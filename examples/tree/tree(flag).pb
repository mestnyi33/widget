IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Button_6
  Define vert=100, horiz=100, width=400, height=400
  
  Procedure events_widgets()
    Protected flag
    
    Select *event\type
      Case #PB_EventType_LeftClick
        Select *event\widget
          Case *this
            If Flag(*this, #__button_toggle)
              SetState(Button_4, GetState(*event\widget))
            EndIf
            
          Case Button_type 
            
          Case Button_0 : flag = #__tree_nolines
          Case Button_1 : flag = #__tree_nobuttons
          Case Button_2 : flag = #__tree_checkboxes
          Case Button_3 : flag = #__tree_threestate
          Case Button_4 : flag = #__tree_collapsed
          Case Button_5 : flag = #__tree_expanded
          Case Button_6 : flag = #__tree_gridlines
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(*event\widget))
        EndIf
        Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    
    *this = widget::tree(100, 100, 250, 200, #__flag_anchorsgadget | #__tree_nolines) 
    ;  2_example
    AddItem(*this, 0, "Tree_0", -1 )
    AddItem(*this, 1, "Tree_1_1", 0, 1) 
    AddItem(*this, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*this, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*this, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*this, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*this, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*this, 2, "Tree_1_2", -1, 1) 
    AddItem(*this, 3, "Tree_1_3", -1, 1) 
    AddItem(*this, 9, "Tree_2",-1 )
    AddItem(*this, 10, "Tree_3", -1 )
    AddItem(*this, 11, "Tree_4", -1 )
    AddItem(*this, 12, "Tree_5", -1 )
    AddItem(*this, 13, "Tree_6", -1 )
    
    Define y = 10
    ; flag
    Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
    Button_0 = widget::Button(width+45, y+30*1, 100, 26, "nolines", #__button_toggle) 
    Button_1 = widget::Button(width+45, y+30*2, 100, 26, "nobuttons", #__button_toggle) 
    Button_2 = widget::Button(width+45, y+30*3, 100, 26, "checkboxes", #__button_toggle) 
    Button_3 = widget::Button(width+45, y+30*4, 100, 26, "threestate", #__button_toggle) 
    Button_4 = widget::Button(width+45, y+30*5, 100, 26, "collapsed", #__button_toggle) 
    Button_5 = widget::Button(width+45, y+30*6, 100, 26, "expanded", #__button_toggle) 
    Button_6 = widget::Button(width+45, y+30*7, 100, 26, "gridlines", #__button_toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(Button_0, Flag(*this, #__tree_nolines))
    Hide(Button_type, 1)
    
;     Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
;     Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
;     Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
;     Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
;     SetState(Splitter_3, width-40-horiz)
;     SetState(Splitter_2, height-40-vert)
;     SetState(Splitter_0, vert)
;     SetState(Splitter_1, horiz)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP