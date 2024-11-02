IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *this._s_widget, i, pos = 100, width=450, height=400
  Global Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
      
  If Open(0, 0, 0, width+20, height+20, "resize demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *this = widget::tree(100, 100, 250, 200, #PB_Tree_CheckBoxes )
    
    For i = 1 To 6
      AddItem(*this, -1, "tree_add_item_"+Str(i), -1, -1) 
    Next 
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #PB_Default, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #PB_Default, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #PB_Default, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #PB_Default, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width-pos-#__splittersize)
    SetState(Splitter_2, height-pos-#__splittersize)
    
     
;     Debug " --v-- "
;     Debug *this\scroll\v\bar\percent
;     Debug *this\scroll\v\bar\page\pos
;     Debug *this\scroll\v\bar\page\len
;     Debug *this\scroll\v\bar\page\end
;     Debug *this\scroll\v\bar\page\change
;     Debug ""
;     Debug *this\scroll\v\bar\thumb\pos
;     Debug *this\scroll\v\bar\thumb\len
;     Debug *this\scroll\v\bar\thumb\end
;     Debug *this\scroll\v\bar\thumb\change
;     Debug ""
;     Debug *this\scroll\v\bar\area\pos
;     Debug *this\scroll\v\bar\area\len
;     Debug *this\scroll\v\bar\area\end
;     Debug *this\scroll\v\bar\area\change
;     Debug ""
;     
;     Debug " --h-- "
;     Debug *this\scroll\h\bar\percent
;     Debug *this\scroll\h\bar\page\pos
;     Debug *this\scroll\h\bar\page\len
;     Debug *this\scroll\h\bar\page\end
;     Debug *this\scroll\h\bar\page\change
;     Debug ""
;     Debug *this\scroll\h\bar\thumb\pos
;     Debug *this\scroll\h\bar\thumb\len
;     Debug *this\scroll\h\bar\thumb\end
;     Debug *this\scroll\h\bar\thumb\change
;     Debug ""
;     Debug *this\scroll\h\bar\area\pos
;     Debug *this\scroll\h\bar\area\len
;     Debug *this\scroll\h\bar\area\end
;     Debug *this\scroll\h\bar\area\change
;     Debug ""
;     
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 25
; FirstLine = 20
; Folding = -
; EnableXP
; DPIAware