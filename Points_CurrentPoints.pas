unit performance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, FileUtil, TAGraph, TASeries,
  TADbSource, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DbCtrls,
  ColorBox, Buttons, Spin, math, crt;

type

  { TTFrmPoints }
  TTFrmPoints = class(TForm)
    BtnAdjustScale: TButton;
    BtnDrawScreen: TButton;
    BtnUpdateScore: TButton;
    BtnDisplayScore: TButton;
	  BtnTestDisplay: TButton;
	  BtnTest: TButton;
    ColBox: TColorBox;
	  TestTimer: TTimer;
    procedure BtnAdjustScaleClick(Sender: TObject);
    procedure BtnDisplayScoreClick(Sender: TObject);
    procedure BtnDrawScreenClick(Sender: TObject);
	  procedure BtnTestClick(Sender: TObject);
	  procedure BtnTestDisplayClick(Sender: TObject);
    procedure BtnUpdateScoreClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
    //noCols --> The number of columns of points to display dependant of the number of lodges to track points for
    testi, testj, testcolval : Integer;
    devMode : Boolean;
  public
    { public declarations }
    Scale, noCols :Integer;
    points : array of Integer;
    Colours : array of string;
  end;

var
  TFrmPoints: TTFrmPoints;
  //New code using arrays to give dynamic screen size adaptation
  //scoreColumns --> array to hold 1-10 segments for displaying numbr of points lodge has - duplicated for number of lodges on the system
  //spinEdts --> array to hold the spin edit components used to set the score per lodge
  //scoreCaptions --> array to store the captions used to dislay the number of points in a clear way at the top of the score columns
  //scoreScale --> array to store the captions used to the blocks to points coversion on the left hand side of the screen
  scoreColumns : array of array [0..9] of TShape;
  spinEdts : array of TSpinEdit;
  scoreLabels : array of TLabel;
  scoreScale : array of array [0..9] of TLabel;

implementation

{$R *.lfm}

{ TTFrmPoints }
uses
  Depend;

//This is invoked when the program starts and this form is created
procedure TTFrmPoints.FormCreate(Sender: TObject);
begin
  //Maximise program screen area then start database queries and set up program screen then activate it, also set initial scale
  begin
  //Initiate other form to get data from DB
  TFrmDepend.BtnGetPoints.Click;
  //Set the window state to maximise the program window
  WindowState:=wsMaximized;
  //Set the inital scale of the display
  TFrmPoints.Scale:= 10;
  //Invoke procedure to generate the components and set everything up
  TFrmPoints.BtnDrawScreen.Click;
  //Set the number of columns global variable
  noCols := TFrmDepend.RecordNo;
  //Set the devMode variable to true for testing, eventually this will be an option on the config screen
  devMode := True;
  //Set controls based on if development mode is on or not
  TFrmPoints.BtnTest.Visible:=devMode;
  end;
end;

procedure TTFrmPoints.BtnAdjustScaleClick(Sender: TObject);
var
TP, j:Integer;
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
  //Update captions
  for j := 0 to 9 do
  begin
       scoreScale[0, j].Caption := InttoStr(Round(((10-j)*TFrmPoints.Scale)/10));
  end;
end;

//This hooks in to the OnResize event of the form
procedure TTFrmPoints.BtnDrawScreenClick(Sender: TObject);
var
  //Setup varibles:
  //screenWidth --> Stores the width, in pixels of the screen
  //screenHeight --> Stores the height, in pixels of the screen
  //colWidth --> The width, in pixels of the columns
  //btwnCols --> The width, in pixels between columns
  //hMargin --> The horizontal margin around the display
  //vMarginT --> The vertical margin at the top of the display
  //vMarginB --> The vertical margin at the bottom of the display
  screenWidth, screenHeight, colWidth, btwnCols, hMargin, vMarginT, vMarginB: Integer;
  i, j : Integer;
begin
  begin
    //Workaround as the OnResize event fires before the onCreate event of the form
    noCols := TFrmDepend.RecordNo;
    //Setup screen width and height varibles
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
    SetLength(scoreScale, (noCols + 1));
  end;
  //Cleanup previously generated shapes and objects/components
  begin
    for i := noCols downto 0 do
      begin
        //Cleanup spinedit components
        if spinEdts[i] is TSpinEdit then
          spinEdts[i].Free;
        //Cleanup label components along the top of the display
        if scoreLabels[i] is TLabel then
          scoreLabels[i].Free;
        //Cleanup score column segments and label components
        for j := 9 downto 0 do
          begin
               //Cleanup score column segments
               if scoreColumns[i,j] is TShape then
                  scoreColumns[i,j].Free;
               //Cleanup label components for the scale on the left hand side
               if scoreScale[i,j] is TLabel then
                  scoreScale[i,j].Free;
          end;
      end;
  end;
  //Generate the correct number of columns based on what is found in the database
  begin
    for i := 0 to noCols do
      begin
        //Set colour for column
        if Colours[i] <> '' then
          ColBox.Selected:=TColor(StringtoColor(Colours[i]));

        //Generate label components to allow points to shown at the top of the columns, only if space is available
        if Round(vMarginT/3) > 6 then
          begin
               scoreLabels[i] := TLabel.Create(self);
               with scoreLabels[i] do
               begin
                    //Properties
                    Parent := self;
                    Font.Size := Round(vMarginT/3);
                    Caption := '00';
                    Top := Round(vMarginT/Height);
                    Left := Round((hMargin + (i*btwnCols) + (i*colWidth) + (colWidth/2))-(TFrmPoints.Canvas.TextWidth(Caption))/1.5);
                    Name := 'Lbl_' + InttoStr(i);
                    Caption := InttoStr(TFrmPoints.points[i]);
               end;
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
          //If the first column is being generated, generate the scale as well
          if (i = 0) then
             begin
               scoreScale[i, j] := TLabel.Create(self);
               with scoreScale[i, j] do
                    begin
                         //Properties
                         Parent := self;
                         Font.Size := Round(hMargin/4);
                         Caption := '00';
                         Top := Round(vMarginT + j*Round((screenHeight-(vMarginT + vMarginB))/10)-j);
                         Left := Round(((hMargin/2)-(TFrmPoints.Canvas.TextWidth(Caption)))*0.75);
                         Name := 'LblScale_' + InttoStr(j);
                    end;
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
  //Update the scale
  TFrmPoints.BtnAdjustScale.Click;
  //Display the points on the screen
  TFrmPoints.BtnDisplayScore.Click;
end; //End procedure

procedure TTFrmPoints.BtnUpdateScoreClick(Sender: TObject);
var
  i: Integer;
  identiferList : TStrings;
begin
//Find out which spin edit component changed and update the relevent colour accordingly
try
   identiferList := TStringList.Create;
   ExtractStrings(['_'], [], PChar((Sender as TSpinEdit).Name), identiferList);
   i := StrtoInt(identiferList[1]);
  finally
    identiferList.Free;
  end; //End try

//Update array with new value
points[i] := spinEdts[i].Value;

//Update screen
TFrmPoints.BtnDisplayScore.Click;
end; //End procedure

procedure TTFrmPoints.BtnDisplayScoreClick(Sender: TObject);
var i, j, displayPoints : Integer;

begin
//Update the scale
TFrmPoints.BtnAdjustScale.Click;

//Update the score points columns
for i := 0 to TFrmDepend.RecordNo do
   begin
       //Set / update the label captions
       if scoreLabels[i] is TLabel then
           scoreLabels[i].Caption := InttoStr(points[i]);

     //Display number of segments for each colour by setting each block to either visisble or invisible
     //Work out how many segments should be visible
     displayPoints:=9-Trunc(points[i]/(TFrmPoints.Scale/10));

     //Check to ensure the displayPoints is within allowed limits
     if (displayPoints <= 9) and (displayPoints >= 0) then
     //Set the required number of segemnts invisible
     begin
         for j := 0 to displayPoints do
             begin
                 scoreColumns[i, j].Visible := False;
             end; //End if
     end; //End if
     //Check to ensure the displayPoints is within allowed limits, theese are one lower than before to prevent overwriting of the invisible value
     if (displayPoints <= 8) and (displayPoints >= -1) then
     //Set the required number of segemnts invisible
     begin
        for j := displayPoints+1 to 9 do
            begin
                 scoreColumns[i, j].Visible := True;
            end; //End for
     end; //End if
   end; //End for loop
end; //End procedure

procedure TTFrmPoints.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ShowMessage('Saving data...');
  try
    //TFrmDepend.BtnUpdateDB.Click;
  except
    ShowMessage('Error saving')
  end;
end;

//Test proceedures
procedure TTFrmPoints.BtnTestDisplayClick(Sender: TObject);
var
  i: Integer;
begin
  if testi < noCols then
    begin
      if testj <= 100 then
        begin
             spinEdts[testi].Value:=testj;
             testj := testj + 1;
		    end  //End if
	  else
          begin
            spinEdts[testi].Value:=testcolval;
            testj := 0;
            testi := testi + 1;

            if testi = noCols then
              begin
                   testcolval := testcolval + 1;
                   if testcolval <=100 then
                   begin
                        for i := 0 to noCols do
                        begin
                           spinEdts[i].Value:=testcolval;
                        end; //End for
                        testi := 0;
                        testj := 0;
			             end  //End if
			        end; //End if
		      end; //End else
    end //End if
  else
      begin
        TFrmPoints.TestTimer.Enabled:=False;
        for i := 0 to noCols do
            begin
                spinEdts[i].Value:=0;
            end; //End for
	    end; //End else
end; //End proceedure

procedure TTFrmPoints.BtnTestClick(Sender: TObject);
begin
     TFrmPoints.TestTimer.Enabled:=True;
end;


end.
