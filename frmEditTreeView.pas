unit frmEditTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, utlconst, utlDB, ToolWin,
  frmFETWPanel, AdvOfficePager, AdvPanel, AdvOfficePagerStylers;

type
  TFrameEditTreeView = class(TFrame)
    TSVmeter: TAdvOfficePager;
    TSAddress: TAdvOfficePage;
    TSAbon: TAdvOfficePage;
    TSHome: TAdvOfficePage;
    AdvPanel1: TAdvPanel;
    AdvPanelStyler1: TAdvPanelStyler;
    fREGIN: TframeFETW;
    fRAYON: TframeFETW;
    fTOWNS: TframeFETW;
    fTPODS: TframeFETW;
    fSTRET: TframeFETW;
    fABONT: TframeFETW;
    pnlAddressRight: TAdvPanel;
    pnlAddressTop: TAdvPanel;
    lblAddress: TLabel;
    lstAddress: TListBox;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    procedure lstAddressClick(Sender: TObject);
  private
    function CbbCompare(cbb : TComboBox):Boolean;
    procedure InlstAddress(cbb : TComboBox);
   public
    REGIN         : Integer;
    RAYON         : Integer;
    TOWNS         : Integer;
    TPODS         : Integer;
    STRET         : Integer;
    ABONT         : Integer;
    ActiveProc    : integer;
    sss           : string;
    pnlColor      : array[0..5] of TframeFETW;
    procedure Init(lab : integer);   //  lab - ��� �������, ��� ����� �������������, 1 - �����,
    procedure NotVisableTabs;
    procedure InitFETW;
   end;

implementation

{$R *.DFM}

{$R+}

uses
{$IFDEF TESTMODE}

{$ELSE}
  knsl3abon, knsl5module;
{$ENDIF}

{ TFrameEditTreeView }

procedure TFrameEditTreeView.InitFETW;
var i : Integer;
begin
  pnlColor[0] := fREGIN;
  pnlColor[1] := fRAYON;
  pnlColor[2] := fTOWNS;
  pnlColor[3] := fTPODS;
  pnlColor[4] := fSTRET;
  pnlColor[5] := fABONT;
  for i := 0 to 5 do begin
    pnlColor[i].REGIN := REGIN;
    pnlColor[i].RAYON := RAYON;
    pnlColor[i].TOWNS := TOWNS;
    pnlColor[i].TPODS := TPODS;
    pnlColor[i].STRET := STRET;
    pnlColor[i].ABONT := ABONT;
  end;
end;

procedure TFrameEditTreeView.Init(lab: integer);
var i : integer;
begin
   InitFETW;
//  fREGIN.InitObjects;
  ActiveProc:=SD_REGIN;
  case lab of
    ETV_ADDRESS : begin
      fREGIN.GetData(fREGIN.ComboBox);
      if REGIN = -1 then begin
        ActiveProc:=SD_REGIN;
        fREGIN.SetInNil(0);
        fREGIN.VisableFETW(1);
        fREGIN.GetData(fREGIN.ComboBox);
        fREGIN.SetColorHighlight(fREGIN.Panel);
//        fREGIN.Panel.Color := $00C2DEE4;
        lstAddress.ItemIndex:=0;
        InLstAddress(fREGIN.ComboBox);
        lblAddress.Caption := fREGIN.Label1.Caption;
        Exit;
      end else begin
        fREGIN.GetData(fREGIN.ComboBox);
        fREGIN.SetIndex;
        if RAYON = -1 then begin
          ActiveProc:=SD_RAYON;
          fRAYON.SetInNil(1);
          fRAYON.VisableFETW(2);
          fRAYON.GetData(fRAYON.ComboBox);
          fRAYON.SetColorHighlight(fRAYON.Panel);
          lstAddress.ItemIndex:=0;
          InLstAddress(fRAYON.ComboBox);
          lblAddress.Caption := fRAYON.Label1.Caption;
          Exit;
        end else begin
          fRAYON.GetData(fRAYON.ComboBox);
          fRAYON.SetIndex;
          if TOWNS = -1 then Begin
            ActiveProc:=SD_TOWNS;
            fTOWNS.SetInNil(2);
            fTOWNS.VisableFETW(3);
            fTOWNS.GetData(fTOWNS.ComboBox);
            fTOWNS.SetColorHighlight(fTOWNS.Panel);
            lstAddress.ItemIndex:=0;
            InLstAddress(fTOWNS.ComboBox);
            lblAddress.Caption := fTOWNS.Label1.Caption;
            Exit;
          end else begin
            fTOWNS.GetData(fTOWNS.ComboBox);
            fTOWNS.SetIndex;
            if TPODS = -1 then begin
              ActiveProc:=SD_TPODS;
              fTPODS.SetInNil(3);
              fTPODS.VisableFETW(4);
              fTPODS.GetData(fTPODS.ComboBox);
              fTPODS.SetColorHighlight(fTPODS.Panel);
              lstAddress.ItemIndex:=0;
              InLstAddress(fTPODS.ComboBox);
              lblAddress.Caption := fTPODS.Label1.Caption;
              Exit;
            end else begin
              fTPODS.GetData(fTPODS.ComboBox);
              fTPODS.SetIndex;
              if STRET = -1 then begin
                ActiveProc:=SD_STRET;
                fSTRET.SetInNil(4);
                fSTRET.VisableFETW(5);
                fSTRET.GetData(fSTRET.ComboBox);
                fSTRET.SetColorHighlight(fSTRET.Panel);
                lstAddress.ItemIndex:=0;
                InLstAddress(fSTRET.ComboBox);
                lblAddress.Caption := fSTRET.Label1.Caption;
                Exit;
              end else begin
                fSTRET.GetData(fSTRET.ComboBox);
                fSTRET.SetIndex;
                if ABONT = -1 then begin
                  ActiveProc:=SD_ABONT;
                  fABONT.SetInNil(5);
                  fABONT.VisableFETW(6);
                  fABONT.GetData(fABONT.ComboBox);
                  fABONT.SetColorHighlight(fABONT.Panel);
                  lstAddress.ItemIndex:=0;
                  InLstAddress(fABONT.ComboBox);
                  lblAddress.Caption := fABONT.Label1.Caption;
                  Exit;
                end else begin
                  ActiveProc:=SD_ABONT;
                  fABONT.GetData(fABONT.ComboBox);
                  fABONT.VisableFETW(6);
                  fABONT.SetIndex;
                  fABONT.SetColorHighlight(fABONT.Panel);
                  lblAddress.Caption := fABONT.Label1.Caption;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
 {     lblAddress.Caption:='���������';
      InlstAddress(cbbRegin);
      ActiveProc:=SD_REGIN; }
    end;
  end;
end;

procedure TFrameEditTreeView.lstAddressClick(Sender: TObject);
var code    : Integer;
    cbb     : TComboBox;
begin
  case ActiveProc of
    SD_REGIN : cbb := fREGIN.ComboBox;
    SD_RAYON : cbb := fRAYON.ComboBox;
    SD_TOWNS : cbb := fTOWNS.ComboBox;
    SD_TPODS : cbb := fTPODS.ComboBox;
    SD_STRET : cbb := fSTRET.ComboBox;
    SD_ABONT : cbb := fABONT.ComboBox;
  end;
  if lstAddress.ItemIndex >= 0 then begin
    cbb.Items:=lstAddress.Items;
    cbb.ItemIndex:=lstAddress.ItemIndex;
    cbb.Text:=lstAddress.Items.Strings[lstAddress.ItemIndex];
    case ActiveProc of
      SD_REGIN : fREGIN.ComboBoxChange(Sender);
      SD_RAYON : fRAYON.ComboBoxChange(Sender);
      SD_TOWNS : fTOWNS.ComboBoxChange(Sender);
      SD_TPODS : fTPODS.ComboBoxChange(Sender);
      SD_STRET : fSTRET.ComboBoxChange(Sender);
      SD_ABONT : fABONT.ComboBoxChange(Sender);
    end;
  end;
end;


function TFrameEditTreeView.CbbCompare(cbb: TComboBox): Boolean;
var s1, s2 : string;
    i      : Integer;
    res    : Boolean;
begin
  s1:=cbb.Text; //+chr(Y);
  Result := False;
  for i := 0 to cbb.Items.Count -1 do Begin
    s2:=cbb.Items[i];
    s2:=Copy(s2,1,Length(s1));
    if AnsiCompareText(s1, s2) = 0 then begin
      lstAddress.ItemIndex:=i;
      Result:=True;
      Exit;
    end;
  end;
end;


procedure TFrameEditTreeView.InlstAddress(cbb: TComboBox);
begin
  lstAddress.Items:=cbb.Items;
  lstAddress.ItemIndex:=cbb.ItemIndex;
end;


procedure TFrameEditTreeView.NotVisableTabs;
begin
  TSHome.Visible := False;     // BO 25/06/19
  TSAddress.Visible := False;
  TSAbon.Visible := False;
  TSVmeter.AdvPages[0].TabVisible := False;
  TSVmeter.AdvPages[1].TabVisible := False;
  TSVmeter.AdvPages[2].TabVisible := False;
end;


end.
