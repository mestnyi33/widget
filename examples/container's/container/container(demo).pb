XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(IDWidget(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  If OpenRootWidget(0, 0, 0, 640, 560, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ContainerGadget( 0, 10,10,200,100, #PB_Container_BorderLess ) 
    SetGadGetWidgetColor(0, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 1, 10,120,200,100, #PB_Container_Flat ) 
    SetGadGetWidgetColor(1, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 2, 10,230,200,100, #PB_Container_Single ) 
    SetGadGetWidgetColor(2, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 3, 10,340,200,100, #PB_Container_Double ) 
    SetGadGetWidgetColor(3, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 4, 10,450,200,100, #PB_Container_Raised ) 
    SetGadGetWidgetColor(4, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    
    ContainerWidget( 220,10,200,100, #PB_Container_BorderLess ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 220,120,200,100, #PB_Container_Flat ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 220,230,200,100, #PB_Container_Single ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 220,340,200,100, #PB_Container_Double ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 220,450,200,100, #PB_Container_Raised ) 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    
       
    ContainerWidget( 430,10,200,100, #__flag_BorderLess ) : widget( )\round = 20
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 430,120,200,100, #__flag_BorderFlat ) : widget( )\round = 20 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 430,230,200,100, #__flag_BorderSingle ) : widget( )\round = 20 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 430,340,200,100, #__flag_BorderDouble ) : widget( )\round = 20 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    ContainerWidget( 430,450,200,100, #__flag_BorderRaised ) : widget( )\round = 20 
    SetWidgetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseWidgetList( )
    
    
    
    WaitCloseRootWidget( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = -
; Optimizer
; EnableXP
; DPIAware