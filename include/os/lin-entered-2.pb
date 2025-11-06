
  Macro gtk_children( _handle_, _children_ = 0 ) : g_list_nth_data_( gtk_container_get_children_( _handle_ ), _children_ ) : EndMacro
  Macro gtk_bin( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_bin_get_type_ ( ) ) : EndMacro
  Macro gtk_box( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_box_get_type_ ( ) ) : EndMacro
  Macro gtk_frame( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_frame_get_type_ ( ) ) : EndMacro
  Macro gtk_fixed( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_fixed_get_type_ ( ) ) : EndMacro
  Macro gtk_container( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_container_get_type_ ( ) ) : EndMacro
  Macro gtk_widget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_widget_get_type_ ( ) ) : EndMacro
  Macro gtk_window( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_window_get_type_ ( ) ) : EndMacro
  Macro gtk_table( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_table_get_type_ ( ) ) : EndMacro
  Macro gtk_hbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vpaned( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_vpaned_get_type_ ( ) ) : EndMacro
  Macro gtk_viewport( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_viewport_get_type_ ( ) ) : EndMacro
  
  
  Procedure GTKSignalConnect(*Widget, Signal$, Function, user_data)
    ;*Widget = gtk_bin(*Widget)
    ;*Widget = gtk_widget(*Widget)
    gtk_widget_add_events_(*Widget, #GDK_ENTER_NOTIFY_MASK|#GDK_LEAVE_NOTIFY_MASK)
    
  CompilerIf #GTK_MAJOR_VERSION = 1
    gtk_signal_connect_(*Widget, Signal$, Function, user_data)
  CompilerElse
    g_signal_connect_data_(*Widget, Signal$, Function, user_data, 0, 0)
  CompilerEndIf
EndProcedure

; This is a signal callback. Note the CDLL declaration. that is important.
; the user_data field helps to pass additional data.
;
ProcedureCDLL EventCallback(*Widget, *Event.GdkEventCrossing, user_data)
  Select user_data
   Case 1 : Debug "container enter event"
   Case 2 : Debug "container leave event"
   Case 3 : Debug "button enter event"
   Case 4 : Debug "button leave event"
  EndSelect
EndProcedure

#MyContainer = 10
#MyButton = 11

If OpenWindow(0,0,0,345,105,"Event Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) ; And CreateGadgetList(WindowID(0))
  ButtonGadget(#MyButton, 200, 10, 100, 30, "Test")
  ContainerGadget(#MyContainer, 10,10,100,83,#PB_Container_Raised)
    
  ; connect the signals...
  GTKSignalConnect(GadgetID(#MyContainer), "enter-notify-event", @EventCallback(), 1)
  GTKSignalConnect(GadgetID(#MyContainer), "leave-notify-event", @EventCallback(), 2) 

  GTKSignalConnect(GadgetID(#MyButton), "enter-notify-event", @EventCallback(), 3)
  GTKSignalConnect(GadgetID(#MyButton), "leave-notify-event", @EventCallback(), 4) 

  Repeat
     EventID = WaitWindowEvent()
          
     Select EventID
     
       Case #PB_Event_Gadget
         Select EventGadget()
           Case #MyContainer : Debug "Container clicked!"
           Case #MyButton : Debug "Button clicked!"
         EndSelect
     
     EndSelect
   Until EventID = #PB_Event_CloseWindow
    
EndIf

End

; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 19
; FirstLine = 4
; Folding = ----
; EnableXP
; DPIAware