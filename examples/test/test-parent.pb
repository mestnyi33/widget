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

XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Global NewMap buttons()
   
   Procedure SetGadget(*this._s_WIDGET, *parent._s_WIDGET, mode)
      AddMapElement(buttons( ), Str(*parent+mode)) : buttons( ) = *this
      SetParent(*this, *parent)
   EndProcedure
   
   Procedure GetGadget(*parent._s_WIDGET, mode)
     ProcedureReturn buttons( Str(*parent+mode))
   EndProcedure
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Button(0,0,30,30,"1") ; Tree(0,0,0,0)
      Protected *g2 = Button(0,0,30,30,"2") ; Tree(0,0,0,0)
      
      Protected *this._s_WIDGET = Container( X,Y,Width,Height ) : CloseList()
      
      SetGadget(*g1, *this, 1) 
      SetGadget(*g2, *this, 2) 
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static count = 2
      count + 1
      Protected._s_WIDGET *g2 = buttons( Str(*this+2)) ; GetAttribute(*this, #PB_Splitter_SecondGadget)
      Protected._s_WIDGET *g3, *g1 = Button(40,0,30,30,Str(count)) ; Tree(0,0,0,0)
      ;SetData(*g1, count)
      
       Static X = 0
;       If GetType(*g2) = #__type_Splitter
;       Else
;          X = GetState(*this)
;       EndIf
      
      *g3 = Container( Width,0,*this\width,70 ) : CloseList()
      SetGadget(*g1, *g3, 1) 
      SetGadget(*g2, *g3, 2) 
      
      SetGadget(*g3, *this, 2) 
      
;       SetAttribute( *this, #PB_Splitter_SecondGadget, *g2 )
;       SetState(*g2, Width)
            X + Width
    
   EndProcedure
   
;    Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
;       Protected *g1 = GetAttribute(*this, #PB_Splitter_SecondGadget)
;       Protected c = GetData(*g1) + 1
;       Protected *g2 = Button(0,0,0,0,Str(c)) ; Tree(0,0,0,0)
;         SetData(*g2, c)
;        
;       If position >= 2
;          *g2 = Splitter( 0,0,*this\Width,*this\height, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
;          SetAttribute( *this, #PB_Splitter_SecondGadget, *g2 )
;          SetState(*g2, Width)
;       EndIf
;       
;    EndProcedure
   
   Procedure AddItem_( *this._s_WIDGET, Item.l, Text.s, Image.i = - 1, Flag.q = 0 )
      Protected *g1 = GetAttribute(*this, #PB_Splitter_FirstGadget)
      Protected *g2 = GetAttribute(*this, #PB_Splitter_SecondGadget)
      Protected i, count = CountString(Text.s, #LF$)
      ;       For i=1 To count
      ;          AddItem( *g1, Item, StringField(Text.s, i, #LF$), Image, flag )
      ;       Next
      
      If GetType(*g1) = #__type_tree
         AddItem( *g1, Item, StringField(Text.s, GetData(*g1), #LF$), Image, Flag )
      EndIf
      If GetType(*g2) = #__type_tree
         AddItem( *g2, Item, StringField(Text.s, GetData(*g2), #LF$), -1, 0 )
      Else
         ;*g2 = GetAttribute(*g2, #PB_Splitter_FirstGadget)
         AddItem_( *g2, Item, Text.s, -1,0)
      EndIf
      
   EndProcedure
   
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetActiveWindow(0)
      
      Define g = 3
      ListIconGadget(g, 10, 10, 700, 210,"Column_0",190, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
      For i=1 To 3
         AddGadgetColumn(g, i,"Column_"+Str(i),90)
      Next
      
      AddGadgetItem(g, -1, Chr(10)+"ListIcon_"+Str(i)) 
      For i=1 To 5
         AddGadgetItem(g, i, Str(i)+"_Column_0"+#LF$+Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3", ImageID(0))                                           
      Next
      
      
      g = 13
      *g = ListIcon_(10, 230, 700, 210, "Column_0",190, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
;       For i=1 To 3
;          AddColumn_(*g, i,"Column_"+Str(i),90)
;       Next
         i=1 : AddColumn_(*g, i,"Column_"+Str(i),90)
         
         i=2 : AddColumn_(*g, i,"Column_"+Str(i),90)
         
         i=3 : AddColumn_(*g, i,"Column_"+Str(i),90)
      
;       AddItem_(*g, -1, Chr(10)+"ListIcon_"+Str(i)) 
;       For i=1 To 5
;          AddItem_(*g, i, Str(i)+"_Column_0"+#LF$+Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3", (0))                                        
;       Next
;
         If StartEnum(Root())
            Debug ""+widgets()\class
            
           StopEnum() 
         EndIf
         
         
      WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 80
; FirstLine = 64
; Folding = --
; EnableXP
; DPIAware