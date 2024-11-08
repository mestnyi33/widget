XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define width=500, height=400
  
  Procedure active()
   ; Debug ""+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) +"_"+ GetText( EventWidget( ) )
  EndProcedure
  
  Procedure deactive()
   ; Debug " "+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) +"_"+ GetText( EventWidget( ) )
  EndProcedure
  
  ;
  If Open(0, 100, 200, width, height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
     
     a_init(root())
     
;     Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_10")
;     string(10,10,170,30,"1") : SetClass(widget(), "gadget_1")
;     string(10,50,170,30,"4") : SetClass(widget(), "gadget_4")
;     
;     Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_20")
;     string(10,10,170,30,"2") : SetClass(widget(), "gadget_2")
;     string(10,50,170,30,"5") : SetClass(widget(), "gadget_5")
;     
;     Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_30")
;     string(10,10,170,30,"3") : SetClass(widget(), "gadget_3")
;     string(10,50,170,30,"6") : SetClass(widget(), "gadget_6")
    
    
    Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_10")
    Button(10,10,170,30,"1") : SetClass(widget(), "gadget_1")
    Button(10,50,170,30,"4") : SetClass(widget(), "gadget_4")
    
    Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_20")
    Button(10,10,170,30,"2") : SetClass(widget(), "gadget_2")
    Button(10,50,170,30,"5") : SetClass(widget(), "gadget_5")
    
    Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_30")
    Button(10,10,170,30,"3") : SetClass(widget(), "gadget_3")
    Button(10,50,170,30,"6") : SetClass(widget(), "gadget_6")
    
    ; Bind(widget(), @active(), #__event_Focus)
    Bind(#PB_All, @active(), #__event_Focus)
    Bind(#PB_All, @deactive(), #__event_LostFocus)
    
    WaitClose()
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 20
; FirstLine = 10
; Folding = -
; EnableXP