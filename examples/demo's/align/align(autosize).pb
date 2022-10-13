;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( WIDGET )
  
  If Open(OpenWindow(#PB_Any, 0, 0, 600, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    SetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
    
    ;a_init(Root())
    ;Window(50,50,500,300,"window", #__window_systemmenu)
    ;MDI(50,50,500,300) : OpenList(widget())
    Container(50,50,500,300)
    ;ScrollArea(50,50,500,300, 800,500)
    ;Panel(50,50,500,300) : AddItem(widget(), -1, "panel")
    ;a_init(widget())
    
    ;
    ;Button(0,0,0,0,"", #__flag_autosize)
    ;Window(0,0,0,0,"", #__window_systemmenu|#__flag_autosize, widget())
    MDI(0,0,0,0, #__flag_autosize)
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP