XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  ; EnableExplicit
  UseWidgets( )
  
  test_align = 1
  Global canvas_gadget, canvas_window
  Global._s_WIDGET *B_0, *B_1, *B_2, *B_3, *B_4, *B_5, *B_6, *B_7, *B_8
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Define Text.s = "Text"
  Define width = 200
  
  If Open(0, 0, 0, width+20, 760, "test alignment text", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    canvas_gadget = GetGadget(Root())
    canvas_window = GetWindow(Root())
    
    *B_1 = Text(10,  10, width, 65, Text);, #__flag_Textleft)
    *B_2 = Text(10,  10+65+10, width, 65, Text, #__flag_Texttop)
    *B_3 = Text(10, 160, width, 65, Text, #__flag_Textright)
    *B_4 = Text(10, 160+65+10, width, 65, Text, #__flag_Textbottom)
    
    *B_5 = Text(10, 310, width, 65, Text, #__flag_Textcenter|#__flag_Textleft)
    *B_6 = Text(10, 310+65+10, width, 65, Text, #__flag_Textcenter|#__flag_Texttop)
    *B_7 = Text(10, 460, width, 65, Text, #__flag_Textcenter|#__flag_Textright)
    *B_8 = Text(10, 460+65+10, width, 65, Text, #__flag_Textcenter|#__flag_Textbottom)
    
    *B_9 = Text(10, 610, width, 140, Text, #__flag_Textcenter)
     
  
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DPIAware