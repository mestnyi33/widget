XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ; test_focus_set = 1
   test_focus_draw = 1
   
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
      ; String(X,Y,Width,Height, "string_"+Text.s)
      Spin( X,Y,Width,Height, 0,999999 )
      SetState( widget(),2345 )
      ;SetClass( widget(), Text )
      SetActive( widget()\stringbar )
   EndProcedure
   
   
   ;
   If Open(0, 100, 200, Width, Height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
      
      TestWindow(30, 220, 50, 190, 150, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      TestGadget(3, 10,10,170,60,"3") 
      TestGadget(6, 10,80,170,60,"6") 
      
      SetActive( widget( ) )
      
      Bind(#PB_All, @active( ), #__event_Focus)
      Bind(#PB_All, @deactive( ), #__event_LostFocus)
      
      WaitClose( )
   EndIf
   
   End  
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 6
; Folding = 2-
; EnableXP
; DPIAware