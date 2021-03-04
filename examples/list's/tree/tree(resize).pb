IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
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
    
    Select this()\event
      Case #PB_EventType_Change
        Debug  "change"
        
      Case #PB_EventType_LeftClick
        Select this()\widget
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
          Flag(*this, flag, GetState(this()\widget))
        EndIf
        Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  Define i, img = 0
  Define pos = 100
      
  If Open(OpenWindow(#PB_Any, 0, 0, width+20, height+20, "resize demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    *this = widget::tree(100, 100, 250, 200, #__flag_anchorsgadget |#__tree_optionBoxes | #__tree_nolines | #__tree_nobuttons );| #__tree_OptionBoxes)  ; |#__tree_GridLines
    
    For i = 1 To 6
      AddItem(*this, -1, "tree_add_item_"+Str(i), -1, -1) 
    Next 
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width-pos-#__splitter_buttonsize)
    SetState(Splitter_2, height-pos-#__splitter_buttonsize)
    
    Bind(*this, @events_widgets())
    ;Redraw(root())
    
    Debug " --v-- "
    Debug *this\scroll\v\bar\percent
    Debug *this\scroll\v\bar\page\pos
    Debug *this\scroll\v\bar\page\len
    Debug *this\scroll\v\bar\page\end
    Debug *this\scroll\v\bar\page\change
    Debug ""
    Debug *this\scroll\v\bar\thumb\pos
    Debug *this\scroll\v\bar\thumb\len
    Debug *this\scroll\v\bar\thumb\end
    Debug *this\scroll\v\bar\thumb\change
    Debug ""
    Debug *this\scroll\v\bar\area\pos
    Debug *this\scroll\v\bar\area\len
    Debug *this\scroll\v\bar\area\end
    Debug *this\scroll\v\bar\area\change
    Debug ""
    
    Debug " --h-- "
    Debug *this\scroll\h\bar\percent
    Debug *this\scroll\h\bar\page\pos
    Debug *this\scroll\h\bar\page\len
    Debug *this\scroll\h\bar\page\end
    Debug *this\scroll\h\bar\page\change
    Debug ""
    Debug *this\scroll\h\bar\thumb\pos
    Debug *this\scroll\h\bar\thumb\len
    Debug *this\scroll\h\bar\thumb\end
    Debug *this\scroll\h\bar\thumb\change
    Debug ""
    Debug *this\scroll\h\bar\area\pos
    Debug *this\scroll\h\bar\area\len
    Debug *this\scroll\h\bar\area\end
    Debug *this\scroll\h\bar\area\change
    Debug ""
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP