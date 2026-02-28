; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Procedure all_events( event, EventObject, EventType, EventData )
      
      Select event
         Case #PB_Event_ActivateWindow
            Debug "active - "+ EventObject
            
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+ EventObject
            
         Case #PB_Event_Gadget
          Protected class.s = GetText(EventObject)
          Select EventType
               Case #__event_MouseWheel
                  If MouseDirection( ) > 0
                     Debug "wheel_vertical - "+class +" "+ EventData
                  Else
                     Debug "wheel_horizontal - "+class +" "+ EventData
                  EndIf
                  
               Case #__event_Focus
                  Debug "focus - "+class +" "+ EventData
                  
               Case #__event_LostFocus
                  Debug "lostfocus - "+class +" "+ EventData
                  
               Case #__event_LeftDown
                  Debug "down - "+class
                  
               Case #__event_LeftUp
                  Debug "up - "+class
                  
               Case #__event_MouseEnter
                  Debug "enter - "+class
                  
               Case #__event_MouseLeave
                  Debug "leave - "+class
                  
               Case #__event_DragStart
                  Debug "drag - "+class
                  
               Case #__event_LeftClick
                  Debug "click - "+class
                  
               Case #__event_Left2Click
                  Debug "2click - "+class
                  
               Case #__event_Left3Click
                  Debug "3click - "+class
                  
            EndSelect
            
      EndSelect
      
   EndProcedure
   
   Procedure _events( )
      If is_root_(EventWidget( ))
         If WidgetEvent( ) = #__event_Focus
            all_events( #PB_Event_ActivateWindow, GetCanvasWindow(EventWidget( )), #PB_All, WidgetEventData( ) )
         EndIf
         If WidgetEvent( ) = #__event_LostFocus
            all_events( #PB_Event_DeactivateWindow, GetCanvasWindow(EventWidget( )), #PB_All, WidgetEventData( ) )
         EndIf
      Else
         all_events( #PB_Event_Gadget, EventWidget( ), WidgetEvent( ), WidgetEventData( ) )
      EndIf
   EndProcedure
   
   Procedure OpenDemo( ID, flag=0 )
      Static X,Y
      Open( ID, X,Y,200,200,"win"+Str(ID), #PB_Window_SystemMenu);|flag)
      Button(40,40,200-80,55, "win"+Str(ID)+"-btn1")
      Button( 40,110,200-80,55, "win"+Str(ID)+"-btn2")
      
      Bind( Root(), @_events())
      X + 100
      Y + 100
   EndProcedure
   
   OpenDemo(1, #PB_Window_NoActivate)
   OpenDemo(2, #PB_Window_NoActivate)
   OpenDemo(3, #PB_Window_NoActivate)
   
   Define event
   Repeat
      event = WaitWindowEvent(1)
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 20
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware