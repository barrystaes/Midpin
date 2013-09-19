unit formMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls,

  unitmidpin;


type
  THand = record
    SubjectPin{, TargetPin} : TPoint;
  end;

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

    Hand : THand; // The current potential hand/move.

    procedure ConstructPins;
    procedure RenderPins;

    procedure OnPinBtnClick(Sender : TObject);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  // TPoint operators
  GraphMath;

const
  NOPIN : TPoint = (x:-1; y:-1);

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Hand.SubjectPin := NOPIN;

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
  clickedIndex : Integer;
  clickedPoint : TPoint;
begin
  clickedIndex := (Sender as TSpeedButton).Tag;
  clickedPoint := Point(clickedIndex mod 9, clickedIndex div 9);

  if FMidpin.IsValidSubjectPin(clickedPoint) then
  begin
    // Set subject
    Hand.SubjectPin := clickedPoint;
  end
  else
  if (Hand.SubjectPin <> NOPIN) and FMidpin.IsValidTargetPin(clickedPoint) then
  begin
    // Use target

    // Execute move
    FMidpin.MoveJump(Hand.SubjectPin, clickedPoint, False);

    // Reset
    Hand.SubjectPin := NOPIN;
  end;

  RenderPins;
end;

end.

