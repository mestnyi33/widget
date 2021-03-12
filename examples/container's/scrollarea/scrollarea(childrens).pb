;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global g,*g._s_widget, b,*b, i, time, Sw = 350, Sh = 300, gcount=10000, wcount=10000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    Debug ""+EventWidget()+ " - widget event - " +WidgetEventType()
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    g = ScrollAreaGadget(#PB_Any, 10, 10, 290, 300, Sw, Sh, 15, #PB_ScrollArea_Flat)
    SetGadgetColor(g, #PB_Gadget_BackColor, $00FFFF)
    
    ButtonGadget  (1,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (2,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (3,  90,  90, 230, 30,"Button 3")
    TextGadget    (4, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    
    *g = ScrollArea(310, 10, 290, 300, Sw, Sh, 15, #PB_ScrollArea_Flat)
    SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    
    Button(10,  10, 230, 30,"Button 1")
    Button(50,  50, 230, 30,"Button 2") ;: SetAlignment(widget(), #__align_right)
    Button(90,  90, 230, 30,"Button 3")
    Text(130, 130, 330, 20,"This is the content of a ScrollAreaWidget!", #__text_right)
    ; SetColor(widget(), #PB_Gadget_BackColor, -1)
    
    *b = Button(Sw-130, Sh-30, 130, 30,"Button")
    CloseList()
    
    ;
    Splitter(10,10,590,480, 0, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
    If gcount
      OpenGadgetList(g)
      time = ElapsedMilliseconds()
      For i=0 To gcount
        If Bool(i>gcount-110)
          ButtonGadget  (#PB_Any, (gcount-i)*2, (gcount-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add gadget "+ gcount
      CloseGadgetList()
    EndIf
    
    If wcount
      OpenList(*g)
      time = ElapsedMilliseconds()
      For i=0 To wcount
        If Bool(i>wcount-110)
          Button((wcount-i)*2, (wcount-i)*2, 130, 30,"Button"+Str(i))
        Else
          Button(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget "+ wcount
      CloseList()
    EndIf
    
    
    
    BindGadgetEvent(g, @events_gadgets())
    Bind(*g, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP