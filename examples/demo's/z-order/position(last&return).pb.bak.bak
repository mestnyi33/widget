XIncludeFile "../../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=420, Height=420 , focus
  Global after
  Global before
  Global before1, after1 
  
  Procedure   _SetPosition(*this._s_widget, position.l, *widget._s_widget = #Null) ; Ok
    ProcedureReturn SetPosition(*this, position, *widget)
      
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
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_Before, *after\address)
          
          While NextElement(widgets()) 
            If isChild(widgets(), *this)
              MoveElement(widgets(), #PB_List_Before, *after\address)
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
          
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_After, *last\address)
          
          While PreviousElement(widgets()) 
            If Child(widgets(), *this)
              MoveElement(widgets(), #PB_List_After, *this\address)
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
    Select WidgetEvent( )
      Case #PB_EventType_LeftButtonDown 
        before = GetPosition(EventWidget( ), #PB_List_Before)
        after = GetPosition(EventWidget( ), #PB_List_After)
        
        If before
          Debug "Before - "+GetClass(before)
        EndIf
        If after
          Debug "After - "+GetClass(after)
          _SetPosition(EventWidget( ), #PB_List_Last)
        EndIf
        
      Case #PB_EventType_LeftButtonUp
        If after
          _SetPosition(EventWidget( ), #PB_List_Before, after)
          
          Debug " --- up "
          before = GetPosition(EventWidget( ), #PB_List_Before)
          after = GetPosition(EventWidget( ), #PB_List_After)
          
          If before
            Debug "Before - "+GetClass(before)
          EndIf
          If after
            Debug "After - "+GetClass(after)
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g0 = window(10,10,200,200, "form_0", #PB_Window_SystemMenu) : SetClass(widget(), "form_0")
  Button(10,10,100,90,"button_0") : SetClass(widget(), GetText(widget()))
  Button(30,30,100,90,"button_1") : SetClass(widget(), GetText(widget()))
  Button(50,50,100,90,"button_2") : SetClass(widget(), GetText(widget()))
  Button(70,70,100,90,"button_3") : SetClass(widget(), GetText(widget()))
  Button(90,90,100,90,"button_4") : SetClass(widget(), GetText(widget()))
  
  ForEach widget()
    If Child(widget(), *g0)
      Bind(widget(), @this_events(), #PB_EventType_LeftButtonDown)
      Bind(widget(), @this_events(), #PB_EventType_LeftButtonUp)
    EndIf
  Next

  
  Debug "---->>"
  ForEach widget()
    Debug "  "+ widget()\class
  Next
  Debug "<<----"
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 28
; Folding = v-+--
; Optimizer
; EnableXP