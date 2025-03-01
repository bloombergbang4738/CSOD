unit knsl3EventBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AdvPanel, StdCtrls, AdvOfficeStatusBar,
  AdvOfficeStatusBarStylers, AdvToolBar, AdvToolBarStylers, AdvAppStyler{, knsl5config},
  RbDrawCore, RbButton, utltypes, utlconst,utlbox, ImgList, ComCtrls,
  Spin, utlThread, ExeParams, utlSendRecive {$IFDEF JCL1}, uJCL {$ENDIF};


function SetLayeredWindowAttributes(
    hwnd    : HWND; // handle to the layered window
    crKey   : TColor; // specifies the color key
    bAlpha  : byte; // value for the blend function
    dwFlags : DWORD // action
): BOOL; stdcall;

function SetLayeredWindowAttributes; external 'user32.dll';

const 
 WS_EX_LAYERED= $80000;
 LWA_COLORKEY = 1;
 LWA_ALPHA = 2;

type
  TNotifyEvent = procedure(Sender: TObject) of object;
  TEventBox = class(TForm)
    AdvPanelStyler3: TAdvPanelStyler;
    EventBoxStyler: TAdvFormStyler;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    ImageList2: TImageList;
    AdvPanel3: TAdvPanel;
    AdvPanel2: TAdvPanel;
    Label3: TLabel;
    AdvPanel1: TAdvPanel;
    Label2: TLabel;
    AdvToolBar1: TAdvToolBar;
    bClearEv: TAdvToolBarButton;
    bSaveEv: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    bEnablEv: TAdvToolBarButton;
    bDisablEv: TAdvToolBarButton;
    m_reEventer: TRichEdit;
    m_sdSaveLog: TSaveDialog;
    m_chbTransp: TCheckBox;
    m_seTransp: TSpinEdit;
    AdvToolBarMenuButton1: TAdvToolBarMenuButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    procedure bClearEvClick(Sender: TObject);
    procedure bSaveEvClick(Sender: TObject);
    procedure bEnablEvClick(Sender: TObject);
    procedure bDisablEvClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure m_chbTranspClick(Sender: TObject);
    procedure m_seTranspChange(Sender: TObject);
    procedure OnCollapse(Sender: TObject);
  private
    { Private declarations }
    m_boIsADDEnabled    : Boolean;
    m_bTranparentValue  : Byte;
    m_boTranparent      : Boolean;
    PtEventBoxStyler    : PAdvFormStyler;
    m_reEventer1        : TRichEdit;
    m_blTraceL5         : Boolean;
    FCollapse           : TNotifyEvent;
    FLogFile            : TextFile;
    FLogFileName        : String;
    FLastErrMsg         : String;
    FLastErrTick        : Cardinal;
    RecivedClass        : TRecivedClass;
    function FixEvents_0(_Type : Integer; _Message : String) : Boolean;
    procedure WriteLogLn(const Line :String);
    procedure HandleAppException(Sender: TObject; E: Exception);
    procedure WMCopyData(var MessageData: TWMCopyData); message WM_COPYDATA;    
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function FixEvents(_Type : Integer; _Message : String) : Boolean;
    class function FixMessage(_Type : Integer; _Message : String; msg : CMessage) : Boolean;
    class function FixMessageCH(_Type : Integer; _Message : String; msg : CHMessage) : Boolean;
    procedure EnableBox;
    procedure DisableBox;
    procedure OnbClearEvClick(Sender: TObject);
    procedure OnbSaveEvClick(Sender: TObject);
    procedure OnbEnablEvClick(Sender: TObject);
    procedure OnbDisablEvClick(Sender: TObject);
    property PEventBoxStyler:PAdvFormStyler read PtEventBoxStyler;
    property PREditL5  : TRichEdit    read m_reEventer1 write m_reEventer1;
    property PTraceL5  : Boolean      read m_blTraceL5  write m_blTraceL5;
    property PCollapse : TNotifyEvent read FCollapse    write FCollapse;
  end;
  PTEventBox = ^ TEventBox;
  TTracer = class(CThread)
  private
    m_nMsg : CMessage;
    //m_nStr : String[255];
    procedure OnHandler;
    protected
    procedure Execute; override;
  end;
var
  EventBox: TEventBox;
  m_nTracer : TTracer;

implementation
{$R *.DFM}

const
  sAddDisabled = '����������� ���������!';
  sAddClear    = '������� ������ �������!';

procedure TTracer.OnHandler;
Var
     i,nType : Integer;
     m_nStr : String;
Begin
  if EventBox = nil then Exit;
     m_nStr := '';
     //SetLength(m_nStr,m_nMsg.m_swLen-10);
     nType := m_nMsg.m_sbyServerID;
     for i:=0 to m_nMsg.m_swLen-1-13 do m_nStr := m_nStr + Char(m_nMsg.m_sbyInfo[i]);

  m_nStr := PChar(m_nStr);

  EventBox.FixEvents_0(nType,m_nStr);
End;
procedure TTracer.Execute;
Begin
     FDEFINE(BOX_L5_TC,BOX_L5_TC_SZ,True);
     while true do
     Begin
      FGET(BOX_L5_TC,@m_nMsg);
      Synchronize(OnHandler);
      //OnHandler;
      Sleep(1);
     End;
End;

constructor TEventBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  EventBoxHandle      := Handle;
  EventBoxThead       := GetCurrentThread;
  EventBoxTheadID     := GetCurrentThreadID;
  if RecivedClass=Nil then RecivedClass := TRecivedClass.Create;
  FLastErrTick := GetTickCount();
  Application.OnException := HandleAppException;
  if startParams.isWriteLog then begin
    FLogFileName := ParamStr(0);
    FLogFileName := ChangeFileExt(FLogFileName, '-$' + IntToHex(GetCurrentProcessId(), 4)
                                  + '-' + FormatDateTime('yymmdd-hhnn', Now())
                                  + '.log');
    AssignFile(FLogFile, FLogFileName);
    FileMode := 2;
    if not FileExists(FLogFileName) then Rewrite(FLogFile) else begin
      Reset(FLogFile);
      Append(FLogFile);
    end;
  end;
end;

destructor TEventBox.Destroy;
begin
  Application.OnException := nil;
  if FLogFileName <> '' then begin
    FLogFileName := '';
    CloseFile(FLogFile);
  end;
  if RecivedClass<>Nil then FreeAndNil(RecivedClass);
  inherited;
end;

procedure TEventBox.HandleAppException(Sender: TObject; E: Exception);
var
  vMessage :String;
begin
  if (GetTickCount() - FLastErrTick) < 1000 then
    if FLastErrMsg = E.Message then Exit;

  m_boIsADDEnabled := true;
  //if not Self.Visible then Show;

  {$IFDEF JCL1}
  vMessage := uJCL.JclAddStackList(E.Message);
  {$ENDIF}

  TEventBox.FixEvents(ET_CRITICAL, E.ClassName + ': ' + vMessage);
  FLastErrMsg := E.Message;
  FLastErrTick := GetTickCount();
end;

procedure TEventBox.OnbClearEvClick(Sender: TObject);
Begin
    bClearEvClick(Sender);
End;
procedure TEventBox.OnbSaveEvClick(Sender: TObject);
Begin
    bSaveEvClick(Sender);
End;
procedure TEventBox.OnbEnablEvClick(Sender: TObject);
Begin
    bEnablEvClick(Sender);
End;
procedure TEventBox.OnbDisablEvClick(Sender: TObject);
Begin
    bDisablEvClick(Sender);
End;
procedure TEventBox.bClearEvClick(Sender: TObject);
begin
    m_reEventer.Lines.Clear();
    if m_reEventer1 <> nil then m_reEventer1.Lines.Clear();
    FixEvents(ET_CRITICAL, sAddClear);
end;


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

procedure TEventBox.bEnablEvClick(Sender: TObject);
begin
    if (m_boIsADDEnabled) then
        exit;
    m_boIsADDEnabled := true;
    FixEvents(ET_RELEASE, '����������� ��������!');
end;

procedure TEventBox.bDisablEvClick(Sender: TObject);
begin
    if (not m_boIsADDEnabled) then
        exit;
    FixEvents(ET_CRITICAL, sAddDisabled);
    m_boIsADDEnabled := false;
end;

procedure TEventBox.EnableBox;
Begin
    bEnablEvClick(self);
End;
procedure TEventBox.DisableBox;
Begin
    bDisablEvClick(self);
End;
{
 nLen := Length(strConnect);
    nMsg.m_swLen := 11 + nLen;

    for i:=0 to nLen-1 do nMsg.m_sbyInfo[i] := Byte(strConnect[i+1]);


              byBuff     : PByteArray;
    str        : String;
    i          : Integer;
      byBuff := @outMsg;
      for i:=0 to wLen-1 do str := str + IntToHex(byBuff[i], 2) + ' ';


}

class function TEventBox.FixMessageCH(_Type : Integer; _Message : String; msg : CHMessage) : Boolean;
Var
    byBuff : PByteArray;
    str    : String;
    i      : Integer;
Begin
  Result:=True;
   try
    str:='';
    byBuff := @msg;
    for i:=0 to msg.m_swLen-1 do str := str + IntToHex(byBuff[i], 2) + ' ';
    FixEvents(_Type,_Message+str);
   except
     Result:=False;
   end;
End;

class function TEventBox.FixMessage(_Type : Integer; _Message : String; msg : CMessage) : Boolean;
Var
    byBuff : PByteArray;
    str    : String;
    i      : Integer;
Begin
  Result:=True;
   try
    str:='';
    byBuff := @msg;
    for i:=0 to msg.m_swLen-1 do str := str + IntToHex(byBuff[i], 2) + ' ';
    FixEvents(_Type,_Message+str);
   except
     Result:=False;
   end;
End;


class function TEventBox.FixEvents(_Type : Integer; _Message : String) : Boolean;
Var
    m_nMsg : CMessage;
    i,nLen : Integer;
Begin
  Result := False;
  _Message := PChar(_Message);

  if _Message = '' then Exit;

  if Length(_Message) > SizeOf(m_nMsg.m_sbyInfo) then begin
    _Message:=Copy(_Message, 1, 1000);  //����������� ����� ���������
  end;

  nLen                 := Length(_Message);
  m_nMsg.m_swLen       := 13 + nLen;
  m_nMsg.m_sbyServerID := _Type;
    
  FillChar(m_nMsg.m_sbyInfo, SizeOf(m_nMsg.m_sbyInfo), #0);

  for i := 0 to nLen - 1 do m_nMsg.m_sbyInfo[i] := Byte(_Message[i + 1]);

  FPUT(BOX_L5_TC,@m_nMsg);

  Result := True;
End;

procedure TEventBox.WriteLogLn(const Line: String);
var
str:String;
begin
  if not startParams.isWriteLog then Exit;
  if FLogFileName <> '' then begin
    System.Writeln(FLogFile, Line);
//    if (startParams.isResError=true)then
//     str:='True'
//    else str:='False';
//    System.Writeln(FLogFile, str);
    Flush(FLogFile);
  end;
end;

function TEventBox.FixEvents_0(_Type : Integer; _Message : String) : Boolean;
var
    l_clMsgColor : TColor;
    l_Font       : TFontStyles;
    msg          : String;
begin
    Result := false;
    if _Message = '' then Exit;

    msg := DateTimeToStr(Now()) + ' :> ' + _Message;

    WriteLogLn(msg);

    if not m_boIsADDEnabled then begin
      if (_Message <> sAddClear) and (_Message <> sAddDisabled) then
        exit;
    end;

    l_clMsgColor := clBlack;
    l_Font       := l_Font-[fsBold, fsItalic, fsUnderline, fsStrikeOut];

    case _Type of
    ET_NORMAL:
    begin
        l_clMsgColor := clBlack;
//        l_Font       := [fsBold];
    end;
    ET_CRITICAL:
    begin
        l_clMsgColor := clRed;
//        l_Font       := [fsBold, fsUnderline];
    end;
    ET_RELEASE:
    begin
        l_clMsgColor := clGreen;
//        l_Font       := [fsBold];
    end;
    end;
     m_reEventer.Lines.BeginUpdate;
     m_reEventer.SelStart := m_reEventer.GetTextLen;
     m_reEventer.SelAttributes.Color := l_clMsgColor;
     m_reEventer.SelAttributes.Style := l_Font;
     m_reEventer.Lines.Add(msg);
     m_reEventer.Lines.EndUpdate;

    if m_reEventer1<>Nil then
    Begin
     m_reEventer1.Lines.BeginUpdate;
     m_reEventer1.SelStart := m_reEventer1.GetTextLen;
     m_reEventer1.SelAttributes.Color := l_clMsgColor;
     m_reEventer1.SelAttributes.Style := l_Font;
     m_reEventer1.Lines.Add(msg);
     m_reEventer1.Lines.EndUpdate;
    End;
    Result := true;    
end;

procedure TEventBox.FormCreate(Sender: TObject);
begin
    //SendMessage(m_reEventer.Handle,EM_LIMITTEXT, System.MaxInt-2, 0);
    m_blTraceL5    := false;
    m_boTranparent := false;
    m_chbTransp.Checked := m_boTranparent;
    //m_bTranparentValue := 127;
    m_bTranparentValue := 255;
    PtEventBoxStyler := @EventBoxStyler;
    SetWindowLong(Self.Handle, GWL_EXSTYLE, GetWindowLong(Self.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
    SetLayeredWindowAttributes(Self.Handle, 0, m_bTranparentValue, LWA_ALPHA);
    m_boIsADDEnabled := False;
    FixEvents(ET_CRITICAL, sAddDisabled);
end;


procedure TEventBox.m_chbTranspClick(Sender: TObject);
var
    t : byte;
begin
    m_bTranparentValue := 75 + trunc(1.8*m_seTransp.Value);
    m_boTranparent := m_chbTransp.Checked;
    t := m_bTranparentValue;

    if (not m_boTranparent) then
        t := 255;

    SetLayeredWindowAttributes(Self.Handle, 0, t, LWA_ALPHA);
end;

procedure TEventBox.m_seTranspChange(Sender: TObject);
begin
    if (not m_boTranparent) then
        exit;
    m_bTranparentValue := 75 + trunc(1.8*m_seTransp.Value);
    SetLayeredWindowAttributes(Self.Handle, 0, m_bTranparentValue, LWA_ALPHA);
end;

procedure TEventBox.OnCollapse(Sender: TObject);
begin
    if Assigned(FCollapse) then FCollapse(Sender);
end;

procedure TEventBox.WMCopyData(var MessageData: TWMCopyData);
var
    SQMD: SQWERYCMDID;
    s : string;
    _Message:String;
    _Type:Byte;
    msg: CMessage;
begin
  try
    _Type:= 0;
    RecivedClass.WMCopyData(MessageData,s);
    if MessageData.CopyDataStruct.dwData = QL_QWERYBOXEVENT then begin
       _Message:= RecivedClass.ExtractStringBoxEvent(s,_Type);
       FixEvents(_Type,_Message);
//       MessageEventBox(_Type,_Message);  //���������� ���������� ������ ���������
    end
    else if MessageData.CopyDataStruct.dwData = QL_QWERYBOXEVENTMSG then begin
     msg:= RecivedClass.ExtractStringBoxEventMsg(s,_Type,_Message);
     FixMessage(_Type,_Message,msg);
    end;
  except
    if EventBox<>Nil then EventBox.FixEvents(ET_CRITICAL,'l5module_MessageTree_ERROR');
  end;
end;

end.
