IncludePath "../../../"
; XIncludeFile "gadget/gadgets.pbi"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global Canvas_0
  Define i, a, g = 1
  Global *g._S_widget
  Global *g0._S_widget
  Global *g1._S_widget
  Global *g2._S_widget
  Global *g3._S_widget
  Global *g4._S_widget
  Global *g5._S_widget
  Global *g6._S_widget
  Global *g7._S_widget
  Global *g8._S_widget
  Global *g9._S_widget
  
; ;   UsePNGImageDecoder()
; ;   
; ;   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
; ;     End
; ;   EndIf
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      ; Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+EventWidget( )+" "+WidgetEvent( )
    Protected EventGadget = EventWidget( )
    Protected EventType = WidgetEvent( )
    Protected EventData; = this()\data
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #__event_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #__event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__event_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
        ;; DD::DragText(GetItemText(EventGadget, EventItem))
        
      Case #__event_Drop : Debug "widget drop item = " + EventItem +" data "+ EventData
        ;; Debug DD::DropText()
        
      Case #__event_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #__event_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure.i add( *this._s_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
    ProcedureReturn AddItem( *this, position, Text, Image, sublevel)
    Protected handle, *last._s_ROWS, *parent._s_ROWS
    Protected *row.allocate(ROWS)
    ; sublevel + 1
    
    ;With *this
    If *this
      ;{ Генерируем идентификатор
      If position < 0 Or position > ListSize( *this\__rows( ) ) - 1
        If LastElement( *this\__rows( ) )
          ;;*this\row\last = *this\__rows( )
        EndIf
        handle = AddElement( *this\__rows( ) ) 
        ;If position < 0 
          position = ListIndex( *this\__rows( ) )
        ;EndIf
      Else
        handle = SelectElement( *this\__rows( ), position )
        ; for the tree( )
        If sublevel > *this\__rows( )\sublevel
          PushListPosition( *this\__rows( ) )
          If PreviousElement( *this\__rows( ) )
            *this\row\last = *this\__rows( )
            ;; NextElement( *this\__rows( ) )
          Else
            *last = *this\row\last
            sublevel = *this\__rows( )\sublevel
          EndIf
          PopListPosition( *this\__rows( ) )
; ;           If *last = *this\row\last
; ;             sublevel = *this\__rows( )\sublevel
; ;           EndIf
        Else
          *last = *this\row\last
          sublevel = *this\__rows( )\sublevel
        EndIf
        
        handle = InsertElement( *this\__rows( ) )
      EndIf
      ;}
      
      If handle
         *this\__rows( ) = *row
         
        If sublevel > position
          sublevel = position
        EndIf
        
        If *this\row\last 
          If sublevel > *this\row\last\sublevel
            sublevel = *this\row\last\sublevel + 1
            *parent = *this\row\last
            *parent\childrens = 1
            
          ElseIf *this\row\last\parent 
            If sublevel > *this\row\last\parent\sublevel 
              *parent = *this\row\last\parent
              
            ElseIf sublevel < *this\row\last\sublevel 
              If *this\row\last\parent\parent
                *parent = *this\row\last\parent\parent
                
                While *parent 
                  If sublevel >= *parent\sublevel 
                    If sublevel = *parent\sublevel 
                      *parent = 0
                    EndIf
                    Break
                  Else
                    *parent = *parent\parent
                  EndIf
                Wend
              EndIf
              
              ;; ; for the editor( )
              If *this\row\last\parent 
                If *this\row\last\parent\sublevel = sublevel 
; ;                   *last = *this\row\last\parent
; ;                   *parent = *this\row\last\parent
; ; ;                   *parent\_last = *this\__rows( )
; ;                    *this\row\last = *parent
                  *this\row\last\parent\after = *this\__rows( )
                  ;*this\row\last = *parent
                  Debug Text
                EndIf
              EndIf
              
            EndIf
          EndIf
        EndIf
        
        *this\__rows( )\parent = *parent
        
        If *last
         ; *this\row\last = *last
        Else
          *this\row\last = *this\__rows( )
        EndIf
        
        ; for the tree( )
        If *this\row\last\parent And 
           *this\row\last\parent\sublevel < sublevel
          *this\row\last\parent\_last = *this\row\last
        EndIf
        
        If sublevel = 0
          If *this\row\first 
            If *this\row\first\first
              *this\__rows( )\first = *this\row\first\first
            EndIf
            *this\row\first\first = *this\__rows( )
          EndIf
        EndIf
        
        If position = 0
          *this\row\first = *this\__rows( )
        EndIf
        
        *this\__rows( )\sublevel = sublevel
        
        ; add lines
        *this\__rows( )\index = ListIndex( *this\__rows( ) )
        *this\__rows( )\color = _get_colors_( )
        *this\__rows( )\color\state = 0
        *this\__rows( )\color\back = 0 
        *this\__rows( )\color\frame = 0
        
        If Text
          *this\__rows( )\text\change = 1
          *this\__rows( )\text\string = StringField( Text.s, 1, #LF$ )
          *this\__rows( )\text\edit\string = StringField( Text.s, 2, #LF$ )
        EndIf
        
        *this\countitems + 1
        *this\change = 1
      EndIf
    EndIf
    ;EndWith
    
    ProcedureReturn *this\countitems - 1
  EndProcedure
  
  LoadFont(5, "Arial", 16)
  LoadFont(6, "Arial", 25)
    
  
  Open(OpenWindow(-1, 0, 0, 1110, 650, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  
  
; ;     *g = Tree(10, 100, 210, 210, #__tree_CheckBoxes)                                         
; ;     
; ;     
; ;     ; 1_example
; ;     add(*g, 0, "Normal Item "+Str(a), -1, 0)                                   
; ;     add(*g, -1, "Node "+Str(a), 0, 0)                                         
; ;     add(*g, -1, "Sub-Item 1", -1, 1)                                           
; ;     add(*g, -1, "Sub-Item 2", -1, 11)
; ;     add(*g, -1, "Sub-Item 3", -1, 1)
; ;     add(*g, -1, "Sub-Item 4", -1, 1)                                           
; ;     add(*g, -1, "Sub-Item 5", -1, 11)
; ;     add(*g, -1, "Sub-Item 6", -1, 1)
; ;     add(*g, -1, "File "+Str(a), -1, 0)  
; ;     ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
; ;     
; ; ; ;     ; RemoveItem(*g,1)
; ; ; ;     SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
; ; ; ;     ;BindGadgetEvent(g, @Events())
; ; ; ;     ;     SetState(*g, 3)
; ; ; ;     ;     SetState(*g, -1)
; ; ; ;     ;Debug " - "+GetText(*g)
; ; ; ;     LoadFont(3, "Arial", 18)
; ; ; ;     SetFont(*g, 3)
    
    ; 1_example
    *g = Tree(10, 10, 210, 100, #__tree_CheckBoxes)                                         
    add(*g, -1, "Node "+Str(a), 0, 0)                                         
    add(*g, -1, "Sub-Item 1", -1, 1)                                           
    add(*g, -1, "Sub-Item 3", -1, 3)
    add(*g, -1, "Sub-Item 2", -1, 2)
    add(*g, -1, "Sub-Item 4", -1, 4)
    
    ; 2_example
    *g = Tree(10, 10+110, 210, 100, #__tree_CheckBoxes)                                         
    add(*g, 0, "Node "+Str(a), 0, 0)                                         
    add(*g, 1, "Sub-Item 1", -1, 1)                                           
    add(*g, 3, "Sub-Item 3", -1, 3)
    add(*g, 2, "Sub-Item 2", -1, 2)
    add(*g, 4, "Sub-Item 4", -1, 4)
    
    ;{  5_example
    *g5 = Tree(230, 10, 103, 210, #__Tree_NoButtons|#__flag_collapsed)                                         
    add(*g5, 0, "Tree_0", -1 )
    add(*g5, 1, "Tree_1", -1, 0) 
    add(*g5, 2, "Tree_2", -1, 0) 
    add(*g5, 3, "Tree_3", -1, 0) 
    add(*g5, 0, "Tree_0 (NoButtons)", -1 )
    add(*g5, 1, "Tree_1", -1, 1) 
    add(*g5, 2, "Tree_2_1", -1, 1) 
    add(*g5, 2, "Tree_2_2", -1, 2) 
    For i = 0 To 10
      add(*g5, -1, "Normal Item "+Str(i), 0, 0) ; if you want to add an image, use
      add(*g5, -1, "Node "+Str(i), 0, 0)        ; ImageID(x) as 4th parameter
      add(*g5, -1, "Sub-Item 1", 0, 1)          ; These are on the 1st sublevel
      add(*g5, -1, "Sub-Item 2", 0, 1)
      add(*g5, -1, "Sub-Item 3", 0, 1)
      add(*g5, -1, "Sub-Item 4", 0, 1)
      add(*g5, -1, "File "+Str(i), 0, 0) ; sublevel 0 again
    Next
    
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    ;     SetItemImage(*g, 0, 0)
    ;}
    
    ;{  6_example
    *g6 = Tree(341, 10, 103, 210, #__flag_border_Less|#__flag_collapsed)                                         
    
    add(*g6, 0, "Tree_1", -1, 1) 
    add(*g6, 0, "Tree_2_1", -1, 2) 
    add(*g6, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        add(*g6, -1, "Directory" + Str(i), -1, 0)
      Else
        add(*g6, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    add(*g6, 0, "Tree_0", -1, 1) 
     ;}
    
    
    Splitter(230, 10, 210, 210, *g6,*g5, #PB_Splitter_Vertical)                                         
    
    
       ;  2_example
    *g = Tree(450, 10, 210, 210);|#__flag_collapsedd)                                         
    add(*g, 0, "Tree_0", -1 )
    add(*g, 1, "Tree_1_1", 0, 1) 
    add(*g, 4, "Tree_1_1_1", -1, 2) 
    add(*g, 5, "Tree_1_1_2", -1, 2) 
    add(*g, 6, "Tree_1_1_2_1", -1, 3) 
    add(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    add(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    add(*g, 2, "Tree_1_2", -1, 1) 
    add(*g, 3, "Tree_1_3", -1, 4) 
    add(*g, 9, "Tree_2",-1 )
    add(*g, 10, "Tree_3", -1 )
    add(*g, 11, "Tree_4", -1 )
    add(*g, 12, "Tree_5", -1 )
    add(*g, 13, "Tree_6", -1 )
    add(*g, 14, "Tree_7", -1 )
; ;     ;Bind(*g, @events_tree_widget())
; ;     DD::EnableDrop(*g, #PB_Drop_Text, #PB_Drag_Copy)
    
    
 ;{  4_example
    *g = Tree(670, 10, 210, 210, #__tree_NoLines);|#__flag_optionboxes|#__tree_NoButtons) ;                                        
        add(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
        add(*g, 1, "Tree_1", -1, 1) 
        add(*g, 2, "Tree_2_2", -1, 2) 
        add(*g, 2, "Tree_2_1", -1, 1) 
        add(*g, 3, "Tree_3_1", -1, 1) 
        add(*g, 3, "Tree_3_2", -1, 2) 
        For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
; ;     add(*g, -1, "#PB_Window_SystemMenu    ", -1,1) ; Enables the system menu on the window title bar (Default", -1).
; ;     add(*g, -1, "#PB_Window_TitleBar      ", -1,1) ; Creates a window With a titlebar.
; ;     add(*g, -1, "#PB_Window_BorderLess    ", -1,1) ; Creates a window without any borders.
; ;     add(*g, -1, "#PB_Window_Tool          ", -1,1) ; Creates a window With a smaller titlebar And no taskbar entry. 
; ;     add(*g, -1, "#PB_Window_MinimizeGadget", -1) ; Adds the minimize gadget To the window title bar. add(*g, -1, "#PB_Window_SystemMenu is automatically added.
; ;     add(*g, -1, "#PB_Window_MaximizeGadget", -1) ; adds the maximize gadget To the window title bar. add(*g, -1, "#PB_Window_SystemMenu is automatically added.
; ;     add(*g, -1, "#PB_Window_SizeGadget    ", -1) ; adds the sizeable feature To a window.
; ;                                                       ;                              (MacOS only", -1) ; add(*g, -1, "#PB_Window_SizeGadget", -1) ; will be also automatically added", -1).
; ;     add(*g, -1, "#PB_Window_Maximize      ", -1, 1); Opens the window maximized. (Note", -1) ; on Linux, Not all Windowmanagers support this", -1)
; ;     add(*g, -1, "#PB_Window_Minimize      ", -1, 1); Opens the window minimized.
; ;     
; ;     add(*g, -1, "#PB_Window_Invisible     ", -1) ; Creates the window but don't display.
; ;     add(*g, -1, "#PB_Window_NoGadgets     ", -1)   ; Prevents the creation of a GadgetList. UseGadgetList(", -1) can be used To do this later.
; ;     add(*g, -1, "#PB_Window_NoActivate    ", -1)   ; Don't activate the window after opening.
; ;     add(*g, -1, "#PB_Window_ScreenCentered", -1, 1)   ; Centers the window in the middle of the screen. x,y parameters are ignored.
; ;     add(*g, -1, "#PB_Window_WindowCentered", -1, 1)   ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified", -1). x,y parameters are ignored.
    ;}                                                    ;
    
    ;{  3_example
    *g = Tree(890, 10, 210, 210, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__flag_GridLines | #__tree_ThreeState | #__flag_optionboxes)                            
    add(*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5 ;Or i%3=0
        add(*g, -1, "Tree_"+Str(i), -1, 0) 
      Else
        add(*g, -1, "Tree_"+Str(i), 0, -1) 
      EndIf
    Next 
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    SetItemState(*g, 0, #PB_Tree_Selected|#PB_Tree_Checked)
    SetItemState(*g, 5, #PB_Tree_Selected|#PB_Tree_Inbetween)
    
    ;LoadFont(5, "Arial", 16)
    
    SetItemFont(*g, 3, 5)
    SetItemText(*g, 3, "16_font and text change")
    SetItemColor(*g, 5, #PB_Gadget_FrontColor, $FFFFFF00)
    SetItemColor(*g, 5, #pb_gadget_backcolor, $FFFF00FF)
    SetItemText(*g, 5, "backcolor and text change")
    
    ;LoadFont(6, "Arial", 25)
    
    SetItemFont(*g, 4, 6)
    SetItemText(*g, 4, "25_font and text change")
    SetItemFont(*g, 14, 6)
    SetItemText(*g, 14, "25_font and text change")
    ;Bind(*g, @events_tree_widget())
    ;}
    
  
; ; ; ;   Open(OpenWindow(-1, 0, 0, 320, 620, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
; ; ; ;   
; ; ; ;   g = 11
    *g = Tree(10, 230, 210, 400);|#__flag_collapsedd)                                         
  
    ;  2_example
    add(*g, 0, "Structure widget", -1, 0)
    add(*g, 1, "window.i", -1, 1) 
    add(*g, 2, "gadget.i", -1, 1) 
    add(*g, 3, "EndStructure", -1, 0) 
    
    add(*g, 4, "", -1, 0) 
    
    add(*g, 5, "Enumeration widget", -1, 0)
    add(*g, 6, "#window", -1, 1) 
    add(*g, 7, "#gadget", -1, 1) 
    add(*g, 8, "EndEnumeration", -1, 0) 
    
    add(*g, 9, "", -1, 0) 
    
    add(*g, 10, "Procedure Open()", -1, 0) 
    add(*g, 11, "If is_widget()", -1, 1) 
    add(*g, 12, "If is_Hide()", -1, 2) 
    add(*g, 13, " 1", -1, 3) 
    add(*g, 14, "EndIf ; is_hide", -1, 2) 
    add(*g, 15, "If is_visible()", -1, 2) 
    add(*g, 16, " 2", -1, 3) 
    add(*g, 17, "EndIf ; is_visible", -1, 2) 
    add(*g, 18, "EndIf ; is_widget", -1, 1) 
    add(*g, 19, "EndProcedure", -1, 0) 
  
; ; ; ;   
; ; ; ; ; ;   ;  0_example
; ; ; ; ; ;   add(*g, 0, "Tree_0", -1 )
; ; ; ; ; ;   add(*g, 1, "Tree_1_1", 0, 1) 
; ; ; ; ; ;   add(*g, 4, "Tree_1_1_1", -1, 2) 
; ; ; ; ; ;   add(*g, 5, "Tree_1_1_2", -1, 2) 
; ; ; ; ; ;   add(*g, 6, "Tree_1_1_2_1", -1, 3) 
; ; ; ; ; ;   add(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
; ; ; ; ; ;   add(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
; ; ; ; ; ;   add(*g, 2, "Tree_1_2", -1, 1) 
; ; ; ; ; ;   add(*g, 3, "Tree_1_3", -1, 4) 
; ; ; ; ; ;   add(*g, 9, "Tree_2",-1 )
; ; ; ; ; ;   add(*g, 10, "Tree_3", -1 )
; ; ; ; ; ;   add(*g, 11, "Tree_4", -1 )
; ; ; ; ; ;   add(*g, 12, "Tree_5", -1 )
; ; ; ; ; ;   add(*g, 13, "Tree_6", -1 )
; ; ; ; ; ;   add(*g, 14, "Tree_7", -1 )
; ; ; ;  
; ; ; ;   
; ; ; ;   Define item = 2
; ; ; ;   Define sublevel = 2
; ; ; ;   
; ; ; ; ;     ; 1_example
; ; ; ; ;       add (*g, -1, "Node "+Str(a), 0, 0)                                         
; ; ; ; ;       add (*g, -1, "Sub-Item 1", -1, 1)                                           
; ; ; ; ;       add (*g, -1, "Sub-Item 3", -1, 3)
; ; ; ; ;       add (*g, -1, "Sub-Item 2", -1, 2)
; ; ; ; ;       add (*g, -1, "Sub-Item 4", -1, 4)
; ; ; ; ;       add (*g, item, "add-Item "+Str(item), -1, sublevel)
; ; ; ; ;     
; ; ; ;   
; ; ; ; ;     ; 2_example
; ; ; ; ;     add (*g, 0, "Node "+Str(a), 0, 0)                                         
; ; ; ; ;     add (*g, 1, "Sub-Item 1", -1, 1)                                           
; ; ; ; ;     add (*g, 3, "Sub-Item 3", -1, 3)
; ; ; ; ;     add (*g, 2, "Sub-Item 2", -1, 2)
; ; ; ; ;     add (*g, 4, "Sub-Item 4", -1, 4)
; ; ; ; ;     add (*g, item, "add-Item "+Str(item), -1, sublevel)
; ; ; ; ;   
; ; ; ;   
; ; ; ;   ; 3_example
; ; ; ;   add (*g, 0, "Tree_1", -1, 1) 
; ; ; ;   add (*g, 0, "Tree_2_1", -1, 2) 
; ; ; ;   add (*g, 0, "Tree_2_2", -1, 3) 
; ; ; ;         
; ; ; ;   For i = 0 To 14
; ; ; ;     If i % 5 = 0
; ; ; ;       add (*g, -1, "Directory" + Str(i), -1, 0)
; ; ; ;     Else
; ; ; ;       add (*g, -1, "Item" + Str(i), -1, 1)
; ; ; ;     EndIf
; ; ; ;   Next i
  
;   ForEach *g\row\_s()
;     If *g\row\_s()\parent ;And *g\row\_s()\parent\_last = *g\row\_s()
;       Debug *g\row\_s()\text\string +" p "+ *g\row\_s()\parent\text\string +" l "+ *g\row\_s()\parent\_last\text\string
;     EndIf
;   Next
;   Debug ""
  
  Repeat
    Select WaitWindowEvent()   
      Case #PB_Event_CloseWindow
        CloseWindow(EventWindow()) 
        Break
    EndSelect
  ForEver
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 367
; FirstLine = 362
; Folding = -------
; Optimizer
; EnableXP
; DPIAware