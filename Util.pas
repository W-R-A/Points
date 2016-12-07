unit Util;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, sqlite3dyn, db, dbf, FileUtil, Forms, Controls,
  LResources, Graphics, Dialogs, StdCtrls, DBGrids, ExtCtrls;

type

  { TTFrmUtil }

  TTFrmUtil = class(TForm)
    BtnCheck: TButton;
    BtnUpdateDB: TButton;
    BtnGetPoints: TButton;
    BtnLoadConfig: TButton;
    DataSourceLodge: TDataSource;
    OpenDlgDatabase: TOpenDialog;
    SQLite3ConnectionMain: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTransactionIntergration: TSQLTransaction;
    procedure BtnCheckClick(Sender: TObject);
    procedure BtnGetPointsClick(Sender: TObject);
    procedure BtnLoadConfigClick(Sender: TObject);
    procedure BtnUpdateDBClick(Sender: TObject);
    procedure FormClose(Sender: TObject);
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

procedure TTFrmUtil.BtnCheckClick(Sender: TObject);
begin
  if SQLite3ConnectionMain.Connected then
     begin
       try
          ShowMessage('A connection is already established');
          SQLTransactionIntergration.Active:=True;
          SQLQuery.Active:=True;
       except
         ShowMessage('Fatal Error');
         SQLite3ConnectionMain.Close();
         TFrmMain.Close;
       end;
     end
   else
     begin
       try
         SQLite3ConnectionMain.Connected:=False;
         SQLite3ConnectionMain.Connected:=True;
       except
         ShowMessage('Error connecting to database')
       end;
     end;


     //File checking

     //Attempt to open

      TFrmUtil.OpenDlgDatabase.Create(BtnGetPoints);


      //Terminate
      TFrmMain.Close;
end;

//Insert into LodgePoints (Colour,Points) values ('FF0000', '0')
procedure TTFrmUtil.BtnGetPointsClick(Sender: TObject);
var
  i:Integer;
begin
  try
    begin
      //todo -- test to see if the file existes before opening it
      //Load points from database
      //Load all records to determine total number of rows in the database
      SQLQuery.Active:=False;
      SQLQuery.SQL.Clear;
      SQLQuery.SQL.Text:='SELECT * FROM Points';
      try
          SQLQuery.Active:=True;
      except
        on EDatabaseError do
        begin
          ShowMessage('Unable to start database connection');
          TFrmMain.Close;
        end;
      end;
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

procedure TTFrmUtil.BtnUpdateDBClick(Sender: TObject);
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

procedure TTFrmUtil.FormClose(Sender: TObject);
begin
  //TFrmMain.Close;
end;

procedure TTFrmUtil.FormCreate(Sender: TObject);
begin
  sqlite3dyn.SqliteDefaultLibrary := 'sqlite3.dll';
  TFrmUtil.BtnCheck.Click;
end;

end.

