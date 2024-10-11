IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_roots( )
    If WidgetEventType( ) <> #__event_MouseMove
      Debug "  "+ IDWidget(EventWidget()) +" - widget event - "+ WidgetEventType() +" item - "+ WidgetEventItem() ;;+ " event - " + WidgetEventType()
    EndIf
  EndProcedure
  
  Procedure Window_0( )
    If Open(OpenWindow(#PB_Any, 0, 0, 480, 180, "Demo binded events for the test-button", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
      
      Define *butt0 = Button(50, 50, 280, 35, "test-button-events") 
      Bind( *butt0, @events_roots( ) )
      
      Define *butt = Button(50, 50+45, 280, 35, "test-button-events") 
      Bind( *butt, @events_roots( ), #__event_Change )
      ;Bind( *butt, @events_roots( ), #__event_CloseItem )
      Bind( *butt, @events_roots( ), #__event_Down )
      Bind( *butt, @events_roots( ), #__event_DragStart )
      Bind( *butt, @events_roots( ), #__event_Focus )
      Bind( *butt, @events_roots( ), #__event_Input )
      Bind( *butt, @events_roots( ), #__event_KeyDown )
      Bind( *butt, @events_roots( ), #__event_KeyUp )
      Bind( *butt, @events_roots( ), #__event_LeftButtonDown )
      Bind( *butt, @events_roots( ), #__event_LeftButtonUp )
      Bind( *butt, @events_roots( ), #__event_LeftClick )
      Bind( *butt, @events_roots( ), #__event_LeftDoubleClick )
      Bind( *butt, @events_roots( ), #__event_LostFocus )
      Bind( *butt, @events_roots( ), #__event_MiddleDown )
      Bind( *butt, @events_roots( ), #__event_MiddleUp )
      Bind( *butt, @events_roots( ), #__event_MouseEnter )
      Bind( *butt, @events_roots( ), #__event_MouseLeave )
      Bind( *butt, @events_roots( ), #__event_MouseMove )
      Bind( *butt, @events_roots( ), #__event_MouseWheel )
      ;Bind( *butt, @events_roots( ), #__event_PopupMenu )
      ;Bind( *butt, @events_roots( ), #__event_PopupWindow )
      Bind( *butt, @events_roots( ), #__event_Resize )
      Bind( *butt, @events_roots( ), #__event_RightButtonDown )
      Bind( *butt, @events_roots( ), #__event_RightButtonUp )
      Bind( *butt, @events_roots( ), #__event_RightClick )
      Bind( *butt, @events_roots( ), #__event_RightDoubleClick )
      ;Bind( *butt, @events_roots( ), #__event_SizeItem )
      Bind( *butt, @events_roots( ), #__event_StatusChange )
      ;Bind( *butt, @events_roots( ), #__event_TitleChange )
      Bind( *butt, @events_roots( ), #__event_Up )
      
      Define *butt1 = Button(350, 50, 80, 80, "Deactivate")
      
    EndIf
  EndProcedure
  
  Window_0( )
  
  Repeat
    gEvent = WaitWindowEvent( )
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit = #True
        
        ;       Case #PB_Event_Gadget;Widget
        ;         Debug ""+gettext(EventWidget( )) +" "+ WidgetEvent( ) ;+" "+ *Value\This +" "+ *Value\event
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
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 9
; Folding = --
; EnableXP
; DPIAware