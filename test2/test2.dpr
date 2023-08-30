program test2;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  untAutoParams in '..\untAutoParams.pas',
  untKeliUDP in '..\untKeliUDP.pas',
  untLog in '..\untLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
