
;\\                                       ; win ; mac & lin
; Debug #PB_MessageRequester_YesNoCancel  ; 3   ; 2
; Debug #PB_MessageRequester_YesNo        ; 4   ; 1
; Debug #PB_MessageRequester_Yes          ; 6   ; 6
; Debug #PB_MessageRequester_Error        ; 16  ; 8
; Debug #PB_MessageRequester_Warning      ; 48  ; 16
; Debug #PB_MessageRequester_Info         ; 64  ; 4
; 
; Debug ""
; Debug #PB_MessageRequester_Ok           ; 0   ; 0
; Debug #PB_MessageRequester_Cancel       ; 2   ; 2
; Debug #PB_MessageRequester_No           ; 7   ; 7
; 
; ;MessageRequester(


EnableExplicit
Declare CanvasEvents( )

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
Procedure.s GetTitle(Handle)
      Protected Name.s
      Name.s = Space(1024)
      GetWindowText_(Handle, @Name, Len(Name))
      ProcedureReturn Left(Name, Len(Name))
  EndProcedure
    
 Procedure.s ClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
   
   Procedure   Proc(hWnd, uMsg, wParam, lParam)
    Protected result
    Protected oldproc = GetProp_(hWnd, "#__oldproc")
    
    Select uMsg
      Case #PB_EventType_FirstCustomValue
        Debug "event( FirstCustomValue ) "+hwnd
        
      Case #WM_LBUTTONDOWN
        Debug "event( LBUTTONDOWN ) "+hwnd
        
      Case #WM_DESTROY
        Debug "event( DESTROY ) "+hwnd
;       Case #WM_NCDESTROY
;         Debug "event( NC_DESTROY ) "+hwnd
        RemoveProp_(hwnd, "#__oldproc")
        
      Default
        result = CallWindowProc_(oldproc, hWnd, uMsg, wParam, lParam)
        
    EndSelect
    
    ProcedureReturn result
  EndProcedure
  
  Procedure CallBack(WindowID, message, wParam, lParam)
      Protected Text$
      Protected Result = #PB_ProcessPureBasicEvents
      
      Select message
        Case #WM_CLOSE 
          Debug "close "
           ; DestroyWindow_( WindowID )
           ; PostQuitMessage_( 0 )
            
         Case #WM_DESTROY 
           Debug "DESTROY " + ClassName(WindowID) +" "+ GetTitle(WindowID)
           
         Case #WM_NCDESTROY
           Debug "NC DESTROY " + ClassName(WindowID) +" "+ GetTitle(WindowID)
           
         Case #WM_QUIT : Text$ = "Quit"
      EndSelect
      ; Debug "CallBack "+message +" "+ Text$+" "+Str(wParam)+" "+Str(lParam)
      
      ProcedureReturn Result
   EndProcedure
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
   ProcedureC winCloseHandler(*Widget.GtkWidget, *Event.GdkEventAny, UserData.I)
      Debug "winCloseHandler"
      gtk_main_quit_( )
   EndProcedure
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
   ProcedureC winCloseHandler(obj.i, sel.i, win.i) 
      Debug "winShouldClose"
      CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", win)
      ProcedureReturn #YES
   EndProcedure
   
CompilerEndIf

;-
Procedure WaitEvents( window )
   Protected win = WindowID( window )
   
   ;\\ start main loop
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ;       ;\\
      ;       Protected NSObjectClass = objc_getClass_("NSObject")
      ;       Protected myWindowDelegateClass = objc_allocateClassPair_(NSObjectClass, "myWindowDelegate", 0)
      ;       class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
      ;       class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winCloseHandler(), "c@:@")
      ;       Protected myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)
      ;       CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
      
      ;\\
      CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "run")
      
   CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ;\\ https://www.purebasic.fr/english/viewtopic.php?p=570200&hilit=move+items#p570200
      ;       g_signal_connect_(win, "delete-event", @winCloseHandler( ), 0)
      ;       g_signal_connect_(win, "destroy", @winCloseHandler( ), 0)
      
      ;\\
      gtk_main_( )
      
   CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      Protected msg.MSG
      Protected canvas = GetWindowData( window )
      
      SetProp_( GadgetID(canvas), "#__oldproc", SetWindowLongPtr_(GadgetID(canvas), #GWL_WNDPROC, @Proc( )))
      ; SetProp_( WindowID(window), "#__oldproc", SetWindowLongPtr_(WindowID(window), #GWL_WNDPROC, @Proc( )))
      SetWindowCallback( @CallBack( ) )
      
      PostMessage_(GadgetID(canvas), #WM_LBUTTONDOWN, 0,0)
      ; SendMessage_(GadgetID(canvas), #WM_LBUTTONDOWN, 0,0)
     
      ;\\
      ; While PeekMessage_(@msg,0,0,0,1)
      While GetMessage_(@msg, #Null, 0, 0 )
         TranslateMessage_(msg) 
         DispatchMessage_(msg)
      Wend
      
   CompilerEndIf
EndProcedure

;-
Procedure MessageEvents( )
   Protected *ew = EventGadget( )
   Protected *message = EventWindow( )
   
   Select EventType( )
      Case #PB_EventType_LeftClick
         Select GetGadgetText( *ew )
            Case "No"     : SetWindowData( *message, #PB_MessageRequester_No )     ; no
            Case "Yes"    : SetWindowData( *message, #PB_MessageRequester_Yes )    ; yes
            Case "Cancel" : SetWindowData( *message, #PB_MessageRequester_Cancel ) ; cancel
         EndSelect
         
         ;\\
         UnbindGadgetEvent( *ew, @MessageEvents( ), #PB_EventType_LeftClick )
         
         ;\\ stop main loop
         CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows
               PostQuitMessage_( 0 )
            CompilerCase #PB_OS_Linux
               gtk_main_quit_( )
            CompilerCase #PB_OS_MacOS
               CocoaMessage( 0, CocoaMessage( 0, 0, "NSApplication sharedApplication" ), "stop:", 0 )
         CompilerEndSelect
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure Message( Title.s, Text.s, flag.q, *parent )
   Protected result, img = 0, f1 = - 1, f2 = 8, width = 400, height = 120
   Protected bw = 85, bh = 25, iw = height - bh - f1 - f2 * 4 - 2 - 1
   
   ;\\
   Protected *ok, *no, *cancel
   Protected *message = OpenWindow(#PB_Any, 0, 0, width, height, Title, #PB_Window_TitleBar|#PB_Window_WindowCentered, WindowID(*parent))
   
   If Flag & #PB_MessageRequester_Info
   EndIf
   
   If Flag & #PB_MessageRequester_Error
   EndIf
   
   If Flag & #PB_MessageRequester_Warning
   EndIf
   
   ;\\
   ContainerGadget(#PB_Any, f1, f1, width - f1 * 2, height - bh - f1 - f2 * 2 - 1 )
   ImageGadget(#PB_Any, f2, f2, iw, iw, img, #PB_Image_Border )
   TextGadget(#PB_Any, f2 + iw + f2, f2, width - iw, iw, Text )
   CloseGadgetList( )
   
   ;\\
   *ok = ButtonGadget(#PB_Any, width - bw - f2, height - bh - f2, bw, bh, "Ok");, #__flag_ButtonDefault )
   BindGadgetEvent( *ok, @MessageEvents( ), #PB_EventType_LeftClick )
   If Flag & #PB_MessageRequester_YesNo Or
      Flag & #PB_MessageRequester_YesNoCancel
      SetGadgetText( *ok, "Yes" )
      *no = ButtonGadget(#PB_Any, width - ( bw + f2 ) * 2 - f2, height - bh - f2, bw, bh, "No" )
      BindGadgetEvent( *no, @MessageEvents( ), #PB_EventType_LeftClick )
   EndIf
   If Flag & #PB_MessageRequester_YesNoCancel
      *cancel = ButtonGadget(#PB_Any, width - ( bw + f2 ) * 3 - f2 * 2, height - bh - f2, bw, bh, "Cancel" )
      BindGadgetEvent( *cancel, @MessageEvents( ), #PB_EventType_LeftClick )
   EndIf
   
    ; macos bug no post event
   PostEvent( #PB_Event_Gadget, 0,0, #PB_EventType_FirstCustomValue )
   
   ;\\
   StickyWindow( *message, #True )
   
   ;\\
   WaitEvents( *parent )
   
   ;\\
   StickyWindow( *message, #False )
   
   ;\\
   result = GetWindowData( *message )
   
   ;\\ close
   CloseWindow( *message )
   
   ProcedureReturn result
EndProcedure


;-
Procedure ShowMessage( UseGadgetList )
   Debug "open - Title"
   Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info, UseGadgetList) 
   Debug " close - Title " + Result
   
   Define flag, a$ = "Result of the previously requester was: "
   
   If Result = #PB_MessageRequester_Yes       ; pressed Yes button
      flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
      a$ +#LF$+ "Yes"
   ElseIf Result = #PB_MessageRequester_No    ; pressed No button
      flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
      a$ +#LF$+ "No"
   Else                                       ; pressed Cancel button or Esc
      flag = #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning
      a$ +#LF$+ "Cancel"
   EndIf
   
   Debug "open - Information"
   Result = Message("Information", a$, flag, UseGadgetList)
   Debug "close - Information "+Result
EndProcedure

Procedure CanvasEvents( )
   Protected x,y
   
   If EventType() = #PB_EventType_FirstCustomValue
      Debug "#PB_EventType_FirstCustomValue "
   EndIf
   
   
   If EventType() = #PB_EventType_LeftButtonDown Or 
      (EventType() = #PB_EventType_MouseMove And GetGadgetAttribute(1, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
      
      If StartDrawing(CanvasOutput(1))
         x = GetGadgetAttribute(1, #PB_Canvas_MouseX)
         y = GetGadgetAttribute(1, #PB_Canvas_MouseY)
         Circle(x, y, 10, RGB(Random(255), Random(255), Random(255)))
         StopDrawing()
      EndIf
      
   EndIf
   
   If EventType() = #PB_EventType_RightButtonDown
      If StartDrawing(CanvasOutput(1))
         Box(0, 0, 200, 200, #White)
         StopDrawing()
      EndIf
   EndIf
EndProcedure

Procedure EventClick( )
   If EventType( ) = #PB_EventType_LeftClick
      ShowMessage( (0) )
   EndIf
EndProcedure

If OpenWindow( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
   CanvasGadget(1,10,10,490, 250 )
   BindGadgetEvent( 1, @canvasevents() )
   SetWindowData( 0, 1 )
   
   Define *showButton = ButtonGadget(#PB_Any, 600-100, 300-40, 90,30,"show")
   BindGadgetEvent( *showButton, @EventClick() )
   
   ShowMessage( (0) )
   
   Define Event
   Repeat
      Event = WaitWindowEvent( )
      If Event = #PB_Event_Gadget
         If EventType( ) = #PB_EventType_LeftClick
            If EventGadget( ) = 1
               Debug "main loop canvas click event"
            EndIf
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
   
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 193
; FirstLine = 182
; Folding = f--8--
; EnableXP