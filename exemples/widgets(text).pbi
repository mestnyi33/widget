IncludePath "../"
XIncludeFile "widgets().pbi"
;XIncludeFile "widgets(_align_0_0_0).pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  UseModule constants
  
  Global g_canvas, *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    
    resize(*B_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore )
    resize(*B_2, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore )
    ResizeGadget(g_canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-160)
    
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Text.s = "строка_1"+Chr(10)+
  "строка__2"+Chr(10)+
  "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
  "строка_4"+#CRLF$+
  "строка__5";+#CRLF$
             ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
             ; Debug "len - "+Len(Text)
  
  If Open(0, 0, 0, 290, 760, "CanvasGadget", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g_canvas = getgadget(root())
    
    *B_0 = Text(0, 0, 200, 140, Text, #__text_center|#__text_top)
    *B_1 = Text(0, 150, 200, 140, Text, #__text_center|#__text_left)
    *B_2 = Text(0, 300, 200, 140, Text, #__text_center|#__text_Right)
    *B_3 = Text(0, 450, 200, 140, Text, #__text_center|#__text_Bottom)
    
    TextGadget(0, 10, 610, 200, 140, Text, #PB_Text_Border|#PB_Text_Center)
    ;   EditorGadget(4, 10, 220, 200, 200) : AddGadgetItem(10, -1, Text)
    ;SetGadgetFont(0,FontID)
    
    ResizeCallBack()
    ; ResizeWindow(0,WindowX(0)-180,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),0)
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
; ;   If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
; ;     ClearList(List())
; ;     
; ;     ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
; ;     TextGadget(0, 10, 10, 380, 330, Text.s) 
; ;     ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
; ;     
; ;     g=16
; ;     CanvasGadget(g, 10, 350, 380, 330) 
; ;     
; ;     *Text = Create(g, -1, 0, 0, 380, 330, Text.s);, #PB_Text_Center|#PB_Text_Middle);
; ;     SetColor(*Text, #PB_Gadget_BackColor, $FFCCBFB4)
; ;     SetColor(*Text, #PB_Gadget_FrontColor, $FFD56F1A)
; ;     SetFont(*Text, FontID(0))
; ;     
; ;     ; Get example
; ;     SetGadgetFont(0, GetFont(*Text))
; ;     SetGadgetColor(0, #PB_Gadget_BackColor, GetColor(*Text, #PB_Gadget_BackColor))
; ;     SetGadgetColor(0, #PB_Gadget_FrontColor, GetColor(*Text, #PB_Gadget_FrontColor))
; ;     
; ;     PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
; ;     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
; ;     
; ;     BindGadgetEvent(g, @Canvas_CallBack())
; ;     PostEvent(#PB_Event_Gadget, 0,g, #PB_EventType_Resize) ; 
; ;     
; ;     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; ;   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP