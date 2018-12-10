XIncludeFile "includepath.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  LN = 15000
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
;            m.s +
;            "Schol is a beautiful thing." + m.s +
;            "You ned it, that's true." + m.s +
;            "There was a group of monkeys siting on a fallen tree."
   Text.s = "This is a long line. Who should show, i have to write the text in the box or not. The string must be very long. Otherwise it will not work."
        
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-120, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-135, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    
    CompilerIf #PB_Compiler_Version =< 546 : SplitterCallBack() : CompilerEndIf
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,110,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 233, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    Define time = ElapsedMilliseconds()
    For a = 0 To 2;LN
      AddGadgetItem(0, a, "Line "+Str(a))
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
    
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, -1, "Line "+Str(a))
    Next
    ;SetGadgetFont(0, FontID(0))
    ;SetGadgetState(0, 9)
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Text_WordWrap|#PB_Flag_GridLines);|#PB_Text_Right) #PB_Flag_FullSelection|
    *w.Widget_S=GetGadgetData(g)
    
    Editor::SetText(*w, Text.s) : Len = Len(text) : Count = CountString(Text, #LF$)
;     Debug Len
;     Debug Len(*w\text\string)
      
    Define time = ElapsedMilliseconds()
    For a = 0 To LN
      Count + 1
      Len + Len("Line "+Str(a)+#LF$)
      Editor::AddItem(*w, -1, "Line "+Str(a))
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(*w)
     
    Editor::AddItem(*w, a, "") : Count + 1 : Len + Len(#LF$)
    
    For a = 4 To 6
      Count + 1
      Len + Len("Line "+Str(a)+#LF$)
      Editor::AddItem(*w, a, "Line "+Str(a))
    Next
    
    ;Editor::SetFont(*w, FontID(0))
    ;editor::SetState(*w, -1) ; 119) ; set caret pos    
   
;    Debug 555
;    editor::SetState(*w, #PB_Ignore) ; 119) ; set caret pos    
    
;     Define time = ElapsedMilliseconds()
   ; Editor::Make(*w)
    Editor::Update(*w)
  ;; While WindowEvent() : Wend
;     Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(*w)
    
;     Debug *w\text\string
;     
;     Debug " "+Len
;     Debug "  "+*w\text\Len
;     Debug "   "+Len(*w\text\string)
;     
;     Debug " "+Count
;     Debug "  "+*w\text\Count
;     Debug "   "+CountString(*w\text\string, #LF$)
    
    SplitterGadget(10,8, 8, 250, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
                Editor::RemoveItem(g, 5)
                RemoveGadgetItem(0,5)
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---
; EnableXP