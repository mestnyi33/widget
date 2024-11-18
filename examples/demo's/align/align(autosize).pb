XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  OpenWindow(0, 0, 0, 600, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If OpenRoot(0, 30, 30, 540, 340)
    SetWidgetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
    a_init(root(), 20 )
    
    Define vfs = #__window_CaptionHeight+#__window_FrameSize*2
    Define hfs = #__window_FrameSize*2
  
    ;a_init(Root())
    ;Window(50,50,440-hfs,240-vfs,"window", #__window_systemmenu)
    ;MDIWidget(50,50,440,240) : OpenWidgetList(widget())
    ;ContainerWidget(50,50,440,240)
    ;ScrollAreaWidget(50,50,440,240, 800,500)
    ;PanelWidget(50,50,440,240) : AddItem(widget(), -1, "panel")
    ;a_init(widget())
    ;SetWidgetColor(widget( ), #__color_back, $ff00ff00 )
    
    ;
    ;StringWidget(0,0,0,0,"", #__flag_autosize);|#__flag_transparent)
    ButtonWidget(0,0,0,0,"button", #__flag_autosize)
    ;Window(0,0,0,0,"", #__window_systemmenu|#__flag_autosize, widget())
    ;Window(0,0,0,0,"", #__window_systemmenu|#__flag_autosize|#__flag_child, widget())
    ;MDIWidget(0,0,0,0, #__flag_autosize)
    ;SetWidgetColor(widget( ), #__color_back, -1 )
    
    Debug ""+ WidgetWidth(widget()) +" "+ WidgetHeight(widget())
    
    WaitCloseRoot( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 10
; Folding = -
; EnableXP
; DPIAware