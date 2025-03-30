; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g._s_WIDGET, g, CountItems=9; количесвто итемов 
   
   Procedure TreeGadget_(gadget, X,Y,Width,Height,flag=0)
      Protected g = PB(TreeGadget)(gadget, X,Y,Width,Height,flag)
      If gadget =- 1 : gadget = g : EndIf
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         Define RowHeight.CGFloat = 20
         ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
         CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
      CompilerElse
      CompilerEndIf
      
      ProcedureReturn gadget
   EndProcedure
   
   
   
   Procedure.i AddItem_Tree( *this._s_WIDGET, List *rows._S_ROWS( ), position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected last
      Protected *row.allocate(ROWS)
      Protected._s_ROWS *parent_row
      
      If *this
         If *row
            ;{ Генерируем идентификатор
            If position < 0 Or position > ListSize( *this\__rows( )) - 1
               ResetList( *this\__rows( )) 
               LastElement( *this\__rows( ))
               AddElement( *this\__rows( ))
               
               If position < 0
                  position = ListIndex( *this\__rows( ))
               EndIf
            Else
               SelectElement( *this\__rows( ), position )
              ; Debug "   "+position +" "+ *this\__rows( )\txt\string
               ;                   PushListPosition( *this\__rows( ))
               ;                   While NextElement( *this\__rows( ))
               ;                      If *this\__rows( )\_index = position
               ;                         *this\__rows( )\_index + 1
               ;                      Else
               ;                         Break
               ;                      EndIf
               ;                   Wend
               ;                   PopListPosition( *this\__rows( ))
               
               ;                  ; ProcedureReturn 
               ; for the tree( )
               
               If sublevel
                  If sublevel > *this\__rows( )\sublevel
                  PushListPosition( *this\__rows( ))
                  If PreviousElement( *this\__rows( ))
                     *this\RowLast( ) = *this\__rows( )
                  Else
                     last     = *this\RowLast( )
                     sublevel = *this\__rows( )\sublevel
                  EndIf
                  PopListPosition( *this\__rows( ))
               Else
                  last     = *this\RowLast( )
                  sublevel = *this\__rows( )\sublevel
                  
                  *this\RowLast( ) =  *this\__rows( )
               EndIf
               EndIf
               
               InsertElement( *this\__rows( ))
            EndIf
            ;}
            
            *this\__rows( ) = *row
            
            
            If *this\RowLast( )
               If sublevel > *this\RowLast( )\sublevel
                  sublevel    = *this\RowLast( )\sublevel + 1
                  *parent_row = *this\RowLast( )
                  
               ElseIf *this\RowLast( )\RowParent( )
                  If sublevel > *this\RowLast( )\RowParent( )\sublevel
                     *parent_row = *this\RowLast( )\RowParent( )
                     
                  ElseIf sublevel < *this\RowLast( )\sublevel
                     ; Debug position
                     If *this\RowLast( )\RowParent( )\RowParent( )
                        *parent_row = *this\RowLast( )\RowParent( )\RowParent( )
                        
                        While *parent_row
                           If sublevel >= *parent_row\sublevel
                              If sublevel = *parent_row\sublevel
                                 *parent_row = *parent_row\RowParent( )
                              EndIf
                              Break
                           Else
                              *parent_row = *parent_row\RowParent( )
                           EndIf
                        Wend
                     EndIf
                     
                     ;                         ; for the editor( )
                     ;                         If *this\RowLast( )\RowParent( )
                     ;                            If *this\RowLast( )\RowParent( )\sublevel = sublevel
                     ;                               ;                     *row\before = *this\RowLast( )\RowParent( )
                     ;                               ;                     *this\RowLast( )\RowParent( )\after = *row
                     ;                               
                     ;                               If *this\type = #__type_Editor
                     ;                                  *parent_row         = *this\RowLast( )\RowParent( )
                     ;                                  *parent_row\_last    = *row
                     ;                                  *this\RowLast( ) = *parent_row
                     ;                                  last                = *parent_row
                     ;                               EndIf
                     ;                               
                     ;                            EndIf
                     ;                         EndIf
                  EndIf
               EndIf
               
               ; position = *this\RowLast( )\index + 1
            Else
               ; position = 0
            EndIf
            
            If *parent_row
               *parent_row\childrens + 1
               *row\RowParent( ) = *parent_row
            EndIf
            
            *row\columnindex = ListIndex( *this\columns( ))
            *row\rindex = position 
            
            If sublevel > position
               sublevel = position
            EndIf
            
            If sublevel
               *row\sublevel = sublevel
            EndIf
            
            If position = 0
               If sublevel = 0
                  ;*this\RowFirst( ) = *row
               EndIf
            EndIf
            
            If Not last
               If sublevel = 0
                  *this\RowLast( ) = *row
               EndIf
               ;
               *this\RowLast( ) = *row
               ;
               ; for the tree( )
               If *row\RowParent( ) And
                  *row\RowParent( )\sublevel < sublevel
                  *row\RowParent( )\_last = *row
               EndIf
            EndIf
            
            
            If *this\mode\collapsed And 
               *row\RowParent( ) And *row\sublevel > *row\RowParent( )\sublevel
               *row\RowParent( )\buttonbox\checked = 1
               *row\hide                      = 1
            EndIf
            
            ;                ; properties
            ;                If *this\flag & #__tree_property
            ;                   If *parent_row And Not *parent_row\sublevel And Not GetFontID( *parent_row )
            ;                      *parent_row\color\back     = $FFF9F9F9
            ;                      *parent_row\color\back[1]  = *parent_row\color\back
            ;                      *parent_row\color\back[2]  = *parent_row\color\back
            ;                      *parent_row\color\frame    = *parent_row\color\back
            ;                      *parent_row\color\frame[1] = *parent_row\color\back
            ;                      *parent_row\color\frame[2] = *parent_row\color\back
            ;                      *parent_row\color\front[1] = *parent_row\color\front
            ;                      *parent_row\color\front[2] = *parent_row\color\front
            ;                      SetFontID( *parent_row, FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic )))
            ;                   EndIf
            ;                EndIf
            
            ; add lines
            *row\color         = *this\color ; _get_colors_( )
            *row\ColorState( ) = 0
            *row\color\back    = 0
            *row\color\frame   = 0
            
            *row\color\fore[0] = 0
            *row\color\fore[1] = 0
            *row\color\fore[2] = 0
            *row\color\fore[3] = 0
            
            ;
            ;                If *this\RowLast( )
            ;                   If *this\RowLast( )\_type = #__type_Option
            ;                      *row\_groupbar = *this\RowLast( )\_groupbar
            ;                   Else
            ;                      *row\_groupbar = *this\RowLast( )
            ;                   EndIf
            ;                Else
            *row\_groupbar = *row\RowParent( )
            ;                EndIf
            
            
            ;If Text
            *row\txt\TextChange( ) = 1
            *row\txt\string   = Text ; StringField( Text.s, ListIndex( *this\columns( )) + 1, #LF$);Chr(9) )
                                      ;*row\txt\edit\string = StringField( Text.s, 2, #LF$ )
                                      ;EndIf
            
            ;\\
            If *row\columnindex = 0
               *this\countitems + 1
               *this\WidgetChange( ) = 1
               ;add_image( *this, *row\Image, Image )
               
               If *this\RowFocused( )
                  *this\RowFocused( )\_focus = 0
                  *this\RowFocused( )\ColorState( ) = #__s_0
                  
                  *this\RowFocused( )             = *row
                  *this\RowFocused( )\_focus = 1
                  *this\RowFocused( )\ColorState( ) = #__s_2 + Bool( *this\focus = 0 )
               EndIf
               
               If *this\ScrollState( ) = #True
                  *this\ScrollState( ) = - 1
               EndIf
               
               If test_redraw_items
                  PostReDraw( *this\root )
               EndIf
            EndIf
         EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *row
   EndProcedure
   
   
   Procedure AddItem_( *this._s_WIDGET, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      ProcedureReturn AddItem( *this, position, Text, Image, sublevel )
   EndProcedure
   
   Procedure AddGadgetItem_( gadget, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      ProcedureReturn ToolBarImageButton( position, 0, 0, Text )
   EndProcedure
   
   Procedure gadget_events()
      
   EndProcedure
   
   Procedure widget_events()
      
   EndProcedure
   
   If OpenWindow(1, 100, 50, 1025, 435+40, "demo add item", #PB_Window_SystemMenu)
      Open(1, 0,50)
      ; demo gadget
      g = CreateToolBar(-1, WindowID(1), #PB_ToolBar_Text|#PB_ToolBar_InlineText)
      AddGadgetItem_(g, 0, "0_0", 0 )
      AddGadgetItem_(g, 1, "1_0_1", 0, 1) 
      AddGadgetItem_(g, 4, "4_0_3", 0, 2) 
      AddGadgetItem_(g, 5, "5_0_4", 0, 2) 
      AddGadgetItem_(g, 6, "6_0_4_1", 0, 3) 
      AddGadgetItem_(g, 8, "8_0_4_1_1", 0, 4) 
      AddGadgetItem_(g, 7, "7_0_4_2", 0, 3) 
      AddGadgetItem_(g, 2, "2_0_2", 0, 1) 
      AddGadgetItem_(g, 3, "3_0_2_1", 0, 4) 
      ;
      ;
      AddGadgetItem_(g, 9, "9_2",0 )
      AddGadgetItem_(g, 10, "10_3", 0 )
      AddGadgetItem_(g, 11, "11_4", 0 )
      AddGadgetItem_(g, 12, "12_5", 0 )
      ;
      ; comment\uncomment
      AddGadgetItem_(g, 8, "8_add",0 )
      ;
      AddGadgetItem_(g, 13, "13_6", 0 )
      AddGadgetItem_(g, 14, "14_7", 0 )
;       For a=0 To 14
;       BindMenuEvent(g, a, @gadget_events())
;       Next
      Debug ""
      
      ; demo widget
      ;*g = ToolBar(root(), #__flag_vertical ) 
      *g = Tab(265, 10, 250, 450, #__flag_vertical ) 
      
      AddItem_(*g, 0, "    0_0", -1 )
      AddItem_(*g, 1, "    1_0_1", 0, 1) 
      AddItem_(*g, 4, "    4_0_3", -1, 2) 
      AddItem_(*g, 5, "    5_0_4", -1, 2) 
      AddItem_(*g, 6, "    6_0_4_1", -1, 3) 
      AddItem_(*g, 8, "    8_0_4_1_1", -1, 4) 
      AddItem_(*g, 7, "    7_0_4_2", -1, 3) 
      AddItem_(*g, 2, "    2_0_2", -1, 1) 
      AddItem_(*g, 3, "    3_0_2_1", -1, 4) 
      ;       ;
      ;       ;
      AddItem_(*g, 9, "    9_2",-1 )
      AddItem_(*g, 10, "    10_3", -1 )
      AddItem_(*g, 11, "    11_4", -1 )
      AddItem_(*g, 12, "    12_5", -1 )
      ;       ;
      ; comment\uncomment
      AddItem_(*g, 8, "    8_add", -1 )
      ;
      AddItem_(*g, 13, "    13_6", -1 )
      AddItem_(*g, 14, "    14_7", -1 )
      Bind(*g, @widget_events())
      
;       ;       For a=0 To CountItems(*g) - 1
;       ;          Debug GetItemText(*g, a)
;       ;       Next
;       
      ForEach *g\__tabs( )
         Debug ""+*g\__tabs( )\index +" "+*g\__tabs( )\txt\string
      Next
      
      
      Repeat
        Define Event = WaitWindowEvent()
        If Event = #PB_Event_Menu
            Debug "Идентификатор Панели инструментов: "+Str(EventMenu())
        EndIf
    Until Event = #PB_Event_CloseWindow

      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 152
; FirstLine = 139
; Folding = -------
; EnableXP
; DPIAware