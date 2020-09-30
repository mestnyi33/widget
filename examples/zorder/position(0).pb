IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  
  Global Panel =- 1
  Global _1_First=-1,_1_Prev=-1,_1_Next=-1,_1_Last=-1
  Global _2_First=-1,_2_Prev=-1,_2_Next=-1,_2_Last=-1
  Global _3_First=-1,_3_Prev=-1,_3_Next=-1,_3_Last=-1
  
  Procedure _Event()
    Select this()\event
      Case #PB_EventType_LeftClick 
        Select this()\widget
          Case _1_First, _2_First, _3_First
            SetPosition(this()\widget, #PB_List_First)
          Case _1_Prev, _2_Prev, _3_Prev
            SetPosition(this()\widget, #PB_List_Before)
          Case _1_Next, _2_Next, _3_Next
            SetPosition(this()\widget, #PB_List_After)
          Case _1_Last, _2_Last, _3_Last
            SetPosition(this()\widget, #PB_List_Last)
        EndSelect
        
        debug_position()
    EndSelect
    
  EndProcedure
  
  
  If Open(OpenWindow(#PB_Any, 0,0, 250,160, "Demo Z-Order", #PB_Window_ScreenCentered))
    
    Panel = Panel(30,30,190,100);, "0")                                                               ;
    AddItem(Panel, -1, "tab_1")
    _1_Last = Button(110,30,50,35, "_1_Last") : SetClass(widget(), GetText(widget()))                                                               ;
    _1_Next = Button(70,30,50,35, "_1_Next") : SetClass(widget(), GetText(widget()))                                                                ;
    _1_Prev = Button(30,30,50,35, "_1_Prev") : SetClass(widget(), GetText(widget()))                                                                ;
    _1_First = Button(10,10,170,35, "_1_First") : SetClass(widget(), GetText(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_2") 
    _2_Last = Button(110,30,50,35, "_2_Last") : SetClass(widget(), GetText(widget()))                                                               ;
    _2_Next = Button(70,30,50,35, "_2_Next") : SetClass(widget(), GetText(widget()))                                                                ;
    _2_Prev = Button(30,30,50,35, "_2_Prev") : SetClass(widget(), GetText(widget()))                                                                ;
    _2_First = Button(10,10,170,35, "_2_First") : SetClass(widget(), GetText(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_3")
    _3_Last = Button(110,30,50,35, "_3_Last") : SetClass(widget(), GetText(widget()))                                                               ;
    _3_Next = Button(70,30,50,35, "_3_Next") : SetClass(widget(), GetText(widget()))                                                                ;
    _3_Prev = Button(30,30,50,35, "_3_Prev") : SetClass(widget(), GetText(widget()))                                                                ;
    _3_First = Button(10,10,170,35, "_3_First") : SetClass(widget(), GetText(widget()))                                                             ;
    
    CloseList()
    
    debug_position()
    SetState(Panel, 1)
    Bind(#PB_All, @_Event())
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP