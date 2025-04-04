﻿; bug when clicking on the canvas in an inactive window
EnableExplicit

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
   Static gadget = #PB_Any
   Protected NSEvent, Window, View, Point.NSPoint
   
   If type > 0 And type < 29
      NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
      
      If NSEvent
         Window = CocoaMessage(0, NSEvent, "window")
         
         If Window
            CocoaMessage(@Point, NSEvent, "locationInWindow")
            View = CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "hitTest:@", @Point)
            
            If type = 1
               If GetActiveWindow() <> EventWindow()
                  gadget = CocoaMessage(0, View, "tag")
                  If IsGadget( gadget )
                     SetActiveGadget(gadget)
                     ;PostEvent( #PB_Event_Gadget, EventWindow() ,gadget, #PB_EventType_LeftButtonDown )
                  EndIf
               EndIf
            ElseIf type = 2
               If IsGadget( gadget )
                  ;PostEvent( #PB_Event_Gadget, EventWindow() ,gadget, #PB_EventType_LeftButtonUp )
               EndIf
               gadget = #PB_Any
            EndIf
         Else
            If type = 10
               key.s = PeekS(CocoaMessage(0, CocoaMessage(0, NSEvent, "charactersIgnoringModifiers"), "UTF8String"), 1, #PB_UTF8)
               Debug "Key " + key + " pressed (key code : " + Str(CocoaMessage(0, NSEvent, "keyCode")) + ")"
            EndIf
         EndIf
         
      EndIf
   EndIf
   
EndProcedure



; *** test ***
CompilerIf #PB_Compiler_IsMainFile
   
   ; If OpenWindow(0, 0, 0, 220, 120, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;   ButtonGadget(0, 10, 10, 200, 30, "Button 0")
   ;   ButtonGadget(1, 10, 40, 200, 30, "Button 1")
   ;   ScrollBarGadget(2, 10, 70, 200, 30, 0, 100, 1)
   ;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   ; EndIf
   
   OpenWindow(0, 200, 100, 220, 220, "click hire", #PB_Window_SystemMenu)
   CanvasGadget(0, 10, 10, 200, 200, #PB_Canvas_Keyboard)
   
   OpenWindow(1, 300, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
   CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard)
   
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
                  Debug "focus - "+EventGadget()
               Case #PB_EventType_LostFocus
                  Debug "lostfocus - "+EventGadget()
                  
               Case #PB_EventType_LeftButtonDown
                  Debug "down - "+EventGadget()
                  
               Case #PB_EventType_LeftButtonUp
                  Debug "up - "+EventGadget()
                  
            EndSelect
            
      EndSelect
      
   Until event = #PB_Event_CloseWindow
   
   
   
   
   ; ; ; bug when clicking on the canvas in an inactive window
   ; ; EnableExplicit
   ; ; 
   ; ; #LeftMouseDownMask      = 1 << 1
   ; ; #LeftMouseUpMask        = 1 << 2
   ; ; ; #RightMouseDownMask     = 1 << 3
   ; ; ; #RightMouseUpMask       = 1 << 4
   ; ; ; #MouseMovedMask         = 1 << 5
   ; ; ; #LeftMouseDraggedMask   = 1 << 6
   ; ; ; #RightMouseDraggedMask  = 1 << 7
   ; ; ; #KeyDownMask            = 1 << 10
   ; ; ; #KeyUpMask              = 1 << 11
   ; ; ; #FlagsChangedMask       = 1 << 12
   ; ; ; #ScrollWheelMask        = 1 << 22
   ; ; ; #OtherMouseDownMask     = 1 << 25
   ; ; ; #OtherMouseUpMask       = 1 << 26
   ; ; ; #OtherMouseDraggedMask  = 1 << 27
   ; ; 
   ; ; Global psn.q, mask, eventTap, key.s
   ; ; 
   ; ; ImportC ""
   ; ;   CFRunLoopGetCurrent()
   ; ;   CFRunLoopAddCommonMode(rl, mode)
   ; ;   
   ; ;   GetCurrentProcess(*psn)
   ; ;   CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
   ; ; EndImport
   ; ; 
   ; ; GetCurrentProcess(@psn.q)
   ; ; 
   ; ; mask = #LeftMouseDownMask | #LeftMouseUpMask
   ; ; ; mask | #RightMouseDownMask | #RightMouseUpMask
   ; ; ; mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
   ; ; ; mask | #KeyDownMask
   ; ; 
   ; ; ; callback function
   ; ; ProcedureC eventTapFunction(proxy, type, event, refcon)
   ; ;   Static window =- 1
   ; ;   
   ; ;   If GetActiveWindow( ) <> EventWindow( )
   ; ;     window = EventWindow( )
   ; ;   EndIf
   ; ;   
   ; ;   If IsWindow( window )
   ; ;     If type = 1 ; LeftButtonDown
   ; ;       PostEvent( #PB_Event_Gadget , EventWindow( ), EventGadget( ), #PB_EventType_LeftButtonDown )
   ; ;       
   ; ;     ElseIf type = 2 ; LeftButtonUp
   ; ;       PostEvent( #PB_Event_Gadget , EventWindow( ), EventGadget( ), #PB_EventType_LeftButtonUp )
   ; ;       window =- 1
   ; ;     EndIf
   ; ;   EndIf
   ; ; EndProcedure
   ; ; 
   ; ; eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
   ; ; If eventTap
   ; ;   CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
   ; ; EndIf
   ; ; 
   ; ; 
   ; ; CompilerIf #PB_Compiler_IsMainFile
   ; ;   ; *** test ***
   ; ;   Procedure events_gadgets()
   ; ;     Select EventType()
   ; ;       Case #PB_EventType_LeftButtonDown,
   ; ;            #PB_EventType_LeftButtonUp
   ; ;         
   ; ;         Debug #PB_Compiler_Procedure +" "+ EventGadget() +" "+ EventType()
   ; ;     EndSelect
   ; ;   EndProcedure
   ; ;   
   ; ;   OpenWindow(0, 200, 100, 220, 220, "click hire", #PB_Window_SystemMenu)
   ; ;   CanvasGadget(0, 10, 10, 200, 200)
   ; ;   
   ; ;   OpenWindow(1, 300, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
   ; ;   CanvasGadget(1, 10, 10, 200, 200)
   ; ;   
   ; ;   BindEvent( #PB_Event_Gadget, @events_gadgets() )
   ; ;   
   ; ;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   ; ; CompilerEndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 68
; FirstLine = 54
; Folding = ---
; EnableXP