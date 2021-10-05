IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  EnableExplicit
  
  Global w_this, w_flag
  
  Procedure events_widgets()
    Protected result
    Static _2click
    Select WidgetEventType( )
;       Case #PB_EventType_Draw ;: result = 1 : AddItem(w_flag, -1, " ------------ draw")
;         Debug "draw"
;         
      Case #PB_EventType_LeftButtonDown  : Debug  "down"
      Case #PB_EventType_DragStart       : Debug  " drag"
      Case #PB_EventType_Drop            : Debug  " drop"
      Case #PB_EventType_LeftButtonUp    : Debug  "up"
      Case #PB_EventType_LeftClick       : Debug  " click"
      Case #PB_EventType_LeftDoubleClick : Debug  "  2_click"
    EndSelect
    Select WidgetEventType( )
      Case #PB_EventType_Draw ;: result = 1 : AddItem(w_flag, -1, " ------------ draw")
        Debug "draw"
        
      Case #PB_EventType_LeftButtonDown : result = 1
        If _2click = 2
          _2click = 0
          ClearItems(w_flag)
        EndIf
        AddItem(w_flag, -1, "down")
        
      Case #PB_EventType_LeftButtonUp    : result = 1 : AddItem(w_flag, -1, " up")
      Case #PB_EventType_LeftClick       : result = 1 : AddItem(w_flag, -1, "  click") : _2click + 1
      Case #PB_EventType_LeftDoubleClick : result = 1 : AddItem(w_flag, -1, "   2_click") : _2click = 2
    EndSelect
    
    If result
      SetState(w_flag, countitems(w_flag) - 1)
    EndIf
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    w_flag = widget::Tree(10, 10, 150, 200, #__tree_nobuttons | #__tree_nolines) 
    w_this = widget::Button(10, 220, 150, 70, "Click me", #__button_multiline );| #__button_toggle) 
    
    ; widget::Bind(w_this, @events_widgets(), #PB_All )
    
    ;widget::Bind(w_this, @events_widgets(), #PB_EventType_Draw)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_DragStart)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_Drop)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonDown)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonUp)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftClick)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftDoubleClick)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP