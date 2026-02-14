; Debug #PB_ListIcon_CheckBoxes           ; = 1           ; = 2
; Debug #PB_ListIcon_ThreeState           ; = 4           ; = 8
; Debug #PB_ListIcon_MultiSelect          ; = 4           ; = 1
; Debug #PB_ListIcon_AlwaysShowSelection  ; = 8           ; = 0
; Debug #PB_ListIcon_GridLines            ; = 65536       ; = 16
; Debug #PB_ListIcon_HeaderDragDrop       ; = 268435456   ; = 32
; Debug #PB_ListIcon_FullRowSelect        ; = 1073741824  ; = 0
; 
; ; GetGadgetAttribute
; Debug #PB_ListIcon_ColumnCount          ; = 3           ; = 3
; ; SetGadgetAttribute & GetGadgetAttribute
; Debug #PB_ListIcon_DisplayMode          ; = 2           ; = 2
;   Debug #PB_ListIcon_LargeIcon          ; = 0           ; = 0
;   Debug #PB_ListIcon_SmallIcon          ; = 1           ; = 1
;   Debug #PB_ListIcon_List               ; = 2           ; = 2
;   Debug #PB_ListIcon_Report             ; = 3           ; = 3
;   
;   ; SetGadgetItemAttribute & GetGadgetItemAttribute
; Debug #PB_ListIcon_ColumnWidth          ; = 1           ; = 1
; 
; Debug #PB_ListIcon_Selected             ; = 1           ; = 1
; Debug #PB_ListIcon_Checked              ; = 2           ; = 2
; Debug #PB_ListIcon_Inbetween            ; = 4           ; = 4
; 
; ;ListIconGadget(

;- 
;- example list-icon
;-
; CocoaMessage(0, GadgetID(0), "setHeaderView:", 0)

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure   Properties_Status( *splitter._s_WIDGET, *this._s_WIDGET, item )
      Protected._s_WIDGET *first = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected._s_WIDGET *second = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROWS *row
      Protected state
      
      ;
      If PushItem( *this )
         If SelectItem( *this, Item)
            *row = *this\__rows( )
         EndIf
         PopItem( *this)
      EndIf
      
      ; чтобы не виделялся
      If MouseDrag( )
         If *this\RowFocused( ) = *row 
            *row\focus = 1
            *row\ColorState( ) = #__s_2
         Else
            *row\focus = 0
            *row\ColorState( ) = #__s_0
         EndIf
         ProcedureReturn
      EndIf
      
      ;
      If *row\data
         Select *this
            Case *first 
               If GetState( *second ) <> *row\index
                  ChangeItemState( *second, *row\index, *row\ColorState( ))
               EndIf
            Case *second 
               If GetState( *first ) <> *row\index
                  ChangeItemState( *first, *row\index, *row\ColorState( ))
               EndIf   
         EndSelect
         
      Else
         Select *this
            Case *first 
               If *second\RowFocused( )
                  item = *second\RowFocused( )\index
                  state = *second\RowFocused( )\ColorState( ) 
               EndIf
               
            Case *second 
               If *first\RowFocused( )
                  item = *first\RowFocused( )\index
                  state = *first\RowFocused( )\ColorState( ) 
               EndIf
         EndSelect
         
         If GetState( *this ) <> item
            ChangeItemState( *this, item, state )
         EndIf
         
         *row\focus = 0
         *row\ColorState( ) = #__s_0
      EndIf
      
   EndProcedure
   
   Procedure listicon_tree_events( )
      Protected._s_WIDGET *g = EventWidget()
      Protected._s_WIDGET *area = *g\parent\data
      
      Select WidgetEvent( )
         Case #__event_StatusChange
            Protected._s_ROWS *row
            
            If PushItem( *g )
               If SelectItem( *g, WidgetEventItem( ))
                  *row = *g\__rows( )
               EndIf
               PopItem( *g)
            EndIf
            
            If StartEnum( *area )
               If *g = widgets()
                  Continue
               EndIf
               If widgets()\type = #__type_Tree
                  ChangeItemState( widgets(), *row\index, *row\ColorState( ))
               EndIf
               StopEnum()
            EndIf
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetAttribute( *area, #PB_ScrollArea_Y, GetAttribute( *area, #PB_ScrollArea_Y)-WidgetEventData())
            Else
               SetAttribute( *area, #PB_ScrollArea_X, GetAttribute( *area, #PB_ScrollArea_X)-WidgetEventData())
            EndIf
      EndSelect
      
   EndProcedure
   
   Procedure SetAttribute_( *this._s_WIDGET, attribute, value )
      Select attribute
         Case #PB_ScrollArea_InnerWidth
            ;Repaint( )
            If value < Width(*this)
               value = Width(*this)
            EndIf
            If SetAttribute( *this, attribute, value )
               If Not *this\flag & #__flag_AutoSize
                  Resize(*this\firstWidget( ), #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
               EndIf
            EndIf
            
         Case #PB_ScrollArea_InnerHeight
            ;Repaint( )
            If value < Height(*this)
               value = Height(*this)
            EndIf
            If SetAttribute( *this, attribute, value )
               If Not *this\flag & #__flag_AutoSize
                  Resize(*this\firstWidget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
               EndIf
            EndIf
            
      EndSelect
      
   EndProcedure
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected._s_WIDGET *parent = ScrollArea(X,Y,Width,Height, Width,Height, 1 )
      Protected._s_WIDGET *g1 = Tree(0,0,0,0, #__flag_NoLines|flags);|#__flag_BorderLess)
      Bind(*g1, @listicon_tree_events())
      Hide(*g1\scroll\v, 1)
      Hide(*g1\scroll\h, 1)
      SetData(*g1, 1)
      
      ;Protected *this._s_WIDGET = Splitter( 0,0,Width,Height, *g1,-1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      Protected *this._s_WIDGET = Splitter( 0,0,0,0, *g1,-1, #PB_Splitter_Separator|#PB_Splitter_Vertical|#PB_Splitter_FirstFixed|#__flag_AutoSize|#__flag_BorderLess )
;       ;
;       *this\bar\button\size = DPIScaled(1)
;       *this\bar\button\size + Bool( *this\bar\button\size % 2 )
;       *this\bar\button\round = 0;  DPIScaled(1)
      
      If flags & #__flag_CheckBoxes
         firstcolumnwidth + 25
      EndIf
      SetState( *this, firstcolumnwidth)
      SetData(*this, *parent)
      
     
   
      CloseList( )
      ProcedureReturn *parent
   EndProcedure
   
   Procedure AddColumn_( *parent._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Protected *this._s_WIDGET = *parent\FirstWidget( )
      
      If *this
         Protected._s_WIDGET *g,*g1,*g2
         Static X, parent
         
         If Not ( parent And IsChild( parent, *this ))
            parent = *this
         EndIf
         
         ;
         Define *Tree._s_WIDGET=GetAttribute(*this, #PB_Splitter_FirstGadget)
         *g2 = GetAttribute(parent, #PB_Splitter_SecondGadget)
         *g1 = Tree(0,0,0,0, #__flag_NoLines|(*Tree\flag&~#__flag_CheckBoxes)) ; 
         Bind(*g1, @listicon_tree_events())
         
         ;SetFlag(*g1, *Tree\flag)
         Hide(*g1\scroll\v, 1)
         Hide(*g1\scroll\h, 1)
         
         If position =- 1
            Static c = 1
            c + 1
            SetData(*g1, c)
         Else
            SetData(*g1, position+1)
         EndIf
         
         If *g2 > 0
            *g = Splitter( 0,0,0,0, *g2, *g1, #PB_Splitter_Separator|#PB_Splitter_Vertical|#PB_Splitter_FirstFixed|#__flag_BorderLess )
;             ;
;             *g\bar\button\size = DPIScaled(1)
;             *g\bar\button\size + Bool( *g\bar\button\size % 2 )
;             *g\bar\button\round = 0;  DPIScaled(1)
            
            SetAttribute( parent, #PB_Splitter_SecondGadget, *g )
            SetData(*g, *parent)
            SetState(*g, Width)
            If position =- 1
               c = 1  
            EndIf
            parent = *g
         Else
            SetAttribute( parent, #PB_Splitter_SecondGadget, *g1 )
            X = GetState(*this)
            parent = 0
         EndIf
         
         X + Width
         SetAttribute_( *parent, #PB_ScrollArea_InnerWidth, X )
         
         ProcedureReturn *g
      EndIf
   EndProcedure
   
   Procedure AddItem_( *parent._s_WIDGET, Item.l, Text.s, Image.i = - 1, Flag.q = 0 )
      Protected *this._s_WIDGET
      
      If GetType(*parent) = #__type_ScrollArea
         *this = *parent\FirstWidget( )
      Else
         *this = *parent
      EndIf
      
      If *this
         Protected._s_WIDGET *g1 = GetAttribute(*this, #PB_Splitter_FirstGadget)
         Protected._s_WIDGET *g2 = GetAttribute(*this, #PB_Splitter_SecondGadget)
         
         If GetType(*g1) = #__type_tree
            AddItem( *g1, Item, StringField(Text.s, GetData(*g1), #LF$), Image, Flag )
         EndIf
         If GetType(*g2) = #__type_tree
            AddItem( *g2, Item, StringField(Text.s, GetData(*g2), #LF$), -1, 0 )
         Else
            AddItem_( *g2, Item, Text.s, -1,0)
         EndIf
      EndIf
      
   EndProcedure
   
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetActiveWindow(0)
      
      Define Count = 500
      Debug "Create items count - "+Str(Count)
      
      ;{ - gadget 
      Define t=ElapsedMilliseconds()
      Define g = 1
      ListIconGadget(g, 10, 10, 165, 210,"Column_1",130)                                         
      For i=1 To 1 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
      For i=0 To 7
         AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
      Next
      
      g = 2
      ListIconGadget(g, 180, 10, 165, 210,"Column_1",130)                                         
      For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
      For i=0 To Count
         AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
      Next
      
      g = 3
      ListIconGadget(g, 350, 10, 430, 210,"Column_1",130, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
      
      ;HideListIcon_(g,1)
      For i=1 To 3
         AddGadgetColumn(g, i,"Column_"+Str(i+1),90)
      Next
      ; 1_example
      AddGadgetItem(g, -1, Chr(10)+"ListIcon_"+Str(i)) 
      For i=1 To 5
         AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
      Next
      ;HideListIcon_(g,0)
      
      Debug " time create gadget (listicon) - "+Str(ElapsedMilliseconds()-t)
      ;}
      
      
      ;{ - widget
      t=ElapsedMilliseconds()
      g = 11
      Define *g._s_WIDGET = ListIcon_(10, 230, 165, 210, "Column_1",130) ;: *g = GetGadgetData(g)                                        
      For i=1 To 1 : AddColumn_(*g, i,"Column_"+Str(i+1),90) : Next
      ; 1_example
      For i=0 To 7
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                          
      Next
      
      Repaint()
      Define value = *g\FirstWidget( )\split_1( )\Scroll\v\bar\max
      SetAttribute_( *g, #PB_ScrollArea_InnerHeight, value )
      
      g = 12
      *g = ListIcon_(180, 230, 165, 210, "Column_1",130);, #__flag_RowFullSelect) ;: *g = GetGadgetData(g)                                          
      For i=1 To 2 : AddColumn_(*g, i,"Column_"+Str(i+1),90) : Next
      ; 1_example
      For i=0 To Count
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                          
      Next
      
      Repaint()
      Define value = *g\FirstWidget( )\split_1( )\Scroll\v\bar\max
      SetAttribute_( *g, #PB_ScrollArea_InnerHeight, value )
      
      g = 13
      *g = ListIcon_(350, 230, 430, 210, "Column_1",130, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
      
      ;HideListIcon_(g,1)
      For i=1 To 3
         AddColumn_(*g, i,"Column_"+Str(i+1),90)
      Next
      ; 1_example
      AddItem_(*g, -1, Chr(10)+"ListIcon_"+Str(i)) 
      For i=1 To 5
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                         
      Next
      ;HideListIcon_(g,0)
      
      Repaint()
      Define value = *g\FirstWidget( )\split_1( )\Scroll\v\bar\max
      SetAttribute_( *g, #PB_ScrollArea_InnerHeight, value )
     
      Debug " time create canvas (listicon) - "+Str(ElapsedMilliseconds()-t)
      ;}
      
      ;   Define *This.Gadget = GetGadgetData(g)
      ;   
      ;   With *This\Columns()
      ;     Debug "Scroll_Height "+*This\Scroll\Height
      ;   EndWith
      
      WaitClose( )
      
      Repeat
         Select WaitWindowEvent()   
            Case #PB_Event_CloseWindow
               End 
               ;         Case #PB_Event_Widget
               ;           Select EventGadget()
               ;             Case 13
               ;               Select EventType()
               ;                 Case #__event_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
               ;                 Case #__event_DragStart : Debug "widget dragStart"
               ;                 Case #__event_Change, #__event_LeftClick
               ;                   Debug "widget id = " + GetState(EventGadget())
               ;                   
               ;                   If EventType() = #__event_Change
               ;                     Debug "  widget change"
               ;                   EndIf
               ;               EndSelect
               ;           EndSelect
               
            Case #PB_Event_Gadget
               Select EventGadget()
                  Case 3
                     Select EventType()
                        Case #PB_EventType_DragStart : Debug "gadget dragStart"
                        Case #PB_EventType_Change, #PB_EventType_LeftClick
                           Debug "gadget id = " + GetGadgetState(EventGadget())
                           
                           If EventType() = #PB_EventType_Change
                              Debug "  gadget change"
                           EndIf
                     EndSelect
               EndSelect
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 350
; FirstLine = 281
; Folding = ------4--
; EnableXP
; DPIAware