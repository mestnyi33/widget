CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ImportC ""
    gtk_button_set_alignment(*Button.GtkButton, xAlign.F, yAlign.F)
  EndImport
CompilerEndIf

OpenWindow(0,200,200,200,100,"test")
ButtonGadget(0,10,10,180,80,"Click for left")
bg=GadgetID(0)
t=1

Repeat
  ev=WaitWindowEvent()
  If ev=#PB_Event_Gadget
    t=1-t
    If t=0
      SetGadgetText(0,"Click for center")
    Else
      SetGadgetText(0,"Click for left")
    EndIf

    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        gtk_button_get_alignment_(bg, @xAlign.F, @yAlign.F)
        gtk_button_set_alignment(bg, Abs(xAlign - 0.5), yAlign)
      CompilerCase #PB_OS_MacOS
        CocoaMessage(0, bg, "setAlignment:", CocoaMessage(0, bg, "alignment") ! 1) 
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(bg,#GWL_STYLE,GetWindowLongPtr_(bg,#GWL_STYLE)!#BS_LEFT)
    CompilerEndSelect
  EndIf
Until ev=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP