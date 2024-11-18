IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile 
  
  EnableExplicit
  UseWidgets( )
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  
  ; Shows using of several panels...
  Procedure HandlerEvents( )
    Protected eventobject = EventWidget( )
    Protected eventtype = WidgetEvent( )
    
    Select eventtype
      Case #__event_ResizeBegin
        Debug ""+ GetWidgetClass(eventobject) + " #__event_ResizeBegin " 
        
      Case #__event_Resize
        Debug ""+GetWidgetClass(eventobject) + " #__event_Resize " 
        
      Case #__event_ResizeEnd
        Debug ""+GetWidgetClass(eventobject) + " #__event_ResizeEnd " 
    EndSelect
  EndProcedure
  
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  Define *root._S_widget = OpenRoot(#window_0,0,0,424, 352): *root\class = "root": SetWidgetText(*root, "root")
  ;BindWidgetEvent( *root, @HandlerEvents( ) )
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Define *root0._S_widget = OpenRoot(#window,10,10,300-20,300-20): *root0\class = "root0": SetWidgetText(*root0, "root0")
  ;BindWidgetEvent( *root0, @HandlerEvents( ) )
  
  Define *root1._S_widget = OpenRoot(#window,300,10,300-20,300-20): *root1\class = "root1": SetWidgetText(*root1, "root1")
  ;BindWidgetEvent( *root1, @HandlerEvents( ) )
  
  Define *root2._S_widget = OpenRoot(#window,10,300,300-20,300-20): *root2\class = "root2": SetWidgetText(*root2, "root2")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  
  Define *root3._S_widget = OpenRoot(#window,300,300,300-20,300-20): *root3\class = "root3": SetWidgetText(*root3, "root3")
  ;BindWidgetEvent( *root3, @HandlerEvents( ) )
  
  Define *root4._S_widget = OpenRoot(#window, 590, 10, 200, 600-20): *root4\class = "root4": SetWidgetText(*root4, "root4")
  ;BindWidgetEvent( *root4, @HandlerEvents( ) )
  
  BindWidgetEvent( #PB_All, @HandlerEvents( ) )
  
  WaitCloseRoot( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 20
; Folding = -
; EnableXP