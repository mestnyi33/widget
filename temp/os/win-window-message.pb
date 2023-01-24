EnableExplicit

#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

Procedure CloseWindow_( hWnd )
  DestroyWindow_(hWnd)
EndProcedure

Procedure WindowCallback(hWnd, uMsg, wParam, lParam) 
  Protected result
  ;Debug hWnd
  Select uMsg 
    Case #WM_CLOSE 
      DestroyWindow_(hWnd) 
    Case #WM_DESTROY 
      PostQuitMessage_(0) 
      Result  = 0 
    Default 
      Result  = DefWindowProc_(hWnd, uMsg, wParam, lParam) 
  EndSelect 
  
  ProcedureReturn Result 
EndProcedure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected hWndMain, uFlags, WindowClass.s  = "WindowClass_227B" 
  
  Protected wc.WNDCLASSEX 
  wc\cbSize  = SizeOf(WNDCLASSEX) 
  wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
  wc\hCursor = LoadCursor_(0, #IDC_ARROW)
  wc\lpfnWndProc  = @WindowCallback() 
  wc\lpszClassName  = @WindowClass 
  RegisterClassEx_(@wc) 
  
  If flags & #PB_Window_BorderLess = #PB_Window_BorderLess
    uFlags = #WS_VISIBLE | #WS_POPUP
  EndIf
  
  ; #WS_POPUPWINDOW = #WS_POPUP | #WS_BORDER | #WS_SYSMENU
  ; #WS_OVERLAPPEDWINDOW = #WS_OVERLAPPED | #WS_CAPTION | #WS_SYSMENU | #WS_THICKFRAME | #WS_MINIMIZEBOX | #WS_MAXIMIZEBOX
  
  ;   screenx = GetSystemMetrics_(#SM_CXSCREEN)/2-width/2
  ;   screeny = GetSystemMetrics_(#SM_CYSCREEN)/2-height/2
  
  ;hWndMain  = CreateWindowEx_( #WS_EX_APPWINDOW, WindowClass, "Test Window", #WS_VISIBLE | #WS_CHILD | #WS_CAPTION, x, y, width, height, parentID, 0, 0, 0) 
  ;hWndMain  = CreateWindow_( WindowClass, "Test Window", #WS_VISIBLE | #WS_POPUP , x, y, width, height, 0, 0, 0, 0) 
  ;hWndMain  = CreateWindow_( WindowClass, "Test Window", #WS_VISIBLE | #WS_POPUP | #WS_THICKFRAME | #WS_SYSMENU , x, y, width, height, 0, 0, 0, 0) 
  ;hWndMain  = CreateWindowEx_( #WS_EX_TOPMOST|#WS_EX_NOACTIVATE|#WS_EX_NOPARENTNOTIFY|#WS_EX_TOOLWINDOW, WindowClass, "Test Window", #WS_VISIBLE | #WS_OVERLAPPEDWINDOW , x, y, width, height, 0, 0, 0, 0) 
  
  ;hWndMain  = CreateWindowEx_( #WS_EX_TOPMOST, WindowClass, "Test Window", #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU , x, y, width, height, 0, 0, 0, 0) 
  hWndMain  = CreateWindowEx_( #WS_EX_TOPMOST | #WS_EX_NOACTIVATE, WindowClass, "Test Window", uFlags, x, y, width, height, 0, 0, 0, 0) 
  
  ; SetWindowPos_( hWndMain, #HWND_TOPMOST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE);|#SWP_NOACTIVATE);|#SWP_SHOWWINDOW )
  If ParentID
    SetProp_(hWndMain, "ParentID", ParentID) 
    ;SetProp_(ParentID, "ChildID", hWndMain) 
    ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
    SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
  EndIf
  
  ProcedureReturn hWndMain
EndProcedure

Procedure WaitClose_( )
  Protected msg.MSG
  While GetMessage_(msg, #Null, 0, 0 ) 
    TranslateMessage_(msg) 
    DispatchMessage_(msg) 
  Wend 
EndProcedure

Declare EventsMessage( )

Procedure OpenMessage(ParentID=0)
  Define win = OpenWindow_(10, 160, 100, 200, 200, "mac-win", #PB_Window_BorderLess, ParentID)
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  
  SetProp_(GadgetID(Gadget), "ParentID", win) 
  
  ;\\
  Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
  BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
  SetProp_(GadgetID(closeButton), "ParentID", win) 
  
  UseGadgetList(UseGadgetList)
  WaitClose_( )
  
  ;FreeGadget( gadget )
  Debug "Quit MESSAGE"
EndProcedure

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
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  
  ;\\
  SetProp_(GadgetID(Gadget), "ParentID", win) 
  SetWindowPos_( win, #HWND_TOPMOST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOACTIVATE )
  
  ;\\
  Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
  BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
  SetProp_(GadgetID(closeButton), "ParentID", win) 
  
  ;\\
  If ParentID
    SetProp_(win, "ParentID", ParentID) 
    ;SetProp_(ParentID, "ChildID", win) 
    ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
    ;SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
  EndIf
UseGadgetList(UseGadgetList)
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
        Debug " bug message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
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
        Select EventGadget()
          Case 5
            Debug "close"
            ;OpenPopup( WindowID( EventWindow( )))
             OpenMessage( WindowID( EventWindow( )))
        EndSelect
        
      Case #PB_EventType_LeftButtonDown
        Select EventGadget()
          Case 0
            Debug "messageCreate"
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
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 103
; FirstLine = 79
; Folding = ----
; EnableXP