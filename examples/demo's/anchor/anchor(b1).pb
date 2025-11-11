XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Define hfs = #__window_FrameSize*2
   Define vfs = #__window_CaptionHeight+hfs
   ;
   If Open(0, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #PB_Gadget_BackColor, RGBA(245, 245, 245, 255))
      ;
      ;\\
      a_init(root( ))
      ;a_init(Window(20,20,760-hfs,410-vfs,"window", #PB_Window_SystemMenu))
      ;a_init(MDI(20,20,760,410)) : OpenList(widget())
      ;a_init(Container(20,20,760,410))
      ;a_init(ScrollArea(20,20,760,410, 800,500))
      ;a_init(Panel(20,20,760,410)) : AddItem(widget(), -1, "panel")
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; DPIAware