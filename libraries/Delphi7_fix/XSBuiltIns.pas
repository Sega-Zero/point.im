{*******************************************************}
{                                                       }
{ Borland Delphi Visual Component Library               }
{                SOAP Support                           }
{                                                       }
{ Copyright (c) 2001 Borland Software Corporation       }
{                                                       }
{*******************************************************}

unit XSBuiltIns;

{$IFNDEF VER150}
{$INCLUDE 'CompVer.inc'}
{$ENDIF}

interface

uses SysUtils, InvokeRegistry, Classes, FMTBcd, Types, XmlIntf;

const
  SHexMarker               = '$';      { do not localize }
  SoapTimePrefix           = 'T';      { do not localize }
  XMLDateSeparator         = '-';      { do not localize }
  XMLHourOffsetMinusMarker = '-';      { do not localize }
  XMLHourOffsetPlusMarker  = '+';      { do not localize }
  XMLTimeSeparator         = ':';      { do not localize }
  XMLMonthPos              = 6;
  XMLDayPos                = 9;
  XMLYearPos               = 1;
  XMLMilSecPos             = 10;
  XMLDefaultYearDigits     = 4;
  XMLDurationStart         = 'P';      { do not localize }
  XMLDurationYear          = 'Y';      { do not localize }
  XMLDurationMonth         = 'M';      { do not localize }
  XMLDurationDay           = 'D';      { do not localize }
  XMLDurationHour          = 'H';      { do not localize }
  XMLDurationMinute        = 'M';      { do not localize }
  XMLDurationSecond        = 'S';      { do not localize }
  SNAN                     = 'NAN';    { do not localize }
  SSciNotationMarker: Char = 'E';      { do not localize }
  SDecimal: Char           = '.';      { do not localize }
  SNegative: Char          = '-';      { do not localize }
  SPlus: Char              = '+';      { do not localize }
  SLocalTimeMarker         = 'Z';      { do not localize }
  MaxMonth                 = 12;
  MinMonth                 = 1;
  MaxDay                   = 31;
  MinDay                   = 1;
  SoapDecimalSeparator     = '.';

  IncrementAmount: array[Boolean] of Integer = (1, -1);

type

{ forward declarations }

TXSDuration = class;
TXSTime = class;
TXSDate = class;
TXSDateTime = class;

{ TXSTime }

TXSTime = class(TRemotableXS)
  private
    FTimeValue: WideString;
    FUseZeroMilliseconds: Boolean;
  protected
    function GetAsTime: TDateTime;
    function GetFractionalSeconds: Double;
    function GetFractionalSecondString: string;
    function GetHourOffset: SmallInt;
    function GetHour: Word;
    function GetMillisecond: Word;
    function GetMinute: Word;
    function GetMinuteOffset: SmallInt;
    function GetSecond: Word;
    procedure SetAsTime(const Value: TDateTime);
    procedure SetFractionalSeconds(const Value: Double);
    procedure SetHour(const Value: Word);
    procedure SetHourOffset(const Value: SmallInt);
    procedure SetMillisecond(const Value: Word);
    procedure SetMinute(const Value: Word);
    procedure SetMinuteOffset(const Value: SmallInt);
    procedure SetSecond(const Value: Word);
    property FractionalSecondString: string read GetFractionalSecondString;
  public
    property AsTime: TDateTime read GetAsTime write SetAsTime;
    property FractionalSeconds: Double read GetFractionalSeconds write
             SetFractionalSeconds;
    property Hour: Word read GetHour write SetHour default 0;
    property HourOffset: SmallInt read GetHourOffset write SetHourOffset default 0;
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
    property Minute: Word read GetMinute write SetMinute default 0;
    property MinuteOffset: SmallInt read GetMinuteOffset write SetMinuteOffset;
    property Second: Word read GetSecond write SetSecond default 0;
    property UseZeroMilliseconds: Boolean read FUseZeroMilliseconds write
             FUseZeroMilliseconds;
    function Clone: TXSTime;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function NativeToXS: WideString; override;
end;

{ TXSDate }

TXSDate = class(TRemotableXS)
  private
    FDateValue: WideString;
  protected
    function GetAsDate: TDateTime;
    function GetDay: Word;
    function GetMonth: Word;
    function GetYear: Integer;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetMonth(const Value: Word);
    procedure SetDay(const Value: Word);
    procedure SetYear(const Value: Integer);
  public
    constructor Create; override;
    property Month: Word read GetMonth write SetMonth default 0;
    property Day: Word read GetDay write SetDay default 0;
    property Year: Integer read GetYear write SetYear default 0;
    function Clone: TXSDate;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function NativeToXS: WideString; override;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
end;

{ TXSCustomDateTime }

TXSCustomDateTime = class(TRemotableXS)
  protected
    FDateTime: WideString;
    function GetAsDateTime: TDateTime;
    function GetAsUTCDateTime: TDateTime;
    function GetDay: Word;
    function GetFractionalSeconds: Double;
    function GetHour: Word;
    function GetHourOffset: SmallInt;
    function GetMonth: Word;
    function GetMillisecond: Word;
    function GetMinute: Word;
    function GetMinuteOffset: SmallInt;
    function GetSecond: Word;
    function GetUseZeroMilliseconds: Boolean;
    function GetYear: Integer;
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsUTCDateTime(const Value: TDateTime);
    procedure SetFractionalSeconds(const Value: Double);
    procedure SetDay(const Value: Word); virtual;
    procedure SetHour(const Value: Word); virtual;
    procedure SetHourOffset(const Value: SmallInt); virtual;
    procedure SetMillisecond(const Value: Word); virtual;
    procedure SetMinute(const Value: Word); virtual;
    procedure SetMinuteOffset(const Value: SmallInt); virtual;
    procedure SetMonth(const Value: Word); virtual;
    procedure SetSecond(const Value: Word); virtual;
    procedure SetUseZeroMilliseconds(const Value: Boolean);
    procedure SetYear(const Value: Integer); virtual;
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
  public
    constructor Create;  override;
    destructor Destroy; override;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsUTCDateTime: TDateTime read GetAsUTCDateTime write SetAsUTCDateTime;
    property FractionalSeconds: Double read GetFractionalSeconds write
             SetFractionalSeconds;
    property Hour: Word read GetHour write SetHour default 0;
    property HourOffset: SmallInt read GetHourOffset write SetHourOffset default 0;
    property Minute: Word read GetMinute write SetMinute default 0;
    property MinuteOffset: SmallInt read GetMinuteOffset write SetMinuteOffset default 0;
    property Second: Word read GetSecond write SetSecond default 0;
    property Month: Word read GetMonth write SetMonth default 0;
    property Day: Word read GetDay write SetDay default 0;
    property Year: Integer read GetYear write SetYear default 0;
    property UseZeroMilliseconds: Boolean read GetUseZeroMilliseconds write
             SetUseZeroMilliseconds;
end;

{ TXSDateTime }

TXSDateTime = class(TXSCustomDateTime)
  public
    function Clone: TXSDateTime;
    function CompareDateTimeParam(const Value1, Value2: TXSDateTime): TXSDuration;
    function NativeToXS: WideString; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
end;

{ TXSDuration }

{ Backward compatible definition that was incorrectly based on DateTime:(
  In a future release TXSDuration should be lightened }
TXSDuration = class(TXSCustomDateTime)
  protected
    function GetDecimalSecond: Double;
    procedure SetDecimalSecond(const Value: Double);
  public
    constructor Create; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function NativeToXS: WideString; override;
    property DecimalSecond: Double read GetDecimalSecond write SetDecimalSecond;
end;

{ NOTE: These classes should derive from ERemotableException so we can
        send better SOAP faults across the wire?? }
EXSDateTimeException  = class(Exception);
EXSDecimalException   = class(Exception);
EXSHexBinaryException = class(Exception);

{ TXSHexBinary }
TXSHexBinary = class(TRemotableXS)
  private
    FHexBinaryString: string;
    procedure  SetAsByteArray(const Value: TByteDynArray);
    function   GetAsByteArray: TByteDynArray;
  public
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function  NativeToXS: WideString; override;
    property  HexBinaryString: string read FHexBinaryString write FHexBinaryString;
    property  AsByteArray: TByteDynArray read GetAsByteArray write SetAsByteArray;
end;

{ TXSDecimal }
{ Rudimentary support (strictly to handle xsd:decimal) for now }
TXSDecimal = class(TRemotableXS)
  private
    FDecimalString: string;
    function GetAsBcd: TBcd;
    procedure SetAsBcd(const Value: TBcd);
  public
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function  NativeToXS: WideString; override;
    property  DecimalString: string read FDecimalString write FDecimalString;
    property  AsBcd: TBcd read GetAsBcd write SetAsBcd;
end;

{ TXSString - for xsd:string and any other XML Data Types where nillable support
              is required }
TXSString = class(TRemotableXS)
  private
    FString: WideString;
  public
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    function  NativeToXS: WideString; override;
  end;

TXSTimeInstant = TXSDateTime;

{ TXSBoolean - for xsd:boolean that require nillable support }
TXSBoolean = class(TRemotableXS)
  private
    FBoolean: Boolean;
  public
    function  NativeToXS: WideString; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    property AsBoolean: Boolean read FBoolean write FBoolean;
end;

{ TXSInteger - for xsd:int that require nillable support }
TXSInteger = class(TRemotableXS)
  private
    FInteger: Integer;
  public
    function  NativeToXS: WideString; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    property AsInteger: Integer read FInteger write FInteger;
end;

{ TXSLong - for xsd:long that require nillable support }
TXSLong = class(TRemotableXS)
  private
    FLong: Int64;
  public
    function  NativeToXS: WideString; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString); override;
{$ELSE}
    procedure XSToNative(Value: WideString); override;
{$ENDIF}
    property AsLong: Int64 read FLong write FLong;
end;

{ For cases where one needs access to the raw XMLNode data in a SOAP envelope }
TXMLData = class(TRemotable)
  private
    FXMLDocument: IXMLDocument;
    FXMLNode: IXMLNode;
  public
    constructor Create; override;
    destructor  Destroy; override;
    function   ObjectToSOAP(RootNode, ParentNode: IXMLNode;
                            const ObjConverter: IObjConverter;
                            const Name, URI: InvString; ObjConvOpts: TObjectConvertOptions;
                            out RefID: InvString): IXMLNode; override;
    procedure  SOAPToObject(const RootNode, Node: IXMLNode; const ObjConverter: IObjConverter); override;
    procedure  LoadFomXML(const XML: string); overload;
    procedure  LoadFromXML(const XML: WideString); overload;

    property XMLNode: IXMLNode read FXMLNode;
end;

{ Utility function }

{ XML DateTime <-> Delphi TDateTime conversion routines }
function DateTimeToXMLTime(Value: TDateTime; ApplyLocalBias: Boolean = True): WideString;
function XMLTimeToDateTime(const XMLDateTime: WideString; AsUTCTime: Boolean = False): TDateTime;

{ Utility function for TDateTime -> TXSDateTime conversion }
function DateTimeToXSDateTime(const Value: TDateTime; ApplyLocalBias: Boolean = False): TXSDateTime;

function GetDataFromFile(AFileName: string): string;
function SoapFloatToStr(Value: double): string;
function SoapStrToFloat(Value: string): double;

procedure InitXSTypes;

implementation

uses SOAPConst, {$IFDEF MSWINDOWS}Windows{$ENDIF}{$IFDEF LINUX}Libc{$ENDIF},
     DateUtils, XMLDoc;

type

{ TXSBaseTime }

TXSBaseTime = class
  private
    FFractionalSecondString: string;
    FHour: Word;
    FHourOffset: Word;
    FMinute: Word;
    FMinuteOffset: Word;
    FNegativeOffset: Boolean;
    FSecond: Word;
    FUseZeroMilliseconds: Boolean;
    function BuildHourOffset: WideString;
    function IntToFractionalSeconds(Value: Word): string;
  protected
    function GetAsTime: TDateTime;
    function GetFractionalSeconds: Double;
    function GetFractionalSecondString: string;
    function GetHourOffset: SmallInt;
    function GetMillisecond: Word;
    function GetMinuteOffset: SmallInt;
    procedure SetAsTime(const Value: TDateTime);
    procedure SetFractionalSeconds(const Value: Double);
    procedure SetHour(const Value: Word);
    procedure SetHourOffset(const Value: SmallInt);
    procedure SetMillisecond(const Value: Word);
    procedure SetMinute(const Value: Word);
    procedure SetMinuteOffset(const Value: SmallInt);
    procedure SetSecond(const Value: Word);
    property FractionalSecondString: string read GetFractionalSecondString;
  public
    property AsTime: TDateTime read GetAsTime write SetAsTime;
    property FractionalSeconds: Double read GetFractionalSeconds write
             SetFractionalSeconds;
    property Hour: Word read FHour write SetHour default 0;
    property HourOffset: SmallInt read GetHourOffset write SetHourOffset default 0;
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
    property Minute: Word read FMinute write SetMinute default 0;
    property MinuteOffset: SmallInt read GetMinuteOffset write SetMinuteOffset;
    property Second: Word read FSecond write SetSecond default 0;
    property UseZeroMilliseconds: Boolean read FUseZeroMilliseconds write
             FUseZeroMilliseconds;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString);
{$ELSE}
    procedure XSToNative(Value: WideString);
{$ENDIF}
    function NativeToXS: WideString;
end;

{ TXSBaseDate }

TXSBaseDate = class
  private
    { place holder for future work supporting years with greater than 4 digits }
    FMonth: Word;
    FDay: Word;
    FYear: Integer;
    FNegativeDate: Boolean;
  protected
    function GetAsDate: TDateTime;
    function GetYear: Integer;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetMonth(const Value: Word);
    procedure SetDay(const Value: Word);
    procedure SetYear(const Value: Integer);
  public
    constructor Create;
    property Month: Word read FMonth write SetMonth default 0;
    property Day: Word read FDay write SetDay default 0;
    property Year: Integer read GetYear write SetYear default 0;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString);
{$ELSE}
    procedure XSToNative(Value: WideString);
{$ENDIF}
    function NativeToXS: WideString;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
end;

{ TXSBaseCustomDateTime }

TXSBaseCustomDateTime = class
  private
    FDateParam: TXSBaseDate;
    FTimeParam: TXSBaseTime;
    procedure SetUseZeroMilliseconds(const Value: Boolean);
    function GetUseZeroMilliseconds: Boolean;
  protected
    procedure AdjustDate(Reverse: Boolean); virtual;
    function GetAsDateTime: TDateTime;
    function GetAsUTCDateTime: TDateTime;
    function GetDay: Word;
    function GetFractionalSeconds: Double;
    function GetHour: Word;
    function GetHourOffset: SmallInt;
    function GetMonth: Word;
    function GetMillisecond: Word;
    function GetMinute: Word;
    function GetMinuteOffset: SmallInt;
    function GetSecond: Word;
    function GetYear: Integer;
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsUTCDateTime(const Value: TDateTime);
    procedure SetFractionalSeconds(const Value: Double);
    procedure SetDay(const Value: Word); virtual;
    procedure SetHour(const Value: Word); virtual;
    procedure SetHourOffset(const Value: SmallInt); virtual;
    procedure SetMillisecond(const Value: Word); virtual;
    procedure SetMinute(const Value: Word); virtual;
    procedure SetMinuteOffset(const Value: SmallInt); virtual;
    procedure SetMonth(const Value: Word); virtual;
    procedure SetSecond(const Value: Word); virtual;
    procedure SetYear(const Value: Integer); virtual;
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
  public
    constructor Create;
    destructor Destroy; override;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString);
{$ELSE}
    procedure XSToNative(Value: WideString);
{$ENDIF}
    function NativeToXS: WideString;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsUTCDateTime: TDateTime read GetAsUTCDateTime write SetAsUTCDateTime;
    property FractionalSeconds: Double read GetFractionalSeconds write
             SetFractionalSeconds;
    property Hour: Word read GetHour write SetHour default 0;
    property HourOffset: SmallInt read GetHourOffset write SetHourOffset default 0;
    property Minute: Word read GetMinute write SetMinute default 0;
    property MinuteOffset: SmallInt read GetMinuteOffset write SetMinuteOffset default 0;
    property Second: Word read GetSecond write SetSecond default 0;
    property Month: Word read GetMonth write SetMonth default 0;
    property Day: Word read GetDay write SetDay default 0;
    property Year: Integer read GetYear write SetYear default 0;
    property UseZeroMilliseconds: Boolean read GetUseZeroMilliseconds write
             SetUseZeroMilliseconds;
end;

{ TXSBaseDateTime }

TXSBaseDateTime = class(TXSBaseCustomDateTime)
  public
    property Millisecond: Word read GetMillisecond write SetMillisecond default 0;
end;

TXSBaseDuration = class(TXSBaseCustomDateTime)
  private
    FDecimalSecond: Double;
    function GetDecimalValue(const AParam: String; const AType: string): Double;
    function GetIntegerValue(const AParam: String; const AType: string): Integer;
    function GetNumericString(const AParam: string; const AType: String;
             const Decimals: Boolean = False): WideString;
  protected
    procedure SetDecimalSecond(const Value: Double);
  public
    constructor Create;
{$IFDEF CONST_XS_TO_NATIVE}
    procedure XSToNative(const Value: WideString);
{$ELSE}
    procedure XSToNative(Value: WideString);
{$ENDIF}
    function NativeToXS: WideString;
    function NativeToXSAsDateTime: WideString;
    procedure XSToNativeAsDateTime(const Value: WideString);
    property DecimalSecond: Double read FDecimalSecond write SetDecimalSecond;
end;

  { Record that holds Duration Data }
  TDurationData = record
    Year: Integer;
    Month: Integer;
    Day: Integer;
    Hour: Integer;
    Minute: Integer;
    Second: Double;
    Negative: Boolean;
  end;

DurationDataFlag = (ddYear, ddMonth, ddDay, ddHour, ddMinute, ddSecond);
TDurationDataFlags = set of DurationDataFlag;

function IsDurationType(const DateTimeStr: WideString): Boolean;
begin
  Result := (Length(DateTimeStr) > 2) and
             (DateTimeStr[1] = XMLDurationStart) or
             (DateTimeSTr[1] = '-');
end;

{ exception routines }

procedure SoapDateTimeError(const Message: string); local;
begin
  raise EXSDateTimeException.Create(Message);
end;

procedure SoapDateTimeErrorFmt(const Message: string; const Args: array of const); local;
begin
  SoapDateTimeError(Format(Message,Args));
end;

procedure SoapDecimalError(const Message: string); local;
begin
  raise EXSDecimalException.Create(Message);
end;

procedure SoapDecimalErrorFmt(const Message: string; const Args: array of const); local;
begin
  SoapDecimalError(Format(Message,Args));
end;

procedure SoapHexBinaryError(const Message: string); local;
begin
  raise EXSHexBinaryException.Create(Message);
end;

procedure SoapHexBinaryErrorFmt(const Message: string; const Args: array of const); local;
begin
  SoapHexBinaryError(Format(Message,Args));
end;

{ utility functions }

type
  PFormatSettings = ^TFormatSettings;

var
  FormatSettings : TFormatSettings;

function GetFormatSettings: PFormatSettings;
begin
  if FormatSettings.DecimalSeparator <> SoapDecimalSeparator then
  begin
    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FormatSettings);
    FormatSettings.DecimalSeparator := SoapDecimalSeparator;
  end;
  Result := @FormatSettings;
end;

function SoapFloatToStr(Value: double): string;
begin
  Result := FloatToStr(Value, GetFormatSettings^);
end;

function SoapStrToFloat(Value: string): double;
begin
  Result := StrToFloat(Value, GetFormatSettings^);
end;

function EncodeDuration(const Data: TDurationData): WideString;
const
  sNegPrefix: array[Boolean] of string = ('', '-');
begin
  Result := Format('%sP%dY%dM%dD%dH%dM%sS', [sNegPrefix[Data.Negative],
                                             Data.Year, Data.Month, Data.Day,
                                             Data.Hour, Data.Minute,
                                             SoapFloatToStr(Data.Second)]);
end;

procedure DecodeDuration(const ADuration: string;
                         out Data: TDurationData;
                         Flags: TDurationDataFlags = []);

  function GetNumberBefore(const ASeparator: string;
                           const Decimals: Boolean = False): String;
  var
    I, J: Integer;
  begin
    I := Pos(ASeparator, ADuration);
    J := I;
    while (I > 0) and ((ADuration[I-1] in ['0'..'9']) or
          (Decimals and (ADuration[I-1] = '.'))) do
      Dec(I);
    if J > I then
      Result := Copy(ADuration, I, J-I)
    else
      Result := '0';
  end;

  function GetNumber(const ASeparator: string): Integer;
  begin
    Result := StrToInt(GetNumberBefore(ASeparator));
  end;

  function GetDouble(const ASeparator: string): Double;
  begin
    Result := SoapStrToFloat(GetNumberBefore(ASeparator, True));
  end;

var
  Flag: DurationDataFlag;
begin
  { "The designator 'P' must be present"
    "...at least one number and its designator ·must· be present."
    http://www.w3.org/TR/2001/REC-xmlschema-2-20010502/#duration }
  if (Length(ADuration) < 3) then
    SoapDateTimeErrorFmt(SInvalidDuration, [ADuration]);

  { "The designator 'P' must always be present."
    "An optional preceding minus sign ('-') is allowed, to indicate
     a negative duration."
    http://www.w3.org/TR/2001/REC-xmlschema-2-20010502/#duration }
  if not ((ADuration[1] = XMLDurationStart) or
          ((ADuration[1] = '-')  and (ADuration[2] = XMLDurationStart)))  then
    SoapDateTimeErrorFmt(SInvalidDuration, [ADuration]);

  Data.Negative := ADuration[1] = '-';

  for Flag := Low(DurationDataFlag) to High(DurationDataFlag) do
  begin
    if (Flags = []) or (Flag in Flags) then
    begin
      case Flag of
        ddYear:   data.Year := GetNumber(XMLDurationYear);
        ddMonth:  data.Month := GetNumber(XMLDurationMonth);
        ddDay:    data.Day := GetNumber(XMLDurationDay);
        ddHour:   data.Hour:= GetNumber(XMLDurationHour);
        ddMinute: data.Minute := GetNumber(XMLDurationMinute);
        ddSecond: data.Second := GetDouble(XMLDurationSecond);
      end;
    end;
  end;
end;

function GetBaseTime(const Value: WideString): TXSBaseTime;
begin
  Result := TXSBaseTime.Create;
  try
    { exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNative(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function GetBaseDate(const Value: WideString): TXSBaseDate;
begin
  Result := TXSBaseDate.Create;
  try
    { exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNative(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function GetBaseDurationFromDuration(const Value: WideString): TXSBaseDuration;
begin
  Result := TXSBaseDuration.Create;
  try
    { exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNative(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function GetBaseCustomDateTime(const Value: WideString): TXSBaseCustomDateTime;
begin
  if IsDurationType(Value) then
  begin
    Result := GetBaseDurationFromDuration(Value);
    Exit;
  end;

  Result := TXSBaseCustomDateTime.Create;
  try
    { exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNative(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function GetBaseDateTime(const Value: WideString): TXSBaseDateTime;
begin
  Result := TXSBaseDateTime.Create;
  try
    { Exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNative(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function GetBaseDurationFromDateTime(const Value: WideString): TXSBaseDuration;
begin
  Result := TXSBaseDuration.Create;
  try
    { exception will be raised for invalid values }
    if Value <> '' then
      Result.XSToNativeAsDateTime(Value);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

{ Adjust for Month > 12 or < 1 }
procedure AdjustMonths(var Year: Integer; var Month: Word; Reverse: Boolean);
const
  AdjustAmt: array[Boolean] of Integer = (-12, 12);
begin
  if (Month < 1) or (Month > 12) then
  begin
    Inc(Year, IncrementAmount[Reverse]);
    Inc(Month, AdjustAmt[Reverse]);
  end;
end;

function ValidValue(Value, Subtract, Min, Max: Integer; var Remainder: Integer): Integer;
begin
  Result := Value - Subtract;
  Remainder := 0;
  if Result < Min then
  begin
    Remainder := 1;
    Inc(Result,Max);
  end;
end;

{ Adjust for Days > 28/30/31 or < 1 }
procedure AdjustDays(var Month, Day: Word; const Year: Word; Reverse: Boolean);
var
  Days: Integer;
begin
  Days := DaysInAMonth(Year, Month);
  if (Day < 1) or (Day > Days) then
  begin
    Inc(Month, IncrementAmount[Reverse]);
    if Reverse then
      Dec(Day, Days)
    else
      Inc(Day, Days);
  end;
end;

{ Adjust for Hours over 23 or less than 0 }
procedure AdjustHours(var Day, Hour: Word; Reverse: Boolean);
const
  AdjustAmt: array[Boolean] of Integer = (-24, 24);
begin
  if (Hour > 23) or (Integer(Hour) < 0) then
  begin
    Inc(Day, IncrementAmount[Reverse]);
    Inc(Hour, AdjustAmt[Reverse]);
  end;
end;

{ Adjust Minutes for Hours over 59 or less than 0 }
procedure AdjustMinutes(var Hour, Minute: Word; Reverse: Boolean);
const
  AdjustAmt: array[Boolean] of Integer = (-60, 60);
begin
  if (Minute > 59) or (Integer(Minute) < 0) then
  begin
    Inc(Hour, IncrementAmount[Reverse]);
    Inc(Minute, AdjustAmt[Reverse]);
  end;
end;

{ Utility functions }
{$IFDEF LINUX}
function GetHourMinuteOffset(UTCTime, LocalTime: TUnixTime;
                             var Hour, Minute: Word): Boolean;
var
  LocalT, UTC, Diff: TDateTime;
  Second, Fractions: Word;
begin
  with LocalTime do
  begin
    LocalT := EncodeDate(tm_year, tm_mon, tm_mday);
    if LocalT >= 0 then
      LocalT := LocalT + EncodeTime(tm_hour, tm_min, tm_sec, 0)
    else
      LocalT := LocalT - EncodeTime(tm_hour, tm_min, tm_sec, 0);
  end;
  with UTCTime do
  begin
    UTC := EncodeDate(tm_year, tm_mon, tm_mday);
    if UTC >= 0 then
      UTC := UTC + EncodeTime(tm_hour, tm_min, tm_sec, 0)
    else
      UTC := UTC - EncodeTime(tm_hour, tm_min, tm_sec, 0);
  end;
  Result := UTC > LocalT;
  if Result then
    Diff := UTC - LocalT
  else
    Diff := LocalT - UTC;
  Result := UTC > LocalT;
  DecodeTime(Diff, Hour, Minute, Second, Fractions);
end;
{$ENDIF}

procedure AddUTCBias(DateTime: TXSBaseCustomDateTime);
var
{$IFDEF MSWINDOWS}
  Info: TTimeZoneInformation;
  Status: DWORD;
{$ENDIF}
{$IFDEF LINUX}
  CurTime: PTime_T;
  UTCUnixTime, LocalUnixTime: TUnixTime;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  Status := GetTimeZoneInformation(Info);
  if (Status = TIME_ZONE_ID_UNKNOWN) or (Status = TIME_ZONE_ID_INVALID) then
    SoapDateTimeError(SInvalidTimeZone);
  DateTime.HourOffset := Abs(Info.Bias) div 60;
  DateTime.MinuteOffset := Abs(Info.Bias) - (DateTime.HourOffset * 60);
  DateTime.FTimeParam.FNegativeOffset := (Info.Bias < 0);
  if DateTime.FtimeParam.FNegativeOffset then
  begin
    DateTime.FTimeParam.FHour := DateTime.Hour - DateTime.HourOffset;
    DateTime.FTimeParam.FMinute := DateTime.Minute - DateTime.MinuteOffset;
    DateTime.AdjustDate(True);
  end
  else
  begin
    DateTime.FTimeParam.FHour := DateTime.Hour + DateTime.HourOffset;
    DateTime.FTimeParam.FMinute := DateTime.Minute + DateTime.MinuteOffset;
    DateTime.AdjustDate(False);
  end;
{$ENDIF}
{$IFDEF LINUX}
  CurTime := AllocMem(SizeOf(TTime_T));
  try
    __time(CurTime);
    gmtime_r(CurTime, UTCUnixTime);
    localtime_r(CurTime, LocalUnixTime);
    DateTime.FTimeParam.FNegativeOffset :=
        GetHourMinuteOffset(UTCUnixTime, LocalUnixTime,
        DateTime.FTimeParam.FHourOffset, DateTime.FTimeParam.FMinuteOffset);
  finally
    FreeMem(CurTime);
  end;
{$ENDIF}
end;

function GetTimeZoneBias: Integer;
var
  TimeZoneInfo: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TimeZoneInfo) of
    TIME_ZONE_ID_UNKNOWN: Result := TimeZoneInfo.Bias;
    TIME_ZONE_ID_STANDARD: Result := TimeZoneInfo.Bias + TimeZoneInfo.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := TimeZoneInfo.Bias + TimeZoneInfo.DaylightBias;
  else
    Result := 0;
  end;
end;

function DateTimeToXMLTime(Value: TDateTime; ApplyLocalBias: Boolean = True): WideString;
const
  Neg: array[Boolean] of string=  ('+', '-');
var
  Bias: Integer;
begin
  Result := FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''.''zzz', Value); { Do not localize }
  Bias := GetTimeZoneBias;
  if (Bias <> 0) and ApplyLocalBias then
  begin
    Result := Format('%s%s%.2d:%.2d', [Result, Neg[Bias > 0],                         { Do not localize }
                                       Abs(Bias) div MinsPerHour,
                                       Abs(Bias) mod MinsPerHour]);
  end else
    Result := Result + 'Z'; { Do not localize }
end;

function XMLTimeToDateTime(const XMLDateTime: WideString; AsUTCTime: Boolean = False): TDateTime;
var
  XSDateTime: TXSDateTime;
begin
  XSDateTime := TXSDateTime.Create;
  try
    if XMLDateTime <> '' then
      XSDateTime.XSToNative(XMLDateTime);
    if AsUTCTime then
      Result := XSDateTime.AsUTCDateTime
    else
      Result := XSDateTime.AsDateTime;
  finally
    XSDateTime.Free;
  end;
end;

function DateTimeToXSDateTime(const Value: TDateTime; ApplyLocalBias: Boolean = False): TXSDateTime;
begin
  Result := TXSDateTime.Create;
  Result.XSToNative(DateTimeToXMLTime(Value, ApplyLocalBias));
end;

function GetNext(const P: PChar; Digits: Integer; const SError, Value: string): string;
var
  I: Integer;
begin
  SetLength(Result, Digits);
  for I := 0 to Digits -1 do
  begin
    if P[I] in ['0'..'9'] then
      Result[I+1] := P[I]
    else
      raise EXSDateTimeException.CreateFmt(SError, [Value]);
  end;
end;

function DateTimeToXSBaseDateTime(Value: TDateTime; ApplyLocalBias: Boolean = False): TXSBaseDateTime;
begin
  Result := TXSBaseDateTime.Create;
  Result.XSToNative(DateTimeToXMLTime(Value, ApplyLocalBias));
end;

function XMLDateToStr(const ADate: WideString; AddDigits: Word = 0): WideString;
begin
  Result := Copy(ADate, XMLMonthPos + AddDigits, 2) + DateSeparator +
            Copy(ADate, XMLDayPos + AddDigits, 2 ) +
            DateSeparator + Copy(ADate, XMLYearPos, XMLDefaultYearDigits + AddDigits);
end;

procedure TXSBaseCustomDateTime.AdjustDate(Reverse: Boolean);
begin
  if (FTimeParam.FMinute >= 60) or (Integer(FTimeParam.FMinute) < 0) then
    AdjustMinutes(FTimeParam.FHour, FTimeParam.FMinute, Reverse);
  if (FTimeParam.FHour >= 24) or (Integer(FTimeParam.FHour) < 0) then
  begin
    AdjustHours(FDateParam.FDay, FTimeParam.FHour, Reverse);
    AdjustDays(FDateParam.FMonth, FDateParam.FDay, FDateParam.FYear, Reverse);
    AdjustMonths(FDateParam.FYear, FDateParam.FMonth, Reverse);
  end;
end;

function GetDataFromFile(AFileName: string): string;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(AFileName, fmOpenRead);
  try
    SetLength(Result, Stream.Size);
    Stream.Read(Result[1], Stream.Size);
  finally
    FreeAndNil(Stream);
  end;
end;

{ TXSBaseTime }

function TXSBaseTime.IntToFractionalSeconds(Value: Word): string;
begin
  if Value < 1000 then
  begin
    Result := Format('.%.3d', [Value]);
  end else
    SoapDateTimeErrorFmt(SInvalidMillisecond, [Value]);
end;

function TXSBaseTime.GetFractionalSeconds: Double;
begin
  if FFractionalSecondString = '' then
    Result := 0
  else
    Result := SoapStrToFloat(FFractionalSecondString);
end;

procedure TXSBaseTime.SetFractionalSeconds(const Value: Double);
begin
  if Value > 0 then
    SoapDateTimeErrorFmt(SInvalidFractionalSecond, [Value]);
  FFractionalSecondString := SoapFloatToStr(Value);
end;

function TXSBaseTime.GetFractionalSecondString: string;
begin
  if (FFractionalSecondString = '') and UseZeroMilliseconds then
      Result := '.000'
  else
    Result := FFractionalSecondString;
end;

function TXSBaseTime.GetMilliSecond: Word;
begin
  Result := Round(FractionalSeconds*1000);
end;

procedure TXSBaseTime.SetHour(const Value: Word);
begin
  FHour := Value
end;

procedure TXSBaseTime.SetMinute(const Value: Word);
begin
  FMinute := Value
end;

procedure TXSBaseTime.SetSecond(const Value: Word);
begin
  FSecond := Value
end;

procedure TXSBaseTime.SetMillisecond(const Value: Word);
begin
  FFractionalSecondString := IntToFractionalSeconds(Value);
end;

procedure TXSBaseTime.SetHourOffset(const Value: SmallInt);
const
 {  http://www.w3.org/TR/xmlschema-2/#dateTime:
    ... currently there are no legally prescribed
   timezones which are durations whose magnitude is greater than 14 hours }
  sMaxOffset = 14;
begin
  if Abs(Value) <= sMaxOffset then
  begin
    FHourOffset := Abs(Value);
    if Value < 0 then
      FNegativeOffset := True;
  end else
    SoapDateTimeErrorFmt(SInvalidHourOffset, [Value]);
end;

procedure TXSBaseTime.SetMinuteOffset(const Value: SmallInt);
begin
  if Abs(Value) < 60 then
    FMinuteOffset := Abs(Value)
  else
    SoapDateTimeErrorFmt(SInvalidMinute, [Value]);
end;

function TXSBaseTime.GetHourOffset: SmallInt;
begin
  if FNegativeOffset then
    Result := -FHourOffset
  else
    Result := FHourOffset;
end;

function TXSBaseTime.GetMinuteOffset: SmallInt;
begin
  if FNegativeOffset then
    Result := -FMinuteOffset
  else
    Result := FMinuteOffset;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSBaseTime.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSBaseTime.XSToNative(Value: WideString);
{$ENDIF}
const
  XMLMilSecSeparator : char = '.';
var
  PMilSec, P: PChar;
  LValue: Integer;
  SValue: string;
begin
  { make sure string is long enough }
  SValue := Value;
  LValue := Length(SValue);
  if LValue < 8 then
    raise EXSDateTimeException.CreateFmt(SInvalidTimeString, [SValue]);
  P := PChar(SValue);
  FHour := StrToInt(GetNext(P, 2, SInvalidTimeString, SValue));
  Inc(P, 3);
  FMinute := StrToInt(GetNext(P, 2, SInvalidTimeString, SValue));
  Inc(P, 3);
  FSecond := StrToInt(GetNext(P, 2, SInvalidTimeString, SValue));
  Inc(P, 2);   { now pointing to byte after last second digit }
  { millisecond portion is optional }
  if P^ = XMLMilSecSeparator then
  begin
    { make sure string is long enough }
    if LValue < 10 then
      raise EXSDateTimeException.CreateFmt(SInvalidTimeString, [SValue]);
    PMilSec := P; { save starting position }
    Inc(P);      { skip over Dot }
    if not (P^ in ['0' .. '9']) then
      raise EXSDateTimeException.CreateFmt(SInvalidTimeString, [SValue]);
    while P^ in ['0' .. '9'] do
      Inc(P);
    SetString(FFractionalSecondString, PMilSec, P-PMilSec);
    FUseZeroMilliseconds := True;
  end else
  begin
    FFractionalSecondString := '';
    FUseZeroMilliseconds := False;
  end;
  if P^ in ['-', '+'] then
  begin
    { make sure string is long enough }
    if (LValue < 13 + Length(FFractionalSecondString)) then
      raise EXSDateTimeException.CreateFmt(SInvalidTimeString, [SValue]);
    FNegativeOffset := (P^ = '-');
    Inc(P);
    FHourOffset := StrToInt(GetNext(P, 2, SInvalidTimeOffset, SValue));
    Inc(P, 3);
    MinuteOffset := StrToInt(GetNext(P, 2, SInvalidTimeOffset, SValue));
  end else
  begin
    HourOffset := 0;
    MinuteOffset := 0;
  end;
end;

function TXSBaseTime.BuildHourOffset: WideString;
var
  Marker: String;
begin
  if Abs(FHourOffset) + Abs(FMinuteOffset) > 0 then
  begin
    if FNegativeOffset then
      Marker := XMLHourOffsetMinusMarker
    else
      Marker := XMLHourOffsetPlusMarker;
    Result := IntToStr(Abs(HourOffset));
    if Abs(HourOffset) < 10 then
      Result := '0' + Result;
    if Abs(MinuteOffSet) > 9 then
      Result := Result + XMLTimeSeparator + IntToStr(Abs(MinuteOffset))
    else if Abs(MinuteOffSet) > 0 then
      Result := Result + XMLTimeSeparator + '0' + IntToStr(Abs(MinuteOffset))
    else
      Result := Result + XMLTimeSeparator + '00';
    Result := Marker + Result;
  end else
    Result := SLocalTimeMarker;
end;

function TXSBaseTime.NativeToXS: WideString;
begin
  Result := Format('%.2d%s%.2d%s%.2d', [Hour, XMLTimeSeparator,
            Minute, XMLTimeSeparator, Second]) +
            FFractionalSecondString + BuildHourOffset;
end;

procedure TXSBaseTime.SetAsTime(const Value: TDateTime);
var
  AMilSeconds: Word;
begin
  DecodeTime(Value, FHour, FMinute, FSecond, AMilSeconds);
  FFractionalSecondString := IntToFractionalSeconds(AMilSeconds);
end;

function TXSBaseTime.GetAsTime: TDateTime;
begin
  Result := EncodeTime(Hour, Minute, Second, 0);
end;

{ TXSBaseDate }

constructor TXSBaseDate.Create;
begin
  inherited Create;
end;

procedure TXSBaseDate.SetMonth(const Value: Word);
begin
  FMonth := Value
end;

procedure TXSBaseDate.SetDay(const Value: Word);
begin
  FDay := Value
end;

procedure TXSBaseDate.SetYear(const Value: Integer);
begin
  FYear := Abs(Value);
  FNegativeDate := Value < 0;
end;


{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSBaseDate.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSBaseDate.XSToNative(Value: WideString);
{$ENDIF}

  procedure ConvertDate(var Value: string);
  var
    P: PChar;
  begin
    P := PChar(Value);
    FYear := StrToInt(GetNext(P, 4, SInvalidDateString, Value));
    Inc(P, 5);
    FMonth := StrToInt(GetNext(P, 2, SInvalidDateString, Value));
    Inc(P, 3);
    FDay := StrToInt(GetNext(P, 2, SInvalidDateString, Value));
  end;

var
  TempValue: string;
begin
  FNegativeDate := (Value[1] = '-');
  if FNegativeDate then
    TempValue := Copy(Value, 2, Length(Value))
  else
    TempValue := Value;
//  FAdditionalYearDigits := GetAdditionalYears(TempValue);
  if Length(TempValue) < 10 then
    raise EXSDateTimeException.CreateFmt(SInvalidDateString, [TempValue]);
  ConvertDate(TempValue);
end;

function TXSBaseDate.NativeToXS: WideString;
const
  sFormatString = '%s%.4d-%.2d-%.2d';
  sNegative: array[boolean] of string = ('', '-');
begin
  Result := Format(sFormatString, [sNegative[FNegativeDate], FYear, FMonth, FDay]);
end;

function TXSBaseDate.GetYear: Integer;
begin
  Result := FYear;
  if FNegativeDate then
    Result := -Result;
end;

function TXSBaseDate.GetAsDate: TDateTime;
begin
  Result := EncodeDate(Year, Month, Day);
end;

procedure TXSBaseDate.SetAsDate(const Value: TDateTime);
var
  AYear: Word;
begin
  { Earliest TDateTime is 30 Dec 1899 }
  FNegativeDate := False;
  DecodeDate(Value, AYear, FMonth, FDay);
  FYear := Integer(AYear);
end;

{ TXSBaseCustomDateTime }

constructor TXSBaseCustomDateTime.Create;
begin
  Inherited Create;
  FDateParam := TXSBaseDate.Create;
  FTimeParam := TXSBaseTime.Create;
end;

destructor TXSBaseCustomDateTime.Destroy;
begin
  FreeAndNil(FDateParam);
  FreeAndNil(FTimeParam);
  inherited Destroy;
end;

function TXSBaseCustomDateTime.GetFractionalSeconds: Double;
begin
  Result := FTimeParam.GetFractionalSeconds;
end;

procedure TXSBaseCustomDateTime.SetFractionalSeconds(const Value: Double);
begin
  FTimeParam.SetFractionalSeconds(Value);
end;

procedure TXSBaseCustomDateTime.SetUseZeroMilliseconds(const Value: Boolean);
begin
  FTimeParam.FUseZeroMilliseconds := Value;
end;

function TXSBaseCustomDateTime.GetUseZeroMilliseconds: Boolean;
begin
  Result := FTimeParam.FUseZeroMilliseconds;
end;

function TXSBaseCustomDateTime.GetHour: Word;
begin
  Result := FTimeParam.Hour;
end;

function TXSBaseCustomDateTime.GetMinute: Word;
begin
  Result := FTimeParam.Minute;
end;

function TXSBaseCustomDateTime.GetSecond: Word;
begin
  Result := FTimeParam.Second;
end;

function TXSBaseCustomDateTime.GetMilliSecond: Word;
begin
  Result := FTimeParam.MilliSecond;
end;

function TXSBaseCustomDateTime.GetHourOffset: SmallInt;
begin
  Result := FTimeParam.HourOffset
end;

function TXSBaseCustomDateTime.GetMinuteOffset: SmallInt;
begin
  Result := FTimeParam.MinuteOffset
end;

function TXSBaseCustomDateTime.GetMonth: Word;
begin
  Result := FDateParam.Month;
end;

function TXSBaseCustomDateTime.GetDay: Word;
begin
  Result := FDateParam.Day;
end;

function TXSBaseCustomDateTime.GetYear: Integer;
begin
  Result := FDateParam.Year;
end;

procedure TXSBaseCustomDateTime.SetHour(const Value: Word);
begin
  FTimeParam.SetHour(Value);
end;

procedure TXSBaseCustomDateTime.SetMinute(const Value: Word);
begin
  FTimeParam.SetMinute(Value);
end;

procedure TXSBaseCustomDateTime.SetSecond(const Value: Word);
begin
  FTimeParam.SetSecond(Value);
end;

procedure TXSBaseCustomDateTime.SetMillisecond(const Value: Word);
begin
  FTimeParam.SetMillisecond(Value);
end;

procedure TXSBaseCustomDateTime.SetHourOffset(const Value: SmallInt);
begin
  FTimeParam.SetHourOffset(Value);
end;

procedure TXSBaseCustomDateTime.SetMinuteOffset(const Value: SmallInt);
begin
  FTimeParam.SetMinuteOffset(Value);
end;

procedure TXSBaseCustomDateTime.SetMonth(const Value: Word);
begin
  FDateParam.SetMonth(Value);
end;

procedure TXSBaseCustomDateTime.SetDay(const Value: Word);
begin
  FDateParam.SetDay(Value);
end;

procedure TXSBaseCustomDateTime.SetYear(const Value: Integer);
begin
  FDateParam.SetYear(Value);
end;

procedure TXSBaseCustomDateTime.SetAsDateTime(const Value: TDateTime);
begin
  FDateParam.AsDate := Value;
  FTimeParam.AsTime := Value;
end;

procedure TXSBaseCustomDateTime.SetAsUTCDateTime(const Value: TDateTime);
begin
  FDateParam.AsDate := Value;
  FTimeParam.AsTime := Value;
  AddUTCBias(Self);
end;

function TXSBaseCustomDateTime.GetAsDateTime: TDateTime;
var
  BiasDT: TDateTime;
  BiasTime, BiasLocal: Integer;
  BiasHour, BiasMins: Word;
begin
  { NOTE: In XML Years can exceed 9999 - that's not the case for TDateTime.
          So here, there would be a problem with the conversion }
  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0);
  { Now adjust TDateTime based on any offsets we have and the local bias }
  { There are two possibilities:
      a. The time we have has the same offset as the local bias - nothing to do!!
      b. The time we have and the local bias are different - requiring adjustments }
  BiasLocal := GetTimeZoneBias;
  BiasTime  := (HourOffset * MinsPerHour) + MinuteOffset;
  if (BiasLocal + BiasTime) = 0 then
    Exit;

  { Here we adjust the Local Bias to make it relative to the Time's own offset
    instead of being relative to GMT }
  BiasLocal := BiasLocal + BiasTime;
  BiasHour := Abs(BiasLocal) div MinsPerHour;
  BiasMins := Abs(BiasLocal) mod MinsPerHour;
  BiasDT := EncodeTime(BiasHour, BiasMins, 0, 0);
  if (BiasLocal > 0) then
    Result := Result - BiasDT
  else
    Result := Result + BiasDT;
end;

function TXSBaseCustomDateTime.GetAsUTCDateTime: TDateTime;
var
  AdjustDT: TDateTime;
begin
  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0);
  { If we have an offset, adjust time to go back to UTC }
  if (HourOffset <> 0) or (MinuteOffset <> 0) then
  begin
    AdjustDT := EncodeTime(Abs(HourOffset), Abs(MinuteOffset), 0, 0);
    if ((HourOffset * MinsPerHour) + MinuteOffset) > 0 then
      Result := Result - AdjustDT
    else
      Result := Result + AdjustDT;
  end;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSBaseCustomDateTime.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSBaseCustomDateTime.XSToNative(Value: WideString);
{$ENDIF}
var
  TimeString, DateString: WideString;
  TimePosition: Integer;
begin
  TimePosition := Pos(SoapTimePrefix, Value);
  if TimePosition > 0 then
  begin
    DateString := Copy(Value, 1, TimePosition -1);
    TimeString := Copy(Value, TimePosition + 1, Length(Value) - TimePosition);
    FDateParam.XSToNative(DateString);
    FTimeParam.XSToNative(TimeString);
  end else
  begin
    FTimeParam.Hour := 0;
    FTimeParam.Minute := 0;
    FTimeParam.Second := 0;
    FTimeParam.Millisecond := 0;
    FTimeParam.HourOffset := 0;
    FDateParam.XSToNative(Value);
  end;
end;

function TXSBaseCustomDateTime.NativeToXS: WideString;
var
  TimeString: WideString;
begin
  TimeString := FTimeParam.NativeToXS;
  if TimeString <> '' then
    Result := FDateParam.NativeToXS + SoapTimePrefix + TimeString
  else
    Result := FDateParam.NativeToXS;
end;

{ TXSTime }

function TXSTime.GetAsTime: TDateTime;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.AsTime;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetFractionalSeconds: Double;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.FractionalSeconds;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetFractionalSecondString: string;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.FractionalSecondString;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetHourOffset: SmallInt;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.HourOffset;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetHour: Word;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.Hour;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetMillisecond: Word;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.Millisecond;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetMinute: Word;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.Minute;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetMinuteOffset: SmallInt;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.MinuteOffset;
  finally
    Time.Free;
  end;
end;

function TXSTime.GetSecond: Word;
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Result := Time.Second;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetAsTime(const Value: TDateTime);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.AsTime := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetFractionalSeconds(const Value: Double);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.FractionalSeconds := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetHour(const Value: Word);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.Hour := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetHourOffset(const Value: SmallInt);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.HourOffset := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetMillisecond(const Value: Word);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.Millisecond := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetMinute(const Value: Word);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.Minute := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetMinuteOffset(const Value: SmallInt);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.MinuteOffset := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

procedure TXSTime.SetSecond(const Value: Word);
var
  Time: TXSBaseTime;
begin
  Time := GetBaseTime(FTimeValue);
  try
    Time.Second := Value;
    FTimeValue := Time.NativeToXS;
  finally
    Time.Free;
  end;
end;

function TXSTime.Clone: TXSTime;
begin
  Result := TXSTime.Create;
  try
    if FTimeValue <> '' then
      Result.XSToNative(FTimeValue);
  except
    FreeAndNil(Result)
  end;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSTime.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSTime.XSToNative(Value: WideString);
{$ENDIF}
begin
  FTimeValue := Value;
end;

function TXSTime.NativeToXS: WideString;
const
  sDefaultValue: WideString = '00:00:00';
begin
  if FTimeValue <> '' then
    Result := FTimeValue
  else
    Result := sDefaultValue;
end;

{ TXSDate }

function TXSDate.GetAsDate: TDateTime;
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    Result := ADate.AsDate;
  finally
    ADate.Free;
  end;
end;

function TXSDate.GetDay: Word;
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    Result := ADate.Day;
  finally
    ADate.Free;
  end;
end;

function TXSDate.GetMonth: Word;
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    Result := ADate.Month;
  finally
    ADate.Free;
  end;
end;

function TXSDate.GetYear: Integer;
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    Result := ADate.Year;
  finally
    ADate.Free;
  end;
end;

procedure TXSDate.SetAsDate(const Value: TDateTime);
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    ADate.AsDate := Value;
    FDateValue := ADate.NativeToXS;
  finally
    ADate.Free;
  end;
end;

procedure TXSDate.SetMonth(const Value: Word);
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    ADate.Month := Value;
    FDateValue := ADate.NativeToXS;
  finally
    ADate.Free;
  end;
end;

procedure TXSDate.SetDay(const Value: Word);
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    ADate.Day := Value;
    FDateValue := ADate.NativeToXS;
  finally
    ADate.Free;
  end;
end;

procedure TXSDate.SetYear(const Value: Integer);
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(FDateValue);
  try
    ADate.Year := Value;
    FDateValue := ADate.NativeToXS;
  finally
    ADate.Free;
  end;
end;

constructor TXSDate.Create; 
begin
  inherited Create;
end;

function TXSDate.Clone: TXSDate;
begin
  Result := TXSDate.Create;
  try
    if FDateValue <> '' then
      Result.XSToNative(FDateValue);
  except
    FreeAndNil(Result);
  end;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSDate.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSDate.XSToNative(Value: WideString);
{$ENDIF}
var
  ADate: TXSBaseDate;
begin
  ADate := GetBaseDate(Value);
  try
    FDateValue := Value;
  finally
    ADate.Free;
  end;    
end;

function TXSDate.NativeToXS: WideString;
const
  sDefaultValue: WideString = '0001-01-01';
begin
  if FDateValue <> '' then
    Result := FDateValue
  else
    Result := sDefaultValue;
end;

{ TXSCustomDateTime }

function TXSCustomDateTime.GetAsDateTime: TDateTime;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.AsDateTime;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetAsUTCDateTime: TDateTime;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.AsUTCDateTime;
  finally
    DateTime.Free;
  end;
end;


function TXSCustomDateTime.GetDay: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Day;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetFractionalSeconds: Double;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.FractionalSeconds;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetHour: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Hour;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetHourOffset: SmallInt;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.HourOffset;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetMonth: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Month;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetMillisecond: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Millisecond;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetMinute: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Minute;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetMinuteOffset: SmallInt;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.MinuteOffset;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetSecond: Word;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Second;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetUseZeroMilliseconds: Boolean;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.UseZeroMilliseconds;
  finally
    DateTime.Free;
  end;
end;

function TXSCustomDateTime.GetYear: Integer;
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    Result := DateTime.Year;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetAsDateTime(const Value: TDateTime);
begin
  { Here the user gives us a TDateTime that's in the current TimeZone }
  { So we store the value with the offset of the local bias }
  FDateTime := DateTimeToXMLTime(Value, True);
end;

procedure TXSCustomDateTime.SetAsUTCDateTime(const Value: TDateTime);
begin
  { Here we are given a TDateTime that's already UTC. Therefore
    we don't need to save the Local Bias as Offset }
  FDateTime := DateTimeToXMLTime(Value, False);
end;

procedure TXSCustomDateTime.SetFractionalSeconds(const Value: Double);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.FractionalSeconds := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetDay(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Day := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetHour(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Hour := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetHourOffset(const Value: SmallInt);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.HourOffset := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetMillisecond(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Millisecond := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetMinute(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Minute := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetMinuteOffset(const Value: SmallInt);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.MinuteOffset := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetMonth(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Month := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetSecond(const Value: Word);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Second := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetUseZeroMilliseconds(const Value: Boolean);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.UseZeroMilliseconds := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

procedure TXSCustomDateTime.SetYear(const Value: Integer);
var
  DateTime: TXSBaseCustomDateTime;
begin
  DateTime := GetBaseCustomDateTime(FDateTime);
  try
    DateTime.Year := Value;
    FDateTime := DateTime.NativeToXS;
  finally
    DateTime.Free;
  end;
end;

constructor TXSCustomDateTime.Create;
const
  sDefaultValue: WideString = '0001-01-01T00:00:00';
begin
  FDateTime := sDefaultValue;
  inherited Create;
end;

destructor TXSCustomDateTime.Destroy; 
begin
  inherited Destroy;
end;

{ TXSDateTime }

function TXSDateTime.CompareDateTimeParam(const Value1, Value2: TXSDateTime): TXSDuration;
var
  Duration: TXSBaseDuration;
  Remainder, Milliseconds, Seconds: Integer;
  DateTime1, DateTime2: TXSBaseDateTime;
begin
  DateTime1 := GetBaseDateTime(Value1.FDateTime);
  try
    DateTime2 := GetBaseDateTime(Value2.FDateTime);
    try
      Duration := TXSBaseDuration.Create;
      try
        MilliSeconds := ValidValue(DateTime1.Millisecond, DateTime2.Millisecond, 0, 1000, Remainder);
        Seconds := ValidValue(DateTime1.Second + Remainder, DateTime2.Second, 0, 60, Remainder);
        Duration.DecimalSecond := Seconds + Milliseconds / 1000;
        Duration.FTimeParam.FMinute := ValidValue(DateTime1.Minute + Remainder, DateTime2.Minute, 0, 60, Remainder);
        Duration.FTimeParam.FHour := ValidValue(DateTime1.Hour + Remainder, DateTime2.Hour, 0, 24, Remainder);
        Duration.FDateParam.FDay := ValidValue(DateTime1.Day + Remainder, DateTime2.Day, 0, 31, Remainder);
        Duration.FdateParam.FMonth := ValidValue(DateTime1.Month + Remainder, DateTime2.Month, 0, 12, Remainder);
        Duration.FdateParam.FYear := ValidValue(DateTime1.Year + Remainder, DateTime2.Year, -9999, 0, Remainder);
        Result := TXSDuration.Create;
        try
          Result.FDateTime := Duration.NativeToXS;
        except
          FreeAndNil(Result);
        end;
      finally
        Duration.Free
      end;
    finally
      DateTime2.Free;
    end;
  finally
    DateTime1.Free;
  end;
end;

function TXSDateTime.Clone: TXSDateTime;
begin
  Result := TXSDateTime.Create;
  try
    if FDateTime <> '' then
      Result.XSToNative(FDateTime);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSDateTime.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSDateTime.XSToNative(Value: WideString);
{$ENDIF}
var
  BaseDate: TXSBaseDateTime;
begin
  BaseDate := GetBaseDateTime(Value);
  try
    FDateTime := Value;
  finally
    BaseDate.Free;
  end;
end;

function TXSDateTime.NativeToXS: WideString;
begin
  Result := FDateTime;
end;                     

{ TXSBaseDuration }

constructor TXSBaseDuration.Create;
begin
  inherited Create;
end;

procedure TXSBaseDuration.SetDecimalSecond(const Value: Double);
begin
  if Value < 60 then
    FDecimalSecond := Value
  else
    SoapDateTimeErrorFmt(SInvalidFractionSecond, [Value]);
end;

function TXSBaseDuration.GetNumericString(const AParam: string; const AType: string;
         const Decimals: Boolean = False): WideString;
var
  I, J: Integer;
begin
  I := Pos(AType, AParam);
  J := I;
  while (I > 0) and ((AParam[I-1] in ['0'..'9']) or
        (Decimals and (AParam[I-1] = '.'))) do
    Dec(I);
  if J > I then
    Result := Copy(AParam, I, J-I)
  else
    Result := '0';
end;

function TXSBaseDuration.GetIntegerValue(const AParam: string; const AType: string): Integer;
begin
  Result := StrToInt(GetNumericString(AParam, AType));
end;

function TXSBaseDuration.GetDecimalValue(const AParam: string; const AType: string): Double;
begin
  Result := SoapStrToFloat(GetNumericString(AParam, AType, True));
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSBaseDuration.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSBaseDuration.XSToNative(Value: WideString);
{$ENDIF}
var
  DateString, TimeString: string;
  TimePosition: Integer;
begin
  if (Length(Value) < 2) then
    SoapDateTimeErrorFmt(SInvalidDuration, [Value]);
  if not ((Value[1] = XMLDurationStart) or
          ((Value[1] = '-') and (Value[2] = XMLDurationStart))) then
    SoapDateTimeErrorFmt(SInvalidDuration, [Value]);

  { Exception will be thrown if values are invalid }
  TimePosition := Pos(SoapTimePrefix, Value);
  if TimePosition > 0 then
  begin
    TimeString := Copy(Value, TimePosition + 1, Length(Value) - TimePosition);
    DateString := Copy(Value, 1, TimePosition - 1);
  end else
    DateString := Value;

  FDateParam.FNegativeDate := Value[1] = '-';
  FDateParam.FYear := GetIntegerValue(DateString, XMLDurationYear);
  FDateParam.FMonth := GetIntegerValue(DateString, XMLDurationMonth);
  FDateParam.FDay := GetIntegerValue(DateString, XMLDurationDay);

  if TimePosition > 0 then
  begin
    FTimeParam.FHour := GetIntegerValue(TimeString, XMLDurationHour);
    FTimeParam.FMinute := GetIntegerValue(TimeString, XMLDurationMinute);
    FDecimalSecond := GetDecimalValue(TimeString, XMLDurationSecond);
  end
  else
  begin
    FTimeParam.FHour := 0;
    FTimeParam.FMinute := 0;
    FDecimalSecond := 0;
  end;
end;

{ Format is '[-]P1Y2M3DT10H30M12.3S' }
function TXSBaseDuration.NativeToXS: WideString;
const
  sNegativePrefix: array[boolean] of string = ('', '-');
begin
  { Could skip items with value of zero ?? }
  Result := sNegativePrefix[FDateParam.FNegativeDate] +
            XMLDurationStart +
              IntToStr(Year) + XMLDurationYear +
              IntToStr(Month) + XMLDurationMonth +
              IntToStr(Day) + XMLDurationDay + SoapTimePrefix +
              IntToStr(Hour) + XMLDurationHour +
              IntToStr(Minute) + XMLDurationMinute +
              SoapFloatToStr(DecimalSecond) + XMLDurationSecond;
end;

function TXSBaseDuration.NativeToXSAsDateTime: WideString;
begin
  Result := inherited NativeToXS;
end;


procedure TXSBaseDuration.XSToNativeAsDateTime(const Value: WideString);
begin
  inherited XSToNative(Value);
end;

{ TXSDuration }

function TXSDuration.GetDecimalSecond: Double;
var
  Duration: TXSBaseDuration;
begin
  Duration := GetBaseDurationFromDateTime(FDateTime);
  try
    Result := Duration.DecimalSecond;
  finally
    Duration.Free;
  end;
end;

procedure TXSDuration.SetDecimalSecond(const Value: Double);
var
  Duration: TXSBaseDuration;
begin
  Duration := GetBaseDurationFromDateTime(FDateTime);
  try
    Duration.SetDecimalSecond(Value);
    FDateTime := Duration.NativeToXS;
  finally
    Duration.Free;
  end;
end;

constructor TXSDuration.Create;
const
  sDefaultValue: WideString = '0000-00-00T00:00:00';
begin
  inherited Create;
  FDateTime := sDefaultValue;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSDuration.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSDuration.XSToNative(Value: WideString);
{$ENDIF}
var
  Duration: TXSBaseDuration;
begin
  Duration := GetBaseDurationFromDuration(Value);
  try
    FDateTime := Duration.NativeToXSAsDateTime;
  finally
    Duration.Free;
  end;
end;

function TXSDuration.NativeToXS: WideString;
var
  Duration: TXSBaseDuration;
begin
  Duration := GetBaseDurationFromDateTime(FDateTime);
  try
    Result := Duration.NativeToXS;
  finally
    Duration.Free;
  end;
end;

{ TXSHexBinary }

function TXSHexBinary.NativeToXS: WideString;
begin
  Result := FHexBinaryString;
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSHexBinary.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSHexBinary.XSToNative(Value: WideString);
{$ENDIF}
var
  PText: PChar;
  V: string;
  L : Integer;
begin
  V := Value;
  L := Length(V);
  PText := AllocMem(L * 2 + 1);
  try
    if Pos(SHexMarker, V) = 0 then
      V := SHexMarker + V;
    if HexToBin(PChar(V), PText, L) > 0 then
      SoapHexBinaryErrorFmt(SInvalidHexValue, [Value]);
    FHexBinaryString := Value;
  finally
    FreeMem(PText);
  end;
end;

function TXSHexBinary.GetAsByteArray: TByteDynArray;
var
  P: PChar;
begin
  if FHexBinaryString = '' then
    SetLength(Result, 0)
  else
  begin
    SetLength(Result, Length(FHexBinaryString));
    P := @Result[0];
    HexToBin(PChar(FHexBinaryString), P, Length(FHexBinaryString));
  end;
end;

procedure TXSHexBinary.SetAsByteArray(const Value: TByteDynArray);
var
  P, PText: PChar;
  L : Integer;
begin
  P := @Value[0];
  L := Length(Value);
  PText := AllocMem((L+1) * 2);
  try
    BinToHex(P, PText, L);
    SetString(FHexBinaryString, PText, StrLen(PText));
  finally
    FreeMem(PText);
  end;
end;

{ TXSDecimal }

function TXSDecimal.NativeToXS: WideString;
begin
  Result := FDecimalString
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSDecimal.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSDecimal.XSToNative(Value: WideString);
{$ENDIF}
begin
  FDecimalString := Value;
end;

function TXSDecimal.GetAsBcd: TBcd;

  procedure CheckDecimalString(const Value: WideString);
  begin
    if Pos(SSciNotationMarker, Value) > 0 then
      SoapDecimalError(SNoSciNotation)
    else if Pos(SNAN, Value) > 0 then
      SoapDecimalError(SNoNAN)
    else if Length(Value) > 2 + (MaxFMTBcdDigits * 2) then
      SoapDecimalErrorFMT(SBcdStringTooBig, [Value]);
  end;

const
  sDefaultValue: WideString = '00';
var
  Value: WideString;
begin
  Value := NativeToXS;
  if Value = '' then
    Value := sDefaultValue;
  CheckDecimalString(Value);
  if not TryStrToBcd(Value, Result) then
    SoapDecimalErrorFmt(SInvalidDecimalString, [Value]);
end;

procedure TXSDecimal.SetAsBcd(const Value: TBcd);
begin
  if (Value.Precision > MaxFMTBcdDigits * 2) or
     (Value.Precision < 1) or
     (BcdScale(Value) > MaxFMTBcdDigits * 2) then
    SoapDecimalErrorFmt(SInvalidBcd, [Value.Precision, BcdScale(Value)]);
  FDecimalString := BcdToStr(Value);
end;

{ TXSString }

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSString.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSString.XSToNative(Value: WideString);
{$ENDIF}
begin
  FString := Value;
end;

function  TXSString.NativeToXS: WideString;
begin
  Result := FString;
end;

function TXSBoolean.NativeToXS: WideString;
const
  sValues: array[Boolean] of WideString = ('0', '1'); { Do not localize }
begin
  Result := sValues[FBoolean]
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSBoolean.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSBoolean.XSToNative(Value: WideString);
{$ENDIF}
begin
  FBoolean := (Value = '1') or (Value = 'true'); { Do not localize }
end;

{ TXSInteger }

function TXSInteger.NativeToXS: WideString;
begin
  Result := IntToStr(FInteger);
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSInteger.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSInteger.XSToNative(Value: WideString);
{$ENDIF}
begin
  FInteger := StrToInt(Value);
end;

{ TXSLong }

function TXSLong.NativeToXS: WideString;
begin
  Result := IntToStr(FLong);
end;

{$IFDEF CONST_XS_TO_NATIVE}
procedure TXSLong.XSToNative(const Value: WideString);
{$ELSE}
procedure TXSLong.XSToNative(Value: WideString);
{$ENDIF}
begin
  FLong := StrToInt64(Value);
end;

{ TXMLData }

constructor TXMLData.Create;
begin
  inherited;
  FXMLDocument := NewXMLDocument;
end;

destructor TXMLData.Destroy;
begin
  FXMLNode := nil;
  FXMLDocument := nil;
  inherited;
end;

procedure TXMLData.LoadFomXML(const XML: string);
begin
  FXMLDocument.LoadFromXML(XML);
  if FXMLDocument.Node.ChildNodes.Count > 0 then
    FXMLNode := FXMLDocument.Node.ChildNodes[0];
end;

procedure TXMLData.LoadFromXML(const XML: WideString);
begin
  FXMLDocument.LoadFromXML(XML);
  if FXMLDocument.Node.ChildNodes.Count > 0 then
    FXMLNode := FXMLDocument.Node.ChildNodes[0];
end;

{ Utility routine lifted from XMLDoc.pas }
function CloneNodeToDoc(const SourceNode: IXMLNode; const TargetDoc: IXMLDocument;
  Deep: Boolean = True): IXMLNode;
var
  I: Integer;
begin
  with SourceNode do
    case nodeType of
      ntElement:
        begin
          Result := TargetDoc.CreateElement(NodeName, NamespaceURI);
          for I := 0 to AttributeNodes.Count - 1 do
            Result.AttributeNodes.Add(CloneNodeToDoc(AttributeNodes[I], TargetDoc, False));
          if Deep then
            for I := 0 to ChildNodes.Count - 1 do
              Result.ChildNodes.Add(CloneNodeToDoc(ChildNodes[I], TargetDoc, Deep));
        end;
      ntAttribute:
        begin
          Result := TargetDoc.CreateNode(NodeName, ntAttribute, NamespaceURI);
          Result.NodeValue := NodeValue;
        end;
      ntText, ntCData, ntComment:
          Result := TargetDoc.CreateNode(NodeValue, NodeType);
      ntEntityRef:
          Result := TargetDoc.createNode(nodeName, NodeType);
      ntProcessingInstr:
          Result := TargetDoc.CreateNode(NodeName, ntProcessingInstr, NodeValue);
      ntDocFragment:
        begin
          Result := TargetDoc.CreateNode('', ntDocFragment);
          if Deep then
            for I := 0 to ChildNodes.Count - 1 do
              Result.ChildNodes.Add(CloneNodeToDoc(ChildNodes[I], TargetDoc, Deep));
        end;
      else
       {ntReserved, ntEntity, ntDocument, ntDocType:}
       { XMLDocError(SInvalidNodeType); }
    end;
end;

function TXMLData.ObjectToSOAP(RootNode, ParentNode: IXMLNode;
  const ObjConverter: IObjConverter; const Name, URI: InvString;
  ObjConvOpts: TObjectConvertOptions; out RefID: InvString): IXMLNode;
var
  RawNode: IXMLNode;
begin
  Result := inherited ObjectToSOAP(RootNode, ParentNode, ObjConverter, Name, URI,
                                   ObjConvOpts+[ocoDontSerializeProps], RefId);
  if (Result <> nil) and (FXMLNode <> nil) then
  begin
    RawNode := CloneNodeToDoc(FXMLNode, ParentNode.OwnerDocument, True);
    if RawNode <> nil then
      Result.ChildNodes.Add(RawNode);
  end;
end;

procedure TXMLData.SOAPToObject(const RootNode, Node: IXMLNode;
  const ObjConverter: IObjConverter);
begin
  if Node.ChildNodes.Count = 1 then
    FXMLNode := CloneNodeToDoc(Node.ChildNodes[0], FXMLDocument, True)
end;

procedure InitXSTypes;
begin
  RemClassRegistry.RegisterXSClass(TXSDateTime, XMLSchemaNameSpace, 'dateTime', '',True);
  RemClassRegistry.RegisterXSClass(TXSTimeInstant, XMLSchemaNameSpace, 'timeInstant', '', True);
  RemClassRegistry.RegisterXSClass(TXSTime, XMLSchemaNameSpace, 'time', '', True);
  RemClassRegistry.RegisterXSClass(TXSDate, XMLSchemaNameSpace, 'date', '', True);
  RemClassRegistry.RegisterXSClass(TXSDuration, XMLSchemaNameSpace, 'duration', '', True);
  RemClassRegistry.RegisterXSClass(TXSDuration, XMLSchemaNameSpace, 'timeDuration', '', True);
  RemClassRegistry.RegisterXSClass(TXSHexBinary, XMLSchemaNamespace, 'hexBinary', '', True);
  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'decimal', '', True);
  {
  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'integer', '', True);
  }
  RemClassRegistry.RegisterXSClass(TXSSTring, XMLSchemaNamespace, 'string', '', True);
  RemClassRegistry.RegisterXSClass(TXSBoolean, XMLSchemaNamespace, 'boolean', '', True);
  RemClassRegistry.RegisterXSClass(TXSInteger, XMLSchemaNamespace, 'int', '', True);
  RemClassRegistry.RegisterXSClass(TXSLong, XMLSchemaNamespace, 'long', '', True);

  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'negativeInteger', '', True);
  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'nonNegativeInteger', '', True);
  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'nonPositiveInteger', '', True);
  RemClassRegistry.RegisterXSClass(TXSDecimal, XMLSchemaNamespace, 'positiveInteger', '', True);
end;

end.
