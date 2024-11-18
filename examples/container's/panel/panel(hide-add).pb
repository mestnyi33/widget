
XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global._s_widget *PANEL_1, *PANEL_2
  
  If OpenRoot(3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *PANEL_1 = Panel (30, 30, 340, 240)
    AddItem(*PANEL_1, -1, "*PANEL_1 - 1")
    AddItem(*PANEL_1, -1, "*PANEL_1 - 2")
    
    *PANEL_2 = PanelWidget(10, 5, 150, 65) 
    AddItem(*PANEL_2, -1, "*PANEL_2 - 1")
    
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ButtonWidget(10,5,50,25, "butt1") 
    CloseWidgetList()
    CloseWidgetList()
    
    AddItem(*PANEL_2, -1, "*PANEL_2 - 2")
    CloseWidgetList() ; close *PANEL_2 list
    CloseWidgetList() ; close *PANEL_1 list
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP