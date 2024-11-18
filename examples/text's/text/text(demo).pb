XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  Global canvas_gadget, canvas_window, *B_0, *B_1, *B_2, *B_3
  
  Procedure ResizeCallBack()
    Protected w = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65
    
    ResizeWidget(*B_0, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
    ResizeWidget(*B_1, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
    ResizeWidget(*B_2, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
    ResizeWidget(*B_3, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
    
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, w, #PB_Ignore)
 ;     ; ResizeGadget(canvas_gadget, #PB_Ignore, #PB_Ignore, w+10, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-160)
    
    SetWindowTitle(EventWindow(), Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  ;Debug   LoadFont(0, "", 13)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Text.s = "строка_1"+#CR$+
  Text.s + "строка__2"+#LF$+
  Text.s + "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
  Text.s + "строка_4"+#CRLF$+
  Text.s + "строка__5"
  
  ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
   Define width = 200
  If OpenRoot(0, 0, 0, width+90, 760, "text multiline", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    canvas_gadget = GetCanvasGadget(Root())
    canvas_window = GetCanvasWindow(Root())
    
    *B_0 = TextWidget(10,  10, width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_Texttop)
    *B_1 = TextWidget(10, 160, width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_Textleft)
    *B_2 = TextWidget(10, 310, width, 140, Text, #PB_Text_Border|#PB_Text_Center|#PB_Text_Right)
    *B_3 = TextWidget(10, 460, width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_Textbottom)
    
;     SetAlign(*B_0, #__align_left|#__align_right)
;     SetAlign(*B_1, #__align_left|#__align_right)
;     SetAlign(*B_2, #__align_left|#__align_right)
;     SetAlign(*B_3, #__align_left|#__align_right)
    
    TextGadget(0, 10, 610, width, 140, Text, #PB_Text_Border|#PB_Text_Center)
    ; EditorGadget(0, 10, 610, width, 140, #PB_Editor_WordWrap) : AddGadgetItem(0, -1, Text)
    
    ;PostEvent(#PB_Event_SizeWindow, canvas_window, - 1)
    BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),canvas_window )
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP