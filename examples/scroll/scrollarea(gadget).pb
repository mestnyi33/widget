XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global g,*g, b,*b, oc, ic, i, time, Sw = 350, Sh = 300, count;=1000
  
  Procedure events_gadgets()
    Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    Debug ""+Str(GetIndex(this()\widget))+ " - widget event - " +this()\event+ " bar - " +GetClass(this()\item)+ " direction - " +this()\data 
    
    Select this()\event
      Case #PB_EventType_Resize
        ResizeGadget(oc, X(*g, #__c_inner), Y(*g, #__c_inner), width(*g, #__c_inner), height(*g, #__c_inner))
        
      Case #PB_EventType_ScrollChange
        ResizeGadget(ic, X(*g, #__c_required), Y(*g, #__c_required), #PB_Ignore, #PB_Ignore)
    EndSelect
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    g = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, Sw, Sh, 15, #PB_ScrollArea_Flat)
    SetGadgetColor(g, #PB_Gadget_BackColor, $00FFFF)
    
    ButtonGadget  (#PB_Any,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (#PB_Any,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (#PB_Any,  90,  90, 230, 30,"Button 3")
    TextGadget    (#PB_Any, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    CloseGadgetList()
    
    *g = ScrollArea(0, 0, 0, 0, Sw, Sh, 15, #PB_ScrollArea_Flat)
    oc = ContainerGadget(#PB_Any, X(*g, #__c_inner), Y(*g, #__c_inner), width(*g, #__c_inner), height(*g, #__c_inner))
    ic = ContainerGadget(#PB_Any, 0, 0, Sw, Sh)
    SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    
    ButtonGadget  (#PB_Any,  10,  10, 230, 30,"Button 1")
    ButtonGadget  (#PB_Any,  50,  50, 230, 30,"Button 2")
    ButtonGadget  (#PB_Any,  90,  90, 230, 30,"Button 3")
    TextGadget    (#PB_Any, 130, 130, 330, 20,"This is the content of a ScrollAreaGadget!", #PB_Text_Right)
    
    *b = ButtonGadget  (#PB_Any, Sw-130, Sh-30, 130, 30,"Button")
    
    CloseGadgetList()
    CloseGadgetList()
    CloseList()
    
    ;
    Splitter(10,10,590,480, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical),0)
    
    ResizeGadget(oc, X(*g, #__c_inner), Y(*g, #__c_inner), width(*g, #__c_inner), height(*g, #__c_inner))
    
    BindGadgetEvent(g, @events_gadgets())
    Bind(*g, @events_widgets())
    
    ; set&get demos
    If Not count
;       SetGadgetAttribute(g, #PB_ScrollArea_X, 50)
;       SetAttribute(*g, #PB_ScrollArea_X, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_Y, 50)
      SetAttribute(*g, #PB_ScrollArea_Y, 50)
      
      SetGadgetAttribute(g, #PB_ScrollArea_InnerHeight, sh+80)
      SetAttribute(*g, #PB_ScrollArea_InnerHeight, sh+80)
      
;       ResizeGadget(b, #PB_Ignore, GetGadgetAttribute(g, #PB_ScrollArea_InnerHeight)-30, #PB_Ignore, #PB_Ignore)
;       ResizeGadget(*b, #PB_Ignore, GetAttribute(*g, #PB_ScrollArea_InnerHeight)-30, #PB_Ignore, #PB_Ignore)
      
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
    
;     BindGadgetEvent(g, @events_gadgets())
;     Bind(*g, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP