unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TTFrmConfig }

  TTFrmConfig = class(TForm)
    CBDevMode: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TFrmConfig: TTFrmConfig;

implementation

{$R *.lfm}

uses
  util;

{ TTFrmConfig }

procedure TTFrmConfig.FormCreate(Sender: TObject);
begin
  CBDevMode.Checked;
end;

end.

