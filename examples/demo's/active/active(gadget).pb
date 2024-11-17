XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define width=500, height=400
  
  Procedure active()
   ; Debug ""+#PB_Compiler_Procedure +" - "+ GetWidgetClass( EventWidget( ) ) +"_"+ GetTextWidget( EventWidget( ) )
  EndProcedure
  
  Procedure deactive()
   ; Debug " "+#PB_Compiler_Procedure +" - "+ GetWidgetClass( EventWidget( ) ) +"_"+ GetTextWidget( EventWidget( ) )
  EndProcedure
  
  ;
  If Open(0, 100, 200, width, height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
    Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_10")
    StringWidget(10,10,170,30,"1") : SetWidgetClass(widget(), "gadget_1")
    StringWidget(10,50,170,30,"4") : SetWidgetClass(widget(), "gadget_4")
    
    Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_20")
    StringWidget(10,10,170,30,"2") : SetWidgetClass(widget(), "gadget_2")
    StringWidget(10,50,170,30,"5") : SetWidgetClass(widget(), "gadget_5")
    
    Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_30")
    StringWidget(10,10,170,30,"3") : SetWidgetClass(widget(), "gadget_3")
    StringWidget(10,50,170,30,"6") : SetWidgetClass(widget(), "gadget_6")
    
    
;     a_init(root())
;     Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_10")
;     ButtonWidget(10,10,170,30,"1") : SetWidgetClass(widget(), "gadget_1")
;     ButtonWidget(10,50,170,30,"4") : SetWidgetClass(widget(), "gadget_4")
;     
;     Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_20")
;     ButtonWidget(10,10,170,30,"2") : SetWidgetClass(widget(), "gadget_2")
;     ButtonWidget(10,50,170,30,"5") : SetWidgetClass(widget(), "gadget_5")
;     
;     Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_30")
;     ButtonWidget(10,10,170,30,"3") : SetWidgetClass(widget(), "gadget_3")
;     ButtonWidget(10,50,170,30,"6") : SetWidgetClass(widget(), "gadget_6")
    
    ; Bind(widget(), @active(), #__event_Focus)
    Bind(#PB_All, @active(), #__event_Focus)
    Bind(#PB_All, @deactive(), #__event_LostFocus)
    
    WaitClose()
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 11
; Folding = -
; EnableXP