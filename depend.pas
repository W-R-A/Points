unit Depend;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db, dbf, FileUtil, Forms, Controls,
  LResources, Graphics, Dialogs, ComCtrls, StdCtrls, DBGrids, ColorBox;

type

  { TTFrmDepend }

  TTFrmDepend = class(TForm)
    BtnCheck: TButton;
    BtnUpdate: TButton;
    BtnUpdateDB: TButton;
    CBColors: TComboBox;
    DataSourceLodge: TDataSource;
    DBGridCurrent: TDBGrid;
    EdtID: TEdit;
    EdtColour: TEdit;
    EdtPoints: TEdit;
    LblProgInfo: TLabel;
    LabelInfo: TLabel;
    SQLite3ConnectionMain: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTransactionIntergration: TSQLTransaction;
    procedure BtnCheckClick(Sender: TObject);
    procedure BtnUpdateClick(Sender: TObject);
    procedure BtnUpdateDBClick(Sender: TObject);
    procedure DataSourceLodgeDataChange(Sender: TObject; Field: TField);
    procedure DBGridCurrentEditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SQLite3ConnectionMainAfterConnect(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TFrmDepend: TTFrmDepend;

implementation

{$R *.lfm}

{ TTFrmDepend }
uses
  Main, performance;

procedure TTFrmDepend.SQLite3ConnectionMainAfterConnect(Sender: TObject);
begin

end;

procedure TTFrmDepend.BtnCheckClick(Sender: TObject);
begin
  if SQLite3ConnectionMain.Connected then
     begin
       try
          LabelInfo.Caption:='Successful connection established';
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
       ShowMessage('Error, database not open -trying again');
       try
         SQLite3ConnectionMain.Connected:=True;
         SQLite3ConnectionMain.Connected:=False;
       except
         ShowMessage('Error connecting to database')
       end;
     end;
end;


procedure TTFrmDepend.BtnUpdateClick(Sender: TObject);
var
  Converted:Integer;
begin
  try
    Converted:=StrtoInt(EdtPoints.Text);
  except
    ShowMessage('Error, incorrect format')
  end;
  //Write to database
  try
      if (EdtID.Text ='') and (EdtPoints.Text ='') and (EdtColour.Text ='') then
         ShowMessage('No Data entered, try again')
      else
        SQLTransactionIntergration.Active:=True;
        SQLQuery.Close;
        SQLQuery.SQL.Text := 'Insert into LodgePoints (ID,Colour,Points) values (:PrID,:PrColour,:PrPoints)';
        SQLQuery.Params.ParamByName('PrID').AsString := EdtID.Text;
        SQLQuery.Params.ParamByName('PrColour').AsString := EdtColour.Text;
        SQLQuery.Params.ParamByName('PrPoints').AsInteger:= Converted;
        SQLQuery.ExecSQL;
        SQLTransactionIntergration.Commit;
        EdtID.Text:='';
        EdtPoints.Text:='';
        EdtColour.Text:='';
        SQLTransactionIntergration.Active := False;
        SQLite3ConnectionMain.Close;
        LabelInfo.Caption:='Success';
  except
    ShowMessage('Error writing to database')
  end;
end;

procedure TTFrmDepend.BtnUpdateDBClick(Sender: TObject);
begin
  try
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

end;

procedure TTFrmDepend.DataSourceLodgeDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TTFrmDepend.DBGridCurrentEditingDone(Sender: TObject);
begin
  try
    SQLTransactionIntergration.Active:=True;
    SQLTransactionIntergration.Commit;
    SQLite3ConnectionMain.Close;
    LabelInfo.Caption:='Success - Edit done';
  except
    ShowMessage('Database write error');
  end;


end;

procedure TTFrmDepend.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //TFrmMain.Close;
end;

procedure TTFrmDepend.FormCreate(Sender: TObject);
begin
  SQLiteLibraryName:='sqlite3.dll';
  TFrmDepend.BtnCheck.Click;
end;

end.

