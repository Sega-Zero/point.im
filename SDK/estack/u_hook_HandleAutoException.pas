unit u_hook_HandleAutoException;

interface

uses Windows, SysUtils;

implementation

type
  TSafeCallObj = class (TObject)
  public
    procedure GetHandleAutoException; safecall; //����� ��� ��������� ��������� �� _HandleAutoException
  end;

  TRaiseProc = procedure (dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD; lpArguments: PDWORD); stdcall;
  THAE = function (excPtr: PExceptionRecord; errPtr: Pointer; ctxPtr: Pointer; dspPtr: Pointer): DWord; stdcall;
var cDelphiException: DWord;
    prevHanldleAutoException: THAE; //��������� �� ������������ �������
    prevHAE: array [0..15] of Byte; //����� ������ ����� ������� ���� "��� ������������"
    pHAE: Pointer;                  //��������� �� ��������� �������

    prevRaiseExceptionProc: Pointer;
    HandlingAutoException: boolean; //���� ��� RaiseExceptionProc
    CSRaiseException: TRTLCriticalSection; //����������� ������ ����� �������� ������������� ����

threadvar
    ExceptionAddress: Pointer;
    ExceptionRecord: TExceptionRecord;

{ TSafeCallObj }

procedure TSafeCallObj.GetHandleAutoException;
begin
  pHAE := nil;                                     //������� �����, ��� �������� ��������� �� _HandleAutoException
  asm                                              //������ "������" safecall �����, ����� ��� ����������� � try except � ������� _HandleAutoException
    push ebx                                       //����� ����� �����, �� ����� ��� ���� �����, � �������� ���������� ���������
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
    FillChar(ExceptionRecord, SizeOf(TExceptionRecord), 0);      //��������� ���������� � ����� � ����� �������� ���������� ExceptionRecord
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
    LeaveCriticalSection(CSRaiseException);                      //���� ������ ������� ��������
    if assigned(prevRaiseExceptionProc) then
      TRaiseProc(prevRaiseExceptionProc)(dwExceptionCode, dwExceptionFlags, nNumberOfArguments, lpArguments);
  end;
end;

{$O-} //��������� �����������, ���� ����� ������ ����� raise-� ���������� �� ��������������� ����� �������
function MyHanldleAutoException (excPtr: PExceptionRecord; errPtr: Pointer; ctxPtr: Pointer; dspPtr: Pointer): DWord; stdcall;
type
  TProc1 = function (p: Pointer): TObject;
var obj: TObject;
begin
  if excPtr.ExceptionCode = cDelphiException then
  begin
    Result := prevHanldleAutoException(excPtr, errPtr, ctxPtr, dspPtr); //��� ����� ����������, �������� ������� _HandleAutoException
  end
  else
  begin                                                                 //��� �� ����� ����������, ��������� PExceptionRecord
    obj := TProc1(ExceptObjProc)(excPtr);                               //������� ������ ����������
    ExceptionAddress := excPtr.ExceptionAddress;                        //���������� ����� ���������� ����������
    EnterCriticalSection(CSRaiseException);                             //������ � ���� ������ �...
    HandlingAutoException := True;
    raise obj;                                                          //������ ������ (����� �� �����, ��� ��������), � � �������� ����������
    HandlingAutoException := False;                                     //ExceptionRecord ����� ������ ������ ��� ������
    LeaveCriticalSection(CSRaiseException);
    Result := prevHanldleAutoException(@ExceptionRecord, errPtr, ctxPtr, dspPtr); //�� � ��������� ������, �������� ������������ _HandleAutoException                                                                                  //��� ����� ����� ���������� ExceptionRecord
  end;
end;
{$O+}


procedure RaiseForDelphiExceptionCode(dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD; lpArguments: PDWORD); stdcall;
begin
  cDelphiException := dwExceptionCode;
  RaiseException(dwExceptionCode, dwExceptionFlags, nNumberOfArguments, lpArguments);
end;

{$O-} //��������� �����������, ���� ����� ������ ����� raise-� ���������� �� ��������������� ����� �������
procedure GetDelphiExceptionConst;                        //����� ��� ��������� ��������� ���������� cDelphiException
var prevRaise: Pointer;                                   //��������� raise ������� � � ��� ����� ���������
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

function SetHook: boolean;  //���������� � ������� � _HandleAutoException. �������� ��������� ������, � ��� �������� �� ������. ����� �� ����������
const checkArr: array [0..10] of Byte = ($8b, $44, $24, $04, $f7, $40, $04, $06, $00, $00, $00);
var bytes: array [0..4] of Byte;
    tmp: DWord;
begin
  Result := false;
  if assigned(pHAE) and (cDelphiException<>0) then
  begin
    if CompareMem(pHAE, @checkArr[0], SizeOf(checkArr)) then //��������� ������ ����� �������, ��� ��� ���, ���� ��� - �� ������ ������
    begin
      Move(checkArr[0], prevHAE[0], SizeOf(CheckArr));       //�������� ������ ����� ������� � ��� ���������
      prevHAE[11] := $e9;                                    //�����
      tmp := DWord(pHAE) + 11 - DWord(@prevHAE[0]) - 16;     //� ������������ ����� _HandleAutoException
      Move(tmp, prevHAE[12], 4);
      prevHanldleAutoException := THAE(@prevHAE[0]);
      // hook!

      bytes[0] := $e9;                                           //����� �����
      tmp := DWord(@MyHanldleAutoException) - (DWord(pHAE) + 5); //� ��� ���
      Move(tmp, bytes[1], 4);
      CopyMemoryEx(pHAE, @bytes[0], Length(bytes));              //����� � ������ � ���������������� ����� VirtualProtect
      Result := true;
    end;
  end;
end;

initialization
cDelphiException := 0;

InitializeCriticalSection(CSRaiseException);

TSafeCallObj(nil).GetHandleAutoException;
GetDelphiExceptionConst;

if SetHook then //���������� � ������� � _HandleAutoException. �������� ��������� ������. ����� �� ����������
begin
  HandlingAutoException := False;
  prevRaiseExceptionProc := RaiseExceptionProc;
  RaiseExceptionProc := @MyRaise;
end;

finalization

DeleteCriticalSection(CSRaiseException);

end.
