IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *test, *bind, *unbind
   Global binded
   
   Procedure events_1()
      Debug " "+Str(GetIndex( EventWidget( ) ))+ " - 1event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   Procedure events_2()
      Debug " "+Str(GetIndex( EventWidget( ) ))+ " - 2event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   
   Procedure events_BindWidgetEvent()
      If binded = 0
         binded = 1
         ClearDebugOutput()
         Debug "binded"
         ; post this events
         BindWidgetEvent(*test, @events_1(), #__event_MouseEnter)
         BindWidgetEvent(*test, @events_2(), #__event_MouseLeave)
         ;
         BindWidgetEvent(*test, @events_1(), #__event_LeftDown)
         BindWidgetEvent(*test, @events_2(), #__event_LeftDown)
         
         BindWidgetEvent(*test, @events_1(), #__event_LeftUp, 1)
         BindWidgetEvent(*test, @events_2(), #__event_LeftUp, 2)
         
         Disable( *unbind, 0 )
         Disable( *bind, 1 )
      EndIf
   EndProcedure
   
   Procedure events_UnBindWidgetEvent()
      If binded = 1
         binded = 0
         ClearDebugOutput()
         Debug "unbinded" 
         ; post this events
         UnBindWidgetEvent(*test, @events_1(), #__event_MouseEnter)
         UnBindWidgetEvent(*test, @events_2(), #__event_MouseLeave)
         ;
         UnBindWidgetEvent(*test, @events_1(), #__event_LeftDown)
         UnBindWidgetEvent(*test, @events_2(), #__event_LeftDown)
         
         UnBindWidgetEvent(*test, @events_1(), #__event_LeftUp, 1)
         UnBindWidgetEvent(*test, @events_2(), #__event_LeftUp, 2)
         
         
         Disable( *bind, 0 )
         Disable( *unbind, 1 )
         
      EndIf
   EndProcedure
   
   
   If OpenWindow(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If OpenRoot(0, 100, 100, 300, 280)
         *test = TreeWidget(10,  10, 280, 170)
         Define i
         For i = 0 To 12
            AddItem( *test, -1, "item-"+Str(i) )
         Next i
         ;
         *bind = ButtonWidget(10, 190, 135, 80, "Bind (events)")
         *unbind = ButtonWidget(155, 190, 135, 80, "Unbind (events)")
         Disable( *unbind, 1 )
         
         BindWidgetEvent(*unbind, @events_UnBindWidgetEvent(), #__event_LeftClick)
         BindWidgetEvent(*bind, @events_BindWidgetEvent(), #__event_LeftClick)
      EndIf
      
      WaitCloseRoot( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 73
; FirstLine = 51
; Folding = --
; EnableXP
; DPIAware