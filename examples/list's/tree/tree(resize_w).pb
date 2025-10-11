IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global g, *g._S_widget, g_Canvas, NewList *List._S_widget()
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
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
  
  If OpenWindow(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g_Canvas = GetCanvasGadget(Open(0))
    
    g = TreeGadget_(#PB_Any, 0,0,0,0, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2 980980_", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    Define i
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    *g=Tree(0,0,0,0);|#__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
    
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    AddItem(*g, 11, "Tree_4", -1 )
    AddItem(*g, 12, "Tree_5", -1 )
    AddItem(*g, 13, "Tree_6", -1 )
    
    
    Define *splitter1 = Splitter(0,0,0,0, 0, Splitter(0,0,0,0, g,*g), #__flag_Borderless|#__flag_autosize | #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    SetState(*splitter1, 0)
    ;SetGadgetData(g_Canvas, Splitter(8, 8, 306, 491-16, g,*g, #__flag_autosize))
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = --
; EnableXP
; DPIAware