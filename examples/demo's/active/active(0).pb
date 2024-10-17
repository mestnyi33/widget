XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

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
        Case 3 : SetActive(WidgetID(0))   ; Activate StringGadget
        Case 4 : SetActive(WidgetID(1))   ; Activate ComboBoxGadget
      EndSelect
  EndSelect
EndProcedure


If Open(0, 0, 0, 270+270, 140, "SetActiveGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  StringGadget  (0, 10, 10, 250, 20, "bla bla...")
  
  ComboBoxGadget(1, 10, 40, 250, 21)
  For a = 1 To 5 
    AddGadgetItem(1, -1, "ComboBox item " + Str(a)) 
  Next
  SetGadgetState(1, 2)                ; set (beginning with 0) the third item as active one
  
  ButtonGadget  (2, 200, 65, 60, 20, "button")
  ButtonGadget  (3, 10,  90, 250, 20, "Activate StringGadget")
  ButtonGadget  (4, 10, 115, 250, 20, "Activate ComboBox")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  ;-----
  String(10+270, 10, 250, 20, "bla bla...")
  ;String(10+270, 40, 250, 21, "...blabla")
  *g = ComboBox(10+270, 40, 250, 21)
  For a = 1 To 5 
     AddItem(*g, -1, "ComboBox item " + Str(a)) 
  Next
  SetState(*g, 2)                ; set (beginning with 0) the third item as active one
  
  Button(200+270, 65, 60, 20, "button")
  Button(10+270,  90, 250, 20, "Activate String")
  Button(10+270, 115, 250, 20, "Activate ComboBox")
  
  For i = 0 To 2
    Bind(WidgetID(i), @events_widgets())
  Next
  For i = 3 To 4
    Bind(WidgetID(i), @events_buttons())
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
; CursorPosition = 28
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware