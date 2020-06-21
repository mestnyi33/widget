IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3
  Global Button_4, Button_5, Button_6, Button_7, Button_8, Button_9
  Define vert=100, horiz=100, width=450, height=400
  
  Procedure events_widgets()
    Protected flag
    
    Select *event\type
      Case #PB_EventType_Change
        Debug  "change"
        
      Case #PB_EventType_LeftClick
        Select *event\widget
          Case Button_type 
            
          Case Button_0 : flag = #__tree_nolines
          Case Button_1 : flag = #__tree_nobuttons
          Case Button_2 : flag = #__tree_checkboxes
          Case Button_3 : flag = #__tree_optionboxes
          Case Button_4 : flag = #__tree_threestate
          Case Button_5 : flag = #__tree_collapsed
          Case Button_6 : flag = #__tree_expanded
          Case Button_7 : flag = #__tree_gridlines
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(*event\widget))
        EndIf
        Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+55, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    
    Define img = 0
    Container(10,10,width, height)
    *this = widget::tree(100, 100, 250, 200, #__flag_anchorsgadget |#__tree_optionBoxes | #__tree_nolines | #__tree_nobuttons );| #__tree_OptionBoxes)  ; |#__tree_GridLines
    CloseList()
    
    ; ;     Define i
    ; ;     AddItem (*this, 0, "Tree_option_0", -1, 1)                                    
    ; ;     For i=1 To 6
    ; ;       If i=3 ;Or i%3=0
    ; ;         AddItem(*this, -1, "Tree_checkbox_"+Str(i), 0, 0) 
    ; ;       Else
    ; ;         AddItem(*this, -1, "Tree_option_"+Str(i), -1, -1) 
    ; ;       EndIf
    ; ;     Next 
    
    ;  2_example
    AddItem(*this, 0, "Tree_0", img )
    AddItem(*this, 1, "Tree_1_1", 0, 1) 
    AddItem(*this, 4, "Tree_1_1_1", img, 2) 
    AddItem(*this, 5, "Tree_1_1_2", img, 2) 
    AddItem(*this, 6, "Tree_1_1_2_1", img, 3) 
    AddItem(*this, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", img, 4) 
    AddItem(*this, 7, "Tree_1_1_2_2 980980_", img, 3) 
    AddItem(*this, 2, "Tree_1_2", img, 1) 
    AddItem(*this, 3, "Tree_1_3", img, 1) 
    AddItem(*this, 9, "Tree_2", img )
    AddItem(*this, 10, "Tree_3", img )
    AddItem(*this, 11, "Tree_4", img )
    AddItem(*this, 12, "Tree_5", img )
    AddItem(*this, 13, "Tree_6", img )
    
    SetItemState(*this, 0, #PB_Tree_Selected|#PB_Tree_Checked)
    SetItemState(*this, 5, #PB_Tree_Selected|#PB_Tree_Inbetween)
    
    ;             SetState(*this, 5) 
    ;             SetState(*this, 7) 
    ;             SetState(*this, 9) 
    
    Define y = 10
    ; flag
    Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
    Button_0 = widget::Button(width+45, y+30*1, 100, 26, "nolines", #__button_toggle) 
    Button_1 = widget::Button(width+45, y+30*2, 100, 26, "nobuttons", #__button_toggle) 
    Button_2 = widget::Button(width+45, y+30*3, 100, 26, "checkboxes", #__button_toggle) 
    Button_3 = widget::Button(width+45, y+30*4, 100, 26, "optionboxes", #__button_toggle) 
    Button_4 = widget::Button(width+45, y+30*5, 100, 26, "threestate", #__button_toggle) 
    Button_5 = widget::Button(width+45, y+30*6, 100, 26, "collapsed", #__button_toggle) 
    ;Button_6 = widget::Button(width+45, y+30*7, 100, 26, "expanded", #__button_toggle) 
    Button_7 = widget::Button(width+45, y+30*8, 100, 26, "gridlines", #__button_toggle) 
    
    ; set button toggled state
    SetState(Button_0, Flag(*this, #__tree_nolines))
    SetState(Button_1, Flag(*this, #__tree_nobuttons))
    SetState(Button_2, Flag(*this, #__tree_checkboxes))
    SetState(Button_3, Flag(*this, #__tree_optionboxes))
    SetState(Button_4, Flag(*this, #__tree_threestate))
    SetState(Button_5, Flag(*this, #__tree_collapsed))
    ;SetState(Button_6, Flag(*this, #__tree_expanded))
    SetState(Button_7, Flag(*this, #__tree_gridlines))
    ;     SetState(Button_8, Flag(*this, #__tree_nolines))
    ;     SetState(Button_9, Flag(*this, #__tree_nobuttons))
    Hide(Button_type, 1)
    
    Button(10, height+20, 60, 24,"remove")
    Button(75, height+20, 100, 24,"add")
    Button(180, height+20, 30, 24,"1")
    Button(180+30+4, height+20, 30, 24,"2")
    Button(180+60+8, height+20, 30, 24,"3")
    Button(285, height+20, 60, 24,"clear")
    
    Bind(#PB_All, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP