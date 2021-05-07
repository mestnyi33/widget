IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  
  Global Panel =- 1
  Global first1=-1,prev1=-1,next1=-1,last1=-1
  Global first2=-1,prev2=-1,next2=-1,last2=-1
  Global first3=-1,prev3=-1,next3=-1,last3=-1
  
  Procedure _Event()
    Select this()\event
      Case #PB_EventType_LeftClick 
        Select this()\widget
          Case first1, first2, first3
            SetPosition(this()\widget, #PB_List_First)
          Case prev1, prev2, prev3
            SetPosition(this()\widget, #PB_List_Before)
          Case next1, next2, next3
            SetPosition(this()\widget, #PB_List_After)
          Case last1, last2, last3
            SetPosition(this()\widget, #PB_List_Last)
        EndSelect
        
        ClearDebugOutput()
        debug_position()
    EndSelect
    
  EndProcedure
  
  
  If Open(OpenWindow(#PB_Any, 0,0, 250,160, "Demo Z-Order", #PB_Window_ScreenCentered))
    
    Panel = Panel(30,30,190,100);, "0")                                                               ;
    AddItem(Panel, -1, "tab_1")
    last1 = Button(110,30,50,35, "last1") : SetClass(widget(), GetText(widget()))                                                               ;
    next1 = Button(70,30,50,35, "next1") : SetClass(widget(), GetText(widget()))                                                                ;
    prev1 = Button(30,30,50,35, "prev1") : SetClass(widget(), GetText(widget()))                                                                ;
    first1 = Button(10,10,170,35, "first1") : SetClass(widget(), GetText(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_2") 
    last2 = Button(110,30,50,35, "last2") : SetClass(widget(), GetText(widget()))                                                               ;
    next2 = Button(70,30,50,35, "next2") : SetClass(widget(), GetText(widget()))                                                                ;
    prev2 = Button(30,30,50,35, "prev2") : SetClass(widget(), GetText(widget()))                                                                ;
    first2 = Button(10,10,170,35, "first2") : SetClass(widget(), GetText(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_3")
    last3 = Button(110,30,50,35, "last3") : SetClass(widget(), GetText(widget()))                                                               ;
    next3 = Button(70,30,50,35, "next3") : SetClass(widget(), GetText(widget()))                                                                ;
    prev3 = Button(30,30,50,35, "prev3") : SetClass(widget(), GetText(widget()))                                                                ;
    first3 = Button(10,10,170,35, "first3") : SetClass(widget(), GetText(widget()))                                                             ;
    
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