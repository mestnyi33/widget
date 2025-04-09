XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global i
   
   Procedure events_gadgets( )
      Protected event = EventType( )
      Debug ""+event+ " - event gadget - " +EventGadget( ) ;+ " state - " +GetGadgetState(EventGadget( )) ; 
      
      Select event
         Case #PB_EventType_LeftClick
            SetState(ID(EventGadget( )), GetGadgetState(EventGadget( )))
      EndSelect
   EndProcedure
   
   Procedure events_widgets( )
      Protected event = WidgetEvent( )
      Debug ""+event+ " - event widget - " +Str(Index(EventWidget( ))) ;+ " state - "+ GetState(EventWidget( )) ; 
      
      Select event
         Case #__Event_Change
            SetGadgetState(Index(EventWidget( )), GetState(EventWidget( )))
      EndSelect
   EndProcedure
   
   ;
   If OpenWindow(0, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;SetWindowColor(0, $0FDFE9)
      ;SetWindowColor(0, $0EE98A)
      ;
      OptionGadget(0, 10, 20, 115, 20, "Option 1") 
      OptionGadget(1, 10, 45, 115, 20, "Option 2")
      OptionGadget(2, 10, 70, 115, 20, "Option 3")
      
      CheckBoxGadget(3, 10, 95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
      OptionGadget(4, 10, 120, 115, 20, "Option 4")
      OptionGadget(5, 10, 145, 115, 20, "Option 5")
      
      SetGadgetState(1, 1)   ; set second option as active one
      SetGadgetState(3, #PB_Checkbox_Inbetween)   
      SetGadgetState(4, 1)   
      
      For i = 0 To 2
         BindGadgetEvent(i, @events_gadgets( ))
      Next
      
      ;
      Open(0, 140, 0, 140, 200,"",#__flag_transparent)
      ;SetBackgroundColor( root(), $00FFFFF0 );$0FDFE9)
      ;SetBackgroundColor( root(), $0FDFE9)
       
      Option(10, 20, 115, 20, "Option 1") : SetClass( widget( ), "Option 1" )
      Option(10, 45, 115, 20, "Option 2") : SetClass( widget( ), "Option 2" )
      Option(10, 70, 115, 20, "Option 3") : SetClass( widget( ), "Option 3" )
      
      CheckBox(10, 95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState ) : SetClass( widget( ), "CheckBox" )
      Option(10, 120, 115, 20, "Option 4") : SetClass( widget( ), "Option 4" )
      Option(10, 145, 115, 20, "Option 5") : SetClass( widget( ), "Option 5" )
      
      SetState(ID(1), 1)   ; set second option as active one
      SetState(ID(3), #PB_Checkbox_Inbetween)  
      SetState(ID(4), 1)  
      
      For i = 0 To 2
         Bind(ID(i), @events_widgets( ), #__Event_Change)
      Next
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 52
; FirstLine = 34
; Folding = --
; EnableXP