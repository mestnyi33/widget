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
      Window(x,y,width,height, "", #PB_Window_SystemMenu, parent)
    ElseIf type = #PB_GadgetType_ScrollArea
      ScrollArea(x,y,width,height, 500,500,1)
    ElseIf type = #PB_GadgetType_Panel
      Panel(x,y,width,height)
      AddItem(widget(), -1, "1Layer = "+text.s)
      AddItem(widget(), -1, "2Layer = "+text.s)
      SetState(widget(),1)
    ElseIf type = #PB_GadgetType_MDI
      AddItem(widget(), -1, "", -1);, #PB_Window_BorderLess)
      Resize(widget(), x,y,width,height)
    EndIf
    
    SetText(widget(), "Layer = " +text )
    SetColor(widget(), #__color_back, RGBA(206, 156, 232, alpha))
    SetColor(widget(), #__color_frame, RGB(128, 64, 192))
    
    Container(20, 20, 200, 100, #__flag_nogadgets) 
    SetText(widget(), "Layer = " +text+ "-1")
    SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
    SetColor(widget(), #__color_frame, RGB(64, 128, 192))
    
    Container(50, 50, 200, 100);, #__flag_nogadgets)
    SetText(widget(), "Layer = " +text+ "-2")
    SetColor(widget(), #__color_back, RGBA(192, 64, 128, alpha))
    SetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
    Button(10, 10, 50, 30, "1") 
    Button(70, 10, 50, 30, "2") 
    Button(130, 10, 50, 30, "3") 
    CloseList( )
    
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
    
     WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP