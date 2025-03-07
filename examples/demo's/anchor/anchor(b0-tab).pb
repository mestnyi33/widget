XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  Global alpha = 192
  
  Procedure CreateContainer( Type, X,Y,Width,Height,Text.s, parent=0 )
    ;
    If Type = #PB_GadgetType_Container
      Container(X,Y,Width,Height)
    ElseIf Type = #__Type_Window
      Window(X,Y,Width,Height, "", #PB_Window_SystemMenu, parent)
    ElseIf Type = #PB_GadgetType_ScrollArea
      ScrollArea(X,Y,Width,Height, 500,500,1)
    ElseIf Type = #PB_GadgetType_Panel
      Panel(X,Y,Width,Height)
      AddItem(widget(), -1, "1Layer = "+Text.s)
      AddItem(widget(), -1, "2Layer = "+Text.s)
      SetState(widget(),1)
    ElseIf Type = #PB_GadgetType_MDI
      AddItem(widget(), -1, "", -1);, #PB_Window_BorderLess)
      Resize(widget(), X,Y,Width,Height)
    EndIf
    
    SetText(widget(), "Layer = " +Text )
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(206, 156, 232, alpha))
    SetColor(widget(), #__FrameColor, RGB(128, 64, 192))
    
    Container(20, 20, 200, 100, #__flag_nogadgets) 
    SetText(widget(), "Layer = " +Text+ "-1")
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(64, 128, 192, alpha))
    SetColor(widget(), #__FrameColor, RGB(64, 128, 192))
    
    Container(50, 50, 200, 100);, #__flag_nogadgets)
    SetText(widget(), "Layer = " +Text+ "-2")
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(192, 64, 128, alpha))
    SetColor(widget(), #__FrameColor, RGBA(192, 64, 128, 255))
    Button(10, 10, 50, 30, "1") 
    Button(70, 10, 50, 30, "2") 
    Button(130, 10, 50, 30, "3") 
    CloseList( )
    
    ;Container(80, 80, 200, 100, #__flag_nogadgets) 
    Button(80, 80, 200, 100, "") 
    SetText(widget(), "Layer = " +Text+ "-3")
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(128, 192, 64, alpha))
    SetColor(widget(), #__FrameColor, RGB(128, 192, 64))
    
    Container(110, 110, 200, 100, #__flag_nogadgets)
    SetText(widget(), "Layer = " +Text+ "-4")
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(192, 128, 64, alpha))
    SetColor(widget(), #__FrameColor, RGBA(192, 128, 64, 255))
    
    Container(140, 140, 200, 100, #__flag_nogadgets) 
    SetText(widget(), "Layer = " +Text+ "-5")
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(128, 64, 192, alpha))
    SetColor(widget(), #__FrameColor, RGB(128, 64, 192))
    
  EndProcedure
  
  If Open(0, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;;a_init(root(), 4) ; , 0)
    
    MDI(50, 50, 800-100, 450-100) 
    a_init(widget(), 4) ; , 0)
    SetColor(widget(), #PB_Gadget_BackColor, RGBA(230, 227, 120, alpha))
    
    CreateContainer( #PB_GadgetType_MDI, 50, 50, 590, 350, "1" )
    
    ;CreateContainer( #PB_GadgetType_Window, 50, 50, 590, 350, "1", widget( )\window)
    ;CreateContainer( #PB_GadgetType_Container, 360, 20, 300, 220, "1-6" )
    CreateContainer( #PB_GadgetType_ScrollArea, 360, 20, 300, 220, "1-6" )
    ;CreateContainer( #PB_GadgetType_Panel, 360, 20, 300, 220, "1-6" )
    ;CloseList( )
    
    
    ;   ContainerGadget( -1, 20, 20, 200, 100, #PB_Container_Flat )
    ;   CloseGadgetList()
    
    
    ;SetActiveGadget( GetCanvasGadget( Root( ) ) )
    
     WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 27
; Folding = -
; EnableXP
; DPIAware