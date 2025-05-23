﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  ;
  If Open(0, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor(root( ), #pb_gadget_backcolor, RGBA(245, 245, 245, 255))
    ;
    ;\\
    a_init(root( ))
    ;a_init(Window(40,40,720,370,"window", #PB_Window_systemmenu))
    ;a_init(MDI(40,40,720,370)) : OpenList(widget())
    ;a_init(Container(40,40,720,370))
    ;a_init(ScrollArea(40,40,720,370, 800,500))
    ;a_init(Panel(40,40,720,370)) : AddItem(widget(), -1, "panel")
    ;
    ;\\
    a_object(20, 20, 200, 100, "Layer = 1", RGBA(128, 192, 64, 125))
    a_object(320, 20, 200, 100, "Layer = 2", RGBA(192, 64, 128, 125))
    a_object(20, 320, 200, 100, "Layer = 3", RGBA(92, 64, 128, 125))
    a_object(320, 320, 200, 100, "Layer = 4", RGBA(192, 164, 128, 125))
    ;
    ;\\
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware