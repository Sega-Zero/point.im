unit u_gui_intf;
//***********************************
//Данный модуль - генерируемый,
//правки следует вносить через генератор
//***********************************

interface

uses Windows, u_gui_const, u_string, u_estack;

type
  IComponent = interface;
  IControl = interface;
  IWinControl = interface;
  IListener = interface;
  IFont = interface;
  IBrush = interface;
  ICanvas = interface;
  IPopupMenu = interface;
  IParaAttributes = interface;
  ITextAttributes = interface;
  IPageControl = interface;
  IMenuItems = interface;
  IVirtualTreeOptions = interface;
  ITreeColumns = interface;
  ITreeColumn = interface;
  ITreeHeader = interface;
  IVTColors = interface;
  IPageList = interface;
  IToolBar = interface;
  ITaskBar = interface;

  THeaderPaintInfo = record
    TargetCanvas: ICanvas;
    Column: ITreeColumn;
    PaintRectangle: TRect;
    TextRectangle: TRect;
    IsHoverIndex,
    IsDownIndex,
    IsEnabled,
    ShowHeaderGlyph,
    ShowSortGlyph,
    ShowRightBorder: Boolean;
    DropMark: TVTDropMarkMode;
    GlyphPos,
    SortGlyphPos: TPoint;
  end;

  IEventsCallback = interface
    procedure SetEvent(Control: IComponent); safecall;
  end;

  ISyncCallback = interface
    procedure SyncProc(var data); safecall;
  end;

  IQIPCoreGUI = interface
  ['{3A3345AE-E21A-4ACA-89B1-4E8434D9B947}']
    //creates group of controls. EventList should return an Event Handler for each control that specified in Description parameter
    //returns root object (usually IWindow)
    function  CreateControls(const Description: IString; EventsCallback: IEventsCallback): IComponent; safecall;
    //this may be used to create a single control of specified type with default property values without string description
    procedure CreateControl(Owner: IComponent; iid: TGUID; out Component; EventHandler: IInterface); safecall;
    procedure CreateObject(iid: TGUID; out Obj; EventHandler: IInterface); safecall;
    procedure DoSync(intf: ISyncCallback; var data); safecall;
  end;

  IObject = interface
  ['{1777C481-4604-4CCA-B42C-7D87E449D833}']
    function GetAccess: TAccessLevel; safecall;
    function GetEvents: IUnknown; safecall;
    function GetName: IString; safecall;
    procedure SetEvents(events: IUnknown); safecall;
    property Events: IUnknown read GetEvents write SetEvents;
    property Name: IString read GetName;
    function Core: IQIPCoreGUI; safecall;
  end;

  IComponent = interface (IObject)
  ['{CE30FFF1-2289-4B4C-A4FD-C7ED2D774D61}']
    function ComponentCount: Integer; safecall;
    function GetComponent(AIndex: Integer): IComponent; safecall;
    function FindComponent(AName: IString): IComponent; safecall;
    procedure RemoveComponent(AComponent: IComponent); safecall;
    function Owner: IComponent; safecall;
    property Components[index: integer]: IComponent read GetComponent;
    function GetTag: integer; safecall;
    procedure SetTag(value: integer); safecall;

    property Tag: integer read GetTag write SetTag;
  end;

  IControl = interface (IComponent)
  ['{E27C7804-F2D2-43EE-A295-7873A49EA09A}']
    procedure BringToFront; safecall;
    function ClientToScreen(Point: TPoint): TPoint; safecall;
    procedure Hide; safecall;
    procedure Invalidate; safecall;
    procedure Refresh; safecall;
    procedure Repaint; safecall;
    function ScreenToClient(Point: TPoint): TPoint; safecall;
    procedure SendToBack; safecall;
    procedure Show; safecall;
    function GetAlign: TAlign; safecall;
    function GetAnchors: TAnchors; safecall;
    function GetBoundsRect: TRect; safecall;
    function GetClientHeight: Integer; safecall;
    function GetClientRect: TRect; safecall;
    function GetClientWidth: Integer; safecall;
    function GetColor: TColor; safecall;
    function GetCursor: TCursor; safecall;
    function GetEnabled: BOOL; safecall;
    function GetFont: IFont; safecall;
    function GetHeight: Integer; safecall;
    function GetLeft: Integer; safecall;
    function GetName: IString; safecall;
    function GetParent: IWinControl; safecall;
    function GetPopupMenu: IPopupMenu; safecall;
    function GetShowHint: BOOL; safecall;
    function GetTop: Integer; safecall;
    function GetVisible: BOOL; safecall;
    function GetWidth: Integer; safecall;
    procedure SetAlign(Value: TAlign); safecall;
    procedure SetAnchors(Value: TAnchors); safecall;
    procedure SetBoundsRect(Value: TRect); safecall;
    procedure SetClientHeight(Value: Integer); safecall;
    procedure SetClientWidth(Value: Integer); safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetCursor(Value: TCursor); safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetFont(Value: IFont); safecall;
    procedure SetHeight(Value: Integer); safecall;
    procedure SetLeft(Value: Integer); safecall;
    procedure SetParent(Value: IWinControl); safecall;
    procedure SetPopupMenu(Value: IPopupMenu); safecall;
    procedure SetShowHint(Value: BOOL); safecall;
    procedure SetTop(Value: Integer); safecall;
    procedure SetVisible(Value: BOOL); safecall;
    procedure SetWidth(Value: Integer); safecall;

    property Align: TAlign read GetAlign write SetAlign;
    property Anchors: TAnchors read GetAnchors write SetAnchors;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
    property ClientHeight: Integer read GetClientHeight write SetClientHeight;
    property ClientRect: TRect read GetClientRect ;
    property ClientWidth: Integer read GetClientWidth write SetClientWidth;
    property Color: TColor read GetColor write SetColor;
    property Cursor: TCursor read GetCursor write SetCursor;
    property Enabled: BOOL read GetEnabled write SetEnabled;
    property Font: IFont read GetFont write SetFont;
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft write SetLeft;
    property Name: IString read GetName ;
    property Parent: IWinControl read GetParent write SetParent;
    property PopupMenu: IPopupMenu read GetPopupMenu write SetPopupMenu;
    property ShowHint: BOOL read GetShowHint write SetShowHint;
    property Top: Integer read GetTop write SetTop;
    property Visible: BOOL read GetVisible write SetVisible;
    property Width: Integer read GetWidth write SetWidth;

  end;
  IWinControl = interface (IControl)
  ['{27C7084A-C62F-49B9-ABED-67009979A414}']
    procedure AlignControls(AControl: IControl; Rect: TRect); safecall;
    function CanFocus: BOOL; safecall;
    function ContainsControl(Ctrl: IControl): BOOL; safecall;
    function ControlAtPos(Pos: TPoint; AllowDisabled: BOOL; AllowWinControls: BOOL = False): IControl; safecall;
    procedure CreateHandle; safecall;
    procedure CreateParams(Params: TCreateParams); safecall;
    procedure DisableAlign; safecall;
    procedure EnableAlign; safecall;
    function Focused: BOOL; safecall;
    function HandleAllocated: BOOL; safecall;
    procedure HandleNeeded; safecall;
    procedure InsertControl(AControl: IControl); safecall;
    procedure PaintToDC(DC: HDC; X: Integer; Y: Integer); safecall;
    procedure PaintTo(Canvas: ICanvas; X: Integer; Y: Integer); safecall;
    procedure Realign; safecall;
    procedure RecreateWnd; safecall;
    procedure SetFocus; safecall;
    function GetAlignDisabled: BOOL; safecall;
    function GetBevelEdges: TBevelEdges; safecall;
    function GetBevelInner: TBevelCut; safecall;
    function GetBevelKind: TBevelKind; safecall;
    function GetBevelOuter: TBevelCut; safecall;
    function GetBevelWidth: TBevelWidth; safecall;
    function GetBorderWidth: TBorderWidth; safecall;
    function GetBrush: IBrush; safecall;
    function GetControlCount: Integer; safecall;
    function GetControl(Index: Integer): IControl; safecall;
    function GetCtl3D: BOOL; safecall;
    function GetHandle: HWnd; safecall;
    function GetParentWindow: HWnd; safecall;
    function GetShowing: BOOL; safecall;
    function GetTabOrder: TTabOrder; safecall;
    function GetTabStop: BOOL; safecall;
    procedure SetBevelEdges(Value: TBevelEdges); safecall;
    procedure SetBevelKind(Value: TBevelKind); safecall;
    procedure SetBevelCut(Value: TBevelCut); safecall;
    procedure SetBevelWidth(Value: TBevelWidth); safecall;
    procedure SetBorderWidth(Value: TBorderWidth); safecall;
    procedure SetCtl3D(Value: BOOL); safecall;
    procedure SetParentWindow(Value: HWnd); safecall;
    procedure SetTabOrder(Value: TTabOrder); safecall;
    procedure SetTabStop(Value: BOOL); safecall;

    property AlignDisabled: BOOL read GetAlignDisabled ;
    property BevelEdges: TBevelEdges read GetBevelEdges write SetBevelEdges;
    property BevelInner: TBevelCut read GetBevelInner write SetBevelCut;
    property BevelKind: TBevelKind read GetBevelKind write SetBevelKind;
    property BevelOuter: TBevelCut read GetBevelOuter write SetBevelCut;
    property BevelWidth: TBevelWidth read GetBevelWidth write SetBevelWidth;
    property BorderWidth: TBorderWidth read GetBorderWidth write SetBorderWidth;
    property Brush: IBrush read GetBrush ;
    property ControlCount: Integer read GetControlCount ;
    property Controls[Index: Integer]: IControl read GetControl ;
    property Ctl3D: BOOL read GetCtl3D write SetCtl3D;
    property Handle: HWnd read GetHandle ;
    property ParentWindow: HWnd read GetParentWindow write SetParentWindow;
    property Showing: BOOL read GetShowing ;
    property TabOrder: TTabOrder read GetTabOrder write SetTabOrder;
    property TabStop: BOOL read GetTabStop write SetTabStop;

  end;
  IForm = interface (IWinControl)
  ['{7F17572B-8FEF-4BDA-AEFC-5E2B26FAB615}']
    procedure Close; safecall;
    procedure Release; safecall;
    function ShowModal: Integer; safecall;
    function GetActive: BOOL; safecall;
    function GetActiveControl: IWinControl; safecall;
    function GetAlphaBlend: BOOL; safecall;
    function GetAlphaBlendValue: Byte; safecall;
    function GetAntiBoss: BOOL; safecall;
    function GetBorderIcons: TBorderIcons; safecall;
    function GetBorderStyle: TFormBorderStyle; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetCaption: IString; safecall;
    function GetFormState: TFormState; safecall;
    function GetGlassed: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetIconURI: IString; safecall;
    function GetKeyPreview: BOOL; safecall;
    function GetListener: IListener; safecall;
    function GetModalResult: TModalResult; safecall;
    function GetPopupMenu: IPopupMenu; safecall;
    function GetPosition: TPosition; safecall;
    function GetScaled: BOOL; safecall;
    function GetScreenSnap: BOOL; safecall;
    function GetShowOnTaskbar: BOOL; safecall;
    function GetSnapBuffer: Integer; safecall;
    function GetTaskBar: ITaskBar; safecall;
    function GetTransparentColor: BOOL; safecall;
    function GetTransparentColorValue: TColor; safecall;
    function GetWindowState: TWindowState; safecall;
    procedure SetActiveControl(Value: IWinControl); safecall;
    procedure SetAlphaBlend(Value: BOOL); safecall;
    procedure SetAlphaBlendValue(Value: Byte); safecall;
    procedure SetAntiBoss(Value: BOOL); safecall;
    procedure SetBorderIcons(Value: TBorderIcons); safecall;
    procedure SetBorderStyle(Value: TFormBorderStyle); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetGlassed(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetIconURI(Value: IString); safecall;
    procedure SetKeyPreview(Value: BOOL); safecall;
    procedure SetModalResult(Value: TModalResult); safecall;
    procedure SetPopupMenu(Value: IPopupMenu); safecall;
    procedure SetPosition(Value: TPosition); safecall;
    procedure SetScaled(Value: BOOL); safecall;
    procedure SetScreenSnap(Value: BOOL); safecall;
    procedure SetShowOnTaskbar(Value: BOOL); safecall;
    procedure SetSnapBuffer(Value: Integer); safecall;
    procedure SetTransparentColor(Value: BOOL); safecall;
    procedure SetTransparentColorValue(Value: TColor); safecall;
    procedure SetWindowState(Value: TWindowState); safecall;

    property Active: BOOL read GetActive ;
    property ActiveControl: IWinControl read GetActiveControl write SetActiveControl;
    property AlphaBlend: BOOL read GetAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte read GetAlphaBlendValue write SetAlphaBlendValue;
    property AntiBoss: BOOL read GetAntiBoss write SetAntiBoss;
    property BorderIcons: TBorderIcons read GetBorderIcons write SetBorderIcons;
    property BorderStyle: TFormBorderStyle read GetBorderStyle write SetBorderStyle;
    property Canvas: ICanvas read GetCanvas ;
    property Caption: IString read GetCaption write SetCaption;
    property FormState: TFormState read GetFormState ;
    property Glassed: BOOL read GetGlassed write SetGlassed;
    property Hint: IString read GetHint write SetHint;
    property IconURI: IString read GetIconURI write SetIconURI;
    property KeyPreview: BOOL read GetKeyPreview write SetKeyPreview;
    property Listener: IListener read GetListener ;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property PopupMenu: IPopupMenu read GetPopupMenu write SetPopupMenu;
    property Position: TPosition read GetPosition write SetPosition;
    property Scaled: BOOL read GetScaled write SetScaled;
    property ScreenSnap: BOOL read GetScreenSnap write SetScreenSnap;
    property ShowOnTaskbar: BOOL read GetShowOnTaskbar write SetShowOnTaskbar;
    property SnapBuffer: Integer read GetSnapBuffer write SetSnapBuffer;
    property TaskBar: ITaskBar read GetTaskBar ;
    property TransparentColor: BOOL read GetTransparentColor write SetTransparentColor;
    property TransparentColorValue: TColor read GetTransparentColorValue write SetTransparentColorValue;
    property WindowState: TWindowState read GetWindowState write SetWindowState;

  end;
  IFont = interface (IObject)
  ['{784DB137-44A8-4B1C-9661-BABBD3AF92CD}']
    function HandleAllocated: BOOL; safecall;
    function GetCharset: TFontCharset; safecall;
    function GetColor: TColor; safecall;
    function GetHandle: HFont; safecall;
    function GetHeight: Integer; safecall;
    function GetName: IString; safecall;
    function GetPitch: TFontPitch; safecall;
    function GetPixelsPerInch: Integer; safecall;
    function GetSize: Integer; safecall;
    function GetStyle: TFontStyles; safecall;
    procedure SetCharset(Value: TFontCharset); safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetHandle(Value: HFont); safecall;
    procedure SetHeight(Value: Integer); safecall;
    procedure SetName(Value: IString); safecall;
    procedure SetPitch(Value: TFontPitch); safecall;
    procedure SetPixelsPerInch(Value: Integer); safecall;
    procedure SetSize(Value: Integer); safecall;
    procedure SetStyle(Value: TFontStyles); safecall;

    property Charset: TFontCharset read GetCharset write SetCharset;
    property Color: TColor read GetColor write SetColor;
    property Handle: HFont read GetHandle write SetHandle;
    property Height: Integer read GetHeight write SetHeight;
    property Name: IString read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property PixelsPerInch: Integer read GetPixelsPerInch write SetPixelsPerInch;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;

  end;
  
  IBrush = interface (IObject)
  ['{B684FF1F-3560-4515-92DF-6D35CE1EB03A}']
    function HandleAllocated: BOOL; safecall;
    function GetColor: TColor; safecall;
    function GetHandle: HBrush; safecall;
    function GetStyle: TBrushStyle; safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetHandle(Value: HBrush); safecall;
    procedure SetStyle(Value: TBrushStyle); safecall;

    property Color: TColor read GetColor write SetColor;
    property Handle: HBrush read GetHandle write SetHandle;
    property Style: TBrushStyle read GetStyle write SetStyle;

  end;
  
  IPen = interface (IObject)
  ['{C81A4656-BAAC-4525-85D4-CEF9A1D5FCD0}']
    function HandleAllocated: BOOL; safecall;
    function GetColor: TColor; safecall;
    function GetHandle: HPen; safecall;
    function GetMode: TPenMode; safecall;
    function GetStyle: TPenStyle; safecall;
    function GetWidth: Integer; safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetHandle(Value: HPen); safecall;
    procedure SetMode(Value: TPenMode); safecall;
    procedure SetStyle(Value: TPenStyle); safecall;
    procedure SetWidth(Value: Integer); safecall;

    property Color: TColor read GetColor write SetColor;
    property Handle: HPen read GetHandle write SetHandle;
    property Mode: TPenMode read GetMode write SetMode;
    property Style: TPenStyle read GetStyle write SetStyle;
    property Width: Integer read GetWidth write SetWidth;

  end;
  
  ICanvas = interface (IObject)
  ['{E77AC998-8CB3-4D41-9769-A6713CC8E7DB}']
    procedure Arc(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer; X3: Integer; Y3: Integer; X4: Integer; Y4: Integer); safecall;
    procedure Chord(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer; X3: Integer; Y3: Integer; X4: Integer; Y4: Integer); safecall;
    procedure CopyRect(Dest: TRect; Canvas: ICanvas; Source: TRect); safecall;
    procedure Draw(X: Integer; Y: Integer; Graphic: IString); safecall;
    procedure DrawFocusRect(Rect: TRect); safecall;
    procedure Ellipse(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); overload; safecall;
    procedure Ellipse(Rect: TRect); overload; safecall;
    procedure FillRect(Rect: TRect); safecall;
    procedure FloodFill(X: Integer; Y: Integer; Color: TColor; FillStyle: TFillStyle); safecall;
    procedure FrameRect(Rect: TRect); safecall;
    function HandleAllocated: BOOL; safecall;
    procedure LineTo(X: Integer; Y: Integer); safecall;
    procedure Lock; safecall;
    procedure MoveTo(X: Integer; Y: Integer); safecall;
    procedure Pie(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer; X3: Integer; Y3: Integer; X4: Integer; Y4: Integer); safecall;
    procedure PolyBezier(Points: PPoint; count: integer); safecall;
    procedure PolyBezierTo(Points: PPoint; count: integer); safecall;
    procedure Polygon(Points: PPoint; count: integer); safecall;
    procedure Polyline(Points: PPoint; count: integer); safecall;
    procedure Rectangle(Rect: TRect); safecall;
    procedure Refresh; safecall;
    procedure RoundRect(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer; X3: Integer; Y3: Integer); safecall;
    procedure StretchDraw(Rect: TRect; Graphic: IString; Scale: TScaleMetod); safecall;
    function TextExtent(Text: IString): TSize; safecall;
    function TextHeight(Text: IString): Integer; safecall;
    procedure TextOut(X: Integer; Y: Integer; Text: IString); safecall;
    procedure TextRect(Rect: TRect; X: Integer; Y: Integer; Text: IString); safecall;
    function TextWidth(Text: IString): Integer; safecall;
    function TryLock: BOOL; safecall;
    procedure Unlock; safecall;
    function GetBrush: IBrush; safecall;
    function GetCanvasOrientation: TCanvasOrientation; safecall;
    function GetClipRect: TRect; safecall;
    function GetCopyMode: TCopyMode; safecall;
    function GetFont: IFont; safecall;
    function GetHandle: HDC; safecall;
    function GetLockCount: Integer; safecall;
    function GetPen: IPen; safecall;
    function GetPenPos: TPoint; safecall;
    function GetPixel(X: Integer; Y: Integer): TColor; safecall;
    function GetTextFlags: Longint; safecall;
    procedure SetBrush(Value: IBrush); safecall;
    procedure SetCopyMode(Value: TCopyMode); safecall;
    procedure SetFont(Value: IFont); safecall;
    procedure SetHandle(Value: HDC); safecall;
    procedure SetPen(Value: IPen); safecall;
    procedure SetPenPos(Value: TPoint); safecall;
    procedure SetPixel(X: Integer; Y: Integer; Value: TColor); safecall;
    procedure SetTextFlags(Value: Longint); safecall;

    property Brush: IBrush read GetBrush write SetBrush;
    property CanvasOrientation: TCanvasOrientation read GetCanvasOrientation ;
    property ClipRect: TRect read GetClipRect ;
    property CopyMode: TCopyMode read GetCopyMode write SetCopyMode;
    property Font: IFont read GetFont write SetFont;
    property Handle: HDC read GetHandle write SetHandle;
    property LockCount: Integer read GetLockCount ;
    property Pen: IPen read GetPen write SetPen;
    property PenPos: TPoint read GetPenPos write SetPenPos;
    property Pixels[X: Integer; Y: Integer]: TColor read GetPixel write SetPixel;
    property TextFlags: Longint read GetTextFlags write SetTextFlags;

  end;
  ILabel = interface (IControl)
  ['{0FA4966F-846E-4EAB-B232-45663949353B}']
    procedure AdjustBounds; safecall;
    function GetAlignment: TAlignment; safecall;
    function GetAutoSize: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetCaption: IString; safecall;
    function GetHint: IString; safecall;
    function GetLayout: TTextLayout; safecall;
    function GetShowAccelChar: BOOL; safecall;
    function GetTransparent: BOOL; safecall;
    function GetWordWrap: BOOL; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetLayout(Value: TTextLayout); safecall;
    procedure SetShowAccelChar(Value: BOOL); safecall;
    procedure SetTransparent(Value: BOOL); safecall;
    procedure SetWordWrap(Value: BOOL); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property Canvas: ICanvas read GetCanvas ;
    property Caption: IString read GetCaption write SetCaption;
    property Hint: IString read GetHint write SetHint;
    property Layout: TTextLayout read GetLayout write SetLayout;
    property ShowAccelChar: BOOL read GetShowAccelChar write SetShowAccelChar;
    property Transparent: BOOL read GetTransparent write SetTransparent;
    property WordWrap: BOOL read GetWordWrap write SetWordWrap;

  end;
  
  IStaticText = interface (IWinControl)
  ['{CCDA5BAD-AAE6-46D0-AD02-5FFC05373B95}']
    function GetAlignment: TAlignment; safecall;
    function GetAutoSize: BOOL; safecall;
    function GetBorderStyle: TStaticBorderStyle; safecall;
    function GetCaption: IString; safecall;
    function GetEndEllipsis: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetShowAccelChar: BOOL; safecall;
    function GetTransparent: BOOL; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetBorderStyle(Value: TStaticBorderStyle); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetEndEllipsis(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetShowAccelChar(Value: BOOL); safecall;
    procedure SetTransparent(Value: BOOL); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property BorderStyle: TStaticBorderStyle read GetBorderStyle write SetBorderStyle;
    property Caption: IString read GetCaption write SetCaption;
    property EndEllipsis: BOOL read GetEndEllipsis write SetEndEllipsis;
    property Hint: IString read GetHint write SetHint;
    property ShowAccelChar: BOOL read GetShowAccelChar write SetShowAccelChar;
    property Transparent: BOOL read GetTransparent write SetTransparent;

  end;
  
  IProgressBar = interface (IWinControl)
  ['{58675583-56AD-451F-92C6-6FD1E308B619}']
    procedure StepBy(Delta: Integer); safecall;
    procedure StepIt; safecall;
    function GetMax: Integer; safecall;
    function GetMin: Integer; safecall;
    function GetOrientation: TProgressBarOrientation; safecall;
    function GetPosition: Integer; safecall;
    function GetSmooth: BOOL; safecall;
    function GetStep: Integer; safecall;
    procedure SetMax(Value: Integer); safecall;
    procedure SetMin(Value: Integer); safecall;
    procedure SetOrientation(Value: TProgressBarOrientation); safecall;
    procedure SetPosition(Value: Integer); safecall;
    procedure SetSmooth(Value: BOOL); safecall;
    procedure SetStep(Value: Integer); safecall;

    property Max: Integer read GetMax write SetMax;
    property Min: Integer read GetMin write SetMin;
    property Orientation: TProgressBarOrientation read GetOrientation write SetOrientation;
    property Position: Integer read GetPosition write SetPosition;
    property Smooth: BOOL read GetSmooth write SetSmooth;
    property Step: Integer read GetStep write SetStep;

  end;
  
  ITrackBar = interface (IWinControl)
  ['{436AA9F3-6C16-481D-959F-9CCC9917335E}']
    procedure SetTick(Value: Integer); safecall;
    function GetFrequency: Integer; safecall;
    function GetLineSize: Integer; safecall;
    function GetMax: Integer; safecall;
    function GetMin: Integer; safecall;
    function GetOrientation: TTrackBarOrientation; safecall;
    function GetPageSize: Integer; safecall;
    function GetPosition: Integer; safecall;
    function GetSelEnd: Integer; safecall;
    function GetSelStart: Integer; safecall;
    function GetSliderVisible: BOOL; safecall;
    function GetThumbLength: Integer; safecall;
    function GetTickMarks: TTickMark; safecall;
    function GetTickStyle: TTickStyle; safecall;
    procedure SetFrequency(Value: Integer); safecall;
    procedure SetLineSize(Value: Integer); safecall;
    procedure SetMax(Value: Integer); safecall;
    procedure SetMin(Value: Integer); safecall;
    procedure SetOrientation(Value: TTrackBarOrientation); safecall;
    procedure SetPageSize(Value: Integer); safecall;
    procedure SetPosition(Value: Integer); safecall;
    procedure SetSelEnd(Value: Integer); safecall;
    procedure SetSelStart(Value: Integer); safecall;
    procedure SetSliderVisible(Value: BOOL); safecall;
    procedure SetThumbLength(Value: Integer); safecall;
    procedure SetTickMarks(Value: TTickMark); safecall;
    procedure SetTickStyle(Value: TTickStyle); safecall;

    property Frequency: Integer read GetFrequency write SetFrequency;
    property LineSize: Integer read GetLineSize write SetLineSize;
    property Max: Integer read GetMax write SetMax;
    property Min: Integer read GetMin write SetMin;
    property Orientation: TTrackBarOrientation read GetOrientation write SetOrientation;
    property PageSize: Integer read GetPageSize write SetPageSize;
    property Position: Integer read GetPosition write SetPosition;
    property SelEnd: Integer read GetSelEnd write SetSelEnd;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SliderVisible: BOOL read GetSliderVisible write SetSliderVisible;
    property ThumbLength: Integer read GetThumbLength write SetThumbLength;
    property TickMarks: TTickMark read GetTickMarks write SetTickMarks;
    property TickStyle: TTickStyle read GetTickStyle write SetTickStyle;

  end;
  
  IToolButton = interface (IControl)
  ['{D822E946-1A3D-4099-AE4B-E43C1D21396A}']
    procedure Click; safecall;
    function GetAllowAllUp: BOOL; safecall;
    function GetAutoSize: BOOL; safecall;
    function GetCaption: IString; safecall;
    function GetDown: BOOL; safecall;
    function GetDropdownMenu: IPopupMenu; safecall;
    function GetGrouped: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetImageURI: IString; safecall;
    function GetIndeterminate: BOOL; safecall;
    function GetIndex: Integer; safecall;
    function GetMarked: BOOL; safecall;
    function GetStyle: TToolButtonStyle; safecall;
    function GetToolBar: IToolBar; safecall;
    function GetWrap: BOOL; safecall;
    procedure SetAllowAllUp(Value: BOOL); safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetDown(Value: BOOL); safecall;
    procedure SetDropdownMenu(Value: IPopupMenu); safecall;
    procedure SetGrouped(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetImageURI(Value: IString); safecall;
    procedure SetIndeterminate(Value: BOOL); safecall;
    procedure SetMarked(Value: BOOL); safecall;
    procedure SetStyle(Value: TToolButtonStyle); safecall;
    procedure SetToolBar(Value: IToolBar); safecall;
    procedure SetWrap(Value: BOOL); safecall;

    property AllowAllUp: BOOL read GetAllowAllUp write SetAllowAllUp;
    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property Caption: IString read GetCaption write SetCaption;
    property Down: BOOL read GetDown write SetDown;
    property DropdownMenu: IPopupMenu read GetDropdownMenu write SetDropdownMenu;
    property Grouped: BOOL read GetGrouped write SetGrouped;
    property Hint: IString read GetHint write SetHint;
    property ImageURI: IString read GetImageURI write SetImageURI;
    property Indeterminate: BOOL read GetIndeterminate write SetIndeterminate;
    property Index: Integer read GetIndex ;
    property Marked: BOOL read GetMarked write SetMarked;
    property Style: TToolButtonStyle read GetStyle write SetStyle;
    property ToolBar: IToolBar read GetToolBar write SetToolBar;
    property Wrap: BOOL read GetWrap write SetWrap;

  end;
  
  IToolBar = interface (IWinControl)
  ['{27183EFC-0E8F-4918-9C33-613AE8B941B2}']
    function GetAutoSize: BOOL; safecall;
    function GetButtonCount: Integer; safecall;
    function GetButtonHeight: Integer; safecall;
    function GetButtonWidth: Integer; safecall;
    function GetButton(Index: Integer): IToolButton; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetCaption: IString; safecall;
    function GetEdgeBorders: TEdgeBorders; safecall;
    function GetEdgeInner: TEdgeStyle; safecall;
    function GetEdgeOuter: TEdgeStyle; safecall;
    function GetFlat: BOOL; safecall;
    function GetHideClippedButtons: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetIndent: Integer; safecall;
    function GetList: BOOL; safecall;
    function GetShowCaptions: BOOL; safecall;
    function GetTransparent: BOOL; safecall;
    function GetWrapable: BOOL; safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetButtonHeight(Value: Integer); safecall;
    procedure SetButtonWidth(Value: Integer); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetEdgeBorders(Value: TEdgeBorders); safecall;
    procedure SetEdgeInner(Value: TEdgeStyle); safecall;
    procedure SetEdgeOuter(Value: TEdgeStyle); safecall;
    procedure SetFlat(Value: BOOL); safecall;
    procedure SetHideClippedButtons(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetIndent(Value: Integer); safecall;
    procedure SetList(Value: BOOL); safecall;
    procedure SetShowCaptions(Value: BOOL); safecall;
    procedure SetTransparent(Value: BOOL); safecall;
    procedure SetWrapable(Value: BOOL); safecall;

    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property ButtonCount: Integer read GetButtonCount ;
    property ButtonHeight: Integer read GetButtonHeight write SetButtonHeight;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth;
    property Buttons[Index: Integer]: IToolButton read GetButton ;
    property Canvas: ICanvas read GetCanvas ;
    property Caption: IString read GetCaption write SetCaption;
    property EdgeBorders: TEdgeBorders read GetEdgeBorders write SetEdgeBorders;
    property EdgeInner: TEdgeStyle read GetEdgeInner write SetEdgeInner;
    property EdgeOuter: TEdgeStyle read GetEdgeOuter write SetEdgeOuter;
    property Flat: BOOL read GetFlat write SetFlat;
    property HideClippedButtons: BOOL read GetHideClippedButtons write SetHideClippedButtons;
    property Hint: IString read GetHint write SetHint;
    property Indent: Integer read GetIndent write SetIndent;
    property List: BOOL read GetList write SetList;
    property ShowCaptions: BOOL read GetShowCaptions write SetShowCaptions;
    property Transparent: BOOL read GetTransparent write SetTransparent;
    property Wrapable: BOOL read GetWrapable write SetWrapable;

  end;
  
  IUpDown = interface (IWinControl)
  ['{47D92A22-48D9-4317-977D-3C649AD1EE54}']
    function GetAlignButton: TUDAlignButton; safecall;
    function GetArrowKeys: BOOL; safecall;
    function GetAssociate: IWinControl; safecall;
    function GetHint: IString; safecall;
    function GetIncrement: Integer; safecall;
    function GetMax: SmallInt; safecall;
    function GetMin: SmallInt; safecall;
    function GetOrientation: TUDOrientation; safecall;
    function GetThousands: BOOL; safecall;
    function GetWrap: BOOL; safecall;
    procedure SetAlignButton(Value: TUDAlignButton); safecall;
    procedure SetArrowKeys(Value: BOOL); safecall;
    procedure SetAssociate(Value: IWinControl); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetIncrement(Value: Integer); safecall;
    procedure SetMax(Value: SmallInt); safecall;
    procedure SetMin(Value: SmallInt); safecall;
    procedure SetOrientation(Value: TUDOrientation); safecall;
    procedure SetThousands(Value: BOOL); safecall;
    procedure SetWrap(Value: BOOL); safecall;

    property AlignButton: TUDAlignButton read GetAlignButton write SetAlignButton;
    property ArrowKeys: BOOL read GetArrowKeys write SetArrowKeys;
    property Associate: IWinControl read GetAssociate write SetAssociate;
    property Hint: IString read GetHint write SetHint;
    property Increment: Integer read GetIncrement write SetIncrement;
    property Max: SmallInt read GetMax write SetMax;
    property Min: SmallInt read GetMin write SetMin;
    property Orientation: TUDOrientation read GetOrientation write SetOrientation;
    property Thousands: BOOL read GetThousands write SetThousands;
    property Wrap: BOOL read GetWrap write SetWrap;

  end;
  
  IButton = interface (IWinControl)
  ['{33A124B7-4A9C-465E-A23D-1ECAF800EB0E}']
    procedure Click; safecall;
    function GetCaption: IString; safecall;
    function GetDefault: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetImgURI: IString; safecall;
    function GetLayout: TButtonLayout; safecall;
    function GetMargin: Integer; safecall;
    function GetModalResult: TModalResult; safecall;
    function GetSpacing: Integer; safecall;
    function GetWordWrap: BOOL; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetDefault(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetImgURI(Value: IString); safecall;
    procedure SetLayout(Value: TButtonLayout); safecall;
    procedure SetMargin(Value: Integer); safecall;
    procedure SetModalResult(Value: TModalResult); safecall;
    procedure SetSpacing(Value: Integer); safecall;
    procedure SetWordWrap(Value: BOOL); safecall;

    property Caption: IString read GetCaption write SetCaption;
    property Default: BOOL read GetDefault write SetDefault;
    property Hint: IString read GetHint write SetHint;
    property ImgURI: IString read GetImgURI write SetImgURI;
    property Layout: TButtonLayout read GetLayout write SetLayout;
    property Margin: Integer read GetMargin write SetMargin;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property Spacing: Integer read GetSpacing write SetSpacing;
    property WordWrap: BOOL read GetWordWrap write SetWordWrap;

  end;
  
  ISpeedButton = interface (IControl)
  ['{AED80E85-5B4F-4858-A4FE-011FBA003435}']
    procedure Click; safecall;
    function GetAllowAllUp: BOOL; safecall;
    function GetCaption: IString; safecall;
    function GetDown: BOOL; safecall;
    function GetFlat: BOOL; safecall;
    function GetFrameOnMouse: BOOL; safecall;
    function GetGroupIndex: Integer; safecall;
    function GetHint: IString; safecall;
    function GetImgURI: IString; safecall;
    function GetLayout: TButtonLayout; safecall;
    function GetMargin: Integer; safecall;
    function GetShowDropArrow: BOOL; safecall;
    function GetSpacing: Integer; safecall;
    function GetThemeFlat: BOOL; safecall;
    function GetTransparent: BOOL; safecall;
    procedure SetAllowAllUp(Value: BOOL); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetDown(Value: BOOL); safecall;
    procedure SetFlat(Value: BOOL); safecall;
    procedure SetFrameOnMouse(Value: BOOL); safecall;
    procedure SetGroupIndex(Value: Integer); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetImgURI(Value: IString); safecall;
    procedure SetLayout(Value: TButtonLayout); safecall;
    procedure SetMargin(Value: Integer); safecall;
    procedure SetShowDropArrow(Value: BOOL); safecall;
    procedure SetSpacing(Value: Integer); safecall;
    procedure SetThemeFlat(Value: BOOL); safecall;
    procedure SetTransparent(Value: BOOL); safecall;

    property AllowAllUp: BOOL read GetAllowAllUp write SetAllowAllUp;
    property Caption: IString read GetCaption write SetCaption;
    property Down: BOOL read GetDown write SetDown;
    property Flat: BOOL read GetFlat write SetFlat;
    property FrameOnMouse: BOOL read GetFrameOnMouse write SetFrameOnMouse;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
    property Hint: IString read GetHint write SetHint;
    property ImgURI: IString read GetImgURI write SetImgURI;
    property Layout: TButtonLayout read GetLayout write SetLayout;
    property Margin: Integer read GetMargin write SetMargin;
    property ShowDropArrow: BOOL read GetShowDropArrow write SetShowDropArrow;
    property Spacing: Integer read GetSpacing write SetSpacing;
    property ThemeFlat: BOOL read GetThemeFlat write SetThemeFlat;
    property Transparent: BOOL read GetTransparent write SetTransparent;

  end;
  
  IRadioButton = interface (IWinControl)
  ['{C1BFF325-3339-4D8F-98DF-92467D6FDD13}']
    function GetCaption: IString; safecall;
    function GetChecked: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetWordWrap: BOOL; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetChecked(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetWordWrap(Value: BOOL); safecall;

    property Caption: IString read GetCaption write SetCaption;
    property Checked: BOOL read GetChecked write SetChecked;
    property Hint: IString read GetHint write SetHint;
    property WordWrap: BOOL read GetWordWrap write SetWordWrap;

  end;
  
  ICheckBox = interface (IWinControl)
  ['{82363584-B929-474B-9501-3AE30F244D4C}']
    procedure Click; safecall;
    function GetAlignment: TLeftRight; safecall;
    function GetAllowGrayed: BOOL; safecall;
    function GetCaption: IString; safecall;
    function GetChecked: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetState: TCheckBoxState; safecall;
    function GetTransparent: BOOL; safecall;
    function GetWordWrap: BOOL; safecall;
    procedure SetAlignment(Value: TLeftRight); safecall;
    procedure SetAllowGrayed(Value: BOOL); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetChecked(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetState(Value: TCheckBoxState); safecall;
    procedure SetTransparent(Value: BOOL); safecall;
    procedure SetWordWrap(Value: BOOL); safecall;

    property Alignment: TLeftRight read GetAlignment write SetAlignment;
    property AllowGrayed: BOOL read GetAllowGrayed write SetAllowGrayed;
    property Caption: IString read GetCaption write SetCaption;
    property Checked: BOOL read GetChecked write SetChecked;
    property Hint: IString read GetHint write SetHint;
    property State: TCheckBoxState read GetState write SetState;
    property Transparent: BOOL read GetTransparent write SetTransparent;
    property WordWrap: BOOL read GetWordWrap write SetWordWrap;

  end;
  
  IEdit = interface (IWinControl)
  ['{B7A09905-96CF-4C0B-898C-009FAA3CD050}']
    procedure Clear; safecall;
    procedure ClearSelection; safecall;
    procedure ClearUndo; safecall;
    procedure CopyToClipboard; safecall;
    procedure CutToClipboard; safecall;
    procedure PasteFromClipboard; safecall;
    procedure SelectAll; safecall;
    procedure Undo; safecall;
    function GetAutoSelect: BOOL; safecall;
    function GetAutoSize: BOOL; safecall;
    function GetBorderStyle: TBorderStyle; safecall;
    function GetCanUndo: BOOL; safecall;
    function GetCharCase: TEditCharCase; safecall;
    function GetHideSelection: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetMaxLength: Integer; safecall;
    function GetModified: BOOL; safecall;
    function GetOEMConvert: BOOL; safecall;
    function GetPasswordChar: WideChar; safecall;
    function GetReadOnly: BOOL; safecall;
    function GetSelLength: Integer; safecall;
    function GetSelStart: Integer; safecall;
    function GetSelText: IString; safecall;
    function GetText: IString; safecall;
    function GetTextHint: IString; safecall;
    function GetTextHintOptions: TTextHintOptions; safecall;
    procedure SetAutoSelect(Value: BOOL); safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetBorderStyle(Value: TBorderStyle); safecall;
    procedure SetCharCase(Value: TEditCharCase); safecall;
    procedure SetHideSelection(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetMaxLength(Value: Integer); safecall;
    procedure SetModified(Value: BOOL); safecall;
    procedure SetOEMConvert(Value: BOOL); safecall;
    procedure SetPasswordChar(Value: WideChar); safecall;
    procedure SetReadOnly(Value: BOOL); safecall;
    procedure SetSelLength(Value: Integer); safecall;
    procedure SetSelStart(Value: Integer); safecall;
    procedure SetSelText(Value: IString); safecall;
    procedure SetText(Value: IString); safecall;
    procedure SetTextHint(Value: IString); safecall;
    procedure SetTextHintOptions(Value: TTextHintOptions); safecall;

    property AutoSelect: BOOL read GetAutoSelect write SetAutoSelect;
    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property BorderStyle: TBorderStyle read GetBorderStyle write SetBorderStyle;
    property CanUndo: BOOL read GetCanUndo ;
    property CharCase: TEditCharCase read GetCharCase write SetCharCase;
    property HideSelection: BOOL read GetHideSelection write SetHideSelection;
    property Hint: IString read GetHint write SetHint;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property Modified: BOOL read GetModified write SetModified;
    property OEMConvert: BOOL read GetOEMConvert write SetOEMConvert;
    property PasswordChar: WideChar read GetPasswordChar write SetPasswordChar;
    property ReadOnly: BOOL read GetReadOnly write SetReadOnly;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: IString read GetSelText write SetSelText;
    property Text: IString read GetText write SetText;
    property TextHint: IString read GetTextHint write SetTextHint;
    property TextHintOptions: TTextHintOptions read GetTextHintOptions write SetTextHintOptions;

  end;
  
  IMemo = interface (IWinControl)
  ['{27FA3632-2E38-4F11-A915-9C6118460869}']
    procedure Clear; safecall;
    procedure ClearSelection; safecall;
    procedure ClearUndo; safecall;
    procedure CopyToClipboard; safecall;
    procedure CutToClipboard; safecall;
    procedure PasteFromClipboard; safecall;
    procedure SelectAll; safecall;
    procedure Undo; safecall;
    function GetAlignment: TAlignment; safecall;
    function GetBorderStyle: TBorderStyle; safecall;
    function GetCanUndo: BOOL; safecall;
    function GetCaretPos: TPoint; safecall;
    function GetHideSelection: BOOL; safecall;
    function GetLines: IStringList; safecall;
    function GetMaxLength: Integer; safecall;
    function GetModified: BOOL; safecall;
    function GetOEMConvert: BOOL; safecall;
    function GetReadOnly: BOOL; safecall;
    function GetScrollBars: TScrollStyle; safecall;
    function GetSelLength: Integer; safecall;
    function GetSelStart: Integer; safecall;
    function GetSelText: IString; safecall;
    function GetText: IString; safecall;
    function GetWantReturns: BOOL; safecall;
    function GetWantTabs: BOOL; safecall;
    function GetWordWrap: BOOL; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetBorderStyle(Value: TBorderStyle); safecall;
    procedure SetCaretPos(Value: TPoint); safecall;
    procedure SetHideSelection(Value: BOOL); safecall;
    procedure SetLines(Value: IStringList); safecall;
    procedure SetMaxLength(Value: Integer); safecall;
    procedure SetModified(Value: BOOL); safecall;
    procedure SetOEMConvert(Value: BOOL); safecall;
    procedure SetReadOnly(Value: BOOL); safecall;
    procedure SetScrollBars(Value: TScrollStyle); safecall;
    procedure SetSelLength(Value: Integer); safecall;
    procedure SetSelStart(Value: Integer); safecall;
    procedure SetSelText(Value: IString); safecall;
    procedure SetText(Value: IString); safecall;
    procedure SetWantReturns(Value: BOOL); safecall;
    procedure SetWantTabs(Value: BOOL); safecall;
    procedure SetWordWrap(Value: BOOL); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property BorderStyle: TBorderStyle read GetBorderStyle write SetBorderStyle;
    property CanUndo: BOOL read GetCanUndo ;
    property CaretPos: TPoint read GetCaretPos write SetCaretPos;
    property HideSelection: BOOL read GetHideSelection write SetHideSelection;
    property Lines: IStringList read GetLines write SetLines;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property Modified: BOOL read GetModified write SetModified;
    property OEMConvert: BOOL read GetOEMConvert write SetOEMConvert;
    property ReadOnly: BOOL read GetReadOnly write SetReadOnly;
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: IString read GetSelText write SetSelText;
    property Text: IString read GetText write SetText;
    property WantReturns: BOOL read GetWantReturns write SetWantReturns;
    property WantTabs: BOOL read GetWantTabs write SetWantTabs;
    property WordWrap: BOOL read GetWordWrap write SetWordWrap;

  end;
  
  IRichEdit = interface (IMemo)
  ['{CBC854DC-7C6A-40D4-80AA-1055666D82E2}']
    procedure Clear; safecall;
    function FindText(SearchStr: IString; StartPos: Integer; Length: Integer; Options: TSearchTypes): Integer; safecall;
    function GetDefAttributes: ITextAttributes; safecall;
    function GetHideScrollBars: BOOL; safecall;
    function GetHideSelection: BOOL; safecall;
    function GetPageRect: TRect; safecall;
    function GetParagraph: IParaAttributes; safecall;
    function GetFormattedText: IString; safecall;
    function GetSelAttributes: ITextAttributes; safecall;
    procedure SetDefAttributes(Value: ITextAttributes); safecall;
    procedure SetHideScrollBars(Value: BOOL); safecall;
    procedure SetHideSelection(Value: BOOL); safecall;
    procedure SetPageRect(Value: TRect); safecall;
    procedure SetFormattedText(Value: IString); safecall;
    procedure SetSelAttributes(Value: ITextAttributes); safecall;

    property DefAttributes: ITextAttributes read GetDefAttributes write SetDefAttributes;
    property HideScrollBars: BOOL read GetHideScrollBars write SetHideScrollBars;
    property HideSelection: BOOL read GetHideSelection write SetHideSelection;
    property PageRect: TRect read GetPageRect write SetPageRect;
    property Paragraph: IParaAttributes read GetParagraph ;
    property FormattedText: IString read GetFormattedText write SetFormattedText;
    property SelAttributes: ITextAttributes read GetSelAttributes write SetSelAttributes;

  end;
  
  IListControl = interface (IWinControl)
  ['{6842816A-5CF6-49FD-BEA0-7D0836EF698C}']
    procedure AddItem(Item: IString; AObject: TObject); safecall;
    procedure Clear; safecall;
    procedure ClearSelection; safecall;
    procedure SelectAll; safecall;
    function GetHint: IString; safecall;
    function GetItemIndex: Integer; safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetItemIndex(Value: Integer); safecall;

    property Hint: IString read GetHint write SetHint;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;

  end;
  
  IComboBox = interface (IListControl)
  ['{82B26652-146A-48F5-91D2-A265C55F6F34}']
    procedure AddItem(Item: IString; AObject: TObject); safecall;
    procedure DropDown; safecall;
    function Focused: BOOL; safecall;
    procedure SetSmartDropWidth(AddLen: Integer = 0); safecall;
    function GetAutoComplete: BOOL; safecall;
    function GetAutoDropDown: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetDropDownCount: Integer; safecall;
    function GetDroppedDown: BOOL; safecall;
    function GetEditHandle: HWnd; safecall;
    function GetHint: IString; safecall;
    function GetItemHt: Integer; safecall;
    function GetItems: IStringList; safecall;
    function GetMaxLength: Integer; safecall;
    function GetSelLength: Integer; safecall;
    function GetSelStart: Integer; safecall;
    function GetSelText: IString; safecall;
    function GetSorted: BOOL; safecall;
    function GetStyle: TComboBoxStyle; safecall;
    function GetText: IString; safecall;
    procedure SetAutoComplete(Value: BOOL); safecall;
    procedure SetAutoDropDown(Value: BOOL); safecall;
    procedure SetDropDownCount(Value: Integer); safecall;
    procedure SetDroppedDown(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetItemHeight(Value: Integer); safecall;
    procedure SetItems(Value: IStringList); safecall;
    procedure SetMaxLength(Value: Integer); safecall;
    procedure SetSelLength(Value: Integer); safecall;
    procedure SetSelStart(Value: Integer); safecall;
    procedure SetSelText(Value: IString); safecall;
    procedure SetSorted(Value: BOOL); safecall;
    procedure SetStyle(Value: TComboBoxStyle); safecall;
    procedure SetText(Value: IString); safecall;

    property AutoComplete: BOOL read GetAutoComplete write SetAutoComplete;
    property AutoDropDown: BOOL read GetAutoDropDown write SetAutoDropDown;
    property Canvas: ICanvas read GetCanvas ;
    property DropDownCount: Integer read GetDropDownCount write SetDropDownCount;
    property DroppedDown: BOOL read GetDroppedDown write SetDroppedDown;
    property EditHandle: HWnd read GetEditHandle ;
    property Hint: IString read GetHint write SetHint;
    property ItemHeight: Integer read GetItemHt write SetItemHeight;
    property Items: IStringList read GetItems write SetItems;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: IString read GetSelText write SetSelText;
    property Sorted: BOOL read GetSorted write SetSorted;
    property Style: TComboBoxStyle read GetStyle write SetStyle;
    property Text: IString read GetText write SetText;

  end;
  
  IListBox = interface (IListControl)
  ['{A189B36C-F135-47F8-92A5-152C7ED45393}']
    procedure AddItem(Item: IString; AObject: TObject); safecall;
    procedure DeleteSelected; safecall;
    function ItemAtPos(Pos: TPoint; Existing: BOOL): Integer; safecall;
    function ItemRect(Index: Integer): TRect; safecall;
    function GetAutoComplete: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetColumns: Integer; safecall;
    function GetCount: Integer; safecall;
    function GetExtendedSelect: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetIntegralHeight: BOOL; safecall;
    function GetItemHeight: Integer; safecall;
    function GetItems: IStringList; safecall;
    function GetMultiSelect: BOOL; safecall;
    function GetScrollWidth: Integer; safecall;
    function GetSelCount: Integer; safecall;
    function GetSelected(Index: Integer): BOOL; safecall;
    function GetSorted: BOOL; safecall;
    function GetStyle: TListBoxStyle; safecall;
    function GetTabWidth: Integer; safecall;
    function GetTopIndex: Integer; safecall;
    procedure SetAutoComplete(Value: BOOL); safecall;
    procedure SetColumns(Value: Integer); safecall;
    procedure SetCount(Value: Integer); safecall;
    procedure SetExtendedSelect(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetIntegralHeight(Value: BOOL); safecall;
    procedure SetItemHeight(Value: Integer); safecall;
    procedure SetItems(Value: IStringList); safecall;
    procedure SetMultiSelect(Value: BOOL); safecall;
    procedure SetScrollWidth(Value: Integer); safecall;
    procedure SetSelected(Index: Integer; Value: BOOL); safecall;
    procedure SetSorted(Value: BOOL); safecall;
    procedure SetStyle(Value: TListBoxStyle); safecall;
    procedure SetTabWidth(Value: Integer); safecall;
    procedure SetTopIndex(Value: Integer); safecall;

    property AutoComplete: BOOL read GetAutoComplete write SetAutoComplete;
    property Canvas: ICanvas read GetCanvas ;
    property Columns: Integer read GetColumns write SetColumns;
    property Count: Integer read GetCount write SetCount;
    property ExtendedSelect: BOOL read GetExtendedSelect write SetExtendedSelect;
    property Hint: IString read GetHint write SetHint;
    property IntegralHeight: BOOL read GetIntegralHeight write SetIntegralHeight;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property Items: IStringList read GetItems write SetItems;
    property MultiSelect: BOOL read GetMultiSelect write SetMultiSelect;
    property ScrollWidth: Integer read GetScrollWidth write SetScrollWidth;
    property SelCount: Integer read GetSelCount ;
    property Selected[Index: Integer]: BOOL read GetSelected write SetSelected;
    property Sorted: BOOL read GetSorted write SetSorted;
    property Style: TListBoxStyle read GetStyle write SetStyle;
    property TabWidth: Integer read GetTabWidth write SetTabWidth;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;

  end;
  
  IMenuItem = interface (IComponent)
  ['{14A51322-AE67-48D7-A7BD-2359E61FE4BB}']
    procedure Add(Item: IMenuItem); safecall;
    procedure Clear; safecall;
    procedure Click; safecall;
    procedure Delete(Index: Integer); safecall;
    function Find(ACaption: IString): IMenuItem; safecall;
    function HasParent: BOOL; safecall;
    function IndexOf(Item: IMenuItem): Integer; safecall;
    procedure Insert(Index: Integer; Item: IMenuItem); safecall;
    function IsLine: BOOL; safecall;
    procedure Remove(Item: IMenuItem); safecall;
    function GetAltCaption: IString; safecall;
    function GetAltColor: TColor; safecall;
    function GetAltSize: Integer; safecall;
    function GetAutoCheck: BOOL; safecall;
    function GetBreak: TMenuBreak; safecall;
    function GetCaption: IString; safecall;
    function GetChecked: BOOL; safecall;
    function GetCommand: Word; safecall;
    function GetCount: Integer; safecall;
    function GetDefault: BOOL; safecall;
    function GetEnabled: BOOL; safecall;
    function GetGroupIndex: Byte; safecall;
    function GetHandle: HMENU; safecall;
    function GetHeadColor: TColor; safecall;
    function GetHeadFontColor: TColor; safecall;
    function GetHeadFrameColor: TColor; safecall;
    function GetHeadGradColor: TColor; safecall;
    function GetHeaderItem: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetImgURI: IString; safecall;
    function GetItemID: Word; safecall;
    function GetItem(Index: Integer): IMenuItem; safecall;
    function GetMenuIndex: Integer; safecall;
    function GetParent: IMenuItem; safecall;
    function GetRadioItem: BOOL; safecall;
    function GetRightImageURI: IString; safecall;
    function GetVisible: BOOL; safecall;
    procedure SetAltCaption(Value: IString); safecall;
    procedure SetAltColor(Value: TColor); safecall;
    procedure SetAltSize(Value: Integer); safecall;
    procedure SetAutoCheck(Value: BOOL); safecall;
    procedure SetBreak(Value: TMenuBreak); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetChecked(Value: BOOL); safecall;
    procedure SetDefault(Value: BOOL); safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetGroupIndex(Value: Byte); safecall;
    procedure SetHeadColor(Value: TColor); safecall;
    procedure SetHeadFontColor(Value: TColor); safecall;
    procedure SetHeadFrameColor(Value: TColor); safecall;
    procedure SetHeadGradColor(Value: TColor); safecall;
    procedure SetHeaderItem(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetImgURI(Value: IString); safecall;
    procedure SetItemID(Value: Word); safecall;
    procedure SetMenuIndex(Value: Integer); safecall;
    procedure SetRadioItem(Value: BOOL); safecall;
    procedure SetRightImageURI(Value: IString); safecall;
    procedure SetVisible(Value: BOOL); safecall;

    property AlternateCaption: IString read GetAltCaption write SetAltCaption;
    property AlternateFontColor: TColor read GetAltColor write SetAltColor;
    property AlternateFontSize: Integer read GetAltSize write SetAltSize;
    property AutoCheck: BOOL read GetAutoCheck write SetAutoCheck;
    property Break: TMenuBreak read GetBreak write SetBreak;
    property Caption: IString read GetCaption write SetCaption;
    property Checked: BOOL read GetChecked write SetChecked;
    property Command: Word read GetCommand ;
    property Count: Integer read GetCount ;
    property Default: BOOL read GetDefault write SetDefault;
    property Enabled: BOOL read GetEnabled write SetEnabled;
    property GroupIndex: Byte read GetGroupIndex write SetGroupIndex;
    property Handle: HMENU read GetHandle ;
    property HeadColor: TColor read GetHeadColor write SetHeadColor;
    property HeadFontColor: TColor read GetHeadFontColor write SetHeadFontColor;
    property HeadFrameColor: TColor read GetHeadFrameColor write SetHeadFrameColor;
    property HeadGradColor: TColor read GetHeadGradColor write SetHeadGradColor;
    property HeaderItem: BOOL read GetHeaderItem write SetHeaderItem;
    property Hint: IString read GetHint write SetHint;
    property ImgURI: IString read GetImgURI write SetImgURI;
    property ItemID: Word read GetItemID write SetItemID;
    property Items[Index: Integer]: IMenuItem read GetItem ;
    property MenuIndex: Integer read GetMenuIndex write SetMenuIndex;
    property Parent: IMenuItem read GetParent ;
    property RadioItem: BOOL read GetRadioItem write SetRadioItem;
    property RightImageURI: IString read GetRightImageURI write SetRightImageURI;
    property Visible: BOOL read GetVisible write SetVisible;

  end;
  
  IMenu = interface (IComponent)
  ['{3F06F0D4-687C-45AA-8AAF-C8A6727A030E}']
    function GetAutoHotkeys: TMenuAutoFlag; safecall;
    function GetHandle: HMENU; safecall;
    function GetItems: IMenuItems; safecall;
    function GetOwnerDraw: BOOL; safecall;
    procedure SetAutoHotkeys(Value: TMenuAutoFlag); safecall;
    procedure SetOwnerDraw(Value: BOOL); safecall;

    property AutoHotkeys: TMenuAutoFlag read GetAutoHotkeys write SetAutoHotkeys;
    property Handle: HMENU read GetHandle ;
    property Items: IMenuItems read GetItems ;
    property OwnerDraw: BOOL read GetOwnerDraw write SetOwnerDraw;

  end;
  
  IMainMenu = interface (IMenu)
  ['{EE06009B-3174-4D8D-B901-3DDF41348BD6}']
    procedure Merge(Menu: IMainMenu); safecall;
    procedure Unmerge(Menu: IMainMenu); safecall;
    function GetAutoMerge: BOOL; safecall;
    procedure SetAutoMerge(Value: BOOL); safecall;

    property AutoMerge: BOOL read GetAutoMerge write SetAutoMerge;

  end;
  
  IPopupMenu = interface (IMenu)
  ['{8C9D6068-8DF3-4DEF-9E4C-2E2CFAFEBF43}']
    procedure Popup(X: Integer; Y: Integer; TPM_Flags: DWORD = TPM_LEFTALIGN); safecall;
    function GetAlignment: TPopupAlignment; safecall;
    function GetAutoPopup: BOOL; safecall;
    function GetPopupPoint: TPoint; safecall;
    function GetTrackButton: TTrackButton; safecall;
    procedure SetAlignment(Value: TPopupAlignment); safecall;
    procedure SetAutoPopup(Value: BOOL); safecall;
    procedure SetTrackButton(Value: TTrackButton); safecall;

    property Alignment: TPopupAlignment read GetAlignment write SetAlignment;
    property AutoPopup: BOOL read GetAutoPopup write SetAutoPopup;
    property PopupPoint: TPoint read GetPopupPoint ;
    property TrackButton: TTrackButton read GetTrackButton write SetTrackButton;

  end;
  
  IGroupBox = interface (IWinControl)
  ['{D30F6560-D9E8-4546-8A71-1C2AEAA80A1D}']
    function GetCaption: IString; safecall;
    function GetHint: IString; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetHint(Value: IString); safecall;
    property Caption: IString read GetCaption write SetCaption;
    property Hint: IString read GetHint write SetHint;

  end;
  
  IRadioGroup = interface (IGroupBox)
  ['{CEA85243-1D10-423F-8AD5-1F4A6319A57C}']
    function GetButtons(Index: Integer): IRadioButton; safecall;
    function GetCaption: IString; safecall;
    function GetColumns: Integer; safecall;
    function GetHint: IString; safecall;
    function GetItemIndex: Integer; safecall;
    function GetItems: IStringList; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetColumns(Value: Integer); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetItemIndex(Value: Integer); safecall;
    procedure SetItems(Value: IStringList); safecall;

    property Buttons[Index: Integer]: IRadioButton read GetButtons ;
    property Caption: IString read GetCaption write SetCaption;
    property Columns: Integer read GetColumns write SetColumns;
    property Hint: IString read GetHint write SetHint;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Items: IStringList read GetItems write SetItems;

  end;
  
  IBevel = interface (IControl)
  ['{5BCEC41D-0F5D-48FB-8984-C147FDDBFC84}']
    function GetHint: IString; safecall;
    function GetShape: TBevelShape; safecall;
    function GetStyle: TBevelStyle; safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetShape(Value: TBevelShape); safecall;
    procedure SetStyle(Value: TBevelStyle); safecall;

    property Hint: IString read GetHint write SetHint;
    property Shape: TBevelShape read GetShape write SetShape;
    property Style: TBevelStyle read GetStyle write SetStyle;

  end;
  
  IStatusPanel = interface (IObject)
  ['{470F7556-476E-4D36-BDCE-8ACA507B9E0E}']
    function GetAlignment: TAlignment; safecall;
    function GetBevel: TStatusPanelBevel; safecall;
    function GetStyle: TStatusPanelStyle; safecall;
    function GetText: IString; safecall;
    function GetWidth: Integer; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetBevel(Value: TStatusPanelBevel); safecall;
    procedure SetStyle(Value: TStatusPanelStyle); safecall;
    procedure SetText(Value: IString); safecall;
    procedure SetWidth(Value: Integer); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property Bevel: TStatusPanelBevel read GetBevel write SetBevel;
    property Style: TStatusPanelStyle read GetStyle write SetStyle;
    property Text: IString read GetText write SetText;
    property Width: Integer read GetWidth write SetWidth;

  end;
  
  IStatusPanels = interface (IObject)
  ['{3A789EC2-FF96-4D86-B94B-D538C7D4478D}']
    function Add: IStatusPanel; safecall;
    function AddItem(Item: IStatusPanel; Index: Integer): IStatusPanel; safecall;
    procedure BeginUpdate; safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure EndUpdate; safecall;
    function Insert(Index: Integer): IStatusPanel; safecall;
    function GetCount: Integer; safecall;
    function GetItem(Index: Integer): IStatusPanel; safecall;
    procedure SetItem(Index: Integer; Value: IStatusPanel); safecall;

    property Count: Integer read GetCount ;
    property Items[Index: Integer]: IStatusPanel read GetItem write SetItem;

  end;
  
  IStatusBar = interface (IWinControl)
  ['{4DE089C3-8C77-40A5-B66C-B39F2F86E4FC}']
    function GetAutoHint: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetHint: IString; safecall;
    function GetPanels: IStatusPanels; safecall;
    function GetSimplePanel: BOOL; safecall;
    function GetSimpleText: IString; safecall;
    function GetSizeGrip: BOOL; safecall;
    function GetUseSystemFont: BOOL; safecall;
    procedure SetAutoHint(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetPanels(Value: IStatusPanels); safecall;
    procedure SetSimplePanel(Value: BOOL); safecall;
    procedure SetSimpleText(Value: IString); safecall;
    procedure SetSizeGrip(Value: BOOL); safecall;
    procedure SetUseSystemFont(Value: BOOL); safecall;

    property AutoHint: BOOL read GetAutoHint write SetAutoHint;
    property Canvas: ICanvas read GetCanvas ;
    property Hint: IString read GetHint write SetHint;
    property Panels: IStatusPanels read GetPanels write SetPanels;
    property SimplePanel: BOOL read GetSimplePanel write SetSimplePanel;
    property SimpleText: IString read GetSimpleText write SetSimpleText;
    property SizeGrip: BOOL read GetSizeGrip write SetSizeGrip;
    property UseSystemFont: BOOL read GetUseSystemFont write SetUseSystemFont;

  end;
  
  ISplitter = interface (IControl)
  ['{EEA2535A-2131-4D83-BCBC-0C76321252AA}']
    function GetAutoSnap: BOOL; safecall;
    function GetBeveled: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetMinSize: NaturalNumber; safecall;
    function GetResizeStyle: TResizeStyle; safecall;
    procedure SetAutoSnap(Value: BOOL); safecall;
    procedure SetBeveled(Value: BOOL); safecall;
    procedure SetMinSize(Value: NaturalNumber); safecall;
    procedure SetResizeStyle(Value: TResizeStyle); safecall;

    property AutoSnap: BOOL read GetAutoSnap write SetAutoSnap;
    property Beveled: BOOL read GetBeveled write SetBeveled;
    property Canvas: ICanvas read GetCanvas ;
    property MinSize: NaturalNumber read GetMinSize write SetMinSize;
    property ResizeStyle: TResizeStyle read GetResizeStyle write SetResizeStyle;

  end;
  
  IPanel = interface (IWinControl)
  ['{70554BBE-5EAD-4593-BC70-EBFF6F796F1A}']
    function GetAlignment: TAlignment; safecall;
    function GetBevelInner: TPanelBevel; safecall;
    function GetBevelOuter: TPanelBevel; safecall;
    function GetBevelWidth: TBevelWidth; safecall;
    function GetBorderStyle: TBorderStyle; safecall;
    function GetBorderWidth: TBorderWidth; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetCaption: IString; safecall;
    function GetErase: BOOL; safecall;
    function GetFlatBorder: BOOL; safecall;
    function GetFullRepaint: BOOL; safecall;
    function GetHint: IString; safecall;
    function GetLocked: BOOL; safecall;
    function GetNoBorders: BOOL; safecall;
    function GetParentBackground: BOOL; safecall;
    function GetParentColor: BOOL; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetBevelInner(Value: TPanelBevel); safecall;
    procedure SetBevelOuter(Value: TPanelBevel); safecall;
    procedure SetBevelWidth(Value: TBevelWidth); safecall;
    procedure SetBorderStyle(Value: TBorderStyle); safecall;
    procedure SetBorderWidth(Value: TBorderWidth); safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetErase(Value: BOOL); safecall;
    procedure SetFlatBorder(Value: BOOL); safecall;
    procedure SetFullRepaint(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetLocked(Value: BOOL); safecall;
    procedure SetNoBorders(Value: BOOL); safecall;
    procedure SetParentBackground(Value: BOOL); safecall;
    procedure SetParentColor(Value: BOOL); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property BevelInner: TPanelBevel read GetBevelInner write SetBevelInner;
    property BevelOuter: TPanelBevel read GetBevelOuter write SetBevelOuter;
    property BevelWidth: TBevelWidth read GetBevelWidth write SetBevelWidth;
    property BorderStyle: TBorderStyle read GetBorderStyle write SetBorderStyle;
    property BorderWidth: TBorderWidth read GetBorderWidth write SetBorderWidth;
    property Canvas: ICanvas read GetCanvas ;
    property Caption: IString read GetCaption write SetCaption;
    property EraseBackground: BOOL read GetErase write SetErase;
    property FlatBorder: BOOL read GetFlatBorder write SetFlatBorder;
    property FullRepaint: BOOL read GetFullRepaint write SetFullRepaint;
    property Hint: IString read GetHint write SetHint;
    property Locked: BOOL read GetLocked write SetLocked;
    property NoBorders: BOOL read GetNoBorders write SetNoBorders;
    property ParentBackground: BOOL read GetParentBackground write SetParentBackground;
    property ParentColor: BOOL read GetParentColor write SetParentColor;

  end;
  
  IParaAttributes = interface (IObject)
  ['{46E6605C-9206-430D-AF2C-E9D9CD7966B8}']
    function GetAlignment: TAlignment; safecall;
    function GetFirstIndent: Longint; safecall;
    function GetLeftIndent: Longint; safecall;
    function GetNumbering: TNumberingStyle; safecall;
    function GetRightIndent: Longint; safecall;
    function GetTab(Index: Byte): Longint; safecall;
    function GetTabCount: Integer; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetFirstIndent(Value: Longint); safecall;
    procedure SetLeftIndent(Value: Longint); safecall;
    procedure SetNumbering(Value: TNumberingStyle); safecall;
    procedure SetRightIndent(Value: Longint); safecall;
    procedure SetTab(Index: Byte; Value: Longint); safecall;
    procedure SetTabCount(Value: Integer); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property FirstIndent: Longint read GetFirstIndent write SetFirstIndent;
    property LeftIndent: Longint read GetLeftIndent write SetLeftIndent;
    property Numbering: TNumberingStyle read GetNumbering write SetNumbering;
    property RightIndent: Longint read GetRightIndent write SetRightIndent;
    property Tab[Index: Byte]: Longint read GetTab write SetTab;
    property TabCount: Integer read GetTabCount write SetTabCount;

  end;
  
  ITextAttributes = interface (IObject)
  ['{96A9F0AB-3966-49FB-A9BD-B6B07714F950}']
    function GetColor: TColor; safecall;
    function GetConsistentAttributes: TConsistentAttributes; safecall;
    function GetHeight: Integer; safecall;
    function GetName: IString; safecall;
    function GetSize: Integer; safecall;
    function GetStyle: TFontStyles; safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetHeight(Value: Integer); safecall;
    procedure SetName(Value: IString); safecall;
    procedure SetSize(Value: Integer); safecall;
    procedure SetStyle(Value: TFontStyles); safecall;

    property Color: TColor read GetColor write SetColor;
    property ConsistentAttributes: TConsistentAttributes read GetConsistentAttributes ;
    property Height: Integer read GetHeight write SetHeight;
    property Name: IString read GetName write SetName;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;

  end;
  
  ITabSheet = interface (IWinControl)
  ['{345C3003-E0DC-4092-AF47-E20C63B9BF32}']
    function GetCaption: IString; safecall;
    function GetHint: IString; safecall;
    function GetPageControl: IPageControl; safecall;
    function GetPageIndex: Integer; safecall;
    function GetTabIndex: Integer; safecall;
    function GetTabVisible: BOOL; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetPageControl(Value: IPageControl); safecall;
    procedure SetPageIndex(Value: Integer); safecall;
    procedure SetTabVisible(Value: BOOL); safecall;

    property Caption: IString read GetCaption write SetCaption;
    property Hint: IString read GetHint write SetHint;
    property PageControl: IPageControl read GetPageControl write SetPageControl;
    property PageIndex: Integer read GetPageIndex write SetPageIndex;
    property TabIndex: Integer read GetTabIndex ;
    property TabVisible: BOOL read GetTabVisible write SetTabVisible;

  end;
  
  IBaseTabControl = interface (IWinControl)
  ['{3AADC2F1-C225-4773-A641-8C40D82C497A}']
    function GetHitTestInfoAt(X: Integer; Y: Integer): THitTests; safecall;
    function IndexOfTabAt(X: Integer; Y: Integer): Integer; safecall;
    function RowCount: Integer; safecall;
    function TabRect(Index: Integer): TRect; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetDisplayRect: TRect; safecall;
    function GetHotTrack: BOOL; safecall;
    function GetMultiLine: BOOL; safecall;
    function GetStyle: TTabStyle; safecall;
    function GetTabSize: Smallint; safecall;
    function GetTabIndex: Integer; safecall;
    function GetTabPosition: TTabPosition; safecall;
    procedure SetHotTrack(Value: BOOL); safecall;
    procedure SetMultiLine(Value: BOOL); safecall;
    procedure SetStyle(Value: TTabStyle); safecall;
    procedure SetTabHeight(Value: Smallint); safecall;
    procedure SetTabIndex(Value: Integer); safecall;
    procedure SetTabPosition(Value: TTabPosition); safecall;

    property Canvas: ICanvas read GetCanvas ;
    property DisplayRect: TRect read GetDisplayRect ;
    property HotTrack: BOOL read GetHotTrack write SetHotTrack;
    property MultiLine: BOOL read GetMultiLine write SetMultiLine;
    property Style: TTabStyle read GetStyle write SetStyle;
    property TabHeight: Smallint read GetTabSize write SetTabHeight;
    property TabIndex: Integer read GetTabIndex write SetTabIndex;
    property TabPosition: TTabPosition read GetTabPosition write SetTabPosition;

  end;
  
  ITabControl = interface (IBaseTabControl)
  ['{EA2555E4-2B35-4551-B5CF-1CE2C00354D7}']
    function GetTabs: IStringList; safecall;
    procedure SetTabs(Value: IStringList); safecall;

    property Tabs: IStringList read GetTabs write SetTabs;

  end;
  
  IPageControl = interface (IBaseTabControl)
  ['{085A0F44-6C25-416E-9BE5-607BA1C2559F}']
    function FindNextPage(CurPage: ITabSheet; GoForward: BOOL; CheckTabVisible: BOOL): ITabSheet; safecall;
    procedure SelectNextPage(GoForward: BOOL; CheckTabVisible: BOOL); safecall;
    function GetActivePage: ITabSheet; safecall;
    function GetActivePageIndex: Integer; safecall;
    function GetPageCount: Integer; safecall;
    function GetPage(Index: Integer): ITabSheet; safecall;
    procedure SetActivePage(Value: ITabSheet); safecall;
    procedure SetActivePageIndex(Value: Integer); safecall;

    property ActivePage: ITabSheet read GetActivePage write SetActivePage;
    property ActivePageIndex: Integer read GetActivePageIndex write SetActivePageIndex;
    property PageCount: Integer read GetPageCount ;
    property Pages[Index: Integer]: ITabSheet read GetPage ;

  end;
  
  ITimer = interface (IComponent)
  ['{78BD461B-F083-48A7-99C5-D8E3A17F78CB}']
    function GetEnabled: BOOL; safecall;
    function GetInterval: Cardinal; safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetInterval(Value: Cardinal); safecall;

    property Enabled: BOOL read GetEnabled write SetEnabled;
    property Interval: Cardinal read GetInterval write SetInterval;

  end;
  
  IPaintBox = interface (IControl)
  ['{4D001F43-5FB1-41BE-96CE-AC2DAF8F6C74}']
    function GetCanvas: ICanvas; safecall;

    property Canvas: ICanvas read GetCanvas ;

  end;
  
  IImage = interface (IControl)
  ['{2D06DBA3-27D8-401F-922F-4DA323DFE5B7}']
    procedure Start; safecall;
    procedure Stop; safecall;
    function GetAllowAnimation: BOOL; safecall;
    function GetAutoSize: BOOL; safecall;
    function GetCanvas: ICanvas; safecall;
    function GetImageURI: IString; safecall;
    function GetScale: TScaleMetod; safecall;
    procedure SetAllowAnimation(Value: BOOL); safecall;
    procedure SetAutoSize(Value: BOOL); safecall;
    procedure SetImageURI(Value: IString); safecall;
    procedure SetScale(Value: TScaleMetod); safecall;

    property AllowAnimation: BOOL read GetAllowAnimation write SetAllowAnimation;
    property AutoSize: BOOL read GetAutoSize write SetAutoSize;
    property Canvas: ICanvas read GetCanvas ;
    property ImageURI: IString read GetImageURI write SetImageURI;
    property Scale: TScaleMetod read GetScale write SetScale;

  end;
  
  IListener = interface (IComponent)
  ['{F7934A80-0E8E-4B17-8F65-0F514179E022}']
    procedure ApplyChanges; safecall;
    function Changed: BOOL; safecall;
    function EnumChangedControls(var Index: Integer; var AControl: IComponent): BOOL; safecall;
    procedure ResetChanges; safecall;
    procedure WatchClear; safecall;
    procedure WatchForProperties(AComponentClass: TGUID; PropName: IString); overload; safecall;
    procedure WatchForProperties(AOwner: IWinControl; ClassGuid: TGUID; PropName: IString); overload; safecall;
    procedure WatchForProperty(AComponent: IComponent; PropName: IString); safecall;


  end;
  
  IMenuItems = interface (IComponent)
  ['{06DA3DF7-3575-47F4-99B9-5524E273D13A}']
    procedure Add(Item: IMenuItem); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    function Find(ACaption: IString): IMenuItem; safecall;
    function IndexOf(Item: IMenuItem): Integer; safecall;
    procedure Insert(Index: Integer; Item: IMenuItem); safecall;
    procedure Remove(Item: IMenuItem); safecall;
    function GetCaption: IString; safecall;
    function GetCount: Integer; safecall;
    function GetEnabled: BOOL; safecall;
    function GetItem(Index: Integer): IMenuItem; safecall;
    function GetParent: IMenuItem; safecall;
    function GetVisible: BOOL; safecall;
    procedure SetCaption(Value: IString); safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetVisible(Value: BOOL); safecall;

    property Caption: IString read GetCaption write SetCaption;
    property Count: Integer read GetCount ;
    property Enabled: BOOL read GetEnabled write SetEnabled;
    property Items[Index: Integer]: IMenuItem read GetItem ;
    property Parent: IMenuItem read GetParent ;
    property Visible: BOOL read GetVisible write SetVisible;

  end;
  
  IVirtualTree = interface (IWinControl)
  ['{11CFC811-931D-4423-9445-EABF83813B9D}']
    function AbsoluteIndex(Node: PVirtualNode): Cardinal; safecall;
    function AddChild(Parent: PVirtualNode): PVirtualNode; safecall;
    procedure BeginUpdate; safecall;
    function CanFocus: BOOL; safecall;
    function CancelEditNode: BOOL; safecall;
    procedure Clear; safecall;
    procedure ClearChecked; safecall;
    procedure ClearSelection; safecall;
    procedure DeleteChildren(Node: PVirtualNode; ResetHasChildren: BOOL = False); safecall;
    procedure DeleteNode(Node: PVirtualNode; Reindex: BOOL = True); safecall;
    procedure DeleteSelectedNodes; safecall;
    function EditNode(Node: PVirtualNode; Column: TColumnIndex): BOOL; safecall;
    function EndEditNode: BOOL; safecall;
    procedure EndUpdate; safecall;
    procedure FullCollapse(Node: PVirtualNode = nil); safecall;
    procedure FullExpand(Node: PVirtualNode = nil); safecall;
    function GetDisplayRect(Node: PVirtualNode; Column: TColumnIndex; TextOnly: BOOL; Unclipped: BOOL = False): TRect; safecall;
    function GetFirst: PVirtualNode; safecall;
    function GetFirstChecked(State: TCheckState = csCheckedNormal): PVirtualNode; safecall;
    function GetFirstChild(Node: PVirtualNode): PVirtualNode; safecall;
    function GetFirstSelected: PVirtualNode; safecall;
    function GetFirstVisible: PVirtualNode; safecall;
    function GetFirstVisibleChild(Node: PVirtualNode): PVirtualNode; safecall;
    procedure GetHitTestInfoAt(X: Integer; Y: Integer; Relative: BOOL; var HitInfo: THitInfo); safecall;
    function GetLast(Node: PVirtualNode = nil): PVirtualNode; safecall;
    function GetLastChild(Node: PVirtualNode): PVirtualNode; safecall;
    function GetLastVisible(Node: PVirtualNode = nil): PVirtualNode; safecall;
    function GetLastVisibleChild(Node: PVirtualNode): PVirtualNode; safecall;
    function GetMaxColumnWidth(Column: TColumnIndex): Integer; safecall;
    function GetNext(Node: PVirtualNode): PVirtualNode; safecall;
    function GetNextChecked(Node: PVirtualNode; State: TCheckState = csCheckedNormal): PVirtualNode; safecall;
    function GetNextSibling(Node: PVirtualNode): PVirtualNode; safecall;
    function GetNextVisible(Node: PVirtualNode): PVirtualNode; safecall;
    function GetNextVisibleSibling(Node: PVirtualNode): PVirtualNode; safecall;
    function GetNodeAt(X: Integer; Y: Integer): PVirtualNode; overload; safecall;
    function GetNodeAt(X: Integer; Y: Integer; Relative: BOOL; NodeTop: Integer): PVirtualNode; overload; safecall;
    function GetNodeData(Node: PVirtualNode): Integer; safecall;
    function GetNodeLevel(Node: PVirtualNode): Cardinal; safecall;
    function GetPrevious(Node: PVirtualNode): PVirtualNode; safecall;
    function GetPreviousSibling(Node: PVirtualNode): PVirtualNode; safecall;
    function GetPreviousVisible(Node: PVirtualNode): PVirtualNode; safecall;
    function GetPreviousVisibleSibling(Node: PVirtualNode): PVirtualNode; safecall;
    function GetTreeRect: TRect; safecall;
    function GetVisibleParent(Node: PVirtualNode): PVirtualNode; safecall;
    function InsertNode(Node: PVirtualNode; Mode: TVTNodeAttachMode): PVirtualNode; safecall;
    procedure InvalidateChildren(Node: PVirtualNode; Recursive: BOOL); safecall;
    procedure InvalidateColumn(Column: TColumnIndex); safecall;
    function InvalidateNode(Node: PVirtualNode): TRect; safecall;
    procedure InvalidateToBottom(Node: PVirtualNode); safecall;
    procedure InvertSelection(VisibleOnly: BOOL); safecall;
    function IsEditing: BOOL; safecall;
    function IsMouseSelecting: BOOL; safecall;
    procedure MoveTo(Source: PVirtualNode; Target: PVirtualNode; Mode: TVTNodeAttachMode; ChildrenOnly: BOOL); overload; safecall;
    procedure MoveTo(Node: PVirtualNode; Tree: IVirtualTree; Mode: TVTNodeAttachMode; ChildrenOnly: BOOL); overload; safecall;
    function Path(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; Delimiter: WideChar): IString; safecall;
    procedure RepaintNode(Node: PVirtualNode); safecall;
    procedure SelectAll(VisibleOnly: BOOL); safecall;
    procedure Sort(Node: PVirtualNode; Column: TColumnIndex; Direction: TSortDirection); safecall;
    procedure SortTree(Column: TColumnIndex; Direction: TSortDirection); safecall;
    procedure ToggleNode(Node: PVirtualNode); safecall;
    procedure ValidateNode(Node: PVirtualNode; Recursive: BOOL); safecall;
    function GetAutoValidateNodes: BOOL; safecall;
    function GetCheckState(Node: PVirtualNode): TCheckState; safecall;
    function GetCheckType(Node: PVirtualNode): TCheckType; safecall;
    function GetChildCount(Node: PVirtualNode): Cardinal; safecall;
    function GetColors: IVTColors; safecall;
    function GetDefaultNodeHeight: Cardinal; safecall;
    function GetExpanded(Node: PVirtualNode): BOOL; safecall;
    function GetFocusedColumn: TColumnIndex; safecall;
    function GetFocusedNode: PVirtualNode; safecall;
    function GetFullyVisible(Node: PVirtualNode): BOOL; safecall;
    function GetHasChildren(Node: PVirtualNode): BOOL; safecall;
    function GetHeader: ITreeHeader; safecall;
    function GetCurrentHotNode: PVirtualNode; safecall;
    function GetIsDisabled(Node: PVirtualNode): BOOL; safecall;
    function GetIsVisible(Node: PVirtualNode): BOOL; safecall;
    function GetMultiline(Node: PVirtualNode): BOOL; safecall;
    function GetNodeHeight(Node: PVirtualNode): Cardinal; safecall;
    function GetNodeParent(Node: PVirtualNode): PVirtualNode; safecall;
    function GetOffsetX: Integer; safecall;
    function GetOffsetXY: TPoint; safecall;
    function GetOffsetY: Integer; safecall;
    function GetRoot: PVirtualNode; safecall;
    function GetSelected(Node: PVirtualNode): BOOL; safecall;
    function GetSelectionCount: Integer; safecall;
    function GetNodeText(Node: PVirtualNode; Column: TColumnIndex): IString; safecall;
    function GetTopNode: PVirtualNode; safecall;
    function GetTotalCount: Cardinal; safecall;
    function GetOptions: IVirtualTreeOptions; safecall;
    function GetStates: TVirtualTreeStates; safecall;
    function GetUpdateCount: Cardinal; safecall;
    function GetVerticalAlignment(Node: PVirtualNode): Byte; safecall;
    function GetVisibleCount: Cardinal; safecall;
    function GetVisiblePath(Node: PVirtualNode): BOOL; safecall;
    procedure SetAutoValidateNodes(Value: BOOL); safecall;
    procedure SetCheckState(Node: PVirtualNode; Value: TCheckState); safecall;
    procedure SetCheckType(Node: PVirtualNode; Value: TCheckType); safecall;
    procedure SetChildCount(Node: PVirtualNode; Value: Cardinal); safecall;
    procedure SetColors(Value: IVTColors); safecall;
    procedure SetDefaultNodeHeight(Value: Cardinal); safecall;
    procedure SetExpanded(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetFocusedColumn(Value: TColumnIndex); safecall;
    procedure SetFocusedNode(Value: PVirtualNode); safecall;
    procedure SetFullyVisible(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetHasChildren(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetHeader(Value: ITreeHeader); safecall;
    procedure SetIsDisabled(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetIsVisible(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetMultiline(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetNodeData(Node: PVirtualNode; Value: Integer); safecall;
    procedure SetNodeHeight(Node: PVirtualNode; Value: Cardinal); safecall;
    procedure SetNodeParent(Node: PVirtualNode; Value: PVirtualNode); safecall;
    procedure SetOffsetX(Value: Integer); safecall;
    procedure SetOffsetXY(Value: TPoint); safecall;
    procedure SetOffsetY(Value: Integer); safecall;
    procedure SetSelected(Node: PVirtualNode; Value: BOOL); safecall;
    procedure SetNodeText(Node: PVirtualNode; Column: TColumnIndex; Value: IString); safecall;
    procedure SetTopNode(Value: PVirtualNode); safecall;
    procedure SetOptions(Value: IVirtualTreeOptions); safecall;
    procedure SetStates(Value: TVirtualTreeStates); safecall;
    procedure SetVerticalAlignment(Node: PVirtualNode; Value: Byte); safecall;
    procedure SetVisiblePath(Node: PVirtualNode; Value: BOOL); safecall;

    property AutoValidateNodes: BOOL read GetAutoValidateNodes write SetAutoValidateNodes;
    property CheckState[Node: PVirtualNode]: TCheckState read GetCheckState write SetCheckState;
    property CheckType[Node: PVirtualNode]: TCheckType read GetCheckType write SetCheckType;
    property ChildCount[Node: PVirtualNode]: Cardinal read GetChildCount write SetChildCount;
    property Colors: IVTColors read GetColors write SetColors;
    property DefaultNodeHeight: Cardinal read GetDefaultNodeHeight write SetDefaultNodeHeight;
    property Expanded[Node: PVirtualNode]: BOOL read GetExpanded write SetExpanded;
    property FocusedColumn: TColumnIndex read GetFocusedColumn write SetFocusedColumn;
    property FocusedNode: PVirtualNode read GetFocusedNode write SetFocusedNode;
    property FullyVisible[Node: PVirtualNode]: BOOL read GetFullyVisible write SetFullyVisible;
    property HasChildren[Node: PVirtualNode]: BOOL read GetHasChildren write SetHasChildren;
    property Header: ITreeHeader read GetHeader write SetHeader;
    property HotNode: PVirtualNode read GetCurrentHotNode ;
    property IsDisabled[Node: PVirtualNode]: BOOL read GetIsDisabled write SetIsDisabled;
    property IsVisible[Node: PVirtualNode]: BOOL read GetIsVisible write SetIsVisible;
    property MultiLine[Node: PVirtualNode]: BOOL read GetMultiline write SetMultiline;
    property NodeData[Node: PVirtualNode]: Integer read GetNodeData write SetNodeData;
    property NodeHeight[Node: PVirtualNode]: Cardinal read GetNodeHeight write SetNodeHeight;
    property NodeParent[Node: PVirtualNode]: PVirtualNode read GetNodeParent write SetNodeParent;
    property OffsetX: Integer read GetOffsetX write SetOffsetX;
    property OffsetXY: TPoint read GetOffsetXY write SetOffsetXY;
    property OffsetY: Integer read GetOffsetY write SetOffsetY;
    property RootNode: PVirtualNode read GetRoot ;
    property Selected[Node: PVirtualNode]: BOOL read GetSelected write SetSelected;
    property SelectedCount: Integer read GetSelectionCount ;
    property Text[Node: PVirtualNode; Column: TColumnIndex]: IString read GetNodeText write SetNodeText;
    property TopNode: PVirtualNode read GetTopNode write SetTopNode;
    property TotalCount: Cardinal read GetTotalCount ;
    property TreeOptions: IVirtualTreeOptions read GetOptions write SetOptions;
    property TreeStates: TVirtualTreeStates read GetStates write SetStates;
    property UpdateCount: Cardinal read GetUpdateCount ;
    property VerticalAlignment[Node: PVirtualNode]: Byte read GetVerticalAlignment write SetVerticalAlignment;
    property VisibleCount: Cardinal read GetVisibleCount ;
    property VisiblePath[Node: PVirtualNode]: BOOL read GetVisiblePath write SetVisiblePath;

  end;
  
  IVirtualTreeOptions = interface (IObject)
  ['{64D2DEC9-C9CC-4A01-9288-7513A4814193}']
    function GetAnimationOptions: TVTAnimationOptions; safecall;
    function GetAutoOptions: TVTAutoOptions; safecall;
    function GetMiscOptions: TVTMiscOptions; safecall;
    function GetPaintOptions: TVTPaintOptions; safecall;
    function GetSelectionOptions: TVTSelectionOptions; safecall;
    function GetStringOptions: TVTStringOptions; safecall;
    procedure SetAnimationOptions(Value: TVTAnimationOptions); safecall;
    procedure SetAutoOptions(Value: TVTAutoOptions); safecall;
    procedure SetMiscOptions(Value: TVTMiscOptions); safecall;
    procedure SetPaintOptions(Value: TVTPaintOptions); safecall;
    procedure SetSelectionOptions(Value: TVTSelectionOptions); safecall;
    procedure SetStringOptions(Value: TVTStringOptions); safecall;

    property AnimationOptions: TVTAnimationOptions read GetAnimationOptions write SetAnimationOptions;
    property AutoOptions: TVTAutoOptions read GetAutoOptions write SetAutoOptions;
    property MiscOptions: TVTMiscOptions read GetMiscOptions write SetMiscOptions;
    property PaintOptions: TVTPaintOptions read GetPaintOptions write SetPaintOptions;
    property SelectionOptions: TVTSelectionOptions read GetSelectionOptions write SetSelectionOptions;
    property StringOptions: TVTStringOptions read GetStringOptions write SetStringOptions;

  end;
  
  ITreeHeader = interface (IObject)
  ['{D2B25504-6B02-4D10-8368-E869D0AB8F9E}']
    function GetAutoSizeIndex: TColumnIndex; safecall;
    function GetBackground: TColor; safecall;
    function GetColumns: ITreeColumns; safecall;
    function GetFont: IFont; safecall;
    function GetHeight: Cardinal; safecall;
    function GetMainColumn: TColumnIndex; safecall;
    function GetOptions: TVTHeaderOptions; safecall;
    function GetParentFont: BOOL; safecall;
    function GetPopupMenu: IPopupMenu; safecall;
    function GetSortColumn: TColumnIndex; safecall;
    function GetSortDirection: TSortDirection; safecall;
    function GetStates: THeaderStates; safecall;
    function GetStyle: TVTHeaderStyle; safecall;
    function GetOwner: IVirtualTree; safecall;
    function GetUseColumns: BOOL; safecall;
    procedure SetAutoSizeIndex(Value: TColumnIndex); safecall;
    procedure SetBackground(Value: TColor); safecall;
    procedure SetColumns(Value: ITreeColumns); safecall;
    procedure SetFont(Value: IFont); safecall;
    procedure SetHeight(Value: Cardinal); safecall;
    procedure SetMainColumn(Value: TColumnIndex); safecall;
    procedure SetOptions(Value: TVTHeaderOptions); safecall;
    procedure SetParentFont(Value: BOOL); safecall;
    procedure SetPopUpMenu(Value: IPopupMenu); safecall;
    procedure SetSortColumn(Value: TColumnIndex); safecall;
    procedure SetSortDirection(Value: TSortDirection); safecall;
    procedure SetStyle(Value: TVTHeaderStyle); safecall;

    property AutoSizeIndex: TColumnIndex read GetAutoSizeIndex write SetAutoSizeIndex;
    property Background: TColor read GetBackground write SetBackground;
    property Columns: ITreeColumns read GetColumns write SetColumns;
    property Font: IFont read GetFont write SetFont;
    property Height: Cardinal read GetHeight write SetHeight;
    property MainColumn: TColumnIndex read GetMainColumn write SetMainColumn;
    property Options: TVTHeaderOptions read GetOptions write SetOptions;
    property ParentFont: BOOL read GetParentFont write SetParentFont;
    property PopupMenu: IPopupMenu read GetPopupMenu write SetPopUpMenu;
    property SortColumn: TColumnIndex read GetSortColumn write SetSortColumn;
    property SortDirection: TSortDirection read GetSortDirection write SetSortDirection;
    property States: THeaderStates read GetStates ;
    property Style: TVTHeaderStyle read GetStyle write SetStyle;
    property Treeview: IVirtualTree read GetOwner ;
    property UseColumns: BOOL read GetUseColumns ;

  end;
  
  ITreeColumns = interface (IObject)
  ['{F08FA7FC-DD51-43A7-A727-D113913F8CB7}']
    function Add: ITreeColumn; safecall;
    procedure AnimatedResize(Column: TColumnIndex; NewWidth: Integer); safecall;
    procedure Clear; safecall;
    function ColumnFromPosition(P: TPoint; Relative: BOOL = True): TColumnIndex; overload; safecall;
    function ColumnFromPosition(PositionIndex: TColumnPosition): TColumnIndex; overload; safecall;
    procedure GetColumnBounds(Column: TColumnIndex; Left: Integer; Right: Integer); safecall;
    function GetFirstVisibleColumn: TColumnIndex; safecall;
    function GetLastVisibleColumn: TColumnIndex; safecall;
    function GetNextColumn(Column: TColumnIndex): TColumnIndex; safecall;
    function GetNextVisibleColumn(Column: TColumnIndex): TColumnIndex; safecall;
    function GetPreviousColumn(Column: TColumnIndex): TColumnIndex; safecall;
    function GetPreviousVisibleColumn(Column: TColumnIndex): TColumnIndex; safecall;
    function GetVisibleFixedWidth: Integer; safecall;
    function IsValidColumn(Column: TColumnIndex): BOOL; safecall;
    function TotalWidth: Integer; safecall;
    function GetClickIndex: TColumnIndex; safecall;
    function GetCount: integer; safecall;
    function GetHeader: ITreeHeader; safecall;
    function GetItem(Index: TColumnIndex): ITreeColumn; safecall;
    function GetTrackIndex: TColumnIndex; safecall;
    procedure SetItem(Index: TColumnIndex; Value: ITreeColumn); safecall;

    property ClickIndex: TColumnIndex read GetClickIndex ;
    property Count: integer read GetCount ;
    property Header: ITreeHeader read GetHeader ;
    property Items[Index: TColumnIndex]: ITreeColumn read GetItem write SetItem;
    property TrackIndex: TColumnIndex read GetTrackIndex ;

  end;
  
  ITreeColumn = interface (IObject)
  ['{8F34DD2B-047F-41DD-AF36-D74E7F690CE4}']
    function GetRect: TRect; safecall;
    function GetAlignment: TAlignment; safecall;
    function GetColor: TColor; safecall;
    function GetHint: IString; safecall;
    function GetLayout: TVTHeaderColumnLayout; safecall;
    function GetLeft: Integer; safecall;
    function GetMargin: Integer; safecall;
    function GetMaxWidth: Integer; safecall;
    function GetMinWidth: Integer; safecall;
    function GetOptions: TVTColumnOptions; safecall;
    function GetOwner: ITreeColumns; safecall;
    function GetPosition: TColumnPosition; safecall;
    function GetSpacing: Integer; safecall;
    function GetStyle: TVirtualTreeColumnStyle; safecall;
    function GetTag: Integer; safecall;
    function GetText: IString; safecall;
    function GetWidth: Integer; safecall;
    procedure SetAlignment(Value: TAlignment); safecall;
    procedure SetColor(Value: TColor); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetLayout(Value: TVTHeaderColumnLayout); safecall;
    procedure SetMargin(Value: Integer); safecall;
    procedure SetMaxWidth(Value: Integer); safecall;
    procedure SetMinWidth(Value: Integer); safecall;
    procedure SetOptions(Value: TVTColumnOptions); safecall;
    procedure SetPosition(Value: TColumnPosition); safecall;
    procedure SetSpacing(Value: Integer); safecall;
    procedure SetStyle(Value: TVirtualTreeColumnStyle); safecall;
    procedure SetTag(Value: Integer); safecall;
    procedure SetText(Value: IString); safecall;
    procedure SetWidth(Value: Integer); safecall;

    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property Color: TColor read GetColor write SetColor;
    property Hint: IString read GetHint write SetHint;
    property Layout: TVTHeaderColumnLayout read GetLayout write SetLayout;
    property Left: Integer read GetLeft ;
    property Margin: Integer read GetMargin write SetMargin;
    property MaxWidth: Integer read GetMaxWidth write SetMaxWidth;
    property MinWidth: Integer read GetMinWidth write SetMinWidth;
    property Options: TVTColumnOptions read GetOptions write SetOptions;
    property Owner: ITreeColumns read GetOwner ;
    property Position: TColumnPosition read GetPosition write SetPosition;
    property Spacing: Integer read GetSpacing write SetSpacing;
    property Style: TVirtualTreeColumnStyle read GetStyle write SetStyle;
    property Tag: Integer read GetTag write SetTag;
    property Text: IString read GetText write SetText;
    property Width: Integer read GetWidth write SetWidth;

  end;
  
  ITrayIcon = interface (IComponent)
  ['{B57FA15F-CD3D-41C3-9A74-3A6BF1C8B81E}']
    function GetBalloonHintHandle: HWND; safecall;
    function GetClientIconPos(X: Integer; Y: Integer): TPoint; safecall;
    function GetTooltipHandle: HWND; safecall;
    function HideBalloonHint: BOOL; safecall;
    procedure Popup(X: Integer; Y: Integer); safecall;
    procedure PopupAtCursor; safecall;
    function Refresh: BOOL; safecall;
    function SetFocus: BOOL; safecall;
    function ShowBalloonHint(Title: IString; Text: IString; IconType: TBalloonHintIcon; TimeoutSecs: TBalloonHintTimeOut): BOOL; safecall;
    function GetEnabled: BOOL; safecall;
    function GetHandle: HWND; safecall;
    function GetHint: IString; safecall;
    function GetIconGuid: TGUID; safecall;
    function GetIconVisible: BOOL; safecall;
    function GetImageURI: IString; safecall;
    function GetLeftPopup: BOOL; safecall;
    function GetPopupMenu: IPopupMenu; safecall;
    function GetShowHint: BOOL; safecall;
    function GetWantEnterExitEvents: BOOL; safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetHint(Value: IString); safecall;
    procedure SetIconGuid(Value: TGUID); safecall;
    procedure SetIconVisible(Value: BOOL); safecall;
    procedure SetImageURI(Value: IString); safecall;
    procedure SetLeftPopup(Value: BOOL); safecall;
    procedure SetPopupMenu(Value: IPopupMenu); safecall;
    procedure SetShowHint(Value: BOOL); safecall;
    procedure SetWantEnterExitEvents(Value: BOOL); safecall;

    property Enabled: BOOL read GetEnabled write SetEnabled;
    property Handle: HWND read GetHandle ;
    property Hint: IString read GetHint write SetHint;
    property IconGuid: TGUID read GetIconGuid write SetIconGuid;
    property IconVisible: BOOL read GetIconVisible write SetIconVisible;
    property ImageURI: IString read GetImageURI write SetImageURI;
    property LeftPopup: BOOL read GetLeftPopup write SetLeftPopup;
    property PopupMenu: IPopupMenu read GetPopupMenu write SetPopupMenu;
    property ShowHint: BOOL read GetShowHint write SetShowHint;
    property WantEnterExitEvents: BOOL read GetWantEnterExitEvents write SetWantEnterExitEvents;

  end;
  
  IVTColors = interface (IObject)
  ['{6CC01456-E23D-4423-AFA6-1AD23DBC4FFF}']
    function GetBorderColor: TColor; safecall;
    function GetDisabledColor: TColor; safecall;
    function GetDropMarkColor: TColor; safecall;
    function GetDropTargetBorderColor: TColor; safecall;
    function GetDropTargetColor: TColor; safecall;
    function GetFocusedSelectionBorderColor: TColor; safecall;
    function GetFocusedSelectionColor: TColor; safecall;
    function GetGridLineColor: TColor; safecall;
    function GetHeaderHotColor: TColor; safecall;
    function GetHotColor: TColor; safecall;
    function GetSelectionRectangleBlendColor: TColor; safecall;
    function GetSelectionRectangleBorderColor: TColor; safecall;
    function GetTreeLineColor: TColor; safecall;
    function GetUnfocusedSelectionBorderColor: TColor; safecall;
    function GetUnfocusedSelectionColor: TColor; safecall;
    procedure SetBorderColor(Value: TColor); safecall;
    procedure SetDisabledColor(Value: TColor); safecall;
    procedure SetDropMarkColor(Value: TColor); safecall;
    procedure SetDropTargetBorderColor(Value: TColor); safecall;
    procedure SetDropTargetColor(Value: TColor); safecall;
    procedure SetFocusedSelectionBorderColor(Value: TColor); safecall;
    procedure SetFocusedSelectionColor(Value: TColor); safecall;
    procedure SetGridLineColor(Value: TColor); safecall;
    procedure SetHeaderHotColor(Value: TColor); safecall;
    procedure SetHotColor(Value: TColor); safecall;
    procedure SetSelectionRectangleBlendColor(Value: TColor); safecall;
    procedure SetSelectionRectangleBorderColor(Value: TColor); safecall;
    procedure SetTreeLineColor(Value: TColor); safecall;
    procedure SetUnfocusedSelectionBorderColor(Value: TColor); safecall;
    procedure SetUnfocusedSelectionColor(Value: TColor); safecall;

    property BorderColor: TColor read GetBorderColor write SetBorderColor;
    property DisabledColor: TColor read GetDisabledColor write SetDisabledColor;
    property DropMarkColor: TColor read GetDropMarkColor write SetDropMarkColor;
    property DropTargetBorderColor: TColor read GetDropTargetBorderColor write SetDropTargetBorderColor;
    property DropTargetColor: TColor read GetDropTargetColor write SetDropTargetColor;
    property FocusedSelectionBorderColor: TColor read GetFocusedSelectionBorderColor write SetFocusedSelectionBorderColor;
    property FocusedSelectionColor: TColor read GetFocusedSelectionColor write SetFocusedSelectionColor;
    property GridLineColor: TColor read GetGridLineColor write SetGridLineColor;
    property HeaderHotColor: TColor read GetHeaderHotColor write SetHeaderHotColor;
    property HotColor: TColor read GetHotColor write SetHotColor;
    property SelectionRectangleBlendColor: TColor read GetSelectionRectangleBlendColor write SetSelectionRectangleBlendColor;
    property SelectionRectangleBorderColor: TColor read GetSelectionRectangleBorderColor write SetSelectionRectangleBorderColor;
    property TreeLineColor: TColor read GetTreeLineColor write SetTreeLineColor;
    property UnfocusedSelectionBorderColor: TColor read GetUnfocusedSelectionBorderColor write SetUnfocusedSelectionBorderColor;
    property UnfocusedSelectionColor: TColor read GetUnfocusedSelectionColor write SetUnfocusedSelectionColor;

  end;
  
  IPage = interface (IWinControl)
  ['{B467FD3E-1B4C-43D4-93B3-BEA52B0D9B20}']
    function GetPageIndex: Integer; safecall;
    function GetPageList: IPageList; safecall;
    function GetPageVisible: BOOL; safecall;
    procedure SetPageIndex(Value: Integer); safecall;
    procedure SetPageList(Value: IPageList); safecall;
    procedure SetPageVisible(Value: BOOL); safecall;

    property PageIndex: Integer read GetPageIndex write SetPageIndex;
    property PageList: IPageList read GetPageList write SetPageList;
    property PageVisible: BOOL read GetPageVisible write SetPageVisible;

  end;
  
  IPageList = interface (IWinControl)
  ['{E9D469A9-873C-4E9D-B098-27E1A22A4F20}']
    function FindNextPage(APage: IPage; GoForward: BOOL; CheckTabVisible: BOOL): IPage; safecall;
    function SelectNextPage(GoForward: BOOL): BOOL; safecall;
    function GetActivePage: IPage; safecall;
    function GetBorderDrawStyle: TBorderDrawStyle; safecall;
    function GetPageCount: Integer; safecall;
    function GetPage(Index: Integer): IPage; safecall;
    procedure SetActivePage(Value: IPage); safecall;
    procedure SetBorderDrawStyle(Value: TBorderDrawStyle); safecall;

    property ActivePage: IPage read GetActivePage write SetActivePage;
    property BorderDrawStyle: TBorderDrawStyle read GetBorderDrawStyle write SetBorderDrawStyle;
    property PageCount: Integer read GetPageCount ;
    property Pages[Index: Integer]: IPage read GetPage ;

  end;
  
  IThemeServices = interface (IObject)
  ['{69A9F64E-6FAE-4A96-A02F-2DEBC61326F6}']
    function ContentRect(DC: HDC; Details: TThemedElementDetails; BoundingRect: TRect): TRect; safecall;
    procedure DrawEdge(DC: HDC; Details: TThemedElementDetails; R: TRect; Edge: Cardinal; Flags: Cardinal; ContentRect: PRect); safecall;
    procedure DrawElement(DC: HDC; Details: TThemedElementDetails; R: TRect; ClipRect: PRect = nil); safecall;
    procedure DrawParentBackground(Window: HWND; Target: HDC; Details: PThemedElementDetails; OnlyIfTransparent: Boolean; Bounds: PRect); safecall;
    procedure DrawText(DC: HDC; Details: TThemedElementDetails; S: IString; R: TRect; Flags: Cardinal; Flags2: Cardinal); safecall;
    function GetElementDetails(Detail: TThemedButton): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedClock): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedComboBox): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedEdit): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedExplorerBar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedHeader): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedListView): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedMenu): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedPage): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedProgress): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedRebar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedScrollBar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedSpin): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedStartPanel): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedStatus): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTab): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTaskBand): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTaskBar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedToolBar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedToolTip): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTrackBar): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTrayNotify): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedTreeview): TThemedElementDetails; overload; safecall;
    function GetElementDetails(Detail: TThemedWindow): TThemedElementDetails; overload; safecall;
    function HasTransparentParts(Details: TThemedElementDetails): BOOL; safecall;
    function GetTheme(Element: TThemedElement): HTHEME; safecall;
    function GetThemesAvailable: BOOL; safecall;
    function GetThemesEnabled: BOOL; safecall;

    property Theme[Element: TThemedElement]: HTHEME read GetTheme ;
    property ThemesAvailable: BOOL read GetThemesAvailable ;
    property ThemesEnabled: BOOL read GetThemesEnabled ;

  end;
  
  ITaskBarButton = interface (IObject)
  ['{9625DCC8-5835-4DB3-87F8-ABA2EA27152C}']
    procedure Click; safecall;
    function GetDismissOnClick: BOOL; safecall;
    function GetEnabled: BOOL; safecall;
    function GetID: Cardinal; safecall;
    function GetIcon: IString; safecall;
    function GetNoBackground: BOOL; safecall;
    function GetNoInteractive: BOOL; safecall;
    function GetToolTip: IString; safecall;
    function GetVisible: BOOL; safecall;
    procedure SetDismissOnClick(Value: BOOL); safecall;
    procedure SetEnabled(Value: BOOL); safecall;
    procedure SetIcon(Value: IString); safecall;
    procedure SetNoBackground(Value: BOOL); safecall;
    procedure SetNoInteractive(Value: BOOL); safecall;
    procedure SetToolTip(Value: IString); safecall;
    procedure SetVisible(Value: BOOL); safecall;

    property DismissOnClick: BOOL read GetDismissOnClick write SetDismissOnClick;
    property Enabled: BOOL read GetEnabled write SetEnabled;
    property ID: Cardinal read GetID ;
    property Icon: IString read GetIcon write SetIcon;
    property NoBackground: BOOL read GetNoBackground write SetNoBackground;
    property NoInteractive: BOOL read GetNoInteractive write SetNoInteractive;
    property ToolTip: IString read GetToolTip write SetToolTip;
    property Visible: BOOL read GetVisible write SetVisible;

  end;
  
  ITaskBar = interface
  ['{34E04843-98E7-4E24-8353-D3D9B1281E29}']
    function Button(index: Integer): ITaskBarButton; safecall;
    function ButtonCount: Integer; safecall;
    procedure InitInterface(AHandle: HWND); safecall;
    function GetAllowButtons: BOOL; safecall;
    function GetFullScreen: BOOL; safecall;
    function GetOverlayIcon: IString; safecall;
    function GetProgress: Int64; safecall;
    function GetProgressMax: Int64; safecall;
    function GetProgressState: TProgressState; safecall;
    procedure SetAllowButtons(Value: BOOL); safecall;
    procedure SetMarkAsFullScreen(Value: BOOL); safecall;
    procedure SetOverlayIcon(Value: IString); safecall;
    procedure SetProgress(Value: Int64); safecall;
    procedure SetProgressMax(Value: Int64); safecall;
    procedure SetProgressState(Value: TProgressState); safecall;

    property AllowButtons: BOOL read GetAllowButtons write SetAllowButtons;
    property MarkAsFullScreen: BOOL read GetFullScreen write SetMarkAsFullScreen;
    property OverlayIcon: IString read GetOverlayIcon write SetOverlayIcon;
    property Progress: Int64 read GetProgress write SetProgress;
    property ProgressMax: Int64 read GetProgressMax write SetProgressMax;
    property ProgressState: TProgressState read GetProgressState write SetProgressState;

  end;
  


  IDialogs = interface
  ['{D6BD0F6B-A951-446A-A424-E3DE8BD351FA}']
    function ShowOpen(const ParentWnd: HWND; const Caption, FileName, Filter: IString; Flags: TOFNOptions = [ofnFILEMUSTEXIST, ofnENABLESIZING]): IString; safecall;
    function ShowSave(const ParentWnd: HWND; const Caption, FileName: IString; var Filter: IString; Flags: TOFNOptions = [ofnFILEMUSTEXIST, ofnENABLESIZING]): IString; safecall;
    function ShowBrowseFolder(const ParentWnd: HWND; const Caption, Title, Dir: IString; Flags: TBIFOptions = [boNewDialogStyle, boEditBox, boUAHint]): IString; safecall;

    function ShowYesNo(const ParentWnd: HWND; const Caption, Info, CheckText, IconUri: IString; Btns: TDialogBtnStyles; var Checked: BOOL; HelpText: IString = nil; HelpUrl: IString = nil): TModalResult; safecall;
    function ShowInput(const ParentWnd: HWND; const Caption, Info, IconUri: IString; var Value: IString): TModalResult; safecall;
    function ShowEnterPass(const ParentWnd: HWND; var Pass: IString): TModalResult; safecall;
    function ShowNewPass(const ParentWnd: HWND; var CurPass, NewPass: IString): TModalResult; safecall;
  end;
implementation

end.
