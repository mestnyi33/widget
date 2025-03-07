
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
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
  
  If OpenWindow(0, 0, 0, 300, 300, "autosize", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    SetWindowColor( 0, $ff00ff)
  
    Open(0, 20,20 )
    SetColor(root(), #PB_Gadget_BackColor, $ff00ff00)
;     CloseGadgetList()
;     SplitterGadget(-1,20,20,260,260,GetCanvasGadget(root()), ButtonGadget(-1,0,0,0,0,""))
    
;     ;Window(0,0,0,0,"window", #__window_systemmenu|#__flag_autosize)
;     ;MDI(0,0,0,0, #__flag_autosize) : OpenList(widget())
;     ;Container(0,0,0,0, #__flag_autosize)
;     ; ScrollArea(0,0,0,0, 800,800,0, #__flag_autosize)
;     ;Panel(0,0,200, 200, #__flag_autosize) : AddItem(widget(), -1, "panel")
;     Tree(0,0,0,0, #__flag_autosize) : Define i : For i=0 To 15 : AddItem(widget(), -1, "943093029709234790237490623panel") : Next
;     ;Button(0,0,0,0,"button", #__flag_autosize)
;     
;    ; String(10, 10, 200, 65, "string gadget text");, #__flag_autosize)
;   
; ;     If ListSize(widget())
;       SetColor(widget(), #pb_gadget_backcolor, $ff00ff00)
;       SetColor(widget(), #__FrameColor, $ff0000ff)
; ;     Else
; ;       SetColor(root(), #pb_gadget_backcolor, $ff00ffff)
; ;       SetColor(root(), #__FrameColor, $ff00ff00)
; ;     EndIf
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 44
; FirstLine = 18
; Folding = -
; EnableXP