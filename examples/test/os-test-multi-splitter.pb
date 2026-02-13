
CompilerIf #PB_Compiler_IsMainFile
   UsePNGImageDecoder()
   ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Define a,i
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = ButtonGadget(#PB_Any,0,0,0,0,"1") ; Tree(0,0,0,0)
      Protected *g2 = ButtonGadget(#PB_Any,0,0,0,0,"2") ; Tree(0,0,0,0)
      SetGadgetData(*g1, 1)
      SetGadgetData(*g2, 2)
      Protected *this = SplitterGadget(#PB_Any, X,Y,Width,Height, *g1,*g2, #PB_Splitter_Vertical);|#PB_Splitter_FirstFixed )
      SetGadgetState( *this, firstcolumnwidth)
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure AddColumn_( *this, position.l, Text.s, Width.l, Image.i = -1 )
      Static count = 2
      count + 1
      Protected *g2 = GetGadgetAttribute(*this, #PB_Splitter_SecondGadget)
      Protected *g1 = ButtonGadget(#PB_Any, 0,0,0,0,Str(count)) ; Tree(0,0,0,0)
      SetGadgetData(*g1, count)
      
      Static X
      If GadgetType(*g2) = #PB_GadgetType_Splitter
         X + GetGadgetState(*g2 )
      Else
         X = GetGadgetState(*this)
      EndIf
      
      ;
      Define *g4 = ButtonGadget(#PB_Any, 0,0,0,0,"")
      SetGadgetAttribute( *this, #PB_Splitter_SecondGadget, *g4 )
      
      ;
      *g3 = SplitterGadget(#PB_Any, 0,0,X,GadgetHeight(*this), *g1, *g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      ;*g3 = SplitterGadget(#PB_Any, 0,0,X,GadgetHeight(*this), *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      
      ;*g3 = SplitterGadget(#PB_Any, 0,0,GadgetWidth(*this),GadgetHeight(*this), *g1, *g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      ;*g3 = SplitterGadget(#PB_Any, 0,0,GadgetWidth(*this),GadgetHeight(*this), *g2, *g1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed )
      
      SetGadgetAttribute( *this, #PB_Splitter_SecondGadget, *g3 )
      SetGadgetState(*g3, Width)
      
      ;
      FreeGadget( *g4 )
      
      ;SetGadgetState(*this, GetGadgetState(*this)+1)
      
   EndProcedure
   
   Procedure AddItem_( *this, Item.l, Text.s, Image.i = - 1, Flag.q = 0 )
      Protected *g1 = GetGadgetAttribute(*this, #PB_Splitter_FirstGadget)
      Protected *g2 = GetGadgetAttribute(*this, #PB_Splitter_SecondGadget)
      Protected i, count = CountString(Text.s, #LF$)
      ;       For i=1 To count
      ;          AddItem( *g1, Item, StringField(Text.s, i, #LF$), Image, flag )
      ;       Next
      
      If GadgetType(*g1) = #PB_GadgetType_Tree
         AddGadgetItem( *g1, Item, StringField(Text.s, GetGadgetData(*g1), #LF$), Image, Flag )
      EndIf
      If GadgetType(*g2) = #PB_GadgetType_Tree
         AddGadgetItem( *g2, Item, StringField(Text.s, GetGadgetData(*g2), #LF$), -1, 0 )
      Else
         ;*g2 = GetAttribute(*g2, #PB_Splitter_FirstGadget)
         AddItem_( *g2, Item, Text.s, -1,0)
      EndIf
      
   EndProcedure
   
   If OpenWindow(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
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
      *g = ListIcon_(10, 230, 700, 210, "Column_0",190);, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
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
      ;          If StartEnum(Root())
      ;             Debug ""+widgets()\class
      ;             
      ;            StopEnum() 
      ;          EndIf
      ;          
      
      Repeat : Until WaitWindowEvent()= #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 31
; FirstLine = 19
; Folding = --
; EnableXP
; DPIAware