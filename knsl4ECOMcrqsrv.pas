unit knsl4ECOMcrqsrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdCustomHTTPServer,
  IdHTTPServer, StdCtrls, utlconst, utldatabase, utltypes, utlbox, utlTimeDate;

type
  CEcomCrqSrv = class
  private
    IdHTTPServer1: TIdHTTPServer;
    procedure IdHTTPServer1CommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure Rigths_info(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Auth(ARequestInfo: TIdHTTPRequestInfo);
    procedure Delete();
    procedure MeterNotFound(Chanel: string);
   // procedure IdHTTPServer1Exception(AThread: TIdPeerThread; AException: Exception);

    function  Controller(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Archive(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Chan_Info(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Current(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Last_event(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Events(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  GetTime(AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  SetTime(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Ident(AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Sys_events(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
    function  Total(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;

    procedure EncodeKanToVMAndCMDID(KT : char; NK : integer; var VM, CMDID : integer);

    procedure MeterMIDDecoder();

    function  InitPar(ARequestInfo: TIdHTTPRequestInfo) : Boolean;
    function  EncodeEventToECOM(_PTable : SEVENTTAG; var Code : WORD) : string;
    function  getMeterStatus(VM : Integer) : Integer;
    function  inTime(date : string; var dateTime : TDateTime) : Boolean;
    function  outTime(date : TDateTime) : string;
    function  DayNull(date : TDateTime) : TDateTime;
    procedure DefaultTime(ARequestInfo: TIdHTTPRequestInfo);

  private
    str        : string;
    error      : string;
    busy       : Boolean;
    typeEnergy : string;

    //Ftxt       : System.Text;

    autoriz    : Boolean;

    listChanel    : TStringList;
    listChanelVMID : Array[0..1024] of Integer;
    listChanelDID : Array[0..1024] of Integer;
    t1            : TDatetime;
    t2            : TDatetime;
    fulltime      : Integer;
    interval      : string;
    tariff        : Array of Integer;
    sum           : Integer;
    time          : TDatetime;
    max_size      : Integer;
    Ne1           : Integer;
    Ne2           : Integer;
    m_pDDB   : PCDBDynamicConn;
    m_nDescDB : Integer;
  public
   AbonID       : Integer;
   constructor Create;
   destructor Destroy;override;
   //procedure Init(var pTable : SL1TAG);
   procedure Init(port : Integer);
   procedure Stop;
   procedure Run;

    { Public declarations }
  end;

const
//G1       *(VMID + 1)   - �������
//G2..G4   *(VMID + 1)   - ���������� �� �����
//G5..G7   *(VMID + 1)   - ��� �� �����
//G8..G11  *(VMID + 1)   - �������� �������� ����� � �� �����
//G12..G15 *(VMID + 1)   - �������� ���������� ����� � �� �����
//V                      - ������ ����������� � �������� ���������


    ns = #10;                                                  //������ �������� ������

    x  = 1;                                                   //��������� ��� �������
    xm = 1;                                                   //��������� ��� �������� 


  CHAN_NAMES  : array [0..94] of string = ( '�����������',
                                						'���.�����.���.��.(Wp+)',
					                                  '���.�����.���.��.(Wp-)',
			                          						'���.�����.pe�.��.(Wq+)',
                          									'���.�����.pe�.��.(Wq-)',
                          									'�-�� ���.���.��.� �����(Wp+)',
                          									'�-�� ���.���.��.� �����(Wp-)',
                          									'�-�� ���.pe�.��.� �����(Wq+)',
                          									'�-�� ���.pe�.��.� �����(Wq-)',
                          									'�-�� ���.���.��.� �����(Wp+)',
                          									'�-�� ���.���.��.� �����(Wp-)',
                          									'�-�� ���.pe�.��.� �����(Wq+)',
                          									'�-�� ���.pe�.��.� �����(Wq-)',
                          									'�-�� ���.���.��.�� 30 ���(Wp+)',
                          									'�-�� ���.���.��.�� 30 ���(Wp-)',
                          									'�-�� ���.���.��.�� 30 ���(Wq+)',
                          									'�-�� ���.���.��.�� 30 ���(Wq-)',
                          									'���.�����.���.��.� ���.�����(Wp+)',
                          									'���.�����.���.��.� ���.�����(Wp-)',
                          									'���.�����.���.��.� ���.�����(Wq+)',
                          									'���.�����.���.��.� ���.�����(Wq-)',
                          									'���.�����.���.��.� ���.������(Wp+)',
                          									'���.�����.���.��.� ���.������(Wp-)',
                          									'���.�����.���.��.� ���.������(Wq+)',
                          									'���.�����.���.��.� ���.������(Wq-)',
                          									'�-�� ���.���.��.� ���.����(Wp+)',
                          									'�-�� ���.���.��.� ���.����(Wp-)',
                          									'�-�� ���.���.��.� ���.����(Wq+)',
                          									'�-�� ���.���.��.� ���.����(Wq-)',
                          									'����.���.���.3  ���.(P+)',
                          									'����.���.���.3  ���.(P-)',
                          									'����.���.���.3  ���.(Q+)',
                          									'����.���.���.3  ���.(Q-)',
                          									'����.���.���.30 ���.(P+)',
                          									'����.���.���.30 ���.(P-)',
                          									'����.���.���.30 ���.(Q+)',
                          									'����.���.���.30 ���.(Q-)',
                          									'����.���.���:S',
                          									'����.���.���.������:A',
                          									'����.���.���.������:B',
                          									'����.���.���.������:C',
                          									'����.���.���:S',
                          									'����.���.���.������:A',
                          									'����.���.���.������:B',
                          									'����.���.���.������:C',
                          									'����������:S',
                          									'���������� ������:A',
                          									'���������� ������:B',
                          									'���������� ������:C',
                          									'���:S',
                          									'��� ������:A',
                          									'��� ������:B',
                          									'��� ������:C',
                          									'�������',
                          									'�����.����.:A',
                          									'�����.����.:B',
                          									'�����.����.:C',
                          									'�����������:A',
                          									'�����������:R',
                          									'����-�����',
                          									'����.���.���.����.� �����(P+)',
                          									'����.���.���.����.� �����(P-)',
                          									'����.���.���.����.� �����(Q+)',
                          									'����.���.���.����.� �����(Q-)',
                          									'�-�� ���.���.30���.��.�� ����(Wp+)',
                          									'�-�� ���.���.30���.��.�� ����(Wp-)',
                          									'�-�� ���.���.30���.��.�� ����(Wq+)',
                          									'�-�� ���.���.30���.��.�� ����(Wq-)',
                          									'��� ��������',
                          									'������ ������ ���',
                          									'������ ������ ��������� �������',
                          									'������ ������ ������������� �������',
                          									'������ ������ ������� ������������',
                          									'������ ���� ����������',
                          									'������ ��������� ��������� �� �����',
                          									'������ ����� � �������� ������������',
                          									'������ ���� � �������� ������������',
                          									'����������� ���� � �������� ������������',
                          									'������ ���� (�����) � �������� �����������',
                          									'������ ����� � �������� ������������',
                          									'������ ���� � �������� ������������',
                          									'����������� ���� � �������� ������������',
                          									'������ ���� (�����) � �������� ������������',
                          									'����������� �������� ����',
                          									'����� ��������� � �������� ������������',
                          									'����� ������ � ������ �������',
                          									'����� �� ������� ���������',
                          									'���� Fi',
                          									'Cos(Fi)',
                          									'�������������',
                          									'����������',
                          									'����� ;)',
                          									'���������� �����������',
                          									'��������� ����/�������',
                          									'������ ������' );

  PAR_NAMES_CURR   : array [0..14, 0..1] of string =       ( ('�������', '��'),
                                                             ('���������� �� ���� 1', '�'),
                                                             ('���������� �� ���� 2', '�'),
                                                             ('���������� �� ���� 3', '�'),
                                                             ('��� �� ���� 1', '�'),
                                                             ('��� �� ���� 2', '�'),
                                                             ('��� �� ���� 3', '�'),
                                                             ('�������� �������� �� ����� ���', '���'),
                                                             ('�������� �������� �� ���� 1', '���'),
                                                             ('�������� �������� �� ���� 2', '���'),
                                                             ('�������� �������� �� ���� 3', '���'),
                                                             ('���������� �������� �� ����� ���', '����'),
                                                             ('���������� �������� �� ���� 1', '����'),
                                                             ('���������� �������� �� ���� 2', '����'),
                                                             ('���������� �������� �� ���� 3', '����')
                                                           );
  PAR_NAMES_KVNA   : array [0..3, 0..1] of string =        ( ('������� A+', '��� �'),
                                                             ('������� A-', '��� �'),
                                                             ('������� R+', '���� �'),
                                                             ('������� R-', '���� �')
                                                           );
  USER_RULE   : array [0..2] of string = ( '������������',
			                                     '������� ������������',
			                                     '�������������'  );

  {
	 ��������	�����	��������
	1	0x01	�������� ��� ������������� ��������
	2	0x02	����� �������� �� �������
	4	0x04	������ ��� �������������� �� �������
	8	0x08	������ � �������� �� ������ �������
	16	0x10	������ �������� ����� ������������� �������
	32	0x20	��������� �������
	64	0x40	������ ���� �� ������, ����� ������� ��������� �����
	128	0x80	����� �� ������ (����������� ������) � ������������
	256	0x0100	������������ �� �������
	512	0x0200	��������� �������� ������ (�� ��������� ���� ����������� ���������)
	1024	0x0400	����� �� ������� ������������ �������
	2048	0x0800	����� �� ������� ������
	4096	0x1000	����� �� ������ ������
	8192	0x2000	����������� ����� (���������� ������)
	16384	0x4000	������ ����
	32768	0x8000	�������� ��������
	65536	0x010000	��������������� �� ������������
	131072	0x020000	��������� �������� ������
	262144	0x040000	����� �� ������� (min)
	524288	0x080000	����� �� ������� (max)
	1048576	0x100000	St_SIF
	}

	//�������: 0 - ���� ���� ������, 64 - ���� ��� ������, 128 - ���� ����� �� ������

	STATE : array [0..22] of Integer = ( 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096,
			8192, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576 );


implementation
constructor CEcomCrqSrv.Create;
Begin
   m_pDDB := Nil;
   m_nDescDB := 0;
End;
destructor CEcomCrqSrv.Destroy;
Begin
   listChanel.Destroy;
   IdHTTPServer1.Destroy;
   //m_pDDB.Disconnect();
   m_pDDB := Nil;
   m_pDB.DynDisconnectEx(m_nDescDB);
End;
procedure CEcomCrqSrv.Init(port : Integer);
begin
    listChanel     := TStringList.Create;
    //if m_pDDB=Nil then m_pDDB         := m_pDB.CreateConnect;
    if m_pDDB=Nil then m_pDDB := m_pDB.CreateConnectEx(m_nDescDB);

    if not Assigned(IdHTTPServer1) then
    IdHTTPServer1  := TIdHTTPServer.Create(Application.MainForm);
    IdHTTPServer1.DefaultPort  := port;
    IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;
    AbonID := port mod 1000;
    fulltime := 0;
    interval := 'main';
    tariff   := 0;
    sum      := 0;
end;
{
procedure CEcomCrqSrv.Init(var pTable : SL1TAG);
begin
    listChanel     := TStringList.Create;
    if m_pDDB=Nil then m_pDDB         := m_pDB.CreateConnect;
    if not Assigned(IdHTTPServer1) then
    IdHTTPServer1  := TIdHTTPServer.Create(Application.MainForm);
    IdHTTPServer1.DefaultPort  := StrToInt(pTable.m_swIPPort);
    IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;
    fulltime := 0;
    interval := 'main';
    tariff   := 0;
    sum      := 0;
end;
}
procedure CEcomCrqSrv.Run;
var strDirName : String;
begin
   if IdHTTPServer1.Active = True then Exit;
   IdHTTPServer1.Active:=True;
{
   strDirName := ExtractFilePath(Application.ExeName) + 'Server'+'\'+'Server.txt';

    AssignFile(Ftxt, strDirName); //����������� �����
    Rewrite(Ftxt); //�������� �����, ���� �� ��� ����, �� ����������������� (������ ����������, ����� ������ �����������)
    //Reset(Ftxt); //������ ��������� ���� ��� ��������������
    ShowMessage('������ �������!');
   //Ftxt := TFileStream.Create(strDirName, fmCreate or fmOpenWrite);
}
end;

procedure CEcomCrqSrv.Stop;
begin
   if IdHTTPServer1.Active = False then Exit;
   IdHTTPServer1.Active:=False;
   //CloseFile(Ftxt); //��������� ����
end;

procedure CEcomCrqSrv.IdHTTPServer1CommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var s : String;
begin
    try
    //AResponseInfo.ContentText:='�������� �����';
    AResponseInfo.ContentType:='text/plain';
    AResponseInfo.ContentText:='';
    if busy=True then
      begin
        AResponseInfo.ContentText:='������: 500 Internal Server Error. ������ �����, ��������� ������ �����!';
        Exit;
      end;
{
    //������

    WriteLn(Ftxt, '');
    WriteLn(Ftxt, '������'); //���������� ������ � ���� � ��������� ������� �� ����� ������
    //Write(Ftxt,'My first file!!!'); //���������� ������ � ���� ��� �������� ������� �� ����� ������

    WriteLn(Ftxt, ARequestInfo.Host);
    WriteLn(Ftxt, ARequestInfo.RemoteIP);
    WriteLn(Ftxt, ARequestInfo.RawHTTPCommand);

    s:= ARequestInfo.Params.Text;


    WriteLn(Ftxt, s);
}    

    busy := True;
    if ARequestInfo.Params.Values['req']='rigths_info' then
      Begin
        Rigths_info(ARequestInfo, AResponseInfo);
        busy := False;
        exit;
      end;
    {
    Auth(ARequestInfo);                                                          //�����������
    if autoriz=False then
      begin
        AResponseInfo.ContentText:='401 Unauthorized. �������� ��� ������������ ��� ������';
        Exit;
      end;
    }

    if Controller(ARequestInfo, AResponseInfo) = False then AResponseInfo.ContentText := error;
    {
    WriteLn(Ftxt, '');
    WriteLn(Ftxt, '�����');
    WriteLn(Ftxt, AResponseInfo.ContentText);
    }
    Delete;
    busy := False;
    except
      AResponseInfo.ContentText:='������: 500 Internal Server Error. ���������� ����� ����� ��������� ������!';
      busy := False;
      //WriteLn(Ftxt, AResponseInfo.ContentText);
    end;

end;

procedure CEcomCrqSrv.Auth(ARequestInfo: TIdHTTPRequestInfo);
    var user, pass : String;
        pTable     : SUSERTAGS;
        i          : Integer;
begin
    user := ARequestInfo.AuthUsername;                             //�����������
    pass := ARequestInfo.AuthPassword;
    autoriz := False;
    m_pDDB.GetUsersTable(pTable);
    for i:=0 to pTable.Count-1 do
    Begin
      if pTable.Items[i].m_strShName=user then
      begin
        if pTable.Items[i].m_strPassword=pass then
        begin
           autoriz := True;
        end;
      end;
    end;
end;

procedure CEcomCrqSrv.Rigths_info(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    var pTable  : SUSERTAGS;
        i       : Integer;
begin
    m_pDDB.GetUsersTable(pTable);
    str:= '�� ����� ��� ������ ������������: '+ ARequestInfo.AuthUsername + ns;                           //?????????
    for i:=0 to pTable.Count-1 do
     Begin
      if pTable.Items[i].m_strShName =  ARequestInfo.AuthUsername then
        Begin
          str:= str + '������������ ����� ��������� �����: ' + USER_RULE[pTable.Items[i].m_swSLID];
          AResponseInfo.ContentText:=str;
          Exit;
        end;
     end;
    str:= str + '������������ ����� ��������� �����: ������������ �� ���������������!';
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Controller(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
begin
    Result:=True;
    if ARequestInfo.Params.Values['req']='archive' then
      Begin
        if Archive(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='chan_info' then
      Begin
        if Chan_Info(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='current' then
      Begin
        if Current(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='last_event' then
      Begin
        if Last_event(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='events' then
      Begin
        if Events(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='gettime' then
      Begin
        if GetTime(AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='ident' then
      Begin
        if Ident(AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='settime' then
      Begin
        if SetTime(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='sys_events' then
      Begin
        if Sys_events(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if ARequestInfo.Params.Values['req']='total' then
      Begin
        if Total(ARequestInfo, AResponseInfo) = False then begin Result:=False; Exit; end;
      end
    else if (ARequestInfo.Params.Values['req']='change') or (ARequestInfo.Params.Values['req']='cpuuse') or
            (ARequestInfo.Params.Values['req']='dev_info') or (ARequestInfo.Params.Values['req']='file_info') or
            (ARequestInfo.Params.Values['req']='get_crc') or (ARequestInfo.Params.Values['req']='getfilelen') or
            (ARequestInfo.Params.Values['req']='module_info') or (ARequestInfo.Params.Values['req']='modules') or
            (ARequestInfo.Params.Values['req']='version') then
      Begin
        error:='������: ������� '+ ARequestInfo.Params.Values['req'] +' �� �����������!';
        Result:=False;
        Exit;
      end
    else
      Begin
        error:='������: �������� ��� �������!';
        Result:=False;
        Exit;
      end;
end;

function CEcomCrqSrv.InitPar(ARequestInfo: TIdHTTPRequestInfo) : Boolean;
var typeChanel, chanel, tar: String;
    i, n1, n2, VM, VMDID: Integer;
Begin
    Result:=True;
    str:='';

    if ARequestInfo.Params.Values['interval']<>'' then
      Begin
        interval:= ARequestInfo.Params.Values['interval'];
        if (interval = 'no') or (interval = 'short') or (interval = 'main') or (interval = 'day') or
           (interval = 'month') or (interval = 'year') or (interval = 'all') then else
             begin
               error  :='������: ������� ����� �������� interval';
               Result := False;
               Exit;
             end;
      end
    else if (ARequestInfo.Params.Values['req']='current') or (ARequestInfo.Params.Values['req']='chan_info') then interval:= 'no' else interval:= 'main';

    if ARequestInfo.Params.Values['g1']<>'' then
      Begin
        i := 1;
        While(True) do
          Begin
            if ARequestInfo.Params.Values['g'+IntToStr(i)]<>'' then
              Begin
                listChanel.Add(AnsiUpperCase(ARequestInfo.Params.Values['g'+IntToStr(i)]));
                inc(i);
              end
            else
              Begin
                Break;
              end;
          end;
      end
    else if ARequestInfo.Params.Values['type']<>'' then
      Begin
        typeChanel := 'b';
        n1 := 0;
        n2 := 0;
        if ARequestInfo.Params.Values['type']<>'' then
          Begin
            typeChanel := ARequestInfo.Params.Values['type'];
            typeChanel := AnsiUpperCase(typeChanel);
          end;
        if ARequestInfo.Params.Values['n1']<>'' then
          Begin
            n1 := StrToIntDef(ARequestInfo.Params.Values['n1'], 1);
            Ne1:= n1;
          end;
        if ARequestInfo.Params.Values['n2']<>'' then
          Begin
            n2 := StrToIntDef(ARequestInfo.Params.Values['n2'], 1);
            Ne2:= n2;
            if (n2>1024) and (ARequestInfo.Params.Values['req']<>'sys_events') then begin error:='������: �������� ����� ������������� ������� (���. ���: ...)'; Result := False; Exit; end;
          end;
        for i:=n1 to n2 do
          Begin
            chanel:=typeChanel+IntToStr(i);
            listChanel.Add(chanel);
          end;
       end
    else
      Begin
        if ARequestInfo.Params.Values['n1']<>'' then
          Begin
            Ne1 := StrToIntDef(ARequestInfo.Params.Values['n1'], 1);
          end;
        if ARequestInfo.Params.Values['n2']<>'' then
          Begin
            Ne2 := StrToIntDef(ARequestInfo.Params.Values['n2'], 1);
          end;
      end;

    if (ARequestInfo.Params.Values['g1']<>'') or ((ARequestInfo.Params.Values['type']<>'') and (ARequestInfo.Params.Values['n2']<>'')) then
      Begin
        for i:=0 to listChanel.Count-1 do
          Begin
            chanel := listChanel[i];
            EncodeKanToVMAndCMDID(chanel[1], StrToInt(copy(chanel,2, Length(chanel)+1)), VM,  VMDID);
            listChanelVMID[i]:= VM;
            listChanelDID[i]:= VMDID;
          end;
        MeterMIDDecoder();
      end;

    if ARequestInfo.Params.Values['t1']<>'' then
      Begin
        if inTime(ARequestInfo.Params.Values['t1'], t1) = False then begin Result := False; Exit; end;
      end
    else
      Begin

      end;                                                                       //?????????????????????????????????

    if ARequestInfo.Params.Values['t2']<>'' then
      Begin
        if inTime(ARequestInfo.Params.Values['t2'], t2) = False then begin Result := False; Exit; end;
      end
    else
      Begin
                                                                                //?????????????????????????????????
      end;

    if ARequestInfo.Params.Values['fulltime']<>'' then
      Begin
        fulltime := StrToInt( ARequestInfo.Params.Values['fulltime']);
      end
    else
      Begin
        fulltime := 1;
      end;

    if ARequestInfo.Params.Values['tariff']<>'' then
      Begin
        if ARequestInfo.Params.Values['tariff']='all' then
          Begin
            SetLength(tariff, 4);
            for i:=0 to 3 do
              begin
                tariff[i]:=i;
              end;
          end
        else
          Begin
            tar := ARequestInfo.Params.Values['tariff'];
            if (length(tar) = 1) then
              Begin
                SetLength(tariff, 1);
                tariff[0]:= StrToInt(tar);
              end
            else if (length(tar) = 3) then
              Begin
                SetLength(tariff, 2);
                tariff[0]:= StrToInt(copy(tar, 1, 1));
                tariff[1]:= StrToInt(copy(tar, 3, 1));
              end
            else if (length(tar) = 5) then
              Begin
                SetLength(tariff, 3);
                tariff[0]:= StrToInt(copy(tar, 1, 1));
                tariff[1]:= StrToInt(copy(tar, 3, 1));
                tariff[2]:= StrToInt(copy(tar, 5, 1));
              end
            else if (length(tar) = 7) then
              Begin
                SetLength(tariff, 4);
                tariff[0]:= StrToInt(copy(tar, 1, 1));
                tariff[1]:= StrToInt(copy(tar, 3, 1));
                tariff[2]:= StrToInt(copy(tar, 5, 1));
                tariff[3]:= StrToInt(copy(tar, 7, 1));
              end
            else
              Begin
                error  := '������: �������� �������� ��������� tariff';
                Result := False;
                Exit;
              end;
        end;
      end
    else
      begin
        SetLength(tariff, 1);
        tariff[0]:=0;
      end;

    if ARequestInfo.Params.Values['sum']<>'' then
      Begin
        sum:= StrToInt( ARequestInfo.Params.Values['sum']);
      end
    else sum:=0;

    if ARequestInfo.Params.Values['time']<>'' then
      Begin
        if inTime(ARequestInfo.Params.Values['time'], time) = False then begin Result := False; Exit; end;
      end;

    if ARequestInfo.Params.Values['max_size']<>'' then
      Begin
        max_size:=StrToInt(ARequestInfo.Params.Values['max_size']);
      end
    else max_size:=1024;
end;

procedure CEcomCrqSrv.EncodeKanToVMAndCMDID(KT : char; NK : integer; var VM, CMDID : integer);
var remain : integer;
begin
   VM     := -1;
   CMDID  := -1;
   case KT of
     'G' : begin            //������� ���������
             VM     := (NK - 1) div 15;
             remain := (NK - 1) mod 15;
             case remain of
               0              : CMDID := QRY_FREQ_NET;
               1, 2, 3        : CMDID := QRY_U_PARAM_A + remain - 1;
               4, 5, 6        : CMDID := QRY_I_PARAM_A + remain - 4;
               7, 8, 9, 10    : CMDID := QRY_MGAKT_POW_S + remain - 7;
               11, 12, 13, 14 : CMDID := QRY_MGREA_POW_S + remain - 11;
 //              15, 16, 17     : CMDID := QRY_KOEF_POW_A + remain - 15
             end;
           end;
     'V' : begin            //��������� ���������

           end;
     'B' : begin            //������������� ��������� (������ ����������� �������)
             VM    := (NK - 1) div 4;
             if interval='no' then CMDID := QRY_ENERGY_SUM_EP + (NK - 1) mod 4;
             if interval='main' then CMDID := QRY_SRES_ENR_EP + (NK - 1) mod 4;
             if typeEnergy='pr' then
               begin
                  if interval='day' then CMDID := QRY_ENERGY_DAY_EP + (NK - 1) mod 4;
                  if interval='month' then CMDID := QRY_ENERGY_MON_EP + (NK - 1) mod 4;
               end;
             if typeEnergy='nak' then
               begin
                  if interval='day' then CMDID := QRY_NAK_EN_DAY_EP + (NK - 1) mod 4;
                  if interval='month' then CMDID := QRY_NAK_EN_MONTH_EP + (NK - 1) mod 4;
               end;
           end;
     'S' : begin
             VM    := (NK - 1) div 4;
             CMDID := QRY_ENERGY_SUM_EP + (NK - 1) mod 4;
           end;
     'J' : begin            //������ �������
             VM     := NK;
             if (VM = 0) then
               CMDID  := 0
             else
             begin
               CMDID  := VM;
               //VM     := VM - 1;
             end;
           end;
     end;
end;

function  CEcomCrqSrv.inTime(date : string; var dateTime : TDateTime) : Boolean;
var year, month, day,
    hour, min, sec, ms : word;
    sez                : String;
begin
    Result:=True;
    year  := 2012;
    month := 1;
    day   := 1;
    hour  := 0;
    min   := 0;
    sec   := 0;
    ms    := 0;
    sez   :='';

    //if Length(date)>=14 then sec    := StrToInt(copy(date,13,2));
    //if Length(date)>=12 then min    := StrToInt(copy(date,11,2));
    //if Length(date)>=10 then hour   := StrToInt(copy(date,9,2));
    //if Length(date)>= 8 then day    := StrToInt(copy(date,7,2));
    //if Length(date)>= 6 then month  := StrToInt(copy(date,5,2));
    //if Length(date)>= 4 then year   := StrToInt(copy(date,1,4));
    if Length(date)>=14 then
      Begin
        year   := StrToInt(copy(date,1,4));
        month  := StrToInt(copy(date,5,2));
        day    := StrToInt(copy(date,7,2));
        hour   := StrToInt(copy(date,9,2));
        min    := StrToInt(copy(date,11,2));
        sec    := StrToInt(copy(date,13,2));
      end
    else
      Begin
        error := '������: ������������ ������ ������� (���. ���: ...)';
        Result := False;
        Exit;
      end;
    if Length(date)>=18 then ms    := StrToInt(copy(date,16,3));
    if Length(date)>=19 then sez   := copy(date,19,1);
    try
      dateTime := EncodeDate(year, month, day) + EncodeTime(hour, min, sec, ms);
      Result := True;
    except
      Result := False;
    end;
end;

function  CEcomCrqSrv.outTime(date : TDateTime) : string;
begin
    if fulltime=0 then Result := FormatDateTime('dd-mm-yyyy', date);
    if fulltime=1 then Result := FormatDateTime('dd-mm-yyyy hh:mm:ss.zzz', date)+'w';           //����� �� ���������!!!!!!!!
    if fulltime=2 then Result := FormatDateTime('dd-mm-yyyy hh:mm:ss', date)+'w';
end;

function  CEcomCrqSrv.EncodeEventToECOM(_PTable : SEVENTTAG; var Code : WORD) : string;
var
   GrID : integer;
   EvID : integer;
   CMDID : integer;
   TID : integer;
begin
   GrID := _PTable.m_swGroupID;
   EvID := _PTable.m_swEventID;
   CMDID:= _PTable.m_swAdvDescription;
   TID  := trunc(_PTable.m_swDescription);
   
   Code := $0000; Result := '��� �������';
   if GrID = 0 then
   begin
     case EvID of
       EVH_POW_ON :
          begin Code := 1; Result := '���������' end;
       EVH_POW_OF :
          begin Code := 2; Result := '��������� ����������' end;
       EVH_PROG_RESTART :
          begin Code := 3; Result := '������������ �� �������' end;
       EVH_MOD_SPEED, EVH_MOD_ADRES_USPD, EVH_MOD_PASSWORD, EVH_MOD_DATA :
          begin Code := 5; Result := '��������� ������������' end;
       EVH_COR_TIME_KYEBD, EVH_COR_TIME_DEVICE, EVH_COR_TIME_AUTO :
          begin Code := 6; Result := '��������� �������' end;
       EVH_CORR_BEG :
          begin Code := 15; Result := '��������� �������/�����' end;
       EVH_CORR_END :
          begin Code := 16; Result := '��������� �������/�����' end;
       EVH_STEST_PS :
          begin Code := 32; Result := '��������������� �������' end;
       EVH_STEST_FL :
          begin Code := 33; Result := '��������������� ���������' end;
       EVH_MOD_TARIFF :
          begin Code := 129; Result := '���.��������� ����������' end;
       EVH_DEL_BASE :
          begin Code := 130; Result := '����� ���������' end;
       EVH_OPN_COVER :
          begin Code := 137; Result := '�������� ������'; end;
       EVH_CLS_COVER :
          begin Code := 138; Result := '�������� ������'; end;
       EVH_AUTO_GO_TIME :
       begin
         Code := 158;
         Result := '������� �� ������ �����';
         if (cDateTimeR.GetSeason(_PTable.m_sdtEventTime) > 0) then
            Code := 157; Result := '������� �� ������ �����';
       end;
     end;
   end
   else if grID = 3 then
   begin
     case EvID of
       EVS_CHNG_OPZONE, EVS_CHNG_SBPARAM, EVS_CHNG_TPMETER, EVS_CHNG_PHCHANN,
       EVS_CHNG_PHMETER, EVS_CHNG_PARAM_ED, EVS_CHNG_GROUP, EVS_CHNG_POINT,
       EVS_CHNG_PARAM, EVS_CHNG_T_ZONE, EVS_CHNG_TPLANE, EVS_CHNG_SYZONE,
       EVS_CHNG_SZTDAY :
          begin Code := 5; Result := '��������� ������������' end;
       EVS_AUTORIZ :
          begin Code := 21; Result := '������� ������' end;
       EVS_END_AUTORIZ :
          begin Code := 22; Result := '������� ������' end;
       EVS_DEL_EVENT_JRNL :
          begin Code := 157; Result := '����� �������' end;
       EVS_STRT_USPD :
          begin Code := 162; Result := '����' end;
       EVS_STOP_USPD :
          begin Code := 163; Result := '����' end;
       EVS_STSTOP :
          begin Code := 155; Result := '����. �����'; end;
       EVS_STSTART :
          begin Code := 156; Result := '���. �����'; end;
       EVS_TZONE_ED_OF :
          begin Code := 129; Result := '���. ��������� ����������'; end;
     end;
   end
   else
   begin
     if grID = 2 then
     begin
       case EvID of
         EVM_CHG_SPEED, EVM_CHG_CONST, EVM_CHG_PASSW :
            begin Code := 5; Result := '��������� ������������' end;
//         EVM_CORR_BUTN, EVM_CORR_INTER :
//            begin Code := 6; Result := '��������� �������'; end;
         EVM_CHG_FREEDAY :
            begin Code := 128; Result := '���.���������� ����������'; end;
         EVM_CHG_TARIFF:
            begin Code := 129; Result := '���.��������� ����������'; end;
         EVM_EXCL_PH_A :
            begin Code := 131; Result := '����. ���� 1'; end;
         EVM_INCL_PH_A :
            begin Code := 132; Result := '���. ���� 1'; end;
         EVM_EXCL_PH_B :
            begin Code := 133; Result := '����. ���� 2'; end;
         EVM_INCL_PH_B :
            begin Code := 134; Result := '���. ���� 2'; end;
         EVM_EXCL_PH_C :
            begin Code := 135; Result := '����. ���� 3'; end;
         EVM_INCL_PH_C :
            begin Code := 136; Result := '���. ���� 3'; end;
         EVM_START_CORR, EVM_CORR_BUTN, EVM_CORR_INTER:
            begin Code := 15;  Result := '��������� �������/�����'; end;
         EVM_FINISH_CORR:
            begin Code := 16;  Result := '��������� �������/�����'; end;

         EVM_OPN_COVER :
            begin Code := 137; Result := '����.������' end;
         EVM_CLS_COVER :
            begin Code := 138; Result := '����.������' end;

         EVM_LSTEP_DOWN :
            begin
              case (CMDID) of // m_swTID
                QRY_FREQ_NET:
                  begin Code := 139; Result := '���. �� ���.����.�������'; end;
                QRY_U_PARAM_A:
                  begin Code := 143; Result := '���. �� ���.����.����. �� ���� 1'; end;
                QRY_U_PARAM_B:
                  begin Code := 147; Result := '���. �� ���.����.����. �� ���� 2'; end;
                QRY_U_PARAM_C:
                  begin Code := 151; Result := '���. �� ���.����.����. �� ���� 3'; end;
            end;
         end;

       EVM_L_NORMAL :
       begin
         case (CMDID) of // m_swTID
         QRY_FREQ_NET:
            begin Code := 140; Result := '������� �� ���.����.�������'; end;
         QRY_U_PARAM_A:
            begin Code := 144; Result := '������� �� ���.����.����. �� ���� 1'; end;
         QRY_U_PARAM_B:
            begin Code := 148; Result := '������� �� ���.����.����. �� ���� 2'; end;
         QRY_U_PARAM_C:
            begin Code := 152; Result := '������� �� ���.����.����. �� ���� 3'; end;
         QRY_SRES_ENR_EP, QRY_SRES_ENR_EM, QRY_SRES_ENR_RP, QRY_SRES_ENR_RM :
            begin Code := 175; Result := '������� � ������ ��������'; end;
         end;
       end;

       EVM_LSTEP_UP :
       begin
         case (CMDID) of
         QRY_FREQ_NET :
            begin Code := 141; Result := '���. �� ����.����.�������'; end;
         QRY_U_PARAM_A :
            begin Code := 145; Result := '���. �� ����.����.����. �� ���� 1'; end;
         QRY_U_PARAM_B :
            begin Code := 149; Result := '���. �� ����.����.����. �� ���� 2'; end;
         QRY_U_PARAM_C :
            begin Code := 153; Result := '���. �� ����.����.����. �� ���� 3'; end;

         QRY_MGAKT_POW_S,QRY_MGAKT_POW_A,QRY_MGAKT_POW_B,QRY_MGAKT_POW_C,
         QRY_MGREA_POW_S,QRY_MGREA_POW_A,QRY_MGREA_POW_B,QRY_MGREA_POW_C :
            begin Code := 174; Result := '����� �� ������ ��������' end;

         QRY_ENERGY_DAY_EP,QRY_ENERGY_DAY_EM,QRY_ENERGY_DAY_RP,QRY_ENERGY_DAY_RM,
         QRY_ENERGY_MON_EP,QRY_ENERGY_MON_EM,QRY_ENERGY_MON_RP,QRY_ENERGY_MON_RM :
         begin
            case (TID) of
            1: begin
               Code := 176;
               Result := '����� �� ������ ������� �� ������ 1';
            end;
            2: begin
               Code := 177;
               Result := '����� �� ������ ������� �� ������ 2';
            end;
            3: begin
               Code := 178;
               Result := '����� �� ������ ������� �� ������ 3';
            end;
            4: begin
               Code := 179;
               Result := '����� �� ������ ������� �� ������ 4';
            end;
         end;
         end;
         QRY_SRES_ENR_EP :
            begin Code := 430; Result := '����� �� ������ �������� ������ ��������' end;
         QRY_SRES_ENR_EM:
            begin Code := 686; Result := '����� �� ������ �������� �������� ��������' end;
         else
            begin Code := 188; Result := '���������� ������' end;
       end;
      end;
       end;
end;
     if GrID = 1 then
     begin
       case EvID of
         EVA_METER_NO_ANSWER :
           begin Code := 28; Result := '������� ����� � �������'; end;
         EVA_METER_ANSWER    :
           begin Code := 29; Result := '������������� ����� � ������'; end;
       end;
     end;
   end;
end;

procedure CEcomCrqSrv.Delete();
begin
    str       := '';
    listChanel.Clear;
    fulltime  := 0;
    interval  := 'no';
    tariff    := 0;
    sum       := 0;
end;

procedure CEcomCrqSrv.MeterMIDDecoder();
var i, j, k  : Integer;
    pTable   : SL3GROUPTAG;
    pTableGroup : SL3INITTAG;
    bol      : Boolean;
begin
    m_pDDB.GetVMetersTable(-1,-1, pTable);
    m_pDDB.GetAbonGroupsTable(AbonID, pTableGroup);

    for i:=0 to listChanel.Count - 1 do
      Begin
        bol := False;
        for j:=0 to pTable.Item.Count-1 do
          Begin
            if StrToInt(pTable.Item.Items[j].M_SMETERCODE) = listChanelVMID[i] then
              Begin
                for k:=0 to pTableGroup.Count -1 do
                  Begin
                    if pTable.Item.Items[j].m_sbyGroupID = pTableGroup.Items[k].m_sbyGroupID then
                      Begin
                        listChanelVMID[i] := pTable.Item.Items[j].m_swVMID;
                        bol := True;
                      end;
                  end;
              end;
          end;
        if bol = False then listChanelVMID[i] := -1;
      end;
end;

function CEcomCrqSrv.getMeterStatus(VM: Integer): Integer;
var status, i  : Integer;
begin
    status := 64;
    if VM = -1 then status:=128;
    Result:=status;
end;


{
function CEcomCrqSrv.getMeterStatus(VM: Integer): Integer;
var status, i  : Integer;
    pTable     : SL3GROUPTAG;
begin
    status := 128;
    m_pDB.GetVMetersTable(-1, pTable);
    for i:=0 to pTable.Item.Count-1 do
      Begin
        if pTable.Item.Items[i].m_swMID = VM then status:=64;
      end;
		Result:=status;
end;
}
procedure CEcomCrqSrv.MeterNotFound(Chanel: string);
begin
    str:=str + Chanel + ' , 0, 128, 0';
    if interval='month' then str:=str+', 0';
    str:=str + ns;
end;

function CEcomCrqSrv.DayNull(date : TDateTime) : TDateTime;
var sDate : TSystemTime;
begin
    date:= trunc(date);
    DateTimeToSystemTime(date, sDate);
    sDate.wDay := 1;
    date:= SystemTimeToDateTime(sDate);
    Result := date;
end;

procedure CEcomCrqSrv.DefaultTime(ARequestInfo: TIdHTTPRequestInfo);
var m_pArData  : CCDatas;
    pTableHalf : L3GRAPHDATAS;
    pTable     : SEVENTTAGS;
begin
    if ARequestInfo.Params.Values['req']='archive' then
      begin
        if ARequestInfo.Params.Values['t1']='' then
          begin
            if (interval='day') or (interval='month') then
              begin
                m_pDDB.GetGDataTimeCRQ(0, m_pArData);
                t1 := m_pArData.Items[0].m_sTime;
              end
            else if interval='main' then
              begin
                m_pDDB.GetGraphDatasTimeCRQ(0, pTableHalf);
                t1 := pTableHalf.Items[0].m_sdtDate;
              end;
          end;
        if ARequestInfo.Params.Values['t2']='' then
          begin
            if (interval='day') or (interval='month') then
              begin
                m_pDDB.GetGDataTimeCRQ(1, m_pArData);
                t2 := m_pArData.Items[0].m_sTime;
              end
            else if interval='main' then
              begin
                m_pDDB.GetGraphDatasTimeCRQ(1, pTableHalf);
                t2 := pTableHalf.Items[0].m_sdtDate;
              end;
          end;
      end;
    if ARequestInfo.Params.Values['req']='total' then
      begin
        if ARequestInfo.Params.Values['t1']='' then
          begin
            m_pDDB.GetGDataTimeCRQ(0, m_pArData);
            t1 := m_pArData.Items[0].m_sTime;
          end;
        if ARequestInfo.Params.Values['t2']='' then
          begin
            m_pDDB.GetGDataTimeCRQ(1, m_pArData);
            t2 := m_pArData.Items[0].m_sTime;
          end;
      end;
    if ARequestInfo.Params.Values['req']='sys_events' then
      begin
        if ARequestInfo.Params.Values['t1']='' then
          begin
//            m_pDDB.ReadJrnlLastOneCRQ(0, pTable);
            t1 := pTable.Items[0].m_sdtEventTime;
          end;
        if ARequestInfo.Params.Values['t2']='' then
          begin
            t2 := Now;
          end;
      end;
end;
{
procedure CEcomCrqSrv.IdHTTPServer1Exception(AThread: TIdPeerThread;
  AException: Exception);
begin
    //123
    ShowMessage(AException.Message);
end;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




function CEcomCrqSrv.Archive(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
var m_pArData                             : CCDatas;
    i, j, k, z, sumInd, sumStat, status   : Integer;
    sumVal                                : Double;
    timeStart, timeEnd, dateMain          : TDateTime;
    pTable                                : CCDatas;
    pTableHalf                            : L3GRAPHDATAS;
    bol                                   : Boolean;
    zdvig                                 : int64;
begin
    Result:=True;
    typeEnergy := 'pr';
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    if (ARequestInfo.Params.Values['t1']='') or (ARequestInfo.Params.Values['t2']='') then DefaultTime(ARequestInfo);
    fulltime := 2;
    zdvig :=1;
    {
    for i:=0 to listChanel.Count-1 do
      Begin
        str:=str + listChanel[i] + ' MID:  ' + IntToStr(listChanelVMID[i]) + ' DID:  ' +  IntToStr(listChanelDID[i])+ns;
      end;
    }
    if sum=0 then
      begin
        str:=str + 'ShortChanName, Value, State, Time';
        if (ARequestInfo.Params.Values['tariff']<>'') and ((interval='month') or (interval='day'))  then str:=str + ', Tariff';
        str:=str + ns;
      end;
    if sum=1 then
      begin
        str:=str + 'ShortChanName, COUNT, SUM(Value), State';
        if (ARequestInfo.Params.Values['tariff']<>'') and (interval='month')  then str:=str + ', Tariff';
        str:=str + ns;
      end;
    timeStart:= trunc(t1);
    timeEnd  := trunc(t2);
    if interval='day' then
      begin
        for i:=0 to listChanel.Count-1 do
          Begin
            if getMeterStatus(listChanelVMID[i]) = 128 then
              Begin
                MeterNotFound(listChanel[i]);
                continue;
              end;
            m_pDDB.GetGData(timeEnd, timeStart, listChanelVMID[i], listChanelDID[i], 0, m_pArData);
            sumVal:=0;
            sumStat:=0;
            sumInd:=0;

            for j:=0 to m_pArData.Count-1 do
              begin
               bol := True;
               for z:=0 to length(tariff)-1 do
               begin
                if m_pArData.Items[j].m_swTID = tariff[z] then
                  begin
                    status:=7;
                    if m_pArData.Items[j].m_sbyMaskRead = 1 then status:=0;
                    if sum=0 then
                      Begin
                        str:=str +listChanel[i]+', ' + (Format('%.5f',[m_pArData.Items[j].m_sfValue * x]) ) + ', '+ IntToStr(STATE[status])
                        + ', '+ outTime(m_pArData.Items[j].m_sTime);
                        if ARequestInfo.Params.Values['tariff']<>'' then str:=str + ', ' + IntToStr(tariff[z]);
                        str:=str + ns;
                      end
                    else if sum=1 then
                      Begin
                        if (m_pArData.Items[j].m_swTID = 0) and (bol = True) then
                          Begin
                            sumVal := sumVal + m_pArData.Items[j].m_sfValue * x;
                            sumInd := sumInd + 1;
                            if status<>0 then sumStat := status;
                          end;  
                      end;
                  end;
               end;
              end;

            if sum=1 then
              Begin
                str:=str + listChanel[i]+', ' + IntToStr(sumInd)+ ',' + Format('%.5f',[sumVal]) + ', '+ IntToStr(STATE[sumStat]);
                str:=str + ns;
              end;
          end;
      end;

    if interval='month' then
      begin
        timeStart :=DayNull(timeStart);
        timeEnd   :=DayNull(timeEnd);
        for i:=0 to listChanel.Count-1 do
          Begin
            if getMeterStatus(listChanelVMID[i]) = 128 then
              Begin
                MeterNotFound(listChanel[i]);
                continue;
              end;
            sumVal:=0;
            m_pDDB.GetGData(timeEnd, timeStart, listChanelVMID[i], listChanelDID[i], 0, m_pArData);
            sumStat:=0;
            sumInd:=0;
            for j:=0 to m_pArData.Count-1 do
              begin
                bol := True;
                for z:=0 to length(tariff)-1 do
                  begin
                    status:=7;
                    if m_pArData.Items[j].m_sbyMaskRead = 1 then status:=0;
                    if sum=0 then
                      Begin
                        if m_pArData.Items[j].m_swTID = tariff[z] then
                          begin
                            str:=str +listChanel[i]+', ' + Format('%.5f',[m_pArData.Items[j].m_sfValue * x] ) + ', '+ IntToStr(STATE[status])
                                + ', '+ outTime(m_pArData.Items[j].m_sTime);
                            if ARequestInfo.Params.Values['tariff']<>'' then str:=str + ', ' + IntToStr(tariff[z]);
                            str:=str + ns;
                          end;
                      end
                    else if sum=1 then
                      Begin
                        if (m_pArData.Items[j].m_swTID = 0) and (bol = True) then
                          Begin
                            sumVal := sumVal + m_pArData.Items[j].m_sfValue * x;
                            sumInd := sumInd + 1;
                            bol := False;
                            if status<>0 then sumStat := status;
                          end;
                      end;
                  end;
              end;
            if sum=1 then
              Begin
                str:=str + listChanel[i]+', ' + IntToStr(sumInd)+', ' + Format('%.5f',[sumVal]) + ', '+ IntToStr(STATE[sumStat]);
                str:=str + ns;
              end;
          end;
      end;

    if interval='main' then
      begin
        t1:=t1 + 1 / (24 * 60 * 60);                                       //?????????????????????????????
        t2:=t2 + 1 / (24 * 60 * 60);
        for i:=0 to listChanel.Count-1 do
          Begin
            if getMeterStatus(listChanelVMID[i]) = 128 then
              Begin
                MeterNotFound(listChanel[i]);
                continue;
              end;
            m_pDDB.GetGraphDatas(timeEnd + 1, timeStart, listChanelVMID[i], listChanelDID[i], pTableHalf);
            sumVal:=0;
            sumStat:=0;
            sumInd:=0;
            for j:=0 to pTableHalf.Count-1 do
              begin
                 //status:=7;
                //if pTableHalf.Items[j].m_sMaskReRead = 1 then status:=0;
                dateMain :=pTableHalf.Items[j].m_sdtDate;
                dateMain := dateMain + 30 / (24 * 60);
                for k:=0 to 47 do
                  begin
                    //if (t1 < dateMain) and (dateMain < t2) then
                    if (t1 < dateMain) and (dateMain < (t2 + 30 / (24 * 60))) then
                      Begin
                        if sum=0 then
                          Begin
                             status:=7;
                            if ((pTableHalf.Items[j].m_sMaskReRead and (zdvig shl k)) <> 0) then status := 0;
                            str:=str +listChanel[i]+', ' + Format('%.5f',[pTableHalf.Items[j].v[k]*xm]) + ', '+IntToStr(STATE[status])
                              +', ' + outTime(dateMain);
                            str:=str + ns;
                          end
                        else if sum=1 then
                          Begin
                            sumVal := sumVal + pTableHalf.Items[j].v[k];
                            sumInd := sumInd + 1;
                            if status<>0 then sumStat := status;
                          end;
                      end;
                      dateMain := dateMain + 30 / (24 * 60);
                  end;
              end;
            if sum=1 then
              Begin
                str:=str + listChanel[i]+', ' + IntToStr(sumInd)+ ', ' + Format('%.5f',[sumVal]) + ', '+ IntToStr(STATE[sumStat]);
                str:=str + ns;
              end;
          end;
      end;

      if (interval='short') or (interval='year') then
        begin
          error := '������: �� ��������� ' + interval + ' ��� �������� (���. ���: ...)';
          Result:=False;
          Exit;
        end;
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Chan_Info(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
var
    i  : Integer;
    Name, Units, Module, NumInModule, SumShift,
    Fill, FillValue, Arc, Disp, KbdControl,
    MinLimit, MaxLimit, Coeff, strContr: string;
    KanType                            : Char;
    KanN                               : integer;
    pTable                             : SL2USPDCHARACTDEVLISTEX;
begin
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    Name       := '-';
    Units      := '-';
    Module     := '-';
    NumInModule := '-';
    SumShift   := '-';
    Fill       := 'Fixed';
    FillValue  := '0';
    Arc        := '-';
    MinLimit   := '0';
    MaxLimit   := '0';
    Disp       := 'NO';
    KbdControl := 'NO';
    Coeff      := '-';
    for i:=0 to listChanel.Count-1 do
      Begin
        KanType:= listChanel[i][1];
        KanN:=StrToInt(copy(listChanel[i],2, Length(listChanel[i])+1));
        m_pDDB.ReadUSPDCharDevCFG(true, pTable);
        strContr := '['+listChanel[i]+']' + ns;
        case KanType of
        'J' : if KanN = 0 then
           begin
             Name    := '������ ������� ����';
             Module  := '0';
             Arc     := 'NO';
           end
           else
             if KanN - 1 < pTable.Count then
             begin
               Name   := '������ ������� ����� ����� ' + pTable.Items[KanN - 1].m_sStrAdr;
               Module := IntToStr(KanN);
             end
               else Name := '������ �� ������';
        'G' : if (KanN = 0) or (KanN <= pTable.Count*15) then
           begin
             if KanN = 0 then begin Name := '���� �����-�'; Module := '0'; end else
             begin
               Name     := PAR_NAMES_CURR[(KanN - 1) mod 15, 0];
               Units    := PAR_NAMES_CURR[(KanN - 1) mod 15, 1];
               Module   := IntToStr((KanN - 1) div 15 + 1);
               NumInModule := IntToStr((KanN - 1) mod 15 + 1);
               Arc      := 'YES';
               Coeff    := FloatToStr(pTable.Items[(KanN - 1) div 15].m_sfKt);
             end;
           end
           else Name := '����� �� ������';
        'B' : if (KanN = 0) or (KanN <= pTable.Count*4) then
           begin
             if KanN = 0 then begin Name := '���� �����-�'; Module := '0'; end
             else
             begin
               Name     := PAR_NAMES_KVNA[(KanN - 1) mod 4, 0];
               Units    := PAR_NAMES_KVNA[(KanN - 1) mod 4, 1];
               Module   := IntToStr((KanN - 1) div 4 + 1);
               NumInModule := IntToStr((KanN - 1) mod 4 + 1);
               Arc      := 'YES';
               Coeff    := FloatToStr(pTable.Items[(KanN - 1) div 4].m_sfKt);
               SumShift := '0';
             end;
           end
            else Name := '����� �� ������';
         else begin Name := '����� �� ������';  end;
      end;
     strContr := strContr + 'Name=' + Name + ns + 'Units=' + Units + ns + 'Module=' + Module + ns +
             'NumInModule=' + NumInModule + ns + 'SumShift=' + SumShift + ns +
             'Fill=' + Fill + ns + 'FillValue=' + FillValue + ns +'Arc=' + Arc + ns +
             'MinLimit=' + MinLimit + ns +  'MaxLimit=' + MaxLimit + ns +
             'Disp=' + Disp + ns+'KbdControl=' + KbdControl + ns +
             'Coeff=' + Coeff + ns;
     if Length(strContr)*2 < max_size then str:= str + strContr;
    end;
         AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Current(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
var i, j, status : Integer;
    pTable       : L3CURRENTDATAS;
    sumVal       : Double;
begin
    typeEnergy := 'nak';
    sumVal     :=0;
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    {
    for i:=0 to listChanel.Count-1 do
      Begin
        str:=str + listChanel[i] + ' MID:  ' + IntToStr(listChanelVMID[i]) + ' DID:  ' +  IntToStr(listChanelDID[i])+ns;
      end;
    }
    str:=str + 'ShortChanName, Value, State' + ns;
    for i:=0 to listChanel.Count-1 do
      Begin
        if getMeterStatus(listChanelVMID[i]) = 128 then
          Begin
            MeterNotFound(listChanel[i]);
            continue;
          end;
        m_pDDB.GetCurrentData(listChanelVMID[i], listChanelDID[i], pTable);
        for j:=0 to pTable.Count-1 do
          begin
            //if (pTable.Items[j].m_swTID=1) or (pTable.Items[j].m_swTID=2) then
            if listChanel[i][1]='G' then
              begin
                status:=7;
                if pTable.Items[j].m_sbyMaskRead = 1 then status := 0;
                str:=str + listChanel[i]+ ', ' + Format('%.5f',[pTable.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]);
                str:=str + ns;
              end
            else
              begin
                case pTable.Items[j].m_swTID of
                1,2 : begin
                        sumVal:=sumVal + pTable.Items[j].m_sfValue * x;
                      end;
                3 : begin
                      sumVal:=sumVal + pTable.Items[j].m_sfValue * x;
                      status:=7;
                      if pTable.Items[j].m_sbyMaskRead = 1 then status := 0;
                      str:=str +listChanel[i]+', ' + Format('%.5f',[sumVal]) + ', '+ IntToStr(STATE[status]);
                      str:=str + ns;
                      sumVal:=0;
                    end;
               end;
            end;
          end;
      end;
    if (interval='short') or (interval='year') then
      begin
        error := '������: �� ��������� ' + interval + ' ��� �������� (���. ���: ...)';
        Result:=False;
        Exit;
      end;
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Last_event(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
var pTable               : SEVENTTAGS;
    i, j                 : Integer;
    Code                 : Word;
    comment              : string;
begin
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    fulltime := 1;
    str:='ShortChanName, Time, Value, Ipar, Fpar, Comment'+ns;
    for i:=0 to listChanel.Count-1 do
      Begin
//        m_pDDB.ReadJrnlLastCRQ(1, listChanelVMID[i], pTable);
        Code:=0;
        if pTable.Count = 0 then continue;
        comment:= EncodeEventToECOM(pTable.Items[0], Code);
        str:=str + listChanel[i] +', ' + outTime(pTable.Items[pTable.Count - 1].m_sdtEventTime) + ', '
           + IntToStr(Code) + ', 0, 0, ' + comment;
        str:=str + ns;
      end;
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Events(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) : Boolean;
var timeStart, timeEnd   : TDateTime;
    pTable               : SEVENTTAGS;
    i, j                 : Integer;
    Code                 : Word;
    comment              : string;
begin
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    fulltime := 1;
    if ARequestInfo.Params.Values['t2']='' then t2 := SysUtils.Date + SysUtils.Time;
    if ARequestInfo.Params.Values['t1']='' then
      begin
        Last_event(ARequestInfo, AResponseInfo);
        Exit;
      end;
    {
    for i:=0 to listChanel.Count-1 do
    Begin
    str:=str + listChanel[i] + ' MID:  ' + IntToStr(listChanelVMID[i]) + ' DID:  ' +  IntToStr(listChanelDID[i])+ns;
    end;
    }
    str:=str + 'ShortChanName, Time, Value, Ipar, Fpar, Comment'+ns;
    timeStart:= trunc(t1);
    timeEnd:= trunc(t2);
    for i:=0 to listChanel.Count-1 do
      Begin
//        m_pDDB.ReadJrnlEx(1, listChanelVMID[i], timeStart, timeEnd, pTable);
        for j:=0 to pTable.Count-1 do
          begin
            Code:=0;
            comment:= EncodeEventToECOM(pTable.Items[j], Code);
            str:=str + listChanel[i] +', ' + outTime(pTable.Items[j].m_sdtEventTime) + ', '
                + IntToStr(Code) + ', 0, 0, ' + comment;
            str:=str + ns;
          end;
      end;
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.GetTime(AResponseInfo: TIdHTTPResponseInfo): Boolean;
var date: TDateTime;
begin
    fulltime := 1;
    //date:= SysUtils.Date;
    date:= SysUtils.Date + SysUtils.Time;
    AResponseInfo.ContentText:=outTime(date);
    Result:=True;
end;

function CEcomCrqSrv.Ident(AResponseInfo: TIdHTTPResponseInfo): Boolean;
begin
   AResponseInfo.ContentText:='00000001';
   Result:=True;
end;

function CEcomCrqSrv.SetTime(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
var tST: TSystemTime;
begin
    Result:=True;
    fulltime := 1;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if abs((time - Now)*24*60*60) > 60*30 then begin error := '������: ������� ����� ������� �������� ���������� � �������� � ������� ��������� 30 ����� (���. ���: ...)'; Result:=False; Exit; end;
    DateTimeToSystemTime(time,tST);
    SetLocalTime(tST);
    AResponseInfo.ContentText:='����� ����������� � ��������: '+outTime(time);
end;

function CEcomCrqSrv.Sys_events(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
var timeStart, timeEnd   : TDateTime;
    pTable               : SEVENTTAGS;
    i, j                 : Integer;
    Code                 : Word;
    DateP                : TDateTime;
    comment              : string;
begin
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if (ARequestInfo.Params.Values['t1']='') or (ARequestInfo.Params.Values['t2']='') then DefaultTime(ARequestInfo);
    fulltime := 1;
    str:=str + 'ShortChanName, Time, Value, Ipar, Fpar, Comment' + ns;
    if (ARequestInfo.Params.Values['t2']<>'') or (ARequestInfo.Params.Values['t2']<>'') then
      begin
        timeStart:= trunc(t1);
        timeEnd:= trunc(t2);
//        m_pDDB.ReadJrnlEx(0, -1, timeStart, timeEnd, pTable);
        for j:=0 to pTable.Count-1 do
          begin
            Code:=0;
            comment:= EncodeEventToECOM(pTable.Items[j], Code);
            str:=str + 'J0, ' + outTime(pTable.Items[j].m_sdtEventTime) + ', '
                + IntToStr(Code) + ', 0, 0, ' + comment;
            str:=str + ns;
          end;
      end;
    if (ARequestInfo.Params.Values['n1']<>'') or (ARequestInfo.Params.Values['n2']<>'') then
      begin
//      m_pDDB.ReadJrnlIdCRQ(0, Ne1, Ne2, pTable);
      for j:=0 to pTable.Count-1 do
        begin
          Code:=0;
          comment:= EncodeEventToECOM(pTable.Items[j], Code);
          str:=str + 'J0, ' + outTime(pTable.Items[j].m_sdtEventTime) + ', '
             + IntToStr(Code) + ', 0, 0, ' + comment;
          str:=str + ns;
        end;
      end;
    AResponseInfo.ContentText:=str;
end;

function CEcomCrqSrv.Total(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
var i, j, k, status    : Integer;
    m_pArData          : CCDatas;
    pTable             : L3CURRENTDATAS;
    timeStart, timeEnd : TDateTime;
begin
    typeEnergy := 'nak';
    Result:=True;
    if InitPar(ARequestInfo) = False then begin Result:=False; Exit; end;
    if listChanel.Count = 0 then begin error := '������: ������� ����� ����� ������� (���. ���: ...)'; Result:=False; Exit; end;
    if (ARequestInfo.Params.Values['t1']='') or (ARequestInfo.Params.Values['t2']='') then DefaultTime(ARequestInfo);
    {
    for i:=0 to listChanel.Count-1 do
      Begin
        str:=str + listChanel[i] + ' MID:  ' + IntToStr(listChanelVMID[i]) + ' DID:  ' +  IntToStr(listChanelDID[i]) + ns;
      end;
    }
    fulltime := 1;
    timeStart := trunc(t1);
    timeEnd   := trunc(t2);
    str:=str + 'ShortChanName, Value, State, Time';
    if ARequestInfo.Params.Values['tariff']<>'' then str:=str + ', Tariff';
    str:=str + ns;
    if (interval='day') or (interval='month') then
      begin
        if interval='month' then
          begin
            timeStart :=DayNull(timeStart);
            timeEnd   :=DayNull(timeEnd);
          end;
        for i:=0 to listChanel.Count-1 do
          Begin
            if getMeterStatus(listChanelVMID[i]) = 128 then
              Begin
                MeterNotFound(listChanel[i]);
                continue;
              end;
            m_pDDB.GetGData(timeEnd, timeStart, listChanelVMID[i], listChanelDID[i], 0, m_pArData);
              for j:=0 to m_pArData.Count-1 do
                begin
                  for k:=0 to length(tariff)-1 do
                    begin
                      if tariff[k] = m_pArData.Items[j].m_swTID then
                        begin
                          status:=7;
                          if m_pArData.Items[j].m_sbyMaskRead = 1 then status:=0;
                          str:=str +listChanel[i] + ', ' + Format('%.5f',[m_pArData.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]) +
                              ', '+outTime(m_pArData.Items[j].m_sTime);
                          if ARequestInfo.Params.Values['tariff']<>'' then str := str+ ', ' + IntToStr(m_pArData.Items[j].m_swTID);
                          str:=str + ns;
                        end;
                    end;
                end;
          end;
      end;
    if (interval='no') or (interval='main') then
      begin
         for i:=0 to listChanel.Count-1 do
          Begin
            if getMeterStatus(listChanelVMID[i]) = 128 then
              Begin
                MeterNotFound(listChanel[i]);
                continue;
              end;
            m_pDDB.GetCurrentData(listChanelVMID[i], listChanelDID[i], pTable);
              for j:=0 to pTable.Count-1 do
                begin
                  for k:=0 to length(tariff)-1 do
                     begin
                      if tariff[k] = pTable.Items[j].m_swTID then
                        begin
                          status:=7;
                          if pTable.Items[j].m_sbyMaskRead = 1 then status:=0;
                          str:=str +listChanel[i] + ', ' + Format('%.5f',[pTable.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]) +
                              ', '+outTime(pTable.Items[j].m_sTime);
                          if  ARequestInfo.Params.Values['tariff']<>'' then str := str+ ', ' + IntToStr(pTable.Items[j].m_swTID);
                          str:=str + ns;
                        end;
                    end;
                end;
          end;
      end;
      {
      if interval='main' then
        begin

        end;
      }
      if interval='all' then                                                    //��� ��������� �� ������ ����
        begin
          for i:=0 to listChanel.Count-1 do
            Begin
              if getMeterStatus(listChanelVMID[i]) = 128 then
                Begin
                  MeterNotFound(listChanel[i]);
                  continue;
                end;

                m_pDDB.GetCurrentData(listChanelVMID[i], QRY_ENERGY_SUM_EP + (StrToInt(copy(listChanel[i],2, Length(listChanel[i])+1)) - 1) mod 4, pTable);
                for j:=0 to pTable.Count-1 do
                  begin
                  for k:=0 to length(tariff)-1 do
                     begin
                      if tariff[k] = pTable.Items[j].m_swTID then
                        begin
                          status:=7;
                          if pTable.Items[j].m_sbyMaskReRead = 1 then status:=0;
                          str:=str +listChanel[i] + ', ' + Format('%.5f',[pTable.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]) +
                              ', '+outTime(pTable.Items[j].m_sTime);
                          if  ARequestInfo.Params.Values['tariff']<>'' then str := str+ ', ' + IntToStr(pTable.Items[j].m_swTID);
                          str:=str + ns;
                        end;
                    end;
                  end;
              m_pDDB.GetGData(timeEnd, timeStart, listChanelVMID[i], QRY_NAK_EN_DAY_EP + (StrToInt(copy(listChanel[i],2, Length(listChanel[i])+1)) - 1) mod 4, 0, m_pArData);
              for j:=0 to m_pArData.Count-1 do
                begin
                  for k:=0 to length(tariff)-1 do
                    begin
                      if tariff[k] = m_pArData.Items[j].m_swTID then
                        begin
                          status:=7;
                          if m_pArData.Items[j].m_sbyMaskRead = 1 then status:=0;
                          str:=str +listChanel[i] + ', ' + Format('%.5f',[m_pArData.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]) +
                              ', '+outTime(m_pArData.Items[j].m_sTime);
                          if ARequestInfo.Params.Values['tariff']<>'' then str := str+ ', ' + IntToStr(m_pArData.Items[j].m_swTID);
                          str:=str + ns;
                        end;
                    end;
                end;
              m_pDDB.GetGData(timeEnd, timeStart, listChanelVMID[i], QRY_NAK_EN_MONTH_EP + (StrToInt(copy(listChanel[i],2, Length(listChanel[i])+1)) - 1) mod 4, 0, m_pArData);
              for j:=0 to m_pArData.Count-1 do
                begin
                  for k:=0 to length(tariff)-1 do
                    begin
                      if tariff[k] = m_pArData.Items[j].m_swTID then
                        begin
                          status:=7;
                          if m_pArData.Items[j].m_sbyMaskRead = 1 then status:=0;
                          str:=str +listChanel[i] + ', ' + Format('%.5f',[m_pArData.Items[j].m_sfValue * x]) + ', '+ IntToStr(STATE[status]) +
                              ', '+outTime(m_pArData.Items[j].m_sTime);
                          if ARequestInfo.Params.Values['tariff']<>'' then str := str+ ', ' + IntToStr(m_pArData.Items[j].m_swTID);
                          str:=str + ns;
                        end;
                    end;
                end;

            end;
        end;
      if (interval='short') or (interval='year') then
        begin
          error := '������: �� ��������� ' + interval + ' ��� �������� (���. ���: ...)';
          Result:=False;
          Exit;
        end;
     AResponseInfo.ContentText:=str;
end;


end.


