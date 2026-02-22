XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global ScrollStep = 1
   Global padding = 0
   Global size = 150
   Global AreaWidth = 350
   Global AreaHeight = 300
   
   If Open(0, 0, 0, 320+320, 320, "clip", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ScrollArea(10, 10, 300, 300, AreaWidth, AreaHeight, ScrollStep, #__flag_BorderLess)
      Container( padding, padding, size, size, #PB_Container_Flat): CloseList( )
      Container( AreaWidth-size-padding, AreaHeight-size-padding, size, size, #PB_Container_Flat): CloseList( )
      CloseList()
      
      Define *g = MDI(330, 10, 300, 300);, AreaWidth, AreaHeight, ScrollStep, #__flag_BorderLess)
      Resize(AddItem(*g, -1, "form_0"), padding, padding, size, size)
      Resize(AddItem(*g, -1, "form_1"), AreaWidth-size-padding, AreaHeight-size-padding, size, size)
      CloseList()
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 18
; Folding = -
; EnableXP
; DPIAware