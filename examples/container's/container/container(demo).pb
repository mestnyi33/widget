XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(Index(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  If Open(0, 0, 0, 640, 560, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ContainerGadget( 0, 10,10,200,100, #PB_Container_BorderLess ) 
    SetGadgetColor(0, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 1, 10,120,200,100, #PB_Container_Flat ) 
    SetGadgetColor(1, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 2, 10,230,200,100, #PB_Container_Single ) 
    SetGadgetColor(2, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 3, 10,340,200,100, #PB_Container_Double ) 
    SetGadgetColor(3, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 4, 10,450,200,100, #PB_Container_Raised ) 
    SetGadgetColor(4, #PB_Gadget_BackColor, $95E3F6 )
    CloseGadgetList( )
    
    Container( 220,10,200,100, #PB_Container_BorderLess ) 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 220,120,200,100 );, #PB_Container_Flat ) 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 220,230,200,100, #PB_Container_Single ) 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 220,340,200,100, #PB_Container_Double ) 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 220,450,200,100, #PB_Container_Raised ) 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    
       
    Container( 430,10,200,100, #__flag_BorderLess ) : Widget( )\round = 20
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 430,120,200,100, #__flag_BorderFlat ) : Widget( )\round = 20 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 430,230,200,100, #__flag_BorderSingle ) : Widget( )\round = 20 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 430,340,200,100, #__flag_BorderDouble ) : Widget( )\round = 20 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    Container( 430,450,200,100, #__flag_BorderRaised ) : Widget( )\round = 20 
    SetColor( Widget( ), #PB_Gadget_BackColor, $FF95E3F6 )
    CloseList( )
    
    
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 62
; FirstLine = 27
; Folding = -
; Optimizer
; EnableXP
; DPIAware