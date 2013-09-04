unit formMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls,

  unitmidpin;


type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PanelButtons: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FButtons : array[0..80] of TSpeedButton;
    FMidpin : TMidpin;

    procedure ConstructPins;
    procedure RenderPins;

    procedure OnPinBtnClick(Sender : TObject);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ConstructPins;

  FMidpin := TMidpin.Create;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RenderPins;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FMidpin.ResetVeld;
  RenderPins;
end;

procedure TForm1.ConstructPins;
  procedure _destroyall;
  var
    button : TSPeedButton;
  begin
    // Destroy all
    for button in FButtons do
      if Assigned(button) then
        begin
          button.Free;
          button := nil;
        end;
  end;
var
  i : Integer;
const
  BUTTONSIZE = 30;
  BUTTONMARGIN = 2;
  BORDERMARGIN = 10;
begin
  for i := Low(FButtons) to High(FButtons) do
  begin
    FButtons[i] := TSpeedButton.Create(PanelButtons);
    FButtons[i].Tag     := i;
    FButtons[i].Left    := (i mod 9) * (BUTTONSIZE + BUTTONMARGIN) + BORDERMARGIN;
    FButtons[i].Top     := (i div 9) * (BUTTONSIZE + BUTTONMARGIN) + BORDERMARGIN;
    FButtons[i].Width   := BUTTONSIZE;
    FButtons[i].Height  := BUTTONSIZE;
    FButtons[i].OnClick := @OnPinBtnClick;
    FButtons[i].Parent  := PanelButtons;
    FButtons[i].Visible := ((i mod 9) in [3..5]) or (((i div 9) in [3..5]))
  end;

  PanelButtons.Width  := 9 * (BUTTONSIZE + BUTTONMARGIN) + (2*BORDERMARGIN);
  PanelButtons.Height := PanelButtons.Width;
end;

procedure TForm1.RenderPins;
var
  i : Integer;
begin
  for i := Low(FButtons) to High(FButtons) do
  begin
    if FMidpin.Pin[i mod 9, i div 9] then
      FButtons[i].Caption := 'X'
    else
      FButtons[i].Caption := '-';
  end;
end;

procedure TForm1.OnPinBtnClick(Sender: TObject);
var
  index : Integer;
begin
  index := (Sender as TSpeedButton).Tag;

  // debug
  Self.Caption := Format('%d = %dx%d', [
    index,
    index mod 9,
    index div 9
  ]);

  // Toggle test
  FMidpin.Pin[index mod 9, index div 9] := not FMidpin.Pin[index mod 9, index div 9];
  RenderPins;
end;

end.

