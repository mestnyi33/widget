Procedure EnterGadgetID( ) 
  Protected handle
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      Protected EnterGadgetID, GadgetID
      Protected Cursorpos.q
      
      GetCursorPos_( @Cursorpos )
      handle = WindowFromPoint_( Cursorpos )
      ScreenToClient_(handle, @Cursorpos) 
      GadgetID = ChildWindowFromPoint_( handle, Cursorpos )
      
      GetCursorPos_( @Cursorpos )
      handle = GetAncestor_( handle, #GA_ROOT )
      ScreenToClient_(handle, @Cursorpos) 
      handle = ChildWindowFromPoint_( handle, Cursorpos )
      
      If IsGadget( GetDlgCtrlID_( GadgetID )) 
        If GadgetID = GadgetID( GetDlgCtrlID_( GadgetID ))
          handle = GadgetID
        Else
          ; SpinGadget
          If GetWindow_( GadgetID, #GW_HWNDPREV ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            EndIf
            handle = GetWindow_( GadgetID, #GW_HWNDPREV)
            
          ElseIf GetWindow_( GadgetID, #GW_HWNDNEXT ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            EndIf
            handle = GetWindow_( GadgetID, #GW_HWNDNEXT)
          EndIf
        EndIf
      Else
        If GetParent_( GadgetID )
          handle = GetParent_( GadgetID ) ; С веб гаджетом проблемы
                                            ;Debug handle ; 
        EndIf
      EndIf
      
      ; SplitterGadget( ) 
      Protected RealClass.S = Space(13) 
      GetClassName_( GetParent_( handle ), @RealClass, Len( RealClass ))
      If RealClass.S = "PureSplitter" 
        handle = GetParent_( handle ) 
      EndIf
      
      ;Debug handle
      ProcedureReturn handle
      
    CompilerCase #PB_OS_MacOS
      Protected win_id, win_cv, pt.NSPoint
      win_id = WindowID(EventWindow( ))
      win_cv = CocoaMessage(0, win_id, "contentView")
      CocoaMessage(@pt, win_id, "mouseLocationOutsideOfEventStream")
      handle = CocoaMessage(0, win_cv, "hitTest:@", @pt)
      ProcedureReturn handle
      
    CompilerCase #PB_OS_Linux
      Protected desktop_x, desktop_y, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
      If *GdkWindow
        gdk_window_get_user_data_( *GdkWindow, @handle )
        ; handle = *GdkWindow\user_data ; Начиная с PB 5.40, * GdkWindow.GdkWindowObject \ user_data больше не содержит GtkWindow или является неверным
        ProcedureReturn handle
      EndIf
      
  CompilerEndSelect
  
EndProcedure    

Procedure is_double_click( _event_type_ )
  Static time_click
  
  If _event_type_ = #PB_EventType_LeftButtonDown
    If Not ( time_click And ElapsedMilliseconds( ) - time_click < 160 )
      time_click = 0
      ProcedureReturn 0
    EndIf
  EndIf
  
  If _event_type_ = #PB_EventType_LeftButtonUp
    ; do click events
    If Not ( time_click And ElapsedMilliseconds( ) - time_click < DoubleClickTime( ) )
      time_click = ElapsedMilliseconds( )
      ProcedureReturn 0
    Else
      time_click = 0
    EndIf
  EndIf
  
  ProcedureReturn 1
EndProcedure

; OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
;   CanvasGadget(1, 10, 10, 200, 200)
;   CanvasGadget(11, 110, 110, 200, 200)

OpenWindow(2, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(2, 10, 10, 200, 200)

Define PressedGadgetID
Repeat 
  event = WaitWindowEvent( )
  
  If event = #PB_Event_Gadget
    If EventType( ) = #PB_EventType_LeftButtonDown
      PressedGadgetID = GadgetID( EventGadget() )
      
      If Not is_double_click( EventType( ) ) 
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
      EndIf
    EndIf
    
    CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
      If EventType( ) = #PB_EventType_LeftButtonUp
        
        
        ; do click events
        If Not is_double_click( EventType( ) )
          Debug ""+EventGadget( ) + " #PB_EventType_LeftButtonUp "
          
          If PressedGadgetID = EnterGadgetID( ) ; GadgetID( EventGadget() )
            ; do one-click events
            Debug ""+EventGadget( ) + " #PB_EventType_LeftClick"
          EndIf
        Else
          ; do double-click events 
          Debug ""+EventGadget( ) + " #PB_EventType_LeftDoubleClick"
        EndIf
        
        
      EndIf
    CompilerElse
      If EventType( ) = #PB_EventType_LeftButtonUp
        Debug ""+EventGadget( ) + " #PB_EventType_LeftButtonUp "
      EndIf
      If EventType( ) = #PB_EventType_LeftClick
        Debug ""+EventGadget( ) + " #PB_EventType_LeftClick "
      EndIf
      If EventType( ) = #PB_EventType_LeftDoubleClick
        Debug ""+EventGadget( ) + " #PB_EventType_LeftDoubleClick "
      EndIf
    CompilerEndIf
    
;     ;       If EventType() = #PB_EventType_Change
;     ;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
;     ;       EndIf
;     If EventType() = #PB_EventType_MouseEnter
;       Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData()
;     EndIf
;     If EventType() = #PB_EventType_MouseLeave
;       Debug ""+EventGadget() + " #PB_EventType_MouseLeave "
;     EndIf
  EndIf
Until event = #PB_Event_CloseWindow

; windows
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftDoubleClick 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---H-
; EnableXP