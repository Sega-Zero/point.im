{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 17.0}
    {$DEFINE DIAMONDBACK_UP}
  {$IFEND}
  {$IF CompilerVersion >= 18.0}
    {$DEFINE DIAMONDBACK_UP}
    {$DEFINE DEXTER_UP}
  {$IFEND}
  {$IF CompilerVersion >= 19.0}
    {$DEFINE DIAMONDBACK_UP}
    {$DEFINE DEXTER_UP}
    {$DEFINE HIGHLANDER_UP}
  {$IFEND}
{$ENDIF}

{$IFDEF HIGHLANDER_UP}
  {$DEFINE CONST_XS_TO_NATIVE}
  {$DEFINE CONST_WIDESTRING_PARAMS}
{$ENDIF}
//  {$DEFINE CONST_XS_TO_NATIVE}
//  {$DEFINE CONST_WIDESTRING_PARAMS}

