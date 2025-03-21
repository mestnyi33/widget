
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Declare CallBack( )
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_0_root_container" )
   Button(10,10,200,50,"window_0_root_butt_1")
   SetClass(widget( ), "window_0_root_butt_1" )
   Button(10,65,200,50,"window_0_root_butt_2")
   SetClass(widget( ), "window_0_root_butt_2" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_1_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_1_root_container" )
   Button(10,10,200,50,"window_1_root_butt_1")
   SetClass(widget( ), "window_1_root_butt_1" )
   Button(10,65,200,50,"window_1_root_butt_2")
   SetClass(widget( ), "window_1_root_butt_2" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_2_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_2_root_container" )
   Button(10,10,200,50,"window_2_root_butt_1")
   SetClass(widget( ), "window_2_root_butt_1" )
   Button(10,65,200,50,"window_2_root_butt_2")
   SetClass(widget( ), "window_2_root_butt_2" )
   
   
;    ;Message( "message", "test", #__message_ScreenCentered )
;             
;    ;\\
;    WaitEvent( #PB_All, @CallBack( ) )
;    \
   
   ;\\
  Bind( #PB_All, @CallBack( ) )
  ; Message( "message", "test", #__message_ScreenCentered )
  
  ;\\
  ;WaitQuit( )
  WaitClose( )
  
  ;
   ;\\
   Procedure CallBack( )
     If WidgetEvent( ) <> #__event_draw
       Debug ""+RemoveString(ClassFromEvent(WidgetEvent( )), "#__event_") +" - " + EventWidget( )\class +" - ("+ Bool(root( ) = EventWidget( )\root) +")";+" "+ WidgetEvent( )
     EndIf
   EndProcedure
 CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 62
; FirstLine = 30
; Folding = -
; EnableXP