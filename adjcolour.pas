unit AdjColour;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TTFrmAdjColour }

  TTFrmAdjColour = class(TForm)
    BtnSelCol: TButton;
    CDSelectColour: TColorDialog;
    ShpSampleColour: TShape;
    procedure BtnSelColClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TFrmAdjColour: TTFrmAdjColour;

implementation

{$R *.lfm}

{ TTFrmAdjColour }

procedure TTFrmAdjColour.BtnSelColClick(Sender: TObject);
begin
  CDSelectColour.Execute;

  ShpSampleColour.Brush.Color:=CDSelectColour.Color;

  //MessageDlg('Confirm', 'Do you wish to procced with this colour?', mtConfirmation, [mbYes, mbNo], 0)
end;

end.



