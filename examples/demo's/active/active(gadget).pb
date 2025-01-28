XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_set = 1
   
   Define Width=500, Height=400
   
   Procedure Active()
      ;If MouseButtonPress( )
      ;ClearDebugOutput( )
      If EventWidget( )\type < 0
         Debug ""+GetClass( EventWidget( ) ) +" --- "+#PB_Compiler_Procedure +" --- "
      Else
         Debug "   "+GetClass( EventWidget( ) ) +" --- focus --- "
      EndIf
      ;         If StartEnum( root( ) )
      ;            Debug Space(Bool(Not is_window_(widget()))*5)+ "["+ widgets(  )\class +
      ;                  "]  FIRST["+ widgets(  )\parent\FirstWidget( )\class +
      ;                  "]  LAST["+ widgets(  )\parent\LastWidget( )\class+"]"
      ;            StopEnum( ) 
      ;         EndIf
      ;EndIf
   EndProcedure
   
   Procedure Deactive()
      If EventWidget( )\type < 0
         Debug ""+GetClass( EventWidget( ) ) + " --- "+#PB_Compiler_Procedure +" --- "
      Else
         Debug "   "+GetClass( EventWidget( ) ) +" --- lostfocus --- "
      EndIf
   EndProcedure
   
   Procedure TestWindow( win, X,Y,Width,Height, Text.s, flag.q = 0, *parent = 0)
      Window( X,Y,Width,Height, "window_"+Text, flag, *parent )
      
      SetClass(widget(), Text)
      ProcedureReturn widget( )
   EndProcedure
   
   Procedure TestGadget(gad, X,Y,Width,Height, Text.s )
      String(X,Y,Width,Height, "string_"+Text.s)
      
      SetClass(widget(), Text)
   EndProcedure
   
   
   ;
   If Open(0, 100, 200, Width, Height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
      ;     a_init(root())
      Define *parent = TestWindow(10, 10, 10, 430, 350, "00", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget )
      
      SetParent(TestWindow(10, 10, 10, 190, 150, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget ), *parent )
      TestGadget(1, 10,10,170,60,"1") 
      TestGadget(4, 10,80,170,60,"4") 
      
      SetParent(TestWindow(20, 110, 30, 190, 150, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget ), *parent ) 
      TestGadget(2, 10,10,170,60,"2") 
      TestGadget(5, 10,80,170,60,"5")
      
      SetParent(TestWindow(30, 220, 50, 190, 150, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget), *parent ) 
      TestGadget(3, 10,10,170,60,"3") 
      TestGadget(6, 10,80,170,60,"6") 
      SetActive( widget( ) )
      
      
      Bind(#PB_All, @active( ), #__event_Focus)
      Bind(#PB_All, @deactive( ), #__event_LostFocus)
      
      WaitClose( )
   EndIf
   
   End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 5
; Folding = --
; EnableXP