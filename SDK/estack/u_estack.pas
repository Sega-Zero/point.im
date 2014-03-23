// для использования - модуль следует подключать последним в списке

// добавлен модуль u_hook_HandleAutoException, решающий проблему с аппаратными исключениями
// добавлен модуль u_hook_SafeCallException, добавляющий реализацию в TObject.SafeCallException
//    что позволяет всем наследникам TObject иметь обработку SafeCall исключений

// чтобы safecall исключения нормально пробрасывались в ядро
// нужно наследоваться от TQIPInterfacedObject или перекрывать
// TObject.SafeCallException в котором вызывать u_estack.SafeCallExceptionProc
// либо использовать модуль u_hook_SafeCallException (по умолчанию вкл)

// возможны проблемы при передаче аппаратных исключений в ядро
// это баг, как бороться см. тут: http://qc.embarcadero.com/wc/qcmain.aspx?d=81725
// либо использовать модуль u_hook_HandleAutoException (по умолчанию вкл)


unit u_estack;

interface

uses Windows, SysUtils{$IFNDEF DISABLE_HOOKS}, u_hook_HandleAutoException, u_hook_SafeCallException{$ENDIF};

const
  ESTACK_MAPNAME = 'QIP_IEStack';
  ESTACK_SECTION_STR = 'QIP SafeCall stacktrace:';
  ESTACK_SECTION = #13#10 + ESTACK_SECTION_STR + #13#10;
  E_QIPEXCEPTION = HResult($80044444);

type
  EFileMapping = class (Exception);
  EFileMappingCreate = class (EFileMapping);
  FFileMappingMapViewOfFile = class (EFileMapping);

  IInheritedInfo = interface
  ['{024727A4-0A7E-4AB9-8D27-0848E0BEAAAB}']
    function GetClassName: PWideChar; stdcall;
    function InheritedFrom: IInheritedInfo; stdcall;
  end;

  IQIPException = interface
  ['{62B7789A-DA2C-4302-BBBC-6323AD2D76CA}']
    function ExceptionClass: PWideChar; stdcall;
    function Message: PWideChar; stdcall;
    function HelpContext: Integer; stdcall;
    function Code: DWORD; stdcall;
    function Address: Pointer; stdcall;
    function StackTrace: PWideChar; stdcall;
    function Data: Pointer; stdcall;
    function DataSize: Integer; stdcall;
    function InheritedInfo: IInheritedInfo; stdcall;
    function InheritedFrom(AClassName: WideString): BOOL; stdcall;
  end;

  IEStack = interface
  ['{933B251A-3EF9-413E-B1D0-B1EF8D42B038}']
    procedure Push(e: IQIPException); stdcall;
    function Pop: IQIPException; stdcall;
  end;

  TQIPInterfacedObject = class (TInterfacedObject)
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; override;
  end;

  TInheritedInfo = class (TInterfacedObject, IInheritedInfo)
  private
    FClassName: WideString;
    FIheritedFrom: IInheritedInfo;
  public
    function GetClassName: PWideChar; stdcall;
    function InheritedFrom: IInheritedInfo; stdcall;
    constructor Create(AClass: TClass);
  end;

  TQIPException = class (TInterfacedObject, IQIPException)
  private
    FExceptionClass: WideString;
    FMessage: WideString;
    FHelpContext: Integer;
    FCode: DWORD;
    FAddress: Pointer;
    FStackTrace: WideString;
    FData: Pointer;
    FDataSize: Integer;
    FIheritedInfo: IInheritedInfo;
  public
    function ExceptionClass: PWideChar; stdcall;
    function Message: PWideChar; stdcall;
    function HelpContext: Integer; stdcall;
    function Code: DWORD; stdcall;
    function Address: Pointer; stdcall;
    function StackTrace: PWideChar; stdcall;
    function InheritedInfo: IInheritedInfo; stdcall;
    function InheritedFrom(AClassName: WideString): BOOL; stdcall;
    function Data: Pointer; stdcall;
    function DataSize: Integer; stdcall;

    constructor Create(EObject: TObject; EAddr: Pointer); overload;
    constructor Create(AClassName: WideString;
                       AMsg: WideString;
                       AHelpContext: Integer;
                       ACode: DWORD;
                       AAddr: Pointer;
                       AStackTrace: WideString;
                       AData: Pointer;
                       ADataSize: Integer); overload;
  end;

  TFileMapMode = set of (fmmCreate, fmmReadOnly, fmmReadWrite, fmmWriteCopy);
  TFileMapping = class (TObject)
  private
    FName: string;
    FHandle: THandle;
    FSize: Int64;
    FAccess: Cardinal;
    FSystemInfo: TSystemInfo;

    FSeek: Int64;
  public
    property Seek: Int64 read FSeek write FSeek;
    property Size: Int64 read FSize;

    procedure Read (var ABuffer; ASize: Cardinal);
    procedure Write(var ABuffer; ASize: Cardinal);

    constructor Create(AName: string; AMode: TFileMapMode; ASize: Int64);
    destructor Destroy; override;
  end;

  TExceptionToQIPException = function (EObject: TObject; EAddr: Pointer): TQIPException;

procedure QIPSafeCallErrorProc(ErrorCode: HResult; ErrorAddr: Pointer);  
function SafeCallExceptionProc(ExceptObject: TObject; ExceptAddr: Pointer): HResult;
function GetEStack: IEStack;

var ExceptionToQIPException: TExceptionToQIPException;
    {$IFDEF madExcept}madStackLimit: Integer;{$ENDIF}

implementation

uses StrUtils, u_exceptions{$IFDEF madExcept}, madExcept, Classes{$ENDIF};

var prevSafeCallErrorProc: TSafeCallErrorProc;
    eStack: IEStack;

function GetEStack: IEStack;
var fm: TFileMapping;
begin
  if not assigned(eStack) then
  begin
    fm := TFileMapping.Create(ESTACK_MAPNAME, [fmmReadOnly], SizeOf(Pointer));
    try
      fm.Read(eStack, SizeOf(Pointer));
      if assigned(eStack) then
        eStack._AddRef;
    finally
      fm.Free;
    end;
  end;
  Result := eStack;
end;

function SafeCallExceptionProc(ExceptObject: TObject; ExceptAddr: Pointer): HResult;
const SIDE_NAME = {$IFDEF INFIUM}'>> core side'{$ELSE}'>> module side'{$ENDIF};
var stack: IEStack;
{$IFDEF madExcept}
    e: Exception;
    s: string;
    i, n: Integer;
{$ENDIF}
begin
  stack := GetEStack;
  if assigned(stack) then
  begin
    Result := E_QIPEXCEPTION;

    //добавляем информацию о стеке в текст сообщения
    {$IFDEF madExcept}
    if ExceptObject is Exception then
    begin
      e := Exception(ExceptObject);
      if Pos(ESTACK_SECTION, e.Message) = 0 then e.Message := e.Message + ESTACK_SECTION;
      if Pos(SIDE_NAME, e.Message) = 0 then
      begin
        e.Message := e.Message + SIDE_NAME + sLineBreak;
        s := GetCrashStackTrace;

        n := Pos('SafeCallExceptionProc', s);
        if n > 0 then
        begin
          Inc(n, Length('SafeCallExceptionProc'));
          n := PosEx(sLineBreak, s, n);
          if n > 0 then
            Delete(s, 1, n - 1 + Length(sLineBreak));
        end;

        n := Pos('@CheckAutoResult', s);
        if n > 0 then
        begin
          Inc(n, Length('@CheckAutoResult'));
          n := PosEx(sLineBreak, s, n);
          if n > 0 then
            Delete(s, 1, n - 1 + Length(sLineBreak));
        end;

        n := 0;
        for i := 0 to madStackLimit - 1 do
          begin
            n := PosEx(sLineBreak, s, n + Length(sLineBreak));
            if n = 0 then Break;
          end;
        if n > 0 then s := Copy(s, 1, n - 1);

        e.Message := e.Message + s + sLineBreak;
      end;  
    end;
    {$ENDIF}

    if assigned(ExceptionToQIPException) then
      stack.Push(ExceptionToQIPException(ExceptObject, ExceptAddr))
    else
      stack.Push(TQIPException.Create(ExceptObject, ExceptAddr));
  end
  else
    Result := E_UNEXPECTED;
end;

procedure QIPSafeCallErrorProc(ErrorCode: HResult; ErrorAddr: Pointer);
var stack: IEStack;
    e: IQIPException;
begin
  stack := GetEStack;
  if (ErrorCode = E_QIPEXCEPTION) and assigned(stack) then
  begin
    e := stack.Pop;
    RaiseExceptionByName(e.ExceptionClass, e.Message, e.HelpContext, e.Code, e.Address, e.StackTrace, e.Data, e.DataSize);
  end
  else
    if assigned(prevSafeCallErrorProc) then
      prevSafeCallErrorProc(ErrorCode, ErrorAddr);
end;

{ TFileMapping }

constructor TFileMapping.Create(AName: string; AMode: TFileMapMode; ASize: Int64);
var flags: Cardinal;
begin
  inherited Create;
  FSize := ASize;
  FName := AName;

  if fmmReadOnly in AMode then FAccess := FAccess or FILE_MAP_READ;
  if fmmReadWrite in AMode then FAccess := FAccess or FILE_MAP_READ or FILE_MAP_WRITE;
  if fmmWriteCopy in AMode then FAccess := FAccess or FILE_MAP_COPY;

  if fmmCreate in AMode then
  begin
    flags := 0;
    if fmmReadOnly in AMode then flags := flags or PAGE_READONLY;
    if fmmReadWrite in AMode then flags := flags or PAGE_READWRITE;
    if fmmWriteCopy in AMode then flags := flags or PAGE_WRITECOPY;
    FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, flags, Cardinal(ASize shl 32), Cardinal(ASize), PChar(AName))
  end
  else
  begin
    FHandle := OpenFileMapping(FAccess, True, PChar(AName));
  end;
  if FHandle = 0 then
    raise EFileMappingCreate.Create('Can''t create/open filemapping, errCode #' + IntToStr(GetLastError));

  GetSystemInfo(FSystemInfo);
end;

destructor TFileMapping.Destroy;
begin
  if (FHandle <> 0) then
  begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;
  inherited;
end;

procedure TFileMapping.Read(var ABuffer; ASize: Cardinal);
var pb, pb2: PByte;
    offset: Cardinal;
    pageSeek: Int64;
begin
  pageSeek := FSeek div FSystemInfo.dwPageSize * FSystemInfo.dwPageSize;
  offset := FSeek mod FSystemInfo.dwPageSize;

  pb := MapViewOfFile(FHandle, FAccess, Cardinal(pageSeek shl 32), Cardinal(pageSeek), ASize + offset);
  if pb = nil then
    raise FFileMappingMapViewOfFile.Create('Can''t MapViewOfFile, errCode #' + IntToStr(GetLastError));
  pb2 := pb;
  Inc(pb2, offset);
  Move(pb2^, ABuffer, ASize);
  UnmapViewOfFile(pb);
  Inc(FSeek, ASize);
end;

procedure TFileMapping.Write(var ABuffer; ASize: Cardinal);
var pb, pb2: PByte;
    offset: Cardinal;
    pageSeek: Int64;
begin
  pageSeek := FSeek div FSystemInfo.dwPageSize * FSystemInfo.dwPageSize;
  offset := FSeek mod FSystemInfo.dwPageSize;

  pb := MapViewOfFile(FHandle, FAccess, Cardinal(pageSeek shl 32), Cardinal(pageSeek), ASize + offset);
  if pb = nil then
    raise FFileMappingMapViewOfFile.Create('Can''t MapViewOfFile, errCode #' + IntToStr(GetLastError));
  pb2 := pb;
  Inc(pb2, offset);
  Move(ABuffer, pb2^, ASize);
  UnmapViewOfFile(pb);
  Inc(FSeek, ASize);
end;

{ TQIPInterfacedObject }

function TQIPInterfacedObject.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  Result := SafeCallExceptionProc(ExceptObject, ExceptAddr);
end;

{ TQIPException }

function TQIPException.Address: Pointer;
begin
  Result := FAddress;
end;

function TQIPException.Code: DWORD;
begin
  Result := FCode;
end;

constructor TQIPException.Create(AClassName, AMsg: WideString;
  AHelpContext: Integer; ACode: DWORD; AAddr: Pointer;
  AStackTrace: WideString; AData: Pointer; ADataSize: Integer);
begin
  FExceptionClass := AClassName;
  FMessage := AMsg;
  FHelpContext := AHelpContext;
  FCode := ACode;
  FAddress := AAddr;
  FStackTrace := AStackTrace;
  FData := AData;
  FDataSize := ADataSize;
end;

constructor TQIPException.Create(EObject: TObject; EAddr: Pointer);
begin
  FExceptionClass := EObject.ClassName;
  FAddress := EAddr;
  if EObject is Exception then
  begin
    FMessage := (EObject as Exception).Message;
    FHelpContext := (EObject as Exception).HelpContext;
  end;
{$IFDEF MSWINDOWS}
{$WARNINGS OFF}
  if EObject is EExternal then
    if assigned((EObject as EExternal).ExceptionRecord) then
      FCode := (EObject as EExternal).ExceptionRecord.ExceptionCode;
{$WARNINGS ON}
{$ENDIF}
  if EObject.ClassParent <> nil then
    FIheritedInfo := TInheritedInfo.Create(EObject.ClassParent);
end;

function TQIPException.Data: Pointer;
begin
  Result := FData;
end;

function TQIPException.DataSize: Integer;
begin
  Result := FDataSize;
end;

function TQIPException.ExceptionClass: PWideChar;
begin
  Result := PWideChar(FExceptionClass);
end;

function TQIPException.HelpContext: Integer;
begin
  Result := FHelpContext;
end;

function TQIPException.InheritedFrom(AClassName: WideString): BOOL;
var info: IInheritedInfo;
begin
  Result := false;
  if FExceptionClass = AClassName then
  begin
    Result := true;
    Exit;
  end;

  info := FIheritedInfo;
  while assigned(info) do
  begin
    if info.GetClassName = AClassName then
    begin
      Result := true;
      Exit;
    end;
    info := info.InheritedFrom;
  end;
end;

function TQIPException.InheritedInfo: IInheritedInfo;
begin

end;

function TQIPException.Message: PWideChar;
begin
  Result := PWideChar(FMessage);
end;

function TQIPException.StackTrace: PWideChar;
begin
  Result := PWideChar(FStackTrace);
end;

{ TInheritedInfo }

constructor TInheritedInfo.Create(AClass: TClass);
begin
  FClassName := AClass.ClassName;
  if AClass.ClassParent <> nil then
    FIheritedFrom := TInheritedInfo.Create(AClass.ClassParent);
end;

function TInheritedInfo.GetClassName: PWideChar;
begin
  Result := PWideChar(FClassName);
end;

function TInheritedInfo.InheritedFrom: IInheritedInfo;
begin
  Result := FIheritedFrom;
end;

initialization

{$IFDEF madExcept}madStackLimit := 10;{$ENDIF}

ExceptionToQIPException := nil;
eStack := nil;
prevSafeCallErrorProc := SafeCallErrorProc;
SafeCallErrorProc := @QIPSafeCallErrorProc;

finalization

eStack := nil;
SafeCallErrorProc := prevSafeCallErrorProc;

end.
