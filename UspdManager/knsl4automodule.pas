unit knsl4automodule;

interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer;
type
    CHIAutomat = class
    protected
     m_sbyID        : Byte;
     m_swAddres     : Word;
     m_sbyPortTypeID: Byte;
     m_sbyPortID    : Byte;
     m_sbyRepMsg    : Byte;
     m_sbyRepTime   : Byte;
     m_sbyBoxID     : Byte;
     m_nRepTimer    : CTimer;
     function SelfHandler(var pMsg:CMessage):Boolean;virtual; abstract;
     function LoHandler(var pMsg:CMessage):Boolean;virtual; abstract;
     function HiHandler(var pMsg:CMessage):Boolean;virtual; abstract;
    public
     procedure Init(var pTable:SL1TAG);
     procedure InitAuto(var pTable:SL1TAG);virtual; abstract;
     procedure SetBox(byBox:Byte);
     //function EventHandler(var pMsg : CMessage):Boolean;virtual;abstract;
     function EventHandler(var pMsg:CMessage):Boolean;
     function SelfBaseHandler(var pMsg:CMessage):Boolean;
     function LoBaseHandler(var pMsg:CMessage):Boolean;
     function HiBaseHandler(var pMsg:CMessage):Boolean;
     procedure Run;
     procedure RunAuto;virtual; abstract;
    End;
    PCHIAutomat =^ CHIAutomat;
implementation
procedure CHIAutomat.Init(var pTable:SL1TAG);
Begin
     m_swAddres     := pTable.m_sbyPortNum;
     m_sbyPortTypeID:= pTable.m_sbyType;
     if pTable.m_sblReaddres=0 then
       m_sbyPortID    := pTable.m_sbyPortID else
     m_sbyPortID    := pTable.m_swAddres;
     m_sbyRepMsg    := 10;
     m_sbyRepTime   := 3;
     m_nRepTimer    := CTimer.Create;
     m_nRepTimer.SetTimer(DIR_L4TOL4,AL_REPMSG_TMR,0,m_swAddres,m_sbyBoxID);
     SendPData(BOX_L1,m_swAddres,m_sbyPortID,DIR_BTITOL1,PH_DATARD_REQ,1,@m_swAddres);
     InitAuto(pTable);
End;
procedure CHIAutomat.SetBox(byBox:Byte);
Begin
    m_sbyBoxID := byBox;
End;
function CHIAutomat.EventHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    case pMsg.m_sbyFor of
     DIR_L1TOL2,DIR_ARTOL4  : res := LoBaseHandler(pMsg);
     DIR_L4TOL4             : res := SelfBaseHandler(pMsg);
     DIR_L4TOAR, DIR_LMETOL4: res := HiBaseHandler(pMsg);
    End;
    Result := res;;
End;
function CHIAutomat.SelfBaseHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;

    SelfHandler(pMsg);
    Result := res;
End;
function CHIAutomat.LoBaseHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;

    LoHandler(pMsg);
    Result := res;
End;
function CHIAutomat.HiBaseHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;

    HiHandler(pMsg);
    Result := res;
End;
procedure CHIAutomat.Run;
Begin
    if m_nRepTimer <> nil then
      m_nRepTimer.RunTimer;
    RunAuto;
End;
end.
