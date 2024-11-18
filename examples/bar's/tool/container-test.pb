XIncludeFile "../../../widgets.pbi" 
; bug set alpha color in windows

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  If OpenRoot(0, 0, 0, 430, 440, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ContainerGadget( 1, 10,10,200,100, #PB_Container_Flat ) 
    SetGadGetWidgetColor(1, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 2, 10,120,200,100, #PB_Container_Single ) 
    SetGadGetWidgetColor(2, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    SplitterGadget( #PB_Any, 10,10,200,200, 1,2 )
    
    ContainerWidget( 10,10,200,100, #PB_Container_Flat ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 10,120,200,100, #PB_Container_Single ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    SplitterWidget( 220,10,200,200, WidgetID(0), WidgetID(1) )
    
    ;\\
    ContainerGadget( 3, 0,0,0,0, #PB_Container_Flat ) 
    SetGadGetWidgetColor(3, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 4, 0,0,0,0, #PB_Container_Single ) 
    SetGadGetWidgetColor(4, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    SplitterGadget( #PB_Any, 10,230,200,200, 3,4 )
    
    ContainerWidget( 0,0,0,0, #PB_Container_Flat ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ) )
    CloseWidgetList( )
    ContainerWidget( 0,0,0,0, #PB_Container_Single ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ) )
    CloseWidgetList( )
    SplitterWidget( 220,230,200,200, WidgetID(3), WidgetID(4) )
    
    WaitCloseRoot( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 13
; Folding = -
; EnableXP