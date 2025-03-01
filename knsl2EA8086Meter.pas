unit knsl2EA8086Meter;
//{$DEFINE EA8086_DEBUG}
interface

uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,knsl2meter,utlmtimer,knsl3observemodule,utlTimeDate,utldatabase,knsl3EventBox;

type
    buf = array of byte;
    Arr = array[0..4] of Double;
    CEA8086Meter = class(CMeter)
    Private
     tempBufRead  : array of byte;
     tempDateRead : TDateTime;
     m_nCounter   : Integer;
     m_nCounter1  : Integer;
     //IsUpdate     : boolean; 
     mCurrState   : Integer;
     nReq         : CQueryPrimitive;
     //Ke           : word;
     Ke           : double;
     dt_TLD       : TDateTime;
     EA8086Struct : SL2EA8086STRUCT;
     lastMonth    : Integer;
     pTable       : SL3ABONS;
     tarif        : Integer;
     itemPacket   : Integer; // id ������ � �������� SL2EA8086STRUCT_RXPacket ��� ��������
     EA8086_RXPacket : SL2EA8086STRUCT_RXPacket;//��������� ��� ������������ ������� ��� ��������
     adres_chtenia: Integer;//����� ������ ��������� (� ����� ������ ���������� ��������� �������)
     ChannelID    : Integer; // ����������� ������ ������
     pTableMeter  : SL2INITITAG; // ������� ��������� �� ������� ������
     pTableChannel: SL2INITITAG; // ������� ���� ��������� ������� � ���������� ��������� � ���
     pTableChannelTariffs: SL2INITITAG; // ������� ���� ��������� ��������� i-��� ������ �� ������� ������
     tempValSum   : double; //����������� �����
     procedure   SetCurrQry;
     procedure   SetGraphQry;
     procedure   RunMeter;override;
     procedure   InitEA8086Struct;
     procedure   InitABON;
     procedure   InitMeter(var pL2:SL2TAG);override;
     function    CalculateCS(var mas : array of byte; len : integer):byte;
     procedure   EncodeStrToBCD(var mas:array of byte; var str:string);
     procedure   EncodeNoStrToBCD(var mas:array of byte; str:string);
     procedure   EncodeIntToBCD(var mas:array of byte; str:string);
     function    ByteToBCD(intNumb:byte):byte;
     function    BCDToByte(hexNumb:byte):byte;
     function    ArrayBCDToDouble(var mas:array of byte; size : byte):Double;
     procedure   MsgHead(var pMsg:CHMessage; Size:byte);
     function    CheckControlField(sm: integer): boolean;
     function    FindSmFromAdr(tAdr, tSpecc0: integer): integer;
     function    FindSmInMSG(case_of:integer):integer;
     procedure   ReadNakEnMonth(sm: integer);
     function    GET_ReadEnSum(sm: integer; var Val:Double):Boolean;
     function    GET_ReadEnSumTekMonth(sm: integer; var Val:Double):Boolean;

     procedure   ReadNakEnMonthNow(sm: integer);
     procedure   ReadSresEn(sm: integer);
     procedure   ReadEnSum(sm: integer);
     procedure   ReadAktPow(sm: integer);
     function    ReadReqToParamEA8086(nLen : Integer):integer;
     function    NakMonthMeter:boolean;
     function    ReadParamFromTempBuf(nLen : Integer):Integer;

     procedure   CreateReqParamTimeEA8086();
     function    CreateReqParamRaziem(countRaz,counKvar :integer):buf;
     function    MsgHeadParam(read: Boolean; nomConc,passwConcOld,passwConcNew: string; addr: Pchar): buf;
     function    CRC(mass: array of byte; nach: integer; konec: integer):byte;  //������� �������� ����������� �����
     function    NumStringToBCD(const inStr: PChar): buf;  //������� �������������� ������ � BCD ������
     function    BufNazvanieRaz(nazvanie: string;       //������� ������������ ������ �������� �������
                        countSch: string): buf;//16 ���� �������� �����

     function   CreateReqParamSchetchik(countRaz,counKvar:integer;var adres_read:integer): buf; //������� ������������ ������ ���������
     procedure  SendMessageParametrization(itemPacket:integer);
     procedure  SendMessageEndChannel(addr:integer);

     procedure   CreateReqToParam1_EA8086(tarifs,channel:byte);
     procedure   CreateReqToParam2_EA8086(tarifs:byte);
     procedure   CreateReqToParamEnd1_EA8086();
     procedure   CreateReqToParamEnd2_EA8086();
     procedure   CreateReqToEA8086();
     procedure   SendByteToEA8086();
     function    SelfHandler(var pMsg:CMessage):Boolean;override;
     procedure   TestMSG(var pMSG:CMessage);
     function    LoHandler(var pMsg:CMessage):Boolean;override;
     function    HiHandler(var pMsg:CMessage):Boolean;override;
     procedure   AddEnergyMonthGrpahQry(Date1, Date2:TDateTime);
     procedure   AddNakEnergyMonthGraphQry(Date1, Date2: TDateTime);
     procedure   AddSresEnDayGraphQry(Date1, Date2: TDateTime);
     constructor Create;
     destructor  Destroy;override;
     procedure   SendMessageToMeter;
     procedure   HandQryRoutine(var pMsg:CMessage);
     procedure   MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
     procedure   CreateOutMSG(param : double; sm : byte; tar : byte; Date : TDateTime);
     procedure   OnFinHandQryRoutine(var pMsg:CMessage);
     procedure   OnEnterAction;
     procedure   OnFinalAction;
     procedure   OnConnectComplette(var pMsg:CMessage);override;
     function    SetCommand(swParamID:Word;swSpecc0,swSpecc1,swSpecc2:Smallint;byEnable:Byte):Boolean;override;
     procedure   OnDisconnectComplette(var pMsg:CMessage);override;
     function    CalcKS(var buf : array of byte; len : integer) : byte;
     procedure   EncodeStrToBufArr(var str : string; var buf : array of byte; var nCount : integer);
     function    GetStringFromFile(FileName : string; nStr : integer) : string;
     //procedure   SetGraphParam(dt_Date1, dt_Date2:TDateTime; param : word);override;
    End;

const
//**************������ ��������*********************
  AdresRaz: array [1..16] of PChar = ('0000', //������ 1
                                      '00C0', //������ 2
                                      '0180', //������ 3
                                      '0240', //������ 4
                                      '0300', //������ 5
                                      '03C0', //������ 6
                                      '0480', //������ 7
                                      '0540', //������ 8
                                      '0600', //������ 9
                                      '06C0', //������ 10
                                      '0780', //������ 11
                                      '0840', //������ 12
                                      '0900', //������ 13
                                      '09C0', //������ 14
                                      '0A80', //������ 15
                                      '0B40'); //������ 16

  //**********������ ������ ��������� �����������
  AdresChteniaVarTar: array [1..10] of integer =
                                     ($2000, //������� ����������� 1
                                      $2100, //������� ����������� 2
                                      $2200, //������� ����������� 3
                                      $2300, //������� ����������� 4
                                      $2400, //������� ����������� 5
                                      $2500, //������� ����������� 6
                                      $2600, //������� ����������� 7
                                      $2700, //������� ����������� 8
                                      $2800, //������� ����������� 9
                                      $2900); //������� ����������� 10

  RusKod: array[0..255] of byte = (0,1,2,3,4,5,6,7,8,9,10,11,12,
  13,14,15,
  16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
  48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,
  64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,
  80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,
  96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,
  112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
  128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
  144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
  160,161,162,163,164,165,166,167,$A2,169,170,171,172,173,174,175,
  176,177,178,179,180,181,182,183,$B5,185,186,187,188,189,190,191,
  $41,$A0,$42,$A1,$E0,$45,$A3,$A4,$A5,$A6,$4B,$A7,$4D,$48,$4F,$A8,  
  $50,$43,$54,$A9,$AA,$58,$E1,$AB,$AC,$E2,$AD,$AE,$62,$AF,$B0,$B1,
  $61,$B2,$B3,$B4,$E3,$65,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$6F,$BE,
  $70,$63,$BF,$79,$E4,$78,$E5,$C0,$C1,$E6,$C2,$C3,$c4,$C5,$C6,$C7);
 var   buftarif    :array[0..9]of byte=(0,0,0,0,0,0,0,0,0,0);
implementation

constructor CEA8086Meter.Create;
Begin

End;
destructor CEA8086Meter.Destroy;
Begin
   inherited;
   SetLength(tempBufRead, 0);
End;
function CEA8086Meter.SetCommand(swParamID:Word;swSpecc0,swSpecc1,swSpecc2:Smallint;byEnable:Byte):Boolean;
var
    YearN, MonthN, DayN : word;
Begin
    if(swParamID=QRY_NAK_EN_MONTH_EP) then
    Begin
     DecodeDate(Now, YearN, MonthN, DayN);
     m_nObserver.AddCurrParam(swParamID,MonthN,swSpecc1+1,swSpecc2,byEnable);
    End else
    m_nObserver.AddCurrParam(swParamID,swSpecc0,swSpecc1,swSpecc2,byEnable);
    Result := False;
end;

procedure CEA8086Meter.AddEnergyMonthGrpahQry(Date1, Date2:TDateTime);
//var Year, Month, Day : word;
//    i                : integer;
//    TempDate         : TDateTime;
begin
   {if (CDateTimeR.CompareMonth(Date2, Now) = 1) then
     Date2 := Now;
   if (CDateTimeR.CompareMonth(Date2, Now) = 0) then
     CDateTimeR.DecMonth(Date2);
   while CDateTimeR.CompareMonth(Date1, Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while CDateTimeR.CompareMonth(Date2, TempDate) <> 1 do
     begin
       CDateTimeR.DecMonth(TempDate);
       Inc(i);
       if i > 12 then
         exit;
     end;
     DecodeDate(Date2, Year, Month, Day);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, Month, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, Month, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, Month, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_ENERGY_MON_EP, Month, 4, 0, 1);
     CDateTimeR.DecMonth(Date2);
   end;    }
end;

procedure CEA8086Meter.AddNakEnergyMonthGraphQry(Date1, Date2: TDateTime);
var Year, Month, Day : word;
//    i                : integer;
//    TempDate         : TDateTime;
begin
   {if (CDateTimeR.CompareMonth(Date2, Now) = 1) then
     Date2 := Now;
   if (CDateTimeR.CompareMonth(Date2, Now) = 0) then
     CDateTimeR.DecMonth(Date2);
   while CDateTimeR.CompareMonth(Date1, Date2) <> 1 do
   begin
     i        := 0;
     TempDate := Now;
     while CDateTimeR.CompareMonth(Date2, TempDate) <> 1 do
     begin
       CDateTimeR.DecMonth(TempDate);
       Inc(i);
       if i > 12 then
         exit;
     end;
     DecodeDate(Date2, Year, Month, Day);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 4, 0, 1);
     CDateTimeR.DecMonth(Date2);
   end;         }
   while (Date1 <= Date2) and (Date1 <= Now) do
   begin
     DecodeDate(Date1, Year, Month, Day);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 1, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 2, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 3, 0, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP, Month, 4, 0, 1);
     cDateTimeR.IncMonth(Date1);
   end;
end;

procedure CEA8086Meter.AddSresEnDayGraphQry(Date1, Date2: TDateTime);
var i : integer;
begin
   for i := trunc(Date1) to trunc(Date2) do
     m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, abs(trunc(Now) - i), 0, 0, 1);
end;

procedure CEA8086Meter.InitEA8086Struct;
var i, j  : integer;
    ts    : string;
begin
   EA8086Struct.m_sKoncFubNum := '';
   EA8086Struct.m_sKoncPassw  := '';
   EA8086Struct.m_sAdrToRead  := '';
   EA8086Struct.m_sRazNumb    := '';
   EA8086Struct.m_sTarVar     := '';
   j  := 0;
   ts := '';
   for i := 1 to Length(m_nP.m_sAdvDiscL2Tag) do
   begin
     if m_nP.m_sAdvDiscL2Tag[i] = ';' then
     begin
       case j of
         0 : begin EA8086Struct.m_sKoncFubNum := ts; j := j + 1;  end;
         1 : begin EA8086Struct.m_sKoncPassw  := ts; j := j + 1; end;
         2 : begin EA8086Struct.m_sAdrToRead  := ts; j := j + 1; end;
         3 : begin EA8086Struct.m_sRazNumb    := ts; j := j + 1; end;
         4 : begin EA8086Struct.m_sTarVar     := ts; j := j + 1; end;
       end;
       ts := '';
       continue;
     end;
     ts := ts + m_nP.m_sAdvDiscL2Tag[i];
   end;
end;

procedure CEA8086Meter.InitABON;
var i:integer;
begin
    ChannelID  := 1; //������������� ��������������� ������
    itemPacket := 0; //������������� ��������������� ������ ���������
    EA8086_RXPacket.Count:=0;  //������������� ���-�� ������� ��� ������� ���������
    SetLength(EA8086_RXPacket.Items,6);
    for i:=0 to 5 do
    SetLength(EA8086_RXPacket.Items[i].Packet,1); // �������������� ��� ������ ������������ ������� 1 � ��������� 0
    m_pDB.GetAbonTable(m_nP.M_SWABOID,pTable);
end;

procedure CEA8086Meter.InitMeter(var pL2:SL2TAG);
Begin
    tempValSum := 0;
    tarif      := 0;
    mCurrState := 0;
    m_nCounter := 0;
    m_nCounter1:= 0;
    IsUpdate   := 0;
    SetHandScenario;
    SetHandScenarioGraph;
    tempDateRead := 0;
    InitEA8086Struct;
End;

procedure CEA8086Meter.MsgHead(var pMsg:CHMessage; Size:byte);
begin
    pMsg.m_swLen       := Size;             //pMsg.m_sbyInfo[] :=
    pMsg.m_swObjID     := m_nP.m_swMID;     //������� ����� ��������
    pMsg.m_sbyFrom     := DIR_L2TOL1;
    pMsg.m_sbyFor      := DIR_L2TOL1;       //DIR_L2toL1
    pMsg.m_sbyType     := PH_DATARD_REQ;    //PH_DATARD_REC
    pMsg.m_sbyIntID    := m_nP.m_sbyPortID;
    pMsg.m_sbyServerID := MET_EA8086;       //������� ��� ��������
    pMsg.m_sbyDirID    := m_nP.m_sbyPortID;
end;

procedure CEA8086Meter.MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
begin
    pMsg.m_swLen       := Size;
    pMsg.m_swObjID     := m_nP.m_swMID;       //������� ����� ��������
    pMsg.m_sbyFrom     := DIR_L2TOL3;
    pMsg.m_sbyFor      := DIR_L2TOL3;         //DIR_L2toL1
    pMsg.m_sbyType     := PH_EVENTS_INT;      //PH_DATARD_REC
    //pMsg.m_sbyTypeIntID:= DEV_COM;          //DEF_COM
    pMsg.m_sbyIntID    := m_nP.m_sbyPortID;
    pMsg.m_sbyServerID := MET_EA8086;         //������� ��� ��������
    pMsg.m_sbyDirID    := m_nP.m_sbyPortID;
end;

procedure CEA8086Meter.CreateOutMSG(param : double; sm : byte; tar : byte; Date : TDateTime);
var Year, Month, Day,
    Hour, Min, Sec, ms : word;
begin                         //sm - ��� �������; tar - ������
   DecodeDate(Date, Year, Month, Day);
   DecodeTime(Date, Hour, Min, Sec, ms);
   m_nRxMsg.m_sbyType    := DL_DATARD_IND;
   m_nRxMsg.m_sbyFor     := DIR_L2TOL3;
   m_nRxMsg.m_swObjID    := m_nP.m_swMID;
   m_nRxMsg.m_swLen      := 13 + 9 + sizeof(double);
   m_nRxMsg.m_sbyInfo[0] := 9 + sizeof(double);
   m_nRxMsg.m_sbyInfo[1] := sm;
   m_nRxMsg.m_sbyInfo[2] := Year - 2000;
   m_nRxMsg.m_sbyInfo[3] := Month;
   m_nRxMsg.m_sbyInfo[4] := Day;
   m_nRxMsg.m_sbyInfo[5] := Hour;
   m_nRxMsg.m_sbyInfo[6] := Min;
   m_nRxMsg.m_sbyInfo[7] := Sec;
   m_nRxMsg.m_sbyInfo[8] := tar;
   move(param, m_nRxMsg.m_sbyInfo[9], sizeof(double));
   m_nRxMsg.m_sbyDirID   := Byte(IsUpdate);
end;

procedure CEA8086Meter.SetCurrQry;
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

procedure CEA8086Meter.SetGraphQry;
begin

end;

function  CEA8086Meter.CalculateCS(var mas : array of byte; len : integer):byte;
var i     : integer;
    //res   : longword;
    res   : integer;
begin //����������� ����������� �����
   res    := 0;
//   Result := res;
   for i := 0 to len-1 do
     res := res + mas[i];
   Result := res;
end;

procedure CEA8086Meter.EncodeStrToBCD(var mas:array of byte; var str:string);
var rez : int64;
      i : byte;
begin //�������������� ������ � BCD
    rez   := 0;
    for i := 1 to 6 do
    begin
      if (i > Length(str)) then
        break; 
      rez := rez * $10;
      rez := rez + StrToInt(str[i]);
    end;
    move(rez, mas, 3);
end;

procedure CEA8086Meter.EncodeIntToBCD(var mas:array of byte; str:string);
var rez : int64;
      i : byte;
begin //�������������� ������ � BCD
    rez   := 0;
    for i := 1 to 6 do
    begin
      rez := rez * $10;
      rez := rez + StrToInt(str[i]);
    end;
    move(rez, mas, 3);
end;

function  CEA8086Meter.ByteToBCD(intNumb:byte):byte;
begin //�������������� ����� � BCD ������
    Result := ((intNumb div 10) shl 4) + (intNumb mod 10);
end;

function  CEA8086Meter.BCDToByte(hexNumb:byte):byte;
begin //�������������� BCD � ����
    Result := (hexNumb shr 4)*10 + (hexNumb and $0F);
end;

function CEA8086Meter.ArrayBCDToDouble(var mas:array of byte; size : byte):Double;
var i:byte;
begin  //�������������� �� BCD � single
   Result := 0;
   try
   for i:=size-1 downto 0 do
   begin
     Result := Result*100;
     Result := Result + BCDToByte(mas[i]);
   end;
   Result := Result / 100;
   except

   end;
end;

function  CEA8086Meter.CheckControlField(sm: integer): boolean;
var tempCS : integer;
begin
   tempCS := CalculateCS(tempBufRead[sm], 17);
   if (tempBufRead[sm + 17] = tempCS) then
     Result := true
   else
     Result := false;
end;

function  CEA8086Meter.FindSmFromAdr(tAdr, tSpecc0: integer): integer;
var //tempAdrMeter : int64;
    tBufAdr      : array [0..3] of byte;
    i            : integer;
    addrRead : word;
    addrPar : word;
    b0,b1,b2 : byte;
begin
   Result := -1;
   //tempAdrMeter := StrToInt(m_nP.m_sddFabNum);
  { if (Length(tempBufRead)>700) then
   Begin
    exit;
   End;}
   //EncodeIntToBCD(tBufAdr, m_nP.m_sddFabNum);
   tBufAdr[0] := tempBufRead[0];
   tBufAdr[1] := tempBufRead[1];
   tBufAdr[2] := tempBufRead[2];
   tBufAdr[3] := tBufAdr[0] + tBufAdr[1] + tBufAdr[2];
   for i := 0 to Length(tempBufRead) - 17 do
   Begin

     if (tBufAdr[0] = tempBufRead[i]) and
        (tBufAdr[1] = tempBufRead[i + 1]) and
        (tBufAdr[2] = tempBufRead[i + 2]) and
        (tBufAdr[3] = tempBufRead[i + 3]) then
        Begin
         b0 := BCDToByte(tempBufRead[i]);
         b1 := BCDToByte(tempBufRead[i+1]);
         b2 := BCDToByte(tempBufRead[i+2]);
         {TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CEA8086 FindSmFromAdr_0:'+
                          IntToStr(b0)+IntToStr(b1)+IntToStr(b2)+
                          ' addr:'+IntToHex(tempBufRead[i + 14] + tempBufRead[i + 15]*$100,4));}
       if (tempBufRead[i + 12] = 0) and (tAdr = tempBufRead[i + 14] + tempBufRead[i + 15]*$100) then
       Begin
//       TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CEA8086 FindSmFromAdr_1:'+
//                          IntToStr(b2)+IntToStr(b1)+IntToStr(b0)+
//                          ' addr:'+IntToHex(tempBufRead[i + 14] + tempBufRead[i + 15]*$100,4));
         if   (CheckControlField(i)) then
         Begin
           if (tSpecc0 = -1) then
           begin
             Result := i + 18;
             break;
           end else
           if (tSpecc0 = tempBufRead[i + 16]) then
           begin
             Result := i + 18;
             break;
           end;
         end else begin
                  //         TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CEA8086 CRC Error!!!');
                  End;

       End;

       End;
   End;
end;

function  CEA8086Meter.FindSmInMSG(case_of:integer):integer;
var tempAdr          : integer;
    nSpecc0          : integer;
    Year, Month, Day : word;
begin
   tempAdr := -1;
   nSpecc0 := -1;
   case case_of of
      QRY_NAK_EN_MONTH_EP :
      begin
          tempAdr := $0600 + (nReq.m_swSpecc1 - 1)*$41
      end;
      QRY_SRES_ENR_EP     :
        begin
          tempAdr := $8000;
          nSpecc0 := nReq.m_swSpecc0
        end;
      QRY_ENERGY_SUM_EP   : tempAdr := $05A0;
      QRY_MGAKT_POW_S     : tempAdr := $05F0;
   end;
   if tempAdr = -1 then
     Result := -1
   else
     Result := FindSmFromAdr(tempAdr, nSpecc0)
end;
    {
procedure CEA8086Meter.ReadNakEnMonth(sm: integer);
var i,step,k,smTek              : integer;
    tempVal              : double;
    YearN, MonthN, DayN  : word;
    tempDate             : TDateTime;
    tempSpecc0,tSpecc0   : integer;
begin
   {if nReq.m_swSpecc1 = 0 then
     Exit;
   tempSpecc0 := nReq.m_swSpecc0;
   tempSpecc0 := tempSpecc0 - 1;
   if (tempSpecc0 < 1) then
     tempSpecc0 := 12;
   DecodeDate(Now, YearN, MonthN, DayN);
   if MonthN < nReq.m_swSpecc0 then
     YearN := YearN - 1;}
  // tempVal := 0;
   //if (sm<>-1) then
{
   DecodeDate(Now, YearN, MonthN, DayN);
   tSpecc0:=MonthN;
   step:=0;k:=11;
   for i:=0 to 2 do
   begin
     if i=0 then
       tempVal := ArrayBCDToDouble(tempBufRead[sm + i*5], 4)
     else
        begin
        tempVal := ArrayBCDToDouble(tempBufRead[sm + k*5], 4);
        k:=k-1;
        end;

   {  tSpecc0:=tSpecc0-i;
     tSpecc0:=tSpecc0-step;
     MonthN:= tSpecc0;
     if tSpecc0 <= 0 then
        begin
        if step=0 then
        YearN := YearN - 1;
        MonthN:= 12-step;
        step:=step+1;
        end;
   tempDate := EncodeDate(YearN, MonthN, 1);
   tempVal := tempVal * m_nP.m_sfKI * m_nP.m_sfKU;
   CreateOutMSG(tempVal, QRY_NAK_EN_MONTH_EP, nReq.m_swSpecc1, tempDate);
   saveToDB(m_nRxMsg);
   end; }
             {
   tempVal := ArrayBCDToDouble(tempBufRead[sm + (tempSpecc0 - 1)*5], 4);
   tempVal := tempVal * m_nP.m_sfKI * m_nP.m_sfKU;
   tempDate := EncodeDate(YearN, nReq.m_swSpecc0, 1);
   CreateOutMSG(tempVal, QRY_NAK_EN_MONTH_EP, nReq.m_swSpecc1, tempDate);
   saveToDB(m_nRxMsg);   }

   //������ ������� ����������
   //smTek:=$05A0;
   //if smTek<>-1 then
 {  smTek:=FindSmInMSG(QRY_ENERGY_SUM_EP);
   ReadEnSum(smTek);
   m_nRxMsg.m_sbyServerID := 0;
end;
}
procedure CEA8086Meter.ReadNakEnMonth(sm: integer);
var i,step,k,smTek,j     : integer;
    tempVal              : double;
    YearN, MonthN, DayN  : word;
    tempDate             : TDateTime;
    tempSpecc0,tSpecc0   : integer;
    str1,str2,str3,fub_num : string;
    b0,b1,b2 : byte;
    ki,ku:integer;
    GetRes              : Boolean;
    GetValPok           : Double;
begin
    fub_num :='';
    str1:='';
    str2:='';
    str3:='';
   if nReq.m_swSpecc1 = 0 then
        Exit;
   tempSpecc0 := nReq.m_swSpecc0;
   tempSpecc0 := tempSpecc0 - 1;
   if (tempSpecc0 < 1) then
        tempSpecc0 := 12;
   DecodeDate(Now, YearN, MonthN, DayN);
   if MonthN < nReq.m_swSpecc0 then
        YearN := YearN -1;
   tempVal := 0;
   b0 := BCDToByte(tempBufRead[0]);
   b1 := BCDToByte(tempBufRead[1]);
   b2 := BCDToByte(tempBufRead[2]);
   if (b0<=9) then str1:= '0'+IntToStr(b0)else str1:= IntToStr(b0);
   if (b1<=9) then str2:= '0'+IntToStr(b1)else str2:= IntToStr(b1);
   if (b2<=9) then str3:= '0'+IntToStr(b2)else str3:= IntToStr(b2);
   fub_num := str3+str2+str1;
   if(sm<>-1) then
   if(nReq.m_swSpecc1=1)then 
    tempValSum:=0;

   ////�������� �� ������� � ������� (������� � �� ���������)/////////
   if not ((tempBufRead[66]=$23) and (tempBufRead[67]=$23)) then
   begin
       smTek:=FindSmInMSG(QRY_ENERGY_SUM_EP);
       GetRes:= GET_ReadEnSumTekMonth(smTek,GetValPok);
       dynConnect.getCountMeterKiKu(m_nP.M_SWABOID,fub_num,ki,ku);
       if (GetRes=True)then
         begin
           tempVal := (GetValPok*ki*ku);//-(tempVal*ki*ku);
           tempDate := EncodeDate(YearN, nReq.m_swSpecc0, 1);
           CreateOutMSG(tempVal, QRY_NAK_EN_MONTH_EP, nReq.m_swSpecc1, tempDate);
           saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
           tempValSum:=tempValSum+tempVal;
            if(nReq.m_swSpecc1=4)then
              begin
                CreateOutMSG(tempValSum, QRY_NAK_EN_MONTH_EP, 0, tempDate);
                saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
                smTek:=FindSmInMSG(QRY_ENERGY_SUM_EP);
                ReadEnSum(smTek);
              end;
         end;
   end
   else
    begin
     tempVal := ArrayBCDToDouble(tempBufRead[sm + (tempSpecc0 - 1)*5], 4);
     dynConnect.getCountMeterKiKu(m_nP.M_SWABOID,fub_num,ki,ku);
     tempVal := tempVal*ki*ku; //* m_nP.m_sfKI * m_nP.m_sfKU;
     tempDate := EncodeDate(YearN, nReq.m_swSpecc0, 1);
     CreateOutMSG(tempVal, QRY_NAK_EN_MONTH_EP, nReq.m_swSpecc1, tempDate);
     saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
     tempValSum:=tempValSum+tempVal;
      if(nReq.m_swSpecc1=4)then
      begin
      CreateOutMSG(tempValSum, QRY_NAK_EN_MONTH_EP, 0, tempDate);
      saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
      smTek:=FindSmInMSG(QRY_ENERGY_SUM_EP);
      ReadEnSum(smTek);
      end;
    end;
   ///////////////////////////////////////////////////////////////////


end;

function CEA8086Meter.GET_ReadEnSum(sm: integer; var Val:Double):Boolean;
var i      : integer;
//    tempVal : double;
    Res : Boolean;
begin
   Res:=False;
     if (sm<>-1) then
     begin
     Val := ArrayBCDToDouble(tempBufRead[40 + sm + (nReq.m_swSpecc1-1)*5], 4);
     Res:=True;
     end;
   Result:=Res;
end;

function CEA8086Meter.GET_ReadEnSumTekMonth(sm: integer; var Val:Double):Boolean;
var i      : integer;
//    tempVal : double;
    Res : Boolean;
begin
   Res:=False;
     if (sm<>-1) then
     begin
     Val := ArrayBCDToDouble(tempBufRead[{20 + }sm + (nReq.m_swSpecc1-1)*5], 4);
     Res:=True;
     end;
   Result:=Res;
end;

procedure CEA8086Meter.ReadNakEnMonthNow(sm: integer);
var i       : integer;
    tempVal : double;
    fub_num : string;
begin
   for i := 0 to 3 do
   begin
     tempVal := 0;
     if (sm<>-1) then
     tempVal := ArrayBCDToDouble(tempBufRead[sm + i*5], 4);
     tempVal := tempVal * m_nP.m_sfKI * m_nP.m_sfKU;
     CreateOutMSG(tempVal, QRY_NAK_EN_MONTH_EP, i + 1, cDateTimeR.NowFirstDayMonth);
     fub_num := Format('%x', [tempBufRead[2]]) + Format('%x', [tempBufRead[1]]) + Format('%x', [tempBufRead[0]]);
     saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
     m_nRxMsg.m_sbyServerID := 0;
   end;
end;

procedure CEA8086Meter.ReadSresEn(sm: integer);
var i,j      : integer;
    tempVal  : double;
    TempDate : TDateTime;
    str1,str2,str3,fub_num : string;
    b0,b1,b2 : byte;
begin
   TempDate := trunc(Now) - nReq.m_swSpecc0;
   for i := 0 to 47 do
   begin
     tempVal := 0;
     if (sm<>-1) then
     tempVal := ArrayBCDToDouble(tempBufRead[sm + i*2], 2);
     tempVal := tempVal * m_nP.m_sfKI * m_nP.m_sfKU / 2;
     if TempDate + EncodeTime(0, 30, 0, 0)*i >= tempDateRead then
     begin
       m_nRxMsg.m_sbyServerID := i or $80;
       tempVal := 0;
     end
     else
       m_nRxMsg.m_sbyServerID := i;
     CreateOutMSG(tempVal, QRY_SRES_ENR_EP, 0, TempDate + EncodeTime(0, 30, 0, 0)*i);
     b0 := BCDToByte(tempBufRead[0]);
     b1 := BCDToByte(tempBufRead[1]);
     b2 := BCDToByte(tempBufRead[2]);
     if (b0<=9) then str1:= '0'+IntToStr(b0)else str1:= IntToStr(b0);
     if (b1<=9) then str2:= '0'+IntToStr(b1)else str2:= IntToStr(b1);
     if (b2<=9) then str3:= '0'+IntToStr(b2)else str3:= IntToStr(b2);
     fub_num := str3+str2+str1;
     saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
   end;
end;

procedure CEA8086Meter.ReadEnSum(sm: integer);
var i,j     : integer;
    tempVal,tempValSumtek : double;
    Year, Month, Day : word;
    str1,str2,str3,fub_num : string;
    b0,b1,b2 : byte;
    ki,ku:integer;
begin
     tempValSumtek:=0;
     b0 := BCDToByte(tempBufRead[0]);
     b1 := BCDToByte(tempBufRead[1]);
     b2 := BCDToByte(tempBufRead[2]);
     if (b0<=9) then str1:= '0'+IntToStr(b0)else str1:= IntToStr(b0);
     if (b1<=9) then str2:= '0'+IntToStr(b1)else str2:= IntToStr(b1);
     if (b2<=9) then str3:= '0'+IntToStr(b2)else str3:= IntToStr(b2);
     fub_num := str3+str2+str1;
   for i := 0 to 3 do
   begin
     tempVal := 0;
     if (sm<>-1) then
     tempVal := ArrayBCDToDouble(tempBufRead[40 + sm + i*5], 4);
     dynConnect.getCountMeterKiKu(m_nP.M_SWABOID,fub_num,ki,ku);
     tempVal := tempVal*ki*ku; //* m_nP.m_sfKI * m_nP.m_sfKU;
     tempValSumtek:=tempValSumtek+tempVal;
     CreateOutMSG(tempVal, QRY_ENERGY_SUM_EP, i + 1, Now);
     saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
     m_nRxMsg.m_sbyServerID := 0;
   end;
     CreateOutMSG(tempValSumtek, QRY_ENERGY_SUM_EP, 0, Now);
     saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
end;

procedure CEA8086Meter.ReadAktPow(sm: integer);
var i       : integer;
    tempVal : double;
    fub_num              : string;
begin
   tempVal := 0;
   if (sm<>-1) then
   tempVal := ArrayBCDToDouble(tempBufRead[sm], 2);
   tempVal := tempVal * m_nP.m_sfKI * m_nP.m_sfKU;
   CreateOutMSG(tempVal, QRY_MGAKT_POW_S, 0, Now);
   saveToDB_8086(fub_num, m_nP.M_SWABOID,m_nRxMsg);
   fub_num := Format('%x', [tempBufRead[2]]) + Format('%x', [tempBufRead[1]]) + Format('%x', [tempBufRead[0]]);
   m_nRxMsg.m_sbyServerID := 0;
end;

function CEA8086Meter.ReadParamFromTempBuf(nLen : Integer):Integer;
var sm,i,j               : integer;
    Year, Month, Day : word;
    crc,crcMsg : word;
    str1,str2,str3,fub_num : string;
    b0,b1,b2 : byte;
    boolfab :boolean;
begin
   boolfab:=false;
   sm := FindSmInMSG(nReq.m_swParamID);
   if sm=-1 then
   Begin
     Result := sm;
   End else
   begin
     Result := sm;
      test_massiv^ [0] := tempBufRead[Length(tempBufRead) - 4];
      test_massiv^ [1] := tempBufRead[Length(tempBufRead) - 3];
      test_massiv^ [2] := tempBufRead[Length(tempBufRead) - 2];

   b0 := BCDToByte(tempBufRead[0]);
   b1 := BCDToByte(tempBufRead[1]);
   b2 := BCDToByte(tempBufRead[2]);
   if (b0<=9) then str1:= '0'+IntToStr(b0)else str1:= IntToStr(b0);
   if (b1<=9) then str2:= '0'+IntToStr(b1)else str2:= IntToStr(b1);
   if (b2<=9) then str3:= '0'+IntToStr(b2)else str3:= IntToStr(b2);
   fub_num := str3+str2+str1;
     for j:=0 to Length(test_massiv_ADR^)-1 do
     begin
       if (test_massiv_ADR^[j]=StrToInt(fub_num))then
        begin
         if(nReq.m_swSpecc1=4)then
         begin
            test_massiv_ADR^[j]:=0;
            boolfab:=true;
            break;
         end
            else
              begin
               boolfab:=true;
               break;
              end;
            end;
     end;
     if boolfab then
     begin
         case nReq.m_swParamID of
          QRY_NAK_EN_MONTH_EP : ReadNakEnMonth(sm);
          QRY_SRES_ENR_EP     : ReadSresEn(sm);
          QRY_ENERGY_SUM_EP   : ReadEnSum(sm);
          QRY_MGAKT_POW_S     : ReadAktPow(sm);
         end;
     end
     else
     Result := -1;
     FinalAction;
   end;
end;

procedure CEA8086Meter.CreateReqToEA8086();
var tempAdr : integer;
begin
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $33;
   tempAdr := 0;
   if (EA8086Struct.m_sAdrToRead <> '') then
   try
     tempAdr := StrToInt(EA8086Struct.m_sAdrToRead);
   except
     tempAdr := 0;
   end;
   //m_nTxMsg.m_sbyInfo[14] := tempAdr mod $100;
   //m_nTxMsg.m_sbyInfo[15] := tempAdr div $100;
   //m_nTxMsg.m_sbyInfo[16] := 0;
   //m_nTxMsg.m_sbyInfo[14] := byte(tempAdr);
   //m_nTxMsg.m_sbyInfo[15] := byte(tempAdr shr 8);
   //m_nTxMsg.m_sbyInfo[16] := byte(tempAdr shr 16);
   m_nTxMsg.m_sbyInfo[14] := byte(test_massiv^ [0]); // bytes in contr memory
   m_nTxMsg.m_sbyInfo[15] := byte(test_massiv^ [1]);
   m_nTxMsg.m_sbyInfo[16] := byte(test_massiv^ [2]);

   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   MsgHead(m_nTxMsg, 18 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
  // m_nRepTimer.OnTimer(m_nP.m_swRepTime);
end;

procedure CEA8086Meter.CreateReqToParam1_EA8086(tarifs,channel:byte);
var
  addres: integer;
begin
   addres:=AdresChteniaVarTar[tarifs];
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $55;
   m_nTxMsg.m_sbyInfo[14] := StrToInt('$' + Copy(PChar(IntToHex(addres, 4)), 3, 2)); //����� ������ ��� ������ ������� ����
   m_nTxMsg.m_sbyInfo[15] := StrToInt('$' + Copy(PChar(IntToHex(addres, 4)), 1, 2)); //������� ����
   m_nTxMsg.m_sbyInfo[16] := $20;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   move(m_nTxMsg.m_sbyInfo[4], m_nTxMsg.m_sbyInfo[18] , 4);
   move(m_nTxMsg.m_sbyInfo[8], m_nTxMsg.m_sbyInfo[22] , 4);
   m_nTxMsg.m_sbyInfo[26] := channel;//$08;  //���-�� ��������
   m_nTxMsg.m_sbyInfo[27] := $0d;
   ///////�����////////////
   m_nTxMsg.m_sbyInfo[28] := $00;
   m_nTxMsg.m_sbyInfo[29] := $f0;
   m_nTxMsg.m_sbyInfo[30] := $08;
   ///////////////////////

   ///////������������ �������� �����������///////////
   m_nTxMsg.m_sbyInfo[31] := $40;
   m_nTxMsg.m_sbyInfo[32] := $05;
   m_nTxMsg.m_sbyInfo[33] := $20;
   //////////////////////////////////////////////////

   /////// �������� ����������///////////
   m_nTxMsg.m_sbyInfo[34] := $a0;
   m_nTxMsg.m_sbyInfo[35] := $05;
   m_nTxMsg.m_sbyInfo[36] := $44;
   //////////////////////////////////////

   m_nTxMsg.m_sbyInfo[37] := $f0;
   m_nTxMsg.m_sbyInfo[38] := $05;
   m_nTxMsg.m_sbyInfo[39] := $0c;


   ///////����� 1////////////
   m_nTxMsg.m_sbyInfo[40] := $00;
   m_nTxMsg.m_sbyInfo[41] := $06;
   m_nTxMsg.m_sbyInfo[42] := $41;
   /////////////////////////

   ///////����� 2////////////
   m_nTxMsg.m_sbyInfo[43] := $41;
   m_nTxMsg.m_sbyInfo[44] := $06;
   m_nTxMsg.m_sbyInfo[45] := $41;
   /////////////////////////

   ///////����� 3////////////
   m_nTxMsg.m_sbyInfo[46] := $82;
   m_nTxMsg.m_sbyInfo[47] := $06;
   m_nTxMsg.m_sbyInfo[48] := $41;
   /////////////////////////

   ///////����� 4////////////
   m_nTxMsg.m_sbyInfo[49] := $c3;

   m_nTxMsg.m_sbyInfo[50] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 50);
   MsgHead(m_nTxMsg, 51 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
   //m_nRepTimer.OnTimer(m_nP.m_swRepTime);

{   addres:=AdresChteniaVarTar[tarifs];
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $55;
   m_nTxMsg.m_sbyInfo[14] := StrToInt('$' + Copy(PChar(IntToHex(addres, 4)), 3, 2)); //����� ������ ��� ������ ������� ����
   m_nTxMsg.m_sbyInfo[15] := StrToInt('$' + Copy(PChar(IntToHex(addres, 4)), 1, 2)); //������� ����
   m_nTxMsg.m_sbyInfo[16] := $1C;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   move(m_nTxMsg.m_sbyInfo[4], m_nTxMsg.m_sbyInfo[18] , 4);
   move(m_nTxMsg.m_sbyInfo[8], m_nTxMsg.m_sbyInfo[22] , 4);
   m_nTxMsg.m_sbyInfo[26] := channel;//$08;  //���-�� ��������
   m_nTxMsg.m_sbyInfo[27] := $06;
   m_nTxMsg.m_sbyInfo[28] := $00;
   m_nTxMsg.m_sbyInfo[29] := $f0;
   m_nTxMsg.m_sbyInfo[30] := $08;
   m_nTxMsg.m_sbyInfo[31] := $a0;
   m_nTxMsg.m_sbyInfo[32] := $05;
   m_nTxMsg.m_sbyInfo[33] := $44;
   m_nTxMsg.m_sbyInfo[34] := $00;
   m_nTxMsg.m_sbyInfo[35] := $06;
   m_nTxMsg.m_sbyInfo[36] := $41;
   m_nTxMsg.m_sbyInfo[37] := $41;
   m_nTxMsg.m_sbyInfo[38] := $06;
   m_nTxMsg.m_sbyInfo[39] := $41;
   m_nTxMsg.m_sbyInfo[40] := $82;
   m_nTxMsg.m_sbyInfo[41] := $06;
   m_nTxMsg.m_sbyInfo[42] := $41;
   m_nTxMsg.m_sbyInfo[43] := $c3;
   m_nTxMsg.m_sbyInfo[44] := $06;
   m_nTxMsg.m_sbyInfo[45] := $41;
   m_nTxMsg.m_sbyInfo[46] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 46);
   MsgHead(m_nTxMsg, 47 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
   //m_nRepTimer.OnTimer(m_nP.m_swRepTime);   }
end;

procedure CEA8086Meter.CreateReqToParam2_EA8086(tarifs:byte);
begin
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $55;
   m_nTxMsg.m_sbyInfo[14] := $20;

   if (tarifs=3)then
    m_nTxMsg.m_sbyInfo[15] := $22
   else
    m_nTxMsg.m_sbyInfo[15] := $20;

   m_nTxMsg.m_sbyInfo[16] := $11;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   m_nTxMsg.m_sbyInfo[18] := $06;
   m_nTxMsg.m_sbyInfo[19] := $41;
   m_nTxMsg.m_sbyInfo[20] := $20;
   m_nTxMsg.m_sbyInfo[21] := $07;
   m_nTxMsg.m_sbyInfo[22] := $3c;
   m_nTxMsg.m_sbyInfo[23] := $5c;
   m_nTxMsg.m_sbyInfo[24] := $07;
   m_nTxMsg.m_sbyInfo[25] := $3c;
   m_nTxMsg.m_sbyInfo[26] := $98;
   m_nTxMsg.m_sbyInfo[27] := $07;
   m_nTxMsg.m_sbyInfo[28] := $3c;
   m_nTxMsg.m_sbyInfo[29] := $60;
   m_nTxMsg.m_sbyInfo[30] := $05;
   m_nTxMsg.m_sbyInfo[31] := $03;
   m_nTxMsg.m_sbyInfo[32] := $00;
   m_nTxMsg.m_sbyInfo[33] := $00;
   if (tarifs=3)then
    m_nTxMsg.m_sbyInfo[34] := $40
   else
    m_nTxMsg.m_sbyInfo[34] := $10;
   m_nTxMsg.m_sbyInfo[35] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 35);
   MsgHead(m_nTxMsg, 36 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
end;

procedure CEA8086Meter.CreateReqToParamEnd1_EA8086();
var tempAdr : integer;
begin
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $55;
   m_nTxMsg.m_sbyInfo[14] := $84;
   m_nTxMsg.m_sbyInfo[15] := $1e;
   m_nTxMsg.m_sbyInfo[16] := $03;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   m_nTxMsg.m_sbyInfo[18] := $01;  
   m_nTxMsg.m_sbyInfo[19] := $00;
   m_nTxMsg.m_sbyInfo[20] := $00;
   m_nTxMsg.m_sbyInfo[21] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 21);
   MsgHead(m_nTxMsg, 22 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
end;

procedure CEA8086Meter.CreateReqToParamEnd2_EA8086();
var tempAdr : integer;
begin
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;
   m_nTxMsg.m_sbyInfo[13] := $55;
   m_nTxMsg.m_sbyInfo[14] := $88;
   m_nTxMsg.m_sbyInfo[15] := $1e;
   m_nTxMsg.m_sbyInfo[16] := $01;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17);
   m_nTxMsg.m_sbyInfo[18] := $00;
   m_nTxMsg.m_sbyInfo[19] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 19);
   MsgHead(m_nTxMsg, 20 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
end;
procedure CEA8086Meter.SendByteToEA8086();
begin
   m_nTxMsg.m_sbyInfo[0] := $00;
   MSGHead(m_nTxMsg, 13 + 1);
   FPUT(BOX_L3_BY, @m_nTxMsg);
end;

function CEA8086Meter.SelfHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    //���������� ��� L2(������ ���)
    Result := res;
End;

procedure CEA8086Meter.TestMSG(var pMSG:CMessage);
var tempStr : string;
    cnt     : integer;
begin
   tempStr := GetStringFromFile('d:\Kon2\TraceForDebug\testEA8086.txt', 0);
   EncodeStrToBufArr(tempStr, pMsg.m_sbyInfo[0], cnt);
   pMsg.m_swLen := 13 + cnt;
end;

function CEA8086Meter.LoHandler(var pMsg:CMessage):Boolean;
Var
    res    : Boolean;
    fValue : Single;
    nres, mass_len   : Integer;
    srs    :byte;
    YearN, MonthN, DayN  : word;
    Year_,Month_:word;
    YearRead, MonthRead, DayRead  : word;
    str    : string;
Begin
   res := true;
   nres:= -1;
   if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'(CEA8086Meter/LoHandler ON');
   try
    //���������� ��� L1
    case pMsg.m_sbyType of
      PH_DATA_IND:
      Begin
        {$IFDEF EA8086_DEBUG}
          TestMSG(pMSG);
        {$ENDIF}
         DecodeDate(Now, YearN, MonthN, DayN);                  //508
        if (((pMsg.m_swLen >= 100) and (pMsg.m_swLen <=1100)) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-4]=$5A) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-5]=$A5) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-6]=$5A)) or
        ((pMsg.m_swLen=49) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-4]=$5A) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-5]=$A5) and (pMsg.m_sbyInfo[pMsg.m_swLen-14-6]=$5A)) or
        (nReq.m_swParamID=QRY_LOAD_ALL_PARAMS)then
         begin
          SetLength(tempBufRead, pMsg.m_swLen - 13);
          move(pMsg.m_sbyInfo[0], tempBufRead[0], pMsg.m_swLen - 13);
          tempDateRead := trunc(Now) + EncodeTime(4, 0, 0, 0);
          mass_len := Length(tempBufRead) - 1;
//          MonthRead:= BCDToByte(tempBufRead[23]);
//          YearRead := 2000+BCDToByte(tempBufRead[24]);
         end else
         begin
           if (tempBufRead[0]=$FF) and (tempBufRead[1]=$FF) and (tempBufRead[2]=$FF)and (tempBufRead[3]=$FF)and (tempBufRead[4]=$FF)then
           begin
             State_8086:=2;
             Result:=true;
             exit;
           end
           else
           begin
             SetLength(tempBufRead, 0);
             Result := False;
             exit;
           end;
         end;
         if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'BUFER test[0]'+IntToStr(test_massiv^[0])+' BUFER test[1]'+IntToStr(test_massiv^[1])+' BUFER test[2]'+IntToStr(test_massiv^[2]));

     // srs:= Lo(CalculateCS(tempBufRead[0], mass_len-17));//and $FF;


      if (nReq.m_swParamID=QRY_LOAD_ALL_PARAMS)  then
        begin
        srs:= Lo(CalculateCS(tempBufRead[mass_len-17],  17));
         if (tempBufRead[mass_len]<>srs) then
              begin
               Result := False;
               exit;
              end;
        nres := ReadReqToParamEA8086(pMsg.m_swLen);
        end;
       if (nReq.m_swParamID=QRY_NAK_EN_MONTH_EP)  then
       begin
          srs:= Lo(CalculateCS(tempBufRead[mass_len-17],  17));
            if (tempBufRead[mass_len]<>srs) then
              begin
               Result := False;
               exit;            
              end;
        if (tempBufRead[mass_len-4]=$5A) and (tempBufRead[mass_len-5]=$A5) and (tempBufRead[mass_len-6]=$5A) then
          if tempBufRead[12] = $07 then
            begin
              State_8086:=1;
              Result:=true;
              test_massiv^ [0] := tempBufRead[Length(tempBufRead) - 4];
              test_massiv^ [1] := tempBufRead[Length(tempBufRead) - 3];
              test_massiv^ [2] := tempBufRead[Length(tempBufRead) - 2];
              exit;
            end
          else
          if (tempBufRead[0]=$FF) and (tempBufRead[1]=$FF) and (tempBufRead[2]=$FF)and (tempBufRead[3]=$FF)and (tempBufRead[4]=$FF) then
              begin
               State_8086:=2;
               Result:=true;
               exit;
              end
          else
          begin
           Month_:=StrToInt(Format('%x', [tempBufRead[23]]));
           Year_:=StrToInt(Format('%x', [tempBufRead[24]]));
           if (Month_ <> MonthN) and (Year_ <> YearN)then //����������� ����� � ���, ����� ���� ��������� ����������������
            begin
              State_8086:=2;
              Result:=true;
              test_massiv^ [0] := tempBufRead[Length(tempBufRead) - 4];
              test_massiv^ [1] := tempBufRead[Length(tempBufRead) - 3];
              test_massiv^ [2] := tempBufRead[Length(tempBufRead) - 2];
              exit;
            end
           else
            nres := ReadParamFromTempBuf(pMsg.m_swLen)
          end;
//        else      { TODO 1 : �������� �� ���������������� � ����� }
//        begin
//          res := false;
//          Result:=res;
//          nres := -3;
//          exit;
//        end;
       end;
     
      end;
      QL_CONNCOMPL_REQ: OnConnectComplette(pMsg);
      QL_DISCCOMPL_REQ: OnDisconnectComplette(pMsg);
    End;

    if nres=0 then
    if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'End Param:');
    if nres=-1 then
      res := False;
   except
       if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'(CEA8086Meter/LoHandler ERROR');
       State_8086:=1;
       Result:=true;
       test_massiv^ [0] := tempBufRead[Length(tempBufRead) - 4];
       test_massiv^ [1] := tempBufRead[Length(tempBufRead) - 3];
       test_massiv^ [2] := tempBufRead[Length(tempBufRead) - 2];
   end;
  if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'(CEA8086Meter/LoHandler EXIT');
  Result := res;
End;

procedure CEA8086Meter.HandQryRoutine(var pMsg:CMessage);
Var
    Date1, Date2 : TDateTime;
    param        : word;
    wPrecize     : word;
    szDT         : word;
    pDS          : CMessageData;
begin
    lastMonth  := -1;
    IsUpdate   := 1;
    m_nCounter := 0;
    m_nCounter1:= 0;
    //FinalAction;
    //m_nObserver.ClearGraphQry;
    szDT := sizeof(TDateTime);
    Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));
    Move(pDS.m_sbyInfo[0],Date1,szDT);
    Move(pDS.m_sbyInfo[szDT],Date2,szDT);
    param    := pDS.m_swData1;
    wPrecize := pDS.m_swData2;
    case param of
      //QRY_ENERGY_MON_EP   : AddEnergyMonthGrpahQry(Date1, Date2);
      QRY_NAK_EN_MONTH_EP : AddNakEnergyMonthGraphQry(Date1, Date2);
      QRY_SRES_ENR_EP     : AddSresEnDayGraphQry(Date1, Date2);
    end;
end;

function CEA8086Meter.HiHandler(var pMsg:CMessage):Boolean;
Var
    res                 : Boolean;
  //  nReq              : CQueryPrimitive;
    tempP, i            : ShortInt;
    Year, Month, Day    : word;
    TempDate            : TDateTime;
    len                 : Integer;
    nres                : Integer;
Begin
  if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'(CEA8086Meter/HiHandler ON');
  res := false;
   try
    nres:= -1;
    //���������� ��� L3
    m_nRxMsg.m_sbyServerID := 0;
    case pMsg.m_sbyType of
      QL_DATARD_REQ:
      Begin
        Move(pMsg.m_sbyInfo[0],nReq,sizeof(CQueryPrimitive));
        if nReq.m_swParamID=QM_ENT_MTR_IND   then Begin OnEnterAction;exit;End;
        if nReq.m_swParamID=QM_FIN_MTR_IND   then Begin OnFinalAction;exit;End;

        if (nReq.m_swParamID=QRY_LOAD_ALL_PARAMS)  then
            Begin
             if (mCurrState=0)then
                begin
                InitABON;  //�������������� �������
                SendMessageToMeter;
                SetLength(test_massiv^, 3);
                Result := true;
                exit;
                end
             else
              begin
              SendMessageToMeter;
              SetLength(test_massiv^, 3);
              Result := true;
              exit;
              end;
            End;
          if (nReq.m_swParamID=QRY_NAK_EN_MONTH_EP)  then
            Begin
              SetLength(test_massiv^, 3);
              Result:= NakMonthMeter;
              Result := true;
              exit;
             End;
       // if (nReq.m_swParamID = QRY_NAK_EN_MONTH_EP) then
      //  SendMessageToMeter; // CreateReqToParamEA8086();

      End;
      QL_DATA_GRAPH_REQ     : HandQryRoutine(pMsg);
      QL_DATA_FIN_GRAPH_REQ : OnFinHandQryRoutine(pMsg);
//      QL_LOAD_EVENTS_REQ    : AddEventsGraphQry;
    End;
   except
      if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'(CEA8086Meter/HiHandler ERROR');
   end;
  Result := res;
  if EventBox<>Nil then EventBox.FixEvents(ET_NORMAL,'(CEA8086Meter/HiHandler EXIT');
End;

procedure CEA8086Meter.OnEnterAction;
Begin
    if (m_nP.m_sbyEnable=1)and(m_nP.m_sbyModem=1) then
    OpenPhone else
    if (m_nP.m_sbyModem=0) then FinalAction;
End;

procedure CEA8086Meter.OnFinalAction;
Begin
    //if m_nP.m_sbyModem=1 then SendPMSG(BOX_L1,m_nP.m_sbyPortID,DIR_L2TOL1,PH_CONN_IND) else
    //if m_nP.m_sbyModem=0 then FinalAction;
    //if (m_nP.m_sbyEnable=1)and(m_nP.m_sbyModem=1) OnLoadCounter;
//    FinalAction;
End;

procedure CEA8086Meter.OnConnectComplette(var pMsg:CMessage);
Begin
    m_nModemState := 1;
End;

procedure CEA8086Meter.OnDisconnectComplette(var pMsg:CMessage);
Begin
    m_nModemState := 0;
    //SendMSG(BOX_L2,DIR_QMTOL2,DL_ERRTMR1_IND);
End;

procedure CEA8086Meter.OnFinHandQryRoutine(var pMsg:CMessage);
begin
    if m_nP.m_sbyEnable=1 then
    Begin
     //if m_nModemState=1 then
//     OnFinalAction;
     IsUpdate := 0;
     m_nCounter := 0;
     m_nCounter1:= 0;
    End;
end;

function CEA8086Meter.ReadReqToParamEA8086(nLen : Integer):integer;
begin
  case mCurrState of
  0: if (tempBufRead[12]=0) then
      begin
         if (pTableChannel.m_swAmMeter=null) then
           begin
            mCurrState:=0; // ����������� �������������� � �������� ����� 2
            Result:=0;
           end
         else
           begin
            m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, pTableChannel.m_sMeter[ChannelID-1].M_SWABOID,0,0,1);  //������� � ����� ��������� ��� ����������� ���� �������(�� ������ ��� �� ��������)
            mCurrState :=1;
            Result := 1;
            //end else if(tempBufRead[12]=4) then Result := -1
           end;
      end
        else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1
      else
      begin
       if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'EA8086 ������ ��������������');
      end;
  1: if (tempBufRead[12]=0) then
      begin
        if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,IntToStr(pTableChannel.m_sMeter[ChannelID-1].M_SWABOID)+' ����������������!!!]');
        m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, nReq.m_swSpecc0,pTableMeter.m_swAmMeter,0,1);//�������� ��� ���� �������� ����� ��� �������
        mCurrState :=2; // ���� �� ������� �� ���������
        Result := 1;
      //end else if(tempBufRead[12]=4) then Result := -1;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;
  2: if (tempBufRead[12]=0) then
      begin
         if (itemPacket<EA8086_RXPacket.Count-1) then //-1
             begin
                if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,IntToStr(pTableChannel.m_sMeter[ChannelID-1].M_SWABOID)+' ����������������!!!]');
                inc(itemPacket);
                mCurrState :=2; //������������ �� ������� �� ���������
                m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, nReq.m_swSpecc0,pTableMeter.m_swAmMeter,0,1);//�������� ��� ���� �������� ����� ��� �������
                Result := 1;
             end
         else
             begin
              if (ChannelID>pTableChannel.m_swAmMeter-1) then //-1
                   begin
                   if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'EA8086 All channels are programmed');
                   ChannelID  := 1; //������������� ��������������� ������
                   itemPacket:=0; // �������������� ����� ��������� �� 0 �� ��������� �����
                   mCurrState:=3; // ����������� ��������������
                   m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS,0,0,0,1);  //������� � ����� ��������� ��� ����������� ���� �������(�� ������ ��� �� ��������)
                   Result:=1;
                   end
              else
                   begin
                   if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'EA8086 Channel to kv Packet=['+IntToStr(itemPacket+1)+' ����������������!!!]');
                   inc(ChannelID);
                   itemPacket:=0; // �������������� ����� ��������� �� 0 �� ��������� �����
                   EA8086_RXPacket.Count:=0;
                   mCurrState:=1; // ���� �� ���� ������ �� ������
                   m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, pTableChannel.m_sMeter[ChannelID-1].M_SWABOID,0,0,1);  //������� � ����� ��������� ��� ����������� ���� �������(�� ������ ��� �� ��������)
                   Result:=1;
                   end;
             end;
     //end else if(tempBufRead[12]=4) then Result := -1;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;     
  3:  if (tempBufRead[12]=0) then
      begin
         mCurrState:=4; // ����������� �������������� ����������
         Result:=1;
      //end else if(tempBufRead[12]=4) then Result := -1;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;      
  4:  if (tempBufRead[12]=0) then
      begin
         if (tarif=0) then begin
         mCurrState:=6; // ����������� �������������� �� �������
         Result:=1;
         m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);
         end
         else
         begin
         mCurrState:=5; // ����������� �������������� ����������
         Result:=1;
         m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);
         end;
      //end else if(tempBufRead[12]=4) then Result := -1;
        end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;
  5: if (tempBufRead[12]=0) then
      begin
         if (tarif=0) then
          begin
            mCurrState:=6; // ����������� �������������� � �������� ����� 1
            Result:=1;
            m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);
          end
         else
           begin
             mCurrState:=4; // ����������� �������������� � �������� ����� 1
             Result:=1;
             m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);
           end;
      //end else if(tempBufRead[12]=4) then Result := -1;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;



  6: if (tempBufRead[12]=0) then
      begin
         mCurrState:=7; // ����������� �������������� � �������� ����� 1
         Result:=1;
      //end else if(tempBufRead[12]=4) then Result := -1;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;
  7: if (tempBufRead[12]=0) then
      begin
         m_nObserver.ClearGraphQry;
         m_nObserver.ClearCurrQry;
         m_nObserver.ClearCtrlQry;
         mCurrState:=0; // ����������� �������������� � �������� ����� 2
         Result:=0;
      end else if(tempBufRead[12] in [1, 2, 3, 4, 5, 6]) then Result := -1;
 { 7:  //if (tempBufRead[12]=0) then
      begin
         mCurrState:=0; // ����������� �������������� � �������� ����� 2
         Result:=10;
      end;   }
  end;
end;

procedure CEA8086Meter.SendMessageToMeter;
var
i :integer;
tempBufRaz,tempBufSch:buf;
begin
   case mCurrState of
     0  :
        begin
             CreateReqParamTimeEA8086();
             //dynConnect.setQueryState(m_nP.M_SWABOID,m_nP.m_swMID,QUERY_STATE_OK);
             dynConnect.getChannel(m_nP.M_SWABOID,pTableChannel);  // ��������� ���-�� ��������� �� ������� ������ � ��������� � ��������� ��� ����������� �������������
             if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'( '+IntToStr(m_nP.M_SWABOID)+') ���-�� ������� �� �������'+IntToStr(ChannelID)+' = '+IntToStr(pTableChannel.m_swAmMeter)+' WRITE TIME OK');
        end;
     1  :
        begin
             dynConnect.getChannelMeter(m_nP.M_SWABOID,pTableChannel.m_sMeter[ChannelID-1].M_SWABOID,-1,pTableMeter); //��������� �� ���� ������ ���-�� ��������� � ������� � ������
             tempBufRaz:=CreateReqParamRaziem(ChannelID,pTableMeter.m_swAmMeter);//���� ������� �� ������� ������ ����� ������ � ��� �������� �� ����
             move(tempBufRaz[0], m_nTxMsg.m_sbyInfo, Length(tempBufRaz));
             MsgHead(m_nTxMsg, Length(tempBufRaz) + 13);
             SendToL1(BOX_L1, @m_nTxMsg);
             if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(CHANNEL '+IntToStr(ChannelID)+' PUT)');
             //m_nRepTimer.OnTimer(m_nP.m_swRepTime);
        end;
     2  :
        begin
             if (itemPacket=0)then
              begin
              tempBufSch:=CreateReqParamSchetchik(nReq.m_swSpecc0,pTableMeter.m_swAmMeter,adres_chtenia);//�������� ����� ������ � ���������� ��������� �� ����
              SendMessageParametrization(itemPacket);  // ��������� ��� ���������� ���� �������� �������������� ��������� �������
             end
             else
              begin
               SendMessageParametrization(itemPacket);
              end;
         if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(CHANNEL '+IntToStr(ChannelID)+' METERS '+IntToStr(itemPacket)+ ' PUT)');
        end;
     3  :
        begin
                SendMessageEndChannel(pTableChannel.m_swAmMeter+1);
                if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(END CHANEL PROGRAMMING)');
        end;
     4  :
        begin
             //dec(tarif);
             for i:=0 to 9 do
             begin
              if (buftarif[i]<>0) then
                begin
                 CreateReqToParam1_EA8086(buftarif[i],pTableChannel.m_swAmMeter);
                 if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(END TARIF 1 PROGRAMMING)');
                 break;
                end;
             end;
        end;
     5  :
        begin
              dec(tarif);
              for i:=0 to 9 do
               begin
                if (buftarif[i]<>0) then
                begin
                 CreateReqToParam2_EA8086(buftarif[i]);
                 buftarif[i]:=0;
                 if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(END TARIF 2 PROGRAMMING)');
                 break;
                end;
             end;
        end;
     6 :
       begin
             CreateReqToParamEnd1_EA8086();
             m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);
             if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(END PROGRAMMING_1)');
        end;
     7 :
        begin
             CreateReqToParamEnd2_EA8086();
             if EventBox<>Nil then EventBox.FixEvents(ET_RELEASE,'(END PROGRAMMING_2)');
             //m_nObserver.ClearGraphQry;
        end;

    end;
end;

function CEA8086Meter.NakMonthMeter:boolean;
var
TempDate            : TDateTime;
res                 : Boolean;
Year, Month, Day    : word;
len,i,nres          : Integer;
begin
    res := true;
    nres:= -1;
        len := Length(tempBufRead);
        if (nReq.m_swParamID = QRY_NAK_EN_MONTH_EP) and (len<>0) then //and (lastMonth=nReq.m_swSpecc0) and (len<>0) then
        Begin
          nres := ReadParamFromTempBuf(0);
        End
        else
        begin
            if (nReq.m_swSpecc1=1) then
            CreateReqToEA8086();
          End;
        {else
        if (nReq.m_swParamID = QRY_NAK_EN_MONTH_EP) and (lastMonth=nReq.m_swSpecc0) and (len=0) then
        Begin
         if (nReq.m_swSpecc1=1) then
          CreateReqToEA8086();
         lastMonth := nReq.m_swSpecc0;
        End else
        Begin
         CreateReqToEA8086();
         lastMonth := nReq.m_swSpecc0;
        End;}
        Result:=res;
end;

procedure CEA8086Meter.RunMeter;
Begin
    //m_nRepTimer.RunTimer;
    //m_nObserver.Run;
End;

function CEA8086Meter.CalcKS(var buf : array of byte; len : integer) : byte;
var i : integer;
begin
   Result := 0;
   for i := 0 to len - 1 do
     Result := Result + buf[i];
end;

function CEA8086Meter.GetStringFromFile(FileName : string; nStr : integer) : string;
var f :TStringList;
begin
   f := TStringList.Create();
   f.LoadFromFile(FileName);
   Result := f.Strings[nStr];
   f.Free;
end;

procedure CEA8086Meter.EncodeStrToBufArr(var str : string; var buf : array of byte; var nCount : integer);
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

procedure CEA8086Meter.EncodeNoStrToBCD(var mas:array of byte; str:string);
var rez : int64;
      i : byte;
begin //�������������� ������ � BCD
    rez   := 0;
    for i := 1 to 6 do
    begin
      if (i > Length(str)) then
        break;
      rez := rez * $10;
      rez := rez + StrToInt(str[i]);
    end;
    move(rez, mas, 3);
end;

procedure CEA8086Meter.CreateReqParamTimeEA8086();
var year, month, day,DOW,
    hour, min, sec, ms : word;
    DenWeek: integer;
begin
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[0], EA8086Struct.m_sKoncFubNum);
   m_nTxMsg.m_sbyInfo[3] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[4], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[7] := CalculateCS(m_nTxMsg.m_sbyInfo[4], 3);
   EncodeStrToBCD(m_nTxMsg.m_sbyInfo[8], EA8086Struct.m_sKoncPassw);
   m_nTxMsg.m_sbyInfo[11] := CalculateCS(m_nTxMsg.m_sbyInfo[8], 3);
   m_nTxMsg.m_sbyInfo[12] := 0;   //��� ������ - 0
   m_nTxMsg.m_sbyInfo[13] := $55;  //��� �������
   m_nTxMsg.m_sbyInfo[14] := $00;  //��� ������� �������
   m_nTxMsg.m_sbyInfo[15] := $F0;  //��� ������� �������
   m_nTxMsg.m_sbyInfo[16]:=8;
   m_nTxMsg.m_sbyInfo[17] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 17); //����������� ����� (���������������� � ����������)
   DecodeDate(Now, year, month, day);
   DecodeTime(Now, hour, min, sec, ms);
   DenWeek:= DayOfWeek(Now);
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[18], IntToStr(sec));
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[19], IntToStr(min));
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[20], IntToStr(hour));
   m_nTxMsg.m_sbyInfo[21] := DenWeek-1;
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[22], IntToStr(day));
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[23], IntToStr(month));
   EncodeNoStrToBCD(m_nTxMsg.m_sbyInfo[24], IntToStr(year-2000));
   m_nTxMsg.m_sbyInfo[25] := 128;
   m_nTxMsg.m_sbyInfo[26] := CalculateCS(m_nTxMsg.m_sbyInfo[0], 26);
   MsgHead(m_nTxMsg, 27 + 13);
   SendToL1(BOX_L1, @m_nTxMsg);
 //  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
end;

function CEA8086Meter.MsgHeadParam(read: Boolean; nomConc,passwConcOld,passwConcNew: string; addr: Pchar): buf;
var
  tempBuf: buf;
begin
  Result := nil;
  SetLength(Result, 18);          //����� ����� 18 ����         //����� ����� 18 ����
  tempBuf := NumStringToBCD(PChar(nomConc)); //  ����������� � ������ ����� �������������
  Result[0] := tempBuf[2];        //
  Result[1] := tempBuf[1];        // \ ����� ������������� � BCD �������
  Result[2] := tempBuf[0];        // / 3 ����� + 1 �����. �����
  Result[3] := CRC(Result, 0, 2); //

  tempBuf := NumStringToBCD(PChar(passwConcOld));
  Result[4] := tempBuf[2];        //
  Result[5] := tempBuf[1];        // \ ������ ������������� ������ � BCD
  Result[6] := tempBuf[0];        // / 3 ����� + 1 �����. �����
  Result[7] := CRC(Result, 4, 6); //

  tempBuf := NumStringToBCD(PChar(passwConcNew));
  Result[8] := tempBuf[2];        //
  Result[9] := tempBuf[1];        // \ ������ ������������� ����� � BCD
  Result[10] := tempBuf[0];       // / 3 ����� + 1 �����. �����
  Result[11] := CRC(Result, 8, 10);//
  Result[12] := 0;                //��� ������ - 0

  if read then
    Result[13] := $55             //��� �������
  else                            //� ����������� �� ������ ��� ������
    Result[13] := $33;
  if Length(addr) < 3 then
    addr := AdresRaz[StrToint(addr)+1];
  Result[14] := StrToInt('$' + Copy(addr, 3, 2)); //����� ������ ��� ������ ������� ����
  Result[15] := StrToInt('$' + Copy(addr, 1, 2)); //������� ����
  Result[16] := 0;                //���������� ������������ ���� (���������������� � ����������)
  Result[17] := CRC(Result, 0, 16); //����������� ����� (���������������� � ����������)
end;


function CEA8086Meter.CreateReqParamRaziem(countRaz,counKvar :integer): buf;
var
  i: integer;
  tempBuf: buf;
begin
  Result := nil;
  SetLength(Result, 51);
  tempBuf := MsgHeadParam(true, EA8086Struct.m_sKoncFubNum, EA8086Struct.m_sKoncPassw, EA8086Struct.m_sKoncPassw, AdresRaz[countRaz]);
  for i := 0 to 17 do                 //����� 18 ����
    Result[i] := tempBuf[i];
  Result[16] := 32;                   //���������� ���� ��������
  Result[17] := CRC(Result, 0, 16);   //����������� ����� �����
  if (pTable.Items[0].M_SKORPUSNUMBER='')then pTable.Items[0].M_SKORPUSNUMBER:='0';
  tempBuf := BufNazvanieRaz('��. '+PChar(pTable.Items[0].m_sAddress+', ��� '+pTable.Items[0].M_SHOUSENUMBER+', ������ '+pTable.Items[0].M_SKORPUSNUMBER+ ', ������ '+IntToStr(nReq.m_swSpecc0)),IntToStr(counKvar));
  for i := 0 to 31 do             //�������� �����, �������, ������ ����, ���������� ��������� � �������
    Result[i+18] := tempBuf[i];   //32 �����
  Result[50] := CRC(Result, 0, 49);    //����� ����������� �����
end;

function CEA8086Meter.BufNazvanieRaz(nazvanie: string;       //������� ������������ ������ �������� �������
                        countSch: string): buf;//16 ���� �������� �����
var
  i:      integer;
  nazvUl: string;
  dom:    string;
  korpus: string;
  raz:    string;
  len:integer;
begin
  //����������� ������ nazvanie �� ���������
  // nazvUl -  �������� ����� (��. ������)
  // dom - ���
  // korpus - ������
  // raz - ����� �������
  //***********************
  nazvUl := Trim(Copy(nazvanie, 1, Pos(',', nazvanie)-1));
  dom := Trim(Copy(nazvanie, Pos('���', nazvanie)+4, Pos(', ������', nazvanie)-Pos('���', nazvanie)-4));
  korpus := Trim(Copy(nazvanie, Pos('������', nazvanie)+6, Pos(', ������', nazvanie)-Pos('������', nazvanie)-6));
  raz := Trim(Copy(nazvanie, Length(nazvanie)-1, 2));
  if nazvUl = '' then
    nazvUl := '�����������';
  if dom = '' then
    dom := '0';
  if korpus = '' then
    korpus := '0';
  //**************************

  SetLength(Result, 32);                            //��������� ����� ������ 32 �����

  //********������������ ������******
  //�������� �����
  if Length(nazvUl) < 16 then                       //���������� ������ �������� �����
    begin                                           //������ 16 ����
      for i := 0 to Length(nazvUl)-1 do             //���� �������� ������ 16 ���� �� ���������� �� ����� ���������
        Result[i] := RusKod[integer(nazvUl[i+1])];
      for i := Length(nazvUl) to 15 do
        Result[i] := RusKod[integer(' ')]
    end
  else                                              //���� ������, �� ���������� ������ 16 ����
    for i := 0 to 15 do
      Result[i] := RusKod[integer(nazvUl[i+1])];

  //����� ����
  Result[16] := RusKod[integer('�')];              //������ � - ���
  for i := 19-Length(dom)+1 to 19 do                      //���������� ������ ������ ����
    Result[i] := RusKod[integer(dom[i-19+Length(dom)])];  //3 �����. ���� ����� ������ 3 ���� � ������ ����
  for i := 17 to 19-Length(dom) do
    Result[i] := RusKod[integer('0')];

  Result[20] := RusKod[integer(' ')];               //������ ����� ������� ���� � �������

  //����� �������
  Result[21] := RusKod[integer('�')];               //����� ������� 2 �����
  if Length(korpus) = 1 then                        //����� ����� 1 �����, �� ������� �����
    begin
      Result[22] := RusKod[integer('0')];
      Result[23] := RusKod[integer(korpus[1])];
    end
  else
    for i := 22 to 23 do
      Result[i] := RusKod[integer(korpus[i-21])];

  //����� �������
  Result[24] := RusKod[integer('�')];                 //���������� ������� ��� � ������ �������
  if Length(raz) = 1 then
    begin
      Result[25] := RusKod[integer('0')];
      Result[26] := RusKod[integer(raz[1])];
    end
  else
    for i := 25 to 26 do
      Result[i] := RusKod[integer(raz[i-24])];

  Result[27] := RusKod[integer(' ')];                 //������ ����� ������� ������� � ����������� ���������

  //���������� ��������� � �������
  Result[28] := RusKod[integer('�')];
  len:= Length(countSch);
  for i := 31-Length(countSch)+1 to 31 do                           //���������� ������ ���������� ���������
    Result[i] := RusKod[integer(countSch[i-31+Length(countSch)])];  //3 ����� ���� ����� ������ 3 ���� � ������ ����
  for i := 29 to 31-Length(countSch) do
    Result[i] := RusKod[integer('0')];
end;


function CEA8086Meter.CreateReqParamSchetchik(countRaz,counKvar:integer;var adres_read: integer): buf;
var
  tempBuf: buf;
  addres: integer;
  nomerByte,lenItem,lenItem1: integer;
  i,j,k: integer;

  procedure Proverka();    //��������� �������� ����� ������ (32 �����)
  var
    tempBufer: buf;
    i: integer;
  begin
    if Length(Result) in [50, 101, 152, 203, 254] then
      begin
        Result[nomerByte-34] := 32;
        Result[nomerByte-33] := CRC(Result, nomerByte-50, nomerByte-34);
        SetLength(Result, Length(result)+1);
        Result[nomerByte] := CRC(Result, nomerByte-50, nomerByte-1);
         /////////������� ������� � ���������/////////////
        case  Length(Result) of
         51:
           begin
            SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result));
            move(Result[Length(Result)-51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)); //�������� � ������� ������� �� �������� ���������� �������
           end;
         102:
            begin
            SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-51);
            move(Result[Length(Result)-51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-51);
            end;
         153:
            begin
             SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-102);
             move(Result[Length(Result)-51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-102);
             end;
         204:
            begin
             SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-153);
             move(Result[Length(Result)-51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-153);
            end;
         255:
           begin
           SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-204);
           move(Result[Length(Result)-51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-204);
           end;
        end;
        inc(EA8086_RXPacket.Count); //���������� ���������� ����������� �������
        Inc(nomerByte);
        addres := addres + 32;
        adres_chtenia:=addres;
        tempBufer := MsgHeadParam(true, EA8086Struct.m_sKoncFubNum, EA8086Struct.m_sKoncPassw, EA8086Struct.m_sKoncPassw, Pchar(IntToHex(addres, 4)));
        SetLength(Result, Length(result)+18);
         for i := 0 to 17 do
           begin
            Result[nomerByte] := tempBufer[i];
            Inc(nomerByte);
           end;
      end;
  end;

begin
  Result := nil;
  SetLength(Result, 19);
  addres := StrToInt('$' + AdresRaz[ChannelID]) + 32;
  tempBuf := MsgHeadParam(true, EA8086Struct.m_sKoncFubNum, EA8086Struct.m_sKoncPassw, EA8086Struct.m_sKoncPassw, PChar(IntToHex(addres, 4)));

  for i := 0 to 17 do
    Result[i] := tempBuf[i];

  nomerByte := 18;
  Result[nomerByte] := pTableChannel.m_sMeter[ChannelID-1].M_SWABOID;//countRaz;      //����� �������
  Inc(nomerByte);

//**********��������� � ����� ���-�� ��������� � i-�� ��������� �����������
//********** + ������������� ���������� + ������ ��������� � BCD � CRC (3+1)
  for i := 1 to 11 do
   begin
    dynConnect.getChannelMeter(m_nP.M_SWABOID,pTableChannel.m_sMeter[ChannelID-1].M_SWABOID,i,pTableChannelTariffs);
    if (pTableChannelTariffs.m_swAmMeter <> 0) then
     begin
        if (buftarif[i-1]=0) then
         begin
         buftarif[i-1]:=i;
         inc(tarif);
         end;
        //dynConnect.getChannelMeter(m_nP.M_SWABOID,nReq.m_swSpecc0,i,pTableMeter); //��������� �� ���� ������ ���-�� ��������� � ������� � ������
        Proverka();
        SetLength(Result, Length(Result)+1);
        //Result[nomerByte] := pTableMeter.m_swAmMeter;//counKvar;    //���������� ��������� � i-��� ��������� �����������
        Result[nomerByte] := pTableChannelTariffs.m_swAmMeter;//counKvar;    //���������� ��������� � i-��� ��������� �����������
        Inc(nomerByte);
        Proverka();
        SetLength(Result, Length(Result)+1);
        Result[nomerByte] := i;                       //����� �������� �����������
        Inc(nomerByte);
        for j := 0 to pTableChannelTariffs.m_swAmMeter - 1 do        //counKvar
          begin
            if StrToIntDef(pTableChannelTariffs.m_sMeter[j].typeabo, 0) = 0 then
              tempBuf := NumStringToBCD('000000')
            else
              tempBuf := NumStringToBCD(PChar(pTableChannelTariffs.m_sMeter[j].typeabo));
              dynConnect.setQueryState(m_nP.M_SWABOID,pTableChannelTariffs.m_sMeter[j].m_swMID,QUERY_STATE_OK);
            for k := 2  downto 0 do
                      begin
                Proverka();
                SetLength(Result, Length(Result)+1);
                Result[nomerByte] := tempBuf[k];
                Inc(nomerByte);
              end;
            Proverka();
            SetLength(Result, Length(Result)+1);
            Result[nomerByte] := CRC(tempBuf, 0, 2);    //������������ ����� ������� ���������
            Inc(nomerByte);
          end;
          pTableChannelTariffs.m_swAmMeter:=0;
     end;
   end;
  if (((nomerByte mod 51) - 18) mod 2) = 1 then
    begin
      SetLength(Result, Length(Result)+1);
      Result[nomerByte] := 0;
      Inc(nomerByte);
    end;

  Result[nomerByte-(nomerByte mod 51)+16] := (nomerByte mod 51) - 18;
  Result[nomerByte-(nomerByte mod 51)+17] := CRC(Result, nomerByte-(nomerByte mod 51), nomerByte-(nomerByte mod 51)+16);
  SetLength(Result, Length(Result)+1);
  Result[nomerByte] := CRC(Result, nomerByte-(nomerByte mod 51), nomerByte-1);
  case EA8086_RXPacket.Count of   //case itemPacket of
  0:
  begin
    SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result));
    move(Result[0], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)); //�������� � ������� ������� �� �������� ���������� �������
  end;
  1:
  begin
    SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-51);
    move(Result[51], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-51);  //�������� � ������� ������� �� �������� ���������� �������
  end;
  2:
  begin
    SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-102);
    move(Result[102], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-102); //�������� � ������� ������� �� �������� ���������� �������
  end;
  3:
  begin
    SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-153);
    move(Result[153], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-153); //�������� � ������� ������� �� �������� ���������� �������
  end;
  4:
  begin
    SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-204);
    move(Result[204], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-204); //�������� � ������� ������� �� �������� ���������� �������
  end;
  5:
  begin
   SetLength(EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet, Length(Result)-255);
   move(Result[255], EA8086_RXPacket.Items[EA8086_RXPacket.Count].Packet[0],Length(Result)-255); //�������� � ������� ������� �� �������� ���������� �������
  end;
  end;
  inc(EA8086_RXPacket.Count); //���������� ���������� ����������� �������
end;

procedure  CEA8086Meter.SendMessageParametrization(itemPacket:integer);
begin
  move(EA8086_RXPacket.Items[itemPacket].Packet[0], m_nTxMsg.m_sbyInfo[0], Length(EA8086_RXPacket.Items[itemPacket].Packet));
  MsgHead(m_nTxMsg, Length(EA8086_RXPacket.Items[itemPacket].Packet) + 13);
  SendToL1(BOX_L1, @m_nTxMsg);
end;

procedure  CEA8086Meter.SendMessageEndChannel(addr:integer);
var
tempBuf:buf;
begin
  tempBuf := MsgHeadParam(true, EA8086Struct.m_sKoncFubNum, EA8086Struct.m_sKoncPassw, EA8086Struct.m_sKoncPassw, AdresRaz[addr]);
  move(tempBuf[0], m_nTxMsg.m_sbyInfo[0], Length(tempBuf));
  m_nTxMsg.m_sbyInfo[16] := 1;
  m_nTxMsg.m_sbyInfo[17] := CRC(m_nTxMsg.m_sbyInfo, 0, 16);
  m_nTxMsg.m_sbyInfo[18] := 255;
  m_nTxMsg.m_sbyInfo[19] := CRC(m_nTxMsg.m_sbyInfo, 0, 18);
  MsgHead(m_nTxMsg, 20 + 13);
  SendToL1(BOX_L1, @m_nTxMsg);
  m_nObserver.AddGraphParam(QRY_LOAD_ALL_PARAMS, 0,0,1,1);//�������� ��� ���� �������� ����� ��� ����� �������
end;


function CEA8086Meter.CRC(mass: array of byte; nach: integer; konec: integer):byte;  //������� �������� ����������� �����
var
  i: integer;
begin
  Result := 0;
  for i := nach to konec do
    Result := Result + mass[i];
end;

function CEA8086Meter.NumStringToBCD(const inStr: PChar): buf;  //������� �������������� ������ � BCD ������
  function Pack(ch1, ch2: Char): byte;
  begin
    //Assert((ch1 > '0') and (ch1 < '9'));
    //Assert((ch2 > '0') and (ch2 < '9'));
    Result := (Ord(ch1) and $F) or ((Ord(ch2) and $F) shl 4)
  end;
var
  i: Integer;
begin
    if Odd(Length(inStr)) then
      Result := NumStringToBCD(PChar('0' + String(instr)))
    else
    begin
      SetLength(Result, Length(inStr) div 2);
      for i := 1 to Length(Result) do
        Result[i-1] := Pack(inStr[2*i-1], inStr[2*i-2]);
    end;
end;

end.


