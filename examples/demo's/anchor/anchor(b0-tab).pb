XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  Global alpha = 192
  
  Procedure CreateContainerWidget( type, x,y,width,height,text.s, parent=0 )
    ;
    If type = #PB_GadgetType_Container
      ContainerWidget(x,y,width,height)
    ElseIf type = #PB_WidgetType_Window
      Window(x,y,width,height, "", #PB_Window_SystemMenu, parent)
    ElseIf type = #PB_GadgetType_ScrollArea
      ScrollAreaWidget(x,y,width,height, 500,500,1)
    ElseIf type = #PB_GadgetType_Panel
      PanelWidget(x,y,width,height)
      AddItem(widget(), -1, "1Layer = "+text.s)
      AddItem(widget(), -1, "2Layer = "+text.s)
      SetState(widget(),1)
    ElseIf type = #PB_GadgetType_MDI
      AddItem(widget(), -1, "", -1);, #PB_Window_BorderLess)
      ResizeWidget(widget(), x,y,width,height)
    EndIf
    
    SetTextWidget(widget(), "Layer = " +text )
    SetWidgetColor(widget(), #__color_back, RGBA(206, 156, 232, alpha))
    SetWidgetColor(widget(), #__color_frame, RGB(128, 64, 192))
    
    ContainerWidget(20, 20, 200, 100, #__flag_nogadgets) 
    SetTextWidget(widget(), "Layer = " +text+ "-1")
    SetWidgetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
    SetWidgetColor(widget(), #__color_frame, RGB(64, 128, 192))
    
    ContainerWidget(50, 50, 200, 100);, #__flag_nogadgets)
    SetTextWidget(widget(), "Layer = " +text+ "-2")
    SetWidgetColor(widget(), #__color_back, RGBA(192, 64, 128, alpha))
    SetWidgetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
    ButtonWidget(10, 10, 50, 30, "1") 
    ButtonWidget(70, 10, 50, 30, "2") 
    ButtonWidget(130, 10, 50, 30, "3") 
    CloseList( )
    
    ;ContainerWidget(80, 80, 200, 100, #__flag_nogadgets) 
    ButtonWidget(80, 80, 200, 100, "") 
    SetTextWidget(widget(), "Layer = " +text+ "-3")
    SetWidgetColor(widget(), #__color_back, RGBA(128, 192, 64, alpha))
    SetWidgetColor(widget(), #__color_frame, RGB(128, 192, 64))
    
    ContainerWidget(110, 110, 200, 100, #__flag_nogadgets)
    SetTextWidget(widget(), "Layer = " +text+ "-4")
    SetWidgetColor(widget(), #__color_back, RGBA(192, 128, 64, alpha))
    SetWidgetColor(widget(), #__color_frame, RGBA(192, 128, 64, 255))
    
    ContainerWidget(140, 140, 200, 100, #__flag_nogadgets) 
    SetTextWidget(widget(), "Layer = " +text+ "-5")
    SetWidgetColor(widget(), #__color_back, RGBA(128, 64, 192, alpha))
    SetWidgetColor(widget(), #__color_frame, RGB(128, 64, 192))
    
  EndProcedure
  
  If Open(0, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;;a_init(root(), 4) ; , 0)
    
    MDIWidget(50, 50, 800-100, 450-100) 
    a_init(widget(), 4) ; , 0)
    SetWidgetColor(widget(), #__color_back, RGBA(230, 227, 120, alpha))
    
    CreateContainerWidget( #PB_GadgetType_MDI, 50, 50, 590, 350, "1" )
    
    ;CreateContainerWidget( #PB_GadgetType_Window, 50, 50, 590, 350, "1", widget( )\window)
    ;CreateContainerWidget( #PB_GadgetType_Container, 360, 20, 300, 220, "1-6" )
    CreateContainerWidget( #PB_GadgetType_ScrollArea, 360, 20, 300, 220, "1-6" )
    ;CreateContainerWidget( #PB_GadgetType_Panel, 360, 20, 300, 220, "1-6" )
    ;CloseList( )
    
    
    ;   ContainerGadget( -1, 20, 20, 200, 100, #PB_Container_Flat )
    ;   CloseGadgetList()
    
    
    ;SetActiveGadget( GetCanvasGadget( Root( ) ) )
    
     WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 45
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware