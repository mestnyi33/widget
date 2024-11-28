
IncludePath "../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget  *window1, *window2, *window3
   
   Procedure.i __Free( *this._S_WIDGET )
   EndProcedure
   
   
   
   If Open(0, 0, 0, 800, 600, "window", #PB_Window_SystemMenu |
                                        #PB_Window_ScreenCentered )
      ;\\
      *window1 = Window( 30, 30, 300, 200, "window_1", #PB_Window_SystemMenu |
                                                       #PB_Window_SizeGadget |
                                                       #PB_Window_MinimizeGadget |
                                                       #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_1_root" )
      ;       Button(10,10,200,50,"window_1_close")
      ;       SetClass(widget( ), "window_1_close" )
      
      ;\\
      *window2 = Window( 230, 130, 300, 200, "window_2", #PB_Window_SystemMenu |
                                                         #PB_Window_SizeGadget |
                                                         #PB_Window_MinimizeGadget |
                                                         #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_2_root" )
      ;       Button(10,10,200,50,"window_2_close")
      ;       SetClass(widget( ), "window_2_close" )
      
      ;\\
      *window3 = Window( 430, 230, 300, 200, "window_3", #PB_Window_SystemMenu |
                                                         #PB_Window_SizeGadget |
                                                         #PB_Window_MinimizeGadget |
                                                         #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_3_root" )
      ;       Button(10,10,200,50,"window_3_close")
      ;       SetClass(widget( ), "window_3_close" )
      
      
      
      
      
      
      
      
      ;__Free( *window2 ) ;: *window2 = 0
      
      If *window1
         Debug "--1--" 
         If *window1\parent
            If *window1\parent\FirstWidget( )
               Debug "FirstWidget "+*window1\parent\FirstWidget( )\class
            EndIf
            If *window1\parent\LastWidget( )
               Debug "LastWidget "+*window1\parent\LastWidget( )\class
            EndIf
         EndIf
         If *window1\BeforeWidget( )
            Debug "  BeforeWidget "+*window1\BeforeWidget( )\class
         EndIf
         ;             If *window1\FirstWidget( )
         ;                Debug "  FirstWidget "+*window1\FirstWidget( )\class
         ;             EndIf
         ;             If *window1\LastWidget( )
         ;                Debug "  LastWidget "+*window1\LastWidget( )\class
         ;             EndIf
         If *window1\AfterWidget( )
            Debug "  AfterWidget "+*window1\AfterWidget( )\class
         EndIf
      EndIf
      
      
      If *window2
         Debug "--2--"
         If *window2\parent
            If *window2\parent\FirstWidget( )
               Debug "FirstWidget "+*window2\parent\FirstWidget( )\class
            EndIf
            If *window2\parent\LastWidget( )
               Debug "LastWidget "+*window2\parent\LastWidget( )\class
            EndIf
         EndIf
         If *window2\BeforeWidget( )
            Debug "  BeforeWidget "+*window2\BeforeWidget( )\class
         EndIf
         ;             If *window2\FirstWidget( )
         ;                Debug "  FirstWidget "+*window2\FirstWidget( )\class
         ;             EndIf
         ;             If *window2\LastWidget( )
         ;                Debug "  LastWidget "+*window2\LastWidget( )\class
         ;             EndIf
         If *window2\AfterWidget( )
            Debug "  AfterWidget "+*window2\AfterWidget( )\class
         EndIf
      EndIf
      
      If *window3
         Debug "--3--"
         If *window3\parent
            If *window3\parent\FirstWidget( )
               Debug "FirstWidget "+*window3\parent\FirstWidget( )\class
            EndIf
            If *window3\parent\LastWidget( )
               Debug "LastWidget "+*window3\parent\LastWidget( )\class
            EndIf
         EndIf
         If *window3\BeforeWidget( )
            Debug "  BeforeWidget "+*window3\BeforeWidget( )\class
         EndIf
         ;             If *window3\FirstWidget( )
         ;                Debug "  FirstWidget "+*window3\FirstWidget( )\class
         ;             EndIf
         ;             If *window3\LastWidget( )
         ;                Debug "  LastWidget "+*window3\LastWidget( )\class
         ;             EndIf
         If *window3\AfterWidget( )
            Debug "  AfterWidget "+*window3\AfterWidget( )\class
         EndIf
      EndIf
      
      
      
      
      
      WaitClose(  )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 5
; Folding = ----
; EnableXP