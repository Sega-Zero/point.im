unit MainUnit;


interface

uses
  u_plugin_info, u_plugin_msg, u_common, u_BasePlugin, Classes, Windows;

const
  PLUGIN_VER_MAJOR = 1;
  PLUGIN_VER_MINOR = 5;
  PLUGIN_NAME      : WideString = 'Point.im support';
  PLUGIN_AUTHOR    : WideString = '@hohoho';
  PLUGIN_DESC      : WideString = 'Ya dawg, i heard you like point.im...';

type
  TQipPlugin = class(TBaseQipPlugin)
  private
    FPlugIco: HICON;
    FSelectedURL: WideString;
    procedure TransformMessage(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString);
  public
    procedure GetPluginInformation(var VersionMajor: Word; var VersionMinor: Word;
                                   var PluginName: PWideChar; var Creator: PWideChar;
                                   var Description: PWideChar; var Hint: PWideChar); override;

    function MessageReceived(const AMessage: TQipMsgPlugin;
      var ChangeMessageText: WideString): Boolean; override;
    function MessageSending(const AMessage: TQipMsgPlugin;
      var ChangeMessageText: WideString): Boolean; override;

    procedure URLClicked(const ProtoHandle: Integer;
      const AccountName: WideString; const URLText: WideString); override;

    function InnerNodeIDFromAccName(AccountName: WideString;
      ProtoHandle: Integer; AMeta: IMetaContact = nil;
      MetaHasNode: Boolean = False): WideString; override;
    function InnerNodeIDFromMeta(AMeta: IMetaContact): WideString;
      override;
    function InnerHasHistory: Boolean; override;
    function InnerHistFile(NodeID: WideString): WideString; override;
    // Super icon (thx for @arts)
    function PluginIcon: HICON; override;

    constructor Create(const PluginService: IQIPPluginService);
    destructor Destroy; override;

    procedure AddMenuItems(const SelectedStr: WideString;
      const SelectedURL: WideString; AddingToPicture: Boolean;
      var Items: TMenuItemsArray); override;
    procedure MenuItemClicked(const SelectedStr: WideString;
      const ItemID: Integer; const ItemData: Integer;
      const PictureID: Integer = 0); override;
  end;

implementation

uses
  RegExpr, SysUtils;

{$I widecode.inc}

procedure TQipPlugin.GetPluginInformation(var VersionMajor,
  VersionMinor: Word; var PluginName, Creator, Description,
  Hint: PWideChar);
begin
  inherited;
  VersionMajor := PLUGIN_VER_MAJOR;
  VersionMinor := PLUGIN_VER_MINOR;
  Creator      := PWideChar(PLUGIN_AUTHOR);
  PluginName   := PWideChar(PLUGIN_NAME);
  Hint         := PWideChar(PLUGIN_NAME);
  Description  := PWideChar(PLUGIN_DESC);
end;

const
  //[0=user, 1=text, 2=handle, 3=tags]
  PostTemplate = '[table border=0 cellspacing=0 cellpadding=0]' +
                   '[tr]' +
                     '[td border=0 padding=0 width=34 padding-left=3]' +
                       '[img alt="@%0:s avatar" width=32 height=32]https://point.im/avatar/%0:s/80[/img]' +
                     '[/td]' +
                     '[td border=0 padding=0 padding-right=5 padding-left=5]' +
                       '[table border=0 cellspacing=0 padding-left=5]' +
                       '[tr padding=0]' +
                         '[td]' +
                         '[color=$00649D][url="plugin:%2:d" alt="PM @%0:s"][b]@%0:s[/b][img alt="PM @%0:s"]skin://jabber_pics,816,#14[/img][/url][/color]' +
                         '[/td]' +
                       '[/tr]' +
                       '%3:s' +
                       '[tr padding=0]' +
                         '[td]%1:s[/td]' +
                       '[/tr]' +
                       '[/table]' +
                     '[/td]' +
                   '[/tr]' +
                 '[/table]';
  TagsTemplate = '[tr padding=0  backcolor=$CCE5FF]' +
                 '[td]%s[/td]' +
                 '[/tr]';

procedure TQipPlugin.TransformMessage(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString);
var
  I: Integer;
  firstLine, user, tags: WideString;
begin
  firstLine := AMessage.MsgText;
  ChangeMessageText := TrimLeft(firstLine);

  if (Pos(WideString('Оффлайн сообщение'), ChangeMessageText) = 1) or
     (Pos(WideString('Offline message'), ChangeMessageText) = 1) then
  begin
    I := Pos(WideString(#13#10), ChangeMessageText);
    if I > 0 then
      Delete(ChangeMessageText, 1, I + 1);

    ChangeMessageText := TrimLeft(ChangeMessageText);
  end;

  firstLine := Copy(ChangeMessageText, 1, Pos(WideString(#13#10), ChangeMessageText) - 1);
  Delete(ChangeMessageText, 1,Length(firstLine));
  ChangeMessageText := TrimLeft(ChangeMessageText);

  user := '';
  with TRegExpr.Create do
  try
    Expression := '(?igr)\A(@([\w\-@\.]+):?)';
    if Exec(firstLine) then
      user := match[2];
  finally
    Free;
  end;
    
  //если это новый пост юзера и там есть теги - подсвечиваем их там с учётом пробелов
  if ExecRegExpr('(?igr)\*[^\*\r\n]+', firstLine) then
  begin
    with TRegExpr.Create do
    try
      Expression := '(?igr)\*([^\*\r\n]+)';
      if Exec(firstLine) then
      repeat
        if user <> '' then
          tags := tags + WideFormat('[url="https://' + user + '.point.im?tag=%s"]%s[img]skin://graph,228[/img][/url]', [Match[1], Match[0]])
        else
          tags := tags + WideFormat('[url="https://point.im?tag=%s"]%s[img]skin://graph,228[/img][/url]', [Match[1], Match[0]]);
      until not ExecNext;
    finally
      Free;
    end;
  end;
  // If no tags found in the first line
  //else
  //begin
  //  ChangeMessageText := firstLine + #13#10 + ChangeMessageText;
  //end;

  if user = '' then
     ChangeMessageText := Trim(firstLine + #13#10 + ChangeMessageText);

  //строку "@user recommended your post #post" трансформируем в строку с картиночкой
  // TODO: Сделать обработку через хендлер кликабельных ссылок
  //MessageBox(0, PChar(ChangeMessageText), PChar('debug'), MB_ICONINFORMATION + MB_OK);
  ChangeMessageText := ReplaceRegExpr('(?igr)@([\w\-]+)\srecommended\syour\s(post|comment)\s\#(\w+(\/\d+)?)(\:)?(\n(.+)\s\((\#\w+\/\d+)\))?(\n(https?\:\/\/[\w\.\%\-\/^\s\#^\s^\n\$]+))?', ChangeMessageText,
                                      '@$0[img alt="Recommended"]skin://jabber_pics,838,#14[/img] #$2 (#$7)' + #13#10 + '$6' + #13#10 + '$9', True);

  //юзеры в тексте с микроаватарками
  ChangeMessageText := ReplaceRegExpr('(?igr)(@([\w\-@\.]+):?)', ChangeMessageText,
                                      '[img width=16 height=16 alt="@$2 avatar"]https://point.im/avatar/$2/80[/img]' +
                                      '[url="https://$2.point.im"]@$2[img]skin://graph,228[/img][/url]', True);

  //преобразовываем все посты в кликабле
  ChangeMessageText := ReplaceRegExpr('(?igr)((\s|Comment |Post |Private post |Комментарий |Пост |Приватный пост )#([\d\w\/]+) ?(is added.\r\n|is sent.\r\n|отправлен.\r\n|добавлен.\r\n|)?(https?\:\/\/point.im\/([\d\w#]+))?)', ChangeMessageText,
                                      WideFormat('$2[url="plugin:%d"]#$3[/url][url="https://point.im/$3"][img]skin://graph,228[/img][/url] $4', [MyHandle]), True);

  //преобразуем все теги в тексте
  ChangeMessageText := ReplaceRegExpr('(?igr)\*([^\*\s]+)', ChangeMessageText, '[url="https://point.im?tag=$1"]$0[img]skin://graph,228[/img][/url]', True);

  // Replacing images
  ChangeMessageText := ReplaceRegExpr('(?igr)(https?\:\/\/[\w\.\%\-\/^\s\@\&\=]+?\.(jpg|jpeg|png|gif))', ChangeMessageText, #13#10 + '[url=$0][img]$0[/img][/url]' + #13#10, True);

  // Markdown links
  ChangeMessageText := ReplaceRegExpr('(?igr)\[([^\]]+)\]\((\w+?\:(\/\/)?[\w\.\%\-\/^\s\#\@\&\?\=\:]+)(\s\"(.*?)\")?\)?', ChangeMessageText, '[url=$2]$1[/url]', True);

  //строку "Recommended by" трансформируем картинку
  ChangeMessageText := Tnt_WideStringReplace(ChangeMessageText, 'Recommended by', '[img alt="Recommended by"]skin://jabber_pics,838,#14[/img]', [rfReplaceAll]);

  //фиксим урлы на комменты, ибо там не / а #
  ChangeMessageText := ReplaceRegExpr('(?igr)\[url=\"https?\:\/\/point.im\/([\d\w#]+)/(\d+)', ChangeMessageText,
                                      '[url="https://point.im/$1#$2', True);
  //теперь лишние переводы строк
  ChangeMessageText := Tnt_WideStringReplace(ChangeMessageText, #13#10#13#10, #13#10, [rfReplaceAll]);

  if user <> '' then
  begin
    if tags <> '' then
      tags := WideFormat(TagsTemplate, [tags]);
    ChangeMessageText := WideFormat(PostTemplate, [user, ChangeMessageText, MyHandle, tags]);
  end
end;

function TQipPlugin.MessageReceived(const AMessage: TQipMsgPlugin;
  var ChangeMessageText: WideString): Boolean;
var
  FS: Int64;
  aPath: WideString;
begin
  Result := True;//do not block messages
  if AMessage.SenderAcc = 'p@point.im' then
  begin
    if CoreHistory <> nil then
      CoreHistory.AddToHistory(MyHandle, 'p@point.im', AMessage.SenderNick, False, AMessage.MsgText, FS, aPath);
    TransformMessage(AMessage, ChangeMessageText);
  end;
end;
  
function TQipPlugin.MessageSending(const AMessage: TQipMsgPlugin;
  var ChangeMessageText: WideString): Boolean;
var
  FS: Int64;
  aPath: WideString;
begin
  Result := True;
  if AMessage.RcvrAcc = 'p@point.im' then
  begin
    if CoreHistory <> nil then
      CoreHistory.AddToHistory(MyHandle, 'p@point.im', AMessage.RcvrNick, True, AMessage.MsgText, FS, aPath);
  end;
end;

procedure TQipPlugin.URLClicked(const ProtoHandle: Integer;
  const AccountName, URLText: WideString);
var
  cmd: WideString;
  FoundInfo: TPluginInfo;
  Enabled: Boolean;
begin
  cmd := URLText;
  if cmd <> '' then
  begin
    if (cmd[1] <> '#') and (Copy(cmd,1,3) <> 'PM ') then
      cmd := 'PM ' + cmd;
    FindPlugin('sdkhelper', FoundInfo, Enabled);
    if Enabled and (FoundInfo.DllHandle <> 0) then
    begin
      SendMessageToPlugin(FoundInfo.DllHandle, 1, Integer(PWideChar(cmd)), 0);
      OpenTab(AccountName, ProtoHandle);
    end;
  end;
end;

function TQipPlugin.InnerNodeIDFromAccName(AccountName: WideString;
  ProtoHandle: Integer; AMeta: IMetaContact;
  MetaHasNode: Boolean): WideString;
begin
  Result := '';
  if MetaHasNode then Exit;
  if (AccountName = 'p@point.im') and WideFileExists(HistorySavePath + 'p@point.im.phf') then
    Result := 'p@point.im';
end;

function TQipPlugin.InnerNodeIDFromMeta(AMeta: IMetaContact): WideString;
var
  i: Integer;
begin
  if AMeta = nil then Exit;

  Result := '';
  if WideFileExists(HistorySavePath + 'p@point.im.phf') then
  for i := 0 to AMeta.Count - 1 do
    if AMeta.Contact(i).AccountName = 'p@point.im' then
    begin
      Result := 'p@point.im';
      Exit;
    end;
end;

function TQipPlugin.InnerHasHistory: Boolean;
begin
  Result := True;
end;

function TQipPlugin.InnerHistFile(NodeID: WideString): WideString;
begin
  if NodeID = 'p@point.im' then
    Result := 'p@point.im'
  else
    Result := '';
end;

// Super icon (thx for @arts)
constructor TQipPlugin.Create(const PluginService: IQIPPluginService);
begin
  inherited;
  FPlugIco := LoadImageW(HInstance, 'PLUGINICON', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
end;

destructor TQipPlugin.Destroy;
begin
  DeleteObject(FPlugIco);
  FPlugIco := 0;
  inherited;
end;

function TQipPlugin.PluginIcon: HICON;
begin
  Result := FPlugIco;
end;

procedure TQipPlugin.AddMenuItems(const SelectedStr,
  SelectedURL: WideString; AddingToPicture: Boolean;
  var Items: TMenuItemsArray);
var
  AccountName: WideString;
  Proto, SubCount: Integer;
begin
  inherited;
  GetActiveTab(AccountName, Proto, SubCount);
  if not AddingToPicture and (AccountName = 'p@point.im') then
  begin
    FSelectedURL := SelectedURL;

    //user
    if ExecRegExpr('(?igr)(@([\w\-@\.]+):?)', SelectedURL) then
    begin
      SetLength(Items, 1);
      Items[0].ItemID := 0;
      Items[0].ItemData := Proto;
      Items[0].MenuCaption := 'PM';
      Items[0].MenuIcon := PluginIcon;
      Items[0].Enabled := True;
    end;

    //thread
    if ExecRegExpr('(?igr)#([\d\w\/]+)', SelectedURL) then
    begin
      SetLength(Items, 1);
      Items[0].ItemID := 0;
      Items[0].ItemData := Proto;
      Items[0].MenuCaption := 'Recommend';
      Items[0].MenuIcon := PluginIcon;
      Items[0].Enabled := True;
    end;
  end;
end;

procedure TQipPlugin.MenuItemClicked(const SelectedStr: WideString;
  const ItemID, ItemData, PictureID: Integer);
var
  AccountName, cmd: WideString;
  Proto, SubCount: Integer;

  FoundInfo: TPluginInfo;
  Enabled: Boolean;
begin
  GetActiveTab(AccountName, Proto, SubCount);

  //thread
  if ExecRegExpr('(?igr)#([\d\w\/]+)', FSelectedURL) then
  case ItemID of
    0: SendIM(Proto, AccountName, '! ' + FSelectedURL);
  end;

  //user
  if ExecRegExpr('(?igr)(@([\w\-@\.]+):?)', FSelectedURL) then
  case ItemID of
    0:
    begin
      FindPlugin('sdkhelper', FoundInfo, Enabled);
      if Enabled and (FoundInfo.DllHandle <> 0) then
      begin
        cmd := 'PM ' + FSelectedURL;
        SendMessageToPlugin(FoundInfo.DllHandle, 1, Integer(PWideChar(cmd)), 0);
        OpenTab(AccountName, FoundInfo.DllHandle);
      end;
    end;
  end;
end;

end.