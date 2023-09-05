unit untLog;

interface

uses
  SysUtils, Vcl.Forms, Vcl.StdCtrls, System.Classes;

type
  LogFileSaveType = (NotSave, OnlyOneFile, OneFilePerDay);

type
  PListBox = ^TListBox;

type
  TLog = class
  private
    FLogFileType: LogFileSaveType;
    FLogFileDir: string;
    FFile: TextFile;
    FLogFileSize: integer;
    FListBox: PListBox;
    FLogFileName: string;
  public
    property LogFileType: LogFileSaveType read FLogFileType write FLogFileType;
    property LogFileDir: string read FLogFileDir write FLogFileDir;
    property LogFileSize: integer read FLogFileSize write FLogFileSize;   //µ¥Î»ÎªM
    property PListBox: PListBox read FListBox write FListBox;
    property LogFileName: string read FLogFileName write FLogFileName;

    constructor Create(); overload;
    constructor Create(sPath: string); overload;
    destructor Destroy; override;
    procedure LogMsg(sMsg: string);
  end;
implementation

{ TLog }

destructor TLog.Destroy;
begin
//  if FListBox <> nil then
//  begin
//    if not DirectoryExists(LogFileDir) then
//      CreateDir(LogFileDir);
//    FListBox.Items.SaveToFile(LogFileDir + LogFileName);
//  end;
  inherited destroy;
end;

constructor TLog.Create(sPath: string);
begin
  LogFileDir := sPath;
  LogFileType := LogFileSaveType.OnlyOneFile;
  LogFileSize := 2;
  LogFileName := 'LogFile.log';
  if not DirectoryExists(LogFileDir) then
    CreateDir(LogFileDir);
end;

constructor TLog.Create;
begin
  LogFileDir := ExtractFilePath(application.ExeName) + 'log\';
  LogFileType := LogFileSaveType.OnlyOneFile;
  LogFileSize := 2;
  LogFileName := 'LogFile.log';
  if not DirectoryExists(LogFileDir) then
    CreateDir(LogFileDir);

  var sFile := LogFileDir + LogFileName;
  if fileexists(sFile) then
  begin
    var sl := TStringList.Create;
    try
      sl.LoadFromFile(sFile);
      if sl.Count > 10000 then
      begin
        for var i := 1 to sl.Count - 9500 do
          sl.Delete(0);
        sl.SaveToFile(sFile);
      end;
    finally
      freeandnil(sl);
    end;
  end;

end;

procedure TLog.LogMsg(sMsg: string);
begin
  if FListBox <> nil then
  begin
    var sTime := datetimetostr(now) + ' ----> ' + sMsg;
    if assigned(FListBox) then
      FListBox.Items.Add(sTime);

    if LogFileType <> LogFileSaveType.NotSave then
    begin
      var sFile: TextFile;
      var sFileName := LogFileDir + LogFileName;
      assignfile(sFile, sFileName);
      if fileexists(sFileName) then
        append(sFile)
      else
        rewrite(sFile);
      try
        writeln(sFile, sTime);
      finally
        CloseFile(sFile);
      end;
    end;
  end;
end;

end.
