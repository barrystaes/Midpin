unit unitmidpin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TMidpin }

  TPin = [pinYes, pinNo, pinDisabled];

  TMidpin = class(TObject)
  private
    FVeld : array [1..9,1..9] of Boolean;

    function  GetPin(x,y: Integer): Boolean;
    procedure SetPin(x,y: Integer; value: Boolean);
  public
    constructor Create; overload;
    procedure ResetVeld;

    property Pin[x,y: Integer] : Boolean read GetPin write SetPin;
  end;


implementation

{ TMidpin }

function TMidpin.GetPin(x, y: Integer): Boolean;
begin
  Result := FVeld[x,y];
end;

procedure TMidpin.SetPin(x, y: Integer; value: Boolean);
begin
  FVeld[x,y] := value;
end;

constructor TMidpin.Create;
begin
  ResetVeld;
end;

procedure TMidpin.ResetVeld;
var
  i,j : Integer;
begin
  for i := Low(FVeld) to High(FVeld) do
      for j := Low(FVeld[i]) to High(FVeld[i]) do
          FVeld[i][j] := True;

  FVeld[4][4] := False;
end;

end.

