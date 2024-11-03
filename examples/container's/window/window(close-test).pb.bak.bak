XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  
  Global *window
  
    Open(#PB_Any, 150, 150, 500, 400, "demo close", #__Window_SizeGadget | #__Window_SystemMenu)
  Define *root._S_root = root()
  Define *widget._S_WIDGET
  
  *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  ;   AddElement(*root\_widgets( ))
  ;   *root\_widgets( ) = AllocateStructure(_S_WIDGET)
  ;   *root\_widgets( )\_root() = *root
  ;   *root\_widgets( )\_parent() = *root
  ;   *root\_widgets( )\class="button1"
  ;   *root\haschildren + 1
  ;*window = Button(10, 10, 90,30,"button")
  Free(*window)
;  *widget = AllocateStructure(_S_WIDGET)
;  *widget\class="button2"
; ;  AddElement(*root\_widgets( )) 
; ;   *root\_widgets( ) = *widget
; ;   *root\_widgets( )\_root() = *root
; ;   *root\_widgets( )\_parent() = *root
; ;    *root\haschildren + 1
;   SetParent2(*widget, *root)
  
  ;Debug Root()\last\widget
  *window = Button(10, 10, 90,30,"button")
  
  Debug " >> "
  ForEach widgets()
    Debug widgets()\class
  Next
  Debug "<<"
  
  
    
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 36
; FirstLine = 19
; Folding = -
; EnableXP