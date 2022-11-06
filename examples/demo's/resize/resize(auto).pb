
IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
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
  
  If OpenWindow(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Open(0, 20,20 )
    SetColor(root(), #PB_Gadget_BackColor, $ff00ff00)
   
    ;Window(0,0,0,0,"window", #__window_systemmenu|#__flag_autosize)
    ;MDI(0,0,0,0, #__flag_autosize) : OpenList(widget())
    Container(0,0,0,0, #__flag_autosize)
    ;ScrollArea(0,0,400, 591, 800,500,0, #__flag_autosize)
    ;Panel(0,0,0,0, #__flag_autosize) : AddItem(widget(), -1, "panel")
    SetColor(widget(), #PB_Gadget_BackColor, $ffff0000)
   
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP