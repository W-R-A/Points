unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls;

type

  { TTFrmMain }

  TTFrmMain = class(TForm)
    BtnShowConfig: TButton;
    BtnCurrentPoints: TButton;
    procedure BtnShowConfigClick(Sender: TObject);
    procedure BtnCurrentPointsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TFrmMain: TTFrmMain;

implementation

{$R *.lfm}

{ TTFrmMain }
uses
  config, performance;

procedure TTFrmMain.BtnShowConfigClick(Sender: TObject);
begin
    TFrmConfig.ShowModal;
end;


procedure TTFrmMain.BtnCurrentPointsClick(Sender: TObject);
begin
  TFrmPoints.ShowModal;
end;

procedure TTFrmMain.FormCreate(Sender: TObject);
begin

end;

end.

