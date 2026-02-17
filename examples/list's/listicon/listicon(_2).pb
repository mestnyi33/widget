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
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Tree(0,0,0,0, #__flag_NoLines|flags)
      SetData(*g1, 1)
      
      Protected *this._s_WIDGET = Splitter( X,Y,Width,Height, *g1,-1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      If flags & #__flag_CheckBoxes
         firstcolumnwidth + 25
      EndIf
      SetState( *this, firstcolumnwidth)
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static parent
      Static c ;= 1
      
      Protected._s_WIDGET *g,*g1,*g2
      
      
      If parent 
         c = 1
         If Not IsChild( parent, *this )
            parent = *this
         EndIf
      Else
         parent = *this
      EndIf
      
      c + 1
      *g2 = GetAttribute(parent, #PB_Splitter_SecondGadget)
      *g1 = Tree(0,0,0,0, #__flag_NoLines) ; Button(0,0,0,0,Str(c))
      
      If position =- 1
         SetData(*g1, c)
      Else
         SetData(*g1, position+1)
      EndIf
      ;Debug ""+c+" "+position
      
      If *g2 > 0
         Static X
         If Type(*g2) = #__type_Splitter
            X + GetState(*g2 )
         Else
            X = GetState(*this)
         EndIf
         
         *g = Splitter( 0,0,X ,*this\height, *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
         SetAttribute( parent, #PB_Splitter_SecondGadget, *g )
         SetState(*g, Width)
         parent = *g
      Else
         X = GetState(*this)
         SetAttribute( parent, #PB_Splitter_SecondGadget, *g1 )
         parent = 0
      EndIf
      
      ProcedureReturn *g
   EndProcedure
   
   Procedure AddItem_( *this._s_WIDGET, Item.l, Text.s, Image.i = - 1, Flag.q = 0 )
      Protected *g1 = GetAttribute(*this, #PB_Splitter_FirstGadget)
      Protected *g2 = GetAttribute(*this, #PB_Splitter_SecondGadget)
      
      If Type(*g1) = #__type_tree
         AddItem( *g1, Item, StringField(Text.s, GetData(*g1), #LF$), Image, Flag )
      EndIf
      If Type(*g2) = #__type_tree
         AddItem( *g2, Item, StringField(Text.s, GetData(*g2), #LF$), -1, 0 )
      Else
         AddItem_( *g2, Item, Text.s, -1,0)
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetActiveWindow(0)
      
      Define Count = 500
      Debug "Create items count - "+Str(Count)
      
      ;{ - gadget 
      Define t=ElapsedMilliseconds()
      Define g = 1
      ListIconGadget(g, 10, 10, 165, 210,"Column_1",90)                                         
      For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
      For i=0 To 7
         AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
      Next
      
      g = 2
      ListIconGadget(g, 180, 10, 165, 210,"Column_1",90)                                         
      For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
      For i=0 To Count
         AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
      Next
      
      g = 3
      ListIconGadget(g, 350, 10, 430, 210,"Column_1",90, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
      
      ;HideListIcon_(g,1)
      For i=1 To 2
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
      *g = ListIcon_(10, 230, 165, 210, "Column_1",90) ;: *g = GetGadgetData(g)                                        
      For i=1 To 2 : AddColumn_(*g, i,"Column_"+Str(i+1),90) : Next
      ; 1_example
      For i=0 To 7
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                          
      Next
      
      g = 12
      *g = ListIcon_(180, 230, 165, 210, "Column_1",90);, #__flag_RowFullSelect) ;: *g = GetGadgetData(g)                                          
      For i=1 To 2 : AddColumn_(*g, i,"Column_"+Str(i+1),90) : Next
      ; 1_example
      For i=0 To Count
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                          
      Next
      
      g = 13
      *g = ListIcon_(350, 230, 430, 210, "Column_1",90, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
      
      ;HideListIcon_(g,1)
      For i=1 To 2
         AddColumn_(*g, i,"Column_"+Str(i+1),90)
      Next
      ; 1_example
      AddItem_(*g, -1, Chr(10)+"ListIcon_"+Str(i)) 
      For i=1 To 5
         AddItem_(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                         
      Next
      ;HideListIcon_(g,0)
      
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
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 112
; FirstLine = 86
; Folding = ----
; EnableXP
; DPIAware