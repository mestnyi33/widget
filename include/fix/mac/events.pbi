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
      
      
      ;       ;
      ;       ; callback function
      ;       ;
      ProcedureC eventTapFunction(proxy, type, event, refcon)
        Static event_window =- 1
        Static event_gadget =- 1
        
        If type = 1 ; LeftButtonDown
          If GetActiveWindow( ) <> EventWindow( ) 
            
            event_window = EventWindow( )
            event_gadget = EventGadget( )
            Debug " ---  fixmePB --- "+#PB_Compiler_Procedure +"( )"
            
            PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
          EndIf
        ElseIf type = 2 ; LeftButtonUp
          If IsWindow( event_window )
            PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp )
            event_window =- 1
            event_gadget =- 1
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
  Define event
  
  OpenWindow(1, 200, 100, 220, 220, "click hire", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200)
  
  OpenWindow(2, 300, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
  CanvasGadget(2, 10, 10, 200, 200)
  
  Repeat 
    event = WaitWindowEvent()
    If event = #PB_Event_Gadget
      If EventType() = #PB_EventType_LeftButtonDown
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
      EndIf
      If EventType() = #PB_EventType_LeftButtonUp
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonUp "
      EndIf
    EndIf
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 0--
; EnableXP