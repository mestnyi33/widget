XIncludeFile "../../../widgets.pbi" 
; Define i
; For i = 0 To 32
;   Debug ""+i +" "+ Str( 2147483648 >> ( (i - 1) ) )
; Next

;#__window_child          = #__flag_child
Debug #PB_Window_Normal         ; 0     ; 0
Debug #PB_Window_TitleBar       ; 8     ; 12582912   ; Creates a window with a titlebar.
Debug #PB_Window_SystemMenu     ; 4     ; 13107200   ; Enables the system menu on the window title bar (Default).
Debug #PB_Window_SizeGadget     ; 2     ; 12845056   ; Adds the sizeable feature To a window.
Debug #PB_Window_MinimizeGadget ; 32    ; 13238272   ; Adds the minimize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
Debug #PB_Window_MaximizeGadget ; 16    ; 13172736   ; Adds the maximize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
                                                     ; (MacOS only ; #PB_Window_SizeGadget will be also automatically added).
Debug #PB_Window_Invisible      ; 1     ; 268435456  ; Creates the window but don't display.
Debug #PB_Window_ScreenCentered ; 64    ; 1          ; Centers the window in the middle of the screen. x,y parameters are ignored.
Debug #PB_Window_WindowCentered ; 256   ; 2          ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified).
Debug #PB_Window_BorderLess     ; 128   ; 2147483648 ; Creates a window without any borders.
Debug #PB_Window_Tool           ; 2048  ; 4          ; Creates a window with a smaller titlebar And no taskbar entry. 
                                                     ;                 x,y parameters are ignored.
Debug #PB_Window_Maximize       ; 512   ; 16777216   ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
Debug #PB_Window_Minimize       ; 1024  ; 536870912  ;  Opens the window minimized.
Debug #PB_Window_NoGadgets      ; 4096  ; 8          ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
Debug #PB_Window_NoActivate     ; 8192  ; 33554432   ; Don't activate the window after opening.

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( ) 
  EnableExplicit
  
  Global *Button_0._s_widget
  Global *Button_1._s_widget
  Global *Button_2._s_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure _events_()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*4)
  
  If Open(0, 0, 0, 720+45, 405, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Define._s_widget *f_0, *f_1, *f_2, *f_3, *f_4, *f_5, *f_6, *f_7, *f_8, *f_9, *f_10, *f_11, *sp_0, *sp_1, *sc_0
    ;a_init( root( ) )
    
    *f_0 = window(10, 10, 180,  90, "form_0", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    button(10, -10, 80, 40, "Butt_0")
    ;*f_0\fs = 10
    
    ; set_border_size()
    *f_0\bs = 10
    Resize(*f_0, 0, 0, #PB_Ignore, #PB_Ignore)
    
    button(10, 40, 80, 40, "Butt_0")
    closelist()
    
    *f_1 = window(10, 10, 180,  90, "form_1", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    button(10, -10, 80, 40, "Butt_1")
    closelist()
    
    *f_2 = window(10, 10, 180,  90, "form_2", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    *f_3 = ScrollArea(10, 10, 180,  90, 250, 250, 1)
    ;*f_3 = window(10, 10, 180,  90, "form_3", *f_2)
    button(10, 0, 80, 40, "Butt_3")
    closelist()
    closelist()
    
    *sp_0 = splitter(0, 0, 0, 0, *f_1, *f_0, #__bar_vertical)
    *sp_1 = splitter(10, 10, 360, 360+25, *f_2, *sp_0)
    
    *f_4 = window(370+10, 10, 180,  70, "form_4 BorderLess", #__flag_BorderLess)
    button(5, 5, 80, 20, "Butt_4_0")
    *f_5 = window(370+10, 130+10, 180,  70, "form_6 SizeGadget", #PB_Window_SizeGadget)
    button(5, 5, 80, 20, "Butt_6_0")
    
    *f_6 = window(370+10, 130+10+130, 180,  70, "form_8 TitleBar", #PB_Window_TitleBar)
    button(5, 5, 80, 20, "Butt_8_0")
    
    *f_7 = window(370+10+190, 10, 180,  70, "form_5 SystemMenu", #PB_Window_SystemMenu)
    button(5, 5, 80, 20, "Butt_5_0")
    
    *f_8 = window(370+10+190, 130+10, 180,  70, "form_7 Minimize", #PB_Window_MinimizeGadget)
    button(5, 5, 80, 20, "Butt_7_0")
    
    *f_9 = window(370+10+190, 130+10+130, 180,  70, "form_9 Maximize", #PB_Window_MaximizeGadget)
    button(5, 5, 80, 20, "Butt_9_0")
    
  
    SetColor(*f_4, #__color_back, $CA00D7FF)
    SetColor(*f_5, #__color_back, $CA00D7FF)
    SetColor(*f_6, #__color_back, $CA00D7FF)

    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 83
; FirstLine = 63
; Folding = -
; EnableXP