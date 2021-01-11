IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, *g, *vList, *pList
  Global g, vList, pList
  
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
    
    If this()\widget\transform
      
      Select this()\event
        Case #PB_EventType_LeftButtonDown
          
          
        Case #PB_EventType_StatusChange
          Debug "status - id " + GetData(this()\widget)
          
          SetItemState(*g, GetData(this()\widget), #PB_Tree_Selected)
        Case #PB_EventType_Focus
          Debug "focus"
          
        Case #PB_EventType_LostFocus
          Debug "lostfocus"
          
        Case #PB_EventType_LeftClick
          
          ; Post(#__event_repaint, #PB_All)
      EndSelect
      
    Else
      Select this()\widget
        Case *g
          Select this()\event
            Case #PB_EventType_Change
              text.s = "button"
          EndSelect
      EndSelect
    EndIf
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180+170, height+45, "transform", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 0, 0, width+180, height+45)
    
    Define i
    Define y = 10
    
    g = TreeGadget(-1,10, y, 150, 145-y)
    *g = Tree(170, y, 150, 145-y)
    
    AddItem(*g, -1, "Root", -1, 0)
    AddGadgetItem(g, -1, "Root", 0, 0)
    
    For i = 0 To 15
      AddGadgetItem(g, -1, "Tree_"+Str(i), 0,1)
      AddItem(*g, -1, "Tree_"+Str(i), -1, 1)
    Next
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    SetItemState(*g, 1, #PB_Tree_Selected)
    SetItemState(*g, 1, #PB_Tree_Selected)
    SetItemState(*g, 2, #PB_Tree_Selected)
    SetItemState(*g, 3, #PB_Tree_Selected)
    
    SetGadgetItemState(g, 1, #PB_Tree_Selected)
    SetGadgetItemState(g, 1, #PB_Tree_Selected)
    SetGadgetItemState(g, 2, #PB_Tree_Selected)
    SetGadgetItemState(g, 3, #PB_Tree_Selected)
    
    Bind(#PB_All, @events_widgets())
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP