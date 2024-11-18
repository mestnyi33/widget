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
        result = _SetPosition(*this, #PB_List_Before, *this\parent\first\widget)
        
      Case #PB_List_Before 
        If *widget
          *after = *widget
        Else
          *after = *this\before\widget
        EndIf
        
        If *after
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_Before, *after\address)
          
          While NextElement(widgets()) 
            If IsWidgetChild(widgets(), *this)
              MoveElement(widgets(), #PB_List_Before, *after\address)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\first\widget = *this
            *this\parent\first\widget = *this\after\widget
          EndIf
          
          ; if last element in parent list
          If *this\parent\last\widget = *this
            *this\parent\last\widget = *this\before\widget
          EndIf
          
          If *this\before\widget
            *this\before\widget\after\widget = *this\after\widget
          EndIf
          
          If *this\after\widget
            *this\after\widget\before\widget = *this\before\widget
          EndIf
          
          *this\after\widget = *after
          *this\before\widget = *after\before\widget 
          *after\before\widget = *this
          
          If *this\before\widget
            *this\before\widget\after\widget = *this
          Else
            *this\parent\first\widget\before\widget = *this
            *this\parent\first\widget = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_After 
        If *widget
          *before = *widget
        Else
          *before = *this\after\widget
        EndIf
        
        If *before
          *last = GetLast(*before, 0)
          ;           Debug *before\class
          ;           Debug *last\class
          
          ChangeCurrentElement(widgets(), *this\address)
          MoveElement(widgets(), #PB_List_After, *last\address)
          
          While PreviousElement(widgets()) 
            If IsWidgetChild(widgets(), *this)
              MoveElement(widgets(), #PB_List_After, *this\address)
            EndIf
          Wend
          
          ; if first element in parent list
          If *this\parent\first\widget = *this
            *this\parent\first\widget = *this\after\widget
          EndIf
          
          ; if last element in parent list
          If *this\parent\last\widget = *this
            *this\parent\last\widget = *this\before\widget
          EndIf
          
          If *this\after\widget
            *this\after\widget\before\widget = *this\before\widget
          EndIf
          
          If *this\before\widget
            *this\before\widget\after\widget = *this\after\widget
          EndIf
          
          *this\before\widget = *before
          *this\after\widget = *before\after\widget 
          *before\after\widget = *this
          
          If *this\after\widget
            *this\after\widget\before\widget = *this
          Else
            *this\parent\last\widget\after\widget = *this
            *this\parent\last\widget = *this
          EndIf
          
          result = 1
        EndIf
        
      Case #PB_List_Last 
        result = _SetPosition(*this, #PB_List_After, *this\parent\last\widget)
        
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
          Debug "Before - "+GetWidgetClass(before)
         _SetPosition(EventWidget( ), #PB_List_First)
        EndIf
        If after
          Debug "After - "+GetWidgetClass(after)
        EndIf
        
        
      Case #PB_EventType_LeftButtonUp
        If before
          _SetPosition(EventWidget( ), #PB_List_After, before)
          
          Debug " --- up "
          before = GetPosition(EventWidget( ), #PB_List_Before)
          after = GetPosition(EventWidget( ), #PB_List_After)
          
          If before
            Debug "Before - "+GetWidgetClass(before)
          EndIf
          If after
            Debug "After - "+GetWidgetClass(after)
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget( OpenRoot(0, 10, 10) );, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g0 = WindowWidget(10,10,200,200, "form_0", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "form_0")
  ButtonWidget(10,10,100,90,"button_0") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(30,30,100,90,"button_1") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(50,50,100,90,"button_2") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(70,70,100,90,"button_3") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(90,90,100,90,"button_4") : SetWidgetClass(widget(), GetWidgetText(widget()))
  
  ForEach widgets()
    If IsWidgetChild(widgets(), *g0)
      BindWidgetEvent(widgets(), @this_events(), #PB_EventType_LeftButtonDown)
      BindWidgetEvent(widgets(), @this_events(), #PB_EventType_LeftButtonUp)
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
; CursorPosition = 43
; FirstLine = 39
; Folding = -----
; EnableXP
; DPIAware