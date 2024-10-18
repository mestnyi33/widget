IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   test_draw_contex = 0
   
   Global i, *test._s_widget
   
   Procedure HandlerEvents( )
      Protected event = WidgetEvent( ) 
      Protected *this._s_widget = EventWidget( )
      
      ;\\
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
         Bind(#PB_All, @HandlerEvents( ))
         Window(80, 100, 300, 280, "Window_2")
         
         ;\\
         *test = Tree(10, 10, 280, 80)
         setframe(*test, 0)
         ;a_set( *test, #__a_full, 12 )
         For i = 0 To 6
            AddItem( *test, -1, "item-"+Str(i) )
         Next i
;          For i = 0 To 2;6
;             AddItem( *test, -1, "1234567890ssssssssssssssssyuuyfythjgjyftd-item-"+Str(i) )
;          Next i
         
         ;\\
         ; *test = Splitter( 10, 100, 280, 80, Button( 0,0,0,0,"1"),Button( 0,0,0,0,"2") )
         *test = ScrollArea(10, 100, 280, 80, 200,200,1, #__flag_Borderflat|#__flag_noGadgets)
         setframe(*test, 10)
         
         ;\\
         *test = Panel( 10, 190, 280, 80)
         For i = 0 To 6
            AddItem( *test, -1, "tab-"+Str(i) )
         Next i
         
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 8
; Folding = --
; EnableXP
; DPIAware