{*******************************************************************************
 *  ������ ��������� �������� ����1
 *  Ukrop
 *  11.07.2013
 ******************************************************************************}

unit knsl2MIRT1W2Meter;

interface

uses
    Windows, Classes, SysUtils,
    knsl5config, knsl2meter, knsl5tracer, utldatabase, utltypes, utlbox,
    utlconst, utlmtimer, utlTimeDate, knsl3EventBox;

type
    SRTRADDR= packed record
      Items : array[0..8] of WORD;
      Count : Word;
    End;
    CMIRT1W2Meter = class(CMeter)
    private
        m_DotPosition : Integer; // ��������� �����
        m_sAddress    : SRTRADDR;
        m_Password    : DWORD; // ������ ��������
        m_nRtr        : Byte; //���������� ��������������
        nRSH          : Byte; //�����
        m_QFNC        : BYTE;
        m_QTimestamp  : TDateTime;

        m_IsAuthorized: Boolean;
        m_SresID      : Byte;
        m_dbDecSeparator  : Extended;
        nReq : CQueryPrimitive;
        dt_TLD          : TDateTime;
        nOldYear        : Word;
        bl_SaveCrEv     : boolean;
        id              : Word;
    public
        // base
        constructor Create;
        destructor  Destroy; override;
        procedure   InitMeter(var pL2:SL2TAG); override;
        procedure   RunMeter; override;

        // events routing
        function    SelfHandler(var pMsg:CMessage) : Boolean; override;
        function    LoHandler(var pMsg:CMessage) : Boolean; override;
        function    HiHandler(var pMsg:CMessage) : Boolean; override;

        procedure   OnEnterAction();
        procedure   OnFinalAction();
        procedure   OnConnectComplette(var pMsg:CMessage); override;
        procedure   OnDisconnectComplette(var pMsg:CMessage); override;
        function    SetCommand(swParamID:Word;swSpecc0,swSpecc1,swSpecc2:Smallint;byEnable:Byte):Boolean;override;


        procedure   HandQryRoutine(var pMsg:CMessage);
        procedure   OnFinHandQryRoutine(var pMsg:CMessage);

    private
        function    Param2CMD(_ParamID : BYTE) : BYTE;
        function    FindFrame(var pMsg:CMessage;var nRet:Byte):Boolean;
        function    GetFrame(var byInMsg:array of byte;var byOutMsg:array of byte):Integer;

        function    CRC8(_Packet: array of BYTE; _DataLen:Integer) : Byte;
        function    IsValidMessage(var pMsg : CMessage) : boolean;
        procedure   FillMessageHead(var pMsg : CHMessage; length : word);
        procedure   MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
        function    FillMessageBody(var _Msg : CHMessage; _FNC : BYTE;_Len : BYTE):Word;
        procedure   FillSaveDataMessage(_Value : double; _ParamID : byte; _Tariff : byte; _WriteDate : Boolean);
        function    GetAddres(var strInAddr:String;var sAddress:SRTRADDR):Boolean;
        function    ByteStuff(var _Buffer : array of BYTE; _Len : Byte) : Byte;
        function    ByteUnStuff(var _Buffer : array of BYTE; _Len : Byte): Byte;

        // protocol REQUESTS
        procedure   REQ01_OpenSession(var nReq: CQueryPrimitive);   // ������� ������ � ��������
        procedure   RES01_OpenSession(var pMsg:CMessage);           // �����

        procedure   REQ05_GetEnergySum(var nReq: CQueryPrimitive);
        procedure   RES05_GetEnergySum(var pMsg:CMessage);

        procedure   REQ1C_GetDateTime(var nReq: CQueryPrimitive);   // ������ ����/�������
        procedure   RES1C_GetDateTime(var pMsg : CMessage);         // �n���
        procedure   KorrTime(LastDate : TDateTime);

        //procedure   REQ1D_SetDateTime(var nReq: CQueryPrimitive);
        procedure   RES1D_SetDateTime(var pMsg : CMessage);

        procedure   REQ26_ReadEnergyOn30min(var nReq: CQueryPrimitive);
        procedure   RES26_ReadEnergyOn30min(var pMsg : CMessage);

        procedure   REQ24_GetEnergyMonth(var nReq: CQueryPrimitive);
        procedure   RES24_GetEnergyMonth(var pMsg : CMessage);

        procedure   REQ25_GetEnergyDay(var nReq: CQueryPrimitive);
        procedure   RES25_GetEnergyDay(var pMsg : CMessage);

        procedure   REQ2B_GetCurrentPower(var nReq: CQueryPrimitive);
        procedure   RES2B_GetCurrentPower(var pMsg:CMessage);

        procedure   REQ2A_GetEvents(var nReq: CQueryPrimitive);
        procedure   RES2A_GetEvents(var pMsg:CMessage);

        procedure   REQ10_ReadConfig(var nReq: CQueryPrimitive);
        procedure   RES10_ReadConfig(var pMsg:CMessage);

    /////////////////////////////

        procedure   ADD_Energy_Sum_GraphQry();
        procedure   ADD_DateTime_Qry();
        procedure   ADD_Events_GraphQry();

        procedure   ADD_SresEnergyDay_GraphQry(dt_Date1, dt_Date2 : TDateTime);
        procedure   ADD_NakEnergyMonth_Qry(dt_Date1, dt_Date2 : TDateTime);
        procedure   ADD_NakEnergyDay_Qry(dt_Date1, dt_Date2 : TDateTime);
        procedure   ADD_CurrPower_Qry(_DTS, _DTE : TDateTime);

    End;


implementation


{*******************************************************************************
 *
 ******************************************************************************}
constructor CMIRT1W2Meter.Create;
Begin
  TraceL(2, m_nP.m_swMID,'(__)CL2MD::> MIRT1 Meter Created');
End;


{*******************************************************************************
 *
 ******************************************************************************}
destructor CMIRT1W2Meter.Destroy;
Begin
    inherited;
End;

procedure CMIRT1W2Meter.RunMeter; Begin end;

function CMIRT1W2Meter.SelfHandler(var pMsg:CMessage):Boolean;
begin
    Result := False;
end;

{*******************************************************************************
 *
 ******************************************************************************}
procedure CMIRT1W2Meter.InitMeter(var pL2:SL2TAG);
Var
  Year, Month, Day : Word;
  str : String;
begin
  //m_Address := StrToInt(pL2.m_sddPHAddres);
  str := pL2.m_sddPHAddres;
  GetAddres(str,m_sAddress);
  m_nP.m_sddPHAddres := IntToStr(m_sAddress.Items[0]);
  m_Password := StrToInt(pL2.m_schPassword);
  IsUpdate := 0;
  m_nRtr   := 0;
  m_IsAuthorized := false;
  SetHandScenario;
  SetHandScenarioGraph;
  DecodeDate(Now, Year, Month, Day);
  nOldYear := Year;
  TraceL(2,m_nP.m_swMID,'(__)CL2MD::>MIRW1 Meter Created:'+
    ' PortID:'+IntToStr(m_nP.m_sbyPortID)+
    ' Rep:'+IntToStr(m_byRep)+
    ' Group:'+IntToStr(m_nP.m_sbyGroupID));
End;
function CMIRT1W2Meter.GetAddres(var strInAddr:String;var sAddress:SRTRADDR):Boolean;
Var
    str,strF : String;
    i,nPos:Integer;
    wAddr : array[0..7] of Word;
Begin
    try
    Result := False;
    str    := strInAddr+';';
    nPos   := Pos(';',str);
    sAddress.Count := 0;
    for i:=0 to 8 do sAddress.Items[i] := 0;
    i := 0;
    while (nPos<>0) do
    Begin
     strF := Copy(str,0,nPos-1);
     //sAddress.Items[i] := StrToInt(strF);
     wAddr[i] := StrToInt(strF);
     Delete(str,1,nPos+0);
     nPos := Pos(';',str);
     Inc(i);
     Result := True;
     if (nPos=1) then break;
    End;
    sAddress.Count := i;
    for i:=0 to sAddress.Count-1 do
    Begin
      if (i=(sAddress.Count-1)) then
      sAddress.Items[i] := wAddr[0]
       else
      sAddress.Items[i] := wAddr[i+1];
    End;
    except
     Result   := False;
    end;
End;
function  CMIRT1W2Meter.SetCommand(swParamID:Word;swSpecc0,swSpecc1,swSpecc2:Smallint;byEnable:Byte):Boolean;
Var
  i,j : Integer;
Begin
  case swParamID of
       QRY_SRES_ENR_EP :
       Begin
        for j:=0 to 4-1 do
        for i:=6 downto 1 do
        m_nObserver.AddCurrParam(swParamID,swSpecc0,(j),swSpecc2 or (i shl 8),byEnable);
       End;
       else
       if swSpecc1<=3 then
        m_nObserver.AddCurrParam(swParamID,swSpecc0,swSpecc1,swSpecc2,byEnable);
  End;
  Result := False;
End;
{*******************************************************************************
 * ���������� ������� ������� ������
 ******************************************************************************}
function CMIRT1W2Meter.FindFrame(var pMsg:CMessage;var nRet:Byte):Boolean;
Var
   i,j,nLen:Integer;
   byBuff : array[0..100] of Byte;
Begin
   Result := False;
   for i:=0 to pMsg.m_swLen-1-13 do
   Begin
    if (pMsg.m_sbyInfo[i+0]=$73)and(pMsg.m_sbyInfo[i+1]=$55) then
    Begin
     if ((pMsg.m_sbyInfo[3+i] and $0f)=0)and
        ((pMsg.m_sbyInfo[2+i] and $20)=0)and
        (pMsg.m_sbyInfo[4+i]=255)and
        (pMsg.m_sbyInfo[5+i]=255)then
     Begin
      nRet := pMsg.m_sbyInfo[3+i] shl 4;
      nLen := GetFrame(pMsg.m_sbyInfo[i],byBuff);
      if(nLen<>0) then
      Begin
       move(byBuff,pMsg.m_sbyInfo[0], nLen);
       pMsg.m_swLen := 13+nLen;
       Result := True;
       break;
      End;
     End;
    End;
   End;
End;
function CMIRT1W2Meter.GetFrame(var byInMsg:array of byte;var byOutMsg:array of byte):Integer;
Var
   i : Integer;
Begin
   Result := 0;
   FillChar(byOutMsg,100,0);
   byOutMsg[0] := $73;
   byOutMsg[1] := $55;
   i:=2;
   while (byInMsg[i]<>$55) do
   Begin
    byOutMsg[i] := byInMsg[i];
    if (i>95) then
    Begin
     Result := 0;
     //break;
     exit
    End;
    Inc(i);
   End;
   byOutMsg[i] := byInMsg[i];
   Result := i+1+1;
End;
function CMIRT1W2Meter.LoHandler(var pMsg:CMessage):Boolean;
Var
  nLen : Word;
  nRet : Byte;
begin
  Result := true;
  case pMsg.m_sbyType of
    QL_CONNCOMPL_REQ: OnConnectComplette(pMsg);
    QL_DISCCOMPL_REQ: OnDisconnectComplette(pMsg);
    PH_DATA_IND:
    Begin
      TraceM(2,pMsg.m_swObjID,'(__)CMIRW2::>Inp DRQ:',@pMsg);
      //73 55 04 00 FF FF 9D 00 01 31 01 43 00 00 01 9D 00 F9 55 CD
 //Out//73 55 20 00 9D 00 FF FF 01 00 00 00 00 F4 55
      //Inp DRQ:7B 00 00 00 01 01 0C 00 00 21 00
      //73 55 20 21 CB 00 9D 00 FF FF E1 00 01 00 00 00 00 C7 55 D7
      //73 55 20 20 9D 00 FF FF E1 00 CB 00 01 00 00 00 00 E4 55 DC
      //73 55 04 22 CB 00 E1 00 FF FF 9D 00 01 31 01 43 00 00 01 9D 00 0D 55 D0
      //73 55 04 21 E1 00 FF FF 9D 00 CB 00 01 31 01 43 00 00 01 9D 00 A9 55 D8
      //73 55 04 20 FF FF 9D 00 CB 00 E1 00 01 31 01 43 00 00 01 9D 00 33 55 D7
 //Out//73 55 20 22 E1 00 CB 00 9D 00 FF FF 01 00 00 00 00 A7 55
      if FindFrame(pMsg,nRet)=False then
      Begin
        Result := false;
        exit;
      End;
      nLen := ByteUnStuff(pMsg.m_sbyInfo, pMsg.m_swLen-13);
      pMsg.m_swLen := 13+nLen;
      if not IsValidMessage(pMsg) then
      begin
        TraceM(2,pMsg.m_swObjID,'(__)CMIRW1::>Error BAD Packet:',@pMsg);
        //ByteUnStuff(pMsg.m_sbyInfo, pMsg.m_swLen - 12);
        //TraceM(2,pMsg.m_swObjID,'(__)CMIRW1::>Inp1 DRQ:',@pMsg);
        Result := false;
        exit;
      end;
      case m_QFNC of // FUNCTION
        $01 : RES01_OpenSession(pMsg);
        $05 : RES05_GetEnergySum(pMsg);
        $1C : RES1C_GetDateTime(pMsg);
        $1D : RES1D_SetDateTime(pMsg);
        $24 : RES24_GetEnergyMonth(pMsg);
        $25 : RES25_GetEnergyDay(pMsg);
        $26 : RES26_ReadEnergyOn30min(pMsg);
        $2B : RES2B_GetCurrentPower(pMsg);
        $10 : RES10_ReadConfig(pMsg);
        else  FinalAction();
      end;
      if (m_nP.m_sbyStBlock and ST_L2_AUTO_BLOCK) <> 0 then
      begin
        m_nP.m_sbyStBlock := (m_nP.m_sbyStBlock xor ST_L2_AUTO_BLOCK) or ST_L2_NO_AUTO_BLOCK;
        m_pDB.UpdateBlStateMeter(m_nP.m_swMID, m_nP.m_sbyStBlock);
        CreateNoAutoBlockEv();
      end;
    end;
  end;
end;

{*******************************************************************************
 * ���������� ������� �������� ������
 ******************************************************************************}
function CMIRT1W2Meter.HiHandler(var pMsg:CMessage):Boolean;
//Var
    //nReq : CQueryPrimitive;
begin
  Result := False;

  m_nRxMsg.m_sbyServerID := 0;
  case pMsg.m_sbyType of
    QL_DATARD_REQ:
    Begin
      Move(pMsg.m_sbyInfo[0],nReq,sizeof(CQueryPrimitive));
      if nReq.m_swParamID=QM_ENT_MTR_IND then Begin OnEnterAction;exit;End;
      if nReq.m_swParamID=QM_FIN_MTR_IND then Begin OnFinalAction;exit;End;

      case nReq.m_swParamID of
        QRY_AUTORIZATION   : REQ01_OpenSession(nReq);
        QRY_ENERGY_SUM_EP  : REQ05_GetEnergySum(nReq);
        QRY_SRES_ENR_EP    : REQ26_ReadEnergyOn30min(nReq);
        QRY_NAK_EN_MONTH_EP: REQ24_GetEnergyMonth(nReq);
        QRY_NAK_EN_DAY_EP  : REQ25_GetEnergyDay(nReq);
        QRY_KPRTEL_KE      : REQ10_ReadConfig(nReq);
        QRY_DATA_TIME      : REQ1C_GetDateTime(nReq);
        QRY_JRNL_T3        : REQ2A_GetEvents(nReq);
        QRY_MGAKT_POW_S    : REQ2B_GetCurrentPower(nReq);
      else
          FinalAction();
      end;

      TraceM(2,pMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@pMsg);
//      m_nRepTimer.OnTimer(m_nP.m_swRepTime);
    End;
    QL_DATA_GRAPH_REQ    : HandQryRoutine(pMsg);
    QL_DATA_FIN_GRAPH_REQ: OnFinHandQryRoutine(pMsg);

    QL_LOAD_EVENTS_REQ   : ADD_Events_GraphQry();
  end;
end;


{*******************************************************************************
 *  ������� ����������� �����
 ******************************************************************************}
 {
 functionCalculateCRC(PData:Pointer;Count:Integer):Byte;
var
CRC_Pointer:Integer;
CRC_Byte,i:Byte;
begin
  Result:=0;
forCRC_Pointer:=1 to Count do
begin
CRC_Byte:=Byte(PData^);
PData:=IncPtr(PData);
for i:=1 to 8 do
begin
if ((CRC_Bytexor Result) and $80) =0 then7
begin
            Result:=Byte(Result shl 1);
end else begin
            Result:=Byte((Result shl 1)xor $A9);
end;
CRC_Byte:=Byte(CRC_Byteshl 1);
end;
end;
end;

 }
function CMIRT1W2Meter.CRC8(_Packet: array of BYTE; _DataLen:Integer) : Byte;
var
  CRC_Pointer:Integer;
  CRC_Byte,i:Byte;
begin
  Result:=0;
  for CRC_Pointer:=2 to _DataLen-1+2 do
  begin
    CRC_Byte:=_Packet[CRC_Pointer];

    for i:=1 to 8 do
    begin
      if ((CRC_Byte xor Result) and $80) =0 then
      begin
        Result:=Byte(Result shl 1);
      end else
      begin
        Result:=Byte((Result shl 1)xor $A9);
      end;

      CRC_Byte:=Byte(CRC_Byte shl 1);
    end;
  end;
end;


{*******************************************************************************
 *  �������� ����������� ���������
 *      @param var pMsg : CMessage ���������
 *      @return Boolean
 ******************************************************************************}
 {
2894	0.00000475	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 73
2900	0.00000363	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 55
2906	0.00000363	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 07
2912	0.00000307	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 00
2918	0.00000391	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: FF
2924	0.00000391	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: FF
2930	0.00000363	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 73
2936	0.00000307	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 11
2942	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 01
2948	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 1C
2954	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 31
2960	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 01
2966	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 4B
2972	0.00000335	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 00
2978	0.00000363	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 37
2984	0.00000419	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 18
2990	0.00000419	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 0C
2996	0.00000391	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 02
3002	0.00000391	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 1A
3008	0.00000447	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 0B
3014	0.00000391	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 0D
3019	0.00000559	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: DD
3039	0.00000447	MeterTools.exe	IRP_MJ_READ	Serial2	SUCCESS	Length 1: 55
Inp DRQ:23 00 00 00 01 01 0C 00 00 21 00 73 55 07 00 FF FF 73 11 01 1C 31 01 4B 00 1E 3B 0D 02 1A 0B 0D 66 55 CF
 }
function CMIRT1W2Meter.IsValidMessage(var pMsg : CMessage) : Boolean;
var
    l_DataLen : WORD;
    nSH : Integer;
begin
    Result := false;
    // ����������� �����
    nSH:=0;
    if m_nP.m_sbyTSlice=1 then nSH:=1; //
    l_DataLen := pMsg.m_swLen-13-2-nSH;
    if (self.CRC8(pMsg.m_sbyInfo, pMsg.m_swLen-13-4-nSH-1) <> pMsg.m_sbyInfo[l_DataLen]) then
    begin
        TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CMIRT1 ������ CRC! �����!');
        exit;
    end;

  Result := true;
end;


{*******************************************************************************
 *
 ******************************************************************************}
procedure CMIRT1W2Meter.FillMessageHead(var pMsg : CHMessage; length : word);
begin
   pMsg.m_swLen         := length + 13;
   pMsg.m_swObjID       := m_nP.m_swMID;
   pMsg.m_sbyFrom       := DIR_L2TOL1;
   pMsg.m_sbyFor        := DIR_L2TOL1;
   pMsg.m_sbyType       := PH_DATARD_REQ;
   pMsg.m_sbyTypeIntID  := m_nP.m_sbyPortID;
   pMsg.m_sbyIntID      := m_nP.m_sbyPortID;
   pMsg.m_sbyServerID   := MET_MIRT1;
   pMsg.m_sbyDirID      := IsUpdate;
   SendOutStat(pMsg.m_swLen);
end;

procedure CMIRT1W2Meter.MsgHeadForEvents(var pMsg:CHMessage; Size:byte);
begin
    pMsg.m_swLen       := 13 + 9 + 3;
    pMsg.m_swObjID     := m_nP.m_swMID;
    pMsg.m_sbyFrom     := DIR_L2TOL3;
    pMsg.m_sbyFor      := DIR_L2TOL3;
    pMsg.m_sbyType     := PH_EVENTS_INT;
    pMsg.m_sbyIntID    := m_nP.m_sbyPortID;
    pMsg.m_sbyServerID := MET_MIRT1;
    pMsg.m_sbyDirID    := m_nP.m_sbyPortID;

(*    m_nRxMsg.m_sbyInfo[0] := 9 + 3;
    m_nRxMsg.m_sbyInfo[8] := m_Address;
        move(pMsg.m_sbyInfo[10], m_nRxMsg.m_sbyInfo[9], 3);
        i := i + 4;

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

*)
end;



function CMIRT1W2Meter.FillMessageBody(var _Msg : CHMessage; _FNC : BYTE;_Len : BYTE):Word;
Var
  nLen,nSH : Word;
  i: Integer;
begin
  m_nTxMsg.m_sbyInfo[0] := $73; // ������� ������ ������ 2by
  m_nTxMsg.m_sbyInfo[1] := $55;
  //m_nTxMsg.m_sbyInfo[2] := $20 OR _Len; // ����� ������
  //73 55 20 33 CB 00 E1 00 D8 01 9D 00 FF FF 1E 00 00 00 00 FA 55
  i   := 0;
  nSH := 0;
  //Out 1E 00 00 00 02 02 00 00 00 21 00
  //73 55 20 33 E1 00 CB 00 9D 00 FF FF 01 00 00 00 00 EA 55
  //73 55 20 22 E1 00 CB 00 9D 00 FF FF 01 00 00 00 00 A7 55
  for i:=0 to m_sAddress.Count-1 do
  Begin
   nSH := 2*i;
   m_nTxMsg.m_sbyInfo[4+nSH] := LO(m_sAddress.Items[i]);
   m_nTxMsg.m_sbyInfo[5+nSH] := HI(m_sAddress.Items[i]);
  End;
  //_Len := _Len + 2*m_sAddress.Count;
  Dec(i);
  m_nRtr := i;
  nRSH := 2*m_nRtr;
  m_nTxMsg.m_sbyInfo[2]     := $20 OR _Len;// ����� ������

  m_nTxMsg.m_sbyInfo[3]     := m_nRtr or (m_nRtr shl 4);  // :=0; // ������

  m_nTxMsg.m_sbyInfo[6+nSH] := $FF;              // ����� ���� ��� ������� $FFFF
  m_nTxMsg.m_sbyInfo[7+nSH] := $FF;
  m_nTxMsg.m_sbyInfo[8+nSH] := _FNC;             // �������� ��� 2

  // ������ ��� ��������
  m_nTxMsg.m_sbyInfo[9+nSH] := (m_Password AND $000000FF);
  m_nTxMsg.m_sbyInfo[10+nSH]:= (m_Password AND $0000FF00) shr 8;
  m_nTxMsg.m_sbyInfo[11+nSH]:= (m_Password AND $00FF0000) shr 16;
  m_nTxMsg.m_sbyInfo[12+nSH]:= (m_Password AND $FF000000) shr 24;


  m_nTxMsg.m_sbyInfo[13+nSH + _Len] := CRC8(m_nTxMsg.m_sbyInfo,13+nSH+_Len);
  m_nTxMsg.m_sbyInfo[14+nSH + _Len] := $55;
  nLen := ByteStuff(m_nTxMsg.m_sbyInfo, 15+nSH+_Len); // ���� ��������
  //73 55 20 22 E1 00 CB 00 9D 00 FF FF 01 00 00 00 00 A7 55
  Result := nLen;
end;


{*******************************************************************************
 *  ������������ ��������� ���������� ������
 *      @param _Value : double �������� ���������
 *      @param _EType : byte ��� �������
 *      @param _Tariff : byte ������
 *      @param _WriteDate : Boolean ���������� ����� �������
 ******************************************************************************}
procedure CMIRT1W2Meter.FillSaveDataMessage(_Value : double; _ParamID : byte; _Tariff : byte; _WriteDate : Boolean);
var
    l_Year, l_Month, l_Day,
    l_Hour, l_Min, l_Second, l_MS : word;
begin
   m_nRxMsg.m_sbyType    := DL_DATARD_IND;
   m_nRxMsg.m_sbyFor     := DIR_L2TOL3;
   m_nRxMsg.m_swObjID    := m_nP.m_swMID;
   m_nRxMsg.m_swLen      := 13 + 9 + sizeof(double);
   m_nRxMsg.m_sbyInfo[0] := 9 + sizeof(double);
   m_nRxMsg.m_sbyInfo[1] := _ParamID;
   m_nRxMsg.m_sbyInfo[8] := _Tariff;
   move(_Value, m_nRxMsg.m_sbyInfo[9], sizeof(double));
   m_nRxMsg.m_sbyDirID   := IsUpdate;
   m_nRxMsg.m_sbyServerID:= 0;


   if _WriteDate=false then
        exit;


    case _ParamID of
        QRY_NAK_EN_MONTH_EP,
        QRY_NAK_EN_MONTH_EM,
        QRY_NAK_EN_MONTH_RP,
        QRY_NAK_EN_MONTH_RM :
        begin
            DecodeDate(m_QTimestamp, l_Year, l_Month, l_Day);
            m_nRxMsg.m_sbyInfo[2] := l_Year - 2000;
            m_nRxMsg.m_sbyInfo[3] := l_Month;
            m_nRxMsg.m_sbyInfo[4] := 1;
            m_nRxMsg.m_sbyInfo[5] := 00;
            m_nRxMsg.m_sbyInfo[6] := 00;
            m_nRxMsg.m_sbyInfo[7] := 00;
          end;

        QRY_ENERGY_MON_EP,
        QRY_ENERGY_MON_EM,
        QRY_ENERGY_MON_RP,
        QRY_ENERGY_MON_RM :
        begin
            //cDateTimeR.IncMonth(m_QTimestamp);
            DecodeDate(m_QTimestamp, l_Year, l_Month, l_Day);
            m_nRxMsg.m_sbyInfo[2] := l_Year - 2000;
            m_nRxMsg.m_sbyInfo[3] := l_Month;
            m_nRxMsg.m_sbyInfo[4] := 1;
            m_nRxMsg.m_sbyInfo[5] := 00;
            m_nRxMsg.m_sbyInfo[6] := 00;
            m_nRxMsg.m_sbyInfo[7] := 00;
          end;

        QRY_NAK_EN_DAY_EP,
        QRY_NAK_EN_DAY_EM,
        QRY_NAK_EN_DAY_RP,
        QRY_NAK_EN_DAY_RM,
        QRY_ENERGY_DAY_EP,
        QRY_ENERGY_DAY_EM,
        QRY_ENERGY_DAY_RP,
        QRY_ENERGY_DAY_RM :
        begin
            //cDateTimeR.IncDate(m_QTimestamp);
            DecodeDate(m_QTimestamp, l_Year, l_Month, l_Day);
            m_nRxMsg.m_sbyInfo[2] := l_Year - 2000;
            m_nRxMsg.m_sbyInfo[3] := l_Month;
            m_nRxMsg.m_sbyInfo[4] := l_Day;
            m_nRxMsg.m_sbyInfo[5] := 00;
            m_nRxMsg.m_sbyInfo[6] := 00;
            m_nRxMsg.m_sbyInfo[7] := 00;
        end;{
       QRY_U_PARAM_S,
       QRY_U_PARAM_A,
       QRY_U_PARAM_B,
       QRY_U_PARAM_C,
       QRY_I_PARAM_S,
       QRY_I_PARAM_A,
       QRY_I_PARAM_B,
       QRY_I_PARAM_C,
       QRY_KOEF_POW_A,
       QRY_KOEF_POW_B,
       QRY_KOEF_POW_C,
       QRY_FREQ_NET :
       begin
        DecodeDate(m_QTimestamp, l_Year, l_Month, l_Day);
        DecodeTime(m_QTimestamp, l_Hour, l_Min, l_Second, l_MS);
        m_nRxMsg.m_sbyServerID := l_Hour * 2 + (l_Min div 30);
        m_nRxMsg.m_sbyInfo[2] := l_Year - 2000;
        m_nRxMsg.m_sbyInfo[3] := l_Month;
        m_nRxMsg.m_sbyInfo[4] := l_Day;
        m_nRxMsg.m_sbyInfo[5] := l_Hour;
        m_nRxMsg.m_sbyInfo[6] := l_Min;
        m_nRxMsg.m_sbyInfo[7] := l_Second;
      end;}
    else
        DecodeDate(Now(), l_Year, l_Month, l_Day);
        DecodeTime(Now(), l_Hour, l_Min, l_Second, l_MS);
        m_nRxMsg.m_sbyInfo[2] := l_Year - 2000;
        m_nRxMsg.m_sbyInfo[3] := l_Month;
        m_nRxMsg.m_sbyInfo[4] := l_Day;
        m_nRxMsg.m_sbyInfo[5] := l_Hour;
        m_nRxMsg.m_sbyInfo[6] := l_Min;
        m_nRxMsg.m_sbyInfo[7] := l_Second;
    end;
end;



{******************************************************************************
 *  ��������� ������ ��������� � ��������� ��301 �� ID ���������
 *      @param  _ParamID : Byte
 *      @return Integer
 ******************************************************************************}
function CMIRT1W2Meter.Param2CMD(_ParamID : BYTE) : BYTE;
Begin
  case _ParamID of
    QRY_AUTORIZATION  : Result := $01;
    QRY_DATA_TIME     : Result := $1C;
    QRY_NAK_EN_MONTH_EP : Result := $24;
    QRY_NAK_EN_DAY_EP : Result := $25;
    QRY_SRES_ENR_EP   : Result := $26;
    QRY_JRNL_T3       : Result := $2A;
    QRY_MGAKT_POW_S   : Result := $2B;
    QRY_ENERGY_SUM_EP : Result := $05;
    else
        Result := 1;
    end;
End;


procedure CMIRT1W2Meter.HandQryRoutine(var pMsg:CMessage);
Var
    DTS, DTE : TDateTime;
    l_Param        : word;
    szDT         : word;
    pDS          : CMessageData;
begin
    IsUpdate := 1;
    m_nObserver.ClearGraphQry;
    szDT := sizeof(TDateTime);
    Move(pMsg.m_sbyInfo[0],pDS,sizeof(CMessageData));

    Move(pDS.m_sbyInfo[0],DTE,szDT);
    Move(pDS.m_sbyInfo[szDT],DTS,szDT);

    l_Param := pDS.m_swData1;
    case l_Param of
      QRY_SRES_ENR_EP :
        ADD_SresEnergyDay_GraphQry(DTS, DTE);

      QRY_NAK_EN_DAY_EP:
        ADD_NakEnergyDay_Qry(DTS, DTE);

      QRY_NAK_EN_MONTH_EP:
        ADD_NakEnergyMonth_Qry(DTS, DTE);

        QRY_JRNL_T3 :
          ADD_Events_GraphQry();

        QRY_DATA_TIME :
          ADD_DateTime_Qry();
    end;
end;



procedure CMIRT1W2Meter.OnFinHandQryRoutine(var pMsg:CMessage);
begin
  if m_nP.m_sbyEnable=1 then
  begin
    m_IsAuthorized := false;
    OnFinalAction();
    TraceM(2,pMsg.m_swObjID,'(__)CL2MD::>CMIRT1 OnFinHandQryRoutine  DRQ:',@pMsg);
    IsUpdate := 0;
  End;
end;

procedure CMIRT1W2Meter.OnEnterAction;
begin
    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CMIRT1 OnEnterAction');
    if (m_nP.m_sbyEnable=1) and (m_nP.m_sbyModem=1) then
        OpenPhone
    else if m_nP.m_sbyModem=0 then
        FinalAction;
end;

procedure CMIRT1W2Meter.OnConnectComplette(var pMsg:CMessage);
Begin
    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CMIRT1 OnConnectComplette');
    m_nModemState := 1;
    if not((m_blIsRemCrc=True)or(m_blIsRemEco=True)) then
        FinalAction;
End;

procedure CMIRT1W2Meter.OnDisconnectComplette(var pMsg:CMessage);
Begin
    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CMIRT1 OnDisconnectComplette');
    m_nModemState := 0;
End;

procedure CMIRT1W2Meter.OnFinalAction;
begin
    TraceL(2,m_nP.m_swMID,'(__)CL2MD::>CMIRT1 OnFinalAction');
    FinalAction;
end;







{*******************************************************************************
 *  ����� ����� �������� �������� ��������� ���������� �������������
 *  ��� ������������� ������������� ������ ����, �:
 *	0�55 ���������� �� 0�73 0�11,
 *	0�73 ���������� �� 0�73 0�22.
 ******************************************************************************}
function CMIRT1W2Meter.ByteStuff(var _Buffer : array of BYTE; _Len : Byte) : Byte;
var
  i, l : integer;
  tArr : array[0..255] of BYTE;
begin
  l := 0;
  FillChar(tArr,254,0);
  for i:=0 to _Len-1 do
  Begin
   if (i=0) then
   Begin
      tArr[l]:=$73;Inc(l);
   End else
   if (i=1) then
   Begin
      tArr[l]:=$55;Inc(l);
   End else
   if (i>1)and(i<=(_Len-1-1)) then
   Begin
     if (_Buffer[i]=$55) then
     Begin
      tArr[l]:=$73;Inc(l);
      tArr[l]:=$11;Inc(l);
     end else
     if (_Buffer[i]=$73) then
     Begin
      tArr[l]:=$73;Inc(l);
      tArr[l]:=$22;Inc(l);
     end else
     Begin
      tArr[l] := _Buffer[i];
      Inc(l);
     End;
   End;
  End;
  Inc(l);
  tArr[l-1] := _Buffer[_Len-1];
  move(tarr,_Buffer,l);
  Result := l;
  {
  l := 2;
  tArr[0] := _Buffer[0];
  tArr[1] := _Buffer[1];
  for i := 0 to _Len-1 do
  begin
    if (_Buffer[i] = $55) then
    begin
      tArr[l] := $73;
      Inc(l);
      tArr[l] := $11;
    end else if (_Buffer[i] = $73) then
    begin
      tArr[l] := $73;
      Inc(l);
      tArr[l] := $22;
    end else
      tArr[l] := _Buffer[i];
    Inc(l);
  end;
  Inc(l);
  tArr[l-1] := _Buffer[_Len+3-1];
  move(tarr, _Buffer, l+3);
  Result := l;
  }
end;

{*******************************************************************************
 *  ����� ����� �������� �������� ��������� ���������� �������������
 *  ��� ������������� ������������� ������ ����, �:
 *	0�73 0�11 ���������� �� 0�55,
 *	0�73 0�22 ���������� �� 0�73.
*******************************************************************************}
function CMIRT1W2Meter.ByteUnStuff(var _Buffer : array of BYTE; _Len : Byte) : Byte;
var
  i, l : integer;
  tArr : array[0..255] of BYTE;
begin
  l := 0;
  i := 0;
  FillChar(tArr,255,0);
  while i<_Len do
  begin
    if (i=0) then
    Begin
     tArr[l] := $73;Inc(l);Inc(i);
    End else
    if (i=1) then
    Begin
     tArr[l] := $55;Inc(l);Inc(i);
    End else
   if (i>1)and(i<=(_Len-1-1)) then
    Begin
    if ((_Buffer[i] = $73) AND (_Buffer[i + 1] = $11)) then
    begin
      tArr[l] := $55;
      Inc(l);Inc(i);Inc(i);
    end else if ((_Buffer[i] = $73) AND (_Buffer[i + 1] = $22)) then
    begin
      tArr[l] := $73;
      Inc(l);Inc(i);Inc(i);
    end else
    Begin
      tArr[l] := _Buffer[i];
      Inc(l);
      Inc(i);
    End;
   End else
    Begin
      tArr[l] := _Buffer[i];
      Inc(l);
      Inc(i);
    End;
  end;
  //Inc(l);
  //tArr[l-2] := _Buffer[_Len-2];
  move(tarr, _Buffer, l);
  Result := l;
end;























(*******************************************************************************
 * ������� "Ping"
 *   Ping	0�01	�������������
 * 4 �����:
 *   1 ���� - ������ ���������;
 *   1 ���� - ������ ��������;
 *   2 ����� - ����� ����������.
 *
 *   @param var nReq: CQueryPrimitive �������� �������
 ******************************************************************************)
procedure CMIRT1W2Meter.REQ01_OpenSession(var nReq: CQueryPrimitive);
begin
  m_QTimestamp := Now();
  m_QFNC := $01; // ������� ������ � ��������

  //FillMessageBody(m_nTxMsg, m_QFNC, 0);
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 0));
   FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;


(*******************************************************************************
 * �����
 ******************************************************************************)
procedure CMIRT1W2Meter.RES01_OpenSession(var pMsg:CMessage);
var
  l_ProtoVer,
  l_FWVer,
  l_Addr : WORD;
begin
  m_IsAuthorized := true;

  l_ProtoVer := pMsg.m_sbyInfo[13+nRSH];
  l_FWVer    := pMsg.m_sbyInfo[14+nRSH];
  l_Addr      := pMsg.m_sbyInfo[15+nRSH] + pMsg.m_sbyInfo[16+nRSH]*$100;

  TraceL (2, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ���������� � ����. ��������: ' + IntToStr(l_ProtoVer) +
      ' ��������: '  + IntToStr(l_FWVer) + ' �����: '  + IntToStr(l_Addr));
  FinalAction();
end;

procedure CMIRT1W2Meter.REQ05_GetEnergySum(var nReq: CQueryPrimitive);
Begin
  m_QTimestamp := Now();
  m_QFNC := $05; // ������� ������ � ��������

  //FillMessageBody(m_nTxMsg, m_QFNC, 0);
  m_nTxMsg.m_sbyInfo[13+nRSH] := nReq.m_swSpecc1;
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 1));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;

procedure CMIRT1W2Meter.RES05_GetEnergySum(var pMsg:CMessage);
var
  l_Data : array[0..5] of Extended;
  dbDivKoeff : Extended;
  l_DWData : DWORD;
  l_DivKoeff,l_Config : Byte;
  i : Integer;
begin
  m_QTimestamp := Now;
  //nSH := 2*m_nRtr;
  TraceL (2, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ���������� � ����. ��������:RES05_GetEnergySum ');

  //l_Config := pMsg.m_sbyInfo[14+nRSH];
    l_DivKoeff := pMsg.m_sbyInfo[14+nRSH];
   dbDivKoeff:=1.0;
  {
  ���� 1,0 - ��������� ����� �� ���
(00-"00000000",  01-"0000000.0",
 10-"000000.00", 11-"00000.000")
  }
  if (l_DivKoeff and $03)=$00 then dbDivKoeff:=1.0 else
  if (l_DivKoeff and $03)=$01 then dbDivKoeff:=10.0 else
  if (l_DivKoeff and $03)=$02 then dbDivKoeff:=100.0 else
  if (l_DivKoeff and $03)=$03 then dbDivKoeff:=1000.0;

  move(pMsg.m_sbyInfo[23{13}+nRSH], l_DWData, 4);
  l_Data[0] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;

  for i:=0 to 3 do
  begin
    move(pMsg.m_sbyInfo[27{23} + i*4+nRSH], l_DWData, 4);
    l_Data[1 + i] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;
  end;

  for i:=0 to 4 do
  begin
    if (pMsg.m_sbyInfo[12+nRSH]=$06) then
     l_Data[i] := 0;
    FillSaveDataMessage(l_Data[i], QRY_ENERGY_SUM_EP+nReq.m_swSpecc1, i, true);
    FPUT(BOX_L3_BY, @m_nRxMsg);
  end;

  FinalAction();
end;

(*******************************************************************************
 * ReadDateTime	0x1C	������ ������� � ����
 * 7 ����:
 *   �������,
 *   ������,
 *   ����,
 *   ���� ������ (0 - �����������),
 *   ����,
 *   �����,
 *   ���.
 *
 * @param var nReq: CQueryPrimitive �������� �������
 ******************************************************************************)
procedure CMIRT1W2Meter.REQ1C_GetDateTime(var nReq: CQueryPrimitive);
begin
  m_QFNC := $1C;
  m_QTimestamp := Now();

  //FillMessageBody(m_nTxMsg, m_QFNC, 0);
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 0));

  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;


(*******************************************************************************
 * ����� "������ ������� � ����"
 *******************************************************************************)
(*******************************************************************************
 * ����� "������ ������� � ����"
 *******************************************************************************)

procedure CMIRT1W2Meter.RES1C_GetDateTime(var pMsg:CMessage);
var
  nReq : CQueryPrimitive;
  Year,Month,Day,_yy,_mn,_dd,_hh,_mm,_ss  : word;
  Hour,Min  ,Sec,mSec,nKorrTime: word;
  LastDate:TDateTime;
begin
    m_nRxMsg.m_sbyInfo[0] := 8;
    m_nRxMsg.m_sbyInfo[1] := QRY_DATA_TIME;
    {
     7 ����: �������, ������, ����, ���� ������ (0 - �����������), ����, �����, ���.
     l_ss := pMsg.m_sbyInfo[13];
     l_mm := pMsg.m_sbyInfo[14];
     l_hh := pMsg.m_sbyInfo[15];
     l_D  := pMsg.m_sbyInfo[17];
     l_M  := pMsg.m_sbyInfo[18];
     l_Y  := pMsg.m_sbyInfo[19] + 2000;
    }
    _yy := (pMsg.m_sbyInfo[19+nRSH]);
    _mn := (pMsg.m_sbyInfo[18+nRSH]);
    _dd := (pMsg.m_sbyInfo[17+nRSH]);
    _hh := (pMsg.m_sbyInfo[15+nRSH]);
    _mm := (pMsg.m_sbyInfo[14+nRSH]);
    _ss := (pMsg.m_sbyInfo[13+nRSH]);
    if (_mn>12)or(_mn=0)or(_dd>31)or(_dd=0)or(_hh>59)or(_mm>59)or(_ss>59) then
    Begin
     FinalAction;
     exit;
    End;
    //i:=i+3;
    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
        //�������� �������� �������� ���������� ��� �������� ����
        if nOldYear<>Year then
        Begin
         m_nP.m_sdtSumKor :=cDateTimeR.SecToDateTime(0);
         m_pDB.UpdateTimeKorr(m_nP.m_swMID, m_nP.m_sdtSumKor);
        End;
        nOldYear := Year;
        LastDate := EncodeDate(_yy + 2000, _mn, _dd) + EncodeTime(_hh, _mm, _ss, 0);
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
        if (Year <> _yy) or (Month <> _mn) or (Day <> _dd)
        or (Hour <> _hh) or (Min <> _mm) or (abs(_ss - Sec) >= nKorrTime) then
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
end;
procedure CMIRT1W2Meter.KorrTime(LastDate : TDateTime);
var Year, Month, Day           : word;
    Hour, Min, Sec, mSec       : word;
begin
    TraceL(2,m_nRxMsg.m_swObjID,'(__)CMIRW1::>   Korrection Time');
    if abs(LastDate - Now) < EncodeTime(0, 0, 1, 0) then
      bl_SaveCrEv := false
    else
      bl_SaveCrEv := true;
    m_nTxMsg.m_sbyInfo[0]  := StrToInt(m_nP.m_sddPHAddres);
    DecodeDate(Now, Year, Month, Day);
    DecodeTime(Now, Hour, Min, Sec, mSec);
    Year := Year - 2000;
    if m_nP.m_sdtSumKor < m_nP.m_sdtLimKor then
    begin
      dt_TLD := LastDate;
      { }
    end;
    if m_nP.m_sdtSumKor >= m_nP.m_sdtLimKor then
    begin
      m_nRxMsg.m_sbyType    := PH_EVENTS_INT;
      m_nRxMsg.m_sbyInfo[0] := 13 + 8;
      m_nRxMsg.m_sbyInfo[1] := QRY_LIM_TIME_KORR;
      m_nRxMsg.m_sbyInfo[2] := Year;
      m_nRxMsg.m_sbyInfo[3] := Month;
      m_nRxMsg.m_sbyInfo[4] := Day;
      m_nRxMsg.m_sbyInfo[5] := Hour;
      m_nRxMsg.m_sbyInfo[6] := Min;
      m_nRxMsg.m_sbyInfo[7] := Sec;
      FPUT(BOX_L3_BY, @m_nRxMsg);
      FinalAction;
      exit;
    end;
{
// BCD
  m_nTxMsg.m_sbyInfo[13] := l_ss;
  m_nTxMsg.m_sbyInfo[14] := l_mm;
  m_nTxMsg.m_sbyInfo[15] := l_hh;
  m_nTxMsg.m_sbyInfo[16] := DayOfWeek(Now()) - 1;

  m_nTxMsg.m_sbyInfo[17] := l_D;
  m_nTxMsg.m_sbyInfo[18] := l_M;
  m_nTxMsg.m_sbyInfo[19] := l_Y - 2000;
}

    m_QTimestamp := Now();
    m_QFNC       := $1D;
    //m_Req := nReq;

    DecodeTime(m_QTimestamp, Hour, Min, Sec, mSec);
    DecodeDate(m_QTimestamp, Year, Month, Day);

    // BCD
    m_nTxMsg.m_sbyInfo[13+nRSH] := (Sec);
    m_nTxMsg.m_sbyInfo[14+nRSH] := (Min);
    m_nTxMsg.m_sbyInfo[15+nRSH] := (Hour);
    m_nTxMsg.m_sbyInfo[16+nRSH] := DayOfWeek(Now()) - 1;

    m_nTxMsg.m_sbyInfo[17+nRSH] := (Day);
    m_nTxMsg.m_sbyInfo[18+nRSH] := (Month);
    m_nTxMsg.m_sbyInfo[19+nRSH] := (Year - 2000);

    FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 7));
    SendToL1(BOX_L1, @m_nTxMsg);
    m_nRepTimer.OnTimer(m_nP.m_swRepTime);
    TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
    if bl_SaveCrEv then
      StartCorrEv(LastDate);
end;

(*******************************************************************************
 * ����� �� ������� "������ ������� � ���� � �������" (������� ������ �� 4-� ������)
 0�00 - OK (��� ���������)
0�01 - ������� ������ � �������� �������
0�02 - ������� ������������ ��������
0�03 - ������� ��������� ���������� ���������
0�04 - �������� ������ ������
0�05 - ��������� ������������
0�06 - ������������� ������ ���
0�07- ������� ������ � �������� �������

 *******************************************************************************)
procedure CMIRT1W2Meter.RES1D_SetDateTime(var pMsg:CMessage);
Var
    byStatus : Byte;
begin
    byStatus := pMsg.m_sbyInfo[12+nRSH];
    if byStatus=$00 then
    Begin
     TraceL(3, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ����� �������� �����������: ' + DateTimeToStr(Now()));
     m_nP.m_sdtSumKor       := m_nP.m_sdtSumKor + abs(Now - dt_TLD);
     if m_nP.m_sdtSumKor >= m_nP.m_sdtLimKor then m_nP.m_sdtSumKor := m_nP.m_sdtLimKor;
     m_pDB.UpdateTimeKorr(m_nP.m_swMID, m_nP.m_sdtSumKor);
     if bl_SaveCrEv then FinishCorrEv(Now - dt_TLD);
    End else
    Begin
     if byStatus=$01 then  TraceL(3, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ������� ������ ������� � �������� ������� ') else
     if byStatus=$05 then  TraceL(3, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ��������� ������������ ') else
     TraceL(3, m_nTxMsg.m_swObjID, '(__)CMIRW1::> ������:'+IntToStr(byStatus));
     ErrorCorrEv;
    End;
    FinalAction();
    m_QFNC:=0;
end;
(*******************************************************************************
 * ReadConfigure
 * 0x10
 * ������ ������������
    ���� 1,0 - ��������� ����� �� ���
    (00-"00000000",  01-"0000000.0",
    10-"000000.00", 11-"00000.000")
 *******************************************************************************)

procedure  CMIRT1W2Meter.REQ10_ReadConfig(var nReq: CQueryPrimitive);
Begin
  m_QTimestamp := Now();
  m_QFNC := $10; // ������������
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 0));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
End;
procedure  CMIRT1W2Meter.RES10_ReadConfig(var pMsg:CMessage);
Var
   byConfig0 : Byte;
Begin
   byConfig0 := pMsg.m_sbyInfo[13];
   //m_dbDecSeparator := pMsg.m_sbyInfo[13];
   //if (byConfig0 and $03)=$00 then m_dbDecSeparator := 1.0 else
   //if (byConfig0 and $03)=$00 then m_dbDecSeparator := 1.0 else
   //if (byConfig0 and $03)=$00 then m_dbDecSeparator := 1.0;
End;
(*******************************************************************************
 * ReadEnergyOnMonth
 * 0x24
 * ������ �������� ������� �� ������� � ��������, ����������� �� ������ �������� � 23 ���������� �������
    2 �����:
      1� ���� - �����;
      2� ���� - ���.
 *******************************************************************************)
procedure CMIRT1W2Meter.REQ24_GetEnergyMonth(var nReq: CQueryPrimitive);
Var
  Year,Month,Day : Word;
  dtTemp : TDateTime;
begin
  m_QFNC := $24;
  if (nReq.m_swSpecc2=0)then
  Begin
   dtTemp := Now;
   cDateTimeR.DecMonthEx(nReq.m_swSpecc2,dtTemp);
   DecodeDate(dtTemp,Year,Month,Day);
   nReq.m_swSpecc0 := Year-2000;
   nReq.m_swSpecc1 := (Month shl 8)+nReq.m_swSpecc1;
   nReq.m_swSpecc2 := 1;
  End;

  m_QTimestamp := EncodeDate(nReq.m_swSpecc0+2000, HiByte(nReq.m_swSpecc1), 1);

  {dtTemp := Now;
  cDateTimeR.DecMonthEx(nReq.m_swSpecc1,dtTemp);
  DecodeDate(dtTemp,Year,Month,Day);
  nReq.m_swSpecc2:= Month-nReq.m_swSpecc1;
  cDateTimeR.DecMonthEx(nReq.m_swSpecc1,dtTemp);       }

  m_nTxMsg.m_sbyInfo[13+nRSH] := LoByte(nReq.m_swSpecc1);//nReq.m_swSpecc2;

  m_nTxMsg.m_sbyInfo[14+nRSH] :=  HiByte(nReq.m_swSpecc1);
  m_nTxMsg.m_sbyInfo[15+nRSH] :=  nReq.m_swSpecc0;

  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 3));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);

end;

(*******************************************************************************
 *      24 �����:
 *   1 ���� - �����;
 *   1 ���� - ���;
 *   4 ����� - ����� �� ���� �������;
 *   1 ���� - ���������������� ����;
 *   1 ���� - ����������� �������;
 *   16 ���� - �������� �� ������� ������� (4 ����� �� ����� ������� � 1�� ������) �� ������ ������������ ������.
 ******************************************************************************)
procedure CMIRT1W2Meter.RES24_GetEnergyMonth(var pMsg : CMessage);
var
  l_Data : array[0..5] of Extended;
  dbDivKoeff : Extended;
  l_DWData : DWORD;
  l_DivKoeff,
  l_Config : Byte;
  i : Integer;
begin

  if (pMsg.m_sbyInfo[12+nRSH]=$06) then
  Begin
   //FinalAction;
   //exit;
  End;
    if (HiByte(nReq.m_swSpecc1)=0) or (HiByte(nReq.m_swSpecc1)>12) then
  Begin
    FinalAction();
    exit;
  End;
  m_QTimestamp := EncodeDate(nReq.m_swSpecc0+2000,HiByte(nReq.m_swSpecc1),1);

  //l_Config := pMsg.m_sbyInfo[19+nRSH];
  l_DivKoeff := pMsg.m_sbyInfo[17+nRSH];
  dbDivKoeff:=1.0;

  if (l_DivKoeff and $03)=$00 then dbDivKoeff:=1.0 else
  if (l_DivKoeff and $03)=$01 then dbDivKoeff:=10.0 else
  if (l_DivKoeff and $03)=$02 then dbDivKoeff:=100.0 else
  if (l_DivKoeff and $03)=$03 then dbDivKoeff:=1000.0;

  move(pMsg.m_sbyInfo[22+nRSH], l_DWData, 4);
  l_Data[0] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;

  for i:=0 to 3 do
  begin
    move(pMsg.m_sbyInfo[26 + i*4+nRSH], l_DWData, 4);
    l_Data[1 + i] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;
  end;

  for i:=0 to 4 do
  begin
    if (pMsg.m_sbyInfo[12+nRSH]=$06) then l_Data[i] := 0;
    FillSaveDataMessage(l_Data[i], QRY_NAK_EN_MONTH_EP + LoByte(nReq.m_swSpecc1), i, true);
    FPUT(BOX_L3_BY, @m_nRxMsg);
  end;
  FinalAction();

end;



(*******************************************************************************
 * ReadEnergyOnDay
  0x25
  ������ �������� ������� �� ������� � ��������, ����������� �� ����� �����, �� ���������  90 �����
  3 �����:
    1� ���� - ����;
    2� ���� - �����;
    3� ���� - ���.
 *******************************************************************************)
procedure CMIRT1W2Meter.REQ25_GetEnergyDay(var nReq: CQueryPrimitive);
Var
  Year,Month,Day : Word;
  dtTemp : TDateTime;
begin
  m_QFNC := $25;
  if (HiByte(nReq.m_swSpecc1)=0) then
  Begin
   dtTemp := Now-nReq.m_swSpecc2;
   DecodeDate(dtTemp,Year,Month,Day);
   nReq.m_swSpecc0 := Year-2000;
   nReq.m_swSpecc1 := (Month shl 8)+LoByte(nReq.m_swSpecc1);
   nReq.m_swSpecc2 := Day;
  End;
  m_QTimestamp := EncodeDate(nReq.m_swSpecc0 + 2000, HiByte(nReq.m_swSpecc1), nReq.m_swSpecc2);
  m_nTxMsg.m_sbyInfo[13+nRSH] := LoByte(nReq.m_swSpecc1);
  m_nTxMsg.m_sbyInfo[14+nRSH] := nReq.m_swSpecc2;
  m_nTxMsg.m_sbyInfo[15+nRSH] := HiByte(nReq.m_swSpecc1);
  m_nTxMsg.m_sbyInfo[16 +nRSH] := nReq.m_swSpecc0;

  //FillMessageBody(m_nTxMsg, m_QFNC, 3);
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 4));

  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;

(*******************************************************************************
 *	25 ����:
 *   1 ���� - ����;
 *   1 ���� - �����;
 *   1 ���� - ���;
 *   4 ����� - ����� �� ���� �������;
 *   1 ���� - ���������������� ����;
 *   1 ���� - ����������� �������;
 *   16 ���� - �������� �� ������� ������� (4 ����� �� ����� ������� � 1�� ������) �� ������ ������������ ������.
 ******************************************************************************)
procedure CMIRT1W2Meter.RES25_GetEnergyDay(var pMsg : CMessage);
var
  l_Data : array[0..5] of Extended;
  dbDivKoeff : Extended;
  l_DWData : DWORD;
  //l_DWData : Single;
  l_DivKoeff,
  l_Config : Byte;
  i : Integer;
begin
  if (HiByte(nReq.m_swSpecc1)=0) or (HiByte(nReq.m_swSpecc1)>12) then
  Begin
    FinalAction();
    exit;
  End;
  m_QTimestamp := EncodeDate(nReq.m_swSpecc0 + 2000, HiByte(nReq.m_swSpecc1), nReq.m_swSpecc2);
  //l_Config := pMsg.m_sbyInfo[17+nRSH];
  l_DivKoeff := pMsg.m_sbyInfo[17+nRSH];
  dbDivKoeff:=1.0;
  if (l_DivKoeff and $30)=$00 then dbDivKoeff:=1.0 else
  if (l_DivKoeff and $30)=$10 then dbDivKoeff:=10.0 else
  if (l_DivKoeff and $30)=$20 then dbDivKoeff:=100.0 else
  if (l_DivKoeff and $30)=$30 then dbDivKoeff:=1000.0;

  move(pMsg.m_sbyInfo[22+nRSH], l_DWData, 4);
  l_Data[0] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;

  for i:=0 to 3 do
  begin
    move(pMsg.m_sbyInfo[26 + i*4+nRSH], l_DWData, 4);
    l_Data[1 + i] := l_DWData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;
  end;

  for i:=0 to 4 do
  begin
    if (pMsg.m_sbyInfo[12+nRSH]=$06) then l_Data[i] := 0;
    FillSaveDataMessage(l_Data[i], QRY_NAK_EN_DAY_EP+LoByte(nReq.m_swSpecc1), i, true);
    FPUT(BOX_L3_BY, @m_nRxMsg);
  end;

  FinalAction();
end;


(*******************************************************************************
 * ReadEnergyOn30min
 * 0x26
 * ������ ����������� �������� ������� �� ���������  90 �����
 *   4 ����:
 *   1� ���� - ����;
 *   2� ���� - �����;
 *   3� ���� - ���;
 *   4� ���� - ����� ����� (1-6).
 *   ����� 6 ������ �� 8 ���������, ��. ������� 3.
 ******************************************************************************)
procedure   CMIRT1W2Meter.REQ26_ReadEnergyOn30min(var nReq: CQueryPrimitive);
var
  Year,Month,Day,nCell,j : WORD;
begin
  m_QFNC := $26;

  if (HiByte(nReq.m_swSpecc1)=0) then
  Begin
   DecodeDate(Now-(nReq.m_swSpecc2 and $00ff),Year,Month,Day);
   nReq.m_swSpecc0 := Year-2000;
   nReq.m_swSpecc1 := (Month shl 8)or LoByte(nReq.m_swSpecc1);
   nReq.m_swSpecc2 := nReq.m_swSpecc2 or Day;
  End;

  m_QTimestamp := EncodeDate(nReq.m_swSpecc0 + 2000, HiByte(nReq.m_swSpecc1), nReq.m_swSpecc2 and $00ff);

  m_nTxMsg.m_sbyInfo[13+nRSH] := LoByte(nReq.m_swSpecc1);
  m_nTxMsg.m_sbyInfo[14+nRSH] := BYTE(nReq.m_swSpecc2 and $00ff);
  m_nTxMsg.m_sbyInfo[15+nRSH] := HiByte(nReq.m_swSpecc1);
  m_nTxMsg.m_sbyInfo[16+nRSH] := nReq.m_swSpecc0;

  m_nTxMsg.m_sbyInfo[17+nRSH] := 10;
  m_nTxMsg.m_sbyInfo[18+nRSH] := BYTE(nReq.m_swSpecc2 shr 8);


  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, m_QFNC, 6));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;


(*******************************************************************************
 * 22 �����:
 *   1 ���� - ����;
 *   1 ���� - �����;
 *   1 ���� - ���;
 *   1 ���� - ����� ����� (1-6) , ��. ������� 3;
 *   1 ���� - ���������������� ����;
 *   1 ���� - ����������� �������;
 *   16 ���� - 8 ����������� �������� �� 2 ����� �� �������.
 ******************************************************************************)
 {
 procedure   CCE102Meter.RES0134_GetSresEnergy(var pMsg : CMessage);
var
  l_V    : Double;
  i : integer;
  l_t : DWORD;

  l_Y, l_M, l_D,
  l_hh, l_mm, l_ss, l_ms : WORD;
begin
  DecodeTime(Now(), l_hh, l_mm, l_ss, l_ms);
  DecodeDate(m_QTimestamp, l_Y, l_M, l_D);

    FillSaveDataMessage(0, 0, 0, false);
    m_nRxMsg.m_sbyDirID   := IsUpdate;
    m_nRxMsg.m_sbyServerID:= (m_Req.m_swSpecc2);
    m_nRxMsg.m_swLen      := 11 + 9 + sizeof(double);
    m_nRxMsg.m_sbyInfo[0] := 9 + sizeof(double);
    m_nRxMsg.m_sbyInfo[1] := QRY_SRES_ENR_EP;
    m_nRxMsg.m_sbyInfo[2] := l_Y-2000;
    m_nRxMsg.m_sbyInfo[3] := l_M;
    m_nRxMsg.m_sbyInfo[4] := l_D;
    m_nRxMsg.m_sbyInfo[5] := 0; // H
    m_nRxMsg.m_sbyInfo[6] := 0; // M
    m_nRxMsg.m_sbyInfo[7] := 0; // S
    m_nRxMsg.m_sbyInfo[8] := 0; // HH

    l_t := GetDATA3(pMsg.m_sbyInfo[9]);
    l_V := 0;
    if (l_t <> $00FFFFFF) then
      l_V :=  l_t / m_DotPosition * m_nP.m_sfKI * m_nP.m_sfKU
    else
      l_V :=  0;
      //m_nRxMsg.m_sbyServerID:= m_nRxMsg.m_sbyServerID or $80;

    move(l_V, m_nRxMsg.m_sbyInfo[9], sizeof(double));
    FPUT(BOX_L3_BY_BY, @m_nRxMsg);
    FinalAction();
end;
 }
procedure   CMIRT1W2Meter.RES26_ReadEnergyOn30min(var pMsg : CMessage);
var
  l_Data : Double;
  dbDivKoeff : Extended;
  l_WData : WORD;
  l_DivKoeff,
  l_Config : Byte;
  m_SresID,i : Integer;
begin
  if (HiByte(nReq.m_swSpecc1)=0) or (HiByte(nReq.m_swSpecc1)>12) then
  Begin
    FinalAction();
    exit;
  End;
  m_QTimestamp := EncodeDate(nReq.m_swSpecc0 + 2000, HiByte(nReq.m_swSpecc1), nReq.m_swSpecc2 and $00ff);
  m_SresID := BYTE(nReq.m_swSpecc2 shr 8);

  //l_Config := pMsg.m_sbyInfo[17];

  l_DivKoeff := pMsg.m_sbyInfo[19+nRSH];
  dbDivKoeff := 1.0;
  if (l_DivKoeff and $03)=$00 then dbDivKoeff:=1.0 else
  if (l_DivKoeff and $03)=$01 then dbDivKoeff:=10.0 else
  if (l_DivKoeff and $03)=$02 then dbDivKoeff:=100.0 else
  if (l_DivKoeff and $03)=$03 then dbDivKoeff:=1000.0;

  FillSaveDataMessage(0, 0, 0, false);
  m_nRxMsg.m_sbyDirID   := 1;
  m_nRxMsg.m_swLen      := 13 + 9 + sizeof(double);
  m_nRxMsg.m_sbyInfo[0] := 9 + sizeof(double);
  m_nRxMsg.m_sbyInfo[1] := QRY_SRES_ENR_EP+LoByte(nReq.m_swSpecc1);
  m_nRxMsg.m_sbyInfo[2] := BYTE(nReq.m_swSpecc0);
  m_nRxMsg.m_sbyInfo[3] := HiByte(nReq.m_swSpecc1);
  m_nRxMsg.m_sbyInfo[4] := BYTE(nReq.m_swSpecc2 and $00ff);
  m_nRxMsg.m_sbyInfo[5] := 0; // H
  m_nRxMsg.m_sbyInfo[6] := 0; // M
  m_nRxMsg.m_sbyInfo[7] := 0; // S
  m_nRxMsg.m_sbyInfo[8] := 0; // HH

  for i:=7 downto 0 do
  begin
   move(pMsg.m_sbyInfo[24 + i*2+nRSH], l_WData, 2);
   l_WData := l_WData and $3fff;
   m_nRxMsg.m_sbyServerID := 8*(m_SresID-1)+i;
   l_Data := l_WData / dbDivKoeff * m_nP.m_sfKI * m_nP.m_sfKU * m_nP.m_sfMeterKoeff;
   if (pMsg.m_sbyInfo[12+nRSH]=$06) then l_Data := 0;
   move(l_Data, m_nRxMsg.m_sbyInfo[9], sizeof(double));
   FPUT(BOX_L3_BY, @m_nRxMsg);
  end;
  FinalAction();
end;


(*******************************************************************************
 * ReadPower
	0x2D	������  ��������, ����������� �� �������� ���������
        0x2B
 ******************************************************************************)
procedure CMIRT1W2Meter.REQ2B_GetCurrentPower(var nReq: CQueryPrimitive);
begin
  m_QFNC       := $2B;
  m_QTimestamp := Now();

  //FillMessageBody(m_nTxMsg, $2D, 0);
   m_nTxMsg.m_sbyInfo[13+nRSH] := 0;
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, $2B, 1));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);
end;


(*******************************************************************************
 * �����
 5 ����:
3 ����� - �������� ��������;
1 ���� - ���������������� ����;
1 ���� - ����������� �������.
 *******************************************************************************)
procedure CMIRT1W2Meter.RES2B_GetCurrentPower(var pMsg:CMessage);
var
    l_ValueReactiv,l_ValueActiv,l_ValueChastota, l_ValueCosinus : Extended;
    l_tValueReactiv,l_tValueActiv, l_tValueChastota, l_tValueCosinus: DWORD;
    l_DivKoeff : Byte;
    dbDivKoeff : Extended;
    l_ValueU  : array[0..2] of double;
    l_ValueI  : array[0..2] of double;
    l_tValueU :  DWORD;
    l_tValueI :  DWORD;
    i:integer;
begin

  if (pMsg.m_sbyInfo[12+nRSH]=$06) then
  Begin
    FinalAction();
    exit;
  End;
 l_tValueReactiv  := 0;
 l_tValueActiv    := 0;
 l_tValueChastota :=0;
 l_tValueCosinus  :=0;
 move(pMsg.m_sbyInfo[18+nRSH], l_tValueActiv, 2); // ������� �������� �������� 2 Byte
 move(pMsg.m_sbyInfo[20+nRSH], l_tValueReactiv, 2); // ������� ���������� �������� 2 Byte
 move(pMsg.m_sbyInfo[22+nRSH], l_tValueChastota, 2); // ������� cos 2 Byte
 move(pMsg.m_sbyInfo[24+nRSH],l_tValueCosinus, 2); // ������� ������� 2 Byte

  for i:=0 to 2 do
  begin
    move(pMsg.m_sbyInfo[26 + i*2+nRSH], l_tValueU, 2);
    l_ValueU[i] := l_tValueU/100*m_nP.m_sfKU*m_nP.m_sfMeterKoeff;
    move(pMsg.m_sbyInfo[32 + i*2+nRSH], l_tValueI, 2);
    l_ValueI[i] := l_tValueI /1000*m_nP.m_sfKI*m_nP.m_sfMeterKoeff;
  end;

  dbDivKoeff:=1000;
  l_ValueActiv := l_tValueActiv/dbDivKoeff*m_nP.m_sfKI*m_nP.m_sfKU*m_nP.m_sfMeterKoeff;
  l_ValueReactiv := l_tValueReactiv/dbDivKoeff*m_nP.m_sfKI*m_nP.m_sfKU*m_nP.m_sfMeterKoeff;
  l_ValueChastota :=  l_tValueChastota/100;

  if (l_tValueCosinus and $8000)<>0 then
   l_ValueCosinus:=0-((l_tValueCosinus)/1000)
  else
   l_ValueCosinus:=l_tValueCosinus/1000;

  m_QTimestamp := Now();

  FillSaveDataMessage(l_ValueActiv, QRY_MGAKT_POW_S, 0, true);
  FPUT(BOX_L3_BY, @m_nRxMsg);

  FillSaveDataMessage(l_ValueReactiv, QRY_MGREA_POW_S, 0, true);
  FPUT(BOX_L3_BY, @m_nRxMsg);

  FillSaveDataMessage(l_ValueChastota, QRY_FREQ_NET, 0, true);
  FPUT(BOX_L3_BY, @m_nRxMsg);

  FillSaveDataMessage(l_ValueCosinus, QRY_KOEF_POW_A, 0, true);
  FPUT(BOX_L3_BY, @m_nRxMsg);

   for i:=0 to 2 do
   begin
    FillSaveDataMessage(l_ValueU[i], QRY_U_PARAM_A+i, 0, true);
    FPUT(BOX_L3_BY, @m_nRxMsg);

    FillSaveDataMessage(l_ValueI[i], QRY_I_PARAM_A+i, 0, true);
    FPUT(BOX_L3_BY, @m_nRxMsg);
   End;
   FinalAction();
end;


(******************************************************************************
 * ������ ������ �� �������
  2 �����:
    1� ���� - ��� ������� (��. ������� 6),
    ����� �� 0 �� 7;
    2� ���� - ����� ����� (����� 8 ������),
    ����� �� 0 �� 7.
 *)
procedure CMIRT1W2Meter.REQ2A_GetEvents(var nReq: CQueryPrimitive);
begin
  m_QFNC       := $2A;
  m_QTimestamp := Now();

  m_nTxMsg.m_sbyInfo[13+nRSH] := nReq.m_swSpecc0;
  m_nTxMsg.m_sbyInfo[14+nRSH] := nReq.m_swSpecc1;
  //FillMessageBody(m_nTxMsg, $2A, 2);
  FillMessageHead(m_nTxMsg, FillMessageBody(m_nTxMsg, $2A, 2));
  FPUT(BOX_L1, @m_nTxMsg);
  m_nRepTimer.OnTimer(m_nP.m_swRepTime);
  TraceM(2, m_nTxMsg.m_swObjID,'(__)CMIRW1::>Out DRQ:',@m_nTxMsg);

end;


(******************************************************************************
 * 31 ����:
  30 ���� -6 ������� ������� �� 5 ���� ������.
    ��������� ����� ������ ������� ��. � ������� 5.
    ����������� ����� ������� �������� ������������ � ������� 7.
  1 ���� - �������� ��� ������� � ����� ����� � ������� �������:XAAAXBBB, ���:
    AAA - ��� �������;
    BBB - ����� �����.
 *)
procedure CMIRT1W2Meter.RES2A_GetEvents(var pMsg:CMessage);
var
  l_EvCode,
  l_Y, l_M, l_D, l_hh, l_mm,l_ss,

  lt : WORD;
  i : Integer;
begin
  for i:=0 to 5 do
  begin
    l_Y := (pMsg.m_sbyInfo[13+i*5+nRSH] AND $FE) shr 3;
    l_M := ((pMsg.m_sbyInfo[13+i*5+nRSH] AND $01) shl 3) OR ((pMsg.m_sbyInfo[14+i*5+nRSH] AND $E0) shr 5);
    l_D := pMsg.m_sbyInfo[14+i*5+nRSH] AND $1F;

    l_hh := (pMsg.m_sbyInfo[15+i*5+nRSH] AND $F8) shr 3;
    l_mm := ((pMsg.m_sbyInfo[15+i*5+nRSH] AND $07) shl 3) OR ((pMsg.m_sbyInfo[16+i*5+nRSH] AND $E0) shr 5);
    l_ss := ((pMsg.m_sbyInfo[16+i*5+nRSH] AND $1F) shl 1) OR ((pMsg.m_sbyInfo[17+i*5+nRSH] AND $80) shr 7);

    l_EvCode := pMsg.m_sbyInfo[17+i*5+nRSH] AND $7F;



  end;


end;










(*******************************************************************************
 * ������������ ������� �� ���������� ��������� ������������ �������
 ******************************************************************************)
procedure CMIRT1W2Meter.ADD_Energy_Sum_GraphQry();
begin
  m_nObserver.ClearGraphQry();
  m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
  m_nObserver.AddGraphParam(QRY_ENERGY_SUM_EP, 0, 0, 0, 1);
end;


{*******************************************************************************
 * ������������ ������� �� ���������� �������
 ******************************************************************************}
procedure CMIRT1W2Meter.ADD_Events_GraphQry();
begin
  m_nObserver.ClearGraphQry();
  m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
  m_nObserver.AddGraphParam(QRY_JRNL_T3, 0, 0, 0, 1);
end;


{*******************************************************************************
 * ������������ ������� �� ���������� �������
 ******************************************************************************}
procedure CMIRT1W2Meter.ADD_DateTime_Qry();
begin
  m_nObserver.ClearGraphQry();
  m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
  m_nObserver.AddGraphParam(QRY_DATA_TIME, 0, 0, 0, 1);
end;

{*******************************************************************************
 * ������������ ������� �� ����������
 ******************************************************************************}
procedure CMIRT1W2Meter.ADD_NakEnergyMonth_Qry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;
    Year,Month,Day : Word;
begin
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
       if i < -23 then
         exit;
     end;
     cDateTimeR.IncMonth(TempDate);
     DecodeDate(TempDate,Year,Month,Day);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP,Year-2000,(Month shl 8)+0,1,1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP,Year-2000,(Month shl 8)+1,1,1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP,Year-2000,(Month shl 8)+2,1,1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_MONTH_EP,Year-2000,(Month shl 8)+3,1,1);
     cDateTimeR.DecMonth(dt_Date2);
   end;
end;
procedure CMIRT1W2Meter.ADD_NakEnergyDay_Qry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i           : integer;
    Year,Month,Day : Word;
begin
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
       if i < -40 then
         exit;
     end;
     cDateTimeR.IncDate(TempDate);
     DecodeDate(dt_Date1,Year,Month,Day);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, Year-2000,(Month shl 8)+0, Day, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, Year-2000,(Month shl 8)+1, Day, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, Year-2000,(Month shl 8)+2, Day, 1);
     m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, Year-2000,(Month shl 8)+3, Day, 1);
     cDateTimeR.DecDate(dt_Date2);
   end;
end;

procedure CMIRT1W2Meter.ADD_CurrPower_Qry(_DTS, _DTE : TDateTime);
begin
  m_nObserver.ClearGraphQry();
  m_nObserver.AddGraphParam(QRY_AUTORIZATION, 0, 0, 0, 1);
  m_nObserver.AddGraphParam(QRY_NAK_EN_DAY_EP, 0, 0, 0, 1);
end;


{*******************************************************************************
 * ������������ ������� �� ���������� ����������� ������
    @param DTS  TDateTime ������ �������
    @param DTE  TDateTime ��������� �������
 ******************************************************************************}
procedure CMIRT1W2Meter.ADD_SresEnergyDay_GraphQry(dt_Date1, dt_Date2 : TDateTime);
var TempDate    : TDateTime;
    i,j         : integer;
    Year,Month,Day : Word;
begin
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
       if i < -40 then
         exit;
     end;
     cDateTimeR.IncDate(TempDate);
     DecodeDate(dt_Date1,Year,Month,Day);
     for i:=0 to 4-1 do
     for j:=6 downto 0 do
     begin
       m_nObserver.AddGraphParam(QRY_SRES_ENR_EP, Year-2000, (Month shl 8)+i , Day or (j shl 8), 1);
     end;

     cDateTimeR.DecDate(dt_Date2);
   end;
end;

End.
