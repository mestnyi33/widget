XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
  
   Procedure key_events( )
      Debug ""+ ClassFromEvent(WidgetEvent()) +" "+
            keyboard( )\key +" "+ Chr( keyboard( )\key ) +" "+ 
            keyboard( )\input +" "+ Chr( keyboard( )\input )
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "press key_R to replace object", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      
      SetActive( root() )
      SetActiveGadget( GetCanvasGadget() )
      
      Bind( root(), @key_events( ), #__event_KeyDown )
      Bind( root(), @key_events( ), #__event_Input )
      ;Bind( root(), @key_events( ), #__event_KeyUp )
      
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware