unit untKeliUDP;

interface

uses
  System.SysUtils, Classes, IdUdpServer, IdGlobal, IdSocketHandle, Vcl.ExtCtrls;

type
  TKeLiEvent = procedure of object;

type
  //����UDPͨѶ��
  //���Խ����Ǳ�ͨѶ��Ҳ�����Լ��������ݣ���Ϊ���Զ�
  TKeliUDP = class(TObject)
  private
    FGetData: TKeLiEvent;
    FIsSender: boolean; //�Ƿ��ͻ��ǽ��գ�true�Ƿ���
    FGrossWeight: integer;
    FDecimal: integer;
    FStatus_Steady: boolean;
    FStatus_Overload: boolean;
    FStatus_CommOK: boolean;
    FStatus_DataOK: boolean;
    udpServer: TIDUdpServer;
    timer: TTimer; //��ʱ��, ��udp��ʼ����������, ʱ�䵽��ʾ��ͨѶ, ��ͨѶʱҪ��λ��ʱ��
    FActive: boolean;
    FRawData: string;
    FErrorMsg: string;
    FUdpError: TKeLiEvent;
    FTimerError: boolean;
    FDateTime: string;
    FMsgLength: integer;
    FMsgLength2: integer;  //���ݵ�ʵ�ʳ���
    FSensorCount: integer;
    FCheckSumOK: boolean;
    FPeerIP: string;
    FPeerPort: integer;
    FPort: integer;   //�̶�4097, ������
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
    property MsgLength: integer read FMsgLength;  //����֡��ʵ�ʳ���
    property MsgLength2: integer read FMsgLength2; //����֡�Ķ��峤��
    property SensorCount: integer read FSensorCount;
    property CheckSumOK: boolean read FCheckSumOK;
    property PeerIP: string read FPeerIP;
    property PeerPort: integer read FPeerPort;
    property Port: integer read FPort write SetPort;

    procedure SetZero(); //����
    procedure SetSendRate(bHighRate: boolean); //���÷�������
    procedure TriggerGetDataEvent();  //�����������ݵ��¼�
    procedure TriggerUdpErrorEvent(); //����udp������¼�
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
    //ָ��: SPEEDCOMMAND:1  , 0��ÿ��3��, 1��ÿ��10��, 1Ҫ�°汾��֧��
    if bHighRate then
      sComm := 'SPEEDCOMMAND:1'
    else
      sComm := 'SPEEDCOMMAND:0';
    udpServer.Send(FPeerIP, FPeerPort, sComm);
  end;
end;

procedure TKeliUDP.SetZero;
begin
  //������ָ��: KEYCOMMAND:ZERO
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

  FMsgLength := length(AData);  //���յ������ݳ���
  FMsgLength2 := AData[24] shl 8 + AData[25];  //��������Ӧ�þ��еĳ���

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
