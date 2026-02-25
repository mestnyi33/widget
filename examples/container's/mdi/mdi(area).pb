IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   UseWidgets( )
   Global._s_WIDGET *g, *g1, *g2
   ;test_resize = 1
   ;test_iclip = 1
   ;test_focus_draw = 3
   test_draw_area = 1
   no_resize_mdi_child = 1
   
   
   If Open(0, 0, 0, 740, 480, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      a_init( Root( ))
      
      *g = MDI(20, 20, 160,95)
      *g2 = AddItem(*g, -1, "form_0")
      *g1 = AddItem(*g, -1, "form_1") 
      Resize(*g2, 30, 20, 120, 20)
      Resize(*g1, 40, -1, 120, 20)
      CloseList( )
      
      ;
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 15
; Folding = -
; EnableXP
; DPIAware