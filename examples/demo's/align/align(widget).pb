
IncludePath "../../../"
XIncludeFile "widget-events.pbi"

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
    _this_\align\left
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
          
          If EventWidget()\align\left > 0
            AddItem(tree_view, -1, "LEFT")
          ElseIf EventWidget()\align\left < 0
            AddItem(tree_view, -1, "LEFT-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\right > 0
            AddItem(tree_view, -1, "RIGHT")
          ElseIf EventWidget()\align\right < 0
            AddItem(tree_view, -1, "RIGHT-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\top > 0
            AddItem(tree_view, -1, "TOP")
          ElseIf EventWidget()\align\top < 0
            AddItem(tree_view, -1, "TOP-PROPORTIONAL")
          EndIf
          
          If EventWidget()\align\bottom > 0
            AddItem(tree_view, -1, "BOTTOM")
          ElseIf EventWidget()\align\bottom < 0
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
  
  ; proportional
  Procedure example_1()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 30, 30, 190, 200, "example_1 proportional", #PB_Window_SizeGadget))
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
    
    
    SetAlignment(Widgets(Hex(2)), 0, 0,#__align_proportional,0,0 )    
    SetAlignment(Widgets(Hex(3)), 0, 0,0,1,0 )
    SetAlignment(Widgets(Hex(4)), 0, 1,0,1,#__align_proportional )
    SetAlignment(Widgets(Hex(44)), 0, 0,1,0,0 )
    SetAlignment(Widgets(Hex(5)), 0, #__align_proportional,0,#__align_proportional,1 )
    
    SetAlignment(Widgets(Hex(6)), 0, #__align_proportional,0,0,1 )
    SetAlignment(Widgets(Hex(7)), 0, 0,0,#__align_proportional,1 )
    
    SetAlignment(Widgets(Hex(8)), 0, 1,0,0,1 )
    SetAlignment(Widgets(Hex(9)), 0, 1,0,0,1 )
    SetAlignment(Widgets(Hex(10)), 0, 1,0,1,1 )
    SetAlignment(Widgets(Hex(11)), 0, 0,0,1,1 )
    SetAlignment(Widgets(Hex(12)), 0, 0,0,1,1 )
    
    bind(root(), @events())
    ;bind(-1,-1)
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  ; auto alignment
  Procedure example_2()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 130, 190, 200, "example_2 alignment", #PB_Window_SizeGadget))
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
    
    
    SetAlignment( Widgets(Hex(1)), #__align_auto, -5,0,0,0 )
    SetAlignment( Widgets(Hex(2)), #__align_auto, 0,-5,0,0 )
    SetAlignment( Widgets(Hex(3)), #__align_auto, 0,0,-5,0 )
    SetAlignment( Widgets(Hex(4)), #__align_auto, 0,0,0,-5 )
    
    SetAlignment( Widgets(Hex(6)), #__align_auto, -5,-5,0,0 )
    SetAlignment( Widgets(Hex(7)), #__align_auto, 0,-5,-5,0 )
    SetAlignment( Widgets(Hex(8)), #__align_auto, 0,0,-5,-5 )
    SetAlignment( Widgets(Hex(9)), #__align_auto, -5,0,0,-5 )
    
    SetAlignment( Widgets(Hex(10)), #__align_auto, -5,0,-5,0 )
    SetAlignment( Widgets(Hex(11)), #__align_auto, 0,-5,0,-5 )
    
    SetAlignment( Widgets(Hex(5)), #__align_center ) ; , 0,0,0,0 )
    
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,260)
  EndProcedure
  
  ; auto docking
  Procedure example_3()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 650, 260, 390, 200, "example_3 docking", #PB_Window_SizeGadget))
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
    
    SetAlignment(Widgets(Hex(1)), #__align_full, #__align_full, 0,0,0 ) 
    SetAlignment(Widgets(Hex(2)), #__align_full, 0,#__align_full, 0,0 ) 
    SetAlignment(Widgets(Hex(3)), #__align_full, 0,0,#__align_full, 0 )              
    SetAlignment(Widgets(Hex(4)), #__align_full, 0,0,0, #__align_full )      
    
    SetAlignment(Widgets(Hex(11)), #__align_full, #__align_full, 0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), #__align_full, 0,#__align_full, 0,0 ) 
    SetAlignment(Widgets(Hex(33)), #__align_full, 0,0,#__align_full, 0 )              
    SetAlignment(Widgets(Hex(44)), #__align_full, 0,0,0, #__align_full )      
    
    SetAlignment(Widgets(Hex(5)), #__align_full ); ,  #__align_full, #__align_full, #__align_full, #__align_full )
    
    SetAlignment(Widgets(Hex(51)), #__align_full, #__align_full, 0,0,0 ) 
    SetAlignment(Widgets(Hex(52)), #__align_full, 0, #__align_full,0,0 ) 
    SetAlignment(Widgets(Hex(53)), #__align_full, 0,0, #__align_full,0 )              
    SetAlignment(Widgets(Hex(54)), #__align_full, 0,0,0, #__align_full )      
    
    SetAlignment(Widgets(Hex(55)), #__align_full ); , #__align_full, #__align_full, #__align_full, #__align_full )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  ; 
  Procedure example_4()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 850, 460, 390, 200, "example_4 auto", #PB_Window_SizeGadget))
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
    
    SetAlignment(Widgets(Hex(1)), #__align_auto, #__align_auto, 0,0,0 ) 
    SetAlignment(Widgets(Hex(2)), #__align_auto, 0,#__align_auto, 0,0 ) 
    SetAlignment(Widgets(Hex(3)), #__align_auto, 0,0,#__align_auto, 0 )              
    SetAlignment(Widgets(Hex(4)), #__align_auto, 0,0,0, #__align_auto )      
    
    SetAlignment(Widgets(Hex(11)), #__align_auto, #__align_auto, 0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), #__align_auto, 0,#__align_auto, 0,0 ) 
    SetAlignment(Widgets(Hex(33)), #__align_auto, 0,0,#__align_auto, 0 )              
    SetAlignment(Widgets(Hex(44)), #__align_auto, 0,0,0, #__align_auto )      
    
    
    SetAlignment(Widgets(Hex(5)), #__align_auto,  #__align_auto, #__align_auto, #__align_auto, #__align_auto )
    
    SetAlignment(Widgets(Hex(51)), #__align_auto, #__align_auto, 0,0,0 ) 
    SetAlignment(Widgets(Hex(52)), #__align_auto, 0, #__align_auto,0,0 ) 
    SetAlignment(Widgets(Hex(53)), #__align_auto, 0,0, #__align_auto,0 )              
    SetAlignment(Widgets(Hex(54)), #__align_auto, 0,0,0, #__align_auto )      
    ;     
    SetAlignment(Widgets(Hex(55)), #__align_auto, #__align_auto, #__align_auto, #__align_auto, #__align_auto )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  
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