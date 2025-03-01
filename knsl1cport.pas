unit knsl1cport;

interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlcbox;
type
    CPort = class(TPersistent)
    protected
     m_byID        : Byte;
     m_byType      : Byte;
     m_byIsControl : Byte;
     m_byReccBoxID : Byte;
     m_sbyProtoType: Byte; 
     m_wCurrMtrType: Integer;
     m_wCurrMtrID  : Integer;
     //m_nL1         : SL1TAG;
     m_blIsPause   : Boolean;
     connectionState : Boolean;
     constructor Create;
     destructor Destroy;override;
    public
     m_blState     : Byte;
     m_nL1         : SL1TAG;
     m_byState     : Word;
     m_byWaitState   : Byte;
     m_blDialErr   : Boolean;
     msbox         : CBox;
     function  EventHandler(var pMsg:CMessage):boolean;virtual; abstract;
     procedure Close;virtual; abstract;
     procedure MakeMessageL1;virtual; abstract;
     procedure RunTmr;virtual; abstract;
     procedure RunSpeedTmr;virtual; abstract;
     procedure Init(var pL1:SL1TAG);virtual; abstract;
     procedure SetDynamic(var pL1 : SL1SHTAG);virtual; abstract;
     procedure SetDefaultSett;virtual; abstract;
     function Send(pMsg:Pointer;nLen:Word):Boolean;virtual; abstract;
     function Connect(var pMsg:CMessage):Boolean;virtual;abstract;
     function ReConnect(var pMsg:CMessage):Boolean;virtual;abstract;
     function Disconnect(var pMsg:CMessage):Boolean;virtual; abstract;
     function FreePort(var pMsg:CMessage):Boolean;virtual;abstract;
     function SettPort(var pMsg:CMessage):Boolean;virtual; abstract;
     function SendCommandEx(var pMsg:CMessage):Boolean;virtual; abstract;
     procedure OpenPortEx(var pL1:SL1SHTAG);virtual; abstract;
     procedure QueryConnect(var pMsg:CMessage);virtual;
     procedure ResetPort(var pMsg:CMessage);virtual; abstract;
     procedure StopPort;virtual; abstract;
     procedure StartPort;virtual; abstract;
     procedure StopIsGPRS;virtual;
     function GetPortState:Boolean;virtual;abstract;
     function GetConnectState:Boolean;virtual;abstract;
     function ReconnectL1(var pMsg:CMessage):Boolean;virtual;
     function getConnectionState:Boolean;

    End;
    PCPort =^ CPort;
implementation
constructor CPort.Create;
Var
   v : Integer;
Begin
   v := 0;
   connectionState := false;
   msbox := CBox.Create(10000);
End;
destructor CPort.Destroy;
Begin
   FreeAndNil(msbox);
   inherited;
End;
function CPort.getConnectionState:Boolean;
Begin
   Result := connectionState;
End;
procedure CPort.QueryConnect(var pMsg:CMessage);
Begin
End;
function CPort.ReconnectL1(var pMsg:CMessage):Boolean;
Begin
End;
procedure CPort.StopIsGPRS;
Begin

End;
end.
