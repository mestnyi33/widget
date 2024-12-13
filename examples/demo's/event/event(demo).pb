; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Procedure Events(event, EventObject, EventType, EventData )
      
      Select event
         Case #PB_Event_ActivateWindow
            Debug "active - "+ EventObject
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+ EventObject
            
         Case #PB_Event_Gadget
            Select EventType
;                Case #__event_MouseWheel
;                   Debug "wheel - "+EventObject
                  
               Case #__event_MouseWheel
                  If MouseWheelDirection( ) > 0
                     Debug "wheelvertical - "+EventObject +" "+ EventData +" "+ MouseWheelData( ) +" "+ MouseData( )
                  Else
                     Debug "wheelhorizontal - "+EventObject +" "+ EventData +" "+ MouseWheelData( ) +" "+ MouseData( )
                  EndIf
                  
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
      If is_root_(EventWidget( ))
         If WidgetEvent( ) = #__event_Focus
            Events( #PB_Event_ActivateWindow, GetCanvasWindow(EventWidget( )), #PB_All, WidgetEventData( ) )
         EndIf
         If WidgetEvent( ) = #__event_LostFocus
            Events( #PB_Event_DeactivateWindow, GetCanvasWindow(EventWidget( )), #PB_All, WidgetEventData( ) )
         EndIf
      Else
         Events( #PB_Event_Gadget, EventWidget( ), WidgetEvent( ), WidgetEventData( ) )
      EndIf
   EndProcedure
   
   Procedure OpenDemo( ID, flag=0 )
      Static X,Y
      Open( ID, X,Y,200,200,"win"+Str(ID), #PB_Window_SystemMenu);|flag)
      Button(40,40,200-80,55, "win"+Str(ID)+"-btn1")
      Button( 40,110,200-80,55, "win"+Str(ID)+"-btn2")
      
      Bind( root(), @_events())
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 14
; Folding = --
; EnableXP
; DPIAware