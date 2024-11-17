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
  
  ;*w = Button(-30,10,160,70,"Button") 
  *w = Window(-30, 10,160,70,"Button", #PB_Window_NoGadgets) ;: closelist()
  
  *scrollarea = ScrollArea(200,150,200,160,200,160,10,#PB_ScrollArea_Flat) 
  *button = Button(31,90,160,30,"Button >>(ScrollArea)") 
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
  Debug "  screen - "+ X(*w, #__c_screen)
  Debug "  frame - "+ X(*w, #__c_frame)
  Debug "  inner - "+ X(*w, #__c_inner)
  Debug "  container - "+ X(*w, #__c_container)
  Debug "  required - "+ X(*w, #__c_required)
  Debug "  window - "+ X(*w, #__c_window)
  Debug "  draw - "+ X(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  screen - "+ X(*button, #__c_screen)
  Debug "  frame - "+ X(*button, #__c_frame)
  Debug "  inner - "+ X(*button, #__c_inner)
  Debug "  container - "+ X(*button, #__c_container)
  Debug "  required - "+ X(*button, #__c_required)
  Debug "  window - "+ X(*button, #__c_window)
  Debug "  draw - "+ X(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  screen - "+ X(*scrollarea, #__c_screen)
  Debug "  frame - "+ X(*scrollarea, #__c_frame)
  Debug "  inner - "+ X(*scrollarea, #__c_inner)
  Debug "  container - "+ X(*scrollarea, #__c_container)
  Debug "  required - "+ X(*scrollarea, #__c_required)
  Debug "  window - "+ X(*scrollarea, #__c_window)
  Debug "  draw - "+ X(*scrollarea, #__c_draw)
  Debug ""
  
  Debug "SIZE (width&height)"
  Debug "window "
  Debug "  frame - "+ Width(*w, #__c_frame)
  Debug "  inner - "+ Width(*w, #__c_inner)
  Debug "  container - "+ Width(*w, #__c_container)
  Debug "  required - "+ Width(*w, #__c_required)
  Debug "  draw - "+ Width(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  frame - "+ Width(*button, #__c_frame)
  Debug "  inner - "+ Width(*button, #__c_inner)
  Debug "  container - "+ Width(*button, #__c_container)
  Debug "  required - "+ Width(*button, #__c_required)
  Debug "  draw - "+ Width(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  frame - "+ Width(*scrollarea, #__c_frame)
  Debug "  inner - "+ Width(*scrollarea, #__c_inner)
  Debug "  container - "+ Width(*scrollarea, #__c_container)
  Debug "  required - "+ Width(*scrollarea, #__c_required)
  Debug "  draw - "+ Width(*scrollarea, #__c_draw)
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
; FirstLine = 40
; Folding = -
; EnableXP
; DPIAware