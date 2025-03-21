﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  OpenWindow(0, 0, 0, 600, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If Open(0, 30, 30, 540, 340)
    SetColor(root(), #PB_Gadget_BackColor, RGBA(244, 245, 233, 255))
    ;a_init(root(), 20 )
    
    Define vfs = #__window_CaptionHeight+#__window_FrameSize*2
    Define hfs = #__window_FrameSize*2
  
    ;a_init(Root())
    ;Window(50,50,440-hfs,240-vfs,"window", #PB_Window_systemmenu)
    ;MDI(50,50,440,240) : OpenList(widget())
    ;Container(50,50,440,240)
    ;ScrollArea(50,50,440,240, 800,500)
    ;Panel(50,50,440,240) : AddItem(widget(), -1, "panel")
    ;a_init(widget())
    ;SetColor(widget( ), #pb_gadget_backcolor, $ff00ff00 )
    
    ;
    ;String(0,0,0,0,"", #__flag_autosize);|#__flag_transparent)
    Button(0,0,0,0,"button", #__flag_autosize)
    ;Window(0,0,0,0,"", #PB_Window_systemmenu|#__flag_autosize, widget())
    ;Window(0,0,0,0,"", #PB_Window_systemmenu|#__flag_autosize|#__flag_child, widget())
    ;MDI(0,0,0,0, #__flag_autosize)
    ;SetColor(widget( ), #pb_gadget_backcolor, -1 )
    
    Debug ""+ Width(widget()) +" "+ Height(widget())
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 29
; Folding = -
; EnableXP
; DPIAware