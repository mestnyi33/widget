;-TOP Dump Object Methods

; by mk-soft, 29.12.2019 - 06.11.2022, v1.08.2

Structure ArrayOfMethods
  i.i[0]
EndStructure

ImportC ""
  class_copyMethodList(*Class, *p_methodCount)
  ; -> An array of pointers of type Method describing
  ;    the instance methods implemented by the class
  ;    Any instance methods implemented by superclasses are Not included
  ;    You must free the array with free()
  class_getName(*Class) ; -> UnsafePointer<Int8> -> *string
  sel_getName(*Selector); -> const char *
  method_getName(*Method) ; -> Selector
  method_getTypeEncoding(*Method) ; -> const char *
  method_getReturnType(*Method, *dst, dst_len) ; -> void
  method_getNumberOfArguments(*Method)         ; -> unsigned int
  method_getArgumentType(*Method, index, *dst, dst_len) ; -> void
  
  NSGetSizeAndAlignment(*StringPtr, *p_size, *p_align) 
  ; -> const char *
  ;    Obtains the actual size and the aligned size of an encoded type.
EndImport

; ----

Procedure.s GetArgumentType(*String)
  Protected r1.s, arg.s, size.i, ofs.i
  
  arg = PeekS(*String, -1, #PB_UTF8)
  r1 + arg + " - "
  If Left(arg, 1) = "^"
    r1 + "A pointer to type of "
    arg = Mid(arg, 2)
  EndIf
  Select arg
    Case "c" : r1 + "A char "
    Case "i" : r1 + "An int "
    Case "s" : r1 + "A short "
    Case "l" : r1 + "A long "
    Case "q" : r1 + "A long long"
    Case "C" : r1 + "An unsigned char "
    Case "I" : r1 + "An unsigned int "
    Case "S" : r1 + "An unsigned short "
    Case "L" : r1 + "An unsigned long "
    Case "Q" : r1 + "An unsigned long long "
    Case "f" : r1 + "A float "
    Case "d" : r1 + "A double "
    Case "B" : r1 + "A C++ bool Or a C99 _Bool "
    Case "v" : r1 + "A void"
    Case "*" : r1 + "A character string (char *) "
    Case "@" : r1 + "An object (whether statically typed Or typed id) "
    Case "#" : r1 + "A class object (Class) "
    Case ":" : r1 + "A method selector (SEL) "
    Default:
      NSGetSizeAndAlignment(*String, @size, @ofs)
      r1 + "[" + Str(size) + " bytes]"
  EndSelect
  If Right(arg, 1) = "?"
    r1 + "An unknown type (e.g. function pointer)"
  EndIf
  ProcedureReturn r1
EndProcedure

; ----

Procedure.s DumpObjectMethods(*Object, SuperLevel = 0, HidePrivate = #True, ShowEncoding = #False, FirstArgument = 2)
  Protected r1.s, i, c, n, methodCount, Method.s
  Protected *Class, *SuperClass, *Method, *Methods.ArrayOfMethods
  Protected *String
  
  *Class = object_getclass_(*Object)
  If *Class
    *String = AllocateMemory(1024)
    r1 = PeekS(class_getName(*Class), -1, #PB_UTF8)
    If SuperLevel
      For i = 1 To SuperLevel
        *SuperClass = class_getsuperclass_(*Class)
        If *SuperClass
          *Class = *SuperClass
          r1 + " -> " + PeekS(class_getName(*Class), -1, #PB_UTF8)
        Else
          Break
        EndIf
      Next
    EndIf
    *Methods = class_copyMethodList(*Class, @methodCount)
    r1 + #LF$ + #LF$ + "Count of Methods: " + methodCount + #LF$ + #LF$
    For i = 0 To methodCount - 1
      
      *Method = *Methods\i[i];
      ;Debug ">>> "+*Method +
      Method = PeekS(sel_getName(method_getName(*Method)), -1, #PB_UTF8)
      If HidePrivate And Left(Method, 1) = "_"
        Continue
      EndIf
      r1 + "Method " + Method + #LF$
      If ShowEncoding
        r1 + " * Encoding " + PeekS(method_getTypeEncoding(*Method), -1, #PB_UTF8) + #LF$
      EndIf
      method_getReturnType(*Method, *String, 1024)
      r1 + " -- ReturnType = " + GetArgumentType(*String) + #LF$
      c = method_getNumberOfArguments(*Method)
      For n = FirstArgument To c - 1
        method_getArgumentType(*Method, n, *String, 1024)
        r1 + " -- Argument " + Str(n - FirstArgument + 1) + " = " + GetArgumentType(*String) + #LF$
      Next
      r1 + #LF$
    Next
    r1 + "End Class" + #LF$ + #LF$
    If *Methods
      free_(*Methods)
    EndIf
    FreeMemory(*String)
  Else
    r1 = "Object is nil" + #LF$
  EndIf
  ProcedureReturn r1
EndProcedure

; ****

;-TOP

Procedure UpdateWindow()
  Protected dx, dy
  dx = WindowWidth(0)
  dy = WindowHeight(0) - StatusBarHeight(0) - MenuHeight()
  ; Resize Gadgets
EndProcedure

Procedure Main()
  Protected dx, dy
  
  #WinStyle = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
  
  If OpenWindow(0, #PB_Ignore, #PB_Ignore, 600, 400, "Test Window", #WinStyle)
    ; MenuBar
    CreateMenu(0, WindowID(0))
    MenuTitle("File")
    
    ; StatusBar
    CreateStatusBar(0, WindowID(0))
    AddStatusBarField(#PB_Ignore)
    
    ; Gadgets
    dx = WindowWidth(0)
    dy = WindowHeight(0) - StatusBarHeight(0) - MenuHeight()
    
    ; Bind Events
    BindEvent(#PB_Event_SizeWindow, @UpdateWindow(), 0)
    
    NSCurrentCursor = CocoaMessage(0, 0, "NSCursor currentSystemCursor")
    ;Method image
    
;     Define methodCount
;     Define *Methods.ArrayOfMethods = class_copyMethodList(object_getclass_(NSCurrentCursor), @methodCount)
;     Debug PeekS(sel_getName(method_getName(*Methods\i[6])), -1, #PB_UTF8)
    Debug DumpObjectMethods(NSCurrentCursor)
    
    ; Main Loop
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Select EventWindow()
            Case 0
              Break
          EndSelect
          
        Case #PB_Event_Menu
          Select EventMenu()
            
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
              
          EndSelect
          
      EndSelect
    ForEver
    
  EndIf
  
EndProcedure : Main()

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP