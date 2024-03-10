XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  If Open(0, 0, 0, 430, 440, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ContainerGadget( 1, 10,10,200,100, #PB_Container_Flat ) 
    SetGadgetColor(1, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 2, 10,120,200,100, #PB_Container_Single ) 
    SetGadgetColor(2, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    SplitterGadget( #PB_Any, 10,10,200,200, 1,2 )
    
    Container( 10,10,200,100, #__flag_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Container( 10,120,200,100, #__flag_Single ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Splitter( 220,10,200,200, WidgetID(0),WidgetID(1) )
    
    ;\\
    ContainerGadget( 3, 0,0,0,0, #PB_Container_Flat ) 
    SetGadgetColor(3, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 4, 0,0,0,0, #PB_Container_Single ) 
    SetGadgetColor(4, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    SplitterGadget( #PB_Any, 10,230,200,200, 3,4 )
    
    Container( 0,0,0,0, #__flag_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ) )
    CloseList( )
    Container( 0,0,0,0, #__flag_Single ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Splitter( 220,230,200,200, WidgetID(3),WidgetID(4) )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 33
; FirstLine = 7
; Folding = -
; EnableXP