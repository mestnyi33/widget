; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Procedure events(event, EventObject, EventType, EventData )
      
      Select event
         Case #PB_Event_ActivateWindow
            Debug "active - "+ EventObject
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+ EventObject
            
         Case #PB_Event_Gadget
            Select EventType
;                Case #__event_MouseWheel
;                   Debug "wheel - "+EventObject
                  
               Case #__event_MouseWheelX
                  Debug "wheelX - "+EventObject +" "+ EventData
                  
               Case #__event_MouseWheelY
                  Debug "wheelY - "+EventObject +" "+ EventData
                  
               Case #__event_Focus
                  Debug "focus - "+EventObject +" "+ EventData
                  
               Case #__event_LostFocus
                  Debug "lostfocus - "+EventObject +" "+ EventData
                  
               Case #__event_LeftDown
                  Debug "down - "+EventObject
                  
               Case #__event_LeftUp
                  Debug "up - "+EventObject
                  
               Case #__event_MouseEnter
                  Debug "enter - "+EventObject
                  
               Case #__event_MouseLeave
                  Debug "leave - "+EventObject
                  
               Case #__event_DragStart
                  Debug "drag - "+EventObject
                  
               Case #__event_LeftClick
                  Debug "click - "+EventObject
                  
               Case #__event_Left2Click
                  Debug "2click - "+EventObject
                  
               Case #__event_Left3Click
                  Debug "3click - "+EventObject
                  
            EndSelect
            
      EndSelect
      
   EndProcedure
   
   Procedure _events( )
      If is_root_(eventWidget( ))
         If WidgetEvent( ) = #__event_Focus
            events( #PB_Event_ActivateWindow, GetWindow(eventWidget( )), #PB_All, widgetEventData( ) )
         EndIf
         If WidgetEvent( ) = #__event_LostFocus
            events( #PB_Event_DeactivateWindow, GetWindow(eventWidget( )), #PB_All, widgetEventData( ) )
         EndIf
      Else
         events( #PB_Event_Gadget, eventWidget( ), WidgetEvent( ), widgetEventData( ) )
      EndIf
   EndProcedure
   
   Procedure OpenDemo( id, flag=0 )
      Static x,y
      Open( id, x,y,200,200,"win"+Str(id), #PB_Window_SystemMenu);|flag)
      Button(40,40,200-80,55, "win"+Str(id)+"-btn1")
      Button( 40,110,200-80,55, "win"+Str(id)+"-btn2")
      
      Bind( root(), @_events())
      x + 100
      y + 100
   EndProcedure
   
   OpenDemo(1, #PB_Window_NoActivate)
   OpenDemo(2, #PB_Window_NoActivate)
   OpenDemo(3, #PB_Window_NoActivate)
   
   Define event
   Repeat
      event = WaitWindowEvent(1)
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 31
; Folding = --
; EnableXP
; DPIAware