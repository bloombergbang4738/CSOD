unit knsl3aboneditor;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,Messages,
  Graphics, Controls, Forms, Dialogs, Spin,
  Grids, BaseGrid, AdvGrid,utlbox,utlconst,utldatabase,knsl1module,
  knsl2module,knsl2treehandler,knsl3groupeditor,knsl2treeloader,knsl5tracer,knsl5config,knseditexpr,knsl3abon,utlCEmcosGenTable,knsl3RegionIns;
type

    CL3AbonEditor = class
    Private
     FTreeModule    : PTTreeView;
     m_byTrState    : Byte;
     m_byTrEditMode : Byte;
     m_nIDIndex     : Integer;
     m_nRowIndex    : Integer;
     m_nAmRecords   : Integer;
     m_nPageIndex   : Integer;
     m_nIndex       : Integer;
     m_nMasterIndex : Integer;
     m_strCurrentDir: String;
     FsgGrid        : PTAdvStringGrid;
     FChild         : CL3GroupEditor;
     FTreeLoader    : PCTreeLoader;

     m_nGroupIndex  : Integer;
     m_nCmdList     : TStringList;
     blOnClickfrom  : boolean;
     FsgGridChild   : PTAdvStringGrid;
     m_nPlaneList   : TStringList;
     m_nTehnoLen    : Integer;
     m_treeID       : CTreeIndex;
     FTreeModuleData: TTreeView;

     constructor Create;
     destructor Destroy; override;
     function  FindRow(str:String):Integer;
     procedure ViewChild(nIndex:Integer);
     procedure OnExecute(Sender: TObject);
     procedure ExecEditData;
     procedure ExecAddData;
     procedure ExecDelData;

     procedure AddRecordToGrid(nIndex:Integer;pTbl:PSL3ABON);
     function  FindFreeRow(nIndex:Integer):Integer;
     procedure SetDefaultRow(i:Integer);
     procedure GetGridRecord(var pTbl:SL3ABON);
     function  GetComboIndex(cbCombo:TComboBox;str:String):Integer;
     procedure SendMSG(byBox,byFor,byType:Byte);
     procedure InitComboPl;
    Public
     procedure Init;
     procedure ExecSelRowGrid;
     procedure OnFormResize;
      procedure OnMDownGE(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
     procedure OnChannelGetCellColor(Sender: TObject; ARow,
               ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
     procedure OnChannelGetCellType(Sender: TObject; ACol,
               ARow: Integer; var AEditor: TEditorType);
     procedure OnClickGrid(Sender: TObject; ARow, ACol: Integer);
     procedure ExecSetEditData(nIndex:Integer);
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
     procedure GenTableChanel;
     procedure UpdateMeterCode;
     procedure OpenInfo;
     procedure CloseInfo;
     procedure setTreeIndex(index:CTreeIndex);
     procedure setTreeData(value:TTreeView);
     procedure OnAddRowRegion_ES; //���������� �������

     procedure OnAddRowAbon; //���������� ��������

    Public
     property PTreeModule :PTTreeView       read FTreeModule    write FTreeModule;
     property PsgGrid     :PTAdvStringGrid  read FsgGrid        write FsgGrid;
     property PPageIndex  :Integer          read m_nPageIndex   write m_nPageIndex;
     property PIndex      :Integer          read m_nIndex       write m_nIndex;
     property PMasterIndex:Integer          read m_nMasterIndex write m_nMasterIndex;
     property PChild      :CL3GroupEditor   read FChild         write FChild;
     property PTreeLoader :PCTreeLoader     read FTreeLoader    write FTreeLoader;
     property PGroupIndex  :Integer          read m_nGroupIndex  write m_nGroupIndex;
     property PsgGridChild     :PTAdvStringGrid  read FsgGridChild   write FsgGridChild;
     procedure ExecSetGridMI(MI:integer);     
    End;
implementation
constructor CL3AbonEditor.Create;
Begin

End;
//ExtractFilePath(Application.ExeName)
{
     m_sbyID         : Byte;
     m_sbyGroupID    : Byte;
     m_swAmVMeter    : Word;
     m_sGroupName    : String[30];
     m_sGroupExpress : String[100];
}
destructor CL3AbonEditor.Destroy;
begin
  if m_nCmdList <> nil then FreeAndNil(m_nCmdList);
  if m_nPlaneList <> nil then FreeAndNil(m_nPlaneList);
  if FChild <> nil then FreeAndNil(FChild);
  inherited;
end;

procedure CL3AbonEditor.Init;
Var
    i : Integer;
Begin
    m_strCurrentDir := ExtractFilePath(Application.ExeName) + '\\Settings\\';
    m_nCmdList   := TStringList.Create;
    m_nCmdList.LoadFromFile(m_strCurrentDir+'CommandType.dat');
    m_nPlaneList := TStringList.Create;
    m_nRowIndex := -1;
    m_nIDIndex  := 2;
    FsgGrid.Color       := KNS_NCOLOR;
    FsgGrid.ColCount    := 6;
    FsgGrid.RowCount    := 25;
    FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := 'ID';
    FsgGrid.Cells[2,0]  := 'ABO';
    FsgGrid.Cells[3,0]  := '��������';
    FsgGrid.Cells[4,0]  := '������';
    FsgGrid.Cells[5,0]  := '����������';
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 0;
    FsgGrid.ColWidths[3]:= 150;
    FsgGrid.ColWidths[4]:= 120;
    m_nTehnoLen         := 0+150+120;

    FChild              := CL3GroupEditor.Create;
    FChild.PMasterIndex := 0;
    FChild.PPageIndex   := 3;
    InitComboPl;
    //ExecSetGrid;
End;
procedure CL3AbonEditor.OpenInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 35;
    FsgGrid.ColWidths[3]:= 150;
    FsgGrid.ColWidths[4]:= 120;
    m_nTehnoLen         := 35+150+120;
    OnFormResize;
End;
procedure CL3AbonEditor.CloseInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 0;
    FsgGrid.ColWidths[3]:= 150;
    FsgGrid.ColWidths[4]:= 120;
    m_nTehnoLen         := 0+150+120;
    OnFormResize;
End;
procedure CL3AbonEditor.setTreeIndex(index:CTreeIndex);
Begin
    m_treeID := index;
End;
procedure CL3AbonEditor.setTreeData(value:TTreeView);
Begin
    FTreeModuleData := value;
End;
procedure CL3AbonEditor.OnMDownGE(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Begin
   if (Button=mbLeft)and(Shift=[ssCtrl,ssLeft]) then
   Begin
     if m_nRowIndex<>-1 then
      if TAbonManager.PrepareAbon(m_nRowIndex-1,0)=True then
      Begin
       TAbonManager.ShowModal;
       ExecSetGrid;
      End;
   End;
End;
procedure CL3AbonEditor.SetEdit;
Begin
     m_nRowIndex := -1;
End;
procedure CL3AbonEditor.OnFormResize;
Var
    i : Integer;
Begin
    for i:=5 to FsgGrid.ColCount-1  do FsgGrid.ColWidths[i]  := trunc((FsgGrid.Width-(m_nTehnoLen)-2*FsgGrid.ColWidths[0])/(FsgGrid.ColCount-1-4));
    if FChild<>Nil then FChild.OnFormResize;
End;
//Edit Add Del Request
procedure CL3AbonEditor.OnEditNode;
begin
    m_byTrEditMode                  := ND_EDIT;
    ExecSetEditData(m_nIndex);
end;
procedure CL3AbonEditor.OnAddNode;
begin
    m_byTrEditMode                  := ND_ADD;
    //m_nIndex                        := GenIndex;
end;
procedure CL3AbonEditor.OnDeleteNode;
Begin
    m_byTrEditMode                  := ND_DEL;
    ExecSetEditData(m_nIndex);
    m_strL3SelNode := '������';
End;
//Edit Add Del Execute
procedure CL3AbonEditor.ExecSetEditData(nIndex:Integer);
Var
    m_sTbl : SL3GROUPTAG;
Begin
    TraceL(3,0,'ExecSetEditData.');
    m_sTbl.m_sbyGroupID    := nIndex;
End;
procedure CL3AbonEditor.ExecEditData;
Begin
    TraceL(3,0,'ExecEditData.');
End;
procedure CL3AbonEditor.ExecAddData;
Begin
    TraceL(3,0,'ExecAddData.');
End;
procedure CL3AbonEditor.InitComboPl;
Var
    pTable : TM_PLANES;
    i : Integer;
Begin
    if m_pDB.GetTPlanesTable(pTable) then
    Begin
     FsgGrid.Combobox.Items.Clear;
     m_nPlaneList.Clear;
     for i:=0 to pTable.Count-1 do
     Begin
      FsgGrid.Combobox.Items.Add(pTable.Items[i].m_sName);
      m_nPlaneList.Add(pTable.Items[i].m_sName);
     End;
    End;
End;
procedure CL3AbonEditor.ExecDelData;
Var
    m_sTbl : SL3GROUPTAG;
    i,wMID : Integer;
Begin
    TraceL(3,0,'ExecDelData.');
    //mL2Module.DelNodeLv(m_nIndex);
    {
    if m_pDB.GetVMetersTable(m_nIndex,m_sTbl)=True then
     for i:=0 to m_sTbl.m_swAmVMeter-1 do
     Begin
      wMID := m_sTbl.Item.Items[i].m_swVMID;
      //mL1Module.DelNodeLv(wMID);
      m_blVMeterIndex[wMID] := True;
     End;
    m_pDB.DelGroupTable( m_nIndex);
    FreeIndex(m_nIndex);
    }
End;
procedure CL3AbonEditor.ExecInitLayer;
Begin
    TraceL(3,0,'ExecInitLayer.');
    //mL2Module.Init;
    //SendMSG(BOX_L3,DIR_L2TOL3,DL_STARTSNDR_IND);
End;
//Tree Reload
procedure CL3AbonEditor.ExecSetTree;
Begin
    TraceL(1,0,'ExecSetTree.');
    FTreeLoader.LoadTree;
End;
//Grid Routine
procedure CL3AbonEditor.ExecSetGrid;
Var
    pTbl : SL3ABONS;
    i    : Integer;
Begin
    FsgGrid.ClearNormalCells;
    m_nRowIndex := -1;
    //GetAbonTable(swABOID:Integer;var pTable:SL3ABONS):Boolean;
    //if m_pDB.GetAbonsTable(pTbl)=True then
    m_nMasterIndex := m_treeID.PAID;
    if m_pDB.GetAbonTable(m_nMasterIndex,pTbl)=True then
    Begin
     m_nAmRecords := pTbl.Count;
     FsgGrid.RowCount := pTbl.Count+20;
     for i:=0 to pTbl.Count-1 do
     Begin
      //SetIndex(pTbl.Items[i].m_swABOID);
      AddRecordToGrid(i,@pTbl.Items[i]);
     End;
     ViewChild(m_nMasterIndex);
    End;
End;

procedure CL3AbonEditor.ExecSetGridMI(MI:integer);
Var
    pTbl : SL3ABONS;
    i    : Integer;
Begin
    FsgGrid.ClearNormalCells;
    m_nRowIndex := -1;
    //GetAbonTable(swABOID:Integer;var pTable:SL3ABONS):Boolean;
    //if m_pDB.GetAbonsTable(pTbl)=True then
    m_nMasterIndex := MI;
    if m_pDB.GetAbonTable(m_nMasterIndex,pTbl)=True then
    Begin
     m_nAmRecords := pTbl.Count;
     FsgGrid.RowCount := pTbl.Count+20;
     for i:=0 to pTbl.Count-1 do
     Begin
      //SetIndex(pTbl.Items[i].m_swABOID);
      AddRecordToGrid(i,@pTbl.Items[i]);
     End;
     ViewChild(m_nMasterIndex);
    End;
End;
procedure CL3AbonEditor.AddRecordToGrid(nIndex:Integer;pTbl:PSL3ABON);
Var
   nY : Integer;
   nVisible : Integer;
Begin
    nY := nIndex+1;
    nVisible := round(FsgGrid.Height/21);
    if (nY-nVisible)>0  then FsgGrid.TopRow := nY-nVisible;
    with pTbl^ do Begin
     FsgGrid.Cells[0,nY] := IntToStr(nY);
     FsgGrid.Cells[1,nY] := IntToStr(pTbl.m_swID);
     FsgGrid.Cells[2,nY] := IntToStr(pTbl.m_swABOID);
     FsgGrid.Cells[3,nY] := pTbl.m_sName;
     FsgGrid.Cells[4,nY] := pTbl.m_sObject;

     FsgGrid.Cells[5,nY] := m_nEsNoList.Strings[pTbl.m_sbyEnable];
     if pTbl.m_nRegionID = REG_UNKNOWN THEN
       FsgGrid.RowColor[nY] := clRed
     //else
       //FsgGrid.RowColor[nY] := clBlack;
    End;
End;
procedure CL3AbonEditor.OnSetGrid;
Begin
    ExecSetGrid;
End;
{
procedure CL2Editor.OnSaveGrid;
Var
    i      : Integer;
    pMETID : Integer;
    pTbl   : SL2TAG;
Begin
    try
    for i:=1 to FsgGrid.RowCount-1 do
    Begin
     if FsgGrid.Cells[m_nIDIndex,i]='' then break;
     pTbl.m_sbyID := i;
     GetGridRecord(pTbl);
     pMETID := m_pDB.addMeterId(pTbl);
     if pTbl.m_swMID<>-1 then pMETID := pTbl.m_swMID;
     m_pDB.InsertCommand(pMETID,pTbl.m_sbyType);
    End;
    ExecSetGrid;
    except
     TraceER('(__)CL3MD::>Error In CL2Editor.OnSaveGrid!!!');
    end;
End;
}
procedure CL3AbonEditor.OnSaveGrid;
{Var
    i : Integer;
    pTbl:SL3ABON;
    }
Begin
    {for i:=1 to FsgGrid.RowCount-1 do
    Begin
     if FsgGrid.Cells[m_nIDIndex,i]='' then break;
     pTbl.m_swID := i;
     GetGridRecord(pTbl);
     //m_pDB.addAbonId(pTbl);
     //m_pDB.SetAbonNmTable(pTbl);
    End;
    //ExecInitLayer;
    ExecSetGrid;
    }
End;
{
//������� ��������
    SL3ABON = packed record
     m_swID      : Integer;
     m_swABOID   : Integer;
     m_swPortID  : Integer;
     m_sdtRegDate: TDateTime;
     m_sName     : string[100];
     m_sObject   : string[100];
     m_sKSP      : string[5];
     m_sDogNum   : string[25];
     m_sPhone    : string[25];
     m_sAddress  : string[75];
     m_sEAddress : string[55];
     m_sShemaPath: string[55];
     m_sComment  : string[200];
     m_sPhoto    : string;
     m_sbyEnable: Byte;
     //����� ����������������
    End;
}
procedure CL3AbonEditor.GetGridRecord(var pTbl:SL3ABON);
Var
    i : Integer;
    str : String;
Begin
    i := pTbl.m_swID;
    with pTbl do Begin
     pTbl.m_swID      := StrToInt(FsgGrid.Cells[1,i]);
     pTbl.m_swABOID   := StrToInt(FsgGrid.Cells[2,i]);
     pTbl.m_sName     := FsgGrid.Cells[3,i];
     pTbl.m_sObject   := FsgGrid.Cells[4,i];
     pTbl.m_sbyEnable := m_nEsNoList.IndexOf(FsgGrid.Cells[5,i]);
    End;
End;
procedure CL3AbonEditor.SetDefaultRow(i:Integer);
Begin
    if FsgGrid.Cells[1,i]=''  then FsgGrid.Cells[1,i]  := '0';
    if FsgGrid.Cells[2,i]=''  then FsgGrid.Cells[2,i]  := '-1';
    if FsgGrid.Cells[3,i]=''  then FsgGrid.Cells[3,i]  := 'Group '+FsgGrid.Cells[m_nIDIndex,i];
    if FsgGrid.Cells[4,i]=''  then FsgGrid.Cells[4,i]  := '[x]';
    if FsgGrid.Cells[5,i]=''  then Begin if m_nPlaneList.Count<>0 then FsgGrid.Cells[5,i] := m_nPlaneList.Strings[0] else FsgGrid.Cells[5,i] :='����� �� ���������'; End;
    if FsgGrid.Cells[6,i]=''  then FsgGrid.Cells[6,i]  := m_nEsNoList.Strings[1];
End;
procedure CL3AbonEditor.ExecSelRowGrid;
Begin
    FsgGrid.SelectRows(FindRow(IntToStr(m_nIndex)),1);
    FsgGrid.Refresh;
    ViewChild(m_nIndex);
End;
function CL3AbonEditor.FindRow(str:String):Integer;
Var
   i : Integer;
Begin
   for i:=1 to 60 do if FsgGrid.Cells[m_nIDIndex,i]=str then
    Begin
     if (i-FsgGrid.VisibleRowCount)>0  then FsgGrid.TopRow := i-FsgGrid.VisibleRowCount+1 else FsgGrid.TopRow := 1;
     Result := i;
     exit;
    End;
    Result := 1;
End;
procedure CL3AbonEditor.ViewChild(nIndex:Integer);
Begin
    if m_blCL3AbonEditor=False then
    if FChild<>Nil then
    Begin
     FChild.PMasterIndex := nIndex;
     FChild.ExecSetGrid;
    End;
End;
function CL3AbonEditor.FindFreeRow(nIndex:Integer):Integer;
Var
    i : Integer;
Begin
    for i:=1 to 60 do if FsgGrid.Cells[nIndex,i]='' then
    Begin
     Result := i;
     exit;
    End;
    Result := 1;
End;
procedure CL3AbonEditor.OnAddRow;
Begin
    TAbonManager.setTreeData(FTreeModuleData);
    TAbonManager.setTreeIndex(m_treeID);
    if m_nRowIndex<>-1 then
    TAbonManager.OnAddAbon;
    TAbonManager.aop_AbonPages.ActivePageIndex:=0;
    TAbonManager.ShowModal;
    ExecSetGrid;
End;
procedure CL3AbonEditor.OnCloneRow;
Begin
    TAbonManager.setTreeData(FTreeModuleData);
    TAbonManager.setTreeIndex(m_treeID);
    if m_nRowIndex<>-1 then
    if TAbonManager.PrepareAbon(m_nIndex,0)=True then
    Begin
     TAbonManager.ShowModal;
     ExecSetGrid;
    End;
End;
procedure CL3AbonEditor.OnDelRow;
Var
    nFind : Integer;
Begin
    if m_nAmRecords=FindFreeRow(m_nIDIndex)-1 then
    Begin
     if m_nIndex<>-1 then
     Begin
      //ExecDelData;
      //FreeAllIndex;
      m_pDB.DelAbonTable(m_nIndex);
      ExecSetGrid;
      ViewChild(m_nIndex);
     End;
    End else
    Begin
     if m_nRowIndex<>-1 then
     Begin
      //if FsgGrid.Cells[m_nIDIndex,m_nRowIndex]<>'' then
      //FreeIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndex]));
      FsgGrid.ClearRows(m_nRowIndex,1);
     End;
    End;
End;
procedure CL3AbonEditor.OnDelAllRow;
Var
    i,wMID : Integer;
    pTbl   : SL3GROUPTAG;
Begin
{
     if m_pDB.GetVMetersTable(-1,pTbl)=True then
     for i:=0 to pTbl.m_swAmVMeter-1 do
     Begin
      wMID := pTbl.Items[i].m_swVMID;
      //mL1Module.DelNodeLv(wMID);
      m_blVMeterIndex[wMID] := True;
     End;
    m_pDB.DelGroupTable(-1);
    FreeAllIndex;
    ExecSetGrid;
}
    m_pDB.DelAbonTable(m_nMasterIndex);
    //FreeAllIndex;
    ExecSetGrid;
End;
procedure CL3AbonEditor.OnClickGrid(Sender: TObject; ARow, ACol: Integer);
Begin
    m_nRowIndex := -1;
    if ARow>0 then Begin
     m_nRowIndex := ARow;
     if FsgGrid.Cells[m_nIDIndex,ARow]<>'' then
     Begin
      m_nIndex := StrToInt(FsgGrid.Cells[m_nIDIndex,ARow]);
      ViewChild(m_nIndex);
     End else m_nIndex := -1;
    End;
End;
//Init Layer
procedure CL3AbonEditor.OnInitLayer;
Begin
    //ExecSetTree;
    //ExecInitLayer;
End;

procedure CL3AbonEditor.OnExecute(Sender: TObject);
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
procedure CL3AbonEditor.OnChannelGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
     OnGlGetCellColor(Sender,ARow,ACol,AState,ABrush,AFont);
end;
procedure CL3AbonEditor.OnChannelGetCellType(Sender: TObject; ACol, ARow: Integer;var AEditor: TEditorType);
begin
    with FsgGrid^ do
    case ACol of
     {
     5:Begin
        AEditor := edComboList;
        InitComboPl;
       End;
     }
     5:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'Active.dat');
       End;
    end;
end;
function CL3AbonEditor.GetComboIndex(cbCombo:TComboBox;str:String):Integer;
Var
    i : Integer;
Begin
    Result:=0;
    for i:=0 to cbCombo.Items.Count-1 do
    Begin
      if cbCombo.Items[i]=str then
      Begin
       Result := i;
       exit;
      End;
    End;
End;
procedure CL3AbonEditor.SendMSG(byBox,byFor,byType:Byte);
Var
    pMsg : CHMessage;
Begin
    With pMsg do
    Begin
    m_swLen       := 13;
    m_swObjID     := m_nIndex;
    m_sbyFrom     := byFor;
    m_sbyFor      := byFor;
    m_sbyType     := byType;
    m_sbyTypeIntID:= 0;
    m_sbyIntID    := m_nMasterIndex;
    m_sbyServerID := 0;
    m_sbyDirID    := 0;
    end;
    FPUT(byBox,@pMsg);
End;

procedure CL3AbonEditor.GenTableChanel;
Var
   GenTable : CEmcosGenTable;
Begin
   GenTable := CEmcosGenTable.Create;
   GenTable.CreateMeterTable(m_nIndex);
End;

procedure CL3AbonEditor.UpdateMeterCode;
Var
   GenTable : CEmcosGenTable;
Begin
   GenTable := CEmcosGenTable.Create;
   GenTable.UpdateCode(m_nIndex);
End;

procedure CL3AbonEditor.OnAddRowRegion_ES;
Begin
    Region_ES.setTreeData(FTreeModuleData);

    Region_ES.setTreeIndex(m_treeID);
    if m_nRowIndex<>-1 then
    Region_ES.OnAddAbon;
    Region_ES.ShowModal;
End;

procedure CL3AbonEditor.OnAddRowAbon;
Begin
    TAbonManager.setTreeData(FTreeModuleData);
    TAbonManager.setTreeIndex(m_treeID);
    TAbonManager.OnAddAbon;
    TAbonManager.aop_AbonPages.ActivePageIndex:=0;
    TAbonManager.ShowModal;
    ExecSetGrid;
End;


end.
