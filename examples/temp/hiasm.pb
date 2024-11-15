XIncludeFile "../../widgets.pbi"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  Global Button_4, Button_5, Button_6, Button_7, Button_8, Button_9
  Define vert=100, horiz=100, width=450, height=400
  
  Procedure events_widgets()
    Protected flag
    
    Select WidgetEvent( )
      Case #PB_EventType_Change
        Debug  "change"
        
      Case #PB_EventType_LeftClick
        Select EventWidget( )
          Case Button_type 
            
          Case Button_0 : flag = #__tree_nolines
          Case Button_1 : flag = #__tree_nobuttons
          Case Button_2 : flag = #__tree_checkboxes
          Case Button_3 : flag = #__flag_optionboxes
          Case Button_4 : flag = #__tree_threestate
          Case Button_5 : flag = #__flag_collapsed;d
          ;Case Button_6 : flag = #__tree_expanded
          Case Button_7 : flag = #__flag_gridlines
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget( )))
        EndIf
        ;Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, width+180, height+55, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    
    Define img = 0
    Container(10,10,width, height)
    *this = widget::tree(100, 100, 250, 200,  #__flag_optionboxes | #__tree_nolines | #__tree_nobuttons );| #__flag_optionboxes)  ; |#__tree_GridLines
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
    AddItem(*this, 0, "do", -1, 1)
    AddItem(*this, 0, "do", -1, 1)
    AddItem(*this, 0, "do", -1, 1)
    AddItem(*this, 0, "set", -1, 2)
    AddItem(*this, 0, "set", -1, 2)
    AddItem(*this, 0, "set", -1, 2)
    AddItem(*this, 0, "on", -1, 3)
    AddItem(*this, 0, "on", -1, 3)
    AddItem(*this, 0, "on", -1, 3)
    AddItem(*this, 0, "get", -1, 4)
    AddItem(*this, 0, "get", -1, 4)
    AddItem(*this, 0, "get", -1, 4)
    
    SetItemState(*this, 0, #PB_Tree_Selected|#PB_Tree_Checked)
    SetItemState(*this, 5, #PB_Tree_Selected|#PB_Tree_Inbetween)
    
    ;             SetState(*this, 5) 
    ;             SetState(*this, 7) 
    ;             SetState(*this, 9) 
    
    Define y = 10
    ; flag
    Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__flag_ButtonToggle) 
    Button_0 = widget::Button(width+45, y+30*1, 100, 26, "nolines", #__flag_ButtonToggle) 
    Button_1 = widget::Button(width+45, y+30*2, 100, 26, "nobuttons", #__flag_ButtonToggle) 
    Button_2 = widget::Button(width+45, y+30*3, 100, 26, "checkboxes", #__flag_ButtonToggle) 
    Button_3 = widget::Button(width+45, y+30*4, 100, 26, "optionboxes", #__flag_ButtonToggle) 
    Button_4 = widget::Button(width+45, y+30*5, 100, 26, "threestate", #__flag_ButtonToggle) 
    Button_5 = widget::Button(width+45, y+30*6, 100, 26, "collapsed", #__flag_ButtonToggle) 
    ;Button_6 = widget::Button(width+45, y+30*7, 100, 26, "expanded", #__flag_ButtonToggle) 
    Button_7 = widget::Button(width+45, y+30*8, 100, 26, "gridlines", #__flag_ButtonToggle) 
    
    ; set button toggled state
    SetState(Button_0, Flag(*this, #__tree_nolines))
    SetState(Button_1, Flag(*this, #__tree_nobuttons))
    SetState(Button_2, Flag(*this, #__tree_checkboxes))
    SetState(Button_3, Flag(*this, #__flag_optionboxes))
    SetState(Button_4, Flag(*this, #__tree_threestate))
    ;SetState(Button_5, Flag(*this, #__flag_collapsedd))
    ;SetState(Button_6, Flag(*this, #__tree_expanded))
    SetState(Button_7, Flag(*this, #__flag_gridlines))
    ;     SetState(Button_8, Flag(*this, #__tree_nolines))
    ;     SetState(Button_9, Flag(*this, #__tree_nobuttons))
    HideWidget(Button_type, 1)
    
    Button(10, height+20, 60, 24,"remove")
    Button(75, height+20, 100, 24,"add")
    Button(180, height+20, 30, 24,"1")
    Button(180+30+4, height+20, 30, 24,"2")
    Button(180+60+8, height+20, 30, 24,"3")
    Button(285, height+20, 60, 24,"clear")
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    Define pos = 80
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width-pos-#__splittersize)
    SetState(Splitter_2, height-pos-#__splittersize)
    
    Bind(#PB_All, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 110
; FirstLine = 105
; Folding = --
; EnableXP
; DPIAware