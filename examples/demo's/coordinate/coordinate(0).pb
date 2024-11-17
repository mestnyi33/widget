XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global p,*p, g,*g, b,*b, i, time, Sw = 130, Sh = 300, count;=1000
  
  If Open(OpenWindow(#PB_Any, 0, 0, 305+305, 340, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    p = PanelGadget(#PB_Any, 10, 10, 290, 200)
    AddGadgetItem(p, -1, "panel_0")
    g = ScrollAreaGadget(#PB_Any, 10, 10, 250, 100, Sw, Sh, 15, #PB_ScrollArea_Flat)
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    CloseGadgetList()
    
    *p = Panel(10+300, 10, 290, 200)
    AddItem(*p, -1, "panel_0")
    *g = ScrollArea(10, 10, 250, 100, Sw, Sh, 15, #PB_ScrollArea_Flat)
    *b = Button(Sw-130, Sh-30, 130, 30,"Button")
    CloseList()
    CloseList()
    
    ; set&get demos
    SetGadgetAttribute(g, #PB_ScrollArea_Y, sh)
    SetAttribute(*g, #PB_ScrollArea_Y, sh)
    
    Debug "Y ScrollArea-gadget coordinate"
    Debug "  screen - "+ GadgetY(g, #PB_Gadget_ScreenCoordinate)
    Debug "  window - "+ GadgetY(g, #PB_Gadget_WindowCoordinate)
    Debug "  container - "+ GadgetY(g, #PB_Gadget_ContainerCoordinate)
    Debug "  area - "+GetGadgetAttribute(g, #PB_ScrollArea_Y)
    Debug ""
    
    Debug "Y ScrollArea-widget coordinate"
    Debug "  screen - "+ Str(GadgetY(GetCanvasGadget(*g), #PB_Gadget_ScreenCoordinate)+y(*g, #__c_screen))
    Debug "  window - "+ Y(*g, #__c_window)
    Debug "  container - "+ Y(*g, #__c_container)
    Debug "  area - "+ GetAttribute(*g, #PB_ScrollArea_Y)
    Debug ""
    
;     ; mac os
;     Y ScrollArea-gadget coordinate
;     screen - 220
;     window - 53
;     container - 10
;     area - 202
;     
;     Y ScrollArea-widget coordinate
;     screen - 212
;     window - 45
;     container - 10
;     area - 220
  
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 30
; Folding = -
; EnableXP