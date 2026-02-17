
XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Button(0,0,0,0,"0") ; Tree(0,0,0,0)
      Protected *g2 = Button(0,0,0,0,"1") ; Tree(0,0,0,0)
      SetData(*g1, 1)
      SetData(*g2, 2)
      Protected *this._s_WIDGET = Splitter( X,Y,Width,Height, *g1,*g2, #PB_Splitter_Vertical);|#PB_Splitter_FirstFixed )
      SetState( *this, firstcolumnwidth)
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static parent
      Static count = 2
      count + 1
      
      Protected._s_WIDGET *g,*g1,*g2
      
      If Not ( parent And IsChild( parent, *this ))
         count = 2
         parent = *this
      EndIf
      
      *g2 = GetAttribute(parent, #PB_Splitter_SecondGadget)
      If *g2 > 0
         If Type(*g2) <> #__type_Splitter
            *g1 = Button(0,0,0,0,Str(count))
            SetData(*g1, Count)
         EndIf
      EndIf
       
       *g = Splitter( 0,0,*this\width ,*this\height, *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
         SetAttribute( parent, #PB_Splitter_SecondGadget, *g )
         SetState(*g, Width)
         parent = *g
;       Else
;          X = GetState(*this)
;          SetAttribute( parent, #PB_Splitter_SecondGadget, *g1 )
;       EndIf
      
      ProcedureReturn *g
   EndProcedure
   
   
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      g = 13
      *g = ListIcon_(10, 10, 700, 210, "Column_0",190, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
      
      Define *this._s_WIDGET
      i=1 
      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
        ; Debug ""+*this\class +" "+ *this\parent\class
         
         i=2 
      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
        ; Debug ""+*this\class +" "+ *this\parent\class
;          
      i=3 
      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
;         ; Debug ""+*this\class +" "+ *this\parent\class
      
      
      
      Debug "-----"
      
         If StartEnum(Root())
            Debug "" + widgets()\class +" > "+ widgets()\parent\class
            
           StopEnum() 
         EndIf
         
         
      WaitClose( )
  EndIf
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile = 99
   UseWidgets( )
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Button(0,0,0,0,"0") ; Tree(0,0,0,0)
      Protected *g2 = Button(0,0,0,0,"1") ; Tree(0,0,0,0)
      SetData(*g1, 1)
      SetData(*g2, 2)
      Protected *this._s_WIDGET = Splitter( X,Y,Width,Height, *g1,*g2, #PB_Splitter_Vertical);|#PB_Splitter_FirstFixed )
      SetState( *this, firstcolumnwidth)
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static parent
      Static count = 2
      count + 1
      
      Protected._s_WIDGET *g,*g1,*g2
      
      If Not ( parent And IsChild( parent, *this ))
         count = 2
         parent = *this
      EndIf
      
      *g2 = GetAttribute(parent, #PB_Splitter_SecondGadget)
      *g1 = Button(0,0,0,0,Str(count))
      SetData(*g1, Count)
      
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
      EndIf
      
      ProcedureReturn *g
   EndProcedure
   
   
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      g = 13
      *g = ListIcon_(10, 10, 700, 210, "Column_0",190, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
      
      Define *this._s_WIDGET
      i=1 
      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
        ; Debug ""+*this\class +" "+ *this\parent\class
         
         i=2 
      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
        ; Debug ""+*this\class +" "+ *this\parent\class
;          
;       i=3 
 ;      *this = AddColumn_(*g, i,"Column_"+Str(i),90)
;         ; Debug ""+*this\class +" "+ *this\parent\class
      
      
      
      Debug "-----"
      
         If StartEnum(Root())
            Debug "" + widgets()\class +" > "+ widgets()\parent\class
            
           StopEnum() 
         EndIf
         
         
      WaitClose( )
  EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
   UseWidgets( )
   
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Button(0,0,0,0,"1") ; Tree(0,0,0,0)
      Protected *g2 = Button(0,0,0,0,"2") ; Tree(0,0,0,0)
      SetData(*g1, 1)
      SetData(*g2, 2)
      Protected *this._s_WIDGET = Splitter( X,Y,Width,Height, *g1,*g2, #PB_Splitter_Vertical);|#PB_Splitter_FirstFixed )
      SetState( *this, firstcolumnwidth)
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static count = 2
      count + 1
      Protected gadget = #PB_Splitter_SecondGadget ;   #PB_Splitter_FirstGadget ; 
      Protected._s_WIDGET *g2 = GetAttribute(*this, gadget)
      Protected._s_WIDGET *g1 = Button(0,0,0,0,Str(count)) ; Tree(0,0,0,0)
      SetData(*g1, count)
      
      Static X
      If Type(*g2) = #__type_Splitter
         X + GetState(*g2 )
      Else
         X = GetState(*this)
      EndIf
      
      ;*g2 = Splitter( 0,0,X ,*this\height, *g1, *g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      ;*g2 = Splitter( 0,0,*this\Width ,*this\height, *g1, *g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
;       SPLITTER_0 > Root
;       BUTTON_1 > SPLITTER_0
;       SPLITTER_3 > SPLITTER_0
;       BUTTON_4 > SPLITTER_3
;       SPLITTER_2 > SPLITTER_3
;       BUTTON_3 > SPLITTER_2
;       SPLITTER_1 > SPLITTER_2
;       BUTTON_2 > SPLITTER_1
;       BUTTON_0 > SPLITTER_1

;       SPLITTER_0 > Root
;       BUTTON_0 > SPLITTER_0
;       SPLITTER_3 > SPLITTER_0
;       BUTTON_4 > SPLITTER_3
;       SPLITTER_2 > SPLITTER_3
;       BUTTON_3 > SPLITTER_2
;       SPLITTER_1 > SPLITTER_2
;       BUTTON_2 > SPLITTER_1
;       BUTTON_1 > SPLITTER_1

      *g2 = Splitter( 0,0,X ,*this\height, *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
;      *g2 = Splitter( 0,0,*this\Width ,*this\height, *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
;       SPLITTER_0 > Root
;       BUTTON_1 > SPLITTER_0
;       SPLITTER_3 > SPLITTER_0
;       SPLITTER_2 > SPLITTER_3
;       SPLITTER_1 > SPLITTER_2
;       BUTTON_0 > SPLITTER_1
;       BUTTON_2 > SPLITTER_1
;       BUTTON_3 > SPLITTER_2
;       BUTTON_4 > SPLITTER_3

;       SPLITTER_0 > Root
;       BUTTON_0 > SPLITTER_0
;       SPLITTER_3 > SPLITTER_0
;       SPLITTER_2 > SPLITTER_3
;       SPLITTER_1 > SPLITTER_2
;       BUTTON_1 > SPLITTER_1
;       BUTTON_2 > SPLITTER_1
;       BUTTON_3 > SPLITTER_2
;       BUTTON_4 > SPLITTER_3
      SetAttribute( *this, gadget, *g2 )
      SetState(*g2, Width)
      
      
      ;Resize( *g2, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ; SetState(*this, GetState(*this)+1)
      
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
      
      If Type(*g1) = #__type_tree
         AddItem( *g1, Item, StringField(Text.s, GetData(*g1), #LF$), Image, Flag )
      EndIf
      If Type(*g2) = #__type_tree
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
            Debug "" + widgets()\class +" > "+ widgets()\parent\class
            
           StopEnum() 
         EndIf
         
         
      WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 296
; FirstLine = 261
; Folding = 8----
; EnableXP
; DPIAware