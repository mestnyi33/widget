

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  
  ; Shows using of several panels...
  Procedure BindEvents( )
    Protected *this._s_WIDGET = EventWidget( )
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
        ;       Case #PB_EventType_Draw          : Debug "draw"         
      Case #PB_EventType_MouseWheelX     : Debug  " - "+ *this +" - wheel-x"
      Case #PB_EventType_MouseWheelY     : Debug  " - "+ *this +" - wheel-y"
      Case #PB_EventType_Input           : Debug  " - "+ *this +" - input"
      Case #PB_EventType_KeyDown         : Debug  " - "+ *this +" - key-down"
      Case #PB_EventType_KeyUp           : Debug  " - "+ *this +" - key-up"
      Case #PB_EventType_Focus           : Debug  " - "+ *this +" - focus"
      Case #PB_EventType_LostFocus       : Debug  " - "+ *this +" - lfocus"
      Case #PB_EventType_MouseEnter      : Debug  " - "+ *this +" - enter"
      Case #PB_EventType_MouseLeave      : Debug  " - "+ *this +" - leave"
      Case #PB_EventType_LeftButtonDown  : Debug  " - "+ *this +" - down"
      Case #PB_EventType_DragStart       : Debug  " - "+ *this +" - drag"
      Case #PB_EventType_Drop            : Debug  " - "+ *this +" - drop"
      Case #PB_EventType_LeftButtonUp    : Debug  " - "+ *this +" - up"
      Case #PB_EventType_LeftClick       : Debug  " - "+ *this +" - click"
      Case #PB_EventType_LeftDoubleClick : Debug  " - "+ *this +" - 2_click"
    EndSelect
  EndProcedure
  
 
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;{ OpenRoot0
  Define *root0._s_WIDGET = Open(#window,10,10,600-20,600-20)
  
  Define Text.s, m.s=#LF$, a,*g._s_widget = Editor(10, 10, 200+60, 200);, #__flag_autosize) 
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  ;SetText(*g, Text.s) 
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 7+a, "_")
  For a = 4 To 16
    AddItem(*g, a, "Line "+Str(a))
  Next
  
;   editor_update()
;   ForEach *g\row\_s( )
;     Debug *g\row\_s( )
;   Next
  
  *g = Tree(280, 10, 200+60, 200)
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 7+a, "_")
  For a = 4 To 16
    AddItem(*g, a, "Line "+Str(a))
  Next
  
  Define event, handle, enter, result
  Repeat 
    event = WaitWindowEvent( )
    If event = #PB_Event_Gadget
      If EventType( ) = #PB_EventType_MouseMove
        ;       enter = EnterGadgetID( )
        ;       
        ;       If handle <> enter
        ;         handle = enter
        ;         
        ;         ChangeCurrentRoot( handle )
        ;       EndIf
        ;             ElseIf EventType( ) = #PB_EventType_MouseEnter ; bug do't send mouse enter event then press mouse buttons
        ;               Root( ) = GetRoot( GadgetID( EventGadget( ) ) )
      EndIf
      
      ;     WidgetsEvents( EventType( ) )
    EndIf
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP