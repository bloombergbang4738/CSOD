unit knsl2qweryportpull;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,ExtCtrls,
utldynconnect,knsl3EventBox,knsl1cport,utldatabase,knsl1module;

type
{
    SL2PORTPULL = packed record
     id              : Integer;
     pullid          : Integer;
     connstring      : String[50];
     item            : SL2PORTPULL;
    end;
    PSL2PORTPULL =^ SL2PORTPULL;
    SL2PORTPULLS = packed record
     id              : Integer;
     Count           : Integer;
     pulltype        : Integer;
     name            : String[50];
     items           : array of SL2PORTPULL;
    end;
    PSL2PORTPULLS =^ SL2PORTPULLS;
}

   IConnection = class
    protected
     semaphore : THandle;
     timer     : TTimer;
     busy      : Boolean;
     param     : CL2Pull;
     csBusy    : TCriticalSection;
     connectionState : Integer;
     oldOptions: String;
    private
     procedure OnTimeElapsed(Sender:TObject);dynamic;
     function iput(var pMsg:CMessage):Boolean;
     function iget(var pMsg:CMessage):Integer;
    public
     function iconnect(options:String):Integer;
     procedure clearHistory;
     function getConnectionState:Integer;
     function setConnectionState:Integer;
     function IsBusy():boolean;
     function IsParam():integer;
     procedure setBusyState(vState:Boolean);
    public
     constructor Create(value:CL2Pull;var sem:THandle);
     destructor Destroy;override;
     function iclose:boolean;
     function getConfig:CL2Pull;
     function put(var pMsg:CMessage):Boolean;virtual; abstract;
     function get(var pMsg:CMessage):Integer;virtual; abstract;
    protected
     function connect(options:String):Integer;virtual;abstract;
     function close:boolean;virtual;abstract;
    End;
    PIConnection = ^IConnection;
    GsmConnection = class(IConnection)
     private
      testMsg : CMessage;
      port    : CPort;
      handleComm : THandle;
     function OpenPhone(strPhone:String):CMessage;
     function CreateMsg(byType:Byte;var pDS:CMessageData):CMessage;
     public
      constructor Create(value:CL2Pull;var sem:THandle);
      function connect(options:String):Integer; override;
      function close:boolean; override;
      function put(var pMsg:CMessage):Boolean; override;
      function get(var pMsg:CMessage):Integer; override;
    End;

     ComConnection = class(IConnection)
     private
      testMsg : CMessage;
      port    : CPort;
      handleComm : THandle;
     function CreateMsg(byType:Byte;var pDS:CMessageData):CMessage;
     public
      constructor Create(value:CL2Pull;var sem:THandle);
      function connect(options:String):Integer; override;
      function close:boolean; override;
      function put(var pMsg:CMessage):Boolean; override;
      function get(var pMsg:CMessage):Integer; override;
    End;


    TcpConnection = class(IConnection)
     private
      testMsg : CMessage;
      port    : CPort;
     public
      constructor Create(value:CL2Pull;var sem:THandle);
      function connect(options:String):Integer; override;
      function close:boolean; override;
      function put(var pMsg:CMessage):Boolean; override;
      function get(var pMsg:CMessage):Integer; override;
    End;

    UdpConnection = class(IConnection)
     public
      constructor Create(value:CL2Pull;var sem:THandle);
      function connect(options:String):Integer; override;
      function close:boolean; override;
      function put(var pMsg:CMessage):Boolean; override;
      function get(var pMsg:CMessage):Integer; override;
    End;

    CFlyConnectionEntityFactory = class
     private
      semaphore : THandle;
     public
      constructor Create(var value:THandle);
     public
      function getInstance(options:CL2Pull;meta:CL2Pulls):IConnection;
    End;

    CPortPull = class
     protected
      semaphore   : THandle;
      pull        : TThreadList;
      configMap   : CL2Pulls;
      connFactory : CFlyConnectionEntityFactory;
     public
      constructor Create(value:CL2Pulls);
      destructor Destroy;override;
      function getConnection(var getIdChannel:integer):IConnection;
      function getPullID:Integer;
    End;

implementation

{
    CL2Pulls = class
     public
      ID             : INTEGER;
      PULLTYPE       : String[20];
      DESCRIPTION    : String[50];
      item           : TStringList;
      procedure clear;
    end;

    CL2Pull = class
     public
      ID                : INTEGER;
      PULLID            : INTEGER;
      CONNECTIONTIMEOUT : INTEGER;
      CONNSTRING        : String[50];
      RECONNECTIONS     : INTEGER;
      STATE             : SMALLINT;
    end;
}
//CQweryServers
constructor CPortPull.Create(value:CL2Pulls);
Var
    i          : Integer;
    pullSize   : Integer;
    pullOption : CL2Pull;
    connection : IConnection;
    vList      : TList;
Begin
    configMap   := value;
    pull        := TThreadList.Create;
    pullSize    := configMap.item.LockList.Count;
    configMap.item.UnLockList;
    semaphore   := CreateSemaphore(nil,pullSize,pullSize,nil);
    connFactory := CFlyConnectionEntityFactory.Create(semaphore);
    vList       := configMap.item.LockList;
    try
    for i:=0 to vList.Count-1 do
    Begin
     pullOption := vList[i];
     //if(pullOption.STATE=1)then
     Begin
      connection := connFactory.getInstance(pullOption,configMap);
      pull.LockList.add(connection);
      pull.UnlockList;
     End;
    End;
    finally
     configMap.item.UnLockList;
    End;
End;
destructor CPortPull.Destroy;
Begin
  ClearListAndFree(pull);
  if configMap <> nil then FreeAndNil(configMap);
  if connFactory <> nil then FreeAndNil(connFactory);
  //ReleaseSemaphore(semaphore, 0, 0);
  inherited;
End;

function CPortPull.getPullID:Integer;
Begin
    Result := configMap.ID;
End;
function CPortPull.getConnection(var getIdChannel:integer):IConnection;
Var
    i  : Integer;
    rc : Word;
    connection : IConnection;
    vList : TList;
Begin
    getIdChannel:= 0;
    //if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(getPullID)+')CPortPull �������� getConnection('+options+') ... ');
    rc := WaitForSingleObject(semaphore,INFINITE);
    case RC of
    WAIT_OBJECT_0:
    Begin
     vList := pull.LockList;
     try
     for i :=0 to vList.Count-1 do
     begin
      connection :=  vList[i];
      if connection.IsBusy=false then
      begin
       if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(getPullID)+','+IntToStr(connection.IsParam)+')CPortPull �������� ���� getConnection('+connection.getConfig.CONNSTRING+') ... ');
       //connection.iconnect(options);
       //getIdChannel:=connection.  getPullID;
       getIdChannel:=connection.IsParam;
       connection.setBusyState(true);
       Result := connection;
       Exit;
      end;
     end;
      finally
      pull.UnLockList;
     end;
    End;
    End;
    //ReleaseSemaphore(semaphore,1,nil);
End;

//IConnection
constructor IConnection.Create(value:CL2Pull;var sem:THandle);
Begin
    semaphore      := sem;
    busy           := false;
    param          := value;
    timer          := TTimer.Create(Nil);
    csBusy         := TCriticalSection.Create;
    timer.Interval := param.CONNECTIONTIMEOUT*1000;
    timer.Enabled  := false;
    timer.OnTimer  := OnTimeElapsed;
End;
destructor IConnection.Destroy;
Begin
  if timer <> nil then FreeAndNil(timer);
  if csBusy <> nil then FreeAndNil(csBusy);
  inherited;
End;
procedure IConnection.clearHistory;
Begin
    oldOptions := '';
End;
function IConnection.getConnectionState:Integer;
Begin
    Result := connectionState;
End;

function IConnection.setConnectionState:Integer;
Begin
    connectionState:=PULL_STATE_CONN;
    Result := connectionState;
End;

function IConnection.iconnect(options:String):Integer;
Begin
    //csBusy.Enter;
    //busy := true;
    //csBusy.Leave;
    //timer.Interval := param.CONNECTIONTIMEOUT*1000;
    //timer.Enabled  := true;
    //if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'('+IntToStr(param.PULLID)+')CPortPull ���������� ������������'+param.CONNSTRING+') ... ');
    connectionState := connect(options);
    Result := connectionState;
End;
function IConnection.getConfig:CL2Pull;
Begin
    Result := param;
End;
function IConnection.iput(var pMsg:CMessage):Boolean;
Begin
    //timer.Interval := param.CONNECTIONTIMEOUT*1000;
    //timer.Enabled  := true;
    result := put(pMsg);
End;
function IConnection.iget(var pMsg:CMessage):Integer;
Begin
    //timer.Interval := param.CONNECTIONTIMEOUT*1000;
    //timer.Enabled  := true;
    result := get(pMsg);
End;
procedure IConnection.OnTimeElapsed(Sender:TObject);
Begin
   try
    csBusy.Enter;
    //if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'('+IntToStr(param.PULLID)+')IConnection �������� ������ ����� ����������...');
    iclose;
    csBusy.Leave;
   except
     if EventBox<>Nil then EventBox.FixEvents(ET_Critical,'('+IntToStr(287)+' ������)Connection.OnTimeElapsed!!!');
   end;
End;
function IConnection.iclose:boolean;
Begin
    close;
    csBusy.Enter;
    busy := false;
    csBusy.Leave;
    //timer.Enabled := false;
    ReleaseSemaphore(semaphore,1,nil);
    if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')IConnection Connection Free port: '+param.CONNSTRING);
End;
procedure IConnection.setBusyState(vState:Boolean);
Begin
    csBusy.Enter;
    busy := vState;
    csBusy.Leave;
End;
function IConnection.IsBusy:Boolean;
Begin
    csBusy.Enter;
    Result := busy;
    csBusy.Leave;
End;

function IConnection.IsParam:integer;
begin
    csBusy.Enter;
    Result := param.PORTID;
    csBusy.Leave;
end;

//GsmConnection
constructor GsmConnection.Create(value:CL2Pull;var sem:THandle);
Begin
    Inherited Create(value,sem);
End;

function GsmConnection.OpenPhone(strPhone:String):CMessage;
Var
    pDS  : CMessageData;
    nLen : Integer;
    i    : Integer;
Begin
    nLen          := Length(strPhone)+1;
    pDS.m_swData0 := nLen-1;
    pDS.m_swData1 := 40;
    if nLen<50 then
    Begin
     for i:=0 to nLen-1 do pDS.m_sbyInfo[i] := Byte(strPhone[i+1]);
     pDS.m_sbyInfo[nLen] := Byte(#0);
     Result := CreateMsg(PH_CONN_IND,pDS);
    End;
End;
function GsmConnection.CreateMsg(byType:Byte;var pDS:CMessageData):CMessage;
Var
    pMsg : CMessage;
Begin
    With pMsg do
    Begin
     m_swObjID     := 0;
     m_sbyFrom     := 0;
     m_sbyFor      := 0;
     m_sbyType     := 0;
     m_sbyTypeIntID:= 0;
     m_sbyIntID    := 0;
     m_sbyServerID := 0;
     m_sbyDirID    := 0;
     Move(pDS,m_sbyInfo[0],sizeof(pDS));
     m_swLen       := 13 + sizeof(pDS);
    end;
    Result := pMsg;
End;
{
  PULL_STATE_CONN = 0;
  PULL_STATE_DISC = 1;
  PULL_STATE_ERR  = 2;
}
function GsmConnection.connect(options:String):Integer;
Var
     index : Integer;
     pMsg  : CMessage;
     i,j   : Integer;
Begin
 try
     i:=0;j:=0;
     index := param.PORTID;
//     if assigned(mL1Module) then
//       if mL1Module.m_pPort[index]=nil then
//       begin
//         mL1Module.InitIndex(index);
//         port := mL1Module.m_pPort[index];
//       end;
////     port := mL1Module.m_pPort[index];
//      if port=nil then
//        begin
//          if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(Error GsmConnection.connect!!! �� ���������� ����� Gsm �����');
//          exit;
//        end;
     port := mL1Module.m_pPort[index];
     if (oldOptions=options) and (connectionState=PULL_STATE_ERR) then
     Begin
      Result := PULL_STATE_ERR;
      exit;
     End;

     while port.m_byWaitState<>WAIT_NUL do
     Begin
       //if (port.m_byState=ST_CONN_L1) or (port.m_byState=ST_DISC_L1) then break;
       if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+','+IntToStr(param.PORTID)+')GSMConnection.connect Wait Port '+IntToStr(j)+' of 5 5000ms');
       sleep(5000);
       j := j + 1;
       if(j>5) then break;
     End;
     j:=0;
    // sleep(1000);     
     pMsg := OpenPhone(options);
     port.Connect(pMsg);
     oldOptions := options;
     while port.m_byState<>ST_CONN_L1 do
     Begin
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')GSMConnection.connect Wait Connection 5000ms '+IntToStr(i)+' of 10'+' Conn:'+options);
      sleep(5000);
      i := i + 1;
      if i>10 then
      Begin
        if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(param.PULLID)+')GSMConnection.connect CONNECT ERORR!!! '+options);
        port.Disconnect(pMsg);
        while port.m_byState<>ST_DISC_L1 do
        Begin
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')GSMConnection.connect Wait Disconnection 5000ms Conn:'+options);
         sleep(5000);
         j := j + 1;
         if(j>5) then break;
        End;
        Result := PULL_STATE_ERR;
        if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')GSMConnection.connect DISCONNECT Complette... '+options);
        exit;
      End
     End;
     if port.m_byState=ST_CONN_L1 then
     Begin
      Result := PULL_STATE_CONN;
      if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'('+IntToStr(param.PULLID)+')GSMConnection.connect Wait Connection Complette Conn:'+options);
     End;
 except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')������ � GsmConnection.connet ');
 end;
End;

function GsmConnection.close:boolean;
Var
     pMsg  : CMessage;
     index : Integer;
     j     : Integer;
Begin
  try
   try
     j := 0;
     index := param.PORTID;
     port := mL1Module.m_pPort[index];
     port.Disconnect(pMsg);

     while port.m_byState<>ST_DISC_L1 do
     Begin
         sleep(5000);
         j := j + 1;
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')GsmConnection.close Wait Disconnection '+IntToStr(j)+' of 5 5000ms');
         if(j>5) then
        // begin
        //   if (mL1Module.m_pPort[index]<>nil)then
        //   mL1Module.DelNodeLv(Index);
         break;
        // end;
     End;
     if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')GsmConnection.close DISCONNECT Complette... ');
   except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')������ � GsmConnection.close ');
   end;
  finally
//    if (mL1Module.m_pPort[index]<>nil)then
//           mL1Module.DelNodeLv(Index);
  end;
End;
function GsmConnection.put(var pMsg:CMessage):Boolean;
Var
     index : Integer;
Begin
     port.msbox.FFREE;
     testMsg := pMsg;
     index := param.PORTID;
     port    := mL1Module.m_pPort[index];
     port.Send(@testMsg,testMsg.m_swLen);
End;

function GsmConnection.get(var pMsg:CMessage):Integer;
Var
     index : Integer;
     C :Cardinal;
Begin
     //port.msbox.FFREE;
     FillChar(pMsg,sizeof(CMessage),0);
     index := param.PORTID;
     port  := mL1Module.m_pPort[index];
     if port.m_byState<>ST_CONN_L1 then Begin Result:=2;exit;End;
     C := GetTickCount();
     while port.msbox.FCHECK=0 do Begin
       sleep(1);
//       if (GetTickCount() - C) >= (port.m_nL1.m_swDelayTime * 15) then Begin
       if (GetTickCount() - C) >= (port.m_nL1.m_swDelayTime * 8) then Begin
         Result:=1;
         exit;
       End;
     End;
     port.msbox.FGET(@pMsg);
     port.msbox.FFREE;
     if (pMsg.m_swLen<=13) then  Result := 1;
     if (pMsg.m_swLen>0) then  Result := 0;
End;

//ComConnection
constructor ComConnection.Create(value:CL2Pull;var sem:THandle);
Begin
    Inherited Create(value,sem);
End;

function ComConnection.CreateMsg(byType:Byte;var pDS:CMessageData):CMessage;
Var
    pMsg : CMessage;
Begin
    With pMsg do
    Begin
     m_swObjID     := 0;
     m_sbyFrom     := 0;
     m_sbyFor      := 0;
     m_sbyType     := 0;
     m_sbyTypeIntID:= 0;
     m_sbyIntID    := 0;
     m_sbyServerID := 0;
     m_sbyDirID    := 0;
     Move(pDS,m_sbyInfo[0],sizeof(pDS));
     m_swLen       := 13 + sizeof(pDS);
    end;
    Result := pMsg;
End;
{
  PULL_STATE_CONN = 0;
  PULL_STATE_DISC = 1;
  PULL_STATE_ERR  = 2;
}
function ComConnection.connect(options:String):Integer;
Var
     pMsg  : CMessage;
     index,i,j : Integer;
Begin
 try
     index := param.PORTID;
//     if assigned(mL1Module) then
//       if mL1Module.m_pPort[index]=nil then
//         begin
//           mL1Module.InitIndex(index);
//           port := mL1Module.m_pPort[index];
//         end;
//     if port=nil then
//      begin
//        if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(Error ComConnection.connect!!! �� ���������� ����� com �����');
//        exit;
//      end;
//     sleep(1000);
     port  := mL1Module.m_pPort[index];
     port.SettPort(pMsg);
     while port.m_blState<>1 do
     Begin
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')ComConnection.connect Wait Connection 5000ms '+IntToStr(i)+' of 10'+' Conn:'+options);
      sleep(5000);
      i := i + 1;
      if i>10 then
      Begin
        if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(param.PULLID)+')ComConnection.connect CONNECT ERORR!!! '+options);
        port.FreePort(pMsg);
        while port.m_blState<>0 do
        Begin
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')ComConnection.connect Wait Disconnection 5000ms Conn:'+options);
         sleep(5000);
         j := j + 1;
         if(j>5) then break;
        End;
        Result := PULL_STATE_ERR;
        if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')ComConnection.connect DISCONNECT Complette... '+options);
        exit;
      End
     End;
     if port.m_blState=1 then
     Begin
      Result := PULL_STATE_CONN;
      if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'('+IntToStr(param.PULLID)+')ComConnection.connect Wait Connection Complette Conn:'+options);
     End;
 except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')������ � ComConnection.connect ');
 end;
End;

function ComConnection.close:boolean;
Var
     pMsg  : CMessage;
     index : Integer;
     j     : Integer;
Begin
     j := 0;
     index := param.PORTID;
     port := mL1Module.m_pPort[index];
     port.FreePort(pMsg);
     while port.m_blState<>0 do
     Begin
         sleep(5000);
         j := j + 1;
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')ComConnection.close Wait Disconnection '+IntToStr(j)+' of 5 5000ms');
         if(j>5) then break;
     End;
     if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')ComConnection.close DISCONNECT Complette... ');
End;

function ComConnection.put(var pMsg:CMessage):Boolean;
Var
     index : Integer;
Begin
     port.msbox.FFREE;
     testMsg := pMsg;
     index   := param.PORTID;
     port    := mL1Module.m_pPort[index];
     port.Send(@testMsg,testMsg.m_swLen);
End;

function ComConnection.get(var pMsg:CMessage):Integer;
Var
     index : Integer;
     j     : Integer;
Begin
     //port.msbox.FFREE;
     FillChar(pMsg,sizeof(CMessage),0);
     index := param.PORTID;
     port  := mL1Module.m_pPort[index];
     if port.m_blState<>1 then Begin Result:=2;exit;End;
     j:=0;
     while port.msbox.FCHECK=0 do
     Begin
      sleep(100);
      inc(j);
      if j>50 then Begin Result:=1;exit;End;
     End;
     port.msbox.FGET(@pMsg);
     port.msbox.FFREE;
     if (pMsg.m_swLen<=13) then  Result := 1;
     if (pMsg.m_swLen>0) then  Result := 0;
End;

//TcpConnection
constructor TcpConnection.Create(value:CL2Pull;var sem:THandle);
Begin
    Inherited Create(value,sem);
End;

function TcpConnection.connect(options:String):Integer;
Var
     pMsg  : CMessage;
     index,i,j : Integer;
Begin
 try
     index := param.PORTID;
{     if assigned(mL1Module) then
       if mL1Module.m_pPort[index]=nil then
         begin
           mL1Module.InitIndex(index);
           port := mL1Module.m_pPort[index];
         end;    }
     port  := mL1Module.m_pPort[index];
     if port=nil then
      begin
       if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(Error TcpConnection.connect!!! �� ���������� TCP �����');
       exit;
      end;
//     sleep(1000);      
     port.Connect(pMsg);
     while port.m_byState<>ST_CONN_L1 do
     Begin
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')TcpConnection.connect Wait Connection 5000ms '+IntToStr(i)+' of 10'+' Conn:'+options);
      sleep(5000);
      i := i + 1;
      if i>10 then
      Begin
        if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'('+IntToStr(param.PULLID)+')TcpConnection.connect CONNECT ERORR!!! '+options);
        port.Disconnect(pMsg);
        while port.m_byState<>ST_DISC_L1 do
        Begin
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')TcpConnection.connect Wait Disconnection 5000ms Conn:'+options);
         sleep(5000);
         j := j + 1;
         if(j>5) then break;
        End;
        Result := PULL_STATE_ERR;
        if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')TcpConnection.connect DISCONNECT Complette... '+options);
        exit;
      End
     End;
     if port.m_byState=ST_CONN_L1 then
     Begin
      Result := PULL_STATE_CONN;
      if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'('+IntToStr(param.PULLID)+')TcpConnection.connect Wait Connection Complette Conn:'+options);
     End;
 except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')������ � GsmConnection.connect ');
 end;
End;

function TcpConnection.close:boolean;
Var
     pMsg  : CMessage;
     index : Integer;
     j     : Integer;
Begin
 try
   try
     j := 0;
     index := param.PORTID;
     port := mL1Module.m_pPort[index];
     port.Disconnect(pMsg);
     while port.m_byState<>ST_DISC_L1 do
     Begin
         sleep(5000);
         j := j + 1;
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')TcpConnection.close Wait Disconnection '+IntToStr(j)+' of 5 5000ms');
         if(j>5) then break;
     End;
     if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')TcpConnection.close DISCONNECT Complette... ');
   except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'('+IntToStr(param.PULLID)+')������ � TcpConnection.close ');
   end;
 finally
//    if (mL1Module.m_pPort[index]<>nil)then
//           mL1Module.DelNodeLv(Index);
 end;
End;

function TcpConnection.put(var pMsg:CMessage):Boolean;
Var
     index : Integer;
Begin
     port.msbox.FFREE;
     testMsg := pMsg;
     index   := param.PORTID;
     port    := mL1Module.m_pPort[index];
     port.Send(@testMsg,testMsg.m_swLen);
End;

function TcpConnection.get(var pMsg:CMessage):Integer;
Var
     index : Integer;
     j     : Integer;
Begin
     FillChar(pMsg,sizeof(CMessage),0);
     index := param.PORTID;
     port  := mL1Module.m_pPort[index];
     if port.m_byState<>ST_CONN_L1 then Begin Result:=2;exit;End;
     j:=0;
     while port.msbox.FCHECK=0 do
     Begin
      sleep(100);
      inc(j);
      if j>160 then Begin Result:=1;exit;End;
     End;
     port.msbox.FGET(@pMsg);
     port.msbox.FFREE;
     if (pMsg.m_swLen<=13) then  Result := 1;
     if (pMsg.m_swLen>0) then  Result := 0;
End;

//UdpConnection
constructor UdpConnection.Create(value:CL2Pull;var sem:THandle);
Begin
    Inherited Create(value,sem);
End;

function UdpConnection.connect(options:String):Integer;
Begin


End;

function UdpConnection.close:boolean;
Begin

End;

function UdpConnection.put(var pMsg:CMessage):Boolean;
Begin
End;
function UdpConnection.get(var pMsg:CMessage):Integer;
Begin
End;

//CFlyConnectionEntityFactory
constructor CFlyConnectionEntityFactory.Create(var value:THandle);
Begin
   semaphore := value;
End;

function CFlyConnectionEntityFactory.getInstance(options:CL2Pull;meta:CL2Pulls):IConnection;
Begin
   if(pos('gsm',meta.PULLTYPE)>0) then
    Result := GsmConnection.Create(options,semaphore)
  else if(pos('com',meta.PULLTYPE)>0) then
    Result := ComConnection.Create(options,semaphore)
  else if(pos('tcp',meta.PULLTYPE)>0) then
    Result := TcpConnection.Create(options,semaphore)
  else if(pos('udp',meta.PULLTYPE)>0) then
    Result := UdpConnection.Create(options,semaphore)
  else Result := nil;
  Assert(Result <> nil);
 End;

end.
