Global.i Window0_ID, Window0_CV

Procedure GetObject()
  
  Protected pt.NSPoint
  
  CocoaMessage(@pt, Window0_ID, "mouseLocationOutsideOfEventStream")
  ProcedureReturn CocoaMessage(0, Window0_CV, "hitTest:@", @pt)
  
EndProcedure



OpenWindow(0,#PB_Ignore,#PB_Ignore,640,480,"",#PB_Window_SystemMenu)
Window0_ID = WindowID(0)
Window0_CV = CocoaMessage(0, Window0_ID, "contentView")

ButtonGadget(0,10,10,100,100,"Blub1")
ButtonGadget(1,10,110,100,100,"Blub2")

CreateStatusBar(0,WindowID(0))
AddStatusBarField(#PB_Ignore)

Repeat
  event = WaitWindowEvent() 
  
  If #PB_Event_Repaint
    
    Select GetObject()
      Case GadgetID(0)
        StatusBarText(0, 0, "Blub1")
      Case GadgetID(1)
        StatusBarText(0, 0, "Blub2")
      Default
        StatusBarText(0, 0, "")
    EndSelect
    
  EndIf
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP