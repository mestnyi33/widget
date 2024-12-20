﻿
IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   
   Procedure Window_0_Resize( )
    ;  Debug 888
    ;  ResizeGadget(GetCanvasGadget(root()),#PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()), WindowHeight(EventWindow()) )
     ;  Resize( root(),#PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()), WindowHeight(EventWindow()) )
      ; PostEventRepaint( root())
   EndProcedure
   
   Define Window_0 = GetCanvasWindow( Open( 0, 20, 20, 200, 200, "test", #PB_Window_SizeGadget))
   
   ;Window( 20,20,160,160,"", #PB_Window_SizeGadget&~#PB_Window_TitleBar)
   ;SetBackgroundColor()
   ;Define Button_0 = Button( 200-50-5, 200-50-5, 50,  50, "right & bottom")
   Define Button_0 = Button( 5, 5, 50,  50, "right & bottom")
   
   ;SetAlign(Button_0, 0, 0,0,1,1 )
   ;SetAlign(Button_0, #__align_right|#__align_bottom )
   ;
   ;SetAlign(Button_0, #__align_auto, 0,0,1,1 )
   ;SetAlign(Button_0, #__align_auto|#__align_right|#__align_bottom )
   ;
   SetAlign(Button_0, #__align_auto, 0,0, -5,-5 )
   ReDraw( root() )
   
   ;While WaitWindowEvent(1000) : Wend ;:
   Delay(1000)
   
   BindEvent(#PB_Event_SizeWindow, @Window_0_Resize( ))
   ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,300)
   
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 19
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware