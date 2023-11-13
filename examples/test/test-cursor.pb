XIncludeFile "../../widgets.pbi"
;bug когда с левого якорья переходит на сам сплиттер 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global *object._s_widget
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root( ), 4)
   
   ;\\
   String(20, 20, 150, 150, "String")
   Button(170, 170, 150, 150, "Button")
   HyperLink(20, 320, 150, 150, "HyperLink", $ffFF0000, #PB_HyperLink_Underline)
   Splitter(320, 320, 150, 150, String(0,0,0,0,"String"), Splitter(0,0,0,0, #PB_Default, Button(0,0,0,0, "Button") ), #PB_Splitter_Vertical ) 
   
   ;\\
   ForEach widget( )
      *object = widget( )
      If *object <> root( )
         ;\\ для всех виджетов
         Bind( *object, @CustomEvents( ), #__event_cursorchange )
         
         ;\\ исключаем некоторые виджеты
         If *object\child
            Continue
         EndIf
         If *object\parent
            If *object\parent\type = #__type_splitter
               Continue
            EndIf
         EndIf
         
         ;\\ оставщиеся виджеты после исключеныя
         a_set( *object, #__a_full, 30 )
         Bind( *object, @CustomEvents( ), #__event_statuschange )
         Bind( *object, @CustomEvents( ), #__event_resize )
      EndIf
   Next
   
   ;\\
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEventType( )
            
         Case #__event_cursorchange
            ;Debug ""+ WidgetEvent( )\widget\class +" event( CURSOR ) "+ WidgetEvent( )\data +" "+ WidgetEvent( )\item
            
         Case #__event_statuschange
             ;Debug ""+ WidgetEvent( )\widget\class +" event( STATUS ) "+ WidgetEvent( )\data +" "+ WidgetEvent( )\item
            
         Case #__event_resize
            ;Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 25
; FirstLine = 11
; Folding = --
; EnableXP