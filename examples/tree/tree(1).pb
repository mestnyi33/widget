IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, *tList, *vList, *pList
  Global tList, vList, pList
  
  Enumeration 
;   #_pi_group_0 
;   #_pi_id
  #_pi_class
  #_pi_text
  
;   #_pi_group_1 
  #_pi_x
  #_pi_y
  #_pi_width
  #_pi_height
  
;   #_pi_group_2 
;   #_pi_disable
;   #_pi_hide
EndEnumeration

Define vert=100, horiz=100, width=400, height=400
  
  Procedure events_widgets()
    Static text.s
    
    If *event\widget\mode\transform
        
          Select *event\type
            Case #PB_EventType_LeftButtonDown
              
              
            Case #PB_EventType_StatusChange
              Debug "status - id " + GetData(*event\widget)
              
              SetItemState(*tlist, GetData(*event\widget), #PB_Tree_Selected)
              Case #PB_EventType_Focus
              Debug "focus"
              
            Case #PB_EventType_LostFocus
              Debug "lostfocus"
              
            Case #PB_EventType_LeftClick
              
              ; Post(#__event_repaint, #PB_All)
          EndSelect
        
    Else
      Select *event\widget
        Case *tList
          Select *event\type
            Case #PB_EventType_Change
              text.s = "button"
          EndSelect
      EndSelect
    EndIf
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180+170, height+45, "transform", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 0, 0, width+180, height+45)
    
    Define item
    Define y = 10
    *tList = Tree(width+20, y, 150, 145-y)
    
    AddItem(*tlist, -1, "Root", -1, 0)
      
    For item = 0 To 5
        AddItem(*tlist, -1, widget()\class);, -1, widget()\level + 1)
       ; SetItemState(*tlist, item, #PB_Tree_Selected)
    Next
      
      SetItemState(*tlist, 1, #PB_Tree_Selected)
      SetItemState(*tlist, 2, #PB_Tree_Selected)
      
    Bind(#PB_All, @events_widgets())
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP