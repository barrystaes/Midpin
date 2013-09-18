unit unitmidpin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TMidpin }

  TPin = (pinYes, pinNo, pinDisabled);

  TMidpin = class(TObject)
  private
    FVeld : array [0..80] of TPin;

    function  GetPin(x,y: Integer): TPin;
    procedure SetPin(x,y: Integer; value: TPin);
  public
    constructor Create; overload;
    procedure ResetVeld;

    function MoveJump(pinSubject, pinTarget: TPoint; test: Boolean): Boolean;

    property Pin[x,y: Integer] : TPin read GetPin write SetPin;
  end;


implementation

{ TMidpin }

function TMidpin.GetPin(x, y: Integer): TPin;
begin
  Result := FVeld[x * 9 + y];
end;

procedure TMidpin.SetPin(x, y: Integer; value: TPin);
begin
  FVeld[x * 9 + y] := value;
end;

constructor TMidpin.Create;
begin
  ResetVeld;
end;

procedure TMidpin.ResetVeld;
var
  i : Integer;
begin
  // Standaard speelveld door Silvia
  for i := Low(FVeld) to High(FVeld) do
  begin
    if ((i mod 9) in [3..5]) or (((i div 9) in [3..5])) then
      FVeld[i] := pinYes
    else
      FVeld[i] := pinDisabled;
  end;
  FVeld[4 * 9 + 4] := pinNo;
end;

function TMidpin.MoveJump(pinSubject, pinTarget: TPoint; test: Boolean): Boolean;
var
  pinBetween : TPoint;
begin
  { Conditions are:
    - pinSubject = pinYes
    - pinTarget = pinNo
    - Subject and target exactly 2 pins apart on either Y or X axis?
    - pinBetween = pinYes
  }

  Result := (
    // Subject exists, and target is empty?
    (Pin[pinSubject.x, pinSubject.y] = pinYes) and
    (Pin[pinTarget.x, pinTarget.y] = pinNo) and
    // Target coördinate delta is 2 on exactly one axis?
    (
      (abs(pinSubject.x - pinTarget.x) = 2) xor
      (abs(pinSubject.y - pinTarget.y) = 2)
    )
  );

  if Result then
  begin
    // Determine pinBetween coördinate
    pinBetween.x := pinSubject.x - ((pinSubject.x - pinTarget.x) div 2);
    pinBetween.y := pinSubject.y - ((pinSubject.y - pinTarget.y) div 2);

    // Victim exists?
    Result := (Pin[pinBetween.x, pinBetween.y] = pinYes);
  end;

  // Mutate pins
  if Result and not test then
  begin
    Pin[pinSubject.x, pinSubject.y] := pinNo;
    Pin[pinBetween.x, pinBetween.y] := pinNo;
    Pin[pinTarget.x , pinTarget.y ] := pinYes;
  end;
end;

end.

