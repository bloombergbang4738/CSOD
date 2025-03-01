unit knsl4connmanager;

interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,knsl2meter,utlmtimer
,knsl5tracer,utldatabase,knsl3ZoneHandler,knsl4secman,knsl5config,knsl3treeloader,mmsystem;
type
    CConnManager = class
    Private
     m_pTable      : SL3CONNTBLS;
     FConnString   : PTComboBox;
     FLogin        : PTEdit;
     FPassword     : PTEdit;
     FConnInfo     : PTLabel;
     //m_sLogin      : String;
     m_sPassword   : String;
     m_sPasswordL2 : String;
     m_sPasswordL3 : String;
     m_sConnStr    : String;
     m_nConnIndex  : Integer;
     FL3TreeLoader : PCL3TreeLoader;
     FTreePanel    : PTAdvPanel;
     FDataPanel    : PTAdvPanel;
     procedure RunManager;
     function SelfHandler(var pMsg:CMessage):Boolean;
     function LoHandler(var pMsg:CMessage):Boolean;
     function HiHandler(var pMsg:CMessage):Boolean;
     constructor Create;
     destructor Destroy; override;
    Public
     m_sLogin     : String;
     procedure InitManager;
     procedure SelectDataSource(nIndex:Integer);
     function  QueryConnection:Boolean;
    public
    {    m_nConnManager.PConnString := @cbConnectionStr;
     m_nConnManager.PLogin      := @edUser;
     m_nConnManager.PPassword   := @edPassword;
    }
    property PConnString : PTComboBox read FConnString write FConnString;
    property PLogin      : PTEdit     read FLogin      write FLogin;
    property PPassword   : PTEdit     read FPassword   write FPassword;
    property PConnInfo   : PTLabel    read FConnInfo   write FConnInfo;
    property PL3TreeLoader:PCL3TreeLoader read FL3TreeLoader write FL3TreeLoader;
    property PTreePanel  : PTAdvPanel read FTreePanel write FTreePanel;
    property PDataPanel  : PTAdvPanel read FDataPanel write FDataPanel;


    End;
implementation
constructor CConnManager.Create;
Begin
End;
destructor CConnManager.Destroy;
Begin
    inherited;
End;
procedure CConnManager.InitManager;
Var
    i : Integer;
Begin
    TraceL(2,0,'(__)CCMMD::>Init Connection Manager.');
    if m_pDB.GetConnTable(m_pTable) then
    Begin
     PConnString.Items.Clear;
     for i:=0 to m_pTable.Count-1 do
     Begin
      PConnString.Items.Add(m_pTable.Items[i].m_sName);
      //if m_pTable.Items[i].m_swLocation=0 then
      //  m_nLocalConnStr:=m_pTable.Items[i].m_sConnString;
     End;
     if PConnString.Items.Count<>0 then
     Begin
      PConnString.ItemIndex := m_nCurrentConnection;
      SelectDataSource(m_nCurrentConnection);
     End;
    End;
    //m_blIsLocal := m_pDB.IsLocalConn(m_nCurrentConnection);
End;
procedure CConnManager.SelectDataSource(nIndex:Integer);
Begin
    //PLogin.Text := PConnString.Items[nIndex];
    m_nCurrentConnection := nIndex;
    m_nConnIndex  := nIndex;
    //m_sLogin      := m_pTable.Items[m_nConnIndex].m_sLogin;
    //m_sPassword   := m_pTable.Items[m_nConnIndex].m_sPassword;
    //m_sPasswordL2 := m_pTable.Items[m_nConnIndex].m_sPasswordL2;
    //m_sPasswordL3 := m_pTable.Items[m_nConnIndex].m_sPasswordL3;
    m_sConnStr    := m_pTable.Items[m_nConnIndex].m_sConnString;
    //m_blIsLocal   := m_pDB.IsLocalConn(m_nConnIndex);
    //m_blIsSlave   := m_pDB.IsSlaveConn(m_nConnIndex);
    //if m_blIsSlave=False then m_blRemProtoState:=True else m_blRemProtoState:=False;
    //FLogin.Text   := m_sLogin;
    PConnInfo.Caption := '�����������';
End;
{
FConnString : PTComboBox;
     FLogin      : PTEdit;
     FPassword   : PTMaskEdit;
}
function CConnManager.QueryConnection:Boolean;
Var
    res    : Boolean;
    nLevel,nError : Integer;
Begin
    res := False;
    if (FConnString.Text='')or(FLogin.Text='')or(FPassword.Text='')or(m_sConnStr='') then
    Begin
     PConnInfo.Caption := '�� ��� ���������!';
     Result := res;
    End else
    if m_nUM.CheckAccess(FLogin.Text,FPassword.Text,SA_USER_PERMIT_DE,True,nLevel,nError)=True then
    Begin
     //PConnInfo.Caption    := m_nUserLayer.Strings[nLevel];
     m_nCurrentConnection := m_nConnIndex;
     m_pDB.FullConnect(m_sConnStr);
   //  m_pDB.FixMeterEvent(0, EVH_CONNARM_START, 0, 0, Now);
     //m_pDB.FixMeterEvent(0, EVH_FIRST_START, 0, 0, Now);
     //m_pDB.FixMeterEvent(0, EVH_POW_ON, 0, 0, Now - timeGetTime*EncodeTime(0,0,0,1));
     //m_pDB.FixMeterEvent(0, EVH_POW_OF, 0, 0, Now - (timeGetTime+33500)*EncodeTime(0,0,0,1));
     PTreePanel.Visible := True;
     //PDataPanel.Visible := True;
     FL3TreeLoader.SetCurrUsr(m_nUM.PCurrUser);
     FL3TreeLoader.SelectTreeType; //aav
     //m_nZH.Init;                   //aav
     //m_nZH.Enable;                 //aav
     //TL2Statistic.IntitObserver;   //aav
     m_nCF.InitColor;
//     m_pDB.FixUspdDescEvent(0,3,EVS_CONN_BASE,m_nConnIndex);
     m_strCurrUser        := FLogin.Text;
     res := True;
    End else
    Begin
     if nError=1 then PConnInfo.Caption := '������ �����������!' else
     if nError=2 then PConnInfo.Caption := '����-���� �� �����������.!' else
     if nError=3 then PConnInfo.Caption := '�� ���������� ����������!' else
     if nError=4 then
     begin
       PConnInfo.Caption := '���������� �������������!';
       m_nUM.SaveBanTime;
     end;
     res := False;
    End;
    {
    if (FLogin.Text<>m_sLogin)or((FPassword.Text<>m_sPassword)and(FPassword.Text<>m_sPasswordL2)and(FPassword.Text<>m_sPasswordL3)) then
    Begin
     PConnInfo.Caption := '������ �����������!';
     exit;
    End;
    if FPassword.Text=m_sPassword then
    Begin
     PConnInfo.Caption    := '�������� �����������';
     m_nCurrentConnection := m_nConnIndex;
     m_pDB.LightConnect(m_sConnStr);
     m_strCurrUser := FLogin.Text;
     res := True;
    End;

    if FPassword.Text=m_sPasswordL2 then
    Begin
     PConnInfo.Caption    := '�������������';
     m_nCurrentConnection := m_nConnIndex;
     m_pDB.FullConnect(m_sConnStr);
     m_strCurrUser := FLogin.Text;
     res := True;
    End;
    if FPassword.Text=m_sPasswordL3 then
    Begin
     PConnInfo.Caption    := 'C.�������������';
     m_nCurrentConnection := m_nConnIndex;
     m_pDB.SFullConnect(m_sConnStr);
     m_strCurrUser := FLogin.Text;
     res := True;
    End;
    }
    Result := res;
End;
function CConnManager.SelfHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    //���������� ��� L2(������ ���)
    Result := res;
End;
function CConnManager.LoHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    //���������� ��� L1
    case pMsg.m_sbyType of
      PH_DATARD_IND:
      Begin
        //��������� � L3 ������ �������� � ���������� ������ �������� �������������
        //m_nRepTimer.OffTimer;
      End;
    End;
    Result := res;
End;
function CConnManager.HiHandler(var pMsg:CMessage):Boolean;
Var
    res : Boolean;
Begin
    res := False;
    //���������� ��� L3
    case pMsg.m_sbyType of
      QL_DATARD_REQ:
      Begin
       //������������ ������,��������� � L1 � ��������� ������ �������� �������������
      End;
    End;
    Result := res;
End;
procedure CConnManager.RunManager;
Begin
    //m_nRepTimer.RunTimer;
End;
end.
