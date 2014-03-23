type
  TPopupExPluginExtender = class(TCustomBaseQipPlugin)
  private
	  pexConnected: Boolean;
    pexInfo: TPluginInfo;
    FFades: TList;
  protected
    procedure DeleteFade(index: Integer; bCloseFade: Boolean = true);
    function IndexOfFade(const FadeID: Integer): Integer;
  	function pexConnect(): Boolean;
  public
    property Fades: TList read FFades;
    
    function ShowFade(const FadeInfo: TFadeWndInfo): Integer; overload;
    function ShowFade(const AFadeTitle, AFadeText: WideString; const AFadeIcon: HICON;
                      const AFadeType: Integer = 0; const ATextCentered: Boolean = False;
                      const ANoAutoClose: Boolean = False): Integer; overload;
    function ShowFade(const APEXFlags: DWORD; const FadeInfo: TFadeWndInfo; const AProtoHandle: Integer; const AAccName: WideString): Integer; overload;
    function ShowFade(const APEXFlags: DWORD; const AFadeTitle, AFadeText: WideString; const AFadeIcon: HICON;
                      const AFadeType: Integer; const ATextCentered: Boolean;
                      const ANoAutoClose: Boolean;
                      const AProtoHandle: Integer; 
                      const AAccName: WideString): Integer; overload;

    function CloseFade(const FadeID: Integer): Boolean;

    function pexFadeClicked(const pme: pPEXMouseEvent; const FadeIndex: Integer): Integer; virtual;
    procedure PluginMessageReceived(var LParam, NParam, AResult: Integer); override;
    procedure EnumPluginsCallback(const EnumInfo: TPluginInfo; const PluginEnabled, IsLastEnumPlugin: Boolean); override;

    procedure InitPlugin; override;
    procedure FinalPlugin; override;

    function VarSendMessageToPlugin(const PluginHandle: Integer; var LParam, NParam: Integer): Integer;
    constructor Create(const PluginService: IQIPPluginService);
  end;
