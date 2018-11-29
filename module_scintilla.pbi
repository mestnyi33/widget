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
;   Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
;   Declare.i Repaint(*This.Widget_S)
EndDeclareModule

Module Scintilla
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
    ProcedureReturn Editor::Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i)
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
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
  
  
  If OpenWindow(0, 0, 0, 422, 491, "ScintillaGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
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
    
    
    g=16
    Scintilla::Gadget(g, 8, 133+5+8, 306, 233, #PB_Text_WordWrap|#PB_Flag_GridLines|#PB_Flag_Numeric) 
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
; Folding = ofI9
; EnableXP