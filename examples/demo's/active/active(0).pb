XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Procedure events_gadgets()
  ; Debug "event - " +EventType()+  " gadget - " + EventGadget() +" focus = "+ #PB_EventType_Focus +" lostfocus = "+ #PB_EventType_LostFocus
  
  Select PB(EventType)()
    Case #PB_EventType_Focus
      Debug ""+PB(EventGadget)() + " - gadget focus"
    Case #PB_EventType_LostFocus
      Debug ""+PB(EventGadget)() + " - gadget lostfocus"
  EndSelect
  
EndProcedure

Procedure events_widgets()
  ; Debug "event - "+WidgetEvent( )+ " widget - " + Str(EventWidget( )\index - 1)
  
  Select WidgetEvent( )
    Case #__event_Focus
      Debug Str(EventWidget( )\index)+ " - widget focus"
    Case #__event_LostFocus
      Debug Str(EventWidget( )\index)+ " - widget lostfocus"
  EndSelect
  
EndProcedure

Procedure events_buttons()
  Select WidgetEvent( )
    Case #__event_LeftClick
      ; Debug "click widget - " + Str(EventWidget( )\index - 1)
      
      Select (EventWidget( )\index)
        Case 3 : SetActiveWidget(ID(0))   ; Activate StringGadget
        Case 4 : SetActiveWidget(ID(1))   ; Activate ComboBoxGadget
      EndSelect
  EndSelect
EndProcedure


If OpenRoot(0, 0, 0, 270+270, 140, "SetActiveGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  StringGadget  (0, 10, 10, 250, 20, "bla bla...")
  
  ComboBoxGadget(1, 10, 40, 250, 21)
  For a = 1 To 5 
    AddGadgetItem(1, -1, "ComboBox item " + Str(a)) 
  Next
  SetGadGetWidgetState(1, 2)                ; set (beginning with 0) the third item as active one
  
  ButtonGadget  (2, 200, 65, 60, 20, "button")
  ButtonGadget  (3, 10,  90, 250, 20, "Activate StringGadget")
  ButtonGadget  (4, 10, 115, 250, 20, "Activate ComboBox")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  ;-----
  StringWidget(10+270, 10, 250, 20, "bla bla...")
  ;StringWidget(10+270, 40, 250, 21, "...blabla")
  *g = ComboBoxWidget(10+270, 40, 250, 21)
  For a = 1 To 5 
     AddItem(*g, -1, "ComboBox item " + Str(a)) 
  Next
  SetWidgetState(*g, 2)                ; set (beginning with 0) the third item as active one
  
  ButtonWidget(200+270, 65, 60, 20, "button")
  ButtonWidget(10+270,  90, 250, 20, "Activate String")
  ButtonWidget(10+270, 115, 250, 20, "Activate ComboBox")
  
  For i = 0 To 2
    BindWidgetEvent(ID(i), @events_widgets())
  Next
  For i = 3 To 4
    BindWidgetEvent(ID(i), @events_buttons())
  Next
  
  Repeat
    Event = WaitWindowEvent()
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case 3 : SetActiveGadget(0)   ; Activate StringGadget
        Case 4 : SetActiveGadget(1)   ; Activate ComboBoxGadget
      EndSelect
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 74
; FirstLine = 50
; Folding = --
; EnableXP
; DPIAware