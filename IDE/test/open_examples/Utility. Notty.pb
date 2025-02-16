Declare OpenWindow_Notty(x, y, Width, Height)
Declare CloseWindow_Notty()

Enumeration FormWindow
  #Notty_Window_Main
EndEnumeration

Enumeration FormGadget
  #Notty_Gadget_Editor
EndEnumeration

Enumeration MenuItem
  #Notty_MenuItem_Save
EndEnumeration


Procedure Notty_Save()
  Shared CurrentFile$

  If CurrentFile$
    File$=CurrentFile$
  Else
    File$=SaveFileRequester("Сохранить файл", "", "Текстовый файл|*.txt|Все файлы|*", 0)
    If Not Len(GetExtensionPart(File$))
      Select SelectedFilePattern()
        Case 0: File$+".txt"
      EndSelect
    EndIf
  EndIf
  
  File=CreateFile(#PB_Any, File$)
  If File
    WriteStringN(File, GetGadgetText(#Notty_Gadget_Editor))
    CloseFile(File)
    
    CurrentFile$=File$
    MessageRequester("Сообщение", "Файл сохранён", #PB_MessageRequester_Info)
    Result=#True
  EndIf
  
  ProcedureReturn Result
EndProcedure
Procedure Notty_Resize()
  WindowX=WindowX(#Notty_Window_Main)
  WindowY=WindowY(#Notty_Window_Main)
  WindowWidth=WindowWidth(#Notty_Window_Main)
  WindowHeight=WindowHeight(#Notty_Window_Main)

  ResizeGadget(#Notty_Gadget_Editor, #PB_Ignore, #PB_Ignore, WindowWidth, WindowHeight)
EndProcedure

Procedure OpenWindow_Notty(x, y, Width, Height)
  If OpenWindow(#Notty_Window_Main, x, y, Width, Height, "Блокнотик", #PB_Window_SizeGadget|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    StickyWindow(#Notty_Window_Main, #True)
    EditorGadget(#Notty_Gadget_Editor, 0, 0, Width, Height)
    
    AddKeyboardShortcut(#Notty_Window_Main, #PB_Shortcut_Control|#PB_Shortcut_S, #Notty_MenuItem_Save)
    
    BindEvent(#PB_Event_Menu, @Notty_Save(), #Notty_Window_Main, #Notty_MenuItem_Save)
    BindEvent(#PB_Event_SizeWindow, @Notty_Resize(), #Notty_Window_Main)
    BindEvent(#PB_Event_CloseWindow, @CloseWindow_Notty())
  EndIf
EndProcedure
Procedure CloseWindow_Notty()
  If IsWindow(#Notty_Window_Main)
    CloseWindow(#Notty_Window_Main)
  EndIf
EndProcedure

;- Начало выполнения

; Параметры по умолчанию
CurrentFile$=""
x=#PB_Ignore
y=#PB_Ignore
Width=320
Height=240

; Получение параметров из коммандной строки
RegEx=CreateRegularExpression(#PB_Any, "(?:(\w+):)?(.*)")
If RegEx
  Count=CountProgramParameters()
  For Index=1 To Count
    Parameter$=ProgramParameter(Index-1)
    
    ExamineRegularExpression(RegEx, Parameter$)
    If NextRegularExpressionMatch(RegEx)
      Type$=UCase(RegularExpressionGroup(RegEx, 1))
      Value$=RegularExpressionGroup(RegEx, 2)
      
      Select Type$
        Case "X"
          x=Val(Value$)
        Case "Y"
          y=Val(Value$)
        Case "WIDTH"
          Width=Val(Value$)
        Case "HEIGHT"
          Height=Val(Value$)
        Case "FILE"
          CurrentFile$=Value$
        Default
          CurrentFile$=Value$
      EndSelect
    EndIf
  Next
  
Else
  CurrentFile$=ProgramParameter(0)
EndIf

If CurrentFile$ 
  File=ReadFile(#PB_Any, CurrentFile$)
  If File
    While Not Eof(File)
      AddGadgetItem(#Notty_Gadget_Editor, -1, ReadString(File))
    Wend
    CloseFile(File)
  EndIf
EndIf

OpenWindow_Notty(x, y, Width, Height)
While IsWindow(#Notty_Window_Main)
  WaitWindowEvent()
Wend
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 52
; Folding = 1
; EnableXP
; Executable = C:\Programs\FindOWOX.exe
; CompileSourceDirectory
; IncludeVersionInfo
; VersionField15 = VOS_DOS