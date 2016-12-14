unit Util;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, sqlite3dyn, db, dbf, FileUtil, Forms, Controls,
  LResources, Graphics, Dialogs, StdCtrls, DBGrids, ExtCtrls;

type

  { TTFrmUtil }

  TTFrmUtil = class(TForm)
    BtnCheckDatabase: TButton;
    BtnCreateDatabaseFile: TButton;
    BtnUpdateDatabase: TButton;
    BtnGetPoints: TButton;
    BtnLoadConfig: TButton;
    BtnOpenDatabaseFile: TButton;
    DataSourceLodge: TDataSource;
    OpenDlgDatabase: TOpenDialog;
    SaveDlgDatabase: TSaveDialog;
    SQLite3ConnectionMain: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTransactionIntergration: TSQLTransaction;
    procedure BtnCheckDatabaseClick(Sender: TObject);
    procedure BtnCreateDatabaseFileClick(Sender: TObject);
    procedure BtnGetPointsClick(Sender: TObject);
    procedure BtnLoadConfigClick(Sender: TObject);
    procedure BtnOpenDatabaseFileClick(Sender: TObject);
    procedure BtnUpdateDatabaseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SQLite3ConnectionMainAfterConnect(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    RecordNo : Integer;
    Options : array of String;
    OptionsValues : array of String;
  end;

var
  TFrmUtil: TTFrmUtil;

implementation

{$R *.lfm}

{ TTFrmUtil }
uses
  Main, performance;

procedure TTFrmUtil.SQLite3ConnectionMainAfterConnect(Sender: TObject);
begin

end;

procedure TTFrmUtil.BtnCheckDatabaseClick(Sender: TObject);
begin
  if SQLite3ConnectionMain.Connected then
     begin
       try
         //If a connection is already present, start the database transaction
         SQLTransactionIntergration.Active:=True;
       except
         //If there is an error, trap it and close the program
         ShowMessage('A Fatal Error has occured');
         SQLite3ConnectionMain.Close();
         TFrmMain.Close;
       end;
     end //End if
   else
     begin
       try
         //Try and close and reopen the database to establish a connection
         SQLite3ConnectionMain.Connected:=False;
         SQLite3ConnectionMain.Connected:=True;
       except
         //Tell the user that an error occured
         ShowMessage('Error connecting to database')
       end; //End except
     end; //End else

   //Test to ensure the database is valid
   SQLQuery.Active:=False;
   SQLQuery.SQL.Clear;
   SQLQuery.SQL.Text:='SELECT * FROM Points';
   try
     SQLQuery.Active:=True;
     RecordNo := SQLQuery.RecordCount;
     SQLQuery.Active:=False;
   except
     //Trap errors relating to an invaild database format
     on EDatabaseError do
       begin
         //Tell user that an error occured while reading the database
         ShowMessage('Unable to read the database or the data is in an invalid format, please try again');
         //Close down the connection with the invalid file
         SQLite3ConnectionMain.Connected:=False;
         SQLite3ConnectionMain.Close();
         //Ask the user to choose a different file
         TFrmUtil.BtnOpenDatabaseFile.Click;
       end;
   end;
   //Now that inital tests show that the database is okay, cleanup unneeded stuff
   TFrmUtil.OpenDlgDatabase.CleanupInstance;
end;

procedure TTFrmUtil.BtnCreateDatabaseFileClick(Sender: TObject);
begin

end;

//Insert into LodgePoints (Colour,Points) values ('FF0000', '0')
procedure TTFrmUtil.BtnGetPointsClick(Sender: TObject);
var
  i:Integer;
begin
  try
    begin
      //Load points from database
      //Load all records to determine total number of rows in the database
      RecordNo := SQLQuery.RecordCount;
      SQLQuery.Active:=False;
      //Set the arrays to the appropiate length based on what is in the database
      SetLength(TFrmPoints.points, (RecordNo+1));
      SetLength(TFrmPoints.Colours, (RecordNo+1));
      //Extract each row seperately from the database and process the data
      for i := 1 to RecordNo do
        begin
          SQLQuery.SQL.Clear;
          SQLQuery.SQL.Text:='SELECT * FROM LodgePoints WHERE ID='+IntToStr(i);
          SQLQuery.Active:=True;
          TFrmPoints.Colours[i-1]:=SQLQuery.Fields[1].AsString;
          TFrmPoints.points[i-1]:=SQLQuery.Fields[2].AsInteger;
          SQLQuery.Active:=False;
        end;
      SQLTransactionIntergration.CloseDataSets;
      SQLTransactionIntergration.CleanupInstance;
      SQLQuery.Active:=False;
      SQLQuery.Close;
    end;
  except
    begin
    //If no data can be found, override the value, TODO - display a setup screen if this happens
        if RecordNo < 1 then
          begin
            //ShowMessage('There does not seem to be and data in the database, would you like to add a colour?');
            RecordNo := 1;
          end; //End if
      ShowMessage('Could not read database');
    end;
  end;
end;

procedure TTFrmUtil.BtnLoadConfigClick(Sender: TObject);
begin

end;

procedure TTFrmUtil.BtnOpenDatabaseFileClick(Sender: TObject);
begin
  while (TFrmUtil.OpenDlgDatabase.Execute = False) do
    begin
      ShowMessage('No file has been selected, please try again');
    end;
  SQLite3ConnectionMain.DatabaseName:=TFrmUtil.OpenDlgDatabase.FileName;
  TFrmUtil.BtnCheckDatabase.Click;
end;

procedure TTFrmUtil.BtnUpdateDatabaseClick(Sender: TObject);
begin
  //UPDATE LodgePoints SET Points = '68' where ID = '4';
 { try
    SQLite3ConnectionMain.Connected:=True;
    SQLite3ConnectionMain.Open;
    SQLTransactionIntergration.Active := True;
    SQLite3ConnectionMain.ExecuteDirect('UPDATE LodgePoints SET Points = '''+InttoStr(TFrmPoints.Points1)+''' WHERE ID = ''1'';');
    SQLite3ConnectionMain.ExecuteDirect('UPDATE LodgePoints SET Points = '''+InttoStr(TFrmPoints.Points2)+''' WHERE ID = ''2'';');
    SQLite3ConnectionMain.ExecuteDirect('UPDATE LodgePoints SET Points = '''+InttoStr(TFrmPoints.Points3)+''' WHERE ID = ''3'';');
    SQLite3ConnectionMain.ExecuteDirect('UPDATE LodgePoints SET Points = '''+InttoStr(TFrmPoints.Points4)+''' WHERE ID = ''4'';');
    //ShowMessage('UPDATE LodgePoints SET Points = '''+InttoStr(TFrmPoints.Points4)+''' WHERE ID = ''4'';');
    SQLTransactionIntergration.Commit;
  except
    ShowMessage('Unable to write to database')
  end;
  }
end;

procedure TTFrmUtil.FormCreate(Sender: TObject);
begin
  sqlite3dyn.SqliteDefaultLibrary := 'sqlite3.dll';

  if FileExists('Points.txt') then
  begin
    if MessageDlg('Confirm', 'Existing database found, would you like to open it?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      SQLite3ConnectionMain.DatabaseName:='Points.db'
    else
      begin
        TFrmUtil.OpenDlgDatabase.Create(TFrmUtil.BtnOpenDatabaseFile);
        TFrmUtil.BtnOpenDatabaseFile.Click;
      end;
  end;
end;

end.

