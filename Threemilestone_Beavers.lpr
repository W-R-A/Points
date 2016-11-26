program Threemilestone_Beavers;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, dbflaz, tachartlazaruspkg, Main, performance, Util
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Points';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TTFrmMain, TFrmMain);
  Application.CreateForm(TTFrmUtil, TFrmUtil);
  Application.CreateForm(TTFrmPoints, TFrmPoints);
  Application.Run;
end.

