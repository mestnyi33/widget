EnableExplicit
; ImportC ""
;   g_object_set_data_(*Widget,name.p-ascii,*data) As "g_object_set_data"
;   g_object_get_data_(*Widget,name.p-ascii) As "g_object_get_data"
;   g_signal_connect(*d, ev.p-ascii, *func, u.i, a=0, b=0) As "g_signal_connect_data"
;   g_object_set_property_(*widget, name.p-ascii, *val) As "g_object_set_property"
; EndImport

ImportC "-gtk"
  g_signal_connect(instance,signal.p-ascii,*fn,*vdata,destroy=0,flags=0) As "g_signal_connect_data"
EndImport

ProcedureC.i GadgetHandler(*widget.GtkWidget,*event.GdkEventButton,*gadget)
  Protected stat.s
  
  Select *event\type
    Case #GDK_BUTTON_PRESS
      Select *event\button 
        Case 1
          stat = "Left button down on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button down on gadget #" + Str(*gadget)
      EndSelect
      
    Case #GDK_BUTTON_RELEASE
      Select *event\button
        Case 1
          stat = "Left button up on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button up on gadget #" + Str(*gadget)
      EndSelect
      
    Case #GDK_2BUTTON_PRESS
      Select *event\button 
        Case 1
          stat = "Left button click on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button click on gadget #" + Str(*gadget)
      EndSelect
      
  EndSelect
  
  If IsGadget(0) And stat
    AddGadgetItem (0, -1, stat)
    SetGadgetState(0, CountGadgetItems(0) - 1)
  EndIf
EndProcedure 

Procedure BindGadgets(gadgetNo)
  If IsGadget(gadgetNo)
    ;gtk_widget_set_events_(GadgetID(gadgetNo),#GDK_ALL_EVENTS_MASK  )
    g_signal_connect(GadgetID(gadgetNo), "event", @GadgetHandler(), gadgetNo)
  EndIf
EndProcedure

Define i, wFlags.i = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
OpenWindow(0, #PB_Any, #PB_Any, 300, 200, "Binding Gadget Events", wFlags)
ListViewGadget(0, 20, 60, 260, 120)
ButtonGadget(1, 20, 15, 60, 30, "Button")
CheckBoxGadget(2, 110, 15, 80, 30, "CheckBox")
StringGadget(3, 200, 15, 80, 30, "StringGadget")

For i = 0 To 3
  BindGadgets(i)
Next

While WaitWindowEvent() ! #PB_Event_CloseWindow : Wend
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP