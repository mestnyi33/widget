
XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global._s_widget *PANEL_1, *PANEL_2
  
  If Open(3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *PANEL_1 = Panel (30, 30, 340, 240)
    AddItem(*PANEL_1, -1, "*PANEL_1 - 1")
    AddItem(*PANEL_1, -1, "*PANEL_1 - 2")
    
    *PANEL_2 = Panel(10, 5, 150, 65) 
    AddItem(*PANEL_2, -1, "*PANEL_2 - 1")
    
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,25, "butt1") 
    CloseList()
    CloseList()
    
    AddItem(*PANEL_2, -1, "*PANEL_2 - 2")
    CloseList() ; close *PANEL_2 list
    CloseList() ; close *PANEL_1 list
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP