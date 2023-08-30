program KeliUDPTest;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  untKeliUDP in 'untKeliUDP.pas',
  untAutoParams in 'untAutoParams.pas',
  untLog in 'untLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
