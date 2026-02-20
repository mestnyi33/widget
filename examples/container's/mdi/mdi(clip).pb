IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global._s_WIDGET *g
   
   
   If Open(0, 0, 0, 380, 400, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g = MDI(20, 20, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 7, 40, 120, 60)
      CloseList( )
      
      *g = MDI(200, 20, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 40, 0, 120, 60)
      CloseList( )
      
      ;
      *g = MDI(20, 135, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 7, - 40, 120, 60)
      CloseList( )
      
      *g = MDI(200, 135, 160,95)
      Resize(AddItem(*g, -1, "form_0"), - 40, 0, 120, 60)
      CloseList( )
      
      ;
      *g = MDI(20, 250, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 40, 1, 120, 47)
      CloseList( )
      
      *g = MDI(200, 250, 160,95)
      Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 40, 0, 120, 20)
      CloseList( )
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 40
; Folding = -
; EnableXP
; DPIAware