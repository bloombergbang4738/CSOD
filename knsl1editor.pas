unit knsl1editor;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,Messages,
  Graphics, Controls, Forms, Dialogs, Spin,
  Grids, BaseGrid, AdvGrid,utlbox,utlconst,utldatabase,knsl1module,
  knsl2module,knsl3module,knsl2editor,knsl2treeloader,knsl5tracer,knsl5config, knsl2BTIInit, knsl5MainEditor;
type
    CL1Editor = class
    Private
     FTreeModule    : PTTreeView;
     m_byTrState    : Byte;
     m_byTrEditMode : Byte;
     m_nRowIndex    : Integer;
     pullDSId       : Integer;
     pullDSRow      : Integer;
     pullPLId       : Integer;
     pullPLRow      : Integer;
     m_nAmRecords   : Integer;
     m_nPageIndex   : Integer;
     m_nIndex       : Integer;
     m_nIDIndex     : Integer;
     m_strCurrentDir: String;
     FAdvPullDesc   : PTAdvStringGrid;
     FAdvSgPulls    : PTAdvStringGrid;
     FsgGrid        : PTAdvStringGrid;
     FChild         : CL2Editor;
     FTreeLoader    : PCTreeLoader;
     m_nTehnoLen    : Integer;
     constructor Create;
     function  FindRow(str:String):Integer;
     procedure ViewChild(nIndex:Integer);
     procedure OnExecute(Sender: TObject);
     procedure ExecEditData;
     procedure ExecAddData;
     procedure ExecDelData;

     procedure AddRecordToGrid(nIndex:Integer;pTbl:PSL1TAG);
     function  SetIndex(nIndex : Integer):Integer;
     function  GenIndex:Integer;
     function  GenIndexSv:Integer;
     procedure FreeAllIndex;
     procedure FreeIndex(nIndex : Integer);
     function  FindFreeRow(nIndex:Integer;adcSG:PTAdvStringGrid):Integer;
     procedure GetGridRecord(var pTbl:SL1TAG);
    Public
     procedure Init;
     function  getIDFromStr(str:String):Integer;
     procedure SetDefaultRowDs(i:Integer);
     procedure SetDefaultRowPl(i:Integer);
     procedure ExecSelRowGrid;
     procedure OnFormResize;
     procedure OnChannelGetCellColor(Sender: TObject; ARow,
               ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
     procedure OnChannelGetCellType(Sender: TObject; ACol,
               ARow: Integer; var AEditor: TEditorType);
     procedure OnClickGrid(Sender: TObject; ARow, ACol: Integer);
     procedure SetDefaultRow(i:Integer);
     procedure ExecSetEditData(nIndex:Integer);
     procedure ExecInitLayer;
     procedure ExecSetTree;
     procedure ExecSetGrid;
     procedure ExecSetGridPullDs;
     procedure ExecSetGridPull(pullID:Integer);
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
     procedure ExecMainEditor;
     procedure OpenInfo;
     procedure CloseInfo;
     procedure nmItSaveClick;
     procedure nmItRead;
     procedure nmItCreate;
     procedure nmItClone;
     procedure nmItDelOne;
     procedure nmItDelAll;

     procedure nmItSavePl;
     procedure nmItReadPl;
     procedure nmItCreatePl;
     procedure nmItClonePl;
     procedure nmItDelOnePl;
     procedure nmItDelAllPl;


    Public
     property PTreeModule :PTTreeView       read FTreeModule  write FTreeModule;
     property PsgGrid     :PTAdvStringGrid  read FsgGrid      write FsgGrid;
     property PAdvPullDesc:PTAdvStringGrid  read FAdvPullDesc write FAdvPullDesc;
     property PAdvSgPulls :PTAdvStringGrid  read FAdvSgPulls  write FAdvSgPulls;
     property PPageIndex  :Integer          read m_nPageIndex write m_nPageIndex;
     property PIndex      :Integer          read m_nIndex     write m_nIndex;
     //property PChild      :CL2Editor        read FChild       write FChild;
     property PTreeLoader :PCTreeLoader     read FTreeLoader  write FTreeLoader;
    End;
implementation
constructor CL1Editor.Create;
Begin

End;
procedure CL1Editor.Init;
Var
    i : Integer;
Begin
    m_strCurrentDir := ExtractFilePath(Application.ExeName) + '\\Settings\\';
    for i:=0 to MAX_PORT  do m_blPortIndex[i]  := True;
    //for i:=0 to MAX_METER do m_blMeterIndex[i] := True;
    pullDSId     := -1;
    m_nRowIndex  := -1;
    m_nPageIndex := 0;
    m_nIDIndex   := 1;
    FsgGrid.Color       := KNS_NCOLOR;
    FsgGrid.ColCount    := 19;
    FsgGrid.RowCount    := MAX_PORT;//180;
    FsgGrid.Cells[0,0]  := '�/T';
    FsgGrid.Cells[1,0]  := '����ID';
    FsgGrid.Cells[2,0]  := '��������';
    FsgGrid.Cells[3,0]  := '�����';
    FsgGrid.Cells[4,0]  := '���';          //m_sbyControl
    FsgGrid.Cells[5,0]  := '��� ���������';
    FsgGrid.Cells[6,0]  := '����������';          //m_sbyControl
    FsgGrid.Cells[7,0]  := '����� ����.';          //m_sbyControl
    FsgGrid.Cells[8,0]  := '�����������';          //m_sbyControl
    FsgGrid.Cells[9,0]  := '��������';
    FsgGrid.Cells[10,0]  := '�������';
    FsgGrid.Cells[11,0]  := '������';
    FsgGrid.Cells[12,0]  := '���� ���';
    FsgGrid.Cells[13,0] := '��.������';
    FsgGrid.Cells[14,0] := '�����';
    FsgGrid.Cells[15,0] := '�������.';
    FsgGrid.Cells[16,0] := '���.';
    FsgGrid.Cells[17,0] := 'IP ����';
    FsgGrid.Cells[18,0] := 'IP ���';
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    FsgGrid.ColWidths[2]:= 50;
    FsgGrid.ColWidths[3]:= 20;
    FsgGrid.ColWidths[4]:= 50;
    FsgGrid.ColWidths[5]:= 50;
    FsgGrid.ColWidths[6]:= 50;
    FsgGrid.ColWidths[7]:= 50;
    FsgGrid.ColWidths[8]:= 50;
    FsgGrid.ColWidths[9]:= 50;
    FsgGrid.ColWidths[10]:= 20;
    FsgGrid.ColWidths[11]:= 20;
    FsgGrid.ColWidths[12]:= 20;
    FsgGrid.ColWidths[13]:= 20;
    FsgGrid.ColWidths[14]:= 50;
    FsgGrid.ColWidths[15]:= 50;
    FsgGrid.ColWidths[16]:= 50;
    FsgGrid.ColWidths[17]:= 50;
    FsgGrid.ColWidths[18]:= 100;

    m_nTehnoLen := 0;

    {
         FAdvSgPulls    : PTAdvStringGrid;
     FsgGrid        : PTAdvStringGrid;

     CL2Pulls = class
     public
      ID             : INTEGER;
      PULLTYPE       : String[20];
      DESCRIPTION    : String[50];
      item           : TThreadList;
      procedure clear;
    end;
      CL2Pull = class
     public
      ID                : INTEGER;
      PULLID            : INTEGER;
      CONNECTIONTIMEOUT : INTEGER;
      CONNSTRING        : String[50];
      RECONNECTIONS     : INTEGER;
      STATE             : SMALLINT;
    end;
    PCL2Pull = ^CL2Pull; 

CREATE TABLE L2PULL (
    ID                 INTEGER,
    PULLID             INTEGER,
    CONNECTIONTIMEOUT  INTEGER,
    CONNSTRING         VARCHAR(50),
    RECONNECTIONS      INTEGER,
    STATE              INTEGER
);
    }
    FAdvPullDesc.Color       := KNS_NCOLOR;
    FAdvPullDesc.ColCount    := 3;
    FAdvPullDesc.RowCount    := MAX_PORT;//180;
    FAdvPullDesc.Cells[0,0]  := '�/T';
    FAdvPullDesc.Cells[1,0]  := '���';
    FAdvPullDesc.Cells[2,0]  := '��������';
    FAdvPullDesc.ColWidths[0]:= 30;
    FAdvPullDesc.ColWidths[1]:= 40;

    FAdvSgPulls.Color       := KNS_NCOLOR;
    FAdvSgPulls.ColCount    := 7;
    FAdvSgPulls.RowCount    := 180;
    FAdvSgPulls.Cells[0,0]  := '�/T';
    FAdvSgPulls.Cells[1,0]  := 'PLID';
    FAdvSgPulls.Cells[2,0]  := 'PRID';
    FAdvSgPulls.Cells[3,0]  := '����� �����.';
    FAdvSgPulls.Cells[4,0]  := '������ �����.';
    FAdvSgPulls.Cells[5,0]  := '�-�� ������.';
    FAdvSgPulls.Cells[6,0]  := '����.';
    FAdvSgPulls.ColWidths[0]:= 25;
    FAdvSgPulls.ColWidths[1]:= 30;
    //FAdvSgPulls.ColWidths[2]:= 40;
    //FAdvSgPulls.ColWidths[3]:= 0;
    //FAdvSgPulls.ColWidths[4]:= 40;

    ExecSetGrid;
    //FChild                := CL2Editor.Create;
    //FChild.PPageIndex     := 1;
End;
procedure CL1Editor.OpenInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 45;
    m_nTehnoLen := 45;
    OnFormResize;
End;
procedure CL1Editor.CloseInfo;
Begin
    FsgGrid.ColWidths[0]:= 30;
    FsgGrid.ColWidths[1]:= 0;
    m_nTehnoLen := 0;
    OnFormResize;
End;

procedure CL1Editor.OnFormResize;
Var
    i : Integer;
Begin
//    for i:=2 to FsgGrid.ColCount-1  do FsgGrid.ColWidths[i]  := trunc((FsgGrid.Width-m_nTehnoLen-2*FsgGrid.ColWidths[0])/(FsgGrid.ColCount-1-1));
    for i:=2 to FAdvPullDesc.ColCount-1  do FAdvPullDesc.ColWidths[i]  := trunc((FAdvPullDesc.Width-2*FAdvPullDesc.ColWidths[0])/(FAdvPullDesc.ColCount-1-1));
    for i:=2 to FAdvSgPulls.ColCount-1  do FAdvSgPulls.ColWidths[i]  := trunc((FAdvSgPulls.Width-2*FAdvSgPulls.ColWidths[0])/(FAdvSgPulls.ColCount-1-1));
    //PChild.OnFormResize;
End;
procedure CL1Editor.SetEdit;
Var
    pTbl : SL1INITITAG;
    i    : Integer;
Begin
    m_nRowIndex  := -1;
    FreeAllIndex;
    if m_pDB.GetL1Table(pTbl)=True then for i:=0 to pTbl.Count-1 do SetIndex(pTbl.Items[i].m_sbyPortID);
End;
//Edit Add Del Request
procedure CL1Editor.OnEditNode;
begin
    m_byTrEditMode                  := ND_EDIT;
    ExecSetEditData(m_nIndex);
end;
procedure CL1Editor.OnAddNode;
begin
    m_byTrEditMode                  := ND_ADD;
    m_nIndex                        := GenIndex;
end;
procedure CL1Editor.OnDeleteNode;
Begin
    m_byTrEditMode                  := ND_DEL;
    ExecSetEditData(m_nIndex);
End;
//Edit Add Del Execute
procedure CL1Editor.ExecSetEditData(nIndex:Integer);
Var
    m_sl1Tbl : SL1TAG;
Begin
//    TraceL(1,0,'ExecSetEditData.');
    m_sl1Tbl.m_sbyPortID := nIndex;
End;
procedure CL1Editor.ExecEditData;
Var
    m_sl1Tbl : SL1TAG;
Begin
//    TraceL(1,0,'ExecEditData.');
End;
procedure CL1Editor.ExecAddData;
Var
    m_sl1Tbl : SL1TAG;
Begin
//    TraceL(1,0,'ExecAddData.');
     SetIndex(m_nIndex);
     mL1Module.CreateQrySender;
End;
procedure CL1Editor.ExecDelData;
Var
    pTbl : SL2INITITAG;
    i,wMID : Integer;
Begin
//    TraceL(1,0,'ExecDelData.');
    try
    mL1Module.DelNodeLv(m_nIndex);
     {if m_pDB.GetMetersTable(m_nIndex,pTbl)=True then
     for i:=0 to pTbl.m_swAmMeter-1 do
     Begin
      wMID := pTbl.m_sMeter[i].m_swMID;
      //mL2Module.DelNodeLv(wMID);
      //m_blMeterIndex[wMID] := True;
     End;}
    m_pDB.DelPortTable(m_nIndex);
    FreeIndex(m_nIndex);
    //mL1Module.CreateQrySender;
    except
    end;
End;
procedure CL1Editor.ExecInitLayer;
Begin
//    TraceL(1,0,'ExecInitLayer.');
    mL1Module.Init;
End;
//Tree Reload
procedure CL1Editor.ExecSetTree;
Begin
//    TraceL(1,0,'ExecSetTree.');
    FTreeLoader.LoadTree;
End;
//Grid Routine
procedure CL1Editor.ExecSetGrid;
Var
    pTbl : SL1INITITAG;
    i : Integer;
Begin
    ExecSetGridPullDs;
    FsgGrid.ClearNormalCells;
    if m_pDB.GetL1Table(pTbl)=True then
    Begin
     m_nAmRecords := pTbl.Count;
     for i:=0 to pTbl.Count-1 do
     Begin
      SetIndex(pTbl.Items[i].m_sbyPortID);
      AddRecordToGrid(i,@pTbl.Items[i]);
     End;
    End;
End;
procedure CL1Editor.ExecSetGridPullDs;
Var
    pTbl : SL2PULLDSS;
    i  : Integer;
    nY : Integer;
Begin
    FAdvPullDesc.ClearNormalCells;
    if m_pDB.GetSL2PULLDS(pTbl)=True then
    Begin
     for i:=0 to pTbl.Count-1 do
     Begin
      nY := i+1;
      FAdvPullDesc.Cells[0,nY] := IntToStr(pTbl.Items[i].ID);
      FAdvPullDesc.Cells[1,nY] := pTbl.Items[i].PULLTYPE;
      FAdvPullDesc.Cells[2,nY] := pTbl.Items[i].DESCRIPTION;
     End;
    End;
End;
procedure CL1Editor.ExecSetGridPull(pullID:Integer);
Var
    pTbl : SL2PULLS;
    i  : Integer;
    nY : Integer;
Begin
    FAdvSgPulls.ClearNormalCells;
    pullDSId := pullID;
    if m_pDB.GetSL2PULL(pullID,pTbl)=True then
    Begin
     for i:=0 to pTbl.Count-1 do
     Begin
      nY := i+1;
      FAdvSgPulls.Cells[0,nY]  := IntToStr(pTbl.Items[i].ID);
      FAdvSgPulls.Cells[1,nY]  := IntToStr(pTbl.Items[i].PULLID);
      FAdvSgPulls.Cells[2,nY]  := IntToStr(pTbl.Items[i].PORTID);
      FAdvSgPulls.Cells[3,nY]  := IntToStr(pTbl.Items[i].CONNECTIONTIMEOUT);
      FAdvSgPulls.Cells[4,nY]  := pTbl.Items[i].CONNSTRING;
      FAdvSgPulls.Cells[5,nY]  := IntToStr(pTbl.Items[i].RECONNECTIONS);
      FAdvSgPulls.Cells[6,nY]  := IntToStr(pTbl.Items[i].STATE);
     End;
    End;
End;


{
SL2PULL = packed record
     ID                : INTEGER;
     PULLID            : INTEGER;
     CONNECTIONTIMEOUT : INTEGER;
     CONNSTRING        : String[50];
     RECONNECTIONS     : INTEGER;
     STATE             : SMALLINT;
    end;
 FAdvPullDesc.ColWidths[1]:= 40;

    FAdvSgPulls.Color       := KNS_NCOLOR;
     function GetSL2PULLDS(var pTable:SL2PULLDSS):Boolean;
     function GetSL2PULL(pullID:Integer; var pTable:SL2PULLS):Boolean;
}

procedure CL1Editor.AddRecordToGrid(nIndex:Integer;pTbl:PSL1TAG);
Var
   nY : Integer;
   nVisible : Integer;
Begin
    nY := nIndex+1;
    //nVisible := round(FsgGrid.Height/21);
    //if (nY-nVisible)>0  then FsgGrid.TopRow := nY-nVisible;
    with pTbl^ do Begin
     FsgGrid.Cells[0,nY]  := IntToStr(nY);
     FsgGrid.Cells[1,nY]  := IntToStr(m_sbyPortID);
     FsgGrid.Cells[2,nY]  := m_schName;
     FsgGrid.Cells[3,nY]  := IntToStr(m_sbyPortNum);
     FsgGrid.Cells[4,nY]  := m_nPortTypeList.Strings[m_sbyType];
     FsgGrid.Cells[5,nY]  := m_nTypeProt.Strings[m_sbyProtID];
     FsgGrid.Cells[6,nY]  := m_nActiveList.Strings[m_sbyControl];
     FsgGrid.Cells[7,nY]  := m_nKTRout.Strings[m_sbyKTRout];
     FsgGrid.Cells[8,nY]  := m_nActiveList.Strings[m_nFreePort];
     FsgGrid.Cells[9,nY]  := m_nSpeedList.Strings[m_sbySpeed];
     FsgGrid.Cells[10,nY] := m_nParityList.Strings[m_sbyParity];
     FsgGrid.Cells[11,nY] := m_nDataList.Strings[m_sbyData];
     FsgGrid.Cells[12,nY] := m_nStopList.Strings[m_sbyStop];
     FsgGrid.Cells[13,nY] := IntToStr(m_swDelayTime);
     FsgGrid.Cells[14,nY] := IntToStr(m_swAddres);
     FsgGrid.Cells[15,nY] := m_nActiveList.Strings[m_sblReaddres];
     FsgGrid.Cells[16,nY] := m_schPhone;
     FsgGrid.Cells[17,nY] := m_swIPPort;
     FsgGrid.Cells[18,nY] := m_schIPAddr;
    End;
End;
procedure CL1Editor.OnSetGrid;
Begin
    ExecSetGrid;
End;
procedure CL1Editor.OnSaveGrid;
Var
    i : Integer;
    pTbl:SL1TAG;
Begin
    for i:=1 to FsgGrid.RowCount do
    Begin
     if FsgGrid.Cells[1,i]='' then break;
     pTbl.m_sbyID := i;
     GetGridRecord(pTbl);
     if m_pDB.AddPortTable(pTbl)=True then SetIndex(pTbl.m_sbyPortNum);
    End;
    ExecSetGrid;
End;
procedure CL1Editor.GetGridRecord(var pTbl:SL1TAG);
Var
    i : Integer;
Begin
    i := pTbl.m_sbyID;
    with pTbl do Begin
     m_sbyPortID   := StrToInt(FsgGrid.Cells[1,i]);
     m_schName     := FsgGrid.Cells[2,i];
     m_sbyPortNum  := StrToInt(FsgGrid.Cells[3,i]);
     m_sbyType     := m_nPortTypeList.IndexOf(FsgGrid.Cells[4,i]);
     m_sbyProtID   := m_nTypeProt.IndexOf(FsgGrid.Cells[5,i]);
     m_sbyControl  := m_nActiveList.IndexOf(FsgGrid.Cells[6,i]);
     m_sbyKTRout   := m_nKTRout.IndexOf(FsgGrid.Cells[7,i]);
     m_nFreePort   := m_nActiveList.IndexOf(FsgGrid.Cells[8,i]);
     m_sbySpeed    := m_nSpeedList.IndexOf(FsgGrid.Cells[9,i]);
     m_sbyParity   := m_nParityList.IndexOf(FsgGrid.Cells[10,i]);
     m_sbyData     := m_nDataList.IndexOf(FsgGrid.Cells[11,i]);
     m_sbyStop     := m_nStopList.IndexOf(FsgGrid.Cells[12,i]);
     m_swDelayTime := StrToInt(FsgGrid.Cells[13,i]);
     m_swAddres    := StrToInt(FsgGrid.Cells[14,i]);
     m_sblReaddres := m_nActiveList.IndexOf(FsgGrid.Cells[15,i]);
     m_schPhone    := FsgGrid.Cells[16,i];
     m_swIPPort    := FsgGrid.Cells[17,i];
     m_schIPAddr   := FsgGrid.Cells[18,i];
    End;
End;
procedure CL1Editor.SetDefaultRow(i:Integer);
Var
    nIndex : Integer;
Begin
    if FsgGrid.Cells[1,i]=''  then FsgGrid.Cells[1,i]  := IntToStr(GenIndex);
    if FsgGrid.Cells[2,i]=''  then FsgGrid.Cells[2,i]  := '����� '+FsgGrid.Cells[1,i];
    if FsgGrid.Cells[3,i]=''  then FsgGrid.Cells[3,i]  := '0';
    if FsgGrid.Cells[4,i]=''  then FsgGrid.Cells[4,i]  := m_nPortTypeList.Strings[0];
    if FsgGrid.Cells[5,i]=''  then FsgGrid.Cells[5,i]  := m_nTypeProt.Strings[0];
    if FsgGrid.Cells[6,i]=''  then FsgGrid.Cells[6,i]  := m_nActiveList.Strings[0];
    if FsgGrid.Cells[7,i]=''  then FsgGrid.Cells[7,i]  := m_nKTRout.Strings[0];
    if FsgGrid.Cells[8,i]=''  then FsgGrid.Cells[8,i]  := m_nActiveList.Strings[0];
    if FsgGrid.Cells[9,i]=''  then FsgGrid.Cells[9,i]  := '9600';
    if FsgGrid.Cells[10,i]='' then FsgGrid.Cells[10,i] := 'NO';
    if FsgGrid.Cells[11,i]='' then FsgGrid.Cells[11,i] := '8';
    if FsgGrid.Cells[12,i]='' then FsgGrid.Cells[12,i] := '1';
    if FsgGrid.Cells[13,i]='' then FsgGrid.Cells[13,i] := '20000';
    if FsgGrid.Cells[14,i]='' then FsgGrid.Cells[14,i] := '0';
    if FsgGrid.Cells[15,i]='' then FsgGrid.Cells[15,i] := m_nActiveList.Strings[0];;
    if FsgGrid.Cells[16,i]='' then FsgGrid.Cells[16,i] := '80172305898';
    if FsgGrid.Cells[17,i]='' then FsgGrid.Cells[17,i] := '800';
    if FsgGrid.Cells[18,i]='' then FsgGrid.Cells[18,i] := '192.168.1.1';
End;
procedure CL1Editor.ExecSelRowGrid;
Begin
    FsgGrid.SelectRows(FindRow(IntToStr(m_nIndex)),1);
    FsgGrid.Refresh;
    ViewChild(m_nIndex);
End;
function CL1Editor.FindRow(str:String):Integer;
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
procedure CL1Editor.ViewChild(nIndex:Integer);
Begin
    if m_blCL2ChannEditor=False then
    if FChild<>Nil then
    Begin
     FChild.PMasterIndex := nIndex;
     FChild.ExecSetGrid;
    End;
End;
function CL1Editor.FindFreeRow(nIndex:Integer;adcSG:PTAdvStringGrid):Integer;
Var
    i : Integer;
Begin
    for i:=1 to adcSG.RowCount-1 do if adcSG.Cells[nIndex,i]='' then
    Begin
     Result := i;
     exit;
    End;
    Result := 1;
End;
procedure CL1Editor.OnAddRow;
Var
    nIndex : Integer;
Begin
    if m_nRowIndex<>-1 then
    Begin
     SetDefaultRow(m_nRowIndex);
     SetIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndex]));
    End else
    Begin
     nIndex := FindFreeRow(3,FsgGrid);
     SetDefaultRow(nIndex);
     SetIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,nIndex]));
    End;
End;
procedure CL1Editor.OnCloneRow;
Var
    nIndex : Integer;
    pTbl   : SL1TAG;
Begin
    if m_nRowIndex<>-1 then
    if m_nRowIndex<=FindFreeRow(3,FsgGrid)-1 then
    Begin
     pTbl.m_sbyID   := m_nRowIndex;
     GetGridRecord(pTbl);
     pTbl.m_sbyPortID := GenIndexSv;
     AddRecordToGrid(FindFreeRow(3,FsgGrid)-1,@pTbl);
    End;
End;
procedure CL1Editor.OnDelRow;
Var
    nFind : Integer;
Begin
    if m_nAmRecords=FindFreeRow(3,FsgGrid)-1 then
    Begin
     if m_nIndex<>-1 then
     Begin
      //ExecDelData;
      //FreeAllIndex;
      m_pDB.DelPortTable(m_nIndex);
      SetEdit;
      ExecSetGrid;
      ViewChild(m_nIndex);
     End;
    End else
    Begin
     if m_nRowIndex<>-1 then
     Begin
      if FsgGrid.Cells[1,m_nRowIndex]<>'' then
      FreeIndex(StrToInt(FsgGrid.Cells[m_nIDIndex,m_nRowIndex]));
      FsgGrid.ClearRows(m_nRowIndex,1);
     End;
    End;
End;
procedure CL1Editor.OnDelAllRow;
//Var
//    i : Integer;
Begin
    m_pDB.DelPortTable(-1);
    SetEdit;
    ExecSetGrid;
    {
    for i:=0 to MAX_PORT do
    if m_blPortIndex[i]=False then
    Begin
     m_nIndex := i;
     ExecDelData
    End;
    m_pDB.DelPortTable(-1);
    FreeAllIndex;
    ExecSetGrid;
    }
End;
procedure CL1Editor.OnClickGrid(Sender: TObject; ARow, ACol: Integer);
Begin
    if (Sender as TAdvStringGrid).name='sgChannels' then
    Begin
     m_nRowIndex := -1;
     if ARow>0 then Begin
      if FsgGrid.Cells[m_nIDIndex,ARow]<>'' then
      Begin
       m_nIndex := StrToInt(FsgGrid.Cells[m_nIDIndex,ARow]);
       ViewChild(m_nIndex);
      End else m_nIndex := -1;
      m_nRowIndex := ARow;
     End;
     if (Assigned(mBtiModule)) and (FsgGrid.Cells[5,ARow] = 'BTI_SRV') then
       mBtiModule.SetPortID(StrToInt(FsgGrid.Cells[1,ARow]));
    End else
    if (Sender as TAdvStringGrid).name='advPullDesc' then
    Begin
      pullDSId := -1;
      pullDSRow:= -1;
      if ((ARow>0) and (FAdvPullDesc.Cells[0,ARow]<>'')) then
      Begin
       ExecSetGridPull(StrToInt(FAdvPullDesc.Cells[0,ARow]));
       pullDSRow:= ARow;
      End;
    End else
    if (Sender as TAdvStringGrid).name='advSgPulls' then
    Begin
      pullPLId := -1;
      pullPLRow:= -1;
      if ((ARow>0) and (FAdvSgPulls.Cells[0,ARow]<>'')) then
      Begin
       pullPLId := StrToInt(FAdvSgPulls.Cells[0,ARow]);
       //ExecSetGridPull(StrToInt(FAdvPullDesc.Cells[0,ARow]));
       pullPLRow:= ARow;
      End;
    End;
End;
//Init Layer
procedure CL1Editor.OnInitLayer;
Begin
    ExecSetTree;
    ExecInitLayer;
End;
//Index Generator
function  CL1Editor.GenIndex:Integer;
Var
    i : Integer;
Begin
    for i:=0 to MAX_PORT do
    if m_blPortIndex[i]=True then
    Begin
     Result := i;
     exit;
    End;
    Result := -1;
End;
function CL1Editor.GenIndexSv:Integer;
Begin
    Result := SetIndex(GenIndex);
End;
function CL1Editor.SetIndex(nIndex : Integer):Integer;
Begin
    m_blPortIndex[nIndex] := False;
    Result := nIndex;
End;
Procedure CL1Editor.FreeIndex(nIndex : Integer);
Begin
    m_blPortIndex[nIndex] := True;
End;
Procedure CL1Editor.FreeAllIndex;
Var
    i : Integer;
Begin
    for i:=0 to MAX_PORT do
    m_blPortIndex[i] := True;
End;
procedure CL1Editor.OnExecute(Sender: TObject);
Begin
    //TraceL(5,0,'OnExecute.');
    case m_byTrEditMode of
     ND_EDIT : Begin ExecEditData;End;
     ND_ADD  : Begin ExecAddData;ExecSetTree;End;
     ND_DEL  : Begin ExecDelData;ExecSetTree;End;
    end;
    ExecSetGrid;
    ExecInitLayer;
End;
//Color And Control
procedure CL1Editor.OnChannelGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
     OnGlGetCellColor(Sender,ARow,ACol,AState,ABrush,AFont);
end;
procedure CL1Editor.OnChannelGetCellType(Sender: TObject; ACol, ARow: Integer;var AEditor: TEditorType);
begin
    with FsgGrid^ do
    case ACol of
     4:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'PortType.dat');
       End;
     5:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'TypeProt.dat');
       end;
     15,6,8:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'Active.dat');
       End;
     7:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'ktrouting.dat');
       End;
     9:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'potrspeed.dat');
       End;
     10:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'portparity.dat');
       End;
     11:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'portdbit.dat');
       End;
     12:Begin
        AEditor := edComboList;
        combobox.items.loadfromfile(m_strCurrentDir+'portsbit.dat');
       End;
    end;
end;

procedure CL1Editor.ExecMainEditor;
var m_nL1Node : SL1TAG;
    PortID    : integer;
begin
   if m_blCL2ChannEditor=False then
   if FsgGrid.Cells[m_nIDIndex,FsgGrid.Row] <> '' then
   begin
     m_nL1Node.m_sbyPortID := StrToInt(FsgGrid.Cells[m_nIDIndex, FsgGrid.Row]);
     m_pDB.GetPortTable(m_nL1Node);
     m_nL1Node.m_sbyID := FsgGrid.Row;
     GetGridRecord(m_nL1Node);
     frMainEditor.pL1Node      := m_nL1Node;
     frMainEditor.byTypeEditor := EDT_MN_L1TAG;
     frMainEditor.ShowModal;
//     m_pDB.FixUspdEvent(0,3,EVS_CHNG_PHCHANN);
     OnSetGrid;
   end;
end;

procedure CL1Editor.nmItSaveClick;
Var
    i    : Integer;
    pTbl : SL2PULLDS;
Begin
    for i:=1 to FAdvPullDesc.RowCount do
    Begin
     if FAdvPullDesc.Cells[1,i]='' then break;
     pTbl.ID          := getIDFromStr(FAdvPullDesc.Cells[0,i]);
     pTbl.PULLTYPE    := FAdvPullDesc.Cells[1,i];
     pTbl.DESCRIPTION := FAdvPullDesc.Cells[2,i];
     m_pDB.addSL2PULLDS(pTbl);
    End;
    ExecSetGridPullDs;
End;
procedure CL1Editor.nmItRead;
Begin
    ExecSetGridPullDs;
End;
procedure CL1Editor.nmItCreate;
Var
    nIndex : Integer;
Begin
    nIndex := FindFreeRow(1,FAdvPullDesc);
    SetDefaultRowDs(nIndex);
End;                                                    
procedure CL1Editor.nmItClone;
Var
    nIndex : Integer;
    pTbl   : SL1TAG;
    newID  : Integer;
Begin
    newID := FindFreeRow(1,FAdvPullDesc);
    if pullDSRow<>-1 then
    if pullDSRow<=newID-1 then
    Begin
     FAdvPullDesc.Cells[0,newID]  := '-1';
     FAdvPullDesc.Cells[1,newID]  := FAdvPullDesc.Cells[1,pullDSRow];
     FAdvPullDesc.Cells[2,newID]  := FAdvPullDesc.Cells[2,pullDSRow];
    End;
End;
procedure CL1Editor.nmItDelOne;
Begin
    if pullDSId<>-1 then
    Begin
     m_pDB.delSL2PULLDS(pullDSId);
     ExecSetGridPullDs;
    End;
End;
procedure CL1Editor.nmItDelAll;
Begin
    m_pDB.delSL2PULLDS(-1);
    ExecSetGridPullDs;
End;
function CL1Editor.getIDFromStr(str:String):Integer;
Begin
   if ((str='')or(str='-1')) then
   Result := -1
    else
   Result := StrToInt(str);
End;
procedure CL1Editor.SetDefaultRowDs(i:Integer);
Begin
    if FAdvPullDesc.Cells[0,i]=''  then FAdvPullDesc.Cells[0,i]  := '-1';
    if FAdvPullDesc.Cells[1,i]=''  then FAdvPullDesc.Cells[1,i]  := 'com port '+IntToStr(i);
    if FAdvPullDesc.Cells[2,i]=''  then FAdvPullDesc.Cells[2,i]  := 'com for gsm';
End;
/////////////////////////////////////////////////////////////////////////////////////
{

 SL2PULLDS = packed record
     ID             : INTEGER;
     PULLTYPE       : String[20];
     DESCRIPTION    : String[50];
    end;
    SL2PULLDSS = packed record
     count          : Integer;
     items          : array of SL2PULLDS;
    end;



    SL2PULL = packed record
     ID                : INTEGER;
     PULLID            : INTEGER;
     CONNECTIONTIMEOUT : INTEGER;
     CONNSTRING        : String[50];
     RECONNECTIONS     : INTEGER;
     PORTID            : INTEGER;
     STATE             : SMALLINT;
    end;
     FAdvSgPulls.Cells[0,0]  := '�/T';
    FAdvSgPulls.Cells[1,0]  := 'PLID';
    FAdvSgPulls.Cells[2,0]  := 'PRID';
    FAdvSgPulls.Cells[3,0]  := '����� �����.';
    FAdvSgPulls.Cells[4,0]  := '������ �����.';
    FAdvSgPulls.Cells[5,0]  := '�-�� ������.';
    FAdvSgPulls.Cells[6,0]  := '����.';
     FAdvSgPulls.Cells[0,nY]  := IntToStr(pTbl.Items[i].ID);
      FAdvSgPulls.Cells[1,nY]  := IntToStr(pTbl.Items[i].PULLID);
      FAdvSgPulls.Cells[2,nY]  := IntToStr(pTbl.Items[i].PORTID);
      FAdvSgPulls.Cells[3,nY]  := IntToStr(pTbl.Items[i].CONNECTIONTIMEOUT);
      FAdvSgPulls.Cells[4,nY]  := pTbl.Items[i].CONNSTRING;
      FAdvSgPulls.Cells[5,nY]  := IntToStr(pTbl.Items[i].RECONNECTIONS);
      FAdvSgPulls.Cells[6,nY]  := IntToStr(pTbl.Items[i].STATE);
}
procedure CL1Editor.nmItSavePl;
Var
    i    : Integer;
    pTbl : SL2PULL;
Begin
    for i:=1 to FAdvSgPulls.RowCount do
    Begin
     if FAdvSgPulls.Cells[1,i]='' then break;
     pTbl.ID            := getIDFromStr(FAdvSgPulls.Cells[0,i]);
     pTbl.PULLID        := StrToInt(FAdvSgPulls.Cells[1,i]);
     pTbl.PORTID        := StrToInt(FAdvSgPulls.Cells[2,i]);
     pTbl.CONNECTIONTIMEOUT := StrToInt(FAdvSgPulls.Cells[3,i]);
     pTbl.CONNSTRING    := FAdvSgPulls.Cells[4,i];
     pTbl.RECONNECTIONS := StrToInt(FAdvSgPulls.Cells[5,i]);
     pTbl.STATE         := StrToInt(FAdvSgPulls.Cells[6,i]);
     m_pDB.addSL2PULL(pTbl);
    End;
    ExecSetGridPull(pullDSId);
End;
procedure CL1Editor.nmItReadPl;
Begin
    ExecSetGridPull(pullDSId);
End;
procedure CL1Editor.nmItCreatePl;
Var
    nIndex : Integer;
Begin
    nIndex := FindFreeRow(1,FAdvSgPulls);
    SetDefaultRowPl(nIndex);
End;
procedure CL1Editor.nmItClonePl;
Var
    nIndex : Integer;
    pTbl   : SL1TAG;
    newID  : Integer;
Begin
    newID := FindFreeRow(1,FAdvSgPulls);
    if pullDSId<>-1 then
    if pullPLRow<>-1 then
    if pullPLRow<=newID-1 then
    Begin
     FAdvSgPulls.Cells[0,newID]  := '-1';
     FAdvSgPulls.Cells[1,newID]  := FAdvSgPulls.Cells[1,pullPLRow];
     FAdvSgPulls.Cells[2,newID]  := FAdvSgPulls.Cells[2,pullPLRow];
     FAdvSgPulls.Cells[3,newID]  := FAdvSgPulls.Cells[3,pullPLRow];
     FAdvSgPulls.Cells[4,newID]  := FAdvSgPulls.Cells[4,pullPLRow];
     FAdvSgPulls.Cells[5,newID]  := FAdvSgPulls.Cells[5,pullPLRow];
     FAdvSgPulls.Cells[6,newID]  := FAdvSgPulls.Cells[6,pullPLRow];
    End;
End;
procedure CL1Editor.nmItDelOnePl;
Begin
    if pullPLId<>-1 then
    Begin
     m_pDB.delSL2PULL(pullPLId,pullDSId);
     ExecSetGridPull(pullDSId);
    End;
End;
procedure CL1Editor.nmItDelAllPl;
Begin
    if(pullDSId=-1) then exit;
    m_pDB.delSL2PULL(-1,pullDSId);
    ExecSetGridPull(pullDSId);
End;
procedure CL1Editor.SetDefaultRowPl(i:Integer);
Begin
                                      FAdvSgPulls.Cells[0,i] := '-1';
    if FAdvSgPulls.Cells[1,i]='' then FAdvSgPulls.Cells[1,i] := IntToStr(pullDSId);
    if FAdvSgPulls.Cells[2,i]='' then FAdvSgPulls.Cells[2,i] := '0';
    if FAdvSgPulls.Cells[3,i]='' then FAdvSgPulls.Cells[3,i] := '30';
    if FAdvSgPulls.Cells[4,i]='' then FAdvSgPulls.Cells[4,i] := 'conn string';
    if FAdvSgPulls.Cells[5,i]='' then FAdvSgPulls.Cells[5,i] := '3';
    if FAdvSgPulls.Cells[6,i]='' then FAdvSgPulls.Cells[6,i] := '0';
End;




end.
