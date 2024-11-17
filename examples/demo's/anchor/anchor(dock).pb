IncludePath "../../../"
;XIncludeFile "widgets.pbi"

XIncludeFile "widgets.pbi"

    
;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure.i _SetAlignment(*this._s_widget, Mode.l, Type.l=1)
    ProcedureReturn SetAlign(*this, Mode, Type)
    
;       With *this
;         Select Type
;           Case 1 ; widget
;             If \parent
;               If Not \align
;                 \align.structures::_s_align = AllocateStructure(structures::_s_align)
;               EndIf
;               
;               ; Auto dock
;                 Static y2,x2,y1,x1
;                 Protected width = #PB_Ignore
;                 Protected height = #PB_Ignore
;                 
;                 
;               If Bool(Mode&#__flag_autoSize=#__flag_autoSize)
;                 \align\top = Bool(Not Mode&#__align_bottom)
;                 \align\left = Bool(Not Mode&#__align_right)
;                 \align\right = Bool(Not Mode&#__align_left)
;                 \align\bottom = Bool(Not Mode&#__align_top)
;                 \align\autoSize = 0
;                 
;                 If \align\left And \align\right
;                   \x = x2
;                   width = \parent\width[2] - x1 - x2
;                 EndIf
;                 If \align\top And \align\bottom 
;                   \y = y2
;                   height = \parent\height[2] - y1 - y2
;                 EndIf
;                 
;                 If \align\left And Not \align\right
;                   \x = x2
;                   \y = y2
;                   x2 + \width
;                   height = \parent\height[2] - y1 - y2
;                 EndIf
;                 If \align\right And Not \align\left
;                   \x = \parent\width[2] - \width - x1
;                   \y = y2
;                   x1 + \width
;                   height = \parent\height[2] - y1 - y2
;                 EndIf
;                 
;                 If \align\top And Not \align\bottom 
;                   \x = 0
;                   \y = y2
;                   y2 + \height
;                   width = \parent\width[2] - x1 - x2
;                 EndIf
;                 If \align\bottom And Not \align\top
;                   \x = 0
;                   \y = \parent\height[2] - \height - y1
;                   y1 + \height
;                   width = \parent\width[2] - x1 - x2
;                 EndIf
;                 
;                 
;                 ResizeWidget(*this, \x, \y, width, height)
;                 
;               ElseIf Bool(Mode&#__align_auto=#__align_auto)
;                 \align\top = Bool(Mode&#__align_top=#__align_top)
;                 \align\left = Bool(Mode&#__align_left=#__align_left)
;                 \align\right = Bool(Mode&#__align_right=#__align_right)
;                 \align\bottom = Bool(Mode&#__align_bottom=#__align_bottom)
;                 
;                 If Not Mode & #__align_center
;                   \align\left = Bool(Not \align\right)
;                   \align\top = Bool(Not \align\bottom)
;                 EndIf
;                 
;                 Protected p = 2
;                 \y = 0
;                 \x = 0
;                 
;                 If \align\bottom
;                   \y = (\parent\height[2] - \height)
;                   
;                 ElseIf \align\v
;                   \y = (\parent\height[p] - \height)/2
;                   
;                 EndIf
;                 
;                 If \align\right
;                   If \align\left
;                     width = \parent\width[2]
;                   Else
;                     \x = (\parent\width[2] - \width)
;                   EndIf
;                   
;                 ElseIf \align\h
;                   \x = (\parent\width[p] - \width)/2
;                 EndIf
;                 
;                 
;                 
;               If \align\right
;                 If \align\left
;                   \align\delta\x = \parent\width[2] - \width
;                 Else
;                   \align\delta\x = (\parent\width[2]-\x[3])
;                 EndIf
;               EndIf
;               
;               If \align\bottom
;                 If \align\top
;                   \align\delta\y = \parent\height[2] - \height
;                 Else
;                   \align\delta\y = (\parent\height[2]-\y[3])
;                 EndIf
;               EndIf
;                 
;                 ResizeWidget(*this, \x, \y, width, height)
;                 
;               Else
;                 \align\top = Bool(Mode&#__align_top=#__align_top)
;                 \align\left = Bool(Mode&#__align_left=#__align_left)
;                 \align\right = Bool(Mode&#__align_right=#__align_right)
;                 \align\bottom = Bool(Mode&#__align_bottom=#__align_bottom)
;                 
;                 If Not Mode & #__align_center
;                   \align\left = Bool(Not \align\right)
;                   \align\top = Bool(Not \align\bottom)
;                 EndIf
;               EndIf
;               
;               If \align\right
;                 If \align\left
;                   \align\delta\x = \parent\width[2] - \width
;                 Else
;                   \align\delta\x = (\parent\width[2]-\x[3])
;                 EndIf
;               EndIf
;               
;               If \align\bottom
;                 If \align\top
;                   \align\delta\y = \parent\height[2] - \height
;                 Else
;                   \align\delta\y = (\parent\height[2]-\y[3])
;                 EndIf
;               EndIf
;               
;               ; update parent childrens coordinate
;               ResizeWidget(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;             EndIf
;           Case 2 ; text
;           Case 3 ; image
;         EndSelect
;       EndWith
    EndProcedure
 
  Procedure.s get_TextWidget(m.s=#LF$)
    Protected Text.s = "This is a long line." + m.s +
                       "Who should show." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "I have to write the text in the box or not." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "The string must be very long." + m.s +
                       "Otherwise it will not work." ;+ m.s; +
    
    ProcedureReturn Text
  EndProcedure
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Global *l,*t,*r,*b , *dl,*dt,*dr,*db , *lt,*rt,*rb,*lb, *ce
  
  Global *demo
  Procedure events_widgets()
;     SetData(EventWidget( ), (GetData(EventWidget( )) ! 1))
;     
;     If GetData(EventWidget( ))
;      ; EventWidget( )\color\state = 2
;     EndIf
    
    Select EventWidget( )
      Case *t
        _SetAlignment(*demo, #__align_Center|#__align_top|#__align_auto)
        
      Case *l
;         If GetData(*r)
;           SetAlign(*demo, #__align_Center|#__align_left|#__align_right|#__align_auto)
;         Else
          _SetAlignment(*demo, #__align_Center|#__align_left|#__align_auto)
;         EndIf
        
      Case *r
;         If GetData(*l)
;           SetAlign(*demo, #__align_Center|#__align_left|#__align_right|#__align_auto)
;         Else
          _SetAlignment(*demo, #__align_Center|#__align_right|#__align_auto)
;         EndIf
        
      Case *b
        _SetAlignment(*demo, #__align_Center|#__align_bottom|#__align_auto)
        
        
      Case *ce
        _SetAlignment(*demo, #__align_center|#__align_auto)
        
        
      Case *lt
        SetState(*l, 0)
        SetState(*t, 0)
        SetState(*r, 0)
        SetState(*b, 0)
        ;SetState(*lt, 0)
        SetState(*rt, 0)
        SetState(*rb, 0)
        SetState(*lb, 0)
        _SetAlignment(*demo, #__align_left|#__align_top|#__align_auto)
        
      Case *rt
        _SetAlignment(*demo, #__align_right|#__align_top|#__align_auto)
        
      Case *rb
        _SetAlignment(*demo, #__align_right|#__align_bottom|#__align_auto)
        
      Case *lb
        _SetAlignment(*demo, #__align_left|#__align_bottom|#__align_auto)
      
  EndSelect    
  EndProcedure
  
  If OpenRootWidget(OpenWindow(#PB_Any, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
    
    Define *cont = ContainerWidget(15,15,100,100)
    Define s2=10+6, s = s2+6, r2 = 4+3, r = r2+3-1, o=1, o2 = 1
     *lt = ButtonWidget(o,o,s,s,"",#__flag_ButtonToggle,0,r)
     *rt = ButtonWidget(98-s-o*2,o,s,s,"",#__flag_ButtonToggle,0,r)
     *rb = ButtonWidget(98-s-o*2,98-s-o*2,s,s,"",#__flag_ButtonToggle,0,r)
     *lb = ButtonWidget(o,98-s-o*2,s,s,"",#__flag_ButtonToggle,0,r)
    
     
;      *dt = ButtonWidget(o2,o2,s2,s2,"",#__flag_ButtonToggle,0,r2)
      *dl = ButtonWidget(o2,s+1,s2,98-s*2-o2*4 ,"",#__flag_ButtonToggle,0,r2)
      *dr = ButtonWidget(98-s2-o2*2,s+1,s2,98-s*2-o2*4,"",#__flag_ButtonToggle,0,r2)
;      *db = ButtonWidget(o2,98-s2-o2*2,s2,s2,"",#__flag_ButtonToggle,0,r2)
     
      *t = ButtonWidget(o2,o2,s2,s2,"",#__flag_ButtonToggle,0,r2)
     *l = ButtonWidget(o2,o2,s2,s2,"",#__flag_ButtonToggle,0,r2)
     *r = ButtonWidget(98-s2-o2*2,o2,s2,s2,"",#__flag_ButtonToggle,0,r2)
     *b = ButtonWidget(o2,98-s2-o2*2,s2,s2,"",#__flag_ButtonToggle,0,r2)
    SetState(*lt, 1)
     
    Define *c._s_widget = ContainerWidget(s2+o2*3-1,s2+o2*3-1,(98-s2*2-o2*6+1),(98-s2*2-o2*6+1))
    *c\round = 9
    
    *demo = ButtonWidget(o,o,s,s,"",0,0, r)
     *ce = ButtonWidget(o2,o2,s2,s2,"",0,0, r2)
    CloseWidgetList()
    
;     SetWidgetClass(*t, "t_anchor")
;     SetWidgetClass(*l, "l_anchor")
;     SetWidgetClass(*r, "r_anchor")
;     SetWidgetClass(*b, "b_anchor")
;     
;     SetWidgetClass(*lt, "lt_anchor")
;     SetWidgetClass(*rt, "rt_anchor")
;     SetWidgetClass(*rb, "rb_anchor")
;     SetWidgetClass(*lb, "lb_anchor")
;     SetWidgetClass(*ce, "ce_anchor")
    
    _SetAlignment(*t, #__align_Center|#__align_top)
    _SetAlignment(*b, #__align_Center|#__align_bottom)
    _SetAlignment(*l, #__align_Center|#__align_left)
    _SetAlignment(*r, #__align_Center|#__align_right)
    
    
    _SetAlignment(*lt, #__align_left|#__align_top)
    _SetAlignment(*rt, #__align_right|#__align_top)
    _SetAlignment(*rb, #__align_right|#__align_bottom)
    _SetAlignment(*lb, #__align_left|#__align_bottom)
    _SetAlignment(*ce, #__align_center)
    
    _SetAlignment(*c, #__align_Center|#__align_full)
    CloseWidgetList()
    
    BindWidgetEvent(*t, @events_widgets())
    BindWidgetEvent(*l, @events_widgets())
    BindWidgetEvent(*r, @events_widgets())
    BindWidgetEvent(*b, @events_widgets())
    
    BindWidgetEvent(*lt, @events_widgets())
    BindWidgetEvent(*rt, @events_widgets())
    BindWidgetEvent(*rb, @events_widgets())
    BindWidgetEvent(*lb, @events_widgets())
    BindWidgetEvent(*ce, @events_widgets())
    
    ;BindWidgetEvent(-1,-1)
    
    Define direction = 1
  Define Width, Height
  
    Repeat
   Define  gEvent = WaitWindowEvent( ) ;events::WaitEvent( @EventHandler( ), PB(WaitWindowEvent)( ) )
    
    Select gEvent
      Case #PB_Event_CloseWindow
        Define gQuit= #True
        
      Case #PB_Event_Timer
        If Width = 100
           direction = 1
        EndIf
        If Width = WidgetWidth(root())-100
          direction =- 1
        EndIf
;         
        Width + direction
        Height + direction
        
        If ResizeWidget(*cont, #PB_Ignore, #PB_Ignore, Width, Height)
          ; SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(*Bar_0, #PB_Bar_Direction)))
        EndIf
       
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Width = WidgetWidth(*cont)
            Height = WidgetHeight(*cont)
            
            If GetGadgetState(0)
              AddWindowTimer(GetCanvasWindow(root()), 1, 200)
            Else
              RemoveWindowTimer(GetCanvasWindow(root()), 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 342
; FirstLine = 307
; Folding = 8V-
; EnableXP