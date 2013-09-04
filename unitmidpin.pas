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

end.

