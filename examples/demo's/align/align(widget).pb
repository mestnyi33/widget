
IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
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
            If GetWidgetText(*eventWidget) = "parent stretch"
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
              ;               ; SetWidgetItemState(tree_view, CountItems(tree_view), 1)
              
            EndIf
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  #__flag_TextLeft = #__flag_Textleft
  #__flag_TextRight = #__flag_Textright
  
  Procedure example_1( )
    *root = OpenRoot( #PB_Any, 30, 30, 190, 200, #PB_Compiler_Procedure+"(proportional-alignment (alexample_1))", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    SetWidgetColor(*root, #__color_back, $FFACE3FF )
    
    wlist(Hex(2)) = ButtonWidget(55, 5, 80, 20, "center")   ; center \2     align_proportional_horizontal
    wlist(Hex(3)) = ButtonWidget(55, 25, 80, 20, "right")   ; right         #right
    wlist(Hex(4)) = ContainerWidget(55, 45, 80, 20)         ; stretch       #stretch 
    wlist(Hex(44)) = ButtonWidget(0, 5, 80, 20, "parent stretch")
    CloseWidgetList()
    
    wlist(Hex(5)) = ButtonWidget(55, 65, 80, 20, ">>|<<")    ; proportional  #proportion
    
    wlist(Hex(6)) = ButtonWidget(10, 90, 80, 20, ">>|", #__flag_TextRight) ; proportional
    wlist(Hex(7)) = ButtonWidget(100, 90, 80, 20, "|<<", #__flag_TextLeft) ; proportional
    
    wlist(Hex(8)) = ButtonWidget(10, 115, 50, 20, ">>|", #__flag_TextRight) ; proportional
    wlist(Hex(9)) = ButtonWidget(60, 115, 20, 20, "|")                    ; proportional
    wlist(Hex(10)) = ButtonWidget(80, 115, 30, 20, "<<>>")                ; proportional
    wlist(Hex(11)) = ButtonWidget(110, 115, 20, 20, "|")                  ; proportional
    wlist(Hex(12)) = ButtonWidget(130, 115, 50, 20, "|<<", #__flag_TextLeft); proportional
    
    
    SetAlign(wlist(Hex(2)), 0, 0,1,0,#__align_proportional )    
    SetAlign(wlist(Hex(3)), 0, 0,0,1,0 )
    SetAlign(wlist(Hex(4)), 0, 1,#__align_proportional,1,1 )
    
    SetAlign(wlist(Hex(44)), 0, 0,1,0,0 )
    SetAlign(wlist(Hex(5)), 0, #__align_proportional,0,#__align_proportional,1 )
    
    SetAlign(wlist(Hex(6)), 0, 1,0,#__align_proportional,1 )
    SetAlign(wlist(Hex(7)), 0, #__align_proportional,0,1,1 )
    
    SetAlign(wlist(Hex(8)), 0, 1,0,0,1 )
    SetAlign(wlist(Hex(9)), 0, 1,0,0,1 )
    SetAlign(wlist(Hex(10)), 0, 1,0,1,1 )
    SetAlign(wlist(Hex(11)), 0, 0,0,1,1 )
    SetAlign(wlist(Hex(12)), 0, 0,0,1,1 )
    
    BindWidgetEvent(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  Procedure example_2( )
    *root = OpenRoot( #PB_Any, 310, 30, 190, 200, #PB_Compiler_Procedure+"(alignment-auto-indent)", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    wlist(Hex(10)) = ButtonWidget(0, 0, 90, 50, "left&center&right")      
    wlist(Hex(11)) = ButtonWidget(0, 0, 90, 50, "top&center&bottom")      
    
    wlist(Hex(1)) = ButtonWidget(0, 0, 80, 40, "left")        ; center \2     align_proportional_horizontal
    wlist(Hex(2)) = ButtonWidget(0, 0, 80, 40, "top")         ; center \2     align_proportional_horizontal
    wlist(Hex(3)) = ButtonWidget(0, 0, 80, 40, "right")       ; right         #right
    wlist(Hex(4)) = ButtonWidget(0, 0, 80, 40, "bottom")      ; right         #right
    
    wlist(Hex(5)) = ButtonWidget(0, 0, 80, 40, "center")      ; center \2     align_proportional_horizontal
    
    wlist(Hex(6)) = ButtonWidget(0, 0, 80, 40, "left&top")    ; right         #right
    wlist(Hex(7)) = ButtonWidget(0, 0, 80, 40, "right&top")   ; right         #right
    wlist(Hex(8)) = ButtonWidget(0, 0, 80, 40, "left&bottom") ; right         #right
    wlist(Hex(9)) = ButtonWidget(0, 0, 80, 40, "right&bottom"); right         #right
    
    Define position = 1;#__align_auto
    Define mode = #__align_auto
    SetAlign( wlist(Hex(1)), mode, position,0,0,0 )
    SetAlign( wlist(Hex(2)), mode, 0,position,0,0 )
    SetAlign( wlist(Hex(3)), mode, 0,0,position,0 )
    SetAlign( wlist(Hex(4)), mode, 0,0,0,position )
    
    SetAlign( wlist(Hex(6)), mode, position,position,0,0 )
    SetAlign( wlist(Hex(7)), mode, 0,position,position,0 )
    SetAlign( wlist(Hex(8)), mode, position,0,0,position )
    SetAlign( wlist(Hex(9)), mode, 0,0,position,position )
    
    SetAlign( wlist(Hex(10)), mode, position,0,position,0 )
    SetAlign( wlist(Hex(11)), mode, 0,position,0,position )
    
    SetAlign( wlist(Hex(5)), #__align_center ) ; , 0,0,0,0 )
    
    
    BindWidgetEvent(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,260)
  EndProcedure
  
  Procedure example_3( )
    *root = OpenRoot( #PB_Any, 250, 330, 390, 200, #PB_Compiler_Procedure+"(gadget-auto-dock)", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    wlist(Hex(1)) = ButtonWidget(0, 0, 60, 20, "left1")  
    wlist(Hex(2)) = ButtonWidget(0, 0, 80, 40, "top1")   
    wlist(Hex(3)) = ButtonWidget(0, 0, 40, 20, "right1")    
    wlist(Hex(4)) = ButtonWidget(0, 0, 80, 20, "bottom1")   
    
    wlist(Hex(11)) = ButtonWidget(0, 0, 40, 20, "left2")   
    wlist(Hex(33)) = ButtonWidget(0, 0, 60, 40, "right2")   
    wlist(Hex(22)) = ButtonWidget(0, 0, 80, 20, "top2")   
    wlist(Hex(44)) = ButtonWidget(0, 0, 80, 40, "bottom2")   
    
    ;wlist(Hex(5)) = WindowWidget(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = ContainerWidget(0, 0, 80, 20)   
    wlist(Hex(5)) = ScrollAreaWidget(0, 0, 80, 20, 500,500,1)   
    ;SetWidgetFrame(wlist(Hex(5)), 1 )
    
    wlist(Hex(51)) = ButtonWidget(0, 0, 60, 20, "left3")  
    wlist(Hex(52)) = ButtonWidget(0, 0, 80, 40, "top3")   
    wlist(Hex(53)) = ButtonWidget(0, 0, 60, 20, "right3")    
    wlist(Hex(54)) = ButtonWidget(0, 0, 80, 20, "bottom3")   
    
    wlist(Hex(55)) = ButtonWidget(0, 0, 80, 20, "center")   
    
    CloseWidgetList()
    
    
    SetAlign(wlist(Hex(1)), #__align_full|#__align_left ) 
    SetAlign(wlist(Hex(2)), #__align_full|#__align_top ) 
    SetAlign(wlist(Hex(3)), #__align_full|#__align_right )              
    SetAlign(wlist(Hex(4)), #__align_full|#__align_bottom )      
    ;     SetAlign(wlist(Hex(1)), #__align_full, 1,0,0,0 ) 
    ;     SetAlign(wlist(Hex(2)), #__align_full, 0,1,0,0 ) 
    ;     SetAlign(wlist(Hex(3)), #__align_full, 0,0,1,0 )              
    ;     SetAlign(wlist(Hex(4)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(11)), #__align_full, 1,0,0,0 ) 
    SetAlign(wlist(Hex(22)), #__align_full, 0,1,0,0 ) 
    SetAlign(wlist(Hex(33)), #__align_full, 0,0,1,0 )              
    SetAlign(wlist(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(5)), #__align_full )
    
    SetAlign(wlist(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlign(wlist(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlign(wlist(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlign(wlist(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(55)), #__align_full )
    
    BindWidgetEvent(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_4( )
    ;ProcedureReturn 
    *root = OpenRoot( #PB_Any, 450, 460, 390, 200, #PB_Compiler_Procedure+"(window-auto-dock)", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    wlist(Hex(1)) = WindowWidget(0, 0, 60, 20, "left1", #__flag_nogadgets)  
    wlist(Hex(2)) = WindowWidget(0, 0, 80, 40, "top1", #__flag_nogadgets)   
    wlist(Hex(3)) = WindowWidget(0, 0, 40, 20, "right1", #__flag_nogadgets)    
    wlist(Hex(4)) = WindowWidget(0, 0, 80, 20, "bottom1", #__flag_nogadgets)   
    
    wlist(Hex(11)) = WindowWidget(0, 0, 40, 20, "left2", #__flag_nogadgets)   
    wlist(Hex(33)) = WindowWidget(0, 0, 60, 40, "right2", #__flag_nogadgets)   
    wlist(Hex(22)) = WindowWidget(0, 0, 80, 20, "top2", #__flag_nogadgets)   
    wlist(Hex(44)) = WindowWidget(0, 0, 80, 40, "bottom2", #__flag_nogadgets)   
    
    wlist(Hex(5)) = WindowWidget(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = ContainerWidget(0, 0, 80, 20)   
    wlist(Hex(51)) = WindowWidget(0, 0, 60, 20, "left3", #__flag_nogadgets, wlist(Hex(5)))  
    wlist(Hex(52)) = WindowWidget(0, 0, 80, 40, "top3", #__flag_nogadgets, wlist(Hex(5)))   
    wlist(Hex(53)) = WindowWidget(0, 0, 60, 20, "right3", #__flag_nogadgets, wlist(Hex(5)))    
    wlist(Hex(54)) = WindowWidget(0, 0, 80, 20, "bottom3", #__flag_nogadgets, wlist(Hex(5)))   
    
    wlist(Hex(55)) = WindowWidget(0, 0, 80, 20, "center", #__flag_nogadgets, wlist(Hex(5)))   
    
    CloseWidgetList()
    ;     SetWidgetFrame(wlist(Hex(5)), 10 )
    ;     SetWidgetFrame(wlist(Hex(1)), 10 )
    ;     SetWidgetFrame(wlist(Hex(55)), 1 )
    
    SetAlign(wlist(Hex(1)), #__align_full|#__align_left ) 
    SetAlign(wlist(Hex(2)), #__align_full|#__align_top ) 
    SetAlign(wlist(Hex(3)), #__align_full|#__align_right )              
    SetAlign(wlist(Hex(4)), #__align_full|#__align_bottom )      
    ;     SetAlign(wlist(Hex(1)), #__align_full, 1,0,0,0 ) 
    ;     SetAlign(wlist(Hex(2)), #__align_full, 0,1,0,0 ) 
    ;     SetAlign(wlist(Hex(3)), #__align_full, 0,0,1,0 )              
    ;     SetAlign(wlist(Hex(4)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(11)), #__align_full, 1,0,0,0 ) 
    SetAlign(wlist(Hex(22)), #__align_full, 0,1,0,0 ) 
    SetAlign(wlist(Hex(33)), #__align_full, 0,0,1,0 )              
    SetAlign(wlist(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(5)), #__align_full )
    
    SetAlign(wlist(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlign(wlist(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlign(wlist(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlign(wlist(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(55)), #__align_full )
    
    BindWidgetEvent(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_5( )
    *root = OpenRoot( #PB_Any, 850, 460, 390, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    wlist(Hex(1)) = ButtonWidget(0, 0, 60, 20, "left1")  
    wlist(Hex(2)) = ButtonWidget(0, 0, 80, 40, "top1")   
    wlist(Hex(3)) = ButtonWidget(0, 0, 60, 20, "right1")    
    wlist(Hex(4)) = ButtonWidget(0, 0, 80, 20, "bottom1")   
    
    wlist(Hex(11)) = ButtonWidget(0, 0, 40, 20, "left2")   
    wlist(Hex(33)) = ButtonWidget(0, 0, 40, 40, "right2")   
    wlist(Hex(22)) = ButtonWidget(0, 0, 80, 20, "top2")   
    wlist(Hex(44)) = ButtonWidget(0, 0, 80, 40, "bottom2")   
    
    wlist(Hex(5)) = WindowWidget(0, 0, 80, 20, "")   
    ;wlist(Hex(5)) = ContainerWidget(0, 0, 80, 20)   
    wlist(Hex(51)) = ButtonWidget(0, 0, 60, 20, "left3")  
    wlist(Hex(52)) = ButtonWidget(0, 0, 80, 40, "top3")   
    wlist(Hex(53)) = ButtonWidget(0, 0, 60, 20, "right3")    
    wlist(Hex(54)) = ButtonWidget(0, 0, 80, 20, "bottom3")   
    
    wlist(Hex(55)) = ButtonWidget(0, 0, 80, 20, "center")   
    
    CloseWidgetList()
    
    SetAlign(wlist(Hex(1)), #__align_auto|#__align_left ) 
    SetAlign(wlist(Hex(2)), #__align_auto|#__align_top ) 
    SetAlign(wlist(Hex(3)), #__align_auto|#__align_right )              
    SetAlign(wlist(Hex(4)), #__align_auto|#__align_bottom )      
    ;     SetAlign(wlist(Hex(1)), #__align_auto, 1,0,0,0 ) 
    ;     SetAlign(wlist(Hex(2)), #__align_auto, 0,1,0,0 ) 
    ;     SetAlign(wlist(Hex(3)), #__align_auto, 0,0,1,0 )              
    ;     SetAlign(wlist(Hex(4)), #__align_auto, 0,0,0,1 )      
    
    SetAlign(wlist(Hex(11)), #__align_auto, 1,0,0,0 ) 
    SetAlign(wlist(Hex(22)), #__align_auto, 0,1,0,0 ) 
    SetAlign(wlist(Hex(33)), #__align_auto, 0,0,1,0 )              
    SetAlign(wlist(Hex(44)), #__align_auto, 0,0,0,1 )      
    
    
    SetAlign(wlist(Hex(5)), #__align_auto )
    
    SetAlign(wlist(Hex(51)), #__align_auto, 1,0,0,0 ) 
    SetAlign(wlist(Hex(52)), #__align_auto, 0,1,0,0 ) 
    SetAlign(wlist(Hex(53)), #__align_auto, 0,0,1,0 )              
    SetAlign(wlist(Hex(54)), #__align_auto, 0,0,0,1 )      
    ;     
    SetAlign(wlist(Hex(55)), #__align_auto )
    
    BindWidgetEvent(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_6( )
    Protected width = 460
    Protected height = 200
    
    *root = OpenRoot( #PB_Any, 620, 30, width, height, #PB_Compiler_Procedure+"(Proportional)", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    ;\\
    wlist(Hex(6)) = ButtonWidget(10, 10, 120, 40, "left&top") 
    wlist(Hex(2)) = ButtonWidget((width-120)/2, 10, 120, 40, "top")
    wlist(Hex(7)) = ButtonWidget(width-130, 10, 120, 40, "top&right") 
    
    wlist(Hex(1)) = ButtonWidget(10, (height-40)/2, 120, 40, "left") 
    wlist(Hex(5)) = ButtonWidget((width-120)/2, (height-40)/2, 120, 40, "center")
    wlist(Hex(3)) = ButtonWidget(width-130, (height-40)/2, 120, 40, "right")
    
    wlist(Hex(8)) = ButtonWidget(10, height-50, 120, 40, "left&bottom")
    wlist(Hex(4)) = ButtonWidget((width-120)/2, height-50, 120, 40, "bottom")
    wlist(Hex(9)) = ButtonWidget(width-130, height-50, 120, 40, "bottom&right")
    
    ;\\ OK example - 1
    SetAlign( wlist(Hex(6)), #__align_proportional, 1,1,0,0 )
    SetAlign( wlist(Hex(2)), #__align_proportional, 0,1,0,0 )
    SetAlign( wlist(Hex(7)), #__align_proportional, 0,1,1,0 )
    
    SetAlign( wlist(Hex(1)), #__align_proportional, 1,0,0,0 )
    SetAlign( wlist(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
    SetAlign( wlist(Hex(3)), #__align_proportional, 0,0,1,0 )
    
    SetAlign( wlist(Hex(8)), #__align_proportional, 1,0,0,1 )
    SetAlign( wlist(Hex(4)), #__align_proportional, 0,0,0,1 )
    SetAlign( wlist(Hex(9)), #__align_proportional, 0,0,1,1 )
    
    ;      ;\\ Ok example - 2
    ;     SetAlign( wlist(Hex(6)), #__align_proportional|#__align_top|#__align_left )
    ;     SetAlign( wlist(Hex(2)), #__align_proportional|#__align_top )
    ;     SetAlign( wlist(Hex(7)), #__align_proportional|#__align_top|#__align_right )
    ;     
    ;     SetAlign( wlist(Hex(1)), #__align_proportional|#__align_left )
    ;     SetAlign( wlist(Hex(5)), #__align_proportional )
    ;     SetAlign( wlist(Hex(3)), #__align_proportional|#__align_right )
    ;     
    ;     SetAlign( wlist(Hex(8)), #__align_proportional|#__align_bottom|#__align_left )
    ;     SetAlign( wlist(Hex(4)), #__align_proportional|#__align_bottom )
    ;     SetAlign( wlist(Hex(9)), #__align_proportional|#__align_bottom|#__align_right )
    ;    
    ;     ;\\ OK example - 3
    ;     SetAlign( wlist(Hex(6)), 0, 0                    ,0                    ,#__align_proportional,#__align_proportional )
    ;     SetAlign( wlist(Hex(2)), 0, #__align_proportional,0                    ,#__align_proportional,#__align_proportional )
    ;     SetAlign( wlist(Hex(7)), 0, #__align_proportional,0                    ,0                    ,#__align_proportional )
    ;     
    ;     SetAlign( wlist(Hex(1)), 0, 0                    ,#__align_proportional,#__align_proportional,#__align_proportional )
    ;     SetAlign( wlist(Hex(5)), 0, #__align_proportional,#__align_proportional,#__align_proportional,#__align_proportional )
    ;     SetAlign( wlist(Hex(3)), 0, #__align_proportional,#__align_proportional,0                    ,#__align_proportional )
    ;     
    ;     SetAlign( wlist(Hex(8)), 0, 0                    ,#__align_proportional,#__align_proportional,0 )
    ;     SetAlign( wlist(Hex(4)), 0, #__align_proportional,#__align_proportional,#__align_proportional,0 )
    ;     SetAlign( wlist(Hex(9)), 0, #__align_proportional,#__align_proportional,0                    ,0 )
    
    ;     ;\\ example - 4
    ;     SetAlign( wlist(Hex(6)), #__align_proportional, -5,-5,0,0 )
    ;     SetAlign( wlist(Hex(2)), #__align_proportional, 0,-5,0,0 )
    ;     SetAlign( wlist(Hex(7)), #__align_proportional, 0,-5,-5,0 )
    ;     
    ;     SetAlign( wlist(Hex(1)), #__align_proportional, -5,0,0,0 )
    ;     SetAlign( wlist(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
    ;     SetAlign( wlist(Hex(3)), #__align_proportional, 0,0,-5,0 )
    ;     
    ;     SetAlign( wlist(hex(8)), #__align_proportional, -5,0,0,-5 )
    ;     SetAlign( wlist(Hex(4)), #__align_proportional, 0,0,0,-5 )
    ;     SetAlign( wlist(Hex(9)), #__align_proportional, 0,0,-5,-5 )
    
    BindWidgetEvent(root(), @events())
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 490,390)
  EndProcedure
  
  Procedure example_7( )
    Protected width = 384
    Protected height = 144
    
    *root = OpenRoot( #PB_Any, 320, 130, width, height, #PB_Compiler_Procedure+"(indent-auto-alignment (example_2))", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    ;\\
    wlist(Hex(6)) = ButtonWidget(10, 10, 120, 40, "left&top") 
    wlist(Hex(2)) = ButtonWidget((width-120)/2, 10, 120, 40, "top")
    wlist(Hex(7)) = ButtonWidget(width-130, 10, 120, 40, "top&right") 
    
    wlist(Hex(1)) = ButtonWidget(10, (height-40)/2, 120, 40, "left") 
    wlist(Hex(5)) = ButtonWidget((width-120)/2, (height-40)/2, 120, 40, "center")
    wlist(Hex(3)) = ButtonWidget(width-130, (height-40)/2, 120, 40, "right")
    
    wlist(Hex(8)) = ButtonWidget(10, height-50, 120, 40, "left&bottom")
    wlist(Hex(4)) = ButtonWidget((width-120)/2, height-50, 120, 40, "bottom")
    wlist(Hex(9)) = ButtonWidget(width-130, height-50, 120, 40, "bottom&right")
    
    ;      ;\\ Ok example - 1
    ;     SetAlign( wlist(Hex(2)), #__align_center|#__align_proportional|#__align_top )
    ;     SetAlign( wlist(Hex(1)), #__align_center|#__align_proportional|#__align_left )
    ;     SetAlign( wlist(Hex(5)), #__align_center )
    ;     SetAlign( wlist(Hex(3)), #__align_center|#__align_proportional|#__align_right )
    ;     SetAlign( wlist(Hex(4)), #__align_center|#__align_proportional|#__align_bottom )
    
    ;\\ OK example - 3
    SetAlign( wlist(Hex(6)), 0, 1,1,#__align_proportional,#__align_proportional )
    SetAlign( wlist(Hex(2)), 0, 0,1,0,#__align_proportional )
    SetAlign( wlist(Hex(7)), 0, #__align_proportional,1,1,#__align_proportional )
    
    SetAlign( wlist(Hex(1)), 0, 1,0,#__align_proportional,0 )
    SetAlign( wlist(Hex(5)), #__align_center ) ; , 0,0,0,0 )
    SetAlign( wlist(Hex(3)), 0, #__align_proportional,0,1,0 )
    
    SetAlign( wlist(Hex(8)), 0, 1,#__align_proportional,#__align_proportional,1 )
    SetAlign( wlist(Hex(4)), 0, 0,#__align_proportional,0,1 )
    SetAlign( wlist(Hex(9)), 0, #__align_proportional,#__align_proportional,1,1 )
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 690,490)
  EndProcedure
  
  ;
  Procedure example_demo()
    *root = OpenRoot( #PB_Any, 20, 540, 250, 410, "test", #PB_Window_SizeGadget)
    Canvas_0 = GetCanvasGadget(*root)
    Window_0 = GetCanvasWindow(*root)
    
    ;     ;\\
    ;     tree_view = TreeWidget(0, 0, 0, 0, #__flag_autosize)   
    
    ;\\
    Define tree_button1 = ButtonWidget( 5,   345, 240,  25, "")
    Define tree_button2 = ButtonWidget( 5,   345+30, 240, 30,"")
    Define tree_container = WindowWidget( 10, 10, 230-#__window_FrameSize*2,  325-#__window_FrameSize*2-#__window_CaptionHeight, "", #PB_Window_SystemMenu)
    tree_view = TreeWidget(10, 10, 230-20-#__window_FrameSize*2,  325-20-#__window_FrameSize*2-#__window_CaptionHeight)  : CloseWidgetList( )
    
    SetAlign(tree_container, 0, 1,1,1,1 )
    SetAlign(tree_view, 0, 1,1,1,1 )
    
    SetAlign(tree_button1, 0, 1,0,1,1 )
    SetAlign(tree_button2, 0, 1,0,1,1 )
    
    BindWidgetEvent(root(), @events())
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
  
  WaitCloseRoot( )
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
; CursorPosition = 461
; FirstLine = 295
; Folding = --x-
; Optimizer
; EnableXP
; DPIAware