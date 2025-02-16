Declare OpenWindow_RegexTest()
Declare CloseWindow_RegexTest()

Enumeration FormWindow
  #Window_RegexTest
EndEnumeration

Enumeration FormGadget
  #Gadget_RegexFlags
  
  #Gadget_Pattern
  #Gadget_Text
  #Gadget_Output
  
  #Gadget_EditorSplitter
  #Gadget_FullSplitter
EndEnumeration


Enumeration Font
  #Font_Default
EndEnumeration

LoadFont(#Font_Default, "Calibri", 16, 0)

Procedure.s ComleteString(String$)
  If Len(String$)>50
    String$=Left(String$, 23)+" ... "+Right(String$, 23)
  ElseIf Len(String$)=0
    String$="<пустая строка>"
  EndIf
  
  ProcedureReturn String$
EndProcedure

Procedure RegexTest_Parse()
  ClearGadgetItems(#Gadget_Output)
  
  Pattern$=GetGadgetText(#Gadget_Pattern)
  Text$=GetGadgetText(#Gadget_Text)
  
  If Pattern$ And Text$
    
    CountFlags=CountGadgetItems(#Gadget_RegexFlags)
    For FlagItem=0 To CountFlags-1
      If GetGadgetItemState(#Gadget_RegexFlags, FlagItem) = #PB_ListIcon_Checked
        Flags | GetGadgetItemData(#Gadget_RegexFlags, FlagItem)
      EndIf
    Next
    
    RegEx=CreateRegularExpression(#PB_Any, Pattern$, Flags)
    If RegEx
      If ExamineRegularExpression(RegEx, Text$)
        While NextRegularExpressionMatch(RegEx)
          
          Match$=RegularExpressionMatchString(RegEx)
          AddGadgetItem(#Gadget_Output, -1, ComleteString(Match$), 0, 0)
          
          CountGroups=CountRegularExpressionGroups(RegEx)
          If CountGroups
            For Group=1 To CountGroups
              Group$=RegularExpressionGroup(RegEx, Group)
              AddGadgetItem(#Gadget_Output, -1, ComleteString(Group$), 0, 1)
            Next
          EndIf
        Wend
      EndIf
      
      FreeRegularExpression(RegEx)
    Else
      ErrorMessage$=RegularExpressionError()
      AddGadgetItem(#Gadget_Output, -1, ErrorMessage$, 0, 0)
    EndIf
    
  ElseIf Not Len(Pattern$)
    AddGadgetItem(#Gadget_Output, -1, "Пустой шаблон", 0, 0)
  ElseIf Not Len(Text$)
    AddGadgetItem(#Gadget_Output, -1, "Негде искать", 0, 0)
  EndIf
EndProcedure

Procedure RegexTest_Resize()
  Width=WindowWidth(#Window_RegexTest)
  Height=WindowHeight(#Window_RegexTest)
  
  ResizeGadget(#Gadget_FullSplitter, #PB_Ignore, #PB_Ignore, Width-250, Height)
  ResizeGadget(#Gadget_RegexFlags, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height)
EndProcedure


Procedure OpenWindow_RegexTest()
  If OpenWindow(#Window_RegexTest, #PB_Ignore, #PB_Ignore, 890, 480, "RegEx Text", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
    SetGadgetFont(#PB_Default, FontID(#Font_Default))
    ListIconGadget(#Gadget_RegexFlags, 0, 0, 245, 640, "Флаги", 240, #PB_ListIcon_CheckBoxes);[
      AddGadgetItem(#Gadget_RegexFlags, 0, "_DotAll")     : SetGadgetItemData(Gadget_RegexFlags, 0, #PB_RegularExpression_DotAll)
      AddGadgetItem(#Gadget_RegexFlags, 1, "_Extended")   : SetGadgetItemData(Gadget_RegexFlags, 1, #PB_RegularExpression_Extended)
      AddGadgetItem(#Gadget_RegexFlags, 2, "_MultiLine")  : SetGadgetItemData(Gadget_RegexFlags, 2, #PB_RegularExpression_MultiLine)
      AddGadgetItem(#Gadget_RegexFlags, 3, "_AnyNewLine") : SetGadgetItemData(Gadget_RegexFlags, 3, #PB_RegularExpression_AnyNewLine)
      AddGadgetItem(#Gadget_RegexFlags, 4, "_NoCase")     : SetGadgetItemData(Gadget_RegexFlags, 4, #PB_RegularExpression_NoCase)
      ;]
      
    EditorGadget(#Gadget_Pattern, 250, 0, 250, 80, #PB_Editor_WordWrap)
    EditorGadget(#Gadget_Text, 250, 80, 250, 400)
    TreeGadget(#Gadget_Output, 500, 0, 140, 480)
    
    SplitterGadget(#Gadget_EditorSplitter, 250, 0, 300, 480, #Gadget_Pattern, #Gadget_Text)
    SetGadgetState(#Gadget_EditorSplitter, 50)
    SplitterGadget(#Gadget_FullSplitter,   250, 0, 390, 480, #Gadget_EditorSplitter, #Gadget_Output, #PB_Splitter_Vertical)
    
    RegexTest_Resize()
    
    BindGadgetEvent(#Gadget_Pattern, @RegexTest_Parse(), #PB_EventType_Change)
    BindGadgetEvent(#Gadget_Text, @RegexTest_Parse(), #PB_EventType_Change)
    BindGadgetEvent(#Gadget_RegexFlags, @RegexTest_Parse(), #PB_EventType_LeftClick)
    
    BindEvent(#PB_Event_SizeWindow, @RegexTest_Resize(), #Window_RegexTest)
    BindEvent(#PB_Event_CloseWindow, @CloseWindow_RegexTest(), #Window_RegexTest)
  EndIf
EndProcedure


Procedure CloseWindow_RegexTest()
  If IsWindow(#Window_RegexTest)
    UnbindGadgetEvent(#Gadget_Pattern, @RegexTest_Parse(), #PB_EventType_Change)
    UnbindGadgetEvent(#Gadget_Text, @RegexTest_Parse(), #PB_EventType_Change)
    UnbindGadgetEvent(#Gadget_RegexFlags, @RegexTest_Parse(), #PB_EventType_LeftClick)
        
    UnbindEvent(#PB_Event_SizeWindow, @RegexTest_Resize(), #Window_RegexTest)
    UnbindEvent(#PB_Event_CloseWindow, @CloseWindow_RegexTest(), #Window_RegexTest)
    CloseWindow(#Window_RegexTest)
  EndIf
EndProcedure




OpenWindow_RegexTest()

While IsWindow(#Window_RegexTest)
  WaitWindowEvent()
Wend

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 24
; Folding = --
; EnableXP
; CompileSourceDirectory