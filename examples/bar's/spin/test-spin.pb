XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = 25 ; bug fixed
   
   Procedure spin_events( )
      Debug "*g "+GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( )
   EndProcedure
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #PB_Gadget_BackColor, $FFEFEFEF )
      a_init(root( ))
      
      Define *spin1 = Spin(50, 20, 250, 50, 0, 30)
      SetState(*spin1, 0)
      
      Define *spin2 = Spin(50, 80, 250, 50, min, 30, #__flag_vertical|#__flag_TextCenter|#__flag_Invert)
      SetState(*spin2, 15)
      
      Define *spin3 = Spin(50, 140, 250, 50, 0, 30, #__flag_TextRight|#__flag_Invert)
      SetState(*spin3, 30)
      
      Bind( #PB_All, @spin_events(), #__event_Change )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 23
; Folding = -
; EnableXP
; DPIAware