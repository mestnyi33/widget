XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = - 25 
   
   Procedure g_spin_change_event( )
      Debug "["+ GetGadgetState(EventGadget()) +"] - "+ #PB_Compiler_Procedure
   EndProcedure
   
   Procedure spin_focus_event( )
      Debug ""+ GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( ) +" [FOCUS] - "+ GetClass(EventWidget())
   EndProcedure
   
   Procedure spin_lostfocus_event( )
      Debug "["+ GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( ) +"[ - LOSTFOCUS "+ GetClass(EventWidget())
   EndProcedure
   
   Procedure spin_change_event( )
      Debug ""+ GetState(EventWidget()) +" "+ WidgetEventItem( ) +" "+ WidgetEventData( ) +" [CHANGE] - "+ GetClass(EventWidget())
      SetActive( EventWidget( )\stringbar )
   EndProcedure
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #PB_Gadget_BackColor, $FFEFEFEF )
      a_init(root( ))
      
      Define g = SpinGadget(#PB_Any, 50, 20, 100, 50, min, 30, #PB_Spin_Numeric);|#PB_Spin_ReadOnly )
      SetGadgetState(g, 0)
      
      Define *g = Spin(50, 80, 100, 50, min, 30, #__flag_TextRight);|#__flag_TextReadOnly)
      ;Debug "//"
      SetState(*g, 0)
     
      ;Debug "---"
      BindGadgetEvent( g, @g_spin_change_event(), #PB_EventType_Change )
      Bind( *g, @spin_change_event(), #__event_Change )
      Bind( *g, @spin_focus_event(), #__event_Focus )
      Bind( *g, @spin_lostfocus_event(), #__event_LostFocus )
      WaitClose( )
   EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 37
; FirstLine = 3
; Folding = 4-
; EnableXP
; DPIAware