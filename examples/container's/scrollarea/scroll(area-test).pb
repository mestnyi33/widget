XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global g,*g._s_widget, b,*b, i, time, ss=50,Sw = 296, Sh = 296, count;=1000;0
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *g = ScrollArea(10, 10, 300, 300, Sw, Sh, ss);, #PB_ScrollArea_Flat)
    ;SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    *b = Button(Sw-130, Sh-130, 130, 130, "Button")
    CloseList()
    
    WaitClose()
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 5
; Folding = -
; EnableXP
; DPIAware