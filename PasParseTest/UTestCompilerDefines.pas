unit UTestCompilerDefines;

interface

uses
  UTest, UCompilerDefines;

type
  TTestCompilerDefines = class(TTest)
  private
    class function DefineIsTrue(ACompilerDefines: TCompilerDefines;
      ACompilerDirective: string): Boolean;

  public
    class procedure TestAll; override;
    class function GetName: string; override;
  end;

implementation

uses
  SysUtils, ULocation, UPreprocessorException;

{ TTestDictionary }

class function TTestCompilerDefines.DefineIsTrue(
  ACompilerDefines: TCompilerDefines; ACompilerDirective: string): Boolean;
begin
  Result :=
    ACompilerDefines.IsTrue(ACompilerDirective, TLocation.Create('', '', 0));
end;

class function TTestCompilerDefines.GetName: string;
begin
  Result := 'CompilerDefines';
end;

class procedure TTestCompilerDefines.TestAll;
var
  ADefines: TCompilerDefines;
begin
  ADefines := TCompilerDefines.CreateEmpty;

  // Test for False if undefined IfDef
  OK(not DefineIsTrue(ADefines, 'IFDEF FOO'), 'not IFDEF FOO');

  // Test for True if undefined IfNDef
  OK(DefineIsTrue(ADefines, 'IFNDEF FOO'), 'IFNDEF FOO');

  // Test for exception on undefined if
  try
    DefineIsTrue(ADefines, 'IF Foo');
  except
    on EPreprocessorException do
      OK(True, 'IF Foo');
  else
      OK(False, 'IF Foo');
  end;

  // Test DefineDirectiveAsTrue
  ADefines.DefineDirectiveAsTrue('IFDEF FOO');
  OK(DefineIsTrue(ADefines, 'IFDEF FOO'), 'IFDEF FOO');

  // Test DefineDirectiveAsFalse
  ADefines.DefineDirectiveAsFalse('IFDEF FOO');
  OK(not DefineIsTrue(ADefines, 'IFDEF FOO'), 'not IFDEF FOO');

  // Test DefineSymbol
  ADefines.DefineSymbol('FOO');
  OK(DefineIsTrue(ADefines, 'IFDEF FOO'), 'IFDEF FOO');
  OK(not DefineIsTrue(ADefines, 'IFNDEF FOO'), 'not IFNDEF FOO');

  // Test UndefineSymbol
  ADefines.UndefineSymbol('FOO');
  OK(not DefineIsTrue(ADefines, 'IFDEF FOO'), 'not IFDEF FOO');
  OK(DefineIsTrue(ADefines, 'IFNDEF FOO'), 'IFNDEF FOO');

  // Test case-insensitivity
  ADefines.DefineDirectiveAsTrue('IFDEF FOO');
  OK(DefineIsTrue(ADefines, 'IfDef Foo'), 'IfDef Foo');

  FreeAndNil(ADefines);
end;

end.

