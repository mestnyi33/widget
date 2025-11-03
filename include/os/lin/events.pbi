; https://www.purebasic.fr/english/viewtopic.php?f=13&t=60526
; http://forums.purebasic.com/english/viewtopic.php?t=64258

EnableExplicit
ImportC ""; -gtk"
;   g_object_set_data_(*Widget,name.p-ascii,*data) As "g_object_set_data"
;   g_object_get_data_(*Widget,name.p-ascii) As "g_object_get_data"
;   g_object_set_property_(*widget, name.p-ascii, *val) As "g_object_set_property"
  
  ; g_signal_connect(*d, ev.p-ascii, *func, u.i, a=0, b=0) As "g_signal_connect_data"
  ; g_signal_connect(instance,signal.p-ascii,*fn,*vdata,destroy=0,flags=0) As "g_signal_connect_data"
  ; g_signal_connect() — это макрос, поэтому вместо него вы должны использовать g_signal_connect_data().
  g_signal_connect_data(*instance, signal.p-utf8, *handler, *data, *destroy_data, *connect_flags)
  
EndImport

ProcedureC ChangeHandler2(*Scrollbar, ScrollType, value.d, user_data)
      ; https://www.purebasic.fr/english/viewtopic.php?p=370832#p370832
      
      ; display the scroll event
      Select ScrollType
         Case #GTK_SCROLL_NONE: Debug "#GTK_SCROLL_NONE"
         Case #GTK_SCROLL_JUMP: Debug "#GTK_SCROLL_JUMP"
         Case #GTK_SCROLL_STEP_BACKWARD: Debug "#GTK_SCROLL_STEP_BACKWARD"
         Case #GTK_SCROLL_STEP_FORWARD: Debug "#GTK_SCROLL_STEP_FORWARD"
         Case #GTK_SCROLL_PAGE_BACKWARD: Debug "#GTK_SCROLL_PAGE_BACKWARD"
         Case #GTK_SCROLL_PAGE_FORWARD: Debug "#GTK_SCROLL_PAGE_FORWARD"
         Case #GTK_SCROLL_STEP_UP: Debug "#GTK_SCROLL_STEP_UP"
         Case #GTK_SCROLL_STEP_DOWN: Debug "#GTK_SCROLL_STEP_DOWN"
         Case #GTK_SCROLL_PAGE_UP: Debug "#GTK_SCROLL_PAGE_UP"
         Case #GTK_SCROLL_PAGE_DOWN: Debug "#GTK_SCROLL_PAGE_DOWN"
         Case #GTK_SCROLL_STEP_LEFT: Debug "#GTK_SCROLL_STEP_LEFT"
         Case #GTK_SCROLL_STEP_RIGHT: Debug "#GTK_SCROLL_STEP_RIGHT"
         Case #GTK_SCROLL_PAGE_LEFT: Debug "#GTK_SCROLL_PAGE_LEFT"
         Case #GTK_SCROLL_PAGE_RIGHT: Debug "#GTK_SCROLL_PAGE_RIGHT"
         Case #GTK_SCROLL_START: Debug "#GTK_SCROLL_START"
         Case #GTK_SCROLL_END: Debug "#GTK_SCROLL_END"
      EndSelect
      Debug value
      
      ; move scrollbar 1 step forward regardless of the event
      SetGadgetState(0, GetGadgetState(0)+1)
      
      ; return #true to stop default processing
      ProcedureReturn #True
   EndProcedure
; g_signal_connect_data_(GadgetID(gadget), "change-value", @ChangeHandler2(), 0, #Null, 0)
      
   
ProcedureC.i GadgetHandler(*widget.GtkWidget,*event.GdkEventAny,*gadget)
  Protected stat.s
  Protected *eventMouseButtons.GdkEventButton = *event
  
  Select *eventMouseButtons\type
    Case #GDK_BUTTON_PRESS
      Select *eventMouseButtons\button 
        Case 1
          stat = "Left button down on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button down on gadget #" + Str(*gadget)
      EndSelect
      
    Case #GDK_BUTTON_RELEASE
      Select *eventMouseButtons\button
        Case 1
          stat = "Left button up on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button up on gadget #" + Str(*gadget)
      EndSelect
      
    Case #GDK_2BUTTON_PRESS
      Select *eventMouseButtons\button 
        Case 1
          stat = "Left button click on gadget #" + Str(*gadget)
        Case 3
          stat = "Right button click on gadget #" + Str(*gadget)
      EndSelect
      
     Case #GDK_LEAVE_NOTIFY
      Debug "Event: GDK_LEAVE_NOTIFY: 11  on gadget #" + Str(*gadget)
    Case #GDK_ENTER_NOTIFY
      Debug "Event: GDK_ENTER_NOTIFY: 10  on gadget #" + Str(*gadget)
    
  EndSelect
  
  If stat
    Debug stat
  EndIf
EndProcedure 

Procedure BindGadgets(gadgetNo)
  If IsGadget(gadgetNo)
    gtk_widget_add_events_(GadgetID(gadgetNo), #GDK_ALL_EVENTS_MASK  )
    ; gtk_widget_add_events_(GadgetID(#Edt1), gtk_widget_get_events_(GadgetID(#Edt1)) | #GDK_SCROLL_MASK)
	
    g_signal_connect_data(GadgetID(gadgetNo), "event", @GadgetHandler(), gadgetNo, 0, 0)
  EndIf
EndProcedure

Define i, wFlags.i = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
OpenWindow(0, #PB_Any, #PB_Any, 300, 200, "Binding Gadget Events", wFlags)
TextGadget(1, 20, 15, 60, 30, "Button")
CheckBoxGadget(2, 110, 15, 80, 30, "CheckBox")
StringGadget(3, 200, 15, 80, 30, "StringGadget")
ContainerGadget(0, 20, 60, 260, 120, #PB_Container_Flat)
CloseGadgetList()
For i = 0 To 3
  BindGadgets(i)
Next

While WaitWindowEvent() ! #PB_Event_CloseWindow : Wend
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 48
; FirstLine = 12
; Folding = +-
; EnableXP