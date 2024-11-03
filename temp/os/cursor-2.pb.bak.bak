EnableExplicit

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux
    #CURSOR_ARROW = #GDK_ARROW
    #CURSOR_BUSY = #GDK_WATCH

    ImportC ""
      gtk_widget_get_window(*Widget.GtkWidget)
    EndImport
  CompilerCase #PB_OS_Windows
    #CURSOR_ARROW = #IDC_ARROW
    #CURSOR_BUSY = #IDC_WAIT
CompilerEndSelect

Define BusyCursorActive.I
Define NewCursor.I

OpenWindow(0, 270, 100, 200, 90, "Toggle busy cursor")
ButtonGadget(0, 20, 30, 160, 25, "Enable busy cursor")
  
Repeat
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ; -----------------------------------------
      Define *Widget.GtkWidget = gdk_window_at_pointer_(0,0)
      If *Widget And PeekS(gtk_widget_get_name_(*Widget\name), -1, #PB_UTF8) = "GtkFixed"
        If NewCursor
          gdk_window_set_cursor_(gtk_widget_get_window(WindowID(0)), NewCursor)
        EndIf
      Else
        gdk_window_set_cursor_(gtk_widget_get_window(WindowID(0)), gdk_cursor_new_(#CURSOR_ARROW))
      EndIf
    CompilerEndSelect
    
    Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 0 And EventType() = #PB_EventType_LeftClick
        BusyCursorActive ! 1

        CompilerSelect #PB_Compiler_OS
          CompilerCase #PB_OS_Linux ; -----------------------------------------
            If BusyCursorActive
              NewCursor = gdk_cursor_new_(#CURSOR_BUSY)
            Else
              NewCursor = gdk_cursor_new_(#CURSOR_ARROW)
            EndIf

            If NewCursor
              gdk_window_set_cursor_(gtk_widget_get_window(WindowID(0)), NewCursor)
            EndIf
         
          CompilerCase #PB_OS_Windows ; ---------------------------------------
            If BusyCursorActive
              NewCursor = LoadCursor_(0, #CURSOR_BUSY)
            Else
              NewCursor = LoadCursor_(0, #CURSOR_ARROW)
            EndIf

            If NewCursor
             ; SetClassLongPtr_(WindowID(0), #GCL_HCURSOR, NewCursor)
              SetClassLongPtr_(GadgetID(0), #GCL_HCURSOR, NewCursor)
             ; SetCursor_(LoadCursor_(0, #IDC_WAIT))
            EndIf
        CompilerEndSelect ; ---------------------------------------------------
        
        If BusyCursorActive
          SetGadgetText(0, "Disable busy cursor")
        Else
          SetGadgetText(0, "Enable busy cursor")
        EndIf
      EndIf
  EndSelect
ForEver

End


; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 62
; FirstLine = 38
; Folding = --
; EnableXP