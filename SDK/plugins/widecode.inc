function WStrScan(const Str: PWideChar; Chr: WideChar): PWideChar;
begin
  Result := Str;
  while Result^ <> Chr do
  begin
    if Result^ = #0 then
    begin
      Result := nil;
      Exit;
    end;
    Inc(Result);
  end;
end;

function WideLastDelimiter(const Delimiters, S: WideString): Integer;
var
  P: PWideChar;
begin
  Result := Length(S);
  P := PWideChar(Delimiters);
  while Result > 0 do
  begin
    if (S[Result] <> #0) and (WStrScan(P, S[Result]) <> nil) then
      Exit;
    Dec(Result);
  end;
end;

function WideExtractFileName(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := WideLastDelimiter('\:', FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function WideIsPathDelimiter(const S: WideString; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = PathDelim);
end;

function WideExcludeTrailingPathDelimiter(const S: WideString): WideString;
begin
  Result := S;
  if WideIsPathDelimiter(Result, Length(Result)) then
    SetLength(Result, Length(Result)-1);
end;

function WideExcludeTrailingBackslash(const S: WideString): WideString;
begin
  Result := WideExcludeTrailingPathDelimiter(S);
end;

function WideIncludeTrailingPathDelimiter(const S: WideString): WideString;
begin
  Result := S;
  if not WideIsPathDelimiter(Result, Length(Result)) then Result := Result + PathDelim;
end;

function WideIncludeTrailingBackslash(const S: WideString): WideString;
begin
  Result := WideIncludeTrailingPathDelimiter(S);
end;

function WideExtractFileExt(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := WideLastDelimiter('.\:', FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt) else
    Result := '';
end;

function Tnt_GetStringTypeExW(Locale: LCID; dwInfoType: DWORD;
  lpSrcStr: PWideChar; cchSrc: Integer; var lpCharType): BOOL; 
begin
  Result := GetStringTypeExW(Locale, dwInfoType, lpSrcStr, cchSrc, lpCharType)
end;

function _WideCharType(WC: WideChar; dwInfoType: Cardinal): Word;
begin
{$WARNINGS OFF}
  Win32Check(Tnt_GetStringTypeExW(GetThreadLocale, dwInfoType, PWideChar(@WC), 1, Result))
{$WARNINGS ON}
end;

function IsWideCharSpace(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_SPACE) <> 0;
end;

function IsWideCharPunct(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_PUNCT) <> 0;
end;

function Tnt_CharUpperBuffW(lpsz: PWideChar; cchLength: DWORD): DWORD;
begin
  Result := CharUpperBuffW(lpsz, cchLength)
end;

function Tnt_WideUpperCase(const S: WideString): WideString;
begin
  Result := S;
  if Length(Result) > 0 then
    Tnt_CharUpperBuffW(PWideChar(Result), Length(Result));
end;

function WideLastChar(const S: WideString): PWideChar;
begin
  if S = '' then
    Result := nil
  else
    Result := @S[Length(S)];
end;

function TntWideLastChar(const S: WideString): WideChar;
var
  P: PWideChar;
begin
  P := WideLastChar(S);
  if P = nil then
    Result := #0
  else
    Result := P^;
end;

function Tnt_WideStringReplace(const S, OldPattern, NewPattern: WideString;
  Flags: TReplaceFlags; WholeWord: Boolean = False): WideString;

  function IsWordSeparator(WC: WideChar): Boolean;
  begin
    Result := (WC = WideChar(#0))
           or IsWideCharSpace(WC)
           or IsWideCharPunct(WC);
  end;

var
  SearchStr, Patt, NewStr: WideString;
  Offset: Integer;
  PrevChar, NextChar: WideChar;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := Tnt_WideUpperCase(S);
    Patt := Tnt_WideUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end; // done

    if (WholeWord) then
    begin
      if (Offset = 1) then
        PrevChar := TntWideLastChar(Result)
      else
        PrevChar := NewStr[Offset - 1];

      if Offset + Length(OldPattern) <= Length(NewStr) then
        NextChar := NewStr[Offset + Length(OldPattern)]
      else
        NextChar := WideChar(#0);

      if (not IsWordSeparator(PrevChar))
      or (not IsWordSeparator(NextChar)) then
      begin
        Result := Result + Copy(NewStr, 1, Offset + Length(OldPattern) - 1);
        NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
        SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
        continue;
      end;
    end;

    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function WideFileExists(const Name: WideString): Boolean;
var
  Handle: THandle;
  FindData: TWin32FindDataW;
begin
  Result := False;
  Handle := FindFirstFileW(PWideChar(Name), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      Result := True;
  end;
end;

function WideDeleteFile(const FileName: WideString): Boolean;
begin
  Result := DeleteFileW(PWideChar(FileName))
end;

function WideExtractFilePath(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := WideLastDelimiter('\:', FileName);
  Result := Copy(FileName, 1, I);
end;

function WideFileGetAttr(const FileName: WideString): Cardinal;
begin
  Result := GetFileAttributesW(PWideChar(FileName));
end;

function WideFileSetAttr(const FileName: WideString; Attr: Integer): Boolean;
begin
  Result := SetFileAttributesW(PWideChar(FileName), Attr);
end;

const
  INVALID_FILE_ATTRIBUTES = DWORD(-1);
  
function WideDirectoryExists(const Name: WideString): Boolean;
var
  Code: Cardinal;
begin
  Code := WideFileGetAttr(Name);
  Result := (Code <> INVALID_FILE_ATTRIBUTES) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function WideForceDirectories(Dir: WideString): Boolean;
begin
  Result := True;
  if Length(Dir) = 0 then Exit;
  Dir := WideExcludeTrailingBackslash(Dir);
  if (Length(Dir) < 3) or WideDirectoryExists(Dir)
    or (WideExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  Result := WideForceDirectories(WideExtractFilePath(Dir));
  if Result then
    Result := CreateDirectoryW(PWideChar(Dir), nil)
end;

const
  fmCreate = $FFFF;

function WideCreateFile(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
    hTemplateFile: THandle): THandle;
begin
  Result := CreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes,
                        dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
end;

function WideFileCreate(const FileName: WideString): Integer;
begin
  Result := Integer(WideCreateFile(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
    0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0))
end;

function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := Integer(CreateFileW(PWideChar(FileName), AccessMode[Mode and 3],
    ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL, 0));
end;