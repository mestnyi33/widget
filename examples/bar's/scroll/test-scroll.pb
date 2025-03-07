﻿
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  If Open(0, 0, 0, 250,240, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor(root(), #pb_gadget_backcolor, RGBA(244, 245, 233, 255))
    
    
    Define *g._S_WIDGET = Editor(20,20,200,100);, #__flag_autosize);|#__flag_transparent)
    AddItem(*g, -1, ~"define W_0 = form( 282, \"Window_0\" )")
    
    
    Debug *g\scroll\h\bar\button[1]\size
    
    WaitClose( )
  EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  Define vertical = 0
  
  ; Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
  
  If vertical
    ;\\ vertical
    If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *scroll1 = Scroll(20, 50, 50, 250,  0, 30, 0, #PB_ScrollBar_Vertical|#__flag_Invert)
      SetState(*scroll1, 5)
      
      Define *scroll2 = Scroll(80, 50, 50, 250,  5, 30, 15, #PB_ScrollBar_Vertical)
      SetState(*scroll2, 10)
      
      Define *scroll3 = Scroll(140, 50, 50, 250,  0, 30, 0, #PB_ScrollBar_Vertical)
      SetState(*scroll3, 5)
      
      
      WaitClose( )
    EndIf
  Else
    
    ;\\ horizontal
    If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *scroll1 = Scroll(50, 20, 250, 50,  0, 30, 0, #__flag_Invert)
      SetState(*scroll1, 5)
      
      Define *scroll2 = Scroll(50, 80, 250, 50,  5, 30, 15, 0, 55)
      SetState(*scroll2, 10)
      
      Define *scroll3 = Scroll(50, 140, 250, 50,  0, 30, 0)
      SetState(*scroll3, 5)
      
      
      WaitClose( )
    EndIf
  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; FirstLine = 4
; Folding = --
; EnableXP