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
    FClientPort: integer;
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
    procedure SetIsSender(const Value: boolean);
    procedure SetClientPort(const Value: integer);
    procedure SetGrossWeight(const Value: integer);
    procedure SetDecimal(const Value: integer);
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
    property Decimal: integer read FDecimal write SetDecimal;
    property Status_Steady: boolean read FStatus_Steady;
    property Status_Overload: boolean read FStatus_Overload;
    property Status_CommOK: boolean read FStatus_CommOK;
    property Status_DataOK: boolean read FStatus_DataOK;
    property Active: boolean read FActive write SetFActive;
    property OnGetData: TKeLiEvent read FGetData write FGetData;
    property OnUdpError: TKeLiEvent read FUdpError write FUdpError;
    property RawData: string read FRawData;
    property ErrorMsg: string read FErrorMsg;

    procedure TriggerGetDataEvent();  //�����������ݵ��¼�
    procedure TriggerUdpErrorEvent(); //����udp������¼�
  end;

implementation

{ TKeliUDP }

//��������������(��ʽ)�Ƿ���ȷ
function TKeliUDP.CheckData: integer;
begin
  result := 0;

  //1. ����ͷ, �ǲ��� 'STATE: '
  var sBegin := RawData.Substring(1, 7);
  if sBegin = 'STATE: ' then
  begin
    var iLen1 := length(RawData);       //ʵ�ʵ�����֡����
    var iLen2 := strtoint('0x' + RawData.Substring(25, 2)); //����֡���������ĳ���
    if iLen1 = iLen2 then
    begin
      //У����
      //var iSum :=


      exit(0); //������0, ����
    end
    else
      exit(2); //������2, ����֡���Ȳ�һ��
  end
  else
    exit(1);  //������1, ����ͷ���� 'STATE: '
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

procedure TKeliUDP.SetDecimal(const Value: integer);
begin
  FDecimal := Value;
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
begin
  var data := BytesToString(AData, IndyTextEncoding_UTF8);
  FRawData := data;
  TriggerGetDataEvent();
  timer.Enabled := false;
  timer.Enabled := true;
  FTimerError := false;
end;

end.
