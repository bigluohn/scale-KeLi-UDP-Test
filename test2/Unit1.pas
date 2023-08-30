unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, IniFiles;

type
  TForm1 = class(TForm)
    edtPort: TLabeledEdit;
    lst: TListBox;
    btnListen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnListenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure KeLiGetData;
    procedure KeLiUdpError;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses untAutoParams, untKeliUDP, untLog;

var
  m_Log: TLog;
  m_KeLiUDP: TKeLiUDP;
  m_ini: TIniFile;


procedure TForm1.btnListenClick(Sender: TObject);
begin
  var iPort := strtoint(edtPort.Text);
  m_KeLiUDP.ClientPort := iPort;
  m_KeLiUDP.Active := true;
  m_Log.LogMsg('开始监听');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_KeLiUDP.Active := false;
  HandleAllComponents(m_ini, self, false);
  m_KeLiUDP.Free;
  m_ini.Free;
  m_log.LogMsg('程序关闭');
  m_log.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  m_ini := TIniFile.Create(extractfilepath(application.ExeName) + 'Settings.ini');
  HandleAllComponents(m_ini, self, true);
  m_Log := TLog.Create;
  m_Log.PListBox := @lst;
  m_KeLiUDP := TKeLiUDP.Create;
  m_KeLiUDP.OnGetData := KeLiGetData;
  m_KeLiUDP.OnUdpError := KeLiUdpError;
  m_log.LogMsg('进入程序');
end;

procedure TForm1.KeLiGetData;
begin
  m_Log.LogMsg(m_KeLiUDP.RawData);
end;

procedure TForm1.KeLiUdpError;
begin
  m_Log.LogMsg('Udp error timer');
end;

end.
