unit u_gr_ids;

interface

const
  {GRAPHICS RESOURCES IDS}
  GR_LOGO_QIP_INFIUM      =   1;
  GR_QIP_TRAY_ICON        =   2;
  GR_QIP_SYS_ICON         =   3;
  GR_QIP_CLOSE_ICON       =   4;
  GR_PREFS                =   5;
  GR_GENERAL              =   6;
  GR_CONTACT_LIST         =   7;
  GR_EVENTS               =   8;
  GR_MESSAGING            =   9;
  GR_HISTORY              =  10;
  GR_STATUS_MODE          =  11;
  GR_ANTI_SPAM            =  12;
  GR_SOUNDS               =  13;
  GR_LANGS                =  14;
  GR_SKINS                =  15;
  GR_HOT_KEYS             =  16;
  GR_IM_NETWORKS          =  17;
  GR_QIP_MENU_ICON        =  18;
  GR_CONNECTION           =  19;
  GR_PLUGINS              =  20;

  GR_QIP_MAIN_BTN         =  21;
  GR_ADD_FIND_BTN         =  22;
  GR_FIND_IN_CL_BTN       =  23;
  GR_USER_TOOL_SHOW_BTN   =  24;
  GR_CUST_ST_BTN          =  25;
  GR_SHOW_ONLINE          =  26;
  GR_SHOW_ALL             =  27;
  GR_SHOW_GROUPS          =  28;
  GR_HIDE_GROUPS          =  29;
  GR_SOUNDS_ON            =  30;
  GR_SOUNDS_OFF           =  31;
  GR_PRIV_LISTS           =  32;
  GR_HISTORY_TOOL         =  33;
  GR_PREFS_TOOL           =  34;
  GR_USER_DETAILS         =  35;

  GR_ST_ONLINE            =  36;
  GR_ST_FFC               =  37;
  GR_ST_AWAY              =  38;
  GR_ST_NA                =  39;
  GR_ST_OCCUPIED          =  40;
  GR_ST_DND               =  41;
  GR_ST_INVISIBLE         =  42;
  GR_ST_LUNCH             =  43;
  GR_ST_DEPRES            =  44;
  GR_ST_EVIL              =  45;
  GR_ST_ATHOME            =  46;
  GR_ST_ATWORK            =  47;
  GR_ST_OFFLINE           =  48;
  GR_ST_IFA               =  49;

  GR_ST_PRIV_VIS4ALL      =  50;
  GR_ST_PRIV_VIS4VIS      =  51;
  GR_ST_PRIV_VISNORM      =  52;
  GR_ST_PRIV_VIS4CL       =  53;
  GR_ST_PRIV_INVIS4ALL    =  54;

  GR_SWITCH_PROFILE       =  55;
  GR_SERVICE_MSGS         =  56;
  GR_CHANGE_PROF_PASS     =  57;

  GR_ST_CONNECTING        =  58;

//  GR_CL_ROOT_CLOSED       =  59;
//  GR_CL_ROOT_OPENED       =  60;
  GR_CL_GROUP_CLOSED      =  61;
  GR_CL_GROUP_OPENED      =  62;

  GR_ST_NIL               =  63;
  GR_DOCKING              =  64;

//  GR_CL_NIL_GROUP_CLOSED  =  65;
//  GR_CL_NIL_GROUP_OPENED  =  66;
//  GR_CL_OFFLINE_CLOSED    =  67;
//  GR_CL_OFFLINE_OPENED    =  68;
  GR_CL_BG                =  69;

  GR_FADE1_MSG_TITLE      =  70;
  GR_FADE1_MSG_CONT       =  71;
  GR_FADE2_MSG_TITLE      =  72;
  GR_FADE2_MSG_CONT       =  73;
  GR_FADE3_MSG_TITLE      =  74;
  GR_FADE3_MSG_CONT       =  75;

  GR_ICON_MSG             =  76;
  GR_ICON_INFO            =  77;
  GR_ICON_WARNING         =  78;

  GR_CL_NEED_AUTH         =  79;
  GR_CL_INVIS_LIST        =  80;
  GR_CL_VIS_LIST          =  81;
  GR_CL_IGN_LIST          =  82;
  GR_CL_BALLOON           =  83;
  GR_CL_MOBILE            =  84;
  GR_CL_NOTE              =  85;

  GR_EMPTY                =  86;

  GR_MSG_GREEN            =  87; //own messages icon
  GR_MSG_GREEN_ACK        =  88; //own msg delivered report ico
  GR_MSG_BLUE             =  89; //information msg ico
  GR_MSG_YELLOW           =  90; //msg received from another contacts
  GR_MSG_RED              =  91; //any service message icon

  GR_MSG_CLOSE            =  92;
  GR_MSG_SEND             =  93;
  GR_ARROW_DOWN           =  94;
  GR_MSG_QUOTE            =  95;
  GR_MSG_PREDEFINED       =  96;
  GR_MSG_CONTMENU         =  97;
  GR_MSG_ENTER            =  98;
  GR_MSG_TYPNOT           =  99;
  GR_MSG_SMILES           = 100;
  GR_MSG_TEXTCOLOR        = 101;
  GR_MSG_BGCOLOR          = 102;
  GR_SEND_FILE            = 103;
  GR_MSG_COMPACT          = 104;
  GR_MSG_CLOSE_TOOL       = 105;
  GR_MSG_TAB_FORM         = 106;
  GR_MSG_TAB_CLOSE        = 107;
  GR_MSG_BG_PIC           = 108;
  GR_MSG_BGE_PIC          = 109;
  GR_DOCK_LEFT            = 110;
  GR_DOCK_RIGHT           = 111;

  GR_EV_CHAT              = 112;
  GR_EV_FILE              = 113;
  GR_EV_URL               = 114;
  GR_EV_AUTH              = 115;
  GR_EV_ADDED             = 116;
  GR_EV_SERVER            = 117;
  GR_EV_WEB               = 118;
  GR_EV_CONTACTS          = 119;
  GR_EV_AUTO              = 120;
  GR_EV_EMAIL             = 121;

  GR_FIND                 = 122;
  GR_DELETE               = 123;
  GR_SAVE_AS              = 124;

  GR_HIST_BG_PIC          = 125;
  GR_XST_PIC_NO           = 126;

  GR_OPEN_ALL_GROUPS      = 127;
  GR_CLOSE_ALL_GROUPS     = 128;
  GR_CREATE_NEW_GROUP     = 129;
  GR_RENAME_GROUP         = 130;
  GR_DELETE_GROUP         = 131;
  GR_UNIQUE_SETTINGS      = 132;
  GR_COPY                 = 133;
  GR_RENAME_CONTACT       = 134;
  GR_DELETE_CONTACT       = 135;
  GR_ADD_TO_VISLIST       = 136;
  GR_ADD_TO_INVISLIST     = 137;
  GR_ADD_TO_IGNLIST       = 138;
  GR_ADD_CONTACT          = 139;
  GR_DELETE_SMALL         = 140;

  GR_SAVE_DETS            = 141;
  GR_REQUEST_DETS         = 142;

  GR_DETS_SUMMARY         = 143;
  GR_DETS_GENERAL         = 144;
  GR_DETS_HOME            = 145;
  GR_DETS_WORK            = 146;
  GR_DETS_PERSONAL        = 147;
  GR_DETS_ABOUT           = 148;
  GR_DEF_AVATAR           = 149;
  GR_SIGNS                = 150;

  GR_OPEN_SMALL           = 151;
  GR_PLAY_PREVIEW         = 152;
  GR_CLEAR                = 153;
  GR_SRCH_DETS            = 154;
  GR_SRCH_MSG             = 155;
  GR_SRCH_QIM             = 156;
  GR_SRCH_QIM_DONE        = 157;

  GR_CUT                  = 158;
  GR_PASTE                = 159;
  GR_MULTI_SEND           = 160;

  GR_FADE1_MSG_BG         = 161;
  GR_FADE2_MSG_BG         = 162;
  GR_FADE3_MSG_BG         = 163;

  GR_REMOVE_SELF          = 164;
  GR_ALLOW_ADD_ME         = 165;
  GR_RCVD_FILES           = 166;
  GR_FLOATING_CNT         = 167;
  GR_MOVE_CONTACT         = 168;

  GR_SEND_CHAT            = 169;
  GR_CHAT_BG_USERLIST     = 170;
  GR_CHAT_BG_DIALOGS      = 171;
  GR_CHAT_BG_EDITOR       = 172;

  GR_IMPORT               = 173;
  GR_ADD_ACCOUNT          = 174;
  GR_MAKE_CALL            = 175; //иконка только для КЛ
  GR_QUOTE_SITE           = 176;
  GR_MONEY                = 177;
  GR_MERGE_CONTACTS       = 178;
  GR_SEPARATE_CONTACTS    = 179;
  GR_PROGRESS_BLOCK       = 180;
  GR_ADDITIONAL           = 181;
  GR_CL_NOTE_EDIT         = 182;
  GR_OPEN_FOLDER          = 183;
  GR_IM_SETTINGS          = 184;

  GR_ST_META_ONLINE       = 185;
  GR_ST_META_OFFLINE      = 186;
  GR_ST_META_NIL          = 187;
  GR_ST_META_AWAY         = 188;
  GR_ST_META_INVISIBLE    = 189;
  GR_ST_META_OCCUPIED     = 190;
  GR_ST_META_DND          = 191;
  GR_ST_META_NA           = 192;
  GR_ST_META_LUNCH        = 193;
  GR_ST_META_FFC          = 194;
  GR_ST_META_DEPRES       = 195;
  GR_ST_META_EVIL         = 196;
  GR_ST_META_ATHOME       = 197;
  GR_ST_META_ATWORK       = 198;

  GR_USER_TYPING          = 199;
  GR_REG_WIZARD           = 200;

  GR_CL_NEED_AUTH_SMALL   = 201;
  GR_CL_INVIS_LIST_SMALL  = 202;
  GR_CL_VIS_LIST_SMALL    = 203;
  GR_CL_IGN_LIST_SMALL    = 204;

  GR_VISTA_CLOSE1         = 205;
  GR_VISTA_CLOSE2         = 206;
  GR_VISTA_CLOSE3         = 207;
  GR_VISTA_HIDE1          = 208;
  GR_VISTA_HIDE2          = 209;
  GR_VISTA_HIDE3          = 210;
  GR_VISTA_TOP1           = 211;
  GR_VISTA_TOP2           = 212;
  GR_VISTA_TOP3           = 213;

  GR_GTALK_MAIL           = 214;
  GR_MRA_MAIL             = 215;
  GR_QIP_MAIL             = 216;
  GR_SEND_SMS             = 217; //иконка только для КЛ
  GR_CALL                 = 218;
  GR_INVITE               = 219;
  GR_INVITE_OS            = 220;

  GR_MERGE_CONTACTS_WIZ   = 221;
  GR_AUTOMERGED           = 222;
  GR_SYNCWIZ              = 223;

  GR_SEVEN_THUMB_BG        = 224;
  GR_SEVEN_THUMB_AVATAR_BG = 225;
  GR_SEVEN_NEXT_TAB        = 226;
  GR_SEVEN_PREVOUS_TAB     = 227;

  GR_EXT_LINK              = 228;
  GR_BACK                  = 229;
  GR_RU_FLAG               = 230;
  GR_EN_FLAG               = 231;

  GR_SEND_FILE_QIP_RU      = 232;
  
  GR_VOICE_PEER_CALL       = 233;
  GR_VIDEO_PEER_CALL       = 234;

  GR_PREFS_VIDEO           = 235;
  GR_CAM_NON_AVAIL         = 236;

  GR_SERVICES_HIDE_PANEL   = 237;
  GR_SERVICES_SHOW_PANEL   = 238;
  GR_SERVICES_INVITE2      = 239;

  GR_VIDWIZ_SPEAKERS       = 240;
  GR_VIDWIZ_MIC            = 241;
  GR_VIDWIZ_WEBCAM         = 242;
  GR_VIDWIZ_SET_DONE       = 243;

  GR_SMS_FAILED            = 244;
  GR_SMS_ANSWER            = 245;
  GR_CLEARFILTER           = 246;
  GR_WEBCAM_CL             = 247; //иконка только для КЛ

  GR_FT_INCOMING           = 248;
  GR_FT_OUTGOING           = 249;
  GR_FT_FAILED             = 250;

  GR_COMBO_DROPDOWN        = 251;
  GR_SET_TOPIC             = 252;

  GR_BB_MORE               = 253;
  GR_BB_ALIGN_CENTER       = 254;
  GR_BB_ALIGN_FILL         = 255;
  GR_BB_ALIGN_LEFT         = 256;
  GR_BB_ALIGN_RIGHT        = 257;
  GR_BB_BOLD               = 258;
  GR_BB_BACKGROUND         = 259;
  GR_BB_BB_OFF             = 260;
  GR_BB_CODE               = 261;
  GR_BB_COLOR              = 262;
  GR_BB_E_MAIL             = 263;
  GR_BB_FONT               = 264;
  GR_BB_ITALIC             = 265;
  GR_BB_IMG                = 266;
  GR_BB_QUOTE              = 267;
  GR_BB_STRIKE             = 268;
  GR_BB_SIZE               = 269;
  GR_BB_SPOILER            = 270;
  GR_BB_SUB_TEXT           = 271;
  GR_BB_TABLE              = 272;
  GR_BB_UNDERLINE          = 273;
  GR_BB_UP_BB_TEXT         = 274;
  GR_BB_URL                = 275;
  GR_BB_DOTS_1             = 276;
  GR_BB_DOTS_2             = 277;
  GR_BB_DOTS_3             = 278;

  GR_BB_QUOTE_ICON         = 279;
  GR_EDIT                  = 280;
  GR_DM_STATUS_ERROR       = 281;
  GR_DM_STATUS_LOADING     = 282;

  GR_YOUTUBE_PLAY          = 283;
  GR_DM_STATUS_STARTPLAYER = 284;
  GR_DM_STATUS_OVERLAYZOOM = 285;

  GR_FADE2_BODY        = 290;
  GR_FADE2_CLOSE       = 291;
  GR_FADE2_CLOSE_HOT   = 292;
  GR_FADE2_CLOSE_DOWN  = 293;
  GR_FADE2_MSGS_COUNT  = 294;
  GR_FADE2_AVATAR_BACK = 295;

  GR_FADE2_INFO        = 300;
  GR_FADE2_WARNING     = 301;
  GR_FADE2_MAIL_QIP    = 302;
  GR_FADE2_MAIL_JABBER = 303;
  GR_FADE2_GMAIL       = 304;
  GR_FADE2_VOIP        = 305;
  GR_FADE2_MAILRU      = 306;
  GR_FADE2_ORKUT       = 307;
  GR_FADE2_PLUGIN      = 308;

  GR_FACEBOOK_LETTER   = 309;
  GR_FB_INVITE_BG      = 310;
  GR_FB_BTN_NORM       = 311;
  GR_FB_BTN_PRESSED    = 312;
  GR_FB_CALL           = 313;
  GR_FB_CHAT           = 314;
  GR_FB_VIDEO          = 315;
  GR_FB_WALL           = 316;
  GR_LOGIN_ANIMATION   = 317;
  GR_FB_BTN_CANCEL         = 318;
  GR_FB_BTN_CANCEL_PRESSED = 319;
  GR_FB_BTN_SEND           = 320;
  GR_FB_BTN_SEND_PRESSED   = 321;
  GR_FB_TEXT_BG            = 322;

  GR_CHAT_AVATAR         = 323;
  GR_NEWTABS_BG          = 324;
  GR_NEWTABS_1ST_ICON    = 325;
  GR_NEWTABS_2ND_ICON    = 326;
  GR_LOGPWD_DLG_TWITTER  = 327;
  GR_LOGPWD_DLG_FACEBOOK = 328;
  GR_NEW_TAB_CLOSE       = 329;

  GR_FB_TAB_PIC    = 330;
  GR_FB_TAB_NEG    = 331;
  GR_FB_TAB_OFF    = 332;
  GR_TWT_TAB_PIC   = 333;
  GR_TWT_TAB_NEG   = 334;
  GR_TWT_TAB_OFF   = 335;
  GR_JUICK_TAB_PIC = 336;
  GR_JUICK_TAB_NEG = 337;
  GR_JUICK_TAB_OFF = 338;
  GR_VK_TAB_PIC    = 339;
  GR_VK_TAB_NEG    = 340;
  GR_VK_TAB_OFF    = 341;

  GR_PINNED        = 342;
  GR_NOT_PINNED    = 343;

  GR_PROMAN_BG     = 344;
  GR_PROMAN_ANI    = 345;
  GR_MOBILE_LOGIN  = 346;

  GR_CALL_BIG      = 347;
  GR_CAM_BIG       = 348;
  GR_INVITE_BIG    = 349;
  GR_SMS_BIG       = 350;
  GR_LOGPWD_DLG_VK = 351;
  GR_DETS_BIG      = 352;

  GR_OGOROD_TAB_PIC = 353;
  GR_OGOROD_TAB_NEG = 354;
  GR_OGOROD_TAB_OFF = 355;

  GR_RADIO_BG       = 356;

  GR_PHONE_TYPE_HOME   = 357;
  GR_PHONE_TYPE_MOBILE = 358;
  GR_PHONE_TYPE_OTHER  = 359;
  GR_PHONE_TYPE_WORK   = 360;
  GR_PHONE_DEFAULT     = 361;

  GR_QIP_STORE      = 362;

  GR_CLBTN1_CALLS = 363;
  GR_CLBTN2_GAMES = 364;
  GR_CLBTN3_STORE = 365;

  GR_SVC_ICQ    = 366;
  GR_SVC_QIP    = 367;
  GR_SVC_FB     = 368;
  GR_SVC_TW     = 369;
  GR_SVC_VK     = 370;
  GR_SVC_MAIL   = 371;
  GR_SVC_MOBILE = 372;

  GR_LOGIN_PHONE = 373;
  GR_LOGIN_FB    = 374;
  GR_LOGIN_TW    = 375;
  GR_LOGIN_VK    = 376;
  GR_LOGIN_MORE  = 377;

  GR_CONTACT_BTN_PHONE = GR_MAKE_CALL;
  GR_CONTACT_BTN_SMS   = GR_SEND_SMS;
  GR_CONTACT_BTN_VIDEO = GR_WEBCAM_CL;
  GR_CONTACT_BTNHOT_PHONE = 378;
  GR_CONTACT_BTNHOT_SMS   = 379;
  GR_CONTACT_BTNHOT_VIDEO = 380;

  GR_CL_VIEW_SETTINGS = 381;
  GR_PROMAN_APPBTN = 382;

  GR_ST_GLOBAL_CONNECT    = 383; //green
  GR_ST_GLOBAL_DISCONNECT = 384;
  GR_ST_GLOBAL_CONNECTING = 385; //yellow

  GR_PROMAN_SMS_PROGRESS = 386;
  GR_CL_BIG_SMS          = 387;

  GR_GL_ST_ONLINE        = GR_ST_ONLINE;   //388;
  GR_GL_ST_INVISIBLE     = GR_ST_INVISIBLE;//389;
  GR_GL_ST_INVISFORALL   = GR_ST_IFA;      //390;
  GR_GL_ST_FFC           = GR_ST_FFC;      //391;
  GR_GL_ST_EVIL          = GR_ST_EVIL;     //392;
  GR_GL_ST_DEPRES        = GR_ST_DEPRES;   //393;
  GR_GL_ST_ATHOME        = GR_ST_ATHOME;   //394;
  GR_GL_ST_ATWORK        = GR_ST_ATWORK;   //395;
  GR_GL_ST_OCCUPIED      = GR_ST_OCCUPIED; //396;
  GR_GL_ST_DND           = GR_ST_DND;      //397;
  GR_GL_ST_LUNCH         = GR_ST_LUNCH;    //398;
  GR_GL_ST_AWAY          = GR_ST_AWAY;     //399;
  GR_GL_ST_NA            = GR_ST_NA;       //400;

  GR_PHONEBOOK           = 401;
  GR_LOGIN_PHONE_EN      = 402;
  GR_PHONE_CONTACT       = 403;

  GR_Q_ST_ONLINE        = GR_ST_ONLINE;     //404;
  GR_Q_ST_FFC           = GR_ST_FFC;        //405;
  GR_Q_ST_AWAY          = GR_ST_AWAY;       //406;
  GR_Q_ST_NA            = GR_ST_NA;         //407;
  GR_Q_ST_OCCUPIED      = GR_ST_OCCUPIED;   //408;
  GR_Q_ST_DND           = GR_ST_DND;        //409;
  GR_Q_ST_INVISIBLE     = GR_ST_INVISIBLE;  //410;
  GR_Q_ST_LUNCH         = GR_ST_LUNCH;      //411;
  GR_Q_ST_DEPRES        = GR_ST_DEPRES;     //412;
  GR_Q_ST_EVIL          = GR_ST_EVIL;       //413;
  GR_Q_ST_ATHOME        = GR_ST_ATHOME;     //414;
  GR_Q_ST_ATWORK        = GR_ST_ATWORK;     //415;
  GR_Q_ST_OFFLINE       = GR_ST_OFFLINE;    //416;
  GR_Q_ST_INVISFORALL   = GR_ST_IFA;        //417;
  GR_Q_ST_CONNECTING    = GR_ST_CONNECTING; //418;
  GR_Q_NOT_IN_LIST      = GR_ST_NIL;        //419;

  GR_PHONE_ASSIGN  = 420;
  GR_PHONE_ASSIGN2 = 421;

  GR_FEEDS_TAB_PIC      = 422;
  GR_FEEDS_TAB_NEG      = 423;
  GR_FEEDS_TAB_OFF      = 424;
  GR_FEEDS_TAB_MENUITEM = 425;

  GR_UPDATE        = 426;
  GR_SEARCHQIP     = 427;
  GR_FEED_SEARCH   = 428;

  GR_NF_WELCOME_BG = 429;
  GR_NF_WELCOME_FB = 430;
  GR_NF_WELCOME_TW = 431;
  GR_NF_WELCOME_VK = 432;
  GR_NF_EMPTY_ICON = 433;

implementation
end.
