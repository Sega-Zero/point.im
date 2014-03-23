unit u_hook_HandleAutoException;

interface

uses Windows, SysUtils;

implementation

type
  TSafeCallObj = class (TObject)
  public
    procedure GetHandleAutoException; safecall; //метод для получения указателя на _HandleAutoException
  end;

  TRaiseProc = procedure (dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD; lpArguments: PDWORD); stdcall;
  THAE = function (excPtr: PExceptionRecord; errPtr: Pointer; ctxPtr: Pointer; dspPtr: Pointer): DWord; stdcall;
var cDelphiException: DWord;
    prevHanldleAutoException: THAE; //указатель на оригинальную функцию
    prevHAE: array [0..15] of Byte; //кусок памяти чтобы функция была "как оригинальная"
    pHAE: Pointer;                  //указатель на похуканую функцию

    prevRaiseExceptionProc: Pointer;
    HandlingAutoException: boolean; //буль для RaiseExceptionProc
    CSRaiseException: TRTLCriticalSection; //критическая секция чтобы защитить вышеописанный буль

threadvar
    ExceptionAddress: Pointer;
    ExceptionRecord: TExceptionRecord;

{ TSafeCallObj }

procedure TSafeCallObj.GetHandleAutoException;
begin
  pHAE := nil;                                     //немного магии, как получить указатель на _HandleAutoException
  asm                                              //делаем "пустой" safecall метод, делфя его оборачивает в try except с вызовом _HandleAutoException
    push ebx                                       //вызов через джамп, мы знаем где этот джамп, и получаем собственно указатель
    push edx
    mov ebx, dword ptr fs:[0]
    mov ebx, [ebx + 4]
    cmp byte ptr [ebx], $e9
    jne @done
    inc ebx
    mov edx, [ebx]
    add ebx, 4
    add edx, ebx
    mov pHAE, edx
    @done:
    pop edx
    pop ebx
  end;
end;

procedure MyRaise(dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD; lpArguments: PDWORD); stdcall;
begin
  EnterCriticalSection(CSRaiseException);
  if HandlingAutoException then
  begin
    LeaveCriticalSection(CSRaiseException);
    FillChar(ExceptionRecord, SizeOf(TExceptionRecord), 0);      //сохраняем информацию о рейзе в нашей тредовой переменной ExceptionRecord
    ExceptionRecord.ExceptionCode := dwExceptionCode;
    ExceptionRecord.ExceptionFlags := dwExceptionFlags;
    ExceptionRecord.ExceptionRecord := nil;
    ExceptionRecord.ExceptionAddress := ExceptionAddress;
    ExceptionRecord.NumberParameters := nNumberOfArguments;
    if nNumberOfArguments > 0 then
      Move(lpArguments^, ExceptionRecord.ExceptionInformation[0], SizeOf(DWord)*nNumberOfArguments);
  end
  else
  begin
    LeaveCriticalSection(CSRaiseException);                      //либо рейзим обычным способом
    if assigned(prevRaiseExceptionProc) then
      TRaiseProc(prevRaiseExceptionProc)(dwExceptionCode, dwExceptionFlags, nNumberOfArguments, lpArguments);
  end;
end;

{$O-} //выключаем оптимизацию, дабы после нашего супер raise-а компилятор не заоптимизировал хвост функции
function MyHanldleAutoException (excPtr: PExceptionRecord; errPtr: Pointer; ctxPtr: Pointer; dspPtr: Pointer): DWord; stdcall;
type
  TProc1 = function (p: Pointer): TObject;
var obj: TObject;
begin
  if excPtr.ExceptionCode = cDelphiException then
  begin
    Result := prevHanldleAutoException(excPtr, errPtr, ctxPtr, dspPtr); //это делфи исключение, вызываем обычный _HandleAutoException
  end
  else
  begin                                                                 //это НЕ делфи исключение, подменяем PExceptionRecord
    obj := TProc1(ExceptObjProc)(excPtr);                               //создаем объект исключения
    ExceptionAddress := excPtr.ExceptionAddress;                        //записываем адрес настоящего исключения
    EnterCriticalSection(CSRaiseException);                             //входим в крит секцию и...
    HandlingAutoException := True;
    raise obj;                                                          //резйим объект (рейза не будет, там заглушка), а в тредовой переменной
    HandlingAutoException := False;                                     //ExceptionRecord будут лежать нужные нам данные
    LeaveCriticalSection(CSRaiseException);
    Result := prevHanldleAutoException(@ExceptionRecord, errPtr, ctxPtr, dspPtr); //ну и финальный аккорд, вызываем оригинальный _HandleAutoException                                                                                  //для нашей новой структурки ExceptionRecord
  end;
end;
{$O+}


procedure RaiseForDelphiExceptionCode(dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD; lpArguments: PDWORD); stdcall;
begin
  cDelphiException := dwExceptionCode;
  RaiseException(dwExceptionCode, dwExceptionFlags, nNumberOfArguments, lpArguments);
end;

{$O-} //выключаем оптимизацию, дабы после нашего супер raise-а компилятор не заоптимизировал хвост функции
procedure GetDelphiExceptionConst;                        //метод для получения константы исключения cDelphiException
var prevRaise: Pointer;                                   //подменяем raise функцию и в ней ловим константу
begin
  prevRaise := RaiseExceptionProc;
  RaiseExceptionProc := @RaiseForDelphiExceptionCode;
  try
    raise TObject.Create;
  except
  end;
  RaiseExceptionProc := prevRaise;
end;
{$O+}

procedure CopyMemoryEx(Destination: Pointer; Source: Pointer; Length: Cardinal);
var dwOldProtect: DWord;
begin
	VirtualProtect(Destination, Length, PAGE_EXECUTE_READWRITE, @dwOldProtect);
  Move(Source^, Destination^, Length);
	VirtualProtect(Destination, Length, dwOldProtect, @dwOldProtect);
	FlushInstructionCache(GetCurrentProcess(), Destination, Length);
end;

function SetHook: boolean;  //осторожней с бряками в _HandleAutoException. Дебаггер подменяет память, а тут проверка по памяти. Может не похукаться
const checkArr: array [0..10] of Byte = ($8b, $44, $24, $04, $f7, $40, $04, $06, $00, $00, $00);
var bytes: array [0..4] of Byte;
    tmp: DWord;
begin
  Result := false;
  if assigned(pHAE) and (cDelphiException<>0) then
  begin
    if CompareMem(pHAE, @checkArr[0], SizeOf(checkArr)) then //проверяем первые байты функции, оно или нет, если нет - то хукать нельзя
    begin
      Move(checkArr[0], prevHAE[0], SizeOf(CheckArr));       //копируем первые байты функции в наш массивчик
      prevHAE[11] := $e9;                                    //джамп
      tmp := DWord(pHAE) + 11 - DWord(@prevHAE[0]) - 16;     //в оригинальный кусок _HandleAutoException
      Move(tmp, prevHAE[12], 4);
      prevHanldleAutoException := THAE(@prevHAE[0]);
      // hook!

      bytes[0] := $e9;                                           //сходу джамп
      tmp := DWord(@MyHanldleAutoException) - (DWord(pHAE) + 5); //в наш хук
      Move(tmp, bytes[1], 4);
      CopyMemoryEx(pHAE, @bytes[0], Length(bytes));              //пишем в память с разблокированием через VirtualProtect
      Result := true;
    end;
  end;
end;

initialization
cDelphiException := 0;

InitializeCriticalSection(CSRaiseException);

TSafeCallObj(nil).GetHandleAutoException;
GetDelphiExceptionConst;

if SetHook then //осторожней с бряками в _HandleAutoException. Дебаггер подменяет память. Может не похукаться
begin
  HandlingAutoException := False;
  prevRaiseExceptionProc := RaiseExceptionProc;
  RaiseExceptionProc := @MyRaise;
end;

finalization

DeleteCriticalSection(CSRaiseException);

end.
