;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule events
    
      Macro PB(Function)
        Function
      EndMacro
      
    EndDeclareModule 
  
  Module events
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ; bug when clicking on the canvas in an inactive window
      #LeftMouseDownMask      = 1 << 1
      #LeftMouseUpMask        = 1 << 2
      ; #RightMouseDownMask     = 1 << 3
      ; #RightMouseUpMask       = 1 << 4
       #MouseMovedMask         = 1 << 5
       #LeftMouseDraggedMask   = 1 << 6
      ; #RightMouseDraggedMask  = 1 << 7
      ; #KeyDownMask            = 1 << 10
      ; #KeyUpMask              = 1 << 11
      ; #FlagsChangedMask       = 1 << 12
      ; #ScrollWheelMask        = 1 << 22
      ; #OtherMouseDownMask     = 1 << 25
      ; #OtherMouseUpMask       = 1 << 26
      ; #OtherMouseDraggedMask  = 1 << 27
      
      Global psn.q, mask, eventTap, key.s
      
      ImportC ""
        CFRunLoopGetCurrent()
        CFRunLoopAddCommonMode(rl, mode)
        
        GetCurrentProcess(*psn)
        CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
      EndImport
      
      Import ""
        PB_Window_GetID(hWnd) 
      EndImport
      
;       Procedure.s GetClassName( handle.i )
;         Protected Result
;         CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
;         If Result
;           ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
;         EndIf
;       EndProcedure
;       
      Procedure IDWindow(Handle)
        ProcedureReturn PB_Window_GetID(Handle)
      EndProcedure
      
      Procedure IDGadget(Handle)
        ProcedureReturn CocoaMessage(0, Handle, "tag")
      EndProcedure
      
      GetCurrentProcess(@psn.q)
      
      mask = #LeftMouseDownMask | #LeftMouseUpMask | #LeftMouseDraggedMask ; | #MouseMovedMask ;| 1 << 8 | 1 << 9 ; 
      ; mask | #RightMouseDownMask | #RightMouseUpMask
      ; mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
      ; mask | #KeyDownMask
      
      Procedure GetGadgetWindow( Gadget )
        ProcedureReturn IDWindow( CocoaMessage( 0, GadgetID( Gadget ), "window" ) )
      EndProcedure
      
      Global GetActiveGadget =- 1
      Procedure Event_ActivateWindow( )
        If IsGadget( EventGadget( ) )
          If GetActiveGadget <> EventGadget( ) 
            If IsGadget( GetActiveGadget )
              PostEvent( #PB_Event_Gadget , GetGadgetWindow( GetActiveGadget ), GetActiveGadget, #PB_EventType_LostFocus )
            EndIf
            
            GetActiveGadget = EventGadget( )
            
            If GetActiveGadget( ) =- 1
              SetActiveGadget( EventGadget( ) ) 
            Else
             ; SetActiveGadget( EventGadget( ) ) 
              PostEvent( #PB_Event_Gadget , EventWindow( ), EventGadget( ), #PB_EventType_Focus )
            EndIf
          EndIf
        EndIf
      EndProcedure
      
      Procedure Event_Gadget( )
        If EventType( ) = #PB_EventType_Focus
           ; SetActiveGadget( EventGadget( ) ) 
             GetActiveGadget = EventGadget( )
          Debug GetActiveGadget()
          
        EndIf
      EndProcedure
      
      BindEvent( #PB_Event_ActivateWindow, @Event_ActivateWindow( ) )
      BindEvent( #PB_Event_Gadget, @Event_Gadget( ) )
      
;       Procedure Event_DeactivateWindow( )
;         If IsGadget( EventGadget() )
;           Debug ""+67777+" "+GetActiveGadget( )
;           If IsGadget( GetActiveGadget( ) )
;             Debug 2222 ;PostEvent( #PB_Event_Gadget , GetActiveWindow(), GetActiveGadget( ), #PB_EventType_LostFocus )
;           EndIf
;          ; SetActiveGadget( EventGadget() )
;         EndIf
;       EndProcedure
;       
;       BindEvent( #PB_Event_DeactivateWindow, @Event_DeactivateWindow( ) )
      ;       ;
      ;       ; callback function
      ;       ;
      ProcedureC eventTapFunction(proxy, type, event, refcon)
        Static event_window =- 1
        Static event_gadget =- 1
        
        If type = 1 ; 1 << type = #LeftMouseDownMask ; LeftButtonDown
          Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
          If NSEvent
            Protected NSWindow = CocoaMessage(0, NSEvent, "window")
            If NSWindow
              Protected Point.NSPoint
              CocoaMessage(@Point, NSEvent, "locationInWindow")
              Protected contentView = CocoaMessage(0, NSWindow, "contentView")
              Protected hitTest = CocoaMessage(0, contentView, "hitTest:@", @Point)
              If hitTest
                Protected Gadget = IDGadget( hitTest )
              EndIf
              event_window = IDWindow( NSWindow )
            EndIf
          EndIf           
          
          If GetActiveWindow( ) <> event_window 
            Static GetActiveGadget =- 1
            If IsGadget( Gadget )
              event_gadget = Gadget
              PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown, NSEvent )
;               Debug ""+ GetActiveGadget( ) +" "+ event_gadget
;               If GetActiveGadget <> event_gadget
;                 If IsGadget( GetActiveGadget )
;                   PostEvent( #PB_Event_Gadget , event_window, GetActiveGadget, #PB_EventType_LostFocus, NSEvent )
;                 EndIf
;                 
;                 ; Debug  SetActiveGadget( event_gadget )
;                 GetActiveGadget = event_gadget
;                 PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_Focus, NSEvent )
;                 PostEvent( #PB_Event_Repaint , event_window, event_gadget, EventType( ), NSEvent )
;                 
;               EndIf
            EndIf
          Else
            event_window =- 1
          EndIf
          
        ElseIf type = 2 ; 1 << type = #LeftMouseUpMask ; LeftButtonUp
          If IsWindow( event_window )
            If IsGadget( event_gadget )
              PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp, NSEvent )
              event_gadget =- 1
            Else
              PostEvent( #PB_Event_LeftClick , event_window, EventGadget( ), EventType( ), NSEvent )
            EndIf
            event_window =- 1
          EndIf
        ElseIf type = 6
          If event_window >= 0
            event_window =- 1
          EndIf
        EndIf
      EndProcedure
      
; ; ;       ProcedureC eventTapFunction(proxy, type, event, refcon)
; ; ;         Static event_window =- 1
; ; ;         Static event_gadget =- 1
; ; ;         
; ; ;         If type = 1 ; 1 << type = #LeftMouseDownMask ; LeftButtonDown
; ; ;           If GetActiveWindow( ) <> EventWindow( ) 
; ; ;             
; ; ;             event_window = EventWindow( )
; ; ;             event_gadget = EventGadget( )
; ; ;             Debug " ---  fixmePB --- "+#PB_Compiler_Procedure +"( )"
; ; ;             
; ; ;             PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
; ; ;           EndIf
; ; ;         ElseIf type = 2 ; 1 << type = #LeftMouseUpMask ; LeftButtonUp
; ; ;           If IsWindow( event_window )
; ; ;             PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp )
; ; ;             event_window =- 1
; ; ;             event_gadget =- 1
; ; ;           EndIf
; ; ;           
; ; ;           ; bug mouse enter 
; ; ;         ElseIf type = 5 Or type = 8 Or type = 9 ; 1 << type = #MouseMovedMask ; MouseMove
; ; ;           Static lastView
; ; ;           Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
; ; ;           
; ; ;           If NSEvent
; ; ;             Protected  Window = CocoaMessage(0, NSEvent, "window")
; ; ;             
; ; ;             If Window
; ; ;               Protected Point.NSPoint
; ; ;               CocoaMessage(@Point, NSEvent, "locationInWindow")
; ; ;               Protected contentView = CocoaMessage(0, Window, "contentView")
; ; ;               
; ; ;               Protected View = CocoaMessage(0, contentView, "hitTest:@", @Point)
; ; ;               
; ; ;               If lastView <> View 
; ; ;                 If lastView
; ; ;                  ; PostEvent( #PB_Event_Gadget, EventWindow(), LastView, #PB_EventType_MouseLeave )
; ; ;                 EndIf
; ; ;                 
; ; ;                 lastView = View 
; ; ;                                 ; Debug "eventTapFunction - "+Window +" "+ contentView +" "+ View +" "+ EventGadget()
; ; ;                 PostEvent( #PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Change, View )
; ; ;               EndIf
; ; ;             EndIf
; ; ;           EndIf           
; ; ;         EndIf
; ; ;       EndProcedure
; ; ;       
      eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
      If eventTap
        CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
      EndIf
      
     CompilerEndIf
    
  EndModule 
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  UseModule events
  Define event
  
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard )
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard)
  
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu)
  CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard)
  
  Debug GadgetID(1)
  Debug GadgetID(11)
  Debug GadgetID(2)
  
  Repeat 
    event = WaitWindowEvent()
    
    If event = #PB_Event_Gadget
      If EventType() = #PB_EventType_Focus
        Debug ""+EventWindow() +" "+EventGadget() + " #PB_EventType_Focus "
      EndIf
      If EventType() = #PB_EventType_LostFocus
        Debug "  "+EventWindow() +" "+EventGadget() + " #PB_EventType_LostFocus "
      EndIf
      
      If EventType() = #PB_EventType_LeftButtonDown
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
      EndIf
      If EventType() = #PB_EventType_LeftButtonUp
        Debug "  "+EventGadget() + " #PB_EventType_LeftButtonUp "
      EndIf
      
      If EventType() = #PB_EventType_Change
        Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
      EndIf
;       If EventType() = #PB_EventType_MouseEnter
;         Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData() +" "+ GetActiveWindow( )
;       EndIf
;       If EventType() = #PB_EventType_MouseLeave
;         Debug "  "+EventGadget() + " #PB_EventType_MouseLeave "
;       EndIf
    EndIf
    
    If event = #PB_Event_Repaint
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_Repaint "
    EndIf
    If event = #PB_Event_LeftClick
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_LeftClick "
    EndIf
    If event = #PB_Event_RightClick
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_RightClick "
    EndIf
    If event = #PB_Event_ActivateWindow
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_ActivateWindow "
    EndIf
    If event = #PB_Event_DeactivateWindow
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_DeactivateWindow "
    EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------
; EnableXP