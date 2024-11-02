XIncludeFile "Element.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Global i
   
   Procedure events_gadgets( )
      Protected eventtype = EventType( )
      Debug ""+eventtype+ " - event gadget - " +EventGadget( ) ;+ " state - " +GetGadgetState(EventGadget( )) ; 
      
      Select eventtype
         Case #PB_EventType_LeftClick
            SetElementState(EventGadget( ), GetGadgetState(EventGadget( )))
      EndSelect
   EndProcedure
   
   Procedure events_elements( )
      Protected eventtype = ElementEventType( )
      Debug ""+eventtype+ " - event element - " +Str(EventElement( )) ;+ " state - "+ GetElementState(EventElement( ))
      
      Select eventtype
         Case #PB_EventType_Change
            SetGadgetState(EventElement( ), GetElementState(EventElement( )))
      EndSelect
   EndProcedure
   
   
   If OpenElement(0, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      OptionGadget(1, 10, 20, 115, 20, "Option 1")
      OptionGadget(2, 10, 45, 115, 20, "Option 2")
      OptionGadget(3, 10, 70, 115, 20, "Option 3")
      SetGadgetState(2, 1)   ; set second option as active one
      
      CheckBoxGadget(4, 10,  95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
      OptionGadget(5, 10, 120, 115, 20, "Option 2")
      OptionGadget(6, 10, 145, 115, 20, "Option 3")
      
      SetGadgetState(4, #PB_Checkbox_Inbetween)   
      SetGadgetState(5, 1)   
      
      For i = 1 To 3
         BindGadgetEvent(i, @events_gadgets( ))
      Next
      
      OptionElement(1, 10+140, 20, 115, 20, "Option 1")
      OptionElement(2, 10+140, 45, 115, 20, "Option 2")
      OptionElement(3, 10+140, 70, 115, 20, "Option 3")
      SetElementState(2, 1)   ; set second option as active one
      
      CheckBoxElement(4, 10+140,  95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
      OptionElement(5, 10+140, 120, 115, 20, "Option 2")
      OptionElement(6, 10+140, 145, 115, 20, "Option 3")
      
      SetElementState(4, #PB_Checkbox_Inbetween)  
      SetElementState(5, 1)  
      
      For i = 1 To 3
         BindElementEvent(i, @events_elements( ), #__Event_Change)
      Next
      
      WaitCloseElement( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 61
; FirstLine = 27
; Folding = --
; EnableXP