IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  #NSTopTabsBezelBorder    = 0
  #NSLeftTabsBezelBorder   = 1
  #NSBottomTabsBezelBorder = 2
  #NSRightTabsBezelBorder  = 3
  
  Global *panel, *option
  Global SelectedGadget
  
  Open(0, 270, 100, 600, 310, "Change tab location")
  
  PanelGadget(0, 10, 10, 300 - 20, 180)
  AddGadgetItem (0, -1, "Tab 1")
  AddGadgetItem (0, -1, "Tab 2")
  CloseGadgetList()
  
  FrameGadget(1, 30, 210, 300 - 60, 80, "Tab location")
  OptionGadget(2, 130, GadgetY(1) + 20, 80, 20, "Top")
  OptionGadget(3, 50, GadgetY(1) + 35, 80, 20, "Left")
  OptionGadget(4, 130, GadgetY(1) + 50, 80, 20, "Bottom")
  OptionGadget(5, 210, GadgetY(1) + 35, 80, 20, "Right")
  SetGadgetState(2, #True)
  
  
  *panel = Panel(300+10, 10, 300 - 20, 180)
  AddItem (*panel, -1, "Tab 1")
  AddItem (*panel, -1, "Tab 2")
  CloseList() ; *panel
  
  Frame(300+30, 210, 300 - 60, 80, "Tab location")
  *option = Option(300+130, GadgetY(1) + 20, 80, 20, "Top")
  Option(300+50, GadgetY(1) + 35, 80, 20, "Left")
  Option(300+130, GadgetY(1) + 50, 80, 20, "Bottom")
  Option(300+210, GadgetY(1) + 35, 80, 20, "Right")
  SetState(*option, #True)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        SelectedGadget = EventGadget()
        
        If SelectedGadget >= 2 And SelectedGadget <= 5
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            CocoaMessage(0, GadgetID(0), "setTabViewType:", SelectedGadget - 2)
          CompilerEndIf
        EndIf
    EndSelect
  ForEver
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP