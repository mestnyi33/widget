IncludePath "../../../../"
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
           Message( "message", "demo click", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info | #__message_ScreenCentered )
           
        Case #__event_LeftUp   : result = 1 : AddItem(w_flag, -1, "  leftup")
           Debug "leftup"
           
        Case #__Event_LeftClick      : result = 1 : AddItem(w_flag, -1, "   click") 
           Debug "click"
           
        Case #__Event_Left2Click     : result = 1 : AddItem(w_flag, -1, "     2_click") 
        Case #__Event_Left3Click     : result = 1 : AddItem(w_flag, -1, "       3_click") 
        Case #__Event_Up             : result = 1 : AddItem(w_flag, -1, "up")
     EndSelect
     
     If result
        SetState(w_flag, CountItems(w_flag) - 1)
     EndIf
  EndProcedure
  
  If Open(1, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    w_flag = Tree(10, 10, 150, 200, #__flag_nobuttons | #__flag_nolines) 
    w_this = Button(10, 220, 150, 70, "Click me", #__flag_Textmultiline );| #PB_Button_Toggle) 
    
    ; Bind(w_this, @events_widgets( ), #PB_All )
    ; Bind(w_this, @events_widgets( ), #__Event_Draw)
    Bind(w_this, @events_widgets( ), #__Event_DragStart)
    Bind(w_this, @events_widgets( ), #__Event_Drop)
    ; Bind(w_this, @events_widgets( ), #__Event_Down)
    ; Bind(w_this, @events_widgets( ), #__Event_Up)
    Bind(w_this, @events_widgets( ), #__event_LeftDown)
    Bind(w_this, @events_widgets( ), #__event_LeftUp)
    Bind(w_this, @events_widgets( ), #__Event_LeftClick)
    Bind(w_this, @events_widgets( ), #__Event_Left2Click)
    Bind(w_this, @events_widgets( ), #__Event_Left3Click)
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 56
; FirstLine = 34
; Folding = -
; EnableXP
; DPIAware