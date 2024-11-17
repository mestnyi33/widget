;                                                       - PB
;                                                       - ToolBarID( #ToolBar )
;                                                       - IsToolBar( #ToolBar )
;
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                                 BarWidgetHeight( *address ) - ToolBarWidgetHeight( #ToolBar )
;
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                            BarSeparator( [*address] ) - ToolBarSeparator( )
;             DisableBarButtonWidget( *address, item, state ) - DisableBarButtonWidget( #ToolBar, Button, State )
;                   GetBarButtonState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;            SetBarButtonState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;               BarButtonTextWidget( *address, item, text.s ) - BarButtonTextWidget( #ToolBar, Button, Text$ )
;              BarButtonWidget( button, image, mode, text.s ) - ToolBarImageButtonWidget( #Button, ImageID [, Mode [, Text$]] )
;               BarButtonWidget( button, icon, mode, text.s ) - ToolBarStandardButtonWidget( #Button, #ButtonIcon [, Mode [, Text$]] )
;                BarWidgetToolTip( *address, button, text.s ) - ToolBarWidgetToolTip( #ToolBar, Button, Text$ )


XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   UsePNGImageDecoder()
   
   Global *toolbar._s_widget, th=24
   
   Procedure ToolBarEvents( )
      Debug WidgetEventItem( )
   EndProcedure
   
   Procedure PB_ToolBarEvents( )
      Debug EventMenu( )
   EndProcedure
   
   ;SetGadgetFont(#PB_All, LoadFont(1,"Arial", 50))
   
   If OpenWindow(0, 100, 200, 520, 380, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
      
      ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
      ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
      ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large|#PB_ToolBar_Text)
      If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small|#PB_ToolBar_Text)
         ToolBarImageButtonWidget(10, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
         ToolBarImageButtonWidget(1, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
         ToolBarImageButtonWidget(2, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
         
         ToolBarSeparator()
         
         ToolBarImageButtonWidget(5, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
         ToolBarWidgetToolTip(0, 5, "Paste")
         
         ToolBarImageButtonWidget(4, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
         ToolBarWidgetToolTip(0, 4, "Copy")
         
         ToolBarImageButtonWidget(3, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
         ToolBarWidgetToolTip(0, 3, "Cut")
         
         ToolBarSeparator()
         
         ToolBarImageButtonWidget(6, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
         ToolBarWidgetToolTip(0, 6, "Find a document")
      EndIf
      
      DisableBarButtonWidget(0, 2, 1) ; Disable the button '2'
      BindEvent( #PB_Event_Menu, @PB_ToolBarEvents( ))
   EndIf
   
   If Open( 0, 0, ToolBarWidgetHeight( 0 ), 520, 380 )
   ;If Open( 1, 550, 200, 500, 380, "ToolBar example");, #PB_Window_BorderLess ) ;      a_init(root( ))
      Window( 10, 10, 420, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      
      ;*toolbar = ToolBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
      ;*toolbar = ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
      ;*toolbar = ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Text);|#PB_ToolBar_Buttons)
      *toolbar = ToolBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_Text)
      
      If *toolbar
         OpenSubBar("Menu")
           BarItem(11, "Open")
           BarItem(12, "Save")
           ; BarItem(13, "Save as...")
           OpenSubBar("Save as...")
             BarItem(15, "Save as BMP")
             BarItem(16, "Save as PNG")
             BarItem(17, "Save as JPG")
           CloseSubBar( )
           BarSeparator( )
           BarItem(14, "Quit")
         CloseSubBar( )
           
         OpenSubBar("-Menu-")
         CloseSubBar( )
         
         OpenSubBar("2Menu")
           BarItem(21, "2Open")
           BarItem(22, "2Save")
           BarItem(23, "2Save as...")
           BarSeparator( )
           BarItem(24, "2Quit")
         CloseSubBar( )
         
         
         BarSeparator( )
         BarButtonWidget(10, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New") ;: Debug widget( )\class
         BarButtonWidget(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
         BarButtonWidget(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
         BarSeparator( )
         
         
         OpenSubBar("3Menu")
         BarItem(31, "3Open")
         BarItem(32, "3Save")
         BarItem(33, "3Save as...")
         BarSeparator( )
         BarItem(34, "3Quit")
         CloseSubBar( )
         
         
         BarSeparator( )
         BarButtonWidget(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
         ; WidgetToolTip(*toolbar, 5, "Paste")
         
;          BarButtonWidget(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
;          ; WidgetToolTip(*toolbar, 4, "Copy")
;          
;          BarButtonWidget(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
;          ; WidgetToolTip(*toolbar, 3, "Cut")
         
         BarSeparator( )
         
         BarButtonWidget(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
         ; WidgetToolTip(*toolbar, 6, "Find a document")
      EndIf
      
      DisableBarButtonWidget(*toolbar, 2, 1) ; Disable the button '2'
      Bind( *toolbar, @ToolBarEvents( ) )
      
          ;SetState(*toolbar, 12 )
            ButtonWidget( 10,10, 50,150,"" )
           ;  Bind( root( ), #PB_Default )
   EndIf
   
   
   Define Event, Quit
   Repeat
      Event = WaitWindowEvent()
      
      Select Event
            
         Case #PB_Event_Menu
            Debug Str(EventMenu())+" - event item"
            
         Case #PB_Event_CloseWindow  ; If the user has pressed on the close button
            Quit = 1
            
      EndSelect
      
   Until Quit = 1
   
   
   End   ; All resources are automatically freed
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 23
; Folding = --
; EnableXP
; DPIAware