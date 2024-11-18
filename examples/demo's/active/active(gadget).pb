XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define width=500, height=400
  
  Procedure active()
   ; Debug ""+#PB_Compiler_Procedure +" - "+ GetWidgetClass( EventWidget( ) ) +"_"+ GetWidgetText( EventWidget( ) )
  EndProcedure
  
  Procedure deactive()
   ; Debug " "+#PB_Compiler_Procedure +" - "+ GetWidgetClass( EventWidget( ) ) +"_"+ GetWidgetText( EventWidget( ) )
  EndProcedure
  
  ;
  If OpenRoot(0, 100, 200, width, height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
    WindowWidget(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_10")
    StringWidget(10,10,170,30,"1") : SetWidgetClass(widget(), "gadget_1")
    StringWidget(10,50,170,30,"4") : SetWidgetClass(widget(), "gadget_4")
    
    WindowWidget(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_20")
    StringWidget(10,10,170,30,"2") : SetWidgetClass(widget(), "gadget_2")
    StringWidget(10,50,170,30,"5") : SetWidgetClass(widget(), "gadget_5")
    
    WindowWidget(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_30")
    StringWidget(10,10,170,30,"3") : SetWidgetClass(widget(), "gadget_3")
    StringWidget(10,50,170,30,"6") : SetWidgetClass(widget(), "gadget_6")
    
    
;     a_init(root())
;     WindowWidget(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_10")
;     ButtonWidget(10,10,170,30,"1") : SetWidgetClass(widget(), "gadget_1")
;     ButtonWidget(10,50,170,30,"4") : SetWidgetClass(widget(), "gadget_4")
;     
;     WindowWidget(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_20")
;     ButtonWidget(10,10,170,30,"2") : SetWidgetClass(widget(), "gadget_2")
;     ButtonWidget(10,50,170,30,"5") : SetWidgetClass(widget(), "gadget_5")
;     
;     WindowWidget(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetWidgetClass(widget(), "window_30")
;     ButtonWidget(10,10,170,30,"3") : SetWidgetClass(widget(), "gadget_3")
;     ButtonWidget(10,50,170,30,"6") : SetWidgetClass(widget(), "gadget_6")
    
    ; BindWidgetEvent(widget(), @active(), #__event_Focus)
    BindWidgetEvent(#PB_All, @active(), #__event_Focus)
    BindWidgetEvent(#PB_All, @deactive(), #__event_LostFocus)
    
    WaitCloseRoot()
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 11
; Folding = -
; EnableXP