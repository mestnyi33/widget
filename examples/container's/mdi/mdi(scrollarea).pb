XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global g,*g, b,*b, i, time, Sw = 350, Sh = 300, count;=10000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
  ;  Debug ""+Str(GetIndex(this()\widget))+ " - widget event - " +this()\event+ " bar - " +this()\item+ " direction - " +this()\data 
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
    
    *g = MDI(310, 10, 290, 300)
    SetAttribute(*g, #PB_ScrollArea_ScrollStep, 15)
    SetAttribute(*g, #PB_ScrollArea_InnerWidth, sw)
    SetAttribute(*g, #PB_ScrollArea_InnerHeight, sh)
    SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    
    Define *g1 = AddItem(*g, -1, "form_1") : Resize(*g1, 10,  10, 230, 30)
    Define *g2 = AddItem(*g, -1, "form_2") : Resize(*g2, 50,  50, 230, 30)
    Define *g3 = AddItem(*g, -1, "form_3") : Resize(*g3, 90,  90, 230, 30)
    
    *b = AddItem(*g, -1, "form") : Resize(*b, Sw-130, Sh-30, 130, 30)
    ;  *b = Window(Sw-130, Sh-130, 130, 30,"Window", #__window_systemmenu, *g) : CloseList()
    ; *b = Window(Sw-130, Sh-130, 130, 30,"Window", #__window_systemmenu|#__window_child, *g) : CloseList()
    CloseList()
   
    ;
    Splitter(10,10,590,480, -1, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
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
      SetAttribute(*g, #PB_ScrollArea_X, 50)
      SetGadgetAttribute(g, #PB_ScrollArea_X, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, 50)
      SetAttribute(*g, #PB_ScrollArea_Y, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_InnerHeight, sh+80)
      SetAttribute(*g, #PB_ScrollArea_InnerHeight, sh+80)
      
      If *b
        ResizeGadget(b, #PB_Ignore, GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)-GadgetHeight(b), #PB_Ignore, #PB_Ignore)
        Resize(*b, #PB_Ignore, GetAttribute(*g, #PB_ScrollArea_InnerHeight)-Height(*b), #PB_Ignore, #PB_Ignore)
      EndIf

      SetGadgetAttribute(g, #PB_ScrollArea_Y, 0)
      SetAttribute(*g, #PB_ScrollArea_Y, 0)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, sh)
      SetAttribute(*g, #PB_ScrollArea_Y, sh)
    EndIf
    
    Debug "gadget"
    Debug "x - "+GetGadgetAttribute(g, #PB_ScrollArea_X)
    Debug "y - "+GetGadgetAttribute(g, #PB_ScrollArea_Y)
    Debug "iw - "+GetGadgetAttribute(g, #PB_ScrollArea_InnerWidth)
    Debug "ih - "+GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)
    Debug "step - "+GetGadgetAttribute(g, #PB_ScrollArea_ScrollStep)
    
    Debug "widget"
    Debug "x - "+GetAttribute(*g, #PB_ScrollArea_X)
    Debug "y - "+GetAttribute(*g, #PB_ScrollArea_Y)
    Debug "iw - "+GetAttribute(*g, #PB_ScrollArea_InnerWidth)
    Debug "ih - "+GetAttribute(*g, #PB_ScrollArea_InnerHeight)
    Debug "step - "+GetAttribute(*g, #PB_ScrollArea_ScrollStep)
    
    BindGadgetEvent(g, @events_gadgets())
    Bind(*g, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 6-
; EnableXP