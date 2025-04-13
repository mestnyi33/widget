; FIXED
XIncludeFile "../../widgets.pbi"
;   WordWrap ! 1
;         SetGadgetAttribute(0, #PB_Editor_WordWrap, WordWrap)

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define a,i
   Define g, Text.s
   ; Define m.s=#CRLF$
   Define m.s=#LF$
   Global Splitter
   test_draw_repaint = 1
   
   Text.s = "This is a long line." + m.s +
            "Who should show." + m.s +
            m.s +
            m.s +
            "I have to write the text in the box or not." + m.s +
            m.s +
            m.s +
            "The string must be very long." + m.s +
            "Otherwise it will not work."
   
   Procedure ResizeCallBack()
      Debug "Resize window"
      Resize(Splitter, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate), WindowHeight(EventWindow(), #PB_Window_InnerCoordinate))
      ; PostReDraw( root())
      
      SetState(widget(), 100 )
      
      Debug ""+widget()\bar\page\pos  +" = "+ widget()\bar\thumb\pos
      Debug ""+widget()\bar\page\end  +" = "+ widget()\bar\area\end
      Debug ""+widget()\bar\thumb\end +" = "+ widget()\bar\area\len

   EndProcedure
   
   LoadFont(1, "Courier", 14)
   If Open(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      
      EditorGadget(0, 0, 0, 0, 0) ; bug PB
      SetGadgetText(0, Text.s)
      AddGadgetItem(0, 3, "add line "+Str(3))
      AddGadgetItem(0, 7, "add line "+Str(7))
      ; SetGadgetFont(0, FontID(1))
      
      ;g=Editor(8, 146, 306, 133) 
      g=Editor(0, 0, 0, 0) 
      SetBackColor(widget(), $FFB3FDFF)
      SetText(g, Text.s)
      AddItem(g, 3, "add line "+Str(3))
      AddItem(g, 7, "add line "+Str(7))
      ; SetFont(g, FontID(1))
      
      Splitter = Splitter(0, 0, 306, 276, 0,g);, #__flag_autosize)
      
      ; PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
      BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
      
     
      
;       
; ;       Debug widget()\bar\min
; ;       Debug widget()\bar\max
; ;       Debug ""
;       Debug widget()\bar\page\pos
; ;       Debug widget()\bar\page\len
;       Debug widget()\bar\page\end
;       Debug ""
;       Debug widget()\bar\thumb\pos
; ;       Debug widget()\bar\thumb\len
;       Debug widget()\bar\thumb\end
;       Debug ""
; ;       Debug widget()\bar\area\pos
;       Debug widget()\bar\area\len
;       Debug widget()\bar\area\end
;       
;       bar_is_first_gadget_ 2309259622688
;       0
;       0
;       133
;       0
;       267
;       133
;       9
;       276
;       0
;       276
;       267
;       Resize window
;       REPAINT root
      
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
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 50
; FirstLine = 46
; Folding = -
; EnableXP