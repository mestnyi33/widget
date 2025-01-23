XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define i, Width=500, Height=400
  
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
  
  Procedure TestWindow(win, X,Y,Width,Height, Text.s, flag.q = 0)
     Window(X,Y,Width,Height, Text, flag)
     
     SetClass(widget(), Text)
  EndProcedure
  
  Procedure TestGadget(gad, X,Y,Width,Height, Text.s )
     ;Tree(X,Y,Width,Height)
     Editor(X,Y,Width,Height)
     
     SetClass(widget(), Text)
  EndProcedure
  
  ;
  If Open(0, 100, 200, Width, Height, "demo focus list widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
     ;     a_init(root())
     
    TestWindow(10, 10, 10, 190, 150, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    TestGadget(1, 10,10,170,60,"1")
    For i = 0 To 9
       AddItem(widget( ),-1,"item_1"+Str(i))
    Next

    TestGadget(4, 10,80,170,60,"4") 
    For i = 0 To 9
       AddItem(widget( ),-1,"item_4"+Str(i))
    Next

    TestWindow(20, 110, 30, 190, 150, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    TestGadget(2, 10,10,170,60,"2")
    For i = 0 To 9
       AddItem(widget( ),-1,"item_2"+Str(i))
    Next
    
    TestGadget(5, 10,80,170,60,"5")
    For i = 0 To 9
       AddItem(widget( ),-1,"item_5"+Str(i))
    Next

    TestWindow(30, 220, 50, 190, 150, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    TestGadget(3, 10,10,170,60,"3") 
    For i = 0 To 9
       AddItem(widget( ),-1,"item_3"+Str(i))
    Next
    
    TestGadget(6, 10,80,170,60,"6")
    For i = 0 To 9
       AddItem(widget( ),-1,"item_6"+Str(i))
    Next
    
    SetActive( widget( ) )
    
    Bind(#PB_All, @active( ), #__event_Focus)
    Bind(#PB_All, @deactive( ), #__event_LostFocus)
    
    WaitClose( )
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 22
; Folding = --
; EnableXP