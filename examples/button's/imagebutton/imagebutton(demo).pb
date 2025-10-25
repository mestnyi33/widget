XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  test_draw_area = 1
   
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
    ForEach widgets( )
      Resize(widgets( ), #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore )
    Next
    
    ;\\
    ResizeGadget(GetCanvasGadget( root( ) ), #PB_Ignore, #PB_Ignore, Width, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate))
  EndProcedure
  
  Procedure TestButton( X,Y,Width,Height, Text.s, flags, round = 0)
      Protected *g._s_WIDGET
      ;*g = Button( X,Y,Width,Height, Text.s, #__align_text|flags, round) 
      *g = ComboBox( X,Y,Width,Height, flags) : AddItem( *g, -1, Text,1 ) : SetState( *g, 0 )
      ProcedureReturn *g
   EndProcedure
   
   
  If Open(11, 0, 0, 150, 235, "ImageButton", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
    WindowBounds(11,150,235,#PB_Ignore,235)
    ;a_init(root())
    
    TestButton( 10,10,60,25,"text_right", #__align_Image|#__Flag_left)    : SetImage(widget( ), 0)
    TestButton( 10,40,60,25,"text_left",#__align_Image|#__Flag_Right,10)  : SetImage(widget( ), 10)
    TestButton( 10,70,60,75,"text_top",#__align_Image|#__Flag_Bottom )    : SetImage(widget( ), 0)
    TestButton( 10,150,60,75,"text_bottom",#__align_Image|#__Flag_Top,10) : SetImage(widget( ), 11)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack( ), 11)
    ResizeWindow(11, #PB_Ignore, #PB_Ignore, 300, #PB_Ignore)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 55
; FirstLine = 29
; Folding = --
; EnableXP