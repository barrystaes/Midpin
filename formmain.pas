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

    handSubject, handTarget: TPoint; // the current move

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
  handSubject := Point(-1,-1);
  handTarget  := Point(-1,-1);

  ConstructPins;
  FMidpin := TMidpin.Create;
  RenderPins;
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
    FButtons[i].Visible := True;
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
    case FMidpin.Pin[i mod 9, i div 9] of
    pinYes:
      begin
        FButtons[i].Visible := True;
        FButtons[i].Caption := 'X';
      end;
    pinNo:
      begin
        FButtons[i].Visible := True;
        FButtons[i].Caption := '-';
      end;
    pinDisabled:
      begin
        FButtons[i].Visible := False;
        FButtons[i].Caption := '?';
      end;
    end;
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

  // test move rules
  handTarget := handSubject; // shift
  handSubject := Point(index mod 9, index div 9);
  if (handTarget.x<>-1) and FMidpin.MoveJump(handSubject,handTarget,True) then
    Self.Caption := Self.Caption + ' allowed';

  // Toggle test
  //case FMidpin.Pin[index mod 9, index div 9] of
  //  pinYes: FMidpin.Pin[index mod 9, index div 9] := pinNo;
  //  pinNo:  FMidpin.Pin[index mod 9, index div 9] := pinYes;
  //end;

  // Execute move
  FMidpin.MoveJump(handSubject,handTarget,False);

  RenderPins;
end;

end.

