//{$DEFINE DIS_DEBUG}
unit knsl3discret;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,knsl5tracer;
type
    CDiscret = class
    protected
     m_blEnable    : Boolean;
     m_blInEnable  : Boolean;
     m_blOutEnable : Boolean;

     m_blPinON     : Boolean;
     m_blPinOFF    : Boolean;

     m_blTmSetState: Boolean;
     m_blTmRemState: Boolean;
     m_byStPulce   : Boolean;

     m_byInPort    : Byte;

     m_wAddr       : Word;
     m_wProgAddr   : Word;
     m_byCSetPulce : Byte;
     m_byCRemPulce : Byte;
     m_bySetPulce  : Byte;
     m_byRemPulce  : Byte;
     m_byPulceTact : Byte;
     m_byPin       : Byte;
     m_byLPin      : Byte;
     m_byPinType   : Byte;
     m_byDirPin    : Byte;

     m_nBox        : Integer;
     m_byFor       : Byte;
     m_byPinEvent  : Byte;
     m_byLastEvent : Byte;
     m_byEvent     : Byte;
     m_dwCount     : DWord;

     destructor Destroy;override;
     procedure ProcOutPulce;
     procedure ProcInPulce;
     procedure DoAction;

     procedure OutP(wAddr:Word;byParam:Byte);
     procedure InP(wAddr:Word;var byParam:Byte);

     function GetPin:Boolean;
     function GetPinState:Byte;
     procedure PostInProc;
     procedure SaveChange(byPinEvent:Byte);
     function  CheckPinState:Byte;
    public
     constructor Create(byCSetPulce,byCRemPulce,byPulceTact,byPin,byPinType,byDirPin:Byte);
     procedure SetProgPin(byDirPin:Byte);
     procedure SetEvent(nBox:Integer;byFor,byEvent:Byte);
     function  EventHandler(var pMsg:CMessage):boolean;
     procedure Enabled(blState:Boolean);
     procedure SetPin;
     procedure RemPin;
     procedure SetPulce;
     procedure SetPinState(byPinEvent:Byte);
     procedure SetAddrVal(wAddr:Word;byParam:Byte);
     procedure Run;
    End;
    SDIOTAG = packed record
     Count : Integer;
     Items : array[0..PH_MAX_PIN-1] of CDiscret;
    End;
    procedure InitPins;
Var
    sDSCS  : TCriticalSection = nil;
    m_nDIO : SDIOTAG;
implementation
//{$R *.DFM}
function Inp32(PortAdr: word): byte; stdcall; external 'inpout32.dll';
function Out32(PortAdr: word; Data: byte): byte; stdcall; external 'inpout32.dll';
constructor CDiscret.Create(byCSetPulce,byCRemPulce,byPulceTact,byPin,byPinType,byDirPin:Byte);
Begin
     m_byCSetPulce  := byCSetPulce;
     m_byCRemPulce  := byCRemPulce;
     m_byPulceTact  := byPulceTact;
     m_byPin        := byPin;
     m_byPinType    := byPinType;
     m_byDirPin     := byDirPin;
     //m_byPinEvent   := CheckPinState;
     m_blPinON      := False;
     m_blPinOFF     := False;
     m_bySetPulce   := 0;
     m_byRemPulce   := 0;
     m_blTmSetState := False;
     m_blTmRemState := False;
     m_byStPulce    := False;
     m_wAddr        := PH_BASE_ADDR_PIN_PORT + (byPin div 8);
     m_wProgAddr    := PH_BASE_ADDR_SET_PORT + (byPin div 8);
     m_byLPin       := byPin mod 8;
     m_byInPort     := 0;
     SetProgPin(m_byDirPin);
     m_byPinEvent   := CheckPinState;
     m_byLastEvent  := m_byPinEvent;
     Enabled(False);
End;
destructor CDiscret.Destroy;
Begin
     if sDSCS <> nil then FreeAndNil(sDSCS);
     inherited;
End;
procedure CDiscret.SetAddrVal(wAddr:Word;byParam:Byte);
Begin
     m_wAddr := wAddr;
     m_byLPin:= byParam;
End;
function CDiscret.EventHandler(var pMsg:CMessage):boolean;
Begin
End;
procedure CDiscret.ProcInPulce;
Var
     byState : Byte;
Begin
     if m_blInEnable=True then
     Begin
      byState := GetPinState;
      if(byState=PIN_STATE_ONN) then Begin m_blTmSetState := TRUE;m_blTmRemState := FALSE;m_bySetPulce := m_byCSetPulce;End;
      if(byState=PIN_STATE_OFF) then Begin m_blTmRemState := TRUE;m_blTmSetState := FALSE;m_byRemPulce := m_byCRemPulce;End;
      PostInProc;
     End;
End;
function  CDiscret.CheckPinState:Byte;
Var
     byState : Byte;
Begin
      byState := GetPinState;
      Result  := PH_X_TO_X_EV;
      if(byState=PIN_STATE_ONN) then
      Begin
       if (m_byPinType=PH_DIRECT_PIN) then Result := PH_0_TO_1_EV else
       if (m_byPinType=PH_INVERT_PIN) then Result := PH_1_TO_0_EV;
      End else
      if(byState=PIN_STATE_OFF) then
      Begin
       if (m_byPinType=PH_DIRECT_PIN) then Result := PH_0_TO_1_EV else
       if (m_byPinType=PH_INVERT_PIN) then Result := PH_1_TO_0_EV;
      End;
End;
procedure CDiscret.PostInProc;
Begin
     //Set
     if m_blTmSetState=True then
     Begin
      if (m_bySetPulce=0) then
      Begin
       m_blTmSetState := FALSE;
       SaveChange(PH_0_TO_1_EV);
      End;
      Dec(m_bySetPulce);
     End;
     //Rem
     if m_blTmRemState=True then
     Begin
      if (m_byRemPulce=0) then
      Begin
       m_blTmRemState := FALSE;
       SaveChange(PH_1_TO_0_EV);
      End;
      Dec(m_byRemPulce);
     End;
End;
procedure CDiscret.SetEvent(nBox:Integer;byFor,byEvent:Byte);
Begin
     m_nBox         := nBox;
     m_byFor        := byFor;
     m_byPinEvent   := CheckPinState;
     m_byEvent      := byEvent;
     m_blPinON      := False;
     m_blPinOFF     := False;
     m_bySetPulce   := 0;
     m_byRemPulce   := 0;
     m_blTmSetState := False;
     m_blTmRemState := False;
     m_byStPulce    := False;
     m_byLastEvent  := m_byPinEvent;
End;
procedure CDiscret.SetProgPin(byDirPin:Byte);
Var
     byState : Byte;
Begin
     InP(m_wProgAddr,byState);
      if (m_byDirPin=PIN_INPUT) then byState := byState and (not(1 shl m_byLPin)) else
      if (m_byDirPin=PIN_OUTPT) then byState := byState or (1 shl m_byLPin);
     OutP(m_wProgAddr,byState)
End;
procedure CDiscret.SetPulce;
Begin
     if(m_blOutEnable=True) then
     Begin
      m_bySetPulce := m_byPulceTact;
      m_byStPulce  := TRUE;
      SetPin;
      if (m_byPinType=PH_DIRECT_PIN) then SaveChange(PH_0_TO_1_EV);
      if (m_byPinType=PH_INVERT_PIN) then SaveChange(PH_1_TO_0_EV);
     End;
End;
procedure CDiscret.SetPinState(byPinEvent:Byte);
Begin
     if(m_blOutEnable=True) then
     Begin
      if (byPinEvent=PH_0_TO_1_EV) then
      Begin
       SetPin;
       if (m_byPinType=PH_DIRECT_PIN) then SaveChange(PH_0_TO_1_EV);
       if (m_byPinType=PH_INVERT_PIN) then SaveChange(PH_1_TO_0_EV);
      End else
      if (byPinEvent=PH_1_TO_0_EV) then
      Begin
       RemPin;
       if (m_byPinType=PH_DIRECT_PIN) then SaveChange(PH_1_TO_0_EV);
       if (m_byPinType=PH_INVERT_PIN) then SaveChange(PH_0_TO_1_EV);
      End;
     End;
End;
procedure CDiscret.ProcOutPulce;
Begin
     if m_blOutEnable=True then
     Begin
      if(m_byStPulce=TRUE) then
      Begin
       if (m_bySetPulce=0) then
       Begin
        m_byStPulce := FALSE;
        RemPin;
        if (m_byPinType=PH_DIRECT_PIN) then SaveChange(PH_1_TO_0_EV);
        if (m_byPinType=PH_INVERT_PIN) then SaveChange(PH_0_TO_1_EV);
       End;
       Dec(m_bySetPulce)
      End;
     End;
End;
procedure CDiscret.Enabled(blState:Boolean);
Begin
     m_blEnable    := blState;
     m_blInEnable  := False;
     m_blOutEnable := False;
     if m_byDirPin=PIN_INPUT then m_blInEnable  := blState;
     if m_byDirPin=PIN_OUTPT then m_blOutEnable := blState;
End;
procedure CDiscret.DoAction;
Var
     m_sMsg:CHMessage;
Begin
     with m_sMsg do
     Begin
      m_swLen        := 11;
      m_sbyFrom      := m_byFor;
      m_sbyFor       := m_byFor;
      m_sbyTypeIntID := m_byDirPin;
      m_sbyServerID  := 0;
      m_sbyDirID     := m_byPinEvent;
      m_swObjID      := m_byPin;
      m_sbyType      := m_byEvent;
      if m_nCheckPins=1 then
      FPUT(m_nBox,@m_sMsg);
     End;
End;
procedure CDiscret.SaveChange(byPinEvent:Byte);
Begin
     if byPinEvent<>m_byLastEvent then
     Begin
      m_byPinEvent  := byPinEvent;
      DoAction;
      m_byLastEvent := m_byPinEvent;
     End;
End;
function CDiscret.GetPinState:Byte;
Var
     blValue : Boolean;
Begin
     Result := PIN_STATE_TRI;
     blValue := GetPin;
     if (blValue=True) then
     Begin
      if (m_blPinON=False) then
      Begin
       m_blPinON  := True;
       m_blPinOFF := False;
       Result := PIN_STATE_ONN;
      End;
     End else
     if (blValue=False) then
     Begin
      if (m_blPinOFF=False) then
      Begin
       m_blPinOFF := True;
       m_blPinON  := False;
       Result := PIN_STATE_OFF;
      End;
     End;
End;
function CDiscret.GetPin:Boolean;
Var
     byState : Byte;
Begin
     byState := 0;
     InP(m_wAddr,byState);
     Result := (byState and (1 shl m_byLPin))<>0;
End;
procedure CDiscret.SetPin;
Var
     byState : Byte;
Begin
     InP(m_wAddr,byState);
      if (m_byPinType=PH_INVERT_PIN) then byState := byState and (not(1 shl m_byLPin)) else
      if (m_byPinType=PH_DIRECT_PIN) then byState := byState or (1 shl m_byLPin);
     OutP(m_wAddr,byState)
End;
procedure CDiscret.RemPin;
Var
     byState : Byte;
Begin
     InP(m_wAddr,byState);
      if (m_byPinType=PH_INVERT_PIN) then byState := byState or (1 shl m_byLPin) else
      if (m_byPinType=PH_DIRECT_PIN) then byState := byState and (not(1 shl m_byLPin));
     OutP(m_wAddr,byState)
End;
procedure CDiscret.OutP(wAddr:Word;byParam:Byte);
Begin
     sDSCS.Enter;
     {$IFDEF DIS_DEBUG}
      m_byInPort := byParam;
      TraceL(3,m_byPin,'(__)CDSMD::>ADDR: '+IntToHex(wAddr,2)+' VAL: '+IntToHex(byParam,2));
     {$ELSE}
      if m_nCheckPins=1 then Out32(wAddr,byParam);
     {$ENDIF}
     sDSCS.Leave;
End;
procedure CDiscret.InP(wAddr:Word;var byParam:Byte);
Begin
     sDSCS.Enter;
     {$IFDEF DIS_DEBUG}
      byParam := m_byInPort;
     {$ELSE}
     if m_nCheckPins=1 then byParam := Inp32(wAddr);
     {$ENDIF}
     sDSCS.Leave;
End;
procedure CDiscret.Run;
Begin
     //if m_blEnable=True then
     //Begin
     // ProcOutPulce;
     // ProcInPulce;
     //End;
     //{$IFDEF DIS_DEBUG}
     //if ((m_dwCount mod 6)=0) and(m_byDirPin=PIN_INPUT) then m_byInPort := m_byInPort xor $ff;
     //if ((m_dwCount mod 10)=0)and(m_byDirPin=PIN_OUTPT) then SetPulce;
     //m_dwCount := m_dwCount + 1;
     //{$ENDIF}
End;
procedure InitPins;
Begin
     //byCSetPulce,byCRemPulce,byPulceTact,byPin,byPinType,byDirPin:Byte
     if sDSCS=Nil then sDSCS := TCriticalSection.Create;
     m_nDIO.Count    := 32;
     m_nDIO.Items[0] :=  CDiscret.Create(2,2,2,0 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[1] :=  CDiscret.Create(2,2,2,1 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[2] :=  CDiscret.Create(3,3,2,2 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[3] :=  CDiscret.Create(5,5,2,3 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[4] :=  CDiscret.Create(5,5,2,4 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[5] :=  CDiscret.Create(5,5,2,5 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[6] :=  CDiscret.Create(5,5,2,6 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[7] :=  CDiscret.Create(5,5,2,7 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[8] :=  CDiscret.Create(5,5,2,8 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[9] :=  CDiscret.Create(5,5,2,9 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[10]:=  CDiscret.Create(5,5,2,10,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[11]:=  CDiscret.Create(5,5,2,11,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[12]:=  CDiscret.Create(5,5,2,12,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[13]:=  CDiscret.Create(5,5,2,13,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[14]:=  CDiscret.Create(5,5,2,14,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[15]:=  CDiscret.Create(5,5,2,15,PH_DIRECT_PIN,PIN_INPUT);

     m_nDIO.Items[0].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); m_nDIO.Items[0].Enabled(True);
     m_nDIO.Items[1].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); m_nDIO.Items[1].Enabled(True);
     m_nDIO.Items[2].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[2].Enabled(True);
     m_nDIO.Items[3].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[3].Enabled(True);
     m_nDIO.Items[4].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[4].Enabled(True);
     m_nDIO.Items[5].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[5].Enabled(True);
     m_nDIO.Items[6].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[6].Enabled(True);
     m_nDIO.Items[7].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[7].Enabled(True);
     m_nDIO.Items[8].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[8].Enabled(True);
     m_nDIO.Items[9].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[9].Enabled(True);
     m_nDIO.Items[10].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[10].Enabled(True);
     m_nDIO.Items[11].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[11].Enabled(True);
     m_nDIO.Items[12].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[12].Enabled(True);
     m_nDIO.Items[13].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[13].Enabled(True);
     m_nDIO.Items[14].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[14].Enabled(True);
     m_nDIO.Items[15].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND);//m_nDIO.Items[15].Enabled(True);

     m_nDIO.Items[16]:=  CDiscret.Create(5,5,10,16,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[17]:=  CDiscret.Create(5,5,3,17,PH_DIRECT_PIN,PIN_OUTPT);
     //m_nDIO.Items[16] :=  CDiscret.Create(2,2,2,16 ,PH_DIRECT_PIN,PIN_INPUT);
     //m_nDIO.Items[17] :=  CDiscret.Create(2,2,2,17 ,PH_DIRECT_PIN,PIN_INPUT);
     m_nDIO.Items[18]:=  CDiscret.Create(5,5,3,18,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[19]:=  CDiscret.Create(5,5,3,19,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[20]:=  CDiscret.Create(5,5,3,20,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[21]:=  CDiscret.Create(5,5,3,21,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[22]:=  CDiscret.Create(5,5,3,22,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[23]:=  CDiscret.Create(5,5,3,23,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[24]:=  CDiscret.Create(5,5,3,24,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[25]:=  CDiscret.Create(5,5,3,25,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[26]:=  CDiscret.Create(5,5,3,26,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[27]:=  CDiscret.Create(5,5,3,27,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[28]:=  CDiscret.Create(5,5,3,28,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[29]:=  CDiscret.Create(5,5,3,29,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[30]:=  CDiscret.Create(5,5,3,30,PH_DIRECT_PIN,PIN_OUTPT);
     m_nDIO.Items[31]:=  CDiscret.Create(5,5,3,31,PH_DIRECT_PIN,PIN_OUTPT);

     m_nDIO.Items[16].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[16].Enabled(True);
     m_nDIO.Items[17].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[17].Enabled(True);
     m_nDIO.Items[18].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[18].Enabled(True);
     m_nDIO.Items[19].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[19].Enabled(True);
     m_nDIO.Items[20].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[20].Enabled(True);
     m_nDIO.Items[21].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[21].Enabled(True);
     m_nDIO.Items[22].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[22].Enabled(True);
     m_nDIO.Items[23].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[23].Enabled(True);
     m_nDIO.Items[24].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[24].Enabled(True);
     m_nDIO.Items[25].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[25].Enabled(True);
     m_nDIO.Items[26].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[26].Enabled(True);
     m_nDIO.Items[27].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[27].Enabled(True);
     m_nDIO.Items[28].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[28].Enabled(True);
     m_nDIO.Items[29].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[29].Enabled(True);
     m_nDIO.Items[30].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[30].Enabled(True);
     m_nDIO.Items[31].SetEvent(BOX_L3,DIR_L2TOL3,AL_CHANDGEPIN_IND); //m_nDIO.Items[31].Enabled(True);

End;

procedure InitModule;
var I :Integer;
begin
  for I := Low(m_nDIO.Items) to High(m_nDIO.Items) do
    m_nDIO.Items[I] := nil;
end;

procedure FinalizModule;
var I :Integer;
begin
  if sDSCS <> nil then FreeAndNil(sDSCS);
  
  for i := Low(m_nDIO.Items) to High(m_nDIO.Items) do
    if m_nDIO.Items[I] <> nil then
      m_nDIO.Items[I].Free;
end;

initialization
  InitModule();

finalization
  FinalizModule();

end.
