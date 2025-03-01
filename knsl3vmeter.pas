unit knsl3vmeter;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer,
knsl3vparam,utldatabase,knsl3observemodule,knsl5tracer,knsl3jointable;
type
    CVMeter = class;
    CVMeters = packed record
     Count    : Integer;
     Items    : array[0..MAX_VMETER] of CVMeter;
    end;
    PCVMeters =^ CVMeters;

    CVBalance = packed record
     Count    : Integer;
     Items    : array[0..30] of Integer;
    end;
    PCVBalance =^ CVBalance;

    CVMeter = class
    public
     m_nP       : PSL3VMETERTAG;
     m_nBalance : CVBalance;
     m_nHiJoin  : CVBalance;
    protected
     LastMask     : word;
     m_byRep      : Byte;
     m_nTxMsg     : CHMessage;
     //m_nPoiCVpoint
    public
     m_nVParam    : array[0..MAX_PARAM] of CVParam;
     constructor Create(pTbl:PSL3VMETERTAG);
     destructor Destroy;override;
    protected
     function SelfHandler(var pMsg:CMessage):Boolean;
     function LoHandler(var pMsg:CMessage):Boolean;
     function HiHandler(var pMsg:CMessage):Boolean;
     procedure SendMSG1(byBox,byFor,byType:Byte);
     procedure ChandgePrepareData(var pMsg:CMessage);
     procedure OnReLoadVParams;
     function FindTokenGR(var str:String;var pTN:CVToken):Boolean;
     function CheckValid:Boolean;
    public
     function GetDataTSL1(strV:String;var pDT:CVToken):Boolean;
     function GetDataTSL2(strV:String;var pDT:CVToken):Boolean;
     function GetInfo(strV:String;var pDT:CVToken):Boolean;
     procedure OnLoadVParams;
     function EventHandler(var pMsg:CMessage):Boolean;
     procedure Init(pTbl:PSL3VMETERTAG);
     //procedure ReadPhaseJrnl(var pMsg:CMessage);
     //procedure ReadStateJrnl(var pMsg:CMessage);
     //procedure ReadKorrJrnl(var pMsg:CMessage);
     procedure SaveKorrMonth(var pMsg:CMessage);
     procedure SaveLimKorr(var pMsg:CMessage);
     procedure ReadJrnl1_BTI(var pMsg:CMessage);
     procedure ReadJrnl2_BTI(var pMsg:CMessage);
     procedure ReadJrnl3_BTI(var pMsg:CMessage);
     procedure SaveJrnlEvents(var pMsg:CMessage);
     procedure SaveEventsDB(var pMsg:CMessage);
     procedure SaveMonitorToDB(var pMsg:CMessage);
     procedure SetLockState;
     procedure SetValidState(byVState:Byte);
     procedure ReSetLockState;
     function  FindJoin(nVMID:Integer):Boolean;
     function  FindJoinEx(nVMID,nCMDID:Integer):Boolean;
     procedure SetHiBalance(pJoin:PCJoinTable);
     procedure SetLoBalance(pJoin:PCJoinTable);
     //procedure SendHiMeter(var pMsg:CMessage);
     End;
    PCVMeter =^ CVMeter;
implementation
constructor CVMeter.Create(pTbl:PSL3VMETERTAG);
Begin
    TraceL(3,pTbl.m_swVMID,'(__)CL3MD::>CVMTR Create : '+IntToStr(pTbl.m_swVMID));
    LastMask := 0;
    m_nP := pTbl;
    OnLoadVParams;
End;
destructor CVMeter.Destroy;
Var
    i    : Integer;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    inherited;
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     pVP.Destroy;
    End;
End;
procedure CVMeter.Init(pTbl:PSL3VMETERTAG);
Var
    pDS : CMessageData;
Begin
    LastMask := 0;
    m_nP := pTbl;
    //if m_nP.m_swVMID=83 then
    // LastMask := 0;
    {
    if m_nLockMeter=1 then
    Begin
     if m_nP.m_sbyEnable=1 then
     Begin
      ReSetLockState;
      pDS.m_swData0 := PR_TRUE;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
      m_pDB.UpdateBlStateMeter(m_nP.m_swMID, ST_L2_NO_AUTO_BLOCK);
     End else
     if m_nP.m_sbyEnable=0 then
     Begin
      SetLockState;
      pDS.m_swData0 := PR_FAIL;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
      m_pDB.UpdateBlStateMeter(m_nP.m_swMID, ST_L2_AUTO_BLOCK);
     End;
    End;
    }
    OnLoadVParams;
End;
procedure CVMeter.OnReLoadVParams;
Begin
    if m_pDB.GetVMeterTable(m_nP^)=True then
    OnLoadVParams;
End;
function CVMeter.FindTokenGR(var str:String;var pTN:CVToken):Boolean;
Var
     res : Boolean;
     sV  : String;
     i,j : Integer;
Begin
     Result := False;
      //Find VMID
     i := Pos('v',str)+1;
     if i=1 then exit;
     if i>2 then Begin Delete(str,1,i-2);i:=Pos('v',str)+1;End;
     j := Pos('_',str);
     if j<=i then Begin pTN.blError:=True;exit;End;
     sV := Copy(str,i,j-i);
     Delete(str,1,(j+2)-i);
     pTN.nVMID := StrToInt(sV);
     Result := True;
End;

function CVMeter.GetDataTSL1(strV:String;var pDT:CVToken):Boolean;
Var
    i : Integer;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     if pVP.m_nP.m_sParam=strV then
     Begin
      if(pVP.GetDataTSL1(pDT))=True then
      Result := True;
      exit;
     End;
    End;
    pDT.fValue := 0;
    Result := False;
End;
function CVMeter.GetDataTSL2(strV:String;var pDT:CVToken):Boolean;
Var
    i : Integer;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     if pVP.m_nP.m_sParam=strV then
     Begin
      if(pVP.GetDataTSL2(pDT))=True then
      Result := True;
      exit;
     End;
    End;
    pDT.fValue := 0;
    Result := False;
End;
function CVMeter.GetInfo(strV:String;var pDT:CVToken):Boolean;
Var
    i : Integer;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     if pVP.m_nP.m_sParam=strV then
     Begin
      if(pVP.GetInfo(pDT))=True then
      Result := True;
      exit;
     End;
    End;
    Result := False;
End;
function  CVMeter.FindJoin(nVMID:Integer):Boolean;
Var
    i    : Integer;
    strV : String;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     strV := 'v'+IntToStr(nVMID)+'_';
     if pos(strV,m_nP.Item.Items[i].m_sParamExpress)<>0 then
     Begin
      Result := True;
      exit;
     End;
    End;
    Result := False;
End;
function  CVMeter.FindJoinEx(nVMID,nCMDID:Integer):Boolean;
Var
    i    : Integer;
    strV : String;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     strV := 'v'+IntToStr(nVMID)+'_';
     if (pos(strV,m_nP.Item.Items[i].m_sParamExpress)<>0)and(pVPT.m_swParamID=nCMDID) then
     Begin
      Result := True;
      exit;
     End;
    End;
    Result := False;
End;
procedure CVMeter.OnLoadVParams;
Var
    i : Integer;
    pVP  : PCVParam;
    pVPT : PSL3PARAMS;
Begin
    for i:=0 to m_nP.m_swAmParams-1 do
    Begin
     pVPT := @m_nP.Item.Items[i];
     pVP  := @m_nVParam[pVPT.m_swParamID];
     pVPT.m_sbyRecursive := 0;
     //pVPT.m_sParam := 'v'+IntToStr(m_nP.m_swVMID)+'_'+pVPT.m_sParam;
     if pVP^=Nil then pVP^ := CVParam.Create(pVPT^);
     pVP.m_byPLID := m_nP.m_swPLID;
     pVP.Init(pVPT^);
    End;
End;
{
procedure CVMeter.ReadPhaseJrnl(var pMsg:CMessage);
var Mask : WORD;
    Date : TDateTime;
    XorLM: WORD;
begin
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
       m_pDB.FixMeterEvent(2, EVM_INCL_PH_A, m_nP.m_swVMID, 0, Date)
     else
       m_pDB.FixMeterEvent(2, EVM_EXCL_PH_A, m_nP.m_swVMID, 0, Date);
   if (XorLM and $02) = $02 then
     if (Mask and $02) <> 0 then
       m_pDB.FixMeterEvent(2, EVM_INCL_PH_B, m_nP.m_swVMID, 0, Date)
     else
       m_pDB.FixMeterEvent(2, EVM_EXCL_PH_B, m_nP.m_swVMID, 0, Date);
   if (XorLM and $04) = $04 then
     if (Mask and $04) <> 0 then
       m_pDB.FixMeterEvent(2, EVM_INCL_PH_C, m_nP.m_swVMID, 0, Date)
     else
       m_pDB.FixMeterEvent(2, EVM_EXCL_PH_C, m_nP.m_swVMID, 0, Date);
   LastMask := Mask;
end;

procedure CVMeter.ReadStateJrnl(var pMsg:CMessage);
var Mask : WORD;
    Date : TDateTime;
begin
   if (pMsg.m_sbyInfo[2] = 0) or (pMsg.m_sbyInfo[3] = 0) or (pMsg.m_sbyInfo[4] = 0) then
     exit;  //�������� ����
   Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
           EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   Mask := pMsg.m_sbyInfo[9]  + pMsg.m_sbyInfo[10] shl 8;
   if pMsg.m_sbyInfo[8] <> 0 then
   begin
     if (Mask and $0002) = $0002 then
       m_pDB.FixMeterEvent(2, EVM_ERR_REAL_CLOCK, m_nP.m_swVMID, 0, Date);
     if (Mask and $0008) = $0008 then
       m_pDB.FixMeterEvent(2, EVM_ERR_KAL, m_nP.m_swVMID, 0, Date);
     if (Mask and $0010) = $0010 then
       m_pDB.FixMeterEvent(2, EVM_NOIZE, m_nP.m_swVMID, 0, Date);
     if ((Mask and $0100) = $0100) or ((Mask and $0200) = $0200) then
       m_pDB.FixMeterEvent(2, EVM_ERR_DSP, m_nP.m_swVMID, 0, Date);
     if ((Mask and $0800) = $0800) or ((Mask and $1000) = $1000) then
       m_pDB.FixMeterEvent(2, EVM_ERR_RAM, m_nP.m_swVMID, 0, Date);
     if ((Mask and $4000) = $4000) or ((Mask and $8000) = $8000) then
       m_pDB.FixMeterEvent(2, EVM_ERR_RAM, m_nP.m_swVMID, 0, Date);
   end
   else
   begin
     if (Mask and $0100) = $0100 then
       m_pDB.FixMeterEvent(0, 10, 0, 0, Date);
     if (Mask and $0200) = $0200 then
       m_pDB.FixMeterEvent(0, 11, 0, 0, Date);
     if (Mask and $0400) = $0400 then
       m_pDB.FixMeterEvent(0, 1, 0, 0, Date);
     if (Mask and $0800) = $0800 then
       m_pDB.FixMeterEvent(0, 23, 0, 0, Date);
     if (Mask and $1000) = $1000 then
       m_pDB.FixMeterEvent(0, 24, 0, 0, Date);
     if (Mask and $2000) = $2000 then
       m_pDB.FixMeterEvent(0, 93, 0, 0, Date);
     if (Mask and $4000) = $4000 then
       m_pDB.FixMeterEvent(0, 94, 0, 0, Date);
     if (Mask and $8000) = $8000 then
       m_pDB.FixMeterEvent(0, 7, 0, 0, Date);
   end;
end;

procedure CVMeter.ReadKorrJrnl(var pMsg:CMessage);
var Mask    : WORD;
    Date    : TDateTime;
    yto     : byte;
    f_Temp  : Double;
    pDS     : CMessageData;
begin
   if (pMsg.m_sbyInfo[2] = 0) or (pMsg.m_sbyInfo[3] = 0) or (pMsg.m_sbyInfo[4] = 0) then
     exit;  //�������� ����
   Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
           EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   Mask := pMsg.m_sbyInfo[9]  + pMsg.m_sbyInfo[10] shl 8;
   yto  := pMsg.m_sbyInfo[11];
   if (Mask and $0001) = $0001 then
     m_pDB.FixMeterEvent(2, EVM_OPN_COVER, m_nP.m_swVMID, 0, Date);
   if (Mask and $0002) = $0002 then
     m_pDB.FixMeterEvent(2, EVM_CLS_COVER, m_nP.m_swVMID, 0, Date);
   if (Mask and $0004) = $0004 then
     m_pDB.FixMeterEvent(2, EVM_CORR_BUTN, m_nP.m_swVMID, 0, Date);
   if (Mask and $0008) = $0008 then
     m_pDB.FixMeterEvent(2, EVM_CORR_INTER, m_nP.m_swVMID, 0, Date);
   if (Mask = $4000) and (yto = 10) then
   begin
     move(pMsg.m_sbyInfo[12], f_temp, sizeof(Double));
     m_pDB.FixMeterEvent(2, EVM_START_CORR, m_nP.m_swVMID, f_temp, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 11) then
   begin
     move(pMsg.m_sbyInfo[12], f_temp, sizeof(Double));
     m_pDB.FixMeterEvent(2, EVM_FINISH_CORR, m_nP.m_swVMID, f_temp, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 12) then
   begin
     m_pDB.FixMeterEvent(2, EVM_ERROR_CORR, m_nP.m_swVMID, 0, Date);
     exit;
   end;
   if (Mask = $4000) and (yto = 13) then
   begin
     m_pDB.FixMeterEvent(1, EVA_METER_NO_ANSWER, m_nP.m_swVMID, 0, Date);
     if m_nLockMeter=1 then
     Begin
      SetLockState;
      pDS.m_swData0 := PR_FAIL;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
     exit;
   end;
   if (Mask = $4000) and (yto = 14) then
   begin
     m_pDB.FixMeterEvent(1, EVA_METER_ANSWER, m_nP.m_swVMID, 0, Date);
     if m_nLockMeter=1 then
     Begin
      ReSetLockState;
      pDS.m_swData0 := PR_TRUE;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
     exit;
   end;
   if (Mask and $0010) = $0010 then
     m_pDB.FixMeterEvent(2, EVM_CHG_TARIFF, m_nP.m_swVMID, 0, Date);
   if (Mask and $0020) = $0020 then
     m_pDB.FixMeterEvent(2, EVM_CHG_FREEDAY, m_nP.m_swVMID, 0, Date);
   if (Mask and $0040) = $0040 then
     m_pDB.FixMeterEvent(2, EVM_CHG_CONST, m_nP.m_swVMID, 0, Date);
   if (Mask and $0080) = $0080 then
     if (yto and $20) = $20 then
       m_pDB.FixMeterEvent(2, EVM_CHG_SPEED, m_nP.m_swVMID, 0, Date)
     else
       m_pDB.FixMeterEvent(2, EVM_CHG_CONST, m_nP.m_swVMID, 0, Date);
   if (Mask and $0100) = $0100 then
     m_pDB.FixMeterEvent(2, EVM_CHG_PAR_TELEM, m_nP.m_swVMID, 0, Date);
   if (Mask and $0200) = $0200 then
     m_pDB.FixMeterEvent(2, EVM_CHG_MODE_IZM,  m_nP.m_swVMID, 0, Date);
   if (Mask and $0400) = $0400 then
     m_pDB.FixMeterEvent(2, EVM_CHG_PASSW, m_nP.m_swVMID, 0, Date);
   if (Mask and $0800) = $0800 then
     m_pDB.FixMeterEvent(2, EVM_RES_ENERG, m_nP.m_swVMID, 0, Date);
   if (Mask and $1000) = $1000 then
     m_pDB.FixMeterEvent(2, EVM_RES_MAX_POW, m_nP.m_swVMID, 0, Date);
   if (Mask and $2000) = $2000 then
     m_pDB.FixMeterEvent(2, EVM_RES_SLICE, m_nP.m_swVMID, 0, Date);
end;
}
{
  QRY_ENERGY_DAY_EP     = 5;//2
  QRY_ENERGY_DAY_EM     = 6;
  QRY_ENERGY_DAY_RP     = 7;
  QRY_ENERGY_DAY_RM     = 8;
  QRY_ENERGY_MON_EP     = 9;//3
  QRY_ENERGY_MON_EM     = 10;
  QRY_ENERGY_MON_RP     = 11;
  QRY_ENERGY_MON_RM     = 12;
  QRY_SRES_ENR_EP       = 13;//36
  QRY_SRES_ENR_EM       = 14;
  QRY_SRES_ENR_RP       = 15;
  QRY_SRES_ENR_RM       = 16;
}

//AutoBlock_VMeter
procedure CVMeter.SetValidState(byVState:Byte);
Var
   i    : Integer;
   pVPT : PSL3PARAMS;
Begin
   for i:=0 to m_nP.m_swAmParams-1 do
   Begin
    pVPT := @m_nP.Item.Items[i];
    if m_nVParam[pVPT.m_swParamID]<>Nil then
    if (pVPT.m_swParamID>=QRY_ENERGY_DAY_EP) and (pVPT.m_swParamID<=QRY_SRES_ENR_RM) then
    Begin
     pVPT.m_sbyLockState := byVState;
     m_nVParam[pVPT.m_swParamID].m_nP.m_sbyLockState := byVState;
    End;
   End;
End;
procedure CVMeter.SetLockState;
Begin
   TraceL(3, 0, '('+IntToStr(m_nP.m_swVMID)+')'+'CL3MD::>CVMTR:���������� ��������! '+m_nP.m_sVMeterName);
   m_pDB.AutoBlock_VMeter(m_nP.m_swVMID);
   SetValidState(PR_FAIL);
End;
procedure CVMeter.ReSetLockState;
Var
   res : Boolean;
Begin
   res := True;
   TraceL(3, 0, '('+IntToStr(m_nP.m_swVMID)+')'+'CL3MD::>CVMTR:������������� ��������... '+m_nP.m_sVMeterName);
   if (m_nP.m_sbyType=MET_SUMM) or (m_nP.m_sbyType=MET_GSUMM) then res := CheckValid;
   if res=True then
   Begin
    TraceL(3, 0, '('+IntToStr(m_nP.m_swVMID)+')'+'CL3MD::>CVMTR:C������ �������������! '+m_nP.m_sVMeterName);
    m_pDB.AutoUnBlock_VMeter(m_nP.m_swVMID);
    SetValidState(PR_TRUE);
   End;
End;
function CVMeter.CheckValid:Boolean;
Var
   strMeters : String;
   i         : Integer;
Begin
   if m_nBalance.Count=0 then Begin Result:=False;exit;End;
   strMeters := '('+IntToStr(m_nBalance.Items[0]);
    for i:=1 to m_nBalance.Count-1 do
    strMeters := strMeters+','+IntToStr(m_nBalance.Items[i]);
   strMeters := strMeters+')';
   Result := m_pDB.CheckValidMeters(strMeters);
End;
{
procedure CVMeter.ReSetLockState;
Var
   i    : Integer;
   pVPT : PSL3PARAMS;
   pDS  : CMessageData;
   res  : Boolean;
Begin
   res := False;
   pDS.m_swData0 := PR_TRUE;
   for i:=0 to m_nP.m_swAmParams-1 do
   Begin
    pVPT := @m_nP.Item.Items[i];
    if m_nVParam[pVPT.m_swParamID]<>Nil then
    if (pVPT.m_swParamID>=QRY_ENERGY_DAY_EP) and (pVPT.m_swParamID<=QRY_SRES_ENR_RM) then
    Begin
     m_nVParam[pVPT.m_swParamID].m_nP.m_sbyLockState := PR_TRUE;
     m_pDB.UpdateLockStParam(m_nP.m_swVMID,pVPT.m_swParamID,PR_TRUE);
     res := True;
    End;
   End;
   if res=True then
   SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
End;
}
procedure CVMeter.SaveKorrMonth(var pMsg:CMessage);
var Value : WORD;
begin
   move(pMsg.m_sbyInfo[9], Value, 2);
   TraceL(3, 0, '(__)CL3MD::>CVMTR: EVT: ��������� ����� ��������� = ' + IntToStr(Value));
//   m_pDB.FixUSPDCorrMonth(Value, Now);
end;

procedure CVMeter.SaveLimKorr(var pMsg:CMessage);
begin
//   m_pDB.FixMeterEvent(2, EVM_ERR_KORR, m_nP.m_swVMID,  0,Now);
   TraceL(3, 0, '(__)CL3MD::>CVMTR: EVT: ����� �� ������� ���������');
end;

procedure CVMeter.ReadJrnl1_BTI(var pMsg:CMessage);
var Date : TDateTime;
begin
   if (pMsg.m_sbyInfo[3] <> 0) and (pMsg.m_sbyInfo[4] <> 0) then
   begin
     Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
             EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
//     m_pDB.FixMeterEvent(pMsg.m_sbyInfo[8] - 1, pMsg.m_sbyInfo[9], 0, pMsg.m_sbyInfo[12]*$100 + pMsg.m_sbyInfo[13], Date);
   end;
end;

procedure CVMeter.ReadJrnl2_BTI(var pMsg:CMessage);
var Date : TDateTime;
begin
   if (pMsg.m_sbyInfo[3] <> 0) and (pMsg.m_sbyInfo[4] <> 0) then
   begin
     Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
             EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
//     m_pDB.FixMeterEvent(pMsg.m_sbyInfo[8] - 1, pMsg.m_sbyInfo[9], m_nP.m_swVMID, pMsg.m_sbyInfo[12]*$100 + pMsg.m_sbyInfo[13], Date);
   end;
end;

procedure CVMeter.ReadJrnl3_BTI(var pMsg:CMessage);
var Date : TDateTime;
begin
   if (pMsg.m_sbyInfo[3] <> 0) and (pMsg.m_sbyInfo[4] <> 0) then
   begin
     Date := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
             EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
//     m_pDB.FixMeterEvent(pMsg.m_sbyInfo[8] - 1, pMsg.m_sbyInfo[9], m_nP.m_swVMID, pMsg.m_sbyInfo[12]*$100 + pMsg.m_sbyInfo[13], Date);
   end;
end;
{
procedure CSS301F3Meter.SendL3Event(byType:Byte;byJrnType:Byte;wEvType:Word;nMID:Word;nPrm:Double;dtDate:TDateTime);
Var
   pMsg : CHMessage;
Begin
   pMsg.m_swLen      := 13+30;
   pMsg.m_swObjID    := nMID;
   pMsg.m_sbyType    := PH_EVENTS_INT;
   pMsg.m_sbyFor     := DIR_L2TOL3;
   pMsg.m_sbyFrom    := byJrnType;
   pMsg.m_sbyInfo[1] := byType;
   Move(wEvType,pMsg.m_sbyInfo[2],sizeof(Word));
   Move(nPrm,pMsg.m_sbyInfo[4],sizeof(Double));
   Move(dtDate,pMsg.m_sbyInfo[12],sizeof(TDateTime));
   FPUT(BOX_L3_BY,@pMsg);
End;
SendL3Event(2, EVM_CHG_MODE_IZM,  m_nP.m_swVMID, 0, Date);
}

procedure CVMeter.SaveEventsDB(var pMsg:CMessage);
Var
   wEvType : Word;
   nPrm    : Double;
   Date    : TDateTime;
   byJrnType,byJrn : Byte;
   pDS     : CMessageData;
Begin
   byJrnType := pMsg.m_sbyFrom;
   Move(pMsg.m_sbyInfo[2],wEvType,sizeof(Word));
   Move(pMsg.m_sbyInfo[4],nPrm,sizeof(Double));
   Move(pMsg.m_sbyInfo[12],Date,sizeof(TDateTime));
//   m_pDB.FixMeterEvent(byJrnType, wEvType, m_nP.m_swVMID, nPrm, Date);
   if (byJrnType=1)and(wEvType=EVA_METER_NO_ANSWER) then
   Begin
     if m_nLockMeter=1 then
     Begin
      SetLockState;
      //SendHiMeter(pMsg);
      pDS.m_swData0 := PR_FAIL;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
   End;
   if (byJrnType=1)and(wEvType=EVA_METER_ANSWER) then
   Begin
     if m_nLockMeter=1 then
     Begin
      ReSetLockState;
      //SendHiMeter(pMsg);
      pDS.m_swData0 := PR_TRUE;
      SendMsgData(BOX_L3,m_nP.m_swVMID,DIR_L4TOL3,AL_FINDJOIN_IND,pDS);
     End;
   End;
End;
procedure CVMeter.SetHiBalance(pJoin:PCJoinTable);
Var
   i : Integer;
Begin
   m_nHiJoin.Count := pJoin.m_pQSMD.Count;
   for i:=0 to pJoin.m_pQSMD.Count-1 do
   m_nHiJoin.Items[i] := pJoin.m_pQSMD.Items[i];
End;
procedure CVMeter.SetLoBalance(pJoin:PCJoinTable);
Var
   i : Integer;
Begin
   m_nBalance.Count := pJoin.m_pQSMD.Count;
   for i:=0 to pJoin.m_pQSMD.Count-1 do
   m_nBalance.Items[i] := pJoin.m_pQSMD.Items[i];
End;
procedure CVMeter.SaveJrnlEvents(var pMsg:CMessage);
begin
   if pMsg.m_sbyServerID <> DEV_BTI_SRV then
   begin
     case pMsg.m_sbyInfo[1] of
       QRY_JRNL_T1,
       QRY_JRNL_T2,
       QRY_JRNL_T3        : SaveEventsDB(pMsg);//ReadKorrJrnl(pMsg);
       QRY_SUM_KORR_MONTH : SaveKorrMonth(pMsg);
       QRY_LIM_TIME_KORR  : SaveLimKorr(pMsg);
     end;
   end
   else
   begin
      case pMsg.m_sbyInfo[1] of
       QRY_JRNL_T1,
       QRY_JRNL_T4 : ReadJrnl1_BTI(pMsg);
       QRY_JRNL_T2 : ReadJrnl2_BTI(pMsg);
       QRY_JRNL_T3 : ReadJrnl3_BTI(pMsg);
     end;
   end;
end;

procedure CVMeter.SaveMonitorToDB(var pMsg:CMessage);
var pTable:SMONITORDATA;
begin
   pTable.m_swVMID  := m_nP.m_swVMID;
   pTable.m_nCount  := 1;
   pTable.m_nSize   := 1;
   pTable.m_nPeriod := 60;
   pTable.CmdID     := pMsg.m_sbyInfo[1];
   pTable.m_dtDate  := EncodeDate(pMsg.m_sbyInfo[2] + 2000, pMsg.m_sbyInfo[3], pMsg.m_sbyInfo[4]) +
                       EncodeTime(pMsg.m_sbyInfo[5], pMsg.m_sbyInfo[6], pMsg.m_sbyInfo[7], 0);
   pTable.m_nData    := TMemoryStream.Create;
   pTable.m_nData.LoadFromFile(m_strExePath+'arch.rar');
   m_pDB.AddMonTable(pTable);
   pTable.m_nData.Free;
   pTable.m_nData := nil;
end;

function  CVMeter.EventHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    case pMsg.m_sbyFor of
     DIR_L2TOL3: res := LoHandler(pMsg);
     DIR_L3TOL3: res := SelfHandler(pMsg);
     DIR_L4TOL3: res := HiHandler(pMsg);
    End;
    Result := res;
End;
function CVMeter.SelfHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := True;

    Result := res;
End;
function CVMeter.LoHandler(var pMsg:CMessage):Boolean;
Var
    res  : Boolean;
    nCID : Integer;
Begin
    res := True;
    case pMsg.m_sbyType of
      PH_EVENTS_INT : SaveJrnlEvents(pMsg);
      DL_DATARD_IND :
       begin
          nCID := pMsg.m_sbyInfo[1];
          //TraceL(3,m_nP.m_swVMID,'(__)CL3MD::>CVMTR COMM:'+m_nCommandList.Strings[nCID]);
          //TraceM(3,m_nP.m_swVMID,'(__)CL3MD::>CVMTR INCMD:'+IntToStr(nCID)+' Msg: ',@pMsg);
          if nCID<=MAX_PARAM then
          if m_nVParam[nCID]<>Nil then
          Begin
           ChandgePrepareData(pMsg);
           m_nVParam[nCID].EventHandler(pMsg);
          End;
       end;
       PH_MON_ANS_IND : SaveMonitorToDB(pMsg);
    end;
    Result := res;
End;
function CVMeter.HiHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := True;

    Result := res;
End;
{
SL3CHANDGE = packed record
     m_swID      : Integer;
     m_swVMID    : Integer;
     m_swCHID    : Integer;
     m_dtTime    : TDateTime;
     m_sComment  : String[100];
     m_sfKU_0    : Double;
     m_sfKI_0    : Double;
     m_sfKU_1    : Double;
     m_sfKI_1    : Double;
     m_sbyEnable : Byte;
     Item        : SL3CHANDTS;
    End;
SL3CHANDT = packed record
     m_swID      : Integer;
     m_swCHID    : Integer;
     m_swCMDID   : Word;
     m_swTID     : Word;
     m_sTime     : TDateTime;
     m_sfWP0     : Extended;
     m_sfWM0     : Extended;
     m_sfQP0     : Extended;
     m_sfQM0     : Extended;
     m_sfWP1     : Extended;
     m_sfWM1     : Extended;
     m_sfQP1     : Extended;
     m_sfQM1     : Extended;
     m_sfDWP     : Extended;
     m_sfDWM     : Extended;
     m_sfDQP     : Extended;
     m_sfDQM     : Extended;
    End;
}
procedure CVMeter.ChandgePrepareData(var pMsg:CMessage);
Var
    nCID,nTID,nIND:Integer;
    fValue0  : Double;
    fValue1,fValue2,dfValue,KI,KU : Extended;
Begin
    if (m_nP.ItemCh.Count=1)then
    Begin
     if (m_nP.ItemCh.Items[0].m_sbyEnable=1) then
     Begin
     nCID := pMsg.m_sbyInfo[1]; nTID := pMsg.m_sbyInfo[8];
     if ((nCID>=QRY_NAK_EN_DAY_EP)and(nCID<=QRY_NAK_EN_YEAR_RM))or
        ((nCID>=QRY_ENERGY_SUM_EP)and(nCID<=QRY_ENERGY_SUM_RM))then
     Begin
     KU := m_nP.ItemCh.Items[0].m_sfKU_1;
     KI := m_nP.ItemCh.Items[0].m_sfKI_1;
     Move(pMsg.m_sbyInfo[9],fValue0,sizeof(fValue0));
     fValue1 := fValue0;
     with m_nP.ItemCh.Items[0].Item do
     Begin
      if (nCID>=QRY_ENERGY_SUM_EP)and(nCID<=QRY_ENERGY_SUM_RM) then
       Begin
       nIND := 0*MAX_TARIFF+nTID;  if nIND>Count then exit;
       if nCID=QRY_ENERGY_SUM_EP   then dfValue := Items[nIND].m_sfDWP;
       if nCID=QRY_ENERGY_SUM_EM   then dfValue := Items[nIND].m_sfDWM;
       if nCID=QRY_ENERGY_SUM_RP   then dfValue := Items[nIND].m_sfDQP;
       if nCID=QRY_ENERGY_SUM_RM   then dfValue := Items[nIND].m_sfDQM;
      End else
      if (nCID>=QRY_NAK_EN_DAY_EP)and(nCID<=QRY_NAK_EN_DAY_RM) then
       Begin
       nIND := 1*MAX_TARIFF+nTID;  if nIND>Count then exit;
       if nCID=QRY_NAK_EN_DAY_EP   then dfValue := Items[nIND].m_sfDWP;
       if nCID=QRY_NAK_EN_DAY_EM   then dfValue := Items[nIND].m_sfDWM;
       if nCID=QRY_NAK_EN_DAY_RP   then dfValue := Items[nIND].m_sfDQP;
       if nCID=QRY_NAK_EN_DAY_RM   then dfValue := Items[nIND].m_sfDQM;
      End else
      if (nCID>=QRY_NAK_EN_MONTH_EP)and(nCID<=QRY_NAK_EN_MONTH_RM) then
      Begin
       nIND := 2*MAX_TARIFF+nTID;  if nIND>Count then exit;
       if nCID=QRY_NAK_EN_MONTH_EP then dfValue := Items[nIND].m_sfDWP;
       if nCID=QRY_NAK_EN_MONTH_EM then dfValue := Items[nIND].m_sfDWM;
       if nCID=QRY_NAK_EN_MONTH_RP then dfValue := Items[nIND].m_sfDQP;
       if nCID=QRY_NAK_EN_MONTH_RM then dfValue := Items[nIND].m_sfDQM;
      End else
      if (nCID>=QRY_NAK_EN_YEAR_EP)and(nCID<=QRY_NAK_EN_YEAR_RM) then
      Begin
       nIND := 3*MAX_TARIFF+nTID;  if nIND>Count then exit;
       if nCID=QRY_NAK_EN_YEAR_EP  then dfValue := Items[nIND].m_sfDWP;
       if nCID=QRY_NAK_EN_YEAR_EM  then dfValue := Items[nIND].m_sfDWM;
       if nCID=QRY_NAK_EN_YEAR_RP  then dfValue := Items[nIND].m_sfDQP;
       if nCID=QRY_NAK_EN_YEAR_RM  then dfValue := Items[nIND].m_sfDQM;
      End;
     End;
     //fValue2 := RVLPr(fValue1/(KU*KI),3);
     //fValue0 := fValue2*1;
     //fValue0 := RVLPr(fValue1 + dfValue*KU*KI,3);
     fValue1 := fValue1 + dfValue*KU*KI;
     fValue0 := fValue1;
     Move(fValue0,pMsg.m_sbyInfo[9],sizeof(fValue0));
     End;
     End;
    End;
End;
procedure CVMeter.SendMSG1(byBox,byFor,byType:Byte);
Var
    pMsg : CHMessage;
Begin
    With pMsg do
    Begin
     m_swLen       := 11;
     m_swObjID     := m_nP.m_swMID;
     m_sbyFrom     := byFor;
     m_sbyFor      := byFor;
     m_sbyType     := byType;
     m_sbyTypeIntID:= 0;
     m_sbyIntID    := 0;
     m_sbyServerID := 0;
     m_sbyDirID    := 0;
     end;
    FPUT(byBox,@pMsg);
End;
end.
