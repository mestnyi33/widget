IncludePath "../"
XIncludeFile "widgets.pbi"

UseModule Widget
Procedure Gadget(Window, X,Y,Width,Height, Flag=0)
  Open(0, X,Y,Width,Height,"")
  Root() = Tree(0, 0, Width,Height, Flag)
  PostEvent(#PB_Event_Gadget, 0, RootGadget(), #PB_EventType_Repaint)
  ProcedureReturn Root()\Canvas
EndProcedure
#PB_Flag_AlwaysSelection=40
#PB_Flag_BorderLess = 1
Macro GetGadgetData(Gadget)
  Root()
EndMacro

;
;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      ;       If GadgetType(EventGadget()) = #PB_GadgetType_Tree
      ;         Debug GetGadgetText(EventGadget())
      ;         Debug GetGadgetState(EventGadget())
      ;         Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      ;       Else
      ;         Debug GetText(EventGadget())
      ;         Debug GetState(EventGadget())
      ;         Debug GetItemState(EventGadget(), GetState(EventGadget()))
      ;       EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    ; 1_example
    AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    
    ;     AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    ;     AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    ;     AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    ;     AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    ;     AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    ;     AddGadgetItem(g, 9, "Tree_2" )
    ;     AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)  ; |#PB_Tree_NoLines|#PB_Tree_NoButtons                                       
    ;   ;  2_example
    ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
    ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
    ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
    ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    ;  6_example
    AddGadgetItem(g, 0, "Tree_1", 0, 1) 
    AddGadgetItem(g, 0, "Tree_2_1", 0, 2) 
    AddGadgetItem(g, 0, "Tree_2_2", 0, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddGadgetItem(g, -1, "Directory" + Str(i), 0, 0)
      Else
        AddGadgetItem(g, -1, "Item" + Str(i), 0, 1)
      EndIf
    Next i
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    g = 10
    Gadget(g, 10, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    *g = GetGadgetData(g)
    
  Define time = ElapsedMilliseconds()
   AddItem (*g, -1, "Item "+Str(a), -1);,Random(5)+1)
   For a = 1 To 1500
    AddItem (*g, -1, "Item "+Str(a), -1, 1);,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*g)
  
;   Text::Redraw(*g)
  
; ; ;     ; 1_example
; ; ;     AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
; ; ;     AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
; ; ;     AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
; ; ;     AddItem (*g, -1, "Sub-Item 2", -1, 11)
; ; ;     AddItem (*g, -1, "Sub-Item 3", -1, 1)
; ; ;     AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
; ; ;     AddItem (*g, -1, "Sub-Item 5", -1, 11)
; ; ;     AddItem (*g, -1, "Sub-Item 6", -1, 1)
; ; ;     AddItem (*g, -1, "File "+Str(a), -1, 0)  
; ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
; ; ;     
; ; ;     ; RemoveItem(*g,1)
; ; ;     Tree::SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
; ; ;     BindGadgetEvent(g, @Events())
; ; ;     ;Tree::SetState(*g, 1)
; ; ;     ;Tree::SetState(*g, -1)
    ;     Debug "c "+Tree::GetText(*g)
    
    g = 11
    Gadget(g, 230, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    *g = GetGadgetData(g)
    ;  3_example
    
    AddItem(*g, 0, "Tree_0", 0 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", 0, 2) 
    AddItem(*g, 5, "Tree_1_1_2", 0, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", 0, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4 and scroll end", 0, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2", 0, 3) 
    AddItem(*g, 2, "Tree_1_2", 0, 1) 
    AddItem(*g, 3, "Tree_1_3", 0, 1) 
    AddItem(*g, 9, "Tree_2",0 )
    AddItem(*g, 10, "Tree_3", 0 )
    
    ;     AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    ;     AddItem(*g, 8, "Tree_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(*g, 7, "Tree_1_1_2_2", -1, 3) 
    ;     AddItem(*g, 2, "Tree_1_2", -1, 1) 
    ;     AddItem(*g, 3, "Tree_1_3", -1, 1) 
    ;     AddItem(*g, 9, "Tree_2",-1 )
    ;     AddItem(*g, 10, "Tree_3", -1 )
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(*g)
    
    g = 12
    Gadget(g, 450, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes)    ; |#PB_Flag_NoLines|#PB_Flag_NoButtons                                    
    *g = GetGadgetData(g)
; ;     ;   ;  2_example
; ;     ;   AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                    
; ;     ;   AddItem (*g, 1, "Node "+Str(a), -1, 1)                                           
; ;     ;   AddItem (*g, 4, "Sub-Item 1", -1, 2)                                            
; ;     ;   AddItem (*g, 2, "Sub-Item 2", -1, 1)
; ;     ;   AddItem (*g, 3, "Sub-Item 3", -1, 1)
; ;     
; ;     ;  2_example
; ;     AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
; ;     For i=1 To 20
; ;       If i=5
; ;         AddItem(*g, -1, "Tree_"+Str(i), -1) 
; ;       Else
; ;         AddItem(*g, -1, "Tree_"+Str(i), 0) 
; ;       EndIf
; ;     Next
    *g2 = *g
     AddItem(*g2, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g2, 1, "Tree_1_1", -1, 1) 
    AddItem(*g2, 2, "Tree_2_2", -1, 2) 
    AddItem(*g2, 3, "Tree_3_2", -1, 2) 
    AddItem(*g2, 4, "Tree_4_3", -1, 3) 
    AddItem(*g2, 5, "Tree_5_2", -1, 2) 
    AddItem(*g2, 5, "Tree_5_3", -1, 3) 
    AddItem(*g2, 7, "Tree_7_2", -1, 2) 
    AddItem(*g2, 8, "Tree_8_2", -1, 2) 
    AddItem(*g2, 6, "Tree_6_3", -1, 3) 
    AddItem(*g2, 7, "Tree_7_3", -1, 3) 
    AddItem(*g2, 8, "Tree_8_4", -1, 4) 
    AddItem(*g2, 12, "Tree_12_2", -1, 2) 
    AddItem(*g2, 9, "Tree_9_4", -1, 4) 
  
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 13
    Gadget(g, 670, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    *g = GetGadgetData(g)
    ;  4_example
    AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    Gadget(g, 890, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    *g = GetGadgetData(g)
    ;  5_example
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    Gadget(g, 890+106, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
    *g = GetGadgetData(g)
    ;  6_example
    AddItem(*g, 0, "Tree_1", -1, 1) 
    AddItem(*g, 0, "Tree_2_1", -1, 2) 
    AddItem(*g, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ;Free(*g)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 12
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  widget change"
                  EndIf
              EndSelect
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "ScrollChange" +" "+ EventData()
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP