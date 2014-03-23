unit u_public_intf;

interface

uses
  Windows, Types, u_string, u_estack, u_gui_intf, u_gui_const, ActiveX;

const
  PRX_TYPE_NONE     = 0;
  PRX_TYPE_HTTP     = 1;
  PRX_TYPE_HTTPS    = 2;
  PRX_TYPE_SOCKS4   = 3;
  PRX_TYPE_SOCKS4A  = 4;
  PRX_TYPE_SOCKS5   = 5;

  PRX_AUTH_NONE     = 0;
  PRX_AUTH_SOCKS    = 1;
  PRX_AUTH_BASIC    = 2;
  PRX_AUTH_NTLM     = 3;

type
  {qip account connection setting record}
  TConnectSet = record
    PrxType         : Byte;         //proxy type, PRX_TYPE_..
    PrxHost         : WideString;
    PrxPort         : WideString;
    PrxAuthNeeded   : Boolean;      //proxy requires authentication
    PrxUser         : WideString;
    PrxPassword     : WideString;
    PrxNtlmAuth     : Boolean;      //proxy authentication method is NTLM
  end;
  pConnectSet = ^TConnectSet;

  TRequestMethod  = (rmUnknown, rmGet, rmPost, rmDelete, rmHead, rmPut);
  THttpAuthType   = (httpAuthNone, httpAuthBasic, httpAuthNtlm);
  TTimeoutType    = (toIdle, toConnect, toKeepAlive);

type

//******* STRINGS *******//

  IString     = u_string.IString;
  IStringList = u_string.IStringList;

//******* HTTP *******//

  IQIPHttpRequest   = interface;
  IQIPHttpSession   = interface;
  IQIPHttpHandler   = interface;

  IQIPNetwork = interface
  ['{830949FC-34DC-4EA4-8492-072DDA82727A}']
    function  CreateHttpSession(DllHandle: Integer; var Session: IQipHttpSession): Boolean; safecall;
    function  CreateHttpRequest(const URL: WideString; Method: TRequestMethod; Session: IQipHttpSession; Handler: IQipHttpHandler; AllowLocationChange: Boolean = True): IQipHttpRequest; overload; safecall;
    function  CreateHttpRequest(const URL: WideString; Method: TRequestMethod; Session: IQipHttpSession; Handler: IQipHttpHandler; var Req: IQipHttpRequest; AllowLocationChange: Boolean = True): Boolean; overload; safecall;

    function  Base64Encode(Data: WideString): WideString; safecall;
    function  Base64Decode(Data: WideString): WideString; safecall;

    function  UrlEncodeUTF8(const S: WideString): WideString; safecall;
    function  UrlDecodeUTF8(const S: WideString): WideString; safecall;

    function  StrMD5(const Buffer : WideString): WideString; safecall;
    function  GetMD5(Buffer: Pointer; BufSize: Integer): WideString; safecall;

    function  HMAC_SHA1(const Base, Key: WideString): WideString; overload; safecall;
    function  HMAC_SHA1(BaseBuf: Pointer; BaseSize: Integer; KeyBuf: Pointer; KeySize: Integer): WideString; overload; safecall;
  end;
  pIQIPNetwork = ^IQIPNetwork;

  IQIPHttpSession = interface
  ['{FBA7CBD7-0C43-45DF-B89F-D683D7B12A03}']
    procedure Initialize(DllHandle: Integer); safecall;
    function  Save: WideString; safecall;
    procedure Restore(Cookies: PWideChar); safecall;

    procedure ProcessCookies(Req: IQipHttpRequest); safecall;
    function  GetCookie(Req: IQipHttpRequest; Name: PWideChar): WideString; safecall;
    function  GetCookies(Req: IQipHttpRequest): WideString; safecall;

    function  GetRetriesCount: Integer; safecall;
    procedure SetRetriesCount(Count: Integer); safecall;

    function  GetTimeOut: Integer; safecall;
    procedure SetTimeOut(TimeOut: Integer); safecall;

    function  Proxy: TConnectSet; safecall;
    procedure SetProxy(const AProxy: TConnectSet); safecall;
  end;

  IQipHttpRequest = interface
  ['{CA0CCF60-A091-4F82-B7EF-F57D42303FE8}']
    procedure Cancel; safecall;
    procedure SetTimeout(ConnTimeout, IdleTimeout: Integer); overload; safecall;

    procedure AddHeader(Value: PWideChar); safecall;
    procedure AddReferer(Req: IQipHttpRequest); safecall;
    procedure SetHttpVersion(Value: PWideChar); safecall;
    procedure SetContentType(Value: PWideChar); safecall;
    procedure SetData(Data: Pointer; Size: Cardinal); safecall;

    procedure Send; safecall;
    function  Method: TRequestMethod; safecall;
    function  URL: WideString; safecall;
    function  Headers: WideString; safecall;
    function  Cookie: WideString; safecall;
    procedure SetCookie(const ACookie: WideString); safecall;

    function  GetUserAgent: WideString; safecall;
    procedure SetUserAgent(Agent: PWideChar); safecall;

    function  IsSecured: Boolean; safecall;
    procedure SetServerAuth(AuthType: THttpAuthType; UserName, UserPass: WideString); safecall;
    function  Location: WideString; safecall;

    function  GetTimeout(ValueType: TTimeoutType): Integer; safecall;
    procedure SetTimeout(ValueType: TTimeoutType; Value: Integer); overload; safecall;
  end;

  IQipHttpHandler = interface
  ['{3C98B3C4-B42F-461C-9093-0A0346588A60}']
    procedure OnHttpDone(Req: IQipHttpRequest; StatusCode: Integer; Data: Pointer; Size: Int64); safecall;
    procedure OnHttpError(Req: IQipHttpRequest; ErrCode: Integer; Msg: WideString); safecall;
    procedure OnHttpHead(Req: IQipHttpRequest; StatusCode: Integer; Data: Pointer; Size: Int64); safecall;
  end;

  IQipHttpSendRcvHandler = interface(IQipHttpHandler)
  ['{F5050E06-EC76-4FA3-9135-E16FD39BB346}']
    procedure OnHttpSending(Req: IQipHttpRequest; Data: Pointer; Size: Int64; TotalSent: Int64); safecall;
    procedure OnHttpReceiving(Req: IQipHttpRequest; Data: Pointer; Size: Int64; TotalReceived: Int64); safecall;
    function  GetSendStream(Req: IQipHttpRequest): IStream; safecall;
    function  GetRcvStream(Req: IQipHttpRequest): IStream; safecall;
    procedure OnHttpBeforeSendHeaders(Req: IQipHttpRequest; Method: IString; Headers: IStringList; var Changed: Boolean); safecall;
  end;

//******* QIP GRAPHICS *******//

  SkinString          = IString;
  TThinGraphicPointer = Pointer;

  //������ �� ������������� ��������
  TAnimationItemData = record
    Coord    : TRect;        //���� �������� (��������� ����� ���� �������������� � IAnimationTarget.OnDraw)
    //�������� ������:
    Frames   : Longint;      //����� ������
    Delays   : PDWORD;       //��������� �� ������ ������� ������� ������� Frames (@delays[0])
                             //! ������� ������ ����������� ����� ����������� - ������������ GetMem/FreeMem
    UpdDelay : Longint;      //������ ���������� ��� ��������� �������� ��������� (0 - ����)
    Cycles   : Longint;      //����� ������ �������� (0 - ����������, ! ��� rv ������ = 0)

    //��������� �������� ��� �������� (������ ������ ��� �������������)
    CurFrame : Longint;      //������� ���� 
    Timeout  : Longint;      //�������� �� ���������� ����� (��������� Delays � UpdDelay)
    CyclesLeft: Longint;     //�������� ������ ��������
  end;
  pAnimationItemData = ^TAnimationItemData;

  IAnimationTarget = interface;

  //������ �������� ��� TThinGraphic
  IAnimationProcessor = interface
  ['{1F510F51-5E9D-4232-9E57-DCFDE690FD6A}']
    //����� ���������� ����� ������������ ����������
    function Start(): LongBool; stdcall;
    function Stop() : LongBool; stdcall;
    //���������� UpdateCount
    function BeginUpdate(): Longint; stdcall;
    function EndUpdate()  : Longint; stdcall;

    //���������� �������� � ��������� ��� ����� ��� ���������� � Align �� �������
    //�������� �������� ��� ��������, ���������� ID (����� ���������� ��������� ANIMATION_STATE_DEFAULT)
    function Add (const Image: TThinGraphicPointer; const Target: IAnimationTarget; const Dst: TRect): Longint; stdcall;
    //������ �������� �� ���������, ��������� ��������� IAnimationTarget
    function Del (const ID: Longint): LongBool; stdcall;
    //������������� ����� ��������� ��� ��������, ���������� ����������
    function SetState(const ID: Longint; const NewState: DWORD): DWORD; stdcall;
    //������������� ����� ��������� ��������
    function SetData(const ID: Longint; const NewData: pAnimationItemData): LongBool; stdcall;

    //���������� �������� �� DC (������ ���������� �� IAnimationTarget.OnDraw)
    function Draw(const ID: Longint; const Data: pAnimationItemData; const DC: HDC; const Dst: TRect): LongBool; stdcall;

    //���������� ��������
    function Repaint(const ID: Longint): LongBool; stdcall;
  end;

  //���������� ��������� ����� � ����������� �����
  //���������� ��� �������� ����� - ������ IAnimationProcessor (����� ���� ��������� ID ��� ����� ��������)
  IAnimationTarget = interface
  ['{7F8A4791-A440-4BF0-BD05-75ABB8DE75CC}']
    //������� ������ : IAnimator.DrawFrame > OnDraw > IAnimator.Draw > DoEraseBackground
    function OnDraw(const Animator: IAnimationProcessor; const ID: Longint; const Data: pAnimationItemData): LongBool; stdcall;
    function DoEraseBackground(const DC: HDC; const ID: Longint; const Dst: TRect): LongBool; stdcall;
  end;

  ISkinDraw = interface
  ['{64A24FD2-EDC8-40FD-A9C9-4D926881B903}']
    //���������/�������� ����������� � ��������� uri
    function GetSkinIm(const uri: PWideChar; group: PWideChar = nil): TThinGraphicPointer; stdcall;
    //������� ����������� �� ����
    function FreeSkinIm(const uri: PWideChar; group: PWideChar = nil): BOOL; stdcall;

    //���������� ����������� � ��������� �����:
    //���������� � ����������� Rect ��������� Stretch ���������������
    function DrawSkinIm(const DC: HDC; const Rect: TRect; const ImageURI: PWideChar): BOOL; overload; stdcall;
    //���������� � ��������� X,Y � �������� ��������� �����������
    function DrawSkinIm(const DC: HDC; const X,Y: Integer; const ImageURI: PWideChar; ImageSize: PSize = nil): BOOL; overload; stdcall;
    //���������� � ������ ������� Rect(0,0,W,H)
    function DrawSkinImCenter(const DC: HDC; const W,H: Integer; const ImageURI: PWideChar; ImageSize: PSize = nil): BOOL; overload; stdcall;

    function DrawSkinIm2(const DC: HDC; const Rect: TRect; const ImageURI: SkinString): BOOL; overload; stdcall;
    function DrawSkinIm2(const DC: HDC; const X,Y: Integer; const ImageURI: SkinString; ImageSize: PSize = nil): BOOL; overload; stdcall;
    function DrawSkinImCenter2(const DC: HDC; const W,H: Integer; const ImageURI: SkinString; ImageSize: PSize = nil): BOOL; overload; stdcall;

    function DrawSkinIm3(const DC: HDC; const Rect: TRect; const ImageURI: WideString): BOOL; overload; stdcall;
    function DrawSkinIm3(const DC: HDC; const X,Y: Integer; const ImageURI: WideString; ImageSize: PSize = nil): BOOL; overload; stdcall;
    function DrawSkinImCenter3(const DC: HDC; const W,H: Integer; const ImageURI: WideString; ImageSize: PSize = nil): BOOL; overload; stdcall;

    //���������� True ���� ����������� �������� � ���������� � ImageSize ������ ����������� �����������
    //��� ���������� ����������� �������� ���������� ������ ����� �� ��������������� ��������� (��� ����� �� ��� ��� ���� �������� ��������� �� ����������)
    function GetImSize(const ImageSize: PSize; const uri: PWideChar; group: PWideChar = nil): BOOL; stdcall;
    //���������� ����������� � ���� ������ (32 ���� � ��������� ��������), ���� 0 ���� ������ ����������� ���, ����� ������������� ������ ������ ��� ���������� ������
    function GetSkinIm_AsIcon(const uri: PWideChar; group: PWideChar = nil; W: Integer = -1; H: Integer = -1): HICON; stdcall;
    //���������� ����������� � ���� HBITMAP (32 ���� �������� ��������), ���� 0 ���� ������ ����������� ���, ����� ������������� ������ ������ ��� ���������� Bitmap
    function GetSkinIm_AsBitmap(const uri: PWideChar; group: PWideChar = nil): HBITMAP; stdcall;
    //���������� True ���� ����� ����������� ����
    function IsExistsSkinIm(const uri: PWideChar; group: PWideChar = nil): BOOL; stdcall;

    //������ � ��������� �������� ��������� �������� (������ ������ ����������� IAnimationTarget � ������� ���������� �������� ����� ���������)
    function AnimationStart(Image: TThinGraphicPointer; AniTarget: IAnimationTarget; TargetRect: TRect): LongInt; stdcall;
    function AnimationStop(var id: LongInt): BOOL; stdcall;
  end;
  pISkinDraw = ^ISkinDraw;

//******* QIP UTILS *******//

  IQIPUtils = interface
  ['{C5F7962B-BC48-454F-83AF-089DBC9D3985}']
    function NetUtils(): pIQIPNetwork; safecall;
    function AppClosing(): BOOL; safecall;

    function AddSkinModule(const FileName: PWideChar): BOOL; safecall;
    function DelSkinModule(const FileName: PWideChar): BOOL; safecall;
    function Draw : pISkinDraw; safecall;

    function CreateIString(): IString; safecall;
    function CreateIStringList(): IStringList; safecall;
    function StringsGen(): pIStringsGen; safecall;

    function CreateDialogs(): IDialogs; safecall;
  end;
  pIQIPUtils = ^IQIPUtils;

const
  nilTConnectSet: TConnectSet = ();

implementation

end.
