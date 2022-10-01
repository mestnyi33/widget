﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ;EnableExplicit
  Uselib(widget)
  
  Procedure active()
    Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+EventWidget()\index
  EndProcedure
  
  Procedure deactive()
    Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+EventWidget()\index
  EndProcedure
  
  Procedure click()
    Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+EventWidget()\index
  EndProcedure
  
  Procedure events()
    Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+EventWidget()\index
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
    ; If Open(Window(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
    ; If Window(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    
    ;a_add(root())
    
    String(10,10,180,30,"string_0")
    SetActive(widget())
    
    String(10,50,180,30,"string_1")
    SetActive(widget())
    
    Debug ""
    Bind( #PB_All, @click(), #PB_EventType_LeftClick)
    Bind( #PB_All, @deactive(), #PB_EventType_LostFocus)
    Bind( #PB_All, @active(), #PB_EventType_Focus)
    
    Debug ""
;     Bind( #PB_All, @events(), #PB_EventType_LeftClick)
;     Bind( #PB_All, @events(), #PB_EventType_LostFocus)
;     Bind( #PB_All, @events(), #PB_EventType_Focus)
    Bind( #PB_All, @events())
    
    Repeat
      Event = WaitWindowEvent()
      
      If Event = #PB_Event_CloseWindow 
        Quit = 1
      EndIf
      
    Until Quit = 1
    
  EndIf
CompilerEndIf
End  
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP