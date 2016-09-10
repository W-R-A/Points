unit performance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, sqlite3conn, FileUtil, TAGraph, TASeries,
  TADbSource, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DbCtrls,
  ColorBox, Buttons, ComCtrls, Spin, types;

type

  { TTFrmPoints }
  //Declare record of points pieces
  //TPointChunks = array [ 0..9] of TShape;

  TTFrmPoints = class(TForm)
    BtnActive: TButton;
    BtnAdjustScale: TButton;
    BtnSetColour: TButton;
    BtnDrawScreen: TButton;
    ColBoxL1: TColorBox;
    ColBoxL2: TColorBox;
    ColBoxL3: TColorBox;
    ColBoxL4: TColorBox;
    DataSourceColour: TDataSource;
    L3P1: TShape;
    L3P2: TShape;
    L3P3: TShape;
    L3P4: TShape;
    L3P5: TShape;
    L3P6: TShape;
    L3P7: TShape;
    L3P8: TShape;
    L3P9: TShape;
    L3P10: TShape;
    L4P1: TShape;
    L4P2: TShape;
    L4P3: TShape;
    L4P4: TShape;
    L4P5: TShape;
    L4P6: TShape;
    L4P7: TShape;
    L4P8: TShape;
    L4P9: TShape;
    L4P10: TShape;
    LbL1: TLabel;
    LbL2: TLabel;
    LbL3: TLabel;
    LbL4: TLabel;
    LblLodge1: TLabel;
    LblLodge2: TLabel;
    LblLodge3: TLabel;
    LblLodge4: TLabel;
    LblPoints1: TLabel;
    LblPoints10: TLabel;
    LblPoints7: TLabel;
    LblPoints2: TLabel;
    LblPoints3: TLabel;
    LblPoints4: TLabel;
    LblPoints5: TLabel;
    LblPoints6: TLabel;
    LblPoints0: TLabel;
    LblPoints8: TLabel;
    LblPoints9: TLabel;
    L1P1: TShape;
    L1P10: TShape;
    L2P1: TShape;
    L2P2: TShape;
    L2P3: TShape;
    L2P4: TShape;
    L2P5: TShape;
    L2P6: TShape;
    L2P7: TShape;
    L2P8: TShape;
    L2P9: TShape;
    L1P2: TShape;
    L2P10: TShape;
    L1P3: TShape;
    L1P4: TShape;
    L1P5: TShape;
    L1P6: TShape;
    L1P7: TShape;
    L1P8: TShape;
    L1P9: TShape;
    SEPL1: TSpinEdit;
    SEPL2: TSpinEdit;
    SEPL3: TSpinEdit;
    SEPL4: TSpinEdit;
    SQLConnector: TSQLConnector;
    SQLGetInfo: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    TimerRefreshPoints1: TTimer;
    TimerRefreshPoints2: TTimer;
    TimerRefreshPoints3: TTimer;
    TimerRefreshPoints4: TTimer;
    TimerUpdateScale: TTimer;
    procedure BtnActiveClick(Sender: TObject);
    procedure BtnAdjustScaleClick(Sender: TObject);
    procedure BtnSetColourClick(Sender: TObject);
    procedure BtnDrawScreenClick(Sender: TObject);
    procedure ColBoxL1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LbL1Click(Sender: TObject);
    procedure LblLodge1Click(Sender: TObject);
    procedure SEPL1Change(Sender: TObject);
    procedure SEPL2Change(Sender: TObject);
    procedure SEPL3Change(Sender: TObject);
    procedure SEPL4Change(Sender: TObject);
    procedure TimerUpdateScaleTimer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    Points1, Points2, Points3, Points4, Scale:Integer;
  end;

var
  TFrmPoints: TTFrmPoints;
  //New code using arrays to give dynamic screen size adaptation
  //pointsChunks --> array to hold 1-10 segments for displaying numbr of points lodge has - duplicated for number of lodges on the system
  //pointChunks : array [ 0..9] of TShape;
  scoreColumns : array of array [ 0..9] of TShape;

implementation

{$R *.lfm}

{ TTFrmPoints }
uses
  Depend;

procedure TTFrmPoints.FormCreate(Sender: TObject);
var
  screenWidth, screenHeight, noCols, colWidth, btwnCols, margin: Integer;
  i : Integer;
begin
  //Maximise program screen area then start database queries and set up program screen then activate it, also set initial scale
  begin
  WindowState:=wsMaximized;
  SQLGetInfo.SQL.Clear;
  SQLGetInfo.SQL.Text:='SELECT * FROM LodgePoints';
  BtnActive.Click;
  TFrmPoints.Scale:=10;
  TFrmPoints.BtnDrawScreen.Click;
  end;
end;

procedure TTFrmPoints.LbL1Click(Sender: TObject);
begin

end;

procedure TTFrmPoints.LblLodge1Click(Sender: TObject);
begin

end;

procedure TTFrmPoints.SEPL1Change(Sender: TObject);
var
  DP:Integer;
begin
TFrmPoints.Points1:= Trunc(SEPL1.Value);
DP:=Round(SEPL1.Value/(TFrmPoints.Scale/10));
BtnAdjustScale.Click;
BtnSetColour.Click;
TFrmPoints.LbL1.Caption:=InttoStr(SEPL1.Value);
  try
      case DP of
      0: begin
           L1P1.Visible:=False;
           L1P2.Visible:=False;
           L1P3.Visible:=False;
           L1P4.Visible:=False;
           L1P5.Visible:=False;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      1: begin
           L1P1.Visible:=True;
           L1P2.Visible:=False;
           L1P3.Visible:=False;
           L1P4.Visible:=False;
           L1P5.Visible:=False;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      2: begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=False;
           L1P4.Visible:=False;
           L1P5.Visible:=False;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      3:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=False;
           L1P5.Visible:=False;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      4:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=False;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      5:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=False;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      6:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=True;
           L1P7.Visible:=False;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      7:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=True;
           L1P7.Visible:=True;
           L1P8.Visible:=False;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      8:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=True;
           L1P7.Visible:=True;
           L1P8.Visible:=True;
           L1P9.Visible:=False;
           L1P10.Visible:=False;
         end;
      9:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=True;
           L1P7.Visible:=True;
           L1P8.Visible:=True;
           L1P9.Visible:=True;
           L1P10.Visible:=False;
         end;
      10:begin
           L1P1.Visible:=True;
           L1P2.Visible:=True;
           L1P3.Visible:=True;
           L1P4.Visible:=True;
           L1P5.Visible:=True;
           L1P6.Visible:=True;
           L1P7.Visible:=True;
           L1P8.Visible:=True;
           L1P9.Visible:=True;
           L1P10.Visible:=True;
         end;
    end;
   except
     ShowMessage('Please enter a number between 0 and 50')
   end;
end;

procedure TTFrmPoints.SEPL2Change(Sender: TObject);
var
  DP:Integer;
begin
TFrmPoints.Points2:= Trunc(SEPL2.Value);
DP:=Round(SEPL2.Value/(TFrmPoints.Scale/10));
BtnAdjustScale.Click;
BtnSetColour.Click;
TFrmPoints.LbL2.Caption:=InttoStr(SEPL2.Value);
  try
      case DP of
      0: begin
           L2P1.Visible:=False;
           L2P2.Visible:=False;
           L2P3.Visible:=False;
           L2P4.Visible:=False;
           L2P5.Visible:=False;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      1: begin
           L2P1.Visible:=True;
           L2P2.Visible:=False;
           L2P3.Visible:=False;
           L2P4.Visible:=False;
           L2P5.Visible:=False;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      2: begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=False;
           L2P4.Visible:=False;
           L2P5.Visible:=False;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      3:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=False;
           L2P5.Visible:=False;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      4:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=False;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      5:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=False;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      6:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=True;
           L2P7.Visible:=False;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      7:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=True;
           L2P7.Visible:=True;
           L2P8.Visible:=False;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      8:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=True;
           L2P7.Visible:=True;
           L2P8.Visible:=True;
           L2P9.Visible:=False;
           L2P10.Visible:=False;
         end;
      9:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=True;
           L2P7.Visible:=True;
           L2P8.Visible:=True;
           L2P9.Visible:=True;
           L2P10.Visible:=False;
         end;
      10:begin
           L2P1.Visible:=True;
           L2P2.Visible:=True;
           L2P3.Visible:=True;
           L2P4.Visible:=True;
           L2P5.Visible:=True;
           L2P6.Visible:=True;
           L2P7.Visible:=True;
           L2P8.Visible:=True;
           L2P9.Visible:=True;
           L2P10.Visible:=True;
         end;
    end;
   except
     ShowMessage('Please enter a number between 0 and 50')
   end;
end;

procedure TTFrmPoints.SEPL3Change(Sender: TObject);
var
  DP:Integer;
begin
TFrmPoints.Points3:= Trunc(SEPL3.Value);
DP:=Round(SEPL3.Value/(TFrmPoints.Scale/10));
BtnAdjustScale.Click;
BtnSetColour.Click;
TFrmPoints.LbL3.Caption:=InttoStr(SEPL3.Value);
  try
      case DP of
      0: begin
           L3P1.Visible:=False;
           L3P2.Visible:=False;
           L3P3.Visible:=False;
           L3P4.Visible:=False;
           L3P5.Visible:=False;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      1: begin
           L3P1.Visible:=True;
           L3P2.Visible:=False;
           L3P3.Visible:=False;
           L3P4.Visible:=False;
           L3P5.Visible:=False;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      2: begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=False;
           L3P4.Visible:=False;
           L3P5.Visible:=False;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      3:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=False;
           L3P5.Visible:=False;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      4:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=False;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      5:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=False;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      6:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=True;
           L3P7.Visible:=False;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      7:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=True;
           L3P7.Visible:=True;
           L3P8.Visible:=False;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      8:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=True;
           L3P7.Visible:=True;
           L3P8.Visible:=True;
           L3P9.Visible:=False;
           L3P10.Visible:=False;
         end;
      9:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=True;
           L3P7.Visible:=True;
           L3P8.Visible:=True;
           L3P9.Visible:=True;
           L3P10.Visible:=False;
         end;
      10:begin
           L3P1.Visible:=True;
           L3P2.Visible:=True;
           L3P3.Visible:=True;
           L3P4.Visible:=True;
           L3P5.Visible:=True;
           L3P6.Visible:=True;
           L3P7.Visible:=True;
           L3P8.Visible:=True;
           L3P9.Visible:=True;
           L3P10.Visible:=True;
         end;
    end;
   except
     ShowMessage('Please enter a number between 0 and 50')
   end;
end;

procedure TTFrmPoints.SEPL4Change(Sender: TObject);
var
  DP:Integer;
begin
TFrmPoints.Points4:= Trunc(SEPL4.Value);
DP:=Round(SEPL4.Value/(TFrmPoints.Scale/10));
BtnAdjustScale.Click;
BtnSetColour.Click;
TFrmPoints.LbL4.Caption:=InttoStr(SEPL4.Value);
  try
      case DP of
      0: begin
           L4P1.Visible:=False;
           L4P2.Visible:=False;
           L4P3.Visible:=False;
           L4P4.Visible:=False;
           L4P5.Visible:=False;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      1: begin
           L4P1.Visible:=True;
           L4P2.Visible:=False;
           L4P3.Visible:=False;
           L4P4.Visible:=False;
           L4P5.Visible:=False;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      2: begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=False;
           L4P4.Visible:=False;
           L4P5.Visible:=False;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      3:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=False;
           L4P5.Visible:=False;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      4:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=False;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      5:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=False;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      6:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=True;
           L4P7.Visible:=False;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      7:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=True;
           L4P7.Visible:=True;
           L4P8.Visible:=False;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      8:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=True;
           L4P7.Visible:=True;
           L4P8.Visible:=True;
           L4P9.Visible:=False;
           L4P10.Visible:=False;
         end;
      9:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=True;
           L4P7.Visible:=True;
           L4P8.Visible:=True;
           L4P9.Visible:=True;
           L4P10.Visible:=False;
         end;
      10:begin
           L4P1.Visible:=True;
           L4P2.Visible:=True;
           L4P3.Visible:=True;
           L4P4.Visible:=True;
           L4P5.Visible:=True;
           L4P6.Visible:=True;
           L4P7.Visible:=True;
           L4P8.Visible:=True;
           L4P9.Visible:=True;
           L4P10.Visible:=True;
         end;
    end;
   except
     ShowMessage('Please enter a number between 0 and 10000')
   end;

end;

procedure TTFrmPoints.TimerUpdateScaleTimer(Sender: TObject);
var
TP:Integer;
begin
TP:=0;
if (TFrmPoints.Points1>=TFrmPoints.Points2)and(TFrmPoints.Points1>=TFrmPoints.Points3)and(TFrmPoints.Points1>=TFrmPoints.Points4) then
  TP:=Points1
  else
    if (TFrmPoints.Points2>=TFrmPoints.Points1)and(TFrmPoints.Points2>=TFrmPoints.Points3)and(TFrmPoints.Points2>=TFrmPoints.Points4) then
      TP:=Points2
      else
        if (TFrmPoints.Points3>=TFrmPoints.Points1)and(TFrmPoints.Points3>=TFrmPoints.Points2)and(TFrmPoints.Points3>=TFrmPoints.Points4) then
          TP:=Points3
          else
            if (TFrmPoints.Points4>=TFrmPoints.Points1)and(TFrmPoints.Points4>=TFrmPoints.Points2)and(TFrmPoints.Points4>=TFrmPoints.Points3) then
              TP:=Points4;
  case TP of
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:       begin
                                            TFrmPoints.Scale:=10
                                          end;
  11, 12, 13, 14, 15, 16, 17, 18, 19, 20: begin
                                            TFrmPoints.Scale:=20;
                                          end;
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30: begin
                                            TFrmPoints.Scale:=30;
                                          end;
  31, 32, 33, 34, 35, 36, 37, 38, 39, 40: begin
                                            TFrmPoints.Scale:=40;
                                          end;
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50: begin
                                            TFrmPoints.Scale:=50;
                                          end;
  51, 52, 53, 54, 55, 56, 57, 58, 59, 60: begin
                                            TFrmPoints.Scale:=60;
                                          end;
  61, 62, 63, 64, 65, 66, 67, 68, 69, 70: begin
                                            TFrmPoints.Scale:=70;
                                          end;
  71, 72, 73, 74, 75, 76, 77, 78, 79, 80: begin
                                            TFrmPoints.Scale:=80;
                                          end;
  81, 82, 83, 84, 85, 86, 87, 88, 89, 90: begin
                                            TFrmPoints.Scale:=90;
                                          end;
  91, 92, 93, 94, 95, 96, 97, 98, 99, 100: begin
                                            TFrmPoints.Scale:=100;
                                          end;
  end;

  BtnAdjustScale.Click;
end;

procedure TTFrmPoints.BtnActiveClick(Sender: TObject);
var
  Records, count:Integer;
begin
SQLGetInfo.Active:=True;
Records := SQLGetInfo.RecordCount;
for count:= 1 to Records do
  begin
    SQLGetInfo.SQL.Clear;
    SQLGetInfo.Active:=False;
    SQLGetInfo.SQL.Text:='SELECT * FROM LodgePoints WHERE ID='+IntToStr(count);
    SQLGetInfo.Active:=True;
    if count = 1 then
      begin
      LblLodge1.Caption:=SQLGetInfo.Fields[1].AsString;
      SEPL1.Value:=SQLGetInfo.Fields[2].AsInteger;
      end
      else
        if count = 2 then
          begin
          LblLodge2.Caption:=SQLGetInfo.Fields[1].AsString;
          SEPL2.Value:=SQLGetInfo.Fields[2].AsInteger;
          end
          else
            if count = 3 then
              begin
              LblLodge3.Caption:=SQLGetInfo.Fields[1].AsString;
              SEPL3.Value:=SQLGetInfo.Fields[2].AsInteger;
              end
              else
                  if count = 4 then
                    begin
                    LblLodge4.Caption:=SQLGetInfo.Fields[1].AsString;
                    SEPL4.Value:=SQLGetInfo.Fields[2].AsInteger;
                    end
    //ShowMessage(IntToStr(count));
    //ShowMessage(SQLGetInfo.Fields[1].AsString)
  end;
//ShowMessage(inttostr(records));
SQLConnector.CloseDataSets;
SQLConnector.CloseTransactions;
SQLTransaction.CloseDataSets;
SQLTransaction.CleanupInstance;
SQLGetInfo.Active:=False;
SQLGetInfo.Close;
end;

procedure TTFrmPoints.BtnAdjustScaleClick(Sender: TObject);
begin
  try
     LblPoints1.Caption:=IntToStr(Round(TFrmPoints.Scale/10));
     LblPoints2.Caption:=InttoStr(Round((2*TFrmPoints.Scale)/10));
     LblPoints3.Caption:=InttoStr(Round((3*TFrmPoints.Scale)/10));
     LblPoints4.Caption:=InttoStr(Round((4*TFrmPoints.Scale)/10));
     LblPoints5.Caption:=InttoStr(Round((5*TFrmPoints.Scale)/10));
     LblPoints6.Caption:=InttoStr(Round((6*TFrmPoints.Scale)/10));
     LblPoints7.Caption:=InttoStr(Round((7*TFrmPoints.Scale)/10));
     LblPoints8.Caption:=InttoStr(Round((8*TFrmPoints.Scale)/10));
     LblPoints9.Caption:=InttoStr(Round((9*TFrmPoints.Scale)/10));
     LblPoints10.Caption:=InttoStr(Round((10*TFrmPoints.Scale)/10));
  except
    ShowMessage('Scale not recognised')
  end;
end;

procedure TTFrmPoints.BtnSetColourClick(Sender: TObject);
begin
  try
    case TFrmPoints.LblLodge1.Caption of
    'Green': ColBoxL1.Selected:=TColor($008000);
    'Red': ColBoxL1.Selected:=TColor($0000FF);
    'Yellow': ColBoxL1.Selected:=TColor($00FFFF);
    'Blue': ColBoxL1.Selected:=TColor($FF0000);
    'Purple': ColBoxL1.Selected:=TColor($800080);
    end;
  except
  end;

  try
    case TFrmPoints.LblLodge2.Caption of
    'Green': ColBoxL2.Selected:=TColor($008000);
    'Red': ColBoxL2.Selected:=TColor($0000FF);
    'Yellow': ColBoxL2.Selected:=TColor($00FFFF);
    'Blue': ColBoxL2.Selected:=TColor($FF0000);
    'Purple': ColBoxL2.Selected:=TColor($800080);
    end;
  except
  end;

  try
    case TFrmPoints.LblLodge3.Caption of
    'Green': ColBoxL3.Selected:=TColor($008000);
    'Red': ColBoxL3.Selected:=TColor($0000FF);
    'Yellow': ColBoxL3.Selected:=TColor($00FFFF);
    'Blue': ColBoxL3.Selected:=TColor($FF0000);
    'Purple': ColBoxL3.Selected:=TColor($800080);
    end;
  except
  end;

  try
    case TFrmPoints.LblLodge4.Caption of
    'Green': ColBoxL4.Selected:=TColor($008000);
    'Red': ColBoxL4.Selected:=TColor($0000FF);
    'Yellow': ColBoxL4.Selected:=TColor($00FFFF);
    'Blue': ColBoxL4.Selected:=TColor($FF0000);
    'Purple': ColBoxL4.Selected:=TColor($800080);
    end;
  except
  end;

  L1P1.Brush.Color:=ColBoxL1.Selected;
  L1P2.Brush.Color:=ColBoxL1.Selected;
  L1P3.Brush.Color:=ColBoxL1.Selected;
  L1P4.Brush.Color:=ColBoxL1.Selected;
  L1P5.Brush.Color:=ColBoxL1.Selected;
  L1P6.Brush.Color:=ColBoxL1.Selected;
  L1P7.Brush.Color:=ColBoxL1.Selected;
  L1P8.Brush.Color:=ColBoxL1.Selected;
  L1P9.Brush.Color:=ColBoxL1.Selected;
  L1P10.Brush.Color:=ColBoxL1.Selected;

  L2P1.Brush.Color:=ColBoxL2.Selected;
  L2P2.Brush.Color:=ColBoxL2.Selected;
  L2P3.Brush.Color:=ColBoxL2.Selected;
  L2P4.Brush.Color:=ColBoxL2.Selected;
  L2P5.Brush.Color:=ColBoxL2.Selected;
  L2P6.Brush.Color:=ColBoxL2.Selected;
  L2P7.Brush.Color:=ColBoxL2.Selected;
  L2P8.Brush.Color:=ColBoxL2.Selected;
  L2P9.Brush.Color:=ColBoxL2.Selected;
  L2P10.Brush.Color:=ColBoxL2.Selected;

  L3P1.Brush.Color:=ColBoxL3.Selected;
  L3P2.Brush.Color:=ColBoxL3.Selected;
  L3P3.Brush.Color:=ColBoxL3.Selected;
  L3P4.Brush.Color:=ColBoxL3.Selected;
  L3P5.Brush.Color:=ColBoxL3.Selected;
  L3P6.Brush.Color:=ColBoxL3.Selected;
  L3P7.Brush.Color:=ColBoxL3.Selected;
  L3P8.Brush.Color:=ColBoxL3.Selected;
  L3P9.Brush.Color:=ColBoxL3.Selected;
  L3P10.Brush.Color:=ColBoxL3.Selected;

  L4P1.Brush.Color:=ColBoxL4.Selected;
  L4P2.Brush.Color:=ColBoxL4.Selected;
  L4P3.Brush.Color:=ColBoxL4.Selected;
  L4P4.Brush.Color:=ColBoxL4.Selected;
  L4P5.Brush.Color:=ColBoxL4.Selected;
  L4P6.Brush.Color:=ColBoxL4.Selected;
  L4P7.Brush.Color:=ColBoxL4.Selected;
  L4P8.Brush.Color:=ColBoxL4.Selected;
  L4P9.Brush.Color:=ColBoxL4.Selected;
  L4P10.Brush.Color:=ColBoxL4.Selected;
end;

//This hooks in to the OnResize event of the form
procedure TTFrmPoints.BtnDrawScreenClick(Sender: TObject);
var
  screenWidth, screenHeight, noCols, colWidth, btwnCols, margin: Integer;
  i, j : Integer;
  shapes : array [0..9] of TShape;
begin
  begin
    //Setup screen width and height varibles
    noCols := 4;
    if noCols < 1 then
      ShowMessage('The number of columns must be greater than 1');
    margin := 64;
    screenHeight := TFrmPoints.Height;
    screenWidth := TFrmPoints.Width;
    colWidth := Round(screenWidth/(noCols*2));
    btwnCols := Round(colWidth+(colWidth/noCols));
    //Set length of scoreColumns array
    SetLength(scoreColumns, (noCols + 1))
    //ShowMessage(InttoStr(Round((screenHeight-2*margin)/10)));
  end;
  //Cleanup previously generated shapes
  begin
    for i := noCols downto 0 do
    begin
      for j := 9 downto 0 do
        if scoreColumns[i,j] is TShape then
        scoreColumns[i,j].Free;
    end;
  end;
  //Generate new shapes and set required properties
  begin
    for i := 0 to noCols do
      begin
        for j := 0 to 9 do
          begin
            scoreColumns[i,j]:= TShape.Create(self);
            with scoreColumns[i,j] do
              begin
                Parent := self;
                Top := Round(margin + j*Round((screenHeight-2*margin)/10)-j);
                Height := Round((screenHeight-2*margin)/10);
                Left := margin + btwnCols;
                Width := colWidth;
              end;
          end
      end;
  end;
end;
procedure TTFrmPoints.ColBoxL1Change(Sender: TObject);
begin

end;

procedure TTFrmPoints.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ShowMessage('Saving data...');
  try
    TFrmDepend.BtnUpdateDB.Click;
  except
    ShowMessage('Error saving')
  end;
end;



end.

