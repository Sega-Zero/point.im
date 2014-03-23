unit u_hook_SafeCallException;

interface

uses
  SysUtils, Windows;

implementation

uses u_estack;

type
  TJumpOfs = Integer;
  PPointer = ^Pointer;

  PXRedirCode = ^TXRedirCode;
  TXRedirCode = packed record
    Jump: Byte;
    Offset: TJumpOfs;
  end;

  PWin9xDebugThunk = ^TWin9xDebugThunk;
  TWin9xDebugThunk = packed record
    PUSH: Byte;
    Addr: Pointer;
    JMP: TXRedirCode;
  end;

  PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
  TAbsoluteIndirectJmp = packed record
    OpCode: Word;   //$FF25(Jmp, FF /4)
    Addr: PPointer;
  end;

  THookSafecallObject = class (TObject)
  public
    function NewSafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult;
  end;

var BackupSafeCallException: TXRedirCode;

function GetActualAddr(Proc: Pointer): Pointer;

  function IsWin9xDebugThunk(AAddr: Pointer): Boolean;
  begin
    Result := (AAddr <> nil) and
              (PWin9xDebugThunk(AAddr).PUSH = $68) and
              (PWin9xDebugThunk(AAddr).JMP.Jump = $E9);
  end;

begin
  if Proc <> nil then
  begin
    if (Win32Platform <> VER_PLATFORM_WIN32_NT) and IsWin9xDebugThunk(Proc) then
      Proc := PWin9xDebugThunk(Proc).Addr;
    if (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end
  else
    Result := nil;
end;

procedure HookProc(Proc, Dest: Pointer; var BackupCode: TXRedirCode);
var
  n: {$IF CompilerVersion <= 18.0}DWORD{$ELSE}NativeUInt{$IFEND};
  Code: TXRedirCode;
begin
  Proc := GetActualAddr(Proc);
  Assert(Proc <> nil);
  if ReadProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n) then
  begin
    Code.Jump := $E9;
    Code.Offset := PAnsiChar(Dest) - PAnsiChar(Proc) - SizeOf(Code);
    WriteProcessMemory(GetCurrentProcess, Proc, @Code, SizeOf(Code), n);
  end;
end;

procedure UnhookProc(Proc: Pointer; var BackupCode: TXRedirCode);
var
  n: {$IF CompilerVersion <= 18.0}DWORD{$ELSE}NativeUInt{$IFEND};
begin
  if (BackupCode.Jump <> 0) and (Proc <> nil) then
  begin
    Proc := GetActualAddr(Proc);
    Assert(Proc <> nil);
    WriteProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n);
    BackupCode.Jump := 0;
  end;
end;

{ THookSafecallObject }

function THookSafecallObject.NewSafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  Result := u_estack.SafeCallExceptionProc(ExceptObject, ExceptAddr);
end;

initialization
  HookProc(@TObject.SafeCallException, @THookSafecallObject.NewSafeCallException, BackupSafeCallException);

finalization
  UnhookProc(@TObject.SafeCallException, BackupSafeCallException);

end.
