XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define width=500, height=400
  
  Procedure active()
    Debug ""+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) +"_"+ GetText( EventWidget( ) )
  EndProcedure
  
  Procedure deactive()
    Debug " "+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) +"_"+ GetText( EventWidget( ) )
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 100, 200, width, height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
    
    Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    
    Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"2")
    string(10,50,170,30,"5")
    
    Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    string(10,10,170,30,"3")
    string(10,50,170,30,"6")
    
    Bind(#PB_All, @active(), #PB_EventType_Focus)
    Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)
    
    WaitClose()
  EndIf
  
  End  
CompilerEndIf

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP