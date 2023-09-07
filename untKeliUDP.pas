unit untKeliUDP;

interface

uses
  System.SysUtils, Classes, IdUdpServer, IdGlobal, IdSocketHandle, Vcl.ExtCtrls;

type
  TKeLiEvent = procedure of object;

type
  //柯力UDP通讯类
  //可以接收仪表通讯，也可以自己发送数据，作为测试端
  TKeliUDP = class(TObject)
  private
    FGetData: TKeLiEvent;
    FIsSender: boolean; //是发送还是接收？true是发送
    FGrossWeight: integer;
    FDecimal: integer;
    FStatus_Steady: boolean;
    FStatus_Overload: boolean;
    FStatus_CommOK: boolean;
    FStatus_DataOK: boolean;
    udpServer: TIDUdpServer;
    timer: TTimer; //定时器, 在udp开始监听后启用, 时间到表示无通讯, 有通讯时要复位定时器
    FActive: boolean;
    FRawData: string;
    FErrorMsg: string;
    FUdpError: TKeLiEvent;
    FTimerError: boolean;
    FDateTime: string;
    FMsgLength: integer;
    FMsgLength2: integer;  //数据的实际长度
    FSensorCount: integer;
    FCheckSumOK: boolean;
    FPeerIP: string;
    FPeerPort: integer;
    FPort: integer;   //固定4097, 可以用
    procedure SetIsSender(const Value: boolean);
    procedure SetGrossWeight(const Value: integer);
    procedure SetFActive(const Value: boolean);

    procedure UDPServerRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure UDPServerError(AThread: TIdUDPListenerThread; ABinding: TIdSocketHandle; const AMessage: string;
                              const AExceptionClass: TClass);
    procedure timerOnTime(Sender: TObject);
    procedure SetPort(const Value: integer);
  public
    constructor Create();
    destructor Destroy; override;

    property IsSender: boolean read FIsSender write SetIsSender;
    property GrossWeight: integer read FGrossWeight write SetGrossWeight;
    property Decimal: integer read FDecimal;
    property Status_Steady: boolean read FStatus_Steady;
    property Status_Overload: boolean read FStatus_Overload;
    property Status_CommOK: boolean read FStatus_CommOK;
    property Status_DataOK: boolean read FStatus_DataOK;
    property Active: boolean read FActive write SetFActive;
    property OnGetData: TKeLiEvent read FGetData write FGetData;
    property OnUdpError: TKeLiEvent read FUdpError write FUdpError;
    property RawData: string read FRawData;
    property ErrorMsg: string read FErrorMsg;
    property DateTime: string read FDateTime;
    property MsgLength: integer read FMsgLength;  //数据帧的实际长度
    property MsgLength2: integer read FMsgLength2; //数据帧的定义长度
    property SensorCount: integer read FSensorCount;
    property CheckSumOK: boolean read FCheckSumOK;
    property PeerIP: string read FPeerIP;
    property PeerPort: integer read FPeerPort;
    property Port: integer read FPort write SetPort;

    procedure SetZero(); //置零
    procedure SetSendRate(bHighRate: boolean); //设置发送速率
    procedure TriggerGetDataEvent();  //触发读到数据的事件
    procedure TriggerUdpErrorEvent(); //触发udp错误的事件
  end;

implementation

{ TKeliUDP }

constructor TKeliUDP.Create;
begin
  FActive := false;
  udpServer := TIdUDPServer.Create(nil);
  udpServer.OnUDPRead := UDPServerRead;
  udpServer.OnUDPException := UDPServerError;

  timer := TTimer.Create(nil);
  timer.Interval := 2000;
  timer.OnTimer := timerOnTime;
  timer.Enabled := false;
end;

destructor TKeliUDP.Destroy;
begin
  udpServer.Active := false;
  udpServer.Free;
  timer.Enabled := false;
  timer.Free;
  inherited;
end;

procedure TKeliUDP.SetFActive(const Value: boolean);
begin
  FActive := Value;
  udpServer.Active := Value;
  timer.Enabled := Value;
end;

procedure TKeliUDP.SetGrossWeight(const Value: integer);
begin
  FGrossWeight := Value;
end;

procedure TKeliUDP.SetIsSender(const Value: boolean);
begin
  FIsSender := Value;
end;

procedure TKeliUDP.SetPort(const Value: integer);
begin
  FPort := Value;
  udpServer.Active := false;
  udpServer.DefaultPort := Value;
end;

procedure TKeliUDP.SetSendRate(bHighRate: boolean);
var
  sComm: string;
begin
  if udpServer.Active then
  begin
    //指令: SPEEDCOMMAND:1  , 0是每秒3次, 1是每秒10次, 1要新版本才支持
    if bHighRate then
      sComm := 'SPEEDCOMMAND:1'
    else
      sComm := 'SPEEDCOMMAND:0';
    udpServer.Send(FPeerIP, FPeerPort, sComm);
  end;
end;

procedure TKeliUDP.SetZero;
begin
  //即发送指令: KEYCOMMAND:ZERO
  if udpServer.Active then
    udpServer.Send(FPeerIP, FPeerPort, 'KEYCOMMAND:ZERO');
end;

procedure TKeliUDP.timerOnTime(Sender: TObject);
begin
  if not FTimerError then
  begin
    FTimerError := true;
    TriggerUdpErrorEvent();
  end;
end;

procedure TKeliUDP.TriggerGetDataEvent;
begin
  if assigned(FGetData) then
    FGetData();
end;

procedure TKeliUDP.TriggerUdpErrorEvent;
begin
  if assigned(FUdpError) then
    FUdpError();
end;

procedure TKeliUDP.UDPServerError(AThread: TIdUDPListenerThread;
  ABinding: TIdSocketHandle; const AMessage: string;
  const AExceptionClass: TClass);
begin
  FErrorMsg := AMessage;
end;

procedure TKeliUDP.UDPServerRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  iSum, iChk: integer;
begin
  var data := BytesToString(AData, IndyTextEncoding_UTF8);
  FRawData := data;

  FMsgLength := length(AData);  //接收到的数据长度
  FMsgLength2 := AData[24] shl 8 + AData[25];  //正常数据应该具有的长度

  if FMsgLength = FMsgLength2 then
  begin
    FDateTime := copy(FRawData, 8, 17);
    FSensorCount := AData[26];
    FDecimal := AData[27];
    FStatus_Steady := ((AData[40] and $4) <> 0);
    FStatus_Overload := ((AData[40] and $2) <> 0);
    FStatus_CommOK := ((AData[40] and $40) <> 0);
    FStatus_DataOK := ((AData[40] and $1) <> 0);
    FGrossWeight := AData[48] + (AData[49] shl 8) + (AData[50] shl 16) +
          (AData[51] shl 24);
    FPeerPort := ABinding.PeerPort;
    FPeerIP := ABinding.PeerIP;
    iSum := 0;
    for var i := 0 to FMsgLength - 3 do
      iSum := iSum + AData[i];
    iChk := (AData[FMsgLength - 2] shl 8) + AData[FMsgLength - 1];
    FCheckSumOK := (iSum = iChk);
  end
  else
    FCheckSumOK := false;

  TriggerGetDataEvent();
  timer.Enabled := false;
  timer.Enabled := true;
  FTimerError := false;
end;

end.
