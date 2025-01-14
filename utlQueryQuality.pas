unit utlQueryQuality;

interface

uses
  Forms, ComObj, SysUtils, utlDB;

type
  TQQData = record
    Dats : TDateTime;  // 10 ��������
    Stat : Byte;       // 1-3 �������
    Perc : Byte;       // 1-3 �������
  end;

  TQueryQuality = class
    public
      Months : TQQData;  // �����   17 ��������  DD.MM.YYYY;X;XXX;
      Days   : TQQData;  // ����    17 ��������  DD.MM.YYYY;X;XXX;
      Currs  : TQQData;  // ������� 17 ��������  DD.MM.YYYY;X;XXX;
      procedure GetQueryQuality(AbonID : integer);
      procedure SetQueryQuality(AbonID : integer);
      procedure SetQueryQualityInNil(AbonID : integer); // ��� ���������� �������� ������� ���������� ('')
      function GetQQMonths(AbonID : integer): TQQData;
      procedure SetQQMonths(AbonID : integer; QData : TQQData);
      function GetQQDays(AbonID : integer): TQQData;
      procedure SetQQDays(AbonID : integer; QData : TQQData);
      function GetQQCurrs(AbonID : integer): TQQData;
      procedure SetQQCurrs(AbonID : integer; QData : TQQData);
      function GetPercent(AbonID : integer) : Double;
  end;

//var QueryQuality : TQueryQuality;
//    QQData       : TQQData;

implementation

function GetStr(var str : string):string;
var h : Integer;
begin
  h := Pos(';', str);
  if h <> 0 then begin
    Result := Copy(str,1,h-1);
    delete(str,1,h);
  end else Result := '';
end;

function GetDate(var str : string): TDateTime;
var s : string;
begin
  s := GetStr(str);
  if Length(s) > 0 then begin
    try
      Result := StrToDate(s);
    except
      Result := StrToDate('01.01.1990');
    end;
  end else Result := StrToDate('01.01.1990');
end;

function GetByte(var str : string) : Byte;
var s : string;
begin
  s := GetStr(str);
  if Length(s) > 0 then begin
    try
      Result := StrToInt(s);
    except
      Result := StrToInt('255');
    end;
  end else Result := StrToInt('255');
end;

{ TQueryQuality }

procedure TQueryQuality.GetQueryQuality(AbonID: integer);
var strSQL     : string;
    nCount, i  : integer;
    str        : string;
begin
  strSQL:='SELECT QUERYQUALITY FROM SL3ABON WHERE M_SWABOID = ' + IntToStr(AbonID);
  if utlDB.DBase.OpenQry(strSQL,nCount)=True then begin
    for i := 0 to utlDB.DBase.IBQuery.RecordCount-1 do begin
      Str := utlDB.DBase.IBQuery.FieldByName('QUERYQUALITY').AsString;
      Months.Dats := GetDate(str);
      Months.Stat := GetByte(str);
      Months.Perc := GetByte(str);
      Days.Dats   := GetDate(str);
      Days.Stat   := GetByte(str);
      Days.Perc   := GetByte(str);
      Currs.Dats  := GetDate(str);
      Currs.Stat  := GetByte(str);
      Currs.Perc  := GetByte(str);
      utlDB.DBase.IBQuery.Next;
    end;
  end
end;


procedure TQueryQuality.SetQueryQuality(AbonID: integer);
var str        : string;
    strSQL     : string;
begin
{  Months.Dats := StrToDate('1.1.2001');
  Months.Stat := 10;
  Months.Perc := 98;
  Days.Dats := StrToDate('2.2.2002');
  Days.Stat := 20;
  Days.Perc := 99;
  Currs.Dats := StrToDate('3.3.2003');
  Currs.Stat := 30;
  Currs.Perc := 100; }

  str :=       DateToStr(Months.Dats) + ';' + IntToStr(Months.Stat) + ';' + IntToStr(Months.Perc) + ';';
  str := str + DateToStr(Days.Dats)   + ';' + IntToStr(Days.Stat)   + ';' + IntToStr(Days.Perc)   + ';';
  str := str + DateToStr(Currs.Dats)  + ';' + IntToStr(Currs.Stat)  + ';' + IntToStr(Currs.Perc)  + ';';
  strSQL := 'UPDATE SL3ABON SET QUERYQUALITY = ''' + str + ''' WHERE M_SWABOID = ' + IntToStr(AbonID);
  utlDB.DBase.ExecQry(strSQL);
end;

procedure TQueryQuality.SetQueryQualityInNil;
var str        : string;
    strSQL     : string;
begin
  str := ';;;;;;;;;';
  strSQL := 'UPDATE SL3ABON SET QUERYQUALITY = ''' + str + ''' WHERE M_SWABOID = ' + IntToStr(AbonID);
  utlDB.DBase.ExecQry(strSQL);
end;

function TQueryQuality.GetQQMonths(AbonID: integer): TQQData;
begin
  GetQueryQuality(AbonID);
  Result := Months;
end;

procedure TQueryQuality.SetQQMonths(AbonID: integer; QData: TQQData);
begin
  GetQueryQuality(AbonID);
  Months.Dats := QData.Dats;
  Months.Stat := QData.Stat;
  Months.Perc := QData.Perc;
  SetQueryQuality(AbonID);
end;

function TQueryQuality.GetQQDays(AbonID: integer): TQQData;
begin
  GetQueryQuality(AbonID);
  Result := Days;
end;

procedure TQueryQuality.SetQQDays(AbonID: integer; QData: TQQData);
begin
  GetQueryQuality(AbonID);
  Days.Dats := QData.Dats;
  Days.Stat := QData.Stat;
  Days.Perc := QData.Perc;
  SetQueryQuality(AbonID);
end;

function TQueryQuality.GetQQCurrs(AbonID: integer): TQQData;
begin
  GetQueryQuality(AbonID);
  Result := Currs;
end;

procedure TQueryQuality.SetQQCurrs(AbonID: integer; QData: TQQData);
begin
  GetQueryQuality(AbonID);
  Currs.Dats := QData.Dats;
  Currs.Stat := QData.Stat;
  Currs.Perc := QData.Perc;
  SetQueryQuality(AbonID);
end;


function TQueryQuality.GetPercent(AbonID: integer): Double;
var strSQL     : string;
    nCount     : integer;
    d1, d2     : Double;
begin
  strSQL:='SELECT COUNT(L2T.M_SWABOID) as S1, ' +
          'COUNT(case when L2T.QUERYSTATE=0 then L2T.M_SWABOID end) as S2, ' +
          'COUNT(case when L2T.QUERYSTATE=2 then L2T.M_SWABOID end) as S3 ' +
          'FROM QUERYGROUP QG, QGABONS QGA, L2TAG L2T ' +
          'WHERE L2T.M_SBYENABLE = 1 AND QG.ID = QGA.QGID ' +
          '  AND QGA.ABOID = L2T.M_SWABOID AND QGA.ABOID = ' + IntToStr(AbonID) + ' ' +
          'GROUP BY QG.NAME, QG.ID ';
  if utlDB.DBase.OpenQry(strSQL,nCount)=True then begin
    d1 := StrToFloat(utlDB.DBase.IBQuery.FieldByName('S2').AsString);
    d2 := StrToFloat(utlDB.DBase.IBQuery.FieldByName('S1').AsString);
    Result := (d1 / d2) * 100;
  end else Result := -1;
end;

end.
