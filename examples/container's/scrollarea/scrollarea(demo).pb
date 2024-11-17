XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global g,*g._s_widget, b,*b, i, time, Sw = 350, Sh = 300, count;=1000;0
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(GetIndex(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
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
    
    Button(10,  10, 230, 30, "Button 1")
    Button(50,  50, 230, 30, "Button 2") ;: SetAlign(widget(), #__align_right)
    Button(90,  90, 230, 30, "Button 3")
    Text(130, 130, 330, 20,"This is the content of a ScrollAreaWidget!", #__flag_Textright)
    ; SetColor(widget(), #PB_Gadget_BackColor, -1)
    
    *b = Button(Sw-130, Sh-30, 130, 30, "Button")
    CloseList()
    
    ;
    Splitter(10,10,590,480, 0, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
    If count
      OpenGadgetList(g)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          ButtonGadget  (#PB_Any, (count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add gadget" 
      CloseGadgetList()
      
      OpenList(*g)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          Button((count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          Button(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget"
      CloseList()
    EndIf
    
    ; set&get demos
    If Not count
      SetGadgetAttribute(g, #PB_ScrollArea_X, 50)
      SetAttribute(*g, #PB_ScrollArea_X, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, 50)
      SetAttribute(*g, #PB_ScrollArea_Y, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_InnerHeight, sh+80)
      SetAttribute(*g, #PB_ScrollArea_InnerHeight, sh+80)
      
      ResizeGadget(b, #PB_Ignore, GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)-GadgetHeight(b), #PB_Ignore, #PB_Ignore)
      Resize(*b, #PB_Ignore, GetAttribute(*g, #PB_ScrollArea_InnerHeight)- Height(*b), #PB_Ignore, #PB_Ignore)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, 0)
      SetAttribute(*g, #PB_ScrollArea_Y, 0)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, sh)
      SetAttribute(*g, #PB_ScrollArea_Y, sh)
      
      Debug ""
      Debug *g\scroll\v\bar\page\pos
      Debug *g\scroll\v\bar\page\len
      Debug *g\scroll\v\bar\page\end
      Debug *g\scroll\v\bar\page\change
      Debug *g\scroll\v\bar\percent
      Debug *g\scroll\v\bar\area\end
      Debug *g\scroll\v\bar\thumb\pos
      Debug *g\scroll\v\bar\thumb\len
      Debug *g\scroll\v\bar\thumb\end
      Debug *g\scroll\v\bar\thumb\change
      Debug ""
    EndIf
    
    Debug ">>>>>>gadget>>>>>>"                    
    Debug "area_x = "+GetGadgetAttribute(g, #PB_ScrollArea_X)
    Debug "area_y = "+GetGadgetAttribute(g, #PB_ScrollArea_Y)
    Debug "area_w = "+GetGadgetAttribute(g, #PB_ScrollArea_InnerWidth)
    Debug "area_h = "+GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)
    Debug "scroll_step = "+GetGadgetAttribute(g, #PB_ScrollArea_ScrollStep)
    Debug ">>>>>>widget>>>>>>"
    Debug "area_x = "+GetAttribute(*g, #PB_ScrollArea_X)
    Debug "area_y = "+GetAttribute(*g, #PB_ScrollArea_Y)
    Debug "area_w = "+GetAttribute(*g, #PB_ScrollArea_InnerWidth)
    Debug "area_h = "+GetAttribute(*g, #PB_ScrollArea_InnerHeight)
    Debug "scroll_step = "+GetAttribute(*g, #PB_ScrollArea_ScrollStep)
    Debug ""
    
    BindGadgetEvent(g, @events_gadgets())
    Bind(*g, @events_widgets())
    
    WaitClose()
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 80
; FirstLine = 56
; Folding = v-
; Optimizer
; EnableXP
; DPIAware