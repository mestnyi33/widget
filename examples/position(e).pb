XIncludeFile "../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *this._s_widget
  Global *current._s_widget
  
  #_First=99
  #PrevOne=100
  #NextOne=101
  #_Last=102
  
  Procedure Demo()
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 110, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 250, 110)
    
    Container(55, 60, 30, 45)                     ; Gadget(9,   
    Container(3, 20, 24-4, 25+6)   
    Container(3, 4, 17-8, 25+6)   
    CloseList()
    CloseList()
    CloseList()
    
    Button(55, 51, 170, 25, "8",#PB_Button_Right)  ; Gadget(8, 
    Button(55, 47, 150, 25, "7",#PB_Button_Right)  ; Gadget(7, 
    Button(55, 43, 130, 25, "6",#PB_Button_Right)  ; Gadget(6, 
    
    *this = Container(10, 15, 60, 80)              ; Gadget(10, 
    Container(10, 4, 60, 74-4)   
    Container(10, 4, 60, 68-8)   
    CloseList()
    CloseList()
    CloseList()
    *current = Button(55, 39, 110, 25, "5",#PB_Button_Right)  ; Gadget(5, 
    
    Button(55, 35, 90, 25, "4",#PB_Button_Right)  ; Gadget(4, 
    Button(55, 31, 70, 25, "3",#PB_Button_Right)  ; Gadget(3, 
    Button(55, 27, 50, 25, "2",#PB_Button_Right)  ; Gadget(2, 
    
    Container(55, 5, 30, 43)                     ; Gadget(1,
    Container(3, -3, 24-4, 25+6)   
    Container(3, -3, 17-8, 25+6)   
    CloseList()
    CloseList()
    CloseList()
    
    ResizeWindow(0,#PB_Ignore,WindowY(0)-130,#PB_Ignore,#PB_Ignore)
    ; BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
    
    OpenWindow(10, 0, 0, 250, 125, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#_Last, 5, 10, 240, 20, "last position gadget №10")
    ButtonGadget(#PrevOne, 5, 40, 240, 20, "prev position gadget №10")
    
    ButtonGadget(#NextOne, 5, 70, 240, 20, "next position gadget №10")
    ButtonGadget(#_First, 5, 100, 240, 20, "first position gadget №10")
  EndProcedure
  
  Demo()
  
  Define gEvent, gQuit
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            Select EventGadget()
              Case #_First
                SetPosition(*this, #PB_List_First)
                
              Case #PrevOne
                SetPosition(*this, #PB_List_Before)
                
              Case #NextOne
                SetPosition(*this, #PB_List_After)
                
              Case #_Last
                SetPosition(*this, #PB_List_Last)
                
            EndSelect
            Redraw(Root())
            
            ;               ClearDebugOutput()
            ;               Debug "first "+GetFirst(ParentID)
            ;               Debug "last "+GetLast(ParentID)
            ;               Debug "prev №1 < № "+GetPrev(1)
            ;               Debug "next №1 > № "+GetNext(1)
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP