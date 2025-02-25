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


; Найти Enumeration 
; https://regex101.com/r/u60Wqt/1

#RegEx_Pattern_Find = ""+
; https://regex101.com/r/oIDfrI/2
"(?P<Comments>;).* |"+
; #Эта часть нужна для поиска переменных
; #Например, "Window" в выражении "Window=OpenWindow(#PB_Any...)"
"(?:(?P<Handle>[^:\n\s]+)\s*=\s*)?"+
"(?P<FuncString>"+
~"\".*\" |"+
; #Эта часть для поиска функций
"\b(?P<FuncName>\w+)\s*"+
; #Эта часть для поиска аргументов функции
"(?:\((?P<FuncArguments>(?>(?R)|[^()])*)\))"+
") |"+
; #Эта часть для поиска процедур
"(?P<StartPracedure>\bProcedure[.A-Za-z]* \s*"+
; #Эта часть для поиска имени процедуры
"(?P<PracName>\w*) \s*"+
; #Эта часть для поиска аргументов процедуры
"(?:\((?P<ProcArguments>(?>(?R)|[^()])*)\))) |"+
; #Эта часть для поиска конец процедуры
"(?P<StopProcedure>\bEndProcedure\b)"
; 
; #После выполнения:
; # - В группе (Comments) будет находиться комментария
; # - В группе (Handle) будет находиться название переменной
; # - В группе (FunctionName) - название Функции
; # - В группе (FuncArguments) - перечень всех аргументов найденной Функции
; # - В группе (ProcedureName) - название процедуры
; # - В группе (ProcArguments) - перечень всех аргументов найденной процедуры


;#RegEx_Pattern_Others1 = ~"[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\]"
#RegEx_Pattern_Quotes = ~"(?:\"(.*?)\")" ; - Находит Кавычки
#RegEx_Pattern_Others = ~"(?:[\\s\\^\\|\\!\\~\\&\\$])" ; Находим остальное
#RegEx_Pattern_Match = ~"(?:([\\/])|([\\*])|([\\-])|([\\+]))" ; Находит (*-+/)
                                                              ;#RegEx_Pattern_Function = ~"(?:(\\w*)\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_Function = ~"(?:(\\b[A-Za-z_]\\w+)?\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_World = ~"(?:([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+))"
#RegEx_Pattern_Captions = #RegEx_Pattern_Quotes+"|"+#RegEx_Pattern_Function+"|"+#RegEx_Pattern_Match+"|"+#RegEx_Pattern_World
#RegEx_Pattern_Arguments = "("+#RegEx_Pattern_Captions+"|"+#RegEx_Pattern_Others+")+"

#RegEx_Pattern_Func = ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)"

Enumeration RegularExpression
  #RegEx_Function
  #RegEx_Arguments
  #RegEx_Arguments1
  #RegEx_Captions
  #RegEx_Captions1
  #Regex_Procedure
  #RegEx_Var
EndEnumeration

#File = 0

;-
;- STRUCTURE
Structure ContentStruct
  File$
  Text$    ; Содержимое файла 
  String$  ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
  Position.i  ; Положение Content-a в исходном файле
  Length.i    ; длинна Content-a в исходном файле
  Open.i
  Close.i
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
  
  Type.i  
  object.i ; Object$ = Window_0;Window_0_Button_0;Window_0_Text_0
  parent.i
  window.i
  
  type$    ; OpenWindow;ButtonGadget;TextGadget
  class$   ; Window_0;Button_0;Text_0
  object$
  parent$
  window$
EndStructure

Structure FONT
  Object.i
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  Object.i
  Name$
EndStructure

Structure ParseStruct Extends ObjectStruct
  Item.i
  SubLevel.i ; 
  Container.i
  Content.ContentStruct  
  
  X.i 
  Y.i
  Width.i
  Height.i
  Param1.i
  Param2.i
  Param3.i
  Flag.i
  
  x$
  y$
  width$
  height$
  Caption$
  Param1$
  Param2$
  Param3$
  Param1Def$
  Param2Def$
  Param3Def$
  flag$
  
  Map Font.FONT()
  Map Img.IMG()
  ;Map Code.ContentStruct()
  
  Args$
EndStructure

Structure ThisStruct Extends ParseStruct
  Map get.ObjectStruct()
EndStructure

EnableExplicit
Global NewList ParsePBObject.ParseStruct() 
Global *This.ThisStruct = AllocateStructure(ThisStruct)

;-
Procedure$ GetStr1(String$)
  Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
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
            Object = (*This\get(RegularExpressionGroup(#RegEx_Captions1, 3))\Object)
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
            Case "GetWindowTitle" : Result$+GetWindowTitle(Object)
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
                Result$ + WindowHeight(Object, Param2)
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
  Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
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
            Object = (*This\get(RegularExpressionGroup(#RegEx_Captions, 3))\Object)
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
            Case "GetWindowTitle" : Result$+GetWindowTitle(Object)
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
                Result$ + WindowHeight(Object, Param2)
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


;-
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open(WE_ScrollArea_0)
Declare PC_Free(Object.i)


;-
Macro is_object(_object_)
  Bool(IsGadget(_object_) | IsWindow(_object_))
EndMacro

Macro get_object_id(_class_)
  *This\get(_class_)\Object\Argument
EndMacro

Macro get_object_class(_object_)
  *This\get(Str(_object_))\Class\Argument$
EndMacro

Macro get_object_type(_object_)
  *This\get(Str(_object_))\Type\Argument$
EndMacro

Macro get_object_adress(_object_)
  *This\get(Str(_object_))\Adress
EndMacro

Macro get_object_parent(_object_)
  *This\get(Str(_object_))\Parent\Argument
EndMacro

Macro get_object_window(_object_)
  *This\get(Str(_object_))\Window\Argument
EndMacro

Macro get_object_count(_object_)
  *This\get(Str(get_object_parent(_object_))+"_"+get_object_type(_object_))\Count
EndMacro

Macro get_argument_string(_string_)
  GetArguments(_string_, #RegEx_Pattern_Function, 2)
EndMacro

Macro change_current_object_from_class(_class_)
  Bool(*This\get(_class_)\Adress And ChangeCurrentElement(ParsePBObject(), *This\get(_class_)\Adress))
EndMacro

Macro change_current_object_from_id(_object_)
  change_current_object_from_class(Str(_object_))
EndMacro

Macro GetVarValue(StrToFind)
  ;GetArguments(*This\Content\Text$, "(?:(\w+)\s*\(.*)?"+StrToFind+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
  GetArguments(*This\Content\Text$, ~"(?:(\\w+)\\s*\\(.*)?"+StrToFind+~"(?:\\$)?(?:\\.\\w)?\\s*=\\s*(?:\")?([\\#\\w\\|\\s\\(\\)]+$|[\\#\\w\\|\\s\\(\\)]+)(?:\")?", 2)
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



;-
;- PARSER_CODE
Procedure PC_Add(*This.ParseStruct, Index)
  Protected Result
  
  With *This
    Select \Type$
      Case "HideWindow", "HideGadget", 
           "DisableWindow", "DisableGadget"
        Select Index
          Case 1 : \Object$ = \Args$
          Case 2 : \Param1$ = \Args$
        EndSelect
        
        Select \Param1$
          Case "#True" : \Object = #True
          Case "#False" : \Param1 = #False
          Default
            \Param1 = Val(\Param1$)
        EndSelect
        
      Case "LoadFont"
        Select Index
          Case 1 : \Object$ = \Args$
          Case 2 : \Param1$ = \Args$
          Case 3 : \Param2$ = \Args$
          Case 4 : \Param3$ = \Args$
        EndSelect
        
      Case "LoadImage", 
           "SetGadgetFont", 
           "SetGadgetState",
           "SetGadgetText"
        Select Index
          Case 1 : \Object$ = \Args$
          Case 2 : \Param1$=GetStr(\Args$)
        EndSelect
        
      Case "ResizeGadget"
        Select Index
          Case 1 : \Object$ = \Args$
          Case 2 
            If "#PB_Ignore"=\Args$ 
              \x = #PB_Ignore
            Else
              \x = Val(\Args$)
            EndIf
            
          Case 3 
            If "#PB_Ignore"=\Args$ 
              \y = #PB_Ignore
            Else
              \y = Val(\Args$)
            EndIf
            
          Case 4 
            If "#PB_Ignore"=\Args$ 
              \width = #PB_Ignore
            Else
              \width = Val(\Args$)
            EndIf
            
          Case 5 
            If "#PB_Ignore"=\Args$ 
              \height = #PB_Ignore
            Else
              \height = Val(\Args$)
            EndIf
            
        EndSelect
        
      Case "SetGadgetColor"
        Select Index
          Case 1 : \Object$ = \Args$
          Case 2 
            Select \Args$
              Case "#PB_Gadget_FrontColor"      : \Param1 = #PB_Gadget_FrontColor      ; Цвет текста гаджета
              Case "#PB_Gadget_BackColor"       : \Param1 = #PB_Gadget_BackColor       ; Фон гаджета
              Case "#PB_Gadget_LineColor"       : \Param1 = #PB_Gadget_LineColor       ; Цвет линий сетки
              Case "#PB_Gadget_TitleFrontColor" : \Param1 = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
              Case "#PB_Gadget_TitleBackColor"  : \Param1 = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
              Case "#PB_Gadget_GrayTextColor"   : \Param1 = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
            EndSelect
            
          Case 3
            \Param2 = Val(\Args$)
            Result = GetVal(\Args$)
            If Result
              \Param2 = Result
            EndIf
        EndSelect
        
        
    EndSelect
    
  EndWith
  
EndProcedure

Procedure PC_Set(*ThisParse.ParseStruct)
  Protected Result, I, Object
  
  With *ThisParse ; 
    Object = *This\get(\Object$)\Object
    
    Select \Type$
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
        AddMapElement(\Font(), \Object$) 
        
        \Font()\Name$=\Param1$
        \Font()\Height=Val(\Param2$)
        
        For I = 0 To CountString(\Param3$,"|")
          Select Trim(StringField(\Param3$,(I+1),"|"))
            Case "#PB_Font_Bold"        : \Font()\Style|#PB_Font_Bold
            Case "#PB_Font_HighQuality" : \Font()\Style|#PB_Font_HighQuality
            Case "#PB_Font_Italic"      : \Font()\Style|#PB_Font_Italic
            Case "#PB_Font_StrikeOut"   : \Font()\Style|#PB_Font_StrikeOut
            Case "#PB_Font_Underline"   : \Font()\Style|#PB_Font_Underline
          EndSelect
        Next
        
        \Font()\Object=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
        
      Case "LoadImage"
        AddMapElement(\Img(), \Object$) 
        \Img()\Name$=\Param1$
        \Img()\Object=LoadImage(#PB_Any, \Img()\Name$)
        
    EndSelect
    
    If IsWindow(Object)
      Select \Type$
        Case "SetActiveWindow"         : SetActiveWindow(Object)
        Case "HideWindow"              : HideWindow(Object, \Param1)
        Case "DisableWindow"           : DisableWindow(Object, \Param1)
      EndSelect
    EndIf
    
    If IsGadget(Object)
      Select \Type$
        Case "SetActiveGadget"         : SetActiveGadget(Object)
        Case "HideGadget"              : HideGadget(Object, \Param1)
        Case "DisableGadget"           : DisableGadget(Object, \Param1)
        Case "SetGadgetText"           : SetGadgetText(Object, \Param1$)
        Case "SetGadgetColor"          : SetGadgetColor(Object, \Param1, \Param2)
          
        Case "SetGadgetFont"
          Protected Font = \Font(\Param1$)\Object
          If IsFont(Font)
            SetGadgetFont(Object, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1$)\Object
          If IsImage(Img)
            SetGadgetState(Object, ImageID(Img))
          EndIf
          
        Case "ResizeGadget"
          ResizeGadget(Object, \x, \y, \width, \height)
          ; Transformation::Update(Object)
          
      EndSelect
    EndIf
  EndWith
  
EndProcedure



Procedure$ PC_Content() ; Ok
  Protected ID$, Handle$, Result$
  
  With ParsePBObject()
    If Asc(\Object$) = '#'
      ID$ = \Object$
    Else
      Select Asc(\Object$)
        Case '0' To '9'
          ID$ = Chr(Asc(\Object$))
        Default
          Handle$ = \Object$+" = "
          ID$ = "#PB_Any"
      EndSelect
    EndIf
    
    Select \Type$
        Case "OpenWindow", "WindowGadget" : Result$ = Handle$+"OpenWindow("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                            : If \flag$ : Result$ +", "+\flag$ : EndIf : If \Param1$ : Result$ +", "+\Param1$ : EndIf 
        Case "ButtonGadget"        : Result$ = Handle$+"ButtonGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "StringGadget"        : Result$ = Handle$+"StringGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "TextGadget"          : Result$ = Handle$+"TextGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                   : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "CheckBoxGadget"      : Result$ = Handle$+"CheckBoxGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                               : If \flag$ : Result$ +", "+\flag$ : EndIf
      Case "OptionGadget"        : Result$ = Handle$+"OptionGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)
        Case "ListViewGadget"      : Result$ = Handle$+"ListViewGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "FrameGadget"         : Result$ = Handle$+"FrameGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                  : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ComboBoxGadget"      : Result$ = Handle$+"ComboBoxGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ImageGadget"         : Result$ = Handle$+"ImageGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$                                                                                                   : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "HyperLinkGadget"     : Result$ = Handle$+"HyperLinkGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                                       : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ContainerGadget"     : Result$ = Handle$+"ContainerGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                       : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ListIconGadget"      : Result$ = Handle$+"ListIconGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
      Case "IPAddressGadget"     : Result$ = Handle$+"IPAddressGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$
        Case "ProgressBarGadget"   : Result$ = Handle$+"ProgressBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                      : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ScrollBarGadget"     : Result$ = Handle$+"ScrollBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$+", "+\Param3$                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ScrollAreaGadget"    : Result$ = Handle$+"ScrollAreaGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$    : If \Param3$ : Result$ +", "+\Param3$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf 
        Case "TrackBarGadget"      : Result$ = Handle$+"TrackBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                         : If \flag$ : Result$ +", "+\flag$ : EndIf
      Case "WebGadget"           : Result$ = Handle$+"WebGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)
        Case "ButtonImageGadget"   : Result$ = Handle$+"ButtonImageGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$                                                                                             : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "CalendarGadget"      : Result$ = Handle$+"CalendarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                     : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "DateGadget"          : Result$ = Handle$+"DateGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "EditorGadget"        : Result$ = Handle$+"EditorGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ExplorerListGadget"  : Result$ = Handle$+"ExplorerListGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                           : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ExplorerTreeGadget"  : Result$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                           : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "ExplorerComboGadget" : Result$ = Handle$+"ExplorerComboGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "SpinGadget"          : Result$ = Handle$+"SpinGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                             : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "TreeGadget"          : Result$ = Handle$+"TreeGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                            : If \flag$ : Result$ +", "+\flag$ : EndIf
      Case "PanelGadget"         : Result$ = Handle$+"PanelGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$ 
        Case "SplitterGadget"      : Result$ = Handle$+"SplitterGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                         : If \flag$ : Result$ +", "+\flag$ : EndIf
        Case "MDIGadget"           : Result$ = Handle$+"MDIGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                              : If \flag$ : Result$ +", "+\flag$ : EndIf 
      Case "ScintillaGadget"     : Result$ = Handle$+"ScintillaGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$
      Case "ShortcutGadget"      : Result$ = Handle$+"ShortcutGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$
        Case "CanvasGadget"        : Result$ = Handle$+"CanvasGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
    EndSelect
    
    Result$+")" 
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure PC_Change(Indent.i, Replace$="")
  Protected RegExID, Identific$, delete_len
  ;   Debug "PC_Change "+Replace$
  ;   ProcedureReturn 
  ; Ищем функцию 
  With ParsePBObject()
    If Replace$
      ; Это значить меняем строки
      Identific$ = \Content\String$
      delete_len = \Content\Length
      \Content\String$ = Replace$
      \Content\Length = Len( Replace$ )
      delete_len-\Content\Length
    Else
      ;{ Remove string
      ; Это значить удаляем строки
      ; Для этого ищем идентификатор 
      ; (перечисление через два пробела) (переменые через длину "Global ") 
      If Asc(\Object$)='#'
        Identific$ = #CRLF$+Space(Len("  "))+\Object$
      Else
        Identific$ = ","+#CRLF$+Space(Len("Global "))+\Object$+"=-1"
      EndIf
      
      RegExID = CreateRegularExpression(#PB_Any, Identific$)
      delete_len = Len(Identific$)
      
      If RegExID
        *This\get("Code")\Code("Code_Object")\Position - delete_len
        *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, "")
        FreeRegularExpression(RegExID)
      EndIf
      
      ; Ищем строки функции
      Identific$ = #CRLF$+Space(Indent)+\Content\String$
      If \Container
        Identific$ = Identific$+#CRLF$+Space(Indent)+"CloseGadgetList()"
      EndIf
      delete_len = Len(Identific$)+delete_len
      ;}
    EndIf
    
    ;         Debug "-> "+Identific$
    ;         Debug " -> "+Replace$
    
    Identific$ = ReplaceString(Identific$, "(", "\(")
    Identific$ = ReplaceString(Identific$, ")", "\)")
    Identific$ = ReplaceString(Identific$, "|", "\|")
    RegExID = CreateRegularExpression(#PB_Any, Identific$)
    
    If RegExID
      ; Изменяем последнюю позицию добавления строки
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object$)\Code("Code_Function")\Position - delete_len
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
      *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Replace$)
      FreeRegularExpression(RegExID)
    EndIf
  EndWith
  
EndProcedure

Procedure PC_Destroy()
  With ParsePBObject()
    PC_Change(0)
    
    ;
    ;     *This\get(Str(\parent)+"_"+\Type$)\Count-1 
    ;     If *This\get(Str(\parent)+"_"+\Type$)\Count =< 0
    ;       DeleteMapElement(*This\get(), Str(\parent)+"_"+\Type$)
    ;     EndIf
    
    DeleteMapElement(*This\get(), \Object$)
    DeleteMapElement(*This\get(), Str(\Object))
    DeleteElement(ParsePBObject())
    
  EndWith
EndProcedure

Procedure PC_Free(Object.i)
  
  If ListSize(ParsePBObject())
    With ParsePBObject()
      ; Если есть дети, работаем над детми
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        If \Container
          ForEach ParsePBObject()
            If \parent = Object 
              If \Container
                PC_Free(\Object)
                
              Else
                PC_Destroy()
                
              EndIf
            EndIf
          Next
        EndIf
      EndIf
      
      ; Удаляем строки объекта из кода 
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        PC_Destroy()
      EndIf
    EndWith  
  EndIf
  
EndProcedure

Macro PC_Update(_object_=-1)
  PushListPosition(ParsePBObject())
  ForEach ParsePBObject() 
    PC_Change(Indent, PC_Content()) 
  Next
  PopListPosition(ParsePBObject())
  
  WE_Code_Show(*This\Content\Text$)
EndMacro

;-
Procedure CO_Change(Object.i)
EndProcedure

Procedure CO_Events()
EndProcedure

#PB_EventType_Create =- 33
#PB_Event_Create =- 22

Procedure CO_Open(WE_ScrollArea_0) ; Ok
   ; ProcedureReturn 
   
   Protected GetParent, OpenGadgetList, Object=-1
  Static AddGadget
  
  With *This
    ;
    Select \Type$
      Case "OpenWindow" : \type =- 1  : \window =- 1  
        If IsGadget(WE_ScrollArea_0)
          Select GadgetType(WE_ScrollArea_0)
            Case #PB_GadgetType_ScrollArea
              \Type$ = "WindowGadget"
              \x = 20
              \y = 20+25
              \parent = WE_ScrollArea_0
              OpenGadgetList(WE_ScrollArea_0)
              
;               \Object = WindowGadget(#PB_Any, \x,\y,\width,\height, \Caption$, \flag);, \Param1)
;               \flag | #PB_Canvas_Container
            Case #PB_GadgetType_MDI ; , \flag, \Param1)
              \x = 20
              \y = 20
              \Object = AddGadgetItem(WE_ScrollArea_0, #PB_Any, \Caption$, 0, \flag) : ResizeWindow(\Object, \x,\y,\width,\height)
              
          EndSelect
        Else
          \Param1 = UseGadgetList(0)
          \Object = OpenWindow          (#PB_Any, \x,\y,\width,\height, \Caption$, \flag, \Param1)
          StickyWindow(\Object, 1)
        EndIf
      Case "ButtonGadget"         : \type = #PB_GadgetType_Button        : \Object = ButtonGadget        (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "StringGadget"        : \type = #PB_GadgetType_String        : \Object = StringGadget        (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "TextGadget"          : \type = #PB_GadgetType_Text          : \Object = TextGadget          (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "CheckBoxGadget"      : \type = #PB_GadgetType_CheckBox      : \Object = CheckBoxGadget      (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "OptionGadget"        : \type = #PB_GadgetType_Option        : \Object = OptionGadget        (#PB_Any, \x,\y,\width,\height, \Caption$)
      Case "ListViewGadget"      : \type = #PB_GadgetType_ListView      : \Object = ListViewGadget      (#PB_Any, \x,\y,\width,\height, \flag)
      Case "FrameGadget"         : \type = #PB_GadgetType_Frame         : \Object = FrameGadget         (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "ComboBoxGadget"      : \type = #PB_GadgetType_ComboBox      : \Object = ComboBoxGadget      (#PB_Any, \x,\y,\width,\height, \flag)
      Case "ImageGadget"         : \type = #PB_GadgetType_Image         : \Object = ImageGadget         (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
      Case "HyperLinkGadget"     : \type = #PB_GadgetType_HyperLink     : \Object = HyperLinkGadget     (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
      Case "ContainerGadget"     : \type = #PB_GadgetType_Container     : \Object = ContainerGadget     (#PB_Any, \x,\y,\width,\height, \flag)
      Case "ListIconGadget"      : \type = #PB_GadgetType_ListIcon      : \Object = ListIconGadget      (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
      Case "IPAddressGadget"     : \type = #PB_GadgetType_IPAddress     : \Object = IPAddressGadget     (#PB_Any, \x,\y,\width,\height)
      Case "ProgressBarGadget"   : \type = #PB_GadgetType_ProgressBar   : \Object = ProgressBarGadget   (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
      Case "ScrollBarGadget"     : \type = #PB_GadgetType_ScrollBar     : \Object = ScrollBarGadget     (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \Param3, \flag)
      Case "ScrollAreaGadget"    : \type = #PB_GadgetType_ScrollArea    : \Object = ScrollAreaGadget    (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \Param3, \flag) 
      Case "TrackBarGadget"      : \type = #PB_GadgetType_TrackBar      : \Object = TrackBarGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
        ;       Case "WebGadget"           : \type = #PB_GadgetType_Web           : \Object = WebGadget           (#PB_Any, \x,\y,\width,\height, \Caption$)
      Case "ButtonImageGadget"   : \type = #PB_GadgetType_ButtonImage   : \Object = ButtonImageGadget   (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
      Case "CalendarGadget"      : \type = #PB_GadgetType_Calendar      : \Object = CalendarGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
      Case "DateGadget"          : \type = #PB_GadgetType_Date          : \Object = DateGadget          (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
      Case "EditorGadget"        : \type = #PB_GadgetType_Editor        : \Object = EditorGadget        (#PB_Any, \x,\y,\width,\height, \flag)
      Case "ExplorerListGadget"  : \type = #PB_GadgetType_ExplorerList  : \Object = ExplorerListGadget  (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "ExplorerTreeGadget"  : \type = #PB_GadgetType_ExplorerTree  : \Object = ExplorerTreeGadget  (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "ExplorerComboGadget" : \type = #PB_GadgetType_ExplorerCombo : \Object = ExplorerComboGadget (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
      Case "SpinGadget"          : \type = #PB_GadgetType_Spin          : \Object = SpinGadget          (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
      Case "TreeGadget"          : \type = #PB_GadgetType_Tree          : \Object = TreeGadget          (#PB_Any, \x,\y,\width,\height, \flag)
      Case "PanelGadget"         : \type = #PB_GadgetType_Panel         : \Object = PanelGadget         (#PB_Any, \x,\y,\width,\height) 
      Case "SplitterGadget"      
        Debug "Splitter FirstGadget "+\Param1
        Debug "Splitter SecondGadget "+\Param2
        If IsGadget(\Param1) And IsGadget(\Param2)
          \type = #PB_GadgetType_Splitter                               
          \Object = SplitterGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
        Else
          \type = #PB_GadgetType_Splitter     
          \Param1 = TextGadget(#PB_Any, 0,0,0,0, "Splitter")
          \Param2 = TextGadget(#PB_Any, 0,0,0,0, "")
          \Object = SplitterGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
          
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          \type = #PB_GadgetType_MDI                                    : \Object = MDIGadget           (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag) 
        CompilerEndIf
      Case "ScintillaGadget"     : \type = #PB_GadgetType_Scintilla     : \Object = ScintillaGadget     (#PB_Any, \x,\y,\width,\height, \Param1)
      Case "ShortcutGadget"      : \type = #PB_GadgetType_Shortcut      : \Object = ShortcutGadget      (#PB_Any, \x,\y,\width,\height, \Param1)
      Case "CanvasGadget"        : \type = #PB_GadgetType_Canvas        : \Object = CanvasGadget        (#PB_Any, \x,\y,\width,\height, \flag)
    EndSelect
    
    ; Заносим данные объекта в памят
    If Bool(IsGadget(\Object) | IsWindow(\Object))
      If \Object$=""
        \Object$=Str(\Object)
        ParsePBObject()\Object$=\Object$
      EndIf
      
      ParsePBObject()\type = \type
      ParsePBObject()\Object = \Object
      
      If ParsePBObject()\parent<>\parent
        If \get(Str(\parent))\Object$
          \parent$ = \get(Str(\parent))\Object$
        EndIf
        ParsePBObject()\parent=\parent
        ParsePBObject()\parent$=\parent$
      EndIf
      If ParsePBObject()\window<>\window
        If \get(Str(\window))\Object$
          \window$ = \get(Str(\window))\Object$
        EndIf
        ParsePBObject()\window=\window
        ParsePBObject()\window$=\window$
      EndIf
      
      ; TODO -----------------------------------------
      If IsWindow(\Object)
        \parent =- 1
      EndIf
      
      Macro Init_object_data(_object_, _object_key_)
        If FindMapElement(*This\get(), _object_key_)
          *This\get(_object_key_)\Index=ListIndex(ParsePBObject())
          *This\get(_object_key_)\Adress=@ParsePBObject()
          
          *This\get(_object_key_)\Object=_object_ 
          *This\get(_object_key_)\Object$=*This\Object$ 
          
          *This\get(_object_key_)\type=*This\type 
          *This\get(_object_key_)\Type$=*This\Type$ 
          
          *This\get(_object_key_)\window=*This\window 
          *This\get(_object_key_)\parent=*This\parent 
          
          *This\get(_object_key_)\window$=*This\window$ 
          *This\get(_object_key_)\parent$=*This\parent$ 
        Else
          AddMapElement(*This\get(), _object_key_)
          *This\get()\Index=ListIndex(ParsePBObject())
          *This\get()\Adress=@ParsePBObject()
          
          *This\get()\Object=_object_ 
          *This\get()\Object$=*This\Object$ 
          
          *This\get()\type=*This\type 
          *This\get()\Type$=*This\Type$ 
          
          *This\get()\window=*This\window 
          *This\get()\parent=*This\parent 
          
          *This\get()\window$=*This\window$ 
          *This\get()\parent$=*This\parent$ 
        EndIf
        
      EndMacro
      
      ; Количество однотипных объектов
      If Not FindMapElement(\get(), \Type$)
        AddMapElement(\get(), \Type$)
        \get()\Index=ListIndex(ParsePBObject())
        \get()\Adress=@ParsePBObject()
        \get()\Count+1 
      Else
        \get(\Type$)\Count+1 
      EndIf
      
      ; Количество однотипных объектов
      If Not FindMapElement(\get(), Str(\parent)+"_"+\Type$)
        AddMapElement(\get(), Str(\parent)+"_"+\Type$)
        \get()\Index=ListIndex(ParsePBObject())
        \get()\Adress=@ParsePBObject()
        \get()\Count+1 
      Else
        \get(Str(\parent)+"_"+\Type$)\Count+1 
      EndIf
      
      ; Чтобы по идентификатору 
      ; объекта получить все остальное
      Init_object_data(\Object, Str(\Object))
      
      ; Чтобы по классу
      ; объекта получить все остальное
      Init_object_data(\Object, \Object$)
      
    EndIf
    
    ; 
    Select \Type$
      Case "WindowGadget" : \window = EventWindow() : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel = 1
      Case "OpenWindow" : \window = \Object : \window$ = \Object$ : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel = 1
      Case "ContainerGadget", "ScrollAreaGadget" : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel + 1
      Case "PanelGadget" : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel + 1 
        If IsGadget(\parent) 
          \Item = GetGadgetData(\parent) 
        EndIf
        
      Case "CanvasGadget"
        If ((\flag & #PB_Canvas_Container)=#PB_Canvas_Container)
          \parent = \Object : \SubLevel + 1
          \Container = \type
        EndIf
        
      Case "UseGadgetList" 
        Debug "UseGadgetList( " + \Param1$ +" )"
        Debug "  "+*This\get(Str(\Param1))\Object$
        If IsWindow(\Param1) 
          \SubLevel = 1
          \window = \Param1
          \parent = \window
          Debug "    " + GetWindowTitle(\parent)
          UseGadgetList( WindowID(\parent) )
        ElseIf IsGadget(\Param1) 
         ; Debug "    " + wgTitle(\Param1)
          \parent = \Param1
          OpenGadgetList(\parent)
        EndIf
        
      Case "CloseGadgetList" 
        If IsGadget(\parent) : \SubLevel - 1 : CloseGadgetList() 
          \parent = *This\get(Str(\parent))\parent 
          If IsGadget(\parent) : \Item = GetGadgetData(\parent) : EndIf
        EndIf
        
      Case "OpenGadgetList"      
        \parent = \get(\Object$)\Object
        If IsGadget(\parent) : OpenGadgetList(\parent, \Param1) : EndIf
        
      Case "AddGadgetColumn"       
        Object=\get(\Object$)\Object
        If IsGadget(Object)
          AddGadgetColumn(Object, \Param1, \Caption$, \Param2)
        Else
          Debug " add column no_gadget "+\Object$
        EndIf
        
      Case "AddGadgetItem"   
        Object=\get(\Object$)\Object
        If IsGadget(Object) : \Item+1 : SetGadgetData(Object, \Item)
          AddGadgetItem(Object, \Param1, \Caption$, \Param2, \flag)
        Else
          Debug " add item no_gadget "+\Object$
        EndIf
        
      Default
        \Container = #PB_GadgetType_Unknown
        
    EndSelect
    
    ;
    If IsGadget(\parent)
      GetParent = \get(Str(\parent))\parent
    ElseIf IsWindow(\parent)
      \SubLevel = 1
    EndIf
    
    ;
    If \Object And IsGadget(\Object)
      ; Если объект контейнер, то есть (Panel;ScrollArea;Container;Canvas)
      If \Container
        ParsePBObject()\Container = \Container
        ParsePBObject()\SubLevel = \SubLevel - 1
        EnableGadgetDrop(\Object, #PB_Drop_Text, #PB_Drag_Copy)
        BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \window, \Object)
        
        If \Type$ = "WindowGadget"
          BindEvent(#PB_Event_Gadget, @CO_Events(), \window)
        EndIf
      Else
        ParsePBObject()\SubLevel = \SubLevel
      EndIf
      
      ; Итем родителя для создания в нем гаджетов
      If \Item : ParsePBObject()\Item=\Item-1 : EndIf
      
      ; Открываем гаджет лист на том родителе где создан данный объект.
      If \Object = \parent
        If IsWindow(GetParent) : CloseGadgetList() : UseGadgetList(WindowID(GetParent)) : EndIf
        If IsGadget(GetParent) : OpenGadgetList = OpenGadgetList(GetParent, ParsePBObject()\Item) : EndIf
      EndIf
      
      ;       Transformation::Create(ParsePBObject()\Object, ParsePBObject()\window, ParsePBObject()\parent, ParsePBObject()\Item, 5)
      ;        Transformation::Create(ParsePBObject()\Object, ParsePBObject()\parent, -1, 0, 5)
      ;       ButtonGadget(-1,0,0,160,20,Str(Random(5))+" "+\parent$+"-"+Str(\parent))
      ;       CallFunctionFast(@CO_Events())
      
      ; Посылаем сообщение, что создали гаджет.
      If \Type$ = "WindowGadget"
        ParsePBObject()\window = \window
        PostEvent(#PB_Event_Gadget, \window, \Object, #PB_EventType_Create, \Object)
      Else
        PostEvent(#PB_Event_Gadget, \window, \Object, #PB_EventType_Create, \parent)
      EndIf
      
      ; Закрываем ранее открытий гаджет лист.
      If \Object = \parent
        If IsWindow(GetParent) : OpenGadgetList(\parent) : EndIf
        If OpenGadgetList : CloseGadgetList() : EndIf
      EndIf
    EndIf
    
    ;
    If IsWindow(\Object)
      StickyWindow(\Object, #True)
      ParsePBObject()\Container = \Container
      ;       Transformation::Create(ParsePBObject()\Object, ParsePBObject()\window, ParsePBObject()\parent, ParsePBObject()\Item, 5)
      PostEvent(#PB_Event_Gadget, \Object, #PB_Ignore, #PB_EventType_Create)
      EnableWindowDrop(\Object, #PB_Drop_Text, #PB_Drag_Copy)
      
      BindEvent(#PB_Event_Create, @CO_Events(), \Object)
      BindEvent(#PB_Event_Gadget, @CO_Events(), \Object)
      BindEvent(#PB_Event_WindowDrop, @CO_Events(), \Object)
      BindEvent(#PB_Event_LeftClick, @CO_Events(), \Object)
    EndIf
    
    ProcedureReturn \Object
  EndWith
EndProcedure

Procedure.q CO_Flag(Arg$)
  Protected Flag$, I, String$
  
  For I = 0 To CountString(Arg$,"|")
    String$ = Trim(StringField(Arg$,(I+1),"|"))
    
    Select Asc(String$)
      Case '#', '0' To '9'
        Flag$+String$+"|"
      Default
        String$ = GetArguments(*This\Content\Text$, "(?:(\w+)\s*\(.*)?"+String$+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
        
        Flag$+String$+"|"
    EndSelect
  Next
  
 ; ProcedureReturn Flag::Value(Trim(Flag$, "|"))
EndProcedure

;-
Procedure CodePosition(Indent)
  Protected RegExID
  
  With *This
    ;     \parent$ = \get(Str(\parent))\Object$
    
    ; Получаем последнюю позицию идентификаторов в файле
    RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])("+\Object$+"(?:=-1)?)([^\s]\w+)?(?:\s+(\w+$))?")
    If RegExID
      If ExamineRegularExpression(RegExID, \Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          \get("Code")\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID)+
                                                      RegularExpressionMatchLength(RegExID)
          If Asc(\Object$) = '#'
            \get("Code")\Code("Code_Object")\Position + Len(#CRLF$+"EndEnumeration")
          EndIf
          Break
        Wend
      EndIf
      
      FreeRegularExpression(RegExID)
    EndIf
    
    ; Запоминаем последнюю позицию объекта
    \get(\Object$)\Code("Code_Function")\Position = \Content\Position+\Content\Length +Len(#CRLF$+Space(Indent))
    \get(\parent$)\Code("Code_Function")\Position=\get(\Object$)\Code("Code_Function")\Position
    
    Select \Type$
      Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
        \get(\parent$)\Code("Code_Function")\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
    EndSelect
    
    ;     Debug "               "+\parent$
    ;     Debug "               "+\get(Str(\parent))\Object$
  EndWith
EndProcedure

Procedure ParsePBFile(FileName.s)
  Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
  Protected state_id, state_class
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
    Protected Line, FindWindow, Text$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected Length = Lof(#File) 
    Protected *File = AllocateMemory(Length)
    
    
    If *File 
      ReadData(#File, *File, Length)
      *This\Content\Text$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
      
      ;If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|\\d|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:(\\w+)\\s*\\((\".*?\"|[^:]|.*?)\\))|(?:(\\w+)(|\\.\\w))\\s)", #PB_RegularExpression_Extended | Create_Reg_Flag) And
      If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
         CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
        
        
         With *This
            If ExamineRegularExpression(#RegEx_Function, \Content\Text$)
               While NextRegularExpressionMatch(#RegEx_Function)
                  
                  If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                     \Type$=RegularExpressionGroup(#RegEx_Function, 7)
                     \Args$ = Trim(RegularExpressionGroup(#RegEx_Function, 8))
                     
                     If RegularExpressionGroup(#RegEx_Function, 3)
                        \Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                     EndIf
                     
                     ; Если идентификатрор сгенерирован с #PB_Any то есть (Ident=PBFunction(#PB_Any))
                     If RegularExpressionGroup(#RegEx_Function, 3)
                        Protected Content_String$, Content_Length, Content_Position
                        \Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                        Content_String$ = RegularExpressionMatchString(#RegEx_Function)
                        Content_Length = RegularExpressionMatchLength(#RegEx_Function)
                        Content_Position = RegularExpressionMatchPosition(#RegEx_Function)
                     EndIf
                     
                     ; Debug ""+\Type$ +" <-> ("+ \Args$ +") <-> "+ \Object$
                     
                     If \Type$
                        ; Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                        Select \Type$
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
                              ParsePBObject()\Type$ = \Type$
                              ParsePBObject()\Content\String$ = Content_String$ + RegularExpressionMatchString(#RegEx_Function)
                              ParsePBObject()\Content\Length = Content_Length + RegularExpressionMatchLength(#RegEx_Function)
                              If Content_Position
                                 ParsePBObject()\Content\Position = Content_Position
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
                                          Select \Type$
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
                                                      If \Type$="OpenWindow"
                                                         \Object$ = Arg$+"_Window"
                                                      Else
                                                         \Object$ = Arg$+"_"+ReplaceString(\Type$, "Gadget","")
                                                      EndIf
                                                   Default
                                                      \Object$ = Arg$
                                                EndSelect
                                             Else
                                                state_id = 1 
                                             EndIf
                                             
                                             ParsePBObject()\Object$ = \Object$
                                             ; Получаем класс объекта
                                             \Class$ = \Object$ 
                                             ; Удаляем имя родителя
                                             \Class$ = ReplaceString(\Class$, \window$+"_", "")
                                             ; Сохраняем класс объекта
                                             ParsePBObject()\Class$ = \Class$
                                             
                                             ; 
                                             state_class = Bool(\Object$ <> \Class$)
                                             
                                          Case 2 : ParsePBObject()\x$ = Arg$
                                             MacroCoordinate(\x, Arg$)
                                             
                                          Case 3 : ParsePBObject()\y$ = Arg$
                                             MacroCoordinate(\y, Arg$)
                                             
                                          Case 4 : ParsePBObject()\width$ = Arg$
                                             MacroCoordinate(\width, Arg$)
                                             
                                          Case 5 : ParsePBObject()\height$ = Arg$
                                             MacroCoordinate(\height, Arg$)
                                             
                                          Case 6 
                                             \Caption$ = GetStr(Arg$)
                                             ParsePBObject()\Caption$ = \Caption$
                                             
                                          Case 7 : ParsePBObject()\Param1$ = Arg$
                                             Select \Type$ 
                                                Case "OpenWindow"      
                                                   \Param1$ = get_argument_string(Arg$)
                                                   
                                                   ; Если идентификаторы окон цыфри
                                                   If Val(\Param1$)
                                                      \Param1$+"_Window"
                                                   Else
                                                      \Param1$ = Arg$
                                                   EndIf
                                                   
                                                   \Param1 = *This\get(\Param1$)\Object
                                                   
                                                   If IsWindow(\Param1)
                                                      \Param1 = WindowID(\Param1)
                                                   EndIf
                                                   
                                                Case "SplitterGadget"      
                                                   \Param1 = *This\get(Arg$)\Object
                                                   
                                                Case "ImageGadget"      
                                                   Result = \Img(GetStr(Arg$))\Object 
                                                   If IsImage(Result)
                                                      \Param1 = ImageID(Result)
                                                   EndIf
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         \Param1 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 8 : ParsePBObject()\Param2$ = Arg$
                                             Select \Type$ 
                                                Case "SplitterGadget"      
                                                   \Param2 = *This\get(Arg$)\Object
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         \Param2 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 9 : ParsePBObject()\Param3$ = Arg$
                                             \Param3 = Val(Arg$)
                                             
                                          Case 10 
                                             ParsePBObject()\flag$ = Arg$
                                             \flag = CO_Flag(Arg$)
                                             
                                       EndSelect
                                       
                                    EndIf
                                 Wend
                              EndIf
                              
                              
                              Protected win = CallFunctionFast(@CO_Open())
                              
                              CodePosition(0)
                              
                              ; Записываем у родителя позицию конца добавления объекта
                              ; *This\get(*This\get(Str(*This\parent))\Object$)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                              ;   Debug "Load Code_Enumeration "+ *This\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *This\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *This\get(*This\window$)\Code("Code_Object")\Position
                              ;   Debug "  Load Code_Function "+ *This\get(Str(*This\parent))\Object$ +" "+ *This\get(*This\get(Str(*This\parent))\Object$)\Code("Code_Function")\Position
                              ;   Debug "    Code_Object"+ *This\get(*This\get(Replace$)\window$)\Code("Code_Object")\Position
                              ;   Debug "    Code_Function"+ *This\get(*This\get(Replace$)\parent$)\Code("Code_Function")\Position
                              
                              
                              \Object=-1
                              \Object$=""
                              \Param1 = 0
                              \Param2 = 0
                              \Param3 = 0
                              \Caption$ = ""
                              \flag = 0
                              
                           Case "UseGadgetList"
                              \Param1$ = get_argument_string(\Args$)
                              
                              ; Если идентификаторы окон цыфри
                              If Val(\Param1$)
                                 \Param1$+"_Window"
                              Else
                                 \Param1$ = \Args$
                              EndIf
                              
                              \Param1 = *This\get(\Param1$)\Object
                              
                              If IsWindow(\Param1)
                                 ;                         *This\get(\Object$)\Object = *This\get(Str(\Param1))\window
                                 Protected UseGadgetList = UseGadgetList(WindowID(\Param1))
                                 PushListPosition(ParsePBObject())
                                 ForEach ParsePBObject()
                                    If ParsePBObject()\Container=-1 
                                       If IsWindow(ParsePBObject()\Object) And 
                                          WindowID(ParsePBObject()\Object) = UseGadgetList
                                          *This\get(\Object$)\Object = ParsePBObject()\Object
                                       EndIf
                                    EndIf
                                 Next
                                 PopListPosition(ParsePBObject())
                                 UseGadgetList(UseGadgetList)
                                 
                              ElseIf IsGadget(\Param1)
                                 PushListPosition(ParsePBObject())
                                 change_current_object_from_id(\Param1)
                                 While PreviousElement(ParsePBObject())
                                    If ParsePBObject()\Container=-1 
                                       *This\get(\Object$)\Object = ParsePBObject()\Object
                                       Break
                                    EndIf
                                 Wend
                                 PopListPosition(ParsePBObject())
                                 
                              Else
                                 \Param1 = *This\get(\Param1$)\Object
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
                                             \Object$ = Arg$
                                             If Val(Arg$)
                                                PushListPosition(ParsePBObject())
                                                ForEach ParsePBObject()
                                                   If Val(ParsePBObject()\Object$) = Val(Arg$)
                                                      \Object$ = ParsePBObject()\Object$
                                                   EndIf
                                                Next
                                                PopListPosition(ParsePBObject())
                                             EndIf
                                             
                                             ;*This\get(Str(\parent))\Object$
                                             ;                                 \Object$ = *This\get(Str(\parent))\Object$
                                             
                                             
                                          Case 2 : \Param1 = Val(Arg$)  
                                          Case 3 : \Caption$=GetStr(Arg$)
                                          Case 4 : \Param2 = Val(Arg$)
                                          Case 5 : \flag$ = Arg$
                                             \flag = CO_Flag(Arg$)
                                             If Not \flag
                                                Select Asc(\flag$)
                                                   Case '0' To '9'
                                                   Default
                                                      \flag = CO_Flag(GetVarValue(Arg$))
                                                EndSelect
                                             EndIf
                                       EndSelect
                                    EndIf
                                 Wend
                              EndIf
                              
                              ;Debug " g "+\Object$ +" "+ Str(*This\get(\Object$)\Object)
                              CallFunctionFast(@CO_Open())
                              
                              
                              \Object =- 1
                              \Object$ = ""
                              \flag = 0
                              \Param1 = 0
                              \Param2 = 0
                              \Param3 = 0
                              \flag$ = ""
                              \Param1$ = ""
                              \Param2$ = ""
                              \Param3$ = ""
                              \Caption$ = ""
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
                                       PC_Add(*This, Index)
                                    EndIf
                                 Wend
                                 
                                 PC_Set(*This)
                              EndIf
                              
                        EndSelect
                        
                     EndIf
                     
                  EndIf
               Wend
               
            Else
               Debug "Nothing to extract from: " + \Content\Text$
               ProcedureReturn 
            EndIf
         EndWith
        
        
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


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1494
; FirstLine = 1490
; Folding = ----------------------------------------
; EnableXP
; DPIAware