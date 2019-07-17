 
    
    Global sh,cw,ch

Procedure type()
  Text$ = GetGadgetText(1)
  StartDrawing(WindowOutput(0))
    DrawingFont(FontID(0))
    w = TextWidth(text$)
  StopDrawing()     
  ResizeGadget(1,cw/2-w/2,ch/2-sh/2-2,w,sh)
EndProcedure

LoadFont(0,"Tahoma",24)
OpenWindow(0, 0, 0, 600, 400, "StringGadget ", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)

 StringGadget(1,10,10,580,90," 88888 ",#PB_String_BorderLess)
  SetGadgetFont(1,FontID(0))
  SetGadgetColor(1,#PB_Gadget_FrontColor,$0000FF)  

SetActiveGadget(1)
; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      ;CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
      Debug CocoaMessage (0, GadgetID (1), "isHidden")
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
   
;BindGadgetEvent(1,@type())
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Quit = 1
      
    Case #PB_Event_Gadget
      Select EventGadget()
         Case 1
          
      EndSelect
  EndSelect
Until Quit = 1
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP