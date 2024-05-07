IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseLib(widget)
  
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
  ReDraw( Root( ) )
  
  ;\\
  Debug "POSITION (x&y)"
  Debug "window "
  Debug "  screen - "+ x(*w, #__c_screen)
  Debug "  frame - "+ x(*w, #__c_frame)
  Debug "  inner - "+ x(*w, #__c_inner)
  Debug "  container - "+ x(*w, #__c_container)
  Debug "  required - "+ x(*w, #__c_required)
  Debug "  window - "+ x(*w, #__c_window)
  Debug "  draw - "+ x(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  screen - "+ x(*button, #__c_screen)
  Debug "  frame - "+ x(*button, #__c_frame)
  Debug "  inner - "+ x(*button, #__c_inner)
  Debug "  container - "+ x(*button, #__c_container)
  Debug "  required - "+ x(*button, #__c_required)
  Debug "  window - "+ x(*button, #__c_window)
  Debug "  draw - "+ x(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  screen - "+ x(*scrollarea, #__c_screen)
  Debug "  frame - "+ x(*scrollarea, #__c_frame)
  Debug "  inner - "+ x(*scrollarea, #__c_inner)
  Debug "  container - "+ x(*scrollarea, #__c_container)
  Debug "  required - "+ x(*scrollarea, #__c_required)
  Debug "  window - "+ x(*scrollarea, #__c_window)
  Debug "  draw - "+ x(*scrollarea, #__c_draw)
  Debug ""
  
  Debug "SIZE (width&height)"
  Debug "window "
  Debug "  frame - "+ width(*w, #__c_frame)
  Debug "  inner - "+ width(*w, #__c_inner)
  Debug "  container - "+ width(*w, #__c_container)
  Debug "  required - "+ width(*w, #__c_required)
  Debug "  draw - "+ width(*w, #__c_draw)
  Debug ""
  Debug "button "
  Debug "  frame - "+ width(*button, #__c_frame)
  Debug "  inner - "+ width(*button, #__c_inner)
  Debug "  container - "+ width(*button, #__c_container)
  Debug "  required - "+ width(*button, #__c_required)
  Debug "  draw - "+ width(*button, #__c_draw)
  Debug ""
  Debug "scrollarea "
  Debug "  frame - "+ width(*scrollarea, #__c_frame)
  Debug "  inner - "+ width(*scrollarea, #__c_inner)
  Debug "  container - "+ width(*scrollarea, #__c_container)
  Debug "  required - "+ width(*scrollarea, #__c_required)
  Debug "  draw - "+ width(*scrollarea, #__c_draw)
  Debug ""
  
  Debug "----------"
  If StartEnumerate( Root( ) )
    Debug ""+EnumWidget( )\class +" childrens - "+ EnumWidget( )\haschildren
    StopEnumerate( )
  EndIf

  Repeat
    Define Event = WaitWindowEvent()
    
    ; repaint()
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 95
; FirstLine = 73
; Folding = -
; EnableXP