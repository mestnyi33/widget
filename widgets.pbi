CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  #path = "/media/sf_as/Documents/GitHub/widget"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  #path = "Z:/Documents/GitHub/widget"
  ;#path "C:\Users\as\Desktop\Widget_15_08_2020"
CompilerEndIf

IncludePath #path

CompilerIf Not Defined( fix, #PB_Module )
  ; fix all pb bug's
  XIncludeFile "include/fix.pbi"
CompilerEndIf

CompilerIf Not Defined( func, #PB_Module )
  XIncludeFile "include/func.pbi"
CompilerEndIf

CompilerIf Not Defined( constants, #PB_Module )
  XIncludeFile "include/constants.pbi"
CompilerEndIf

CompilerIf Not Defined( structures, #PB_Module )
  XIncludeFile "include/structures.pbi"
CompilerEndIf

CompilerIf Not Defined( colors, #PB_Module )
  XIncludeFile "include/colors.pbi"
CompilerEndIf

CompilerIf Not Defined( Widget, #PB_Module )
  ;-  >>>
  DeclareModule Widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    CompilerIf Defined( fix, #PB_Module )
      UseModule fix
    CompilerEndIf
    
    ;-  ----------------
    ;-   DECLARE_macros
    ;-  ----------------
    Macro Debugger( _text_="" )
      CompilerIf #PB_Compiler_Debugger  ; Only enable assert in debug mode
        Debug  " " +_macro_call_count_ +_text_+ "   ( debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
        _macro_call_count_ + 1
      CompilerEndIf
    EndMacro
    
    ;- demo text
    Macro debug_position( _text_="" )
      Debug " " +_text_+ " - "
      ForEach Widget( ) 
        If Widget( )\before And Widget( )\after
          Debug " - "+ Str(ListIndex(Widget())) +" "+ Widget( )\index +" "+ Widget( )\before\class +" "+ Widget( )\class +" "+ Widget( )\after\class
        ElseIf Widget( )\after
          Debug " - "+ Str(ListIndex(Widget())) +" "+ Widget( )\index +" none "+ Widget( )\class +" "+ Widget( )\after\class
        ElseIf Widget( )\before
          Debug " - "+ Str(ListIndex(Widget())) +" "+ Widget( )\index +" "+ Widget( )\before\class +" "+ Widget( )\class +" none"
        Else
          Debug " - "+ Str(ListIndex(Widget())) +" "+ Widget( )\index +" none "+ Widget( )\class + " none " 
        EndIf
      Next
      Debug ""
    EndMacro
    
    
    ;- Replacement >> PB( )
    ;  Drag and Drop
    
    Macro EventDropX( ): DD_DropX( ): EndMacro
    Macro EventDropY( ): DD_DropY( ): EndMacro
    Macro EventDropWidth( ): DD_DropWidth( ): EndMacro
    Macro EventDropHeight( ): DD_DropHeight( ): EndMacro
    
    Macro EventDropType( ): DD_DropType( ): EndMacro
    Macro EventDropAction( ): DD_DropAction( ): EndMacro
    Macro EventDropPrivate( ): DD_DropPrivate( ): EndMacro
    Macro EventDropFiles( ): DD_DropFiles( ): EndMacro
    Macro EventDropText( ): DD_DropText( ): EndMacro
    Macro EventDropImage( Image = -1, Depth = 24 ): DD_DropImage( Image, Depth ): EndMacro
    
    
    Macro DragItem( Row, Actions = #PB_Drag_Copy ): DD_EventDragItem( Row, Actions ): EndMacro
    Macro DragText( Text, Actions = #PB_Drag_Copy ): DD_EventDragText( Text, Actions ): EndMacro
    Macro DragImage( Image, Actions = #PB_Drag_Copy ): DD_EventDragImage( Image, Actions ): EndMacro
    Macro DragFiles( Files, Actions = #PB_Drag_Copy ): DD_EventDragFiles( Files, Actions ): EndMacro
    Macro DragPrivate( PrivateType, Actions = #PB_Drag_Copy ): DD_EventDragPrivate( PrivateType, Actions ): EndMacro
    
    Macro EnableDrop( Widget, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Widget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableGadgetDrop( Gadget, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Gadget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableWindowDrop( Window, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Window, Format, Actions, PrivateType ) : EndMacro
    
    Declare.l DD_DropX( )
    Declare.l DD_DropY( )
    Declare.l DD_DropWidth( )
    Declare.l DD_DropHeight( )
    
    Declare.s DD_DropFiles( )
    Declare.s DD_DropText( )
    Declare.i DD_DropType( )
    Declare.i DD_DropAction( )
    Declare.i DD_DropPrivate( )
    Declare.i DD_DropImage( Image.i = -1, Depth.i = 24 )
    
    
    Declare.i DD_EventDragText( Text.S, Actions.i = #PB_Drag_Copy )
    Declare.i DD_EventDragImage( Image.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_EventDragPrivate( Type.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_EventDragFiles( Files.s, Actions.i = #PB_Drag_Copy )
    
    Declare.i DD_DropEnable( *this, Format.i, Actions.i, PrivateType.i = 0 )
    
    ;-
    Macro allocate( _struct_name_, _struct_type_= )
      _s_#_struct_name_#_struct_type_ = AllocateStructure( _s_#_struct_name_ )
    EndMacro
    
    Macro PB( _pb_function_name_ ) : _pb_function_name_: EndMacro
    Macro This( ) : widget::*include: EndMacro
    Macro Root( ) : widget::this( )\_root( ): EndMacro
    Macro Mouse( ) : widget::this( )\mouse: EndMacro
    Macro Widget( ) : widget::this( )\address( ): EndMacro ; Returns last created widget 
    Macro Keyboard( ) : widget::this( )\keyboard: EndMacro
    ;;Macro posted( _address_ ) : _address_\event\bind( )\events(): EndMacro
    ;;Macro buttons( ) : widget::mouse( )\buttons: EndMacro
    
    Macro _get_bar_enter_item_( _this_ ) : _this_\bar\hover: EndMacro; Returns mouse entered widget
    Macro _get_bar_active_item_( _this_ ) : _this_\bar\active: EndMacro; Returns mouse entered widget
    
    Macro GetActive( ) : widget::keyboard( )\window: EndMacro   ; Returns activeed window
    
    Macro EnterRow( ) : widget::mouse( )\row: EndMacro; Returns mouse entered widget
    Macro LeaveRow( ) : widget::mouse( )\row[1]: EndMacro; Returns mouse entered widget
    
    Macro EnterButton( ) : widget::mouse( )\button : EndMacro
    Macro LeaveButton( ) : widget::mouse( )\button[1] : EndMacro
    Macro ActiveButton( ) : widget::mouse( )\button[2] : EndMacro
    
    Macro EnterWidget( ) : widget::mouse( )\entered: EndMacro ; Returns mouse entered widget
    Macro LeaveWidget( ) : widget::mouse( )\leaved: EndMacro  ; Returns mouse entered widget
                                                              ;Macro SelectWidget( ) : widget::mouse( )\selected: EndMacro ; Returns mouse entered widget
    
    Macro EventWidget( ) : widget::this( )\widget: EndMacro
    Macro FocusWidget( ) : widget::keyboard( )\widget: EndMacro ; Returns keyboard focus widget
    Macro OpenWidget( ) : widget::Root( )\openlist: EndMacro
    
    Macro EventIndex( ) : widget::this( )\widget\index: EndMacro
    Macro WidgetEvent( ) : widget::this( )\event: EndMacro
    Macro WidgetEventType( ) : widget::WidgetEvent( )\type: EndMacro
    Macro WidgetEventItem( ) : widget::WidgetEvent( )\item: EndMacro
    Macro WidgetEventData( ) : widget::WidgetEvent( )\data: EndMacro
    
    Macro Transform( ) : widget::mouse( )\_transform: EndMacro
    
    Macro WaitClose( _window_ = #PB_Any, _time_ = 0 )
      If Root( )
        ReDraw( Root( ) )
        ; EndIf  
        
        Repeat 
          Select WaitWindowEvent( _time_ ) 
            Case #PB_Event_Gadget
              If Root( )\canvas\bindevent = #False
                Root( )\repaint = #True
                EventHandler( )
              EndIf
              
            Case #PB_Event_CloseWindow
              If _window_ = #PB_Any 
                Debug " - close - " + EventWidget( ) ; +" "+ GetWindow( _window_ )
                If EventWidget( )\container = #__type_window
                  ;Else
                  
                  ForEach Root( )
                    Debug Root( )
                    free( Root( ) )
                    ;               ForEach widget( )
                    ;                 Debug ""+widget( )\root +" "+ _is_root_( widget( ) )
                    ;               Next
                  Next
                  Break
                EndIf
                
              ElseIf PB(EventGadget)( ) = _window_
                Debug " - close1 - " + PB(EventWindow)( ) ; +" "+ GetWindow( _window_ )
                Free( _window_ )
                Break
              ElseIf PB(EventWindow)( ) = _window_ And Post( #__event_Free, _window_ )
                Debug " - close2 - " + PB(EventWindow)( ) ; +" "+ GetWindow( _window_ )
                Break
              EndIf
              
          EndSelect
        ForEver
        
        ; If root( )
        ReDraw( Root( ) )
      EndIf  
    EndMacro
    
    Macro Repaints( )
      _post_repaint_( Root( ), Root( ) )
    EndMacro
    
    ;-
    Macro StartEnumerate( _parent_ )
      Bool( _parent_\count\childrens )
      
      PushListPosition( Widget( ) )
      If _parent_\address
        ChangeCurrentElement( Widget( ), _parent_\address )
      Else
        ResetList( Widget( ) )
      EndIf
      
      While NextElement( Widget( ) )
        If Child( Widget( ), _parent_ )
        EndMacro
        
        Macro AbortEnumerate( )
          Break
        EndMacro
        
        Macro StopEnumerate( ) ; _break_ = #True )
        Else
          ; If _break_ = #True
          Break
          ; EndIf
        EndIf
      Wend
      PopListPosition( Widget( ) )
    EndMacro
    
    
    ;-
    Macro _get_colors_( ) : colors::*this\blue : EndMacro
    
    ;- 
    Macro _is_root_( _this_ ) : Bool( _this_ > 0 And _this_ = _this_\root ): EndMacro
    Macro _is_item_( _this_, _item_ ) : Bool( _item_ >= 0 And _item_ < _this_\count\items ) : EndMacro
    Macro _is_widget_( _this_ ) : Bool( _this_ > 0 And _this_\address ) : EndMacro
    Macro _is_window_( _this_ ) : Bool( _is_widget_( _this_ ) And _this_\type = constants::#__type_window ) : EndMacro
    Macro _is_selected_( _this_ ) : Bool( _this_ > 0 And _this_\_state & constants::#__s_selected ) : EndMacro
    Macro _is_scrollbars_( _this_ ) : Bool( _this_\parent And _this_\parent\scroll And ( _this_\parent\scroll\v = _this_ Or _this_\parent\scroll\h = _this_ ) ) : EndMacro
    
    Macro _is_root_container_( _this_ )
      Bool( _this_ = _this_\root\canvas\container )
    EndMacro
    
    
    ;     Macro _get_active_( ): widget::keyboard( )\widget: EndMacro
    ;     Macro _set_active_( _this_ ) : Bool( _this_\_state | constants::#__s_focused ) : EndMacro
    ;     Macro _is_active_( _this_ ) : Bool( _this_\_state & constants::#__s_focused ) : EndMacro
    Macro _is_focused_( _this_ ) : Bool( _this_\_state & constants::#__s_focused ) : EndMacro
    ;     Macro _is_entered_( _this_ ) : Bool( _this_\_state & constants::#__s_entered ) : EndMacro
    ; Macro _get_state_value_( ) : EndMacro
    
    Macro _no_select_item_( _list_, _item_ )
      Bool( _item_ < 0 Or _item_ >= ListSize( _list_ ) Or (ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) ) ) 
      ; Bool( _item_ >= 0 And ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) ) 
    EndMacro
    
    Macro _no_select_scrollbars_( _this_ ) : Bool( Not (_is_selected_( _this_\scroll\v ) Or _is_selected_( _this_\scroll\h ))) : EndMacro
    
    Macro _is_child_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child = 1 )
    EndMacro
    
    Macro _is_child_no_integral_( _this_ )
      Bool( _this_\child =- 1 )
    EndMacro
    
    Macro _is_current_( _address_ )
      Bool( Not mouse( )\buttons Or _is_selected_( _address_ ) )
      ; Bool( Not ( mouse( )\buttons And Not _is_selected_( _address_ ) ) )
    EndMacro
    
    Macro _select_prev_item_( _address_, _index_ )
      SelectElement( _address_, _index_ - 1 )
      
      If _address_\hide
        While PreviousElement( _address_ )
          If Not _address_\hide
            Break
          EndIf
        Wend
      EndIf
    EndMacro
    
    Macro _select_next_item_( _address_, _index_ )
      SelectElement( _address_, _index_ + 1 )
      
      If _address_\hide
        While NextElement( _address_ )
          If Not _address_\hide
            Break
          EndIf
        Wend
      EndIf
    EndMacro
    
    ;-
    Macro _post_event_( _result_, _address_, _eventtype_ )
      ;;PushListPosition( _address_ )
      ForEach _address_
        If _address_\eventtype = _eventtype_ Or _address_\eventtype = #PB_All 
          
          ;;PushListPosition( _address_\callback( ) )
          ForEach _address_\callback( )
            If _address_\callback( )\func( ) = #PB_Ignore
              _result_ = #PB_Ignore
              Break 2
            EndIf
          Next
          ;;PopListPosition( _address_\callback( ) )
          
          ;Break
        EndIf
      Next
      ;;PopListPosition( _address_ )
    EndMacro
    
    Macro _post_repaint_items_( _this_ )
      If _this_\count\items = 0 Or 
         ( Not _this_\hide And _this_\row\count And 
           ( _this_\count\items % _this_\row\count ) = 0 )
        
        Debug #PB_Compiler_Procedure
        _this_\change = 1
        _this_\row\count = _this_\count\items
        _post_repaint_( _this_\root )
      EndIf  
    EndMacro
    
    Macro _post_repaint_( _address_root_, _event_data_ = #Null )
      If _address_root_\canvas\postevent = #False 
        _address_root_\canvas\postevent = #True
        PostEvent( #PB_Event_Gadget, _address_root_\canvas\window, _address_root_\canvas\gadget, #__event_Repaint, _event_data_ )
      EndIf
    EndMacro
    
    
    ;- 
    Macro ICase( String ) ; sTRinG = StrINg
      func::IinvertCase( String )
    EndMacro
    
    Macro ULCase( String ) ; sTRinG = String
      InsertString( UCase( Left( String, 1 ) ), LCase( Right( String, Len( String ) - 1 ) ), 2 )
    EndMacro
    
    Macro Atbox( _x_, _y_, _width_, _height_, _mouse_x_, _mouse_y_ )
      Bool( _mouse_x_ > _x_ And _mouse_x_ <= ( _x_ + _width_ ) And 
            _mouse_y_ > _y_ And _mouse_y_ <= ( _y_ + _height_ ) )
    EndMacro
    
    Macro Atpoint( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( _mouse_x_ > _address_\x#_mode_ And _mouse_x_ <= ( _address_\x#_mode_ + _address_\width#_mode_ ) And 
            _mouse_y_ > _address_\y#_mode_ And _mouse_y_ <= ( _address_\y#_mode_ + _address_\height#_mode_ ) )
    EndMacro
    
    Macro Intersect( _address_1_, _address_2_, _address_1_mode_ = )
      Bool( ( _address_1_\x#_address_1_mode_ + _address_1_\width#_address_1_mode_ ) > _address_2_\x And _address_1_\x#_address_1_mode_ < ( _address_2_\x + _address_2_\width ) And 
            ( _address_1_\y#_address_1_mode_ + _address_1_\height#_address_1_mode_ ) > _address_2_\y And _address_1_\y#_address_1_mode_ < ( _address_2_\y + _address_2_\height ) )
    EndMacro
    
    
    ;-
    ; хочу внедрит
    Macro _draw_mode_( _mode_ )
      If Widget( )\_drawing <> _mode_
        Widget( )\_drawing = _mode_
        
        DrawingMode( _mode_ )
      EndIf
    EndMacro
    
    ; хочу внедрит
    Macro _draw_mode_alpha_( _mode_ )
      If Widget( )\_draw_alpha <> _mode_
        Widget( )\_draw_alpha = _mode_
        
        DrawingMode( _mode_ | #PB_2DDrawing_AlphaBlend )
      EndIf
    EndMacro
    
    Macro _draw_font_( _this_ )
      ; drawing font
      ; If Not _this_\hide
      
      If _this_\text\fontID = #Null
        _this_\text\fontID = _this_\root\text\fontID 
        _this_\text\change = #True
      EndIf
      
      If _this_\root\canvas\fontID <> _this_\text\fontID
        _this_\root\canvas\fontID = _this_\text\fontID
        
        ;; Debug "draw current font - " + #PB_Compiler_Procedure  + " " +  _this_ + " fontID - "+ _this_\text\fontID
        DrawingFont( _this_\text\fontID ) 
        _this_\text\change = #True
      EndIf
      
      If _this_\text\change
        If _this_\text\string 
          _this_\text\width = TextWidth( _this_\text\string ) 
        EndIf
        
        _this_\text\height = TextHeight( "A" ); - Bool( #PB_Compiler_OS <> #PB_OS_Windows ) * 2
        _this_\text\rotate = Bool( _this_\text\invert ) * 180 + Bool( _this_\vertical ) * 90
      EndIf
      
      ; EndIf
    EndMacro
    
    Macro _draw_font_item_( _this_, _item_, _change_ )
      If _item_\text\fontID = #Null
        If _this_\text\fontID = #Null
          If _is_child_integral_( _this_ )
            _this_\text\fontID = _this_\parent\text\fontID 
            _this_\text\height = _this_\parent\text\height 
          Else
            _this_\text\fontID = _this_\root\text\fontID 
            _this_\text\height = _this_\root\text\height 
          EndIf
        EndIf
        
        _item_\text\fontID = _this_\text\fontID
        _item_\text\height = _this_\text\height
        _item_\text\change = #True
      EndIf
      
      ; drawing item font
      If _this_\root\canvas\fontID <> _item_\text\fontID
        ;;Debug " item fontID - "+ _item_\text\fontID
        _this_\root\canvas\fontID = _item_\text\fontID
        
        ; Debug "draw current item font - " + #PB_Compiler_Procedure  + " " +  _this_  + " " +  _item_\index + " fontID - "+ _item_\text\fontID
        DrawingFont( _item_\text\fontID ) 
        _item_\text\height = TextHeight( "A" ) 
        _item_\text\change = #True
      EndIf
      
      ; Получаем один раз после изменения текста  
      If _item_\text\change ; _change_
        If _item_\text\string
          _item_\text\width = TextWidth( _item_\text\string ) 
        EndIf
        
        _item_\text\change = #False
      EndIf 
    EndMacro      
    
    ; -
    Macro _draw_arrows_( _address_, _type_ )
      Arrow( _address_\x + ( _address_\width - _address_\arrow\size )/2,
             _address_\y + ( _address_\height - _address_\arrow\size )/2, _address_\arrow\size, _type_, 
             _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24, _address_\arrow\type )
    EndMacro   
    
    Macro _draw_gradient_( _vertical_, _address_, _color_fore_, _color_back_, _mode_= )
      BackColor( _color_fore_&$FFFFFF | _address_\color\_alpha<<24 )
      FrontColor( _color_back_&$FFFFFF | _address_\color\_alpha<<24 )
      
      If _vertical_  ; _address_\vertical
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, ( _address_\x#_mode_ + _address_\width#_mode_ ), _address_\y#_mode_ )
      Else
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, _address_\x#_mode_, ( _address_\y#_mode_ + _address_\height#_mode_ ) )
      EndIf
      
      RoundBox( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      
      BackColor( #PB_Default ) 
      FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro _draw_gradient_box_( _vertical_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_ = 0, _alpha_ = 255 )
      BackColor( _color_1_&$FFFFFF | _alpha_<<24 )
      FrontColor( _color_2_&$FFFFFF | _alpha_<<24 )
      
      If _vertical_
        LinearGradient( _x_,_y_, ( _x_ + _width_ ), _y_ )
      Else
        LinearGradient( _x_,_y_, _x_, ( _y_ + _height_ ) )
      EndIf
      
      RoundBox( _x_,_y_,_width_,_height_, _round_,_round_ )
      
      BackColor( #PB_Default ) : FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro _draw_box_( _address_, _color_type_, _mode_= )
      RoundBox( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, 
                _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
    EndMacro
    
    Macro _draw_box_button_( _address_, _color_type_ )
      If Not _address_\hide
        RoundBox( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        RoundBox( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        RoundBox( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro _draw_close_button_( _address_, _size_ )
      ; close button
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x - 1 + _size_ + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + _size_ + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        _draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro _draw_maximize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 2 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 2 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        _draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro _draw_minimize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width )/2 - _size_, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 0 + ( _address_\width )/2 - _size_, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x - 1 + ( _address_\width )/2 + _size_, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x - 2 + ( _address_\width )/2 + _size_, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        _draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro _draw_help_button_( _address_, _size_ )
      If Not _address_\hide
        RoundBox( _address_\x, _address_\y, _address_\width, _address_\height, 
                  _address_\round, _address_\round, _address_\color\frame[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro _draw_option_button_( _address_, _size_, _color_ )
      If _address_\round > 2
        If _address_\width % 2
          RoundBox( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, _size_ + 1,_size_ + 1, _color_ ) 
        Else
          RoundBox( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_,_size_, _size_,_size_, _color_ ) 
        EndIf
      Else
        If _address_\width % 2
          RoundBox( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
        Else
          RoundBox( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
        EndIf
      EndIf
    EndMacro
    
    Macro _draw_check_button_( _address_, _size_, _color_ )
      If _address_\state
        LineXY( ( _address_\x +0+ ( _address_\width-_size_ )/2 ),( _address_\y +4+ ( _address_\height-_size_ )/2 ),( _address_\x +1+ ( _address_\width-_size_ )/2 ),( _address_\y +5+ ( _address_\height-_size_ )/2 ), _color_ ) ; Левая линия
        LineXY( ( _address_\x +0+ ( _address_\width-_size_ )/2 ),( _address_\y +5+ ( _address_\height-_size_ )/2 ),( _address_\x +1+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; Левая линия
        
        LineXY( ( _address_\x +5+ ( _address_\width-_size_ )/2 ),( _address_\y +0+ ( _address_\height-_size_ )/2 ),( _address_\x +2+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; правая линия
        LineXY( ( _address_\x +6+ ( _address_\width-_size_ )/2 ),( _address_\y +0+ ( _address_\height-_size_ )/2 ),( _address_\x +3+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; правая линия
      EndIf
    EndMacro
    
    Macro _draw_button_( _type_, _x_,_y_, _width_, _height_, _checked_, _round_, _color_fore_=$FFFFFFFF, _color_fore2_=$FFE9BA81, _color_back_=$80E2E2E2, _color_back2_=$FFE89C3D, _color_frame_=$80C8C8C8, _color_frame2_=$FFDC9338, _alpha_ = 255 ) 
      DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
      LinearGradient( _x_,_y_, _x_, ( _y_ + _height_ ) )
      
      If _checked_
        BackColor( _color_fore2_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back2_&$FFFFFF | _alpha_<<24 )
      Else
        BackColor( _color_fore_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      RoundBox( _x_,_y_,_width_,_height_, _round_,_round_ )
      
      If _type_ = 4
        FrontColor( $ff000000&$FFFFFF | _alpha_<<24 )
        BackColor( $ff000000&$FFFFFF | _alpha_<<24 )
        
        Line( _x_ + 1 + ( _width_ - 6 )/2, _y_ + ( _height_ - 6 )/2, 6, 6 )
        Line( _x_ + ( _width_ - 6 )/2, _y_ + ( _height_ - 6 )/2, 6, 6 )
        
        Line( _x_ - 1 + 6 + ( _width_ - 6 )/2, _y_ + ( _height_ - 6 )/2,  - 6, 6 )
        Line( _x_ + 6 + ( _width_ - 6 )/2, _y_ + ( _height_ - 6 )/2,  - 6, 6 )
      Else
        FrontColor( _color_fore_&$FFFFFF | _alpha_<<24 )
        BackColor( _color_fore_&$FFFFFF | _alpha_<<24 )
        
        If _checked_
          If _type_ = 1
            If _width_%2
              RoundBox( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5, 5,5 ) 
            Else
              RoundBox( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4, 4,4 ) 
            EndIf
          Else
            If _checked_ =- 1
              If _width_%2
                Box( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5 ) 
              Else
                Box( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4 ) 
              EndIf
            Else
              _box_x_ = _width_/2 - 4
              _box_y_ = _box_x_ + Bool( _width_%2 ) 
              
              LineXY( ( _x_ + 1+_box_x_ ),( _y_ +4+ _box_y_ ),( _x_ +2+ _box_x_ ),( _y_ +5+ _box_y_ ) ) ; Левая линия
              LineXY( ( _x_ + 1+_box_x_ ),( _y_ +5+ _box_y_ ),( _x_ +2+ _box_x_ ),( _y_ +6+ _box_y_ ) ) ; Левая линия
              
              LineXY( ( _x_ + 6+_box_x_ ),( _y_ +0+ _box_y_ ),( _x_ +3+ _box_x_ ),( _y_ +6+ _box_y_ ) ) ; правая линия
              LineXY( ( _x_ + 7+_box_x_ ),( _y_ +0+ _box_y_ ),( _x_ +4+ _box_x_ ),( _y_ +6+ _box_y_ ) ) ; правая линия
            EndIf
          EndIf
        EndIf
        
      EndIf    
      
      DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
      
      If _checked_
        FrontColor( _color_frame2_&$FFFFFF | _alpha_<<24 )
      Else
        FrontColor( _color_frame_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      RoundBox( _x_,_y_,_width_,_height_, _round_,_round_ );, _color_frame_&$FFFFFF | _alpha_<<24 )
    EndMacro
    
    
    ;- BAR
    Macro _bar_in_start_( _bar_ ) 
      Bool( _bar_\thumb\pos >=_bar_\area\end )
    EndMacro
    
    Macro _bar_in_stop_( _bar_ ) 
      Bool( _bar_\thumb\pos <= _bar_\area\pos )
    EndMacro
    
    Macro _bar_page_pos_( _bar_, _thumb_pos_ )
      ( _bar_\min + Round( ( ( _thumb_pos_ ) - _bar_\area\pos ) / _bar_\percent, #PB_Round_Nearest ) )
    EndMacro
    
    Macro _bar_thumb_pos_( _bar_, _scroll_pos_ )
      Round( ( ( _scroll_pos_ ) - _bar_\min - _bar_\min[1] ) * _bar_\percent, #PB_Round_Nearest ) 
    EndMacro
    
    Macro _bar_invert_page_pos_( _bar_, _scroll_pos_ )
      ( Bool( _bar_\inverted ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min ) ) + Bool( Not _bar_\inverted ) * ( _scroll_pos_ ) )
    EndMacro
    
    Macro _bar_invert_thumb_pos_( _bar_, _thumb_pos_ )
      ( Bool( _bar_\inverted ) * ( _bar_\area\end - _thumb_pos_ ) +
        Bool( Not _bar_\inverted ) * ( _bar_\area\pos + _thumb_pos_ ) )
    EndMacro
    
    Macro _bar_scroll_pos_( _this_, _pos_, _len_ )
      Bool( Bool( ( ( ( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) < 0 And Bar_SetState( _this_, ( ( _pos_ ) + _this_\bar\min ) ) ) Or
            Bool( ( ( ( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) > ( _this_\bar\page\len - ( _len_ ) ) And Bar_SetState( _this_, ( ( _pos_ ) + _this_\bar\min ) - ( _this_\bar\page\len - ( _len_ ) ) ) ) )
    EndMacro
    
    ;-
    Macro _mdi_update_( _this_,  _x_,_y_, _width_, _height_ )
      _this_\x[#__c_required] = _x_
      _this_\y[#__c_required] = _y_
      _this_\width[#__c_required] = _width_
      _this_\height[#__c_required] = _height_
      
      If StartEnumerate( _this_ )
        If Widget( )\parent = _this_
          If _this_\x[#__c_required] > Widget( )\x[#__c_container] 
            _this_\x[#__c_required] = Widget( )\x[#__c_container] 
          EndIf
          If _this_\y[#__c_required] > Widget( )\y[#__c_container] 
            _this_\y[#__c_required] = Widget( )\y[#__c_container] 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If StartEnumerate( _this_ )
        If Widget( )\parent = _this_
          If _this_\width[#__c_required] < Widget( )\x[#__c_container] + Widget( )\width[#__c_frame] - _this_\x[#__c_required] 
            _this_\width[#__c_required] = Widget( )\x[#__c_container] + Widget( )\width[#__c_frame] - _this_\x[#__c_required] 
          EndIf
          If _this_\height[#__c_required] < Widget( )\y[#__c_container] + Widget( )\height[#__c_frame] - _this_\y[#__c_required] 
            _this_\height[#__c_required] = Widget( )\y[#__c_container] + Widget( )\height[#__c_frame] - _this_\y[#__c_required] 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If Bar_Updates( _this_, 0, 0, _this_\width[#__c_container], _this_\height[#__c_container] )
        
        _this_\width[#__c_inner] = _this_\scroll\h\bar\page\len
        _this_\height[#__c_inner] = _this_\scroll\v\bar\page\len
        
        If _this_\container 
          If StartEnumerate( _this_ )
            ; If widget( )\parent = _this_
            Reclip( Widget( ), 0 ); #True )
                                  ; EndIf
            StopEnumerate( )
          EndIf
        EndIf
      EndIf
      
    EndMacro
    
    ;-  -----------------
    ;-   DECLARE_globals
    ;-  -----------------
    Global _macro_call_count_
    Global *include.allocate( INCLUDE )
    
    ;-  -------------------
    ;-   DECLARE_functions
    ;-  -------------------
    ;{
    ; Requester
    Global resize_one
    
    Declare Message( Title.s, Text.s, Flag.i = #Null )
    
    Declare.i Tree_properties( x.l,y.l,width.l,height.l, Flag.i = 0 )
    
    Declare a_init( *this, grid_size.a = 7, grid_type.b = 0 )
    Declare a_set( *this, size.l = #__a_size, position.l = #PB_Ignore )
    Declare a_update( *parent )
    
    Macro a_reset( )
      ; reset multi group
      If ListSize( transform( )\group( ) )
        ForEach transform( )\group( )
          transform( )\group( )\widget\_a_transform = 1
          transform( )\group( )\widget\root\_a_transform = 1
          transform( )\group( )\widget\parent\_a_transform = 1
        Next
        
        transform( )\id[0]\x = 0
        transform( )\id[0]\y = 0
        transform( )\id[0]\width = 0
        transform( )\id[0]\height = 0
        ClearList( transform( )\group( ) )
      EndIf
    EndMacro
    
    Declare   SetFrame( *this, size.a, mode.i = 0 )
    
    
    Declare.i TypeFromClass( class.s )
    Declare.s ClassFromType( type.i )
    Declare.b IsContainer( *this )
    
    Declare.b Draw( *this )
    Declare   ReDraw( *this )
    
    Declare.l GetMousex( *this, mode.l = #__c_screen )
    Declare.l GetMouseY( *this, mode.l = #__c_screen )
    
    Declare.l x( *this, mode.l = #__c_frame )
    Declare.l Y( *this, mode.l = #__c_frame )
    Declare.l Width( *this, mode.l = #__c_frame )
    Declare.l Height( *this, mode.l = #__c_frame )
    
    Declare.b Hide( *this, State.b = #PB_Default )
    Declare.b Disable( *this, State.b = #PB_Default )
    Declare.i Sticky( *window = #PB_Default, state.b = #PB_Default )
    
    Declare.b Update( *this )
    Declare   Child( *this, *parent )
    Declare.b Change( *this, ScrollPos.f )
    Declare   Flag( *this, flag.i = #Null, state.b = #PB_Default )
    Declare.b Resize( *this, ix.l,iy.l,iwidth.l,iheight.l )
    
    Declare.l CountItems( *this )
    Declare.l ClearItems( *this )
    Declare   RemoveItem( *this, Item.l ) 
    
    ;;Declare.b GetFocus( *this )
    Declare.l GetIndex( *this )
    Declare   GetWidget( index )
    
    Declare.l GetDeltax( *this )
    Declare.l GetDeltaY( *this )
    Declare.l GetLevel( *this )
    Declare.l GetButtons( *this )
    Declare.l GetType( *this )
    Declare.i GetRoot( *this )
    
    Declare.i GetWindow( *this )
    Declare.i GetGadget( *this = #Null )
    
    Declare.l GetCount( *this, mode.b = #False )
    Declare.i GetItem( *this, parent_sublevel.l =- 1 )
    
    Declare   GetLast( *last, tabindex.l )
    
    Declare.i GetAddress( *this )
    ; 
    Declare.i SetActive( *this )
    
    Declare.s GetClass( *this )
    Declare   SetClass( *this, class.s )
    
    Declare.s GetText( *this )
    Declare   SetText( *this, Text.s )
    
    Declare.i GetData( *this )
    Declare.i SetData( *this, *data )
    
    Declare.i GetFont( *this )
    Declare.i SetFont( *this, FontID.i )
    
    Declare.f GetState( *this )
    Declare.b SetState( *this, state.f )
    
    Declare.i GetParent( *this )
    Declare   SetParent( *this, *parent, tabindex.l = 0 )
    
    Declare.l GetColor( *this, ColorType.l )
    Declare.l SetColor( *this, ColorType.l, Color.l )
    
    Declare.i GetAttribute( *this, Attribute.l )
    Declare.i SetAttribute( *this, Attribute.l, *value )
    
    Declare   GetPosition( *this, position.l )
    Declare   SetPosition( *this, position.l, *widget = #Null )
    
    ;
    Declare.l GetItemState( *this, Item.l )
    Declare.b SetItemState( *this, Item.l, State.b )
    
    Declare.i GetItemData( *this, item.l )
    Declare.i SetItemData( *this, item.l, *data )
    
    Declare.s GetItemText( *this, Item.l, Column.l = 0 )
    Declare.l SetItemText( *this, Item.l, Text.s, Column.l = 0 )
    
    Declare.i GetItemImage( *this, Item.l )
    Declare.i SetItemImage( *this, Item.l, Image.i )
    
    Declare.i GetItemFont( *this, Item.l )
    Declare.i SetItemFont( *this, Item.l, Font.i )
    
    Declare.l GetItemColor( *this, Item.l, ColorType.l, Column.l = 0 )
    Declare.l SetItemColor( *this, Item.l, ColorType.l, Color.l, Column.l = 0 )
    
    Declare.i GetItemAttribute( *this, Item.l,  Attribute.l, Column.l = 0 )
    Declare.i SetItemAttribute( *this, Item.l, Attribute.l, *value, Column.l = 0 )
    
    Declare   SetCursor( *this, *cursor )
    Declare.i SetAlignment( *this, Mode.l, Type.l = 1 )
    
    Declare   SetImage( *this, *image )
    Declare   SetBackgroundImage( *this, *image )
    
    Declare.i Create( *parent, class.s, type.l, x.l,y.l,width.l,height.l, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, Text.s = #Null$, flag.i = #Null, size.l = 0, round.l = 7, ScrollStep.f = 1.0 )
    
    ; button
    Declare.i Text( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
    Declare.i String( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
    Declare.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
    Declare.i Option( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
    Declare.i Checkbox( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
    Declare.i HyperLink( x.l,y.l,width.l,height.l, Text.s, Color.i, Flag.i = 0 )
    
    ; bar
    ;Declare.i Area( *parent, ScrollStep, AreaWidth, AreaHeight, width, height, Mode = 1 )
    Declare.i Spin( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, increment.f = 1.0 )
    Declare.i Tab( x.l,y.l,width.l,height.l, Flag.i = 0, round.l = 0 )
    Declare.i Scroll( x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0 )
    Declare.i Track( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7 )
    Declare.i Progress( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0 )
    Declare.i Splitter( x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i = 0 )
    
    ; list
    Declare.i Tree( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare.i ListView( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare.i Editor( x.l, Y.l, width.l,height.l, Flag.i = 0, round.i = 0 )
    Declare.i ListIcon( x.l,y.l,width.l,height.l, ColumnTitle.s, ColumnWidth.i, flag.i=0 )
    
    Declare.i ExplorerList( x.l,y.l,width.l,height.l, Directory.s, flag.i=0 )
    
    Declare.i Image( x.l,y.l,width.l,height.l, image.i, Flag.i = 0 )
    Declare.i ButtonImage( x.l,y.l,width.l,height.l, Image.i = -1, Flag.i = 0, round.l = 0 )
    
    ; container
    Declare.i Panel( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare.i Container( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare.i Frame( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
    Declare.i Window( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, *parent = 0 )
    Declare.i ScrollArea( x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0 )
    Declare.i MDI( x.l,y.l,width.l,height.l, Flag.i = 0 ) 
    
    ; menu
    Declare   ToolBar( *parent, flag.i = #PB_ToolBar_Small )
    ;     Declare   Menus( *parent, flag.i )
    ;     Declare   PopupMenu( *parent, flag.i )
    
    Declare   EventHandler ( )
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    
    Declare.i Tab_SetState( *this._s_WIDGET, State.l )
    Declare   Bar_Updates( *this, x.l,y.l,width.l,height.l )
    Declare   Bar_Resizes( *this, x.l,y.l,width.l,height.l )
    Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.i = 0 )
    Declare   AddColumn( *this, Position.l, Text.s, Width.l, Image.i =- 1 )
    
    Declare.b Arrow( x.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
    
    Declare   Free( *this )
    Declare.i Bind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Unbind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Post( eventtype.l, *this, *button = #PB_All, *data = #Null )
    
    ;
    Declare   DoEvents( *this, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    Declare.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l,height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  Window = -1, *CallBack = #Null )
    ;}
    
  EndDeclareModule
  
  Module Widget
    ;-
    ;- DECLARE_private_functions
    ;-
    
    Declare.b Tab_Draw( *this )
    Declare.b Bar_Update( *this )
    Declare.b Bar_Resize( *this )
    Declare.b Bar_SetState( *this, state.f )
    
    Macro _set_cursor_( _this_, _cursor_ )
      If _this_\root\cursor <> _cursor_ 
        _this_\root\cursor = _cursor_
        ;Debug ""+89898 +" "+ _cursor_
        If _cursor_ < 65560
          SetGadgetAttribute( _this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_ )
        Else
          SetGadgetAttribute( _this_\root\canvas\gadget, #PB_Canvas_CustomCursor, func::CreateCursor( _cursor_ ) )
        EndIf
      EndIf
    EndMacro
    
    Macro _cursor_set_( _this_ )
      If Not mouse( )\buttons And
         ; _this_\color\state = #__s_1 And 
        _this_\cursor And Not _is_selected_( _this_ ) 
        
        _set_cursor_( _this_, _this_\cursor )
      EndIf
    EndMacro
    
    Macro _cursor_remove_( _this_ )
      If Not mouse( )\buttons
        ; Debug "remove cursor "+_this_ +" "+ EnterWidget( )
        
        If EnterWidget( ) And EnterWidget( )\cursor And EnterWidget( )\cursor <> EnterWidget( )\root\cursor ; Not _is_root_( EnterWidget( ) )  
          _set_cursor_( _this_, EnterWidget( )\cursor )
        Else
          _set_cursor_( _this_, #PB_Cursor_Default )
        EndIf
      EndIf
    EndMacro
    
    
    Declare   DoEvents( *this, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
    ;-
    Procedure   CreateIcon( img.l, type.l )
      Protected x,y,Pixel, size = 8, index.i
      
      index = CreateImage( img, size, size ) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing( ImageOutput( img ) )
        Box( 0, 0, size, size, $fff0f0f0 );GetSysColor_( #COLOR_bTNFACE ) )
        
        If type = 1
          Restore img_arrow_down
          For y = 0 To size - 1
            For x = 0 To size - 1
              Read.b Pixel
              
              If Pixel
                Plot( x, y, $000000 )
              EndIf
            Next x
          Next y
          
        ElseIf type = 2
          Restore img_arrow_down
          For y = size - 1 To 0 Step -1
            For x = 0 To size - 1
              Read.b Pixel
              
              If Pixel
                Plot( x, y, $000000 )
              EndIf
            Next x
          Next y
        EndIf 
        StopDrawing( )
      EndIf
      
      DataSection
        
        img_arrow_down:
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        
        
        ;       img_arrow_>:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
        ;       img_arrow_v:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,0,0,0,1,0,0
        ;       Data.b 0,1,1,0,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       
        ;       img_close
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
      EndDataSection
    EndProcedure
    
    Procedure   DrawArrow( x.l, y.l, Direction.l, color.l )
      
      If Direction = 0
        ; left                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,0,0,0,0,0
        
        :                                                           : Plot( x + 3, y + 1, color )                        
        :                             : Plot( x + 2, y + 2, color ) : Plot( x + 4, y + 1, color )                     
        :                             : Plot( x + 3, y + 2, color ) : Plot( x + 5, y + 1, color )
        : Plot( x + 1, y + 3, color ) : Plot( x + 4, y + 2, color )
        : Plot( x + 2, y + 3, color )                                                                       
        : Plot( x + 3, y + 3, color ) : Plot( x + 2, y + 4, color )                          
        :                             : Plot( x + 3, y + 4, color )     
        :                             : Plot( x + 4, y + 4, color ) : Plot( x + 3, y + 5, color ) 
        :                                                           : Plot( x + 4, y + 5, color )                       
        :                                                           : Plot( x + 5, y + 5, color )  
      EndIf
      
      If Direction = 1
        ; up                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,1,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,0,0,0,1,0
        ; 0,0,0,0,0,0,0
        
        :                                                           : Plot( x + 3, y + 1, color ) 
        :                             : Plot( x + 2, y + 2, color ) : Plot( x + 3, y + 2, color ) : Plot( x + 4, y + 2, color ) 
        : Plot( x + 1, y + 3, color ) : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 5, y + 3, color )
        : Plot( x + 1, y + 4, color ) : Plot( x + 2, y + 4, color )                               : Plot( x + 4, y + 4, color ) : Plot( x + 5, y + 4, color )
        : Plot( x + 1, y + 5, color )                                                                                           : Plot( x + 5, y + 5, color )
      EndIf
      
      If Direction = 2
        ; right                                                 
        ; 0,0,0,0,0,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot( x + 1, y + 1, color )                        
        : Plot( x + 2, y + 1, color ) : Plot( x + 2, y + 2, color )                      
        : Plot( x + 3, y + 1, color ) : Plot( x + 3, y + 2, color ) 
        :                             : Plot( x + 4, y + 2, color ) : Plot( x + 3, y + 3, color )
        :                                                           : Plot( x + 4, y + 3, color )                        
        :                             : Plot( x + 2, y + 4, color ) : Plot( x + 5, y + 3, color )                          
        :                             : Plot( x + 3, y + 4, color )     
        : Plot( x + 1, y + 5, color ) : Plot( x + 4, y + 4, color )
        : Plot( x + 2, y + 5, color )                       
        : Plot( x + 3, y + 5, color )  
      EndIf
      
      If Direction = 3
        ; down
        ; 0,0,0,0,0,0,0
        ; 0,1,0,0,0,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,1,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot( x + 1, y + 1, color )                                                                                           : Plot( x + 5, y + 1, color )
        : Plot( x + 1, y + 2, color ) : Plot( x + 2, y + 2, color )                               : Plot( x + 4, y + 2, color ) : Plot( x + 5, y + 2, color )
        : Plot( x + 1, y + 3, color ) : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 5, y + 3, color )
        :                             : Plot( x + 2, y + 4, color ) : Plot( x + 3, y + 4, color ) : Plot( x + 4, y + 4, color )
        :                                                           : Plot( x + 3, y + 5, color )
      EndIf
      
      If Direction = 11
        ; select_bottom
        ; 0,0,0,0,0,1,0,0,0,0,0
        ; 0,0,0,0,1,1,1,0,0,0,0
        ; 0,0,0,1,1,0,1,1,0,0,0
        ; 0,0,1,1,0,0,0,1,1,0,0
        ; 0,1,1,0,0,0,0,0,1,1,0
        ; 1,1,0,0,0,0,0,0,0,1,1
        
        : Plot( x+5, y, color ) 
        : Plot( x+4, y+1, color ) : Plot( x+5, y+1, color ) : Plot( x+6, y+1, color ) 
        : Plot( x+3, y+2, color ) : Plot( x+4, y+2, color )         : Plot( x+6, y+2, color ) : Plot( x+7, y+2, color )
        : Plot( x+2, y+3, color ) : Plot( x+3, y+3, color )         : Plot( x+7, y+3, color ) : Plot( x+8, y+3, color )
        : Plot( x+1, y+4, color ) : Plot( x+2, y+4, color )         : Plot( x+8, y+4, color ) : Plot( x+9, y+4, color )
        : Plot( x, y+5, color )   : Plot( x+1, y+5, color )         : Plot( x+9, y+5, color ) : Plot( x+10, y+5, color )
        
        :                                                           
      EndIf
      
      If Direction = 33
        ; select_bottom
        ; 1,1,0,0,0,0,0,0,0,1,1
        ; 0,1,1,0,0,0,0,0,1,1,0
        ; 0,0,1,1,0,0,0,1,1,0,0
        ; 0,0,0,1,1,0,1,1,0,0,0
        ; 0,0,0,0,1,1,1,0,0,0,0
        ; 0,0,0,0,0,1,0,0,0,0,0
        
        : Plot( x, y, color )     : Plot( x+1, y, color )           : Plot( x+9, y, color )   : Plot( x+10, y, color )
        : Plot( x+1, y+1, color ) : Plot( x+2, y+1, color )         : Plot( x+8, y+1, color ) : Plot( x+9, y+1, color )
        : Plot( x+2, y+2, color ) : Plot( x+3, y+2, color )         : Plot( x+7, y+2, color ) : Plot( x+8, y+2, color )
        : Plot( x+3, y+3, color ) : Plot( x+4, y+3, color )         : Plot( x+6, y+3, color ) : Plot( x+7, y+3, color )
        : Plot( x+4, y+4, color ) : Plot( x+5, y+4, color ) : Plot( x+6, y+4, color ) 
        : Plot( x+5, y+5, color ) 
        
        :                                                           
      EndIf
      
    EndProcedure
    
    Procedure.b Arrow( x.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
      ; ProcedureReturn DrawArrow( x,y, Direction, Color )
      
      Protected I
      ;Size - 2
      
      If Not Length
        Style =- 1
      EndIf
      Length = ( Size + 2 )/2
      
      
      If Direction = 1 ; top
        If Style > 0 : x - 1 : y + 2
          Size / 2
          For i = 0 To Size 
            LineXY( ( x + 1 + i ) + Size,( Y + i - 1 ) - ( Style ),( x + 1 + i ) + Size,( Y + i - 1 ) + ( Style ),Color )         ; Левая линия
            LineXY( ( ( x + 1 + ( Size ) ) - i ),( Y + i - 1 ) - ( Style ),( ( x + 1 + ( Size ) ) - i ),( Y + i - 1 ) + ( Style ),Color ) ; правая линия
          Next
        Else : x - 1 : y - 1
          For i = 1 To Length 
            If Style =- 1
              LineXY( x + i, ( Size + y ), x + Length, y, Color )
              LineXY( x + Length*2 - i, ( Size + y ), x + Length, y, Color )
            Else
              LineXY( x + i, ( Size + y ) - i/2, x + Length, y, Color )
              LineXY( x + Length*2 - i, ( Size + y ) - i/2, x + Length, y, Color )
            EndIf
          Next 
          i = Bool( Style =- 1 ) 
          LineXY( x, ( Size + y ) + Bool( i = 0 ), x + Length, y + 1, Color ) 
          LineXY( x + Length*2, ( Size + y ) + Bool( i = 0 ), x + Length, y + 1, Color ) ; bug
        EndIf
      ElseIf Direction = 3 ; bottom
        If Style > 0 : x - 1 : y + 1;2
          Size / 2
          For i = 0 To Size
            LineXY( ( x + 1 + i ),( Y + i ) - ( Style ),( x + 1 + i ),( Y + i ) + ( Style ),Color ) ; Левая линия
            LineXY( ( ( x + 1 + ( Size*2 ) ) - i ),( Y + i ) - ( Style ),( ( x + 1 + ( Size*2 ) ) - i ),( Y + i ) + ( Style ),Color ) ; правая линия
          Next
        Else : x - 1 : y + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY( x + i, y, x + Length, ( Size + y ), Color )
              LineXY( x + Length*2 - i, y, x + Length, ( Size + y ), Color )
            Else
              LineXY( x + i, y + i/2 - Bool( i = 0 ), x + Length, ( Size + y ), Color )
              LineXY( x + Length*2 - i, y + i/2 - Bool( i = 0 ), x + Length, ( Size + y ), Color )
            EndIf
          Next
        EndIf
      ElseIf Direction = 0 ; в лево
        If Style > 0 : y - 1
          Size / 2
          For i = 0 To Size 
            ; в лево
            LineXY( ( ( x + 1 ) + i ) - ( Style ),( ( ( Y + 1 ) + ( Size ) ) - i ),( ( x + 1 ) + i ) + ( Style ),( ( ( Y + 1 ) + ( Size ) ) - i ),Color ) ; правая линия
            LineXY( ( ( x + 1 ) + i ) - ( Style ),( ( Y + 1 ) + i ) + Size,( ( x + 1 ) + i ) + ( Style ),( ( Y + 1 ) + i ) + Size,Color )                 ; Левая линия
          Next  
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style =- 1
              LineXY( ( Size + x ), y + i, x, y + Length, Color )
              LineXY( ( Size + x ), y + Length*2 - i, x, y + Length, Color )
            Else
              LineXY( ( Size + x ) - i/2, y + i, x, y + Length, Color )
              LineXY( ( Size + x ) - i/2, y + Length*2 - i, x, y + Length, Color )
            EndIf
          Next 
          i = Bool( Style =- 1 ) 
          LineXY( ( Size + x ) + Bool( i = 0 ), y, x + 1, y + Length, Color ) 
          LineXY( ( Size + x ) + Bool( i = 0 ), y + Length*2, x + 1, y + Length, Color )
        EndIf
      ElseIf Direction = 2 ; в право
        If Style > 0 : y - 1 ;: x + 1
          Size / 2
          For i = 0 To Size 
            ; в право
            LineXY( ( ( x + 1 ) + i ) - ( Style ),( ( Y + 1 ) + i ),( ( x + 1 ) + i ) + ( Style ),( ( Y + 1 ) + i ),Color ) ; Левая линия
            LineXY( ( ( x + 1 ) + i ) - ( Style ),( ( ( Y + 1 ) + ( Size*2 ) ) - i ),( ( x + 1 ) + i ) + ( Style ),( ( ( Y + 1 ) + ( Size*2 ) ) - i ),Color ) ; правая линия
          Next
        Else : y - 1 : x + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY( x, y + i, Size + x, y + Length, Color )
              LineXY( x, y + Length*2 - i, Size + x, y + Length, Color )
            Else
              LineXY( x + i/2 - Bool( i = 0 ), y + i, Size + x, y + Length, Color )
              LineXY( x + i/2 - Bool( i = 0 ), y + Length*2 - i, Size + x, y + Length, Color )
            EndIf
          Next
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i Match( *value, Grid.i, Max.i = $7FFFFFFF )
      If Grid 
        *value = Round( ( *value/Grid ), #PB_Round_Nearest ) * Grid 
        
        If *value > Max 
          *value = Max 
        EndIf
      EndIf
      
      ProcedureReturn *value
      ;   Procedure.i Match( *value.i, Grid.i, Max.i = $7FFFFFFF )
      ;     ProcedureReturn ( ( Bool( *value>Max ) * Max ) + ( Bool( Grid And *value<Max ) * ( Round( ( *value/Grid ), #PB_round_nearest ) * Grid ) ) )
    EndProcedure
    
    Procedure   Draw_Datted( x, Y, SourceColor, TargetColor )
      Static Len.b
      Protected Color,
                Dot = transform( )\dotted\dot, 
                Space.b = transform( )\dotted\space, 
                line.b = transform( )\dotted\line
      
      If ( ( Len % ( Line + Space*2 - 1 ) ) < line )
        If Len > Line
          Len = 0
        EndIf
        Color = SourceColor
      Else
        If Dot And ( Len % ( Line + Space - 1 ) = 0 ) 
          Color = SourceColor
        Else
          Color = TargetColor
        EndIf
      EndIf
      ;       If Len < ( line + Space )
      ;         If ( Len % ( Line + Space ) ) * 2 > Space 
      ;           Color = SourceColor
      ;         Else
      ;           Color = TargetColor
      ;         EndIf
      ;         Len + 1
      ;       Else;If Len = line
      ;         Color = TargetColor
      ;         Len =- 1
      ;       EndIf
      
      Len + 1
      ProcedureReturn Color
    EndProcedure
    
    Procedure   Draw_Plot( x, Y, SourceColor, TargetColor )
      Protected Color
      
      If (y%2 And Not x%2) Or
         (x%2 And Not y%2)
        
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;-
    #PB_Drop_Item =- 5
    #PB_Cursor_Drag = 50
    #PB_Cursor_Drop = 51
    #PB_Drag_Drop = 32
    
    ;     Global *drop._s_DD
    ;     Global NewMap *droped._s_DD( )
    
    Macro _DD_drop_( )
      EnterWidget( )\drop
      ; *drop
    EndMacro
    
    Macro _DD_drag_( )
      mouse()\_drag
    EndMacro
    
    Macro _DD_action_( )
      Bool( _DD_drop_( ) And _DD_drag_( ) And 
            _DD_drop_( )\format = _DD_drag_( )\format And 
            _DD_drop_( )\actions & _DD_drag_( )\actions And
            _DD_drop_( )\PrivateType = _DD_drag_( )\PrivateType )
    EndMacro
    
    Macro _DD_event_enter_( _result_, _this_ )
      If _this_\_state & #__s_dropped = #False
        _this_\_state | #__s_dropped
        
        If _DD_drag_( ) 
          ; _DD_drop_( ) = _this_\drop
          
          ; If FindMapElement( *droped( ), Hex( _this_ ) )
          ;   _DD_drop_( ) = *droped( )
          ; Else
          ;   _DD_drop_( ) = #Null
          ; EndIf
          
          If _DD_action_( )
            DD_cursor( #PB_Cursor_Drop )
          Else
            DD_cursor( #PB_Cursor_Drag )
          EndIf
          
          _result_ = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _DD_event_leave_( _result_, _this_ )
      If _this_\_state & #__s_dropped
        _this_\_state &~ #__s_dropped
        
        If _DD_drag_( ) 
          DD_cursor( #PB_Cursor_Drag )
          _result_ = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _DD_event_drag_( _result_, _this_, _mouse_x_, _mouse_y_ )
      If _this_\_state & #__s_dragged = #False
        _this_\_state | #__s_dragged | #__s_dropped
        
        DoEvents( _this_, #__event_DragStart, _mouse_x_, _mouse_y_ )
        
        If _DD_drag_( )
          If Not _this_\container
            DD_cursor( #PB_Cursor_Drag )
          EndIf
          
          _result_ = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _DD_event_drop_( _result_, _this_, _mouse_x_, _mouse_y_ )
      If _DD_drag_( )
        _this_\_state &~ #__s_dragged
        
        ;; DD_cursor( #PB_Cursor_Default )
        If _is_root_( _this_ ) 
          SetCursor( _this_, #PB_Cursor_Default )
        Else
          SetCursor( _this_, _this_\cursor )
        EndIf
        
        If _DD_action_( )
          ; drag stop 
          ;           If transform( )\grab
          If transform( ) And
             transform( )\type
            
            _DD_drag_( )\x = transform( )\id[0]\x - _this_\x[#__c_inner]
            _DD_drag_( )\y = transform( )\id[0]\y - _this_\y[#__c_inner]
            
            _DD_drag_( )\width = transform( )\id[0]\width 
            _DD_drag_( )\height = transform( )\id[0]\height 
            
            transform( )\type = 0
          Else
            _DD_drag_( )\x = _mouse_x_ - _this_\x[#__c_inner]
            _DD_drag_( )\y = _mouse_y_ - _this_\y[#__c_inner]
          EndIf
          
          ;             transform( )\grab = 0
          ;           EndIf
          
          DoEvents( _this_, #__event_Drop, _mouse_x_, _mouse_y_ )
        EndIf
        
        ; reset
        FreeStructure( _DD_drag_( ) ) : _DD_drag_( ) = #Null
        _DD_event_leave_( _result_, _this_ )
        _post_repaint_( _this_\root )
        
        ;         If _result_
        ;           ;_get_entered_( _result_ )
        ;           EventHandler( )
        ;         EndIf
        
      EndIf
    EndMacro
    
    ;
    Procedure.i DD_cursor( type )
      Protected x = 2, y = 2, cursor
      UsePNGImageDecoder( )
      
      If type = #PB_Cursor_Drop
        cursor = CatchImage( #PB_Any, ?add, 601 )
      ElseIf type = #PB_Cursor_Drag
        cursor = CatchImage( #PB_Any, ?copy, 530 )
      EndIf
      
      ;SetCursor( EnterWidget( )\root, ImageID( cursor ) )
      If cursor
        If Root( )\cursor <> cursor
          Root( )\cursor = cursor
          SetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_CustomCursor, func::CreateCursor( ImageID( cursor ), x, y ) )
        EndIf
      EndIf
      
      DataSection
        add: ; memory_size - ( 601 )
        Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000017000000,$0FBDF60000000408,$4D416704000000F5,$61FC0B8FB1000041,
               $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
               $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
               $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$3854414449300100,$1051034ABB528DCB,
               $58DB084146C5293D,$82361609B441886C,$AA4910922C455E92,$C2C105F996362274,$FC2FF417B0504FC2,$DEF7BB3BB9ACF1A0,
               $B99CE66596067119,$2DB03A16C1101E67,$12D0B4D87B0D0B8F,$11607145542B450C,$190D04A4766FDCAA,$4129428FD14DCD04,
               $98F0D525AEFE8865,$A1C4924AD95B44D0,$26A2499413E13040,$F4F9F612B8726298,$62A6ED92C07D5B54,$E13897C2BE814222,
               $A75C5C6365448A6C,$D792BBFAE41D2925,$1A790C0B8161DC2F,$224D78F4C611BD60,$A1E8C72566AB9F6F,$2023A32BDB05D21B,
               $0E3BC7FEBAF316E4,$8E25C73B08CF01B1,$385C7629FEB45FBE,$8BB5746D80621D9F,$9A5AC7132FE2EC2B,$956786C4AE73CBF3,
               $FE99E13C707BB5EB,$C2EA47199109BF48,$01FE0FA33F4D71EF,$EE0F55B370F8C437,$F12CD29C356ED20C,$CBC4BD4A70C833B1,
               $FFCD97200103FC1C,$742500000019D443,$3A65746164745845,$3200657461657263,$312D38302D393130,$3A35313A31315439,
               $30303A30302B3930,$25000000B3ACC875,$6574616474584574,$00796669646F6D3A,$2D38302D39313032,$35313A3131543931,
               $303A30302B35303A,$0000007B7E35C330,$6042AE444E454900
        Data.b $82
        add_end:
        ;     EndDataSection
        ;       
        ;     DataSection
        copy: ; memory_size - ( 530 )
        Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000010000000,$1461140000000408,$4D4167040000008C,$61FC0B8FB1000041,
               $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
               $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
               $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$2854414449E90000,$1040C20A31D27DCF,
               $8B08226C529FD005,$961623685304458D,$05E8A288B1157A4A,$785858208E413C44,$AD03C2DE8803C505,$74CCDD93664D9893,
               $5C25206CCCECC7D9,$0AF51740A487B038,$E4950624ACF41B10,$0B03925602882A0F,$504520607448C0E1,$714E75682A0F7A22,
               $1EC4707FBC91940F,$EF1F26F801E80C33,$6FE840E84635C148,$47D13D78D54EC071,$5BDF86398A726F4D,$7DD0539F268C6356,
               $39B40B3759101A3E,$2EEB2D02D7DBC170,$49172CA44A415AD2,$52B82E69FF1E0AC0,$CC0D0D97E9B7299E,$046FA509CA4B09C0,
               $CB03993630382B86,$5E4840261A49AA98,$D3951E21331B30CF,$262C1B127F8F8BD3,$250000007DB05216,$6574616474584574,
               $006574616572633A,$2D38302D39313032,$35313A3131543931,$303A30302B37303A,$000000EED7F72530,$7461647458457425,
               $796669646F6D3A65,$38302D3931303200,$313A31315439312D,$3A30302B35303A35,$00007B7E35C33030,$42AE444E45490000
        Data.b $60,$82
        copy_end:
      EndDataSection
    EndProcedure
    
    Procedure   DD_draw( *this._s_WIDGET )
      ; if you drag to the widget-dropped
      If _DD_drag_( ) And *this\_state & #__s_dropped
        
        DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
        
        If _DD_drop_( ) ; *this\drop 
          If _DD_action_( )
            If EnterRow( ) And EnterRow( )\_state & #__s_entered
              Box( EnterRow( )\x, EnterRow( )\y, EnterRow( )\width, EnterRow( )\height, $2000ff00 )
            EndIf  
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $1000ff00 )
          Else
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff0000 )
          EndIf
        Else
          If *this\_state & #__s_dragged 
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff00ff )
          Else
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $100000ff )
          EndIf
        EndIf
        
        DrawingMode( #PB_2DDrawing_Outlined )
        
        If _DD_drop_( ) ; *this\drop 
          If _DD_action_( )
            If EnterRow( ) And EnterRow( )\_state & #__s_entered
              Box( EnterRow( )\x, EnterRow( )\y, EnterRow( )\width, EnterRow( )\height, $ff00ff00 )
            EndIf
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff00ff00 )
          Else
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
          EndIf
        Else
          If *this\_state & #__s_dragged 
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff00ff )
          Else
            Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff0000ff )
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    
    Procedure.l DD_DropX( )
      ProcedureReturn _DD_drag_( )\x
    EndProcedure
    
    Procedure.l DD_DropY( )
      ProcedureReturn _DD_drag_( )\y
    EndProcedure
    
    Procedure.l DD_DropWidth( )
      ProcedureReturn _DD_drag_( )\width
    EndProcedure
    
    Procedure.l DD_DropHeight( )
      ProcedureReturn _DD_drag_( )\height
    EndProcedure
    
    Procedure.i DD_DropType( )
      If _DD_action_( ) 
        ProcedureReturn _DD_drop_( )\Format 
      EndIf
    EndProcedure
    
    Procedure.i DD_DropAction( )
      If _DD_action_( ) 
        ProcedureReturn _DD_drop_( )\Actions 
      EndIf
    EndProcedure
    
    Procedure.s DD_DropFiles( )
      If _DD_action_( )
        Debug "   event drop files - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.s DD_DropText( )
      If _DD_action_( )
        Debug "   event drop text - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.i DD_DropPrivate( )
      If _DD_action_( )
        Debug "   event drop type - "+_DD_drag_( )\PrivateType
        ProcedureReturn _DD_drag_( )\PrivateType
      EndIf
    EndProcedure
    
    Procedure.i DD_DropImage( Image.i = -1, Depth.i = 24 )
      Protected result.i
      
      If _DD_action_( ) And _DD_drag_( )\value
        Debug "   event drop image - "+_DD_drag_( )\value
        
        If Image  = - 1
          Result = CreateImage( #PB_Any, _DD_drag_( )\Width, _DD_drag_( )\Height ) : Image = Result
        Else
          Result = IsImage( Image )
        EndIf
        
        If Result And StartDrawing( ImageOutput( Image ) )
          If Depth = 32
            DrawAlphaImage( _DD_drag_( )\value, 0, 0 )
          Else
            DrawImage( _DD_drag_( )\value, 0, 0 )
          EndIf
          StopDrawing( )
        EndIf  
        
        ProcedureReturn Result
      EndIf
    EndProcedure
    
    Procedure.i DD_DropEnable( *this._s_WIDGET, Format.i, Actions.i, PrivateType.i = 0 )
      ;                        ; windows ;    macos   ; linux ;
      ; = Format
      ; #PB_Drop_Text          ; = 1     ; 1413830740 ; -1    ; Accept text on this widget
      ; #PB_Drop_Image         ; = 8     ; 1346978644 ; -2    ; Accept images on this widget
      ; #PB_Drop_Files         ; = 15    ; 1751544608 ; -3    ; Accept filenames on this widget
      ; #PB_Drop_Private       ; = 512   ; 1885499492 ; -4    ; Accept a "private" Drag & Drop on this gadgetProtected Result.i
      
      ; & Actions
      ; #PB_Drag_None          ; = 0     ; 0          ; 0     ; The Data format will Not be accepted on the widget
      ; #PB_Drag_Copy          ; = 1     ; 1          ; 2     ; The Data can be copied
      ; #PB_Drag_Move          ; = 2     ; 16         ; 4     ; The Data can be moved
      ; #PB_Drag_Link          ; = 4     ; 2          ; 8     ; The Data can be linked
      
      ; SetDragCallback( )
      ; 'State' specifies the current state of the Drag & Drop operation and is one of the following values:
      ; #PB_Drag_Enter         ; = 1     ; 1          ; 1     ; The mouse entered the gadget Or window
      ; #PB_Drag_Update        ; = 2     ; 2          ; 2     ; The mouse was moved inside the gadget Or window, Or the intended action changed
      ; #PB_Drag_Leave         ; = 3     ; 3          ; 3     : The mouse left the gadget Or window (Format, Action, x, y are 0 here)
      ; #PB_Drag_Finish        ; = 4     ; 4          ; 4     : The Drag & Drop finished
      ;     
      
      ; If Not FindMapElement( *droped( ), Hex( *this ) )
      ;   Debug "Enable dropped - " + *this
      ;   AddMapElement( *droped( ), Hex( *this ) )
      ;   *droped.allocate( DD, ( ) )
      ; EndIf
      ; 
      ; *droped( )\format = Format
      ; *droped( )\actions = Actions
      ; *droped( )\PrivateType = PrivateType
      
      If Not *this\drop
        Debug "Enable dropped - " + *this
        *this\drop.allocate( DD )
      EndIf
      
      *this\drop\format = Format
      *this\drop\actions = Actions
      *this\drop\PrivateType = PrivateType
    EndProcedure
    
    
    Procedure.i DD_EventDragItem( *row, Actions.i = #PB_Drag_Copy )
      Debug "  drag Item - " + *row
      
      If *row
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Item
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\value = *row
      EndIf
    EndProcedure
    
    Procedure.i DD_EventDragText( Text.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag text - " + Text
      
      If Text
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Text
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\string = Text
      EndIf
    EndProcedure
    
    Procedure.i DD_EventDragImage( Image.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag image - " + Image
      
      If IsImage( Image )
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Image
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\value = ImageID( Image )
        _DD_drag_( )\width = ImageWidth( Image )
        _DD_drag_( )\height = ImageHeight( Image )
      EndIf
    EndProcedure
    
    Procedure.i DD_EventDragFiles( Files.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag files - " + Files
      
      If Files
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Files
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\string = Files
      EndIf
    EndProcedure
    
    Procedure.i DD_EventDragPrivate( PrivateType.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag private - " + PrivateType
      
      If PrivateType
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Private
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\PrivateType = PrivateType
      EndIf
    EndProcedure
    
    ;- 
    ;-  ANCHORs
    Structure _s_DATA_TRANSFORM_CURSOR
      cursor.i[#__a_count+1]
    EndStructure
    
    DataSection
      DATA_TRANSFORM_CURSOR:
      Data.i #PB_Cursor_Default          ; 0
      Data.i #PB_Cursor_LeftRight        ; 1
      Data.i #PB_Cursor_UpDown           ; 2
      Data.i #PB_Cursor_LeftRight        ; 3
      Data.i #PB_Cursor_UpDown           ; 4
      Data.i #PB_Cursor_LeftUpRightDown  ; 5
      Data.i #PB_Cursor_LeftDownRightUp  ; 6
      Data.i #PB_Cursor_LeftUpRightDown  ; 7
      Data.i #PB_Cursor_LeftDownRightUp  ; 8
      Data.i #PB_Cursor_Arrows           ; 9
      
      Data.i #PB_Cursor_LeftRight        ; 10
      Data.i #PB_Cursor_UpDown           ; 11
      Data.i #PB_Cursor_LeftRight        ; 12
      Data.i #PB_Cursor_UpDown           ; 13
    EndDataSection
    
    Global *Data_Transform_Cursor._s_DATA_TRANSFORM_CURSOR = ?DATA_TRANSFORM_CURSOR
    
    Procedure a_grid_image( Steps = 5, line=0, Color = 0 )
      Static ID
      Protected hDC, x,y
      
      If Not ID
        ;Steps - 1
        
        ExamineDesktops( )
        Protected width = DesktopWidth( 0 )   
        Protected height = DesktopHeight( 0 )
        ID = CreateImage( #PB_Any, width, height, 32, #PB_Image_Transparent )
        
        If Color = 0 : Color = $ff808080 : EndIf
        
        If StartDrawing( ImageOutput( ID ) )
          DrawingMode( #PB_2DDrawing_AllChannels )
          ;Box( 0, 0, width, height, BoxColor )
          
          For x = 0 To width - 1
            
            For y = 0 To height - 1
              
              If line
                Line( x, 0, 1,height, Color )
                Line( 0, y, width,1, Color )
              Else
                Line( x, y, 1,1, Color )
              EndIf
              
              y + Steps
            Next
            
            
            x + Steps
          Next
          
          StopDrawing( )
        EndIf
      EndIf
      
      ProcedureReturn ID
    EndProcedure
    
    Macro a_grid_change( _this_, _redraw_ = #False )
      If transform( )\grid\widget <> _this_
        If transform( )\grid\size > 1 And transform( )\grid\widget
          SetBackgroundImage( transform( )\grid\widget, #PB_Default )
        EndIf
        transform( )\grid\widget = _this_
        
        If _this_\container ;;> 0
          _this_\image[#__img_background]\x =- _this_\fs
          _this_\image[#__img_background]\y =- _this_\fs
        EndIf
        
        If transform( )\grid\size > 1
          SetBackgroundImage( transform( )\grid\widget, transform( )\grid\image )
        EndIf
        
        If _redraw_
          ReDraw( _this_\root )
        EndIf
      EndIf
    EndMacro
    
    Macro a_widget( ) : transform( )\_a_widget: EndMacro
    
    Macro a_size( _address_, _size_ )
      If _address_[1] ; left
        _address_[1]\width = _size_
        _address_[1]\height = _size_
      EndIf
      If _address_[2] ; top
        _address_[2]\width = _size_ 
        _address_[2]\height = _size_
      EndIf
      If _address_[3] ; right
        _address_[3]\width = _size_ 
        _address_[3]\height = _size_
      EndIf
      If _address_[4] ; bottom
        _address_[4]\width = _size_ 
        _address_[4]\height = _size_
      EndIf
      
      If _address_[5] ; left&top
        _address_[5]\width = _size_ 
        _address_[5]\height = _size_
      EndIf
      If _address_[6] ; right&top
        _address_[6]\width = _size_ 
        _address_[6]\height = _size_
      EndIf
      If _address_[7] ; right&bottom
        _address_[7]\width = _size_ 
        _address_[7]\height = _size_
      EndIf
      If _address_[8] ; left&bottom
        _address_[8]\width = _size_ 
        _address_[8]\height = _size_
      EndIf
    EndMacro
    
    Macro a_move( _address_, _x_, _y_, _width_, _height_, _a_moved_type_ = 0 )
      If _address_[0]
        _address_[0]\x = _x_ + transform( )\pos
        _address_[0]\y = _y_ + transform( )\pos
        _address_[0]\width = _width_ - transform( )\pos * 2
        _address_[0]\height = _height_ - transform( )\pos * 2
      EndIf  
      If _address_[1]
        _address_[1]\x = _x_   ; left
        _address_[1]\y = _y_ + ( _height_ - _address_[1]\height )/2
      EndIf
      If _address_[2] ; top
        _address_[2]\x = _x_ + ( _width_ - _address_[2]\width )/2
        _address_[2]\y = _y_
      EndIf
      If  _address_[3] ; right
        _address_[3]\x = _x_ + _width_ - _address_[3]\width 
        _address_[3]\y = _y_ + ( _height_ - _address_[3]\height )/2
      EndIf
      If _address_[4] ; bottom
        _address_[4]\x = _x_ + ( _width_ - _address_[4]\width )/2
        _address_[4]\y = _y_ + _height_ - _address_[4]\height
      EndIf
      
      If _address_[5] ; left&top
        _address_[5]\x = _x_
        _address_[5]\y = _y_
      EndIf
      If _address_[6] ; right&top
        _address_[6]\x = _x_ + _width_ - _address_[6]\width
        _address_[6]\y = _y_
      EndIf
      If _address_[7] ; right&bottom
        _address_[7]\x = _x_ + _width_ - _address_[7]\width
        _address_[7]\y = _y_ + _height_ - _address_[7]\height
      EndIf
      If _address_[8] ; left&bottom
        _address_[8]\x = _x_
        _address_[8]\y = _y_ + _height_ - _address_[8]\height
      EndIf
      
      If _address_[#__a_moved] 
        If _a_moved_type_
          _address_[#__a_moved]\x = _x_
          _address_[#__a_moved]\y = _y_
          _address_[#__a_moved]\width = transform( )\size * 2
          _address_[#__a_moved]\height = transform( )\size * 2
        Else
          _address_[#__a_moved]\x = _x_ + transform( )\pos
          _address_[#__a_moved]\y = _y_ + transform( )\pos
          _address_[#__a_moved]\width = _width_ - transform( )\pos * 2
          _address_[#__a_moved]\height = _height_ - transform( )\pos * 2
        EndIf
      EndIf
      
      If transform( )\id[10] And 
         transform( )\id[11] And
         transform( )\id[12] And
         transform( )\id[13]
        a_lines( a_widget( ) )
      EndIf
      
    EndMacro
    
    Macro a_line_draw( _address_ )
      ; left line
      If transform( )\id[10] 
        If transform( )\id[10]\y = _address_\y[#__c_frame] And transform( )\id[10]\height = _address_\height[#__c_frame]
          Box( transform( )\id[10]\x, transform( )\id[10]\y, transform( )\id[10]\width, transform( )\id[10]\height ,_address_\_a_id_[#__a_moved]\color\frame[_address_\_a_id_[#__a_moved]\color\state] ) 
        Else
          Box( transform( )\id[10]\x, transform( )\id[10]\y, transform( )\id[10]\width, transform( )\id[10]\height ,transform( )\id[10]\color\frame[transform( )\id[10]\color\state] ) 
        EndIf
      EndIf
      
      ; top line
      If transform( )\id[12] 
        If transform( )\id[12]\y = _address_\y[#__c_frame] And transform( )\id[12]\height = _address_\height[#__c_frame]
          Box( transform( )\id[12]\x, transform( )\id[12]\y, transform( )\id[12]\width, transform( )\id[12]\height ,_address_\_a_id_[#__a_moved]\color\frame[_address_\_a_id_[#__a_moved]\color\state] ) 
        Else
          Box( transform( )\id[12]\x, transform( )\id[12]\y, transform( )\id[12]\width, transform( )\id[12]\height ,transform( )\id[12]\color\frame[transform( )\id[12]\color\state] ) 
        EndIf
      EndIf
      
      ; right line
      If transform( )\id[11] 
        If transform( )\id[11]\x = _address_\x[#__c_frame] And transform( )\id[11]\width = _address_\width[#__c_frame]
          Box( transform( )\id[11]\x, transform( )\id[11]\y, transform( )\id[11]\width, transform( )\id[11]\height ,_address_\_a_id_[#__a_moved]\color\frame[_address_\_a_id_[#__a_moved]\color\state] ) 
        Else
          Box( transform( )\id[11]\x, transform( )\id[11]\y, transform( )\id[11]\width, transform( )\id[11]\height ,transform( )\id[11]\color\frame[transform( )\id[11]\color\state] ) 
        EndIf
      EndIf
      
      ; bottom line
      If transform( )\id[13] 
        If transform( )\id[13]\x = _address_\x[#__c_frame] And transform( )\id[13]\width = _address_\width[#__c_frame]
          Box( transform( )\id[13]\x, transform( )\id[13]\y, transform( )\id[13]\width, transform( )\id[13]\height ,_address_\_a_id_[#__a_moved]\color\frame[_address_\_a_id_[#__a_moved]\color\state] ) 
        Else
          Box( transform( )\id[13]\x, transform( )\id[13]\y, transform( )\id[13]\width, transform( )\id[13]\height ,transform( )\id[13]\color\frame[transform( )\id[13]\color\state] ) 
        EndIf
      EndIf
    EndMacro
    
    Macro a_draw( _address_ )
      DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
      
      ; draw grab background 
      If transform( )\grab
        DrawImage( ImageID( transform( )\grab ), 0,0 )
        If Not transform( )\type
          CustomFilterCallback( @Draw_Datted( ) )
        EndIf 
      EndIf
      
      ; clip drawing coordinate
      _clip_content_( transform( )\main, [#__c_clip2] )
      
      If transform( )\grab
        If transform( )\id[0]\color\back[0]
          Box( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\back[0] )
        EndIf
        
        If transform( )\type
          DrawText( transform( )\id[0]\x + 3, transform( )\id[0]\y + 1, Str( transform( )\id[0]\width ) +"x"+ Str( transform( )\id[0]\height ), transform( )\id[0]\color\front[0], transform( )\id[0]\color\back[0] )
          
          If transform( )\id[0]\color\frame[0]
            DrawingMode( #PB_2DDrawing_Outlined )
            Box( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\frame[0] )
          EndIf
        Else
          DrawingMode( #PB_2DDrawing_CustomFilter | #PB_2DDrawing_Outlined ) 
          Box( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\frame[0] ) 
        EndIf
      Else
        ; draw back transparent
        If a_widget( ) And a_widget( )\_a_transform =- 1 And transform( )\id[0]\width And transform( )\id[0]\height And transform( )\id[0]\color\back[0]
          Box( a_widget( )\_a_id_[#__a_moved]\x, a_widget( )\_a_id_[#__a_moved]\y, a_widget( )\_a_id_[#__a_moved]\width, a_widget( )\_a_id_[#__a_moved]\height, a_widget( )\_a_id_[0]\color\back[0] )
          ; Box( transform( )\id[0]\x+transform( )\pos, transform( )\id[0]\y+transform( )\pos, transform( )\id[0]\width-transform( )\pos*2, transform( )\id[0]\height-transform( )\pos*2, transform( )\id[0]\color\frame[0] )
        EndIf
      EndIf
      
      DrawingMode( #PB_2DDrawing_Outlined )
      
      If _address_\_a_id_[0] : Box( _address_\_a_id_[0]\x, _address_\_a_id_[0]\y, _address_\_a_id_[0]\width, _address_\_a_id_[0]\height ,_address_\_a_id_[0]\color\back[_address_\_a_id_[0]\color\state] ) : EndIf
      
      DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
      
      ; draw background anchors
      If _address_\_a_id_[1] : Box( _address_\_a_id_[1]\x, _address_\_a_id_[1]\y, _address_\_a_id_[1]\width, _address_\_a_id_[1]\height ,_address_\_a_id_[1]\color\back[_address_\_a_id_[1]\color\state] ) : EndIf
      If _address_\_a_id_[2] : Box( _address_\_a_id_[2]\x, _address_\_a_id_[2]\y, _address_\_a_id_[2]\width, _address_\_a_id_[2]\height ,_address_\_a_id_[2]\color\back[_address_\_a_id_[2]\color\state] ) : EndIf
      If _address_\_a_id_[3] : Box( _address_\_a_id_[3]\x, _address_\_a_id_[3]\y, _address_\_a_id_[3]\width, _address_\_a_id_[3]\height ,_address_\_a_id_[3]\color\back[_address_\_a_id_[3]\color\state] ) : EndIf
      If _address_\_a_id_[4] : Box( _address_\_a_id_[4]\x, _address_\_a_id_[4]\y, _address_\_a_id_[4]\width, _address_\_a_id_[4]\height ,_address_\_a_id_[4]\color\back[_address_\_a_id_[4]\color\state] ) : EndIf
      If _address_\_a_id_[5] : Box( _address_\_a_id_[5]\x, _address_\_a_id_[5]\y, _address_\_a_id_[5]\width, _address_\_a_id_[5]\height ,_address_\_a_id_[5]\color\back[_address_\_a_id_[5]\color\state] ) : EndIf
      If _address_\_a_id_[6] : Box( _address_\_a_id_[6]\x, _address_\_a_id_[6]\y, _address_\_a_id_[6]\width, _address_\_a_id_[6]\height ,_address_\_a_id_[6]\color\back[_address_\_a_id_[6]\color\state] ) : EndIf
      If _address_\_a_id_[7] : Box( _address_\_a_id_[7]\x, _address_\_a_id_[7]\y, _address_\_a_id_[7]\width, _address_\_a_id_[7]\height ,_address_\_a_id_[7]\color\back[_address_\_a_id_[7]\color\state] ) : EndIf
      If _address_\_a_id_[8] : Box( _address_\_a_id_[8]\x, _address_\_a_id_[8]\y, _address_\_a_id_[8]\width, _address_\_a_id_[8]\height ,_address_\_a_id_[8]\color\back[_address_\_a_id_[8]\color\state] ) : EndIf
      
      DrawingMode( #PB_2DDrawing_Outlined )
      
      ; draw frame anchors
      If _address_\_a_id_[1] : Box( _address_\_a_id_[1]\x, _address_\_a_id_[1]\y, _address_\_a_id_[1]\width, _address_\_a_id_[1]\height, _address_\_a_id_[1]\color\frame[_address_\_a_id_[1]\color\state] ) : EndIf
      If _address_\_a_id_[2] : Box( _address_\_a_id_[2]\x, _address_\_a_id_[2]\y, _address_\_a_id_[2]\width, _address_\_a_id_[2]\height, _address_\_a_id_[2]\color\frame[_address_\_a_id_[2]\color\state] ) : EndIf
      If _address_\_a_id_[3] : Box( _address_\_a_id_[3]\x, _address_\_a_id_[3]\y, _address_\_a_id_[3]\width, _address_\_a_id_[3]\height, _address_\_a_id_[3]\color\frame[_address_\_a_id_[3]\color\state] ) : EndIf
      If _address_\_a_id_[4] : Box( _address_\_a_id_[4]\x, _address_\_a_id_[4]\y, _address_\_a_id_[4]\width, _address_\_a_id_[4]\height, _address_\_a_id_[4]\color\frame[_address_\_a_id_[4]\color\state] ) : EndIf
      If _address_\_a_id_[5] : Box( _address_\_a_id_[5]\x, _address_\_a_id_[5]\y, _address_\_a_id_[5]\width, _address_\_a_id_[5]\height, _address_\_a_id_[5]\color\frame[_address_\_a_id_[5]\color\state] ) : EndIf
      If _address_\_a_id_[6] : Box( _address_\_a_id_[6]\x, _address_\_a_id_[6]\y, _address_\_a_id_[6]\width, _address_\_a_id_[6]\height, _address_\_a_id_[6]\color\frame[_address_\_a_id_[6]\color\state] ) : EndIf
      If _address_\_a_id_[7] : Box( _address_\_a_id_[7]\x, _address_\_a_id_[7]\y, _address_\_a_id_[7]\width, _address_\_a_id_[7]\height, _address_\_a_id_[7]\color\frame[_address_\_a_id_[7]\color\state] ) : EndIf
      If _address_\_a_id_[8] : Box( _address_\_a_id_[8]\x, _address_\_a_id_[8]\y, _address_\_a_id_[8]\width, _address_\_a_id_[8]\height, _address_\_a_id_[8]\color\frame[_address_\_a_id_[8]\color\state] ) : EndIf
      
      If _address_\_a_id_[#__a_moved] And _address_\container And _address_ = a_widget( )
        Box( _address_\_a_id_[#__a_moved]\x, _address_\_a_id_[#__a_moved]\y, _address_\_a_id_[#__a_moved]\width, _address_\_a_id_[#__a_moved]\height, _address_\_a_id_[#__a_moved]\color\frame[_address_\_a_id_[#__a_moved]\color\state] ) 
      EndIf
      
    EndMacro
    
    Procedure   a_lines( *this._s_WIDGET = -1, distance = 0 )
      Protected ls = 1, top_x1,left_y2,top_x2,left_y1
      Protected bottom_x1,right_y2,bottom_x2,right_y1
      Protected checked_x1,checked_y1,checked_x2,checked_y2
      Protected relative_x1,relative_y1,relative_x2,relative_y2
      
      checked_x1 = *this\x[#__c_frame]
      checked_y1 = *this\y[#__c_frame]
      checked_x2 = checked_x1 + *this\width[#__c_frame]
      checked_y2 = checked_y1 + *this\height[#__c_frame]
      
      top_x1 = checked_x1 : top_x2 = checked_x2
      left_y1 = checked_y1 : left_y2 = checked_y2 
      right_y1 = checked_y1 : right_y2 = checked_y2
      bottom_x1 = checked_x1 : bottom_x2 = checked_x2
      
      transform( )\id[10]\color\state = 0
      transform( )\id[10]\x = checked_x1
      transform( )\id[10]\y = checked_y1
      transform( )\id[10]\width = ls
      transform( )\id[10]\height = checked_y2 - checked_y1
      
      transform( )\id[12]\color\state = 0
      transform( )\id[12]\x = checked_x2 - ls
      transform( )\id[12]\y = checked_y1
      transform( )\id[12]\width = ls
      transform( )\id[12]\height = checked_y2 - checked_y1
      
      transform( )\id[11]\color\state = 0
      transform( )\id[11]\x = checked_x1
      transform( )\id[11]\y = checked_y1
      transform( )\id[11]\width = checked_x2 - checked_x1
      transform( )\id[11]\height = ls
      
      transform( )\id[13]\color\state = 0
      transform( )\id[13]\x = checked_x1
      transform( )\id[13]\y = checked_y2 - ls
      transform( )\id[13]\width = checked_x2 - checked_x1
      transform( )\id[13]\height = ls
      
      If *this\parent And ListSize( Widget( ) )
        PushListPosition( Widget( ) )
        ForEach Widget( )
          If *this <> Widget( ) And
             Not Widget( )\hide And
             Widget( )\_a_transform And
             Widget( )\parent = *this\parent
            
            relative_x1 = Widget( )\x[#__c_frame]
            relative_y1 = Widget( )\y[#__c_frame]
            relative_x2 = relative_x1 + Widget( )\width[#__c_frame]
            relative_y2 = relative_y1 + Widget( )\height[#__c_frame]
            
            ;Left_line
            If checked_x1 = relative_x1
              If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
              If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
              
              transform( )\id[10]\color\state = 2
              transform( )\id[10]\x = checked_x1
              transform( )\id[10]\y = left_y1
              transform( )\id[10]\width = ls
              transform( )\id[10]\height = left_y2 - left_y1
            EndIf
            
            ;Right_line
            If checked_x2 = relative_x2
              If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
              If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
              
              transform( )\id[12]\color\state = 2
              transform( )\id[12]\x = checked_x2 - ls
              transform( )\id[12]\y = right_y1
              transform( )\id[12]\width = ls
              transform( )\id[12]\height = right_y2 - right_y1
            EndIf
            
            ;Top_line
            If checked_y1 = relative_y1 
              If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
              If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
              
              transform( )\id[11]\color\state = 1
              transform( )\id[11]\x = top_x1
              transform( )\id[11]\y = checked_y1
              transform( )\id[11]\width = top_x2 - top_x1
              transform( )\id[11]\height = ls
            EndIf
            
            ;Bottom_line
            If checked_y2 = relative_y2 
              If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
              If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
              
              transform( )\id[13]\color\state = 1
              transform( )\id[13]\x = bottom_x1
              transform( )\id[13]\y = checked_y2 - ls
              transform( )\id[13]\width = bottom_x2 - bottom_x1
              transform( )\id[13]\height = ls
            EndIf
          EndIf
        Next
        PopListPosition( Widget( ) )
      EndIf
      
    EndProcedure
    
    Macro a_remove( _this_, _index_ )
      For _index_ = 0 To #__a_moved
        _this_\_a_id_[_index_] = #Null
      Next
    EndMacro
    
    Macro a_add( _this_, _index_, _cursor_ )
      For _index_ = 0 To #__a_moved
        If Not _this_\_a_id_[_index_]
          _this_\_a_id_.allocate( BUTTONS, [_index_] )
        EndIf
        _this_\_a_id_[_index_]\cursor = _cursor_[_index_]
        
        _this_\_a_id_[_index_]\color\frame[#__s_0] = $ff000000
        _this_\_a_id_[_index_]\color\frame[#__s_1] = $ffFF0000
        _this_\_a_id_[_index_]\color\frame[#__s_2] = $ff0000FF
        
        _this_\_a_id_[_index_]\color\back[#__s_0] = $ffFFFFFF
        _this_\_a_id_[_index_]\color\back[#__s_1] = $80FF0000 
        _this_\_a_id_[_index_]\color\back[#__s_2] = $800000FF
      Next _index_
    EndMacro
    
    Procedure.i a_set( *this._s_WIDGET, size.l = #__a_size, position.l = #PB_Ignore )
      Protected result.i, i
      Static *before._s_widget
      ; 
      If *this = transform( )\main And a_widget( )
        *this = a_widget( )\window
      EndIf
      
      ;
      If *this And ( *this\_a_transform =- 1 And Not transform( )\index ) Or
         ( *this\_a_transform = 1 And a_widget( ) <> *this )
        
        If a_widget( )
;           ; TODO set and return layout position - with childrens no tested
;           If Not *before 
;             SetPosition( a_widget( ), #PB_List_First ) 
;           ElseIf a_widget( ) = a_widget( )\parent\last
;             SetPosition( a_widget( ), #PB_List_After, *before ) 
;           EndIf
;           *before = GetPosition( *this, #PB_List_Before )
;           If *this <> *this\parent\last
;             SetPosition( *this, #PB_List_Last ) 
;           EndIf
          
          ;
          a_remove( a_widget( ), i ) 
        EndIf
        
        ; a_add
        a_add( *this, i, *Data_Transform_Cursor\cursor )
        a_grid_change( *this\parent )
        
        transform( )\size = size
        
        If position = #PB_Ignore
          transform( )\pos = transform( )\size - transform( )\size / 3 - 1
        Else
          transform( )\pos = position
        EndIf
        
        *this\bs = transform( )\pos + *this\fs
        
        If *this\container And *this\fs > 1
          transform( )\size + *this\fs
        EndIf
        
        
        If a_widget( )
          result = a_widget( )
        Else
          result =- 1
        EndIf
        
        a_widget( ) = *this
        
        a_size( *this\_a_id_, transform( )\size )
        a_move( *this\_a_id_, *this\x[#__c_screen], *this\y[#__c_screen], *this\width[#__c_screen], *this\height[#__c_screen], *this\container )
        
        Post( #__event_StatusChange, *this, transform( )\index )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i a_init( *this._s_WIDGET, grid_size.a = 7, grid_type.b = 0 )
      Protected i
      
      If Not *this\_a_transform
        *this\_a_transform = #True
        
        If Not transform( )
          transform( ).allocate( TRANSFORM )
          
          transform( )\main = *this
          
          transform( )\grid\type = grid_type
          transform( )\grid\size = grid_size + 1
          transform( )\grid\image = a_grid_image( transform( )\grid\size - 1, transform( )\grid\type, $FF000000 )
          
          For i = 0 To #__a_count
            transform( )\id[i]\cursor = *Data_Transform_Cursor\cursor[i]
            
            transform( )\id[i]\color\frame[0] = $ff000000
            transform( )\id[i]\color\frame[1] = $ffFF0000
            transform( )\id[i]\color\frame[2] = $ff0000FF
            
            transform( )\id[i]\color\back[0] = $ffFFFFFF
            transform( )\id[i]\color\back[1] = $ffFFFFFF
            transform( )\id[i]\color\back[2] = $ffFFFFFF
          Next i
          
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure   a_update( *parent._s_WIDGET )
      If *parent\_a_transform = 1 ; Not ListSize( transform( )\group( ) )
                               ; check transform group
        ForEach Widget( )
          If Widget( ) <> *parent And
             Widget( )\parent = *parent And 
             ; child( widget( ), *parent ) And 
            Intersect( Widget( ), transform( )\id[0], [#__c_frame] )
            ; Debug " -- "+widget( )\class +"_"+ widget( )\count\index 
            
            Widget( )\_a_transform = 2
            Widget( )\root\_a_transform =- 1
            Widget( )\parent\_a_transform =- 1
          EndIf
        Next
        
        ; reset
        transform( )\id[0]\x = 0
        transform( )\id[0]\y = 0
        transform( )\id[0]\width = 0
        transform( )\id[0]\height = 0
        ; ClearList( transform( )\group( ) )
        
        ; init min group pos
        ForEach Widget( )
          If Widget( )\_a_transform = 2
            If transform( )\id[0]\x = 0 Or 
               transform( )\id[0]\x > Widget( )\x[#__c_frame]
              transform( )\id[0]\x = Widget( )\x[#__c_frame]
            EndIf
            If transform( )\id[0]\y = 0 Or 
               transform( )\id[0]\y > Widget( )\y[#__c_frame]
              transform( )\id[0]\y = Widget( )\y[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init max group size
        ForEach Widget( )
          If Widget( )\_a_transform = 2
            If transform( )\id[0]\x + transform( )\id[0]\width < Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame]
              transform( )\id[0]\width = ( Widget( )\x[#__c_frame] - transform( )\id[0]\x ) + Widget( )\width[#__c_frame]
            EndIf
            If transform( )\id[0]\y + transform( )\id[0]\height < Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame]
              transform( )\id[0]\height = ( Widget( )\y[#__c_frame] - transform( )\id[0]\y ) + Widget( )\height[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init group list ( & delta size )
        ForEach Widget( )
          If Widget( )\_a_transform = 2
            If AddElement( transform( )\group( ) )
              transform( )\group.allocate( GROUP, ( ) )
              ;transform( )\group( )\widget.allocate( WIDGET )
              
              transform( )\group( )\widget = Widget( )
              transform( )\group( )\x = transform( )\group( )\widget\x[#__c_frame] - transform( )\id[0]\x
              transform( )\group( )\y = transform( )\group( )\widget\y[#__c_frame] - transform( )\id[0]\y
              
              transform( )\group( )\width = transform( )\id[0]\width - transform( )\group( )\widget\width[#__c_frame]
              transform( )\group( )\height = transform( )\id[0]\height - transform( )\group( )\widget\height[#__c_frame]
            EndIf
          EndIf
        Next
        
      Else
        ; update min group pos
        ForEach transform( )\group( )
          If transform( )\id[0]\x = 0 Or 
             transform( )\id[0]\x > transform( )\group( )\widget\x[#__c_frame]
            transform( )\id[0]\x = transform( )\group( )\widget\x[#__c_frame]
          EndIf
          If transform( )\id[0]\y = 0 Or 
             transform( )\id[0]\y > transform( )\group( )\widget\y[#__c_frame]
            transform( )\id[0]\y = transform( )\group( )\widget\y[#__c_frame]
          EndIf
        Next
        
        ; update max group size
        ForEach transform( )\group( )
          If transform( )\id[0]\x + transform( )\id[0]\width < transform( )\group( )\widget\x[#__c_frame] + transform( )\group( )\widget\width[#__c_frame]
            transform( )\id[0]\width = ( transform( )\group( )\widget\x[#__c_frame] - transform( )\id[0]\x ) + transform( )\group( )\widget\width[#__c_frame]
          EndIf
          If transform( )\id[0]\y + transform( )\id[0]\height < transform( )\group( )\widget\y[#__c_frame] + transform( )\group( )\widget\height[#__c_frame]
            transform( )\id[0]\height = ( transform( )\group( )\widget\y[#__c_frame] - transform( )\id[0]\y ) + transform( )\group( )\widget\height[#__c_frame]
          EndIf
        Next
        
        ; update delta size
        ForEach transform( )\group( )
          transform( )\group( )\x = transform( )\group( )\widget\x[#__c_frame] - transform( )\id[0]\x
          transform( )\group( )\y = transform( )\group( )\widget\y[#__c_frame] - transform( )\id[0]\y
          
          transform( )\group( )\width = transform( )\id[0]\width - transform( )\group( )\widget\width[#__c_frame]
          transform( )\group( )\height = transform( )\id[0]\height - transform( )\group( )\widget\height[#__c_frame]
        Next
      EndIf   
      
      ;
      a_move( transform( )\id, transform( )\id[0]\x - transform( )\pos, transform( )\id[0]\y - transform( )\pos, transform( )\id[0]\width + transform( )\pos*2, transform( )\id[0]\height + transform( )\pos*2 )
    EndProcedure
    
    Procedure a_hide( *this._s_WIDGET )
      ;If  eventtype = #__event_MouseLeave 
      Protected i, repaint
      Debug " hide - "+*this\class
      If transform( ) And Not _is_child_integral_( *this ) And Not ( transform( )\index And transform( )\index <> #__a_moved )
        If *this\_a_transform And a_widget( ) <> *this
          Debug " remove "
          If transform( )\widget\_a_id_[0]\color\state <> #__s_0
            transform( )\widget\_a_id_[0]\color\state = #__s_0
          EndIf
          a_remove( *this, i )
          transform( )\widget = #Null
          repaint = 1
          
        EndIf
        
      EndIf
      
      ;EndIf
      ProcedureReturn repaint
    EndProcedure
    
    Procedure a_show( *this._s_WIDGET )
      ;If   eventtype = #__event_MouseEnter ;Or
      ; eventtype = #__event_MouseLeave Or
      ;eventtype = #__event_MouseMove Or eventtype = #__event_LeftButtonDown 
      
      Protected i, repaint
      Debug " enter - " +*this\class
      If transform( ) And Not _is_child_integral_( *this ) ;And Not ( transform( )\index And transform( )\index <> #__a_moved )
        If transform( )\widget <> *this
          If *this\_a_transform 
            If a_widget( ) = *this And transform( )\widget
              repaint = a_hide( transform( )\widget )
            Else
              transform( )\widget = *this
              Debug "show - "+transform( )\index
              
              a_add( transform( )\widget, i, *Data_Transform_Cursor\cursor )
              a_size( transform( )\widget\_a_id_, #__a_size )
              a_move( transform( )\widget\_a_id_, transform( )\widget\x[#__c_screen], transform( )\widget\y[#__c_screen], transform( )\widget\width[#__c_screen], transform( )\widget\height[#__c_screen] )
              If transform( )\widget\_a_id_[0]\color\state <> #__s_1
                transform( )\widget\_a_id_[0]\color\state = #__s_1
              EndIf
              repaint = 1 
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure   a_events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      Macro a_index( _this_, _result_, _index_ )
        If transform( )\widget And
           transform( )\index <> #Null And 
           transform( )\widget\_a_id_[transform( )\index] And
           Not Atpoint( transform( )\widget\_a_id_[transform( )\index], mouse_x, mouse_y ) 
          
          ;             If transform( )\widget <> a_widget( )
          ;               Debug " a_index reset "
          ;               a_remove( transform( )\widget, i )
          ;               ;repaint | DoEvents( transform( )\widget, #__event_MouseLeave, mouse( )\x, mouse( )\y )
          ;                   
          ;               transform( )\widget = #Null
          ;               repaint = 1
          ;              EndIf
        EndIf
        
        transform( )\index = #Null
        
        If _this_
          ; find entered anchor index
          For _index_ = 1 To #__a_moved 
            If _this_\_a_id_[_index_] 
              If Atpoint( _this_\_a_id_[_index_], mouse_x, mouse_y ) 
                transform( )\index = _index_
                
                If _this_\_a_id_[_index_]\color\state <> #__s_1
                  _this_\_a_id_[_index_]\color\state = #__s_1
                  ;transform( )\widget = #Null
                  
                  ;_set_cursor_( _this_, _this_\_a_id_[_index_]\cursor )
                  _result_ = 1
                EndIf
                Break
                
              Else
                If _this_\_a_id_[_index_]\color\state <> #__s_0
                  _this_\_a_id_[_index_]\color\state = #__s_0
                  ;transform( )\widget = #Null
                  
                  ;_set_cursor_( _this_, #PB_Cursor_Default )
                  _result_ = 1
                EndIf
              EndIf
            EndIf
          Next
        EndIf
      EndMacro
      
      Macro a_resize( _result_, _x_, _y_, _width_, _height_ )
        If a_widget( )\_a_transform = 1 ; Not ListSize( transform( )\group( ) )
          
          If #__a_moved = transform( )\index
            _result_ = Resize( a_widget( ), _x_, _y_, #PB_Ignore, #PB_Ignore )
          Else
            Select transform( )\index
              Case 1, 5, 8 ; left
                _result_ = Resize( a_widget( ), _x_, #PB_Ignore, _width_, #PB_Ignore )
                
              Case 3, 6, 7 ; right
                _result_ = Resize( a_widget( ), #PB_Ignore, #PB_Ignore, _width_, #PB_Ignore )
            EndSelect
            
            Select transform( )\index
              Case 2, 5, 6 ; top
                _result_ = Resize( a_widget( ), #PB_Ignore, _y_, #PB_Ignore, _height_ )
                
              Case 4, 8, 7 ; bottom 
                _result_ = Resize( a_widget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, _height_ )
            EndSelect
          EndIf
          
        Else
          ; multi resize
          transform( )\id[0]\x = _x_
          transform( )\id[0]\y = _y_
          
          transform( )\id[0]\width = _width_
          transform( )\id[0]\height = _height_
          
          a_move( transform( )\id, 
                  transform( )\id[0]\x - transform( )\pos, 
                  transform( )\id[0]\y - transform( )\pos, 
                  transform( )\id[0]\width + transform( )\pos*2, 
                  transform( )\id[0]\height + transform( )\pos*2 )
          
          Select transform( )\index
            Case 1, 5, 8, #__a_moved ; left
              ForEach transform( )\group( )
                _result_ = Resize( transform( )\group( )\widget, 
                                   ( transform( )\id[0]\x - a_widget( )\x[#__c_inner] ) + transform( )\group( )\x,
                                   #PB_Ignore, transform( )\id[0]\width - transform( )\group( )\width, #PB_Ignore )
              Next
              
            Case 3, 6, 7 ; right
              ForEach transform( )\group( )
                _result_ = Resize( transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, transform( )\id[0]\width - transform( )\group( )\width, #PB_Ignore )
              Next
          EndSelect
          
          Select transform( )\index
            Case 2, 5, 6, #__a_moved ; top
              ForEach transform( )\group( )
                _result_ = Resize( transform( )\group( )\widget, #PB_Ignore, 
                                   ( transform( )\id[0]\y - a_widget( )\y[#__c_inner] ) + transform( )\group( )\y,
                                   #PB_Ignore, transform( )\id[0]\height - transform( )\group( )\height )
              Next
              
            Case 4, 8, 7 ; bottom 
              ForEach transform( )\group( )
                _result_ = Resize( transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, transform( )\id[0]\height - transform( )\group( )\height )
              Next
          EndSelect
          
          _result_ = 1
        EndIf
      EndMacro
      
      If transform( )  
        Static xx, yy
        Static move_x, move_y
        Protected Repaint, i
        Protected mxw, myh
        Protected.l mx, my, mw, mh
        Protected.l Px,Py, IsGrid = Bool( transform( )\grid\size>1 )
        
        ;
        If eventtype = #__event_LeftButtonDown 
          ; set current transformer
          If a_set( *this )
            a_reset( )
          EndIf
          
          ; get transform index
          a_index( *this, repaint, i )
          
          ; change frame color
          If transform( )\type > 0
            transform( )\id[0]\color\back = $9F646565
            transform( )\id[0]\color\frame = $BA161616
            transform( )\id[0]\color\front = $ffffffff
          Else
            transform( )\dotted\dot = 1 ; 2
            transform( )\dotted\space = 4
            transform( )\dotted\line = 6 ; 6
            
            transform( )\id[0]\color\back = $80DFE2E2 
            transform( )\id[0]\color\frame = $BA161616
          EndIf
          
          If transform( )\index 
            ; set current transform index
            a_widget( )\_a_id_[transform( )\index]\color\state = #__s_2
            
            ; 
            If a_widget( )\_a_transform = 1
              If a_widget( )\parent 
                mouse_x + a_widget( )\parent\x[#__c_inner]
                mouse_y + a_widget( )\parent\y[#__c_inner]
                
                If Not _is_child_integral_( a_widget( ) )
                  mouse_x - a_widget( )\parent\x[#__c_required]
                  mouse_y - a_widget( )\parent\y[#__c_required]
                EndIf
              EndIf
            EndIf
            
            ; set delta pos
            mouse( )\delta\x = mouse_x - a_widget( )\_a_id_[transform( )\index]\x
            mouse( )\delta\y = mouse_y - a_widget( )\_a_id_[transform( )\index]\y
            
            If Not ( a_widget( )\container = 0 And transform( )\index = #__a_moved )
              ; horizontal
              Select transform( )\index
                Case 1, 5, 8, #__a_moved ; left
                  mouse( )\delta\x - transform( )\pos
                  
                Case 3, 6, 7 ; right
                  mouse( )\delta\x - ( transform( )\size-transform( )\pos )
              EndSelect
              
              ; vertical
              Select transform( )\index
                Case 2, 5, 6, #__a_moved ; top
                  mouse( )\delta\y - transform( )\pos
                  
                Case 4, 8, 7 ; bottom
                  mouse( )\delta\y - ( transform( )\size-transform( )\pos ) 
              EndSelect
            EndIf
            
          Else
            If transform( )\main 
              mouse_x - transform( )\main\x[#__c_container]
              mouse_y - transform( )\main\y[#__c_container]
            EndIf
            
            ; for the selector
            ; grid mouse pos
            If transform( )\grid\size > 0
              mouse_x = ( ( mouse_x ) / transform( )\grid\size ) * transform( )\grid\size
              mouse_y = ( ( mouse_y ) / transform( )\grid\size ) * transform( )\grid\size 
            EndIf
            
            ; set delta pos
            mouse( )\delta\x = mouse_x
            mouse( )\delta\y = mouse_y
          EndIf
          
          Repaint = #True
        EndIf
        
        ;
        If eventtype = #__event_DragStart 
          If a_widget( )\_a_id_[#__a_moved] And transform( )\index = #__a_moved
            _set_cursor_( *this, a_widget( )\_a_id_[#__a_moved]\cursor )
          EndIf
          
          If  *this\container And 
              Not transform( )\index And 
              Atpoint( *this, mouse_x, mouse_y, [#__c_inner] )
            
            _set_cursor_( *this, #PB_Cursor_Cross )
            ; transform( )\container = *this\container
            
            a_grid_change( *this, #True )
            
            If StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
              ;DrawAlphaImage( ImageID( transform( )\grid\image ), *this\x[#__c_inner],*this\y[#__c_inner] )
              transform( )\grab = GrabDrawingImage( #PB_Any, 0,0, *this\root\width, *this\root\height )
              StopDrawing( )
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_LeftButtonUp
          If a_widget( )\_a_id_[transform( )\index]
            If Atpoint( a_widget( )\_a_id_[transform( )\index], mouse_x, mouse_y )
              a_widget( )\_a_id_[transform( )\index]\color\state = #__s_1
            EndIf
            
            If transform( )\index = #__a_moved Or 
               a_widget( )\_a_id_[transform( )\index]\color\state = #__s_0
              
              ; return widget cursor
              _set_cursor_( *this, a_widget( )\cursor )
            EndIf
          EndIf
          
          ; init multi group selector
          If transform( )\grab And 
             Not transform( )\type 
            a_update( *this )
          EndIf
          
          ;           If after
          ;             Debug "reafter - "+GetClass(after)
          ;             SetPosition( *this, #PB_List_Before, after)
          ;           EndIf
          
          Repaint = 1
        EndIf
        
        ; 
        If eventtype = #__event_MouseMove
          If Not transform( )\grab And a_widget( )
            If Not mouse( )\buttons
              ; a_index( Repaint, i )
              
            ElseIf a_widget( )\_a_id_[transform( )\index] And a_widget( )\_a_id_[transform( )\index]\color\state = #__s_2
              If transform( )\grid\size > 0
                mouse_x = ( ( mouse_x - mouse( )\delta\x ) / transform( )\grid\size ) * transform( )\grid\size
                mouse_y = ( ( mouse_y - mouse( )\delta\y ) / transform( )\grid\size ) * transform( )\grid\size
              Else
                mouse_x - mouse( )\delta\x
                mouse_y - mouse( )\delta\y
              EndIf
              
              If xx <> mouse_x Or yy <> mouse_y : xx = mouse_x : yy = mouse_y
                If a_widget( )\_a_transform = 1
                  ; horizontal 
                  Select transform( )\index
                    Case 1, 5, 8 ; left
                      mw = ( a_widget( )\x[#__c_container] - mouse_x ) + a_widget( )\width[#__c_frame] ;;+ (a_widget( )\parent\fs - a_widget( )\fs[1])
                      
                    Case 3, 6, 7 ; right
                      mw = ( mouse_x - a_widget( )\x[#__c_container] ) + IsGrid 
                  EndSelect
                  
                  ; vertical
                  Select transform( )\index
                    Case 2, 5, 6 ; top
                      mh = ( a_widget( )\y[#__c_container] - mouse_y ) + a_widget( )\height[#__c_frame] ;;+ (a_widget( )\parent\fs - a_widget( )\fs[2])
                      
                    Case 4, 8, 7 ; bottom 
                      mh = ( mouse_y - a_widget( )\y[#__c_container] ) + IsGrid
                  EndSelect
                  
                  a_resize( Repaint, mouse_x,mouse_y,mw,mh )
                  
                Else
                  If transform( )\main 
                    mouse_x + transform( )\main\x[#__c_container]
                    mouse_y + transform( )\main\y[#__c_container]
                  EndIf
                  
                  ; horizontal 
                  Select transform( )\index
                    Case 1, 5, 8, #__a_moved ; left
                      If transform( )\index <> #__a_moved
                        transform( )\id[0]\width = ( transform( )\id[0]\x - mouse_x ) + transform( )\id[0]\width
                      EndIf     
                      transform( )\id[0]\x = mouse_x
                      
                    Case 3, 6, 7 ; right
                      transform( )\id[0]\width = ( mouse_x - transform( )\id[0]\x ) + IsGrid
                  EndSelect
                  
                  ; vertical
                  Select transform( )\index
                    Case 2, 5, 6, #__a_moved ; top
                      If transform( )\index <> #__a_moved
                        transform( )\id[0]\height = ( transform( )\id[0]\y - mouse_y ) + transform( )\id[0]\height
                      EndIf  
                      transform( )\id[0]\y = mouse_y
                      
                    Case 4, 8, 7 ; bottom
                      transform( )\id[0]\height = ( mouse_y - transform( )\id[0]\y ) + IsGrid
                  EndSelect
                  
                  a_resize( Repaint, transform( )\id[0]\x,transform( )\id[0]\y,transform( )\id[0]\width,transform( )\id[0]\height )
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          ; change selector coordinate
          If transform( )\grab
            If transform( )\main 
              mouse_x - transform( )\main\x[#__c_container]
              mouse_y - transform( )\main\y[#__c_container]
            EndIf
            
            If transform( )\grid\size > 0
              mouse_x = ( mouse_x / transform( )\grid\size ) * transform( )\grid\size
              mouse_y = ( mouse_y / transform( )\grid\size ) * transform( )\grid\size
            EndIf
            
            If move_x <> mouse_x
              If move_x > mouse_x
                Repaint =- 1
              Else
                Repaint = 1
              EndIf
              
              ; to left
              If mouse( )\delta\x > mouse_x
                transform( )\id[0]\x = mouse_x + transform( )\grid\size
                transform( )\id[0]\width = mouse( )\delta\x - mouse_x
              Else
                transform( )\id[0]\x = mouse( )\delta\x
                transform( )\id[0]\width = mouse_x - mouse( )\delta\x
              EndIf
              
              transform( )\id[0]\x + transform( )\main\x[#__c_container]
              If transform( )\grid\size > 0 : transform( )\id[0]\width + 1 : EndIf
              move_x = mouse_x
            EndIf
            
            If move_y <> mouse_y
              If move_y > mouse_y
                Repaint =- 2
              Else
                Repaint = 2
              EndIf
              
              ; to top
              If mouse( )\delta\y > mouse_y
                transform( )\id[0]\y = mouse_y + transform( )\grid\size
                transform( )\id[0]\height = mouse( )\delta\y - mouse_y 
              Else
                transform( )\id[0]\y = mouse( )\delta\y 
                transform( )\id[0]\height = mouse_y - mouse( )\delta\y 
              EndIf
              
              transform( )\id[0]\y + transform( )\main\y[#__c_container]
              If transform( )\grid\size > 0 : transform( )\id[0]\height + 1 : EndIf
              move_y = mouse_y
            EndIf
          EndIf
        EndIf
        
        ;- widget::a_key_events
        If eventtype = #__event_KeyDown
          If a_widget( )
            If a_widget( )\_a_transform = 1
              mx = a_widget( )\x[#__c_container]
              my = a_widget( )\y[#__c_container]
              mw = a_widget( )\width[#__c_frame]
              mh = a_widget( )\height[#__c_frame] 
              
              ; fixed in container
              If a_widget( )\parent And
                 a_widget( )\parent\container ;;> 0
                mx + a_widget( )\parent\fs
                my + a_widget( )\parent\fs
              EndIf
              
            Else
              mx = transform( )\id[0]\x
              my = transform( )\id[0]\y
              mw = transform( )\id[0]\width
              mh = transform( )\id[0]\height
            EndIf
            
            Select keyboard( )\Key[1] 
              Case (#PB_Canvas_Alt | #PB_Canvas_Control), #PB_Canvas_Shift
                Select keyboard( )\Key
                  Case #PB_Shortcut_Left  : mw - transform( )\grid\size : transform( )\index = 3  
                  Case #PB_Shortcut_Right : mw + transform( )\grid\size : transform( )\index = 3
                    
                  Case #PB_Shortcut_Up    : mh - transform( )\grid\size : transform( )\index = 4
                  Case #PB_Shortcut_Down  : mh + transform( )\grid\size : transform( )\index = 4
                EndSelect
                
                a_resize( Repaint, mx,my,mw,mh )
                
              Case (#PB_Canvas_Shift | #PB_Canvas_Control), #PB_Canvas_Alt ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control | #PB_Canvas_Command
                Select keyboard( )\Key
                  Case #PB_Shortcut_Left  : mx - transform( )\grid\size : transform( )\index = #__a_moved
                  Case #PB_Shortcut_Right : mx + transform( )\grid\size : transform( )\index = #__a_moved
                    
                  Case #PB_Shortcut_Up    : my - transform( )\grid\size : transform( )\index = #__a_moved
                  Case #PB_Shortcut_Down  : my + transform( )\grid\size : transform( )\index = #__a_moved
                EndSelect
                
                a_resize( Repaint, mx,my,mw,mh )
                
              Default
                ;;ChangeCurrentElement( widget( ), a_widget( )\address)
                Protected index = a_widget( )\index ;; ListIndex( widget( ) )
                Protected parent = a_widget( )\parent ;; ListIndex( widget( ) )
                
                Select keyboard( )\Key
                  Case #PB_Shortcut_Up   
                    PushListPosition( Widget( ) )
                    ForEach Widget( )
                      If ListIndex( Widget( ) ) = index - 1 ;And widget( )\parent = parent
                                                            ;;If widget( )\index = index - 1
                        Repaint = a_set( Widget( ) )
                        Break
                      EndIf
                    Next
                    PopListPosition( Widget( ) )
                    
                  Case #PB_Shortcut_Down  
                    PushListPosition( Widget( ) )
                    ForEach Widget( )
                      If ListIndex( Widget( ) ) = index + 1 ;And widget( )\parent = parent 
                                                            ;;If widget( )\index = index + 1 
                        Debug " "+ListIndex( Widget( ) ) +" "+ Widget( )\index
                        Repaint = a_set( Widget( ) )
                        Break
                      EndIf
                    Next
                    PopListPosition( Widget( ) )
                    
                  Case #PB_Shortcut_Left  
                    parent = a_widget( )\parent\parent
                    PushListPosition( Widget( ) )
                    ForEach Widget( )
                      If ListIndex( Widget( ) ) = index - 1 And Widget( )\parent = parent
                        ;;If widget( )\index = index - 1
                        Repaint = a_set( Widget( ) )
                        Break
                      EndIf
                    Next
                    PopListPosition( Widget( ) )
                    
                  Case #PB_Shortcut_Right  
                    parent = a_widget( )
                    PushListPosition( Widget( ) )
                    ForEach Widget( )
                      If ListIndex( Widget( ) ) = index + 1 And Widget( )\parent = parent 
                        ;;If widget( )\index = index + 1 
                        Debug " "+ListIndex( Widget( ) ) +" "+ Widget( )\index
                        Repaint = a_set( Widget( ) )
                        Break
                      EndIf
                    Next
                    PopListPosition( Widget( ) )
                    
                EndSelect
                
            EndSelect
          EndIf
        EndIf
        
        ; 
        Post( eventtype, *this, *this\index[#__s_1] )
        
        If eventtype = #__event_LeftButtonUp
          transform( )\grab = 0
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  PRIVATEs
    ;-
    Macro _position_move_( _this_ )
      ; if first element in parent list
      If _this_\parent\first = _this_
        _this_\parent\first = _this_\after
      EndIf
      
      ; if last element in parent list
      If _this_\parent\last = _this_
        ; Debug #PB_Compiler_Procedure + " before - " + *this\before\class
        _this_\parent\last = _this_\before
      EndIf
      
      If _this_\before
        _this_\before\after = _this_\after
      EndIf
      
      If _this_\after
        _this_\after\before = _this_\before
      EndIf
    EndMacro
    
    Macro _position_move_after_(_this_, _before_)
      _position_move_( _this_ )
      
      PushListPosition( Widget( ) )
      ChangeCurrentElement( Widget( ), _this_\address )
      ;; Debug " "+widget( )\class +" "+ _this_\class +" "+ _before_\class
      ;;If widget( )\address <> _before_\address
      MoveElement( Widget( ), #PB_List_After, _before_\address )
      ;;EndIf
      
      ; change root address for the startenumerate 
      If _this_\root <> _before_\root
        _this_\root\address = _this_\address
      EndIf
      
      If _this_\count\childrens
        While NextElement( Widget( ) ) 
          If Child( Widget( ), _this_ )
            MoveElement( Widget( ), #PB_List_Before, _before_\address )
          EndIf
        Wend
        
        While PreviousElement( Widget( ) ) 
          If Child( Widget( ), _this_ )
            MoveElement( Widget( ), #PB_List_After, _this_\address )
          EndIf
        Wend
      EndIf
      PopListPosition( Widget( ) )
    EndMacro
    
    Macro _position_move_before_(_this_, _after_)
      _position_move_( _this_ )
      
      PushListPosition( Widget( ) )
      ChangeCurrentElement( Widget( ), _this_\address )
      ;;If widget( )\address <> _after_\address
      MoveElement( Widget( ), #PB_List_Before, _after_\address )
      ;;EndIf
      
      If _this_\count\childrens
        While PreviousElement( Widget( ) ) 
          If Child( Widget( ), _this_ )
            MoveElement( Widget( ), #PB_List_After, _after_\address )
          EndIf
        Wend
        
        While NextElement( Widget( ) ) 
          If Child( Widget( ), _this_ )
            MoveElement( Widget( ), #PB_List_Before, _after_\address )
          EndIf
        Wend
      EndIf
      PopListPosition( Widget( ) )
    EndMacro
    
    ;-
    Macro _set_align_( _address_, _left_, _top_, _right_, _bottom_, _center_ )
      _address_\align\left = _left_
      _address_\align\right = _right_
      
      _address_\align\top = _top_
      _address_\align\bottom = _bottom_
      
      If Not _center_ And 
         Not _address_\align\top And 
         Not _address_\align\left And
         Not _address_\align\right And 
         Not _address_\align\bottom
        
        If Not _address_\align\right
          _address_\align\left = #True 
        EndIf
        If Not _address_\align\bottom
          _address_\align\top = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_x_( _this_, _address_, _width_, _rotate_ )
      If _rotate_ = 180
        If _this_\align\right
          _address_\x = _width_                          - _this_\padding\x
        ElseIf Not _this_\align\left
          _address_\x = ( _width_ + _address_\width ) / 2
        Else
          _address_\x = _address_\width                   + _this_\padding\x
        EndIf
      EndIf
      
      If _rotate_ = 0
        If _this_\align\right
          _address_\x = ( _width_ - _address_\width )       - _this_\padding\x
        ElseIf Not _this_\align\left
          _address_\x = ( _width_ - _address_\width ) / 2           
        Else
          _address_\x =                                    _this_\padding\x
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_y_( _this_, _address_, _height_, _rotate_ )
      If _rotate_ = 90                  
        If _this_\align\bottom
          _address_\y = _height_                         - _this_\padding\y
        ElseIf Not _this_\align\top
          _address_\y = ( _height_ + _address_\width ) / 2
        Else
          _address_\y = _address_\width                   + _this_\padding\y
        EndIf
      EndIf
      
      If _rotate_ = 270                 
        If _this_\align\bottom
          _address_\y = ( _height_ - _address_\width )      - _this_\padding\y
        ElseIf Not _this_\align\top
          _address_\y = ( _height_ - _address_\width ) / 2
        Else
          _address_\y =                                    _this_\padding\y
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_flag_( _this_, _parent_, _flag_ )
      If _flag_ & #__flag_autosize = #__flag_autosize
        _this_\align.allocate( ALIGN )
        _this_\align\autoSize = 1
        _this_\align\left = 1
        _this_\align\top = 1
        _this_\align\right = 1
        _this_\align\bottom = 1
        
        If _parent_
          _parent_\color\back =- 1
          ;           _parent_\color\_alpha = 0
          ;           _parent_\color\_alpha[1] = 0
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Macro _set_text_( _this_, _text_, _flag_ )
      ;     If Not _this_\text
      ;       _this_\text.allocate( TEXT )
      ;     EndIf
      
      If _this_\text
        _this_\text\change = #True
        
        _this_\text\editable = Bool( Not constants::_check_( _flag_, #__text_readonly ) )
        _this_\text\lower = constants::_check_( _flag_, #__text_lowercase )
        _this_\text\upper = constants::_check_( _flag_, #__text_uppercase )
        _this_\text\pass = constants::_check_( _flag_, #__text_password )
        _this_\text\invert = constants::_check_( _flag_, #__text_invert )
        
        _set_align_( _this_\text, 
                     constants::_check_( _flag_, #__text_left ),
                     constants::_check_( _flag_, #__text_top ),
                     constants::_check_( _flag_, #__text_right ),
                     constants::_check_( _flag_, #__text_bottom ),
                     constants::_check_( _flag_, #__text_center ) )
        
        If _this_\text\invert 
          _this_\text\rotate = Bool( _this_\vertical )*270 + Bool( Not _this_\vertical )*180
        Else
          _this_\text\rotate = Bool( _this_\vertical )*90
        EndIf
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          _this_\text\caret\pos[1] =- 1
          _this_\text\caret\pos[2] =- 1
          _this_\cursor = #PB_Cursor_IBeam
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0] = $FFFFFFFF 
          Else
            _this_\color\back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
        ;  _this_\text\fontID = root( )\text\fontID
      EndIf
      
      ; padding
      If _this_\type = #__type_Text
        _this_\text\padding\x = 1
      ElseIf _this_\type = #__type_Button
        _this_\text\padding\x = 4
        _this_\text\padding\y = 4
      ElseIf _this_\type = #__type_Editor
        _this_\text\padding\y = 6
        _this_\text\padding\x = 6
      ElseIf _this_\type = #__type_String
        _this_\text\padding\x = 3
        _this_\text\padding\y = 0
        
      ElseIf _this_\type = #__type_Option Or 
             _this_\type = #__type_CheckBox 
        _this_\text\padding\x = _this_\button\width + 8
      EndIf
      
      
      ; multiline
      If constants::_check_( _flag_, #__text_wordwrap )
        _this_\text\multiLine =- 1
        
      ElseIf constants::_check_( _flag_, #__text_multiline )
        _this_\text\multiLine = 1
      Else
        _this_\text\multiLine = 0 
      EndIf
      
      If _this_\type = #__type_Text
        _this_\text\multiLine =- 1
        
      ElseIf _this_\type = #__type_Option Or 
             _this_\type = #__type_CheckBox Or 
             _this_\type = #__type_HyperLink
        ; wrap text
        _this_\text\multiline =- CountString( _text_, #LF$ )
        
      ElseIf _this_\type = #__type_Editor
        If Not _this_\text\multiLine
          _this_\text\multiLine = 1
        EndIf
        
      ElseIf _this_\type = #__type_String
        _this_\text\multiLine = 0
      EndIf
      
      If _text_
        SetText( _this_, _text_ )
      EndIf
      
    EndMacro
    
    Macro _set_image_( _this_, _address_, _image_ )
      If IsImage( _image_ )
        _address_\change = 1
        
        If _address_\size
          ResizeImage( _image_, 
                       _address_\size, 
                       _address_\size )
          
          _address_\width = _address_\size
          _address_\height = _address_\size
        Else
          _address_\width = ImageWidth( _image_ )
          _address_\height = ImageHeight( _image_ )
        EndIf  
        
        _address_\img = _image_ 
        _address_\id = ImageID( _image_ )
        
        _this_\row\margin\width = _address_\padding\x + 
                                  _address_\width + 2
      Else
        _address_\change =- 1
        _address_\img =- 1
        _address_\id = 0
        _address_\width = 0
        _address_\height = 0
      EndIf
    EndMacro
    
    Macro _set_text_flag_( _this_, _flag_, _x_ = 0, _y_ = 0 )
      ;     If Not _this_\text
      ;       _this_\text.allocate( TEXT )
      ;     EndIf
      
      If _this_\text
        _this_\text\x = _x_
        _this_\text\y = _y_
        ; _this_\text\_padding = 5
        _this_\text\change = #True
        
        _this_\text\editable = Bool( Not constants::_check_( _flag_, #__text_readonly ) )
        _this_\text\lower = constants::_check_( _flag_, #__text_lowercase )
        _this_\text\upper = constants::_check_( _flag_, #__text_uppercase )
        _this_\text\pass = constants::_check_( _flag_, #__text_password )
        _this_\text\invert = constants::_check_( _flag_, #__text_invert )
        
        _set_align_( _this_\text, 
                     constants::_check_( _flag_, #__text_left ),
                     constants::_check_( _flag_, #__text_top ),
                     constants::_check_( _flag_, #__text_right ),
                     constants::_check_( _flag_, #__text_bottom ),
                     constants::_check_( _flag_, #__text_center ) )
        
        
        If constants::_check_( _flag_, #__text_wordwrap )
          _this_\text\multiLine =- 1
        ElseIf constants::_check_( _flag_, #__text_multiline )
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0 
        EndIf
        
        If _this_\text\invert 
          _this_\text\rotate = Bool( _this_\vertical )*270 + Bool( Not _this_\vertical )*180
        Else
          _this_\text\rotate = Bool( _this_\vertical )*90
        EndIf
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          _this_\text\caret\pos[1] =- 1
          _this_\text\caret\pos[2] =- 1
          _this_\cursor = #PB_Cursor_IBeam
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0] = $FFFFFFFF 
          Else
            _this_\color\back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
        ;  _this_\text\fontID = root( )\text\fontID
      EndIf
      
    EndMacro
    
    Macro _set_hide_state_( _this_ )
      _this_\hide = Bool( _this_\hide[1] Or _this_\parent\hide Or 
                          ( _this_\parent\type = #__type_Panel And 
                            _this_\parent\_tab\index[#__tab_2] <> _this_\tabindex ) )
    EndMacro
    
    Macro _set_check_state_( _address_, _three_state_ )
      ; change checkbox state
      Select _address_\state 
        Case #PB_Checkbox_Unchecked 
          If _three_state_
            _address_\state = #PB_Checkbox_Inbetween
          Else
            _address_\state = #PB_Checkbox_Checked
          EndIf
        Case #PB_Checkbox_Checked : _address_\state = #PB_Checkbox_Unchecked
        Case #PB_Checkbox_Inbetween : _address_\state = #PB_Checkbox_Checked
      EndSelect
    EndMacro
    
    
    ;-
    Macro make_scrollarea_x( _this_, _address_ );, _rotate_ )
                                                ; make horizontal scroll x
      If _this_\scroll\h
        If _address_\align\right
          _this_\x[#__c_required] = ( _this_\width[#__c_inner] - _this_\width[#__c_required] + _this_\scroll\h\bar\page\end ) - ( _this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min )
        ElseIf Not _address_\align\left ; horizontal center
          _this_\x[#__c_required] = ( _this_\width[#__c_inner] -  _this_\width[#__c_required] + _this_\scroll\h\bar\page\end ) / 2 - ( _this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min )
        Else
          _this_\x[#__c_required] =- ( _this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min )
        EndIf
      Else
        If _address_\align\right
          _this_\x[#__c_required] = ( _this_\width[#__c_inner] - _this_\width[#__c_required] )
        ElseIf Not _address_\align\left ; horizontal center
          _this_\x[#__c_required] = ( _this_\width[#__c_inner] -  _this_\width[#__c_required] ) / 2
        Else
          _this_\x[#__c_required] = 0
        EndIf
      EndIf
    EndMacro    
    
    Macro make_scrollarea_y( _this_, _address_, _rotate_=0 )
      ; make vertical scroll y
      If _this_\scroll\v
        If _address_\align\bottom
          _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\scroll\v\bar\page\end ) - ( _this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min )
        ElseIf Not _address_\align\top ; vertical center
          _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\scroll\v\bar\page\end ) / 2 - ( _this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min )
        Else
          _this_\y[#__c_required] =- ( _this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min )
        EndIf
      Else
        If _address_\align\bottom
          _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] )
        ElseIf Not _address_\align\top ; vertical center
          If _this_\button\height And Not _address_\align\left And Not _address_\align\right
            If _rotate_ = 0
              _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\button\height ) / 2
            Else
              _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] - _this_\button\height ) / 2
            EndIf
          Else
            _this_\y[#__c_required] = ( _this_\height[#__c_inner] - _this_\height[#__c_required] ) / 2
          EndIf
        Else
          _this_\y[#__c_required] = 0
        EndIf
      EndIf
    EndMacro
    
    
    ;- 
    Procedure.i TypeFromClass( class.s )
      Protected result.i
      
      Select Trim( LCase( class.s ) )
        Case "popupmenu"      : result = #__type_popupmenu
          ;case "property"       : result = #__type_property
        Case "window"         : result = #__type_window
          
        Case "button"         : result = #__type_Button
        Case "buttonimage"    : result = #__type_ButtonImage
        Case "calendar"       : result = #__type_Calendar
        Case "canvas"         : result = #__type_Canvas
        Case "checkbox"       : result = #__type_CheckBox
        Case "combobox"       : result = #__type_ComboBox
        Case "container"      : result = #__type_Container
        Case "date"           : result = #__type_Date
        Case "editor"         : result = #__type_Editor
        Case "explorercombo"  : result = #__type_ExplorerCombo
        Case "explorerlist"   : result = #__type_ExplorerList
        Case "explorertree"   : result = #__type_ExplorerTree
        Case "frame"          : result = #__type_Frame
        Case "hyperlink"      : result = #__type_HyperLink
        Case "image"          : result = #__type_Image
        Case "ipaddress"      : result = #__type_IPAddress
        Case "listicon"       : result = #__type_ListIcon
        Case "listview"       : result = #__type_ListView
        Case "mdi"            : result = #__type_MDI
        Case "opengl"         : result = #__type_OpenGL
        Case "option"         : result = #__type_Option
        Case "panel"          : result = #__type_Panel
        Case "progress"       : result = #__type_ProgressBar
        Case "scintilla"      : result = #__type_Scintilla
        Case "scrollarea"     : result = #__type_ScrollArea
        Case "scroll"         : result = #__type_ScrollBar
        Case "shortcut"       : result = #__type_Shortcut
        Case "spin"           : result = #__type_Spin
        Case "splitter"       : result = #__type_Splitter
        Case "string"         : result = #__type_String
        Case "text"           : result = #__type_Text
        Case "track"       : result = #__type_TrackBar
        Case "tree"           : result = #__type_Tree
        Case "unknown"        : result = #__type_Unknown
        Case "web"            : result = #__type_Web
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s ClassFromType( type.i )
      Protected result.s
      
      Select type
        Case #__type_root           : result.s = "root"
        Case #__type_statusbar      : result.s = "status"
        Case #__type_popupmenu      : result.s = "popupmenu"
        Case #__type_menu           : result.s = "menu"
        Case #__type_toolbar        : result.s = "tool"
          
        Case #__type_window         : result.s = "window"
        Case #__type_Unknown        : result.s = "create"
        Case #__type_Button         : result.s = "button"
        Case #__type_String         : result.s = "string"
        Case #__type_Text           : result.s = "text"
        Case #__type_CheckBox       : result.s = "checkbox"
        Case #__type_Option         : result.s = "option"
        Case #__type_ListView       : result.s = "listview"
        Case #__type_Frame          : result.s = "frame"
        Case #__type_ComboBox       : result.s = "combobox"
        Case #__type_Image          : result.s = "image"
        Case #__type_HyperLink      : result.s = "hyperlink"
        Case #__type_Container      : result.s = "container"
        Case #__type_ListIcon       : result.s = "listicon"
        Case #__type_IPAddress      : result.s = "ipaddress"
        Case #__type_ProgressBar    : result.s = "progress"
        Case #__type_ScrollBar      : result.s = "scroll"
        Case #__type_ScrollArea     : result.s = "scrollarea"
        Case #__type_TrackBar       : result.s = "track"
        Case #__type_Web            : result.s = "web"
        Case #__type_ButtonImage    : result.s = "buttonimage"
        Case #__type_Calendar       : result.s = "calendar"
        Case #__type_Date           : result.s = "date"
        Case #__type_Editor         : result.s = "editor"
        Case #__type_ExplorerList   : result.s = "explorerlist"
        Case #__type_ExplorerTree   : result.s = "explorertree"
        Case #__type_ExplorerCombo  : result.s = "explorercombo"
        Case #__type_Spin           : result.s = "spin"
        Case #__type_Tree           : result.s = "tree"
        Case #__type_Panel          : result.s = "panel"
        Case #__type_Splitter       : result.s = "splitter"
        Case #__type_MDI            : result.s = "mdi"
        Case #__type_Scintilla      : result.s = "scintilla"
        Case #__type_Shortcut       : result.s = "shortcut"
        Case #__type_Canvas         : result.s = "canvas"
          
          ;     case #__type_imagebutton    : result.s = "imagebutton"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    
    Procedure.s ClassFromEvent( event.i )
      Protected result.s
      
      Select event
        Case #__event_free             : result.s = "#PB_EventType_Free"    
        Case #__event_drop             : result.s = "#PB_EventType_Drop"
        Case #__event_create           : result.s = "#PB_EventType_Create"
        Case #__event_sizeitem         : result.s = "#PB_EventType_SizeItem"
          
        Case #__event_repaint          : result.s = "#PB_EventType_Repaint"
        Case #__event_resizeend        : result.s = "#PB_EventType_ResizeEnd"
        Case #__event_scrollchange     : result.s = "#PB_EventType_ScrollChange"
          
        Case #__event_closewindow      : result.s = "#PB_EventType_CloseWindow"
        Case #__event_maximizewindow   : result.s = "#PB_EventType_MaximizeWindow"
        Case #__event_minimizewindow   : result.s = "#PB_EventType_MinimizeWindow"
        Case #__event_restorewindow    : result.s = "#PB_EventType_RestoreWindow"
          
        Case #__event_mouseenter       : result.s = "#PB_EventType_MouseEnter"       ; The mouse cursor entered the gadget
        Case #__event_mouseleave       : result.s = "#PB_EventType_MouseLeave"       ; The mouse cursor left the gadget
        Case #__event_mousemove        : result.s = "#PB_EventType_MouseMove"        ; The mouse cursor moved
        Case #__event_mousewheel       : result.s = "#PB_EventType_MouseWheel"       ; The mouse wheel was moved
        Case #__event_leftButtonDown   : result.s = "#PB_EventType_LeftButtonDown"   ; The left mouse button was pressed
        Case #__event_leftButtonUp     : result.s = "#PB_EventType_LeftButtonUp"     ; The left mouse button was released
        Case #__event_leftclick        : result.s = "#PB_EventType_LeftClick"        ; A click With the left mouse button
        Case #__event_leftdoubleclick  : result.s = "#PB_EventType_LeftDoubleClick"  ; A double-click With the left mouse button
        Case #__event_rightbuttondown  : result.s = "#PB_EventType_RightButtonDown"  ; The right mouse button was pressed
        Case #__event_rightbuttonup    : result.s = "#PB_EventType_RightButtonUp"    ; The right mouse button was released
        Case #__event_rightclick       : result.s = "#PB_EventType_RightClick"       ; A click With the right mouse button
        Case #__event_rightdoubleclick : result.s = "#PB_EventType_RightDoubleClick" ; A double-click With the right mouse button
        Case #__event_middlebuttondown : result.s = "#PB_EventType_MiddleButtonDown" ; The middle mouse button was pressed
        Case #__event_middlebuttonup   : result.s = "#PB_EventType_MiddleButtonUp"   ; The middle mouse button was released
        Case #__event_focus            : result.s = "#PB_EventType_Focus"            ; The gadget gained keyboard focus
        Case #__event_lostfocus        : result.s = "#PB_EventType_LostFocus"        ; The gadget lost keyboard focus
        Case #__event_keydown          : result.s = "#PB_EventType_KeyDown"          ; A key was pressed
        Case #__event_keyup            : result.s = "#PB_EventType_KeyUp"            ; A key was released
        Case #__event_input            : result.s = "#PB_EventType_Input"            ; Text input was generated
        Case #__event_resize           : result.s = "#PB_EventType_Resize"           ; The gadget has been resized
        Case #__event_statuschange     : result.s = "#PB_EventType_StatusChange"
        Case #__event_titlechange      : result.s = "#PB_EventType_TitleChange"
        Case #__event_change           : result.s = "#PB_EventType_Change"
        Case #__event_dragstart        : result.s = "#PB_EventType_DragStart"
        Case #__event_returnkey        : result.s = "#PB_EventType_returnKey"
        Case #__event_closeitem        : result.s = "#PB_EventType_CloseItem"
          
        Case #__event_down             : result.s = "#PB_EventType_Down"
        Case #__event_up               : result.s = "#PB_EventType_Up"
          
        Case #__event_mousewheelX      : result.s = "#PB_EventType_MouseWheelX"
        Case #__event_mousewheelY      : result.s = "#PB_EventType_MouseWheelY"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    
    ;-
    Procedure  ClipPut( *this._s_WIDGET, x, y, width, height )
      Protected clip_x, clip_y, clip_w, clip_h
      
      ; clip inner coordinate
      If *this\x[#__c_clip] < x
        clip_x = x
      Else
        clip_x = *this\x[#__c_clip]
      EndIf
      
      If *this\y[#__c_clip] < y
        clip_y = y
      Else
        clip_y = *this\y[#__c_clip]
      EndIf
      
      If *this\width[#__c_clip] > width
        clip_w = width
      Else
        clip_w = *this\width[#__c_clip]
      EndIf
      
      If *this\height[#__c_clip] > height
        clip_h = height
      Else
        clip_h = *this\height[#__c_clip]
      EndIf
      
      ClipOutput( clip_x, clip_y, clip_w, clip_h )
    EndProcedure
    
    Declare Reclip( *this._s_WIDGET, childrens.b )
    Procedure   Reclip( *this._s_WIDGET, childrens.b )
      Macro _clip_content_( _address_, _mode_= )
        ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      EndMacro
      
      Macro _clip_caption_( _this_ )
        ClipPut( _this_, _this_\caption\x[#__c_inner], _this_\caption\y[#__c_inner], _this_\caption\width[#__c_inner], _this_\caption\height[#__c_inner] )
        
        ;ClipPut( _this_, _this_\x[#__c_frame] + _this_\bs, _this_\y[#__c_frame] + _this_\fs, _this_\width[#__c_frame] - _this_\bs*2, _this_\fs[2] - _this_\fs*2 )
      EndMacro
      
      Macro _clip_width_( _address_, _x_width_, _parent_ix_iwidth_, _mode_ = )
        If _is_child_no_integral_( _address_ )
          _address_\width#_mode_ = (_address_\parent\x#_mode_ + _address_\parent\width#_mode_)  - _address_\x#_mode_
        ElseIf _address_\parent And 
               (_address_\parent\x#_mode_ + _address_\parent\width#_mode_) > 0 And
               (_address_\parent\x#_mode_ + _address_\parent\width#_mode_) < (_x_width_) And 
               (_parent_ix_iwidth_) > (_address_\parent\x#_mode_ + _address_\parent\width#_mode_)  
          
          _address_\width#_mode_ = (_address_\parent\x#_mode_ + _address_\parent\width#_mode_)  - _address_\x#_mode_
        ElseIf _address_\parent And (_parent_ix_iwidth_) > 0 And (_parent_ix_iwidth_) < (_x_width_)
          
          _address_\width#_mode_ = (_parent_ix_iwidth_) - _address_\x#_mode_
        Else
          _address_\width#_mode_ = (_x_width_) - _address_\x#_mode_
        EndIf
        
        If _address_\width#_mode_ < 0
          _address_\width#_mode_ = 0
        EndIf
      EndMacro
      
      Macro _clip_height_( _address_, _y_height_, _parent_iy_iheight_, _mode_ = )
        If _is_child_no_integral_( _address_ )
          _address_\height#_mode_ = (_address_\parent\y#_mode_ + _address_\parent\height#_mode_)  - _address_\y#_mode_
        ElseIf _address_\parent And 
               (_address_\parent\y#_mode_ + _address_\parent\height#_mode_) > 0 And 
               (_address_\parent\y#_mode_ + _address_\parent\height#_mode_) < (_y_height_) And
               (_parent_iy_iheight_) > (_address_\parent\y#_mode_ + _address_\parent\height#_mode_) 
          
          _address_\height#_mode_ = (_address_\parent\y#_mode_ + _address_\parent\height#_mode_) - _address_\y#_mode_
        ElseIf _address_\parent And (_parent_iy_iheight_) > 0 And (_parent_iy_iheight_) < (_y_height_)
          
          _address_\height#_mode_ = (_parent_iy_iheight_) - _address_\y#_mode_
        Else
          _address_\height#_mode_ = (_y_height_) - _address_\y#_mode_
        EndIf
        
        If _address_\height#_mode_ < 0
          _address_\height#_mode_ = 0
        EndIf
      EndMacro
      
      ; then move and size parent set clip coordinate
      Protected _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner]
      Protected _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner]
      
      If _is_child_integral_( *this )
        If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ; And *this\parent\_tab And *this\parent\_tab = *this
          _p_x2_ = *this\parent\x[#__c_frame] + *this\parent\width[#__c_frame]
          _p_y2_ = *this\parent\y[#__c_frame] + *this\parent\height[#__c_frame]
        EndIf
        
        If *this\type = #__type_ScrollBar ; And _is_scrollbars_( *this )
          _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_container]
          _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_container]
        EndIf
      EndIf
      
      ; for the splitter childrens
      If *this\parent\type = #__type_Splitter
        If *this\parent\gadget[#__split_1] = *this
          _p_x2_ = *this\parent\bar\button[#__split_b1]\x + *this\parent\bar\button[#__split_b1]\width
          _p_y2_ = *this\parent\bar\button[#__split_b1]\y + *this\parent\bar\button[#__split_b1]\height
        EndIf
        If *this\parent\gadget[#__split_2] = *this
          _p_x2_ = *this\parent\bar\button[#__split_b2]\x + *this\parent\bar\button[#__split_b2]\width
          _p_y2_ = *this\parent\bar\button[#__split_b2]\y + *this\parent\bar\button[#__split_b2]\height
        EndIf
      EndIf
      
      ; for the scrollarea childrens except scrollbars
      If *this\parent\type = #__type_ScrollArea Or
         *this\parent\type = #__type_MDI 
        
        If Not _is_scrollbars_( *this )
          If _p_x2_ > *this\parent\x[#__c_inner] + *this\parent\width[#__c_required]
            _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_required]
          EndIf
          If _p_y2_ > *this\parent\y[#__c_inner] + *this\parent\height[#__c_required]
            _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_required]
          EndIf
        EndIf
      EndIf
      
      ; clip inner scrollbars parent
      If *this\parent\scroll 
        ;         _p_x2_ = *this\parent\parent\x[#__c_inner] + *this\parent\parent\width[#__c_inner]
        ;         _p_y2_ = *this\parent\parent\y[#__c_inner] + *this\parent\parent\height[#__c_inner]
        
        If *this = *this\parent\scroll\h
          _clip_width_( *this\parent, *this\x[#__c_inner] + *this\parent\scroll\h\bar\page\len, _p_x2_, [#__c_clip2] )
        EndIf
        
        If *this = *this\parent\scroll\v
          _clip_height_( *this\parent, *this\y[#__c_inner] + *this\parent\scroll\v\bar\page\len, _p_y2_, [#__c_clip2] )
        EndIf
      EndIf
      
      
      ; then move and size parent set clip coordinate
      ; x&y - clip screen coordinate  
      If _is_child_no_integral_( *this )
        *this\x[#__c_clip] = *this\parent\x[#__c_clip]
      ElseIf *this\parent And 
             *this\parent\x[#__c_inner] > *this\x[#__c_screen] And
             *this\parent\x[#__c_inner] > *this\parent\x[#__c_clip]
        *this\x[#__c_clip] = *this\parent\x[#__c_inner]
      ElseIf *this\parent And *this\parent\x[#__c_clip] > *this\x[#__c_screen] 
        *this\x[#__c_clip] = *this\parent\x[#__c_clip]
      Else
        *this\x[#__c_clip] = *this\x[#__c_screen]
      EndIf
      If _is_child_no_integral_( *this )
        *this\y[#__c_clip] = *this\parent\y[#__c_clip]
      ElseIf *this\parent And 
             *this\parent\y[#__c_inner] > *this\y[#__c_screen] And 
             *this\parent\y[#__c_inner] > *this\parent\y[#__c_clip]
        *this\y[#__c_clip] = *this\parent\y[#__c_inner]
      ElseIf *this\parent And *this\parent\y[#__c_clip] > *this\y[#__c_screen] 
        *this\y[#__c_clip] = *this\parent\y[#__c_clip]
      Else
        *this\y[#__c_clip] = *this\y[#__c_screen]
      EndIf
      If *this\x[#__c_clip] < 0 : *this\x[#__c_clip] = 0 : EndIf
      If *this\y[#__c_clip] < 0 : *this\y[#__c_clip] = 0 : EndIf
      
      ; x&y - clip frame coordinate
      If *this\x[#__c_clip] < *this\x[#__c_frame]
        *this\x[#__c_clip1] = *this\x[#__c_frame] 
      Else
        *this\x[#__c_clip1] = *this\x[#__c_clip]
      EndIf
      If *this\y[#__c_clip] < *this\y[#__c_frame] 
        *this\y[#__c_clip1] = *this\y[#__c_frame] 
      Else
        *this\y[#__c_clip1] = *this\y[#__c_clip]
      EndIf
      
      ; x&y - clip inner coordinate
      If *this\x[#__c_clip] < *this\x[#__c_inner] 
        *this\x[#__c_clip2] = *this\x[#__c_inner] 
      Else
        *this\x[#__c_clip2] = *this\x[#__c_clip]
      EndIf
      If *this\y[#__c_clip] < *this\y[#__c_inner] 
        *this\y[#__c_clip2] = *this\y[#__c_inner] 
      Else
        *this\y[#__c_clip2] = *this\y[#__c_clip]
      EndIf
      
      
      ; width&height - clip coordinate
      _clip_width_( *this, *this\x[#__c_screen] + *this\width[#__c_screen], _p_x2_, [#__c_clip] )
      _clip_height_( *this, *this\y[#__c_screen] + *this\height[#__c_screen], _p_y2_, [#__c_clip] )
      
      ; width&height - clip frame coordinate
      _clip_width_( *this, *this\x[#__c_frame] + *this\width[#__c_frame], _p_x2_, [#__c_clip1] )
      _clip_height_( *this, *this\y[#__c_frame] + *this\height[#__c_frame], _p_y2_, [#__c_clip1] )
      
      ; width&height - clip inner coordinate
      _clip_width_( *this, *this\x[#__c_inner] + *this\width[#__c_inner], _p_x2_, [#__c_clip2] )
      _clip_height_( *this, *this\y[#__c_inner] + *this\height[#__c_inner], _p_y2_, [#__c_clip2] )
      
      
      ;       ; clip child tab bar
      ;       If *this\parent\_tab And 
      ;          *this\parent\type = #__type_panel
      ;         Reclip( *this\parent, 0 )
      ;       EndIf
      
      ; clip child tab bar
      If *this\_tab And 
         *this\type = #__type_Panel
        Reclip( *this\_tab, 0 )
      EndIf
      
      ; ;       ; mdi(demo) show bug
      ; ;       ; clip child scroll bars 
      ; ;       If *this\scroll 
      ; ;         If *this\scroll\v 
      ; ;           Reclip( *this\scroll\v, 0 )
      ; ;         EndIf
      ; ;         If *this\scroll\h
      ; ;           Reclip( *this\scroll\h, 0 )
      ; ;         EndIf
      ; ;       EndIf
      
      
      ;
      If ( *this\width[#__c_clip] Or 
           *this\height[#__c_clip] )
        *this\draw_widget = #True
      Else
        *this\draw_widget = #False
      EndIf
      
      If childrens And *this\container
        If StartEnumerate( *this ) 
          If Widget( )\parent = *this                     And Not _is_child_no_integral_( *this )
            Reclip( Widget( ), childrens )
          EndIf
          StopEnumerate( )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.b Resize( *this._s_WIDGET, x.l,y.l,width.l,height.l )
      Protected.b result
      Protected.l ix,iy,iwidth,iheight,  Change_x, Change_y, Change_width, Change_height
      
      ; 
      If *this\bs < *this\fs 
        *this\bs = *this\fs 
      EndIf
      
      If *this\fs[1] <> *this\BarWidth 
        *this\fs[1] = *this\BarWidth
      EndIf
      
      If *this\fs[2] <> *this\BarHeight + *this\MenuBarHeight + *this\ToolBarHeight
        *this\fs[2] = *this\BarHeight + *this\MenuBarHeight + *this\ToolBarHeight
      EndIf
      
      With *this
        ; #__flag_autoSize
        If *this\parent And Not _is_root_container_( *this ) And 
           *this\align And *this\align\autosize And
           *this\parent\type <> #__type_Splitter And
           *this\align\left And *this\align\top And 
           *this\align\right And *this\align\bottom
          
          x = 0; \align\delta\x
          Y = 0; \align\delta\y
          width = *this\parent\width[#__c_inner] ; - \align\delta\x
          height = *this\parent\height[#__c_inner] ; - \align\delta\y
          
          If _is_root_( *this\parent )
            width - *this\fs*2 - *this\fs[1]
            height - *this\fs*2 - *this\fs[2]
          EndIf
        EndIf
        
        ; Debug " resize - "+*this\class
        
        ;
        If transform( ) And 
           transform( )\grid\size And
           *this = a_widget( ) And 
           *this <> transform( )\main ;And 1=3
          
          If x <> #PB_Ignore 
            If transform( )\grid\size > 1
              x + ( x%transform( )\grid\size ) 
              x = ( x/transform( )\grid\size ) * transform( )\grid\size
            EndIf
            If *this\parent And *this\parent\container
              x - *this\parent\fs
            EndIf
          EndIf
          
          If y <> #PB_Ignore 
            If transform( )\grid\size > 1
              y + ( y%transform( )\grid\size ) 
              y = ( y/transform( )\grid\size ) * transform( )\grid\size
            EndIf
            If *this\parent And *this\parent\container
              y - *this\parent\fs
            EndIf
          EndIf
          
          If width <> #PB_Ignore 
            If transform( )\grid\size > 1
              width + ( width%transform( )\grid\size ) 
              width = ( width/transform( )\grid\size ) * transform( )\grid\size + 1 
            EndIf
          EndIf
          
          If height <> #PB_Ignore
            If transform( )\grid\size > 1
              height + ( height%transform( )\grid\size ) 
              height = ( height/transform( )\grid\size ) * transform( )\grid\size + 1 
            EndIf
          EndIf
        EndIf
        
        ;
        If x = #PB_Ignore 
          x = *this\x[#__c_container]
        Else
          If *this\parent 
            If Not _is_child_integral_( *this )
              x + *this\parent\x[#__c_required] 
            EndIf 
            *this\x[#__c_container] = x
          EndIf 
        EndIf  
        
        If y = #PB_Ignore 
          y = *this\y[#__c_container] 
        Else
          If *this\parent 
            If Not _is_child_integral_( *this )
              y + *this\parent\y[#__c_required] 
            EndIf 
            *this\y[#__c_container] = y
          EndIf 
        EndIf  
        
        If width = #PB_Ignore 
          If *this\type = #__type_window And Not *this\_a_transform
            width = \width[#__c_container] + \fs*2 + ( *this\fs[1] + *this\fs[3] )
          Else
            width = \width[#__c_frame] 
          EndIf
        Else
          If *this\type = #__type_window And Not *this\_a_transform
            width + *this\fs*2 + ( *this\fs[1] + *this\fs[3] )
          EndIf
        EndIf  
        If width < 0 
          width = 0 
        EndIf
        
        If height = #PB_Ignore 
          If *this\type = #__type_window And Not *this\_a_transform 
            height = \height[#__c_container] + \fs*2 + ( *this\fs[2] + *this\fs[4] )
          Else
            height = \height[#__c_frame]
          EndIf
        Else
          If *this\type = #__type_window And Not *this\_a_transform 
            height + *this\fs*2 + ( *this\fs[2] + *this\fs[4] )
          EndIf
        EndIf
        If Height < 0 
          Height = 0 
        EndIf
        
        ;
        If *this\parent                        
          ;           If _is_child_no_integral_( *this )
          ;             x + *this\parent\x[#__c_frame]
          ;             y + *this\parent\y[#__c_frame]
          ;           Else
          x + *this\parent\x[#__c_inner]
          y + *this\parent\y[#__c_inner]
          ;           EndIf
        EndIf
        
        ;
        If _is_root_container_( *this )
          ResizeWindow( *this\root\canvas\window, #PB_Ignore,#PB_Ignore,width,height )
          ResizeGadget( *this\root\canvas\gadget, #PB_Ignore,#PB_Ignore,width,height )
          
          x = ( \bs*2 - \fs*2 )
          y = ( \bs*2 - \fs*2 )
          width - ( \bs*2 - \fs*2 )*2
          height - ( \bs*2 - \fs*2 )*2
          
          *this\x[#__c_frame] = #PB_Ignore
          *this\y[#__c_frame] = #PB_Ignore
          ;           *this\width[#__c_frame] = #PB_Ignore
          ;           *this\height[#__c_frame] = #PB_Ignore
        EndIf
        
        ; inner x&y position
        ix = ( x + *this\fs + *this\fs[1] )
        iy = ( y + *this\fs + *this\fs[2] )
        
        ;
        If *this\x[#__c_inner] <> ix
          Change_x = ix - *this\x[#__c_inner] 
          
          If Change_x
            *this\resize | #__resize_x | #__resize_change
            
            *this\x[#__c_frame] = x 
            *this\x[#__c_inner] = ix 
            *this\x[#__c_screen] = x - ( *this\bs - *this\fs ) 
            If *this\window
              *this\x[#__c_window] = x - *this\window\x[#__c_inner]
            EndIf
          EndIf
        EndIf 
        
        If *this\y[#__c_inner] <> iy
          Change_y = iy - *this\y[#__c_inner] 
          
          If Change_y
            *this\resize | #__resize_y | #__resize_change
            
            *this\y[#__c_frame] = y 
            *this\y[#__c_inner] = iy
            *this\y[#__c_screen] = y - ( *this\bs - *this\fs )
            If *this\window
              *this\y[#__c_window] = y - *this\window\y[#__c_inner]
            EndIf
          EndIf
        EndIf 
        
        If *this\type = #__type_window And Not *this\_a_transform
          If *this\width[#__c_frame] <> width 
            Change_width = width - *this\width[#__c_frame] 
            
            If Change_width
              *this\resize | #__resize_width | #__resize_change
              
              *this\width[#__c_frame] = width 
              *this\width[#__c_screen] = width + ( *this\bs*2 - *this\fs*2 ) 
              *this\width[#__c_container] = width - *this\fs*2 - ( *this\fs[1] + *this\fs[3] )
              If *this\width[#__c_container] < 0 
                *this\width[#__c_container] = 0 
              EndIf
              *this\width[#__c_inner] = *this\width[#__c_container]
            EndIf
          EndIf 
          
          If *this\height[#__c_frame] <> height 
            Change_height = height - *this\height[#__c_frame] 
            
            If Change_height
              *this\resize | #__resize_height | #__resize_change
              
              *this\height[#__c_frame] = height 
              *this\height[#__c_screen] = height + ( *this\bs*2 - *this\fs*2 )
              *this\height[#__c_container] = height - *this\fs*2 - ( *this\fs[2] + *this\fs[4] )
              If *this\height[#__c_container] < 0 
                *this\height[#__c_container] = 0 
              EndIf
              *this\height[#__c_inner] = *this\height[#__c_container]
            EndIf
          EndIf 
          
        Else
          iwidth = width  - *this\fs*2 - ( *this\fs[1] + *this\fs[3] )
          iheight = height - *this\fs*2 - ( *this\fs[2] + *this\fs[4] )
          
          If *this\width[#__c_container] <> iwidth 
            Change_width = iwidth - *this\width[#__c_container] 
            
            If Change_width
              *this\resize | #__resize_width | #__resize_change
              
              *this\width[#__c_frame] = width 
              *this\width[#__c_container] = iwidth
              *this\width[#__c_screen] = width + ( *this\bs*2 - *this\fs*2 ) 
              If *this\width[#__c_container] < 0 
                *this\width[#__c_container] = 0 
              EndIf
              *this\width[#__c_inner] = *this\width[#__c_container]
            EndIf
          EndIf 
          
          If *this\height[#__c_container] <> iheight 
            Change_height = iheight - *this\height[#__c_container] 
            
            If Change_height
              *this\resize | #__resize_height | #__resize_change
              
              *this\height[#__c_frame] = height 
              *this\height[#__c_container] = iheight
              *this\height[#__c_screen] = height + ( *this\bs*2 - *this\fs*2 )
              If *this\height[#__c_container] < 0 
                *this\height[#__c_container] = 0 
              EndIf
              *this\height[#__c_inner] = *this\height[#__c_container]
            EndIf
          EndIf 
        EndIf
        
        ;
        If Change_height Or Change_width
          If *this\type = #__type_Image Or
             *this\type = #__type_ButtonImage
            *this\image\change = 1
          EndIf
          
          If Change_height And *this\count\items And 
             *this\height[#__c_required] >= *this\height[#__c_inner] ; #__c_container
            *this\change = 1
          EndIf
          
          If Change_width And *this\count\items
            If *this\type <> #__type_Tree
              *this\change | #__resize_width
            EndIf
          EndIf
        EndIf
        
        
        ; parent mdi
        If *this\parent And 
           _is_child_integral_( *this ) And 
           *this\parent\type = #__type_MDI And 
           *this\parent\scroll And
           *this\parent\scroll\v <> *this And 
           *this\parent\scroll\h <> *this And
           *this\parent\scroll\v\bar\page\change = 0 And
           *this\parent\scroll\h\bar\page\change = 0
          
          _mdi_update_( *this\parent, *this\x[#__c_container], *this\y[#__c_container], *this\width[#__c_frame], *this\height[#__c_frame] )
        EndIf
        
        ; then move and size parent set clip ( width&height )
        If *this\parent And
           *this\parent <> *this
          Reclip( *this, #False )
        Else
          *this\x[#__c_clip] = *this\x[#__c_screen]
          *this\y[#__c_clip] = *this\y[#__c_screen]
          *this\width[#__c_clip] = *this\width[#__c_screen]
          *this\height[#__c_clip] = *this\height[#__c_screen]
          
          *this\x[#__c_clip1] = *this\x[#__c_frame]
          *this\y[#__c_clip1] = *this\y[#__c_frame]
          *this\width[#__c_clip1] = *this\width[#__c_frame]
          *this\height[#__c_clip1] = *this\height[#__c_frame]
          
          *this\x[#__c_clip2] = *this\x[#__c_inner]
          *this\y[#__c_clip2] = *this\y[#__c_inner]
          *this\width[#__c_clip2] = *this\width[#__c_inner]
          *this\height[#__c_clip2] = *this\height[#__c_inner]
        EndIf
        
        ;
        ; ---------------------------------
        ;
        If *this\type = #__type_Spin Or
           *this\type = #__type_TabBar Or *this\type = #__type_ToolBar Or
           *this\type = #__type_TrackBar Or
           *this\type = #__type_ScrollBar Or
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_Splitter
          
          If ( Change_width Or Change_height )
            *this\bar\change_tab_items =- 1
            Bar_Update( *this )
          EndIf
          Bar_Resize( *this )  
        EndIf
        
        If *this\type = #__type_Window
          result = Update( *this )
        EndIf
        
        
        ; if the widgets is composite
        If *this\type = #__type_Spin
          *this\width[#__c_inner] = *this\width[#__c_container] - *this\bs*2 - *this\bar\button[#__b_3]\size
        EndIf
        
        ; if the integral scroll bars
        If ( *this\scroll And *this\scroll\v And *this\scroll\h )
          ; resize vertical&horizontal scrollbars
          
          If ( Change_x Or Change_y )
            If Not *this\scroll\v\hide
              Resize( *this\scroll\v, #PB_Ignore, #PB_Ignore, #__scroll_buttonsize, #PB_Ignore )
            EndIf
            If Not *this\scroll\h\hide
              Resize( *this\scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #__scroll_buttonsize )
            EndIf
          EndIf
          
          If ( Change_width Or Change_height )
            Bar_Resizes( *this, 0, 0, *this\width[#__c_container], *this\height[#__c_container] )
          EndIf
          
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; if the integral tab bar 
        If *this\_tab And _is_child_integral_( *this\_tab )
          *this\x[#__c_inner] - *this\fs - *this\fs[1]
          *this\y[#__c_inner] - *this\fs - *this\fs[2] 
          
          If *this\type = #__type_Panel
            If *this\_tab\vertical
              Resize( *this\_tab, *this\_tab\bs, *this\_tab\bs, *this\BarWidth-*this\_tab\bs*2, *this\height[#__c_frame]-*this\_tab\bs*2 )
            Else
              Resize( *this\_tab, *this\_tab\bs, *this\_tab\bs, *this\width[#__c_frame]-*this\_tab\bs*2, *this\BarHeight-*this\_tab\bs*2 + *this\bs )
            EndIf
          EndIf
          If *this\type = #__type_window
            Resize( *this\_tab, *this\_tab\bs+*this\bs, *this\_tab\bs+*this\fs[2]-*this\fs[2]-*this\bs, *this\width[#__c_frame]-*this\bs*2-*this\_tab\bs*2, *this\fs[2]-*this\_tab\bs*2 + *this\bs )
          EndIf
          
          *this\x[#__c_inner] + *this\fs + ( *this\fs[1] + *this\fs[3] )
          *this\y[#__c_inner] + *this\fs + ( *this\fs[2] + *this\fs[4] )
        EndIf
        
        
        ; then move and size parent resize all childrens
        If *this\container And *this\count\childrens
          ; Protected.l x, y, width, height
          Protected x2,y2,pw,ph, pwd,phd, frame = #__c_frame
          If *this\type = #__type_window
            frame = #__c_inner
          EndIf
          
          If *this\align
            pw = ( *this\width[frame] - *this\align\delta\width )
            ph = ( *this\height[frame] - *this\align\delta\height )
            pwd = pw/2 
            phd = ph/2 
          EndIf
          
          If StartEnumerate( *this ) 
            If Not _is_scrollbars_( Widget( ) )
              
              If Widget( )\align
                x2 = ( Widget( )\align\delta\x + Widget( )\align\delta\width )
                y2 = ( Widget( )\align\delta\y + Widget( )\align\delta\height )
                
                Select Widget( )\align\h
                  Case 0, 3, 5 : x = Widget( )\align\delta\x                                                   
                  Case 1, 6    : x = Widget( )\align\delta\x + pwd
                  Case 2       : x = Widget( )\align\delta\x + pw   
                  Case 4       : x = Widget( )\align\delta\x * *this\width[frame] / *this\align\delta\width       
                EndSelect
                
                Select Widget( )\align\v
                  Case 0, 3, 5 : y = Widget( )\align\delta\y                                                   
                  Case 1, 6    : y = Widget( )\align\delta\y + phd 
                  Case 2       : y = Widget( )\align\delta\y + ph   
                  Case 4       : y = Widget( )\align\delta\y * *this\height[frame] / *this\align\delta\height       
                EndSelect
                
                Select Widget( )\align\h
                  Case 0       : width = x2
                  Case 1, 5    : width = x2 + pwd    ; center ( right & bottom )
                  Case 2, 3, 6 : width = x2 + pw     ; right & bottom
                  Case 4       : width = x2 * *this\width[frame] / *this\align\delta\width
                EndSelect
                
                Select Widget( )\align\v
                  Case 0       : height = y2
                  Case 1, 5    : height = y2 + phd    ; center ( right & bottom )
                  Case 2, 3, 6 : height = y2 + ph     ; right & bottom
                  Case 4       : height = y2 * *this\height[frame] / *this\align\delta\height
                EndSelect
                
                Resize( Widget( ), x, y, width - x, height - y )
              Else
                If (Change_x Or Change_y)
                  Resize( Widget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                ElseIf (Change_width Or Change_height)
                  Reclip( Widget( ), 1 )
                EndIf
              EndIf
            EndIf
            
            StopEnumerate( )
          EndIf
        EndIf
        
        ;
        If *this\draw_widget
        Else
          result = #True
        EndIf
        
        If *this\type = #__type_MDI
          _mdi_update_( *this, 0,0,0,0 )
        EndIf
        
        ; 
        If ( Change_x Or Change_y Or Change_width Or Change_height )
          If *this\_a_transform = 1 And a_widget( )
            ; anchors widgets
            a_move( a_widget( )\_a_id_, *this\x, *this\y, *this\width, *this\height, *this\container )
            
            Post( #__event_Resize, *this , transform( )\index )
          ElseIf *this\container And Not *this\root ;container <> #__type_root
            Post( #__event_Resize, *this )
          EndIf
          
          ProcedureReturn 1
        EndIf
        
      EndWith
    EndProcedure
    
    
    ;-
    ;-  BARs
    ;{
    Macro Area( _parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True )
      _parent_\scroll\v = Create( _parent_, _parent_\class+"_vertical", #__type_ScrollBar, 0,0,#__scroll_buttonsize,0,  0,_area_height_,_height_, #Null$, #__flag_child | #__bar_vertical, #__scroll_buttonsize, 7, _scroll_step_ )
      _parent_\scroll\h = Create( _parent_, _parent_\class+"_horizontal", #__type_ScrollBar, 0,0,0,#__scroll_buttonsize,  0,_area_width_,_width_, #Null$, #__flag_child, Bool( _mode_ )*#__scroll_buttonsize, 7, _scroll_step_ )
    EndMacro                                                  
    
    Macro Area_Draw( _this_ )
      If _this_\scroll
        _clip_content_( _this_, [#__c_clip] )
        
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And _this_\scroll\v\width[#__c_clip] > 0 And _this_\scroll\v\height[#__c_clip] > 0
          Bar_Draw( _this_\scroll\v )
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And _this_\scroll\h\width[#__c_clip] > 0 And _this_\scroll\h\height[#__c_clip] > 0
          Bar_Draw( _this_\scroll\h )
        EndIf
        
        If #__draw_scroll_box 
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          ; Scroll area coordinate
          Box( _this_\x[#__c_inner] + _this_\x[#__c_required] + _this_\text\padding\x, _this_\y[#__c_inner] + _this_\y[#__c_required] + _this_\text\padding\y, _this_\width[#__c_required] - _this_\text\padding\x*2, _this_\height[#__c_required] - _this_\text\padding\y*2, $FFFF0000 )
          Box( _this_\x[#__c_inner] + _this_\x[#__c_required], _this_\y[#__c_inner] + _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], $FF0000FF )
          
          If _this_\scroll\v And _this_\scroll\h
            Box( _this_\scroll\h\x[#__c_frame] + _this_\x[#__c_required], _this_\scroll\v\y[#__c_frame] + _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], $FF0000FF )
            
            ; Debug "" +  _this_\x[#__c_required]  + " " +  _this_\y[#__c_required]  + " " +  _this_\width[#__c_required]  + " " +  _this_\height[#__c_required]
            ; Box( _this_\scroll\h\x[#__c_frame] - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y[#__c_frame] - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF )
            
            ; page coordinate
            Box( _this_\scroll\h\x[#__c_frame], _this_\scroll\v\y[#__c_frame], _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00 )
          EndIf
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Procedure.i Tab_SetState( *this._s_WIDGET, State.l )
      Protected result.b
      
      ; prevent selection of a non-existent tab
      If State < 0 : State =- 1 : EndIf
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If *this\index[#__tab_2] <> State 
        *this\index[#__tab_2] = State
        *this\bar\change_tab_items = #True
        ;;Debug " - - - "
        
        If _is_child_integral_( *this ) ; *this\parent\_tab = *this 
          If StartEnumerate( *this\parent )
            ;; Debug widget( )\text\string
            
            _set_hide_state_( Widget( ) )
            StopEnumerate( )
          EndIf
          ;           
          ;           Post( #__event_Change, *this\parent, State )
          ;         Else
          ;           Post( #__event_Change, *this, State )
        EndIf
        
        ; scroll to active tab
        *this\_state | #__s_scrolled
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Tab_AddItem( *this._s_WIDGET, Item.i, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected result
      
      With *this
        ; 
        *this\bar\change_tab_items = #True
        
        If ( Item =- 1 Or Item > ListSize( \bar\_s( ) ) - 1 )
          LastElement( \bar\_s( ) )
          AddElement( \bar\_s( ) ) 
          Item = ListIndex( \bar\_s( ) )
        Else
          If SelectElement( \bar\_s( ), Item )
            If *this\index[#__tab_2] >= Item
              *this\index[#__tab_2] + 1
            EndIf
            
            If *this = *this\parent\_tab
              If StartEnumerate( *this\parent )
                If Widget( )\parent = *this\parent And 
                   Widget( )\tabindex = Item
                  Widget( )\tabindex + 1
                EndIf
                
                _set_hide_state_( Widget( ) )
                StopEnumerate( )
              EndIf
            EndIf
            
            InsertElement( \bar\_s( ) )
            
            PushListPosition( \bar\_s( ) )
            While NextElement( \bar\_s( ) )
              *this\bar\_s( )\index = ListIndex( *this\bar\_s( ) )
            Wend
            PopListPosition( \bar\_s( ) )
          EndIf
        EndIf
        
        ; tab last opened item 
        *this\bar\index = Item
        
        ;
        *this\bar\_s.allocate( TABS, ( ))
        *this\bar\_s( )\color = _get_colors_( )
        *this\bar\_s( )\height = *this\height - 1
        *this\bar\_s( )\text\string = Text.s
        *this\bar\_s( )\index = item
        
        If _is_child_integral_( *this ) 
          *this\parent\count\items + 1 
        EndIf
        *this\count\items + 1 
        
        _set_image_( *this, \bar\_s( )\Image, Image )
        _post_repaint_( *this\root )
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i Tab_removeItem( *this._s_WIDGET, Item.l )
      If SelectElement( *this\bar\_s( ), item )
        *this\bar\change_tab_items = #True
        
        If *this\index[#__tab_2] = *this\bar\_s( )\index
          *this\index[#__tab_2] = item - 1
        EndIf
        
        DeleteElement( *this\bar\_s( ), 1 )
        
        If *this\parent\_tab = *this
          Post( #__event_CloseItem, *this\parent, Item )
          *this\parent\count\items - 1
        Else
          Post( #__event_CloseItem, *this, Item )
        EndIf
        
        *this\count\items - 1
      EndIf
    EndProcedure
    
    Procedure   Tab_clearItems( *this._s_WIDGET ) ; Ok
      If *this\count\items <> 0
        
        *this\bar\change_tab_items = #True
        ClearList( *this\bar\_s( ) )
        
        If *this\parent\_tab = *this
          Post( #__event_CloseItem, *this\parent, #PB_All )
          *this\parent\count\items = 0
        Else
          Post( #__event_CloseItem, *this, #PB_All )
        EndIf
        
        *this\count\items = 0
      EndIf
    EndProcedure
    
    Procedure.s Tab_GetItemText( *this._s_WIDGET, Item.l, Column.l = 0 )
      Protected result.s
      
      If _is_item_( *this, Item ) And 
         SelectElement( *this\bar\_s( ), Item ) 
        result = *this\bar\_s( )\text\string
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Macro Tab_Draw_Item( _vertical_, _address_,_x_, _y_, _fore_color_, _back_color_, _frame_color_, _text_color_, _round_)
      ;Draw back
      DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
      _draw_gradient_box_( _vertical_,_x_ + _address_\x,_y_ + _address_\y, _address_\width, _address_\height, _fore_color_, _back_color_, _round_, _address_\color\_alpha )
      ; Draw frame
      DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
      RoundBox( _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _round_, _round_, _frame_color_&$FFFFFF | _address_\color\_alpha<<24 )
      ; Draw items image
      If _address_\image\id
        DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
        DrawAlphaImage( _address_\image\id, _x_ + _address_\image\x, _y_ + _address_\image\y, _address_\color\_alpha )
      EndIf
      ; Draw items text
      If _address_\text\string
        DrawingMode( #PB_2DDrawing_Transparent )
        DrawText( _x_ + _address_\text\x, _y_ + _address_\text\y, _address_\text\string, _text_color_&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    ; Farbaddition
    Procedure.i TabBarGadget_ColorPlus(Color.i, Plus.i) ; Code OK
      
      If Color&$FF + Plus&$FF < $FF
        Color + Plus&$FF
      Else
        Color | $FF
      EndIf
      If Color&$FF00 + Plus&$FF00 < $FF00
        Color + Plus&$FF00
      Else
        Color | $FF00
      EndIf
      If Color&$FF0000 + Plus&$FF0000 < $FF0000
        Color + Plus&$FF0000
      Else
        Color | $FF0000
      EndIf
      
      ProcedureReturn Color
      
    EndProcedure
    
    
    
    ; Farbsubtraktion
    Procedure.i TabBarGadget_ColorMinus(Color.i, Minus.i) ; Code OK
      
      If Color&$FF - Minus&$FF > 0
        Color - Minus&$FF
      Else
        Color & $FFFFFF00
      EndIf
      If Color&$FF00 - Minus&$FF00 > 0
        Color - Minus&$FF00
      Else
        Color & $FFFF00FF
      EndIf
      If Color&$FF0000 - Minus&$FF0000 > 0
        Color - Minus&$FF0000
      Else
        Color & $FF00FFFF
      EndIf
      
      ProcedureReturn Color
      
    EndProcedure
    
    Procedure.b _Tab_Draw( *this._s_WIDGET )
      With *this
        Protected Color
        Protected ActivColorPlus = $FF101010
        Protected HoverColorPlus = $FF101010
        Protected forecolor
        Protected backcolor
        Protected textcolor = $ff000000
        Protected framecolor = $FF808080;&$FFFFFF | \bar\_s( )\color\_alpha<<24
        Protected Item_Color_Background
        Protected widget_backcolor1 = $FFD0D0D0
        Protected widget_backcolor = $FFD0D0D0;$FFEEEEEE ; $FFE6E5E5;
        
        Protected typ = 0
        Protected layout = 4
        Protected pos = 2 + Bool(typ)*2
        Protected text_pos = 6
        
        If Not \hide And \color\_alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
            RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\Back&$FFFFFF | \color\_alpha<<24 )
          EndIf
          
          ;- widget::Tab_Update( )
          If *this\bar\change_tab_items
            If *this\vertical
              *this\text\y = text_pos
            Else
              *this\text\x = text_pos
            EndIf
            
            *this\bar\max = 0
            ; *this\text\width = *this\width
            
            ForEach \bar\_s( )
              _draw_font_item_( *this, *this\bar\_s( ), *this\bar\_s( )\change )
              
              If *this\vertical
                *this\bar\_s( )\y = *this\bar\max + layout/2
                
                If \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\x = 0
                  *this\bar\_s( )\width = *this\bar\button[#__b_3]\width + 1
                Else
                  *this\bar\_s( )\x = pos
                  *this\bar\_s( )\width = *this\bar\button[#__b_3]\width - 3
                EndIf
                
                *this\text\x = ( *this\bar\_s( )\width - *this\bar\_s( )\text\width )/2 - Bool(\index[#__tab_2] <> \bar\_s( )\index And typ)*2
                
                *this\bar\_s( )\text\y = *this\text\y + *this\bar\_s( )\y
                *this\bar\_s( )\text\x = *this\text\x + *this\bar\_s( )\x
                *this\bar\_s( )\height = *this\text\y*2 + *this\bar\_s( )\text\height
                
                *this\bar\max + *this\bar\_s( )\height + Bool( *this\bar\_s( )\index <> *this\count\items - 1 ) - Bool(typ)*2 +  Bool( *this\bar\_s( )\index = *this\count\items - 1 ) * layout 
                ;
                If typ And \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\height + 4
                  *this\bar\_s( )\y - 2
                EndIf
              Else
                *this\bar\_s( )\x = *this\bar\max + layout/2
                
                If \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\y = 0
                  *this\bar\_s( )\height = *this\bar\button[#__b_3]\height + 1
                Else
                  *this\bar\_s( )\y = pos
                  *this\bar\_s( )\height = *this\bar\button[#__b_3]\height - 3
                EndIf
                
                *this\text\y = ( *this\bar\_s( )\height - *this\bar\_s( )\text\height )/2 - Bool(\index[#__tab_2] <> \bar\_s( )\index And typ)*2
                
                *this\bar\_s( )\text\x = *this\text\x + *this\bar\_s( )\x
                *this\bar\_s( )\text\y = *this\text\y + *this\bar\_s( )\y
                *this\bar\_s( )\width = *this\text\x*2 + *this\bar\_s( )\text\width
                
                *this\bar\max + *this\bar\_s( )\width + Bool( *this\bar\_s( )\index <> *this\count\items - 1 ) - Bool(typ)*2 + Bool( *this\bar\_s( )\index = *this\count\items - 1 ) * layout 
                ;                                                                                                           
                If typ And \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\width + 4
                  *this\bar\_s( )\x - 2
                EndIf
              EndIf
              
              ; then set tab state
              If *this\bar\_s( )\index = \index[#__tab_2] 
                *this\bar\_s( )\_state | #__s_selected
                
                If _get_bar_active_item_( *this ) <> *this\bar\_s( ) 
                  If _get_bar_active_item_( *this )
                    _get_bar_active_item_( *this )\_state &~ #__s_selected
                  EndIf
                  
                  _get_bar_active_item_( *this ) = *this\bar\_s( )
                  
                  If *this\_state & #__s_scrolled
                    *this\_state &~ #__s_scrolled
                    _get_bar_active_item_( *this )\_state | #__s_scrolled
                  EndIf
                EndIf
              EndIf
            Next
            
            Bar_Update( *this )
            If _get_bar_active_item_( *this ) And 
               _get_bar_active_item_( *this )\_state & #__s_scrolled
              _get_bar_active_item_( *this )\_state &~ #__s_scrolled
              Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
              
              Protected ThumbPos = *this\bar\max - ( _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ) - 3 ; to right
              ThumbPos = *this\bar\max - ( _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ) - ( *this\bar\thumb\end - _get_bar_active_item_( *this )\width ) / 2 - 3   ; to center
              Protected ScrollPos = _bar_page_pos_( *this\bar, ThumbPos )
              ScrollPos = _bar_invert_page_pos_( *this\bar, ScrollPos )
              *this\bar\page\pos = ScrollPos
            EndIf
            Bar_Resize( *this )
            *this\bar\change_tab_items = #False
          EndIf
          
          
          If *this\vertical 
            *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2            
            *this\bar\button[#__b_1]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2              
          Else 
            *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2           
            *this\bar\button[#__b_1]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2            
          EndIf
          
          
          Protected State_3, Color_frame
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          
          
          
          
          ; draw all visible items
          ForEach \bar\_s( )
            _draw_font_item_( *this, *this\bar\_s( ), 0 )
            
            If *this\vertical
              *this\bar\_s( )\draw = Bool( Not *this\bar\_s( )\hide And 
                                           ( ( y + *this\bar\_s( )\y + *this\bar\_s( )\height ) > *this\y[#__c_inner]  And 
                                             ( y + *this\bar\_s( )\y ) < ( *this\y[#__c_inner] + *this\height[#__c_inner] ) ) )
            Else
              *this\bar\_s( )\draw = Bool( Not *this\bar\_s( )\hide And 
                                           ( ( x + *this\bar\_s( )\x + *this\bar\_s( )\width ) > *this\x[#__c_inner]  And 
                                             ( x + *this\bar\_s( )\x ) < ( *this\x[#__c_inner] + *this\width[#__c_inner] ) ) )
            EndIf
            
            ; draw all default items
            If \bar\_s( )\draw And 
               \bar\_s( ) <> _get_bar_enter_item_( *this ) And 
               \bar\_s( ) <> _get_bar_active_item_( *this )
              
              Tab_Draw_Item( *this\vertical, *this\bar\_s( ), x, y, 
                             *this\bar\_s( )\color\fore[0],
                             *this\bar\_s( )\color\Back[0],
                             *this\bar\_s( )\color\frame[0], 
                             *this\bar\_s( )\color\front[0],
                             *this\bar\button[#__b_3]\round )
            EndIf
          Next
          
          ; draw mouse-enter visible item
          If _get_bar_enter_item_( *this ) And 
             _get_bar_enter_item_( *this )\draw And 
             _get_bar_enter_item_( *this ) <> _get_bar_active_item_( *this )
            
            _draw_font_item_( *this, _get_bar_enter_item_( *this ), 0 )
            Tab_Draw_Item( *this\vertical, _get_bar_enter_item_( *this ), x, y, 
                           _get_bar_enter_item_( *this )\color\fore[1],
                           _get_bar_enter_item_( *this )\color\Back[1],
                           _get_bar_enter_item_( *this )\color\frame[1], 
                           _get_bar_enter_item_( *this )\color\front[1],
                           *this\bar\button[#__b_3]\round )
          EndIf
          
          ; draw key-focus visible item
          If _get_bar_active_item_( *this ) And 
             _get_bar_active_item_( *this )\draw
            
            _draw_font_item_( *this, _get_bar_active_item_( *this ), 0 )
            Tab_Draw_Item( *this\vertical, _get_bar_active_item_( *this ), x, y, 
                           _get_bar_active_item_( *this )\color\fore[2],
                           _get_bar_active_item_( *this )\color\Back[2],
                           _get_bar_active_item_( *this )\color\frame[1 + Bool( *this\index[#__tab_2] <> _get_bar_active_item_( *this )\index And *this\index[#__tab_1] = _get_bar_active_item_( *this )\index And *this\bar\button[#__b_3]\_state & #__s_selected )], 
                           _get_bar_active_item_( *this )\color\front[2],
                           *this\bar\button[#__b_3]\round )
          EndIf
          
          
          
          
          color = $FF909090
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          
          ; draw lines
          If _get_bar_active_item_( *this ) And 
             _get_bar_active_item_( *this )\draw
            
            color = _get_bar_active_item_( *this )\color\frame[2]
            If *this\vertical
              ; frame on the selected item
              Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y, 1, _get_bar_active_item_( *this )\height, color )
              Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y, _get_bar_active_item_( *this )\width, 1, color )
              Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height -1, _get_bar_active_item_( *this )\width, 1, color )
            Else
              ; frame on the selected item
              Line( x + _get_bar_active_item_( *this )\x , y + _get_bar_active_item_( *this )\y, _get_bar_active_item_( *this )\width, 1, color )
              Line( x + _get_bar_active_item_( *this )\x , y + _get_bar_active_item_( *this )\y, 1, *this\bar\button[#__b_3]\height+1, color )
              Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width -1, y + _get_bar_active_item_( *this )\y, 1, *this\bar\button[#__b_3]\height+1, color )
              
            EndIf
          EndIf
          
          
          If *this\vertical
            color = *this\color\frame[0]
            ; vertical tab right line 
            If _get_bar_active_item_( *this )
              Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, *this\y[#__c_screen], 1, ( y + _get_bar_active_item_( *this )\y ) - *this\x[#__c_frame], color ) ;*this\bar\_s( )\color\fore[2] )
              Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height, 1, *this\y[#__c_frame] + *this\height[#__c_frame] - ( y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height ), color ) ; *this\bar\_s( )\color\fore[2] )
            Else
              Line( *this\x[#__c_screen]+*this\width[#__c_screen]-1, *this\y[#__c_screen], 1, *this\height[#__c_screen], color )
            EndIf
            
            If _is_child_integral_( *this ) 
              color = *this\parent\color\back[0]
              ; selected tab inner frame
              Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, 1, _get_bar_active_item_( *this )\height-2, color )
              Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, *this\bar\button[#__b_3]\width, 1, color )
              Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height -2, *this\bar\button[#__b_3]\width, 1, color )
              
              Protected size1 = 5
              ;               
              ;Arrow( *this\x[#__c_screen] + selected_tab_pos + ( _get_bar_active_item_( *this )\width - size1 )/2, *this\y[#__c_frame]+*this\height[#__c_frame] - 5, 11, $ff000000, 1, 1)
              
              Arrow( x + _get_bar_active_item_( *this )\x + ( _get_bar_active_item_( *this )\width - size1 ),
                     y + _get_bar_active_item_( *this )\y + ( _get_bar_active_item_( *this )\height - size1 )/2, size1, 0, color, -1 )
              
              
              
              color = *this\parent\color\frame[0]
              Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] - 1, *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner], *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              Line( *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner], *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
            EndIf
          Else
            color = *this\color\frame[0]
            ; horizontal tab bottom line 
            If _get_bar_active_item_( *this )
              Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, ( x + _get_bar_active_item_( *this )\x ) - *this\x[#__c_frame], 1, color ) ;*this\bar\_s( )\color\fore[2] )
              Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width, *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\x[#__c_frame] + *this\width[#__c_frame] - ( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ), 1, color ) ; *this\bar\_s( )\color\fore[2] )
            Else
              Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\width[#__c_screen], 1, color )
            EndIf
            
            If _is_child_integral_( *this ) 
              color = *this\parent\color\back[0]
              ; selected tab inner frame
              Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, _get_bar_active_item_( *this )\width-2, 1, color )
              Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, 1, *this\bar\button[#__b_3]\height, color )
              Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width - 2, y + _get_bar_active_item_( *this )\y +1, 1, *this\bar\button[#__b_3]\height, color )
              
              color = *this\parent\color\frame[0]
              Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              Line( *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner], *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner], *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              
            EndIf
          EndIf
          
          ; Navigation
          Protected fabe_pos, fabe_out, button_size = 20, round=0, Size = 60
          backcolor = \parent\parent\color\back[\parent\parent\color\state]
          If Not backcolor
            backcolor = \parent\color\back[\parent\color\state]
          EndIf
          If Not backcolor
            backcolor = \bar\button[#__b_2]\color\back[\color\state]
          EndIf
          
          
          DrawingMode( #PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Gradient )
          ResetGradientColors( )
          GradientColor( 0.0, backcolor&$FFFFFF )
          GradientColor( 0.5, backcolor&$FFFFFF | $A0<<24 )
          GradientColor( 1.0, backcolor&$FFFFFF | 245<<24 )
          
          fabe_out = Size - button_size
          
          If *this\vertical
            ;             ; to top
            If Not \bar\button[#__b_2]\hide 
              fabe_pos = \y + ( size ) - \fs
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos - fabe_out )
              RoundBox( \x + \bs, fabe_pos, \width - \bs-1,  - Size, round,round )
            EndIf
            
            ;             ; to bottom
            If Not \bar\button[#__b_1]\hide 
              fabe_pos = \y + \height - ( size ) + \fs*2
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos + fabe_out )
              RoundBox( \x + \bs, fabe_pos, \width - \bs-1 ,Size, round,round )
            EndIf
          Else
            ;             ; to left
            If Not \bar\button[#__b_2]\hide
              fabe_pos = \x + ( size ) - \fs
              LinearGradient( fabe_pos, \y + \bs, fabe_pos - fabe_out, \y + \bs )
              RoundBox( fabe_pos, \y + \bs,  - Size, \height - \bs-1, round,round )
            EndIf
            
            ;             ; to right
            If Not \bar\button[#__b_1]\hide
              fabe_pos = \x + \width - ( size ) + \fs*2
              LinearGradient( fabe_pos, \y + \bs, fabe_pos + fabe_out, \y + \bs )
              RoundBox( fabe_pos, \y + \bs, Size, \height - \bs-1 ,round,round )
            EndIf
          EndIf
          
          ResetGradientColors( )
          
          
          
          ; draw navigator
          If Not \bar\button[#__b_2]\hide
            ;             Color = $FF202020
            ;             ; Color = $FF101010
            ;             Item_Color_Background = TabBarGadget_ColorMinus(widget_backcolor1, Color)
            ;             ;Item_Color_Background = TabBarGadget_ColorPlus(widget_backcolor1, Color)
            ;             forecolor = TabBarGadget_ColorPlus(Item_Color_Background, Color)
            ;             ;backcolor = TabBarGadget_ColorMinus(Item_Color_Background, Color)
            ;             
            ;             If \bar\button[#__b_1]\color\state = 3
            ;               Color = $FF303030
            ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ;              \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ;              \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ; ;               
            ;             ElseIf \bar\button[#__b_1]\color\state = 1
            ; ;                Color = $FF303030
            ; ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ; ;              framecolor = TabBarGadget_ColorMinus(framecolor, Color)
            ; ;              \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ; ;              \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ;              
            ;                \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state];backcolor
            ;               \bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;             \bar\button[#__b_1]\arrow\size = 6               
            ;                
            ;             ElseIf \bar\button[#__b_1]\color\state = 0
            ;               \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = backcolor
            ;               \bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;               \bar\button[#__b_1]\arrow\size = 4               
            ;             EndIf
            
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical,\bar\button[#__b_2], \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              RoundBox( \bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | \bar\button[#__b_2]\color\_alpha<<24 )
            EndIf
          EndIf
          
          If Not \bar\button[#__b_1]\hide 
            ; Draw buttons
            If \bar\button[#__b_1]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical, \bar\button[#__b_1], \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              RoundBox( \bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | \bar\button[#__b_1]\color\_alpha<<24 )
            EndIf
          EndIf
          
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          
          ; Draw buttons frame
          If Not \bar\button[#__b_1]\hide 
            RoundBox( \bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | \bar\button[#__b_1]\color\_alpha<<24 )
            
            ; Draw arrows
            If Not \bar\button[#__b_1]\hide And \bar\button[#__b_1]\arrow\size
              _draw_arrows_( *this\bar\button[#__b_1], Bool( \vertical ) + 2 ) 
            EndIf
          EndIf
          If Not \bar\button[#__b_2]\hide 
            RoundBox( \bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | \bar\button[#__b_2]\color\_alpha<<24 )
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              _draw_arrows_( *this\bar\button[#__b_2], Bool( \vertical ) ) 
            EndIf
          EndIf
          
          
        EndIf
        
        
        
        CompilerIf #PB_Compiler_IsMainFile
          ; _Tab_Draw( *this )
        CompilerEndIf
      EndWith 
    EndProcedure
    
    Procedure.b Tab_Draw( *this._s_WIDGET )
      With *this
        Protected Color
        Protected ActivColorPlus = $FF101010
        Protected HoverColorPlus = $FF101010
        Protected forecolor
        Protected backcolor
        Protected textcolor = $ff000000
        Protected framecolor = $FF808080;&$FFFFFF | \bar\_s( )\color\_alpha<<24
        Protected Item_Color_Background
        Protected widget_backcolor1 = $FFD0D0D0
        Protected widget_backcolor = $FFD0D0D0;$FFEEEEEE ; $FFE6E5E5;
        
        Protected typ = 0
        Protected pos = 1
        If *this\parent And *this\parent\type = #PB_GadgetType_Panel
          pos = 2
        EndIf
        
        pos + Bool(typ)*2
        
        Protected layout = pos*2
        Protected text_pos = 6
        
        If Not \hide And \color\_alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
            RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\Back&$FFFFFF | \color\_alpha<<24 )
          EndIf
          
          ;- widget::Tab_Update( )
          If *this\bar\change_tab_items
            *this\image\x = ( *this\height - 16 - pos - 1 ) / 2
            Debug " --- "+*this\image\x
            
            If *this\vertical
              *this\text\y = text_pos
            Else
              *this\text\x = text_pos
            EndIf
            
            *this\bar\max = 0
            ; *this\text\width = *this\width
            
            ForEach \bar\_s( )
              _draw_font_item_( *this, *this\bar\_s( ), *this\bar\_s( )\change )
              
              If *this\vertical
                *this\bar\_s( )\y = *this\bar\max + pos 
                
                If \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\x = 0
                  *this\bar\_s( )\width = *this\bar\button[#__b_3]\width + 1
                Else
                  *this\bar\_s( )\x = pos
                  *this\bar\_s( )\width = *this\bar\button[#__b_3]\width - 3
                EndIf
                
                *this\text\x = ( *this\bar\_s( )\width - *this\bar\_s( )\text\width )/2 - Bool(\index[#__tab_2] <> \bar\_s( )\index And typ)*2
                
                *this\bar\_s( )\text\y = *this\text\y + *this\bar\_s( )\y
                *this\bar\_s( )\text\x = *this\text\x + *this\bar\_s( )\x
                *this\bar\_s( )\height = *this\text\y*2 + *this\bar\_s( )\text\height
                
                *this\bar\max + *this\bar\_s( )\height + Bool( *this\bar\_s( )\index <> *this\count\items - 1 ) - Bool(typ)*2 +  Bool( *this\bar\_s( )\index = *this\count\items - 1 ) * layout 
                ;
                If typ And \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\height + 4
                  *this\bar\_s( )\y - 2
                EndIf
              Else
                *this\bar\_s( )\x = *this\bar\max + pos
                
                If \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\y =  pos - Bool( pos>0 )*2
                  *this\bar\_s( )\height = *this\bar\button[#__b_3]\height - *this\bar\_s( )\y + 1
                Else
                  *this\bar\_s( )\y = pos
                  *this\bar\_s( )\height = *this\bar\button[#__b_3]\height - *this\bar\_s( )\y - 1
                EndIf
                
                *this\text\y = ( *this\bar\_s( )\height - *this\bar\_s( )\text\height )/2 - Bool(\index[#__tab_2] <> \bar\_s( )\index And typ)*2
                ;
                *this\bar\_s( )\image\y = *this\bar\_s( )\y + ( *this\bar\_s( )\height - *this\bar\_s( )\image\height )/2 
                *this\bar\_s( )\text\y = *this\bar\_s( )\y + *this\text\y
                
                ;
                *this\bar\_s( )\image\x = *this\bar\_s( )\x + Bool( *this\bar\_s( )\image\width ) * *this\image\x ;+ Bool( *this\bar\_s( )\text\width ) * ( *this\text\x ) 
                *this\bar\_s( )\text\x = *this\bar\_s( )\image\x + *this\bar\_s( )\image\width + *this\text\x
                *this\bar\_s( )\width = Bool( *this\bar\_s( )\text\width ) * ( *this\text\x*2 ) + *this\bar\_s( )\text\width +
                                        Bool( *this\bar\_s( )\image\width ) * ( *this\image\x*2 ) + *this\bar\_s( )\image\width - ( Bool( *this\bar\_s( )\image\width And *this\bar\_s( )\text\width ) * ( *this\text\x ) )
                
                *this\bar\max + *this\bar\_s( )\width + Bool( *this\bar\_s( )\index <> *this\count\items - 1 ) - Bool(typ)*2 + Bool( *this\bar\_s( )\index = *this\count\items - 1 ) * layout 
                ;                                                                                                           
                If typ And \index[#__tab_2] = \bar\_s( )\index
                  *this\bar\_s( )\width + 4
                  *this\bar\_s( )\x - 2
                EndIf
              EndIf
              
              ; then set tab state
              If *this\bar\_s( )\index = \index[#__tab_2] 
                *this\bar\_s( )\_state | #__s_selected
                
                If _get_bar_active_item_( *this ) <> *this\bar\_s( ) 
                  If _get_bar_active_item_( *this )
                    _get_bar_active_item_( *this )\_state &~ #__s_selected
                  EndIf
                  
                  _get_bar_active_item_( *this ) = *this\bar\_s( )
                  
                  If *this\_state & #__s_scrolled
                    *this\_state &~ #__s_scrolled
                    _get_bar_active_item_( *this )\_state | #__s_scrolled
                  EndIf
                EndIf
              EndIf
            Next
            
            Bar_Update( *this )
            If _get_bar_active_item_( *this ) And 
               _get_bar_active_item_( *this )\_state & #__s_scrolled
              _get_bar_active_item_( *this )\_state &~ #__s_scrolled
              Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
              
              Protected ThumbPos = *this\bar\max - ( _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ) - 3 ; to right
              ThumbPos = *this\bar\max - ( _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ) - ( *this\bar\thumb\end - _get_bar_active_item_( *this )\width ) / 2 - 3   ; to center
              Protected ScrollPos = _bar_page_pos_( *this\bar, ThumbPos )
              ScrollPos = _bar_invert_page_pos_( *this\bar, ScrollPos )
              *this\bar\page\pos = ScrollPos
            EndIf
            Bar_Resize( *this )
            *this\bar\change_tab_items = #False
          EndIf
          
          
          If *this\vertical 
            *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2            
            *this\bar\button[#__b_1]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2              
          Else 
            *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2           
            *this\bar\button[#__b_1]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2            
          EndIf
          
          
          Protected State_3, Color_frame
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          
          
          
          
          ; draw all visible items
          ForEach \bar\_s( )
            _draw_font_item_( *this, *this\bar\_s( ), 0 )
            
            If *this\vertical
              *this\bar\_s( )\draw = Bool( Not *this\bar\_s( )\hide And 
                                           ( ( y + *this\bar\_s( )\y + *this\bar\_s( )\height ) > *this\y[#__c_inner]  And 
                                             ( y + *this\bar\_s( )\y ) < ( *this\y[#__c_inner] + *this\height[#__c_inner] ) ) )
            Else
              *this\bar\_s( )\draw = Bool( Not *this\bar\_s( )\hide And 
                                           ( ( x + *this\bar\_s( )\x + *this\bar\_s( )\width ) > *this\x[#__c_inner]  And 
                                             ( x + *this\bar\_s( )\x ) < ( *this\x[#__c_inner] + *this\width[#__c_inner] ) ) )
            EndIf
            
            ; draw all default items
            If \bar\_s( )\draw And 
               \bar\_s( ) <> _get_bar_enter_item_( *this ) And 
               \bar\_s( ) <> _get_bar_active_item_( *this )
              
              Tab_Draw_Item( *this\vertical, *this\bar\_s( ), x, y, 
                             *this\bar\_s( )\color\fore[0],
                             *this\bar\_s( )\color\Back[0],
                             *this\bar\_s( )\color\frame[0], 
                             *this\bar\_s( )\color\front[0],
                             *this\bar\button[#__b_3]\round )
            EndIf
          Next
          
          ; draw mouse-enter visible item
          If _get_bar_enter_item_( *this ) And 
             _get_bar_enter_item_( *this )\draw And 
             _get_bar_enter_item_( *this ) <> _get_bar_active_item_( *this )
            
            _draw_font_item_( *this, _get_bar_enter_item_( *this ), 0 )
            Tab_Draw_Item( *this\vertical, _get_bar_enter_item_( *this ), x, y, 
                           _get_bar_enter_item_( *this )\color\fore[1],
                           _get_bar_enter_item_( *this )\color\Back[1],
                           _get_bar_enter_item_( *this )\color\frame[1], 
                           _get_bar_enter_item_( *this )\color\front[1],
                           *this\bar\button[#__b_3]\round )
          EndIf
          
          ; draw key-focus visible item
          If _get_bar_active_item_( *this ) And 
             _get_bar_active_item_( *this )\draw
            
            _draw_font_item_( *this, _get_bar_active_item_( *this ), 0 )
            Tab_Draw_Item( *this\vertical, _get_bar_active_item_( *this ), x, y, 
                           _get_bar_active_item_( *this )\color\fore[2],
                           _get_bar_active_item_( *this )\color\Back[2],
                           _get_bar_active_item_( *this )\color\frame[1 + Bool( *this\index[#__tab_2] <> _get_bar_active_item_( *this )\index And *this\index[#__tab_1] = _get_bar_active_item_( *this )\index And *this\bar\button[#__b_3]\_state & #__s_selected )], 
                           _get_bar_active_item_( *this )\color\front[2],
                           *this\bar\button[#__b_3]\round )
          EndIf
          
          
          
          
          color = $FF909090
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          
          ; draw lines
          If _get_bar_active_item_( *this )  
            If *this\vertical
              color = _get_bar_active_item_( *this )\color\frame[2]
              ; frame on the selected item
              If _get_bar_active_item_( *this )\draw
                Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y, 1, _get_bar_active_item_( *this )\height, color )
                Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y, _get_bar_active_item_( *this )\width, 1, color )
                Line( x + _get_bar_active_item_( *this )\x, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height -1, _get_bar_active_item_( *this )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              ; vertical tab right line 
              If _get_bar_active_item_( *this )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, *this\y[#__c_screen], 1, ( y + _get_bar_active_item_( *this )\y ) - *this\x[#__c_frame], color ) ;*this\bar\_s( )\color\fore[2] )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height, 1, *this\y[#__c_frame] + *this\height[#__c_frame] - ( y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height ), color ) ; *this\bar\_s( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen]+*this\width[#__c_screen]-1, *this\y[#__c_screen], 1, *this\height[#__c_screen], color )
              EndIf
              
              If _is_child_integral_( *this ) 
                color = *this\parent\color\back[0]
                ; selected tab inner frame
                Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, 1, _get_bar_active_item_( *this )\height-2, color )
                Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, *this\bar\button[#__b_3]\width, 1, color )
                Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y + _get_bar_active_item_( *this )\height -2, *this\bar\button[#__b_3]\width, 1, color )
                
                Protected size1 = 5
                ;               
                ;Arrow( *this\x[#__c_screen] + selected_tab_pos + ( _get_bar_active_item_( *this )\width - size1 )/2, *this\y[#__c_frame]+*this\height[#__c_frame] - 5, 11, $ff000000, 1, 1)
                
                Arrow( x + _get_bar_active_item_( *this )\x + ( _get_bar_active_item_( *this )\width - size1 ),
                       y + _get_bar_active_item_( *this )\y + ( _get_bar_active_item_( *this )\height - size1 )/2, size1, 0, color, -1 )
                
                
                
                color = *this\parent\color\frame[0]
                Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] - 1, *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
                Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner], *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
                Line( *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner], *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
              EndIf
            Else
              color = _get_bar_active_item_( *this )\color\frame[2]
              ; frame on the selected item
              If _get_bar_active_item_( *this )\draw
                Line( x + _get_bar_active_item_( *this )\x , y + _get_bar_active_item_( *this )\y, _get_bar_active_item_( *this )\width, 1, color )
                Line( x + _get_bar_active_item_( *this )\x , y + _get_bar_active_item_( *this )\y, 1, *this\bar\button[#__b_3]\height-_get_bar_active_item_( *this )\y+1, color )
                Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width -1, y + _get_bar_active_item_( *this )\y, 1, *this\bar\button[#__b_3]\height-_get_bar_active_item_( *this )\y+1, color )
              EndIf
              
              color = *this\color\frame[0]
              ; horizontal tab bottom line 
              If _get_bar_active_item_( *this )
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, ( x + _get_bar_active_item_( *this )\x ) - *this\x[#__c_frame], 1, color ) ;*this\bar\_s( )\color\fore[2] )
                Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width, *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\x[#__c_frame] + *this\width[#__c_frame] - ( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width ), 1, color ) ; *this\bar\_s( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\width[#__c_screen], 1, color )
              EndIf
              
              If _is_child_integral_( *this ) 
                color = *this\parent\color\back[0]
                ; selected tab inner frame
                Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, _get_bar_active_item_( *this )\width-2, 1, color )
                Line( x + _get_bar_active_item_( *this )\x +1, y + _get_bar_active_item_( *this )\y +1, 1, *this\bar\button[#__b_3]\height, color )
                Line( x + _get_bar_active_item_( *this )\x + _get_bar_active_item_( *this )\width - 2, y + _get_bar_active_item_( *this )\y +1, 1, *this\bar\button[#__b_3]\height, color )
                
                color = *this\parent\color\frame[0]
                Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
                Line( *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner], *this\parent\y[#__c_inner] - 1, 1, *this\parent\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
                Line( *this\parent\x[#__c_inner] - 1, *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner], *this\parent\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\_tab\index[#__tab_2]  <>-1 )*2 ] )
                
              EndIf
            EndIf
          EndIf
          
          ; Navigation
          Protected fabe_pos, fabe_out, button_size = 20, round=0, Size = 60
          backcolor = \parent\parent\color\back[\parent\parent\color\state]
          If Not backcolor
            backcolor = \parent\color\back[\parent\color\state]
          EndIf
          If Not backcolor
            backcolor = \bar\button[#__b_2]\color\back[\color\state]
          EndIf
          
          
          DrawingMode( #PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Gradient )
          ResetGradientColors( )
          GradientColor( 0.0, backcolor&$FFFFFF )
          GradientColor( 0.5, backcolor&$FFFFFF | $A0<<24 )
          GradientColor( 1.0, backcolor&$FFFFFF | 245<<24 )
          
          fabe_out = Size - button_size
          
          If *this\vertical
            ;             ; to top
            If Not \bar\button[#__b_2]\hide 
              fabe_pos = \y + ( size ) - \fs
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos - fabe_out )
              RoundBox( \x + \bs, fabe_pos, \width - \bs-1,  - Size, round,round )
            EndIf
            
            ;             ; to bottom
            If Not \bar\button[#__b_1]\hide 
              fabe_pos = \y + \height - ( size ) + \fs*2
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos + fabe_out )
              RoundBox( \x + \bs, fabe_pos, \width - \bs-1 ,Size, round,round )
            EndIf
          Else
            ;             ; to left
            If Not \bar\button[#__b_2]\hide
              fabe_pos = \x + ( size ) - \fs
              LinearGradient( fabe_pos, \y + \bs, fabe_pos - fabe_out, \y + \bs )
              RoundBox( fabe_pos, \y + \bs,  - Size, \height - \bs-1, round,round )
            EndIf
            
            ;             ; to right
            If Not \bar\button[#__b_1]\hide
              fabe_pos = \x + \width - ( size ) + \fs*2
              LinearGradient( fabe_pos, \y + \bs, fabe_pos + fabe_out, \y + \bs )
              RoundBox( fabe_pos, \y + \bs, Size, \height - \bs-1 ,round,round )
            EndIf
          EndIf
          
          ResetGradientColors( )
          
          
          
          ; draw navigator
          ; Draw buttons back
          If Not \bar\button[#__b_2]\hide
            ;             Color = $FF202020
            ;             ; Color = $FF101010
            ;             Item_Color_Background = TabBarGadget_ColorMinus(widget_backcolor1, Color)
            ;             ;Item_Color_Background = TabBarGadget_ColorPlus(widget_backcolor1, Color)
            ;             forecolor = TabBarGadget_ColorPlus(Item_Color_Background, Color)
            ;             ;backcolor = TabBarGadget_ColorMinus(Item_Color_Background, Color)
            ;             
            ;             If \bar\button[#__b_1]\color\state = 3
            ;               Color = $FF303030
            ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ;              \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ;              \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ; ;               
            ;             ElseIf \bar\button[#__b_1]\color\state = 1
            ; ;                Color = $FF303030
            ; ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ; ;              framecolor = TabBarGadget_ColorMinus(framecolor, Color)
            ; ;              \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ; ;              \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ;              
            ;                \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state];backcolor
            ;               \bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;             \bar\button[#__b_1]\arrow\size = 6               
            ;                
            ;             ElseIf \bar\button[#__b_1]\color\state = 0
            ;               \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = backcolor
            ;               \bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;               \bar\button[#__b_1]\arrow\size = 4               
            ;             EndIf
            
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical,\bar\button[#__b_2], \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              RoundBox( \bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | \bar\button[#__b_2]\color\_alpha<<24 )
            EndIf
          EndIf
          If Not \bar\button[#__b_1]\hide 
            ; Draw buttons
            If \bar\button[#__b_1]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical, \bar\button[#__b_1], \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              RoundBox( \bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | \bar\button[#__b_1]\color\_alpha<<24 )
            EndIf
          EndIf
          
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          
          ; Draw buttons frame
          If Not \bar\button[#__b_1]\hide 
            RoundBox( \bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | \bar\button[#__b_1]\color\_alpha<<24 )
            
            ; Draw arrows
            If Not \bar\button[#__b_1]\hide And \bar\button[#__b_1]\arrow\size
              _draw_arrows_( *this\bar\button[#__b_1], Bool( \vertical ) + 2 ) 
            EndIf
          EndIf
          If Not \bar\button[#__b_2]\hide 
            RoundBox( \bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | \bar\button[#__b_2]\color\_alpha<<24 )
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              _draw_arrows_( *this\bar\button[#__b_2], Bool( \vertical ) ) 
            EndIf
          EndIf
          
          
        EndIf
        
        
        
        CompilerIf #PB_Compiler_IsMainFile
          ; _Tab_Draw( *this )
        CompilerEndIf
      EndWith 
    EndProcedure
    
    ;- 
    Procedure.b Scroll_Draw( *this._s_WIDGET )
      With *this
        
        ;         DrawImage( ImageID( UpImage ),\bar\button[#__b_1]\x,\bar\button[#__b_1]\y )
        ;         DrawImage( ImageID( DownImage ),\bar\button[#__b_2]\x,\bar\button[#__b_2]\y )
        ;         ProcedureReturn 
        
        If \color\_alpha
          ; Draw scroll bar background
          If \color\back <>- 1
            DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
            _draw_box_(*this, color\back, [#__c_frame])
          EndIf
          
          If \type = #__type_ScrollBar
            If \vertical
              If ( \bar\page\len + Bool( \round )*( \width/4 ) ) = \height[#__c_frame]
                Line( \x[#__c_frame], \y[#__c_frame], 1, \bar\page\len + 1, \color\front&$FFFFFF | \color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line( \x[#__c_frame], \y[#__c_frame], 1, \height, \color\front&$FFFFFF | \color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            Else
              If ( \bar\page\len + Bool( \round )*( \height/4 ) ) = \width[#__c_frame]
                Line( \x[#__c_frame], \y[#__c_frame], \bar\page\len + 1, 1, \color\front&$FFFFFF | \color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line( \x[#__c_frame], \y[#__c_frame], \width[#__c_frame], 1, \color\front&$FFFFFF | \color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            EndIf
          EndIf
          
          If Not \bar\button[#__b_1]\hide
            ; background buttons draw
            If \bar\button[#__b_1]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical,\bar\button[#__b_1], \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              _draw_box_(\bar\button[#__b_1], color\back)
            EndIf
            
            ; arrows buttons draw 
            If \bar\button[#__b_1]\arrow\size
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              ;               Arrow( \bar\button[#__b_1]\x + ( \bar\button[#__b_1]\width - \bar\button[#__b_1]\arrow\size )/2,\bar\button[#__b_1]\y + ( \bar\button[#__b_1]\height - \bar\button[#__b_1]\arrow\size )/2, 
              ;                      \bar\button[#__b_1]\arrow\size, Bool( \vertical ), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF | \bar\button[#__b_1]\color\_alpha<<24, \bar\button[#__b_1]\arrow\type )
              
              _draw_arrows_( *this\bar\button[#__b_1], Bool( \vertical ) ) 
            EndIf
            
            ; frame buttons draw
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            _draw_box_(\bar\button[#__b_1], color\frame)
          EndIf
          
          If Not \bar\button[#__b_2]\hide
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical,\bar\button[#__b_2], \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              _draw_box_(\bar\button[#__b_2], color\back)
            EndIf
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              ;               Arrow( \bar\button[#__b_2]\x + ( \bar\button[#__b_2]\width - \bar\button[#__b_2]\arrow\size )/2,\bar\button[#__b_2]\y + ( \bar\button[#__b_2]\height - \bar\button[#__b_2]\arrow\size )/2, 
              ;                      \bar\button[#__b_2]\arrow\size, Bool( \vertical ) + 2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF | \bar\button[#__b_2]\color\_alpha<<24, \bar\button[#__b_2]\arrow\type )
              
              _draw_arrows_( *this\bar\button[#__b_2], Bool( \vertical ) + 2 ) 
            EndIf
            
            ; Draw buttons frame
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            _draw_box_(\bar\button[#__b_2], color\frame)
          EndIf
          
          If \bar\thumb\len And \type <> #__type_ProgressBar
            ; Draw thumb
            DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
            _draw_gradient_( \vertical,\bar\button[#__b_3], \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state])
            
            If \bar\button[#__b_3]\arrow\type ; \type = #__type_ScrollBar
              If \bar\button[#__b_3]\arrow\size
                DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                ;                 Arrow( \bar\button[#__b_3]\x + ( \bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y + ( \bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size )/2, 
                ;                        \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \bar\button[#__b_3]\color\_alpha<<24, \bar\button[#__b_3]\arrow\type )
                
                _draw_arrows_( *this\bar\button[#__b_3], \bar\button[#__b_3]\arrow\direction ) 
              EndIf
            Else
              ; Draw thumb lines
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              If \vertical
                Line( \bar\button[#__b_3]\x + ( \bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 - 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
                Line( \bar\button[#__b_3]\x + ( \bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
                Line( \bar\button[#__b_3]\x + ( \bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 + 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
              Else
                Line( \bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 - 3,\bar\button[#__b_3]\y + ( \bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
                Line( \bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y + ( \bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
                Line( \bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 + 3,\bar\button[#__b_3]\y + ( \bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF | \color\_alpha<<24 )
              EndIf
            EndIf
            
            ; Draw thumb frame
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            _draw_box_(\bar\button[#__b_3], color\frame)
          EndIf
          
        EndIf
      EndWith 
    EndProcedure
    
    Procedure.b Progress_Draw( *this._s_WIDGET )
      With *this
        Protected i,a, _position_, _frame_size_ = 1, _gradient_ = 1
        Protected _vertical_ = *this\vertical
        Protected _reverse_ = *this\bar\inverted
        Protected _round_ = *this\bar\button[#__b_1]\round
        Protected alpha = 230
        Protected _frame_color_ = $000000 ; *this\bar\button[#__b_1]\color\frame[0]
        Protected _fore_color1_
        Protected _back_color1_
        Protected _fore_color2_ 
        Protected _back_color2_
        
        alpha = 230
        _fore_color1_ = *this\bar\button[#__b_1]\color\fore[2]&$FFFFFF | alpha<<24 ; $f0E9BA81 ; 
        _back_color1_ = *this\bar\button[#__b_1]\color\back[2]&$FFFFFF | alpha<<24 ; $f0E89C3D ; 
        alpha - 15
        _fore_color2_ = *this\bar\button[#__b_1]\color\fore[0]&$FFFFFF | alpha<<24 ; $e0F8F8F8 ; 
        _back_color2_ = *this\bar\button[#__b_1]\color\back[0]&$FFFFFF | alpha<<24 ; $e0E2E2E2 ; 
        
        If _vertical_
          If _reverse_
            _position_ = *this\bar\thumb\pos
          Else
            _position_ = *this\height[#__c_frame] - *this\bar\thumb\pos
          EndIf
        Else
          If _reverse_
            _position_ = *this\width[#__c_frame] - *this\bar\thumb\pos
          Else
            _position_ = *this\bar\thumb\pos
          EndIf
        EndIf
        
        If _position_ < 0
          _position_ = 0
        EndIf
        
        ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
        FrontColor(_frame_color_)
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, *this\height[#__c_frame] - _frame_size_*2, _round_,_round_)
        ;   RoundBox(*this\x[#__c_frame] + _frame_size_+1, *this\y[#__c_frame] + _frame_size_+1, *this\width[#__c_frame] - _frame_size_*2-2, *this\height[#__c_frame] - _frame_size_*2-2, _round_,_round_)
        ;   ; ;   RoundBox(*this\x[#__c_frame] + _frame_size_+2, *this\y[#__c_frame] + _frame_size_+2, *this\width[#__c_frame] - _frame_size_*2-4, *this\height[#__c_frame] - _frame_size_*2-4, _round_,_round_)
        ;   ;   
        ;   ;   For i = 0 To 1
        ;   ;     RoundBox(*this\x[#__c_frame] + (_frame_size_+i), *this\y[#__c_frame] + (_frame_size_+i), *this\width[#__c_frame] - (_frame_size_+i)*2, *this\height[#__c_frame] - (_frame_size_+i)*2, _round_,_round_)
        ;   ;   Next
        
        If _gradient_
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          If _vertical_
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], (*this\x[#__c_frame] + *this\width[#__c_frame]), *this\y[#__c_frame])
          Else
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], *this\x[#__c_frame], (*this\y[#__c_frame] + *this\height[#__c_frame]))
          EndIf
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf 
        
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If Not _round_
          If _vertical_
            Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _frame_size_ - (_position_)))
          Else
            Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, (_position_) - _frame_size_, *this\height[#__c_frame] - _frame_size_*2)
          EndIf
        Else 
          
          If _vertical_
            If (*this\height[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)))
                Else
                  Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)))
                EndIf
              EndIf
              
              For a = (*this\height[#__c_frame] - _round_) To (*this\height[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (_position_)
                For a = _frame_size_ + (_position_) To _round_
                  For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                    If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = (_position_) - _frame_size_ To (*this\height[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          Else
            If (_position_) > _round_
              ; рисуем прямоуголную часть
              If *this\width[#__c_frame] > _round_*2
                If (*this\width[#__c_frame] - (_position_)) > _round_ 
                  Box(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) , *this\height[#__c_frame] - _frame_size_*2)
                Else
                  Box(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) + (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
                EndIf
              EndIf
              
              For a = _frame_size_ To _round_
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\width[#__c_frame] - (_position_))
                For a = (*this\width[#__c_frame] - _frame_size_ - _round_) To (_position_) - _frame_size_
                  For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                    If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = _frame_size_ To (_position_) + _frame_size_ - 1
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          EndIf
          
        EndIf
        
        BackColor(_fore_color2_)
        FrontColor(_back_color2_)
        
        If Not _round_
          If _vertical_
            Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, (_position_) - _frame_size_)
          Else 
            Box(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _frame_size_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
          EndIf 
        Else 
          If _vertical_
            If (_position_) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (*this\height[#__c_frame] - (_position_))
                  Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_) + (*this\height[#__c_frame] - _round_ - (_position_)))
                Else
                  Box(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_))
                EndIf
              EndIf
              
              For a = _frame_size_ To _round_
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\height[#__c_frame] - (_position_))
                For a = (*this\height[#__c_frame] - _frame_size_ - _round_) To (_position_) - _frame_size_
                  For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_*2)
                    If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = _frame_size_ To (_position_) + _frame_size_ - 1
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i*2, 1)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          Else
            If (*this\width[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\width[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  Box(*this\x[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
                Else
                  Box(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
                EndIf
              EndIf
              
              For a = (*this\width[#__c_frame] - _round_) To (*this\width[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (_position_)
                For a = _frame_size_ + (_position_) To _round_
                  For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                    If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = (_position_) - _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_*2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i*2)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          EndIf
        EndIf 
        
        
        ; Draw string
        If *this\text And *this\text\string And ( *this\height > *this\text\height )
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state] )
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i Spin_Draw( *this._s_WIDGET ) 
      Scroll_Draw( *this )
      
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( *this\bar\button[#__b_1]\x - 2,*this\y[#__c_frame],*this\x[#__c_inner] + *this\width[#__c_container] - *this\bar\button[#__b_1]\x + 3,*this\height[#__c_frame], *this\color\frame[*this\color\state] )
      Box( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\color\frame[*this\color\state] )
      
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
        DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0] ) ; *this\color\state] )
      EndIf
    EndProcedure
    
    Procedure.b Track_Draw( *this._s_WIDGET )
      Scroll_Draw( *this )
      ;Progress_Draw( *this )
      
      With *this
        If \type = #__type_TrackBar
          Protected i, x,y
          DrawingMode( #PB_2DDrawing_XOr )
          
          If \vertical
            x = \bar\button[#__b_3]\x + Bool( \bar\inverted )*( \bar\button[#__b_3]\width - 3 + 4 ) - 2
            y = *this\y + \bar\area\pos + \bar\button[#__b_3]\size/2  
            
            If \bar\mode & #PB_TrackBar_Ticks
              For i = 0 To \bar\page\end
                Line( x, y + _bar_thumb_pos_( *this\bar, i ),6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3,1,\bar\button[#__b_3]\color\Frame )
              Next
            EndIf
            
            Line( x-3, y,3,1,\bar\button[#__b_3]\color\Frame )
            Line( x-3, y + *this\bar\area\len - *this\bar\thumb\len,3,1,\bar\button[#__b_3]\color\Frame )
            
          Else
            x = *this\x + \bar\area\pos + \bar\button[#__b_3]\size/2 
            y = \bar\button[#__b_3]\y + Bool( Not \bar\inverted )*( \bar\button[#__b_3]\height - 3 + 4 ) - 2
            
            If \bar\mode & #PB_TrackBar_Ticks
              For i = *this\bar\min To *this\bar\max
                Line( x + _bar_thumb_pos_( *this\bar, i ), y,1,6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3,\bar\button[#__b_3]\color\Frame )
              Next
            EndIf
            
            Line( x, y-3,1,3,*this\bar\button[#__b_3]\color\Frame )
            Line( x + *this\bar\area\len - *this\bar\thumb\len, y-3,1,3, *this\bar\button[#__b_3]\color\Frame )
          EndIf
        EndIf
      EndWith    
      
    EndProcedure
    
    Procedure.b Splitter_Draw( *this._s_WIDGET )
      With *this
        DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
        
        ; draw the splitter background
        Box(  *this\bar\button[#__split_b3]\x, *this\bar\button[#__split_b3]\y, *this\bar\button[#__split_b3]\width, *this\bar\button[#__split_b3]\height, *this\color\back[*this\bar\button[#__split_b3]\color\state]&$ffffff|210<<24 )
        
        ; if there is no first child, draw the background
        If Not ( \index[#__split_1] Or \gadget[#__split_1] )
          Box( \bar\button[#__split_b1]\x, \bar\button[#__split_b1]\y,\bar\button[#__split_b1]\width,\bar\button[#__split_b1]\height,\color\frame[\bar\button[#__split_b1]\color\state] )
        EndIf
        
        ; if there is no second child, draw the background
        If Not ( \index[#__split_2] Or \gadget[#__split_2] )
          Box( \bar\button[#__split_b2]\x, \bar\button[#__split_b2]\y,\bar\button[#__split_b2]\width,\bar\button[#__split_b2]\height,\color\frame[\bar\button[#__split_b2]\color\state] )
        EndIf
        
        DrawingMode( #PB_2DDrawing_Outlined )
        
        ; if there is no first child, draw the frame
        If Not ( \index[#__split_1] Or \gadget[#__split_1] )
          Box( \bar\button[#__split_b1]\x, \bar\button[#__split_b1]\y,\bar\button[#__split_b1]\width,*this\bar\button[#__split_b1]\height,*this\color\frame[*this\bar\button[#__split_b1]\color\state] )
        EndIf
        
        ; if there is no second child, draw the frame
        If Not ( \index[#__split_2] Or \gadget[#__split_2] )
          Box( \bar\button[#__split_b2]\x, \bar\button[#__split_b2]\y,\bar\button[#__split_b2]\width,*this\bar\button[#__split_b2]\height,*this\color\frame[*this\bar\button[#__split_b2]\color\state] )
        EndIf
        
        ; 
        If *this\bar\thumb\len
          Protected circle_x, circle_y
          
          If *this\vertical
            circle_y = ( *this\bar\button[#__split_b3]\y + *this\bar\button[#__split_b3]\height/2 )
            circle_x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *this\bar\button[#__split_b3]\round )/2 + Bool( *this\width%2 )
          Else
            circle_x = ( *this\bar\button[#__split_b3]\x + *this\bar\button[#__split_b3]\width/2 ) ; - *this\x
            circle_y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *this\bar\button[#__split_b3]\round )/2 + Bool( *this\height%2 )
          EndIf
          
          If \vertical ; horisontal line
            If \bar\button[#__split_b3]\width > 35
              Circle( circle_x - ( \bar\button[#__split_b3]\round*2 + 2 )*2 - 2, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
              Circle( circle_x + ( \bar\button[#__split_b3]\round*2 + 2 )*2 + 2, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
            EndIf
            If \bar\button[#__split_b3]\width > 20
              Circle( circle_x - ( \bar\button[#__split_b3]\round*2 + 2 ), circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
              Circle( circle_x + ( \bar\button[#__split_b3]\round*2 + 2 ), circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
            EndIf
          Else
            If \bar\button[#__split_b3]\height > 35
              Circle( circle_x,circle_y - ( \bar\button[#__split_b3]\round*2 + 2 )*2 - 2, \bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
              Circle( circle_x,circle_y + ( \bar\button[#__split_b3]\round*2 + 2 )*2 + 2, \bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
            EndIf
            If \bar\button[#__split_b3]\height > 20
              Circle( circle_x,circle_y - ( \bar\button[#__split_b3]\round*2 + 2 ), \bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
              Circle( circle_x,circle_y + ( \bar\button[#__split_b3]\round*2 + 2 ), \bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
            EndIf
          EndIf
          
          Circle( circle_x, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\Frame[#__s_2] )
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_Draw( *this._s_WIDGET )
      With *this
        If \text\string  And ( *this\type = #__type_Spin Or
                               *this\type = #__type_ProgressBar )
          
          _draw_font_( *this )
          
          If \text\change Or *this\resize & #__resize_change
            
            Protected _x_ = *this\x[#__c_inner]
            Protected _y_ = *this\y[#__c_inner]
            Protected _width_ = *this\width[#__c_inner]
            Protected _height_ = *this\height[#__c_inner]
            
            If *this\text\rotate = 0
              *this\text\y = _y_ + ( _height_ - *this\text\height )/2
              
              If *this\text\align\right
                *this\text\x = _x_ + ( _width_ - *this\text\align\delta\x - *this\text\width - *this\text\padding\x ) 
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + ( _width_ - *this\text\align\delta\x - *this\text\width )/2
              Else
                *this\text\x = _x_ + *this\text\padding\x
              EndIf
              
            ElseIf *this\text\rotate = 180
              *this\text\y = _y_ + ( _height_ - *this\y )
              
              If *this\text\align\right
                *this\text\x = _x_ + *this\text\padding\x + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + ( _width_ + *this\text\width )/2 
              Else
                *this\text\x = _x_ + _width_ - *this\text\padding\x 
              EndIf
              
            ElseIf *this\text\rotate = 90
              *this\text\x = _x_ + ( _width_ - *this\text\height )/2
              
              If *this\text\align\right
                *this\text\y = _y_  + *this\text\align\delta\y +  *this\text\padding\y + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + ( _height_ + *this\text\align\delta\y + *this\text\width )/2
              Else
                *this\text\y = _y_ + _height_ - *this\text\padding\y
              EndIf
              
            ElseIf *this\text\rotate = 270
              *this\text\x = _x_ + ( _width_ - 4 )
              
              If *this\text\align\right
                *this\text\y = _y_ + ( _height_ - *this\text\width - *this\text\padding\y ) 
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + ( _height_ - *this\text\width )/2 
              Else
                *this\text\y = _y_ + *this\text\padding\y 
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        Select \type
          Case #__type_Spin           : Spin_Draw( *this )
          Case #__type_TabBar,#__type_ToolBar         : Tab_Draw( *this )
          Case #__type_TrackBar       : Track_Draw( *this )
          Case #__type_ScrollBar      : Scroll_Draw( *this )
          Case #__type_ProgressBar    : Progress_Draw( *this )
          Case #__type_Splitter       : Splitter_Draw( *this )
        EndSelect
        
        ;            DrawingMode( #PB_2DDrawing_Outlined )
        ;            Box( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00 )
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        
      EndWith
    EndProcedure
    
    ;- 
    Procedure.b Bar_Resize( *this._s_WIDGET )
      Protected result.b, fixed.l, ScrollPos.f, ThumbPos.i
      
      ; get thumb pos
      If *this\bar\fixed And Not *this\bar\page\change
        If *this\bar\fixed = #__split_1
          ThumbPos = *this\bar\button[*this\bar\fixed]\fixed
          
          If ThumbPos > *this\bar\area\end
            If *this\bar\min[1] < *this\bar\area\end
              ThumbPos = *this\bar\area\end
            Else
              If *this\bar\min[1] > ( *this\bar\area\end + *this\bar\min[2] )
                ThumbPos = ( *this\bar\area\end + *this\bar\min[2] )
              Else
                ThumbPos = *this\bar\min[1]
              EndIf
            EndIf
          EndIf
          
        Else 
          ThumbPos = ( *this\bar\area\end + *this\bar\min[2] ) - *this\bar\button[*this\bar\fixed]\fixed
          
          If ThumbPos < *this\bar\min[1]
            If *this\bar\min[1] > ( *this\bar\area\end + *this\bar\min[2] )
              ThumbPos = ( *this\bar\area\end + *this\bar\min[2] )
            Else
              ThumbPos = *this\bar\min[1]
            EndIf
          EndIf
        EndIf
        
        If *this\bar\thumb\pos <> ThumbPos
          *this\bar\thumb\change = *this\bar\thumb\pos - ThumbPos
          *this\bar\thumb\pos = ThumbPos
        EndIf
        
      Else
        If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
          If *this\bar\page\pos < *this\bar\min
            *this\bar\page\pos = *this\bar\min
          EndIf
        Else
          ; fixed mac-OS splitterGadget
          If *this\bar\page\pos < *this\bar\min
            If *this\bar\page\end 
              *this\bar\page\pos = *this\bar\page\end + *this\bar\page\pos
            Else
              Debug "error page\end - "+*this\bar\page\end
            EndIf
          EndIf
          
          ; for the scrollarea childrens
          If *this\bar\page\end And *this\bar\page\pos > *this\bar\page\end 
            ; Debug " bar end change - " + *this\bar\page\pos +" "+ *this\bar\page\end 
            *this\bar\page\change = *this\bar\page\pos - *this\bar\page\end
            *this\bar\page\pos = *this\bar\page\end
          EndIf
        EndIf
        
        If Not *this\bar\thumb\change
          ThumbPos = _bar_thumb_pos_( *this\bar, *this\bar\page\pos )
          ThumbPos = _bar_invert_thumb_pos_( *this\bar, ThumbPos )
          
          If ThumbPos < *this\bar\area\pos : ThumbPos = *this\bar\area\pos : EndIf
          If ThumbPos > *this\bar\area\end : ThumbPos = *this\bar\area\end : EndIf
          
          If *this\bar\thumb\pos <> ThumbPos
            *this\bar\thumb\change = *this\bar\thumb\pos - ThumbPos
            *this\bar\thumb\pos = ThumbPos
          EndIf
        EndIf
      EndIf
      
      
      ; get fixed size
      If *this\bar\fixed And *this\bar\page\change
        If *this\bar\fixed = #__split_1
          *this\bar\button[#__split_1]\fixed = *this\bar\thumb\pos
        Else
          *this\bar\button[#__split_2]\fixed = *this\bar\area\len - *this\bar\thumb\len - *this\bar\thumb\pos
        EndIf
      EndIf
      
      ; buttons state
      If ( *this\type = #__type_ScrollBar Or *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ; disable/enable button-scroll(left&top)-tab(right&bottom)
        If *this\bar\button[#__b_1]\size 
          If _bar_in_stop_( *this\bar )
            If *this\bar\button[#__b_1]\color\state <> #__s_3
              *this\bar\button[#__b_1]\color\state = #__s_3
            EndIf
          Else
            If *this\bar\button[#__b_1]\color\state <> #__s_2
              *this\bar\button[#__b_1]\color\state = #__s_0
            EndIf
          EndIf 
        Else
        EndIf
        
        ; disable/enable button-scroll(right&bottom)-tab(left&top)
        If *this\bar\button[#__b_2]\size And _bar_in_start_( *this\bar ) 
          If *this\bar\button[#__b_2]\color\state <> #__s_3 
            *this\bar\button[#__b_2]\color\state = #__s_3
          EndIf
        Else
          If *this\bar\button[#__b_2]\color\state <> #__s_2
            *this\bar\button[#__b_2]\color\state = #__s_0
          EndIf
        EndIf
        
        ; disable/enable button-thumb
        If *this\type = #__type_ScrollBar
          If *this\bar\thumb\len 
            If *this\bar\button[#__b_1]\color\state = #__s_3 And
               *this\bar\button[#__b_2]\color\state = #__s_3 
              
              If *this\bar\button[#__b_3]\color\state <> #__s_3
                *this\bar\button[#__b_3]\color\state = #__s_3
              EndIf
            Else
              If *this\bar\button[#__b_3]\color\state <> #__s_2
                *this\bar\button[#__b_3]\color\state = #__s_0
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; show/hide button-(right&bottom)
        If *this\bar\button[#__b_2]\size > 0
          If *this\bar\button[#__b_2]\hide <> Bool( *this\bar\button[#__b_2]\color\state = #__s_3 And (*this\type = #__type_TabBar Or *this\type = #__type_ToolBar) )
            *this\bar\button[#__b_2]\hide = Bool( *this\bar\button[#__b_2]\color\state = #__s_3 And (*this\type = #__type_TabBar Or *this\type = #__type_ToolBar) )
          EndIf
        Else
          If *this\bar\button[#__b_2]\hide <> #True
            *this\bar\button[#__b_2]\hide = #True
          EndIf
        EndIf
        
        ; show/hide button-(left&top)
        If *this\bar\button[#__b_1]\size > 0
          If *this\bar\button[#__b_1]\hide <> Bool( *this\bar\button[#__b_1]\color\state = #__s_3 And (*this\type = #__type_TabBar Or *this\type = #__type_ToolBar) )
            *this\bar\button[#__b_1]\hide = Bool( *this\bar\button[#__b_1]\color\state = #__s_3 And (*this\type = #__type_TabBar Or *this\type = #__type_ToolBar) )
          EndIf
        Else
          If *this\bar\button[#__b_1]\hide <> #True
            *this\bar\button[#__b_1]\hide = #True
          EndIf
        EndIf
      EndIf
      
      
      ; resize coordinate
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        ; inner coordinate
        If *this\vertical
          *this\x[#__c_inner] = *this\x[#__c_frame] 
          *this\width[#__c_inner] = *this\width[#__c_frame] - 1
          *this\y[#__c_inner] = *this\y[#__c_frame] + Bool( *this\bar\button[#__b_2]\hide = #False ) * ( *this\bar\button[#__b_2]\size + *this\fs )
          *this\height[#__c_inner] = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\y[#__c_inner] - Bool( *this\bar\button[#__b_1]\hide = #False ) * ( *this\bar\button[#__b_1]\size + *this\fs )
        Else
          *this\y[#__c_inner] = *this\y[#__c_frame]
          *this\height[#__c_inner] = *this\height[#__c_frame] - 1
          *this\x[#__c_inner] = *this\x[#__c_frame] + Bool( *this\bar\button[#__b_2]\hide = #False ) * ( *this\bar\button[#__b_2]\size + *this\fs )
          *this\width[#__c_inner] = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\x[#__c_inner] - Bool( *this\bar\button[#__b_1]\hide = #False ) * ( *this\bar\button[#__b_1]\size + *this\fs )
        EndIf
        
        If *this\bar\button[#__b_2]\size And Not *this\bar\button[#__b_2]\hide 
          If *this\vertical 
            ; Top button coordinate on vertical scroll bar
            ;  *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *this\bar\button[#__b_2]\size )/2            
            *this\bar\button[#__b_2]\y = *this\y[#__c_inner] - *this\bar\button[#__b_2]\size
          Else 
            ; Left button coordinate on horizontal scroll bar
            *this\bar\button[#__b_2]\x = *this\x[#__c_inner] - *this\bar\button[#__b_2]\size
            ;  *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *this\bar\button[#__b_2]\size )/2           
          EndIf
          If *this\bar\button[#__b_2]\width <> *this\bar\button[#__b_2]\size
            *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\size
          EndIf
          If *this\bar\button[#__b_2]\height <> *this\bar\button[#__b_2]\size
            *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\size                   
          EndIf
        EndIf
        
        If *this\bar\button[#__b_1]\size And Not *this\bar\button[#__b_1]\hide
          If *this\vertical 
            ; Botom button coordinate on vertical scroll bar
            ;  *this\bar\button[#__b_1]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *this\bar\button[#__b_1]\size )/2              
            *this\bar\button[#__b_1]\y = *this\y[#__c_inner] + *this\height[#__c_inner]
          Else 
            ; Right button coordinate on horizontal scroll bar
            *this\bar\button[#__b_1]\x = *this\x[#__c_inner] + *this\width[#__c_inner]
            ;  *this\bar\button[#__b_1]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *this\bar\button[#__b_1]\size )/2            
          EndIf
          If *this\bar\button[#__b_1]\width <> *this\bar\button[#__b_1]\size
            *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\size
          EndIf
          If *this\bar\button[#__b_1]\height <> *this\bar\button[#__b_1]\size 
            *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\size 
          EndIf
        EndIf
        
        ;If *this\bar\thumb\len
        If *this\vertical
          *this\bar\button[#__b_3]\x = *this\x[#__c_inner]          
          *this\bar\button[#__b_3]\width = *this\width[#__c_inner]
          *this\bar\button[#__b_3]\height = *this\bar\max                             
          *this\bar\button[#__b_3]\y = *this\y[#__c_frame] + ( *this\bar\thumb\pos - *this\bar\area\end )
        Else
          *this\bar\button[#__b_3]\y = *this\y[#__c_inner]         
          *this\bar\button[#__b_3]\height = *this\height[#__c_inner]
          *this\bar\button[#__b_3]\width = *this\bar\max
          *this\bar\button[#__b_3]\x = *this\x[#__c_frame] + ( *this\bar\thumb\pos - *this\bar\area\end )
        EndIf
        ;EndIf
        
        
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ;
      If *this\type = #__type_ScrollBar
        If *this\bar\thumb\len 
          If *this\vertical
            *this\bar\button[#__b_3]\x = *this\x[#__c_frame]           + 1 ; white line size 
            *this\bar\button[#__b_3]\width = *this\width[#__c_frame]   - 1 ; white line size 
            *this\bar\button[#__b_3]\y = *this\y[#__c_inner_b] + *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
          Else
            *this\bar\button[#__b_3]\y = *this\y[#__c_frame]           + 1 ; white line size
            *this\bar\button[#__b_3]\height = *this\height[#__c_frame] - 1 ; white line size
            *this\bar\button[#__b_3]\x = *this\x[#__c_inner_b] + *this\bar\thumb\pos 
            *this\bar\button[#__b_3]\width = *this\bar\thumb\len                                  
          EndIf
        EndIf
        
        If *this\bar\button[#__b_1]\size 
          If *this\vertical 
            ; Top button coordinate on vertical scroll bar
            *this\bar\button[#__b_1]\x = *this\bar\button[#__b_3]\x
            *this\bar\button[#__b_1]\width = *this\bar\button[#__b_3]\width
            *this\bar\button[#__b_1]\y = *this\y[#__c_frame] 
            *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\size                   
          Else 
            ; Left button coordinate on horizontal scroll bar
            *this\bar\button[#__b_1]\y = *this\bar\button[#__b_3]\y
            *this\bar\button[#__b_1]\height = *this\bar\button[#__b_3]\height
            *this\bar\button[#__b_1]\x = *this\x[#__c_frame] 
            *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\size 
          EndIf
        EndIf
        
        If *this\bar\button[#__b_2]\size 
          If *this\vertical 
            ; Botom button coordinate on vertical scroll bar
            *this\bar\button[#__b_2]\x = *this\bar\button[#__b_3]\x
            *this\bar\button[#__b_2]\width = *this\bar\button[#__b_3]\width
            *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\size 
            *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_2]\height
          Else 
            ; Right button coordinate on horizontal scroll bar
            *this\bar\button[#__b_2]\y = *this\bar\button[#__b_3]\y
            *this\bar\button[#__b_2]\height = *this\bar\button[#__b_3]\height
            *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\size 
            *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_2]\width 
          EndIf
        EndIf
        
        ; Thumb coordinate on scroll bar
        If Not *this\bar\thumb\len
          ; auto resize buttons
          If *this\vertical
            *this\bar\button[#__b_2]\height = *this\height[#__c_frame]/2 
            *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\bar\button[#__b_2]\height + Bool( *this\height[#__c_frame]%2 ) 
            
            *this\bar\button[#__b_1]\y = *this\y 
            *this\bar\button[#__b_1]\height = *this\height/2 - Bool( Not *this\height[#__c_frame]%2 )
            
          Else
            *this\bar\button[#__b_2]\width = *this\width[#__c_frame]/2 
            *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + *this\bar\button[#__b_2]\width + Bool( *this\width[#__c_frame]%2 ) 
            
            *this\bar\button[#__b_1]\x = *this\x[#__c_frame] 
            *this\bar\button[#__b_1]\width = *this\width[#__c_frame]/2 - Bool( Not *this\width[#__c_frame]%2 )
          EndIf
          
          If *this\vertical
            *this\bar\button[#__b_3]\width = 0 
            *this\bar\button[#__b_3]\height = 0                             
          Else
            *this\bar\button[#__b_3]\height = 0
            *this\bar\button[#__b_3]\width = 0                                 
          EndIf
        EndIf
      EndIf
      
      ;
      If *this\type = #__type_Splitter 
        If *this\bar\thumb\len 
          If *this\vertical
            *this\bar\button[#__b_3]\x = *this\x[#__c_frame]           + 1 ; white line size 
            *this\bar\button[#__b_3]\width = *this\width[#__c_frame]   - 1 ; white line size 
            *this\bar\button[#__b_3]\y = *this\y[#__c_inner_b] + *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
          Else
            *this\bar\button[#__b_3]\y = *this\y[#__c_frame]           + 1 ; white line size
            *this\bar\button[#__b_3]\height = *this\height[#__c_frame] - 1 ; white line size
            *this\bar\button[#__b_3]\x = *this\x[#__c_inner_b] + *this\bar\thumb\pos 
            *this\bar\button[#__b_3]\width = *this\bar\thumb\len                                  
          EndIf
        EndIf
        
        If *this\vertical
          *this\bar\button[#__split_b1]\width    = *this\width[#__c_frame]
          *this\bar\button[#__split_b1]\height   = *this\bar\thumb\pos
          
          *this\bar\button[#__split_b1]\x        = *this\x[#__c_frame]
          *this\bar\button[#__split_b2]\x        = *this\x[#__c_frame]
          
          If Not ( ( #PB_Compiler_OS = #PB_OS_MacOS ) And *this\index[#__split_1] And Not *this\parent )
            *this\bar\button[#__split_b1]\y      = *this\y[#__c_frame] 
            *this\bar\button[#__split_b2]\y      = ( *this\bar\thumb\pos + *this\bar\thumb\len ) + *this\y[#__c_frame] 
          Else
            *this\bar\button[#__split_b1]\y      = *this\height[#__c_frame] - *this\bar\button[#__split_b1]\height
          EndIf
          
          *this\bar\button[#__split_b2]\height   = *this\height[#__c_frame] - ( *this\bar\button[#__split_b1]\height + *this\bar\thumb\len )
          *this\bar\button[#__split_b2]\width    = *this\width[#__c_frame]
          
        Else
          *this\bar\button[#__split_b1]\width    = *this\bar\thumb\pos
          *this\bar\button[#__split_b1]\height   = *this\height[#__c_frame]
          
          *this\bar\button[#__split_b1]\y        = *this\y[#__c_frame]
          *this\bar\button[#__split_b2]\y        = *this\y[#__c_frame]
          *this\bar\button[#__split_b1]\x        = *this\x[#__c_frame]
          *this\bar\button[#__split_b2]\x        = ( *this\bar\thumb\pos + *this\bar\thumb\len ) + *this\x[#__c_frame]
          
          *this\bar\button[#__split_b2]\width    = *this\width[#__c_frame] - ( *this\bar\button[#__split_b1]\width + *this\bar\thumb\len )
          *this\bar\button[#__split_b2]\height   = *this\height[#__c_frame]
          
        EndIf
        
        
        ; Splitter childrens auto resize       
        If *this\gadget[#__split_1]
          If *this\index[#__split_1]
            If *this\root\canvas\container
              ResizeGadget( *this\gadget[#__split_1],
                            *this\bar\button[#__split_b1]\x,
                            *this\bar\button[#__split_b1]\y,
                            *this\bar\button[#__split_b1]\width, *this\bar\button[#__split_b1]\height )
            Else
              ResizeGadget( *this\gadget[#__split_1],
                            *this\bar\button[#__split_b1]\x + GadgetX( *this\root\canvas\gadget ), 
                            *this\bar\button[#__split_b1]\y + GadgetY( *this\root\canvas\gadget ),
                            *this\bar\button[#__split_b1]\width, *this\bar\button[#__split_b1]\height )
            EndIf
          Else
            If *this\gadget[#__split_1]\x <> *this\bar\button[#__split_b1]\x Or
               *this\gadget[#__split_1]\y <> *this\bar\button[#__split_b1]\y Or
               *this\gadget[#__split_1]\width <> *this\bar\button[#__split_b1]\width Or
               *this\gadget[#__split_1]\height <> *this\bar\button[#__split_b1]\height
              ; Debug "splitter_1_resize " + *this\gadget[#__split_1]
              
              If *this\gadget[#__split_1]\type = #__type_window
                Resize( *this\gadget[#__split_1],
                        *this\bar\button[#__split_b1]\x - *this\x[#__c_frame],
                        *this\bar\button[#__split_b1]\y - *this\y[#__c_frame], 
                        *this\bar\button[#__split_b1]\width - #__window_frame_size*2, *this\bar\button[#__split_b1]\height - #__window_frame_size*2 - #__window_caption_height)
              Else
                Resize( *this\gadget[#__split_1],
                        *this\bar\button[#__split_b1]\x - *this\x[#__c_frame],
                        *this\bar\button[#__split_b1]\y - *this\y[#__c_frame], 
                        *this\bar\button[#__split_b1]\width, *this\bar\button[#__split_b1]\height )
              EndIf
              
            EndIf
          EndIf
        EndIf
        
        If *this\gadget[#__split_2]
          If *this\index[#__split_2]
            If *this\root\canvas\container 
              ResizeGadget( *this\gadget[#__split_2],
                            *this\bar\button[#__split_b2]\x, 
                            *this\bar\button[#__split_b2]\y,
                            *this\bar\button[#__split_b2]\width, *this\bar\button[#__split_b2]\height )
            Else
              ResizeGadget( *this\gadget[#__split_2], 
                            *this\bar\button[#__split_b2]\x + GadgetX( *this\root\canvas\gadget ),
                            *this\bar\button[#__split_b2]\y + GadgetY( *this\root\canvas\gadget ),
                            *this\bar\button[#__split_b2]\width, *this\bar\button[#__split_b2]\height )
            EndIf
          Else
            If *this\gadget[#__split_2]\x <> *this\bar\button[#__split_b2]\x Or 
               *this\gadget[#__split_2]\y <> *this\bar\button[#__split_b2]\y Or
               *this\gadget[#__split_2]\width <> *this\bar\button[#__split_b2]\width Or
               *this\gadget[#__split_2]\height <> *this\bar\button[#__split_b2]\height 
              ; Debug "splitter_2_resize " + *this\gadget[#__split_2]
              
              If *this\gadget[#__split_2]\type = #__type_window
                Resize( *this\gadget[#__split_2], 
                        *this\bar\button[#__split_b2]\x - *this\x[#__c_frame], 
                        *this\bar\button[#__split_b2]\y - *this\y[#__c_frame], 
                        *this\bar\button[#__split_b2]\width - #__window_frame_size*2, *this\bar\button[#__split_b2]\height - #__window_frame_size*2 - #__window_caption_height )
              Else
                Resize( *this\gadget[#__split_2], 
                        *this\bar\button[#__split_b2]\x - *this\x[#__c_frame], 
                        *this\bar\button[#__split_b2]\y - *this\y[#__c_frame], 
                        *this\bar\button[#__split_b2]\width, *this\bar\button[#__split_b2]\height )
              EndIf
              
            EndIf
          EndIf   
        EndIf      
        
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ;
      If *this\type = #__type_TrackBar
        If *this\bar\direction > 0 
          If *this\bar\thumb\pos = *this\bar\area\end Or *this\bar\mode & #PB_TrackBar_Ticks
            *this\bar\button[#__b_3]\arrow\direction = Bool( Not *this\vertical ) + Bool( *this\vertical = *this\bar\inverted ) * 2
          Else
            *this\bar\button[#__b_3]\arrow\direction = Bool( *this\vertical ) + Bool( Not *this\bar\inverted ) * 2
          EndIf
        Else
          If *this\bar\thumb\pos = *this\bar\area\pos Or *this\bar\mode & #PB_TrackBar_Ticks 
            *this\bar\button[#__b_3]\arrow\direction = Bool( Not *this\vertical ) + Bool( *this\vertical = *this\bar\inverted ) * 2
          Else
            *this\bar\button[#__b_3]\arrow\direction = Bool( *this\vertical ) + Bool( *this\bar\inverted ) * 2
          EndIf
        EndIf
        
        ; button draw color
        *this\bar\button[#__b_3]\color\state = #__s_2
        If Not *this\bar\mode & #PB_TrackBar_Ticks
          If *this\bar\inverted
            *this\bar\button[#__b_2]\color\state = #__s_2
            ; *this\bar\button[#__b_1]\color\state = #__s_3
          Else
            ; *this\bar\button[#__b_2]\color\state = #__s_3
            *this\bar\button[#__b_1]\color\state = #__s_2
          EndIf
        EndIf
        
        ; track bar draw coordinate
        If *this\vertical
          If *this\bar\thumb\len
            *this\bar\button[#__b_3]\y      = *this\y[#__c_inner_b] + *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
          EndIf
          
          *this\bar\button[#__b_1]\width    = 4
          *this\bar\button[#__b_2]\width    = 4
          *this\bar\button[#__b_3]\width    = *this\bar\button[#__b_3]\size + ( Bool( *this\bar\button[#__b_3]\size<10 )**this\bar\button[#__b_3]\size )
          
          *this\bar\button[#__b_1]\y        = *this\y
          *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos + *this\bar\thumb\len/2 
          
          *this\bar\button[#__b_2]\y        = *this\y[#__c_inner_b] + *this\bar\thumb\pos + *this\bar\thumb\len/2
          *this\bar\button[#__b_2]\height   = *this\height - ( *this\bar\thumb\pos + *this\bar\thumb\len/2 )
          
          If *this\bar\inverted
            *this\bar\button[#__b_1]\x      = *this\x[#__c_frame] + 6
            *this\bar\button[#__b_2]\x      = *this\x[#__c_frame] + 6
            *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/4 - 1 -  Bool( *this\bar\button[#__b_3]\size>10 )
          Else
            *this\bar\button[#__b_1]\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_1]\width - 6
            *this\bar\button[#__b_2]\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_2]\width - 6 
            *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/2 + Bool( *this\bar\button[#__b_3]\size>10 )
          EndIf
        Else
          If *this\bar\thumb\len
            *this\bar\button[#__b_3]\x      = *this\x[#__c_inner_b] + *this\bar\thumb\pos 
            *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
          EndIf
          
          *this\bar\button[#__b_1]\height   = 4
          *this\bar\button[#__b_2]\height   = 4
          *this\bar\button[#__b_3]\height   = *this\bar\button[#__b_3]\size + ( Bool( *this\bar\button[#__b_3]\size<10 )**this\bar\button[#__b_3]\size )
          
          *this\bar\button[#__b_1]\x        = *this\x[#__c_frame]
          *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos + *this\bar\thumb\len/2
          
          *this\bar\button[#__b_2]\x        = *this\x[#__c_inner_b] + *this\bar\thumb\pos + *this\bar\thumb\len/2
          *this\bar\button[#__b_2]\width    = *this\width[#__c_frame] - ( *this\bar\thumb\pos + *this\bar\thumb\len/2 )
          
          If *this\bar\inverted
            *this\bar\button[#__b_1]\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_1]\height - 6
            *this\bar\button[#__b_2]\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_2]\height - 6 
            *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/2 + Bool( *this\bar\button[#__b_3]\size>10 )
          Else
            *this\bar\button[#__b_1]\y      = *this\y[#__c_frame] + 6
            *this\bar\button[#__b_2]\y      = *this\y[#__c_frame] + 6
            *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/4 - 1 -  Bool( *this\bar\button[#__b_3]\size>10 )
          EndIf
        EndIf
        
      EndIf
      
      
      
      ;
      If *this\bar\page\change <> 0
        If *this\type = #__type_ScrollBar
          ;- widget::Area_Update( )
          If *this\parent And 
             *this\parent\scroll
            
            If *this\vertical
              If *this\parent\scroll\v = *this
                *this\parent\change =- 1
                *this\parent\y[#__c_required] =- *this\bar\page\pos
                
                ; Area childrens x&y auto move 
                If *this\parent\container
                  If StartEnumerate( *this\parent ) 
                    If *this\parent = Widget( )\parent And 
                       *this\parent\scroll\v <> Widget( ) And 
                       *this\parent\scroll\h <> Widget( ) And Not Widget( )\align
                      
                      If _is_child_integral_( Widget( ) )
                        Resize( Widget( ), #PB_Ignore, ( Widget( )\y[#__c_container] + *this\bar\page\change ), #PB_Ignore, #PB_Ignore )
                      Else
                        Resize( Widget( ), #PB_Ignore, ( Widget( )\y[#__c_container] + *this\bar\page\change ) - *this\parent\y[#__c_required], #PB_Ignore, #PB_Ignore )
                      EndIf
                    EndIf
                    
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            Else
              If *this\parent\scroll\h = *this
                *this\parent\change =- 2
                *this\parent\x[#__c_required] =- *this\bar\page\pos
                
                ; Area childrens x&y auto move 
                If *this\parent\container
                  If StartEnumerate( *this\parent ) 
                    If *this\parent = Widget( )\parent And 
                       *this\parent\scroll\v <> Widget( ) And 
                       *this\parent\scroll\h <> Widget( ) And Not Widget( )\align
                      
                      If _is_child_integral_( Widget( ) )
                        Resize( Widget( ), ( Widget( )\x[#__c_container] + *this\bar\page\change ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                      Else
                        Resize( Widget( ), ( Widget( )\x[#__c_container] + *this\bar\page\change ) - *this\parent\x[#__c_required], #PB_Ignore, #PB_Ignore, #PB_Ignore )
                      EndIf
                    EndIf
                    
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        ;
        If *this\root\canvas\gadget <> PB(EventGadget)( ) And PB(IsGadget)( PB(EventGadget)( ) ) 
          Debug "bar redraw - "+*this\root\canvas\gadget +" "+ PB(EventGadget)( ) +" "+ EventGadget( )
          ReDraw( *this\root ) 
        EndIf
        
        ;         If _is_child_integral_( *this )
        ;           If *this\type = #__type_ScrollBar ; _is_scrollbars_( *this )
        ;             Post( #__event_ScrollChange, *this\parent, *this, *this\bar\page\change )
        ;           EndIf
        ;         Else
        ;           Post( #__event_Change, *this, EnterButton(), *this\bar\page\change )
        ;         EndIf
        
        *this\bar\page\change = 0
      EndIf 
      
      ; 
      If *this\bar\thumb\change <> 0
        If *this\root\canvas\gadget = PB(EventGadget)( ) 
          result = *this\bar\thumb\change
        EndIf
        
        *this\bar\thumb\change = 0
      EndIf  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Bar_Update( *this._s_WIDGET )
      Protected fixed.l, result.b, ScrollPos.f, ThumbPos.i
      Protected bordersize = 0;*this\bs
      Protected width = *this\width[#__c_frame]
      Protected height = *this\height[#__c_frame]
      
      ; get area size
      If *this\vertical
        *this\bar\area\len = height 
      Else
        *this\bar\area\len = width 
      EndIf
      
      If *this\type = #__type_ScrollBar 
        ; default button size
        If *this\bar\max 
          If *this\bar\button[#__b_1]\size =- 1 And *this\bar\button[#__b_2]\size =- 1
            If *this\vertical And width > 7 And width < 21
              *this\bar\button[#__b_1]\size = width - 1
              *this\bar\button[#__b_2]\size = width - 1
              
            ElseIf Not *this\vertical And height > 7 And height < 21
              *this\bar\button[#__b_1]\size = height - 1
              *this\bar\button[#__b_2]\size = height - 1
              
            Else
              *this\bar\button[#__b_1]\size = *this\bar\button[#__b_3]\size
              *this\bar\button[#__b_2]\size = *this\bar\button[#__b_3]\size
            EndIf
          EndIf
          
          ;           If *this\bar\button[#__b_3]\size
          ;             If *this\vertical
          ;               If *this\width = 0
          ;                 *this\width = *this\bar\button[#__b_3]\size
          ;               EndIf
          ;             Else
          ;               If *this\height = 0
          ;                 *this\height = *this\bar\button[#__b_3]\size
          ;               EndIf
          ;             EndIf
          ;           EndIf
        EndIf
      EndIf
      
      *this\bar\area\pos = ( *this\bar\button[#__b_1]\size + *this\bar\min[1] ) + bordersize
      *this\bar\thumb\end = *this\bar\area\len - ( *this\bar\button[#__b_1]\size + *this\bar\button[#__b_2]\size ) - bordersize*2
      
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        If *this\bar\max
          *this\bar\thumb\len = *this\bar\thumb\end - ( *this\bar\max - *this\bar\area\len )
          *this\bar\page\end = *this\bar\max - ( *this\bar\thumb\end - *this\bar\thumb\len )
        EndIf
      Else
        If *this\bar\page\len
          ; get thumb size
          *this\bar\thumb\len = Round( ( *this\bar\thumb\end / ( *this\bar\max - *this\bar\min ) ) * *this\bar\page\len, #PB_Round_Nearest )
          If *this\bar\thumb\len > *this\bar\thumb\end 
            *this\bar\thumb\len = *this\bar\thumb\end 
          EndIf
          If *this\bar\thumb\len < *this\bar\button[#__b_3]\size 
            If *this\bar\thumb\end > *this\bar\button[#__b_3]\size + *this\bar\thumb\len
              *this\bar\thumb\len = *this\bar\button[#__b_3]\size 
            ElseIf *this\bar\button[#__b_3]\size > 7
              Debug "get thumb size - ?????"
              *this\bar\thumb\len = 0
            EndIf
          EndIf
          
          ; for the scroll-bar
          If *this\bar\max > *this\bar\page\Len
            *this\bar\page\end = *this\bar\max - *this\bar\page\len
          Else
            *this\bar\page\end = *this\bar\page\Len - *this\bar\max
          EndIf
        Else
          ; get page end
          If *this\bar\max
            *this\bar\thumb\len = *this\bar\button[#__b_3]\size
            *this\bar\page\end = *this\bar\max
          Else
            ; get thumb size
            *this\bar\thumb\len = *this\bar\button[#__b_3]\size
            
            ; one set end
            If Not *this\bar\page\end And *this\bar\area\len 
              *this\bar\page\end = *this\bar\area\len - *this\bar\thumb\len
              
              If Not *this\bar\page\pos
                *this\bar\page\pos = *this\bar\page\end/2 
              EndIf
              
              ; if splitter fixed 
              ; set splitter pos to center
              If *this\bar\fixed
                If *this\bar\fixed = #__split_1
                  *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
                Else
                  *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\end - *this\bar\page\pos
                EndIf
              EndIf
            Else
              If *this\bar\page\change Or *this\bar\fixed = 1
                *this\bar\page\end = *this\bar\area\len - *this\bar\thumb\len 
              EndIf
            EndIf
          EndIf
          
        EndIf
      EndIf
      
      If *this\bar\page\end
        *this\bar\percent = ( *this\bar\thumb\end - *this\bar\thumb\len ) / ( *this\bar\page\end - *this\bar\min )
      Else
        *this\bar\percent = ( *this\bar\thumb\end - *this\bar\thumb\len ) / ( *this\bar\min )
      EndIf
      
      *this\bar\area\end = *this\bar\area\len - *this\bar\thumb\len - ( *this\bar\button[#__b_2]\size + *this\bar\min[2] + bordersize )
      
      
      ;Debug ""+*this\bar\thumb\len +" "+ *this\bar\thumb\end +" "+ *this\class
      ProcedureReturn 1;Bar_Resize( *this )  
    EndProcedure
    
    Procedure.b Bar_Change( *this._s_WIDGET, ScrollPos.f )
      With *this
        ;Debug ""+ScrollPos +" "+ \bar\page\end
        
        ;If ScrollPos < *this\bar\min : ScrollPos = *this\bar\min : EndIf
        If ScrollPos > *this\bar\page\end 
          If *this\bar\page\end
            ScrollPos = *this\bar\page\end 
          Else
            ScrollPos = _bar_page_pos_( *this\bar, *this\bar\area\end ) - ScrollPos
          EndIf
        EndIf
        
        If *this\bar\page\pos <> ScrollPos 
          If *this\bar\page\pos > ScrollPos
            *this\bar\direction =- ScrollPos
          Else
            *this\bar\direction = ScrollPos
          EndIf
          
          *this\bar\page\change = *this\bar\page\pos - ScrollPos
          *this\bar\page\pos = ScrollPos
          
          ; example-scroll(area) fixed
          If _is_child_integral_( *this )
            If *this\type = #__type_ScrollBar ; _is_scrollbars_( *this )
              Post( #__event_ScrollChange, *this\parent, *this, *this\bar\page\change )
            EndIf
          Else
            Post( #__event_Change, *this, EnterButton(), *this\bar\page\change )
          EndIf
          
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_SetState( *this._s_WIDGET, state.f )
      ;       If *this\type = #__type_TabBar
      ;         Tab_SetState( *this, state )
      ;       Else
      If Bar_Change( *this, state ) 
        Bar_Update( *this ) 
        ProcedureReturn Bar_Resize( *this )
      EndIf
      ;       EndIf
    EndProcedure
    
    Procedure.b Bar_SetPos( *this._s_WIDGET, ThumbPos.i )
      Protected ScrollPos.f
      If ThumbPos < *this\bar\area\pos : ThumbPos = *this\bar\area\pos : EndIf
      If ThumbPos > *this\bar\area\end : ThumbPos = *this\bar\area\end : EndIf
      
      If *this\bar\thumb\pos <> ThumbPos 
        ScrollPos = _bar_page_pos_( *this\bar, ThumbPos )
        ScrollPos = _bar_invert_page_pos_( *this\bar, ScrollPos )
        
        ; thumb move tick steps
        If *this\bar\mode & #PB_TrackBar_Ticks
          ThumbPos = _bar_thumb_pos_( *this\bar, ScrollPos )
          ThumbPos = _bar_invert_thumb_pos_( *this\bar, ThumbPos )
        EndIf
        
        If *this\bar\thumb\change <> *this\bar\thumb\pos - ThumbPos 
          *this\bar\thumb\change = *this\bar\thumb\pos - ThumbPos 
          *this\bar\thumb\pos = ThumbPos
          If Bar_Change( *this, ScrollPos )
            *this\_state | #__s_scrolled
          EndIf
          ProcedureReturn Bar_Resize( *this )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.l Bar_SetAttribute( *this._s_WIDGET, Attribute.l, *value )
      Protected result.l
      
      With *this
        If \type = #__type_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              *this\bar\min[1] = *value 
              ;*this\bar\button[#__b_1]\size = *value 
              result = Bool( \bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *this\bar\min[2] = *value
              ;*this\bar\button[#__b_2]\size = *value 
              result = Bool( \bar\max )
              
            Case #PB_Splitter_FirstGadget
              *this\gadget[#__split_1] = *value
              *this\index[#__split_1] = Bool( PB(IsGadget)( *value ) )
              result =- 1
              
            Case #PB_Splitter_SecondGadget
              *this\gadget[#__split_2] = *value
              *this\index[#__split_2] = Bool( PB(IsGadget)( *value ) )
              result =- 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If \bar\min <> *value ;And Not *value < 0
                \bar\area\change = \bar\min - *value
                If \bar\page\pos < *value
                  \bar\page\pos = *value
                EndIf
                \bar\min = *value
                ; Debug  " min " + \bar\min + " max " + \bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If \bar\max <> *value And Not ( *value < 0 And Not #__bar_minus)
                \bar\area\change = \bar\max - *value
                
                If \bar\min > *value And Not #__bar_minus
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = *value
                EndIf
                ;                 
                If Not \bar\max And Not #__bar_minus
                  \bar\page\pos = \bar\max
                EndIf
                ; Debug  "   min " + \bar\min + " max " + \bar\max
                
                ;\bar\page\change = #True
                result = #True
              EndIf
              
            Case #__bar_pagelength
              If \bar\page\len <> *value And Not ( *value < 0 And Not #__bar_minus )
                \bar\area\change = \bar\page\len - *value
                \bar\page\len = *value
                
                If Not \bar\max And Not #__bar_minus
                  If \bar\min > *value
                    \bar\max = \bar\min + 1
                  Else
                    \bar\max = *value
                  EndIf
                EndIf
                
                result = #True
              EndIf
              
            Case #__bar_buttonsize
              If \bar\button[#__b_3]\size <> *value
                \bar\button[#__b_3]\size = *value
                
                If \type = #__type_ScrollBar
                  \bar\button[#__b_1]\size = *value
                  \bar\button[#__b_2]\size = *value
                EndIf
                
                If \type = #__type_TabBar Or *this\type = #__type_ToolBar
                  \bar\button[#__b_1]\size = *value
                  \bar\button[#__b_2]\size = *value
                EndIf
                
                *this\resize | #__resize_change
                result = #True
              EndIf
              
            Case #__bar_invert
              \bar\inverted = Bool( *value )
              Bar_Update( *this )
              ProcedureReturn Bar_Resize( *this )  
            Case #__bar_ScrollStep 
              \scroll\increment = *value
              
          EndSelect
        EndIf
        
        If result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\page\change = #True
                  ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
          
          If *this\root ;And *this\root\canvas\postevent = #False
            Bar_Update( *this ) ; \hide = 
            Bar_Resize( *this )  
          EndIf
          
          If *this\type = #__type_Splitter
            If result =- 1
              SetParent(*value, *this)
            EndIf
          EndIf
        EndIf
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Bar_Updates( *this._s_WIDGET, x.l,y.l,width.l,height.l )
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
      If *this\scroll\v\bar\page\len <> height - Bool( *this\width[#__c_required] > width ) * *this\scroll\h\height
        *this\scroll\v\bar\page\len = height - Bool( *this\width[#__c_required] > width ) * *this\scroll\h\height
      EndIf
      
      If *this\scroll\h\bar\page\len <> width - Bool( *this\height[#__c_required] > height ) * *this\scroll\v\width
        *this\scroll\h\bar\page\len = width - Bool( *this\height[#__c_required] > height ) * *this\scroll\v\width
      EndIf
      
      If *this\x[#__c_required] < x
        ; left set state
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        sx = ( *this\x[#__c_required] - x ) 
        *this\width[#__c_required] + sx
        *this\x[#__c_required] = x
      EndIf
      
      If *this\y[#__c_required] < y
        ; top set state
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        sy = ( *this\y[#__c_required] - y )
        *this\height[#__c_required] + sy
        *this\y[#__c_required] = y
      EndIf
      
      If *this\width[#__c_required] > *this\scroll\h\bar\page\len - ( *this\x[#__c_required] - x )
        If *this\width[#__c_required] - sx <= width And *this\height[#__c_required] = *this\scroll\v\bar\page\len - ( *this\y[#__c_required] - y )
          ;Debug "w - " + Str( *this\height[#__c_required] - sx )
          
          ; if on the h - scroll
          If *this\scroll\v\bar\max > height - *this\scroll\h\height
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width 
            *this\height[#__c_required] = *this\scroll\v\bar\max
            ;  Debug "w - " + *this\scroll\v\bar\max  + " " +  *this\scroll\v\height  + " " +  *this\scroll\v\bar\page\len
          Else
            *this\height[#__c_required] = *this\scroll\v\bar\page\len - ( *this\x[#__c_required] - x ) - *this\scroll\h\height
          EndIf
        EndIf
        
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
      Else
        *this\scroll\h\bar\max = *this\width[#__c_required]
        *this\width[#__c_required] = *this\scroll\h\bar\page\len - ( *this\x[#__c_required] - x )
      EndIf
      
      If *this\height[#__c_required] > *this\scroll\v\bar\page\len - ( *this\y[#__c_required] - y )
        If *this\height[#__c_required] - sy <= Height And *this\width[#__c_required] = *this\scroll\h\bar\page\len - ( *this\x[#__c_required] - x )
          ;Debug " h - " + Str( *this\height[#__c_required] - sy )
          
          ; if on the v - scroll
          If *this\scroll\h\bar\max > width - *this\scroll\v\width
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
            *this\width[#__c_required] = *this\scroll\h\bar\max
            ;  Debug "h - " + *this\scroll\h\bar\max  + " " +  *this\scroll\h\width  + " " +  *this\scroll\h\bar\page\len
          Else
            *this\width[#__c_required] = *this\scroll\h\bar\page\len - ( *this\x[#__c_required] - x ) - *this\scroll\v\width
          EndIf
        EndIf
        
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        *this\scroll\v\bar\max = *this\height[#__c_required]
        *this\height[#__c_required] = *this\scroll\v\bar\page\len - ( *this\y[#__c_required] - y )
      EndIf
      
      If *this\scroll\h\round And
         *this\scroll\v\round And
         *this\scroll\h\bar\page\len < width And 
         *this\scroll\v\bar\page\len < height
        round = ( *this\scroll\h\height/4 )
      EndIf
      
      If *this\width[#__c_required] >= *this\scroll\h\bar\page\len  
        If *this\scroll\h\bar\Max <> *this\width[#__c_required] 
          *this\scroll\h\bar\Max = *this\width[#__c_required]
          
          If *this\x[#__c_required] <= x 
            *this\scroll\h\bar\page\pos =- ( *this\x[#__c_required] - x )
          EndIf
        EndIf
        
        If *this\scroll\h\width <> *this\scroll\h\bar\page\len + round
          ; Debug  "h " + *this\scroll\h\bar\page\len
          Resize( *this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len + round, #PB_Ignore )
          *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len ) ) 
          ;           *this\scroll\h\width = *this\scroll\h\bar\page\len + round
          ;           *this\scroll\h\hide = Bar_Update( *this\scroll\h )
          result = 1
        EndIf
      EndIf
      
      If *this\height[#__c_required] >= *this\scroll\v\bar\page\len  
        If *this\scroll\v\bar\Max <> *this\height[#__c_required]  
          *this\scroll\v\bar\Max = *this\height[#__c_required]
          
          If *this\y[#__c_required] <= y 
            ;If *this\scroll\v\bar\page\pos <>- ( *this\y[#__c_required] - y )
            *this\scroll\v\bar\page\pos =- ( *this\y[#__c_required] - y )
            
            ; Post( #__event_change, *this\scroll\v )
            ;EndIf
          EndIf
        EndIf
        
        If *this\scroll\v\height <> *this\scroll\v\bar\page\len + round
          ; Debug  "v " + *this\scroll\v\bar\page\len
          Resize( *this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len + round )
          *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len ) ) 
          ;           *this\scroll\v\height = *this\scroll\v\bar\page\len + round
          ;           *this\scroll\v\hide = Bar_Update( *this\scroll\v )
          result = 1
        EndIf
      EndIf
      
      ;       If Not *this\scroll\h\hide 
      ;         If *this\scroll\h\y[#__c_container] <> y + height - *this\scroll\h\height
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize( *this\scroll\h, #PB_Ignore, y + height - *this\scroll\h\height, #PB_Ignore, #PB_Ignore )
      ;         EndIf
      ;         If *this\scroll\h\x[#__c_container] <> x
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize( *this\scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ;         EndIf
      ;       EndIf
      ;       
      ;       If Not *this\scroll\v\hide 
      ;         If *this\scroll\v\x[#__c_container] <> x + width - *this\scroll\v\width
      ;           ; Debug "x"
      ;           *this\scroll\v\hide = Resize( *this\scroll\v, x + width - *this\scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ;         EndIf
      ;         If *this\scroll\v\y[#__c_container] <> y
      ;           ; Debug "y"
      ;           *this\scroll\v\hide = Resize( *this\scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore )
      ;         EndIf
      ;       EndIf
      
      If v_max <> *this\scroll\v\bar\Max
        v_max = *this\scroll\v\bar\Max
        *this\scroll\v\resize | #__resize_change
        Bar_Update( *this\scroll\v ) 
        Bar_Resize( *this\scroll\v )  
        *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len ) ) 
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        Bar_Update( *this\scroll\h ) 
        Bar_Resize( *this\scroll\h )  
        *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len ) ) 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   _3Bar_Resizes( *this._s_WIDGET, x.l,y.l,width.l,height.l )
      With *this\scroll
        Protected iwidth, iheight, w, h
        If Not \v Or Not \h : ProcedureReturn : EndIf 
        
        If x = #PB_Ignore 
          x = \h\x[#__c_container] 
        EndIf
        If y = #PB_Ignore 
          y = \v\y[#__c_container]
        EndIf
        If width = #PB_Ignore 
          width = \v\x[#__c_frame] - \h\x[#__c_frame] + \v\width[#__c_frame] 
        EndIf
        If height = #PB_Ignore 
          height = \h\y[#__c_frame] - \v\y[#__c_frame] + \h\height[#__c_frame] 
        EndIf
        
        w = Bool( *this\width[#__c_required] > width )
        h = Bool( *this\height[#__c_required] > height )
        
        \v\bar\page\len = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        \h\bar\page\len = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        
        iheight = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        If \v\bar\page\len <> iheight
          \v\bar\area\change = \v\bar\page\len - iheight
          \v\bar\page\len = iheight
          
          If Not \v\bar\max
            If \v\bar\min > iheight
              \v\bar\max = \v\bar\min + 1
            Else
              \v\bar\max = iheight
            EndIf
          EndIf
        EndIf
        
        iwidth = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        If \h\bar\page\len <> iwidth
          \h\bar\area\change = \h\bar\page\len - iwidth
          \h\bar\page\len = iwidth
          
          If Not \h\bar\max
            If \h\bar\min > iwidth
              \h\bar\max = \h\bar\min + 1
            Else
              \h\bar\max = iwidth
            EndIf
          EndIf
        EndIf
        
        width + x
        height + y
        
        If \v\x[#__c_frame] <> width - \v\width 
          Resize( \v, width - \v\width , y, #PB_Ignore, #PB_Ignore )
        EndIf
        
        If \h\y[#__c_frame] <> height - \h\height
          Resize( \h, x, height - \h\height, #PB_Ignore, #PB_Ignore )
        EndIf
        
        If \v\bar\max > \v\bar\page\len 
          ;\v\y = y
          height = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ) 
          If \v\height[#__c_frame] <> height
            \v\height[#__c_frame] = height 
            \v\height[#__c_screen] = height + ( \v\bs*2 - \v\fs*2 )
            \v\height[#__c_container] = height - \v\fs*2 
            If \v\height[#__c_container] < 0 : \v\height[#__c_container] = 0 : EndIf
            \v\height[#__c_inner] = \v\height[#__c_container]
            \v\height[#__c_clip] = \v\parent\height[#__c_clip]
            
            Bar_Update( \v )
            Bar_Resize( \v )
          EndIf
          ;   Resize( \v, #PB_Ignore, y, #PB_Ignore, ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ) )
          If \v\hide <> #False
            \v\hide = #False
          EndIf
        Else
          If \v\hide <> #True
            \v\hide = #True
            ;\v\y = y
            \v\height = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ) 
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If Bar_Change( \v, \v\bar\min )
                Bar_Resize( \v )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          ;\h\x = x
          width = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 ) )
          If \h\width[#__c_frame] <> width
            \h\width[#__c_frame] = width 
            \h\width[#__c_screen] = width + ( \h\bs*2 - \h\fs*2 )
            \h\width[#__c_container] = width - \h\fs*2 
            If \h\width[#__c_container] < 0 : \h\width[#__c_container] = 0 : EndIf
            \h\width[#__c_inner] = \h\width[#__c_container]
            \h\width[#__c_clip] = \h\parent\width[#__c_clip]
            
            Bar_Update( \h )
            Bar_Resize( \h )
          EndIf
          ; Resize( \h, x, #PB_Ignore, ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 ) ), #PB_Ignore )
          If \h\hide <> #False
            \h\hide = #False
          EndIf
        Else
          If \h\hide <> #True
            \h\hide = #True
            \h\width = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 ) ) 
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If Bar_Change( \h, \h\bar\min )
                Bar_Resize( \h )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ProcedureReturn Bool( \v\bar\area\change Or \h\bar\area\change )
      EndWith
    EndProcedure
    Procedure   Bar_Resizes( *this._s_WIDGET, x.l,y.l,width.l,height.l )
      With *this\scroll
        Protected iwidth, iheight, w, h
        If Not \v Or Not \h : ProcedureReturn : EndIf 
        
        If x = #PB_Ignore 
          x = \h\x[#__c_container] 
        EndIf
        If y = #PB_Ignore 
          y = \v\y[#__c_container]
        EndIf
        If width = #PB_Ignore 
          width = \v\x[#__c_frame] - \h\x[#__c_frame] + \v\width[#__c_frame] 
        EndIf
        If height = #PB_Ignore 
          height = \h\y[#__c_frame] - \v\y[#__c_frame] + \h\height[#__c_frame] 
        EndIf
        
        w = Bool( *this\width[#__c_required] > width )
        h = Bool( *this\height[#__c_required] > height )
        
        \v\bar\page\len = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        \h\bar\page\len = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        
        iheight = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        If \v\bar\page\len <> iheight
          \v\bar\area\change = \v\bar\page\len - iheight
          \v\bar\page\len = iheight
          
          If Not \v\bar\max
            If \v\bar\min > iheight
              \v\bar\max = \v\bar\min + 1
            Else
              \v\bar\max = iheight
            EndIf
          EndIf
        EndIf
        
        iwidth = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        If \h\bar\page\len <> iwidth
          \h\bar\area\change = \h\bar\page\len - iwidth
          \h\bar\page\len = iwidth
          
          If Not \h\bar\max
            If \h\bar\min > iwidth
              \h\bar\max = \h\bar\min + 1
            Else
              \h\bar\max = iwidth
            EndIf
          EndIf
        EndIf
        
        width + x
        height + y
        
        If \v\x[#__c_frame] <> width - \v\width 
          Resize( \v, width - \v\width , y, #PB_Ignore, #PB_Ignore )
        EndIf
        
        If \h\y[#__c_frame] <> height - \h\height
          Resize( \h, x, height - \h\height, #PB_Ignore, #PB_Ignore )
        EndIf
        
        If \v\bar\max > \v\bar\page\len 
          Resize( \v, #PB_Ignore, y, #PB_Ignore, ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ) )
          If \v\hide <> #False
            \v\hide = #False
          EndIf
        Else
          If \v\hide <> #True
            \v\hide = #True
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If Bar_Change( \v, \v\bar\min )
                Bar_Resize( \v )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          Resize( \h, x, #PB_Ignore, ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 ) ), #PB_Ignore )
          If \h\hide <> #False
            \h\hide = #False
          EndIf
        Else
          If \h\hide <> #True
            \h\hide = #True
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If Bar_Change( \h, \h\bar\min )
                Bar_Resize( \h )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ProcedureReturn Bool( \v\bar\area\change Or \h\bar\area\change )
      EndWith
    EndProcedure
    
    
    Procedure   Bar_Events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
      Protected Repaint
      
      If eventtype = #__event_LeftButtonDown
        If ActiveButton( ) <> EnterButton( ) 
          ActiveButton( ) = EnterButton( )
        EndIf
        ; change the color state of non-disabled buttons
        
        If EnterButton( ) And 
           EnterButton( )\color\state <> #__s_3 And 
           EnterButton( )\_state & #__s_disabled = #False
          EnterButton( )\_state | #__s_selected
          
          If Not ( *this\type = #__type_TrackBar Or 
                   ( *this\type = #__type_Splitter And 
                     EnterButton( ) <> *this\bar\button[#__b_3] ) )
            EnterButton( )\color\state = #__s_2
          EndIf
          
          If _is_selected_( *this\bar\button[#__b_3] )
            Repaint = #True
          ElseIf ( _is_selected_( *this\bar\button[#__b_1] ) And *this\bar\inverted ) Or
                 ( _is_selected_( *this\bar\button[#__b_2] ) And Not *this\bar\inverted )
            
            Post( #__event_Down, *this )
            ;;Repaint | Bar_SetState( *this, *this\bar\page\pos + *this\scroll\increment )
            If Bar_Change( *this, *this\bar\page\pos + *this\scroll\increment ) 
              Bar_Update( *this ) 
              Repaint = Bar_Resize( *this )  
            EndIf
            
          ElseIf ( _is_selected_( *this\bar\button[#__b_2] ) And *this\bar\inverted ) Or 
                 ( _is_selected_( *this\bar\button[#__b_1] ) And Not *this\bar\inverted )
            
            Post( #__event_Up, *this )
            ;; Repaint | Bar_SetState( *this, *this\bar\page\pos - *this\scroll\increment )
            If Bar_Change( *this, *this\bar\page\pos - *this\scroll\increment ) 
              Bar_Update( *this ) 
              Repaint = Bar_Resize( *this )  
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #__event_LeftButtonUp
        If ActiveButton( ) And
           ActiveButton( )\_state & #__s_selected  
          ActiveButton( )\_state &~ #__s_selected 
          
          If ActiveButton( )\color\state <> #__s_3 And 
             ActiveButton( )\_state & #__s_disabled = #False 
            
            ; change color state
            If ActiveButton( )\color\state = #__s_2 And
               Not ( *this\type = #__type_TrackBar Or 
                     ( *this\type = #__type_Splitter And 
                       ActiveButton( ) <> *this\bar\button[#__b_3] ) )
              
              If ActiveButton( )\_state & #__s_entered
                ActiveButton( )\color\state = #__s_1
              Else
                ; for the splitter thumb
                If *this\bar\button[#__b_3] = ActiveButton( ) And 
                   *this\bar\button[#__b_2]\size <> $ffffff
                  _cursor_remove_( *this )
                EndIf
                
                ActiveButton( )\color\state = #__s_0 
              EndIf
            EndIf
            
            ;- widget::TabBar_Events( up )
            If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
              ;Debug Bool( *this\_state & #__s_scrolled ) ; ""+*this\bar\page\change+" "+*this\bar\thumb\change
              ; that is, if you did not move the items
              If Not *this\_state & #__s_scrolled And
                 ActiveButton( ) = *this\bar\button[#__b_3] 
                
                
                If *this\index[#__tab_1] >= 0 And 
                   *this\index[#__tab_2] <> *this\index[#__tab_1]
                  Repaint | Tab_SetState( *this, *this\index[#__tab_1] )
                EndIf
              EndIf
              
              *this\_state &~ #__s_scrolled
            EndIf
            
            Repaint = 1
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #__event_MouseMove
        If _is_selected_( *this ) And ActiveButton( ) = *this\bar\button[#__b_3]
          If *this\vertical
            Repaint | Bar_SetPos( *this, ( mouse_y - mouse( )\delta\y ) )
          Else
            Repaint | Bar_SetPos( *this, ( mouse_x - mouse( )\delta\x ) )
          EndIf
          SetWindowTitle( EventWindow( ), Str( *this\bar\page\pos )  + " " +  Str( *this\bar\thumb\pos - *this\bar\area\pos ) )
        EndIf
      EndIf
      
      
      ProcedureReturn Repaint
    EndProcedure
    ;}
    
    
    ;- 
    ;-  EDITOR
    Macro  _start_draw_( _this_ )
      StartDrawing( CanvasOutput( _this_\root\canvas\gadget ) ) 
      
      _draw_font_( _this_ )
      ;       If _this_\text\fontID
      ;         DrawingFont( _this_\text\fontID ) 
      ;       EndIf
    EndMacro
    
    Macro _row_x_( _this_ )
      ( _this_\x[#__c_inner] + _this_\row\_s( )\x + _this_\x[#__c_required] )
    EndMacro
    
    Macro _row_y_( _this_ )
      ( _this_\y[#__c_inner] + _this_\row\_s( )\y + _this_\y[#__c_required] )
    EndMacro
    
    Macro _row_text_x_( _this_ )
      ( _this_\x[#__c_inner] + _this_\row\_s( )\text\x + _this_\x[#__c_required] )
    EndMacro
    
    Macro _row_text_y_( _this_ )
      ( _this_\y[#__c_inner] + _this_\row\_s( )\text\y + _this_\y[#__c_required] )
    EndMacro
    
    Macro _row_text_edit_x_( _this_, _mode_ )
      ( _this_\x[#__c_inner] + _this_\row\_s( )\text\edit#_mode_\x + _this_\x[#__c_required] )
    EndMacro
    
    Macro _row_text_edit_y_( _this_, _mode_ )
      ( _this_\y[#__c_inner] + _this_\row\_s( )\text\edit#_mode_\y + _this_\y[#__c_required] )
    EndMacro
    
    Macro _text_scroll_x_( _this_ )
      If *this\scroll\h And Not *this\scroll\v\hide And _this_\text\caret\x
        ; *this\change =- _bar_scroll_pos_( *this\scroll\h, (_this_\text\caret\x - _this_\text\padding\x) - _this_\x, ( _this_\text\padding\x * 2 + _this_\row\margin\width ) ) ; ok
        *this\change =- _bar_scroll_pos_( *this\scroll\h, (_this_\text\caret\x - _this_\text\padding\x), ( _this_\text\padding\x * 2 + _this_\row\margin\width ) ) ; ok
      EndIf
    EndMacro
    
    Macro _text_scroll_y_( _this_ )
      If *this\scroll\v And Not *this\scroll\v\hide
        ;  *this\change =- _bar_scroll_pos_( *this\scroll\v, (_this_\text\caret\y - _this_\text\padding\y), ( _this_\text\padding\y * 2 + _this_\text\caret\height ) ) ; ok
        *this\change =- _bar_scroll_pos_( *this\scroll\v, (_this_\text\caret\y - _this_\text\padding\y) - _this_\y, ( _this_\text\padding\y * 2 + _this_\text\caret\height ) ) ; ok
      EndIf
    EndMacro
    
    
    
    ;- 
    Procedure.l _text_caret_( *this._s_WIDGET )
      ; Get caret position
      Protected i.l, x.l, Position.l =- 1,  
                Mousex.l, Distance.f, MinDistance.f = Infinity( )
      
      Mousex = mouse( )\x - _row_text_x_( *this )
      
      For i = 0 To *this\row\_s( )\text\len
        x = TextWidth( Left( *this\row\_s( )\text\string, i ) )
        Distance = ( Mousex - x )*( Mousex - x )
        
        If MinDistance > Distance 
          MinDistance = Distance
          Position = i
        EndIf
      Next 
      
      ProcedureReturn Position
    EndProcedure
    
    Procedure   _edit_sel_( *this._s_WIDGET, _pos_, _len_ )
      If _pos_ < 0 : _pos_ = 0 : EndIf
      If _len_ < 0 : _len_ = 0 : EndIf
      
      If _pos_ > *this\row\_s( )\text\len
        _pos_ = *this\row\_s( )\text\len
      EndIf
      
      If _len_ > *this\row\_s( )\text\len
        _len_ = *this\row\_s( )\text\len
      EndIf
      
      Protected _line_ = *this\index[#__s_1]
      Protected _caret_last_len_ = Bool( _line_ <> *this\index[#__s_2] And 
                                         ( *this\row\_s( )\index < *this\index[#__s_1] Or 
                                           *this\row\_s( )\index < *this\index[#__s_2] ) ) * *this\mode\fullselection
      
      ;     If  _caret_last_len_
      ;       _caret_last_len_ = *this\width[2]
      ;     EndIf
      
      *this\row\_s( )\text\edit[1]\len = _pos_
      *this\row\_s( )\text\edit[2]\len = _len_
      
      *this\row\_s( )\text\edit[1]\pos = 0 
      *this\row\_s( )\text\edit[2]\pos = *this\row\_s( )\text\edit[1]\len
      
      *this\row\_s( )\text\edit[3]\pos = *this\row\_s( )\text\edit[2]\pos + *this\row\_s( )\text\edit[2]\len 
      *this\row\_s( )\text\edit[3]\len = *this\row\_s( )\text\len - *this\row\_s( )\text\edit[3]\pos
      
      ; set string & size ( left;selected;right )
      If *this\row\_s( )\text\edit[1]\len > 0
        *this\row\_s( )\text\edit[1]\string = Left( *this\row\_s( )\text\string, *this\row\_s( )\text\edit[1]\len )
        *this\row\_s( )\text\edit[1]\width = TextWidth( *this\row\_s( )\text\edit[1]\string ) 
      Else
        *this\row\_s( )\text\edit[1]\string = ""
        *this\row\_s( )\text\edit[1]\width = 0
      EndIf
      If *this\row\_s( )\text\edit[2]\len > 0
        If *this\row\_s( )\text\edit[2]\len <> *this\row\_s( )\text\len
          *this\row\_s( )\text\edit[2]\string = Mid( *this\row\_s( )\text\string, 1 + *this\row\_s( )\text\edit[2]\pos, *this\row\_s( )\text\edit[2]\len )
          *this\row\_s( )\text\edit[2]\width = TextWidth( *this\row\_s( )\text\edit[2]\string ) + _caret_last_len_ 
          ;         + Bool( ( _line_ <  *this\index[2] And *this\row\_s( )\index = _line_ ) Or
          ;                                                                                                  ;( _line_ <> *this\row\_s( )\index And *this\row\_s( )\index <> *this\index[2] ) Or
          ;         ( _line_  > *this\index[2] And *this\row\_s( )\index = *this\index[2] ) ) * *this\mode\fullselection
        Else
          *this\row\_s( )\text\edit[2]\string = *this\row\_s( )\text\string
          *this\row\_s( )\text\edit[2]\width = *this\row\_s( )\text\width + _caret_last_len_
        EndIf
      Else
        *this\row\_s( )\text\edit[2]\string = ""
        *this\row\_s( )\text\edit[2]\width = _caret_last_len_
      EndIf
      
      If *this\row\_s( )\text\edit[3]\len > 0
        *this\row\_s( )\text\edit[3]\string = Right( *this\row\_s( )\text\string, *this\row\_s( )\text\edit[3]\len )
        *this\row\_s( )\text\edit[3]\width = TextWidth( *this\row\_s( )\text\edit[3]\string )  
      Else
        *this\row\_s( )\text\edit[3]\string = ""
        *this\row\_s( )\text\edit[3]\width = 0
      EndIf
      
      ; because bug in mac os
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        If *this\row\_s( )\text\edit[2]\width And Not ( _line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2] ) And
           *this\row\_s( )\text\edit[2]\width <> *this\row\_s( )\text\width - ( *this\row\_s( )\text\edit[1]\width + *this\row\_s( )\text\edit[3]\width ) + _caret_last_len_
          *this\row\_s( )\text\edit[2]\width = *this\row\_s( )\text\width - ( *this\row\_s( )\text\edit[1]\width + *this\row\_s( )\text\edit[3]\width ) + _caret_last_len_
        EndIf
      CompilerEndIf
      
      ; для красоты
      If *this\row\_s( )\text\edit[2]\width > *this\width[#__c_required]
        *this\row\_s( )\text\edit[2]\width - _caret_last_len_
      EndIf
      
      ; set position ( left;selected;right )
      *this\row\_s( )\text\edit[1]\x = *this\row\_s( )\text\x 
      *this\row\_s( )\text\edit[2]\x = ( *this\row\_s( )\text\edit[1]\x + *this\row\_s( )\text\edit[1]\width ) 
      *this\row\_s( )\text\edit[3]\x = ( *this\row\_s( )\text\edit[2]\x + *this\row\_s( )\text\edit[2]\width )
      
      ; если выделили свнизу вверх
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] >= *this\row\_s( )\index
        *this\text\edit[1]\len = ( *this\row\_s( )\text\pos + *this\row\_s( )\text\edit[2]\pos )
        *this\text\edit[2]\pos = *this\text\edit[1]\len
      EndIf
      
      ; если выделили сверху ввниз
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] <= *this\row\_s( )\index
        *this\text\edit[3]\pos = ( *this\row\_s( )\text\pos + *this\row\_s( )\text\edit[3]\pos )
        *this\text\edit[3]\len = ( *this\text\len - *this\text\edit[3]\pos )
      EndIf
      
      ; text/pos/len/state
      If _line_ = *this\row\_s( )\index
        If *this\text\edit[2]\len <> ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
          *this\text\edit[2]\len = ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
        EndIf
        
        ; set text ( left;selected;right )
        If *this\text\edit[1]\len > 0
          *this\text\edit[1]\string = Left( *this\text\string.s, *this\text\edit[1]\len ) 
        Else
          *this\text\edit[1]\string = ""
        EndIf
        If *this\text\edit[2]\len > 0
          *this\text\edit[2]\string = Mid( *this\text\string.s, 1 + *this\text\edit[2]\pos, *this\text\edit[2]\len ) 
        Else
          *this\text\edit[2]\string = ""
        EndIf
        If *this\text\edit[3]\len > 0
          *this\text\edit[3]\string = Right( *this\text\string.s, *this\text\edit[3]\len )
        Else
          *this\text\edit[3]\string = ""
        EndIf
        
        ;       ; set cursor pos
        ;       If _line_ = *this\row\_s( )\index
        *this\text\caret\y = *this\row\_s( )\text\y + Bool( #PB_Compiler_OS <> #PB_OS_Windows )
        *this\text\caret\height = *this\row\_s( )\text\height
        
        If _line_ > *this\index[#__s_2] Or
           ( _line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2] )
          *this\text\caret\x = *this\row\_s( )\text\edit[3]\x
          *this\text\caret\pos = *this\row\_s( )\text\pos + *this\row\_s( )\text\edit[3]\pos
        Else
          ;           If *this\row\_s( )\text\edit[2]\x
          *this\text\caret\x = *this\row\_s( )\text\edit[2]\x
          ;           Else
          ;             *this\text\caret\x = *this\text\padding\x
          ;           EndIf
          *this\text\caret\pos = *this\row\_s( )\text\pos + *this\row\_s( )\text\edit[2]\pos
        EndIf
        
        ;*this\text\caret\width = 1
        
        ProcedureReturn 1
        ;       EndIf
      EndIf
      
    EndProcedure
    
    Procedure   _edit_sel_set_( *this._s_WIDGET, _line_, _scroll_ ) ; Ok
                                                                    ;     Debug  "" + *this\text\caret\pos[1]  + " " +  *this\text\caret\pos[2]
                                                                    ;     ProcedureReturn 3
      Macro _edit_sel_reset_( _this_ )
        _this_\text\edit[1]\len = 0 
        _this_\text\edit[2]\len = 0 
        _this_\text\edit[3]\len = 0 
        
        _this_\text\edit[1]\pos = 0 
        _this_\text\edit[2]\pos = 0 
        _this_\text\edit[3]\pos = 0 
        
        _this_\text\edit[1]\width = 0 
        _this_\text\edit[2]\width = 0 
        _this_\text\edit[3]\width = 0 
        
        _this_\text\edit[1]\string = ""
        _this_\text\edit[2]\string = "" 
        _this_\text\edit[3]\string = ""
      EndMacro
      
      
      If _scroll_
        
        PushListPosition( *this\row\_s( ) ) 
        ForEach *this\row\_s( )
          If ( _line_ = *this\row\_s( )\index Or *this\index[#__s_2] = *this\row\_s( )\index ) Or    ; линия
             ( _line_ < *this\row\_s( )\index And *this\index[#__s_2] > *this\row\_s( )\index ) Or   ; верх
             ( _line_ > *this\row\_s( )\index And *this\index[#__s_2] < *this\row\_s( )\index )      ; вниз
            
            If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s( )\index
              If *this\text\caret\pos[1] > *this\text\caret\pos[2]
                _edit_sel_( *this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2] )
              Else
                _edit_sel_( *this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1] )
              EndIf
              
            ElseIf ( _line_ < *this\row\_s( )\index And *this\index[#__s_2] > *this\row\_s( )\index ) Or   ; верх
                   ( _line_ > *this\row\_s( )\index And *this\index[#__s_2] < *this\row\_s( )\index )      ; вниз
              
              If _line_ < 0
                ; если курсор перешел за верхный предел
                *this\index[#__s_1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                ; если курсор перешел за нижный предел
                *this\index[#__s_1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s( )\text\len
              EndIf
              
              _edit_sel_( *this, 0, *this\row\_s( )\text\len )
              
            ElseIf _line_ = *this\row\_s( )\index 
              If _line_ > *this\index[#__s_2] 
                _edit_sel_( *this, 0, *this\text\caret\pos[1] )
              Else
                _edit_sel_( *this, *this\text\caret\pos[1], *this\row\_s( )\text\len - *this\text\caret\pos[1] )
              EndIf
              
            ElseIf *this\index[#__s_2] = *this\row\_s( )\index
              
              
              If *this\count\items = 1 And 
                 ( _line_ < 0 Or _line_ > *this\count\items - 1 )
                ; если курсор перешел за пределы итемов
                *this\index[#__s_1] = 0
                
                If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                  _edit_sel_( *this, 0, *this\text\caret\pos[2] )
                Else
                  *this\text\caret\pos[1] = *this\row\_s( )\text\len
                  _edit_sel_( *this, *this\text\caret\pos[2], Bool( _line_ <> *this\index[#__s_2] ) * ( *this\row\_s( )\text\len - *this\text\caret\pos[2] ) )
                EndIf
                
                *this\index[#__s_1] = _line_
              Else
                If _line_ < 0
                  *this\index[#__s_1] = 0
                  *this\text\caret\pos[1] = 0
                ElseIf _line_ > *this\count\items - 1
                  *this\index[#__s_1] = *this\count\items - 1
                  *this\text\caret\pos[1] = *this\row\_s( )\text\len
                EndIf
                
                If *this\index[#__s_2] > _line_ 
                  _edit_sel_( *this, 0, *this\text\caret\pos[2] )
                Else
                  _edit_sel_( *this, *this\text\caret\pos[2], ( *this\row\_s( )\text\len - *this\text\caret\pos[2] ) )
                EndIf
              EndIf
              
            EndIf
            
            If *this\index[#__s_1] = *this\row\_s( )\index
              ; vertical scroll
              If _scroll_ = 1
                _text_scroll_y_( *this )
              EndIf
              
              ; horizontal scroll
              If _scroll_ =- 1
                _text_scroll_x_( *this )
              EndIf
            EndIf
            
          ElseIf ( *this\row\_s( )\text\edit[2]\width <> 0 And 
                   *this\index[#__s_2] <> *this\row\_s( )\index And _line_ <> *this\row\_s( )\index )
            
            ; reset selected string
            _edit_sel_reset_( *this\row\_s( ) )
            
          EndIf
        Next
        PopListPosition( *this\row\_s( ) ) 
        
      EndIf 
      
      ProcedureReturn _scroll_
    EndProcedure
    
    Procedure   _edit_sel_draw_( *this._s_WIDGET, _line_, _caret_ = -1 ) ; Ok
      Protected Repaint.b
      
      Macro _edit_sel_is_line_( _this_ )
        Bool( _this_\row\_s( )\text\edit[2]\width And 
              mouse( )\x > _this_\row\_s( )\text\edit[2]\x - _this_\scroll\h\bar\page\pos And
              mouse( )\y > _this_\row\_s( )\text\y - _this_\scroll\v\bar\page\pos And 
              mouse( )\y < ( _this_\row\_s( )\text\y + _this_\row\_s( )\text\height ) - _this_\scroll\v\bar\page\pos And
              mouse( )\x < ( _this_\row\_s( )\text\edit[2]\x + _this_\row\_s( )\text\edit[2]\width ) - _this_\scroll\h\bar\page\pos )
      EndMacro
      
      With *this
        ; select enter mouse item
        If _line_ >= 0 And 
           _line_ < *this\count\items And 
           _line_ <> *this\row\_s( )\index
          \row\_s( )\color\state = 0
          SelectElement( *this\row\_s( ), _line_ ) 
          \row\_s( )\color\state = 1
        EndIf
        
        If _start_draw_( *this )
          
          If _caret_ =- 1
            _caret_ = _text_caret_( *this ) 
          Else
            ; Ctrl - A
            Repaint =- 2
          EndIf
          
          ; если перемещаем выделеный текст
          If *this\row\box\state 
            If *this\index[#__s_1] <> _line_
              *this\index[#__s_1] = _line_
              Repaint = 1
            EndIf
            
            If _edit_sel_is_line_( *this )
              If *this\text\caret\pos[2] <> *this\row\_s( )\text\edit[1]\len
                *this\text\caret\pos[2] = *this\row\_s( )\text\edit[1]\len
                *this\text\caret\pos[1] = *this\row\_s( )\text\edit[1]\len + *this\row\_s( )\text\edit[2]\len
                
                If _caret_ < *this\row\_s( )\text\edit[1]\len + *this\row\_s( )\text\edit[2]\len/2
                  _caret_ = *this\row\_s( )\text\edit[1]\len
                Else
                  _caret_ = *this\row\_s( )\text\edit[1]\len + *this\row\_s( )\text\edit[2]\len
                EndIf
                
                Repaint =- 1
              EndIf
            Else
              If *this\text\caret\pos[2] <> _caret_
                *this\text\caret\pos[2] = _caret_
                *this\text\caret\pos[1] = _caret_
                Repaint =- 1
              EndIf
            EndIf
            
            If Repaint 
              ; set cursor pos
              *this\text\caret\y = *this\row\_s( )\text\y
              *this\text\caret\height = *this\row\_s( )\text\height - 1
              *this\text\caret\x = *this\row\_s( )\text\x + TextWidth( Left( *this\row\_s( )\text\string, _caret_ ) )
              _text_scroll_x_( *this )
            EndIf
            
          Else
            If *this\text\caret\pos[1] <> _caret_
              *this\text\caret\pos[1] = _caret_
              Repaint =- 1 ; scroll horizontal
            EndIf
            
            If *this\index[#__s_1] <> _line_ 
              *this\index[#__s_1] = _line_ ; scroll vertical
              Repaint = 1
            EndIf
            
            Repaint = _edit_sel_set_( *this, _line_, Repaint )
          EndIf
          
          StopDrawing( ) 
        EndIf
      EndWith
      
      ProcedureReturn Bool( Repaint )
    EndProcedure
    
    Procedure   _edit_sel_update_( *this._s_WIDGET )
      ; ProcedureReturn 
      
      ; key - ( return & backspace )
      If *this\index[#__s_2] = *this\row\_s( )\index 
        *this\row\selected = *this\row\_s( )
        
        If *this\index[#__s_2] = *this\index[#__s_1]
          If *this\text\caret\pos[1] > *this\text\caret\pos[2]
            _edit_sel_( *this, *this\text\caret\pos[2] , *this\text\caret\pos[1] - *this\text\caret\pos[2] )
          Else
            _edit_sel_( *this, *this\text\caret\pos[1] , *this\text\caret\pos[2] - *this\text\caret\pos[1] )
          EndIf
        EndIf
      EndIf
      
      ;     If *this\row\count = *this\count\items
      ;       ; move caret
      ;       If *this\index[2] + 1 = *this\row\_s( )\index 
      ;         ;         *this\index[1] = *this\row\_s( )\index 
      ;         ;         *this\index[2] = *this\index[1]
      ;         
      ;         If *this\index[2] = *this\index[1]
      ;           If *this\text\caret\pos[1]<>*this\text\caret\pos[2]
      ;             _edit_sel_( *this, 0, *this\text\caret\pos[1] - *this\row\selected\text\len )
      ;           Else
      ;             _edit_sel_( *this, *this\text\caret\pos[1] - *this\row\selected\text\len, 0 )
      ;           EndIf
      ;         EndIf
      ;         
      ;       EndIf
      ;     EndIf
      
      
      
      
      Protected  _line_ = *this\index[#__s_1]
      ;       If _line_ > 0 
      ;         SelectElement( *this\row\_s( ), _line_ )
      ;       EndIf
      
      ;; PushListPosition( *this\row\_s( ) )
      
      If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s( )\index
        If *this\text\caret\pos[1] > *this\text\caret\pos[2]
          _edit_sel_( *this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2] )
        Else
          _edit_sel_( *this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1] )
        EndIf
        
      ElseIf ( *this\index[#__s_2] > *this\row\_s( )\index And _line_ < *this\row\_s( )\index ) Or   ; верх
             ( *this\index[#__s_2] < *this\row\_s( )\index And _line_ > *this\row\_s( )\index )      ; вниз
        
        _edit_sel_( *this, 0, *this\row\_s( )\text\len )
        
      ElseIf _line_ = *this\row\_s( )\index 
        If _line_ > *this\index[#__s_2] 
          _edit_sel_( *this, 0, *this\text\caret\pos[1] )
        Else
          _edit_sel_( *this, *this\text\caret\pos[1], *this\row\_s( )\text\len - *this\text\caret\pos[1] )
        EndIf
        
      ElseIf *this\index[#__s_2] = *this\row\_s( )\index
        If *this\index[#__s_2] > _line_ 
          _edit_sel_( *this, 0, *this\text\caret\pos[2] )
        Else
          _edit_sel_( *this, *this\text\caret\pos[2], *this\row\_s( )\text\len - *this\text\caret\pos[2] )
        EndIf
        
      EndIf
      
      ;; PopListPosition( *this\row\_s( ) )
      
      
      
      
      ProcedureReturn 
      
      If ( *this\index[#__s_2] = *this\row\_s( )\index Or *this\index[#__s_1] = *this\row\_s( )\index ) Or    ; линия
         ( *this\index[#__s_2] > *this\row\_s( )\index And *this\index[#__s_1] < *this\row\_s( )\index ) Or   ; верх
         ( *this\index[#__s_2] < *this\row\_s( )\index And *this\index[#__s_1] > *this\row\_s( )\index )      ; вниз
        
        If ( *this\index[#__s_2] > *this\row\_s( )\index And *this\index[#__s_1] < *this\row\_s( )\index ) Or   ; верх
           ( *this\index[#__s_2] < *this\row\_s( )\index And *this\index[#__s_1] > *this\row\_s( )\index )      ; вниз
          
          *this\row\_s( )\text\edit[1]\len = 0 
          *this\row\_s( )\text\edit[2]\len = *this\row\_s( )\text\len
          
        ElseIf *this\index[#__s_1] = *this\row\_s( )\index 
          If *this\index[#__s_1] > *this\index[#__s_2] 
            *this\row\_s( )\text\edit[1]\len = 0 
            *this\row\_s( )\text\edit[2]\len = *this\text\caret\pos[1]
          Else
            *this\row\_s( )\text\edit[1]\len = *this\text\caret\pos[1] 
            *this\row\_s( )\text\edit[2]\len = *this\row\_s( )\text\len - *this\row\_s( )\text\edit[1]\len
          EndIf
          
        ElseIf *this\index[#__s_2] = *this\row\_s( )\index
          If *this\index[#__s_2] > *this\index[#__s_1] 
            *this\row\_s( )\text\edit[1]\len = 0 
            *this\row\_s( )\text\edit[2]\len = *this\text\caret\pos[2]
          Else
            *this\row\_s( )\text\edit[1]\len = *this\text\caret\pos[2] 
            *this\row\_s( )\text\edit[2]\len = *this\row\_s( )\text\len - *this\row\_s( )\text\edit[1]\len
          EndIf
          
        EndIf
        
        *this\row\_s( )\text\edit[1]\pos = 0 
        *this\row\_s( )\text\edit[2]\pos = *this\row\_s( )\text\edit[1]\len
        
        *this\row\_s( )\text\edit[3]\pos = *this\row\_s( )\text\edit[2]\pos + *this\row\_s( )\text\edit[2]\len 
        *this\row\_s( )\text\edit[3]\len = *this\row\_s( )\text\len - *this\row\_s( )\text\edit[3]\pos
        
        ; set string & size ( left;selected;right )
        If *this\row\_s( )\text\edit[1]\len > 0
          *this\row\_s( )\text\edit[1]\string = Left( *this\row\_s( )\text\string, *this\row\_s( )\text\edit[1]\len )
          *this\row\_s( )\text\edit[1]\width = TextWidth( *this\row\_s( )\text\edit[1]\string ) 
        Else
          *this\row\_s( )\text\edit[1]\string = ""
          *this\row\_s( )\text\edit[1]\width = 0
        EndIf
        If *this\row\_s( )\text\edit[2]\len > 0
          If *this\row\_s( )\text\edit[2]\len = *this\row\_s( )\text\len
            *this\row\_s( )\text\edit[2]\string = *this\row\_s( )\text\string
            *this\row\_s( )\text\edit[2]\width = *this\row\_s( )\text\width + *this\mode\fullselection
          Else
            *this\row\_s( )\text\edit[2]\string = Mid( *this\row\_s( )\text\string, 1 + *this\row\_s( )\text\edit[2]\pos, *this\row\_s( )\text\edit[2]\len )
            *this\row\_s( )\text\edit[2]\width = TextWidth( *this\row\_s( )\text\edit[2]\string ) + Bool( ( *this\index[#__s_1] <  *this\index[#__s_2] And *this\row\_s( )\index = *this\index[#__s_1] ) Or
                                                                                                          ; ( *this\index[1] <> *this\row\_s( )\index And *this\row\_s( )\index <> *this\index[2] ) Or
            ( *this\index[#__s_1]  > *this\index[#__s_2] And *this\row\_s( )\index = *this\index[#__s_2] ) ) * *this\mode\fullselection
          EndIf
        Else
          *this\row\_s( )\text\edit[2]\string = ""
          *this\row\_s( )\text\edit[2]\width = 0
        EndIf
        If *this\row\_s( )\text\edit[3]\len > 0
          *this\row\_s( )\text\edit[3]\string = Right( *this\row\_s( )\text\string, *this\row\_s( )\text\edit[3]\len )
          *this\row\_s( )\text\edit[3]\width = TextWidth( *this\row\_s( )\text\edit[3]\string )  
        Else
          *this\row\_s( )\text\edit[3]\string = ""
          *this\row\_s( )\text\edit[3]\width = 0
        EndIf
        
        ; set position ( left;selected;right )
        *this\row\_s( )\text\edit[1]\x = *this\row\_s( )\text\x 
        *this\row\_s( )\text\edit[2]\x = ( *this\row\_s( )\text\edit[1]\x + *this\row\_s( )\text\edit[1]\width ) 
        *this\row\_s( )\text\edit[3]\x = ( *this\row\_s( )\text\edit[2]\x + *this\row\_s( )\text\edit[2]\width )
        
        ; set cursor pos
        If *this\index[#__s_1] = *this\row\_s( )\index 
          *this\text\caret\y = *this\row\_s( )\text\y
          *this\text\caret\height = *this\row\_s( )\text\height
          
          If *this\index[#__s_1] > *this\index[#__s_2] Or
             ( *this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2] )
            *this\text\caret\x = *this\row\_s( )\text\edit[3]\x
          Else
            *this\text\caret\x = *this\row\_s( )\text\edit[2]\x
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i _edit_sel_start_( *this._s_WIDGET )
      Protected result.i, i.i, char.i
      
      Macro _edit_sel_end_( _char_ )
        Bool( ( _char_ >= ' ' And _char_ <= '/' ) Or 
              ( _char_ >= ':' And _char_ <= '@' ) Or 
              ( _char_ >= '[' And _char_ <= 96 ) Or 
              ( _char_ >= '{' And _char_ <= '~' ) )
      EndMacro
      
      With *this
        ; | <<<<<< left edge of the word 
        If \text\caret\pos[1] > 0 
          For i = \text\caret\pos[1] - 1 To 1 Step - 1
            char = Asc( Mid( \row\_s( )\text\string.s, i, 1 ) )
            If _edit_sel_end_( char )
              Break
            EndIf
          Next 
          
          result = i
        EndIf
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i _edit_sel_stop_( *this._s_WIDGET )
      Protected result.i, i.i, char.i
      
      With *this
        ; >>>>>> | right edge of the word
        For i = \text\caret\pos[1] + 2 To \row\_s( )\text\len
          char = Asc( Mid( \row\_s( )\text\string.s, i, 1 ) )
          If _edit_sel_end_( char )
            Break
          EndIf
        Next 
        
        result = i - 1
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s _text_insert_make_( *this._s_WIDGET, Text.s )
      Protected String.s, i.i, Len.i
      
      With *this
        If \text\numeric And Text.s <> #LF$
          Static Dot, Minus
          Protected Chr.s, Input.i, left.s, count.i
          
          Len = Len( Text.s ) 
          For i = 1 To Len 
            Chr = Mid( Text.s, i, 1 )
            Input = Asc( Chr )
            
            Select Input
              Case '0' To '9', '.',' - '
              Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr( Input )
              Default
                Input = 0
            EndSelect
            
            If Input
              If \type = #__type_IPAddress
                left.s = Left( \text\string, \text\caret\pos[1] )
                Select CountString( left.s, "." )
                  Case 0 : left.s = StringField( left.s, 1, "." )
                  Case 1 : left.s = StringField( left.s, 2, "." )
                  Case 2 : left.s = StringField( left.s, 3, "." )
                  Case 3 : left.s = StringField( left.s, 4, "." )
                EndSelect                                           
                count = Len( left.s + Trim( StringField( Mid( \text\string, \text\caret\pos[1]  + 1 ), 1, "." ), #LF$ ) )
                If count < 3 And ( Val( left.s ) > 25 Or Val( left.s + Chr.s ) > 255 )
                  Continue
                  ;               ElseIf Mid( \text\string, \text\caret\pos[1] + 1, 1 ) = "."
                  ;                 \text\caret\pos[1] + 1 : \text\caret\pos[2] = \text\caret\pos[1] 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid( \text\string, \text\caret\pos[1] + 1, 1 ) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid( \text\string, \text\caret\pos[1] + 1, 1 ) <> " - "
                Minus = 1
              ElseIf Input <> ' - '
                Minus = 0
              Else
                Continue
              EndIf
              
              String.s + Chr
            EndIf
          Next
          
        ElseIf \text\pass
          Len = Len( Text.s ) 
          For i = 1 To Len : String.s + "●" : Next
          
        Else
          Select #True
            Case \text\lower : String.s = LCase( Text.s )
            Case \text\upper : String.s = UCase( Text.s )
            Default
              String.s = Text.s
          EndSelect
        EndIf
      EndWith
      
      ProcedureReturn String.s
    EndProcedure
    
    Procedure.b _text_paste_( *this._s_WIDGET, Chr.s = "", Count.l = 0 )
      Protected Repaint.b
      
      With *this
        If \index[#__s_1] <> \index[#__s_2] ; Это значить строки выделени
          If \index[#__s_2] > \index[#__s_1] : Swap \index[#__s_2], \index[#__s_1] : EndIf
          
          If \row\_s( )\index <> \index[#__s_2]
            SelectElement( \row\_s( ), \index[#__s_2] )
          EndIf
          
          If Count
            \index[#__s_2] + Count
            \text\caret\pos[1] = Len( StringField( Chr.s, 1 + Count, #LF$ ) )
          ElseIf Chr.s = #LF$ ; to return
            \index[#__s_2] + 1
            \text\caret\pos[1] = 0
          Else
            \text\caret\pos[1] = \row\_s( )\text\edit[1]\len
            If Chr.s <> ""
              \text\caret\pos[1] + Len( Chr.s )
            EndIf
          EndIf
          
          ; reset items selection
          PushListPosition( *this\row\_s( ) )
          ForEach *this\row\_s( )
            If *this\row\_s( )\text\edit[2]\width <> 0 
              _edit_sel_reset_( *this\row\_s( ) )
            EndIf
          Next
          PopListPosition( *this\row\_s( ) )
          
          \text\caret\pos[2] = \text\caret\pos[1] 
          \index[#__s_1] = \index[#__s_2]
          \text\change =- 1 
          Repaint = #True
        EndIf
        
        ;       \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string + Chr.s + \row\_s( )\text\edit[3]\string
        ;       \row\_s( )\text\len = Len( \row\_s( )\text\string.s )
        
        \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure.b _text_insert_( *this._s_WIDGET, Chr.s )
      Static Dot, Minus, Color.i
      Protected result.b = -1, Input, Input_2, String.s, Count.i
      
      With *this
        Chr.s = _text_insert_make_( *this, Chr.s )
        
        If Chr.s
          Count = CountString( Chr.s, #LF$ )
          
          If Not _text_paste_( *this, Chr.s, Count )
            If \row\_s( )\text\edit[2]\len 
              If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
              \row\_s( )\text\edit[2]\len = 0 : \row\_s( )\text\edit[2]\string.s = "" : \row\_s( )\text\edit[2]\change = 1
            EndIf
            
            \row\_s( )\text\edit[1]\change = 1
            \row\_s( )\text\edit[1]\string.s + Chr.s
            \row\_s( )\text\edit[1]\len = Len( \row\_s( )\text\edit[1]\string.s )
            
            \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[3]\string.s
            \row\_s( )\text\len = \row\_s( )\text\edit[1]\len + \row\_s( )\text\edit[3]\len : \row\_s( )\text\change = 1
            
            If Count
              \index[#__s_2] + Count
              \index[#__s_1] = \index[#__s_2] 
              \text\caret\pos[1] = Len( StringField( Chr.s, 1 + Count, #LF$ ) )
            Else
              \text\caret\pos[1] + Len( Chr.s ) 
            EndIf
            
            \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
            \text\caret\pos[2] = \text\caret\pos[1] 
            ;; \count\items = CountString( \text\string.s, #LF$ )
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
          SelectElement( \row\_s( ), \index[#__s_2] ) 
          result = 1 
        EndIf
      EndWith
      
      If result =- 1
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s text_wrap_( text$, Width.i, Mode = -1, DelimList$ = " " + Chr( 9 ), nl$ = #LF$ )
      ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
      Protected line$, ret$ = "", LineRet$ = ""
      Protected.i CountString, i, start, found, length
      
      ;     text$ = ReplaceString( text$, #LFCR$, #LF$ )
      ;     text$ = ReplaceString( text$, #CRLF$, #LF$ )
      ;     text$ = ReplaceString( text$, #CR$, #LF$ )
      ;     text$ + #LF$
      ;     
      ;CountString = CountString( text$, #LF$ ) 
      Protected *str.Character = @text$
      Protected *end.Character = @text$
      
      While *end\c 
        If *end\c = #LF
          start = ( *end - *str ) >> #PB_Compiler_Unicode
          line$ = PeekS ( *str, start )
          ; Debug "" + start  + " " +  Str( ( *end - *str ) )  + " " +  Str( ( *end - *str ) / #__sOC )  + " " +  #PB_compiler_Unicode  + " " +  #__sOC
          
          ;           For i = 1 To CountString
          ;       line$ = StringField( text$, i, #LF$ )
          ;       start = Len( line$ )
          length = start
          
          ; Get text len
          While length > 1
            If width > TextWidth( RTrim( Left( line$, length ) ) )
              Break
            Else
              length - 1 
            EndIf
          Wend
          
          While start > length 
            For found = length To 1 Step - 1
              If FindString( " ", Mid( line$, found,1 ) )
                start = found
                Break
              EndIf
            Next
            
            If found = 0 
              start = length
            EndIf
            
            ; LineRet$ + Left( line$, start ) + nl$
            ret$ + Left( line$, start ) + nl$
            line$ = LTrim( Mid( line$, start + 1 ) )
            start = Len( line$ )
            
            If length <> start
              length = start
              
              ; Get text len
              While length > 1
                If width > TextWidth( RTrim( Left( line$, length ) ) )
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          Wend
          
          ret$ + line$ + nl$
          ;         ret$ +  LineRet$ + line$ + nl$
          ;         LineRet$ = ""
          *str = *end + #__sOC 
        EndIf 
        
        *end + #__sOC 
        
        ;     Next
      Wend
      
      ProcedureReturn ret$ ; ReplaceString( ret$, " ", "*" )
    EndProcedure
    
    ;-
    
    Procedure   Editor_Update( *this._s_WIDGET, List row._s_rows( ) )
      With *this
        
        If \text\string.s And *this\change > 0
          If #debug_update_text
            Debug "*this\change > 0 - " + #PB_Compiler_Procedure
          EndIf
          
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, width
          Protected ColorFont = \color\Front[Bool( *this\__state & #__ss_front ) * \color\state]
          
          ; \max 
          If *this\vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            Width = *this\height[#__c_inner] - *this\text\padding\x*2
            
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            
            width = *this\width[#__c_inner] - *this\text\padding\x*2 
          EndIf
          
          If *this\text\multiLine
            ; make multiline text
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString( text$, #LFCR$, #LF$ )
            ;     text$ = ReplaceString( text$, #CRLF$, #LF$ )
            ;     text$ = ReplaceString( text$, #CR$, #LF$ )
            ;     text$ + #LF$
            ;     
            
            If *this\text\multiLine > 0
              String = text$
            Else
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found, length
              Protected$ line$, DelimList$ = " " + Chr( 9 ), nl$ = #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; make word wrap
              While *end\c 
                If *end\c = #LF
                  start = ( *end - *str ) >> #PB_Compiler_Unicode
                  line$ = PeekS ( *str, start )
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth( RTrim( Left( line$, length ) ) )
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString( " ", Mid( line$, found,1 ) )
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left( line$, start ) + nl$
                    line$ = LTrim( Mid( line$, start + 1 ) )
                    start = Len( line$ )
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth( RTrim( Left( line$, length ) ) )
                        Break
                      Else
                        length - 1 
                      EndIf
                    Wend
                    ;EndIf
                  Wend
                  
                  String + line$ + nl$
                  *str = *end + #__sOC 
                EndIf 
                
                *end + #__sOC 
              Wend
            EndIf
            
            CountString = CountString( String, #LF$ )
          Else
            String.s = RemoveString( *this\text\string, #LF$ ) + #LF$
            CountString = 1
          EndIf
          
          If *this\count\items <> CountString
            If *this\count\items > CountString
              *this\text\change = 1
            Else
              *this\text\change = #__text_update
            EndIf
            
            *this\count\items = CountString
          EndIf
          
          If *this\change > 0
            *this\text\change = 1
          EndIf
          
          If *this\text\change
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos  = 0
            *this\text\len = Len( *this\text\string )
            
            ;             ;; editor
            ;If *this\text\change =- 10 
            ;             If *this\row\count <> *this\count\items 
            ; *this\row\count = *this\count\items
            If #debug_update_text
              Debug  " - - - - ClearList - - - - " + *this\text\change
            EndIf
            Protected padding_x2 = *this\text\padding\x*2 ;+ *this\image\width
            
            ClearList( row( ) )
            *this\width[#__c_required] = padding_x2
            *this\height[#__c_required] = *this\text\padding\y*2 
            
            ;
            While *end\c 
              If *end\c = #LF 
                AddElement( row( ) )
                row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
                row( )\text\string = PeekS ( *str, row( )\text\len )
                ;;row( )\text\width = TextWidth( row( )\text\string )
                
                ; drawing item font
                _draw_font_item_( *this, row( ), row( )\text\change )
                
                ;; editor
                row( )\index = ListIndex( row( ) )
                row( )\height = row( )\text\height
                
                ;If *this\type = #__type_editor
                ;EndIf
                
                row( )\color\back[1] = _get_colors_( )\back[1]
                row( )\color\back[2] = _get_colors_( )\back[2] : row( )\color\front[2] = _get_colors_( )\front[2]
                row( )\color\back[3] = _get_colors_( )\back[3]
                
                If \index[#__s_1] = row( )\index Or
                   \index[#__s_2] = row( )\index 
                  row( )\text\change = 1
                EndIf
                
                ; make line position
                If \vertical
                  If *this\height[#__c_required] < row( )\text\width + *this\text\padding\y * 2
                    *this\height[#__c_required] = row( )\text\width + *this\text\padding\y * 2
                  EndIf
                  
                  If \text\rotate = 270
                    row( )\x = *this\width[#__c_inner] - *this\width[#__c_required] + *this\text\padding\x                      ; + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  ElseIf \text\rotate = 90
                    row( )\x = *this\width[#__c_required]                           - *this\text\padding\x                      ; - 1 
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight + Bool( row( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                Else
                  If *this\width[#__c_required] < row( )\text\width + padding_x2
                    *this\width[#__c_required] = row( )\text\width + padding_x2
                  EndIf
                  
                  If \text\rotate = 0
                    row( )\y = *this\height[#__c_required]                            - *this\text\padding\y                     ; - 1 
                  ElseIf \text\rotate = 180
                    row( )\y = *this\height[#__c_inner] - *this\height[#__c_required] + *this\text\padding\y - row( )\text\height ; + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight + Bool( row( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                EndIf
                
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ;             Else
            ;               While *end\c 
            ;                 If *end\c = #LF 
            ;                   If SelectElement( row( ), IT )
            ;                     row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
            ;                     line$ = PeekS ( *str, row( )\text\len )
            ;                     
            ;                     If row( )\text\string.s <> line$
            ;                       row( )\text\string.s = line$
            ;                       row( )\text\change = 1
            ;                     EndIf
            ;                     
            ;                     If row( )\text\change <> 0
            ;                       row( )\text\width = TextWidth( row( )\text\string )
            ;                       ;Debug *this\count\items
            ;                       If *this\width[#__c_required] < row( )\text\width + *this\text\padding\x * 2
            ;                         *this\width[#__c_required] = row( )\text\width + *this\text\padding\x * 2
            ;                       EndIf
            ;                     EndIf
            ;                   EndIf
            ;                   
            ;                   IT + 1
            ;                   *str = *end + #__sOC 
            ;                 EndIf 
            ;                 
            ;                 *end + #__sOC 
            ;               Wend
            ;             EndIf 
            
            
            ;
            ForEach row( )
              row( )\text\pos = *this\text\pos 
              *this\text\pos + row( )\text\len + 1 ; Len( #LF$ )
              
              If *this\vertical
                If *this\text\rotate = 270
                  row( )\x - ( *this\width[#__c_inner] - *this\width[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 270
                  row( )\text\x = row( )\x + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) + 1
                ElseIf \text\rotate = 90
                  row( )\text\x = row( )\x - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                Else
                  row( )\text\x = row( )\x
                EndIf
                
                _set_align_y_( *this\text, row( )\text, *this\height[#__c_required], *this\text\rotate )
              Else
                If *this\text\rotate = 180
                  row( )\y - ( *this\height[#__c_inner] - *this\height[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 0
                  row( )\text\y = row( )\y - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                ElseIf \text\rotate = 180
                  row( )\text\y = row( )\y + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + row( )\text\height
                Else
                  row( )\text\y = row( )\y
                EndIf
                
                _set_align_x_( *this\text, row( )\text, *this\width[#__c_required], *this\text\rotate )
              EndIf
              
              ;               
              ;                         \row\_s( )\draw = Bool( Not \row\_s( )\hide And 
              ;                                     _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And 
              ;                                     _row_y_( *this ) < *this\y[#__c_inner] + *this\height[#__c_inner] )
              ; ;               If  _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And _row_y_( *this ) < *this\y[#__c_inner] + \row\_s( )\height
              ;                         If \row\_s( )\draw
              ;                           Debug \row\_s( )\index;_row_y_( *this )
              ;                EndIf
              
              If row( )\text\change <> 0
                _edit_sel_update_( *this )
                
                row( )\text\change = 0
              EndIf
            Next 
            
            
          EndIf
        EndIf
        
        If *this\text\change
          Protected update_scroll_area
          
          If *this\scroll\v And
             *this\scroll\v\bar\max <> *this\height[#__c_required] And
             Bar_SetAttribute( *this\scroll\v, #__bar_maximum, *this\height[#__c_required] )
            update_scroll_area = 1
          EndIf
          
          If *this\scroll\h And 
             *this\scroll\h\bar\max <> *this\width[#__c_required] And  
             Bar_SetAttribute( *this\scroll\h, #__bar_maximum, *this\width[#__c_required] )
            update_scroll_area = 1
          EndIf
          
          If update_scroll_area ; _bar_scrollarea_update_( *this )
            Bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
          
          ; Debug ""+*this\scroll\h\bar\page\pos +" "+ *this\scroll\h\bar\page\end
          ; *this\scroll\h\bar\page\end ) *this\scroll\h\bar\page\pos - *this\scroll\h\bar\min
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\text )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\text )
          
          ; This is for the caret and scroll 
          ; when entering the key - ( enter & backspace ) 
          If *this\scroll\v
            _text_scroll_y_( *this )
          EndIf
          
          If *this\scroll\h
            _text_scroll_x_( *this )
          EndIf
          
          ; If *this\text\change = #__text_update 
          
          ; vertical bar one before displaying
          ; vertical bar one before displaying
          If *this\scroll\v And Not *this\scroll\v\bar\thumb\change 
            If *this\scroll\v\bar\max > *this\scroll\v\bar\page\len  
              If *this\text\align\bottom
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end ) 
                  Bar_Update( *this\scroll\v )
                  Bar_Resize( *this\scroll\v )  
                EndIf
                
              ElseIf Not *this\text\align\top
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end / 2 ) 
                  Bar_Update( *this\scroll\v )
                  Bar_Resize( *this\scroll\v )  
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; horizontal bar one before displaying
          If *this\scroll\h And Not *this\scroll\h\bar\thumb\change   
            If *this\scroll\h\bar\max > *this\scroll\h\bar\page\len  
              If *this\text\align\right
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end ) 
                  Bar_Update( *this\scroll\h )
                  Bar_Resize( *this\scroll\h )  
                EndIf
                
              ElseIf Not *this\text\align\left
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end / 2 ) 
                  Bar_Update( *this\scroll\h )
                  Bar_Resize( *this\scroll\h )  
                EndIf
              EndIf
            EndIf
          EndIf
          ;Else
          
          
          ; EndIf
        EndIf
        ;           ; text frame 
        ;           *this\text\x = *this\x[#__c_required] + *this\text\padding\x
        ;           *this\text\y = *this\y[#__c_required] + *this\text\padding\y
        ;           *this\text\width = *this\width[#__c_required] - *this\text\padding\x*2
        ;           *this\text\height = *this\height[#__c_required] + *this\text\padding\y*2
        
        
      EndWith
    EndProcedure
    
    Procedure   __Editor_Update( *this._s_WIDGET, List row._s_rows( ) )
      With *this
        
        If \text\string.s And *this\change > 0
          If #debug_update_text
            Debug "*this\change > 0 - " + #PB_Compiler_Procedure
          EndIf
          
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, width
          Protected ColorFont = \color\Front[Bool( *this\__state & #__ss_front ) * \color\state]
          
          ; \max 
          If *this\vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            Width = *this\height[#__c_inner] - *this\text\padding\x*2
            
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            
            width = *this\width[#__c_inner] - *this\text\padding\x*2 
          EndIf
          
          If *this\text\multiLine
            ; make multiline text
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString( text$, #LFCR$, #LF$ )
            ;     text$ = ReplaceString( text$, #CRLF$, #LF$ )
            ;     text$ = ReplaceString( text$, #CR$, #LF$ )
            ;     text$ + #LF$
            ;     
            
            If *this\text\multiLine > 0
              String = text$
            Else
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found, length
              Protected$ line$, DelimList$ = " " + Chr( 9 ), nl$ = #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; make word wrap
              While *end\c 
                If *end\c = #LF
                  start = ( *end - *str ) >> #PB_Compiler_Unicode
                  line$ = PeekS ( *str, start )
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth( RTrim( Left( line$, length ) ) )
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString( " ", Mid( line$, found,1 ) )
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left( line$, start ) + nl$
                    line$ = LTrim( Mid( line$, start + 1 ) )
                    start = Len( line$ )
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth( RTrim( Left( line$, length ) ) )
                        Break
                      Else
                        length - 1 
                      EndIf
                    Wend
                    ;EndIf
                  Wend
                  
                  String + line$ + nl$
                  *str = *end + #__sOC 
                EndIf 
                
                *end + #__sOC 
              Wend
            EndIf
            
            CountString = CountString( String, #LF$ )
          Else
            String.s = RemoveString( *this\text\string, #LF$ ) + #LF$
            CountString = 1
          EndIf
          
          If *this\count\items <> CountString
            If *this\count\items > CountString
              *this\text\change = 1
            Else
              *this\text\change = #__text_update
            EndIf
            
            *this\count\items = CountString
          EndIf
          
          If *this\change > 0
            *this\text\change = 1
          EndIf
          
          If *this\text\change
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos  = 0
            *this\text\len = Len( *this\text\string )
            
            ;             ;; editor
            ;If *this\text\change =- 10 
            ;             If *this\row\count <> *this\count\items 
            ; *this\row\count = *this\count\items
            If #debug_update_text
              Debug  " - - - - ClearList - - - - " + *this\text\change
            EndIf
            Protected padding_x2 = *this\text\padding\x*2 ;+ *this\image\width
            
            ClearList( row( ) )
            *this\width[#__c_required] = padding_x2
            *this\height[#__c_required] = *this\text\padding\y*2 
            
            ;
            While *end\c 
              If *end\c = #LF 
                AddElement( row( ) )
                row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
                row( )\text\string = PeekS ( *str, row( )\text\len )
                ;;row( )\text\width = TextWidth( row( )\text\string )
                
                ; drawing item font
                _draw_font_item_( *this, row( ), row( )\text\change )
                
                ;; editor
                row( )\index = ListIndex( row( ) )
                row( )\height = row( )\text\height
                
                ;If *this\type = #__type_editor
                ;EndIf
                
                row( )\color\back[1] = _get_colors_( )\back[1]
                row( )\color\back[2] = _get_colors_( )\back[2] : row( )\color\front[2] = _get_colors_( )\front[2]
                row( )\color\back[3] = _get_colors_( )\back[3]
                
                If \index[#__s_1] = row( )\index Or
                   \index[#__s_2] = row( )\index 
                  row( )\text\change = 1
                EndIf
                
                ; make line position
                If \vertical
                  If *this\height[#__c_required] < row( )\text\width + *this\text\padding\y * 2
                    *this\height[#__c_required] = row( )\text\width + *this\text\padding\y * 2
                  EndIf
                  
                  If \text\rotate = 270
                    row( )\x = *this\width[#__c_inner] - *this\width[#__c_required] + *this\text\padding\x                      ; + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  ElseIf \text\rotate = 90
                    row( )\x = *this\width[#__c_required]                           - *this\text\padding\x                      ; - 1 
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight + Bool( row( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                Else
                  If *this\width[#__c_required] < row( )\text\width + padding_x2
                    *this\width[#__c_required] = row( )\text\width + padding_x2
                  EndIf
                  
                  If \text\rotate = 0
                    row( )\y = *this\height[#__c_required]                            - *this\text\padding\y                     ; - 1 
                  ElseIf \text\rotate = 180
                    row( )\y = *this\height[#__c_inner] - *this\height[#__c_required] + *this\text\padding\y - row( )\text\height ; + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight + Bool( row( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                EndIf
                
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ;             Else
            ;               While *end\c 
            ;                 If *end\c = #LF 
            ;                   If SelectElement( row( ), IT )
            ;                     row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
            ;                     line$ = PeekS ( *str, row( )\text\len )
            ;                     
            ;                     If row( )\text\string.s <> line$
            ;                       row( )\text\string.s = line$
            ;                       row( )\text\change = 1
            ;                     EndIf
            ;                     
            ;                     If row( )\text\change <> 0
            ;                       row( )\text\width = TextWidth( row( )\text\string )
            ;                       ;Debug *this\count\items
            ;                       If *this\width[#__c_required] < row( )\text\width + *this\text\padding\x * 2
            ;                         *this\width[#__c_required] = row( )\text\width + *this\text\padding\x * 2
            ;                       EndIf
            ;                     EndIf
            ;                   EndIf
            ;                   
            ;                   IT + 1
            ;                   *str = *end + #__sOC 
            ;                 EndIf 
            ;                 
            ;                 *end + #__sOC 
            ;               Wend
            ;             EndIf 
            
            
            ;
            ForEach row( )
              row( )\text\pos = *this\text\pos 
              *this\text\pos + row( )\text\len + 1 ; Len( #LF$ )
              
              If *this\vertical
                If *this\text\rotate = 270
                  row( )\x - ( *this\width[#__c_inner] - *this\width[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 270
                  row( )\text\x = row( )\x + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) + 1
                ElseIf \text\rotate = 90
                  row( )\text\x = row( )\x - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                Else
                  row( )\text\x = row( )\x
                EndIf
                
                _set_align_y_( *this\text, row( )\text, *this\height[#__c_required], *this\text\rotate )
              Else
                If *this\text\rotate = 180
                  row( )\y - ( *this\height[#__c_inner] - *this\height[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 0
                  row( )\text\y = row( )\y - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                ElseIf \text\rotate = 180
                  row( )\text\y = row( )\y + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + row( )\text\height
                Else
                  row( )\text\y = row( )\y
                EndIf
                
                _set_align_x_( *this\text, row( )\text, *this\width[#__c_required], *this\text\rotate )
              EndIf
              
              ;               
              ;                         \row\_s( )\draw = Bool( Not \row\_s( )\hide And 
              ;                                     _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And 
              ;                                     _row_y_( *this ) < *this\y[#__c_inner] + *this\height[#__c_inner] )
              ; ;               If  _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And _row_y_( *this ) < *this\y[#__c_inner] + \row\_s( )\height
              ;                         If \row\_s( )\draw
              ;                           Debug \row\_s( )\index;_row_y_( *this )
              ;                EndIf
              
              If row( )\text\change <> 0
                _edit_sel_update_( *this )
                
                row( )\text\change = 0
              EndIf
            Next 
            
            
          EndIf
        EndIf
        
        If *this\text\change
          Protected update_scroll_area
          
          If *this\scroll\v And
             *this\scroll\v\bar\max <> *this\height[#__c_required] And
             Bar_SetAttribute( *this\scroll\v, #__bar_maximum, *this\height[#__c_required] )
            update_scroll_area = 1
          EndIf
          
          If *this\scroll\h And 
             *this\scroll\h\bar\max <> *this\width[#__c_required] And  
             Bar_SetAttribute( *this\scroll\h, #__bar_maximum, *this\width[#__c_required] )
            update_scroll_area = 1
          EndIf
          
          If update_scroll_area ; _bar_scrollarea_update_( *this )
            Bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
          
          ; Debug ""+*this\scroll\h\bar\page\pos +" "+ *this\scroll\h\bar\page\end
          ; *this\scroll\h\bar\page\end ) *this\scroll\h\bar\page\pos - *this\scroll\h\bar\min
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\text )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\text )
          
          
          If *this\text\change = #__text_update 
            
            ; vertical bar one before displaying
            If *this\scroll\v 
              If *this\text\align\bottom
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end ) 
                  Bar_Update( *this\scroll\v )
                  Bar_Resize( *this\scroll\v )  
                EndIf
                
              ElseIf Not *this\text\align\top
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end / 2 ) 
                  Bar_Update( *this\scroll\v )
                  Bar_Resize( *this\scroll\v )  
                EndIf
              EndIf
            EndIf
            
            ; horizontal bar one before displaying
            If *this\scroll\h  
              If *this\text\align\right
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end ) 
                  Bar_Update( *this\scroll\h )
                  Bar_Resize( *this\scroll\h )  
                EndIf
                
              ElseIf Not *this\text\align\left
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end / 2 ) 
                  Bar_Update( *this\scroll\h )
                  Bar_Resize( *this\scroll\h )  
                EndIf
              EndIf
            EndIf
          Else
            
            ; This is for the caret and scroll 
            ; when entering the key - ( enter & backspace ) 
            If *this\scroll\v
              _text_scroll_y_( *this )
            EndIf
            
            If *this\scroll\h
              _text_scroll_x_( *this )
            EndIf
            
          EndIf
        EndIf
        ;           ; text frame 
        ;           *this\text\x = *this\x[#__c_required] + *this\text\padding\x
        ;           *this\text\y = *this\y[#__c_required] + *this\text\padding\y
        ;           *this\text\width = *this\width[#__c_required] - *this\text\padding\x*2
        ;           *this\text\height = *this\height[#__c_required] + *this\text\padding\y*2
        
        
      EndWith
    EndProcedure
    
    Procedure   _Editor_Update( *this._s_WIDGET, List row._s_rows( ) )
      With *this
        
        If \text\string.s
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, Width,Height
          Protected ColorFont = \color\Front[Bool( *this\__state & #__ss_front ) * \color\state]
          
          If \vertical
            Width = \height[#__c_inner] - \text\x*2
            Height = \width[#__c_inner] - \text\y*2
          Else
            Width = \width[#__c_inner] - \text\x*2 
            Height = \height[#__c_inner] - \text\y*2
          EndIf
          
          ; make multiline text
          If \text\multiLine
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString( text$, #LFCR$, #LF$ )
            ;     text$ = ReplaceString( text$, #CRLF$, #LF$ )
            ;     text$ = ReplaceString( text$, #CR$, #LF$ )
            ;     text$ + #LF$
            ;     
            
            If \text\multiLine < 0
              String = text$
            Else
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found, length
              Protected$ line$, DelimList$ = " " + Chr( 9 ), nl$ = #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; make word wrap
              While *end\c 
                If *end\c = #LF
                  start = ( *end - *str ) >> #PB_Compiler_Unicode
                  line$ = PeekS ( *str, start )
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth( RTrim( Left( line$, length ) ) )
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString( " ", Mid( line$, found,1 ) )
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left( line$, start ) + nl$
                    line$ = LTrim( Mid( line$, start + 1 ) )
                    start = Len( line$ )
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth( RTrim( Left( line$, length ) ) )
                        Break
                      Else
                        length - 1 
                      EndIf
                    Wend
                    ;EndIf
                  Wend
                  
                  String + line$ + nl$
                  *str = *end + #__sOC 
                EndIf 
                
                *end + #__sOC 
              Wend
            EndIf
            
            CountString = CountString( String, #LF$ )
          Else
            String.s = RemoveString( *this\text\string, #LF$ ) + #LF$
            CountString = 1
          EndIf
          
          ; \max 
          If \vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #True
            EndIf
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #True
            EndIf
          EndIf
          
          ; 
          If *this\count\items <> CountString
            *this\count\items = CountString
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            Debug "*this\text\change - " + #PB_Compiler_Procedure
            
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos  = 0
            *this\text\len = Len( *this\text\string )
            
            ;             ;; editor
            ;             If *this\row\count <> *this\count\items 
            *this\row\count = *this\count\items
            Debug  " - - - - ClearList - - - - "
            
            ClearList( row( ) )
            *this\width[#__c_required] = *this\text\padding\x*2 
            *this\height[#__c_required] = *this\text\padding\y*2 
            
            ;
            While *end\c 
              If *end\c = #LF 
                AddElement( row( ) )
                row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
                row( )\text\string = PeekS ( *str, row( )\text\len )
                ;;row( )\text\width = TextWidth( row( )\text\string )
                
                ; drawing item font
                _draw_font_item_( *this, row( ), row( )\text\change )
                
                ;; editor
                row( )\index = ListIndex( row( ) )
                row( )\height = row( )\text\height
                row( )\color\back[1] = _get_colors_( )\back[1]
                row( )\color\back[2] = _get_colors_( )\back[2]
                row( )\color\back[3] = _get_colors_( )\back[3]
                row( )\color\front[2] = _get_colors_( )\front[2]
                
                If \index[#__s_1] = row( )\index Or
                   \index[#__s_2] = row( )\index 
                  row( )\text\change = 1
                EndIf
                
                ; make line position
                If \vertical
                  If *this\height[#__c_required] < row( )\text\width + *this\text\padding\y * 2
                    *this\height[#__c_required] = row( )\text\width + *this\text\padding\y * 2
                  EndIf
                  
                  If \text\rotate = 270
                    row( )\x = *this\width[#__c_inner] - *this\width[#__c_required] + *this\text\padding\x + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  ElseIf \text\rotate = 90
                    row( )\x = *this\width[#__c_required]                           - *this\text\padding\x - 1 
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight
                Else
                  If *this\width[#__c_required] < row( )\text\width + *this\text\padding\x * 2
                    *this\width[#__c_required] = row( )\text\width + *this\text\padding\x * 2
                  EndIf
                  
                  If \text\rotate = 0
                    row( )\y = *this\height[#__c_required]                            - *this\text\padding\y - 1 
                  ElseIf \text\rotate = 180
                    row( )\y = *this\height[#__c_inner] - *this\height[#__c_required] + *this\text\padding\y + Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight
                EndIf
                
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ;             Else
            ;               While *end\c 
            ;                 If *end\c = #LF 
            ;                   If SelectElement( row( ), IT )
            ;                     row( )\text\len = ( *end - *str )>>#PB_Compiler_Unicode
            ;                     line$ = PeekS ( *str, row( )\text\len )
            ;                     
            ;                     If row( )\text\string.s <> line$
            ;                       row( )\text\string.s = line$
            ;                       row( )\text\change = 1
            ;                     EndIf
            ;                     
            ;                     If row( )\text\change <> 0
            ;                       row( )\text\width = TextWidth( row( )\text\string )
            ;                       ;Debug *this\count\items
            ;                       If *this\width[#__c_required] < row( )\text\width + *this\text\padding\x * 2
            ;                         *this\width[#__c_required] = row( )\text\width + *this\text\padding\x * 2
            ;                       EndIf
            ;                     EndIf
            ;                   EndIf
            ;                   
            ;                   IT + 1
            ;                   *str = *end + #__sOC 
            ;                 EndIf 
            ;                 
            ;                 *end + #__sOC 
            ;               Wend
            ;             EndIf 
            
            ;
            ForEach row( )
              row( )\text\pos = *this\text\pos 
              *this\text\pos + row( )\text\len + 1 ; Len( #LF$ )
              
              If *this\vertical
                If *this\text\rotate = 270
                  row( )\x - ( *this\width[#__c_inner] - *this\width[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 270
                  row( )\text\x = row( )\x + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) + 1
                ElseIf \text\rotate = 90
                  row( )\text\x = row( )\x - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                Else
                  row( )\text\x = row( )\x
                EndIf
                
                _set_align_y_( *this\text, row( )\text, *this\height[#__c_required], *this\text\rotate )
              Else
                If *this\text\rotate = 180
                  row( )\y - ( *this\height[#__c_inner] - *this\height[#__c_required] )
                EndIf
                
                ; changed
                If \text\rotate = 0
                  row( )\text\y = row( )\y - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) - 1 
                ElseIf \text\rotate = 180
                  row( )\text\y = row( )\y + Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + row( )\text\height
                Else
                  row( )\text\y = row( )\y
                EndIf
                
                _set_align_x_( *this\text, row( )\text, *this\width[#__c_required], *this\text\rotate )
              EndIf
              
              ;               
              ;                         \row\_s( )\draw = Bool( Not \row\_s( )\hide And 
              ;                                     _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And 
              ;                                     _row_y_( *this ) < *this\y[#__c_inner] + *this\height[#__c_inner] )
              ; ;               If  _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And _row_y_( *this ) < *this\y[#__c_inner] + \row\_s( )\height
              ;                         If \row\_s( )\draw
              ;                           Debug \row\_s( )\index;_row_y_( *this )
              ;                EndIf
              
              If row( )\text\change <> 0
                _edit_sel_update_( *this )
                
                row( )\text\change = 0
              EndIf
            Next 
          EndIf
          
          
        EndIf
        
        Protected update_scroll_area
        
        If *this\scroll\v And
           *this\scroll\v\bar\max <> *this\height[#__c_required] And
           Bar_SetAttribute( *this\scroll\v, #__bar_maximum, *this\height[#__c_required] )
          update_scroll_area = 1
        EndIf
        
        If *this\scroll\h And 
           *this\scroll\h\bar\max <> *this\width[#__c_required] And  
           Bar_SetAttribute( *this\scroll\h, #__bar_maximum, *this\width[#__c_required] )
          update_scroll_area = 1
        EndIf
        
        If update_scroll_area ; _bar_scrollarea_update_( *this )
          Bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          \height[#__c_inner] = \scroll\v\bar\page\len
          \width[#__c_inner] = \scroll\h\bar\page\len 
        EndIf
        
        ; make vertical scroll y
        make_scrollarea_y( *this, *this\text )
        
        ; make horizontal scroll x
        make_scrollarea_x( *this, *this\text )
        
        
        
        If *this\scroll\v
          ; This is for the caret and scroll when entering the key - ( enter & backspace ) 
          _text_scroll_y_( *this )
          
          ; fist show 
          If Not *this\scroll\v\bar\thumb\change
            If *this\text\align\bottom
              If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end ) 
                Bar_Update( *this\scroll\v )
                Bar_Resize( *this\scroll\v )  
              EndIf
              
            ElseIf Not *this\text\align\top
              If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end / 2 ) 
                Bar_Update( *this\scroll\v )
                Bar_Resize( *this\scroll\v )  
              EndIf
            EndIf
          EndIf
        EndIf
        
        
        If *this\scroll\h
          ; This is for the caret and scroll when entering the key - ( enter & backspace ) 
          _text_scroll_x_( *this )
          
          ; first show
          If Not *this\scroll\h\bar\thumb\change
            If *this\text\align\right
              If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end ) 
                Bar_Update( *this\scroll\h )
                Bar_Resize( *this\scroll\h )  
              EndIf
              
            ElseIf Not *this\text\align\left
              If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end / 2 ) 
                Bar_Update( *this\scroll\h )
                Bar_Resize( *this\scroll\h )  
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;           ; text frame 
        ;           *this\text\x = *this\x[#__c_required] + *this\text\padding\x
        ;           *this\text\y = *this\y[#__c_required] + *this\text\padding\y
        ;           *this\text\width = *this\width[#__c_required] - *this\text\padding\x*2
        ;           *this\text\height = *this\height[#__c_required] + *this\text\padding\y*2
        
        
      EndWith
    EndProcedure
    
    Procedure   Editor_Draw( *this._s_WIDGET )
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT,Text_Y,Text_x, x,Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Make output multi line text
          If *this\change > 0 ;<> 0
            Editor_Update( *this, *this\row\_s( ) )
          EndIf
          
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           DrawingMode( #PB_2DDrawing_Gradient )
          ;           _draw_gradient_( \vertical, *this,\color\fore[\color\state],\color\back[\color\state], [#__c_frame] )
          ;         Else
          DrawingMode( #PB_2DDrawing_Default )
          RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back[\color\state] )
          ;         EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If ( \text\change Or \resize )
              \row\margin\x = \x[#__c_inner]
              \row\margin\y = \y[#__c_inner]
              \row\margin\height = \height[#__c_inner]
            EndIf
            
            ; Draw margin
            DrawingMode( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
            Box( \row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back )
          EndIf
          
          ; widget inner coordinate
          ix = \x[#__c_inner] + \row\margin\width 
          iY = \y[#__c_inner]
          iwidth = \width[#__c_inner]
          iheight = \height[#__c_inner]
          
          ; Draw Lines text
          If \count\items
            PushListPosition( \row\_s( ) )
            ForEach \row\_s( )
              ;               ; Is visible lines - -  - 
              ;               \row\_s( )\draw = Bool( Not \row\_s( )\hide And 
              ;                                     \row\_s( )\y + \row\_s( )\height + *this\y[#__c_required] > *this\y[#__c_inner] And 
              ;                                     ( \row\_s( )\y - *this\y[#__c_inner] ) + *this\y[#__c_required]<*this\height[#__c_inner] )
              
              \row\_s( )\draw = Bool( Not \row\_s( )\hide And 
                                      _row_y_( *this ) > *this\y[#__c_inner] - \row\_s( )\height And 
                                      _row_y_( *this ) < *this\y[#__c_inner] + *this\height[#__c_inner] )
              
              ; Draw selections
              If *this\row\_s( )\draw 
                Y = _row_y_( *this )
                Text_x = _row_text_x_( *this )
                Text_Y = _row_text_y_( *this )
                
                Protected sel_text_x1 = _row_text_edit_x_( *this, [1] )
                Protected sel_text_x2 = _row_text_edit_x_( *this, [2] )
                Protected sel_text_x3 = _row_text_edit_x_( *this, [3] )
                
                Protected sel_x = \x[#__c_inner] + *this\text\y
                Protected sel_width = \width[#__c_inner] - *this\text\y*2
                
                Protected text_sel_state = 2 + Bool( Not _is_focused_( *this ) )
                Protected text_sel_width = \row\_s( )\text\edit[2]\width + Bool( Not _is_focused_( *this ) ) * *this\text\caret\width
                Protected text_state = *this\row\_s( )\color\state
                
                text_state = Bool( *this\row\_s( )\index = *this\index[#__s_1] ) + Bool( *this\row\_s( )\index = *this\index[#__s_1] And Not _is_focused_( *this ) )*2
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный 
                  ; фон отличный от заднего фона едитора
                  If *this\row\_s( )\color\Back  
                    DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                    RoundBox( sel_x,Y,sel_width ,*this\row\_s( )\height, *this\row\_s( )\round,*this\row\_s( )\round, *this\row\_s( )\color\back[0] )
                    
                    If *this\color\Back And 
                       *this\color\Back <> *this\row\_s( )\color\Back
                      ; Draw margin back color
                      If *this\row\margin\width > 0
                        ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                        DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                        Box( *this\row\margin\x, *this\row\_s( )\y, *this\row\margin\width, *this\row\_s( )\height, *this\row\margin\color\back )
                        Line( *this\x[#__c_inner] + *this\row\margin\width, *this\row\_s( )\y, 1, *this\row\_s( )\height, *this\color\Back ) ; $FF000000 );
                      EndIf
                    EndIf
                  EndIf
                  
                  ; Draw entered selection
                  If text_state ; *this\row\_s( )\index = *this\index[1] ; \color\state;
                    If *this\row\_s( )\color\back[text_state] <>- 1              ; no draw transparent
                      DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                      RoundBox( sel_x,Y,sel_width ,*this\row\_s( )\height, *this\row\_s( )\round,*this\row\_s( )\round, *this\row\_s( )\color\back[text_state] )
                    EndIf
                    
                    If *this\row\_s( )\color\frame[text_state] <>- 1 ; no draw transparent
                      DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
                      RoundBox( sel_x,Y,sel_width ,*this\row\_s( )\height, *this\row\_s( )\round,*this\row\_s( )\round, *this\row\_s( )\color\frame[text_state] )
                    EndIf
                  EndIf
                EndIf
                
                ; Draw text
                ; Draw string
                If *this\text\editable And 
                   *this\row\_s( )\text\edit[2]\width And 
                   *this\row\_s( )\color\front[2] <> *this\color\front
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    If \row\_s( )\text\string.s
                      DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
                      DrawRotatedText( Text_x, Text_Y, \row\_s( )\text\string.s, *this\text\rotate, *this\row\_s( )\color\front[*this\row\_s( )\color\state] )
                    EndIf
                    
                    If \row\_s( )\text\edit[2]\width
                      DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                      Box( sel_text_x2, Y, text_sel_width, \row\_s( )\height, *this\row\_s( )\color\back[text_sel_state] )
                    EndIf
                    
                    DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
                    
                    ; to right select
                    If ( *this\index[#__s_1] > *this\index[#__s_2] Or 
                         ( *this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2] ) )
                      
                      If \row\_s( )\text\edit[2]\string.s
                        DrawRotatedText( sel_text_x2, Text_Y, \row\_s( )\text\edit[2]\string.s, *this\text\rotate, *this\row\_s( )\color\front[text_sel_state] )
                      EndIf
                      
                      ; to left select
                    Else
                      If \row\_s( )\text\edit[2]\string.s
                        DrawRotatedText( Text_x, Text_Y, \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[2]\string.s, *this\text\rotate, *this\row\_s( )\color\front[text_sel_state] )
                      EndIf
                      
                      If \row\_s( )\text\edit[1]\string.s
                        DrawRotatedText( Text_x, Text_Y, \row\_s( )\text\edit[1]\string.s, *this\text\rotate, *this\row\_s( )\color\front[*this\row\_s( )\color\state] )
                      EndIf
                    EndIf
                    
                  CompilerElse
                    If \row\_s( )\text\edit[2]\width
                      DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                      Box( sel_text_x2, Y, text_sel_width, \row\_s( )\height, *this\row\_s( )\color\back[text_sel_state] )
                    EndIf
                    
                    DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
                    
                    If \row\_s( )\text\edit[1]\string.s
                      DrawRotatedText( sel_text_x1, Text_Y, \row\_s( )\text\edit[1]\string.s, *this\text\rotate, *this\row\_s( )\color\front[*this\row\_s( )\color\state] )
                    EndIf
                    If \row\_s( )\text\edit[2]\string.s
                      DrawRotatedText( sel_text_x2, Text_Y, \row\_s( )\text\edit[2]\string.s, *this\text\rotate, *this\row\_s( )\color\front[text_sel_state] )
                    EndIf
                    If \row\_s( )\text\edit[3]\string.s
                      DrawRotatedText( sel_text_x3, Text_Y, \row\_s( )\text\edit[3]\string.s, *this\text\rotate, *this\row\_s( )\color\front[*this\row\_s( )\color\state] )
                    EndIf
                  CompilerEndIf
                  
                Else
                  If *this\row\_s( )\text\edit[2]\width
                    DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                    Box( sel_text_x2, Y, text_sel_width, *this\row\_s( )\height, $FFFBD9B7 );*this\row\_s( )\color\back[2] )
                  EndIf
                  
                  If *this\color\state = 2
                    DrawingMode( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, *this\row\_s( )\text\string.s, *this\text\rotate, *this\row\_s( )\color\front[text_sel_state] )
                  Else
                    DrawingMode( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, *this\row\_s( )\text\string.s, *this\text\rotate, *this\row\_s( )\color\front[*this\row\_s( )\color\state] )
                  EndIf
                EndIf
                
                ; Draw margin text
                If *this\row\margin\width > 0
                  DrawingMode( #PB_2DDrawing_Transparent )
                  DrawRotatedText( *this\row\_s( )\margin\x + Bool( *this\vertical ) * *this\x[#__c_required],
                                   *this\row\_s( )\margin\y + Bool( Not *this\vertical ) * *this\y[#__c_required], 
                                   *this\row\_s( )\margin\string, *this\text\rotate, *this\row\margin\color\front )
                EndIf
                
                ; Horizontal line
                If *this\mode\GridLines And
                   *this\row\_s( )\color\line And 
                   *this\row\_s( )\color\line <> *this\row\_s( )\color\back 
                  DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                  Box( *this\row\_s( )\x, ( *this\row\_s( )\y + *this\row\_s( )\height + Bool( *this\mode\gridlines>1 ) ) + *this\y[#__c_required], *this\row\_s( )\width, 1, *this\color\line )
                EndIf
              EndIf
            Next
            PopListPosition( *this\row\_s( ) ) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And _is_focused_( *this )
            DrawingMode( #PB_2DDrawing_XOr )             
            Box( *this\x[#__c_inner] + *this\text\caret\x + *this\x[#__c_required], *this\y[#__c_inner] + *this\text\caret\y + *this\y[#__c_required], *this\text\caret\width, *this\text\caret\height, $FFFFFFFF )
          EndIf
          
          ; Draw frames
          If *this\notify
            DrawingMode( #PB_2DDrawing_Outlined )
            RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round, $FF0000FF )
            If \round : RoundBox( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round, $FF0000FF ) : EndIf  ; Сглаживание краев ) ) )
          ElseIf *this\bs
            DrawingMode( #PB_2DDrawing_Outlined )
            RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\frame[\color\state] )
            If \round : RoundBox( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round,\color\front[\color\state] ) : EndIf  ; Сглаживание краев ) ) )
          EndIf
          
          ; Draw scroll bars
          Area_Draw( *this )
          
          If *this\text\change : *this\text\change = 0 : EndIf
          If *this\change : *this\change = 0 : EndIf
          If *this\resize : *this\resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure   Editor_SetItemState( *this._s_WIDGET, Item.l, State.i )
      Protected result
      
      With *this
        If state < 0 Or 
           state > *this\text\len
          state = *this\text\len
        EndIf
        
        ;       If *this\text\caret\pos <> State
        ;         *this\text\caret\pos = State
        If *this\text\caret\pos <> State
          Protected i.l, len.l
          Protected *str.Character = @\text\string 
          Protected *end.Character = @\text\string 
          
          While *end\c 
            If *end\c = #LF 
              i + 1
              len + ( *end - *str )/#__sOC
              ; Debug "" + Item + " " + Str( len + Item )  + " " +  state
              
              If i = Item 
                *this\index[#__s_1] = Item
                *this\index[#__s_2] = Item
                
                *this\text\caret\pos = state + len + Item
                *this\text\caret\pos[1] = state
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__s_1] <> Item 
            *this\index[#__s_1] = Item
            *this\index[#__s_2] = Item
            
            *this\text\caret\pos = state + len + Item
            *this\text\caret\pos[1] = state
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          
        EndIf
        
        ; ;       PushListPosition( \row\_s( ) )
        ; ;       result = SelectElement( \row\_s( ), Item ) 
        ; ;       
        ; ;       If result 
        ; ;         \index[1] = \row\_s( )\index
        ; ;         \index[2] = \row\_s( )\index
        ; ;         \row\index = \row\_s( )\index
        ; ;        ; \text\caret\pos[1] = State
        ; ;        ; \text\caret\pos[2] = \text\caret\pos[1] 
        ; ;       EndIf
        ; ;       PopListPosition( \row\_s( ) )
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Editor_AddItem( *this._s_WIDGET, Item.l,Text.s,Image.i = -1,Flag.i = 0 )
      Static len.l, Widget
      Protected l.l, i.l
      
      If Widget <> *this 
        Widget = *this 
        len = 0
      EndIf
      
      If *this
        With *this  
          Protected String.s = \text\string + #LF$
          
          If Item > \count\items - 1
            Item = \count\items - 1
          EndIf
          
          If ( Item > 0 And Item < \count\items - 1 )
            Define *str.Character = @string 
            Define *end.Character = @string 
            len = 0
            
            While *end\c 
              If *end\c = #LF 
                
                If item = i 
                  len + Item
                  Break 
                Else
                  ;Debug "" +  PeekS ( *str, ( *end - *str )/#__sOC )  + " " +  Str( ( *end - *str )/#__sOC )
                  len + ( *end - *str )/#__sOC
                EndIf
                
                i + 1
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
          EndIf
          
          \text\string = Trim( InsertString( String, Text.s + #LF$, len + 1 ), #LF$ )
          
          l = Len( Text.s ) + 1
          \text\change = 1
          \text\len + l 
          Len + l
          
          ;_post_repaint_items_( *this )
          \count\items + 1
          
        EndWith
      EndIf
      
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure   Editor_Events_Key( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      Static _caret_last_pos_, DoubleClick.i
      Protected Repaint.i, _key_control_.i, _key_shift_.i, Caret.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\row\_s( )\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
      
      With *this
        _key_shift_ = Bool( keyboard( )\key[1] & #PB_Canvas_Shift )
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          _key_control_ = Bool( ( keyboard( )\key[1] & #PB_Canvas_Control ) Or ( keyboard( )\key[1] & #PB_Canvas_Command ) ) * #PB_Canvas_Control
        CompilerElse
          _key_control_ = Bool( keyboard( )\key[1] & #PB_Canvas_Control ) * #PB_Canvas_Control
        CompilerEndIf
        
        Select EventType
          Case #__event_Input ; - Input ( key )
            If Not _key_control_   ; And Not _key_shift_
              If Not *this\notify And keyboard( )\input
                
                Repaint = _text_insert_( *this, Chr( keyboard( )\input ) )
                
              EndIf
            EndIf
            
          Case #__event_KeyUp
            ; Чтобы перерисовать 
            ; рамку вокруг едитора 
            ; reset all errors
            If \notify 
              \notify = 0
              ProcedureReturn - 1
            EndIf
            
          Case #__event_KeyDown
            Select keyboard( )\key
              Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
                If _key_control_ : *this\index[#__s_2] = 0 : EndIf
                Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )
                
              Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
                If _key_control_ : *this\index[#__s_2] = *this\count\items - 1 : EndIf
                Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )
                
              Case #PB_Shortcut_PageUp   ;: Repaint = ToPos( *this, 1, 1 )
                
              Case #PB_Shortcut_PageDown ;: Repaint = ToPos( *this, - 1, 1 )
                
              Case #PB_Shortcut_A        ; Ok
                If _key_control_ And
                   \text\edit[2]\len <> \text\len
                  
                  ; set caret to begin
                  \text\caret\pos[2] = 0 
                  \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                  
                  ; select first item
                  \index[#__s_2] = 0 
                  \index[#__s_1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                  
                  Repaint = _edit_sel_draw_( *this, \count\items - 1, \text\len )
                EndIf
                
              Case #PB_Shortcut_Up       ; Ok
                If *this\index[#__s_1] > _line_first_
                  If _caret_last_pos_
                    If Not keyboard( )\key[1] & #PB_Canvas_Alt 
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                      Repaint = _edit_sel_draw_( *this, 0, 0 )  
                    Else
                      Repaint = _edit_sel_draw_( *this, *this\index[#__s_1] - _step_, *this\text\caret\pos[1] )  
                    EndIf
                  ElseIf keyboard( )\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_min_ 
                      *this\text\caret\pos[2] = _caret_min_
                    Else
                      *this\index[#__s_2] - _step_ 
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = 0
                      *this\text\caret\pos[2] = 0
                    Else
                      *this\index[#__s_2] - _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )
                  EndIf
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_( *this, _line_first_, *this\text\caret\pos[2] )  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                If *this\index[#__s_1] < _line_last_
                  If _caret_last_pos_
                    If Not keyboard( )\key[1] & #PB_Canvas_Alt And Not _key_control_
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                      Repaint = _edit_sel_draw_( *this, \count\items - 1, *this\text\len )  
                    Else
                      Repaint = _edit_sel_draw_( *this, *this\index[#__s_1] + _step_, *this\text\caret\pos[1] )  
                    EndIf
                  ElseIf keyboard( )\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_max_ 
                      *this\text\caret\pos[2] = _caret_max_
                    Else
                      *this\index[#__s_2] + _step_ 
                      
                      If SelectElement( *this\row\_s( ), *this\index[#__s_2] ) 
                        _caret_max_ = *this\row\_s( )\text\len
                        
                        If *this\text\caret\pos[1] <> _caret_max_
                          *this\text\caret\pos[2] = _caret_max_
                          
                          Debug "" + #PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = \count\items - 1
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      *this\index[#__s_2] + _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                  EndIf
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\row\_s( )\index <> _line_last_ And
                     SelectElement( *this\row\_s( ), _line_last_ ) 
                    _caret_max_ = *this\row\_s( )\text\len
                    Debug "" + #PB_Compiler_Procedure + "*this\row\_s( )\index <> _line_last_"
                  EndIf
                  
                  If *this\text\caret\pos[1] <> _caret_max_ : *this\text\caret\pos[2] = _caret_max_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_( *this, _line_last_, *this\text\caret\pos[2] )  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Left     ; Ok
                If _key_shift_        
                  If _key_control_
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], 0 )  
                  Else
                    _line_ = *this\index[#__s_1] - Bool( *this\index[#__s_1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_ ) * _step_
                    
                    ; коректируем позицию коректора
                    If *this\row\_s( )\index <> _line_ And
                       SelectElement( *this\row\_s( ), _line_ ) 
                    EndIf
                    If *this\text\caret\pos[1] > *this\row\_s( )\text\len
                      *this\text\caret\pos[1] = *this\row\_s( )\text\len
                    EndIf
                    
                    If *this\index[#__s_1] <> _line_
                      Repaint = _edit_sel_draw_( *this, _line_, *this\row\_s( )\text\len )  
                    ElseIf *this\text\caret\pos[1] > _caret_min_
                      Repaint = _edit_sel_draw_( *this, _line_, *this\text\caret\pos[1] - _step_ )  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] > _line_first_
                  If keyboard( )\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_start_( *this )
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = 0
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] - _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] - _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_min_
                        *this\index[#__s_2] - _step_
                        
                        If SelectElement( *this\row\_s( ), *this\index[#__s_2] ) 
                          *this\text\caret\pos[1] = *this\row\_s( )\text\len
                          *this\text\caret\pos[2] = *this\row\_s( )\text\len
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] > _caret_min_ 
                    *this\text\caret\pos[2] - _step_
                    Repaint = _edit_sel_draw_( *this, _line_first_, *this\text\caret\pos[2] )  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Right    ; Ok
                If _key_shift_       
                  If _key_control_
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\len )  
                  Else
                    If *this\row\_s( )\index <> *this\index[#__s_1] And
                       SelectElement( *this\row\_s( ), *this\index[#__s_1] ) 
                      _caret_max_ = *this\row\_s( )\text\len
                    EndIf
                    
                    If *this\text\caret\pos[1] > _caret_max_
                      *this\text\caret\pos[1] = _caret_max_
                    EndIf
                    
                    _line_ = *this\index[#__s_1] + Bool( *this\index[#__s_1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_ ) * _step_
                    
                    ; если дошли в конец строки,
                    ; то переходим в начало
                    If *this\index[#__s_1] <> _line_ 
                      Repaint = _edit_sel_draw_( *this, _line_, 0 )  
                    ElseIf *this\text\caret\pos[1] < _caret_max_
                      Repaint = _edit_sel_draw_( *this, _line_, *this\text\caret\pos[1] + _step_ )  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] < _line_last_
                  If keyboard( )\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_stop_( *this )
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] + _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] + _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_max_
                        *this\index[#__s_2] + _step_
                        
                        If SelectElement( *this\row\_s( ), *this\index[#__s_2] ) 
                          *this\text\caret\pos[1] = 0
                          *this\text\caret\pos[2] = 0
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], *this\text\caret\pos[2] )  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\text\caret\pos[1] < _caret_max_ 
                    *this\text\caret\pos[2] + _step_
                    
                    
                    Repaint = _edit_sel_draw_( *this, _line_last_, *this\text\caret\pos[2] )  
                  EndIf
                  
                EndIf
                
                ;- backup  
              Case #PB_Shortcut_Back   
                If Not \notify
                  If Not _text_paste_( *this )
                    If \row\_s( )\text\edit[2]\len
                      
                      If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
                      \row\_s( )\text\edit[2]\len = 0 : \row\_s( )\text\edit[2]\string.s = "" : \row\_s( )\text\edit[2]\change = 1
                      
                      \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[3]\string.s
                      \row\_s( )\text\len = \row\_s( )\text\edit[1]\len + \row\_s( )\text\edit[3]\len : \row\_s( )\text\change = 1
                      
                      \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                      
                    ElseIf \text\caret\pos[2] > 0 : \text\caret\pos[1] - 1 
                      \row\_s( )\text\edit[1]\string.s = Left( \row\_s( )\text\string.s, \text\caret\pos[1] )
                      \row\_s( )\text\edit[1]\len = Len( \row\_s( )\text\edit[1]\string.s ) : \row\_s( )\text\edit[1]\change = 1
                      
                      \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[3]\string.s
                      \row\_s( )\text\len = \row\_s( )\text\edit[1]\len + \row\_s( )\text\edit[3]\len : \row\_s( )\text\change = 1
                      
                      \text\string.s = Left( \text\string.s, \row\_s( )\text\pos + \text\caret\pos[1] ) + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                      
                    Else
                      ; Если дошли до начала строки то 
                      ; переходим в конец предыдущего итема
                      If \index[#__s_1] > _line_first_ 
                        \text\string.s = RemoveString( \text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s( )\text\pos + \text\caret\pos[1], 1 )
                        
                        ;to up
                        \index[#__s_1] - 1
                        \index[#__s_2] - 1
                        
                        If *this\row\_s( )\index <> \index[#__s_2] And
                           SelectElement( *this\row\_s( ), \index[#__s_2] ) 
                        EndIf
                        ;: _edit_sel_draw_( *this, \index[2], \text\len )
                        
                        \text\caret\pos[1] = \row\_s( )\text\len
                        \text\change =- 1 ; - 1 post event change widget
                        
                      Else
                        \notify = 2
                        ProcedureReturn - 1
                      EndIf
                      
                    EndIf
                  EndIf
                  
                  If \text\change
                    \text\caret\pos[2] = \text\caret\pos[1] 
                    Repaint =- 1 
                  EndIf
                EndIf
                
                
              Case #PB_Shortcut_Delete
                If Not _text_paste_( *this ) And 
                   ( \text\caret\pos[2] < \text\len Or \row\_s( )\text\edit[2]\len )
                  
                  If \row\_s( )\text\edit[2]\len 
                    If \text\caret\pos[1] > \text\caret\pos[2] 
                      \text\caret\pos[1] = \text\caret\pos[2] 
                    Else
                      \text\caret\pos[2] = \text\caret\pos[1] 
                    EndIf
                    
                    \row\_s( )\text\edit[2]\pos = 0 
                    \row\_s( )\text\edit[2]\len = 0 
                    \row\_s( )\text\edit[2]\width = 0 
                    \row\_s( )\text\edit[2]\string.s = "" 
                    \row\_s( )\text\edit[2]\change = 1
                    
                  Else
                    \row\_s( )\text\edit[3]\string.s = Right( \row\_s( )\text\string.s, \row\_s( )\text\len - \text\caret\pos[1] - 1 )
                    \row\_s( )\text\edit[3]\len = Len( \row\_s( )\text\edit[3]\string.s ) : \row\_s( )\text\edit[3]\change = 1
                    
                    \text\edit[3]\string = Right( \text\string.s, \text\len - ( \row\_s( )\text\pos + \text\caret\pos[1] ) - 1 )
                    \text\edit[3]\len = Len( \text\edit[3]\string.s )
                    \text\caret\pos[2] = \text\caret\pos[1] 
                  EndIf
                  
                  \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[3]\string.s
                  \row\_s( )\text\len = \row\_s( )\text\edit[1]\len + \row\_s( )\text\edit[3]\len : \row\_s( )\text\change = 1
                  
                  \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                  \text\change =- 1 
                  Repaint =- 1 
                EndIf
                
                ;- return
              Case #PB_Shortcut_Return 
                If *this\text\multiline
                  If Not _text_paste_( *this, #LF$ )
                    *this\index[#__s_2] + 1
                    *this\index[#__s_1] = *this\index[#__s_2]
                    *this\text\caret\pos[2] = 0
                    *this\text\caret\pos[1] = 0
                    *this\text\change =- 1 ; - 1 post event change widget
                  EndIf
                  
                  If *this\text\change 
                    Repaint = 1
                  EndIf
                Else
                  *this\notify = 3
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_C, #PB_Shortcut_X
                If _key_control_
                  SetClipboardText( *this\text\edit[2]\string )
                  
                  If keyboard( )\key = #PB_Shortcut_X
                    Repaint = _text_paste_( *this )
                  EndIf
                EndIf
                
              Case #PB_Shortcut_V
                If _key_control_ And *this\text\editable
                  Protected Text.s = GetClipboardText( )
                  
                  If Not *this\text\multiLine
                    Text = ReplaceString( Text, #LFCR$, #LF$ )
                    Text = ReplaceString( Text, #CRLF$, #LF$ )
                    Text = ReplaceString( Text, #CR$, #LF$ )
                    Text = RemoveString( Text, #LF$ )
                  EndIf
                  
                  Repaint = _text_insert_( *this, Text )
                EndIf  
                
            EndSelect 
            
            Select keyboard( )\key
              Case #PB_Shortcut_Home,
                   #PB_Shortcut_End,
                   #PB_Shortcut_PageUp, 
                   #PB_Shortcut_PageDown,
                   #PB_Shortcut_Up,
                   #PB_Shortcut_Down,
                   #PB_Shortcut_Left,
                   #PB_Shortcut_Right,
                   #PB_Shortcut_Delete,
                   #PB_Shortcut_Return ;, #PB_Shortcut_back
                
                If Not Repaint
                  *this\notify =- 1
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_A,
                   #PB_Shortcut_C,
                   #PB_Shortcut_X, 
                   #PB_Shortcut_V
                
            EndSelect
            
        EndSelect
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   _Editor_Events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      Static DoubleClick.i = -1
      Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
      
      With *this
        ;If \text\editable  
        
        If *this And ( *this\scroll\v And *this\scroll\h And Not EnterButton( ) )
          If ListSize( *this\row\_s( ) )
            If Not \hide ;And \interact
                         ; Get line position
                         ;If mouse( )\buttons ; сним двойной клик не работает
              If \scroll\v And ( mouse( )\y - \y[#__c_inner] - \text\y + \scroll\v\bar\page\pos ) > 0
                _line_ = ( ( mouse( )\y - \y[#__c_inner] - \text\y - \y[#__c_required] ) / ( \text\height + \mode\gridlines ) )
                ;  _line_ = ( ( mouse( )\y - \y[2] - \text\y + \scroll\v\bar\page\pos ) / ( \text\height + \mode\gridlines ) )
              Else
                _line_ =- 1
              EndIf
              ;EndIf
              ;Debug  _line_; ( mouse( )\y - \y[2] - \text\y + \scroll\v\bar\page\pos )
            EndIf
            
            
            Select eventtype 
              Case #__event_LeftDoubleClick 
                ; bug pb
                ; в мак ос в editorgadget ошибка
                ; при двойном клике на слове выделяет правильно 
                ; но стирает вместе с предшествующим пробелом
                ; в окнах выделяет уще и пробелл но стирает то что выделено
                
                ; Событие двойной клик происходит по разному
                ; - mac os  - 
                ; LeftButtonDown 
                ; LeftButtonUp 
                ; LeftClick 
                ; LeftDoubleClick 
                
                ; - windows & linux  - 
                ; LeftButtonDown
                ; LeftDoubleClick
                ; LeftButtonUp
                ; LeftClick
                
                *this\index[#__s_2] = _line_
                
                Caret = _edit_sel_stop_( *this )
                *this\text\caret\time = ElapsedMilliseconds( )
                *this\text\caret\pos[2] = _edit_sel_start_( *this )
                Repaint = _edit_sel_draw_( *this, *this\index[#__s_2], Caret )
                *this\row\selected = \row\_s( ) ; *this\index[2]
                
              Case #__event_LeftButtonDown
                
                If _is_item_( *this, _line_ ) And 
                   _line_ <> \row\_s( )\index  
                  \row\_s( )\color\state = 0
                  SelectElement( *this\row\_s( ), _line_ ) 
                EndIf
                
                If _line_ = \row\_s( )\index
                  \row\_s( )\color\state = 1
                  
                  If *this\row\selected And 
                     *this\row\selected = \row\_s( ) And
                     ( ElapsedMilliseconds( ) - *this\text\caret\time ) < 500
                    
                    *this\text\caret\pos[2] = 0
                    *this\row\box\state = #False
                    *this\row\selected = #Null
                    *this\index[#__s_1] = _line_
                    *this\text\caret\pos[1] = \row\_s( )\text\len ; Чтобы не прокручивало в конец строки
                    Repaint = _edit_sel_draw_( *this, _line_, \row\_s( )\text\len )
                    
                  Else
                    _start_draw_( *this )
                    *this\row\selected = \row\_s( )
                    
                    If *this\text\editable And _edit_sel_is_line_( *this )
                      ; Отмечаем что кликнули
                      ; по выделеному тексту
                      *this\row\box\state = 1
                      
                      Debug "sel - " + \row\_s( )\text\edit[2]\width
                      _set_cursor_( *this, #PB_Cursor_Default )
                    Else
                      ; reset items selection
                      PushListPosition( *this\row\_s( ) )
                      ForEach *this\row\_s( )
                        If *this\row\_s( )\text\edit[2]\width <> 0 
                          _edit_sel_reset_( *this\row\_s( ) )
                        EndIf
                      Next
                      PopListPosition( *this\row\_s( ) )
                      
                      Caret = _text_caret_( *this )
                      
                      \index[#__s_2] = \row\_s( )\index 
                      
                      
                      If *this\text\caret\pos[1] <> Caret
                        *this\text\caret\pos[1] = Caret
                        *this\text\caret\pos[2] = Caret 
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[#__s_1] <> _line_ 
                        *this\index[#__s_1] = _line_
                        Repaint = 1
                      EndIf
                      
                      If Repaint
                        Repaint = Bool( _edit_sel_set_( *this, _line_, Repaint ) )
                      EndIf
                    EndIf
                    
                    StopDrawing( ) 
                  EndIf
                EndIf
                
                
              Case #__event_LeftButtonUp  
                If *this\text\editable And *this\row\box\state
                  ;                   
                  ;                   If _line_ >= 0 And 
                  ;                      _line_ < \count\items And 
                  ;                      _line_ <> \row\_s( )\index And 
                  ;                      SelectElement( \row\_s( ), _line_ ) 
                  ;                   EndIf
                  ;                    
                  _start_draw_( *this )
                  
                  ; на одной линии работает
                  ; теперь надо сделать чтоб и на другие линии можно было бросать
                  If *this\text\caret\pos[2] = *this\text\caret\pos[1] 
                    
                    ; Если бросили на правую сторону от выделеного текста.
                    If *this\index[#__s_2] = *this\index[#__s_1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
                      *this\text\caret\pos[2] - *this\row\selected\text\edit[2]\len
                    EndIf
                    ; Debug "" + *this\text\caret\pos[2]  + " " +  *this\row\selected\text\edit[2]\pos
                    
                    *this\row\selected\text\string = RemoveString( *this\row\selected\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\edit[2]\pos, 1 )
                    *this\text\string = RemoveString( *this\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\pos + *this\row\selected\text\edit[2]\pos, 1 )
                    
                    *this\row\_s( )\text\string = InsertString( *this\row\_s( )\text\string, *this\row\selected\text\edit[2]\string, *this\text\caret\pos[2] + 1 )
                    *this\text\string = InsertString( *this\text\string, *this\row\selected\text\edit[2]\string, *this\row\_s( )\text\pos + *this\text\caret\pos[2] + 1 )
                    
                    
                    ;                       \row\_s( )\text\edit[1]\string.s = Left( \row\_s( )\text\string.s, \text\caret\pos[1] )
                    ;                     \row\_s( )\text\edit[1]\len = Len( \row\_s( )\text\edit[1]\string.s ) : \row\_s( )\text\edit[1]\change = 1
                    ;                     
                    ;                     \row\_s( )\text\string.s = \row\_s( )\text\edit[1]\string.s + \row\_s( )\text\edit[3]\string.s
                    ;                     \row\_s( )\text\len = \row\_s( )\text\edit[1]\len + \row\_s( )\text\edit[3]\len : \row\_s( )\text\change = 1
                    ;                     
                    ;                     \text\string.s = Left( \text\string.s, \row\_s( )\text\pos + \text\caret\pos[1] ) + \text\edit[3]\string
                    ;                     \text\change =- 1 ; - 1 post event change widget
                    
                    ;                     _text_insert_( *this, *this\row\selected\text\edit[2]\string )
                    
                    Debug *this\row\selected\index
                    ;                     *this\index[1] = *this\row\selected\index
                    ;                     *this\index[2] = *this\row\selected\index
                    ;                     Protected len = *this\row\selected\text\edit[2]\len
                    ;                     ;
                    ;                     _line_ = *this\row\selected\index
                    ;                     If _line_ >= 0 And 
                    ;                      _line_ < \count\items And 
                    ;                      _line_ <> \row\_s( )\index And 
                    ;                      SelectElement( \row\_s( ), _line_ ) 
                    ;                   EndIf
                    ;                           
                    Debug *this\row\selected\text\string
                    
                    If *this\index[#__s_2] <> *this\index[#__s_1]
                      ; *this\text\change =- 1
                      _edit_sel_reset_( *this\row\selected )
                      *this\index[#__s_2] = *this\index[#__s_1]
                      
                      ;                          *this\text\change =- 1
                      ;                       make_text_multiline( *this )
                      ;                        *this\text\change = 0
                      ;                     
                    EndIf
                    
                    *this\text\caret\pos[1] = *this\row\selected\text\edit[2]\len
                    
                    ;Swap *this\text\caret\pos[1], *this\text\caret\pos[2]
                    *this\row\selected = #Null
                    
                    Repaint = _edit_sel_( *this, *this\text\caret\pos[2], *this\text\caret\pos[1] )
                    ;                     If *this\text\caret\pos[1] <> Caret  ; *this\text\caret\pos[2] ); + *this\row\selected\text\edit[2]\len
                    ;                       *this\text\caret\pos[1] = Caret
                    ;                       Repaint =- 1
                    ;                     EndIf
                    ;                     
                    ;                     If *this\index[1] <> _line_ 
                    ;                       *this\index[1] = _line_
                    ;                       Repaint = 1
                    ;                     EndIf
                    ;Repaint = _edit_sel_set_( *this, *this\index[1], Repaint )
                    
                    _set_cursor_( *this, #PB_Cursor_IBeam )
                  Else
                    *this\text\caret\pos[2] = _text_caret_( *this )
                    *this\row\_s( )\text\edit[2]\len = 0
                    *this\index[#__s_2] = _line_
                    
                    If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      Repaint =- 1
                    EndIf
                    
                    If *this\index[#__s_1] <> _line_ 
                      *this\index[#__s_1] = _line_
                      Repaint = 1
                    EndIf
                    
                    Repaint = _edit_sel_set_( *this, _line_, Repaint )
                  EndIf
                  
                  StopDrawing( ) 
                  *this\row\box\state = #False
                  *this\row\selected = #Null
                  Repaint = 1
                EndIf
                
              Case #__event_MouseMove  
                If mouse( )\buttons & #PB_Canvas_LeftButton 
                  Repaint = _edit_sel_draw_( *this, _line_ )
                EndIf
                
              Default
                If _is_item_( *this, \index[#__s_2] ) And 
                   \index[#__s_2] <> \row\_s( )\index  
                  \row\_s( )\color\state = 0
                  SelectElement( *this\row\_s( ), \index[#__s_2] ) 
                EndIf
                
            EndSelect
            
            ; edit key events
            If eventtype = #__event_Input Or
               eventtype = #__event_KeyDown Or
               eventtype = #__event_KeyUp
              
              Repaint | Editor_Events_Key( *this, eventtype, mouse( )\x, mouse( )\y )
            EndIf
          EndIf
        EndIf
        ;EndIf
      EndWith
      
      If *this\text\change 
        *this\change = 1
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   Editor_Events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      
      Select eventtype
        Case #__event_Focus
          If *this\text\editable
            Repaint = Bool( Post( eventtype, *this ) )
          EndIf
          
        Case #__event_LostFocus
          If *this\text\editable
            Repaint = Bool( Post( eventtype, *this ) )
          EndIf
          
      EndSelect
      
      Repaint = _Editor_Events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;- 
    ;-  TREE
    Declare.l Tree_Draw( *this._s_WIDGET, List row._s_rows( ) )
    Declare tt_close( *this._s_tt )
    
    Procedure tt_tree_Draw( *this._s_tt, *color._s_color = 0 )
      With *this
        If *this And PB(IsGadget)( \gadget ) And StartDrawing( CanvasOutput( \gadget ) )
          If Not *color
            *color = \color
          EndIf
          
          ;_draw_font_( *this )
          If \text\fontID 
            DrawingFont( \text\fontID ) 
          EndIf
          
          DrawingMode( #PB_2DDrawing_Default )
          Box( 0,1,\width,\height - 2, *color\back[*color\state] )
          DrawingMode( #PB_2DDrawing_Transparent )
          DrawText( \text\x, \text\y, \text\string, *color\front[*color\state] )
          DrawingMode( #PB_2DDrawing_Outlined )
          Line( 0,0,\width,1, *color\frame[*color\state] )
          Line( 0,\height - 1,\width,1, *color\frame[*color\state] )
          Line( \width - 1,0,1,\height, *color\frame[*color\state] )
          StopDrawing( )
        EndIf 
      EndWith
    EndProcedure
    
    Procedure tt_tree_callBack( )
      ;     ;SetActiveWindow( EventWidget( )\root\canvas\window )
      ;     ;SetActiveGadget( EventWidget( )\root\canvas\gadget )
      ;     
      ;     If EventWidget( )\row\selected
      ;       EventWidget( )\row\selected\color\state = 0
      ;     EndIf
      ;     
      ;     EventWidget( )\row\selected = EventWidget( )\row\_s( )
      ;     EventWidget( )\row\_s( )\color\state = 2
      ;     EventWidget( )\color\state = 2
      ;     
      ;     ;Tree_reDraw( EventWidget( ) )
      
      tt_close( GetWindowData( EventWindow( ) ) )
    EndProcedure
    
    Procedure tt_creare( *this._s_WIDGET, x,y )
      With *this
        If *this
          EventWidget( ) = *this
          \row\_tt.allocate( TT )
          \row\_tt\visible = 1
          \row\_tt\x = x + \row\_s( )\x + \row\_s( )\width - 1
          \row\_tt\y = y + \row\_s( )\y - \scroll\v\bar\page\pos
          
          \row\_tt\width = \row\_s( )\text\width - \width[#__c_inner] + ( \row\_s( )\text\x - \row\_s( )\x ) + 5 ; -  ( \width[#__c_required] - \width ); -  \row\_s( )\text\x; 105 ;\row\_s( )\text\width - ( \width[#__c_required] - \row\_s( )\width )  ; - 32 + 5 
          
          If \row\_tt\width < 6
            \row\_tt\width = 0
          EndIf
          
          Debug \row\_tt\width ;Str( \row\_s( )\text\x - \row\_s( )\x )
          
          \row\_tt\height = \row\_s( )\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\_tt\window = OpenWindow( #PB_Any, \row\_tt\x, \row\_tt\y, \row\_tt\width, \row\_tt\height, "", 
                                        #PB_Window_BorderLess | #PB_Window_NoActivate | flag, WindowID( \root\canvas\window ) )
          
          \row\_tt\gadget = CanvasGadget( #PB_Any,0,0, \row\_tt\width, \row\_tt\height )
          \row\_tt\color = \row\_s( )\color
          \row\_tt\text = \row\_s( )\text
          \row\_tt\text\fontID = \row\_s( )\text\fontID
          \row\_tt\text\x =- ( \width[#__c_inner] - ( \row\_s( )\text\x - \row\_s( )\x ) ) + 1
          \row\_tt\text\y = ( \row\_s( )\text\y - \row\_s( )\y ) + \scroll\v\bar\page\pos
          
          BindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), \row\_tt\window )
          SetWindowData( \row\_tt\window, \row\_tt )
          tt_tree_Draw( \row\_tt )
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close( *this._s_tt )
      If IsWindow( *this\window )
        *this\visible = 0
        ; UnbindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), *this\window )
        CloseWindow( *this\window )
        ; ClearStructure( *this, _s_tt ) ;??????
      EndIf
    EndProcedure
    
    ;- 
    Macro _tree_items_scroll_y_( _address_, _pos_, _len_ )
      _bar_scroll_pos_( _address_, ( _pos_ ) - _address_\y, _len_ )
      ; 
      ;bar_SetState( _address_, ( ( _pos_ - _address_\y ) - ( _address_\bar\page\len - _len_ ) ) ) 
    EndMacro
    
    Procedure.l Tree_Draw( *this._s_WIDGET, List *row._s_rows( ) )
      Protected state.b, x.l,y.l, scroll_x, scroll_y
      
      With *this
        If Not \hide
          ; update coordinate
          If \change > 0
            Debugger( )
            Debug "Tree_New_Update"
            
            ; if the item list has changed
            *this\x[#__c_required] = 0
            *this\y[#__c_required] = 0
            *this\width[#__c_required] = 0
            *this\height[#__c_required] = 0
            ;*this\scroll\v\bar\page\pos = 0
            
            ; reset item z - order
            Protected buttonpos = 6
            Protected buttonsize = 9
            Protected boxpos = 4
            Protected boxsize = 11
            
            PushListPosition( *this\row\_s( ) )
            ForEach *this\row\_s( )
              *this\row\_s( )\index = ListIndex( *this\row\_s( ) )
              
              If *this\row\_s( )\hide
                *this\row\_s( )\draw = 0
              Else
                If *this\change > 0
                  ; check box size
                  If ( *this\mode\check = #__m_checkselect Or 
                       *this\mode\check = #__m_optionselect )
                    *this\row\_s( )\checkbox\width = boxsize
                    *this\row\_s( )\checkbox\height = boxsize
                  EndIf
                  
                  ; collapse box size
                  If ( *this\mode\lines Or *this\mode\buttons ) And
                     Not ( *this\row\_s( )\sublevel And *this\mode\check = #__m_optionselect )
                    *this\row\_s( )\button\width = buttonsize
                    *this\row\_s( )\button\height = buttonsize
                  EndIf
                  
                  ; drawing item font
                  _draw_font_item_( *this, *this\row\_s( ), *this\row\_s( )\text\change )
                  
                  ; draw items height
                  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                    CompilerIf Subsystem("qt")
                      *this\row\_s( )\height = *this\row\_s( )\text\height - 1
                    CompilerElse
                      *this\row\_s( )\height = *this\row\_s( )\text\height + 3
                    CompilerEndIf
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
                    *this\row\_s( )\height = *this\row\_s( )\text\height + 4
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
                    If *this\type = #__type_ListView
                      *this\row\_s( )\height = *this\row\_s( )\text\height
                    Else
                      *this\row\_s( )\height = *this\row\_s( )\text\height + 2
                    EndIf
                  CompilerEndIf
                  
                  *this\row\_s( )\y[#__c_container] = *this\height[#__c_required]
                  *this\row\_s( )\y = *this\y[#__c_inner] + *this\height[#__c_required]
                EndIf
                
                ; sublevel position
                *this\row\_s( )\sublevelsize = *this\row\_s( )\sublevel * *this\row\sublevelsize + Bool( *this\mode\check ) * (boxpos + boxsize) + Bool( *this\mode\lines Or *this\mode\buttons ) * ( buttonpos + buttonsize )
                
                ; check & option box position
                If ( *this\mode\check = #__m_checkselect Or 
                     *this\mode\check = #__m_optionselect )
                  
                  If *this\row\_s( )\parent And *this\mode\check = #__m_optionselect
                    *this\row\_s( )\checkbox\x = *this\row\_s( )\sublevelsize - *this\row\_s( )\checkbox\width
                  Else
                    *this\row\_s( )\checkbox\x = boxpos
                  EndIf
                  *this\row\_s( )\checkbox\y = ( *this\row\_s( )\height ) - ( *this\row\_s( )\height + *this\row\_s( )\checkbox\height )/2
                EndIf
                
                ; expanded & collapsed box position
                If ( *this\mode\lines Or *this\mode\buttons ) And Not ( *this\row\_s( )\sublevel And *this\mode\check = #__m_optionselect )
                  
                  If *this\mode\check = #__m_optionselect
                    *this\row\_s( )\button\x = *this\row\_s( )\sublevelsize - 10
                  Else
                    *this\row\_s( )\button\x = *this\row\_s( )\sublevelsize - (( buttonpos + buttonsize ) - 4)
                  EndIf
                  
                  *this\row\_s( )\button\y = ( *this\row\_s( )\height ) - ( *this\row\_s( )\height + *this\row\_s( )\button\height )/2
                EndIf
                
                ; image position
                If *this\row\_s( )\image\id
                  *this\row\_s( )\image\x = *this\row\_s( )\sublevelsize + *this\image\padding\x + 2
                  *this\row\_s( )\image\y = ( *this\row\_s( )\height - *this\row\_s( )\image\height )/2
                EndIf
                
                ; text position
                If *this\row\_s( )\text\string
                  *this\row\_s( )\text\x = *this\row\_s( )\sublevelsize + *this\row\margin\width + *this\text\padding\x
                  *this\row\_s( )\text\y = ( *this\row\_s( )\height - *this\row\_s( )\text\height )/2
                EndIf
                
                If *this\row\_s( )\text\edit\string
                  If *this\bar
                    *this\row\_s( )\text\edit\x = *this\row\_s( )\text\x + *this\bar\page\pos
                  Else
                    *this\row\_s( )\text\edit\x = *this\row\_s( )\text\x
                  EndIf
                  *this\row\_s( )\text\edit\y = *this\row\_s( )\text\y
                EndIf
                
                ; vertical & horizontal scroll max value
                If *this\change > 0
                  *this\height[#__c_required] + *this\row\_s( )\height + Bool( *this\row\_s( )\index <> *this\count\items - 1 ) * *this\mode\GridLines
                  
                  ;;If *this\scroll\h
                  If *this\width[#__c_required] < ( *this\row\_s( )\text\x + *this\row\_s( )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ); - *this\x[#__c_inner]
                    *this\width[#__c_required] = ( *this\row\_s( )\text\x + *this\row\_s( )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ) ; - *this\x[#__c_inner]
                                                                                                                                                                  ;;EndIf
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition( *this\row\_s( ) )
            
            ; change vertical scrollbar max
            If *this\scroll\v\bar\max <> *this\height[#__c_required] And
               bar_SetAttribute( *this\scroll\v, #__bar_Maximum, *this\height[#__c_required] )
              
              Bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
              *this\width[#__c_inner] = *this\scroll\h\bar\page\len
              *this\height[#__c_inner] = *this\scroll\v\bar\page\len
            EndIf
            
            ; change horizontal scrollbar max
            If *this\scroll\h\bar\max <> *this\width[#__c_required] And
               bar_SetAttribute( *this\scroll\h, #__bar_Maximum, *this\width[#__c_required] )
              
              Bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
              *this\width[#__c_inner] = *this\scroll\h\bar\page\len
              *this\height[#__c_inner] = *this\scroll\v\bar\page\len
            EndIf
            
            \change =- 2
          EndIf 
          
          ; SetState( )
          If *this\row\selected And 
             *this\row\selected\_state & #__s_scrolled
            _tree_items_scroll_y_( *this\scroll\v, *this\row\selected\y, *this\row\selected\height )
            *this\row\selected\_state &~ #__s_scrolled
            *this\scroll\v\change = 0 
          EndIf
          
          If \change < 0
            ;; Tree_New_Update( *this, *this\row\_s( ) )
            PushListPosition( *this\row\_s( ) )
            ; reset draw list
            ClearList( *this\row\draws( ) )
            *this\row\first_visible = 0
            *this\row\last_visible = 0
            
            
            ForEach *this\row\_s( )
              *this\row\_s( )\draw = Bool( Not *this\row\_s( )\hide And 
                                           ( ( *this\row\_s( )\y[#__c_container] + *this\row\_s( )\height - *this\scroll\v\bar\page\pos ) > 0 And 
                                             ( *this\row\_s( )\y[#__c_container] - *this\scroll\v\bar\page\pos ) < *this\height[#__c_inner] ) )
              ; add new draw list
              If *this\row\_s( )\draw And 
                 AddElement( *this\row\draws( ) )
                *this\row\draws( ) = *this\row\_s( )
                
                If Not *this\row\first_visible
                  *this\row\first_visible = *this\row\_s( )
                EndIf
                *this\row\last_visible = *this\row\_s( )
              EndIf
            Next
            PopListPosition( *this\row\_s( ) )
          EndIf
          
          
          
          ; Draw background
          If *this\color\_alpha
            DrawingMode( #PB_2DDrawing_Default )
            RoundBox( *this\x[#__c_frame],*this\y[#__c_frame], *this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round,*this\color\back[*this\color\state] )
          EndIf
          
          ; Draw background image
          If *this\image\id
            DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
            DrawAlphaImage( *this\image\id, *this\image\x, *this\image\y, *this\color\_alpha )
          EndIf
          
          ;
          _clip_content_( *this, [#__c_clip2] )
          
          
          PushListPosition( *row( ) )
          
          scroll_x = *this\scroll\h\bar\page\pos
          scroll_y = *this\scroll\v\bar\page\pos
          
          ; Draw all items
          ForEach *row( )
            If *row( )\draw
              If *row( )\x <> *this\x[#__c_inner] + 1
                *row( )\x = *this\x[#__c_inner] + 1
              EndIf
              If *row( )\y <> *this\y[#__c_inner] + *row( )\y[#__c_container]
                *row( )\y = *this\y[#__c_inner] + *row( )\y[#__c_container]
              EndIf
              If *row( )\width <> *this\width[#__c_inner] - 2
                *row( )\width = *this\width[#__c_inner] - 2
              EndIf
              
              x = *row( )\x - scroll_x
              y = *row( )\y - scroll_y
              
              ; init real drawing font
              _draw_font_item_( *this, *row( ), 0 )
              
              state = *row( )\color\state  
              
              ; Draw selector back
              If *row( )\childrens And *this\flag & #__tree_property
                DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                RoundBox( *row( )\x, y, *this\width[#__c_inner],*row( )\height,*row( )\round,*row( )\round,*row( )\color\back )
                ;RoundBox( *this\x[#__c_inner] + *this\row\sublevelsize,Y,*this\width[#__c_inner] - *this\row\sublevelsize,*row( )\height,*row( )\round,*row( )\round,*row( )\color\back[state] )
                Line( *row( )\x + *this\row\sublevelsize, y + *row( )\height, *this\width[#__c_inner] - *this\row\sublevelsize, 1, $FFACACAC )
                
              Else
                If *row( )\color\back[state]
                  DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                  RoundBox( *row( )\x, y, *row( )\width, *row( )\height,*row( )\round,*row( )\round,*row( )\color\back[state] )
                EndIf
              EndIf
              
              ;               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  *this\_dd And
              ;                  
              ;               If mouse( )\buttons And 
              ;                  *row( )\_state & #__s_entered And 
              ;                  Not _is_selected_( *this )
              ;                 
              ;                 DrawingMode( #PB_2DDrawing_Default )
              ;                 If (y + *row( )\height/2) > mouse( )\y 
              ;                   Line( *row( )\x, y - *this\mode\gridlines, *row( )\width, 1, $ff000000 )
              ;                 Else
              ;                   Line( *row( )\x, y + *row( )\height, *row( )\width, 1, $ff000000 )
              ;                 EndIf
              ;               EndIf
              
              ; Draw items image
              If *row( )\image\id
                DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
                DrawAlphaImage( *row( )\image\id, x + *row( )\image\x, y + *row( )\image\y, *row( )\color\_alpha )
              EndIf
              
              ; Draw items text
              If *row( )\text\string.s
                DrawingMode( #PB_2DDrawing_Transparent )
                DrawRotatedText( x + *row( )\text\x, y + *row( )\text\y, *row( )\text\string.s, *this\text\rotate, *row( )\color\front[state] )
              EndIf
              
              ; Draw items data text
              If *row( )\text\edit\string.s
                DrawingMode( #PB_2DDrawing_Transparent )
                DrawRotatedText( *row( )\x + *row( )\text\edit\x - scroll_x, *row( )\y + *row( )\text\edit\y - scroll_y, *row( )\text\edit\string.s, *this\text\rotate, *row( )\color\front[state] )
              EndIf
              
              ; Draw selector frame
              If *row( )\childrens And *this\flag & #__tree_property
              Else
                If *row( )\color\frame[state]
                  DrawingMode( #PB_2DDrawing_Outlined )
                  RoundBox( *row( )\x, y, *row( )\width, *row( )\height, *row( )\round,*row( )\round, *row( )\color\frame[state] )
                EndIf
              EndIf
              
              ; Horizontal line
              If *this\mode\GridLines And *row( )\color\line <> *row( )\color\back
                DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
                Box( *row( )\x, y + *row( )\height + Bool( *this\mode\gridlines>1 ) , *row( )\width, 1, *this\color\line )
              EndIf
            EndIf
          Next
          
          ;           DrawingMode( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
          ;           Box( *this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevelsize, *this\height[#__c_inner], *this\row\_s( )\parent\color\back )
          
          
          ; Draw plots
          If *this\mode\lines ;= 1
            DrawingMode( #PB_2DDrawing_Default )
            ; DrawingMode( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ) )
            
            ForEach *row( )
              If *row( )\draw And Not *row( )\hide 
                x = *row( )\x - scroll_x
                y = *row( )\y - scroll_y
                
                ; for the tree vertical line
                If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
                  Line( (x + *row( )\last\button\x+*row( )\last\button\width/2), (y+*row( )\height), 1, (*row( )\last\y-*row( )\y)-*row( )\last\height/2, *row( )\color\line )
                EndIf
                If *row( )\parent And Not *row( )\parent\draw And *row( )\parent\last = *row( ) And *row( )\sublevel
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\y+*row( )\parent\height) - scroll_y, 1, (*row( )\y-*row( )\parent\y)-*row( )\height/2, *row( )\parent\color\line )
                EndIf
                
                ; for the tree horizontal line
                If Not (*this\mode\buttons And *row( )\childrens)
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 7, 1, *row( )\color\line )
                EndIf
              EndIf    
            Next
            
            ; for the tree item first vertical line
            If *this\row\first And *this\row\last
              Line( (*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - scroll_x, (*this\row\first\y+*this\row\first\height/2) - scroll_y, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
            EndIf
            
          ElseIf *this\mode\lines = 2
            DrawingMode( #PB_2DDrawing_Default )
            ; DrawingMode( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ) )
            
            ForEach *row( )
              If *row( )\draw And Not *row( )\hide 
                x = *row( )\x - scroll_x - Bool(*row()\parent Or *row( )\childrens) * *this\row\sublevelsize
                y = *row( )\y - scroll_y
                
                If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
                  Line( (x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
                EndIf
                If *row( )\parent And Not *row( )\parent\draw And *row( )\parent\last = *row( ) And *row( )\sublevel
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\y+*row( )\parent\height/2) - scroll_y, 1, (*row( )\y-*row( )\parent\y), *row( )\parent\color\line )
                EndIf
                
                ; for the tree horizontal line
                If *row()\parent
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 7, 1, *row( )\color\line )
                EndIf
                
                If (Not *this\mode\buttons And *row( )\childrens)
                  Line( (x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize-3, (y+*row( )\height/2), 3, 1, *row( )\color\line )
                EndIf
              EndIf    
            Next
            
          ElseIf *this\mode\lines = 3
            DrawingMode( #PB_2DDrawing_Default )
            ; DrawingMode( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ) )
            Protected minus = 7
            ; for the tree item first vertical line
            If *this\row\first And *this\row\last
              Line( (*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - scroll_x - minus, (*this\row\first\y+*this\row\first\height/2) - scroll_y, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
            EndIf
            
            
            ForEach *row( )
              If *row( )\draw And Not *row( )\hide 
                x = *row( )\x - scroll_x - Bool(*row()\parent Or *row( )\childrens) * *this\row\sublevelsize
                y = *row( )\y - scroll_y
                
                ; for the tree vertical line
                If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
                  Line( (x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
                EndIf
                If *row( )\parent And Not *row( )\parent\draw And *row( )\parent\last = *row( ) And *row( )\sublevel
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\y+*row( )\parent\height/2) - scroll_y, 1, (*row( )\y-*row( )\parent\y), *row( )\parent\color\line )
                EndIf
                
                ; for the tree horizontal line
                If (Not *this\mode\buttons And *row( )\childrens) 
                  If *row( )\last\sublevel > 1 Or minus
                    Line( (x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize-4-Bool(minus And *row( )\last\sublevel < 2)*3, (y+*row( )\height/2), 4+Bool(minus And *row( )\last\sublevel < 2)*3, 1, *row( )\color\line )
                  EndIf
                ElseIf *row( )\parent
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 5, 1, *row( )\color\line )
                ElseIf Not (*this\mode\buttons And *row( )\childrens) Or *row( ) = *this\row\first Or *row( ) = *this\row\last
                  If *row( ) = *this\row\first Or *row( ) = *this\row\last
                    x + Bool(*row()\parent Or *row( )\childrens) * *this\row\sublevelsize
                  EndIf
                  Line( (x + *row( )\button\x+*row( )\button\width/2) - minus, (y+*row( )\height/2), 7, 1, *row( )\color\line )
                EndIf
              EndIf    
            Next
          ElseIf *this\mode\lines ;= 4
            DrawingMode( #PB_2DDrawing_Default )
            ; DrawingMode( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ) )
            
            ; for the tree item first vertical line
            If *this\row\first And *this\row\last
              Line( (*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - scroll_x, (*this\row\first\y+*this\row\first\height/2) - scroll_y, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
            EndIf
            
            ForEach *row( )
              If *row( )\draw And Not *row( )\hide 
                x = *row( )\x - scroll_x - Bool(*row()\parent Or *row( )\childrens) * *this\row\sublevelsize
                y = *row( )\y - scroll_y
                
                ; for the tree vertical line
                If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
                  Line( (x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
                EndIf
                If *row( )\parent And Not *row( )\parent\draw And *row( )\parent\last = *row( ) And *row( )\sublevel
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\y+*row( )\parent\height/2) - scroll_y, 1, (*row( )\y-*row( )\parent\y), *row( )\parent\color\line )
                EndIf
                
                ; for the tree horizontal line
                If (Not *this\mode\buttons And *row( )\childrens) And *row( )\sublevel
                  Line( (x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize, (y+*row( )\height/2), 5, 1, *row( )\color\line )
                EndIf
                
                If *row( ) = *this\row\first Or *row( ) = *this\row\last Or (*row( )\childrens And *row( )\sublevel = 0)
                  x + Bool(*row()\parent Or *row( )\childrens) * *this\row\sublevelsize
                EndIf
                
                If Not ( *this\mode\buttons And *row( )\childrens And *row( )\sublevel = 0 )
                  Line( (x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 5, 1, *row( )\color\line )
                EndIf
              EndIf    
            Next
          EndIf
          
          ; Draw buttons
          If *this\mode\buttons Or
             ( *this\mode\check = #__m_checkselect Or *this\mode\check = #__m_optionselect )
            
            ; Draw boxs ( check&option )
            Protected _box_x_, _box_y_
            ForEach *row( )
              If *row( )\draw And *this\mode\check
                x = *row( )\x + *row( )\checkbox\x - scroll_x
                y = *row( )\y + *row( )\checkbox\y - scroll_y
                
                If *row( )\parent And *this\mode\check = #__m_optionselect
                  ; option
                  _draw_button_( 1, x, y, *row( )\checkbox\width, *row( )\checkbox\height, *row( )\checkbox\state, 4 );, \color )
                Else                                                                                                  ;If Not ( *this\mode\buttons And *row( )\childrens And *this\mode\check = #__m_optionselect )
                                                                                                                      ; check
                  _draw_button_( 3, x, y, *row( )\checkbox\width, *row( )\checkbox\height, *row( )\checkbox\state, 2 );, \color )
                EndIf
              EndIf    
            Next
            
            DrawingMode( #PB_2DDrawing_Outlined); | #PB_2DDrawing_AlphaBlend )
            
            ; Draw buttons ( expanded&collapsed )
            ForEach *row( )
              If *row( )\draw And Not *row( )\hide 
                x = *row( )\x + *row( )\button\x - scroll_x
                y = *row( )\y + *row( )\button\y - scroll_y
                
                If *this\mode\buttons And *row( )\childrens And
                   Not ( *row( )\sublevel And *this\mode\check = #__m_optionselect )
                  
                  If #PB_Compiler_OS = #PB_OS_Windows Or 
                     (*row( )\parent And *row( )\parent\last And *row( )\parent\sublevel = *row( )\parent\last\sublevel)
                    
                    _draw_button_( 0, x, y, *row( )\button\width, *row( )\button\height, 0,2)
                    _draw_box_( *row( )\button, color\frame )
                    
                    Line(x + 2, y + *row( )\button\height/2, *row( )\button\width - 4, 1, $ff000000)
                    If *row( )\button\state
                      Line(x + *row( )\button\width/2, y + 2, 1, *row( )\button\height - 4, $ff000000)
                    EndIf
                    
                  Else
                    
                    Arrow( x + ( *row( )\button\width - 4 )/2,
                           y + ( *row( )\button\height - 4 )/2, 4, 
                           Bool( Not *row( )\button\state ) + 2, *row( )\color\front[0] ,0,0 ) 
                    
                  EndIf
                  
                EndIf
              EndIf    
            Next
          EndIf
          
          ; 
          PopListPosition( *row( ) ) ; 
          
          
          ; Draw scroll bars
          Area_Draw( *this )
          
          ; Draw frames
          If *this\fs
            DrawingMode( #PB_2DDrawing_Outlined )
            _draw_box_( *this, color\frame, [#__c_frame] )
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.i Tree_AddItem( *this._s_WIDGET, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected handle, last, *last._s_rows, *parent._s_rows
      ; sublevel + 1
      
      ;With *this
      If *this
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize( *this\row\_s( ) ) - 1
          LastElement( *this\row\_s( ) )
          handle = AddElement( *this\row\_s( ) ) 
          
          If position < 0 
            position = ListIndex( *this\row\_s( ) )
          EndIf
        Else
          handle = SelectElement( *this\row\_s( ), position )
          
          ; for the tree( )
          If sublevel > *this\row\_s( )\sublevel
            PushListPosition( *this\row\_s( ) )
            If PreviousElement( *this\row\_s( ) )
              *this\row\last_add = *this\row\_s( )
              ;;NextElement( *this\row\_s( ) )
            Else
              last = *this\row\last_add
              sublevel = *this\row\_s( )\sublevel
            EndIf
            PopListPosition( *this\row\_s( ) )
          Else
            last = *this\row\last_add
            sublevel = *this\row\_s( )\sublevel
          EndIf
          
          handle = InsertElement( *this\row\_s( ) )
        EndIf
        ;}
        
        If handle
          If sublevel > position
            sublevel = position
          EndIf
          
          If *this\row\last_add 
            If sublevel > *this\row\last_add\sublevel
              sublevel = *this\row\last_add\sublevel + 1
              *parent = *this\row\last_add
              
            ElseIf *this\row\last_add\parent 
              If sublevel > *this\row\last_add\parent\sublevel 
                *parent = *this\row\last_add\parent
                
              ElseIf sublevel < *this\row\last_add\sublevel 
                If *this\row\last_add\parent\parent
                  *parent = *this\row\last_add\parent\parent
                  
                  While *parent 
                    If sublevel >= *parent\sublevel 
                      If sublevel = *parent\sublevel 
                        *parent = *parent\parent
                      EndIf
                      Break
                    Else
                      *parent = *parent\parent
                    EndIf
                  Wend
                EndIf
                
                ; for the editor( )
                If *this\row\last_add\parent 
                  If *this\row\last_add\parent\sublevel = sublevel 
                    ;                     *this\row\_s( )\before = *this\row\last_add\parent
                    ;                     *this\row\last_add\parent\after = *this\row\_s( )
                    
                    If *this\type = #__type_Editor
                      *parent = *this\row\last_add\parent
                      *parent\last = *this\row\_s( )
                      *this\row\last_add = *parent
                      last = *parent
                    EndIf
                    
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          If *parent
            *parent\childrens + 1
            *this\row\_s( )\parent = *parent
          EndIf
          
          If sublevel
            *this\row\_s( )\sublevel = sublevel
          EndIf
          
          If last
            ; *this\row\last_add = last
          Else
            *this\row\last_add = *this\row\_s( )
          EndIf
          
          ; for the tree( )
          If *this\row\last_add\parent And
             *this\row\last_add\parent\sublevel < sublevel
            *this\row\last_add\parent\last = *this\row\last_add
          EndIf
          
          If *this\row\last_add\sublevel = 0
            *this\row\last = *this\row\last_add
          EndIf
          
          If position = 0
            *this\row\first = *this\row\_s( )
          EndIf
          
          If *this\mode\collapse And *this\row\_s( )\parent And 
             *this\row\_s( )\sublevel > *this\row\_s( )\parent\sublevel
            *this\row\_s( )\parent\button\state = 1 
            *this\row\_s( )\hide = 1
          EndIf
          
          ; properties
          If *this\flag & #__tree_property
            If *parent And Not *parent\sublevel And Not *parent\text\fontID
              *parent\color\back = $FFF9F9F9
              *parent\color\back[1] = *parent\color\back
              *parent\color\back[2] = *parent\color\back
              *parent\color\frame = *parent\color\back
              *parent\color\frame[1] = *parent\color\back
              *parent\color\frame[2] = *parent\color\back
              *parent\color\front[1] = *parent\color\front
              *parent\color\front[2] = *parent\color\front
              *parent\text\fontID = FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic ) )
            EndIf
          EndIf
          
          ; add lines
          *this\row\_s( )\index = ListIndex( *this\row\_s( ) )
          *this\row\_s( )\color = _get_colors_( )
          *this\row\_s( )\color\state = 0
          *this\row\_s( )\color\back = 0 
          *this\row\_s( )\color\frame = 0
          
          *this\row\_s( )\color\fore[0] = 0 
          *this\row\_s( )\color\fore[1] = 0
          *this\row\_s( )\color\fore[2] = 0
          *this\row\_s( )\color\fore[3] = 0
          
          If Text
            *this\row\_s( )\text\change = 1
            *this\row\_s( )\text\string = StringField( Text.s, 1, #LF$ )
            *this\row\_s( )\text\edit\string = StringField( Text.s, 2, #LF$ )
          EndIf
          
          _set_image_( *this, *this\row\_s( )\Image, Image )
          
          If *this\row\selected 
            *this\row\selected\color\state = #__s_0
            
            If *this\row\selected\_state & #__s_scrolled
              *this\row\selected\_state &~ #__s_scrolled
            EndIf
            
            *this\row\selected = *this\row\_s( ) 
            *this\row\selected\_state | #__s_scrolled | #__s_selected
            *this\row\selected\color\state = #__s_2 + Bool( *this\_state & #__s_focused = #False )
            
            _post_repaint_( *this\root )
          Else
            _post_repaint_items_( *this )
          EndIf
          
          *this\count\items + 1
          *this\change = 1
        EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *this\count\items - 1
    EndProcedure
    
    Procedure.l Tree_events_Key( *this._s_WIDGET, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected result, from =- 1
      Static cursor_change, Down, *row_selected._s_rows
      
      With *this
        Select eventtype 
          Case #__event_KeyDown
            
            Select keyboard( )\key
              Case #PB_Shortcut_PageUp
                If bar_SetState( *this\scroll\v, 0 ) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\end ) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\row\selected
                  If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( keyboard( )\key[1] & #PB_Canvas_Control )
                    If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If ( keyboard( )\key = #PB_Shortcut_Home Or
                         ( keyboard( )\key[1] & #PB_Canvas_Alt ) )
                      SelectElement( *this\row\_s( ), 0 )
                    Else
                      _select_prev_item_( *this\row\_s( ), *this\row\selected\index )
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s( )
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s( )
                      *this\row\_s( )\color\state = 2
                      *row_selected = *this\row\_s( )
                      
                      *this\change =- _tree_items_scroll_y_( *this\scroll\v, *this\row\selected\y, *this\row\selected\height )
                      Post( #__event_Change, *this, *this\row\_s( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\row\selected
                  If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( keyboard( )\key[1] & #PB_Canvas_Control )
                    
                    If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < ( *this\count\items - 1 )
                    ; select modifiers key
                    If ( keyboard( )\key = #PB_Shortcut_End Or
                         ( keyboard( )\key[1] & #PB_Canvas_Alt ) )
                      SelectElement( *this\row\_s( ), ( *this\count\items - 1 ) )
                    Else
                      _select_next_item_( *this\row\_s( ), *this\row\selected\index )
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s( )
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s( )
                      *this\row\_s( )\color\state = 2
                      *row_selected = *this\row\_s( )
                      
                      *this\change =- _tree_items_scroll_y_( *this\scroll\v, *this\row\selected\y, *this\row\selected\height )
                      Post( #__event_Change, *this, *this\row\_s( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  *this\change = bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end/10 ) ) 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  *this\change = bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end/10 ) ) 
                  result = 1
                EndIf
                
            EndSelect
            
            ;EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Tree_events( *this._s_WIDGET, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected Repaint
      
      If eventtype = #__event_LeftButtonDown
        If EnterRow( ) 
          ; collapsed/expanded button
          If EnterRow( )\childrens And 
             Atpoint( EnterRow( )\button,
                      mouse_x + *this\scroll\h\bar\page\pos - EnterRow( )\x,
                      mouse_y + *this\scroll\v\bar\page\pos - EnterRow( )\y )
            
            If EnterRow( )\button\state
              Repaint | SetItemState( *this, EnterRow( )\index, #__tree_expanded )
            Else
              Repaint | SetItemState( *this, EnterRow( )\index, #__tree_collapsed )
            EndIf
          Else
            ; change box ( option&check )
            If Atpoint( EnterRow( )\checkbox,
                        mouse_x + *this\scroll\h\bar\page\pos - EnterRow( )\x,
                        mouse_y + *this\scroll\v\bar\page\pos - EnterRow( )\y )
              ;*this\row\box\state = 1
              
              ; change box option
              If *this\mode\check = #__m_optionselect
                If EnterRow( )\parent And EnterRow( )\option_group  
                  If EnterRow( )\option_group\parent And 
                     EnterRow( )\option_group\checkbox\state 
                    EnterRow( )\option_group\checkbox\state = #PB_Checkbox_Unchecked
                  EndIf
                  
                  If EnterRow( )\option_group\option_group <> EnterRow( )
                    If EnterRow( )\option_group\option_group
                      EnterRow( )\option_group\option_group\checkbox\state = #PB_Checkbox_Unchecked
                    EndIf
                    EnterRow( )\option_group\option_group = EnterRow( )
                  EndIf
                EndIf
              EndIf
              
              ; change box check
              _set_check_state_( EnterRow( )\checkbox, *this\mode\threestate )
              
              ;
              If EnterRow( )\color\state = #__s_2 
                Post( #__event_Change, *this, EnterRow( )\index )
              EndIf
            EndIf
            
            
            If *this\mode\check = #__m_clickselect
              If EnterRow( )\_state & #__s_selected
                EnterRow( )\_state &~ #__s_selected
              Else
                EnterRow( )\_state | #__s_selected
              EndIf
              *this\row\selected = EnterRow( )
              
            Else
              ; reset selected items
              ForEach *this\row\_s( )
                If *this\row\_s( ) <> EnterRow( ) And 
                   *this\row\_s( )\_state & #__s_selected
                  *this\row\_s( )\_state &~ #__s_selected
                  *this\row\_s( )\color\state = #__s_0
                EndIf
              Next
              
              If *this\row\selected <> EnterRow( )
                *this\row\selected = EnterRow( )
                EnterRow( )\_state | #__s_selected
              EndIf
            EndIf
            
            ; set draw color state
            If EnterRow( )\_state & #__s_selected 
              If EnterRow( )\color\state <> #__s_2
                EnterRow( )\color\state = #__s_2
                
                Post( #__event_Change, *this, EnterRow( )\index )
              EndIf
            Else
              EnterRow( )\color\state = #__s_1
            EndIf
          EndIf
          
          ; Repaint = #True
        EndIf
      EndIf
      
      If eventtype = #__event_LeftButtonUp
        If EnterRow( ) And
           EnterRow( )\_state & #__s_entered  
          
          If EnterRow( )\color\state = #__s_0
            EnterRow( )\color\state = #__s_1
            
            ; Post event item status change
            Post( #__event_StatusChange, *this, EnterRow( )\index )
            ; Repaint = #True 
          Else
            If EnterRow( )\childrens And 
               Atpoint( EnterRow( )\button, 
                        mouse_x + *this\scroll\h\bar\page\pos - EnterRow( )\x,
                        mouse_y + *this\scroll\v\bar\page\pos - EnterRow( )\y )
              
              Post( #__event_Up, *this, EnterRow( )\index )
            Else
              Post( #__event_LeftClick, *this, EnterRow( )\index )
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      If eventtype = #__event_Focus Or 
         eventtype = #__event_LostFocus
        
        If *this\count\items
          PushListPosition( *this\row\_s( ) ) 
          ForEach *this\row\_s( )
            If eventtype = #__event_Focus
              If *this\row\_s( )\color\state = #__s_3
                *this\row\_s( )\color\state = #__s_2
                *this\row\_s( )\_state | #__s_selected
                Repaint = #True
              EndIf
              
            ElseIf eventtype = #__event_LostFocus
              If *this\row\_s( )\color\state = #__s_2
                *this\row\_s( )\color\state = #__s_3
                *this\row\_s( )\_state &~ #__s_selected
                Repaint = #True
              EndIf
            EndIf
          Next
          PopListPosition( *this\row\_s( ) ) 
        EndIf
      EndIf
      
      If eventtype = #__event_RightButtonUp Or
         eventtype = #__event_LeftDoubleClick
        
        Post( eventtype, *this, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      
      ; mouse wheel verticl and horizontal
      If eventtype = #__event_MouseWheelX
        ;         If mouse( )\wheel\x > 0
        ;           ;Post( #__event_Up, *this\scroll\h )
        Repaint | Bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
        
        ;         ElseIf mouse( )\wheel\x < 0
        ;           ;Post( #__event_Down, *this\scroll\h )
        ;           Repaint | Bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
        ;         EndIf
      EndIf
      
      If eventtype = #__event_MouseWheelY
        ;         If mouse( )\wheel\y > 0
        ;           ;Post( #__event_Up, *this\scroll\v )
        Repaint | Bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
        ;           
        ;         ElseIf mouse( )\wheel\y < 0
        ;           ;Post( #__event_Down, *this\scroll\v )
        ;           Repaint | Bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
        ;         EndIf
      EndIf
      
      
      ; key events
      If eventtype = #__event_Input Or
         eventtype = #__event_KeyDown Or
         eventtype = #__event_KeyUp
        
        Repaint | Tree_events_Key( *this, eventtype, mouse_x, mouse_y )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Macro _set_state_list_( _address_, _state_ )
      If _state_ > 0 
        If *this\mode\check = #__m_clickselect
          If _address_\_state & #__s_entered = #False
            _address_\_state | #__s_entered
          EndIf
        Else
          If _address_\_state & #__s_selected = #False
            _address_\_state | #__s_selected
          EndIf
        EndIf 
        
        If _address_\_state & #__s_selected
          _address_\color\state = #__s_2
        ElseIf _address_\_state & #__s_entered
          _address_\color\state = #__s_1
        EndIf
        
      ElseIf _address_ 
        If *this\mode\check <> #__m_clickselect
          If _address_\_state & #__s_selected
            _address_\_state &~ #__s_selected
          EndIf
        EndIf 
        
        If _address_\_state & #__s_entered
          _address_\_state &~ #__s_entered
        EndIf
        
        If _address_\_state & #__s_selected = #False
          _address_\color\state = #__s_0
        EndIf
      EndIf
    EndMacro
    
    Macro _set_state_list_1( _address_, _state_ )
      If _state_ > 0 
        If *this\mode\check = #__m_clickselect
          If _address_\color\state <> #__s_2
            _address_\color\state = #__s_1
            _address_\_state | #__s_entered
          EndIf
        Else
          _address_\color\state = #__s_2
          _address_\_state | #__s_selected
        EndIf
        
      ElseIf _address_ 
        If *this\mode\check = #__m_clickselect
          If _address_\color\state <> #__s_2
            _address_\color\state = #__s_0
            _address_\_state &~ #__s_entered
          EndIf
        Else
          _address_\color\state = #__s_0
          _address_\_state &~ #__s_selected
        EndIf
      EndIf
    EndMacro
    
    Macro _multi_select_items_( _this_ )
      PushListPosition( *this\row\_s( ) ) 
      ForEach *this\row\_s( )
        If *this\row\_s( )\draw
          If Bool( ( EnterRow( )\index >= *this\row\_s( )\index And *this\row\selected\index <= *this\row\_s( )\index ) Or ; верх
                   ( *this\row\selected\index >= *this\row\_s( )\index And EnterRow( )\index <= *this\row\_s( )\index ) )  ; вниз
            
            If *this\row\_s( )\color\state <> #__s_2
              *this\row\_s( )\color\state = #__s_2
              Repaint | #True
            EndIf
            
          Else
            
            If *this\row\_s( )\color\state <> #__s_0
              *this\row\_s( )\color\state = #__s_0
              
              ; example( sel 5;6;7, click 5, no post change )
              If *this\row\_s( )\_state & #__s_selected
                *this\row\_s( )\_state &~ #__s_selected
              EndIf
              
              Repaint | #True
            EndIf
            
          EndIf
        EndIf
      Next
      PopListPosition( *this\row\_s( ) ) 
    EndMacro
    
    
    Procedure.l ListView_Events( *this._s_WIDGET, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected Repaint
      
      If eventtype = #__event_DragStart
        Post( #__event_DragStart, *this, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #__event_Focus
        PushListPosition( *this\row\_s( ) ) 
        ForEach *this\row\_s( )
          If *this\row\_s( )\color\state = #__s_3
            *this\row\_s( )\color\state = #__s_2
            *this\row\_s( )\_state | #__s_selected
          EndIf
        Next
        PopListPosition( *this\row\_s( ) ) 
        
        ; Post( #__event_Focus, *this, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #__event_LostFocus
        PushListPosition( *this\row\_s( ) ) 
        ForEach *this\row\_s( )
          If *this\row\_s( )\color\state = #__s_2
            *this\row\_s( )\color\state = #__s_3
            *this\row\_s( )\_state &~ #__s_selected
          EndIf
        Next
        PopListPosition( *this\row\_s( ) ) 
        
        ; Post( #__event_lostFocus, *this, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #__event_LeftButtonUp
        If *this\row\selected 
          If *this\mode\check = #__m_multiselect
            EnterRow( ) = *this\row\selected
          EndIf
          
          If *this\mode\check <> #__m_clickselect 
            If *this\row\selected\_state & #__s_selected = #False
              *this\row\selected\_state | #__s_selected
              Post( #__event_Change, *this, *this\row\selected\index )
              Repaint | #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__event_LeftClick
        Post( #__event_LeftClick, *this, EnterRow( )\index )
        Repaint | #True
      EndIf
      
      If eventtype = #__event_LeftDoubleClick
        Post( #__event_LeftDoubleClick, *this, EnterRow( )\index )
        Repaint | #True
      EndIf
      
      If eventtype = #__event_RightClick
        Post( #__event_RightClick, *this, EnterRow( )\index )
        Repaint | #True
      EndIf
      
      
      If eventtype = #__event_MouseEnter Or
         eventtype = #__event_MouseMove Or
         eventtype = #__event_MouseLeave Or
         eventtype = #__event_RightButtonDown Or
         eventtype = #__event_LeftButtonDown ;Or eventtype = #__event_leftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws( )
            ; If *this\row\draws( )\draw
            If Atpoint( *this, mouse_x, mouse_y, [#__c_inner] ) And 
               Atpoint( *this\row\draws( ),
                        mouse_x + *this\scroll\h\bar\page\pos,
                        mouse_y + *this\scroll\v\bar\page\pos )
              
              ;  
              If Not *this\row\draws( )\_state & #__s_entered 
                *this\row\draws( )\_state | #__s_entered 
                
                ; 
                If Not mouse( )\buttons
                  EnterRow( ) = *this\row\draws( )
                EndIf
                
                If *this\row\draws( )\color\state = #__s_0
                  *this\row\draws( )\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                ;
                If Not ( mouse( )\buttons And *this\mode\check )
                  Post( #__event_StatusChange, *this, *this\row\draws( )\index )
                  Repaint | #True
                EndIf
              EndIf
              
              If mouse( )\buttons
                If *this\mode\check
                  *this\row\selected = *this\row\draws( )
                  
                  ; clickselect items
                  If *this\mode\check = #__m_clickselect
                    If eventtype = #__event_LeftButtonDown
                      If *this\row\draws( )\_state & #__s_selected 
                        *this\row\draws( )\_state &~ #__s_selected
                        *this\row\draws( )\color\state = #__s_1
                      Else
                        *this\row\draws( )\_state | #__s_selected
                        *this\row\draws( )\color\state = #__s_2
                      EndIf
                      
                      Post( #__event_Change, *this, *this\row\draws( )\index )
                      Repaint | #True
                    EndIf
                  EndIf
                  
                  If *this\row\selected
                    PushListPosition( *this\row\_s( ) ) 
                    ForEach *this\row\_s( )
                      If *this\row\_s( )\draw
                        If Bool( ( EnterRow( )\index >= *this\row\_s( )\index And *this\row\selected\index <= *this\row\_s( )\index ) Or ; верх
                                 ( EnterRow( )\index <= *this\row\_s( )\index And *this\row\selected\index >= *this\row\_s( )\index ) )  ; вниз
                          
                          If *this\mode\check = #__m_clickselect
                            If EnterRow( )\_state & #__s_selected
                              If *this\row\_s( )\color\state <> #__s_2
                                *this\row\_s( )\color\state = #__s_2
                                
                                If *this\row\_s( )\_state & #__s_selected = #False
                                  ; entered to no selected
                                  Post( #__event_Change, *this, *this\row\_s( )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\row\_s( )\_state & #__s_entered
                              If *this\row\_s( )\color\state <> #__s_1
                                *this\row\_s( )\color\state = #__s_1
                                
                                If *this\row\_s( )\_state & #__s_selected
                                  If EnterRow( )\_state & #__s_selected = #False
                                    ; entered to selected
                                    Post( #__event_Change, *this, *this\row\_s( )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          ; multiselect items
                          If *this\mode\check = #__m_multiselect
                            If *this\row\_s( )\color\state <> #__s_2
                              *this\row\_s( )\color\state = #__s_2
                              Repaint | #True
                              
                              ; reset select before this 
                              ; example( sel 5;6;7, click 7, reset 5;6 )
                            ElseIf eventtype = #__event_LeftButtonDown
                              If *this\row\selected <> *this\row\_s( )
                                *this\row\_s( )\color\state = #__s_0
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                        Else
                          
                          If *this\mode\check = #__m_clickselect
                            If *this\row\_s( )\_state & #__s_selected 
                              If *this\row\_s( )\color\state <> #__s_2
                                *this\row\_s( )\color\state = #__s_2
                                
                                If EnterRow( )\_state & #__s_selected = #False
                                  ; leaved from selected
                                  Post( #__event_Change, *this, *this\row\_s( )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\row\_s( )\_state & #__s_entered = #False
                              If *this\row\_s( )\color\state <> #__s_0
                                *this\row\_s( )\color\state = #__s_0
                                
                                If EnterRow( )\_state & #__s_selected
                                  If *this\row\_s( )\_state & #__s_selected = #False
                                    ; leaved from no selected
                                    Post( #__event_Change, *this, *this\row\_s( )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          If *this\mode\check = #__m_multiselect
                            If *this\row\_s( )\color\state <> #__s_0
                              *this\row\_s( )\color\state = #__s_0
                              
                              ; example( sel 5;6;7, click 5, no post change )
                              If *this\row\_s( )\_state & #__s_selected
                                *this\row\_s( )\_state &~ #__s_selected
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                          
                        EndIf
                      EndIf
                    Next
                    PopListPosition( *this\row\_s( ) ) 
                  EndIf
                Else
                  If *this\row\selected And
                     *this\row\selected <> *this\row\draws( )
                    *this\row\selected\_state &~ #__s_selected
                    *this\row\selected\color\state = #__s_0
                  EndIf
                  
                  *this\row\draws( )\color\state = #__s_2
                  *this\row\selected = *this\row\draws( )
                  ; *this\change =- _tree_items_scroll_y_( *this\scroll\v, *this\row\selected\y, *this\row\selected\height )
                  Repaint | #True
                EndIf
              EndIf
              
            ElseIf *this\row\draws( )\_state & #__s_entered
              *this\row\draws( )\_state &~ #__s_entered 
              
              
              If *this\row\draws( )\color\state = #__s_1
                *this\row\draws( )\color\state = #__s_0
              EndIf
              
              ;
              If mouse( )\buttons And *this\mode\check
                If *this\mode\check = #__m_multiselect
                  If *this\row\draws( )\_state & #__s_selected = #False
                    *this\row\draws( )\_state | #__s_selected
                  EndIf
                  
                  Post( #__event_Change, *this, *this\row\draws( )\index )
                EndIf
              EndIf
              
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      
      If eventtype = #__event_MouseWheelX
        Repaint | Bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
      EndIf
      
      If eventtype = #__event_MouseWheelY
        Repaint | Bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
      EndIf
      
      
      ;- widget::ListView_Events_Key
      If eventtype = #__event_KeyDown 
        Protected *current._s_rows
        Protected result, from =- 1
        Static cursor_change, Down
        
        If _is_focused_( *this )
          
          If *this\mode\check = #__m_clickselect
            *current = EnterRow( )
          Else
            *current = *this\row\selected
          EndIf
          
          Select keyboard( )\key
            Case #PB_Shortcut_Space
              If *this\mode\check = #__m_clickselect 
                If *current\_state & #__s_selected
                  *current\_state &~ #__s_selected
                  *current\color\state = #__s_1
                Else
                  *current\_state | #__s_selected
                  *current\color\state = #__s_2
                  *this\row\selected = *current
                EndIf
                
                Post( #__event_Change, *this, *current\index )
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageUp
              ; TODO scroll to first visible
              If bar_SetState( *this\scroll\v, 0 ) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageDown
              ; TODO scroll to last visible
              If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\end ) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up,
                 #PB_Shortcut_Home
              
              If *current
                If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  ; scroll to top
                  If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - 18 ) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *current\index > 0
                  ; select modifiers key item
                  If ( keyboard( )\key = #PB_Shortcut_Home Or
                       ( keyboard( )\key[1] & #PB_Canvas_Alt ) )
                    SelectElement( *this\row\_s( ), 0 )
                  Else
                    _select_prev_item_( *this\row\_s( ), *current\index )
                  EndIf
                  
                  If *current <> *this\row\_s( )
                    If *current 
                      _set_state_list_( *current, #False )
                    EndIf
                    _set_state_list_( *this\row\_s( ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      *this\row\selected = *this\row\_s( )
                    EndIf
                    
                    If Not keyboard( )\key[1] & #PB_Canvas_Shift
                      EnterRow( ) = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = *this\row\_s( )
                    *this\change =- _tree_items_scroll_y_( *this\scroll\v, *current\y, *current\height )
                    Post( #__event_Change, *this, *current\index )
                    Repaint = 1
                  EndIf
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Down,
                 #PB_Shortcut_End
              
              If *current
                If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + 18 ) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *current\index < ( *this\count\items - 1 )
                  ; select modifiers key item
                  If ( keyboard( )\key = #PB_Shortcut_End Or
                       ( keyboard( )\key[1] & #PB_Canvas_Alt ) )
                    SelectElement( *this\row\_s( ), ( *this\count\items - 1 ) )
                  Else
                    _select_next_item_( *this\row\_s( ), *current\index )
                  EndIf
                  
                  If *current <> *this\row\_s( )
                    If *current 
                      _set_state_list_( *current, #False )
                    EndIf
                    _set_state_list_( *this\row\_s( ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      *this\row\selected = *this\row\_s( )
                    EndIf
                    
                    If Not keyboard( )\key[1] & #PB_Canvas_Shift
                      EnterRow( ) = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = *this\row\_s( )
                    *this\change =- _tree_items_scroll_y_( *this\scroll\v, *current\y, *current\height )
                    Post( #__event_Change, *this, *current\index )
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Left
              If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( keyboard( )\key[1] & #PB_Canvas_Control )
                
                *this\change = bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end/10 ) ) 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Right
              If ( keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( keyboard( )\key[1] & #PB_Canvas_Control )
                
                *this\change = bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end/10 ) ) 
                Repaint = 1
              EndIf
              
          EndSelect
          
          If *this\mode\check = #__m_clickselect
            EnterRow( ) = *current
          Else
            *this\row\selected = *current
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  WINDOW - e
    Procedure   Window_Update( *this._s_WIDGET )
      If *this\type = #__type_window
        ; чтобы закруглять только у окна с титлебаром
        If *this\fs[2]
          If *this\round
            *this\caption\round = *this\round
            *this\round = 0
          EndIf
        EndIf
        
        ; caption title bar
        If Not *this\caption\hide
          *this\caption\x = *this\x[#__c_frame]
          *this\caption\y = *this\y[#__c_frame]
          *this\caption\width = *this\width[#__c_frame] ; - *this\fs*2
          
          *this\caption\height = *this\BarHeight + *this\fs  
          If *this\caption\height > *this\height[#__c_frame] - *this\fs ;*2
            *this\caption\height = *this\height[#__c_frame] - *this\fs  ;*2
          EndIf
          
          ; 
          *this\caption\x[#__c_inner] = *this\caption\x + *this\fs
          *this\caption\y[#__c_inner] = *this\caption\y + *this\fs
          *this\caption\width[#__c_inner] = *this\caption\width - *this\fs*2
          *this\caption\height[#__c_inner] = *this\caption\height - *this\fs*2
          
          ; caption close button
          If Not *this\caption\button[#__wb_close]\hide
            *this\caption\button[#__wb_close]\x =  ( *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] ) - ( *this\caption\button[#__wb_close]\width + *this\caption\_padding ) 
            *this\caption\button[#__wb_close]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_close]\height )/2
          EndIf
          
          ; caption maximize button
          If Not *this\caption\button[#__wb_maxi]\hide
            If *this\caption\button[#__wb_close]\hide
              *this\caption\button[#__wb_maxi]\x = ( *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] ) - ( *this\caption\button[#__wb_maxi]\width + *this\caption\_padding )
            Else
              *this\caption\button[#__wb_maxi]\x = *this\caption\button[#__wb_close]\x - ( *this\caption\button[#__wb_maxi]\width + *this\caption\_padding )
            EndIf
            *this\caption\button[#__wb_maxi]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_maxi]\height )/2
          EndIf
          
          ; caption minimize button
          If Not *this\caption\button[#__wb_mini]\hide
            If *this\caption\button[#__wb_maxi]\hide
              *this\caption\button[#__wb_mini]\x = *this\caption\button[#__wb_close]\x - ( *this\caption\button[#__wb_mini]\width + *this\caption\_padding )
            Else
              *this\caption\button[#__wb_mini]\x = *this\caption\button[#__wb_maxi]\x - ( *this\caption\button[#__wb_mini]\width + *this\caption\_padding )
            EndIf
            *this\caption\button[#__wb_mini]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_mini]\height )/2
          EndIf
          
          ; caption help button
          If Not *this\caption\button[#__wb_help]\hide
            If Not *this\caption\button[#__wb_mini]\hide
              *this\caption\button[#__wb_help]\x = *this\caption\button[#__wb_mini]\x - ( *this\caption\button[#__wb_help]\width + *this\caption\_padding )
            ElseIf Not *this\caption\button[#__wb_maxi]\hide
              *this\caption\button[#__wb_help]\x = *this\caption\button[#__wb_maxi]\x - ( *this\caption\button[#__wb_help]\width + *this\caption\_padding )
            Else
              *this\caption\button[#__wb_help]\x = *this\caption\button[#__wb_close]\x - ( *this\caption\button[#__wb_help]\width + *this\caption\_padding )
            EndIf
            *this\caption\button[#__wb_help]\y = *this\caption\button[#__wb_close]\y
          EndIf
          
          ; title bar width
          If Not *this\caption\button[#__wb_help]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[#__wb_help]\x - *this\caption\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[#__wb_mini]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[#__wb_mini]\x - *this\caption\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[#__wb_maxi]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[#__wb_maxi]\x - *this\caption\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[#__wb_close]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[#__wb_close]\x - *this\caption\x[#__c_inner] - *this\caption\_padding
          EndIf
          
          
        EndIf
      EndIf
    EndProcedure
    
    Procedure   _Window_Draw( *this._s_WIDGET )
      Protected caption_height = *this\caption\height - *this\fs 
      
      With *this 
        ; чтобы закруглять только у окна с титлебаром
        Protected round = \round ; Bool( Not \caption\height )*\round
        Protected fheight = Bool( \height[#__c_frame] - \fs[2]>0 ) * ( \height[#__c_frame] - caption_height )
        Protected iwidth = Bool( \width[#__c_frame] - \fs*2> - 2 )*( \width[#__c_frame] - \fs*2 + 2 )
        Protected iheight = Bool( \height[#__c_frame] - \fs*2 - caption_height> - 2 )*( \height[#__c_frame] - \fs*2 - caption_height + 2 )
        Protected i = 1
        
        ; Draw back
        If \color\back[\interact * \color\state]
          DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
          RoundBox( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,\color\back[\interact * \color\state] )
        EndIf
        
        ; draw frame back
        If \fs
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          If \fs = 1 
            For i = 1 To \caption\round
              Line( \x[#__c_frame] + i - 1,\y[#__c_frame] + caption_height - 1,1,Bool( \round )*( i - \round ),\caption\color\back[\color\state] )
              Line( \x[#__c_frame] + \width[#__c_frame] + i - \round - 1,\y[#__c_frame] + caption_height - 1,1, - Bool( \round )*( i ),\caption\color\back[\color\state] )
            Next
          Else
            For i = 1 To \fs
              RoundBox( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i - 1, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2 + 2,\round,\round, \caption\color\back[\color\state] )
              RoundBox( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2,\round,\round, \caption\color\back[\color\state] )
            Next
          EndIf
        EndIf 
        
        ; frame draw
        If \fs
          DrawingMode( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
          If \fs = 1 
            RoundBox( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
          Else
            ; draw out frame
            RoundBox( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
            
            ; draw inner frame 
            If \type = #__type_ScrollArea Or \type = #__type_MDI ; \scroll And \scroll\v And \scroll\h
              RoundBox( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \scroll\v\color\line )
            Else
              RoundBox( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \color\frame[\color\state] )
            EndIf
          EndIf
        EndIf
        
        
        If caption_height
          ; Draw caption back
          If \caption\color\back 
            DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
            _draw_gradient_( 0, \caption, \caption\color\fore[\color\state], \caption\color\back[\color\state] )
          EndIf
          
          ; Draw caption frame
          If \fs
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            RoundBox( \caption\x, \caption\y, \caption\width, caption_height - 1,\caption\round,\caption\round,\color\frame[\color\state] )
            
            ; erase the bottom edge of the frame
            DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
            BackColor( \caption\color\fore[\color\state] )
            FrontColor( \caption\color\back[\color\state] )
            
            ;Protected i
            For i = \caption\round/2 + 2 To caption_height - 1
              Line( \x[#__c_frame],\y[#__c_frame] + i,\width[#__c_frame],1, \caption\color\back[\color\state] )
            Next
            
            ; two edges of the frame
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            Line( \x[#__c_frame],\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
            Line( \x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
          EndIf
          
          ; buttins background
          DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
          _draw_box_button_( \caption\button[#__wb_close], color\back )
          _draw_box_button_( \caption\button[#__wb_maxi], color\back )
          _draw_box_button_( \caption\button[#__wb_mini], color\back )
          _draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          _draw_close_button_( \caption\button[#__wb_close], 6 )
          _draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          _draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          _draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; Draw image
          If \image\id
            DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
            DrawAlphaImage( \image\id,
                            *this\x[#__c_frame] + *this\bs + *this\x[#__c_required] + \image\x,
                            *this\y[#__c_frame] + *this\bs + *this\y[#__c_required] + \image\y - 2, \color\_alpha )
          EndIf
          
          If \caption\text\string
            _clip_caption_( *this )
            
            ; Draw string
            If \resize & #__resize_change
              If \image\id
                \caption\text\x = \caption\x[#__c_inner] + \caption\text\padding\x + \image\width + 10;\image\padding\x
              Else
                \caption\text\x = \caption\x[#__c_inner] + \caption\text\padding\x
              EndIf
              \caption\text\y = \caption\y[#__c_inner] + ( \caption\height[#__c_inner] - TextHeight( "A" ) )/2
            EndIf
            
            DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            ;             RoundBox( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
          EndIf
        EndIf
        
        _clip_content_( *this, [#__c_clip2] )
        
        ; background image draw 
        If *this\image[#__img_background]\id
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          DrawAlphaImage( *this\image[#__img_background]\id,
                          *this\x[#__c_inner] + *this\image[#__img_background]\x, 
                          *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
        EndIf
        
        _clip_content_( *this, [#__c_clip] )
        
        ; UnclipOutput()
        ; DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
        ; RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; RoundBox( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure   Window_Draw( *this._s_WIDGET )
      Protected color_inner_line
      Protected window_color_state = *this\color\state
      Protected caption_height = *this\caption\height - *this\fs 
      
      With *this 
        
        ; чтобы закруглять только у окна с титлебаром
        Protected _round_ = 9, round = \round ; Bool( Not caption_height )*\round
        
        ; frame draw
        Protected _fore_color1_ = *this\color\fore[window_color_state]&$FFFFFF | 255<<24 ; $e0F8F8F8 ; 
        Protected _back_color1_ = *this\color\back[window_color_state]&$FFFFFF | 255<<24 ; $e0E2E2E2 ; 
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If \fs[2] 
          DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
          RoundBox(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], caption_height, _round_,_round_)
          
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          RoundBox( \x[#__c_frame], \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          RoundBox( \x[#__c_frame]+\width[#__c_frame]-caption_height, \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          
          DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
          RoundBox(*this\x[#__c_frame]+1, *this\y[#__c_frame]+1, *this\width[#__c_frame]-2, caption_height, _round_,_round_)
          Box( \x[#__c_frame], \y[#__c_frame]+caption_height/2, \width[#__c_frame], \fs[2]-caption_height/2+\fs, \caption\color\back[window_color_state] )
        EndIf
        
        DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
        Box( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, \color\back[0] )
        
        If \fs
          If \fs = 1 
            DrawingMode( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
            RoundBox( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], \height[#__c_frame], round, round, \color\frame[window_color_state] )
          Else
            If \type = #__type_ScrollArea Or \type = #__type_MDI
              color_inner_line = \scroll\v\color\line
            Else                                                                                             
              color_inner_line = \color\frame[window_color_state]
            EndIf
            
            DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
            RoundBox( \x[#__c_frame], \y[#__c_inner] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            RoundBox( \x[#__c_frame], \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            RoundBox( \x[#__c_frame]+\width[#__c_frame]-\fs, \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            RoundBox( \x[#__c_frame], \y[#__c_frame]+\height[#__c_frame] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            
            ; draw inner frame 
            DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            RoundBox( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, round, round, color_inner_line )
            
            ; draw out frame
            ;RoundBox( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[window_color_state] )
            Line(\x[#__c_frame]+caption_height/2, \y[#__c_frame], \width[#__c_frame]-caption_height, 1, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame] + \width[#__c_frame] - 1, \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame] + \height[#__c_frame] - 1, \width[#__c_frame], 1, color_inner_line)
          EndIf
        EndIf
        
        
        If caption_height
          ; buttins background
          DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
          _draw_box_button_( \caption\button[#__wb_close], color\back )
          _draw_box_button_( \caption\button[#__wb_maxi], color\back )
          _draw_box_button_( \caption\button[#__wb_mini], color\back )
          _draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          _draw_close_button_( \caption\button[#__wb_close], 6 )
          _draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          _draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          _draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; draw caption image
          If \image\id
            DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
            DrawAlphaImage( \image\id,
                            *this\x[#__c_frame] + *this\bs + *this\x[#__c_required] + \image\x,
                            *this\y[#__c_frame] + *this\bs + *this\y[#__c_required] + \image\y - 2, \color\_alpha )
          EndIf
          
          ; draw caption text
          If \caption\text\string
            ;_clip_caption_( *this )
            
            ; Draw string
            If \resize & #__resize_change
              If \image\id
                \caption\text\x = \caption\x[#__c_inner] + \caption\text\padding\x + \image\width + 10;\image\padding\x
              Else
                \caption\text\x = \caption\x[#__c_inner] + \caption\text\padding\x
              EndIf
              \caption\text\y = \caption\y[#__c_inner] + ( \caption\height[#__c_inner] - TextHeight( "A" ) )/2
            EndIf
            
            DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[window_color_state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
            ;             RoundBox( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
          EndIf
        EndIf
        
        ; ;         _clip_content_( *this, [#__c_clip2] )
        ; ;         
        ; ;         ; background image draw 
        ; ;         If *this\image[#__img_background]\id
        ; ;           DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
        ; ;           DrawAlphaImage( *this\image[#__img_background]\id,
        ; ;                           *this\x[#__c_inner] + *this\image[#__img_background]\x, 
        ; ;                           *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
        ; ;         EndIf
        ; ;         
        ; ;         _clip_content_( *this, [#__c_clip] )
        ; ;         
        ; ;         ; UnclipOutput()
        ; ;         ; DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
        ; ;         ; RoundBox( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; ;         ; RoundBox( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure   Window_SetState( *this._s_WIDGET, state.l )
      Protected.b result
      
      ; restore state
      If state = #__Window_Normal
        If Not Post( #__event_restoreWindow, *this )
          If *this\resize & #__resize_minimize
            *this\resize &~ #__resize_minimize
            *this\caption\button[#__wb_close]\hide = 0
            *this\caption\button[#__wb_mini]\hide = 0
          EndIf
          *this\resize &~ #__resize_maximize
          *this\resize | #__resize_restore
          
          SetAlignment( *this, #__align_none )
          Resize( *this, *this\root\x[#__c_rootrestore], *this\root\y[#__c_rootrestore], 
                  *this\root\width[#__c_rootrestore], *this\root\height[#__c_rootrestore] )
          
          If _is_root_( *this )
            PostEvent( #PB_Event_RestoreWindow, *this\root\canvas\window, *this )
          EndIf
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post( #__event_MaximizeWindow, *this )
          If Not *this\resize & #__resize_minimize
            *this\root\x[#__c_rootrestore] = *this\x[#__c_container]
            *this\root\y[#__c_rootrestore] = *this\y[#__c_container]
            *this\root\width[#__c_rootrestore] = *this\width[#__c_frame]
            *this\root\height[#__c_rootrestore] = *this\height[#__c_frame]
          EndIf
          
          *this\resize | #__resize_maximize
          Resize( *this, 0,0, *this\parent\width[#__c_container], *this\parent\height[#__c_container] )
          
          If _is_root_( *this )
            PostEvent( #PB_Event_MaximizeWindow, *this\root\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post( #__event_MinimizeWindow, *this )
          If Not *this\resize & #__resize_maximize
            *this\root\x[#__c_rootrestore] = *this\x[#__c_container]
            *this\root\y[#__c_rootrestore] = *this\y[#__c_container]
            *this\root\width[#__c_rootrestore] = *this\width[#__c_frame]
            *this\root\height[#__c_rootrestore] = *this\height[#__c_frame]
          EndIf
          
          *this\caption\button[#__wb_close]\hide = 1
          If *this\caption\button[#__wb_maxi]\hide = 0
            *this\caption\button[#__wb_mini]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize( *this, *this\root\x[#__c_rootrestore], *this\parent\height[#__c_container] - *this\fs[2], *this\root\width[#__c_rootrestore], *this\fs[2] )
          SetAlignment( *this, #__align_bottom )
          
          If _is_root_( *this )
            PostEvent( #PB_Event_MinimizeWindow, *this\root\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_Close( *this._s_WIDGET )
      Protected.b result
      
      ; close window
      If Not Post( #__event_closeWindow, *this )
        Free( *this )
        
        If _is_root_( *this )
          PostEvent( #PB_Event_CloseWindow, *this\root\canvas\window, *this )
        EndIf
        
        result = #True
      EndIf
    EndProcedure
    
    Procedure   Window_Events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      
      If eventtype = #__event_Focus
        *this\color\state = #__s_2
        Post( eventtype, *this )
        Repaint = #True
      EndIf
      
      If eventtype = #__event_LostFocus
        *this\color\state = #__s_3
        Post( eventtype, *this )
        Repaint = #True
      EndIf
      
      If eventtype = #__event_MouseEnter
        Repaint = #True
      EndIf
      
      If eventtype = #__event_MouseMove
        If _is_selected_( *this )
          ;           If *this\container = #__type_root
          ;             ResizeWindow(*this\root\canvas\window, (DesktopMouseX() - *this\root\mouse\delta\x), (DesktopMouseY() - *this\root\mouse\delta\y), #PB_Ignore, #PB_Ignore)
          ;           Else
          Repaint = Resize(*this, (mouse_x - mouse()\delta\x), (mouse_y - mouse()\delta\y), #PB_Ignore, #PB_Ignore)
          ;           EndIf
        EndIf
      EndIf
      
      If eventtype = #__event_MouseLeave
        Repaint = #True
      EndIf
      
      ;       If eventtype = #__event_MouseMove
      ;         If _is_selected_( *this )
      ;           If *this = *this\root\canvas\container
      ;             ResizeWindow( *this\root\canvas\window, ( DesktopMousex( ) - mouse( )\delta\x ), ( DesktopMouseY( ) - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           Else
      ;             Repaint = Resize( *this, ( mouse_x - mouse( )\delta\x ), ( mouse_y - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           EndIf
      ;         EndIf
      ;       EndIf
      
      If eventtype = #__event_LeftClick
        If *this\type = #__type_Window
          *this\caption\interact = Atpoint( *this\caption, mouse_x, mouse_y, [2] )
          ;*this\color\state = 2
          
          ; close button
          If Atpoint( *this\caption\button[#__wb_close], mouse_x, mouse_y )
            ProcedureReturn Window_close( *this )
          EndIf
          
          ; maximize button
          If Atpoint( *this\caption\button[#__wb_maxi], mouse_x, mouse_y )
            If Not *this\resize & #__resize_maximize And
               Not *this\resize & #__resize_minimize
              
              ProcedureReturn Window_SetState( *this, #__window_maximize )
            Else
              ProcedureReturn Window_SetState( *this, #__window_normal )
            EndIf
          EndIf
          
          ; minimize button
          If Atpoint( *this\caption\button[#__wb_mini], mouse_x, mouse_y )
            If Not *this\resize & #__resize_minimize
              ProcedureReturn Window_SetState( *this, #__window_minimize )
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Procedure.b IsContainer( *this._s_WIDGET )
      ProcedureReturn *this\container
    EndProcedure
    
    Procedure.i GetItem( *this._s_WIDGET, parent_sublevel.l =- 1 )
      Protected result
      Protected *row._s_rows
      Protected *widget._s_WIDGET
      
      If *this 
        If parent_sublevel =- 1
          *widget = *this
          result = *widget\tabindex
          
        Else
          *row = *this
          
          While *row And *row <> *row\parent
            
            If parent_sublevel = *row\parent\sublevel
              result = *row
              Break
            EndIf
            
            *row = *row\parent
          Wend
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Flag( *this._s_WIDGET, flag.i=#Null, state.b =- 1 )
      Protected result
      
      If Not flag
        result = *this\flag
        ;       If *this\type = #__type_Button
        ;         ;         If *this\text\align\left
        ;         ;           result | #__button_left
        ;         ;         EndIf
        ;         ;         If *this\text\align\right
        ;         ;           result | #__button_right
        ;         ;         EndIf
        ;         ;         If *this\text\multiline
        ;         ;           result | #__button_multiline
        ;         ;         EndIf
        ;         ;         If *this\flag & #__button_toggle
        ;         ;           result | #__button_toggle
        ;         ;         EndIf
        ;       EndIf
      Else
        If state =- 1
          result = Bool( *this\flag & flag )
        Else
          If state 
            *this\flag | flag
          Else
            *this\flag &~ flag
          EndIf
          
          If *this\type = #__type_Button Or
             *this\type = #__type_Editor Or
             *this\type = #__type_String Or
             *this\type = #__type_Text
            ; commons
            If Flag & #__flag_vertical
              *this\vertical = state
              *this\text\change = #True
            EndIf
            
            If flag & #__text_invert
              *this\text\invert = state 
              *this\text\change = #True
            EndIf
          EndIf
          
          If *this\text\change
            If *this\text\invert 
              If *this\vertical
                *this\text\rotate = 270 
              Else
                *this\text\rotate = 180
              EndIf
            Else
              *this\text\rotate = Bool( *this\vertical ) * 90
            EndIf
          EndIf
          
          If flag & #__text_top
            *this\text\change = #__text_update
            *this\text\align\bottom = 0
            *this\text\align\top = state
          EndIf
          If flag & #__text_bottom
            *this\text\change = #__text_update
            *this\text\align\top = 0
            *this\text\align\bottom = state
            
            *this\image\change = #__text_update
            *this\image\align\top = 0
            *this\image\align\bottom = state
          EndIf
          If flag & #__text_left
            *this\text\change = #__text_update
            *this\text\align\right = 0
            *this\text\align\left = state
          EndIf
          If flag & #__text_right
            *this\text\change = #__text_update
            *this\text\align\left = 0
            *this\text\align\right = state
            
            *this\image\change = #__text_update
            *this\image\align\left = 0
            *this\image\align\right = state
          EndIf
          
          If flag & #__text_multiline
            *this\text\change = #__text_update
            *this\text\multiline = state
          EndIf
          
          If flag & #__text_wordwrap
            *this\text\change = #__text_update
            *this\text\multiline =- state
          EndIf
          
          If *this\type = #__type_Button
            If flag & #__button_default
              ; *this\text\align\left = state
            EndIf
            ;             If flag & #__button_left
            ;               *this\text\align\right = 0
            ;               *this\text\align\left = state
            ;             EndIf
            ;             If flag & #__button_right
            ;               *this\text\align\left = 0
            ;               *this\text\align\right = state
            ;             EndIf
            ;             If flag & #__button_multiline
            ;               *this\text\change = #__text_update
            ;               *this\text\multiline = state
            ;             EndIf
            If flag & #__button_toggle
              If state 
                *this\_state | #__s_checked
                *this\color\state = #__s_2
              Else
                *this\_state &~ #__s_checked
                *this\color\state = #__s_0
              EndIf
            EndIf
            
            *this\change = 1
          EndIf
          
          If *this\type = #__type_Tree Or
             *this\type = #__type_ListView Or
             *this\type = #__type_property
            
            If flag & #__list_nolines
              *this\mode\lines = Bool( state ) * #__tree_linesize
            EndIf
            If flag & #__tree_nobuttons
              *this\mode\buttons = state
              
              If *this\count\items
                If *this\flag & #__tree_optionboxes
                  PushListPosition( *this\row\_s( ) )
                  ForEach *this\row\_s( )
                    If *this\row\_s( )\parent And 
                       *this\row\_s( )\parent\childrens
                      *this\row\_s( )\sublevel = state
                    EndIf
                  Next
                  PopListPosition( *this\row\_s( ) )
                EndIf
              EndIf
            EndIf
            If flag & #__tree_checkboxes
              If *this\flag & #__tree_optionboxes
                *this\mode\check = Bool( state ) * #__m_optionselect
              Else
                *this\mode\check = Bool( state )
              EndIf
            EndIf
            If flag & #__tree_threestate
              If *this\flag & #__tree_checkboxes
                *this\mode\threestate = state
              Else
                *this\mode\threestate = 0
              EndIf
            EndIf
            If flag & #__tree_clickselect
              *this\mode\check = Bool( state ) * #__m_clickselect
            EndIf
            If flag & #__tree_multiselect
              *this\mode\check = Bool( state ) * #__m_multiselect
            EndIf
            If flag & #__tree_optionboxes
              If state 
                *this\mode\check = #__m_optionselect
              Else
                *this\mode\check = Bool( *this\flag & #__tree_checkboxes )
              EndIf
              
              ; set option group
              If *this\count\items
                PushListPosition( *this\row\_s( ) )
                ForEach *this\row\_s( )
                  If *this\row\_s( )\parent
                    *this\row\_s( )\checkbox\state = #PB_Checkbox_Unchecked
                    *this\row\_s( )\option_group = Bool( state ) * GetItem( *this\row\_s( ), 0 ) 
                  EndIf
                Next
                PopListPosition( *this\row\_s( ) )
              EndIf
            EndIf
            If flag & #__tree_gridlines
              *this\mode\gridlines = state
            EndIf
            If flag & #__tree_collapse 
              *this\mode\collapse = state
              
              If *this\count\items
                PushListPosition( *this\row\_s( ) )
                ForEach *this\row\_s( )
                  If *this\row\_s( )\parent 
                    *this\row\_s( )\parent\button\state = state
                    *this\row\_s( )\hide = state
                  EndIf
                Next
                PopListPosition( *this\row\_s( ) )
              EndIf
              
              If *this\root
                ReDraw( *this )
              EndIf
            EndIf
            
            
            If ( *this\mode\lines Or *this\mode\buttons Or *this\mode\check ) And
               Not ( *this\flag & #__tree_property Or *this\flag & #__tree_optionboxes )
              *this\row\sublevelsize = 18 
            Else
              *this\row\sublevelsize = 0
            EndIf
            
            If *this\count\items
              *this\change = 1
            EndIf
          EndIf
          
          If flag & #__text_center
            *this\text\align\left = 0
            *this\text\align\top = 0
            *this\text\align\right = 0
            *this\text\align\bottom = 0
            
            ;           Else
            ;             If Not *this\text\align\bottom
            ;               *this\text\align\top = #True
            ;             EndIf
            ;             
            ;             If Not *this\text\align\right
            ;               *this\text\align\left = #True 
            ;             EndIf
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Disable( *this._s_WIDGET, State.b =- 1 )
      If State =- 1
        ProcedureReturn Bool( *this\_state & #__s_disabled )
      Else
        If *this\_state & #__s_disabled
          *this\_state &~ #__s_disabled
          ; *this\color\state = #__s_0
        Else
          *this\_state | #__s_disabled
          ; *this\color\state = #__s_3
          *this\color\state = #__s_0
        EndIf
        
        If StartEnumerate( *this )
          Widget( )\color\state = #__s_3 
          StopEnumerate( )
        EndIf
        _post_repaint_(*this\root)
      EndIf
    EndProcedure
    
    Procedure.b Hide( *this._s_WIDGET, State.b =- 1 )
      With *this
        If State =- 1
          ProcedureReturn *this\hide 
        Else
          *this\hide = State
          *this\hide[1] = *this\hide
          
          If StartEnumerate( *this ) ;  *this\container And 
            _set_hide_state_( Widget( ) )
            StopEnumerate( )
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure   Child( *this._s_WIDGET, *parent._s_WIDGET )
      Protected result 
      
      Repeat
        If *parent = *this\parent
          result = *this
          Break
        EndIf
        
        *this = *this\parent
      Until *this = *this\root
      
      ; ; ;       ;If *this And *parent
      ; ; ;       If *this\parent = *parent
      ; ; ;         result = *this
      ; ; ;       Else
      ; ; ;         While *this <> *this\root ; Not _is_root_( *this )
      ; ; ;           If *parent = *this\parent
      ; ; ;             result = *this
      ; ; ;             Break
      ; ; ;           EndIf
      ; ; ;           
      ; ; ;           *this = *this\parent
      ; ; ;         Wend
      ; ; ;       EndIf
      ; ; ;       ;EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Update( *this._s_WIDGET )
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Panel
        Bar_Update( *this\_tab )
        result = Bar_Resize( *this\_tab )  
      EndIf  
      
      If *this\type = #__type_Window
        result = Window_Update( *this )
      EndIf
      
      ; ;       If *this\type = #__type_tree
      ; ;         If StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
      ; ;           Tree_Update( *this, *this\row\_s( ) )
      ; ;           StopDrawing( )
      ; ;         EndIf
      ; ;         
      ; ;         result = 1
      ; ;       EndIf
      
      If *this\type = #__type_ScrollBar Or
         *this\type = #__type_TabBar Or *this\type = #__type_ToolBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_Splitter Or
         *this\type = #__type_Spin
        
        Bar_Update( *this )
        result = Bar_Resize( *this )  
      Else
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change( *this._s_WIDGET, ScrollPos.f )
      Select *this\type
        Case #__type_TabBar,#__type_ToolBar,
             #__type_Spin,
             #__type_Splitter,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar
          
          ProcedureReturn Bar_Change( *this, ScrollPos )
      EndSelect
    EndProcedure
    
    Procedure.l x( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\x[mode] )
    EndProcedure
    
    Procedure.l Y( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\y[mode] )
    EndProcedure
    
    Procedure.l Width( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\width[mode] )
    EndProcedure
    
    Procedure.l Height( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\height[mode] )
    EndProcedure
    
    ;- 
    Procedure.i AddColumn( *this._s_WIDGET, Position.l, Text.s, Width.l, Image.i=-1 )
      
      With *This
        ;         LastElement( \Columns( ) )
        ;         AddElement( \Columns( ) ) 
        ;         ;       Position = ListIndex( \Columns( ) )
        ;         
        ;         \Columns( )\text\string.s = Text.s
        ;         \Columns( )\text\change = 1
        ;         \Columns( )\x = \width[#__c_required]
        ;         \Columns( )\width = Width
        ;         \Columns( )\height = 24
        ;         \width[#__c_required] + Width
        ;         \height[#__c_required] = \bs*2+\Columns( )\height
        ;         ;      ; ReDraw( *This )
        ;         ;       If Position = 0
        ;         ;      ;   _post_repaint_( *this\root )
        ;         ;       EndIf
      EndWith
    EndProcedure
    
    Procedure   AddItem( *this._s_WIDGET, Item.l, Text.s, Image.i =- 1, flag.i = 0 )
      Protected result
      
      If *this\type = #__type_MDI
        *this\count\items + 1
        ;         Static pos_x, pos_y
        ;         Protected x = transform( )\grid\size, y = transform( )\grid\size, width.l = 280, height.l = 180
        ;         
        ;         ;         If transform( ) And transform( )\grid\size
        ;         ;           x = ( x/transform( )\grid\size ) * transform( )\grid\size
        ;         ;           y = ( y/transform( )\grid\size ) * transform( )\grid\size
        ;         ;           
        ;         ;           width = ( width/transform( )\grid\size ) * transform( )\grid\size - ( #__window_frame_size * 2 )%transform( )\grid\size + 1
        ;         ;           height = ( height/transform( )\grid\size ) * transform( )\grid\size - ( #__window_frame_size*2+#__window_caption_height )%transform( )\grid\size + 1
        ;         ;         EndIf
        ;         
        flag | #__window_systemmenu | #__window_sizegadget | #__window_maximizegadget | #__window_minimizegadget | #__window_child
        ;         result = Window( x + pos_x, y + pos_y, width, height, Text, flag, *this )
        ;         pos_y + y + #__window_frame_size + #__window_caption_height
        ;         pos_x + x + #__window_frame_size
        
        result = Window( #PB_Ignore, #PB_Ignore, 280, 180, Text, flag, *this )
        
        ProcedureReturn result
      EndIf
      
      If *this\type = #__type_Editor
        ProcedureReturn Editor_AddItem( *this, Item,Text, Image, flag )
      EndIf
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_property
        ProcedureReturn Tree_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_ListView
        ProcedureReturn Tree_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        ProcedureReturn Tab_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn Tab_AddItem( *this\_tab, Item,Text,Image,flag )
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure   RemoveItem( *this._s_WIDGET, Item.l )
      Protected result
      
      If *this\type = #__type_Editor
        *this\text\change = 1
        *this\count\items - 1
        
        If *this\count\items =- 1 
          *this\count\items = 0 
          *this\text\string = #LF$
          
          _post_repaint_( *this\root )
          
        Else
          *this\text\string = RemoveString( *this\text\string, StringField( *this\text\string, item + 1, #LF$ ) + #LF$ )
        EndIf
        
        result = #True
      EndIf
      
      ;- widget::tree_remove_item( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If _no_select_item_( *this\row\_s( ), Item )
          ProcedureReturn #False
        EndIf
        
        Protected sublevel = *this\row\_s( )\sublevel
        Protected *parent._s_rows = *this\row\_s( )\parent
        
        ; if is last parent item then change to the prev element of his level
        If *parent And *parent\last = *this\row\_s( )
          PushListPosition( *this\row\_s( ) )
          While PreviousElement( *this\row\_s( ) )
            If *parent = *this\row\_s( )\parent
              *parent\last = *this\row\_s( )
              Break
            EndIf
          Wend
          PopListPosition( *this\row\_s( ) )
          
          ; if the remove last parent childrens
          If *parent\last = *this\row\_s( )
            *parent\childrens = #False
            *parent\last = #Null
          Else
            *parent\childrens = #True
          EndIf
        EndIf
        
        ; before deleting a parent, we delete its children
        If *this\row\_s( )\childrens
          PushListPosition( *this\row\_s( ) )
          While NextElement( *this\row\_s( ) )
            If *this\row\_s( )\sublevel > sublevel 
              DeleteElement( *this\row\_s( ) ) 
              *this\count\items - 1 
              *this\row\count - 1
            Else
              Break
            EndIf
          Wend
          PopListPosition( *this\row\_s( ) )
        EndIf
        
        ; if the item to be removed is selected, 
        ; then we set the next item of its level as selected
        If *this\row\selected = *this\row\_s( )
          *this\row\selected\_state &~ #__s_selected
          
          ; if he is a parent then we find the next item of his level
          PushListPosition( *this\row\_s( ) )
          While NextElement( *this\row\_s( ) )
            If *this\row\_s( )\sublevel = *this\row\selected\sublevel 
              Break
            EndIf
          Wend
          
          ; if we remove the last selected then 
          If *this\row\selected = *this\row\_s( ) 
            *this\row\selected = PreviousElement( *this\row\_s( ) )
          Else
            *this\row\selected = *this\row\_s( ) 
          EndIf
          PopListPosition( *this\row\_s( ) )
          
          If *this\row\selected
            If *this\row\selected\parent And 
               *this\row\selected\parent\button\state
              *this\row\selected = *this\row\selected\parent
            EndIf 
            
            *this\row\selected\_state | #__s_selected
            *this\row\selected\color\state = #__s_2 + Bool( *this\_state & #__s_focused = #False )
          EndIf
        EndIf
        
        *this\change = 1  
        *this\count\items - 1
        DeleteElement( *this\row\_s( ) )
        _post_repaint_( *this\root )
        result = #True
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_removeItem( *this\_tab, Item )
        
      ElseIf *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        result = Tab_removeItem( *this, Item )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l CountItems( *this._s_WIDGET )
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure.l ClearItems( *this._s_WIDGET )
      Protected result
      
      ; - widget::editor_clear_items( )
      If *this\type = #__type_Editor
        *this\text\change = 1 
        *this\count\items = 0
        
        If *this\text\editable
          *this\text\string = #LF$
        EndIf
        
        _post_repaint_( *this\root )
        ProcedureReturn #True
      EndIf
      
      ; - widget::tree_clear_items( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If *this\count\items <> 0
          Post( #__event_Change, *this, #PB_All )
          
          *this\change = 1
          *this\row\count = 0
          *this\count\items = 0
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            ClearStructure(*this\row\selected, _s_rows)
            *this\row\selected = 0
          EndIf
          
          ClearList( *this\row\_s( ) )
          
          _post_repaint_( *this\root )
          ;           ReDraw( *this )
          ;           
        EndIf
      EndIf
      
      ; - Panel_ClearItems( )
      If *this\type = #__type_Panel
        result = Tab_clearItems( *this\_tab )
        
      ElseIf *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        result = Tab_clearItems( *this )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CloseList( )
      If OpenWidget( ) And 
         OpenWidget( )\parent And
         OpenWidget( )\root\canvas\gadget = Root( )\canvas\gadget 
        
        ; Debug "" + OpenWidget( ) + " - " + OpenWidget( )\class + " " + OpenWidget( )\parent + " - " + OpenWidget( )\parent\class
        If OpenWidget( )\parent\type = #__type_MDI
          OpenWidget( ) = OpenWidget( )\parent\parent
        Else
          OpenWidget( ) = OpenWidget( )\parent
        EndIf
      Else
        OpenWidget( ) = Root( )
      EndIf
    EndProcedure
    
    Procedure.i OpenList( *this._s_WIDGET, item.l = 0 )
      Protected result.i = OpenWidget( )
      
      If *this
        If *this\_tab And 
           *this\_tab\type = #__type_TabBar
          *this\_tab\bar\index = item
        EndIf
        
        OpenWidget( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure   Getwidget( index )
      Protected result
      
      If index =- 1
        ProcedureReturn Widget( )
      Else
        ForEach Widget( )
          If Widget( )\index = index ; +  1
            result = Widget( )
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Getaddress( *this._s_WIDGET )
      ProcedureReturn *this\address
    EndProcedure
    
    Procedure.l GetIndex( *this._s_WIDGET )
      ProcedureReturn *this\index ; - 1
    EndProcedure
    
    Procedure.l GetLevel( *this._s_WIDGET )
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass( *this._s_WIDGET )
      ProcedureReturn *this\class
    EndProcedure
    
    Procedure.l GetMousex( *this._s_WIDGET, mode.l = #__c_screen )
      ProcedureReturn mouse( )\x - *this\x[mode]
    EndProcedure
    
    Procedure.l GetMouseY( *this._s_WIDGET, mode.l = #__c_screen )
      ProcedureReturn mouse( )\y - *this\y[mode]
    EndProcedure
    
    Procedure.l GetDeltax( *this._s_WIDGET )
      ProcedureReturn ( mouse( )\delta\x + *this\x[#__c_container] )
    EndProcedure
    
    Procedure.l GetDeltaY( *this._s_WIDGET )
      ProcedureReturn ( mouse( )\delta\y + *this\y[#__c_container] )
    EndProcedure
    
    Procedure.l GetButtons( *this._s_WIDGET )
      ProcedureReturn mouse( )\buttons
    EndProcedure
    
    Procedure.i GetFont( *this._s_WIDGET )
      ProcedureReturn *this\text\fontID
    EndProcedure
    
    Procedure.l GetCount( *this._s_WIDGET, mode.b = #False )
      If mode
        ProcedureReturn *this\count\type
      Else
        ProcedureReturn *this\count\index
      EndIf
    EndProcedure
    
    Procedure.i GetData( *this._s_WIDGET )
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure.l GetType( *this._s_WIDGET )
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.i GetRoot( *this._s_WIDGET )
      ProcedureReturn *this\root ; Returns root element
    EndProcedure
    
    Procedure.i GetGadget( *this._s_WIDGET = #Null )
      If *this = #Null : *this = Root( ) : EndIf
      
      If _is_root_( *this )
        ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow( *this._s_WIDGET )
      If _is_root_( *this )
        ProcedureReturn *this\root\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\window ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParent( *this._s_WIDGET )
      ProcedureReturn *this\parent
    EndProcedure
    
    Procedure.i GetAttribute( *this._s_WIDGET, Attribute.l )
      Protected result.i
      
      If *this\type = #__type_Tree
        If Attribute = #__tree_collapsed  
          result = *this\mode\collapse
        EndIf
      EndIf
      
      If *this\type = #__type_Splitter
        Select Attribute 
          Case #PB_Splitter_FirstGadget       : result = *this\gadget[#__split_1]
          Case #PB_Splitter_SecondGadget      : result = *this\gadget[#__split_2]
          Case #PB_Splitter_FirstMinimumSize  : result = *this\bar\button[#__b_1]\size
          Case #PB_Splitter_SecondMinimumSize : result = *this\bar\button[#__b_2]\size
        EndSelect
      EndIf
      
      ; _is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or *this\type = #__type_MDI
        Select Attribute 
          Case #PB_ScrollArea_X               : result = *this\scroll\h\bar\page\pos
          Case #PB_ScrollArea_Y               : result = *this\scroll\v\bar\page\pos
          Case #PB_ScrollArea_InnerWidth      : result = *this\scroll\h\bar\max
          Case #PB_ScrollArea_InnerHeight     : result = *this\scroll\v\bar\max
          Case #PB_ScrollArea_ScrollStep      : result = *this\scroll\increment
        EndSelect
      EndIf
      
      If *this\type = #__type_Spin Or
         *this\type = #__type_TabBar Or *this\type = #__type_ToolBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar ; Or *this\type = #__type_Splitter
        
        Select Attribute
          Case #__bar_minimum    : result = *this\bar\min          ; 1
          Case #__bar_maximum    : result = *this\bar\max          ; 2
          Case #__bar_pagelength : result = *this\bar\page\len     ; 3
          Case #__bar_scrollstep : result = *this\scroll\increment ; 5
            
          Case #__bar_buttonsize : result = *this\bar\button[#__b_1]\size   
          Case #__bar_direction  : result = *this\bar\direction
          Case #__bar_invert   : result = *this\bar\inverted
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.f GetState( *this._s_WIDGET )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView Or
         *this\type = #__type_ListIcon
        
        If *this\row\selected
          ProcedureReturn *this\row\selected\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        ProcedureReturn Bool( *this\_state & #__s_checked )
      EndIf
      
      If *this\type = #__type_Option Or
         *this\type = #__type_CheckBox
        
        ProcedureReturn *this\button\state
      EndIf
      
      If *this\type = #__type_Editor
        ProcedureReturn *this\index[#__s_2] ; *this\text\caret\pos
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn *this\_tab\index[#__tab_2]
      EndIf
      
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        ProcedureReturn *this\index[#__tab_2] 
        
      Else
        If *this\bar
          ProcedureReturn *this\bar\page\pos
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s GetText( *this._s_WIDGET )
      If *this\type = #__type_Tree
        If *this\row\selected 
          ProcedureReturn *this\row\selected\text\string
        EndIf
      EndIf
      
      If *this\type = #__type_Window
        ProcedureReturn *this\caption\text\string
      EndIf
      
      If *this\text\pass
        ProcedureReturn *this\text\edit\string
      Else
        ProcedureReturn *this\text\string
      EndIf
    EndProcedure
    
    Procedure.l GetColor( *this._s_WIDGET, ColorType.l )
      Protected Color.l
      
      With *This
        Select ColorType
          Case #__color_line  : Color = \color\Line
          Case #__color_back  : Color = \color\Back
          Case #__color_front : Color = \color\Front
          Case #__color_frame : Color = \color\Frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;- 
    Procedure   SetCursor( *this._s_WIDGET, *cursor )
      _set_cursor_( *this, *cursor )
    EndProcedure
    
    Procedure   SetFrame( *this._s_WIDGET, size.a, mode.i = 0 )
      Protected result
      If *this\fs <> size
        result = *this\fs 
        *this\fs = size
        If mode =- 1 ; auto pos
          Resize( *this, *this\x[#__c_container]-size, *this\y[#__c_container]-size, *this\width[#__c_frame]+size*2, *this\height[#__c_frame]+size*2 )
        ElseIf mode =- 2 ; auto pos
                         ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Resize( *this, *this\x[#__c_container]-(size - result), *this\y[#__c_container]-(size - result), #PB_Ignore, #PB_Ignore  )
        Else
          Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        EndIf
      EndIf
    EndProcedure
    
    Procedure   SetClass( *this._s_WIDGET, class.s )
      *this\class = class
    EndProcedure
    
    Procedure.b SetState( *this._s_WIDGET, state.f )
      Protected result
      
      ; - widget::Button_SetState( )
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        If *this\flag & #__button_toggle
          If *this\_state & #__s_checked
            *this\_state &~ #__s_checked
            
            If *this\_state & #__s_entered
              *this\color\state = #__s_1 
            Else
              *this\color\state = #__s_0 
            EndIf
            
          ElseIf state
            *this\_state | #__s_checked
            *this\color\state = #__s_2 
          EndIf
          
          Post( #__event_Change, *this )
          result = 1
        Else
          If *this\color\state <> #__s_1
            *this\color\state = #__s_1
            result = 1
          EndIf
        EndIf
      EndIf
      
      ; - widget::CheckBox_SetState( )
      If *this\type = #__type_CheckBox
        If *this\button\state <> state
          _set_check_state_( *this\button, Bool( state = #PB_Checkbox_Inbetween ) )
          
          Post( #__event_Change, *this )
          ReDraw( *this\root )
          ProcedureReturn 1
        EndIf
      EndIf
      
      ; - widget::Option_SetState( )
      If *this\type = #__type_Option
        If *this\_group And 
           *this\button\state <> State
          
          If *this\_group\_group <> *this
            If *this\_group\_group
              *this\_group\_group\button\state = 0
            EndIf
            *this\_group\_group = *this
          EndIf
          *this\button\state = State
          
          Post( #__event_Change, *this )
          ReDraw( *this\root )
          ProcedureReturn 1
        EndIf
      EndIf
      
      ; - widget::IPaddress_SetState( )
      If *this\type = #__type_IPAddress
        If *this\index[#__s_2] <> State : *this\index[#__s_2] = State
          SetText( *this, Str( IPAddressField( State,0 ) ) + "." + 
                          Str( IPAddressField( State,1 ) ) + "." + 
                          Str( IPAddressField( State,2 ) ) + "." + 
                          Str( IPAddressField( State,3 ) ) )
        EndIf
      EndIf
      
      ; - widget::Window_SetState( )
      If *this\type = #__type_Window
        result = Window_SetState( *this, state )
      EndIf
      
      ; - widget::Editor_SetState( )
      If *this\type = #__type_Editor
        If state < 0 Or state > *this\text\len
          state = *this\text\len
        EndIf
        
        If *this\text\caret\pos <> State
          *this\text\caret\pos = State
          
          Protected i.l, len.l
          Protected *str.Character = @*this\text\string 
          Protected *end.Character = @*this\text\string 
          
          While *end\c 
            If *end\c = #LF 
              len + ( *end - *str )/#__sOC
              ; Debug "" + i + " " + Str( len + i )  + " " +  state
              
              If len + i >= state
                *this\index[#__s_1] = i
                *this\index[#__s_2] = i
                
                *this\text\caret\pos[1] = state - ( len - ( *end - *str )/#__sOC ) - i
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              i + 1
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__s_1] <> i 
            *this\index[#__s_1] = i
            *this\index[#__s_2] = i
            
            *this\text\caret\pos[1] = ( state - len - i ) 
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          result = #True 
        EndIf
      EndIf
      
      ;- widget::tree_setState
      If *this\type = #__type_Tree Or 
         *this\type = #__type_ListView
        ; Debug *this\mode\check 
        
        
        ; reset all selected items
        If State =- 1
          If *this\row\selected 
            If *this\mode\check <> #__m_optionselect
              If *this\row\selected\_state & #__s_selected
                *this\row\selected\_state &~ #__s_selected
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( #__event_Change, *this, *this\row\selected\index, - 1 )
                EndIf
              EndIf
            EndIf
            
            If *this\row\selected\_state & #__s_scrolled
              *this\row\selected\_state &~ #__s_scrolled
            EndIf
            
            *this\row\selected\color\state = #__s_0
            *this\row\selected = #Null
          EndIf
        EndIf
        
        ; 
        If _no_select_item_( *this\row\_s( ), State )
          ProcedureReturn #False
        EndIf
        
        If *this\count\items
          If *this\row\selected <> *this\row\_s( )
            If *this\row\selected 
              If *this\row\selected\_state & #__s_selected
                *this\row\selected\_state &~ #__s_selected
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( #__event_Change, *this, *this\row\selected\index, - 1 )
                EndIf
              EndIf
              
              If *this\row\selected\_state & #__s_scrolled
                *this\row\selected\_state &~ #__s_scrolled
              EndIf
              
              *this\row\selected\color\state = #__s_0
            EndIf
            
            ; click select mode 
            If *this\mode\check = #__m_clickselect
              If *this\row\_s( )\_state & #__s_selected 
                *this\row\_s( )\_state &~ #__s_selected
                *this\row\_s( )\color\state = #__s_0
              Else
                *this\row\_s( )\_state | #__s_selected
                *this\row\_s( )\color\state = #__s_3
              EndIf
              
              Post( #__event_Change, *this, *this\row\_s( )\index )
            Else
              If *this\row\_s( )\_state & #__s_selected = #False
                *this\row\_s( )\_state | #__s_selected
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( #__event_Change, *this, *this\row\_s( )\index, 1 )
                EndIf
              EndIf
              
              *this\row\_s( )\color\state = #__s_3
            EndIf
            
            *this\row\_s( )\_state | #__s_scrolled
            *this\row\selected = *this\row\_s( )
            
            ;_post_repaint_items_( *this )
            
            ;*this\change = 1
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      
      ; - Panel_SetState( )
      If *this\type = #__type_Panel
        result = Tab_SetState( *this\_tab, state )
      EndIf
      
      ; - TabBar_SetState( )
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        result = Tab_SetState( *this, state )
      EndIf
      
      Select *this\type
        Case #__type_Spin ,
             #__type_TabBar,#__type_ToolBar,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter       
          
          result = Bar_SetState( *this, state )
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetAttribute( *this._s_WIDGET, Attribute.l, *value )
      Protected result.i
      
      If *this\type = #__type_Spin Or
         *this\type = #__type_TabBar Or *this\type = #__type_ToolBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_Splitter
        result = Bar_SetAttribute( *this, Attribute, *value )
      EndIf
      
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        Select Attribute 
          Case #PB_Button_Image
            _set_image_( *this, *this\image, *value )
            _set_image_( *this, *this\image[#__img_released], *value )
            
          Case #PB_Button_PressedImage
            _set_image_( *this, *this\image[#__img_pressed], *value )
            
        EndSelect
      EndIf
      
      ;  _is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or 
         *this\type = #__type_MDI
        
        Select Attribute 
          Case #PB_ScrollArea_X 
            If Bar_SetState( *this\scroll\h, *value )
              ; *this\x[#__c_required] = *this\scroll\h\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_Y               
            If Bar_SetState( *this\scroll\v, *value )
              ; *this\y[#__c_required] = *this\scroll\v\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerWidth      
            If Bar_SetAttribute( *this\scroll\h, #__bar_maximum, *value )
              *this\width[#__c_required] = *this\scroll\h\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerHeight     
            If Bar_SetAttribute( *this\scroll\v, #__bar_maximum, *value )
              *this\height[#__c_required] = *this\scroll\v\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_ScrollStep      
            *this\scroll\increment = *value
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetText( *this._s_WIDGET, Text.s )
      Protected result.i, Len.i, String.s, i.i
      
      If *this\type = #__type_Window
        *this\caption\text\string = Text
      EndIf
      
      If *this\type = #__type_Tree
        If *this\row\selected 
          *this\row\selected\text\string = Text
        EndIf
      EndIf
      
      If *this\type = #__type_Editor ;Or *this\type = #__type_String
        
        ; If Text.s = "" : Text.s = #LF$ : EndIf
        Text.s = ReplaceString( Text.s, #LFCR$, #LF$ )
        Text.s = ReplaceString( Text.s, #CRLF$, #LF$ )
        Text.s = ReplaceString( Text.s, #CR$, #LF$ )
        ;Text + #LF$
        
        With *this
          If ListSize( *this\row\_s( ) )
            ClearItems( *this )
          EndIf
          
          If \text\edit\string.s <> Text.s
            \text\edit\string = Text.s
            \text\string.s = _text_insert_make_( *this, Text.s )
            
            If \text\string.s
              If \text\multiline
                \count\items = CountString( \text\string.s, #LF$ )
              Else
                \count\items = 1
              EndIf
              
              ;           If *this And StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
              ;             If \text\fontID 
              ;               DrawingFont( \text\fontID ) 
              ;             EndIf
              ;             
              ;             make_text_multiline( *this )
              ;             StopDrawing( )
              ;           EndIf
              
              \text\len = Len( \text\string.s )
              \text\change = #True
              
              _post_repaint_( *this\root )
              
              result = #True
            EndIf
          EndIf
        EndWith
      Else
        ;         If *this\text\multiline = 0
        ;           Text = RemoveString( Text, #LF$ )
        ;         EndIf
        
        Text = ReplaceString( Text, #LFCR$, #LF$ )
        Text = ReplaceString( Text, #CRLF$, #LF$ )
        Text = ReplaceString( Text, #CR$, #LF$ )
        ;Text + #LF$
        
        If *This\text\string.s <> Text.s
          *This\text\string.s = Text.s
          *This\text\change = #True
          result = #True
        EndIf
      EndIf
      
      *this\change = 1
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetFont( *this._s_WIDGET, FontID.i )
      Protected result
      
      If *this\text\fontID <> FontID
        *this\text\fontID = FontID
        
        If *this\type = #__type_Editor
          *this\text\change = 1
          
          If Not Bool( *this\row\count And *this\row\count <> *this\count\items )
            Redraw( *this )
          EndIf
        Else
          ReDraw( *this )
          ;           ; example\font\font( demo )
          ;           If StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
          ;             _draw_font_( *this )
          ;             Draw( *this )
          ;             
          ;             StopDrawing( )
          ;           EndIf
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetColor( *this._s_WIDGET, ColorType.l, Color.l )
      Protected result
      *this\color\alpha.allocate( COLOR )
      
      Select ColorType
        Case #__color_line
          If *this\color\Line <> Color 
            *this\color\Line = Color
            *this\color\alpha\line = Alpha( Color )
            result = #True
          EndIf
          
        Case #__color_back
          If *this\color\Back <> Color 
            *this\color\Back = Color
            *this\color\alpha\back = Alpha( Color )
            result = #True
          EndIf
          
        Case #__color_fore
          If *this\color\fore <> Color 
            *this\color\fore = Color
            *this\color\alpha\fore = Alpha( Color )
            result = #True
          EndIf
          
        Case #__color_front
          If *this\color\Front <> Color 
            *this\color\Front = Color
            *this\color\alpha\Front = Alpha( Color )
            result = #True
          EndIf
          
        Case #__color_frame
          If *this\color\Frame <> Color 
            *this\color\Frame = Color
            *this\color\alpha\Frame = Alpha( Color )
            result = #True
          EndIf
          
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   SetImage( *this._s_WIDGET, *image )
      _set_image_( *this, *this\Image, *image )
    EndProcedure
    
    Procedure   SetBackgroundImage( *this._s_WIDGET, *image )
      _set_image_( *this, *this\Image[#__img_background], *image )
    EndProcedure
    
    Procedure   SetData( *this._s_WIDGET, *data )
      *this\data = *data
    EndProcedure
    
    Procedure SetForeground( *this._s_WIDGET )
      While _is_window_( *this ) 
        SetPosition( *this, #PB_List_Last )
        *this = *this\window
      Wend
      
      If this( )\sticky\window
        SetPosition( this( )\sticky\window, #PB_List_Last )
      EndIf
    EndProcedure
    
    Procedure.i Sticky( *window._s_WIDGET = #PB_Default, state.b = #PB_Default )
      Protected result = this( )\sticky\window
      
      If state <> #PB_Default 
        If _is_window_( *window )
          If state
            this( )\sticky\window = *window
          Else
            this( )\sticky\window = #Null 
          EndIf
          
          SetForeground( *window )
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetActive( *this._s_WIDGET )
      Protected result.i, *active._s_widget
      
      If *this 
        If *this\_state & #__s_focused = 0
          *this\_state | #__s_focused
          
          If GetActive( ) 
            If GetActive( ) <> *this\window And 
               GetActive( )\_state & #__s_focused
              GetActive( )\_state &~ #__s_focused
              result | DoEvents( GetActive( ), #__event_LostFocus, mouse( )\x, mouse( )\y )
            EndIf
            
            ; when we deactivate the window 
            ; we will deactivate his last active gadget
            If GetActive( )\gadget And 
               GetActive( )\gadget\_state & #__s_focused 
              GetActive( )\gadget\_state &~ #__s_focused
              result | DoEvents( GetActive( )\gadget, #__event_LostFocus, mouse( )\x, mouse( )\y )
            EndIf
            
            ; set deactive all parents
            If GetActive( )\gadget And 
               GetActive( )\gadget\address
              *active = GetActive( )\gadget
            ElseIf GetActive( )\address
              *active = GetActive( )
            EndIf
            If *active And *active\address
              ChangeCurrentElement( Widget( ), *active\address )
              While PreviousElement( Widget( ) )
                If Widget( ) = *this\window
                  Break
                EndIf
                If Child( *active, Widget( ) )
                  If Widget( )\_state & #__s_focused
                    Widget( )\_state &~ #__s_focused
                    result | DoEvents( Widget( ), #__event_LostFocus, mouse( )\x, mouse( )\y )
                  EndIf
                EndIf
              Wend 
            EndIf
          EndIf
          
          ; set active all parents
          If *this\address
            ChangeCurrentElement( Widget( ), *this\address )
            While PreviousElement( Widget( ) )
              If Child( *this, Widget( ) ) ;And Widget( )\container
                If Widget( )\_state & #__s_focused = 0
                  Widget( )\_state | #__s_focused
                  result | DoEvents( Widget( ), #__event_Focus, mouse( )\x, mouse( )\y )
                EndIf
              EndIf
            Wend 
          EndIf
          
          ; 
          If _is_window_( *this ) Or _is_root_( *this )
            GetActive( ) = *this
          Else
            If _is_child_integral_( *this )
              GetActive( ) = *this\parent\window
              GetActive( )\gadget = *this\parent
            Else
              GetActive( ) = *this\window
              GetActive( )\gadget = *this
            EndIf  
            
            ; when we activate the gadget
            ; first we activate its parent window
            If GetActive( )\_state & #__s_focused = 0
              GetActive( )\_state | #__s_focused
              result | DoEvents( GetActive( ), #__event_Focus, mouse( )\x, mouse( )\y )
            EndIf
          EndIf
          
          result | DoEvents( *this, #__event_Focus, mouse( )\x, mouse( )\y )
          ; when we activate the window
          ; we will activate his last gadget that lost focus
          If GetActive( )\gadget And 
             GetActive( )\gadget\_state & #__s_focused = 0
            GetActive( )\gadget\_state | #__s_focused
            result | DoEvents( GetActive( )\gadget, #__event_Focus, mouse( )\x, mouse( )\y )
          EndIf
          
          ; set window foreground position
          SetForeground( GetActive( ) )
        EndIf
        
      Else
        If GetActive( ) 
          If GetActive( )\_state & #__s_focused
            GetActive( )\_state &~ #__s_focused
            result | DoEvents( GetActive( ), #__event_LostFocus, mouse( )\x, mouse( )\y )
          EndIf
          
          ; when we deactivate the window 
          ; we will deactivate his last active gadget
          If GetActive( )\gadget And 
             GetActive( )\gadget\_state & #__s_focused 
            GetActive( )\gadget\_state &~ #__s_focused
            result | DoEvents( GetActive( )\gadget, #__event_LostFocus, mouse( )\x, mouse( )\y )
          EndIf
          
          ; set deactive all parents
          If GetActive( )\gadget And 
             GetActive( )\gadget\address
            *active = GetActive( )\gadget
          ElseIf GetActive( )\address
            *active = GetActive( )
          EndIf
          If *active And *active\address
            ChangeCurrentElement( Widget( ), *active\address )
            While PreviousElement( Widget( ) )
              If Child( *active, Widget( ) ) ;And Widget( )\container
                If Widget( )\_state & #__s_focused
                  Widget( )\_state &~ #__s_focused
                  result | DoEvents( Widget( ), #__event_LostFocus, mouse( )\x, mouse( )\y )
                EndIf
              EndIf
            Wend 
          EndIf
          
          GetActive( ) = 0
        EndIf
      EndIf
      
      result = #True
      ProcedureReturn result
    EndProcedure
    
    Procedure  GetLast( *last._s_WIDGET, tabindex.l )
      While *last\before And *last\tabindex <> tabindex
        *last = *last\before
        
        ;         If Not *last\before 
        ;           *last = *last\parent
        ;           Break
        ;         EndIf
      Wend
      
      ProcedureReturn *last
    EndProcedure
    
    Procedure.i GetPosition( *this._s_WIDGET, position.l )
      Protected *result._s_WIDGET
      
      Select position
        Case #PB_List_First : *result = *this\parent\first
          If *this\parent\_tab
            ; get tab first address
            While *result\after And 
                  *result\tabindex <> *this\tabindex
              *result = *result\after
            Wend
          EndIf
          
        Case #PB_List_Before 
          If *this\before And 
             *this\before\tabindex = *this\tabindex
            *result = *this\before
          EndIf
          
        Case #PB_List_After 
          If *this\after And 
             *this\after\tabindex = *this\tabindex
            *result = *this\after
          EndIf
          
        Case #PB_List_Last   : *result = *this\parent\last
          If *this\parent\_tab
            ; get tab last address
            While *result\before And 
                  *result\tabindex <> *this\tabindex
              *result = *result\before
            Wend
          EndIf
          
      EndSelect
      
      ProcedureReturn *result
    EndProcedure
    
    Procedure   SetPosition( *this._s_WIDGET, position.l, *widget._s_WIDGET = #Null ) ; Ok
      Protected Type
      Protected result
      
      Protected *before._s_WIDGET 
      Protected *after._s_WIDGET 
      Protected *last._s_WIDGET
      Protected *first._s_WIDGET
      
      If *this = *widget
        ProcedureReturn 0
      EndIf
      
      Select Position
        Case #PB_List_First 
          *first = GetPosition( *this, #PB_List_First )
          result = SetPosition( *this, #PB_List_Before, *first )
          
        Case #PB_List_Last 
          *last = GetPosition( *this, #PB_List_Last )
          result = SetPosition( *this, #PB_List_After, *last )
          
        Case #PB_List_Before 
          If *widget
            *after = *widget
          Else
            *after = *this\before
          EndIf
          
          If *after And *after\tabindex = *this\tabindex
            _position_move_before_(*this, *after)
            
            *this\after = *after
            *this\before = *after\before 
            *after\before = *this
            
            If *this\before
              *this\before\after = *this
            Else
              If *this\parent\first
                *this\parent\first\before = *this
              EndIf
              *this\parent\first = *this
            EndIf
            
            result = 1
          EndIf
          
        Case #PB_List_After 
          If *widget
            *before = *widget
          Else
            *before = *this\after
          EndIf
          
          If *before And *before\tabindex = *this\tabindex
            ; get last moved address
            If *before\last 
              ; get parent tab last address
              If *before\last\parent\_tab And 
                 *before\last\parent = *this\parent
                *last = GetLast( *before\last, *this\tabindex )
              Else
                ; get parent last address
                If Not *before\last\last
                  *last = *before\last
                Else
                  *last = *before\last\last
                  ; get child last address
                  While *last\last
                    *last = *last\last
                  Wend
                EndIf
              EndIf
            Else
              *last = *before
            EndIf
            
            _position_move_after_(*this, *last)
            
            *this\before = *before
            *this\after = *before\after 
            *before\after = *this
            
            If *this\after
              *this\after\before = *this
            Else
              If *this\parent\last
                *this\parent\last\after = *this
              EndIf
              *this\parent\last = *this
            EndIf
            
            result = 1
          EndIf
          
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   SetParent( *this._s_WIDGET, *parent._s_WIDGET, tabindex.l = 0 )
      Protected x.l, y.l, *last._s_WIDGET, *lastParent._s_WIDGET
      
      If *parent 
        If tabindex < 0 
          If *parent\_tab And 
             *parent\_tab\type = #__type_TabBar
            tabindex = *parent\_tab\bar\index 
          Else
            tabindex = 0
          EndIf
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex%2
              *parent\gadget[#__split_1] = *this
              *parent\index[#__split_1] = Bool( PB(IsGadget)( *this ) )
              Update( *parent )
              If *parent\index[#__split_1]
                ProcedureReturn 0
              EndIf
            Else
              *parent\gadget[#__split_2] = *this
              *parent\index[#__split_2] = Bool( PB(IsGadget)( *this ) )
              Update( *parent )
              If *parent\index[#__split_2]
                ProcedureReturn 0
              EndIf
            EndIf    
          EndIf    
        EndIf
        
        If *this\parent <> *parent Or 
           *this\tabindex <> tabindex
          *this\tabindex = tabindex
          
          ; set hide state 
          If *parent\hide
            *this\hide = #True
          ElseIf *parent\_tab
            ; hide all children except the selected tab
            *this\hide = Bool(*parent\_tab\index[#__tab_2] <> tabindex)
          EndIf
          
          ; get last added address
          If *parent\last 
            ; get parent tab last address
            If *parent\_tab And 
               *parent\last\tabindex > *this\tabindex
              
              *last = GetLast( *parent\last, tabindex )
              
              If *last\tabindex <> tabindex
                If *this\parent 
                  If *this\parent\last = *this
                    *this\parent\last = *this\before
                    *this\before\after = #Null
                    *this\before = #Null
                  EndIf
                EndIf
                
                *this\after = *last
                *last\before = *this
                *last = #Null
              EndIf
              
            Else
              ; get parent last address
              If Not *parent\last\last
                *last = *parent\last
              Else
                *last = *parent\last\last
                ; get child last address
                While *last\last
                  *last = *last\last
                Wend
              EndIf
            EndIf
          Else
            *last = *parent
          EndIf
          
          ; change parent
          If *this\parent
            *LastParent = *this\parent
            *LastParent\count\childrens - 1
            
            If Not _is_root_( *last )
              If *last
                _position_move_after_(*this, *last)
              Else
                _position_move_after_(*this, *parent)
              EndIf
            EndIf
            
            ; 
            If *this\root <> *parent\root
              If StartEnumerate( *this )
                Widget( )\root = *parent\root
                
                If _is_window_( *parent\window )
                  Widget( )\window = *parent\window
                EndIf
                
                _set_hide_state_( Widget( ) )
                StopEnumerate( )
              EndIf
            EndIf
          Else
            If *parent\root\count\childrens
              If *last
                ChangeCurrentElement( Widget( ), *last\address )
              Else
                ChangeCurrentElement( Widget( ), *parent\address )
              EndIf
            Else
              If LastElement( Widget( ) )
                *parent\address = Widget( )\address
              EndIf
            EndIf
            
            *this\address = AddElement( Widget( ) ) 
            *this\index = ListIndex( Widget( ) ) 
            Widget( ) = *this
          EndIf
          
          ; set parent last address
          If *parent\last 
            If *last 
              If *parent = *last\parent 
                *this\before = *last
              Else
                *this\before = *parent\last
              EndIf
              
              If *this\before
                *this\after = *this\before\after
                *this\before\after = *this
              EndIf
              
              If *parent\last\tabindex <= *this\tabindex
                *parent\last = *this
              EndIf
            Else
              *parent\first = *this
            EndIf
            
            If *this\after
              *this\after\before = *this  
            EndIf
          Else
            *this\before = #Null
            *this\after = #Null
            *parent\first = *this
            *parent\last = *this
          EndIf
          
          ;
          *this\parent = *parent
          *this\root = *parent\root
          
          ;;*this\window = *parent\window
          If _is_window_( *parent ) 
            *this\window = *parent
          Else
            *this\window = *parent\window
          EndIf
          
          ; add parent childrens count
          *parent\count\childrens + 1
          If *parent <> *this\root
            *this\root\count\childrens + 1
            *this\level = *parent\level + 1
          EndIf
          
          ; TODO
          If *this\window
            Static NewMap typecount.l( )
            
            *this\count\index = typecount( Hex( *this\window + *this\type ) )
            typecount( Hex( *this\window + *this\type ) ) + 1
            
            If *parent\_a_transform
              *this\count\type = typecount( Hex( *parent ) + "_" + Hex( *this\type ) )
              typecount( Hex( *parent ) + "_" + Hex( *this\type ) ) + 1
            EndIf
          EndIf
          
          ; set transformation for the child
          If Not *this\_a_transform And *parent\_a_transform 
            *this\_a_transform = Bool( *parent\_a_transform )
            a_set( *this )
          EndIf
          
          ; reparent children 
          If *LastParent And 
             *LastParent <> *parent
            
            ;
            If *this\scroll
              If *this\scroll\v
                *this\scroll\v\root = *this\root
                *this\scroll\v\window = *this\window
              EndIf
              If *this\scroll\h
                *this\scroll\h\root = *this\root
                *this\scroll\h\window = *this\window
              EndIf
            EndIf
            
            ;;If Not _is_child_no_integral_( *this )
            ; resize
            x = *this\x[#__c_container]
            y = *this\y[#__c_container]
            
            ; for the scrollarea container childrens
            ; if new parent - scrollarea container
            If *parent\scroll And *parent\scroll\v And *parent\scroll\h
              x - *parent\scroll\h\bar\page\pos
              y - *parent\scroll\v\bar\page\pos
            EndIf
            ; if last parent - scrollarea container
            If *LastParent\scroll And *LastParent\scroll\v And *LastParent\scroll\h
              x + *LastParent\scroll\h\bar\page\pos
              y + *LastParent\scroll\v\bar\page\pos
            EndIf
            
            ;;Debug "reparent - "
            Resize( *this, x - *parent\x[#__c_required], y - *parent\y[#__c_required], #PB_Ignore, #PB_Ignore )
            ;;EndIf
            
            ; re draw new parent root 
            If *LastParent\root <> *parent\root
              Select Root( )
                Case *LastParent\root : ReDraw( *parent\root )
                Case *parent\root     : ReDraw( *LastParent\root )
              EndSelect
            EndIf
            
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i SetAlignment( *this._s_WIDGET, Mode.l, Type.l = 1 ) ; ok
      Protected rx.b, ry.b
      
      With *this
        Select Type
          Case 1 ; widget
            If \parent
              If Not \parent\align
                \parent\align.allocate( ALIGN )
              EndIf
              If Not \align
                \align.allocate( ALIGN )
              EndIf
              
              ; 
              If Mode & #__align_full = #__align_full
                Mode | ( Bool( Mode & #__align_right = #False ) * #__align_left ) | 
                       ( Bool( Mode & #__align_bottom = #False ) * #__align_top ) | 
                       ( Bool( Mode & #__align_left = #False ) * #__align_right ) | 
                       ( Bool( Mode & #__align_top = #False ) * #__align_bottom )
              EndIf
              
              If Mode & #__align_right = #__align_right
                rx = 2 + Bool( Mode & #__align_left = #__align_left )
              EndIf
              
              If Mode & #__align_bottom = #__align_bottom
                ry = 2 + Bool( Mode & #__align_top = #__align_top )
              EndIf
              
              If Mode & #__align_center = #__align_center
                If Not Mode & #__align_right And
                   Not Mode & #__align_left
                  rx = 1
                EndIf
                
                If Not Mode & #__align_bottom And
                   Not Mode & #__align_top
                  ry = 1
                EndIf
              EndIf
              
              If Mode & #__align_proportional_vertical = #__align_proportional_vertical
                If Mode & #__align_top = #__align_top And Not Mode & #__align_left 
                  If Mode & #__align_bottom = #__align_bottom
                    ry = 4
                  Else
                    ry = 5
                  EndIf
                Else
                  ry = 6
                EndIf
                
              ElseIf Mode & #__align_proportional = #__align_proportional
                If Mode & #__align_left = #__align_left And Not Mode & #__align_top
                  If Mode & #__align_right = #__align_right
                    rx = 4
                  Else
                    rx = 5
                  EndIf
                Else
                  rx = 6
                EndIf
                
              EndIf
              
              \align\h = rx
              \align\v = ry
              
              \align\delta\x = \x[#__c_container]
              \align\delta\y = \y[#__c_container]
              \align\delta\width = \width[#__c_frame]
              \align\delta\height = \height[#__c_frame]
              
              \parent\align\delta\x = \parent\x[#__c_container]
              \parent\align\delta\y = \parent\y[#__c_container]
              
              If *this\parent\type = #__type_window
                \parent\align\delta\width = \parent\width[#__c_inner]
                \parent\align\delta\height = \parent\height[#__c_inner]
              Else
                \parent\align\delta\width = \parent\width[#__c_frame]
                \parent\align\delta\height = \parent\height[#__c_frame]
              EndIf
              
              ; docking
              If Mode & #__align_auto = #__align_auto
                If \align\h = 1 ; center
                  \align\delta\x = ( \parent\width[#__c_inner] - \align\delta\width )/2
                ElseIf \align\h = 2 ; right
                  \align\delta\x = \parent\width[#__c_inner] - \align\delta\width
                EndIf
                
                If \align\v = 1 ; center
                  \align\delta\y = ( \parent\height[#__c_inner] - \align\delta\height )/2
                ElseIf \align\v = 2 ; bottom
                  \align\delta\y = \parent\height[#__c_inner] - \align\delta\height
                EndIf
                
                If \align\h = 3 Or \align\v = 3
                  If \align\h = 3 ; full horizontal
                    \align\delta\width = \parent\width[#__c_inner]
                    
                    If \align\v = 0 ; top
                      \align\delta\y + \parent\align\_top
                      \parent\align\_top + *this\height[#__c_frame]
                      
                    ElseIf \align\v = 2 ; bottom
                      \align\delta\y - \parent\align\_bottom
                      \parent\align\_bottom + *this\height[#__c_frame] + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  If \align\v = 3 ; full vertical
                    \align\delta\height = \parent\height[#__c_inner] 
                    
                    If \align\h = 0 ; left
                      \align\delta\x + \parent\align\_left
                      \parent\align\_left + *this\width[#__c_frame]
                      
                    ElseIf \align\h = 2 ; right
                      \align\delta\x - \parent\align\_right
                      \parent\align\_right + *this\width[#__c_frame] + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  ; loop enumerate widgets
                  If StartEnumerate( *this\parent ) 
                    If Widget( )\align 
                      If ( Widget( )\align\h = 0 Or Widget( )\align\h = 2 )
                        Widget( )\align\delta\y = \parent\align\_top
                        Widget( )\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                      If ( Widget( )\align\v = 3 And Widget( )\align\h = 3 )
                        Widget( )\align\delta\x = \parent\align\_left
                        Widget( )\align\delta\width = \parent\align\delta\width - \parent\align\_left - \parent\align\_right
                        
                        Widget( )\align\delta\y = \parent\align\_top
                        Widget( )\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                    EndIf
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
              
              ; update parent childrens coordinate
              Resize( \parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            EndIf
          Case 2 ; text
          Case 3 ; image
        EndSelect
      EndWith
    EndProcedure
    
    
    ;- 
    Procedure.i GetItemData( *this._s_WIDGET, item.l )
      Protected result.i
      
      With *This
        Select \type
          Case #__type_Tree,
               #__type_ListView
            
            ;             PushListPosition( *this\row\_s( ) ) 
            ;             ForEach *this\row\_s( )
            ;               If *this\row\_s( )\index = Item 
            ;                 result = *this\row\_s( )\data
            ;                 ; Debug *this\row\_s( )\text\string
            ;                 Break
            ;               EndIf
            ;             Next
            ;             PopListPosition( *this\row\_s( ) )
            ; 
            If _no_select_item_( *this\row\_s( ), item )
              ProcedureReturn #False
            EndIf
            
            result = *this\row\_s( )\data
        EndSelect
      EndWith
      
      ;     If result
      ;       Protected *w.widget_S = result
      ;       
      ;       Debug "GetItemData " + Item  + " " +  result  + " " +   *w\class
      ;     EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s GetItemText( *this._s_WIDGET, Item.l, Column.l = 0 )
      Protected result.s
      
      If *this\type = #__type_Panel
        ProcedureReturn Tab_GetItemText( *this\_tab, Item, Column )
      EndIf
      
      If *this\type = #__type_tabbar Or *this\type = #__type_ToolBar
        ProcedureReturn Tab_GetItemText( *this, Item, Column )
      EndIf
      
      If *this\count\items ; row\count
        If _no_select_item_( *this\row\_s( ), Item ) 
          ProcedureReturn ""
        EndIf
        
        If *this\type = #__type_property And Column 
          result = *this\row\_s( )\text\edit\string
        Else
          result = *this\row\_s( )\text\string
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemImage( *this._s_WIDGET, Item.l ) 
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_ListView Or
         *this\type = #__type_Tree
        
        If _no_select_item_( *this\row\_s( ), Item ) 
          ProcedureReturn #PB_Default
        EndIf
        
        result = *this\row\_s( )\image\img
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont( *this._s_WIDGET, Item.l )
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_ListView Or
         *this\type = #__type_Tree
        
        If _no_select_item_( *this\row\_s( ), Item ) 
          ProcedureReturn #False
        EndIf
        
        result = *this\row\_s( )\text\fontID
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemState( *this._s_WIDGET, Item.l )
      Protected result
      
      ; 
      If *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        If _no_select_item_( *this\bar\_s( ), Item ) 
          ProcedureReturn #False
        EndIf
        
        ProcedureReturn *this\bar\_s( )\_state
      EndIf
      
      If *this\type = #__type_Editor
        If item =- 1
          ProcedureReturn *this\text\caret\pos
        Else
          ProcedureReturn *this\text\caret\pos[1]
        EndIf
        
      ElseIf *this\type = #__type_Tree
        If _is_item_( *this, item ) And SelectElement( *this\row\_s( ), Item ) 
          If *this\row\_s( )\color\state
            result | #__tree_selected
          EndIf
          
          If *this\row\_s( )\checkbox\state
            If *this\mode\threestate And 
               *this\row\_s( )\checkbox\state = #PB_Checkbox_Inbetween
              result | #__tree_Inbetween
            Else
              result | #__tree_checked
            EndIf
          EndIf
          
          If *this\row\_s( )\childrens And
             *this\row\_s( )\button\state = 0
            result | #__tree_expanded
          Else
            result | #__tree_collapsed
          EndIf
        EndIf
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemColor( *this._s_WIDGET, Item.l, ColorType.l, Column.l = 0 )
      Protected result, *color._s_color
      
      If *this\type = #__type_Editor
        If _is_item_( *this, item ) And SelectElement( *this\row\_s( ), Item )
          *color = *this\row\_s( )\color
        EndIf
      ElseIf *this\type = #__type_Tree 
        If _is_item_( *this, item ) And SelectElement( *this\row\_s( ), Item )
          *color = *this\row\_s( )\color
        EndIf
      Else
        *color = *this\bar\button[Item]\color
      EndIf
      
      Select ColorType
        Case #__color_line  : result = *color\line[Column]
        Case #__color_back  : result = *color\back[Column]
        Case #__color_front : result = *color\front[Column]
        Case #__color_frame : result = *color\frame[Column]
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemAttribute( *this._s_WIDGET, Item.l, Attribute.l, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_Tree
        If _no_select_item_( *this\row\_s( ), Item )
          ProcedureReturn #False
        EndIf
        
        Select Attribute
          Case #__tree_sublevel
            result = *this\row\_s( )\sublevel
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i SetItemData( *This._s_WIDGET, item.l, *data )
      If *this\count\items 
        If _no_select_item_( *this\row\_s( ), item )
          ProcedureReturn #False
        EndIf
        
        *this\row\_s( )\data = *Data
      EndIf
    EndProcedure
    
    Procedure.l SetItemText( *this._s_WIDGET, Item.l, Text.s, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_tabbar Or *this\type = #__type_ToolBar
        If _no_select_item_( *this\bar\_s( ), item )
          ProcedureReturn #False
        EndIf
        
        *this\bar\change_tab_items = #True
        *this\bar\_s( )\text\string = Text.s
        _post_repaint_( *this\root )
      EndIf
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_property
        
        ;Item = *this\row\i( Hex( Item ) )
        
        If _no_select_item_( *this\row\_s( ), item )
          ProcedureReturn #False
        EndIf
        
        Protected row_count = CountString( Text.s, #LF$ )
        
        If Not row_count
          *this\row\_s( )\text\string = Text.s
        Else
          *this\row\_s( )\text\string = StringField( Text.s, 1, #LF$ )
          *this\row\_s( )\text\edit\string = StringField( Text.s, 2, #LF$ )
        EndIf
        
        *this\row\_s( )\text\change = 1
        *this\change = 1
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText( *this\_tab, Item, Text, Column )
        
      ElseIf *this\type = #__type_TabBar Or *this\type = #__type_ToolBar
        If _is_item_( *this, Item ) And
           SelectElement( *this\bar\_s( ), Item ) And 
           *this\bar\_s( )\text\string <> Text 
          *this\bar\_s( )\text\string = Text 
          *this\bar\_s( )\text\change = 1
          *this\change = 1
          result = #True
        EndIf
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemImage( *this._s_WIDGET, Item.l, Image.i ) 
      Protected result
      
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If _is_item_( *this, item ) And SelectElement( *this\row\_s( ), Item )
          If *this\row\_s( )\image\img <> Image
            _set_image_( *this, *this\row\_s( )\Image, Image )
            _post_repaint_items_( *this )
            *this\change = 1
            ;;_post_repaint_( *this\root )
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont( *this._s_WIDGET, Item.l, Font.i )
      Protected result, FontID.i = FontID( Font )
      
      If *this\type = #__type_Editor Or 
         *this\type = #__type_property Or 
         *this\type = #__type_ListView Or 
         *this\type = #__type_Tree
        
        If _is_item_( *this, item ) And 
           SelectElement( *this\row\_s( ), Item ) And 
           *this\row\_s( )\text\fontID <> FontID
          *this\row\_s( )\text\fontID = FontID
          ;       *this\row\_s( )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      ElseIf *this\type = #__type_Panel
        If _is_item_( *this\_tab, item ) And 
           SelectElement( *this\_tab\bar\_s( ), Item ) And 
           *this\_tab\bar\_s( )\text\fontID <> FontID
          *this\_tab\bar\_s( )\text\fontID = FontID
          ;       *this\row\_s( )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState( *this._s_WIDGET, Item.l, State.b )
      Protected result
      
      If *this\type = #__type_tabbar Or *this\type = #__type_ToolBar
        If _no_select_item_( *this\bar\_s( ), Item )
          ProcedureReturn #False
        EndIf
        
        If State & #__tree_selected = #__tree_selected
          ;           If *this\row\selected <> *this\bar\_s( )
          ;             *this\row\selected = *this\bar\_s( )
          ;             *this\row\selected\_state | #__s_selected
          ;             *this\row\selected\color\state = #__s_2 + Bool( *this\_state & #__s_focused = #False )
          ;           EndIf
          Tab_SetState( *this, Item )
        EndIf
        
        If State & #__tree_inbetween = #__tree_inbetween
          *this\bar\_s( )\checkbox\state = #PB_Checkbox_Inbetween
        ElseIf State & #__tree_checked = #__tree_checked
          *this\bar\_s( )\checkbox\state = #PB_Checkbox_Checked
        EndIf
        
        _post_repaint_( *this\root )
      EndIf  
      
      ; - widget::window_set_item_state( )
      If *this\type = #__type_window
        ; result = Window_SetState( *this, state )
        
        ; - widget::editor_set_item_state( )
      ElseIf *this\type = #__type_Editor
        result = Editor_SetItemState( *this, Item, state )
        
        ;- widget::tree_set_item_state( )
      ElseIf *this\type = #__type_Tree
        If *this\count\items
          If _no_select_item_( *this\row\_s( ), Item )
            ProcedureReturn #False
          EndIf
          
          Protected *this_current_row._s_rows = *this\row\_s( )
          
          If State & #__tree_selected = #__tree_selected
            If *this\row\selected <> *this\row\_s( )
              *this\row\selected = *this\row\_s( )
              *this\row\selected\_state | #__s_selected
              *this\row\selected\color\state = #__s_2 + Bool( *this\_state & #__s_focused = #False )
            EndIf
          EndIf
          
          If State & #__tree_inbetween = #__tree_inbetween
            *this\row\_s( )\checkbox\state = #PB_Checkbox_Inbetween
          ElseIf State & #__tree_checked = #__tree_checked
            *this\row\_s( )\checkbox\state = #PB_Checkbox_Checked
          EndIf
          
          If *this\row\_s( )\childrens
            If State & #__tree_expanded = #__tree_expanded Or 
               State & #__tree_collapsed = #__tree_collapsed
              
              *this\change = #True
              *this\row\_s( )\button\state = Bool( State & #__tree_collapsed )
              
              PushListPosition( *this\row\_s( ) )
              While NextElement( *this\row\_s( ) )
                If *this\row\_s( )\parent 
                  *this\row\_s( )\hide = Bool( *this\row\_s( )\parent\button\state | *this\row\_s( )\parent\hide )
                EndIf
                
                If *this\row\_s( )\sublevel = *this_current_row\sublevel 
                  _post_repaint_( *this\root )
                  Break
                EndIf
              Wend
              PopListPosition( *this\row\_s( ) )
            EndIf
          EndIf
          
          result = *this_current_row\button\state
        EndIf
        
        ; - widget::panel_set_item_state( )
      ElseIf *this\type = #__type_Panel
        ; result = Panel_SetItemState( *this, state )
        
      Else
        ; result = Bar_SetState( *this, state )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l _SetItemColor( *this._s_WIDGET, Item.l, ColorType.l, Color.l, Column.l = 0 )
      Protected result
      
      With *this
        If Item =- 1
          PushListPosition( \row\_s( ) ) 
          ForEach \row\_s( )
            Select ColorType
              Case #__color_back
                \row\_s( )\color\back[Column] = Color
                
              Case #__color_Front
                \row\_s( )\color\front[Column] = Color
                
              Case #__color_Frame
                \row\_s( )\color\frame[Column] = Color
                
              Case #__color_line
                \row\_s( )\color\line[Column] = Color
                
            EndSelect
          Next
          PopListPosition( \row\_s( ) ) 
          
        Else
          If _is_item_( *this, item ) And SelectElement( *this\row\_s( ), Item )
            Select ColorType
              Case #__color_back
                \row\_s( )\color\back[Column] = Color
                
              Case #__color_front
                \row\_s( )\color\front[Column] = Color
                
              Case #__color_frame
                \row\_s( )\color\frame[Column] = Color
                
              Case #__color_line
                \row\_s( )\color\line[Column] = Color
                
            EndSelect
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.l SetItemColor( *this._s_WIDGET, Item.l, ColorType.l, Color.l, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_Editor
        
        result = _SetItemColor( *this, Item.l, ColorType.l, Color.l, Column.l )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemAttribute( *this._s_WIDGET, Item.l, Attribute.l, *value, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_Window
        
      ElseIf *this\type = #__type_Tree
        Select Attribute
          Case #__tree_collapsed
            *this\mode\collapse = Bool( Not *value ) 
            
          Case #__tree_OptionBoxes
            *this\mode\check = Bool( *value ) * #__m_clickselect
            
        EndSelect
        
      ElseIf *this\type = #__type_Editor
        
      ElseIf *this\type = #__type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    ;- 
    ;-  CREATEs
    Procedure.i create_new_widget( *parent._s_WIDGET, class.s, type.l, x.l,y.l,width.l,height.l, Text.s="", flag.i = 0, size.l=0, *param_1=0, *param_2=0, *param_3=0, round.l = 7, ScrollStep.f = 1.0 )
      Protected *this.allocate( Widget )
      ;Protected *parent._s_WIDGET = OpenWidget( )
      
      If *this
        With *this
          *this\type = #__type_Tree
          *this\class = #PB_Compiler_Procedure
          
          *this\x[#__c_inner] =- 2147483648
          *this\y[#__c_inner] =- 2147483648
          
          If type = #__type_Property
            If *this\bar
              *this\bar\page\pos = 60
            EndIf
          EndIf
          
          ;*this\_state = #__ss_front
          *this\color\_alpha = 255
          *this\color\fore[#__s_0] =- 1
          *this\color\back[#__s_0] = $ffffffff ; _get_colors_( )\fore
          *this\color\front[#__s_0] = _get_colors_( )\front
          *this\color\frame[#__s_0] = _get_colors_( )\frame
          
          *this\row\index =- 1
          *this\change = 1
          
          *this\interact = 1
          ;*this\round = round
          
          *this\text\change = 1 
          *this\text\height = 18 
          
          *this\image\padding\x = 2
          *this\text\padding\x = 4
          
          ;*this\vertical = Bool( Flag&#__flag_vertical )
          *this\fs = Bool( Not Flag&#__flag_borderLess )*2
          *this\bs = *this\fs
          
          If flag & #__list_nolines
            flag &~ #__list_nolines
          Else
            flag | #__list_nolines
          EndIf
          
          If flag & #__tree_NoButtons
            flag &~ #__tree_NoButtons
          Else
            flag | #__tree_NoButtons
          EndIf
          
          If flag
            Flag( *this, flag, #True )
          EndIf
          
          _set_align_flag_( *this, *parent, flag )
          SetParent( *this, *parent, #PB_Default )
          
          If flag & #__flag_noscrollbars = #False
            Area( *this, 1, 0,0,0,0, Bool( ( \mode\buttons = 0 And \mode\lines = 0 ) = 0 ) )
          EndIf
          Resize( *this, x,y,width,height )
        EndWith
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Create( *parent._s_WIDGET, class.s, type.l, x.l,y.l,width.l,height.l, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, Text.s = #Null$, flag.i = #Null, size.l = 0, round.l = 7, ScrollStep.f = 1.0 )
      Protected ScrollBars, *this.allocate( Widget )
      
      With *this
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        *this\type = type
        *this\round = round
        *this\class = class
        *this\child = Bool( Flag & #__flag_child = #__flag_child )
        
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] =- 1
        
        ; *this\address = *this
        ; *this\class = #PB_compiler_Procedure
        *this\color = _get_colors_( )
        
        ; - Create Texts
        If *this\type = #__type_Text Or
           *this\type = #__type_Editor Or
           *this\type = #__type_String Or
           *this\type = #__type_Button Or
           *this\type = #__type_Option
          
          
        EndIf
        
        ; - Create Containers
        If *this\type = #__type_Container Or
           *this\type = #__type_ScrollArea Or
           *this\type = #__type_Panel Or
           *this\type = #__type_MDI
          
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          *this\container = *this\type
          *this\color\back = $FFF9F9F9
          
          If *this\type = #__type_MDI
            ScrollBars = 1
          EndIf
          
          If *this\type = #__type_ScrollArea
            ScrollBars = 1
            *this\scroll\increment = ScrollStep
          EndIf
          
          If *this\type = #__type_Container 
          EndIf
          
          If *this\type = #__type_Panel 
            If Flag & #__bar_vertical = #False
              *this\BarHeight = #__panel_height
            Else
              *this\BarWidth = #__panel_width
            EndIf
          EndIf
          
          If Not Flag&#__flag_borderLess
            If ScrollBars
              *this\fs = #__border_scroll
            Else
              *this\fs = 1
            EndIf
          EndIf
        EndIf
        
        ; - Create image
        If *this\type = #__type_Image
          ScrollBars = 1
          *this\flag = Flag
          
          If *this\image\img <> *param_3
            _set_image_( *this, *this\Image, *param_3 )
          EndIf
          
          _set_align_( *this\image, 
                       constants::_check_( Flag, #__image_left ),
                       constants::_check_( Flag, #__image_top ),
                       constants::_check_( Flag, #__image_right ),
                       constants::_check_( Flag, #__image_bottom ),
                       constants::_check_( Flag, #__image_center ) )
          
          *param_1 = *this\image\width 
          *param_2 = *this\image\height 
          
          *this\color\back = $FFF9F9F9
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\fs = Bool( Not Flag&#__flag_borderLess ) * #__border_scroll
        EndIf
        
        ;- Create Bars
        If *this\type = #__type_ScrollBar Or 
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_TrackBar Or
           *this\type = #__type_tabbar Or *this\type = #__type_ToolBar Or
           *this\type = #__type_Spin Or
           *this\type = #__type_Splitter
          
          *this\bar.allocate( BAR )
          *this\scroll\increment = ScrollStep
          
          ; - Create Scroll
          If *this\type = #__type_ScrollBar
            *this\color\back = $FFF9F9F9 ; - 1 
            *this\color\front = $FFFFFFFF
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            *this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\class = class+"-v"
            Else
              *this\class = class+"-h"
            EndIf
            
            *this\bar\button[#__b_3]\size = size
            
            If Not Flag & #__flag_nobuttons = #__flag_nobuttons
              *this\bar\button[#__b_1]\size =- 1
              *this\bar\button[#__b_2]\size =- 1
            EndIf
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            *this\bar\button[#__b_3]\round = *this\round
            
            *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            *this\bar\button[#__b_3]\arrow\size = 3
          EndIf
          
          ; - Create Spin
          If *this\type = #__type_Spin
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If Not ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
              *this\vertical = #True
              *this\bar\inverted = #True
            EndIf
            
            *this\fs = Bool( Not Flag&#__flag_borderless )
            *this\bs = *this\fs
            
            ; *this\text.allocate( TEXT )
            *this\text\change = 1
            *this\text\editable = 1
            *this\text\align\top = 1
            
            *this\text\padding\x = #__spin_padding_text
            *this\text\padding\y = #__spin_padding_text
            
            *this\color = _get_colors_( )
            *this\color\_alpha = 255
            *this\color\back = $FFFFFFFF
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            ;*this\bar\button[#__b_3]\interact = #True
            
            If *this\vertical
              *this\bar\button[#__b_3]\size = Size + 2
            Else
              *this\bar\button[#__b_3]\size = Size*2 + 3
            EndIf
            
            *this\bar\button[#__b_1]\size = Size
            *this\bar\button[#__b_2]\size = Size
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            
            *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
            
            _set_text_flag_( *this, flag )
            
          EndIf
          
          ; - Create Tab
          If *this\type = #__type_tabbar Or *this\type = #__type_ToolBar
            ;;*this\text\change = 1
            *this\index[#__tab_2] = 0 ; default selected tab
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\inverted = Bool( Flag & #__bar_invert = #False )
            
            If Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
            EndIf
            
            If Not Flag & #__bar_buttonsize = #__bar_buttonsize
              *this\bar\button[#__b_3]\size = size
              *this\bar\button[#__b_1]\size = 15
              *this\bar\button[#__b_2]\size = 15
            EndIf
            
            If *this\child
              *this\fs = *parent\fs
            Else
              *this\fs = #__border_scroll
            EndIf
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_1]\round = 7
            *this\bar\button[#__b_2]\round = 7
            *this\bar\button[#__b_3]\round = *this\round
            
            *this\bar\button[#__b_1]\arrow\type = -1 ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = -1 ; -1 0 1
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            ;*this\bar\button[#__b_3]\arrow\size = 3
            
            _set_text_flag_( *this, flag )
          EndIf
          
          ; - Create Track
          If *this\type = #__type_TrackBar
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            *this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\inverted = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            If flag & #PB_TrackBar_Ticks = #PB_TrackBar_Ticks
              *this\bar\mode = #PB_TrackBar_Ticks
            EndIf
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_3]\arrow\size = #__arrow_size
            *this\bar\button[#__b_3]\arrow\type = #__arrow_type
            
            *this\bar\button[#__b_1]\round = 2
            *this\bar\button[#__b_2]\round = 2
            *this\bar\button[#__b_3]\round = *this\round
            
            If *this\round < 7
              *this\bar\button[#__b_3]\size = 9
            Else
              *this\bar\button[#__b_3]\size = 15
            EndIf
            
            _set_text_flag_( *this, flag )
            
          EndIf
          
          ; - Create Progress
          If *this\type = #__type_ProgressBar
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
            
            If Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\inverted = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            
            *this\text\change = #True
            _set_text_flag_( *this, flag | #__text_center )
          EndIf
          
          ; - Create Splitter
          If *this\type = #__type_Splitter
            *this\color\back =- 1
            
            ;         *this\bar\button[#__b_1]\color = _get_colors_( )
            ;         *this\bar\button[#__b_2]\color = _get_colors_( )
            ;         *this\bar\button[#__b_3]\color = _get_colors_( )
            
            ;;Debug ""+*param_1 +" "+ PB(IsGadget)( *param_1 )
            
            ;*this\container =- *this\type 
            *this\gadget[#__split_1] = *param_1
            *this\gadget[#__split_2] = *param_2
            *this\index[#__split_1] = Bool( PB(IsGadget)( *this\gadget[#__split_1] ) )
            *this\index[#__split_2] = Bool( PB(IsGadget)( *this\gadget[#__split_2] ) )
            
            *this\bar\inverted = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
              *this\bar\mode = #PB_Splitter_Separator
            EndIf
            
            If ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
              *this\cursor = #PB_Cursor_LeftRight
            Else
              *this\vertical = #True
              *this\cursor = #PB_Cursor_UpDown
            EndIf
            
            If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
              *this\bar\fixed = #__split_1 
            ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
              *this\bar\fixed = #__split_2 
            EndIf
            ;             
            *this\bar\button[#__b_3]\size = #__splitter_buttonsize
            *this\bar\button[#__b_3]\interact = #True
            *this\bar\button[#__b_3]\round = 2
            
          Else
            If *param_1 
              SetAttribute( *this, #__bar_minimum, *param_1 ) 
            EndIf
            If *param_2 
              SetAttribute( *this, #__bar_maximum, *param_2 ) 
            EndIf
            If *param_3 
              SetAttribute( *this, #__bar_pageLength, *param_3 ) 
            EndIf
          EndIf
        EndIf
        
        ;
        If *this\child
          *this\parent = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\address = *parent\address
          
        Else
          _set_align_flag_( *this, *parent, flag )
          
          If *parent
            SetParent( *this, *parent, #PB_Default )
          Else
            *this\draw_widget = 1
          EndIf
          
          ; splitter 
          If *this\type = #__type_Splitter
            If *this\gadget[#__split_1] And Not *this\index[#__split_1]
              SetParent( *this\gadget[#__split_1], *this )
            EndIf
            
            If *this\gadget[#__split_2] And Not *this\index[#__split_2]
              SetParent( *this\gadget[#__split_2], *this )
            EndIf
          EndIf
          
          If *this\type = #__type_Panel 
            *this\_tab = Create( *this, *this\class+"_"+#PB_Compiler_Procedure, #__type_TabBar, 0,0,0,0, 0,0,0, #Null$, Flag | #__flag_child, 0,0,30 )
          EndIf
          
          If *this\container And flag & #__flag_nogadgets = #False And *this\type <> #__type_Splitter 
            OpenList( *this )
          EndIf
          
          If ScrollBars And flag & #__flag_noscrollbars = #False
            Area( *this, ScrollStep, *param_1, *param_2, 0, 0 )
          EndIf
          
          If *this\type = #__type_MDI
            ; this before Resize( ) 
            ; and after SetParent( )
            ; 
            If Not *this\_a_transform And
               Bool( flag & #__mdi_editable = #__mdi_editable )
              a_init( *this )
            EndIf
          EndIf
          
          Resize( *this, x,y,width,height )
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            ; ;             *this\x[#__c_required] = *this\x[#__c_inner]
            ; ;             *this\y[#__c_required] = *this\y[#__c_inner] 
            *this\width[#__c_required] = *param_1
            *this\height[#__c_required] = *param_2
          EndIf
          
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab( x.l,y.l,width.l,height.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_TabBar, x,y,width,height, 0,0,0, #Null$, flag, 40,round,40 )
    EndProcedure
    
    Procedure.i Spin( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, Increment.f = 1.0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_Spin, x,y,width,height, min,max,0, #Null$, flag, #__spin_buttonsize,round,Increment )
    EndProcedure
    
    Procedure.i Scroll( x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_ScrollBar, x,y,width,height, min,max,pagelength, #Null$, flag, #__scroll_buttonsize,round,1 )
    EndProcedure
    
    Procedure.i Track( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_TrackBar, x,y,width,height, min,max,0, #Null$, flag, 0,round,1 )
    EndProcedure
    
    Procedure.i Progress( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_ProgressBar, x,y,width,height, min,max,0, #Null$, flag, 0,round,1 )
    EndProcedure
    
    Procedure.i Splitter( x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_Splitter, x,y,width,height, First,Second,0, #Null$, flag, 0,0,1 )
    EndProcedure
    
    
    
    ;- 
    Procedure.i Tree( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn create_new_widget( OpenWidget( ), #PB_Compiler_Procedure, #__type_Tree, x,y,width,height, "", Flag )
    EndProcedure
    
    Procedure.i ListView( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn create_new_widget( OpenWidget( ), #PB_Compiler_Procedure, #__type_ListView, x,y,width,height, "", Flag | #__tree_nobuttons | #__list_nolines )
    EndProcedure
    
    Procedure.i ListIcon( x.l,y.l,width.l,height.l, ColumnTitle.s, ColumnWidth.i, flag.i = 0 )
      ProcedureReturn create_new_widget( OpenWidget( ), #PB_Compiler_Procedure, #__type_ListIcon, x,y,width,height, "", Flag )
    EndProcedure
    
    Procedure.i ExplorerList( x.l,y.l,width.l,height.l, Directory.s, flag.i=0 )
      ProcedureReturn create_new_widget( OpenWidget( ), #PB_Compiler_Procedure, #__type_ExplorerList, x,y,width,height, "", Flag | #__tree_nobuttons | #__list_nolines )
    EndProcedure
    
    Procedure.i Tree_properties( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn create_new_widget( OpenWidget( ), #PB_Compiler_Procedure, #__type_Property, x,y,width,height, "", Flag )
    EndProcedure
    
    
    ;- 
    Procedure.i _text( *parent._s_WIDGET, class.s, type.l, x.l, y.l, width.l,height.l, Text.s, flag.i = 0, round.i = 0, color.i = 0 )
      Protected *this.allocate( Widget )
      
      *this\type = type
      *this\class = class
      *this\round = round
      
      ; flag
      If *this\type = #__type_Editor
        *this\flag = Flag | #__text_left | #__text_top
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_CheckBox Or 
             *this\type = #__type_String
        
        If Not flag & #__text_center
          *this\flag = flag | #__text_center | #__text_left
        Else
          *this\flag = flag | #__text_center
        EndIf
        
      ElseIf *this\type = #__type_Button Or 
             *this\type = #__type_HyperLink
        
        *this\flag = Flag | #__text_center
        
      EndIf
      
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      *this\mode\threestate = constants::_check_( Flag, #PB_CheckBox_ThreeState )
      
      *this\bs = *this\fs
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_( )\fore
      *this\color\front[#__s_0] = _get_colors_( )\front
      
      
      If *this\type = #__type_Editor Or 
         *this\type = #__type_String
        *this\color = _get_colors_( )
        *this\color\back = $FFF9F9F9
      EndIf
      
      
      
      If *this\type = #__type_Editor
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = *this\index[#__s_1]
        
        ; PB 
        *this\fs = constants::_check_( Flag, #__flag_borderLess, #False ) * #__border_scroll
        
        *this\mode\check = #__m_multiselect ; multiselect
        *this\mode\fullselection = constants::_check_( Flag, #__flag_fullselection, #False )*7
        *this\mode\alwaysselection = constants::_check_( Flag, #__flag_alwaysselection )
        *this\mode\gridlines = constants::_check_( Flag, #__flag_gridlines )
        
        *this\row\margin\hide = constants::_check_( Flag, #__text_numeric, #False )
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      EndIf
      
      If *this\type = #__type_String
        If Not Flag & #__flag_borderLess
          *this\fs = 1
          *this\color\frame = _get_colors_( )\frame
        EndIf
        
        *this\text\caret\x = *this\text\padding\x
        
        Text = RemoveString( Text, #LF$ ) ; +  #LF$
      EndIf
      
      ; - Create Text
      If *this\type = #__type_Text
        If Flag & #__text_border = #__text_border 
          *this\fs = 1
          *this\color\frame = _get_colors_( )\frame
        EndIf
        
      EndIf
      
      ; - Create Button
      If *this\type = #__type_Button
        *this\__state = #__ss_front | #__ss_back | #__ss_frame
        
        *this\fs = 1
        *this\color = _get_colors_( )
      EndIf
      
      If *this\type = #__type_Option Or 
         *this\type = #__type_CheckBox Or 
         *this\type = #__type_HyperLink
        
        *this\button\color = _get_colors_( )
        *this\button\color\back = $ffffffff
      EndIf
      
      If *this\type = #__type_Option Or 
         *this\type = #__type_CheckBox 
        *this\button\width = 15
        *this\button\height = *this\button\width
      EndIf
      
      If *this\type = #__type_Option
        *this\button\round = *this\button\width/2
      EndIf
      
      If *this\type = #__type_CheckBox
        *this\button\round = 2
      EndIf
      
      If *this\type = #__type_HyperLink
        *this\__state = #__ss_front
        *this\cursor = #PB_Cursor_Hand
        
        *this\mode\lines = constants::_check_( Flag, #PB_HyperLink_Underline )
        *this\color\front[#__s_1] = Color
      EndIf
      
      
      If *this\type = #__type_Option
        If Root( )\count\childrens
          If Widget( )\type = #__type_Option
            *this\_group = Widget( )\_group 
          Else
            *this\_group = Widget( ) 
          EndIf
        Else
          *this\_group = OpenWidget( )
        EndIf
      EndIf
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      If flag & #__flag_noscrollbars = #False
        Area( *this,1,0,0,0,0 )
      EndIf
      
      Resize( *this, x,y,width,height )
      
      ; text
      _set_text_flag_( *this, *this\flag )
      
      *this\change = 1
      
      If *this\type = #__type_Text
        *this\text\padding\x = 1
      ElseIf *this\type = #__type_Button
        *this\text\padding\x = 4
        *this\text\padding\y = 4
      ElseIf *this\type = #__type_Editor
        *this\text\padding\y = 6
        *this\text\padding\x = 6
      ElseIf *this\type = #__type_String
        *this\text\padding\x = 3
        *this\text\padding\y = 0
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_CheckBox 
        *this\text\padding\x = *this\button\width + 8
      EndIf
      
      
      ; multiline
      If *this\type = #__type_Text
        *this\text\multiLine =- 1
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_CheckBox Or 
             *this\type = #__type_HyperLink
        ; wrap text
        *this\text\multiline =- CountString( Text, #LF$ )
        
      ElseIf *this\type = #__type_Editor
        If Not *this\text\multiLine
          *this\text\multiLine = 1
        EndIf
        
      ElseIf *this\type = #__type_String
        *this\text\multiLine = 0
      EndIf
      
      If Text.s
        SetText( *this, Text.s )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Editor( x.l, Y.l, width.l,height.l, Flag.i = 0, round.i = 0 )
      Protected *this.allocate( Widget )
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\round = round
      *this\flag = Flag | #__text_left | #__text_top
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      *this\type = #__type_Editor
      *this\color = _get_colors_( )
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      
      ; - Create Text
      If *this\type = #__type_Editor
        *this\class = "Text"
        ; *this\color\back =- 1 
        
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = *this\index[#__s_1]
        
        ; PB 
        *this\fs = constants::_check_( Flag, #__flag_borderLess, #False ) * #__border_scroll
        *this\bs = *this\fs
        
        *this\text\padding\y = Bool( #PB_Compiler_OS = #PB_OS_Windows ) ;; 6
        *this\text\padding\x = 3 - Bool( #PB_Compiler_OS = #PB_OS_Windows ) * 2 - Bool( #PB_Compiler_OS = #PB_OS_Linux ) * 3 ;; 6
        
        *this\mode\check = #__m_multiselect ; multiselect
        *this\mode\fullselection = constants::_check_( Flag, #__flag_fullselection, #False )*7
        *this\mode\alwaysselection = constants::_check_( Flag, #__flag_alwaysselection )
        *this\mode\gridlines = constants::_check_( Flag, #__flag_gridlines )
        
        *this\row\margin\hide = constants::_check_( Flag, #__text_numeric, #False )
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        _set_text_flag_( *this, flag )
        If Not *this\text\multiLine
          *this\text\multiLine = 1
        EndIf
        *this\change = 1
      EndIf
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Area( *this,1,0,0,0,0 )
      Resize( *this, x,y,width,height )
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i String( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
      Protected *this.allocate( Widget )
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\round = round
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      *this\type = #__type_String
      *this\color = _get_colors_( )
      *this\color\fore =- 1
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      If *this\text\multiline
        *this\row\margin\hide = 0;Bool( Not Flag&#__string_numeric )
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      Else
        *this\row\margin\hide = 1
        *this\text\numeric = Bool( Flag&#__string_numeric )
      EndIf
      
      _set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ) )
      
      ; - Create Text
      If *this\type = #__type_String
        *this\class = "String"
        ; *this\color\back =- 1 
        
        ; PB 
        If Flag & #__flag_borderless = #False
          *this\fs = 1
          *this\bs = *this\fs
        EndIf
        
        *this\text\padding\x = 3
        *this\text\padding\y = 0
        *this\text\caret\x = *this\text\padding\x
        
        *this\text\multiline = 0
        Text = RemoveString( Text, #LF$ ) ; +  #LF$
        
        SetText( *This, Text )
      EndIf
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Area( *this,1,0,0,0,0 )
      Resize( *this, x,y,width,height )
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Text( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
      Protected *this.allocate( Widget )
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\round = round
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      *this\type = #__type_Text
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_( *this, flag )
      
      ; - Create Text
      If *this\type = #__type_Text
        *this\class = "Text"
        
        *this\color\fore =- 1
        *this\color\back = _get_colors_( )\fore
        *this\color\front = _get_colors_( )\front
        
        ; PB 
        If Flag & #__text_border = #__text_border 
          *this\fs = 1
          *this\bs = *this\fs
          *this\color\frame = _get_colors_( )\frame
        EndIf
        
        *this\text\x = 1
        *this\text\multiline =- 1
        SetText( *This, Text )
      EndIf
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Resize( *this, x,y,width,height )
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
      Protected *this.allocate( Widget )
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\round = round
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      *this\type = #__type_Button
      *this\flag = Flag | #__text_center
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_( *this, *this\flag )
      
      _set_image_( *this, *this\Image, Image )
      
      _set_align_( *this\image, 
                   constants::_check_( *this\flag, #__image_left ),
                   constants::_check_( *this\flag, #__image_top ),
                   constants::_check_( *this\flag, #__image_right ),
                   constants::_check_( *this\flag, #__image_bottom ),
                   constants::_check_( *this\flag, #__image_center ) )
      
      ;       If *this\image\change
      ;         *this\type = #__type_Buttonimage
      ;       EndIf
      
      ; - Create Text
      If *this\type = #__type_Button
        *this\class = "Button"
        
        *this\color = _get_colors_( )
        *this\__state = #__ss_front | #__ss_back | #__ss_frame
        
        ; PB 
        ; If Flag & #__text_border = #__text_border 
        *this\fs = 1
        *this\bs = *this\fs
        
        *this\text\padding\x = 4
        *this\text\padding\y = 4
        
        SetText( *This, Text )
      EndIf
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      ;       If flag & #__flag_noscrollbars = #False
      ;         Area( *this, 1, 0, 0, 0, 0 )
      ;       EndIf
      Resize( *this, x,y,width,height )
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Option( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      Protected *this.allocate( Widget ) 
      Protected *parent._s_WIDGET = OpenWidget( )
      ;flag | #__text_center
      
      If Root( )\count\childrens
        If Widget( )\type = #__type_Option
          *this\_group = Widget( )\_group 
        Else
          *this\_group = Widget( ) 
        EndIf
      Else
        *this\_group = OpenWidget( )
      EndIf
      
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      
      *this\type = #__type_Option
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ) )
      
      ;       *this\color\back =- 1; _get_colors_( ); - 1
      ;       *this\color\fore =- 1
      
      ; *this\__state = #__ss_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_( )\fore
      *this\color\front = _get_colors_( )\front
      
      
      *this\button\color = _get_colors_( )
      *this\button\color\back = $ffffffff
      
      *this\button\round = 7
      *this\button\width = 15
      *this\button\height = *this\button\width
      *this\text\padding\x = *this\button\width + 8
      
      *this\text\multiline =- CountString( Text, #LF$ )
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Resize( *this, x,y,width,height )
      If Text.s
        SetText( *this, Text.s )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Checkbox( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      Protected *this.allocate( Widget ) 
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      
      *this\type = #__type_CheckBox
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      
      _set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ) )
      
      *this\mode\threestate = constants::_check_( Flag, #PB_CheckBox_ThreeState )
      *this\text\multiline =- CountString( Text, #LF$ )
      
      ; *this\__state = #__ss_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_( )\fore
      *this\color\front = _get_colors_( )\front
      
      *this\button\color = _get_colors_( )
      *this\button\color\back = $ffffffff
      
      *this\button\round = 2
      *this\button\height = 15
      *this\button\width = *this\button\height
      *this\text\padding\x = *this\button\width + 8
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Resize( *this, x,y,width,height )
      If Text.s
        SetText( *this, Text.s )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i HyperLink( x.l,y.l,width.l,height.l, Text.s, Color.i, Flag.i = 0 )
      Protected *this.allocate( Widget ) 
      Protected *parent._s_WIDGET = OpenWidget( )
      
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      
      *this\type = #__type_HyperLink
      *this\cursor = #PB_Cursor_Hand
      *this\class = #PB_Compiler_Procedure 
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_( *this, flag | #__text_center );, 3 )
      
      *this\mode\lines = constants::_check_( Flag, #PB_HyperLink_Underline )
      *this\text\multiline =- CountString( Text, #LF$ )
      
      *this\__state = #__ss_front
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_( )\fore
      *this\color\front[#__s_0] = _get_colors_( )\front
      If Not Alpha( Color )
        Color = Color & $FFFFFF | 255<<24
      EndIf
      *this\color\front[#__s_1] = Color
      
      _set_align_flag_( *this, *parent, flag )
      SetParent( *this, *parent, #PB_Default )
      
      Resize( *this, x,y,width,height )
      If Text.s
        SetText( *this, Text.s )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ButtonImage( x.l,y.l,width.l,height.l, Image.i =-1 , Flag.i = 0, round.l = 0 )
      ProcedureReturn Button( x,y,width,height, "", Flag, Image, round )
    EndProcedure
    
    ;- 
    Procedure.i MDI( x.l,y.l,width.l,height.l, Flag.i = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_MDI, x,y,width,height, 0,0,0, #Null$, flag | #__flag_nogadgets, #__scroll_buttonsize,0,1 )
    EndProcedure
    
    Procedure.i Panel( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_Panel, x,y,width,height, 0,0,0, #Null$, flag | #__flag_noscrollbars, #__scroll_buttonsize,0,0 )
    EndProcedure
    
    Procedure.i Container( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_Container, x,y,width,height, 0,0,0, #Null$, flag | #__flag_noscrollbars, #__scroll_buttonsize,0,0 )
    EndProcedure
    
    Procedure.i ScrollArea( x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0 )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_ScrollArea, x,y,width,height, ScrollAreaWidth,ScrollAreaHeight,0, #Null$, flag, #__scroll_buttonsize,0,ScrollStep )
    EndProcedure
    
    Procedure.i Frame( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      Protected Size = 16, *this.allocate( Widget ) 
      ;_set_last_parameters_( *this, #__type_Frame, Flag, OpenWidget( ) )
      Protected *parent._s_WIDGET = OpenWidget( )
      
      With *this
        \x =- 1
        \y =- 1
        \container = #__type_Frame
        \color = _get_colors_( )
        \color\_alpha = 255
        \color\back = $FFF9F9F9
        
        \BarHeight = 16
        
        \bs = 1
        \fs = 1
        
        ;       ; \text.allocate( TEXT )
        ;       \text\edit\string = Text.s
        ;       \text\string.s = Text.s
        ;       \text\change = 1
        _set_text_flag_( *this, flag, 2, - 22 )
        
        *this\text\padding\x = 5
        ;*this\text\align\vertical = Bool( Not *this\text\align\top And Not *this\text\align\bottom )
        ;*this\text\align\horizontal = Bool( Not *this\text\align\left And Not *this\text\align\right )
        
        _set_align_flag_( *this, *parent, flag )
        SetParent( *this, *parent, #PB_Default )
        
        
        Resize( *this, x,y,width,height )
        If Text.s
          SetText( *this, Text.s )
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Image( x.l,y.l,width.l,height.l, image.i, Flag.i = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenWidget( ), #PB_Compiler_Procedure, #__type_Image, x,y,width,height, 0,0,image, #Null$, flag, #__scroll_buttonsize,0,1 )
    EndProcedure
    
    ;- 
    Procedure ToolBar( *parent._s_WIDGET, flag.i = #PB_ToolBar_Small )
      ProcedureReturn ListView( 0,0,*parent\width[#__c_inner],20, flag )
    EndProcedure
    
    Procedure ToolTip( *this._s_WIDGET, Text.s, item =- 1 )
      
      *this\_tt\text\string = Text 
    EndProcedure
    
    ;- 
    ;- 
    ;-  DRAWINGs
    Procedure   Button_Draw( *this._s_WIDGET )
      Protected x, y
      
      With *this
        ; update text 
        If *this\change 
          Editor_Update( *this, *this\row\_s( ) )
        EndIf
        
        If *this\image\change
          *this\image\padding\x = *this\text\padding\x 
          *this\image\padding\y = *this\text\padding\y
          
          ; make horizontal scroll max 
          If *this\width[#__c_required] < *this\image\width + *this\image\padding\x * 2
            *this\width[#__c_required] = *this\image\width + *this\image\padding\x * 2
          EndIf
          
          ; make vertical scroll max 
          If *this\height[#__c_required] < *this\image\height + *this\image\padding\y * 2
            *this\height[#__c_required] = *this\image\height + *this\image\padding\y * 2
          EndIf
          
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\image )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\image )
          
          
          _set_align_x_( *this\image, *this\image, *this\width[#__c_required], 0 )
          _set_align_y_( *this\image, *this\image, *this\height[#__c_required], 270 )
        EndIf
        
        If *this\type = #__type_Option Or 
           *this\type = #__type_CheckBox
          
          ; update widget ( option&checkbox ) position
          If *this\change
            *this\button\y = *this\y[#__c_inner] + ( *this\height[#__c_inner] - *this\button\height )/2
            
            If *this\text\align\right
              *this\button\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\button\height - 3 )
            ElseIf Not *this\text\align\left
              *this\button\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\button\width )/2
              
              If Not *this\text\align\top 
                If *this\text\rotate = 0
                  *this\button\y = *this\y[#__c_inner] + *this\y[#__c_required] - *this\button\height
                Else
                  *this\button\y = *this\y[#__c_inner] + *this\y[#__c_required] + *this\height[#__c_required]
                EndIf
              EndIf
            Else
              *this\button\x = *this\x[#__c_inner] + 3
            EndIf
          EndIf
        EndIf
        
        
        ; origin position
        x = *this\x[#__c_inner] + *this\x[#__c_required]
        y = *this\y[#__c_inner] + *this\y[#__c_required]
        
        ; background draw
        If *this\image[#__img_background]\id
          ; background image draw 
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          DrawAlphaImage( *this\image[#__img_background]\id, x + *this\image[#__img_background]\x, x + *this\image[#__img_background]\y, *this\color\_alpha )
        Else
          If *this\color\back <>- 1
            If \color\fore <>- 1
              DrawingMode( #PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend )
              _draw_gradient_( \vertical, *this,\color\Fore[\color\state],\color\Back[Bool( *this\__state&#__ss_back )*\color\state], [#__c_frame] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              _draw_box_( *this, color\back, [#__c_frame])
            EndIf
          EndIf
        EndIf
        
        ; draw text items
        If \text\string.s
          _clip_content_( *this, [#__c_clip1] )
          
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          ForEach *this\row\_s( )
            DrawRotatedText( x + *this\row\_s( )\text\x, y + *this\row\_s( )\text\y,
                             *this\row\_s( )\text\String.s, *this\text\rotate, *this\color\Front[Bool( *this\__state & #__ss_front ) * *this\color\state] ) ; *this\row\_s( )\color\font )
            
            If *this\mode\lines
              Protected i, count = Bool( func::GetFontSize( *this\row\_s( )\text\fontID ) > 13 )
              For i=0 To count
                Line( x + *this\row\_s( )\text\x, y + *this\row\_s( )\text\y + *this\row\_s( )\text\height - count + i - 1, *this\row\_s( )\text\width,1, *this\color\Front[Bool( *this\__state & #__ss_front ) * *this\color\state] )
              Next
            EndIf
            
          Next 
          
          _clip_content_( *this, [#__c_clip] )
        EndIf
        
        ; box draw    
        Protected _box_x_,_box_y_
        If #__type_Option = *this\type
          _draw_button_( 1, *this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\state, *this\button\round );, \color )
        EndIf 
        If #__type_CheckBox = *this\type
          _draw_button_( 3, *this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\state, *this\button\round );, \color )
        EndIf
        
        ; image draw
        If \image\id
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          DrawAlphaImage( \image\id, x + \image\x, y + \image\y, \color\_alpha )
        EndIf
        
        ; defaul focus widget frame draw
        If *this\flag & #__button_default
          DrawingMode( #PB_2DDrawing_Outlined )
          ;; RoundBox( \x[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\width[#__c_inner]-4+2,\height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1] )
          If \round 
            RoundBox( \x[#__c_inner]+2,\Y[#__c_inner]+2-1,\width[#__c_inner]-4,\height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1] ) 
          EndIf
          RoundBox( \x[#__c_inner]+2,\Y[#__c_inner]+2,\width[#__c_inner]-4,\height[#__c_inner]-4,\round,\round,*this\color\Frame[1] )
        EndIf
        
        ; area scrollbars draw 
        Area_Draw( *this )
        
        ; frame draw
        If *this\fs
          DrawingMode( #PB_2DDrawing_Outlined )
          _draw_box_( *this, color\frame, [#__c_frame])
        EndIf
      EndWith
    EndProcedure
    
    Procedure   Container_Draw( *this._s_WIDGET )
      With *this
        DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
        RoundBox( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;RoundBox( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        
        ;
        _clip_content_( *this, [#__c_clip2] )
        
        
        If \image\id Or *this\image[#__img_background]\id
          If *this\image\change <> 0
            _set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            _set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\image\change = 0
          EndIf
          
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          
          ; background image draw 
          If *this\image[#__img_background]\id
            DrawAlphaImage( *this\image[#__img_background]\id,
                            *this\x[#__c_inner] + *this\image[#__img_background]\x,
                            *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
          EndIf
          
          ; scroll image draw
          If \image\id
            DrawAlphaImage( \image\id,
                            *this\x[#__c_inner] + *this\x[#__c_required] + *this\image\x,
                            *this\y[#__c_inner] + *this\y[#__c_required] + *this\image\y, *this\color\_alpha )
          EndIf
        EndIf
        
        If \text\string
          DrawingMode( #PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend )
          DrawText( *this\x[#__c_inner] + *this\x[#__c_required] + \text\x, 
                    *this\y[#__c_inner] + *this\y[#__c_required] + \text\y, 
                    \text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
        EndIf
        
        ; area scrollbars draw 
        Area_Draw( *this )
        
        If *this\fs
          If \fs = 1 
            DrawingMode( #PB_2DDrawing_Outlined )
            RoundBox( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state] )
          Else
            If \color\alpha And \color\alpha\frame
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
            Else
              DrawingMode( #PB_2DDrawing_Default )
            EndIf
            RoundBox( \x[#__c_frame], \y[#__c_inner] - \fs, \width[#__c_frame], \fs, \round,\round, \color\frame[*this\color\state] )
            RoundBox( \x[#__c_frame], \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \color\frame[*this\color\state] )
            RoundBox( \x[#__c_frame]+\width[#__c_frame]-\fs, \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \color\frame[*this\color\state] )
            RoundBox( \x[#__c_frame], \y[#__c_frame]+\height[#__c_frame] - \fs, \width[#__c_frame], \fs, \round,\round, \color\frame[*this\color\state] )
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    
    Procedure.b Draw( *this._s_WIDGET )
      With *this
        ; init drawing font
        _draw_font_( *this )
        
        ; we call the event dispatched before the binding 
        If *this\event And 
           *this\count\events = 0 ;And ListSize( *this\event\queue( ) )
          *this\count\events = 1
          
          ForEach *this\event\queue( )
            Post( *this\event\queue( )\type, *this, *this\event\queue( )\item, *this\event\queue( )\data ) 
          Next
          ; ClearList( *this\event\queue( ) )
        EndIf
        
        ; limit drawing boundaries
        CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ) )
          _clip_content_( *this, [#__c_clip] )
        CompilerEndIf
        
        ; draw widgets
        Select \type
          Case #__type_Window         : Window_Draw( *this )
          Case #__type_MDI            : Container_Draw( *this )
          Case #__type_Container      : Container_Draw( *this )
          Case #__type_ScrollArea     : Container_Draw( *this )
          Case #__type_Image          : Container_Draw( *this )
            
            ;- widget::panel_draw( )
          Case #__type_Panel         
            If *this\_tab And *this\_tab\count\items
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              Box( *this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\color\back[0] )
            Else
              DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\back[0] )
              
              DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
              Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\frame[Bool( *this\_tab\index[#__tab_2] <>- 1 )*2 ] )
            EndIf
            
          Case #__type_String         : Editor_Draw( *this )
          Case #__type_Editor         : Editor_Draw( *this )
            
          Case #__type_Tree           : Tree_Draw( *this, *this\row\draws( ) )
          Case #__type_property       : Tree_Draw( *this, *this\row\draws( ) )
          Case #__type_ListView       : Tree_Draw( *this, *this\row\draws( ) )
            
          Case #__type_Text           : Button_Draw( *this )
          Case #__type_Button         : Button_Draw( *this )
          Case #__type_ButtonImage    : Button_Draw( *this )
          Case #__type_Option         : Button_Draw( *this )
          Case #__type_CheckBox       : Button_Draw( *this )
          Case #__type_HyperLink      : Button_Draw( *this )
            
          Case #__type_Spin ,
               #__type_tabbar,#__type_ToolBar,
               #__type_TrackBar,
               #__type_ScrollBar,
               #__type_ProgressBar,
               #__type_Splitter       
            
            Bar_Draw( *this )
        EndSelect
        
        ; 
        If *this\_tab And *this\_tab\count\items
          Tab_Draw( *this\_tab ) 
        EndIf
        
        ;         ; TEST  
        ;         If test_draw_box_clip_type = #PB_All Or 
        ;            test_draw_box_clip_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff0000ff )
        ;         EndIf
        ;         
        ;         If test_draw_box_clip1_type = #PB_All Or 
        ;            test_draw_box_clip1_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_clip1], *this\y[#__c_clip1], *this\width[#__c_clip1], *this\height[#__c_clip1], $ffff0000 )
        ;         EndIf
        ;         
        ;         If test_draw_box_clip2_type = #PB_All Or 
        ;            test_draw_box_clip2_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_clip2], *this\y[#__c_clip2], *this\width[#__c_clip2], *this\height[#__c_clip2], $ff00ff00 )
        ;         EndIf
        ;         
        ;         If test_draw_box_screen_type = #PB_All Or 
        ;            test_draw_box_screen_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_screen], *this\y[#__c_screen], *this\width[#__c_screen], *this\height[#__c_screen], $ff0000ff )
        ;         EndIf
        ;         
        ;         If test_draw_box_frame_type = #PB_All Or 
        ;            test_draw_box_frame_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff00ff00 )
        ;         EndIf
        ;         
        ;         If test_draw_box_inner_type = #PB_All Or 
        ;            test_draw_box_inner_type = *this\type
        ;           DrawingMode( #PB_2DDrawing_Outlined )
        ;           Box( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff0000 )
        ;         EndIf
        ;         
        ;         
        ;         If *this\parent
        ;           If test_draw_box_clip2_type = *this\parent\type
        ;             DrawingMode( #PB_2DDrawing_Outlined )
        ;             Box( *this\parent\x[#__c_clip2], *this\parent\y[#__c_clip2], *this\parent\width[#__c_clip2], *this\parent\height[#__c_clip2], $ff00ff00 )
        ;           EndIf
        ;           If test_draw_box_inner_type = *this\parent\type
        ;             DrawingMode( #PB_2DDrawing_Outlined )
        ;             Box( *this\parent\x[#__c_inner], *this\parent\y[#__c_inner], *this\parent\width[#__c_inner], *this\parent\height[#__c_inner], $ffff0000 )
        ;           EndIf
        ;         EndIf
        ;         ; ENDTEST
        
        
        ; 
        If *this\_state & #__s_disabled Or *this\color\state = #__s_3
          DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
          Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $80f0f0f0 )
        Else
          ; draw drag & drop
          If *this\_state & #__s_entered And _DD_drag_( )
            DD_draw( *this )
          EndIf
        EndIf
        
        
        ; 
        If _is_focused_( *this )
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          Box( *this\x[#__c_frame]-1, *this\y[#__c_frame]-1, *this\width[#__c_frame]+2, *this\height[#__c_frame]+2, $ffff0000 )
          Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
          Box( *this\x[#__c_frame]+1, *this\y[#__c_frame]+1, *this\width[#__c_frame]-2, *this\height[#__c_frame]-2, $ffff0000 )
        EndIf
        
        ; reset values
        If *this\change <> 0
          *this\change = 0
        EndIf
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        If *this\image\change <> 0
          *this\image\change = 0
        EndIf
        If *this\resize & #__resize_change
          *this\resize &~ #__resize_change
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   ReDraw( *this._s_WIDGET )
      If StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
                   #PB_Compiler_OS = #PB_OS_Windows
          ; difference in system behavior
          If *this\root\canvas\fontID
            DrawingFont( *this\root\canvas\fontID ) 
          EndIf
        CompilerEndIf
        
        ;
        If Not ( transform( ) And transform( )\grab )
          If _is_root_( *this )
            If *this\root\repaint = #True
              ;             CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
              ;               FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ) )
              ;             CompilerElse
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
              ;             CompilerEndIf
              ;; FillArea( 0, 0, -1, $f0f0f0 ) 
              ;             Else
              ;               DrawingMode(#PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
              ;               Box( 0, 0, OutputWidth( ), OutputHeight( ), $FFFFFFFF&$FFFFFF | 50<<24)
            EndIf
            
            PushListPosition( Widget( ) )
            ForEach Widget( )
              If Not Widget( )\hide And Widget( )\draw_widget And 
                 ( Widget( )\root\canvas\gadget = *this\root\canvas\gadget ) And 
                 ( Widget( )\width[#__c_clip] > 0 And Widget( )\height[#__c_clip] > 0 )
                
                ; begin draw all widgets
                Draw( Widget( ) )
                
                
                ; Draw anchors 
                If transform( )
                  If Widget( )\_state & #__s_entered And Widget( )\_a_id_
                    a_draw( Widget( ) )
                  EndIf
                  
;                   If a_widget( ) And a_widget( ) = Widget( ) And a_widget( )\_a_id_
;                     a_draw( a_widget( ) )
;                   EndIf
                EndIf
                
                ; draw group transform widgets frame
                If Widget( )\_a_transform = 2
                  UnclipOutput( )
                  DrawingMode( #PB_2DDrawing_Outlined )
                  Box( Widget( )\x[#__c_frame], Widget( )\y[#__c_frame], Widget( )\width[#__c_frame], Widget( )\height[#__c_frame], $ffff00ff )
                EndIf
                
;                 ;
;                 DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
;                 Box( Widget( )\x[#__c_frame], Widget( )\y[#__c_frame], Widget( )\width[#__c_frame], Widget( )\height[#__c_frame], $ffff0000 )
;                 Box( Widget( )\x[#__c_screen], Widget( )\y[#__c_screen], Widget( )\width[#__c_screen], Widget( )\height[#__c_screen], $ffff0000 )
                
              Else
                ; draw clip out transform widgets frame
                If Widget( )\_a_transform 
                  UnclipOutput( )
                  DrawingMode( #PB_2DDrawing_Outlined )
                  Box( Widget( )\x[#__c_inner], Widget( )\y[#__c_inner], Widget( )\width[#__c_inner], Widget( )\height[#__c_inner], $ff00ffff )
                EndIf
              EndIf
            Next
            PopListPosition( Widget( ) )
            
          Else
            Draw( *this )
          EndIf
        EndIf
        
        ; 
        UnclipOutput()
        
        If _is_focused_( *this )
          DrawingMode( #PB_2DDrawing_Outlined | #PB_2DDrawing_AlphaBlend )
          Box( *this\x[#__c_frame]-1, *this\y[#__c_frame]-1, *this\width[#__c_frame]+2, *this\height[#__c_frame]+2, $ffff0000 )
          Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
          Box( *this\x[#__c_frame]+1, *this\y[#__c_frame]+1, *this\width[#__c_frame]-2, *this\height[#__c_frame]-2, $ffff0000 )
        EndIf
        
        If transform( )
          If a_widget( ) And a_widget( )\_a_id_
            a_draw( a_widget( ) )
          EndIf
        EndIf
        
        ;         If EventWidget( )
        ;           Debug EventWidget( )\class
        ;         EndIf
        
        If *this\root\canvas\postevent <> #False
          *this\root\canvas\postevent = #False
        EndIf
        
        StopDrawing( )
      EndIf
    EndProcedure
    
    Procedure.i Post( eventtype.l, *this._s_WIDGET, *button = #PB_All, *data = #Null )
      Protected result.i, is_eventtype.b
      
      ; send update canvas 
      If eventtype = #__event_Repaint
        If *this <> #PB_All
          ; root( ) = *this\root
          ChangeCurrentElement( Root( ), @*this\root\canvas\address )
        EndIf
        
        _post_repaint_( Root( ), Root( ) )
      Else
        ;; Debug "  post - "+ *this\class +" "+ ClassFromEvent( eventtype )
        
        If Not WidgetEvent( )
          WidgetEvent( ).allocate( EVENTDATA )
        EndIf
        WidgetEvent( )\type = eventtype
        WidgetEvent( )\item = *button
        WidgetEvent( )\data = *data
        
        ; if called function bind( )
        If Not *this\count\events
          If Not *this\event
            *this\event.allocate( EVENT )
          EndIf
          
          ; find post event 
          ForEach *this\event\queue( )
            If *this\event\queue( )\type = eventtype
              is_eventtype = 1
              Break
            EndIf
          Next
          
          If Not is_eventtype
            AddElement( *this\event\queue( ) )
            *this\event\queue.allocate( EVENTDATA, ( ) ) 
            *this\event\queue( )\type = eventtype
          EndIf
          
          *this\event\queue( )\item = *button
          *this\event\queue( )\data = *data
        Else
          EventWidget( ) = *this
          
          If Not _is_root_( *this )
            If *this\event And result <> #PB_Ignore
              _post_event_( result, *this\event\bind( ), eventtype )
            EndIf
            
            If Not _is_window_( *this ) And 
               Not _is_root_( *this\window ) 
              If *this\window\event And result <> #PB_Ignore
                _post_event_( result, *this\window\event\bind( ), eventtype )
              EndIf
            EndIf
          EndIf
          
          If *this\root\event And result <> #PB_Ignore
            _post_event_( result, *this\root\event\bind( ), eventtype )
          EndIf
          
          If EventWidget( ) <> #Null
            EventWidget( ) = #Null
          EndIf
        EndIf
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind( *this._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      Protected is_eventtype.b, is_callback.b
      
      If *callback > 0
        If *this = #PB_All And 
           ListSize( Root( ) )
          *this = Root( )
        EndIf
        
        If Not *this
          ProcedureReturn #False
        EndIf
        
        If Not *this\event
          *this\event.allocate( EVENT )
        EndIf
        
        ; find bind event
        ForEach *this\event\bind( )
          If *this\event\bind( )\eventtype = eventtype
            is_eventtype = 1
            Break
          EndIf
        Next
        
        If Not is_eventtype
          AddElement( *this\event\bind( ) )
          *this\event\bind.allocate( Bind, ( ) ) 
          *this\event\bind( )\eventtype = eventtype
        EndIf
        
        ForEach *this\event\bind( )\callback( )
          If *this\event\bind( )\callback( )\func = *callback
            is_callback = 1
            Break
          EndIf
        Next
        
        If Not is_callback
          AddElement( *this\event\bind( )\callback( ) )
          *this\event\bind( )\callback.allocate( FUNC, ( ) )
          *this\event\bind( )\callback( )\func = *callback
        EndIf
        
        ProcedureReturn *this\event\bind( )
      Else
        If Root( )\canvas\bindevent = #False
          Root( )\canvas\bindevent = #True
          BindGadgetEvent( Root( )\canvas\gadget, @EventHandler( ) )
        EndIf
        If *callback
          Root( )\repaint = #True
        EndIf
        ProcedureReturn Root( )
      EndIf
    EndProcedure
    
    Procedure.i Unbind( *this._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      If *this = #PB_All And 
         ListSize( Root( ) )
        *this = Root( )
      EndIf
      
      If Not *this
        ProcedureReturn #False
      EndIf
      
      ; set bind evet
      ForEach *this\event\bind( )
        If *this\event\bind( )\eventtype = eventtype
          
          ForEach *this\event\bind( )\callback( )
            If *this\event\bind( )\callback( )\func = *callback
              DeleteElement( *this\event\bind( )\callback( ) )
            EndIf
          Next
          
          Break
        EndIf
      Next
      
      ;       
      ;       ProcedureReturn *this\event
    EndProcedure
    
    Procedure PBFlag( Type, Flag )
      Protected flags
      
      Select Type
        Case #__type_CheckBox
          If Flag & #PB_CheckBox_Right = #PB_CheckBox_Right
            Flag &~ #PB_CheckBox_Right
            flags | #__text_right
          EndIf
          If Flag & #PB_CheckBox_Center = #PB_CheckBox_Center
            Flag &~ #PB_CheckBox_Center
            flags | #__text_center
          EndIf
          
        Case #__type_Text
          If Flag & #PB_Text_Border = #PB_Text_Border
            Flag &~ #PB_Text_Border
            flags | #__text_border
          EndIf
          If Flag & #PB_Text_Center = #PB_Text_Center
            Flag &~ #PB_Text_Center
            flags | #__text_center
          EndIf
          If Flag & #PB_Text_Right = #PB_Text_Right
            Flag &~ #PB_Text_Right
            flags | #__text_right
          EndIf
          
        Case #__type_Button
          If Flag & #PB_Button_Left = #PB_Button_Left
            Flag &~ #PB_Button_Left
            flags | #__button_left
          EndIf
          If Flag & #PB_Button_Right = #PB_Button_Right
            Flag &~ #PB_Button_Right
            flags | #__button_right
          EndIf
          If Flag & #PB_Button_MultiLine = #PB_Button_MultiLine
            Flag &~ #PB_Button_MultiLine
            flags | #__button_multiline
          EndIf
          If Flag & #PB_Button_Toggle = #PB_Button_Toggle
            Flag &~ #PB_Button_Toggle
            flags | #__button_toggle
          EndIf
          If Flag & #PB_Button_Default = #PB_Button_Default
            Flag &~ #PB_Button_Default
            flags | #__button_default
          EndIf
          
        Case #__type_Tree
          If Flag & #PB_Tree_AlwaysShowSelection = #PB_Tree_AlwaysShowSelection
            Flag &~ #PB_Tree_AlwaysShowSelection
            flags | #__tree_alwaysselection
          EndIf
          If Flag & #PB_Tree_CheckBoxes = #PB_Tree_CheckBoxes
            Flag &~ #PB_Tree_CheckBoxes
            flags | #__tree_checkboxes 
          EndIf
          If Flag & #PB_Tree_ThreeState = #PB_Tree_ThreeState
            Flag &~ #PB_Tree_ThreeState
            flags | #__tree_threestate
          EndIf
          If Flag & #PB_Tree_NoButtons = #PB_Tree_NoButtons
            Flag &~ #PB_Tree_NoButtons
            flags | #__tree_nobuttons
          EndIf
          If Flag & #PB_Tree_NoLines = #PB_Tree_NoLines
            Flag &~ #PB_Tree_NoLines
            flags | #__list_nolines
          EndIf
          
      EndSelect
      
      flags | Flag
      ProcedureReturn flags
    EndProcedure
    
    
    ;-
    Procedure message_events( )
      Protected result
      
      If WidgetEventType( ) = #__event_LeftClick
        Select EventWidget( )\index
          Case 4 : result = #PB_MessageRequester_Yes    ; yes
          Case 5 : result = #PB_MessageRequester_No     ; no
          Case 6 : result = #PB_MessageRequester_Cancel ; cancel
        EndSelect
        
        SetData( EventWidget( )\window, result )
        PostEvent( #PB_Event_CloseWindow, EventWindow( ), EventWidget( )\window )
      EndIf
    EndProcedure
    
    Procedure Message( Title.s, Text.s, Flag.i = #Null )
      Protected result
      Protected img =- 1, f1 =- 1, f2=8, width = 400, height = 120
      Protected bw = 85, bh = 25, iw = height-bh-f1 - f2*4 - 2-1
      
      Protected x = ( Root( )\width-width-#__window_frame_size*2 )/2
      Protected y = ( Root( )\height-height-#__window_caption_height-#__window_frame_size*2 )/2
      ;       Protected x = ( root( )\width-width )/2
      ;       Protected y = ( root( )\height-height )/2
      Protected *parent;._s_WIDGET = EventWidget( )\window ; OpenWidget( )
      
      Protected Window = Window( x,y, width, height, Title, #__window_titlebar, *parent)
      Widget( )\class = #PB_Compiler_Procedure
      ;SetAlignment( widget( ), #__align_center )
      Bind( Widget( ), @message_events( ) )
      Sticky( Widget( ), #True )
      
      
      If Flag & #PB_MessageRequester_Info
        img = CatchImage( #PB_Any, ?img_info, ?end_img_info - ?img_info )
        
        DataSection
          img_info: 
          ; size : 1404 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$2800000028000000,$B8FE8C0000000608,$474B62060000006D
          Data.q $A0FF00FF00FF0044,$493105000093A7BD,$5F98CD8558544144,$3B3BBFC71C47144C,$54C0F03D7F7BB707
          Data.q $14DA0D5AD0348C10,$7C1A6360A90B6D6D,$6D03CAADF49898D3,$D1A87D7AD262545F,$B69B5F469AA9349A
          Data.q $680D82AB6C37D269,$A6220B47FA51A890,$DECFEE38E105102A,$053FB87D333B772E,$CCDD3CF850EE114A
          Data.q $0766FDFE767ECCDC,$F476DC569948E258,$5BCA94AD89227ADA,$3C10B9638C15E085,$7A59504C89240017
          Data.q $8055B371E2774802,$2E678FEAA9A17AFC,$06961711C3AC7F58,$EF905DD4CA91A322,$A159B0EAD38F5EA2
          Data.q $4D30000CA9417358,$1A3033484098DD06,$2C671601A343EB08,$EDD3F547A138B820,$DAFB560A82C89ABE
          Data.q $2E1D2C863E5562A8,$3CD50AAB359173CC,$8D8C00262FCE6397,$83FB0DA43FD7D187,$DDAAFF5D74F85C02
          Data.q $B3A477582D666357,$45754E5D9B42C73C,$16732AAEDD894565,$41FBABA3A6B0899B,$3FAB16311F45A424
          Data.q $8FDB82C66F4B707F,$1595D6EF9001DD5F,$69B32B24BD2B2529,$EA0DEEB7E6181FDC,$9D9F369A5BBB6326
          Data.q $A94FBDAEC7BBE0B7,$A732EAE5951BF5F4,$5C114204D2DD216D,$6B9C344C651BD9B9,$5F8FDB82CE66FAAA
          Data.q $5F57EDFEF90841DD,$8469F486ECB61D52,$C2634777AE971D35,$2A9E9FF5E072D5DC,$8DE85A9CB3A47758
          Data.q $4DCF559EDB963737,$0D1DD74741182C67,$C9DDD550E5F86C71,$E68DAFB555E65365,$79E522B2BAF36858
          Data.q $B2DAC765C78001C9,$8DAFB573522C2B62,$8F9455C8929B2E4E,$77B1059330B54E5C,$D579F26E672AD4E3
          Data.q $AC8D0E0F2BD2BD5F,$9F9532F8021F1304,$C910838758FEB56E,$816E0DF732515957,$DAAF81036D5F2CA9
          Data.q $C2E305A5E54F66D7,$73EED922E79850D2,$88B9E6F02BB0E0D9,$2241697952FB2AA2,$B51C5D50B8ACB1A3
          Data.q $69322368555B297F,$A654FC089009A54C,$1E34DD1B45EE65EE,$5F9F7579224403B7,$416D440905240B59
          Data.q $244059B47C668BBE,$56F2A644DDF22B00,$1EBC77E473482920,$E3DCB126CD5175A7,$E720A4816B952854
          Data.q $AA1C1F8C97DBB0A8,$3CE0A0A481CA0015,$2829A74C5DCDCD5F,$0F5481799C981CD6,$9356B8BCB2A56E0A
          Data.q $0B4C0AC3821950B0,$6188962AC4914B75,$8326E2692ED8B632,$32112C58C9006044,$ECE858E5B0989D1A
          Data.q $743677B1BE616735,$07BA4027E44A0623,$6C80F60B188E13D1,$829201DC00066B09,$8C96858E8E2EC9A6
          Data.q $805AC633A82068E1,$371FE43AD04336D4,$3E017C48017AE2C5,$292045C9C672091A,$FE17193FA6FF7E78
          Data.q $24BB170DC670F1B1,$228215E7B04759EC,$8381081FD341E657,$105A57F6BD342FFB,$B487FAFAA7631800
          Data.q $02CD8258AB7E1B4C,$7FAFA533BF1272D8,$0B4E95227E4D3348,$C2283FB0F4FD51EA,$448A12D9E3719E9A
          Data.q $A9D39441710FE231,$C02226AFBB60B4BC,$BE71A320F3D6FF0F,$B80C4880C5A02FD4,$EAE80059B3FE70FC
          Data.q $BFD96D3E2109AFBE,$33433E3653923D3E,$6181FDEF7925044E,$40CCA2BCC151695B,$BFB32F995BDBE050
          Data.q $4BD80C6A38598607,$EED1229FCE4E4FFB,$37BADFD58B1931AB,$9AC9DFBE734207A8,$31180DF76E30F1B1
          Data.q $484A73B9DC7FEBCE,$D7A5B83F9D2F4FFB,$F3E8DECDC7776C64,$77EFE7474D218F98,$BEA6C0F5ABB1CE75
          Data.q $E6D34B630E33E5E9,$D1DDEBF686899CB3,$30F1B1C9EBB3E0B1,$707F829A8EE8DF2E,$EB33FE99E7EAA9A1
          Data.q $92547BE745F7507E,$CF3D5948A6BB587F,$BB773989021B3939,$EE4FFEBB1CE0C06F,$17B5C8FDB00082A9
          Data.q $0D85E5765D9A9161,$D2CFBB3D8776A515,$B091079EAE8A2450,$58699FAF38C60FA6,$AAAC44AE240825E7
          Data.q $524EF9BCCF8048DA,$7CE63B71E6C2BC56,$B1F0FBBCC0BA9B3D,$B389F106710FE236,$E0B19105F4D4FFA4
          Data.q $4964FB2AA2BB5124,$96EF9053D965946A,$5542B5438A9C7B97,$AA218C9B953A9172,$F504091819AC204F
          Data.q $19C68C085CE323C7,$0AFC1667EBA1393B,$9132FEBD1DB62678,$0A88495AE54CAD78,$974C713C10AF0B93
          Data.q $C7A92409E9132188,$DA1DCE5A182B5934,$00FF3496B3E99DD4,$C5E52BD0901E71B2,$444E454900000000
          Data.b $AE,$42,$60,$82
          end_img_info:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Error
        img = CatchImage( #PB_Any, ?img_error, ?end_img_error - ?img_error )
        
        DataSection
          img_error: 
          ; size : 1642 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$3000000030000000,$F902570000000608,$474B620600000087
          Data.q $A0FF00FF00FF0044,$491F06000093A7BD,$41D9ED8168544144,$CCEFF1C71DC7546C,$F6A06C4218C6ED7A
          Data.q $E448A410E515497A,$2070C40BB121A4E0,$46DC512B241A4E54,$124BD29004AB2039,$5150F4DA060B2630
          Data.q $52894889E9734815,$42B01552AB888955,$0A9535535581A8E4,$A69B1B838C151352,$0F5F9BEDFAF1DAF1
          Data.q $1B16F7DEBB3635DE,$DBF3D5DEB2E7A873,$8599BCFFBCCDEFCF,$8B999BBFFED0B685,$D94DFC3235B5A893
          Data.q $2AD241A8331E9177,$A24A50090AA21D50,$F4E23494382E38DF,$CDC2449B1FD5A692,$67C9F4601567BBF6
          Data.q $EA910FC176C73A56,$FB3E2C820C026811,$90FA231C4D0CFD92,$77E7A6B4722EFB8E,$3975B5B8601AF37D
          Data.q $E795079E6401C8E9,$718909C7B3E02570,$139E92E751637E23,$67B6C9EA403CB783,$16621CEA8257EE71
          Data.q $51DA72431163C9F8,$ED40125BADFBB67D,$B69198EA40D4D1ED,$E1CFD7F08E620A6A,$649A76066FAEE378
          Data.q $1CAF696A00B39BD2,$F8A5BF1E82DFA931,$B68B1E9F7E92E7EC,$10366C83462792C6,$9B483C679D1EDEDF
          Data.q $E5ADFDD3DFC7CA2B,$679B1D481A900EB3,$FD5FC5A1C6FDEE7C,$789EA5087457C832,$DF27E036FC740DB6
          Data.q $2EDEA7739A99E91B,$7D63573D4FD7C039,$091E176ECB121FEF,$3D92C5F7739E6BA1,$E3F8C8438CEC4B05
          Data.q $E338639DC7E0C287,$93E731F8D0BBE631,$A883C20B9CF064CA,$C03059C99BECC32E,$8A2A927678B696E8
          Data.q $6773962BC31DF31F,$5E32A40D35BC1ED7,$61AE34C8F7C47E20,$B482B75C33F7CFE9,$BD6DC8C3B3E18BF3
          Data.q $F3CE00E87774D0D6,$C8C73B8EC3301077,$1EAA53FC3F1397B7,$A3ED685DBED88879,$889BEB3C515EF88C
          Data.q $FBB987C6E2C3DC1F,$4F437B575A305FF5,$D8C99E55CF67C74C,$B432B0912802A16D,$0BD967DF31F98D05
          Data.q $2244C006A9AB295B,$95211F6B425F3AC4,$131BB7DFAF88CCC9,$17F2C3565D100089,$60D9F045FBE631B7
          Data.q $0C030246B6B523F0,$1BA0F14E30F0BF9F,$EF9127DDBFE58A36,$7DED884489AFFE4F,$0078CCC4F5CBAD05
          Data.q $A1A89BAF79FF3EF9,$AF17ABFAEFE27E38,$B54C2C7A40060436,$9FD33FDED83596F9,$D82EC4FA885E59F8
          Data.q $D0F7C463C6548EB0,$7ABDF473BC7CC6DA,$3F0026054BD3D308,$C1803039A9C479F1,$CC32DA5654B6183D
          Data.q $843D34389FD11F87,$875C6CC25F3AC4B5,$EFC7C8EAEF1236D6,$86D6458670FE883D,$6F207AF2E72123C2
          Data.q $EE229FADFBFAF81E,$E35C19F88FCEA52F,$89B8CABF4FF7EA1A,$F8B374EBF5EC6161,$5A3FDFED5BFB10EC
          Data.q $524EA5751007B45D,$7B2B97B0FD822695,$BC3B99AC09EB4E0F,$A8050B7237754E04,$6194D2B63B9F052A
          Data.q $FCB800F3AFA5E83E,$D12A27E1D9A4A295,$FA6EE7C74A0110E2,$3343761C4CC77B89,$A4788CCDAA213002
          Data.q $66EA532260530BFC,$3698EAEF136AB9F0,$377FBE21937FAE6C,$F026FF1923335366,$598BE240181C3102
          Data.q $3270DA691B56A7E1,$666A6EC0EAEF12D6,$08BE902F11299324,$7D1CEF04E7174011,$C4AF2272F4B8079D
          Data.q $9181BE3CC1EC0FC6,$C085D20F121D8CEC,$B0DECF8273F38800,$621F92BD2E59CCE6,$A6A48DE6EC4EC1E5
          Data.q $181F3A4E3C00A70C,$F4D5891F61D388C0,$FF7BBCB9F7DE3E68,$9675385AC3B9B564,$5373410C15F6BBCB
          Data.q $ECEB025E38B489F6,$8C7F569A4B00C0E9,$4B1CE3220F0C5CB8,$4FE0BA3BE3E5365B,$7F45AC8B952B4C1F
          Data.q $2DEA844889EFC9EC,$AA5D23C40BBE782D,$091207B8325CECFD,$630A823C3166F487,$4543837863E1F7F9
          Data.q $19E4E8B5A54439F1,$CBEF0864EAFCBD2E,$4131B94C3B5E0641,$2D1D5E40D37B9078,$4D6E25BF5A1CA4B8
          Data.q $EEB9F085E5489FE6,$FC565ABAD19F3B4E,$A7A63EFBBDAE05E4,$6E687C654A927037,$E61DAF030B4B7AA2
          Data.q $3330F5B7215D7F8E,$DF6577BFDC7F695E,$FAD5F0000A84AF5F,$73E133C7EE175E27,$6A27DF318E73D6A5
          Data.q $EF9E3E769954FD08,$47491E3068863728,$99CE42CECBFF3FEA,$D060C40EE915C4D7,$1E3436B2A80CBC02
          Data.q $1F8B0DAC8B0C0A89,$CEE0189ADA5B5132,$7C316769C9AF2793,$336A9850616065F1,$19C98BB16DA138F5
          Data.q $ED9F556C6E8B7D37,$3A0F0BB71BC70B7E,$03198A7793FCFF1A,$E71DB45BAAEEE677,$EFB1DD41BC6F9DDE
          Data.q $B7736A17C8317D2C,$077E9A22B2A5A1BF,$E37DE9DE572F3CD8,$B9BF6727F58E9E45,$86F6AD189E4B100B
          Data.q $B13618F9EBF4207E,$F1370F06153E967B,$E8769E1B43D0C703,$DA14BFE31CD96208,$607AA16C6FE6341E
          Data.q $630AEDEA7739AB6A,$7C039E94863A4956,$152AAF8DE711D25A,$E681F06F91FCB30F,$65624DA80766477A
          Data.q $DDC7F71DC8CBF889,$35C804BCEC3342D1,$388C1EF7C0FABD81,$AA70FBA106B9CB35,$887D7214F8B2AA07
          Data.q $FB5D3D9D6F3A4E8B,$B6859B67A164B9D9,$FEEC7FED695A16D0,$00006B709A860323,$42AE444E45490000
          Data.b $60,$82
          
          
          end_img_error:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Warning
        img = CatchImage( #PB_Any, ?img_warning, ?end_img_warning - ?img_warning )
        
        DataSection
          img_warning: 
          ; size : 1015 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$2800000028000000,$B8FE8C0000000608,$474B62060000006D
          Data.q $A0FF00FF00FF0044,$49AC03000093A7BD,$DD98ED8558544144,$67339F8718551C6B,$6BA934DBB3B3B267
          Data.q $60255624DDDB3493,$785E2A42F0458295,$068C4AF69BDA17E3,$030B4150FDBB362A,$D9AC514B49409622
          Data.q $86FF825726F0546E,$2968A4290537B482,$7B79EF7CD1F26F42,$CCECECDD9B68DDB1,$3DE7337B07E4DE84
          Data.q $CE73DE666FECFBEF,$BE4895C549A28EC0,$D18003BEE526913D,$1BC8E3E7C60FAABF,$9FECC2827EF8A00B
          Data.q $A661997980015464,$5B7351EBFBE505F3,$47813B9850001351,$53C3D570C7AAE19E,$B23A91C71FB3F205
          Data.q $DEADAC5DE7CBF283,$8B8B83D4866AB9E2,$A3501A8AC0BD75C0,$F5C1DD1FC946EE17,$A401C06F62B271D5
          Data.q $FA6A26F924D8AC80,$7E5A30F4E54A0E48,$5560C8F125D550E7,$EF525E4622D61FC1,$09839A235B0F5C4F
          Data.q $6801C1363A672499,$22528E5162499C81,$1C849B7E9D4CA034,$9B0B11E8E79A47A4,$D4275B0ADE94A961
          Data.q $86766961DF69962D,$ACF075B2DD97A5A7,$D5E5ADCCBFD61B82,$E0E70AD6ED2BCBC9,$01C25A643259C2E2
          Data.q $267D976692740A74,$BDB1C9941DB6A94C,$00648F1BCF26FAD8,$B2C7BE9AE0658040,$5EA769DE2F46A039
          Data.q $1126BD12FA3A0EFB,$4936293C09200E18,$A54A016D72DDA26B,$768E93EC9BC50878,$2E521BC80E33910B
          Data.q $141140605A676E1D,$A093744937932ADA,$8281A48D7ED62F67,$15A3F82459547171,$403871C753A9C1DC
          Data.q $06470A2CF737C256,$804094E82C78A9F8,$D268304CD1725D32,$92EA1CB5051ED691,$7565900D8BC67CFC
          Data.q $D18BC6D5D9712E8E,$117CC62E3760194C,$10E54E54A025BC24,$2A40E3FD026F2319,$6858AA64C64A1498
          Data.q $61F477CD41DADA15,$27D00E40F641C4E3,$8096E855B9759636,$67D2AF1465F163F2,$8B1B13EAEAE0D8EC
          Data.q $535855B2BD295223,$321995650B7DF140,$C60B95CDEEFB4C6E,$B8D66D1F4CB2AB43,$D29243E17FBD28B6
          Data.q $084F4AD2B684774F,$4859A46E52C3D2B8,$3D5D0669FAB94043,$435D5C1B6F49A0CF,$B3ACF95CB8C88D26
          Data.q $D9AFD513076370D1,$EC1E3B578FDB0E23,$4DE1A355F6B926C1,$FEC232053D2E5280,$8171BCABDB194E87
          Data.q $9B43A3CCF63AB911,$1D8D8BF4930EEB37,$1B03C18628DF29A2,$2381EFADB70E37E8,$5E94A941C87A1FFF
          Data.q $4653A34D7B30E2C3,$57BCFD90E834E96B,$37AF4AA6517A9634,$506499A04FDF1404,$4BE860F68ADAA152
          Data.q $7B4EB6B20E173A18,$DF46D1F2B907EA58,$CA9492773F250FFD,$BBF30895BD7115D2,$BF527F49C6E93C04
          Data.q $2DC126EA5CA400A4,$73BAB8046E349A0E,$A6B8292C73E17BD5,$BB85E8D406B15816,$05103AFB551D0735
          Data.q $DA95C00E05160EAE,$1B16FD43CE570957,$DA5DBF1B621FD38E,$EA54075063860747,$5917BB61884A7336
          Data.q $FBD40FF52823CC02,$FE37EB4DCBBCBAE0,$9BF9A436D938F722,$8ED1D8C6E3DEF555,$2EE409553D03EE00
          Data.q $4900000000FAB21F
          Data.b $45,$4E,$44,$AE,$42,$60,$82
          end_img_warning:
        EndDataSection
      EndIf
      
      
      Container( f1,f1,width - f1*2, height-bh-f1 - f2*2-1 ) 
      Image( f2,f2,iw, iw, img, #PB_Image_Border | #__flag_center )
      Text( f2+iw+f2, f2, width - iw, iw, Text, #__text_center | #__text_left )
      CloseList( )
      
      Button( width-bw-f2,height-bh-f2,bw,bh,"Ok", #__button_default )
      SetAlignment( Widget( ), #__align_bottom | #__align_right )
      
      If Flag & #PB_MessageRequester_YesNo Or 
         Flag & #PB_MessageRequester_YesNoCancel
        SetText( Widget( ), "Yes" )
        Button( width-( bw+f2 )*2-f2,height-bh-f2,bw,bh,"No" )
        SetAlignment( Widget( ), #__align_bottom | #__align_right )
      EndIf
      
      If Flag & #PB_MessageRequester_YesNoCancel
        Button( width-( bw+f2 )*3-f2*2,height-bh-f2,bw,bh,"Cansel" )
        SetAlignment( Widget( ), #__align_bottom | #__align_right )
      EndIf
      
      ; no do repeat
      If Root()\canvas\postevent = #True
        WaitClose( Window )
        Root()\canvas\postevent = #True
      EndIf
      
      ;;Sticky( window, #False )
      result = GetData( Window )
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure Mouse_events( *this._s_WIDGET, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected repaint
      
      
      ; at point row
      If eventtype = #__event_MouseEnter Or
         eventtype = #__event_MouseLeave Or 
         eventtype = #__event_MouseMove
        
        ; get at point (item; button;)
        If eventtype = #__event_MouseLeave 
          If LeaveWidget( )\count\items
            ;; Debug ""+*this\class+" leave - set color state " 
          EndIf
          
          If mouse( )\buttons
            If LeaveRow( ) 
              If Atpoint( *this, mouse( )\x, mouse( )\y, [#__c_inner] ) 
                
                LeaveRow( )\_state &~ #__s_entered
                If LeaveRow( )\color\state = #__s_1
                  LeaveRow( )\color\state = #__s_0
                EndIf
                
              Else
                
                If LeaveRow( ) 
                  LeaveRow( )\_state &~ #__s_entered
                  If LeaveRow( )\color\state = #__s_1
                    LeaveRow( )\color\state = #__s_0
                    repaint = #True
                  EndIf
                EndIf
                
                If ListSize( FocusWidget( )\row\draws( ) )
                  If mouse( )\y < FocusWidget( )\y[#__c_inner]
                    FocusWidget( )\row\leaved = FocusWidget( )\row\first_visible
                    Debug 77777777774
                  ElseIf mouse( )\y > ( FocusWidget( )\y[#__c_inner] + FocusWidget( )\height[#__c_inner] )
                    FocusWidget( )\row\leaved = FocusWidget( )\row\last_visible
                    Debug 99999999994
                  Else
                    FocusWidget( )\row\leaved = LeaveRow( )
                  EndIf
                  
                  FocusWidget( )\row\leaved\_state | #__s_entered
                  
                  If FocusWidget( )\row\leaved\color\state = #__s_0
                    FocusWidget( )\row\leaved\color\state = #__s_1
                    repaint = #True
                  EndIf 
                EndIf
                ;                 
              EndIf
              
              LeaveRow( ) = #Null
            EndIf
            
            repaint = #True
          EndIf 
          
          ; reset at point element
          EnterRow( ) = #Null
          EnterButton( ) = #Null
          
          If *this\type = #__type_tabbar Or *this\type = #__type_ToolBar
            *this\index[#__tab_1] =- 1
            _get_bar_enter_item_( *this ) = #Null
          EndIf
          
        Else
          
          ; get at_point_item address
          If ListSize( EnterWidget( )\row\draws( ) ) And 
             Atpoint( EnterWidget( ), mouse( )\x, mouse( )\y, [#__c_inner] ) 
            
            If ListSize( EnterWidget( )\row\_s( ) )
              If Not ( EnterRow( ) And Atpoint( EnterRow( ),
                                                mouse( )\x + EnterWidget( )\scroll\h\bar\page\pos,
                                                mouse( )\y + EnterWidget( )\scroll\v\bar\page\pos ) )
                
                ; reset entered item
                EnterRow( ) = #Null
                
                ; search entered item
                LastElement( EnterWidget( )\row\draws( ) ) 
                Repeat                                 
                  If EnterWidget( )\row\draws( )\draw And 
                     Not EnterWidget( )\row\draws( )\hide And 
                     Atpoint( EnterWidget( )\row\draws( ),
                              mouse( )\x + EnterWidget( )\scroll\h\bar\page\pos,
                              mouse( )\y + EnterWidget( )\scroll\v\bar\page\pos )
                    
                    EnterRow( ) = EnterWidget( )\row\draws( ) 
                    repaint = #True       
                    Break
                  EndIf
                Until PreviousElement( EnterWidget( )\row\draws( ) ) = #False 
              EndIf
              
            EndIf
            
          Else
            If EnterRow( ) <> #Null
              EnterRow( ) = #Null
            EndIf
          EndIf
          
          
          If EnterWidget( )\bar
            If EnterWidget( )\count\items And ; EnterButton( ) = EnterWidget( )\bar\button[#__b_3]
                                              ; Atpoint( EnterWidget( ), mouse_x, mouse_y, [#__c_clip] ) And 
              Atpoint( EnterWidget( ), mouse_x, mouse_y, [#__c_inner] )
              
              ; splitter хурмит
              If ListSize( EnterWidget( )\bar\_s( ) ) And EnterWidget( )\type = #__type_tabbar Or EnterWidget( )\type = #__type_ToolBar
                ForEach EnterWidget( )\bar\_s( )
                  ; If EnterWidget( )\bar\_s( )\draw
                  If Atpoint( EnterWidget( )\bar\_s( ), 
                              mouse_x - EnterWidget( )\bar\button[#__b_3]\x,
                              mouse_y - EnterWidget( )\bar\button[#__b_3]\y )
                    
                    ;If Atpoint( EnterWidget( )\bar\_s( ), mouse_x, mouse_y ) And EnterWidget( )\bar\from = #__b_3
                    If EnterWidget( )\index[#__tab_1] <> EnterWidget( )\bar\_s( )\index
                      If EnterWidget( )\index[#__tab_1] >= 0
                        ; Debug " leave tab - " + EnterWidget( )\index[#__tab_1]
                        Repaint | #True
                      EndIf
                      
                      EnterWidget( )\index[#__tab_1] = EnterWidget( )\bar\_s( )\index
                      ; Debug " enter tab - " + EnterWidget( )\index[#__tab_1]
                      _get_bar_enter_item_( *this ) = EnterWidget( )\bar\_s( )
                      Repaint | #True
                    EndIf
                    Break
                    
                  ElseIf EnterWidget( )\index[#__tab_1] = EnterWidget( )\bar\_s( )\index
                    ; Debug " leave tab - " + EnterWidget( )\index[#__tab_1]
                    EnterWidget( )\index[#__tab_1] =- 1
                    _get_bar_enter_item_( *this ) = #Null
                    Repaint | #True
                    Break
                  EndIf
                  ; EndIf
                Next
              EndIf
            ElseIf EnterWidget( )\type = #__type_tabbar Or EnterWidget( )\type = #__type_ToolBar
              If EnterWidget( )\index[#__tab_1] <> - 1
                EnterWidget( )\index[#__tab_1] = - 1
                _get_bar_enter_item_( *this ) = #Null
              EndIf
            EndIf
            
            ; get at_point_button address
            If Not ( EnterButton( ) And 
                     Atpoint( EnterButton( ), mouse( )\x, mouse( )\y ) And 
                     Atpoint( EnterWidget( ), mouse( )\x, mouse( )\y, [#__c_inner] ) )
              
              ; reset entered button
              EnterButton( ) = #Null
              
              ; search entered button
              If EnterWidget( )\bar\button[#__b_1]\interact And 
                 Atpoint( EnterWidget( )\bar\button[#__b_1], mouse_x, mouse_y )
                
                If EnterButton( ) <> EnterWidget( )\bar\button[#__b_1]
                  EnterButton( ) = EnterWidget( )\bar\button[#__b_1]
                EndIf
              ElseIf EnterWidget( )\bar\button[#__b_2]\interact And
                     Atpoint( EnterWidget( )\bar\button[#__b_2], mouse_x, mouse_y )
                
                If EnterButton( ) <> EnterWidget( )\bar\button[#__b_2]
                  EnterButton( ) = EnterWidget( )\bar\button[#__b_2]
                EndIf
              ElseIf EnterWidget( )\bar\button[#__b_3]\interact And
                     Atpoint( EnterWidget( ), mouse_x, mouse_y, [#__c_inner] ) And
                     Atpoint( EnterWidget( )\bar\button[#__b_3], mouse_x, mouse_y, )
                
                If EnterButton( ) <> EnterWidget( )\bar\button[#__b_3]
                  EnterButton( ) = EnterWidget( )\bar\button[#__b_3]
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; do items events entered & leaved 
        If LeaveRow( ) <> EnterRow( ) And 
           Not ( EnterRow( ) = #Null And FocusWidget( ) And _is_selected_( FocusWidget( ) ) )  
          ; Not ( EnterRow( ) = #Null And _is_selected_( *this ) )  
          
          If LeaveRow( ) And
             LeaveRow( )\_state & #__s_entered
            LeaveRow( )\_state &~ #__s_entered
            
            If _is_current_( EnterWidget( ) )
              If LeaveRow( )\color\state = #__s_1
                LeaveRow( )\color\state = #__s_0
                repaint = #True
              EndIf
            EndIf
          EndIf
          
          If EnterRow( ) And 
             EnterRow( )\_state & #__s_entered = #False
            
            If _is_selected_( EnterWidget( ) ) And 
               EnterWidget( )\row\leaved And 
               EnterWidget( )\row\leaved\_state & #__s_entered
              EnterWidget( )\row\leaved\_state &~ #__s_entered
              
              If EnterWidget( )\row\leaved\color\state = #__s_1
                EnterWidget( )\row\leaved\color\state = #__s_0
                EnterWidget( )\row\leaved = #Null
                repaint = #True
              EndIf
            EndIf
            
            EnterRow( )\_state | #__s_entered
            
            If _is_current_( EnterWidget( ) )
              ; multi select items
              If mouse( )\buttons And
                 EnterWidget( )\mode\check = #__m_multiselect
                
                ForEach EnterWidget( )\row\draws( ) 
                  If Bool( ( EnterWidget( )\row\selected\index >= EnterWidget( )\row\draws( )\index And EnterRow( )\index <= EnterWidget( )\row\draws( )\index ) Or ; верх
                           ( EnterWidget( )\row\selected\index <= EnterWidget( )\row\draws( )\index And EnterRow( )\index >= EnterWidget( )\row\draws( )\index ) )  ; вниз
                    
                    If EnterWidget( )\row\draws( )\_state & #__s_selected = #False
                      EnterWidget( )\row\draws( )\_state | #__s_selected
                      EnterWidget( )\row\draws( )\color\state = #__s_2
                    EndIf
                    
                  ElseIf EnterWidget( )\row\draws( )\_state & #__s_selected
                    EnterWidget( )\row\draws( )\_state &~ #__s_selected
                    EnterWidget( )\row\draws( )\color\state = #__s_0
                  EndIf
                Next
              EndIf
              
              ; draw item color state entered
              If EnterRow( )\color\state = #__s_0
                EnterRow( )\color\state = #__s_1
                repaint = #True
              EndIf
              
              ; Post event item status change
              Post( #__event_StatusChange, EnterWidget( ), EnterRow( )\index )
            EndIf
          EndIf
          
          LeaveRow( ) = EnterRow( )
        Else
          If Not EnterRow( ) And LeaveRow( ) And 
             Not _is_selected_( EnterWidget( ) )
            
            LeaveRow( ) = #Null
            
            If EnterWidget( )\drop
              repaint = #True
            EndIf
          EndIf
        EndIf  
        
        ; do buttons events entered & leaved 
        If LeaveButton( ) <> EnterButton( ) 
          
          If LeaveButton( ) And
             LeaveButton( )\_state & #__s_entered
            LeaveButton( )\_state &~ #__s_entered
            
            If _is_current_( EnterWidget( ) ) 
              If LeaveButton( )\color\state = #__s_1
                LeaveButton( )\color\state = #__s_0
                
                ; for the splitter thumb
                If LeaveWidget( )\type = #__type_Splitter And 
                   LeaveWidget( )\bar\button[#__b_3] = LeaveButton( ) And 
                   LeaveWidget( )\bar\button[#__b_2]\size <> $ffffff
                  
                  _cursor_remove_( LeaveWidget( ) )
                EndIf
                
                repaint = #True
              EndIf
            EndIf
          EndIf
          
          If EnterButton( ) And 
             EnterButton( )\_state & #__s_entered = #False
            EnterButton( )\_state | #__s_entered
            
            If _is_current_( EnterWidget( ) )
              ; draw item color state entered
              If EnterButton( )\color\state = #__s_0
                If Not ( EnterWidget( )\type = #__type_TrackBar Or 
                         ( EnterWidget( )\type = #__type_Splitter And 
                           EnterWidget( )\bar\button[#__b_3] <> EnterButton( ) ) )
                  
                  EnterButton( )\color\state = #__s_1
                  
                  ; for the splitter thumb
                  If EnterWidget( )\type = #__type_Splitter And 
                     EnterWidget( )\bar\button[#__b_3] = EnterButton( ) And 
                     EnterWidget( )\bar\button[#__b_2]\size <> $ffffff
                    
                    _cursor_set_( EnterWidget( ) )
                  EndIf
                  
                  repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
          
          LeaveButton( ) = EnterButton( )
        EndIf  
        
        
        
        If _is_selected_( *this ) 
          If ListSize( *this\row\draws( ) ) 
            If eventtype = #__event_MouseLeave
            EndIf 
            
            If eventtype = #__event_MouseEnter
            EndIf 
            
            ;             ; scroll to visible item  ok 
            ;             If eventtype = #__event_MouseMove
            ;               If Mouse()\y < *this\y
            ;                 If *this\row\first_visible\index - 1 >= 0 And 
            ;                    _select_prev_item_( *this\row\_s( ), *this\row\first_visible\index )
            ;                   
            ;                   If LeaveRow( ) 
            ;                     LeaveRow( )\_state &~ #__s_entered
            ;                     If LeaveRow( )\color\state = #__s_1
            ;                       LeaveRow( )\color\state = #__s_0
            ;                       repaint = #True
            ;                     EndIf
            ;                   EndIf
            ;                   LeaveRow( ) = *this\row\_s( )
            ;                   LeaveRow( )\_state | #__s_entered
            ;                   If LeaveRow( )\color\state = #__s_0
            ;                     LeaveRow( )\color\state = #__s_1
            ;                     repaint = #True
            ;                   EndIf 
            ;                   
            ;                   If *this\mode\check = #__m_multiselect
            ;                     *this\row\_s( )\color\state = #__s_2
            ;                     *this\row\_s( )\_state | #__s_selected
            ;                   EndIf
            ;                   repaint | _tree_items_scroll_y_( *this\scroll\v, *this\row\_s( )\y, *this\row\_s( )\height )
            ;                 EndIf
            ;                 
            ;               ElseIf Mouse()\y > (*this\y + *this\height)
            ;                 If *this\row\last_visible\index + 1 < *this\count\items And 
            ;                    _select_next_item_( *this\row\_s( ), *this\row\last_visible\index )
            ;                   
            ;                   If LeaveRow( ) 
            ;                     LeaveRow( )\_state &~ #__s_entered
            ;                     If LeaveRow( )\color\state = #__s_1
            ;                       LeaveRow( )\color\state = #__s_0
            ;                       repaint = #True
            ;                     EndIf
            ;                   EndIf
            ;                   LeaveRow( ) = *this\row\_s( )
            ;                   LeaveRow( )\_state | #__s_entered
            ;                   If LeaveRow( )\color\state = #__s_0
            ;                     LeaveRow( )\color\state = #__s_1
            ;                     repaint = #True
            ;                   EndIf 
            ;                   
            ;                   If *this\mode\check = #__m_multiselect
            ;                     *this\row\_s( )\color\state = #__s_2
            ;                     *this\row\_s( )\_state | #__s_selected
            ;                   EndIf
            ;                   repaint | _tree_items_scroll_y_( *this\scroll\v, *this\row\_s( )\y, *this\row\_s( )\height )
            ;                 EndIf
            ;               EndIf
            ;             EndIf
            
          EndIf 
          
        EndIf
        
      EndIf
      
      
      If eventtype = #__event_MouseEnter
        ; entered item draw color state
        If EnterRow( ) And 
           EnterRow( )\_state & #__s_entered And
           EnterRow( )\color\state = #__s_0
          EnterRow( )\color\state = #__s_1
          repaint = #True
        EndIf
        
        ; entered button draw color state
        If EnterButton( ) And 
           EnterButton( )\_state & #__s_entered And
           EnterButton( )\color\state = #__s_0
          EnterButton( )\color\state = #__s_1
          
          ; for the splitter thumb
          If EnterWidget( )\type = #__type_Splitter And 
             EnterWidget( )\bar\button[#__b_3] = EnterButton( ) And 
             EnterWidget( )\bar\button[#__b_2]\size <> $ffffff
            
            _cursor_set_( EnterWidget( ) )
          EndIf
          
          repaint = #True
        EndIf
      EndIf 
      
      If eventtype = #__event_LeftButtonUp
        ;   Debug " up - set color state "
        
        ; for the list items (tree; listview)
        If _is_widget_( FocusWidget( ) )  
          If FocusWidget( )\row\leaved And 
             FocusWidget( )\row\leaved\_state & #__s_entered
            FocusWidget( )\row\leaved\_state &~ #__s_entered
            
            If FocusWidget( )\row\leaved\color\state = #__s_1
              FocusWidget( )\row\leaved\color\state = #__s_0
              FocusWidget( )\row\leaved = #Null
              repaint = #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure DoEvents( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
      Protected Repaint
      
      If Not _is_widget_( *this )
        If Not _is_root_( *this )
          Debug "not event widget - " + *this
        EndIf
        ProcedureReturn 0
      EndIf
      
      ;       If eventtype = #__event_MouseEnter Or 
      ;          eventtype = #__event_LeftButtonDown Or 
      ;          eventtype = #__event_LeftButtonUp Or 
      ;          eventtype = #__event_MouseLeave
      ;         Debug "     "+ eventtype +" "+ *this\class
      ;       EndIf
      
      ;       If eventtype = #__event_Focus Or 
      ;          eventtype = #__event_LostFocus 
      ;         Debug "     "+ eventtype +" "+ *this\class
      ;       EndIf
      
      
      
      ;       If *this\type = #__type_Spin Or
      ;            *this\type = #__type_tabbar Or *this\type = #__type_ToolBar Or
      ;            *this\type = #__type_TrackBar Or
      ;            *this\type = #__type_ScrollBar Or
      ;            *this\type = #__type_ProgressBar Or
      ;            *this\type = #__type_Splitter
      ;         Repaint | Mouse_events( *this, eventtype, mouse_x, mouse_y )
      ;       Else
      Repaint | Mouse_events( *this, eventtype, mouse_x, mouse_y )
      ;       EndIf
      
      ; widget::_events_Anchors( )
      If *this\_a_transform
        Repaint | a_events( *this, eventtype, mouse_x, mouse_y )
        ; ProcedureReturn Repaint
      EndIf    
      
      If *this\_state & #__s_disabled = #False
        ; widget::_events_Window( )
        If *this\type = #__type_window
          Repaint | Window_Events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_Properties( )
        If *this\type = #__type_property
          Repaint | Tree_events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_Tree( )
        If *this\type = #__type_Tree
          Repaint | Tree_events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_ListView( )
        If *this\type = #__type_ListView
          Repaint | ListView_Events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_Editor( )
        If *this\type = #__type_Editor 
          Repaint | Editor_Events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_String( )
        If *this\type = #__type_String
          Repaint | Editor_Events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_CheckBox( )
        If *this\type = #__type_Option Or
           *this\type = #__type_CheckBox
          
          Select eventtype
            Case #__event_LeftButtonDown : Repaint = #True
            Case #__event_LeftButtonUp   : Repaint = #True
            Case #__event_LeftClick
              If *this\type = #__type_CheckBox
                Repaint = SetState( *this, Bool( *this\button\state ! 1 ) )
              Else
                Repaint = SetState( *this, 1 )
              EndIf
              
              If Repaint
                Post( #__event_LeftClick, *this ) 
              EndIf
          EndSelect
        EndIf
        
        ; widget::_events_Button( )
        If *this\type = #__type_Button
          If Not *this\_state & #__s_checked
            Select eventtype
              Case #__event_MouseLeave     : Repaint = #True : *this\color\state = #__s_0 
              Case #__event_LeftButtonDown : Repaint = #True : *this\color\state = #__s_2
              Case #__event_MouseEnter     : Repaint = #True 
                If _is_selected_( *this )
                  *this\color\state = #__s_2
                Else
                  *this\color\state = #__s_1
                EndIf
            EndSelect
          EndIf
          
          If eventtype = #__event_LeftButtonUp 
            Repaint = #True
          EndIf
          
          If eventtype = #__event_LeftClick
            SetState( *this, Bool( Bool( *this\_state & #__s_checked ) ! 1 ) )
            
            Post( #__event_LeftClick, *this ) 
          EndIf
          
          If *this\image[#__img_released]\id Or *this\image[#__img_pressed]\id
            *this\image = *this\image[1 + Bool( *this\color\state = #__s_2 )]
          EndIf
        EndIf
        
        ;- widget::_events_Hyper( )
        If *this\type = #__type_HyperLink
          If Not mouse( )\buttons
            If Atpoint( *this, mouse_x - *this\x, mouse_y - *this\y, [#__c_required] )
              If *this\color\state = #__s_0
                *this\color\state = #__s_1
                _set_cursor_( *this, #PB_Cursor_Hand )
                Repaint = #True
              EndIf
            Else 
              If *this\color\state = #__s_1
                *this\color\state = #__s_0
                _set_cursor_( *this, #PB_Cursor_Default )
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
          If eventtype = #__event_MouseEnter
            _set_cursor_( *this, #PB_Cursor_Default )
          EndIf
          If *this\color\state = #__s_1
            If eventtype = #__event_LeftClick
              Post( #__event_LeftClick, *this )
            EndIf
            If eventtype = #__event_LeftButtonUp
              _set_cursor_( *this, #PB_Cursor_Hand )
              Repaint = #True
            EndIf
            If eventtype = #__event_LeftButtonDown
              *this\color\state = #__s_0 
              _set_cursor_( *this, #PB_Cursor_Default )
              Repaint = 1
            EndIf
          EndIf
          
          
          
          ;         If eventtype <> #__event_MouseLeave And
          ;            Atpoint( *this, mouse_x - *this\x, mouse_y - *this\y, [#__c_required] )
          ;           
          ;           Select eventtype
          ;             Case #__event_LeftClick : Post( eventtype, *this )
          ;             Case #__event_LeftButtonUp   
          ;               _set_cursor_( *this, *this\cursor )
          ;               *this\color\state = #__s_1 
          ;               Repaint = 1
          ;               
          ;             Case #__event_MouseMove 
          ;               If Not _is_selected_( *this )
          ;                 _set_cursor_( *this, *this\cursor )
          ;                 *this\color\state = #__s_1 
          ;                 Repaint = 1
          ;               EndIf
          ;               
          ;             Case #__event_LeftButtonDown 
          ;               _set_cursor_( *this, #PB_Cursor_Default )
          ;               *this\color\state = #__s_0 
          ;               Repaint = 1
          ;               
          ;           EndSelect
          ;         Else
          ;           Debug "897897   "+eventtype
          ;           If Not _is_selected_( *this )  
          ;             _set_cursor_( *this, #PB_Cursor_Default )
          ;             *this\color\state = #__s_0
          ;             Repaint = 1
          ;           EndIf
          ;         EndIf
        EndIf
        
        ;- widget::_events_Bars( )
        If *this\type = #__type_Spin Or
           *this\type = #__type_tabbar Or *this\type = #__type_ToolBar Or
           *this\type = #__type_TrackBar Or
           *this\type = #__type_ScrollBar Or
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_Splitter
          
          Repaint | Bar_Events( *this, eventtype, mouse_x, mouse_y, _wheel_x_, _wheel_y_ )
        EndIf
        
        ; bind event do
        If *this\event And WidgetEvent( ) And 
           WidgetEvent( )\type <> eventtype 
          WidgetEvent( )\type = eventtype
          If *this\count\items
            WidgetEvent( )\item = *this\row\selected
          EndIf
          EventWidget( ) = *this
          
          ;Debug "do event - "+eventtype
          
          ForEach *this\event\bind( )
            If *this\event\bind( )\eventtype = eventtype
              
              ForEach *this\event\bind( )\callback( )
                If *this\event\bind( )\callback( )\func( ) = #PB_Ignore
                  ProcedureReturn #PB_Ignore
                EndIf
              Next
            EndIf
          Next
          
          If EventWidget( ) <> #Null
            EventWidget( ) = #Null
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    ;-
    Procedure EventHandler( )
      Protected *this._s_WIDGET
      Protected Repaint, mouse_x , mouse_y 
      Protected Canvas.i = PB(EventGadget)( )
      Protected eventtype.i = PB(EventType)( )
      Protected Width = PB(GadgetWidth)( Canvas )
      Protected Height = PB(GadgetHeight)( Canvas )
      
      If Root( ) And Root( )\container = Canvas
        *this = Root( )
      Else
        *this = GetGadgetData( Canvas )
      EndIf
      
      If Not *this
        ProcedureReturn 
      EndIf
      
      If Root( ) <> *this\root
        ChangeCurrentElement( Root( ), @*this\root\canvas\address )
      EndIf
      
      Select eventtype
        Case #__event_repaint 
          If EventData( ) <> #PB_Ignore
            
            ;If #debug_repaint
            Debug " - -  Canvas repaint - -  " ; + widget( )\row\count
                                               ;EndIf
            Repaint = 1
          EndIf
          
        Case #__event_Resize : ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          ;If Not _is_root_container_( *this )
          Repaint = Resize( Root( ), #PB_Ignore, #PB_Ignore, width, height )  
          ;EndIf
          
          Repaint = 1
      EndSelect
      
      ; set default value
      If eventtype = #__event_LeftButtonDown
        mouse( )\buttons | #PB_Canvas_LeftButton
        
      ElseIf eventtype = #__event_RightButtonDown
        mouse( )\buttons | #PB_Canvas_RightButton
        
      ElseIf eventtype = #__event_MiddleButtonDown
        mouse( )\buttons | #PB_Canvas_MiddleButton
        
        ; enable mouse behavior
      ElseIf eventtype = #__event_LeftButtonUp Or 
             eventtype = #__event_RightButtonUp Or
             eventtype = #__event_MiddleButtonUp
        mouse( )\interact = 1
        mouse( )\change =- 1
        
        ; x&y mouse
      ElseIf ( eventtype = #__event_MouseMove Or 
               eventtype = #__event_MouseEnter Or 
               eventtype = #__event_MouseLeave )
        mouse_x = GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
        mouse_y = GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
        ;      mouse_x = DesktopMousex( ) - Gadgetx( Canvas, #PB_Gadget_ScreenCoordinate )
        ;      mouse_y = DesktopMouseY( ) - GadgetY( Canvas, #PB_Gadget_ScreenCoordinate )
        
        If mouse( )\x <> mouse_x
          mouse( )\x = mouse_x
          mouse( )\change = #True
        EndIf
        
        If mouse( )\y <> mouse_y
          mouse( )\y = mouse_y
          mouse( )\change = #True
        EndIf
        
        If ( eventtype = #__event_MouseEnter Or 
             eventtype = #__event_MouseLeave ) And 
           mouse( )\change And Not mouse( )\buttons 
          mouse( )\change =- 1
        EndIf
        
      ElseIf eventtype = #__event_MouseWheel
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          Protected app, ev
          app = CocoaMessage(0,0,"NSApplication sharedApplication")
          If app
            ev = CocoaMessage(0,app,"currentEvent")
            If ev
              mouse( )\wheel\x = CocoaMessage(0,ev,"scrollingDeltaX")
            EndIf
          EndIf
        CompilerEndIf
        
        mouse( )\wheel\y = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_WheelDelta )
        
      ElseIf eventtype = #__event_Input 
        keyboard( )\input = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_Input )
        
      ElseIf ( eventtype = #__event_KeyUp Or
               eventtype = #__event_KeyDown )
        keyboard( )\Key = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_Key )
        keyboard( )\key[1] = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_Modifiers )
        
      EndIf
      
      
      ; get enter&leave widget address
      If mouse( )\change
        ; enter&leave mouse events
        If mouse( )\interact
          ; get at point
          If Root( )\count\childrens
            EnterWidget( ) = #Null
            
            LastElement( Widget( ) ) 
            Repeat                                 
              If _is_widget_( Widget( ) ) And
                 Not Widget( )\hide And Widget( )\draw_widget And 
                 Widget( )\root\canvas\gadget = Root( )\canvas\gadget And 
                 Atpoint( Widget( ), mouse( )\x, mouse( )\y, [#__c_frame] ) And 
                 Atpoint( Widget( ), mouse( )\x, mouse( )\y, [#__c_clip] )
                
                EnterWidget( ) = Widget( )
                
                Break
              EndIf
            Until PreviousElement( Widget( ) ) = #False 
          EndIf
          
          If Not EnterWidget( ) 
            EnterWidget( ) = Root( ) 
          EndIf
          
          ; get entered anchor index
          If Not mouse( )\buttons
            If transform( )
              Protected i
              If a_widget( )
                a_index( a_widget( ), Repaint, i )
              EndIf
              If transform( )\widget And transform( )\widget <> a_widget( )
                a_index( transform( )\widget, Repaint, i )
              EndIf
            EndIf
          EndIf
          
          ; 
          If ( transform( ) And transform( )\index And transform( )\index <> #__a_moved )
            ;Debug 9999
            
            ;             If transform( )\widget And
            ;                      Atpoint( transform( )\widget, mouse( )\x, mouse( )\y, [#__c_screen] ) And 
            ;                      Atpoint( transform( )\widget, mouse( )\x, mouse( )\y, [#__c_clip] )
            ;               Else
            ;                  Debug ""+ 77 +" "+ EnterWidget( )\class +" "+ LeaveWidget( )\class +" "+ transform( )\widget\class
            ;                
            ;                 EnterWidget( ) = transform( )\widget
            ;               EndIf
            
            ;              If LeaveWidget( ) <> EnterWidget( )
            ;               If a_widget( ) And
            ;                  Atpoint( a_widget( ), mouse( )\x, mouse( )\y, [#__c_frame] ) And 
            ;                  Atpoint( a_widget( ), mouse( )\x, mouse( )\y, [#__c_clip] )
            ;                 Debug ""+ 66 +" "+ EnterWidget( )\class +" "+ LeaveWidget( )\class +" "+ a_widget( )\class
            ;                 
            ;                 
            ;                 EnterWidget( ) = a_widget( )
            ;               ElseIf transform( )\widget And
            ;                      Atpoint( transform( )\widget, mouse( )\x, mouse( )\y, [#__c_frame] ) And 
            ;                      Atpoint( transform( )\widget, mouse( )\x, mouse( )\y, [#__c_clip] )
            ;                 Debug ""+ 77 +" "+ EnterWidget( )\class +" "+ LeaveWidget( )\class +" "+ transform( )\widget\class
            ;                 
            ;                 EnterWidget( ) = transform( )\widget
            ;               EndIf
            ;               
            ;                 If LeaveWidget( ) And 
            ;                    LeaveWidget( )\_state & #__s_entered 
            ;                   LeaveWidget( )\_state &~ #__s_entered
            ;                  ; repaint = a_hide( LeaveWidget( ) )
            ;                 EndIf
            ;                 
            ;               If EnterWidget( ) And 
            ;                  EnterWidget( )\_state & #__s_entered = #False
            ;                 EnterWidget( )\_state | #__s_entered
            ;                 
            ;                 ;repaint = a_show( EnterWidget( ) )
            ;                 EndIf
            ;               
            ;               LeaveWidget( ) = EnterWidget( )
            ;             EndIf 
            ;             
          Else
            
            ;EndIf : If Not ( transform( ) And transform( )\index And transform( )\index <> #__a_moved )
            
            ; do events entered & leaved 
            If LeaveWidget( ) <> EnterWidget( )
              If LeaveWidget( ) And 
                 LeaveWidget( )\_state & #__s_entered And Not ( #__from_mouse_state And Child( EnterWidget( ), LeaveWidget( ) ) )
                LeaveWidget( )\_state &~ #__s_entered
                
                If _is_current_( LeaveWidget( ) ) 
                  repaint | DoEvents( LeaveWidget( ), #__event_MouseLeave, mouse( )\x, mouse( )\y )
                  
                  If #__from_mouse_state
                    ;ChangeCurrentElement( widget( ), LeaveWidget( )\address )
                    SelectElement( Widget( ), LeaveWidget( )\index )
                    Repeat                 
                      If Widget( )\draw_widget And Child( LeaveWidget( ), Widget( ) )
                        If Widget( )\_state & #__s_entered
                          Widget( )\_state &~ #__s_entered
                          
                          repaint | DoEvents( Widget( ), #__event_MouseLeave, mouse( )\x, mouse( )\y )
                        EndIf
                      EndIf
                    Until PreviousElement( Widget( ) ) = #False 
                  EndIf
                Else
                  If LeaveWidget( )\color\state = #__s_1
                    LeaveWidget( )\color\state = #__s_0
                    repaint = #True
                  EndIf
                EndIf
                
                _DD_event_leave_( repaint, LeaveWidget( ) )
              EndIf
              
              If EnterWidget( ) And 
                 EnterWidget( )\_state & #__s_entered = #False
                EnterWidget( )\_state | #__s_entered
                
                If _is_current_( EnterWidget( ) )
                  If #__from_mouse_state
                    ForEach Widget( )
                      If Widget( ) = EnterWidget( )
                        Break
                      EndIf
                      
                      If Widget( )\draw_widget And Child( EnterWidget( ), Widget( ) )
                        If Widget( )\_state & #__s_entered = #False
                          Widget( )\_state | #__s_entered
                          
                          repaint | DoEvents( Widget( ), #__event_MouseEnter, mouse( )\x, mouse( )\y )
                        EndIf
                      EndIf
                    Next
                  EndIf
                  
                  repaint = a_show( EnterWidget( ) )
                  repaint | DoEvents( EnterWidget( ), #__event_MouseEnter, mouse( )\x, mouse( )\y )
                EndIf
                
                _DD_event_enter_( repaint, EnterWidget( ) )
              EndIf
              
              LeaveWidget( ) = EnterWidget( )
            EndIf  
            
            ; do integral scrollbars events
            If EnterWidget( ) And Not _DD_drag_( )
              If EnterWidget( )\scroll
                If EnterWidget( )\scroll\v And Not EnterWidget( )\scroll\v\hide And EnterWidget( )\scroll\v\type  
                  If Atpoint( EnterWidget( )\scroll\v, mouse( )\x, mouse( )\y, [#__c_frame] ) And
                     Atpoint( EnterWidget( )\scroll\v, mouse( )\x, mouse( )\y, [#__c_clip] ) 
                    
                    If EnterWidget( )\scroll\v\_state & #__s_entered = #False
                      EnterWidget( )\scroll\v\_state | #__s_entered 
                      repaint | DoEvents( EnterWidget( )\scroll\v, #__event_MouseEnter, mouse( )\x, mouse( )\y )
                    EndIf
                    
                    EnterWidget( ) = EnterWidget( )\scroll\v
                  Else
                    If EnterWidget( )\scroll\v And EnterWidget( )\scroll\v\_state & #__s_entered 
                      EnterWidget( )\scroll\v\_state &~ #__s_entered 
                      repaint | DoEvents( EnterWidget( )\scroll\v, #__event_MouseLeave, mouse( )\x, mouse( )\y )
                    EndIf
                  EndIf
                EndIf
                
                If EnterWidget( )\scroll\h And Not EnterWidget( )\scroll\h\hide And EnterWidget( )\scroll\h\type  
                  If Atpoint( EnterWidget( )\scroll\h, mouse( )\x, mouse( )\y, [#__c_frame] ) And
                     Atpoint( EnterWidget( )\scroll\h, mouse( )\x, mouse( )\y, [#__c_clip] ) 
                    
                    If EnterWidget( )\scroll\h\_state & #__s_entered = #False
                      EnterWidget( )\scroll\h\_state | #__s_entered 
                      repaint | DoEvents( EnterWidget( )\scroll\h, #__event_MouseEnter, mouse( )\x, mouse( )\y )
                    EndIf
                    
                    EnterWidget( ) = EnterWidget( )\scroll\h
                  Else
                    If EnterWidget( )\scroll\h And EnterWidget( )\scroll\h\_state & #__s_entered 
                      EnterWidget( )\scroll\h\_state &~ #__s_entered 
                      repaint | DoEvents( EnterWidget( )\scroll\h, #__event_MouseLeave, mouse( )\x, mouse( )\y )
                    EndIf
                  EndIf
                EndIf
              EndIf
              
              ; do integral tabbar events
              If EnterWidget( )\_tab And Not EnterWidget( )\_tab\hide And  EnterWidget( )\_tab\type 
                If Atpoint( EnterWidget( )\_tab, mouse( )\x, mouse( )\y, [#__c_frame] ) And
                   Atpoint( EnterWidget( )\_tab, mouse( )\x, mouse( )\y, [#__c_clip] ) 
                  
                  If EnterWidget( )\_tab\_state & #__s_entered = #False
                    EnterWidget( )\_tab\_state | #__s_entered 
                    repaint | DoEvents( EnterWidget( )\_tab, #__event_MouseEnter, mouse( )\x, mouse( )\y )
                  EndIf
                  
                  EnterWidget( ) = EnterWidget( )\_tab
                Else
                  If EnterWidget( )\_tab And EnterWidget( )\_tab\_state & #__s_entered 
                    EnterWidget( )\_tab\_state &~ #__s_entered 
                    repaint | DoEvents( EnterWidget( )\_tab, #__event_MouseLeave, mouse( )\x, mouse( )\y )
                  EndIf
                EndIf
              EndIf
            EndIf
            
          EndIf
        EndIf
      EndIf
      
      ;
      If eventtype = #__event_LostFocus
        Repaint = SetActive( 0 ) 
        
      ElseIf eventtype = #__event_Focus
        Repaint = SetActive( EnterWidget( ) ) 
        
      ElseIf eventtype = #__event_MouseEnter 
        If EnterWidget( ) And 
           EnterWidget( )\_state & #__s_entered = #False
          EnterWidget( )\_state | #__s_entered
          ; Debug "enter " + EnterWidget( )\class
          
          Repaint | DoEvents( EnterWidget( ), #__event_MouseEnter, mouse( )\x, mouse( )\y )
        EndIf
        
      ElseIf eventtype = #__event_MouseLeave 
        If EnterWidget( ) And 
           EnterWidget( )\_state & #__s_entered
          EnterWidget( )\_state &~ #__s_entered
          ; Debug "leave " + EnterWidget( )\class
          
          Repaint | DoEvents( EnterWidget( ), #__event_MouseLeave, mouse( )\x, mouse( )\y )
        EndIf
        
      ElseIf eventtype = #__event_LeftButtonDown Or
             eventtype = #__event_MiddleButtonDown Or
             eventtype = #__event_RightButtonDown
        
        If EnterWidget( )
          If ( eventtype = #__event_LeftButtonDown Or
               eventtype = #__event_RightButtonDown ) 
            
            FocusWidget( ) = EnterWidget( )
            ;If _is_widget_( EnterWidget( ) ) 
            EnterWidget( )\_state | #__s_selected
            ;EndIf
            EnterWidget( )\time_down = ElapsedMilliseconds( )
            
            ; disabled mouse behavior
            If EnterWidget( )\_a_transform Or EnterButton() > 0
              mouse( )\interact = #False
            EndIf
            
            If Not EnterWidget( )\_a_transform 
              If EnterButton() > 0
                ;; Debug "   bar delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                ; bar mouse delta pos
                ;If EnterButton() = EnterWidget( )\bar\button[#__b_3] ; EnterButton()\index = #__b_3
                mouse( )\delta\x = mouse( )\x - EnterWidget( )\bar\thumb\pos
                mouse( )\delta\y = mouse( )\y - EnterWidget( )\bar\thumb\pos
                ;EndIf
              Else
                ;; Debug "  widget delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                If _is_child_integral_( EnterWidget( ) )
                  mouse( )\delta\x = mouse( )\x - EnterWidget( )\x[#__c_container]
                  mouse( )\delta\y = mouse( )\y - EnterWidget( )\y[#__c_container]
                Else
                  mouse( )\delta\x = mouse( )\x - EnterWidget( )\x[#__c_container] - EnterWidget( )\parent\x[#__c_required]
                  mouse( )\delta\y = mouse( )\y - EnterWidget( )\y[#__c_container] - EnterWidget( )\parent\y[#__c_required]
                EndIf
              EndIf
              
              
              ; set active widget
              If eventtype = #__event_LeftButtonDown
                If GetActiveGadget( ) = EnterWidget( )\root\canvas\gadget
                  Repaint | SetActive( EnterWidget( ) )
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; do events down
          If eventtype = #__event_LeftButtonDown
            Repaint | DoEvents( EnterWidget( ), #__event_LeftButtonDown, mouse( )\x, mouse( )\y )
          ElseIf eventtype = #__event_RightButtonDown
            Repaint | DoEvents( EnterWidget( ), #__event_RightButtonDown, mouse( )\x, mouse( )\y )
          ElseIf eventtype = #__event_MiddleButtonDown
            Repaint | DoEvents( EnterWidget( ), #__event_MiddleButtonDown, mouse( )\x, mouse( )\y )
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_MouseMove 
        If mouse( )\change 
          If mouse( )\buttons
            ; mouse drag start
            _DD_event_drag_( Repaint, FocusWidget( ), mouse( )\x, mouse( )\y )
            
            ; mouse selected widget move event
            Repaint | DoEvents( FocusWidget( ), #__event_MouseMove, mouse( )\x, mouse( )\y )
          Else
            ; mouse enter widget move event
            If EnterWidget( )
              Repaint | DoEvents( EnterWidget( ), #__event_MouseMove, mouse( )\x, mouse( )\y )
            EndIf
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_LeftButtonUp Or 
             eventtype = #__event_MiddleButtonUp Or
             eventtype = #__event_RightButtonUp
        
        ; reset mouse buttons
        If mouse( )\buttons
          If eventtype = #__event_LeftButtonUp
            mouse( )\buttons &~ #PB_Canvas_LeftButton
          ElseIf eventtype = #__event_RightButtonUp
            mouse( )\buttons &~ #PB_Canvas_RightButton
          ElseIf eventtype = #__event_MiddleButtonUp
            mouse( )\buttons &~ #PB_Canvas_MiddleButton
          EndIf
          
          ;
          If Not mouse( )\buttons 
            If _is_widget_( FocusWidget( ) ) And 
               FocusWidget( )\_state & #__s_selected
              FocusWidget( )\_state &~ #__s_selected 
              
              ; up events
              If eventtype = #__event_LeftButtonUp
                Repaint | DoEvents( FocusWidget( ), #__event_LeftButtonUp, mouse( )\x, mouse( )\y )
              ElseIf eventtype = #__event_RightButtonUp
                Repaint | DoEvents( FocusWidget( ), #__event_RightButtonUp, mouse( )\x, mouse( )\y )
              ElseIf eventtype = #__event_MiddleButtonUp
                Repaint | DoEvents( FocusWidget( ), #__event_MiddleButtonUp, mouse( )\x, mouse( )\y )
              EndIf
              
              ; if released the mouse button inside the widget
              If FocusWidget( )\_state & #__s_entered
                If eventtype = #__event_LeftButtonUp
                  Repaint | DoEvents( FocusWidget( ), #__event_LeftClick, mouse( )\x, mouse( )\y )
                EndIf
                If eventtype = #__event_RightButtonUp
                  Repaint | DoEvents( FocusWidget( ), #__event_RightClick, mouse( )\x, mouse( )\y )
                EndIf
                
                If FocusWidget( )\time_click And DoubleClickTime( ) > ElapsedMilliseconds( ) - FocusWidget( )\time_click
                  If eventtype = #__event_LeftButtonUp
                    Repaint | DoEvents( FocusWidget( ), #__event_LeftDoubleClick, mouse( )\x, mouse( )\y )
                  EndIf
                  If eventtype = #__event_RightButtonUp
                    Repaint | DoEvents( FocusWidget( ), #__event_RightDoubleClick, mouse( )\x, mouse( )\y )
                  EndIf
                  
                  FocusWidget( )\time_click = 0
                Else
                  FocusWidget( )\time_click = ElapsedMilliseconds( )
                EndIf
              EndIf
            EndIf
            
            ; enter&drop events
            If EnterWidget( ) 
              If FocusWidget( ) <> EnterWidget( ) 
                Repaint | DoEvents( EnterWidget( ), #__event_MouseEnter, mouse( )\x, mouse( )\y )
              EndIf
              
              ;
              _DD_event_drop_( Repaint, EnterWidget( ), mouse( )\x, mouse( )\y  )
            EndIf
            
            ;
            mouse( )\delta\x = 0
            mouse( )\delta\y = 0
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_Input Or
             eventtype = #__event_KeyDown Or
             eventtype = #__event_KeyUp
        
        ; keyboard events
        If FocusWidget( )
          If eventtype = #__event_KeyDown
            Repaint | DoEvents( FocusWidget( ), #__event_KeyDown, mouse( )\x, mouse( )\y )
          ElseIf eventtype = #__event_KeyUp
            Repaint | DoEvents( FocusWidget( ), #__event_KeyUp, mouse( )\x, mouse( )\y )
          ElseIf eventtype = #__event_Input
            Repaint | DoEvents( FocusWidget( ), #__event_Input, mouse( )\x, mouse( )\y )
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_MouseWheel
        
        If EnterWidget( )
          If mouse( )\wheel\y
            Repaint | DoEvents( EnterWidget( ), #__event_MouseWheelY, mouse( )\x, mouse( )\y )
            mouse( )\wheel\y = 0
            
          ElseIf mouse( )\wheel\x
            Repaint | DoEvents( EnterWidget( ), #__event_MouseWheelX, mouse( )\x, mouse( )\y )
            mouse( )\wheel\x = 0
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_Repaint 
      ElseIf eventtype = #__event_LeftClick 
      ElseIf eventtype = #__event_LeftDoubleClick 
      ElseIf eventtype = #__event_RightClick 
      ElseIf eventtype = #__event_RightDoubleClick 
      ElseIf eventtype = #__event_DragStart 
      ElseIf eventtype = #__event_Focus
        
      ElseIf eventtype = #__event_MouseWheel
      ElseIf eventtype = #__event_Resize 
      Else        
        If eventtype <> #__event_MouseMove
          mouse( )\change = 1
        EndIf
        Debug  #PB_Compiler_Procedure + " - else eventtype - "+eventtype
        
        If EnterWidget( ) And mouse( )\change
          Repaint | DoEvents( EnterWidget( ), eventtype, mouse( )\x, mouse( )\y )
        EndIf
        If FocusWidget( ) And EnterWidget( ) <> FocusWidget( ) And _is_selected_( FocusWidget( ) ) And mouse( )\change 
          Repaint | DoEvents( FocusWidget( ), eventtype, mouse( )\x, mouse( )\y )
        EndIf
      EndIf
      
      ; reset
      ;       If EventWidget( ) <> #Null
      ;         EventWidget( ) = #Null
      ;       EndIf
      If mouse( )\change <> #False
        mouse( )\change = #False
      EndIf
      
      If Repaint 
        ReDraw( Root( ) )
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure EventDeactive( )
      Protected canvas = GetWindowData( EventWindow( ) )
      Protected *this._s_WIDGET = GetGadgetData( Canvas )
      
      If Root( ) <> *this\root
        ChangeCurrentElement( Root( ), @*this\root\canvas\address )
        ; root( ) = *this\root
      EndIf
      
      Debug #PB_Compiler_Procedure + "( )"
      If SetActive( 0 )
        ReDraw( Root( ) )
      EndIf 
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = GetWindowData( EventWindow( ) )
      ; Protected *this._s_WIDGET = GetGadgetData( Canvas )
      ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( ) ) - GadgetX( canvas )*2, WindowHeight( EventWindow( ) ) - GadgetY( canvas )*2 )
    EndProcedure
    
    ;-
    Procedure   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g
      
      If width = #PB_Ignore And
         height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If Not IsWindow( Window ) 
        If Not ListSize( Root( ) )
          w = OpenWindow( Window, x,y,width,height, title$, flag ) : If Window =- 1 : Window = w : EndIf
          x = 0
          y = 0
        Else
          Window = GetWindow( Root( ) )
          If Not ( IsWindow( Window ) And Widget( ) = Root( )\canvas\container )
            Window = OpenWindow( #PB_Any, Widget( )\x,Widget( )\y,Widget( )\width,Widget( )\height, "", #PB_Window_BorderLess )
          EndIf
        EndIf
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth( Window, #PB_Window_InnerCoordinate )
        If x <> #PB_Ignore
          width - x*2
        EndIf
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight( Window, #PB_Window_InnerCoordinate )
        If y <> #PB_Ignore
          height - y*2
        EndIf
      EndIf
      
      AddElement( Root( ) ) 
      Root( ) = AllocateStructure( _s_root )
      Root( )\class = "Root"
      Root( )\root = Root( )
      Root( )\parent = Root( )
      Root( )\window = Root( )
      Root( )\canvas\address = Root( ) ; ! example active( demo ) 
      
      Root( )\text\fontID = PB_( GetGadgetFont )( #PB_Default )
      
      If PB(IsGadget)(Canvas)
        ;g = GadgetID( Canvas )
        Root( )\container = Canvas
      Else
        Root( )\container = #__type_root
        g = CanvasGadget( Canvas, x, y, width, height, Flag | #PB_Canvas_Keyboard ) : If Canvas =- 1 : Canvas = g : EndIf
      EndIf
      
      ; check the elements under the mouse
      mouse( )\interact = #True
      
      Root( )\canvas\window = Window
      Root( )\canvas\gadget = Canvas
      
      If flag & #PB_Window_NoGadgets = #False
        OpenList( Root( ) )
      EndIf
      
      If flag & #PB_Window_NoActivate = #False
        SetActive( Root( ) )
      EndIf 
      
      Resize( Root( ), #PB_Ignore,#PB_Ignore,width,height ) ;??
      
      ; post repaint canvas event
      _post_repaint_( Root( ) ) 
      
      
      If g
        SetGadgetData( Canvas, Root( ) )
        SetWindowData( Window, Canvas )
        
        If flag & #PB_Canvas_Container = #PB_Canvas_Container
          BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window );, Canvas )
        EndIf
        
        BindEvent( #PB_Event_DeactivateWindow, @EventDeactive( ), Window );, Canvas )
        
        ; z - order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( GadgetID( Canvas ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Canvas ), #GWL_STYLE ) | #WS_cLIPSIBLINGS )
          SetWindowPos_( GadgetID( Canvas ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE | #SWP_NOSIZE )
        CompilerEndIf
      EndIf
      
      ProcedureReturn Root( )
    EndProcedure
    
    Procedure.i Window( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, *parent._s_WIDGET = 0 )
      Protected *this.allocate( Widget ) 
      
      With *this
        Static pos_x.l, pos_y.l, parent.i
        If parent <> *parent
          pos_x = 0
          pos_y = 0
          parent = *parent
        EndIf
        
        *this\fs = constants::_check_( flag, #__flag_borderless, #False ) * #__window_frame_size
        *this\child = Bool( Flag & #__window_child = #__window_child )
        
        ; if _is_child_no_integral_( )
        If *parent And 
           *this\child = 0
          *this\child =- 1
          
          x - *parent\x[#__c_container] - *parent\fs - *parent\fs[1]
          y - *parent\y[#__c_container] - *parent\fs - *parent\fs[2]
        EndIf
        
        If x = #PB_Ignore : If transform( ) : x = pos_x + transform( )\grid\size : Else : x = pos_x : EndIf : EndIf : pos_x = x + #__window_frame_size
        If y = #PB_Ignore : If transform( ) : y = pos_y + transform( )\grid\size : Else : y = pos_y : EndIf : EndIf : pos_y = y + #__window_frame_size + #__window_caption_height
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        
        *this\type = #__type_window
        *this\class = #PB_Compiler_Procedure
        *this\container = *this\type
        
        *this\color = _get_colors_( )
        *this\color\back = $FFF9F9F9
        
        ; Background image
        *this\image\img =- 1
        
        *this\caption\round = 4
        *this\caption\_padding = *this\caption\round
        *this\caption\color = _get_colors_( )
        
        ;\caption\hide = constants::_check_( flag, #__flag_borderless )
        *this\caption\hide = constants::_check_( flag, #__Window_titleBar, #False )
        *this\caption\button[#__wb_close]\hide = constants::_check_( flag, #__Window_SystemMenu, #False )
        *this\caption\button[#__wb_maxi]\hide = constants::_check_( flag, #__Window_MaximizeGadget, #False )
        *this\caption\button[#__wb_mini]\hide = constants::_check_( flag, #__Window_MinimizeGadget, #False )
        *this\caption\button[#__wb_help]\hide = 1
        
        *this\caption\button[#__wb_close]\color = colors::*this\red
        *this\caption\button[#__wb_maxi]\color = colors::*this\blue
        *this\caption\button[#__wb_mini]\color = colors::*this\green
        
        *this\caption\button[#__wb_close]\color\state = 1
        *this\caption\button[#__wb_maxi]\color\state = 1
        *this\caption\button[#__wb_mini]\color\state = 1
        
        *this\caption\button[#__wb_close]\round = 4 + 3
        *this\caption\button[#__wb_maxi]\round = *this\caption\button[#__wb_close]\round
        *this\caption\button[#__wb_mini]\round = *this\caption\button[#__wb_close]\round
        *this\caption\button[#__wb_help]\round = *this\caption\button[#__wb_close]\round
        
        *this\caption\button[#__wb_close]\width = 12 + 2
        *this\caption\button[#__wb_close]\height = 12 + 2
        
        *this\caption\button[#__wb_maxi]\width = *this\caption\button[#__wb_close]\width
        *this\caption\button[#__wb_maxi]\height = *this\caption\button[#__wb_close]\height
        
        *this\caption\button[#__wb_mini]\width = *this\caption\button[#__wb_close]\width
        *this\caption\button[#__wb_mini]\height = *this\caption\button[#__wb_close]\height
        
        *this\caption\button[#__wb_help]\width = *this\caption\button[#__wb_close]\width*2
        *this\caption\button[#__wb_help]\height = *this\caption\button[#__wb_close]\height
        
        If *this\caption\button[#__wb_maxi]\hide = 0 Or 
           *this\caption\button[#__wb_mini]\hide = 0
          *this\caption\button[#__wb_close]\hide = 0
        EndIf
        
        If *this\caption\button[#__wb_close]\hide = 0
          *this\caption\hide = 0
        EndIf
        
        If Not \caption\hide 
          *this\BarHeight = constants::_check_( flag, #__flag_borderless, #False ) * ( #__window_caption_height ); + #__window_frame_size )
          *this\round = 7
          
          *this\caption\text\padding\x = 5
          *this\caption\text\string = Text
        EndIf
        
        ; open root list
        If Not ListSize( Root( ) )
          Protected Root = Open( OpenWindow( #PB_Any, x,y,width + *this\fs*2,height + *this\fs*2 + *this\BarHeight, "", #PB_Window_BorderLess, *parent ) )
          Flag | #__flag_autosize
          x = 0
          y = 0
          Root()\width[#__c_inner] = width
          Root()\height[#__c_inner] = height
        EndIf
        
        If *parent
          If Root( ) = *parent 
            Root( )\parent = *this
          EndIf
        Else
          If Root( )\canvas\container > 1
            *parent = Root( )\canvas\container 
          Else
            *parent = Root( )
          EndIf
        EndIf
        
        If Root
          Root( )\canvas\container = *this
        EndIf
        
        _set_align_flag_( *this, *parent, flag )
        SetParent( *this, *parent, #PB_Default )
        
        If flag & #__Window_NoGadgets = #False
          OpenList( *this )
        EndIf
        
        If flag & #__Window_NoActivate = #False And Not *this\_a_transform
          SetActive( *this )
        EndIf 
        
        Resize( *this, x,y,width,height )
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l,height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  Window = -1, *CallBack = #Null )
      Protected *this, g
      
      If  Window = -1
        Window = GetActiveWindow( )
      EndIf
      
      Flag = PBFlag( Type, Flag ) | #__flag_autosize
      
      Open( Window, x,y,width,height, "", #Null, *CallBack, Gadget )
      
      Select Type
        Case #__type_Tree      : *this = Tree( 0, 0, width, height, flag )
        Case #__type_Text      : *this = Text( 0, 0, width, height, Text, flag )
        Case #__type_Button    : *this = Button( 0, 0, width, height, Text, flag )
        Case #__type_Option    : *this = Option( 0, 0, width, height, Text, flag )
        Case #__type_CheckBox  : *this = Checkbox( 0, 0, width, height, Text, flag )
        Case #__type_HyperLink : *this = HyperLink( 0, 0, width, height, Text, *param1, flag )
        Case #__type_Splitter  : *this = Splitter( 0, 0, width, height, *param1, *param2, flag )
      EndSelect
      
      If Gadget =- 1
        Gadget = GetGadget( Root( ) )
        g = Gadget
      Else
        g = GadgetID( Gadget )
      EndIf
      SetGadgetData( Gadget, *this )
      
      EnterWidget( ) = *this
      
      ProcedureReturn g
    EndProcedure
    
    Procedure.i Free( *this._s_WIDGET )
      Protected result.i
      
      With *this
        If *this
          If \scroll
            If \scroll\v : FreeStructure( \scroll\v ) : \scroll\v = 0 : EndIf
            If \scroll\h : FreeStructure( \scroll\h )  : \scroll\h = 0 : EndIf
            ; *this\scroll = 0
          EndIf
          
          If \type = #__type_Splitter
            If \gadget[#__split_1] : FreeStructure( \gadget[#__split_1] ) : \gadget[#__split_1] = 0 : EndIf
            If \gadget[#__split_2] : FreeStructure( \gadget[#__split_2] ) : \gadget[#__split_2] = 0 : EndIf
          EndIf
          
          If \_tab
          EndIf
          
          If *this\parent 
            If *this\parent\scroll\v = *this
              FreeStructure( *this\parent\scroll\v ) : *this\parent\scroll\v = 0
            EndIf
            If *this\parent\scroll\h = *this
              FreeStructure( *this\parent\scroll\h )  : *this\parent\scroll\h = 0
            EndIf
            
            If *this\parent\type = #__type_Splitter
              If *this\parent\gadget[#__split_1] = *this
                FreeStructure( *this\parent\gadget[#__split_1] ) : *this\parent\gadget[#__split_1] = 0
              EndIf
              If *this\parent\gadget[#__split_2] = *this
                FreeStructure( *this\parent\gadget[#__split_2] )  : *this\parent\gadget[#__split_2] = 0
              EndIf
            EndIf
          EndIf
          
          
          Debug  " free - " + ListSize( Widget( ) )  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          If *this\parent And
             *this\parent\count\childrens 
            
            _position_move_( *this )
            
            ;*this\address = 0
            
            LastElement( Widget( ) )
            Repeat
              If Widget( ) = *this Or Child( Widget( ), *this )
                
                If Widget( )\root\count\childrens > 0 
                  Widget( )\root\count\childrens - 1
                  If Widget( )\parent <> Widget( )\root
                    Widget( )\parent\count\childrens - 1
                  EndIf
                  If this( )\sticky\window = Widget( )
                    this( )\sticky\window = #Null
                  EndIf
                  DeleteElement( Widget( ), 1 )
                EndIf
                
                If Not *this\root\count\childrens
                  Break
                EndIf
              ElseIf PreviousElement( Widget( ) ) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  "   free - " + ListSize( Widget( ) )  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          
          
          If EnterWidget( ) = *this
            EnterWidget( ) = *this\parent
          EndIf
          If FocusWidget( ) = *this
            FocusWidget( ) = *this\parent
          EndIf
          
          ; *this = 0
          ;ClearStructure( *this, _s_WIDGET )
        EndIf
      EndWith
      
      
      ;       Debug " free - "
      ;       ForEach widget( ) 
      ;         If widget( )\before And widget( )\after
      ;           Debug " free - "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ;         ElseIf widget( )\after
      ;           Debug " free - none "+ widget( )\class +" "+ widget( )\after\class
      ;         ElseIf widget( )\before
      ;           Debug " free - "+ widget( )\before\class +" "+ widget( )\class +" none"
      ;         Else
      ;           Debug " free - "+ widget( )\class 
      ;         EndIf
      ;       Next
      ;       Debug ""
      
      ProcedureReturn result
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf


;- 
Macro Uselib( _name_ )
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro


CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseLib(Widget)
  
  UsePNGImageDecoder()
  
  Global img = 2
  ;   CatchImage(0, ?Logo);?maximize, 204)
  ; ;   DataSection
  ; ;       maximize:
  ; ;       Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  ; ;       Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$93,$49,$44,$41
  ; ;       Data.b $54,$78,$DA,$CD,$D2,$B1,$0E,$82,$40,$10,$84,$61,$59,$A0,$80,$82,$80,$86,$D8,$28
  ; ;       Data.b $14,$14,$24,$14,$60,$7C,$FF,$52,$E3,$23,$F8,$38,$E7,$5F,$6C,$61,$36,$7B,$39,$13
  ; ;       Data.b $1B,$36,$F9,$AA,$99,$0C,$14,$77,$D8,$E5,$65,$90,$04,$3A,$FE,$BD,$11,$12,$9E,$A8
  ; ;       Data.b $91,$7B,$5F,$0E,$3F,$BA,$A0,$B6,$03,$A2,$E1,$82,$1B,$36,$AC,$C6,$5D,$3B,$33,$DA
  ; ;       Data.b $D8,$C0,$84,$11,$3D,$8E,$46,$FF,$D5,$E9,$62,$03,$23,$4E,$28,$21,$46,$09,$ED,$C4
  ; ;       Data.b $FF,$60,$D0,$50,$10,$ED,$EC,$7F,$A0,$43,$01,$31,$8A,$D4,$C0,$03,$21,$E1,$85,$2B
  ; ;       Data.b $1A,$EF,$21,$55,$38,$6B,$61,$F0,$68,$46,$87,$AE,$73,$B9,$06,$0D,$5A,$8F,$66,$95
  ; ;       Data.b $76,$FF,$BF,$0F,$21,$2E,$31,$D6,$FF,$2F,$53,$8C,$00,$00,$00,$00,$49,$45,$4E,$44
  ; ;       Data.b $AE,$42,$60,$82
  ; ;       maximizeend:
  ; ;     EndDataSection
  ;     
  ;     DataSection
  ;     Logo: 
  ;       IncludeBinary #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png";"Logo.bmp"
  ;   EndDataSection
  
  If Not LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i,NewMap Widgets.i()
  
  Procedure scrolled( )
    ; If EventGadget() = #__type_ScrollBar
    SetState( Widgets(Hex(#__type_ProgressBar)), GetState( Widgets(Hex(#__type_ScrollBar))))
    ; EndIf 
  EndProcedure
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open( GetActiveWindow( ) )
    a_init(root())
    ;
    ;Widgets("Container") = Container(0, 0, 995, 455);, #__flag_AutoSize) 
    
    Widgets(Hex(#__type_Button)) = Button(5, 5, 160,95, "Multiline Button_"+Hex(#__type_Button)+" (longer text gets automatically multiline)", #__button_multiLine ) 
    Widgets(Hex(#__type_String)) = String(5, 105, 160,95, "String_"+Hex(#__type_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    Widgets(Hex(#__type_Text)) = Text(5, 205, 160,95, "Text_"+Hex(#__type_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #__text_border)        
    Widgets(Hex(#__type_CheckBox)) = Checkbox(5, 305, 160,95, "CheckBox_"+Hex(#__type_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Hex(#__type_CheckBox)), #PB_Checkbox_Inbetween)
    Widgets(Hex(#__type_Option)) = Option(5, 405, 160,95, "Option_"+Hex(#__type_Option) ) : SetState(Widgets(Hex(#__type_Option)), 1)                                                       
    Widgets(Hex(#__type_ListView)) = ListView(5, 505, 160,95) : AddItem(Widgets(Hex(#__type_ListView)), -1, "ListView_"+Hex(#__type_ListView)) : For i=1 To 5 : AddItem(Widgets(Hex(#__type_ListView)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#__type_Frame)) = Frame(170, 5, 160,95, "Frame_"+Hex(#__type_Frame) )
    ;Widgets(Hex(#__type_ComboBox)) = ComboBox(170, 105, 160,95) : AddItem(Widgets(Hex(#__type_ComboBox)), -1, "ComboBox_"+Hex(#__type_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Hex(#__type_ComboBox)), i, "item_"+Hex(i)) : Next : SetState(Widgets(Hex(#__type_ComboBox)), 0) 
    Widgets(Hex(#__type_Image)) = Image(170, 205, 160,95, img, #PB_Image_Border ) 
    Widgets(Hex(#__type_HyperLink)) = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#__type_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    Widgets(Hex(#__type_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
    Widgets(Hex(101)) = Option(10, 10, 110,20, "Container_"+Hex(#__type_Container) )  : SetState(Widgets(Hex(101)), 1)  
    Widgets(Hex(102)) = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
    CloseList()
    ;Widgets(Hex(#__type_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#__type_ListIcon),120 )                           
    
    ;Widgets(Hex(#__type_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(Widgets(Hex(#__type_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
    Widgets(Hex(#__type_ProgressBar)) = Progress(335, 105, 160,95,0,100, 0, 50) : SetState(Widgets(Hex(#__type_ProgressBar)), 50)
    Widgets(Hex(#__type_ScrollBar)) = Scroll(335, 205, 160,95,0,120,20) : SetState(Widgets(Hex(#__type_ScrollBar)), 50)
    Widgets(Hex(#__type_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = Button(0, 0, 150,20, "ScrollArea_"+Hex(#__type_ScrollArea) ) : Widgets(Hex(202)) = Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
    Widgets(Hex(#__type_TrackBar)) = Track(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetState(Widgets(Hex(#__type_TrackBar)), 11)
    ;     WebGadget(#__type_Web, 335, 505, 160,95,"" )
    
    Widgets(Hex(#__type_ButtonImage)) = ButtonImage(500, 5, 160,95, 1)
    ;     CalendarGadget(#__type_Calendar, 500, 105, 160,95 )
    ;     DateGadget(#__type_Date, 500, 205, 160,95 )
    Widgets(Hex(#__type_Editor)) = Editor(500, 305, 160,95 ) : AddItem(Widgets(Hex(#__type_Editor)), -1, "set"+#LF$+"editor"+#LF$+"_"+Hex(#__type_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ;     Widgets(Hex(#__type_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
    ;     ExplorerTreeGadget(#__type_ExplorerTree, 500, 505, 160,95,"" )
    ;     
    ;     ExplorerComboGadget(#__type_ExplorerCombo, 665, 5, 160,95,"" )
    Widgets(Hex(#__type_Spin)) = Spin(665, 105, 160,95,20,100)
    
    Widgets(Hex(#__type_Tree)) = Tree( 665, 205, 160, 95 ) 
    AddItem(Widgets(Hex(#__type_Tree)), -1, "Tree_"+Hex(#__type_Tree)) 
    For i=1 To 5 : AddItem(Widgets(Hex(#__type_Tree)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#__type_Panel)) = Panel(665, 305, 160,95) 
    AddItem(Widgets(Hex(#__type_Panel)), -1, "Panel_"+Hex(#__type_Panel)) 
    Widgets(Hex(255)) = Button(0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddItem(Widgets(Hex(#__type_Panel)), i, "item_"+Hex(i)) : Button(i*5,5,50,35, "butt_"+Str(i)) : Next 
    CloseList()
    
    OpenList(Widgets(Hex(#__type_Panel)), 4)
    Container(10,15,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,35,50,35, "butt_0") 
    CloseList()
    CloseList()
    CloseList()
    
    SetState( Widgets(Hex(#__type_Panel)), 2)
    
    Widgets(Hex(301)) = Spin(0, 0, 100,20,0,10, #__bar_Vertical)
    Widgets(Hex(302)) = Spin(0, 0, 100,20,0,10)                 
    Widgets(Hex(#__type_Splitter)) = Splitter(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)))
    
    Widgets(Hex(#__type_MDI)) = MDI(665, 505, 160,95); ,#__flag_AutoSize)
    Define *g = AddItem(Widgets(Hex(#__type_MDI)), -1, "form_0")
    Resize(*g, 7, 40, 120, 60)
    
    ;     CloseList()
    ; ;     OpenList(Root())
    ;      Button(10,5,50,35, "butt_1") 
    
    ;     CompilerEndIf
    ;     InitScintilla()
    ;     ScintillaGadget(#__type_Scintilla, 830, 5, 160,95,0 )
    ;     ShortcutGadget(#__type_Shortcut, 830, 105, 160,95 ,-1)
    ;     CanvasGadget(#__type_Canvas, 830, 205, 160,95 )
    
    CloseList( )
    Bind(Widgets(Hex(#__type_ScrollBar)), @scrolled() )
    
    
    ReDraw( Root( ) )
    Bind( Root( ), #PB_Default )
    
    Repeat
      Define  Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = +----------------------------------9----------0-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------8--------
; EnableXP