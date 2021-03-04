;                                                       - PB
;                     Separator( *address = widget( ) ) - ToolBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableToolBarButton( #ToolBar, Button, State )
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetToolBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetToolBarButtonState( #ToolBar, Button, State )
;                 SetItemText( *address, item, text.s ) - ToolBarButtonText( #ToolBar, Button, Text$ )
;                                    Height( *address ) - ToolBarHeight( #ToolBar )
; AddItem( *address, #PB_Default, text.s, image, mode ) - ToolBarImageButton( #Button, ImageID [, Mode [, Text$]] )
;  AddItem( *address, icon, text.s, #PB_Default, mode ) - ToolBarStandardButton( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemText( *address, item ) - 
;                        GetItemImage( *address, item ) - 
;                 SetItemImage( *address, item, image ) - 

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  If Open(0, 100, 200, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
    
    If CreateToolBar(0, WindowID(0))
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
    
    
    If CreateMenu(0, WindowID(0))
      MenuTitle("Project")
      MenuItem(0, "New")
      MenuItem(1, "Open")
      MenuItem(2, "Save")
    EndIf
    
    DisableToolBarButton(0, 2, 1) ; Disable the button '2'
    
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
    
  EndIf
  
  End   ; All resources are automatically freed
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP