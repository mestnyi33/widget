XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define Width=500, Height=400
  
  Procedure Active()
     ;If MouseButtonPress( )
        ;ClearDebugOutput( )
        Debug ""+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) ;+"_"+ GetActive( )\class ; GetText( EventWidget( ) )
;         If StartEnum( root( ) )
;            Debug Space(Bool(Not is_window_(widget()))*5)+ "["+ widgets(  )\class +
;                  "]  FIRST["+ widgets(  )\parent\FirstWidget( )\class +
;                  "]  LAST["+ widgets(  )\parent\LastWidget( )\class+"]"
;            StopEnum( ) 
;         EndIf
     ;EndIf
  EndProcedure
  
  Procedure deactive()
    Debug " "+#PB_Compiler_Procedure +" - "+ GetClass( EventWidget( ) ) ;+"_"+ GetText( EventWidget( ) )
  EndProcedure
  
  ;
  If Open(0, 100, 200, Width, Height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
    Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "10")
    String(10,10,170,30,"1") : SetClass(widget(), "1")
    String(10,50,170,30,"4") : SetClass(widget(), "4")
    
    Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "20")
    String(10,10,170,30,"2") : SetClass(widget(), "2")
    String(10,50,170,30,"5") : SetClass(widget(), "5")
    
    Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "30")
    String(10,10,170,30,"3") : SetClass(widget(), "3")
    String(10,50,170,30,"6") : SetClass(widget(), "6")
    
    
;     a_init(root())
;     Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_10")
;     Button(10,10,170,30,"1") : SetClass(widget(), "gadget_1")
;     Button(10,50,170,30,"4") : SetClass(widget(), "gadget_4")
;     
;     Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_20")
;     Button(10,10,170,30,"2") : SetClass(widget(), "gadget_2")
;     Button(10,50,170,30,"5") : SetClass(widget(), "gadget_5")
;     
;     Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "window_30")
;     Button(10,10,170,30,"3") : SetClass(widget(), "gadget_3")
;     Button(10,50,170,30,"6") : SetClass(widget(), "gadget_6")
    
    ; Bind(widget(), @active(), #__event_Focus)
    Bind(#PB_All, @active(), #__event_Focus)
    Bind(#PB_All, @deactive(), #__event_LostFocus)
    
    WaitClose()
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 11
; Folding = -
; EnableXP