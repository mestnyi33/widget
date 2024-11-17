IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  
  Global w_this, w_flag
  
  Procedure events_widgets()
     Protected result
     
     Select WidgetEvent( )
        Case #__Event_Draw ;         : result = 1 : AddItem(w_flag, -1, " ------------ draw")
           Debug "draw"
           
        Case #__Event_Down           : result = 1 : AddItem(w_flag, -1, "down")
           
        Case #__event_LeftDown : 
           Debug "leftdown"
           result = 1 : AddItem(w_flag, -1, " leftdown")
           MessageWidget( "message", "demo click", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info | #__message_ScreenCentered )
           
        Case #__event_LeftUp   : result = 1 : AddItem(w_flag, -1, "  leftup")
           Debug "leftup"
           
        Case #__Event_LeftClick      : result = 1 : AddItem(w_flag, -1, "   click") 
           Debug "click"
           
        Case #__Event_Left2Click     : result = 1 : AddItem(w_flag, -1, "     2_click") 
        Case #__Event_Left3Click     : result = 1 : AddItem(w_flag, -1, "       3_click") 
        Case #__Event_Up             : result = 1 : AddItem(w_flag, -1, "up")
     EndSelect
     
     If result
        SetState(w_flag, countitems(w_flag) - 1)
     EndIf
  EndProcedure
  
  If OpenRootWidget(1, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    w_flag = widget::TreeWidget(10, 10, 150, 200, #__tree_nobuttons | #__tree_nolines) 
    w_this = widget::ButtonWidget(10, 220, 150, 70, "Click me", #__flag_Textmultiline );| #__flag_ButtonToggle) 
    
    ; widget::BindWidgetEvent(w_this, @events_widgets( ), #PB_All )
    ; widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Draw)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_DragStart)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Drop)
    ; widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Down)
    ; widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Up)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__event_LeftDown)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__event_LeftUp)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_LeftClick)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Left2Click)
    widget::BindWidgetEvent(w_this, @events_widgets( ), #__Event_Left3Click)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 27
; Folding = -
; EnableXP
; DPIAware