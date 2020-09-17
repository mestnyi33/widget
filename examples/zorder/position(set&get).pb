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
  
  Procedure   _1SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
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
        Debug *Last\text\string
        
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
        result = SetPosition(*this, #PB_List_Before, *this\parent\first)
        
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
          
          If *this\parent\last = *this
            *this\parent\last = *this\before
          EndIf
          
          If *this\before
            *this\before\after = *this\after
          EndIf
          
          If *this\after
            *this\after\before = *this\before
          EndIf
          
          If *widget_2
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
        If *widget_2
          *after = *widget_2
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
          
          If *widget_2
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
  
  Procedure this_events()
    Static after
    Static before
    
    Select this()\event
      Case #PB_EventType_LeftButtonDown 
        after = GetPosition(this()\widget, #PB_List_After)
        before = GetPosition(this()\widget, #PB_List_Before)
        
        If after
          Debug "After - "+GetClass(after)
        EndIf
        If before
          Debug "Before - "+GetClass(before)
        EndIf
        
        _SetPosition(this()\widget, #PB_List_First)
        
;         Debug ">>"
;         ForEach widget()
;           Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
;         Next
        
      Case #PB_EventType_LeftButtonUp
        _SetPosition(this()\widget, #PB_List_After)
        
        If after 
          Debug "<<"
;           _SetPosition(this()\widget, #PB_List_After, after)
;           
;           ForEach widget()
;             Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
;           Next
          
          after = 0
        EndIf
    EndSelect
  EndProcedure
  
  Procedure Demo()
    Protected y = 35
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 180, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 250, 180)
   
    Button(55, y+56, 190, 25, "1",#__Button_Right) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    Button(55, y+51, 170, 25, "2",#__Button_Right) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    Button(55, y+47, 150, 25, "3",#__Button_Right) : SetClass(widget(), GetText(widget())) ; Gadget(7, 
    Button(55, y+43, 130, 25, "4",#__Button_Right) : SetClass(widget(), GetText(widget())) ; Gadget(6, 
    
    *this = Button(10, y, 155, 105, "5", #__Button_left) : SetClass(widget(), GetText(widget())) 
    
    Button(55, y+35, 90, 25, "6",#__Button_Right) : SetClass(widget(), GetText(widget()))  ; Gadget(4, 
    Button(55, y+31, 70, 25, "7",#__Button_Right) : SetClass(widget(), GetText(widget()))  ; Gadget(3, 
    Button(55, y+27, 50, 25, "8",#__Button_Right) : SetClass(widget(), GetText(widget()))  ; Gadget(2, 
    Button(55, y+23, 30, 25, "9",#__Button_Right) : SetClass(widget(), GetText(widget()))  ; Gadget(2, 
    
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
  
  Define gEvent, gQuit
  Define after, before
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
                
                SetPosition(*this, #PB_List_First)
                resize(*this, #PB_Ignore, #PB_Ignore, Width(GetPosition(*this, #PB_List_After))+45, #PB_Ignore)
                
              Case #before 
                SetPosition(*this, #PB_List_Before)
                resize(*this, #PB_Ignore, #PB_Ignore, Width(GetPosition(*this, #PB_List_After))+45, #PB_Ignore)
                
              Case #after 
                SetPosition(*this, #PB_List_After)
                If Not GetPosition(*this, #PB_List_After)
                  resize(*this, #PB_Ignore, #PB_Ignore, 55, #PB_Ignore)
                Else
                  resize(*this, #PB_Ignore, #PB_Ignore, Width(GetPosition(*this, #PB_List_After))+45, #PB_Ignore)
                EndIf
                
              Case #last 
                DisableGadget(#return, 0)
                before = GetPosition(*this, #PB_List_Before)
                
                SetPosition(*this, #PB_List_Last)
                resize(*this, #PB_Ignore, #PB_Ignore, 55, #PB_Ignore)
                
              Case #return
                DisableGadget(#return, 1) 
                If after
                  _SetPosition(*this, #PB_List_After, after)
                EndIf
                If before
                  _SetPosition(*this, #PB_List_Before, before)
                EndIf
                
                If after Or before
                  resize(*this, #PB_Ignore, #PB_Ignore, 155, #PB_Ignore)
                EndIf
            EndSelect
            
            Redraw(Root())
            
            ;             ClearDebugOutput()
            ;             ForEach widget()
            ;               Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
            ;             Next
            ;             
            ;             ;               Debug "first "+GetFirst(ParentID)
            ;             ;               Debug "last "+GetLast(ParentID)
            ;             ;               Debug "prev №1 < № "+GetPrev(1)
            ;             ;               Debug "next №1 > № "+GetNext(1)
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 0---b+-4--
; EnableXP