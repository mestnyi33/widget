IncludePath "../../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  Global tree_view
  Global *this._s_widget
  Global NewMap Widgets.i()
  Global.i Window_0, Canvas_0, gEvent, gQuit, x=10,y=10
  
  
  #__button_left = #__text_left
  #__button_right = #__text_right
  
  Procedure _SetAlignment( *this._S_widget, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
    ;ProcedureReturn SetAlignment( *this, mode, left, top, right, bottom )
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
      If left = 0 And right = 0 
        left = #__align_proportional 
        right = #__align_proportional
      EndIf
      If top = 0 And bottom = 0 
        top = #__align_proportional 
        bottom = #__align_proportional
      EndIf
      
      If left And left <> #__align_proportional
        If right = 0
          left = 0
        EndIf
        right = #__align_proportional 
      EndIf
      If top And top <> #__align_proportional 
        If bottom = 0
          top = 0
        EndIf
        bottom = #__align_proportional 
      EndIf
      If right And right <> #__align_proportional 
        If left = 0
          right = 0
        EndIf
        left = #__align_proportional 
      EndIf
      If bottom And bottom <> #__align_proportional 
        If top = 0
          bottom = 0 
        EndIf
        top = #__align_proportional 
      EndIf
      
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
    
    Widgets(Hex(8)) = Button(10, 115, 50, 20, ">>|", #__button_right) ; proportional
    Widgets(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    Widgets(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    Widgets(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    Widgets(Hex(12)) = Button(130, 115, 50, 20, "|<<", #__button_left); proportional
    
    
    _SetAlignment(Widgets(Hex(2)), 0, 0,1,0,#__align_proportional )    
    _SetAlignment(Widgets(Hex(3)), 0, 0,0,1,0 )
    _SetAlignment(Widgets(Hex(4)), 0, 1,#__align_proportional,1,1 )
    
    _SetAlignment(Widgets(Hex(44)), 0, 0,1,0,0 )
    _SetAlignment(Widgets(Hex(5)), 0, #__align_proportional,0,#__align_proportional,1 )
    
    _SetAlignment(Widgets(Hex(6)), 0, 1,0,#__align_proportional,1 )
    _SetAlignment(Widgets(Hex(7)), 0, #__align_proportional,0,1,1 )
    
    _SetAlignment(Widgets(Hex(8)), 0, 1,0,0,1 )
    _SetAlignment(Widgets(Hex(9)), 0, 1,0,0,1 )
    _SetAlignment(Widgets(Hex(10)), 0, 1,0,1,1 )
    _SetAlignment(Widgets(Hex(11)), 0, 0,0,1,1 )
    _SetAlignment(Widgets(Hex(12)), 0, 0,0,1,1 )
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
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
    
    ;\\ OK example - 1
    _SetAlignment( Widgets(Hex(6)), #__align_proportional, 1,1,0,0 )
    _SetAlignment( Widgets(Hex(2)), #__align_proportional, 0,1,0,0 )
    _SetAlignment( Widgets(Hex(7)), #__align_proportional, 0,1,1,0 )
    
    _SetAlignment( Widgets(Hex(1)), #__align_proportional, 1,0,0,0 )
    _SetAlignment( Widgets(Hex(5)), #__align_proportional ) ; , 0,0,0,0 )
    _SetAlignment( Widgets(Hex(3)), #__align_proportional, 0,0,1,0 )
    
    _SetAlignment( Widgets(Hex(8)), #__align_proportional, 1,0,0,1 )
    _SetAlignment( Widgets(Hex(4)), #__align_proportional, 0,0,0,1 )
    _SetAlignment( Widgets(Hex(9)), #__align_proportional, 0,0,1,1 )
    
;      ;\\ Ok example - 2
;     _SetAlignment( Widgets(Hex(6)), #__align_proportional|#__align_top|#__align_left )
;     _SetAlignment( Widgets(Hex(2)), #__align_proportional|#__align_top )
;     _SetAlignment( Widgets(Hex(7)), #__align_proportional|#__align_top|#__align_right )
;     
;     _SetAlignment( Widgets(Hex(1)), #__align_proportional|#__align_left )
;     _SetAlignment( Widgets(Hex(5)), #__align_proportional )
;     _SetAlignment( Widgets(Hex(3)), #__align_proportional|#__align_right )
;     
;     _SetAlignment( Widgets(Hex(8)), #__align_proportional|#__align_bottom|#__align_left )
;     _SetAlignment( Widgets(Hex(4)), #__align_proportional|#__align_bottom )
;     _SetAlignment( Widgets(Hex(9)), #__align_proportional|#__align_bottom|#__align_right )
;    
;     ;\\ OK example - 3
;     _SetAlignment( Widgets(Hex(6)), 0, 0                    ,0                    ,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(2)), 0, #__align_proportional,0                    ,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(7)), 0, #__align_proportional,0                    ,0                    ,#__align_proportional )
;     
;     _SetAlignment( Widgets(Hex(1)), 0, 0                    ,#__align_proportional,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(5)), 0, #__align_proportional,#__align_proportional,#__align_proportional,#__align_proportional )
;     _SetAlignment( Widgets(Hex(3)), 0, #__align_proportional,#__align_proportional,0                    ,#__align_proportional )
;     
;     _SetAlignment( Widgets(Hex(8)), 0, 0                    ,#__align_proportional,#__align_proportional,0 )
;     _SetAlignment( Widgets(Hex(4)), 0, #__align_proportional,#__align_proportional,#__align_proportional,0 )
;     _SetAlignment( Widgets(Hex(9)), 0, #__align_proportional,#__align_proportional,0                    ,0 )
    
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
    
    
      ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 690,490)
  EndProcedure
  
  Procedure example_7()
    Protected width = 384
    Protected height = 144
    
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 320, 130, width, height, "indent-auto-alignment (example_2)", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    ;\\
    Widgets(Hex(6)) = Button(10, 10, 120, 40, "left&top") 
    Widgets(Hex(2)) = Button((width-120)/2, 10, 120, 40, "top")
    Widgets(Hex(7)) = Button(width-130, 10, 120, 40, "top&right") 
    
    Widgets(Hex(1)) = Button(10, (height-40)/2, 120, 40, "left") 
    Widgets(Hex(3)) = Button(width-130, (height-40)/2, 120, 40, "right")
    
    Widgets(Hex(8)) = Button(10, height-50, 120, 40, "left&bottom")
    Widgets(Hex(4)) = Button((width-120)/2, height-50, 120, 40, "bottom")
    Widgets(Hex(9)) = Button(width-130, height-50, 120, 40, "bottom&right")
    Widgets(Hex(5)) = Button((width-120)/2, (height-40)/2, 120, 40, "center")
    
    ;\\ example - 2
    _SetAlignment( Widgets(Hex(6)), 0, 1                    ,1,#__align_proportional,#__align_proportional )
    _SetAlignment( Widgets(Hex(2)), 0, 0                    ,1,0                    ,#__align_proportional )
    _SetAlignment( Widgets(Hex(7)), 0, #__align_proportional,1,1                    ,#__align_proportional )
    
    _SetAlignment( Widgets(Hex(1)), 0, 1                    ,0,#__align_proportional,0 )
    _SetAlignment( Widgets(Hex(5)), #__align_center ) ;#__align_proportional,#__align_proportional,#__align_proportional,#__align_proportional )
    _SetAlignment( Widgets(Hex(3)), 0, #__align_proportional,0,1                    ,0 )
    
    _SetAlignment( Widgets(Hex(8)), 0, 1                    ,#__align_proportional,#__align_proportional,1 )
    _SetAlignment( Widgets(Hex(4)), 0, 0                    ,#__align_proportional,0                    ,1 )
    _SetAlignment( Widgets(Hex(9)), 0, #__align_proportional,#__align_proportional,1                    ,1 )

      ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 690,490)
  EndProcedure
  
  example_1()
  example_6()
  
  
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


CompilerIf #PB_Compiler_IsMainFile = 99
  EnableExplicit
  Uselib(widget)
  
  Enumeration 
    #tree_item_default
    #tree_item_multiline
    #tree_item_text
    #tree_item_top
    #tree_item_left
    #tree_item_center
    #tree_item_right
    #tree_item_bottom
    #tree_item_toggle
    #tree_item_vertical
    #tree_item_invert
  EndEnumeration
  
  Procedure.s get_text(m.s = #LF$)
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
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  ; cr = "" : text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  text.s = get_text( )
  Global *this._s_widget, *this_container._s_widget,
         tree,
         gadget,
         Button_type,
         button_default,
         button_multiline,
         button_left,
         button_right,
         button_toggle,
         button_top,
         button_bottom,
         button_center,
         button_vertical,
         button_invert,
         Splitter_0,
         Splitter_1,
         Splitter_2,
         Splitter_3,
         Splitter_4
  
  Define width = 560, height = 560, pos = 60
  
  Procedure events_widgets()
    Protected flag, EventWidget = EventWidget( )
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick
        Select EventWidget
          Case button_default   : flag = #PB_Button_Default
          Case button_top,
               button_left,
               button_right,
               button_bottom,
               button_center
            
            
            ;             ; Flag(*this, #PB_Button_Left|#PB_Button_Right|#__text_top|#__text_bottom, 0)
            ;             ;
            If EventWidget <> button_top And EventWidget <> button_left And EventWidget <> button_right
              SetState(button_top,0) 
            EndIf
            If EventWidget <> button_left And EventWidget <> button_top And EventWidget <> button_bottom 
              SetState(button_left,0) 
            EndIf
            If EventWidget <> button_right And EventWidget <> button_top And EventWidget <> button_bottom  
              SetState(button_right,0) 
            EndIf
            If EventWidget <> button_bottom And EventWidget <> button_left And EventWidget <> button_right 
              SetState(button_bottom,0) 
            EndIf
            If EventWidget <> button_center 
              ;  Flag(*this, #__text_center, 0)
              SetState(button_center,0) 
            EndIf
            ;             
            ;             If GetState(button_left) And GetState(button_bottom)
            ;              ; Flag(*this, #PB_Button_Left|#__text_bottom, 1)
            ;             ElseIf GetState(button_right) And GetState(button_bottom)
            ;              ; Flag(*this, #PB_Button_Right|#__text_bottom, 1)
            ;             ElseIf GetState(button_left) And GetState(button_top)
            ;              ; Flag(*this, #PB_Button_Left|#__text_top, 1)
            ;             ElseIf GetState(button_right) And GetState(button_top)
            ;              ; Flag(*this, #PB_Button_Right|#__text_top, 1)
            ;             ElseIf GetState(button_left)
            ;              ; Flag(*this, #PB_Button_Left, 1)
            ;             ElseIf GetState(button_right) 
            ;              ; Flag(*this, #PB_Button_Right, 1)
            ;             ElseIf GetState(button_bottom)
            ;              ; Flag(*this, #__text_bottom, 1)
            ;             ElseIf GetState(button_top)
            ;              ; Flag(*this, #__text_top, 1)
            ;             EndIf
            ;             
            If GetState(button_left)=0 And 
               GetState(button_top)=0 And 
               GetState(button_right)=0 And
               GetState(button_bottom)=0
              SetState(button_center,1) 
              ; Flag(*this, #__text_center, 1)
            EndIf
            
            Protected left = 0, top = 0, right = 0, bottom = 0, center = 0, mode
            ;
            Select EventWidget
              Case button_top       : top = 1   
              Case button_left      : Left = 1
              Case button_right     : right = 1
              Case button_bottom    : bottom = 1
              Case button_center    : center = 1
                mode = #__align_auto
            EndSelect
            
            _SetAlignment(*this, mode, Left, top, right, bottom )
        EndSelect
        
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width + 180, height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    *this_container  = widget::Container(100, 100, 250, 200)
    *this  = widget::Button(100, 100, 250, 200, text, #PB_Button_MultiLine) : Closelist( )
    
    Define y  = 10
    Define bh = 24
    ; flag
    Button_type      = widget::Button(width + 45, y, 100, 26, "gadget", #PB_Button_Toggle)
    button_default   = widget::Button(width + 45, y + bh * 1, 100, 26, "default", #PB_Button_Toggle)
    button_top       = widget::Button(width + 45, y + bh * 3, 100, 26, "top", #PB_Button_Toggle)
    button_left      = widget::Button(width + 45, y + bh * 4, 100, 26, "left", #PB_Button_Toggle)
    button_center    = widget::Button(width + 45, y + bh * 5, 100, 26, "center", #PB_Button_Toggle)
    button_right     = widget::Button(width + 45, y + bh * 6, 100, 26, "right", #PB_Button_Toggle)
    button_bottom    = widget::Button(width + 45, y + bh * 7, 100, 26, "bottom", #PB_Button_Toggle)
    
    ;     ; flag
    ;     tree = widget::Tree(width + 20, y + bh * 11 + 10, 150, height - (y + bh * 11), #__Tree_NoLines | #__Tree_NoButtons | #__tree_OptionBoxes | #__tree_CheckBoxes | #__Tree_threestate)
    ;     AddItem(tree, #tree_item_default, "default")
    ;     AddItem(tree, #tree_item_multiline, "multiline")
    ;     AddItem(tree, #tree_item_text, "text alignment", -1, 0)
    ;     AddItem(tree, #tree_item_top, "top", -1, 1)
    ;     AddItem(tree, #tree_item_left, "left", -1, 1)
    ;     AddItem(tree, #tree_item_center, "center", -1, 1)
    ;     AddItem(tree, #tree_item_right, "right", -1, 1)
    ;     AddItem(tree, #tree_item_bottom, "bottom", -1, 1)
    ;     AddItem(tree, #tree_item_toggle, "toggle")
    ;     AddItem(tree, #tree_item_vertical, "vertical")
    ;     AddItem(tree, #tree_item_invert, "invert")
    
    Bind(#PB_All, @events_widgets())
    
    ;\\ set button toggled state
    SetState(button_center, 1)
    Hide(Button_type, 1)
    
    ;\\
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this_container, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    ;\\
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width - pos - #__splitter_buttonsize)
    SetState(Splitter_2, height - pos - #__splitter_buttonsize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 64P5----------4---
; EnableXP