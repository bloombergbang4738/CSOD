unit knsl2qwerybyttmr;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer,
controls,{utldatabase,}{knsl5tracer,}knsl3EventBox,ShellAPI,forms,utlTimeDate;
type
    //CTimeSheduler
    CTimeSheduler = class
    protected
     m_nTbl  : QGPARAM;
     m_wYear : Word;
     m_wMonth: Word;
     m_wDay  : Word;
     m_wDayW : Word;
     m_wHour : Word;
     m_wMin  : Word;
     m_wSec  : Word;
     m_wMSec : Word;
     m_dtTimeNode : TDateTime;
     m_dtLastNode : TDateTime;
     m_dtLastFullNode : TDateTime;
     m_dtTimeFullNode : TDateTime;
     m_sblState   : Boolean;
     m_blFindST   : Boolean;
     m_blPostExpired : Boolean;
     m_nDT    : CDTRouting;
     destructor Destroy();override;
     function IsFindDM:Boolean;
     function IsFindDW:Boolean;
     function IsFindDC:Boolean;
     function IsTimeExpired:Boolean;
     function FindTimeNode(nNextNode:Integer;var dtTime:TDateTime):Boolean;
     function IsEnabled:Boolean;

     procedure OnSelfExpired;
    protected
     constructor Create(var pTbl:QGPARAM);
     procedure OnExpired; virtual;
     procedure OnInit; virtual;
    public
     function getID:Integer;
     function IsTimeValid:Boolean;
     procedure Init(var pTbl:QGPARAM);
     procedure Run;
    End;
implementation
//CTimeSheduler
destructor CTimeSheduler.Destroy();
Begin
  if m_nDT <> nil then FreeAndNil(m_nDT);
  inherited;
End;

constructor CTimeSheduler.Create(var pTbl:QGPARAM);
Begin
    if m_nDT = nil then  m_nDT := CDTRouting.Create;
    Init(pTbl);
    if m_nDT <> nil then FreeAndNil(m_nDT);
End;

procedure CTimeSheduler.Init(var pTbl:QGPARAM);
Begin
     Move(pTbl, m_nTbl, sizeof(QGPARAM));
     OnInit;
     m_blFindST := False;
     if (frac(Now)>=frac(m_nTbl.DTBEGIN))and(frac(Now)<=frac(m_nTbl.DTEND)) then
     Begin
      FindTimeNode(1,m_dtTimeNode);
      m_dtLastNode := m_dtTimeNode;
     End else
     Begin
      m_dtTimeNode := 0;
      m_dtLastNode := 0;
     End;
     //TraceL(3,0,'(__)CQTMD::>INIT T00:'+TimeToStr(Now)+' m_dtLastNode:'+TimeToStr(m_dtLastNode));
     m_blPostExpired := False;
End;

procedure CTimeSheduler.OnInit;
Begin
End;
function CTimeSheduler.getID:Integer;
Begin
     Result := m_nTbl.PARAM;
End;
function CTimeSheduler.FindTimeNode(nNextNode:Integer;var dtTime:TDateTime):Boolean;
Var
     nPD : Integer;
Begin
     Result := False;
     if (frac(Now)>=frac(m_nTbl.DTBEGIN))and(frac(Now)<=frac(m_nTbl.DTEND)) then
     Begin
      if frac(m_nTbl.DTPERIOD)<>0 then
      Begin
       //nTimePD := trunc((frac(Now)-frac(m_nTbl.DTBEGIN))/frac(m_nTbl.DTPERIOD));
       //dtTime := (nTimePD+nNextNode)*frac(m_nTbl.DTPERIOD);
       nPD := trunc((frac(Now)-frac(m_nTbl.DTBEGIN))/frac(m_nTbl.DTPERIOD));
       dtTime := frac(m_nTbl.DTBEGIN)+nPD*frac(m_nTbl.DTPERIOD);
       Result := True;
       //DecodeTime(dtTime,h0,m0,s0,ms0);
       //TraceL(3,0,'(__)CQTMD::>N CURR:'+TimeToStr(Now)+' NODE(n+1):'+TimeToStr(dtTime)+' nPD:'+IntToStr(nPD));
      End else Result := False;
     End else Result := False;
End;
function CTimeSheduler.IsTimeValid:Boolean;
Begin
     Result := False;
     if (frac(Now)>=frac(m_nTbl.DTBEGIN))and(frac(Now)<=frac(m_nTbl.DTEND)) then
     Result := True;
End;
function CTimeSheduler.IsFindDM:Boolean;
Var
     dw1 : int64;
Begin
     dw1 := 1;
     Result := (m_nTbl.MONTHMASK and (dw1 shl m_wDay))<>0;
     //if ((1 shl m_wDay) or MTM_ENABLE)=m_nTbl.MONTHMASK then Result := True;
     //if ((1 shl m_wDay) or MTM_ENABLE)=m_nTbl.MONTHMASK then Result := True;
End;
function CTimeSheduler.IsFindDW:Boolean;
Var
     dw1 : int64;
Begin
     dw1 := 1;
     //if ((1 shl m_wDayW) or DYM_ENABLE)=m_nTbl.DAYMASK then Result := True;
     Result := (m_nTbl.DAYMASK and (dw1 shl m_wDayW))<>0;
     //if ((1 shl m_wDayW) or DYM_ENABLE)=m_nTbl.DAYMASK then Result := True;
End;
function CTimeSheduler.IsFindDC:Boolean;
Var
     res0 : Boolean;
Begin
     Result := False;
     //TraceL(3,0,'(__)CQTMD::>IsFindDC Time:'+TimeToStr(Now)+' T(n-1):'+TimeToStr(m_dtLastNode)+' T(n):'+TimeToStr(m_dtTimeNode));
     res0 := FindTimeNode(1,m_dtTimeNode);
     if (res0=True) and (frac(m_dtTimeNode)<>frac(m_dtLastNode)) then
     Begin
      //TraceL(3,0,'(__)CQTMD::>Expired!!! Time:'+TimeToStr(Now)+' T(n-1):'+TimeToStr(m_dtLastNode)+' T(n):'+TimeToStr(m_dtTimeNode));
      m_dtLastNode := m_dtTimeNode;
      Result       := True;
     End else
     if (res0=False) then
     Begin
      m_dtTimeNode := 0;
      m_dtLastNode := 0;
     End;
     //TraceL(3,0,'(__)CQTMD::>D2 T0:'+TimeToStr(Now)+' T1:'+TimeToStr(m_dtLastNode)+' T2:'+TimeToStr(m_dtTimeNode));
End;

procedure CTimeSheduler.OnSelfExpired;
Begin
     OnExpired;
End;

procedure CTimeSheduler.OnExpired;
Begin
     //Override
End;

function CTimeSheduler.IsTimeExpired:Boolean;
Var
     blM,blD:Boolean;
Begin
     blM := (m_nTbl.MONTHMASK and MTM_ENABLE)<>0;
     blD := (m_nTbl.DAYMASK and DYM_ENABLE)<>0;
     if (blM=True)and(blD=False)  then
     Begin
      if (IsFindDM=True)and(IsFindDC=True) then
                                                OnSelfExpired;
     End else
     if (blD=True)and(blM=False)  then
     Begin
      if (IsFindDW=True)and(IsFindDC=True) then
                                                OnSelfExpired;
     End else
     if (blD=False)and(blM=False) then
     Begin
      if (IsFindDC=True) then
                              OnSelfExpired;
     End else exit;
End;
function CTimeSheduler.IsEnabled:Boolean;
Begin
     Result := (m_nTbl.Enable=1);
End;
procedure CTimeSheduler.Run;
Begin
     if (m_nTbl.Enable=1)and(m_nTbl.Pause=0) then
     Begin
      DecodeDate(Now,m_wYear,m_wMonth,m_wDay);
      DecodeTime(Now,m_wHour,m_wMin,m_wSec,m_wMSec);
      m_wDayW := DayOfWeek(Now);
      IsTimeExpired;
     End;
End;

end.

