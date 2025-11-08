XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Procedure Active()
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

Define Width=500, Height=400

  Open(0, 10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,170,30,"string_0")
  ;SetActive(widget())
  
  String(10,50,170,30,"string_1")
  ;SetActive(widget())
  
  Open(1, 110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,170,30,"string_2")
  ;SetActive(widget())
  
  String(10,50,170,30,"string_3")
  ;SetActive(widget())
  
  Open(2, 220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,170,30,"string_4")
  ;SetActive(widget())
  
  String(10,50,170,30,"string_5")
  ;SetActive(widget())
  
  
    
  Bind( #PB_All, @active_0(), #__event_Focus)
  Bind( #PB_All, @deactive_0(), #__event_LostFocus)
  
  WaitClose()
End  
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 36
; FirstLine = 13
; Folding = --
; EnableXP