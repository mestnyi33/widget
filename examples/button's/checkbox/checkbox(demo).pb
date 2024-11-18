XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )
Global i

Procedure events_gadgets( )
  ClearDebugOutput( )
  ; Debug ""+EventGadget( )+ " - widget  event - " +EventType( )+ "  state - " +GetGadGetWidgetState( EventGadget( ) ) ; 
  
  Select EventType( )
    Case #PB_EventType_LeftClick
     SetWidgetState( WidgetID( EventGadget( ) ), GetGadGetWidgetState( EventGadget( ) ) )
     Debug  ""+ EventGadget( ) +" - gadget change state " + GetGadGetWidgetState( EventGadget( ) )
     
 EndSelect
EndProcedure

Procedure events_widgets( )
  ClearDebugOutput( )
  ; Debug ""+Str( EventWidget( )\index - 1 )+ " - widget  event - " +WidgetEvent( )+ "  state - " GetWidgetState( EventWidget( ) ) ; 
  
  Select WidgetEvent( )
    Case #__event_Change
      SetGadGetWidgetState( GetIndex( EventWidget( ) ), GetWidgetState( EventWidget( ) ) )
      Debug  Str( GetIndex( EventWidget( ) ) )+" - widget change state " + GetWidgetState( EventWidget( ) )
      
  EndSelect
EndProcedure

Define cr.s = #LF$, Text.s = "this long" + cr + " multiline " + cr + "text"
  
If OpenRoot( 0, 0, 0, 160+160, 110, "CheckBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
  CheckBoxGadget( 0, 10, 10, 140, 20, "CheckBox 1" )
  CheckBoxGadget( 1, 10, 35, 140, 40, Text, #PB_CheckBox_ThreeState )
  CheckBoxGadget( 2, 10, 80, 140, 20, "CheckBox (right)", #PB_CheckBox_Right )
  SetGadGetWidgetState( 0, #PB_Checkbox_Checked )   
  SetGadGetWidgetState( 1, #PB_Checkbox_Inbetween )  
  
  For i = 0 To 2
    BindGadgetEvent( i, @events_gadgets( ) )
  Next
  
  CheckBoxWidget( 10+160, 10, 140, 20, "CheckBox 1" )
  CheckBoxWidget( 10+160, 35, 140, 40, Text, #PB_CheckBox_ThreeState );| #__flag_Textcenter )
  CheckBoxWidget( 10+160, 80, 140, 20, "CheckBox (right)", #PB_CheckBox_Right )
  SetWidgetState( WidgetID( 0 ), #PB_Checkbox_Checked )  
  SetWidgetState( WidgetID( 1 ), #PB_Checkbox_Inbetween )  
  ;BindWidgetEvent( #PB_All, @events_widgets( ) )
  
  For i = 0 To 2
    BindWidgetEvent( WidgetID( i ), @events_widgets( ), #PB_EventType_Change )
  Next
  
  WaitCloseRoot( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 20
; Folding = -
; EnableXP
; DPIAware