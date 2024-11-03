;XIncludeFile "../../gadgets.pbi" : UseModule gadget

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, Xalign.f)
      gtk_label_set_yalign(*Label.GtkLabel, Yalign.F)
    EndImport
  CompilerEndIf
  
  Procedure SetTextAlignment(gadget, pos)
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      If pos & #PB_Text_Center
        pos = #NSCenterTextAlignment
      ElseIf pos & #PB_Text_Right
        pos = #NSRightTextAlignment
      EndIf
      If pos
        CocoaMessage(0,GadgetID(gadget),"setAlignment:", pos)
      EndIf
      
      CocoaMessage(0, CocoaMessage(0, GadgetID(gadget), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, GadgetID(gadget), "setNeedsDisplay:", #True)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
      SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(3), #GWL_STYLE, GetWindowLong_(GadgetID(3), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(4), #GWL_STYLE, GetWindowLong_(GadgetID(4), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(5), #GWL_STYLE, GetWindowLong_(GadgetID(5), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(6), #GWL_STYLE, GetWindowLong_(GadgetID(6), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(7), #GWL_STYLE, GetWindowLong_(GadgetID(7), #GWL_STYLE)|#SS_CENTERIMAGE)
      
      SetWindowLongPtr_(GadgetID(8), #GWL_STYLE, GetWindowLong_(GadgetID(8), #GWL_STYLE)|#SS_CENTERIMAGE)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      ;gtk_text_view_set_justification_(GadgetID(Editor), #GTK_JUSTIFY_CENTER)
      
      gtk_label_set_yalign(GadgetID(8), 0.5)
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define h = 185, bh = 26
  Define *g1, *g2, *g3, *g4, *g5, *g6
  
  If OpenWindow(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = StringGadget(#PB_Any,     30, 30, 200, h, "left 00000000000000000000000000000000000")
    SetTextAlignment(*g1, 0 )
    
    *g2 = StringGadget(#PB_Any, 30+210, 30, 200, h, "0000000000000000000 center 00000000000000000000")
    SetTextAlignment(*g2, #PB_Text_Center )
    
    *g3 = StringGadget(#PB_Any, 30+420, 30, 200, h, "00000000000000000000000000000000000 right")
    SetTextAlignment(*g3, #PB_Text_Right )
    
    *g4 = SplitterGadget(#PB_Any, 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = SplitterGadget(#PB_Any, 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = SplitterGadget(#PB_Any, 30,30,620,h, *g5,TextGadget(#PB_Any, 0,0,0,0,""))
    
    SetGadgetState(*g4, 200)
    SetGadgetState(*g5, 200*2)
    SetGadgetState(*g6, h)
    
    SetGadgetAttribute(*g2, #PB_ScrollArea_X, 114/2 )
    SetGadgetAttribute(*g3, #PB_ScrollArea_X, 94 )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP