{*************************************}
{                                     }
{       Base plugin class             }
{       Copyright © Sega-Zero         }
{       Sega-Zero@qip.ru              }
{       http://www.qip.ru             }
{  http://wiki.qip.ru/TBaseQipPlugin  }
{                                     }
{*************************************}
unit u_BasePlugin;

interface

{$I sdk_defines.inc}

uses
  Windows, Messages, Consts, SysUtils, {$IFNDEF NOGRAPHICS}Graphics, {$ENDIF} Classes,
  u_plugin_info, u_plugin_msg, u_common, {$IFDEF USEPOPUPEX}u_PopupEx, {$ENDIF}
  u_gui_const, u_gui_intf, u_public_intf, u_gui_graphics, u_gui_events, u_gui_helpers;

type
{$IFDEF NOGRAPHICS}
  TColor = Integer;
{$ENDIF}
	TChatAction = (caClose, caOpen, caActivate);
  TMenuItemsArray = array of TPluginMenuItem;

  TFadeList = class;

  TCustomBaseQipPlugin = class(TInterfacedObject, IQIPPlugin, ICLSnapshot, IPluginHistory)
  private
    FPluginSvc  : IQIPPluginService;
    FPluginInfo : TPluginInfo;
    FOptions    : TPluginSpecific;
    FCoreMinVer: Integer;
    FCoreMajVer: Integer;
    FLanguage: WideString;
    FEnabled: Boolean;
    
    FUpdatedText: WideString;
    FStatus: Integer;
    FPrivacy: Integer;
    FHist: IQIPHistory;
    FFullPluginPath: WideString;
    FFilter: WideString;

    FMenuItems: array of TPluginMenuItem;
    FFades: TFadeList;
    FABossed: Boolean;

    FWidgets: TInterfaceList;
    FWidgetIDCounter: Integer;

    FCoreGUI: IQIPCoreGUI;
    FCoreUtils: IQIPUtils;
    
    //main plugin messages
    procedure OnLoadSuccess(var Message: TPluginMessage);   message PM_PLUGIN_LOAD_SUCCESS;
    procedure OnPluginRun(var Message: TPluginMessage);     message PM_PLUGIN_RUN;
    procedure OnPluginQuit(var Message: TPluginMessage);    message PM_PLUGIN_QUIT;
    procedure OnPluginEnable(var Message: TPluginMessage);  message PM_PLUGIN_ENABLE;
    procedure OnPluginDisable(var Message: TPluginMessage); message PM_PLUGIN_DISABLE;
    procedure OnPluginOptions(var Message: TPluginMessage); message PM_PLUGIN_OPTIONS;

    //msgs for plug-in
    procedure OnWrongSdkVer(var Message: TPluginMessage);   message PM_PLUGIN_WRONG_SDK_VER;
    procedure OnCurrentLang(var Message: TPluginMessage);   message PM_PLUGIN_CURRENT_LANG;
    procedure OnAntiBoss(var Message: TPluginMessage);      message PM_PLUGIN_ANTIBOSS;
    procedure OnStatusChanged(var Message: TPluginMessage); message PM_PLUGIN_STATUS_CHANGED;
    procedure OnFadeClick(var Message: TPluginMessage);     message PM_PLUGIN_FADE_CLICK;
    procedure OnEnumInfo(var Message: TPluginMessage);      message PM_PLUGIN_ENUM_INFO;

    procedure OnSpellCheck(var Message: TPluginMessage); message PM_PLUGIN_SPELL_CHECK;
    procedure OnSpellPopup(var Message: TPluginMessage); message PM_PLUGIN_SPELL_POPUP;

    procedure OnXStatusChanged(var Message: TPluginMessage); message PM_PLUGIN_XSTATUS_CHANGED;
    procedure OnSoundChanged(var Message: TPluginMessage);   message PM_PLUGIN_SOUND_CHANGED;

    procedure OnMsgRcvd(var Message: TPluginMessage);     message PM_PLUGIN_MSG_RCVD;
    procedure OnMsgSend(var Message: TPluginMessage);     message PM_PLUGIN_MSG_SEND;
    procedure OnMsgRcvdIM(var Message: TPluginMessage);   message PM_PLUGIN_RCVD_IM;
    procedure OnMsgRcvdNew(var Message: TPluginMessage);  message PM_PLUGIN_MSG_RCVD_NEW;
    procedure OnMsgRcvdRead(var Message: TPluginMessage); message PM_PLUGIN_MSG_RCVD_READ;

    procedure OnChatMsgRcvd(var Message: TPluginMessage); message PM_PLUGIN_CHAT_MSG_RCVD;//obsolete since 1.8.5
    procedure OnChatMsgRcvdNew(var Message: TPluginMessage); message PM_PLUGIN_CHAT_MSG_RCVDNEW; //PM_PLUGIN_CHAT_MSG_RCVD is obsolete since 1.8.5
    procedure OnChatMsgSend(var Message: TPluginMessage); message PM_PLUGIN_CHAT_SENDING;

    procedure OnCanAddBtns(var Message: TPluginMessage);      message PM_PLUGIN_CAN_ADD_BTNS;
    procedure OnMsgBtnClick(var Message: TPluginMessage);     message PM_PLUGIN_MSG_BTN_CLICK;
    procedure OnChatCanAddBtns(var Message: TPluginMessage);  message PM_PLUGIN_CHAT_CAN_BTNS;
    procedure OnChatMsgBtnClick(var Message: TPluginMessage); message PM_PLUGIN_CHAT_BTN_CLICK;

    procedure OnContactStatus(var Message: TPluginMessage); message PM_PLUGIN_CONTACT_STATUS;
    procedure OnChatTab(var Message: TPluginMessage);       message PM_PLUGIN_CHAT_TAB;
    procedure OnSpecRcvd(var Message: TPluginMessage);      message PM_PLUGIN_SPEC_RCVD;

    procedure OnDrawSpecContact(var Message: TPluginMessage);     message PM_PLUGIN_SPEC_DRAW_CNT;
    procedure OnSpecContactDblClk(var Message: TPluginMessage);   message PM_PLUGIN_SPEC_DBL_CLICK;
    procedure OnSpecContactRightClk(var Message: TPluginMessage); message PM_PLUGIN_SPEC_RIGHT_CLK;
    procedure OnGetHintWH(var Message: TPluginMessage);           message PM_PLUGIN_HINT_GET_WH;
    procedure OnDrawHint(var Message: TPluginMessage);            message PM_PLUGIN_HINT_DRAW;

    procedure OnBroadcast(var Message: TPluginMessage); message PM_PLUGIN_BROADCAST;
    procedure OnPluginMsg(var Message: TPluginMessage); message PM_PLUGIN_MESSAGE;
    procedure OnDragStart(var Message: TPluginMessage); message PM_PLUGIN_SPEC_DRAG_START;
    procedure OnDragEnd(var Message: TPluginMessage);   message PM_PLUGIN_SPEC_DRAG_END;
    procedure OnCLChanged(var Message: TPluginMessage); message PM_PLUGIN_CL_CHANGED;

    procedure OnNotifBtnClick(var Message: TPluginMessage);    message PM_PLUGIN_NOTIF_BTN_CLICK;
    procedure OnGetHistInterface(var Message: TPluginMessage); message PM_PLUGIN_GET_PLUGHIST;
    procedure OnCoreSvcFade(var Message: TPluginMessage);      message PM_PLUGIN_CORE_SVC_FADE;
    procedure OnDetailsChanged(var Message: TPluginMessage);   message PM_PLUGIN_DETAILS_CHANGED;

    procedure OnChatTabActivated(var Message: TPluginMessage);   message PM_PLUGIN_CTAB_ACTIVATED;
    procedure OnCLFilterChanged(var Message: TPluginMessage);    message PM_PLUGIN_CL_FILTERED;

    procedure OnWantSendFiles(var Message: TPluginMessage);    message PM_PLUGIN_WANT_SEND_FILES;
    procedure OnAcceptFiles(var Message: TPluginMessage);      message PM_PLUGIN_FILE_ACCEPT;

    procedure OnWantAddMenuItems(var Message: TPluginMessage); message PM_PLUGIN_ADD_MENU_ITEMS;
    procedure OnMenuItemClick(var Message: TPluginMessage);    message PM_PLUGIN_MENU_ITEM_CLICK;

    procedure OnWantAddCLMenuItems(var Message: TPluginMessage); message PM_PLUGIN_ADD_CL_MENU_ITEMS;
    procedure OnCLMenuItemClick(var Message: TPluginMessage);    message PM_PLUGIN_CL_MENU_ITEM_CLICK;

    procedure OnTabCreated(var Message: TPluginMessage); message PM_PLUGIN_TAB_CREATED;
    procedure OnUrlClick(var Message: TPluginMessage); message PM_PLUGIN_URL_CLICK;

    procedure OnReadyForItem(var Message: TPluginMessage); message PM_PLUGIN_READY_FOR_WIDGET;
    procedure OnGetPluginHint(var Message: TPluginMessage); message PM_PLUGIN_HINT_GET_BB;
  protected
    {+++ IQIPPlugin interface funcs. Qip Core will use it to get info and send messages +++}
    function  GetPluginInfo: pPluginInfo; stdcall;
    procedure OnQipMessage(var PlugMsg: TPluginMessage); stdcall;
    procedure ExceptionHandler(const E: Exception; const MessageID: WideString = ''); virtual;
    function  SendPluginMessage(const AMsg: DWord; AWParam, ALParam, ANParam: Integer): Integer; overload;
    function  SendPluginMessage(const AMsg: DWord; AWParam, ALParam, ANParam, AResult: Integer): Integer; overload;
    function  VarSendPluginMessage(const AMsg: DWord; var AWParam, ALParam, ANParam): Integer; overload;
    function  VarSendPluginMessage(const AMsg: DWord; var AWParam, ALParam, ANParam, AResult): Integer; overload;
    {$IFDEF LOGDEBUGINFO}
    procedure LogSafe(const LogMessage: WideString);
    procedure Log(const LogMessage: WideString); virtual;
    procedure LogFmt(const LogMessageFmtStr: WideString; Args: array of const); virtual;
    {$ENDIF}
    {+++ ICLSnapchot interface proc +++}
    function AddElement(const Contact: pSnapshotElement): HResult; stdcall;
    function AddProto(const Proto: pProtoSnapshotElement): HResult; stdcall;
    {+++ IPluginHistory interface procs +++}
    function  HasHistory: Boolean; stdcall;
    procedure LoadHist(NodeID: WideString; IsMeta: Boolean); stdcall;
    procedure GetHistInfo(NodeID: WideString; var TimeFmtStr: WideString; var NickBeforeTime, BreakBeforeMsg, HideMsgSeparators: Boolean); stdcall;
    function  NodeIDFromMeta(AMeta: IMetaContact): WideString; stdcall;
    function  NodeIDFromAccName(AccountName: WideString; ProtoHandle: Integer; AMeta: IMetaContact; MetaHasNode: Boolean): WideString; stdcall;
    function  AccNodeIcon(NodeID: WideString): HICON; stdcall;
    procedure RefreshNodes(Filter: WideString); stdcall;
    procedure ExpandNode(NodeID, Filter: WideString); stdcall;
    function  DeleteHist(NodeID: WideString): Boolean; stdcall;
    function  HistFile(NodeID: WideString): WideString; stdcall;
    function  MenuCaption(NodeID: WideString): WideString; stdcall;

  public
    {+++ create/destroy +++++++++++++++++++++++}
    constructor Create(const PluginService: IQIPPluginService);
    destructor  Destroy; override;

    {+++ these ones are helper methods +++++++}
    //by default SDK_VER_MAJOR, SDK_VER_MINOR are the core sdk version
    procedure LoadSuccess(const SDK_VER_MAJOR, SDK_VER_MINOR: Cardinal); virtual;
    //fill PluginInfo structure here
    procedure GetPluginInformation(var VersionMajor, VersionMinor: Word;
                                   var PluginName, Creator, Description, Hint: PWideChar); virtual;
    //do your specific initialization here
    procedure InitPlugin; virtual;
    //do your specific finalization here
    procedure FinalPlugin; virtual;
    //this function should return the plugin icon handle
    function PluginIcon: HICON; virtual;
    //notifies the core language is changed
    procedure CoreLanguageChanged; virtual;
    //notifies the Anti-Boss switched on/off. Hide all the windows when true
    procedure AntiBossChanged(const SwitchedOn: Boolean); virtual;
    //notifies global status or privacy status has changed (use MainStatus and MainPrivacyLevel to compare with)
    procedure StatusChanged(const Status, PrivacyLevel: Integer); virtual;
    //notifies contact status has changed
    procedure ContactStatusChanged(const ProtoName, AccountName: WideString; const Status, XStatus, ProtoHandle: Integer); virtual;
    //notifies core activates chat tab
    procedure ChatTabChanged(const ChatName, ChatCaption, MyNickName: WideString; const ProtoHandle: Integer; const ChatAction: TChatAction); virtual;
    //notifies special plugin message came
    procedure GotSpecialMessage(const ProtoName, AccountName, SpecialText: WideString; const ProtoHandle: Integer); virtual;
    //notifies fade widow has been left-clicked
    procedure FadeClicked(const FadeID: Integer); virtual;
    //Enumeration request callback function
    procedure EnumPluginsCallback(const EnumInfo: TPluginInfo; const PluginEnabled, IsLastEnumPlugin: Boolean); virtual;
    //other plugin started broadcasting. You can stop broadcast to other plugins by setting Result := False
    function BroadcastReceived(var WParam, LParam, NParam, AResult: Integer): Boolean; virtual;
    //received the message from another plugin
    procedure PluginMessageReceived(SenderDllHandle: Integer; var LParam, NParam, AResult: Integer); virtual;
    //received when contact-list is changed
    procedure ContactListChanged; virtual;
    procedure ContactListFilterChanged; virtual;
    procedure MessageTabCreated(const ProtoHandle: Integer; const AccountName: WideString; TabActivated: Boolean); virtual;
    procedure URLClicked(const ProtoHandle: Integer; const AccountName, URLText: WideString); virtual;

    (* options routines *)
    procedure LoadOptions; virtual;
    procedure SaveOptions; virtual; //obsolete, use property Options := Value
    //procedure to be called when user clicks Settings button
    procedure OnOptions; virtual;

    (* spelling routines *)
    //should return True if misspelled. otherwise it should return False
    function SpellCheck(const AWord: WideString; var WordColor: TColor): Boolean; virtual;
    //should return True if the core has to ignore self context menu. otherwise it should return False
    //if you change AWord then SpellReplace will be called
    function SpellPopup(var AWord: WideString; const PopupPoint: TPoint): Boolean; virtual;
    //replaces current mispelled word with AWord. returns True if the word was succesfully replaced
    function SpellReplace(var AWord: WideString): Boolean; virtual;
    //procedure causes core to start re-check the spelling
    procedure SpellRecheck;

    (* X-status routines *)
    procedure XStatusChanged(const ActiveStatus: Integer; const StatusText, StatusDescription: WideString); virtual;
    procedure GetXStatus(var ActiveStatus: Integer; var StatusText, StatusDescription: WideString);
    procedure UpdateXStatus(const ActiveStatus: Integer = 0; const StatusText: WideString = ''; const StatusDescription: WideString = '');

    (* Sound routines *)
    procedure SoundChanged(const SoundOn: Boolean); virtual;
    function  IsSoundEnabled: Boolean;
    procedure SetSoundEnabled(const Enable: Boolean = True);

    (* Message handling routines *)
    //occurs before displaying message to user. Use ChangeMessageText to change the incoming text.
    //return False if the message should be blocked
    function MessageReceived(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString): Boolean; virtual;
    //this function is for replying
    procedure CanReply(const ProtoHandle, MessageType: Integer; const SenderAccount, Message: WideString); virtual;
    //occurs before sending message from user. Use ChangeMessageText to change the outgoing text.
    //return False if the message should be blocked
    function MessageSending(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString): Boolean; virtual;
    //notifies the message came, but not read
    procedure MessageFlash(const Account, NickName: WideString; const ProtoHandle: Integer); virtual;
    //notifies the message has been received and read by user
    procedure MessageRead(const Account, NickName: WideString; const ProtoHandle: Integer); virtual;
    //notifies the message from chat came
    procedure ChatMessageReceived(const ChatTextType: Cardinal; const ProtoHandle: Integer; const ChatName, NickName, Message: WideString); virtual;
    procedure ChatMessageReceived2(const ChatTextType: Cardinal; const ChatName: WideString; const ChatTextInfo: TChatTextInfo); virtual;
    //notifies chat message is about to send. change the value of  ChangedChatText to replace sending text.
    procedure ChatMessageSending(const ChatTextType: Cardinal; const ProtoHandle: Integer; const ChatName, NickName, Message: WideString; var ChangedChatText: WideString); virtual;

    (* Buttons handling *)
    //notifies the user has focused to another tab and the buttons under avatar should be added
    //use AddAvatarButton to add your buttons here
    procedure NeedAddButtons(const AccountName, ProtoName: WideString; const ProtoHandle: Integer = -1); virtual;
    //notifies the button has been clicked
    procedure ButtonClicked(const UniqueID, ProtoHandle: Integer; const AccountName, ProtoName: WideString; const BtnData: TBtnClick); virtual;
    //notifies the user has focused to another chat tab and the buttons should be added
    //use AddChatButton to add your buttons here
    procedure NeedAddChatButtons(const ChatName, ProtoName, ChatCaption: WideString; const ProtoHandle: Integer); virtual;
    //notifies the button has been clicked
    procedure ChatButtonClicked(const UniqueID, ProtoHandle: Integer; const ChatName, ProtoName: WideString; const BtnData: TBtnClick); virtual;

    (* Buttons routines *)
    //this function adds button under avatar. The result value is button's UniqueID
    function AddAvatarButton(const ButtonICO: HICON; const ButtonHint: WideString; const ButtonDataPtr: LongInt): Integer;
    //this function adds button in the chat tab. The result value is button's UniqueID
    function AddChatButton(const ButtonICO: HICON; const ButtonHint: WideString; const ButtonDataPtr: LongInt): Integer;

    (* Fake Contact routines *)
    //tries to add fake contact to CL. returns added contact UniqueID if successful, otherwise returns 0
    function AddFakeContact(const ContactHeight, UserDataAddr: Integer): Integer;
    //tries to delete fake contact with UniqueID form CL. returns true if successful
    function RemoveFakeContact(const UniqueID: Integer): Boolean;
    //forces core to draw fake contact
    procedure InvalidateFakeContact(const UniqueID: Integer);
    //this function should return True if fake contact can be dragged to desktop
    function AllowDragFakeContact(const UniqueID: Integer): Boolean; virtual;
    //this notification occurs when user drops a contact to desktop
    procedure FakeContactDropped(const UniqueID: Integer; ToDesktop: Boolean; DropPoint: TPoint); virtual;

    (* Fake contact handlers*)
    //occurs when fake contact shold be draw
    {$IFDEF NOGRAPHICS}
    procedure PaintContact(const DestCanvas: HDC; const ARect: TRect; const UniqueID, UserData: Integer); virtual;
    {$ELSE}
    procedure PaintContact(const DestCanvas: TCanvas; const ARect: TRect; const UniqueID, UserData: Integer); virtual;
    {$ENDIF}
    //occurs when user double-clicked on fake contact
    procedure OnFakeContactDblClk(const UniqueID, UserData: Integer); virtual;
    //occurs when user right-clicked on fake contact
    procedure OnFakeContactRightClick(const UniqueID, UserData: Integer; const PopupPoint: TPoint); virtual;
    //occurs when the core requests fake contact hint size
    procedure OnGetFakeContactHintSize(const UniqueID, UserData: Integer; var Width, Height: Integer); virtual;
    //occurs when the hint of fake contact should be redrawn
    {$IFDEF NOGRAPHICS}
    procedure PaintContactHint(const HintCanvas: HDC; const ARect: TRect; const UniqueID, UserData: Integer); virtual;
    {$ELSE}
    procedure PaintContactHint(const HintCanvas: TCanvas; const ARect: TRect; const UniqueID, UserData: Integer); virtual;
    {$ENDIF}
    //get bb-code for hint (return True for use bb-code hints)
    function OnGetBBCodeHint(var Hint: WideString; var ShowR: TRect; const UniqueID, UserData: Integer): BOOL; virtual;

    (*event and routines for message window items*)
    procedure MessageWindowReady; virtual;
    function  Widgets_Add(AWidget: IWidget): Boolean;
    function  Widgets_Delete(ID: TWidgetID): Boolean;
    procedure Widgets_Invalidate(ID: TWidgetID);
    procedure Widgets_InvalidateAll();
    function  Widgets_Get(ID: TWidgetID): IWidget;
    function  Widgets_ShowHint(): Boolean; //hot item only
    procedure Widgets_HideHint(); //hide all hints
    procedure Widgets_InvalidateHint(ID: TWidgetID);
    procedure Widgets_DoMouseLeave();
    procedure Widgets_Clear();
    function  Widgets_GetHotItem(): IWidget;

    (* Contact list enumeration *)
    procedure AddContact(AContact: TSnapshotElement; var Stop: Boolean); virtual;
    procedure AddEnumProto(AProto: TProtoSnapshotElement; var Stop: Boolean); virtual;

    (* Overlay Icons routines *)
    //returns true if successful
    function AddOverlayIcon(OI: TOverlayIcon; var UniqID: Integer): Boolean;
    function UpdateOverlayIcon(UniqID: Integer; OI: TOverlayIcon; RedrawContacts: Boolean = False): Boolean;
    function DeleteOverlayIcon(UniqID: Integer): Boolean;
    function SetIconForContact(const AccountName: WideString; ProtoHandle: Integer; UniqID: Integer): Boolean;

    (* Notification routines *)
    function AddIconToMsgImgList(Ico: HICON; Png: Integer = 0): Integer;
    function AddNotifMessage(AccountName: WideString; ProtoHandle: Integer; NI: TNotifInfo): Integer; overload;
    function AddNotifMessage(AccountName: WideString; ProtoHandle: Integer; MessageText: WideString; IconID: Integer = -1; IsIncomimg: Boolean = False): Integer; overload;
    //disables all buttons if BtnID = -1
    procedure DisableNotifButton(AccountName: WideString; ProtoHandle: Integer; NotifID: Integer; BtnID: Integer = -1);
    //return True if all buttons should be disable after click
    function OnNotifButtonClicked(NotifID: Integer; BtnID: Cardinal; BtnData: Integer): Boolean; virtual;

    (* IPluginHistory virtual wrapper methods *)
    function  InnerHasHistory: Boolean; virtual;
    procedure InnerLoadHist(NodeID: WideString; IsMeta: Boolean); virtual;
    procedure InnerGetHistInfo(NodeID: WideString; var TimeFmtStr: WideString;
                               var NickBeforeTime, BreakBeforeMsg, HideMsgSeparators: Boolean); virtual;
    function  InnerNodeIDFromMeta(AMeta: IMetaContact): WideString; virtual;
    function  InnerNodeIDFromAccName(AccountName: WideString; ProtoHandle: Integer; AMeta: IMetaContact = nil; MetaHasNode: Boolean = False): WideString; virtual;
    function  InnerAccNodeIcon(NodeID: WideString): HICON; virtual;
    procedure InnerRefreshNodes(Filter: WideString); virtual;
    procedure InnerExpandNode(NodeID, Filter: WideString); virtual;
    function  InnerDeleteHist(NodeID: WideString): Boolean; virtual;
    function  InnerHistFile(NodeID: WideString): WideString; virtual;
    function  InnerMenuCaption(NodeID: WideString): WideString; virtual;

    (* popup menu handling*)
    procedure AddMenuItems(const SelectedStr, SelectedURL: WideString; AddingToPicture: Boolean; var Items: TMenuItemsArray); virtual;
    procedure MenuItemClicked(const SelectedStr: WideString; const ItemID, ItemData: Integer; const PictureID: Integer = 0); virtual;
    procedure AddCLMenuItems(const MetaContact: IMetaContact; ToMessageWindow: Boolean; var Items: TMenuItemsArray); virtual;
    procedure CLMenuItemClicked(const MetaContact: IMetaContact; const ItemID, ItemData: Integer); virtual;

    //return True if you want to block core service fades
    procedure BlockCoreFade(FadeInfo: TFadeWndInfo; var Allow: LongBool); virtual;
    procedure DetailsChanged(const AccountName: WideString; ProtoHandle: Integer); virtual;

    (* other routines *)
    //returns LI_* string representation in current language
    function GetLanguageString(const LANG_ID: Integer): WideString;
    //show fade window. FadeType: 0 - message style, 1 - information style, 2 - warning style
    function ShowFade(const AFadeTitle, AFadeText: WideString; const AFadeIcon: HICON;
                      const AFadeType: Integer = 0; const ATextCentered: Boolean = False;
                      const ANoAutoClose: Boolean = False;
                      const AddToFadeList: Boolean = True;
                      const AdditionalData: Integer = 0): Integer; overload;
    function ShowFade(const FadeInfo: TFadeWndInfo; const AddToFadeList: Boolean = True; const AdditionalData: Integer = 0): Integer; overload;
    //closes fade window. returns True if fade closed successfully
    function CloseFade(const FadeID: Integer): Boolean;
    //retreives Display and Profile name
    procedure GetDisplayProfileNames(var DisplayName, ProfileName: WideString);
    //retreives global core status and privacy level. In case of fail, returns -1
    procedure GetGlobalStatusPrivacy(var Status, Privacy: Integer);
    //retreives global core status and privacy level as string (optionally an current language)
    procedure GetGlobalStatusPrivacyAsString(var Status, Privacy: WideString; const UseLang: Boolean = True);
    //sets global status, returns True if succesful
    function SetGlobalStatus(const Status: Integer): Boolean;
    //sets global privacy level, returns True if succesful
    function SetGlobalPrivacyLevel(const Privacy: Integer): Boolean;
    //tries to send IM, returns True if successfull
    function SendIM(const ProtoHandle: Integer; const ReceiverAccount, MessageText: WideString): Boolean;
    //tries to send your specific message, returns True if successful
    function SendSpecialMessage(const ProtoHandle: Integer; const ReceiverAccount, MessageText: WideString): Boolean;
    //tries to send a message to chat, returns True if succesfull
    function SendChatMessage(const ProtoHandle: Integer; const ChatName, MessageText: WideString): Boolean;
    //returns contact details
    function GetContactDetails(const ProtoHandle: Integer; const AccountName: WideString): TContactDetails;
    //set contact details
    function SetContactDetails(const ProtoHandle: Integer; const AccountName: WideString; DetailsUpd: TContactDetails): Boolean;
    //returns specified contact status
    function GetContactStatus(const ProtoHandle: Integer; const AccountName: WideString): Integer;
    //returns specified contact status
    procedure GetContactXStatus(const ProtoHandle: Integer; const AccountName: WideString; var StatusText, StatusDescription: WideString; var StatusPic: Integer);
    //tries to play core sound
    procedure PlaySound(const SoundID: Integer; const ForcePlaying: Boolean = False);
    //returns path to current user "plugins-data" directory (%PROFILEPATH%\Plugins)
    function GetPluginsDataDirectory: WideString;
    //Path to profile dir
    function GetQIPProfileDirectory: WideString;
    //returns global connection settings
    function GetGlobalNetParams: TNetParams;
    //gets global font and color settings. returns True if all data succesfully got
    function GetFontColorSettings(var FontName: WideString; var FontSize: Integer; var Colors: TQipColors): Boolean;
    //closes current infium instance
    procedure CloseInfium;
    //restarts current infium instance
    procedure RestartInfium;
    //finds plugin by its name. returns number of founded plugins
    function FindPlugin(const PluginName: WideString; var FoundInfo: TPluginInfo; var PluginEnabled: Boolean): Integer;
    //enumerates all plugins. results will be sent by core through EnumPluginsCallback
    procedure EnumeratePlugins;
    //broadcasts the message to all other plugins (see PM_PLUGIN_BROADCAST message description)
    procedure BroadcastMessage(const WParam, LParam, NParam, Result: Integer);
    //send message to plugin with DllHandle
    procedure SendMessageToPlugin(const PluginHandle, LParam, NParam, Result: Integer);
    procedure GetActiveTab(var AccountName: WideString; var ProtoHandle: Integer; var SubCount: Integer; FindFocused: Boolean = False); 
    procedure GetActiveChatTab(var ChatName, OwnNick, ChatCaption: WideString; var ProtoHandle: Integer);

    (* filesend routines*)
    procedure CoreWantSendFiles(const FileInfo: TDropFilesInfo; var BlockTransfer: LongBool); virtual;
    function AcceptFiles(const AccountName: WideString; const ProtoHandle: Integer; const FileInfo: TDropFilesInfo): Boolean; virtual;

    (* useful methods *)
    class function ConvertTime(const UnixTime: DWord): TDateTime;
    function StatusToStr(const Status: Integer; const UseLangStr: Boolean = True): WideString;
    function PrivacyLevelToStr(const Privacy: Integer; const UseLangStr: Boolean = True): WideString;
    function GetOptions: pPluginSpecific;
    procedure SetOptions(const Value: TPluginSpecific);
    function FullPluginPath: WideString;
    class function IsJabberChatAccount(const AccountName: WideString): Boolean;
    class function IsJabberPrivateChatAccount(const AccountName: WideString): Boolean;
    class function ExtractChatName(const PrivateName: WideString): WideString;
    class function ExtractPrivateNick(const ChatName: WideString): WideString;
    class function IsIRCChannel(const ChatName: WideString): Boolean;
    class function IsIRCPrivate(const ChatName: WideString): Boolean;
    class function GetSystemIcon(const IconID: PAnsiChar): HICON;
    //set any other protohandle to enumerate only the contacts of that proto
    procedure EnumerateCL(ProtocolHandle: Integer = 0);
    procedure EnumerateProtos;
    function  GetGraphHandle: THandle;
    //protohandles could be got from several messages, like PM_PLUGIN_MSG_RCVD_NEW
    function  OpenTab(AccountNameOrChatName: WideString; ProtoHandle: Integer): Boolean; overload;
    //try not to use this method :)
    function  OpenTab(AccountNameOrChatName: WideString; ProtoName: WideString): Boolean; overload;
    procedure ClearIncomingEvent(AccountName: WideString; ProtoHandle: Integer); overload;
    procedure ClearIncomingEvent(AccountName, ProtoName: WideString); overload;
    //returns True if contact belongs to Not In List group
    function IsAccountNIL(AccountName: WideString; ProtoHandle: Integer): Boolean; overload;
    function IsAccountNIL(AccountName, ProtoName: WideString): Boolean; overload;
    function GetMetaContact(AccountName: WideString; ProtoHandle: Integer): IMetaContact;
    function HistorySavePath: WideString;
    class function PatchFileName(const AFileName: WideString): WideString;
    class function Obsolete_IsChatWindowActive: Boolean;
    function SendFiles(AccountName: WideString; ProtoHandle: Integer; FileList: WideString;
                       ToChat: Boolean = False; TypeOfUpload: Integer = SFT_CORE_DECIDES): Boolean; overload;
    function SendFiles(FileInfo: TDropFilesInfo; TypeOfUpload: Integer = SFT_CORE_DECIDES): Boolean; overload;
    function GetRightsMask: Integer;
    procedure ControlMedia(const AccountName: WideString; const ProtoHandle, PictureID, ControlCommand: Integer);
    function SetProtoStatus(const ProtoHandle, Status: Integer; const PrivacyStatus: Integer = 0): Boolean;

    //core GUI and Utils
    function CoreGUI(): IQIPCoreGUI;
    function CoreUtils(): IQIPUtils;
    function GetSkinFN(): PWideChar;
    function GetSkinRes(ResID: WideString): WideString;
    procedure DrawSkinImage(ImageURI: WideString; DC: HDC; DrawRect: TRect);
    function CreateTimer(Interval: Integer; Enabled: Boolean; OnTimer: TGUINotifyEvent): ITimer;

    (* useful properies *)
    property Enabled: Boolean read FEnabled;
    property CoreSdkMajorVersion: Integer read FCoreMajVer;
    property CoreSdkMinorVersion: Integer read FCoreMinVer;
    property SoundEnabled: Boolean read IsSoundEnabled write SetSoundEnabled;
    property Options: TPluginSpecific read FOptions write SetOptions;
    property CoreLanguage: WideString read FLanguage;
    property MainStatus: Integer read FStatus;
    property MainPrivacyLevel: Integer read FPrivacy;
    property CoreHistory: IQIPHistory read FHist;
    property MyHandle: THandle read FPluginInfo.DllHandle;
    property CurrentCLFilter: WideString read FFilter;
    property FadeInfos: TFadeList read FFades;
    property AntiBossed: Boolean read FABossed;
    property Widgets: TInterfaceList read FWidgets;
  end;

  {$IFDEF USEPOPUPEX}
  {$I pex_class_def.inc}
  TBaseQipPlugin = class(TPopupExPluginExtender);
  {$ELSE}
  TBaseQipPlugin = class(TCustomBaseQipPlugin);
  {$ENDIF}

  TFadeList = class
  private
    FFadesInfo: array of TFadeWndInfo;
    FAdditional: array of Integer;
    FIds: array of Integer;
    function GetOffset(ID: Integer): Integer;
  protected
    procedure AddFade(const ID: Integer; FadeInfo: TFadeWndInfo; Additional: Integer);
    procedure KillFade(const ID: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function FadeInfoFromID(const ID: Integer): TFadeWndInfo;
    function AdditionalFromID(const ID: Integer): Integer;
  end;

  TWidgetItem = class(TInterfacedObject, IWidget)
  protected
    FID: WideString;
    FClass: TWidgetClass;
    FAllowedStates: TWidgetStateSet;
    FState: TWidgetStateSet;
    FOwner: TCustomBaseQipPlugin;
    procedure FreeOwner();

    function  GetPluginHandle(): Integer; safecall;
    function  GetID   (): TWidgetID; safecall;
    function  GetClass(): TWidgetClass; safecall;
    function  GetState(): TWidgetStateSet; safecall;
    procedure SetState(v: TWidgetStateSet); safecall;
  public
    procedure Click       (MousePt: TPoint); virtual; safecall;
    procedure DoubleClick (MousePt: TPoint); virtual; safecall;
    procedure MouseDown   (MousePt: TPoint; Button: TMouseButton; ShiftState: TShiftState); virtual; safecall;
    procedure MouseUp     (MousePt: TPoint; Button: TMouseButton; ShiftState: TShiftState); virtual; safecall;
    procedure MouseMove   (MousePt: TPoint; ShiftState: TShiftState); virtual; safecall;
    procedure MouseEnter  (); virtual; safecall;
    procedure MouseLeave  (); virtual; safecall;

    procedure Draw    (const DC: HDC; DrawRect: TRect; MousePt: TPoint); virtual; safecall;
    procedure DrawHint(const DC: HDC; DrawRect: TRect); virtual; safecall;

    function  StateAllowed(const CheckState: TWidgetState): Boolean; virtual; safecall;
    function  IsCompact(): Boolean; safecall;
    procedure GetHintInfo(const DC: HDC; var W,H: Integer; var HintPos: TWidgetHintPos); virtual; safecall;

    //properties
    property PluginHandle: Integer read GetPluginHandle; //readonly
    property ID          : TWidgetID read GetID; //readonly
    property WidgetClass : TWidgetClass read GetClass; //readonly
    property State       : TWidgetStateSet read GetState write SetState;
  public
    constructor Create(AOwner: TCustomBaseQipPlugin; AClass: TWidgetClass; AllowCompact: Boolean);
    destructor Destroy(); override;

    function ClientBounds(): TRect;
    function Bounds(): TRect;
    function IsHot(): Boolean;
    property Owner: TCustomBaseQipPlugin read FOwner;
  end;

const
  WM_SYNC = WM_USER + 1;

type
  TMainThreadSyncWnd = class
  private
    FHandle: HWND;
    FOnSync: TNotifyEvent;
  protected
    procedure SyncProc(var Msg: TMessage); message WM_SYNC;
    procedure WndProc(var Msg: TMessage); virtual;
  public
    constructor Create(AOnSync: TNotifyEvent);
    destructor Destroy(); override;
    procedure DefaultHandler(var Message); override;

    property OnSync: TNotifyEvent read FOnSync write FOnSync;
    property Handle: HWND read FHandle;
  end;

function QipPath: WideString;
procedure SetThreadName(szThreadName: AnsiString; threadId: dword = DWORD(-1));

{$IFDEF NOFORMS}
var
  OnException: TNotifyEvent = nil;
{$ENDIF}

implementation

uses
  {$IFNDEF NOFORMS}Forms, {$ENDIF}Types, u_lang_ids, DateUtils, StrUtils,
  {$IFDEF GEXPERTSDEBUG}DbugIntf, {$ENDIF}
  {$IFDEF USEPOPUPEX}Messages, {$ENDIF}
  u_string;

{$IF CompilerVersion <= 18.0}
{$I widecode.inc}
{$IFEND}

{$IFDEF USEPOPUPEX}
{$I pex_class.inc}
{$ENDIF}

{ TCustomBaseQipPlugin }

{***********************************************************}
constructor TCustomBaseQipPlugin.Create(const PluginService: IQIPPluginService);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('PluginService is about to create');
  if MainThreadID <> GetCurrentThreadId then
    LogSafe('warning! MainThreadID <> GetCurrentThreadId');
{$ENDIF}
  FCoreGUI   := nil;
  FCoreUtils := nil;

  FWidgetIDCounter := 0;
  FPluginSvc := PluginService;
  SetLength(FMenuItems, 0);
  FFades := TFadeList.Create;
  FABossed := False;
  FillChar(FPluginInfo, SizeOf(FPluginInfo), 0);
  with FPluginInfo do //force plugin info
    GetPluginInformation(PlugVerMajor, PlugVerMinor, PluginName, PluginAuthor,
                         PluginDescription, PluginHint);

  FWidgets := TInterfaceList.Create;
end;

{***********************************************************}
destructor TCustomBaseQipPlugin.Destroy;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('RefCount = 0, destroying plugin class');
{$ENDIF}
  Widgets_Clear();
  FreeAndNil(FWidgets);
  SetLength(FMenuItems, 0);
  FreeAndNil(FFades);

  if FCoreUtils <> nil then
    FCoreUtils.DelSkinModule(GetSkinFN);
  FCoreUtils := nil;
  FCoreGUI   := nil;
  FinalizeIStrings();
  inherited;
end;

{***********************************************************}
function TCustomBaseQipPlugin.GetPluginInfo: pPluginInfo;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('core requests plugin info');
{$ENDIF}
  Result := @FPluginInfo;
end;

{***********************************************************}
function PluginMessageToStr(const MessageID: Integer): WideString;
begin
  case MessageID of
    PM_PLUGIN_LOAD_SUCCESS:    Result := 'PM_PLUGIN_LOAD_SUCCESS';
    PM_PLUGIN_RUN:             Result := 'PM_PLUGIN_RUN';
    PM_PLUGIN_QUIT:            Result := 'PM_PLUGIN_QUIT';
    PM_PLUGIN_ENABLE:          Result := 'PM_PLUGIN_ENABLE';
    PM_PLUGIN_DISABLE:         Result := 'PM_PLUGIN_DISABLE';
    PM_PLUGIN_OPTIONS:         Result := 'PM_PLUGIN_OPTIONS';
    PM_PLUGIN_SPELL_CHECK:     Result := 'PM_PLUGIN_SPELL_CHECK';
    PM_PLUGIN_SPELL_POPUP:     Result := 'PM_PLUGIN_SPELL_POPUP';
    PM_PLUGIN_SPELL_REPLACE:   Result := 'PM_PLUGIN_SPELL_REPLACE';
    PM_PLUGIN_XSTATUS_UPD:     Result := 'PM_PLUGIN_XSTATUS_UPD';
    PM_PLUGIN_XSTATUS_GET:     Result := 'PM_PLUGIN_XSTATUS_GET';
    PM_PLUGIN_XSTATUS_CHANGED: Result := 'PM_PLUGIN_XSTATUS_CHANGED';
    PM_PLUGIN_SOUND_GET:       Result := 'PM_PLUGIN_SOUND_GET';
    PM_PLUGIN_SOUND_SET:       Result := 'PM_PLUGIN_SOUND_SET';
    PM_PLUGIN_SOUND_CHANGED:   Result := 'PM_PLUGIN_SOUND_CHANGED';
    PM_PLUGIN_MSG_RCVD:        Result := 'PM_PLUGIN_MSG_RCVD';
    PM_PLUGIN_MSG_SEND:        Result := 'PM_PLUGIN_MSG_SEND';
    PM_PLUGIN_SPELL_RECHECK:   Result := 'PM_PLUGIN_SPELL_RECHECK';
    PM_PLUGIN_MSG_RCVD_NEW:    Result := 'PM_PLUGIN_MSG_RCVD_NEW';
    PM_PLUGIN_MSG_RCVD_READ:   Result := 'PM_PLUGIN_MSG_RCVD_READ';
    PM_PLUGIN_WRONG_SDK_VER:   Result := 'PM_PLUGIN_WRONG_SDK_VER';
    PM_PLUGIN_CAN_ADD_BTNS:    Result := 'PM_PLUGIN_CAN_ADD_BTNS';
    PM_PLUGIN_ADD_BTN:         Result := 'PM_PLUGIN_ADD_BTN';
    PM_PLUGIN_MSG_BTN_CLICK:   Result := 'PM_PLUGIN_MSG_BTN_CLICK';
    PM_PLUGIN_SPEC_SEND:       Result := 'PM_PLUGIN_SPEC_SEND';
    PM_PLUGIN_SPEC_RCVD:       Result := 'PM_PLUGIN_SPEC_RCVD';
    PM_PLUGIN_ANTIBOSS:        Result := 'PM_PLUGIN_ANTIBOSS';
    PM_PLUGIN_CURRENT_LANG:    Result := 'PM_PLUGIN_CURRENT_LANG';
    PM_PLUGIN_GET_LANG_STR:    Result := 'PM_PLUGIN_GET_LANG_STR';
    PM_PLUGIN_FADE_MSG:        Result := 'PM_PLUGIN_FADE_MSG';
    PM_PLUGIN_GET_NAMES:       Result := 'PM_PLUGIN_GET_NAMES';
    PM_PLUGIN_STATUS_GET:      Result := 'PM_PLUGIN_STATUS_GET';
    PM_PLUGIN_STATUS_SET:      Result := 'PM_PLUGIN_STATUS_SET';
    PM_PLUGIN_STATUS_CHANGED:  Result := 'PM_PLUGIN_STATUS_CHANGED';
    PM_PLUGIN_RCVD_IM:         Result := 'PM_PLUGIN_RCVD_IM';
    PM_PLUGIN_SEND_IM:         Result := 'PM_PLUGIN_SEND_IM';
    PM_PLUGIN_CONTACT_STATUS:  Result := 'PM_PLUGIN_CONTACT_STATUS';
    PM_PLUGIN_DETAILS_GET:     Result := 'PM_PLUGIN_DETAILS_GET';
    PM_PLUGIN_CHAT_TAB:        Result := 'PM_PLUGIN_CHAT_TAB';
    PM_PLUGIN_CHAT_CAN_BTNS:   Result := 'PM_PLUGIN_CHAT_CAN_BTNS';
    PM_PLUGIN_CHAT_ADD_BTN:    Result := 'PM_PLUGIN_CHAT_ADD_BTN';
    PM_PLUGIN_CHAT_BTN_CLICK:  Result := 'PM_PLUGIN_CHAT_BTN_CLICK';
    PM_PLUGIN_CHAT_MSG_RCVD:   Result := 'PM_PLUGIN_CHAT_MSG_RCVD';
    PM_PLUGIN_CHAT_SENDING:    Result := 'PM_PLUGIN_CHAT_SENDING';
    PM_PLUGIN_CHAT_MSG_SEND:   Result := 'PM_PLUGIN_CHAT_MSG_SEND';
    PM_PLUGIN_PLAY_WAV_SND:    Result := 'PM_PLUGIN_PLAY_WAV_SND';
    PM_PLUGIN_SPEC_ADD_CNT:    Result := 'PM_PLUGIN_SPEC_ADD_CNT';
    PM_PLUGIN_SPEC_DEL_CNT:    Result := 'PM_PLUGIN_SPEC_DEL_CNT';
    PM_PLUGIN_SPEC_REDRAW:     Result := 'PM_PLUGIN_SPEC_REDRAW';
    PM_PLUGIN_SPEC_DRAW_CNT:   Result := 'PM_PLUGIN_SPEC_DRAW_CNT';
    PM_PLUGIN_SPEC_DBL_CLICK:  Result := 'PM_PLUGIN_SPEC_DBL_CLICK';
    PM_PLUGIN_SPEC_RIGHT_CLK:  Result := 'PM_PLUGIN_SPEC_RIGHT_CLK';
    PM_PLUGIN_FADE_CLICK:      Result := 'PM_PLUGIN_FADE_CLICK';
    PM_PLUGIN_FADE_CLOSE:      Result := 'PM_PLUGIN_FADE_CLOSE';
    PM_PLUGIN_GET_PROFILE_DIR: Result := 'PM_PLUGIN_GET_PROFILE_DIR';
    PM_PLUGIN_GET_COLORS_FONT: Result := 'PM_PLUGIN_GET_COLORS_FONT';
    PM_PLUGIN_HINT_GET_WH:     Result := 'PM_PLUGIN_HINT_GET_WH';
    PM_PLUGIN_HINT_DRAW:       Result := 'PM_PLUGIN_HINT_DRAW';
    PM_PLUGIN_GET_CONTACT_ST:  Result := 'PM_PLUGIN_GET_CONTACT_ST';
    PM_PLUGIN_INFIUM_CLOSE:    Result := 'PM_PLUGIN_INFIUM_CLOSE';
    PM_PLUGIN_GET_NET_SET:     Result := 'PM_PLUGIN_GET_NET_SET';
    PM_PLUGIN_BROADCAST:       Result := 'PM_PLUGIN_BROADCAST';
    PM_PLUGIN_FIND:            Result := 'PM_PLUGIN_FIND';
    PM_PLUGIN_MESSAGE:         Result := 'PM_PLUGIN_MESSAGE';
    PM_PLUGIN_ENUM_PLUGINS:    Result := 'PM_PLUGIN_ENUM_PLUGINS';
    PM_PLUGIN_ENUM_INFO:       Result := 'PM_PLUGIN_ENUM_INFO';
    PM_PLUGIN_SPEC_DRAG_START: Result := 'PM_PLUGIN_SPEC_DRAG_START';
    PM_PLUGIN_SPEC_DRAG_END:   Result := 'PM_PLUGIN_SPEC_DRAG_END';
    PM_PLUGIN_IS_ACC_IN_NIL:   Result := 'PM_PLUGIN_IS_ACC_IN_NIL';
    PM_PLUGIN_GET_CL_SNAPSHOT: Result := 'PM_PLUGIN_GET_CL_SNAPSHOT';
    PM_PLUGIN_CL_CHANGED:      Result := 'PM_PLUGIN_CL_CHANGED';
    PM_PLUGIN_OPEN_FOCUS_TAB:  Result := 'PM_PLUGIN_OPEN_FOCUS_TAB';
    PM_PLUGIN_CLEAR_EVENT:     Result := 'PM_PLUGIN_CLEAR_EVENT';
    PM_PLUGIN_GET_SKIN_HANDLE: Result := 'PM_PLUGIN_GET_SKIN_HANDLE';
    PM_PLUGIN_ADD_OVERLAY_ICN: Result := 'PM_PLUGIN_ADD_OVERLAY_ICN';
    PM_PLUGIN_UPD_OVERLAY_ICN: Result := 'PM_PLUGIN_UPD_OVERLAY_ICN';
    PM_PLUGIN_DEL_OVERLAY_ICN: Result := 'PM_PLUGIN_DEL_OVERLAY_ICN';
    PM_PLUGIN_SET_OVERLAY_ICN: Result := 'PM_PLUGIN_SET_OVERLAY_ICN';
    PM_PLUGIN_GET_META_CONT:   Result := 'PM_PLUGIN_GET_META_CONT';
    PM_PLUGIN_PROTOS_SNAPSHOT: Result := 'PM_PLUGIN_PROTOS_SNAPSHOT';
    PM_PLUGIN_SET_DETAILS:     Result := 'PM_PLUGIN_SET_DETAILS';
    PM_PLUGIN_NOTIF_ADD_ICON:  Result := 'PM_PLUGIN_NOTIF_ADD_ICON';
    PM_PLUGIN_NOTIF_SEND_CHAT: Result := 'PM_PLUGIN_NOTIF_SEND_CHAT';
    PM_PLUGIN_NOTIF_BTN_CLICK: Result := 'PM_PLUGIN_NOTIF_BTN_CLICK';
    PM_PLUGIN_NOTIF_BTN_DISBL: Result := 'PM_PLUGIN_NOTIF_BTN_DISBL';
    PM_PLUGIN_ACTIVE_MSG_TAB:  Result := 'PM_PLUGIN_ACTIVE_MSG_TAB';
    PM_PLUGIN_ACTIVE_CHAT_TAB: Result := 'PM_PLUGIN_ACTIVE_CHAT_TAB';
    PM_PLUGIN_IS_META_MODE:    Result := 'PM_PLUGIN_IS_META_MODE';
    PM_PLUGIN_GET_QIPHIST:     Result := 'PM_PLUGIN_GET_QIPHIST';
    PM_PLUGIN_GET_PLUGHIST:    Result := 'PM_PLUGIN_GET_PLUGHIST';
    PM_PLUGIN_CORE_SVC_FADE:   Result := 'PM_PLUGIN_CORE_SVC_FADE';
    PM_PLUGIN_DETAILS_CHANGED: Result := 'PM_PLUGIN_DETAILS_CHANGED';
    PM_PLUGIN_GET_PROTO_ST:    Result := 'PM_PLUGIN_GET_PROTO_ST';
    PM_PLUGIN_PROTO_ST_CHANGED:Result := 'PM_PLUGIN_PROTO_ST_CHANGED';
    PM_PLUGIN_GET_CONT_XST:    Result := 'PM_PLUGIN_GET_CONT_XST';
    PM_PLUGIN_CONT_XST_CHANGE: Result := 'PM_PLUGIN_CONT_XST_CHANGE';
    PM_PLUGIN_CL_FILTERED:     Result := 'PM_PLUGIN_CL_FILTERED';
    PM_PLUGIN_CHAT_MSG_RCVDNEW:Result := 'PM_PLUGIN_CHAT_MSG_RCVDNEW';
    PM_PLUGIN_CTAB_ACTIVATED:  Result := 'PM_PLUGIN_CTAB_ACTIVATED';
    PM_PLUGIN_WANT_SEND_FILES: Result := 'PM_PLUGIN_WANT_SEND_FILES';
    PM_PLUGIN_FILE_ACCEPT:     Result := 'PM_PLUGIN_FILE_ACCEPT';
    PM_PLUGIN_GET_RIGHTS_MASK: Result := 'PM_PLUGIN_GET_RIGHTS_MASK';
    PM_PLUGIN_ADD_MENU_ITEMS:  Result := 'PM_PLUGIN_ADD_MENU_ITEMS';
    PM_PLUGIN_MENU_ITEM_CLICK: Result := 'PM_PLUGIN_MENU_ITEM_CLICK';

    PM_PLUGIN_ADD_CL_MENU_ITEMS  : Result := 'PM_PLUGIN_ADD_CL_MENU_ITEMS';
    PM_PLUGIN_CL_MENU_ITEM_CLICK : Result := 'PM_PLUGIN_CL_MENU_ITEM_CLICK';
    PM_PLUGIN_TAB_CREATED        : Result := 'PM_PLUGIN_TAB_CREATED';
    PM_PLUGIN_URL_CLICK          : Result := 'PM_PLUGIN_URL_CLICK';
    PM_PLUGIN_READY_FOR_WIDGET   : Result := 'PM_PLUGIN_READY_FOR_WIDGET';
    PM_PLUGIN_HINT_GET_BB        : Result := 'PM_PLUGIN_HINT_GET_BB';
  end;
end;

procedure TCustomBaseQipPlugin.OnQipMessage(var PlugMsg: TPluginMessage);
begin
   try
     {$IFDEF LOGDEBUGINFO}
     with PlugMsg do
     begin
       LogFmt('%s (%d) came to plugin', [PluginMessageToStr(Msg), Msg]);
       {$IFDEF LOGLOWLEVELINFO}
       LogFmt('Message content: WParam %d($%.8x), LParam %d($%.8x), NParam %d($%.8x), Result %d($%.8x)',
              [WParam, WParam, LParam, LParam, NParam, NParam, Result, Result]);
       {$ENDIF}
     end;
     {$ENDIF}
     Dispatch(PlugMsg);
   except
     on E: Exception do
       ExceptionHandler(E, PluginMessageToStr(PlugMsg.Msg));
   end;
end;

{***********************************************************}
procedure TCustomBaseQipPlugin.LoadSuccess(const SDK_VER_MAJOR, SDK_VER_MINOR: Cardinal);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Entering LoadSuccess, SDK: %d.%d', [SDK_VER_MAJOR, SDK_VER_MINOR]);
{$ENDIF}
  FFullPluginPath     := FullPluginPath;
  FPluginInfo.DllPath := PWideChar(FFullPluginPath);

  FCoreMajVer := SDK_VER_MAJOR;
  FCoreMinVer := SDK_VER_MINOR;

  FPluginInfo.QipSdkVerMajor := QIP_SDK_VER_MAJOR;
  FPluginInfo.QipSdkVerMinor := QIP_SDK_VER_MINOR;
  with FPluginInfo do
    GetPluginInformation(PlugVerMajor, PlugVerMinor, PluginName, PluginAuthor,
                         PluginDescription, PluginHint);
  FPluginInfo.PluginIcon := PluginIcon;
{$IFDEF LOGDEBUGINFO}
  LogSafe('PluginInfo params set:');
  with FPluginInfo do
  begin
    LogFmt('Path: %s', [DllPath]);
    LogFmt('plugin version: %d.%d', [PlugVerMajor, PlugVerMinor]);
    LogFmt('Icon: %d', [PluginIcon]);
    LogFmt('name: %s', [PluginName]);
    LogFmt('Author: %s', [PluginAuthor]);
    LogFmt('Description: %s', [PluginDescription]);
    LogFmt('Hint: %s', [PluginHint]);
  end;
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.GetPluginInformation(var VersionMajor, VersionMinor: Word;
  var PluginName, Creator, Description, Hint: PWideChar);
begin
//nothing by default
end;

procedure TCustomBaseQipPlugin.ExceptionHandler(const E: Exception; const MessageID: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  if MessageID > '' then
    LogFmt('Exception occurs during message (%s) handling (%s)', [MessageID, E.Message])
  else
    LogFmt('Exception occurs during message handling (%s)', [E.Message]);
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.OnLoadSuccess(var Message: TPluginMessage);
begin
  LoadSuccess(Message.WParam, Message.LParam);
end;

procedure TCustomBaseQipPlugin.OnPluginRun(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('core is ready, run plugin');
{$ENDIF}
  FEnabled := True;

  InitPlugin;
  LoadOptions;
end;

procedure TCustomBaseQipPlugin.OnPluginQuit(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('core unloads plugin, quit');
{$ENDIF}
  if FEnabled then
    FinalPlugin;
end;

procedure TCustomBaseQipPlugin.OnPluginDisable(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('core disables plugin');
{$ENDIF}
  FEnabled := False;
  FinalPlugin;
end;

procedure TCustomBaseQipPlugin.OnPluginEnable(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('core enables plugin');
{$ENDIF}
  FEnabled := True;
  InitPlugin;
  LoadOptions;
end;
    
procedure TCustomBaseQipPlugin.OnMsgRcvd(var Message: TPluginMessage);
var
  aQipMsg: pQipMsgPlugin;
  Rslt: BOOL;
begin
  {Getting record pointer of instant message}
  aQipMsg := pQipMsgPlugin(Message.WParam);

  if (aQipMsg <> nil) and Boolean(Message.Result) then
  begin
    FUpdatedText := aQipMsg^.MsgText;

    //if msg not already blocked (22.02.2012 plugins chain)
    if not aQipMsg^.Blocked and (Message.Result <> 0) then
    begin
      Rslt := MessageReceived(aQipMsg^, FUpdatedText);
      Message.Result := Integer(Rslt);

      if (FUpdatedText <> '') and not WideSameStr(FUpdatedText, aQipMsg^.MsgText) then
      begin
        {$IFDEF LOGDEBUGINFO}
        LogFmt('changed original text from %s to %s', [aQipMsg^.MsgText, FUpdatedText]);
        {$ENDIF}
        Message.LParam := LongInt(PWideChar(FUpdatedText));
      end;
    end //if blocked
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('message already blocked');
    {$ENDIF};
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('cannot retrieve message structure');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnMsgRcvdIM(var Message: TPluginMessage);
begin
  with Message do
  if (LParam <> 0) and (NParam <> 0) then
    CanReply(WParam, Result, PWideChar(LParam), PWideChar(NParam))
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data for reply');
{$ENDIF};
end;

function ChatTextTypeToStr(const AType: Integer): WideString;
begin
  case AType of
    CHAT_TEXT_TOPIC:        Result := 'CHAT_TEXT_TOPIC';
    CHAT_TEXT_OWN_MESSAGE:  Result := 'CHAT_TEXT_OWN_MESSAGE';
    CHAT_TEXT_MESSAGE:      Result := 'CHAT_TEXT_MESSAGE';
    CHAT_TEXT_JOINED:       Result := 'CHAT_TEXT_JOINED';
    CHAT_TEXT_QUIT:         Result := 'CHAT_TEXT_QUIT';
    CHAT_TEXT_DISCONNECTED: Result := 'CHAT_TEXT_DISCONNECTED';
    CHAT_TEXT_NOTIFICATION: Result := 'CHAT_TEXT_NOTIFICATION';
    CHAT_TEXT_HIGHLIGHTED:  Result := 'CHAT_TEXT_HIGHLIGHTED';
    CHAT_TEXT_INFORMATION:  Result := 'CHAT_TEXT_INFORMATION';
    CHAT_TEXT_ACTION:       Result := 'CHAT_TEXT_ACTION';
    CHAT_TEXT_KICKED:       Result := 'CHAT_TEXT_KICKED';
    CHAT_TEXT_MODE:         Result := 'CHAT_TEXT_MODE';
  end;
end;

procedure TCustomBaseQipPlugin.OnChatMsgRcvd(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (NParam <> 0) and (Result <> 0) then
    ChatMessageReceived(LParam, DllHandle, PWideChar(WParam), PWideChar(NParam), PWideChar(Result))
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in chat message');
{$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnChatMsgRcvdNew(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (NParam <> 0) then
    ChatMessageReceived2(LParam, PWideChar(WParam), pChatTextInfo(NParam)^)
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in chat message');
{$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnPluginOptions(var Message: TPluginMessage);
begin
  OnOptions;
end;

procedure TCustomBaseQipPlugin.InitPlugin;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('Initialize plugin data');
{$ENDIF}
  FHist := IQIPHistory(SendPluginMessage(PM_PLUGIN_GET_QIPHIST, 0, 0, 0));
end;

procedure TCustomBaseQipPlugin.FinalPlugin;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('Finalize plugin data');
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.LoadOptions;
var
  optns: pPluginSpecific;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('Loading Options');
{$ENDIF}
  optns := GetOptions;
  if optns <> nil then
    FOptions := optns^;
end;

procedure TCustomBaseQipPlugin.SaveOptions;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('Saving options');
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnWrongSdkVer(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('wrong sdk version');
{$ENDIF}
  with Message do
    MessageBoxW(0, PWideChar(WideFormat('Wrong SDK version. Core SDK ver. %d.%d',
                                        [WParam, LParam])),
                'Error', MB_ICONERROR or MB_OK or MB_TOPMOST or MB_TASKMODAL);
end;

procedure TCustomBaseQipPlugin.OnSpellCheck(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
    Result := LongInt(SpellCheck(PWideChar(WParam), TColor(LParam)))
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('cannot retrieve checking word');
{$ENDIF};
end;

function TCustomBaseQipPlugin.SpellCheck(const AWord: WideString;
  var WordColor: TColor): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core requests spell check of word %s with color %s',
         [AWord, {$IFDEF NOGRAPHICS}IntToHex(WordColor, 8){$ELSE}ColorToString(WordColor){$ENDIF}]);
{$ENDIF}
  Result := False;
end;

procedure TCustomBaseQipPlugin.OnSpellPopup(var Message: TPluginMessage);
var
  wStr: WideString;
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
  begin
    wStr := PWideChar(WParam);
    Result := LongInt(SpellPopup(wStr, PPoint(LParam)^));
    if not WideSameStr(wStr, PWideChar(WParam)) then
    {$IFDEF LOGDEBUGINFO}
    begin
      LogFmt('changing original spelling text from %s to %s', [PWideChar(WParam), wStr]);
    {$ENDIF}
      SpellReplace(wStr);
    {$IFDEF LOGDEBUGINFO}
    end;
    {$ENDIF}
  end
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('cannot retrieve misspelling word');
{$ENDIF};
end;

function TCustomBaseQipPlugin.SpellPopup(var AWord: WideString;
  const PopupPoint: TPoint): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  with PopupPoint do
    LogFmt('core requests spell popup on word %s at point %d.%d', [AWord, X, Y]);
{$ENDIF}
  Result := False;
end;

function TCustomBaseQipPlugin.SendPluginMessage(const AMsg: DWord; AWParam, ALParam,
  ANParam: Integer): Integer;
var
  PluginMsg: TPluginMessage;
begin
  with PluginMsg do
  begin
    Msg := AMsg;
    WParam := AWParam;
    LParam := ALParam;
    NParam := ANParam;
    DllHandle := FPluginInfo.DllHandle;
  end;
  FPluginSvc.OnPluginMessage(PluginMsg);
  Result := PluginMsg.Result;
  {$IFDEF LOGDEBUGINFO}
  {$IFDEF LOGLOWLEVELINFO}
  with PluginMsg do
    LogFmt('sending message to core: %s, WParam: %d($%.8x), LParam: %d($%.8x),' +
           'NParam: %d($%.8x). Result is %d($%.8x)',
           [PluginMessageToStr(AMsg), AWParam, AWParam, ALParam, ALParam,
            ANParam, ANParam, Result, Result]);
  {$ENDIF}
  {$ENDIF}
end;

function TCustomBaseQipPlugin.SendPluginMessage(const AMsg: DWord; AWParam,
  ALParam, ANParam, AResult: Integer): Integer;
var
  PluginMsg: TPluginMessage;
begin
  with PluginMsg do
  begin
    Msg := AMsg;
    WParam := AWParam;
    LParam := ALParam;
    NParam := ANParam;
    DllHandle := FPluginInfo.DllHandle;
  end;
  PluginMsg.Result := AResult;
  FPluginSvc.OnPluginMessage(PluginMsg);
  Result := PluginMsg.Result;
  {$IFDEF LOGDEBUGINFO}
  {$IFDEF LOGLOWLEVELINFO}
  with PluginMsg do
    LogFmt('sending message to core: %s, WParam: %d($%.8x), LParam: %d($%.8x),' +
           'NParam: %d($%.8x), old Result: %d($%.8x). new Result is %d($%.8x)',
           [PluginMessageToStr(AMsg), AWParam, AWParam, ALParam, ALParam,
            ANParam, ANParam, AResult, AResult, Result, Result]);
  {$ENDIF}
  {$ENDIF}
end;

function TCustomBaseQipPlugin.VarSendPluginMessage(const AMsg: DWord;
  var AWParam, ALParam, ANParam): Integer;
var Foo: Integer;
begin
  Result := VarSendPluginMessage(AMsg, AWParam, ALParam, ANParam, Foo);
end;

function TCustomBaseQipPlugin.VarSendPluginMessage(const AMsg: DWord; var AWParam,
  ALParam, ANParam, AResult): Integer;
var
  PluginMsg: TPluginMessage;
begin
  with PluginMsg do
  begin
    Msg := AMsg;
    WParam := Integer(AWParam);
    LParam := Integer(ALParam);
    NParam := Integer(ANParam);
    DllHandle := FPluginInfo.DllHandle;
    PluginMsg.Result := Integer(AResult);
  end;

  FPluginSvc.OnPluginMessage(PluginMsg);
  Result := PluginMsg.Result;
  {$IFDEF LOGDEBUGINFO}
  {$IFDEF LOGLOWLEVELINFO}
    LogFmt('sending message to core: %s, WParam: %d($%.8x), LParam: %d($%.8x),' +
           'NParam: %d($%.8x). Result is %d($%.8x)',
           [PluginMessageToStr(AMsg), Integer(AWParam), Integer(AWParam),
            Integer(ALParam), Integer(ALParam), Integer(ANParam), Integer(ANParam),
            Result, Result]);
    with PluginMsg do
    LogFmt('send params changed to: WParam: %d($%.8x), LParam: %d($%.8x),' +
           'NParam: %d($%.8x)',
           [WParam, WParam, LParam, LParam, NParam, NParam]);
  {$ENDIF}
  {$ENDIF}
  with PluginMsg do
  begin
    Integer(AWParam) := WParam;
    Integer(ALParam) := LParam;
    Integer(ANParam) := NParam;
  end;
end;

function TCustomBaseQipPlugin.SpellReplace(var AWord: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin requests spell replace on word %s', [AWord]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SPELL_REPLACE,
                                      LongInt(PWideChar(AWord)),
                                      0, 0));
end;

procedure TCustomBaseQipPlugin.SpellRecheck;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests spell rechecking');
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_SPELL_RECHECK, 0, 0, 0);
end;

procedure TCustomBaseQipPlugin.OnXStatusChanged(var Message: TPluginMessage);
begin
  with Message do
    XStatusChanged(WParam, PWideChar(LParam), PWideChar(NParam));
end;

procedure TCustomBaseQipPlugin.XStatusChanged(const ActiveStatus: Integer;
  const StatusText, StatusDescription: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core xstatus changed to %d (%s/%s)', [ActiveStatus, StatusText, StatusDescription]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.GetXStatus(var ActiveStatus: Integer;
  var StatusText, StatusDescription: WideString);
var
  wStatus, wDescription : LongInt;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests xstatus code,text and description');
{$ENDIF}
  StatusText := '';
  StatusDescription := '';
  VarSendPluginMessage(PM_PLUGIN_XSTATUS_GET, ActiveStatus, wStatus, wDescription);
  if wStatus <> 0 then
    StatusText := PWideChar(wStatus)
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('x-status text is empty')
{$ENDIF};
  if wDescription <> 0 then
    StatusDescription := PWideChar(wDescription)
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('x-status description is empty')
{$ENDIF};
end;

procedure TCustomBaseQipPlugin.UpdateXStatus(const ActiveStatus: Integer;
  const StatusText, StatusDescription: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests xstatus updating');
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_XSTATUS_UPD, ActiveStatus,
                    LongInt(PWideChar(StatusText)), LongInt(PWideChar(StatusDescription)));
end;

function TCustomBaseQipPlugin.PluginIcon: HICON;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('request to plugin main icon');
{$ENDIF}
  Result := LoadIconW(HInstance, 'MAINICON');
end;

procedure TCustomBaseQipPlugin.OnSoundChanged(var Message: TPluginMessage);
begin
  SoundChanged(Boolean(Message.WParam));
end;

procedure TCustomBaseQipPlugin.SoundChanged(const SoundOn: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('global sound mode changed. is switched on: %s',
         [BoolToStr(SoundOn, True)]);
{$ENDIF}
//nothing by default
end;

function TCustomBaseQipPlugin.IsSoundEnabled: Boolean;
var Foo: Integer;
begin
  VarSendPluginMessage(PM_PLUGIN_SOUND_GET, Result, Foo, Foo);
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin requests sound mode. result is %s', [BoolToStr(Result, True)]);
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.SetSoundEnabled(const Enable: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin sets sound mode to %s', [BoolToStr(Enable, True)]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_SOUND_SET, Integer(Enable), 0, 0)
end;

function TCustomBaseQipPlugin.MessageReceived(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('message received from %s. details:', [AMessage.SenderAcc]);
  with AMessage do
  begin
    LogFmt('MsgType: %d', [MsgType]);
    LogFmt('MsgTime: %s', [DateTimeToStr(UnixToDateTime(MsgTime))]);
    LogFmt('ProtoName: %s', [ProtoName]);
    LogFmt('SenderAcc: %s', [SenderAcc]);
    LogFmt('SenderNick: %s', [SenderNick]);
    LogFmt('RcvrAcc: %s', [RcvrAcc]);
    LogFmt('RcvrNick: %s', [RcvrNick]);
    LogFmt('MsgText: %s', [MsgText]);
  end;
{$ENDIF}
  ChangeMessageText := '';
  Result := True;
end;

procedure TCustomBaseQipPlugin.CanReply(const ProtoHandle, MessageType: Integer;
  const SenderAccount, Message: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('message finally received from %s and can be replied. details:', [SenderAccount]);
  LogFmt('MsgType: %d', [MessageType]);
  LogFmt('ProtoHandle: %d', [ProtoHandle]);
  LogFmt('SenderAccount: %s', [SenderAccount]);
  LogFmt('MsgText: %s', [Message]);
{$ENDIF}
//nothing by default
end;


procedure TCustomBaseQipPlugin.ChatMessageReceived2(const ChatTextType: Cardinal;
  const ChatName: WideString; const ChatTextInfo: TChatTextInfo);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('ChatTextType: %d (%s)', [ChatTextType, ChatTextTypeToStr(ChatTextType)]);
  with ChatTextInfo do
  begin
    LogFmt('chat message received from %s. details:', [ChatName]);
    LogFmt('MsgType: %d',     [MsgType]);
    LogFmt('MsgTime: %d(%s)', [MsgTime, DateTimeToStr(UnixToDateTime(MsgTime))]);
    LogFmt('ChatName: %s',    [ChatName]);
    LogFmt('ChatCaption: %s', [ChatCaption]);
    LogFmt('ProtoAcc: %s',    [ProtoAcc]);
    LogFmt('ProtoDll: %d',    [ProtoDll]);
    LogFmt('NickName: %s',    [NickName]);
    LogFmt('MyNick: %s',      [MyNick]);
    LogFmt('MsgText: %s',     [MsgText]);
    LogFmt('IsPrivate: %s',   [BoolToStr(IsPrivate, True)]);
    LogFmt('IsSimple: %s',    [BoolToStr(IsPrivate, True)]);
    LogFmt('IsIRC: %s',       [BoolToStr(IsPrivate, True)]);
  end
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.ChatMessageReceived(const ChatTextType: Cardinal; const ProtoHandle: Integer; const ChatName, NickName, Message: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('chat message received from %s. details:', [ChatName]);
  LogFmt('ChatTextType: %d (%s)', [ChatTextType, ChatTextTypeToStr(ChatTextType)]);
  LogFmt('ProtoHandle: %d', [ProtoHandle]);
  LogFmt('NickName: %s', [NickName]);
  LogFmt('Message: %s', [Message]);
  LogFmt('Is PrivateChat? %s', [BoolToStr(IsJabberPrivateChatAccount(ChatName), True)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.MessageRead(const Account, NickName: WideString; const ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('message from %s(%s)/%d has been read by user', [Account, NickName, ProtoHandle]);
{$ENDIF}
//nothing by default
end;

function TCustomBaseQipPlugin.MessageSending(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('user wants to send a message. details:');
  with AMessage do
  begin
    LogFmt('MsgType: %d', [MsgType]);
    LogFmt('MsgTime: %s', [DateTimeToStr(UnixToDateTime(MsgTime))]);
    LogFmt('ProtoName: %s', [ProtoName]);
    LogFmt('SenderAcc: %s', [SenderAcc]);
    LogFmt('SenderNick: %s', [SenderNick]);
    LogFmt('RcvrAcc: %s', [RcvrAcc]);
    LogFmt('RcvrNick: %s', [RcvrNick]);
    LogFmt('MsgText: %s', [MsgText]);
    LogFmt('Blocked: %s', [BoolToStr(Blocked, True)]);
    LogFmt('ProtoDll: %d', [ProtoDll]);
    LogFmt('OfflineMsg: %s', [OfflineMsg]);
  end;
{$ENDIF}
  ChangeMessageText := '';
  Result := True;
end;

procedure TCustomBaseQipPlugin.OnMsgRcvdNew(var Message: TPluginMessage);
begin
  with Message do
    MessageFlash(PWideChar(WParam), PWideChar(LParam), NParam);
end;

procedure TCustomBaseQipPlugin.OnMsgRcvdRead(var Message: TPluginMessage);
begin
  with Message do
    MessageRead(PWideChar(WParam), PWideChar(LParam), NParam);
end;

procedure TCustomBaseQipPlugin.OnMsgSend(var Message: TPluginMessage);
var
  aQipMsg: pQipMsgPlugin;
  b: BOOL;
begin
  {Getting record pointer of instant message}
  aQipMsg := pQipMsgPlugin(Message.WParam);

  if aQipMsg <> nil then
  begin
    FUpdatedText := aQipMsg^.MsgText;

    //if msg is allowed (22.02.2012 plugins chain)
    if Message.Result <> 0 then
    begin
      b := MessageSending(aQipMsg^, FUpdatedText);
      Message.Result := Integer(b);

      if (FUpdatedText <> '') and not WideSameStr(FUpdatedText, aQipMsg^.MsgText) then
      begin
        {$IFDEF LOGDEBUGINFO}
        LogFmt('changing original text from %s to %s', [aQipMsg^.MsgText, FUpdatedText]);
        {$ENDIF}
        Message.LParam := LongInt(PWideChar(FUpdatedText));
      end;
    end
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('message already disallowed');
    {$ENDIF};
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('cannot retrieve message structure');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.MessageFlash(const Account, NickName: WideString; const ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('message from %s(%s)/%d haven''t read yet. flashing', [Account, NickName, ProtoHandle]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.ChatMessageSending(const ChatTextType: Cardinal;
  const ProtoHandle: Integer; const ChatName, NickName, Message: WideString;
  var ChangedChatText: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('user wants to send message to chat %s. details:', [ChatName]);
  LogFmt('ChatTextType: %d (%s)', [ChatTextType, ChatTextTypeToStr(ChatTextType)]);
  LogFmt('ProtoHandle: %d', [ProtoHandle]);
  LogFmt('NickName: %s', [NickName]);
  LogFmt('Message: %s', [Message]);
{$ENDIF}
  ChangedChatText := '';
end;

procedure TCustomBaseQipPlugin.OnChatMsgSend(var Message: TPluginMessage);
var
  ChangingText: WideString;
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) and (NParam <> 0) then
  begin
    FUpdatedText := PWideChar(NParam);
    ChangingText := FUpdatedText;
    ChatMessageSending(LParam, DllHandle, PWideChar(WParam), PWideChar(LParam), ChangingText, FUpdatedText);

    if (FUpdatedText <> '') and (FUpdatedText <> ChangingText) then
    begin
      //change WParam & Result only if the plugin has changed the text (22.02.2012 plugins chain)
      {$IFDEF LOGDEBUGINFO}
      LogFmt('changing original chat sending text from %s to %s', [ChangingText, FUpdatedText]);
      {$ENDIF}
      Message.Result := Integer(True);
      Message.NParam := LongInt(PWideChar(FUpdatedText));
    end;
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in sending chat message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnOptions;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('user called options dialog from settings window');
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.ButtonClicked(const UniqueID,
  ProtoHandle: Integer; const AccountName, ProtoName: WideString;
  const BtnData: TBtnClick);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('user clicked the button %d under avatar of %s(from proto %s)',
         [UniqueID, AccountName, ProtoName]);
  with BtnData do
    LogFmt('Click button info: BtnData %d($%.8x), is right click: %s',
           [BtnData, BtnData, BoolToStr(RightClick, True)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.NeedAddButtons(const AccountName,
  ProtoName: WideString; const ProtoHandle: Integer = -1);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core requests adding buttons under avatar of user %s (proto %s - %d)',
         [AccountName, ProtoName, ProtoHandle]);
{$ENDIF}
//nothing by default
//call AddAvatarButton here
end;

procedure TCustomBaseQipPlugin.OnCanAddBtns(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
    NeedAddButtons(PWideChar(WParam), PWideChar(LParam), NParam);
end;

procedure TCustomBaseQipPlugin.OnChatCanAddBtns(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) and (Result <> 0) then
    NeedAddChatButtons(PWideChar(WParam), PWideChar(LParam), PWideChar(Result), NParam);
end;

procedure TCustomBaseQipPlugin.OnChatMsgBtnClick(var Message: TPluginMessage);
begin
  with Message do
  if (NParam <> 0) and (LParam <> 0) and (DllHandle <> 0) then
    ChatButtonClicked(WParam, Result, PWideChar(LParam), PWideChar(NParam), pBtnClick(DllHandle)^);
end;

procedure TCustomBaseQipPlugin.OnMsgBtnClick(var Message: TPluginMessage);
begin
  with Message do
  if (NParam <> 0) and (LParam <> 0) and (DllHandle <> 0) then
    ButtonClicked(WParam, Result, PWideChar(LParam), PWideChar(NParam), pBtnClick(DllHandle)^);
end;

function TCustomBaseQipPlugin.AddAvatarButton(const ButtonICO: HICON;
  const ButtonHint: WideString; const ButtonDataPtr: Integer): Integer;
var BtnInfo : TAddBtnInfo2;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to add button under avatar. Icon %d, Hint %s, DataPointer: %d',
         [ButtonICO, ButtonHint, ButtonDataPtr]);
{$ENDIF}
  with BtnInfo do
  begin
    cbSize     := SizeOf(BtnInfo);
    obsBtnIcon := ButtonICO;
    obsBtnPNG  := 0;
    BtnImg     := ''; //Image URI 'file://c:\1.png'
    BtnData    := ButtonDataPtr;
    BtnHint    := ButtonHint;
  end;
  Result := SendPluginMessage(PM_PLUGIN_ADD_BTN, 0, LongInt(@BtnInfo), 0);
end;

function TCustomBaseQipPlugin.AddChatButton(const ButtonICO: HICON;
  const ButtonHint: WideString; const ButtonDataPtr: Integer): Integer;
var BtnInfo : TAddBtnInfo2;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to add button in the chat. Icon %d, Hint %s, DataPointer: %d($%.8x)',
         [ButtonICO, ButtonHint, ButtonDataPtr, ButtonDataPtr]);
{$ENDIF}
  with BtnInfo do
  begin
    cbSize     := SizeOf(BtnInfo);
    obsBtnIcon := ButtonICO;
    obsBtnPNG  := 0;
    BtnImg     := ''; //Image URI 'file://c:\1.png'
    BtnData    := ButtonDataPtr;
    BtnHint    := ButtonHint;
  end;
  Result := SendPluginMessage(PM_PLUGIN_CHAT_ADD_BTN, 0, LongInt(@BtnInfo), 0);
end;

procedure TCustomBaseQipPlugin.ChatButtonClicked(const UniqueID,
  ProtoHandle: Integer; const ChatName, ProtoName: WideString;
  const BtnData: TBtnClick);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('user clicked the button %d in the chat %s from proto %s',
         [UniqueID, ChatName, ProtoName]);
  with BtnData do
    LogFmt('Click button info: BtnData %d($%.8x), is right click: %s',
           [BtnData, BtnData, BoolToStr(RightClick, True)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.NeedAddChatButtons(const ChatName, ProtoName,
  ChatCaption: WideString; const ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core requests adding buttons in the chat %s(%s) proto %s',
         [ChatName, ChatCaption, ProtoName]);
{$ENDIF}
//nothing by default
//call AddChatButton here
end;

procedure TCustomBaseQipPlugin.CoreLanguageChanged;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Core has changed language to %s', [CoreLanguage]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnCurrentLang(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (Trim(PWideChar(WParam)) <> '') and not WideSameStr(PWideChar(WParam), FLanguage) then
  begin
    FLanguage := PWideChar(WParam);
    CoreLanguageChanged;
    //if we have different strings according on a language - refill the structure
    with FPluginInfo do
      GetPluginInformation(PlugVerMajor, PlugVerMinor, PluginName, PluginAuthor,
                           PluginDescription, PluginHint);
  end;
end;

procedure TCustomBaseQipPlugin.AntiBossChanged(const SwitchedOn: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Antiboss state changed to %s', [BoolToStr(SwitchedOn, True)]);
{$ENDIF}
  //nothing by default
end;

procedure TCustomBaseQipPlugin.OnAntiBoss(var Message: TPluginMessage);
begin
  FABossed := Boolean(Message.WParam);
  AntiBossChanged(Boolean(Message.WParam));
end;

procedure TCustomBaseQipPlugin.OnStatusChanged(var Message: TPluginMessage);
begin
  with Message do
  begin
    if WParam <> -1 then FStatus := WParam
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('status hasnt been changed');
    {$ENDIF};
    if LParam <> -1 then FPrivacy := LParam
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('privacy level hasnt been changed');
    {$ENDIF};
    StatusChanged(FStatus, FPrivacy);
  end;
end;

procedure TCustomBaseQipPlugin.StatusChanged(const Status,
  PrivacyLevel: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Global status or privacy level changed. Status: %d (%s), Privacy: %d(%s)',
         [Status, StatusToStr(Status), PrivacyLevel, PrivacyLevelToStr(PrivacyLevel)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.ContactStatusChanged(const ProtoName,
  AccountName: WideString; const Status, XStatus, ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Contact %s from %s status changed to %d (%s)/xstatus: %d',
         [AccountName, ProtoName, Status, StatusToStr(Status), XStatus]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnContactStatus(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
    ContactStatusChanged(PWideChar(WParam), PWideChar(LParam),
                         NParam, Result, DllHandle)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in contact status change message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.ChatTabChanged(const ChatName, ChatCaption, MyNickName: WideString;
  const ProtoHandle: Integer; const ChatAction: TChatAction);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core has changed chat tab to %s(%s). My nickname there: %s.',
         [ChatName, ChatCaption, MyNickName]);
  LogSafe('is chat closed? ' + BoolToStr(ChatAction = caClose, True));
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnChatTab(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) and (Result <> 0) then
  begin
  	if Boolean(NParam) then
	    ChatTabChanged(PWideChar(WParam), PWideChar(Result), PWideChar(LParam), DllHandle, caOpen)
    else
	    ChatTabChanged(PWideChar(WParam), PWideChar(Result), PWideChar(LParam), DllHandle, caClose);
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in chat tab change message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.GotSpecialMessage(const ProtoName, AccountName,
  SpecialText: WideString; const ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('Special message came from contact %s(proto %s). Message text is "%s"',
         [AccountName, ProtoName, SpecialText]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnSpecRcvd(var Message: TPluginMessage);
begin
  with Message do
  if (NParam <> 0) and (LParam <> 0) and (Result <> 0) then
    GotSpecialMessage(PWideChar(Result), PWideChar(LParam), PWideChar(NParam),
                      WParam)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in special message');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.AddFakeContact(const ContactHeight,
  UserDataAddr: Integer): Integer;
begin
  {$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to add fake contact. Height %d, DataPointer: %d($%.8x)',
         [ContactHeight, UserDataAddr, UserDataAddr]);
  {$ENDIF}
  Result := SendPluginMessage(PM_PLUGIN_SPEC_ADD_CNT, ContactHeight, UserDataAddr, 0);
  {$IFDEF LOGDEBUGINFO}
  if Result <> 0 then
    LogFmt('fake contact succesfully added with ID %d.', [Result]);
  {$ENDIF}
end;

function TCustomBaseQipPlugin.RemoveFakeContact(const UniqueID: Integer): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SPEC_DEL_CNT, UniqueID, 0, 0));
  {$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to remove fake contact %d. removed: %s',
         [UniqueID, BoolToStr(Result, True)]);
  {$ENDIF}
end;

procedure TCustomBaseQipPlugin.OnDrawSpecContact(var Message: TPluginMessage);
var
  Canvas: {$IFDEF NOGRAPHICS}HDC{$ELSE}TCanvas{$ENDIF};
  DrawRect: TRect;
begin
  with Message do
  if (WParam <> 0) and (NParam <> 0) and (Result <> 0) then
  begin
    {$IFNDEF NOGRAPHICS}
    Canvas := TCanvas.Create;
    {$ENDIF}
    try
      {$IFNDEF NOGRAPHICS}
      Canvas.Handle := NParam;
      {$ELSE}
      Canvas := NParam;
      {$ENDIF}
      DrawRect := PRect(Result)^;
      PaintContact(Canvas, DrawRect, WParam, LParam);
    finally
      {$IFNDEF NOGRAPHICS}
      Canvas.Refresh;
      Canvas.Handle := 0;
      Canvas.Free;
      {$ENDIF}
    end;
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in fake contact draw message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnSpecContactDblClk(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
    OnFakeContactDblClk(WParam, LParam)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('wrong UniqueID in fake contact dblclick message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnSpecContactRightClk(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (NParam <> 0) then
    OnFakeContactRightClick(WParam, LParam, PPoint(NParam)^)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('wrong UniqueID or PopupPoint in fake contact rightclick message');
  {$ENDIF};
end;

{$IFDEF NOGRAPHICS}
procedure TCustomBaseQipPlugin.PaintContact(const DestCanvas: HDC;
  const ARect: TRect; const UniqueID, UserData: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  with ARect do
    LogFmt('core requests fake contact %d to be repainted. OutRect (%d, %d, %d, %d), UserData: $%.8x',
           [UniqueID, Left, Top, Right, Bottom, UserData]);
{$ENDIF}
//nothing by default
end;
{$ELSE}
procedure TCustomBaseQipPlugin.PaintContact(const DestCanvas: TCanvas;
  const ARect: TRect; const UniqueID, UserData: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  with ARect do
    LogFmt('core requests fake contact %d to be repainted. OutRect (%d, %d, %d, %d), UserData: $%.8x',
           [UniqueID, Left, Top, Right, Bottom, UserData]);
{$ENDIF}
//nothing by default
end;
{$ENDIF}


procedure TCustomBaseQipPlugin.OnFakeContactDblClk(const UniqueID,
  UserData: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('user dblclicked on fake contact %d, UserData: $%.8x',
         [UniqueID, UserData]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnFakeContactRightClick(const UniqueID,
  UserData: Integer; const PopupPoint: TPoint);
begin
{$IFDEF LOGDEBUGINFO}
  with PopupPoint do
  LogFmt('user right clicked on fake contact %d, UserData: $%.8x at point %d,%d',
         [UniqueID, UserData, X, Y]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.FadeClicked(const FadeID: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('user has clicked your fade window. FadeID is %d', [FadeID]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnFadeClick(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
    FadeClicked(WParam)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('wrong FadeID or PopupPoint in fadeclick message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnDrawHint(var Message: TPluginMessage);
var
  Canvas: {$IFDEF NOGRAPHICS}HDC{$ELSE}TCanvas{$ENDIF};
  DrawRect: TRect;
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) and (NParam <> 0) then
  begin
    {$IFNDEF NOGRAPHICS}
    Canvas := TCanvas.Create;
    {$ENDIF}
    try
      {$IFNDEF NOGRAPHICS}
      Canvas.Handle := LParam;
      {$ELSE}
      Canvas := LParam;
      {$ENDIF}
      DrawRect := PRect(NParam)^;

      PaintContactHint(Canvas, DrawRect, WParam, Result);
    finally
      {$IFNDEF NOGRAPHICS}
      Canvas.Refresh;
      Canvas.Handle := 0;
      Canvas.Free;
      {$ENDIF}
    end;
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in fake contact hint draw message');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.OnGetFakeContactHintSize(const UniqueID, UserData: Integer; var Width, Height: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core requests hint size for fake contact %d, UserData: $%.8x',
         [UniqueID, UserData]);
{$ENDIF}
  Width := 0;
  Height := 0;
end;

procedure TCustomBaseQipPlugin.OnGetHintWH(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
    OnGetFakeContactHintSize(WParam, Result, LParam, NParam)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('wrong UniqueID in fake contact hint size request message');
  {$ENDIF};
end;

{$IFDEF NOGRAPHICS}
procedure TCustomBaseQipPlugin.PaintContactHint(const HintCanvas: HDC;
  const ARect: TRect; const UniqueID, UserData: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  with ARect do
  LogFmt('core requests hint repaint for fake contact %d, UserData: $%.8x, OutRect (%d, %d, %d, %d)',
         [UniqueID, UserData, Left, Top, Right, Bottom]);
{$ENDIF}
//nothing by default
end;
{$ELSE}
procedure TCustomBaseQipPlugin.PaintContactHint(const HintCanvas: TCanvas;
  const ARect: TRect; const UniqueID, UserData: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  with ARect do
  LogFmt('core requests hint repaint for fake contact %d, UserData: $%.8x, OutRect (%d, %d, %d, %d)',
         [UniqueID, UserData, Left, Top, Right, Bottom]);
{$ENDIF}
//nothing by default
end;
{$ENDIF}

procedure TCustomBaseQipPlugin.EnumPluginsCallback(const EnumInfo: TPluginInfo;
  const PluginEnabled, IsLastEnumPlugin: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugins enumeration in progress. plugin enabled: %s, is last plugin: %s',
         [BoolToStr(PluginEnabled, True), BoolToStr(IsLastEnumPlugin, True)]);
  with EnumInfo do
  LogFmt('plugin information: DllHandle %d, DllPath %s, QipSdk %d.%d, PlugVer %d.%d,' +
         'PluginName %s, PluginAuthor %s, PluginDescription %s, PluginHint %s, PluginIcon %d',
         [DllHandle, DllPath, QipSdkVerMajor, QipSdkVerMinor, PlugVerMajor,
          PlugVerMinor, PluginName, PluginAuthor, PluginDescription,
          PluginHint, PluginIcon]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.OnEnumInfo(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
    EnumPluginsCallback(pPluginInfo(WParam)^, Boolean(LParam), Boolean(NParam))
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect enuminfo pointer in EnumInfo message');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.GetLanguageString(const LANG_ID: Integer): WideString;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin asks core for language string for %d ID', [LANG_ID]);
{$ENDIF}
  Result := PWideChar(SendPluginMessage(PM_PLUGIN_GET_LANG_STR, LANG_ID, 0, 0));
end;

function TCustomBaseQipPlugin.ShowFade(const AFadeTitle, AFadeText: WideString;
  const AFadeIcon: HICON; const AFadeType: Integer; const ATextCentered,
  ANoAutoClose: Boolean; const AddToFadeList: Boolean; const AdditionalData: Integer): Integer;
var
  aFadeWnd: TFadeWndInfo;
begin
  with aFadeWnd do
  begin
    FadeType := AFadeType;
    FadeIcon := AFadeIcon;
    FadeTitle := AFadeTitle;
    FadeText  := AFadeText;
    TextCentered := ATextCentered;
    NoAutoClose  := ANoAutoClose;
  end;
  Result := ShowFade(aFadeWnd, AddToFadeList, AdditionalData);
end;

function TCustomBaseQipPlugin.ShowFade(const FadeInfo: TFadeWndInfo;
  const AddToFadeList: Boolean; const AdditionalData: Integer): Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to show fade window.');
  with FadeInfo do
  LogFmt('Title %s, Text %s, Icon %d, Type %d, IsCentered: %s, NoAutoClose: %s',
        [FadeTitle, FadeText, FadeIcon, FadeType,
         BoolToStr(TextCentered, True), BoolToStr(NoAutoClose, True)]);
{$ENDIF}
  Result := SendPluginMessage(PM_PLUGIN_FADE_MSG, LongInt(@FadeInfo), 0, 0);
  if AddToFadeList then
    FFades.AddFade(Result, FadeInfo, AdditionalData);
{$IFDEF LOGDEBUGINFO}
  if Result <> 0 then
    LogFmt('fade window succesfully shown with ID %d.', [Result]);
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.GetDisplayProfileNames(var DisplayName, ProfileName: WideString);
var
  wDisp, wProf, foo: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to display and profile names.');
{$ENDIF}
  DisplayName := '';
  ProfileName := '';
  wDisp := 0;
  wProf := 0;
  foo   := 0;
  if LongBool(VarSendPluginMessage(PM_PLUGIN_GET_NAMES, wDisp, wProf, foo)) then
  begin
    if wDisp <> 0 then DisplayName := PWideChar(wDisp)
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('cannot retrieve display name.');
    {$ENDIF};
    if wProf <> 0 then ProfileName := PWideChar(wProf)
    {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('cannot retrieve profile name.');
    {$ENDIF};
  end
{$IFDEF LOGDEBUGINFO}
  else
    LogSafe('cannot retrieve display and profile names.');
{$ENDIF};
end;

procedure TCustomBaseQipPlugin.GetGlobalStatusPrivacy(var Status, Privacy: Integer);
var
  foo: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests global status and privacy level.');
{$ENDIF}
  if not LongBool(VarSendPluginMessage(PM_PLUGIN_STATUS_GET, Status, Privacy, foo)) then
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('cannot retrieve global status and privacy level.');
    {$ENDIF}
    Status  := -1;
    Privacy := -1;
  end;
end;

procedure TCustomBaseQipPlugin.GetGlobalStatusPrivacyAsString(var Status,
  Privacy: WideString; const UseLang: Boolean);
var
  iStatus, iPrivacy: Integer;
begin
  Status  := '';
  Privacy := '';
  GetGlobalStatusPrivacy(iStatus, iPrivacy);
  if (iStatus >= 0) and (iPrivacy >= 0) then
  begin
    Status  := StatusToStr(iStatus, UseLang);
    Privacy := PrivacyLevelToStr(iPrivacy, UseLang);
  end;
end;

function TCustomBaseQipPlugin.SetGlobalPrivacyLevel(const Privacy: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to set global privacy level %d(%s).',
         [Privacy, PrivacyLevelToStr(Privacy)]);
{$ENDIF}
  Result := False;
  if Privacy in [QIP_STATUS_PRIV_VIS4ALL..QIP_STATUS_PRIV_VIS4CL] then
    Result := Boolean(SendPluginMessage(PM_PLUGIN_STATUS_SET, -1, Privacy, 0));
end;

function TCustomBaseQipPlugin.SetGlobalStatus(const Status: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to set global status %d(%s).',
         [Status, StatusToStr(Status)]);
{$ENDIF}
  Result := False;
  if Status in [QIP_STATUS_ONLINE..QIP_STATUS_OFFLINE] then
    Result := Boolean(SendPluginMessage(PM_PLUGIN_STATUS_SET, Status, -1, 0));
end;

function TCustomBaseQipPlugin.SendIM(const ProtoHandle: Integer;
  const ReceiverAccount, MessageText: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to send instant message. Proto %d, RcvrAcc %s, Message %s.',
         [ProtoHandle, ReceiverAccount, MessageText]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SEND_IM, ProtoHandle,
                                      LongInt(PWideChar(ReceiverAccount)),
                                      LongInt(PWideChar(MessageText))));
end;

function TCustomBaseQipPlugin.SendSpecialMessage(const ProtoHandle: Integer;
  const ReceiverAccount, MessageText: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to send special message. Proto %d, RcvrAcc %s, Message %s.',
         [ProtoHandle, ReceiverAccount, MessageText]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SPEC_SEND, ProtoHandle,
                                      LongInt(PWideChar(ReceiverAccount)),
                                      LongInt(PWideChar(MessageText))));
end;

function TCustomBaseQipPlugin.GetContactDetails(const ProtoHandle: Integer; const AccountName: WideString): TContactDetails;
var
  iAcc, iProto: Integer;
  Details: pContactDetails;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to retrieve Contact %s details, Proto %d',
         [AccountName, ProtoHandle]);
{$ENDIF}
  FillChar(Result, SizeOf(Result), 0);
  iProto := ProtoHandle;
  iAcc := LongInt(PWideChar(AccountName));
  if LongBool(VarSendPluginMessage(PM_PLUGIN_DETAILS_GET, iProto, iAcc, LongInt(Details))) then
  {$IFDEF LOGDEBUGINFO}
  begin
  {$ENDIF}
    if Details <> nil then
      Result := Details^
  {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('incorect details pointer');
  end
  else
    LogSafe('couldnt get contact details');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.SetContactDetails(const ProtoHandle: Integer;
  const AccountName: WideString; DetailsUpd: TContactDetails): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SET_DETAILS, ProtoHandle,
                                      Integer(PWideChar(AccountName)),
                                      Integer(@DetailsUpd)));
end;

function TCustomBaseQipPlugin.SendChatMessage(const ProtoHandle: Integer;
  const ChatName, MessageText: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to send chat message. Proto %d, ChatName %s, Message %s.',
         [ProtoHandle, ChatName, MessageText]);
{$ENDIF}
   Result := Boolean(SendPluginMessage(PM_PLUGIN_CHAT_MSG_SEND, LongInt(PWideChar(ChatName)),
                                       ProtoHandle,
                                       LongInt(PWideChar(MessageText))));
end;

procedure TCustomBaseQipPlugin.PlaySound(const SoundID: Integer;
  const ForcePlaying: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to play sound with %d ID, forceplaying: %s',
         [SoundID, BoolToStr(ForcePlaying, True)]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_PLAY_WAV_SND, SoundID, 0, Byte(ForcePlaying));
end;

procedure TCustomBaseQipPlugin.InvalidateFakeContact(const UniqueID: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to invalidate fake contact %d', [UniqueID]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_SPEC_REDRAW, UniqueID, 0, 0);
end;

function TCustomBaseQipPlugin.CloseFade(const FadeID: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin wants to close fade window %d', [FadeID]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_FADE_CLOSE, FadeID, 0, 0));
  if Result then
    FFades.KillFade(FadeID);
end;

function UpperDir(const Path: WideString): WideString;
var
  I: Integer;
begin
  Result := {$IF CompilerVersion <= 18.0}WideExcludeTrailingBackslash{$ELSE}ExcludeTrailingBackslash{$IFEND}(Path);
  I := {$IF CompilerVersion <= 18.0}WideLastDelimiter{$ELSE}LastDelimiter{$IFEND}('\:', Result);
  if I > 0 then
    Result := Copy(Result, 1, I);

  Result := {$IF CompilerVersion <= 18.0}WideIncludeTrailingBackslash{$ELSE}IncludeTrailingBackslash{$IFEND}(Result);
end;

function TCustomBaseQipPlugin.GetQIPProfileDirectory: WideString;
begin
  Result := UpperDir(GetPluginsDataDirectory)
end;

function TCustomBaseQipPlugin.GetPluginsDataDirectory: WideString;
var
  iDir, foo: Integer;
begin
  {$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to retrieve plugin profile directory');
  {$ENDIF};
  Result := '';
  if LongBool(VarSendPluginMessage(PM_PLUGIN_GET_PROFILE_DIR, iDir, foo, foo)) and (iDir <> 0) then
    Result := PWideChar(iDir)
  {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('couldnt retrieve plugin profile directory');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.GetGlobalNetParams: TNetParams;
var
  NetParams: pNetParams;
  foo: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to retrieve global net parameters');
{$ENDIF}
  FillChar(Result, SizeOf(Result), 0);
  if LongBool(VarSendPluginMessage(PM_PLUGIN_GET_NET_SET, LongInt(NetParams), foo, foo)) then
  {$IFDEF LOGDEBUGINFO}
  begin
  {$ENDIF}
    if NetParams <> nil then
      Result := NetParams^
  {$IFDEF LOGDEBUGINFO}
    else
      LogSafe('incorect netparams pointer');
  end
  else
    LogSafe('couldnt get net parameters');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.GetFontColorSettings(var FontName: WideString;
  var FontSize: Integer; var Colors: TQipColors): Boolean;
var
  iName, iSize: Integer;
  AColors: pQipColors;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to retrieve font/color settings');
{$ENDIF}
  Result := False;
  FontName := '';
  FontSize := 0;
  FillChar(Colors, SizeOf(Colors), 0);
  VarSendPluginMessage(PM_PLUGIN_GET_COLORS_FONT, iName, iSize, AColors);
  if (iName <> 0) and (AColors <> nil) then
  begin
    FontName := PWideChar(iName);
    FontSize := iSize;
    Colors   := AColors^;
    Result   := True;
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('couldnt get font/color settings');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.CloseInfium;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to close current Infium instance');
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_INFIUM_CLOSE, 0, 0, 0);
end;

procedure TCustomBaseQipPlugin.RestartInfium;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to restart current Infium instance');
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_INFIUM_CLOSE, 1, 0, 0);
end;

function TCustomBaseQipPlugin.FindPlugin(const PluginName: WideString; var FoundInfo: TPluginInfo; var PluginEnabled: Boolean): Integer;
var
  iNameInfo, iEnabled: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin requests core to find plugin %s', [PluginName]);
{$ENDIF}
  iNameInfo := LongInt(PWideChar(PluginName));
  FillChar(FoundInfo, SizeOf(FoundInfo), 0);
  PluginEnabled := False;
  if LongBool(VarSendPluginMessage(PM_PLUGIN_FIND, iNameInfo, Result, iEnabled)) and
     (iNameInfo <> 0) then
  begin
    FoundInfo     := pPluginInfo(iNameInfo)^;
    PluginEnabled := Boolean(iEnabled);
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data or plugin ot found');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.EnumeratePlugins;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests core to enumerate all plugins');
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_ENUM_PLUGINS, 0, 0, 0);
end;

procedure TCustomBaseQipPlugin.BroadcastMessage(const WParam, LParam, NParam,
  Result: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin requests core to broadcast message:');
  LogFmt('WParam %d($%.8x) LParam %d($%.8x) NParam %d($%.8x) Result %d($%.8x)',
         [WParam, WParam, LParam, LParam, NParam, NParam, Result, Result]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_BROADCAST, WParam, LParam, NParam, Result);
end;

procedure TCustomBaseQipPlugin.OnBroadcast(var Message: TPluginMessage);
begin
  with Message do
  if not BroadcastReceived(WParam, LParam, NParam, Result) then
{$IFDEF LOGDEBUGINFO}
  begin
{$ENDIF}
    Msg := 0;
{$IFDEF LOGDEBUGINFO}
    LogSafe('plugin stops broadcasting');
  end
{$ENDIF}
end;

function TCustomBaseQipPlugin.BroadcastReceived(var WParam, LParam, NParam,
  AResult: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('received broadcast message. WParam %d, LParam %d, NParam %d, Result %d',
         [WParam, LParam, NParam, AResult]);
{$ENDIF}
  Result := True;
end;

procedure TCustomBaseQipPlugin.OnPluginMsg(var Message: TPluginMessage);
begin
  with Message do
    PluginMessageReceived(DllHandle, LParam, NParam, Result);
end;

procedure TCustomBaseQipPlugin.OnCLChanged(var Message: TPluginMessage);
begin
  ContactListChanged;
end;

procedure TCustomBaseQipPlugin.OnNotifBtnClick(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
    Result := Integer(OnNotifButtonClicked(WParam, LParam, NParam));
end;

procedure TCustomBaseQipPlugin.OnGetHistInterface(var Message: TPluginMessage);
begin
  Message.Result := Integer(IPluginHistory(Self));
end;

procedure TCustomBaseQipPlugin.PluginMessageReceived(SenderDllHandle: Integer; var LParam, NParam,
  AResult: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('received message from %d plugin. LParam %d, NParam %d, Result %d',
         [SenderDllHandle, LParam, NParam, AResult]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.ContactListChanged;
begin
{$IFDEF LOGDEBUGINFO}
  Log('Contact list has been changed');
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.SendMessageToPlugin(const PluginHandle, LParam,
  NParam, Result: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to send message to another plugin:');
  LogFmt('PluginHandle %d($%.8x) LParam %d($%.8x) NParam %d($%.8x) Result %d($%.8x)',
         [PluginHandle, PluginHandle, LParam, LParam, NParam, NParam, Result, Result]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_MESSAGE, PluginHandle, LParam, NParam, Result);
end;          

function TCustomBaseQipPlugin.GetContactStatus(const ProtoHandle: Integer;
  const AccountName: WideString): Integer;
var
  iProto, iAccName, iStatus: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin requests contact %s status', [AccountName]);
{$ENDIF}
  Result := QIP_STATUS_OFFLINE;
  iProto := ProtoHandle;
  iAccName := LongInt(PWideChar(AccountName));
  if LongBool(VarSendPluginMessage(PM_PLUGIN_GET_CONTACT_ST, iProto, iAccName, iStatus)) then
    Result := iStatus
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('couldnt retrieve contact status');
  {$ENDIF};
end;

procedure TCustomBaseQipPlugin.GetContactXStatus(const ProtoHandle: Integer;
  const AccountName: WideString; var StatusText,
  StatusDescription: WideString; var StatusPic: Integer);
var
  iProto, iAccName, iStatusPic, iDelim, iResult: Integer;
  XSt: array[0..4095] of WideChar;
  wXSt: WideString;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('plugin requests contact %s/%d x-status', [AccountName, ProtoHandle]);
{$ENDIF}
  FillChar(Xst, SizeOf(Xst), 0);

  iProto     := ProtoHandle;
  iAccName   := LongInt(PWideChar(AccountName));
  iStatusPic := 4096;
  iResult    := Longint(@XSt);
  VarSendPluginMessage(PM_PLUGIN_GET_CONT_XST, iAccName, iProto, iStatusPic, iResult);

  wXSt       := XSt;
  StatusPic  := iStatusPic;

  if wXSt <> '' then
  begin
    iDelim := Pos('|', wXSt);
    StatusText := wXSt;
    if iDelim > 0 then
    begin
      Delete(StatusText, iDelim, Length(StatusText));
      Delete(wXSt, 1, iDelim);
      StatusDescription := wXSt;
    end;
  end
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('couldnt retrieve contact x-status');
  {$ENDIF};
end;

function TCustomBaseQipPlugin.PrivacyLevelToStr(const Privacy: Integer;
  const UseLangStr: Boolean): WideString;
type
	TQipPrivacyStatusL = QIP_STATUS_PRIV_VIS4ALL..QIP_STATUS_PRIV_VIS4CL;
const
  PrivLevels: array[TQipPrivacyStatusL] of WideString =
    ('Visible for all', 'Invisible for all',
     'Visible only for visible list', 'Visible for all, except invisible list',
     'Visible for contact list');
  PrivacyLangIDs: array[TQipPrivacyStatusL] of Integer =
    (LI_ST_PRIV_VIS4ALL, LI_ST_PRIV_INVIS4ALL, LI_ST_PRIV_VIS4VIS,
     LI_ST_PRIV_VISNORM, LI_ST_PRIV_VIS4CL);
begin
  Result := '';
  if (Privacy >= LOW(TQipPrivacyStatusL)) and (Privacy <= HIGH(TQipPrivacyStatusL)) then
  begin
    Result  := PrivLevels[Privacy];

    if UseLangStr then
      Result  := GetLanguageString(PrivacyLangIDs[Privacy]);
  end;
end;

class function TCustomBaseQipPlugin.ConvertTime(const UnixTime: DWord): TDateTime;
begin
  Result := UnixToDateTime(UnixTime);
end;

function TCustomBaseQipPlugin.StatusToStr(const Status: Integer;
  const UseLangStr: Boolean): WideString;
const
  Statuses: array[0..14] of WideString =
    ('Online', 'Invisible', 'Invisible for all', 'Free for chat',
     'Evil', 'Depression', 'At home', 'At work', 'Occupied',
     'Do not disturb', 'Lunch', 'Away', 'Not Available',
     'Offline', 'Connecting');
  StatusLangIDs: array[0..14] of Integer =
    (LI_ST_ONLINE, LI_ST_INVISIBLE, LI_ST_INVIS4ALL, LI_ST_FFC,
     LI_ST_EVIL, LI_ST_DEPRES, LI_ST_ATHOME, LI_ST_ATWORK,
     LI_ST_OCCUPIED, LI_ST_DND, LI_ST_LUNCH, LI_ST_AWAY,
     LI_ST_NA, LI_ST_OFFLINE, LI_ST_CONNECTING);
begin
  Result := '';
  if Status in [QIP_STATUS_ONLINE..QIP_STATUS_NOTINLIST] then
  begin
    Result  := Statuses[Status];

    if UseLangStr then
      Result  := GetLanguageString(StatusLangIDs[Status]);
  end;
end;

function TCustomBaseQipPlugin.GetOptions: pPluginSpecific;
begin
  Result := FPluginSvc.PluginOptions(FPluginInfo.DllHandle);
end;

procedure TCustomBaseQipPlugin.SetOptions(const Value: TPluginSpecific);
var
  RealOptionsPtr: pPluginSpecific;
begin
  RealOptionsPtr := GetOptions;
  if RealOptionsPtr <> nil then
  begin
    RealOptionsPtr^ := Value;
    FOptions := Value;
  end;
end;

{$IFDEF LOGDEBUGINFO}
procedure TCustomBaseQipPlugin.LogSafe(const LogMessage: WideString);
begin
  try
    Log(LogMessage);
  except
    Log('Error while logging, please check output string or overriden log code');
  end;
end;

procedure TCustomBaseQipPlugin.Log(const LogMessage: WideString);
begin
  {$IFDEF GEXPERTSDEBUG}
  SendDebug(LogMessage);
  {$ENDIF}
end;

procedure TCustomBaseQipPlugin.LogFmt(const LogMessageFmtStr: WideString;
  Args: array of const);
begin
  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF CompilerVersion <= 15.0}
      {$Message 'please read this comment'}
    {$IFEND}
  {$ELSE}
    {$Message 'please read this comment'}
  {$ENDIF}
  //note, that D7 (and probably lower) has a bug with formatting WideStrings
  //see SysUtils.WideFmtStr, QA 4744
  //web link may change, see http://qc.embarcadero.com/wc/qcmain.aspx?d=4744

  //it is highly recommended NOT to use D7 and use at least D2006
  //if you still want to use it, you may patch your SysUtils unit as described on QA
  //do it at your own risk
  LogSafe(WideFormat(LogMessageFmtStr, Args));
end;
{$ENDIF}

function TCustomBaseQipPlugin.FullPluginPath: WideString;
var
  buf: array[0..MAX_PATH - 1] of WideChar;
begin
  Result := '';
  if GetModuleFileNameW(FPluginInfo.DllHandle, buf, MAX_PATH) <> 0 then
    Result := buf;
end;

class function TCustomBaseQipPlugin.GetSystemIcon(const IconID: PAnsiChar): HICON;
begin
  Result := LoadImageA(0, IconID, IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR or LR_SHARED);
end;

class function TCustomBaseQipPlugin.IsJabberChatAccount(const AccountName: WideString): Boolean;
var
  AtPos, LastDotPos: Integer;
  BetweenStr: WideString;
begin
  Result := False;
  AtPos := Pos('@', AccountName);
  if AtPos = 0 then Exit;

  //if this is a private chat jid, cut all after "/" symbol 
  BetweenStr := AccountName;
  LastDotPos := PosEx('/', AccountName, AtPos);
  if LastDotPos <> 0 then
    BetweenStr := Copy(AccountName, 1, LastDotPos);

  LastDotPos := PosEx('.', BetweenStr, AtPos);
  if LastDotPos = 0 then Exit;

  BetweenStr := Copy(BetweenStr, AtPos, LastDotPos);

  Result := (Pos(WideString(' '), BetweenStr) = 0) and (Pos(WideString('@conference.'), AccountName) <> 0);
end;

class function TCustomBaseQipPlugin.IsJabberPrivateChatAccount(const AccountName: WideString): Boolean;
begin
  Result := IsJabberChatAccount(AccountName) and (Pos('/', AccountName) <> 0);
end;

class function TCustomBaseQipPlugin.ExtractChatName(const PrivateName: WideString): WideString;
begin
  Result := PrivateName;
  if IsJabberPrivateChatAccount(PrivateName) then
    Result := Copy(PrivateName, 1, Pos('/', PrivateName) - 1);
end;

class function TCustomBaseQipPlugin.ExtractPrivateNick(const ChatName: WideString): WideString;
begin
  Result := ChatName;
  if IsJabberPrivateChatAccount(ChatName) then
    Result := Copy(ChatName, Pos('/', ChatName) + 1, Length(ChatName) - Pos('/', ChatName) + 1);
end;

class function TCustomBaseQipPlugin.IsIRCChannel(const ChatName: WideString): Boolean;
begin
  Result := ChatName[1] = '#';
end;

class function TCustomBaseQipPlugin.IsIRCPrivate(const ChatName: WideString): Boolean;
begin
  Result := not IsIRCChannel(ChatName) and not IsJabberChatAccount(ChatName);
end;

procedure TCustomBaseQipPlugin.OnDragEnd(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (NParam <> 0) then
    FakeContactDropped(WParam, Boolean(LParam), PPoint(NParam)^);
end;

procedure TCustomBaseQipPlugin.OnDragStart(var Message: TPluginMessage);
begin
  Message.Result := Byte(AllowDragFakeContact(Message.WParam));
end;

function TCustomBaseQipPlugin.AllowDragFakeContact(const UniqueID: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('start dragging a spec contact id=', [UniqueID]);
{$ENDIF}
  Result := False;
end;

procedure TCustomBaseQipPlugin.FakeContactDropped(const UniqueID: Integer; ToDesktop: Boolean; DropPoint: TPoint);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('fake contact %d has been dropped to desktop to %d,%d', [UniqueID, DropPoint.X, DropPoint.Y]);
{$ENDIF}
//nothing by default
end;

function TCustomBaseQipPlugin.AddElement(const Contact: pSnapshotElement): HResult;
var
  Stop: Boolean;
begin
  Result := E_FAIL; //not Success()
  if (Contact <> nil) then
  begin
    Stop := False;
    AddContact(Contact^, Stop);
    if Stop then
      Result := E_ABORT
    else
      Result := S_OK;
  end;
end;

function TCustomBaseQipPlugin.AddProto(const Proto: pProtoSnapshotElement): HResult;
var
  Stop: Boolean;
begin
  Result := E_FAIL; //not Success()
  if (Proto <> nil) then
  begin
    Stop := False;
    AddEnumProto(Proto^, Stop);
    if Stop then
      Result := E_ABORT
    else
      Result := S_OK;
  end;
end;

procedure TCustomBaseQipPlugin.AddContact(AContact: TSnapshotElement;
  var Stop: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  with AContact do
    LogFmt('Core added contact: %s/%s - %s proto %d status %d IsChat %s',
                      [AccountName, ContactName, GroupName, ProtoHandle, ContactStatus,
                       BoolToStr(IsChatContact, True)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.AddEnumProto(AProto: TProtoSnapshotElement; var Stop: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  with AProto do
    LogFmt('Core added proto: name %s handle %d Enabled %s',
                      [ProtoName, ProtoHandle, BoolToStr(Enabled, True)]);
{$ENDIF}
//nothing by default
end;

procedure TCustomBaseQipPlugin.EnumerateCL(ProtocolHandle: Integer);
var CLSnapshotIntf: ICLSnapshot;
begin
{$IFDEF LOGDEBUGINFO}
  Log('begin contact list enumeration');
{$ENDIF}
  CLSnapshotIntf := Self;
  SendPluginMessage(PM_PLUGIN_GET_CL_SNAPSHOT, Integer(CLSnapshotIntf), ProtocolHandle, 0);
{$IFDEF LOGDEBUGINFO}
  Log('contact list enumeration done');
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.EnumerateProtos;
var CLSnapshotIntf: ICLSnapshot;
begin
{$IFDEF LOGDEBUGINFO}
  Log('begin proto enumeration');
{$ENDIF}
  CLSnapshotIntf := Self;
  SendPluginMessage(PM_PLUGIN_PROTOS_SNAPSHOT, Integer(CLSnapshotIntf), 0, 0);
{$IFDEF LOGDEBUGINFO}
  Log('proto enumeration done');
{$ENDIF}
end;

function TCustomBaseQipPlugin.GetGraphHandle: THandle;
begin
  Result := SendPluginMessage(PM_PLUGIN_GET_SKIN_HANDLE, 0, 0, 0);
end;

function TCustomBaseQipPlugin.OpenTab(AccountNameOrChatName: WideString;
  ProtoHandle: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('trying to open message tab or chat tab %s/%d', [AccountNameOrChatName, ProtoHandle]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_OPEN_FOCUS_TAB,
                                      Integer(PWideChar(AccountNameOrChatName)),
                                      ProtoHandle, 0));
{$IFDEF LOGDEBUGINFO}
  LogFmt('open message tab or chat tab result is %s', [BoolToStr(Result, True)]);
{$ENDIF}
end;

function TCustomBaseQipPlugin.OpenTab(AccountNameOrChatName, ProtoName: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('trying to open message tab or chat tab %s/%s', [AccountNameOrChatName, ProtoName]);
{$ENDIF}
  Result := Boolean(SendPluginMessage(PM_PLUGIN_OPEN_FOCUS_TAB,
                                      Integer(PWideChar(AccountNameOrChatName)), 0,
                                      Integer(PWideChar(ProtoName))));
{$IFDEF LOGDEBUGINFO}
  LogFmt('open message tab or chat tab result is %s', [BoolToStr(Result, True)]);
{$ENDIF}
end;

procedure TCustomBaseQipPlugin.ClearIncomingEvent(AccountName: WideString;
  ProtoHandle: Integer);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('trying to clear event for %s/%d', [AccountName, ProtoHandle]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_CLEAR_EVENT, Integer(PWideChar(AccountName)), ProtoHandle, 0);
end;

procedure TCustomBaseQipPlugin.ClearIncomingEvent(AccountName,
  ProtoName: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('trying to clear event for %s/%s', [AccountName, ProtoName]);
{$ENDIF}
  SendPluginMessage(PM_PLUGIN_CLEAR_EVENT,
                    Integer(PWideChar(AccountName)), 0,
                    Integer(PWideChar(ProtoName)));
end;


function TCustomBaseQipPlugin.IsAccountNIL(AccountName: WideString; ProtoHandle: Integer): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_IS_ACC_IN_NIL,
                                      Integer(PWideChar(AccountName)), ProtoHandle, 0));
end;

function TCustomBaseQipPlugin.IsAccountNIL(AccountName, ProtoName: WideString): Boolean;
begin
   Result := Boolean(SendPluginMessage(PM_PLUGIN_IS_ACC_IN_NIL,
                                       Integer(PWideChar(AccountName)), 0,
                                       Integer(PWideChar(ProtoName))));
end;

function TCustomBaseQipPlugin.AddOverlayIcon(OI: TOverlayIcon;
  var UniqID: Integer): Boolean;
begin
  Result := False;
  if (OI.Memory <> nil) and (OI.MemoryLen <> 0) then
  begin
    UniqID := SendPluginMessage(PM_PLUGIN_ADD_OVERLAY_ICN, Integer(@OI), 0, 0);
    Result := UniqID >= 0;
  end;
end;

function TCustomBaseQipPlugin.DeleteOverlayIcon(UniqID: Integer): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_DEL_OVERLAY_ICN, UniqID, 0, 0));
end;

function TCustomBaseQipPlugin.SetIconForContact(const AccountName: WideString;
  ProtoHandle: Integer; UniqID: Integer): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_SET_OVERLAY_ICN,
                                      Integer(PWideChar(AccountName)), ProtoHandle,
                                      UniqID));
end;

function TCustomBaseQipPlugin.UpdateOverlayIcon(UniqID: Integer;
  OI: TOverlayIcon; RedrawContacts: Boolean): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_UPD_OVERLAY_ICN, Integer(@OI),
                                      UniqID, Integer(RedrawContacts), 0));
end;

function TCustomBaseQipPlugin.GetMetaContact(AccountName: WideString; ProtoHandle: Integer): IMetaContact;
begin
  Result := IMetaContact(SendPluginMessage(PM_PLUGIN_GET_META_CONT,
                                           ProtoHandle,
                                           Integer(PWideChar(AccountName)), 0));
end;

function TCustomBaseQipPlugin.AddIconToMsgImgList(Ico: HICON; Png: Integer = 0): Integer;
begin
  Result := SendPluginMessage(PM_PLUGIN_NOTIF_ADD_ICON, Ico, Png, 0);
end;

function TCustomBaseQipPlugin.AddNotifMessage(AccountName: WideString; ProtoHandle: Integer; NI: TNotifInfo): Integer;
begin
  Result := SendPluginMessage(PM_PLUGIN_NOTIF_SEND_CHAT,
                              ProtoHandle,
                              Integer(PWideChar(AccountName)),
                              Integer(@NI));
end;

function TCustomBaseQipPlugin.AddNotifMessage(AccountName: WideString; ProtoHandle: Integer; MessageText: WideString; IconID: Integer; IsIncomimg: Boolean): Integer;
var NI: TNotifInfo;
begin
  NI.IconID := IconID;
  NI.Text   := MessageText;
  NI.Buttons := 0;
  NI.UserBtnText1 := '';
  NI.UserBtnText2 := '';
  NI.NotifData    := 0;
  NI.Incoming     := IsIncomimg;
  Result := AddNotifMessage(AccountName, ProtoHandle, NI);
end;

procedure TCustomBaseQipPlugin.DisableNotifButton(AccountName: WideString; ProtoHandle: Integer; NotifID: Integer; BtnID: Integer);
begin
  SendPluginMessage(PM_PLUGIN_NOTIF_BTN_DISBL,
                    ProtoHandle,
                    Integer(PWideChar(AccountName)),
                    NotifID,
                    BtnID);
end;

function TCustomBaseQipPlugin.OnNotifButtonClicked(NotifID: Integer; BtnID: Cardinal; BtnData: Integer): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('NotifInfo (id=%d) button clicked id=%d, Data=%d', [NotifID, BtnID, BtnData]);
{$ENDIF}
  Result := False;
end;

function TCustomBaseQipPlugin.DeleteHist(NodeID: WideString): Boolean;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants to delete history of NodeID=%s', [NodeID]);
{$ENDIF}
  Result := InnerDeleteHist(NodeID);
end;

procedure TCustomBaseQipPlugin.GetHistInfo(NodeID: WideString; var TimeFmtStr: WideString;
  var NickBeforeTime, BreakBeforeMsg, HideMsgSeparators: Boolean);
begin
  InnerGetHistInfo(NodeID, TimeFmtStr, NickBeforeTime, BreakBeforeMsg, HideMsgSeparators);
end;

function TCustomBaseQipPlugin.HasHistory: Boolean;
begin
  Result := InnerHasHistory;
end;

procedure TCustomBaseQipPlugin.LoadHist(NodeID: WideString; IsMeta: Boolean);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants to load history of NodeID=%s IsMeta=%s', [NodeID, BoolToStr(IsMeta, True)]);
{$ENDIF}
  InnerLoadHist(NodeID, IsMeta);
end;

function TCustomBaseQipPlugin.NodeIDFromMeta(AMeta: IMetaContact): WideString;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants to get NodeID for Meta %s id=%d', [AMeta.MetaContactName, AMeta.UniqueID]);
{$ENDIF}
  Result := InnerNodeIDFromMeta(AMeta);
end;

function TCustomBaseQipPlugin.NodeIDFromAccName(AccountName: WideString;
  ProtoHandle: Integer; AMeta: IMetaContact; MetaHasNode: Boolean): WideString;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants to get NodeID for Acc=%s Proto=%d MC=%d MetaHasNode=%s',
         [AccountName, ProtoHandle, Integer(@AMeta), BoolToStr(MetaHasNode, True)]);
{$ENDIF}
  Result := InnerNodeIDFromAccName(AccountName, ProtoHandle, AMeta, MetaHasNode);
end;

procedure TCustomBaseQipPlugin.RefreshNodes(Filter: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants plugin to re-add all the nodes with filter="%s"', [Filter]);
{$ENDIF}
  InnerRefreshNodes(Filter);
end;

function TCustomBaseQipPlugin.AccNodeIcon(NodeID: WideString): HICON;
begin
  Result := InnerAccNodeIcon(NodeID);
end;

function TCustomBaseQipPlugin.InnerAccNodeIcon(NodeID: WideString): HICON;
begin
  //nothing by default
  Result := 0;
end;

function TCustomBaseQipPlugin.InnerDeleteHist(NodeID: WideString): Boolean;
begin
  //nothing by default
  Result := False;
end;

procedure TCustomBaseQipPlugin.InnerGetHistInfo(NodeID: WideString; var TimeFmtStr: WideString;
  var NickBeforeTime, BreakBeforeMsg, HideMsgSeparators: Boolean);
begin
  //nothing by default
end;

function TCustomBaseQipPlugin.InnerHasHistory: Boolean;
begin
  Result := False;
end;

procedure TCustomBaseQipPlugin.InnerLoadHist(NodeID: WideString; IsMeta: Boolean);
begin
  //nothing by default
end;

function TCustomBaseQipPlugin.InnerNodeIDFromMeta(AMeta: IMetaContact): WideString;
begin
  //nothing by default
  Result := '';
end;

function TCustomBaseQipPlugin.InnerNodeIDFromAccName(AccountName: WideString;
  ProtoHandle: Integer; AMeta: IMetaContact; MetaHasNode: Boolean): WideString;
begin
  //nothing by default. Always return empty string if you do not want node to be added!
  Result := '';
end;

procedure TCustomBaseQipPlugin.InnerRefreshNodes(Filter: WideString);
begin
  //nothing by default
end;

function TCustomBaseQipPlugin.HistFile(NodeID: WideString): WideString;
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants to load history for NodeID=%s', [NodeID]);
{$ENDIF}
  Result := InnerHistFile(NodeID);
end;

function TCustomBaseQipPlugin.InnerHistFile(NodeID: WideString): WideString;
begin
  //nothing by default
  Result := '';
end;

procedure TCustomBaseQipPlugin.ExpandNode(NodeID, Filter: WideString);
begin
{$IFDEF LOGDEBUGINFO}
  LogFmt('core wants plugin to expand node %s with filter="%s"', [NodeID, Filter]);
{$ENDIF}
  InnerExpandNode(NodeID, Filter);
end;

procedure TCustomBaseQipPlugin.InnerExpandNode(NodeID, Filter: WideString);
begin
  //nothing by default
end;

function TCustomBaseQipPlugin.InnerMenuCaption(NodeID: WideString): WideString;
begin
  //by default return pluginname
  Result := FPluginInfo.PluginName;
end;

function TCustomBaseQipPlugin.MenuCaption(NodeID: WideString): WideString;
begin
  Result := InnerMenuCaption(NodeID);
end;

function TCustomBaseQipPlugin.HistorySavePath: WideString;
begin
  if CoreHistory <> nil then
  begin
    Result := CoreHistory.HistoryPath(MyHandle);
    Exit;
  end;
  //this is not fully working code, history can be located at another path
  Result := {$IF CompilerVersion <= 18.0}WideExtractFileName{$ELSE}ExtractFileName{$IFEND}(FullPluginPath);
  Result := Copy(Result, 1, Length(Result) - Length({$IF CompilerVersion <= 18.0}WideExtractFileExt{$ELSE}ExtractFileExt{$IFEND}(Result)));
  Result := GetQIPProfileDirectory + 'History\Plugins\' + Result + '\';
end;

procedure TCustomBaseQipPlugin.BlockCoreFade(FadeInfo: TFadeWndInfo; var Allow: LongBool);
begin
  //do not block by default
  //if Allow is already False - do not set to True if you are not sure about it
end;

procedure TCustomBaseQipPlugin.OnCoreSvcFade(var Message: TPluginMessage);
begin
{$IFDEF LOGDEBUGINFO}
  Log('core wants to show svc fade');
{$ENDIF}
  if (Message.WParam <> 0) then
  	BlockCoreFade(pFadeWndInfo(Message.WParam )^, LongBool(Message.Result));
end;

class function TCustomBaseQipPlugin.PatchFileName(const AFileName: WideString): WideString;
const
  DeniedSymbols: array[0..8] of WideString = ('>', '<', '|', '?', '*', '/', '\', ':', '"');
  AllowedSymbols: array[0..8] of WideString = ('Ы', 'Л', '¶', #$061F {обратный вопрос},
                                               #$066D, #$2044, '_', #$05C3, 'У');
var
  I: Integer;
begin
//«апрещены символы в Win Ђ>ї, Ђ<ї, Ђ|ї, Ђ?ї, Ђ*ї, Ђ/ї, Ђ\ї, Ђ:ї, Ђ"ї. «амен€ем на аналоги
  Result := AFileName;
  for I := 0 to 8 do
  {$IF CompilerVersion < 18.0}
    Result := Tnt_WideStringReplace(Result, DeniedSymbols[I], AllowedSymbols[I], [rfReplaceAll]);
  {$ELSE}
    Result := StringReplace(Result, DeniedSymbols[I], AllowedSymbols[I], [rfReplaceAll]);
  {$IFEND}
end;

procedure TCustomBaseQipPlugin.DetailsChanged(const AccountName: WideString;
  ProtoHandle: Integer);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.OnDetailsChanged(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
  begin
    {$IFDEF LOGDEBUGINFO}
      LogFmt('details for %s-%d has been changed', [PWideChar(WParam), LParam]);
    {$ENDIF}
    DetailsChanged(PWideChar(WParam), LParam);
  end;
end;

procedure TCustomBaseQipPlugin.GetActiveTab(var AccountName: WideString;
  var ProtoHandle, SubCount: Integer; FindFocused: Boolean);
var
  Acc, Proto, Subs: Integer;
begin
  Acc   := Integer(FindFocused);
  Proto := 0;
  Subs  := 0;
  VarSendPluginMessage(PM_PLUGIN_ACTIVE_MSG_TAB, Acc, Proto, Subs);
  //22.02.2012 fix bug : AccountName := PWideChar(True)
  if Proto <> 0 then
  begin
    ProtoHandle := Proto;
    if Acc <> 0 then
      AccountName := PWideChar(Acc);
  end;
  SubCount := Subs;
end;

procedure TCustomBaseQipPlugin.GetActiveChatTab(var ChatName, OwnNick,
  ChatCaption: WideString; var ProtoHandle: Integer);
var
  Chat, Nick, Caption, Proto: Integer;
begin
  Chat    := 0;
  Caption := 0;
  Nick    := 0;
  Proto   := VarSendPluginMessage(PM_PLUGIN_ACTIVE_CHAT_TAB, Chat, Nick, Caption);
  if Chat <> 0 then
    ChatName := PWideChar(Chat);
  if Caption <> 0 then
    ChatCaption := PWideChar(Caption);
  if Nick <> 0 then
    OwnNick := PWideChar(Nick);
  if Proto <> 0 then
    ProtoHandle := Proto;  
end;

procedure TCustomBaseQipPlugin.OnChatTabActivated(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) then
    ChatTabChanged(PWideChar(WParam), '', '', LParam, caActivate)
  {$IFDEF LOGDEBUGINFO}
  else
    LogSafe('incorrect data in TBaseQipPlugin.OnChatTabActivated');
  {$ENDIF};
end;

function WindowFromSameProcess(const wnd: HWND): Boolean;
var pid: DWORD;
begin
  GetWindowThreadProcessId(wnd, pid);
  Result := (pid = GetCurrentProcessId());
end;

function GetWindowClassW(wnd: HWND): WideString;
var
  AText: array[0..511] of WChar;
begin
  FillChar(AText, SizeOf(AText), #0);
  GetClassNameW(wnd, AText, 512);
  Result := AText;
end;

class function TCustomBaseQipPlugin.Obsolete_IsChatWindowActive: Boolean;
var
  wnd: HWND;
begin
  wnd    := GetForegroundWindow;
  Result := (GetWindowClassW(wnd) = 'TfrmChatMan.UnicodeClass'); //chat is foreground
  Result := Result and WindowFromSameProcess(wnd); //chat in self process
end;

procedure TCustomBaseQipPlugin.OnCLFilterChanged(var Message: TPluginMessage);
begin
  if Message.WParam <> 0 then FFilter := PWideChar(Message.WParam);
  {$IFDEF LOGDEBUGINFO}
  LogSafe('CL filter has been changed to "' + FFilter + '"');
  {$ENDIF}
  ContactListFilterChanged;
end;

procedure TCustomBaseQipPlugin.ContactListFilterChanged;
begin
  //nothing by default
end;

function TCustomBaseQipPlugin.AcceptFiles(const AccountName: WideString;
  const ProtoHandle: Integer; const FileInfo: TDropFilesInfo): Boolean;
begin
  //by default do not accept files
  Result := False;
end;

procedure TCustomBaseQipPlugin.CoreWantSendFiles(const FileInfo: TDropFilesInfo; var BlockTransfer: LongBool);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.OnAcceptFiles(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) and (LParam <> 0) and (NParam <> 0) then
  with PDropFilesInfo(NParam)^ do
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('Accept files from ' + PWideChar(WParam) + '/' + IntToStr(LParam));
    LogSafe('File info: ');
    LogSafe('Sending to chat: '  + BoolToStr(ToChat, True));
    LogSafe('FileCount: '        + IntToStr(FileCount));
    LogSafe('FileList: '         + FileList);
    LogSafe('AccountName: '      + AccountName);
    LogSafe('ProtoHandle: '      + IntToStr(ProtoHandle));
    LogSafe('Additional button data:' + IntToStr(DropBtnInfo.BtnData));
    {$ENDIF}
    if AcceptFiles(PWideChar(WParam), LParam, PDropFilesInfo(NParam)^) then
      Result := Byte(True); //DO NOT set to False if you are not sure that you really need this
  end;
end;

procedure TCustomBaseQipPlugin.OnWantSendFiles(var Message: TPluginMessage);
begin
  with Message do
  if (WParam <> 0) then
  with PDropFilesInfo(WParam)^ do
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('Core want to send file. Info: ');
    LogSafe('Drop to plugin button: ' + BoolToStr(Boolean(LParam), True));
    LogSafe('Sending to chat: '       + BoolToStr(ToChat, True));
    LogSafe('FileCount: '             + IntToStr(FileCount));
    LogSafe('FileList: '              + FileList);
    LogSafe('AccountName: '           + AccountName);
    LogSafe('ProtoHandle: '           + IntToStr(ProtoHandle));
    LogSafe('Additional button data:' + IntToStr(DropBtnInfo.BtnData));
    {$ENDIF}
    CoreWantSendFiles(PDropFilesInfo(WParam)^, LongBool(Result))
  end;
end;

function TCustomBaseQipPlugin.SendFiles(FileInfo: TDropFilesInfo; TypeOfUpload: Integer = SFT_CORE_DECIDES): Boolean;
begin
  Result := False;
  if GetRightsMask and PRM_FILE_SENDING_ALLOWED = PRM_FILE_SENDING_ALLOWED then
    Result := Boolean(SendPluginMessage(PM_PLUGIN_FILE_SEND, Integer(@FileInfo), TypeOfUpload, 0))
  else
    ShowFade(GetPluginInfo^.PluginName, GetLanguageString(LI_INSUFFICIENT_RIGHTS),
             PluginIcon, 2);
end;

function TCustomBaseQipPlugin.SendFiles(AccountName: WideString;
  ProtoHandle: Integer; FileList: WideString; ToChat: Boolean; TypeOfUpload: Integer): Boolean;
var FileInfo: TDropFilesInfo;
begin
  FileInfo.FileCount   := 1;//core can recalculate files count if needed. this field should not be 0
  FileInfo.FileList    := FileList;
  FileInfo.ToChat      := ToChat;
  FileInfo.AccountName := AccountName;
  FileInfo.ProtoHandle := ProtoHandle;
  Result := SendFiles(FileInfo, TypeOfUpload);
end;

function TCustomBaseQipPlugin.GetRightsMask: Integer;
begin
  Result := SendPluginMessage(PM_PLUGIN_GET_RIGHTS_MASK, 0, 0, 0);
end;

procedure TCustomBaseQipPlugin.AddMenuItems(const SelectedStr, SelectedURL: WideString;
  AddingToPicture: Boolean; var Items: TMenuItemsArray);
begin
  //nothing by default
  {//for example, we can add two items here if selected string starts from http
  if Pos('http://', SelectedStr) = 1 then
  begin
    SetLength(Items, 2);
    Items[0].ItemID   := 1;
    Items[0].ItemData := 0;
    Items[0].MenuCaption := 'menu1';
    Items[0].MenuIcon    := PluginIcon;
    Items[1].ItemID   := 2;
    Items[1].ItemData := 0;
    Items[1].MenuCaption := 'menu2';
    Items[1].MenuIcon    := PluginIcon;
  end;}
end;

procedure TCustomBaseQipPlugin.MenuItemClicked(const SelectedStr: WideString;
  const ItemID, ItemData: Integer; const PictureID: Integer = 0);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.AddCLMenuItems(const MetaContact: IMetaContact;
  ToMessageWindow: Boolean; var Items: TMenuItemsArray);
begin
  //nothing by default. actions are similar to AddMenuItems
end;

procedure TCustomBaseQipPlugin.CLMenuItemClicked(const MetaContact: IMetaContact;
  const ItemID, ItemData: Integer);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.OnMenuItemClick(var Message: TPluginMessage);
begin
  with Message do
  if (NParam <> 0) then
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('User clicked menu item for selected text: ' + PWideChar(NParam));
    LogSafe('ItemID is: '   + IntToStr(WParam));
    LogSafe('ItemData is: ' + IntToStr(LParam));
    LogSafe('PictureID is: ' + IntToStr(Result));
    {$ENDIF}
    MenuItemClicked(PWideChar(NParam), WParam, LParam, Result);
  end;
end;

procedure TCustomBaseQipPlugin.OnWantAddMenuItems(var Message: TPluginMessage);
var
  wURL: WideString;
begin
  with Message do
  if WParam <> 0 then
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('Core want to menu items for selected text: ' + PWideChar(WParam));
    {$ENDIF}
    SetLength(FMenuItems, 0);
    if LParam <> 0 then
      wURL := PWideChar(LParam);
    AddMenuItems(PWideChar(WParam), wURL, Boolean(NParam), TMenuItemsArray(FMenuItems));
    if Length(FMenuItems) > 0 then
    begin
      {$IFDEF LOGDEBUGINFO}
      LogSafe('Got menu items count: ' + IntToStr(Length(FMenuItems)));
      {$ENDIF}
      Result := Byte(True);
      LParam := Length(FMenuItems);
      NParam := Integer(@FMenuItems[0]);
    end;
  end;
end;

procedure TCustomBaseQipPlugin.OnCLMenuItemClick(var Message: TPluginMessage);
begin
  with Message do
  if (NParam <> 0) then
  begin
    {$IFDEF LOGDEBUGINFO}
    LogSafe('User clicked cl menu item');
    LogSafe('ItemID is: '   + IntToStr(WParam));
    LogSafe('ItemData is: ' + IntToStr(LParam));
    with pIMetaContact(NParam)^ do
      LogSafe('meta is: ' + MetaContactName + ' metaid: ' + IntToStr(UniqueID));
    {$ENDIF}
    CLMenuItemClicked(pIMetaContact(NParam)^, WParam, LParam);
  end;
end;

procedure TCustomBaseQipPlugin.OnWantAddCLMenuItems(var Message: TPluginMessage);
begin
  with Message do
  if WParam <> 0 then
  begin
    {$IFDEF LOGDEBUGINFO}
    with pIMetaContact(WParam)^ do
      LogSafe('Core want to add cl menu items for meta: ' + MetaContactName +
              ' metaid: ' + IntToStr(UniqueID) + '. Message Window?' +
              BoolToStr(Boolean(LParam), True));
    {$ENDIF}
    SetLength(FMenuItems, 0);
    AddCLMenuItems(pIMetaContact(WParam)^, Boolean(LParam), TMenuItemsArray(FMenuItems));
    if Length(FMenuItems) > 0 then
    begin
      {$IFDEF LOGDEBUGINFO}
      LogSafe('Got menu items count: ' + IntToStr(Length(FMenuItems)));
      {$ENDIF}
      Result := Byte(True);
      LParam := Length(FMenuItems);
      NParam := Integer(@FMenuItems[0]);
    end;
  end;
end;

procedure TCustomBaseQipPlugin.OnTabCreated(var Message: TPluginMessage);
begin
  if (Message.WParam <> 0) and (Message.LParam <> 0) then
    MessageTabCreated(Message.LParam, PWideChar(Message.WParam), Boolean(Message.NParam));
end;

procedure TCustomBaseQipPlugin.MessageTabCreated(const ProtoHandle: Integer;
  const AccountName: WideString; TabActivated: Boolean);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.OnUrlClick(var Message: TPluginMessage);
begin
  if (Message.WParam <> 0) and (Message.LParam <> 0) and (Message.NParam <> 0) then
    URLClicked(Message.LParam, PWideChar(Message.WParam), PWideChar(Message.NParam));
end;

procedure TCustomBaseQipPlugin.URLClicked(const ProtoHandle: Integer;
  const AccountName, URLText: WideString);
begin
  //nothing by default
end;

procedure TCustomBaseQipPlugin.ControlMedia(const AccountName: WideString;
  const ProtoHandle, PictureID, ControlCommand: Integer);
begin
  SendPluginMessage(PM_PLUGIN_MEDIA_CONTROL, LongInt(PWideChar(AccountName)),
                    ProtoHandle, PictureID, ControlCommand);
end;

procedure TCustomBaseQipPlugin.OnReadyForItem(var Message: TPLuginMessage);
begin
  MessageWindowReady;
end;

procedure TCustomBaseQipPlugin.MessageWindowReady;
{$IFnDEF WIDGET_FREEUNUSED}
var
  i: Integer;
  w: IWidget;
{$ENDIF}
begin
  //см. также TWidgetItem.SetState чтобы пон€ть когда виджет используетс€, а когда нет
{$IFnDEF WIDGET_FREEUNUSED}
  for i := 0 to FWidgets.Count-1 do
  begin
    //add widgets to Msg window
    w := FWidgets[i] as IWidget;
    if (w <> nil) and (w.WidgetClass = wgcMsg) then
      SendPluginMessage(PM_PLUGIN_WIDGET_ADD, Integer(w), 0, 0);
  end;
{$ELSE}
  {do nothing}
{$ENDIF}
end;

function TCustomBaseQipPlugin.Widgets_Add;
begin
  //w := TWidgetItem.Create(Self, AClass, AllowCompact);
  Result := (AWidget <> nil) and LongBool(SendPluginMessage(PM_PLUGIN_WIDGET_ADD, Integer(AWidget), 0, 0));
{$IFDEF WIDGET_FREEUNUSED}
  if Result then
{$ENDIF}
    FWidgets.Add(AWidget);
end;

function TCustomBaseQipPlugin.Widgets_Delete;
var
  w: IWidget;
begin
  w := Widgets_Get(ID);
  Result := w <> nil;
  if Result then
  begin
    Result := LongBool(SendPluginMessage(PM_PLUGIN_WIDGET_DEL, Integer(w), 0, 0));
    FWidgets.Delete(FWidgets.IndexOf(w));
  end;
end;

function TCustomBaseQipPlugin.Widgets_Get(ID: TWidgetID): IWidget;
var
  i: Integer;
  w: IWidget;
begin
  Result := nil;
  for i := 0 to FWidgets.Count - 1 do
  begin
    w := FWidgets[i] as IWidget;
    if (w <> nil) and (w.ID.wString = ID.wString) then
    begin
      Result := w;
      Exit;
    end;
  end;
end;

procedure TCustomBaseQipPlugin.Widgets_Invalidate;
var
  w: IWidget;
begin
  w := Widgets_Get(ID);
  if w <> nil then
    SendPluginMessage(PM_PLUGIN_WIDGET_INVALIDATE, Integer(w), 0, 0);
end;

procedure TCustomBaseQipPlugin.Widgets_InvalidateAll;
var
  w: IWidget;
  i: Integer;
begin
  for i := 0 to FWidgets.Count - 1 do
  begin
    w := FWidgets[i] as IWidget;
    if w <> nil then
      SendPluginMessage(PM_PLUGIN_WIDGET_INVALIDATE, Integer(w), 0, 0);
  end;
end;

function TCustomBaseQipPlugin.Widgets_ShowHint(): Boolean;
var
  w: IWidget;
  i: Integer;
begin
  Result := False;
  for i := 0 to FWidgets.Count - 1 do
  begin
    w := FWidgets[i] as IWidget;
    if (w <> nil) and (wgsHot in w.State) then
    begin
      Result := LongBool(SendPluginMessage(PM_PLUGIN_WIDGET_SHOW_HINT, Integer(w), 1, 1));
      if Result then Exit;
    end;
  end;
end;

procedure TCustomBaseQipPlugin.Widgets_HideHint;
var
  w: IWidget;
  i: Integer;
begin
  for i := 0 to FWidgets.Count - 1 do
  begin
    w := FWidgets[i] as IWidget;
    if w <> nil then
      SendPluginMessage(PM_PLUGIN_WIDGET_SHOW_HINT, Integer(w), 0, 0);
  end;
end;

procedure TCustomBaseQipPlugin.Widgets_InvalidateHint;
var
  w: IWidget;
begin
  w := Widgets_Get(ID);
  if w <> nil then
    SendPluginMessage(PM_PLUGIN_WIDGET_INV_HINT, Integer(w), 0, 0);
end;

procedure TCustomBaseQipPlugin.Widgets_DoMouseLeave;
var
  i: Integer;
begin
  for i := 0 to FWidgets.Count - 1 do
    (FWidgets[i] as IWidget).MouseLeave;
end;

procedure TCustomBaseQipPlugin.Widgets_Clear;
var
  i: Integer;
begin
  for i := FWidgets.Count - 1 downto 0 do
    Widgets_Delete((FWidgets[i] as IWidget).ID);    
  FWidgets.Clear;
end;

function TCustomBaseQipPlugin.Widgets_GetHotItem: IWidget;
var
  i: Integer;
  w: IWidget;
begin
  for i := 0 to FWidgets.Count - 1 do
  begin
    w := (FWidgets[i] as IWidget);
    if (w <> nil) and (wgsHot in w.State) then
    begin
      Result := w;
      Exit;
    end;
  end;
end;

function TCustomBaseQipPlugin.OnGetBBCodeHint(var Hint: WideString; var ShowR: TRect; const UniqueID, UserData: Integer): BOOL;
begin
  Result := False; //use old style hint by default
  {$IFDEF LOGDEBUGINFO}
  with ShowR do
  LogFmt('core requests hint bb-code and bounds: %d,%d %dx%d',
         [Left, Top, Right-Left, Bottom-Top]);
  {$ENDIF}
end;

procedure TCustomBaseQipPlugin.OnGetPluginHint(var Message: TPluginMessage);
var
  hd: pPluginBBHint;
begin
  {$IFDEF LOGDEBUGINFO}
  LogSafe('PM_PLUGIN_HINT_GET_BB request obtained');
  {$ENDIF}
  Message.Result := 0;
  hd := pPluginBBHint(Message.WParam);
  if (hd = nil) or (hd.cbSize < Sizeof(TPluginBBHint)) then Exit;
  if OnGetBBCodeHint(hd^.Hint, hd^.ShowRect, hd^.ContactID, hd^.PluginData) then
  begin
    Message.Result := 1;
    {$IFDEF LOGDEBUGINFO}
    LogFmt('new bb-code hint: %s', [hd^.Hint]);
    with ShowR do
      LogFmt('new hint bounds: %d,%d %dx%d',
             [Left, Top, Right-Left, Bottom-Top]);
    {$ENDIF}
  end;
end;

function TCustomBaseQipPlugin.CoreGUI: IQIPCoreGUI;
begin
  if FCoreGUI = nil then
    SendPluginMessage(PM_PLUGIN_GETGUI, Integer(@FCoreGUI), 0, 0);
  Result := FCoreGUI;
end;

function TCustomBaseQipPlugin.CoreUtils: IQIPUtils;
begin
  if FCoreUtils = nil then
  begin
    SendPluginMessage(PM_PLUGIN_GET_UTILS, Integer(@FCoreUtils), 0, 0);
    if FCoreUtils <> nil then
    begin
      FCoreUtils.AddSkinModule(GetSkinFN);
      u_string.InitializeIStrings(FCoreUtils.StringsGen);
    end;
  end;
  Result := FCoreUtils;
end;

function TCustomBaseQipPlugin.GetSkinFN: PWideChar;
begin
  Result := PWideChar(WideLowerCase(GetPluginInfo.DllPath));
end;

function TCustomBaseQipPlugin.GetSkinRes(ResID: WideString): WideString;
begin
  Result := SCHEMA_SKIN + '//' + GetSkinFN + ',' + ResID;
end;

procedure TCustomBaseQipPlugin.DrawSkinImage(ImageURI: WideString; DC: HDC; DrawRect: TRect);
begin
  if CoreUtils <> nil then
    CoreUtils.Draw.DrawSkinIm3(DC, DrawRect, ImageURI);
end;

function TCustomBaseQipPlugin.CreateTimer(Interval: Integer; Enabled: Boolean; OnTimer: TGUINotifyEvent): ITimer;
var
  Handler: TTimerEvents;
begin
  Handler := TTimerEvents.Create(OnTimer);
  CoreGUI.CreateControl(nil, ITimer, Result, Handler);
  Result.Interval := Interval;
  Result.Enabled  := Enabled;
end;

function TCustomBaseQipPlugin.SetProtoStatus(const ProtoHandle, Status,
  PrivacyStatus: Integer): Boolean;
begin
  Result := Boolean(SendPluginMessage(PM_PLUGIN_PROTO_STATUS_SET, ProtoHandle, Status, PrivacyStatus));
end;

{ TFadeList }

procedure TFadeList.AddFade(const ID: Integer; FadeInfo: TFadeWndInfo; Additional: Integer);
begin
  SetLength(FIds, Length(FIds) + 1);
  SetLength(FAdditional, Length(FAdditional) + 1);
  SetLength(FFadesInfo, Length(FFadesInfo) + 1);

  FIds[Length(FIds) - 1]               := ID;
  FAdditional[Length(FAdditional) - 1] := Additional;
  FFadesInfo[Length(FFadesInfo) - 1]   := FadeInfo;
end;

function TFadeList.AdditionalFromID(const ID: Integer): Integer;
var
  Index: Integer;
begin
  Result := 0;
  Index := GetOffset(ID);
  if Index >= 0 then
    Result := FAdditional[Index];
end;

constructor TFadeList.Create;
begin
  inherited;
  SetLength(FFadesInfo, 0);
  SetLength(FAdditional, 0);
  SetLength(FIds, 0);
end;

destructor TFadeList.Destroy;
begin
  SetLength(FFadesInfo, 0);
  SetLength(FAdditional, 0);
  SetLength(FIds, 0);
  inherited;
end;

function TFadeList.FadeInfoFromID(const ID: Integer): TFadeWndInfo;
var
  Index: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  Index := GetOffset(ID);
  if Index >= 0 then
    Result := FFadesInfo[Index];
end;

function TFadeList.GetOffset(ID: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(FIds) - 1 do
  if ID = FIds[I] then
  begin
    Result := I;
    Exit;
  end;
end;

procedure TFadeList.KillFade(const ID: Integer);
var
  Index: Integer;
begin
  Index := GetOffset(ID);
  if Index >= 0 then
  begin
    if Index < Length(FIds) - 1 then
    System.Move(FIds[Index + 1], FIds[Index],
      (Length(FIds) - 1 - Index) * SizeOf(Integer));
    SetLength(FIds, Length(FIds) - 1);

    if Index < Length(FAdditional) - 1 then
    System.Move(FAdditional[Index + 1], FAdditional[Index],
      (Length(FAdditional) - 1 - Index) * SizeOf(Integer));
    SetLength(FAdditional, Length(FIds) - 1);

    if Index < Length(FFadesInfo) - 1 then
    System.Move(FFadesInfo[Index + 1], FFadesInfo[Index],
      (Length(FFadesInfo) - 1 - Index) * SizeOf(TFadeWndInfo));
    SetLength(FFadesInfo, Length(FFadesInfo) - 1);
  end;
end;

{ TWidgetItem }

constructor TWidgetItem.Create(AOwner: TCustomBaseQipPlugin; AClass: TWidgetClass; AllowCompact: Boolean);
begin
  inherited Create();
  FOwner := AOwner;
  FClass := AClass;
  FID    := WideFormat('%s_%.8x', [FOwner.FPluginInfo.PluginName, FOwner.FWidgetIDCounter]);//! core sort widgets with Windows.CompareStringW
  Inc(FOwner.FWidgetIDCounter);

  FState := [wgsNormal];
  if AllowCompact then
    FAllowedStates := [wgsUnused, wgsNormal, wgsCompact, wgsHot]
  else
    FAllowedStates := [wgsUnused, wgsNormal, wgsHot];
end;

destructor TWidgetItem.Destroy;
begin
  FreeOwner;
  inherited;
end;

procedure TWidgetItem.FreeOwner;
begin
  FOwner := nil;
end;

//////////////////////

function TWidgetItem.GetClass: TWidgetClass;
begin
  Result := FClass;
end;

function TWidgetItem.GetID: TWidgetID;
begin
  Result := FOwner.CoreUtils.CreateIString;
  Result.SetString(FID);
end;

function TWidgetItem.GetState: TWidgetStateSet;
begin
  Result := FState;
end;

procedure TWidgetItem.SetState(v: TWidgetStateSet);
var
  i: TWidgetState;
begin
  FState := [];
  for i := Low(TWidgetState) to High(TWidgetState) do
    if (i in v) and (i in FAllowedStates) then
      Include(FState, i);
{$IFDEF WIDGET_FREEUNUSED}
  if (wgsUnused in FState) and (FOwner <> nil) then
    FOwner.Widgets_Delete(ID); //release plugin reference
{$ENDIF}
end;

function TWidgetItem.StateAllowed(const CheckState: TWidgetState): Boolean;
begin
  Result := CheckState in FAllowedStates;
end;

function TWidgetItem.IsCompact: Boolean;
begin
  Result := wgsCompact in State;
end;

//////////////////////

procedure TWidgetItem.Draw(const DC: HDC; DrawRect: TRect; MousePt: TPoint);
begin
  {do nothing}
end;

procedure TWidgetItem.DrawHint(const DC: HDC; DrawRect: TRect);
begin
  {do nothing}
end;

procedure TWidgetItem.Click(MousePt: TPoint);
begin
  {do nothing}
end;

procedure TWidgetItem.DoubleClick(MousePt: TPoint);
begin
  {do nothing}
end;

procedure TWidgetItem.MouseEnter;
begin
  State := State + [wgsHot];
end;

procedure TWidgetItem.MouseLeave;
begin
  State := State - [wgsHot];
end;

procedure TWidgetItem.MouseDown(MousePt: TPoint; Button: TMouseButton; ShiftState: TShiftState);
begin
  State := State + [wgsHot];
end;

procedure TWidgetItem.MouseMove(MousePt: TPoint; ShiftState: TShiftState);
begin
  State := State + [wgsHot];
end;

procedure TWidgetItem.MouseUp(MousePt: TPoint; Button: TMouseButton; ShiftState: TShiftState);
begin
  State := State + [wgsHot];
end;

function TWidgetItem.IsHot: Boolean;
var
  p: TPoint;
  r, gr: TRect;
  w: IWidget;
begin
  //довольно таки медленный код, поэтому используем его только когда нет другого выбора
  Result := False;
  r  := Rect(0,0,0,0);
  gr := Rect(0,0,0,0);
  if GetCursorPos(p) then
  begin
    w := Self;
    if (FOwner <> nil) and (FOwner.SendPluginMessage(PM_PLUGIN_WIDGET_GETBOUNDS, Integer(w), Integer(@r), Integer(@gr)) <> 0) then
      Result := PtInRect(r, p);
  end;
  if Result then
    State := State + [wgsHot]
  else
    State := State - [wgsHot];
end;

function TWidgetItem.Bounds: TRect;
var
  p: TPoint;
  r, gr: TRect;
  w: IWidget;
begin
  Result := Rect(0,0,0,0);
  r      := Rect(0,0,0,0);
  gr     := Rect(0,0,0,0);
  if GetCursorPos(p) then
  begin
    w := Self;
    if (FOwner <> nil) and (FOwner.SendPluginMessage(PM_PLUGIN_WIDGET_GETBOUNDS, Integer(w), Integer(@r), Integer(@gr)) <> 0) then
      Result := r;
  end;
end;

function TWidgetItem.ClientBounds: TRect;
var
  p: TPoint;
  r, gr: TRect;
  w: IWidget;
begin
  Result := Rect(0,0,0,0);
  r      := Rect(0,0,0,0);
  gr     := Rect(0,0,0,0);
  if GetCursorPos(p) then
  begin
    w := Self;
    if (FOwner <> nil) and (Owner.SendPluginMessage(PM_PLUGIN_WIDGET_GETBOUNDS, Integer(w), Integer(@r), Integer(@gr)) <> 0) then
    begin
      Result := r;
      if IsCompact then
        OffsetRect(Result, -gr.Left, -gr.Top)
      else
        OffsetRect(Result, -Result.Left, -Result.Top)
    end;
  end;
end;

function TWidgetItem.GetPluginHandle: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.FPluginInfo.DllHandle;
end;

procedure TWidgetItem.GetHintInfo(const DC: HDC; var W,
  H: Integer; var HintPos: TWidgetHintPos);
begin
  {do nothing}
end;

function QipPath: WideString;
var
  buf: array[0..MAX_PATH - 1] of WideChar;
begin
  Result := '';
  if GetModuleFileNameW(0, buf, MAX_PATH) <> 0 then
    Result := buf;

  if Result <> '' then
    Result := WideExtractFilePath(Result);
end;

{ TMainThreadSyncWnd }

constructor TMainThreadSyncWnd.Create;
begin
  inherited Create();
  FHandle := AllocateHWnd(WndProc);
  FOnSync := AOnSync;
  if GetCurrentThreadId <> MainThreadID then
    raise Exception.Create('Unable to create TMainThreadSyncWnd, wrong thread_id');
end;

procedure TMainThreadSyncWnd.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(FHandle, Msg, WParam, LParam);
end;

destructor TMainThreadSyncWnd.Destroy;
begin
  FOnSync := nil;
  DeallocateHWnd(FHandle);
  inherited;
end;

procedure TMainThreadSyncWnd.SyncProc(var Msg: TMessage);
begin
  if Assigned(FOnSync) then FOnSync(Self);
end;

procedure TMainThreadSyncWnd.WndProc(var Msg: TMessage);
begin
  Dispatch(Msg);
end;

procedure SetThreadName(szThreadName: AnsiString; threadId: dword);
type
  tagTHREADNAME_INFO = record
    dwType     : DWORD;  // must be 0x1000
    szName     : LPCSTR; // pointer to name (in user addr space)
    dwThreadID : DWORD;  // thread ID (-1=caller thread)
    dwFlags    : DWORD;  // reserved for future use, must be zero
  end;
var
  info: tagTHREADNAME_INFO;
begin
  if szThreadName <> '' then
  begin
    info.dwType     := $1000;
    info.szName     := PAnsiChar(szThreadName);
    info.dwThreadID := threadId;
    info.dwFlags    := 0;
    try
      RaiseException($406D1388, 0, sizeof(info) div sizeof(DWORD), @info);
    except end;
  end;
end;

{$IFNDEF NOFORMS}
{------------------------------------------------------------------------------}
var
  InfiHandle, OldHandle: HWND;

function EnumWindowsProc(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  pid: Cardinal;
begin
  Result := True;
  if (GetWindowClassW(hwnd) = 'TApplication') and WindowFromSameProcess(wnd) then
    InfiHandle := hwnd;
end;

function InfiumHandle: HWND; stdcall;
begin
  Result := 0;
  InfiHandle := 0;
  if EnumWindows(@EnumWindowsProc, 0) then
    Result := InfiHandle;
end;

initialization

  //this is for correct working of forms inside plugin purposes
  OldHandle := Application.Handle;
  Application.Handle := InfiumHandle;

finalization

  Application.Handle := OldHandle;
{$ENDIF}
end.

