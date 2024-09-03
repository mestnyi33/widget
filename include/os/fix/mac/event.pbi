;-\\ MAC OS
XIncludeFile "../events.pbi"

Module events
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
   ;-
   Global psn.q, mask, key.s
   
   Global event_window =- 1
   Global event_gadget =- 1
   
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
                     If eType = #NSLeftMouseDown Or eType = #NSRightMouseDown
                        If GetActiveGadget() <> Gadget 
                           ;;Debug CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "focusView")
                           ; If GetActiveWindow() <> EventWindow()
                           SetActiveGadget( #PB_Default )
                           SetActiveGadget( Gadget )
                           ; EndIf
                        EndIf
                        
                     ElseIf eType = #NSScrollWheel
                        Window = EventWindow( )
                        scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
                        scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
                        
                        If scrollX And Not scrollY
                           ; Debug "X - scroll"
                           CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
                              PostEvent( #PB_Event_Gadget, Window, Gadget, constants::#PB_EventType_MouseWheelX, scrollX )
                           CompilerEndIf
                        EndIf
                        
                        If scrollY And Not scrollX
                           ; Debug "Y - scroll"
                           CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
                              PostEvent( #PB_Event_Gadget, window, Gadget, constants::#PB_EventType_MouseWheelY, scrollY )
                           CompilerEndIf
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
      
   EndProcedure
   
   ProcedureC  _eventTapFunction(proxy, eType, event, refcon) ; CGEventTapProxy.i, CGEventType.i, CGEvent.i,  *UserData
      Protected Point.CGPoint
      Protected *cursor.cursor::_s_cursor = #Null
      ; Debug "eventTapFunction - "+ID::ClassName(event)
      
      If refcon
         Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
         Protected MouseMove, MouseX, MouseY, MoveStart, EnteredID, gadget =- 1
         
         ;       If eType = #NSMouseEntered
         ;         Debug "en "+proxy+" "+CocoaMessage(0, CocoaMessage(0, NSEvent, "window"), "contentView") +" "+CocoaMessage(0, NSEvent, "windowNumber")
         ;       EndIf
         ;       If eType = #NSMouseExited
         ;         Debug "le "+proxy+" "+ CocoaMessage(0, NSEvent, "windowNumber")
         ;       EndIf
         
         If eType = #NSLeftMouseDown
            ;Debug CocoaMessage(0, Mouse::Gadget(Mouse::Window( )), "pressedMouseButtons")
            MouseDrag = 1
         ElseIf eType = #NSLeftMouseUp
            MouseDrag = 0
            ;             If EnteredGadget( ) >= 0 
            ;                If DraggedGadget( ) >= 0 And DraggedGadget( ) = PressedGadget( ) 
            ;                   CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
            ;                      CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_Drop)
            ;                   CompilerEndIf
            ;                EndIf
            ;             EndIf
         EndIf
         
         ;
         If MouseDrag >= 0 
            EnteredID = Mouse::Gadget(Mouse::Window( ))
         EndIf
         
         ;
         If EnteredID
            gadget = ID::Gadget(EnteredID)
            
            If gadget >= 0
               Mousex = GadgetMouseX(gadget)
               Mousey = GadgetMouseY(gadget)
            Else
               Mousex =- 1
               Mousey =- 1
            EndIf
         Else
            Mousex =- 1
            Mousey =- 1
         EndIf
         
         ;
         If MouseDrag And
            Mousex =- 1 And Mousey =- 1
            
            If PressedGadget( ) >= 0
               Mousex = GadgetMouseX(PressedGadget( ))
               Mousey = GadgetMouseY(PressedGadget( ))
            EndIf
         EndIf
         
         If MouseMoveX <> Mousex
            MouseMoveX = Mousex
            MouseMove = #True
         EndIf
         
         If MouseMoveY <> Mousey
            MouseMoveY = Mousey
            MouseMove = #True
         EndIf
         
         ;
         If MouseMove 
            If MouseDrag >= 0 And 
               EnteredGadget( ) <> gadget
               If EnteredGadget( ) >= 0 ;And GadgetType(EnteredGadget( )) = #PB_GadgetType_Canvas
                  If Not MouseDrag
                     Cursor::change(EnteredGadget( ), 0)
                  EndIf
                  
                  CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ) , #PB_EventType_MouseLeave)
               EndIf
               
               EnteredGadget( ) = gadget
               
               If EnteredGadget( ) >= 0 ;And GadgetType(EnteredGadget( )) = #PB_GadgetType_Canvas
                  If Not MouseDrag
                     Cursor::change(EnteredGadget( ), 1)
                  EndIf
                  
                  CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_MouseEnter)
               EndIf
            Else
               ; mouse drag start
               If MouseDrag > 0
                  If EnteredGadget( ) >= 0 And
                     DraggedGadget( ) <> PressedGadget( )
                     DraggedGadget( ) = PressedGadget( )
                     CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_DragStart)
                     DeltaX = GadgetX(PressedGadget( )) 
                     DeltaY = GadgetY(PressedGadget( ))
                  EndIf
               EndIf
               
               If MouseDrag And EnteredGadget( ) <> PressedGadget( )
                  CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_MouseMove)
               EndIf
               
               If EnteredGadget( ) >= 0
                  CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_MouseMove)
                  
                  ; if move gadget x&y position
                  If MouseDrag > 0 And PressedGadget( ) = EnteredGadget( ) 
                     If DeltaX <> GadgetX(PressedGadget( )) Or 
                        DeltaY <> GadgetY(PressedGadget( ))
                        MouseDrag =- 1
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
         ;
         If eType = #NSLeftMouseDown Or
            eType = #NSRightMouseDown
            
            PressedGadget( ) = EnteredGadget( ) ; EventGadget( )
                                                ; Debug CocoaMessage(0, Mouse::Window( ), "focusView")
                                                ;             If GetActiveGadget() <> PressedGadget( ) 
                                                ;                ; If GetActiveWindow() <> EventWindow()
                                                ;                SetActiveGadget( #PB_Default )
                                                ;                SetActiveGadget( PressedGadget( ) )
                                                ;                ; EndIf
                                                ;             EndIf
            If PressedGadget( ) >= 0
               If FocusedGadget( ) = - 1
                  If GetActiveGadget( )
                     If FocusedGadget( ) <> GetActiveGadget( )
                        FocusedGadget( ) = GetActiveGadget( )
                        ; CallCFunctionFast(refcon, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
                     EndIf
                  EndIf
               EndIf
               
               If FocusedGadget( ) <> PressedGadget( )
                  If FocusedGadget( ) >= 0
                     CallCFunctionFast(refcon, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
                  EndIf
                  
                  FocusedGadget( ) = PressedGadget( )
                  CallCFunctionFast(refcon, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_Focus)
               EndIf
               
               If eType = #NSLeftMouseDown
                  CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_LeftButtonDown)
               EndIf
               If eType = #NSRightMouseDown
                  CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_RightButtonDown)
               EndIf
            EndIf
         EndIf
         
         ;
         If eType = #NSLeftMouseUp Or 
            eType = #NSRightMouseUp
            
            If PressedGadget( ) >= 0 And 
               PressedGadget( ) <> gadget  
               Cursor::change(PressedGadget( ), 0)
            EndIf
            
            If gadget >= 0 And 
               gadget <> PressedGadget( )
               EnteredGadget( ) = gadget
               Cursor::change(EnteredGadget( ), 1)
            EndIf
            
            If PressedGadget( ) >= 0 
               If eType = #NSLeftMouseUp
                  CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_LeftButtonUp)
               EndIf
               If eType = #NSRightMouseUp
                  CallCFunctionFast(refcon, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_RightButtonUp)
               EndIf
            EndIf
            
            ; PressedGadget( ) =- 1
            DraggedGadget( ) =- 1
         EndIf
         
         ;         ;
         ;         If eType = #PB_EventType_LeftDoubleClick
         ;           CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_LeftDoubleClick)
         ;         EndIf
         
         If eType = #NSScrollWheel
            Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
            
            If NSEvent
               Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
               Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
               
               If scrollX And Not scrollY
                  ; Debug "X - scroll"
                  If EnteredGadget( ) >= 0
                     CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
                        CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_MouseWheelX, scrollX)
                     CompilerEndIf
                  EndIf
               EndIf
               
               If scrollY And Not scrollX
                  ; Debug "Y - scroll"
                  If EnteredGadget( ) >= 0
                     CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
                        CallCFunctionFast(refcon, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_MouseWheelY, scrollY)
                     CompilerEndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
         If eType = #NSKeyDown 
            Debug "eventtap key down"
         EndIf
         
         If eType = #NSKeyUp
            Debug "eventtap key up"
         EndIf
         
         ;           If eType = #PB_EventType_Resize
         ;             ; CallCFunctionFast(refcon, #PB_Event_Gadget, EventGadget( ), #PB_EventType_Resize)
         ;           EndIf
         ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
         ;             If eType = #PB_EventType_Repaint
         ;               CallCFunctionFast(refcon, #PB_Event_Gadget, EventGadget( ), #PB_EventType_Repaint)
         ;             EndIf
         ;           CompilerEndIf
         ;           
      EndIf
      
   EndProcedure
   
   Procedure GadgetEvents( )
      If *setcallback
         Protected eventtype = EventType( )
         Protected eventGadget = EventGadget( )
         
         If #PB_EventType_Resize = eventtype
            CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ))
         EndIf
         
         If EventType = #PB_EventType_Focus 
            ;Debug "f "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
               CallCFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
         ElseIf EventType = #PB_EventType_LostFocus
            ; Debug "l "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
               CallCFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
         ElseIf (EventType = #PB_EventType_KeyDown Or
                 EventType = #PB_EventType_KeyUp Or
                 EventType = #PB_EventType_Input)
            
            CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
         Else
            
            If FocusedGadget( ) = - 1
               CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure ResizeEvents( )
      If *setcallback
         CallFunctionFast(*setcallback, #PB_Event_SizeWindow, #PB_All, #PB_All, EventData( ) )
      EndIf
   EndProcedure
   
   Procedure ActivateEvents( )
      If *setcallback
         CallFunctionFast(*setcallback, #PB_Event_ActivateWindow, #PB_All, #PB_All, EventData( ) )
      EndIf
   EndProcedure
   
   Procedure DeactivateEvents( )
      If *setcallback
         CallFunctionFast(*setcallback, #PB_Event_DeactivateWindow, #PB_All, #PB_All, EventData( ) )
      EndIf
   EndProcedure
   
   Procedure.i WaitEvent( event.i, second.i = 0 )
      ;       Protected EventGadget, EventType, EventData
      ;       
      ;       If *setcallback 
      ;          ;          If event = #PB_Event_ActivateWindow
      ;          ;              Debug " WaitEvent - ActivateWindow"
      ;          ;             ;CallCFunctionFast(*setcallback, #PB_Event_ActivateWindow, #PB_All, #PB_EventType_Focus, #Null )
      ;          ;          EndIf
      ;          ;          
      ;          ;          If event = #PB_Event_DeactivateWindow
      ;          ;              Debug " WaitEvent - DeactivateWindow"
      ;          ;             ;CallCFunctionFast(*setcallback, #PB_Event_DeactivateWindow, #PB_All, #PB_EventType_LostFocus, #Null )
      ;          ;          EndIf
      ;          
      ;          If event = #PB_Event_Gadget
      ;             EventGadget = EventGadget( )
      ;             EventType   = EventType( )
      ;             EventData   = EventData( )
      ;             
      ;             
      ; ;             If EventType = #PB_EventType_Focus 
      ; ;                ;Debug "f "+FocusedGadget( ) +" "+ PressedGadget( )
      ; ;                If FocusedGadget( ) = - 1
      ; ;                   CallCFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData )
      ; ;                EndIf
      ; ;             ElseIf EventType = #PB_EventType_LostFocus
      ; ;                ; Debug "l "+FocusedGadget( ) +" "+ PressedGadget( )
      ; ;                If FocusedGadget( ) = - 1
      ; ;                   CallCFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData )
      ; ;                EndIf
      ; ;             ElseIf (EventType = #PB_EventType_KeyDown Or
      ; ;                     EventType = #PB_EventType_KeyUp Or
      ; ;                     EventType = #PB_EventType_Input)
      ; ;                
      ; ;                CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData )
      ; ; ;             ElseIf (EventType = #PB_EventType_RightButtonDown Or
      ; ; ;                     EventType = #PB_EventType_RightButtonUp)
      ; ; ;                
      ; ; ;                CallCFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData )
      ; ;             Else
      ; ;                
      ; ;               ;\\ CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData )
      ; ;                
      ; ;             EndIf
      ;          EndIf
      ;       EndIf
      ;       
      ProcedureReturn event
   EndProcedure
   
   Procedure   SetCallBack( *callback )
      *setcallback = *callback
      
      Protected mask, EventTap
      mask = #NSMouseMovedMask | #NSScrollWheelMask
      mask | #NSMouseEnteredMask | #NSMouseExitedMask  ;| #NSCursorUpdateMask
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
      
      If *callback
         ;       ;\\
         BindEvent( #PB_Event_Gadget, @GadgetEvents( ) )
         CompilerIf #PB_Compiler_IsMainFile ; TEST
            BindEvent( #PB_Event_ActivateWindow, @ActivateEvents( ) )
            BindEvent( #PB_Event_DeactivateWindow, @DeactivateEvents( ) )
            ;       BindEvent( #PB_Event_SizeWindow, @ResizeEvents( ) )
         CompilerEndIf
      EndIf
   EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
   
   Procedure events(event, EventGadget, EventType, EventData )
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
   
   Procedure Open( id, flag=0 )
      Static x,y
      OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
      CanvasGadget( id, 40,40,200-80,55, #PB_Canvas_Keyboard );| #PB_Canvas_Container) : CloseGadgetList()
      CanvasGadget( 10+id, 40,110,200-80,55, #PB_Canvas_Keyboard)
      x + 100
      y + 100
   EndProcedure
   
   
   events::setCallBack( @events())
   
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
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 494
; FirstLine = 225
; Folding = -v7------------
; EnableXP