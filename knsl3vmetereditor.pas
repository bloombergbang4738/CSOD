unit knsl3vmetereditor;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,Messages,
  Graphics, Controls, Forms, Dialogs, Spin,
  Grids, BaseGrid, AdvGrid,utlbox,utlconst,utldatabase,knsl1module,
  knsl2module,knsl2treehandler,knsl3vparameditor,knsl2treeloader,knsl5tracer,knsl5config,knsl3setenergo;
type
    SCHANNEL = packed record
     m_sbyPortID   : Integer;
     m_schName     : String[100];
    end;
    PSCHANNEL = ^SCHANNEL;

    SMETER = packed record
     m_sbyPortID    : Byte;
     m_swMID        : WORD;
     m_sbyType      : Byte;
     m_sddPHAddres  : String[30];
     m_schShName    : String[100];
     m_schName      : String[100];
    end;
    PSMETER = ^SMETER;

    CL3VMeterEditor = class
    Private
     FTreeModule    : PTTreeView;
     FComboModule   : PTComboBox;
     m_byTrState    : Byte;
     m_byTrEditMode : Byte;
     m_nPortIndex   : Integer;
     m_nPortID      : Integer;
     m_nMeterIndex  : Integer;
     m_nAbonIndex   : Integer;
     m_nIDIndex     : Integer;
     m_nRowIndex    : Integer;
     m_nRowIndexEx  : Integer;
     m_nAmRecords   : Integer;
     FPageIndex     : Integer;
     m_nIndex       : Integer;
     m_nMasterIndex : Integer;
     m_strCurrentDir: String;
     m_nTypeMeter   : QM_METERS;
     m_nChannelList : TList;
     m_nMtrList     : TList;
     FsgGrid        : PTAdvStringGrid;
     FsgCGrid       : PTAdvStringGrid;
     FChild         : CL3VParamEditor;
     m_sL2Addr      : array of Integer;
     FTreeLoader    : PCTreeLoader;
     m_nPlaneList   : TStringList;
     m_nTehnoLen    : Integer;
     m_treeID       : CTreeIndex;
     constructor Create;
     function  FindRow(str:String):Integer;
     procedure ViewDefault;
     function  GetMeterType:Integer;
     procedure CreateVParamList(nType,nMID:Integer);
     function  GetPortName:String;
     procedure ViewChild(nIndex:Integer);
     procedure OnExecute(Sender: TObject);
     procedure ExecEditData;
     procedure ExecAddData;
     procedure ExecDelData;

     procedure AddRecordToGrid(nIndex:Integer;pTbl:PSL3VMETERTAG);
     procedure AddRecordToCGrid(nIndex:Integer;pTbl:PSMETER);
     function  FindFreeRow(nIndex:Integer):Integer;
     procedure SetDefaultRow(i:Integer);
     procedure GetGridRecord(var pTbl:SL3VMETERTAG);
     function  GetComboIndex(cbCombo:TComboBox;str:String):Integer;
     procedure SendMSG(byBox,byFor,byType:Byte);
     procedure ConnectMeter;
     function  GetMeterTIndex(sName:String):Integer;
    Public
     procedure Init;
     destructor Destroy; override;
     procedure ExecSelRowGrid;
     procedure InitCombo;
     procedure InitComboChannel;
     procedure InitComboPl;
     procedure OnFormResize;
     procedure OnChannelGetCellColor(Sender: TObject; ARow,
               ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
     procedure OnChannelGetCellType(Sender: TObject; ACol,
               ARow: Integer; var AEditor: TEditorType);
     procedure OnChandgeComboVL3(ACol, ARow,
               AItemIndex: Integer; ASelection: String);
     procedure OnClickGrid(Sender: TObject; ARow, ACol: Integer);
     procedure OnClickGridVChannel(Sender: TObject; ARow, ACol: Integer);
     procedure OnChandgeChannel;
     procedure ExecSetEditData(nIndex:Integer);
     procedure ExecInitLayer;
     procedure ExecSetTree;
     procedure ExecSetGrid;
     procedure ExecSetCGrid;
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
     procedure OnConnect;
     procedure OnDropVChannel;
     procedure SetEdit;
     procedure OpenInfo;
     procedure CloseInfo;
     procedure setTreeIndex(value:CTreeIndex);
    Public
     property PTreeModule  :PTTreeView       read FTreeModule    write FTreeModule;
     property PComboModule :PTComboBox       read FComboModule   write FComboModule;
     property PsgGrid      :PTAdvStringGrid  read FsgGrid        write FsgGrid;
     property PsgCGrid     :PTAdvStringGrid  read FsgCGrid       write FsgCGrid;
     property PPageIndex   :Integer          read FPageIndex     write FPageIndex;
     property PIndex       :Integer          read m_nIndex       write m_nIndex;
     property PMasterIndex :Integer          read m_nMasterIndex write m_nMasterIndex;
     property PAbonIndex   :Integer          read m_nAbonIndex   write m_nAbonIndex;
     property PChild       :CL3VParamEditor  read FChild         write FChild;
     property PTreeLoader  :PCTreeLoader     read FTreeLoader    write FTreeLoader;
    End;
implementation
constructor CL3VMeterEditor.Create;
Begin

End;
//ExtractFilePath(Application.ExeName)
{
     m_swID          : Word;
     m_swMID         : WORD;
     m_sbyGroupID    : Byte;
     m_swVMID        : WORD;
     m_sMeterName    : String[30];
     m_sVMeterName   : String[30];
}

destructor CL3VMeterEditor.Destroy;
begin
  if FChild <> nil then FreeAndNil(FChild);
  if m_nPlaneList <> nil then FreeAndNil(m_nPlaneList);
  if m_nChannelList <> nil then FreeAndNil(m_nChannelList);
  if m_nMtrList <> nil then FreeAndNil(m_nMtrList);

  inherited;
end;

procedure CL3VMeterEditor.Init;
Var
    i : Integer;
Begin
    m_strCurrentDir := ExtractFilePath(Application.ExeName) + '\\Settings\\';
    //for i:=0 to MAX_VMETER do m_blVMeterIndex[i] := True;
    m_nMtrList        := TList.Create;
    m_nChannelList      := TList.Create;
    m_nPlaneList        := TStringList.Create;
    m_nPortIndex        := -1;
    m_nPortID           := -1;
    m_nRowIndex         := -1;
    m_nRowIndexEx       := 1;
    m_nMeterIndex       := -1;
    m_nIDIndex          := 6;
    //FTreeModule.Color   := KNS_COLOR;
    //FComboModule.Color  := KNS_COLOR;

    FsgGrid.Color       := KNS_NCOLOR;
    FsgGrid.ColCount    := 14;
    FsgGrid.RowCount    := 200;
    FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := 'ID';
    FsgGrid.Cells[2,0]  := 'MID';
    FsgGrid.Cells[3,0]  := 'PRID';
    FsgGrid.Cells[4,0]  := 'TPID';
    FsgGrid.Cells[5,0]  := 'GID';
    FsgGrid.Cells[6,0]  := 'VMID';

    FsgGrid.Cells[7,0]  := '�.�����';
    FsgGrid.Cells[8,0]  := '������';
    FsgGrid.Cells[9,0]  := '�����';

    FsgGrid.Cells[10,0]  := '����� �����';
    FsgGrid.Cells[11,0] := '������.';
    FsgGrid.Cells[12,0] := '�������� ����';
    FsgGrid.Cells[13,0] := '����������';

    FsgGrid.ColWidths[0] := 30;
    FsgGrid.ColWidths[1] := 0;
    FsgGrid.ColWidths[2] := 0;
    FsgGrid.ColWidths[3] := 0;
    FsgGrid.ColWidths[4] := 0;
    FsgGrid.ColWidths[5] := 0;
    FsgGrid.ColWidths[6] := 0;
    FsgGrid.ColWidths[7] := 0;
    FsgGrid.ColWidths[8] := 0;
    FsgGrid.ColWidths[9] := 0;
    FsgGrid.ColWidths[10]:= 150;
    m_nTehnoLen          := 7*0+0+0+150;
  {
     m_sbyPortID    : Byte;
     m_swMID        : WORD;
     m_sbyType      : Byte;
     m_schName      : String[30];
}
    FsgCGrid.Color       := KNS_NCOLOR;
    FsgCGrid.ColCount    := 5;
    FsgCGrid.RowCount    := 200;
    FsgCGrid.Cells[0,0]  := '�/T';
    FsgCGrid.Cells[1,0]  := '����';
    FsgCGrid.Cells[2,0]  := '����.';
    FsgCGrid.Cells[3,0]  := '���';
    FsgCGrid.Cells[4,0]  := '��������';
    FsgCGrid.ColWidths[0]:= 0;
    FsgCGrid.ColWidths[1]:= 35;
    FsgCGrid.ColWidths[2]:= 35;
    FsgCGrid.ColWidths[3]:= 60;


    FChild              := CL3VParamEditor.Create;
    FChild.PPageIndex   := 3;

    InitComboChannel;
    InitCombo;
    InitComboPl;
    ExecSetCGrid;
    //ExecSetTree;
    //ExpandTree(FTreeModule^,'������');
    //ExecSetGrid;
End;
procedure CL3VMeterEditor.OpenInfo;
Begin
    FsgGrid.ColWidths[0] := 30;
    FsgGrid.ColWidths[1] := 30;
    FsgGrid.ColWidths[2] := 30;
    FsgGrid.ColWidths[3] := 30;
    FsgGrid.ColWidths[4] := 30;
    FsgGrid.ColWidths[5] := 30;
    FsgGrid.ColWidths[6] := 30;
    FsgGrid.ColWidths[7] := 30;
    FsgGrid.ColWidths[8] := 0;
    FsgGrid.ColWidths[9] := 55;
    FsgGrid.ColWidths[10]:= 150;
    m_nTehnoLen          := 7*30+0+55+150;
    OnFormResize;
End;
procedure CL3VMeterEditor.CloseInfo;
Begin
    FsgGrid.ColWidths[0] := 30;
    FsgGrid.ColWidths[1] := 0;
    FsgGrid.ColWidths[2] := 0;
    FsgGrid.ColWidths[3] := 0;
    FsgGrid.ColWidths[4] := 0;
    FsgGrid.ColWidths[5] := 0;
    FsgGrid.ColWidths[6] := 0;
    FsgGrid.ColWidths[7] := 0;
    FsgGrid.ColWidths[8] := 0;
    FsgGrid.ColWidths[9] := 0;
    FsgGrid.ColWidths[10]:= 150;
    m_nTehnoLen          := 7*0+0+0+150;
    OnFormResize;
End;
procedure CL3VMeterEditor.OnFormResize;
Var
    i : Integer;
Begin
    for i:=11 to FsgGrid.ColCount-1  do
    FsgGrid.ColWidths[i]  := trunc((FsgGrid.Width-(m_nTehnoLen)-2*FsgGrid.ColWidths[0])/(FsgGrid.ColCount-1-10));

    for i:=4 to FsgCGrid.ColCount-1  do
    FsgCGrid.ColWidths[i]  := trunc((FsgCGrid.Width-(70+60)-2*FsgCGrid.ColWidths[0])/(FsgCGrid.ColCount-1-3));

    FChild.OnFormResize;
End;
{
procedure CL3VMeterEditor.ExecSetGrid;
Var
    m_sTbl : SL3GROUPTAG;
    i : Integer;
Begin
    //m_nRowIndex := -1;
    FsgGrid.ClearNormalCells;
    //FreeAllIndex;
    if m_pDB.GetVMetersTable(m_nMasterIndex,m_sTbl)=True then
    Begin
     m_nAmRecords := m_sTbl.m_swAmVMeter;
     for i:=0 to m_sTbl.m_swAmVMeter-1 do
     AddRecordToGrid(i,@m_sTbl.Item.Items[i]);
      RestoreIndex;
     ViewDefault;
    End;
End;
}
procedure CL3VMeterEditor.SetEdit;
Begin
End;
procedure CL3VMeterEditor.setTreeIndex(value:CTreeIndex);
Begin
    m_treeID := value;
End;
{
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
}

procedure CL3VMeterEditor.InitComboChannel;
Var
    pTable : SL3ABONS;
    pCnl   : PSCHANNEL;
    i      : Integer;
Begin
    if m_pDB.GetMetersTypeTable(m_nTypeMeter) then Begin
    m_nChannelList.Clear;
    FComboModule.Items.Clear;
    if m_pDB.GetAbonTable(m_treeID.PAID,pTable) then
    Begin
     for i:=0 to pTable.Count-1 do
     Begin
      New(pCnl);
      pCnl.m_sbyPortID := pTable.Items[i].m_swABOID;
      pCnl.m_schName   := pTable.Items[i].m_sName;
      m_nChannelList.Add(pCnl);
      FComboModule.Items.Add(pCnl.m_schName);
     End;
    m_nPortIndex           := 0;
    m_nPortID              := pTable.Items[0].m_swABOID;
    FComboModule.ItemIndex := 0;
    End;
    End;
End;

{procedure CL3VMeterEditor.InitComboChannel;
Var
    pTable : SL1INITITAG;
    pCnl   : PSCHANNEL;
    i      : Integer;
Begin
    if m_pDB.GetMetersTypeTable(m_nTypeMeter) then Begin
    m_nChannelList.Clear;
    FComboModule.Items.Clear;
    if m_pDB.GetL1Table(pTable) then
    Begin
     for i:=0 to pTable.Count-1 do
     Begin
      New(pCnl);
      pCnl.m_sbyPortID := pTable.Items[i].m_sbyPortID;
      pCnl.m_schName   := pTable.Items[i].m_schName;
      m_nChannelList.Add(pCnl);
      FComboModule.Items.Add(pCnl.m_schName);
     End;
    m_nPortIndex           := 0;
    m_nPortID              := pTable.Items[0].m_sbyPortID;
    FComboModule.ItemIndex := 0;
    End;
    End;
End;
}
procedure CL3VMeterEditor.InitComboPl;
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
procedure CL3VMeterEditor.OnChandgeChannel;
Var
    nIndex : Integer;
    pCnl   : PSCHANNEL;
Begin
    nIndex       := FComboModule.ItemIndex;
    m_nPortIndex := nIndex;
    pCnl         := m_nChannelList.Items[nIndex];
    m_nPortID    := pCnl.m_sbyPortID;
    InitCombo;
    ExecSetCGrid;
End;
procedure CL3VMeterEditor.InitCombo;
Var
    pTable : SL2INITITAG;
    pMtr   : PSMETER;
    i      : Integer;
    str    : String;
Begin
    if m_pDB.GetMetersTable(m_treeID.PAID,pTable) then
    Begin
     m_nMtrList.Clear;
     FsgGrid.Combobox.Items.Clear;
     SetLength(m_sL2Addr,pTable.m_swAmMeter);
     for i:=0 to pTable.m_swAmMeter-1 do
     Begin
      with pTable.m_sMeter[i] do
      Begin
       New(pMtr);
       pMtr.m_sbyPortID    := m_nPortID;
       pMtr.m_swMID        := m_swMID;
       pMtr.m_sddPHAddres  := m_sddPHAddres;
       pMtr.m_sbyType      := m_sbyType;
       pMtr.m_schShName    := m_schName;
       str := GetPortName+':'+m_schName;
       pMtr.m_schName      := str;
       m_nMtrList.Add(pMtr);
       FsgGrid.Combobox.Items.Add(str);
      End;
     End;
    End;
End;

procedure CL3VMeterEditor.ExecSetCGrid;
Var
    pMtr : PSMETER;
    i    : Integer;
Begin
    FsgCGrid.ClearNormalCells;
    FsgCGrid.TopRow := 1;
    for i:=0 to m_nMtrList.Count-1 do
    Begin
     pMtr := m_nMtrList.Items[i];
     AddRecordToCGrid(i,pMtr)
    End;
End;
procedure CL3VMeterEditor.AddRecordToCGrid(nIndex:Integer;pTbl:PSMETER);
Var
   nY : Integer;
   nVisible : Integer;
Begin
    nY := nIndex+1;
    nVisible := round(FsgCGrid.Height/21);
    //if (nY-nVisible)>0  then FsgCGrid.TopRow := nY-nVisible;
    with pTbl^ do Begin
     FsgCGrid.Cells[0,nY] := IntToStr(nY);
     FsgCGrid.Cells[1,nY] := IntToStr(pTbl.m_sbyPortID);
     FsgCGrid.Cells[2,nY] := IntToStr(pTbl.m_swMID);
     FsgCGrid.Cells[3,nY] := m_nTypeMeter.m_sMeterType[m_sbyType].m_sName;
     FsgCGrid.Cells[4,nY] := m_schName;
    End;
    if nY>FsgCGrid.RowCount then
    FsgCGrid.RowCount := FsgCGrid.RowCount + 1;

End;
procedure CL3VMeterEditor.CreateVParamList(nType,nMID:Integer);
Begin
    //OnSaveGrid;
    m_pDB.InsertVParams(nType,nMID);
End;

procedure CL3VMeterEditor.OnClickGridVChannel(Sender: TObject; ARow, ACol: Integer);
Var
    nIndex : Integer;
    pCnl   : PSMETER;
Begin
    if ARow<>0 then
    Begin
     if Length(FsgCGrid.Cells[2,ARow])<>0 then
      m_nMeterIndex := ARow-1;
      //m_nMtrList
    End;
End;
{
FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := 'ID';
    FsgGrid.Cells[2,0]  := 'MID';
    FsgGrid.Cells[3,0]  := 'PRID';
    FsgGrid.Cells[4,0]  := 'TPID';
    FsgGrid.Cells[5,0]  := 'GID';
    FsgGrid.Cells[6,0]  := 'VMID';

    FsgGrid.Cells[7,0]  := '������';
    FsgGrid.Cells[8,0]  := '���.�����';
    FsgGrid.Cells[9,0]  := '����� �����';
    FsgGrid.Cells[10,0] := '����������';
}
procedure CL3VMeterEditor.OnConnect;
Var
    pCnl : PSMETER;
Begin
    if (m_nMeterIndex<>-1) and (m_nMeterIndex<=m_nMtrList.Count) then
    if m_nIndex<>-1 then
    if m_nRowIndex<>-1 then
    Begin
     pCnl := m_nMtrList.Items[m_nMeterIndex];
     FsgGrid.Cells[2,m_nRowIndex] := IntToStr(pCnl.m_swMID);
     FsgGrid.Cells[3,m_nRowIndex] := IntToStr(pCnl.m_sbyPortID);
     //FsgGrid.Cells[4,m_nRowIndex] := m_nTypeMeter.m_sMeterType[pCnl.m_sbyType].m_sName;
     FsgGrid.Cells[4,m_nRowIndex] := IntToStr(pCnl.m_sbyType);
     FsgGrid.Cells[7,m_nRowIndex] := pCnl.m_sddPHAddres;
     FsgGrid.Cells[8,m_nRowIndex] := pCnl.m_schName;
     FsgGrid.Cells[9,m_nRowIndex] := 'MCode:'+FsgGrid.Cells[6,m_nRowIndex];
     FsgGrid.Cells[10,m_nRowIndex] := pCnl.m_schShName;
     FsgGrid.Cells[11,m_nRowIndex] := m_nActiveExList.Strings[1];
     CreateVParamList(pCnl.m_sbyType,m_nIndex);
    End;
End;
procedure CL3VMeterEditor.OnDropVChannel;
Begin
    InitComboChannel;
End;




function CL3VMeterEditor.GetPortName:String;
Var
    str  : String;
    pCnl : PSCHANNEL;
Begin
    if m_nPortIndex<>-1 then
    Begin
     pCnl   := m_nChannelList.Items[m_nPortIndex];
     Result := pCnl.m_schName;
    End else
    Result := ' ';
End;
function CL3VMeterEditor.GetMeterTIndex(sName:String):Integer;
Var
    i : Integer;
Begin
    Result := 0;
    for i:=0 to m_nTypeMeter.m_swAmMeterType-1 do
    Begin
     if m_nTypeMeter.m_sMeterType[i].m_sName=sName then
     Result := m_nTypeMeter.m_sMeterType[i].m_swType
    End;
End;
procedure CL3VMeterEditor.ConnectMeter;
Var
   nIndex : Integer;
Begin

End;
//Edit Add Del Request
procedure CL3VMeterEditor.OnEditNode;
begin
    m_byTrEditMode                  := ND_EDIT;
    InitCombo;
    ExecSetEditData(m_nIndex);
end;
procedure CL3VMeterEditor.OnAddNode;
begin
    m_byTrEditMode                   := ND_ADD;
    InitCombo;
end;
procedure CL3VMeterEditor.OnDeleteNode;
Begin
    m_byTrEditMode                   := ND_DEL;
    InitCombo;
    ExecSetEditData(m_nIndex);
End;
//Edit Add Del Execute
procedure CL3VMeterEditor.ExecSetEditData(nIndex:Integer);
Var
    m_sTbl : SL3VMETERTAG;
Begin
    TraceL(3,0,'ExecSetEditData.');
    m_sTbl.m_swVMID        := m_nIndex;
    m_sTbl.m_sbyGroupID    := m_nMasterIndex;
End;
procedure CL3VMeterEditor.ExecEditData;
Var
    m_sTbl : SL3VMETERTAG;
Begin
    TraceL(3,0,'ExecEditData.');
    m_pDB.SetVMeterTable(m_sTbl);
End;
procedure CL3VMeterEditor.ExecAddData;
Var
    m_sTbl : SL3VMETERTAG;
Begin
    TraceL(3,0,'ExecAddData.');
End;
procedure CL3VMeterEditor.ExecDelData;
Begin
    TraceL(3,0,'ExecDelData.');
    //mL2Module.DelNodeLv(m_nIndex);
    m_pDB.DelVMeterTable(m_nMasterIndex,m_nIndex);
End;
procedure CL3VMeterEditor.ExecInitLayer;
Begin
    TraceL(3,0,'ExecInitLayer.');
    //mL2Module.Init;
    //SendMSG(BOX_L3,DIR_L2TOL3,DL_STARTSNDR_IND);
End;
//Tree Reload
procedure CL3VMeterEditor.ExecSetTree;
Begin
    TraceL(1,0,'ExecSetTree.');
    FTreeLoader.LoadTree;
End;
//Grid Routine
procedure CL3VMeterEditor.ExecSetGrid;
Var
    m_sTbl : SL3GROUPTAG;
    i : Integer;
Begin
    FsgGrid.ClearNormalCells;
    //FsgGrid.RowCount := 40; 
    if m_pDB.GetVMetersTable(m_nMasterIndex,m_sTbl)=True then
    Begin
     m_nAmRecords := m_sTbl.m_swAmVMeter;
     for i:=0 to m_sTbl.m_swAmVMeter-1 do
     Begin
      AddRecordToGrid(i,@m_sTbl.Item.Items[i]);
     End;
     ViewDefault;
    End else ViewChild($ffff);
End;
{
procedure CL3VMeterEditor.RestoreIndex;
var
  i,j:integer;
  m_sTbl : SL3GROUPTAG;
  pTblG :SL3INITTAG;
begin
     for i:=0 to MAX_VMETER do m_blVMeterIndex[i] := True;
     if m_pDB.GetGroupsTable(pTblG)=True then
    Begin
      for i:=0 to pTblG.Count-1 do
      Begin
       if m_pDB.GetVMetersTable(pTblG.Items[i].m_sbyGroupID,m_sTbl)=True then
       Begin
         for j:=0 to m_sTbl.m_swAmVMeter-1 do
                m_blVMeterIndex[m_sTbl.Item.Items[j].m_swVMID] := false;
        end;
       end;
    end;
end;
}
procedure CL3VMeterEditor.ViewDefault;
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
procedure CL3VMeterEditor.AddRecordToGrid(nIndex:Integer;pTbl:PSL3VMETERTAG);
Var
   nY : Integer;
   nVisible : Integer;
Begin
    nY := nIndex+1;
    nVisible := round(FsgGrid.Height/21);
    //if (nY-nVisible)>0  then FsgGrid.TopRow := nY-nVisible;
    with pTbl^ do Begin
     FsgGrid.Cells[0,nY]  := IntToStr(nY);
     FsgGrid.Cells[1,nY]  := IntToStr(m_swID);
     FsgGrid.Cells[2,nY]  := IntToStr(m_swMID);
     FsgGrid.Cells[3,nY]  := IntToStr(m_sbyPortID);
     FsgGrid.Cells[4,nY]  := IntToStr(m_sbyType);
     //FsgGrid.Cells[4,nY]  := m_nTypeMeter.m_sMeterType[m_sbyType].m_sName;

     FsgGrid.Cells[5,nY]  := IntToStr(m_sbyGroupID);
     FsgGrid.Cells[6,nY]  := IntToStr(m_swVMID);
     FsgGrid.Cells[7,nY]  := m_sddPHAddres;
     FsgGrid.Cells[8,nY]  := m_sMeterName;
     FsgGrid.Cells[9,nY]  := m_sMeterCode;
     FsgGrid.Cells[10,nY]  := m_sVMeterName;
     FsgGrid.Cells[11,nY] := m_nActiveExList.Strings[m_sbyExport];
     if (m_nPlaneList.Count=0)or(m_swPLID<0)or(m_swPLID>=m_nPlaneList.Count) then FsgGrid.Cells[12,nY]:='����' else
     FsgGrid.Cells[12,nY] := m_nPlaneList.Strings[m_swPLID];
     FsgGrid.Cells[13,nY] := m_nActiveList.Strings[m_sbyEnable];
    End;
    if nY>FsgGrid.RowCount then
    Begin
     FsgGrid.RowCount := FsgGrid.RowCount + 1;
     FsgGrid.RowHeights[nY-1] := nSizeFont+17;
    End;
End;
procedure CL3VMeterEditor.OnSetGrid;
Begin
    ExecSetGrid;
End;
{
     pVMETID   := m_pDB.addVMeterId(l3Data);
     m_pDB.InsertVParams(l3Data.m_sbyType,pVMETID);     //AAV 27.04.2017

}
procedure CL3VMeterEditor.OnSaveGrid;
Var
    i : Integer;
    pTbl:SL3VMETERTAG;
Begin
    for i:=1 to FsgGrid.RowCount-1 do
    Begin
     if FsgGrid.Cells[1,i]='' then break;
     pTbl.m_swID := i;
     GetGridRecord(pTbl);
     m_pDB.addVMeterId(pTbl);
     {if m_pDB.AddVMeterTable(pTbl)=True then
     Begin
      SetIndex(pTbl.m_swVMID);
     End;}
    End;
    //ExecInitLayer;
    ExecSetGrid;
    //m_nEN.Init;
End;
{
FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := 'ID';
    FsgGrid.Cells[2,0]  := 'MID';
    FsgGrid.Cells[3,0]  := 'PRID';
    FsgGrid.Cells[4,0]  := 'TPID';
    FsgGrid.Cells[5,0]  := 'GID';
    FsgGrid.Cells[6,0]  := 'VMID';

    FsgGrid.Cells[8,0]  := '���.�����';
    FsgGrid.Cells[7,0]  := '������';

    FsgGrid.Cells[9,0]  := '����� �����';
    FsgGrid.Cells[10,0] := '����������';
}
procedure CL3VMeterEditor.GetGridRecord(var pTbl:SL3VMETERTAG);
Var
    i : Integer;
    str : String;
Begin
    i := pTbl.m_swID;
    with pTbl do Begin
     pTbl.m_swID        := StrToInt(FsgGrid.Cells[1,i]);
     pTbl.m_swMID       := StrToInt(FsgGrid.Cells[2,i]);
     pTbl.m_sbyPortID   := StrToInt(FsgGrid.Cells[3,i]);
     pTbl.m_sbyType     := StrToInt(FsgGrid.Cells[4,i]);
     //pTbl.m_sbyType     := GetMeterTIndex(FsgGrid.Cells[4,i]);
     pTbl.m_sbyGroupID  := StrToInt(FsgGrid.Cells[5,i]);
     pTbl.m_swVMID      := StrToInt(FsgGrid.Cells[6,i]);
     pTbl.m_sddPHAddres := FsgGrid.Cells[7,i];
     pTbl.m_sMeterName  := FsgGrid.Cells[8,i];
     pTbl.m_sMeterCode  := FsgGrid.Cells[9,i];
     pTbl.m_sVMeterName := FsgGrid.Cells[10,i];
     pTbl.m_sbyExport   := m_nActiveExList.IndexOf(FsgGrid.Cells[11,i]);
     pTbl.m_swPLID      := m_nPlaneList.IndexOf(FsgGrid.Cells[12,i]);
     pTbl.m_sbyEnable   := m_nEsNoList.IndexOf(FsgGrid.Cells[13,i]);
    End;
End;
procedure CL3VMeterEditor.SetDefaultRow(i:Integer);
Begin
    if FsgGrid.Cells[0,i]=''  then FsgGrid.Cells[0,i]  := IntToStr(i);
    if FsgGrid.Cells[1,i]=''  then FsgGrid.Cells[1,i]  := '0';
    if FsgGrid.Cells[2,i]=''  then FsgGrid.Cells[2,i]  := '0';

    if FsgGrid.Cells[3,i]=''  then FsgGrid.Cells[3,i]  := '0';
    if FsgGrid.Cells[4,i]=''  then FsgGrid.Cells[4,i]  := '0';

    if FsgGrid.Cells[5,i]=''  then FsgGrid.Cells[5,i]  := IntToStr(m_nMasterIndex);
    if FsgGrid.Cells[6,i]=''  then FsgGrid.Cells[6,i]  := '-1';
    if FsgGrid.Cells[7,i]=''  then FsgGrid.Cells[7,i]  := 'Addres X';
    if FsgGrid.Cells[8,i]=''  then FsgGrid.Cells[8,i]  := 'Counter '+FsgGrid.Cells[m_nIDIndex,i];
    if FsgGrid.Cells[9,i]=''  then FsgGrid.Cells[9,i]  := 'Code '+FsgGrid.Cells[m_nIDIndex,i];
    if FsgGrid.Cells[10,i]=''  then FsgGrid.Cells[10,i]:= 'Counter '+FsgGrid.Cells[m_nIDIndex,i];
    if FsgGrid.Cells[11,i]='' then FsgGrid.Cells[11,i] := m_nActiveExList.Strings[0];
    if FsgGrid.Cells[12,i]='' then Begin if m_nPlaneList.Count<>0 then FsgGrid.Cells[12,i] := m_nPlaneList.Strings[0] else FsgGrid.Cells[12,i] :='����� �� ���������'; End;
    if FsgGrid.Cells[13,i]='' then FsgGrid.Cells[13,i] := m_nActiveList.Strings[1];
End;
procedure CL3VMeterEditor.ExecSelRowGrid;
Begin
    FsgGrid.SelectRows(FindRow(IntToStr(m_nIndex)),1);
    FsgGrid.Refresh;
    ViewChild(m_nIndex);
End;
function CL3VMeterEditor.FindRow(str:String):Integer;
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
procedure CL3VMeterEditor.ViewChild(nIndex:Integer);
Begin
    if m_blCL3VMetEditor=False then
    if FChild<>Nil then
    Begin
     FChild.PAbonIndex   := m_nAbonIndex;
     FChild.PGroupIndex  := m_nMasterIndex;
     FChild.PMasterIndex := nIndex;
     FChild.PTypeIndex   := GetMeterType;
     FChild.ExecSetGrid;
    End;
End;

function CL3VMeterEditor.GetMeterType:Integer;
Var
    pMtr : PSMETER;
    i    : Integer;
Begin
    for i:=0 to m_nMtrList.Count-1 do
    Begin
     pMtr := m_nMtrList.Items[i];
     if pMtr.m_swMID=m_nIndex then
     Begin
      Result := pMtr.m_sbyType;
      exit;
     End
    End;
End;


function CL3VMeterEditor.FindFreeRow(nIndex:Integer):Integer;
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
procedure CL3VMeterEditor.OnAddRow;
Var
    nIndex : Integer;
Begin
    if m_nRowIndex<>-1 then
    Begin
     SetDefaultRow(m_nRowIndex);
    End else
    Begin
     nIndex := FindFreeRow(3);
     SetDefaultRow(nIndex);
    End;
End;
procedure CL3VMeterEditor.OnCloneRow;
Var
    nIndex : Integer;
    pTbl   : SL3VMETERTAG;
Begin
    if m_nRowIndex<>-1 then
    if m_nRowIndex<=FindFreeRow(m_nIDIndex)-1 then
    Begin
     pTbl.m_swID   := m_nRowIndex;
     GetGridRecord(pTbl);
     pTbl.m_swVMID := -1;
     AddRecordToGrid(FindFreeRow(m_nIDIndex)-1,@pTbl);
    End;
End;
procedure CL3VMeterEditor.OnDelRow;
Var
    nFind : Integer;
Begin
    if m_nAmRecords=FindFreeRow(m_nIDIndex)-1 then
    Begin
     if m_nIndex<>-1 then
     Begin
      m_pDB.DelVMeterTable(m_nMasterIndex,m_nIndex);
      SetEdit;
      ExecSetGrid;
      ViewChild(m_nIndex);
     End;
    End else
    Begin
     if m_nRowIndex<>-1 then
     Begin
      FsgGrid.ClearRows(m_nRowIndex,1);
     End;
    End;
End;
procedure CL3VMeterEditor.OnDelAllRow;
Begin
    m_pDB.DelVMeterTable(m_nMasterIndex,-1);
    SetEdit;
    ExecSetGrid;
End;
procedure CL3VMeterEditor.OnClickGrid(Sender: TObject; ARow, ACol: Integer);
Begin
    m_nRowIndex   := -1;
    m_nRowIndexEx := -1;
    if ARow>0 then Begin
     m_nRowIndex   := ARow;
     m_nRowIndexEx := ARow;
     if FsgGrid.Cells[m_nIDIndex,ARow]<>'' then
     Begin
      m_nIndex := StrToInt(FsgGrid.Cells[m_nIDIndex,ARow]);
      ViewChild(m_nIndex);
     End else m_nIndex := -1;
    End;
End;
//Init Layer
procedure CL3VMeterEditor.OnInitLayer;
Begin
    //ExecSetTree;
    ExecInitLayer;
End;
procedure CL3VMeterEditor.OnExecute(Sender: TObject);
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
procedure CL3VMeterEditor.OnChannelGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
     OnGlGetCellColor(Sender,ARow,ACol,AState,ABrush,AFont);
end;
procedure CL3VMeterEditor.OnChannelGetCellType(Sender: TObject; ACol, ARow: Integer;var AEditor: TEditorType);
begin

    with FsgGrid^ do
    case ACol of
     8:Begin
        AEditor := edComboList;
        InitCombo;
       End;
     11:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'ActiveEx.dat');
       End;
     13:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'Active.dat');
       End;
     12 : Begin
        AEditor := edComboList;
        InitComboPl;
       End;
    end;

end;
procedure CL3VMeterEditor.OnChandgeComboVL3(ACol, ARow,
               AItemIndex: Integer; ASelection: String);
Var
    pMtr : PSMETER;
Begin
    try
    if m_nIndex<>-1 then
    if ACol=8 then
    Begin
     pMtr := m_nMtrList.Items[AItemIndex];
     FsgGrid.Cells[2,ARow] := IntToStr(pMtr.m_swMID);
     CreateVParamList(pMtr.m_sbyType,m_nIndex);
     //CreateVParamList(pMtr.m_swMID,m_nIndex);
    End;
    except
    end;
End;
function CL3VMeterEditor.GetComboIndex(cbCombo:TComboBox;str:String):Integer;
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
procedure CL3VMeterEditor.SendMSG(byBox,byFor,byType:Byte);
Var
    pMsg : CHMessage;
Begin
    With pMsg do
    Begin
    m_swLen       := 11;
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
end.
