
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
  
    OpenRoot(0, 20,20 )
    SetWidgetColor(root(), #PB_Gadget_BackColor, $ff00ff00)
   
    ;Window(0,0,0,0,"window", #__window_systemmenu|#__flag_autosize)
    ;MDIWidget(0,0,0,0, #__flag_autosize) : OpenWidgetList(widget())
    ;ContainerWidget(0,0,0,0, #__flag_autosize)
    ; ScrollAreaWidget(0,0,0,0, 800,800,0, #__flag_autosize)
    ;PanelWidget(0,0,200, 200, #__flag_autosize) : AddItem(widget(), -1, "panel")
    TreeWidget(0,0,0,0, #__flag_autosize) : Define i : For i=0 To 15 : AddItem(widget(), -1, "943093029709234790237490623panel") : Next
    ;ButtonWidget(0,0,0,0,"button", #__flag_autosize)
    
   ; StringWidget(10, 10, 200, 65, "string gadget text");, #__flag_autosize)
  
;     If ListSize(widget())
      SetWidgetColor(widget(), #__color_back, $ff00ff00)
      SetWidgetColor(widget(), #__color_frame, $ff0000ff)
;     Else
;       SetWidgetColor(root(), #__color_back, $ff00ffff)
;       SetWidgetColor(root(), #__color_frame, $ff00ff00)
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 32
; FirstLine = 13
; Folding = -
; EnableXP