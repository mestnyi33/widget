
IncludePath "../../../"
XIncludeFile "widgets.pbi"

;XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  Global tree_view
  Global *this._s_widget
  Global NewMap Widgets.i()
  Global.i Window_0, Canvas_0, gEvent, gQuit, x=10,y=10
  
  Procedure events()
    Protected *eventWidget._s_widget = EventWidget()
    Select WidgetEventType()
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
;               ; ReDraw(tree_view)
            EndIf
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  #__button_left = #__text_left
  #__button_right = #__text_right
  
  Procedure _SetAlignment( *this._S_widget, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
    Protected flag.q
    ;\\
    If mode & #__align_auto
      If left = 0 And top = 0 And right = 0 And bottom = 0
        If mode & #__align_left : left = #__align_auto
        ElseIf mode & #__align_top : top = #__align_auto
        ElseIf mode & #__align_right : right = #__align_auto
        ElseIf mode & #__align_bottom : bottom = #__align_auto
        Else
          left   = #__align_auto
          top    = #__align_auto
          right  = #__align_auto
          bottom = #__align_auto
        EndIf
      Else
        If left > 0 : left = #__align_auto : EndIf
        If top > 0 : top = #__align_auto : EndIf
        If right > 0 : right = #__align_auto : EndIf
        If bottom > 0 : bottom = #__align_auto : EndIf
      EndIf
    EndIf
    
    ;\\
    If mode & #__align_full
      If left = 0 And top = 0 And right = 0 And bottom = 0
        If mode & #__align_left : left = #__align_full
        ElseIf mode & #__align_top : top = #__align_full
        ElseIf mode & #__align_right : right = #__align_full
        ElseIf mode & #__align_bottom : bottom = #__align_full
        Else
          left   = #__align_full
          top    = #__align_full
          right  = #__align_full
          bottom = #__align_full
        EndIf
      Else
        If left > 0 : left = #__align_full : EndIf
        If top > 0 : top = #__align_full : EndIf
        If right > 0 : right = #__align_full : EndIf
        If bottom > 0 : bottom = #__align_full : EndIf
      EndIf
    EndIf
    
    ;\\
    If left = #__align_full
      left   = #__align_auto
      top    = #True
      bottom = #True
      flag | #__align_full
    EndIf
    If right = #__align_full
      right  = #__align_auto
      top    = #True
      bottom = #True
      flag | #__align_full
    EndIf
    If top = #__align_full
      top   = #__align_auto
      left  = #True
      right = #True
      flag | #__align_full
    EndIf
    If bottom = #__align_full
      bottom = #__align_auto
      left   = #True
      right  = #True
      flag | #__align_full
    EndIf
    If mode And
       left > 0 And top > 0 And right > 0 And bottom > 0
      flag | #__align_full
    EndIf
    
    ;\\
    If mode & #__align_proportional 
      If left  : left = #__align_proportional : EndIf
      If top  : top = #__align_proportional : EndIf
      If right  : right = #__align_proportional : EndIf
      If bottom  : bottom = #__align_proportional : EndIf
      
      If mode & #__align_right
        left = #__align_proportional
      EndIf
      
      If mode & #__align_left
        right = #__align_proportional
      EndIf
      
      If mode & #__align_top
        bottom = #__align_proportional
      EndIf
      
      If mode & #__align_bottom
        top = #__align_proportional
      EndIf
      
      If left = 0 And right = 0 
        left = #__align_proportional 
        right = #__align_proportional
      EndIf
      If top = 0 And bottom = 0 
        top = #__align_proportional 
        bottom = #__align_proportional
      EndIf
      mode = 0
    EndIf
    
    ;\\
    If *this\_parent( )
      If Not *this\_parent( )\align
        *this\_parent( )\align.allocate( ALIGN )
      EndIf
      If Not *this\align
        *this\align.allocate( ALIGN )
      EndIf
      
      ;\\
      If *this\align
        ;\\ horizontal
        If left Or ( Not right And flag & #__align_full = #__align_full )
          If left = #__align_proportional ;Or ( left And mode & #__align_proportional = #__align_proportional )
            *this\align\left = - 1
          Else
            *this\align\left = 1
          EndIf
        Else
          *this\align\left = 0
        EndIf
        If right Or ( Not left And flag & #__align_full = #__align_full )
          If right = #__align_proportional ;Or ( right And mode & #__align_proportional = #__align_proportional )
            *this\align\right = - 1
          Else
            *this\align\right = 1
          EndIf
        Else
          *this\align\right = 0
        EndIf
        
        ;\\ vertical
        If top Or ( Not bottom And flag & #__align_full = #__align_full )
          If top = #__align_proportional ;Or ( top And mode & #__align_proportional = #__align_proportional )
            *this\align\top = - 1
          Else
            *this\align\top = 1
          EndIf
        Else
          *this\align\top = 0
        EndIf
        If bottom Or ( Not top And flag & #__align_full = #__align_full )
          If bottom = #__align_proportional ;Or ( bottom And mode & #__align_proportional = #__align_proportional )
            *this\align\bottom = - 1
          Else
            *this\align\bottom = 1
          EndIf
        Else
          *this\align\bottom = 0
        EndIf
        
        ;\\ ?-надо тестировать
        If Not *this\_parent( )\align\width
          *this\_parent( )\align\x     = *this\_parent( )\x[#__c_container]
          *this\_parent( )\align\width = *this\_parent( )\width[#__c_frame]
          If *this\_parent( )\type = #__type_window
            *this\_parent( )\align\x + *this\_parent( )\fs
            *this\_parent( )\align\width - *this\_parent( )\fs * 2 - ( *this\_parent( )\fs[1] + *this\_parent( )\fs[3] )
          EndIf
        EndIf
        If Not *this\_parent( )\align\height
          *this\_parent( )\align\y      = *this\_parent( )\y[#__c_container]
          *this\_parent( )\align\height = *this\_parent( )\height[#__c_frame]
          If *this\_parent( )\type = #__type_window
            *this\_parent( )\align\y + *this\_parent( )\fs
            *this\_parent( )\align\height - *this\_parent( )\fs * 2 - ( *this\_parent( )\fs[2] + *this\_parent( )\fs[4] )
          EndIf
        EndIf
        
        ;\\
        If mode
          ;\\ full horizontal
          If *this\align\right And *this\align\left
            *this\align\x     = 0
            *this\align\width = *this\_parent( )\align\width
            If *this\type = #__type_window
              *this\align\width - *this\fs * 2
            EndIf
          Else
            *this\align\width = *this\width[#__c_frame]
            If Not *this\align\right And *this\align\left
              ; left
              *this\align\x = 0
            ElseIf Not *this\align\right And Not *this\align\left
              ; center
              *this\align\x = ( *this\_parent( )\align\width - *this\width[#__c_frame] ) / 2
            ElseIf *this\align\right And Not *this\align\left
              ; right
              *this\align\x = *this\_parent( )\align\width - *this\width[#__c_frame]
              If *this\type = #__type_window
                *this\align\x - *this\fs * 2
              EndIf
            EndIf
          EndIf
          
          ;\\ full vertical
          If *this\align\bottom And *this\align\top
            *this\align\y      = 0
            *this\align\height = *this\_parent( )\align\height
            If *this\type = #__type_window
              *this\align\height - *this\fs * 2
            EndIf
          Else
            *this\align\height = *this\height[#__c_frame]
            If Not *this\align\bottom And *this\align\top
            ; top
              *this\align\y = 0
            ElseIf Not *this\align\bottom And Not *this\align\top
              ; center
              *this\align\y = ( *this\_parent( )\align\height - *this\height[#__c_frame] ) / 2
            ElseIf *this\align\bottom And Not *this\align\top
              ; bottom
              *this\align\y = *this\_parent( )\align\height - *this\height[#__c_frame]
              If *this\type = #__type_window
                *this\align\y - *this\fs * 2
              EndIf
            EndIf
          EndIf
          
          ;
          ;\\ auto stick change
          If *this\_parent( )\align
            If left = #__align_auto And
               *this\_parent( )\align\autodock\x
              left = - *this\_parent( )\align\autodock\x
            EndIf
            If right = #__align_auto And
               *this\_parent( )\align\autodock\width
              right = - *this\_parent( )\align\autodock\width
            EndIf
            If left < 0 Or right < 0
              If left And right
                *this\align\x - left
                *this\align\width - *this\align\x + right
              Else
                *this\align\x - left + right
              EndIf
            EndIf
            
            If top = #__align_auto And
               *this\_parent( )\align\autodock\y
              top = - *this\_parent( )\align\autodock\y
            EndIf
            If bottom = #__align_auto And
               *this\_parent( )\align\autodock\height
              bottom = - *this\_parent( )\align\autodock\height
            EndIf
            If top < 0 Or bottom < 0
              If top And bottom
                *this\align\y - top
                *this\align\height - *this\align\y + bottom
              Else
                *this\align\y - top + bottom
              EndIf
            EndIf
          EndIf
          
          ;\\ auto stick position
          If Not *this\align\right And *this\align\left
            *this\_parent( )\align\autodock\x = *this\align\x + *this\align\width
            If *this\type = #__type_window
              *this\_parent( )\align\autodock\x + *this\fs * 2
            EndIf
          EndIf
          If Not *this\align\bottom And *this\align\top
            *this\_parent( )\align\autodock\y = *this\align\y + *this\align\height
            If *this\type = #__type_window
              *this\_parent( )\align\autodock\y + *this\fs * 2
            EndIf
          EndIf
          If Not *this\align\left And *this\align\right
            *this\_parent( )\align\autodock\width = *this\_parent( )\width[#__c_inner] - *this\align\x
          EndIf
          If Not *this\align\top And *this\align\bottom
            *this\_parent( )\align\autodock\height = *this\_parent( )\height[#__c_inner] - *this\align\y
          EndIf
          
          ;\\ auto stick update
          If flag & #__align_full = #__align_full
            If ( *this\_parent( )\align\autodock\x Or
                 *this\_parent( )\align\autodock\y Or
                 *this\_parent( )\align\autodock\width Or
                 *this\_parent( )\align\autodock\height )
              
              ; loop enumerate widgets
              If StartEnumerate( *this\_parent( ) )
                If enumWidget( )\align
                  If enumWidget( )\align\top And enumWidget( )\align\bottom
                    enumWidget( )\align\y      = enumWidget( )\_parent( )\align\autodock\y
                    enumWidget( )\align\height = enumWidget( )\_parent( )\height[#__c_inner] - ( enumWidget( )\_parent( )\align\autodock\y + enumWidget( )\_parent( )\align\autodock\height )
                    
                    If enumWidget( )\align\left And enumWidget( )\align\right
                      enumWidget( )\align\x     = enumWidget( )\_parent( )\align\autodock\x
                      enumWidget( )\align\width = enumWidget( )\_parent( )\width[#__c_inner] - ( enumWidget( )\_parent( )\align\autodock\x + enumWidget( )\_parent( )\align\autodock\width )
                      
                      If enumWidget( )\type = #__type_window
                        enumWidget( )\align\width - enumWidget( )\fs * 2
                      EndIf
                    EndIf
                    
                    If enumWidget( )\type = #__type_window
                      enumWidget( )\align\height - enumWidget( )\fs * 2
                    EndIf
                  EndIf
                EndIf
                StopEnumerate( )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If Not mode
          *this\align\x = *this\x[#__c_container]
          *this\align\y = *this\y[#__c_container]
          ;\\
          If *this\type = #__type_window
            *this\align\width  = *this\width[#__c_inner]
            *this\align\height = *this\height[#__c_inner]
          Else
            *this\align\width  = *this\width[#__c_frame]
            *this\align\height = *this\height[#__c_frame]
          EndIf
        EndIf
        
        ; update parent childrens coordinate
        Resize( *this\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        PostCanvasRepaint( *this\_root( ) )
      EndIf
    EndIf
    
  EndProcedure
  
  ; proportional
  Procedure example_1()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 30, 30, 190, 200, "proportional-alignment (alexample_1)", #PB_Window_SizeGadget))
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
    
    Widgets(Hex(8)) = Button(10, 115, 50, 20, ">>>|", #__button_right) ; proportional
    Widgets(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    Widgets(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    Widgets(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    Widgets(Hex(12)) = Button(130, 115, 50, 20, "|<<<", #__button_left); proportional
    
    
    ;SetAlignment(Widgets(Hex(2)), 0, 0,#__align_proportional,0,0 )    
    SetAlignment(Widgets(Hex(2)), 0, 0,#__align_proportional,0,1 )    
    SetAlignment(Widgets(Hex(3)), 0, 0,0,1,0 )
    ;SetAlignment(Widgets(Hex(4)), 0, 1,0,1,#__align_proportional )
    SetAlignment(Widgets(Hex(4)), 0, 1,1,1,#__align_proportional )
    SetAlignment(Widgets(Hex(44)), 0, 0,1,0,0 )
    SetAlignment(Widgets(Hex(5)), 0, #__align_proportional,0,#__align_proportional,1 )
    
;     SetAlignment(Widgets(Hex(6)), 0, #__align_proportional,0,0,1 )
;     SetAlignment(Widgets(Hex(7)), 0, 0,0,#__align_proportional,1 )
    SetAlignment(Widgets(Hex(6)), 0, #__align_proportional,0,1,1 )
    SetAlignment(Widgets(Hex(7)), 0, 1,0,#__align_proportional,1 )
    
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
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 130, 190, 200, "indent-auto-alignment (example_2)", #PB_Window_SizeGadget))
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
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 650, 260, 390, 200, "auto-docking (example_3)", #PB_Window_SizeGadget))
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
    
    ;Widgets(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(5)) = ScrollArea(0, 0, 80, 20, 500,500,1)   
    ;SetFrame(Widgets(Hex(5)), 1 )
    
    Widgets(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    Widgets(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    Widgets(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    Widgets(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    Widgets(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    
     SetAlignment(Widgets(Hex(1)), #__align_full|#__align_left ) 
     SetAlignment(Widgets(Hex(2)), #__align_full|#__align_top ) 
     SetAlignment(Widgets(Hex(3)), #__align_full|#__align_right )              
     SetAlignment(Widgets(Hex(4)), #__align_full|#__align_bottom )      
     ;     SetAlignment(Widgets(Hex(1)), #__align_full, 1,0,0,0 ) 
     ;     SetAlignment(Widgets(Hex(2)), #__align_full, 0,1,0,0 ) 
     ;     SetAlignment(Widgets(Hex(3)), #__align_full, 0,0,1,0 )              
     ;     SetAlignment(Widgets(Hex(4)), #__align_full, 0,0,0,1 )      
     
     SetAlignment(Widgets(Hex(11)), #__align_full, 1,0,0,0 ) 
     SetAlignment(Widgets(Hex(22)), #__align_full, 0,1,0,0 ) 
     SetAlignment(Widgets(Hex(33)), #__align_full, 0,0,1,0 )              
     SetAlignment(Widgets(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(5)), #__align_full )
    
    SetAlignment(Widgets(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlignment(Widgets(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlignment(Widgets(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlignment(Widgets(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(55)), #__align_full )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_5()
    ;ProcedureReturn 
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 450, 460, 390, 200, "auto-docking (example_3)", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Window(0, 0, 60, 20, "left1", #__flag_nogadgets)  
    Widgets(Hex(2)) = Window(0, 0, 80, 40, "top1", #__flag_nogadgets)   
    Widgets(Hex(3)) = Window(0, 0, 40, 20, "right1", #__flag_nogadgets)    
    Widgets(Hex(4)) = Window(0, 0, 80, 20, "bottom1", #__flag_nogadgets)   
    
    Widgets(Hex(11)) = Window(0, 0, 40, 20, "left2", #__flag_nogadgets)   
    Widgets(Hex(33)) = Window(0, 0, 60, 40, "right2", #__flag_nogadgets)   
    Widgets(Hex(22)) = Window(0, 0, 80, 20, "top2", #__flag_nogadgets)   
    Widgets(Hex(44)) = Window(0, 0, 80, 40, "bottom2", #__flag_nogadgets)   
    
    Widgets(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(51)) = Window(0, 0, 60, 20, "left3", #__flag_nogadgets, Widgets(Hex(5)))  
    Widgets(Hex(52)) = Window(0, 0, 80, 40, "top3", #__flag_nogadgets, Widgets(Hex(5)))   
    Widgets(Hex(53)) = Window(0, 0, 60, 20, "right3", #__flag_nogadgets, Widgets(Hex(5)))    
    Widgets(Hex(54)) = Window(0, 0, 80, 20, "bottom3", #__flag_nogadgets, Widgets(Hex(5)))   
    
    Widgets(Hex(55)) = Window(0, 0, 80, 20, "center", #__flag_nogadgets, Widgets(Hex(5)))   
    
    CloseList()
;     SetFrame(Widgets(Hex(5)), 10 )
;     SetFrame(Widgets(Hex(1)), 10 )
;     SetFrame(Widgets(Hex(55)), 1 )
    
    SetAlignment(Widgets(Hex(1)), #__align_full|#__align_left ) 
    SetAlignment(Widgets(Hex(2)), #__align_full|#__align_top ) 
    SetAlignment(Widgets(Hex(3)), #__align_full|#__align_right )              
    SetAlignment(Widgets(Hex(4)), #__align_full|#__align_bottom )      
;     SetAlignment(Widgets(Hex(1)), #__align_full, 1,0,0,0 ) 
;     SetAlignment(Widgets(Hex(2)), #__align_full, 0,1,0,0 ) 
;     SetAlignment(Widgets(Hex(3)), #__align_full, 0,0,1,0 )              
;     SetAlignment(Widgets(Hex(4)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(11)), #__align_full, 1,0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), #__align_full, 0,1,0,0 ) 
    SetAlignment(Widgets(Hex(33)), #__align_full, 0,0,1,0 )              
    SetAlignment(Widgets(Hex(44)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(5)), #__align_full )
    
    SetAlignment(Widgets(Hex(51)), #__align_full, 1,0,0,0 ) 
    SetAlignment(Widgets(Hex(52)), #__align_full, 0,1,0,0 ) 
    SetAlignment(Widgets(Hex(53)), #__align_full, 0,0,1,0 )              
    SetAlignment(Widgets(Hex(54)), #__align_full, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(55)), #__align_full )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  ; 
  Procedure example_4()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 850, 460, 390, 200, "auto-alignment (example_4)", #PB_Window_SizeGadget))
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
    
    Widgets(Hex(5)) = Window(0, 0, 80, 20, "")   
    ;Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(51)) = Button(0, 0, 60, 20, "left3")  
    Widgets(Hex(52)) = Button(0, 0, 80, 40, "top3")   
    Widgets(Hex(53)) = Button(0, 0, 60, 20, "right3")    
    Widgets(Hex(54)) = Button(0, 0, 80, 20, "bottom3")   
    
    Widgets(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    SetAlignment(Widgets(Hex(1)), #__align_auto|#__align_left ) 
    SetAlignment(Widgets(Hex(2)), #__align_auto|#__align_top ) 
    SetAlignment(Widgets(Hex(3)), #__align_auto|#__align_right )              
    SetAlignment(Widgets(Hex(4)), #__align_auto|#__align_bottom )      
;     SetAlignment(Widgets(Hex(1)), #__align_auto, 1,0,0,0 ) 
;     SetAlignment(Widgets(Hex(2)), #__align_auto, 0,1,0,0 ) 
;     SetAlignment(Widgets(Hex(3)), #__align_auto, 0,0,1,0 )              
;     SetAlignment(Widgets(Hex(4)), #__align_auto, 0,0,0,1 )      
    
    SetAlignment(Widgets(Hex(11)), #__align_auto, 1,0,0,0 ) 
    SetAlignment(Widgets(Hex(22)), #__align_auto, 0,1,0,0 ) 
    SetAlignment(Widgets(Hex(33)), #__align_auto, 0,0,1,0 )              
    SetAlignment(Widgets(Hex(44)), #__align_auto, 0,0,0,1 )      
    
    
    SetAlignment(Widgets(Hex(5)), #__align_auto )
    
    SetAlignment(Widgets(Hex(51)), #__align_auto, 1,0,0,0 ) 
    SetAlignment(Widgets(Hex(52)), #__align_auto, 0,1,0,0 ) 
    SetAlignment(Widgets(Hex(53)), #__align_auto, 0,0,1,0 )              
    SetAlignment(Widgets(Hex(54)), #__align_auto, 0,0,0,1 )      
    ;     
    SetAlignment(Widgets(Hex(55)), #__align_auto )
    
    bind(root(), @events())
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  Procedure example_6()
    Protected width = 460
    Protected height = 200
    
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 130, width, height, "indent-auto-alignment (example_2)", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    ;\\
    Widgets(Hex(6)) = Button(10, 10, 120, 40, "left&top") 
    Widgets(Hex(2)) = Button((width-120)/2, 10, 120, 40, "top")
    Widgets(Hex(7)) = Button(width-130, 10, 120, 40, "top&right") 
    
    Widgets(Hex(1)) = Button(10, (height-40)/2, 120, 40, "left") 
    Widgets(Hex(5)) = Button((width-120)/2, (height-40)/2, 120, 40, "center")
    Widgets(Hex(3)) = Button(width-130, (height-40)/2, 120, 40, "right")
    
    Widgets(Hex(8)) = Button(10, height-50, 120, 40, "left&bottom")
    Widgets(Hex(4)) = Button((width-120)/2, height-50, 120, 40, "bottom")
    Widgets(Hex(9)) = Button(width-130, height-50, 120, 40, "bottom&right")
    
    
    ;\\ example - 1
    _SetAlignment( Widgets(Hex(6)), #__align_proportional|#__align_bottom|#__align_right )
    _SetAlignment( Widgets(Hex(2)), #__align_proportional|#__align_bottom )
    _SetAlignment( Widgets(Hex(7)), #__align_proportional|#__align_bottom|#__align_left )
    
    _SetAlignment( Widgets(Hex(1)), #__align_proportional|#__align_right )
    _SetAlignment( Widgets(Hex(5)), #__align_proportional )
    _SetAlignment( Widgets(Hex(3)), #__align_proportional|#__align_left )
    
    _SetAlignment( Widgets(Hex(8)), #__align_proportional|#__align_top|#__align_right )
    _SetAlignment( Widgets(Hex(4)), #__align_proportional|#__align_top )
    _SetAlignment( Widgets(Hex(9)), #__align_proportional|#__align_top|#__align_left )
    
;     ;\\ example - 2
;     _SetAlignment( Widgets(Hex(6)), 0, 1                    ,1,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(2)), 0, #__align_proportional,1,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(7)), 0, #__align_proportional,1,1                    ,#__align_proportional )
;     
;     _SetAlignment( Widgets(Hex(1)), 0, 1                    ,#__align_proportional,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(5)), 0, #__align_proportional,#__align_proportional,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(3)), 0, #__align_proportional,#__align_proportional,1                    ,#__align_proportional )
;     
;     _SetAlignment( Widgets(Hex(8)), 0, 1                    ,#__align_proportional,#__align_proportional,1 )
;     _SetAlignment( Widgets(Hex(4)), 0, #__align_proportional,#__align_proportional,#__align_proportional,1 )
;     _SetAlignment( Widgets(Hex(9)), 0, #__align_proportional,#__align_proportional,1                    ,1 )
;     
;     ;\\ example - 3
;     _SetAlignment( Widgets(Hex(6)), #__align_proportional, 1,1,0,0 )
;     _SetAlignment( Widgets(Hex(2)), #__align_proportional, 0,1,0,0 )
;     _SetAlignment( Widgets(Hex(7)), #__align_proportional, 0,1,1,0 )
;     
;     _SetAlignment( Widgets(Hex(1)), #__align_proportional, 1,0,0,0 )
;     _SetAlignment( Widgets(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
;     _SetAlignment( Widgets(Hex(3)), #__align_proportional, 0,0,1,0 )
;     
;     _SetAlignment( Widgets(Hex(8)), #__align_proportional, 1,0,0,1 )
;     _SetAlignment( Widgets(Hex(4)), #__align_proportional, 0,0,0,1 )
;     _SetAlignment( Widgets(Hex(9)), #__align_proportional, 0,0,1,1 )
;     
;     ;\\ example - 4
;     _SetAlignment( Widgets(Hex(6)), #__align_proportional, -5,-5,0,0 )
;     _SetAlignment( Widgets(Hex(2)), #__align_proportional, 0,-5,0,0 )
;     _SetAlignment( Widgets(Hex(7)), #__align_proportional, 0,-5,-5,0 )
;     
;     _SetAlignment( Widgets(Hex(1)), #__align_proportional, -5,0,0,0 )
;     _SetAlignment( Widgets(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
;     _SetAlignment( Widgets(Hex(3)), #__align_proportional, 0,0,-5,0 )
;     
;     _SetAlignment( Widgets(hex(8)), #__align_proportional, -5,0,0,-5 )
;     _SetAlignment( Widgets(Hex(4)), #__align_proportional, 0,0,0,-5 )
;     _SetAlignment( Widgets(Hex(9)), #__align_proportional, 0,0,-5,-5 )
    
    
    ;  ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 90,90)
  EndProcedure
  
  example_1()
  example_2()
  example_3()
  example_4()
  example_5()
  example_6()
  
  
  Procedure example_demo()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 120, 540, 250, 410, "test", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
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
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,400)
    bind(root(), @events())
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
; Folding = 0--------------v+
; EnableXP