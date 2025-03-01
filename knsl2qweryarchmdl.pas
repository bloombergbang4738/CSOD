unit knsl2qweryarchmdl;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer,
controls,utldatabase,knsl2meter,knsl5tracer,knsl3EventBox,knsl2qwerytmr,knsl2module,utlTimeDate,knsl2qwerymdl,knsl3HolesFinder,utlcbox;
type
    TFindRespond = function(snCLSID,snPrmID:Integer):Boolean of object;
    CDataPump = class
    private
     m_dtBegin  : TDatetime;
     m_dtEnd    : TDatetime;
     m_dtTmp    : TDatetime;
     m_nMID     : Integer;
     m_nCLSID   : Integer;
     m_blEnable : Boolean;
     m_blPause  : Boolean;
     m_byOneSlice: Byte;
     //m_nBox     : CBox;
     m_nDT      : CDTRouting;
     m_pHF      : CHolesFinder;
     m_nHD      : SHALLSDATES;
     m_blIsFinder: Boolean;
     m_nFindID  : Integer;
     m_pTbl     : PSQWERYMDL;
     m_PFindResp  : TFindRespond;
     function  NextP:Boolean;
     function  NextF:Boolean;
    private
     procedure CreateCommand;
     procedure CreateEventQwery(var pMsg:CMessage;var pDS:CMessageData);
     procedure DecDate;
     procedure CreateFindAnswer;
    public
     m_pMT      : CMeter;
     m_nCMDID   : Integer;
     m_blFind   : Boolean;
     m_blFree   : Boolean;
     constructor Create(PFindResp:TFindRespond;pHF:CHolesFinder;pMT:CMeter;pTbl:PSQWERYMDL;nCMDID:Integer);
     destructor Destroy;override;
     procedure SetPump(dtBegin,dtEnd:TDateTime;nMID,nCLSID:Integer;blOneSlice:Byte);
     function  PrepareFind(dtBegin,dtEnd:TDateTime;nMID,nCLSID:Integer):Boolean;
     function  StartFindPrg(var nDT:SHALLSDATES):Boolean;
     function  GetFindBuffer(var nDT:SHALLSDATES):Boolean;
     procedure StopQwery;
     procedure Start;
     procedure Stop;
     function  Next:Boolean;
     procedure Enable;
     procedure Disable;
     procedure Pause;
     procedure SetArchCmd;
    End;
    PCDataPump = ^CDataPump;
    TCmdEvent = procedure(wCMDID:Integer) of object;
    CDataPumps = class
    private
     m_nDP   : TList;
     m_pMT   : PCMeter;
     PCmdProc: TCmdEvent;
     m_pDDB   : Pointer;
     m_pTbl  : PSQWERYMDL;
     m_PFindResp:TFindRespond;
    private
     procedure Add(nCMDID:Integer);
     function Find(nCMDID:Integer):PCDataPump;
     procedure ClearPumps;
     function IsFree(nCMDID:Integer):Boolean;
    public
     constructor Create(PFindResp:TFindRespond;pDDB:Pointer;pMT:PCMeter;pTbl:PSQWERYMDL);
     destructor Destroy;override;
     procedure Init(str:String);
     procedure SetPump(dtBegin,dtEnd:TDateTime;nMID,nCLSID,nCMDID:Integer);
     procedure SetPumpEx(dtBegin,dtEnd:TDateTime;nMID,nCLSID,nCMDID:Integer;blOneSlice:Byte;pProc:TCmdEvent);
     procedure PrepareFind(dtBegin,dtEnd:TDateTime;nVMID,nCLSID,nCMDID:Integer);
     procedure StartFindPrg(nMID,nCLSID,nCMDID:Integer;pProc:TCmdEvent;var nDT:SHALLSDATES);
     procedure StopQwery(nCMDID:Integer);
     function  GetFindBuffer(snPrmID:Integer;var nDT:SHALLSDATES):Boolean;
     procedure Start(nCMDID:Integer);
     procedure Stop(nCMDID:Integer);
     function  Next(nCMDID:Integer):Boolean;
     function  IsFind(nCMDID:Integer):Boolean;
     function  IsExists(nCMDID:Integer):Boolean;
     procedure Enable(nCMDID:Integer);
     procedure Disable(nCMDID:Integer);
     procedure Pause(nCMDID:Integer);
     procedure SetArchCmd(nCMDID:Integer);
    End;
    PCDataPumps = ^CDataPumps;
    CQweryArchMDL = class(CQweryMDL)
    private
     m_nDPS: CDataPumps;
     m_PFindResp:TFindRespond;
    private
     procedure OnEndLoad;override;
     procedure OnEndQwery(nCMDID:Integer);override;
     procedure OnErrQwery;override;
     procedure OnInit; override;
     procedure OnTimeExpired;override;
     procedure CreateFindQwery;
     procedure CreateLoadQwery;
     function  GetEndTime:TDateTime;
    public
     m_pDDB   : Pointer;
     constructor Create(PFindResp:TFindRespond;pDDB:Pointer;var pTbl:SQWERYMDL);
     destructor Destroy();override;
     procedure  LoadData(dtBegin,dtEnd:TDateTime;nCMDID:Integer;blOneSlice:Byte);override;
     procedure  Find(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer;nCause:DWord);override;
     procedure  FindData(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
     procedure  Update(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);override;
     procedure  StartFindPrg(snPrmID:Integer;var nDT:SHALLSDATES);override;
     function   SendErrorL2(snPrmID:Integer):Boolean;override;
     procedure  StopQwery(byCause:Byte);override;
     procedure  LoadCMDV(nCMDID:Integer);override;
     function   GetFindBuffer(snPrmID:Integer;var nDT:SHALLSDATES):Boolean;override;
     function   IsFind(nCMD:Integer):Boolean;override;
     function   IsExists(nCMD:Integer):Boolean;override;
    End;
implementation
//CDataPump
constructor CDataPump.Create(PFindResp:TFindRespond;pHF:CHolesFinder;pMT:CMeter;pTbl:PSQWERYMDL;nCMDID:Integer);
Begin
     m_PFindResp  := PFindResp;
     m_nCMDID     := nCMDID;
     m_pMT        := pMT;
     m_blIsFinder := False;
     m_blFind     := False;
     m_pTbl       := pTbl;
     m_pHF        := pHF;
     //m_nBox       := CBox.Create(BOX_PUMP_SZ);
End;
destructor CDataPump.Destroy;
Begin
     Setlength(m_nHD.Items,0);
     if m_nDT<>nil then FreeAndNil(m_nDT);
     inherited;
End;
procedure CDataPump.SetPump(dtBegin,dtEnd:TDateTime;nMID,nCLSID:Integer;blOneSlice:Byte);
Begin
     m_dtBegin := trunc(dtBegin);
     m_dtEnd   := trunc(dtEnd);
     m_nMID    := nMID;
     m_nCLSID  := nCLSID;
     m_blEnable:= True;
     m_blPause := False;
     m_byOneSlice := blOneSlice;
     if (m_nCMDID>=QRY_JRNL_T1)and(m_nCMDID<=QRY_JRNL_T4) then m_dtBegin := m_dtEnd;
     if not Assigned(m_nDT) then m_nDT := CDTRouting.Create;
End;
function CDataPump.PrepareFind(dtBegin,dtEnd:TDateTime;nMID,nCLSID:Integer):Boolean;
Begin
     if m_blEnable=False then
     Begin
      m_blFind := True;
      m_pHF.FindHall(nCLSID,dtBegin,dtEnd,nMID,m_nCMDID,m_nHD);
      m_blIsFinder := True;
      m_nFindID    := 0;
      m_blFind     := False;
      if IsDb(2)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!CDataPump.PrepareFind. ������ �: '+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID)+'Len:'+IntToStr(m_nHD.Count));
      //Sleep(100);//AAV
      if Assigned(m_PFindResp) then m_PFindResp(nCLSID,m_nCMDID);
      //CreateFindAnswer;
     End else
      EventBox.FixEvents(ET_CRITICAL,'Warning!CDataPump.PrepareFind ������ :'+GetVMName(m_pTbl.m_snVMID)+' �����: '+DateTimeToStr(dtEnd)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID)+' �����!!!');
     Result := (m_nHD.Count<>0)
End;
procedure CDataPump.CreateFindAnswer;
Var
     sQC : SQWERYCMDID;
     pDS : CMessageData;
Begin
     with sQC do
     Begin
      m_snABOID := m_pTbl.m_snAID;
      m_snSRVID := m_pTbl.m_snSRVID;
      m_snCLID  := m_pTbl.m_snCLID;
      m_snCLSID := m_pTbl.m_snCLSID;
      m_snPrmID := m_nCMDID;
     End;
     Move(sQC,pDS.m_sbyInfo[0],sizeof(SQWERYCMDID));
     SendMsgData(BOX_QSRV,0,DIR_L2TOQS,QSRV_FIND_COMPL_REQ,pDS);
End;
function CDataPump.StartFindPrg(var nDT:SHALLSDATES):Boolean;
Var
     i : Integer;
Begin
     m_nHD.Count := nDT.Count;
     SetLength(m_nHD.Items,nDT.Count);
     for i:=0 to m_nHD.Count-1 do m_nHD.Items[i] := nDT.Items[i];
     m_blIsFinder := True;
     m_nFindID    := 0;
     m_blFind     := False;
     Result       := (m_nHD.Count<>0);
End;
function CDataPump.GetFindBuffer(var nDT:SHALLSDATES):Boolean;
Var
     i : Integer;
Begin
     nDT.Count := m_nHD.Count;
     SetLength(nDT.Items,m_nHD.Count);
     for i:=0 to m_nHD.Count-1 do nDT.Items[i] := m_nHD.Items[i];
     Result := (m_nHD.Count<>0);
End;
procedure CDataPump.CreateCommand;
Var
     szDT : Integer;
     pDS  : CMessageData;
     pMsg : CMessage;
Begin
     szDT := sizeof(TDateTime);
     pDS.m_swData0 := m_nMID;
     pDS.m_swData1 := m_nCMDID;
     pDS.m_swData2 := m_byOneSlice;
     pDS.m_swData3 := 1;
     Move(m_dtTmp,pDS.m_sbyInfo[0] ,szDT);
     Move(m_dtTmp,pDS.m_sbyInfo[szDT],szDT);
     pDS.m_sbyInfo[2*szDT] := 0;
     if (m_nCMDID>=QRY_JRNL_T1)and(m_nCMDID<=QRY_JRNL_T4) then
     CreateEventQwery(pMsg,pDS) else
     CreateMSGDL(pMsg,BOX_L2,m_nMID,DIR_L3TOL2,QL_DATA_GRAPH_REQ,pDS);
     if m_pMT=Nil then exit;
     m_pMT.EventHandler(pMsg);
     //m_nBox.FFREE;
     //m_pMT.PObserver.GetArchCmd(m_nBox);
     //if IsDb(1)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!!! CDataPump.CreateCommand. ������:'+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID)+' �����: '+IntToStr(m_nBox.FCHECK));
End;
procedure CDataPump.CreateEventQwery(var pMsg:CMessage;var pDS:CMessageData);
Var
     nJIM : int64;
Begin
     case pDS.m_swData1 of
          QRY_JRNL_T1 : nJIM := (QFH_JUR_0);
          QRY_JRNL_T2 : nJIM := (QFH_JUR_1);
          QRY_JRNL_T3 : nJIM := (QFH_JUR_2);
          QRY_JRNL_T4 : nJIM := (QFH_JUR_3);
     End;
     Move(nJIM,pDS.m_sbyInfo[2*sizeof(TDateTime)],sizeof(int64));
     CreateMSGDL(pMsg,BOX_L2,m_nMID,DIR_L3TOL2,QL_LOAD_EVENTS_REQ,pDS);
End;
procedure CDataPump.SetArchCmd;
Begin
     //if m_pMT=Nil then exit;
     //m_pMT.PObserver.SetArchCmd(m_nBox);
     //m_nBox.FFREE();
End;
procedure CDataPump.StopQwery;
Begin
     //m_blEnable   := False; //AAV
     m_blEnable   := False;
     m_nFindID    := 0;
     m_blIsFinder := False;
     m_blFind     := False;
     m_blPause    := False;
     m_byOneSlice := 0;
     //m_nBox.FFREE;
     m_nHD.Count  := 0;
     Setlength(m_nHD.Items,0);
     if IsDb(1)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!CDataPump.StopQwery. ������ �: '+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID)+' �����!!!');
End;
procedure CDataPump.Start;
Begin
     m_dtTmp   := m_dtBegin;
     m_blPause := False;
     Enable;
End;
procedure CDataPump.Stop;
Begin
     m_dtTmp := m_dtBegin;
     Disable;
End;
procedure CDataPump.Pause;
Begin
     m_blPause := True;
End;
function CDataPump.Next:Boolean;
Begin
     if m_blIsFinder=True  then Result := NextF else
     if m_blIsFinder=False then Result := NextP;
End;
function CDataPump.NextP:Boolean;
Begin
     Result := False;
     if m_blPause=False then
     Begin
      if (m_dtTmp>=m_dtEnd)and(m_blEnable=True) then
      Begin
       CreateCommand;
       DecDate;
       Result := True;
      End else
      Begin
       if IsDb(1)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!CDataPump.StopQwery. ������ �: '+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID)+' �����!!!');
       Disable;
      End;
     End;
End;
{
     CLS_MGN      = 1;
     CLS_GRAPH48  = 4;
     CLS_DAY      = 8;
     CLS_MONT     = 9;
     CLS_EVNT     = 11;
     CLS_TIME     = 12;
     CLS_PNET     = 13;
}
procedure CDataPump.DecDate;
Begin
     case m_nCLSID of
          CLS_DAY,
          CLS_GRAPH48,
          CLS_EVNT,
          CLS_PNET    : m_dtTmp := m_dtTmp - 1;
          CLS_MONT    : m_nDT.DecMonth(m_dtTmp);
     End;
End;
function CDataPump.NextF:Boolean;   
Begin
     Result := False;
     //if m_blPause=False then
     //Begin
      if m_nFindID<=(m_nHD.Count-1) then
      Begin
       m_dtTmp := m_nHD.Items[m_nFindID];
       CreateCommand;
       Inc(m_nFindID);
       Result := True;
      End else
      Begin
       Disable;
       if IsDb(1)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!!! CDataPump.NextF.����� �� ��������.m_nFindID>(m_nHD.Count-1)! ������:'+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID));
      End;
     //End else if IsDb(1)=True then EventBox.FixEvents(ET_CRITICAL,'Warning!!! CDataPump.NextF.����� �� ��������.�����! ������:'+GetVMName(m_pTbl.m_snVMID)+' �������:'+GetCLSID(m_nCLSID)+' ��������:'+GetCMD(m_nCMDID));
End;
procedure CDataPump.Enable;
Begin
     m_blEnable := True;
End;
procedure CDataPump.Disable;
Begin
     m_blEnable   := False;
     m_blIsFinder := False;
     m_nFindID    := 0;
     m_byOneSlice := 0;
     SetLength(m_nHD.Items,0);
     m_nHD.Count  := 0;
End;







//CDataPumps
constructor CDataPumps.Create(PFindResp:TFindRespond;pDDB:Pointer;pMT:PCMeter;pTbl:PSQWERYMDL);
Begin
     m_PFindResp := PFindResp;
     m_pDDB := pDDB;
     m_nDP := TList.Create;
     m_pMT := pMT;
     m_pTbl:= pTbl;
     //m_pDDB := CHolesFinder.Create(m_pDDB);
End;
destructor CDataPumps.Destroy;
Begin
     ClearPumps;
     m_nDP.Destroy;
     inherited;
End;
procedure CDataPumps.Init(str:String);
Var
     strCMD : String;
     nCMDID : Integer;
Begin
     ClearPumps;
     strCMD := str;
     while GetCode(nCMDID,strCMD)<>False do
     if (nCMDID and $8000)<>0 then Add(nCMDID and $7fff);
End;
procedure CDataPumps.Add(nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     New(pDP);
     pDP^ := CDataPump.Create(m_PFindResp,m_pDDB,m_pMT^,m_pTbl,nCMDID);
     m_nDP.Add(pDP);
End;
function CDataPumps.Find(nCMDID:Integer):PCDataPump;
Var
     i : Integer;
     pDP : PCDataPump;
Begin
     Result := Nil;
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      if pDP.m_nCMDID=nCMDID then
      Begin
       Result := pDP;
       exit;
      End;
     End;
End;
procedure CDataPumps.ClearPumps;
Var
     i : Integer;
     pDP : PCDataPump;
Begin
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.Free;
      Dispose(pDP);
     End;
     m_nDP.Clear;
End;
procedure CDataPumps.SetPump(dtBegin,dtEnd:TDateTime;nMID,nCLSID,nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     pDP := Find(nCMDID);
     if pDP<>Nil then pDP.SetPump(dtBegin,dtEnd,nMID,nCLSID,0);
End;
procedure CDataPumps.SetPumpEx(dtBegin,dtEnd:TDateTime;nMID,nCLSID,nCMDID:Integer;blOneSlice:Byte;pProc:TCmdEvent);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     PCmdProc := pProc;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Begin
       pDP.SetPump(dtBegin,dtEnd,nMID,nCLSID,blOneSlice);
       pDP.Start;
       pDP.Next;
       if Assigned(PCmdProc) then PCmdProc(pDP.m_nCMDID)
      End;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.SetPump(dtBegin,dtEnd,nMID,nCLSID,blOneSlice);
      pDP.Start;
      pDP.Next;
      if Assigned(PCmdProc) then PCmdProc(pDP.m_nCMDID)
     End;
End;
procedure CDataPumps.PrepareFind(dtBegin,dtEnd:TDateTime;nVMID,nCLSID,nCMDID:Integer);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     if nCMDID=$ffff then exit;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Begin
       pDP.PrepareFind(dtBegin,dtEnd,nVMID,nCLSID);
      End;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.PrepareFind(dtBegin,dtEnd,nVMID,nCLSID);
     End;
End;
procedure CDataPumps.StopQwery(nCMDID:Integer);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     if nCMDID=$ffff then exit;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Begin
       pDP.StopQwery;
      End;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.StopQwery;
     End;
End;
procedure CDataPumps.StartFindPrg(nMID,nCLSID,nCMDID:Integer;pProc:TCmdEvent;var nDT:SHALLSDATES);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     PCmdProc := pProc;
     if nCMDID=$ffff then exit;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Begin
       if pDP.StartFindPrg(nDT)=True then
       Begin
        pDP.SetPump(pDP.m_nHD.Items[0],pDP.m_nHD.Items[pDP.m_nHD.Count-1],nMID,nCLSID,0);
        pDP.Start;
        pDP.Next;
        if Assigned(PCmdProc) then PCmdProc(pDP.m_nCMDID);
       End;
      End;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      if pDP.StartFindPrg(nDT)=True then
      Begin
       pDP.SetPump(pDP.m_nHD.Items[0],pDP.m_nHD.Items[pDP.m_nHD.Count-1],nMID,nCLSID,0);
       pDP.Start;
       pDP.Next;
       if Assigned(PCmdProc) then PCmdProc(pDP.m_nCMDID)
      End;
     End;
End;
procedure CDataPumps.SetArchCmd(nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     if (nCMDID=$ffff)or(nCMDID=-1) then exit;
     pDP := Find(nCMDID);
     if pDP<>Nil then
     pDP.SetArchCmd;
End;
function CDataPumps.GetFindBuffer(snPrmID:Integer;var nDT:SHALLSDATES):Boolean;
Var
     pDP : PCDataPump;
Begin
     Result := True;
     nDT.Count := 0;
     if (snPrmID=$ffff)or(snPrmID=-1) then exit;
     pDP := Find(snPrmID);
     if pDP<>Nil then
     Result := pDP.GetFindBuffer(nDT);
End;
function CDataPumps.IsFind(nCMDID:Integer):Boolean;
Var
     pDP : PCDataPump;
Begin
     Result:=False;
     if nCMDID=$ffff then exit;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Result := pDP.m_blFind else Result := True;
     End;
End;
function CDataPumps.IsExists(nCMDID:Integer):Boolean;
Var
     pDP : PCDataPump;
Begin
     Result:=False;
     if (nCMDID=$ffff)or(nCMDID=-1) then exit;
     pDP := Find(nCMDID);
     if pDP<>Nil then
     Result := True;
End;

function CDataPumps.IsFree(nCMDID:Integer):Boolean;
Var
     pDP : PCDataPump;
Begin
     Result:=False;
     if nCMDID=$ffff then exit;
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then
      Result := pDP.m_blFree;
     End;
End;
function CDataPumps.Next(nCMDID:Integer):Boolean;
Var
     pDP : PCDataPump;
     res : Boolean;
Begin
     //Result := False;
     res:=False;
     pDP := Find(nCMDID);
     if pDP<>Nil then
     Begin
      res := pDP.Next;
      if (res=True) and Assigned(PCmdProc) then PCmdProc(nCMDID)
     End;
     Result := res;
End;
procedure CDataPumps.Start(nCMDID:Integer);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then pDP.Start;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.Start;
     End;
End;
procedure CDataPumps.Stop(nCMDID:Integer);
Var
     pDP : PCDataPump;
     i   : Integer;
Begin
     if nCMDID<>-1 then
     Begin
      pDP := Find(nCMDID);
      if pDP<>Nil then pDP.Stop;
     End else
     if nCMDID=-1 then
     for i:=0 to m_nDP.Count-1 do
     Begin
      pDP := m_nDP.Items[i];
      pDP.Stop;
     End;
End;
procedure CDataPumps.Enable(nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     pDP := Find(nCMDID);
     if pDP<>Nil then pDP.Enable;
End;
procedure CDataPumps.Disable(nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     pDP := Find(nCMDID);
     if pDP<>Nil then pDP.Disable;
End;
procedure CDataPumps.Pause(nCMDID:Integer);
Var
     pDP : PCDataPump;
Begin
     pDP := Find(nCMDID);
     if pDP<>Nil then pDP.Pause;
End;
//CQweryMDL
destructor CQweryArchMDL.Destroy();
Begin
  if m_nDPS <> nil then FreeAndNil(m_nDPS);
  inherited;
End;
constructor CQweryArchMDL.Create(PFindResp:TFindRespond;pDDB:Pointer;var pTbl:SQWERYMDL);
Begin
     m_PFindResp := PFindResp;
     m_pDDB  := pDDB;
     m_pMT  := mL2Module.GetL2Object(pTbl.m_snMID);
     m_nDPS := CDataPumps.Create(m_PFindResp,pDDB,m_pMT,@m_nTbl);
     inherited Create(pTbl);
     m_byUpdate := 1;
End;
procedure CQweryArchMDL.OnInit;
//Var
//     i : Integer;
Begin
     //m_nTbl.m_strCMDCluster := '32783,32775,';
      m_nDPS.Init(m_nTbl.m_strCMDCluster);
End;
procedure CQweryArchMDL.OnEndLoad;
Begin
End;
procedure CQweryArchMDL.OnEndQwery(nCMDID:Integer);
Begin
     if IsEnabled=True then
     m_nDPS.Next(nCMDID);
End;
procedure CQweryArchMDL.OnErrQwery;
Begin
End;
procedure CQweryArchMDL.LoadCMDV(nCMDID:Integer);
Begin
     m_nDPS.SetArchCmd(nCMDID);
End;
procedure CQweryArchMDL.LoadData(dtBegin,dtEnd:TDateTime;nCMDID:Integer;blOneSlice:Byte);
Var
     PCmdProc : TCmdEvent;
Begin
     PCmdProc := LoadQSV;
     m_nDPS.SetPumpEx(dtBegin,dtEnd,m_nTbl.m_snMID,m_nTbl.m_snCLSID,nCMDID,blOneSlice,PCmdProc);
End;
procedure CQweryArchMDL.Find(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer;nCause:DWord);
Begin
     case nCause of
          AL_NO_ERR  : if IsEnabled then OnTimeExpired;
          AL_ER_DIAL : if IsEnabled and IsTimeValid then OnTimeExpired;
     End;
End;
procedure CQweryArchMDL.FindData(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Begin
     //m_nDPS.StopQwery(snPrmID);
     if m_pMT=Nil then exit;
     if IsEnabled then
     m_nDPS.PrepareFind(sdtBegin,sdtEnd,m_nTbl.m_snVMID,m_nTbl.m_snCLSID,snPrmID);
End;
procedure CQweryArchMDL.Update(sdtBegin,sdtEnd:TDateTime;snPrmID:Integer);
Begin
     //m_nDPS.StopQwery(snPrmID);
     if m_pMT=Nil then exit;
     if IsEnabled then
     LoadData(sdtBegin,sdtEnd,snPrmID,0);
End;
procedure CQweryArchMDL.StartFindPrg(snPrmID:Integer;var nDT:SHALLSDATES);
Var
     PCmdProc : TCmdEvent;
Begin
     if IsEnabled then
     Begin
      PCmdProc := LoadQSV;
      m_nDPS.StartFindPrg(m_nTbl.m_snMID,m_nTbl.m_snCLSID,snPrmID,PCmdProc,nDT);
     End;
End;
procedure CQweryArchMDL.CreateFindQwery;
Var
     dtBegin,dtEnd  : TDateTime;
Begin
     dtBegin:= Now;
     dtEnd  := GetEndTime;
     FindData(dtBegin,dtEnd,-1);
     EventBox.FixEvents(ET_NORMAL,'����� � �������. ������:'+GetVMName(m_nTbl.m_snVMID)+' ����� �: '+DateTimeToStr(dtBegin)+' ��: '+DateTimeToStr(dtEnd)+' �������:'+GetCLSID(m_nTbl.m_snCLSID));
End;
procedure CQweryArchMDL.CreateLoadQwery;
Var
     dtBegin,dtEnd  : TDateTime;
Begin
     dtBegin:= Now;
     dtEnd  := GetEndTime;
     m_byUpdate := 0;
      LoadData(dtBegin,dtEnd,-1,0);
     m_byUpdate := 1;
     EventBox.FixEvents(ET_NORMAL,'����� � �������. ������:'+GetVMName(m_nTbl.m_snVMID)+' ����� �: '+DateTimeToStr(dtBegin)+' ��: '+DateTimeToStr(dtEnd)+' �������:'+GetCLSID(m_nTbl.m_snCLSID));
End;
function CQweryArchMDL.GetEndTime:TDateTime;
Var
     dtEnd : TDateTime;
     year,month,day : Word;
Begin
     dtEnd := Now;  
     if m_nTbl.m_snDeepFind=0 then
     Begin
      DecodeDate(dtEnd,year,month,day);
      dtEnd := EncodeDate(year,month,1);
      dtEnd := dtEnd - 1;
     End else
     if m_nTbl.m_snDeepFind=12 then
     Begin
      m_nDT.DecMonth(dtEnd);
      DecodeDate(dtEnd,year,month,day);
      dtEnd := EncodeDate(year,month,1);
     End else
     if m_nTbl.m_snDeepFind<>0 then dtEnd := dtEnd - DeltaFHF[m_nTbl.m_snDeepFind];
     Result := dtEnd;
End;
procedure CQweryArchMDL.OnTimeExpired;
Begin
     if IsEnabled then
     Begin
      //m_nDPS.StopQwery(-1);
      if m_nTbl.m_sbyFindData=0 then CreateFindQwery else
      if m_nTbl.m_sbyFindData=1 then
      Begin
       if m_pMT=Nil then exit;
       if m_pMT.m_nP.m_sbyType<>MET_ENTASNET then CreateLoadQwery;
       if m_pMT.m_nP.m_sbyType= MET_ENTASNET then Begin m_byUpdate := 0;LoadData(trunc(Now),trunc(Now),-1,1);m_byUpdate := 1;End;
      End;
     End else
     EventBox.FixEvents(ET_CRITICAL,'Error.CQweryArchMDL.OnTimeExpired. ������:'+GetVMName(m_nTbl.m_snVMID)+' CL:'+GetCLSID(m_nTbl.m_snCLSID)+' �����!!!');
End;
procedure CQweryArchMDL.StopQwery(byCause:Byte);
Begin
     m_nDPS.StopQwery(-1);
     if m_pMT=Nil then exit;
     if byCause=0 then m_pMT.OnFinal;
     if byCause=1 then m_pMT.OnFree;
End;
function CQweryArchMDL.SendErrorL2(snPrmID:Integer):Boolean;
Begin
     m_nDPS.StopQwery(snPrmID);
     //m_pMT.OnFree;
End;
function CQweryArchMDL.GetFindBuffer(snPrmID:Integer;var nDT:SHALLSDATES):Boolean;
Begin
     Result := m_nDPS.GetFindBuffer(snPrmID,nDT);
End;
function CQweryArchMDL.IsFind(nCMD:Integer):Boolean;
Begin
     if IsEnabled then
     Begin
      Result := m_nDPS.IsFind(nCMD);
     End else Result := True;
End;
function  CQweryArchMDL.IsExists(nCMD:Integer):Boolean;
Begin
     Result := False;
     if IsEnabled then
     Result := m_nDPS.IsExists(nCMD);
End;
end.

