IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_draw_contex = 0
   
   Global i, *test._s_widget
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected *this._s_widget = EventWidget( )
      
      ;\\
      If event = #__event_MouseMove
         If *this\parent
            If is_integral_(*this)
             ;  Debug " -- "+*this\class +" ("+ *this\enter +") ("+ *this\parent\enter +") " + WidgetEventData( )
            EndIf
         EndIf
      EndIf
      
      If event = #__event_MouseEnter
         If *this\parent
            Debug " -enter- "+*this\class +" ("+ *this\enter +") ("+ *this\parent\enter +") " + WidgetEventData( )
         EndIf
      EndIf
      
      ;\\
      If event = #__event_MouseLeave
         If *this\parent
            Debug " -leave- "+*this\class +" ("+ *this\enter +") ("+ *this\parent\enter +") " + WidgetEventData( )
         EndIf
      EndIf
   EndProcedure
   
   If OpenWindow(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 10,10, 480, 480)
         a_init( root( ) )
         Bind(#PB_All, @EventsHandler( ))
         Window(80, 100, 300, 280, "Window_2")
         ; Bind(widget(), @EventsHandler( ))
        
         ;\\
         *test = Tree(10, 10, 135, 80)
         SetFrame(*test, 0)
         ;a_set( *test, #__a_full, 12 )
         For i = 0 To 6
            AddItem( *test, -1, "item-"+Str(i) )
         Next i
;          For i = 0 To 2;6
;             AddItem( *test, -1, "1234567890ssssssssssssssssyuuyfythjgjyftd-item-"+Str(i) )
;          Next i
         *test = Splitter(10+145, 10, 135, 80, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
   
         ;\\
         ; *test = Splitter( 10, 100, 280, 80, Button( 0,0,0,0,"1"),Button( 0,0,0,0,"2") )
         *test = ScrollArea(10, 100, 135, 80, 200,200,1, #__flag_border_flat|#__flag_noGadgets)
         SetBackColor(*test, $FE9CA784)
         SetFrame(*test, 10)
         *test = ScrollArea(10+145, 100, 135, 80, 200,200,1, #__flag_border_less|#__flag_noGadgets)
         SetBackColor(*test, $FFAC86DB)
         SetFrame(*test, 0)
         
         ;\\
         *test = Button( 10, 190, 135, 80, "")
         *test = Panel( 10+145, 190, 135, 80)
         For i = 0 To 6
            AddItem( *test, -1, "tab-"+Str(i) )
         Next i
         
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 43
; FirstLine = 4
; Folding = --
; EnableXP
; DPIAware