; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;   IncludePath "/Users/as/Documents/GitHub/Widget/"
; CompilerElse
   IncludePath "../../"
; CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_bar.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule editor
  
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
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "editorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    ;{ - gadget
    EditorGadget(g, 10, 10, 210, 210)                                         
    ; 1_example
    Define time = ElapsedMilliseconds()
    AddGadgetItem(g, -1, "Item "+Str(a), -1);,Random(5)+1)
    For a = 1 To 150
      AddGadgetItem(g, -1, "Item "+Str(a), -1, 1)
      If A & $f=$f:WindowEvent()             ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next : a = 0
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(g)
    
    g = 2
    EditorGadget(g, 230, 10, 210, 210)                                         
    ; 3_example
    AddGadgetItem(g, 0, "editor_0", 0 )
    AddGadgetItem(g, 1, "editor_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "editor_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "editor_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "editor_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "editor_1_1_2_1_1 long line and scroll end", 0, 4) 
    AddGadgetItem(g, 7, "editor_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "editor_1_2", 0, 1) 
    AddGadgetItem(g, 3, "editor_1_3", 0, 1) 
    AddGadgetItem(g, 9, "editor_2" )
    AddGadgetItem(g, 10, "editor_3", 0 )
    ;}
    
    ;{ - widget
    ; Demo draw string on the canvas
    g = 10
    CanvasGadget(g,  0, 220, 1110, 230, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(g, @CallBacks())
    
    *g = Create(g, -1, 10, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    
    Define time = ElapsedMilliseconds()
    AddItem (*g, -1, "Item "+Str(a), -1);,Random(5)+1)
    For a = 1 To 150
      AddItem (*g, -1, "Item "+Str(a), -1, 1)
      If A & $f=$f:WindowEvent()             ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*g)
    
    Text::Redraw(*g)

     *g = Create(g, -1, 230, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    ;  3_example
    
    AddItem(*g, 0, "editor_0", 0 )
    AddItem(*g, 1, "editor_1_1", 0, 1) 
    AddItem(*g, 4, "editor_1_1_1", 0, 2) 
    AddItem(*g, 5, "editor_1_1_2", 0, 2) 
    AddItem(*g, 6, "editor_1_1_2_1", 0, 3) 
    AddItem(*g, 8, "editor_1_1_2_1_1_4 long line and scroll end", 0, 4) 
    AddItem(*g, 7, "editor_1_1_2_2", 0, 3) 
    AddItem(*g, 2, "editor_1_2", 0, 1) 
    AddItem(*g, 3, "editor_1_3", 0, 1) 
    AddItem(*g, 9, "editor_2 ",0 )
    AddItem(*g, 10, "editor_3", 0 )
    
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