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
      
     ;     a_init(root())
     
    Window(10, 10, 190, 150, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "10")
    String(10,10,170,60,"1") : SetClass(widget(), "1")
    String(10,80,170,60,"4") : SetClass(widget(), "4")
    
    Window(110, 30, 190, 150, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "20")
    String(10,10,170,60,"2") : SetClass(widget(), "2")
    String(10,80,170,60,"5") : SetClass(widget(), "5")
    
    Window(220, 50, 190, 150, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), "30")
    String(10,10,170,60,"3") : SetClass(widget(), "3")
    String(10,80,170,60,"6") : SetClass(widget(), "6")
    SetActive( widget( ) )
    
    
    
    Bind(#PB_All, @active( ), #__event_Focus)
    Bind(#PB_All, @deactive( ), #__event_LostFocus)
    
    WaitClose( )
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 44
; FirstLine = 20
; Folding = -
; EnableXP