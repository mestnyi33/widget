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
   
   If Open(0, 0, 0, 560, 480, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g = MDI(20, 20, 160,95)
      ;Resize(AddItem(*g, -1, "form_0"), 7, 0, 120, 60)
      Resize(AddItem(*g, -1, "form_0"), - 40, 0, 120, 60)
      CloseList( )
      
      *g = MDI(200, 20, 160, 95)
      Resize(AddItem(*g, -1, "form_0"), - 40, -1, 120, 60)
      CloseList( )
      
      *g = MDI(380, 20, 160,95)
      *g1 = AddItem(*g, -1, "form_1") 
      *g2 = AddItem(*g, -1, "form_0")
      Resize(*g1, 40, -1, 120, 20)
      Resize(*g2, 30, 20, 120, 20)
      CloseList( )
      
      ;
      *g = MDI(20, 135, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 7, 40, 120, 60)
      CloseList( )
      
      *g = MDI(200, 135, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 40, 0, 120, 48)
      CloseList( )
      
      *g = MDI(380, 135, 160,95)
      *g2 = AddItem(*g, -1, "form_0")
      *g1 = AddItem(*g, -1, "form_1") 
      Resize(*g1, 40, -1, 120, 20)
      Resize(*g2, 30, 20, 120, 20)
      CloseList( )
      
      ;
      *g = MDI(20, 250, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 7, - 40, 120, 60)
      CloseList( )
      
      *g = MDI(200, 250, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 40, -1, 120, 20)
      CloseList( )
      
      *g = MDI(380, 250, 160,95)
      *g2 = AddItem(*g, -1, "form_0")
      *g1 = AddItem(*g, -1, "form_1") 
      Resize(*g2, 30, 20, 120, 20)
      Resize(*g1, 40, -1, 120, 20)
      CloseList( )
      
       ;
      *g = MDI(20, 365, 160,95)
      Resize(AddItem(*g, -1, "form_1"), 7, -1, 120, 48)
      CloseList( )
      
      *g = MDI(200, 365, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 40, 0, 120, 20)
      CloseList( )
      
      *g = MDI(380, 365, 160,95)
      *g1 = AddItem(*g, -1, "form_1") 
      *g2 = AddItem(*g, -1, "form_0")
      Resize(*g2, 30, 20, 120, 20)
      Resize(*g1, 40, -1, 120, 20)
      CloseList( )
      
      ;
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 15
; FirstLine = 4
; Folding = -
; EnableXP
; DPIAware