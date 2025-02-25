unit knsl3querysender;

interface
uses
     Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,extctrls,utlmtimer,
     knsl5config,knsl1cport,knsl3EventBox;
type
     CQuerySender = class(TThread)
     private
      m_wQryTime   : Word;
      m_byID       : Word;
      m_byBox      : Word;
      m_nMsg       : CMessage;
      m_hEvent     : Thandle;
      m_nPoolTime  : Integer;
      m_nPoolTimer : CTimer;
      FTimer       : TTimer;
      FState       : Byte;
      FMState      : Byte;
      FSynState    : Boolean;
      m_plTable    : PSL1TAG;
      m_wLastCMD   : Word;
      pSvQR        : CQueryPrimitive;
      m_pDS        : CMessageData;
      m_nDiscTimer : CTimer;
      m_blMDMState : Boolean;
      m_blMDMError : Boolean;
      m_nErAID     : Integer;
      m_nErSRVID   : Integer;
      m_nErCLID    : Integer;
      FPort        : PCPort;
     public
      destructor Destroy; override;
      procedure Init(var pTable:SL1TAG);
      procedure Stop;
      procedure Go;
      procedure GoGsm;
      procedure Free;
      procedure GoSender;
      procedure GoSenderGraph(var pMsg:CMessage);
      procedure GoSenderCtrl(var pMsg:CMessage);
      procedure GoSenderAllGraph(wMID:Word);
      procedure StopSender;
      procedure SetModemState(byState:Integer);
      procedure DiscSender;
      procedure FreeSender;
      procedure DiscCauseSender;
      procedure FreeMID(nMID:Integer);
      procedure FreeMID1(nMID:Integer);
      procedure SetFinalEvent(wMID,wFinal:Word);
      procedure SetFinalEventEx(wVMID,wMID,wCMDID,wFinal:Integer);
      procedure OnModemFinalAction(wMID:Word);
      procedure Run;
      procedure OnDisconnect(var pMsg:CMessage);
      function  EventHandler(var pMsg:CMessage):Boolean;
      procedure OnDialError;
     private
      procedure SetDefault;
      procedure SetState(byState:Byte);
      procedure OnMeterFinalAction(pQR:PCQueryPrimitive);
      procedure OnChannelFinalAction(pQR:PCQueryPrimitive);
      procedure OnMeterEnterAction(pQR:PCQueryPrimitive);
      procedure OnChannelEnterAction(pQR:PCQueryPrimitive);
      procedure OnMonitorEnterAction(pQR:PCQueryPrimitive);
      procedure OnMonitorFinalAction(pQR:PCQueryPrimitive);
      procedure OnStartCalc(pQR:PCQueryPrimitive);
      procedure OnCommandFinalAction(pQR:PCQueryPrimitive);
      procedure OnConnAfterError;
      procedure OnDiscError;
      procedure SendMSG(wMid:Word;byBox:Integer;byFor,byType,byPort:Byte);
      procedure SendErrQS(wEvType:Word);
      //procedure DoHalfTime(Sender:TObject);dynamic;
      procedure SendQry(pQR:PCQueryPrimitive);
      procedure Execute; override;
     public
      property PState : Byte read FState  write FState;
      property PMState: Byte read FMState write FMState;
      property PPort  : PCPort read FPort write FPort;

     End;
const
     WAIT_TMR = 20;
Var
     m_nQrySender : array[0..MAX_PORT] of CQuerySender;
implementation
procedure CQuerySender.Init(var pTable:SL1TAG);
Begin
     m_plTable   := @pTable;
     if m_plTable.m_sblReaddres=1 then
     m_byID      := m_plTable.m_swAddres else
     m_byID      := pTable.m_sbyPortID;
     //m_nPoolTime := pTable.m_swPoolTime*1000;
     m_byBox     := BOX_L3_QS+m_byID;
     FState      := QM_NULL_STATE;
     FMState     := 0;
     if pTable.m_sbyType=DEV_COM_LOC then FMState := 1;
     SetState(QM_NULL_STATE);
     FDEFINE(m_byBox,BOX_L3_QS_SZ,True);
     m_hEvent := CreateEvent(Nil,False,False,Nil);
     FSynState := False;
     //SetEvent(m_hEvent);
     ReSetEvent(m_hEvent);
     m_nDiscTimer := CTimer.Create;
     m_nDiscTimer.SetTimer(DIR_QSTOL1,DL_QSDISC_TMR,0,0,BOX_L1);
     if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(__)CL3QS::>Create Query Sender.');
     m_blMDMState := False;
     m_blMDMError := False;
End;
destructor CQuerySender.Destroy;
Begin
     if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(__)CL3QS::>Delete Query Sender.');
     FFREE(m_byBox);
     Terminate;
End;
function  CQuerySender.EventHandler(var pMsg : CMessage):Boolean;
Begin
     case pMsg.m_sbyType of
          DL_QSDISC_TMR : OnDisconnect(pMsg);
     End;
End;
procedure CQuerySender.Stop;
Begin
     ResetEvent(m_hEvent);
End;
procedure CQuerySender.Go;
Begin
     if m_plTable.m_sblReaddres=1 then exit;
     if FCHECK(m_byBox)<>0 then
     Begin
      //TraceL(2,m_byID,'(__)CL3QS::>Syncronize MSG:Int:'+IntToStr(m_byID));
      SetEvent(m_hEvent);
     End;// else
     //TraceL(2,m_byID,'(__)CL3QS::>Stop Sync  MSG:Int:'+IntToStr(m_byID));
End;
procedure CQuerySender.GoGsm;
Begin
     FMState     := 1;
     Go;
End;
procedure CQuerySender.Free;
Begin
     //SetEvent(m_hEvent);
     FFREE(m_byBox);
End;
procedure CQuerySender.OnConnAfterError;
Begin
     if m_nIsServer=1 then
     Begin
      FFREE(m_byBox);
      ClearAbon(m_nErAID,m_nErSRVID,-1);
      SendQSComm(m_nErAID,-1,-1,-1,m_byID,QS_FIND_AP);
      //SendQSComm(m_nErAID,m_nErSRVID,-1,-1,m_byID,QS_FIND_AP);
      m_blMDMError := False;
     End;
End;
procedure CQuerySender.OnDialError;
Begin
     if m_nCF.QueryType=QWR_QWERY_SRV then
     Begin
      if m_nIsServer=1 then
      Begin
       FFREE(m_byBox);
       ClearAbon(m_nErAID,m_nErSRVID,-1);
       SendQSComm(m_nErAID,m_nErSRVID,-1,-1,m_byID,QS_FIND_AP);
      End;
     End;
End;
procedure CQuerySender.OnDiscError;
Begin
     FFREE(m_byBox);
End;
procedure CQuerySender.FreeMID(nMID:Integer);
Var
     nQry   : CQueryPrimitive;
     pMsg:CMessage;
Begin
     if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(__)CL3QS::>FreeMID:'+IntToStr(nMID)+' BCT:'+IntToStr(FCHECK(m_byBox)));
     //if m_plTable.m_sbyType=DEV_COM_GSM then SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_RECONN_IND);
     if m_plTable.m_sbyType=DEV_COM_GSM then FPort.ReConnect(pMsg);
     //SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_RECONN_IND);
     if m_nCF.QueryType=QWR_QWERY_SRV then Begin {OnDialError;}SendErrQS(EVA_METER_NO_ANSWER);end;
     FCLRSYN(m_byBox);
     Begin
      repeat
       if FGET(m_byBox,@nQry)=0 then break;
       //TraceM(3,m_byID,'(__)CL3QS::>FreeMID:'+IntToStr(nMID),@nQry);
      until nQry.m_swParamID=QM_FIN_COM_IND;
     End;
     SetDefault;
     FSETSYN(m_byBox);
     Go;
     //if (m_plTable.m_sbyType=DEV_COM_GSM) then
     //m_blMDMError := True;
End;
procedure CQuerySender.FreeMID1(nMID:Integer);
Var
     nQry   : CQueryPrimitive;
Begin
     if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(__)CL3QS::>FreeMID:'+IntToStr(nMID)+' BCT:'+IntToStr(FCHECK(m_byBox)));
     FCLRSYN(m_byBox);
     Begin
      repeat
       if FGET(m_byBox,@nQry)=0 then break;
       //TraceM(3,m_byID,'(__)CL3QS::>FreeMID:'+IntToStr(nMID),@nQry);
      until nQry.m_swParamID=QM_FIN_COM_IND;
     End;
     SetDefault;
     FSETSYN(m_byBox);
     Go;
End;
procedure CQuerySender.GoSender;
Begin
     if m_plTable.m_sblReaddres=1 then exit;
     SetState(QM_POOL_STATE);
     FFREE(m_byBox);
     SendMSG(0,BOX_L2,DIR_LMTOL2,DL_LOADOBSERVER_IND,m_byID);
End;
procedure CQuerySender.GoSenderGraph(var pMsg:CMessage);
Var
     pDS : CMessageData;
Begin
     Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
     SetState(QM_POOL_STATE);
     FFREE(m_byBox);
     SendMsgIData(BOX_L2,pDS.m_swData2,m_byID,DIR_LMTOL2,DL_LOADOBSERVER_GR_IND,pDS);
End;

{*******************************************************************************
 *  ������ ���������
 *  Ukrop
 ******************************************************************************}
procedure CQuerySender.GoSenderCtrl(var pMsg:CMessage);
Var
     pDS : CMessageData;
Begin
     Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
     SetState(QM_POOL_STATE);
     FFREE(m_byBox);
     SendMsgIData(BOX_L2,pDS.m_swData2,m_byID,DIR_LMTOL2,DL_LOADOBSERVER_CTRL_IND,pDS);
End;

procedure CQuerySender.GoSenderAllGraph(wMID:Word);
Begin
     if m_plTable.m_sblReaddres=1 then exit;
     SetState(QM_POOL_STATE);
     FFREE(m_byBox);
     SendMSG(wMID,BOX_L2,DIR_LMTOL2,DL_LOADOBSERVER_AllGR_IND,m_byID);
End;

procedure CQuerySender.StopSender;
Begin
     if FState<>QM_WAIT_STOP_STATE then SetState(QM_NULL_STATE);
     FFREE(m_byBox);
End;
procedure CQuerySender.DiscCauseSender;
Begin
     if FState=QM_WAIT_STOP_STATE then
     DiscSender;
End;
procedure CQuerySender.SetModemState(byState:Integer);
Begin
    if byState=PH_STATIONON_REQ then
    Begin
     if (m_blMDMState=False)or(m_blMDMError=True) then
     Begin
      m_blMDMState := True;
      if m_blMDMError=True then
      Begin
       OnConnAfterError;
       m_blMDMError := False;
      End;
     End;
    End else
    if byState=PH_STATIONOF_REQ then
    Begin
     if (m_blMDMState=True) then
     Begin
      m_blMDMState := False;
      m_blMDMError := True;
      OnDiscError;
     End;
    End;
End;
procedure CQuerySender.DiscSender;
Begin
     SetState(QM_NULL_STATE);
     FMState := 0;
     //if m_plTable.m_sbyType=DEV_COM_GSM then
     //if m_plTable.m_sbyType<>DEV_TCP_SRV then
     m_blMDMState := False;
     m_blMDMError := False;
     SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_DISC_IND);
     FFREE(m_byBox);
End;
procedure CQuerySender.FreeSender;
Begin
     SetState(QM_NULL_STATE);
     FMState := 0;
     //if m_plTable.m_sbyType=DEV_COM_GSM then
     //if m_plTable.m_sbyType<>DEV_TCP_SRV then
     m_blMDMState := False;
     m_blMDMError := False;
     //SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_DISC_IND);
     FFREE(m_byBox);
End;
procedure CQuerySender.SendQry(pQR:PCQueryPrimitive);
Begin
     m_nMsg.m_swLen    := sizeof(CQueryPrimitive)+11;
     m_nMsg.m_sbyFor   := DIR_L3TOL2;
     m_nMsg.m_sbyType  := QL_DATARD_REQ;
     m_nMsg.m_swObjID  := pQR.m_swMtrID;
     Move(pQR^,m_nMsg.m_sbyInfo[0],sizeof(CQueryPrimitive));
     FPUT(BOX_L2,@m_nMsg);
End;
procedure CQuerySender.Execute;
Var
     pQR : CQueryPrimitive;
Begin
     while True do
     Begin
      FSynState := True;
      WaitForSingleObject(m_hEvent,INFINITE);
      FGET(m_byBox,@pQR);
      if IsDb(4)=True then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(m_byID)+')GEt Qwery Sender m_swParamID:'+IntToStr(pQR.m_swParamID));
      FSynState := False;
       case pQR.m_swParamID of
        QM_ENT_MON_IND  : OnMonitorEnterAction(@pQR);
        QM_ENT_CHN_IND  : OnChannelEnterAction(@pQR);
        QM_ENT_MTR_IND  : OnMeterEnterAction(@pQR);
        QM_FIN_MTR_IND  : OnMeterFinalAction(@pQR);
        QM_FIN_COM_IND  : OnCommandFinalAction(@pQR);
        QM_FIN_CHN_IND  : OnChannelFinalAction(@pQR);
        QM_FIN_MON_IND  : OnMonitorFinalAction(@pQR);
        QM_CLC_SRV_IND  : OnStartCalc(@pQR);
       else
         SendQry(@pQR);
        //TraceL(3,m_byID,'(__)CL3QS::>Send Query.');
       End;
       m_wLastCMD := pQR.m_swParamID;
     End;
End;
procedure CQuerySender.OnMeterEnterAction(pQR:PCQueryPrimitive);
Begin
     if (m_plTable.m_sbyType=DEV_COM_GSM) then
      m_nDiscTimer.OffTimer;
     SendQry(pQR);
End;
procedure CQuerySender.OnMonitorEnterAction(pQR:PCQueryPrimitive);
Begin
     m_nErAID   := HiByte(pQR.m_swSpecc2);
     m_nErSRVID := LoByte(pQR.m_swSpecc2);
     m_nErCLID  := pQR.m_swSpecc1;
     SendQry(pQR);
End;
procedure CQuerySender.OnMonitorFinalAction(pQR:PCQueryPrimitive);
Begin
     if (m_plTable.m_sbyType=DEV_COM_GSM) then
     Begin
      if FCHECK(m_byBox)=0 then
      Begin
       Move(pQR^,pSvQR,sizeof(CQueryPrimitive));
       m_nDiscTimer.OnTimer(WAIT_TMR);
      End;
     End;
     SendQry(pQR);
End;
procedure CQuerySender.OnDisconnect(var pMsg:CMessage);
Begin
     FFREE(m_byBox);
     SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_DISC_IND);
     SetState(QM_WAIT_STOP_STATE);
End;
procedure CQuerySender.OnStartCalc(pQR:PCQueryPrimitive);
Var
    pDS : CMessageData;
Begin
    Move(pQR,pDS.m_sbyInfo[0],sizeof(CQueryPrimitive));
    //SendMsgData(BOX_CSRV,0,DIR_L2TOL3,CSRV_START_CALC,pDS);
End;
procedure CQuerySender.OnChannelEnterAction(pQR:PCQueryPrimitive);
Begin
     SetDefault;
     if FCHECK(m_byBox)<>0 then SetEvent(m_hEvent);
End;
procedure CQuerySender.OnMeterFinalAction(pQR:PCQueryPrimitive);
Begin
     SendQry(pQR);
     SendMSG(pQR.m_swMtrID,BOX_L3_LME,DIR_LHTOLM3,LME_FIN_MTR_POLL_REQ,m_byID);
End;
procedure CQuerySender.OnChannelFinalAction(pQR:PCQueryPrimitive);
Begin
     m_pDS.m_swData0 := pQR.m_swVMtrID;
     m_pDS.m_swData1 := pQR.m_swMtrID;
     m_pDS.m_swData2 := pQR.m_swCmdID;
     if m_plTable.m_sbyType=DEV_COM_GSM then
     Begin
      if (m_nCF.QueryType<>QWR_FIND_SHED) then Begin SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_DISC_IND);SetState(QM_NULL_STATE);End else
      begin
       SetState(QM_WAIT_STOP_STATE);
       FFREE(m_byBox);
       SendMsgIData(BOX_L3_LME,pQR.m_swMtrID,m_byID,DIR_LHTOLM3,LME_FIN_CHN_POLL_REQ,m_pDS);
      End;
     End
     else
     Begin
      SetState(QM_NULL_STATE);
      FFREE(m_byBox);
      SendMsgIData(BOX_L3_LME,pQR.m_swMtrID,m_byID,DIR_LHTOLM3,LME_FIN_CHN_POLL_REQ,m_pDS);
      //if (m_plTable.m_nFreePort=1) then SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_FREE_PORT_IND);
     End;
End;
procedure CQuerySender.OnModemFinalAction(wMID:Word);
Begin
     SetState(QM_NULL_STATE);
     FFREE(m_byBox);
     if m_wLastCMD=QM_FIN_CHN_IND then SendMsgIData(BOX_L3_LME,wMID,m_byID,DIR_LHTOLM3,LME_FIN_CHN_POLL_REQ,m_pDS) else
     //m_blMDMState := False;
     //m_blMDMError := False;
     //if m_wLastCMD=QM_FIN_MON_IND then SendQry(@pSvQR);
End;
procedure CQuerySender.OnCommandFinalAction(pQR:PCQueryPrimitive);
Begin
     if FCHECK(m_byBox)<>0 then SetEvent(m_hEvent);
End;
procedure CQuerySender.SetState(byState:Byte);
Begin
     FState := byState;
End;
procedure CQuerySender.SetFinalEvent(wMID,wFinal:Word);
Var
     pQR : CQueryPrimitive;
Begin
     pQR.m_wLen      := sizeof(CQueryPrimitive);
     pQR.m_swVMtrID  := -1;
     pQR.m_swMtrID   := wMID;
     pQR.m_swParamID := wFinal;
     pQR.m_sbyEnable := 1;
     FPUT(m_byBox,@pQR);
End;
procedure CQuerySender.SetFinalEventEx(wVMID,wMID,wCMDID,wFinal:Integer);
Var
     pQR : CQueryPrimitive;
Begin
     pQR.m_wLen      := sizeof(CQueryPrimitive);
     pQR.m_swVMtrID  := wVMID;
     pQR.m_swMtrID   := wMID;
     pQR.m_swParamID := wFinal;
     pQR.m_swCmdID   := wCMDID;
     pQR.m_sbyEnable := 1;
     FPUT(m_byBox,@pQR);
End;
procedure CQuerySender.SetDefault;
Var
     pDS : CMessageData;
     sPT : SL1SHTAG;
Begin
     sPT.m_sbySpeed    := m_plTable.m_sbySpeed;
     sPT.m_sbyParity   := m_plTable.m_sbyParity;
     sPT.m_sbyData     := m_plTable.m_sbyData;
     sPT.m_sbyStop     := m_plTable.m_sbyStop;
     sPT.m_swDelayTime := m_plTable.m_swDelayTime;
     Move(sPT,pDS.m_sbyInfo[0],sizeof(SL1SHTAG));
     //if (m_plTable.m_nFreePort=1) then SendPMSG(BOX_L1,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_RESET_PORT_IND) else
     SendMsgIData(BOX_L1,m_plTable.m_sbyPortID,m_plTable.m_sbyPortID,DIR_L2TOL1,PH_SETPORT_IND,pDS);
End;
procedure CQuerySender.SendErrQS(wEvType:Word);
Var
     pDS : CMessageData;
     sQC : SQWERYCMDID;
Begin
     sQC.m_snABOID := m_nErAID;
     sQC.m_snSRVID := m_nErSRVID;
     sQC.m_snCLID  := m_nErCLID;
     //sQC.m_snCLSID := m_sQS.m_snCLSID;
     //sQC.m_snVMID  := pMsg.m_swObjID;
     //sQC.m_snMID   := m_sQS.m_snMID;
     //sQC.m_snResult:= m_sQS.m_snResult; //PortID
     sQC.m_snCmdID := QS_ERL2_SR;
     //sQC.m_snPrmID := m_sQS.m_snPrmID;
     Move(sQC,pDS.m_sbyInfo[0],sizeof(SQWERYCMDID));
     //Move(pDS,pMsg.m_sbyInfo[0],sizeof(CMessageData));
     SendMsgData(BOX_QSRV,wEvType,DIR_CSTOQS,QSRV_ERR_L2_REQ,pDS);
End;
procedure CQuerySender.SendMSG(wMid:Word;byBox:Integer;byFor,byType,byPort:Byte);
Var
     pMsg : CHMessage;
Begin
     With pMsg do
     Begin
      m_swLen       := 11;
      m_swObjID     := wMid;
      m_sbyFrom     := byFor;
      m_sbyFor      := byFor;
      m_sbyType     := byType;
      m_sbyTypeIntID:= 0;
      m_sbyIntID    := byPort;
      m_sbyServerID := 0;
      m_sbyDirID    := 0;
     end;
     FPUT(byBox,@pMsg);
End;
procedure CQuerySender.Run;
Begin
     try
      if m_nDiscTimer<>Nil then
      m_nDiscTimer.RunTimer;
     except
      if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(__)CL3QS::>Error Timer Routing.');
     End
End;
end.
