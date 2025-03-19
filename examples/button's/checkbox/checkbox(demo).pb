XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )
Global i

Procedure events_gadgets( )
  ClearDebugOutput( )
  ; Debug ""+EventGadget( )+ " - widget  event - " +EventType( )+ "  state - " +GetGadgetState( EventGadget( ) ) ; 
  
  Select EventType( )
    Case #PB_EventType_LeftClick
     SetState( ID( EventGadget( ) ), GetGadgetState( EventGadget( ) ) )
     Debug  ""+ EventGadget( ) +" - gadget change state " + GetGadgetState( EventGadget( ) )
     
 EndSelect
EndProcedure

Procedure events_widgets( )
  ClearDebugOutput( )
  ; Debug ""+Str( EventWidget( )\index - 1 )+ " - widget  event - " +WidgetEvent( )+ "  state - " GetState( EventWidget( ) ) ; 
  
  Select WidgetEvent( )
    Case #__event_Change
      SetGadgetState( Index( EventWidget( ) ), GetState( EventWidget( ) ) )
      Debug  Str( Index( EventWidget( ) ) )+" - widget change state " + GetState( EventWidget( ) )
      
  EndSelect
EndProcedure

Define cr.s = #LF$, Text.s = "this long" + cr + " multiline " + cr + "text"
  
If Open( 0, 0, 0, 160+160, 110, "CheckBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
  CheckBoxGadget( 0, 10, 10, 140, 20, "CheckBox 1" )
  CheckBoxGadget( 1, 10, 35, 140, 40, Text, #PB_CheckBox_ThreeState )
  CheckBoxGadget( 2, 10, 80, 140, 20, "CheckBox (right)", #PB_CheckBox_Right )
  SetGadgetState( 0, #PB_Checkbox_Checked )   
  SetGadgetState( 1, #PB_Checkbox_Inbetween )  
  
  For i = 0 To 2
    BindGadgetEvent( i, @events_gadgets( ) )
  Next
  
  CheckBox( 10+160, 10, 140, 20, "CheckBox 1" )
  CheckBox( 10+160, 35, 140, 40, Text, #PB_CheckBox_ThreeState );| #__flag_text_Center )
  CheckBox( 10+160, 80, 140, 20, "CheckBox (right)", #PB_CheckBox_Right )
  SetState( ID( 0 ), #PB_Checkbox_Checked )  
  SetState( ID( 1 ), #PB_Checkbox_Inbetween )  
  ;Bind( #PB_All, @events_widgets( ) )
  
  For i = 0 To 2
    Bind( ID( i ), @events_widgets( ), #PB_EventType_Change )
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 44
; FirstLine = 32
; Folding = -
; EnableXP
; DPIAware