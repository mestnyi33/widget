XIncludeFile "../../widgets.pbi" 


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
  
  Procedure   _SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
      Protected Type
      Protected result =- 1
      
      Protected *before._s_widget 
      Protected *after._s_widget 
      Protected *last._s_widget
      Protected *first._s_widget
      
      If *this = *widget_2
        ProcedureReturn 0
      EndIf
      
      Select Position
        Case #PB_List_First 
          *first = *this\parent\first
          
          If *first <> *this
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_Before, *first\adress)
            
            While NextElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_Before, *first\adress)
              EndIf
            Wend
            
            If *this\parent\last = *this
              *this\parent\last = *this\before
            EndIf
            
            If *this\before
              *this\before\after = *this\after
            EndIf
            
            If *this\after
              *this\after\before = *this\before
            EndIf
            
            *this\after = *this\parent\first
            *this\before = 0
            
            *this\parent\first\before = *this
            *this\parent\first = *this
          EndIf
          
        Case #PB_List_Before 
          If *widget_2
            *before = *widget_2
          Else
            *before = *this\before
          EndIf
          
          If *before
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_Before, *before\adress)
            
            While NextElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_Before, *before\adress)
              EndIf
            Wend
            
            If *this\parent\last   = *this ; GetLast(*this\parent\last) 
              *this\parent\last    = *before
            EndIf
            
            If *this\before
              *this\before\after   = *this\after
            EndIf
            
             *this\after            = *before
            *this\before           = *before\before 
            
            If Not *this\before
              *this\parent\first = *this
              *this\parent\first\before = 0
            EndIf
          EndIf
          
        Case #PB_List_After 
          If *widget_2
            *after = *widget_2
          Else
            *after = *this\after
          EndIf
          
          If *after
            *Last = GetLast(*after)
            
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *after
            EndIf
            
            If *this\after
              *this\after\before = *this\before
            EndIf
            
            *this\before = *after
            *this\after = *after\after 
            
            If Not *this\after
              *this\parent\last = *this
              *this\parent\last\after = 0
            EndIf
          EndIf
          
        Case #PB_List_Last 
          *last = GetLast(*this\parent)
          
          If *Last <> *this
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            ; first element in parent list
            If *this\parent\first = *this
              *this\parent\first = *this\after
            EndIf
            
            If *this\before
              *this\before\after = *this\after
            EndIf
            
            If *this\after
              *this\after\before = *this\before
            EndIf
            
            *this\before = *this\parent\last
            *this\after = 0
            
            *this\parent\last\after = *this
            *this\parent\last = *this
          EndIf
          
      EndSelect
      
      ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn result
    EndProcedure
    
  Procedure Demo()
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 110, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 250, 110)
    
    ;{ first container
    Container(55, 60, 30, 45)                     ; Gadget(9,   
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    SetClass(widget(), "0_first_container")
    
    Container(3, 20, 24-4, 25+6)   
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    SetClass(widget(), "0_first_container_1_first_container")
    
    Container(3, 4, 17-8, 25+6)   
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    SetClass(widget(), "0_first_container_1_last_container")
    CloseList()
    CloseList()
    
    CloseList()
    ;}
    
    Button(55, 51, 170, 25, "8",#__Button_Right)  ; Gadget(8, 
    Button(55, 47, 150, 25, "7",#__Button_Right)  ; Gadget(7, 
    Button(55, 43, 130, 25, "6",#__Button_Right)  ; Gadget(6, 
    
    *current = Button(55, 39, 110, 25, "5",#__Button_Right)  ; Gadget(5, 
    
    ;{ current container
    *this = Container(10, 15, 60, 80)              ; Gadget(10, 
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    SetClass(widget(), "this_container")
    
    Container(10, 4, 60, 74-4)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    Container(10, 4, 60, 68-8)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    CloseList()
    CloseList()
    
    CloseList()
    ;}
    
    Button(55, 35, 90, 25, "4",#__Button_Right)  ; Gadget(4, 
    Button(55, 31, 70, 25, "3",#__Button_Right)  ; Gadget(3, 
    Button(55, 27, 50, 25, "2",#__Button_Right)  ; Gadget(2, 
    
    ;{ last container
    Container(55, 5, 30, 43)                     ; Gadget(1,
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    SetClass(widget(), "0_last_container")
    
    Container(3, -3, 24-4, 25+6)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    SetClass(widget(), "0_last_container_1_first_container")
    
    Container(3, -3, 17-8, 25+6)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    SetClass(widget(), "0_last_container_1_last_container")
    CloseList()
    CloseList()
    
    CloseList()
    ;}
    
    ForEach widget()
      Debug widget()\class
    Next
    
    ResizeWindow(0,#PB_Ignore,WindowY(0)-130,#PB_Ignore,#PB_Ignore)
    ; BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
    
    OpenWindow(10, 0, 0, 250, 125, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#_Last, 5, 10, 240, 20, "last position gadget №10")
    ButtonGadget(#NextOne, 5, 40, 240, 20, "next position gadget №10")
    
    ButtonGadget(#PrevOne, 5, 70, 240, 20, "prev position gadget №10")
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
            
            ClearDebugOutput()
            ForEach widget()
              Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
            Next
            
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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 0-----
; EnableXP