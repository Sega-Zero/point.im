unit u_gui_graphics;

interface
uses
  Windows, Types, u_gui_const, u_string, u_gui_intf;

type
  TColor = u_gui_const.TColor;

var
  SCREEN_PPI : DWORD = 96; //screen pixels per inch

const
  SCREEN_FONT_NAME : WideString = 'Tahoma'; //default font name
  SCREEN_FONT_SIZE = 8;  //default font size
  SCREEN_ICON      = 16; //small icon
  SCREEN_ICON32    = 32; //big icon

  CL_PADDING_X     = 5; //contact list X padding
  CL_PADDING_Y     = 1; //contact list Y padding
  CL_TEXT_PADDING  = 4; //text padding


const
  SCHEMA_SKIN           : WideString = 'skin:';      //skin://graph,#1,ico
  SCHEMA_SKIN_FILE      : WideString = 'skin-file:'; //загрузка вне очереди (синхронная)

  DEFAULT_SKIN_RESOURCE : WideString = 'skin://graph,%d';
  ICQ_SKIN_RESOURCE     : WideString = 'skin://icq_pics,%d';
  MRA_SKIN_RESOURCE     : WideString = 'skin://mra_pics,%d,ico';
  IRC_SKIN_RESOURCE     : WideString = 'skin://irc_pics,%d,ico';
  JAB_SKIN_RESOURCE     : WideString = 'skin://jabber_pics,%d,#14';
  SOC_SKIN_RESOURCE     : WideString = 'skin://social_pics,%d,#14';

const
  clSystemColor = $FF000000;

  clScrollBar = TColor(clSystemColor or COLOR_SCROLLBAR);
  clBackground = TColor(clSystemColor or COLOR_BACKGROUND);
  clActiveCaption = TColor(clSystemColor or COLOR_ACTIVECAPTION);
  clInactiveCaption = TColor(clSystemColor or COLOR_INACTIVECAPTION);
  clMenu = TColor(clSystemColor or COLOR_MENU);
  clWindow = TColor(clSystemColor or COLOR_WINDOW);
  clWindowFrame = TColor(clSystemColor or COLOR_WINDOWFRAME);
  clMenuText = TColor(clSystemColor or COLOR_MENUTEXT);
  clWindowText = TColor(clSystemColor or COLOR_WINDOWTEXT);
  clCaptionText = TColor(clSystemColor or COLOR_CAPTIONTEXT);
  clActiveBorder = TColor(clSystemColor or COLOR_ACTIVEBORDER);
  clInactiveBorder = TColor(clSystemColor or COLOR_INACTIVEBORDER);
  clAppWorkSpace = TColor(clSystemColor or COLOR_APPWORKSPACE);
  clHighlight = TColor(clSystemColor or COLOR_HIGHLIGHT);
  clHighlightText = TColor(clSystemColor or COLOR_HIGHLIGHTTEXT);
  clBtnFace = TColor(clSystemColor or COLOR_BTNFACE);
  clBtnShadow = TColor(clSystemColor or COLOR_BTNSHADOW);
  clGrayText = TColor(clSystemColor or COLOR_GRAYTEXT);
  clBtnText = TColor(clSystemColor or COLOR_BTNTEXT);
  clInactiveCaptionText = TColor(clSystemColor or COLOR_INACTIVECAPTIONTEXT);
  clBtnHighlight = TColor(clSystemColor or COLOR_BTNHIGHLIGHT);
  cl3DDkShadow = TColor(clSystemColor or COLOR_3DDKSHADOW);
  cl3DLight = TColor(clSystemColor or COLOR_3DLIGHT);
  clInfoText = TColor(clSystemColor or COLOR_INFOTEXT);
  clInfoBk = TColor(clSystemColor or COLOR_INFOBK);
  clHotLight = TColor(clSystemColor or COLOR_HOTLIGHT);
  clGradientActiveCaption = TColor(clSystemColor or COLOR_GRADIENTACTIVECAPTION);
  clGradientInactiveCaption = TColor(clSystemColor or COLOR_GRADIENTINACTIVECAPTION);
  clMenuHighlight = TColor(clSystemColor or COLOR_MENUHILIGHT);
  clMenuBar = TColor(clSystemColor or COLOR_MENUBAR);

  clBlack = TColor($000000);
  clMaroon = TColor($000080);
  clGreen = TColor($008000);
  clOlive = TColor($008080);
  clNavy = TColor($800000);
  clPurple = TColor($800080);
  clTeal = TColor($808000);
  clGray = TColor($808080);
  clSilver = TColor($C0C0C0);
  clRed = TColor($0000FF);
  clLime = TColor($00FF00);
  clYellow = TColor($00FFFF);
  clBlue = TColor($FF0000);
  clFuchsia = TColor($FF00FF);
  clAqua = TColor($FFFF00);
  clLtGray = TColor($C0C0C0);
  clDkGray = TColor($808080);
  clWhite = TColor($FFFFFF);
  StandardColorsCount = 16;

  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue = TColor($F0CAA6);
  clCream = TColor($F0FBFF);
  clMedGray = TColor($A4A0A0);
  ExtendedColorsCount = 4;

  clNone = TColor($1FFFFFFF);
  clDefault = TColor($20000000);

function TextWidth(const Handle: HDC; const Text: WideString): Integer;
function TextHeight(const Handle: HDC; const Text: WideString): Integer;

function ImageURIFromID2(ResID: Integer): IString;
function ImageURIFromID(ResID: Integer): WideString;

function CreateICanvas(GUI: IQIPCoreGUI): ICanvas;

function BlendColor(C1, C2: TColor; W1: Integer): TColor;
function Blend(C1, C2: TColor; W1: Integer): TColor;
procedure SetContrast(var Color: TColor; BkgndColor: TColor; Threshold: Integer);

function ColorToRGB(Color: TColor): Longint;

implementation

uses SysUtils;

function TextWidth(const Handle: HDC; const Text: WideString): Integer;
var s: TSize;
begin
  GetTextExtentPoint32W(Handle, PWideChar(Text), Length(Text), s);
  Result := s.cx;
end;

function TextHeight(const Handle: HDC; const Text: WideString): Integer;
var s: TSize;
begin
  GetTextExtentPoint32W(Handle, PWideChar(Text), Length(Text), s);
  Result := s.cy;
end;

function ImageURIFromID(ResID: Integer): WideString;
begin
  Result := WideFormat(DEFAULT_SKIN_RESOURCE, [ResID]);
end;

function ImageURIFromID2(ResID: Integer): IString;
begin
  Result := GetIString(ImageURIFromID(ResID));
end;

function CreateICanvas(GUI: IQIPCoreGUI): ICanvas;
begin
  Result := nil;
  GUI.CreateObject(IID_ICanvas, Result, nil);
end;

function ReadScreenPPI(): Integer;
var
  DC: HDC;
  i, dpi, E: Integer;
  s: String;
const
  pname = '/dpi=';
begin
  DC := GetDC(0);
  Result := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);
  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);
    if Pos(pname, s) = 1 then
    begin
      s := Copy(s, Length(pname) + 1, Length(s) - Length(pname));
      Val(s, dpi, E);
      if (E = 0) and (dpi >= 96 div 2) and (dpi <= 96 * 10) then
      begin
        Result := dpi;
        Exit;
      end;
    end;
  end;
end;


function BlendColor(C1, C2: TColor; W1: Integer): TColor;
var W2, A1, A2, D, F, G: Integer;
begin
  if C1 < 0 then C1 := GetSysColor(C1 and $FF);
  if C2 < 0 then C2 := GetSysColor(C2 and $FF);
  if W1 >= 100 then D := 1000
  else D := 100;

  W2 := D - W1;
  F := D div 2;

  A2 := C2 shr 16 * W2;
  A1 := C1 shr 16 * W1;
  G := (A1 + A2 + F) div D and $FF;
  Result := G shl 16;

  A2 := (C2 shr 8 and $FF) * W2;
  A1 := (C1 shr 8 and $FF) * W1;
  G := (A1 + A2 + F) div D and $FF;
  Result := Result or G shl 8;

  A2 := (C2 and $FF) * W2;
  A1 := (C1 and $FF) * W1;
  G := (A1 + A2 + F) div D and $FF;
  Result := Result or G;
end;

function Blend(C1, C2: TColor; W1: Integer): TColor;
begin
  Result := BlendColor(C1,C2,W1);
end;

const
  WeightR: single = 0.764706;
  WeightG: single = 1.52941;
  WeightB: single = 0.254902;

function ColorDistance(C1, C2: Integer): Single;
var DR, DG, DB: Integer;
begin
  DR := (C1 and $FF) - (C2 and $FF);
  Result := Sqr(DR * WeightR);
  DG := (C1 shr 8 and $FF) - (C2 shr 8 and $FF);
  Result := Result + Sqr(DG * WeightG);
  DB := (C1 shr 16) - (C2 shr 16);
  Result := Result + Sqr(DB * WeightB);
  Result := Sqrt(Result);
end;

function GetAdjustedThreshold(BkgndIntensity, Threshold: Single): Single;
begin
  if BkgndIntensity < 220 then
    Result := (2 - BkgndIntensity / 220) * Threshold
  else
    Result := Threshold;
end;

function IsContrastEnough(AColor, ABkgndColor: Integer; DoAdjustThreshold: Boolean; Threshold: Single): Boolean;
begin
  if DoAdjustThreshold then Threshold := GetAdjustedThreshold(ColorDistance(ABkgndColor, $000000), Threshold);
  Result := ColorDistance(ABkgndColor, AColor) > Threshold;
end;

procedure AdjustContrast(var AColor: Integer; ABkgndColor: Integer; Threshold: Single);
var X, Y, Z: Single;
    R, G, B: Single;
    RR, GG, BB: Integer;
    I1, I2, S, Q, W: Single;
    DoInvert: Boolean;
begin
  I1 := ColorDistance(AColor, $000000);
  I2 := ColorDistance(ABkgndColor, $000000);
  Threshold := GetAdjustedThreshold(I2, Threshold);

  if I1 > I2 then DoInvert := I2 < 442 - Threshold
  else DoInvert := I2 < Threshold;

  X := (ABkgndColor and $FF) * WeightR;
  Y := (ABkgndColor shr 8 and $FF) * WeightG;
  Z := (ABkgndColor shr 16) * WeightB;

  R := (AColor and $FF) * WeightR;
  G := (AColor shr 8 and $FF) * WeightG;
  B := (AColor shr  16) * WeightB;

  if DoInvert then
  begin
    R := 195 - R;
    G := 390 - G;
    B := 65 - B;
    X := 195 - X;
    Y := 390 - Y;
    Z := 65 - Z;
  end;

  S := Sqrt(Sqr(B) + Sqr(G) + Sqr(R));

  if S < 0.01 then S := 0.01;

  Q := (R * X + G * Y + B * Z) / S;

  X := Q / S * R - X;
  Y := Q / S * G - Y;
  Z := Q / S * B - Z;

  W :=  Sqrt(Sqr(Threshold) - Sqr(X) - Sqr(Y) - Sqr(Z));

  R := (Q - W) * R / S;
  G := (Q - W) * G / S;
  B := (Q - W) * B / S;

  if DoInvert then
  begin
    R := 195 - R;
    G := 390 - G;
    B := 65 - B;
  end;

  if R < 0 then R := 0 else if R > 195 then R := 195;
  if G < 0 then G := 0 else if G > 390 then G := 390;
  if B < 0 then B := 0 else if B >  65 then B :=  65;

  RR := Trunc(R * (1 / WeightR) + 0.5);
  GG := Trunc(G * (1 / WeightG) + 0.5);
  BB := Trunc(B * (1 / WeightB) + 0.5);

  if RR > $FF then RR := $FF else if RR < 0 then RR := 0;
  if GG > $FF then GG := $FF else if GG < 0 then GG := 0;
  if BB > $FF then BB := $FF else if BB < 0 then BB := 0;

  AColor := (BB and $FF) shl 16 or (GG and $FF) shl 8 or (RR and $FF);
end;

procedure SetContrast(var Color: TColor; BkgndColor: TColor; Threshold: Integer);
var T: Single;
begin
  if Color < 0 then Color := GetSysColor(Color and $FF);
  if BkgndColor < 0 then BkgndColor := GetSysColor(BkgndColor and $FF);
  T := Threshold;
  if not IsContrastEnough(Color, BkgndColor, True, T) then AdjustContrast(Integer(Color), BkgndColor, T);
end;

function ColorToRGB(Color: TColor): Longint;
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF) else
    Result := Color;
end;

initialization
  SCREEN_PPI := ReadScreenPPI();
end.
