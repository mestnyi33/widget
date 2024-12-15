XIncludeFile "../../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global X=100,Y=100, Width=420, Height=420 , focus
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
        result = _SetPosition(*this, #PB_List_Before, *this\parent\FirstWidget( ))
        
      Case #PB_List_Before 
        If *widget
          *after = *widget
        Else
          *after = *this\beforeWidget( )
        EndIf
        
        If *after
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_Before, *after\address)
          
          While NextElement(widgets()) 
            If IsChild(widgets(), *this)
              MoveElement(widgets(), #PB_List_Before, *after\address)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\firstWidget( ) = *this
            *this\parent\firstWidget( ) = *this\afterWidget( )
          EndIf
          
          ; if last element in parent list
          If *this\parent\lastWidget( ) = *this
            *this\parent\lastWidget( ) = *this\beforeWidget( )
          EndIf
          
          If *this\beforeWidget( )
            *this\beforeWidget( )\afterWidget( ) = *this\afterWidget( )
          EndIf
          
          If *this\afterWidget( )
            *this\afterWidget( )\beforeWidget( ) = *this\beforeWidget( )
          EndIf
          
          *this\afterWidget( ) = *after
          *this\beforeWidget( ) = *after\beforeWidget( ) 
          *after\beforeWidget( ) = *this
          
          If *this\beforeWidget( )
            *this\beforeWidget( )\afterWidget( ) = *this
          Else
            *this\parent\firstWidget( )\beforeWidget( ) = *this
            *this\parent\firstWidget( ) = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_After 
        If *widget
          *before = *widget
        Else
          *before = *this\afterWidget( )
        EndIf
        
        If *before
          *last = GetLast(*before,0)
          ;           Debug *before\class
          ;           Debug *last\class
          
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_After, *last\address)
          
          While PreviousElement(widgets()) 
            If IsChild(widgets(), *this)
              MoveElement(widgets(), #PB_List_After, *this\address)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\firstWidget( ) = *this
            *this\parent\firstWidget( ) = *this\afterWidget( )
          EndIf
          
          ; if last element in parent list
          If *this\parent\lastWidget( ) = *this
            *this\parent\lastWidget( ) = *this\beforeWidget( )
          EndIf
          
          If *this\afterWidget( )
            *this\afterWidget( )\beforeWidget( ) = *this\beforeWidget( )
          EndIf
          
          If *this\beforeWidget( )
            *this\beforeWidget( )\afterWidget( ) = *this\afterWidget( )
          EndIf
          
          *this\beforeWidget( ) = *before
          *this\afterWidget( ) = *before\afterWidget( ) 
          *before\afterWidget( ) = *this
          
          If *this\afterWidget( )
            *this\afterWidget( )\beforeWidget( ) = *this
          Else
            *this\parent\lastWidget( )\afterWidget( ) = *this
            *this\parent\lastWidget( ) = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_Last 
        result = _SetPosition(*this, #PB_List_After, *this\parent\lastWidget( ))
        
    EndSelect
    
    ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
    
    ProcedureReturn result
  EndProcedure
  
  Procedure this_events()
    Select WidgetEvent( )
      Case #__Event_LeftDown 
        before = GetPosition(EventWidget( ), #PB_List_Before)
        after = GetPosition(EventWidget( ), #PB_List_After)
        
        If before
          Debug "Before - "+GetClass(before)
        EndIf
        If after
          Debug "After - "+GetClass(after)
          _SetPosition(EventWidget( ), #PB_List_Last)
        EndIf
        
      Case #__Event_LeftUp
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
  
  If Not OpenWindow(0, 0, 0, Width+X*2+20, Height+Y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g0 = window(10,10,200,200, "form_0", #PB_Window_SystemMenu) : SetClass(widget(), "form_0")
  Button(10,10,100,90,"button_0") : SetClass(widget(), GetText(widget()))
  Button(30,30,100,90,"button_1") : SetClass(widget(), GetText(widget()))
  Button(50,50,100,90,"button_2") : SetClass(widget(), GetText(widget()))
  Button(70,70,100,90,"button_3") : SetClass(widget(), GetText(widget()))
  Button(90,90,100,90,"button_4") : SetClass(widget(), GetText(widget()))
  
  ForEach widgets()
    If IsChild(widgets(), *g0)
      Bind(widgets(), @this_events(), #__Event_LeftDown)
      Bind(widgets(), @this_events(), #__Event_LeftUp)
    EndIf
  Next

  
  Debug "---->>"
  ForEach widgets()
    Debug "  "+ widgets()\class
  Next
  Debug "<<----"
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 161
; FirstLine = 156
; Folding = -----
; Optimizer
; EnableXP