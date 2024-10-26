XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( WIDGET )
  OpenWindow(0, 0, 0, 600, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If Open(0, 30, 30, 540, 340)
    SetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
    
    Define vfs = #__window_caption_height+#__window_frame_size*2
    Define hfs = #__window_frame_size*2
  
    ;a_init(Root())
    ;Window(50,50,440-hfs,240-vfs,"window", #__window_systemmenu)
    ;MDI(50,50,440,240) : OpenList(widget())
    ;Container(50,50,440,240)
    ;ScrollArea(50,50,440,240, 800,500)
    ;Panel(50,50,440,240) : AddItem(widget(), -1, "panel")
    ;a_init(widget())
    ;SetColor(widget( ), #__color_back, $ff00ff00 )
    
    ;
    ;String(0,0,0,0,"", #__flag_autosize);|#__flag_transparent)
    Button(0,0,0,0,"button", #__flag_autosize)
    ;Window(0,0,0,0,"", #__window_systemmenu|#__flag_autosize, widget())
    ;Window(0,0,0,0,"", #__window_systemmenu|#__flag_autosize|#__flag_child, widget())
    ;MDI(0,0,0,0, #__flag_autosize)
    ;SetColor(widget( ), #__color_back, -1 )
    
    Debug ""+ WidgetWidth(widget()) +" "+ WidgetHeight(widget())
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; FirstLine = 4
; Folding = -
; EnableXP
; DPIAware