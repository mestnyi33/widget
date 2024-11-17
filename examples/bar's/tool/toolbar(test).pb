;                                                       - PB
;                               BarSeparator( [*address] ) - ToolBarBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableBarButtonWidget( #ToolBar, Button, State )
;                                      FreeWidget( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;                 SetItemTextWidget( *address, item, text.s ) - BarButtonTextWidget( #ToolBar, Button, Text$ )
;                                    WidgetHeight( *address ) - ToolBarWidgetHeight( #ToolBar )
;      AddItem( *address, button, text.s, image, mode ) - ToolBarImageButtonWidget( #Button, ImageID [, Mode [, Text$]] )
;       AddItem( *address, button, text.s, icon, mode ) - ToolBarStandardButtonWidget( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarWidgetToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemTextWidget( *address, item ) - 
;                        GetWidgetItemImage( *address, item ) - 
;                 SetWidgetItemImage( *address, item, image ) - 

;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  
  Global *toolbar._s_widget, th=24
  
;   Macro BarButtonWidget( _button_, _image_, _mode_ = 0, _text_ = #Null$ )
;      MenuBarButtonWidget( _button_, _image_, _mode_, _text_ )
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
; ;                               ;  *parent\tab\widget = Create( *parent, *parent\class+"_"+#PB_Compiler_Procedure, #PB_WidgetType_Tool, 0,0,0,0, 0,0,0, #Null$, flag | #__flag_child, 0,0,30 )
; ;     *parent\tab\widget = Create( *parent, *parent\class+"_"+#PB_Compiler_Procedure, #PB_WidgetType_Tool, 0,0,0,0, #Null$, flag | #__flag_child, 0,0,0, 0,0,30 )
; ;     ResizeWidget( *parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
; ;     ProcedureReturn *parent\tab\widget
;      Protected *this._s_WIDGET
;      *this = widget::TabBarWidget(0, 0, *parent\width, 30);, #__flag_autosize)
;      SetAlign(*this, #__align_full|#__align_top )
;      ProcedureReturn *this
;   EndProcedure
;   
;   Macro BarButtonWidget( _button_, _image_, _mode_=0, _text_="" )
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
    Macro DisableButtonWidget( _address_, _button_, _state_ )
   ; DisableItem( _address_, _button_, _state_ )
  EndMacro
  
  
  If OpenRootWidget( 1, 300, 200, 300, 380, "ToolBar example", #PB_Window_SizeGadget )
     a_init(root( ))
    *toolbar = ToolBar( root( ) )
    
    If *toolbar
      BarButtonWidget(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
      BarButtonWidget(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
      BarButtonWidget(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
      
      BarSeparator( )
      
      BarButtonWidget(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
      ; WidgetToolTip(*toolbar, 3, "Cut")
      
      BarButtonWidget(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
      ; WidgetToolTip(*toolbar, 4, "Copy")
      
      BarButtonWidget(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
      ; WidgetToolTip(*toolbar, 5, "Paste")
      
      BarSeparator( )
      
      BarButtonWidget(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
      ; WidgetToolTip(*toolbar, 6, "Find a document")
    EndIf
    
    DisableButtonWidget(*toolbar, 2, 1) ; Disable the button '2'
    
    
    ButtonWidget( 10,0, 50,50,"btn0" ) : SetWidgetClass(widget( ), "btn0" )
      
    ;  BindWidgetEvent( root( ), #PB_Default )
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
; CursorPosition = 10
; FirstLine = 6
; Folding = --
; EnableXP