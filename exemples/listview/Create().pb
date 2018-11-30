CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_listview.pbi"


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule listview
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_KeyDown ; Debug  " key "+GetGadgetAttribute(Canvas, #PB_Canvas_Key)
        Select GetGadgetAttribute(Canvas, #PB_Canvas_Key)
          Case #PB_Shortcut_Tab
            ForEach List()
              If List()\Widget = List()\Widget\Focus
                Result | CallBack(List()\Widget, #PB_EventType_LostFocus);, Canvas) 
                NextElement(List())
                ;Debug List()\Widget
                Result | CallBack(List()\Widget, #PB_EventType_Focus);, Canvas) 
                Break
              EndIf
            Next
        EndSelect
    EndSelect
    
    Select EventType()
      Case #PB_EventType_Repaint : Result = 1
      Case #PB_EventType_Resize : Result = 1
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          If Canvas = List()\Widget\Canvas\Gadget
            Result | CallBack(List()\Widget, EventType()) 
          EndIf
        Next
    EndSelect
    
    If Result
       Text::ReDraw(0, Canvas, $FFF0F0F0)
    EndIf
    
  EndProcedure
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
;       If GadgetType(EventGadget()) = #PB_GadgetType_ListIcon
;         Debug GetGadgetText(EventGadget())
;         Debug GetGadgetState(EventGadget())
;         Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
;       Else
;         Debug ListIcon::GetText(EventGadget())
;         Debug ListIcon::GetState(EventGadget())
;         Debug ListIcon::GetItemState(EventGadget(), ListIcon::GetState(EventGadget()))
;       EndIf
    EndIf
  EndProcedure
  
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "listviewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    ;{ - gadget
    ListViewGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
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
    ListViewGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "listview_0", 0 )
    AddGadgetItem(g, 1, "listview_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "listview_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "listview_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "listview_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "listview_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "listview_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "listview_1_2", 0, 1) 
    AddGadgetItem(g, 3, "listview_1_3", 0, 1) 
    AddGadgetItem(g, 9, "listview_2" )
    AddGadgetItem(g, 10, "listview_3", 0 )
    
    ;     AddGadgetItem(g, 6, "listview_1_1_2_1", 0, 3) 
    ;     AddGadgetItem(g, 8, "listview_1_1_2_1_1", 0, 4) 
    ;     AddGadgetItem(g, 7, "listview_1_1_2_2", 0, 3) 
    ;     AddGadgetItem(g, 2, "listview_1_2", 0, 1) 
    ;     AddGadgetItem(g, 3, "listview_1_3", 0, 1) 
    ;     AddGadgetItem(g, 9, "listview_2" )
    ;     AddGadgetItem(g, 10, "listview_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    ListViewGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes |#PB_Tree_NoLines|#PB_Tree_NoButtons)  ;                                       
                                                                                                                             ;   ;  2_example
                                                                                                                             ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
                                                                                                                             ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
                                                                                                                             ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
                                                                                                                             ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
                                                                                                                             ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "listview_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "listview_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "listview_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    ListViewGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "listview_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "listview_1", 0, 1) 
    AddGadgetItem(g, 2, "listview_2_2", 0, 2) 
    AddGadgetItem(g, 2, "listview_2_1", 0, 1) 
    AddGadgetItem(g, 3, "listview_3_1", 0, 1) 
    AddGadgetItem(g, 3, "listview_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    ListViewGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "listview_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "listview_1", 0, 1) 
    AddGadgetItem(g, 2, "listview_2_1", 0, 1) 
    AddGadgetItem(g, 2, "listview_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    ListViewGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    ;  6_example
    AddGadgetItem(g, 0, "listview_1", 0, 1) 
    AddGadgetItem(g, 0, "listview_2_1", 0, 2) 
    AddGadgetItem(g, 0, "listview_2_2", 0, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddGadgetItem(g, -1, "Directory" + Str(i), 0, 0)
      Else
        AddGadgetItem(g, -1, "Item" + Str(i), 0, 1)
      EndIf
    Next i
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    ;}
    
    ;{ - widget
    ; Demo draw string on the canvas
    g = 10
    CanvasGadget(g,  0, 220, 1110, 230, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(g, @CallBacks())
    
    *g = Create(g, -1, 10, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    
    Define time = ElapsedMilliseconds()
    AddItem (*g, -1, "Item "+Str(a), -1);,Random(5)+1)
    For a = 1 To 1500
      AddItem (*g, -1, "Item "+Str(a), -1, 1)
      If A & $f=$f:WindowEvent()             ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*g)
    
    Text::Redraw(*g)
    
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
    ; ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #pb_tree_Expanded) : Next
    ; ; ;     
    ; ; ;     ; RemoveItem(*g,1)
    ; ; ;     listview::SetItemState(*g, 1, #pb_tree_Selected|#pb_tree_Collapsed|#pb_tree_Checked)
    ; ; ;     BindGadgetEvent(g, @Events())
    ; ; ;     ;listview::SetState(*g, 1)
    ; ; ;     ;listview::SetState(*g, -1)
    ;     Debug "c "+listview::GetText(*g)
    
    *g = Create(g, -1, 230, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    ;  3_example
    
    AddItem(*g, 0, "listview_0", 0 )
    AddItem(*g, 1, "listview_1_1", 0, 1) 
    AddItem(*g, 4, "listview_1_1_1", 0, 2) 
    AddItem(*g, 5, "listview_1_1_2uuuuuuuuuuuuuuuuu", 0, 2) 
    AddItem(*g, 6, "listview_1_1_2_1", 0, 3) 
    AddItem(*g, 8, "listview_1_1_2_1_1_4 and scroll end", 0, 4) 
    AddItem(*g, 7, "listview_1_1_2_2", 0, 3) 
    AddItem(*g, 2, "listview_1_2", 0, 1) 
    AddItem(*g, 3, "listview_1_3", 0, 1) 
    AddItem(*g, 9, "listview_2 ",0 )
    AddItem(*g, 10, "listview_3", 0 )
    
    ;     AddItem(*g, 6, "listview_1_1_2_1", -1, 3) 
    ;     AddItem(*g, 8, "listview_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(*g, 7, "listview_1_1_2_2", -1, 3) 
    ;     AddItem(*g, 2, "listview_1_2", -1, 1) 
    ;     AddItem(*g, 3, "listview_1_3", -1, 1) 
    ;     AddItem(*g, 9, "listview_2",-1 )
    ;     AddItem(*g, 10, "listview_3", -1 )
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(*g)
    
    *g = Create(g, -1, 450, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes |#PB_Flag_NoLines|#PB_Flag_NoButtons )    ;                                
    ;   ;  2_example
    ;   AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                    
    ;   AddItem (*g, 1, "Node "+Str(a), -1, 1)                                           
    ;   AddItem (*g, 4, "Sub-Item 1", -1, 2)                                            
    ;   AddItem (*g, 2, "Sub-Item 2", -1, 1)
    ;   AddItem (*g, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (*g, 0, "listview_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(*g, -1, "listview_"+Str(i), -1) 
      Else
        AddItem(*g, -1, "listview_"+Str(i), 0) 
      EndIf
    Next
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    *g = Create(g, -1, 670, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    ;  4_example
    AddItem(*g, 0, "listview_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "listview_1", -1, 1) 
    AddItem(*g, 2, "listview_2_2", -1, 2) 
    AddItem(*g, 2, "listview_2_1", -1, 1) 
    AddItem(*g, 3, "listview_3_1", -1, 1) 
    AddItem(*g, 3, "listview_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    *g = Create(g, -1, 890, 10, 103, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    ;  5_example
    AddItem(*g, 0, "listview_0 (NoButtons)", -1 )
    AddItem(*g, 1, "listview_1", -1, 1) 
    AddItem(*g, 2, "listview_2_1", -1, 1) 
    AddItem(*g, 2, "listview_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    *g = Create(g, -1, 890+106, 10, 103, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
    ;  6_example
    AddItem(*g, 0, "listview_1", -1, 1) 
    AddItem(*g, 0, "listview_2_1", -1, 2) 
    AddItem(*g, 0, "listview_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    For i=0 To CountItems(*g) : SetItemState(*g, i, #pb_tree_Expanded) : Next
    ;}
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
                  Debug "widget id = " + GetState(GetGadgetData(EventGadget()))
                  
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

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----
; EnableXP