IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseLib(widget)
  
  EnableExplicit
  
  Global *w._S_widget, *combo
  Global *window_1._S_widget, *window_2._S_widget, *panel._S_widget, *container._S_widget, *scrollarea._S_widget
  Global *w_0, *d_0, *b_0, *b_1, *p_0, *p_1, *p_2, *c_0, *s_0
  Global *pb_0, *pb_1, *pb_2, *pb_3
  
  Define X,Y,Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 613, 346, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  Open(10)
  *window_1 = Window(200, 0, 413, 319+#__window_frame, "demo set  new parent", Flags )
  
  ;*w = Button(-30,10,160,70,"Button") 
  *w = Window(-30, 10,160,70,"Button", #PB_Window_NoGadgets) ;: closelist()
  *scrollarea = ScrollArea(200,150,200,160,200,160,10,#PB_ScrollArea_Flat) 
  *s_0 = Button(30,90,160,30,"Button >>(ScrollArea)") 
  CloseList()
  
  
  
  SetParent(*w, *scrollarea)
  SetState(*scrollarea\scroll\h, 30)
;  setparent(*w, Root())
  
;   SetState(*scrollarea\scroll\h, 10)
;   setparent(*w, *scrollarea)
  
  ReDraw(Root()) ; get required pos&size
  
  Debug "POSITION (x&y)"
  Debug "  screen - "+ x(*w, #__c_screen)
  Debug "  frame - "+ x(*w, #__c_frame)
  Debug "  inner - "+ x(*w, #__c_inner)
  Debug "  required - "+ x(*w, #__c_required)
  Debug "  clip - "+ x(*w, #__c_clip)
  Debug "  window - "+ x(*w, #__c_window)
  Debug "  container - "+ x(*w, #__c_container)
  Debug "  draw - "+ x(*w, #__c_draw)
  Debug ""
  Debug "  screen - "+ x(*s_0, #__c_screen)
  Debug "  frame - "+ x(*s_0, #__c_frame)
  Debug "  inner - "+ x(*s_0, #__c_inner)
  Debug "  required - "+ x(*s_0, #__c_required)
  Debug "  clip - "+ x(*s_0, #__c_clip)
  Debug "  window - "+ x(*s_0, #__c_window)
  Debug "  container - "+ x(*s_0, #__c_container)
  Debug "  draw - "+ x(*s_0, #__c_draw)
  Debug ""
  
  Debug "SIZE (width&height)"
  Debug "  frame - "+ width(*w, #__c_frame)
  Debug "  inner - "+ width(*w, #__c_inner)
  Debug "  required - "+ width(*w, #__c_required)
  Debug "  clip - "+ width(*w, #__c_clip)
  ;Debug "  draw - "+ width(*w, #__c_draw)
  Debug ""
  Debug "  frame - "+ width(*s_0, #__c_frame)
  Debug "  inner - "+ width(*s_0, #__c_inner)
  Debug "  required - "+ width(*s_0, #__c_required)
  Debug "  clip - "+ width(*s_0, #__c_clip)
  ;Debug "  draw - "+ width(*s_0, #__c_draw)
  Debug ""
  
;   Macro Enumerate()
;     GetChildrens(Root())
;   EndMacro
;   
;   ForEach Enumerate()
;     Debug Enumerate()\count\childrens
;   Next
  
  
  Repeat
    Define Event = WaitWindowEvent()
    
    ; repaint()
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP