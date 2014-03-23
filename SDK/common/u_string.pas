unit u_string;

interface

uses Windows, Types;

type
  IString = interface
    ['{BED5A9B7-C15A-450E-8F4D-394C593DFB3C}']
    function wString: WideString; stdcall;
    function pString: PWideChar;  stdcall;
    
    procedure SetString(const str: WideString); stdcall; overload;
    procedure SetString(const str: PWideChar);  stdcall; overload;
    procedure SetString(const str: PWideChar; StrLength: Integer);  stdcall; overload;
    procedure SetString(const LangID: Integer);  stdcall; overload;

    procedure Append(str: IString); stdcall; overload;
    procedure Append(str: WideString); stdcall; overload;
    procedure Append(str: PWideChar); stdcall; overload;

    procedure Insert(const Position: Integer; str: IString); stdcall; overload;
    procedure Insert(const Position: Integer; str: WideString); stdcall; overload;
    procedure Insert(const Position: Integer; str: PWideChar); stdcall; overload;

    function Length: Integer;     stdcall;
    function ToDateTime: TDateTime; stdcall;

    function  CreateNew: IString; safecall;
  end;

  IStringList = interface
    ['{60D1FCE2-66FC-45A1-A8A9-891798DF1C67}']
    function  Text: IString; stdcall;
    procedure SetText(AText: IString); stdcall;

    function  CopyItem(const Index: Integer): IString; stdcall; overload;
    procedure CopyItem(const Index: Integer; var Value: IString); stdcall; overload;

    procedure SetItemString(const Index: Integer; const str: WideString); stdcall; overload;
    procedure SetItemString(const Index: Integer; const str: PWideChar);  stdcall; overload;

    function  IndexOf(str: IString):    Integer; stdcall; overload;
    function  IndexOf(str: WideString): Integer; stdcall; overload;
    function  IndexOf(str: PWideChar):  Integer; stdcall; overload;

    function  Add(str: IString): Integer;    stdcall; overload;
    function  Add(str: PWideChar): Integer;  stdcall; overload;
    function  Add(str: WideString): Integer; stdcall; overload;
    procedure Insert(const Pos: Integer; str: IString);    stdcall; overload;
    procedure Insert(const Pos: Integer; str: PWideChar);  stdcall; overload;
    procedure Insert(const Pos: Integer; str: WideString); stdcall; overload;
    procedure Delete(const Index: Integer); stdcall;

    function Count: Integer; stdcall;

    function  IndexOfName(str: IString):    Integer; stdcall; overload;
    function  IndexOfName(str: WideString): Integer; stdcall; overload;
    function  IndexOfName(str: PWideChar):  Integer; stdcall; overload;

    procedure Clear(); stdcall;
    procedure BeginUpdate(); stdcall;
    procedure EndUpdate(); stdcall;

    function  CreateNew: IStringList; safecall;
  end;

  IStringsGen = interface
    ['{14C6A0F8-4840-4D6C-938B-F317E3132E19}']
    function CreateIString(): IString; safecall;
    function CreateIStringList(): IStringList; safecall;
  end;
  pIStringsGen = ^IStringsGen;

function GetIString(const Text: WideString = ''): IString; overload;
function GetIString(const LangID: Integer): IString; overload;
function GetIStringList(const Text: WideString = ''): IStringList;
function CreateIString(const Text: WideString = ''): IString;
function CreateIStringList(const Text: WideString = ''): IStringList;

procedure InitializeIStrings(StrGen: pIStringsGen);
procedure FinalizeIStrings();
  
implementation

var
  RefCounter: Integer      = 0;
  Generator : pIStringsGen = nil;

function CreateIString(const Text: WideString = ''): IString;
begin
  Result := GetIString(Text);
end;

function CreateIStringList(const Text: WideString = ''): IStringList;
begin
  Result := GetIStringList(Text);
end;

function GetIString(const Text: WideString = ''): IString;
begin
  Result := Generator.CreateIString;
  Result.SetString(Text);
end;

function GetIString(const LangID: Integer): IString; overload;
begin
  Result := Generator.CreateIString;
  Result.SetString(LangID);
end;

function GetIStringList(const Text: WideString = ''): IStringList;
begin
  Result := Generator.CreateIStringList;
  Result.SetText(GetIString(Text));
end;

procedure InitializeIStrings(StrGen: pIStringsGen);
begin
  InterlockedIncrement(RefCounter);
  if RefCounter = 1 then
    Generator := StrGen;
end;

procedure FinalizeIStrings();
begin
  InterlockedDecrement(RefCounter);
  if RefCounter = 0 then
    Generator := nil;
end;

initialization
finalization
  FinalizeIStrings();

end.
