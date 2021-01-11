IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_roots( )
    If this( )\event <> #PB_EventType_MouseMove
      Debug "  "+ GetIndex(this( )\widget) +" - widget event - "+ this( )\event +" item - "+ this( )\item ;;+ " event - " + this( )\event
    EndIf
  EndProcedure
  
  Procedure Window_0( )
    If Open(OpenWindow(#PB_Any, 0, 0, 380, 180, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
      
      Define *butt = Button(50, 50, 280, 80, "post event for one procedure")
      
      Bind( *butt, @events_roots( ), #PB_EventType_Change )
      Bind( *butt, @events_roots( ), #PB_EventType_CloseItem )
      Bind( *butt, @events_roots( ), #PB_EventType_Down )
      Bind( *butt, @events_roots( ), #PB_EventType_DragStart )
      Bind( *butt, @events_roots( ), #PB_EventType_Focus )
      Bind( *butt, @events_roots( ), #PB_EventType_Input )
      Bind( *butt, @events_roots( ), #PB_EventType_KeyDown )
      Bind( *butt, @events_roots( ), #PB_EventType_KeyUp )
      Bind( *butt, @events_roots( ), #PB_EventType_LeftButtonDown )
      Bind( *butt, @events_roots( ), #PB_EventType_LeftButtonUp )
      Bind( *butt, @events_roots( ), #PB_EventType_LeftClick )
      Bind( *butt, @events_roots( ), #PB_EventType_LeftDoubleClick )
      Bind( *butt, @events_roots( ), #PB_EventType_LostFocus )
      Bind( *butt, @events_roots( ), #PB_EventType_MiddleButtonDown )
      Bind( *butt, @events_roots( ), #PB_EventType_MiddleButtonUp )
      Bind( *butt, @events_roots( ), #PB_EventType_MouseEnter )
      Bind( *butt, @events_roots( ), #PB_EventType_MouseLeave )
      Bind( *butt, @events_roots( ), #PB_EventType_MouseMove )
      Bind( *butt, @events_roots( ), #PB_EventType_MouseWheel )
      Bind( *butt, @events_roots( ), #PB_EventType_PopupMenu )
      Bind( *butt, @events_roots( ), #PB_EventType_PopupWindow )
      Bind( *butt, @events_roots( ), #PB_EventType_Resize )
      Bind( *butt, @events_roots( ), #PB_EventType_RightButtonDown )
      Bind( *butt, @events_roots( ), #PB_EventType_RightButtonUp )
      Bind( *butt, @events_roots( ), #PB_EventType_RightClick )
      Bind( *butt, @events_roots( ), #PB_EventType_RightDoubleClick )
      Bind( *butt, @events_roots( ), #PB_EventType_SizeItem )
      Bind( *butt, @events_roots( ), #PB_EventType_StatusChange )
      Bind( *butt, @events_roots( ), #PB_EventType_TitleChange )
      Bind( *butt, @events_roots( ), #PB_EventType_Up )
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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP