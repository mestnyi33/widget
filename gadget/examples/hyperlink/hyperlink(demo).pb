
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   LoadFont(5, "Arial", 16)
CompilerElse
   LoadFont(5, "Arial", 12)
CompilerEndIf

Define FontID, Flag

;\\ comment uncomment to see
XIncludeFile "../../gadgets.pbi"  

CompilerIf Defined( Gadget, #PB_Module )
   UseModule gadget
   FontID = (5)
   Flag = #__flag_left
CompilerElse
   FontID = FontID(5)
CompilerEndIf

Procedure events_gadgets()
   ClearDebugOutput()
   
   Select EventType()
      Case #PB_EventType_Change
         Debug  ""+ EventGadget() +" - gadget change state " + GetGadgetState(EventGadget())
         
      Case #PB_EventType_LeftClick
         Debug  ""+ EventGadget() +" - gadget click state " + GetGadgetState(EventGadget())
   EndSelect
EndProcedure

If OpenWindow(#PB_Any, 0, 0, 270, 100, "HyperLinkGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   HyperLinkGadget(0, 10, 10, 250,20,"Red HyperLink", RGB(255,0,0), Flag)
   HyperLinkGadget(1, 10, 40, 250,40,"Text = Arial Underlined"+#LF$+"Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline|Flag)
   SetGadgetFont(1, FontID)
   SetGadgetColor(1, #PB_Gadget_FrontColor, $ff0000)
   SetGadgetColor(1, #PB_Gadget_BackColor, $0000ff)
   
   For i = 0 To 1
      BindGadgetEvent(i, @events_gadgets())
   Next
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 19
; Folding = -
; EnableXP