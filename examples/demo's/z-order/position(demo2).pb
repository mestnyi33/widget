﻿XIncludeFile "../../../widgets.pbi" 


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *c0
  Global *this._s_widget
  Global *current._s_widget
  
  #first=99
  #before=100
  #after=101
  #last=102
  #return = 103
  
  Procedure   _SetPosition(*this._s_widget, position.l, *widget._s_widget = #Null) ; Ok
    ProcedureReturn SetPosition(*this, position, *widget)
      
; ;     Protected Type
; ;     Protected result
; ;     
; ;     Protected *before._s_widget 
; ;     Protected *after._s_widget 
; ;     Protected *last._s_widget
; ;     Protected *first._s_widget
; ;     
; ;     If *this = *widget
; ;       ProcedureReturn 0
; ;     EndIf
; ;     
; ;     Select Position
; ;       Case #PB_List_First 
; ;         result = _SetPosition(*this, #PB_List_Before, *this\parent\first)
; ;         
; ;       Case #PB_List_Before 
; ;         If *widget
; ;           *after = *widget
; ;         Else
; ;           *after = *this\before
; ;         EndIf
; ;         
; ;         If *after
; ;           ChangeCurrentElement(widget(), *this\address)
; ;           MoveElement(widget(), #PB_List_Before, *after\address)
; ;           
; ;           While NextElement(widget()) 
; ;             If Child(widget(), *this)
; ;               MoveElement(widget(), #PB_List_Before, *after\address)
; ;             EndIf
; ;           Wend
; ;           
; ;           ; if first element in parent list
; ;           If *this\parent\first = *this
; ;             *this\parent\first = *this\after
; ;           EndIf
; ;           
; ;           ; if last element in parent list
; ;           If *this\parent\last = *this
; ;             *this\parent\last = *this\before
; ;           EndIf
; ;           
; ;           If *this\before
; ;             *this\before\after = *this\after
; ;           EndIf
; ;           
; ;           If *this\after
; ;             *this\after\before = *this\before
; ;           EndIf
; ;           
; ;           ;           If *widget
; ;           ;             *this\after = *this\parent\first
; ;           ;             *this\before = 0
; ;           ;           Else
; ;           *this\after = *after
; ;           *this\before = *after\before 
; ;           ;           EndIf
; ;           
; ;           If Not *this\before
; ;             *this\parent\first\before = *this
; ;             *this\parent\first = *this
; ;           EndIf
; ;           
; ;           result = 1
; ;         EndIf
; ;         
; ;       Case #PB_List_After 
; ;         If *widget
; ;           *before = *widget
; ;         Else
; ;           *before = *this\after
; ;         EndIf
; ;         
; ;         If *before
; ;           *last = GetLast(*before)
; ;           ;           Debug *before\class
; ;           ;           Debug *last\class
; ;           
; ;           ChangeCurrentElement(widget(), *this\address)
; ;           MoveElement(widget(), #PB_List_After, *last\address)
; ;           
; ;           While PreviousElement(widget()) 
; ;             If Child(widget(), *this)
; ;               MoveElement(widget(), #PB_List_After, *this\address)
; ;             EndIf
; ;           Wend
; ;           
; ;           ; if first element in parent list
; ;           If *this\parent\first = *this
; ;             *this\parent\first = *this\after
; ;           EndIf
; ;           
; ;           ; if last element in parent list
; ;           If *this\parent\last = *this
; ;             *this\parent\last = *this\before
; ;           EndIf
; ;           
; ;           If *this\after
; ;             *this\after\before = *this\before
; ;           EndIf
; ;           
; ;           If *this\before
; ;             *this\before\after = *this\after
; ;           EndIf
; ;           
; ;           
; ;           ;           If *widget
; ;           ;             *this\before = *this\parent\last
; ;           ;             *this\after = 0
; ;           ;           Else
; ;           *this\before = *before
; ;           *this\after = *before\after 
; ;           ;           EndIf
; ;           
; ;           If Not *this\after
; ;             *this\parent\last\after = *this
; ;             *this\parent\last = *this
; ;           EndIf
; ;           
; ;           result = 1
; ;         EndIf
; ;         
; ;       Case #PB_List_Last 
; ;         result = _SetPosition(*this, #PB_List_After, *this\parent\last)
; ;         
; ;     EndSelect
; ;     
; ;     ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
; ;     
; ;     ProcedureReturn result
  EndProcedure
  
  Procedure this_events()
    Static after
    Static before
    
    Select WidgetEvent( )
      Case #__Event_LeftDown 
        after = GetPosition(EventWidget( ), #PB_List_After)
        before = GetPosition(EventWidget( ), #PB_List_Before)
        
        If after
          Debug "After - "+GetClass(after)
        EndIf
        If before
          Debug "Before - "+GetClass(before)
        EndIf
        
        _SetPosition(EventWidget( ), #PB_List_First)
        
;         Debug ">>"
;         ForEach widget()
;           Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
;         Next
        
      Case #__Event_LeftUp
        _SetPosition(EventWidget( ), #PB_List_After)
        
        If after 
          Debug "<<"
;           _SetPosition(EventWidget( ), #PB_List_After, after)
;           
;           ForEach widget()
;             Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
;           Next
          
          after = 0
        EndIf
    EndSelect
  EndProcedure
  
  Procedure Demo()
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 180, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 250, 180)
    
    ;{ first container
    Container(55, 95, 30, 45)                     ; Gadget(9,   
    SetColor(widget(), #PB_Gadget_BackColor, $00ffff)
    SetClass(widget(), "first_0")
    
    Container(3, 20, 24-4, 25+6)   
    SetColor(widget(), #PB_Gadget_BackColor, $00ffff)
    SetClass(widget(), "first_1")
    
;     Container(3, 4, 17-8, 25+6)   
;     SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
;     SetClass(widget(), "first_2")
;     CloseList()
    Button(3, 4, 17, 25+6, "1", #__flag_TextLeft) : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    CloseList()
    ;}
    
    Button(55, 86, 170, 25, "2",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(8, 
    Button(55, 82, 150, 25, "3",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(7, 
    Button(55, 78, 130, 25, "4",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(6, 
    
    ;*current = Button(55, 74, 110, 25, "5",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(5, 
    
    ;{ current container
    *this = Container(10, 50, 60, 80)              ; Gadget(10, 
    SetColor(widget(), #PB_Gadget_BackColor, $ffff00)
    SetClass(widget(), "this_container")
    
    Container(10, 4, 60, 74-4)   
    SetColor(widget(), #PB_Gadget_BackColor, $ffff00)
    Button(10, 4, 60, 68-8, "5", #__flag_TextLeft) : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    CloseList()
    Bind(*this, @this_events(), #__Event_LeftDown)
    Bind(*this, @this_events(), #__Event_LeftUp)
    ;}
    
    Button(55, 70, 90, 25, "6",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(4, 
    Button(55, 66, 70, 25, "7",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(3, 
    Button(55, 62, 50, 25, "8",#__flag_TextRight) : SetClass(widget(), GetText(widget()))  ; Gadget(2, 
    
    ;{ last container
    *c0 = Panel(35, 10, 50, 73) : SetClass(widget(), "last_0")                           ; Gadget(1,
    SetColor(widget(), #PB_Gadget_BackColor, $ffff00ff)
    
    AddItem(*c0, -1, "1")
    Button( 5,  5, 50, 30,"101") : SetClass(widget(), GetText(widget()))  
    Button(15, 25, 50, 30,"102") : SetClass(widget(), GetText(widget()))  
    Button(25, 45, 50, 30,"103") : SetClass(widget(), GetText(widget()))  
    AddItem(*c0, -1, "2")
    Button( 5,  5, 50, 30,"201") : SetClass(widget(), GetText(widget()))  
    Button(15, 25, 50, 30,"202") : SetClass(widget(), GetText(widget()))  
    Button(25, 45, 50, 30,"203") : SetClass(widget(), GetText(widget()))  
    AddItem(*c0, -1, "3")
    Button( 5,  5, 50, 30,"301") : SetClass(widget(), GetText(widget()))  
    Button(15, 25, 50, 30,"302") : SetClass(widget(), GetText(widget()))  
    Button(25, 45, 50, 30,"303") : SetClass(widget(), GetText(widget()))  
    CloseList()
    
    CloseList()
    ;}
    
    ForEach widgets()
      Debug widgets()\class
    Next
    
    ResizeWindow(0,WindowX(0)-200,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    ; BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
    
    OpenWindow(10, 0, 0, 130, 180, "", #PB_Window_TitleBar|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#return, 5, 10, 120, 30, "return")
    
    ButtonGadget(#last, 5, 55, 120, 30, "last (top)")
    ButtonGadget(#before, 5, 85, 120, 30, "before (prev)")
    ButtonGadget(#after, 5, 115, 120, 30, "after (next)")
    ButtonGadget(#first, 5, 145, 120, 30, "first (bottom)")
  EndProcedure
  
  Demo()
  
  Define gEvent, gQuit, after, before
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            
            
            Select EventGadget()
              Case #first
               before = GetPosition(*this, #PB_List_Before)
               _SetPosition(*this, #PB_List_First)
                
              Case #before
                _SetPosition(*this, #PB_List_Before)
                
              Case #after
                _SetPosition(*this, #PB_List_After)
                
              Case #last
               after = GetPosition(*this, #PB_List_After)
               _SetPosition(*this, #PB_List_Last)
                
              Case #return
                If after
                  _SetPosition(*this, #PB_List_Before, after)
                EndIf
                If before
                  _SetPosition(*this, #PB_List_After, before)
                EndIf
            EndSelect
            
            ;             ClearDebugOutput()
            ;             ForEach widget()
            ;               Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
            ;             Next
            
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 235
; FirstLine = 77
; Folding = 0--
; Optimizer
; EnableXP
; DPIAware