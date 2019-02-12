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
;UseModule Widget

;
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
IncludePath "/Users/as/Documents/GitHub/PureParser/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
IncludePath "G:\Documents\GitHub\PureParser"

CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf



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

;-
;- INCLUDE
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Caret.pbi"
XIncludeFile "include/Resize.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Disable.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Transformation.pbi"
XIncludeFile "include/Properties.pbi"


XIncludeFile "include/Helper/Splitter.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
        Macro PB(Function)
          Function
        EndMacro
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
  CompilerEndIf
  
  
;XIncludeFile "include/Scintilla.pbi"
Global WE_Code=-1, CodeShow.b


;-
;- GLOBAL
Global MainWindow=-1
Global Canvas_0, WE=-1, 
       WE_Menu_0=-1, 
       WE_PopupMenu_0=-1,
       WE_Selecting=-1, 
       WE_Objects=-1, 
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


Global Window_0, winBackColor = $FFFFFF
  Global NewMap Widgets.i()
  Global *Widget.Widget::Widget_S, *Parent.Widget::Widget_S, x,y
  
;-
;- DECLARE
Declare WE_Events(Event)
Declare WE_Resize()
Declare WE_Panel_0_Size()
Declare WE_Panel_1_Size()
Declare WE_Position_Selecting(Gadget, Parent)
Declare WE_Update_Selecting(Gadget, Position=-1)
Declare WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)

Declare$ GetObjectClass(Object)
Declare PC_Free(Object.i)

;-
;- MACRO
Macro ULCase(String)
  InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
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
Structure ArgumentStruct
  i.i 
  s.s
EndStructure

Structure ContentStruct
  File$
  Text$       ; Содержимое файла 
  String$     ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
  Position.i  ; Положение Content-a в исходном файле
  Length.i    ; длинна Content-a в исходном файле
EndStructure

Structure Code_S
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
  Position.i ; Code.Code_S
  Map Code.ContentStruct()
  
  Type.ArgumentStruct   ; Type\s.s = OpenWindow;ButtonGadget;TextGadget
  Class.ArgumentStruct  ; Class\s.s = Window_0;Button_0;Text_0
  Object.ArgumentStruct ; Object\s.s = Window_0;Window_0_Button_0;Window_0_Text_0
  Parent.ArgumentStruct
  Window.ArgumentStruct
EndStructure

Structure FONT
  Object.ArgumentStruct
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  Object.ArgumentStruct
  Name$
EndStructure

Structure ParseStruct Extends ObjectStruct
  Item.i
  SubLevel.i ; 
  Container.i
  Content.ContentStruct  
  
  X.ArgumentStruct 
  Y.ArgumentStruct
  Width.ArgumentStruct
  Height.ArgumentStruct
  Caption.ArgumentStruct
  Param1.ArgumentStruct
  Param2.ArgumentStruct
  Param3.ArgumentStruct
  Flag.ArgumentStruct
  
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
#Window$ = "W_"   
#Gadget$ = "G_"   

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
  Widget::SetText(WE_Scintilla_0, Text$)
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
Procedure WindowUpdate(Gadget)
  Protected x,y, Steps=4
  Protected w=GadgetWidth(Gadget)
  Protected h=GadgetHeight(Gadget)
  Protected CaptionGadget = GetGadgetData(Gadget)
  
  If IsGadget(CaptionGadget) And StartDrawing(CanvasOutput(CaptionGadget))
    Box(0, 0, OutputWidth(), OutputHeight(), $E6E6E6)
    Box(OutputWidth()-25, 5, 20, 15, $0030FF)
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(0, 0, w, h, $000000)
    Box(4, 24, w-8, h-4-25, $000000)
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(5+1, 3, PeekS(GetGadgetData(CaptionGadget)), $000000)
    StopDrawing()
  EndIf
  
  
  If StartDrawing(CanvasOutput(Gadget))
;     If w > OutputWidth()
;       w = OutputWidth()
;     EndIf
;     If h > OutputHeight()
;       h = OutputHeight()
;     EndIf
    
;     Box(0, 0, w, h, $000000)
;     Box(1, 1, w-2, h-2, $E6E6E6)
    Box(0, 0, w, h, $E6E6E6)
    
    For x = 0 To OutputWidth()-1
      For y = 0 To OutputHeight()-1
        Plot(x,y,$000000)
        y+Steps
      Next
      x+Steps
    Next
    
    StopDrawing()
  EndIf
  
  
;       ResizeGadget()
EndProcedure

Procedure WindowCallBack()
  Protected Gadget = EventGadget()
  Protected CaptionGadget = GetGadgetData(Gadget)
  
  Select EventType()
    Case #PB_EventType_Move
      ResizeGadget(CaptionGadget, GadgetX(Gadget)-1, GadgetY(Gadget)-1-25, GadgetWidth(Gadget)+2, GadgetHeight(Gadget)+25+2)
      
    Case #PB_EventType_Size
      ResizeGadget(CaptionGadget, GadgetX(Gadget)-1, GadgetY(Gadget)-1-25, GadgetWidth(Gadget)+2, GadgetHeight(Gadget)+25+2)
      WindowUpdate(Gadget)
      
  EndSelect
EndProcedure

Procedure ContainerCallBack()
  Protected x,y,Steps=4,w,h,Gadget = EventGadget()
  Protected CaptionGadget = GetGadgetData(Gadget)
  w=GadgetWidth(Gadget)
 h=GadgetHeight(Gadget)
 
  Select EventType()
    Case #PB_EventType_Move
;       ResizeGadget(CaptionGadget, GadgetX(Gadget), GadgetY(Gadget)-GadgetHeight(CaptionGadget), #PB_Ignore, #PB_Ignore)
;       ResizeGadget(CaptionGadget, #PB_Ignore, #PB_Ignore, GadgetWidth(Gadget), #PB_Ignore)
      
    Case #PB_EventType_Size
     If StartDrawing(CanvasOutput(Gadget))
    Box(0, 0, OutputWidth(), OutputHeight(), $E6E6E6)
    Box(OutputWidth()-25, 5, 20, 15, $0030FF)
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(0, 0, w, h, $000000)
    Box(4, 24, w-8, h-4-25, $000000)
    DrawingMode(#PB_2DDrawing_Transparent)
    ;DrawText(5+1, 3, PeekS(GetGadgetData(CaptionGadget)), $000000)
    StopDrawing()
  EndIf
  
  EndSelect
EndProcedure

Procedure WindowGadget(Gadget, X,Y,Width,Height, Text$="", Flag=0)
  Protected CaptionGadget = CanvasGadget(#PB_Any, x-1,y-1-25,Width+2 ,Height+25+2) 
  
  Protected GadgetID = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Container) 
  If Gadget =- 1 : Gadget = GadgetID : EndIf
  ;SetGadgetData(Gadget, @Text$)
  
  ;   SetGadgetData(Gadget, CanvasGadget(#PB_Any, 5,25, Width-10,Height-30, #PB_Canvas_Container)) : CloseGadgetList()
  ;   CloseGadgetList()
  SetGadgetData(Gadget, CaptionGadget)
  SetGadgetData(CaptionGadget, @Text$)
  
  WindowUpdate(Gadget)
  ;Resize::Gadget(Gadget)
  BindGadgetEvent(Gadget, @WindowCallBack())
  BindGadgetEvent(CaptionGadget, @ContainerCallBack())
  Resize::Gadget(CaptionGadget)
  
  ProcedureReturn Gadget
EndProcedure


;-
;- PARSER_CODE
Procedure PC_Add(*This.ParseStruct, Index)
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

Procedure PC_Set(*ThisParse.ParseStruct)
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


Procedure PC_Destroy()
  With ParsePBObject()
    ; Ищем идентификатор 
    Protected Identific$ = ","+#CRLF$+Space(Len("Global "))+\Object\s.s+"=-1"
    Protected RegExID = CreateRegularExpression(#PB_Any, Identific$)
    Protected len = Len(Identific$)
    
    If RegExID
      If ExamineRegularExpression(RegExID, *This\Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          *This\get(ParsePBObject()\Window\s.s)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)
          Break
        Wend
      EndIf
      
      *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, "")
      FreeRegularExpression(RegExID)
    EndIf
    
    ; Ищем функцию 
    ;ReplaceString(*This\Content\Text$, \Content\String$, Space(Len(\Content\String$)), #PB_String_InPlace, \Content\Position, 1)
    Identific$ = #CRLF$+Space(Indent)+\Content\String$
    
    If \Container
      Identific$ = Identific$+#CRLF$+Space(Indent)+"CloseGadgetList()"
    EndIf
    len = Len(Identific$)+len
    
    Debug Identific$
    
    Identific$ = ReplaceString(Identific$, "(", "\(")
    Identific$ = ReplaceString(Identific$, ")", "\)")
    RegExID = CreateRegularExpression(#PB_Any, Identific$)
    
    If RegExID
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position - len
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
      *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, "")
      FreeRegularExpression(RegExID)
    EndIf
    
    
    *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count-1 
    If *This\get(Str(\Parent\i.i)+"_"+\Type\s.s)\Count =< 0
      DeleteMapElement(*This\get(), Str(\Parent\i.i)+"_"+\Type\s.s)
    EndIf
    DeleteMapElement(*This\get(), \Object\s.s)
    DeleteMapElement(*This\get(), Str(\Object\i.i))
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
            If \Parent\i.i = Object 
              If \Container
                PC_Free(\Object\i.i)
                
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

;-
;- CREATE_OBJECT
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open()

Macro CO_Flag(Flag) ; Ok
  Properties::GetPBFlag(Flag)
EndMacro

Procedure CO_Update(Object.i)
  PushListPosition(ParsePBObject())
  If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
    With ParsePBObject()
      ParsePBObject()\Flag\s.s = Properties::GetCheckedText(Properties_Flag) 
    EndWith
  EndIf
  PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Change(Object.i)
  PushListPosition(ParsePBObject())
  If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
    With ParsePBObject()
      Properties::Init(\Object\i.i, \Object\s.s, \Flag\s.s)
      Transformation::Change(\Object\i.i)
    EndWith
  EndIf
  PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Free(Object.i)
  Protected i
  ;ProcedureReturn 
  
  ; Удаляем итем инспектора
  For i=0 To CountGadgetItems(WE_Selecting)-1
    If Object=GetGadgetItemData(WE_Selecting, i) 
      RemoveGadgetItem(WE_Selecting, i)
      Break
    EndIf
  Next 
  
  ; 
  PC_Free(Object)
  
  ; Удаляем якорья
  Transformation::Free(Object)
  
  ; Удаляем и объект
  If IsGadget(Object)
    FreeGadget(Object)
  ElseIf IsWindow(Object)
    CloseWindow(Object)
  EndIf
  
  WE_Code_Show(*This\Content\Text$)
  
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
      Debug 55555555555
      
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        With ParsePBObject()
          Transformation::Create(\Object\i.i, \Parent\i.i, \Window\i.i, \Item, 5)
          If IsGadget(\Object\i.i) And GadgetType(\Object\i.i) = #PB_GadgetType_Splitter
            Transformation::Free(GetGadgetAttribute(\Object\i.i, #PB_Splitter_FirstGadget))
            Transformation::Free(GetGadgetAttribute(\Object\i.i, #PB_Splitter_SecondGadget))
          EndIf
          Properties::Init(\Object\i.i, \Object\s.s, \Flag\s.s)
        EndWith
      EndIf
      
    Case #PB_Event_Gadget
      
      Select EventType()
        Case #PB_EventType_CloseItem ; Delete
          CO_Free(Object)
          
        Case #PB_EventType_Size
;           Debug GadgetWidth(EventGadget())
;           Debug GadgetHeight(EventGadget())
          
        Case #PB_EventType_StatusChange
          ; При выборе гаджета обнавляем испектор
          For I=0 To CountGadgetItems(WE_Selecting)-1
            If Object = GetGadgetItemData(WE_Selecting, I) 
              SetGadgetState(WE_Selecting, I)
              CO_Change(Object)
              Break
            EndIf
          Next  
              
      EndSelect
      
    Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
      If EventDropText() = "splittergadget"
        W_SH_Object = Object
        W_SH_Parent = EventWindow()
        W_SH_MouseX = WindowMouseX(W_SH_Parent)
        W_SH_MouseY = WindowMouseY(W_SH_Parent)
        
        DisableWindow(WE, #True)
        DisableWindow(WE_Code, #True)
        DisableWindow(W_SH_Parent, #True)
        W_SH_Open(WindowID(W_SH_Parent), #PB_Window_TitleBar|#PB_Window_WindowCentered)
        
        Protected Dim GadgetList.s(0)
        PushListPosition(ParsePBObject())
        ForEach ParsePBObject()
          If ParsePBObject()\Container>=0
            ReDim GadgetList(ListIndex(ParsePBObject())) 
            GadgetList(ListIndex(ParsePBObject())) = ParsePBObject()\Object\s.s
          EndIf
        Next
        PopListPosition(ParsePBObject())
        
        
        W_SH_Load(GadgetList())
        
;         SetWindowData(W_SH, @GadgetList())
;         
;         Protected Array GetWindow(1)  = GetWindowData(W_SH)
;         Dim ListGadget(0)
;         CopyArray(GetWindow, ListGadget(0))
;         
;         Debug ArraySize(ListGadget())
        
      Else
        CO_Create(ReplaceString(EventDropText(), "gadget", ""),
                  WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
      EndIf
      
      
  EndSelect
EndProcedure

Procedure CO_Insert(*ThisParse.ParseStruct, Parent)
  Protected ID$, Handle$
  CodeShow = 1
  
  With *ThisParse
    
    ; 
    Protected Variable$, VariableLength
    
    If \Type\s.s = "OpenWindow" Or \Type\s.s = "WindowGadget"
      Variable$ = #CRLF$+"Global.i "+\Object\s.s+"=-1"
    Else
      Variable$ = ","+#CRLF$+Space(Len("Global.i "))+\Object\s.s+"=-1"
    EndIf
    VariableLength = Len(Variable$)
    
    Debug "  Code_Global" + *This\get(*This\Window\s.s)\Code("Code_Global")\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, *This\get(*This\Window\s.s)\Code("Code_Global")\Position) 
    *This\get(*This\Window\s.s)\Code("Code_Global")\Position + VariableLength
    
    Debug "  Code_Object" + *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Object")\Position
    \Content\Position = *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Object")\Position  + VariableLength
    
    If VariableLength
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position + VariableLength
        EndIf
      Next
      PopListPosition(ParsePBObject())
    EndIf

    If Asc(\Object\s.s) = '#'
      ID$ = \Object\s.s
    Else
      Handle$ = \Object\s.s+" = "
      ID$ = "#PB_Any"
    EndIf
    
    Select \Type\s.s
        Case "OpenWindow", "WindowGadget"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                            : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf: If \Param1\s.s : \Content\String$ +", "+\Param1\s.s : EndIf
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
        Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s                       : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
        Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ \Param1\s.s+", "+\Param2\s.s+", "+\Param3\s.s  : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
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
    *This\get(*This\Window\s.s)\Code("Code_Object")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
    
    ; 
    If *This\Container
      ; Сохряняем у объект-а последную позицию.
      *This\get(\Object\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
      Debug \Object\s.s +" "+ *This\get(\Object\s.s)\Code("Code_Object")\Position 
      
      Select *This\Type\s.s
        Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
          ; 
          *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(Indent), *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))) 
          *This\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
          ; У окна меняем последную позицию.
          *This\get(*This\Window\s.s)\Code("Code_Object")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
      EndSelect
    
    Else
      If IsGadget(Parent)
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        Select ParsePBObject()\Container
          Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea, #PB_GadgetType_Canvas
            ; Проверяем позицию родителя в генерируемом коде
            If *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position>*This\Content\Position
              ; У родителя меняем последную позицию.
              *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
            EndIf
        EndSelect
      Next
      PopListPosition(ParsePBObject())
    EndIf
    
    EndIf
    
    ; Записываем у родителя позицию конца добавления объекта
    *This\get(*This\get(Str(Parent))\Object\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
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
      Case "WindowGadget" : \Type\s.s = "WindowGadget"
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
      
      If \Flag\s.s
        ParsePBObject()\Flag\s.s = \Flag\s.s
      EndIf
      
      \Flag\i.i=CO_Flag(ParsePBObject()\Flag\s.s)
      \Class\s.s+\get(Str(Parent)+"_"+\Type\s.s)\Count
      \Caption\s.s = \Class\s.s
      
      ; Формируем имя объекта
      ParsePBObject()\Class\s.s = \Class\s.s
      If \get(Str(Parent))\Object\s.s
        \Object\s.s = \get(Str(Parent))\Object\s.s+"_"+\Class\s.s
        ;\Object\s.s = #Gadget$+Trim(Trim(Trim(Trim(\get(Str(Parent))\Object\s.s, "W"), "_"), "G"), "_")+"_"+\Class\s.s
      Else
        \Object\s.s = \Class\s.s
        ;\Object\s.s = #Window$+\Class\s.s
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
      
      If \Type\s.s = "SplitterGadget"      
        \Param1\i.i = *This\get(\Param1\s.s)\Object\i.i
        \Param2\i.i = *This\get(\Param2\s.s)\Object\i.i
      EndIf
      
      ParsePBObject()\Param1\s.s = \Param1\s.s
      ParsePBObject()\Param2\s.s = \Param2\s.s
      ParsePBObject()\Param3\s.s = \Param3\s.s
      ParsePBObject()\Param1\i.i = \Param1\i.i
      ParsePBObject()\Param2\i.i = \Param2\i.i
      ParsePBObject()\Param3\i.i = \Param3\i.i
      
      ; Сначала определять кто есть кто.
      Select \Type\s.s
        Case "OpenWindow", "WindowGadget" 
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
        \get(\Window\s.s)\Code("Code_Global")\Position = 16
        \get(\get(Str(Parent))\Object\s.s)\Code("Code_Object")\Position = 249+75+2
      EndIf
      
      CO_Insert(*ThisParse, Parent) 
      \Parent\i.i = Parent
    EndIf
   
    Position = WE_Position_Selecting(WE_Selecting, Parent)
    
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
    
    WE_Update_Selecting(WE_Selecting, Position)
    
    
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
    Data.s "WindowGadget","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
    Data.s "OpenWindow","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
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
           "Declare Window_0_Events(Event.i)"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_CallBack()"+#CRLF$+
           "  Window_0_Events(Event())"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)"+#CRLF$+
           "  If IsWindow(Window_0)"+#CRLF$+
           "    SetActiveWindow(Window_0)"+#CRLF$+    
           "    ProcedureReturn Window_0"+#CRLF$+    
           "  EndIf"+#CRLF$+
           "  "+#CRLF$+  
           "  "+#CRLF$+  
           "  ProcedureReturn Window_0"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Events(Event.i)"+#CRLF$+
           "  Select Event"+#CRLF$+
           "    Case #PB_Event_Gadget"+#CRLF$+
           "      Select EventType()"+#CRLF$+
           "        Case #PB_EventType_LeftClick"+#CRLF$+
           "          Select EventGadget()"+#CRLF$+
           "             "+#CRLF$+            
           "          EndSelect"+#CRLF$+
           "      EndSelect"+#CRLF$+
           "  EndSelect"+#CRLF$+
           "  "+#CRLF$+
           "  ProcedureReturn Event"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
           "  Window_0_Open()"+#CRLF$+
           "  "+#CRLF$+  
           "  While IsWindow(Window_0)"+#CRLF$+
           "    Define.i Event = WaitWindowEvent()"+#CRLF$+
           "    "+#CRLF$+
           "    Select EventWindow()"+#CRLF$+
           "      Case Window_0"+#CRLF$+
           "        If Window_0_Events( Event ) = #PB_Event_CloseWindow"+#CRLF$+
           "          CloseWindow(Window_0)"+#CRLF$+
           "          Break"+#CRLF$+
           "        EndIf"+#CRLF$+
           "        "+#CRLF$+
           "    EndSelect"+#CRLF$+
           "  Wend"+#CRLF$+
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
      Case "WindowGadget"          : \Type\i.i =- 1  : \Window\i.i =- 1  
        \Flag\i.i = #PB_Canvas_Container
        ;\Object\i.i = CanvasGadget        (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, #PB_Canvas_Container) 
        \Object\i.i = Widget::Window(\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s) 
      Case "OpenWindow"          : \Type\i.i =- 1  : \Window\i.i =- 1  : \Object\i.i = OpenWindow          (#PB_Any, \X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i, \Param1\i.i)
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
      Case "WindowGadget" : \Window\i.i = EventWindow() : \Parent\i.i = \Object\i.i : \Container = \Type\i.i : \SubLevel = 1
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
        BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \Window\i.i, \Object\i.i)
        
        If \Type\s.s = "WindowGadget"
          BindEvent(#PB_Event_Create, @CO_Events(), \Window\i.i)
          BindEvent(#PB_Event_Gadget, @CO_Events(), \Window\i.i)
        EndIf
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
                \Window\i.i,
                \Object\i.i, #PB_All,
                \Parent\i.i)
      
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
          Case "OpenWindow", "WindowGadget"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\s.s+", "+\Y\s.s+", "+\Width\s.s+", "+\Height\s.s+", "+ Chr(34)+\Caption\s.s+Chr(34)                                                                                   : If \Flag\s.s : \Content\String$ +", "+\Flag\s.s : EndIf
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
      
      If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
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
                  If \Type\s.s = "OpenWindow"
                    \Type\s.s = "WindowGadget"
                    OpenGadgetList(WE_ScrollArea_0)
                  EndIf
                  
                  Select \Type\s.s
                    Case "OpenWindow","WindowGadget", 
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
                                  
                                Case "OpenWindow", "WindowGadget"
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
                                  If Val(Arg$)
                                    If \Type\s.s="OpenWindow"
                                      \Object\s.s = Arg$+"_Window"
                                    ElseIf \Type\s.s="WindowGadget"
                                      \Object\s.s = Arg$+"_Window"
                                    Else
                                      \Object\s.s = Arg$+"_"+ReplaceString(\Type\s.s, "Gadget","")
                                    EndIf
                                  Else
                                    \Object\s.s = Arg$
                                  EndIf
                                EndIf
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
                                  Case "OpenWindow", "WindowGadget"      
                                    \Param1\s.s = get_argument_string(Arg$)
                                    
                                    ; Если идентификаторы окон цыфри
                                    If Val(\Param1\s.s)
                                      \Param1\s.s+"_Window"
                                    ElseIf Val(\Param1\s.s)
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
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Flag\i.i = Val(Arg$)
                                  Default
                                    \Flag\i.i = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    If \Flag\i.i = 0
                                      Arg$ = GetVarValue(Arg$)
                                      \Flag\i.i = Val(Arg$)
                                    EndIf
                                    If \Flag\i.i = 0
                                      \Flag\i.i = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    EndIf
                                EndSelect
                                ParsePBObject()\Flag\s.s = Arg$
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      If \Type\s.s = "WindowGadget"
                        \X\i.i = 30
                        \Y\i.i = 30
                        *This\Parent\i.i = WE_ScrollArea_0
                      EndIf
                      
                      ; Сначала определять кто есть кто.
                      Select *This\Type\s.s
                        Case "WindowGadget" 
                          *This\Container =- 1 
                          *This\Window\s.s = "WE"
                          *This\Parent\s.s = *This\Object\s.s
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
; ;                            *This\get(*This\Window\s.s)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)-Len(#CRLF$)*2 ;*This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
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
                            *This\get(*This\Window\s.s)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)+Len(Identific$)
                            Break
                          Wend
                        EndIf
                        
                        FreeRegularExpression(RegExID)
                      EndIf
                      Debug *This\get(*This\Window\s.s)\Code("Code_Global")\Position
                      
                      ; Запоминаем последнюю позицию
                      If *This\Container
                        *This\get(*This\Object\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                        
                        Select *This\Type\s.s
                          Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
                            *This\get(*This\Window\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
                        EndSelect
                      Else
                        *This\get(*This\Window\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      EndIf
                      
; ; ;                       ; Записываем у родителя позицию конца добавления объекта
; ; ;                      ; *This\get(*This\get(Str(*This\Parent\i.i))\Object\s.s)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
; ; ;                       Debug "Load Code_Global"+ *This\get(Str(*This\Window\i.i))\Object\s.s +" "+ *This\get(*This\get(Str(*This\Window\i.i))\Object\s.s)\Code("Code_Global")\Position
; ; ;                       Debug "w Code_Object"+ *This\Window\s.s +" "+ *This\get(*This\Window\s.s)\Code("Code_Object")\Position
; ; ;                       Debug "Load Code_Object"+ *This\get(Str(*This\Parent\i.i))\Object\s.s +" "+ *This\get(*This\get(Str(*This\Parent\i.i))\Object\s.s)\Code("Code_Object")\Position
; ; ;                       ;     Debug "    Code_Global"+ *This\get(*This\get(Replace$)\Window\s.s)\Code("Code_Global")\Position
; ; ;                       ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Parent\s.s)\Code("Code_Object")\Position
                      
                      
                      
                      
                      
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
                        *This\get(\Object\s.s)\Object\i.i = *This\get(Str(\Param1\i.i))\Window\i.i
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
                                \Flag\i.i = CO_Flag(Arg$)
                                If Not \Flag\i.i
                                  Select Asc(\Flag\s.s)
                                    Case '0' To '9'
                                    Default
                                      \Flag\i.i = CO_Flag(GetVarValue(Arg$))
                                  EndSelect
                                EndIf
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
                            PC_Add(*This, Index)
                          EndIf
                        Wend
                        
                        PC_Set(*This)
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
                    AddGadgetItem(WE_Objects, -1, GadgetName, ImageID(GadgetImage))
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
Procedure WE_Position_Selecting(Gadget, Parent)
  Protected i, Position=-1 ; 
  
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

Procedure WE_Update_Selecting(Gadget, Position=-1)
  Protected i
  
  ; Добавляем объекты к списку
  If Position=-1
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      Position = CountGadgetItems(Gadget)
      AddGadgetItem (Gadget, -1, ParsePBObject()\Object\s.s, 0, ParsePBObject()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\i.i)
    Next
    PopListPosition(ParsePBObject())
  Else
    AddGadgetItem(Gadget, Position, ParsePBObject()\Object\s.s, 0, ParsePBObject()\SubLevel)
    SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\i.i)
    ;     SetGadgetItemImage(Gadget, Position, ImageID())
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
EndProcedure 

Procedure WE_Replace_ID(Gadget)
  Protected Object, i,Find$ = GetGadgetText(Gadget)
  Protected Replace$ = GetGadgetText(EventGadget())
  Protected RegExID, ParentClass$, len
  
  ; 
  If Replace$ And Find$ <> Replace$
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      If ParsePBObject()\Object\s.s = Find$
        ; Включаем и имя родителя при формировании имени объекта
        If *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s And 
           Not FindString(Replace$, *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s)
          Replace$ = *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s+"_"+Replace$
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
          ParentClass$ = *This\get(Str(ParsePBObject()\Parent\i.i))\Object\s.s
         
          *This\get(ParsePBObject()\Object\s.s)\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s
          *This\get(Str(ParsePBObject()\Object\i.i))\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s
          
          ; Меняем map ключ объекта
          CopyStructure(*This\get(ParsePBObject()\Object\s.s), *This\get(ParentClass$+"_"+ParsePBObject()\Class\s.s), ObjectStruct)
          ; И удаляем старый
          DeleteMapElement(*This\get(), ParsePBObject()\Object\s.s)
          
          ParsePBObject()\Object\s.s = ParentClass$+"_"+ParsePBObject()\Class\s.s 
          
          ; Обнавляем инспектор объектов
          For i=0 To CountGadgetItems(Gadget)-1
            If ParsePBObject()\Object\i.i=GetGadgetItemData(Gadget, i) 
              SetGadgetItemText(Gadget, i, ParsePBObject()\Object\s.s)
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
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Global")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get(*This\Window\s.s)\Code("Code_Global")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position + NbFound
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
    
;     Debug "    Code_Global"+ *This\get(*This\get(Replace$)\Window\s.s)\Code("Code_Global")\Position
;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Parent\s.s)\Code("Code_Object")\Position
    
    SetGadgetText(Gadget, Replace$)
    
    WE_Code_Show(*This\Content\Text$)
  EndIf
EndProcedure

Procedure WE_OpenFile(Path$) ; Открытие файла
  If Path$
    Debug "Открываю файл '"+Path$+"'"
    
    ; Начинаем перебырать файл
    If ParsePBFile(Path$)
      
      WE_Update_Selecting(WE_Selecting)
      
      CodeShow=1
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




Procedure ReDraw(Canvas)
    If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
      ;     DrawingMode(#PB_2DDrawing_Default)
      ;     Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      Widget::Draw(WE_Panel_1)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Widgets_CallBack()
    ; Debug ""+EventType() +" "+ WidgetEventType() +" "+ EventWidget() +" "+ EventGadget() +" "+ EventData()
    
    ;      Select EventWidget()
    ;       Case Widgets("Widgets") 
    Select WidgetEvent()
      Case #PB_EventType_StatusChange
        Select EventData()
          Case #PB_EventType_Focus
            Widget::SetState(Widgets("Inspector"), Widget::GetData(EventWidget()))
            
            Widget::SetItemText(Widgets("Properties"), 1, Widget::GetText(EventWidget()))
            Widget::SetItemText(Widgets("Properties"), 3, Str(Widget::X(EventWidget())))
            Widget::SetItemText(Widgets("Properties"), 4, Str(Widget::Y(EventWidget())))
            Widget::SetItemText(Widgets("Properties"), 5, Str(Widget::Width(EventWidget())))
            Widget::SetItemText(Widgets("Properties"), 6, Str(Widget::Height(EventWidget())))
            
          Case #PB_EventType_LostFocus
            
        EndSelect  
    EndSelect
    ;     EndSelect
    
    
    ; ReDraw(Canvas_0)
  EndProcedure
  
  Procedure CallBacks(*This.Widget::Widget_S, EventType, MouseX, MouseY)
    Protected *Widget.Widget::Widget_S
    Protected Item = Widget::GetState(*This)
    Protected Repaint 
    
    Repaint | Widget::CallBack(*This, EventType, MouseX, MouseY)
    
    With *This
      ForEach \Childrens()
        Repaint | CallBacks(\Childrens(), EventType, MouseX, MouseY)
      Next
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  
Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This.Widget::Widget_S
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Widget::Resize(WE_Panel_1, #PB_Ignore, #PB_Ignore, Width, Height)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        ; Repaint | CallBack(Widgets("Inspector_panel"), EventType(), MouseX, MouseY)
        
        ;           With Widgets()
        ;           ForEach Widgets()
        ;             ;           *Widgets = Widgets()
        ;             ;           If *Widgets\Text\String = "Button_0"
        ;             ;            Debug 55
        ;             ;           Else
        ;             Repaint | CallBack(Widgets(), EventType, MouseX, MouseY)
        Repaint | CallBacks(WE_Panel_1, EventType, MouseX, MouseY)
        ;             ;         EndIf
        ;             
        ;           Next
        ;         EndWith
        
    EndSelect
    
    ;Debug EventType
    
    ;     If WidgetEventType()>0
    ;       Widgets_CallBack()
    ;     EndIf
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
    
  EndProcedure
  
  Procedure Canvas_0_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
      ;       Static Last_X, Last_Y
      ;       If Last_Y <> Mousey
      ;         Last_Y = Mousey
      Result | Canvas_Events(EventGadget, EventType)
      ;       EndIf
      ;       If Last_x <> Mousex
      ;         Last_x = Mousex
      ;         Result | Canvas_Events(EventGadget, EventType)
      ;       EndIf
    Else
      Result | Canvas_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
;-
Procedure WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)
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
    
    WE_Selecting = TreeGadget(#PB_Any, 5, 5, 315, 145, #PB_Tree_AlwaysShowSelection)
    WE_Panel_0 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_0, -1, "Objects")
    WE_Objects = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(WE_Objects, #PB_Drop_Text, #PB_Drag_Copy)
    
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
    
    WE_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Selecting, WE_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(WE_Splitter_0, 145)
    
    
    ; Demo draw widgets on the canvas
    Canvas_0 = CanvasGadget(#PB_Any,  10, 40, 900, 600, #PB_Canvas_Keyboard)
    BindGadgetEvent(Canvas_0, @Canvas_0_CallBack())
    Widget::*value\gadget = Canvas_0
    Widget::*value\window = WE
    
    WE_Panel_1 = Widget::Panel(5, 159, 315, 261, Widget::#PB_Flag_AutoSize)
    
    Widget::AddItem(WE_Panel_1, -1, "Form")
    WE_ScrollArea_0 = Widget::ScrollArea(0, 0, 150, 150, 900, 800, 1, Widget::#PB_Flag_AutoSize)
    Widget::SetColor(WE_ScrollArea_0, #PB_Gadget_BackColor, $BEBEBE)
    Widget::CloseList()
    
    Widget::AddItem(WE_Panel_1, -1, "Code")
    WE_Scintilla_0 = Widget::Text(0, 0, 420, 600,"Тут будут строки кода", Widget::#PB_Flag_AutoSize)
    
    Widget::CloseList()
    
    WE_Splitter_1 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, Canvas_0, WE_Splitter_0, #PB_Splitter_SecondFixed|#PB_Splitter_Vertical)
    SetGadgetState(WE_Splitter_1, 900-300)
    
    LoadControls()
    WE_Panel_0_Size()
    WE_Panel_1_Size()
    
    ;;;WE_OpenFile("Ссылкодел.pb")
    
;     BindEvent(#PB_Event_Menu, @WE_Events(), WE)
;     BindEvent(#PB_Event_Gadget, @WE_Events(), WE)
    BindEvent(#PB_Event_SizeWindow, @WE_Resize(), WE)
    
    BindGadgetEvent(WE_Panel_0, @WE_Panel_0_Size(), #PB_EventType_Resize)
;     BindGadgetEvent(WE_Panel_1, @WE_Panel_1_Size(), #PB_EventType_Resize)
  EndIf
  
  ProcedureReturn WE
EndProcedure


Procedure WE_Panel_0_Size()
  Protected GadgetWidth = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(WE_Panel_0, GetGadgetState(WE_Panel_0))
    Case "Properties" : Properties::Size(GadgetWidth, GadgetHeight)
    Case "Objects"  : ResizeGadget(WE_Objects, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure WE_Panel_1_Size()
;   Protected GadgetWidth = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemWidth)
;   Protected GadgetHeight = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemHeight)
;   
;   Select GetGadgetItemText(WE_Panel_1, GetGadgetState(WE_Panel_1))
;     Case "Code" : ResizeGadget(WE_Scintilla_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
;     Case "Form" : ResizeGadget(WE_ScrollArea_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
;   EndSelect
EndProcedure

Procedure WE_Resize()
  Protected WindowWidth = WindowWidth(WE)
  Protected WindowHeight = WindowHeight(WE)-MenuHeight()
  ResizeGadget(WE_Splitter_1, 5, 5, WindowWidth - 10, WindowHeight - 10)
  WE_Panel_1_Size()
  WE_Panel_0_Size()
EndProcedure

Procedure WE_Close()
  Protected Result = #PB_Event_CloseWindow
  
  If *This\Content\Text$
    Select MessageRequester("WE", "Файл не был сохранен. Сохранить его сейчас?", #PB_MessageRequester_YesNo|#PB_MessageRequester_Warning) 
      Case #PB_MessageRequester_Yes
        ProcedureReturn PostEvent(#PB_Event_Menu, WE, WE_Menu_Save_as, #PB_All, #PB_Event_CloseWindow)
        
      Case #PB_MessageRequester_Cancel
        ProcedureReturn #False
    EndSelect
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure WE_Events(Event)
  Protected I, File$, SubItem, UseGadgetList
  Protected IsContainer.b, Object, Parent=-1
  
  Select Event
    Case #PB_Event_CloseWindow ;- Close(Event)
      
      ProcedureReturn WE_Close()
      ;-
    Case #PB_Event_Gadget ;- Gadget(Event)
      
      Select EventGadget()
        Case WE_Panel_0
          
          If EventType() = #PB_EventType_Change
            If GetGadgetText(EventGadget())="Events"
              Debug ""
              PushListPosition(ParsePBObject())
              ForEach ParsePBObject()
                Debug ParsePBObject()\Object\s.s +" "+ *This\get(ParsePBObject()\Object\s.s)\Code("Code_Object")\Position 
                
              Next
              PopListPosition(ParsePBObject())
            EndIf
          EndIf
          
        Case Properties_ID
          
          Select EventType()
            Case #PB_EventType_Change      
            ;Case #PB_EventType_LostFocus
              WE_Replace_ID(WE_Selecting)
              
          EndSelect
          
        Case Properties_Flag 
          
          Select EventType()
            Case #PB_EventType_LostFocus   
              CO_Update(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
          EndSelect
          
        Case WE_Selecting
          
          Select EventType()
            Case #PB_EventType_RightClick    
              Transformation::DisplayMenu(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
            Case #PB_EventType_Change     
              CO_Change(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
          EndSelect
          
        Case WE_Objects
          
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(WE_Objects, GetGadgetState(WE_Objects)))
          EndSelect
          
      EndSelect
      
      ;-  
    Case #PB_Event_Menu ;- Menu(Event)
      
      Select EventMenu()
        Case WE_Menu_Quit
          End
          
        Case WE_Menu_Delete ;- Event(_WE_Menu_Delete_) 
                            ; Debug EventGadget()
          CO_Free(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
          
        Case WE_Menu_Open ;- Event(_WE_Menu_Open_) 
          WE_OpenFile(OpenFileRequester("Выберите файл с описанием окон", *This\Content\File$, "Все файлы|*", 0))
          
        Case WE_Menu_Save_as ;- Event(_WE_Menu_Save_as_) 
          If Not WE_SaveFile("Test_0.pb") ; SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
            MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
          EndIf
          ProcedureReturn EventData()
          
        Case WE_Menu_Save ;- Event(_WE_Menu_Save_) 
          If Not WE_SaveFile(*This\Content\File$)
            If Not WE_SaveFile(SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
              MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
            EndIf
          EndIf
          
        Case WE_Menu_New ;- Event(_WE_Menu_New_)
          CO_Create("WindowGadget",30,30+20+30, WE_ScrollArea_0)
          ; CO_Create("Window",30,30)
          
          ;           WE_OpenFile("Window_0.pb")
          
          
          SetGadgetState(WE_Panel_0, 0)
          
          
      EndSelect
      
  EndSelect
  
  ProcedureReturn Event
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  ; Инициализация окна редактора
  MainWindow = WE_Open(0,#PB_Window_MinimizeGadget|#PB_Window_SizeGadget)
  
  If CountProgramParameters()=1 
    WE_OpenFile(ProgramParameter(0))
  EndIf
  
  While IsWindow(WE)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case WE
        If WE_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(WE)
          Break
        EndIf
        
      Case W_SH
        If W_SH_Events( Event ) = #PB_Event_CloseWindow
          DisableWindow(WE, #False)
          DisableWindow(WE_Code, #False)
          DisableWindow(W_SH_Parent, #False)
          
          Define Gadget1.String, Gadget2.String, Flag.String
          If W_SH_Return(@Gadget1, @Gadget2, @Flag)
            ;           Debug "Gadget1 "+Gadget1\s
            ;           Debug "Gadget2 "+Gadget2\s
            
            CO_Create(Gadget1\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
            Define First$ = *This\Object\s.s
            CO_Create(Gadget2\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
            Define Second$ = *This\Object\s.s
            
            *This\Param1\s.s = First$
            *This\Param2\s.s = Second$
            *This\Flag\s.s = Flag\s
            CO_Create("splitter", W_SH_MouseX, W_SH_MouseY, W_SH_Object)
            
          EndIf
          
          CloseWindow(W_SH)
        EndIf
        
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----v-----------------------------------------------------------8------
; EnableXP