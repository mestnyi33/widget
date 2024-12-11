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
          *after = *this\BeforeWidget( )
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
          If *this\parent\FirstWidget( ) = *this
            *this\parent\FirstWidget( ) = *this\AfterWidget( )
          EndIf
          
          ; if last element in parent list
          If *this\parent\LastWidget( ) = *this
            *this\parent\LastWidget( ) = *this\BeforeWidget( )
          EndIf
          
          If *this\BeforeWidget( )
            *this\BeforeWidget( )\AfterWidget( ) = *this\AfterWidget( )
          EndIf
          
          If *this\AfterWidget( )
            *this\AfterWidget( )\BeforeWidget( ) = *this\BeforeWidget( )
          EndIf
          
          *this\AfterWidget( ) = *after
          *this\BeforeWidget( ) = *after\BeforeWidget( ) 
          *after\BeforeWidget( ) = *this
          
          If *this\BeforeWidget( )
            *this\BeforeWidget( )\AfterWidget( ) = *this
          Else
            *this\parent\FirstWidget( )\BeforeWidget( ) = *this
            *this\parent\FirstWidget( ) = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_After 
        If *widget
          *before = *widget
        Else
          *before = *this\AfterWidget( )
        EndIf
        
        If *before
          *last = GetLast(*before, 0)
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
          If *this\parent\FirstWidget( ) = *this
            *this\parent\FirstWidget( ) = *this\AfterWidget( )
          EndIf
          
          ; if last element in parent list
          If *this\parent\LastWidget( ) = *this
            *this\parent\LastWidget( ) = *this\BeforeWidget( )
          EndIf
          
          If *this\AfterWidget( )
            *this\AfterWidget( )\BeforeWidget( ) = *this\BeforeWidget( )
          EndIf
          
          If *this\BeforeWidget( )
            *this\BeforeWidget( )\AfterWidget( ) = *this\AfterWidget( )
          EndIf
          
          *this\BeforeWidget( ) = *before
          *this\AfterWidget( ) = *before\AfterWidget( ) 
          *before\AfterWidget( ) = *this
          
          If *this\AfterWidget( )
            *this\AfterWidget( )\BeforeWidget( ) = *this
          Else
            *this\parent\LastWidget( )\AfterWidget( ) = *this
            *this\parent\LastWidget( ) = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_Last 
        result = _SetPosition(*this, #PB_List_After, *this\parent\LastWidget( ))
        
    EndSelect
    
    ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
    
    ProcedureReturn result
  EndProcedure
  
  Procedure this_events()
    Select WidgetEvent( )
      Case #__event_Down 
        before = GetPosition(EventWidget( ), #PB_List_Before)
        after = GetPosition(EventWidget( ), #PB_List_After)
        
        If before
          Debug "Before - "+GetClass(before)
         _SetPosition(EventWidget( ), #PB_List_First)
        EndIf
        If after
          Debug "After - "+GetClass(after)
        EndIf
        
        
      Case #__event_Up
        If before
          _SetPosition(EventWidget( ), #PB_List_After, before)
          
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
  
  MyCanvas = GetCanvasGadget( Open(0, 10, 10) );, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g0 = window(10,10,200,200, "form_0", #PB_Window_SystemMenu) : SetClass(widget(), "form_0")
  Button(10,10,100,90,"button_0") : SetClass(widget(), GetText(widget()))
  Button(30,30,100,90,"button_1") : SetClass(widget(), GetText(widget()))
  Button(50,50,100,90,"button_2") : SetClass(widget(), GetText(widget()))
  Button(70,70,100,90,"button_3") : SetClass(widget(), GetText(widget()))
  Button(90,90,100,90,"button_4") : SetClass(widget(), GetText(widget()))
  
  ForEach widgets()
    If IsChild(widgets(), *g0)
      Bind(widgets(), @this_events(), #__event_Down)
      Bind(widgets(), @this_events(), #__event_Up)
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
; CursorPosition = 152
; FirstLine = 150
; Folding = -----
; EnableXP
; DPIAware