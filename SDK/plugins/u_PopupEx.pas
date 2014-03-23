unit u_PopupEx;

interface

uses
 u_plugin_info, u_plugin_msg, u_common, u_lang_ids;


//PEX plugin SDK

{
usage:
SendMessageToPlugin(Target, CPEX_MSG_SHOWFADE, pPEXMsgLParam, Result)
}

const
	//default theme names:
	FadeID_Window: WideString = 'main';
	FadeID_Drag: WideString 	= 'drag';
	FadeID_Menu: WideString 	= 'menu';
	FadeID_Close: WideString 	= 'close';
	FadeID_Title: WideString	= 'title';
	FadeID_Text: WideString		= 'msg';
	FadeID_Btn1: WideString		= 'btn1';
	FadeID_Btn2: WideString		= 'btn2';
	FadeID_Btn3: WideString		= 'btn3';
	FadeID_Btn4: WideString		= 'btn4';
	FadeID_Btn5: WideString		= 'btn5';
	FadeID_Btn6: WideString		= 'btn6';
	FadeID_Btn7: WideString		= 'btn7';
	FadeID_Btn8: WideString		= 'btn8';
	FadeID_Btn9: WideString		= 'btn9';
	FadeID_Avatar: WideString	= 'avatar';

const
  CPEX_DLLNAME: WideString = 'popupex';
  CPEX_VERSION: WORD = 1;

  CPEX_RC_FALSE = 0;
  CPEX_RC_OK = -1;
  CPEX_RC_HANDLED = 2;

  //сообщения (PEX.SDK v.1)
  CPEX_MSG_TEST = 0;
  CPEX_MSG_SHOWFADE = 1;
  CPEX_MSG_HIDEFADE = 2;
  CPEX_MSG_MOUSEEVENT = 3;
  CPEX_MSG_FADECLOSED = 4;
  {CPEX_MSG_BEFORESHOW = 5;
  перед показом окна PEX рассылает всем включенным плагинам сообщение PM_PLUGIN_CORE_SVC_FADE
  с параметрами:
  	WParam is pFadeWndInfo
    Lparam is PEX.DllHandle - обязательно проверять через CPEX_MSG_TEST перед использованием NParam
    NParam is pPEXShow
  в ответ он ждёт одну из слудующих констант:
  (этот способ позволяет использовать плагины, не поддерживающие работу с PEX)
  }
  	CPEX_RC_SHOW_DISABLE = 0;
  	CPEX_RC_SHOW_ALLOW = 1;
  	//CPEX_RC_SHOW_DELAY = 2;

	CPEX_FLAG_Sender_Interal = $0; //
	CPEX_FLAG_Sender_Plugin  = $2; //plugin must set this flag to get CPEX_MSG_MOUSEEVENT, CPEX_MSG_FADECLOSED etc.
	CPEX_FLAG_DataType_Empty   = $0;
	CPEX_FLAG_DataType_Msg     = $1;
	CPEX_FLAG_DataType_Chat    = $4;
	CPEX_FLAG_DataType_File    = $8;

type

	//CPEX_MSG_TEST: (plugin >> PEX) check PEX sdk 
  	//lParam.out is rcCode: CPEX_RC_OK (support) / CPEX_RC_FALSE (unsupport)
    //nParam.in is required version PEX sdk
  	//Result.out is native version of PEX sdk

	//CPEX_MSG_SHOWFADE: (plugin >> PEX) show fade
  	//lParam.out is rcCode: CPEX_RC_OK / CPEX_RC_FALSE 
    //nParam.in is pPEXShow
    //Result.out is FadeID (==PFadeData)
      TPEXShow = record
        QipFade: TFadeWndInfo; //PEX ignore FadeIcon

        //не используем интерфейсы по причине сложных связей Disable/Enable/Run/Stop
        CallbackDllHandle: Integer; //caller plugin handle (for OnClickEvent PEX >> plugin callback)
        ClientData: Integer; //used on fade click
        UseProtoHandle: Integer; //used for internal OpenTab and ClearEvent, can be "0"
        UseAccName: WideString;  //used for internal OpenTab and ClearEvent, can be ""
        AvatarImage: WideString; //filename, if == "" then QipFade.FadeType used
        Reserved: WideString;
        Flags: DWORD; //> CPEX_FLAG_
      end;
      pPEXShow = ^TPEXShow;

	//CPEX_MSG_HIDEFADE: (plugin >> PEX) hide fade
    //lParam.out is rcCode: CPEX_RC_OK / CPEX_RC_FALSE
    //nParam.in is pPEXHide
    //Result.out is nothing
      TPEXHide = record
      	FadeID: Integer;    //CPEX_MSG_SHOWFADE > Result
        CloseNow: LongBool; //immediately close or theme-like
      end;
      pPEXHide = ^TPEXHide;

  //CPEX_MSG_MOUSEEVENT (PEX >> plugin) OnMouse Event
    //lParam.out is rcCode: CPEX_RC_OK / CPEX_RC_FALSE
    //nParam.in is pPEXMouseEvent
    //Result.out - return CPEX_RC_HANDLED for disable default processing (except "drag")
    //             "drag" is internal process and it can't be disabled in runtime (theme only)
      TPEXMouseEvent = record
      	FadeID: Integer;        //CPEX_MSG_SHOWFADE > Result
        ClientData: Integer;    //CPEX_MSG_SHOWFADE > TPEXShow.ClientData
				wndID,                  //window.name + # (look at theme_xml.windows.<wndID>)
        itemID: WideString;     //control.name (look at theme_xml.windows.controls.<itemID>)
        												//if itemID=='' then is window.event, not item.event
        WM_MOUSE_MSG: Cardinal; //WM_LBUTTONDOWN, etc.
        IsDown: LongBool;       //button is down
      end;
      pPEXMouseEvent = ^TPEXMouseEvent;

  //CPEX_MSG_FADECLOSED (PEX >> plugin) Destroy fade window event
    //lParam.out is rcCode: CPEX_RC_OK / CPEX_RC_FALSE
    //nParam.in is pPEXClosed
    //Result.out - nothing
      TPEXClosed = record
      	FadeID: Integer;    //CPEX_MSG_SHOWFADE > Result
        Reserved: Integer; 
      end;
      pPEXClosed = ^TPEXClosed;


implementation

end.
