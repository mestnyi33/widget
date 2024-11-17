XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Procedure active()
  If EventWidget( )\container =- 1
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive()
  If EventWidget( )\container =- 1
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure active_0()
  If EventWidget( )\container =- 1
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive_0()
  If EventWidget( )\container =- 1
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Define width=500, height=400

; If OpenRootWidget(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;   ; If OpenRootWidget(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;   ; If WindowWidget(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   BindWidgetEvent(#PB_All, @active(), #__event_Focus)
;   BindWidgetEvent(#PB_All, @deactive(), #__event_LostFocus)

  OpenRootWidget(0, 10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;OpenRootWidget(Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  StringWidget(10,10,170,30,"string_0")
  ;SetActive(widget())
  
  StringWidget(10,50,170,30,"string_1")
  ;SetActive(widget())
  
  OpenRootWidget(1, 110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;OpenRootWidget(Window(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  StringWidget(10,10,170,30,"string_2")
  ;SetActive(widget())
  
  StringWidget(10,50,170,30,"string_3")
  ;SetActive(widget())
  
  OpenRootWidget(2, 220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;OpenRootWidget(Window(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  StringWidget(10,10,170,30,"string_4")
  ;SetActive(widget())
  
  StringWidget(10,50,170,30,"string_5")
  ;SetActive(widget())
  
  
    
  BindWidgetEvent( #PB_All, @active_0(), #__event_Focus)
  BindWidgetEvent( #PB_All, @deactive_0(), #__event_LostFocus)
  
  WaitCloseRootWidget()
End  
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = --
; EnableXP