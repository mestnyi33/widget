; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g1._s_WIDGET, g1, *g2._s_WIDGET, g2, CountItems=9; количесвто итемов 
   
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
      Protected last
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
                  ;Else
                     ;last     = *this\RowLast( )
                     ;sublevel = *rows( )\sublevel
                  EndIf
                  PopListPosition( *rows( ))
               Else
                  last     = *this\RowLast( )
                  sublevel = *rows( )\sublevel
                  *rowLast = *rows( )
               EndIf
               
               InsertElement( *rows( ))
               *rows( ) = *row
               
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
            If *rowLast
               If sublevel   > *rowLast\sublevel
                  sublevel   = *rowLast\sublevel + 1
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
                              *rowParent\_last   = *row
                              *this\RowLast( )   = *rowParent
                              last               = *rowParent
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
               *rowParent\childrens + 1
               *row\RowParent( ) = *rowParent
               
               If *rowParent\sublevel < sublevel
                  If Not last
                     ; for the tree draw line
                     *rowParent\_last = *row
                  EndIf
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
            *row\rindex        = position 
            *row\columnindex   = ListIndex( *this\columns( ))
            
            If *this\mode\check
               *row\checkbox.allocate( BOX )
            EndIf
            If *this\mode\lines Or *this\mode\buttons
               *row\buttonbox.allocate( BOX )
            EndIf
                        
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
            *row\TextChange( ) = 1
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
               
               If *this\row\autoscroll = #True
                  *this\row\autoscroll = - 1
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
      ;ProcedureReturn AddItem( *this, position, Text, Image, sublevel )
      ProcedureReturn AddItems( *this, *this\__rows( ), position, Text, Image, sublevel )
   EndProcedure
   
   Procedure gadget_events()
      
   EndProcedure
   
   Procedure widget_events()
      
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo remove item", #PB_Window_SystemMenu)
      ; demo gadget
      g1 = TreeGadget_(#PB_Any, 10, 10, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection)
      AddGadgetItem(g1, 0, "Window ", 0, 0)
      AddGadgetItem(g1, 1, "Container1 ", 0, 1)
      AddGadgetItem(g1, -1, "Container2 ", 0, 1)
      AddGadgetItem(g1, 2, "button1 ", 0, 2)
      AddGadgetItem(g1, 5, "button2 ", 0, 3)
      ;        AddGadgetItem(g1, 2, "button0 ", 0, 2)
      ;        AddGadgetItem(g1, -1, "button ", 0, 1)
      
      
      g2 = TreeGadget_(#PB_Any, 10, 135, 250, 330);, #PB_Tree_NoButtons|#PB_Tree_NoLines)                                                                     
      AddGadgetItem(g2, 0, "0_0", 0 )
      AddGadgetItem(g2, 1, "1_0_1", 0, 1) 
      AddGadgetItem(g2, 4, "4_0_3", 0, 2) 
      AddGadgetItem(g2, 5, "5_0_4", 0, 2) 
      AddGadgetItem(g2, 6, "6_0_4_1", 0, 3) 
      AddGadgetItem(g2, 8, "8_0_4_1_1 [------------------]", 0, 4) 
      AddGadgetItem(g2, 7, "7_0_4_2", 0, 3) 
      AddGadgetItem(g2, 2, "2_0_2", 0, 1) 
      AddGadgetItem(g2, 3, "3_0_2_1", 0, 4) 
      ;
      ;
      AddGadgetItem(g2, 9, "9_2",0 )
      AddGadgetItem(g2, 10, "10_3", 0 )
      AddGadgetItem(g2, 11, "11_4", 0 )
      AddGadgetItem(g2, 12, "12_5", 0 )
      ;
      ; comment\uncomment
      AddGadgetItem(g2, 8, "8_add",0 )
      ;
      AddGadgetItem(g2, 13, "13_6", 0 )
      AddGadgetItem(g2, 14, "14_7", 0 )
      
      ;       
      Define i : For i=0 To CountGadgetItems(g1)-1 : SetGadgetItemState(g1, i, #PB_Tree_Expanded) : Next
      Define i : For i=0 To CountGadgetItems(g2)-1 : SetGadgetItemState(g2, i, #PB_Tree_Expanded) : Next
      
      ;
      BindGadgetEvent(g1, @gadget_events())
      BindGadgetEvent(g2, @gadget_events())
      
      ; demo widget
      *g1 = Tree(265, 10, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      AddItem_(*g1, 0, "Window ", -1, 0)
      AddItem_(*g1, 1, "Container1 ", -1, 1)
      AddItem_(*g1, -1, "Container2 ", -1, 1)
      AddItem_(*g1, 2, "button1 ", -1, 2)
      AddItem_(*g1, 5, "button2 ", -1, 3)
      ;       AddItem(*g1, 2, "button0 ", -1, 2)
      ;       AddItem(*g1, -1, "button ", -1, 1)
      
      
      *g2 = Tree(265, 135, 250, 330);, #PB_Tree_NoButtons|#PB_Tree_NoLines )
      AddItem_(*g2, 0, "0_0", -1 )
      AddItem_(*g2, 1, "1_0_1", 0, 1) 
      AddItem_(*g2, 4, "4_0_3", -1, 2) 
      AddItem_(*g2, 5, "5_0_4", -1, 2) 
      AddItem_(*g2, 6, "6_0_4_1", -1, 3) 
      AddItem_(*g2, 8, "8_0_4_1_1 [------------------]", -1, 4) 
      AddItem_(*g2, 7, "7_0_4_2", -1, 3) 
      AddItem_(*g2, 2, "2_0_2", -1, 1) 
      AddItem_(*g2, 3, "3_0_2_1", -1, 4) 
      ;       ;
      ;       ;
      AddItem_(*g2, 9, "9_2",-1 )
      AddItem_(*g2, 10, "10_3", -1 )
      AddItem_(*g2, 11, "11_4", -1 )
      AddItem_(*g2, 12, "12_5", -1 )
      ;       ;
      ; comment\uncomment
      AddItem_(*g2, 8, "8_add", -1 )
      ;
      AddItem_(*g2, 13, "13_6", -1 )
      AddItem_(*g2, 14, "14_7", -1 )
      
      ;
      ; Define i : For i=0 To CountItems(*g1)-1 : SetItemState(*g1, i, #PB_Tree_Expanded) : Next
      ; Define i : For i=0 To CountItems(*g2)-1 : SetItemState(*g2, i, #PB_Tree_Expanded) : Next
      
      Bind(*g1, @widget_events())
      Bind(*g2, @widget_events())
      
      ;       ;       For a=0 To CountItems(*g1) - 1
      ;       ;          Debug GetItemText(*g1, a)
      ;       ;       Next
      ;       
      ForEach *g2\__rows( )
         Debug ""+*g2\__rows( )\parent +" "+*g2\__rows( )\index +" "+*g2\__rows( )\sublevel +" "+*g2\__rows( )\text\string
      Next
      
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 207
; FirstLine = 203
; Folding = -------
; EnableXP
; DPIAware