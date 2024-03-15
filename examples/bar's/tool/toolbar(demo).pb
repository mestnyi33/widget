;                                                       - PB
;                               Separator( [*address] ) - ToolBarSeparator( )
;                                     WidgetID( index ) - ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )

;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableBarButton( #ToolBar, Button, State )
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;                 SetItemText( *address, item, text.s ) - BarButtonText( #ToolBar, Button, Text$ )
;                                    Height( *address ) - ToolBarHeight( #ToolBar )
;      AddItem( *address, button, text.s, image, mode ) - ToolBarImageButton( #Button, ImageID [, Mode [, Text$]] )
;       AddItem( *address, button, text.s, icon, mode ) - ToolBarStandardButton( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemText( *address, item ) - 
;                        GetItemImage( *address, item ) - 
;                 SetItemImage( *address, item, image ) - 

;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  Global *toolbar._s_widget, th=24
  
  Macro DisableBarButton( _address_, _button_, _state_ )
   ; DisableItem( _address_, _button_, _state_ )
  EndMacro
  
  
  If OpenWindow(0, 100, 200, 420, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
    
    ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    ;If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large|#PB_ToolBar_Text)
    If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small)
      ToolBarImageButton(0, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
      ToolBarImageButton(1, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
      ToolBarImageButton(2, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"))
      
      ToolBarSeparator()
      
      ToolBarImageButton(3, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
      ToolBarToolTip(0, 3, "Cut")
      
      ToolBarImageButton(4, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
      ToolBarToolTip(0, 4, "Copy")
      
      ToolBarImageButton(5, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
      ToolBarToolTip(0, 5, "Paste")
      
      ToolBarSeparator()
      
      ToolBarImageButton(6, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
      ToolBarToolTip(0, 6, "Find a document")
    EndIf
    
    DisableToolBarButton(0, 2, 1) ; Disable the button '2'
  EndIf
  
  
  If Open( 1, 550, 200, 500, 380, "ToolBar example");, #PB_Window_BorderLess )
     a_init(root( ))
     Window( 10, 10, 420, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
     
    ; *toolbar = CreateBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    ;*toolbar = CreateBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    *toolbar = CreateBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Text);|#PB_ToolBar_Buttons)
    ;*toolbar = CreateBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_Text)
    
    If *toolbar
      BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
      BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
      BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
      
      BarSeparator( )
      
      BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
      ; ToolTip(*toolbar, 3, "Cut")
      
      BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
      ; ToolTip(*toolbar, 4, "Copy")
      
      BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
      ; ToolTip(*toolbar, 5, "Paste")
      
      BarSeparator( )
      
      BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
      ; ToolTip(*toolbar, 6, "Find a document")
    EndIf
    
    DisableBarButton(*toolbar, 2, 1) ; Disable the button '2'
    
    ;SetState(*toolbar, 12 )
      Button( 10,10, 50,50,"" )
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 92
; FirstLine = 81
; Folding = --
; EnableXP