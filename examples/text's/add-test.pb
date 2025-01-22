
XIncludeFile "../../widgets.pbi"
;   WordWrap ! 1
;         SetGadgetAttribute(0, #PB_Editor_WordWrap, WordWrap)


; Key 
;         (UP & Down) переход коретки на один итем верх или вниз и делаем видимим итем на который перешла коретка
;         (PageUP & PageDown) прокрутка на одну страницу верх и вниз 
; Ctrl -  (PageUP & PageDown) прокрутка на один итем верх и вниз коретка остается на том же итеме
; Shift - (PageUP & PageDown) выделения на один итем верх и вниз если доходим на первый или последный выдимий итем то прокручиваем
;         (Left&Right) 
;
;
;
;
;
;
;
;
;


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_edit_text = 1
   
   Define g, *g, Text.s, m.s=#LF$
   
   Text.s = "This is a long line." + m.s +
            "Who should show." + m.s +
            m.s +
            m.s +
            "I have to write the text in the box or not." + m.s +
            m.s +
            m.s +
            "The string must be very long." + m.s +
            "Otherwise it will not work."
   
   
   LoadFont(1, "Courier", 14)
   If Open(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      
      g = EditorGadget(#PB_Any, 8, 8, 306, 133) 
      ;g = EditorGadget(#PB_Any, 0, 0, 0, 0) ; bug PB on windows 
      
      SetGadgetText(g,     "012345" )
     ; SetGadgetText(g,     "012345" +#LF$ )
     ; SetGadgetText(g,     "012345" +#LF$+ "012345" )
     ; SetGadgetText(g,     "012345" +#LF$+ "012345"+#LF$ )
     AddGadgetItem(g, -1, "-text-" )
    
      *g = Editor(8, 146, 306, 133) 
      ;*g = Editor(0, 0, 0, 0) 
      SetBackgroundColor(*g, $FFB3FDFF)
;       SetText(*g, Text.s)
;       AddItem(*g, 0, "add line first")
;       AddItem(*g, 4, "add line "+Str(4))
;       AddItem(*g, 8, "add line "+Str(8))
;       AddItem(*g, -1, "add line last")
;       ; SetFont(*g, FontID(1))
      SetText(*g,     "012345")
      ;SetText(*g,     "012345" +#LF$)
      ;SetText(*g,     "012345" +#LF$+ "012345")
      ;SetText(*g,     "012345" +#LF$+ "012345"+#LF$)
      AddItem(*g, -1, "-text-" )
    
      Splitter(8, 8, 306, 276, g, *g, #__flag_autosize)
      
      Repeat
         Define Event = WaitWindowEvent()
         
         Select Event
            Case #PB_Event_LeftClick 
               SetActiveGadget(0)
            Case #PB_Event_RightClick
               SetActiveGadget(10)
         EndSelect
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 66
; FirstLine = 40
; Folding = -
; EnableXP
; DPIAware