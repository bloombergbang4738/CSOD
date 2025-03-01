unit knsl2_HouseTask_KUB;
interface
uses
 Windows, Classes, SysUtils,SyncObjs,stdctrls,utltypes,utlbox,utlconst,utlmtimer,
 knsl3HolesFinder,knsl2qweryportpull,knsl2qweryarchmdl, knsl2meter,knsl2IRunnable,
 utldynconnect,knsl2CThreadPull,knsl2uspdKUB1meter,utlQueryQualityDyn,utlSendRecive;
 type
    CMeterTaskKUB = class(IRunnable)
     private
      meter        : CMeter;
      outMsg       : CMessage;
      inMsg        : CMessage;
      connection   : IConnection;
      m_sQC        : SQWERYCMDID; //��� �������� ���������
      SenderClass  : TSenderClass;
     protected
      procedure getInputBuffer(var V :PCMessageBuffer);
      procedure SendEventBox(_Type : Integer; _Message : String);
      procedure SendEventBoxMessage(_Type : Integer; _Message : String; msg : CMessage);            

     public
      constructor Create(var value:CMeter;var vParent:IRunnable;var vConnection:IConnection);
      destructor Destroy;override;
      function run(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime):Integer;//override;
      function runAsync(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime):Integer;
      function noputAsync:Integer;
      function findAsync(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime):Integer;
      function getOutMsg:Integer;
    End;

   type
    CTaskObjects = record
     runnble  : CMeterTaskKUB;
     pHF      : CHolesFinder;
     pump     : CDataPump;
     meter    : CMeter;
     pD       : CJoinL2;
     pDM      : CDBDynamicConn;
     res      : Integer;
    end;

    CHouseTaskKUB = class(IRunnable)
     private
      dtBegin      : TDateTime;
      dtEnd        : TDateTime;
      cmd          : Integer;
      gid          : Integer;
      aid          : Integer;
      mid          : Integer;
      isFind       : Integer;
      ErrorPercent : double;
      ErrorPercent2 : double;
      TimeToStop   : TDateTime;            
      PackedK      : Integer;
      meterPull    : CThreadPull;
      portPull     : TThreadList;
      taskUndex    : Integer;
      inMessageBuffer : CMessageBuffer;
      pDb          : CDBDynamicConn;
      pDM          : CDBDynamicConn;
      m_sQC        : SQWERYCMDID; //��� �������� ���������
      TimeInterval : Double;
      TimeCounter  : TDateTime;
      TimeStartProc: TDateTime;      
      SenderClass  : TSenderClass;
     private
      function getPortPull(plid:Integer):CPortPull;
      function isManyErrors(pDb:CDBDynamicConn;aid:Integer;vErrorPercent:double):boolean;
      function cmdToCls(cmd:Integer):Integer;
      function getL2Instance(dynConnect:CDBDynamicConn;mid:Integer):CMeter;
      procedure SendQSStatisticAbon(m_snABOID,snSRVID,m_snCLID,m_snCLSID,nCommand,m_snVMID:Integer;sdtBegin,sdtEnd:TDateTime);
      procedure SendEventBox(_Type : Integer; _Message : String);            
      function getRun(i:integer; var objs : array of CTaskObjects; gid:Integer; {var res:integer;
                       var ResDoz:integer;} var kol_Y:Integer; var kol_N:Integer;
                       CPORT:Integer; dateBegin:TDateTime; var connection : IConnection;
                       var pDb : CDBDynamicConn; var addrBegin: Integer; var addrOffset:Integer; advInfo  : SL2TAGADVSTRUCT): integer;      
     public
      function getAboID:integer;
      function getParamID:integer;
      procedure QueryStateAbon(_pDb: CDBDynamicConn);      
      constructor Create(vDtBegin,vDtEnd:TDateTime;
                              vCmd:Integer;
                              vGid :Integer;
                              vAid :Integer;
                              vMid :Integer;
                              vIsFind : Integer;
                              vIsPacketK :Integer;
                              vErrorPercent  : double;
                              vErrorPercent2 : double;
                              vTimeToStop   : TDateTime;                              
                              vPortPull:TThreadList;
                              vTaskIndex:Integer;
                              var vMeterPull:CThreadPull;
                              var vParent : IRunnable);
      destructor Destroy;override;
      function run:Integer;override;
    End;

implementation
{$R+}
constructor CMeterTaskKUB.Create(var value:CMeter; var vParent:IRunnable;var vConnection:IConnection);
Begin
    if SenderClass<>Nil then SenderClass := TSenderClass.Create;
    meter    := value;
    id       := meter.m_nP.m_swMID;
    state    := TASK_STATE_RUN;
    parent   := vParent;
    connection := vConnection;
End;

destructor CMeterTaskKUB.Destroy;
Begin
    if SenderClass<>Nil then FreeAndNil(SenderClass);
    inherited;
End;

procedure CMeterTaskKUB.getInputBuffer(var V :PCMessageBuffer);
begin
  if parent is CHouseTaskKUB then
    V := @(CHouseTaskKUB(parent).inMessageBuffer)
  else V := nil;
end;

procedure CMeterTaskKUB.SendEventBox(_Type : Integer; _Message : String);
Var s  : string;
    ID : Integer;
Begin
  ID := 0;
  s := SenderClass.ToStringBox(_Type,_Message);
  ID := GetCurrentThreadID;
  SenderClass.Send(QL_QWERYBOXEVENT,EventBoxHandle,ID,s);
End;

procedure CMeterTaskKUB.SendEventBoxMessage(_Type : Integer; _Message : String; msg : CMessage);
Var s  : string;
    ID : Integer;
Begin
  ID := 0;
  s := SenderClass.ToStringBoxMsg(_Type,_Message, msg);
  ID := GetCurrentThreadID;
  SenderClass.Send(QL_QWERYBOXEVENTMSG,EventBoxHandle,ID,s);
End;

function CMeterTaskKUB.run(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime):Integer;
Var
    index      : Integer;
    i          : Integer;
    getResult  : Integer;
    pDb        : CDBDynamicConn;
Begin
    index := 0;
    getResult := -1;
    try
     pDb  := meter.getDbConnect;
     while meter.send(outMsg) do
     Begin
       if state=TASK_STATE_KIL then
         Begin
          SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB TASK KILLED!!!');
          exit;
         End;
       if(outMsg.m_swLen<>0) then
         Begin
          connection.put(outMsg);
          SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG PUT Complette... MSG:>',outMsg);
          i   := 0;
          getResult := -1;
          while getResult<>0 do
          Begin
            getResult := connection.get(inMsg);
            //Normal get
            if getResult=0 then
            Begin
             SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG GET Complette... MSG:>',inMsg);
             if meter.EventHandler(inMsg) then
             Begin
              with meter.m_nP do
               if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
                begin
                  pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_OK);
                  inc(kol_Y);
                end;
              SendEventBox(ET_RELEASE,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG GET Complette. Len:'+IntToStr(inMsg.m_swLen));
              break;
             End else
             Begin
              getResult := -1;
             End;
            End;
            //Connect Error
            if getResult=2 then
            Begin
              with meter.m_nP do
              begin
               if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
               begin
                pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_ER);
                pDb.addErrorArch(M_SWABOID,m_swMID);
               end; 
              end;
             SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG Skip. Error In Channel!!! ');
             break;
            End;
            inc(i);
            if i>meter.m_nP.m_sbyRepMsg then
            Begin
             with meter.m_nP do
             begin
               if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
               begin
                 pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_ER);
                 pDb.addErrorArch(M_SWABOID,m_swMID);
               end;  
             end;
             getResult := -1;
             break;
            End;        //Repeat message if not get
            connection.put(outMsg);
            SendEventBoxMessage(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB.Run Repeat '+IntToStr(i)+' of '+IntToStr(meter.m_nP.m_sbyRepMsg)+'    MSG:>',outMsg);
          End;
         End
       else
         Begin
          index := index + 1;
         End;
     End;
    finally
     Result := getResult;
    end;
End;


function CMeterTaskKUB.runAsync(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime): Integer;
Var
    index      : Integer;
    i          : Integer;
    pDb        : CDBDynamicConn;
    inBuff     : PCMessageBuffer;
Begin
    index := 0;
    Result := -1;
    getInputBuffer(inBuff);
    if inBuff = nil then Exit;
    if outMsg.m_swLen = 0 then begin
      if not meter.send(outMsg) then Exit;
    end;

    if outMsg.m_swLen = 0 then Exit;
    pDb  := meter.getDbConnect;
    if (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)then
     Begin
      SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB TASK KILLED!!!');
      exit;
     End;
     if(outMsg.m_swLen<>0) then
      Begin
        connection.put(outMsg);
        SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG PUT ASYNC Complette... MSG:>',outMsg);
        i   := 0;
        Result := -1;

        while Result<>0 do Begin
          Result := connection.get(inMsg);
          //Normal get
          if Result=0 then
          Begin
           SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG GET ASYNC Complette... MSG:>',inMsg);
           SetLength(inBuff^, Length(inBuff^) + 1);
           inBuff^[High(inBuff^)] := inMsg;

           meter.m_nT.B2 := True; // ��������� ������� ���������� ������
           if meter.EventHandler(inMsg) then begin
             if meter.m_nT.B2 then begin
              with meter.m_nP do
              if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
                 begin
                  pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_OK);
                  inc(kol_Y);
                 end;
              SendEventBox(ET_RELEASE,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG GET ASYNC Complette. Len:'+IntToStr(inMsg.m_swLen));
             end
             else begin
               with meter.m_nP do
                 if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
                  begin
                   pDb.setQueryState(M_SWABOID, m_swMID, QUERY_STATE_ER);
                   inc(kol_N);
                  end;
             end;
             break;
           end
           else begin
             Result := -1;
           end;
          End;
          //Connect Error
          if Result=2 then
          Begin
            with meter.m_nP do
            begin
             if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
              begin
                pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_ER);
                pDb.addErrorArch(M_SWABOID,m_swMID);
              end;
            end;
           SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG Skip. Error In Channel!!! ');
           break;
          End;
          inc(i);
          if i>meter.m_nP.m_sbyRepMsg then
          Begin
           with meter.m_nP do
           begin
            if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
             begin
               pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_ER);
               pDb.addErrorArch(M_SWABOID,m_swMID);
             end;     
           end;
           Result := -1;
           break;
          End;        //Repeat message if not get
          connection.put(outMsg);
          SendEventBoxMessage(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB.RunAsync Repeat '+IntToStr(i)+' of '+IntToStr(meter.m_nP.m_sbyRepMsg)+'    MSG:>',outMsg);
        End;
      End
     else
      Begin
        index := index + 1;
      End;

   if Result <> 0 then
    with meter.m_nP do
     if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
      begin
       pDb.setQueryState(M_SWABOID, m_swMID, QUERY_STATE_ER);
      end;
End;

function CMeterTaskKUB.noputAsync: Integer;
begin
  Result := -1;

  if outMsg.m_swLen = 0 then begin
    if not meter.send(outMsg) then Exit;
  end;

  if outMsg.m_swLen = 0 then Exit;

  if (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)   then Begin
    SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB TASK ASYNC KILLED!!!');
    exit;
  End;
  SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG noPUT ASYNC Complette... MSG:>',outMsg);
end;

function CMeterTaskKUB.findAsync(gid:Integer;var kol_Y:Integer;var kol_N:Integer;CPORT:Integer;dateBegin:TDateTime): Integer;
var
  i      : Integer;
  vMsg   : CMessage;
  pDb    : CDBDynamicConn;
  inBuff : PCMessageBuffer;
begin
  Result := -1;
  getInputBuffer(inBuff);
  if inBuff = nil then Exit;
  connection.iconnect(meter.m_nP.m_sPhone);
  pDb  := meter.getDbConnect;
  for i := Low(inBuff^) to High(inBuff^) do begin
    if (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)   then Begin
      SendEventBox(ET_CRITICAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB TASK KILLED!!!');
      exit;
    End;

    vMsg := inBuff^[i];
    meter.m_nT.B2 := True; // ��������� ������� ���������� ������
    if meter.EventHandler(vMsg) then begin
      if meter.m_nT.B2 then begin
       with meter.m_nP do
       if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
        begin
         pDb.setQueryState(M_SWABOID,m_swMID,QUERY_STATE_OK);
         inc(kol_Y);
        end;
       SendEventBoxMessage(ET_NORMAL,'('+IntToStr(meter.m_nP.M_SWABOID)+'/'+meter.m_nP.m_sddPHAddres+')CMeterTask_KUB MSG GET BUFF Complette... MSG:>', inBuff^[i]);
      end
      else begin
        with meter.m_nP do
         if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
           begin
            pDb.setQueryState(M_SWABOID, m_swMID, QUERY_STATE_ER);
            inc(kol_N);
           end;
      end;
      Result := 0;
      break;
    end;
  end;

  if Result <> 0 then
     with meter.m_nP do
       if (meter.m_nT.CMD=QRY_NAK_EN_DAY_EP)or(meter.m_nT.CMD=QRY_NAK_EN_MONTH_EP)or(meter.m_nT.CMD=QRY_LOAD_ALL_PARAMS)then
        pDb.setQueryState(M_SWABOID, m_swMID, QUERY_STATE_ER);
end;

function CMeterTaskKUB.getOutMsg:Integer;
begin
  Result := -1;
  FillChar(outMsg, SizeOf(outMsg), 0);
  if not meter.send(outMsg) then Exit;
  Result := 0;
end;

constructor CHouseTaskKUB.Create(vDtBegin,vDtEnd:TDateTime;
                              vCmd:Integer;
                              vGid :Integer;
                              vAid :Integer;
                              vMid :Integer;
                              vIsFind : Integer;
                              vIsPacketK :Integer;
                              vErrorPercent  : double;
                              vErrorPercent2 : double;
                              vTimeToStop    : TDateTime;                              
                              vPortPull      : TThreadList;
                              vTaskIndex     : Integer;
                              var vMeterPull : CThreadPull;
                              var vParent    : IRunnable);
Begin
      if SenderClass<>Nil then SenderClass := TSenderClass.Create;
      dtBegin      := vDtBegin;
      dtEnd        := vDtEnd;
      cmd          := vCmd;
      gid          := vGid;
      aid          := vAid;
      mid          := vMid;
      isFind       := vIsFind;
      PackedK      := vIsPacketK;
      portPull     := vPortPull;
      meterPull    := vMeterPull;
      id           := aid;
      state        := TASK_STATE_RUN;
      parent       := vParent;
      ErrorPercent := vErrorPercent;
      ErrorPercent2:= vErrorPercent2;
      TimeToStop   := vTimeToStop;           
End;

destructor CHouseTaskKUB.Destroy;
Begin
    if SenderClass<>Nil then FreeAndNil(SenderClass);
    inherited;
End;
function CHouseTaskKUB.getAboID:integer;
Begin
    Result := aid;
End;
function CHouseTaskKUB.getParamID:integer;
Begin
    Result := cmd;
End;

function CHouseTaskKUB.run:Integer;
type
  CRunMode = (rmAsyncMode);
Var
    objs     :array of CTaskObjects;
    i,j        : Integer;
    pMT      : PCMeter;
    pTbl     : SQWERYMDL;
    pDb      : CDBDynamicConn;
    data     : TThreadList;
    vList    : TList;
    pull     : CPortPull;
    res      : Integer;
    connection : IConnection;
    findData : Boolean;
    dateEnd,dateBegin  : TDateTime;
    slv      : TStringList;
    advInfo  : SL2TAGADVSTRUCT;
    addrBegin, addrOffset :Integer;
    ResDoz   : Integer;
    IDCHANNELGSM  : Integer;
    CPORT         : Integer;
    kol_N,kol_Y   : Integer;    
    ErrorExit     : Integer;    
Begin
    try
     try
      TimeInterval := TimeToStop - trunc(TimeToStop);//StrToTime('00:15:00');
      Result:= 0;
      ResDoz:= 0;
      res   := 0;
      i     := 0;
      CPORT := 0;
      kol_N := 0;
      kol_Y := 0;    
      SetLength(inMessageBuffer, 0);
      findData := False;
      vList    := nil;
      dateBegin:=now;    
      SendEventBox(ET_NORMAL,'('+IntToStr(aid)+')CHouseTask_KUB Begin...');
      data := TThreadList.Create;

      pDb  := CDBDynamicConn.Create();
      pDb.Create(pDb.InitStrFileName);
      
      pDb.GetAbonL2Join(gid,aid,data);

      if (cmd=QRY_DATA_TIME) then
        begin
         SendEventBox(ET_NORMAL,'('+IntToStr(aid)+')CHouseTask_KUB Correction Time Begin...');
         data.LockList.Count:=1;
        end;
      
      if (cmd=QRY_NAK_EN_MONTH_EP)then  if ((isFind=0)and(mid=-1)) then pDb.DelArchData(dtEnd,dtBegin,aid,cmd);

      if (cmd=QRY_NAK_EN_DAY_EP)or(cmd=QRY_NAK_EN_MONTH_EP)or(cmd=QRY_LOAD_ALL_PARAMS)then if isFind=0 then

      pDb.setQueryState(aid,mid,QUERY_STATE_NO);
      vList := data.LockList;
      SetLength(objs, vList.count);
      dateEnd:=now;
      pDb.setDtBeginEndInQueryQroup(aid,now,dateEnd,TASK_QUERY_WAIT);

      if (vList.count>0) then
        Begin
         objs[0].pD := vList[0];
         pull := getPortPull(objs[0].pD.m_swPullID);
         if pull=nil then exit;
         IDCHANNELGSM := 0;
         connection := pull.getConnection(IDCHANNELGSM);
         pDb.SetChannelGSM(aid,IDCHANNELGSM,CPORT);//�������� �� ������ ����� ����� ����� �����
         SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY_WAIT,CPORT,now,dateEnd);     
         connection.clearHistory;
        End;
        SendEventBox(ET_NORMAL,'('+IntToStr(aid)+')CHouseTask_KUB Device Received.');
        addrBegin := -1; addrOffset := 0;
     except
      SendEventBox(ET_CRITICAL,'('+IntToStr(aid)+')CHouseTask_KUB TASK ERROR!!!');
      exit;
     end;
        //for i:=0 to vList.count-1 do
     while i<vList.count do
     Begin
      try
        if (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL) then
        Begin
         SendEventBox(ET_CRITICAL,'('+IntToStr(aid)+')CHouseTask_KUB TASK KILLED!!!');
         pDb.setDtEndInQueryQroup(aid,now,TASK_HAND_STOP);
         SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_HAND_STOP,CPORT,dateBegin,now);       
         res:=4;
         ResDoz:=2;
         exit;
        End;
        objs[i].pD := vList[i];
        pTbl.m_snAID  := aid;
        pTbl.m_snVMID := objs[i].pD.m_swVMID;
        pTbl.m_snMID  := objs[i].pD.m_swMID;
        if(mid<>-1) then
        Begin
         if (mid<>objs[i].pD.m_swMID) then continue;
        End;
        if (i=0)then begin
          objs[i].pDM  := CDBDynamicConn.Create();
          objs[i].pDM.Create(objs[i].pDM.InitStrFileName);
        end
        else objs[i].pDM := objs[0].pDM;

        objs[i].meter := getL2Instance(objs[0].pDM,pTbl.m_snMID);
        objs[i].meter.m_nT.CMD:=cmd;//�������� ������� ��� ����������� � Meter.run � ��
        if cmdToCls(cmd)=CLS_MGN then
         begin
          objs[i].meter.PObserver.LoadParamQS(cmd);
         end
        else
        Begin
         objs[i].pHF  := CHolesFinder.Create(pDb);
         objs[i].pump := CDataPump.Create(nil,objs[i].pHF,objs[i].meter,@pTbl,cmd);
         if isFind=1 then findData := objs[i].pump.PrepareFind(dtBegin,dtEnd,pTbl.m_snVMID,cmdToCls(cmd));
         objs[i].pump.SetPump(dtBegin,dtEnd,pTbl.m_snMID,cmdToCls(cmd),0);
         objs[i].pump.Start;
         while(objs[i].pump.Next) do;
        End;
        SendEventBox(ET_NORMAL,'('+IntToStr(aid)+')CHouseTask_KUB QUERY meter �:'+IntToStr(objs[i].meter.m_nP.m_swMID)+' kv �:'+objs[i].meter.m_nP.m_sddPHAddres);
        if ((isFind=1) and (findData=false)) then
         with objs[i].meter.m_nP do
          if (cmd=QRY_NAK_EN_DAY_EP)or(cmd=QRY_NAK_EN_MONTH_EP)or(cmd=QRY_LOAD_ALL_PARAMS)then
           begin
            pDb.setQueryState(aid,m_swMID,QUERY_STATE_OK);
            inc(kol_Y);
            SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY_WAIT,CPORT,dateBegin,now);
           end;
        if (isFind=0) or ((isFind=1) and (findData=true)) then
         Begin
          if isManyErrors(pDb,aid,ErrorPercent) then
          Begin
           SendEventBox(ET_NORMAL,'('+IntToStr(aid)+'/'+objs[i].meter.m_nP.m_sddPHAddres+')CHouseTask_KUB Query Connection=ERR:>Many Errors In House!!!');
           res:=3;
           exit;
          End;
           if (i=0) then
           begin
             pDb.setDtBeginEndInQueryQroup(aid,now,now,CALL_STATE);//��������� ������
             SendQSStatisticAbon(aid,gid,kol_Y,kol_N,CALL_STATE,CPORT,now,now);
           end;

          connection.iconnect(objs[i].meter.m_nP.m_sPhone);
          if ((i=0)or(isFind=1)) and (connection.getConnectionState=PULL_STATE_CONN) then
             TimeStartProc := Now
          else
          if ((i=0)or(isFind=1)) and (connection.getConnectionState=PULL_STATE_ERR) then
           Begin
            SendEventBox(ET_NORMAL,'('+IntToStr(aid)+'/'+objs[i].meter.m_nP.m_sddPHAddres+')CHouseTask SKIP Query Connection=ERR:>');
            if objs[0].pDM<>Nil then begin
             objs[0].pDM.Disconnect;
             FreeAndNil(objs[0].pDM);
            end;
            res:=2;
            ResDoz:=1;
            exit;
           End;

          TimeCounter := Now;
          if TimeStartProc + TimeInterval < TimeCounter then
          exit;

          if (i=0) and (connection.getConnectionState=PULL_STATE_CONN) then
           begin
            pDb.setDtBeginEndInQueryQroup(aid,now,0,TASK_QUERY);//������ ������
            SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY,CPORT,dateBegin,0);
           end;

           objs[i].runnble := CMeterTaskKUB.Create(objs[i].meter,IRunnable(self),connection);
           slv := TStringList.Create;
           objs[i].meter.getStrings(objs[i].meter.m_nP.m_sAdvDiscL2Tag,slv);
           if slv[0]='' then slv[0] := '0';
           if slv[2]='' then slv[2] := '0';
           advInfo.m_sKoncFubNum  := slv[0];
           advInfo.m_sKoncPassw   := slv[1];
           advInfo.m_sAdrToRead   := slv[2];
           slv.Clear;
           FreeAndNil(slv);//.Destroy;
           if addrBegin = -1 then addrBegin := StrToInt(advInfo.m_sAdrToRead);

           if PackedK=1 then
            begin
              if ((i mod 4) = 0) or (i = High(objs)) then
                begin // �� 40 ����� �������
                   ErrorExit := getRun(i, objs, gid, {res, ResDoz,} kol_Y, kol_N, CPORT, dateBegin, connection, pDb,addrBegin,addrOffset,advInfo);
                    if ErrorExit <> 0 then begin
                      if ErrorExit = 1 then Exit;  // Exit for Time collapse
                      if ErrorExit = 2 then begin  // Exit for (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)
                        res := 4;
                        ResDoz:=2;
                        Exit;
                      end;
                      if ErrorExit = 3 then begin   // Exit for  connection.getConnectionState=PULL_STATE_ERR
                        res := 2;
                        ResDoz:=1;
                        Exit;
                      end;
                    end;
                end
              else
              begin
                objs[i].runnble.noputAsync(); // ������������ ������� ��� �������� � �����
              end;
            end
           else
            begin
             if ((i mod 1)=0) or (i = High(objs)) then
                  begin // �� 40 ����� �������
                   ErrorExit := getRun(i, objs, gid, {res, ResDoz,} kol_Y, kol_N, CPORT, dateBegin, connection, pDb,addrBegin,addrOffset,advInfo);
                    if ErrorExit <> 0 then begin
                      if ErrorExit = 1 then Exit;  // Exit for Time collapse
                      if ErrorExit = 2 then begin  // Exit for (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)
                        res := 4;
                        ResDoz:=2;
                        Exit;
                      end;
                      if ErrorExit = 3 then begin   // Exit for  connection.getConnectionState=PULL_STATE_ERR
                        res := 2;
                        ResDoz:=1;
                        Exit;
                      end;
                    end;
                  end
             else
              begin
               objs[i].runnble.noputAsync(); // ������������ ������� ��� �������� � �����
              end;
            end;
          inc(i);
         End
        else inc(i);
      except
       if (cmd=QRY_NAK_EN_DAY_EP)or(cmd=QRY_NAK_EN_MONTH_EP)or(cmd=QRY_LOAD_ALL_PARAMS)then
       begin
         pDb.setQueryState(aid,objs[i].meter.m_nP.m_swMID,QUERY_STATE_ER);
         pDb.addErrorArch(aid,objs[i].meter.m_nP.m_swMID);
         SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY,CPORT,dateBegin,now);//+1         
       end;
       SendEventBox(ET_CRITICAL,'('+IntToStr(aid)+')CHouseTask_KUB Error in meter �:'+IntToStr(objs[i].meter.m_nP.m_swMID)+' kv �:'+objs[i].meter.m_nP.m_sddPHAddres);
       inc(i);
      end;
     End;

    finally
       if (res=0) or (res=-1) then
        begin
           if (cmd=QRY_DATA_TIME)then
            begin
             pDb.setDtEndInQueryQroup(aid,now,TASK_DATE_TIME_COR); //������������� ������� ������� ���������
             SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_DATE_TIME_COR,CPORT,dateBegin,now);
            end
           else
            begin
             pDb.setDtEndInQueryQroup(aid,now,TASK_QUERY_COMPL);    //����� ������
             SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY_COMPL,CPORT,dateBegin,now);           
            end;
        end
       else if (res=2)then
        begin
         pDb.setDtEndInQueryQroup(aid,now,TASK_CONN_ERR); //������ ����������
         SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_CONN_ERR,CPORT,dateBegin,now);       
        end
       else if (res=3)then
        begin
         pDb.setDtEndInQueryQroup(aid,now,TASK_MANY_ERR); //�������� ������ ������
         SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_MANY_ERR,CPORT,dateBegin,now);       
        end
       else if (res=4)then
        begin
         pDb.setDtEndInQueryQroup(aid,now,TASK_HAND_STOP);//������������� ����������
          SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_HAND_STOP,CPORT,dateBegin,now);       
        end;
       for i := Low(objs) to High(objs) do
        begin
         if i=0 then
          if objs[0].pDM<>Nil then begin
           objs[0].pDM.Disconnect;
           FreeAndNil(objs[0].pDM);
          end;
         if objs[i].runnble<>nil then FreeAndNil(objs[i].runnble);
         if objs[i].pHF<>nil then FreeAndNil(objs[i].pHF);
         if objs[i].pump<>nil then FreeAndNil(objs[i].pump);
         if objs[i].meter<>nil then FreeAndNil(objs[i].meter);
        end;

      if (vList<>nil)then
       begin
        data.UnLockList;
        i:=0;
        while i < vList.Count do
          begin
           objs[i].pD := vList[i];
           if objs[i].pD<>Nil then FreeAndNil(objs[i].pD);
           vList.Delete(i);
          end;
        if data<>Nil then FreeAndNil(data);
       end;

       QueryStateAbon(pDb);
       SendEventBox(ET_NORMAL,'('+IntToStr(aid)+')CHouseTask_KUB End.');
     
       pDb.SetResetChannelGSM(aid,-1);//�������� �� ������ ����� ����� ����� �����
       if pDb<>Nil then
        begin
         pDb.Disconnect;
         FreeAndNil(pDb);
        end;
       if (connection<>nil) then  connection.iclose;
       Result:=ResDoz;
    end;
End;

function CHouseTaskKUB.getRun(i:integer; var objs : array of CTaskObjects; gid:Integer;
                                  var kol_Y:Integer; var kol_N:Integer;
                                  CPORT:Integer; dateBegin:TDateTime; var connection : IConnection;
                                  var pDb : CDBDynamicConn; var addrBegin: Integer; var addrOffset:Integer; advInfo  : SL2TAGADVSTRUCT) : integer;
var j:integer;
begin
  Result := 0;
  TimeCounter := Now;
  if TimeStartProc + TimeInterval < TimeCounter then begin
     Result := 1;
     exit;     // �������� ����������� ������� ������ �� ������
  end;
  if (state=TASK_STATE_KIL) or (parent.getTaskState=TASK_STATE_KIL)   then
  Begin
    SendEventBox(ET_CRITICAL,'('+IntToStr(aid)+')CHouseTask_KUB TASK KILLED!!!');
//     res := 4;
//     ResDoz:=2;
    Result := 2;
    exit;
  End;
  SetLength(inMessageBuffer, 0); // ������� ���������� �������� �����
  objs[i].meter.m_nP.m_sddPHAddres2 := IntToStr(addrBegin); // ��������� ����� ������
  addrOffset := StrToInt(advInfo.m_sAdrToRead) - addrBegin; // ��������
  objs[i].meter.m_nP.m_swAddrOffset := addrOffset;
  addrBegin := -1;
   if (cmd=QRY_DATA_TIME) then
      objs[i].res := objs[i].runnble.run(gid,kol_Y,kol_N,CPORT,dateBegin)// ������ ������ ������� ������� � �������
   else
   objs[i].res := objs[i].runnble.runAsync(gid,kol_Y,kol_N,CPORT,dateBegin); // ������ ������ ������� ������� � �������

   for j := i - addrOffset to Pred(i) do
    begin
     objs[j].meter.m_nP.m_swAddrOffset := j - i + addrOffset;
     objs[j].res := objs[j].runnble.findAsync(gid,kol_Y,kol_N,CPORT,dateBegin); // ��������� ��������� �������
    end;
  SendQSStatisticAbon(aid,gid,kol_Y,kol_N,TASK_QUERY,CPORT,dateBegin,now);        
end;

procedure CHouseTaskKUB.SendQSStatisticAbon(m_snABOID,snSRVID,m_snCLID,m_snCLSID,nCommand,m_snVMID:Integer;sdtBegin,sdtEnd:TDateTime);
Var
     pDS : CMessageData;
     sQC : SQWERYCMDID;
     s   : string;
     ID : Integer;         
Begin
     ID := 0;
     ID := GetCurrentThreadID;
     Move(m_sQC,sQC,sizeof(SQWERYCMDID));
     sQC.m_snABOID  := m_snABOID;  //ID HOUSE
     sQC.m_snSRVID  := snSRVID;    //id ������
     sQC.m_snCLID   := m_snCLID;   //Kol-vo ����������
     sQC.m_snCLSID  := m_snCLSID;   //Kol-vo �� ����������
     sQC.m_snCmdID  := nCommand;   //�������  � ���������
     sQC.m_snVMID   := m_snVMID;   //����� �����
     sQC.m_sdtBegin := sdtBegin;   //������ ������� ������
     sQC.m_sdtEnd   := sdtEnd;     //����� ������� ������

     Move(sQC,pDS.m_sbyInfo[0],sizeof(SQWERYCMDID));
     pDS.m_swData4 := MTR_LOCAL;
     s := SenderClass.ToString(sQC);
     SenderClass.Send(QL_QWERYSTATISTICABON_REQ,TQweryModuleHandle,ID,s);
End;

procedure CHouseTaskKUB.SendEventBox(_Type : Integer; _Message : String);
Var s  : string;
    ID : Integer;
Begin
  ID := 0;
  s := SenderClass.ToStringBox(_Type,_Message);
  ID := GetCurrentThreadID;
  SenderClass.Send(QL_QWERYBOXEVENT,EventBoxHandle,ID,s);
End;

procedure CHouseTaskKUB.QueryStateAbon(_pDb: CDBDynamicConn);
var
    QQ  : TQueryQualityDyn;
    MDQ : TQQData;  // ��� ������
    year, month, day :word;
    DateNow :TDateTime;
begin
     QQ := TQueryQualityDyn.Create;
     DecodeDate(Now, year, month, day);
      if (cmd=QRY_NAK_EN_MONTH_EP)then
       begin
        MDQ := QQ.GetQQMonths(_pDb,aid);  // �������� ������ �����
        DateNow := EncodeDate(year,month,1);
       end
      else if (cmd=QRY_NAK_EN_DAY_EP)then
       begin
        DateNow := EncodeDate(year,month,day);
        MDQ := QQ.GetQQDays(_pDb,aid);  // �������� ������ �����
       end
      else
        begin
         DateNow := EncodeDate(year,month,day);
         MDQ := QQ.GetQQCurrs(_pDb,aid);  // �������� ������ �����
        end;
       if (DateNow=dtBegin) then
         begin
          if (MDQ.Perc < ERRORPERCENT2) or (MDQ.Perc=255) then
           begin
             MDQ.Dats := dtBegin;             // ���� ������
             MDQ.Stat := 0;                  // �� �����
             MDQ.Perc := trunc(QQ.GetPercent(_pDb,aid)); //������� ���������� �� �������
             if(cmd=QRY_NAK_EN_MONTH_EP)then
             QQ.SetQQMonths(_pDb,aid, MDQ)   // ��������� ������ ����� (��������� �������� ��������� �����������)
             else if (cmd=QRY_NAK_EN_DAY_EP)then
             QQ.SetQQDays(_pDb,aid, MDQ)     // ��������� ������ ����  (��������� �������� ��������� �����������)
             else if (cmd=QRY_ENERGY_SUM_EP)then
             QQ.SetQQCurrs(_pDb,aid, MDQ);    // ��������� ������ �������  (��������� �������� ��������� �����������)
           end;
         end
       else
         begin
           if (dtBegin=MDQ.Dats)then
            begin
             if (MDQ.Perc < ERRORPERCENT2) or (MDQ.Perc=255) then
              begin
                MDQ.Dats := dtBegin;             // ���� ������
                MDQ.Stat := 0;                  // �� �����
                MDQ.Perc := trunc(QQ.GetPercent(_pDb,aid)); //������� ���������� �� �������
                if(cmd=QRY_NAK_EN_MONTH_EP)then
                QQ.SetQQMonths(_pDb,aid, MDQ)   // ��������� ������ ����� (��������� �������� ��������� �����������)
                else if (cmd=QRY_NAK_EN_DAY_EP)then
                QQ.SetQQDays(_pDb,aid, MDQ)     // ��������� ������ ����  (��������� �������� ��������� �����������)
                else if (cmd=QRY_ENERGY_SUM_EP)then
                QQ.SetQQCurrs(_pDb,aid, MDQ);    // ��������� ������ �������  (��������� �������� ��������� �����������)
              end;
            end;
            if (dtBegin>MDQ.Dats)then
             begin
              MDQ.Dats := dtBegin;             // ���� ������
              MDQ.Stat := 0;                  // �� �����
              MDQ.Perc := trunc(QQ.GetPercent(_pDb,aid)); //������� ���������� �� �������
              if(cmd=QRY_NAK_EN_MONTH_EP)then
              QQ.SetQQMonths(_pDb,aid, MDQ)   // ��������� ������ ����� (��������� �������� ��������� �����������)
              else if (cmd=QRY_NAK_EN_DAY_EP)then
              QQ.SetQQDays(_pDb,aid, MDQ)     // ��������� ������ ����  (��������� �������� ��������� �����������)
              else if (cmd=QRY_ENERGY_SUM_EP)then
              QQ.SetQQCurrs(_pDb,aid, MDQ);    // ��������� ������ �������  (��������� �������� ��������� �����������)
             end;
            if (dtBegin<MDQ.Dats)then
             begin
               SendEventBox(ET_CRITICAL,'������ �������� �������� �� ���� ����������� ��-�� dtBegin<MDQ.Dats');
             end;
         end;
   FreeAndNil(QQ);
end;


function CHouseTaskKUB.isManyErrors(pDb:CDBDynamicConn;aid:Integer;vErrorPercent:double):boolean;
Var
    data : QGABONS;
    quality : double;
Begin
    data := QGABONS.Create;
    data.ALLCOUNTER := 1000;
    data.ISOK := 0;
    data.ISER := 0;
    pDb.GetQueryAbonsError(aid,data);
    quality := 100*data.ISER/data.ALLCOUNTER;
    if quality>vErrorPercent then
    Begin
     Result := true;
     FreeAndNIl(data);
     exit;
    End;
    FreeAndNIl(data);
    Result := false;
End;

function CHouseTaskKUB.getPortPull(plid:Integer):CPortPull;
Var
    vList : TList;
    i     : Integer;
    pD    : CPortPull;
begin
    Result := nil;
    vList := portpull.LockList;
    try
    for i:=0 to vList.Count-1 do
    Begin
     pD := vList[i];
     if pD.getPullID=plid then
     Begin
      Result := pD;
      exit;
     End;
    End;
    finally
     portPull.UnLockList;
    end;
end;

function CHouseTaskKUB.getL2Instance(dynConnect:CDBDynamicConn;mid:Integer):CMeter;
Var
    meter  : CMeter;
    pTable : SL2TAG;
Begin
    if (dynConnect.GetMMeterTableEx(mid,pTable)) then
     Begin
      case pTable.m_sbyType of
       MET_USPDKUB        : meter := CUSPDKUB1Meter.Create;
      End;
     End;
     if meter<>nil then
      Begin
       meter.setDbConnect(dynConnect);
       meter.Init(pTable);
      End;
     Result := meter;
End;

function CHouseTaskKUB.cmdToCls(cmd:Integer):Integer;
Begin
     if(((cmd>=QRY_ENERGY_SUM_EP) and (cmd<=QRY_ENERGY_SUM_EP)) or
        (cmd=QRY_DATA_TIME) or
        (cmd=QRY_LOAD_ALL_PARAMS) or
        ((cmd=QRY_ENTER_COM)or(cmd=QRY_EXIT_COM)) or
        ((cmd>=QRY_MGAKT_POW_S) and (cmd<=QRY_FREQ_NET))) then
     Begin
      Result := CLS_MGN;
      exit;
     End else
     if(((cmd>=QRY_ENERGY_DAY_EP) and (cmd<=QRY_ENERGY_DAY_RM)) or
        ((cmd>=QRY_NAK_EN_DAY_EP) and (cmd<=QRY_NAK_EN_DAY_RM))) then
     Begin
      Result := CLS_DAY;
      exit;
     End else
     if(((cmd>=QRY_ENERGY_MON_EP) and (cmd<=QRY_ENERGY_MON_RM)) or
        ((cmd>=QRY_NAK_EN_MONTH_EP) and (cmd<=QRY_NAK_EN_MONTH_RM))) then
     Begin
      Result := CLS_MONT;
      exit;
     End else
     if((cmd>=QRY_SRES_ENR_EP) and (cmd<=QRY_SRES_ENR_RM)) then
     Begin
      Result := CLS_GRAPH48;
      exit;
     End else
     if(cmd=QRY_DATA_TIME) then
     Begin
      Result := CLS_TIME;
      exit;
     End else
     if((cmd>=QRY_JRNL_T1) and (cmd<=QRY_JRNL_T4)) then
     Begin
      Result := CLS_EVNT;
      exit;
     End
End;


end.
