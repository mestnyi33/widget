XIncludeFile "../../../widgets.pbi" 

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = -3 ; bug fixed
   
   Procedure spin_events( )
      Debug "*g "+GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( )
   EndProcedure
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(Root( ), #PB_Gadget_BackColor, $FFEFEFEF )
      a_init(Root( ))
      
      Define *spin1 = Spin(50, 20, 250, 50, 0, 3)
      SetState(*spin1, 0)
      
      Define *spin2 = Spin(50, 80, 250, 25, min, 3, #__flag_TextCenter|#__flag_vertical);|#__flag_Invert)
      ;Define *spin2 = Spin(50, 80, 250, 25, min, 3, #__spin_Plus)
      SetState(*spin2, 2)
      Define *spin2 = Spin(50, 80+25, 250, 25, min, 0, #__flag_vertical|#__flag_TextCenter);|#__flag_Invert)
      SetState(*spin2, 2)
      
      Define *spin3 = Spin(50, 140, 250, 50, 0, 3, #__flag_TextRight|#__flag_Invert)
      SetState(*spin3, 3)
      
      Bind( #PB_All, @spin_events(), #__event_Change )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 25
; FirstLine = 6
; Folding = -
; EnableXP
; DPIAware