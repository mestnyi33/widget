XIncludeFile "../../../widgets.pbi" 
; ошибка перемешения окна за заголовок
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global g,*g, b,*b, i, time, Sw = 350, Sh = 300, count;=10000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
  ;  Debug ""+Str(GetIndex(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  If OpenRoot(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g = ScrollAreaGadget(#PB_Any, 10, 10, 290, 300, Sw, Sh, 15, #PB_ScrollArea_Flat)
    SetGadGetWidgetColor(g, #PB_Gadget_BackColor, $00FFFF)
    
    ButtonGadget  (1,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (2,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (3,  90,  90, 230, 30,"Button 3")
    TextGadget    (4, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    
    *g = MDIWidget(310, 10, 290, 300)
    SetWidgetAttribute(*g, #PB_ScrollArea_ScrollStep, 15)
    SetWidgetAttribute(*g, #PB_ScrollArea_InnerWidth, sw)
    SetWidgetAttribute(*g, #PB_ScrollArea_InnerHeight, sh)
    SetWidgetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    
    Define *g1 = AddItem(*g, -1, "form_1") : ResizeWidget(*g1, 10,  10, 230, 30)
    Define *g2 = AddItem(*g, -1, "form_2") : ResizeWidget(*g2, 50,  50, 230, 30)
    Define *g3 = AddItem(*g, -1, "form_3") : ResizeWidget(*g3, 90,  90, 230, 30)
    
    *b = AddItem(*g, -1, "form") : ResizeWidget(*b, Sw-130, Sh-30, 130, 30)
    ;  *b = WindowWidget(Sw-130, Sh-130, 130, 30,"Window", #__window_systemmenu, *g) : CloseWidgetList()
    ; *b = WindowWidget(Sw-130, Sh-130, 130, 30,"Window", #__window_systemmenu|#__window_child, *g) : CloseWidgetList()
    CloseWidgetList()
   
    ;
    SplitterWidget(10,10,590,480, -1, SplitterWidget(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
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
      
      OpenWidgetList(*g)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          ButtonWidget((count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonWidget(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget"
      CloseWidgetList()
    EndIf
    
    ; set&get demos
    If Not count
      SetWidgetAttribute(*g, #PB_ScrollArea_X, 50)
      SetGadGetWidgetAttribute(g, #PB_ScrollArea_X, 50)
      
      SetGadGetWidgetAttribute(g, #PB_ScrollArea_Y, 50)
      SetWidgetAttribute(*g, #PB_ScrollArea_Y, 50)
      
      SetGadGetWidgetAttribute(g, #PB_ScrollArea_InnerHeight, sh+80)
      SetWidgetAttribute(*g, #PB_ScrollArea_InnerHeight, sh+80)
      
      If *b
        ResizeGadget(b, #PB_Ignore, GetWidgetAttribute(g, #PB_ScrollArea_InnerHeight)-GadgetHeight(b), #PB_Ignore, #PB_Ignore)
        ResizeWidget(*b, #PB_Ignore, GetWidgetAttribute(*g, #PB_ScrollArea_InnerHeight)- WidgetHeight(*b), #PB_Ignore, #PB_Ignore)
      EndIf

      SetGadGetWidgetAttribute(g, #PB_ScrollArea_Y, 0)
      SetWidgetAttribute(*g, #PB_ScrollArea_Y, 0)
      
      SetGadGetWidgetAttribute(g, #PB_ScrollArea_Y, sh)
      SetWidgetAttribute(*g, #PB_ScrollArea_Y, sh)
    EndIf
    
    Debug "gadget"
    Debug "x - "+GetWidgetAttribute(g, #PB_ScrollArea_X)
    Debug "y - "+GetWidgetAttribute(g, #PB_ScrollArea_Y)
    Debug "iw - "+GetWidgetAttribute(g, #PB_ScrollArea_InnerWidth)
    Debug "ih - "+GetWidgetAttribute(g, #PB_ScrollArea_InnerHeight)
    Debug "step - "+GetWidgetAttribute(g, #PB_ScrollArea_ScrollStep)
    
    Debug "widget"
    Debug "x - "+GetWidgetAttribute(*g, #PB_ScrollArea_X)
    Debug "y - "+GetWidgetAttribute(*g, #PB_ScrollArea_Y)
    Debug "iw - "+GetWidgetAttribute(*g, #PB_ScrollArea_InnerWidth)
    Debug "ih - "+GetWidgetAttribute(*g, #PB_ScrollArea_InnerHeight)
    Debug "step - "+GetWidgetAttribute(*g, #PB_ScrollArea_ScrollStep)
    
    BindGadgetEvent(g, @events_gadgets())
    BindWidgetEvent(*g, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 83
; FirstLine = 79
; Folding = 0-
; Optimizer
; EnableXP
; DPIAware