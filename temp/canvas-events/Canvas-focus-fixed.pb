; bug when clicking on the canvas in an inactive window
EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   #LeftMouseDownMask      = 1 << 1
   #LeftMouseUpMask        = 1 << 2
   #RightMouseDownMask     = 1 << 3
   #RightMouseUpMask       = 1 << 4
   #MouseMovedMask         = 1 << 5
   #LeftMouseDraggedMask   = 1 << 6
   #RightMouseDraggedMask  = 1 << 7
   #KeyDownMask            = 1 << 10
   #KeyUpMask              = 1 << 11
   #FlagsChangedMask       = 1 << 12
   #ScrollWheelMask        = 1 << 22
   #OtherMouseDownMask     = 1 << 25
   #OtherMouseUpMask       = 1 << 26
   #OtherMouseDraggedMask  = 1 << 27
   
   ImportC ""
      CFRunLoopAddCommonMode(rl, mode)
      CFRunLoopGetCurrent()
      CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
      GetCurrentProcess(*psn)
   EndImport
   
   DeclareC eventTapFunction(proxy, type, event, refcon)
   
   Global psn.q, mask, eventTap, key.s
   
   ; CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), CocoaMessage(0, 0, "NSString stringWithString:$", @"NSEventTrackingRunLoopMode"))
   
   mask = #LeftMouseDownMask | #LeftMouseUpMask
   mask | #RightMouseDownMask | #RightMouseUpMask
   mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
   mask | #KeyDownMask
   
   GetCurrentProcess(@psn.q)
   eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
   If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
   EndIf
   
   ; callback function
   
   ProcedureC eventTapFunction(proxy, type, event, refcon)
      Protected Gadget, NSClass, NSEvent, Window, View, Point.NSPoint
      
      If type = 1
         NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
         If NSEvent
            ;
            Window = CocoaMessage(0, NSEvent, "window")
            If Window
               CocoaMessage(@Point, NSEvent, "locationInWindow")
               ;
               View = CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "hitTest:@", @Point)
               If View
                  CocoaMessage( @NSClass, CocoaMessage( 0, View, "className" ), "UTF8String" )
                  ;
                  If NSClass And 
                     PeekS( NSClass, -1, #PB_UTF8 ) = "PB_NSFlippedView"
                     View = CocoaMessage(0, View, "superview")
                  EndIf
                  ;
                  Gadget = CocoaMessage(0, View, "tag")
                  If IsGadget( Gadget )
                     If GetActiveGadget() <> Gadget 
                        ; If GetActiveWindow() <> EventWindow()
                           SetActiveGadget( #PB_Default )
                           SetActiveGadget( Gadget )
                        ; EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
            
         EndIf
      EndIf
      
   EndProcedure
CompilerEndIf


; *** test ***
CompilerIf #PB_Compiler_IsMainFile
   
   Procedure Open( id, flag=0 )
      Static x,y
      OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
      CanvasGadget( id, 40,40,200-80,55, #PB_Canvas_Keyboard | #PB_Canvas_Container) : CloseGadgetList()
      CanvasGadget( 10+id, 40,110,200-80,55, #PB_Canvas_Keyboard)
      x + 100
      y + 100
   EndProcedure
   
   
   
   Open(1, #PB_Window_NoActivate)
   Open(2, #PB_Window_NoActivate)
   Open(3, #PB_Window_NoActivate)
   
   Define event
   Repeat
      event = WaitWindowEvent(1)
      
      Select event
         Case #PB_Event_ActivateWindow
            Debug "active - "+ EventWindow()
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+ EventWindow()
            
         Case #PB_Event_Gadget
            Select EventType()
               Case #PB_EventType_Focus
                  Debug "focus - "+EventGadget() +" "+ EventData()
                  ;SetActiveGadget(EventGadget())
                  
               Case #PB_EventType_LostFocus
                  Debug "lostfocus - "+EventGadget() +" "+ EventData()
                  
               Case #PB_EventType_LeftButtonDown
                  Debug "down - "+EventGadget()
                  
               Case #PB_EventType_LeftButtonUp
                  Debug "up - "+EventGadget()
                  
            EndSelect
            
      EndSelect
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 94
; FirstLine = 87
; Folding = ---
; EnableXP