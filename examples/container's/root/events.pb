
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Declare CallBack( )
   
   ;\\
   OpenRoot(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetWidgetClass(Root( ), "window_0_root" )
   ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_0_root_container" )
   ButtonWidget(10,10,200,50,"window_0_root_butt_1")
   SetWidgetClass(widget( ), "window_0_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_0_root_butt_2")
   SetWidgetClass(widget( ), "window_0_root_butt_2" )
   
   ;\\
   OpenRoot(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetWidgetClass(Root( ), "window_1_root" )
   ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_1_root_container" )
   ButtonWidget(10,10,200,50,"window_1_root_butt_1")
   SetWidgetClass(widget( ), "window_1_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_1_root_butt_2")
   SetWidgetClass(widget( ), "window_1_root_butt_2" )
   
   ;\\
   OpenRoot(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetWidgetClass(Root( ), "window_2_root" )
   ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_2_root_container" )
   ButtonWidget(10,10,200,50,"window_2_root_butt_1")
   SetWidgetClass(widget( ), "window_2_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_2_root_butt_2")
   SetWidgetClass(widget( ), "window_2_root_butt_2" )
   
   
;    ;Message( "message", "test", #__message_ScreenCentered )
;             
;    ;\\
;    WaitEvent( #PB_All, @CallBack( ) )
;    \
   
   ;\\
  BindWidgetEvent( #PB_All, @CallBack( ) )
  ; MessageWidget( "message", "test", #__message_ScreenCentered )
  
  ;\\
  ;WaitQuit( )
  WaitCloseRoot( )
  
  ;
   ;\\
   Procedure CallBack( )
     If WidgetEvent( ) <> #__event_draw
;        If WidgetEvent( ) = #__event_repaint
;          ProcedureReturn 
;        EndIf
       Debug ""+RemoveStringWidget(ClassFromEvent(WidgetEvent( )), "#__event_") +" - " + EventWidget( )\class +" - ("+ Bool(Root( ) = EventWidget( )\root) +")";+" "+ WidgetEvent( )
     EndIf
   EndProcedure
 CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 71
; FirstLine = 44
; Folding = -
; EnableXP