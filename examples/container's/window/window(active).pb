XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Procedure active()
    Debug " "+ EventWidget( )\text\string +"_"+ #PB_Compiler_Procedure 
  EndProcedure
  
  Procedure deactive()
     Debug "   "+ EventWidget( )\text\string +"_"+ #PB_Compiler_Procedure 
  EndProcedure
  
  Define width=500, height=400
  
  If Open(0, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
    ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
     
     ;\\
    ;   Bind(#PB_All, @active(), #PB_EventType_Focus)
    ;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)
    
    Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"string_1")
    ; SetActive(widget())
    
    string(10,50,170,30,"string_2")
    ; SetActive(widget())
    
    Window(110, 30, 190, 90, "Window_3", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"string_4")
    ; SetActive(widget())
    
    string(10,50,170,30,"string_5")
    ; SetActive(widget())
    
    Window(220, 50, 190, 90, "Window_6", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"string_7")
    ; SetActive(widget())
    
    string(10,50,170,30,"string_8")
    ; SetActive(widget())
    
    
    Bind( #PB_All, @active(), #PB_EventType_Focus)
    Bind( #PB_All, @deactive(), #PB_EventType_LostFocus)
    
    WaitClose()
 EndIf
  
  End 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 16
; Folding = -
; EnableXP