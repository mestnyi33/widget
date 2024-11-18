IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global.i gEvent, gQuit
  Global *but, *win
  
  Procedure events_roots( )
    If WidgetEvent( ) <> #__event_MouseMove
      Debug "  "+ GetIndex(EventWidget()) +" - widget event - "+ WidgetEvent() +" item - "+ WidgetEventItem() ;;+ " event - " + WidgetEvent()
    EndIf
  EndProcedure
  
  Procedure Window_0( )
    If OpenRoot(OpenWindow(#PB_Any, 0, 0, 480, 180, "Demo binded events for the test-button", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
      
      Define *butt0 = ButtonWidget(50, 50, 280, 35, "test-button-events") 
      BindWidgetEvent( *butt0, @events_roots( ) )
      
      Define *butt = ButtonWidget(50, 50+45, 280, 35, "test-button-events") 
      BindWidgetEvent( *butt, @events_roots( ), #__event_Change )
      ;BindWidgetEvent( *butt, @events_roots( ), #__event_CloseItem )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Down )
      BindWidgetEvent( *butt, @events_roots( ), #__event_DragStart )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Focus )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Input )
      BindWidgetEvent( *butt, @events_roots( ), #__event_KeyDown )
      BindWidgetEvent( *butt, @events_roots( ), #__event_KeyUp )
      BindWidgetEvent( *butt, @events_roots( ), #__event_LeftDown )
      BindWidgetEvent( *butt, @events_roots( ), #__event_LeftUp )
      BindWidgetEvent( *butt, @events_roots( ), #__event_LeftClick )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Left2Click )
      BindWidgetEvent( *butt, @events_roots( ), #__event_LostFocus )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MiddleDown )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MiddleUp )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MouseEnter )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MouseLeave )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MouseMove )
      BindWidgetEvent( *butt, @events_roots( ), #__event_MouseWheel )
      ;BindWidgetEvent( *butt, @events_roots( ), #__event_PopupMenu )
      ;BindWidgetEvent( *butt, @events_roots( ), #__event_PopupWindow )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Resize )
      BindWidgetEvent( *butt, @events_roots( ), #__event_RightDown )
      BindWidgetEvent( *butt, @events_roots( ), #__event_RightUp )
      BindWidgetEvent( *butt, @events_roots( ), #__event_RightClick )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Right2Click )
      ;BindWidgetEvent( *butt, @events_roots( ), #__event_SizeItem )
      BindWidgetEvent( *butt, @events_roots( ), #__event_StatusChange )
      ;BindWidgetEvent( *butt, @events_roots( ), #__event_TitleChange )
      BindWidgetEvent( *butt, @events_roots( ), #__event_Up )
      
      Define *butt1 = ButtonWidget(350, 50, 80, 80, "Deactivate")
      
    EndIf
  EndProcedure
  
  Window_0( )
  
  Repeat
    gEvent = WaitWindowEvent( )
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit = #True
        
        ;       Case #PB_Event_Gadget;Widget
        ;         Debug ""+GetWidgetText(EventWidget( )) +" "+ WidgetEvent( ) ;+" "+ *Value\This +" "+ *Value\event
        ;         
        ;         Select EventWidget( )
        ;           Case *but
        ;             
        ;             Debug *but
        ;             
        ;         EndSelect
        ;         
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 50
; FirstLine = 46
; Folding = --
; EnableXP
; DPIAware