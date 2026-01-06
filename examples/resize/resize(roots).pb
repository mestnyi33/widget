IncludePath "../../"
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
        Debug ""+ GetClass(eventobject) + " #__event_ResizeBegin " 
        
      Case #__event_Resize
        Debug ""+GetClass(eventobject) + " #__event_Resize " 
        
      Case #__event_ResizeEnd
        Debug ""+GetClass(eventobject) + " #__event_ResizeEnd " 
    EndSelect
  EndProcedure
  
  
 ; OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu|#PB_Window_SizeGadget )
  Define *root._S_widget = Open(#window_0,0,0,424, 352, "AnchorsGadget", #PB_Window_SystemMenu|#PB_Window_SizeGadget): *root\class = "root": SetText(*root, "root")
  ;Bind( *root, @HandlerEvents( ) )
  
;   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered|#PB_Window_SizeGadget)
   Define *root0._S_widget = Open(#window,10,10,300-20,300-20): *root0\class = "root0": SetText(*root0, "root0")
;   ;Bind( *root0, @HandlerEvents( ) )
;   
;   Define *root1._S_widget = Open(#window,300,10,300-20,300-20): *root1\class = "root1": SetText(*root1, "root1")
;   ;Bind( *root1, @HandlerEvents( ) )
;   
;   Define *root2._S_widget = Open(#window,10,300,300-20,300-20): *root2\class = "root2": SetText(*root2, "root2")
;   ;Bind( *root2, @HandlerEvents( ) )
;   
;   Define *root3._S_widget = Open(#window,300,300,300-20,300-20): *root3\class = "root3": SetText(*root3, "root3")
;   ;Bind( *root3, @HandlerEvents( ) )
;   
;   Define *root4._S_widget = Open(#window, 590, 10, 200, 600-20): *root4\class = "root4": SetText(*root4, "root4")
;   ;Bind( *root4, @HandlerEvents( ) )
;   SetAlign(*root4, 0, 0,1,1,1)
  Debug " --- wait --- "
  WaitClose( @HandlerEvents( ) )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; Folding = -
; EnableXP