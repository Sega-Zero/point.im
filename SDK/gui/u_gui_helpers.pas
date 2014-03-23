unit u_gui_helpers;

interface
uses
  Windows, Types, Classes, SysUtils, StrUtils,
  u_gui_intf, u_gui_events, u_gui_const, u_gui_graphics, u_string;

type
  TOnClose           = procedure(Sender: IComponent; var Action: TCloseAction) of object;
  TOnPropertyChanged = procedure(Sender: IUnknown; Component: IComponent) of object;
  TGUINotifyEvent    = procedure(Sender: IComponent) of object;

  TOnTreeGetText     = procedure(Sender: IVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                 TextType: TVSTTextType; var Text: IString) of object;
  TOnTreeGetHint     = procedure(Sender: IVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                 var LineBreakStyle: TTooltipLineBreakStyle; var HintText: IString) of object;
  TOnInitNode        = procedure(Sender: IVirtualTree; Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates) of object;
  TOnFreeNode        = procedure(Sender: IVirtualTree; Node: PVirtualNode) of object;
  TOnKeyUpDown       = procedure(Sender: IComponent; var Key: Word; Shift: TShiftState) of object;
  TOnKeyPress        = procedure(Sender: IComponent; var Key: Char) of object;
  TOnListDrawItem    = procedure(Control: IWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState) of object;
  TOnAlign           = procedure(Sender: IUnknown; Control: IControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect) of object;
  TOnMouse           = procedure(Sender: IComponent; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseMove       = procedure(Sender: IComponent; Shift: TShiftState; X, Y: Integer) of object;

  TCustomEventsCallback = class(TInterfacedObject, IEventsCallback)
  protected
    FOnEventsCallback: TGUINotifyEvent;
    procedure SetEvent(Control: IComponent); virtual; safecall;
  public
    constructor Create(OnEventsCallback: TGUINotifyEvent);
  end;

  TCustomWindowEvents = class(TInterfacedObject, IWindowEvents, IGuiEvents)
  protected
    FOnFreeComponent: TGUINotifyEvent;
    FOnClose: TOnClose;
    FOnPropertyChanged: TOnPropertyChanged;
  protected
    procedure Activated(sender: IUnknown); virtual; safecall;
    procedure Closed(sender: IUnknown; var Action: TCloseAction); virtual; safecall;
    procedure CloseQuery(sender: IUnknown; var CanClose: BOOL); virtual; safecall;
    procedure Created(sender: IUnknown); virtual; safecall;
    procedure Destroyed(sender: IUnknown); virtual; safecall;
    procedure Deactivated(sender: IUnknown); virtual; safecall;
    procedure PropertyChanged(sender: IUnknown; component: IComponent); virtual; safecall;
  protected
    procedure LanguageChanged(NewLangName: IString); virtual; safecall;
    procedure SkinChanged(NewSkinName: IString); virtual; safecall;
    procedure AntiBossChanged(const Activated: BOOL); virtual; safecall;
    procedure FreeNotify(sender: IComponent); virtual; safecall;
  public
    constructor Create(OnFreeComponent: TGUINotifyEvent; OnClose: TOnClose; OnPropertyChanged: TOnPropertyChanged);
  end;

  TCustomClickEvent = class(TInterfacedObject, IMouseClickEvents)
  protected
    FOnClick: TGUINotifyEvent;
    FOnUp   : TOnMouse;
    FOnDown : TOnMouse;

    procedure Click(sender: IUnknown); virtual; safecall;
    procedure DblClick(sender: IUnknown); virtual; safecall;
    procedure MouseDown(sender: IUnknown; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; safecall;
    procedure MouseUp(sender: IUnknown; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; safecall;
    procedure UpDownClick(sender: IUnknown; Button: TUDBtnType); virtual; safecall;
  public
    constructor Create(OnClick: TGUINotifyEvent; OnUp: TOnMouse = nil; OnDown: TOnMouse = nil);
  end;

  TCustomMoveEvent = class(TInterfacedObject, IMouseMoveEvents)
  protected
    FOnMouseEnter: TGUINotifyEvent;
    FOnMouseLeave: TGUINotifyEvent;
    FOnMouseMove : TOnMouseMove;

    procedure MouseMove(Sender: IUnknown; Shift: TShiftState; X, Y: Integer); virtual; safecall;
    procedure MouseEnter(Sender: IUnknown); virtual; safecall;
    procedure MouseLeave(Sender: IUnknown); virtual; safecall;
  public
    constructor Create(OnMouseMove: TOnMouseMove; OnMouseEnter, OnMouseLeave: TGUINotifyEvent);
  end;

  TMouseEvent = class(TInterfacedObject, IMouseClickEvents, IMouseMoveEvents)
  protected
    FEvClick : IMouseClickEvents;
    FEvMove  : IMouseMoveEvents;
  public
    property EvClick : IMouseClickEvents read FEvClick implements IMouseClickEvents;
    property EvMove  : IMouseMoveEvents  read FEvMove  implements IMouseMoveEvents;

    constructor Create(AEvClick: IMouseClickEvents; AEvMove: IMouseMoveEvents);
  end;

  TCustomTreeViewEvent = class(TInterfacedObject, ITreeGetEvents, INodeControlEvents)
  protected
    FOnGetText: TOnTreeGetText;
    FOnGetHint: TOnTreeGetHint;
    FOnFreeNode: TOnFreeNode;
    FOnInitNode: TOnInitNode;

    {ITreeGetEvents}
    procedure GetCellIsEmpty(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex; var IsEmpty: BOOL); virtual; safecall;
    procedure GetCursor(Sender: IUnknown; var Cursor: TCursor); virtual; safecall;
    procedure GetHeaderCursor(Sender: IUnknown; var Cursor: HICON); virtual; safecall;
    procedure GetHint(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                      var LineBreakStyle: TTooltipLineBreakStyle; var HintText: IString); virtual; safecall;
    procedure GetPopupMenu(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                           const P: TPoint; var AskParent: BOOL; var PopupMenu: IPopupMenu); virtual; safecall;
    procedure GetLineStyle(Sender: IUnknown); virtual; safecall;
    procedure GetText(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                      TextType: TVSTTextType; var Text: IString); virtual; safecall;

    {INodeControlEvents}
    procedure CompareNodes(Sender: IUnknown; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer); virtual; safecall;
    procedure DidInitNode(Sender: IUnknown; Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates); virtual; safecall;
    procedure DidFreeNode(Sender: IUnknown; Node: PVirtualNode); virtual; safecall;
    procedure IncrementalSearch(Sender: IUnknown; Node: PVirtualNode; const SearchText: IString; var Result: Integer; var Handled: BOOL); virtual; safecall;
    procedure NodeMeasureItem(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; var NodeHeight: Integer); virtual; safecall;
    procedure ShortenString(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode;
                            Column: TColumnIndex; const S: IString; TextSpace: Integer;
                            var Result: IString; var Done: BOOL); virtual; safecall;
  public
    constructor Create(OnGetText: TOnTreeGetText; OnGetHint: TOnTreeGetHint; OnInitNode: TOnInitNode; OnFreeNode: TOnFreeNode);
  end;

  TCustomTreeViewPaintEvent = class(TInterfacedObject, ITreePaintEvents)
  protected
    procedure AdvancedHeaderDraw(Sender: ITreeHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements); virtual; safecall;
    //after draw
    procedure AfterCellPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); virtual; safecall;
    procedure AfterItemErase(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect); virtual; safecall;
    procedure AfterItemPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect); virtual; safecall;
    procedure AfterPaint(Sender: IUnknown; TargetCanvas: ICanvas); virtual; safecall;
    //before draw
    procedure BeforeCellPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); virtual; safecall;
    procedure BeforeItemErase(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect;
                              var ItemColor: TColor; var EraseAction: TItemEraseAction); virtual; safecall;
    procedure BeforeItemPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect; var CustomDraw: BOOL); virtual; safecall;
    procedure BeforePaint(Sender: IUnknown; TargetCanvas: ICanvas); virtual; safecall;
    //header drawing
    procedure HeaderDraw(Sender: ITreeHeader; HeaderCanvas: ICanvas; Column: ITreeColumn;
                         R: TRect; Hover, Pressed: BOOL; DropMark: TVTDropMarkMode); virtual; safecall;
    procedure HeaderDrawQueryElements(Sender: ITreeHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements); virtual; safecall;
    //tree painting
    procedure PaintBackground(Sender: IUnknown; TargetCanvas: ICanvas; R: TRect; var Handled: BOOL); virtual; safecall;
    procedure PaintText(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType); virtual; safecall;
  end;
  
  TCustomKeybEvent = class(TInterfacedObject, IKeyboardEvents)
  protected
    FOnDown : TOnKeyUpDown;
    FOnUp   : TOnKeyUpDown;
    FOnPress: TOnKeyPress;

    procedure DidEnter(sender: IUnknown); virtual; safecall;
    procedure DidExit(sender: IUnknown); virtual; safecall;
    procedure KeyUp(sender: IUnknown; var Key: Word; Shift: TShiftState); virtual; safecall;
    procedure KeyDown(sender: IUnknown; var Key: Word; Shift: TShiftState); virtual; safecall;
    procedure KeyPress(sender: IUnknown; var Key: Char); virtual; safecall;
  public
    constructor Create(OnDown: TOnKeyUpDown; OnUp: TOnKeyUpDown; OnPress: TOnKeyPress);
  end;

  TCustomChangeEvent = class(TInterfacedObject, IChangeEvents)
  protected
    FOnChanged : TGUINotifyEvent;
    FOnSelect  : TGUINotifyEvent;

    procedure Changed(sender: IUnknown); virtual; safecall;
    procedure Changing(sender: IUnknown; var AllowChange: BOOL); virtual; safecall;
    procedure ChangingEx(sender: IUnknown; var AllowChange: BOOL; NewValue: SmallInt; Direction: TUpDownDirection); virtual; safecall;
    procedure SelectionChange(sender: IUnknown); virtual; safecall;
  public
    constructor Create(OnChanged : TGUINotifyEvent);
  end;

  TCustomPaintEvent = class(TInterfacedObject, IPaintEvents)
  protected
    FOnPaint : TGUINotifyEvent;
    FOnListDrawItem: TOnListDrawItem;

    procedure Paint(sender: IUnknown); virtual; safecall;
    procedure ToolBarCustomDraw(sender: IToolBar; ARect: TRect; var DefaultDraw: BOOL); virtual; safecall;
    procedure ToolBarCustomDrawButton(sender: IToolBar; Button: IToolButton; State: TCustomDrawState; var DefaultDraw: BOOL); virtual; safecall;
    procedure ListDrawItem(Control: IWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL); virtual; safecall;
    procedure MenuItemDrawItem(sender: IUnknown; ACanvas: ICanvas; ARect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL); virtual; safecall;
  public
    constructor Create(OnPaint : TGUINotifyEvent);
  end;

  TListBoxEvents = class(TInterfacedObject, IPaintEvents, IMouseClickEvents)
  protected
    FPaint : IPaintEvents; //TCustomPaintEvent;
    FClick : IMouseClickEvents; //TCustomClickEvent;
  public
    property OnPaint: IPaintEvents read FPaint implements IPaintEvents;
    property OnClick: IMouseClickEvents read FClick implements IMouseClickEvents;
    constructor Create(OnSelect: TGUINotifyEvent; OnDrawItem: TOnListDrawItem);
  end;

  TWindowEvents = class(TInterfacedObject, IWindowEvents, IKeyboardEvents, ISizeMoveEvents)
  protected
    FWnd  : IWindowEvents;
    FKeyb : IKeyboardEvents;
    FOnSized: TGUINotifyEvent;
    FOnAlign: TOnAlign;
    procedure CanResize(sender: IUnknown; var NewWidth, NewHeight: Integer; var Resize: BOOL); virtual; safecall;
    procedure Resized(sender: IUnknown); virtual; safecall;
    procedure Moved(sender: IUnknown); virtual; safecall;
    procedure AlignControls(sender: IUnknown; Control: IControl;
                            var NewLeft, NewTop, NewWidth, NewHeight: Integer;
                            var AlignRect: TRect); virtual; safecall;
  public
    property OnWnd  : IWindowEvents   read FWnd   implements IWindowEvents;
    property OnKeyb : IKeyboardEvents read FKeyb  implements IKeyboardEvents;

    constructor Create(OnFreeComponent: TGUINotifyEvent; OnClose: TOnClose; OnKeyUp: TOnKeyUpDown; OnSized: TGUINotifyEvent; OnAlign: TOnAlign);
  end;

  TTimerEvents = class(TInterfacedObject, ITimerEvents)
  protected
    FOnTimer: TGUINotifyEvent;
    procedure DidTimer(sender: IInterface); virtual; safecall;
  public
    property OnTimer: TGUINotifyEvent read FOnTimer write FOnTimer;
    constructor Create(AOnTimer: TGUINotifyEvent);
  end;

//find component by Name and return it as IID interface
function GetComponent(AForm: IForm; CtlName: WideString; var Obj; IID: TGUID): Boolean;
function CreateMenuItem(GUI: IQIPCoreGUI; Owner: IComponent): IMenuItem;
function GetGraphImage(GR_ID: Integer): IString;
function CreateIString(const s: WideString): IString;

implementation

function CreateIString(const s: WideString): IString;
begin
  Result := u_string.GetIString(s);
end;

function GetGraphImage(GR_ID: Integer): IString;
begin
  Result := CreateIString(ImageURIFromID(GR_ID));
end;

function CreateMenuItem(GUI: IQIPCoreGUI; Owner: IComponent): IMenuItem;
begin
  Result := nil;
  if Owner = nil then Exit;
  GUI.CreateControl(Owner, IMenuItem, Result, nil);
end;

function GetComponent(AForm: IForm; CtlName: WideString; var Obj; IID: TGUID): Boolean;
var
  tmp: IComponent;
begin
  Result       := False;
  Pointer(Obj) := nil;
  if (AForm = nil) or (CtlName = '') then
    Exit;
  tmp := AForm.FindComponent(CreateIString(CtlName));
  Result := Assigned(tmp) and Supports(tmp, IID, Obj);
  tmp := nil;
end;

{ TCustomEventsCallback }

constructor TCustomEventsCallback.Create(OnEventsCallback: TGUINotifyEvent);
begin
  inherited Create();
  FOnEventsCallback := OnEventsCallback;
end;

procedure TCustomEventsCallback.SetEvent(Control: IComponent);
begin
  if Assigned(FOnEventsCallback) then
    FOnEventsCallback(Control);
end;

{ TCustomWindowEvents }

procedure TCustomWindowEvents.Activated(sender: IInterface);
begin

end;

procedure TCustomWindowEvents.Closed(sender: IInterface; var Action: TCloseAction);
var
  ctl: IComponent;
begin
  if Assigned(FOnClose) then
    if Supports(sender, IComponent, ctl) then
      FOnClose(ctl, Action);
end;

procedure TCustomWindowEvents.CloseQuery(sender: IInterface; var CanClose: BOOL);
begin

end;

constructor TCustomWindowEvents.Create(OnFreeComponent: TGUINotifyEvent; OnClose: TOnClose; OnPropertyChanged: TOnPropertyChanged);
begin
  inherited Create();
  FOnFreeComponent   := OnFreeComponent;
  FOnClose           := OnClose;
  FOnPropertyChanged := OnPropertyChanged;
end;

procedure TCustomWindowEvents.Created(sender: IInterface);
begin

end;

procedure TCustomWindowEvents.Deactivated(sender: IInterface);
begin

end;

procedure TCustomWindowEvents.Destroyed(sender: IInterface);
begin

end;

procedure TCustomWindowEvents.PropertyChanged(sender: IInterface; component: IComponent);
begin
  if Assigned(FOnPropertyChanged) then
    FOnPropertyChanged(sender, component);
end;

procedure TCustomWindowEvents.AntiBossChanged(const Activated: BOOL);
begin

end;

procedure TCustomWindowEvents.LanguageChanged(NewLangName: IString);
begin

end;

procedure TCustomWindowEvents.SkinChanged(NewSkinName: IString);
begin

end;

procedure TCustomWindowEvents.FreeNotify(sender: IComponent);
begin
  if Assigned(FOnFreeComponent) then
    FOnFreeComponent(sender);
end;

{ TCustomClickEvent }

constructor TCustomClickEvent.Create(OnClick: TGUINotifyEvent; OnUp: TOnMouse; OnDown: TOnMouse);
begin
  inherited Create();
  FOnClick := OnClick;
  FOnUp    := OnUp;
  FOnDown  := OnDown;
end;

procedure TCustomClickEvent.Click(sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnClick) then
    if Supports(sender, IComponent, ctl) then
      FOnClick(ctl);
end;

procedure TCustomClickEvent.DblClick(sender: IInterface);
begin

end;

procedure TCustomClickEvent.MouseDown(sender: IInterface;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ctl: IComponent;
begin
  if Assigned(FOnDown) then
    if Supports(sender, IComponent, ctl) then
      FOnDown(ctl, Button, Shift, X, Y);
end;

procedure TCustomClickEvent.MouseUp(sender: IInterface;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ctl: IComponent;
begin
  if Assigned(FOnUp) then
    if Supports(sender, IComponent, ctl) then
      FOnUp(ctl, Button, Shift, X, Y);
end;

procedure TCustomClickEvent.UpDownClick(sender: IInterface;
  Button: TUDBtnType);
begin

end;

{ TCustomTreeViewEvent }

constructor TCustomTreeViewEvent.Create(OnGetText: TOnTreeGetText;
  OnGetHint: TOnTreeGetHint; OnInitNode: TOnInitNode; OnFreeNode: TOnFreeNode);
begin
  inherited Create();
  FOnGetText  := OnGetText;
  FOnGetHint  := OnGetHint;
  FOnInitNode := OnInitNode;
  FOnFreeNode := OnFreeNode;
end;

procedure TCustomTreeViewEvent.DidFreeNode(Sender: IInterface; Node: PVirtualNode);
var
  ctl: IVirtualTree;
begin
  if Assigned(FOnFreeNode) then
    if Supports(Sender, IVirtualTree, ctl) then
      FOnFreeNode(ctl, Node);
end;

procedure TCustomTreeViewEvent.DidInitNode(Sender: IInterface;
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  ctl: IVirtualTree;
begin
  if Assigned(FOnInitNode) then
    if Supports(Sender, IVirtualTree, ctl) then
      FOnInitNode(ctl, Node, InitialStates);
end;

procedure TCustomTreeViewEvent.GetText(Sender: IInterface;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var Text: IString);
var
  ctl: IVirtualTree;
begin
  if Assigned(FOnGetText) then
    if Supports(Sender, IVirtualTree, ctl) then
      FOnGetText(ctl, Node, Column, TextType, Text);
end;

procedure TCustomTreeViewEvent.GetHint(Sender: IInterface;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TTooltipLineBreakStyle; var HintText: IString);
var
  ctl: IVirtualTree;
begin
  if Assigned(FOnGetHint) then
    if Supports(Sender, IVirtualTree, ctl) then
      FOnGetHint(ctl, Node, Column, LineBreakStyle, HintText);
end;

procedure TCustomTreeViewEvent.CompareNodes(Sender: IInterface; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
begin

end;

procedure TCustomTreeViewEvent.GetCellIsEmpty(Sender: IInterface;
  Node: PVirtualNode; Column: TColumnIndex; var IsEmpty: BOOL);
begin

end;

procedure TCustomTreeViewEvent.GetCursor(Sender: IInterface;
  var Cursor: TCursor);
begin

end;

procedure TCustomTreeViewEvent.GetHeaderCursor(Sender: IInterface;
  var Cursor: HICON);
begin

end;

procedure TCustomTreeViewEvent.GetLineStyle(Sender: IInterface);
begin

end;

procedure TCustomTreeViewEvent.GetPopupMenu(Sender: IInterface;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: BOOL; var PopupMenu: IPopupMenu);
begin

end;

procedure TCustomTreeViewEvent.IncrementalSearch(Sender: IInterface;
  Node: PVirtualNode; const SearchText: IString; var Result: Integer;
  var Handled: BOOL);
begin

end;

procedure TCustomTreeViewEvent.NodeMeasureItem(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin

end;

procedure TCustomTreeViewEvent.ShortenString(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex;
  const S: IString; TextSpace: Integer; var Result: IString;
  var Done: BOOL);
begin

end;

{ TCustomKeybEvent }

constructor TCustomKeybEvent.Create(OnDown: TOnKeyUpDown; OnUp: TOnKeyUpDown; OnPress: TOnKeyPress);
begin
  inherited Create();
  FOnDown := OnDown;
  FOnUp   := OnUp;
  FOnPress:= OnPress; 
end;

procedure TCustomKeybEvent.DidEnter(sender: IInterface);
begin

end;

procedure TCustomKeybEvent.DidExit(sender: IInterface);
begin

end;

procedure TCustomKeybEvent.KeyDown(sender: IInterface; var Key: Word; Shift: TShiftState);
var
  ctl: IComponent;
begin
  if Assigned(FOnDown) then
    if Supports(Sender, IComponent, ctl) then
      FOnDown(ctl, Key, Shift);
end;

procedure TCustomKeybEvent.KeyPress(sender: IInterface; var Key: Char);
var
  ctl: IComponent;
begin
  if Assigned(FOnPress) then
    if Supports(Sender, IComponent, ctl) then
      FOnPress(ctl, Key);
end;

procedure TCustomKeybEvent.KeyUp(sender: IInterface; var Key: Word; Shift: TShiftState);
var
  ctl: IComponent;
begin
  if Assigned(FOnUp) then
    if Supports(Sender, IComponent, ctl) then
      FOnUp(ctl, Key, Shift);
end;

{ TCustomChangeEvent }

constructor TCustomChangeEvent.Create(OnChanged: TGUINotifyEvent);
begin
  inherited Create();
  FOnChanged := OnChanged;
end;

procedure TCustomChangeEvent.Changed(sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnChanged) then
    if Supports(Sender, IComponent, ctl) then
      FOnChanged(ctl);
end;

procedure TCustomChangeEvent.Changing(sender: IInterface; var AllowChange: BOOL);
begin

end;

procedure TCustomChangeEvent.ChangingEx(sender: IInterface;
  var AllowChange: BOOL; NewValue: SmallInt; Direction: TUpDownDirection);
begin

end;

procedure TCustomChangeEvent.SelectionChange(sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnSelect) then
    if Supports(Sender, IComponent, ctl) then
      FOnSelect(ctl);
end;

{ TCustomPaintEvent }

constructor TCustomPaintEvent.Create(OnPaint: TGUINotifyEvent);
begin
  inherited Create();
  FOnPaint := OnPaint;
end;

procedure TCustomPaintEvent.Paint(sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnPaint) then
    if Supports(Sender, IComponent, ctl) then
      FOnPaint(ctl);
end;

procedure TCustomPaintEvent.ListDrawItem(Control: IWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL);
begin
  if Assigned(FOnListDrawItem) then
    FOnListDrawItem(Control, Index, Rect, State);
end;

procedure TCustomPaintEvent.MenuItemDrawItem(sender: IInterface;
  ACanvas: ICanvas; ARect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL);
begin

end;

procedure TCustomPaintEvent.ToolBarCustomDraw(sender: IToolBar;
  ARect: TRect; var DefaultDraw: BOOL);
begin

end;

procedure TCustomPaintEvent.ToolBarCustomDrawButton(sender: IToolBar;
  Button: IToolButton; State: TCustomDrawState; var DefaultDraw: BOOL);
begin

end;

{ TListBoxEvents }

constructor TListBoxEvents.Create(OnSelect: TGUINotifyEvent; OnDrawItem: TOnListDrawItem);
var
  pe: TCustomPaintEvent;
begin
  inherited Create();
  pe                 := TCustomPaintEvent.Create(nil);
  pe.FOnListDrawItem := OnDrawItem;
  FPaint             := pe;
  FClick             := TCustomClickEvent.Create(OnSelect);
end;

{ TWindowEvents }

constructor TWindowEvents.Create(OnFreeComponent: TGUINotifyEvent; OnClose: TOnClose; OnKeyUp: TOnKeyUpDown; OnSized: TGUINotifyEvent; OnAlign: TOnAlign);
begin
  inherited Create();
  FWnd  := TCustomWindowEvents.Create(OnFreeComponent, OnClose, nil);
  FKeyb := TCustomKeybEvent.Create(nil, OnKeyUp, nil);
  FOnSized := OnSized;
  FOnAlign := OnAlign;
end;

procedure TWindowEvents.AlignControls(sender: IInterface;
  Control: IControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer;
  var AlignRect: TRect);
begin
  if Assigned(FOnAlign) then
    FOnAlign(sender, Control, NewLeft, NewTop, NewWidth, NewHeight, AlignRect);
end;

procedure TWindowEvents.CanResize(sender: IInterface; var NewWidth,
  NewHeight: Integer; var Resize: BOOL);
begin

end;

procedure TWindowEvents.Moved(sender: IInterface);
begin

end;

procedure TWindowEvents.Resized(sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnSized) then
    if Supports(Sender, IComponent, ctl) then
      FOnSized(ctl);
end;

{ TTimerHandler }

constructor TTimerEvents.Create(AOnTimer: TGUINotifyEvent);
begin
  inherited Create();
  FOnTimer := AOnTimer;
end;

procedure TTimerEvents.DidTimer(sender: IInterface);
var
  RefHolder: IInterface;
  ctl: IComponent;
begin
  RefHolder := sender; //_AddRef
  try
    if Assigned(FOnTimer) then
      if Supports(Sender, IComponent, ctl) then
        FOnTimer(ctl);
  finally
    RefHolder := nil; //_Release;
  end;
end;

{ TCustomMoveEvent }

constructor TCustomMoveEvent.Create(OnMouseMove: TOnMouseMove; OnMouseEnter, OnMouseLeave: TGUINotifyEvent);
begin
  inherited Create();
  FOnMouseMove  := OnMouseMove;
  FOnMouseEnter := OnMouseEnter;
  FOnMouseLeave := OnMouseLeave;
end;

procedure TCustomMoveEvent.MouseEnter(Sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnMouseEnter) then
    if Supports(Sender, IComponent, ctl) then
      FOnMouseEnter(ctl);
end;

procedure TCustomMoveEvent.MouseLeave(Sender: IInterface);
var
  ctl: IComponent;
begin
  if Assigned(FOnMouseLeave) then
    if Supports(Sender, IComponent, ctl) then
      FOnMouseLeave(ctl);
end;

procedure TCustomMoveEvent.MouseMove(Sender: IInterface; Shift: TShiftState; X, Y: Integer);
var
  ctl: IComponent;
begin
  if Assigned(FOnMouseMove) then
    if Supports(Sender, IComponent, ctl) then
      FOnMouseMove(ctl, Shift, X, Y);
end;

{ TMouseEvent }

constructor TMouseEvent.Create(AEvClick: IMouseClickEvents; AEvMove: IMouseMoveEvents);
begin
  inherited Create();
  FEvClick := AEvClick;
  FEvMove  := AEvMove;
  Assert(Assigned(AEvClick), 'AEvClick must be assigned');
  Assert(Assigned(AEvMove), 'AEvMove must be assigned');
end;

{ TCustomTreeViewPaintEvent }

procedure TCustomTreeViewPaintEvent.AdvancedHeaderDraw(Sender: ITreeHeader;
  var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
begin

end;

procedure TCustomTreeViewPaintEvent.AfterCellPaint(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
begin

end;

procedure TCustomTreeViewPaintEvent.AfterItemErase(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect);
begin

end;

procedure TCustomTreeViewPaintEvent.AfterItemPaint(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect);
begin

end;

procedure TCustomTreeViewPaintEvent.AfterPaint(Sender: IInterface;
  TargetCanvas: ICanvas);
begin

end;

procedure TCustomTreeViewPaintEvent.BeforeCellPaint(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
begin

end;

procedure TCustomTreeViewPaintEvent.BeforeItemErase(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin

end;

procedure TCustomTreeViewPaintEvent.BeforeItemPaint(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect;
  var CustomDraw: BOOL);
begin

end;

procedure TCustomTreeViewPaintEvent.BeforePaint(Sender: IInterface;
  TargetCanvas: ICanvas);
begin

end;

procedure TCustomTreeViewPaintEvent.HeaderDraw(Sender: ITreeHeader;
  HeaderCanvas: ICanvas; Column: ITreeColumn; R: TRect; Hover,
  Pressed: BOOL; DropMark: TVTDropMarkMode);
begin

end;

procedure TCustomTreeViewPaintEvent.HeaderDrawQueryElements(
  Sender: ITreeHeader; var PaintInfo: THeaderPaintInfo;
  const Elements: THeaderPaintElements);
begin

end;

procedure TCustomTreeViewPaintEvent.PaintBackground(Sender: IInterface;
  TargetCanvas: ICanvas; R: TRect; var Handled: BOOL);
begin

end;

procedure TCustomTreeViewPaintEvent.PaintText(Sender: IInterface;
  TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin

end;

end.
