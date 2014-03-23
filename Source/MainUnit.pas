unit MainUnit;



uses
  u_plugin_info, u_plugin_msg, u_common, u_BasePlugin, Classes;

const
  PLUGIN_VER_MAJOR = 1;
  PLUGIN_VER_MINOR = 0;
  PLUGIN_NAME      : WideString = 'Point.im support';
  PLUGIN_AUTHOR    : WideString = '@hohoho';
  PLUGIN_DESC      : WideString = 'Ya dawg, i heard you like point.im...';

type
  TQipPlugin = class(TBaseQipPlugin)
  private
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
  end;

implementation

uses
  RegExpr, Windows, SysUtils;

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
                       '[img alt="%0:s avatar" width=32 height=32]http://point.im/avatar/%0:s/80[/img]' +
                     '[/td]' +
                     '[td border=0 padding=0 padding-right=5 padding-left=5]' +
                       '[table border=0 cellspacing=0 padding-left=5]' +
                       '[tr padding=0]' +
                         '[td]' +
                         '[color=$00649D][url="plugin:%2:d" alt="PM @%0:s"][b]%0:s[/b][img alt="PM @%0:s"]skin://jabber_pics,816,#14[/img][/url][/color]' +
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
                 '[td]tags: %s[/td]' +
                 '[/tr]';

procedure TQipPlugin.TransformMessage(const AMessage: TQipMsgPlugin; var ChangeMessageText: WideString);
var
  I: Integer;
  firstLine, user, tags, replacePattern: WideString;
begin
  ChangeMessageText := TrimLeft(AMessage.MsgText);

  if (Pos('������� ���������', ChangeMessageText) = 1) or
     (Pos('Offline message', ChangeMessageText) = 1) then
  begin
    I := Pos(#13#10, ChangeMessageText);
    if I > 0 then
      Delete(ChangeMessageText, 1, I + 1);

    ChangeMessageText := TrimLeft(ChangeMessageText);
  end;

  firstLine := Copy(ChangeMessageText, 1, Pos(#13#10, ChangeMessageText) - 1);
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
    
  //���� ��� ����� ���� ����� � ��� ���� ���� - ������������ �� ��� � ������ ��������
  if ExecRegExpr('(?igr)\*[^\*\r\n]+', firstLine) then
  begin
    if user <> '' then
      replacePattern := '[url="http://' + user + '.point.im?tag=$1"]$0[img]skin://graph,228[/img][/url]'
    else
      replacePattern := '[url="http://point.im?tag=$1"]$0[img]skin://graph,228[/img][/url]';

    with TRegExpr.Create do
    try
      Expression := '(?igr)\*([^\*\r\n]+)';
      if Exec(firstLine) then
      repeat
        if user <> '' then
          tags := tags + WideFormat('[url="http://' + user + '.point.im?tag=%s"]%s[img]skin://graph,228[/img][/url]', [Match[1], Match[0]])
        else
          tags := tags + WideFormat('[url="http://point.im?tag=%s"]%s[img]skin://graph,228[/img][/url]', [Match[1], Match[0]]);
      until not ExecNext;
    finally
      Free;
    end;
  end;

  //����� � ������ � ���������������
  ChangeMessageText := ReplaceRegExpr('(?igr)(@([\w\-@\.]+):?)', ChangeMessageText,
                                      '[img width=16 height=16 alt="$2 avatar"]http://point.im/avatar/$2/80[/img]' +
                                      '[url="http://$2.point.im"]$2[img]skin://graph,228[/img][/url]', True);

  //��������������� ��� ����� � ��������
  ChangeMessageText := ReplaceRegExpr('(?igr)((\s)#([\d\w\/]+) ?(http\:\/\/point.im\/([\d\w#]+))?)', ChangeMessageText,
                                      WideFormat('[url="plugin:%d"]$2#$3[/url][url="http://point.im/$3"][img]skin://graph,228[/img][/url]', [MyHandle]), True);
  //������ ���� �� ��������, ��� ��� �� / � #
  ChangeMessageText := ReplaceRegExpr('(?igr)\[url=\"http\:\/\/point.im\/([\d\w#]+)/(\d+)', ChangeMessageText,
                                      '[url="http://point.im/$1#$2', True);

  //����������� ��� ���� � ������
  ChangeMessageText := ReplaceRegExpr('(?igr)\*([^\*\s]+)', ChangeMessageText, '[url="http://point.im?tag=$1"]$0[img]skin://graph,228[/img][/url]', True);

  //������ Recommended by �������������� � ����������
  ChangeMessageText := Tnt_WideStringReplace(ChangeMessageText, 'Recommended by', '[img alt="Recommended by"]skin://jabber_pics,838,#14[/img]', [rfReplaceAll]);

  //������ ������ �������� �����
  ChangeMessageText := Tnt_WideStringReplace(ChangeMessageText, #13#10#13#10, #13#10, [rfReplaceAll]);

  if user <> '' then
  begin
    if tags <> '' then
      tags := WideFormat(TagsTemplate, [tags]);
    ChangeMessageText := WideFormat(PostTemplate, [user, ChangeMessageText, MyHandle, tags]);
  end
  else
    ChangeMessageText := firstLine + #13#10 + ChangeMessageText;
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
  if WideFileExists(HistorySavePath + 'p@point.im.phf') then
    Result := AccountName + IntToStr(ProtoHandle);
end;

function TQipPlugin.InnerNodeIDFromMeta(AMeta: IMetaContact): WideString;
begin
  if AMeta = nil then Exit;

  Result := '';
  if WideFileExists(HistorySavePath + 'p@point.im.phf') then
    Result := IntToStr(AMeta.UniqueID);
end;

function TQipPlugin.InnerHasHistory: Boolean;
begin
  Result := True;
end;

function TQipPlugin.InnerHistFile(NodeID: WideString): WideString;
begin
  Result := 'p@point.im';
end;

end.