﻿;                                                       - PB
;                               BarSeparator( [*address] ) - ToolBarBarSeparator( )
;                                                         ToolBarID( #ToolBar )
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
  UseWidgets( )
  UsePNGImageDecoder()
  
  Global *toolbar._s_widget, th=24
  
;   Macro BarButton( _button_, _image_, _mode_ = 0, _text_ = #Null$ )
;      MenuBarButton( _button_, _image_, _mode_, _text_ )
;   EndMacro
;   
;   Macro BarSeparator( )
;      MenuBarBarSeparator( )
;   EndMacro
;   
  
  Procedure ToolBarEvents( )
      Protected *e_widget._s_WIDGET = EventWidget( )
      Protected BarButton = GetData( *e_widget ) 
      
      
   EndProcedure
   
   
;    Procedure _ToolBar( *parent._s_WIDGET, flag.i = #PB_ToolBar_Small )
;     ;  ProcedureReturn ToolBar( *parent, flag )
; ;     *parent\ToolBarHeight = 32;+2 + 6
; ;                               ;  *parent\tab\widget = Create( *parent, *parent\class+"_"+#PB_Compiler_Procedure, #__type_ToolBar, 0,0,0,0, 0,0,0, #Null$, flag | #__flag_child, 0,0,30 )
; ;     *parent\tab\widget = Create( *parent, *parent\class+"_"+#PB_Compiler_Procedure, #__type_ToolBar, 0,0,0,0, #Null$, flag | #__flag_child, 0,0,0, 0,0,30 )
; ;     Resize( *parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
; ;     ProcedureReturn *parent\tab\widget
;      Protected *this._s_WIDGET
;      *this = widget::Tab(0, 0, *parent\width, 30);, #__flag_autosize)
;      SetAlign(*this, #__align_full|#__align_top )
;      ProcedureReturn *this
;   EndProcedure
;   
;   Macro BarButton( _button_, _image_, _mode_=0, _text_="" )
; ;     If widget( )\tab\widget
; ;       AddItem( widget( )\tab\widget, _button_, _text_, _image_, _mode_)
; ;     EndIf
;     If widget( )
;       AddItem( widget( ), _button_, _text_, _image_, _mode_)
;     EndIf
;   EndMacro
;   
;   Macro BarSeparator( )
;     If widget( )\tab\widget
;       AddItem( widget( )\tab\widget, 65535, "|", #Null, #Null )
;     EndIf
;   EndMacro
    Macro DisableButton( _address_, _button_, _state_ )
   ; DisableItem( _address_, _button_, _state_ )
  EndMacro
  
  
  If Open( 1, 300, 200, 300, 380, "ToolBar example", #PB_Window_SizeGadget )
     a_init(root( ))
    *toolbar = ToolBar( root( ) )
    
    If *toolbar
      BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
      BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
      BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
      
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
    
    DisableButton(*toolbar, 2, 1) ; Disable the button '2'
    
    
    Button( 10,0, 50,50,"btn0" ) : SetClass(widget( ), "btn0" )
      
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
; CursorPosition = 80
; FirstLine = 52
; Folding = --
; EnableXP