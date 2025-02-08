; https://www.rsbasic.de/winapi-library/

EnableExplicit
IncludePath "../"
XIncludeFile "id.pbi"
XIncludeFile "clipgadgets.pbi"

Macro ClassName( windowID )
   ID::ClassName( windowID )
EndMacro

Macro __CloseWindow( windowID )
  DestroyWindow_( windowID )
EndMacro

Procedure __SetActiveWindow( win )
EndProcedure


Procedure __HideWindow( win, state )
   If ClassName( win ) = "PBWindow"
   Else
   EndIf
EndProcedure

Procedure __IsHideWindow( win )
   If ClassName( win ) = "PBWindow"
   Else
   EndIf
EndProcedure

Procedure __IsActiveWindow( win )
EndProcedure

Procedure __IsMainWindow( win )
EndProcedure

Procedure SetWindowColor_(windowID, Color)
  Protected brush
  brush = CreateSolidBrush_(Color)
  ; brush = CreatePatternBrush_(ImageID)
  
  SetClassLongPtr_(windowID, #GCL_HBRBACKGROUND, brush)
  DeleteObject_(brush)
EndProcedure

Procedure Callback(WindowID,Message,wParam,lParam)
  Protected Text$
  Protected Result = #PB_ProcessPureBasicEvents
  
  Select Message
    Case #DM_GETDEFID : Text$ = "DM_GetDefID"
    Case #DM_SETDEFID : Text$ = "DM_SetDefID"
    Case #WM_ACTIVATE : Text$ = "Activate"
    Case #WM_ACTIVATEAPP : Text$ = "ActivateApp"
    Case #WM_ASKCBFORMATNAME : Text$ = "AskCbFormatName"
    Case #WM_CANCELJOURNAL : Text$ = "CancelJournal"
    Case #WM_CANCELMODE : Text$ = "CancelMode"
    Case #WM_CAPTURECHANGED : Text$ = "CaptureChanged"
    Case #WM_CHANGECBCHAIN : Text$ = "ChangeCbChain"
    Case #WM_CHAR : Text$ = "Char"
    Case #WM_CHILDACTIVATE : Text$ = "ChildActivate"
    Case #WM_CLEAR : Text$ = "Clear"
    Case #WM_CLOSE : Text$ = "Close"
    Case #WM_COMMAND : Text$ = "Command"
    Case #WM_COMPACTING : Text$ = "Compacting"
    Case #WM_CONTEXTMENU : Text$ = "ContextMenu"
    Case #WM_COPY : Text$ = "Copy"
    Case #WM_COPYDATA : Text$ = "CopyData"
    Case #WM_CREATE : Text$ = "Create"
    Case #WM_CTLCOLORDLG : Text$ = "CtlColorDlg"
    Case #WM_CTLCOLORMSGBOX : Text$ = "CtlColorMsgBox"
    Case #WM_CUT : Text$ = "Cut"
    Case #WM_DEADCHAR : Text$ = "DeadChar"
    Case #WM_DESTROY : Text$ = "Destroy"
    Case #WM_DESTROYCLIPBOARD : Text$ = "DestroyClipboard"
    Case #WM_DISPLAYCHANGE : Text$ = "DisplayChange"
    Case #WM_DRAWCLIPBOARD : Text$ = "DrawClipboard"
    Case #WM_DRAWITEM : Text$ = "DrawItem"
    Case #WM_ENABLE : Text$ = "Enable"
    Case #WM_ENTERIDLE : Text$ = "EnterIdle"
    Case #WM_ENTERMENULOOP : Text$ = "EnterMenuLoop"
    Case #WM_ENTERSIZEMOVE : Text$ = "EnterSizeMove"
    Case #WM_ERASEBKGND : Text$ = "EraseBkgnd"
    Case #WM_EXITMENULOOP : Text$ = "ExitMenuLoop"
    Case #WM_EXITSIZEMOVE : Text$ = "ExitSizeMove"
    Case #WM_GETDLGCODE : Text$ = "GetDlgCode"
    Case #WM_GETHOTKEY : Text$ = "GetHotKey"
    Case #WM_GETICON : Text$ = "GetIcon"
    Case #WM_GETMINMAXINFO : Text$ = "GetMinMaxInfo"
    Case #WM_GETTEXT : Text$ = "GetText"
    Case #WM_GETTEXTLENGTH : Text$ = "GetTextLength"
    Case #WM_HOTKEY : Text$ = "HotKey"
    Case #WM_HSCROLLCLIPBOARD : Text$ = "HScrollClipboard"
    Case #WM_ICONERASEBKGND : Text$ = "IconEraseBkgnd"
    Case #WM_INITDIALOG : Text$ = "InitDialog"
    Case #WM_INITMENU : Text$ = "InitMenu"
    Case #WM_INITMENUPOPUP : Text$ = "InitMenuPopup"
    Case #WM_INPUTLANGCHANGE : Text$ = "InputLangChange"
    Case #WM_INPUTLANGCHANGEREQUEST : Text$ = "InputLangChangeRequest"
    Case #WM_KEYDOWN : Text$ = "KeyDown"
    Case #WM_KEYUP : Text$ = "KeyUp"
    Case #WM_KILLFOCUS : Text$ = "KillFocus"
    Case #WM_LBUTTONDBLCLK : Text$ = "LButtonDBlclk"
    Case #WM_LBUTTONDOWN : Text$ = "LButtonDown"
    Case #WM_LBUTTONUP : Text$ = "LButtonUp"
    Case #WM_LBUTTONDBLCLK : Text$ = "LButtonDBlclk"
    Case #WM_MBUTTONDOWN : Text$ = "MButtonDown"
    Case #WM_MBUTTONUP : Text$ = "MButtonUp"
    Case #WM_MEASUREITEM : Text$ = "MeasureItem"
    Case #WM_MENUCHAR : Text$ = "MenuChar"
    Case #WM_MENUSELECT : Text$ = "MenuSelect"
    Case #WM_MOUSEACTIVATE : Text$ = "MouseActivate"
    Case #WM_MOUSEMOVE : Text$ = "MouseMove"
    Case #WM_MOUSEWHEEL : Text$ = "MouseWheel"
    Case #WM_MOVE : Text$ = "Move"
    Case #WM_MOVING : Text$ = "Moving"
    Case #WM_NCACTIVATE : Text$ = "NcActivate"
    Case #WM_NCCALCSIZE : Text$ = "NcCalcSize"
    Case #WM_NCCREATE : Text$ = "NcCreate"
    Case #WM_NCDESTROY : Text$ = "NcDestroy"
    Case #WM_NCHITTEST : Text$ = "NCHITTEST"
    Case #WM_NCLBUTTONDBLCLK : Text$ = "NCLButtonDBlclk"
    Case #WM_NCLBUTTONDOWN : Text$ = "NCLButtonDown"
    Case #WM_NCLBUTTONUP : Text$ = "NCLButtonUp"
    Case #WM_NCMBUTTONDBLCLK : Text$ = "NCMButtonDBlclk"
    Case #WM_NCMBUTTONDOWN : Text$ = "NCMButtonDown"
    Case #WM_NCMBUTTONUP : Text$ = "NCMButtonUp"
    Case #WM_NCMOUSEMOVE : Text$ = "NCMouseMove"
    Case #WM_NCPAINT : Text$ = "NCPaint"
    Case #WM_NCRBUTTONDBLCLK : Text$ = "NCRButtonDBlclk"
    Case #WM_NCRBUTTONDOWN : Text$ = "NCRButtonDown"
    Case #WM_NCRBUTTONUP : Text$ = "NCRButtonUp"
    Case #WM_NEXTDLGCTL : Text$ = "NextDlgCtl"
    Case #WM_NOTIFY : Text$ = "Notify"
    Case #WM_NOTIFYFORMAT : Text$ = "NotifyFormat"
    Case #WM_PAINT : Text$ = "Paint"
    Case #WM_PAINTCLIPBOARD : Text$ = "PaintClipboard"
    Case #WM_PAINTICON : Text$ = "PaintIcon"
    Case #WM_PARENTNOTIFY : Text$ = "ParentNotify"
    Case #WM_PASTE : Text$ = "Paste"
    Case #WM_POWER : Text$ = "Power"
    Case #WM_PRINT : Text$ = "Print"
    Case #WM_PRINTCLIENT : Text$ = "PrintClient"
    Case #WM_QUERYDRAGICON : Text$ = "QueryDragIcon"
    Case #WM_QUERYOPEN : Text$ = "QueryOpen"
    Case #WM_QUEUESYNC : Text$ = "QueueSync"
    Case #WM_QUIT : Text$ = "Quit"
    Case #WM_RENDERALLFORMATS : Text$ = "RenderAllFormats"
    Case #WM_RENDERFORMAT : Text$ = "RenderFormat"
    Case #WM_RBUTTONDBLCLK : Text$ = "RButtonDBlclk"
    Case #WM_RBUTTONDOWN : Text$ = "RButtonDown"
    Case #WM_RBUTTONUP : Text$ = "RButtonUp"
    Case #WM_SETCURSOR : Text$ = "SetCursor"
    Case #WM_SETFOCUS : Text$ = "SetFocus"
    Case #WM_SETHOTKEY : Text$ = "SetHotKey"
    Case #WM_SETICON : Text$ = "SetIcon"
    Case #WM_SETREDRAW : Text$ = "SetRedraw"
    Case #WM_SETTEXT : Text$ = "SetText"
    Case #WM_SETTINGCHANGE : Text$ = "SettingChange"
    Case #WM_SHOWWINDOW : Text$ = "ShowWindow"
    Case #WM_SIZE : Text$ = "Size"
    Case #WM_SIZECLIPBOARD : Text$ = "SizeClipboard"
    Case #WM_SIZING : Text$ = "Sizing"
    Case #WM_STYLECHANGED : Text$ = "StyleChanged"
    Case #WM_STYLECHANGING : Text$ = "StyleChanging"
    Case #WM_SYSCHAR : Text$ = "SysChar"
    Case #WM_SYSCOMMAND : Text$ = "SysCommand"
    Case #WM_SYSDEADCHAR : Text$ = "SysDeadChar"
    Case #WM_SYSKEYDOWN : Text$ = "SysKeyDown"
    Case #WM_SYSKEYUP : Text$ = "SysKeyUp"
    Case #WM_TIMER : Text$ = "Timer"
    Case #WM_USER : Text$ = "User"
    Case #WM_USERCHANGED : Text$ = "UserChanged"
    Case #WM_VSCROLLCLIPBOARD : Text$ = "VScrollClipboard"
    Case #WM_WINDOWPOSCHANGED : Text$ = "WindowPosChanged"
    Case #WM_WINDOWPOSCHANGING : Text$ = "WindowPosChanging"
    Case #WM_WININICHANGE : Text$ = "WinIniChange"
    Default
      Debug "Неопределено " + Str(Message)
  EndSelect
  Debug Text$+" "+Str(wParam)+" "+Str(lParam)
  ProcedureReturn Result
EndProcedure

Global ETCallback

Procedure EventTypeCallback(windowID, uMsg, wParam, lParam)
;   Protected xPos = GET_X_LPARAM_(lParam); 
;   Protected yPos = GET_Y_LPARAM_(lParam);
  ; Protected ETCallback = GetProp_(windowID, "oldproc") 
  
  If uMsg = #WM_LBUTTONDOWN
    Debug "#WM_LBUTTONDOWN "+ID::gadget(windowID)
  ElseIf uMsg = #WM_LBUTTONUP 
    Debug "#WM_LBUTTONUP "+ID::gadget(windowID)
  ElseIf uMsg = #WM_RBUTTONDOWN
    Debug "#WM_RBUTTONDOWN "+ID::gadget(windowID)
  ElseIf uMsg = #WM_RBUTTONUP
    Debug "#WM_RBUTTONUP "+ID::gadget(windowID)
  ElseIf uMsg = #WM_MBUTTONDOWN
    Debug "#WM_MBUTTONDOWN "+ID::gadget(windowID)
  ElseIf uMsg = #WM_MBUTTONUP
    Debug "#WM_MBUTTONUP "+ID::gadget(windowID)
  ElseIf uMsg = #WM_MOUSEFIRST
    ;  Debug "#WM_MOUSEMOVE "+id::gadget(windowID)
    
    
      Protected Track.TRACKMOUSEEVENT
          Track\cbSize = SizeOf(Track)
          Track\dwFlags = #TME_HOVER|#TME_LEAVE
          Track\hwndTrack = windowID
          Track\dwHoverTime = 10
          TrackMouseEvent_(@TRACK)
      
  ElseIf uMsg = #WM_MOUSEHOVER
    Debug "#WM_MOUSEHOVER "+ID::gadget(windowID)
  ElseIf uMsg = #WM_MOUSELEAVE
    Debug "#WM_MOUSELEAVE "+ID::gadget(windowID)
  ElseIf uMsg = #WM_CREATE
    Debug "#WM_CREATE "+ID::gadget(windowID)
  EndIf
  
  ProcedureReturn CallWindowProc_(ETCallback, windowID, uMsg, wParam, lParam)
EndProcedure

Procedure OpenWindowCallback_(windowID, uMsg, wParam, lParam) 
  Protected result
  ;Callback(windowID, uMsg, wParam, lParam)
  
  If uMsg = #WM_LBUTTONDOWN
    Debug "#WM_LBUTTONDOWN "
  ElseIf uMsg = #WM_LBUTTONUP 
    Debug "#WM_LBUTTONUP "
  ElseIf uMsg = #WM_RBUTTONDOWN
    Debug "#WM_RBUTTONDOWN "
  ElseIf uMsg = #WM_RBUTTONUP
    Debug "#WM_RBUTTONUP "
  ElseIf uMsg = #WM_MBUTTONDOWN
    Debug "#WM_MBUTTONDOWN "
  ElseIf uMsg = #WM_MBUTTONUP
    Debug "#WM_MBUTTONUP "
  ElseIf uMsg = #WM_MOUSEHOVER
    Debug "#WM_MOUSEHOVER "
  ElseIf uMsg = #WM_MOUSEMOVE
     
      Protected Track.TRACKMOUSEEVENT
          Track\cbSize = SizeOf(Track)
          Track\dwFlags = #TME_HOVER|#TME_LEAVE
          Track\hwndTrack = windowID
          Track\dwHoverTime = 10
          TrackMouseEvent_(@TRACK)
            
      
  ElseIf uMsg = #WM_MOUSELEAVE
    Debug "#WM_MOUSELEAVE "
  ElseIf uMsg = #WM_CREATE
    Debug "#WM_CREATE "
  EndIf
  
  Select uMsg 
;     Case #WM_ERASEBKGND
;       GetClientRect_(windowID, cRect.RECT)
;       FillRect_(wParam, cRect, brush)
;       ProcedureReturn 1
      
;     Case #WM_NCDESTROY
;       SetWindowLongPtr_(windowID, #GWL_WNDPROC, @oldProc)
;       ProcedureReturn DefWindowProc_(windowID, Msg, wParam, lParam)
       
    Case #WM_CLOSE 
      DestroyWindow_(windowID) 
      
    Case #WM_DESTROY 
      PostQuitMessage_(0) 
      Result  = 0 
      
    Default 
      Result  = DefWindowProc_(windowID, uMsg, wParam, lParam) 
  EndSelect 
  
  ProcedureReturn Result 
EndProcedure

Procedure OpenWindow_(window, X, Y, Width, Height, title.s, flags = 0, parentID = 0 )
  Protected win, uFlags, WindowClass.s  = "WindowClass_227B" 
  
  Protected wc.WNDCLASSEX 
  wc\cbSize  = SizeOf(WNDCLASSEX) 
  wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
  wc\hCursor = LoadCursor_(0, #IDC_ARROW)
  wc\lpfnWndProc  = @OpenWindowCallback_() 
  wc\lpszClassName  = @WindowClass 
  RegisterClassEx_(@wc) 
  
  If flags & #PB_Window_BorderLess = #PB_Window_BorderLess
    uFlags = #WS_VISIBLE | #WS_POPUP | #WS_BORDER
  EndIf
  
  ; #WS_POPUPWINDOW = #WS_POPUP | #WS_BORDER | #WS_SYSMENU
  ; #WS_OVERLAPPEDWINDOW = #WS_OVERLAPPED | #WS_CAPTION | #WS_SYSMENU | #WS_THICKFRAME | #WS_MINIMIZEBOX | #WS_MAXIMIZEBOX
  
  ;   screenx = GetSystemMetrics_(#SM_CXSCREEN)/2-width/2
  ;   screeny = GetSystemMetrics_(#SM_CYSCREEN)/2-height/2
  
  ;win  = CreateWindowEx_( #WS_EX_APPWINDOW, WindowClass, "Test Window", #WS_VISIBLE | #WS_CHILD | #WS_CAPTION, x, y, width, height, parentID, 0, 0, 0) 
  ;win  = CreateWindow_( WindowClass, "Test Window", #WS_VISIBLE | #WS_POPUP , x, y, width, height, 0, 0, 0, 0) 
  ;win  = CreateWindow_( WindowClass, "Test Window", #WS_VISIBLE | #WS_POPUP | #WS_THICKFRAME | #WS_SYSMENU , x, y, width, height, 0, 0, 0, 0) 
  ;win  = CreateWindowEx_( #WS_EX_TOPMOST|#WS_EX_NOACTIVATE|#WS_EX_NOPARENTNOTIFY|#WS_EX_TOOLWINDOW, WindowClass, "Test Window", #WS_VISIBLE | #WS_OVERLAPPEDWINDOW , x, y, width, height, 0, 0, 0, 0) 
  
  ;win  = CreateWindowEx_( #WS_EX_TOPMOST, WindowClass, "Test Window", #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU , x, y, width, height, 0, 0, 0, 0) 
  win  = CreateWindowEx_( #WS_EX_TOPMOST | #WS_EX_NOACTIVATE, WindowClass, "Test Window", uFlags, X, Y, Width, Height, 0, 0, 0, 0) 
  
  ; SetWindowPos_( win, #windowID_TOPMOST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE);|#SWP_NOACTIVATE);|#SWP_SHOWWINDOW )
  If ParentID
    SetProp_(win, "ParentID", ParentID) 
    ;SetProp_(ParentID, "ChildID", win) 
    ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
    SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
  EndIf
  
  UseGadgetList(win)
  ProcedureReturn win
EndProcedure

Procedure WaitCloseWindow_( )
  Protected msg.MSG
  While GetMessage_(msg, #Null, 0, 0 ) 
    TranslateMessage_(msg) 
    DispatchMessage_(msg) 
  Wend 
EndProcedure


;-\\
Declare EventsMessage( )

Procedure OpenPopup(ParentID=0)
  Static x,y
  x + 50
  y + 50
  Define win = OpenWindow_(10, 200+x, 100+y, 200, 200, "mac-win", #PB_Window_BorderLess|#PB_Window_NoActivate, ParentID)
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  ;\\
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  ;\\
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
  ;BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  ;ETCallback = SetWindowLongPtr_(GadgetID(gadget), #GWL_WNDPROC, @EventTypeCallback())
  
  ;\\
  SetProp_(GadgetID(Gadget), "ParentID", win) 
  SetWindowPos_( win, #HWND_TOPMOST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOACTIVATE )
  
  ;\\
  Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
  BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
  ;ETCallback = SetWindowLongPtr_(GadgetID(closeButton), #GWL_WNDPROC, @EventTypeCallback())
  ;SetProp_(GadgetID(closeButton), "oldproc", ETCallback)
  SetProp_(GadgetID(closeButton), "ParentID", win) 
  
  ;\\
  If ParentID
    SetProp_(win, "ParentID", ParentID) 
    ;SetProp_(ParentID, "ChildID", win) 
    ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
    ;SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
    ;;;SendMessage_(#windowID_BROADCAST, #WM_SYSCOMMAND, #SC_HOTKEY, ParentID)
  EndIf
  
  ClipGadgets(win)
  UseGadgetList(UseGadgetList)
EndProcedure

Procedure OpenMessage(ParentID=0)
  Define win = OpenWindow_(10, 160, 100, 200, 200, "mac-win", #PB_Window_BorderLess, ParentID)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
  ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
  ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
  ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
  ;   ;BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  ETCallback = SetWindowLongPtr_(GadgetID(gadget), #GWL_WNDPROC, @EventTypeCallback())
  
  SetProp_(GadgetID(Gadget), "ParentID", win) 
  
  ;\\
  Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
  SetProp_(GadgetID(closeButton), "ParentID", win) 
  ETCallback = SetWindowLongPtr_(GadgetID(closeButton), #GWL_WNDPROC, @EventTypeCallback())
  BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
  
  ClipGadgets(win)
  If ParentID
    UseGadgetList(ParentID)
  EndIf
  WaitCloseWindow_( )
  
  ;FreeGadget( gadget )
  Debug "Quit MESSAGE"
EndProcedure

Procedure EventsMessage( )
  Static click, enter
  Protected WindowID = GetProp_(GadgetID(EventGadget()), "ParentID") 
  Protected ParentID = GetProp_(WindowID, "ParentID") 
  
  
  Select EventType()
    Case #PB_EventType_LeftClick
      Debug "close"
      
    Case #PB_EventType_MouseEnter
      If enter = 0
        Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
        enter = 1
      Else
        ;Debug " bug message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
      EndIf
      
    Case #PB_EventType_MouseLeave
      If enter = 1
        Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
        enter = 0
      EndIf
      
    Case #PB_EventType_LeftButtonUp
      If click = 1
        Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
        click = 0
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      If click = 0
        click = 1
        Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
        OpenPopup( ParentID )
        ; OpenMessage( WindowID )
        
        ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
        SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
      EndIf
  EndSelect
EndProcedure

;\\
Procedure gadget_event( )
  If IsWindow(EventWindow())
    Select EventType()
      Case #PB_EventType_LeftClick
        Debug "click"
        
      Case #PB_EventType_LeftButtonDown
        Select EventGadget()
          Case 0
            ;Debug "messageCreate"
            ;OpenPopup( WindowID( EventWindow( )))
            OpenMessage( WindowID( EventWindow( )))
        EndSelect
        
      Case #PB_EventType_MouseEnter
        Debug "enter " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
      Case #PB_EventType_MouseLeave
        Debug "leave " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
    EndSelect
  EndIf
EndProcedure

OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
CanvasGadget(0, 10, 10, 180, 180)
StartDrawing(CanvasOutput(0))
DrawText( 30,45, "button_0")
StopDrawing()

BindEvent(#PB_Event_Gadget, @gadget_event())

Define Event
Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_LeftClick
    Debug " pb_window_leftclick"
  EndIf
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 311
; FirstLine = 301
; Folding = -------
; EnableXP