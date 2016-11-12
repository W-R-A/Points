program Points;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Depend, performance, Main;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TTFrmDepend, TFrmDepend);
  Application.CreateForm(TTFrmMain, TFrmMain);
  Application.CreateForm(TTFrmPoints, TFrmPoints);
  Application.Run;
end.

