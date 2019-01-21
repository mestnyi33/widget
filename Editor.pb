;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
; 43025500559246
; Regex Trim(Arguments)
; https://regex101.com/r/zxBLgG/2
; ~"((?:(?:\".*?\")|(?:\\(.*?\\))|[^,])+)"
; ~"(?:\"(?:.*?)\"|(?:\\w*)\\s*\\((?:(?>[^()]+|(?R))*)\\)|[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\])+"
; #Button_0, ReadPreferenceLong("x", WindowWidth(#Window_0)/WindowWidth(#Window_0)+20), 20, WindowWidth(#Window_0)-(390-155), WindowHeight(#Window_0) - 180 * 2, GetWindowTitle(#Window_0) + Space( 1 ) +"("+ "Button" + "_" + Str(1)+")"

; Regex Trim(Captions)
; https://regex101.com/r/3TwOgS/1
; ~"((?:\"(.*?)\"|\\((.*?)\\)|[^+\\s])+)"
; ~"(?:(\\w*)\\s*\\(((?>[^()\"]+|(?R))+)\\))|\"(.*?)\"|[^+\\s]+"
; ~"(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^()\"]+|(?R))+)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\/])|([\\*])|([\\-])|([\\+])"
; ~"(?:(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^()\"]+|(?R))*)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+)|([\\/])|([\\*])|([\\-])|([\\+]))"
; Str(ListIndex(List( )))+"Число между"+Chr(10)+"это 2!"+
; ListIndex(List()) ; вот так не работает


EnableExplicit
XIncludeFile "widgets.pbi"

;-
;- INCLUDE
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Disable.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Transformation.pbi"
XIncludeFile "include/Properties.pbi"


XIncludeFile "include/Scintilla.pbi"
Global WE_Code=-1, CodeShow.b


;- GLOBAL
Global MainWindow=-1
Global WE=-1, 
       WE_Menu_0=-1, 
       WE_PopupMenu_0=-1,
       WE_Tree_0=-1, 
       WE_Tree_1=-1, 
       WE_Panel_0=-1,
       WE_Panel_1=-1,
       WE_Splitter_0=-1,
       WE_ScrollArea_0=-1,
       WE_Scintilla_0=-1,
       WE_Splitter_1=-1

Global WE_Properties
Global Properties_ID 
Global Properties_Image 
Global Properties_Color 
Global Properties_Puch
Global Properties_Flag

Global WE_Menu_New=1,
       WE_Menu_Open=2,
       WE_Menu_Save=3,
       WE_Menu_Save_as=4,
       WE_Menu_Delete=5,
       WE_Menu_Quit=6,
       WE_Menu_Code=7

;-
;- DECLARE
Declare WE_Events()
Declare WE_CloseWindow()
Declare WE_ResizeWindow()
Declare WE_ResizePanel_0()
Declare WE_ResizePanel_1()
Declare WE_Tree_0_Position(Gadget, Parent)
Declare WE_Tree_0_Update(Gadget, Position=-1)
Declare WE_OpenWindow(Flag.i=#PB_Window_SystemMenu, ParentID=0)

Declare$ GetObjectClass(Object)
Declare CF_Free(Object.i)

;-
;- MACRO
Macro ULCase(String)
  InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
EndMacro

Macro GetVarValue(StrToFind)
  GetArguments(*This\Content\Text$, "(?:(\w+)\s*\(.*)?"+StrToFind+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
  ;GetArguments(*This\Content\Text$, ~"(?:(\\w+)\\s*\\(.*)?"+StrToFind+~"(?:\\$)?(?:\\.\\w)?\\s*=\\s*(?:\")?([\\#\\w\\|\\s\\(\\)]+$|[\\#\\w\\|\\s\\(\\)]+)(?:\")?", 2)
EndMacro

Macro MacroCoordinate(MacroValue, MacroArg) ; 
  Select Asc(MacroArg)
    Case '0' To '9'
      MacroValue = Val(MacroArg) ; Если строка такого рода "10"
    Default
      MacroValue = GetVal(MacroArg) ; Если строка такого рода "GadgetX(#Gadget)"
      If MacroValue = 0
        MacroValue = Val(GetVarValue(MacroArg)) ; Если строка такого рода "x"
      EndIf
  EndSelect
EndMacro

Macro change_current_object_from_class(_class_)
  ChangeCurrentElement(ParsePBObject(), *This\get(_class_)\Adress)
EndMacro

Macro change_current_object_from_id(_object_)
  change_current_object_from_class(Str(_object_))
EndMacro

Macro get_argument_string(_string_)
  GetArguments(_string_, #RegEx_Pattern_Function, 2)
EndMacro

Macro is_object(_object_)
  Bool(IsGadget(_object_) | IsWindow(_object_))
EndMacro

Macro get_object_type(_object_)
  *This\get(Str(_object_))\Type\s.s
EndMacro

Macro get_object_class(_object_)
  *This\get(Str(_object_))\Object\s.s
EndMacro

Macro get_object_count(_object_)
  *This\get(Str(*This\get(Str(_object_))\Parent\i.i)+"_"+*This\get(Str(_object_))\Type\s.s)\Count
EndMacro

Macro get_object_adress(_object_)
  *This\get(Str(_object_))\Adress
EndMacro

Macro get_object_parent(_object_)
  *This\get(Str(_object_))\Parent\i.i
EndMacro

Macro get_object_window(_object_)
  *This\get(Str(_object_))\Window\i.i
EndMacro

Macro get_class_id(_class_)
  *This\get(_class_)\Object\i.i
EndMacro


; Macro is_container(Object)
;   *This\get(Str(Object))\container)
; EndMacro

;-
;- STRUCTURE
Structure Type_S
  i.i 
  s.s
EndStructure

Structure ContentStruct
  File$
  Text$    ; Содержимое файла 
  String$  ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
  Position.i  ; Положение Content-a в исходном файле
  Length.i    ; длинна Content-a в исходном файле
EndStructure

Structure CodeStruct
  Glob.ContentStruct
  Enum.ContentStruct
  Func.ContentStruct
  Decl.ContentStruct
  Even.ContentStruct
  Bind.ContentStruct
  
EndStructure

Structure ObjectStruct
  Count.i
  Index.i
  Adress.i
  Position.i ; Code.CodeStruct
  Map Code.ContentStruct()
  
  Type.Type_S   ; Type\s.s = OpenWindow;ButtonGadget;TextGadget
  Class.Type_S  ; Class\s.s = Window_0;Button_0;Text_0
  Object.Type_S ; Object\s.s = Window_0;Window_0_Button_0;Window_0_Text_0
  Parent.Type_S
  Window.Type_S
EndStructure

Structure FONT
  Object.Type_S
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  Object.Type_S
  Name$
EndStructure

Structure ParseStruct Extends ObjectStruct
  Item.i
  SubLevel.i ; 
  Container.i
  Content.ContentStruct  
  
  X.Type_S 
  Y.Type_S
  Width.Type_S
  Height.Type_S
  Caption.Type_S
  Param1.Type_S
  Param2.Type_S
  Param3.Type_S
  Flag.Type_S
  
  Map Font.FONT()
  Map Img.IMG()
  ;Map Code.ContentStruct()
  
  Args$
EndStructure

Structure ThisStruct Extends ParseStruct
  Map get.ObjectStruct()
EndStructure

Global NewList ParsePBObject.ParseStruct() 
Global *This.ThisStruct = AllocateStructure(ThisStruct)
;
*This\Index=-1
; *This\Item=-1

Global Indent = 2

;-
;- ENUMERATION
;#RegEx_Pattern_Others1 = ~"[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\]"
#RegEx_Pattern_Quotes = ~"(?:\"(.*?)\")" ; - Находит Кавычки
#RegEx_Pattern_Others = ~"(?:[\\s\\^\\|\\!\\~\\&\\$])" ; Находим остальное
#RegEx_Pattern_Match = ~"(?:([\\/])|([\\*])|([\\-])|([\\+]))" ; Находит (*-+/)
#RegEx_Pattern_Function = ~"(?:(\\w*)\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_World = ~"(?:([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+))"
#RegEx_Pattern_Captions = #RegEx_Pattern_Quotes+"|"+#RegEx_Pattern_Function+"|"+#RegEx_Pattern_Match+"|"+#RegEx_Pattern_World
#RegEx_Pattern_Arguments = "("+#RegEx_Pattern_Captions+"|"+#RegEx_Pattern_Others+")+"

#RegEx_Func = ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)"

#File=0
#Window=0

;-
Enumeration RegularExpression
  #RegEx_Function
  #RegEx_Arguments
  #RegEx_Arguments1
  #RegEx_Captions
  #RegEx_Captions1
  #Regex_Procedure
  #RegEx_Var
EndEnumeration

;-
;- OTHERS
Runtime Procedure$ GetObjectClass(Object)
  ProcedureReturn *This\get(Str(Object))\Object\s.s
EndProcedure

Procedure WE_Code_Show(Text$)
  Scintilla::SetText(WE_Scintilla_0, Text$)
EndProcedure


Procedure$ GetStr1(String$)
  Protected Result$, ID, Index, Value.f, Param1, Param2, Param3, Param1$
  Protected operand$, val$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions1, String$)
      While NextRegularExpressionMatch(#RegEx_Captions1)
        If RegularExpressionMatchString(#RegEx_Captions1)
          If operand$ = "-"
            val$ = RegularExpressionMatchString(#RegEx_Captions1)
            Result$ = Str(Val(Result$)-Val(RegularExpressionMatchString(#RegEx_Captions1)))
            operand$ = ""
          EndIf
          If operand$ = "*"
            If val$
              Result$ = Str(Val(Result$)+Val(val$))
              Result$ = Str(Val(Result$) - Val(val$)*Val(RegularExpressionMatchString(#RegEx_Captions1)))
              val$=""
            Else
              Result$ = Str(Val(Result$)*Val(RegularExpressionMatchString(#RegEx_Captions1)))
            EndIf
            operand$ = ""
          EndIf
          
          ;;Debug "    out - " + Result$
          
          Select RegularExpressionMatchString(#RegEx_Captions1)
            Case "#PB_Compiler_Home" : Result$+#PB_Compiler_Home
            Case "-" : operand$="-"
            Case "*" : operand$="*"
          EndSelect
          ;           Debug 55555555555
          ;           Debug Result$
          ;           Debug RegularExpressionMatchString(#RegEx_Captions1)
          
          If RegularExpressionGroup(#RegEx_Captions1, 2)
            ID = (*This\get(RegularExpressionGroup(#RegEx_Captions1, 3))\Object\i.i)
          EndIf
          
          
          Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
            Case "Chr"            : Result$+Chr(10)
            Case "Str"            : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "StrF"           
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions1, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Value.f = ValF(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2 : Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result$ + StrF(Value, Param2)
              EndIf
              
            Case "LCase" 
              ;                 If ExamineRegularExpression(#RegEx_Captions1, RegularExpressionGroup(#RegEx_Captions1, 3))
              ;                   While NextRegularExpressionMatch(#RegEx_Captions1)
              ;                     Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*This\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
              ;                     EndSelect
              ;                   Wend
              ;                 EndIf
              
            Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions1, 3)))
            Case "GetWindowTitle" : Result$+GetWindowTitle(ID)
            Case "WindowHeight"   
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions1, 3)) : Index=0
                Param2 = #PB_Window_InnerCoordinate ; Default value
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2 
                        Select RegularExpressionMatchString(#RegEx_Arguments1)
                          Case "#PB_Window_FrameCoordinate" : Param2 = #PB_Window_FrameCoordinate
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                Result$ + WindowHeight(ID, Param2)
              EndIf
              
            Default               
              Result$+RegularExpressionGroup(#RegEx_Captions1, 1) ; То что между кавичкамы
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure$ GetStr(String$)
  Protected Result$, ID, Index, Value.f, Param1, Param2, Param3, Param1$
  Protected operand$, val$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        If RegularExpressionMatchString(#RegEx_Captions)
          If operand$ = "-"
            val$ = RegularExpressionMatchString(#RegEx_Captions)
            Result$ = Str(Val(Result$)-Val(RegularExpressionMatchString(#RegEx_Captions)))
            operand$ = ""
          EndIf
          If operand$ = "*"
            If val$
              Result$ = Str(Val(Result$)+Val(val$))
              Result$ = Str(Val(Result$) - Val(val$)*Val(RegularExpressionMatchString(#RegEx_Captions)))
              val$=""
            Else
              Result$ = Str(Val(Result$)*Val(RegularExpressionMatchString(#RegEx_Captions)))
            EndIf
            operand$ = ""
          EndIf
          
          ;Debug "    out - " + Result$
          
          Select RegularExpressionMatchString(#RegEx_Captions)
            Case "#PB_Compiler_Home" : Result$+#PB_Compiler_Home
            Case "-" : operand$="-"
            Case "*" : operand$="*"
          EndSelect
          ;           Debug 55555555555
          ;           Debug Result$
          ;           Debug RegularExpressionMatchString(#RegEx_Captions)
          
          If RegularExpressionGroup(#RegEx_Captions, 2)
            ID = (*This\get(RegularExpressionGroup(#RegEx_Captions, 3))\Object\i.i)
          EndIf
          
          
          Select RegularExpressionGroup(#RegEx_Captions, 2) ; Название функции
            Case "Chr"            : Result$+Chr(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "Str"            : Result$+Str(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "StrF"           
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Value.f = ValF(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2 : Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result$ + StrF(Value, Param2)
              EndIf
              
            Case "LCase" 
              ;                 If ExamineRegularExpression(#RegEx_Captions1, RegularExpressionGroup(#RegEx_Captions, 3))
              ;                   While NextRegularExpressionMatch(#RegEx_Captions1)
              ;                     Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*This\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
              ;                     EndSelect
              ;                   Wend
              ;                 EndIf
              Result$+LCase(GetStr1(RegularExpressionGroup(#RegEx_Captions, 3)))
              
            Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "GetWindowTitle" : Result$+GetWindowTitle(ID)
            Case "WindowHeight"   
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                Param2 = #PB_Window_InnerCoordinate ; Default value
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2 
                        Select RegularExpressionMatchString(#RegEx_Arguments1)
                          Case "#PB_Window_FrameCoordinate" : Param2 = #PB_Window_FrameCoordinate
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                Result$ + WindowHeight(ID, Param2)
              EndIf
              
            Default               
              Result$+RegularExpressionGroup(#RegEx_Captions, 1) ; То что между кавичкамы
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure GetVal(String$)
  Protected Result, Index, Param1, Param2, Param3, Param1$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        If RegularExpressionMatchString(#RegEx_Captions) 
          Select RegularExpressionGroup(#RegEx_Captions, 2)
            Case "RGB"
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1) 
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1
                        Param1 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2
                        Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 3
                        Param3 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result = RGB(Param1, Param2, Param3)
              EndIf
              
            Case "ReadPreferenceLong"
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1
                        Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2
                        Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result = ReadPreferenceLong(Param1$, Param2)
              EndIf
              
            Case "WindowHeight"   
              Result = Val(GetStr1(String$))
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure$ GetArguments(String$, Pattern$, Group)
  Protected Result$
  Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
  Protected RegExID = CreateRegularExpression(#PB_Any, Pattern$, Create_Reg_Flag)
  
  If RegExID
    
    If ExamineRegularExpression(RegExID, String$)
      While NextRegularExpressionMatch(RegExID)
        If Group
          Result$ = RegularExpressionGroup(RegExID, Group)
        Else
          Result$ = RegularExpressionMatchString(RegExID)
        EndIf
      Wend
    EndIf
    
    FreeRegularExpression(RegExID)
  EndIf
  
  ;Debug " >> "+Result$ +" - "+Pattern$
  ProcedureReturn Trim(Trim(Trim(Result$), #CR$))
EndProcedure

Procedure$ ContentContent(FileName$)
  Protected *File, Format, Length
  Protected File = ReadFile(#PB_Any, FileName$)
  
  If File
    Length = Lof(File) 
    *File = AllocateMemory(Length)
    Format = ReadStringFormat(File)
    
    If *File 
      ReadData(File, *File, Length)
      ProcedureReturn PeekS(*File, Length, Format)
    EndIf
  Else
    MessageRequester("Предупреждение!!!", "Не получилось прочитать "+FileName$)
  EndIf
EndProcedure

;-
;- CREATE_FUNCTION
Procedure CF_Add(*This.ParseStruct, Index)
  Protected Result
  
  With *This
    Select \Type\s.s
      Case "HideWindow", "HideGadget", 
           "DisableWindow", "DisableGadget"
        Select Index
          Case 1 : \Object\s.s = \Args$
          Case 2 : \Param1\s.s = \Args$
        EndSelect
        
        Select \Param1\s.s
          Case "#True" : \Object\i.i = #True
          Case "#False" : \Param1\i.i = #False
          Default
            \Param1\i.i = Val(\Param1\s.s)
        EndSelect
        
      Case "LoadFont"
        Select Index
          Case 1 : \Object\s.s = \Args$
          Case 2 : \Param1\s.s = \Args$
          Case 3 : \Param2\s.s = \Args$
          Case 4 : \Param3\s.s = \Args$
        EndSelect
        
      Case "LoadImage", 
           "SetGadgetFont", 
           "SetGadgetState",
           "SetGadgetText"
        Select Index
          Case 1 : \Object\s.s = \Args$
          Case 2 : \Param1\s.s=GetStr(\Args$)
        EndSelect
        
      Case "ResizeGadget"
        Select Index
          Case 1 : \Object\s.s = \Args$
          Case 2 
            If "#PB_Ignore"=\Args$ 
              \X\i.i = #PB_Ignore
            Else
              \X\i.i = Val(\Args$)
            EndIf
            
          Case 3 
            If "#PB_Ignore"=\Args$ 
              \Y\i.i = #PB_Ignore
            Else
              \Y\i.i = Val(\Args$)
            EndIf
            
          Case 4 
            If "#PB_Ignore"=\Args$ 
              \Width\i.i = #PB_Ignore
            Else
              \Width\i.i = Val(\Args$)
            EndIf
            
          Case 5 
            If "#PB_Ignore"=\Args$ 
              \Height\i.i = #PB_Ignore
            Else
              \Height\i.i = Val(\Args$)
            EndIf
            
        EndSelect
        
      Case "SetGadgetColor"
        Select Index
          Case 1 : \Object\s.s = \Args$
          Case 2 
            Select \Args$
              Case "#PB_Gadget_FrontColor"      : \Param1\i.i = #PB_Gadget_FrontColor      ; Цвет текста гаджета
              Case "#PB_Gadget_BackColor"       : \Param1\i.i = #PB_Gadget_BackColor       ; Фон гаджета
              Case "#PB_Gadget_LineColor"       : \Param1\i.i = #PB_Gadget_LineColor       ; Цвет линий сетки
              Case "#PB_Gadget_TitleFrontColor" : \Param1\i.i = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
              Case "#PB_Gadget_TitleBackColor"  : \Param1\i.i = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
              Case "#PB_Gadget_GrayTextColor"   : \Param1\i.i = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
            EndSelect
            
          Case 3
            \Param2\i.i = Val(\Args$)
            Result = GetVal(\Args$)
            If Result
              \Param2\i.i = Result
            EndIf
        EndSelect
        
        
    EndSelect
    
  EndWith
  
EndProcedure

Procedure CF_Set(*ThisParse.ParseStruct)
  Protected Result, I, ID
  
  With *ThisParse ; 
    ID = *This\get(\Object\s.s)\Object\i.i
    
    Select \Type\s.s
      Case "GetActiveWindow"         : Result = GetActiveWindow()
      Case "GetActiveGadget"         : Result = GetActiveGadget()
        
      Case "UsePNGImageDecoder"      : UsePNGImageDecoder()
      Case "UsePNGImageEncoder"      : UsePNGImageEncoder()
      Case "UseJPEGImageDecoder"     : UseJPEGImageDecoder()
      Case "UseJPEG2000ImageEncoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEG2000ImageDecoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEGImageEncoder"     : UseJPEGImageEncoder()
      Case "UseGIFImageDecoder"      : UseGIFImageDecoder()
      Case "UseTGAImageDecoder"      : UseTGAImageDecoder()
      Case "UseTIFFImageDecoder"     : UseTIFFImageDecoder()
        
      Case "LoadFont"
        AddMapElement(\Font(), \Object\s.s) 
        
        \Font()\Name$=\Param1\s.s
        \Font()\Height=Val(\Param2\s.s)
        
        For I = 0 To CountString(\Param3\s.s,"|")
          Select Trim(StringField(\Param3\s.s,(I+1),"|"))
            Case "#PB_Font_Bold"        : \Font()\Style|#PB_Font_Bold
            Case "#PB_Font_HighQuality" : \Font()\Style|#PB_Font_HighQuality
            Case "#PB_Font_Italic"      : \Font()\Style|#PB_Font_Italic
            Case "#PB_Font_StrikeOut"   : \Font()\Style|#PB_Font_StrikeOut
            Case "#PB_Font_Underline"   : \Font()\Style|#PB_Font_Underline
          EndSelect
        Next
        
        \Font()\Object\i.i=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
        
      Case "LoadImage"
        AddMapElement(\Img(), \Object\s.s) 
        \Img()\Name$=\Param1\s.s
        \Img()\Object\i.i=LoadImage(#PB_Any, \Img()\Name$)
        
    EndSelect
    
    If IsWindow(ID)
      Select \Type\s.s
        Case "SetActiveWindow"         : SetActiveWindow(ID)
        Case "HideWindow"              : HideWindow(ID, \Param1\i.i)
        Case "DisableWindow"           : DisableWindow(ID, \Param1\i.i)
      EndSelect
    EndIf
    
    If IsGadget(ID)
      Select \Type\s.s
        Case "SetActiveGadget"         : SetActiveGadget(ID)
        Case "HideGadget"              : HideGadget(ID, \Param1\i.i)
        Case "DisableGadget"           : DisableGadget(ID, \Param1\i.i)
        Case "SetGadgetText"           : SetGadgetText(ID, \Param1\s.s)
        Case "SetGadgetColor"          : SetGadgetColor(ID, \Param1\i.i, \Param2\i.i)
          
        Case "SetGadgetFont"
          Protected Font = \Font(\Param1\s.s)\Object\i.i
          If IsFont(Font)
            SetGadgetFont(ID, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1\s.s)\Object\i.i
          If IsImage(Img)
            SetGadgetState(ID, ImageID(Img))
          EndIf
          
        Case "ResizeGadget"
          ResizeGadget(ID, \X\i.i, \Y\i.i, \Width\i.i, \Height\i.i)
          Transformation::Update(ID)
          
      EndSelect
    EndIf
  EndWith
  
EndProcedure

Procedure CF_Free(Object.i)
  
  If ListSize(ParsePBObject())
    With ParsePBObject()
      If IsGadget(Object)
        Select GadgetType(Object)
          Case #PB_GadgetType_Panel, 
               #PB_GadgetType_Container, 
               #PB_GadgetType_ScrollArea
            
            ForEach ParsePBObject()
              If \Parent\i.i = Object 
                Select GadgetType(\Object\i.i)
                  Case #PB_GadgetType_Panel, 
                       #PB_GadgetType_Container, 
                       #PB_GadgetType_ScrollArea
                    
                    CF_Free(\Object\i.i)
                    
                  Default
                    ReplaceString(*This\Content\Text$, \Content\String$, Space(Len(\Content\String$)), #PB_String_InPlace, \Content\Position, 1)
                    
                    *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count-1 
                    If *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count =< 0
                      DeleteMapElement(*This\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
                    EndIf
                    DeleteMapElement(*This\get(), \Object\s.s)
                    DeleteMapElement(*This\get(), Str(\Object\i.i))
                    DeleteElement(ParsePBObject())
                    
                EndSelect
              EndIf
            Next
        EndSelect
      EndIf
      
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        ;         Debug 666666666666
        ;         Debug "Text$ "+\Content\String$
        ReplaceString(*This\Content\Text$, \Content\String$, Space(Len(\Content\String$)), #PB_String_InPlace, \Content\Position, 1)
        ;          \Content\String$ = ""
        ;         \Content\Position = 0
        ;         \Content\Length = 0
        ; Debug *This\Content\Text$
        
        *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count-1 
        If *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count =< 0
          DeleteMapElement(*This\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
        EndIf
        DeleteMapElement(*This\get(), \Object\s.s)
        DeleteMapElement(*This\get(), Str(Object))
        DeleteElement(ParsePBObject())
        
      EndIf
    EndWith  
  EndIf
  
EndProcedure

;-
;- CREATE_OBJECT
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open()

Procedure.q Flag(Flag_String$)
  Protected i, Flag.q, String$
  
  If Flag_String$
    For I = 0 To CountString(Flag_String$,"|")
      String$ = Trim(StringField(Flag_String$,(I+1),"|"))
      
      Select String$
          ; window
        Case "#PB_Window_BorderLess"              : Flag = Flag | #PB_Window_BorderLess
        Case "#PB_Window_Invisible"               : Flag = Flag | #PB_Window_Invisible
        Case "#PB_Window_Maximize"                : Flag = Flag | #PB_Window_Maximize
        Case "#PB_Window_Minimize"                : Flag = Flag | #PB_Window_Minimize
        Case "#PB_Window_MaximizeGadget"          : Flag = Flag | #PB_Window_MaximizeGadget
        Case "#PB_Window_MinimizeGadget"          : Flag = Flag | #PB_Window_MinimizeGadget
        Case "#PB_Window_NoActivate"              : Flag = Flag | #PB_Window_NoActivate
        Case "#PB_Window_NoGadgets"               : Flag = Flag | #PB_Window_NoGadgets
        Case "#PB_Window_SizeGadget"              : Flag = Flag | #PB_Window_SizeGadget
        Case "#PB_Window_SystemMenu"              : Flag = Flag | #PB_Window_SystemMenu
        Case "#PB_Window_TitleBar"                : Flag = Flag | #PB_Window_TitleBar
        Case "#PB_Window_Tool"                    : Flag = Flag | #PB_Window_Tool
        Case "#PB_Window_ScreenCentered"          : Flag = Flag | #PB_Window_ScreenCentered
        Case "#PB_Window_WindowCentered"          : Flag = Flag | #PB_Window_WindowCentered
          ; buttonimage 
        Case "#PB_Button_Image"                   : Flag = Flag | #PB_Button_Image
        Case "#PB_Button_PressedImage"            : Flag = Flag | #PB_Button_PressedImage
          ; button  
        Case "#PB_Button_Default"                 : Flag = Flag | #PB_Button_Default
        Case "#PB_Button_Left"                    : Flag = Flag | #PB_Button_Left
        Case "#PB_Button_MultiLine"               : Flag = Flag | #PB_Button_MultiLine
        Case "#PB_Button_Right"                   : Flag = Flag | #PB_Button_Right
        Case "#PB_Button_Toggle"                  : Flag = Flag | #PB_Button_Toggle
          ; string
        Case "#PB_String_BorderLess"              : Flag = Flag | #PB_String_BorderLess
        Case "#PB_String_LowerCase"               : Flag = Flag | #PB_String_LowerCase
        Case "#PB_String_MaximumLength"           : Flag = Flag | #PB_String_MaximumLength
        Case "#PB_String_Numeric"                 : Flag = Flag | #PB_String_Numeric
        Case "#PB_String_Password"                : Flag = Flag | #PB_String_Password
        Case "#PB_String_ReadOnly"                : Flag = Flag | #PB_String_ReadOnly
        Case "#PB_String_UpperCase"               : Flag = Flag | #PB_String_UpperCase
          ; text
        Case "#PB_Text_Border"                    : Flag = Flag | #PB_Text_Border
        Case "#PB_Text_Center"                    : Flag = Flag | #PB_Text_Center
        Case "#PB_Text_Right"                     : Flag = Flag | #PB_Text_Right
          ; option
          ; checkbox
        Case "#PB_CheckBox_Center"                : Flag = Flag | #PB_CheckBox_Center
        Case "#PB_CheckBox_Right"                 : Flag = Flag | #PB_CheckBox_Right
        Case "#PB_CheckBox_ThreeState"            : Flag = Flag | #PB_CheckBox_ThreeState
          ; listview
        Case "#PB_ListView_ClickSelect"           : Flag = Flag | #PB_ListView_ClickSelect
        Case "#PB_ListView_MultiSelect"           : Flag = Flag | #PB_ListView_MultiSelect
          ; frame
        Case "#PB_Frame_Double"                   : Flag = Flag | #PB_Frame_Double
        Case "#PB_Frame_Flat"                     : Flag = Flag | #PB_Frame_Flat
        Case "#PB_Frame_Single"                   : Flag = Flag | #PB_Frame_Single
          ; combobox
        Case "#PB_ComboBox_Editable"              : Flag = Flag | #PB_ComboBox_Editable
        Case "#PB_ComboBox_Image"                 : Flag = Flag | #PB_ComboBox_Image
        Case "#PB_ComboBox_LowerCase"             : Flag = Flag | #PB_ComboBox_LowerCase
        Case "#PB_ComboBox_UpperCase"             : Flag = Flag | #PB_ComboBox_UpperCase
          ; image 
        Case "#PB_Image_Border"                   : Flag = Flag | #PB_Image_Border
        Case "#PB_Image_Raised"                   : Flag = Flag | #PB_Image_Raised
          ; hyperlink 
        Case "#PB_HyperLink_Underline"            : Flag = Flag | #PB_HyperLink_Underline
          ; container 
        Case "#PB_Container_BorderLess"           : Flag = Flag | #PB_Container_BorderLess
        Case "#PB_Container_Double"               : Flag = Flag | #PB_Container_Double
        Case "#PB_Container_Flat"                 : Flag = Flag | #PB_Container_Flat
        Case "#PB_Container_Raised"               : Flag = Flag | #PB_Container_Raised
        Case "#PB_Container_Single"               : Flag = Flag | #PB_Container_Single
          ; listicon
        Case "#PB_ListIcon_AlwaysShowSelection"   : Flag = Flag | #PB_ListIcon_AlwaysShowSelection
        Case "#PB_ListIcon_CheckBoxes"            : Flag = Flag | #PB_ListIcon_CheckBoxes
        Case "#PB_ListIcon_ColumnWidth"           : Flag = Flag | #PB_ListIcon_ColumnWidth
        Case "#PB_ListIcon_DisplayMode"           : Flag = Flag | #PB_ListIcon_DisplayMode
        Case "#PB_ListIcon_GridLines"             : Flag = Flag | #PB_ListIcon_GridLines
        Case "#PB_ListIcon_FullRowSelect"         : Flag = Flag | #PB_ListIcon_FullRowSelect
        Case "#PB_ListIcon_HeaderDragDrop"        : Flag = Flag | #PB_ListIcon_HeaderDragDrop
        Case "#PB_ListIcon_LargeIcon"             : Flag = Flag | #PB_ListIcon_LargeIcon
        Case "#PB_ListIcon_List"                  : Flag = Flag | #PB_ListIcon_List
        Case "#PB_ListIcon_MultiSelect"           : Flag = Flag | #PB_ListIcon_MultiSelect
        Case "#PB_ListIcon_Report"                : Flag = Flag | #PB_ListIcon_Report
        Case "#PB_ListIcon_SmallIcon"             : Flag = Flag | #PB_ListIcon_SmallIcon
        Case "#PB_ListIcon_ThreeState"            : Flag = Flag | #PB_ListIcon_ThreeState
          ; ipaddress
          ; progressbar 
        Case "#PB_ProgressBar_Smooth"             : Flag = Flag | #PB_ProgressBar_Smooth
        Case "#PB_ProgressBar_Vertical"           : Flag = Flag | #PB_ProgressBar_Vertical
          ; scrollbar 
        Case "#PB_ScrollBar_Vertical"             : Flag = Flag | #PB_ScrollBar_Vertical
          ; scrollarea 
        Case "#PB_ScrollArea_BorderLess"          : Flag = Flag | #PB_ScrollArea_BorderLess
        Case "#PB_ScrollArea_Center"              : Flag = Flag | #PB_ScrollArea_Center
        Case "#PB_ScrollArea_Flat"                : Flag = Flag | #PB_ScrollArea_Flat
        Case "#PB_ScrollArea_Raised"              : Flag = Flag | #PB_ScrollArea_Raised
        Case "#PB_ScrollArea_Single"              : Flag = Flag | #PB_ScrollArea_Single
          ; trackbar
        Case "#PB_TrackBar_Ticks"                 : Flag = Flag | #PB_TrackBar_Ticks
        Case "#PB_TrackBar_Vertical"              : Flag = Flag | #PB_TrackBar_Vertical
          ; web
          ; calendar
        Case "#PB_Calendar_Borderless"            : Flag = Flag | #PB_Calendar_Borderless
          
          ; date
        Case "#PB_Date_CheckBox"                  : Flag = Flag | #PB_Date_CheckBox
        Case "#PB_Date_UpDown"                    : Flag = Flag | #PB_Date_UpDown
          
          ; editor
        Case "#PB_Editor_ReadOnly"                : Flag = Flag | #PB_Editor_ReadOnly
        Case "#PB_Editor_WordWrap"                : Flag = Flag | #PB_Editor_WordWrap
          
          ; explorerlist
        Case "#PB_Explorer_BorderLess"            : Flag = Flag | #PB_Explorer_BorderLess          ; Создать гаджет без границ.
        Case "#PB_Explorer_AlwaysShowSelection"   : Flag = Flag | #PB_Explorer_AlwaysShowSelection ; Выделение отображается даже если гаджет не активирован.
        Case "#PB_Explorer_MultiSelect"           : Flag = Flag | #PB_Explorer_MultiSelect         ; Разрешить множественное выделение элементов в гаджете.
        Case "#PB_Explorer_GridLines"             : Flag = Flag | #PB_Explorer_GridLines           ; Отображать разделительные линии между строками и колонками.
        Case "#PB_Explorer_HeaderDragDrop"        : Flag = Flag | #PB_Explorer_HeaderDragDrop      ; В режиме таблицы заголовки можно перетаскивать (Drag'n'Drop).
        Case "#PB_Explorer_FullRowSelect"         : Flag = Flag | #PB_Explorer_FullRowSelect       ; Выделение охватывает всю строку, а не первую колонку.
        Case "#PB_Explorer_NoFiles"               : Flag = Flag | #PB_Explorer_NoFiles             ; Не показывать файлы.
        Case "#PB_Explorer_NoFolders"             : Flag = Flag | #PB_Explorer_NoFolders           ; Не показывать каталоги.
        Case "#PB_Explorer_NoParentFolder"        : Flag = Flag | #PB_Explorer_NoParentFolder      ; Не показывать ссылку на родительский каталог [..].
        Case "#PB_Explorer_NoDirectoryChange"     : Flag = Flag | #PB_Explorer_NoDirectoryChange   ; Пользователь не может сменить директорию.
        Case "#PB_Explorer_NoDriveRequester"      : Flag = Flag | #PB_Explorer_NoDriveRequester    ; Не показывать запрос 'пожалуйста, вставьте диск X:'.
        Case "#PB_Explorer_NoSort"                : Flag = Flag | #PB_Explorer_NoSort              ; Пользователь не может сортировать содержимое по клику на заголовке колонки.
        Case "#PB_Explorer_AutoSort"              : Flag = Flag | #PB_Explorer_AutoSort            ; Содержимое автоматически упорядочивается по имени.
        Case "#PB_Explorer_HiddenFiles"           : Flag = Flag | #PB_Explorer_HiddenFiles         ; Будет отображать скрытые файлы (поддерживается только в Linux и OS X).
        Case "#PB_Explorer_NoMyDocuments"         : Flag = Flag | #PB_Explorer_NoMyDocuments       ; Не показывать каталог 'Мои документы' в виде отдельного элемента.
          
          ; explorercombo
        Case "#PB_Explorer_DrivesOnly"            : Flag = Flag | #PB_Explorer_DrivesOnly          ; Гаджет будет отображать только диски, которые вы можете выбрать.
        Case "#PB_Explorer_Editable"              : Flag = Flag | #PB_Explorer_Editable            ; Гаджет будет доступен для редактирования с функцией автозаполнения.  			      С этим флагом он действует точно так же, как тот что в Windows Explorer.
          
          ; explorertree
        Case "#PB_Explorer_NoLines"               : Flag = Flag | #PB_Explorer_NoLines             ; Скрыть линии, соединяющие узлы дерева.
        Case "#PB_Explorer_NoButtons"             : Flag = Flag | #PB_Explorer_NoButtons           ; Скрыть кнопки разворачивания узлов в виде символов '+'.
          
          ; spin
        Case "#PB_Spin_Numeric"                   : Flag = Flag | #PB_Spin_Numeric
        Case "#PB_Spin_ReadOnly"                  : Flag = Flag | #PB_Spin_ReadOnly
          ; tree
        Case "#PB_Tree_AlwaysShowSelection"       : Flag = Flag | #PB_Tree_AlwaysShowSelection
        Case "#PB_Tree_CheckBoxes"                : Flag = Flag | #PB_Tree_CheckBoxes
        Case "#PB_Tree_NoButtons"                 : Flag = Flag | #PB_Tree_NoButtons
        Case "#PB_Tree_NoLines"                   : Flag = Flag | #PB_Tree_NoLines
        Case "#PB_Tree_ThreeState"                : Flag = Flag | #PB_Tree_ThreeState
          ; panel
          ; splitter
        Case "#PB_Splitter_Separator"             : Flag = Flag | #PB_Splitter_Separator
        Case "#PB_Splitter_Vertical"              : Flag = Flag | #PB_Splitter_Vertical
        Case "#PB_Splitter_FirstFixed"            : Flag = Flag | #PB_Splitter_FirstFixed
        Case "#PB_Splitter_SecondFixed"           : Flag = Flag | #PB_Splitter_SecondFixed
          ; mdi
        Case "#PB_MDI_AutoSize"                   : Flag = Flag | #PB_MDI_AutoSize
        Case "#PB_MDI_BorderLess"                 : Flag = Flag | #PB_MDI_BorderLess
        Case "#PB_MDI_NoScrollBars"               : Flag = Flag | #PB_MDI_NoScrollBars
          ; scintilla
          ; shortcut
          ; canvas
        Case "#PB_Canvas_Border"                  : Flag = Flag | #PB_Canvas_Border
        Case "#PB_Canvas_ClipMouse"               : Flag = Flag | #PB_Canvas_ClipMouse
        Case "#PB_Canvas_Container"               : Flag = Flag | #PB_Canvas_Container
        Case "#PB_Canvas_DrawFocus"               : Flag = Flag | #PB_Canvas_DrawFocus
        Case "#PB_Canvas_Keyboard"                : Flag = Flag | #PB_Canvas_Keyboard
          
        Default
          Select Asc(String$)
            Case '0' To '9'
              Flag = Flag | Val(String$)
            Default
              Flag = Flag | Flag(GetVarValue(String$))
          EndSelect
      EndSelect
      
    Next
  EndIf
  
  ProcedureReturn Flag
EndProcedure


Procedure CO_Free(Object)
  Protected i
  ;ProcedureReturn 
  
  For i=0 To CountGadgetItems(WE_Tree_0)-1
    If Object=GetGadgetItemData(WE_Tree_0, i) 
      RemoveGadgetItem(WE_Tree_0, i)
      Break
    EndIf
  Next 
  
  With ParsePBObject()
    ;     ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
    ;     *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count-1 
    ;     If *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count =< 0
    ;       DeleteMapElement(*This\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
    ;     EndIf
    ;     DeleteMapElement(*This\get(), \Object\s.s)
    ;     DeleteMapElement(*This\get(), Str(Object))
    ;     DeleteElement(ParsePBObject())
    CF_Free(Object)
    
    Transformation::Free(Object)
    
    If IsGadget(Object)
      FreeGadget(Object)
    ElseIf IsWindow(Object)
      CloseWindow(Object)
    EndIf
  EndWith
EndProcedure

Procedure CO_Events()
  Protected I.i, Parent=-1, Object =- 1
  
  If IsGadget(EventGadget())
    Object = EventGadget()
  ElseIf IsWindow(EventWindow())
    Object = EventWindow()
  EndIf
  
  Select Event()
    Case #PB_Event_Create
      With ParsePBObject()
        ;         PushListPosition(ParsePBObject())
        ;         ForEach ParsePBObject()
        ;           If Object = \Object\i.i
        change_current_object_from_id(Object)
        Transformation::Create(\Object\i.i, \Parent\i.i, \Window\i.i, \Item, 5)
        If IsGadget(\Object\i.i) And GadgetType(\Object\i.i) = #PB_GadgetType_Splitter
          Transformation::Free(GetGadgetAttribute(\Object\i.i, #PB_Splitter_FirstGadget))
          Transformation::Free(GetGadgetAttribute(\Object\i.i, #PB_Splitter_SecondGadget))
        EndIf
        Properties::Init(\Object\i.i, \Object\s.s, \Flag\s.s)
        ;             Break
        ;           EndIf
        ;         Next
        ;         PopListPosition(ParsePBObject())
      EndWith
      
      ; 
      ;       If IsWindow(Object)
      ;         If Transformation::PopupMenu
      ;           MenuItem(WE_Menu_Delete, "Delete"          +Chr(9)+"Ctrl+D")
      ;           MenuItem(WE_Menu_Block, "Block changes"   +Chr(9)+"Ctrl+B")
      ;         EndIf
      ;       EndIf
      
    Case #PB_Event_Gadget
      
      Select EventType()
        Case #PB_EventType_CloseItem ; Delete
          CO_Free(Object)
          
        Case #PB_EventType_StatusChange
          
          ; При выборе гаджета обнавляем испектор
          For I=0 To CountGadgetItems(WE_Tree_0)-1
            If Object = GetGadgetItemData(WE_Tree_0, I) : SetGadgetState(WE_Tree_0, I)
              PostEvent(#PB_Event_Gadget, WE, WE_Tree_0, #PB_EventType_Change)
              Transformation::Change(Object)
              Break
            EndIf
          Next  
          
      EndSelect
      
    Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
      
      CO_Create(ReplaceString(EventDropText(), "gadget", ""),
                WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
      
  EndSelect
EndProcedure

Procedure CO_Insert(*ThisParse.ParseStruct, Parent)
  Protected ID$, Handle$
  CodeShow = 1
  
  With *ThisParse
    
    ; 
    Protected Variable$, VariableLength
    
    If \Type\s.s = "OpenWindow"
      Variable$ = #CRLF$+"Global "+\Object\s.s+"=-1"
    Else
      Variable$ = ","+#CRLF$+Space(Len("Global "))+\Object\s.s+"=-1"
    EndIf
    VariableLength = Len(Variable$)
    
    Debug "  Code_Object" + *This\get(*This\Window\s.s)\Code("Code_Object")\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, *This\get(*This\Window\s.s)\Code("Code_Object")\Position) 
    *This\get(*This\Window\s.s)\Code("Code_Object")\Position + VariableLength
    
    Debug "  Code_Function" + *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Function")\Position
    \Content\Position = *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Function")\Position  + VariableLength
    
    If VariableLength
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\s.s)\Code("Code_Function")\Position + VariableLength
        EndIf
      Next
      PopListPosition(ParsePBObject())
    EndIf
    
    If Asc(\Object\s.s) = '#'
      ID$ = \Object\s.s
    Else
      Select Asc(\Object\s.s)
        Case '0' To '9'
          ID$ = Chr(Asc(\Object\s.s))
        Default
          Handle$ = \Object\s.s+" = "
          ID$ = "#PB_Any"
      EndSelect
    EndIf
    
    Select \Type\s.s
        Case "OpenWindow"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ButtonGadget"        : \Content\String$ = Handle$+"ButtonGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "StringGadget"        : \Content\String$ = Handle$+"StringGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "TextGadget"          : \Content\String$ = Handle$+"TextGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "CheckBoxGadget"      : \Content\String$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
      Case "OptionGadget"        : \Content\String$ = Handle$+"OptionGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)
        Case "ListViewGadget"      : \Content\String$ = Handle$+"ListViewGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "FrameGadget"         : \Content\String$ = Handle$+"FrameGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ComboBoxGadget"      : \Content\String$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ImageGadget"         : \Content\String$ = Handle$+"ImageGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s                                                                 : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "HyperLinkGadget"     : \Content\String$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)+", "+\Param1\s.s                                  : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ContainerGadget"     : \Content\String$ = Handle$+"ContainerGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ListIconGadget"      : \Content\String$ = Handle$+"ListIconGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)+", "+\Param1\s.s                                  : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
      Case "IPAddressGadget"     : \Content\String$ = Handle$+"IPAddressGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s
        Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s+", "+\Param3\s.s                                     : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ScrollAreaGadget"    : \Content\String$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                        : If \Param3\s.s : \Content\String$ +", "+\Param3\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf 
        Case "TrackBarGadget"      : \Content\String$ = Handle$+"TrackBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                          : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
      Case "WebGadget"           : \Content\String$ = Handle$+"WebGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)
        Case "ButtonImageGadget"   : \Content\String$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s                                              : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "CalendarGadget"      : \Content\String$ = Handle$+"CalendarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                         : If \Param1\s.s : \Content\String$ +", "+\Param1\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "DateGadget"          : \Content\String$ = Handle$+"DateGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                    : If \Param1\s.s : \Content\String$ +", "+\Param1\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "EditorGadget"        : \Content\String$ = Handle$+"EditorGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                           : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ExplorerListGadget"  : \Content\String$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                            : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ExplorerTreeGadget"  : \Content\String$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                            : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ExplorerComboGadget" : \Content\String$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                           : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "SpinGadget"          : \Content\String$ = Handle$+"SpinGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                              : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "TreeGadget"          : \Content\String$ = Handle$+"TreeGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                             : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
      Case "PanelGadget"         : \Content\String$ = Handle$+"PanelGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s 
        Case "SplitterGadget"      : \Content\String$ = Handle$+"SplitterGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "MDIGadget"           : \Content\String$ = Handle$+"MDIGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf 
      Case "ScintillaGadget"     : \Content\String$ = Handle$+"ScintillaGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s
      Case "ShortcutGadget"      : \Content\String$ = Handle$+"ShortcutGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s
        Case "CanvasGadget"        : \Content\String$ = Handle$+"CanvasGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
    EndSelect
    
    \Content\String$+")" 
    
    \Content\Length = Len(\Content\String$)
    
    *This\Content\Length = \Content\Length
    *This\Content\Position = \Content\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, \Content\String$+#CRLF$+Space(Indent), \Content\Position) 
    
    
    ; У окна меняем последную позицию.
    *This\get(*This\Window\s.s)\Code("Code_Function")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
    
    ; 
    If *This\Container
      ; Сохряняем у объект-а последную позицию.
      *This\get(\Object\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
      Debug \Object\s.s +" "+ *This\get(\Object\s.s)\Code("Code_Function")\Position 
      
      Select *This\Type\s.s
        Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
          ; 
          *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(Indent), *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))) 
          *This\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
          ; У окна меняем последную позицию.
          *This\get(*This\Window\s.s)\Code("Code_Function")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
      EndSelect
      
    Else
      If IsGadget(Parent)
        PushListPosition(ParsePBObject())
        ForEach ParsePBObject()
          Select ParsePBObject()\Container
            Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea, #PB_GadgetType_Canvas
              ; Проверяем позицию родителя в генерируемом коде
              If *This\get(ParsePBObject()\Object\s.s)\Code("Code_Function")\Position>*This\Content\Position
                ; У родителя меняем последную позицию.
                *This\get(ParsePBObject()\Object\s.s)\Code("Code_Function")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
              EndIf
          EndSelect
        Next
        PopListPosition(ParsePBObject())
      EndIf
      
    EndIf
    
    ; Записываем у родителя позицию конца добавления объекта
    *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
  EndWith
EndProcedure

Procedure CO_Create(Type$, X, Y, Parent=-1)
  Protected GadgetList
  Protected Object, Position
  Protected Buffer.s, BuffType$, i.i, j.i
  
  With *This
    ; Определяем позицию и родителя для создания объекта
    If IsGadget(Parent) 
      X - GadgetX(Parent, #PB_Gadget_WindowCoordinate)
      Y - GadgetY(Parent, #PB_Gadget_WindowCoordinate)
      GadgetList = OpenGadgetList(Parent, GetGadgetState(Parent)) 
    ElseIf IsWindow(Parent)
      GadgetList = UseGadgetList(WindowID(Parent))
    Else ; Создали новое окно
      X=0
      Y=0
      \Parent\i.i =- 1
    EndIf
    
    Select Type$
      Case "Window" : \Type\s.s = "OpenWindow"
      Case "Menu", "ToolBar" : \Type\s.s = Type$
      Default 
        \Type\s.s=ULCase(Type$) + "Gadget"
        
        \Type\s.s = ReplaceString(\Type\s.s, "box","Box")
        \Type\s.s = ReplaceString(\Type\s.s, "link","Link")
        \Type\s.s = ReplaceString(\Type\s.s, "bar","Bar")
        \Type\s.s = ReplaceString(\Type\s.s, "area","Area")
        \Type\s.s = ReplaceString(\Type\s.s, "Ipa","IPA")
        
        \Type\s.s = ReplaceString(\Type\s.s, "view","View")
        \Type\s.s = ReplaceString(\Type\s.s, "icon","Icon")
        \Type\s.s = ReplaceString(\Type\s.s, "image","Image")
        \Type\s.s = ReplaceString(\Type\s.s, "combo","Combo")
        \Type\s.s = ReplaceString(\Type\s.s, "list","List")
        \Type\s.s = ReplaceString(\Type\s.s, "tree","Tree")
    EndSelect
    
    Protected *ThisParse.ParseStruct = AddElement(ParsePBObject())
    If  *ThisParse
      Restore Model 
      For i=1 To 1+33 ; gadget count
        For j=1 To 7  ; i.i count
          Read.s Buffer
          
          Select j
            Case 1  
              If \Type\s.s=Buffer
                BuffType$ = Buffer
              EndIf
          EndSelect
          
          If BuffType$ = \Type\s.s
            Select j
              Case 1 
                ParsePBObject()\Type\s.s=Buffer
                If Buffer = "OpenWindow"
                  \Class\s.s=ReplaceString(Buffer, "Open","")+"_"
                Else
                  \Class\s.s=ReplaceString(Buffer, "Gadget","")+"_"
                EndIf
                
              Case 2 : ParsePBObject()\Width\s.s=Buffer
              Case 3 : ParsePBObject()\Height\s.s=Buffer
              Case 4 : ParsePBObject()\Param1\s.s=Buffer
              Case 5 : ParsePBObject()\Param2\s.s=Buffer
              Case 6 : ParsePBObject()\Param3\s.s=Buffer
              Case 7 : ParsePBObject()\Flag\s.s=Buffer
            EndSelect
          EndIf
        Next  
        BuffType$ = ""
      Next  
      
      \Flag\i.i=Flag(ParsePBObject()\Flag\s.s)
      \Class\s.s+\get(Str(Parent)+"_"+\Type\s.s)\Count
      \Caption\s.s = \Class\s.s
      
      ; Формируем имя объекта
      ParsePBObject()\Class\s.s = \Class\s.s
      If \get(Str(Parent))\Object\s.s
        \Object\s.s = \get(Str(Parent))\Object\s.s+"_"+\Class\s.s
      Else
        \Object\s.s = \Class\s.s
        ParsePBObject()\Flag\s.s="Flag"
      EndIf
      
      \X\i.i = X
      \Y\i.i = Y
      \Width\i.i = Val(ParsePBObject()\Width\s.s)
      \Height\i.i = Val(ParsePBObject()\Height\s.s)
      
      ParsePBObject()\X\s.s = Str(\X\i.i)
      ParsePBObject()\Y\s.s = Str(\Y\i.i)
      ParsePBObject()\Type\s.s = \Type\s.s
      ParsePBObject()\Object\s.s = \Object\s.s
      ParsePBObject()\Caption\s.s = \Caption\s.s
      
      ; Сначала определять кто есть кто.
      Select \Type\s.s
        Case "OpenWindow" 
          \Container =- 1 
          \Window\s.s = \Object\s.s 
          \Parent\s.s = \Object\s.s
        Case "PanelGadget" : \Container = #PB_GadgetType_Panel
          \Parent\s.s = \Object\s.s
        Case "ContainerGadget" : \Container = #PB_GadgetType_Container
          \Parent\s.s = \Object\s.s
        Case "ScrollAreaGadget" : \Container = #PB_GadgetType_ScrollArea
          \Parent\s.s = \Object\s.s
        Case "CanvasGadget"
          If ((\Flag\i.i&#PB_Canvas_Container)=#PB_Canvas_Container)
            \Container = #PB_GadgetType_Canvas
            \Parent\s.s = \Object\s.s
          EndIf
        Default
          \Container = #PB_GadgetType_Unknown
      EndSelect
      
      ; Загружаем выходной код
      If \Content\Text$=""
        Restore Content
        Read.s Buffer
        \Content\Text$ = Buffer
        \get(\Window\s.s)\Code("Code_Object")\Position = 16
        \get(\get(Str(Parent))\Object\s.s)\Code("Code_Function")\Position = 249 ; 176+5
      EndIf
      
      CO_Insert(*ThisParse, Parent) 
      \Parent\i.i = Parent
    EndIf
    
    Position = WE_Tree_0_Position(WE_Tree_0, Parent)
    
    Object=CallFunctionFast(@CO_Open())
    
    If IsGadget(Object)
      ;       Select \Type\i.i
      ;         Case #PB_GadgetType_Panel
      ;           ;OpenGadgetList(Object, 0)
      ;           AddGadgetItem(Object, -1, \Object\s.s)
      ;       EndSelect
      
      Select \Type\i.i ; GadgetType(Object)
        Case #PB_GadgetType_Panel, 
             #PB_GadgetType_Container, 
             #PB_GadgetType_ScrollArea
          CloseGadgetList()
      EndSelect
    EndIf
    
    WE_Tree_0_Update(WE_Tree_0, Position)
    
    
    If GadgetList 
      If IsGadget(Parent) 
        CloseGadgetList() 
      ElseIf IsWindow(Parent)
        UseGadgetList(GadgetList)
      EndIf
    EndIf
    
    ;     Debug "-------------create----------------"
    ;     Debug \Content\Text$
    WE_Code_Show(\Content\Text$)
    
  EndWith
  
  DataSection
    Model:
    ;{
    Data.s "FormGadget","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
    Data.s "OpenWindow","400","300","ParentID","0","0", "#PB_Window_SystemMenu"
    Data.s "ButtonGadget","80","20","0","0","0",""
    Data.s "StringGadget","80","20","0","0","0",""
    Data.s "TextGadget","80","20","0","0","0","#PB_Text_Border"
    Data.s "CheckBoxGadget","80","20","0","0","0",""
    Data.s "OptionGadget","80","20","0","0","0",""
    Data.s "ListViewGadget","150","150","0","0","0",""
    Data.s "FrameGadget","150","150","0","0","0",""
    Data.s "ComboBoxGadget","100","20","0","0","0",""
    Data.s "ImageGadget","120","120","0","0","0","#PB_Image_Border"
    Data.s "HyperLinkGadget","150","200","$0000FF","0","0",""
    Data.s "ContainerGadget","140","120","0","0","0", "#PB_Container_Flat"
    Data.s "ListIconGadget","180","180","0","0","0",""
    Data.s "IPAddressGadget","80", "20","0","0","0",""
    Data.s "ProgressBarGadget","80","20","0","0","0",""
    Data.s "ScrollBarGadget","80","20","0","0","0",""
    Data.s "ScrollAreaGadget","150","150","0","0","0",""
    Data.s "TrackBarGadget","180","150","0","0","0",""
    Data.s "WebGadget","100","20","0","0","0",""
    Data.s "ButtonImageGadget","20","20","0","0","0",""
    Data.s "CalendarGadget","150","200","0","0","0",""
    Data.s "DateGadget","80","20","0","0","0",""
    Data.s "EditorGadget","80","20","0","0","0",""
    Data.s "ExplorerListGadget","150","150","0","0","0",""
    Data.s "ExplorerTreeGadget","180","150","0","0","0",""
    Data.s "ExplorerComboGadget","100","20","0","0","0",""
    Data.s "SpinGadget","80","20","-1000","1000","0","#PB_Spin_Numeric"
    Data.s "TreeGadget","150","180","0","0","0",""
    Data.s "PanelGadget","140","120","0","0","0",""
    Data.s "SplitterGadget","180","100","0","0","0","#PB_Splitter_Separator"
    Data.s "MDIGadget","150","150","0","0","0",""
    Data.s "ScintillaGadget","180","150","0","0","0",""
    Data.s "ShortcutGadget","100","20","0","0","0",""
    Data.s "CanvasGadget","150","150","0","0","0",""
    ;}
    
    
    Content:
    ;{
    Data.s "EnableExplicit"+#CRLF$+
           ""+#CRLF$+
           "Declare Window_0_Events(Event)"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)"+#CRLF$+
           "  If IsWindow(Window_0)"+#CRLF$+
           "    SetActiveWindow(Window_0)"+#CRLF$+    
           "    ProcedureReturn Window_0"+#CRLF$+    
           "  EndIf"+#CRLF$+
           "  "+#CRLF$+  
           "  "+#CRLF$+  
           "  ProcedureReturn Window_0"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Events(Event)"+#CRLF$+
           "  Select Event"+#CRLF$+
           "    Case #PB_Event_CloseWindow"+#CRLF$+
           "      CloseWindow(EventWindow())"+#CRLF$+
           "      "+#CRLF$+
           "    Case #PB_Event_Gadget"+#CRLF$+
           "      Select EventType()"+#CRLF$+
           "        Case #PB_EventType_LeftClick"+#CRLF$+
           "          Select EventGadget()"+#CRLF$+
           "             "+#CRLF$+            
           "          EndSelect"+#CRLF$+
           "      EndSelect"+#CRLF$+
           "  EndSelect"+#CRLF$+
           "  "+#CRLF$+
           "  ProcedureReturn Window_0"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           ""+#CRLF$+
           "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
           "  Window_0_Open()"+#CRLF$+
           ""+#CRLF$+  
           "  While IsWindow(Window_0_Events(WaitWindowEvent())) : Wend"+#CRLF$+
           "CompilerEndIf"
    ;}
    
  EndDataSection
  
EndProcedure

Procedure CO_Open() ; Ok
  Protected GetParent, OpenGadgetList, Object=-1
  Static AddGadget
  
  With *This
    ;
    Select \Type\s.s
      Case "FormGadget"          : \Type\i.i =- 1  : \Window\i.i =- 1  : \Object\i.i = CanvasGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, #PB_Canvas_Container) : CloseGadgetList()
      Case "OpenWindow"          : \Type\i.i =- 1  : \Window\i.i =- 1  
        \Object\i.i = AddGadgetItem(WE_ScrollArea_0, #PB_Any, \Caption\s.s, 0, \Flag\i.i)
        ResizeWindow(\Object\i.i, 20,20,\Width\i.i,\Height\i.i); , \Flag\i.i, \Param1\i.i)
                                                                              ;Case "OpenWindow"          : \Type\i.i =- 1  : \Window\i.i =- 1  : \Object\i.i = OpenWindow          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i, \Param1\i.i)
      Case "ButtonGadget"        : \Type\i.i = #PB_GadgetType_Button        : \Object\i.i = ButtonGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "StringGadget"        : \Type\i.i = #PB_GadgetType_String        : \Object\i.i = StringGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "TextGadget"          : \Type\i.i = #PB_GadgetType_Text          : \Object\i.i = TextGadget          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "CheckBoxGadget"      : \Type\i.i = #PB_GadgetType_CheckBox      : \Object\i.i = CheckBoxGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "OptionGadget"        : \Type\i.i = #PB_GadgetType_Option        : \Object\i.i = OptionGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s)
      Case "ListViewGadget"      : \Type\i.i = #PB_GadgetType_ListView      : \Object\i.i = ListViewGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "FrameGadget"         : \Type\i.i = #PB_GadgetType_Frame         : \Object\i.i = FrameGadget         (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ComboBoxGadget"      : \Type\i.i = #PB_GadgetType_ComboBox      : \Object\i.i = ComboBoxGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "ImageGadget"         : \Type\i.i = #PB_GadgetType_Image         : \Object\i.i = ImageGadget         (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "HyperLinkGadget"     : \Type\i.i = #PB_GadgetType_HyperLink     : \Object\i.i = HyperLinkGadget     (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "ContainerGadget"     : \Type\i.i = #PB_GadgetType_Container     : \Object\i.i = ContainerGadget     (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "ListIconGadget"      : \Type\i.i = #PB_GadgetType_ListIcon      : \Object\i.i = ListIconGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "IPAddressGadget"     : \Type\i.i = #PB_GadgetType_IPAddress     : \Object\i.i = IPAddressGadget     (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i)
      Case "ProgressBarGadget"   : \Type\i.i = #PB_GadgetType_ProgressBar   : \Object\i.i = ProgressBarGadget   (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "ScrollBarGadget"     : \Type\i.i = #PB_GadgetType_ScrollBar     : \Object\i.i = ScrollBarGadget     (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Param3\i.i, \Flag\i.i)
      Case "ScrollAreaGadget"    : \Type\i.i = #PB_GadgetType_ScrollArea    : \Object\i.i = ScrollAreaGadget    (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Param3\i.i, \Flag\i.i) 
      Case "TrackBarGadget"      : \Type\i.i = #PB_GadgetType_TrackBar      : \Object\i.i = TrackBarGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
        ;       Case "WebGadget"           : \Type\i.i = #PB_GadgetType_Web           : \Object\i.i = WebGadget           (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s)
      Case "ButtonImageGadget"   : \Type\i.i = #PB_GadgetType_ButtonImage   : \Object\i.i = ButtonImageGadget   (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "CalendarGadget"      : \Type\i.i = #PB_GadgetType_Calendar      : \Object\i.i = CalendarGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "DateGadget"          : \Type\i.i = #PB_GadgetType_Date          : \Object\i.i = DateGadget          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "EditorGadget"        : \Type\i.i = #PB_GadgetType_Editor        : \Object\i.i = EditorGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "ExplorerListGadget"  : \Type\i.i = #PB_GadgetType_ExplorerList  : \Object\i.i = ExplorerListGadget  (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ExplorerTreeGadget"  : \Type\i.i = #PB_GadgetType_ExplorerTree  : \Object\i.i = ExplorerTreeGadget  (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ExplorerComboGadget" : \Type\i.i = #PB_GadgetType_ExplorerCombo : \Object\i.i = ExplorerComboGadget (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "SpinGadget"          : \Type\i.i = #PB_GadgetType_Spin          : \Object\i.i = SpinGadget          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "TreeGadget"          : \Type\i.i = #PB_GadgetType_Tree          : \Object\i.i = TreeGadget          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "PanelGadget"         : \Type\i.i = #PB_GadgetType_Panel         : \Object\i.i = PanelGadget         (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i) 
      Case "SplitterGadget"      
        Debug "Splitter FirstGadget "+\Param1\i.i
        Debug "Splitter SecondGadget "+\Param2\i.i
        If IsGadget(\Param1\i.i) And IsGadget(\Param2\i.i)
          \Type\i.i = #PB_GadgetType_Splitter                               
          \Object\i.i = SplitterGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
        Else
          \Type\i.i = #PB_GadgetType_Splitter     
          \Param1\i.i = TextGadget(#PB_Any, 0,0,0,0, "Splitter")
          \Param2\i.i = TextGadget(#PB_Any, 0,0,0,0, "")
          \Object\i.i = SplitterGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
          
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          \Type\i.i = #PB_GadgetType_MDI                                    : \Object\i.i = MDIGadget           (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i) 
        CompilerEndIf
      Case "ScintillaGadget"     : \Type\i.i = #PB_GadgetType_Scintilla     : \Object\i.i = ScintillaGadget     (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i)
      Case "ShortcutGadget"      : \Type\i.i = #PB_GadgetType_Shortcut      : \Object\i.i = ShortcutGadget      (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i)
      Case "CanvasGadget"        : \Type\i.i = #PB_GadgetType_Canvas        : \Object\i.i = CanvasGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
    EndSelect
    
    If \Object\s.s=""
      \Object\s.s=Str(\Object\i.i)
      ParsePBObject()\Object\s.s=\Object\s.s
    EndIf
    
    ; Заносим данные объекта в памят
    If Bool(IsGadget(\Object\i.i) | IsWindow(\Object\i.i))
      ParsePBObject()\Type\i.i = \Type\i.i
      ParsePBObject()\Object\i.i = \Object\i.i
      
      If ParsePBObject()\Parent\i.i<>\Parent\i.i
        If \get(Str(\Parent\i.i))\Object\s.s
          \Parent\s.s = \get(Str(\Parent\i.i))\Object\s.s
        EndIf
        ParsePBObject()\Parent\i.i=\Parent\i.i
        ParsePBObject()\Parent\s.s=\Parent\s.s
      EndIf
      If ParsePBObject()\Window\i.i<>\Window\i.i
        If \get(Str(\Window\i.i))\Object\s.s
          \Window\s.s = \get(Str(\Window\i.i))\Object\s.s
        EndIf
        ParsePBObject()\Window\i.i=\Window\i.i
        ParsePBObject()\Window\s.s=\Window\s.s
      EndIf
      
      ; TODO -----------------------------------------
      If IsWindow(\Object\i.i)
        \Parent\i.i =- 1
      EndIf
      
      Macro Init_object_data(_object_, _object_key_)
        If FindMapElement(*This\get(), _object_key_)
          *This\get(_object_key_)\Index=ListIndex(ParsePBObject())
          *This\get(_object_key_)\Adress=@ParsePBObject()
          
          *This\get(_object_key_)\Object\i.i=_object_ 
          *This\get(_object_key_)\Object\s.s=*This\Object\s.s 
          
          *This\get(_object_key_)\Type\i.i=*This\Type\i.i 
          *This\get(_object_key_)\Type\s.s=*This\Type\s.s 
          
          *This\get(_object_key_)\Window\i.i=*This\Window\i.i 
          *This\get(_object_key_)\Parent\i.i=*This\Parent\i.i 
          
          *This\get(_object_key_)\Window\s.s=*This\Window\s.s 
          *This\get(_object_key_)\Parent\s.s=*This\Parent\s.s 
        Else
          AddMapElement(*This\get(), _object_key_)
          *This\get()\Index=ListIndex(ParsePBObject())
          *This\get()\Adress=@ParsePBObject()
          
          *This\get()\Object\i.i=_object_ 
          *This\get()\Object\s.s=*This\Object\s.s 
          
          *This\get()\Type\i.i=*This\Type\i.i 
          *This\get()\Type\s.s=*This\Type\s.s 
          
          *This\get()\Window\i.i=*This\Window\i.i 
          *This\get()\Parent\i.i=*This\Parent\i.i 
          
          *This\get()\Window\s.s=*This\Window\s.s 
          *This\get()\Parent\s.s=*This\Parent\s.s 
        EndIf
        
      EndMacro
      
      ; Количество однотипных объектов
      If Not FindMapElement(\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
        AddMapElement(\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
        \get()\Index=ListIndex(ParsePBObject())
        \get()\Adress=@ParsePBObject()
        \get()\Count+1 
      Else
        \get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count+1 
      EndIf
      
      ; Чтобы по идентификатору 
      ; объекта получить все остальное
      Init_object_data(\Object\i.i, Str(\Object\i.i))
      
      ; Чтобы по классу
      ; объекта получить все остальное
      Init_object_data(\Object\i.i, \Object\s.s)
      
    EndIf
    
    ; 
    Select \Type\s.s
      Case "OpenWindow" : \Window\i.i = \Object\i.i : \Parent\i.i = \Object\i.i : \Container = \Type\i.i : \SubLevel = 1
      Case "ContainerGadget", "ScrollAreaGadget" : \Parent\i.i = \Object\i.i : \Container = \Type\i.i : \SubLevel + 1
      Case "PanelGadget" : \Parent\i.i = \Object\i.i : \Container = \Type\i.i : \SubLevel + 1 
        If IsGadget(\Parent\i.i) 
          \Item = GetGadgetData(\Parent\i.i) 
        EndIf
        
      Case "CanvasGadget"
        If ((\Flag\i.i & #PB_Canvas_Container)=#PB_Canvas_Container)
          \Parent\i.i = \Object\i.i : \SubLevel + 1
          \Container = \Type\i.i
        EndIf
        
      Case "UseGadgetList" 
        If IsWindow(\Param1\i.i) : \SubLevel = 1
          \Window\i.i = \Param1\i.i
          \Parent\i.i = \Window\i.i
          UseGadgetList( WindowID(\Param1\i.i) )
        EndIf
        
      Case "CloseGadgetList" 
        If IsGadget(\Parent\i.i) : \SubLevel - 1 : CloseGadgetList() 
          \Parent\i.i = *This\get(Str(\Parent\i.i))\Parent\i.i 
          If IsGadget(\Parent\i.i) : \Item = GetGadgetData(\Parent\i.i) : EndIf
        EndIf
        
      Case "OpenGadgetList"      
        \Parent\i.i = \get(\Object\s.s)\Object\i.i
        If IsGadget(\Parent\i.i) : OpenGadgetList(\Parent\i.i, \Param1\i.i) : EndIf
        
      Case "AddGadgetColumn"       
        Object=\get(\Object\s.s)\Object\i.i
        If IsGadget(Object)
          AddGadgetColumn(Object, \Param1\i.i, \Caption\s.s, \Param2\i.i)
        Else
          Debug " add column no_gadget "+\Object\s.s
        EndIf
        
      Case "AddGadgetItem"   
        Object=\get(\Object\s.s)\Object\i.i
        If IsGadget(Object) : \Item+1 : SetGadgetData(Object, \Item)
          AddGadgetItem(Object, \Param1\i.i, \Caption\s.s, \Param2\i.i, \Flag\i.i)
        Else
          Debug " add item no_gadget "+\Object\s.s
        EndIf
        
      Default
        \Container = #PB_GadgetType_Unknown
        
    EndSelect
    
    ;
    If IsGadget(\Parent\i.i)
      GetParent = \get(Str(\Parent\i.i))\Parent\i.i
    ElseIf IsWindow(\Parent\i.i)
      \SubLevel = 1
    EndIf
    
    ;
    If IsGadget(\Object\i.i)
      ; Если объект контейнер, то есть (Panel;ScrollArea;Container;Canvas)
      If \Container
        ParsePBObject()\Container = \Container
        ParsePBObject()\SubLevel = \SubLevel - 1
        EnableGadgetDrop(\Object\i.i, #PB_Drop_Text, #PB_Drag_Copy)
        BindEvent(#PB_Event_GadgetDrop, @CO_Events(), ParsePBObject()\Window\i.i, \Object\i.i)
      Else
        ParsePBObject()\SubLevel = \SubLevel
      EndIf
      
      ; Итем родителя для создания в нем гаджетов
      If \Item : ParsePBObject()\Item=\Item-1 : EndIf
      
      ; Открываем гаджет лист на том родителе где создан данный объект.
      If \Object\i.i = \Parent\i.i
        If IsWindow(GetParent) : CloseGadgetList() : UseGadgetList(WindowID(GetParent)) : EndIf
        If IsGadget(GetParent) : OpenGadgetList = OpenGadgetList(GetParent, ParsePBObject()\Item) : EndIf
      EndIf
      
      ;       Transformation::Create(ParsePBObject()\Object\i.i, ParsePBObject()\Window\i.i, ParsePBObject()\Parent\i.i, ParsePBObject()\Item, 5)
      ;        Transformation::Create(ParsePBObject()\Object\i.i, ParsePBObject()\Parent\i.i, -1, 0, 5)
      ;       ButtonGadget(-1,0,0,160,20,Str(Random(5))+" "+\Parent\s.s+"-"+Str(\Parent\i.i))
      ;       CallFunctionFast(@CO_Events())
      
      ; Посылаем сообщение, что создали гаджет.
      PostEvent(#PB_Event_Create,
                ParsePBObject()\Window\i.i,
                ParsePBObject()\Object\i.i, #PB_All,
                ParsePBObject()\Parent\i.i)
      
      ; Закрываем ранее открытий гаджет лист.
      If \Object\i.i = \Parent\i.i
        If IsWindow(GetParent) : OpenGadgetList(\Parent\i.i) : EndIf
        If OpenGadgetList : CloseGadgetList() : EndIf
      EndIf
    EndIf
    
    ;
    If IsWindow(\Object\i.i)
      StickyWindow(\Object\i.i, #True)
      ParsePBObject()\Container = \Container
      ;       Transformation::Create(ParsePBObject()\Object\i.i, ParsePBObject()\Window\i.i, ParsePBObject()\Parent\i.i, ParsePBObject()\Item, 5)
      PostEvent(#PB_Event_Create, \Object\i.i, #PB_Ignore)
      EnableWindowDrop(\Object\i.i, #PB_Drop_Text, #PB_Drag_Copy)
      
      BindEvent(#PB_Event_Create, @CO_Events(), \Object\i.i)
      BindEvent(#PB_Event_Gadget, @CO_Events(), \Object\i.i)
      BindEvent(#PB_Event_WindowDrop, @CO_Events(), \Object\i.i)
    EndIf
    
    ProcedureReturn \Object\i.i
  EndWith
EndProcedure

Procedure CO_Save(*ThisParse.ParseStruct) ; Ok
  Protected Result$, ID$, Handle$, Result, i
  
  With *ThisParse
    If \Content\String$
      Debug "      "+\Content\String$
      
      For i=2 To 5
        Result$ = Trim(Trim(StringField(\Content\String$, i, ","), ")"))
        ; Debug "Coordinate: "+Result$
        
        Select Asc(Result$)
          Case 'A' To 'Z' , 'a' To 'z'
            
            Select i 
              Case 2 : \X\s.s = Result$
              Case 3 : \Y\s.s = Result$
              Case 4 : \Width\s.s = Result$
              Case 5 : \Height\s.s = Result$
            EndSelect
        EndSelect
      Next
      
      If Asc(\Object\s.s) = 35 ; '#'
        ID$ = \Object\s.s
      Else
        Handle$ = \Object\s.s+" = "
        ID$ = "#PB_Any"
      EndIf
      
      Select \Type\s.s
          Case "OpenWindow"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ButtonGadget"        : \Content\String$ = Handle$+"ButtonGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                 : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "StringGadget"        : \Content\String$ = Handle$+"StringGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                 : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "TextGadget"          : \Content\String$ = Handle$+"TextGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "CheckBoxGadget"      : \Content\String$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                               : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "OptionGadget"        : \Content\String$ = Handle$+"OptionGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)
          Case "ListViewGadget"      : \Content\String$ = Handle$+"ListViewGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                        : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "FrameGadget"         : \Content\String$ = Handle$+"FrameGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                  : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ComboBoxGadget"      : \Content\String$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                        : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ImageGadget"         : \Content\String$ = Handle$+"ImageGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s                                                                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "HyperLinkGadget"     : \Content\String$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)+", "+\Param1\s.s                                                       : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ContainerGadget"     : \Content\String$ = Handle$+"ContainerGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                       : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ListIconGadget"      : \Content\String$ = Handle$+"ListIconGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)+", "+\Param1\s.s                                                        : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "IPAddressGadget"     : \Content\String$ = Handle$+"IPAddressGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s
          Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                                      : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s+", "+\Param3\s.s                                                 : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ScrollAreaGadget"    : \Content\String$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s    : If \Param3\s.s : \Content\String$ +", "+\Param3\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf 
          Case "TrackBarGadget"      : \Content\String$ = Handle$+"TrackBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                                         : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "WebGadget"           : \Content\String$ = Handle$+"WebGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)
          Case "ButtonImageGadget"   : \Content\String$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s                                                                                             : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "CalendarGadget"      : \Content\String$ = Handle$+"CalendarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                     : If \Param1\s.s : \Content\String$ +", "+\Param1\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "DateGadget"          : \Content\String$ = Handle$+"DateGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                : If \Param1\s.s : \Content\String$ +", "+\Param1\s.s : EndIf : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "EditorGadget"        : \Content\String$ = Handle$+"EditorGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                          : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ExplorerListGadget"  : \Content\String$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                           : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ExplorerTreeGadget"  : \Content\String$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                           : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "ExplorerComboGadget" : \Content\String$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                          : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "SpinGadget"          : \Content\String$ = Handle$+"SpinGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                                             : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "TreeGadget"          : \Content\String$ = Handle$+"TreeGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                            : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "PanelGadget"         : \Content\String$ = Handle$+"PanelGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s 
          Case "SplitterGadget"      : \Content\String$ = Handle$+"SplitterGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                                         : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
          Case "MDIGadget"           : \Content\String$ = Handle$+"MDIGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                                                                              : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf 
        Case "ScintillaGadget"     : \Content\String$ = Handle$+"ScintillaGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s
        Case "ShortcutGadget"      : \Content\String$ = Handle$+"ShortcutGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s
          Case "CanvasGadget"        : \Content\String$ = Handle$+"CanvasGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s                                                                                                                          : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
      EndSelect
      
      \Content\String$+")" 
      Result = Len(\Content\String$)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure ParsePBFile(FileName.s)
  Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
    Protected Line, FindWindow, Text$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected Length = Lof(#File) 
    Protected *File = AllocateMemory(Length)
    
    
    If *File 
      ReadData(#File, *File, Length)
      *This\Content\Text$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
; CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
      If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|\\d|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:(\\w+)\\s*\\((\".*?\"|[^:]|.*?)\\))|(?:(\\w+)(|\\.\\w))\\s)", #PB_RegularExpression_Extended | Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
         CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
        
        
        If ExamineRegularExpression(#RegEx_Function, *This\Content\Text$)
          While NextRegularExpressionMatch(#RegEx_Function)
            With *This
              
              If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                \Type\s.s=RegularExpressionGroup(#RegEx_Function, 7)
                \Args$=Trim(RegularExpressionGroup(#RegEx_Function, 8))
                
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \Object\s.s = RegularExpressionGroup(#RegEx_Function, 3)
                EndIf
                
                ; Если идентификатрор сгенерирован с #PB_Any то есть (Ident=PBFunction(#PB_Any))
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \Object\s.s = RegularExpressionGroup(#RegEx_Function, 3)
                  \Content\String$ = RegularExpressionMatchString(#RegEx_Function)
                  \Content\Length = RegularExpressionMatchLength(#RegEx_Function)
                  \Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                EndIf
                
                If \Type\s.s
                  ; Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                  
                  Select \Type\s.s
                    Case "OpenWindow", 
                         "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                         "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                         "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                         "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                         "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                         "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                         "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                         "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                      
                      AddElement(ParsePBObject()) 
                      ParsePBObject()\Type\s.s = \Type\s.s
                      ParsePBObject()\Content\String$ = \Content\String$ + RegularExpressionMatchString(#RegEx_Function)
                      ParsePBObject()\Content\Length = \Content\Length + RegularExpressionMatchLength(#RegEx_Function)
                      If \Content\Position
                        ParsePBObject()\Content\Position = \Content\Position
                      Else
                        ParsePBObject()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                      EndIf
                      
                      ; Границы для добавления объектов
                      \Content\Position=ParsePBObject()\Content\Position
                      \Content\Length=ParsePBObject()\Content\Length
                      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            If (Index>5)
                              Select \Type\s.s
                                Case "OpenGLGadget","EditorGadget","CanvasGadget",
                                     "ComboBoxGadget","ContainerGadget","ListViewGadget","TreeGadget"
                                  If Index=6 : Index+4 : EndIf
                                  
                                Case "ScrollBarGadget","ScrollAreaGadget","ScintillaGadget"
                                  If Index=6 : Index+1 : EndIf
                                  
                                Case "SplitterGadget"
                                  ;Debug Str(Index)+" "+Arg$
                                  Select Index 
                                    Case 6,9 : Index+1
                                  EndSelect
                                  
                                Case "TrackBarGadget","SpinGadget","ProgressBarGadget" ; TODO ?
                                  Select Index 
                                    Case 6,8 : Index+1
                                  EndSelect
                                  
                                Case "CalendarGadget","ButtonImageGadget","ImageGadget"
                                  Select Index 
                                    Case 6 : Index+1
                                    Case 7 : Index+2
                                  EndSelect
                                  
                                Case "OpenWindow"
                                  If Index=7 : Index+3 : EndIf
                                  If Index=11 : Index-4: EndIf ; param1=OwnerID
                                  
                                Case "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget","FrameGadget",
                                     "ExplorerListGadget","ExplorerTreeGadget","ExplorerComboGadget"
                                  If Index=7 : Index+3 : EndIf
                                  
                                Case "HyperLinkGadget","DateGadget","ListIconGadget"
                                  If Index=8 : Index+2 : EndIf
                                  
                              EndSelect
                            EndIf
                            
                            Select Index
                              Case 1
                                If Bool(Arg$<>"#PB_Any" And Arg$<>"#PB_All" And Arg$<>"#PB_Default" And Asc(Arg$)<>'-')
                                  ; Если идентификаторы окон цыфри
                                  Select Asc(Arg$)
                                    Case '0' To '9'
                                      If \Type\s.s="OpenWindow"
                                        \Object\s.s = Arg$+"_Window"
                                      Else
                                        \Object\s.s = Arg$+"_"+ReplaceString(\Type\s.s, "Gadget","")
                                      EndIf
                                    Default
                                      \Object\s.s = Arg$
                                  EndSelect
                                EndIf
                                
                                \Class\s.s = \Object\s.s 
                                ParsePBObject()\Class\s.s = \Class\s.s
                                ParsePBObject()\Object\s.s = \Object\s.s
                                
                              Case 2 : ParsePBObject()\X\s.s = Arg$
                                MacroCoordinate(\X\i.i, Arg$)
                                
                              Case 3 : ParsePBObject()\Y\s.s = Arg$
                                MacroCoordinate(\Y\i.i, Arg$)
                                
                              Case 4 : ParsePBObject()\Width\s.s = Arg$
                                MacroCoordinate(\Width\i.i, Arg$)
                                
                              Case 5 : ParsePBObject()\Height\s.s = Arg$
                                MacroCoordinate(\Height\i.i, Arg$)
                                
                              Case 6 : ParsePBObject()\Caption\s.s = Arg$
                                \Caption\s.s = GetStr(Arg$) 
                                
                              Case 7 : ParsePBObject()\Param1\s.s = Arg$
                                Select \Type\s.s 
                                  Case "OpenWindow"      
                                    \Param1\s.s = get_argument_string(Arg$)
                                    
                                    ; Если идентификаторы окон цыфри
                                    If Val(\Param1\s.s)
                                      \Param1\s.s+"_Window"
                                    Else
                                      \Param1\s.s = Arg$
                                    EndIf
                                    
                                    \Param1\i.i = *This\get(\Param1\s.s)\Object\i.i
                                    
                                    If \Param1\i.i
                                      \Param1\i.i = WindowID(\Param1\i.i)
                                    EndIf
                                    
                                  Case "SplitterGadget"      
                                    \Param1\i.i = *This\get(Arg$)\Object\i.i
                                    
                                  Case "ImageGadget"      
                                    Result = \Img(GetStr(Arg$))\Object\i.i 
                                    If IsImage(Result)
                                      \Param1\i.i = ImageID(Result)
                                    EndIf
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param1\i.i = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 8 : ParsePBObject()\Param2\s.s = Arg$
                                Select \Type\s.s 
                                  Case "SplitterGadget"      
                                    \Param2\i.i = *This\get(Arg$)\Object\i.i
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param2\i.i = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 9 : ParsePBObject()\Param3\s.s = Arg$
                                \Param3\i.i = Val(Arg$)
                                
                              Case 10 
                                ;                                 Select Asc(Arg$)
                                ;                                   Case '0' To '9'
                                ;                                     \Flag\i.i = Val(Arg$)
                                ;                                   Default
                                ;                                     \Flag\i.i = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                ;                                     If \Flag\i.i = 0
                                ;                                       Arg$ = GetVarValue(Arg$)
                                ;                                       \Flag\i.i = Val(Arg$)
                                ;                                     EndIf
                                ;                                     If \Flag\i.i = 0
                                ;                                       \Flag\i.i = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                ;                                     EndIf
                                ;                                 EndSelect
                                \Flag\i.i = Flag(Arg$)
                                ParsePBObject()\Flag\s.s = Arg$
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      ; Сначала определять кто есть кто.
                      Select *This\Type\s.s
                        Case "OpenWindow" 
                          *This\Container =- 1 
                          *This\Window\s.s = *This\Object\s.s 
                          *This\Parent\s.s = *This\Object\s.s
                        Case "PanelGadget" : *This\Container = #PB_GadgetType_Panel
                          *This\Parent\s.s = *This\Object\s.s
                        Case "ContainerGadget" : *This\Container = #PB_GadgetType_Container
                          *This\Parent\s.s = *This\Object\s.s
                        Case "ScrollAreaGadget" : *This\Container = #PB_GadgetType_ScrollArea
                          *This\Parent\s.s = *This\Object\s.s
                        Case "CanvasGadget"
                          If ((*This\Flag\i.i&#PB_Canvas_Container)=#PB_Canvas_Container)
                            *This\Container = #PB_GadgetType_Canvas
                            *This\Parent\s.s = *This\Object\s.s
                          EndIf
                        Default
                          *This\Container = #PB_GadgetType_Unknown
                      EndSelect
                      
                      ; ;                       ; Первый вариант
                      ; ;                       ; Ищем Declare и затем отходим на 4 шага (на две концы сторки)
                      ; ;                       Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+"Declare"+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
                      ; ;                       
                      ; ;                       If RegExID
                      ; ; ;                      ; Получаем позицию идентификаторов в файле
                      ; ;                         If ExamineRegularExpression(RegExID, *This\Content\Text$)
                      ; ;                           While NextRegularExpressionMatch(RegExID)
                      ; ;                            *This\get(*This\Window\s.s)\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID)-Len(#CRLF$)*2 ;*This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
                      ; ;                             Break
                      ; ;                           Wend
                      ; ;                         EndIf
                      ; ;                         
                      ; ;                         FreeRegularExpression(RegExID)
                      ; ;                       EndIf
                      
                      ; Второй вариант
                      ; Ищем идентификатор и затем добавлаем его длину
                      Protected Identific$ = *This\Object\s.s+"=-1"
                      Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Identific$+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
                      
                      If RegExID
                        ;                      ; Получаем позицию идентификаторов в файле
                        If ExamineRegularExpression(RegExID, *This\Content\Text$)
                          While NextRegularExpressionMatch(RegExID)
                            *This\get(*This\Window\s.s)\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID)+Len(Identific$)
                            Break
                          Wend
                        EndIf
                        
                        FreeRegularExpression(RegExID)
                      EndIf
                      Debug *This\get(*This\Window\s.s)\Code("Code_Object")\Position
                      
                      ; Запоминаем последнюю позицию
                      *This\get(*This\Object\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      If *This\Container
                        Select *This\Type\s.s
                          Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
                            *This\get(*This\Window\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
                        EndSelect
                      Else
                        *This\get(*This\Window\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      EndIf
                      
                      ; ; ;                       ; Записываем у родителя позицию конца добавления объекта
                      ; ; ;                      ; *This\get(*This\get(Str(*This\Parent\i.i))\Object\s.s)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      ; ; ;                       Debug "Load Code_Object"+ *This\get(Str(*This\Window\i.i))\Object\s.s +" "+ *This\get(*This\get(Str(*This\Window\i.i))\Object\s.s)\Code("Code_Object")\Position
                      ; ; ;                       Debug "w Code_Function"+ *This\Window\s.s +" "+ *This\get(*This\Window\s.s)\Code("Code_Function")\Position
                      ; ; ;                       Debug "Load Code_Function"+ *This\get(Str(*This\Parent\i.i))\Object\s.s +" "+ *This\get(*This\get(Str(*This\Parent\i.i))\Object\s.s)\Code("Code_Function")\Position
                      ; ; ;                       ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Window\s.s)\Code("Code_Object")\Position
                      ; ; ;                       ;     Debug "    Code_Function"+ *This\get(*This\get(Replace$)\Parent\s.s)\Code("Code_Function")\Position
                      
                      
                      
                      
                      
                      Protected win = CallFunctionFast(@CO_Open())
                      
                      
                      \Object\i.i=-1
                      \Object\s.s=""
                      \Param1\i.i = 0
                      \Param2\i.i = 0
                      \Param3\i.i = 0
                      \Caption\s.s = ""
                      \Flag\i.i = 0
                      
                    Case "UseGadgetList"
                      \Param1\s.s = get_argument_string(\Args$)
                      
                      ; Если идентификаторы окон цыфри
                      If Val(\Param1\s.s)
                        \Param1\s.s+"_Window"
                      Else
                        \Param1\s.s = \Args$
                      EndIf
                      
                      \Param1\i.i = *This\get(\Param1\s.s)\Object\i.i
                      
                      If \Param1\i.i
                        ;                         *This\get(\Object\s.s)\Object\i.i = *This\get(Str(\Param1\i.i))\Window\i.i
                        Protected UseGadgetList = UseGadgetList(WindowID(\Param1\i.i))
                        PushListPosition(ParsePBObject())
                        ForEach ParsePBObject()
                          If ParsePBObject()\Type\s.s = "OpenWindow"
                            If IsWindow(ParsePBObject()\Object\i.i) And 
                               WindowID(ParsePBObject()\Object\i.i) = UseGadgetList
                              *This\get(\Object\s.s)\Object\i.i = ParsePBObject()\Object\i.i
                            EndIf
                          EndIf
                        Next
                        PopListPosition(ParsePBObject())
                        UseGadgetList(UseGadgetList)
                      Else
                        \Param1\i.i = *This\get(\Param1\s.s)\Object\i.i
                      EndIf
                      
                      CallFunctionFast(@CO_Open())
                      
                    Case "CloseGadgetList"      : CallFunctionFast(@CO_Open()) ; ; TODO
                      
                    Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            Select Index
                              Case 1 
                                \Object\s.s = Arg$
                                If Val(Arg$)
                                  PushListPosition(ParsePBObject())
                                  ForEach ParsePBObject()
                                    If Val(ParsePBObject()\Object\s.s) = Val(Arg$)
                                      \Object\s.s = ParsePBObject()\Object\s.s
                                    EndIf
                                  Next
                                  PopListPosition(ParsePBObject())
                                EndIf
                                
                                ;*This\get(Str(\Parent\i.i))\Object\s.s
                                ;                                 \Object\s.s = *This\get(Str(\Parent\i.i))\Object\s.s
                                
                                
                              Case 2 : \Param1\i.i = Val(Arg$)  
                              Case 3 : \Caption\s.s=GetStr(Arg$)
                              Case 4 : \Param2\i.i = Val(Arg$)
                              Case 5 : \Flag\s.s = Arg$
                                \Flag\i.i = Flag(Arg$)
                                
                            EndSelect
                          EndIf
                        Wend
                      EndIf
                      
                      ;Debug " g "+\Object\s.s +" "+ Str(*This\get(\Object\s.s)\Object\i.i)
                      CallFunctionFast(@CO_Open())
                      
                      
                      \Object\i.i =- 1
                      \Object\s.s = ""
                      \Flag\i.i = 0
                      \Param1\i.i = 0
                      \Param2\i.i = 0
                      \Param3\i.i = 0
                      \Flag\s.s = ""
                      \Param1\s.s = ""
                      \Param2\s.s = ""
                      \Param3\s.s = ""
                      \Caption\s.s = ""
                      ;ClearStructure(*This, ParseStruct)
                      ;                         FreeStructure(*This)
                      ;                         *This.ParseStruct = AllocateStructure(ParseStruct)
                      
                    Default
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Args$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Args$
                            \Args$ = Args$ 
                            Index+1
                            CF_Add(*This, Index)
                          EndIf
                        Wend
                        
                        CF_Set(*This)
                      EndIf
                      
                  EndSelect
                  
                EndIf
              EndIf
            EndWith
          Wend
          
        Else
          Debug "Nothing to extract from: " + *This\Content\Text$
          ProcedureReturn 
        EndIf
        
        
        If IsRegularExpression(#RegEx_Arguments1)
          FreeRegularExpression(#RegEx_Arguments1)
        EndIf
        If IsRegularExpression(#RegEx_Captions1)
          FreeRegularExpression(#RegEx_Captions1)
        EndIf
        
        FreeRegularExpression(#RegEx_Function)
        FreeRegularExpression(#RegEx_Arguments)
        FreeRegularExpression(#RegEx_Captions)
      Else
        Debug "Error creating #RegEx"
        End
      EndIf
    EndIf
    
    CloseFile(#File)
    Result = #True
    
    
  EndIf
  
  ProcedureReturn Result
EndProcedure



;-
Procedure LoadControls()
  UsePNGImageDecoder()
  
  Protected ZipFile.i, GadgetName.s, GadgetImageSize.i, *GadgetImage, GadgetImage, GadgetCtrlCount.l
  Define ZipFileTheme.s = GetCurrentDirectory()+"SilkTheme.zip"
  
  If FileSize(ZipFileTheme) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFileTheme = #PB_Compiler_Home+"themes\SilkTheme.zip"
    CompilerElse
      ZipFileTheme = #PB_Compiler_Home+"themes/SilkTheme.zip"
    CompilerEndIf
    If FileSize(ZipFileTheme) < 1
      MessageRequester("Designer Error", "SilkTheme.zip Not found in the Content directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  
  CompilerIf #PB_Compiler_Version > 522
    UseZipPacker()
  CompilerEndIf
  
  ZipFile = OpenPack(#PB_Any, ZipFileTheme, #PB_PackerPlugin_Zip)
  If ZipFile
    If ExaminePack(ZipFile)
      While NextPackEntry(ZipFile)
        
        GadgetName = PackEntryName(ZipFile)
        GadgetName = ReplaceString(GadgetName,"chart_bar","vd_tabbargadget")   ;use chart_bar png for TabBarGadget
        GadgetName = ReplaceString(GadgetName,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
        GadgetName = ReplaceString(GadgetName,"frame3dgadget","framegadget")            ;vd_framegadget.png not found. Use vd_frame3dgadget.png instead
        
        If FindString(Left(GadgetName, 3), "vd_")
          GadgetImageSize = PackEntrySize(ZipFile)
          *GadgetImage = AllocateMemory(GadgetImageSize)
          UncompressPackMemory(ZipFile, *GadgetImage, GadgetImageSize)
          GadgetImage = CatchImage(#PB_Any, *GadgetImage, GadgetImageSize)
          GadgetName = LCase(GadgetName)
          GadgetName = ReplaceString(GadgetName,".png","")
          GadgetName = ReplaceString(GadgetName,"vd_","")
          
          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              If GadgetImage
                Select GadgetName
                  Case "buttongadget",
                       "stringgadget",
                       "textgadget",
                       "checkboxgadget",
                       "optiongadget",
                       "listviewgadget",
                       "framegadget",
                       "comboboxgadget",
                       "imagegadget",
                       "hyperlinkgadget",
                       "containergadget",
                       "listicongadget",
                       "ipaddressgadget",
                       "progressbargadget",
                       "scrollbargadget",
                       "scrollareagadget",
                       "trackbargadget",
                       ;                        "webgadget",
                    "buttonimagegadget",
"calendargadget",
"dategadget",
"editorgadget",
"explorerlistgadget",
"explorertreegadget",
"explorercombogadget",
"spingadget",
"treegadget",
"panelgadget",
"splittergadget",
"mdigadget",
"scintillagadget",
"shortcutgadget",
"canvasgadget",
"gadget"
                    
                    
                    GadgetName=ULCase(ReplaceString(GadgetName, "gadget",""))
                    
                    GadgetName = ReplaceString(GadgetName, "box","Box")
                    GadgetName = ReplaceString(GadgetName, "link","Link")
                    GadgetName = ReplaceString(GadgetName, "bar","Bar")
                    GadgetName = ReplaceString(GadgetName, "area","Area")
                    GadgetName = ReplaceString(GadgetName, "Ipa","IPA")
                    
                    GadgetName = ReplaceString(GadgetName, "view","View")
                    GadgetName = ReplaceString(GadgetName, "icon","Icon")
                    GadgetName = ReplaceString(GadgetName, "image","Image")
                    GadgetName = ReplaceString(GadgetName, "combo","Combo")
                    GadgetName = ReplaceString(GadgetName, "list","List")
                    GadgetName = ReplaceString(GadgetName, "tree","Tree")
                    
                    AddGadgetItem(WE_Tree_1, -1, GadgetName, ImageID(GadgetImage))
                    SetGadgetItemData(WE_Tree_1, CountGadgetItems(WE_Tree_1)-1, GadgetImage)
                EndSelect
                
                
              EndIf
          EndSelect
          
          FreeMemory(*GadgetImage)
        EndIf
      Wend
    EndIf
    ClosePack(ZipFile)
  EndIf
EndProcedure

;-
;- PI Редактора
Procedure WE_Tree_0_Position(Gadget, Parent)
  Protected i, Position=-1 ; 
  Position = CountGadgetItems(Gadget)
  
  ; Определяем позицию в списке
  If IsGadget(Parent) 
    For i=0 To CountGadgetItems(Gadget)-1
      If Parent=GetGadgetItemData(Gadget, i) 
        *This\SubLevel=GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)+1
        Position=(i+1)
        Break
      EndIf
    Next 
    For i=Position To CountGadgetItems(Gadget)-1
      If *This\SubLevel=<GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)
        Position+1
      EndIf
    Next 
  ElseIf IsWindow(Parent)
    Position = CountGadgetItems(Gadget)
    *This\SubLevel = 1
  EndIf
  
  ProcedureReturn Position
EndProcedure

Procedure WE_Tree_0_Update(Gadget, Position=-1)
  Protected i, Img, ImageID 
  img = GetGadgetItemData(WE_Tree_1, GetGadgetState(WE_Tree_1))
  Protected img_form = CatchImage(#PB_Any, ?form_png, ?form_png_end-?form_png)
  
  If IsImage(Img)
    ImageID = ImageID(Img)
  EndIf
  
  If ImageID = 0
    ImageID = ImageID(img_form)
  EndIf
  
  Macro generate_image(_class_)
    For I=0 To CountGadgetItems(WE_Tree_1)-1
      If _class_ = GetGadgetItemText(WE_Tree_1, I)+"Gadget"
        ImageID = ImageID(GetGadgetItemData(WE_Tree_1, I))
        Break
      EndIf
    Next  
  EndMacro
  
  ; Добавляем объекты к списку
  If Position=-1
    ClearGadgetItems(Gadget)
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      Position = CountGadgetItems(Gadget)
      generate_image(ParsePBObject()\Type\s.s)
      AddGadgetItem (Gadget, -1, ParsePBObject()\Object\s.s, ImageID, ParsePBObject()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\i.i)
    Next
    PopListPosition(ParsePBObject())
  Else
    AddGadgetItem(Gadget, Position, ParsePBObject()\Object\s.s, ImageID, ParsePBObject()\SubLevel)
    SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\i.i)
  EndIf
  
  ; Раскрываем весь список
  For i=0 To Position 
    If GetGadgetItemState(Gadget, i) & #PB_Tree_Collapsed
      SetGadgetItemState(Gadget, i, #PB_Tree_Expanded)
    EndIf
  Next 
  
  ; Выбыраем последный объект списка
  SetGadgetState(Gadget, Position) ; Bug
  SetGadgetItemState(Gadget, Position, #PB_Tree_Selected)
  
  
  DataSection ; form
    form_png:
    ;   Size : 438 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$4144497D01000061
    Data.q $024B4F93A55E7854,$8E8410B157871841,$27D0839FD0EC45F5,$51468E82222A2290,$074BA221D0449162
    Data.q $444460454444BA51,$604BA22ADD104110,$DDB092D0C2DD0458,$61DF7D9A6671DD1D,$BFB0F2ECBE6D3AC2
    Data.q $1084FAFB037E1F65,$BD6364CE8BE33346,$71702116D95AF091,$C18524CE3379086E,$7C9900524C667C85
    Data.q $FE75FE7CAD4AD6D7,$5384F70813307D68,$40A9E823BF90C12D,$A9B013324A59B2C8,$BF227573D365DBF0
    Data.q $1529DC2CF7B92083,$2C6185C2F56271BD,$A92075A358413EEC,$022F8FC038856051,$1C02A14BE02C942C
    Data.q $766D479D8257395F,$590498941DB128EA,$C60DD127E2C0AB36,$6100FDB73050CF96,$ACC8D5122894319D
    Data.q $D1B282BDF21646AA,$01BA72B6241453A5,$B1F4B23555668945,$BE20A09E2C8CEE90,$28906CD7380D8F79
    Data.q $A31E4A1A34368712,$2D4860374EE37A60,$206772354B1F7E71,$7F862DF4A9828871,$C7F4929AC5328D25
    Data.q $7FD7F9BA9930500F,$503D0E816ACD9D10,$5BDCABCBFDE97C0B,$5CC1B8C30BBB8BA0,$62EE44B0814A4972
    Data.q $D7D197933258B531,$BD37748E1B1D7ED9,$3AF9E3AA9C7BDFCE,$4549000000008891
    Data.b $4E,$44,$AE,$42,$60,$82
    form_png_end:
  EndDataSection
  
EndProcedure 

Procedure WE_Tree_0_Replace(Gadget)
  Protected Object, i,Find$ = GetGadgetText(Gadget)
  Protected Replace$ = GetGadgetText(EventGadget())
  Protected RegExID, ParentClass$, len
  
  Macro replace_map_key(_find_mapkey, _replace_mapkey)
    ; Меняем map ключ объекта
    CopyStructure(*This\get(_find_mapkey), *This\get(_replace_mapkey), ObjectStruct)
    ; И удаляем старый
    DeleteMapElement(*This\get(), _find_mapkey)
  EndMacro
  
  ; 
  If Replace$ And Find$ <> Replace$
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      If ParsePBObject()\Object\s.s = Find$
        ; Включаем и имя родителя при формировании имени объекта
        If *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s And 
           Not FindString(Replace$, *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s)
          Replace$ = *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s+"_"+Replace$
          SetGadgetText(EventGadget(), Replace$)
        EndIf
        
        ;
        If Find$=*This\get(Find$)\Window\s.s
          *This\get(Find$)\Window\s.s=Replace$
        EndIf
        If Find$=*This\get(Find$)\Parent\s.s
          *This\get(Find$)\Parent\s.s=Replace$
        EndIf
        
        *This\get(ParsePBObject()\Object\s.s)\Object\s.s = Replace$
        *This\get(Str(ParsePBObject()\Object\i.i))\Object\s.s = Replace$
        
        ParsePBObject()\Class\s.s = ReplaceString(Replace$, *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s+"_", "")
        
        ; Меняем map ключ объекта
        CopyStructure(*This\get(ParsePBObject()\Object\s.s), *This\get(Replace$), ObjectStruct)
        ; И удаляем старый
        DeleteMapElement(*This\get(), ParsePBObject()\Object\s.s)
        
        ParsePBObject()\Object\s.s = Replace$ 
        
        ; По умалчанию 
        If ParsePBObject()\Container
          If ParsePBObject()\Container =- 1
            *This\Window\s.s = ParsePBObject()\Object\s.s 
          EndIf
          *This\Container = ParsePBObject()\Container
          *This\Parent\s.s = ParsePBObject()\Object\s.s
        EndIf
        ParsePBObject()\Window\s.s = *This\Window\s.s
        ParsePBObject()\Parent\s.s = *This\Parent\s.s
      Else
        ; Формируем имя объекта снова так как изменили имя родителя
        If *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s
          Debug ParsePBObject()\Class\s.s
          ParentClass$ = *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s
          
          *This\get(ParsePBObject()\Object\s.s)\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s
          *This\get(Str(ParsePBObject()\Object\i.i))\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s
          
          ; Меняем map ключ объекта
          CopyStructure(*This\get(ParsePBObject()\Object\s.s), *This\get(ParentClass$+"_"+ParsePBObject()\Class\s.s), ObjectStruct)
          ; И удаляем старый
          DeleteMapElement(*This\get(), ParsePBObject()\Object\s.s)
          
          ParsePBObject()\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s 
          
          ; Обнавляем инспектор объектов
          For i=0 To CountGadgetItems(WE_Tree_0)-1
            If ParsePBObject()\Object\i.i=GetGadgetItemData(WE_Tree_0, i) 
              SetGadgetItemText(WE_Tree_0, i, ParsePBObject()\Object\s.s)
              Break
            EndIf
          Next 
        EndIf
      EndIf
    Next
    PopListPosition(ParsePBObject())  
    
    ; 
    RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Trim(Find$, "#")+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
    
    If RegExID
      Protected NbFound, String$, Dim Result$(0) 
      ; Разница между словами
      len = (Len(Replace$)-Len(Find$))
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get(*This\Window\s.s)\Code("Code_Object")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Function")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\s.s)\Code("Code_Function")\Position + NbFound
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
      ; Заменям слова в файле
      If ExamineRegularExpression(RegExID, *This\Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
          Break
        Wend
      EndIf
      
      FreeRegularExpression(RegExID)
    EndIf
    
    ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Window\s.s)\Code("Code_Object")\Position
    ;     Debug "    Code_Function"+ *This\get(*This\get(Replace$)\Parent\s.s)\Code("Code_Function")\Position
    
    SetGadgetText(Gadget, Replace$)
    
    WE_Code_Show(*This\Content\Text$)
  EndIf
EndProcedure

Procedure WE_OpenFile(Path$) ; Открытие файла
  If Path$
    Debug "Открываю файл '"+Path$+"'"
    
    ; Начинаем перебырать файл
    If ParsePBFile(Path$)
      
      WE_Tree_0_Update(WE_Tree_0)
      
      WE_Code_Show(*This\Content\Text$)
      
    EndIf
    
    *This\Content\File$=Path$
    Debug "..успешно"
  EndIf 
EndProcedure

Procedure WE_SaveFile(Path$) ; Процедура сохранения файла
  If Path$
    *This\Content\File$=Path$
    ClearDebugOutput()
    Debug "Сохраняю файл '"+Path$+"'"
    
    Protected Object
    Protected len, Length, Position
    Protected Space$, Text$
    
    len = 0
    
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      Object = ParsePBObject()\Object\i.i ; *This\get(ParsePBObject()\Object\s.s)\Object\i.i
      
      If IsWindow(Object)
        ParsePBObject()\X\s.s = Str(WindowX(Object))
        ParsePBObject()\Y\s.s = Str(WindowY(Object))
        ParsePBObject()\Width\s.s = Str(WindowWidth(Object))
        ParsePBObject()\Height\s.s = Str(WindowHeight(Object))
        ParsePBObject()\Caption\s.s = GetWindowTitle(Object)
      EndIf
      If IsGadget(Object)
        ParsePBObject()\X\s.s = Str(GadgetX(Object))
        ParsePBObject()\Y\s.s = Str(GadgetY(Object))
        ParsePBObject()\Width\s.s = Str(GadgetWidth(Object))
        ParsePBObject()\Height\s.s = Str(GadgetHeight(Object))
        ParsePBObject()\Caption\s.s = GetGadgetText(Object)
      EndIf
      
    Next
    
    With ParsePBObject()
      ForEach ParsePBObject()
        ;         If \Content\String$=""
        ;           \Length = 53
        ;           \Position = 409
        ;           \Content\String$ = ~"OpenWindow(#Window_0, 230,230,240,200,\"Window_0\", Flag)"
        ;         EndIf
        
        
        Text$ = \Content\String$
        Length = CO_Save(ParsePBObject())
        
        ;         If Text$= ""
        ;           Text$=\Content\String$
        ;           EndIf
        
        If (Length>\Content\Length)
          Position = \Content\Position
          *This\Content\Text$ = InsertString(*This\Content\Text$, Space(Length), 1+(\Content\Position+\Content\Length+len))
          \Content\Length = Length
          \Content\Position + Len
          len + Length
        Else
          \Content\String$ + Space((\Content\Length-Length))
        EndIf
        
        Debug ""+Str(Position)+" "+Str(Length)+" "+Text$+" "+\Object\s.s
        Debug "  "+Str(\Content\Position)+" "+Str(\Content\Length)+" "+\Content\String$+" "+\Object\s.s
        ;*This\Content\Text$=ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_CaseSensitive, Position, 1)
        ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_InPlace, Position, 1)
        ;Replace(\Content\String$, Text$, \Content\Position)
      Next
    EndWith
    PopListPosition(ParsePBObject())
    
    Debug *This\Content\Text$
    
    If CreateFile(#File, *This\Content\File$, #PB_UTF8)
      WriteStringFormat(#File, #PB_UTF8)
      WriteString(#File, *This\Content\Text$, #PB_UTF8)
      CloseFile(#File)
      
      Debug "..успешно"
    Else
      MessageRequester("Information","may not create the file!")
    EndIf
  EndIf
  
  ProcedureReturn Bool(*This\Content\File$)
EndProcedure

;-
Procedure WE_OpenWindow(Flag.i=#PB_Window_SystemMenu, ParentID=0)
  If Not IsWindow(WE)
    WE = OpenWindow(#PB_Any, 100, 100, 900, 600, "(WE) - Редактор объектов", Flag, ParentID)
    StickyWindow(WE, #True)
    
    WE_Menu_0 = CreateMenu(#PB_Any, WindowID(WE))
    If WE_Menu_0
      MenuTitle("Project")
      MenuItem(WE_Menu_New, "New"         +Chr(9)+"Ctrl+N")
      MenuItem(WE_Menu_Open, "Open"       +Chr(9)+"Ctrl+O")
      MenuItem(WE_Menu_Save, "Save"       +Chr(9)+"Ctrl+S")
      MenuItem(WE_Menu_Save_as, "Save as" +Chr(9)+"Ctrl+A")
      MenuItem(WE_Menu_Code, "Code"       +Chr(9)+"Ctrl+C")
      MenuItem(WE_Menu_Quit, "Quit"     +Chr(9)+"Ctrl+Q")
    EndIf
    
    WE_Tree_0 = TreeGadget(#PB_Any, 5, 5, 315, 145, #PB_Tree_AlwaysShowSelection)
    WE_Panel_0 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_0, -1, "Objects")
    WE_Tree_1 = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(WE_Tree_1, #PB_Drop_Text, #PB_Drag_Copy)
    
    AddGadgetItem(WE_Panel_0, -1, "Properties")
    WE_Properties = Properties::Gadget( #PB_Any, 315, 261 )
    Properties_ID = Properties::AddItem( WE_Properties, "ID:", #PB_GadgetType_String | #PB_GadgetType_CheckBox )
    Properties::AddItem( WE_Properties, "Text:", #PB_GadgetType_String )
    Properties::AddItem( WE_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
    Properties::AddItem( WE_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
    
    Properties::AddItem( WE_Properties, "Layouts:", #False )
    Properties::AddItem( WE_Properties, "X:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Y:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Width:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Height:", #PB_GadgetType_Spin )
    
    Properties::AddItem( WE_Properties, "Other:", #False )
    Properties_Flag = Properties::AddItem( WE_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties_Image = Properties::AddItem( WE_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
    
    ; 
    AddGadgetItem(WE_Panel_0, -1, "Events")
    CloseGadgetList()
    
    WE_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Tree_0, WE_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(WE_Splitter_0, 145)
    
    
    WE_Panel_1 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_1, -1, "Form")
    WE_ScrollArea_0 = MDIGadget(#PB_Any, 0, 0, 150, 150, 0, 0)
    UseGadgetList(WindowID(WE)) ; вернёмся к списку гаджетов главного окна
                                ;CloseGadgetList()
    
    AddGadgetItem(WE_Panel_1, -1, "Code")
    ;     CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
;       WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x86_scintilla.dll", "x86_SyntaxHilighting.dll")
;     CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
;       WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x64_scintilla.dll", "x64_SyntaxHilighting.dll")
;     CompilerEndIf
    
    WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "scintilla.dll")
CloseGadgetList()
    
    WE_Splitter_1 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Panel_1, WE_Splitter_0, #PB_Splitter_SecondFixed|#PB_Splitter_Vertical)
    SetGadgetState(WE_Splitter_1, 900-300)
    
    LoadControls()
    WE_ResizePanel_0()
    WE_ResizePanel_1()
    
    ;;;WE_OpenFile("Ссылкодел.pb")
    
    BindEvent(#PB_Event_Menu, @WE_Events(), WE)
    BindEvent(#PB_Event_Gadget, @WE_Events(), WE)
    BindEvent(#PB_Event_SizeWindow, @WE_ResizeWindow(), WE)
    
    BindGadgetEvent(WE_Panel_0, @WE_ResizePanel_0(), #PB_EventType_Resize)
    BindGadgetEvent(WE_Panel_1, @WE_ResizePanel_1(), #PB_EventType_Resize)
    BindEvent(#PB_Event_CloseWindow, @WE_CloseWindow(), WE)
  EndIf
  
  ProcedureReturn WE
EndProcedure


Procedure WE_ResizePanel_0()
  Protected GadgetWidth = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(WE_Panel_0, GetGadgetState(WE_Panel_0))
    Case "Properties" : Properties::Size(GadgetWidth, GadgetHeight)
    Case "Objects"  : ResizeGadget(WE_Tree_1, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure WE_ResizePanel_1()
  Protected GadgetWidth = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(WE_Panel_1, GetGadgetState(WE_Panel_1))
    Case "Code" : ResizeGadget(WE_Scintilla_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
    Case "Form" : ResizeGadget(WE_ScrollArea_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure WE_ResizeWindow()
  Protected WindowWidth = WindowWidth(WE)
  Protected WindowHeight = WindowHeight(WE)-MenuHeight()
  ResizeGadget(WE_Splitter_1, 5, 5, WindowWidth - 10, WindowHeight - 10)
  WE_ResizePanel_1()
  WE_ResizePanel_0()
EndProcedure

Procedure WE_CloseWindow()
  If IsWindow(WE)
    UnbindEvent(#PB_Event_Menu, @WE_Events(), WE)
    UnbindEvent(#PB_Event_Gadget, @WE_Events(), WE)
    UnbindEvent(#PB_Event_SizeWindow, @WE_ResizeWindow(), WE)
    
    UnbindGadgetEvent(WE_Panel_0, @WE_ResizePanel_0(), #PB_EventType_Resize)
    
    CloseWindow(WE)
  EndIf
EndProcedure



Procedure WE_Events()
  Protected I, File$, SubItem, UseGadgetList
  Protected IsContainer.b, Object, Parent=-1
  ;-
  Select Event()
    Case #PB_Event_Gadget ;- Gadget()
      Select EventGadget()
        Case WE_Panel_0
          If EventType() = #PB_EventType_Change
            If GetGadgetText(EventGadget())="Events"
              Debug ""
              PushListPosition(ParsePBObject())
              ForEach ParsePBObject()
                Debug ParsePBObject()\Object\s.s +" "+ *This\get(ParsePBObject()\Object\s.s)\Code("Code_Function")\Position 
                
              Next
              PopListPosition(ParsePBObject())
            EndIf
          EndIf
          
        Case Properties_ID ;- Event(_Properties_ID_)
          
          Select EventType()
            Case #PB_EventType_Change      
              ;Case #PB_EventType_LostFocus
              WE_Tree_0_Replace(WE_Tree_0)
              
          EndSelect
          
        Case Properties_Flag ;- Event(_Properties_Flag_)
          
          Select EventType()
            Case #PB_EventType_LostFocus   
              PushListPosition(ParsePBObject())
              ForEach ParsePBObject()
                If ParsePBObject()\Object\s.s = GetGadgetText(WE_Tree_0)
                  ParsePBObject()\Flag\s.s = Properties::GetCheckedText(EventGadget()) 
                  Break
                EndIf
              Next
              PopListPosition(ParsePBObject())
              
          EndSelect
          
        Case WE_Tree_0 ;- Event(_WE_Tree_0_)
          
          Select EventType()
            Case #PB_EventType_RightClick    
              Transformation::PopupMenu(GetGadgetItemData(WE_Tree_0, GetGadgetState(WE_Tree_0)))
              
              
            Case #PB_EventType_Change     
              ; Для удобства выбираем вкладку свойства 
              If GetGadgetState(WE_Panel_0) <> 1 : SetGadgetState(WE_Panel_0, 1) : EndIf
              
              PushListPosition(ParsePBObject())
              With ParsePBObject()
                ForEach ParsePBObject()
                  If GetGadgetText(WE_Tree_0) = \Object\s.s
                    Properties::Init(\Object\i.i, \Object\s.s, \Flag\s.s)
                    Transformation::Change(\Object\i.i)
                    Break
                  EndIf
                Next
              EndWith
              PopListPosition(ParsePBObject())
              
          EndSelect
          
        Case WE_Tree_1 ;- Event(_WE_Tree_1_)
          
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
          EndSelect
          
      EndSelect
      
    Case #PB_Event_Menu ;- Menu()
      
      Select EventMenu()
        Case WE_Menu_Quit
          End
          
        Case WE_Menu_Delete ;- Event(_WE_Menu_Delete_) 
                            ; Debug EventGadget()
          CO_Free(GetGadgetItemData(WE_Tree_0, GetGadgetState(WE_Tree_0)))
          
        Case WE_Menu_Open ;- Event(_WE_Menu_Open_) 
          WE_OpenFile(OpenFileRequester("Выберите файл с описанием окон", *This\Content\File$, "Все файлы|*", 0))
          
        Case WE_Menu_Save_as ;- Event(_WE_Menu_Save_as_) 
          If Not WE_SaveFile("Test_0.pb") ; SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
            MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
          EndIf
          
        Case WE_Menu_Save ;- Event(_WE_Menu_Save_) 
          If Not WE_SaveFile(*This\Content\File$)
            If Not WE_SaveFile(SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
              MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
            EndIf
          EndIf
          
        Case WE_Menu_New ;- Event(_WE_Menu_New_)
          CO_Create("Window",WindowX(EventWindow())-350,WindowHeight(EventWindow())-300)
          
          ;           WE_OpenFile("Window_0.pb")
          
          
          SetGadgetState(WE_Panel_0, 0)
          
          
      EndSelect
      
  EndSelect
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  ; Инициализация окна редактора
  MainWindow = WE_OpenWindow(#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
  
  If CountProgramParameters()=1 
    WE_OpenFile(ProgramParameter(0))
  EndIf
  
  While IsWindow(MainWindow)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(MainWindow)
        EndIf
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 23
; FirstLine = 3
; Folding = ---------------------------------------------------------------
; EnableXP