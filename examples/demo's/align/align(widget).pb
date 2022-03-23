
IncludePath "../../../"
XIncludeFile "widget-events.pb"

;XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  Global tree_view
  Global NewMap Widgets.i()
  Global.i Window_0, Canvas_0, gEvent, gQuit, x=10,y=10
  Global *this._s_widget
  
  Macro AnchorLeft(_this_)
    _this_\align\anchor\left
  EndMacro
  
  Procedure events()
    Select WidgetEventType()
      Case #__event_leftclick
        
        ;Debug EventWidget()
        ClearItems(tree_view)
        ;Debug EventWidget()
        If EventWidget() And EventWidget()\align
          ;Debug AnchorLeft(EventWidget())
          If GetText(EventWidget()) = "parent stretch"
            EventWidget() = EventWidget()\parent
          EndIf
          
          If EventWidget()\align\anchor\left > 0
            AddItem(tree_view, -1, "LEFT")
          ElseIf EventWidget()\align\anchor\left < 0
            AddItem(tree_view, -1, "LEFT-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\anchor\right > 0
            AddItem(tree_view, -1, "RIGHT")
          ElseIf EventWidget()\align\anchor\right < 0
            AddItem(tree_view, -1, "RIGHT-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\anchor\top > 0
            AddItem(tree_view, -1, "TOP")
          ElseIf EventWidget()\align\anchor\top < 0
            AddItem(tree_view, -1, "TOP-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\anchor\bottom > 0
            AddItem(tree_view, -1, "BOTTOM")
          ElseIf EventWidget()\align\anchor\bottom < 0
            AddItem(tree_view, -1, "BOTTOM-PROPORTIONAL")
          EndIf
          
          If CountItems(tree_view) = 0
            AddItem(tree_view, -1, "CENTER")
          EndIf
          
          ; SetItemState(tree_view, CountItems(tree_view), 1)
          ; ReDraw(tree_view)
        EndIf
        
    EndSelect
  EndProcedure
  
  
  Procedure example_0()
    Define i
    CreateImage(0,200,60) 
    StartDrawing(ImageOutput(0))
    For i=0 To 200
      Circle(100, 30, 200-i, (i+50)*$010101)
    Next
    StopDrawing()
    
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 512, 200, "Resize gadget", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Text(10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized", #__text_center)
    ; Widgets(Hex(3)) = ButtonImageGadget(3, 10, 70, 200, 60, ImageID(0))
    Widgets(Hex(2)) = Editor(10, 140, 200, 20) : SetText(Widgets(Hex(2)),"Editor")
    Widgets(Hex(4)) = Button(10, 170, 490, 20, "Button / toggle", #__button_toggle)
    Widgets(Hex(5)) = Text(220,10,190,20,"Text", #__text_center) : SetColor(Widgets(Hex(5)), #PB_Gadget_BackColor, $00FFFF)
    Widgets(Hex(6)) = Container(220, 30, 190, 100, #PB_Container_Single) : SetColor(Widgets(Hex(6)), #PB_Gadget_BackColor, $cccccc) 
    Widgets(Hex(7)) = Editor(10,  10, 170, 50) : SetText(Widgets(Hex(7)),"Editor")
    Widgets(Hex(8)) = Button(10, 70, 80, 20, "Button") 
    Widgets(Hex(9)) = Button(100, 70, 80, 20, "Button") 
    CloseList() 
    Widgets(Hex(10)) = String(220,  140, 190, 20, "String")
    Widgets(Hex(11)) = Button(420,  10, 80, 80, "Bouton")
    Widgets(Hex(12)) = CheckBox(420,  90, 200, 20, "CheckBox")
    Widgets(Hex(13)) = CheckBox(420,  110, 200, 20, "CheckBox")
    Widgets(Hex(14)) = CheckBox(420,  130, 200, 20, "CheckBox")
    Widgets(Hex(15)) = CheckBox(420,  150, 200, 20, "CheckBox")
    
    SetAlignmentFlag(Widgets(Hex(2)),#__align_top|#__align_bottom) 
    ;SetAlignmentFlag(Widgets(Hex(3)),#__align_center|#__align_right)              
    SetAlignmentFlag(Widgets(Hex(4)),#__align_left|#__align_right|#__align_bottom)      
    
    SetAlignmentFlag(Widgets(Hex(5)),#__align_left|#__align_right)
    
    SetAlignmentFlag(Widgets(Hex(6)),#__align_full) 
    SetAlignmentFlag(Widgets(Hex(7)),#__align_full)
    
    SetAlignmentFlag(Widgets(Hex(8)),#__align_bottom|#__align_left|#__align_proportional_horizontal) 
    SetAlignmentFlag(Widgets(Hex(9)),#__align_bottom|#__align_right|#__align_proportional_horizontal) 
    SetAlignmentFlag(Widgets(Hex(10)),#__align_bottom|#__align_left|#__align_right) 
    SetAlignmentFlag(Widgets(Hex(11)),#__align_bottom|#__align_top|#__align_right) 
    SetAlignmentFlag(Widgets(Hex(12)),#__align_bottom|#__align_right)
    SetAlignmentFlag(Widgets(Hex(13)),#__align_bottom|#__align_right)
    SetAlignmentFlag(Widgets(Hex(14)),#__align_bottom|#__align_right)
    SetAlignmentFlag(Widgets(Hex(15)),#__align_bottom|#__align_right)
    
    bind(root(), @events())
    ;bind(-1,-1)
    
  EndProcedure
  
  ; proportional
  Procedure example_1()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 30, 30, 190, 200, "proportional", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(2)) = Button(55, 5, 80, 20, "center")   ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(55, 25, 80, 20, "right")   ; right         #right
    Widgets(Hex(4)) = Container(55, 45, 80, 20)         ; stretch       #stretch 
    Widgets(Hex(44)) = Button(0, 5, 80, 20, "parent stretch")
    CloseList()
    
    Widgets(Hex(5)) = Button(55, 65, 80, 20, ">>|<<")    ; proportional  #proportion
    
    Widgets(Hex(6)) = Button(10, 90, 80, 20, ">>|", #__button_right) ; proportional
    Widgets(Hex(7)) = Button(100, 90, 80, 20, "|<<", #__button_left) ; proportional
    
    Widgets(Hex(8)) = Button(10, 115, 50, 20, ">>|", #__button_right) ; proportional
    Widgets(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    Widgets(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    Widgets(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    Widgets(Hex(12)) = Button(130, 115, 50, 20, "|<<", #__button_left); proportional
    
    
    SetAlignment(Widgets(Hex(2)), 0,#__align_proportional,0,0, 0)    
    SetAlignment(Widgets(Hex(3)), 0,0,1,0, 0)
    SetAlignment(Widgets(Hex(4)), 1,0,1,#__align_proportional, 0)
    SetAlignment(Widgets(Hex(44)), 0,1,0,0, 0)
    SetAlignment(Widgets(Hex(5)), #__align_proportional,0,#__align_proportional,1, 0)
    
    SetAlignment(Widgets(Hex(6)), #__align_proportional,0,0,1, 0)
    SetAlignment(Widgets(Hex(7)), 0,0,#__align_proportional,1, 0)
    
    SetAlignment(Widgets(Hex(8)), 1,0,0,1, 0)
    SetAlignment(Widgets(Hex(9)), 1,0,0,1, 0)
    SetAlignment(Widgets(Hex(10)), 1,0,1,1, 0)
    SetAlignment(Widgets(Hex(11)), 0,0,1,1, 0)
    SetAlignment(Widgets(Hex(12)), 0,0,1,1, 0)
    
    bind(root(), @events())
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  ; auto alignment
  Procedure example_2()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 130, 190, 200, "alignment", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(10)) = Button(0, 0, 90, 50, "left&center&right")      
    Widgets(Hex(11)) = Button(0, 0, 90, 50, "top&center&bottom")      
    
    Widgets(Hex(1)) = Button(0, 0, 80, 40, "left")        ; center \2     align_proportional_horizontal
    Widgets(Hex(2)) = Button(0, 0, 80, 40, "top")         ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(0, 0, 80, 40, "right")       ; right         #right
    Widgets(Hex(4)) = Button(0, 0, 80, 40, "bottom")      ; right         #right
    
    Widgets(Hex(5)) = Button(0, 0, 80, 40, "center")      ; center \2     align_proportional_horizontal
    
    Widgets(Hex(6)) = Button(0, 0, 80, 40, "left&top")    ; right         #right
    Widgets(Hex(7)) = Button(0, 0, 80, 40, "right&top")   ; right         #right
    Widgets(Hex(8)) = Button(0, 0, 80, 40, "right&bottom"); right         #right
    Widgets(Hex(9)) = Button(0, 0, 80, 40, "left&bottom") ; right         #right
    
    
    SetAlignment( Widgets(Hex(1)), -5,0,0,0 )
    SetAlignment( Widgets(Hex(2)), 0,-5,0,0 )
    SetAlignment( Widgets(Hex(3)), 0,0,-5,0 )
    SetAlignment( Widgets(Hex(4)), 0,0,0,-5 )
    
    SetAlignment( Widgets(Hex(6)), -5,-5,0,0 )
    SetAlignment( Widgets(Hex(7)), 0,-5,-5,0 )
    SetAlignment( Widgets(Hex(8)), 0,0,-5,-5 )
    SetAlignment( Widgets(Hex(9)), -5,0,0,-5 )
    
    SetAlignment( Widgets(Hex(10)), -5,0,-5,0 )
    SetAlignment( Widgets(Hex(11)), 0,-5,0,-5 )
    
    SetAlignment( Widgets(Hex(5)), 0,0,0,0 )
    
    
    bind(root(), @events())
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,260)
  EndProcedure
  
  ; auto docking
  Procedure example_3()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 650, 260, 390, 200, "docking", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(0, 0, 60, 20, "left1")  
    Widgets(Hex(2)) = Button(0, 0, 80, 40, "top1")   
    Widgets(Hex(3)) = Button(0, 0, 40, 20, "right1")    
    Widgets(Hex(4)) = Button(0, 0, 80, 20, "bottom1")   
    
    Widgets(Hex(11)) = Button(0, 0, 40, 20, "left2")   
    Widgets(Hex(33)) = Button(0, 0, 60, 40, "right2")   
    Widgets(Hex(22)) = Button(0, 0, 80, 20, "top2")   
    Widgets(Hex(44)) = Button(0, 0, 80, 40, "bottom2")   
    
    Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    Widgets(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    Widgets(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    Widgets(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    Widgets(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    SetAlignment(Widgets(Hex(1)), #__align_full, 0,0,0 ) 
    SetAlignment(Widgets(Hex(2)), 0,#__align_full, 0,0) 
    SetAlignment(Widgets(Hex(3)), 0,0,#__align_full, 0)              
    SetAlignment(Widgets(Hex(4)), 0,0,0, #__align_full)      
    
    SetAlignment(Widgets(Hex(11)), #__align_full, 0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), 0,#__align_full, 0,0) 
    SetAlignment(Widgets(Hex(33)), 0,0,#__align_full, 0)              
    SetAlignment(Widgets(Hex(44)), 0,0,0, #__align_full)      
    
    SetAlignment(Widgets(Hex(5)),  #__align_full, #__align_full, #__align_full, #__align_full )
    
    SetAlignment(Widgets(Hex(51)), #__align_full, 0,0,0) 
    SetAlignment(Widgets(Hex(52)), 0, #__align_full,0,0) 
    SetAlignment(Widgets(Hex(53)), 0,0, #__align_full,0)              
    SetAlignment(Widgets(Hex(54)), 0,0,0, #__align_full)      
    
    SetAlignment(Widgets(Hex(55)), #__align_full, #__align_full, #__align_full, #__align_full)
    
    bind(root(), @events())
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  ; 
  Procedure example_4()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 850, 460, 390, 200, "auto", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(0, 0, 60, 20, "left1")  
    Widgets(Hex(2)) = Button(0, 0, 80, 40, "top1")   
    Widgets(Hex(3)) = Button(0, 0, 60, 20, "right1")    
    Widgets(Hex(4)) = Button(0, 0, 80, 20, "bottom1")   
    
    Widgets(Hex(11)) = Button(0, 0, 40, 20, "left2")   
    Widgets(Hex(33)) = Button(0, 0, 40, 40, "right2")   
    Widgets(Hex(22)) = Button(0, 0, 80, 20, "top2")   
    Widgets(Hex(44)) = Button(0, 0, 80, 40, "bottom2")   
    
    Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    Widgets(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    Widgets(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    Widgets(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    Widgets(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    SetAlignment(Widgets(Hex(1)), #__align_auto, 0,0,0 ) 
    SetAlignment(Widgets(Hex(2)), 0,#__align_auto, 0,0) 
    SetAlignment(Widgets(Hex(3)), 0,0,#__align_auto, 0)              
    SetAlignment(Widgets(Hex(4)), 0,0,0, #__align_auto)      
    
    SetAlignment(Widgets(Hex(11)), #__align_auto, 0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), 0,#__align_auto, 0,0) 
    SetAlignment(Widgets(Hex(33)), 0,0,#__align_auto, 0)              
    SetAlignment(Widgets(Hex(44)), 0,0,0, #__align_auto)      
    
    
    SetAlignment(Widgets(Hex(5)),  #__align_auto, #__align_auto, #__align_auto, #__align_auto )
    
    SetAlignment(Widgets(Hex(51)), #__align_auto, 0,0,0) 
    SetAlignment(Widgets(Hex(52)), 0, #__align_auto,0,0) 
    SetAlignment(Widgets(Hex(53)), 0,0, #__align_auto,0)              
    SetAlignment(Widgets(Hex(54)), 0,0,0, #__align_auto)      
    ;     
    SetAlignment(Widgets(Hex(55)), #__align_auto, #__align_auto, #__align_auto, #__align_auto)
    
    bind(root(), @events())
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  ;;example_0()
  example_1()
  example_2()
  example_3()
  example_4()
  
  
  Procedure example_demo()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 440, 100, 150, "docking", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    tree_view = Tree(0, 0, 0, 0, #__flag_autosize)   
    
    CloseList()
    
    
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,200)
  EndProcedure
  
  example_demo()
  WaitClose( )
;   Repeat
;     gEvent= WaitWindowEvent()
;     
;     Select gEvent
;       Case #PB_Event_CloseWindow
;         gQuit= #True
;         
;     EndSelect
;     
;   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP