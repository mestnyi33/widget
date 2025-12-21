;-\\ MAC OS
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../events.pbi"
CompilerEndIf

Module Events
   ;   #NSLeftMouseDown      = 1
   ;   #NSLeftMouseUp        = 2
   ;   #NSRightMouseDown     = 3
   ;   #NSRightMouseUp       = 4
   ;   #NSMouseMoved         = 5
   ;   #NSLeftMouseDragged   = 6
   ;   #NSRightMouseDragged  = 7
   ;   #NSMouseEntered       = 8
   ;   #NSMouseExited        = 9
   ;   #NSKeyDown            = 10
   ;   #NSKeyUp              = 11
   ;   #NSFlagsChanged       = 12
   ;   #NSAppKitDefined      = 13
   ;   #NSSystemDefined      = 14
   ;   #NSApplicationDefined = 15
   ;   #NSPeriodic           = 16
   ;   #NSCursorUpdate       = 17
   ;   #NSScrollWheel        = 22
   ;   #NSTabletPoint        = 23
   ;   #NSTabletProximity    = 24
   ;   #NSOtherMouseDown     = 25
   ;   #NSOtherMouseUp       = 26
   ;   #NSOtherMouseDragged  = 27
   ;   #NSEventTypeGesture   = 29
   ;   #NSEventTypeMagnify   = 30
   ;   #NSEventTypeSwipe     = 31
   ;   #NSEventTypeRotate    = 18
   ;   #NSEventTypeBeginGesture = 19
   ;   #NSEventTypeEndGesture   = 20
   ;   #NSEventTypeSmartMagnify = 32
   ;   #NSEventTypeQuickLook   = 33
   
   Global psn.q, mask, key.s
   
   ImportC ""
      CFRunLoopGetCurrent( )
      CFRunLoopAddCommonMode(rl, mode)
      
      CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
      
      ;     GetCurrentProcess(*psn)
      ;     CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
      
      GetCurrentProcess(*ProcessSerialNumber)
      CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.i, CGEventTapOptions.i, CGEventMask.q, CGEventTapCallback.i, *UserData)
   EndImport
   
   ProcedureC eventTapFunction(proxy, eType, event, refcon)
         Protected Gadget, scrollX, scrollY, NSClass, NSEvent, Window, View, Point.NSPoint
         
         If refcon
           If eType = #NSScrollWheel Or
              eType = #NSLeftMouseDown Or eType = #NSRightMouseDown 
             
             NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
             If NSEvent
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
                     If GetActiveGadget( ) <> Gadget 
                       If GetActiveGadget() 
                         SetActiveGadget( #PB_Default )
                       EndIf
                       ; SetActiveWindow( EventWindow( ))
                       SetActiveGadget( Gadget )
                     EndIf
                     
                     If eType = #NSScrollWheel
                       Window = EventWindow( )
                       scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
                       scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
                       
                       If scrollX And Not scrollY
                         ; Debug "X - scroll"
                         CompilerIf Defined(PB_EventType_MouseWheelY, #PB_Constant) 
                           CallCFunctionFast(refcon, Gadget, #PB_EventType_MouseWheelX, scrollX )
                         CompilerEndIf
                       EndIf
                       
                       If scrollY And Not scrollX
                         ; Debug "Y - scroll"
                         CompilerIf Defined(PB_EventType_MouseWheelX, #PB_Constant) 
                           CallCFunctionFast(refcon, Gadget, #PB_EventType_MouseWheelY, scrollY )
                         CompilerEndIf
                       EndIf
                     EndIf
                   EndIf
                 EndIf
               EndIf
             EndIf
           EndIf
         EndIf
         
      EndProcedure
      
;    Procedure.i WaitEvent( event.i, second.i = 0 )
;      ProcedureReturn event
;    EndProcedure
   
   Procedure   SetCallBack( *callback )
      Protected mask, EventTap
      mask = #NSMouseMovedMask | #NSScrollWheelMask
     ; mask | #NSMouseEnteredMask | #NSMouseExitedMask  ;| #NSCursorUpdateMask
      mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask | #NSOtherMouseUpMask
      mask | #NSRightMouseDownMask | #NSRightMouseDownMask | #NSOtherMouseDownMask
      mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask | #NSOtherMouseDraggedMask 
      mask | #NSKeyDownMask | #NSKeyUpMask
      
      ;mask = #kCGEventForAllEventsMask
      
      #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
      #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
      #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
      
      #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
      #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
      
      ;\\
      GetCurrentProcess( @psn )
      eventTap = CGEventTapCreateForPSN( @psn, #headInsertEventTap, 1, mask, @eventTapFunction( ), *callback )
      
      ;\\ с ним mousemove не происходит если приложение не активно
      ; eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction( ), *callback)
      
      ;\\
      If eventTap
         CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
      EndIf
      
      ;\\
      ; CFRelease_(eventTap)
    EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
   
   Procedure Events(event, EventGadget, EventType, EventData )
      ;ProcedureReturn 1
      Select event
         Case #PB_Event_ActivateWindow
            Debug "active - "+ EventWindow()
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+ EventWindow()
            
         Case #PB_Event_Gadget
            Select EventType
;                Case #PB_EventType_MouseWheel
;                   Debug "wheel - "+EventGadget
                  
               Case constants::#PB_EventType_MouseWheelX
                  Debug "wheelX - "+EventGadget +" "+ EventData
                  
               Case constants::#PB_EventType_MouseWheelY
                  Debug "wheelY - "+EventGadget +" "+ EventData
                  
               Case #PB_EventType_Focus
                  Debug "focus - "+EventGadget +" "+ EventData
                  
               Case #PB_EventType_LostFocus
                  Debug "lostfocus - "+EventGadget +" "+ EventData
                  
               Case #PB_EventType_LeftButtonDown
                  Debug "down - "+EventGadget
                  
               Case #PB_EventType_LeftButtonUp
                  Debug "up - "+EventGadget
                  
               Case #PB_EventType_MouseEnter
                  Debug "enter - "+EventGadget
                  
               Case #PB_EventType_MouseLeave
                  Debug "leave - "+EventGadget
                  
               Case #PB_EventType_DragStart
                  Debug "drag - "+EventGadget
                  
               Case #PB_EventType_LeftClick
                  Debug "click - "+EventGadget
                  
               Case #PB_EventType_LeftDoubleClick
                  Debug "2click - "+EventGadget
                  
            EndSelect
            
      EndSelect
      
   EndProcedure
   
   Procedure Open( ID, Flag=0 )
      Static X,Y
      OpenWindow( ID, X,Y,200,200,"window_"+Str(ID), #PB_Window_SystemMenu|Flag)
      CanvasGadget( ID, 40,40,200-80,55, #PB_Canvas_Keyboard );| #PB_Canvas_Container) : CloseGadgetList()
      CanvasGadget( 10+ID, 40,110,200-80,55, #PB_Canvas_Keyboard)
      X + 100
      Y + 100
   EndProcedure
   
   
   Events::setCallBack( @events())
   
   Open(1, #PB_Window_NoActivate)
   Open(2, #PB_Window_NoActivate)
   Open(3, #PB_Window_NoActivate)
   
   Define event
   Repeat
      event = WaitWindowEvent(1)
      
      ;       Select event
      ;          Case #PB_Event_ActivateWindow
      ;             Debug "active - "+ EventWindow()
      ;          Case #PB_Event_DeactivateWindow
      ;             Debug "deactive - "+ EventWindow()
      ;             
      ;          Case #PB_Event_Gadget
      ;             Select EventType()
      ;                Case #PB_EventType_Focus
      ;                   Debug "focus - "+EventGadget() +" "+ EventData()
      ;                   ;SetActiveGadget(EventGadget())
      ;                   
      ;                Case #PB_EventType_LostFocus
      ;                   Debug "lostfocus - "+EventGadget() +" "+ EventData()
      ;                   
      ;                Case #PB_EventType_LeftButtonDown
      ;                   Debug "down - "+EventGadget()
      ;                   
      ;                Case #PB_EventType_LeftButtonUp
      ;                   Debug "up - "+EventGadget()
      ;                
      ;           Case #PB_EventType_MouseEnter
      ;                   Debug "enter - "+EventGadget
      ;                   
      ;                Case #PB_EventType_MouseLeave
      ;                   Debug "leave - "+EventGadget
      ;                   
      ;            
      ;             EndSelect
      ;             
      ;       EndSelect
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.46 LTS (MacOS X - x64)
; CursorPosition = 2
; Folding = 6--0-
; EnableXP