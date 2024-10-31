XIncludeFile "../../../widgets.pbi" 
; пока не наведеш на скролл бар правильно не отрисовивает
CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global g,*g._s_widget, b,*b, oc, ic, i, time, Sw = 350, Sh = 300, count;=1000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ; Debug ""+Str(IDWidget(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +GetClass(this()\item)+ " direction - " +this()\data 
    
    Select WidgetEvent( )
      Case #__event_Resize
;         ;oc = EventWidget( )\scroll\gadget[1]
;         ResizeGadget(oc, WidgetX(EventWidget( ), #__c_inner), WidgetY(EventWidget( ), #__c_inner), WidgetWidth(EventWidget( ), #__c_inner), WidgetHeight(EventWidget( ), #__c_inner))
;         CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;           UpdateWindow_(GadgetID(oc))
;         CompilerEndIf
        
        ;
      Case #__Event_ScrollChange
;         ; ResizeGadget(ic, -DesktopUnscaledX(*g\scroll\h\bar\page\pos), -DesktopUnscaledY(*g\scroll\v\bar\page\pos), #PB_Ignore, #PB_Ignore)
;         ResizeGadget(ic, WidgetX(*g, #__c_required), WidgetY(*g, #__c_required), #PB_Ignore, #PB_Ignore)
;         CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;           UpdateWindow_(GadgetID(ic))
;         CompilerEndIf
    EndSelect
  EndProcedure
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, Sw, Sh, 30, #PB_ScrollArea_Flat)
    SetGadgetColor(g, #PB_Gadget_BackColor, $00FFFF)
    
    ButtonGadget  (#PB_Any,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (#PB_Any,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (#PB_Any,  90,  90, 230, 30,"Button 3")
    TextGadget    (#PB_Any, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    
    ; Bind(-1, @events_widgets())
    
    *g = ScrollArea(0, 0, 100, 100, Sw, Sh, 30, #PB_ScrollArea_Flat)
    oc = ContainerGadget(#PB_Any, 0,0,0,0)
    SetWindowLongPtr_( GadgetID(oc), #GWL_STYLE, GetWindowLongPtr_( GadgetID(oc), #GWL_STYLE ) | #WS_CLIPCHILDREN )
    ic = ContainerGadget(#PB_Any, 0, 0, (Sw), (Sh))
    SetWindowLongPtr_( GadgetID(ic), #GWL_STYLE, GetWindowLongPtr_( GadgetID(ic), #GWL_STYLE ) | #WS_CLIPCHILDREN )
    *g\scroll\gadget[1] = oc
    *g\scroll\gadget[2] = ic
    
    
    SetGadgetColor(oc, #PB_Gadget_BackColor, $00FFFF)
    SetGadgetColor(ic, #PB_Gadget_BackColor, $00FFFF)
    ;SetColor(*g, #PB_Gadget_BackColor, $FFFF00)
    ;SetColor(*g\root, #PB_Gadget_BackColor, $FFFF00)
    
    ButtonGadget  (#PB_Any,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (#PB_Any,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (#PB_Any,  90,  90, 230, 30,"Button 3")
    TextGadget    (#PB_Any, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    *b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    
    CloseGadgetList() ; ic
    CloseGadgetList() ; oc
    CloseList()
    
    ;
    Splitter(10,10,590,480, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical),0)
     
;     BindGadgetEvent(g, @events_gadgets())
;     Bind(*g, @events_widgets())
    
    ; set&get demos
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
      
      OpenGadgetList(ic)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          ButtonGadget  (#PB_Any, (count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget"
      CloseGadgetList()
    Else
;       SetGadgetAttribute(g, #PB_ScrollArea_X, 50)
;       SetAttribute(*g, #PB_ScrollArea_X, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, 50)
      SetAttribute(*g, #PB_ScrollArea_Y, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_InnerHeight, sh+80)
      SetAttribute(*g, #PB_ScrollArea_InnerHeight, sh+80)
        
      ResizeGadget(b, #PB_Ignore, GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)-30, #PB_Ignore, #PB_Ignore)
      ResizeGadget(*b, #PB_Ignore, GetAttribute(*g, #PB_ScrollArea_InnerHeight)-30, #PB_Ignore, #PB_Ignore)
      
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
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 39
; Folding = -9
; EnableXP
; DPIAware