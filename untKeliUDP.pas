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
    FClientPort: integer;
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
    FStrTmp: string;
    FSensorCount: integer;
    procedure SetIsSender(const Value: boolean);
    procedure SetClientPort(const Value: integer);
    procedure SetGrossWeight(const Value: integer);
    procedure SetFActive(const Value: boolean);

    procedure UDPServerRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure UDPServerError(AThread: TIdUDPListenerThread; ABinding: TIdSocketHandle; const AMessage: string;
                              const AExceptionClass: TClass);
    procedure timerOnTime(Sender: TObject);
    function CheckData(): integer;
  public
    constructor Create();
    destructor Destroy; override;

    property IsSender: boolean read FIsSender write SetIsSender;
    property ClientPort: integer read FClientPort write SetClientPort;
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
    property StrTmp: string read FStrTmp;

    procedure TriggerGetDataEvent();  //触发读到数据的事件
    procedure TriggerUdpErrorEvent(); //触发udp错误的事件
  end;

implementation

{ TKeliUDP }

//检查读回来的数据(格式)是否正确
function TKeliUDP.CheckData: integer;
begin
  result := 0;

  //1. 数据头, 是不是 'STATE: '
  var sBegin := RawData.Substring(1, 7);
  if sBegin = 'STATE: ' then
  begin
    var iLen1 := length(RawData);       //实际的数据帧长度
    var iLen2 := strtoint('0x' + RawData.Substring(25, 2)); //数据帧里面描述的长度
    if iLen1 = iLen2 then
    begin
      //校验码
      //var iSum :=


      exit(0); //返回码0, 正常
    end
    else
      exit(2); //返回码2, 数据帧长度不一致
  end
  else
    exit(1);  //返回码1, 数据头不是 'STATE: '
end;

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

procedure TKeliUDP.SetClientPort(const Value: integer);
begin
  FClientPort := Value;
  udpServer.Active := false;
  udpServer.DefaultPort := Value;
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
  sTmp: string;
begin
  var data := BytesToString(AData, IndyTextEncoding_UTF8);
  FRawData := data;
  FMsgLength := length(FRawData);
  FDateTime := copy(FRawData, 8, 17);
  FMsgLength2 := AData[24] shl 8 + AData[25];
  FSensorCount := AData[26];
  FDecimal := AData[27];
  FStatus_Steady := ((AData[40] and $4) <> 0);
  FStatus_Overload := ((AData[40] and $2) <> 0);
  FStatus_CommOK := ((AData[40] and $40) <> 0);
  FStatus_DataOK := ((AData[40] and $1) <> 0);

  TriggerGetDataEvent();
  timer.Enabled := false;
  timer.Enabled := true;
  FTimerError := false;
end;

end.
