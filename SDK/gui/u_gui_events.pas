unit u_gui_events;

interface

uses Windows, u_gui_intf, u_gui_const, u_string;

type
  IShowEvents = interface
  ['{14690BC7-D6EB-450A-8A9C-08E6354DFF6B}']
    procedure DidShow(sender: IUnknown); safecall;
    procedure DidHide(sender: IUnknown); safecall;
  end;

  IMouseClickEvents = interface
  ['{F14A66EC-E252-48C7-A75B-DD17EDFF1A3A}']
    procedure Click(sender: IUnknown); safecall;
    procedure DblClick(sender: IUnknown); safecall;
    procedure MouseDown(sender: IUnknown; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); safecall;
    procedure MouseUp(sender: IUnknown; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); safecall;
    procedure UpDownClick(sender: IUnknown; Button: TUDBtnType); safecall;
  end;

  IMouseMoveEvents = interface
  ['{D140A167-0A85-41C0-9783-EEBDAB0C05A0}']
    procedure MouseMove(sender: IUnknown; Shift: TShiftState; X, Y: Integer); safecall;
    procedure MouseEnter(sender: IUnknown); safecall;
    procedure MouseLeave(sender: IUnknown); safecall;
  end;

  IMouseWheelEvents = interface
  ['{7D359A35-7C7F-4A77-A84A-2FAD29E1D38A}']
    procedure MouseWheel(Sender: IUnknown; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: BOOL); safecall;
    procedure MouseWheelUp(Sender: IUnknown; Shift: TShiftState; MousePos: TPoint; var Handled: BOOL); safecall;
    procedure MouseWheelDown(Sender: IUnknown; Shift: TShiftState; MousePos: TPoint; var Handled: BOOL); safecall;
    procedure DidScroll(Sender: IUnknown; DeltaX, DeltaY: Integer); safecall;
  end;

  IKeyboardEvents = interface
  ['{A6C4ADAD-84A1-4ABF-8054-B18FCBE34625}']
    procedure DidEnter(sender: IUnknown); safecall;
    procedure DidExit(sender: IUnknown); safecall;
    procedure KeyUp(sender: IUnknown; var Key: Word; Shift: TShiftState); safecall;
    procedure KeyDown(sender: IUnknown; var Key: Word; Shift: TShiftState); safecall;
    procedure KeyPress(sender: IUnknown; var Key: Char); safecall;
  end;

  ISizeMoveEvents = interface
  ['{5A3B8000-CAF9-45EA-88D8-0CB3711E77BC}']
    procedure CanResize(sender: IUnknown; var NewWidth, NewHeight: Integer; var Resize: BOOL); safecall;
    procedure Resized(sender: IUnknown); safecall;
    procedure Moved(sender: IUnknown); safecall;
    procedure AlignControls(sender: IUnknown; Control: IControl;
                            var NewLeft, NewTop, NewWidth, NewHeight: Integer;
                            var AlignRect: TRect); safecall;
  end;

  IWindowEvents = interface
  ['{BAAEDC05-A20B-4384-8AF0-91619971D913}']
    procedure Activated(sender: IUnknown); safecall;
    procedure Closed(sender: IUnknown; var Action: TCloseAction); safecall;
    procedure CloseQuery(sender: IUnknown; var CanClose: BOOL); safecall;
    procedure Created(sender: IUnknown); safecall;
    procedure Destroyed(sender: IUnknown); safecall;
    procedure Deactivated(sender: IUnknown); safecall;
    procedure PropertyChanged(sender: IUnknown; component: IComponent); safecall;
  end;

  IPaintEvents = interface
  ['{82B1CCF9-289D-44C3-80A3-1452BBE66CA9}']
    procedure Paint(sender: IUnknown); safecall;
    procedure ToolBarCustomDraw(sender: IToolBar; ARect: TRect; var DefaultDraw: BOOL); safecall;
    procedure ToolBarCustomDrawButton(sender: IToolBar; Button: IToolButton; State: TCustomDrawState; var DefaultDraw: BOOL); safecall;
    procedure ListDrawItem(Control: IWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL); safecall;
    procedure MenuItemDrawItem(sender: IUnknown; ACanvas: ICanvas; ARect: TRect; State: TOwnerDrawState; var DefaultDraw: BOOL); safecall;
  end;

  IChangeEvents = interface
  ['{F671DA01-9D73-400D-9F4D-AFA58535FEFC}']
    procedure Changed(sender: IUnknown); safecall;
    procedure Changing(sender: IUnknown; var AllowChange: BOOL); safecall;
    procedure ChangingEx(sender: IUnknown; var AllowChange: BOOL; NewValue: SmallInt; Direction: TUpDownDirection); safecall;
    procedure SelectionChange(sender: IUnknown); safecall;
  end;

  ITimerEvents = interface
  ['{DA8209ED-90E7-4969-827A-2CA92686A932}']
    procedure DidTimer(sender: IUnknown); safecall;
  end;
  
  IListEvents = interface                    
  ['{F7A3548E-E7B9-4F43-8517-F1EA155EAA0E}']
    procedure ListSelect(sender: IUnknown); safecall;
    procedure DropDown(sender: IUnknown); safecall;
    procedure CloseUp(sender: IUnknown); safecall;
    procedure MeasureItem(Control: IWinControl; Index: Integer; var Height: Integer); safecall;
  end;

  IMenuEvents = interface
  ['{439ECB64-AC07-49EB-B7A7-E6F6DE8836F2}']
    procedure DidPopup(sender: IUnknown); safecall;
    procedure ContextPopup(sender: IUnknown; MousePos: TPoint; var Handled: BOOL); safecall;
    procedure MeasureItem(sender: IUnknown; ACanvas: ICanvas; var Width, Height: Integer); safecall;
  end;

  IGuiEvents = interface
  ['{F82FE796-2C24-40A9-BBF3-E749F091FD41}']
    procedure LanguageChanged(NewLangName: IString); safecall;
    procedure SkinChanged(NewSkinName: IString); safecall;
    procedure AntiBossChanged(const Activated: BOOL); safecall;
    procedure FreeNotify(sender: IComponent); safecall;
  end;

  ITreePaintEvents = interface
  ['{74305798-08D2-4247-9657-7ED85E67E944}']
    procedure AdvancedHeaderDraw(Sender: ITreeHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements); safecall;
    //after draw
    procedure AfterCellPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); safecall;
    procedure AfterItemErase(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect); safecall;
    procedure AfterItemPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect); safecall;
    procedure AfterPaint(Sender: IUnknown; TargetCanvas: ICanvas); safecall;
    //before draw
    procedure BeforeCellPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); safecall;
    procedure BeforeItemErase(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect;
                              var ItemColor: TColor; var EraseAction: TItemEraseAction); safecall;
    procedure BeforeItemPaint(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; ItemRect: TRect; var CustomDraw: BOOL); safecall;
    procedure BeforePaint(Sender: IUnknown; TargetCanvas: ICanvas); safecall;
    //header drawing
    procedure HeaderDraw(Sender: ITreeHeader; HeaderCanvas: ICanvas; Column: ITreeColumn;
                         R: TRect; Hover, Pressed: BOOL; DropMark: TVTDropMarkMode); safecall;
    procedure HeaderDrawQueryElements(Sender: ITreeHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements); safecall;
    //tree painting
    procedure PaintBackground(Sender: IUnknown; TargetCanvas: ICanvas; R: TRect; var Handled: BOOL); safecall;
    procedure PaintText(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType); safecall;
  end;

  ITreeEditingEvents = interface
  ['{94AE8409-112A-49A4-89B5-5988FD8913DB}']
    procedure DidNewText(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex; const NewText: IString); safecall;
    procedure EditCancelled(Sender: IUnknown; Column: TColumnIndex); safecall;
    procedure Edited(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex); safecall;
    procedure Editing(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex; var Allowed: BOOL); safecall;
  end;

  INodeStateEvents = interface
  ['{95843979-501F-4E0D-B10E-BBD74FFDBF48}']
    procedure NodeChecked(Sender: IUnknown; Node: PVirtualNode); safecall;
    procedure NodeChecking(Sender: IUnknown; Node: PVirtualNode; var NewState: TCheckState; var Allowed: BOOL); safecall;
    procedure NodeCollapsed(Sender: IUnknown; Node: PVirtualNode); safecall;
    procedure NodeCollapsing(Sender: IUnknown; Node: PVirtualNode; var Allowed: BOOL); safecall;
    procedure NodeExpanded(Sender: IUnknown; Node: PVirtualNode); safecall;
    procedure NodeExpanding(Sender: IUnknown; Node: PVirtualNode; var Allowed: BOOL); safecall;
  end;

  INodeChangeEvents = interface
  ['{0D2CED26-FB58-4C03-B9FD-BEC9595C53DE}']
    procedure NodeChanged(Sender: IUnknown; Node: PVirtualNode); safecall;
    procedure NodeFocusChanged(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex); safecall;
    procedure NodeFocusChanging(Sender: IUnknown; OldNode, NewNode: PVirtualNode;
                                OldColumn, NewColumn: TColumnIndex; var Allowed: BOOL); safecall;
    procedure NodeHotChange(Sender: IUnknown; OldNode, NewNode: PVirtualNode); safecall;
  end;

  INodeControlEvents = interface
  ['{2EB783D9-A3BB-434E-9F0F-FB82DFD0CD42}']
    procedure CompareNodes(Sender: IUnknown; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer); safecall;
    procedure DidInitNode(Sender: IUnknown; Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates); safecall;
    procedure DidFreeNode(Sender: IUnknown; Node: PVirtualNode); safecall;
    procedure IncrementalSearch(Sender: IUnknown; Node: PVirtualNode; const SearchText: IString; var Result: Integer; var Handled: BOOL); safecall;

    procedure NodeMeasureItem(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode; var NodeHeight: Integer); safecall;

    procedure ShortenString(Sender: IUnknown; TargetCanvas: ICanvas; Node: PVirtualNode;
                            Column: TColumnIndex; const S: IString; TextSpace: Integer;
                            var Result: IString; var Done: BOOL); safecall;
  end;

  ITreeColumnEvents = interface
  ['{615CC572-247D-4FA5-B048-2EAE63CFED84}']
    procedure ColumnClicked(Sender: IUnknown; Column: TColumnIndex; Shift: TShiftState); safecall;
    procedure ColumnDblClicked(Sender: IUnknown; Column: TColumnIndex; Shift: TShiftState); safecall;
    procedure ColumnResized(Sender: ITreeHeader; Column: TColumnIndex); safecall;
  end;

  ITreeHeaderEvents = interface
  ['{B5E66C19-3AF0-4415-8A8A-90C56A6B5941}']
    procedure HeaderClicked(Sender: ITreeHeader; Column: TColumnIndex; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer); safecall;
    procedure HeaderDblClicked(Sender: ITreeHeader; Column: TColumnIndex; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer); safecall;
    procedure HeaderDragged(Sender: ITreeHeader; Column: TColumnIndex; OldPosition: Integer); safecall;
    procedure HeaderDraggedOut(Sender: ITreeHeader; Column: TColumnIndex; DropPosition: TPoint); safecall;
    procedure HeaderDragging(Sender: ITreeHeader; Column: TColumnIndex; var Allowed: BOOL); safecall;
    procedure HeaderMouseDown(Sender: ITreeHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); safecall;
    procedure HeaderMouseMove(Sender: ITreeHeader; Shift: TShiftState; X, Y: Integer); safecall;
    procedure HeaderMouseUp(Sender: ITreeHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); safecall;
  end;

  ITreeGetEvents = interface
  ['{C69943E0-46AC-4999-83AE-2AFAAF48439A}']
    procedure GetCellIsEmpty(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex; var IsEmpty: BOOL); safecall;
    procedure GetCursor(Sender: IUnknown; var Cursor: TCursor); safecall;
    procedure GetHeaderCursor(Sender: IUnknown; var Cursor: HICON); safecall;
    procedure GetHint(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                      var LineBreakStyle: TTooltipLineBreakStyle; var HintText: IString); safecall;
    procedure GetPopupMenu(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                           const P: TPoint; var AskParent: BOOL; var PopupMenu: IPopupMenu); safecall;
    procedure GetText(Sender: IUnknown; Node: PVirtualNode; Column: TColumnIndex;
                      TextType: TVSTTextType; var Text: IString); safecall;
  end;

implementation

end.
