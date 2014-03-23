// для добавления новых исключений их нужно добавить в RaiseExceptionByName
// если с исключением нужно передавать дополнительные данные
// то надо задать свою функцию в u_estack.ExceptionToQIPException
// в которой в конструкторе TQIPException передавать все что нужно в AData
// а придут они во входных параметрах RaiseExceptionByName AData и ADataSize
// p.s. В ядре ExceptionToQIPException уже задано. См. u_estack_code.ToQIPException

// если Classes подключен явно в плагине, то EXCLUDE_CLASSES следует закомментировать
// ибо иначе u_exception.EStreamError <> Classes.EStreamError (и прочее), что может подосрать в обработке
{$DEFINE EXCLUDE_CLASSES}

unit u_exceptions;

interface

uses Windows, SysUtils{$IFNDEF EXCLUDE_CLASSES}, Classes{$ENDIF};

type
  {$IFDEF EXCLUDE_CLASSES}
  EStreamError = class(Exception);
  EFileStreamError = class(EStreamError);
  EFCreateError = class(EFileStreamError);
  EFOpenError = class(EFileStreamError);
  EFilerError = class(EStreamError);
  EReadError = class(EFilerError);
  EWriteError = class(EFilerError);
  EClassNotFound = class(EFilerError);
  EMethodNotFound = class(EFilerError);
  EInvalidImage = class(EFilerError);
  EResNotFound = class(Exception);
  EListError = class(Exception);
  EBitsError = class(Exception);
  EStringListError = class(Exception);
  EComponentError = class(Exception);
  EParserError = class(Exception);
  EOutOfResources = class(EOutOfMemory);
  EInvalidOperation = class(Exception);
  EThread = class(Exception);
  {$ENDIF}

  EQIPException = class (Exception)
  private
    FOriginalClass: WideString;
    FCode: DWORD;
    FAddress: Pointer;
    FStackTrace: WideString;
  public
    property OriginalClass: WideString read FOriginalClass;
    property Code: DWORD read FCode;
    property Address: Pointer read FAddress;
    property StackTrace: WideString read FStackTrace;
    constructor Create(AClassName: WideString; AMsg: WideString; AHelpContext: Integer; ACode: DWORD; AAddr: Pointer; AStackTrace: WideString);
  end;

procedure RaiseExceptionByName(AClassName: WideString; AMsg: WideString; AHelpContext: Integer; ACode: DWORD; AAddr: Pointer; AStackTrace: WideString; AData: Pointer; ADataSize: Integer);

implementation

procedure RaiseExceptionByName(AClassName: WideString; AMsg: WideString; AHelpContext: Integer; ACode: DWORD; AAddr: Pointer; AStackTrace: WideString; AData: Pointer; ADataSize: Integer);
begin
  {from SysUtils}
  if AClassName = 'EAbort' then raise EAbort.Create(AMsg);
  if AClassName = 'EHeapException' then raise EHeapException.Create(AMsg);
  if AClassName = 'EOutOfMemory' then OutOfMemoryError;
  if AClassName = 'EInOutError' then raise EInOutError.Create(AMsg);
  if AClassName = 'EExternal' then raise EExternal.Create(AMsg);
  if AClassName = 'EExternalException' then raise EExternalException.Create(AMsg);
  if AClassName = 'EIntError' then raise EIntError.Create(AMsg);
  if AClassName = 'EDivByZero' then raise EDivByZero.Create(AMsg);
  if AClassName = 'ERangeError' then raise ERangeError.Create(AMsg);
  if AClassName = 'EIntOverflow' then raise EIntOverflow.Create(AMsg);
  if AClassName = 'EMathError' then raise EMathError.Create(AMsg);
  if AClassName = 'EInvalidOp' then raise EInvalidOp.Create(AMsg);
  if AClassName = 'EZeroDivide' then raise EZeroDivide.Create(AMsg);
  if AClassName = 'EOverflow' then raise EOverflow.Create(AMsg);
  if AClassName = 'EUnderflow' then raise EUnderflow.Create(AMsg);
  if AClassName = 'EInvalidPointer' then raise EInvalidPointer.Create(AMsg);
  if AClassName = 'EInvalidCast' then raise EInvalidCast.Create(AMsg);
  if AClassName = 'EConvertError' then raise EConvertError.Create(AMsg);
  if AClassName = 'EAccessViolation' then raise EAccessViolation.Create(AMsg);
  if AClassName = 'EPrivilege' then raise EPrivilege.Create(AMsg);
  {$IFDEF MSWINDOWS}
  {$WARNINGS OFF}
  if AClassName = 'EStackOverflow' then raise EStackOverflow.Create(AMsg);
  if AClassName = 'EAbstractError' then raise EAbstractError.Create(AMsg);
  {$WARNINGS ON}
  {$ENDIF}
  if AClassName = 'EControlC' then raise EControlC.Create(AMsg);
  if AClassName = 'EVariantError' then raise EVariantError.Create(AMsg);
  if AClassName = 'EPropReadOnly' then raise EPropReadOnly.Create(AMsg);
  if AClassName = 'EPropWriteOnly' then raise EPropWriteOnly.Create(AMsg);
  if AClassName = 'EAssertionFailed' then raise EAssertionFailed.Create(AMsg);
  if AClassName = 'EIntfCastError' then raise EIntfCastError.Create(AMsg);
  if AClassName = 'EInvalidContainer' then raise EInvalidContainer.Create(AMsg);
  if AClassName = 'EInvalidInsert' then raise EInvalidInsert.Create(AMsg);
  if AClassName = 'EPackageError' then raise EPackageError.Create(AMsg);
  if AClassName = 'EOSError' then RaiseLastOSError;
  if AClassName = 'EWin32Error' then RaiseLastOSError;
  if AClassName = 'ESafecallException' then raise ESafecallException.Create(AMsg);

  {from Classes}
  if AClassName = 'EStreamError' then raise EStreamError.Create(AMsg);
  if AClassName = 'EFileStreamError' then raise EFileStreamError.Create(AMsg);
  if AClassName = 'EFCreateError' then raise EFCreateError.Create(AMsg);
  if AClassName = 'EFOpenError' then raise EFOpenError.Create(AMsg);
  if AClassName = 'EFilerError' then raise EFilerError.Create(AMsg);
  if AClassName = 'EReadError' then raise EReadError.Create(AMsg);
  if AClassName = 'EWriteError' then raise EWriteError.Create(AMsg);
  if AClassName = 'EClassNotFound' then raise EClassNotFound.Create(AMsg);
  if AClassName = 'EMethodNotFound' then raise EMethodNotFound.Create(AMsg);
  if AClassName = 'EInvalidImage' then raise EInvalidImage.Create(AMsg);
  if AClassName = 'EResNotFound' then raise EResNotFound.Create(AMsg);
  if AClassName = 'EListError' then raise EListError.Create(AMsg);
  if AClassName = 'EBitsError' then raise EBitsError.Create(AMsg);
  if AClassName = 'EStringListError' then raise EStringListError.Create(AMsg);
  if AClassName = 'EComponentError' then raise EComponentError.Create(AMsg);
  if AClassName = 'EParserError' then raise EParserError.Create(AMsg);
  if AClassName = 'EOutOfResources' then raise EOutOfResources.Create(AMsg);
  if AClassName = 'EInvalidOperation' then raise EInvalidOperation.Create(AMsg);
  if AClassName = 'EThread' then raise EThread.Create(AMsg);

  raise EQIPException.Create(AClassName, AMsg, AHelpContext, ACode, AAddr, AStackTrace);
end;

{ EQIPException }

constructor EQIPException.Create(AClassName, AMsg: WideString; AHelpContext: Integer;
  ACode: DWORD; AAddr: Pointer; AStackTrace: WideString);
begin
  FOriginalClass := AClassName;
  Message := AMsg;
  HelpContext := AHelpContext;
  FCode := ACode;
  FAddress := AAddr;
  FStackTrace := AStackTrace;
end;

initialization

finalization

end.
