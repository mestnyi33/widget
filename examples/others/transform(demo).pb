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
              
              SetState(*tlist, GetData(*event\widget))
              SetGadgetState(tlist, GetData(*event\widget))
      
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
    ;Root()\mode\transform = 1
    ;a_add(Root())
    
    widget::Button(10, 10, 150, 100, text, #__button_multiline|#__flag_anchorsgadget) 
    
    *this = widget::Window(100, 100, 250, 200, text,#__window_nogadgets|#__flag_anchorsgadget) 
    ;*this = widget::ScrollArea(100, 100, 250, 200, 300,300,1,#__window_nogadgets|#__flag_anchorsgadget) 
    ;*this = widget::Container(100, 100, 250, 200, #__flag_anchorsgadget) 
    
    OpenList(*this)
    widget::Button(10, 10, 150, 100, text, #__button_multiline) 
    
    widget::Container(100, 100, 150, 100) 
    ;widget::Panel(100, 100, 150, 100,#__flag_anchorsgadget) : AddItem(widget(), -1, "Panel")
    ;widget::ScrollArea(100, 100, 250, 200, 300,300,1, #__flag_anchorsgadget) 
    
    *this = widget::Button(10, 10, 100, 50, "button", #__button_multiline) 
    CloseList()
    CloseList()
    
    Define item
    Define y = 10
    *tList = Tree(width+20, y, 150, 145-y)
    
    AddItem(*tlist, -1, "Root", -1, 0)
      
    ForEach widget()
      If widget()\mode\transform
        item = CountItems(*tlist) ; - 1
        AddItem(*tlist, -1, widget()\class, -1, widget()\level + 1)
        ;SetItemState(*tlist, item, #PB_Tree_Selected)
        SetItemData(*tlist, item, Widget())
        SetData(Widget(), item)
      EndIf
    Next
    ;hide(*tList, 1)
    SetState(*tList, item)
    
    tList = TreeGadget(-1, width+190, y, 150, 145-y)
    
    AddGadgetItem(tList, -1, "Root")
      
    ForEach widget()
      If widget()\mode\transform
        item = CountGadgetItems(tList) ; - 1
        AddGadgetItem(tList, -1, widget()\class, 0, widget()\level + 1)
        SetGadgetItemData(tList, item, Widget())
        SetData(Widget(), item)
      EndIf
    Next
    
    Define i : For i=0 To CountGadgetItems(tList) : SetGadgetItemState(tList, i, #PB_Tree_Expanded) : Next
    SetGadgetState(tList, item)
    
    
    *vlist = ListView(width+20, y+145*1, 150, 145-y)
    AddItem(*vlist, -1, "Button")
    AddItem(*vlist, -1, "Window")
    AddItem(*vlist, -1, "Container")
    
    *plist = Tree_Properties(width+20, y+145*2, 150, 145-y)
    AddItem(*plist, #_pi_class, "class:"+Chr(10)+GetClass(*this)+"_"+GetCount(*this), #PB_GadgetType_String, 1)
    AddItem(*plist, #_pi_text, "text:"+Chr(10)+GetText(*this), #PB_GadgetType_String, 1)
    AddItem(*plist, #_pi_x, "x:"+Chr(10)+Str(X(*this)), #PB_GadgetType_Spin, 1)
    AddItem(*plist, #_pi_y, "y:"+Chr(10)+Str(Y(*this)), #PB_GadgetType_Spin, 1)
    AddItem(*plist, #_pi_width, "width:"+Chr(10)+Str(Width(*this)), #PB_GadgetType_Spin, 1)
    AddItem(*plist, #_pi_height, "height:"+Chr(10)+Str(Height(*this)), #PB_GadgetType_Spin, 1)
    
    Bind(#PB_All, @events_widgets())
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP