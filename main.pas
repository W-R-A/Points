unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  ButtonPanel, StdCtrls;

type

  { TTFrmMain }

  TTFrmMain = class(TForm)
    BtnConnection: TButton;
    BtnPerformance: TButton;
    procedure BtnConnectionClick(Sender: TObject);
    procedure BtnPerformanceClick(Sender: TObject);
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
  Depend, performance;

procedure TTFrmMain.BtnConnectionClick(Sender: TObject);
begin
  try
    //Sleep(5);
    //TFrmDepend.ShowModal
  except
    //ShowMessage('Connection error')
  end;

end;

procedure TTFrmMain.BtnPerformanceClick(Sender: TObject);
begin
  TFrmPoints.ShowModal;
end;

procedure TTFrmMain.FormCreate(Sender: TObject);
begin
  TFrmMain.BtnConnection.Click;
end;

end.

