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
XIncludeFile "module_editor_0_0.pb"


  ;- Example
;{

    EnableExplicit
    
    Global Window_0
    Global Canvas_0, Editor_0, Button_0
    
    Declare ResizeGadgetsWindow_0()
    
    Procedure OpenWindow_0(X = 0, Y = 0, Width = 690, Height = 470)
      Window_0 = OpenWindow(#PB_Any, X, Y, Width, Height, "MyEditor Gadget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
      ; Canvas_0 = CanvasGadget(#PB_Any, 10, 10, 670, 350, #PB_Canvas_Keyboard)
      Editor_0 = EditorGadget(#PB_Any, 10, 390, 670, 70)
      Button_0 = ButtonGadget(#PB_Any, 10, 360, 130, 30, "Close Editor")
    EndProcedure
    Procedure ResizeGadgetsWindow_0()
      Protected FormWindowWidth, FormWindowHeight
      FormWindowWidth = WindowWidth(Window_0)
      FormWindowHeight = WindowHeight(Window_0)
      ResizeGadget(Canvas_0, 10, 10, FormWindowWidth - 20, FormWindowHeight - 120)
      ResizeGadget(Editor_0, 10, FormWindowHeight - 80, FormWindowWidth - 20, 70)
      ResizeGadget(Button_0, 10, FormWindowHeight - 110, 130, 30)
    EndProcedure
    
    Global Font_0, Font_1, Font_2, Font_3
    Global Txt_1.s, txt.s, Editor, Style, i
    Global sep.s = #CRLF$ ; #LF$
    
    ;Txt_1 + "x" + sep + sep
    Txt_1 + sep + sep
    Txt_1 + "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789" + sep + sep
    Txt_1 + "The main features of PureBasic" + sep
    Txt_1 + "- x86, x64, 680x0 and PowerPC support" + sep 
    Txt_1 + "- Built-in arrays, dynamic lists, complex structures, pointers and variable definitions"  + sep
    Txt_1 + "- Supported types: Byte (8-bit), Word (16-bit), Long (32-bit), Quad (64-bit), Float (32-bit), Double (64-bit) and Characters"  + sep
    Txt_1 + "- User defined types (structures)"  + sep
    Txt_1 + "- Built-in string types (characters), including ascii and unicode"  ;+ sep
    Txt_1 + " 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789" + sep
    Txt_1 + "- Powerful macro support"  + sep
    Txt_1 + "- Constants, binary and hexadecimal numbers supported " + sep
    Txt_1 + "- Expression reducer by grouping constants and numeric numbers together " + sep
    Txt_1 + "- Standard arithmetic support in respect of sign priority and parenthesis: +, -, /, *, and, or, <<, >> " + sep
    Txt_1 + "- Extremely fast compilation " + sep
    Txt_1 + "- Procedure support for structured programming with local and global variables " + sep
    Txt_1 + "- All Standard BASIC keywords: If-Else-EndIf, Repeat-Until, etc " + sep
    Txt_1 + "- Specialized libraries to manipulate BMP pictures, windows, gadgets, DirectX, etc " + sep
    Txt_1 + "- Specialized libraries are very optimized for maximum speed and compactness " + sep
    Txt_1 + "- The Win32 API is fully supported as if they were BASIC keywords " + sep
    Txt_1 + "- Inline Assembler " + sep + sep
    Txt_1 + "- Precompiled structures with constants files for extra-fast compilation " + sep
    Txt_1 + "- Configurable CLI compiler " + sep
    Txt_1 + "PureBasic is a high-level programming language based on established BASIC rules. It is mostly compatible with any other BASIC compiler, whether it's for the Amiga or PC format. Learning PureBasic is very easy! PureBasic has been created for beginners and experts alike. Compilation time is extremely fast. This software has been developed for the Windows operating system. We have put a lot of effort into its realization to produce a fast, reliable and system-friendly language. " + sep
    Txt_1 + "The syntax is easy and the possibilities are huge with the advanced functions that have been added to this language like pointers, structures, procedures, dynamic lists and much more. For the experienced coder, there are no problems gaining access to any of the legal OS structures or Windows API objects. " + sep
    Txt_1 + "PureBasic is a portable programming language which currently works on AmigaOS, Linux, MacOS X and Windows computer systems. This means that the same code can be compiled natively for the OS and use the full power of each. There are no bottlenecks like a virtual machine or a code translator, the generated code produces an optimized executable. " + sep
    Txt_1 + "- Very high productivity, comprehensive keywords, online help " + sep
    Txt_1 + "- System friendly, easy to install and easy to use " + sep + sep
    
    
    ;Txt_1 = "a " + sep + " b"
    ;Txt_1 = "a" +#TAB$+ "bb" +#TAB$+ "ccc" +#TAB$+ "dddd" +#TAB$+ "eeeee" +#TAB$+ "ffffff"
    ;Txt_1 = sep + "a"
    ;Txt_1 = sep + "a" + sep
    ;Txt_1 = "- System friendly, easy to install and easy to use " + sep + sep
    ;Txt_1 = sep + "x" + sep + "a" + sep + sep
    ;Txt_1 = "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    ;Txt_1 = "a " + "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    
    ;Txt_1 = ReverseString(Txt_1)
    ;Txt_1 = "a " + "PureBasic is a high-level programming language based on established BASIC rules. It is mostly compatible with any other BASIC compiler" + sep
    
    ;Txt_1 = "Hello said"
    
    OpenWindow_0()
    
    Font_0 = LoadFont(#PB_Any, "Arial", 10)
    Font_1 = LoadFont(#PB_Any, "Courier New", 14 , #PB_Font_Bold|#PB_Font_Italic|#PB_Font_HighQuality)
    Font_2 = LoadFont(#PB_Any, "Tahoma", 12 , #PB_Font_Bold|#PB_Font_HighQuality)
    Font_3 = LoadFont(#PB_Any, "Impact", 18 , #PB_Font_HighQuality)
    
   ; Editor=editor::Create(Canvas_0, -1, 0, 0, GadgetWidth(Canvas_0), GadgetHeight(Canvas_0), "", #PB_Flag_FullSelection)
    Canvas_0 = editor::Gadget(-1, 10, 10, 670, 350);, #PB_Flag_FullSelection) 
    Editor=GetGadgetData(Canvas_0) 
    
    Editor::SetText(Editor, Txt_1)
    ; Editor::SetFont(Editor, FontID(Font_3))
    
   Repeat
        Select WaitWindowEvent()
            Case #PB_Event_SizeWindow
                ResizeGadgetsWindow_0()
;                 MyEditor::Resize(Editor, #PB_Ignore, #PB_Ignore, GadgetWidth(Canvas_0), GadgetHeight(Canvas_0))
                
            Case #PB_Event_Gadget
                
                Select EventGadget()
                    Case Canvas_0
                      ; MyEditor::ManageEvent(Editor, EventType())
;                      If Editor::CallBack(Editor, EventType())
;                        Text::ReDraw(Editor)
;                      EndIf
                     
;                     Case Button_0
;                         txt = MyEditor::CloseEditor(Editor)
;                         SetGadgetText(Editor_0, txt)
                EndSelect
                
            Case #PB_Event_CloseWindow
                Break
                
        EndSelect
    ForEver
    

;}
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP