unit knsl2ss301f3meter;
//{$DEFINE SS301_DEBUG}
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,knsl2meter,utlmtimer,knsl3observemodule,utlTimeDate,utldatabase;
type
    CSS301F3Meter = class(CMeter)
    Private
     DepthEvEnd  : Integer;
     nReq        : CQueryPrimitive;
     Ke          : double;
     dt_TLD      : TDateTime;
     nOldYear    : Word;
     bl_SaveCrEv : boolean;
     LastMask    : word;
     advInfo     : SL2TAGADVSTRUCT;
     procedure   SetCurrQry;
     procedure   SetGraphQry;
     procedure   RunMeter;override;
     procedure   InitMeter(var pL2:SL2TAG);override;
     function    SelfHandler(var pMsg:CMessage):Boolean;override;
     function    LoHandler(var pMsg0:CMessage):Boolean;override;
     function    HiHandler(var pMsg:CMessage):Boolean;override;
     function    GetCommand(byCommand:Byte):Integer;
     procedure   TestMessage(var pMsg:CMessage);
     procedure   TestMessageFNC40(var pMsg:CMessage);
     constructor Create;
     procedure   HandQryRoutine(var pMsg:CMessage);
     procedure   MsgHead(var pMsg:CHMessage; Size:byte);
     procedure   MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
     function    CRC(var buf : array of byte; cnt : byte):boolean;
     function    ReadSlices666(var pMsg:CMessage):boolean;
     function    ProcessingData(var pMsg:CMessage;var i:integer) : boolean;
     function    GetDWValue(var pMsg:CMessage;i:integer):DWORD;
     function    GetValue(var pMsg:CMessage;i:integer):Single;
     procedure   WriteValue(var pMsg:CMessage;i:integer);
     procedure   WriteI(var pMsg:CMessage;i:integer);
     procedure   WriteU(var pMsg:CMessage;i:integer);
     procedure   WriteP(var pMsg:CMessage;i:integer);
     procedure   WriteE(var pMsg:CMessage;i:integer);
     function    SendToL3(var pMsg:CMessage) : boolean;
     procedure   GetTimeValue(var nReq: CQueryPrimitive);
     procedure   Autoriztion;
     procedure   KorrTime(LastDate : TDateTime);
     procedure   SetTime();
     procedure   AddEnergyDayGraphQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddEnergyMonthGrpahQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddSresEnergGrpahQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddSresEnergFNC40(dt_Date: TDateTime);
     procedure   AddLastSresEnergGrpahQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddNakEnDayGrpahQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddNakEnMonthGrpahQry(dt_Date1, dt_Date2 : TDateTime);
     procedure   AddMaxPower(dt_Date1, dt_Date2  : TDateTime);
     procedure   AddKorrGraphQry(dt_Date1 : TDateTime; srezN, srezK : byte);
     procedure   AddEventsGraphQry(var pMsg:CMessage);
     procedure   WriteDate(var pMsg : CMessage; param : word);
     procedure   CreateJrnlReq(var nReq: CQueryPrimitive);
     procedure   OnFinHandQryRoutine(var pMsg:CMessage);
     procedure   OnEnterAction;
     procedure   OnFinalAction;
     procedure   OnConnectComplette(var pMsg:CMessage);override;
     procedure   OnDisconnectComplette(var pMsg:CMessage);override;
     procedure   EncodeStrToBufArr(var str : string; var buf : array of byte; var nCount : integer);
     function    GetStringFromFile(FileName : string; nStr : integer) : string;
     procedure   ReadKorrJrnl(var pMsg:CHMessage);
     procedure   ReadStateJrnl(var pMsg:CHMessage);
     procedure   ReadPhaseJrnl(var pMsg:CHMessage);
    End;
implementation
constructor CSS301F3Meter.Create;
Begin
End;



procedure CSS301F3Meter.InitMeter(var pL2:SL2TAG);
Var
    Year, Month, Day:Word;
    slv : TStringList;
Begin
    m_nCounter := 0;
    m_nCounter1:= 0;
    IsUpdate   := 0;
    DecodeDate(Now, Year, Month, Day);
    nOldYear := Year;
    LastMask := 0;
    //if m_nP.m_sbyHandScenr=0 then
    //Begin
    // SetCurrQry;
    // SetGraphQry;
    //end;
    //if m_nP.m_sbyHandScenr=1 then
    //Begin
     SetHandScenario;
     SetHandScenarioGraph;
    //end;
//    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CSS301  Meter Created:'+
//    ' PortID:'+IntToStr(m_nP.m_sbyPortID)+
//    ' Rep:'+IntToStr(m_byRep)+
//    ' Group:'+IntToStr(m_nP.m_sbyGroupID));
     slv := TStringList.Create;
     getStrings(m_nP.m_sAdvDiscL2Tag,slv);
     if slv[0]='' then slv[0] := '0';
     if slv[2]='' then slv[2] := '0';
     advInfo.m_sKoncFubNum  := slv[0]; //
     advInfo.m_sKoncPassw   := slv[1]; //������ �� �������
     advInfo.m_sAdrToRead   := slv[2]; // ����� ��������

     slv.Clear;
     slv.Destroy;

    {$IFDEF SS301_DEBUG}
    m_nP.m_sbyTSlice := 0;
    {$ENDIF}
End;
procedure CSS301F3Meter.MsgHead(var pMsg:CHMessage; Size:byte);
begin
    pMsg.m_swLen       := Size;                 //pMsg.m_sbyInfo[] :=
    pMsg.m_swObjID     := m_nP.m_swMID;       //������� ����� ��������
    pMsg.m_sbyFrom     := DIR_L2TOL1;
    pMsg.m_sbyFor      := DIR_L2TOL1;    //DIR_L2toL1
    pMsg.m_sbyType     := PH_DATARD_REQ; //PH_DATARD_REC
    //pMsg.m_sbyTypeIntID:= DEV_COM;       //DEF_COM
    pMsg.m_sbyIntID    := m_nP.m_sbyPortID;
    pMsg.m_sbyServerID := MET_SS301F3;     //������� ��� ��������
    pMsg.m_sbyDirID    := m_nP.m_sbyPortID;
end;

procedure CSS301F3Meter.MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
begin
    pMsg.m_swLen       := Size;
    pMsg.m_swObjID     := m_nP.m_swMID;       //������� ����� ��������
    pMsg.m_sbyFrom     := DIR_L2TOL3;
    pMsg.m_sbyFor      := DIR_L2TOL3;    //DIR_L2toL1
    pMsg.m_sbyType     := PH_EVENTS_INT; //PH_DATARD_REC
    //pMsg.m_sbyTypeIntID:= DEV_COM;       //DEF_COM
    pMsg.m_sbyIntID    := m_nP.m_sbyPortID;
    pMsg.m_sbyServerID := MET_SS301F3;     //������� ��� ��������
    pMsg.m_sbyDirID    := m_nP.m_sbyPortID;
end;

procedure CSS301F3Meter.SetCurrQry;
Begin
    with m_nObserver do
    Begin
     ClearCurrQry;
     AddCurrParam(QRY_ENERGY_SUM_EP,0,1,0,1);
     AddCurrParam(QRY_ENERGY_SUM_EP,0,2,0,1);
     AddCurrParam(QRY_ENERGY_SUM_EP,0,3,0,1);
     AddCurrParam(QRY_ENERGY_SUM_EP,0,4,0,1);
     AddCurrParam(QRY_ENERGY_DAY_EP,0,1,0,1);
     AddCurrParam(QRY_ENERGY_DAY_EP,0,2,0,1);
     AddCurrParam(QRY_ENERGY_DAY_EP,0,3,0,1);
     AddCurrParam(QRY_ENERGY_DAY_EP,0,4,0,1);
     AddCurrParam(QRY_ENERGY_MON_EP,0,1,0,1);
     AddCurrParam(QRY_ENERGY_MON_EP,0,2,0,1);
     AddCurrParam(QRY_ENERGY_MON_EP,0,3,0,1);
     AddCurrParam(QRY_ENERGY_MON_EP,0,4,0,1);
     AddCurrParam(QRY_E3MIN_POW_EP,0,0,0,1);
     AddCurrParam(QRY_E30MIN_POW_EP,0,0,0,1);
     AddCurrParam(QRY_MGAKT_POW_S,0,0,0,1);
     AddCurrParam(QRY_MGREA_POW_S,0,0,0,1);
     AddCurrParam(QRY_U_PARAM_A,0,0,0,1);
     AddCurrParam(QRY_I_PARAM_A,0,0,0,1);
     AddCurrParam(QRY_KOEF_POW_A,0,0,0,1);
     AddCurrParam(QRY_FREQ_NET,0,0,0,1);
     AddCurrParam(QRY_KPRTEL_KPR,0,0,0,1);
     AddCurrParam(QRY_DATA_TIME,0,0,0,1);
     AddCurrParam(QRY_SRES_ENR_EP,0,0,0,1);
     AddCurrParam(QRY_NAK_EN_DAY_EP,0,1,0,1);
     AddCurrParam(QRY_NAK_EN_DAY_EP,0,2,0,1);
     AddCurrParam(QRY_NAK_EN_DAY_EP,0,3,0,1);
     AddCurrParam(QRY_NAK_EN_DAY_EP,0,4,0,1);
     AddCurrParam(QRY_NAK_EN_MONTH_EP,0,1,0,1);
     AddCurrParam(QRY_NAK_EN_MONTH_EP,0,2,0,1);
     AddCurrParam(QRY_NAK_EN_MONTH_EP,0,3,0,1);
     AddCurrParam(QRY_NAK_EN_MONTH_EP,0,4,0,1);
    End;
End;

procedure CSS301F3Meter.AddEnergyDayGraphQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;
begin
   if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   if (cDateTimeR.CompareDay(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareDay(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while (cDateTimeR.CompareDay(dt_Date2, TempDate) <> 1) do
     begin  //� ����� ������ ���������� ���� �� ��������
       cDateTimeR.DecDate(TempDate);
       Dec(i);
       if i < -30 then
         exit;
     end;
     m_nObserver.AddGraphParam(QRY_ENERGY_DAY_EP, i + 1, 0, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_DAY_EP, i + 1, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_DAY_EP, i + 1, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_DAY_EP, i + 1, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_DAY_EP, i + 1, 4, 0, 1);
     cDateTimeR.DecDate(dt_Date2);
   end;
end;

procedure CSS301F3Meter.AddEnergyMonthGrpahQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;
begin
   if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   if (cDateTimeR.CompareMonth(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareMonth(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while (cDateTimeR.CompareMonth(dt_Date2, TempDate) <> 1) do
     begin
       cDateTimeR.DecMonth(TempDate);
       Dec(i);
       if i < -24 then
         exit;
     end;
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, i + 1, 0, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, i + 1, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, i + 1, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, i + 1, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, i + 1, 4, 0, 1);
     cDateTimeR.DecMonth(dt_Date2);
   end;
end;

procedure CSS301F3Meter.AddSresEnergFNC40(dt_Date: TDateTime);
var TempDate    : TDateTime;
    h, m, s, ms : word;
    y, d, mn    : word;
    _30Srez     : TDateTime;
begin
   TempDate := trunc(Now);
   _30Srez := EncodeTime(0, 30, 0, 0);
   while TempDate <= Now - _30Srez do
   begin
     DecodeDate(TempDate, y, mn, d);
     DecodeTime(TempDate, h, m, s, ms);
     m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, mn, d, (h*60 + m) div 30, 1);
     TempDate := TempDate + _30Srez*6;
   end;
end;

procedure CSS301F3Meter.AddSresEnergGrpahQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i, Srez     : integer;
    h, m, s, ms : word;
    y, d, mn    : word;
    DeepSrez    : word;
begin
   if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   DecodeTime(Now, h, m, s, ms);
   DeepSrez := 0;
   if (cDateTimeR.CompareDay(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareDay(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     DecodeDate(dt_Date2, y, mn, d);
     if cDateTimeR.CompareDay(dt_Date2, Now) = 0 then
     Begin
      if m_nP.m_sbyTSlice = 0 then
        for Srez := (h*60 + m) div 30 - 1 downto 0 do m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, mn, d, Srez, 1)
      else
        AddSresEnergFNC40(dt_Date2);
       //m_nObserver.AddGraphParam(QM_FIN_MTR_IND, 0, 0, 0, 1);//Final Day Sres
     End else
     Begin
      Srez := 0;
      while Srez <= 47 do
      begin
        m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, mn, d, Srez, 1);
        if m_nP.m_sbyTSlice = 0 then
          Srez := Srez + 1
        else
          Srez := Srez + 6;
      end;
     End;
     cDateTimeR.DecDate(dt_Date2);
     Inc(DeepSrez);
     if (DeepSrez > 365) then
       exit;
   end;
end;
procedure CSS301F3Meter.AddLastSresEnergGrpahQry(dt_Date1, dt_Date2 : TDateTime);
var
    TempDate         : TDateTime;
    i, Srez,DeepSrez : integer;
    h0, m0, s0, ms0  : word;
    y0, d0, mn0      : word;
begin
    if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
    m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
    DeepSrez := 0;
    if (dt_Date2 >= dt_Date1) then
    Begin
     TempDate := dt_Date2;
     if (cDateTimeR.CompareDay(TempDate, Now) = 0 ) then TempDate := Now;
     while TempDate>=dt_Date1 do
     Begin
      if (DeepSrez > 47) then exit;
      DecodeDate(TempDate,y0,mn0,d0);
      DecodeTime(TempDate,h0,m0,s0,ms0);
      Srez := (h0*60+m0) div 30;
//      TraceL(3,m_nP.m_swMID,'(__)CL2MD::>SRZ: Mnt:'+IntToStr(mn0)+' Day:'+IntToStr(d0)+' Srz:'+IntToStr(Srez));
      m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, mn0, d0, Srez, 1);
      TempDate := TempDate - 1/48;
      Inc(DeepSrez);
     End;
    End;
end;

procedure CSS301F3Meter.AddNakEnDayGrpahQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;

begin
   if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   if (cDateTimeR.CompareDay(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareDay(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while (cDateTimeR.CompareDay(dt_Date2, TempDate) <> 1) do
     begin  //� ����� ������ ���������� ���� �� ��������
       cDateTimeR.DecDate(TempDate);
       Dec(i);
       if i < -30 then
         exit;
     end;
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, i + 1, 0, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, i + 1, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, i + 1, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, i + 1, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, i + 1, 4, 0, 1);
     cDateTimeR.DecDate(dt_Date2);
   end;
end;

procedure CSS301F3Meter.AddNakEnMonthGrpahQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;
begin
   {if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);     }
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   if (cDateTimeR.CompareMonth(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareMonth(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while (cDateTimeR.CompareMonth(dt_Date2, TempDate) <> 1) do
     begin
       cDateTimeR.DecMonth(TempDate);
       Dec(i);
       if i < -12 then
         exit;
     end;
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, i + 1, 0, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, i + 1, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, i + 1, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, i + 1, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, i + 1, 4, 0, 1);
     cDateTimeR.DecMonth(dt_Date2);
   end;
end;

procedure CSS301F3Meter.AddMaxPower(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i, j        : integer;
begin
   if m_nOnAutorization = 1 then
     m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   m_nObserver.AddGraphParam(QRY_KPRTEL_KE, 0, 0, 0, 1);
   if (cDateTimeR.CompareMonth(dt_Date2, Now) = 1 ) then
     dt_Date2 := Now;
   while cDateTimeR.CompareMonth(dt_Date1, dt_Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while (cDateTimeR.CompareMonth(dt_Date2, TempDate) <> 1) do
     begin
       cDateTimeR.DecMonth(TempDate);
       Dec(i);
       if i < -24 then
         exit;
     end;
     for j := 1 to 4 do
       m_nObserver.AddGraphParam(QRY_MAX_POWER_EP, i + 1, 1, j, 1);
     for j := 1 to 4 do
       m_nObserver.AddGraphParam(QRY_MAX_POWER_EP, i + 1, 2, j, 1);
     for j := 1 to 4 do
       m_nObserver.AddGraphParam(QRY_MAX_POWER_EP, i + 1, 3, j, 1);
     for j := 1 to 4 do
       m_nObserver.AddGraphParam(QRY_MAX_POWER_EP, i + 1, 4, j, 1);
     cDateTimeR.DecMonth(dt_Date2);
   end;
end;

procedure CSS301F3Meter.AddKorrGraphQry(dt_Date1 : TDateTime; srezN, srezK : byte);
var d, mn, y : word;
    i        : byte;
begin
   DecodeDate(dt_Date1, y, mn, d);
   for i := srezK downto srezN do
     m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, mn, d, i, 1);
end;

procedure CSS301F3Meter.AddEventsGraphQry(var pMsg:CMessage);
var
   i    : integer;
   nJIM : int64;
   pDS  : CMessageData;
   nQry : CQueryPrimitive;
begin
   Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
   Move(pDS.m_sbyInfo[2*sizeof(TDateTime)],nJIM,sizeof(int64));
   if m_nOnAutorization = 1 then m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
   if StrToInt(advInfo.m_sAdrToRead)<> 0 then   //if StrToInt(m_nP.m_sddPHAddres) <> 0 then
   if (nJIM and QFH_JUR_0)<>0 then
   Begin
    m_nObserver.GetQwery(QRY_JRNL_T1,nQry);if nQry.m_swSpecc0=0 then nQry.m_swSpecc0:=-5;
    m_nObserver.AddGraphParam(QRY_JRNL_T1, nQry.m_swSpecc0, 0, 0, 1);   //ADD ARCH_PHASE
   End;
   if (nJIM and QFH_JUR_1)<>0 then
   Begin
    m_nObserver.GetQwery(QRY_JRNL_T2,nQry);if nQry.m_swSpecc0=0 then nQry.m_swSpecc0:=-5;
    m_nObserver.AddGraphParam(QRY_JRNL_T2, nQry.m_swSpecc0, 0, 0, 1);   //ADD ARCH_SOST_PRIB
   End;
   if (nJIM and QFH_JUR_2)<>0 then
   Begin
    m_nObserver.GetQwery(QRY_JRNL_T3,nQry);if nQry.m_swSpecc0=0 then nQry.m_swSpecc0:=-5;
    m_nObserver.AddGraphParam(QRY_JRNL_T3, nQry.m_swSpecc0, 0, 0, 1);   //ADD ARCH_KORREC
   End;
   //m_nObserver.AddGraphParam(QRY_JRNL_T1, -32, 0, 0, 1);   //ADD ARCH_PHASE
   //m_nObserver.AddGraphParam(QRY_JRNL_T2, -32, 0, 0, 1);   //ADD ARCH_SOST_PRIB
   //m_nObserver.AddGraphParam(QRY_JRNL_T3, -32, 0, 0, 1);   //ADD ARCH_KORREC
   if StrToInt(advInfo.m_sAdrToRead) = 0 then  // if StrToInt(m_nP.m_sddPHAddres) = 0 then
   begin
     for i := 0 downto -32 do
     if (nJIM and QFH_JUR_1)<>0 then m_nObserver.AddGraphParam(QRY_JRNL_T2, i, 0, 0, 1);
     m_nObserver.AddGraphParam(QRY_SUM_KORR_MONTH, 0, 0, 0 ,1);
   end;
end;

procedure CSS301F3Meter.SetGraphQry;
begin

end;


{
procedure CSS301Meter.SetHandScenario;
Var
    pQry   : PCQueryPrimitive;
Begin
    m_nObserver.ClearCurrQry;
    while(m_nObserver.GetCommand(pQry)=True) do
    Begin
     with m_nObserver do Begin
     if pQry.m_swParamID<15 then TraceL(2,pQry.m_swMtrID,'(__)CL2MD::>CSS301 CMD INIT:'+IntToStr(pQry.m_swParamID)+':'+chQryType[pQry.m_swParamID]);
     case pQry.m_swParamID of
      EN_QRY_SUM:        //�������: ��������� �����������
      Begin
       AddCurrParam(1,0,1,0,1);
       AddCurrParam(1,0,2,0,1);
       AddCurrParam(1,0,3,0,1);
       AddCurrParam(1,0,4,0,1);
      End;
      EN_QRY_INC_DAY:    //�������: ���������� �� ����
      Begin
       AddCurrParam(2,0,1,0,1);
       AddCurrParam(2,0,2,0,1);
       AddCurrParam(2,0,3,0,1);
       AddCurrParam(2,0,4,0,1);
      End;
      EN_QRY_INC_MON:    //�������: ���������� �� �����
      Begin
       AddCurrParam(3,0,1,0,1);
       AddCurrParam(3,0,2,0,1);
       AddCurrParam(3,0,3,0,1);
       AddCurrParam(3,0,4,0,1);
      End;
      EN_QRY_SRS_30M:    //�������: C��� 30 ���
      Begin
       AddCurrParam(36,0,0,0,1);
      End;
      EN_QRY_ALL_DAY:    //�������: ������ �����
      Begin
       AddCurrParam(42,0,1,0,1);
       AddCurrParam(42,0,2,0,1);
       AddCurrParam(42,0,3,0,1);
       AddCurrParam(42,0,4,0,1);
      End;
      EN_QRY_ALL_MON:    //�������: ������ ������
      Begin
       AddCurrParam(43,0,1,0,1);
       AddCurrParam(43,0,2,0,1);
       AddCurrParam(43,0,3,0,1);
       AddCurrParam(43,0,4,0,1);
      End;
      PW_QRY_SRS_3M:     //��������:���� 3 ���
      Begin
       AddCurrParam(5,0,0,0,1);
      End;
      PW_QRY_SRS_30M:    //��������:���� 30 ���
      Begin
       AddCurrParam(6,0,0,0,1);
      End;
      PW_QRY_MGACT:      //��������:���������� ��������
      Begin
       AddCurrParam(8,0,0,0,1);
      End;
      PW_QRY_MGRCT:      //��������:���������� ����������
      Begin
       AddCurrParam(9,0,0,0,1);
      End;
      U_QRY:             //����������
      Begin
       AddCurrParam(10,0,0,0,1);
      End;
      I_QRY:             //���
      Begin
       AddCurrParam(11,0,0,0,1);
      End;
      F_QRY:             //�������
      Begin
       AddCurrParam(13,0,0,0,1);
      End;
      KM_QRY:            //����������� ��������
      Begin
       AddCurrParam(12,0,0,0,1);
      End;
      DATE_QRY:          //����-�����
      Begin
       AddCurrParam(32, 0, 0, 0, 1);
      End;
     End;
     End;//With
    End;
End;
}

function CSS301F3Meter.SelfHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    //���������� ��� L2(������ ���)
    Result := res;
End;

procedure CSS301F3Meter.Autoriztion;
begin
   m_nTxMsg.m_sbyInfo[0]  := StrToInt(advInfo.m_sAdrToRead); //StrToInt(m_nP.m_sddPHAddres);
//   TraceL(2,m_nRxMsg.m_swObjID,'(__)CL2MD::>CC301   Autoritization...');
   m_nTxMsg.m_sbyInfo[1]  := 31;
   m_nTxMsg.m_sbyInfo[2]  := $00;
   m_nTxMsg.m_sbyInfo[3]  := $00;
   move(m_nP.m_schPassword[1], m_nTxMsg.m_sbyInfo[4], 8);
   CRC(m_nTxMsg.m_sbyInfo, 12);
   MsgHead(m_nTxMsg, 13 + 12 + 2); //   MsgHead(m_nTxMsg, 11 + 12 + 2);
   SendToL1(BOX_L1 ,@m_nTxMsg);
end;

procedure CSS301F3Meter.SetTime();
var Year, Month, Day           : word;
    Hour, Min, Sec, mSec       : word;
begin
    m_nTxMsg.m_sbyInfo[0]  := StrToInt(advInfo.m_sAdrToRead); //StrToInt(m_nP.m_sddPHAddres);
//    TraceL(2,m_nRxMsg.m_swObjID,'(__)CL2MD::>CC301   Korrektion Time');
    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
    Year := Year - 2000;

    m_nTxMsg.m_sbyInfo[1]  := 16;
    m_nTxMsg.m_sbyInfo[2]  := 32;
    m_nTxMsg.m_sbyInfo[3]  := 2;
    m_nTxMsg.m_sbyInfo[4]  := Sec;
    m_nTxMsg.m_sbyInfo[5]  := Min;
    m_nTxMsg.m_sbyInfo[6]  := Hour;
    m_nTxMsg.m_sbyInfo[7]  := Day;
    m_nTxMsg.m_sbyInfo[8]  := Month;
    m_nTxMsg.m_sbyInfo[9]  := Year;
    CRC(m_nTxMsg.m_sbyInfo, 10);
    MsgHead(m_nTxMsg, 13 + 10 + 2);    //MsgHead(m_nTxMsg, 11 + 10 + 2);
    SendToL1(BOX_L1, @m_nTxMsg);
end;

procedure CSS301F3Meter.KorrTime(LastDate : TDateTime);
var Year, Month, Day           : word;
    Hour, Min, Sec, mSec       : word;
begin
    m_nTxMsg.m_sbyInfo[0]  :=StrToInt(advInfo.m_sAdrToRead);  //StrToInt(m_nP.m_sddPHAddres);
    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
    Year := Year - 2000;
    m_nTxMsg.m_sbyInfo[1]  := 16;
    m_nTxMsg.m_sbyInfo[2]  := 32;
    m_nTxMsg.m_sbyInfo[3]  := 0;
    m_nTxMsg.m_sbyInfo[4]  := Sec;
    m_nTxMsg.m_sbyInfo[5]  := Min;
    m_nTxMsg.m_sbyInfo[6]  := Hour;
    m_nTxMsg.m_sbyInfo[7]  := Day;
    m_nTxMsg.m_sbyInfo[8]  := Month;
    m_nTxMsg.m_sbyInfo[9]  := Year;
    CRC(m_nTxMsg.m_sbyInfo, 10);
    MsgHead(m_nTxMsg, 13 + 10 + 2);  //MsgHead(m_nTxMsg, 11 + 10 + 2);
    SendToL1(BOX_L1, @m_nTxMsg);
end;

procedure CSS301F3Meter.WriteDate(var pMsg : CMessage; param : word);
var i, temp          : shortint;
    Year, Month, Day : word;
    TempDate         : TDateTime;
    sm               : shortint;
begin
    move(m_nTxMsg.m_sbyInfo[3], temp, 1);
    TempDate := Now;
    case param of
      QRY_NAK_EN_MONTH_EP, QRY_ENERGY_MON_EP:
      begin
        if param = QRY_ENERGY_MON_EP then
          cDateTimeR.IncMonth(TempDate);
        for i := temp to -1 do
          cDateTimeR.DecMonth(TempDate);
        DecodeDate(TempDate, Year, Month, Day);
        m_nRxMsg.m_sbyInfo[2] := Year - 2000;
        m_nRxMsg.m_sbyInfo[3] := Month;
        m_nRxMsg.m_sbyInfo[4] := 1;
        m_nRxMsg.m_sbyInfo[5] := 00;
        m_nRxMsg.m_sbyInfo[6] := 00;
        m_nRxMsg.m_sbyInfo[7] := 00;
      end;
      QRY_ENERGY_DAY_EP, QRY_NAK_EN_DAY_EP:
      begin
        if param = QRY_ENERGY_DAY_EP then
          cDateTimeR.IncDate(TempDate);
        for i := temp to -1 do
          cDateTimeR.DecDate(TempDate);
        DecodeDate(TempDate, Year, Month, Day);
        m_nRxMsg.m_sbyInfo[2] := Year - 2000;
        m_nRxMsg.m_sbyInfo[3] := Month;
        m_nRxMsg.m_sbyInfo[4] := Day;
        m_nRxMsg.m_sbyInfo[5] := 00;
        m_nRxMsg.m_sbyInfo[6] := 00;
        m_nRxMsg.m_sbyInfo[7] := 00;
      end;
    end;
end;

procedure CSS301F3Meter.CreateJrnlReq(var nReq: CQueryPrimitive);
begin
   if nReq.m_swParamID = QRY_JRNL_T1 then
     nReq.m_swSpecc0 := nReq.m_swSpecc0 + 1
   else
     nReq.m_swSpecc0 := nReq.m_swSpecc0 - 1;
   m_nTxMsg.m_sbyInfo[1] := 3;               //fnc
   m_nTxMsg.m_sbyInfo[2] := GetCommand(nReq.m_swParamID);//parameter
   m_nTxMsg.m_sbyInfo[3] := nReq.m_swSpecc0; //smes
   m_nTxMsg.m_sbyInfo[4] := nReq.m_swSpecc1; //tar
   m_nTxMsg.m_sbyInfo[5] := nReq.m_swSpecc2;
   CRC(m_nTxMsg.m_sbyInfo, 6);
//   TraceL(3,m_nP.m_swMID,'(__)CL2MD::>LGQ2 PR:S0:S1:S2:EN '+IntTostr(nReq.m_swParamID)+
//                                    ' '+IntTostr(nReq.m_swSpecc0)+
//                                    ' '+IntTostr(nReq.m_swSpecc1)+
//                                    ' '+IntTostr(nReq.m_swSpecc2)+
//                                    ' '+IntTostr(nReq.m_sbyEnable));

   {$IFNDEF SS301_DEBUG}
   MsgHead(m_nTxMsg, 13 + 6 + 2);
   {$ELSE}
   MsgHead(m_nTxMsg, 13 + 6 + 2+4*4);
   if nReq.m_swParamID=QRY_SRES_ENR_EP then MsgHead(m_nTxMsg, 13+4+2+4*2);
   {$ENDIF}
   //if nReq.m_swParamID<MAX_PARAM then
   //TraceM(2,m_nTxMsg.m_swObjID,'(__)CL2MD::>SS301  CMD:'+m_nCommandList.Strings[nReq.m_swParamID]+' Msg:',@m_nTxMsg);
   SendOutStat(m_nTxMsg.m_swLen);
   SendToL1(BOX_L1 ,@m_nTxMsg);
 //  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
end;

function CSS301F3Meter.GetDWValue(var pMsg:CMessage;i:integer):DWORD;
begin
   move(pMsg.m_sbyInfo[4 + i*4], Result, sizeof(DWORD));
end;

function CSS301F3Meter.GetValue(var pMsg:CMessage;i:integer):Single;
Var
    byBuff : array[0..3] of Byte;
    fValue,nIV : Single;
Begin
    byBuff[0] := pMsg.m_sbyInfo[4 + i*4];
    byBuff[1] := pMsg.m_sbyInfo[5 + i*4];
    byBuff[2] := pMsg.m_sbyInfo[6 + i*4];
    byBuff[3] := pMsg.m_sbyInfo[7 + i*4];
    Move(byBuff[0],Result,sizeof(Single));
End;
procedure CSS301F3Meter.WriteValue(var pMsg:CMessage;i:integer);
Var
    fValue : Double;
begin
    fValue := RV(GetValue(pMsg,i));
    //Null Operation
    Move(fValue,m_nRxMsg.m_sbyInfo[9],sizeof(fValue));
end;
procedure CSS301F3Meter.WriteI(var pMsg:CMessage;i:integer);
Var
    fValue : Double;
begin
    fValue := RV(GetValue(pMsg,i));
    fValue := fValue*m_nP.m_sfKI;
    Move(fValue,m_nRxMsg.m_sbyInfo[9],sizeof(fValue));
end;
procedure CSS301F3Meter.WriteU(var pMsg:CMessage;i:integer);
Var
    fValue : Double;
begin
    fValue := RV(GetValue(pMsg,i));
    fValue := fValue*m_nP.m_sfKU;
    Move(fValue,m_nRxMsg.m_sbyInfo[9],sizeof(fValue));
end;
procedure CSS301F3Meter.WriteP(var pMsg:CMessage;i:integer);
Var
    fValue : Double;
begin
    //Operation
    //fValue := RVK(GetValue(pMsg,i));
    fValue := RVK(GetValue(pMsg,i));
    fValue := fValue*m_nP.m_sfKI*m_nP.m_sfKU/1000;
    Move(fValue,m_nRxMsg.m_sbyInfo[9],sizeof(fValue));
end;
procedure CSS301F3Meter.WriteE(var pMsg:CMessage;i:integer);
Var
    Value  : single;
    fValue : double;
    dwTemp : DWORD;
    pArray : PBYTEARRAY;
begin
    try
//    fValue := RVK(GetDWValue(pMsg,i)*Ke);
    fValue     := GetDWValue(pMsg,i);
    fValue:=fValue*Ke;//1000000;;
    {pArray    := @Value;
    pArray[0] := pArray[0] and $FC;
    fValue    := Value/1000000;}

    if m_nP.m_swMID=11 then begin end;
//    TraceL(2,pMsg.m_swObjID,'(__)CL2MD::>SS301 DOPROC : '+
//    m_nCommandList.Strings[m_nRxMsg.m_sbyInfo[1]]+'::'+
//    FloatToStr(GetValue(pMsg,i)));

    if fValue<=0.0000001 then
     fValue := 0;
    fValue := fValue*m_nP.m_sfKI*m_nP.m_sfKU{*m_nP.m_sfMeterKoeff};
    Move(fValue,m_nRxMsg.m_sbyInfo[9],sizeof(fValue));
    except

    end;
end;

function CSS301F3Meter.ReadSlices666(var pMsg:CMessage):boolean;
var Year, Month, Day          : word;
    YearNow, MonthNow, DayNow : word;
    SrezNow, i                : word;
    tmp                       : word;
    param                     : double;
    TempDate                  : TDateTime;
    KindEn, SlN               : integer;
begin
   DecodeDate(Now, YearNow, MonthNow, DayNow);
   Month    := m_nTxMsg.m_sbyInfo[3];
   Day      := m_nTxMsg.m_sbyInfo[4];
   SrezNow  := m_nTxMsg.m_sbyInfo[5];
   if (Month > MonthNow) or ((MonthNow = Month) and (Day > DayNow)) then
     Year := YearNow - 1
   else
     Year := YearNow;
   if ((Day>31)or(Day=0)or(Month>12)or(Month=0)) then exit;
   TempDate := EncodeDate(Year, Month, Day);
   for i := SrezNow to SrezNow + 23 do
   begin
     SlN      := SrezNow + (i - SrezNow) div 4;
     KindEn   := (i - SrezNow) mod 4;
     TempDate := SlN div 48 + TempDate;
     DecodeDate(TempDate, Year, Month, Day);
     //if TempDate > Now then
     //  continue;
     if (trunc(Now) = trunc(TempDate)) and (SlN > frac(Now)/EncodeTime(0, 30, 0, 0) - 1) then
       continue;
     move(pMsg.m_sbyInfo[4+(i - SrezNow)*2], tmp, 2);
     param := tmp*Ke;
     if param<0.000001 then param := 0;
     param := RVK(param)*m_nP.m_sfKI*m_nP.m_sfKU;
     move(param, m_nRxMsg.m_sbyInfo[9], sizeof(param));
     m_nRxMsg.m_sbyInfo[0]  := 13+4;
     m_nRxMsg.m_sbyInfo[1]  := QRY_SRES_ENR_EP + KindEn;
     m_nRxMsg.m_sbyInfo[2]  := Year - 2000;
     m_nRxMsg.m_sbyInfo[3]  := Month;
     m_nRxMsg.m_sbyInfo[4]  := Day;
     m_nRxMsg.m_sbyInfo[5]  := (SlN mod 48) div 2;
     m_nRxMsg.m_sbyInfo[6]  := (SlN mod 48) mod 2 * 30;
     m_nRxMsg.m_sbyInfo[7]  := 0;
     m_nRxMsg.m_sbyInfo[8]  := 0;
     m_nRxMsg.m_sbyServerID := SlN mod 48;
     m_nRxMsg.m_swLen       := m_nRxMsg.m_sbyInfo[0] + 13;//11
     saveToDB(m_nRxMsg);//FPUT(BOX_L3_BY, @m_nRxMsg);
   end;
end;

function  CSS301F3Meter.ProcessingData(var pMsg:CMessage; var i:integer) : boolean;
var Year, Month, Day       : word;
YearNow, MonthNow, DayNow,tmp : word;
Hour, Min, Sec, mSec       : word;
param                      : single;
fParam                     : Double;
LastDate                   : TDateTime;
nKorrTime                  : Integer;
begin
    Result := true;
    {$IFNDEF SS301_DEBUG}
    if (pMsg.m_sbyInfo[3] <> 0) then
      Result := false;
    {$endif}
    case (pMsg.m_sbyInfo[2]) of
      1:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_ENERGY_SUM_EP + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4];
        //m_nRxMsg.m_sbyInfo[8] := nReqSv.m_swSpecc1;
        //Move(pMsg.m_sbyInfo[9],fValue,sizeof(Single));
        WriteE(pMsg,i);
      End;
      2:
      Begin
        {$IFDEF SS301_DEBUG}
        m_nTxMsg.m_sbyInfo[5] := 0;
        {$ENDIF}
        m_nRxMsg.m_sbyInfo[1] := QRY_ENERGY_DAY_EP + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4];
        WriteE(pMsg,i);
        WriteDate(pMsg, QRY_ENERGY_DAY_EP);
      End;
      3:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_ENERGY_MON_EP + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4];
        WriteE(pMsg,i);
        WriteDate(pMsg, QRY_ENERGY_MON_EP);
      End;
      5:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_E3MIN_POW_EP  + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteP(pMsg,i);
      End;
      6:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_E30MIN_POW_EP + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteP(pMsg,i);
      End;
      7:
      begin
        m_nRxMsg.m_sbyInfo[1] := QRY_MAX_POWER_EP  + (m_nTxMsg.m_sbyInfo[5]-1);
        {$IFNDEF SS301_DEBUG}
        m_nRxMsg.m_sbyInfo[2] := pMsg.m_sbyInfo[9];//Year
        m_nRxMsg.m_sbyInfo[3] := pMsg.m_sbyInfo[8];//Month
        m_nRxMsg.m_sbyInfo[4] := pMsg.m_sbyInfo[7];//Day
        m_nRxMsg.m_sbyInfo[5] := pMsg.m_sbyInfo[6];//Hour
        m_nRxMsg.m_sbyInfo[6] := pMsg.m_sbyInfo[5];//Min
        m_nRxMsg.m_sbyInfo[7] := pMsg.m_sbyInfo[4];//Sec
        //m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4]; //tariff
        {$ELSE}
        m_nRxMsg.m_sbyInfo[2] := 10;//Year
        m_nRxMsg.m_sbyInfo[3] := 07;//Month
        m_nRxMsg.m_sbyInfo[4] := 13;//Day
        m_nRxMsg.m_sbyInfo[5] := 0;//Hour
        m_nRxMsg.m_sbyInfo[6] := 0;//Min
        m_nRxMsg.m_sbyInfo[7] := 0;//Sec
        if m_nTxMsg.m_sbyInfo[4]=1 then param := 23.65478/1000;
        if m_nTxMsg.m_sbyInfo[4]=2 then param := 33.65478/1000;
        if m_nTxMsg.m_sbyInfo[4]=3 then param := 43.65478/1000;
        if m_nTxMsg.m_sbyInfo[4]=4 then param := 53.65478/1000;
        move(param,pMsg.m_sbyInfo[10],4);
        {$ENDIF}
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4]; //tariff
        move(pMsg.m_sbyInfo[10], param, 4);
        fParam := param;
        fParam := RV(fParam)*m_nP.m_sfKI*m_nP.m_sfKU/1000;
        move(fParam, m_nRxMsg.m_sbyInfo[9], sizeof(fParam));
        i := 14;
      end;
      8:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_MGAKT_POW_S   + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteP(pMsg,i);
      End;
      9:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_MGREA_POW_S   + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteP(pMsg,i);
      End;
      10:
      Begin
        {$IFDEF SS301_DEBUG}
        m_nTxMsg.m_sbyInfo[5] := 0;
        {$ENDIF}
        m_nRxMsg.m_sbyInfo[1] := QRY_U_PARAM_A     + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteU(pMsg,i);
      End;
      11:
      Begin
        {$IFDEF SS301_DEBUG}
        m_nTxMsg.m_sbyInfo[5] := 0;
        {$ENDIF}
        m_nRxMsg.m_sbyInfo[1] := QRY_I_PARAM_A    + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteI(pMsg,i);
      End;
      12:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_KOEF_POW_A    + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteValue(pMsg,i);
      End;
      13:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_FREQ_NET      + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := 0;
        WriteValue(pMsg,i);
      End;
      14, 15, 16:
      Begin
        Result := false;
        m_nRxMsg.m_sbyType    := PH_EVENTS_INT;
        m_nRxMsg.m_swLen      := 13 + 9 + 3; //11
        m_nRxMsg.m_sbyInfo[0] := 9 + 3;
        m_nRxMsg.m_sbyInfo[1] := QRY_JRNL_T1 + pMsg.m_sbyInfo[2] - 14;
        if StrToInt(advInfo.m_sAdrToRead) = 0 then//if StrToInt(m_nP.m_sddPHAddres) = 0 then
          m_nRxMsg.m_sbyInfo[1] := QRY_JRNL_T2;
        {$IFDEF SS301_DEBUG}
        DecodeDate(Now, Year, Month, Day);
        DecodeTime(Now, Hour, Min, Sec, mSec);
        Year := Year - 2000;
        m_nRxMsg.m_sbyInfo[2] := Year;
        m_nRxMsg.m_sbyInfo[3] := Month;
        m_nRxMsg.m_sbyInfo[4] := Day;
        m_nRxMsg.m_sbyInfo[5] := Hour;
        m_nRxMsg.m_sbyInfo[6] := Min;
        m_nRxMsg.m_sbyInfo[7] := Sec;
        {$ELSE}
        m_nRxMsg.m_sbyInfo[2] := pMsg.m_sbyInfo[9];
        m_nRxMsg.m_sbyInfo[3] := pMsg.m_sbyInfo[8];
        m_nRxMsg.m_sbyInfo[4] := pMsg.m_sbyInfo[7];
        m_nRxMsg.m_sbyInfo[5] := pMsg.m_sbyInfo[6];
        m_nRxMsg.m_sbyInfo[6] := pMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[7] := pMsg.m_sbyInfo[4];
        m_nRxMsg.m_sbyInfo[8] := StrToInt(advInfo.m_sAdrToRead);  //StrToInt(m_nP.m_sddPHAddres);
        move(pMsg.m_sbyInfo[10], m_nRxMsg.m_sbyInfo[9], 3);
        i := i + 4;
        {$ENDIF}
        if ((nReq.m_swSpecc0 = DepthEvEnd)) and (nReq.m_swParamID = QRY_JRNL_T1)  then
          m_nRxMsg.m_sbyInfo[11] := 1
        else
          m_nRxMsg.m_sbyInfo[11] := 0;
        if (DepthEvEnd = nReq.m_swSpecc0) and (nReq.m_swParamID <> QRY_JRNL_T1) then
          Result := true;
        if (nReq.m_swSpecc0 = -1) and (nReq.m_swParamID = QRY_JRNL_T1) then
          Result := true;
        if not Result then
          CreateJrnlReq(nReq);

        case m_nRxMsg.m_sbyInfo[1] of
             QRY_JRNL_T1 : ReadPhaseJrnl(m_nRxMsg);
             QRY_JRNL_T2 : ReadStateJrnl(m_nRxMsg);
             QRY_JRNL_T3 : ReadKorrJrnl(m_nRxMsg);
        End;
        //FPUT(BOX_L3_BY, @m_nRxMsg);
      End;
      24:
      Begin
        {$IFNDEF SS301_DEBUG}
        Ke := (pMsg.m_sbyInfo[8] + pMsg.m_sbyInfo[9]*$100)/1000000;
        {$ELSE}
        Ke := 250/1000000;
        {$ENDIF}
//        TraceL(3,pMsg.m_swObjID,'(__)CL2MD::>Ke = :' + FloatToStrF(Ke, ffFixed, 10, 7));
        i := i + 4;
        FinalAction;
        Result := false; //false
      End;
      32:
      Begin
        {$IFDEF SS301_DEBUG}
          DecodeDate(Now, Year, Month, Day);
          DecodeTime(Now, Hour, Min, Sec, mSec);
          pMsg.m_sbyInfo[9]:=Year-2000;
          pMsg.m_sbyInfo[8]:=Month;
          pMsg.m_sbyInfo[7]:=Day;
          pMsg.m_sbyInfo[6]:=Hour;
          pMsg.m_sbyInfo[5]:=Min;
          pMsg.m_sbyInfo[4]:=0;
        {$ENDIF}
        m_nRxMsg.m_sbyInfo[0] := 8;
        m_nRxMsg.m_sbyInfo[1] := QRY_DATA_TIME;
        m_nRxMsg.m_sbyInfo[2] := pMsg.m_sbyInfo[9];//Year
        m_nRxMsg.m_sbyInfo[3] := pMsg.m_sbyInfo[8];//Month
        m_nRxMsg.m_sbyInfo[4] := pMsg.m_sbyInfo[7];//Day
        m_nRxMsg.m_sbyInfo[5] := pMsg.m_sbyInfo[6];//Hour
        m_nRxMsg.m_sbyInfo[6] := pMsg.m_sbyInfo[5];//Min
        m_nRxMsg.m_sbyInfo[7] := pMsg.m_sbyInfo[4];//Sec
        i:=i+3;
        DecodeDate(Now, Year, Month, Day);
        DecodeTime(Now, Hour, Min, Sec, mSec);
        //�������� �������� �������� ���������� ��� �������� ����
        if nOldYear<>Year then
        Begin
         m_nP.m_sdtSumKor :=cDateTimeR.SecToDateTime(0);
         m_pDB.UpdateTimeKorr(m_nP.m_swMID, m_nP.m_sdtSumKor);
        End;
        nOldYear := Year;
        LastDate := EncodeDate(pMsg.m_sbyInfo[9] + 2000, pMsg.m_sbyInfo[8], pMsg.m_sbyInfo[7]) +
                    EncodeTime(pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[4], 0);
        Year := Year - 2000;
        //���������� ����� ������� �� ����������������� ��������
        if (m_nP.m_bySynchro=1) then
        Begin
         if m_nMSynchKorr.m_blEnable=False then
         Begin
          m_nMSynchKorr.m_tmTime := LastDate;
          cDateTimeR.KorrTimeToPC(m_nMSynchKorr.m_tmTime,m_nMaxKorrTime);
          FinalAction;
          exit;
         End else m_nMSynchKorr.m_blEnable := False;
        End;
        //��������� �������

        nKorrTime :=5;
        if ((m_nIsOneSynchro=1)and(m_nP.m_blOneSynchro=True)) then nKorrTime :=1;

        if (Year <> pMsg.m_sbyInfo[9]) or (Month <> pMsg.m_sbyInfo[8]) or (Day <> pMsg.m_sbyInfo[7])
        or (Hour <> pMsg.m_sbyInfo[6]) or (Min <> pMsg.m_sbyInfo[5]) or (abs(pMsg.m_sbyInfo[4] - Sec) >= nKorrTime) then
        begin
         //����� �������� ��������������� ������ ���� ���� ��� ����� ��������� ������� �������
         if (m_nIsOneSynchro=0)or((m_nIsOneSynchro=1)and(m_nP.m_blOneSynchro=True)) then
          Begin
          if m_nIsOneSynchro=1 then m_nP.m_blOneSynchro := False;
          {$IFNDEF SS301_DEBUG}
           KorrTime(LastDate);
           {$ELSE}
           FinalAction;
          {$ENDIF}
          End else FinalAction;
         end else FinalAction;
      End;
      36:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_SRES_ENR_EP    + i;
        m_nRxMsg.m_sbyInfo[8] := 0;
        m_nRxMsg.m_sbyServerID := m_nTxMsg.m_sbyInfo[5];
        move(pMsg.m_sbyInfo[4+i*2], tmp, 2);
        fParam := tmp*Ke;
        if fParam<0.000001 then fParam := 0;
        fParam := RVK(fParam)*m_nP.m_sfKI*m_nP.m_sfKU;
        move(fParam, m_nRxMsg.m_sbyInfo[9], sizeof(fParam));
        DecodeDate(Now, YearNow, MonthNow, DayNow);
        Month := m_nTxMsg.m_sbyInfo[3];
        Day   := m_nTxMsg.m_sbyInfo[4];
        Hour  := trunc(m_nTxMsg.m_sbyInfo[5] / 2);
        Min   := m_nTxMsg.m_sbyInfo[5] mod 2 * 30;
        Sec   := 0;
        if (Month > MonthNow) or ((MonthNow = Month) and (Day > DayNow)) then
          Year := YearNow - 1
        else
          Year := YearNow;
        m_nRxMsg.m_sbyInfo[0] := 13+4;
        m_nRxMsg.m_sbyInfo[2] := Year - 2000;
        m_nRxMsg.m_sbyInfo[3] := Month;
        m_nRxMsg.m_sbyInfo[4] := Day;
        m_nRxMsg.m_sbyInfo[5] := Hour;
        m_nRxMsg.m_sbyInfo[6] := Min;
        m_nRxMsg.m_sbyInfo[7] := Sec;
      End;
      40:
      Begin
        ReadSlices666(pMsg);
        i      := i + 24;
      End;
      42:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_NAK_EN_DAY_EP    + i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4];
        WriteE(pMsg,i);
        WriteDate(pMsg, QRY_NAK_EN_DAY_EP);

      End;
      43:
      Begin
        m_nRxMsg.m_sbyInfo[1] := QRY_NAK_EN_MONTH_EP+ i + m_nTxMsg.m_sbyInfo[5];
        m_nRxMsg.m_sbyInfo[8] := m_nTxMsg.m_sbyInfo[4];
        WriteE(pMsg,i);
        WriteDate(pMsg, QRY_NAK_EN_MONTH_EP);
      End;
      45:
      Begin
        DecodeDate(Now, Year, Month, Day);
        DecodeTime(Now, Hour, Min, Sec, mSec);
        Year := Year - 2000;
        m_nRxMsg.m_sbyType    := PH_EVENTS_INT;
        m_nRxMsg.m_sbyInfo[0] := 11 + 9 + 2;
        m_nRxMsg.m_sbyInfo[1] := QRY_SUM_KORR_MONTH;
        m_nRxMsg.m_sbyInfo[2] := Year;
        m_nRxMsg.m_sbyInfo[3] := Month;
        m_nRxMsg.m_sbyInfo[4] := Day;
        m_nRxMsg.m_sbyInfo[5] := Hour;
        m_nRxMsg.m_sbyInfo[6] := Min;
        m_nRxMsg.m_sbyInfo[7] := Sec;
        move(pMsg.m_sbyInfo[4], m_nRxMsg.m_sbyInfo[9], 2);
        i := i + 10;
      End;
    End;
end;

function CSS301F3Meter.SendToL3(var pMsg:CMessage) : boolean;
Var Hour, Min, Sec, mSec   : word;
    Year, Month, Day       : word;
    i                      : integer;
    fV : array[0..3] of Single;
    wV : array[0..3] of Word;
begin
    i := 0;
    Result := false;
    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
    Year := Year - 2000;
    m_nRxMsg.m_sbyType    := DL_DATARD_IND;
    //if m_byMonitor=1 then
    //m_nRxMsg.m_sbyType    := DL_MONINFO_IND;
    m_nRxMsg.m_sbyFor     := DIR_L2TOL3;
    m_nRxMsg.m_swObjID    := m_nP.m_swMID;
    //m_nRxMsg.m_sbyIntID   := m_byMonitorID;
    m_nRxMsg.m_sbyInfo[0] := 13+4;
    m_nRxMsg.m_sbyInfo[2] := Year;
    m_nRxMsg.m_sbyInfo[3] := Month;
    m_nRxMsg.m_sbyInfo[4] := Day;
    m_nRxMsg.m_sbyInfo[5] := Hour;
    m_nRxMsg.m_sbyInfo[6] := Min;
    m_nRxMsg.m_sbyInfo[7] := Sec;
    //Move(m_nnMonitorID,m_nRxMsg.m_sbyInfo[17],sizeof(int64));
    if IsUpdate=1 then
    Begin
     m_nRxMsg.m_sbyDirID    := 1;
     if not((nReq.m_swParamID>=QRY_SRES_ENR_EP)and(nReq.m_swParamID<=QRY_SRES_ENR_RM)) then
     Begin
      //if (m_nCounter>0)and((m_nCounter mod 4)=0) then Inc(m_nCounter1);
      //m_nRxMsg.m_sbyServerID := m_nCounter1;
     End;
     Inc(m_nCounter);
     //m_nCounter := m_nCounter + 1;
    End else
    Begin
     m_nRxMsg.m_sbyDirID    := 0;
     m_nRxMsg.m_sbyServerID := 0;
    End;

    //while ((7 + i*4) < (pMsg.m_swLen - 11 - 2)) and ((7 + i*4 ) < (300)) do
    while ((7 + i*4 < pMsg.m_swLen - 13 - 2) and (pMsg.m_sbyInfo[2] <> GetCommand(QRY_SRES_ENR_EP))) or //11-2
    ((4 + i*2 < pMsg.m_swLen - 13 - 2) and (pMsg.m_sbyInfo[2] = GetCommand(QRY_SRES_ENR_EP))) do        //11-2
    begin
      //TraceL(3,m_nRxMsg.m_swObjID,'(__)CL2MD::>SS301  DO PROC:');
      {$IFDEF SS301_DEBUG}
      Randomize;
        if pMsg.m_sbyInfo[2]<>24 then
        if (pMsg.m_sbyInfo[2]<>GetCommand(QRY_SRES_ENR_EP)) then
        Begin
         if i=0 then Begin fV[i]:=(m_nP.m_swMID+1)*(4*(1+m_fModel));Move(fV[i],pMsg.m_sbyInfo[4 + i*4],sizeof(Single));End;
         if i=1 then Begin fV[i]:=(m_nP.m_swMID+1)*(3*(1+m_fModel));Move(fV[i],pMsg.m_sbyInfo[4 + i*4],sizeof(Single));End;
         if i=2 then Begin fV[i]:=(m_nP.m_swMID+1)*(2*(1+m_fModel));Move(fV[i],pMsg.m_sbyInfo[4 + i*4],sizeof(Single));End;
         if i=3 then Begin fV[i]:=(m_nP.m_swMID+1)*(1*(1+m_fModel));Move(fV[i],pMsg.m_sbyInfo[4 + i*4],sizeof(Single));End;
        End else
        if (pMsg.m_sbyInfo[2]=GetCommand(QRY_SRES_ENR_EP)) then
        Begin
         if i=0 then Begin wV[i]:=(m_nP.m_swMID+1)*(1+m_nCounter);Move(wV[i],pMsg.m_sbyInfo[4 + i*2],sizeof(Word));End;
         if i=1 then Begin wV[i]:=(m_nP.m_swMID+1)*(2+m_nCounter);Move(wV[i],pMsg.m_sbyInfo[4 + i*2],sizeof(Word));End;
         if i=2 then Begin wV[i]:=(m_nP.m_swMID+1)*(3+m_nCounter);Move(wV[i],pMsg.m_sbyInfo[4 + i*2],sizeof(Word));End;
         if i=3 then Begin wV[i]:=(m_nP.m_swMID+1)*(4+m_nCounter);Move(wV[i],pMsg.m_sbyInfo[4 + i*2],sizeof(Word));End;
        End;
        if (m_nP.m_sbyTSlice=1)and(pMsg.m_sbyInfo[2] = 40) then
          TestMessageFNC40(pMsg);
     {$ENDIF}
      if (ProcessingData(pMsg, i)) then
      begin
        Result := true;
        m_nRxMsg.m_swLen    := 13 + m_nRxMsg.m_sbyInfo[0];
        if (pMsg.m_sbyInfo[2] <> 32) and (pMsg.m_sbyInfo[2] <> 40) and (pMsg.m_sbyInfo[2] <> 14) and (pMsg.m_sbyInfo[2] <> 15) and (pMsg.m_sbyInfo[2] <> 16) then
         saveToDB(m_nRxMsg); //FPUT(BOX_L3_BY,@m_nRxMsg);
        i := i+1;
        if m_nRxMsg.m_sbyInfo[1] = QRY_DATA_TIME then
          break;
      end
      else
      begin
        Result := false;
        exit;
      end;
    end;
end;
function CSS301F3Meter.LoHandler(var pMsg0:CMessage):Boolean;
Var
    res    : Boolean;
    fValue : Single;
    pMsg:CMessage;
Begin
    res := true;   //� ����� ������ ���� ���� ���� LoHandler ��������� true ���� ��� �� ���� ��� �� false
    //���������� ��� L1
    move(pMsg0,pMsg,sizeof(CMessage));
    case pMsg.m_sbyType of
      PH_DATA_IND:
      Begin
        //TraceM(2,pMsg.m_swObjID,'(__)CL2MD::>SS301  L1IN:',@pMsg);
        if (pMsg.m_sbyInfo[1] <> 3) and (pMsg.m_sbyInfo[1] <> 4) then
        Begin
          {$IFNDEF SS301_DEBUG}
          if ((m_nTxMsg.m_sbyInfo[2] = 14) or (m_nTxMsg.m_sbyInfo[2] = 15) or (m_nTxMsg.m_sbyInfo[2] = 16)) then
          begin
            if (m_nTxMsg.m_sbyInfo[2] = 14) and (nReq.m_swSpecc0 = -1) then
            begin
              Inc(DepthEvEnd);
              CreateJrnlReq(nReq);
            end else
              FinalAction;
          end;
          if (pMsg.m_sbyInfo[1] = 31) and (m_nOnAutorization = 1) then
          begin
            //TraceL(2,m_nRxMsg.m_swObjID,'(__)CL2MD::>CC301   Autoritization Complited...');
            //FinalAction;
            exit;
          end;
          if pMsg.m_sbyInfo[1] = 31 then
          begin
            exit;
          end;
          if (pMsg.m_sbyInfo[1] = 16) and (pMsg.m_sbyInfo[2]  = 32) then
          begin
              Result:=true;
              exit;
          end;
          if (pMsg.m_sbyInfo[1] = 16) or (pMsg.m_sbyInfo[1] = 144) then
          begin
            if (pMsg.m_sbyInfo[1] = 144) and (pMsg.m_sbyInfo[2] = 32) then
              ErrorCorrEv;
            exit;
          end;
          exit;
          {$ENDIF}
        End;
        if CRC(pMsg.m_sbyInfo[0], pMsg.m_swLen - 13 - 2) <> true then
        Begin
          {$IFNDEF SS301_DEBUG}
          res:=false;
          exit;
          {$ENDIF}
        End;
        if (pMsg.m_sbyInfo[0]<>StrToInt(advInfo.m_sAdrToRead))then //if (pMsg.m_sbyInfo[0]<>StrToInt(m_nP.m_sddPHAddres)) then
        Begin
         {$IFNDEF SS301_DEBUG}
         res:=false;
         exit;
         {$ENDIF}
        End;
        m_byRep        := m_nP.m_sbyRepMsg;

        if SendToL3(pMsg) then
        begin
         if pMsg.m_sbyInfo[2] <> 32 then
         begin
           res:=true;
         end;
        end;
      end;
      QL_CONNCOMPL_REQ: OnConnectComplette(pMsg);
      QL_DISCCOMPL_REQ: OnDisconnectComplette(pMsg);
    End;
    Result := res;
End;

procedure CSS301F3Meter.TestMessage(var pMsg:CMessage);
Var
    Year, Month, Day, Hour, Min, Sec, mSec:Word;
    fValue : Single;
Begin
//    TraceM(2,pMsg.m_swObjID,'(__)CL2MD::>SS301  DIN:',@pMsg);
    pMsg.m_swLen   := 13+13;
    pMsg.m_sbyFor  := DIR_L2TOL3;
    pMsg.m_sbyType := DL_DATARD_IND;
    //m_nCounter     := m_nP.m_swMID;
    fValue := pMsg.m_sbyInfo[2]+3*pMsg.m_sbyInfo[4];
    Move(fValue,pMsg.m_sbyInfo[9],sizeof(Single));

    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
    Year := Year - 2000;
    pMsg.m_sbyInfo[0] := 13;
    pMsg.m_sbyInfo[1] := pMsg.m_sbyInfo[2];
    pMsg.m_sbyInfo[2] := Year;
    pMsg.m_sbyInfo[3] := Month;
    pMsg.m_sbyInfo[4] := Day;
    pMsg.m_sbyInfo[5] := Hour;
    pMsg.m_sbyInfo[6] := Min;
    pMsg.m_sbyInfo[7] := Sec;

    saveToDB(m_nRxMsg);//FPUT(BOX_L3_BY,@pMsg);
    m_byRep := m_nP.m_sbyRepMsg;
//    m_nRepTimer.OffTimer;
//    SendSyncEvent;
End;

procedure CSS301F3Meter.TestMessageFNC40(var pMsg:CMessage);
var tempStr : string;
    cnt     : Integer;
begin
   tempStr := GetStringFromFile('d:\Kon2\TraceForDebug\TstSS301(fnc40).txt', 1);
   EncodeStrToBufArr(tempStr, pMsg.m_sbyInfo[0], cnt);
   pMsg.m_swLen := cnt + 11;
end;

procedure CSS301F3Meter.GetTimeValue(var nReq: CQueryPrimitive);
var Year, Month, Day       : word;
    Min, Hour, Sec, ms     : word;
    DateLast               : TDateTime;
    _30Min                 : TDateTime;
begin
   _30Min  := EncodeTime(0, 30, 0, 0);
   if m_nP.m_sbyTSlice = 1 then
   begin
     DecodeDate(Now - _30Min*5, Year, Month, Day);
     DecodeTime(Now - _30Min*5, Hour, Min, Sec, ms);
   end else
   begin
     DecodeDate(Now, Year, Month, Day);
     DecodeTime(Now, Hour, Min, Sec, ms);
   end;
   nReq.m_swSpecc0 := Month;
   {nReq.m_swSpecc1 := 14;
   nReq.m_swSpecc2 := 20;}
   nReq.m_swSpecc1 := Day;
   if (Hour*60 + Min) > 30 then
     nReq.m_swSpecc2 := trunc((Hour*60 + Min)/30)-1
   else
   begin
     DateLast := Now;
     cDateTimeR.DecDate(DateLast);
     DecodeDate(DateLast, Year, Month, Day);
     nReq.m_swSpecc0 := Month;
     nReq.m_swSpecc1 := Day;
     nReq.m_swSpecc2 := 47;
   end;
   nReq.m_swSpecc2 := nReq.m_swSpecc2;
end;

procedure CSS301F3Meter.HandQryRoutine(var pMsg:CMessage);
Var
    Date1, Date2 : TDateTime;
    param        : word;
    wPrecize     : word;
    szDT         : word;
    pDS          : CMessageData;
begin
    IsUpdate := 1;
    m_nCounter := 0;
    m_nCounter1:= 0;
    //m_nObserver.ClearGraphQry;
    szDT := sizeof(TDateTime);
    Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
    Move(pDS.m_sbyInfo[0],Date1,szDT);
    Move(pDS.m_sbyInfo[szDT],Date2,szDT);
    param    := pDS.m_swData1;
    wPrecize := pDS.m_swData2;
    if (pDS.m_swData3<>1) then m_nObserver.ClearGraphQry;
    //m_nObserver.AddGraphParam(QM_ENT_MTR_IND, 0, 0, 0, 1);//Enter
    case param of
     QRY_ENERGY_DAY_EP   : AddEnergyDayGraphQry(Date1, Date2);
     QRY_ENERGY_MON_EP   : AddEnergyMonthGrpahQry(Date1, Date2);
     QRY_SRES_ENR_EP,QRY_SRES_ENR_EM,
     QRY_SRES_ENR_RP,QRY_SRES_ENR_RM
                         : AddSresEnergGrpahQry(Date1, Date2);//if wPrecize=0 then AddSresEnergGrpahQry(Date1, Date2) else
                           //if wPrecize=1 then AddLastSresEnergGrpahQry(Date1, Date2);
     QRY_NAK_EN_DAY_EP   : AddNakEnDayGrpahQry(Date1, Date2);
     QRY_NAK_EN_MONTH_EP : AddNakEnMonthGrpahQry(Date1, Date2);
     QRY_MAX_POWER_EP    : AddMaxPower(Date1, Date2);
    end;
end;
function CSS301F3Meter.HiHandler(var pMsg:CMessage):Boolean;
Var
    res          : Boolean;
    tempP        : ShortInt;
Begin
    res := False;
    m_nRxMsg.m_sbyServerID := 0;
    case pMsg.m_sbyType of
      QL_DATARD_REQ:
      Begin
       Move(pMsg.m_sbyInfo[0],nReq,sizeof(CQueryPrimitive));

       if nReq.m_swParamID=QM_ENT_MTR_IND   then Begin OnEnterAction;exit;End;
       if nReq.m_swParamID=QM_FIN_MTR_IND   then Begin OnFinalAction;exit;End;

       case nReq.m_swParamID of
          QRY_DATA_TIME      : begin
                                 KorrTime(Now); exit;    //��������� �������
                               end;
       end;
       m_nTxMsg.m_sbyInfo[0] := StrToInt(advInfo.m_sAdrToRead); //StrToInt(m_nP.m_sddPHAddres);  //adress
       if ((GetCommand(nReq.m_swParamID) = 36) or (GetCommand(nReq.m_swParamID) = 40)) and (nReq.m_swSpecc0 = 0){ and (nReq.m_swSpecc1 = 0)} and (nReq.m_swSpecc2 = 0) then
       begin
        GetTimeValue(nReq);
       end;
       if nReq.m_swParamID = QRY_SRES_ENR_DAY_EP then
       begin
         SendSyncEvent;
         exit;
       end;
       if (nReq.m_swParamID = QRY_AUTORIZATION) and (m_nOnAutorization = 1) then
       begin
         Autoriztion;
        // m_nRepTimer.OnTimer(m_nP.m_swRepTime);
         exit;
       end;
       if (nReq.m_swParamID=QRY_JRNL_T1) or (nReq.m_swParamID=QRY_JRNL_T2) or (nReq.m_swParamID=QRY_JRNL_T3) then
       begin
         DepthEvEnd      := nReq.m_swSpecc0;
         if nReq.m_swParamID <> QRY_JRNL_T1 then
           nReq.m_swSpecc0 := 0;
         nReq.m_swSpecc1 := 0;
         nReq.m_swSpecc2 := 0;
       end;

        m_nTxMsg.m_sbyInfo[1] := 3;               //fnc
        m_nTxMsg.m_sbyInfo[2] := GetCommand(nReq.m_swParamID);//parameter
        m_nTxMsg.m_sbyInfo[3] := nReq.m_swSpecc0; //smes
        m_nTxMsg.m_sbyInfo[4] := nReq.m_swSpecc1; //tar
        tempP                 := nReq.m_swSpecc2;
        move(tempP, m_nTxMsg.m_sbyInfo[5], 1);    //spec
        CRC(m_nTxMsg.m_sbyInfo, 6);

        {$IFNDEF SS301_DEBUG}
        MsgHead(m_nTxMsg, 13 + 6 + 2);
        {$ELSE}
        MsgHead(m_nTxMsg, 13 + 6 + 2+4*4);
        if nReq.m_swParamID=QRY_SRES_ENR_EP then MsgHead(m_nTxMsg, 13+4+2+4*2);
        {$ENDIF}
//        TraceM(2,m_nTxMsg.m_swObjID,'(__)CL2MD::>SS301  CMD:'+m_nCommandList.Strings[nReq.m_swParamID]+' Msg:',@m_nTxMsg);
       // SendOutStat(m_nTxMsg.m_swLen);
        SendToL1(BOX_L1 ,@m_nTxMsg);
      End;
      QL_DATA_GRAPH_REQ    : HandQryRoutine(pMsg);
      QL_DATA_FIN_GRAPH_REQ: OnFinHandQryRoutine(pMsg);
      QL_LOAD_EVENTS_REQ   : AddEventsGraphQry(pMsg);
    End;
    Result := res;
End;
procedure CSS301F3Meter.OnEnterAction;
Begin
//    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>SS301 OnEnterAction');
    if (m_nP.m_sbyEnable=1)and(m_nP.m_sbyModem=1) then
    OpenPhone else
    if (m_nP.m_sbyModem=0) then FinalAction;
    //FinalAction;
End;
procedure CSS301F3Meter.OnFinalAction;
Begin
//    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>SS301 OnFinalAction');
    FinalAction;
End;
procedure CSS301F3Meter.OnConnectComplette(var pMsg:CMessage);
Begin
//    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>SS301 OnConnectComplette');
    m_nModemState := 1;
    FinalAction;
End;
procedure CSS301F3Meter.OnDisconnectComplette(var pMsg:CMessage);
Begin
//    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>SS301 OnDisconnectComplette');
    m_nModemState := 0;
End;
procedure CSS301F3Meter.OnFinHandQryRoutine(var pMsg:CMessage);
begin
    if m_nP.m_sbyEnable=1 then
    Begin
//     OnFinalAction;
//     TraceM(2,pMsg.m_swObjID,'(__)CL2MD::>SS301OnFinHandQryRoutine  DRQ:',@pMsg);
     IsUpdate := 0;
     m_nCounter := 0;
     m_nCounter1:= 0;
    End;
end;
procedure CSS301F3Meter.ReadPhaseJrnl(var pMsg:CHMessage);
var Mask : WORD;
    Date : TDateTime;
    XorLM: WORD;
    byType : Byte;
begin
   byType := pMsg.m_sbyInfo[1];
   if (pMsg.m_sbyInfo[2] = 0) or (pMsg.m_sbyInfo[3] = 0) or (pMsg.m_sbyInfo[4] = 0) then
     exit;  //�������� ����
   Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
           EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   Mask := pMsg.m_sbyInfo[9]  + pMsg.m_sbyInfo[10] shl 8;
   if pMsg.m_sbyInfo[11] <> 0 then
   begin
     LastMask := Mask;
     exit;
   end;
   XorLM := LastMask xor Mask;
   if (XorLM and $01) = $01 then
     if (Mask and $01) <> 0 then
       SendL3Event(byType,2, EVM_INCL_PH_A, m_nP.m_swMID, 0, Date)
     else
       SendL3Event(byType,2, EVM_EXCL_PH_A, m_nP.m_swMID, 0, Date);
   if (XorLM and $02) = $02 then
     if (Mask and $02) <> 0 then
       SendL3Event(byType,2, EVM_INCL_PH_B, m_nP.m_swMID, 0, Date)
     else
       SendL3Event(byType,2, EVM_EXCL_PH_B, m_nP.m_swMID, 0, Date);
   if (XorLM and $04) = $04 then
     if (Mask and $04) <> 0 then
       SendL3Event(byType,2, EVM_INCL_PH_C, m_nP.m_swMID, 0, Date)
     else
       SendL3Event(byType,2, EVM_EXCL_PH_C, m_nP.m_swMID, 0, Date);
   LastMask := Mask;
   {if ((Mask and $0001) = 1) or ((Mask and $0002) = 2)
      or ((Mask and $0004) = 4) then Mask := 1;
     SendL3Event(byType,2, 18 - Mask, m_nP.m_swMID, Date);}
end;

procedure CSS301F3Meter.ReadStateJrnl(var pMsg:CHMessage);
var Mask : WORD;
    Date : TDateTime;
    byType : Byte;
begin
   byType := pMsg.m_sbyInfo[1];
   if (pMsg.m_sbyInfo[2] = 0) or (pMsg.m_sbyInfo[3] = 0) or (pMsg.m_sbyInfo[4] = 0) then
     exit;  //�������� ����
   Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
           EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   Mask := pMsg.m_sbyInfo[9]  + pMsg.m_sbyInfo[10] shl 8;
   if pMsg.m_sbyInfo[8] <> 0 then
   begin
     if (Mask and $0002) = $0002 then
       SendL3Event(byType,2, EVM_ERR_REAL_CLOCK, m_nP.m_swMID, 0, Date);
     if (Mask and $0008) = $0008 then
       SendL3Event(byType,2, EVM_ERR_KAL, m_nP.m_swMID, 0, Date);
     if (Mask and $0010) = $0010 then
       SendL3Event(byType,2, EVM_NOIZE, m_nP.m_swMID, 0, Date);
     if ((Mask and $0100) = $0100) or ((Mask and $0200) = $0200) then
       SendL3Event(byType,2, EVM_ERR_DSP, m_nP.m_swMID, 0, Date);
     if ((Mask and $0800) = $0800) or ((Mask and $1000) = $1000) then
       SendL3Event(byType,2, EVM_ERR_RAM, m_nP.m_swMID, 0, Date);
     if ((Mask and $4000) = $4000) or ((Mask and $8000) = $8000) then
       SendL3Event(byType,2, EVM_ERR_RAM, m_nP.m_swMID, 0, Date);
   end
   else
   begin
     if (Mask and $0100) = $0100 then
       SendL3Event(byType,0, 10, 0, 0, Date);
     if (Mask and $0200) = $0200 then
       SendL3Event(byType,0, 11, 0, 0, Date);
     if (Mask and $0400) = $0400 then
       SendL3Event(byType,0, 1, 0, 0, Date);
     if (Mask and $0800) = $0800 then
       SendL3Event(byType,0, 23, 0, 0, Date);
     if (Mask and $1000) = $1000 then
       SendL3Event(byType,0, 24, 0, 0, Date);
     if (Mask and $2000) = $2000 then
       SendL3Event(byType,0, 93, 0, 0, Date);
     if (Mask and $4000) = $4000 then
       SendL3Event(byType,0, 94, 0, 0, Date);
     if (Mask and $8000) = $8000 then
       SendL3Event(byType,0, 7, 0, 0, Date);
   end;
end;

procedure CSS301F3Meter.ReadKorrJrnl(var pMsg:CHMessage);
var Mask    : WORD;
    Date    : TDateTime;
    yto     : byte;
    f_Temp  : Double;
    pDS     : CMessageData;
    byType : Byte;
begin
   byType := pMsg.m_sbyInfo[1];
   if (pMsg.m_sbyInfo[2] = 0) or (pMsg.m_sbyInfo[3] = 0) or (pMsg.m_sbyInfo[4] = 0) then
     exit;  //�������� ����
   Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
           EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   Mask := pMsg.m_sbyInfo[9]  + pMsg.m_sbyInfo[10] shl 8;
   yto  := pMsg.m_sbyInfo[11];
   if (Mask and $0001) = $0001 then
     SendL3Event(byType,2, EVM_OPN_COVER, m_nP.m_swMID, 0, Date);
   if (Mask and $0002) = $0002 then
     SendL3Event(byType,2, EVM_CLS_COVER, m_nP.m_swMID, 0, Date);
   if (Mask and $0004) = $0004 then
     SendL3Event(byType,2, EVM_CORR_BUTN, m_nP.m_swMID, 0, Date);
   if (Mask and $0008) = $0008 then
     SendL3Event(byType,2, EVM_CORR_INTER, m_nP.m_swMID, 0, Date);
   if (Mask = $4000) and (yto = 10) then
   begin
     move(pMsg.m_sbyInfo[12], f_temp, sizeof(Double));
     SendL3Event(byType,2, EVM_START_CORR, m_nP.m_swMID, f_temp, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 11) then
   begin
     move(pMsg.m_sbyInfo[12], f_temp, sizeof(Double));
     SendL3Event(byType,2, EVM_FINISH_CORR, m_nP.m_swMID, f_temp, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 12) then
   begin
     SendL3Event(byType,2, EVM_ERROR_CORR, m_nP.m_swMID, 0, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 13) then
   begin
     SendL3Event(byType,1, EVA_METER_NO_ANSWER, m_nP.m_swMID, 0, Date);
     if m_nLockMeter=1 then
     Begin
      //SetLockState;
      //pDS.m_swData0 := PR_FAIL;
      //SendMsgData(BOX_L3,m_nP.m_swMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
     exit;
   end;
   if (Mask = $4000) and (yto = 14) then
   begin
     SendL3Event(byType,1, EVA_METER_ANSWER, m_nP.m_swMID, 0, Date);
     if m_nLockMeter=1 then
     Begin
      //ReSetLockState;
      //pDS.m_swData0 := PR_TRUE;
      //SendMsgData(BOX_L3,m_nP.m_swMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
     exit;
   end;
   if (Mask and $0010) = $0010 then
     SendL3Event(byType,2, EVM_CHG_TARIFF, m_nP.m_swMID, 0, Date);
   if (Mask and $0020) = $0020 then
     SendL3Event(byType,2, EVM_CHG_FREEDAY, m_nP.m_swMID, 0, Date);
   if (Mask and $0040) = $0040 then
     SendL3Event(byType,2, EVM_CHG_CONST, m_nP.m_swMID, 0, Date);
   if (Mask and $0080) = $0080 then
     if (yto and $20) = $20 then
       SendL3Event(byType,2, EVM_CHG_SPEED, m_nP.m_swMID, 0, Date)
     else
       SendL3Event(byType,2, EVM_CHG_CONST, m_nP.m_swMID, 0, Date);
   if (Mask and $0100) = $0100 then
     SendL3Event(byType,2, EVM_CHG_PAR_TELEM, m_nP.m_swMID, 0, Date);
   if (Mask and $0200) = $0200 then
     SendL3Event(byType,2, EVM_CHG_MODE_IZM,  m_nP.m_swMID, 0, Date);
   if (Mask and $0400) = $0400 then
     SendL3Event(byType,2, EVM_CHG_PASSW, m_nP.m_swMID, 0, Date);
   if (Mask and $0800) = $0800 then
     SendL3Event(byType,2, EVM_RES_ENERG, m_nP.m_swMID, 0, Date);
   if (Mask and $1000) = $1000 then
     SendL3Event(byType,2, EVM_RES_MAX_POW, m_nP.m_swMID, 0, Date);
   if (Mask and $2000) = $2000 then
     SendL3Event(byType,2, EVM_RES_SLICE, m_nP.m_swMID, 0, Date);
end;

function CSS301F3Meter.GetCommand(byCommand:Byte):Integer;
Var
    res : Integer;
Begin
    case byCommand of
     QRY_NULL_COMM      :   res:=0;// = 0
     QRY_ENERGY_SUM_EP  :   res:=1;//= 1;//1
     QRY_ENERGY_SUM_EM  :   res:=1;//= 2;
     QRY_ENERGY_SUM_RP  :   res:=1;//= 3;
     QRY_ENERGY_SUM_RM  :   res:=1;//= 4;
     QRY_ENERGY_DAY_EP  :   res:=2;//= 5;//2
     QRY_ENERGY_DAY_EM  :   res:=2;//= 6;
     QRY_ENERGY_DAY_RP  :   res:=2;//= 7;
     QRY_ENERGY_DAY_RM  :   res:=2;//= 8;
     QRY_ENERGY_MON_EP  :   res:=3;//= 9;//3
     QRY_ENERGY_MON_EM  :   res:=3;//= 10;
     QRY_ENERGY_MON_RP  :   res:=3;//= 11;
     QRY_ENERGY_MON_RM  :   res:=3;//= 12;
     QRY_SRES_ENR_EP    :   if m_nP.m_sbyTSlice = 0 then res:=36 else res:=40;//= 13;//36
     QRY_SRES_ENR_EM    :   if m_nP.m_sbyTSlice = 0 then res:=36 else res:=40;//= 14;
     QRY_SRES_ENR_RP    :   if m_nP.m_sbyTSlice = 0 then res:=36 else res:=40;//= 15;
     QRY_SRES_ENR_RM    :   if m_nP.m_sbyTSlice = 0 then res:=36 else res:=40;//= 16;
     QRY_NAK_EN_DAY_EP  :   res:=42;//= 17;//42
     QRY_NAK_EN_DAY_EM  :   res:=42;//= 18;
     QRY_NAK_EN_DAY_RP  :   res:=42;//= 19;
     QRY_NAK_EN_DAY_RM  :   res:=42;//= 20;
     QRY_NAK_EN_MONTH_EP:   res:=43;//= 21;//43
     QRY_NAK_EN_MONTH_EM:   res:=43;//= 22;
     QRY_NAK_EN_MONTH_RP:   res:=43;//= 23;
     QRY_NAK_EN_MONTH_RM:   res:=43;//= 24;
     //QRY_NAK_EN_YEAR_EP    res:=0;//= 25;
     //QRY_NAK_EN_YEAR_EM    res:=0;//= 26;
     //QRY_NAK_EN_YEAR_RP    res:=0;//= 27;
     //QRY_NAK_EN_YEAR_RM    res:=0;//= 28;
     QRY_E3MIN_POW_EP   :   res:=5;//= 29;//5
     QRY_E3MIN_POW_EM   :   res:=5;//= 30;
     QRY_E3MIN_POW_RP   :   res:=5;//= 31;
     QRY_E3MIN_POW_RM   :   res:=5;//= 32;
     QRY_E30MIN_POW_EP  :   res:=6;//= 33;//6
     QRY_E30MIN_POW_EM  :   res:=6;//= 34;
     QRY_E30MIN_POW_RP  :   res:=6;//= 35;
     QRY_E30MIN_POW_RM  :   res:=6;//= 36;
     QRY_MGAKT_POW_S    :   res:=8;//= 37;//8
     QRY_MGAKT_POW_A    :   res:=8;//= 38;
     QRY_MGAKT_POW_B    :   res:=8;//= 39;
     QRY_MGAKT_POW_C    :   res:=8;//= 40;
     QRY_MGREA_POW_S    :   res:=9;//= 41;//9
     QRY_MGREA_POW_A    :   res:=9;//= 42;
     QRY_MGREA_POW_B    :   res:=9;//= 43;
     QRY_MGREA_POW_C    :   res:=9;//= 44;
     QRY_U_PARAM_A      :   res:=10;//= 45;//10
     QRY_U_PARAM_B      :   res:=10;//= 46;
     QRY_U_PARAM_C      :   res:=10;//= 47;
     QRY_I_PARAM_A      :   res:=11;//= 48;//11
     QRY_I_PARAM_B      :   res:=11;//= 49;
     QRY_I_PARAM_C      :   res:=11;//= 50;
     QRY_FREQ_NET       :   res:=13;//= 54;//13
     QRY_KOEF_POW_A     :   res:=12;//= 51;//12
     QRY_KOEF_POW_B     :   res:=12;//= 52;
     QRY_KOEF_POW_C     :   res:=12;//= 53;
     QRY_KPRTEL_KPR     :   res:=24;//= 55;//24
     QRY_KPRTEL_KE      :   res:=24;//= 55;//24
     //QRY_KPRTEL_R          res:=0;//= 56;
     QRY_DATA_TIME      :   res:=32;//= 57;//
     QRY_MAX_POWER_EP   :   res:=7;
     QRY_JRNL_T1        :   res:=14;
     QRY_JRNL_T2        :   res:=15;
     QRY_JRNL_T3        :   res:=16;
     QRY_SUM_KORR_MONTH :   res:=45;
     else
     res:=-1;
    End;
    Result := res;
End;
function CSS301F3Meter.CRC(var buf : array of byte; cnt : byte):boolean;
var
    CRChiEl             : byte;
    CRCloEl             : byte;
    i                   : byte;
    cmp                 : byte;
    idx                 : byte;
begin
    Result  := true;
    CRChiEl := $FF;
    CRCloEl := $FF;
    cmp     := cnt-1;
    if cnt >= 300 then
    begin
       Result := false;
       exit;
    end;
    for i:=0 to cmp do
    begin
     idx       := (CRChiEl Xor buf[i]) And $FF;
     CRChiEl   := (CRCloEl Xor CRCHI[idx]);
     CRCloEl   := CRCLO[idx];
    end;
    if (CRCloEl <> buf[cnt]) and (CRChiEl <> buf[cnt+1]) then
      Result := false;
    buf[cnt]    := CRCloEl;
    buf[cnt+1]  := CRChiEl;
end;
procedure CSS301F3Meter.RunMeter;
Begin
    //m_nRepTimer.RunTimer;
    //m_nObserver.Run;
    {$IFDEF SS301_DEBUG}

    {$ENDIF}
End;

function CSS301F3Meter.GetStringFromFile(FileName : string; nStr : integer) : string;
var f :TStringList;
begin
   f := TStringList.Create();
   f.LoadFromFile(FileName);
   Result := f.Strings[nStr];
   f.Free;
end;

procedure CSS301F3Meter.EncodeStrToBufArr(var str : string; var buf : array of byte; var nCount : integer);
var i       : integer;
    ts      : string;
begin
   ts      := '';
   nCount  := 0;
   for i := 1 to Length(str) do
     if str[i] <> ' ' then
     begin
       if ts = '' then ts := '$';
       ts := ts + str[i];
     end
     else
     begin
       if ts <> '' then
       begin
         buf[nCount] := StrToInt(ts);
         Inc(nCount);
         ts := '';
       end;
       continue;
     end;
   if str <> '' then
   begin
     buf[nCount] := StrToInt(ts);
     Inc(nCount);
   end;
end;
end.
