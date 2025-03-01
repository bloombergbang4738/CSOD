unit knsl2qwerytmr;
interface
uses
Windows, Classes, SysUtils,SyncObjs,stdctrls,comctrls,utltypes,utlbox,utlconst,utlmtimer,
controls,utldatabase,{knsl5tracer,}knsl3EventBox,ShellAPI,forms,utlTimeDate;
type
    //CTimeMDL
    THandles = packed record
     m_sProcHandle   : THandle;
     m_sTHreadHandle : THandle;
    End;
    CTimeMDL = class
    protected
     m_nTbl  : SQWERYMDL;
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
     m_hHandle    : int64;
     FForm    : TForm;
     m_nDT    : CDTRouting;
     destructor Destroy();override;
     function IsFindDM:Boolean;
     function IsFindDW:Boolean;
     function IsFindDC:Boolean;
     function IsTimeExpired:Boolean;
     function FindTimeNode(nNextNode:Integer;var dtTime:TDateTime):Boolean;
     function IsEnabled:Boolean;

     function IsExpiredInPack:Boolean;
     function CopyFile(strSrc,strDst:String):Boolean;
     function CopyBase(strSrc,strDst:String):Boolean;
     function CreatePath(strSrc:String):Boolean;
     function DeletePath(strSrc:String):Boolean;
     function StartProcessEx(strPath:String;blWait,blClose:Boolean):THandles;
     procedure OnSelfExpired;
    protected
     constructor Create(var pTbl:SQWERYMDL);
     procedure OnExpired; virtual;
     procedure OnInit; virtual;
    public
     function IsExists(nCMD:Integer):Boolean;virtual;
     function IsComplette(nCMD:Integer):Boolean;
     function IsTimeValid:Boolean;
     //procedure SendErrorL2;
     procedure SetCmdState(nCMD:Integer);
     procedure FreeCmdState(nCMD:Integer);
     procedure Init(var pTbl:SQWERYMDL);
     procedure Run;
    property PForm : TForm read FForm write FForm;
    End;
implementation
//CTimeMDL
destructor CTimeMDL.Destroy();
Begin
    if m_nDT <> nil then FreeAndNil(m_nDT);
    inherited;
End;
constructor CTimeMDL.Create(var pTbl:SQWERYMDL);
Begin
    m_nDT := CDTRouting.Create;
    Init(pTbl);
End;
procedure CTimeMDL.Init(var pTbl:SQWERYMDL);
Begin
     Move(pTbl,m_nTbl,sizeof(SQWERYMDL));
     OnInit;
     m_blFindST := False;
     if (frac(Now)>=frac(m_nTbl.m_sdtBegin))and(frac(Now)<=frac(m_nTbl.m_sdtEnd)) then
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
procedure CTimeMDL.SetCmdState(nCMD:Integer);
Var
     str,strO,strN: String;
Begin
     if IsEnabled=True then
     Begin
      str  := m_nTbl.m_strCMDCluster;
      strO := IntToStr(nCMD or CMD_ENABLED);
      strN := IntToStr(nCMD or CMD_QWRCMPL);
      str  := StringReplace(str,strO,strN,[rfReplaceAll]);
      m_nTbl.m_strCMDCluster := str;
     End;
End;
procedure CTimeMDL.FreeCmdState(nCMD:Integer);
Var
     str : String;
Begin
     if IsEnabled=True then
     Begin
      str := m_nTbl.m_strCMDCluster;
      str := StringReplace(str,IntToStr(nCMD or CMD_QWRCMPL),IntToStr(nCMD or CMD_ENABLED),[rfReplaceAll]);
      m_nTbl.m_strCMDCluster := str;
     End;
End;
function CTimeMDL.IsComplette(nCMD:Integer):Boolean;
Begin
     if IsEnabled=True then
     Result := pos(IntToStr(nCMD or CMD_QWRCMPL),m_nTbl.m_strCMDCluster)<>0;
End;
function CTimeMDL.IsExists(nCMD:Integer):Boolean;
Begin
     Result := False;
     if IsEnabled=True then
     Begin
      if pos(IntToStr(nCMD or CMD_QWRCMPL),m_nTbl.m_strCMDCluster)<>0 then Begin Result := True;exit;End else
      if pos(IntToStr(nCMD or CMD_ENABLED),m_nTbl.m_strCMDCluster)<>0 then Begin Result := True;exit;End;
      //if pos(IntToStr(nCMD               ),m_nTbl.m_strCMDCluster)<>0 then Begin Result := True;exit;End;
     End;
End;
procedure CTimeMDL.OnInit;
Begin
End;
function CTimeMDL.FindTimeNode(nNextNode:Integer;var dtTime:TDateTime):Boolean;
Var
     nPD : Integer;
Begin
     Result := False;
     if (frac(Now)>=frac(m_nTbl.m_sdtBegin))and(frac(Now)<=frac(m_nTbl.m_sdtEnd)) then
     Begin
      if frac(m_nTbl.m_sdtPeriod)<>0 then
      Begin
       //nTimePD := trunc((frac(Now)-frac(m_nTbl.m_sdtBegin))/frac(m_nTbl.m_sdtPeriod));
       //dtTime := (nTimePD+nNextNode)*frac(m_nTbl.m_sdtPeriod);
       nPD := trunc((frac(Now)-frac(m_nTbl.m_sdtBegin))/frac(m_nTbl.m_sdtPeriod));
       dtTime := frac(m_nTbl.m_sdtBegin)+nPD*frac(m_nTbl.m_sdtPeriod);
       Result := True;
       //DecodeTime(dtTime,h0,m0,s0,ms0);
       //TraceL(3,0,'(__)CQTMD::>N CURR:'+TimeToStr(Now)+' NODE(n+1):'+TimeToStr(dtTime)+' nPD:'+IntToStr(nPD));
      End else Result := False;
     End else Result := False;
End;
function CTimeMDL.IsTimeValid:Boolean;
Begin
     Result := False;
     if (frac(Now)>=frac(m_nTbl.m_sdtBegin))and(frac(Now)<=frac(m_nTbl.m_sdtEnd)) then
     Result := True;
End;
function CTimeMDL.IsFindDM:Boolean;
Var
     dw1 : int64;
Begin
     dw1 := 1;
     Result := (m_nTbl.m_sdwMonthMask and (dw1 shl m_wDay))<>0;
     //if ((1 shl m_wDay) or MTM_ENABLE)=m_nTbl.m_sdwMonthMask then Result := True;
     //if ((1 shl m_wDay) or MTM_ENABLE)=m_nTbl.m_sdwMonthMask then Result := True;
End;
function CTimeMDL.IsFindDW:Boolean;
Var
     dw1 : int64;
Begin
     dw1 := 1;
     //if ((1 shl m_wDayW) or DYM_ENABLE)=m_nTbl.m_swDayMask then Result := True;
     Result := (m_nTbl.m_swDayMask and (dw1 shl m_wDayW))<>0;
     //if ((1 shl m_wDayW) or DYM_ENABLE)=m_nTbl.m_swDayMask then Result := True;
End;
function CTimeMDL.IsFindDC:Boolean;
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
procedure CTimeMDL.OnSelfExpired;
Begin
     if (m_blIsBackUp=True)  then  m_blPostExpired := True else
     if (m_blIsBackUp=False) then  OnExpired;
End;
procedure CTimeMDL.OnExpired;
Begin
     //Override
End;
function CTimeMDL.IsExpiredInPack:Boolean;
Begin
     Result := False;
     if (m_blPostExpired=True)and(m_blIsBackUp=False) then
     Begin
      m_blPostExpired :=False;
      Result := True;
     End;
End;
function CTimeMDL.IsTimeExpired:Boolean;
Var
     blM,blD:Boolean;
Begin
     blM := (m_nTbl.m_sdwMonthMask and MTM_ENABLE)<>0;
     blD := (m_nTbl.m_swDayMask and DYM_ENABLE)<>0;
     if IsExpiredInPack=True               then OnSelfExpired else
     if (blM=True)and(blD=False)  then
     Begin
      if (IsFindDM=True)and(IsFindDC=True) then OnSelfExpired;
     End else
     if (blD=True)and(blM=False)  then
     Begin
      if (IsFindDW=True)and(IsFindDC=True) then OnSelfExpired;
     End else
     if (blD=False)and(blM=False) then
     Begin
      if (IsFindDC=True)                   then OnSelfExpired;
     End else
End;
function CTimeMDL.IsEnabled:Boolean;
Begin
     Result := (m_nTbl.m_sbyEnable=1);
End;
function CTimeMDL.CopyFile(strSrc,strDst:String):Boolean;
Begin
    Result := CopyBase(strSrc,strDst);
End;
function CTimeMDL.CopyBase(strSrc,strDst:String):Boolean;
var
    OpStruc: TSHFileOpStruct;
    frombuf, tobuf: array [0..128] of Char;
    x,y:string;
Begin
    //x:='\\ssmdev\client\Client';//������;
    //y:='C:\Users\SSM-DEV\Desktop\lancher\Debug\Win32\id1\';//����;
    try
    if FileExists(strSrc)=True then
    Begin
     FillChar(frombuf,Sizeof(frombuf),0);
     FillChar(tobuf  ,Sizeof(tobuf),0);
     StrPCopy(frombuf,strSrc);
     StrPCopy(tobuf  ,strDst);
     with OpStruc do
     begin
      Wnd    := PForm.Handle;
      wFunc  := FO_COPY;
      pFrom  := @frombuf;
      pTo    := @tobuf;
      fFlags := FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION or FOF_SILENT;
      fAnyOperationsAborted := False;
      hNameMappings         := nil;
      lpszProgressTitle     := nil;
     end;
     ShFileOperation(OpStruc);
    End;
    except
     
    end;
End;
function CTimeMDL.CreatePath(strSrc:String):Boolean;
var
    OpStruc: TSHFileOpStruct;
    frombuf: array [0..128] of Char;
    x,y:string;
Begin
    //x:='\\ssmdev\client\Client';//������;
    //y:='C:\Users\SSM-DEV\Desktop\lancher\Debug\Win32\id1\';//����;
    try
    Result := True;
    //if FileExists(strSrc)=True then
    Begin
     FillChar(frombuf,Sizeof(frombuf),0);
     StrPCopy(frombuf,strSrc);
     with OpStruc do
     begin
      Wnd    := PForm.Handle;
      wFunc  := FO_COPY;
      pFrom  := @frombuf;
      pTo    := @frombuf;
      fFlags := FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION or FOF_SILENT;
      fAnyOperationsAborted := False;
      hNameMappings         := nil;
      lpszProgressTitle     := nil;
     end;
     ShFileOperation(OpStruc);
    End;
    except
     
    end;
End;
function CTimeMDL.DeletePath(strSrc:String):Boolean;
var
    OpStruc: TSHFileOpStruct;
    frombuf: array [0..128] of Char;
    x,y:string;
Begin
    //x:='\\ssmdev\client\Client';//������;
    //y:='C:\Users\SSM-DEV\Desktop\lancher\Debug\Win32\id1\';//����;
    try
    Result := True;
    //if FileExists(strSrc)=True then
    Begin
     FillChar(frombuf,Sizeof(frombuf),0);
     StrPCopy(frombuf,strSrc);
     with OpStruc do
     begin
      Wnd    := PForm.Handle;
      wFunc  := FO_DELETE;
      pFrom  := @frombuf;
      pTo    := @frombuf;
      fFlags := FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION or FOF_SILENT;
      fAnyOperationsAborted := False;
      hNameMappings         := nil;
      lpszProgressTitle     := nil;
     end;
     ShFileOperation(OpStruc);
    End;
    except
     
    end;
End;
function CTimeMDL.StartProcessEx(strPath:String;blWait,blClose:Boolean):THandles;
Var
     si : STARTUPINFO;
     pi : PROCESS_INFORMATION;
     iRes : Boolean;
     dwRes: LongWord;
     pp : THandles;
begin
     FillChar(si,sizeof(si),0);
     FillChar(pi,sizeof(pi),0);
     FillChar(pp,sizeof(pp),0);
     si.cb := sizeof(si);
     //si.wShowWindow:=SW_HIDE;
     //si.dwFlags:= STARTF_USESHOWWINDOW;
     iRes := CreateProcess(Nil, PChar(strPath), Nil, Nil, FALSE, HIGH_PRIORITY_CLASS, Nil, Nil, si, pi);
     if(iRes=False) then
     begin
      //TraceL(4,0,':Process is not created');
      result := pp;
     end;
     if(blWait) then
     begin
      dwRes := WaitForSingleObject(pi.hProcess,60*1000);
      //if(dwRes=WAIT_ABANDONED) then TraceL(4,0,':Process is abandoned!');
     end;
     if blClose=True then
     Begin
      CloseHandle( pi.hProcess );
      CloseHandle( pi.hThread );
     End;
     pp.m_sProcHandle   := pi.hProcess;
     pp.m_sTHreadHandle := pi.hThread;
     result := pp;
end;
procedure CTimeMDL.Run;
Begin
     if (m_nTbl.m_sbyEnable=1)and(m_nTbl.m_sbyPause=0) then
     Begin
      DecodeDate(Now,m_wYear,m_wMonth,m_wDay);
      DecodeTime(Now,m_wHour,m_wMin,m_wSec,m_wMSec);
      m_wDayW := DayOfWeek(Now);
      IsTimeExpired;
     End;
End;
end.

