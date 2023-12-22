;-\\ WINDOW OS
XIncludeFile "../events.pbi"

Module events
  ;-
  Procedure  CallBack(eType) ; CGEventTapProxy.i, CGEventType.i, CGEvent.i,  *UserData
    ; Protected *cursor.Cursor::_s_cursor = #Null
    ; Debug "eventTapFunction - "+ID::ClassName(event)
    
    If *setcallback
      Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
      Protected MouseMove, MouseX, MouseY, MoveStart, EnteredID, gadget =- 1
      
      ;       If eType = #NSMouseEntered
      ;         Debug "en "+proxy+" "+CocoaMessage(0, CocoaMessage(0, NSEvent, "window"), "contentView") +" "+CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      ;       If eType = #NSMouseExited
      ;         Debug "le "+proxy+" "+ CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      
      If eType = #PB_EventType_LeftButtonDown
        ;Debug CocoaMessage(0, Mouse::Gadget(Mouse::Window( )), "pressedMouseButtons")
        MouseDrag = 1
      ElseIf eType = #PB_EventType_LeftButtonUp
        MouseDrag = 0
        ;             If EnteredGadget( ) >= 0 
        ;                If DraggedGadget( ) >= 0 And DraggedGadget( ) = PressedGadget( ) 
        ;                   CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
        ;                      CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_Drop)
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
              ; Cursor::change(EnteredGadget( ), 0)
            EndIf
            
            CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ) , #PB_EventType_MouseLeave)
          EndIf
          
          EnteredGadget( ) = gadget
          
          If EnteredGadget( ) >= 0 ;And GadgetType(EnteredGadget( )) = #PB_GadgetType_Canvas
            If Not MouseDrag
              ; Cursor::change(EnteredGadget( ), 1)
            EndIf
            
            CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_MouseEnter)
          EndIf
        Else
          ; mouse drag start
          If MouseDrag > 0
            If EnteredGadget( ) >= 0 And
               DraggedGadget( ) <> PressedGadget( )
              DraggedGadget( ) = PressedGadget( )
              CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_DragStart)
              DeltaX = GadgetX(PressedGadget( )) 
              DeltaY = GadgetY(PressedGadget( ))
            EndIf
          EndIf
          
          If MouseDrag And EnteredGadget( ) <> PressedGadget( )
            CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_MouseMove)
          EndIf
          
          If EnteredGadget( ) >= 0
            CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_MouseMove)
            
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
      If eType = #PB_EventType_LeftButtonDown Or
         eType = #PB_EventType_RightButtonDown
        
        PressedGadget( ) = EnteredGadget( ) ; EventGadget( )
                                            ; Debug CocoaMessage(0, Mouse::Window( ), "focusView")
        
        If PressedGadget( ) >= 0
          If FocusedGadget( ) = - 1
            If GetActiveGadget( )
              If FocusedGadget( ) <> GetActiveGadget( )
                FocusedGadget( ) = GetActiveGadget( )
                ; CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
              EndIf
            EndIf
          EndIf
          
          If FocusedGadget( ) <> PressedGadget( )
            If FocusedGadget( ) >= 0
              CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
            EndIf
            
            FocusedGadget( ) = PressedGadget( )
            CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_Focus)
          EndIf
          
          If eType = #PB_EventType_LeftButtonDown
            CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_LeftButtonDown)
          EndIf
          If eType = #PB_EventType_RightButtonDown
            CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_RightButtonDown)
          EndIf
        EndIf
      EndIf
      
      ;
      If eType = #PB_EventType_LeftButtonUp Or 
         eType = #PB_EventType_RightButtonUp
        
        If PressedGadget( ) >= 0 And 
           PressedGadget( ) <> gadget  
          ; Cursor::change(PressedGadget( ), 0)
        EndIf
        
        If gadget >= 0 And 
           gadget <> PressedGadget( )
          EnteredGadget( ) = gadget
          ; Cursor::change(EnteredGadget( ), 1)
        EndIf
        
        If PressedGadget( ) >= 0 
          If eType = #PB_EventType_LeftButtonUp
            CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_LeftButtonUp)
          EndIf
          If eType = #PB_EventType_RightButtonUp
            CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_RightButtonUp)
          EndIf
        EndIf
        
        ; PressedGadget( ) =- 1
        DraggedGadget( ) =- 1
      EndIf
      
      ;         ;
      ;         If eType = #PB_EventType_LeftDoubleClick
      ;           CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), #PB_EventType_LeftDoubleClick)
      ;         EndIf
      ;          
      ;          If eType = #NSScrollWheel
      ;             Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
      ;             
      ;             If NSEvent
      ;                Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
      ;                Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
      ;                
      ;                If scrollX And Not scrollY
      ;                   ; Debug "X - scroll"
      ;                   If EnteredGadget( ) >= 0
      ;                      CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
      ;                         CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_MouseWheelX, scrollX)
      ;                      CompilerEndIf
      ;                   EndIf
      ;                EndIf
      ;                
      ;                If scrollY And Not scrollX
      ;                   ; Debug "Y - scroll"
      ;                   If EnteredGadget( ) >= 0
      ;                      CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
      ;                         CallFunctionFast(*setcallback, #PB_Event_Gadget, EnteredGadget( ), constants::#PB_EventType_MouseWheelY, scrollY)
      ;                      CompilerEndIf
      ;                   EndIf
      ;                EndIf
      ;             EndIf
      ;          EndIf
      ;          
      ;          If eType = #NSKeyDown 
      ;             Debug "eventtap key down"
      ;          EndIf
      ;          
      ;          If eType = #NSKeyUp
      ;             Debug "eventtap key up"
      ;          EndIf
      ;          
      ;          ;           If eType = #PB_EventType_Resize
      ;          ;             ; CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget( ), #PB_EventType_Resize)
      ;          ;           EndIf
      ;          ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
      ;          ;             If eType = #PB_EventType_Repaint
      ;          ;               CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget( ), #PB_EventType_Repaint)
      ;          ;             EndIf
      ;          ;           CompilerEndIf
      ;           
    EndIf
    
  EndProcedure
  
  Procedure Events( )
    Protected eventgadget
    Protected eventtype
    
    If *setcallback
      Select Event( ) 
        Case #PB_Event_Gadget
          eventtype = EventType( )
          EventGadget = EventGadget( )
          
          If eventtype = #PB_EventType_Resize
            CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ))
          EndIf
          
          
          If EventType = #PB_EventType_Focus 
            ;Debug "f "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
              CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
          ElseIf EventType = #PB_EventType_LostFocus
            ; Debug "l "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
              CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
          ElseIf (EventType = #PB_EventType_KeyDown Or
                  EventType = #PB_EventType_KeyUp Or
                  EventType = #PB_EventType_Input)
            
            CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            ;             ElseIf (EventType = #PB_EventType_RightButtonDown Or
            ;                     EventType = #PB_EventType_RightButtonUp)
            ;                
            ;                CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
          Else
            
            ;CallBack( EventType ) ;\\
            CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            
          EndIf
          
          ;                If eventtype <> #PB_EventType_LeftClick
          ;                   If eventtype = #PB_EventType_MouseEnter
          ;                      EnteredGadget( ) = EventGadget
          ;                   EndIf
          ;                   If eventtype = #PB_EventType_LeftButtonDown
          ;                      PressedGadget( ) = EnteredGadget( )
          ;                   EndIf
          ;                   If eventtype = #PB_EventType_Focus
          ;                      FocusedGadget( ) = EnteredGadget( )
          ;                   EndIf
          ;                   If eventtype = #PB_EventType_LostFocus
          ;                      FocusedGadget( ) = - 1
          ;                   EndIf
          ;                   
          ;                   CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ) )
          ;                EndIf
          
          
          ;                If eventtype <> #PB_EventType_LeftClick
          ;                  If eventtype = #PB_EventType_MouseEnter
          ;                    EnteredGadget( ) = EventGadget
          ;                    CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ) )
          ;                    
          ;                  ElseIf eventtype = #PB_EventType_LeftButtonDown
          ;                    PressedGadget( ) = EnteredGadget( )
          ;                    
          ;                    If PressedGadget( ) >= 0
          ;                      If FocusedGadget( ) = - 1
          ;                        If GetActiveGadget( )
          ;                          If FocusedGadget( ) <> GetActiveGadget( )
          ;                            FocusedGadget( ) = GetActiveGadget( )
          ;                            ; CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
          ;                          EndIf
          ;                        EndIf
          ;                      EndIf
          ;                      
          ;                      If FocusedGadget( ) <> PressedGadget( )
          ;                        If FocusedGadget( ) >= 0
          ;                          CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_LostFocus)
          ;                        EndIf
          ;                        
          ;                        FocusedGadget( ) = PressedGadget( )
          ;                        CallFunctionFast(*setcallback, #PB_Event_Gadget, FocusedGadget( ), #PB_EventType_Focus)
          ;                      EndIf
          ;                      
          ;                      If eventtype = #PB_EventType_LeftButtonDown
          ;                        CallFunctionFast(*setcallback, #PB_Event_Gadget, PressedGadget( ), #PB_EventType_LeftButtonDown)
          ;                      EndIf
          ;                    EndIf
          ;                    
          ;                  ElseIf EventType = #PB_EventType_Focus 
          ;                    ;Debug "f "+FocusedGadget( ) +" "+ PressedGadget( )
          ;                    If FocusedGadget( ) = - 1
          ;                      CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
          ;                    EndIf
          ;                    
          ;                  ElseIf EventType = #PB_EventType_LostFocus
          ;                    ; Debug "l "+FocusedGadget( ) +" "+ PressedGadget( )
          ;                    If FocusedGadget( ) = - 1
          ;                      CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
          ;                    EndIf
          ;                    
          ;                  Else
          ;                    CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ) )
          ;                    
          ;                  EndIf
          ;                EndIf
          ;                
        Case #PB_Event_SizeWindow
          CallFunctionFast(*setcallback, #PB_Event_SizeWindow, #PB_All, #PB_All, #Null )
          
      EndSelect
    EndIf
  EndProcedure
  
  Procedure.i WaitEvent( event.i, second.i = 0 )
    ProcedureReturn event
  EndProcedure
  
  Procedure   SetCallBack(*callback)
    *setcallback = *callback
    
    ;       ;\\
    BindEvent( #PB_Event_Gadget, @Events( ) )
    ;       BindEvent( #PB_Event_ActivateWindow, @Events( ) )
    ;       BindEvent( #PB_Event_DeactivateWindow, @Events( ) )
    ;       BindEvent( #PB_Event_SizeWindow, @Events( ) )
  EndProcedure
EndModule
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 278
; FirstLine = 272
; Folding = --------
; EnableXP