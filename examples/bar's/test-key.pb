XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
  
   Procedure key_events( )
      Select WidgetEvent()
         Case #__event_KeyDown
           Debug " keyDown "+ keyboard( )\key +" ["+ Chr( keyboard( )\key )+"]" 
         Case #__event_Input
            Debug " input "+ keyboard( )\input +" ["+ Chr( keyboard( )\input )+"]"
         Case #__event_KeyUp
            Debug " keyUp "+ keyboard( )\key +" ["+ Chr( keyboard( )\key )+"]" 
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 80, 80, "press any key", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      SetActive( root() )
      SetActiveGadget( GetCanvasGadget() )
      
      Bind( root(), @key_events( ), #__event_KeyDown )
      Bind( root(), @key_events( ), #__event_Input )
      ;Bind( root(), @key_events( ), #__event_KeyUp )
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 25
; Folding = -
; EnableXP
; DPIAware