IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  EnableExplicit
  
  Global w_this, w_flag
  
  Procedure events_widgets()
    Protected result
  
    Select WidgetEventType( )
      Case #__Event_Draw ;         : result = 1 : AddItem(w_flag, -1, " ------------ draw")
        Debug "draw"
        
      Case #__Event_Down           : result = 1 : AddItem(w_flag, -1, "down")
      Case #__Event_LeftButtonDown : result = 1 : AddItem(w_flag, -1, " leftdown")
      Case #__Event_LeftButtonUp   : result = 1 : AddItem(w_flag, -1, "  leftup")
      Case #__Event_LeftClick      : result = 1 : AddItem(w_flag, -1, "   click") 
      Case #__Event_Left2Click     : result = 1 : AddItem(w_flag, -1, "     2_click") 
      Case #__Event_Left3Click     : result = 1 : AddItem(w_flag, -1, "       3_click") 
      Case #__Event_Up             : result = 1 : AddItem(w_flag, -1, "up")
    EndSelect
    
    If result
      SetState(w_flag, countitems(w_flag) - 1)
    EndIf
  EndProcedure
  
  If Open(1, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    w_flag = widget::Tree(10, 10, 150, 200, #__tree_nobuttons | #__tree_nolines) 
    w_this = widget::Button(10, 220, 150, 70, "Click me", #__button_multiline );| #__button_toggle) 
    
    ; widget::Bind(w_this, @events_widgets(), #PB_All )
    ; widget::Bind(w_this, @events_widgets(), #__Event_Draw)
    widget::Bind(w_this, @events_widgets(), #__Event_DragStart)
    widget::Bind(w_this, @events_widgets(), #__Event_Drop)
    ; widget::Bind(w_this, @events_widgets(), #__Event_Down)
    ; widget::Bind(w_this, @events_widgets(), #__Event_Up)
    widget::Bind(w_this, @events_widgets(), #__Event_LeftButtonDown)
    widget::Bind(w_this, @events_widgets(), #__Event_LeftButtonUp)
    widget::Bind(w_this, @events_widgets(), #__Event_LeftClick)
    widget::Bind(w_this, @events_widgets(), #__Event_LeftDoubleClick)
    widget::Bind(w_this, @events_widgets(), #__Event_Left3Click)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP