{ TPopupExPluginExtender }
function TPopupExPluginExtender.VarSendMessageToPlugin(const PluginHandle: Integer; var LParam, NParam: Integer): Integer;
var
	t: Integer;
begin
{$IFDEF LOGDEBUGINFO}
  LogSafe('plugin wants to send message to another plugin:');
  LogFmt('PluginHandle %d($%.8x) LParam %d($%.8x) NParam %d($%.8x) Result %d($%.8x)',
         [PluginHandle, PluginHandle, LParam, LParam, NParam, NParam, Result, Result]);
{$ENDIF}
	t := PluginHandle;
  Result := VarSendPluginMessage(PM_PLUGIN_MESSAGE, t, LParam, NParam);
end;

function TPopupExPluginExtender.CloseFade(const FadeID: Integer): Boolean;
var
	l,n: Integer;
  pexData: TPEXHide;
begin
	if pexConnected then
  begin
    l := CPEX_MSG_HIDEFADE;
    pexData.FadeID := FadeID;
    pexData.CloseNow := false;
    n := INTEGER(@pexData);
    VarSendMessageToPlugin(pexInfo.DllHandle, l, n);
    result := (l <> CPEX_RC_FALSE);
  end else
  begin
  	//rollback to qip standard popup
    result := inherited CloseFade(FadeID);
  end;
end;

constructor TPopupExPluginExtender.Create(const PluginService: IQIPPluginService);
begin
  inherited;
  pexConnected := false;
  FillChar(pexInfo, SizeOF(pexInfo), #0);
  FFades := nil;
end;

procedure TPopupExPluginExtender.DeleteFade(index: Integer; bCloseFade: Boolean);
begin
	try
  	if bCloseFade then
		  CloseFade(pPEXShow(FFades[index]).ClientData);
    Dispose(pPEXShow(FFades[index]));
		FFades.Delete(index);
  finally
  end;
end;

procedure TPopupExPluginExtender.EnumPluginsCallback(const EnumInfo: TPluginInfo;
  const PluginEnabled, IsLastEnumPlugin: Boolean);
var
	l,n,rc: Integer;
  b: Boolean;
begin
  inherited;
	if PluginEnabled and (WideCompareText(EnumInfo.PluginName, CPEX_DLLNAME) = 0) then
  begin
    l := CPEX_MSG_TEST;
    n := CPEX_VERSION;
   	rc := VarSendMessageToPlugin(EnumInfo.DllHandle, l, n);
    b := (rc > 0) and (l <> CPEX_RC_FALSE);
    if b then
    begin
    	if (EnumInfo.PlugVerMajor > pexInfo.PlugVerMajor) or (EnumInfo.PlugVerMinor > pexInfo.PlugVerMinor)
      	then pexInfo := EnumInfo;
      pexConnected := true;
    end;
  end;
end;

procedure TPopupExPluginExtender.FinalPlugin;
begin
  if assigned(FFades) then
  begin
  	//PEX не всегда уведомляет плагин о закрытии всплывалки (при аварийном отключении например)
    while FFades.Count > 0 do
      DeleteFade(FFades.Count-1);
    FreeAndNIL(FFades);
    pexConnected := false;
  end;
  inherited;
end;

function TPopupExPluginExtender.IndexOfFade(const FadeID: Integer): Integer;
var
	i: Integer;
begin
	result := -1;
	for i := FFades.Count - 1 downto 0 do
  	if pPEXShow(FFades[i]).ClientData = FadeID then
    begin
      result := i;
      exit;
    end;
end;

procedure TPopupExPluginExtender.InitPlugin;
begin
  inherited;
  pexConnected := false;
  FillChar(pexInfo, SizeOF(pexInfo), #0);
	FFades := TList.Create;

 	pexConnect;
end;

function TPopupExPluginExtender.pexConnect: Boolean;
begin
  result := pexConnected;
	if result then exit;

  FillChar(pexInfo, SizeOF(pexInfo), #0);
  EnumeratePlugins;

  result := pexConnected;
end;

function TPopupExPluginExtender.pexFadeClicked(const pme: pPEXMouseEvent;
  const FadeIndex: Integer): Integer;
begin
	result := CPEX_RC_FALSE;

  case pme.WM_MOUSE_MSG of
  WM_LBUTTONUP:
    if(pme.itemID = 'close') then
    begin
      FadeClicked(pme.FadeID);
    	if FadeIndex >= 0
      	then DeleteFade(FadeIndex)
        else CloseFade(pme.FadeID); //oO чужая всплывалка ? 
      Result := CPEX_RC_HANDLED;
    end;
  else
  end;
end;

procedure TPopupExPluginExtender.PluginMessageReceived(var LParam, NParam,
  AResult: Integer);
var
	pme: pPEXMouseEvent;
  pce: pPEXClosed;
  index: Integer;
begin
  inherited;

  case LOWORD(LParam) of
	CPEX_MSG_FADECLOSED:
  	begin
    	pce := pPEXClosed(NParam);
      index := IndexOfFade(pce.FadeID);
      if index >= 0 then 
      	DeleteFade(index, false);
    end;

  CPEX_MSG_MOUSEEVENT:
  	begin
    	LParam := CPEX_RC_OK;
      
      //pex processing
      pme := pPEXMouseEvent(NParam);
      AResult := pexFadeClicked(pme, IndexOfFade(pme.FadeID));

      //base plugin processing
      if AResult = CPEX_RC_FALSE then
      	FadeClicked(pPEXMouseEvent(NParam).FadeID);
    end;
  else
    AResult := CPEX_RC_FALSE;
  end;
end;


function TPopupExPluginExtender.ShowFade(const APEXFlags: DWORD; const FadeInfo: TFadeWndInfo; const AProtoHandle: Integer; const AAccName: WideString): Integer;
var
	l,n,rc: Integer;
  pexData: TPEXShow;
  p: pPEXShow;
begin
	result := 0;

  FillChar(pexData, SizeOF(pexData), #0);
  pexData.QipFade := FadeInfo;

  if not pexConnected then
   	pexConnect;
  
	if pexConnected then
  begin
    l := CPEX_MSG_SHOWFADE;
    pexData.Flags := APEXFlags;
    pexData.CallbackDllHandle := MyHandle;
    pexData.UseProtoHandle := AProtoHandle;
    pexData.UseAccName := AAccName;
    pexData.AvatarImage := '';

    n := INTEGER(@pexData);
    rc := VarSendMessageToPlugin(pexInfo.DllHandle, l, n);
    if (rc <> 0) and (l <> CPEX_RC_FALSE) then
      result := rc;
  end else
  begin
  	//rollback to qip standard popup
    result := inherited ShowFade(FadeInfo);
  end;

  if result <> 0 then
  begin
    New(p);
    FFades.Add(p);
    p^ := pexData;
    p.ClientData := result;
  end;
end;

function TPopupExPluginExtender.ShowFade(const FadeInfo: TFadeWndInfo): Integer;
begin
	result := ShowFade(CPEX_FLAG_Sender_Plugin or CPEX_FLAG_DataType_Empty, FadeInfo, 0, '');
end;

function TPopupExPluginExtender.ShowFade(const AFadeTitle,
  AFadeText: WideString; const AFadeIcon: HICON; const AFadeType: Integer;
  const ATextCentered, ANoAutoClose: Boolean): Integer;
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
	result := ShowFade(aFadeWnd);
end;

function TPopupExPluginExtender.ShowFade(const APEXFlags: DWORD; const AFadeTitle,
  AFadeText: WideString; const AFadeIcon: HICON; const AFadeType: Integer;
  const ATextCentered, ANoAutoClose: Boolean; 
  const AProtoHandle: Integer;
  const AAccName: WideString): Integer;
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
	result := ShowFade(APEXFlags, aFadeWnd, AProtoHandle, AAccName);
end;

