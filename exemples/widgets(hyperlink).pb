
IncludePath "../"
XIncludeFile "widgets(bar1).pbi"
UseModule widget

If Open(#PB_Any, 0, 0, 270, 160, "HyperlinkGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    HyperLink(10, 10, 250,20,"Red HyperLink", RGB(255,0,0))
    HyperLink(10, 30, 250,40,"Arial Underlined Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
    SetFont(widget(), LoadFont(0, "Arial", 12))
    
    redraw(root())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP