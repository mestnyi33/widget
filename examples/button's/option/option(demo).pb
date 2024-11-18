XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global i
   
   Procedure events_gadgets( )
      Protected event = EventType( )
      Debug ""+event+ " - event gadget - " +EventGadget( ) ;+ " state - " +GetGadGetWidgetState(EventGadget( )) ; 
      
      Select event
         Case #PB_EventType_LeftClick
            SetWidgetState(ID(EventGadget( )), GetGadGetWidgetState(EventGadget( )))
      EndSelect
   EndProcedure
   
   Procedure events_widgets( )
      Protected event = WidgetEvent( )
      Debug ""+event+ " - event widget - " +Str(Index(EventWidget( ))) ;+ " state - "+ GetWidgetState(EventWidget( )) ; 
      
      Select event
         Case #__Event_Change
            SetGadGetWidgetState(Index(EventWidget( )), GetWidgetState(EventWidget( )))
      EndSelect
   EndProcedure
   
   ;
   If OpenRoot(0, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;
      OptionGadget(0, 10, 20, 115, 20, "Option 1") 
      OptionGadget(1, 10, 45, 115, 20, "Option 2")
      OptionGadget(2, 10, 70, 115, 20, "Option 3")
      
      CheckBoxGadget(3, 10, 95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
      OptionGadget(4, 10, 120, 115, 20, "Option 4")
      OptionGadget(5, 10, 145, 115, 20, "Option 5")
      
      SetGadGetWidgetState(1, 1)   ; set second option as active one
      SetGadGetWidgetState(3, #PB_Checkbox_Inbetween)   
      SetGadGetWidgetState(4, 1)   
      
      For i = 0 To 2
         BindGadgetEvent(i, @events_gadgets( ))
      Next
      
      ;
      OptionWidget(10+140, 20, 115, 20, "Option 1") : SetWidgetClass( widget( ), "Option 1" )
      OptionWidget(10+140, 45, 115, 20, "Option 2") : SetWidgetClass( widget( ), "Option 2" )
      OptionWidget(10+140, 70, 115, 20, "Option 3") : SetWidgetClass( widget( ), "Option 3" )
      
      CheckBoxWidget(10+140, 95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState ) : SetWidgetClass( widget( ), "CheckBox" )
      OptionWidget(10+140, 120, 115, 20, "Option 4") : SetWidgetClass( widget( ), "Option 4" )
      OptionWidget(10+140, 145, 115, 20, "Option 5") : SetWidgetClass( widget( ), "Option 5" )
      
      SetWidgetState(ID(1), 1)   ; set second option as active one
      SetWidgetState(ID(3), #PB_Checkbox_Inbetween)  
      SetWidgetState(ID(4), 1)  
      
      For i = 0 To 2
         BindWidgetEvent(ID(i), @events_widgets( ), #__Event_Change)
      Next
      
      WaitCloseRoot( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 34
; Folding = --
; EnableXP