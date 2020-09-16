IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  
  Enumeration 
  #__position_First
  #__position_Prev
  #__position_Next
  #__position_Last
EndEnumeration

  Global Window_1, Window_2, Window_3, Window_4, Window_3_Panel =- 1
  Global Panel_1_First=-1,Panel_1_Prev=-1,Panel_1_Next=-1,Panel_1_Last=-1
  Global Panel_2_First=-1,Panel_2_Prev=-1,Panel_2_Next=-1,Panel_2_Last=-1
  Global Panel_3_First=-1,Panel_3_Prev=-1,Panel_3_Next=-1,Panel_3_Last=-1
  
  Procedure Window_First_Event()
    Select this()\event
      Case #__event_LeftButtonDown : SetPosition(this()\event, #__position_First)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Prev_Event()
    Select this()\event
      Case #__event_LeftButtonDown : SetPosition(this()\event, #__position_Prev)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Next_Event()
    Select this()\event
      Case #__event_LeftButtonDown : SetPosition(this()\event, #__position_Next)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Last_Event()
    Select this()\event
      Case #__event_LeftButtonDown : SetPosition(this()\event, #__position_Last)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  
  Procedure _events()
    If this()\event = #__event_LeftClick
      Debug "e "+this()\event+" p "+GetParent(this()\event)
    EndIf
  EndProcedure
  
  
  Define i
  Define w = Open(OpenWindow(-1, 0,0, 700,350, "Demo Z-Order"))
  
  Window_3 = Window( 200,150,250,150, "Next", #__Window_SystemMenu, w);
  Window_4 = Window( 400,150,250,150, "Last", #__Window_SystemMenu, w);
  Window_2 = Window( 50,150,250,150, "Prev", #__Window_SystemMenu, w) ;
  Window_1 = Window( 10,10,680,150, "First", #__Window_SystemMenu, w) ;
  
  Bind(Window_1, @Window_First_Event(), #PB_All)
  Bind(Window_2, @Window_Prev_Event(), #PB_All)
  Bind(Window_3, @Window_Next_Event(), #PB_All)
  Bind(Window_4, @Window_Last_Event(), #PB_All)
  
  SetData(Window_1, #PB_Ignore)
  SetData(Window_2, #PB_Ignore)
  SetData(Window_3, #PB_Ignore)
  SetData(Window_4, #PB_Ignore)
  
  
  OpenList(Window_3)
  Window_3_Panel = Panel(30,10,190,100);, "Panel_0")                                                               ;
  AddItem(Window_3_Panel, -1, "Panel_1")
  Panel_1_Last = Button(110,30,50,35, "1_Last")                                                               ;
  Panel_1_Next = Button(70,30,50,35, "1_Next")                                                                ;
  Panel_1_Prev = Button(30,30,50,35, "1_Prev")                                                                ;
  Panel_1_First = Button(10,10,170,35, "1_First")                                                             ;
  
  Bind(Panel_1_First, @Window_First_Event(), #PB_All)
  Bind(Panel_1_Prev, @Window_Prev_Event(), #PB_All)
  Bind(Panel_1_Next, @Window_Next_Event(), #PB_All)
  Bind(Panel_1_Last, @Window_Last_Event(), #PB_All)
  
  
  AddItem(Window_3_Panel, -1, "Panel_2") 
  Panel_2_Last = Button(110,30,50,35, "2_Last")                                                               ;
  Panel_2_Next = Button(70,30,50,35, "2_Next")                                                                ;
  Panel_2_Prev = Button(30,30,50,35, "2_Prev")                                                                ;
  Panel_2_First = Button(10,10,170,35, "2_First")                                                             ;
  
  Bind(Panel_2_First, @Window_First_Event(), #PB_All)
  Bind(Panel_2_Prev, @Window_Prev_Event(), #PB_All)
  Bind(Panel_2_Next, @Window_Next_Event(), #PB_All)
  Bind(Panel_2_Last, @Window_Last_Event(), #PB_All)
  
  
  AddItem(Window_3_Panel, -1, "Panel_3")
  Panel_3_Last = Button(110,30,50,35, "3_Last")                                                               ;
  Panel_3_Next = Button(70,30,50,35, "3_Next")                                                                ;
  Panel_3_Prev = Button(30,30,50,35, "3_Prev")                                                                ;
  Panel_3_First = Button(10,10,170,35, "3_First")                                                             ;
  
  Bind(Panel_3_First, @Window_First_Event(), #PB_All)
  Bind(Panel_3_Prev, @Window_Prev_Event(), #PB_All)
  Bind(Panel_3_Next, @Window_Next_Event(), #PB_All)
  Bind(Panel_3_Last, @Window_Last_Event(), #PB_All)
  
  
  ;     AddItem(Window_3_Panel, -1, "Panel_4_long")
  ;     ; TODO 
  ;     ;Create(#_Type_Container, 10,10,150,55, "cont") 
  ;     Button(5,20,150,25, "butt") 
  ;     ;CloseList()
  ;     
  ;     AddItem(Window_3_Panel, -1, "Panel_5")
  ;     AddItem(Window_3_Panel, -1, "Panel_6")
  CloseList()
  CloseList()
  
  ;}
  
  WaitClose(w)
CompilerEndIf

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP