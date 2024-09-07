XIncludeFile "../../widgets.pbi" 

Uselib(widget)
   
Macro EventElement( )
   GetIndex( EventWidget( ) )
EndMacro

Macro ElementEventType( )
   ToPBEventType( WidgetEventType( ) )
EndMacro

Macro GetElementState( _element_ )
   GetState( WidgetID( _element_ ) ) 
EndMacro

Macro SetElementState( _element_, _state_ )
   SetState( WidgetID( _element_ ), _state_ ) 
EndMacro

Macro BindElementEvent( _element_, _callback_, _event_ )
   Bind( WidgetID( _element_ ), _callback_, _event_ )
EndMacro

Macro OptionElement( _element_, _x_, _y_, _width_, _height_, _text_, _flag_=0 )
   Option(_x_, _y_, _width_, _height_, _text_, _flag_)
   If _element_ >= 0
      widget( )\_id = _element_
   EndIf
EndMacro

Macro CheckBoxElement( _element_, _x_, _y_, _width_, _height_, _text_, _flag_=0 )
   CheckBox(_x_, _y_, _width_, _height_, _text_, _flag_)
   If _element_ >= 0
      widget( )\_id = _element_
   EndIf
EndMacro

Macro OpenElement( _window_, _x_, _y_, _width_, _height_, _text_, _flag_=0, _parent_=0 )
   Open( _window_, _x_, _y_, _width_, _height_, _text_, _flag_, _parent_ )
EndMacro

Macro WaitCloseElement( _element_=0 )
   WaitClose( _element_ )
EndMacro

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 34
; FirstLine = 9
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; Folding = --
; EnableXP
; DPIAware