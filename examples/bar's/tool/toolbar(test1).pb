﻿;                                                       - PB
;                                                       - ToolBarID( #ToolBar )
;                                                       - IsToolBar( #ToolBar )
;
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                                 BarHeight( *address ) - ToolBarHeight( #ToolBar )
;
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                            BarSeparator( [*address] ) - ToolBarSeparator( )
;             DisableBarButton( *address, item, state ) - DisableBarButton( #ToolBar, Button, State )
;                   GetBarButtonState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;            SetBarButtonState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;               BarButtonText( *address, item, text.s ) - BarButtonText( #ToolBar, Button, Text$ )
;              BarButton( button, image, mode, text.s ) - ToolBarImageButton( #Button, ImageID [, Mode [, Text$]] )
;               BarButton( button, icon, mode, text.s ) - ToolBarStandardButton( #Button, #ButtonIcon [, Mode [, Text$]] )
;                BarToolTip( *address, button, text.s ) - ToolBarToolTip( #ToolBar, Button, Text$ )


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
         ToolBarImageButton(10, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
         ToolBarImageButton(1, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
         ToolBarImageButton(2, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
         
         ToolBarSeparator()
         
         ToolBarImageButton(5, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
         ToolBarToolTip(0, 5, "Paste")
         
         ToolBarImageButton(4, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
         ToolBarToolTip(0, 4, "Copy")
         
         ToolBarImageButton(3, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
         ToolBarToolTip(0, 3, "Cut")
         
         ToolBarSeparator()
         
         ToolBarImageButton(6, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
         ToolBarToolTip(0, 6, "Find a document")
      EndIf
      
      DisableBarButton(0, 2, 1) ; Disable the button '2'
      BindEvent( #PB_Event_Menu, @PB_ToolBarEvents( ))
   EndIf
   
   If Open( 0, 0, ToolBarHeight( 0 ), 520, 380 )
   ;If Open( 1, 550, 200, 500, 380, "ToolBar example");, #PB_Window_BorderLess ) ;      a_init(root( ))
      Window( 10, 10, 420, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_NoActivate )
      
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
         BarButton(10, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New") ;: Debug widget( )\class
         BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
         BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
         BarSeparator( )
         
         
         OpenSubBar("3Menu")
         BarItem(31, "3Open")
         BarItem(32, "3Save")
         BarItem(33, "3Save as...")
         BarSeparator( )
         BarItem(34, "3Quit")
         CloseSubBar( )
         
         
         BarSeparator( )
         BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
         ; ToolTip(*toolbar, 5, "Paste")
         
;          BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
;          ; ToolTip(*toolbar, 4, "Copy")
;          
;          BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
;          ; ToolTip(*toolbar, 3, "Cut")
         
         BarSeparator( )
         
         BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
         ; ToolTip(*toolbar, 6, "Find a document")
      EndIf
      
      DisableBarButton(*toolbar, 2, 1) ; Disable the button '2'
      Bind( *toolbar, @ToolBarEvents( ) )
      
          ;SetState(*toolbar, 12 )
            Button( 10,10, 50,150,"" )
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
; CursorPosition = 75
; FirstLine = 47
; Folding = --
; EnableXP
; DPIAware