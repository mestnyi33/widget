; 22537 - time add gadget 10000

CompilerIf #PB_Compiler_IsMainFile
  Global show, ev, g, b, i, time, Sw = 350, Sh = 300, gcount=10000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  If OpenWindow(#PB_Any, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g = ScrollAreaGadget(#PB_Any, 10, 10, 290, 300, Sw, Sh, 1, #PB_ScrollArea_Flat)
    SetGadGetWidgetColor(g, #PB_Gadget_BackColor, $00FFFF)
    BindGadgetEvent(g, @events_gadgets(), #PB_EventType_LeftClick)
    BindGadgetEvent(g, @events_gadgets(), #PB_EventType_Resize)
    
    ButtonGadget  (1,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (2,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (3,  90,  90, 230, 30,"Button 3")
    TextGadget    (4, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    
    ;
    SplitterGadget(-1, 10,10,590,480, TextGadget(-1,0,0,0,0,""), SplitterGadget(-1, 0,0,0,0,TextGadget(-1,0,0,0,0,""), g, #PB_Splitter_Separator|#PB_Splitter_Vertical), #PB_Splitter_Separator)
    
    If gcount
      OpenGadgetList(g)
      time = ElapsedMilliseconds()
      For i=1 To gcount
        If Bool(i>gcount-110)
          ButtonGadget  (#PB_Any, (gcount-i)*2, (gcount-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      CloseGadgetList()
    EndIf
    
    Repeat 
    	ev = WaitWindowEvent()
    	If ev = - 1
    		If show = 0
    			show = 1
    		  Debug  Str(ElapsedMilliseconds()-time) + " - time add gadget "+ gcount
         EndIf
    	EndIf
    Until ev = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 6
; Folding = --
; EnableXP