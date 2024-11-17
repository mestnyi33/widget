XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Global *Button_0._S_Widget
  Global *Button_1._S_Widget
  #PB_Text_InLine = 0
  #PB_Text_Bottom = 2
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  CopyImage(10, 11 )
  ResizeImage(11,32,32)
    
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
    ;  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 12)))
  CompilerElse
    LoadFont(0, "Arial", 16)
    ; SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 9)))
  CompilerEndIf 
  
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)
    
    ;\\
    ForEach widget( )
      Resize(widget( ), #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore )
    Next
    
    ;\\
    ResizeGadget(GetCanvasGadget( Root( ) ), #PB_Ignore, #PB_Ignore, Width, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate))
  EndProcedure
  
  If Open(11, 0, 0, 150, 235, "ImageButton", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
    WindowBounds(11,150,235,#PB_Ignore,235)
    
    Button( 10,10,60,25,"text_right", #PB_Text_InLine,0)
    Button( 10,40,60,25,"text_left",#PB_Text_InLine|#PB_Text_Right,10)
    Button( 10,70,60,75,"text_top",#PB_Text_Bottom, 0);,32,32)
    Button( 10,150,60,75,"text_bottom",#Null,11)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack( ), 11)
    ResizeWindow(11, #PB_Ignore, #PB_Ignore, 300, #PB_Ignore)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 4
; Folding = --
; EnableXP