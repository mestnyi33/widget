;/--------------------------------
;|
;| Debug WindowEvents
;| (c)HeX0R 2007
;|
;/--------------------------------

#PB_Debug_WindowEvent_PB  = $01
#PB_Debug_WindowEvent_API = $02
#PB_Debug_WindowEvent_ALL = $03

Procedure.s DEBUG_WindowEvent(a.l, Mode.l = #PB_Debug_WindowEvent_PB)
  Protected Result.s = "", Result2.s = ""
  
  If Mode & #PB_Debug_WindowEvent_API
    
    Select a
      Case 0
        Result = "#WM_NULL"
      Case 1
        Result = "#WM_CREATE"
      Case 2
        Result = "#WM_DESTROY"
      Case 3
        Result = "#WM_MOVE"
      Case 5
        Result = "#WM_SIZE"
      Case 6
        Result = "#WM_ACTIVATE"
      Case 7
        Result = "#WM_SETFOCUS"
      Case 8
        Result = "#WM_KILLFOCUS"
      Case 10
        Result = "#WM_ENABLE"
      Case 11
        Result = "#WM_SETREDRAW"
      Case 12
        Result = "#WM_SETTEXT"
      Case 13
        Result = "#WM_GETTEXT"
      Case 14
        Result = "#WM_GETTEXTLENGTH"
      Case 15
        Result = "#WM_PAINT"
      Case 16
        Result = "#WM_CLOSE"
      Case 17
        Result = "#WM_QUERYENDSESSION"
      Case 18
        Result = "#WM_QUIT"
      Case 19
        Result = "#WM_QUERYOPEN"
      Case 20
        Result = "#WM_ERASEBKGND"
      Case 21
        Result = "#WM_SYSCOLORCHANGE"
      Case 22
        Result = "#WM_ENDSESSION"
      Case 24
        Result = "#WM_SHOWWINDOW"
      Case 25
        Result = "#WM_CTLCOLOR"
      Case 26
        Result = "#WM_SETTINGCHANGE;#WM_WININICHANGE"
      Case 27
        Result = "#WM_DEVMODECHANGE"
      Case 28
        Result = "#WM_ACTIVATEAPP"
      Case 29
        Result = "#WM_FONTCHANGE"
      Case 30
        Result = "#WM_TIMECHANGE"
      Case 31
        Result = "#WM_CANCELMODE"
      Case 32
        Result = "#WM_SETCURSOR"
      Case 33
        Result = "#WM_MOUSEACTIVATE"
      Case 34
        Result = "#WM_CHILDACTIVATE"
      Case 35
        Result = "#WM_QUEUESYNC"
      Case 36
        Result = "#WM_GETMINMAXINFO"
      Case 38
        Result = "#WM_PAINTICON"
      Case 39
        Result = "#WM_ICONERASEBKGND"
      Case 40
        Result = "#WM_NEXTDLGCTL"
      Case 42
        Result = "#WM_SPOOLERSTATUS"
      Case 43
        Result = "#WM_DRAWITEM"
      Case 44
        Result = "#WM_MEASUREITEM"
      Case 45
        Result = "#WM_DELETEITEM"
      Case 46
        Result = "#WM_VKEYTOITEM"
      Case 47
        Result = "#WM_CHARTOITEM"
      Case 48
        Result = "#WM_SETFONT"
      Case 49
        Result = "#WM_GETFONT"
      Case 50
        Result = "#WM_SETHOTKEY"
      Case 51
        Result = "#WM_GETHOTKEY"
      Case 55
        Result = "#WM_QUERYDRAGICON"
      Case 57
        Result = "#WM_COMPAREITEM"
      Case 61
        Result = "#WM_GETOBJECT"
      Case 65
        Result = "#WM_COMPACTING"
      Case 66
        Result = "#WM_OTHERWINDOWCREATED"
      Case 67
        Result = "#WM_OTHERWINDOWDESTROYED"
      Case 68
        Result = "#WM_COMMNOTIFY"
      Case 70
        Result = "#WM_WINDOWPOSCHANGING"
      Case 71
        Result = "#WM_WINDOWPOSCHANGED"
      Case 72
        Result = "#WM_POWER"
      Case 74
        Result = "#WM_COPYDATA"
      Case 75
        Result = "#WM_CANCELJOURNAL"
      Case 78
        Result = "#WM_NOTIFY"
      Case 80
        Result = "#WM_INPUTLANGUAGECHANGEREQUEST;#WM_INPUTLANGCHANGEREQUEST"
      Case 81
        Result = "#WM_INPUTLANGCHANGE;#WM_INPUTLANGUAGECHANGE"
      Case 82
        Result = "#WM_TCARD"
      Case 83
        Result = "#WM_HELP"
      Case 84
        Result = "#WM_USERCHANGED"
      Case 85
        Result = "#WM_NOTIFYFORMAT"
      Case 123
        Result = "#WM_CONTEXTMENU"
      Case 124
        Result = "#WM_STYLECHANGING"
      Case 125
        Result = "#WM_STYLECHANGED"
      Case 126
        Result = "#WM_DISPLAYCHANGE"
      Case 127
        Result = "#WM_GETICON"
      Case 128
        Result = "#WM_SETICON"
      Case 129
        Result = "#WM_NCCREATE"
      Case 130
        Result = "#WM_NCDESTROY"
      Case 131
        Result = "#WM_NCCALCSIZE"
      Case 132
        Result = "#WM_NCHITTEST"
      Case 133
        Result = "#WM_NCPAINT"
      Case 134
        Result = "#WM_NCACTIVATE"
      Case 135
        Result = "#WM_GETDLGCODE"
      Case 136
        Result = "#WM_SYNCPAINT"
      Case 160
        Result = "#WM_NCMOUSEMOVE"
      Case 161
        Result = "#WM_NCLBUTTONDOWN"
      Case 162
        Result = "#WM_NCLBUTTONUP"
      Case 163
        Result = "#WM_NCLBUTTONDBLCLK"
      Case 164
        Result = "#WM_NCRBUTTONDOWN"
      Case 165
        Result = "#WM_NCRBUTTONUP"
      Case 166
        Result = "#WM_NCRBUTTONDBLCLK"
      Case 167
        Result = "#WM_NCMBUTTONDOWN"
      Case 168
        Result = "#WM_NCMBUTTONUP"
      Case 169
        Result = "#WM_NCMBUTTONDBLCLK"
      Case 171
        Result = "#WM_NCXBUTTONDOWN"
      Case 172
        Result = "#WM_NCXBUTTONUP"
      Case 173
        Result = "#WM_NCXBUTTONDBLCLK"
      Case 255
        Result = "#WM_INPUT"
      Case 256
        Result = "#WM_KEYFIRST;#WM_KEYDOWN"
      Case 257
        Result = "#WM_KEYUP"
      Case 258
        Result = "#WM_CHAR"
      Case 259
        Result = "#WM_DEADCHAR"
      Case 260
        Result = "#WM_SYSKEYDOWN"
      Case 261
        Result = "#WM_SYSKEYUP"
      Case 262
        Result = "#WM_SYSCHAR"
      Case 263
        Result = "#WM_SYSDEADCHAR"
      Case 264
        Result = "#WM_KEYLAST;#WM_CONVERTREQUESTEX"
      Case 265
        Result = "#WM_UNICHAR;#WM_WNT_CONVERTREQUESTEX"
      Case 266
        Result = "#WM_CONVERTREQUEST"
      Case 267
        Result = "#WM_CONVERTRESULT"
      Case 268
        Result = "#WM_INTERIM;#WM_IM_INFO"
      Case 269
        Result = "#WM_IME_STARTCOMPOSITION"
      Case 270
        Result = "#WM_IME_ENDCOMPOSITION"
      Case 271
        Result = "#WM_IME_KEYLAST;#WM_IME_COMPOSITION"
      Case 272
        Result = "#WM_INITDIALOG"
      Case 273
        Result = "#WM_COMMAND"
      Case 274
        Result = "#WM_SYSCOMMAND"
      Case 275
        Result = "#WM_TIMER"
      Case 276
        Result = "#WM_HSCROLL"
      Case 277
        Result = "#WM_VSCROLL"
      Case 278
        Result = "#WM_INITMENU"
      Case 279
        Result = "#WM_INITMENUPOPUP"
      Case 287
        Result = "#WM_MENUSELECT"
      Case 288
        Result = "#WM_MENUCHAR"
      Case 289
        Result = "#WM_ENTERIDLE"
      Case 290
        Result = "#WM_MENURBUTTONUP"
      Case 291
        Result = "#WM_MENUDRAG"
      Case 292
        Result = "#WM_MENUGETOBJECT"
      Case 293
        Result = "#WM_UNINITMENUPOPUP"
      Case 294
        Result = "#WM_MENUCOMMAND"
      Case 295
        Result = "#WM_CHANGEUISTATE"
      Case 296
        Result = "#WM_UPDATEUISTATE"
      Case 297
        Result = "#WM_QUERYUISTATE"
      Case 306
        Result = "#WM_CTLCOLORMSGBOX"
      Case 307
        Result = "#WM_CTLCOLOREDIT"
      Case 308
        Result = "#WM_CTLCOLORLISTBOX"
      Case 309
        Result = "#WM_CTLCOLORBTN"
      Case 310
        Result = "#WM_CTLCOLORDLG"
      Case 311
        Result = "#WM_CTLCOLORSCROLLBAR"
      Case 312
        Result = "#WM_CTLCOLORSTATIC"
      Case 512
        Result = "#WM_MOUSEFIRST;#WM_MOUSEMOVE"
      Case 513
        Result = "#WM_LBUTTONDOWN"
      Case 514
        Result = "#WM_LBUTTONUP"
      Case 515
        Result = "#WM_LBUTTONDBLCLK"
      Case 516
        Result = "#WM_RBUTTONDOWN"
      Case 517
        Result = "#WM_RBUTTONUP"
      Case 518
        Result = "#WM_RBUTTONDBLCLK"
      Case 519
        Result = "#WM_MBUTTONDOWN"
      Case 520
        Result = "#WM_MBUTTONUP"
      Case 521
        Result = "#WM_MBUTTONDBLCLK;#WM_MOUSELAST"
      Case 522
        Result = "#WM_MOUSEWHEEL"
      Case 523
        Result = "#WM_XBUTTONDOWN"
      Case 524
        Result = "#WM_XBUTTONUP"
      Case 525
        Result = "#WM_XBUTTONDBLCLK"
      Case 528
        Result = "#WM_PARENTNOTIFY"
      Case 529
        Result = "#WM_ENTERMENULOOP"
      Case 530
        Result = "#WM_EXITMENULOOP"
      Case 531
        Result = "#WM_NEXTMENU"
      Case 532
        Result = "#WM_SIZING"
      Case 533
        Result = "#WM_CAPTURECHANGED"
      Case 534
        Result = "#WM_MOVING"
      Case 536
        Result = "#WM_POWERBROADCAST"
      Case 537
        Result = "#WM_DEVICECHANGE"
      Case 544
        Result = "#WM_MDICREATE"
      Case 545
        Result = "#WM_MDIDESTROY"
      Case 546
        Result = "#WM_MDIACTIVATE"
      Case 547
        Result = "#WM_MDIRESTORE"
      Case 548
        Result = "#WM_MDINEXT"
      Case 549
        Result = "#WM_MDIMAXIMIZE"
      Case 550
        Result = "#WM_MDITILE"
      Case 551
        Result = "#WM_MDICASCADE"
      Case 552
        Result = "#WM_MDIICONARRANGE"
      Case 553
        Result = "#WM_MDIGETACTIVE"
      Case 560
        Result = "#WM_MDISETMENU"
      Case 561
        Result = "#WM_ENTERSIZEMOVE"
      Case 562
        Result = "#WM_EXITSIZEMOVE"
      Case 563
        Result = "#WM_DROPFILES"
      Case 564
        Result = "#WM_MDIREFRESHMENU"
      Case 640
        Result = "#WM_IME_REPORT"
      Case 641
        Result = "#WM_IME_SETCONTEXT"
      Case 642
        Result = "#WM_IME_NOTIFY"
      Case 643
        Result = "#WM_IME_CONTROL"
      Case 644
        Result = "#WM_IME_COMPOSITIONFULL"
      Case 645
        Result = "#WM_IME_SELECT"
      Case 646
        Result = "#WM_IME_CHAR"
      Case 647
        Result = "#WM_IME_SYSTEM"
      Case 648
        Result = "#WM_IME_REQUEST"
      Case 656
        Result = "#WM_IMEKEYDOWN;#WM_IME_KEYDOWN"
      Case 657
        Result = "#WM_IME_KEYUP;#WM_IMEKEYUP"
      Case 672
        Result = "#WM_NCMOUSEHOVER"
      Case 673
        Result = "#WM_MOUSEHOVER"
      Case 674
        Result = "#WM_NCMOUSELEAVE"
      Case 675
        Result = "#WM_MOUSELEAVE"
      Case 689
        Result = "#WM_WTSSESSION_CHANGE"
      Case 704
        Result = "#WM_TABLET_FIRST"
      Case 735
        Result = "#WM_TABLET_LAST"
      Case 768
        Result = "#WM_CUT"
      Case 769
        Result = "#WM_COPY"
      Case 770
        Result = "#WM_PASTE"
      Case 771
        Result = "#WM_CLEAR"
      Case 772
        Result = "#WM_UNDO"
      Case 773
        Result = "#WM_RENDERFORMAT"
      Case 774
        Result = "#WM_RENDERALLFORMATS"
      Case 775
        Result = "#WM_DESTROYCLIPBOARD"
      Case 776
        Result = "#WM_DRAWCLIPBOARD"
      Case 777
        Result = "#WM_PAINTCLIPBOARD"
      Case 778
        Result = "#WM_VSCROLLCLIPBOARD"
      Case 779
        Result = "#WM_SIZECLIPBOARD"
      Case 780
        Result = "#WM_ASKCBFORMATNAME"
      Case 781
        Result = "#WM_CHANGECBCHAIN"
      Case 782
        Result = "#WM_HSCROLLCLIPBOARD"
      Case 783
        Result = "#WM_QUERYNEWPALETTE"
      Case 784
        Result = "#WM_PALETTEISCHANGING"
      Case 785
        Result = "#WM_PALETTECHANGED"
      Case 786
        Result = "#WM_HOTKEY"
      Case 791
        Result = "#WM_PRINT"
      Case 792
        Result = "#WM_PRINTCLIENT"
      Case 793
        Result = "#WM_APPCOMMAND"
      Case 794
        Result = "#WM_THEMECHANGED"
      Case 856
        Result = "#WM_HANDHELDFIRST"
      Case 863
        Result = "#WM_HANDHELDLAST"
      Case 864
        Result = "#WM_AFXFIRST"
      Case 895
        Result = "#WM_AFXLAST;#WM_FORWARDMSG"
      Case 896
        Result = "#WM_PENWINFIRST"
      Case 911
        Result = "#WM_PENWINLAST"
      Case 992
        Result = "#WM_DDE_FIRST;#WM_DDE_INITIATE"
      Case 993
        Result = "#WM_DDE_TERMINATE"
      Case 994
        Result = "#WM_DDE_ADVISE"
      Case 995
        Result = "#WM_DDE_UNADVISE"
      Case 996
        Result = "#WM_DDE_ACK"
      Case 997
        Result = "#WM_DDE_DATA"
      Case 998
        Result = "#WM_DDE_REQUEST"
      Case 999
        Result = "#WM_DDE_POKE"
      Case 1000
        Result = "#WM_DDE_LAST;#WM_DDE_EXECUTE"
      Case 1021
        Result = "#WM_DBNOTIFICATION"
      Case 1022
        Result = "#WM_NETCONNECT"
      Case 1023
        Result = "#WM_HIBERNATE"
      Case 1024
        Result = "#WM_CAP_START;#WM_PSD_PAGESETUPDLG;#WM_USER"
      Case 1025
        Result = "#WM_CAP_GET_CAPSTREAMPTR;#WM_PSD_FULLPAGERECT;#WM_CHOOSEFONT_GETLOGFONT"
      Case 1026
        Result = "#WM_CAP_SET_CALLBACK_ERRORA;#WM_PSD_MINMARGINRECT"
      Case 1027
        Result = "#WM_CAP_SET_CALLBACK_STATUSA;#WM_PSD_MARGINRECT"
      Case 1028
        Result = "#WM_PSD_GREEKTEXTRECT;#WM_CAP_SET_CALLBACK_YIELD"
      Case 1029
        Result = "#WM_PSD_ENVSTAMPRECT;#WM_CAP_SET_CALLBACK_FRAME"
      Case 1030
        Result = "#WM_CAP_SET_CALLBACK_VIDEOSTREAM;#WM_PSD_YAFULLPAGERECT"
      Case 1031
        Result = "#WM_CAP_SET_CALLBACK_WAVESTREAM"
      Case 1032
        Result = "#WM_CAP_GET_USER_DATA"
      Case 1033
        Result = "#WM_CAP_SET_USER_DATA"
      Case 1034
        Result = "#WM_CAP_DRIVER_CONNECT"
      Case 1035
        Result = "#WM_CAP_DRIVER_DISCONNECT"
      Case 1036
        Result = "#WM_CAP_DRIVER_GET_NAMEA"
      Case 1037
        Result = "#WM_CAP_DRIVER_GET_VERSIONA"
      Case 1038
        Result = "#WM_CAP_DRIVER_GET_CAPS"
      Case 1044
        Result = "#WM_CAP_FILE_SET_CAPTURE_FILEA"
      Case 1045
        Result = "#WM_CAP_FILE_GET_CAPTURE_FILEA"
      Case 1046
        Result = "#WM_CAP_FILE_ALLOCATE"
      Case 1047
        Result = "#WM_CAP_FILE_SAVEASA"
      Case 1048
        Result = "#WM_CAP_FILE_SET_INFOCHUNK"
      Case 1049
        Result = "#WM_CAP_FILE_SAVEDIBA"
      Case 1054
        Result = "#WM_CAP_EDIT_COPY"
      Case 1059
        Result = "#WM_CAP_SET_AUDIOFORMAT"
      Case 1060
        Result = "#WM_CAP_GET_AUDIOFORMAT"
      Case 1065
        Result = "#WM_CAP_DLG_VIDEOFORMAT"
      Case 1066
        Result = "#WM_CAP_DLG_VIDEOSOURCE"
      Case 1067
        Result = "#WM_CAP_DLG_VIDEODISPLAY"
      Case 1068
        Result = "#WM_CAP_GET_VIDEOFORMAT"
      Case 1069
        Result = "#WM_CAP_SET_VIDEOFORMAT"
      Case 1070
        Result = "#WM_CAP_DLG_VIDEOCOMPRESSION"
      Case 1074
        Result = "#WM_CAP_SET_PREVIEW"
      Case 1075
        Result = "#WM_CAP_SET_OVERLAY"
      Case 1076
        Result = "#WM_CAP_SET_PREVIEWRATE"
      Case 1077
        Result = "#WM_CAP_SET_SCALE"
      Case 1078
        Result = "#WM_CAP_GET_STATUS"
      Case 1079
        Result = "#WM_CAP_SET_SCROLL"
      Case 1084
        Result = "#WM_CAP_GRAB_FRAME"
      Case 1085
        Result = "#WM_CAP_GRAB_FRAME_NOSTOP"
      Case 1086
        Result = "#WM_CAP_SEQUENCE"
      Case 1087
        Result = "#WM_CAP_SEQUENCE_NOFILE"
      Case 1088
        Result = "#WM_CAP_SET_SEQUENCE_SETUP"
      Case 1089
        Result = "#WM_CAP_GET_SEQUENCE_SETUP"
      Case 1090
        Result = "#WM_CAP_SET_MCI_DEVICEA"
      Case 1091
        Result = "#WM_CAP_GET_MCI_DEVICEA"
      Case 1092
        Result = "#WM_CAP_STOP"
      Case 1093
        Result = "#WM_CAP_ABORT"
      Case 1094
        Result = "#WM_CAP_SINGLE_FRAME_OPEN"
      Case 1095
        Result = "#WM_CAP_SINGLE_FRAME_CLOSE"
      Case 1096
        Result = "#WM_CAP_SINGLE_FRAME"
      Case 1104
        Result = "#WM_CAP_PAL_OPENA"
      Case 1105
        Result = "#WM_CAP_PAL_SAVEA"
      Case 1106
        Result = "#WM_CAP_PAL_PASTE"
      Case 1107
        Result = "#WM_CAP_PAL_AUTOCREATE"
      Case 1108
        Result = "#WM_CAP_PAL_MANUALCREATE"
      Case 1109
        Result = "#WM_CAP_SET_CALLBACK_CAPCONTROL"
      Case 1124
        Result = "#WM_CAP_UNICODE_START"
      Case 1125
        Result = "#WM_CHOOSEFONT_SETLOGFONT"
      Case 1126
        Result = "#WM_CAP_SET_CALLBACK_ERRORW;#WM_CHOOSEFONT_SETFLAGS"
      Case 1127
        Result = "#WM_CAP_SET_CALLBACK_STATUSW"
      Case 1136
        Result = "#WM_CAP_DRIVER_GET_NAMEW"
      Case 1137
        Result = "#WM_CAP_DRIVER_GET_VERSIONW"
      Case 1144
        Result = "#WM_CAP_FILE_SET_CAPTURE_FILEW"
      Case 1145
        Result = "#WM_CAP_FILE_GET_CAPTURE_FILEW"
      Case 1147
        Result = "#WM_CAP_FILE_SAVEASW"
      Case 1149
        Result = "#WM_CAP_FILE_SAVEDIBW"
      Case 1190
        Result = "#WM_CAP_SET_MCI_DEVICEW"
      Case 1191
        Result = "#WM_CAP_GET_MCI_DEVICEW"
      Case 1204
        Result = "#WM_CAP_PAL_OPENW"
      Case 1205
        Result = "#WM_CAP_UNICODE_END;#WM_CAP_PAL_SAVEW;#WM_CAP_END"
      Case 2024
        Result = "#WM_CPL_LAUNCH"
      Case 2025
        Result = "#WM_CPL_LAUNCHED"
      Case 2125
        Result = "#WM_ADSPROP_NOTIFY_PAGEINIT"
      Case 2126
        Result = "#WM_ADSPROP_NOTIFY_PAGEHWND"
      Case 2127
        Result = "#WM_ADSPROP_NOTIFY_CHANGE"
      Case 2128
        Result = "#WM_ADSPROP_NOTIFY_APPLY"
      Case 2129
        Result = "#WM_ADSPROP_NOTIFY_SETFOCUS"
      Case 2130
        Result = "#WM_ADSPROP_NOTIFY_FOREGROUND"
      Case 2131
        Result = "#WM_ADSPROP_NOTIFY_EXIT"
      Case 2134
        Result = "#WM_ADSPROP_NOTIFY_ERROR"
      Case 2135
        Result = "#WM_ADSPROP_NOTIFY_SHOW_ERROR_DIALOG"
      Case 30296
        Result = "#WM_NOTIFYICON"
      Case 32768
        Result = "#WM_APP"
      Case 52429
        Result = "#WM_RASDIALEVENT"
    EndSelect
    
  EndIf
  
  If Mode & #PB_Debug_WindowEvent_PB
    
    Select a
      Case 1
        Result2 = "#PB_Event_ClientConnected"
      Case 2
        Result2 = "#PB_Event_DataReceived"
      Case 3
        Result2 = "#PB_Event_MoveWindow;#PB_Event_FileReceived"
      Case 4
        Result2 = "#PB_Event_ClientDisconnected"
      Case 5
        Result2 = "#PB_Event_SizeWindow"
      Case 15
        Result2 = "#PB_Event_Repaint"
      Case 16
        Result2 = "#PB_Event_CloseWindow"
      Case 13100
        Result2 = "#PB_Event_Gadget"
      Case 13101
        Result2 = "#PB_Event_Menu"
      Case 13102
        Result2 = "#PB_Event_SysTray"
      Case 13104
        Result2 = "#PB_Event_ActivateWindow"
      Case 13105
        Result2 = "#PB_Event_WindowDrop"
      Case 13106
        Result2 = "#PB_Event_GadgetDrop"
    EndSelect
    
  EndIf
  
  If Result And Result2
    Result + ";" + Result2
  ElseIf Result2
    Result = Result2
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.s DEBUG_EventType(a.l)
  Protected Result.s
  
  Select a
    Case 0 : Result = "#PB_EventType_LeftClick"
    Case 1 : Result = "#PB_EventType_TitleChange;#PB_EventType_RightClick"
    Case 2 : Result = "#PB_EventType_StatusChange;#PB_EventType_LeftDoubleClick"
    Case 3 : Result = "#PB_EventType_RightDoubleClick;#PB_EventType_PopupWindow"
    Case 4 : Result = "#PB_EventType_DownloadStart"
    Case 5 : Result = "#PB_EventType_DownloadProgress"
    Case 6 : Result = "#PB_EventType_DownloadEnd;#PB_EventType_Resize"
    Case 7 : Result = "#PB_EventType_PopupMenu"
    Case 768 : Result = "#PB_EventType_Change"
    Case 1281 : Result = "#PB_EventType_ReturnKey"
    Case 14000 : Result = "#PB_EventType_Focus"
    Case 14001 : Result = "#PB_EventType_LostFocus"
    Case 14002 : Result = "#PB_EventType_DragStart"
    Case 65534 : Result = "#PB_EventType_SizeItem"
    Case 65535 : Result = "#PB_EventType_CloseItem"
    Case 65537 : Result = "#PB_EventType_MouseEnter"
    Case 65538 : Result = "#PB_EventType_MouseLeave"
    Case 65539 : Result = "#PB_EventType_MouseMove"
    Case 65540 : Result = "#PB_EventType_LeftButtonDown"
    Case 65541 : Result = "#PB_EventType_LeftButtonUp"
    Case 65542 : Result = "#PB_EventType_RightButtonDown"
    Case 65543 : Result = "#PB_EventType_RightButtonUp"
    Case 65544 : Result = "#PB_EventType_MiddleButtonDown"
    Case 65545 : Result = "#PB_EventType_MiddleButtonUp"
    Case 65546 : Result = "#PB_EventType_MouseWheel"
    Case 65547 : Result = "#PB_EventType_KeyDown"
    Case 65548 : Result = "#PB_EventType_KeyUp"
    Case 65549 : Result = "#PB_EventType_Input"
  EndSelect
  
  ProcedureReturn Result
EndProcedure
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 8-
; EnableXP