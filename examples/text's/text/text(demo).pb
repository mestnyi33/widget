XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Global canvas_gadget, canvas_window, *B_0, *B_1, *B_2, *B_3
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      LoadFont(0, "Arial", 18)
   CompilerElse
      LoadFont(0, "Arial", 16)
   CompilerEndIf 
   
   Global min = 100
   Global Width = 200
   Global Text.s
   
   Procedure ResizeCallBack()
      Protected w = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-min
      
;       Resize(*B_0, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
;       Resize(*B_1, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
;       Resize(*B_2, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
;       Resize(*B_3, #PB_Ignore, #PB_Ignore, w, #PB_Ignore )
      
      ResizeGadget(0, #PB_Ignore, #PB_Ignore, w, #PB_Ignore)
      
      SetWindowTitle(EventWindow(), Str(w)+" - Text on the canvas")
   EndProcedure
   
   Text.s = "строка_1"+#CR$+
            Text.s + "строка__2"+#LF$+
            Text.s + "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
            Text.s + "строка_4"+#CRLF$+
            Text.s + "строка__5"
   
   ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
   If Open(0, 0, 0, Width+min, 760, "text multiline", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *B_0 = Text(10,  10, Width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_text_Top)
      *B_1 = Text(10, 160, Width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_text_left)
      *B_2 = Text(10, 310, Width, 140, Text, #PB_Text_Border|#PB_Text_Center|#PB_Text_Right)
      *B_3 = Text(10, 460, Width, 140, Text, #PB_Text_Border|#PB_Text_Center|#__flag_text_Bottom)
      
      SetAlign(*B_0, 0, 1,0,1,0)
      SetAlign(*B_1, 0, 1,0,1,0)
      SetAlign(*B_2, 0, 1,0,1,0)
      SetAlign(*B_3, 0, 1,0,1,0)
      
      ; bug 
      ;       SetAlign(*B_0, #__align_left|#__align_right)
      ;       SetAlign(*B_1, #__align_left|#__align_right)
      ;       SetAlign(*B_2, #__align_left|#__align_right)
      ;       SetAlign(*B_3, #__align_left|#__align_right)
      
      TextGadget(0, 10, 610, Width, 140, Text, #PB_Text_Border|#PB_Text_Center)
      ; EditorGadget(0, 10, 610, width, 140, #PB_Editor_WordWrap) : AddGadgetItem(0, -1, Text)
      ;SetAlign(0, 0, 1,0,1,0)
      
      ;PostEvent(#PB_Event_SizeWindow, canvas_window, - 1)
      BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),GetCanvasWindow() )
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 34
; Folding = -
; EnableXP
; DPIAware