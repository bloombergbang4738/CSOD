unit knsl2qweryserver;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer,
 knsl3EventBox,knsl2qweryvmeter,utldatabase,knsl3datamatrix,knsl3jointable,knsl3HolesFinder,knsl2qwerybitserver;
type
    {
    SQWCLSS = packed record
     Count : Integer;
     Items : array[0..MAX_GCLUSTER] of CQweryClusters;
    End;
    }
    CQweryServer = class
    protected
     m_lQVM  : TList;
     m_sName : String;
     m_pMX   : PCDataMatrix;
     m_pDDB  : Pointer;
     m_nHF   : CHolesFinder;
     m_nJN   : CJoinTable;
     m_sbyEnable : Byte;
     function Find(snCLID:Integer):PCQweryVMeter;
     //procedure UpdateIsExists(snVMID,snPrmID:Integer;sdtBegin,sdtEnd:TDateTime);
     function IsExists(snVMID:Integer):Boolean;
     procedure OnCalc(snCLSID,snPrmID:Integer);
     function FreeCmdState(snCLSID,snPrmID:Integer):Boolean;
     function CheckCalc(snCLSID,snPrmID:Integer):Boolean;
     function CheckFind(snCLSID,snPrmID:Integer):Boolean;
     function GetSummBuffer(snCLSID,snPrmID:Integer;var nDT:SHALLSDATES):Boolean;
     procedure CreateJoinTable(pTbl:SQWERYVM);
     procedure CreateEntasJoin(snMID:Integer);
     procedure SendCalcLabel;
    public
     m_nSRVID : Integer;
     m_nPID   : Integer;
     m_blIsProced : Boolean;
     m_blIsError : Boolean;
     m_nSrvWarning : Integer;
     m_nSrvErrors : Integer;
     constructor Create(pDDB:Pointer;pMX:PCDataMatrix;nSRVID,nSrvWarn,sbyEnable:Integer);
     destructor Destroy;override;
     function  Add(snCLID,snVMID,snPID:Integer):PCQweryVMeter;
     procedure HandQwerySrv(snCLID,snCLSID,snPrmID:Integer);
     procedure UpdateDataSrv(snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
     procedure FindDataSrv(snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
     procedure StartFindPrg(snCLID,snCLSID,snPrmID:Integer;var nDT:SHALLSDATES);
     procedure StopQwerySrv(snCLID:Integer;byCause:Byte);
     procedure SendErrorL2(snCLID,snCLSID,snPrmID:Integer);
     procedure OnEndQwery(snCLID,snCLSID,snPrmID:Integer);
     procedure SetCmdState(snCLID,snCLSID,snPrmID:Integer);
     function  CheckFindState(snCLSID,snPrmID:Integer):Boolean;
     procedure ClearJobsCase(snPortID:Integer);
     procedure SetSrvError;
     procedure FindDataSrvCaseEr(snPortID:Integer);
     procedure Init(var pTbl:SQWERYVMS);
     procedure Delete(snCLID:Integer);
     procedure Run;
    End;
    PCQweryServer =^ CQweryServer;
    CQweryServers = class
    protected
     m_lQSV : TList;
     m_pMX  : PCDataMatrix;
     m_pDDB : Pointer;
     m_nOldTime : TDateTime;
     m_blIsBlack: Boolean;
     procedure SendErrorL2(snSRVID,snCLID,snCLSID,snPrmID:Integer);
     function  Find(snSRVID:Integer):PCQweryServer;
     procedure Delete(snSRVID:Integer);
     function  Add(snSRVID,nSrvWarn,sbyEnable:Integer):PCQweryServer;
     procedure InitSrv(snABOID,snSRVID:Integer);
     procedure Init;
     procedure HandQwerySrv(snSRVID,snCLID,snCLSID,snPrmID:Integer);
     procedure UpdateDataSrv(snSRVID,snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
     procedure FindDataSrv(snSRVID,snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
     procedure FindDataSrvCaseEr(snABOID,snSRVID,snPrmID:Integer);
     function  IsNotInBlackList(snSRVID:Integer):Boolean;
     procedure ClearJobsCase(snSRVID,snPortID:Integer);
     procedure StopQwerySrv(snSRVID:Integer;byCause:Byte);
     procedure StopQwerySrv1(snSRVID:Integer;byCause:Byte);
     procedure ClearQweryLevel(snSRVID:Integer;byCause:Byte);
     procedure ClearBlackList;
     procedure FindIsExists(snVMID,snPrmID:Integer;sdtBegin,sdtEnd:TDateTime);
     procedure UpdateIsExists(snVMID,snPrmID:Integer;sdtBegin,sdtEnd:TDateTime);
     procedure FreeIsExists(snVMID:Integer;byCause:Byte);
     procedure SendStopLabel;
     procedure SendCalcLabel;
     procedure SendStartLabel;
     procedure OpenBlackList;
    public
     m_strBlackList : TStringList;
     constructor Create(pMX:PCDataMatrix;pMDB:Pointer);
     destructor Destroy;override;
     function  EventHandler(var pMsg:CMessage):Boolean;
     procedure Run;
     procedure OnEndQwery(snSRVID,snCLID,snCLSID,snPrmID:Integer);
     procedure SetCmdState(snSRVID,snCLID,snCLSID,snPrmID:Integer);
     procedure CheckFindState(snSRVID,snCLID,snCLSID,snPrmID:Integer);

    End;
implementation
//CQweryServer
constructor CQweryServer.Create(pDDB:Pointer;pMX:PCDataMatrix;nSRVID,nSrvWarn,sbyEnable:Integer);
Begin
    m_pMX    := pMX;
    m_pDDB   := pDDB;
    m_nSRVID := nSRVID;
    m_nSrvWarning := nSrvWarn;
    m_nSrvErrors  := 0;
    m_sbyEnable   := sbyEnable;
    m_blIsError   := False;
    m_nJN    := CJoinTable.Create(m_pMX);
    m_lQVM   := TList.Create;
    m_nHF    := CHolesFinder.Create(m_pDDB);
End;
destructor CQweryServer.Destroy;
Begin
    Delete(-1);
    FreeAndNil(m_nHF);
    FreeAndNil(m_lQVM);
    FreeAndNil(m_nJN);
End;
procedure CQweryServer.Init(var pTbl:SQWERYVMS);
Var
    i  : Integer;
    pV : PCQweryVMeter;
Begin
    Delete(-1);
    m_nJN.FreeLMX;
    for i:=0 to pTbl.Count-1 do
    Begin
     pV := Add(pTbl.Items[i].m_snCLID,pTbl.Items[i].m_snVMID,pTbl.Items[i].m_snPID);
     pV.Init(pTbl.Items[i].Item);
     CreateJoinTable(pTbl.Items[i]);
    End;
End;
procedure CQweryServer.CreateJoinTable(pTbl:SQWERYVM);
Begin
     case pTbl.m_snTPID of
          MET_ENTASNET : CreateEntasJoin(pTbl.m_snMID);
     else
          m_nJN.AddTopLMatrix(pTbl.m_snVMID,QRY_SRES_ENR_EP)
     End;
End;
procedure CQweryServer.CreateEntasJoin(snMID:Integer);
Var
    i : Integer;
    pTbl:SQWERYVMS;
Begin
    if m_pDB.GetEntasJoin(snMID,pTbl)=True then
    for i:=0 to pTbl.Count-1 do
    m_nJN.AddTopLMatrix(pTbl.Items[i].m_snVMID,QRY_SRES_ENR_EP);
End;
function CQweryServer.Add(snCLID,snVMID,snPID:Integer):PCQweryVMeter;
Var
    pV : PCQweryVMeter;
Begin
    if Find(snCLID)<>Nil then exit;
    New(pV);
    pV^ := CQweryVMeter.Create(CheckFindState,m_pDDB,snCLID,snVMID,snPID);
    m_lQVM.Add(pV);
    Result := pV;
End;
function CQweryServer.Find(snCLID:Integer):PCQweryVMeter;
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    Result := Nil;
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     if pV.m_snCLID=snCLID then
     Begin
      Result := pV;
      exit;
     End;
    End;
End;
Function CQweryServer.IsExists(snVMID:Integer):Boolean;
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    Result := False;
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     if (pV.m_snVMID=snVMID)or(snVMID=-1) then
     Begin
      //pV.UpdateIsExists(sdtBegin,sdtEnd,snPrmID);
      Result := True;
      exit;
     End;
    End;
End;
procedure CQweryServer.HandQwerySrv(snCLID,snCLSID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if m_sbyEnable=0 then exit;
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.HandQweryCluster(snCLSID,snPrmID);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.HandQweryCluster(snCLSID,snPrmID);
    End;
End;
procedure CQweryServer.StopQwerySrv(snCLID:Integer;byCause:Byte);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.StopAllCluster(byCause);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.StopAllCluster(byCause);
    End;
End;
procedure CQweryServer.ClearJobsCase(snPortID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    EventBox.FixEvents(ET_RELEASE,'������� � �������� ��������� ������� �: '+GetSRVNAME(m_nSRVID)+' ���� �:'+IntToStr(snPortID));
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     if pV.m_snPID=snPortID then
     pV.SendErrorL2(-1,-1);
    End;
End;
procedure CQweryServer.SetSrvError;
Begin
     if (m_nSrvErrors>=(m_nSrvWarning-1))or(m_nSrvWarning=0) then
     Begin
      m_blIsError  := True;
      EventBox.FixEvents(ET_CRITICAL,'������: '+GetSRVNAME(m_nSRVID)+' ������� � ������ ������!!!');
     End else
     Begin
      m_nSrvErrors := m_nSrvErrors + 1;
      EventBox.FixEvents(ET_CRITICAL,'������: '+GetSRVNAME(m_nSRVID)+' ������� �������������� �:'+IntToStr(m_nSrvErrors)+' �� '+IntToStr(m_nSrvWarning)+' !');
     End;
End;
procedure CQweryServer.FindDataSrvCaseEr(snPortID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if m_sbyEnable=0 then
    Begin
     EventBox.FixEvents(ET_CRITICAL,'Error.CQweryServer.FindDataSrvCaseEr.������:'+GetSRVNAME(m_nSRVID)+' ���� �:'+IntToStr(snPortID)+' ������������!!!');
     exit;
    End;
    EventBox.FixEvents(ET_RELEASE,'��������� ����� ������ �� ������� �:'+GetSRVNAME(m_nSRVID)+' ���� �:'+IntToStr(snPortID));
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     if (pV.m_snPID=snPortID) then
     pV.FindCluster(-1,Now,Now,-1,AL_ER_DIAL);
    End;
End;
procedure CQweryServer.SendErrorL2(snCLID,snCLSID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.SendErrorL2(snCLSID,snPrmID);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.SendErrorL2(snCLSID,snPrmID);
    End;
End;
procedure CQweryServer.OnEndQwery(snCLID,snCLSID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.OnEndQwery(snCLSID,snPrmID);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.OnEndQwery(snCLSID,snPrmID);
    End;
End;
function CQweryServer.CheckCalc(snCLSID,snPrmID:Integer):Boolean;
Var
    i   : Integer;
    pV  : PCQweryVMeter;
    Res : Boolean;
Begin
    Res := True;
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV  := m_lQVM.Items[i];
     if pV.IsExists(snCLSID,snPrmID)=True then
     Res := Res and pV.IsComplette(snCLSID,snPrmID);
    End;
    Result := Res;
End;
procedure CQweryServer.SetCmdState(snCLID,snCLSID,snPrmID:Integer);
Var
    pV : PCQweryVMeter;
Begin
    pV := Find(snCLID);
    if pV<>Nil then
    Begin
     pV.SetCmdState(snCLSID,snPrmID);
     if CheckCalc(snCLSID,snPrmID)=True then
     Begin
      //SendMSG(BOX_L4,0,DIR_L1TOL4,QL_STOP_TRANS_REQ);
       SendCalcLabel;
       OnCalc(snCLSID,snPrmID);
      //SendMSG(BOX_L4,0,DIR_L1TOL4,QL_START_TRANS_REQ);
     End;
    End;
End;
procedure CQweryServer.SendCalcLabel;
Var
    pDS  : CMessageData;
    dtTM : TDateTime;
Begin
    dtTM := Now;
    Move(dtTM,pDS.m_sbyInfo[0],sizeof(dtTM));
    SendRSMsgM(CreateMSGD(BOX_L3,0,DIR_LHTOLMC,NL_STARTCLEX_REQ,pDS));
    SendMsgData(BOX_L3_LME,0,DIR_L3TOLME,NL_STARTCLEX_REQ,pDS);
End;
function CQweryServer.CheckFindState(snCLSID,snPrmID:Integer):Boolean;
Var
    nDT : SHALLSDATES;
Begin
    Result := False;
    if m_blIsError=True then EventBox.FixEvents(ET_CRITICAL,'������ �: '+GetSRVNAME(m_nSRVID)+' � ������ ������ �� ��������� �����!') else
    if CheckFind(snCLSID,snPrmID)=True then
    Begin
     if IsDb(0)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServer.CheckFind=True. ������ �: '+GetSRVNAME(m_nSRVID)+'CL'+GetCLSID(snCLSID));
     if GetSummBuffer(snCLSID,snPrmID,nDT)=True then
     Begin
      if IsDb(0)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServer.GetSummBuffer=True. ������ �: '+GetSRVNAME(m_nSRVID)+'CL'+GetCLSID(snCLSID));
      StartFindPrg(-1,snCLSID,snPrmID,nDT);
      //m_blIsProced := True;
      Result := True;
     End;
    End;
End;
function CQweryServer.GetSummBuffer(snCLSID,snPrmID:Integer;var nDT:SHALLSDATES):Boolean;
Var
    i   : Integer;
    pV  : PCQweryVMeter;
Begin
    Result := False;
    m_nHF.InitFinder;
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     if IsDb(0)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!if pV.GetFindBuffer. ������ �: '+GetVMName(pV.m_snVMID)+'CL'+GetCLSID(snCLSID));
     if pV.GetFindBuffer(snCLSID,snPrmID,nDT)=True then
     Begin
      if IsDb(0)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!if pV.GetFindBuffer=True. ������ �: '+GetVMName(pV.m_snVMID)+'CL'+GetCLSID(snCLSID));
      m_nHF.AddToBuffer(nDT);
      Result := True;
     End;
    End;
    m_nHF.GetBuffer(nDT);
    m_nHF.FreeFinder;
End;
function CQweryServer.CheckFind(snCLSID,snPrmID:Integer):Boolean;
Var
    i   : Integer;
    pV  : PCQweryVMeter;
    Res : Boolean;
Begin
    Res := True;
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV  := m_lQVM.Items[i];
     if pV.IsExists(snCLSID,snPrmID)=True then
     Res := Res and pV.IsFind(snCLSID,snPrmID);
    End;
    Result := Res;
End;
function CQweryServer.FreeCmdState(snCLSID,snPrmID:Integer):Boolean;
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.FreeCmdState(snCLSID,snPrmID);
    End;
End;
procedure CQweryServer.OnCalc(snCLSID,snPrmID:Integer);
Var
    i,nData : Integer;
    pMsg : CMessage;
Begin
    With pMsg,m_nJN.m_pQSMD do
    Begin
     m_swLen        := 11 + 2*Count;
     m_swObjID      := Count;
     m_sbyFor       := DIR_QSTOCS;
     m_sbyType      := CSRV_START_CALC;
     m_sbyDirID     := snPrmID;
     m_sbyServerID  := m_nSRVID;
     m_sbyTypeIntID := snCLSID;
     for i:=0 to Count-1 do
     Begin
      nData := Items[i];
      Move(nData,m_sbyInfo[2*i],2);
     End;
     if Count<>0 then
     //FPUT(BOX_CSRV,@pMsg);
    end;
End;
procedure CQweryServer.UpdateDataSrv(snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if m_sbyEnable=0 then exit;
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.UpdateCluster(snCLSID,sdtBegin,sdtEnd,snPrmID);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.UpdateCluster(snCLSID,sdtBegin,sdtEnd,snPrmID);
    End;
End;
procedure CQweryServer.FindDataSrv(snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if m_sbyEnable=0 then
    Begin
     EventBox.FixEvents(ET_CRITICAL,'Error.CQweryServer.FindDataSrv.������:'+GetSRVNAME(m_nSRVID)+' ������������!!!');
     exit;
    End;
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.FindCluster(snCLSID,sdtBegin,sdtEnd,snPrmID,0);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.FindCluster(snCLSID,sdtBegin,sdtEnd,snPrmID,0);
    End;
End;
procedure CQweryServer.StartFindPrg(snCLID,snCLSID,snPrmID:Integer;var nDT:SHALLSDATES);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then pV.StartFindPrg(snCLSID,snPrmID,nDT);
    End else if snCLID=-1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
      pV := m_lQVM.Items[i];
      pV.StartFindPrg(snCLSID,snPrmID,nDT);
    End;
End;
procedure CQweryServer.Delete(snCLID:Integer);
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if snCLID<>-1 then
    Begin
     pV := Find(snCLID);
     if pV<>Nil then
     Begin
      pV.Free;
      Dispose(pV);
      m_lQVM.Delete(m_lQVM.IndexOf(pV));
     End;
    End else
    if snCLID=-1 then
    Begin
     for i:=0 to m_lQVM.Count-1 do
     Begin
      pV := m_lQVM.Items[i];
      if pV<>Nil then begin
        pV.Free;
        Dispose(pV);
      end;
     End;
     m_lQVM.Clear;
    End;
End;
procedure CQweryServer.Run;
Var
    i : Integer;
    pV : PCQweryVMeter;
Begin
    if m_sbyEnable=1 then
    for i:=0 to m_lQVM.Count-1 do
    Begin
     pV := m_lQVM.Items[i];
     pV.Run;
    End;
End;
//CQweryServers
constructor CQweryServers.Create(pMX:PCDataMatrix;pMDB:Pointer);
Begin
    m_pMX := pMX;
    m_pDDB := pMDB;
    //server := CQweryBytServer.Create(m_pMX,0,2);
    {m_lQSV := TList.Create;

    if m_nSrvName=Nil then m_nSrvName := TStringList.Create;
    Init;
    m_strBlackList := TStringList.Create;
    m_blIsBlack    := False;
    m_nOldTime     := Now;}
End;
destructor CQweryServers.Destroy;
Begin
    Delete(-1);
    if m_lQSV <> nil then FreeAndNil(m_lQSV);
    if m_strBlackList <> nil then FreeAndNil(m_strBlackList);
    if m_nSrvName<>Nil then FreeAndNil(m_nSrvName);
    inherited;
End;
{
procedure CL3LmeModule.CreateQSRVMSG(var pMsg:CMessage);
Var
     pDS  : CMessageData;
     sQC  : SQWERYCMDID;
     szDT : Integer;
     wFind,wLocal:Word;
Begin
     Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
     szDT := sizeof(TDateTime);
     sQC.m_snABOID := -1;
     sQC.m_snSRVID := -1;
     sQC.m_snCLID  := -1;
     sQC.m_snCLSID := -1;
     sQC.m_snVMID  := -1;
     sQC.m_snMID   := -1;
     sQC.m_snPrmID := pDS.m_swData1;
     Move(pDS.m_sbyInfo[0]   ,sQC.m_sdtBegin ,szDT);
     Move(pDS.m_sbyInfo[szDT],sQC.m_sdtEnd   ,szDT);
     if LoWord(pDS.m_swData3)=MTR_LOCAL  then sQC.m_snVMID  := pDS.m_swData0;
     if LoWord(pDS.m_swData3)=MTR_REMOTE then sQC.m_snMID   := pDS.m_swData0;
     if HiWord(pDS.m_swData3)=0          then sQC.m_snCmdID := QS_UPDT_AL;
     if HiWord(pDS.m_swData3)=1          then sQC.m_snCmdID := QS_FIND_AL;
     Move(sQC,pDS.m_sbyInfo[0],sizeof(SQWERYCMDID));
     SendMsgData(BOX_L3_LME,0,DIR_LHTOLM3,QL_QWERYROUT_REQ,pDS);
End;
}
function CQweryServers.EventHandler(var pMsg:CMessage):Boolean;
Var
     pDS : CMessageData;
     sQC : SQWERYCMDID;

Begin
     Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
     Move(pDS.m_sbyInfo[0] ,sQC,sizeof(SQWERYCMDID));
     with sQC do
     case m_snCmdID of
          QS_INIT_SR : InitSrv(m_snABOID,m_snSRVID);
          QS_HQWR_SR : HandQwerySrv(m_snSRVID,m_snCLID,m_snCLSID,m_snPrmID);
          QS_UPDT_SR : UpdateDataSrv(m_snSRVID,m_snCLID,m_snCLSID,m_sdtBegin,m_sdtEnd,m_snPrmID);
          //QS_UPDT_SR : server.load(m_sdtBegin,m_sdtEnd,m_snPrmID);
          QS_FIND_SR : FindDataSrv(m_snSRVID,m_snCLID,m_snCLSID,m_sdtBegin,m_sdtEnd,m_snPrmID);
          QS_FIND_AP : FindDataSrvCaseEr(m_snABOID,m_snSRVID,m_snPrmID);  //ClearDMX(snAID,-1,snPrmID);
          QS_STOP_SR : StopQwerySrv(m_snSRVID,0);
          QS_STP1_SR : StopQwerySrv1(m_snSRVID,0);
          //QS_ERL2_SR : if pMsg.m_swObjID=EVA_METER_NO_ANSWER then
          //             SendErrorL2(m_snSRVID,m_snCLID,-1,-1);
                       //SendErrorL2(m_snSRVID,-1,m_snCLSID,m_snPrmID);
          QS_CLER_BL : m_strBlackList.Clear;
          QS_FIND_AL : FindIsExists(m_snVMID,m_snPrmID,m_sdtBegin,m_sdtEnd);
          QS_UPDT_AL : UpdateIsExists(m_snVMID,m_snPrmID,m_sdtBegin,m_sdtEnd);
          QS_FREE_AL : FreeIsExists(m_snVMID,1);
     End;
End;

function CQweryServers.Find(snSRVID:Integer):PCQweryServer;
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    Result := Nil;
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.m_nSRVID=snSRVID then
     Begin
      Result := pV;
      exit;
     End;
    End;
End;
procedure CQweryServers.Delete(snSRVID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
  if m_lQSV = nil then Exit;
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     if pV<>Nil then
     Begin
      pV.Free;
      Dispose(pV);
      m_lQSV.Delete(m_lQSV.IndexOf(pV));
     End;
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      pV.Free;
      Dispose(pV);
     End;
     m_lQSV.Clear;
    End;
End;
procedure CQweryServers.InitSrv(snABOID,snSRVID:Integer);
Var
    i    : Integer;
    pV   : PCQweryServer;
    pTbl : SQWERYSRVS;
Begin
    //Delete(-1);
    //if m_pDB.GetQweryFullSRVTable(snABOID,snSRVID,-1,pTbl)=True then
    if m_pDB.GetQweryFullSRVTable(snABOID,snSRVID,-1,pTbl)=True then
    Begin
     for i:=0 to pTbl.Count-1 do
     Begin
      Delete(pTbl.Items[i].m_snSRVID);
      pV := Add(pTbl.Items[i].m_snSRVID,pTbl.Items[i].m_nSrvWarning,pTbl.Items[i].m_sbyEnable);
      pV.Init(pTbl.Items[i].Item);
      if (snABOID=-1)and(snSRVID=-1)then
      m_nSrvName.Add('('+IntToStr(pTbl.Items[i].m_snSRVID)+')'+pTbl.Items[i].m_sName);
     End;
    End;
End;
procedure CQweryServers.Init;
Begin
    InitSrv(-1,-1);
End;
function CQweryServers.Add(snSRVID,nSrvWarn,sbyEnable:Integer):PCQweryServer;
Var
    pV : PCQweryServer;
Begin
    if Find(snSRVID)<>Nil then exit;
    New(pV);
    pV^ := CQweryServer.Create(m_pDDB,m_pMX,snSRVID,nSrvWarn,sbyEnable);
    m_lQSV.Add(pV);
    Result := pV;
End;
procedure CQweryServers.HandQwerySrv(snSRVID,snCLID,snCLSID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     //if IsNotInBlackList(snSRVID)=True then
     if pV.m_blIsError=False then
     pV.HandQwerySrv(snCLID,snCLSID,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.HandQwerySrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      //if IsNotInBlackList(pV.m_nSRVID)=True then
      if pV.m_blIsError=False then
      pV.HandQwerySrv(snCLID,snCLSID,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.HandQwerySrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
     End;
    End;
End;
procedure CQweryServers.UpdateDataSrv(snSRVID,snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     //if IsNotInBlackList(snSRVID)=True then
     if pV.m_blIsError=False then
     pV.UpdateDataSrv(snCLID,snCLSID,sdtBegin,sdtEnd,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.UpdateDataSrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      //if IsNotInBlackList(pV.m_nSRVID)=True then
      if pV.m_blIsError=False then
      pV.UpdateDataSrv(snCLID,snCLSID,sdtBegin,sdtEnd,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.UpdateDataSrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
     End;
    End;
End;
procedure CQweryServers.FindIsExists(snVMID,snPrmID:Integer;sdtBegin,sdtEnd:TDateTime);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.IsExists(snVMID) then
     pV.FindDataSrv(-1,-1,sdtBegin,sdtEnd,snPrmID);
    End;
    SendStartLabel;
End;
procedure CQweryServers.UpdateIsExists(snVMID,snPrmID:Integer;sdtBegin,sdtEnd:TDateTime);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.IsExists(snVMID) then
     pV.UpdateDataSrv(-1,-1,sdtBegin,sdtEnd,snPrmID);
    End;
    SendStartLabel;
End;
procedure CQweryServers.FreeIsExists(snVMID:Integer;byCause:Byte);
Var
    i    : Integer;
    pV   : PCQweryServer;
Begin
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.IsExists(snVMID) then
     pV.StopQwerySrv(-1,byCause);
    End;
    SendStopLabel;
End;
procedure CQweryServers.FindDataSrv(snSRVID,snCLID,snCLSID:Integer;sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     if pV<>Nil then
     Begin
      //if IsNotInBlackList(snSRVID)=True then
      if pV.m_blIsError=False then
      pV.FindDataSrv(snCLID,snCLSID,sdtBegin,sdtEnd,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.FindDataSrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
     End;
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      //if IsNotInBlackList(pV.m_nSRVID)=True then
      if pV.m_blIsError=False then
      pV.FindDataSrv(snCLID,snCLSID,sdtBegin,sdtEnd,snPrmID) else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.FindDataSrv.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
     End;
    End;
End;
procedure CQweryServers.ClearJobsCase(snSRVID,snPortID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     //if (snSRVID=-1)or(pV.m_nSRVID=snSRVID) then
     pV.ClearJobsCase(snPortID);
    End;
End;
procedure CQweryServers.FindDataSrvCaseEr(snABOID,snSRVID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    ClearDMX(snABOID,-1,-1);
    ClearJobsCase(snSRVID,snPrmID);
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     if pV<>Nil then pV.SetSrvError;
     OpenBlackList;
    End;
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.m_blIsError=False then
     Begin
      pV.FindDataSrvCaseEr(snPrmID);
     End  else EventBox.FixEvents(ET_CRITICAL,'Warning!CQweryServers.FindDataSrvCaseEr.������: '+GetSRVNAME(snSRVID)+' ������� � ������ ������!!!');
    End;
End;
procedure CQweryServers.OpenBlackList;
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    EventBox.FixEvents(ET_RELEASE,'������ ������� ������.');
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     if pV.m_blIsError=True then
     EventBox.FixEvents(ET_CRITICAL,'��������! �������: '+GetSRVNAME(pV.m_nSRVID)+' �� ������� �������� �������.' );
    End;
     //for i:=0 to m_strBlackList.Count-1 do
     //EventBox.FixEvents(ET_CRITICAL,'��������! �������: '+GetSRVNAME(StrToInt(m_strBlackList.Strings[i]))+' �� ������� �������� �������.' );
    EventBox.FixEvents(ET_RELEASE,'��������� ������� ������.');
End;
function CQweryServers.IsNotInBlackList(snSRVID:Integer):Boolean;
Var
    i : Integer;
Begin
    Result := True;
    for i:=0 to m_strBlackList.Count-1 do
    Begin
     if snSRVID=StrToInt(m_strBlackList.Strings[i]) then
     Begin
      Result := False;
      exit;
     End;
    End;
End;
procedure CQweryServers.StopQwerySrv(snSRVID:Integer;byCause:Byte);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    //m_strBlackList.Clear;
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     pV.m_blIsError := False;
    End;
    ClearQweryLevel(snSRVID,byCause);
End;
procedure CQweryServers.StopQwerySrv1(snSRVID:Integer;byCause:Byte);
Begin
    ClearQweryLevel(snSRVID,byCause);
End;
procedure CQweryServers.ClearQweryLevel(snSRVID:Integer;byCause:Byte);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     if pV<>Nil then pV.StopQwerySrv(-1,byCause);
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      pV.StopQwerySrv(-1,byCause);
     End;
    End;
End;

procedure CQweryServers.SendErrorL2(snSRVID,snCLID,snCLSID,snPrmID:Integer);
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    if snSRVID<>-1 then
    Begin
     pV := Find(snSRVID);
     //if pV<>Nil then pV.SendErrorL2(-1,snCLSID,snPrmID);
     if pV<>Nil then pV.SendErrorL2(snCLID,snCLSID,snPrmID);
    End else
    if snSRVID=-1 then
    Begin
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      //pV.SendErrorL2(-1,snCLSID,snPrmID);
      pV.SendErrorL2(snCLID,snCLSID,snPrmID);
     End;
    End;
End;
procedure CQweryServers.OnEndQwery(snSRVID,snCLID,snCLSID,snPrmID:Integer);
Var
    pV : PCQweryServer;
Begin
    pV := Find(snSRVID);
    if pV<>Nil then pV.OnEndQwery(snCLID,snCLSID,snPrmID);
End;
procedure CQweryServers.SetCmdState(snSRVID,snCLID,snCLSID,snPrmID:Integer);
Var
    pV : PCQweryServer;
Begin
    pV := Find(snSRVID);
    if pV<>Nil then pV.SetCmdState(snCLID,snCLSID,snPrmID);
End;
procedure CQweryServers.CheckFindState(snSRVID,snCLID,snCLSID,snPrmID:Integer);
Var
    pV : PCQweryServer;
Begin
    pV := Find(snSRVID);
    if pV<>Nil then
    Begin
     //if IsNotInBlackList(snSRVID)=True then
     if pV.m_blIsError=False then
     if pV.CheckFindState(snCLSID,snPrmID)=True then
     SendCalcLabel;
     //if pV.CheckFindState(snCLID,snCLSID,snPrmID)=True then
     //m_pDDB.FreeFinder;
    End;
End;
procedure CQweryServers.ClearBlackList;
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    //if m_strBlackList<>Nil then
    if (trunc(now)<>trunc(m_nOldTime))or(m_strBlackList.Count>1000) then
    Begin
     EventBox.FixEvents(ET_NORMAL,'������� ������� ������.');
     ClearDMX(-1,-1,-1);
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      pV.m_blIsError := False;
      pV.m_nSrvErrors:= 0;
      SendErrorL2(pV.m_nSRVID,-1,-1,-1);
      EventBox.FixEvents(ET_NORMAL,'������: '+GetSRVNAME(pV.m_nSRVID)+' �������� �� ������� ������.');
      ClearQweryLevel(pV.m_nSRVID,0);
     End;
     //Init;
     {
     for i:=0 to m_lQSV.Count-1 do
     Begin
      pV := m_lQSV.Items[i];
      if pV.m_blIsError=True Then
      Begin
       pV.m_blIsError := False;
       pV.m_nSrvErrors:= 0;
       SendErrorL2(pV.m_nSRVID,-1,-1,-1);
       EventBox.FixEvents(ET_NORMAL,'������: '+GetSRVNAME(pV.m_nSRVID)+' �������� �� ������� ������.');
      End;
     End;
     }
     m_nOldTime := Now;
     m_strBlackList.Clear;
    End;
End;
procedure CQweryServers.SendStopLabel;
Var
    pDS  : CMessageData;
    dtTM : TDateTime;
Begin
    dtTM := Now;
    Move(dtTM,pDS.m_sbyInfo[0],sizeof(dtTM));
    SendRSMsgM(CreateMSGD(BOX_L3,0,DIR_LHTOLMC,NL_STOPSRV_REQ,pDS));
    SendMsgData(BOX_L3_LME,0,DIR_L3TOLME,NL_STOPSRV_REQ,pDS);
End;
procedure CQweryServers.SendStartLabel;
Var
    pDS  : CMessageData;
    dtTM : TDateTime;
Begin
    dtTM := Now;
    Move(dtTM,pDS.m_sbyInfo[0],sizeof(dtTM));
    SendRSMsgM(CreateMSGD(BOX_L3,0,DIR_LHTOLMC,NL_STARTSRV_REQ,pDS));
    SendMsgData(BOX_L3_LME,0,DIR_L3TOLME,NL_STARTSRV_REQ,pDS);
End;
procedure CQweryServers.SendCalcLabel;
Var
    pDS  : CMessageData;
    dtTM : TDateTime;
Begin
    dtTM := Now;
    Move(dtTM,pDS.m_sbyInfo[0],sizeof(dtTM));
    SendRSMsgM(CreateMSGD(BOX_L3,0,DIR_LHTOLMC,NL_STARTCLEX_REQ,pDS));
    SendMsgData(BOX_L3_LME,0,DIR_L3TOLME,NL_STARTCLEX_REQ,pDS);
End;
procedure CQweryServers.Run;
Var
    i : Integer;
    pV : PCQweryServer;
Begin
    {if m_lQSV<>Nil then
    for i:=0 to m_lQSV.Count-1 do
    Begin
     pV := m_lQSV.Items[i];
     pV.Run;
    End;
    ClearBlackList;}
End;
end.
