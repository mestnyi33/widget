
IncludePath "../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Global._s_widget  *window1, *window2, *window3
   
   Procedure __SetPosition( *this._S_WIDGET, position.l, *widget._S_WIDGET = #Null ) ; Ok
      If *widget = #Null
         Select Position
            Case #PB_List_First : *widget = *this\parent\FirstWidget( )
            Case #PB_List_Before : *widget = *this\BeforeWidget( )
            Case #PB_List_After : *widget = *this\AfterWidget( )
            Case #PB_List_Last : *widget = *this\parent\LastWidget( )
         EndSelect
      EndIf
      
      If Not *widget
         ProcedureReturn #False
      EndIf
      
      If *this <> *widget And
         *this\TabIndex( ) = *widget\TabIndex( )
         
         If Position = #PB_List_First Or
            Position = #PB_List_Before
            
            PushListPosition( *this\_widgets( ))
            ChangeCurrentElement( *this\_widgets( ), *this\address )
            MoveElement( *this\_widgets( ), #PB_List_Before, *widget\address )
            
            If *this\haschildren
               While PreviousElement( *this\_widgets( ))
                  If IsChild( *this\_widgets( ), *this )
                     MoveElement( *this\_widgets( ), #PB_List_After, *widget\address )
                  EndIf
               Wend
               
               While NextElement( *this\_widgets( ))
                  If IsChild( *this\_widgets( ), *this )
                     MoveElement( *this\_widgets( ), #PB_List_Before, *widget\address )
                  EndIf
               Wend
            EndIf
            PopListPosition( *this\_widgets( ))
         EndIf
         
         If Position = #PB_List_Last Or
            Position = #PB_List_After
            
            Protected *last._S_WIDGET = GetLast( *widget, *widget\TabIndex( ))
            
            PushListPosition( *this\_widgets( ))
            ChangeCurrentElement( *this\_widgets( ), *this\address )
            MoveElement( *this\_widgets( ), #PB_List_After, *last\address )
            
            If *this\haschildren
               While NextElement( *this\_widgets( ))
                  If IsChild( *this\_widgets( ), *this )
                     MoveElement( *this\_widgets( ), #PB_List_Before, *last\address )
                  EndIf
               Wend
               
               While PreviousElement( *this\_widgets( ))
                  If IsChild( *this\_widgets( ), *this )
                     MoveElement( *this\_widgets( ), #PB_List_After, *this\address )
                  EndIf
               Wend
            EndIf
            PopListPosition( *this\_widgets( ))
         EndIf
         
         ;
         If *this\BeforeWidget( )
            *this\BeforeWidget( )\AfterWidget( ) = *this\AfterWidget( )
         EndIf
         If *this\AfterWidget( )
            *this\AfterWidget( )\BeforeWidget( ) = *this\BeforeWidget( )
         EndIf
         If *this\parent\FirstWidget( ) = *this
            *this\parent\FirstWidget( ) = *this\AfterWidget( )
         EndIf
         If *this\parent\LastWidget( ) = *this
            *this\parent\LastWidget( ) = *this\BeforeWidget( )
         EndIf
         
         ;
         If Position = #PB_List_First Or
            Position = #PB_List_Before
            
            *this\AfterWidget( )    = *widget
            *this\BeforeWidget( )   = *widget\BeforeWidget( )
            *widget\BeforeWidget( ) = *this
            
            If *this\BeforeWidget( )
               *this\BeforeWidget( )\AfterWidget( ) = *this
            Else
               If *this\parent\FirstWidget( )
                  *this\parent\FirstWidget( )\BeforeWidget( ) = *this
               EndIf
               *this\parent\FirstWidget( ) = *this
            EndIf
         EndIf
         
         If Position = #PB_List_Last Or
            Position = #PB_List_After
            
            *this\BeforeWidget( )  = *widget
            *this\AfterWidget( )   = *widget\AfterWidget( )
            *widget\AfterWidget( ) = *this
            
            If *this\AfterWidget( )
               *this\AfterWidget( )\BeforeWidget( ) = *this
            Else
               If *this\parent\LastWidget( )
                  *this\parent\LastWidget( )\AfterWidget( ) = *this
               EndIf
               *this\parent\LastWidget( ) = *this
            EndIf
         EndIf
         
         ProcedureReturn #True
      EndIf
      
   EndProcedure
   
   Procedure.i __Free( *this._S_WIDGET )
      If *this
         If Not Send( *this, #__event_free )
            ; еще не проверял
            If ListSize( *this\events( ) )
               ; Debug "free-events " + *this\events( )
               ClearList( *this\events( ) )
            EndIf
            
            If PopupWindow( ) = *this
               PopupWindow( ) = #Null
            EndIf
            
            ;\\
            If Not *this\parent
               *this\parent = *this
            EndIf
            
            ;\\
            If Opened( ) = *this
               OpenList( *this\parent )
            EndIf
            
            
            
            
            If *this\parent\FirstWidget( ) = *this
               *this\parent\FirstWidget( ) = *this\AfterWidget( )
            EndIf
            
            If *this\parent\LastWidget( ) = *this
               *this\parent\LastWidget( ) = *this\BeforeWidget( )
            EndIf
            
            
            
            If *this\parent\TabBox( )
               If *this\parent\TabBox( ) = *this
                  FreeStructure( *this\parent\TabBox( ) )
                  *this\parent\TabBox( ) = 0
               EndIf
               *this\parent\TabBox( ) = #Null
            EndIf
            
            If *this\parent\scroll
               If *this\parent\scroll\v = *this
                  FreeStructure( *this\parent\scroll\v )
                  *this\parent\scroll\v = 0
               EndIf
               If *this\parent\scroll\h = *this
                  FreeStructure( *this\parent\scroll\h )
                  *this\parent\scroll\h = 0
               EndIf
               ; *this\parent\scroll = #Null
            EndIf
            
            If *this\parent\type = #__type_Splitter
               If *this\parent\split_1( ) = *this
                  FreeStructure( *this\parent\split_1( ) )
                  *this\parent\split_1( ) = 0
               EndIf
               If *this\parent\split_2( ) = *this
                  FreeStructure( *this\parent\split_2( ) )
                  *this\parent\split_2( ) = 0
               EndIf
            EndIf
            
            ;
            If *this\parent\haschildren
               LastElement(*this\_widgets( ))
               Repeat
                  If *this\_widgets( ) = *this Or IsChild( *this\_widgets( ), *this )
                     If *this\_widgets( )\root\haschildren > 0
                        *this\_widgets( )\root\haschildren - 1
                        
                        If *this\_widgets( )\parent <> *this\_widgets( )\root
                           *this\_widgets( )\parent\haschildren - 1
                        EndIf
                        
                        If *this\_widgets( )\TabBox( )
                           If *this\_widgets( )\TabBox( ) = *this\_widgets( )
                              Debug "   free - tab " + *this\_widgets( )\TabBox( )\class
                              FreeStructure( *this\_widgets( )\TabBox( ) )
                              *this\_widgets( )\TabBox( ) = 0
                           EndIf
                           *this\_widgets( )\TabBox( ) = #Null
                        EndIf
                        
                        If *this\_widgets( )\scroll
                           If *this\_widgets( )\scroll\v
                              Debug "   free - scroll-v " + *this\_widgets( )\scroll\v\class
                              FreeStructure( *this\_widgets( )\scroll\v )
                              *this\_widgets( )\scroll\v = 0
                           EndIf
                           If *this\_widgets( )\scroll\h
                              Debug "   free scroll-h - " + *this\_widgets( )\scroll\h\class
                              FreeStructure( *this\_widgets( )\scroll\h )
                              *this\_widgets( )\scroll\h = 0
                           EndIf
                           ; *this\_widgets( )\scroll = #Null
                        EndIf
                        
                        If *this\_widgets( )\type = #__type_Splitter
                           If *this\_widgets( )\split_1( )
                              Debug "   free - splitter - first " + *this\_widgets( )\split_1( )\class
                              FreeStructure( *this\_widgets( )\split_1( ) )
                              *this\_widgets( )\split_1( ) = 0
                           EndIf
                           If *this\_widgets( )\split_2( )
                              Debug "   free - splitter - second " + *this\_widgets( )\split_2( )\class
                              FreeStructure( *this\_widgets( )\split_2( ) )
                              *this\_widgets( )\split_2( ) = 0
                           EndIf
                        EndIf
                        
                        If *this\_widgets( )\bounds\attach
                           ;Debug " free - attach " +*this\_widgets( )\bounds\attach\parent\class
                           *this\_widgets( )\bounds\attach\parent = 0
                           FreeStructure( *this\_widgets( )\bounds\attach )
                           *this\_widgets( )\bounds\attach = #Null
                        EndIf
                        
                        If EnteredWidget( ) = *this\_widgets( )
                           EnteredWidget( ) = 0
                        EndIf
                        If PressedWidget( ) = *this\_widgets( )
                           PressedWidget( ) = 0
                        EndIf
                        If FocusedWidget( ) = *this\_widgets( )
                           FocusedWidget( ) = 0
                        EndIf
                        *this\_widgets( )\address = 0
                        
                        Debug " free - " + *this\_widgets( )\class
                        
                        If *this\_widgets( )\BeforeWidget( )
                           *this\_widgets( )\BeforeWidget( )\AfterWidget( ) = *this\_widgets( )\AfterWidget( )
                           Debug " - BeforeWidget "+*this\_widgets( )\BeforeWidget( )\class
                        EndIf
                        ;             If *this\_widgets( )\FirstWidget( )
                        ;                Debug "  FirstWidget "+*this\_widgets( )\FirstWidget( )\class
                        ;             EndIf
                        ;             If *this\_widgets( )\LastWidget( )
                        ;                Debug "  LastWidget "+*this\_widgets( )\LastWidget( )\class
                        ;             EndIf
                        If *this\_widgets( )\AfterWidget( )
                           *this\_widgets( )\AfterWidget( )\BeforeWidget( ) = *this\_widgets( )\BeforeWidget( )
                           Debug " - AfterWidget "+*this\_widgets( )\AfterWidget( )\class
                        EndIf
                        
                        
                        
                        DeleteElement( *this\_widgets( ), 1 )
                     EndIf
                     
                     If *this\root\haschildren = 0
                        Break
                     EndIf
                  ElseIf PreviousElement( *this\_widgets( )) = 0
                     Break
                  EndIf
               ForEver
            EndIf
            
            If EnteredWidget( ) = *this
               EnteredWidget( ) = 0
            EndIf
            If PressedWidget( ) = *this
               PressedWidget( ) = 0
            EndIf
            If FocusedWidget( ) = *this
               FocusedWidget( ) = 0
            EndIf
            
            ;\\
            ;PostEventCanvasRepaint( *this\parent\root, #__event_free )
            ;ClearStructure( *this, _S_WIDGET )
            
            If *this = Root( )
               DeleteMapElement( Root( ), MapKey( Root( ) ) )
               ResetMap( Root( ) )
               Debug " free - "+*this\class
            EndIf
            
            ProcedureReturn 1
         EndIf
      EndIf
   EndProcedure
   
   Procedure CallBack( )
      Protected WidgetEventType = WidgetEventType( )
      
      
      If WidgetEventType = #__event_focus
         If EventWidget( )\parent
            ; __SetPosition( EventWidget( ), #PB_List_Last )
         EndIf
      EndIf
      
      
      Select WidgetEventType
         Case #__event_close;, #__event_focus
            Debug "close - event " + EventWidget( )\class ;+" --- "+ GetTitle( EventWidget( ) ) +" "+ GetCount( EventWidget( )\window ) 
            
            __Free( EventWidget( ) )
            
            
            
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
            
            ProcedureReturn 1
      EndSelect
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
      
      WaitEvent( #PB_All, @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 419
; FirstLine = 372
; Folding = ---------------
; EnableXP