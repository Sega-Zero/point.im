//this directive switches on debug info printing
{.$DEFINE LOGDEBUGINFO}

{$IFDEF LOGDEBUGINFO}
  //uncomment this line if you want to see low level information (messages parameter values)
  {$DEFINE LOGLOWLEVELINFO}
  //if you have GExperts  expert installed (http://gexperts.org), turn this directive on to use GDebug tool
  {$DEFINE GEXPERTSDEBUG}
{$ENDIF}

//if you don't use Forms unit - turn this directive on
{$DEFINE NOFORMS}

//if you don't use Graphics unit - turn this directive on
{.$DEFINE NOGRAPHICS}

//uncomment this if you want to use PopupEx fades (http://forum.qip.ru/showthread.php?t=23125)
{.$DEFINE USEPOPUPEX}
