XIncludeFile "../../../widgets.pbi"

UseWidgets( )

Procedure events_gadgets()
   ;ClearDebugOutput()
   ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
   
   Select EventType()
      Case #PB_EventType_LeftClick
         Define state = GetGadgetState(EventGadget())
         Debug  "["+ state +"] - gadget change " + EventGadget()
         SetState(ID(EventGadget()), state)
         PostRepaint( )
   EndSelect
EndProcedure

Procedure events_widgets()
   ;ClearDebugOutput()
   ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +WidgetEvent( )+ "  state - " GetState(EventWidget( )) ; 
   Select WidgetEvent( )
      Case #__event_Change
         Define state = GetState(EventWidget( ))
         Debug "  ["+ state +"] - widget change "+ Str(Index(EventWidget( ))) +" "+ Height( ID(0) ) +" "+ Height( ID(1) )
         SetGadgetState(Index(EventWidget( )), state)
   EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   #Button0  = 0
   #Button1  = 1
   #Splitter2 = 2
   #Splitter4 = 4
   
   Open(0, 230,0, 230,200)
   Button(0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
   Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
   Splitter(5, 5, 220, 120, ID(#Button0), ID(#Button1));, #PB_Splitter_Separator)
   Bind(ID(#Splitter2), @events_widgets())
   
   Text(5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#__flag_TextCenter|#__flag_TextTop )
   Splitter(5, 5, 220, 190, ID(#Splitter2), ID(3), #PB_Splitter_Separator)
   ;Bind(ID(#Splitter4), @events_widgets())
   
   
   ButtonGadget(#Button0, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
   ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
   SplitterGadget(#Splitter2, 5, 5, 220, 120, #Button0, #Button1, #PB_Splitter_Separator)
   BindGadgetEvent(#Splitter2, @events_gadgets())
   
   TextGadget(3, 5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#PB_Text_Center )
   SplitterGadget(#Splitter4, 5, 5, 220, 190, #Splitter2, 3, #PB_Splitter_Separator)
   ;BindGadgetEvent(#Splitter4, @events_gadgets())
   
   
   WaitClose( )
EndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 12
; Folding = -
; Optimizer
; EnableXP
; DPIAware