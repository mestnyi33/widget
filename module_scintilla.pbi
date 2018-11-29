CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_editor.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule Scintilla
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  
  ;   ;- DECLARE
  ;   Declare GetState(*This.Widget_S)
  ;   Declare.s GetText(*This.Widget_S)
  ;   Declare SetState(*This.Widget_S, State.i)
  ;   Declare GetAttribute(*This.Widget_S, Attribute.i)
  ;   Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare AddItem(*This.Widget_S, Item, Text.s, Image.i=-1, Flag.i=0)
  ;   
  ;   Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  ;   Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(*This.Widget_S, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i Send(*This.Widget_S, message.i, param.i=0, lparam.i=0)
  
  ;   Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  ;   Declare.i Repaint(*This.Widget_S)
EndDeclareModule

Module Scintilla
  Procedure.i Send(*This.Widget_S, message.i, param.i=0, lparam.i=0)
    
    With *This
      Select message
        Case #SCI_SETCARETLINEVISIBLE
        Case #SCI_SETCARETLINEBACK  : \Row\Color\Back[1] = param
        Case #SCI_SETCARETLINEBACKALPHA : \Row\Alpha = param
          
        Case #SCI_SETMARGINWIDTHN : \sci\margin\width = lparam
          
        Case #SCI_SETSELALPHA : \Alpha = param
          
        Case #SCI_SETSELBACK
          Select param
            Case 1 : \Row\Color\Back[2] = lparam
              
          EndSelect
        Case #SCI_SETSELFORE
          Select param
            Case 1 : \Row\Color\Front[2] = lparam
              
          EndSelect
            
        Case #SCI_STYLESETBACK
          Select param
            Case #STYLE_DEFAULT : \Color\Back = lparam
            Case #STYLE_LINENUMBER : \sci\margin\Color\Back = lparam
              
          EndSelect
          
        Case #SCI_STYLESETFORE
          Select param
            Case #STYLE_DEFAULT : \Color\Front = lparam
            Case #STYLE_LINENUMBER : \sci\margin\Color\Front = lparam
              
          EndSelect
          
      EndSelect
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    ProcedureReturn Editor::SetFont(*This.Widget_S, FontID.i)
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,Flag.i=0)
    ProcedureReturn Editor::AddItem(*This.Widget_S,Item.i,Text.s,Image.i,Flag.i)
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    ProcedureReturn Editor::SetText(*This.Widget_S, Text.s, Item.i)
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected result.i = Editor::Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i)
    
    ProcedureReturn result
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Global Font_0, Font_1, Font_2, Font_3
  Font_0 = LoadFont(#PB_Any, "Arial", 10)
  Font_1 = LoadFont(#PB_Any, "Courier New", 14 , #PB_Font_Bold|#PB_Font_Italic|#PB_Font_HighQuality)
  Font_2 = LoadFont(#PB_Any, "Tahoma", 12 , #PB_Font_Bold|#PB_Font_HighQuality)
  Font_3 = LoadFont(#PB_Any, "Impact", 18 , #PB_Font_HighQuality)
  
  ;   Text.s = "This is a long line" + m.s +
  ;            "Who should show," + m.s +
  ;            "I have to write the text in the box or not." + m.s +
  ;            "The string must be very long" + m.s +
  ;            "Otherwise it will not work."
  Text.s="Scintilla is a free source code editing component. It comes with "+#CR$+
         "complete source code and a license that permits use in any project "+#CR$+
         "or product personal or commercial. The license may be viewed here. "+#CR$+
         "The source code, as well as the library documentation may be found "+#CR$+
         "on the Scintilla Homepage. From the Scintilla Homepage : As well As "+#CR$+
         "features found in standard text editing components, Scintilla includes "+#CR$+
         "features especially useful when editing And debugging source code."+#CR$+
         "These include support For syntax styling, error indicators, code "+#CR$+
         "completion And call tips.The selection margin can contain markers "+#CR$+
         "like those used in debuggers To indicate breakpoints and the current "+#CR$+
         "line.Styling choices are more open than With many editors, allowing the"+#CR$+
         " use of proportional fonts, bold And italics, multiple foreground "+#CR$+
         "and background colors And multiple fonts."+#CR$
  txtLen=StringByteLength(Text.s, #PB_UTF8)
  
  Procedure MakeUTF8Text(text.s)
    Static buffer.s
    buffer=Space(StringByteLength(text, #PB_UTF8))
    PokeS(@buffer, text, -1, #PB_UTF8)
    ProcedureReturn @buffer
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
  
  If OpenWindow(0, 0, 0, 522, 491, "ScintillaGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    ScintillaGadget(0, 8, 8, 306, 133, 0) ;: ScintillaSendMessage(0, #SCI_SETTEXT, 0, UTF8(Text.s)) ;: SetGadgetText(0, Text.s) 
    
    For a = 0 To 2
      String.s = "Line "+Str(a) + Chr(10) 
      ScintillaSendMessage(0, #SCI_APPENDTEXT, Len(String.s), UTF8(String.s))
      ;AddGadgetItem(0, a, "Line "+Str(a))
    Next
    String.s = "" + Chr(10)
    ScintillaSendMessage(0, #SCI_APPENDTEXT, Len(String.s), UTF8(String.s))
    ;AddGadgetItem(0, a, "")
    For a = 4 To 6
      String.s = "Line "+Str(a) + Chr(10) ;Chr(10) + "Line "+Str(a)
      ScintillaSendMessage(0, #SCI_APPENDTEXT, Len(String.s), UTF8(String.s))
      ;  AddGadgetItem(0, a, "Line "+Str(a))
    Next
    String.s = Text.s
    ScintillaSendMessage(0, #SCI_APPENDTEXT, Len(String.s), UTF8(String.s))
    
    ScintillaSendMessage(0, #SCI_STYLESETFONT,#STYLE_DEFAULT, @"Lucida Console")       ;Police à utiliser 
    ScintillaSendMessage(0, #SCI_STYLESETSIZE, #STYLE_DEFAULT, 16)                     ;Taille de la police
    ScintillaSendMessage(0, #SCI_STYLECLEARALL)
    ;SetGadgetFont(0, FontID(0))
    ScintillaSendMessage(0, #SCI_SETMARGINWIDTHN, 0, 30)
    
    ;{
    ; Set Text Mode
    ScintillaSendMessage(0, #SCI_SETWRAPMODE, #SC_WRAP_NONE)
    ScintillaSendMessage(0, #SCI_SETCODEPAGE, #SC_CP_UTF8)
    ScintillaSendMessage(0, #SCI_SETVIRTUALSPACEOPTIONS, #SCVS_RECTANGULARSELECTION | #SCVS_USERACCESSIBLE) ; allow cursor and rect selection to move beyond end of line
    ; Set Current Line Highlighting
    ScintillaSendMessage(0, #SCI_SETCARETLINEVISIBLE, 1)
    ScintillaSendMessage(0, #SCI_SETCARETLINEVISIBLEALWAYS, 1)
    ScintillaSendMessage(0, #SCI_SETCARETLINEBACKALPHA, 50)
    ScintillaSendMessage(0, #SCI_SETCARETLINEBACK, RGB(100, 252, 195))
    ; Set Text style
    ScintillaSendMessage(0, #SCI_STYLESETFONT, #STYLE_DEFAULT, MakeUTF8Text("Courier New")) ; rectangle selection works better with mono-width font
    ScintillaSendMessage(0, #SCI_STYLESETBACK, #STYLE_DEFAULT, RGB(70, 78, 85))
    ScintillaSendMessage(0, #SCI_STYLESETFORE, #STYLE_DEFAULT, RGB(195, 213, 255))
    ScintillaSendMessage(0, #SCI_STYLECLEARALL)
    ; Set Margin size and style
    ScintillaSendMessage(0, #SCI_STYLESETFONT, #STYLE_LINENUMBER, MakeUTF8Text("Arial"))
    ScintillaSendMessage(0, #SCI_STYLESETBACK, #STYLE_LINENUMBER, RGB(53, 55, 57))
    ScintillaSendMessage(0, #SCI_STYLESETFORE, #STYLE_LINENUMBER, RGB(200, 200, 200))
    ; marginWidth=ScintillaSendMessage(0, #SCI_TEXTWIDTH, #STYLE_LINENUMBER, MakeUTF8Text("_999"))
    ScintillaSendMessage(0, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER)
    ; ScintillaSendMessage(0, #SCI_SETMARGINWIDTHN, 0, marginWidth)
    marginWidth=0
    ScintillaSendMessage(0, #SCI_SETMARGINMASKN, 2, #SC_MASK_FOLDERS)
    ScintillaSendMessage(0, #SCI_SETMARGINWIDTHN, 2, marginWidth)
    ScintillaSendMessage(0, #SCI_SETMARGINSENSITIVEN, 2, #True)
    ; Set Main Caret and Selection
    ScintillaSendMessage(0, #SCI_SETCARETSTICKY, 1) ;make always visible
    ScintillaSendMessage(0, #SCI_SETCARETWIDTH, 3)  ;make thicker
    ScintillaSendMessage(0, #SCI_SETCARETFORE, RGB(255, 160, 136))
    ScintillaSendMessage(0, #SCI_SETSELALPHA, 128)
    ScintillaSendMessage(0, #SCI_SETSELBACK, 1, RGB(255, 160, 136))
    ScintillaSendMessage(0, #SCI_SETSELFORE, 1, RGB(200, 0, 200))
;     ; Set Additional Caret and Selection
;     ScintillaSendMessage(0, #SCI_SETADDITIONALCARETFORE, RGB(157, 64, 41))
;     ScintillaSendMessage(0, #SCI_SETADDITIONALCARETSBLINK, 1)
;     ScintillaSendMessage(0, #SCI_SETADDITIONALSELALPHA, 128)
;     ScintillaSendMessage(0, #SCI_SETADDITIONALSELBACK, RGB(255, 160, 136))
;     ScintillaSendMessage(0, #SCI_SETADDITIONALSELFORE, RGB(200, 200, 200))
;     ; Enable multi cursor editing
;     ScintillaSendMessage(0, #SCI_SETRECTANGULARSELECTIONMODIFIER, #SCMOD_ALT) ; select rectangle range by holding down the ALT key while dragging with the mouse
;     ScintillaSendMessage(0, #SCI_SETMULTIPLESELECTION, 1)                     ; select multiple ranges by holding down the CTRL or CMD key while dragging with the mouse
;     ScintillaSendMessage(0, #SCI_SETMULTIPASTE, #SC_MULTIPASTE_EACH)
;     ScintillaSendMessage(0, #SCI_SETADDITIONALSELECTIONTYPING, 1)
    
    ;}
    
    
    
    g=16
    Scintilla::Gadget(g, 8, 133+5+8, 306, 233, #PB_Flag_GridLines|#PB_Flag_Numeric) 
    *w=GetGadgetData(g)
    
    Scintilla::SetText(*w, Text.s) 
    
    For a = 0 To 2
      Scintilla::AddItem(*w, a, "Line "+Str(a))
    Next
    Scintilla::AddItem(*w, a, "")
    For a = 4 To 6
      Scintilla::AddItem(*w, a, "Line "+Str(a))
    Next
    Scintilla::SetFont(*w, FontID(0))
    
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    
    Scintilla::Send(*w, #SCI_SETSTYLING, Font_1, RGB(255, 215, 0))    ; style # 1
    Scintilla::Send(*w, #SCI_SETSTYLING, Font_2, RGB(205, 38, 38))    ; style # 2
    Scintilla::Send(*w, #SCI_SETSTYLING, Font_3, RGB(0, 250, 154))    ; style # 3
    
    ; Set Current Line Highlighting
    Scintilla::Send(*w, #SCI_SETCARETLINEVISIBLE, 1)
    Scintilla::Send(*w, #SCI_SETCARETLINEVISIBLEALWAYS, 1)
    Scintilla::Send(*w, #SCI_SETCARETLINEBACKALPHA, 50)
    Scintilla::Send(*w, #SCI_SETCARETLINEBACK, RGB(100, 252, 195))
    ; Set Text style
    Scintilla::Send(*w, #SCI_STYLESETFONT, #STYLE_DEFAULT, MakeUTF8Text("Courier New")) ; rectangle selection works better with mono-width font
    Scintilla::Send(*w, #SCI_STYLESETBACK, #STYLE_DEFAULT, RGB(70, 78, 85))
    Scintilla::Send(*w, #SCI_STYLESETFORE, #STYLE_DEFAULT, RGB(195, 213, 255))
    Scintilla::Send(*w, #SCI_STYLECLEARALL)
    ; Set Margin size and style
    Scintilla::Send(*w, #SCI_SETMARGINWIDTHN, 0, 30) 
    ; Scintilla::Send(*w, #SCI_STYLESETFONT, #STYLE_LINENUMBER, MakeUTF8Text("Arial"))
    Scintilla::Send(*w, #SCI_STYLESETBACK, #STYLE_LINENUMBER, RGB(53, 55, 57))
    Scintilla::Send(*w, #SCI_STYLESETFORE, #STYLE_LINENUMBER, RGB(200, 200, 200))
    ; Set Main Caret and Selection
    Scintilla::Send(*w, #SCI_SETCARETSTICKY, 1) ;make always visible
    Scintilla::Send(*w, #SCI_SETCARETWIDTH, 3)  ;make thicker
    Scintilla::Send(*w, #SCI_SETCARETFORE, RGB(255, 160, 136))
    Scintilla::Send(*w, #SCI_SETSELALPHA, 128)
    Scintilla::Send(*w, #SCI_SETSELBACK, 1, RGB(255, 160, 136))
    Scintilla::Send(*w, #SCI_SETSELFORE, 1, RGB(200, 0, 200))
    
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
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
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----
; EnableXP