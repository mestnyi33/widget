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
  
;   *panel = Panel(10,150,200,160) 
;   AddItem(*panel,-1,"Panel") 
;   *p_0 = Button(30,90,160,30,"Button >>(Panel (0))") 
;   AddItem(*panel,-1,"Second") 
;   *p_1 = Button(35,90,160,30,"Button >>(Panel (1))") 
;   AddItem(*panel,-1,"Third") 
;   *p_2 = Button(40,90,160,30,"Button >>(Panel (2))") 
;   CloseList()
;   
;   *container = Container(215,150,200,160,#PB_Container_Flat) 
;   *c_0 = Button(30,90,160,30,"Button >>(Container)") 
;   CloseList()
  
  ;*w = Button(-30,10,160,70,"Button") 
  *w = Window(-30, 10,160,70,"Button", #PB_Window_NoGadgets) ;: closelist()
  *scrollarea = ScrollArea(200,150,200,160,200,160,10,#PB_ScrollArea_Flat) 
  *s_0 = Button(30,90,160,30,"Button >>(ScrollArea)") 
  CloseList()
  
  
  
  setparent(*w, *scrollarea)
  SetState(*scrollarea\scroll\h, 30)
;  setparent(*w, Root())
  
;   SetState(*scrollarea\scroll\h, 10)
;   setparent(*w, *scrollarea)
  
  Debug " screen - "+ x(*w, #__c_0)
  Debug " frame - "+ x(*w, #__c_1)
  Debug " inner - "+ x(*w, #__c_2)
  Debug " draw - "+ x(*w, #__c_4)
  Debug " window - "+ x(*w, #__c_8)
  Debug " container - "+ x(*w, #__c_3)
  Debug ""
  Debug " screen - "+ x(*s_0, #__c_0)
  Debug " frame - "+ x(*s_0, #__c_1)
  Debug " inner - "+ x(*s_0, #__c_2)
  Debug " draw - "+ x(*s_0, #__c_4)
  Debug " window - "+ x(*s_0, #__c_8)
  Debug " container - "+ x(*s_0, #__c_3)
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