unit knsl3tarplaneeditor;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,Messages,
  Graphics, Controls, Forms, Dialogs, Spin,
  Grids, BaseGrid, AdvGrid,utlbox,utlconst,utldatabase,knsl1module,
  knsl3tartypeeditor,knsl2treeloader,knsl5tracer,knsl5config;
type
    CL3TarPlaneEditor = class
    Private
     FTreeModule    : PTTreeView;
     m_byTrState    : Byte;
     m_byTrEditMode : Byte;
     m_nPageIndex   : Integer;
     m_nIndex       : Integer;
     m_nRowIndex    : Integer;
     m_nRowIndexEx  : Integer;
     m_nIDIndex     : Integer;
     m_nAmRecords   : Integer;
     m_nMasterIndex : Integer;
     m_strCurrentDir: String;
     m_nTypeList    : TStringList;
     FsgGrid        : PTAdvStringGrid;
     FsgCGrid       : PTAdvStringGrid;
     FcbCmdCombo    : PTComboBox;
     FChild         : CL3TarTypeEditor;
     FTreeLoader    : PCTreeLoader;
     m_pPLTbl       : TM_PLANES;
     m_nTehnoLen    : Integer;
     constructor Create;
     function  FindRow(str:String):Integer;
     procedure ViewDefault;
     procedure ViewChild(nIndex:Integer);
     function  FindFreeRow(nIndex:Integer):Integer;
     procedure OnExecute(Sender: TObject);
     procedure ExecEditData;
     procedure ExecAddData;
     procedure ExecDelData;

     procedure AddRecordToGrid(nIndex:Integer;pTbl:PTM_PLANE);
     function  SetIndex(nIndex : Integer):Integer;
     function  GenIndex:Integer;
     function  GenIndexSv:Integer;
     procedure FreeIndex(nIndex : Integer);
     Procedure FreeAllIndex;
     procedure GetGridRecord(var pTbl:TM_PLANE);
     function  GetComboIndex(cbCombo:TComboBox;str:String):Integer;
     procedure SetDefaultRow(i:Integer);
     procedure InitCombo;
    Public
     procedure Init;
     destructor Destroy; override;
     procedure OnFormResize;
     procedure SetHigthGrid(var sgGrid:TAdvStringGrid;nHigth:Integer);
     procedure OnChannelGetCellColor(Sender: TObject; ARow,
               ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
     procedure OnChannelGetCellType(Sender: TObject; ACol,
               ARow: Integer; var AEditor: TEditorType);
     procedure OnClickGrid(Sender: TObject; ARow, ACol: Integer);
     procedure ExecSetEditData(nIndex:Integer);
     procedure ExecSelRowGrid;
     procedure ExecInitLayer;
     procedure ExecSetTree;
     procedure ExecSetGrid;
     procedure OnEditNode;
     procedure OnAddNode;
     procedure OnDeleteNode;
     procedure OnSaveGrid;
     procedure OnSetGrid;
     procedure OnInitLayer;
     procedure OnDelRow;
     procedure OnDelAllRow;
     procedure OnAddRow;
     procedure OnCloneRow;
     procedure SetEdit;
     procedure OpenInfo;
     procedure CloseInfo;
    Public
     property PTreeModule :PTTreeView        read FTreeModule    write FTreeModule;
     property PsgGrid     :PTAdvStringGrid   read FsgGrid        write FsgGrid;
     property PsgCGrid    :PTAdvStringGrid   read FsgCGrid       write FsgCGrid;
     property PcbCmdCombo :PTComboBox        read FcbCmdCombo    write FcbCmdCombo;
     property PPageIndex  :Integer           read m_nPageIndex   write m_nPageIndex;
     property PIndex      :Integer           read m_nIndex       write m_nIndex;
     property PMasterIndex:Integer           read m_nMasterIndex write m_nMasterIndex;
     property PChild      : CL3TarTypeEditor read FChild         write FChild;
     property PTreeLoader :PCTreeLoader      read FTreeLoader    write FTreeLoader;
    End;
    PCL3TarPlaneEditor =^ CL3TarPlaneEditor;
implementation
constructor CL3TarPlaneEditor.Create;
Begin

End;
{
TM_TARIFF = packed record
     m_swID    : Word;
     m_swTID   : Word;
     m_swPLID  : Word;
     m_dtTime0 : TDateTime;
     m_dtTime1 : TDateTime;
     m_sName   : String[100];
    End;
    TM_TARIFFS = packed record
     m_swID       : Word;
     m_swPLID     : Word;
     m_sName      : String[100];
     m_swCMDID    : Word;
     m_dtTime0    : TDateTime;
     m_dtTime1    : TDateTime;
     m_sbyEnabled : Boolean;
     Count     : Word;
     Items     : array of TM_TARIFF;
    End;
    PTM_TARIFFS =^ TM_TARIFFS;
    TM_TARIFFSS = packed record
     Count     : Word;
     Items     : array of TM_TARIFFS;
    End;
}
destructor CL3TarPlaneEditor.Destroy;
begin
  if FChild <> nil then FreeAndNil(FChild);

  inherited;
end;

procedure CL3TarPlaneEditor.Init;
Var
    i : Integer;
Begin
    m_strCurrentDir := ExtractFilePath(Application.ExeName) + '\\Settings\\';
    for i:=0 to MAX_TTYPE do m_blTPlaneIndex[i] := True;
    m_nRowIndex         := -1;
    m_nRowIndexEx       := 1;
    m_nIDIndex          := 2;
    FsgGrid.Color       := KNS_NCOLOR;
    FsgGrid.ColCount    := 6;
    FsgGrid.RowCount    := 60;
    FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := 'ID';
    FsgGrid.Cells[2,0]  := '���';
    FsgGrid.Cells[3,0]  := '��������';
    FsgGrid.Cells[4,0]  := '�-�� ���';
    FsgGrid.Cells[5,0]  := '����������';
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 0;
    FsgGrid.ColWidths[3]:= 180;
    FsgGrid.ColWidths[4]:= 0;
    m_nTehnoLen         := 2*0+180+0;
    SetHigthGrid(FsgGrid^,20);

    ExecSetGrid;
    FChild             := CL3TarTypeEditor.Create;
    FChild.PPPLTbl     := @m_pPLTbl;
    //if FsgGrid.Cells[2,1]<>'' then
    //FChild.PMasterIndex:= StrToInt(FsgGrid.Cells[2,1]);
    //FChild.Init;
End;
procedure CL3TarPlaneEditor.OpenInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 30;
    FsgGrid.ColWidths[2]:= 30;
    FsgGrid.ColWidths[3]:= 180;
    FsgGrid.ColWidths[4]:= 0;
    m_nTehnoLen         := 2*30+180+0;
    OnFormResize;
End;
procedure CL3TarPlaneEditor.CloseInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 0;
    FsgGrid.ColWidths[3]:= 180;
    FsgGrid.ColWidths[4]:= 0;
    m_nTehnoLen         := 2*0+180+0;
    OnFormResize;
End;
procedure CL3TarPlaneEditor.SetHigthGrid(var sgGrid:TAdvStringGrid;nHigth:Integer);
Var
    i : Integer;
Begin
   // for i:=0 to sgGrid.RowCount-1 do Begin sgGrid.Cells[0,i+1] := IntToStr(i+1); sgGrid.RowHeights[i]:= nHigth;End;
End;
procedure CL3TarPlaneEditor.SetEdit;
Var
    i : Integer;
Begin
    m_nRowIndex := -1;
    FreeAllIndex;
    if m_pDB.GetTPlanesTable(m_pPLTbl)=True then for i:=0 to m_pPLTbl.Count-1 do SetIndex(m_pPLTbl.Items[i].m_swPLID);
End;
procedure CL3TarPlaneEditor.OnFormResize;
Var
    i : Integer;
Begin
    for i:=5 to FsgGrid.ColCount-1  do FsgGrid.ColWidths[i]  := trunc((FsgGrid.Width-(m_nTehnoLen)-2*FsgGrid.ColWidths[0])/(FsgGrid.ColCount-1-4));
    FChild.OnFormResize;
End;
procedure CL3TarPlaneEditor.InitCombo;
Var
    pTable : QM_METERS;
    i : Integer;
Begin
    if m_pDB.GetMetersTypeTable(pTable) then
    Begin
     FsgGrid.Combobox.Items.Clear;
     m_nTypeList.Clear;
     for i:=0 to pTable.m_swAmMeterType-1 do
     Begin
      FsgGrid.Combobox.Items.Add(pTable.m_sMeterType[i].m_sName);
      m_nTypeList.Add(pTable.m_sMeterType[i].m_sName);
     End;
    End;
End;
//Edit Add Del Request
procedure CL3TarPlaneEditor.OnEditNode;
begin
end;
procedure CL3TarPlaneEditor.OnAddNode;
begin
end;
procedure CL3TarPlaneEditor.OnDeleteNode;
Begin
End;
//Edit Add Del Execute
procedure CL3TarPlaneEditor.ExecSetEditData(nIndex:Integer);
Begin
    TraceL(1,0,'ExecSetEditData.');
End;
procedure CL3TarPlaneEditor.ExecEditData;
Begin
    TraceL(1,0,'ExecEditData.');
End;
procedure CL3TarPlaneEditor.ExecAddData;
Begin
    TraceL(1,0,'ExecAddData.');
End;
procedure CL3TarPlaneEditor.ExecDelData;
Begin
    TraceL(1,0,'ExecDelData.');
End;
procedure CL3TarPlaneEditor.ExecInitLayer;
Begin
    TraceL(1,0,'ExecInitLayer.');
    //mL2Module.Init;
End;
//Tree Reload
procedure CL3TarPlaneEditor.ExecSetTree;
Begin
    TraceL(1,0,'ExecSetTree.');
    //FTreeLoader.LoadTree;
End;
//Grid Routine
procedure CL3TarPlaneEditor.ExecSelRowGrid;
Begin
    FsgGrid.SelectRows(FindRow(IntToStr(m_nIndex)),1);
    FsgGrid.Refresh;
    ViewChild(m_nIndex);
End;
function CL3TarPlaneEditor.FindRow(str:String):Integer;
Var
   i : Integer;
Begin
   for i:=1 to FsgGrid.RowCount-1 do if FsgGrid.Cells[m_nIDIndex,i]=str then
    Begin
     if (i-FsgGrid.VisibleRowCount)>0  then FsgGrid.TopRow := i-FsgGrid.VisibleRowCount+1 else FsgGrid.TopRow := 1;
     Result := i;
     exit;
    End;
    Result := 1;
End;
procedure CL3TarPlaneEditor.ViewChild(nIndex:Integer);
Begin
    if m_blCL3TarPlaneEditor=False then
    if FChild<>Nil then
    Begin
     FChild.PPLane := nIndex;
     FChild.ExecSetGrid;
    End;
End;
procedure CL3TarPlaneEditor.ExecSetGrid;
Var
    i : Integer;
Begin
    FsgGrid.ClearNormalCells;
    //FreeAllIndex;
    if m_pDB.GetTPlanesTable(m_pPLTbl)=True then
    Begin
     m_nAmRecords := m_pPLTbl.Count;
     for i:=0 to m_pPLTbl.Count-1 do
     Begin
      SetIndex(m_pPLTbl.Items[i].m_swPLID);
      AddRecordToGrid(i,@m_pPLTbl.Items[i]);
     End;
     ViewDefault;
    End;
End;
procedure CL3TarPlaneEditor.ViewDefault;
Var
    nIndex : Integer;
    str : String;
Begin
    if m_nRowIndexEx<>-1 then
    if(FsgGrid.Cells[m_nIDIndex,m_nRowIndexEx]<>'')then
    Begin
     nIndex := StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndexEx]);
     ViewChild(nIndex);
    End;
End;

{
TM_PLANE = packed record
     m_swID       : Integer;
     m_swPLID     : Integer;
     m_sName      : String[100];
     m_sAmZones   : Integer;
     m_sbyEnable  : Byte;
    End;
}

procedure CL3TarPlaneEditor.AddRecordToGrid(nIndex:Integer;pTbl:PTM_PLANE);
Var
   nY : Integer;
   nVisible : Integer;
Begin
    nY := nIndex+1;
    nVisible := round(FsgGrid.Height/21);
    if (nY-nVisible)>0  then FsgGrid.TopRow := nY-nVisible;
    with pTbl^ do Begin
     FsgGrid.Cells[0,nY] := IntToStr(nY);
     FsgGrid.Cells[1,nY] := IntToStr(m_swID);
     FsgGrid.Cells[2,nY] := IntToStr(m_swPLID);
     FsgGrid.Cells[3,nY] := m_sName;
     FsgGrid.Cells[4,nY] := IntToStr(m_sAmZones);
     FsgGrid.Cells[5,nY] := m_nEsNoList.Strings[m_sbyEnable];
    End;
End;
procedure CL3TarPlaneEditor.OnSetGrid;
Begin
    ExecSetGrid;
End;
procedure CL3TarPlaneEditor.OnSaveGrid;
Var
    i : Integer;
    pTbl:TM_PLANE;
Begin
    for i:=1 to FsgGrid.RowCount-1 do
    Begin
     if FsgGrid.Cells[3,i]='' then break;
     pTbl.m_swID := i;
     GetGridRecord(pTbl);
     if m_pDB.AddTPlaneTable(pTbl)=True then SetIndex(pTbl.m_swPLID);
    End;
    ExecSetGrid;
End;
function CL3TarPlaneEditor.FindFreeRow(nIndex:Integer):Integer;
Var
    i : Integer;
Begin
    for i:=1 to FsgGrid.RowCount-1 do if FsgGrid.Cells[nIndex,i]='' then
    Begin
     Result := i;
     exit;
    End;
    Result := 1;
End;
procedure CL3TarPlaneEditor.GetGridRecord(var pTbl:TM_PLANE);
Var
    i : Integer;
    str : String;
Begin
    i := pTbl.m_swID;
    with pTbl do Begin
     SetDefaultRow(i);
     m_swID       := StrToInt(FsgGrid.Cells[1,i]);
     m_swPLID     := StrToInt(FsgGrid.Cells[2,i]);
     m_sName      := FsgGrid.Cells[3,i];
     m_sAmZones   := StrToInt(FsgGrid.Cells[4,i]);
     m_sbyEnable  := m_nEsNoList.IndexOf(FsgGrid.Cells[5,i]);
    End;
End;
procedure CL3TarPlaneEditor.OnAddRow;
Var
    nIndex : Integer;
Begin
    if m_nRowIndex<>-1 then
    Begin
     SetDefaultRow(m_nRowIndex);
     SetIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndex]));
    End else
    Begin
     nIndex := FindFreeRow(3);
     SetDefaultRow(nIndex);
     SetIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,nIndex]));
    End;
End;
procedure CL3TarPlaneEditor.OnCloneRow;
Var
    nIndex : Integer;
    pTbl   : TM_PLANE;
Begin
    if m_nRowIndex<>-1 then
    if m_nRowIndex<=FindFreeRow(3)-1 then
    Begin
     pTbl.m_swID   := m_nRowIndex;
     GetGridRecord(pTbl);
     pTbl.m_swPLID := GenIndexSv;
     AddRecordToGrid(FindFreeRow(3)-1,@pTbl);
    End;
End;
{
TM_PLANE = packed record
     m_swID       : Integer;
     m_swPLID     : Integer;
     m_sName      : String[100];
     m_sAmZones   : Integer;
     m_sbyEnable  : Byte;
    End;
}
procedure CL3TarPlaneEditor.SetDefaultRow(i:Integer);
Begin
    if FsgGrid.Cells[1,i]='' then FsgGrid.Cells[1,i] := '-1';
    if FsgGrid.Cells[2,i]='' then FsgGrid.Cells[2,i] := IntToStr(GenIndex);
    if FsgGrid.Cells[3,i]='' then FsgGrid.Cells[3,i] := '�������� ����: '+FsgGrid.Cells[2,i];
    if FsgGrid.Cells[4,i]='' then FsgGrid.Cells[4,i] := '4';
    if FsgGrid.Cells[5,i]='' then FsgGrid.Cells[5,i] := m_nEsNoList.Strings[1];
End;
procedure CL3TarPlaneEditor.OnClickGrid(Sender: TObject; ARow, ACol: Integer);
Begin
    m_nRowIndex := -1;
    m_nRowIndexEx := -1;
    if ARow>0 then Begin
     m_nRowIndex := ARow;
     m_nRowIndexEx := ARow;
     if FsgGrid.Cells[m_nIDIndex,ARow]<>'' then
     Begin
      m_nIndex := StrToInt(FsgGrid.Cells[m_nIDIndex,ARow]);
      ViewChild(m_nIndex);
     End else m_nIndex := -1;
    End;
End;
procedure CL3TarPlaneEditor.OnDelRow;
Var
    nFind,i,j : Integer;
    m_pSZTbl: TM_SZNTARIFFS;
Begin
    if m_nAmRecords=FindFreeRow(3)-1 then
    Begin
     if m_nIndex<>-1 then
     Begin
      m_pDB.GetSZTarifsTable(m_pSZTbl);
      for i:=0 to SZN_HOLY_DAY do
      for j:=0 to m_pSZTbl.Count-1 do
      m_pDB.DelTMTarifTable(m_nIndex,m_pSZTbl.Items[j].m_swSZNID,i,-1);
      m_pDB.DelTPlaneTable(m_nIndex);
      SetEdit;
      ExecSetGrid;
      ViewChild(m_nIndex);
     End;
    End else
    Begin
     if m_nRowIndex<>-1 then
     Begin
      if FsgGrid.Cells[m_nIDIndex,m_nRowIndex]<>'' then
      FreeIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndex]));
      FsgGrid.ClearRows(m_nRowIndex,1);
      //SetHigthGrid(FsgGrid^,20);
     End;
    End;
End;
procedure CL3TarPlaneEditor.OnDelAllRow;
Var
    i,j,k : Integer;
    m_pSZTbl: TM_SZNTARIFFS;
Begin
    m_pDB.GetSZTarifsTable(m_pSZTbl);
    for i:=0 to SZN_HOLY_DAY do
    for j:=0 to m_pSZTbl.Count-1 do
    for k:=0 to m_pPLTbl.Count-1 do
    m_pDB.DelTMTarifTable(m_pPLTbl.Items[k].m_swPLID,m_pSZTbl.Items[j].m_swSZNID,i,-1);
    m_pDB.DelTPlaneTable(-1);
    SetEdit;
    ExecSetGrid;
End;
//Init Layer
procedure CL3TarPlaneEditor.OnInitLayer;
Begin
    //ExecSetTree;
    ExecInitLayer;
End;
//Index Generator
function  CL3TarPlaneEditor.GenIndex:Integer;
Var
    i : Integer;
Begin
    for i:=0 to MAX_TTYPE do
    if m_blTPlaneIndex[i]=True then
    Begin
     Result := i;
     exit;
    End;
    Result := -1;
End;
function  CL3TarPlaneEditor.GenIndexSv:Integer;
Begin
    Result := SetIndex(GenIndex);
End;
function CL3TarPlaneEditor.SetIndex(nIndex : Integer):Integer;
Begin
    m_blTPlaneIndex[nIndex] := False;
    Result := nIndex;
End;
Procedure CL3TarPlaneEditor.FreeIndex(nIndex : Integer);
Begin
    m_blTPlaneIndex[nIndex] := True;
End;
Procedure CL3TarPlaneEditor.FreeAllIndex;
Var
    i : Integer;
Begin
    for i:=0 to MAX_TTYPE do
    m_blTPlaneIndex[i] := True;
End;
procedure CL3TarPlaneEditor.OnExecute(Sender: TObject);
Begin
    //TraceL(5,0,'OnExecute.');
    case m_byTrEditMode of
     ND_EDIT : Begin ExecEditData;End;
     ND_ADD  : Begin ExecAddData;ExecSetTree;End;
     ND_DEL  : Begin ExecDelData;ExecSetTree;End;
    end;
    ExecSetGrid;
    //ExecInitLayer;
End;
//Color And Control
procedure CL3TarPlaneEditor.OnChannelGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
     OnGlGetCellColor(Sender,ARow,ACol,AState,ABrush,AFont);
end;
procedure CL3TarPlaneEditor.OnChannelGetCellType(Sender: TObject; ACol, ARow: Integer;var AEditor: TEditorType);
begin
    with FsgGrid^ do
    case ACol of
     5:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'Active.dat');
       End;
    end;
end;
function CL3TarPlaneEditor.GetComboIndex(cbCombo:TComboBox;str:String):Integer;
Var
    i : Integer;
Begin
    for i:=0 to cbCombo.Items.Count-1 do
    Begin
      if cbCombo.Items[i]=str then
      Begin
       Result := i;
       exit;
      End;
    End;
End;
end.
 