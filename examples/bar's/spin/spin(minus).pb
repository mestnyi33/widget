XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = - 25 
   
   Procedure spin_g_events( )
      Debug "g "+GetGadgetState(EventGadget())
   EndProcedure
   
   Procedure spin_events( )
      Debug "*g "+GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( )
   EndProcedure
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #PB_Gadget_BackColor, $FFEFEFEF )
      a_init(root( ))
      
      Define g = SpinGadget(#PB_Any, 50, 20, 100, 50, min, 30, #PB_Spin_Numeric|#PB_Spin_ReadOnly )
      SetGadgetState(g, 0)
      
      Define *g = Spin(50, 80, 100, 50, min, 30, #__flag_TextRight)
      Debug "//"
      SetState(*g, 0)
     
      Debug "---"
      BindGadgetEvent( g, @spin_g_events(), #PB_EventType_Change )
      Bind( *g, @spin_events(), #__event_Change )
      WaitClose( )
   EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; DPIAware