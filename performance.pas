unit performance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, sqlite3conn, FileUtil, TAGraph, TASeries,
  TADbSource, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DbCtrls,
  ColorBox, Buttons, ComCtrls, Spin, types, math;

type

  { TTFrmPoints }
  //Declare record of points pieces
  //TPointChunks = array [ 0..9] of TShape;

  TTFrmPoints = class(TForm)
    BtnActive: TButton;
    BtnAdjustScale: TButton;
    BtnDrawScreen: TButton;
    BtnUpdateScore: TButton;
    ColBox: TColorBox;
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
    procedure BtnActiveClick(Sender: TObject);
    procedure BtnAdjustScaleClick(Sender: TObject);
    procedure BtnDrawScreenClick(Sender: TObject);
    procedure BtnFwdClick(Sender: TObject);
    procedure BtnUpdateScoreClick(Sender: TObject);
    procedure ColBoxL1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LbL1Click(Sender: TObject);
    procedure LblLodge1Click(Sender: TObject);
    procedure TimerUpdateScaleTimer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    Scale:Integer;
    points : array of Integer;
    Colours : array of string;
  end;

var
  TFrmPoints: TTFrmPoints;
  //New code using arrays to give dynamic screen size adaptation
  //scoreColumns --> array to hold 1-10 segments for displaying numbr of points lodge has - duplicated for number of lodges on the system
  //SpinEdts --> array to hold the spin edit components used to set the score per lodge
  //ScoreCaptions --> array to store the captions used to dislay the number of points in a clear way at the top of the scoe columns
  scoreColumns : array of array [ 0..9] of TShape;
  spinEdts : array of TSpinEdit;
  scoreLabels : array of TLabel;

implementation

{$R *.lfm}

{ TTFrmPoints }
uses
  Depend;

//This is invoked when the form is created
procedure TTFrmPoints.FormCreate(Sender: TObject);
begin
  //Maximise program screen area then start database queries and set up program screen then activate it, also set initial scale
  begin
  //Initiate other form to get data from DB
  TFrmDepend.BtnGetPoints.Click;
  WindowState:=wsMaximized;
  TFrmPoints.Scale:= 10;
  TFrmPoints.BtnDrawScreen.Click;
  end;
end;

procedure TTFrmPoints.LbL1Click(Sender: TObject);
begin

end;

procedure TTFrmPoints.LblLodge1Click(Sender: TObject);
begin

end;

procedure TTFrmPoints.TimerUpdateScaleTimer(Sender: TObject);
var
TP:Integer;
begin
TP := MaxValue(points);
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

//Legacy
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

procedure TTFrmPoints.BtnActiveClick(Sender: TObject);
begin

end;

//This hooks in to the OnResize event of the form
procedure TTFrmPoints.BtnDrawScreenClick(Sender: TObject);
var
  //Setup varibles:
  //screenWidth --> Stores the width, in pixels of the screen
  //screenHeight --> Stores the height, in pixels of the screen
  //noCols --> The number of columns of points to display depentant of the number of lodges to track points for
  //colWidth --> The width, in pixels of the columns
  //btwnCols --> The width, in pixels between columns
  //hMargin --> The horizontal margin around the display
  //vMarginT --> The vertical margin at the top of the display
  //vMarginB --> The vertical margin at the bottom of the display
  screenWidth, screenHeight, noCols, colWidth, btwnCols, hMargin, vMarginT, vMarginB: Integer;
  i, j : Integer;
begin
  begin
    //Setup screen width and height varibles
    noCols := TFrmDepend.RecordNo;
    if noCols < 1 then
      begin
        ShowMessage('The number of columns must be greater than 1');
        noCols := 1;
      end;
    //Setup margins
    screenHeight := TFrmPoints.Height;
    screenWidth := TFrmPoints.Width;
    hMargin := Round(0.05*screenWidth);
    vMarginT := Round(0.05*screenHeight);
    vMarginB := Round(1.5*vMarginT);
    colWidth := Round((screenWidth-2*hMargin)/(noCols*2));
    btwnCols := Round(colWidth+(colWidth/noCols));
    //Set length of scoreColumns and spinEdts array
    SetLength(scoreColumns, (noCols + 1));
    SetLength(spinEdts, (noCols + 1));
    SetLength(scoreLabels, (noCols + 1));
  end;
  //Cleanup previously generated shapes and objects/components
  begin
    for i := noCols downto 0 do
      begin
        //Cleanup spinedit components
        if spinEdts[i] is TSpinEdit then
          spinEdts[i].Free;
        //Cleanup label components
        if scoreLabels[i] is TLabel then
          scoreLabels[i].Free;
        //Cleanup score column segments
        for j := 9 downto 0 do
          if scoreColumns[i,j] is TShape then
          scoreColumns[i,j].Free;
      end;
  end;
  //Generate the correct number of columns based on what is found in the database
  begin
    for i := 0 to noCols do
      begin
        //Set colour for column
        if Colours[i] <> '' then
          ColBox.Selected:=TColor(StringtoColor(Colours[i]));

        //Generate label components to allow points to shown at the top of the columns
        scoreLabels[i] := TLabel.Create(self);
        with scoreLabels[i] do
          begin
            //Properties
            Parent := self;
            Font.Size := Round(vMarginT/3);
            Top := Round(vMarginT/Height);
            Left := Round((hMargin + (i*btwnCols) + (i*colWidth) + (colWidth/2))-(0.5*Width));
            //Caption := InttoStr(TFrmPoints.points[i]);
            Caption := InttoStr(Width);
            Name := 'Lbl_' + InttoStr(i);
          end;

        //Generate segments for coloumns and set properties
        for j := 0 to 9 do
          begin
            scoreColumns[i,j]:= TShape.Create(self);
            with scoreColumns[i,j] do
              begin
                Parent := self;
                Top := Round(vMarginT + j*Round((screenHeight-(vMarginT + vMarginB))/10)-j);
                Height := Round((screenHeight-(vMarginT + vMarginB))/10);
                Left := hMargin + (i*btwnCols) + (i*colWidth);
                Width := colWidth;
                Brush.Color:=ColBox.Selected
              end;
          end;
        //Generate spin edit components to allow points to be added or subtracted from the coloumn score
        spinEdts[i] := TSpinEdit.Create(self);
        with spinEdts[i] do
          begin
            //Properties
            Parent := self;
            Top := Round((vMarginT*1.4) + ((screenHeight-(vMarginT + vMarginB))/10) + j*Round((screenHeight-(vMarginT + vMarginB))/10)-j);
            Height := Round(vMarginT/2);
            Left := Round(hMargin + (i*btwnCols) + (i*colWidth) + colWidth/4);
            Width := Round(colWidth/2);
            Value := TFrmPoints.points[i];
            Name := 'SpinEdit_' + InttoStr(i);
            //Set the event handlers
            OnChange := @BtnUpdateScoreClick;
          end;
      end;
  end;
end;

procedure TTFrmPoints.BtnFwdClick(Sender: TObject);
begin

end;

procedure TTFrmPoints.BtnUpdateScoreClick(Sender: TObject);
var
  i: Integer;
  identiferList : TStrings;
begin
try
   identiferList := TStringList.Create;
   ExtractStrings(['_'], [], PChar((Sender as TSpinEdit).Name), identiferList);
   i := StrtoInt(identiferList[1]);
  finally
    identiferList.Free;
  end;

points[i] := spinEdts[i].Value;
ShowMessage(InttoStr(points[i]));
//DP:=Round(points[i]/(TFrmPoints.Scale/10));


//Begin Legacy code
{TFrmPoints.Points1:= Trunc(SEPL1.Value);
DP:=Round(SEPL1.Value/(TFrmPoints.Scale/10));
BtnAdjustScale.Click;
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
     ShowMessage('An error occured')
   end;}

end;

procedure TTFrmPoints.ColBoxL1Change(Sender: TObject);
begin

end;

procedure TTFrmPoints.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ShowMessage('Saving data...');
  try
    //TFrmDepend.BtnUpdateDB.Click;
  except
    ShowMessage('Error saving')
  end;
end;



end.

