IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseWidgets( )
  
  EnableExplicit
  
  Global *main._S_widget
  Global *w._S_widget
  Global *button._S_widget
  Global *scrollarea._S_widget
  
  Define X,Y,Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 613, 346, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  Open(10)
  *main = Window(200, 0, 413, 319+#__c_frame, "demo set  new parent", Flags )
  
  ;*w = ButtonWidget(-30,10,160,70,"Button") 
  *w = Window(-30, 10,160,70,"Button", #PB_Window_NoGadgets) ;: closelist()
  
  *scrollarea = ScrollAreaWidget(200,150,200,160,200,160,10,#PB_ScrollArea_Flat) 
  *button = ButtonWidget(31,90,160,30,"Button >>(ScrollArea)") 
  CloseList()
  
  
  
  SetParent(*w, *scrollarea)
  SetState(*scrollarea\scroll\h, 30)
;  setparent(*w, Root())
  
;   SetState(*scrollarea\scroll\h, 10)
;   setparent(*w, *scrollarea)
  
  ;\\ get required pos&size
  ReDraw( root( ) )
  
  ;\\
  Debug "POSITION (x&y)"
  Debug "window "
  Debug "  screen - "+ WidgetX(*w, #__c_screen)
  Debug "  frame - "+ WidgetX(*w, #__c_frame)
  Debug "  inner - "+ WidgetX(*w, #__c_inner)
  Debug "  container - "+ WidgetX(*w, #__c_container)
  Debug "  required - "+ WidgetX(*w, #__c_required)
  Debug "  window - "+ WidgetX(*w, #__c_window)
  Debug "  draw - "+ WidgetX(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  screen - "+ WidgetX(*button, #__c_screen)
  Debug "  frame - "+ WidgetX(*button, #__c_frame)
  Debug "  inner - "+ WidgetX(*button, #__c_inner)
  Debug "  container - "+ WidgetX(*button, #__c_container)
  Debug "  required - "+ WidgetX(*button, #__c_required)
  Debug "  window - "+ WidgetX(*button, #__c_window)
  Debug "  draw - "+ WidgetX(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  screen - "+ WidgetX(*scrollarea, #__c_screen)
  Debug "  frame - "+ WidgetX(*scrollarea, #__c_frame)
  Debug "  inner - "+ WidgetX(*scrollarea, #__c_inner)
  Debug "  container - "+ WidgetX(*scrollarea, #__c_container)
  Debug "  required - "+ WidgetX(*scrollarea, #__c_required)
  Debug "  window - "+ WidgetX(*scrollarea, #__c_window)
  Debug "  draw - "+ WidgetX(*scrollarea, #__c_draw)
  Debug ""
  
  Debug "SIZE (width&height)"
  Debug "window "
  Debug "  frame - "+ WidgetWidth(*w, #__c_frame)
  Debug "  inner - "+ WidgetWidth(*w, #__c_inner)
  Debug "  container - "+ WidgetWidth(*w, #__c_container)
  Debug "  required - "+ WidgetWidth(*w, #__c_required)
  Debug "  draw - "+ WidgetWidth(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  frame - "+ WidgetWidth(*button, #__c_frame)
  Debug "  inner - "+ WidgetWidth(*button, #__c_inner)
  Debug "  container - "+ WidgetWidth(*button, #__c_container)
  Debug "  required - "+ WidgetWidth(*button, #__c_required)
  Debug "  draw - "+ WidgetWidth(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  frame - "+ WidgetWidth(*scrollarea, #__c_frame)
  Debug "  inner - "+ WidgetWidth(*scrollarea, #__c_inner)
  Debug "  container - "+ WidgetWidth(*scrollarea, #__c_container)
  Debug "  required - "+ WidgetWidth(*scrollarea, #__c_required)
  Debug "  draw - "+ WidgetWidth(*scrollarea, #__c_draw)
  Debug ""
  
  Debug "----------"
  If StartEnum( root( ) )
    Debug ""+widget( )\class +" childrens - "+ widget( )\haschildren
    StopEnum( )
  EndIf

  Repeat
    Define Event = WaitWindowEvent()
    
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 39
; Folding = -
; EnableXP
; DPIAware