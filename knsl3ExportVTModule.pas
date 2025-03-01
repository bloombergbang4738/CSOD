{*******************************************************************************
 *    ������� ������ � ���� ���� dBase
 *      ��� �������� �����������
 *
 *
 *    ������������ ������ �� ���� ����������, ���������� �������� �����,
 * ������ ����� ������������� �������.
 *
 *    ����������� ������� � ��������� ������ (��� ���������) ����� ����������
 * ������������ �����.
 *    ����������� ���� ����������� �������������� � ������
 * (��������: - AGATGGMM.dbf, ��� GG-2 ��������� ����� ����, �� - ����� ��
 * 1 ����� �������� ����������� ������.
 *
 *    ��� ���� �������� ������������ �� ������ ����������� ��������� SPRSCHET.dbf,
 * � ��� ���������� ������ �������� � ���,  ������� ��� �� ����������� �����
 * ��������� - SPRTPSC.dbf. ��� ������������ ����������� ������� �� Ctrl+C  - Ctrl+V.
 ******************************************************************************}

unit knsl3ExportVTModule;

interface
uses
    Windows, SysUtils, Forms, ShellAPI, Classes,
    knsl5tracer,inifiles,knsl3EventBox,utldynconnect,
    utltypes, utlbox, utlconst, utldatabase, utltimedate, db, dbtables,paramchklist,stdctrls,comctrls,knsl2qwerytmr;

type
  CL3ExportVTModule = class(CTimeMDL)
  private
   // m_pExportDBF    : SL3ExportDBFS;
    m_pExportVit    : SL3ExportVitebsk;
   // m_pExportMOGB   : SL3ExportMOGBS;
    m_QTable        : TTable;
    m_pGenSett      : PSGENSETTTAG;
    m_sTblL1        : SL1INITITAG;
    m_dtLast        : TDateTime; // ��������� �����
    m_nAbonentsCount: Integer;
    m_pAbonents     : array of SABON;  // ��������� ��� �������� �������
    m_boIsMaked     : Boolean;
    m_pAbonTable    : SL3ABONSNAMES;
    clm_strVTAbons    : TParamCheckList;
    em_strVTPath      : TEdit;
    em_strVTPath1     : TEdit;
    clm_swVTDayMask   : TParamCheckList;
    clm_sdwVTMonthMask: TParamCheckList;
    dtm_sdtVTBegin    : TDateTimePicker;
    dtm_sdtVTEnd      : TDateTimePicker;
    dtm_sdtVTPeriod   : TDateTimePicker;
    chm_swVTDayMask   : TCheckBox;
    chm_sdwVTMonthMask: TCheckBox;
    chm_sbyVTEnable   : TCheckBox;
    cbm_snVTDeepFind  : TComboBox;
    cbm_nVTUnlPower   : TCheckBox;
    cbm_nVTMaxUtro      : TCheckBox;
    cbm_nVTMaxVech    : TCheckBox;
    cbm_nVTMaxDay     : TCheckBox;
    cbm_nVTMaxNoch    : TCheckBox;
    cbm_nVTMaxTar     : TCheckBox;
    cbm_nVTExpTret    : TCheckBox;

    m_strAbons      : String;
    m_strPath       : String;
    m_strPath1      : String;

    m_nUnlPower     : Byte;
    m_nMaxUtro      : Byte;
    m_nMaxVech      : Byte;
    m_nMaxDay       : Byte;
    m_nMaxNoch      : Byte;
    m_nMaxTar       : Byte;
    m_nExpTret      : Byte;
    m_nDescDB       : Integer;
    m_nDT           : CDTRouting;
    FDB             : PCDBDynamicConn;
    m_pTTbl         : SL3ExportVIT;
    m_strLockFP     : String;

    procedure OnExpired; override;
    procedure SetToScreen(pTbl:SQWERYMDL);
    function  GetToScreen:SQWERYMDL;
    procedure LoadDayChBox(dwVTDayWMask:Dword);
    procedure LoadMonthChBox(dwVTDayMask:Dword);
    function  GetWDayMask:Word;
    function  GetMDayMask:DWord;
    function  LoadSettings:SQWERYMDL;
    function  LoadDrvName:String;
    procedure SaveSettings(pTbl:SQWERYMDL);
    function  GetLastDate:TDateTime;
    procedure SetLastDate(dtDate:TDateTime);
    function  LoadAbonsCheckList:String;
    function  GetAbonCluster:String;
    procedure SetAbonCluster(strVTCluster:String);
    function  GetAID(strAID:String):Integer;
    function  GetSAID(nAID:Integer):String;
    function  FindAID(nAID:Integer;strAID:String):Boolean;
    function  GetMaxPower(var pTbl:SL3ExportVIT):Double;
    function  FillTretTag(dtDate:TDateTime;nVMID:Integer;var pTbl:SL3ExportVIT):Integer;
  //  procedure InsertUPDBFVIT(FDat:Integer;var pTbl:SL3ExportVIT);
  public
    constructor Create(pTable:PSGENSETTTAG);
    destructor Destroy(); override;

    procedure OnHandler;
    function  EventHandler(var pMsg : CMessage):Boolean;
    function  SelfHandler(var pMsg:CMessage):Boolean;
    function  LoHandler(var pMsg:CMessage):Boolean;
    function  HiHandler(var pMsg:CMessage):Boolean;

    procedure RunExport();
    procedure OnExportOn();
    procedure OnExportOff();
    procedure OnExportInit();
    procedure OnExport();
    procedure OnAbonClear;


    function  GetRealPort(nPort:Integer):Integer;
    procedure Init(pTable:PSGENSETTTAG);
    procedure Prepare;
    procedure Start;
    procedure Finish;
    function  ExportData(ds, de : TDateTime) : Boolean;
   // procedure SaveData(FDat:Integer;var pTbl:SL3ExportMOGB);

    procedure InitTree();
    procedure CreateTable(_TableName : String);
    procedure OnLoadParam;
    procedure OnSaveParam;
    procedure OnHandExport;
    procedure cbm_nVTUnlPowerClick(Sender: TObject);
    property Pem_strVTPath:TEdit read em_strVTPath write em_strVTPath;
    property Pem_strVTPath1:TEdit read em_strVTPath1 write em_strVTPath1;
    property Pclm_strVTAbons:TParamCheckList read clm_strVTAbons write clm_strVTAbons;
    property Pcbm_nVTUnlPower:TCheckBox read cbm_nVTUnlPower write cbm_nVTUnlPower;
    property Pcbm_nVTMaxUtro:TCheckBox read cbm_nVTMaxUtro write cbm_nVTMaxUtro;
    property Pcbm_nVTMaxVech:TCheckBox read cbm_nVTMaxVech write cbm_nVTMaxVech;
    property Pcbm_nVTMaxDay:TCheckBox read cbm_nVTMaxDay write cbm_nVTMaxDay;
    property Pcbm_nVTMaxNoch:TCheckBox read cbm_nVTMaxNoch write cbm_nVTMaxNoch;
    property Pcbm_nVTMaxTar:TCheckBox read cbm_nVTMaxTar write cbm_nVTMaxTar;
    property Pcbm_nVTExpTret:TCheckBox read cbm_nVTExpTret write cbm_nVTExpTret;
    property Pclm_swVTDayMask:TParamCheckList read clm_swVTDayMask write clm_swVTDayMask;
    property Pclm_sdwVTMonthMask:TParamCheckList read clm_sdwVTMonthMask write clm_sdwVTMonthMask;
    property Pchm_swVTDayMask:TCheckBox read chm_swVTDayMask write chm_swVtDayMask;
    property Pchm_sdwVTMonthMask:TCheckBox read chm_sdwVTMonthMask write chm_sdwVTMonthMask;
    property Pchm_sbyVTEnable:TCheckBox read chm_sbyVTEnable write chm_sbyVTEnable;
    property Pdtm_sdtVTBegin:TDateTimePicker read dtm_sdtVTBegin write dtm_sdtVTBegin;
    property Pdtm_sdtVTEnd:TDateTimePicker read dtm_sdtVTEnd write dtm_sdtVTEnd;
    property Pdtm_sdtVTPeriod:TDateTimePicker read dtm_sdtVTPeriod write dtm_sdtVTPeriod;
    property Pcbm_snVTDeepFind:TComboBox read cbm_snVTDeepFind write cbm_snVTDeepFind;
end;
type
  TConvertChars = array [#128..#255] of char;

const
  Win_KoiChars: TConvertChars = (
  #128,#129,#130,#131,#132,#133,#134,#135,#136,#137,#060,#139,#140,#141,#142,#143,
  #144,#145,#146,#147,#148,#169,#150,#151,#152,#153,#154,#062,#176,#157,#183,#159,
  #160,#246,#247,#074,#164,#231,#166,#167,#179,#169,#180,#060,#172,#173,#174,#183,
  #156,#177,#073,#105,#199,#181,#182,#158,#163,#191,#164,#062,#106,#189,#190,#167,
  #225,#226,#247,#231,#228,#229,#246,#250,#233,#234,#235,#236,#237,#238,#239,#240,
  #242,#243,#244,#245,#230,#232,#227,#254,#251,#253,#154,#249,#248,#252,#224,#241,
  #193,#194,#215,#199,#196,#197,#214,#218,#201,#202,#203,#204,#205,#206,#207,#208,
  #210,#211,#212,#213,#198,#200,#195,#222,#219,#221,#223,#217,#216,#220,#192,#209);

  Koi_WinChars: TConvertChars = (
  #128,#129,#130,#131,#132,#133,#134,#135,#136,#137,#138,#139,#140,#141,#142,#143,
  #144,#145,#146,#147,#148,#149,#150,#151,#152,#153,#218,#155,#176,#157,#183,#159,
  #160,#161,#162,#184,#186,#165,#166,#191,#168,#169,#170,#171,#172,#173,#174,#175,
  #156,#177,#178,#168,#170,#181,#182,#175,#184,#185,#186,#187,#188,#189,#190,#185,
  #254,#224,#225,#246,#228,#229,#244,#227,#245,#232,#233,#234,#235,#236,#237,#238,
  #239,#255,#240,#241,#242,#243,#230,#226,#252,#251,#231,#248,#253,#249,#247,#250,
  #222,#192,#193,#214,#196,#197,#212,#195,#213,#200,#201,#202,#203,#204,#205,#206,
  #207,#223,#208,#209,#210,#211,#198,#194,#220,#219,#199,#216,#221,#217,#215,#218);

implementation
procedure CL3ExportVTModule.OnHandler;
Begin

End;
function  CL3ExportVTModule.SelfHandler(var pMsg:CMessage):Boolean;
begin
    Result := false;
end;
function  CL3ExportVTModule.LoHandler(var pMsg:CMessage):Boolean;
begin
    Result := false;
end;
function  CL3ExportVTModule.HiHandler(var pMsg:CMessage):Boolean;
begin
    Result := false;
end;
function  CL3ExportVTModule.EventHandler(var pMsg : CMessage):Boolean;
begin
    case pMsg.m_sbyType of
         DL_EXPORTDBFVIT_START :
         begin
            OnExport();
            Result := true;
            exit;
         end;
    end;
    Result := false;
end;
{
Var
    pTbl : SQWERYMDL;
Begin
    //SaveSettings(GetToScreen);
    pTbl := LoadSettings;
}
constructor CL3ExportVTModule.Create(pTable:PSGENSETTTAG);
var
    strConnect,strDName : string;
    pTbl : SQWERYMDL;
begin
    try
    m_pGenSett := pTable;
    m_QTable := TTable.Create(nil);
    pTbl := LoadSettings;
    if (m_pGenSett.m_sSetForETelecom=1) AND (m_pGenSett.m_sChooseExport=5) then
    Begin
     m_nDT := CDTRouting.Create;
     //FDB := m_pDB.CreateConnectEx(m_nDescDB);
     //strDName := LoadDrvName;
    //strConnect := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source='+strDName+';Initial Catalog='+ExtractFilePath(Application.ExeName)+'\Archive;Collate=Russian;';
     //strConnect := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+ExtractFilePath(Application.ExeName)+'\Archive;Extended Properties=dbase IV;Persist Security Info=False';
     //if (pTbl.m_sbyEnable=1) then m_pDB.ConnectDBF(strConnect);
    End;
    except

    end;
end;
procedure CL3ExportVTModule.Init(pTable:PSGENSETTTAG);
begin
    m_pGenSett := pTable;
    LoadAbonsCheckList;
    OnExportInit;
end;
procedure CL3ExportVTModule.Prepare;
Begin
    if (m_pGenSett.m_sSetForETelecom=1) AND (m_pGenSett.m_sChooseExport=5) then
    OnLoadParam;
End;
procedure CL3ExportVTModule.OnExportInit;
Var
    pTbl : SQWERYMDL;
Begin
    //SaveSettings(GetToScreen);
    pTbl := LoadSettings;
    inherited Init(pTbl);
End;
function CL3ExportVTModule.LoadSettings:SQWERYMDL;
Var
    strPath : String;
    Fl      : TINIFile;
    pTbl    : SQWERYMDL;
Begin
    strPath := ExtractFilePath(Application.ExeName)+'\Settings\UnLoad_Config.ini';
    try
    Fl := TINIFile.Create(strPath);
    with pTbl do
    Begin
     m_strPath      := Fl.ReadString('UNLOAD_VIT','m_strPath','');
     m_strPath1     := Fl.ReadString('UNLOAD_VIT','m_strPath1','');
     m_strAbons     := Fl.ReadString('UNLOAD_VIT','m_strAbons','');
     m_sdtBegin     := StrToTime(Fl.ReadString('UNLOAD_VIT','m_sdtBegin',TimeToStr(Now)));
     m_sdtEnd       := StrToTime(Fl.ReadString('UNLOAD_VIT','m_sdtEnd',TimeToStr(Now)));
     m_sdtPeriod    := StrToTime(Fl.ReadString('UNLOAD_VIT','m_sdtPeriod',TimeToStr(Now)));
     m_dtLast       := StrToDate(Fl.ReadString('UNLOAD_VIT','m_dtLast',DateToStr(GetLastDate)));
     m_swDayMask    :=Fl.ReadInteger('UNLOAD_VIT','m_swDayMask',0);
     m_sdwMonthMask :=Fl.ReadInteger('UNLOAD_VIT','m_sdwMonthMask',0);
     m_sbyEnable    :=Fl.ReadInteger('UNLOAD_VIT','m_sbyEnable',0);
     m_snDeepFind   :=Fl.ReadInteger('UNLOAD_VIT','m_snDeepFind',0);
     m_nUnlPower    :=Fl.ReadInteger('UNLOAD_VIT','m_nUnlPower',0);
     m_nMaxUtro     :=Fl.ReadInteger('UNLOAD_VIT','m_nMaxUtro',0);
     m_nMaxVech     :=Fl.ReadInteger('UNLOAD_VIT','m_nMaxVech',0);
     m_nMaxDay      :=Fl.ReadInteger('UNLOAD_VIT','m_nMaxDay',0);
     m_nMaxNoch     :=Fl.ReadInteger('UNLOAD_VIT','m_nMaxNoch',0);
     m_nMaxTar      :=Fl.ReadInteger('UNLOAD_VIT','m_nMaxTar',0);
     m_nExpTret     :=Fl.ReadInteger('UNLOAD_VIT','m_nExpTret',0);
    end;
    Fl.Destroy;
    except
    end;
    Result := pTbl;
End;
function CL3ExportVTModule.LoadDrvName:String;
Var
    strPath : String;
    Fl      : TINIFile;
    pTbl    : SQWERYMDL;
Begin
    strPath := ExtractFilePath(Application.ExeName)+'\Settings\UnLoad_Config.ini';
    try
    Fl := TINIFile.Create(strPath);
    with pTbl do
    Begin
     Result := Fl.ReadString('UNLOAD_VIT','m_strDriverName','dBASE Files');
    end;
    Fl.Destroy;
    except
     Result := 'dBASE Files';
    end;
End;
procedure CL3ExportVTModule.SaveSettings(pTbl:SQWERYMDL);
Var
    strPath : String;
    Fl      : TINIFile;
Begin
    strPath := ExtractFilePath(Application.ExeName)+'\Settings\UnLoad_Config.ini';
    try
    Fl := TINIFile.Create(strPath);
    with pTbl do
    Begin
     Fl.WriteString('UNLOAD_VIT','m_strPath',m_strPath);
     Fl.WriteString('UNLOAD_VIT','m_strPath1',m_strPath1);
     Fl.WriteString('UNLOAD_VIT','m_strAbons',m_strAbons);
     Fl.WriteString('UNLOAD_VIT','m_sdtBegin',TimeToStr(m_sdtBegin));
     Fl.WriteString('UNLOAD_VIT','m_sdtEnd',TimeToStr(m_sdtEnd));
     Fl.WriteString('UNLOAD_VIT','m_sdtPeriod',TimeToStr(m_sdtPeriod));
     Fl.WriteString('UNLOAD_VIT','m_dtLast',DateToStr(GetLastDate));
     Fl.WriteInteger('UNLOAD_VIT','m_swDayMask',m_swDayMask);
     Fl.WriteInteger('UNLOAD_VIT','m_sdwMonthMask',m_sdwMonthMask);
     Fl.WriteInteger('UNLOAD_VIT','m_sbyEnable',m_sbyEnable);
     Fl.WriteInteger('UNLOAD_VIT','m_snDeepFind',m_snDeepFind);

     Fl.WriteInteger('UNLOAD_VIT','m_nUnlPower',m_nUnlPower);
     Fl.WriteInteger('UNLOAD_VIT','m_nMaxUtro',m_nMaxUtro);
     Fl.WriteInteger('UNLOAD_VIT','m_nMaxVech',m_nMaxVech);
     Fl.WriteInteger('UNLOAD_VIT','m_nMaxDay',m_nMaxDay);
     Fl.WriteInteger('UNLOAD_VIT','m_nMaxNoch',m_nMaxNoch);
     Fl.WriteInteger('UNLOAD_VIT','m_nMaxTar',m_nMaxTar);
     Fl.WriteInteger('UNLOAD_VIT','m_nExpTret',m_nExpTret);
    end;
    Fl.Destroy;
    except
    end;
End;
procedure CL3ExportVTModule.SetToScreen(pTbl:SQWERYMDL);
Begin
    with pTbl do
    Begin
     em_strVTPath.Text          := m_strPath;
     em_strVTPath1.Text         := m_strPath1;
     dtm_sdtVTBegin.DateTime    := m_sdtBegin;
     dtm_sdtVTEnd.DateTime      := m_sdtEnd;
     dtm_sdtVTPeriod.DateTime   := m_sdtPeriod;
     LoadDayChBox(m_swDayMask);
     LoadMonthChBox(m_sdwMonthMask);
     SetAbonCluster(m_strAbons);
     cbm_snVTDeepFind.ItemIndex := m_snDeepFind;
     chm_sbyVTEnable.Checked    := Boolean(m_sbyEnable);
     cbm_nVTUnlPower.Checked    := Boolean(m_nUnlPower);
     cbm_nVTMaxUtro.Checked     := Boolean(m_nMaxUtro);
     cbm_nVTMaxVech.Checked     := Boolean(m_nMaxVech);
     cbm_nVTMaxDay.Checked      := Boolean(m_nMaxDay);
     cbm_nVTMaxNoch.Checked     := Boolean(m_nMaxNoch);
     cbm_nVTMaxTar.Checked      := Boolean(m_nMaxTar);
     cbm_nVTExpTret.Checked     := Boolean(m_nExpTret);
     cbm_nVTUnlPowerClick(cbm_nVTUnlPower);
    End;
End;
function CL3ExportVTModule.GetToScreen:SQWERYMDL;
Var
    pTbl : SQWERYMDL;
Begin
    with pTbl do
    Begin
     m_strPath      := em_strVTPath.Text;
     m_strPath1     := em_strVTPath1.Text;
     m_sdtBegin     := dtm_sdtVTBegin.DateTime;
     m_sdtEnd       := dtm_sdtVTEnd.DateTime;
     m_sdtPeriod    := dtm_sdtVTPeriod.DateTime;
     m_swDayMask    := GetWDayMask;
     m_sdwMonthMask := GetMDayMask;
     m_strAbons     := GetAbonCluster;
     m_snDeepFind   := cbm_snVTDeepFind.ItemIndex;
     m_sbyEnable    := Byte(chm_sbyVTEnable.Checked);
     m_nUnlPower    := Byte(cbm_nVTUnlPower.Checked);
     m_nMaxUtro     := Byte(cbm_nVTMaxUtro.Checked);
     m_nMaxVech     := Byte(cbm_nVTMaxVech.Checked);
     m_nMaxDay      := Byte(cbm_nVTMaxDay.Checked);
     m_nMaxNoch     := Byte(cbm_nVTMaxNoch.Checked);
     m_nMaxTar      := Byte(cbm_nVTMaxTar.Checked);
     m_nExpTret     := Byte(cbm_nVTExpTret.Checked);
    End;
    Result := pTbl;
End;
procedure CL3ExportVTModule.cbm_nVTUnlPowerClick(Sender: TObject);
begin
    if (Sender as TCheckBox).Checked=True then
    Begin
     cbm_nVTMaxUtro.Enabled := True;
     cbm_nVTMaxVech.Enabled := True;
     cbm_nVTMaxDay.Enabled  := True;
     cbm_nVTMaxNoch.Enabled := True;
     cbm_nVTMaxTar.Enabled  := True;
    End else
    Begin
     cbm_nVTMaxUtro.Enabled := False;
     cbm_nVTMaxVech.Enabled := False;
     cbm_nVTMaxDay.Enabled  := False;
     cbm_nVTMaxNoch.Enabled := False;
     cbm_nVTMaxTar.Enabled  := False;
    End;
end;
procedure CL3ExportVTModule.LoadDayChBox(dwVTDayWMask:Dword);
var
    i : integer;
begin
    if (dwVTDayWMask and DYM_ENABLE)<>0 then
     chm_swVTDayMask.Checked := true
    else
     chm_swVTDayMask.Checked := false;
    for i := 0 to 6 do
    if (dwVTDayWMask and (1 shl (i+1)))<>0 then
     clm_swVTDayMask.Checked[i] := true
    else
     clm_swVTDayMask.Checked[i] := false;
end;
procedure CL3ExportVTModule.LoadMonthChBox(dwVTDayMask:Dword);
var
    i : integer;
begin
    if (dwVTDayMask and MTM_ENABLE) <> 0 then
     chm_sdwVTMonthMask.Checked := true
    else
     chm_sdwVTMonthMask.Checked := false;
    for i := 0 to 30 do
    if (dwVTDayMask and (1 shl (i+1))) <> 0 then
     clm_sdwVTMonthMask.Checked[i] := true
    else
     clm_sdwVTMonthMask.Checked[i] := false;
end;
function CL3ExportVTModule.GetWDayMask:Word;
var
    i     : integer;
    wMask : Word;
Begin
    wMask := Byte(chm_swVTDayMask.Checked=True);
    for i := 0 to 6 do
    wMask := wMask or ((Byte(clm_swVTDayMask.Checked[i]=True)) shl (i+1));
    Result := wMask;
End;
function CL3ExportVTModule.GetMDayMask:DWord;
var
    i      : integer;
    dwMask : DWord;
Begin
    dwMask := Byte(chm_sdwVTMonthMask.Checked=True);
    for i := 0 to 30 do
    dwMask := dwMask or ((Byte(clm_sdwVTMonthMask.Checked[i]=True)) shl (i+1));
    Result := dwMask;
End;
procedure CL3ExportVTModule.Start();
begin
    m_nTbl.m_sbyEnable := 1;
end;
destructor CL3ExportVTModule.Destroy();
begin
  if m_QTable <> nil then FreeAndNil(m_QTable);
    m_pDB.DynDisconnectEx(m_nDescDB);
  inherited;
end;
procedure CL3ExportVTModule.Finish;
begin
    m_nTbl.m_sbyEnable := 0;
end;
procedure CL3ExportVTModule.OnExpired;
Begin
    SendMsg(BOX_L3,0,DIR_L3TOL3,DL_EXPORTDBFVIT_START);
End;
procedure CL3ExportVTModule.RunExport;
begin
    Run;
end;
function CL3ExportVTModule.GetLastDate:TDateTime;
Var
    dtBegin,dtEnd  : TDateTime;
    year,month,day : Word;
Begin
    dtBegin:= Now;
    dtEnd  := Now;
    if m_nTbl.m_snDeepFind=0 then
    Begin
     DecodeDate(dtEnd,year,month,day);
     dtEnd := EncodeDate(year,month,1);
    End else
    if (m_nTbl.m_snDeepFind<>0)and(m_nTbl.m_snDeepFind<>255) then dtEnd := dtEnd - DeltaFHF[m_nTbl.m_snDeepFind];
    Result := dtEnd;
End;
procedure CL3ExportVTModule.SetLastDate(dtDate:TDateTime);
Var
    strPath : String;
    Fl      : TINIFile;
Begin
    strPath := ExtractFilePath(Application.ExeName)+'\Settings\UnLoad_Config.ini';
    try
    Fl := TINIFile.Create(strPath);
    Fl.WriteString('UNLOAD_VIT','m_dtLast',DateToStr(dtDate));
    Fl.Destroy;
    except
    end;
End;
procedure CL3ExportVTModule.OnExport;
Begin
    InitTree;
    ExportData(m_dtLast,Now);
    SetLastDate(Now);
end;
procedure CL3ExportVTModule.OnSaveParam;
Begin
    SaveSettings(GetToScreen);
End;
procedure CL3ExportVTModule.OnLoadParam;
Begin
    LoadAbonsCheckList;
    SetToScreen(LoadSettings);
End;
procedure CL3ExportVTModule.OnHandExport;
Begin
    InitTree;
    ExportData(GetLastDate,Now);
End;
procedure CL3ExportVTModule.OnExportOn;
begin
    EventBox.FixEvents(ET_RELEASE,'��������� ������� � DBF.');
    m_nTbl.m_sbyEnable := 1;

end;
procedure CL3ExportVTModule.OnExportOff;
begin
    EventBox.FixEvents(ET_NORMAL,'��������� ������� � DBF.');
    m_nTbl.m_sbyEnable := 0;
end;
procedure CL3ExportVTModule.OnAbonClear;
Var
    strPath : String;
    Fl      : TINIFile;
Begin
    strPath := ExtractFilePath(Application.ExeName)+'\Settings\UnLoad_Config.ini';
    try
     Fl := TINIFile.Create(strPath);
     Fl.WriteString('UNLOAD_VIT','m_strAbons','');
     Fl.Destroy;
     except
    end;
    LoadAbonsCheckList;
End;
function CL3ExportVTModule.LoadAbonsCheckList:String;
var
    i : integer;
    strCluster : String;
begin
    strCluster := '';
    m_pDB.GetAbonsNamesTable(m_pAbonTable);
    clm_strVTAbons.Clear;
    for i := 0 to m_pAbonTable.Count - 1 do
    Begin
     clm_strVTAbons.Items.Add('('+IntToStr(m_pAbonTable.Items[i].m_swABOID)+')'+m_pAbonTable.Items[i].m_sName);
     clm_strVTAbons.Checked[i] := False;
    End;
    Result := strCluster;
end;
function CL3ExportVTModule.GetAbonCluster:String;
Var
    i,nAID,sID : Integer;
    strCluster : String;
Begin
    strCluster := '';
    for i:=0 to clm_strVTAbons.Items.Count-1 do
    Begin
     nAID := GetAID(clm_strVTAbons.Items[i]);
     if clm_strVTAbons.Checked[i]=True then 
     strCluster := strCluster + IntToStr(nAID) + ',';
    End;
    Result := strCluster;
End;
function CL3ExportVTModule.GetAID(strAID:String):Integer;
Var
    i : Integer;
Begin
    Result := 0;
    for i := 0 to m_pAbonTable.Count - 1 do
    Begin
     if strAID='('+IntToStr(m_pAbonTable.Items[i].m_swABOID)+')'+m_pAbonTable.Items[i].m_sName then
     Begin
      Result := m_pAbonTable.Items[i].m_swABOID;
      exit;
     End;
    End;
End;
function CL3ExportVTModule.GetSAID(nAID:Integer):String;
Var
    i : Integer;
Begin
    Result := '';
    for i := 0 to m_pAbonTable.Count - 1 do
    Begin
     if nAID=m_pAbonTable.Items[i].m_swABOID then
     Begin
      Result := m_pAbonTable.Items[i].m_sName;
      exit;
     End;
    End;
End;
procedure CL3ExportVTModule.SetAbonCluster(strVTCluster:String);
Var
    i : Integer;
Begin
    for i := 0 to m_pAbonTable.Count - 1 do
    Begin
     if FindAID(m_pAbonTable.Items[i].m_swABOID,strVTCluster)=True then
     clm_strVTAbons.Checked[i] := True else
     clm_strVTAbons.Checked[i] := False;
    End;
End;
function CL3ExportVTModule.FindAID(nAID:Integer;strAID:String):Boolean;
Var
    i,nCode : Integer;
    str : String;
Begin
    Result := False;
    str := strAID;
    while GetCode(nCode,str)<>False do
    Begin
     if nCode=nAID then
     Begin
      Result := True;
      exit;
     End;
    End;
End;
procedure CL3ExportVTModule.InitTree;
begin
   // FDB.GetAbonsTableNSDBFVIT(m_strAbons,m_pExportVit);
end;
//function CDBDynamicConn.GetMogBitData(nABOID:Integer;de:TDateTime;var pTable:SL3ExportMOGBS):Boolean;

function CL3ExportVTModule.ExportData(ds, de : TDateTime) : Boolean;
var
    FDat,i,j, ni,nAID,s0,s1 : Integer;
    l_Ys, l_Ms, l_Ds,
    l_Ye, l_Me, l_De : WORD;
    strLine, strLineTarif,str,strFileName : String;
    regNo : String;
    pTable:SL3ExportMOGBS;
    mPidFile : TextFile;
    pDb        : CDBDynamicConn;
    strDate : String;
    nSumm   : Integer;
begin
    DecodeDate(ds, l_Ys, l_Ms, l_Ds); l_Ds := 1;
    ds := EncodeDate(l_Ys, l_Ms, l_Ds);
    DecodeDate(de, l_Ye, l_Me, l_De); l_De := 1;
    de := EncodeDate(l_Ye, l_Me, l_De);
    try
    pDb  := m_pDB.getConnection;
    while(cDateTimeR.CompareMonth(ds, de) <> 1) do
    begin
      strFileName := FormatDateTime('yymmdd',(de-1))+'.obh';
      AssignFile(mPidFile,ExtractFilePath(Application.ExeName)+'\Archive\'+strFileName);
      Rewrite(mPidFile);
      str := m_strAbons;
      if m_strPath<>''then EventBox.FixEvents(ET_RELEASE,'������� � '+m_strPath+'\'+strFileName+' �� '+DateToStr(de));
      if m_strPath1<>''then EventBox.FixEvents(ET_RELEASE,'������� � '+m_strPath1+'\'+strFileName+' �� '+DateToStr(de));
      while GetCode(nAID,str)<>False do
      Begin
      if pDb.GetMogBitData(nAID,de,pTable) then
       Begin
        strLine := '';
        strLineTarif := '';
        for i:=0 to pTable.Count-1 do
        Begin
           nSumm := 0;
           strLineTarif := '';
           regNo := '4'+IntToStr(pTable.Items[i].m_wDEPID)+pTable.Items[i].m_strLicNb+'0'+'0';
           for j:=1 to Length(regNo) do
            nSumm := nSumm + StrToInt(regNo[j]);
            nSumm := nSumm mod 9;
           regNo := regNo+IntToStr(nSumm);
           strDate := FormatDateTime('dd/mm/yyyy',pTable.Items[i].m_dtDate-1);
           strDate := StringReplace(strDate,'.','/',[rfReplaceAll]);
           s0:=pos('(',pTable.Items[i].m_strFIO);
           s1:=pos(')',pTable.Items[i].m_strFIO);
           if (s0>0) and (s1>0) then
           Delete(pTable.Items[i].m_strFIO,s0,s1);
           strLine :=  strDate+';'+
                       regNo+';'+
                       pTable.Items[i].m_strLicNb+';'+
                       pTable.Items[i].m_strFabNum+';'+
                       pTable.Items[i].m_strFIO+';'+
                       pTable.Items[i].m_strAddr+';'+
                       FloatToStrF(pTable.Items[i].m_dbDataT1,ffFixed,10,0)+';'+
                       FloatToStrF(pTable.Items[i].m_dbDataT2,ffFixed,10,0)+';'+
                       FloatToStrF(pTable.Items[i].m_dbDataT3,ffFixed,10,0)+';'+
                       FloatToStrF(pTable.Items[i].m_dbDataT4,ffFixed,10,0)+';';
           WriteLn(mPidFile,strLine);
        end;
       End;
      end;
      CloseFile(mPidFile);
      if m_strPath<>'' then CopyFile(ExtractFilePath(Application.ExeName)+'\Archive\'+strFileName,m_strPath+'\'+strFileName);
      if m_strPath1<>'' then CopyFile(ExtractFilePath(Application.ExeName)+'\Archive\'+strFileName,m_strPath1+'\'+strFileName);
      cDateTimeR.DecMonth(de);
      end;
       m_pDB.DiscDynConnect(pDb);
     except
       m_pDB.DiscDynConnect(pDb);
       EventBox.FixEvents(ET_RELEASE,'Error IN CL3ExportVTModule.ExportData !!! ');
     end;
end;
{
SL3ExportMOGB = packed record
     m_nABOID    : Integer;
     m_swVMID    : Integer;
     m_nCMDID    : Integer;
     m_dtDate    : TDateTime;
     m_byREGID   : Byte;
     m_wDEPID    : Word;
     m_strLicNb  : String;
     m_nGorSel   : String;
     m_nRES      : Byte;
     m_nCS       : Byte;
     m_strLicNbAbo : String;
     m_strKvNb   : String;
     m_strFabNum : String;
     m_strFIO    : String;
     m_strAddr   : String;
     m_dbDataT1  : Double;
     m_dbDataT2  : Double;
     m_dbDataT3  : Double;
     m_dbDataT4  : Double;
   End;
   SL3ExportMOGBS = packed record
    Count : Integer;
    Items : array of SL3ExportMOGB;
   end;
}

{
procedure TEventBox.bSaveEvClick(Sender: TObject);
var
  l_str: string;
  I: Integer;
  mPidFile : TextFile;
begin
  if m_sdSaveLog.Execute then
  begin
  try
    AssignFile(mPidFile,m_sdSaveLog.FileName);
    Rewrite(mPidFile);
    if m_blTraceL5=False then
    Begin
     for I := 0 to m_reEventer.Lines.Count-1 do
     begin
      l_str := m_reEventer.Lines[I];
      WriteLn(mPidFile,l_str);
     end;
    end else
    Begin
     for I := 0 to m_reEventer1.Lines.Count-1 do
     begin
      l_str := m_reEventer1.Lines[I];
      WriteLn(mPidFile,l_str);
     End;
    End;
  except
    CloseFile(mPidFile);
    FixEvents(ET_CRITICAL, '�� ����� ���������� ������ ��������� ������!');
  end;
    CloseFile(mPidFile);
    FixEvents(ET_RELEASE, '����� �������� !');
  end;
end;
}


{function CL3ExportVTModule.ExportData(ds, de : TDateTime) : Boolean;
var
    FDat,i, ni,nAID : Integer;
    l_Ys, l_Ms, l_Ds,
    l_Ye, l_Me, l_De : WORD;
    seTable  : L3ARCHDATAMY;
    str,strFileName : String;
    m_pGrData : L3GRAPHDATAS;
    pTable:TM_TARIFFS;
    KE : Double;
begin
    DecodeDate(ds, l_Ys, l_Ms, l_Ds); l_Ds := 1;
    ds := EncodeDate(l_Ys, l_Ms, l_Ds);
    DecodeDate(de, l_Ye, l_Me, l_De); l_De := 1;
    de := EncodeDate(l_Ye, l_Me, l_De);
try
    while(cDateTimeR.CompareMonth(ds, de) <> 1) do
    begin
      strFileName := 'd' + FormatDateTime('mm01yy',de);
      CreateTable(strFileName);
      str := m_strAbons;
      while GetCode(nAID,str)<>False do
      Begin
      if m_strPath<>''then EventBox.FixEvents(ET_RELEASE,'������� � '+m_strPath+'\'+strFileName+'.DBF. �� '+DateToStr(de)+'. �������:'+GetSAID(nAID));
      if m_strPath1<>''then EventBox.FixEvents(ET_RELEASE,'������� � '+m_strPath1+'\'+strFileName+'.DBF. �� '+DateToStr(de)+'. �������:'+GetSAID(nAID));
       FDB.GetAbonsTableNSDBFVIT(nAID,de,m_pExportVit);

       for i:=0 to m_pExportVit.Count-1 do
        m_pDB.InsertUPDBFVIT(strFileName,m_pExportVit.Items[i]);
       // SaveData(FDat,m_pExportMOGB.Items[i]);
      end;

      cDateTimeR.DecMonth(de);

      if m_strPath<>'' then CopyFile(ExtractFilePath(Application.ExeName)+'\Archive\'+strFileName+'.dbf',m_strPath+'\'+strFileName+'.dbf');
      if m_strPath1<>'' then CopyFile(ExtractFilePath(Application.ExeName)+'\Archive\'+strFileName+'.dbf',m_strPath1+'\'+strFileName+'.dbf');
      end;
    except

    end;
end;}



{
procedure CL3ExportVTModule.InsertUPDBFVIT(FDat:Integer;var pTbl:SL3ExportVIT);
Var
    i,sum : Integer;
    str  : String;
    byByff : array[0..50] of Byte;
Begin
    //��� ����
    //pTbl.m_strLicNbAbo := '#12345';
    str := pTbl.NUMABON + ';';
    FileWrite(Fdat,str[1],length(str));
    //POK_ALL
    str := FloatToStrF(pTbl.POK_ALL,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //�1
    str := FloatToStrF(pTbl.POK_T1,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //�2
    str := FloatToStrF(pTbl.POK_T2,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //�3
    str := FloatToStrF(pTbl.POK_T3,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //�4
    str := FloatToStrF(pTbl.POK_T4,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //�5
    str := FloatToStrF(pTbl.POK_T5,ffFixed,11,2) + ';';
    FileWrite(Fdat,str[1],length(str));
    //FLAG
    str := IntToStr(pTbl.FLAG);
    FileWrite(Fdat,str[1],length(str));
    //����
    str := pTbl.TIME;
    FileWrite(Fdat,str[1],length(str));
    //�����
    byByff[0] := 13;
    byByff[1] := 10;
    FileWrite(Fdat,byByff,2);
End;             }



function CL3ExportVTModule.FillTretTag(dtDate:TDateTime;nVMID:Integer;var pTbl:SL3ExportVIT):Integer;
Begin   {
    Result := 0;
    m_nDT.DecMonth(dtDate);
    with pTbl do
    Begin
     NOM_SC := NOM_SC+':(������)';
     POK_ALL  := -1;POK_T1:=-1;POK_T2:=-1;POK_T3:=-1;POK_T4:=-1;POK_T5:=-1;
     POK_ALL  := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,0),3); if POK_ALL=-1 then Begin Result:=-1;exit;End;
     POK_T1   := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,1),3); if POK_T1  =-1 then Begin Result:=-1;exit;End;
     POK_T2   := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,2),3); if POK_T2  =-1 then Begin Result:=-1;exit;End;
     POK_T3   := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,3),3); if POK_T3  =-1 then Begin Result:=-1;exit;End;
     POK_T4   := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,4),3); if POK_T4  =-1 then Begin Result:=-1;exit;End;
     POK_T5   := RVLPr(FDB.CalcTRET(dtDate,nVMID, QRY_SRES_ENR_EP,5),3); if POK_T5  =-1 then Begin Result:=-1;exit;End;
    End;
    with m_pTTbl do
    Begin
     POK_ALL := POK_ALL + pTbl.POK_ALL;
     POK_T1   := POK_T1   + pTbl.POK_T1;
     POK_T2   := POK_T2   + pTbl.POK_T2;
     POK_T3   := POK_T3   + pTbl.POK_T3;
     POK_T4   := POK_T4   + pTbl.POK_T4;
     POK_T5   := POK_T5   + pTbl.POK_T5;
    End;          }
End;
function CL3ExportVTModule.GetMaxPower(var pTbl:SL3ExportVIT):Double;
Var
    dbValues: array[0..3] of Double;
    dbVal : Double;
    i,j   : Integer;
Begin
  {  dbVal := -1;j:=0;
    Move(pTbl.MU,dbValues[0],4*sizeof(Double));
     for i:=0 to 3 do
     if dbValues[i]>dbVal then
     Begin dbVal := dbValues[i];j:=i;End;
     for i:=0 to 3 do if i<>j then dbValues[i]:=-1;
    Move(dbValues[0],pTbl.MU,4*sizeof(Double));
    Result := dbVal;        }
End;
function CL3ExportVTModule.GetRealPort(nPort:Integer):Integer;
Var
    i : Integer;
Begin
    Result := nPort;
    for i:=0 to m_sTblL1.Count-1 do
    Begin
     with m_sTblL1.Items[i] do
     Begin
      if m_sbyPortID=nPort then
      Begin
       Result := m_sbyPortID;
       if m_sblReaddres=1 then Result := m_swAddres;
       exit;
      End;
     End;
    End;
End;

procedure  CL3ExportVTModule.CreateTable(_TableName : String);
Var
    strPath : String;
begin
    strPath := ExtractFilePath(Application.ExeName)+'\Archive\'+_TableName+'.dbf';
    if FileExists(strPath)=True then
    m_pDB.DeleteUPDBF(_TableName);
    m_pDB.CreateUPDBFVIT(_TableName);
end;
end.
