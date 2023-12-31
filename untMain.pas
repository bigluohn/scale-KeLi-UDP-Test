{
 柯力的D2008-W、WD29-W和WD39-W的网络协议(仅支持UDP)
1. 先要在仪表端设置好仪表的IP和UDP端口（默认4097），还要设置接收方的IP和端口；
2. 仪表这边会自动发送，每秒发8帧数据；
3. 对于多字节类型的数据，如0x12345678，将分4个字节发送，0x12, 0x34....；
4. 数据帧长142个字节：
    0-6:     固定为ASCII字符: "STATE: "，注意字节6为空格 0x20;
    7-23:    当前日期和时间，如："23-02-30 14:34:59"
    24-25:   数据帧总字节数，24为00，25为0x8E
    26:      传感器数量，如10个(0xA)
    27:      小数点位置，如1
    28-39:   备用
    40:      状态位，bit0: 0-开机已确认零位，1-零位未确认(此时不能过磅，数据不准)
                     bit1: 0-正常， 1-超载
                     bit2: 0-不稳定，1-稳定
                     bit3: 0-未去皮，1-去皮
                     bit4: 0-不在零位区，1-在零位区
                     bit5: 0-计量数据无效，1-数据有效，标定或组秤过程中输出是无效的
                     bit6: 0-传感器通讯正常，1-通讯异常
                     bit7: 备用
    41-43:   备用
    44-47:   毛重内码，浮点数，将其按分度值化整数后等于毛重显示，如05.6，分度值为2，此时毛重显示6
    48-51:   毛重显示值，有符号整数，无小数点
    52-55:   皮重显示值，同上
    56-59:   净重显示值，同上
    60:      地址为1的传感器状态，0-无通讯，1：密码错，2：正常
    61-64:   地址为1的传感器内码，浮点数
    65-139:  2-16号传感器
    140-141: 校验码

校验码算法：
int16u iSum = 第0-139字节的算术加，则
校验码1(地址140) = (iSum >> 8) & 0xFF;
校验码2(地址141) = iSum & 0xFF;

例：仪表显示0.0t
接收数据(16进制),
1(从0开始的) 5             10             15             20             25             30
53 54 41 54 45 3A 20 31 39 2D 30 39 2D 32 33 20 32 32 3A 30 37 3A 32 33 00 8E 01 01 00 00
00 00 00 00 00 00 00 00 00 00 34 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
02 99 D0 1E 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 C5
仪表显示382.2t
接收数据(16进制)
53 54 41 54 45 3A 20 31 39 2D 30 39 2D 32 33 20 32 32 3A 30 38 3A 31 36 00 8E 01 01 00 00
00 00 00 00 00 00 00 00 00 00 24 00 00 00 3F DC 6E 45 EE 0E 00 00 00 00 00 00 EE 0E 00 00
02 00 B3 E4 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0B 8E


1、置零指令: "KEYCOMMAND:ZERO"
2、连续发送速度设置："SPEEDCOMMAND:1"; //0:1秒3次（默认） ，1：1秒10次(版本为V15及以上才支持)
}
unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, IdGlobal, IdGlobalProtocols,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IniFiles, untLog, untKeliUDP,
  IdSocketHandle, IdUDPClient, WinSock, IpHlpApi;

type
  TfrmMain = class(TForm)
    edtIP: TLabeledEdit;
    lst: TListBox;
    edtPort: TLabeledEdit;
    radFunc: TRadioGroup;
    edtSendText: TLabeledEdit;
    btnListen: TButton;
    btnSend: TButton;
    udpClient: TIdUDPClient;
    Label1: TLabel;
    Label2: TLabel;
    lblDateTime: TLabel;
    lblMsgLen: TLabel;
    Label4: TLabel;
    lblMsgLen2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    lblSensorCount: TLabel;
    Label6: TLabel;
    lblDecimal: TLabel;
    chkS1: TCheckBox;
    chkS2: TCheckBox;
    chkS3: TCheckBox;
    chkS4: TCheckBox;
    Label7: TLabel;
    lblGross: TLabel;
    chkChkOK: TCheckBox;
    GroupBox1: TGroupBox;
    btnZero: TButton;
    chkHighRate: TCheckBox;
    Label8: TLabel;
    lblPeerIPPort: TLabel;
    btnClear: TButton;
    btnGetIPs: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure radFuncClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnListenClick(Sender: TObject);
    procedure btnZeroClick(Sender: TObject);
    procedure chkHighRateClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnGetIPsClick(Sender: TObject);
  private
    { Private declarations }
    m_ini: TIniFile;
    m_log: TLog;
    m_KeLiUdp: TKeLiUDP;

    procedure KeLiGetData;
    procedure KeLiUdpError;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses untAutoParams;

{var
  m_ini: TIniFile;
  m_log: TLog;}

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  lst.Clear;
end;

procedure TfrmMain.btnListenClick(Sender: TObject);
begin
  if m_KeLiUDP.Active then
  begin
    m_KeLiUDP.Active := false;
    btnListen.Caption := '开始监听';
    m_log.LogMsg('停止监听');
  end
  else
  begin
    var iPort := strtoint(edtPort.Text);
    m_KeLiUDP.Port := iPort;
    m_KeLiUDP.Active := true;
    btnListen.Caption := '停止监听';
    m_log.LogMsg('开始监听');
  end;
end;

procedure TfrmMain.btnSendClick(Sender: TObject);
begin
  udpClient.Host := edtIP.Text;
  var iPort := strtoint(edtPort.Text);
  udpClient.Port := iPort;
  udpClient.Send(edtSendText.Text, IndyTextEncoding_UTF8);
end;

procedure TfrmMain.btnZeroClick(Sender: TObject);
begin
  m_KeLiUDP.SetZero;
end;


function GetLocalIP(Multi: Boolean = False): string;
type
  PPInAddr = ^PInAddr; //取本机IP，可取多个(分行列出)
var
  wsaData: TWSAData;
  HostInfo: PHostEnt;
  HostName: array[0..255] of AnsiChar;
  Addr: PPInAddr;
begin
  Result := '';
  if WSAStartup($0101, wsaData) <> 0 then
    exit;
  try
    if gethostname(HostName, SizeOf(HostName)) <> 0 then Exit;

    HostInfo := gethostbyname(HostName);
    if HostInfo = nil then Exit;

    Addr := Pointer(HostInfo^.h_addr_list);
    if (Addr = nil) or (Addr^ = nil) then Exit;

    Result := StrPas(inet_ntoa(Addr^^));
    inc(Addr);
    while (Addr^ <> nil) and Multi do begin
      Result := Result + ', ' + StrPas(inet_ntoa(Addr^^));
      inc(Addr);
    end;
  finally
    WSACleanup;
  end;
end;

//procedure GetAllIPAddresses;
//var
//  bufferSize: DWORD;
//  table: PMIB_IPADDRTABLE;
//  i: Integer;
//begin
//  bufferSize := 0;
//  GetIpAddrTable(nil, @bufferSize, False);
//
//  GetMem(table, bufferSize);
//  try
//    if GetIpAddrTable(table, @bufferSize, False) = NO_ERROR then
//    begin
//      for i := 0 to table.dwNumEntries - 1 do
//      begin
//        // 获取IP地址
//        ShowMessage(Format('IP Address: %s', [inet_ntoa(TInAddr(table.table[i].dwAddr))]));
//      end;
//    end;
//  finally
//    FreeMem(table);
//  end;
//end;

procedure TfrmMain.btnGetIPsClick(Sender: TObject);
begin
  lst.Items.Add('本机的IP为: ' + GetLocalIP(true));
end;

procedure TfrmMain.chkHighRateClick(Sender: TObject);
begin
  m_KeLiUDP.SetSendRate(chkHighRate.Checked);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_KeLiUDP.Active := false;
  HandleAllComponents(m_ini, self, false);
  m_ini.Free;
  m_log.LogMsg('程序关闭');
  freeandnil(m_log);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
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

procedure TfrmMain.KeLiGetData;
begin
  m_Log.LogMsg(copy(m_KeLiUDP.RawData, 1, 7));

  if not m_KeLiUDP.CheckSumOK then
    m_Log.LogMsg('数据异常, 数据头: ' + copy(m_KeLiUDP.RawData, 1, 7))
  else
  begin
    lblMsgLen.Caption := m_KeLiUDP.MsgLength.ToString;
    lblDateTime.Caption := m_KeLiUDP.DateTime;
    lblMsgLen2.Caption := m_KeLiUDP.MsgLength2.ToString;
    lblSensorCount.Caption := m_KeLiUDP.SensorCount.ToString;
    lblDecimal.Caption := m_KeLiUDP.Decimal.ToString;
    lblGross.Caption := m_KeLiUDP.GrossWeight.ToString;
    lblPeerIPPort.Caption := m_KeLiUDP.PeerIP + ':' + m_KeLiUDP.PeerPort.ToString;

    chkS1.Checked := m_KeLiUDP.Status_DataOK;
    chkS2.Checked := m_KeLiUDP.Status_Overload;
    chkS3.Checked := m_KeLiUDP.Status_Steady;
    chkS4.Checked := m_KeLiUDP.Status_CommOK;
    chkChkOK.Checked := m_KeLiUDP.CheckSumOK;
  end;

end;

procedure TfrmMain.KeLiUdpError;
begin
  m_Log.LogMsg('!!!无法通讯!!!');
end;

procedure TfrmMain.radFuncClick(Sender: TObject);
begin
  btnSend.Enabled := (radFunc.ItemIndex = 0);
  btnListen.Enabled := (radFunc.ItemIndex = 1);

  if assigned(m_KeLiUDP) then
    m_KeLiUDP.Active := false;
end;

end.
