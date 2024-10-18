
IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  Global tree_view
  Global *this._s_widget
  Global *root._S_widget
  Global NewMap wlist.i()
  Global.i Window_0, Canvas_0, gEvent, gQuit, x=10,y=10
  
  Procedure events()
    Protected *eventWidget._s_widget = EventWidget()
    Select WidgetEvent()
      Case #__event_mouseenter ; leftclick
        If tree_view
          ;Debug *eventWidget
          ClearItems(tree_view)
          ;Debug *eventWidget
          If *eventWidget And *eventWidget\align
            ;Debug AnchorLeft(*eventWidget)
            If GetText(*eventWidget) = "parent stretch"
              ; *eventWidget = *eventWidget\parent
            EndIf
            
            If *eventWidget And *eventWidget\align
              If *eventWidget\align\left > 0
                AddItem(tree_view, -1, "LEFT")
              ElseIf *eventWidget\align\left < 0
                AddItem(tree_view, -1, "LEFT-PROPORTIONAL")
              EndIf
              
              If *eventWidget\align\right > 0
                AddItem(tree_view, -1, "RIGHT")
              ElseIf *eventWidget\align\right < 0
                AddItem(tree_view, -1, "RIGHT-PROPORTIONAL")
              EndIf
              
              If *eventWidget\align\top > 0
                AddItem(tree_view, -1, "TOP")
              ElseIf *eventWidget\align\top < 0
                AddItem(tree_view, -1, "TOP-PROPORTIONAL")
              EndIf
              
              If *eventWidget\align\bottom > 0
                AddItem(tree_view, -1, "BOTTOM")
              ElseIf *eventWidget\align\bottom < 0
                AddItem(tree_view, -1, "BOTTOM-PROPORTIONAL")
              EndIf
              
              ;               If CountItems(tree_view) = 0
              ;                 AddItem(tree_view, -1, "CENTER")
              ;               EndIf
              ;               
              ;               ; SetItemState(tree_view, CountItems(tree_view), 1)
              
            EndIf
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  #__button_left = #__text_left
  #__button_right = #__text_right
  
  Procedure _SetAlignment( *this._S_widget, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
    ProcedureReturn SetAlignment( *this, mode, left, top, right, bottom )
  EndProcedure
  
  Procedure example_1( )
    *root = Open( #PB_Any, 30, 30, 190, 200, #PB_Compiler_Procedure+"(proportional-alignment (alexample_1))", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    SetColor(*root, #__color_back, $FFACE3FF )
    
    wlist(Hex(2)) = Button(55, 5, 80, 20, "center")   ; center \2     align_proportional_horizontal
    wlist(Hex(3)) = Button(55, 25, 80, 20, "right")   ; right         #right
    wlist(Hex(4)) = Container(55, 45, 80, 20)         ; stretch       #stretch 
    wlist(Hex(44)) = Button(0, 5, 80, 20, "parent stretch")
    CloseList()
    
    wlist(Hex(5)) = Button(55, 65, 80, 20, ">>|<<")    ; proportional  #proportion
    
    wlist(Hex(6)) = Button(10, 90, 80, 20, ">>|", #__button_right) ; proportional
    wlist(Hex(7)) = Button(100, 90, 80, 20, "|<<", #__button_left) ; proportional
    
    wlist(Hex(8)) = Button(10, 115, 50, 20, ">>|", #__button_right) ; proportional
    wlist(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    wlist(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    wlist(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    wlist(Hex(12)) = Button(130, 115, 50, 20, "|<<", #__button_left); proportional
    
    
    _SetAlignment(wlist(Hex(2)), 0, 0,1,0,#__align_proportional )    
    _SetAlignment(wlist(Hex(3)), 0, 0,0,1,0 )
    _SetAlignment(wlist(Hex(4)), 0, 1,#__align_proportional,1,1 )
    
    _SetAlignment(wlist(Hex(44)), 0, 0,1,0,0 )
    _SetAlignment(wlist(Hex(5)), 0, #__align_proportional,0,#__align_proportional,1 )
    
    _SetAlignment(wlist(Hex(6)), 0, 1,0,#__align_proportional,1 )
    _SetAlignment(wlist(Hex(7)), 0, #__align_proportional,0,1,1 )
    
    _SetAlignment(wlist(Hex(8)), 0, 1,0,0,1 )
    _SetAlignment(wlist(Hex(9)), 0, 1,0,0,1 )
    _SetAlignment(wlist(Hex(10)), 0, 1,0,1,1 )
    _SetAlignment(wlist(Hex(11)), 0, 0,0,1,1 )
    _SetAlignment(wlist(Hex(12)), 0, 0,0,1,1 )
    
    bind(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  Procedure example_2( )
    *root = Open( #PB_Any, 310, 30, 190, 200, #PB_Compiler_Procedure+"(alignment-auto-indent)", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    wlist(Hex(10)) = Button(0, 0, 90, 50, "left&center&right")      
    wlist(Hex(11)) = Button(0, 0, 90, 50, "top&center&bottom")      
    
    wlist(Hex(1)) = Button(0, 0, 80, 40, "left")        ; center \2     align_proportional_horizontal
    wlist(Hex(2)) = Button(0, 0, 80, 40, "top")         ; center \2     align_proportional_horizontal
    wlist(Hex(3)) = Button(0, 0, 80, 40, "right")       ; right         #right
    wlist(Hex(4)) = Button(0, 0, 80, 40, "bottom")      ; right         #right
    
    wlist(Hex(5)) = Button(0, 0, 80, 40, "center")      ; center \2     align_proportional_horizontal
    
    wlist(Hex(6)) = Button(0, 0, 80, 40, "left&top")    ; right         #right
    wlist(Hex(7)) = Button(0, 0, 80, 40, "right&top")   ; right         #right
    wlist(Hex(8)) = Button(0, 0, 80, 40, "left&bottom") ; right         #right
    wlist(Hex(9)) = Button(0, 0, 80, 40, "right&bottom"); right         #right
    
    Define position = #__align_auto;#__align_auto
    Define mode = #__align_auto
    SetAlignment( wlist(Hex(1)), mode, position,0,0,0 )
    SetAlignment( wlist(Hex(2)), mode, 0,position,0,0 )
    SetAlignment( wlist(Hex(3)), mode, 0,0,position,0 )
    SetAlignment( wlist(Hex(4)), mode, 0,0,0,position )
    
    SetAlignment( wlist(Hex(6)), mode, position,position,0,0 )
    SetAlignment( wlist(Hex(7)), mode, 0,position,position,0 )
    SetAlignment( wlist(Hex(8)), mode, position,0,0,position )
    SetAlignment( wlist(Hex(9)), mode, 0,0,position,position )
    
    SetAlignment( wlist(Hex(10)), mode, position,0,position,0 )
    SetAlignment( wlist(Hex(11)), mode, 0,position,0,position )
    
    SetAlignment( wlist(Hex(5)), #__align_center ) ; , 0,0,0,0 )
    
    
    bind(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,260)
  EndProcedure
  
  Procedure example_3( )
    *root = Open( #PB_Any, 250, 330, 390, 200, #PB_Compiler_Procedure+"(gadget-auto-dock)", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    wlist(Hex(1)) = Button(0, 0, 60, 20, "left1")  
    wlist(Hex(2)) = Button(0, 0, 80, 40, "top1")   
    wlist(Hex(3)) = Button(0, 0, 40, 20, "right1")    
    wlist(Hex(4)) = Button(0, 0, 80, 20, "bottom1")   
    
    wlist(Hex(11)) = Button(0, 0, 40, 20, "left2")   
    wlist(Hex(33)) = Button(0, 0, 60, 40, "right2")   
    wlist(Hex(22)) = Button(0, 0, 80, 20, "top2")   
    wlist(Hex(44)) = Button(0, 0, 80, 40, "bottom2")   
    
    ;wlist(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = Container(0, 0, 80, 20)   
    wlist(Hex(5)) = ScrollArea(0, 0, 80, 20, 500,500,1)   
    ;SetFrame(wlist(Hex(5)), 1 )
    
    wlist(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    wlist(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    wlist(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    wlist(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    wlist(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    
    SetAlignment(wlist(Hex(1)), #__align_full|#__align_left ) 
    SetAlignment(wlist(Hex(2)), #__align_full|#__align_top ) 
    SetAlignment(wlist(Hex(3)), #__align_full|#__align_right )              
    SetAlignment(wlist(Hex(4)), #__align_full|#__align_bottom )      
    ;     SetAlignment(wlist(Hex(1)), #__align_full, 1,0,0,0 ) 
    ;     SetAlignment(wlist(Hex(2)), #__align_full, 0,1,0,0 ) 
    ;     SetAlignment(wlist(Hex(3)), #__align_full, 0,0,1,0 )              
    ;     SetAlignment(wlist(Hex(4)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(11)), #__align_full, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(22)), #__align_full, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(33)), #__align_full, 0,0,1,0 )              
    SetAlignment(wlist(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(5)), #__align_full )
    
    SetAlignment(wlist(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlignment(wlist(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(55)), #__align_full )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_4( )
    ;ProcedureReturn 
    *root = Open( #PB_Any, 450, 460, 390, 200, #PB_Compiler_Procedure+"(window-auto-dock)", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    wlist(Hex(1)) = Window(0, 0, 60, 20, "left1", #__flag_nogadgets)  
    wlist(Hex(2)) = Window(0, 0, 80, 40, "top1", #__flag_nogadgets)   
    wlist(Hex(3)) = Window(0, 0, 40, 20, "right1", #__flag_nogadgets)    
    wlist(Hex(4)) = Window(0, 0, 80, 20, "bottom1", #__flag_nogadgets)   
    
    wlist(Hex(11)) = Window(0, 0, 40, 20, "left2", #__flag_nogadgets)   
    wlist(Hex(33)) = Window(0, 0, 60, 40, "right2", #__flag_nogadgets)   
    wlist(Hex(22)) = Window(0, 0, 80, 20, "top2", #__flag_nogadgets)   
    wlist(Hex(44)) = Window(0, 0, 80, 40, "bottom2", #__flag_nogadgets)   
    
    wlist(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = Container(0, 0, 80, 20)   
    wlist(Hex(51)) = Window(0, 0, 60, 20, "left3", #__flag_nogadgets, wlist(Hex(5)))  
    wlist(Hex(52)) = Window(0, 0, 80, 40, "top3", #__flag_nogadgets, wlist(Hex(5)))   
    wlist(Hex(53)) = Window(0, 0, 60, 20, "right3", #__flag_nogadgets, wlist(Hex(5)))    
    wlist(Hex(54)) = Window(0, 0, 80, 20, "bottom3", #__flag_nogadgets, wlist(Hex(5)))   
    
    wlist(Hex(55)) = Window(0, 0, 80, 20, "center", #__flag_nogadgets, wlist(Hex(5)))   
    
    CloseList()
    ;     SetFrame(wlist(Hex(5)), 10 )
    ;     SetFrame(wlist(Hex(1)), 10 )
    ;     SetFrame(wlist(Hex(55)), 1 )
    
    SetAlignment(wlist(Hex(1)), #__align_full|#__align_left ) 
    SetAlignment(wlist(Hex(2)), #__align_full|#__align_top ) 
    SetAlignment(wlist(Hex(3)), #__align_full|#__align_right )              
    SetAlignment(wlist(Hex(4)), #__align_full|#__align_bottom )      
    ;     SetAlignment(wlist(Hex(1)), #__align_full, 1,0,0,0 ) 
    ;     SetAlignment(wlist(Hex(2)), #__align_full, 0,1,0,0 ) 
    ;     SetAlignment(wlist(Hex(3)), #__align_full, 0,0,1,0 )              
    ;     SetAlignment(wlist(Hex(4)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(11)), #__align_full, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(22)), #__align_full, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(33)), #__align_full, 0,0,1,0 )              
    SetAlignment(wlist(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(5)), #__align_full )
    
    SetAlignment(wlist(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlignment(wlist(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(55)), #__align_full )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_5( )
    *root = Open( #PB_Any, 850, 460, 390, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    wlist(Hex(1)) = Button(0, 0, 60, 20, "left1")  
    wlist(Hex(2)) = Button(0, 0, 80, 40, "top1")   
    wlist(Hex(3)) = Button(0, 0, 60, 20, "right1")    
    wlist(Hex(4)) = Button(0, 0, 80, 20, "bottom1")   
    
    wlist(Hex(11)) = Button(0, 0, 40, 20, "left2")   
    wlist(Hex(33)) = Button(0, 0, 40, 40, "right2")   
    wlist(Hex(22)) = Button(0, 0, 80, 20, "top2")   
    wlist(Hex(44)) = Button(0, 0, 80, 40, "bottom2")   
    
    wlist(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = Container(0, 0, 80, 20)   
    wlist(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    wlist(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    wlist(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    wlist(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    wlist(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    SetAlignment(wlist(Hex(1)), #__align_auto|#__align_left ) 
    SetAlignment(wlist(Hex(2)), #__align_auto|#__align_top ) 
    SetAlignment(wlist(Hex(3)), #__align_auto|#__align_right )              
    SetAlignment(wlist(Hex(4)), #__align_auto|#__align_bottom )      
    ;     SetAlignment(wlist(Hex(1)), #__align_auto, 1,0,0,0 ) 
    ;     SetAlignment(wlist(Hex(2)), #__align_auto, 0,1,0,0 ) 
    ;     SetAlignment(wlist(Hex(3)), #__align_auto, 0,0,1,0 )              
    ;     SetAlignment(wlist(Hex(4)), #__align_auto, 0,0,0,1 )      
    
    SetAlignment(wlist(Hex(11)), #__align_auto, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(22)), #__align_auto, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(33)), #__align_auto, 0,0,1,0 )              
    SetAlignment(wlist(Hex(44)), #__align_auto, 0,0,0,1 )      
    
    
    SetAlignment(wlist(Hex(5)), #__align_auto )
    
    SetAlignment(wlist(Hex(51)), #__align_auto, 1,0,0,0 ) 
    SetAlignment(wlist(Hex(52)), #__align_auto, 0,1,0,0 ) 
    SetAlignment(wlist(Hex(53)), #__align_auto, 0,0,1,0 )              
    SetAlignment(wlist(Hex(54)), #__align_auto, 0,0,0,1 )      
    ;     
    SetAlignment(wlist(Hex(55)), #__align_auto )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_6( )
    Protected width = 460
    Protected height = 200
    
    *root = Open( #PB_Any, 620, 30, width, height, #PB_Compiler_Procedure+"(Proportional)", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    ;\\
    wlist(Hex(6)) = Button(10, 10, 120, 40, "left&top") 
    wlist(Hex(2)) = Button((width-120)/2, 10, 120, 40, "top")
    wlist(Hex(7)) = Button(width-130, 10, 120, 40, "top&right") 
    
    wlist(Hex(1)) = Button(10, (height-40)/2, 120, 40, "left") 
    wlist(Hex(5)) = Button((width-120)/2, (height-40)/2, 120, 40, "center")
    wlist(Hex(3)) = Button(width-130, (height-40)/2, 120, 40, "right")
    
    wlist(Hex(8)) = Button(10, height-50, 120, 40, "left&bottom")
    wlist(Hex(4)) = Button((width-120)/2, height-50, 120, 40, "bottom")
    wlist(Hex(9)) = Button(width-130, height-50, 120, 40, "bottom&right")
    
    ;\\ OK example - 1
    _SetAlignment( wlist(Hex(6)), #__align_proportional, 1,1,0,0 )
    _SetAlignment( wlist(Hex(2)), #__align_proportional, 0,1,0,0 )
    _SetAlignment( wlist(Hex(7)), #__align_proportional, 0,1,1,0 )
    
    _SetAlignment( wlist(Hex(1)), #__align_proportional, 1,0,0,0 )
    _SetAlignment( wlist(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
    _SetAlignment( wlist(Hex(3)), #__align_proportional, 0,0,1,0 )
    
    _SetAlignment( wlist(Hex(8)), #__align_proportional, 1,0,0,1 )
    _SetAlignment( wlist(Hex(4)), #__align_proportional, 0,0,0,1 )
    _SetAlignment( wlist(Hex(9)), #__align_proportional, 0,0,1,1 )
    
    ;      ;\\ Ok example - 2
    ;     _SetAlignment( wlist(Hex(6)), #__align_proportional|#__align_top|#__align_left )
    ;     _SetAlignment( wlist(Hex(2)), #__align_proportional|#__align_top )
    ;     _SetAlignment( wlist(Hex(7)), #__align_proportional|#__align_top|#__align_right )
    ;     
    ;     _SetAlignment( wlist(Hex(1)), #__align_proportional|#__align_left )
    ;     _SetAlignment( wlist(Hex(5)), #__align_proportional )
    ;     _SetAlignment( wlist(Hex(3)), #__align_proportional|#__align_right )
    ;     
    ;     _SetAlignment( wlist(Hex(8)), #__align_proportional|#__align_bottom|#__align_left )
    ;     _SetAlignment( wlist(Hex(4)), #__align_proportional|#__align_bottom )
    ;     _SetAlignment( wlist(Hex(9)), #__align_proportional|#__align_bottom|#__align_right )
    ;    
    ;     ;\\ OK example - 3
    ;     _SetAlignment( wlist(Hex(6)), 0, 0                    ,0                    ,#__align_proportional,#__align_proportional )
    ;     _SetAlignment( wlist(Hex(2)), 0, #__align_proportional,0                    ,#__align_proportional,#__align_proportional )
    ;     _SetAlignment( wlist(Hex(7)), 0, #__align_proportional,0                    ,0                    ,#__align_proportional )
    ;     
    ;     _SetAlignment( wlist(Hex(1)), 0, 0                    ,#__align_proportional,#__align_proportional,#__align_proportional )
    ;     _SetAlignment( wlist(Hex(5)), 0, #__align_proportional,#__align_proportional,#__align_proportional,#__align_proportional )
    ;     _SetAlignment( wlist(Hex(3)), 0, #__align_proportional,#__align_proportional,0                    ,#__align_proportional )
    ;     
    ;     _SetAlignment( wlist(Hex(8)), 0, 0                    ,#__align_proportional,#__align_proportional,0 )
    ;     _SetAlignment( wlist(Hex(4)), 0, #__align_proportional,#__align_proportional,#__align_proportional,0 )
    ;     _SetAlignment( wlist(Hex(9)), 0, #__align_proportional,#__align_proportional,0                    ,0 )
    
    ;     ;\\ example - 4
    ;     _SetAlignment( wlist(Hex(6)), #__align_proportional, -5,-5,0,0 )
    ;     _SetAlignment( wlist(Hex(2)), #__align_proportional, 0,-5,0,0 )
    ;     _SetAlignment( wlist(Hex(7)), #__align_proportional, 0,-5,-5,0 )
    ;     
    ;     _SetAlignment( wlist(Hex(1)), #__align_proportional, -5,0,0,0 )
    ;     _SetAlignment( wlist(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
    ;     _SetAlignment( wlist(Hex(3)), #__align_proportional, 0,0,-5,0 )
    ;     
    ;     _SetAlignment( wlist(hex(8)), #__align_proportional, -5,0,0,-5 )
    ;     _SetAlignment( wlist(Hex(4)), #__align_proportional, 0,0,0,-5 )
    ;     _SetAlignment( wlist(Hex(9)), #__align_proportional, 0,0,-5,-5 )
    
    bind(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 490,390)
  EndProcedure
  
  Procedure example_7( )
    Protected width = 384
    Protected height = 144
    
    *root = Open( #PB_Any, 320, 130, width, height, #PB_Compiler_Procedure+"(indent-auto-alignment (example_2))", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    ;\\
    wlist(Hex(6)) = Button(10, 10, 120, 40, "left&top") 
    wlist(Hex(2)) = Button((width-120)/2, 10, 120, 40, "top")
    wlist(Hex(7)) = Button(width-130, 10, 120, 40, "top&right") 
    
    wlist(Hex(1)) = Button(10, (height-40)/2, 120, 40, "left") 
    wlist(Hex(5)) = Button((width-120)/2, (height-40)/2, 120, 40, "center")
    wlist(Hex(3)) = Button(width-130, (height-40)/2, 120, 40, "right")
    
    wlist(Hex(8)) = Button(10, height-50, 120, 40, "left&bottom")
    wlist(Hex(4)) = Button((width-120)/2, height-50, 120, 40, "bottom")
    wlist(Hex(9)) = Button(width-130, height-50, 120, 40, "bottom&right")
    
    ;      ;\\ Ok example - 1
    ;     _SetAlignment( wlist(Hex(2)), #__align_center|#__align_proportional|#__align_top )
    ;     _SetAlignment( wlist(Hex(1)), #__align_center|#__align_proportional|#__align_left )
    ;     _SetAlignment( wlist(Hex(5)), #__align_center )
    ;     _SetAlignment( wlist(Hex(3)), #__align_center|#__align_proportional|#__align_right )
    ;     _SetAlignment( wlist(Hex(4)), #__align_center|#__align_proportional|#__align_bottom )
    
    ;\\ OK example - 3
    _SetAlignment( wlist(Hex(6)), 0, 1,1,#__align_proportional,#__align_proportional )
    _SetAlignment( wlist(Hex(2)), 0, 0,1,0,#__align_proportional )
    _SetAlignment( wlist(Hex(7)), 0, #__align_proportional,1,1,#__align_proportional )
    
    _SetAlignment( wlist(Hex(1)), 0, 1,0,#__align_proportional,0 )
    _SetAlignment( wlist(Hex(5)), #__align_center ) ; , 0,0,0,0 )
    _SetAlignment( wlist(Hex(3)), 0, #__align_proportional,0,1,0 )
    
    _SetAlignment( wlist(Hex(8)), 0, 1,#__align_proportional,#__align_proportional,1 )
    _SetAlignment( wlist(Hex(4)), 0, 0,#__align_proportional,0,1 )
    _SetAlignment( wlist(Hex(9)), 0, #__align_proportional,#__align_proportional,1,1 )
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 690,490)
  EndProcedure
  
  ;
  Procedure example_demo()
    *root = Open( #PB_Any, 20, 540, 250, 410, "test", #PB_Window_SizeGadget)
    Canvas_0 = GetGadget(*root)
    Window_0 = GetWindow(*root)
    
    ;     ;\\
    ;     tree_view = Tree(0, 0, 0, 0, #__flag_autosize)   
    
    ;\\
    Define tree_button1 = Button( 5,   345, 240,  25, "")
    Define tree_button2 = Button( 5,   345+30, 240, 30,"")
    Define tree_container = Window( 10, 10, 230-#__window_frame_size*2,  325-#__window_frame_size*2-#__window_caption_height, "", #PB_Window_SystemMenu)
    tree_view = Tree(10, 10, 230-20-#__window_frame_size*2,  325-20-#__window_frame_size*2-#__window_caption_height)  : CloseList( )
    
    SetAlignment(tree_container, 0, 1,1,1,1 )
    SetAlignment(tree_view, 0, 1,1,1,1 )
    
    SetAlignment(tree_button1, 0, 1,0,1,1 )
    SetAlignment(tree_button2, 0, 1,0,1,1 )
    
    bind(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,400)
  EndProcedure
  
  example_1()
  example_2()
  example_3()
  example_4()
  example_5()
  example_6()
  example_7()
  
  example_demo( )
  
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 283
; FirstLine = 405
; Folding = ----
; Optimizer
; EnableXP
; DPIAware