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
   
   
   
   Procedure.i AddItems( *this._s_WIDGET, List *rows._S_ROWS( ), position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected *rowLast._s_ROWS 
      Protected *row.allocate(ROWS)
      Protected *rowParent._s_ROWS
      
      If *this
         If *row
            ;{ Генерируем идентификатор
            If position < 0 Or position > ListSize( *rows( )) - 1
               ResetList( *rows( )) 
               LastElement( *rows( ))
               AddElement( *rows( ))
               ;
               position = ListIndex( *rows( ))
               ;
               *rows( ) = *row
               *rowLast = *this\RowLast( )
               *this\RowLast( ) = *row
             Else
               SelectElement( *rows( ), position )
               
               ; for the tree( )
               If sublevel > *rows( )\sublevel
                  PushListPosition( *rows( ))
                  If PreviousElement( *rows( ))
                     *rowLast = *rows( )
                  Else
                     sublevel = *rows( )\sublevel
                  EndIf
                  PopListPosition( *rows( ))
               Else
                  sublevel = *rows( )\sublevel
               EndIf
               
               InsertElement( *rows( ))
               *rows( ) = *row
               ;
               ;PushListPosition( *rows( ))
               While NextElement( *rows( ))
                  *rows( )\lindex = ListIndex( *rows( ) )
               Wend
               ;PopListPosition(*rows( ))
            EndIf
            ;}
            
            ;
            If sublevel > position
               sublevel = position
            EndIf
            ;
            *row\rindex = position 
            *row\columnindex = ListIndex( *this\columns( ))
            ;
            If *rowLast 
               If sublevel > *rowLast\sublevel
                  sublevel    = *rowLast\sublevel + 1
                  *rowParent = *rowLast
                  
               ElseIf *rowLast\RowParent( )
                  If sublevel > *rowLast\RowParent( )\sublevel
                     *rowParent = *rowLast\RowParent( )
                     
                  ElseIf sublevel < *rowLast\sublevel
                     If *rowLast\RowParent( )\RowParent( )
                        *rowParent = *rowLast\RowParent( )\RowParent( )
                        
                        While *rowParent
                           If sublevel >= *rowParent\sublevel
                              If sublevel = *rowParent\sublevel
                                 *rowParent = *rowParent\RowParent( )
                              EndIf
                              Break
                           Else
                              *rowParent = *rowParent\RowParent( )
                           EndIf
                        Wend
                     EndIf
                     
                     ; for the editor( )
                     If *rowLast\RowParent( )
                        If *rowLast\RowParent( )\sublevel = sublevel
                           ;                     *row\before = *rowLast\RowParent( )
                           ;                     *rowLast\RowParent( )\after = *row
                           
                           If *this\type = #__type_Editor
                              *rowParent         = *rowLast\RowParent( )
                              *rowParent\_last    = *row
                              *rowLast = *rowParent
                           EndIf
                           
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            ;
            If sublevel
               *row\sublevel = sublevel
            EndIf
            
            ;
            If sublevel = 0
               If position = 0
                  *this\RowFirstLevelFirst( ) = *row
               EndIf
               If *this\RowLast( ) = *row
                  *this\RowFirstLevelLast( ) = *row
               EndIf
            EndIf
            
            ;
            If *rowParent
               *row\RowParent( ) = *rowParent
               *rowParent\childrens + 1
               
               If *rowParent\sublevel < sublevel
                  ; for the tree draw line
                  *rowParent\_last = *row
                  ;
                  If *this\mode\collapsed  
                     *rowParent\buttonbox\checked = 1
                     *row\hide                    = 1
                  EndIf
               EndIf
            EndIf
            
            ; properties
            If *this\flag & #__tree_property
               If *rowParent And Not *rowParent\sublevel And Not GetFontID( *rowParent )
                  *rowParent\color\back     = $FFF9F9F9
                  *rowParent\color\back[1]  = *rowParent\color\back
                  *rowParent\color\back[2]  = *rowParent\color\back
                  *rowParent\color\frame    = *rowParent\color\back
                  *rowParent\color\frame[1] = *rowParent\color\back
                  *rowParent\color\frame[2] = *rowParent\color\back
                  *rowParent\color\front[1] = *rowParent\color\front
                  *rowParent\color\front[2] = *rowParent\color\front
                  SetFontID( *rowParent, FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic )))
               EndIf
            EndIf
            
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
            ;                If *this\RowFirstLevelLast( )
            ;                   If *this\RowFirstLevelLast( )\_type = #__type_Option
            ;                      *row\_groupbar = *this\RowFirstLevelLast( )\_groupbar
            ;                   Else
            ;                      *row\_groupbar = *this\RowFirstLevelLast( )
            ;                   EndIf
            ;                Else
            *row\_groupbar = *row\RowParent( )
            ;                EndIf
            
            
            ;If Text
            *row\text\TextChange( ) = 1
            *row\text\string   = Text ; StringField( Text.s, ListIndex( *this\columns( )) + 1, #LF$);Chr(9) )
                                      ;*row\text\edit\string = StringField( Text.s, 2, #LF$ )
                                      ;EndIf
            
            ;\\
            If *row\columnindex = 0
               *this\countitems + 1
               *this\WidgetChange( ) = 1
               ; add_image( *this, *row\Image, Image )
               
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
      
      ProcedureReturn *row
   EndProcedure
   
   Procedure AddItem_( *this._s_WIDGET, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      ; ProcedureReturn AddItem( *this, position, Text, Image, sublevel )
      ProcedureReturn AddItems( *this, *this\__rows( ), position, Text, Image, sublevel )
   EndProcedure
   
   Procedure gadget_events()
      
   EndProcedure
   
   Procedure widget_events()
      
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo add item", #PB_Window_SystemMenu)
      ; demo gadget
      g = TreeGadget_(#PB_Any, 10, 10, 250, 450, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection)
      AddGadgetItem(g, 0, "0_0", 0 )
      AddGadgetItem(g, 1, "1_0_1", 0, 1) 
      AddGadgetItem(g, 4, "4_0_3", 0, 2) 
      AddGadgetItem(g, 5, "5_0_4", 0, 2) 
      AddGadgetItem(g, 6, "6_0_4_1", 0, 3) 
      AddGadgetItem(g, 8, "8_0_4_1_1 [------------------]", 0, 4) 
      AddGadgetItem(g, 7, "7_0_4_2", 0, 3) 
      AddGadgetItem(g, 2, "2_0_2", 0, 1) 
      AddGadgetItem(g, 3, "3_0_2_1", 0, 4) 
      ;
      ;
      AddGadgetItem(g, 9, "9_2",0 )
      AddGadgetItem(g, 10, "10_3", 0 )
      AddGadgetItem(g, 11, "11_4", 0 )
      AddGadgetItem(g, 12, "12_5", 0 )
      ;
      ; comment\uncomment
      AddGadgetItem(g, 8, "8_add",0 )
      ;
      AddGadgetItem(g, 13, "13_6", 0 )
      AddGadgetItem(g, 14, "14_7", 0 )
      
;       ;  
;       AddGadgetItem(g, 0, "Window ", 0, 0)
;       AddGadgetItem(g, 1, "Container ", 0, 1)
;       AddGadgetItem(g, -1, "but7ton ", 0, 1)
;       AddGadgetItem(g, 2, "Cont3ainer ", 0, 2)
;        AddGadgetItem(g, 5, "but4ton ", 0, 3)
; ;       AddGadgetItem(g, 2, "but2ton ", 0, 2)
; ;       AddGadgetItem(g, -1, "button ", 0, 1)
       
       ;
      BindGadgetEvent(g, @gadget_events())
      For a=0 To CountGadgetItems(g) - 1
         ;Debug GetGadgetItemText(g, a)
         SetGadgetItemState(g, a, #PB_Tree_Expanded) 
      Next
      Debug ""
      
      ; demo widget
      *g = Tree(265, 10, 250, 450, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      AddItem_(*g, 0, "0_0", -1 )
      AddItem_(*g, 1, "1_0_1", 0, 1) 
      AddItem_(*g, 4, "4_0_3", -1, 2) 
      AddItem_(*g, 5, "5_0_4", -1, 2) 
      AddItem_(*g, 6, "6_0_4_1", -1, 3) 
      AddItem_(*g, 8, "8_0_4_1_1 [------------------]", -1, 4) 
      AddItem_(*g, 7, "7_0_4_2", -1, 3) 
      AddItem_(*g, 2, "2_0_2", -1, 1) 
      AddItem_(*g, 3, "3_0_2_1", -1, 4) 
      ;       ;
      ;       ;
      AddItem_(*g, 9, "9_2",-1 )
      AddItem_(*g, 10, "10_3", -1 )
      AddItem_(*g, 11, "11_4", -1 )
      AddItem_(*g, 12, "12_5", -1 )
      ;       ;
      ; comment\uncomment
      AddItem_(*g, 8, "8_add", -1 )
      ;
      AddItem_(*g, 13, "13_6", -1 )
      AddItem_(*g, 14, "14_7", -1 )
      
      
;        AddItem_(*g, 0, "Window ", -1, 0)
;       AddItem_(*g, 1, "Container ", -1, 1)
;       AddItem_(*g, -1, "but7ton ", -1, 1)
;       AddItem_(*g, 2, "Cont3ainer ", -1, 2)
;        AddItem_(*g, 5, "but4ton ", -1, 3)
; ;       AddItem_(*g, 2, "but2ton ", -1, 2)
; ;       AddItem_(*g, -1, "button ", -1, 1)
      
      Debug *g\Rowlast( )\text\string
      
      Bind(*g, @widget_events())
      
      ;       For a=0 To CountItems(*g) - 1
      ;          Debug GetItemText(*g, a)
      ;       Next
      
      ForEach *g\__rows( )
         Debug ""+*g\__rows( )\index +" "+*g\__rows( )\sublevel +" "+*g\__rows( )\text\string
      Next
      
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 116
; FirstLine = 103
; Folding = -------
; EnableXP
; DPIAware