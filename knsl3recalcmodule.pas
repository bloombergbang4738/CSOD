unit knsl3recalcmodule;

interface
uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,SyncObjs,stdctrls,comctrls,utltypes,utlconst,inifiles,Db,ADODB
    ,knsl5tracer, Dates,utlbox, utlTimeDate,Parser10,knsl3vmeter,knsl3vparam,utlexparcer,utldatabase,
    knslProgressLoad,knsl3treeloader;
type
     CRcTag = packed record
      m_swVMID        : Integer;
      m_swParamID     : Integer;
      m_sdtTimeF      : TDateTime;
      m_sdtTimeE      : TDateTime;
      m_sdtTime       : TDateTime;
      m_sParamExpress : String[150];
     End;
     LGRAPHTAG  = packed record
      Count           : Integer;
      Items           : array of L3GRAPHDATA;
     End;
     CRclModule = class
     private
      m_swVMID        : Integer;
      m_swABOID       : Integer;
      m_pGR           : SL3GROUPTAG;
      m_nPR           : CEvaluator;
      m_nRCT          : CRcTag;
      m_dwCalc        : DWORD;
      m_swParamID     : Word;
      m_nDT           : CDTRouting;
      m_pData         : L3CURRENTDATA;
      m_pvGraph       : L3GRAPHDATA;
      m_nPType        : TStringList;
      m_bySvType      : Byte;
      m_pGC           : LGRAPHTAG;
      pGI             : PL3GRAPHDATA;
    //  FTreeModuleLoader: PCL3TreeLoader;
  //    FTreeModuleData  : PTTreeView;
      function  FindToken(var str:String;var pTN:CVToken):Boolean;
      function  FindTokenGR(var str:String;var pTN:CVToken):Boolean;
      function  FindTokenCR(var str:String;var pTN:CVToken):Boolean;
      function  GetCheckType(dwCalc:DWord;pVMT:PSL3VMETERTAG):Boolean;
      function  IsParam4(nCMDID:Integer;var nOutCmd:Integer):Boolean;
      function  GetCompareType(nType:Byte):Byte;
      function  CheckTime:Boolean;
      procedure SetCalcSaveTr(nTID:Byte);
      procedure SetCalcSaveCr(nTID:Byte);
      procedure SetCalcSaveGR;
      procedure SetCalcSavePD48;
      procedure SaveDataArch(var pTN:CVToken);
      procedure SaveDataGraph(var pTN:CVToken);
      procedure SaveDataGraphPD48(var pTN:CVToken);
      procedure SaveDataCurr(var pTN:CVToken);
      procedure LoadParamType;
      procedure ReCalc;
      procedure ReCalcCurr;
      function  BlBreakProcess:boolean;
      function  ReturnCRC(m_sfValue:array of double):integer;
      function  FindGI(tmTime:TDateTime;nVMID,nCMD:Integer;var pGI:PL3GRAPHDATA):Boolean;
      function  AddGI(tmTime:TDateTime;nVMID,nCMD:Integer):Boolean;
      procedure FreeGI;
     public
       OnBreak         : boolean;
     public
      procedure Init(pGR:PSL3GROUPTAG);
      procedure OnSetReCalc(nAID,nVMID:Integer;wParamID:Word;dwCalc:DWORD;dtTimeF,dtTimeE:TDateTime);
      procedure OnStartRecalc;
      procedure OnReCalc(dwCalc:DWORD);
      destructor Destroy; override;
     public
    // property PTreeModuleData  :PTTreeView        read FTreeModuleData    write FTreeModuleData;
   //  property PTreeModuleLoader :PCL3TreeLoader   read FTreeModuleLoader  write FTreeModuleLoader;
    //  property PProgress       : PTAdvProgress    read FProgress  write FProgress;
     End;
   var
     m_ngRCL : CRclModule;
const
     RCL_CALCL1 = $001;
     RCL_CALCL2 = $002;
     RCL_CALCL3 = $004;
implementation

destructor CRclModule.Destroy;
begin
  if m_nPR <> nil then FreeAndNil(m_nPR);
  if m_nDT <> nil then FreeAndNil(m_nDT);
  if m_nPType <> nil then FreeAndNil(m_nPType);
  inherited;
end;

procedure CRclModule.Init(pGR:PSL3GROUPTAG);
Begin
     
     m_ngRCL  := self;
     //m_pGR    := pGR;
     m_nPR    := CEvaluator.Create;
//     m_nPR.Init;
     m_nDT    := CDTRouting.Create;
     m_nPType := TStringList.Create;
     OnBreak := false;
     LoadParamType;
     //OnBreak := true;
End;

function CRclModule.FindGI(tmTime:TDateTime;nVMID,nCMD:Integer;var pGI:PL3GRAPHDATA):Boolean;
Var
     i : Integer;
Begin
     Result := False;
     for i:=0 to m_pGC.Count-1 do
     Begin
      with m_pGC.Items[i] do
      Begin
       if (trunc(m_sdtDate)=trunc(tmTime)) and (m_swVMID=nVMID) and (m_swCMDID=nCMD) then
       Begin
        pGI := @m_pGC.Items[i];
        Result := True;
        exit;
       End;
      End;
     End;
End;
function CRclModule.AddGI(tmTime:TDateTime;nVMID,nCMD:Integer):Boolean;
Var
     m_pGrData : L3GRAPHDATAS;
     res       : Boolean;
     i         : Integer;
Begin
     Result := False;
     if m_bySvType=SV_GRPH_ST then  res := m_pDB.GetGraphDatasST(tmTime,tmTime,nVMID,nCMD,m_pGrData);
     if m_bySvType=SV_PDPH_ST then  res := m_pDB.GetGraphDatasPD48(tmTime,tmTime,nVMID,nCMD,m_pGrData);
     Begin
      if res=False then
      Begin
       SetLength(m_pGrData.Items,1);
       m_pGrData.Items[0].m_swVMID  := nVMID;
       m_pGrData.Items[0].m_swCMDID := nCMD;
       m_pGrData.Items[0].m_sdtDate := tmTime;
       for i:=0 to 48-1 do m_pGrData.Items[0].v[i] := 0;
      End;
      m_pGC.Count := m_pGC.Count + 1;
      SetLength(m_pGC.Items,m_pGC.Count);
      move(m_pGrData.Items[0],m_pGC.Items[m_pGC.Count-1],sizeof(L3GRAPHDATA));
      Result := True;
     End;
End;
procedure CRclModule.FreeGI;
Begin
     m_pGC.Count := 0;
     SetLength(m_pGC.Items,m_pGC.Count);
End;
procedure CRclModule.LoadParamType;
Var
     pTbl : QM_PARAMS;
     i    : Integer;
Begin
     if m_pDB.GetParamsTypeTable(pTbl)=True then
     Begin
      for i:=0 to pTbl.Count-1 do
      m_nPType.Add(pTbl.Items[i].m_sEName);
     End;
End;
procedure CRclModule.OnSetReCalc(nAID,nVMID:Integer;wParamID:Word;dwCalc:DWORD;dtTimeF,dtTimeE:TDateTime);
Begin
     m_swABOID         := nAID;
     m_swVMID          := nVMID;
     m_dwCalc          := dwCalc;
     m_swParamID       := wParamID;
     m_bySvType        := 0;
     m_nRCT.m_sdtTimeF := dtTimeF;
     m_nRCT.m_sdtTimeE := dtTimeE;
     if m_pDB.GetVMetersAbonVMidFTable(m_swABOID,m_swVMID,m_pGR)=True then
     OnStartRecalc;
End;
procedure CRclModule.OnStartRecalc;
Begin
     OnReCalc(RCL_CALCL1);
     //if (m_dwCalc and RCL_CALCL1)<>0 then OnReCalc(RCL_CALCL1);
     //if (m_dwCalc and RCL_CALCL2)<>0 then OnReCalc(RCL_CALCL2);
     //if (m_dwCalc and RCL_CALCL3)<>0 then OnReCalc(RCL_CALCL3);
End;

function  CRclModule.BlBreakProcess:boolean;
begin
      Application.ProcessMessages;

      if  (ProgressLoad.OnBreak  = true) then
      begin
       OnBreak  := true;
       ProgressLoad.ProgressBar1.Position:=0;
       ProgressLoad.Close;
       result := true;
      end
      else result := false;
end;

{
  SV_CURR_ST = 0;
  SV_ARCH_ST = 1;
  SV_GRPH_ST = 2;
  SV_PDPH_ST = 3;
}
procedure CRclModule.OnReCalc(dwCalc:Dword);
Var
     i,j,nOutCmd: Integer;
     pVMT : PSL3VMETERTAG;
Begin
     //ProgressLoad.Show;
     //ProgressLoad.ProgressBar1.Position := 0;
     //ProgressLoad.ProgressBar1.max := m_pGR.m_swAmVMeter-1;
     //ProgressLoad.ProgressBar1.Position := i;
  try
     for i:=0 to m_pGR.m_swAmVMeter-1 do
     Begin
     if m_pGR.Item.Items[i].m_sbyEnable=1 then
      Begin
       pVMT := @m_pGR.Item.Items[i];
       if GetCheckType(dwCalc,pVMT)=True then
       Begin
        for j:=pVMT.m_swAmParams-1 DownTo 0 do
        Begin
         m_nRCT.m_swVMID        := pVMT.m_swVMID;
         m_nRCT.m_sParamExpress := pVMT.Item.Items[j].m_sParamExpress;
         m_nRCT.m_swParamID     := pVMT.Item.Items[j].m_swParamID;
         m_bySvType := pVMT.Item.Items[j].m_sblSaved;
          if (IsParam4(m_nRCT.m_swParamID,nOutCmd)=True) then
          Begin
            if (m_bySvType<>SV_CURR_ST) then
            Begin
            if (m_nRCT.m_swParamID>=m_swParamID)and(m_nRCT.m_swParamID<=(m_swParamID+3))         then Begin if pVMT.Item.Items[j].m_sblCalculate=1 then ReCalc;End;
            End else if (m_nRCT.m_swParamID>=m_swParamID)and(m_nRCT.m_swParamID<=(m_swParamID+3))then Begin if pVMT.Item.Items[j].m_sblCalculate=1 then ReCalcCurr;End;
          End else if m_bySvType<>SV_CURR_ST then  Begin if (m_nRCT.m_swParamID=m_swParamID)     then Begin if pVMT.Item.Items[j].m_sblCalculate=1 then ReCalcCurr;End;End;
        End;
       End;
      End;
      End;
   except
      TraceER('(__)CL3MD::>Error In CRclModule.OnReCalcL1!!!');
   end
End;

procedure CRclModule.ReCalcCurr;
Var
     i      : Integer;
     byType : Byte;
Begin
     byType := GetCompareType(m_nRCT.m_swParamID);
     if (byType=1)or(byType=2) then for i:=3 downto 0 do SetCalcSaveCr(i) else
     if byType=3  then SetCalcSaveCr(0);
     m_pDB.CurrentExecute;
     m_pDB.CurrentFlush(m_nRCT.m_swVMID);
End;
procedure CRclModule.ReCalc;
Var
     dtTime : TDateTime;
     i      : Integer;
Begin
     m_nRCT.m_sdtTime := m_nRCT.m_sdtTimeE;
     repeat
      case m_bySvType of
       SV_ARCH_ST:
       Begin
        for i:=3 downto 0 do SetCalcSaveTr(i);
        m_pDB.CurrentExecute;
        m_pDB.CurrentFlush(m_nRCT.m_swVMID);
       End;
       SV_GRPH_ST: SetCalcSaveGR;
       SV_PDPH_ST: SetCalcSavePD48;
      End;
     until CheckTime=False;
End;
procedure CRclModule.SetCalcSaveGR;
Var
     pTN       : CVToken;
     sExpr0    : String;
     i,nCSID   : Integer;
     byValid,byExist,byParST : Byte;
Begin
     //Set
     {
      nCSID    := trunc(frac(Now)/EncodeTime(0,30,0,0))-1;
      sUpdMask := pTable.m_sMaskRead xor sMaskRead;
      if (nCSID>=0)and(trunc(pTable.m_sdtDate)=trunc(Now)) then sUpdMask := sUpdMask or (nM shl nCSID);
     }
     nCSID := 47;
     if (trunc(m_nRCT.m_sdtTime)=trunc(Now)) then
     nCSID := trunc(frac(Now)/EncodeTime(0,30,0,0))-1;

     FreeGI;
     pTN.nTID := 0;
     m_pvGraph.m_sMaskRead   := 0;
     m_pvGraph.m_sMaskReRead := 0;
     for i:=nCSID downto 0 do
     Begin
      byParST := 0;byExist := 0;byValid :=0;
      pTN.nSID := i;
      pTN.sTime:= m_nRCT.m_sdtTime;
      pTN.blIsUpdate := True;
      sExpr0   := m_nRCT.m_sParamExpress+';';
      m_nPR.Expression := m_nRCT.m_sParamExpress;
      while(FindTokenGR(sExpr0,pTN))=True do
      Begin
       m_nPR.Variable[pTN.sPName] := pTN.fValue;
       byExist := byExist or (pTN.m_sbyPrecision and $80);
       byValid := byValid or (pTN.m_sbyPrecision and $40);
       //byIntST := byIntST and pTN.m_sbyPrecision;
       byParST := byParST or (pTN.m_crc and $40);
      End;
      //Calc
      pTN.fValue         := m_nPR.Value;
      //pTN.m_sbyPrecision := byParST or byIntST;
      //pTN.m_sbyPrecision := byIntST;
      pTN.m_sbyPrecision := byExist or byValid;
      //Save
      SaveDataGraph(pTN);
     End;
End;
procedure CRclModule.SetCalcSavePD48;
Var
     pTN   : CVToken;
     sExpr0: String;
     i     : Integer;
Begin
     //Set
     FreeGI;
     pTN.nTID := 0;
     for i:=47 downto 0 do
     Begin
      pTN.nSID := i;
      pTN.sTime:= m_nRCT.m_sdtTime;
      pTN.blIsUpdate := True;
      sExpr0   := m_nRCT.m_sParamExpress+';';
      m_nPR.Expression := m_nRCT.m_sParamExpress;
      while(FindTokenGR(sExpr0,pTN))=True do
      m_nPR.Variable[pTN.sPName] := pTN.fValue;
      //Calc
      pTN.fValue := m_nPR.Value;
      //Save
      SaveDataGraphPD48(pTN);
     End;
End;

procedure CRclModule.SetCalcSaveTr(nTID:Byte);
Var
     pTN   : CVToken;
     sExpr0: String;
     byIntST,byParST : Byte;
Begin
     //Set
     pTN.nTID := nTID;
     m_pData.m_sbyMaskReRead := 0;
     byIntST  := 1;
     byParST  := 1;
     pTN.nSID := 0;
     pTN.sTime:= m_nRCT.m_sdtTime;
     pTN.blIsUpdate := False;
     sExpr0   := m_nRCT.m_sParamExpress+';';
     m_nPR.Expression := m_nRCT.m_sParamExpress;
     while(FindToken(sExpr0,pTN))=True do
     Begin
      m_nPR.Variable[pTN.sPName] := pTN.fValue;
      byIntST := byIntST and pTN.m_sbyPrecision;
      byParST := byParST and pTN.m_crc;
     End;
     //Calc
     pTN.fValue         := m_nPR.Value;
     pTN.m_sbyPrecision := byParST or byIntST;
     //Save
     SaveDataArch(pTN);
End;
procedure CRclModule.SetCalcSaveCr(nTID:Byte);
Var
     pTN   : CVToken;
     sExpr0: String;
Begin
     //Set
     pTN.nTID := nTID;
     pTN.nSID := 0;
     pTN.sTime:= m_nRCT.m_sdtTime;
     pTN.blIsUpdate := False;
     sExpr0   := m_nRCT.m_sParamExpress+';';
     m_nPR.Expression := m_nRCT.m_sParamExpress;
     while(FindTokenCr(sExpr0,pTN))=True do
     m_nPR.Variable[pTN.sPName] := pTN.fValue;
     //Calc
     pTN.fValue := m_nPR.Value;
     //Save
     SaveDataCurr(pTN);
End;

function CRclModule.ReturnCRC(m_sfValue:array of double):integer;
begin
 result := CalcCRCDB(@m_sfValue,length(m_sfValue)*sizeof(double));
end;

procedure CRclModule.SaveDataArch(var pTN:CVToken);
Begin
    // FTreeModuleData.LoadGraph(m_nRCT.m_swVMID);
     m_pData.m_swVMID := m_nRCT.m_swVMID;
     m_pData.m_swCMDID:= m_nRCT.m_swParamID;
     m_pData.m_swTID  := pTN.nTID;
     m_pData.m_sTime  := pTN.sTime;
     m_pData.m_sbyMaskReRead := pTN.m_sbyPrecision;
     m_pData.m_sfValue:= pTN.fValue;
     m_pData.m_CRC    := ReturnCRC(m_pData.m_sfValue);   //������������ crc
     m_pData.m_byInState := DT_FLS;
     m_pDB.SetCurrentParam(m_pData);
     //m_pDB.AddArchData(m_pData);

  //   FTreeModuleData.RefreshTree(m_nRCT.m_swVMID);
End;
procedure CRclModule.SaveDataCurr(var pTN:CVToken);
Begin
  //   FTreeModuleData.LoadGraph(m_nRCT.m_swVMID);
     m_pData.m_swVMID     := m_nRCT.m_swVMID;
     m_pData.m_swCMDID    := m_nRCT.m_swParamID;
     m_pData.m_byOutState := LM_MAX;
     m_pData.m_byInState  := DT_NEW;
     m_pData.m_swTID      := pTN.nTID;
     m_pData.m_sTime      := pTN.sTime;
     m_pData.m_sfValue    := pTN.fValue;
     m_pData.m_CRC        := ReturnCRC(m_pData.m_sfValue);   //������������ crc
     m_pDB.SetCurrentParam(m_pData);
  //   FTreeModuleData.RefreshTree(m_nRCT.m_swVMID);
End;
procedure CRclModule.SaveDataGraph(var pTN:CVToken);
Var
     i : Integer;
Begin
  //   FTreeModuleData.LoadGraph(m_nRCT.m_swVMID);
     m_pvGraph.m_swVMID  := m_nRCT.m_swVMID;
     m_pvGraph.m_swCMDID := m_nRCT.m_swParamID;
     m_pvGraph.m_sdtDate := trunc(pTN.sTime);
     if (pTN.m_sbyPrecision and $80)=0  then SetByteMask(m_pvGraph.m_sMaskRead   , pTN.nSID) else
     if (pTN.m_sbyPrecision and $80)<>0 then RemByteMask(m_pvGraph.m_sMaskRead   , pTN.nSID);
     if (pTN.m_sbyPrecision and $40)=0  then SetByteMask(m_pvGraph.m_sMaskReRead , pTN.nSID) else
     if (pTN.m_sbyPrecision and $40)<>0 then RemByteMask(m_pvGraph.m_sMaskReRead , pTN.nSID);
     {
     if pTN.m_sbyPrecision and =0 then SetByteMask(m_pvGraph.m_sMaskRead, pTN.nSID) else
     if pTN.m_sbyPrecision=0 then RemByteMask(m_pvGraph.m_sMaskRead, pTN.nSID);
     if pTN.m_sbyPrecision=1 then SetByteMask(m_pvGraph.m_sMaskReRead, pTN.nSID) else
     if pTN.m_sbyPrecision=0 then RemByteMask(m_pvGraph.m_sMaskReRead, pTN.nSID);
     }
     if pTN.nSID>=0 then m_pvGraph.v[pTN.nSID] := pTN.fValue;
     if pTN.nSID=0 then
     Begin
      m_pDB.AddGraphData(m_pvGraph);
      for i:=0 to 47 do m_pvGraph.v[i]  :=0;
     End;
  //  FTreeModuleData.RefreshTree(m_nRCT.m_swVMID);
End;
procedure CRclModule.SaveDataGraphPD48(var pTN:CVToken);
Var
     i : Integer;
Begin
  //   FTreeModuleData.LoadGraph(m_nRCT.m_swVMID);
     m_pvGraph.m_swVMID  := m_nRCT.m_swVMID;
     m_pvGraph.m_swCMDID := m_nRCT.m_swParamID;
     m_pvGraph.m_sdtDate := trunc(pTN.sTime);
     SetByteMask(m_pvGraph.m_sMaskRead, pTN.nSID);
     if pTN.nSID>=0 then m_pvGraph.v[pTN.nSID] := pTN.fValue;
     if pTN.nSID=0 then
     Begin
      m_pDB.AddPDTData_48(m_pvGraph);
      for i:=0 to 47 do m_pvGraph.v[i]  :=0;
     End;
  //  FTreeModuleData.RefreshTree(m_nRCT.m_swVMID);
End;
function CRclModule.FindToken(var str:String;var pTN:CVToken):Boolean;
Var
     res   : Boolean;
     i,j,k,n,km : Integer;
     sV,sP : String;
     nVMID : Integer;
     pData : L3CURRENTDATA;
Begin
     Result := False;
     //Find VMID
     i := Pos('v',str)+1;
     if i=1 then exit;
     if i>2 then Begin Delete(str,1,i-2);i:=Pos('v',str)+1;End;
     j := Pos('_',str);
     if j<=i then Begin pTN.blError:=True;exit;End;
     sV := Copy(str,i,j-i);
     nVMID := StrToInt(sV);
     //Find CMD
     km := 100;
     for n:=0 to 7 do
     Begin
      k:=Pos(chEndTn[n],str);
      if (k<=km) and (k<>0) then km:=k;
     End;
     if km>=j then sP:=Copy(str,j+1,km-(j+1));
     if km=100 then Begin pTN.blError:=True;exit;End;
     //Extract Value
     if sP<>'' then
     Begin
      pTN.blError:=False;
      pData.m_swVMID  := nVMID;
      pData.m_swCMDID := m_nPType.IndexOf(sP);
      pData.m_swTID   := pTN.nTID;
      pData.m_sTime   := pTN.sTime;
      pData.m_sfValue := 0;
      m_pDB.GetGRData(pData);

      pTN.fValue         := pData.m_sfValue;
      pTN.m_sbyPrecision := pData.m_sbyMaskReRead;
      pTN.m_CRC          := pData.m_CRC;
      pTN.sPName         := Copy(str,i-1,km-(i-1));

      Delete(str,i-1,(km+1)-(i-1));
      Result := True;
     End;
End;
function CRclModule.FindTokenCr(var str:String;var pTN:CVToken):Boolean;
Var
     res   : Boolean;
     i,j,k,n,km : Integer;
     sV,sP : String;
     nVMID : Integer;
     pData : L3CURRENTDATA;
     byType: Byte;
Begin
     Result := False;
     //Find VMID
     i := Pos('v',str)+1;
     if i=1 then exit;
     if i>2 then Begin Delete(str,1,i-2);i:=Pos('v',str)+1;End;
     j := Pos('_',str);
     if j<=i then Begin pTN.blError:=True;exit;End;
     sV := Copy(str,i,j-i);
     nVMID := StrToInt(sV);
     //Find CMD
     km := 100;
     for n:=0 to 7 do
     Begin
      k:=Pos(chEndTn[n],str);
      if (k<=km) and (k<>0) then km:=k;
     End;
     if km>=j then sP:=Copy(str,j+1,km-(j+1));
     if km=100 then Begin pTN.blError:=True;exit;End;
     //Extract Value
     if sP<>'' then
     Begin
      pTN.blError:=False;
      pData.m_swVMID  := nVMID;
      pData.m_swCMDID := m_nPType.IndexOf(sP);
      pData.m_swTID   := pTN.nTID;
      pData.m_sTime   := pTN.sTime;
      pData.m_sfValue := 0;
      byType          := GetCompareType(pData.m_swCMDID);
      if (byType<>3) then m_pDB.GetCRDataT(pData) else
      if (byType=3)  then m_pDB.GetCRData(pData);
      pTN.fValue := pData.m_sfValue;
      pTN.sTime  := pData.m_sTime;
      pTN.sPName := Copy(str,i-1,km-(i-1));
      Delete(str,i-1,(km+1)-(i-1));
      Result := True;
     End;
End;
function CRclModule.FindTokenGR(var str:String;var pTN:CVToken):Boolean;
Var
     res   : Boolean;
     i,j,k,n,km : Integer;
     sV,sP : String;
     nVMID,swCMDID : Integer;
     nM : int64;
     //m_pGrData     : L3GRAPHDATAS;
     //pGI   : PL3GRAPHDATA;
Begin
     Result := False;
     //Find VMID
     nM := 1;
     i := Pos('v',str)+1;
     if i=1 then exit;
     if i>2 then Begin Delete(str,1,i-2);i:=Pos('v',str)+1;End;
     j := Pos('_',str);
     if j<=i then Begin pTN.blError:=True;exit;End;
     sV := Copy(str,i,j-i);
     nVMID := StrToInt(sV);
     //Find CMD
     km := 100;
     for n:=0 to 7 do
     Begin
      k:=Pos(chEndTn[n],str);
      if (k<=km) and (k<>0) then km:=k;
     End;
     if km>=j then sP:=Copy(str,j+1,km-(j+1));
     if km=100 then Begin pTN.blError:=True;exit;End;
     //Extract Value
     if sP<>'' then
     Begin
      pTN.blError:=False;
      swCMDID    := m_nPType.IndexOf(sP);
      pTN.fValue := 0;
      if FindGI(pTN.sTime,nVMID,swCMDID,pGI)=True then pTN.fValue := pGI.v[pTN.nSID] else
      Begin
       AddGI(pTN.sTime,nVMID,swCMDID);
       if FindGI(pTN.sTime,nVMID,swCMDID,pGI)=True then pTN.fValue := pGI.v[pTN.nSID]
      End;
      pTN.m_crc := 0;
      pTN.m_sbyPrecision := $00;
      if pGI.m_crc=0 then pTN.m_crc := $40;//���������� ��������� � ����������
      if (pGI.m_sMaskReRead and (nM shl pTN.nSID))=0 then pTN.m_sbyPrecision := pTN.m_sbyPrecision or $40; //���������� ������
      if (pGI.m_sMaskRead   and (nM shl pTN.nSID))=0 then pTN.m_sbyPrecision := pTN.m_sbyPrecision or $80;
      pTN.sPName := Copy(str,i-1,km-(i-1));
      Delete(str,i-1,(km+1)-(i-1));
      Result := True;
     End;
End;
function CRclModule.CheckTime:Boolean;
Begin
     Result := True;
     try
     with m_nRCT do
     Begin
      if GetCompareType(m_swParamID)=1 then
      Begin
       if trunc(m_sdtTime)=trunc(m_sdtTimeF) then Result := False else
       m_sdtTime := m_sdtTime + 1;
      End else
      if GetCompareType(m_swParamID)=2 then
      Begin
        if m_nDT.CompareMonth(m_sdtTime,m_sdtTimeF)=0 then Result := False else
        m_nDT.IncMonth(m_sdtTime);
      End else Result := False;
     End;
     except
      TraceER('(__)CL3MD::>Error In CRclModule.CheckTime!!!');
     end;
End;
function CRclModule.GetCompareType(nType:Byte):Byte;
Begin
     case nType of
      QRY_ENERGY_DAY_EP   ,QRY_ENERGY_DAY_EM   ,QRY_ENERGY_DAY_RP   ,QRY_ENERGY_DAY_RM,
      QRY_NAK_EN_DAY_EP   ,QRY_NAK_EN_DAY_EM   ,QRY_NAK_EN_DAY_RP   ,QRY_NAK_EN_DAY_RM,
      QRY_SRES_ENR_EP     ,QRY_SRES_ENR_EM     ,QRY_SRES_ENR_RP     ,QRY_SRES_ENR_RM   : Result := 1;
      QRY_MAX_POWER_EP    ,QRY_MAX_POWER_EM    ,QRY_MAX_POWER_RP    ,QRY_MAX_POWER_RM,
      QRY_NAK_EN_MONTH_EP ,QRY_NAK_EN_MONTH_EM ,QRY_NAK_EN_MONTH_RP ,QRY_NAK_EN_MONTH_RM ,
      QRY_ENERGY_MON_EP   ,QRY_ENERGY_MON_EM   ,QRY_ENERGY_MON_RP   ,QRY_ENERGY_MON_RM : Result := 2;
      QRY_U_PARAM_S       ,QRY_U_PARAM_A       ,QRY_U_PARAM_B       ,QRY_U_PARAM_C,
      QRY_I_PARAM_S       ,QRY_I_PARAM_A       ,QRY_I_PARAM_B       ,QRY_I_PARAM_C,
      QRY_MGAKT_POW_S     ,QRY_MGAKT_POW_A     ,QRY_MGAKT_POW_B     ,QRY_MGAKT_POW_C,
      QRY_MGREA_POW_S     ,QRY_MGREA_POW_A     ,QRY_MGREA_POW_B     ,QRY_MGREA_POW_C   : Result := 3;
      else
      Result := 0;
     End;
End;
function CRclModule.GetCheckType(dwCalc:DWord;pVMT:PSL3VMETERTAG):Boolean;
Var
     r0,r1,r2:Boolean;
Begin
     Result := False;
     {
     case dwCalc of
          RCL_CALCL1:
          Begin
           if ((m_dwCalc and RCL_CALCL1)<>0)and(m_swVMID=-1) then
           Result := not((pVMT.m_sbyType=MET_SUMM)or(pVMT.m_sbyType=MET_GSUMM)) else
           if ((m_dwCalc and RCL_CALCL1)<>0)and(m_swVMID<>-1) then
           Result := pVMT.m_swVMID=m_swVMID;
          End;
          RCL_CALCL2:
          Begin
           if ((m_dwCalc and RCL_CALCL2)<>0)and(m_swVMID=-1) then
           Result := (pVMT.m_sbyType=MET_SUMM) else
           if ((m_dwCalc and RCL_CALCL2)<>0)and(m_swVMID<>-1) then
           Result := pVMT.m_swVMID=m_swVMID;
          End;
          RCL_CALCL3:
          Begin
           if ((m_dwCalc and RCL_CALCL3)<>0)and(m_swVMID=-1) then
           Result := (pVMT.m_sbyType=MET_GSUMM) else
           if ((m_dwCalc and RCL_CALCL3)<>0)and(m_swVMID<>-1) then
           Result := pVMT.m_swVMID=m_swVMID;
          End;
     End;
     }
     Result := pVMT.m_swVMID=m_swVMID;
End;
function CRclModule.IsParam4(nCMDID:Integer;var nOutCmd:Integer):Boolean;
Begin
     Result:=False;
     case nCMDID of
          QRY_ENERGY_DAY_EP,QRY_ENERGY_DAY_EM,QRY_ENERGY_DAY_RP,QRY_ENERGY_DAY_RM:Begin nOutCmd:=QRY_ENERGY_DAY_EP; Result:=True;End;
          QRY_ENERGY_MON_EP,QRY_ENERGY_MON_EM,QRY_ENERGY_MON_RP,QRY_ENERGY_MON_RM:Begin nOutCmd:=QRY_ENERGY_MON_EP; Result:=True;End;
          QRY_NAK_EN_DAY_EP,QRY_NAK_EN_DAY_EM,QRY_NAK_EN_DAY_RP,QRY_NAK_EN_DAY_RM:Begin nOutCmd:=QRY_NAK_EN_DAY_EP; Result:=True;End;
          QRY_NAK_EN_MONTH_EP,QRY_NAK_EN_MONTH_EM,QRY_NAK_EN_MONTH_RP,QRY_NAK_EN_MONTH_RM:Begin nOutCmd:=QRY_NAK_EN_MONTH_EP; Result:=True;End;
          QRY_SRES_ENR_EP,QRY_SRES_ENR_EM,QRY_SRES_ENR_RP,QRY_SRES_ENR_RM        :Begin nOutCmd:=QRY_SRES_ENR_EP;   Result:=True;End;
          QRY_MGAKT_POW_S,QRY_MGAKT_POW_A,QRY_MGAKT_POW_B,QRY_MGAKT_POW_C        :Begin nOutCmd:=QRY_MGAKT_POW_S;   Result:=True;End;
          QRY_MGREA_POW_S,QRY_MGREA_POW_A,QRY_MGREA_POW_B,QRY_MGREA_POW_C        :Begin nOutCmd:=QRY_MGREA_POW_S;   Result:=True;End;
          QRY_U_PARAM_S,QRY_U_PARAM_A,QRY_U_PARAM_B,QRY_U_PARAM_C                :Begin nOutCmd:=QRY_U_PARAM_S;     Result:=True;End;
          QRY_I_PARAM_S,QRY_I_PARAM_A,QRY_I_PARAM_B,QRY_I_PARAM_C                :Begin nOutCmd:=QRY_I_PARAM_S;     Result:=True;End;
     End;
End;
end.

