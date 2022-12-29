XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseLib(Widget)
  Global alpha = 192
  
  Procedure CreateContainer( type, x,y,width,height,text.s, parent=0 )
    ;
    If type = #PB_GadgetType_Container
      Container(x,y,width,height)
    ElseIf type = #__Type_Window
      Window(x,y,width,height, "", parent)
    ElseIf type = #PB_GadgetType_ScrollArea
      ScrollArea(x,y,width,height, 500,500,1)
    ElseIf type = #PB_GadgetType_Panel
      Panel(x,y,width,height)
      AddItem(widget(), -1, "1Layer = "+text.s)
      AddItem(widget(), -1, "2Layer = "+text.s)
      SetState(widget(),1)
    ElseIf type = #PB_GadgetType_MDI
      AddItem(widget(), -1, "", -1, #PB_Window_BorderLess)
      Resize(widget(), x,y,width,height)
    EndIf
    
    SetText(widget(), "Layer = " +text )
    SetColor(widget(), #__color_back, RGBA(206, 156, 232, alpha))
    SetColor(widget(), #__color_frame, RGB(128, 64, 192))
    
    Container(20, 20, 200, 100, #__flag_nogadgets) 
    SetText(widget(), "Layer = " +text+ "-1")
    SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
    SetColor(widget(), #__color_frame, RGB(64, 128, 192))
    
    Container(50, 50, 200, 100, #__flag_nogadgets)
    SetText(widget(), "Layer = " +text+ "-2")
    SetColor(widget(), #__color_back, RGBA(192, 64, 128, alpha))
    SetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
    
    ;Container(80, 80, 200, 100, #__flag_nogadgets) 
    Button(80, 80, 200, 100, "") 
    SetText(widget(), "Layer = " +text+ "-3")
    SetColor(widget(), #__color_back, RGBA(128, 192, 64, alpha))
    SetColor(widget(), #__color_frame, RGB(128, 192, 64))
    
    Container(110, 110, 200, 100, #__flag_nogadgets)
    SetText(widget(), "Layer = " +text+ "-4")
    SetColor(widget(), #__color_back, RGBA(192, 128, 64, alpha))
    SetColor(widget(), #__color_frame, RGBA(192, 128, 64, 255))
    
    Container(140, 140, 200, 100, #__flag_nogadgets) 
    SetText(widget(), "Layer = " +text+ "-5")
    SetColor(widget(), #__color_back, RGBA(128, 64, 192, alpha))
    SetColor(widget(), #__color_frame, RGB(128, 64, 192))
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    ;;a_init(root(), 4) ; , 0)
    
    MDI(50, 50, 800-100, 450-100) 
    a_init(widget(), 4) ; , 0)
    SetColor(widget(), #__color_back, RGBA(230, 227, 120, alpha))
    
    CreateContainer( #PB_GadgetType_MDI, 50, 50, 590, 350, "1" )
    
    ;CreateContainer( #PB_GadgetType_Window, 50, 50, 590, 350, "1", widget( )\window)
    ;CreateContainer( #PB_GadgetType_Container, 360, 20, 300, 220, "1-6" )
    CreateContainer( #PB_GadgetType_ScrollArea, 360, 20, 300, 220, "1-6" )
    ;CreateContainer( #PB_GadgetType_Panel, 360, 20, 300, 220, "1-6" )
    ;CloseList( )
    
    
    ;   ContainerGadget( -1, 20, 20, 200, 100, #PB_Container_Flat )
    ;   CloseGadgetList()
    
    
    ;SetActiveGadget( GetGadget( Root( ) ) )
    
    ; WaitClose( )
    Define _time_ = 0
    Define _window_ = #PB_Any
    
    
    Define event
    Repeat 
      event = events::WaitEvent( @EventHandler( ), WaitWindowEvent( ) )
      ; event = WaitEvent( WaitWindowEvent( ) )
    Until event = #PB_Event_CloseWindow
    
    If Root( )
      ReDraw( Root( ) )
      ; EndIf  
      
      Repeat 
        Select WaitWindowEvent( _time_ ) 
          Case #PB_Event_Gadget
            If Root( )\canvas\bindevent = #False
              Root( )\repaint = #True
              EventHandler( )
            EndIf
            
          Case #PB_Event_CloseWindow
            If _window_ = #PB_Any 
              If EventWidget( )
                Debug " - close - " + EventWidget( ) ; +" "+ GetWindow( _window_ )
                If EventWidget( )\container = #__type_window
                  ;Else
                  
                  ForEach Root( )
                    Debug Root( )
                    free( Root( ) )
                    ;               ForEach widget( )
                    ;                 Debug ""+widget( )\root +" "+ _is_root_( widget( ) )
                    ;               Next
                  Next
                  Break
                EndIf
              Else
                Debug " - close0 - " + PB(EventWindow)( ) ; +" "+ GetWindow( _window_ )
                Break
              EndIf
              
            ElseIf PB(EventGadget)( ) = _window_
              Debug " - close1 - " + PB(EventWindow)( ) ; +" "+ GetWindow( _window_ )
              Free( _window_ )
              Break
              
            ElseIf PB(EventWindow)( ) = _window_ 
              If Post( #__event_Free, _window_ )
                Debug " - close2 - " + PB(EventWindow)( ) ; +" "+ GetWindow( _window_ )
                Break
              EndIf
            EndIf
            
        EndSelect
      ForEver
      
      ReDraw( Root( ) )
      If IsWindow( PB(EventWindow)( ) )
        Debug "end"
        PB(CloseWindow)( PB(EventWindow)( ) )
        End 
      EndIf
    EndIf  
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP