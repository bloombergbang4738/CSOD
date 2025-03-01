unit knslRP3PowerLimit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Excel97,ComObj, OleServer ,BaseGrid, AdvGrid, utlconst, utltypes, utldatabase, utlTimeDate,
  utlbox,utlexparcer;

type
  TRP3PowerLimit = class
  private
    { Private declarations }
    FDB               : PCDBDynamicConn;
    FABOID            : Integer;
    FsgGrid           : PTAdvStringGrid;
    Page              : integer;
    Excel             : variant;
    Sheet             : variant;
    exWorkBook        : Variant;
    FProgress         : PTProgressBar;
    posToWrite        : Integer;
    m_Tariffs         : TM_TARIFFS;
    m_TariffsNames    : array [0..3] of string;
    mLimits           : array of double;
    m3Power           : array of double;
    procedure BuildReport;
    procedure ReadLimitValues(Node: integer);
    procedure Read3Power(Node: integer);
    procedure CreateReportTitle;
    procedure CreateTarifTitle(Node: integer);
    procedure FillReport(Node: integer);
    function  FindAndReplace(find,rep:string):boolean;
  public
    { Public declarations }
    WorksName         : string;
    FirstSign         : string;
    ThirdSign         : string;
    SecondSign        : string;
    NDogovor          : string;
    NameObject        : string;
    Adress            : string;
    m_strObjCode      : string;
    mAllowString      : string;
    m_KindEnergy      : Integer;
    dt_DateBeg        : TDateTime;
    dt_DateEnd        : TDateTime;
    procedure OnFormResize;
    procedure PrepareTable;
    procedure CreateReport;
    procedure SetExcelVisible;
    procedure CreateTariffsNames;
    function  GetColorFromTariffs(Srez:byte; var pTable:TM_TARIFFS):Byte;
    function  DateOutSec(Date : TDateTime) : string;
    procedure InitArrays;
    procedure SetColorToCell(Perc : double);
  public
    property PsgGrid     :PTAdvStringGrid  read FsgGrid      write FsgGrid;
    property PABOID      :Integer          read FABOID       write FABOID;
    property PDB         :PCDBDynamicConn  read FDB          write FDB;
    property PProgress   :PTProgressBar    read FProgress    write FProgress;
  end;

var
  RP3PowerLimit : TRP3PowerLimit;
  
implementation

procedure TRP3PowerLimit.PrepareTable;
var Meters : SL2TAGREPORTLIST;
    i      : integer;
begin
   if FsgGrid=Nil then exit;
   FsgGrid.ColCount      := 5;
   FsgGrid.RowCount      := 60;
   FsgGrid.Cells[0,0]    := '� �.�';
   FsgGrid.Cells[1,0]    := '������������ �����';
   FsgGrid.Cells[2,0]    := '����� ��������';
   FsgGrid.Cells[3,0]    := '�����������';
   FsgGrid.Cells[4,0]    := '��� ��������';
   FsgGrid.ColWidths[0]  := 30;

   if not FDB.GetMeterTableForReport(FABOID,-1,Meters) then
     FsgGrid.RowCount := 1
   else
   begin
     FsgGrid.RowCount := Meters.Count+1;
     for i := 0 to Meters.Count - 1 do
     begin
       if Meters.m_sMeter[i].m_sbyType = MET_VZLJOT then
         continue;
       FsgGrid.Cells[0,i+1] := IntToStr(Meters.m_sMeter[i].m_swVMID);
       if Meters.m_sMeter[i].m_sObject='�������������'  then  FsgGrid.Cells[1,i+1] := Meters.m_sMeter[i].m_sGroupName+' '+Meters.m_sMeter[i].m_sVMeterName else
       if Meters.m_sMeter[i].m_sObject<>'�������������' then  FsgGrid.Cells[1,i+1] := Meters.m_sMeter[i].m_sVMeterName;
       FsgGrid.Cells[2,i+1] := Meters.m_sMeter[i].m_sddPHAddres;
       FsgGrid.Cells[3,i+1] := DVLS(Meters.m_sMeter[i].m_sfKI*Meters.m_sMeter[i].m_sfKU);
       FsgGrid.Cells[4,i+1] := Meters.m_sMeter[i].m_sName;
     end;
   end;
   OnFormResize;
end;

procedure TRP3PowerLimit.OnFormResize;
Var
    i : Integer;
Begin
    if FsgGrid=Nil then exit;
    for i:=1 to FsgGrid.ColCount-1  do FsgGrid.ColWidths[i]  := trunc((FsgGrid.Width-2*FsgGrid.ColWidths[0])/(FsgGrid.ColCount-1));
    //PChild.OnFormResize;
End;

procedure TRP3PowerLimit.CreateReport;
begin
   Page := 1;
   posToWrite := 1;
   try
   Excel := CreateOleObject('Excel.Application');
   except
     MessageDlg('�� ���������� ����������� MS Office Excel ��� �� �� ������', mtWarning, [mbOK], 0);
     exit;
   end;
   Excel.Application.EnableEvents := false;
   exWorkBook  := Excel.WorkBooks.Add(ExtractFileDir(application.ExeName)+'\report\RP3PowerLimit.xls');
   Excel.ActiveSheet.PageSetup.Orientation:= 1;
   Sheet      := Excel.Sheets.item[Page];
   Excel.ActiveWorkBook.worksheets[Page].activate;
   BuildReport;
end;

procedure TRP3PowerLimit.BuildReport;
var i    : integer;
    FTID : integer;
begin
   FProgress.Visible := true;

   FTID := FDB.LoadTID(QRY_E3MIN_POW_EP + m_KindEnergy);
   FDB.GetTMTarPeriodsTable(-1, FTID{ + KindEnergy}, m_Tariffs);
   CreateTariffsNames;
   FProgress.Max:=FsgGrid.RowCount * 2;
   FProgress.Position:=0;

   SetLength(mLimits, FsgGrid.RowCount);
   SetLength(m3Power, FsgGrid.RowCount);
   InitArrays;

   for i := 1 to FsgGrid.RowCount - 1 do
   begin
     FProgress.Position := i;
     if (FsgGrid.Cells[0, i] <> '') then
     begin
       ReadLimitValues(i);
       Read3Power(i);
     end;
   end;
   FTID := GetColorFromTariffs(trunc(frac(Now) / EncodeTime(0, 30, 0, 0)), m_Tariffs) - 1;
   CreateReportTitle;
   CreateTarifTitle(FTID);
   for i := 1 to FsgGrid.RowCount - 1 do
   begin
     FProgress.Position := i + FsgGrid.RowCount;

       if (FsgGrid.Cells[0, i] <> '') then
         FillReport(i);
   end;
   SetExcelVisible;
end;

procedure TRP3PowerLimit.Read3Power(Node: integer);
var pTable : L3CURRENTDATAS;
begin
   PDB.GetCurrentData(StrToInt(FsgGrid.Cells[0, Node]), QRY_E3MIN_POW_EP + m_KindEnergy, pTable);
   m3Power[Node - 1] := 0;
   if pTable.Count > 0 then
     m3Power[Node - 1] := pTable.Items[0].m_sfValue;
end;

procedure TRP3PowerLimit.ReadLimitValues(Node: integer);
var LimTable : SL3LIMITTAGS;
    i        : integer;
    TID      : integer;
begin
   PDB.GetLimitDatas(StrToInt(FsgGrid.Cells[0, Node]), QRY_E3MIN_POW_EP + m_KindEnergy, LimTable);
   TID := GetColorFromTariffs(trunc(frac(Now) / EncodeTime(0, 30, 0, 0)), m_Tariffs);
   for i := 0 to LimTable.Count - 1 do
   if TID = LimTable.Items[i].m_swTID then
   begin
     mLimits[Node - 1] := LimTable.Items[i].m_swMaxValue;
     break;
   end;
end;

procedure TRP3PowerLimit.CreateReportTitle;
begin
   Excel.ActiveSheet.Range['A' + IntToStr(posToWrite) + ':D' + IntToStr(posToWrite)].Select;
   Excel.Selection.Merge;
   Excel.ActiveSheet.Cells[posToWrite,1].Value := '������������ �������� �� ' + DateTimeToStr(Now);
   posToWrite := posToWrite + 1;
end;

procedure TRP3PowerLimit.CreateTarifTitle(Node: integer);
begin

   posToWrite := posToWrite + 3;
   Excel.ActiveSheet.Range['A' + IntToStr(posToWrite) + ':D' + IntToStr(posToWrite)].Select;
   Excel.Selection.Merge;
   Excel.ActiveSheet.Cells[posToWrite,1].Value := '�������� ����: ' + m_TariffsNames[Node];
   posToWrite := posToWrite + 1;
   Excel.ActiveSheet.Range['A' + IntToStr(posToWrite) + ':D' + IntToStr(posToWrite)].Select;
   Excel.Selection.Borders.LineStyle:=1;
   Excel.ActiveSheet.Cells[posToWrite,1].Value := '�������� �-�� �-��';
   Excel.ActiveSheet.Cells[posToWrite,2].Value := '��������';
   Excel.ActiveSheet.Cells[posToWrite,3].Value := '��������/����� (%)';
   Excel.ActiveSheet.Cells[posToWrite,4].Value := '�����';
   posToWrite := posToWrite + 1;
end;

procedure TRP3PowerLimit.FillReport(Node: integer);
var Position : integer;
    Perc     : double;
begin
   Position := Node - 1;
   Excel.ActiveSheet.Range['A' + IntToStr(posToWrite) + ':D' + IntToStr(posToWrite)].Select;
   Excel.Selection.Borders.LineStyle:=1;
   Excel.ActiveSheet.Cells[posToWrite,1].Value := FsgGrid.Cells[1, Node];
   Excel.ActiveSheet.Cells[posToWrite,2].Value := RVLPrStr(m3Power[Position], MeterPrecision[StrToInt(FsgGrid.Cells[0, Node])]);
   if (mLimits[Position] <> 0) and (mLimits[Position] <> -1) then
   begin
     Perc := m3Power[Position] / mLimits[Position];
     Excel.ActiveSheet.Cells[posToWrite,3].Value := RVLPrStr(Perc * 100, MeterPrecision[StrToInt(FsgGrid.Cells[0, Node])]);
   end
   else if mLimits[Position] <> -1 then
   begin
     Perc := 1;
     Excel.ActiveSheet.Cells[posToWrite,3].Value := RVLPrStr(Perc * 100, MeterPrecision[StrToInt(FsgGrid.Cells[0, Node])]);
   end else
   begin
     Perc := 0;
     Excel.ActiveSheet.Cells[posToWrite,3].Value := RVLPrStr(Perc * 100, MeterPrecision[StrToInt(FsgGrid.Cells[0, Node])]);
   end;
   if mLimits[Position] <> - 1 then
     Excel.ActiveSheet.Cells[posToWrite,4].Value := RVLPrStr(mLimits[Position], MeterPrecision[StrToInt(FsgGrid.Cells[0, Node])])
   else
     Excel.ActiveSheet.Cells[posToWrite,4].Value := 'N/A';
   SetColorToCell(Perc);
   posToWrite := posToWrite + 1;
end;

function  TRP3PowerLimit.FindAndReplace(find,rep:string):boolean;
var range : variant;
begin
   FindAndReplace := false;
   if find<>'' then
   begin
     try
       range:=Excel.Range['A1:EL230'].Replace(What := find,Replacement := rep);
       FindAndReplace:=true;
     except
       FindAndReplace:=false;
     end;
   end;
end;

procedure TRP3PowerLimit.SetExcelVisible;
begin
   try
     Excel.Visible := true;
   finally
     if not VarIsEmpty(Excel) then
     begin
       //Excel.Quit;
       Excel := Unassigned;
       Sheet := Unassigned;
       exWorkBook:=Unassigned;
     end;
   end;
end;

procedure TRP3PowerLimit.CreateTariffsNames;
var i : integer;
begin
  for i := 0 to 3 do
  begin
    m_TariffsNames[i] := '';
  end;
  for i := 1 to m_Tariffs.Count - 1 do
  begin
    if m_TariffsNames[m_Tariffs.Items[i].m_swTID-1] = '' then
      m_TariffsNames[m_Tariffs.Items[i].m_swTID-1] := m_Tariffs.Items[i].m_sName + '('
        + DateOutSec(m_Tariffs.Items[i].m_dtTime0) + ' - ' + DateOutSec(m_Tariffs.Items[i].m_dtTime1)
    else
      m_TariffsNames[m_Tariffs.Items[i].m_swTID-1] := m_TariffsNames[m_Tariffs.Items[i].m_swTID-1] + '; '
        + DateOutSec(m_Tariffs.Items[i].m_dtTime0) + ' - ' + DateOutSec(m_Tariffs.Items[i].m_dtTime1);
  end;
  for i := 0 to 3 do
    if m_TariffsNames[i] <> '' then
      m_TariffsNames[i] := m_TariffsNames[i] + ')'
    else
      m_TariffsNames[i] := '����� �� ���������';
end;

function TRP3PowerLimit.GetColorFromTariffs(Srez:byte; var pTable:TM_TARIFFS):Byte;
var SumS                         : word;
    Hour0, Min0, Sec0, ms0, Sum0 : word;
    Hour1, Min1, Sec1, ms1, Sum1 : word;
    i                            : byte;
begin
    Result := 0;
    SumS   := 30 * Srez;
    for i := 1 to pTable.Count - 1 do
    begin
      DecodeTime(pTable.Items[i].m_dtTime0, Hour0, Min0, Sec0, ms0);
      DecodeTime(pTable.Items[i].m_dtTime1, Hour1, Min1, Sec1, ms1);
      Sum0 := Hour0*60 + Min0;
      Sum1 := Hour1*60 + Min1;
      if Hour0 < Hour1 then
      begin
        if (SumS >= Sum0) and (SumS < Sum1) then
          Result := pTable.Items[i].m_swTID;
      end
      else
      begin
        if SumS >= Sum0 then
          Result := pTable.Items[i].m_swTID;
        if SumS < Sum1 then
          Result := pTable.Items[i].m_swTID;
      end;
    end;
end;

function TRP3PowerLimit.DateOutSec(Date : TDateTime) : string;
var str : string;
begin
   str := TimeToStr(Date);
   SetLength(str, Length(str) - 3);
   Result := str;
end;

procedure TRP3PowerLimit.InitArrays;
var i : integer;
begin
   for i := 0 to Length(mLimits) - 1 do
   begin
     mLimits[i] := -1;
     m3Power[i] := 0;
   end;
end;

procedure TRP3PowerLimit.SetColorToCell(Perc : double);
begin
   Excel.ActiveSheet.Range['B' + IntToStr(posToWrite) + ':D' + IntToStr(posToWrite)].Select;
   if (Perc >= 0) and (Perc < 0.9) then
     Excel.Selection.Interior.ColorIndex := 10;//RGB(0, 255, 0);
   if (Perc >= 0.9) and (Perc < 1) then
     Excel.Selection.Interior.ColorIndex := 6;//RGB(0, 255, 255);
   if (Perc >= 1) then
     Excel.Selection.Interior.ColorIndex := 3;//RGB(255, 0, 0);
end;

end.
