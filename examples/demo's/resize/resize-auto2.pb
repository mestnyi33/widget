
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global._S_WIDGET *g
  
  Enumeration 
    #g_tree 
    #w_tree
    #g_splitter
    #g_splitter2
  EndEnumeration
  
  Procedure ResizeCallBack()
  EndProcedure
  
  Procedure SplitterCallBack()
  EndProcedure
  
  If Open(0, 0, 0, 400, 400, "autosize", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ;SetWindowColor( 0, $ff00ff)
  
    SetColor(Root(), #PB_Gadget_BackColor, $ff00ff00)
    a_init( Root())
    ScrollArea(50,50,300,300, 800,800,0)
    
    
    ;Window(0,0,0,0,"window", #PB_Window_systemmenu|#__flag_autosize)
    ;MDI(0,0,0,0, #__flag_autosize) : OpenList(widget())
    ;Container(0,0,0,0, #__flag_autosize)
    ; ScrollArea(0,0,0,0, 800,800,0, #__flag_autosize)
    ;Panel(0,0,200, 200, #__flag_autosize) : AddItem(widget(), -1, "panel")
    
    ;*g = Button(0,0,800,800,"button")
     *g = Button(0,0,0,0,"auto", #__flag_autosize)
;     
;     Repaint()
;     Debug Width( *g)
   ; String(10, 10, 200, 65, "string gadget text");, #__flag_autosize)
  
;     If ListSize(widget())
;       SetColor(widget(), #pb_gadget_backcolor, $ff00ff00)
;       SetColor(widget(), #__FrameColor, $ff0000ff)
;     Else
;       SetColor(root(), #pb_gadget_backcolor, $ff00ffff)
;       SetColor(root(), #__FrameColor, $ff00ff00)
;     EndIf
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 37
; FirstLine = 24
; Folding = -
; EnableXP