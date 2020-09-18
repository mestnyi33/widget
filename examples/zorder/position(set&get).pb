XIncludeFile "../../widgets.pbi" 


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *this._s_widget
  Global *current._s_widget
  
  #first=99
  #before=100
  #after=101
  #last=102
  #return = 103
  
  Global after
  Global before
  Global after1
  Global before1
  
  
  
  Procedure   _1SetPosition(*this._s_widget, position.l, *widget._s_widget = #Null) ; Ok
    Protected Type
    Protected result =- 1
    
    Protected *before._s_widget 
    Protected *after._s_widget 
    Protected *last._s_widget
    Protected *first._s_widget
    
    If *this = *widget
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
        If *widget
          *before = *widget
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
        If *widget
          *after = *widget
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
  
  Procedure   _2SetPosition(*this._s_widget, position.l, *widget._s_widget = #Null) ; Ok
                                                                                    ; ProcedureReturn SetPosition(*this, position, *widget)
    
    Protected Type
    Protected result =- 1
    
    Protected *before._s_widget 
    Protected *after._s_widget 
    Protected *last._s_widget
    Protected *first._s_widget
    
    If *this = *widget
      ProcedureReturn 0
    EndIf
    
    Select Position
      Case #PB_List_First 
        result = SetPosition(*this, #PB_List_Before, *this\parent\first)
        
      Case #PB_List_Before 
        If *widget
          *before = *widget
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
          
          If *this\parent\last = *this
            *this\parent\last = *this\before
          EndIf
          
          If *this\before
            *this\before\after = *this\after
          EndIf
          
          If *this\after
            *this\after\before = *this\before
          EndIf
          
          If *widget
            *this\after = *this\parent\first
            *this\before = 0
          Else
            *this\after = *before
            *this\before = *before\before 
          EndIf
          
          If Not *this\before
            *this\parent\first\before = *this
            *this\parent\first = *this
          EndIf
        EndIf
        
      Case #PB_List_After 
        If *widget
          *after = *widget
        Else
          *after = *this\after
        EndIf
        
        If *after
          ChangeCurrentElement(widget(), *this\adress)
          MoveElement(widget(), #PB_List_After, *after\adress)
          
          While PreviousElement(widget()) 
            If Child(widget(), *this)
              MoveElement(widget(), #PB_List_After, *this\adress)
            EndIf
          Wend
          
          ; first element in parent list
          If *this\parent\first = *this
            *this\parent\first = *this\after
          EndIf
          
          If *this\after
            *this\after\before = *this\before
          EndIf
          
          If *this\before
            *this\before\after = *this\after
          EndIf
          
          If *widget
            *this\before = *this\parent\last
            *this\after = 0
          Else
            *this\before = *after
            *this\after = *after\after 
          EndIf
          
          If Not *this\after
            *this\parent\last\after = *this
            *this\parent\last = *this
          EndIf
        EndIf
        
      Case #PB_List_Last 
        result = SetPosition(*this, #PB_List_After, GetLast(*this\parent\last))
        
    EndSelect
    
    ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
    
    ProcedureReturn result
  EndProcedure
  
  Procedure   _SetPosition(*this._s_widget, position.l, *widget._s_widget = #Null) ; Ok
    ;;ProcedureReturn SetPosition(*this, position, *widget)
      
    Protected Type
    Protected result
    
    Protected *before._s_widget 
    Protected *after._s_widget 
    Protected *last._s_widget
    Protected *first._s_widget
    
    If *this = *widget
      ProcedureReturn 0
    EndIf
    
    Select Position
      Case #PB_List_First 
        result = _SetPosition(*this, #PB_List_Before, *this\parent\first)
        
      Case #PB_List_Before 
        If *widget
          *after = *widget
        Else
          *after = *this\before
        EndIf
        
        If *after
          ChangeCurrentElement(widget(), *this\adress)
          MoveElement(widget(), #PB_List_Before, *after\adress)
          
          While NextElement(widget()) 
            If Child(widget(), *this)
              MoveElement(widget(), #PB_List_Before, *after\adress)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\first = *this
            *this\parent\first = *this\after
          EndIf
          
          ; if last element in parent list
          If *this\parent\last = *this
            *this\parent\last = *this\before
          EndIf
          
          If *this\before
            *this\before\after = *this\after
          EndIf
          
          If *this\after
            *this\after\before = *this\before
          EndIf
          
          *this\after = *after
          *this\before = *after\before 
          *after\before = *this
          
          If *this\before
            *this\before\after = *this
          Else
            *this\parent\first\before = *this
            *this\parent\first = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_After 
        If *widget
          *before = *widget
        Else
          *before = *this\after
        EndIf
        
        If *before
          *last = GetLast(*before)
          ;           Debug *before\class
          ;           Debug *last\class
          
          ChangeCurrentElement(widget(), *this\adress)
          MoveElement(widget(), #PB_List_After, *last\adress)
          
          While PreviousElement(widget()) 
            If Child(widget(), *this)
              MoveElement(widget(), #PB_List_After, *this\adress)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\first = *this
            *this\parent\first = *this\after
          EndIf
          
          ; if last element in parent list
          If *this\parent\last = *this
            *this\parent\last = *this\before
          EndIf
          
          If *this\after
            *this\after\before = *this\before
          EndIf
          
          If *this\before
            *this\before\after = *this\after
          EndIf
          
          *this\before = *before
          *this\after = *before\after 
          *before\after = *this
          
          If *this\after
            *this\after\before = *this
          Else
            *this\parent\last\after = *this
            *this\parent\last = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_Last 
        result = _SetPosition(*this, #PB_List_After, *this\parent\last)
        
    EndSelect
    
    ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
    
    ProcedureReturn result
  EndProcedure
  
  Procedure this_events()
    Select this()\event
      Case #PB_EventType_LeftButtonDown 
        before = GetPosition(this()\widget, #PB_List_Before)
        after = GetPosition(this()\widget, #PB_List_After)
        
        If before
          Debug "Before - "+GetClass(before)
        EndIf
        If after
          Debug "After - "+GetClass(after)
        EndIf
        
        _SetPosition(this()\widget, #PB_List_Last)
        
        Debug " --- down "
        before1 = GetPosition(this()\widget, #PB_List_Before)
        after1 = GetPosition(this()\widget, #PB_List_After)
        
        If before1
          Debug "Before - "+GetClass(before1)
        EndIf
        If after1
          Debug "After - "+GetClass(after1)
        EndIf
        
        
        ;         Debug ">>"
        ;         ForEach widget()
        ;           Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
        ;         Next
        
      Case #PB_EventType_LeftButtonUp
        ;Debug " ---1 "
        If before
          Debug "Before - "+GetClass(before)
          _SetPosition(this()\widget, #PB_List_After, before)
        EndIf
        If after
          ; Debug "After - "+GetClass(after)
          ; _SetPosition(this()\widget, #PB_List_Before, after)
        EndIf
        
        
        
        Debug " --- up "
        before1 = GetPosition(this()\widget, #PB_List_Before)
        after1 = GetPosition(this()\widget, #PB_List_After)
        
        If before1
          Debug "Before - "+GetClass(before1)
        EndIf
        If after1
          Debug "After - "+GetClass(after1)
        EndIf
        
        
        
        ;         If after 
        ;           Debug "<<"
        ; ;           _SetPosition(this()\widget, #PB_List_After, after)
        ; ;           
        ; ;           ForEach widget()
        ; ;             Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
        ; ;           Next
        ;           
        ;           after = 0
        ;         EndIf
    EndSelect
  EndProcedure
  
  Procedure Demo()
    Protected y = 10
    Protected x = 30
    Protected h = 26+20
    Protected s = 24
    Protected font = LoadFont(#PB_Any, "arial", 40)
    Protected   ParentID = OpenWindow(0, 0, 0, 270, 145+s*9, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 270, 271+s*9)
    
    ;    Button(x, y+56+s*9, 215, h, "1",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    ;{ first container
    Container(x, y+56+s*9, 215, h)                     ; Gadget(9,   
    SetClass(widget(), "first_0")
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    
    Container(4, 0, 215-6, h-4-2) 
    SetClass(widget(), "first_1")
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    
    Button(4, 0, 215-12, h-8-4, "1", #__Button_Right|#__text_top) 
    SetClass(widget(), GetText(widget())) 
    CloseList()
    CloseList()
    ;}
    
    
    Button(x, y+51+s*8, 195, h, "2",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    Button(x, y+47+s*7, 175, h, "3",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(7, 
    Button(x, y+43+s*6, 155, h, "4",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(6, 
    
    ;;*this = Button(10, y, 250, 80+h+s*9, "6 < 5 > 4", #__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) 
    ;;SetFont(widget(), FontID(font))
    
    ;{ current container
    *this = Container(10, y, 250, 80+h+s*9)              ; Gadget(10, 
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    SetClass(widget(), "this_container")
    
    Container(250-200-2, 4, 200, (80+h+s*9)-8-2)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    
    Button(4, 4, 200-4, (80+h+s*9)-16-4, "5", #__Button_Right|#__text_top) 
    SetClass(widget(), GetText(widget())) 
    CloseList()
    CloseList()
    ;}
        
    Button(x, y+35+s*4, 115, h, "6",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))  ; Gadget(4, 
    Button(x, y+31+s*3, 95, h, "7",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))   ; Gadget(3, 
    Button(x, y+27+s*2, 75, h, "8",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))   ; Gadget(2, 
    
    ;; Button(x, y+23+s*1, 55, h, "9",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))  ; Gadget(2, 
    ;{ last container
    Container(x, y+23+s*1, 55, h)                     ; Gadget(1,
    SetClass(widget(), "last_0")
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    
    Container(4, 0, 49, h-4-2)   
    SetClass(widget(), "last_1")
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    
    Button(4, 0, 43, h-8-4, "9", #__Button_right|#__text_top) 
    SetClass(widget(), GetText(widget())) 
    CloseList()
    CloseList()
    ;}
    
    Bind(*this, @this_events(), #PB_EventType_LeftButtonDown)
    Bind(*this, @this_events(), #PB_EventType_LeftButtonUp)
    
    ResizeWindow(0,WindowX(0)-200,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    
    OpenWindow(10, 0, 0, 130, 180, "", #PB_Window_TitleBar|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#last, 5, 10, 120, 30, "last (top)")
    ButtonGadget(#before, 5, 40, 120, 30, "before (prev)")
    ButtonGadget(#after, 5, 70, 120, 30, "after (next)")
    ButtonGadget(#first, 5, 100, 120, 30, "first (bottom)") 
    
    ButtonGadget(#return, 5, 145, 120, 30, "return")
    DisableGadget(#return, 1)
  EndProcedure
  
  Demo()
  
  Define gEvent, gQuit, text.s, repaint 
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            Select EventGadget()
              Case #first 
                DisableGadget(#return, 0)
                after = GetPosition(*this, #PB_List_After)
                ;before = GetPosition(*this, #PB_List_After)
                
                If _SetPosition(*this, #PB_List_First)
                  repaint = 1
                EndIf
                
              Case #before 
                If _SetPosition(*this, #PB_List_Before) 
                  repaint = 1
                EndIf
                
              Case #after 
                If _SetPosition(*this, #PB_List_After)
                  repaint = 1
                EndIf
                
              Case #last 
                DisableGadget(#return, 0)
                ;after = GetPosition(*this, #PB_List_Before)
                before = GetPosition(*this, #PB_List_Before)
                
                If _SetPosition(*this, #PB_List_Last)
                  repaint = 1
                EndIf
                
              Case #return
                DisableGadget(#return, 1) 
                If after
                  ;Debug GetClass(after)+"  - after"
                  If _SetPosition(*this, #PB_List_Before, after)
                    repaint = 1
                  EndIf
                  
                EndIf
                If before
                  ;Debug GetClass(before)+"  - before"
                  If _SetPosition(*this, #PB_List_After, before) 
                    repaint = 1
                  EndIf
                  
                EndIf
            EndSelect
            
            If repaint
              text = ""
              Debug ""+ *this +" "+ GetPosition(*this, #PB_List_After) +" "+ GetPosition(*this, #PB_List_Before)
                  
              If GetPosition(*this, #PB_List_After)
                If GetType(GetPosition(*this, #PB_List_After)) = #PB_GadgetType_Container
                  If GetPosition(*this, #PB_List_Before)
                    text + "9"
                  Else
                    text + "1"
                  EndIf
                Else
                  text + GetClass(GetPosition(*this, #PB_List_After))
                EndIf
              EndIf
              
              text + " < 5 > "
              
              If GetPosition(*this, #PB_List_Before)
                If GetType(GetPosition(*this, #PB_List_Before)) = #PB_GadgetType_Container
                  If GetPosition(*this, #PB_List_After)
                    text + "1"
                  Else
                    text + "9"
                  EndIf
                Else
                  text + GetClass(GetPosition(*this, #PB_List_Before))
                EndIf
              EndIf
              
              SetText(*this, text)
              
              Redraw(Root())
              
; ;               Debug " -get- "
; ;               before1 = GetPosition(*this, #PB_List_Before)
; ;               after1 = GetPosition(*this, #PB_List_After)
; ;               
; ;               If before1
; ;                 Debug "Before - "+GetClass(before1)
; ;               EndIf
; ;               If after1
; ;                 Debug "After - "+GetClass(after1)
; ;               EndIf
; ;               
; ;               Debug GetClass(GetPosition(*this, #PB_List_First))
; ;               Debug GetClass(GetPosition(*this, #PB_List_Last))
              
              ;             ClearDebugOutput()
              ;             ForEach widget()
              ;               Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
              ;             Next
              ;             
              ;             ;               Debug "first "+GetFirst(ParentID)
              ;             ;               Debug "last "+GetLast(ParentID)
              ;             ;               Debug "prev №1 < № "+GetPrev(1)
              ;             ;               Debug "next №1 > № "+GetNext(1)
            EndIf
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -------------H+--
; EnableXP