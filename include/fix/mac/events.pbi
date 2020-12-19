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
      ; #MouseMovedMask         = 1 << 5
      ; #LeftMouseDraggedMask   = 1 << 6
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
      
      GetCurrentProcess(@psn.q)
      
      mask = #LeftMouseDownMask | #LeftMouseUpMask
      ; mask | #RightMouseDownMask | #RightMouseUpMask
      ; mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
      ; mask | #KeyDownMask
      
      ;
      ; get real event gadget
      ;
      Global event_window =- 1
      Global event_gadget =- 1
      Procedure events_gadgets( )
        If GetActiveWindow( ) <> EventWindow( )
          event_window = EventWindow( )
        EndIf
        event_gadget = EventGadget( )
      EndProcedure 
      BindEvent( #PB_Event_Gadget, @events_gadgets( ) )
      
      ;
      ; callback function
      ;
      ProcedureC eventTapFunction(proxy, type, event, refcon)
        If IsWindow( event_window )
          Debug "  "+#PB_Compiler_Procedure  +" "+ GetActiveWindow() +" "+ EventWindow() +" "+ EventGadget() +" "+ event_gadget +" "+ type ;+" "+ root()
          
          If type = 1 ; LeftButtonDown
            PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
            
          ElseIf type = 2 ; LeftButtonUp
            PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp )
            event_window =- 1
          EndIf
        EndIf
      EndProcedure
      
      eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
      If eventTap
        CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
      EndIf
      
     CompilerEndIf
    
  EndModule 
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  UseModule events
  
  OpenWindow(0, 200, 100, 220, 220, "click hire", #PB_Window_SystemMenu)
  CanvasGadget(0, 10, 10, 200, 200)
  
  OpenWindow(1, 300, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP