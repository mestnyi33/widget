XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(GetIndex(this()\widget))+ " - widget event - " +this()\event+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  If Open(0, 0, 0, 430, 560, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ContainerGadget( 0, 10,10,200,100, #PB_Container_BorderLess ) 
    SetGadgetColor(0, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 1, 10,120,200,100, #PB_Container_Flat ) 
    SetGadgetColor(1, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 2, 10,230,200,100, #PB_Container_Single ) 
    SetGadgetColor(2, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 3, 10,340,200,100, #PB_Container_Raised ) 
    SetGadgetColor(3, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    ContainerGadget( 4, 10,450,200,100, #PB_Container_Double ) 
    SetGadgetColor(4, #PB_Gadget_BackColor, $FF95E3F6 )
    CloseGadgetList( )
    
    
    Container( 220,10,200,100, #__flag_BorderLess ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Container( 220,120,200,100, #__flag_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Container( 220,230,200,100, #__flag_Single ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Container( 220,340,200,100, #__flag_Raised ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    Container( 220,450,200,100, #__flag_Double ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    CloseList( )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 14
; Folding = -
; EnableXP