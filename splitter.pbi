﻿
#path = ""

IncludePath #path

CompilerIf Not Defined( constants, #PB_Module )
  XIncludeFile "include/constants.pbi"
CompilerEndIf

CompilerIf Not Defined( structures, #PB_Module )
  XIncludeFile "include/structures.pbi"
CompilerEndIf

CompilerIf Not Defined( func, #PB_Module )
  XIncludeFile "include/func.pbi"
CompilerEndIf

CompilerIf Not Defined( colors, #PB_Module )
  XIncludeFile "include/colors.pbi"
CompilerEndIf

; fix all pb bug's
CompilerIf Not Defined( fix, #PB_Module )
  XIncludeFile "include/fix.pbi"
CompilerEndIf


;-  >>>
CompilerIf Not Defined( Widget, #PB_Module )
  DeclareModule Widget
    Global DrawingDC = 0
    
    EnableExplicit
    UseModule constants
    UseModule structures
    UseModule events
    
    ;-  -----------------
    ;-   DECLARE_globals
    ;-  -----------------
    Global _macro_call_count_
    Global __gui._s_STRUCT
    
    ;-  ----------------
    ;-   DECLARE_macros
    ;-  ----------------
    Macro allocate( _struct_name_, _struct_type_ = )
      _s_#_struct_name_#_struct_type_ = AllocateStructure( _s_#_struct_name_ )
    EndMacro
    
    Macro MouseEnter( _this_, _mode_=2 )
      _this_\enter = _mode_
    EndMacro
    
    Macro AlphaState( ) 
      color\_alpha ; << 24
    EndMacro
    
    Macro AlphaState24( ) 
      color\_alpha << 24
    EndMacro
    
    Macro ColorAlphaState( ) 
      color\_alpha
    EndMacro
    
    Macro ColorAlphaColor( ) 
      color\alpha
    EndMacro
    
    Macro AlphaColor( ) 
      color\alpha ; << 24
    EndMacro
    
    Macro AlphaColor24( ) 
      color\alpha << 24
    EndMacro
    
    Macro ToolBar( _parent_, _flags_ = 0 )
      CreateBar( #__type_ToolBarBar, _parent_, _flags_ )
    EndMacro
    Macro ToolBarButton( _button_, _image_, _mode_ = 0, _text_ = #Null$ )
      BarButton( _button_, _image_, _mode_, _text_ )
    EndMacro
    Macro Separator( )
      BarSeparator( )
    EndMacro
    Macro ScrollToActive( _state_ )
      focus =- _state_
    EndMacro
    Macro is_drag_move( )
      a_index( ) = #__a_moved
    EndMacro
    
    
    
    
    
    ;- \\
    ;     Macro item_index( )
    ;       _index
    ;     EndMacro
    ;     Macro __tabs: tab\_s: EndMacro
    ;     Macro __lines( ): lines( ) : EndMacro    ; row\lines( )
    ;     Macro __lines_index( )
    ;       __lines( )\item_index( )
    ;     EndMacro
    ;     
    ;     Macro __items( ): columns( )\items( ) : EndMacro    ; row\items( )
    ;     Macro __items_index( )
    ;       __items( )\item_index( )
    ;     EndMacro
    
    ;-
    Macro root( ): widget::__gui\root: EndMacro
    Macro roots( ): widget::__gui\_roots( ): EndMacro
    Macro widget( ): widget::__gui\widget: EndMacro ; Returns current-root last added widget
    Macro widgets( ): __gui\_widgets( ): EndMacro
    
    
    ;-\\
    ; Macro Firstroot( ): first\root: EndMacro
    Macro Lastroot( ): last\root: EndMacro
    Macro Afterroot( ): after\root: EndMacro
    Macro Beforeroot( ): before\root: EndMacro
    
    ;-
    Macro Mouse( ): widget::__gui\mouse: EndMacro
    Macro Keyboard( ): widget::__gui\keyboard: EndMacro
    
    ;-
    Macro TabChange( ): change: EndMacro         ; tab\widget\change
    Macro TextChange( ): change: EndMacro        ; temp
    Macro ImageChange( ): change: EndMacro       ; temp
    Macro AreaChange( ): area\change: EndMacro   ; temp
    Macro PageChange( ): page\change: EndMacro   ; temp
    Macro ThumbChange( ): thumb\change: EndMacro ; temp
    Macro BarChange( ): bar\change: EndMacro     ; temp
    Macro ResizeChange( ): change: EndMacro      ; temp
    Macro WidgetChange( ): change: EndMacro      ; temp
    
    ;-
    Macro split_1( ) : gadget[1] : EndMacro ; temp
    Macro split_2( ) : gadget[2] : EndMacro ; temp
                                            ;       Macro split_1( ) : bar\button[1]\gadget : EndMacro ; temp
                                            ;       Macro split_2( ) : bar\button[2]\gadget : EndMacro ; temp
    
    ;-
    ; Macro Popup( ): widget::__gui\sticky\box: EndMacro
    Macro Opened( ): widget::__gui\opened: EndMacro ; object list opened container
    Macro PopupWindow( ): widget::__gui\sticky\window: EndMacro
    Macro ParentMenu( ): root\menu: EndMacro   ; *this\
    Macro PopupBar( ): popupBar: EndMacro      ; *this\
    Macro ComboPopupBar( ): comboBar: EndMacro ; *this\ 
    
    ;-
    Macro ColorState( ): color\state: EndMacro
    Macro ScrollState( ): scroll\state: EndMacro
    Macro ToggleBoxState( ): ToggleBox( )\state: EndMacro
    
    ;-
    Macro ToggleBox( ): box: EndMacro ;  
    Macro ComboButton( ): combobox: EndMacro
    
    ;-
    Macro StringBox( ): string: EndMacro
    Macro OptionBox( ): option_group_parent: EndMacro
    Macro RowOptionBox( ): _option_group_parent: EndMacro
    
    ;-
    Macro TabBox( ): tab\widget: EndMacro
    Macro TabEntered( ): tab\entered: EndMacro   ; Returns mouse entered tab
    Macro TabPressed( ): tab\pressed: EndMacro   ; Returns mouse focused tab
    Macro TabFocused( ): tab\focused: EndMacro   ; Returns mouse focused tab
                                                 ;
    Macro TabIndex( ): tab\index: EndMacro
    Macro TabState( ): tab\state: EndMacro      
    Macro TabAddIndex( ): tab\addindex: EndMacro 
    
    ;-
    Macro MarginLine( ): row\margin: EndMacro ; temp
                                              ;                                               ;
                                              ;     Macro LineEntered( ): row\entered: EndMacro ; Returns mouse entered widget
                                              ;     Macro LinePressed( ): row\pressed: EndMacro ; Returns key focus item address
                                              ;     Macro LineFocused( ): row\focused: EndMacro ; Returns key focus item address
                                              ;                                                 ;
                                              ;     Macro LineEnteredIndex( ): row\id[1]: EndMacro ; *this\ Returns mouse entered line index ; 31 count
                                              ;     Macro LineFocusedIndex( ): row\id[2]: EndMacro ; *this\ Returns key focused line index   ; 11 count
                                              ;     Macro LinePressedIndex( ): row\id[3]: EndMacro ; *this\ Returns mouse pressed line index ; 23 count
                                              ;     Macro RowFocusedIndex( ): row\id[0]: EndMacro
                                              ;     
                                              ;-
                                              ;     Macro RowBox( ): checkbox: EndMacro
                                              ;     Macro RowButton( ): buttonbox: EndMacro
                                              ;     
                                              ;     Macro RowBoxState( ): RowBox( )\state: EndMacro
                                              ;     Macro RowButtonState( ): RowButton( )\state: EndMacro
                                              ;     
                                              ;     Macro RowParent( ): _parent: EndMacro ; _s_ROWS( )
                                              ;     Macro RowLeaved( ): row\leaved: EndMacro   ; Returns mouse entered item address
                                              ;     Macro RowEntered( ): row\entered: EndMacro ; Returns mouse entered item address
                                              ;     Macro RowPressed( ): row\pressed: EndMacro ; Returns mouse press item address
                                              ;     Macro RowFocused( ): row\focused: EndMacro ; Returns key focus item address
                                              ;     Macro RowToolTip( ): row\tt: EndMacro
                                              ;     
                                              ;     Macro RowFirst( ): row\first: EndMacro
                                              ;     Macro RowLast( ): row\last: EndMacro
                                              ;     Macro RowLastAdd( ): row\added: EndMacro
                                              ;     
                                              ;     Macro RowVisibleList( ): row\visible\_s( ): EndMacro
                                              ;     Macro RowFirstVisible( ): row\visible\first: EndMacro
                                              ;     Macro RowLastVisible( ): row\visible\last: EndMacro
    
    ;-
    Macro EnteredButton( ): mouse( )\entered\button: EndMacro
    Macro PressedButton( ): mouse( )\pressed\button: EndMacro
    
    ;-
    Macro FirstWidget( ): first\widget: EndMacro
    Macro LastWidget( ): last\widget: EndMacro
    Macro AfterWidget( ): after\widget: EndMacro
    Macro BeforeWidget( ): before\widget: EndMacro
    
    ;-
    Macro LeavedWidget( ): mouse( )\widget[1]: EndMacro ; Returns mouse entered widget
    Macro EnteredWidget( ): mouse( )\widget: EndMacro   ; Returns mouse entered widget
    Macro PressedWidget( ): mouse( )\pressed\widget: EndMacro ; Returns mouse button pushed widget
    
    ;-
    Macro GetActive( ): Keyboard( )\widget: EndMacro        ; Returns activeed object
    Macro ActiveWindow( ): Keyboard( )\window: EndMacro     ; Returns activeed window
    Macro ActiveGadget( ): ActiveWindow( )\gadget: EndMacro ; Returns activeed gadget
    
    ;-
    Macro DesktopScaled( _value_ ): DesktopScaledX( _value_ ): EndMacro
    Macro DesktopUnScaled( _value_ ): DesktopUnscaledX( _value_ ): EndMacro
    ;Macro DesktopResolution( ): DesktopResolutionX( ): EndMacro
    
    ;-
    Macro MouseButtons( ): mouse( )\buttons: EndMacro
    Macro GetMouseX( _this_ = #Null, _mode_ = #__c_screen ): DesktopUnscaledX( mouse( )\x ): EndMacro ; Returns mouse x
    Macro GetMouseY( _this_ = #Null, _mode_ = #__c_screen ): DesktopUnscaledY( mouse( )\y ): EndMacro ; Returns mouse y
                                                                                                  ;-
    Macro Cursor( _this_ )
      _this_\cursor[3]
    EndMacro
    Macro CurrentCursor( )
      mouse( )\cursor
    EndMacro
    
    ;-
    Macro ChangeCurrentCanvas( _canvasID_ )
      FindMapElement( widget::roots( ), Str( _canvasID_ ) )
      widget::root( ) = widget::roots( )
      ;Debug ""+ #PB_Compiler_Procedure + " ChangeCurrentCanvas "+widget::root( )\class
    EndMacro
    Macro OpenCanvas( _canvas_ = #PB_Any )
      Open( ID::Window(UseGadgetList(0)), 0,0,0,0, "", #PB_Canvas_Container, 0, _canvas_ )
    EndMacro
    Macro CloseCanvas( )
      CloseGadgetList( )
    EndMacro
    Macro CanvasMouseX( _canvas_ )
      ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      ;WindowMouseX( ID::Window(ID::GetWindowID(GadgetID(_canvas_))) ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )
      DesktopMouseX( ) - DesktopScaledX(GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate ))
    EndMacro
    Macro CanvasMouseY( _canvas_ )
      ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      ;WindowMouseY(  ID::Window(ID::GetWindowID(GadgetID(_canvas_)))  ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
      DesktopMouseY( ) - DesktopScaledY(GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate ))
    EndMacro
    
    
    ;-
    ;Macro EventIndex( ): EventWidget( )\index: EndMacro
    Macro EventWidget( ): widget::__gui\event\widget: EndMacro
    Macro WidgetEvent( ): widget::__gui\event\type: EndMacro
    Macro WidgetEventData( ): widget::__gui\event\data: EndMacro
    Macro WidgetEventItem( ): widget::__gui\event\item: EndMacro
    ;
    Macro WaitEvent( _callback_, _eventtype_ = #PB_All )
      widget::Bind( #PB_All, _callback_, _eventtype_ )
      widget::WaitClose( )
    EndMacro
    
    ;       Macro BindEvents(_callback_, _this_=#PB_Any, _item_=#PB_All, _event_=0 ) 
    ;          Bind( _this_, _callback_, _event_, _item_ )
    ;       EndMacro
    
    ;-
    Global *before_start_enumerate_widget._s_WIDGET
    Macro StartEnumerate( _parent_, _item_ = #PB_All )
      Bool( _parent_\haschildren And _parent_\FirstWidget( ) )
      *before_start_enumerate_widget = widget( )
      PushListPosition( widgets( ) )
      ;
      If _parent_\FirstWidget( )\address
        ChangeCurrentElement( widgets( ), _parent_\FirstWidget( )\address )
      Else
        ResetList( widgets( ) )
      EndIf
      widget( ) = widgets( )
      ;
      ;\\
      If _item_ > 0
        Repeat
          If widgets( ) = _parent_\AfterWidget( ) 
            Break
          EndIf
          If widgets( )\root <> _parent_\root
            Break    
          EndIf
          If  widgets( )\level < _parent_\level
            Break
          EndIf
          If widgets( )\parent = _parent_  
            If widgets( )\TabIndex( ) = _item_
              Break
            EndIf
          EndIf
        Until Not NextElement( widgets( ) ) 
      EndIf
      ;
      ;\\
      If widgets( )\parent = _parent_
        Repeat
          If widgets( ) = _parent_\AfterWidget( ) 
            Break
          EndIf
          If widgets( )\root <> _parent_\root
            Break    
          EndIf
          If  widgets( )\level < _parent_\level
            Break
          EndIf
          If _item_ >= 0  
            If widgets( )\parent = _parent_  
              If _item_ <> widgets( )\TabIndex( )
                Break
              EndIf
            EndIf
          EndIf
          ;
          widget( ) = widgets( )
        EndMacro
        ;             ;
        ;             Macro AbortEnumerate( )
        ;                Break
        ;             EndMacro
        ;             ;
        Macro StopEnumerate( )
        Until Not NextElement( widgets( ) )
      EndIf
      PopListPosition( widgets( ) )
      widget( ) = *before_start_enumerate_widget
    EndMacro
    
    ;-
    Macro StartDrawingroot( _root_ )
      Bool(widget::__gui\drawingroot <> _root_)
      ;
      widget::StopDrawingroot( )
      If Not _root_\drawmode 
        _root_\drawmode | 1<<2
      EndIf
      If _root_\drawmode & 1<<1 = 1<<1
        widget::DrawingDC = StartVectorDrawing( CanvasVectorOutput( _root_\canvas\gadget ))
      EndIf
      If _root_\drawmode & 1<<2 = 1<<2
        widget::DrawingDC = StartDrawing( CanvasOutput( _root_\canvas\gadget ))
      EndIf
      widget::__gui\drawingroot = _root_
    EndMacro
    Macro StopDrawingroot( )
      If widget::__gui\drawingroot 
        ;Debug "StopDrawingroot "+widget::__gui\drawingroot\class
        If widget::__gui\drawingroot\drawmode & 1<<2 = 1<<2
          StopDrawing( )
        EndIf
        If widget::__gui\drawingroot\drawmode & 1<<1 = 1<<1
          StopVectorDrawing( )  
        EndIf
        widget::__gui\drawingroot = #Null
      EndIf
    EndMacro
    Macro DrawingFont_( _this_ )
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
        If StartDrawingroot( _this_\root ) : Debug "  ---- root ReDrawing ----  " 
          If CurrentFontID( )
            DrawingFont(CurrentFontID( ))
          EndIf
        EndIf
      CompilerEndIf
    EndMacro
    Macro Repaint( _root_ )
      If Not widget::__gui\drawingroot
        widget::StartDrawingroot( _root_ )
      EndIf
      widget::ReDraw( _root_ )
      widget::StopDrawingroot( )
    EndMacro
    
    ;-
    Macro PostEventRepaint( _root_ )
      If _root_
        ; Debug #PB_Compiler_Procedure
        If widget::__gui\eventloop
          If Not widget::Send( _root_, constants::#__event_Repaint )
            ; Debug "PostEventRepaint - ReDraw"
            widget::Repaint( _root_ )
          EndIf
        Else
          If _root_\canvas\post = 0
            _root_\canvas\post = 1
            If Not widget::Send( _root_, constants::#__event_Repaint )
              PostEvent( #PB_Event_Repaint, _root_\canvas\window, #PB_All, #PB_All, _root_\canvas\gadgetID )
            EndIf
          EndIf
        EndIf
      EndIf
    EndMacro
    Macro PostRepaint( _root_ )
      ;Debug #PB_Compiler_Procedure
      PostEventRepaint( _root_ )
    EndMacro
    
    ;-
    Macro MidF(_string_, _start_pos_, _length_ = -1)
      func::MidFast(_string_, _start_pos_, _length_)
    EndMacro
    
    Macro ICase( String ) ; sTRinG = StrINg
      func::InvertCase( String )
    EndMacro
    
    Macro ULCase( String ) ; sTRinG = String
      InsertString( UCase( Left( String, 1 )), LCase( Right( String, Len( String ) - 1 )), 2 )
    EndMacro
    
    
    ;-
    Macro TitleText( ): text: EndMacro
    Macro GetTitle( window ): widget::GetText( window ): EndMacro
    Macro CloseButton( ): caption\button[#__wb_close]: EndMacro
    Macro MaximizeButton( ): caption\button[#__wb_maxi]: EndMacro
    Macro MinimizeButton( ): caption\button[#__wb_mini]: EndMacro
    Macro HelpButton( ): caption\button[#__wb_help]: EndMacro
    
    ;-
    Macro draw_x( ): x[#__c_draw]: EndMacro
    Macro draw_y( ): y[#__c_draw]: EndMacro
    Macro draw_width( ): width[#__c_draw]: EndMacro
    Macro draw_height( ): height[#__c_draw]: EndMacro
    
    ;-
    Macro screen_x( ): x[#__c_screen]: EndMacro
    Macro screen_y( ): y[#__c_screen]: EndMacro
    Macro screen_width( ): width[#__c_screen]: EndMacro
    Macro screen_height( ): height[#__c_screen]: EndMacro
    
    ;-
    Macro inner_x( ): x[#__c_inner]: EndMacro
    Macro inner_y( ): y[#__c_inner]: EndMacro
    Macro inner_width( ): width[#__c_inner]: EndMacro
    Macro inner_height( ): height[#__c_inner]: EndMacro
    
    ;-
    Macro frame_x( ): x[#__c_frame]: EndMacro
    Macro frame_y( ): y[#__c_frame]: EndMacro
    Macro frame_width( ): width[#__c_frame]: EndMacro
    Macro frame_height( ): height[#__c_frame]: EndMacro
    
    ;-
    Macro container_x( ): x[#__c_container]: EndMacro
    Macro container_y( ): y[#__c_container]: EndMacro
    Macro container_width( ): width[#__c_container]: EndMacro
    Macro container_height( ): height[#__c_container]: EndMacro
    
    ;-
    Macro scroll_x( ): x[#__c_required]: EndMacro
    Macro scroll_y( ): y[#__c_required]: EndMacro
    Macro scroll_width( ): width[#__c_required]: EndMacro
    Macro scroll_height( ): height[#__c_required]: EndMacro
    
    ;- TEMP
    Macro scroll_inner_width( ): width[#__c_inner]: EndMacro
    Macro scroll_inner_height( ): height[#__c_inner]: EndMacro
    
    ;-
    Macro _get_colors_( ) : colors::*this\blue : EndMacro
    
    ;-
    Macro is_item_( _this_, _item_ ) : Bool( _item_ >= 0 And _item_ < _this_\countitems ) : EndMacro
    Macro is_root_(_this_ ) : Bool( _this_ >= 65536 And _this_ = _this_\root ): EndMacro
    Macro is_widget_( _this_ ) : Bool( _this_ >= 65536 And _this_\address ) : EndMacro
    Macro is_menu_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type = constants::#__type_MenuBar ) : EndMacro
    ; Macro is_gadget_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type > 0 ) : EndMacro
    Macro is_window_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type = constants::#__type_window ) : EndMacro
    
    Macro is_child_( _this_, _parent_ )
      Bool( _this_\parent = _parent_ And Not ( _parent_\TabBox( ) And _this_\TabIndex( ) <> _parent_\TabBox( )\TabState( ) ))
    EndMacro
    Macro is_level_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\parent = _address_2\parent And _address_1\TabIndex( ) = _address_2\TabIndex( ) )
    EndMacro
    
    Macro is_scrollbars_( _this_ )
      Bool( _this_\parent And _this_\parent\scroll And ( _this_\parent\scroll\v = _this_ Or _this_\parent\scroll\h = _this_ ))
    EndMacro
    
    Macro is_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child > 0 )
    EndMacro
    
    Macro is_inside_( _position_, _size_, _mouse_ ) ;
      Bool( _mouse_ > _position_ And _mouse_ <= ( _position_ + _size_ ) And ( _position_ + _size_ ) > 0 )
    EndMacro
    
    Macro is_insidebox_( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
      Bool( is_inside_( _position_x_, _size_width_, _mouse_x_ ) And
            is_inside_( _position_y_, _size_height_, _mouse_y_ ) )
    EndMacro
    
    Macro is_insidecircle_( _position_x_, _position_y_, _mouse_x_, _mouse_y_, _circle_radius_ )
      Bool( Sqr( Pow((( _position_x_ + _circle_radius_ ) - _mouse_x_ ), 2 ) + Pow((( _position_y_ + _circle_radius_ ) - _mouse_y_ ), 2 )) <= _circle_radius_ )
    EndMacro
    
    Macro is_innerside_( _this_, _mouse_x_, _mouse_y_ )
      Bool( is_atpoint_( _this_, _mouse_x_, _mouse_y_, [#__c_draw] ) And
            is_atpoint_( _this_, _mouse_x_, _mouse_y_, [#__c_inner] ) And
            Not ( _this_\type = #__type_Splitter And is_atpoint_( _this_\bar\button, _mouse_x_, _mouse_y_ ) = 0 ) And
            Not ( _this_\type = #__type_HyperLink And is_atpoint_( _this_, _mouse_x_ - _this_\frame_x( ), _mouse_y_ - _this_\frame_y( ), [#__c_Required] ) = 0 ))
    EndMacro
    
    Macro is_atpoint_( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( is_inside_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ ) And
            is_inside_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ ) )
    EndMacro
    
    Macro is_interrect_( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
                         _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
      
      Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And
           ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ))
    EndMacro
    
    Macro is_intersect_( _address_1_, _address_2_, _address_1_mode_ = )
      Bool(( _address_1_\x#_address_1_mode_ + _address_1_\width#_address_1_mode_ ) > _address_2_\x And _address_1_\x#_address_1_mode_ < ( _address_2_\x + _address_2_\width ) And
           ( _address_1_\y#_address_1_mode_ + _address_1_\height#_address_1_mode_ ) > _address_2_\y And _address_1_\y#_address_1_mode_ < ( _address_2_\y + _address_2_\height ))
    EndMacro
    
    Macro is_text_gadget_( _this_ )
      Bool( _this_\type = #__type_Editor Or
            _this_\type = #__type_HyperLink Or
            _this_\type = #__type_IPAddress Or
            _this_\type = #__type_CheckBox Or
            _this_\type = #__type_Option Or
            _this_\type = #__type_Button Or
            _this_\type = #__type_String Or
            _this_\type = #__type_Text )
    EndMacro
    
    Macro is_list_gadget_( _this_ )
      Bool( _this_\type = #__type_Tree Or
            _this_\type = #__type_ListView Or
            _this_\type = #__type_ListIcon Or
            _this_\type = #__type_ExplorerTree Or
            _this_\type = #__type_ExplorerList )
    EndMacro
    
    Macro is_no_select_item_( _list_, _item_ )
      Bool( _item_ < 0 Or _item_ >= ListSize( _list_ ) Or (ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) ))
      ; Bool( _item_ >= 0 And ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ))
    EndMacro
    
    Macro is_lines_( _this_ )
      Bool( _this_\type = #__type_Editor Or
            _this_\type = #__type_String  Or
            _this_\type = #__type_Text Or
            _this_\type = #__type_Button Or
            _this_\type = #__type_Option Or
            _this_\type = #__type_Hyperlink Or
            _this_\type = #__type_ComboBox Or
            _this_\type = #__type_CheckBox )
    EndMacro
    Macro is_items_( _this_ )
      Bool( _this_\type = #__type_Tree Or
            _this_\type = #__type_ListIcon Or
            _this_\type = #__type_ListView Or
            _this_\type = #__type_Property )
    EndMacro
    
    ;-
    Macro ImageIDWidth( _image_id_ )
      func::GetImageWidth( _image_id_ )
    EndMacro
    
    Macro ImageIDHeight( _image_id_ )
      func::GetImageHeight( _image_id_ )
    EndMacro
    
    Macro ResizeImageID( _image_id_, _width_, _height_ )
      func::SetImageWidth( _image_id_, _width_ )
      func::SetImageHeight( _image_id_, _height_ )
    EndMacro
    
    
    ;-
    Macro CurrentFontID( )
      __gui\fontID    
    EndMacro
    Macro GetFontID( _address_ )
      _address_\text\fontID    
    EndMacro
    Macro SetFontID( _address_, _font_ID_ )
      _address_\text\fontID = _font_ID_ 
      
      ;__gui\mapfontID( Str(_address_) ) = _font_ID_
    EndMacro
    Macro ChangeFontID( _address_, _font_ID_ )
      Bool( GetFontID( _address_ ) <> _font_ID_ )
      SetFontID( _address_, _font_ID_ )
    EndMacro
    
    ;-
    Macro draw_mode_alpha_( _mode_ )
      draw_mode_( _mode_ | #PB_2DDrawing_AlphaBlend )
    EndMacro
    
    Macro draw_mode_( _mode_ )
      DrawingMode( _mode_ )
    EndMacro
    
    Macro draw_font( _address_, _font_id_ = 0 )
      If _font_id_
        If Not GetFontID( _address_ )
          SetFontID( _address_, _font_id_ )
          _address_\text\TextChange( ) = #True
        EndIf
      EndIf
      ;
      If GetFontID( _address_ ) And
         CurrentFontID( ) <> GetFontID( _address_ )
        ; Debug " draw current font - " + #PB_Compiler_Procedure + " " +  Str(_address_) + " " + CurrentFontID( ) +" "+ GetFontID( _address_ )
        CurrentFontID( ) = GetFontID( _address_ )
        
        DrawingFont( CurrentFontID( ) )
        _address_\text\TextChange( ) = #True
      EndIf
      ;
      If _address_\text\TextChange( ) Or Not ( _address_\text\width And _address_\text\height ) 
        If _address_\text\string
          _address_\text\width = TextWidth( _address_\text\string )
        EndIf
        
        _address_\text\height = TextHeight( "A" )
        
        If _address_\text\invert And
           _address_\text\vertical
          _address_\text\rotate = 270
        ElseIf _address_\text\invert
          _address_\text\rotate = 180 
        ElseIf _address_\text\vertical
          _address_\text\rotate = 90
        EndIf
      EndIf
    EndMacro
    
    Macro draw_box_( _x_, _y_, _width_, _height_, _color_ = $ffffffff )
      Box( _x_, _y_, _width_, _height_, _color_ )
    EndMacro
    
    Macro draw_roundbox_( _x_, _y_, _width_, _height_, _round_x_, _round_y_, _color_ = $ffffffff )
      If _round_x_ Or _round_y_
        RoundBox( _x_, _y_, _width_, _height_, _round_x_, _round_y_, _color_ ) ; bug _round_y_ = 0
      Else
        draw_box_( _x_, _y_, _width_, _height_, _color_ )
      EndIf
    EndMacro
    
    ;-
    Macro draw_up_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Line(_x_ + 7, _y_, 2, 1, _frame_color_)                                                                                                                  ; 0,0,0,0,0,0,0,0,0,0
      Plot(_x_ + 6, _y_ + 1, _frame_color_ ) : Line(_x_ + 7, _y_ + 1, 2, 1, _back_color_) : Plot(_x_ + 9, _y_ + 1, _frame_color_ )                             ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + 5, _y_ + 2, _frame_color_ ) : Line(_x_ + 6, _y_ + 2, 4, 1, _back_color_) : Plot(_x_ + 10, _y_ + 2, _frame_color_ )                            ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_ + 4, _y_ + 3, _frame_color_ ) : Line(_x_ + 5, _y_ + 3, 6, 1, _back_color_) : Plot(_x_ + 11, _y_ + 3, _frame_color_ )                            ; 0,0,1,1,1,1,1,1,0,0
      Line(_x_ + 3, _y_ + 4, _size_ / 3 - 1, 1, _frame_color_) : Line(_x_ + 7, _y_ + 4, 2, 1, _back_color_) : Line(_x_ + _size_ / 2 + 1, _y_ + 4, _size_ / 3 - 1 , 1, _frame_color_) ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + _size_ / 2 - 2, _y_ + 5, _frame_color_ ) : Line(_x_ + 7, _y_ + 5, 2, 1, _back_color_) : Plot(_x_ + _size_ / 2 + 1, _y_ + 5, _frame_color_ )                         ; 0,0,0,0,1,1,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ;
                                                                                                                                                                                     ;                                                                                                                                                      ;
    EndMacro
    Macro draw_down_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Plot(_x_ + _size_ / 2 - 2, _y_ + 4, _frame_color_ ) : Line(_x_ + 7, _y_ + 4, 2, 1, _back_color_) : Plot(_x_ + _size_ / 2 + 1, _y_ + 4, _frame_color_ )                     ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_ + 3, _y_ + 5, _size_ / 3 - 1, 1, _frame_color_) : Line(_x_ + 7, _y_ + 5, 2, 1, _back_color_) : Line(_x_ + _size_ / 2 + 1, _y_ + 5, _size_ / 3 - 1, 1, _frame_color_)  ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + 4, _y_ + 6, _frame_color_ ) : Line(_x_ + 5, _y_ + 6, 6, 1, _back_color_) : Plot(_x_ + 11, _y_ + 6, _frame_color_ )                                                  ; 0,0,1,1,1,1,1,1,0,0
      Plot(_x_ + 5, _y_ + 7, _frame_color_ ) : Line(_x_ + 6, _y_ + 7, 4, 1, _back_color_) : Plot(_x_ + 10, _y_ + 7, _frame_color_ )                                                  ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_ + 6, _y_ + 8, _frame_color_ ) : Line(_x_ + 7, _y_ + 8, 2, 1, _back_color_) : Plot(_x_ + 9, _y_ + 8, _frame_color_ )                                                   ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_ + 7, _y_ + 9, 2, 1, _frame_color_)                                                                                                                                    ; 0,0,0,0,0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ;
                                                                                                                                                                                     ;                                                                                                                                                      ;
    EndMacro
    Macro draw_left_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Line(_x_, _y_ + 7, 1, 2, _frame_color_)                                                                                                                  ; 0,0,1,0,0,0
      Plot(_x_ + 1, _y_ + 6, _frame_color_ ) : Line(_x_ + 1, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 1, _y_ + 9, _frame_color_ )                             ; 0,0,1,1,0,0
      Plot(_x_ + 2, _y_ + 5, _frame_color_ ) : Line(_x_ + 2, _y_ + 6, 1, 4, _back_color_) : Plot(_x_ + 2, _y_ + 10, _frame_color_ )                            ; 1,1,1,1,1,0
      Plot(_x_ + 3, _y_ + 4, _frame_color_ ) : Line(_x_ + 3, _y_ + 5, 1, 6, _back_color_) : Plot(_x_ + 3, _y_ + 11, _frame_color_ )                            ; 1,1,1,1,1,0
      Line(_x_ + 4, _y_ + 3, 1, _size_ / 3 - 1, _frame_color_) : Line(_x_ + 4, _y_ + 7, 1, 2, _back_color_) : Line(_x_ + 4, _y_ + _size_ / 2 + 1, 1, _size_ / 3 - 1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_ + 5, _y_ + _size_ / 2 - 2, _frame_color_ ) : Line(_x_ + 5, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 5, _y_ + _size_ / 2 + 1, _frame_color_ )                         ; 0,0,1,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
    EndMacro
    Macro draw_right_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Plot(_x_ + 4, _y_ + _size_ / 2 - 2, _frame_color_ ) : Line(_x_ + 4, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 4, _y_ + _size_ / 2 + 1, _frame_color_ )                     ; 0,0,0,1,0,0
      Line(_x_ + 5, _y_ + 3, 1, _size_ / 3 - 1, _frame_color_) : Line(_x_ + 5, _y_ + 7, 1, 2, _back_color_) : Line(_x_ + 5, _y_ + _size_ / 2 + 1, 1, _size_ / 3 - 1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_ + 6, _y_ + 4, _frame_color_ ) : Line(_x_ + 6, _y_ + 5, 1, 6, _back_color_) : Plot(_x_ + 6, _y_ + 11, _frame_color_ )                                                  ; 0,1,1,1,1,1
      Plot(_x_ + 7, _y_ + 5, _frame_color_ ) : Line(_x_ + 7, _y_ + 6, 1, 4, _back_color_) : Plot(_x_ + 7, _y_ + 10, _frame_color_ )                                                  ; 0,1,1,1,1,1
      Plot(_x_ + 8, _y_ + 6, _frame_color_ ) : Line(_x_ + 8, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 8, _y_ + 9, _frame_color_ )                                                   ; 0,0,1,1,0,0
      Line(_x_ + 9, _y_ + 7, 1, 2, _frame_color_)                                                                                                                                    ; 0,0,0,1,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
    EndMacro
    
    Macro draw_gradient_( _vertical_, _address_, _color_fore_, _color_back_, _mode_ = )
      BackColor( _color_fore_ & $FFFFFF | _address_\AlphaState24( ) )
      FrontColor( _color_back_ & $FFFFFF | _address_\AlphaState24( ) )
      
      If _vertical_  ; _address_\vertical
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, ( _address_\x#_mode_ + _address_\width#_mode_ ), _address_\y#_mode_ )
      Else
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, _address_\x#_mode_, ( _address_\y#_mode_ + _address_\height#_mode_ ))
      EndIf
      
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      
      BackColor( #PB_Default )
      FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_gradientbox_( _vertical_, _x_, _y_, _width_, _height_, _color_1_, _color_2_, _round_ = 0, _alpha_ = 255 )
      BackColor( _color_1_ & $FFFFFF | _alpha_ << 24 )
      FrontColor( _color_2_ & $FFFFFF | _alpha_ << 24 )
      
      If _vertical_
        LinearGradient( _x_, _y_, ( _x_ + _width_ ), _y_ )
      Else
        LinearGradient( _x_, _y_, _x_, ( _y_ + _height_ ))
      EndIf
      
      draw_roundbox_( _x_, _y_, _width_, _height_, _round_, _round_ )
      
      BackColor( #PB_Default ) : FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_button_( _type_, _x_, _y_, _width_, _height_, _checked_, _round_, _color_fore_ = $FFFFFFFF, _color_fore2_ = $FFE9BA81, _color_back_ = $80E2E2E2, _color_back2_ = $FFE89C3D, _color_frame_ = $80C8C8C8, _color_frame2_ = $FFDC9338, _alpha_ = 255, size=4 )
      draw_mode_alpha_( #PB_2DDrawing_Gradient )
      LinearGradient( _x_, _y_, _x_, ( _y_ + _height_ ))
      
      If _checked_
        BackColor( _color_fore2_ & $FFFFFF | _alpha_ << 24 )
        FrontColor( _color_back2_ & $FFFFFF | _alpha_ << 24 )
      Else
        BackColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
        FrontColor( _color_back_ & $FFFFFF | _alpha_ << 24 )
      EndIf
      
      draw_roundbox_( _x_, _y_, _width_, _height_, _round_, _round_ )
      
      If _type_ = 4
        FrontColor( $ff000000 & $FFFFFF | _alpha_ << 24 )
        BackColor( $ff000000 & $FFFFFF | _alpha_ << 24 )
        
        Line( _x_ + 1 + ( _width_ - 6 ) / 2, _y_ + ( _height_ - 6 ) / 2, 6, 6 )
        Line( _x_ + ( _width_ - 6 ) / 2, _y_ + ( _height_ - 6 ) / 2, 6, 6 )
        
        Line( _x_ - 1 + 6 + ( _width_ - 6 ) / 2, _y_ + ( _height_ - 6 ) / 2, - 6, 6 )
        Line( _x_ + 6 + ( _width_ - 6 ) / 2, _y_ + ( _height_ - 6 ) / 2, - 6, 6 )
      Else
        FrontColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
        BackColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
        
        If _checked_
          If _type_ = 1
            If _width_ % 2
              draw_roundbox_( _x_ + ( _width_ - 4 ) / 2, _y_ + ( _height_ - 4 ) / 2, 5, 5, 5, 5 )
            Else
              draw_roundbox_( _x_ + ( _width_ - 4 ) / 2, _y_ + ( _height_ - 4 ) / 2, 4, 4, 4, 4 )
            EndIf
          Else
            If _checked_ = - 1
              If _width_ % 2
                draw_box_( _x_ + ( _width_ - 4 ) / 2, _y_ + ( _height_ - 4 ) / 2, 5, 5 )
              Else
                draw_box_( _x_ + ( _width_ - 4 ) / 2, _y_ + ( _height_ - 4 ) / 2, 4, 4 )
              EndIf
            Else
              _box_x_ = _width_ / 2 - 4
              _box_y_ = _box_x_ + Bool( _width_ % 2 )
              
              LineXY(( _x_ + 1 + _box_x_ ), ( _y_ + 4 + _box_y_ ), ( _x_ + 2 + _box_x_ ), ( _y_ + 5 + _box_y_ )) ; Левая линия
              LineXY(( _x_ + 1 + _box_x_ ), ( _y_ + 5 + _box_y_ ), ( _x_ + 2 + _box_x_ ), ( _y_ + 6 + _box_y_ )) ; Левая линия
              
              LineXY(( _x_ + 6 + _box_x_ ), ( _y_ + 0 + _box_y_ ), ( _x_ + 3 + _box_x_ ), ( _y_ + 6 + _box_y_ )) ; правая линия
              LineXY(( _x_ + 7 + _box_x_ ), ( _y_ + 0 + _box_y_ ), ( _x_ + 4 + _box_x_ ), ( _y_ + 6 + _box_y_ )) ; правая линия
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      draw_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _checked_
        FrontColor( _color_frame2_ & $FFFFFF | _alpha_ << 24 )
      Else
        FrontColor( _color_frame_ & $FFFFFF | _alpha_ << 24 )
      EndIf
      
      draw_roundbox_( _x_, _y_, _width_, _height_, _round_, _round_, _color_frame_ & $FFFFFF | _alpha_ << 24 )
    EndMacro
    
    ;-
    Macro draw_plus( _address_, _plus_, _size_ = DesktopScaled( #__draw_plus_size ))
      Line(_address_\x + (_address_\width - _size_) / 2, _address_\y + (_address_\height - 1) / 2, _size_, 1, _address_\color\front[_address_\ColorState( )])
      If _plus_
        Line(_address_\x + (_address_\width - 1) / 2, _address_\y + (_address_\height - _size_) / 2, 1, _size_, _address_\color\front[_address_\ColorState( )])
      EndIf
    EndMacro
    
    Macro draw_arrows( _address_, _direction_ )
      Draw_Arrow( _direction_,
                  _address_\x + ( _address_\width - _address_\arrow\size ) / 2,
                  _address_\y + ( _address_\height - _address_\arrow\size ) / 2, 
                  _address_\arrow\size, _address_\arrow\type, 0,
                  _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
    EndMacro
    
    Macro draw_box( _address_, _color_type_, _mode_ = )
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_,
                      _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
    EndMacro
    
    Macro draw_box_button( _address_, _color_type_ )
      ;draw_box( _address_, _color_type_)
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
        draw_roundbox_( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
        draw_roundbox_( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
    EndMacro
    
    Macro draw_close_button( _address_, _size_ )
      ; close button
      If Not _address_\hide
        If _address_\ColorState( )
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          
          Line( _address_\x - 1 + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
        EndIf
        
        draw_box_button( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_maximize_button( _address_, _size_ )
      If Not _address_\hide
        If _address_\ColorState( )
          Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
        EndIf
        
        draw_box_button( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_minimize_button( _address_, _size_ )
      If Not _address_\hide
        If _address_\ColorState( )
          Line( _address_\x + 1 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x + 0 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          
          Line( _address_\x - 1 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
          Line( _address_\x - 2 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
        EndIf
        
        draw_box_button( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_help_button( _address_, _size_ )
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height,
                        _address_\round, _address_\round, _address_\color\frame[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
    EndMacro
    
    Macro draw_option_button( _address_, _size_, _color_ )
      If _address_\round > 2
        If _address_\width % 2
          draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, _size_ + 1, _size_ + 1, _color_ )
        Else
          draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _size_, _size_, _color_ )
        EndIf
      Else
        If _address_\width % 2
          draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, 1, 1, _color_ )
        Else
          draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, 1, 1, _color_ )
        EndIf
      EndIf
    EndMacro
    
    Macro draw_button_check( _address_, _size_, _color_ )
      LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 4 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
      LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
      
      LineXY(( _address_\x + 5 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 2 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
      LineXY(( _address_\x + 6 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 3 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
    EndMacro
    
    Macro draw_background_image_( _this_, _x_, _y_, _mode_ = )
      ; draw_mode_alpha_( #PB_2DDrawing_Transparent )
      DrawAlphaImage( _this_\image#_mode_\id, _x_ + _this_\image#_mode_\x + _this_\scroll_x( ), _y_ + _this_\image#_mode_\y + _this_\scroll_y( ), _this_\ColorAlphaState( ) )
    EndMacro
    
    ;     Macro Close( )
    ;       PB(CloseGadgetList)( )
    ;     EndMacro
    
    ;-  -------------------
    ;-   DECLARE_functions
    ;-  -------------------
    ;{
    ; Requester
    Global resize_one
    
    Declare   CanvasEvents( )
    Declare   EventRepaint( )
    Declare   EventActivate( )
    Declare   EventDeactivate( )
    Declare   EventResize( )
    
    
    ;     Declare.b bar_tab_UpdateItems( *this._s_WIDGET, List *items._s_ITEMS( ) )
    Declare.l bar_setAttribute( *this, Attribute.l, *value )
    ;     Declare.i bar_tab_SetState( *this, item.l )
    ;     Declare   bar_mdi_resize( *this, x.l, y.l, width.l, height.l )
    ;     Declare   bar_mdi_update( *this, x.l, y.l, width.l, height.l )
    Declare   bar_area_resize( *this, x.l, y.l, width.l, height.l )
    Declare.b bar_Update( *this, mode.b = 1 )
    Declare.b bar_PageChange( *this, state.l, mode.b = 1 )
    ;     
    ;     
    ;     Declare   Close( *window )
    ;     Declare   GetBar( *this, type.b, index.b = 0 )
    Declare   GetAtPoint( *root, mouse_x, mouse_y, List *List._s_WIDGET( ), *address = #Null )
    ;     
    ;     Declare.i ToPBEventType( event.i )
    ;     Declare.i TypeFromClass( class.s )
    ;     Declare.s ClassFromType( type.i )
    ;     Declare.s ClassFromEvent( event.i )
    Declare   SetBackgroundColor( *this, color.l )
    ;     
    ;     
    Declare   EventHandler( event = - 1, canvas.i = - 1, eventtype.i = - 1, eventdata = 0 )
    Declare.b Draw( *this )
    Declare   ReDraw( *root = 0 )
    ;     
    Declare.l WidgetX( *this, mode.l = #__c_frame )
    Declare.l WidgetY( *this, mode.l = #__c_frame )
    Declare.l WidgetWidth( *this, mode.l = #__c_frame )
    Declare.l WidgetHeight( *this, mode.l = #__c_frame )
    
    Declare.i WidgetID( index )
    Declare.l GetIndex( *this )
    Declare.i GetCanvasGadget( *this = #Null )
    Declare.i GetCanvasWindow( *this = #Null )
    
    ;     
    ;     Declare.b Hide( *this, State.b = #PB_Default, flags.q = 0 )
    ;     Declare.b Disable( *this, State.b = #PB_Default )
    
    Declare.b Resize( *this, ix.l, iy.l, iwidth.l, iheight.l )
    ;     Declare.i SetAlign( *this, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
    ;     Declare.i SetAttach( *this, *parent, mode.a )
    ;     
    ;     Declare.q ToPBFlag( Type, Flag.q )
    ;     Declare.q FromPBFlag( Type, Flag.q )
    ;     Declare.q Flag( *this, flag.q = #Null, state.b = #PB_Default )
    ; ;     
    ;     Declare   ChildrenBounds( *this )
    ;     Declare   SetMoveBounds( *this, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
    ;     Declare   SetSizeBounds( *this, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
    ;     
    ;     Declare.l CountItems( *this )
    ;     Declare.l ClearItems( *this )
    ;     Declare   RemoveItem( *this, Item.l )
    ;     
    ;     Declare.l GetDeltaX( *this )
    ;     Declare.l GetDeltaY( *this )
    ;     Declare.l GetLevel( *this )
    ;     
    ;     Declare.i Getroot( *this )
    ;     Declare.l WidgetType( *this )
    ;     Declare.i GetTypeCount( *this, mode.b = #False )
    ;     
    ;     
    ;     Declare   GetLast( *last, tabindex.l )
    ;     
    ;     Declare.i GetAddress( *this )
    ;     
    ;   Declare.i SetActive( *this )
    ;     
    ;     Declare.a GetFrame( *this, mode.b = 0 )
    ;     Declare   SetFrame( *this, size.a, mode.b = 0 )
    ;     
    ;     Declare.s GetClass( *this )
    ;     Declare   SetClass( *this, class.s )
    ;     
    ;     Declare.s GetText( *this )
    ;     Declare   SetText( *this, Text.s )
    ;     
    ;     Declare.i GetData( *this )
    ;     Declare.i SetData( *this, *data )
    ;     
    ;     Declare.i GetFont( *this )
    ;     Declare.i SetFont( *this, FontID.i )
    ;     
    Declare.i GetState( *this )
    Declare.b SetState( *this, state.i )
    ;     
    Declare.i GetParent( *this )
    Declare   SetParent( *this, *parent, tabindex.l = #PB_Default )
    ;     
    ;     Declare   GetPosition( *this, position.l )
    ;     Declare   SetPosition( *this, position.l, *widget = #Null )
    ;     
    ;     Declare.l GetColor( *this, ColorType.l )
    ;     Declare.l SetColor( *this, ColorType.l, Color.l, Column.l = 0 )
    ;     
    Declare.i GetAttribute( *this, Attribute.l )
    Declare.i SetAttribute( *this, Attribute.l, *value )
    ;     
    ;     
    ;     ;
    ;     Declare.l GetItemState( *this, Item.l )
    ;     Declare.b SetItemState( *this, Item.l, State.b )
    ;     
    ;     Declare.i GetItemData( *this, item.l )
    ;     Declare.i SetItemData( *this, item.l, *data )
    ;     
    ;     Declare.s GetItemText( *this, Item.l, Column.l = 0 )
    ;     Declare.l SetItemText( *this, Item.l, Text.s, Column.l = 0 )
    ;     
    ;     Declare.i GetItemImage( *this, Item.l )
    ;     Declare.i SetItemImage( *this, Item.l, Image.i )
    ;     
    ;     Declare.i GetItemFont( *this, Item.l )
    ;     Declare.i SetItemFont( *this, Item.l, Font.i )
    ;     
    ;     Declare.l GetItemColor( *this, Item.l, ColorType.l, Column.l = 0 )
    ;     Declare.l SetItemColor( *this, Item.l, ColorType.l, Color.l, Column.l = 0 )
    ;     
    ;     Declare.i GetItemAttribute( *this, Item.l, Attribute.l, Column.l = 0 )
    ;     Declare.i SetItemAttribute( *this, Item.l, Attribute.l, *value, Column.l = 0 )
    ;     
    ;     Declare.i GetCursor( *this, index = 0 )
    ;     Declare   SetCursor( *this, *cursor, index = 0 )
    ;     Declare   ChangeCursor( *this, *cursor )
    ;     
    ;     Declare   SetImage( *this, *image )
    ;     Declare   SetBackgroundImage( *this, *image )
    ;     
    ;     Declare   GetPositionAfter( *this, tabindex.l )
    ;     Declare   GetPositionLast( *this, tabindex.l = #PB_Default )
    ;     
    ;     Declare.i Create( *parent, class.s, type.l, x.l, y.l, width.l, height.l, Text.s = #Null$, flag.q = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 0, ScrollStep.f = 1.0 )
    ;     
    ;     ; button
    ;     Declare.i Text( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
    ;     Declare.i String( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
    ;     Declare.i Button( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, Image.i = -1, round.l = 0 )
    ;     Declare.i Option( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
    ;     Declare.i Checkbox( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
    ;     Declare.i HyperLink( x.l, y.l, width.l, height.l, Text.s, Color.i, flag.q = 0 )
    ;     Declare.i ComboBox( x.l, y.l, width.l, height.l, flag.q = 0 )
    ;     
    ;     ; bar
    ;     Declare.i Spin( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0, increment.f = 1.0 )
    ;     Declare.i Tab( x.l, y.l, width.l, height.l, flag.q = 0, round.l = 0 )
    ;     Declare.i Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
    ;     Declare.i Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = #__buttonround )
    ;     Declare.i Progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
    Declare.i Splitter( x.l, y.l, width.l, height.l, First.i, Second.i, flag.q = 0 )
    ;     
    ;     ; list
    ;     Declare.i Tree( x.l, y.l, width.l, height.l, flag.q = 0 )
    ;     Declare.i ListView( x.l, y.l, width.l, height.l, flag.q = 0 )
    ;     Declare.i Editor( x.l, Y.l, width.l, height.l, flag.q = 0, round.i = 0 )
    ;     Declare.i ListIcon( x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.i, flag.q = 0 )
    ;     
    ;     Declare.i ExplorerList( x.l, y.l, width.l, height.l, Directory.s, flag.q = 0 )
    ;     
    ;     Declare.i Image( x.l, y.l, width.l, height.l, image.i, flag.q = 0 )
    ;     Declare.i ButtonImage( x.l, y.l, width.l, height.l, Image.i = -1, flag.q = 0, round.l = 0 )
    ;     
    ;     ; container
    ;     Declare.i Panel( x.l, y.l, width.l, height.l, flag.q = #__flag_BorderFlat )
    ;     Declare.i Container( x.l, y.l, width.l, height.l, flag.q = #__flag_BorderFlat )
    ;     Declare.i Frame( x.l, y.l, width.l, height.l, Text.s, flag.q = #__flag_nogadgets )
    ;     Declare.i Window( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, *parent = 0 )
    Declare.i ScrollArea( x.l, y.l, width.l, height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, flag.q = #__flag_BorderFlat )
    ;     Declare.i MDI( x.l, y.l, width.l, height.l, flag.q = 0 )
    ;     
    ;     ; menu
    ;     Declare.i DisplayPopupMenuBar( *this, *display, x.l = #PB_Ignore, y.l = #PB_Ignore )
    ;     Declare   BarPosition( *this, position.i, size.i = #PB_Default )
    ;     Declare   CreateBar( type.b = #Null, *parent = #Null, flag.q = #Null )
    ;     Declare   CreateMenuBar( *parent, flag.q = #Null )
    ;     Declare   CreatePopupMenuBar( flag.q = #Null ) 
    ;     Declare   BarTitle( title.s, image = - 1 )
    ;     Declare   BarItem( item, text.s, image = - 1 )
    ;     Declare   BarButton( button.i, image.i, mode.i = 0, text.s = #Null$ )
    ;     Declare   BarSeparator( )
    ;     Declare   OpenBar( text.s, image.i = - 1 )
    ;     Declare   CloseBar( )
    ;     
    ;     Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.q = 0 )
    ;     Declare   AddColumn( *this, Position.l, Text.s, Width.l, Image.i = - 1 )
    ;     
    Declare.b Draw_Arrow( direction.a, x.l, y.l, size.a, mode.b = 1, framesize.a = 0, Color = $ff000000 )
    ;     ;
    Declare.i Send( *this, eventtype.l, *button = #PB_All, *data = #Null )
    Declare.i Post( *this, eventtype.l, *button = #PB_All, *data = #Null )
    Declare.i Bind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Unbind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    ;     ;
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    ;     ;
    Declare   DoEvents( *this, eventtype.l, *button = #PB_All, *data = #Null ) ;, mouse_x.l, mouse_y.l
    Declare   Open( Window, x.l = 0, y.l = 0, width.l = #PB_Ignore, height.l = #PB_Ignore, title$ = #Null$, flag.q = #Null, *parentID = #Null, canvas = #PB_Any )
    ;     Declare.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l, height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, flag.q = #Null )
    Declare   Free( *this )
    ;}
  EndDeclareModule
  
  Module Widget
    ;-
    ;-\\ DECLARE PRIVATEs
    ;-
    Declare Repost( )
    Declare DoEvent_Button( *this, eventtype.l, mouse_x.l = - 1, mouse_y.l = - 1 )
    Macro PB(Function)
      Function
    EndMacro
    
    
    
    ;\\
    Macro Leaved( _address_ )
      Bool( _address_\enter )
      If _address_\enter
        _address_\enter = 0
        
        If _address_\ColorState( ) = #__s_1
          _address_\ColorState( ) = #__s_0
        EndIf
      EndIf
    EndMacro
    Macro Entered( _address_ )
      Bool( Not _address_\enter )
      If Not _address_\enter
        _address_\enter = 1
        
        If _address_\ColorState( ) = #__s_0
          _address_\ColorState( ) = #__s_1
        EndIf
      EndIf
    EndMacro
    
    
    ;-
     Macro set_image_( _this_, _address_, _image_ )
      If IsImage( _image_ )
        _address_\change = 1
        _address_\img    = _image_
        _address_\id     = ImageID( _image_ )
        
        ;         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ;           If _address_\size
        ;             resize_image( _address_\id,
        ;                          _address_\size,
        ;                          _address_\size )
        ;
        ;             _address_\width = _address_\size
        ;             _address_\height = _address_\size
        ;           Else
        ;             _address_\width = get_image_width( _address_\id )
        ;             _address_\height = get_image_height( _address_\id )
        ;           EndIf
        ;         CompilerElse
        If _address_\size
          ResizeImage( _image_,
                       _address_\size,
                       _address_\size )
          
          _address_\width  = _address_\size
          _address_\height = _address_\size
        Else
          _address_\width  = ImageWidth( _image_ )
          _address_\height = ImageHeight( _image_ )
        EndIf
        ;         CompilerEndIf
        
        _address_\depth = ImageDepth( _image_, #PB_Image_OriginalDepth )
      Else
        _address_\change = - 1
        _address_\img    = - 1
        _address_\id     = 0
        _address_\width  = 0
        _address_\height = 0
      EndIf
    EndMacro
    
    Macro set_color_( _result_, _address_, _color_type_, _color_, _alpha_, _column_ = )
      If Not _address_\alpha And _alpha_
        _address_\alpha.allocate( COLOR )
      EndIf
      
      Select _color_type_
        Case #__color_line
          If _address_\line#_column_ <> _color_
            _address_\line#_column_ = _color_
            If _address_\alpha
              _address_\alpha\line#_column_ = _alpha_
            EndIf
            _result_ = #True
          EndIf
        Case #__color_back
          If _address_\back#_column_ <> _color_
            _address_\back#_column_ = _color_
            If _address_\alpha
              _address_\alpha\back#_column_ = _alpha_
            EndIf
            _result_ = #True
          EndIf
        Case #__color_fore
          If _address_\fore#_column_ <> _color_
            _address_\fore#_column_ = _color_
            If _address_\alpha
              _address_\alpha\fore#_column_ = _alpha_
            EndIf
            _result_ = #True
          EndIf
        Case #__color_front
          If _address_\front#_column_ <> _color_
            _address_\front#_column_ = _color_
            If _address_\alpha
              _address_\alpha\front#_column_ = _alpha_
            EndIf
            _result_ = #True
          EndIf
        Case #__color_frame
          If _address_\frame#_column_ <> _color_
            _address_\frame#_column_ = _color_
            If _address_\alpha
              _address_\alpha\frame#_column_ = _alpha_
            EndIf
            _result_ = #True
          EndIf
      EndSelect
      
    EndMacro
    
    ;-
    Macro DoCurrentCursor( _this_, _cursor_, _data_=0 )
      If CurrentCursor( ) <> _cursor_
        CurrentCursor( ) = _cursor_
        Debug " DoCurrentCursor( "+ _cursor_ +" ) " + _data_
        DoEvents( _this_, #__event_Cursor, #PB_All, _data_ )
      EndIf
    EndMacro
    
    Procedure.i ChangeCursor( *this._s_WIDGET, *cursor )
      Protected result.i
      
      If Cursor( *this ) <> *cursor
        Debug "changeCURSOR ( "+ *cursor +" ) "
        result = Cursor( *this )
        DoCurrentCursor( *this, *cursor, 123456789 )
        Cursor( *this ) = *cursor
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetCursor( *this._s_WIDGET, index = 0 )
      ProcedureReturn *this\cursor[index]
    EndProcedure
    
    Procedure.i SetCursor( *this._s_WIDGET, *cursor, index = 0 )
      If *this > 0
        If *this\cursor <> *cursor
          ; Debug "setCURSOR( " + *cursor +" )"
          
          ChangeCursor( *this, *cursor )
          *this\cursor = *cursor
          ProcedureReturn 1
        EndIf
      Else
        If CurrentCursor( ) <> *cursor
          CurrentCursor( ) = *cursor
          ProcedureReturn 1
        EndIf
      EndIf
    EndProcedure
    
    ;-
    Procedure.l WidgetX( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * DesktopUnscaledX( *this\x[mode] ) )
    EndProcedure
    
    Procedure.l WidgetY( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * DesktopUnscaledY( *this\y[mode] ) )
    EndProcedure
    
    Procedure.l WidgetWidth( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * DesktopUnscaledX( *this\width[mode] ) )
    EndProcedure
    
    Procedure.l WidgetHeight( *this._s_WIDGET, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * DesktopUnscaledY( *this\height[mode] ) )
    EndProcedure
    
    Procedure.b IsContainer( *this._s_WIDGET )
      ProcedureReturn *this\container
    EndProcedure
    
    Procedure IsChild( *this._s_WIDGET, *parent._s_WIDGET )
      Protected result
      ;
      If *this And
         *this <> *parent And
         *parent\haschildren
        ;
        Repeat
          *this = *this\parent
          If *this
            If *parent = *this
              result = *this
              Break
            EndIf
          Else
            Break
          EndIf
        Until is_root_( *this )
      EndIf
      ;
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Sticky( *window._s_WIDGET = #PB_Default, state.b = #PB_Default )
    EndProcedure
    
    ;-
    Macro HideState( _this_ )
      Bool( _this_\hidden Or
            ( _this_\parent And ( _this_\parent\hide Or 
                                  ( _this_\parent\TabBox( ) And _this_\parent\TabBox( )\TabState( ) <> _this_\TabIndex( )) )))
      
      
      ; Чтобы обновить границы отоброжения (clip-coordinate)
      _this_\resize\clip = #True
    EndMacro
    
    
    Procedure ChildrensState( *this._s_WIDGET, *mode = 0 )
      If StartEnumerate( *this )
        ;
        If *mode = 1
          ; hide all children's except those whose parent-item is selected
          widgets( )\hide = HideState( widgets( ) )
        EndIf
        If *mode = 2
          ; disable all children's except those whose parent-item is selected
          If *this\disable
            widgets( )\disable = - 1
          Else
            widgets( )\disable = 0
          EndIf
          
          If widgets( )\TabBox( )
            If widgets( )\disable
              widgets( )\TabBox( )\disable = - 1
            Else
              widgets( )\TabBox( )\disable = 0
            EndIf
          EndIf
          If widgets( )\StringBox( )
            If widgets( )\disable
              widgets( )\StringBox( )\disable = - 1
            Else
              widgets( )\StringBox( )\disable = 0
            EndIf
          EndIf
          If widgets( )\scroll
            If widgets( )\scroll\v
              If widgets( )\disable
                widgets( )\scroll\v\disable = - 1
              Else
                widgets( )\scroll\v\disable = 0
              EndIf
            EndIf
            If widgets( )\scroll\h
              If widgets( )\disable
                widgets( )\scroll\h\disable = - 1
              Else
                widgets( )\scroll\h\disable = 0
              EndIf
            EndIf
          EndIf
        EndIf
        ;
        StopEnumerate( )
      EndIf
    EndProcedure
    
    Procedure.b Hide( *this._s_WIDGET, state.b = #PB_Default, flags.q = 0 )
      If State = #PB_Default : ProcedureReturn *this\hide : EndIf
      
      If *this\hidden <> state
        *this\hidden = state
        
        ; *this\hide = HideState( *this )
        
        If *this\parent
          If Not *this\parent\hide
            *this\hide = state
          EndIf
        Else
          *this\hide = state 
        EndIf
        
        ; Чтобы обновить границы отоброжения (clip-coordinate)
        *this\resize\clip = #True
        
        If *this\haschildren
          ChildrensState( *this, 1 )
        EndIf
      EndIf
    EndProcedure
    
    ;
    Procedure.b Disable( *this._s_WIDGET, State.b = #PB_Default )
      Protected result.b = *this\disable
      
      If State >= 0 And
         *this\disable <> State
        *this\disable = State
        ;Debug " DISABLE - " + *this\class + " " + State
        
        If *this\TabBox( )
          If *this\disable
            *this\TabBox( )\disable = - 1
          Else
            *this\TabBox( )\disable = 0
          EndIf
        EndIf
        If *this\StringBox( )
          If *this\disable
            *this\StringBox( )\disable = - 1
          Else
            *this\StringBox( )\disable = 0
          EndIf
        EndIf
        If *this\scroll
          If *this\scroll\v
            If *this\disable
              *this\scroll\v\disable = - 1
            Else
              *this\scroll\v\disable = 0
            EndIf
          EndIf
          If *this\scroll\h
            If *this\disable
              *this\scroll\h\disable = - 1
            Else
              *this\scroll\h\disable = 0
            EndIf
          EndIf
        EndIf
        
        If *this\haschildren
          ChildrensState( *this, 2 )
        EndIf
        
        PostRepaint( *this\root )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    ;-
    Procedure ReParent( *this._s_WIDGET, *parent._s_WIDGET )
      ;\\
      If Not is_integral_( *this )
        If *parent\container
          *parent\haschildren + 1
        EndIf
      EndIf
      
      ;\\
      If *parent\root
        If Not is_integral_( *this )
          If Not is_root_( *parent )
            *parent\root\haschildren + 1
          EndIf
        EndIf
        *this\root = *parent\root
      Else
        *this\root = *parent
      EndIf
      
      ;\\
      If is_window_( *parent )
        *this\window = *parent
      Else
        *this\window = *parent\window
      EndIf
      
      ;\\
      *this\level  = *parent\level + 1
      *this\parent = *parent
      
      ;\\ is integrall scroll bars
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\root   = *this\root
          *this\scroll\v\window = *this\window
        EndIf
        If *this\scroll\h
          *this\scroll\h\root   = *this\root
          *this\scroll\h\window = *this\window
        EndIf
      EndIf
    EndProcedure
    
    
    
    
    
    ;-
    Macro clip_output_( _address_, _mode_ = [#__c_draw] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( draw, #PB_Module ))
        ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    
    Procedure ClipPut( *this._s_WIDGET, x, y, width, height )
      Protected clip_x, clip_y, clip_w, clip_h
      
      ; clip inner coordinate
      If *this\draw_x( ) < x
        clip_x = x
      Else
        clip_x = *this\draw_x( )
      EndIf
      
      If *this\draw_y( ) < y
        clip_y = y
      Else
        clip_y = *this\draw_y( )
      EndIf
      
      If *this\draw_width( ) > width
        clip_w = width
      Else
        clip_w = *this\draw_width( )
      EndIf
      
      If *this\draw_height( ) > height
        clip_h = height
      Else
        clip_h = *this\draw_height( )
      EndIf
      
      PB(ClipOutput)( clip_x, clip_y, clip_w, clip_h )
    EndProcedure
    
    Procedure Reclip( *this._s_WIDGET )
      Macro clip_width_( _address_, _parent_, _x_width_, _parent_ix_iwidth_, _mode_ = )
        If _parent_ And
           (_parent_\x#_mode_ + _parent_\width#_mode_) > 0 And
           (_parent_\x#_mode_ + _parent_\width#_mode_) < (_x_width_) And
           (_parent_ix_iwidth_) > (_parent_\x#_mode_ + _parent_\width#_mode_)
          
          _address_\width#_mode_ = (_parent_\x#_mode_ + _parent_\width#_mode_) - _address_\x#_mode_
        ElseIf _parent_ And (_parent_ix_iwidth_) > 0 And (_parent_ix_iwidth_) < (_x_width_)
          
          _address_\width#_mode_ = (_parent_ix_iwidth_) - _address_\x#_mode_
        Else
          _address_\width#_mode_ = (_x_width_) - _address_\x#_mode_
        EndIf
        
        If _address_\width#_mode_ < 0
          _address_\width#_mode_ = 0
        EndIf
      EndMacro
      
      Macro clip_height_( _address_, _parent_, _y_height_, _parent_iy_iheight_, _mode_ = )
        If _parent_ And
           (_parent_\y#_mode_ + _parent_\height#_mode_) > 0 And
           (_parent_\y#_mode_ + _parent_\height#_mode_) < (_y_height_) And
           (_parent_iy_iheight_) > (_parent_\y#_mode_ + _parent_\height#_mode_)
          
          _address_\height#_mode_ = (_parent_\y#_mode_ + _parent_\height#_mode_) - _address_\y#_mode_
        ElseIf _parent_ And (_parent_iy_iheight_) > 0 And (_parent_iy_iheight_) < (_y_height_)
          
          _address_\height#_mode_ = (_parent_iy_iheight_) - _address_\y#_mode_
        Else
          _address_\height#_mode_ = (_y_height_) - _address_\y#_mode_
        EndIf
        
        If _address_\height#_mode_ < 0
          _address_\height#_mode_ = 0
        EndIf
      EndMacro
      
      ; then move and size parent set clip coordinate
      Protected _p_x2_
      Protected _p_y2_
      Protected *parent._s_WIDGET
      
      If *this\bounds\attach
        *parent = *this\bounds\attach\parent
      Else
        *parent = *this\parent
      EndIf
      
      If is_root_( *this )
        If *this\draw_width( ) <> *this\width
          *this\draw_width( )     = *this\width
          *this\width[#__c_draw2] = *this\width
        EndIf
        If *this\draw_height( ) <> *this\height
          *this\draw_height( )     = *this\height
          *this\height[#__c_draw2] = *this\height
        EndIf
      Else
        If *parent
          _p_x2_ = *parent\inner_x( ) + *parent\inner_width( )
          _p_y2_ = *parent\inner_y( ) + *parent\inner_height( )
          
          ; for the splitter children's
          If *parent\type = #__type_Splitter
            If *parent\split_1( ) = *this
              _p_x2_ = *parent\bar\button[1]\x + *parent\bar\button[1]\width
              _p_y2_ = *parent\bar\button[1]\y + *parent\bar\button[1]\height
            EndIf
            If *parent\split_2( ) = *this
              _p_x2_ = *parent\bar\button[2]\x + *parent\bar\button[2]\width
              _p_y2_ = *parent\bar\button[2]\y + *parent\bar\button[2]\height
            EndIf
          EndIf
          
          If *this\child And Not *this\bounds\attach
            If *this\type = #__type_ToolBarBar Or
               *this\type = #__type_TabBarBar Or
               *this\type = #__type_MenuBar Or
               *this\type = #__type_ScrollBar
              ;
              _p_x2_ = *parent\inner_x( ) + *parent\container_width( )
              _p_y2_ = *parent\inner_y( ) + *parent\container_height( )
            EndIf
            
            ; for the scrollarea children's except scrollbars
          Else
            If *parent\scroll_width( ) And
               _p_x2_ > *parent\inner_x( ) + *parent\scroll_x( ) + *parent\scroll_width( )
              _p_x2_ = *parent\inner_x( ) + *parent\scroll_x( ) + *parent\scroll_width( )
            EndIf
            If *parent\scroll_height( ) And
               _p_y2_ > *parent\inner_y( ) + *parent\scroll_y( ) + *parent\scroll_height( )
              _p_y2_ = *parent\inner_y( ) + *parent\scroll_y( ) + *parent\scroll_height( )
            EndIf
          EndIf
        EndIf
        
        ; then move and size parent set clip coordinate
        ;\\ x&y - clip screen coordinate
        If *parent And
           *parent\inner_x( ) > *this\screen_x( ) And
           *parent\inner_x( ) > *parent\draw_x( )
          *this\draw_x( ) = *parent\inner_x( )
        ElseIf *parent And *parent\draw_x( ) > *this\screen_x( )
          *this\draw_x( ) = *parent\draw_x( )
        Else
          *this\draw_x( ) = *this\screen_x( )
        EndIf
        If *parent And
           *parent\inner_y( ) > *this\screen_y( ) And
           *parent\inner_y( ) > *parent\draw_y( )
          *this\draw_y( ) = *parent\inner_y( )
        ElseIf *parent And *parent\draw_y( ) > *this\screen_y( )
          *this\draw_y( ) = *parent\draw_y( )
        Else
          *this\draw_y( ) = *this\screen_y( )
        EndIf
        If *this\draw_x( ) < 0 : *this\draw_x( ) = 0 : EndIf
        If *this\draw_y( ) < 0 : *this\draw_y( ) = 0 : EndIf
        
        ;\\ width&height - clip coordinate
        clip_width_( *this, *parent, *this\screen_x( ) + *this\screen_width( ), _p_x2_, [#__c_draw] )
        clip_height_( *this, *parent, *this\screen_y( ) + *this\screen_height( ), _p_y2_, [#__c_draw] )
        
        
        ;\\ x&y - clip inner coordinate
        If *this\draw_x( ) < *this\inner_x( )
          *this\x[#__c_draw2] = *this\inner_x( )
        Else
          *this\x[#__c_draw2] = *this\draw_x( )
        EndIf
        If *this\draw_y( ) < *this\inner_y( )
          *this\y[#__c_draw2] = *this\inner_y( )
        Else
          *this\y[#__c_draw2] = *this\draw_y( )
        EndIf
        
        ;\\ width&height - clip inner coordinate
        If *parent
          ;           If *this\scroll_width( ) And *this\scroll_width( ) < *this\inner_width( )
          ;             clip_width_( *this, *parent, *this\inner_x( ) + *this\scroll_width( ), _p_x2_, [#__c_draw2] )
          ;           Else
          clip_width_( *this, *parent, *this\inner_x( ) + *this\inner_width( ), _p_x2_, [#__c_draw2] )
          ;           EndIf
          ;           If *this\scroll_height( ) And *this\scroll_height( ) < *this\inner_height( )
          ;             clip_height_( *this, *parent, *this\inner_y( ) + *this\scroll_height( ), _p_y2_, [#__c_draw2] )
          ;           Else
          clip_height_( *this, *parent, *this\inner_y( ) + *this\inner_height( ), _p_y2_, [#__c_draw2] )
          ;           EndIf
        EndIf
      EndIf
      
      ;
      ; clip child bar
      If *this\TabBox( )
        *this\TabBox( )\draw_x( )      = *this\draw_x( )
        *this\TabBox( )\draw_y( )      = *this\draw_y( )
        *this\TabBox( )\draw_width( )  = *this\draw_width( )  ; 39;*this\width[#__c_draw2] ; 
        *this\TabBox( )\draw_height( ) = *this\draw_height( )
      EndIf
      If *this\StringBox( )
        *this\StringBox( )\draw_x( )      = *this\draw_x( )
        *this\StringBox( )\draw_y( )      = *this\draw_y( )
        *this\StringBox( )\draw_width( )  = *this\draw_width( )
        *this\StringBox( )\draw_height( ) = *this\draw_height( )
      EndIf
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\draw_x( )      = *this\draw_x( )
          *this\scroll\v\draw_y( )      = *this\draw_y( )
          *this\scroll\v\draw_width( )  = *this\draw_width( )
          *this\scroll\v\draw_height( ) = *this\draw_height( )
        EndIf
        If *this\scroll\h
          *this\scroll\h\draw_x( )      = *this\draw_x( )
          *this\scroll\h\draw_y( )      = *this\draw_y( )
          *this\scroll\h\draw_width( )  = *this\draw_width( )
          *this\scroll\h\draw_height( ) = *this\draw_height( )
        EndIf
      EndIf
      
      ProcedureReturn Bool( *this\draw_width( ) > 0 And *this\draw_height( ) > 0 )
    EndProcedure
    
    Procedure.b Resize( *this._s_WIDGET, x.l, y.l, width.l, height.l )
      Protected.b result
      Protected.l ix, iy, iwidth, iheight, Change_x, Change_y, Change_width, Change_height
      *this\redraw = 1
      If *this\parent 
        *this\parent\redraw = 1
      EndIf
      
      ;\\
      If *this\resize\change <> 1
        *this\resize\change = 1
      EndIf
      
      ;\\
      If *this\anchors
        If *this\bs < *this\fs + *this\anchors\pos
          *this\bs = *this\fs + *this\anchors\pos
        EndIf
      Else
        If *this\bs < *this\fs
          *this\bs = *this\fs
        EndIf
      EndIf
      ;
      If *this\autosize And *this\parent And *this\parent\type = #__type_Splitter
        *this\autosize = 0
      EndIf
      
      ;\\
      If *this\autosize
        If *this\parent And 
           *this\parent <> *this 
          
          x      = (*this\parent\inner_x( ))
          Y      = (*this\parent\inner_y( ))
          width  = (*this\parent\inner_width( ))
          height = (*this\parent\inner_height( ))
        EndIf
      Else
        ;
        CompilerIf #PB_Compiler_DPIAware
          If Not *this\noscale
            If Not is_integral_( *this )
              If x <> #PB_Ignore
                x = DesktopScaledX( x )
              EndIf
              If width <> #PB_Ignore
                width = DesktopScaledX( width )
              EndIf
              If y <> #PB_Ignore
                y = DesktopScaledY( y )
              EndIf
              If height <> #PB_Ignore
                height = DesktopScaledY( height )
              EndIf
            EndIf
          EndIf
        CompilerEndIf
        
        ;\\ move & size steps
        If mouse( )\steps > 1 And *this\anchors And *this\anchors\mode
          If x <> #PB_Ignore
            x + ( x % mouse( )\steps )
            x = ( x / mouse( )\steps ) * mouse( )\steps
          EndIf
          If y <> #PB_Ignore
            y + ( y % mouse( )\steps )
            y = ( y / mouse( )\steps ) * mouse( )\steps
          EndIf
          If width <> #PB_Ignore
            width + ( width % mouse( )\steps )
            width = (( width / mouse( )\steps ) * mouse( )\steps ) + DesktopScaled(1)
          EndIf
          If height <> #PB_Ignore
            height + ( height % mouse( )\steps )
            height = (( height / mouse( )\steps ) * mouse( )\steps ) + DesktopScaled(1)
          EndIf
        EndIf
        
        ;\\ move boundaries
        If *this\bounds\move
          If x <> #PB_Ignore
            If *this\bounds\move\min\x <> #PB_Ignore And
               x < *this\bounds\move\min\x
              If width <> #PB_Ignore
                width - ( *this\bounds\move\min\x - x )
              EndIf
              x = *this\bounds\move\min\x
            EndIf
            If *this\bounds\move\max\x <> #PB_Ignore
              If width <> #PB_Ignore
                If x > *this\bounds\move\max\x - width
                  x = *this\bounds\move\max\x - width
                EndIf
              Else
                If x > *this\bounds\move\max\x - *this\frame_width( )
                  x = *this\bounds\move\max\x - *this\frame_width( )
                EndIf
              EndIf
            EndIf
          EndIf
          If y <> #PB_Ignore
            If *this\bounds\move\min\y <> #PB_Ignore And
               y < *this\bounds\move\min\y
              If height <> #PB_Ignore
                height - ( *this\bounds\move\min\y - y )
              EndIf
              y = *this\bounds\move\min\y
            EndIf
            If *this\bounds\move\max\y <> #PB_Ignore
              If height <> #PB_Ignore
                If y > *this\bounds\move\max\y - height
                  y = *this\bounds\move\max\y - height
                EndIf
              Else
                If y > *this\bounds\move\max\y - *this\frame_height( )
                  y = *this\bounds\move\max\y - *this\frame_height( )
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ size boundaries
        If *this\bounds\size
          If *this\type = #__type_window
            Protected h_frame = *this\fs * 2 + *this\fs[1] + *this\fs[3]
            Protected v_frame = *this\fs * 2 + *this\fs[2] + *this\fs[4]
          EndIf
          
          If width <> #PB_Ignore
            If #PB_Ignore <> *this\bounds\size\min\width And
               width < *this\bounds\size\min\width - h_frame
              If x <> #PB_Ignore
                x + ( width - *this\bounds\size\min\width ) + h_frame
              EndIf
              width = *this\bounds\size\min\width - h_frame
            EndIf
            If #PB_Ignore <> *this\bounds\size\max\width And
               width > *this\bounds\size\max\width - h_frame
              If x <> #PB_Ignore
                x + ( width - *this\bounds\size\max\width ) + h_frame
              EndIf
              width = *this\bounds\size\max\width - h_frame
            EndIf
            
            ;\\
            If *this\bounds\move
              If x <> #PB_Ignore
                If width > *this\bounds\size\max\width - ( x - *this\bounds\move\min\x ) - h_frame
                  width = *this\bounds\size\max\width - ( x - *this\bounds\move\min\x ) - h_frame
                EndIf
              Else
                If width > *this\bounds\size\max\width - ( *this\container_x( ) - *this\bounds\move\min\x ) - h_frame
                  width = *this\bounds\size\max\width - ( *this\container_x( ) - *this\bounds\move\min\x ) - h_frame
                EndIf
              EndIf
            EndIf
          EndIf
          If height <> #PB_Ignore
            If #PB_Ignore <> *this\bounds\size\min\height And
               height < *this\bounds\size\min\height - v_frame
              If y <> #PB_Ignore
                y + ( height - *this\bounds\size\min\height ) + v_frame
              EndIf
              height = *this\bounds\size\min\height - v_frame
            EndIf
            If #PB_Ignore <> *this\bounds\size\max\height And
               height > *this\bounds\size\max\height - v_frame
              If y <> #PB_Ignore
                y + ( height - *this\bounds\size\max\height ) + v_frame
              EndIf
              height = *this\bounds\size\max\height - v_frame
            EndIf
            
            ;\\
            If *this\bounds\move
              If y <> #PB_Ignore
                If height > *this\bounds\size\max\height - ( y - *this\bounds\move\min\y ) - v_frame
                  height = *this\bounds\size\max\height - ( y - *this\bounds\move\min\y ) - v_frame
                EndIf
              Else
                If height > *this\bounds\size\max\height - ( *this\container_y( ) - *this\bounds\move\min\y ) - v_frame
                  height = *this\bounds\size\max\height - ( *this\container_y( ) - *this\bounds\move\min\y ) - v_frame
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If x = #PB_Ignore
          x = *this\container_x( )
        ElseIf *this\parent And *this\parent\container
          If Not *this\child
            x + *this\parent\scroll_x( )
          EndIf
          *this\container_x( ) = x
        EndIf
        If y = #PB_Ignore
          y = *this\container_y( )
        ElseIf *this\parent And *this\parent\container
          If Not *this\child
            y + *this\parent\scroll_y( )
          EndIf
          *this\container_y( ) = y
        EndIf
        
        ;\\
        If *this\parent And *this <> *this\parent And Not is_root_( *this )
          If Not ( *this\bounds\attach And *this\bounds\attach\mode = 2 )
            x + *this\parent\inner_x( )
          EndIf
          If Not ( *this\bounds\attach And *this\bounds\attach\mode = 1 )
            y + *this\parent\inner_y( )
          EndIf
        EndIf
        
        ;\\
        If width = #PB_Ignore
          If is_window_( *this )
            width = *this\container_width( )
          Else
            width = *this\frame_width( )
          EndIf
        EndIf
        If height = #PB_Ignore
          If is_window_( *this )
            height = *this\container_height( )
          Else
            height = *this\frame_height( )
          EndIf
        EndIf
        
        ;\\
        If width < 0
          width = 0
        EndIf
        If Height < 0
          Height = 0
        EndIf
        
        ;\\ потому что окну задаются внутренные размеры
        If is_window_( *this )
          width + ( *this\fs * 2 + *this\fs[1] + *this\fs[3] )
          Height + ( *this\fs * 2 + *this\fs[2] + *this\fs[4] )
        EndIf
      EndIf
      
      ;\\ inner x&y position
      ix      = x + ( *this\fs + *this\fs[1] )
      iy      = y + ( *this\fs + *this\fs[2] )
      iwidth  = width - ( *this\fs * 2 + *this\fs[1] + *this\fs[3] )
      iheight = height - ( *this\fs * 2 + *this\fs[2] + *this\fs[4] )
      
      ;\\
      If Not Change_x And *this\screen_x( ) <> x - ( *this\bs - *this\fs ) : Change_x = ( x - ( *this\bs - *this\fs )) - *this\screen_x( ) : EndIf
      If Not Change_y And *this\screen_y( ) <> y - ( *this\bs - *this\fs ) : Change_y = ( y - ( *this\bs - *this\fs )) - *this\screen_y( ) : EndIf
      If Not Change_width And *this\screen_width( ) <> width + ( *this\bs * 2 - *this\fs * 2 ) : Change_width = ( width + ( *this\bs * 2 - *this\fs * 2 )) - *this\screen_width( ) : EndIf
      If Not Change_height And *this\screen_height( ) <> height + ( *this\bs * 2 - *this\fs * 2 ) : Change_height = ( height + ( *this\bs * 2 - *this\fs * 2 )) - *this\screen_height( ) : EndIf
      
      If Not Change_x And *this\frame_x( ) <> x : Change_x = x - *this\frame_x( ) : EndIf
      If Not Change_y And *this\frame_y( ) <> y : Change_y = y - *this\frame_y( ) : EndIf
      If Not Change_width And *this\frame_width( ) <> width : Change_width = width - *this\frame_width( ) : EndIf
      If Not Change_height And *this\frame_height( ) <> height : Change_height = height - *this\frame_height( ) : EndIf
      
      If Not Change_x And *this\inner_x( ) <> ix : Change_x = ix - *this\inner_x( ) : EndIf
      If Not Change_y And *this\inner_y( ) <> iy : Change_y = iy - *this\inner_y( ) : EndIf
      If Not Change_width And *this\container_width( ) <> iwidth : Change_width = iwidth - *this\container_width( ) : EndIf
      If Not Change_height And *this\container_height( ) <> iheight : Change_height = iheight - *this\container_height( ) : EndIf
      ;          If Not Change_width And *this\inner_width( ) <> iwidth : Change_width = iwidth - *this\inner_width( ) : EndIf
      ;          If Not Change_height And *this\inner_height( ) <> iheight : Change_height = iheight - *this\inner_height( ) : EndIf
      
      
      ;\\
      If Change_x
        *this\resize\x = Change_x
        *this\frame_x( )  = x
        *this\inner_x( )  = ix
        *this\screen_x( ) = x - ( *this\bs - *this\fs )
        If *this\window
          *this\x[#__c_window] = x - *this\window\inner_x( )
        EndIf
      EndIf
      If Change_y
        *this\resize\y = Change_y
        *this\frame_y( )  = y
        *this\inner_y( )  = iy
        *this\screen_y( ) = y - ( *this\bs - *this\fs )
        If *this\window
          *this\y[#__c_window] = y - *this\window\inner_y( )
        EndIf
      EndIf
      If Change_width
        *this\resize\width = Change_width
        *this\frame_width( )     = width
        *this\container_width( ) = iwidth
        *this\screen_width( )    = width + ( *this\bs * 2 - *this\fs * 2 )
        If *this\container_width( ) < 0
          *this\container_width( ) = 0
        EndIf
        *this\inner_width( ) = *this\container_width( )
      EndIf
      If Change_height
        *this\resize\height = Change_height
        *this\frame_height( )     = height
        *this\container_height( ) = iheight
        *this\screen_height( )    = height + ( *this\bs * 2 - *this\fs * 2 )
        If *this\container_height( ) < 0
          *this\container_height( ) = 0
        EndIf
        *this\inner_height( ) = *this\container_height( )
      EndIf
      
      ;\\
      If ( Change_x Or Change_y Or Change_width Or Change_height )
        If ( Change_width Or Change_height )
          If *this\type = #__type_Image Or
             *this\type = #__type_ButtonImage
            *this\image\ImageChange( ) = 1
          EndIf
        EndIf
        
        ;\\
        *this\resize\clip = #True
        *this\root\repaint = #True
        
        
        
        ;\\ if the widgets is composite
        If *this\StringBox( )
          Resize( *this\StringBox( ), 0, 0, *this\inner_width( ), *this\inner_height( ) )
        EndIf
        
        ;\\ resize vertical&horizontal scrollbars
        If *this\scroll And
           *this\scroll\v And
           *this\scroll\h
          
          ;\\ if the integral scroll bars
          If *this\type = #__type_ScrollArea
            bar_area_resize( *this, 0, 0, *this\container_width( ), *this\container_height( ) )
          EndIf
        EndIf
        
        ;\\
        If *this\parent And
           *this\parent\scroll And
           *this\parent\scroll\v And
           *this\parent\scroll\h
          ;
          ;\\ parent mdi
          If *this\parent\type = #__type_MDI
          Else
            If is_integral_( *this )
              If *this\parent\container_width( ) = *this\parent\inner_width( ) And
                 *this\parent\container_height( ) = *this\parent\inner_height( )
                ; Debug ""+*this\parent\scroll\v\bar\max +" "+ *this\parent\scroll\v\bar\page\len +" "+ *this\parent\scroll\h\bar\max +" "+ *this\parent\scroll\h\bar\page\len
                
                If *this\parent\scroll\v\bar\max > *this\parent\scroll\v\bar\page\len Or
                   *this\parent\scroll\h\bar\max > *this\parent\scroll\h\bar\page\len
                  
                  bar_area_resize( *this\parent, 0, 0, *this\parent\container_width( ), *this\parent\container_height( ) )
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ if the integral tab bar
        If *this\TabBox( )
          ;If *this\container
          ;;Debug ""+*this\class +" "+ x
          *this\inner_x( ) = x ; - *this\fs - *this\fs[1]
          *this\inner_y( ) = y ; - *this\fs - *this\fs[2]
          
          ;\\
          If *this\TabBox( )\autosize
            Resize( *this\TabBox( ), 0, 0, *this\inner_width( ), *this\inner_height( ) )
          Else
            If *this\TabBox( )\bar\vertical
              If *this\fs[1]
                Resize( *this\TabBox( ), *this\fs, *this\fs, *this\fs[1], *this\inner_height( ) )
              EndIf
              If *this\fs[3]
                Resize( *this\TabBox( ), *this\frame_width( ) - *this\fs[3], *this\fs, *this\fs[3], *this\inner_height( ) )
              EndIf
            Else
              If *this\fs[2]
                Resize( *this\TabBox( ), *this\fs, *this\fs + *this\barHeight, *this\inner_width( ), *this\fs[2] - *this\barHeight - 1 )
              EndIf
              If *this\fs[4]
                Resize( *this\TabBox( ), *this\fs, *this\frame_height( ) - *this\fs[4], *this\inner_width( ), *this\fs[4] )
              EndIf
            EndIf
          EndIf
          
          *this\inner_x( ) + *this\fs + *this\fs[1]
          *this\inner_y( ) + *this\fs + *this\fs[2]
          ;EndIf
        EndIf
        
        ;\\
        If *this\type = #__type_ComboBox
          If *this\StringBox( )
            *this\ComboButton( )\width = *this\fs[3]
            *this\ComboButton( )\x     = ( *this\x + *this\width ) - *this\fs[3]
          Else
            *this\ComboButton( )\width = *this\inner_width( )
            *this\ComboButton( )\x     = *this\inner_x( )
          EndIf
          
          *this\ComboButton( )\y      = *this\inner_y( )
          *this\ComboButton( )\height = *this\inner_height( )
        EndIf
        
        ;\\
        If *this\bar    
          If *this\type = #__type_Splitter   
            bar_Update( *this, 2 )
          Else
            If *this\bar\max
              bar_Update( *this, 1 )
            EndIf
          EndIf
        EndIf
        
        ;\\
        If *this\type = #__type_Window
          ; чтобы закруглять только у окна с титлебаром
          If *this\fs[2]
            If *this\round
              *this\caption\round = *this\round
              *this\round         = 0
            EndIf
          EndIf
          
          ; caption title bar
          If Not *this\caption\hide
            *this\caption\x      = *this\frame_x( ) + *this\fs
            *this\caption\y      = *this\frame_y( ) + *this\fs
            *this\caption\width  = *this\frame_width( ) - *this\fs * 2
            *this\caption\height = *this\barHeight + *this\fs - 1
            
            If *this\caption\height > *this\frame_height( ) - *this\fs ;*2
              *this\caption\height = *this\frame_height( ) - *this\fs  ;*2
            EndIf
            
            ; caption close button
            If Not *this\CloseButton( )\hide
              *this\CloseButton( )\x = ( *this\caption\x + *this\caption\width ) - ( *this\CloseButton( )\width + *this\caption\_padding )
              *this\CloseButton( )\y = *this\frame_y( ) + ( *this\caption\height - *this\CloseButton( )\height ) / 2
            EndIf
            
            ; caption maximize button
            If Not *this\MaximizeButton( )\hide
              If *this\CloseButton( )\hide
                *this\MaximizeButton( )\x = ( *this\caption\x + *this\caption\width ) - ( *this\MaximizeButton( )\width + *this\caption\_padding )
              Else
                *this\MaximizeButton( )\x = *this\CloseButton( )\x - ( *this\MaximizeButton( )\width + *this\caption\_padding )
              EndIf
              *this\MaximizeButton( )\y = *this\frame_y( ) + ( *this\caption\height - *this\MaximizeButton( )\height ) / 2
            EndIf
            
            ; caption minimize button
            If Not *this\MinimizeButton( )\hide
              If *this\MaximizeButton( )\hide
                *this\MinimizeButton( )\x = *this\CloseButton( )\x - ( *this\MinimizeButton( )\width + *this\caption\_padding )
              Else
                *this\MinimizeButton( )\x = *this\MaximizeButton( )\x - ( *this\MinimizeButton( )\width + *this\caption\_padding )
              EndIf
              *this\MinimizeButton( )\y = *this\frame_y( ) + ( *this\caption\height - *this\MinimizeButton( )\height ) / 2
            EndIf
            
            ; caption help button
            If Not *this\HelpButton( )\hide
              If Not *this\MinimizeButton( )\hide
                *this\HelpButton( )\x = *this\MinimizeButton( )\x - ( *this\HelpButton( )\width + *this\caption\_padding )
              ElseIf Not *this\MaximizeButton( )\hide
                *this\HelpButton( )\x = *this\MaximizeButton( )\x - ( *this\HelpButton( )\width + *this\caption\_padding )
              Else
                *this\HelpButton( )\x = *this\CloseButton( )\x - ( *this\HelpButton( )\width + *this\caption\_padding )
              EndIf
              *this\HelpButton( )\y = *this\CloseButton( )\y
            EndIf
            
            ; title bar width
            If Not *this\HelpButton( )\hide
              *this\caption\width = *this\HelpButton( )\x - *this\caption\x - *this\caption\_padding
            ElseIf Not *this\MinimizeButton( )\hide
              *this\caption\width = *this\MinimizeButton( )\x - *this\caption\x - *this\caption\_padding
            ElseIf Not *this\MaximizeButton( )\hide
              *this\caption\width = *this\MaximizeButton( )\x - *this\caption\x - *this\caption\_padding
            ElseIf Not *this\CloseButton( )\hide
              *this\caption\width = *this\CloseButton( )\x - *this\caption\x - *this\caption\_padding
            EndIf
          EndIf
        EndIf
        
        ;         ;\\
        ;         If Popup( ) And
        ;            Popup( )\root = *this
        ;           Resize( Popup( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        ;         EndIf
        
        ;\\
        If *this\type = #__type_ScrollArea
          If IsGadget(*this\scroll\gadget[1])
            ResizeGadget(*this\scroll\gadget[1], DesktopUnscaledX(*this\inner_x( )), DesktopUnscaledY(*this\inner_y( )), DesktopUnscaledX(*this\inner_width( )), DesktopUnscaledY(*this\inner_height( )))
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              UpdateWindow_(GadgetID(*this\scroll\gadget[1]))
            CompilerEndIf
          EndIf
        EndIf
        
        ;
        ;\\ Post Event
        If *this\resize\send
          Send( *this, #__event_resize )
        EndIf
        
        ;-\\ children's resize
        ;\\ then move and size parent
        ;\\ resize all children's
        If Not *this\resize\nochildren 
          If *this\haschildren 
            If *this\type <> #__type_Splitter
              ;Debug *this\class
              ; If Not mouse( )\press
              Protected pw, ph
              
              If StartEnumerate( *this )
                If widget( )\parent <> *this
                  widget( )\resize\clip = #True
                  Continue
                EndIf
                ;
                If Not is_scrollbars_( widget( ))
                  If widget( )\align
                    ;\\
                    If widget( )\parent\align
                      pw = ( widget( )\parent\inner_width( ) - widget( )\parent\align\width )
                      ph = ( widget( )\parent\inner_height( ) - widget( )\parent\align\height )
                    EndIf
                    
                    ;\\
                    ;\\ horizontal
                    ;\\
                    If widget( )\align\left > 0
                      x = widget( )\align\x
                      If widget( )\align\right < 0
                        If widget( )\align\left = 0
                          x + pw / 2
                        EndIf
                        width = (( widget( )\align\x + widget( )\align\width ) + pw / 2 ) - x
                      EndIf
                    EndIf
                    If Not widget( )\align\right
                      width = widget( )\align\width
                      
                      If Not widget( )\align\left
                        x = widget( )\align\x
                        If widget( )\align\left = 0
                          x + pw / 2
                        EndIf
                        width = (( widget( )\align\x + widget( )\align\width ) + pw / 2 ) - x
                      EndIf
                    EndIf
                    If widget( )\align\right > 0
                      x = widget( )\align\x
                      If widget( )\align\left < 0
                        ;\\ ( left = proportional & right = 1 )
                        x     = widget( )\align\x + pw / 2
                        width = (( widget( )\align\x + widget( )\align\width ) + pw ) - x
                      Else
                        If widget( )\align\left = 0
                          x + pw
                        EndIf
                        width = (( widget( )\align\x + widget( )\align\width ) + pw ) - x
                      EndIf
                    EndIf
                    ;\\ horizontal proportional
                    If ( widget( )\align\left < 0 And widget( )\align\right <= 0 ) Or
                       ( widget( )\align\right < 0 And widget( )\align\left <= 0 )
                      Protected ScaleX.f = widget( )\parent\inner_width( ) / widget( )\parent\align\width
                      width = ScaleX * widget( )\align\width
                      ;\\ center proportional
                      If widget( )\align\left < 0 And widget( )\align\right < 0
                        x = ( widget( )\parent\inner_width( ) - width ) / 2
                      ElseIf widget( )\align\left < 0 And widget( )\align\right = 0
                        ;\\ right proportional
                        x = widget( )\parent\inner_width( ) - ( widget( )\parent\align\width - widget( )\align\x - widget( )\align\width ) - width
                      ElseIf ( widget( )\align\right < 0 And widget( )\align\left = 0 )
                        ;\\ left proportional
                        x = widget( )\align\x
                      EndIf
                    EndIf
                    
                    ;\\
                    ;\\ vertical
                    ;\\
                    If widget( )\align\top > 0
                      y = widget( )\align\y
                      If widget( )\align\bottom < 0
                        If widget( )\align\top = 0
                          y + ph / 2
                        EndIf
                        height = (( widget( )\align\y + widget( )\align\height ) + ph / 2 ) - y
                      EndIf
                    EndIf
                    If Not widget( )\align\bottom
                      height = widget( )\align\height
                      
                      If Not widget( )\align\top
                        y = widget( )\align\y
                        If widget( )\align\top = 0
                          y + ph / 2
                        EndIf
                        height = (( widget( )\align\y + widget( )\align\height ) + ph / 2 ) - y
                      EndIf
                    EndIf
                    If widget( )\align\bottom > 0
                      y = widget( )\align\y
                      If widget( )\align\top < 0
                        ;\\ ( top = proportional & bottom = 1 )
                        y      = widget( )\align\y + ph / 2
                        height = (( widget( )\align\y + widget( )\align\height ) + ph ) - y
                      Else
                        If widget( )\align\top = 0
                          y + ph
                        EndIf
                        height = (( widget( )\align\y + widget( )\align\height ) + ph ) - y
                      EndIf
                    EndIf
                    ;\\ vertical proportional
                    If ( widget( )\align\top < 0 And widget( )\align\bottom <= 0 ) Or
                       ( widget( )\align\bottom < 0 And widget( )\align\top <= 0 )
                      Protected ScaleY.f = widget( )\parent\inner_height( ) / widget( )\parent\align\height
                      height = ScaleY * widget( )\align\height
                      ;\\ center proportional
                      If widget( )\align\top < 0 And widget( )\align\bottom < 0
                        y = ( widget( )\parent\inner_height( ) - height ) / 2
                      ElseIf widget( )\align\top < 0 And widget( )\align\bottom = 0
                        ;\\ bottom proportional
                        y = widget( )\parent\inner_height( ) - ( widget( )\parent\align\height - widget( )\align\y - widget( )\align\height ) - height
                      ElseIf ( widget( )\align\bottom < 0 And widget( )\align\top = 0 )
                        ;\\ top proportional
                        y = widget( )\align\y
                      EndIf
                    EndIf
                    
                    
                    Resize( widget( ), DesktopUnscaledX(x), DesktopUnscaledY(y), DesktopUnscaledX(width), DesktopUnscaledY(height) )
                  Else
                    Resize( widget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                  EndIf
                EndIf
                ;
                StopEnumerate( )
              EndIf
              
            EndIf
          EndIf
        EndIf
      Else
        If *this\resize\clip <> #True
          *this\resize\clip = #True
        EndIf
      EndIf
      
      ;
      ;;;PostRepaint( *this\root )
      ProcedureReturn *this\root\repaint
    EndProcedure
    
    
    ;-
    ;-  BARs
    ; Farbaddition
    Procedure.i TabBarGadget_ColorPlus(Color.i, Plus.i) ; Code OK
      
      If Color & $FF + Plus & $FF < $FF
        Color + Plus & $FF
      Else
        Color | $FF
      EndIf
      If Color & $FF00 + Plus & $FF00 < $FF00
        Color + Plus & $FF00
      Else
        Color | $FF00
      EndIf
      If Color & $FF0000 + Plus & $FF0000 < $FF0000
        Color + Plus & $FF0000
      Else
        Color | $FF0000
      EndIf
      
      ProcedureReturn Color
      
    EndProcedure
    
    ; Farbsubtraktion
    Procedure.i TabBarGadget_ColorMinus(Color.i, Minus.i) ; Code OK
      
      If Color & $FF - Minus & $FF > 0
        Color - Minus & $FF
      Else
        Color & $FFFFFF00
      EndIf
      If Color & $FF00 - Minus & $FF00 > 0
        Color - Minus & $FF00
      Else
        Color & $FFFF00FF
      EndIf
      If Color & $FF0000 - Minus & $FF0000 > 0
        Color - Minus & $FF0000
      Else
        Color & $FF00FFFF
      EndIf
      
      ProcedureReturn Color
      
    EndProcedure
    
    
    
    ;{
    Macro bar_in_start_( _bar_ )
      Bool( _bar_\area\pos >= _bar_\thumb\pos )
    EndMacro
    
    Macro bar_in_stop_( _bar_ )
      Bool( _bar_\thumb\pos >= _bar_\area\end ) 
    EndMacro
    
    ;       Macro bar_page_in_stop_( _bar_ )
    ;          Bool( _bar_\page\pos >= _bar_\page\end - _bar_\min[2] ) ;
    ;       EndMacro
    
    ;       Macro bar_page_in_start_( _bar_ )
    ;          Bool( _bar_\page\pos <= _bar_\min + _bar_\min[1] ) ;
    ;       EndMacro
    
    Macro bar_page_pos_( _bar_, _thumb_pos_ )
      ( _bar_\min + Round((( _thumb_pos_ ) - _bar_\area\pos ) / _bar_\percent, #PB_Round_Nearest ))
    EndMacro
    
    Macro bar_thumb_pos_( _bar_, _scroll_pos_ )
      Round((( _scroll_pos_ ) - _bar_\min - _bar_\min[1] ) * _bar_\percent, #PB_Round_Nearest )
    EndMacro
    
    Macro bar_scroll_pos_( _this_, _pos_, _len_ )
      Bool( Bool(((( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) < 0 And bar_PageChange( _this_, (( _pos_ ) + _this_\bar\min ) )) Or
            Bool(((( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) > ( _this_\bar\page\len - ( _len_ )) And bar_PageChange( _this_, (( _pos_ ) + _this_\bar\min ) - ( _this_\bar\page\len - ( _len_ ) ))) )
    EndMacro
    
    Macro bar_invert_page_pos_( _bar_, _scroll_pos_ )
      ( Bool( Not _bar_\invert ) * ( _scroll_pos_ ) +
        Bool( _bar_\invert ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min )) )
    EndMacro
    
    ;-
    Procedure bar_tab_AddItem( *this._s_WIDGET, Item.i, Text.s, Image.i = -1, sublevel.i = 0 )
    EndProcedure
    
    Procedure.i bar_tab_SetState( *this._s_WIDGET, item.l )
    EndProcedure
    
    Procedure.i bar_tab_RemoveItem( *this._s_WIDGET, Item.l )
    EndProcedure
    
    Procedure bar_tab_ClearItems( *this._s_WIDGET ) ; Ok
    EndProcedure
    
    Procedure.s bar_tab_GetItemText( *this._s_WIDGET, Item.l, Column.l = 0 )
    EndProcedure
    
    Procedure.b bar_tab_UpdateItems( *this._s_WIDGET, List *tabs._s_ITEMS( ) )
    EndProcedure
    
    ;-
    Macro bar_draw_item_( _vertical_, _address_, _x_, _y_, _round_, _mode_, _flag_ = 1 )
      ; Draw back
      If _flag_ = 1
        draw_mode_alpha_( #PB_2DDrawing_Gradient )
        draw_gradientbox_( 0, _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _address_\color\fore#_mode_, _address_\color\back#_mode_, _round_, _address_\AlphaState( ) )
      EndIf
      ;
      ; Draw items image
      If _address_\image\id
        draw_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawAlphaImage( _address_\image\id, _x_ + _address_\image\x, _y_ + _address_\image\y, _address_\ColorAlphaState( ) )
      EndIf
      ;
      ; Draw items text
      If _address_\text\string
        draw_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawText( _x_ + _address_\text\x, _y_ + _address_\text\y, _address_\text\string, _address_\color\front#_mode_ & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
      
      If _vertical_ > 0
        If _address_\childrens
          DrawText( _x_ + _address_\text\x + _address_\text\width + 20, _y_ + _address_\text\y, ">", _address_\color\front#_mode_ & $FFFFFF | _address_\AlphaState24( ) )
        EndIf
      EndIf
      ;          
      ; Draw frame
      If _flag_ = 1
        draw_mode_alpha_( #PB_2DDrawing_Outlined )
        draw_roundbox_( _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _round_, _round_, _address_\color\frame#_mode_ & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
    EndMacro
    
    Procedure bar_draw_tabitems( *this._s_WIDGET, vertical, x,y, round, List *tabs._s_ITEMS( ) )
      Protected._s_BAR *bar = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *bar\button
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      ; draw all visible items
      ForEach *tabs( )
        If *tabs( )\hide 
          *tabs( )\visible = 0
          Continue
        EndIf
        ;
        draw_font( *tabs( ) )
        
        ; real visible items
        If vertical
          *tabs( )\visible = Bool( (( y + *tabs( )\y + *tabs( )\height ) > *this\inner_y( ) And
                                    ( y + *tabs( )\y ) < ( *this\inner_y( ) + *this\inner_height( ) ) ))
        Else
          *tabs( )\visible = Bool( (( x + *tabs( )\x + *tabs( )\width ) > *this\inner_x( ) And
                                    ( x + *tabs( )\x ) < ( *this\inner_x( ) + *this\inner_width( ) ) ))
        EndIf
        ;
        ; Draw seperator
        ;no &~ entered &~ focused
        If *tabs( )\visible 
          If *tabs( )\itemindex = #PB_Ignore
            draw_roundbox_( x + *tabs( )\x, y + *tabs( )\y, *tabs( )\width, *tabs( )\height, 0, 0, *tabs( )\color\frame[0] & $FFFFFF | *tabs( )\AlphaState24( ) )
          Else
            If is_menu_( *this )
              If BinaryFlag( *this\flag, #PB_ToolBar_InlineText )
                If *tabs( )\image\id
                  If *this\bar\vertical
                    draw_mode_alpha_( #PB_2DDrawing_Default )
                    draw_roundbox_(x + *tabs( )\x,
                                   y + *tabs( )\y - Bool( ListIndex( *tabs( ) ))*3, 
                                   *tabs( )\image\width + 10,
                                   *tabs( )\height + Bool( ListIndex( *tabs( ) ))*3 + Bool( ListIndex( *tabs( ) ) <> *this\countitems - 1 )*3, 
                                   *this\round, *this\round, $FFF0F0F0 )
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;\\
            If *tabs( )\toggle
              bar_draw_item_( *this\bar\vertical, *tabs( ), x, y, round, [2] )
            Else
              If *tabs( ) <> *this\TabFocused( ) And 
                 *tabs( ) <> *this\TabEntered( )
                ;                     ;
                ;Debug ""+*BB1\hide +" "+ Str( *BB1\x ) +" "+ Str( x + *tabs( )\x ) +" - "+ *SB\width
                ;Debug ""+*BB2\hide +" "+ Str( *BB2\x ) +" "+ Str( x + *tabs( )\x )
                ;                         
                ;                         If (( *BB2\x + *BB2\width < x + *tabs( )\x ) Or ( *BB2\hide And *BB2\x + *BB2\width > x + *tabs( )\x )) Or
                ;                            (( *BB1\x > x + *tabs( )\x + *tabs( )\width ) Or ( *BB1\hide And *BB1\x < x + *tabs( )\x + *tabs( )\width )) 
                bar_draw_item_( *this\bar\vertical, *tabs( ), x, y, round, [0],
                                Bool( Not( ( *this\type = #__type_ToolBarBar Or 
                                             *this\type = #__type_MenuBar ) And
                                           Not BinaryFlag( *this\flag, #PB_Toolbar_Buttons ))) )
                ;                         EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      Next
      ;
      ; draw mouse-enter visible item
      If *this\TabEntered( ) <> *this\TabFocused( )
        If *this\TabEntered( ) And
           *this\TabEntered( )\toggle = 0 And
           *this\TabEntered( )\visible 
          ;
          If *this\TabEntered( )\itemindex <> #PB_Ignore
            draw_font( *this\TabEntered( ) )
            bar_draw_item_( *this\bar\vertical, *this\TabEntered( ), x, y, round, [*this\TabEntered( )\ColorState( )] )
          EndIf
        EndIf
      EndIf
      
      ;
      ; draw key-focus visible item
      If *this\TabFocused( ) And
         *this\TabFocused( )\visible
        Protected._s_ITEMS *activeTAB = *this\TabFocused( )
        ;   
        If *this\TabFocused( )\itemindex <> #PB_Ignore
          draw_font( *this\TabFocused( ) )
          ;
          If *this\child 
            If *this\parent
              If Not *this\TabFocused( )\press
                draw_mode_alpha_( #PB_2DDrawing_Default )
                draw_roundbox_( x + *this\TabFocused( )\x,
                                y + *this\TabFocused( )\y,
                                *this\TabFocused( )\width,
                                *this\TabFocused( )\height,
                                *this\round, *this\round,
                                *this\parent\color\back )
              EndIf
            EndIf
            
            bar_draw_item_( *this\bar\vertical, *this\TabFocused( ), x, y, round, [0], 0 )
            
          Else
            ;
            bar_draw_item_( *this\bar\vertical, *this\TabFocused( ), x, y, round, [2] )
          EndIf
        EndIf
      EndIf
      
      ; draw focus-item frame
      If *this\child
        If *this\parent
          Protected color = *this\parent\color\frame
          If *this\parent\focus >= 0 
            color = *this\parent\color\frame[*this\parent\focus]
          EndIf
          
          If *bar\vertical
            If *activeTAB And 
               *activeTAB\visible
              ; frame on the selected item
              If *this\parent\fs[1]
                Line( x + *activeTAB\x, y + *activeTAB\y, 1, *activeTAB\height, color )
                Line( x + *activeTAB\x + 1, y + *activeTAB\y, 1, *activeTAB\height, color )
                Line( x + *activeTAB\x + 2, y + *activeTAB\y, 1, *activeTAB\height, color )
              ElseIf *this\parent\fs[3]
                Line( x + *activeTAB\x + *activeTAB\width -1-2, y + *activeTAB\y, 1, *activeTAB\height, color )
                Line( x + *activeTAB\x + *activeTAB\width -1-1, y + *activeTAB\y, 1, *activeTAB\height, color )
                Line( x + *activeTAB\x + *activeTAB\width -1, y + *activeTAB\y, 1, *activeTAB\height, color )
              EndIf
              Line( x + *activeTAB\x, y + *activeTAB\y, *activeTAB\width - *activeTAB\x - Bool(*this\parent\fs[3]), 1, color )
              Line( x + *activeTAB\x, y + *activeTAB\y + *activeTAB\height - 1, *activeTAB\width - *activeTAB\x - Bool(*this\parent\fs[3]), 1, color )
              ;
              If *this\type = #__type_MenuBar
                Line( x + *activeTAB\x + *activeTAB\width - 1, y + *activeTAB\y, 1, *activeTAB\height, color )
              EndIf
            EndIf
            ;
            If *this\type = #__type_TabBarBar
              ;                      color = *this\parent\color\frame
              ;                      ;
              ;                      If *this\parent\fs[1]
              ;                         If *activeTAB
              ;                            ; horizontal tab bottom line
              ;                            Line( *this\frame_x( ) + *this\frame_width( ) - 1, *this\frame_y( ), 1, ( y + *activeTAB\y ) - *this\frame_y( ), color ) 
              ;                            Line( *this\frame_x( ) + *this\frame_width( ) - 1, y + *activeTAB\y + *activeTAB\height, 1, *this\frame_y( ) + *this\frame_height( ) - ( y + *activeTAB\y + *activeTAB\height ), color )
              ;                         Else
              ;                            Line( *this\frame_x( ) + *this\frame_width( ) - 1, *this\frame_y( ), 1, *this\frame_height( ), color )
              ;                         EndIf
              ;                      Else
              ;                         Line( *this\parent\frame_x( ), *this\parent\frame_y( ), 1, *this\parent\frame_height( ), color )
              ;                      EndIf
              ;                      
              ;                      ;
              ;                      Line( *this\parent\inner_x( ) - 1, *this\parent\frame_y( ), *this\parent\inner_width( ) + 2, 1, color )
              ;                      Line( *this\parent\inner_x( ) - 1, *this\parent\frame_y( ) + *this\parent\frame_height( ) - 1, *this\parent\inner_width( ) + 2, 1, color )
              ;                      
              ;                      If *this\parent\fs[3]
              ;                         If *activeTAB 
              ;                            ; horizontal tab bottom line
              ;                            Line( *this\frame_x( ) - 1, *this\frame_y( ), 1, ( y + *activeTAB\y ) - *this\frame_y( ), color ) 
              ;                            Line( *this\frame_x( ) - 1, y + *activeTAB\y + *activeTAB\height, 1, *this\frame_y( ) + *this\frame_height( ) - ( y + *activeTAB\y + *activeTAB\height ), color )
              ;                         Else
              ;                            Line( *this\frame_x( ) - 1, *this\frame_y( ), 1, *this\frame_height( ), color )
              ;                         EndIf
              ;                      Else
              ;                         Line( *this\parent\frame_x( ) + *this\parent\frame_width( ) - 1, *this\parent\frame_y( ), 1, *this\parent\frame_height( ), color )
              ;                      EndIf
            EndIf
            
          Else
            If *activeTAB And 
               *activeTAB\visible
              ; frame on the selected item
              If *this\parent\fs[2]
                Line( x + *activeTAB\x, y + *activeTAB\y, *activeTAB\width, 1, color )
                Line( x + *activeTAB\x, y + *activeTAB\y + 1, *activeTAB\width, 1, color )
                Line( x + *activeTAB\x, y + *activeTAB\y + 2, *activeTAB\width, 1, color )
              ElseIf *this\parent\fs[4]
                Line( x + *activeTAB\x, y + *activeTAB\height + *activeTAB\y -1-2, *activeTAB\width, 1, color )
                Line( x + *activeTAB\x, y + *activeTAB\height + *activeTAB\y -1-1, *activeTAB\width, 1, color )
                Line( x + *activeTAB\x, y + *activeTAB\height + *activeTAB\y -1, *activeTAB\width, 1, color )
              EndIf
              Line( x + *activeTAB\x, y + *activeTAB\y, 1, *activeTAB\height - *activeTAB\y - Bool(*this\parent\fs[4]), color )
              Line( x + *activeTAB\x + *activeTAB\width - 1, y + *activeTAB\y, 1, *activeTAB\height - *activeTAB\y - Bool(*this\parent\fs[4]), color )
              ;
              If *this\type = #__type_MenuBar
                Line( x + *activeTAB\x, y + *activeTAB\y + *activeTAB\height - 1, *activeTAB\width, 1, color )
              EndIf
            EndIf
            ;
            If *this\type = #__type_TabBarBar
              ;                      color = *this\parent\color\frame
              ;                      ;
              ;                      If *this\parent\fs[2]
              ;                         If *activeTAB 
              ;                            ; horizontal tab bottom line
              ;                            Line( *this\frame_x( ), *this\frame_y( ) + *this\frame_height( ) - 1, ( x + *activeTAB\x ) - *this\frame_x( ), 1, color ) 
              ;                            Line( x + *activeTAB\x + *activeTAB\width, *this\frame_y( ) + *this\frame_height( ) - 1, *this\frame_x( ) + *this\frame_width( ) - ( x + *activeTAB\x + *activeTAB\width ), 1, color )
              ;                         Else
              ;                            Line( *this\frame_x( ), *this\frame_y( ) + *this\frame_height( ) - 1, *this\frame_width( ), 1, color )
              ;                         EndIf
              ;                      Else
              ;                         Line( *this\parent\frame_x( ), *this\parent\frame_y( ), *this\parent\frame_width( ), 1, color )
              ;                      EndIf
              ;                      
              ;                      ;
              ;                      Line( *this\parent\frame_x( ), *this\parent\inner_y( ) - 1, 1, *this\parent\inner_height( ) + 2, color )
              ;                      Line( *this\parent\frame_x( ) + *this\parent\frame_width( ) - 1, *this\parent\inner_y( ) - 1, 1, *this\parent\inner_height( ) + 2, color )
              ;                      
              ;                      
              ;                      If *this\parent\fs[4]
              ;                         If *activeTAB 
              ;                            ; horizontal tab bottom line
              ;                            Line( *this\frame_x( ), *this\frame_y( ) - 1, ( x + *activeTAB\x ) - *this\frame_x( ), 1, color ) 
              ;                            Line( x + *activeTAB\x + *activeTAB\width, *this\frame_y( ) - 1, *this\frame_x( ) + *this\frame_width( ) - ( x + *activeTAB\x + *activeTAB\width ), 1, color )
              ;                         Else
              ;                            Line( *this\frame_x( ), *this\frame_y( ) - 1, *this\frame_width( ), 1, color )
              ;                         EndIf
              ;                      Else
              ;                         Line( *this\parent\frame_x( ), *this\parent\frame_y( ) + *this\parent\frame_height( ) - 1, *this\parent\frame_width( ), 1, color )
              ;                      EndIf
            EndIf
            
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.b bar_draw_tab( *this._s_WIDGET )
    EndProcedure
    
    Procedure.b bar_draw_scroll( *this._s_WIDGET )
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *bar\button
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      With *this
        
        If *this\AlphaState( )
          ; Draw scroll bar background
          If *this\color\back <> - 1
            draw_mode_alpha_( #PB_2DDrawing_Default )
            If *this\child
              If *bar\vertical
                draw_box_(*this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\parent\container_height( ), *this\color\back )
              Else
                draw_box_(*this\inner_x( ), *this\inner_y( ), *this\inner_width( ) - *this\round / 2, *this\inner_height( ), *this\color\back )
              EndIf
            Else
              draw_roundbox_(*this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), *this\round, *this\round, *this\color\back )
            EndIf
          EndIf
          
          ;
          ; background buttons draw
          If Not *BB1\hide
            If *BB1\color\fore <> - 1
              draw_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*bar\vertical, *BB1, *BB1\color\fore[*BB1\ColorState( )], *BB1\color\back[*BB1\ColorState( )] )
            Else
              draw_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(*BB1, color\back)
            EndIf
          EndIf
          If Not *BB2\hide
            If *BB2\color\fore <> - 1
              draw_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*bar\vertical, *BB2, *BB2\color\fore[*BB2\ColorState( )], *BB2\color\back[*BB2\ColorState( )] )
            Else
              draw_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(*BB2, color\back)
            EndIf
          EndIf
          
          draw_mode_alpha_( #PB_2DDrawing_Outlined )
          
          If *this\type = #__type_ScrollBar
            If *bar\vertical
              If (*bar\page\len + Bool(*this\round ) * (*this\width / 4 )) = *this\frame_height( )
                Line(*this\frame_x( ), *this\frame_y( ), 1, *bar\page\len + 1, *this\color\front & $FFFFFF | *this\AlphaState24( ) ) ; $FF000000 ) ;
              Else
                Line(*this\frame_x( ), *this\frame_y( ) + *BB1\round, 1, *this\height - *BB1\round - *BB2\round, *this\color\front & $FFFFFF | *this\AlphaState24( ) ) ; $FF000000 ) ;
              EndIf
            Else
              If (*bar\page\len + Bool(*this\round ) * (*this\height / 4 )) = *this\frame_width( )
                Line(*this\frame_x( ), *this\frame_y( ), *bar\page\len + 1, 1, *this\color\front & $FFFFFF | *this\AlphaState24( ) ) ; $FF000000 ) ;
              Else
                Line(*this\frame_x( ) + *BB1\round, *this\frame_y( ), *this\frame_width( ) - *BB1\round - *BB2\round, 1, *this\color\front & $FFFFFF | *this\AlphaState24( ) ) ; $FF000000 ) ;
              EndIf
            EndIf
          EndIf
          
          ; frame buttons draw
          If Not *BB1\hide
            If *BB1\arrow\size
              draw_arrows( *BB1, Bool(*bar\vertical ))
            EndIf
            draw_box(*BB1, color\frame)
          EndIf
          If Not *BB2\hide
            If *BB2\arrow\size
              draw_arrows( *BB2, Bool(*bar\vertical ) + 2 )
            EndIf
            draw_box(*BB2, color\frame)
          EndIf
          
          
          If *bar\thumb\len And *this\type <> #__type_ProgressBar
            ; Draw thumb
            draw_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_(*bar\vertical, *SB, *SB\color\fore[*SB\ColorState( )], *SB\color\back[*SB\ColorState( )])
            
            If *SB\arrow\type ;*this\type = #__type_ScrollBar
              If *SB\arrow\size
                draw_mode_alpha_( #PB_2DDrawing_Default )
                draw_arrows( *SB, *SB\arrow\direction )
              EndIf
            Else
              ; Draw thumb lines
              draw_mode_alpha_( #PB_2DDrawing_Default )
              ;               FrontColor( *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
              ;               If *bar\vertical
              ;                 Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 - DesktopScaled(3), *SB\arrow\size, DesktopScaled(1))
              ;                 Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2, *SB\arrow\size, DesktopScaled(1))
              ;                 Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 + DesktopScaled(3), *SB\arrow\size, DesktopScaled(1))
              ;               Else
              ;                 Box(*SB\x + *SB\width / 2 - DesktopScaled(3), *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size)
              ;                 Box(*SB\x + *SB\width / 2, *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size)
              ;                 Box(*SB\x + *SB\width / 2 + DesktopScaled(3), *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size)
              ;               EndIf
              If *bar\vertical
                Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 - DesktopScaled(3), *SB\arrow\size, DesktopScaled(1), *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
                Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2, *SB\arrow\size, DesktopScaled(1), *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
                Box(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 + DesktopScaled(3), *SB\arrow\size, DesktopScaled(1), *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
              Else
                Box(*SB\x + *SB\width / 2 - DesktopScaled(3), *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size, *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
                Box(*SB\x + *SB\width / 2, *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size, *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
                Box(*SB\x + *SB\width / 2 + DesktopScaled(3), *SB\y + (*SB\height - *SB\arrow\size ) / 2, DesktopScaled(1), *SB\arrow\size, *SB\color\front[*SB\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
              EndIf
              
            EndIf
            
            ; Draw thumb frame
            draw_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_box(*SB, color\frame)
          EndIf
          
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure.b bar_draw_progress( *this._s_WIDGET )
      Macro DrawHLines( _start_x_, _start_y_, _stop_x_, _stop_y_ )
        For y1 = _start_y_ To _stop_y_
          For x1 = _start_x_ To _stop_x_
            If Point( *this\frame_x( ) + x1, *this\frame_y( ) + y1 ) & $FFFFFF = _frame_color_ & $FFFFFF
              Line( *this\frame_x( ) + x1, *this\frame_y( ) + y1, *this\frame_width( ) - x1 * 2, 1 )
              Break
            EndIf
          Next x1
        Next y1
      EndMacro
      
      Macro DrawVLines( _start_x_, _start_y_, _stop_x_, _stop_y_ )
        For x1 = _start_x_ To _stop_x_
          For y1 = _start_y_ To _stop_y_
            If Point( *this\frame_x( ) + x1, *this\frame_y( ) + y1 ) & $FFFFFF = _frame_color_ & $FFFFFF
              Line( *this\frame_x( ) + x1, *this\frame_y( ) + y1, 1, *this\frame_height( ) - y1 * 2 )
              Break
            EndIf
          Next y1
        Next x1
      EndMacro
      
      With *this
        Protected x1, y1, _position_, _frame_size_ = 1, _gradient_ = 1
        Protected *bar._s_BAR = *this\bar
        Protected _vertical_ = *bar\vertical
        Protected _reverse_ = *bar\invert
        Protected _round_ = *this\round
        Protected alpha = 230
        Protected _frame_color_ = $FF000000 ; *this\color\frame
        Protected _fore_color1_
        Protected _back_color1_
        Protected _fore_color2_
        Protected _back_color2_
        
        Protected state1 = Bool(Not *bar\invert) * #__s_2
        Protected state2 = Bool(*bar\invert) * #__s_2
        
        alpha         = 230
        _fore_color1_ = *this\color\fore[state1] & $FFFFFF | alpha << 24 ; $f0E9BA81 ;
        _back_color1_ = *this\color\back[state1] & $FFFFFF | alpha << 24 ; $f0E89C3D ;
        
        alpha - 15
        _fore_color2_ = *this\color\fore[state2] & $FFFFFF | alpha << 24 ; $e0F8F8F8 ;
        _back_color2_ = *this\color\back[state2] & $FFFFFF | alpha << 24 ; $e0E2E2E2 ;
        
        If _vertical_
          
          ;           if _reverse_
          ;             _position_ = *bar\thumb\pos
          ;           Else
          _position_ = *this\frame_height( ) - *bar\thumb\pos
          ;           EndIf
        Else
          ;           if _reverse_
          ;             _position_ = *this\frame_width( ) - *bar\thumb\pos
          ;           Else
          _position_ = *bar\thumb\pos
          ;           EndIf
          
        EndIf
        
        If _position_ < 0
          _position_ = 0
        EndIf
        
        ; Debug "_position_ "+_position_ +" "+ *bar\page\pos
        
        ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you x1nfratec
        ; FrontColor(_frame_color_) ; не работает
        draw_mode_alpha_(#PB_2DDrawing_Outlined)
        draw_roundbox_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _frame_size_, *this\frame_width( ) - _frame_size_ * 2, *this\frame_height( ) - _frame_size_ * 2, _round_, _round_, _frame_color_)
        ;   draw_roundbox_(*this\frame_x( ) + _frame_size_+1, *this\frame_y( ) + _frame_size_+1, *this\frame_width( ) - _frame_size_*2-2, *this\frame_height( ) - _frame_size_*2-2, _round_,_round_)
        ;   ; ;   draw_roundbox_(*this\frame_x( ) + _frame_size_+2, *this\frame_y( ) + _frame_size_+2, *this\frame_width( ) - _frame_size_*2-4, *this\frame_height( ) - _frame_size_*2-4, _round_,_round_)
        ;   ;
        ;   ;   For x1 = 0 To 1
        ;   ;     draw_roundbox_(*this\frame_x( ) + (_frame_size_+i), *this\frame_y( ) + (_frame_size_+i), *this\frame_width( ) - (_frame_size_+i)*2, *this\frame_height( ) - (_frame_size_+i)*2, _round_,_round_)
        ;   ;   Next
        
        If _gradient_
          draw_mode_alpha_( #PB_2DDrawing_Gradient )
          If _vertical_
            LinearGradient(*this\frame_x( ), *this\frame_y( ), (*this\frame_x( ) + *this\frame_width( )), *this\frame_y( ))
          Else
            LinearGradient(*this\frame_x( ), *this\frame_y( ), *this\frame_x( ), (*this\frame_y( ) + *this\frame_height( )))
          EndIf
        Else
          draw_mode_alpha_( #PB_2DDrawing_Default )
        EndIf
        
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If Not _round_
          If _vertical_
            draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _position_, *this\frame_width( ) - _frame_size_ * 2, (*this\frame_height( ) - _frame_size_ - _position_))
          Else
            draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _frame_size_, _position_ - _frame_size_, *this\frame_height( ) - _frame_size_ * 2)
          EndIf
        Else
          
          If _vertical_
            If (*this\frame_height( ) - _round_ - _position_) > _round_
              If *this\frame_height( ) > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > _position_
                  draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _position_ + (_round_ - _position_), *this\frame_width( ) - _frame_size_ * 2, (*this\frame_height( ) - _round_ - _position_) - (_round_ - _position_))
                Else
                  draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _position_, *this\frame_width( ) - _frame_size_ * 2, (*this\frame_height( ) - _round_ - _position_))
                EndIf
              EndIf
              
              ;\\
              DrawHLines( _frame_size_ , (*this\frame_height( ) - _round_), (*this\frame_width( ) - _frame_size_), (*this\frame_height( ) - _frame_size_))
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > _position_
                DrawHLines( _frame_size_ , _frame_size_ + _position_, (*this\frame_width( ) - _frame_size_), _round_)
              EndIf
              
            Else
              DrawHLines( _frame_size_ , _position_ - _frame_size_, (*this\frame_width( ) - _frame_size_), (*this\frame_height( ) - _frame_size_))
            EndIf
          Else
            If _position_ > _round_
              ; рисуем прямоуголную часть
              If *this\frame_width( ) > _round_ * 2
                If (*this\frame_width( ) - _position_) > _round_
                  draw_box_(*this\frame_x( ) + _round_, *this\frame_y( ) + _frame_size_, (_position_ - _round_) , *this\frame_height( ) - _frame_size_ * 2)
                Else
                  draw_box_(*this\frame_x( ) + _round_, *this\frame_y( ) + _frame_size_, (_position_ - _round_) + (*this\frame_width( ) - _round_ - _position_), *this\frame_height( ) - _frame_size_ * 2)
                EndIf
              EndIf
              
              ;\\
              DrawVLines( _frame_size_ , _frame_size_, _round_, (*this\frame_height( ) - _frame_size_ * 2))
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\frame_width( ) - _position_)
                DrawVLines( (*this\frame_width( ) - _frame_size_ - _round_), _frame_size_ , (_position_ - _frame_size_), (*this\frame_height( ) - _frame_size_ * 2))
              EndIf
              
            Else
              DrawVLines( _frame_size_ , _frame_size_, (_position_ + _frame_size_ - 1), (*this\frame_height( ) - _frame_size_ * 2))
            EndIf
          EndIf
          
        EndIf
        
        BackColor(_fore_color2_)
        FrontColor(_back_color2_)
        
        If Not _round_
          If _vertical_
            draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _frame_size_, *this\frame_width( ) - _frame_size_ * 2, _position_ - _frame_size_)
          Else
            draw_box_(*this\frame_x( ) + _position_, *this\frame_y( ) + _frame_size_, (*this\frame_width( ) - _frame_size_ - _position_), *this\frame_height( ) - _frame_size_ * 2)
          EndIf
        Else
          If _vertical_
            If _position_ > _round_
              If *this\frame_height( ) > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > (*this\frame_height( ) - _position_)
                  draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _round_, *this\frame_width( ) - _frame_size_ * 2, (_position_ - _round_) + (*this\frame_height( ) - _round_ - _position_))
                Else
                  draw_box_(*this\frame_x( ) + _frame_size_, *this\frame_y( ) + _round_, *this\frame_width( ) - _frame_size_ * 2, (_position_ - _round_))
                EndIf
              EndIf
              
              ;\\
              DrawHLines( _frame_size_ , _frame_size_, (*this\frame_width( ) - _frame_size_ * 2), _round_)
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\frame_height( ) - _position_)
                DrawHLines( _frame_size_ , (*this\frame_height( ) - _frame_size_ - _round_), (*this\frame_width( ) - _frame_size_ * 2), _position_ - _frame_size_)
              EndIf
              
            Else
              DrawHLines( _frame_size_ , _frame_size_, (*this\frame_width( ) - _frame_size_ * 2), (_position_ + _frame_size_ - 1))
            EndIf
          Else
            If (*this\frame_width( ) - _round_ - _position_) > _round_
              If *this\frame_width( ) > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > _position_
                  draw_box_(*this\frame_x( ) + _position_ + (_round_ - _position_), *this\frame_y( ) + _frame_size_, (*this\frame_width( ) - _round_ - _position_) - (_round_ - _position_), *this\frame_height( ) - _frame_size_ * 2)
                Else
                  draw_box_(*this\frame_x( ) + _position_, *this\frame_y( ) + _frame_size_, (*this\frame_width( ) - _round_ - _position_), *this\frame_height( ) - _frame_size_ * 2)
                EndIf
              EndIf
              
              ;\\
              DrawVLines( (*this\frame_width( ) - _round_), _frame_size_, (*this\frame_width( ) - _frame_size_), (*this\frame_height( ) - _frame_size_ * 2))
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > _position_
                DrawVLines( ( _frame_size_ + _position_), _frame_size_ , (_round_), (*this\frame_height( ) - _frame_size_ * 2))
              EndIf
              
            Else
              DrawVLines( (_position_ - _frame_size_), _frame_size_, (*this\frame_width( ) - _frame_size_), (*this\frame_height( ) - _frame_size_ * 2))
            EndIf
          EndIf
        EndIf
        
        ; Draw string
        If *this\text And *this\text\string And ( *this\height > *this\text\height )
          draw_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, $ff000000)
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i bar_draw_spin( *this._s_WIDGET )
      Protected state = *this\ColorState( )
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      draw_mode_( #PB_2DDrawing_Default )
      ;          ; draw split-string back
      ;          ;          draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), *this\color\back )
      ;          draw_box_( *this\frame_x( ) + *this\fs[1], *this\frame_y( ) + *this\fs[2], *this\frame_width( ) - *this\fs[1] - *this\fs[3], *this\frame_height( ) - *this\fs[2] - *this\fs[4], *this\color\back[0] )
      ;
      ;          ; draw split-bar back
      ;          If *this\fs[1] ; left
      ;             draw_box_( *this\frame_x( ), *this\frame_y( ), *this\fs[1] + 1, *this\frame_height( ), *this\color\back[0] )
      ;          EndIf
      ;          If *this\fs[2] ; top
      ;             draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\fs[2] + 1, *this\color\back[0] )
      ;          EndIf
      ;          If *this\fs[3] ; right
      ;             draw_box_( *this\frame_x( ) + *this\frame_width( ) - *this\fs[3] - 1, *this\frame_y( ), *this\fs[3] + 1, *this\frame_height( ), *this\color\back[0] )
      ;          EndIf
      ;          If *this\fs[4] ; bottom
      ;             draw_box_( *this\frame_x( ), *this\frame_y( ) + *this\frame_height( ) - *this\fs[4] - 1, *this\frame_width( ), *this\fs[4] + 1, *this\color\back[0] )
      ;          EndIf
      
      
      ;\\ draw spin-buttons back
      draw_mode_alpha_( #PB_2DDrawing_Gradient )
      draw_gradient_(*bar\vertical, *BB1, *BB1\color\fore[*BB1\ColorState( )], *BB1\color\back[*BB1\ColorState( )] )
      draw_gradient_(*bar\vertical, *BB2, *BB2\color\fore[*BB2\ColorState( )], *BB2\color\back[*BB2\ColorState( )] )
      
      ;\\
      draw_mode_( #PB_2DDrawing_Outlined )
      If *this\flag & #__spin_Plus 
        ; -/+
        draw_plus( *BB1, Bool( *bar\invert ) )
        draw_plus( *BB2, Bool( Not *bar\invert ) )
      Else
        ; arrows on the buttons
        If *BB2\arrow\size
          draw_arrows( *BB2, Bool(*bar\vertical ) )
        EndIf
        If *BB1\arrow\size
          draw_arrows( *BB1, Bool(*bar\vertical ) + 2)
        EndIf
      EndIf
      
      ;\\ draw spin-bar frame
      If *this\fs[1]
        draw_box_( *this\frame_x( ), *this\frame_y( ), *this\fs[1] + 1, *this\frame_height( ), *this\color\frame[state] )
      EndIf
      If *this\fs[2]
        draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\fs[2] + 1, *this\color\frame[state] )
      EndIf
      If *this\fs[3]
        draw_box_( *this\frame_x( ) + *this\frame_width( ) - *this\fs[3] - 1, *this\frame_y( ), *this\fs[3] + 1, *this\frame_height( ), *this\color\frame[state] )
      EndIf
      If *this\fs[4]
        draw_box_( *this\frame_x( ), *this\frame_y( ) + *this\frame_height( ) - *this\fs[4] - 1, *this\frame_width( ), *this\fs[4] + 1, *this\color\frame[state] )
      EndIf
      
      ;\\ draw spin-buttons frame
      If EnteredButton( ) <> *BB1
        draw_box_( *BB1\x, *BB1\y, *BB1\width, *BB1\height, *BB1\color\frame[*BB1\ColorState( )] )
      EndIf
      If EnteredButton( ) <> *BB2
        draw_box_( *BB2\x, *BB2\y, *BB2\width, *BB2\height, *BB2\color\frame[*BB2\ColorState( )] )
      EndIf
      If EnteredButton( )
        draw_box_( EnteredButton( )\x, EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, EnteredButton( )\color\frame[EnteredButton( )\ColorState( )] )
      EndIf
      
      ;\\ draw split-string frame
      draw_box_( *this\frame_x( ) + *this\fs[1], *this\frame_y( ) + *this\fs[2], *this\frame_width( ) - *this\fs[1] - *this\fs[3], *this\frame_height( ) - *this\fs[2] - *this\fs[4], *this\color\frame[state] )
    EndProcedure
    
    Procedure.b bar_draw_track( *this._s_WIDGET )
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *bar\button
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      bar_draw_scroll( *this )
      ;bar_draw_progress( *this )
      
      With *this
        If *this\type = #__type_TrackBar
          Protected i, x, y, size = DesktopScaled(7)
          draw_mode_( #PB_2DDrawing_XOr )
          
          If *bar\vertical
            x = *this\x + Bool( *bar\invert ) * ( *this\width - size )
            y = *this\y + *bar\area\pos + *SB\size/2
            
            Line( x, y, size, 1, *SB\color\frame )
            Line( x, y + *bar\area\len - *bar\thumb\len, size, 1, *SB\color\frame )
            
            If BinaryFlag( *this\flag, #PB_TrackBar_Ticks )
              For i = *bar\min To *bar\max
                If i <> *bar\min And 
                   i <> *bar\max
                  Line( x + DesktopScaled(2), y + bar_thumb_pos_( *bar, i ), DesktopScaled(3), 1, *SB\color\frame )
                EndIf
              Next
            EndIf
          Else
            x = *this\x + *bar\area\pos + *SB\size/2
            y = *this\y + Bool( Not *bar\invert ) * ( *this\height - size )
            
            Line( x, y, 1, size, *SB\color\frame )
            Line( x + *bar\area\len - *bar\thumb\len, y, 1, size, *SB\color\frame )
            
            If BinaryFlag( *this\flag, #PB_TrackBar_Ticks )
              For i = *bar\min To *bar\max
                If i <> *bar\min And
                   i <> *bar\max
                  Line( x + bar_thumb_pos_( *bar, i ), y + DesktopScaled(2), 1, DesktopScaled(3), *SB\color\frame )
                EndIf
              Next
            EndIf
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.b bar_draw_splitter( *this._s_WIDGET )
      Protected circle_x, circle_y
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *SB1, *SB2, *SB
      
      *SB  = *bar\button
      *SB1 = *bar\button[1]
      *SB2 = *bar\button[2]
      
      draw_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw the splitter background
      draw_box_( *SB\x, *SB\y, *SB\width, *SB\height, *this\color\back[*SB\ColorState( )] & $ffffff | 210 << 24 )
      
      ; draw the first\second background
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\ColorState( )] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\ColorState( )] ) : EndIf
      
      draw_mode_( #PB_2DDrawing_Outlined )
      
      ; draw the frame
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\ColorState( )] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\ColorState( )] ) : EndIf
      
      ;
      If *bar\thumb\len
        If *bar\vertical
          circle_y = ( *SB\y + *SB\height / 2 )
          circle_x = *this\frame_x( ) + ( *this\frame_width( ) - *SB\round ) / 2 + Bool( *this\width % 2 )
        Else
          circle_x = ( *SB\x + *SB\width / 2 ) ; - *this\x
          circle_y = *this\frame_y( ) + ( *this\frame_height( ) - *SB\round ) / 2 + Bool( *this\height % 2 )
        EndIf
        
        If *bar\vertical ; horisontal line
          If *SB\width > 35
            Circle( circle_x - ( *SB\round * 2 + 2 ) * 2 - 2, circle_y, *SB\round, *SB\color\frame[#__s_2] )
            Circle( circle_x + ( *SB\round * 2 + 2 ) * 2 + 2, circle_y, *SB\round, *SB\color\frame[#__s_2] )
          EndIf
          If *SB\width > 20
            Circle( circle_x - ( *SB\round * 2 + 2 ), circle_y, *SB\round, *SB\color\frame[#__s_2] )
            Circle( circle_x + ( *SB\round * 2 + 2 ), circle_y, *SB\round, *SB\color\frame[#__s_2] )
          EndIf
        Else
          If *SB\height > 35
            Circle( circle_x, circle_y - ( *SB\round * 2 + 2 ) * 2 - 2, *SB\round, *SB\color\frame[#__s_2] )
            Circle( circle_x, circle_y + ( *SB\round * 2 + 2 ) * 2 + 2, *SB\round, *SB\color\frame[#__s_2] )
          EndIf
          If *SB\height > 20
            Circle( circle_x, circle_y - ( *SB\round * 2 + 2 ), *SB\round, *SB\color\frame[#__s_2] )
            Circle( circle_x, circle_y + ( *SB\round * 2 + 2 ), *SB\round, *SB\color\frame[#__s_2] )
          EndIf
        EndIf
        
        Circle( circle_x, circle_y, *SB\round, *SB\color\frame[#__s_2] )
      EndIf
    EndProcedure
    
    Procedure.b bar_draw( *this._s_WIDGET )
      Protected *bar._s_BAR = *this\bar
      
      With *this
        If *this\text\string And ( *this\type = #__type_Spin Or
                                   *this\type = #__type_ProgressBar )
          
          If *this\text\TextChange( ) Or *this\resize\ResizeChange( )
            
            Protected _x_ = *this\inner_x( )
            Protected _y_ = *this\inner_y( )
            Protected _width_ = *this\inner_width( )
            Protected _height_ = *this\inner_height( )
            
            If *this\type = #PB_GadgetType_ProgressBar
              *this\text\rotate = ( Bool( *bar\vertical And Not *bar\invert ) * 90 ) +
                                  ( Bool( *bar\vertical And *bar\invert ) * 270 )
            EndIf
            
            If *this\text\rotate = 0
              *this\text\y = _y_ + ( _height_ - *this\text\height ) / 2
              
              If *this\text\align\right
                *this\text\x = _x_ + ( _width_ - *this\text\width - *this\text\padding\x )
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + ( _width_ - *this\text\width ) / 2
              Else
                *this\text\x = _x_ + *this\text\padding\x
              EndIf
              
            ElseIf *this\text\rotate = 180
              *this\text\y = _y_ + ( _height_ - *this\y )
              
              If *this\text\align\right
                *this\text\x = _x_ + *this\text\padding\x + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + ( _width_ + *this\text\width ) / 2
              Else
                *this\text\x = _x_ + _width_ - *this\text\padding\x
              EndIf
              
            ElseIf *this\text\rotate = 90
              *this\text\x = _x_ + ( _width_ - *this\text\height ) / 2
              
              If *this\text\align\right
                *this\text\y = _y_ + *this\text\padding\y + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + ( _height_ + *this\text\width ) / 2
              Else
                *this\text\y = _y_ + _height_ - *this\text\padding\y
              EndIf
              
            ElseIf *this\text\rotate = 270
              *this\text\x = _x_ + ( _width_ - 4 )
              
              If *this\text\align\right
                *this\text\y = _y_ + ( _height_ - *this\text\width - *this\text\padding\y )
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + ( _height_ - *this\text\width ) / 2
              Else
                *this\text\y = _y_ + *this\text\padding\y
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        Select *this\type
          Case #__type_ToolBarBar     : bar_draw_tab( *this )
          Case #__type_TabBarBar      : bar_draw_tab( *this )
          Case #__type_MenuBar        : bar_draw_tab( *this )
          Case #__type_ScrollBar   : bar_draw_scroll( *this )
          Case #__type_ProgressBar : bar_draw_progress( *this )
          Case #__type_TrackBar    : bar_draw_track( *this )
          Case #__type_Splitter    : bar_draw_splitter( *this )
          Case #__type_Spin        : bar_draw_spin( *this )
        EndSelect
        
        ;draw_mode_( #PB_2DDrawing_Outlined ) :draw_box_( *this\inner_x( ),\inner_y( ),\inner_width( ),\inner_height( ), $FF00FF00 )
        
        If *this\text\TextChange( ) <> 0
          *this\text\TextChange( ) = 0
        EndIf
        
      EndWith
    EndProcedure
    
    ;-
    Macro bar_area_create( _parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _scrollbar_size_, _mode_ = #True )
      If Not _parent_\scroll\bars
        _parent_\scroll\bars = 1
        _parent_\scroll\v    = Create( _parent_, "[" + _parent_\class + "" + _parent_\index + "]", #__type_ScrollBar, 0, 0, DesktopScaled( _scrollbar_size_), _height_, #Null$, #__flag_child | #__bar_vertical, 0, _area_height_, _height_, ( _scrollbar_size_), #__buttonround, _scroll_step_ )
        _parent_\scroll\h    = Create( _parent_, "[" + _parent_\class + "" + _parent_\index + "]", #__type_ScrollBar, 0, 0, _width_, DesktopScaled( _scrollbar_size_), #Null$, #__flag_child, 0, _area_width_, _width_, Bool( _mode_ ) * ( _scrollbar_size_), #__buttonround, _scroll_step_ )
      EndIf
    EndMacro
    
    Macro bar_area_draw( _this_ )
      If _this_\scroll And ( _this_\scroll\v Or _this_\scroll\h )
        ;clip_output_( _this_, [#__c_draw] )
        
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And
           ( _this_\scroll\v\draw_width( ) > 0 And _this_\scroll\v\draw_height( ) > 0 )
          bar_draw_scroll( _this_\scroll\v )
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And
           ( _this_\scroll\h\draw_width( ) > 0 And _this_\scroll\h\draw_height( ) > 0 )
          bar_draw_scroll( _this_\scroll\h )
        EndIf
        
        ;\\
        If Not _this_\haschildren
          draw_mode_alpha_( #PB_2DDrawing_Outlined )
          
          ; ;                ; Box( _this_\scroll_x( ), _this_\scroll_y( ), _this_\scroll_width( ), _this_\scroll_height( ), RGB( 255,0,0 ) )
          ; ;                Box( _this_\scroll\h\bar\page\pos, _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
          
          ;\\ Scroll area coordinate
          draw_box_( _this_\inner_x( ) + _this_\scroll_x( ) + _this_\text\padding\x, _this_\inner_y( ) + _this_\scroll_y( ) + _this_\text\padding\y, _this_\scroll_width( ) - _this_\text\padding\x * 2, _this_\scroll_height( ) - _this_\text\padding\y * 2, $FFFF0000 )
          draw_box_( _this_\inner_x( ) + _this_\scroll_x( ), _this_\inner_y( ) + _this_\scroll_y( ), _this_\scroll_width( ), _this_\scroll_height( ), $FF0000FF )
          
          If _this_\scroll\v And _this_\scroll\h
            draw_box_( _this_\scroll\h\frame_x( ) + _this_\scroll_x( ), _this_\scroll\v\frame_y( ) + _this_\scroll_y( ), _this_\scroll_width( ), _this_\scroll_height( ), $FF0000FF )
            
            ; Debug "" +  _this_\scroll_x( )  + " " +  _this_\scroll_y( )  + " " +  _this_\scroll_width( )  + " " +  _this_\scroll_height( )
            ;draw_box_( _this_\scroll\h\frame_x( ) - _this_\scroll\h\bar\page\pos, _this_\scroll\v\frame_y( ) - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF )
            
            ;\\ page coordinate
            draw_box_( _this_\scroll\h\frame_x( ), _this_\scroll\v\frame_y( ), _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00 )
          EndIf
        EndIf
      EndIf
    EndMacro
    
    Procedure bar_area_resize( *this._s_WIDGET, x.l, y.l, width.l, height.l )
      Protected v1, h1, x1 = #PB_Ignore, y1 = #PB_Ignore, iwidth, iheight, w, h
      ;Protected v1, h1, x1 = *this\container_x( ), y1 = *this\container_y( ), width1 = *this\container_width( ), height1 = *this\container_height( ), iwidth, iheight, w, h
      
      With *this\scroll
        If Not ( *this\scroll And ( \v Or \h ))
          ProcedureReturn 0
        EndIf
        
        If ( *this\width = 0 And *this\height = 0)
          \v\hide = #True
          \h\hide = #True
          ProcedureReturn 0
        EndIf
        
        If x = #PB_Ignore
          x = \h\container_x( )
        EndIf
        If y = #PB_Ignore
          y = \v\container_y( )
        EndIf
        If width = #PB_Ignore
          width = \v\frame_x( ) - \h\frame_x( ) + \v\frame_width( )
        EndIf
        If height = #PB_Ignore
          height = \h\frame_y( ) - \v\frame_y( ) + \h\frame_height( )
        EndIf
        
        w = Bool( *this\scroll_width( ) > width )
        h = Bool( *this\scroll_height( ) > height )
        
        \v\bar\page\len = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        \h\bar\page\len = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        
        iheight = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        If \v\bar\page\len = iheight
          If \v\bar\thumb\len = \v\bar\thumb\end
            bar_Update( \v, #True )
          EndIf
          bar_Update( \h, #True )
        Else
          \v\bar\AreaChange( ) = \v\bar\page\len - iheight
          \v\bar\page\len      = iheight
          
          If Not \v\bar\max
            If \v\bar\min > iheight
              \v\bar\max = \v\bar\min + 1
            Else
              \v\bar\max = iheight
            EndIf
          EndIf
        EndIf
        
        iwidth = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        If \h\bar\page\len = iwidth
          bar_Update( \v, #True )
          If \h\bar\thumb\len = \h\bar\thumb\end
            bar_Update( \h, #True )
          EndIf
        Else
          \h\bar\AreaChange( ) = \h\bar\page\len - iwidth
          \h\bar\page\len      = iwidth
          
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
        
        If \v\frame_x( ) <> width - \v\width
          v1 = 1
          x1 = width - \v\width
        EndIf
        
        If \h\frame_y( ) <> height - \h\height
          h1 = 1
          y1 = height - \h\height
        EndIf
        
        If \v\bar\max > \v\bar\page\len
          v1     = 1
          height = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
          If \v\hide <> #False
            \v\hide = #False
            If \h\hide
              width = \h\bar\page\len
            EndIf
          EndIf
        Else
          If \v\hide <> #True
            \v\hide = #True
            ;// reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              bar_PageChange( \v, \v\bar\min, #False )
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          h1    = 1
          width = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width / 4 ))
          If \h\hide <> #False
            \h\hide = #False
            If \v\hide
              height = \v\bar\page\len
            EndIf
          EndIf
        Else
          If \h\hide <> #True
            \h\hide = #True
            ;// reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              bar_PageChange( \h, \h\bar\min, #False )
            EndIf
          EndIf
        EndIf
        
        If v1 And (\v\frame_x( ) <> *this\inner_x( ) + x1 Or \v\frame_y( ) <> *this\inner_y( ) + y Or \v\frame_height( ) <> height)
          Resize( \v, x1 , y, #PB_Ignore, height )
        EndIf
        If h1 And (\h\frame_x( ) <> *this\inner_x( ) + x Or \h\frame_y( ) <> *this\inner_y( ) + y1 Or \h\frame_width( ) <> width)
          Resize( \h, x, y1, width, #PB_Ignore )
        EndIf
        
        If \v\bar\thumb\len = \v\bar\thumb\end
          \v\hide = 1
        Else
          \v\hide = 0
        EndIf
        
        If \h\bar\thumb\len = \h\bar\thumb\end
          \h\hide = 1
        Else
          \h\hide = 0
        EndIf
        
        ;\\ update scrollbars parent inner coordinate
        If *this\scroll_inner_width( ) <> \h\bar\page\len
          *this\scroll_inner_width( ) = \h\bar\page\len
        EndIf
        If *this\scroll_inner_height( ) <> \v\bar\page\len
          *this\scroll_inner_height( ) = \v\bar\page\len
        EndIf
        
        If \v\bar\AreaChange( ) Or
           \h\bar\AreaChange( )
          
          ; Debug ""+\v\bar\max +" "+ \v\bar\page\len
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b bar_area_update( *this._s_WIDGET )
      Protected result.b
      
      ;\\ change vertical scrollbar max
      If *this\scroll\v And *this\scroll\v\bar\max <> *this\scroll_height( ) And
         bar_SetAttribute( *this\scroll\v, #PB_ScrollBar_Maximum, *this\scroll_height( ) )
        result = 1
      EndIf
      
      ;\\ change horizontal scrollbar max
      If *this\scroll\h And *this\scroll\h\bar\max <> *this\scroll_width( ) And
         bar_SetAttribute( *this\scroll\h, #PB_ScrollBar_Maximum, *this\scroll_width( ) )
        result = 1
      EndIf
      
      If result
        bar_area_resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;     ;-
    ;     Macro bar_mdi_change( _this_, _objects_ )
    ;       ;\\ 
    ;       _this_\scroll_x( ) = _objects_\x 
    ;       _this_\scroll_y( ) = _objects_\Y
    ;       _this_\scroll_width( ) = _objects_\width
    ;       _this_\scroll_height( ) = _objects_\height
    ;       ;
    ;       PushListPosition( _objects_ )
    ;       ForEach _objects_
    ;         If _this_\scroll_x( ) > _objects_\x 
    ;           _this_\scroll_x( ) = _objects_\x 
    ;         EndIf
    ;         If _this_\scroll_y( ) > _objects_\y 
    ;           _this_\scroll_y( ) = _objects_\y 
    ;         EndIf
    ;       Next
    ;       ;
    ;       ForEach _objects_
    ;         If _this_\scroll_width( ) < _objects_\x + _objects_\width - _this_\scroll_x( ) 
    ;           _this_\scroll_width( ) = _objects_\x + _objects_\width - _this_\scroll_x( ) 
    ;         EndIf
    ;         If _this_\scroll_height( ) < _objects_\Y + _objects_\height - _this_\scroll_y( ) 
    ;           _this_\scroll_height( ) = _objects_\Y + _objects_\height - _this_\scroll_y( ) 
    ;         EndIf
    ;       Next
    ;       PopListPosition( _objects_ )
    ;       
    ;       widget::bar_mdi_resize( _this_,
    ;                               _this_\scroll\h\x, 
    ;                               _this_\scroll\v\y, 
    ;                               ( _this_\scroll\v\x + _this_\scroll\v\width ) - _this_\scroll\h\x,
    ;                               ( _this_\scroll\h\y + _this_\scroll\h\height ) - _this_\scroll\v\y )
    ;     EndMacro
    ;     
    Procedure bar_mdi_update( *this._s_WIDGET, x.l, y.l, width.l, height.l ) ; Ok
      *this\scroll_x( )      = x
      *this\scroll_y( )      = y
      *this\scroll_width( )  = width
      *this\scroll_height( ) = height
      
      ;\\
      If StartEnumerate( *this )
        If *this = widget( )\parent
          If *this\scroll_x( ) > widget( )\container_x( )
            *this\scroll_x( ) = widget( )\container_x( )
          EndIf
          If *this\scroll_y( ) > widget( )\container_y( )
            *this\scroll_y( ) = widget( )\container_y( )
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      ;\\
      If StartEnumerate( *this )
        If *this = widget( )\parent
          If *this\scroll_width( ) < widget( )\container_x( ) + widget( )\frame_width( ) - *this\scroll_x( )
            *this\scroll_width( ) = widget( )\container_x( ) + widget( )\frame_width( ) - *this\scroll_x( )
          EndIf
          If *this\scroll_height( ) < widget( )\container_y( ) + widget( )\frame_height( ) - *this\scroll_y( )
            *this\scroll_height( ) = widget( )\container_y( ) + widget( )\frame_height( ) - *this\scroll_y( )
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
    EndProcedure
    
    Procedure bar_mdi_resize( *this._s_WIDGET, x.l, y.l, width.l, height.l )
      Static v_max, h_max
      Protected sx, sy, round, result
      Protected scroll_x, scroll_y, scroll_width, scroll_height
      
      With *this\scroll
        If Not ( *this\scroll And ( \v Or \h ))
          ProcedureReturn 0
        EndIf
        
        ;\\
        scroll_x      = *this\scroll_x( )
        scroll_y      = *this\scroll_y( )
        scroll_width  = *this\scroll_width( )
        scroll_height = *this\scroll_height( )
        
        ;\\ top set state
        If scroll_y < y
          \h\bar\page\len = width - \v\width
        Else
          If \h\bar\page\len <> width - Bool( scroll_height > height ) * \v\width
            \h\bar\page\len = width - Bool( scroll_height > height ) * \v\width
          EndIf
          
          sy = ( scroll_y - y )
          scroll_height + sy
          scroll_y = y
        EndIf
        
        ;\\ left set state
        If scroll_x < x
          \v\bar\page\len = height - \h\height
        Else
          If \v\bar\page\len <> height - Bool( scroll_width > width ) * \h\height
            \v\bar\page\len = height - Bool( scroll_width > width ) * \h\height
          EndIf
          
          sx = ( scroll_x - x )
          scroll_width + sx
          scroll_x = x
        EndIf
        
        ;\\
        If scroll_width > \h\bar\page\len - ( scroll_x - x )
          If scroll_width - sx <= width And scroll_height = \v\bar\page\len - ( scroll_y - y )
            ;Debug "w - " + Str( scroll_height - sx )
            
            ; if on the h - scroll
            If \v\bar\max > height - \h\height
              \v\bar\page\len = height - \h\height
              \h\bar\page\len = width - \v\width
              scroll_height   = \v\bar\max
              
              If scroll_y <= y
                \v\bar\page\pos = - ( scroll_y - y )
              EndIf
              ;  Debug "w - " + \v\bar\max  + " " +  \v\height  + " " +  \v\bar\page\len
            Else
              scroll_height = \v\bar\page\len - ( scroll_x - x ) - \h\height
            EndIf
          EndIf
          
          \v\bar\page\len = height - \h\height
          If scroll_x <= x
            \h\bar\page\pos = - ( scroll_x - x )
            h_max           = 0
          EndIf
        Else
          \h\bar\max   = scroll_width
          scroll_width = \h\bar\page\len - ( scroll_x - x )
        EndIf
        
        ;\\
        If scroll_height > \v\bar\page\len - ( scroll_y - y )
          If scroll_height - sy <= Height And scroll_width = \h\bar\page\len - ( scroll_x - x )
            ;Debug " h - " + Str( scroll_height - sy )
            
            ; if on the v - scroll
            If \h\bar\max > width - \v\width
              \h\bar\page\len = width - \v\width
              \v\bar\page\len = height - \h\height
              scroll_width    = \h\bar\max
              
              If scroll_x <= x
                \h\bar\page\pos = - ( scroll_x - x )
              EndIf
              ;  Debug "h - " + \h\bar\max  + " " +  \h\width  + " " +  \h\bar\page\len
            Else
              scroll_width = \h\bar\page\len - ( scroll_x - x ) - \v\width
            EndIf
          EndIf
          
          \h\bar\page\len = width - \v\width
          If scroll_y <= y
            \v\bar\page\pos = - ( scroll_y - y )
            v_max           = 0
          EndIf
        Else
          \v\bar\max    = scroll_height
          scroll_height = \v\bar\page\len - ( scroll_y - y )
        EndIf
        
        ;\\
        If \h\round And
           \v\round And
           \h\bar\page\len < width And
           \v\bar\page\len < height
          round = ( \h\height / 4 )
        EndIf
        
        ;Debug ""+*this\scroll_width( ) +" "+ scroll_width
        
        ;\\
        If scroll_height >= \v\bar\page\len
          If \v\bar\Max <> scroll_height
            \v\bar\Max = scroll_height
            If scroll_y <= y
              \v\bar\page\pos = - ( scroll_y - y )
            EndIf
          EndIf
          
          If \v\height <> \v\bar\page\len + round
            Resize( \v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len + round )
            *this\scroll\v\hide = Bool( *this\scroll\v\bar\max <= *this\scroll\v\bar\page\len )
            result              = 1
          EndIf
        EndIf
        
        ;\\
        If scroll_width >= \h\bar\page\len
          If \h\bar\Max <> scroll_width
            \h\bar\Max = scroll_width
            If scroll_x <= x
              \h\bar\page\pos = - ( scroll_x - x )
            EndIf
          EndIf
          
          If \h\width <> \h\bar\page\len + round
            Resize( \h, #PB_Ignore, #PB_Ignore, \h\bar\page\len + round, #PB_Ignore )
            *this\scroll\h\hide = Bool( *this\scroll\h\bar\max <= *this\scroll\h\bar\page\len )
            result              = 1
          EndIf
        EndIf
        
        ;\\
        ;\\
        If v_max <> \v\bar\Max
          v_max = \v\bar\Max
          bar_Update( \v, #True )
          result = 1
        EndIf
        
        ;\\
        If h_max <> \h\bar\Max
          h_max = \h\bar\Max
          bar_Update( \h, #True )
          result = 1
        EndIf
        
        ; Debug ""+\h\bar\thumb\len +" "+ \h\bar\page\len +" "+ \h\bar\area\len +" "+ \h\bar\thumb\end +" "+ \h\bar\page\end +" "+ \h\bar\area\end
        
        ;\\
        *this\scroll_x( )      = scroll_x
        *this\scroll_y( )      = scroll_y
        *this\scroll_width( )  = scroll_width
        *this\scroll_height( ) = scroll_height
        
        ;\\ update scrollbars parent inner coordinate
        If *this\scroll_inner_width( ) <> \h\bar\page\len
          *this\scroll_inner_width( ) = \h\bar\page\len
        EndIf
        If *this\scroll_inner_height( ) <> \v\bar\page\len
          *this\scroll_inner_height( ) = \v\bar\page\len
        EndIf
        
        ProcedureReturn result
      EndWith
    EndProcedure
    
    ;-
    Procedure.b bar_Update( *this._s_WIDGET, mode.b = 1 )
      Protected fixed.l, ScrollPos.f, ThumbPos.i, width, height
      
      ;\\
      If Not *this\bar
        ProcedureReturn 0
      EndIf
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *bar\button
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      ;Debug ""+ mode +" "+ *this\bar\PageChange( )
      ;mode = 2
      
      ;          ; NEW
      ;          If Not *bar\max 
      ;             If *this\type = #__type_Splitter
      ;                Debug ">>>>>>>>>"+Str(*bar)+">>>>>>>>"
      ;                Debug " ["+ *this\class +"] "+
      ;                      *bar\percent +" >< "+
      ;                      *bar\min +" "+
      ;                      *bar\max +" >< "+
      ;                      *bar\page\pos +" "+
      ;                      *bar\page\len +" "+
      ;                      *bar\page\end +" "+
      ;                      *bar\page\change +" >< "+
      ;                      *bar\area\pos +" "+
      ;                      *bar\area\len +" "+
      ;                      *bar\area\end +" "+
      ;                      *bar\area\change +" >< "+
      ;                      *bar\thumb\pos +" "+
      ;                      *bar\thumb\len +" "+
      ;                      *bar\thumb\end +" "+
      ;                      *bar\thumb\change +""
      ;                Debug "<<<<<<<<<<<<<<<<<"
      ;                
      ;                If *bar\page\pos = *bar\page\end 
      ;                   ;  ProcedureReturn 0
      ;                EndIf
      ;                
      ;             Else
      ;                ProcedureReturn 0
      ;             EndIf
      ;          EndIf
      
      ;Debug "*bar\page\pos "+*bar\page\pos
      
      width  = *this\frame_width( )
      height = *this\frame_height( )
      
      ;\\
      If mode
        ;\\ get area size
        If *bar\vertical
          *bar\AreaChange( ) = *bar\area\len - height
          *bar\area\len = height
        Else
          *bar\AreaChange( ) = *bar\area\len - width
          *bar\area\len = width
        EndIf
        
        If *this\type = #__type_Spin
          ; set real spin-buttons height
          If Not *this\flag & #__spin_Plus
            *BB1\size = height / 2 + Bool( height % 2 )
            *BB2\size = *BB1\size + Bool( Not height % 2 )
          EndIf
          
          ;*bar\area\pos = ( *BB1\size + *bar\min[1] )
          *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size )
          
          *bar\page\end = *bar\max
          *bar\area\end = *bar\max - *bar\thumb\Len
          *bar\percent  = ( *bar\area\end - *bar\area\pos ) / ( *bar\page\end - *bar\min )
          
        Else
          ; scroll-bar default button size
          If *this\type = #__type_ScrollBar
            If *bar\max
              If *BB1\size = - 1 And *BB2\size = - 1
                If *bar\vertical And width > 7 And width < 21
                  *BB1\size = width - 1
                  *BB2\size = width - 1
                  
                ElseIf Not *bar\vertical And height > 7 And height < 21
                  *BB1\size = height - 1
                  *BB2\size = height - 1
                  
                Else
                  *BB1\size = *SB\size
                  *BB2\size = *SB\size
                EndIf
              EndIf
              
              ;           If *SB\size
              ;             If *bar\vertical
              ;               If *this\width = 0
              ;                 *this\width = *SB\size
              ;               EndIf
              ;             Else
              ;               If *this\height = 0
              ;                 *this\height = *SB\size
              ;               EndIf
              ;             EndIf
              ;           EndIf
            EndIf
          EndIf
          
          If *bar\area\len ; TODO - ?
            *bar\area\pos  = ( *BB1\size + *bar\min[1] )
            *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size )
            ;
            If *this\type = #__type_ToolBarBar Or 
               *this\type = #__type_TabBarBar Or
               *this\type = #__type_MenuBar 
              ;
              If *bar\max
                *bar\thumb\len = *bar\thumb\end - ( *bar\max - *bar\area\len )
                *bar\page\end  = *bar\max - ( *bar\thumb\end - *bar\thumb\len )
                ; *bar\page\end  = *bar\max - ( *bar\area\len - *bar\thumb\len )
              EndIf
              
            Else
              If *bar\page\len
                
                ; get thumb size
                *bar\thumb\len = Round(( *bar\thumb\end / ( *bar\max - *bar\min )) * *bar\page\len, #PB_Round_Nearest )
                If *bar\thumb\len > *bar\thumb\end
                  *bar\thumb\len = *bar\thumb\end
                EndIf
                
                If *bar\thumb\len < *SB\size
                  If *bar\thumb\end > *SB\size + *bar\thumb\len
                    *bar\thumb\len = *SB\size
                  EndIf
                EndIf
                
                ; for the scroll-bar
                If *bar\max > *bar\page\len
                  *bar\page\end = *bar\max - *bar\page\len
                Else
                  *bar\page\end = *bar\page\len - *bar\max
                EndIf
                
                If *bar\thumb\len = *bar\thumb\end
                  *bar\page\end = *bar\min
                EndIf
                
              Else
                ; get page end
                If *bar\max
                  *bar\thumb\len = *SB\size
                  If *bar\thumb\len > *bar\area\len
                    *bar\thumb\len = *bar\area\len
                  EndIf
                  *bar\page\end = *bar\max
                  
                Else
                  ; get thumb size
                  *bar\thumb\len = *SB\size
                  If *bar\thumb\len > *bar\area\len
                    *bar\thumb\len = *bar\area\len
                  EndIf
                  
                  ; one set end
                  If Not *bar\page\end And *bar\area\len
                    *bar\page\end = *bar\area\len - *bar\thumb\len
                    
                    If Not *bar\page\pos
                      *bar\page\pos = *bar\page\end / 2
                      *bar\PageChange( ) = *bar\page\pos
                    EndIf
                  Else
                    If *bar\fixed = 1
                      *bar\page\end = *bar\area\len - *bar\thumb\len
                    ElseIf *bar\PageChange( )
                      *bar\page\end = *bar\area\len - *bar\thumb\len
                    EndIf
                  EndIf
                EndIf
                
              EndIf
            EndIf
            
            If *bar\page\end
              *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\page\end - *bar\min )
            Else
              *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / *bar\min
            EndIf
            
            *bar\area\end = *bar\area\len - *bar\thumb\len - ( *BB2\size + *bar\min[2] )
            If *bar\area\end < *bar\area\pos
              *bar\area\end = *bar\area\pos
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      ; Debug ""+*bar\PageChange( ) +" "+ *bar\percent +" "+ *bar\min +" "+ *bar\min[2] +" "+ *bar\page\pos +" "+ *bar\area\end +" "+ *bar\page\end
      
      ;\\
      ;\\ get thumb pos
      If Not ( *bar\fixed And Not *bar\PageChange( ) )
        If *this\type = #__type_ToolBarBar Or
           *this\type = #__type_TabBarBar Or
           *this\type = #__type_MenuBar
          ;                ;
          ;                If *bar\page\pos < *bar\min
          ;                   ; If *bar\max > *bar\page\len
          ;                   *bar\page\pos = *bar\min
          ;                   ; EndIf
          ;                EndIf
          
          ;\\ scroll to active tab
          If *this\TabChange( )
            If *this\TabFocused( ) And *this\TabFocused( )\enter = #False
              If *this\TabFocused( )\ScrollToActive( - 1 )
                *this\TabFocused( )\ScrollToActive( 1 )
                ;Debug " tab max - " + *bar\max + " " + " " + *bar\page\pos + " " + *bar\page\end
                ScrollPos = *bar\max - *this\TabFocused( )\x
                ;ScrollPos - *bar\thumb\end                                    ; to left
                ;ScrollPos - *this\TabFocused( )\width                         ; to right
                ScrollPos - ( *bar\thumb\end + *this\TabFocused( )\width ) / 2 ; to center
                
                ScrollPos     = bar_page_pos_( *bar, ScrollPos )
                ScrollPos     = bar_invert_page_pos_( *bar, ScrollPos )
                *bar\page\pos = ScrollPos
              EndIf
            EndIf
          Else
            ; Debug *bar\page\pos
            ;                   If Not *bar\page\pos
            ;                      ScrollPos = *bar\max
            ;                      ScrollPos     = bar_page_pos_( *bar, ScrollPos )
            ;                      ScrollPos     = bar_invert_page_pos_( *bar, ScrollPos )
            ;                      *bar\page\pos = ScrollPos
            ;                   EndIf
          EndIf
          
        Else
          ; fixed mac-OS splitterGadget
          If *bar\min > *bar\page\pos
            If *bar\max > *bar\page\len
              If *bar\page\end
                *bar\page\pos = *bar\page\end + *bar\page\pos
                Debug " bar error pos"
              Else
                Debug " bar error end - " + *bar\page\end
              EndIf
            EndIf
          EndIf
          
          ; for the scrollarea children's
          If *bar\page\end And *bar\page\pos > *bar\page\end
            ; Debug " bar end change - " + *bar\page\pos +" "+ *bar\page\end
            *bar\PageChange( )  = *bar\page\pos - *bar\page\end
            *bar\page\pos       = *bar\page\end
            *this\BarChange( ) = 0
          EndIf
        EndIf
        
        ;\\ 
        If Not *this\BarChange( )
          ThumbPos = bar_thumb_pos_( *bar, *bar\page\pos )
          ;
          If *bar\invert
            ThumbPos = *bar\area\end - ThumbPos
          Else
            ThumbPos = *bar\area\pos + ThumbPos
          EndIf
          ;
          If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
          If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
          ;
          If *bar\thumb\pos <> ThumbPos
            *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
            *bar\thumb\pos = ThumbPos
          EndIf
          ;
          If *this\type = #__type_Splitter
            If *bar\ThumbChange( )
              If mouse( )\press
                If Not *bar\PageChange( ) 
                  *bar\PageChange( )  = 1
                EndIf
              EndIf
            EndIf              
          EndIf               
        EndIf
        ;
      EndIf
      
      ;
      ;\\ splitter fixed size
      If *bar\fixed 
        If *bar\PageChange( ) 
          If *bar\fixed = 1
            *bar\fixed[1] = *bar\thumb\pos
          EndIf
          If *bar\fixed = 2
            *bar\fixed[2] = *bar\area\end - *bar\thumb\pos 
          EndIf
        Else
          If *bar\fixed = 1
            If *bar\fixed[1] > *bar\area\end
              If *bar\min[1] < *bar\area\end
                ThumbPos = *bar\area\end
              Else
                If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                  ThumbPos = ( *bar\area\end + *bar\min[2] )
                Else
                  If *bar\min[1] > *bar\area\len - *bar\thumb\len
                    ThumbPos = *bar\area\len - *bar\thumb\len
                  Else
                    ThumbPos = *bar\min[1]
                  EndIf
                EndIf
              EndIf
            Else
              ThumbPos = *bar\fixed[1]
            EndIf
          EndIf
          ;
          If *bar\fixed = 2
            If *bar\min[1] > *bar\area\end - *bar\fixed[2] 
              If *bar\min[1] > *bar\area\end + *bar\min[2] 
                ThumbPos = *bar\area\end + *bar\min[2]
              Else
                If *bar\min[1] > *bar\area\len - *bar\thumb\len
                  ThumbPos = *bar\area\len - *bar\thumb\len
                Else
                  ThumbPos = *bar\min[1]
                EndIf
              EndIf
            Else
              ThumbPos = *bar\area\end - *bar\fixed[2] 
            EndIf
          EndIf
          ;
          If *bar\thumb\pos <> ThumbPos
            *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
            *bar\thumb\pos = ThumbPos
            ; Debug ""+*this\class +" "+  *bar\fixed +" "+ ThumbPos
          EndIf
        EndIf
      EndIf
      
      ;
      ;\\ disable/enable
      ;\\ buttons(left&top)-tab(right&bottom)
      If bar_in_start_( *bar )
        If *BB1\disable = #False
          *BB1\disable = #True
          
          ;\\
          If *this\type = #__type_Spin Or
             *this\type = #__type_ScrollBar 
            ;
            *BB1\ColorState( ) = #__s_3
          EndIf
          
          ;\\
          If *this\type = #__type_ToolBarBar Or
             *this\type = #__type_TabBarBar Or
             *this\type = #__type_MenuBar
            ;
            *BB1\hide = 1
            *BB1\ColorState( ) = #__s_3
          EndIf
          
          ;\\
          If *this\press And 
             *this\type = #__type_splitter
            ChangeCursor( *this, *this\cursor[2] )
          EndIf
        EndIf
      Else
        If *BB1\disable = #True
          *BB1\disable = #False
          
          ;\\
          If *this\type = #__type_Spin Or
             *this\type = #__type_ScrollBar 
            ;
            *BB1\ColorState( ) = #__s_0
          EndIf
          
          ;\\
          If *this\type = #__type_ToolBarBar Or
             *this\type = #__type_TabBarBar Or
             *this\type = #__type_MenuBar
            ;
            *BB1\hide = 0
            *BB1\ColorState( ) = #__s_0
          EndIf
          
          ;\\
          If *this\press And 
             *this\type = #__type_splitter
            ChangeCursor( *this, *this\cursor )
          EndIf
        EndIf
      EndIf
      
      ;\\ buttons(right&bottom)-tab(left&top)
      If bar_in_stop_( *bar )
        If *BB2\disable = #False
          *BB2\disable = #True
          
          ;\\
          If *this\type = #__type_Spin Or
             *this\type = #__type_ScrollBar 
            ;
            *BB2\ColorState( ) = #__s_3
          EndIf
          
          ;\\
          If *this\type = #__type_ToolBarBar Or
             *this\type = #__type_TabBarBar Or
             *this\type = #__type_MenuBar
            ;
            *BB2\hide = 1
            *BB2\ColorState( ) = #__s_3
          EndIf
          
          ;\\
          If *this\press And 
             *this\type = #__type_splitter
            ChangeCursor( *this, *this\cursor[1] )
          EndIf
        EndIf
      Else
        If *BB2\disable = #True
          *BB2\disable = #False
          ;\\
          If *this\type = #__type_Spin Or
             *this\type = #__type_ScrollBar
            ;
            *BB2\ColorState( ) = #__s_0
          EndIf
          
          ;\\
          If *this\type = #__type_ToolBarBar Or
             *this\type = #__type_TabBarBar Or
             *this\type = #__type_MenuBar
            ;
            *BB2\hide = 0
            *BB2\ColorState( ) = #__s_0
          EndIf
          
          ;\\
          If *this\press And 
             *this\type = #__type_splitter
            ChangeCursor( *this, *this\cursor )
          EndIf
        EndIf
      EndIf
      
      ;\\ button-thumb
      If *this\type = #__type_ScrollBar
        If *bar\thumb\len
          If *BB1\ColorState( ) = #__s_3 And
             *BB2\ColorState( ) = #__s_3
            
            If *SB\disable = #False
              *SB\disable = #True
              
              *SB\ColorState( ) = #__s_3
            EndIf
          Else
            If *SB\disable = #True
              *SB\disable = #False
              
              *SB\ColorState( ) = #__s_0
            EndIf
          EndIf
        EndIf
        
        ;\\
        If is_integral_( *this )
          *this\hide = Bool(*bar\max <= *bar\page\len)
        EndIf
      EndIf
      
      ;
      ;\\ resize buttons coordinate
      ;\\
      If *this\type = #__type_ScrollBar
        If *bar\thumb\len
          If *bar\vertical
            *SB\x      = *this\frame_x( ) + 1 ; white line size
            *SB\width  = *this\frame_width( ) - 1 ; white line size
            *SB\y      = *this\inner_y( ) + *bar\thumb\pos
            *SB\height = *bar\thumb\len
          Else
            *SB\y      = *this\frame_y( ) + 1 ; white line size
            *SB\height = *this\frame_height( ) - 1 ; white line size
            *SB\x      = *this\inner_x( ) + *bar\thumb\pos
            *SB\width  = *bar\thumb\len
          EndIf
        EndIf
        
        If *BB1\size
          If *bar\vertical
            ; Top button coordinate on vertical scroll bar
            *BB1\x      = *SB\x
            *BB1\width  = *SB\width
            *BB1\y      = *this\frame_y( )
            *BB1\height = *BB1\size
          Else
            ; Left button coordinate on horizontal scroll bar
            *BB1\y      = *SB\y
            *BB1\height = *SB\height
            *BB1\x      = *this\frame_x( )
            *BB1\width  = *BB1\size
          EndIf
        EndIf
        
        If *BB2\size
          If *bar\vertical
            ; Botom button coordinate on vertical scroll bar
            *BB2\x      = *SB\x
            *BB2\width  = *SB\width
            *BB2\height = *BB2\size
            *BB2\y      = *this\frame_y( ) + *this\frame_height( ) - *BB2\height
          Else
            ; Right button coordinate on horizontal scroll bar
            *BB2\y      = *SB\y
            *BB2\height = *SB\height
            *BB2\width  = *BB2\size
            *BB2\x      = *this\frame_x( ) + *this\frame_width( ) - *BB2\width
          EndIf
        EndIf
        
        ; Thumb coordinate on scroll bar
        If Not *bar\thumb\len
          ; auto resize buttons
          If *bar\vertical
            *BB2\height = *this\frame_height( ) / 2
            *BB2\y      = *this\frame_y( ) + *BB2\height + Bool( *this\frame_height( ) % 2 )
            
            *BB1\y      = *this\y
            *BB1\height = *this\height / 2 - Bool( Not *this\frame_height( ) % 2 )
            
          Else
            *BB2\width = *this\frame_width( ) / 2
            *BB2\x     = *this\frame_x( ) + *BB2\width + Bool( *this\frame_width( ) % 2 )
            
            *BB1\x     = *this\frame_x( )
            *BB1\width = *this\frame_width( ) / 2 - Bool( Not *this\frame_width( ) % 2 )
          EndIf
          
          If *bar\vertical
            *SB\width  = 0
            *SB\height = 0
          Else
            *SB\height = 0
            *SB\width  = 0
          EndIf
        EndIf
        
        ;\\
        If *bar\PageChange( )
          If *this\parent And *this\parent\scroll
            If *bar\vertical
              If *this\parent\scroll\v = *this
                *this\parent\WidgetChange( ) = - 1
                *this\parent\scroll_y( )     = - *bar\page\pos
                
                ;\\ Area children's x&y auto move
                If *this\parent\type = #__type_ScrollArea And IsGadget(*this\parent\scroll\gadget[2])
                  ResizeGadget(*this\parent\scroll\gadget[2], #PB_Ignore, DesktopUnscaledY(*this\parent\scroll_y( )), #PB_Ignore, #PB_Ignore)
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    UpdateWindow_(GadgetID(*this\parent\scroll\gadget[2]))
                  CompilerEndIf
                Else
                  If StartEnumerate( *this\parent )
                    If *this\parent = widget( )\parent 
                      If *this\parent\scroll\v <> widget( ) And
                         *this\parent\scroll\h <> widget( ) And Not widget( )\align
                        ;
                        widget( )\noscale = 1
                        If widget( )\child < 0
                          Resize( widget( ), #PB_Ignore, ( widget( )\container_y( ) + *bar\PageChange( ) ), #PB_Ignore, #PB_Ignore )
                        Else
                          Resize( widget( ), #PB_Ignore, ( widget( )\container_y( ) + *bar\PageChange( ) ) - *this\parent\scroll_y( ), #PB_Ignore, #PB_Ignore )
                        EndIf
                      EndIf
                    EndIf
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            Else
              If *this\parent\scroll\h = *this
                *this\parent\WidgetChange( ) = - 2
                *this\parent\scroll_x( )     = - *bar\page\pos
                ;
                ;\\ Area children's x&y auto move
                If *this\parent\type = #__type_ScrollArea And IsGadget(*this\parent\scroll\gadget[2])
                  ResizeGadget(*this\parent\scroll\gadget[2], DesktopUnscaledX(*this\parent\scroll_x( )), #PB_Ignore, #PB_Ignore, #PB_Ignore)
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    UpdateWindow_(GadgetID(*this\parent\scroll\gadget[2]))
                  CompilerEndIf
                Else
                  If StartEnumerate( *this\parent )
                    If *this\parent = widget( )\parent 
                      If *this\parent\scroll\v <> widget( ) And
                         *this\parent\scroll\h <> widget( ) And Not widget( )\align
                        ;
                        widget( )\noscale = 1
                        If widget( )\child < 0
                          Resize( widget( ), ( widget( )\container_x( ) + *bar\PageChange( ) ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                        Else
                          Resize( widget( ), ( widget( )\container_x( ) + *bar\PageChange( ) ) - *this\parent\scroll_x( ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                        EndIf
                      EndIf
                    EndIf
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\ Ok
      If *this\type = #__type_Splitter
        ;
        If *bar\vertical
          *BB1\width  = *this\frame_width( )
          *BB1\height = *bar\thumb\pos
          
          *BB1\x = *this\frame_x( )
          *BB2\x = *this\frame_x( )
          
          ;             If Not (( #PB_Compiler_OS = #PB_OS_MacOS ) And isgadget( *this\split_1( ) ) And Not *this\parent )
          *BB1\y = *this\frame_y( )
          *BB2\y = ( *bar\thumb\pos + *bar\thumb\len ) + *this\frame_y( )
          ;             Else
          ;               *BB1\y      = *this\frame_height( ) - *BB1\height
          ;             EndIf
          
          *BB2\height = *this\frame_height( ) - ( *BB1\height + *bar\thumb\len )
          *BB2\width  = *this\frame_width( )
          
          ; seperatior pos&size
          If *bar\thumb\len
            *SB\x      = *this\frame_x( )
            *SB\width  = *this\frame_width( )
            *SB\y      = *this\inner_y( ) + *bar\thumb\pos
            *SB\height = *bar\thumb\len
          EndIf
          
        Else
          *BB1\width  = *bar\thumb\pos
          *BB1\height = *this\frame_height( )
          
          *BB1\y = *this\frame_y( )
          *BB2\y = *this\frame_y( )
          *BB1\x = *this\frame_x( )
          *BB2\x = ( *bar\thumb\pos + *bar\thumb\len ) + *this\frame_x( )
          
          *BB2\width  = *this\frame_width( ) - ( *BB1\width + *bar\thumb\len )
          *BB2\height = *this\frame_height( )
          
          ; seperatior pos&size
          If *bar\thumb\len
            *SB\y      = *this\frame_y( )
            *SB\height = *this\frame_height( )
            *SB\x      = *this\inner_x( ) + *bar\thumb\pos
            *SB\width  = *bar\thumb\len
          EndIf
        EndIf
        
        ; Splitter first-child auto resize
        ;If mode = 2;*bar\PageChange( ) Or *bar\ThumbChange( ) 
        If IsGadget( *this\split_1( ) )
          ;             If is_root_container_( *this )
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            ; PB(ResizeGadget)( *this\split_1( ), DesktopUnScaledX(*BB1\x), DesktopUnScaledY(*BB1\y), DesktopUnScaledX(*BB1\width), DesktopUnScaledY(*BB1\height) )
            SetWindowPos_( GadgetID(*this\split_1( )), #HWND_TOP, *BB1\x, *BB1\y, *BB1\width, *BB1\height, #SWP_NOACTIVATE )
            UpdateWindow_(GadgetID(*this\split_1( )))
          CompilerElse
            PB(ResizeGadget)( *this\split_1( ), *BB1\x, *BB1\y, *BB1\width, *BB1\height )
          CompilerEndIf
          ;             Else
          ;               PB(ResizeGadget)( *this\split_1( ),
          ;                                 *BB1\x + GadgetX( *this\root\canvas\gadget ),
          ;                                 *BB1\y + GadgetY( *this\root\canvas\gadget ),
          ;                                 *BB1\width, *BB1\height )
          ;             EndIf
          
        Else
          If *this\split_1( ) > 0 And *this\split_1( ) <> *this
            If *this\split_1( )\x <> *BB1\x Or
               *this\split_1( )\y <> *BB1\y Or
               *this\split_1( )\width <> *BB1\width Or
               *this\split_1( )\height <> *BB1\height
              ; Debug "splitter_1_resize " + *this\split_1( )
              
              If *this\split_1( )\type = #__type_window
                Resize( *this\split_1( ),
                        *BB1\x - *this\frame_x( ),
                        *BB1\y - *this\frame_y( ),
                        *BB1\width - *this\split_1( )\fs * 2,
                        *BB1\height - *this\split_1( )\fs * 2 - *this\split_1( )\fs[2])
              Else
                Resize( *this\split_1( ),
                        *BB1\x - *this\frame_x( ),
                        *BB1\y - *this\frame_y( ),
                        *BB1\width, *BB1\height )
              EndIf
              
            EndIf
          EndIf
        EndIf
        
        ; Splitter second-child auto resize
        If IsGadget( *this\split_2( ) )
          ;             If is_root_container_( *this )
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            ; PB(ResizeGadget)( *this\split_2( ), DesktopUnScaledX(*BB2\x), DesktopUnScaledY(*BB2\y), DesktopUnScaledX(*BB2\width), DesktopUnScaledY(*BB2\height) )
            SetWindowPos_( GadgetID(*this\split_2( )), #HWND_TOP, *BB2\x, *BB2\y, *BB2\width, *BB2\height, #SWP_NOACTIVATE )
            UpdateWindow_(GadgetID(*this\split_2( )))
          CompilerElse
            PB(ResizeGadget)( *this\split_2( ), *BB2\x, *BB2\y, *BB2\width, *BB2\height )
          CompilerEndIf
          ;             Else
          ;               PB(ResizeGadget)( *this\split_2( ),
          ;                                 *BB2\x + GadgetX( *this\root\canvas\gadget ),
          ;                                 *BB2\y + GadgetY( *this\root\canvas\gadget ),
          ;                                 *BB2\width, *BB2\height )
          ;             EndIf
          
        Else
          If *this\split_2( ) > 0 And *this\split_2( ) <> *this
            If *this\split_2( )\x <> *BB2\x Or
               *this\split_2( )\y <> *BB2\y Or
               *this\split_2( )\width <> *BB2\width Or
               *this\split_2( )\height <> *BB2\height
              ; Debug "splitter_2_resize " + *this\split_2( )
              
              If *this\split_2( )\type = #__type_window
                Resize( *this\split_2( ),
                        *BB2\x - *this\frame_x( ),
                        *BB2\y - *this\frame_y( ),
                        *BB2\width - *this\split_1( )\fs * 2,
                        *BB2\height - *this\split_1( )\fs * 2 - *this\split_1( )\fs[2] )
              Else
                Resize( *this\split_2( ),
                        *BB2\x - *this\frame_x( ),
                        *BB2\y - *this\frame_y( ),
                        *BB2\width, *BB2\height )
              EndIf
              
            EndIf
          EndIf
        EndIf
        ;EndIf
      EndIf
      
      ;\\
      If *this\type = #__type_TrackBar
        If bar_in_start_( *bar ) Or 
           bar_in_stop_( *bar ) Or 
           BinaryFlag( *this\flag, #PB_TrackBar_Ticks )
          ;
          If *bar\vertical 
            If *bar\invert
              *SB\arrow\direction = 2 ; вправо
            Else
              *SB\arrow\direction = 0 ; влево
            EndIf
          Else
            If *bar\invert
              *SB\arrow\direction = 1 ; верх
            Else
              *SB\arrow\direction = 3 ; вниз
            EndIf
          EndIf
        Else
          If ( *bar\direction > 0 And *bar\invert ) Or 
             ( *bar\direction < 0 And Not *bar\invert )
            ;
            If *bar\vertical
              *SB\arrow\direction = 1 ; верх
            Else
              *SB\arrow\direction = 0 ; влево
            EndIf
          ElseIf ( *bar\direction < 0 And *bar\invert ) Or 
                 ( *bar\direction > 0 And Not *bar\invert )
            ;
            If *bar\vertical
              *SB\arrow\direction = 3 ; вниз
            Else
              *SB\arrow\direction = 2 ; вправо
            EndIf
          EndIf
        EndIf
        
        ; track bar draw coordinate
        If *bar\vertical
          If *bar\thumb\len
            *SB\y      = *this\frame_y( ) + *bar\thumb\pos
            *SB\height = *bar\thumb\len
          EndIf
          
          *BB1\width = DesktopScaled( #__tracksize )
          *BB2\width = *BB1\width
          *SB\width  = *SB\size + ( Bool( *SB\size < 10 ) * *SB\size )
          
          *BB1\y      = *this\frame_y( )
          *BB1\height = *bar\thumb\pos
          
          *BB2\y      = *BB1\y + *BB1\height + *bar\thumb\len
          *BB2\height = *this\frame_height( ) - *bar\thumb\pos - *bar\thumb\len
          
          If *bar\invert
            *BB1\x = *this\frame_x( ) + DesktopScaled(6)
          Else
            *BB1\x = *this\frame_x( ) + *this\frame_width( ) + DesktopScaled(6) - *SB\size - 1
          EndIf
          
          *BB2\x = *BB1\x
          *SB\x  = *BB1\x - ( *SB\size - *BB1\width )/2
        Else
          If *bar\thumb\len
            *SB\x     = *this\frame_x( ) + *bar\thumb\pos
            *SB\width = *bar\thumb\len
          EndIf
          
          *BB1\height = DesktopScaled( #__tracksize )
          *BB2\height = *BB1\height
          *SB\height  = *SB\size + ( Bool( *SB\size < 10 ) * *SB\size )
          
          *BB1\x     = *this\frame_x( )
          *BB1\width = *bar\thumb\pos
          
          *BB2\x     = *BB1\x + *BB1\width + *bar\thumb\len
          *BB2\width = *this\frame_width( ) - *bar\thumb\pos - *bar\thumb\len
          
          If *bar\invert
            *BB1\y = *this\frame_y( ) + *this\frame_height( ) + DesktopScaled(6) - *SB\size - 1
          Else
            *BB1\y = *this\frame_y( ) + DesktopScaled(6)
          EndIf
          
          *BB2\y = *BB1\y
          *SB\y  = *BB1\y - ( *SB\size - *BB1\height )/2
        EndIf
      EndIf
      
      ;\\
      If *this\type = #__type_ToolBarBar Or
         *this\type = #__type_TabBarBar Or
         *this\type = #__type_MenuBar
        ;
        ; inner coordinate
        If *bar\vertical
          *this\inner_x( )      = *this\frame_x( )
          *this\inner_width( )  = *this\frame_width( ) - 1
          *this\inner_y( )      = *this\frame_y( ) + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
          *this\inner_height( ) = *this\frame_y( ) + *this\frame_height( ) - *this\inner_y( ) - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
        Else
          *this\inner_y( )      = *this\frame_y( )
          *this\inner_height( ) = *this\frame_height( ) - 1
          *this\inner_x( )      = *this\frame_x( ) + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
          *this\inner_width( )  = *this\frame_x( ) + *this\frame_width( ) - *this\inner_x( ) - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
        EndIf
        
        If *BB2\size And Not *BB2\hide
          If *bar\vertical
            ; Top button coordinate on vertical scroll bar
            ;  *BB2\x = *this\frame_x( ) + ( *this\frame_width( ) - *BB2\size )/2
            *BB2\y = *this\inner_y( ) - *BB2\size
          Else
            ; Left button coordinate on horizontal scroll bar
            *BB2\x = *this\inner_x( ) - *BB2\size
            ;  *BB2\y = *this\frame_y( ) + ( *this\frame_height( ) - *BB2\size )/2
          EndIf
          If *BB2\width <> *BB2\size
            *BB2\width = *BB2\size
          EndIf
          If *BB2\height <> *BB2\size
            *BB2\height = *BB2\size
          EndIf
        EndIf
        
        If *BB1\size And Not *BB1\hide
          If *bar\vertical
            ; Botom button coordinate on vertical scroll bar
            ;  *BB1\x = *this\frame_x( ) + ( *this\frame_width( ) - *BB1\size )/2
            *BB1\y = *this\inner_y( ) + *this\inner_height( )
          Else
            ; Right button coordinate on horizontal scroll bar
            *BB1\x = *this\inner_x( ) + *this\inner_width( )
            ;  *BB1\y = *this\frame_y( ) + ( *this\frame_height( ) - *BB1\size )/2
          EndIf
          If *BB1\width <> *BB1\size
            *BB1\width = *BB1\size
          EndIf
          If *BB1\height <> *BB1\size
            *BB1\height = *BB1\size
          EndIf
        EndIf
        
        ;If *bar\thumb\len
        If *bar\vertical
          *SB\x      = *this\inner_x( )
          *SB\width  = *this\inner_width( )
          *SB\height = *bar\max
          *SB\y      = *this\frame_y( ) + ( *bar\thumb\pos - *bar\area\end )
        Else
          *SB\y      = *this\inner_y( )
          *SB\height = *this\inner_height( )
          *SB\width  = *bar\max
          *SB\x      = *this\frame_x( ) + ( *bar\thumb\pos - *bar\area\end )
        EndIf
        ;EndIf
      EndIf
      
      ;\\ Ok
      If *this\type = #__type_Spin
        *SB\x      = *this\inner_x( )
        *SB\y      = *this\inner_y( )
        *SB\width  = *this\inner_width( )
        *SB\height = *this\inner_height( )
        
        If Not *this\flag & #__spin_Plus
          Protected draw_tipe = 1
          If *BB2\size
            *BB2\x      = ( *this\frame_x( ) + *this\frame_width( ) ) - *SB\size + draw_tipe * 2
            *BB2\y      = *this\frame_y( ) + draw_tipe * 2
            *BB2\width  = *SB\size - draw_tipe * 4
            *BB2\height = *BB2\size - draw_tipe * 3
          EndIf
          If *BB1\size
            *BB1\x      = *BB2\x
            *BB1\y      = ( *this\frame_y( ) + *this\frame_height( ) ) - *BB1\size + draw_tipe
            *BB1\height = *BB1\size - draw_tipe * 3
            *BB1\width  = *BB2\width
          EndIf
        Else
          ; spin buttons numeric plus -/+
          If *bar\vertical
            If *BB1\size
              *BB1\x      = *this\frame_x( )
              *BB1\y      = ( *this\frame_y( ) + *this\frame_height( ) ) - *BB1\size
              *BB1\width  = *this\frame_width( )
              *BB1\height = *BB1\size
            EndIf
            If *BB2\size
              *BB2\x      = *this\frame_x( )
              *BB2\y      = *this\frame_y( )
              *BB2\width  = *this\frame_width( )
              *BB2\height = *BB2\size
            EndIf
          Else
            If *BB1\size
              *BB1\x      = *this\frame_x( )
              *BB1\y      = *this\frame_y( )
              *BB1\width  = *BB1\size
              *BB1\height = *this\frame_height( )
            EndIf
            If *BB2\size
              *BB2\x      = ( *this\frame_x( ) + *this\frame_width( ) ) - *BB2\size
              *BB2\y      = *this\frame_y( )
              *BB2\width  = *BB2\size
              *BB2\height = *this\frame_height( )
            EndIf
          EndIf
        EndIf
      EndIf
      
      ; ;          
      ; ;          ;Debug ">>>>>>>>>"+Str(*bar)+">>>>>>>>"
      ; ;          Debug " - ["+ *this\class +"] "+
      ; ;                *bar\percent +" >< "+
      ; ;                *bar\min +" "+
      ; ;                *bar\max +" >< "+
      ; ;                *bar\page\pos +" "+
      ; ;                *bar\page\len +" "+
      ; ;                *bar\page\end +" "+
      ; ;                *bar\page\change +" >< "+
      ; ;                *bar\area\pos +" "+
      ; ;                *bar\area\len +" "+
      ; ;                *bar\area\end +" "+
      ; ;                *bar\area\change +" >< "+
      ; ;                *bar\thumb\pos +" "+
      ; ;                *bar\thumb\len +" "+
      ; ;                *bar\thumb\end +" "+
      ; ;                *bar\thumb\change +""
      ; ;          Debug "<<<<<<<<<<<<<<<<<"
      ;  
      
      
      ;\\
      If *bar\PageChange( )
        ;\\ post change event
        If mode = 2
          If is_scrollbars_( *this )
            If *this\type = #__type_ScrollBar
              Send( *this\parent, #__event_ScrollChange, *this, *bar\PageChange( ) )
            EndIf
          Else
            ; scroll area change
            Send( *this, #__event_Change, EnteredButton( ), *bar\PageChange( ) )
          EndIf  
          
          ;               If *this\StringBox( )
          ;                 Debug 777
          ;                 Send( *this\parent, #__event_ScrollChange, *this, *bar\PageChange( ) )
          ;               EndIf
        EndIf
        
        *this\BarChange( ) = 0
        *bar\PageChange( ) = 0
        *bar\ThumbChange( ) = 0
        
        ;*this\root\repaint  = #True
        ProcedureReturn #True   
      EndIf
    EndProcedure
    
    Procedure.b bar_PageChange( *this._s_WIDGET, ScrollPos.l, mode.b = 1 )
      Protected result.b, *bar._s_BAR = *this\bar
      
      If *bar\area\len
        If Not *bar\max
          *bar\page\end = *bar\area\len - *bar\thumb\len
        EndIf
        
        ;????
        If *bar\thumb\len
          If *bar\thumb\len = *bar\thumb\end 
            ScrollPos = *bar\min
          EndIf
        EndIf
        
        If ScrollPos > *bar\page\end - *bar\min[2]
          ScrollPos = *bar\page\end - *bar\min[2]
        EndIf
      EndIf
      
      If Not *bar\button\disable 
        If ScrollPos < *bar\min
          If *bar\max > *bar\page\len
            ScrollPos = *bar\min
          EndIf
        EndIf
        If ScrollPos > *bar\page\end
          If *bar\page\end
            ScrollPos = *bar\page\end
          Else
            If *bar\area\end ; TODO - ? example-splitter(3)
              ScrollPos = bar_page_pos_( *bar, *bar\area\end ) - ScrollPos
            EndIf
          EndIf
        EndIf
        
        If *bar\page\pos <> ScrollPos
          If *bar\page\pos > ScrollPos
            *bar\direction =- 1
          Else
            *bar\direction = 1
          EndIf
          ;
          *bar\PageChange( ) = *bar\page\pos - ScrollPos
          *bar\page\pos      = ScrollPos
          
          ; Debug ""+ScrollPos +" "+ *bar\page\end +" "+ *bar\thumb\len +" "+ *bar\thumb\end +" "+ *bar\page\pos +" "+ Str(*bar\page\end-*bar\min[2])
          
          result = *bar\PageChange( )
        EndIf
        
        If *bar\PageChange( ) Or
           *this\BarChange( ) 
          ;
          If bar_Update( *this, mode)
            
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b bar_ThumbChange( *this._s_WIDGET, ThumbPos.i )
      Protected *bar._s_BAR = *this\bar
      Protected ScrollPos.f
      
      If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
      If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
      
      If *bar\thumb\pos <> ThumbPos
        *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
        *bar\thumb\pos = ThumbPos
        
        If *this\child
          *this\parent\redraw = 1
        Else
          *this\redraw = 1
        EndIf
        
        If Not ( *this\type = #__type_trackbar And BinaryFlag( *this\flag, #PB_TrackBar_Ticks ))
          *this\BarChange( ) = 1
        EndIf
        
        ScrollPos = bar_page_pos_( *bar, ThumbPos )
        ScrollPos = bar_invert_page_pos_( *bar, ScrollPos )
        bar_PageChange( *this, ScrollPos, 2 ) ; and post change event 
        ProcedureReturn #True
      EndIf
    EndProcedure
    
    Procedure.l bar_SetAttribute( *this._s_WIDGET, Attribute.l, *value )
      Protected result.l
      Protected value = *value
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *bar\button
      *BB1 = *bar\button[1]
      *BB2 = *bar\button[2]
      
      With *this
        ;\\
        If Attribute = #__bar_invert
          If *bar\invert <> Bool( value )
            *bar\invert = Bool( value )
            result      = 1
          EndIf
        EndIf
        
        ;\\
        If Attribute = #__bar_ScrollStep
          If *this\scroll\increment <> value
            *this\scroll\increment = value
            result                 = 1
          EndIf
        EndIf
        
        ;\\
        If *this\type = #__type_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              *bar\min[1] = DesktopScaled(*value)
              result = Bool( *bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *bar\min[2] = DesktopScaled(*value)
              result = Bool( *bar\max )
              
            Case #PB_Splitter_FirstGadget
              *this\split_1( )    = *value
              result              = - 1
              
            Case #PB_Splitter_SecondGadget
              *this\split_2( )    = *value
              result              = - 1
              
          EndSelect
        EndIf
        
        ;\\
        If *this\type <> #__type_Splitter
          Select Attribute
            Case #__bar_minimum
              If *bar\min <> *value ;And Not *value < 0
                                    ;*bar\AreaChange( ) = *bar\min - value
                If *bar\page\pos < *value
                  *bar\page\pos = *value
                EndIf
                *bar\min = *value
                ; Debug  " min " + *bar\min + " max " + *bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If *bar\max <> *value ;And Not ( *value < 0 And Not #__bar_minus)
                                    ;*bar\AreaChange( ) = *bar\max - value
                
                If *bar\min > *value ;And Not #__bar_minus
                  *bar\max = *bar\min + 1
                Else
                  *bar\max = *value
                EndIf
                ;
                If Not *bar\max ;And Not #__bar_minus
                  *bar\page\pos = *bar\max
                EndIf
                ; Debug  "   min " + *bar\min + " max " + *bar\max
                
                ;\\
                If *bar And *this\parent And is_integral_( *this )
                  If *bar\vertical
                    *this\parent\scroll_height( ) = *bar\max
                  Else
                    *this\parent\scroll_width( ) = *bar\max
                  EndIf
                EndIf
                
                result = #True
              EndIf
              
            Case #__bar_pagelength
              If *bar\page\len <> *value ;And Not ( *value < 0 And Not #__bar_minus )
                                         ;*bar\AreaChange( ) = *bar\page\len - value
                *bar\page\len      = *value
                
                If Not *bar\max ;And Not #__bar_minus
                  If *bar\min > *value
                    *bar\max = *bar\min + 1
                  Else
                    *bar\max = *value
                  EndIf
                EndIf
                
                result = #True
              EndIf
              
            Case #__bar_buttonsize
              If *SB\size <> *value
                *SB\size = *value
                
                If *this\type = #__type_spin
                  If *this\flag & #__spin_plus
                    ; set real spin-buttons width
                    *BB1\size = *value
                    *BB2\size = *value
                    
                    If *bar\vertical
                      *this\fs[2] = *BB2\size - 1
                      *this\fs[4] = *BB1\size - 1
                    Else
                      *this\fs[1] = *BB1\size - 1
                      *this\fs[3] = *BB2\size - 1
                    EndIf
                  Else
                    If *bar\vertical
                      If *bar\invert
                        *this\fs[1] = *value - 1
                      Else
                        *this\fs[3] = *value - 1
                      EndIf
                    Else
                      If *bar\invert
                        *this\fs[2] = *value - 1
                      Else
                        *this\fs[4] = *value - 1
                      EndIf
                    EndIf
                  EndIf
                  
                  
                Else
                  ; to reset the button size to default
                  If *this\type = #__type_ToolBarBar Or
                     *this\type = #__type_TabBarBar Or
                     *this\type = #__type_MenuBar Or
                     *this\type = #__type_ScrollBar
                    ;
                    If *value
                      *BB1\size = - 1
                      *BB2\size = - 1
                      *BB1\hide = 0
                      *BB2\hide = 0
                    Else
                      *BB1\size = 0
                      *BB2\size = 0
                      *BB1\hide = 1
                      *BB2\hide = 1
                    EndIf
                  EndIf
                  
                  ; if it is a composite element of the parent
                  If is_integral_( *this ) And *this\parent And *value
                    *value + 1
                    If *bar\vertical
                      Resize(*this, *this\parent\container_width( ) - *value, #PB_Ignore, *value, #PB_Ignore)
                    Else
                      Resize(*this, #PB_Ignore, *this\parent\container_width( ) - *value, #PB_Ignore, *value)
                    EndIf
                  EndIf
                  
                  bar_Update( *this, #True )
                  PostRepaint( *this\root )
                  ProcedureReturn #True
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        
        
        If result ; And *this\width And *this\height ; есть проблемы с imagegadget и scrollareagadget
                  ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          
          ;If *this\root ;And *this\root\canvas\postevent = #False
          If ( *bar\vertical And *this\height ) Or ( *bar\vertical = 0 And *this\width )
            ; Debug "bar_SetAttribute - "+*this\height +" "+ *this\width +" "+ *bar\vertical
            bar_Update( *this, #True ) ; ??????????????
          EndIf
          ;EndIf
          
          ; after update and resize bar
          If *this\type = #__type_ScrollBar And
             Attribute = #__bar_buttonsize
            *BB1\size = - 1
            *BB2\size = - 1
          EndIf
          
          If *this\type = #__type_Splitter
            If result = - 1
              SetParent(*value, *this)
            EndIf
          EndIf
        EndIf
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure bar_Events( *this._s_WIDGET, eventtype.l )
      Protected result.b
      Protected *bar._s_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      
      If *bar
        *SB  = *bar\button
        *BB1 = *bar\button[1]
        *BB2 = *bar\button[2]
      EndIf
      
      ;\\
      If eventtype = #__event_MouseEnter
        If is_integral_( *this )
          *this\parent\bar = *this\bar
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_MouseLeave Or
         eventtype = #__event_Up
        ;
        If Not mouse( )\press 
          If is_integral_( *this )
            If *this\parent\bar
              *this\parent\bar = #Null
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_Down
        If mouse( )\buttons & #PB_Canvas_LeftButton
          If *this\type = #__type_Splitter
            ;                   Static item = 0
            ;                   
            ;                   If EnteredButton( ) = *SB
            ;                      If *this\split_1( ) And *this\split_1( )\haschildren
            ;                         *this\split_1( )\resize\nochildren = 1
            ;                         If *this\split_1( )\type = #__type_Panel
            ;                            item = GetState( *this\split_1( ) )
            ;                         EndIf
            ;                         
            ;                         If StartEnumerate( *this\split_1( ), item )
            ;                            widget( )\resize\hide = widget( )\hide
            ;                            widget( )\hide = 1
            ;                            StopEnumerate( )
            ;                         EndIf
            ;                      EndIf
            ;                      If *this\split_2( ) And *this\split_2( )\haschildren
            ;                         *this\split_2( )\resize\nochildren = 1
            ;                         If *this\split_2( )\type = #__type_Panel
            ;                            item = GetState( *this\split_2( ) )
            ;                         EndIf
            ;                         
            ;                         If StartEnumerate( *this\split_2( ), item )
            ;                            ;Debug widget( )\class
            ;                            widget( )\resize\hide = widget( )\hide
            ;                            widget( )\hide = 1
            ;                            StopEnumerate( )
            ;                         EndIf
            ;                      EndIf
            ;                   EndIf
          EndIf
          
          ;\\
          If EnteredButton( ) And
             EnteredButton( )\press = #False And
             EnteredButton( )\disable = #False And
             EnteredButton( )\ColorState( ) <> #__s_3 ; change the color state of non-disabled buttons
            
            PressedButton( )       = EnteredButton( )
            PressedButton( )\press = #True
            
            If Not ( *this\type = #__type_TrackBar Or
                     ( *this\type = #__type_Splitter And PressedButton( ) <> *SB ))
              PressedButton( )\ColorState( ) = #__s_2
            EndIf
            
            ;
            If ( *BB2\press And *bar\invert ) Or
               ( *BB1\press And Not *bar\invert )
              
              If *this\type = #__type_spin
                If bar_PageChange( *this, *bar\page\pos - *this\scroll\increment )
                  result = #True
                EndIf
              Else
                If bar_ThumbChange( *this, *bar\thumb\pos - *this\scroll\increment )
                  result = #True
                EndIf
              EndIf
            ElseIf ( *BB1\press And *bar\invert ) Or
                   ( *BB2\press And Not *bar\invert )
              
              If *this\type = #__type_spin
                If bar_PageChange( *this, *bar\page\pos + *this\scroll\increment )
                  result = #True
                EndIf
              Else
                If bar_ThumbChange( *this, *bar\thumb\pos + *this\scroll\increment )
                  result = #True
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;\\
          If *this\tab
            *this\TabPressed( ) = *this\TabEntered( )
            
            ;                                              ;
            If Not ( EnteredButton( ) And EnteredButton( )\press And EnteredButton( ) <> *SB )
              If *this\TabPressed( ) And
                 *this\TabPressed( )\press = #False
                *this\TabPressed( )\press = #True
                
                *this\TabPressed( )\ColorState( ) = #__s_2
                result = #True
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_Up
        If mouse( )\buttons & #PB_Canvas_LeftButton
          If PressedButton( ) And
             PressedButton( )\press = #True
            PressedButton( )\press = #False
            
            If PressedButton( )\disable = #False And
               PressedButton( )\ColorState( ) <> #__s_3
              
              ; change color state
              If PressedButton( )\ColorState( ) = #__s_2 And
                 Not ( *this\type = #__type_TrackBar Or
                       ( *this\type = #__type_Splitter And PressedButton( ) <> *SB ))
                
                If PressedButton( )\enter
                  PressedButton( )\ColorState( ) = #__s_1
                Else
                  PressedButton( )\ColorState( ) = #__s_0
                EndIf
              EndIf
              
              result = #True
            EndIf
          EndIf
          
          ;\\
          If *this\TabPressed( )
            If *this\TabPressed( )\press = #True
              *this\TabPressed( )\press = #False
              
              If *this\TabPressed( )\enter
                *this\TabPressed( )\ColorState( ) = #__s_1
              Else
                *this\TabPressed( )\ColorState( ) = #__s_0
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_LeftClick
      EndIf
      
      ;\\
      If eventtype = #__event_MouseMove
        If *SB\press
          If *bar\vertical
            If bar_ThumbChange( *this, ( mouse( )\y - mouse( )\delta\y ))
              result = #True
            EndIf
          Else
            If bar_ThumbChange( *this, ( mouse( )\x - mouse( )\delta\x ))
              result = #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    ;}
    
    
    
    
    
    
    
    
    
    ;-
    Macro set_state_list_( _address_, _state_ )
      If _state_ > 0
        If *this\mode\clickSelect
          If _address_\enter = #False
            _address_\enter = #True
          EndIf
        Else
          If _address_\press = #False
            _address_\press = #True
          EndIf
        EndIf
        
        If _address_\press = #True
          _address_\ColorState( ) = #__s_2
        ElseIf _address_\enter
          _address_\ColorState( ) = #__s_1
        EndIf
        
      ElseIf _address_
        If Not *this\mode\clickSelect
          If _address_\press = #True
            _address_\press = #False
          EndIf
        EndIf
        
        If _address_\enter
          _address_\enter = #False
        EndIf
        
        If _address_\press = #False
          _address_\ColorState( ) = #__s_0
        EndIf
      EndIf
    EndMacro
    
    Macro _multi_select_items_( _this_, _current_row_ )
    EndMacro
    
    
    Procedure.l Tree_KeyEvents( *this._s_WIDGET, List  *items._s_ROWS( ), eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
    EndProcedure
    
    Procedure.l ListView_KeyEvents( *this._s_WIDGET,List  *items._s_ROWS( ), eventtype.l, *item._s_ROWS, item = - 1 )
    EndProcedure
    
    Procedure.l Tree_events( *this._s_WIDGET, eventtype.l, mouse_x.l, mouse_y.l )
    EndProcedure
    
    ;-
    Procedure.i ToPBEventType( event.i )
      If event = #__event_Enter
        ProcedureReturn #PB_EventType_MouseEnter
      EndIf
      If event = #__event_Leave
        ProcedureReturn #PB_EventType_MouseLeave
      EndIf
      If event = #__event_MouseMove
        ProcedureReturn #PB_EventType_MouseMove
      EndIf
      If event = #__event_Focus
        ProcedureReturn #PB_EventType_Focus
      EndIf
      If event = #__event_LostFocus
        ProcedureReturn #PB_EventType_LostFocus
      EndIf
      
      If event = #__event_Resize
        ProcedureReturn #PB_EventType_Resize
      EndIf
      If event = #__event_Change
        ProcedureReturn #PB_EventType_Change
      EndIf
      If event = #__event_StatusChange
        ProcedureReturn #PB_EventType_StatusChange
      EndIf
      If event = #__event_Down
        ProcedureReturn #PB_EventType_Down
      EndIf
      If event = #__event_Up
        ProcedureReturn #PB_EventType_Up
      EndIf
      
      If event = #__event_DragStart
        ProcedureReturn #PB_EventType_DragStart
      EndIf
      If event = #__event_Input
        ProcedureReturn #PB_EventType_Input
      EndIf
      If event = #__event_KeyDown
        ProcedureReturn #PB_EventType_KeyDown
      EndIf
      If event = #__event_KeyUp
        ProcedureReturn #PB_EventType_KeyUp
      EndIf
      
      If event = #__event_LeftButtonDown
        ProcedureReturn #PB_EventType_LeftButtonDown
      EndIf
      If event = #__event_LeftButtonUp
        ProcedureReturn #PB_EventType_LeftButtonUp
      EndIf
      If event = #__event_LeftClick
        ProcedureReturn #PB_EventType_LeftClick
      EndIf
      If event = #__event_Left2Click
        ProcedureReturn #PB_EventType_LeftDoubleClick
      EndIf
      
      If event = #__event_RightButtonDown
        ProcedureReturn #PB_EventType_RightButtonDown
      EndIf
      If event = #__event_RightButtonUp
        ProcedureReturn #PB_EventType_RightButtonUp
      EndIf
      If event = #__event_RightClick
        ProcedureReturn #PB_EventType_RightClick
      EndIf
      If event = #__event_Right2Click
        ProcedureReturn #PB_EventType_RightDoubleClick
      EndIf
      
      ;       If event = #__event_PopupWindow
      ;          ProcedureReturn #PB_EventType_PopupWindow
      ;       EndIf
      ;       If event = #__event_PopupMenu
      ;          ProcedureReturn #PB_EventType_PopupMenu
      ;       EndIf
    EndProcedure
    
    Procedure.q FromPBFlag( Type, Flag.q )
      Protected flags.q = Flag
      
      Select Type
        Case #__type_window
          If BinaryFlag( Flag, #PB_Window_BorderLess )
            flags & ~ #PB_Window_BorderLess
            flags | #__flag_BorderLess
          EndIf
          ;
        Case #__type_Container
          ;                If BinaryFlag( Flag, #PB_Container_BorderLess ) 
          ;                   flags & ~ #PB_Container_BorderLess
          ;                   flags = #__flag_BorderLess
          ;                EndIf
          If BinaryFlag( Flag, #PB_Container_Flat )
            flags & ~ #PB_Container_Flat
            flags = #__flag_BorderFlat
          EndIf
          If BinaryFlag( Flag, #PB_Container_Single )
            flags & ~ #PB_Container_Single
            flags = #__flag_BorderSingle
          EndIf
          If BinaryFlag( Flag, #PB_Container_Raised ) 
            flags & ~ #PB_Container_Raised
            flags = #__flag_BorderRaised
          EndIf
          If BinaryFlag( Flag, #PB_Container_Double )
            flags & ~ #PB_Container_Double
            flags = #__flag_BorderDouble
          EndIf
          ;
        Case #__type_Frame
          ;                If BinaryFlag( Flag, #PB_Frame_BorderLess ) 
          ;                   flags & ~ #PB_Frame_BorderLess
          ;                   flags = #__flag_BorderLess
          ;                EndIf
          If BinaryFlag( Flag, #PB_Frame_Flat )
            flags & ~ #PB_Frame_Flat
            flags = #__flag_BorderFlat
          EndIf
          If BinaryFlag( Flag, #PB_Frame_Single )
            flags & ~ #PB_Frame_Single
            flags = #__flag_BorderSingle
          EndIf
          ;                If BinaryFlag( Flag, #PB_Frame_Raised ) 
          ;                   flags & ~ #PB_Frame_Raised
          ;                   flags = #__flag_BorderRaised
          ;                EndIf
          If BinaryFlag( Flag, #PB_Frame_Double )
            flags & ~ #PB_Frame_Double
            flags = #__flag_BorderDouble
          EndIf
          ;
        Case #__type_MDI
          If BinaryFlag( Flag, #PB_MDI_AutoSize ) 
            flags & ~ #PB_MDI_AutoSize
            flags | #__flag_AutoSize
          EndIf
          If BinaryFlag( Flag, #PB_MDI_BorderLess )
            flags & ~ #PB_MDI_BorderLess
            flags | #__flag_BorderLess
          EndIf
          ;
        Case #__type_CheckBox
          If BinaryFlag( Flag, #PB_CheckBox_Right )
            flags & ~ #PB_CheckBox_Right
            flags | #__flag_Textright
          EndIf
          If BinaryFlag( Flag, #PB_CheckBox_Center )
            flags & ~ #PB_CheckBox_Center
            flags | #__flag_Textcenter
          EndIf
          ;
        Case #__type_Text
          If BinaryFlag( Flag, #PB_Text_Center )
            flags & ~ #PB_Text_Center
            flags | #__flag_Textcenter
            ;flags & ~ #__flag_Textleft
          EndIf
          If BinaryFlag( Flag, #PB_Text_Right )
            flags & ~ #PB_Text_Right
            flags | #__flag_Textright
          EndIf
          ;
        Case #__type_Button ; ok
          If BinaryFlag( Flag, #PB_Button_MultiLine ) 
            flags & ~ #PB_Button_MultiLine
            flags | #__flag_Textwordwrap
          EndIf
          If BinaryFlag( Flag, #PB_Button_Left ) 
            flags & ~ #PB_Button_Left
            flags | #__flag_Textleft
          EndIf
          If BinaryFlag( Flag, #PB_Button_Right ) 
            flags & ~ #PB_Button_Right
            flags | #__flag_Textright
          EndIf
          ;
        Case #__type_String ; ok
          If BinaryFlag( Flag, #PB_String_Password ) 
            flags & ~ #PB_String_Password
            flags | #__flag_Textpassword
          EndIf
          If BinaryFlag( Flag, #PB_String_LowerCase )
            flags & ~ #PB_String_LowerCase
            flags | #__flag_Textlowercase
          EndIf
          If BinaryFlag( Flag, #PB_String_UpperCase ) 
            flags & ~ #PB_String_UpperCase
            flags | #__flag_Textuppercase
          EndIf
          If BinaryFlag( Flag, #PB_String_BorderLess )
            flags & ~ #PB_String_BorderLess
            flags | #__flag_BorderLess
          EndIf
          If BinaryFlag( Flag, #PB_String_Numeric ) 
            flags & ~ #PB_String_Numeric
            flags | #__flag_Textnumeric
          EndIf
          If BinaryFlag( Flag, #PB_String_ReadOnly )
            flags & ~ #PB_String_ReadOnly
            flags | #__flag_Textreadonly
          EndIf
          ;
        Case #__type_Editor
          If BinaryFlag( Flag, #PB_Editor_ReadOnly ) 
            flags & ~ #PB_Editor_ReadOnly
            flags | #__flag_Textreadonly
          EndIf
          If BinaryFlag( Flag, #PB_Editor_WordWrap ) 
            flags & ~ #PB_Editor_WordWrap
            flags | #__flag_Textwordwrap
          EndIf
          ;
        Case #__type_Tree
          If BinaryFlag( Flag, #PB_Tree_AlwaysShowSelection ) 
            flags & ~ #PB_Tree_AlwaysShowSelection
          EndIf
          If BinaryFlag( Flag, #PB_Tree_CheckBoxes ) 
            flags & ~ #PB_Tree_CheckBoxes
            flags | #__tree_checkboxes
          EndIf
          If BinaryFlag( Flag, #PB_Tree_ThreeState ) 
            flags & ~ #PB_Tree_ThreeState
            flags | #__tree_threestate
          EndIf
          If BinaryFlag( Flag, #PB_Tree_NoButtons )
            flags & ~ #PB_Tree_NoButtons
            flags | #__tree_nobuttons
          EndIf
          If BinaryFlag( Flag, #PB_Tree_NoLines ) 
            flags & ~ #PB_Tree_NoLines
            flags | #__tree_nolines
          EndIf
          ;   
        Case #__type_ListView ; Ok
          If BinaryFlag( Flag, #PB_ListView_ClickSelect ) 
            flags & ~ #PB_ListView_ClickSelect
            flags | #__flag_clickselect
          EndIf
          If BinaryFlag( Flag, #PB_ListView_MultiSelect ) 
            flags & ~ #PB_ListView_MultiSelect
            flags | #__flag_multiselect
          EndIf
          ;  
        Case #__type_listicon
          If BinaryFlag( Flag, #PB_ListIcon_AlwaysShowSelection ) 
            flags & ~ #PB_ListIcon_AlwaysShowSelection
          EndIf
          If BinaryFlag( Flag, #PB_ListIcon_CheckBoxes )
            flags & ~ #PB_ListIcon_CheckBoxes
            flags | #__tree_checkboxes
          EndIf
          If BinaryFlag( Flag, #PB_ListIcon_ThreeState )
            flags & ~ #PB_ListIcon_ThreeState
            flags | #__tree_threestate
          EndIf
          
      EndSelect
      
      ProcedureReturn flags
    EndProcedure
    
    Procedure.q ToPBFlag( Type, Flag.q )
      Protected flags.q = Flag
      
      Select Type
        Case #__type_Container
          If BinaryFlag( Flag, #__flag_BorderLess )
            flags & ~ #__flag_BorderLess
            flags | #PB_Container_BorderLess
          EndIf
          If BinaryFlag( Flag, #__flag_BorderFlat )
            flags & ~ #__flag_BorderFlat
            flags | #PB_Container_Flat
          EndIf
          If BinaryFlag( Flag, #__flag_BorderSingle )
            flags & ~ #__flag_BorderSingle
            flags | #PB_Container_Single
          EndIf
          If BinaryFlag( Flag, #__flag_BorderRaised )
            flags & ~ #__flag_BorderRaised
            flags | #PB_Container_Raised
          EndIf
          If BinaryFlag( Flag, #__flag_BorderDouble ) 
            flags & ~ #__flag_BorderDouble
            flags | #PB_Container_Double
          EndIf
          
        Case #__type_Button
          If BinaryFlag( Flag, #__flag_Textwordwrap ) 
            flags & ~ #__flag_Textwordwrap
            flag | #PB_Button_MultiLine
          EndIf
          If BinaryFlag( Flag, #__flag_Textleft ) 
            flags & ~ #__flag_Textleft
            flags | #PB_Button_Left
          EndIf
          If BinaryFlag( Flag, #__flag_Textright ) 
            flags & ~ #__flag_Textright
            flags | #PB_Button_Right
          EndIf
      EndSelect
      
      ProcedureReturn flags
    EndProcedure
    
    Procedure.i get_item_( *this._s_WIDGET, parent_sublevel.l = - 1 ) ;???
    EndProcedure
    
    Procedure.q Flag( *this._s_WIDGET, flag.q = #Null, state.b = #PB_Default )
    EndProcedure
    
    ;-
    Procedure.i TypeFromClass( class.s )
      Protected result.i
      
      Select Trim( LCase( class.s ))
        Case "popupmenu" : result = #__type_PopupBar
          ;case "property"       : result = #__type_property
        Case "window" : result = #__type_window
          
        Case "button" : result = #__type_Button
        Case "buttonimage" : result = #__type_ButtonImage
        Case "calendar" : result = #__type_Calendar
        Case "canvas" : result = #PB_GadgetType_Canvas
        Case "checkbox" : result = #__type_CheckBox
        Case "combobox" : result = #__type_ComboBox
        Case "container" : result = #__type_Container
        Case "date" : result = #__type_Date
        Case "editor" : result = #__type_Editor
        Case "explorercombo" : result = #__type_ExplorerCombo
        Case "explorerlist" : result = #__type_ExplorerList
        Case "explorertree" : result = #__type_ExplorerTree
        Case "frame" : result = #__type_Frame
        Case "hyperlink" : result = #__type_HyperLink
        Case "image" : result = #__type_Image
        Case "ipaddress" : result = #__type_IPAddress
        Case "listicon" : result = #__type_ListIcon
        Case "listview" : result = #__type_ListView
        Case "mdi" : result = #__type_MDI
        Case "opengl" : result = #__type_OpenGL
        Case "option" : result = #__type_Option
        Case "panel" : result = #__type_Panel
        Case "progress" : result = #__type_ProgressBar
        Case "scintilla" : result = #__type_Scintilla
        Case "scrollarea" : result = #__type_ScrollArea
        Case "scroll" : result = #__type_ScrollBar
        Case "shortcut" : result = #__type_Shortcut
        Case "spin" : result = #__type_Spin
        Case "splitter" : result = #__type_Splitter
        Case "string" : result = #__type_String
        Case "text" : result = #__type_Text
        Case "track" : result = #__type_TrackBar
        Case "tree" : result = #__type_Tree
        Case "unknown" : result = #__type_Unknown
        Case "web" : result = #__type_Web
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s ClassFromType( type.i )
      Protected result.s
      
      Select type
        Case #__type_root : result.s = "root"
        Case #__type_statusbar : result.s = "status"
        Case #__type_PopupBar : result.s = "popupmenu"
        Case #__type_ToolBarbar : result.s = "tool"
        Case #__type_TabBarbar : result.s = "tab"
        Case #__type_MenuBar : result.s = "menu"
          
        Case #__type_window : result.s = "window"
        Case #__type_Unknown : result.s = "create"
        Case #__type_Button : result.s = "button"
        Case #__type_String : result.s = "string"
        Case #__type_Text : result.s = "text"
        Case #__type_CheckBox : result.s = "checkbox"
        Case #__type_Option : result.s = "option"
        Case #__type_ListView : result.s = "listview"
        Case #__type_Frame : result.s = "frame"
        Case #__type_ComboBox : result.s = "combobox"
        Case #__type_Image : result.s = "image"
        Case #__type_HyperLink : result.s = "hyperlink"
        Case #__type_Container : result.s = "container"
        Case #__type_ListIcon : result.s = "listicon"
        Case #__type_IPAddress : result.s = "ipaddress"
        Case #__type_ProgressBar : result.s = "progress"
        Case #__type_ScrollBar : result.s = "scroll"
        Case #__type_ScrollArea : result.s = "scrollarea"
        Case #__type_TrackBar : result.s = "track"
        Case #__type_Web : result.s = "web"
        Case #__type_ButtonImage : result.s = "buttonimage"
        Case #__type_Calendar : result.s = "calendar"
        Case #__type_Date : result.s = "date"
        Case #__type_Editor : result.s = "editor"
        Case #__type_ExplorerList : result.s = "explorerlist"
        Case #__type_ExplorerTree : result.s = "explorertree"
        Case #__type_ExplorerCombo : result.s = "explorercombo"
        Case #__type_Spin : result.s = "spin"
        Case #__type_Tree : result.s = "tree"
        Case #__type_Panel : result.s = "panel"
        Case #__type_Splitter : result.s = "splitter"
        Case #__type_MDI : result.s = "mdi"
        Case #__type_Scintilla : result.s = "scintilla"
        Case #__type_Shortcut : result.s = "shortcut"
        Case #PB_GadgetType_Canvas : result.s = "canvas"
          
          ;     case #__type_imagebutton    : result.s = "imagebutton"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    
    Procedure$ ClassFromEvent( event.i )
      Protected result$
      
      Select event
        Case #__event_cursor          : result$ = "Cursor"
        Case #__event_free            : result$ = "Free"
        Case #__event_drop            : result$ = "Drop"
        Case #__event_create          : result$ = "Create"
        Case #__event_Draw            : result$ = "Draw"
          ;Case #__event_SizeItem    : result$ = "SizeItem"
          
        Case #__event_repaint         : result$ = "Repaint"
        Case #__event_resizeend       : result$ = "ResizeEnd"
        Case #__event_scrollchange    : result$ = "ScrollChange"
          
        Case #__event_close           : result$ = "CloseWindow"
        Case #__event_maximize        : result$ = "MaximizeWindow"
        Case #__event_minimize        : result$ = "MinimizeWindow"
        Case #__event_restore         : result$ = "RestoreWindow"
          
        Case #__event_MouseEnter      : result$ = "MouseEnter"       ; The mouse cursor entered the gadget
        Case #__event_MouseLeave      : result$ = "MouseLeave"       ; The mouse cursor left the gadget
        Case #__event_MouseMove       : result$ = "MouseMove"        ; The mouse cursor moved
        Case #__event_MouseWheel      : result$ = "MouseWheel"       ; The mouse wheel was moved
        Case #__event_LeftButtonDown  : result$ = "LeftButtonDown"   ; The left mouse button was pressed
        Case #__event_LeftButtonUp    : result$ = "LeftButtonUp"     ; The left mouse button was released
        Case #__event_LeftClick       : result$ = "LeftClick"        ; A click With the left mouse button
        Case #__event_Left2Click      : result$ = "Left2Click"       ; A double-click With the left mouse button
        Case #__event_RightButtonDown : result$ = "RightButtonDown"  ; The right mouse button was pressed
        Case #__event_RightButtonUp   : result$ = "RightButtonUp"    ; The right mouse button was released
        Case #__event_RightClick      : result$ = "RightClick"       ; A click With the right mouse button
        Case #__event_Right2Click     : result$ = "Right2Click"      ; A double-click With the right mouse button
                                                                     ;Case #__event_MiddleButtonDown : result$ = "MiddleButtonDown" ; The middle mouse button was pressed
                                                                     ;Case #__event_MiddleButtonUp : result$ = "MiddleButtonUp"     ; The middle mouse button was released
        Case #__event_Focus           : result$ = "Focus"            ; The gadget gained keyboard focus
        Case #__event_LostFocus       : result$ = "LostFocus"        ; The gadget lost keyboard focus
        Case #__event_KeyDown         : result$ = "KeyDown"          ; A key was pressed
        Case #__event_KeyUp           : result$ = "KeyUp"            ; A key was released
        Case #__event_Input           : result$ = "Input"            ; Text input was generated
        Case #__event_Resize          : result$ = "Resize"           ; The gadget has been resized
        Case #__event_StatusChange    : result$ = "StatusChange"
          ;Case #__event_TitleChange : result$ = "TitleChange"
        Case #__event_Change          : result$ = "Change"
        Case #__event_DragStart       : result$ = "DragStart"
        Case #__event_ReturnKey       : result$ = "returnKey"
          ;Case #__event_CloseItem : result$ = "CloseItem"
          
        Case #__event_Down            : result$ = "Down"
        Case #__event_Up              : result$ = "Up"
          
        Case #__event_mousewheelX     : result$ = "MouseWheelX"
        Case #__event_mousewheelY     : result$ = "MouseWheelY"
      EndSelect
      
      ProcedureReturn result$
    EndProcedure
    
    Procedure.s ClassFromPBEvent( event.i )
      Protected result.s
      
      Select event
        Case #PB_EventType_MouseEnter       : result.s = "MouseEnter"           ; The mouse cursor entered the gadget
        Case #PB_EventType_MouseLeave       : result.s = "MouseLeave"           ; The mouse cursor left the gadget
        Case #PB_EventType_MouseMove        : result.s = "MouseMove"            ; The mouse cursor moved
        Case #PB_EventType_MouseWheel       : result.s = "MouseWheel"           ; The mouse wheel was moved
          
        Case #PB_EventType_LeftButtonDown   : result.s = "LeftButtonDown"   ; The left mouse button was pressed
        Case #PB_EventType_LeftButtonUp     : result.s = "LeftButtonUp"     ; The left mouse button was released
        Case #PB_EventType_LeftClick        : result.s = "LeftClick"        ; A click With the left mouse button
        Case #PB_EventType_LeftDoubleClick  : result.s = "LeftDoubleClick"  ; A double-click With the left mouse button
          
        Case #PB_EventType_RightButtonDown  : result.s = "RightButtonDown" ; The right mouse button was pressed
        Case #PB_EventType_RightButtonUp    : result.s = "RightButtonUp"   ; The right mouse button was released
        Case #PB_EventType_RightClick       : result.s = "RightClick"      ; A click With the right mouse button
        Case #PB_EventType_RightDoubleClick : result.s = "RightDoubleClick"; A double-click With the right mouse button
          
        Case #PB_EventType_MiddleButtonDown : result.s = "MiddleButtonDown" ; The middle mouse button was pressed
        Case #PB_EventType_MiddleButtonUp   : result.s = "MiddleButtonUp"   ; The middle mouse button was released
        Case #PB_EventType_Focus            : result.s = "Focus"            ; The gadget gained keyboard focus
        Case #PB_EventType_LostFocus        : result.s = "LostFocus"        ; The gadget lost keyboard focus
        Case #PB_EventType_KeyDown          : result.s = "KeyDown"          ; A key was pressed
        Case #PB_EventType_KeyUp            : result.s = "KeyUp"            ; A key was released
        Case #PB_EventType_Input            : result.s = "Input"            ; Text input was generated
        Case #PB_EventType_Resize           : result.s = "Resize"           ; The gadget has been resized
        Case #PB_EventType_StatusChange     : result.s = "StatusChange"
        Case #PB_EventType_Change           : result.s = "Change"
        Case #PB_EventType_DragStart        : result.s = "DragStart"
        Case #PB_EventType_TitleChange      : result.s = "TitleChange"
        Case #PB_EventType_CloseItem        : result.s = "CloseItem"
        Case #PB_EventType_SizeItem         : result.s = "SizeItem"
        Case #PB_EventType_Down             : result.s = "Down"
        Case #PB_EventType_Up               : result.s = "Up"
          ;                
          ;             Case #pb_eventtype_cursor : result.s = "Cursor"
          ;             Case #pb_eventtype_free : result.s = "Free"
          ;             Case #pb_eventtype_drop : result.s = "Drop"
          ;             Case #pb_eventtype_create : result.s = "Create"
          ;             Case #pb_eventtype_Draw : result.s = "Draw"
          ;                
          ;             Case #pb_eventtype_repaint : result.s = "Repaint"
          ;             Case #pb_eventtype_resizeend : result.s = "ResizeEnd"
          ;             Case #pb_eventtype_scrollchange : result.s = "ScrollChange"
          ;                
          ;             Case #pb_eventtype_close : result.s = "CloseWindow"
          ;             Case #pb_eventtype_maximize : result.s = "MaximizeWindow"
          ;             Case #pb_eventtype_minimize : result.s = "MinimizeWindow"
          ;             Case #pb_eventtype_restore : result.s = "RestoreWindow"
          ;             Case #pb_eventtype_ReturnKey : result.s = "returnKey"
          ;             Case #pb_eventtype_mousewheelX : result.s = "MouseWheelX"
          ;             Case #pb_eventtype_mousewheelY : result.s = "MouseWheelY"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    ;-
    Procedure.i AddColumn( *this._s_WIDGET, position.l, text.s, width.l, image.i = -1 )
    EndProcedure
    
    Procedure.i AddItem_Tree( *this._s_WIDGET, List *items._S_ROWS( ), position.l, Text.s, Image.i = -1, sublevel.i = 0 )
    EndProcedure
    
    Procedure AddItem( *this._s_WIDGET, Item.l, Text.s, Image.i = - 1, flag.q = 0 )
    EndProcedure
    
    ;-
    Procedure RemoveItem( *this._s_WIDGET, Item.l )
    EndProcedure
    
    Procedure.l ClearItems( *this._s_WIDGET )
    EndProcedure
    
    Procedure.l CountItems( *this._s_WIDGET )
    EndProcedure
    
    ;-
    Procedure.l WidgetType( *this._s_WIDGET ) ; Returns created widget type
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.l GetIndex( *this._s_WIDGET )
      ProcedureReturn *this\index
    EndProcedure
    
    Procedure.i WidgetID( index )
      Protected.i result
      If index >= 0
        PushListPosition( widgets( ) )
        ForEach widgets( )
          If widgets( )\index = index
            result = widgets( )
            Break
          EndIf
        Next
        PopListPosition( widgets( ) )
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure GetBar( *this._s_WIDGET, type.b, index.b = 0 )
      If type = #__type_scrollbar
        If *this\scroll
          If index = 1
            ProcedureReturn *this\scroll\v
          EndIf
          If index = 2
            ProcedureReturn *this\scroll\h
          EndIf
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i GetAddress( *this._s_WIDGET )
      ProcedureReturn *this\address
    EndProcedure
    
    Procedure.l GetLevel( *this._s_WIDGET )
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass( *this._s_WIDGET )
      ProcedureReturn *this\class
    EndProcedure
    
    ;       Procedure.l GetMouseX( *this._s_WIDGET )
    ;          ProcedureReturn ( mouse( )\x + *this\inner_x( ) )
    ;       EndProcedure
    ;       
    ;       Procedure.l GetMouseY( *this._s_WIDGET )
    ;          ProcedureReturn ( mouse( )\y + *this\inner_y( ) )
    ;       EndProcedure
    
    Procedure.l GetDeltaX( *this._s_WIDGET )
      ProcedureReturn ( mouse( )\delta\x + *this\container_x( ) )
    EndProcedure
    
    Procedure.l GetDeltaY( *this._s_WIDGET )
      ProcedureReturn ( mouse( )\delta\y + *this\container_y( ) )
    EndProcedure
    
    Procedure.i GetFont( *this._s_WIDGET )
      ProcedureReturn GetFontID( *this )
    EndProcedure
    
    Procedure.i GetData( *this._s_WIDGET )
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure GetPositionFirst( *this._s_WIDGET, tabindex.l )
      Protected *result._s_WIDGET
      
      If *this\haschildren
        PushListPosition( widgets( ) )
        ChangeCurrentElement( widgets( ), *this\address )
        While NextElement( widgets( ) )
          If widgets( ) = *this\LastWidget( ) Or
             widgets( )\TabIndex( ) = tabindex
            *result = widgets( )
            Break
          EndIf
        Wend
        PopListPosition( widgets( ) )
      Else
        *result = *this
      EndIf
      
      ; Debug "   "+*result\class
      
      ProcedureReturn *result
    EndProcedure
    
    Procedure GetLast( *this._s_WIDGET, tabindex.l )
      Protected result, *after._s_WIDGET, *parent._s_WIDGET
      
      If *this\LastWidget( )
        If *this\haschildren
          If tabindex = - 1
            
            Protected *root._s_root
            If *this\root
              *root = *this\root
            Else
              *root = *this
            EndIf
            
            ;\\
            LastElement( widgets( ) )
            result = widgets( )\LastWidget( )
            
            ; get after widget
            If *this\AfterWidget( )
              *after = *this\AfterWidget( )
            Else
              *parent = *this
              Repeat
                *parent = *parent\parent
                If Not *parent
                  ProcedureReturn 0
                EndIf
                If *parent\AfterWidget( )
                  *after = *parent\AfterWidget( )
                  Break
                EndIf
              Until is_root_( *parent )
            EndIf
            
            If *after
              PushListPosition( widgets( ) )
              ChangeCurrentElement( widgets( ), *after\address )
              While PreviousElement( widgets( ) )
                If widgets( )\TabIndex( ) = tabindex ;Or widgets( ) = *this
                  Break
                EndIf
              Wend
              result = widgets( )\LastWidget( )
              PopListPosition( widgets( ) )
            EndIf
          Else
            ;Debug ""+tabindex +" "+ *this\LastWidget( )\BeforeWidget( ) +" "+ *this\LastWidget( )\AfterWidget( )
            If tabindex = 0
              If is_root_(*this)
                result = *this\LastWidget( )
              Else
                result = *this 
              EndIf
            Else
              result = *this\LastWidget( )
            EndIf
            If tabindex >= 0 And 
               StartEnumerate( *this, tabindex )
              ;
              If widget( )\TabIndex( ) = tabindex
                result = widget( ) 
              EndIf
              ;
              StopEnumerate( )
            EndIf
            
            ;             If *this\LastWidget( )\TabIndex( ) = tabindex
            ;                result = *this\LastWidget( )
            ;             Else
            ;                If tabindex = 0
            ;                   result = *this;\parent\FirstWidget( )
            ;                Else
            ;                   Debug tabindex;*this\LastWidget( )\text\string
            ; result = *this\LastWidget( )
            ;                EndIf
            ;             EndIf
            *this = result
            If *this\LastWidget( )
              result = *this\LastWidget( )
            EndIf
            
          EndIf
        Else
          result = *this\LastWidget( )
        EndIf
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    Procedure GetPositionLast( *this._s_WIDGET, tabindex.l = #PB_Default )
      Protected *last._s_WIDGET = *this;\LastWidget( )
      If StartEnumerate( *this )
        *last = widgets( )
        StopEnumerate( )
      EndIf
      ProcedureReturn *last
    EndProcedure
    
    Procedure GetPositionAfter( *this._s_WIDGET, tabindex.l )
      Protected *after._s_WIDGET = *this\LastWidget( ) 
      Protected *last._s_WIDGET = *this\LastWidget( ) 
      ;
      If *this\haschildren
        If *this\TabBox( ) 
          If tabindex >= *last\TabIndex( )
            *after = *last
          Else
            *after = *this
            ;
            If *last 
              PushListPosition( widgets( ) )
              ChangeCurrentElement( widgets( ), *last\address )
              While PreviousElement( widgets( ) )
                If widgets( )\parent = *this 
                  If widgets( )\TabIndex( ) = TabIndex
                    *after = widgets( )
                    Break
                  EndIf
                EndIf
              Wend
              PopListPosition( widgets( ) )
            EndIf
          EndIf
        EndIf
      EndIf
      ;
      If is_root_( *after )
        *after = *after\LastWidget( )
      EndIf
      ProcedureReturn *after
    EndProcedure
    
    Procedure.i GetPosition( *this._s_WIDGET, position.l )
      Protected result
      
      Select position
        Case #PB_List_First
          result = *this\parent\FirstWidget( ) ; GetPositionFirst( *this\parent, *this\TabIndex( ) )
        Case #PB_List_Before
          result = *this\BeforeWidget( )
        Case #PB_List_After
          result = *this\AfterWidget( )
        Case #PB_List_Last
          result = *this\parent\LastWidget( ) ; GetLast( *this\parent, *this\TabIndex( ) )
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetAttribute( *this._s_WIDGET, Attribute.l )
      Protected result.i
      
      If *this\type = #__type_Splitter
        Select Attribute
          Case #PB_Splitter_FirstGadget : result = *this\split_1( )
          Case #PB_Splitter_SecondGadget : result = *this\split_2( )
          Case #PB_Splitter_FirstMinimumSize : result = *this\bar\min[1]
          Case #PB_Splitter_SecondMinimumSize : result = *this\bar\min[2]
        EndSelect
      EndIf
      
      ; is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea 
        Select Attribute
          Case #PB_ScrollArea_X : result = DesktopUnscaledX(*this\scroll\h\bar\page\pos)
          Case #PB_ScrollArea_Y : result = DesktopUnscaledY(*this\scroll\v\bar\page\pos)
          Case #PB_ScrollArea_InnerWidth : result = DesktopUnscaledX(*this\scroll\h\bar\max)
          Case #PB_ScrollArea_InnerHeight : result = DesktopUnscaledY(*this\scroll\v\bar\max)
          Case #PB_ScrollArea_ScrollStep : result = *this\scroll\increment
        EndSelect
      EndIf
      
      If *this\type = #__type_ScrollBar 
        Select Attribute
          Case #__bar_minimum : result = *this\bar\min          ; 1
          Case #__bar_maximum : result = *this\bar\max          ; 2
          Case #__bar_pagelength : result = *this\bar\page\len  ; 3
            
          Case #__bar_scrollstep : result = *this\scroll\increment ; 5
          Case #__bar_buttonsize : result = *this\bar\button[1]\size
            
          Case #__bar_direction : result = *this\bar\direction
          Case #__bar_invert : result = *this\bar\invert
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetState( *this._s_WIDGET )
      ;\\ custom object
      If *this\type = 0
        ProcedureReturn *this\state
      EndIf
      
      If *this\bar
        If *this\type = #__type_Splitter
          ProcedureReturn DesktopUnScaled( *this\bar\thumb\pos )
        EndIf
        If *this\type = #__type_ScrollBar
          ProcedureReturn *this\bar\page\pos
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s GetText( *this._s_WIDGET );, column.l = 0 )
    EndProcedure
    
    Procedure.l GetColor( *this._s_WIDGET, ColorType.l )
      Protected Color.l
      
      With *This
        Select ColorType
          Case #__color_line : Color = *this\color\line
          Case #__color_back : Color = *this\color\back
          Case #__color_front : Color = *this\color\front
          Case #__color_frame : Color = *this\color\frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    Procedure.a GetFrame( *this._s_WIDGET, mode.b = 0 )
      ProcedureReturn *this\fs[mode]
    EndProcedure
    
    Procedure.i GetParent( *this._s_WIDGET )
      ProcedureReturn *this\parent
    EndProcedure
    
    Procedure.i GetCanvasGadget( *this._s_WIDGET = #Null ) ; Returns canvas gadget
      Protected.i result
      If is_widget_( *this )
        result = *this\root\canvas\gadget
      Else
        If root( )
          result = root( )\canvas\gadget
        EndIf
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetCanvasWindow( *this._s_WIDGET = #Null ) ; Returns window
      Protected.i result
      If is_widget_( *this )
        If is_root_( *this )
          result = *this\root\canvas\window
        Else
          result = *this\window
        EndIf
      Else
        If root( )
          result = root( )\canvas\window
        EndIf
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Getroot( *this._s_WIDGET ) ; Returns root widget
      ProcedureReturn *this\root
    EndProcedure
    
    ;-
    Procedure SetBackgroundColor( *this._s_WIDGET, color.l )
      Protected ColorType = #__color_back
      Protected result.l, alpha.a = Alpha( Color )
      
      *this\ColorAlphaColor( ).allocate( COLOR )
      
      If Not alpha
        Color = Color & $FFFFFF | 255 << 24
      EndIf
      
      set_color_( result, *this\color, ColorType, Color, alpha )
      
      If *this\scroll
        If ColorType = #__color_back
          If *this\scroll\v
            *this\scroll\v\color\back = color
          EndIf
          If *this\scroll\h
            *this\scroll\h\color\back = color
          EndIf
        EndIf
      EndIf
      
      If result
        PostRepaint( *this\root )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure SetBackgroundImage( *this._s_WIDGET, *image )
      set_image_( *this, *this\Image[#__image_background], *image )
    EndProcedure
    
    Procedure SetClass( *this._s_WIDGET, class.s )
      If *this\class <> class
        *this\class = class
        ProcedureReturn *this
      EndIf
    EndProcedure
    
    Procedure.b SetState( *this._s_WIDGET, state.i )
      Protected result
      
      ;\\ custom object
      If *this\type = 0
        *this\state = state
        ProcedureReturn #True
      EndIf
      
      If *this\child
        *this\parent\redraw = 1
      Else
        *this\redraw = 1
      EndIf
      
      
      ;\\
      Select *this\type
        Case #__type_ScrollBar,
             #__type_Splitter
          
          If *this\type = #__type_splitter
            If *this\bar\vertical
              state = DesktopScaledX( state )
            Else
              state = DesktopScaledY( state )
            EndIf
          EndIf
          
          result = bar_PageChange( *this, state, 2 ) ; and post change event
          
      EndSelect
      
      If result
        PostRepaint( *this\root )
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetAttribute( *this._s_WIDGET, Attribute.l, *value )
      Protected result.i
      Protected value = *value
      
      If *this\type = #__type_ScrollBar Or
         *this\type = #__type_Splitter 
        ;
        result = bar_SetAttribute( *this, Attribute, *value )
      EndIf
      
      ;  is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea 
        Select Attribute
          Case #PB_ScrollArea_X
            If bar_PageChange( *this\scroll\h, DesktopScaledX(*value), 2 ) ; and post event
              result = 1
            EndIf
            
          Case #PB_ScrollArea_Y
            If bar_PageChange( *this\scroll\v, DesktopScaledY(*value), 2 ) ; and post event
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerWidth
            If bar_SetAttribute( *this\scroll\h, #__bar_maximum, DesktopScaledX(*value) )
              If IsGadget(*this\scroll\gadget[2])
                ResizeGadget(*this\scroll\gadget[2], #PB_Ignore, #PB_Ignore, *value, #PB_Ignore)
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  UpdateWindow_(GadgetID(*this\scroll\gadget[2]))
                CompilerEndIf
              EndIf
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerHeight
            If bar_SetAttribute( *this\scroll\v, #__bar_maximum, DesktopScaledY(*value))
              If IsGadget(*this\scroll\gadget[2])
                ResizeGadget(*this\scroll\gadget[2], #PB_Ignore, #PB_Ignore, #PB_Ignore, *value)
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  UpdateWindow_(GadgetID(*this\scroll\gadget[2]))
                CompilerEndIf
              EndIf
              result = 1
            EndIf
            
          Case #PB_ScrollArea_ScrollStep
            If *this\scroll
              If *this\scroll\v
                *this\scroll\v\scroll\increment = value
              EndIf
              If *this\scroll\h
                *this\scroll\h\scroll\increment = value
              EndIf
            EndIf
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetText( *this._s_WIDGET, Text.s )
    EndProcedure
    
    Procedure.i SetFont( *this._s_WIDGET, FontID.i )
    EndProcedure
    
    Procedure SetData( *this._s_WIDGET, *data )
      *this\data = *data
    EndProcedure
    
    Procedure SetForeground( *this._s_WIDGET )
    EndProcedure
    
    Procedure SetPosition( *this._s_WIDGET, position.l, *widget._s_WIDGET = #Null ) ; Ok
      If *widget = #Null
        Select Position
          Case #PB_List_First : *widget = *this\parent\FirstWidget( )
          Case #PB_List_Before : *widget = *this\BeforeWidget( )
          Case #PB_List_After : *widget = *this\AfterWidget( )
          Case #PB_List_Last : *widget = *this\parent\LastWidget( )
        EndSelect
      EndIf
      
      If Not *widget
        ProcedureReturn #False
      EndIf
      
      If *this <> *widget And
         *this\TabIndex( ) = *widget\TabIndex( )
        
        If Position = #PB_List_First Or
           Position = #PB_List_Before
          
          PushListPosition( widgets( ))
          ChangeCurrentElement( widgets( ), *this\address )
          MoveElement( widgets( ), #PB_List_Before, *widget\address )
          
          If *this\haschildren
            While PreviousElement( widgets( ))
              If IsChild( widgets( ), *this )
                MoveElement( widgets( ), #PB_List_After, *widget\address )
              EndIf
            Wend
            
            While NextElement( widgets( ))
              If IsChild( widgets( ), *this )
                MoveElement( widgets( ), #PB_List_Before, *widget\address )
              EndIf
            Wend
          EndIf
          PopListPosition( widgets( ))
        EndIf
        
        If Position = #PB_List_Last Or
           Position = #PB_List_After
          
          Protected *last._s_WIDGET = GetLast( *widget, *widget\TabIndex( ))
          
          PushListPosition( widgets( ))
          ChangeCurrentElement( widgets( ), *this\address )
          MoveElement( widgets( ), #PB_List_After, *last\address )
          
          If *this\haschildren
            While NextElement( widgets( ))
              If IsChild( widgets( ), *this )
                MoveElement( widgets( ), #PB_List_Before, *last\address )
              EndIf
            Wend
            
            While PreviousElement( widgets( ))
              If IsChild( widgets( ), *this )
                MoveElement( widgets( ), #PB_List_After, *this\address )
              EndIf
            Wend
          EndIf
          PopListPosition( widgets( ))
        EndIf
        
        ;
        If *this\BeforeWidget( )
          *this\BeforeWidget( )\AfterWidget( ) = *this\AfterWidget( )
        EndIf
        If *this\AfterWidget( )
          *this\AfterWidget( )\BeforeWidget( ) = *this\BeforeWidget( )
        EndIf
        If *this\parent\FirstWidget( ) = *this
          *this\parent\FirstWidget( ) = *this\AfterWidget( )
        EndIf
        If *this\parent\LastWidget( ) = *this
          *this\parent\LastWidget( ) = *this\BeforeWidget( )
        EndIf
        
        ;
        If Position = #PB_List_First Or
           Position = #PB_List_Before
          
          *this\AfterWidget( )    = *widget
          *this\BeforeWidget( )   = *widget\BeforeWidget( )
          *widget\BeforeWidget( ) = *this
          
          If *this\BeforeWidget( )
            *this\BeforeWidget( )\AfterWidget( ) = *this
          Else
            If *this\parent\FirstWidget( )
              *this\parent\FirstWidget( )\BeforeWidget( ) = *this
            EndIf
            *this\parent\FirstWidget( ) = *this
          EndIf
        EndIf
        
        If Position = #PB_List_Last Or
           Position = #PB_List_After
          
          *this\BeforeWidget( )  = *widget
          *this\AfterWidget( )   = *widget\AfterWidget( )
          *widget\AfterWidget( ) = *this
          
          If *this\AfterWidget( )
            *this\AfterWidget( )\BeforeWidget( ) = *this
          Else
            If *this\parent\LastWidget( )
              *this\parent\LastWidget( )\AfterWidget( ) = *this
            EndIf
            *this\parent\LastWidget( ) = *this
          EndIf
        EndIf
        
        ProcedureReturn #True
      EndIf
      
    EndProcedure
    
    Procedure SetParent( *this._s_WIDGET, *parent._s_WIDGET, tabindex.l = #PB_Default )
      Protected parent, ReParent.b, x, y
      Protected *after._s_WIDGET, *last._s_WIDGET, *lastParent._s_WIDGET
      Protected NewList *D._s_WIDGET( ), NewList *C._s_WIDGET( )
      
      ;\\
      If *this = *parent
        ProcedureReturn 0
      EndIf
      
      If *parent
        If *parent\container = 0 And *parent\child
          Debug "SetParent("
          *parent = *parent\parent
        EndIf
        ;
        If *this\parent = *parent And
           *this\TabIndex( ) = tabindex
          ProcedureReturn #False
        EndIf
        ;
        If tabindex < 0
          tabindex = *parent\TabAddIndex( )
        EndIf
        ;
        ;\\ get the last widget to add it after it
        If *parent\LastWidget( )
          *after = GetPositionAfter( *parent, tabindex )
          ;
          If *after\parent = *parent
            *last = GetPositionLast( *after, tabindex )
            
            ;                   *last = *after 
            ;                   If StartEnumerate( *after )
            ;                      *last = widgets( )
            ;                      StopEnumerate( )
            ;                   EndIf
            ;
            If *this = *after Or IsChild( *last, *this )
              *last = GetPositionLast( *this\BeforeWidget( ), tabindex )
              
              ;                      *last = *this\BeforeWidget( )
              ;                      If StartEnumerate( *this\BeforeWidget( ) )
              ;                        *last = widgets( )
              ;                        StopEnumerate( )
              ;                      EndIf
              
            EndIf
          Else
            *last = *after
          EndIf
          
          ;                If tabindex = 2
          ;                    Debug ""+*this\text\string +" last-"+ *last\class +" after-"+ *after\class
          ;                EndIf
        EndIf
        ;
        If *parent\type = #__type_Splitter
          If tabindex > 0
            If tabindex % 2
              *parent\FirstWidget( ) = *this
              *parent\split_1( )    = *this
              bar_Update( *parent, #True )
              If IsGadget( *parent\split_1( ) )
                ProcedureReturn 0
              EndIf
            Else
              *parent\LastWidget( ) = *this
              *parent\split_2( )    = *this
              bar_Update( *parent, #True )
              If IsGadget( *parent\split_2( ) )
                ProcedureReturn 0
              EndIf
            EndIf
          EndIf
        EndIf
        ;
        *this\TabIndex( ) = tabindex
        
        ;
        ; set hide state
        If *parent\hide
          *this\hide = #True
        ElseIf *parent\TabBox( )
          ; hide all children's except the selected tab
          *this\hide = Bool(*parent\TabBox( )\TabState( ) <> *this\TabIndex( ))
        ElseIf Not *this\hidden
          If *this\hide = #True
            *this\hide = #False
          EndIf
        EndIf
        ;
        ;\\
        If *this And
           *this\parent
          ;
          If *this\address
            *lastParent = *this\parent
            *lastParent\haschildren - 1
            
            ChangeCurrentElement( widgets( ), *this\address )
            AddElement( *D( ) ) : *D( ) = widgets( )
            
            If *this\haschildren
              PushListPosition( widgets( ) )
              While NextElement( widgets( ) )
                If Not IsChild( widgets( ), *this )
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) = widgets( )
                
                ; ChangeParent
                If *parent\window
                  *D( )\window = *parent\window
                Else
                  *D( )\window = *parent
                EndIf
                If *parent\root
                  *D( )\root = *parent\root
                Else
                  *D( )\root = *parent
                EndIf
                ;; Debug " children's - "+ *D( )\data +" - "+ *this\data
                
                ;\\ integrall children's
                If *D( )\scroll
                  If *D( )\scroll\v
                    *D( )\scroll\v\root   = *D( )\root
                    *D( )\scroll\v\window = *D( )\window
                  EndIf
                  If *D( )\scroll\h
                    *D( )\scroll\h\root   = *D( )\root
                    *D( )\scroll\h\window = *D( )\window
                  EndIf
                EndIf
                
                *D( )\hide = HideState( *D( ) )
                ;Debug *D( )\hidden
                
              Wend
              PopListPosition( widgets( ) )
            EndIf
            
            ;\\ move with a parent and his children's
            If *last
              PushListPosition( widgets( ) )
              LastElement( *D( ) )
              Repeat
                ChangeCurrentElement( widgets( ), *D( )\address )
                MoveElement( widgets( ), #PB_List_After, *last\address )
              Until PreviousElement( *D( ) ) = #False
              PopListPosition( widgets( ) )
            EndIf
            ;
            ReParent = #True
          EndIf
          ;
        Else
          ;
          If *last
            ChangeCurrentElement( widgets( ) , *last\address )
          Else
            LastElement( widgets( ) )
          EndIf
          ;
          AddElement( widgets( ) )
          widgets( )  = *this
          *this\index     = ListIndex( widgets( ) )
          *this\address = @widgets( )
        EndIf
        ;
        ;\\
        ;
        If *this\parent 
          If *this\parent\FirstWidget( ) = *this
            *this\parent\FirstWidget( ) = *this\AfterWidget( )
          EndIf
          ;
          If *this\parent\LastWidget( ) = *this
            *this\parent\LastWidget( ) = *this\BeforeWidget( )
          EndIf
        Else
          *this\LastWidget( ) = *this 
        EndIf
        ;
        If *parent\TabBox( )
          If *this\TabIndex( ) = *parent\TabBox( )\countitems - 1
            *parent\LastWidget( ) = *this
          EndIf
        Else
          *parent\LastWidget( ) = *this
        EndIf
        ;
        If *this\BeforeWidget( )
          *this\BeforeWidget( )\AfterWidget( ) = *this\AfterWidget( )
        EndIf
        ;
        If *this\AfterWidget( )
          *this\AfterWidget( )\BeforeWidget( ) = *this\BeforeWidget( )
        EndIf
        ;
        If *after
          If *after\parent = *parent
            If *after\AfterWidget( )
              *after\AfterWidget( )\BeforeWidget( ) = *this
            EndIf
            *this\AfterWidget( ) = *after\AfterWidget( )
            ;
            *this\BeforeWidget( ) = *after
            *after\AfterWidget( ) = *this
          Else
            *this\AfterWidget( ) = *parent\FirstWidget( )
            If *parent\FirstWidget( )
              *this\AfterWidget( )\BeforeWidget( ) = *this
            EndIf
            ;
            *this\BeforeWidget( ) = #Null
            *parent\FirstWidget( ) = *this
          EndIf
        EndIf
        ;
        If *parent\FirstWidget( ) = #Null
          *parent\FirstWidget( ) = *this
        EndIf
        ;
        ;\\
        ReParent( *this, *parent )
        ;\\
        If ReParent
          ;
          ;\\ resize
          x = *this\container_x( )
          y = *this\container_y( )
          
          ;\\ for the scrollarea container childrens
          ;\\ if new parent - scrollarea container
          If *parent\scroll And
             *parent\scroll\v And *parent\scroll\h
            x - *parent\scroll\h\bar\page\pos
            y - *parent\scroll\v\bar\page\pos
          EndIf
          
          ;\\ if last parent - scrollarea container
          If *LastParent\scroll And
             *LastParent\scroll\v And *LastParent\scroll\h
            x + *LastParent\scroll\h\bar\page\pos
            y + *LastParent\scroll\v\bar\page\pos
          EndIf
          
          *this\noscale = 1
          Resize( *this, x - *parent\scroll_x( ), y - *parent\scroll_y( ), #PB_Ignore, #PB_Ignore )
          
          ;\\
          PostRepaint( *parent\root )
          If *parent\root <> *lastParent\root
            PostRepaint( *lastParent\root )
          EndIf
        EndIf
      EndIf
      
      widget( ) = *this
      ProcedureReturn *this
    EndProcedure
    
    Procedure SetFrame( *this._s_WIDGET, size.a, mode.b = 0 )
      Protected result
      If *this\fs <> size
        result   = *this\fs
        *this\bs = size
        *this\fs = size
        
        If mode = - 1 ; auto pos
          Resize( *this, *this\container_x( ) - size, *this\container_y( ) - size, *this\frame_width( ) + size * 2, *this\frame_height( ) + size * 2 )
        ElseIf mode = - 2 ; auto pos
                          ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Resize( *this, *this\container_x( ) - (size - result), *this\container_y( ) - (size - result), #PB_Ignore, #PB_Ignore )
        Else
          Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        EndIf
      EndIf
    EndProcedure
    
    ;-
    Procedure.i GetItemData( *this._s_WIDGET, item.l )
    EndProcedure
    
    Procedure.s GetItemText( *this._s_WIDGET, Item.l, Column.l = 0 )
    EndProcedure
    
    Procedure.i GetItemImage( *this._s_WIDGET, Item.l )
    EndProcedure
    
    Procedure.i GetItemFont( *this._s_WIDGET, Item.l )
    EndProcedure
    
    Procedure.l GetItemState( *this._s_WIDGET, Item.l )
    EndProcedure
    
    Procedure.l GetItemColor( *this._s_WIDGET, Item.l, ColorType.l, Column.l = 0 )
    EndProcedure
    
    Procedure.i GetItemAttribute( *this._s_WIDGET, Item.l, Attribute.l, Column.l = 0 )
    EndProcedure
    
    ;-
    Procedure.i SetItemData( *This._s_WIDGET, item.l, *data )
    EndProcedure
    
    Procedure.l SetItemText( *this._s_WIDGET, Item.l, Text.s, Column.l = 0 )
    EndProcedure
    
    Procedure.i SetItemImage( *this._s_WIDGET, Item.l, Image.i )
    EndProcedure
    
    Procedure.i SetItemFont( *this._s_WIDGET, Item.l, Font.i )
    EndProcedure
    
    Procedure.b SetItemState( *this._s_WIDGET, Item.l, State.b )
    EndProcedure
    
    Procedure.l SetItemColor( *this._s_WIDGET, Item.l, ColorType.l, Color.l, Column.l = 0 )
    EndProcedure
    
    Procedure.i SetItemAttribute( *this._s_WIDGET, Item.l, Attribute.l, *value, Column.l = 0 )
    EndProcedure
    
    
    ;-
    ;-  CREATEs
    Procedure.i Create( *parent._s_WIDGET, class.s, type.l, x.l, y.l, width.l, height.l, Text.s = #Null$, flag.q = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 0, ScrollStep.f = 1.0 )
      Protected *root._s_root
      If *parent
        *root = *parent\root
      EndIf
      ;
      size = DesktopScaled( size )
      ;
      Protected color, image                 ;, *this.allocate( Widget )
      
      Protected *this._s_WIDGET
      If *root And 
         BinaryFlag( Flag, #__flag_autosize ) And
         Not ListSize( widgets( ) )
        x              = 0
        y              = 0
        width          = *root\width
        height         = *root\height
        *root\autosize = #True
        *this          = *root
      Else
        *this.allocate( Widget )
      EndIf
      
      ;\\ replace pb flag
      flag = FromPBFlag( type, flag )
      
      ;\\
      *this\create = #True
      *this\color  = _get_colors_( )
      *this\type   = type
      *this\class  = class
      *this\round  = DesktopScaled( round )
      *this\child  = BinaryFlag( Flag, #__flag_child )
      
      ;\\
      *this\frame_x( )      = #PB_Ignore
      *this\frame_y( )      = #PB_Ignore
      *this\frame_width( )  = #PB_Ignore
      *this\frame_height( ) = #PB_Ignore
      
      
      ;\\ Flags
      *this\flag = Flag
      
      ;\\ Border & Frame size
      If *this\type = #__type_ScrollArea
        If BinaryFlag( *this\flag, #__flag_BorderFlat )
          *this\fs = 1
        ElseIf BinaryFlag( *this\flag, #__flag_BorderSingle )
          *this\fs = 1
        ElseIf BinaryFlag( *this\flag, #__flag_BorderDouble )
          *this\fs = 2
        ElseIf BinaryFlag( *this\flag, #__flag_BorderRaised )
          *this\fs = 2
        ElseIf BinaryFlag( *this\Flag, #__flag_BorderLess )
          *this\fs = 0
        Else
          *this\fs = 1
        EndIf
      EndIf
      *this\bs = *this\fs
      
      ;\\
      If *parent
        ;\\
        If BinaryFlag( Flag, #__flag_autosize )
          If *parent\type <> #__type_Splitter
            *this\autosize = 1
            ; set transparent parent
            *parent\color\back      = - 1
            *parent\ColorAlphaState( ) = 0
          EndIf
        EndIf
        
        ;\\
        If *this\child
          *this\index   =- 1
          *this\address = *parent\address
          ReParent( *this, *parent )
        Else
          *this\text\string = Text
          SetParent( *this, *parent, #PB_Default )
        EndIf
      EndIf
      
      ;\\ - Create Containers
      If *this\type = #__type_ScrollArea 
        
        *this\container = 3
        *this\resize\send = #True
        *this\color\back = $FFF9F9F9
        
        ;\\ Open gadget list
        If *this\container > 0 And Not BinaryFlag( *this\flag, #__flag_nogadgets )
          OpenList( *this )
        EndIf
      EndIf
      
      ;\\ - Create Bars
      If *this\type = #__type_ScrollBar Or
         *this\type = #__type_Splitter 
        
        *this\bar.allocate( BAR )
        *this\bar\button.allocate( BUTTONS )
        *this\bar\button.allocate( BUTTONS, [1] )
        *this\bar\button.allocate( BUTTONS, [2] )
        
        *this\scroll\increment  = ScrollStep
        Protected._s_BUTTONS *BB1, *BB2, *SB
        *SB  = *this\bar\button
        *BB1 = *this\bar\button[1]
        *BB2 = *this\bar\button[2]
        
        ; - Create Scroll
        If *this\type = #__type_ScrollBar
          *this\color\back  = $FFF9F9F9 ; - 1
          *this\color\front = $FFFFFFFF
          
          *this\bar\invert   = BinaryFlag( Flag, #__bar_invert )
          *this\bar\vertical = Bool( BinaryFlag( Flag, #__bar_vertical ) Or BinaryFlag( Flag, #PB_ScrollBar_Vertical ))
          
          If *this\bar\vertical
            *this\class = class + "-v"
          Else
            *this\class = class + "-h"
          EndIf
          
          *BB1\color = _get_colors_( )
          *BB2\color = _get_colors_( )
          *SB\color  = _get_colors_( )
          
          ;
          If Not BinaryFlag( Flag, #__flag_nobuttons ) 
            *BB1\size = - 1
            *BB2\size = - 1
          EndIf
          *SB\size = size
          
          *BB1\round = *this\round
          *BB2\round = *this\round
          *SB\round  = *this\round
          
          *BB1\arrow\type = #__arrow_type 
          *BB2\arrow\type = *BB1\arrow\type 
          
          *BB1\arrow\size = DesktopScaled( #__arrow_size )
          *BB2\arrow\size = DesktopScaled( #__arrow_size )
          *SB\arrow\size  = DesktopScaled( 3 )
        EndIf
        
        ; - Create Splitter
        If *this\type = #__type_Splitter
          *this\container  = - 1
          *this\color\back = - 1
          
          *this\bar\invert   = BinaryFlag( Flag, #__bar_invert )
          *this\bar\vertical = Bool( Not BinaryFlag( Flag, #__bar_vertical ) And 
                                     Not BinaryFlag( Flag, #PB_Splitter_Vertical ))
          
          If BinaryFlag( Flag, #PB_Splitter_FirstFixed )
            *this\bar\fixed = 1
          ElseIf BinaryFlag( Flag, #PB_Splitter_SecondFixed )
            *this\bar\fixed = 2
          EndIf
          
          ;\\
          *this\split_1( ) = *param_1
          *this\split_2( ) = *param_2
          
          *this\bar\button[1]\hide = Bool( IsGadget( *this\split_1( ) ) Or *this\split_1( ) )
          *this\bar\button[2]\hide = Bool( IsGadget( *this\split_2( ) ) Or *this\split_2( ) )
          
          *SB\size                 = DesktopScaled( #__splittersize ) 
          *SB\size                 + Bool( Not *SB\size % 2)
          *SB\round                = DesktopScaled( #__splitterround )
          
          ;\\
          ; If *this\type = #__type_Splitter
          If IsGadget( *this\split_1( ) )
            Debug "bar_is_first_gadget_ " + IsGadget( *this\split_1( ) )
            parent::set( *this\split_1( ), *this\root\canvas\GadgetID )
          ElseIf *this\split_1( ) > 0
            SetParent( *this\split_1( ), *this )
          EndIf
          
          If IsGadget( *this\split_2( ) )
            Debug "bar_is_second_gadget_ " + IsGadget( *this\split_2( ) )
            parent::set( *this\split_2( ), *this\root\canvas\GadgetID )
          ElseIf *this\split_2( ) > 0
            SetParent( *this\split_2( ), *this )
          EndIf
          ; EndIf
        EndIf
        
      EndIf
      
      If BinaryFlag( *this\flag, #__flag_Transparent )
        *this\color\back =- 1
      EndIf
      
      ;\\
      Post( *this, #__event_create )
      
      ;\\ Set Attribute
      If *this\type = #__type_ScrollBar 
        If *param_1 ; > 0 ; в окнах работает так
          SetAttribute( *this, #__bar_minimum, *param_1 )
        EndIf
        If *param_2
          SetAttribute( *this, #__bar_maximum, *param_2 )
        EndIf
        If *param_3
          SetAttribute( *this, #__bar_pageLength, *param_3 )
        EndIf
      EndIf
      
      
      ;\\ cursor init
      If *this\type = #__type_Editor Or
         *this\type = #__type_String
        *this\cursor = cursor::#__cursor_IBeam
      EndIf
      If *this\type = #__type_HyperLink
        *this\cursor = cursor::#__cursor_Hand
        *this\cursor[1] = cursor::#__cursor_IBeam
      EndIf
      If *this\type = #__type_Splitter
        If *this\bar\vertical
          *this\cursor = cursor::#__cursor_SplitUpDown
          *this\cursor[1] = cursor::#__cursor_SplitUp
          *this\cursor[2] = cursor::#__cursor_SplitDown
        Else
          *this\cursor = cursor::#__cursor_SplitLeftRight
          *this\cursor[1] = cursor::#__cursor_SplitLeft
          *this\cursor[2] = cursor::#__cursor_SplitRight
        EndIf
      EndIf
      If *this\cursor
        Cursor( *this ) = *this\cursor
      EndIf
      
      
      ;\\ Resize
      If is_integral_( *this )
        If *this\type = #__type_ScrollBar
          If *this\parent
            If *this\bar\vertical
              *this\parent\scroll\v = *this
              If *this\parent\type <> #__type_string
                Resize( *this, *this\parent\container_width( ) - width, y, width, *this\parent\container_height( ) - width + Bool(*this\Round) * (width / 4) )
              EndIf
            Else
              *this\parent\scroll\h = *this
              If *this\parent\type <> #__type_string
                Resize( *this, x, *this\parent\container_height( ) - height, *this\parent\container_width( ) - height + Bool(*this\Round) * (height / 4), height )
              EndIf
            EndIf
          EndIf
        EndIf
      Else
        If *this\root And 
           width And height And 
           Not *this\root\width And 
           Not *this\root\height
          *this\autosize = 1
          Debug " canvas gadget resize"
          ResizeGadget( *this\root\canvas\gadget, x, y, width, height )
        Else
          Resize( *this, x, y, width, height )
        EndIf
      EndIf
      
      ;\\ Scroll bars
      If *this\type = #__type_ScrollArea
        If Not BinaryFlag( Flag, #__flag_noscrollbars )
          bar_area_create( *this, 1, DesktopScaledX( *param_1 ), DesktopScaledY( *param_2 ), *this\inner_width( ), *this\inner_height( ), #__buttonsize )
        EndIf
      EndIf
      
      
      widget( ) = *this
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab( x.l, y.l, width.l, height.l, flag.q = 0, round.l = 0 )
    EndProcedure
    
    Procedure.i Spin( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0, Increment.f = 1.0 )
    EndProcedure
    
    Procedure.i Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
      ;  ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_ScrollBar, x, y, width, height, #Null$, flag, min, max, pagelength, #__buttonsize, round, 1 )
    EndProcedure
    
    Procedure.i Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = #__buttonround )
    EndProcedure
    
    Procedure.i Progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
    EndProcedure
    
    
    
    ;-
    Procedure.i Tree( x.l, y.l, width.l, height.l, flag.q = 0 )
    EndProcedure
    
    Procedure.i ListView( x.l, y.l, width.l, height.l, flag.q = 0 )
    EndProcedure
    
    Procedure.i ListIcon( x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.i, flag.q = 0 )
    EndProcedure
    
    Procedure.i ExplorerList( x.l, y.l, width.l, height.l, Directory.s, flag.q = 0 )
    EndProcedure
    
    Procedure.i Tree_properties( x.l, y.l, width.l, height.l, flag.q = 0 )
    EndProcedure
    
    
    Procedure.i Splitter( x.l, y.l, width.l, height.l, First.i, Second.i, flag.q = 0 )
      ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Splitter, x, y, width, height, #Null$, flag, First, Second, 0, 0, 0, 1 )
    EndProcedure
    
    Procedure.i ScrollArea( x.l, y.l, width.l, height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, flag.q = #__flag_BorderFlat )
      ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_ScrollArea, x, y, width, height, #Null$, flag, ScrollAreaWidth, ScrollAreaHeight, 0, #__buttonsize, 0, ScrollStep )
    EndProcedure
    
    ;-
    Procedure ToolTip( *this._s_WIDGET, Text.s, item = - 1 )
    EndProcedure
    
    ;-
    ;-  DRAWINGs
    ;-
    Procedure.b Draw_Arrow( direction.a, x.l, y.l, size.a, mode.b = 1, framesize.a = 0, Color = $ff000000 )
      Protected i.w, j.w, thickness.a
      x + size/2
      y + size/2
      
      If mode
        If mode = - 1
          
          thickness.a = 2 + size/4
          
          ;       x - thickness + 1
          ;       y - thickness + 1 
          
          If framesize
            x + framesize*2
            y + framesize*2
            
            Color = $ffffffff
            For i = - (size+framesize)/2 To (size+framesize)/2
              If direction = 0 ; left
                If i > 0
                  Box( x + i + framesize, y + i * 1, - (thickness+framesize*2), 1, Color )
                Else
                  Box( x - i + framesize, y + i * 1, - (thickness+framesize*2), 1, Color )
                EndIf
              EndIf
              If direction = 2 ; right
                If i < 0
                  Box( x + i - framesize, y + i * 1, (thickness+framesize*2), 1, Color )
                Else
                  Box( x - i - framesize, y + i * 1, (thickness+framesize*2), 1, Color )
                EndIf
              EndIf
              If direction = 1 ; up
                If i > 0
                  Box( x + i * 1, y + i + framesize, 1, - (thickness+framesize*2), Color )
                Else
                  Box( x + i * 1, y - i + framesize, 1, - (thickness+framesize*2), Color )
                EndIf
              EndIf
              If direction = 3 ; down
                If i < 0
                  Box( x + i * 1, y + i - framesize, 1, (thickness+framesize*2), Color )
                Else
                  Box( x + i * 1, y - i - framesize, 1, (thickness+framesize*2), Color )
                EndIf
              EndIf
            Next
            Color = $ff000000
          EndIf
          
          For i = - size/2 To size/2
            If direction = 0 ; left
              If i > 0
                Box( x + i, y + i * 1, - (thickness), 1, Color )
              Else
                Box( x - i, y + i * 1, - (thickness), 1, Color )
              EndIf
            EndIf
            If direction = 2 ; right
              If i < 0
                Box( x + i, y + i * 1, (thickness), 1, Color )
              Else
                Box( x - i, y + i * 1, (thickness), 1, Color )
              EndIf
            EndIf
            If direction = 1 ; up
              If i > 0
                Box( x + i * 1, y + i, 1, - (thickness), Color )
              Else
                Box( x + i * 1, y - i, 1, - (thickness), Color )
              EndIf
            EndIf
            If direction = 3 ; down
              If i < 0
                Box( x + i * 1, y + i, 1, (thickness), Color )
              Else
                Box( x + i * 1, y - i, 1, (thickness), Color )
              EndIf
            EndIf
          Next
          
        Else
          
          If framesize
            Color = $ffffffff
            For i = - framesize/2 To size 
              For j = i - framesize To size - i + framesize
                If direction = 0 ; left
                  Box( x - i * mode + framesize, y + j-size/2, mode, 1, Color )
                EndIf
                If direction = 1 ; up
                  Box( x + j-size/2, y - i * mode + framesize, 1, mode, Color )
                EndIf
                If direction = 2 ; right
                  Box( x + i * mode - framesize, y + j-size/2, mode, 1, Color )
                EndIf
                If direction = 3 ; down
                  Box( x + j-size/2, y + i * mode - framesize, 1, mode, Color )
                EndIf
              Next 
            Next
            Color = $ff000000
          EndIf
          
          For i = 0 To size
            For j = i To size - i 
              If direction = 0 ; left
                Box( x - i * mode + framesize, y + j-size/2, mode, 1, Color )
              EndIf
              If direction = 1 ; up
                Box( x + j-size/2, y - i * mode + framesize, 1, mode, Color )
              EndIf
              If direction = 2 ; right
                Box( x + i * mode - framesize, y + j-size/2, mode, 1, Color )
              EndIf
              If direction = 3 ; down
                Box( x + j-size/2, y + i * mode - framesize, 1, mode, Color )
              EndIf
            Next 
          Next
          
        EndIf
      EndIf
    EndProcedure
    
    Procedure   Draw_Container( *this._s_WIDGET )
      Protected i
      
      With *this
        If *this\fs
          draw_mode_alpha_( #PB_2DDrawing_Outlined )
          If BinaryFlag( *this\flag, #__flag_BorderSingle ) Or 
             BinaryFlag( *this\flag, #__flag_BorderDouble )
            draw_roundbox_(*this\frame_x( ), *this\frame_y( ), *this\round*2, *this\round*2, *this\round, *this\round, $FFAAAAAA )
            draw_roundbox_(*this\frame_x( )+*this\frame_width( )-*this\round*2, *this\frame_y( ), *this\round*2, *this\round*2, *this\round, *this\round, $FFFFFFFF )
            draw_roundbox_(*this\frame_x( ), *this\frame_y( )+*this\frame_height( )-*this\round*2, *this\round*2, *this\round*2, *this\round, *this\round, $FFAAAAAA )
            draw_roundbox_(*this\frame_x( )+*this\frame_width( )-*this\round*2, *this\frame_y( )+*this\frame_height( )-*this\round*2, *this\round*2, *this\round*2, *this\round, *this\round, $FFFFFFFF )
          EndIf
          If BinaryFlag( *this\flag, #__flag_BorderDouble )
            draw_roundbox_(*this\frame_x( )+1, *this\frame_y( )+1, *this\round*2, *this\round*2, *this\round, *this\round, $FFAAAAAA )
            draw_roundbox_(*this\frame_x( )+1+*this\frame_width( )-*this\round*2, *this\frame_y( )+1, *this\round*2, *this\round*2, *this\round, *this\round, $FFFFFFFF )
            draw_roundbox_(*this\frame_x( )+1, *this\frame_y( )-1+*this\frame_height( )-*this\round*2, *this\round*2, *this\round*2, *this\round, *this\round, $FFAAAAAA )
            draw_roundbox_(*this\frame_x( )-1+*this\frame_width( )-*this\round*2, *this\frame_y( )-1+*this\frame_height( )-*this\round*2, *this\round*2, *this\round*2, *this\round, *this\round, $FFFFFFFF )
          EndIf
        EndIf
        
        ;\\ backcolor
        draw_mode_alpha_( #PB_2DDrawing_Default )
        If *this\fs
          draw_roundbox_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), *this\round, *this\round, *this\color\back);[*this\ColorState( )] )
        Else
          draw_roundbox_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), *this\round, *this\round, *this\color\back);[*this\ColorState( )] )
        EndIf
        
        ;\\
        If *this\image\id Or
           *this\image[#__image_background]\id
          
          draw_mode_alpha_( #PB_2DDrawing_Default )
          
          ;\\ background image draw
          If *this\image[#__image_background]\id
            draw_background_image_( *this, *this\inner_x( ), *this\inner_y( ), [#__image_background] )
          EndIf
          
          ;\\ scroll image draw
          If *this\image\id
            DrawAlphaImage( *this\image\id,
                            *this\inner_x( ) + *this\scroll_x( ) + *this\image\x,
                            *this\inner_y( ) + *this\scroll_y( ) + *this\image\y, *this\AlphaState( ) )
          EndIf
        EndIf
        
        ;\\
        If *this\text\string
          draw_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\inner_x( ) + *this\scroll_x( ) + *this\text\x,
                    *this\inner_y( ) + *this\scroll_y( ) + *this\text\y,
                    *this\text\string, *this\color\front[\ColorState( )] & $FFFFFF | *this\AlphaState24( ) )
        EndIf
        
        
        If *this\fs
          draw_mode_alpha_( #PB_2DDrawing_Outlined )
          If BinaryFlag( *this\flag, #__flag_BorderFlat )
            If *this\inner_width( ) And 
               *this\inner_height( ) 
              draw_roundbox_( *this\frame_x( )+*this\fs[1], *this\frame_y( )+*this\fs[2], *this\frame_width( )-*this\fs[1]-*this\fs[3], *this\frame_height( )-*this\fs[2]-*this\fs[4], *this\round, *this\round, *this\color\frame )
            EndIf
            If *this\type = #__type_Container
              draw_roundbox_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), *this\round, *this\round, *this\color\frame )
            EndIf
            
          ElseIf BinaryFlag( *this\flag, #__flag_BorderSingle ) Or
                 BinaryFlag( *this\flag, #__flag_BorderDouble )
            Line(*this\frame_x( )+*this\fs[1]+*this\round, *this\frame_y( )+*this\fs[2], *this\frame_width( )-*this\fs[1]-*this\fs[3]-*this\round*2, 1, $FFAAAAAA)
            Line(*this\frame_x( ), *this\frame_y( )+*this\fs[2]+*this\round, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-*this\round*2, $FFAAAAAA)
            Line(*this\frame_x( )+*this\fs[1]+*this\round, *this\frame_y( )+*this\frame_height( )-1, *this\frame_width( )-*this\fs[1]-*this\fs[3]-*this\round*2, 1, $FFFFFFFF)
            Line(*this\frame_x( )+*this\frame_width( )-1, *this\frame_y( )+*this\fs[2]+*this\round, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-*this\round*2, $FFFFFFFF)
            ;                 draw_roundbox_(*this\inner_x( ) - 1, *this\inner_y( ) - 1, *this\inner_width( ) + 2, *this\inner_height( ) + 2, *this\round, *this\round, $FFAAAAAA )
            ;                 draw_roundbox_(*this\inner_x( ) - 2, *this\inner_y( ) - 2, *this\inner_width( ) + 3, *this\inner_height( ) + 3, *this\round, *this\round, $FFFFFFFF )
            
          ElseIf BinaryFlag( *this\flag, #__flag_BorderRaised )
            Line(*this\frame_x( )+*this\fs[1], *this\frame_y( )+*this\fs[2], *this\frame_width( )-*this\fs[1]-*this\fs[3], 1, $FFFFFFFF)
            Line(*this\frame_x( ), *this\frame_y( )+*this\fs[2], 1, *this\frame_height( )-*this\fs[2]-*this\fs[4], $FFFFFFFF)
            Line(*this\frame_x( )+*this\fs[1], *this\frame_y( )+*this\frame_height( )-1, *this\frame_width( )-*this\fs[1]-*this\fs[3], 1, $FF838383)
            Line(*this\frame_x( )+*this\frame_width( )-1, *this\frame_y( )+*this\fs[2], 1, *this\frame_height( )-*this\fs[2]-*this\fs[4], $FF838383)
            
            Line(*this\frame_x( )+*this\fs[1], *this\frame_y( )+*this\fs[2]+1, *this\frame_width( )-*this\fs[1]-*this\fs[3], 1, $FFFFFFFF)
            Line(*this\frame_x( )+1, *this\frame_y( )+*this\fs[2], 1, *this\frame_height( )-*this\fs[2]-*this\fs[4], $FFFFFFFF)
            Line(*this\frame_x( )+*this\fs[1]+1, *this\frame_y( )+*this\frame_height( )-2, *this\frame_width( )-*this\fs[1]-*this\fs[3]-2, 1, $FFAAAAAA)
            Line(*this\frame_x( )+*this\frame_width( )-2, *this\frame_y( )+*this\fs[2]+1, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-2, $FFAAAAAA)
          EndIf
          
          If BinaryFlag( *this\flag, #__flag_BorderDouble )
            ;                 Line(*this\frame_x( )+*this\fs[1], *this\frame_y( )+*this\fs[2]+1, *this\frame_width( )-*this\fs[1]-*this\fs[3], 1, $FF838383)
            ;                 Line(*this\frame_x( )+*this\fs[1]+1, *this\frame_y( )+*this\fs[2], 1, *this\frame_height( )-*this\fs[2]-*this\fs[4], $FF838383)
            ;                 Line(*this\frame_x( )+*this\fs[1]+1, *this\frame_y( )+*this\frame_height( )-2, *this\frame_width( )-*this\fs[1]-*this\fs[3]-2, 1, $FFE7E7E7)
            ;                 Line(*this\frame_x( )+*this\frame_width( )-2, *this\frame_y( )+*this\fs[2]+1, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-2, $FFE7E7E7)
            
            Line(*this\frame_x( )+*this\fs[1]+*this\round, *this\frame_y( )+1+*this\fs[2], *this\frame_width( )-*this\fs[1]-*this\fs[3]-*this\round*2, 1, $FF838383)
            Line(*this\frame_x( )+1, *this\frame_y( )+*this\fs[2]+*this\round, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-*this\round*2, $FF838383)
            Line(*this\frame_x( )+*this\fs[1]+*this\round, *this\frame_y( )+*this\frame_height( )-2, *this\frame_width( )-*this\fs[1]-*this\fs[3]-*this\round*2, 1, $FFE7E7E7)
            Line(*this\frame_x( )+*this\frame_width( )-2, *this\frame_y( )+*this\fs[2]+*this\round, 1, *this\frame_height( )-*this\fs[2]-*this\fs[4]-*this\round*2, $FFE7E7E7)
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Draw( *this._s_WIDGET )
      Protected arrow_right
      
      With *this
        If *this\redraw = 1
          *this\redraw = 0
          ; Debug " redraw - " + *this\class
        EndIf
        
        If *this\contex
          DrawAlphaImage( ImageID( *this\contex ), *this\x, *this\y )
          ;*this\contex = 0
          ProcedureReturn 0
        EndIf
        
        ;\\ draw belowe drawing
        If Not *this\hide
          ;Debug "DRAW( "+*this\class +" "+ *this\mouseenter
          If *this\resize\clip <> 0
            *this\resize\clip = 0
            Reclip( *this )
          EndIf
          
          ;\\
          If *this\draw_width( ) > 0 And
             *this\draw_height( ) > 0
            
            If *this\root\drawmode & 1<<2
              ;\\ init drawing font
              draw_font( *this, GetFontID( *this\root ) )
              ;
              CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                If CurrentFontID( )
                  DrawingFont( CurrentFontID( ) )
                EndIf
              CompilerEndIf
              ;
              ;\\
              If *this\disable = 1
                *this\disable = - 1
                
                If *this\haschildren
                  ChildrensState( *this, 2 )
                EndIf
              EndIf
              ;
              ;\\ limit drawing boundaries
              clip_output_( *this, [#__c_draw] )
              ;
              ;\\ draw widgets
              Select *this\type
                Case #__type_ScrollArea : Draw_Container( *this )
                Case #__type_Splitter : bar_draw( *this )
              EndSelect
              
              ;\\ draw area scrollbars
              If *this\scroll And ( *this\scroll\v Or *this\scroll\h )
                bar_area_draw( *this )
                ; clip_output_( *this, [#__c_draw] )
              EndIf
              
              ;\\ draw disable state
              If *this\disable
                draw_mode_alpha_( #PB_2DDrawing_Default )
                draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), $AAE4E4E4 )
              EndIf
            EndIf
            
            ; post event re draw
            If is_root_( *this )
              Send( *this, #__event_ReDraw );, #PB_All, *this )
                                            ; PostEvent( #PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #PB_EventType_Repaint )
            Else
              Send( *this, #__event_Draw )
            EndIf
          EndIf   
        EndIf
        
        
        
        ;\\ reset values
        If *this\WidgetChange( ) <> 0
          If Not *this\hide
            *this\WidgetChange( ) = 0
          EndIf
        EndIf
        If *this\text\TextChange( ) <> 0
          *this\text\TextChange( ) = 0
        EndIf
        If *this\image\ImageChange( ) <> 0
          *this\image\ImageChange( ) = 0
        EndIf
        
        If *this\resize\x <> 0
          *this\resize\x = 0
        EndIf
        If *this\resize\y <> 0
          *this\resize\y = 0
        EndIf
        If *this\resize\width <> 0
          *this\resize\width = 0
        EndIf
        If *this\resize\height <> 0
          *this\resize\height = 0
        EndIf
        
        If *this\resize\change <> 0
          *this\resize\change = 0
        EndIf
      EndWith
    EndProcedure
    
    Procedure   ReDraw( *root._s_root = 0 )
      If Not *root
        *root = __gui\drawingroot
      EndIf
      
      ;          ClearDebugOutput( )
      ;          ;\\
      If *root
        If *root\drawmode & 1<<1 And Not *root\drawmode & 1<<2
          VectorSourceColor($FFF0F0F0)
          FillVectorOutput( )
        EndIf
        ;\\
        If *root\drawmode & 1<<2
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            ; good transparent canvas
            FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
            ;             CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            ;               FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetSysColor_(#COLOR_BTNFACE) )
          CompilerElse
            ;               Protected *style.GtkStyle, *color.GdkColor
            ;               *style = gtk_widget_get_style_(WindowID(*root\canvas\window))
            ;               *color = *style\bg[0]                       ; 0=#GtkStateNormal
            ;               FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8) )
            FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
          CompilerEndIf
          ; FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetWindowColor(*root\canvas\window))
        EndIf
        ;\\
        Draw( *root )
        
        ;\\
        If Not ( *root\autosize And *root\haschildren = 0 )
          
          ;\\
          If StartEnumerate( *root )
            If *root\contex
              If Not widgets( )\redraw
                Continue
              EndIf
            EndIf
            
            Draw( widgets( ))
            
            StopEnumerate( )
          EndIf
          
          
          ;
        EndIf
        
        
      EndIf
      
      ProcedureReturn *root
    EndProcedure
    
    ;-
    Procedure.i Post( *this._s_WIDGET, eventtype.l, *button = #PB_All, *data = #Null )
      If *this > 0
        ; Debug "post - "+*this\class +" "+ ClassFromEvent(eventtype)
        
        If AddElement( __gui\eventqueue( ) )
          __gui\eventqueue.allocate( EVENTDATA, ( ) )
          __gui\eventqueue( )\widget = *this
          __gui\eventqueue( )\type   = eventtype
          __gui\eventqueue( )\item   = *button
          __gui\eventqueue( )\data   = *data
          ProcedureReturn __gui\eventqueue( )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i Send( *this._s_root, eventtype.l, *button = #PB_All, *data = #Null )
      Protected result, __widget = #Null, __type = #PB_All, __item = #PB_All, __data = #Null
      
      If *this > 0
        If __gui\eventexit >= 0
          If __gui\eventexit = 0
            Post( *this, eventtype, *button, *data )
            
          Else
            ;\\ 
            
            If *this\type = #__type_MenuBar Or *this\type = #__type_ToolBarBar
              ;
              If eventtype = #__event_LeftClick Or
                 eventtype = #__event_Change
                If *this\TabEntered( )
                  *button = *this\TabEntered( )\itemindex
                EndIf
              EndIf
              ;
              If *button < 0
                ProcedureReturn 0
              EndIf
            EndIf
            
            ;\\ 
            __widget = EventWidget( )
            __type   = WidgetEvent( )
            __item   = WidgetEventItem( )
            __data   = WidgetEventData( )
            
            ;\\
            EventWidget( )     = *this
            WidgetEvent( ) = eventtype
            WidgetEventItem( ) = *button
            WidgetEventData( ) = *data
            
            ;\\ menu send bind event
            If *this\type = #__type_MenuBar Or *this\type = #__type_ToolBarBar
              If *this\PopupBar( )
                While *this\PopupBar( )
                  *this = *this\PopupBar( )
                Wend
                EventWidget( )     = *this
              EndIf
            EndIf
            
            ; Debug "send - "+*this\class +" "+ ClassFromEvent(eventtype) +" "+ *button +" "+ *data
            
            
            ;
            ;\\
            If Not is_root_( *this )
              ;\\ first call (current-widget) bind event function
              If __gui\eventhook(Str(*this)+" "+Str(eventtype)+" "+Str(*button))
                result = __gui\eventhook( )\function( )
              ElseIf __gui\eventhook(Str(*this)+" "+Str(eventtype)+" "+Str(#PB_All)) 
                result = __gui\eventhook( )\function( )
              EndIf
              
              ;\\ second call (current-widget-window) bind event function
              If result <> #PB_Ignore
                If *this\window
                  If __gui\eventhook(Str(*this\window)+" "+Str(eventtype)+" "+Str(*button)) 
                    result = __gui\eventhook( )\function( )
                  ElseIf __gui\eventhook(Str(*this\window)+" "+Str(eventtype)+" "+Str(#PB_All)) 
                    result = __gui\eventhook( )\function( )
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;\\ theard call (current-widget-root) bind event function
            If result <> #PB_Ignore
              If *this\root
                If __gui\eventhook(Str(*this\root)+" "+Str(eventtype)+" "+Str(*button)) 
                  result = __gui\eventhook( )\function( )
                ElseIf __gui\eventhook(Str(*this\root)+" "+Str(eventtype)+" "+Str(#PB_All)) 
                  result = __gui\eventhook( )\function( )
                EndIf
              EndIf
            EndIf
            
            ;\\
            If eventtype = #__event_Close
              If result <> #PB_Ignore
                Select result
                  Case - 1
                    If is_root_( *this ) Or
                       is_window_( *this )
                      
                    EndIf
                    
                  Case 1
                    If *button >= 0
                      If Not IsWindow( *button )
                        
                      EndIf
                    EndIf
                    
                  Case 0
                    
                    
                EndSelect
              EndIf
            EndIf
            
            ;\\ если это оставить то после вызова функции напр setState( ) получается EventWidget( ) будеть равно #Null
            EventWidget( )       = __widget
            WidgetEvent( )   = __type
            WidgetEventItem( )   = __item
            WidgetEventData( )   = __data
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind( *this._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      ;
      If *this = #PB_All
        PushMapPosition(roots( ))
        ForEach roots( )
          Bind( roots( ), *callback, eventtype, item )
        Next
        PopMapPosition(roots( ))
        ProcedureReturn #PB_All
      EndIf
      ;
      If *this > 0
        *this\haseventhook = 1
        ;
        If eventtype = #PB_All 
          Define i
          For i = 0 To #__event_count - 1
            If i = #__event_Draw
              Continue
            EndIf
            Bind( *this, *callback, i, item )
          Next
        Else
          If eventtype >= 0  
            If Not FindMapElement( __gui\eventhook( ), Str(*this)+" "+Str(eventtype)+" "+Str(item) )
              AddMapElement(__gui\eventhook( ), Str(*this)+" "+Str(eventtype)+" "+Str(item))
              __gui\eventhook.allocate( HOOK, ( ))
            EndIf
            __gui\eventhook( )\function = *callback
            __gui\eventhook( )\type     = eventtype
            __gui\eventhook( )\item     = item
            __gui\eventhook( )\widget   = *this
          EndIf
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i Unbind( *this._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      ;
      If *this = #PB_All
        PushMapPosition(roots( ))
        ForEach roots( )
          UnBind( roots( ), *callback, eventtype, item )
        Next
        PopMapPosition(roots( ))
        ProcedureReturn #PB_All
      EndIf
      ;
      If *this > 0
        If eventtype = #PB_All 
          Define i
          For i = 0 To #__event_count - 1
            Unbind( *this, *callback, i, item )
          Next
        Else
          If eventtype >= 0  
            If FindMapElement( __gui\eventhook( ), Str(*this)+" "+Str(eventtype)+" "+Str(item) )
              DeleteMapElement(__gui\eventhook( ), Str(*this)+" "+Str(eventtype)+" "+Str(item))
            EndIf
          EndIf
        EndIf 
      EndIf
    EndProcedure
    
    ;-
    Procedure GetAtPoint( *root._s_root, mouse_x, mouse_y, List *List._s_WIDGET( ), *address = #Null )
      Protected i, a_index, Repaint, *this._s_WIDGET, *e._s_WIDGET
      
      ;\\ get at point address
      If *root\haschildren
        If ListSize( *list( ))
          If *address
            ChangeCurrentElement( *list( ), *address )
            PreviousElement( *list( ))
          Else
            LastElement( *list( ))
          EndIf
          Repeat
            If *list( )\address And
               *list( )\hide = 0 And
               *list( )\root = *root And 
               is_atpoint_( *list( ), mouse_x, mouse_y, [#__c_frame] ) And
               is_atpoint_( *list( ), mouse_x, mouse_y, [#__c_draw] )
              
              
              ;
              ;                      ;\\ get alpha
              ;                      If *list( )\anchors = 0 And
              ;                         ( *list( )\image[#__image_background]\id And
              ;                           *list( )\image[#__image_background]\depth > 31 And
              ;                           is_atpoint_( *list( ), mouse_x, mouse_y, [#__c_inner] ) And
              ;                           StartDrawing( ImageOutput( *list( )\image[#__image_background]\img )))
              ;                         
              ;                         draw_mode_( #PB_2DDrawing_AlphaChannel )
              ;                         If Not Alpha( Point( ( mouse( )\x - *list( )\inner_x( ) ) - 1,
              ;                                              ( mouse( )\y - *list( )\inner_y( ) ) - 1 ) )
              ;                            StopDrawing( )
              ;                            Continue
              ;                         Else
              ;                            StopDrawing( )
              ;                         EndIf
              ;                      EndIf
              
              ;\\ если переместили виджет то его исключаем
              
              *this = *list( )
              Break
            EndIf
          Until PreviousElement( *list( )) = #False
        EndIf
      EndIf
      ;
      ;\\ root no enumWidget
      If Not *this
        If is_atpoint_( *root, mouse_x, mouse_y, [#__c_frame] ) And
           is_atpoint_( *root, mouse_x, mouse_y, [#__c_draw] )
          *this = *root
        EndIf
      EndIf
      ;
      ;\\ is integral
      If *this
        ;\\ is integral string bar
        If *this\StringBox( ) And Not *this\StringBox( )\hide And
           is_atpoint_( *this\StringBox( ), mouse_x, mouse_y, [#__c_frame] ) And
           is_atpoint_( *this\StringBox( ), mouse_x, mouse_y, [#__c_draw] )
          *this = *this\StringBox( )
        EndIf
        ;\\ is integral tab bar
        If *this\TabBox( ) And Not *this\TabBox( )\hide And
           is_atpoint_( *this\TabBox( ), mouse_x, mouse_y, [#__c_frame] ) And
           is_atpoint_( *this\TabBox( ), mouse_x, mouse_y, [#__c_draw] )
          *this = *this\TabBox( )
        EndIf
        ;\\ is integral scroll bar's
        If *this\scroll
          If *this\scroll\v And Not *this\scroll\v\hide And
             is_atpoint_( *this\scroll\v, mouse_x, mouse_y, [#__c_frame] ) And
             is_atpoint_( *this\scroll\v, mouse_x, mouse_y, [#__c_draw] )
            *this = *this\scroll\v
          EndIf
          If *this\scroll\h And Not *this\scroll\h\hide And
             is_atpoint_( *this\scroll\h, mouse_x, mouse_y, [#__c_frame] ) And
             is_atpoint_( *this\scroll\h, mouse_x, mouse_y, [#__c_draw] )
            *this = *this\scroll\h
          EndIf
        EndIf
      EndIf
      
      ;\\ reset
      If EnteredButton( )
        If ( EnteredWidget( ) And
             EnteredWidget( ) <> *this )
          ;
          If Leaved( EnteredButton( ) )
            If EnteredWidget( )
              EnteredWidget( )\root\repaint = #True
            Else
              *this\root\repaint = #True
            EndIf
            EnteredButton( ) = #Null
          EndIf
        EndIf
      EndIf
      
      ;\\
      If *this
        ;If Not a_index( )
        If Not mouse( )\press
          ;\\
          DoEvent_Button( *this, #__event_MouseMove, mouse_x, mouse_y )
        EndIf
        ;EndIf
      EndIf
      
      ;\\ do events entered & leaved
      If EnteredWidget( ) <> *this
        LeavedWidget( ) = EnteredWidget( )
        EnteredWidget( ) = *this
        
        ;
        If LeavedWidget( ) And ;LeavedWidget( )\root = *root And 
           LeavedWidget( )\mouseenter > 0 And Not ( *this And *this\parent = LeavedWidget( ) And is_integral_( *this ) )
          LeavedWidget( )\mouseenter = 0
          ;
          DoEvents( LeavedWidget( ), #__event_MouseLeave )
          ;
          If LeavedWidget( )\parent And 
             is_integral_( LeavedWidget( ) ) And
             LeavedWidget( )\parent\mouseenter > 0 And 
             Not Bool( is_atpoint_( LeavedWidget( )\parent, mouse_x, mouse_y, [#__c_frame] ) And
                       is_atpoint_( LeavedWidget( )\parent, mouse_x, mouse_y, [#__c_draw] )) 
            ;
            LeavedWidget( )\parent\mouseenter = 0
            ;
            DoEvents( LeavedWidget( )\parent, #__event_MouseLeave, -1, -1 )
          EndIf
        EndIf
        ;
        ;
        ;If Not a_index( )
        If *this And ;*this\root = *root And 
           *this\mouseenter = 0 
          *this\mouseenter = 1
          
          If *this\parent And 
             is_integral_( *this ) 
            ;
            If *this\parent\mouseenter = 0
              If is_atpoint_( *this\parent, mouse_x, mouse_y, [#__c_frame] ) And
                 is_atpoint_( *this\parent, mouse_x, mouse_y, [#__c_draw] )
                ;
                *this\parent\mouseenter = 1
                ;
                DoEvents( *this\parent, #__event_MouseEnter, -1, -1 )
              EndIf
            Else
              ;   DoEvents( *this\parent, #__event_MouseMove, -1, -1 )
              DoEvents( *this\parent, #__event_ScrollChange, -1, -1 )
            EndIf
          EndIf
          
          DoEvents( *this, #__event_MouseEnter )
        EndIf
        ;EndIf
      EndIf
      
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure DoEvent_Button( *this._s_WIDGET, eventtype.l, mouse_x.l = - 1, mouse_y.l = - 1 )
      Protected._s_BUTTONS *EnteredButton, *BB1, *BB2, *BB0
      
      ;\\
      If *this\type = #__type_window
        *BB0 = *this\CloseButton( )
        *BB1 = *this\MaximizeButton( )
        *BB2 = *this\MinimizeButton( )
      Else
        If *this\bar
          *BB0 = *this\bar\button
          If *this\type <> #__type_splitter
            *BB1 = *this\bar\button[1]
            *BB2 = *this\bar\button[2]
          EndIf
        EndIf
      EndIf
      
      ;\\ get at-point-button address
      If *BB1 And *BB1\hide = 0 And is_atpoint_( *BB1, mouse_x, mouse_y )
        *EnteredButton = *BB1
      ElseIf *BB2 And *BB2\hide = 0 And is_atpoint_( *BB2, mouse_x, mouse_y )
        *EnteredButton = *BB2
      ElseIf *BB0 And *BB0\hide = 0 And is_atpoint_( *BB0, mouse_x, mouse_y )
        *EnteredButton = *BB0
      EndIf
      
      ;\\ do buttons events entered & leaved
      If EnteredButton( ) <> *EnteredButton
        If EnteredButton( ) And
           Leaved( EnteredButton( ) )
          *this\root\repaint = #True
        EndIf
        
        EnteredButton( ) = *EnteredButton
        
        If EnteredButton( ) And
           Entered( EnteredButton( ) )
          ;
          If EnteredButton( ) = *BB0
            If EnteredButton( )\enter > 0
              EnteredButton( )\enter = - 1
            EndIf
          EndIf
          *this\root\repaint = #True
        EndIf
      EndIf
      
      ;\\
      If Not EnteredButton( )
        If *this\caption
          *this\caption\interact = is_atpoint_( *this\caption, mouse( )\x, mouse( )\y )
        EndIf
      EndIf
    EndProcedure
    
    Procedure DoEvents( *this._s_WIDGET, eventtype.l, *button = #PB_All, *data = #Null )
      If Not *this
        ProcedureReturn 0
      EndIf
      If *this\disable
        ProcedureReturn 0
      EndIf
      
      ;
      ;\\ entered position state
      If *this\mouseenter > 0
        If is_innerside_( *this, mouse( )\x, mouse( )\y )
          If *this\mouseenter = 1
            MouseEnter( *this )
          EndIf
        ElseIf MouseEnter( *this )
          *this\mouseenter        = 1
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_cursor
        Protected cursor, result
        
        result = Send( *this, eventtype, #PB_All, *data )
        If result > 0
          cursor = result
        Else
          cursor = CurrentCursor( )
        EndIf
        
        ;Debug " DO CURSOR "+*this\class +" "+ cursor +" TYPE "+ *data
        Cursor::Set( *this\root\canvas\gadget, cursor ) 
      EndIf
      
      
      ;\\ repaint state
      Select eventtype
        Case #__event_ScrollChange,
             #__event_StatusChange,
             #__event_Focus,
             #__event_LostFocus, 
             #__event_MouseEnter,
             #__event_MouseLeave,
             #__event_Down,
             #__event_Up,
             #__event_LeftButtonDown,
             #__event_LeftButtonUp,
             #__event_LeftClick,
             #__event_Left2Click,
             #__event_Left3Click,
             #__event_RightButtonDown,
             #__event_RightButtonUp,
             #__event_RightClick,
             #__event_Right2Click,
             #__event_Right3Click,
             #__event_KeyDown,
             #__event_KeyUp,
             #__event_Drop,
             #__event_DragStart
          
          ; If *this\row
          *this\root\repaint = #True
          ; EndIf
          
          *this\redraw = 1
          *this\root\contex = 0
          
      EndSelect
      
      ;\\ widgets events
      Select *this\type
        Case #__type_ScrollBar,
             #__type_Splitter
          
          If bar_Events( *this, eventtype )
            *this\root\repaint = #True
          EndIf
          ;\\
      EndSelect
      
      
      
      
      ;\\ mouse wheel horizontal
      If eventtype = #__event_MouseWheelX
        ; Debug "wheelX " + *data
        If *this\scroll And *this\scroll\h And
           bar_PageChange( *this\scroll\h, *this\scroll\h\bar\page\pos - *data, 2 )
          *this\root\repaint = #True
        ElseIf *this\bar And bar_PageChange( *this, *this\bar\page\pos - *data, 2 )
          *this\root\repaint = #True
        EndIf
      EndIf
      
      ;\\ mouse wheel verticl
      If eventtype = #__event_MouseWheelY
        ; Debug "wheelY " + *data
        If *this\scroll And *this\scroll\v And 
           bar_PageChange( *this\scroll\v, *this\scroll\v\bar\page\pos - *data, 2 )
          *this\root\repaint = #True
        ElseIf *this\bar And bar_PageChange( *this, *this\bar\page\pos - *data, 2 )
          *this\root\repaint = #True
        EndIf
      EndIf
      
      ;          ;\\ mouse wheel 
      ;          If eventtype = #__event_MouseWheelX Or eventtype = #__event_MouseWheelY
      ;             ;
      ;             If *this\bar And
      ;                bar_PageChange( *this, *this\bar\page\pos - *data, 2 )
      ;                Debug "wheel " + *data
      ;                *this\root\repaint = #True
      ;             EndIf
      ;          EndIf
      
      ;\\ send-widget-events
      If Not *this\disable
        If eventtype = #__event_Cursor
        ElseIf eventtype = #__event_Create
        ElseIf eventtype = #__event_Focus
        ElseIf eventtype = #__event_LostFocus
        Else
          Send( *this, eventtype, *button, *data )
        EndIf
      EndIf
      
      ;\\ cursor update
      Select eventtype
        Case #__event_MouseEnter,
             #__event_DragStart,
             #__event_MouseMove, 
             #__event_MouseLeave, 
             #__event_Down,
             #__event_Up
          
          ;If Not a_index( )
          ;\\ after post&send drag-start-event
          If mouse( )\drag
            If *this\drop And MouseEnter( *this ) And 
               *this\drop\format = mouse( )\drag\format And
               *this\drop\actions & mouse( )\drag\actions And
               ( *this\drop\private = mouse( )\drag\private Or
                 *this\drop\private & mouse( )\drag\private )
            Else
              If *this\press
                If Cursor( *this ) <> CurrentCursor( )
                  Cursor( *this ) = CurrentCursor( )
                  DoEvents( *this, #__event_Cursor, #PB_All, 299 )
                EndIf
              Else
                
              EndIf
            EndIf
          Else
            If eventtype = #__event_DragStart
              CurrentCursor( ) = Cursor( *this ) 
            EndIf    
          EndIf
          
          If PressedWidget( ) And PressedWidget( )\press 
            If CurrentCursor( ) <> Cursor( PressedWidget( ) )
              Debug "change pressed cursor"
              DoCurrentCursor( PressedWidget( ), Cursor( PressedWidget( ) ), 2 )
            EndIf
          Else
            If MouseEnter( *this )
              DoCurrentCursor( *this, Cursor( *this ), 1 )
            Else
              If EnteredWidget( ) And
                 MouseEnter( EnteredWidget( ) )
                ;
                If PressedWidget( ) And
                   PressedWidget( )\root <> EnteredWidget( )\root
                  DoCurrentCursor( PressedWidget( )\root, Cursor( PressedWidget( )\root ), 8 )
                EndIf
                ;
                DoCurrentCursor( EnteredWidget( ), Cursor( EnteredWidget( ) ), 3 )
              Else
                ; если внутри виджета покинули область где надо менять курсор
                If EnteredWidget( )
                  If EnteredWidget( )\mouseenter > 0
                    DoCurrentCursor( EnteredWidget( ), cursor::#__cursor_Default, 5 )
                  Else
                    ;Debug *this\mouseenter
                    
                    ; from button to splitter
                    If Not *this\mouseenter
                      If EnteredWidget( )\mouseenterframe =- 1 ; ???
                        DoCurrentCursor( EnteredWidget( ), Cursor( EnteredWidget( ) ), 4 )
                      EndIf
                    EndIf
                  EndIf
                Else
                  DoCurrentCursor( *this, cursor::#__cursor_Default, 7 )
                EndIf
              EndIf
            EndIf
          EndIf
          ;EndIf
      EndSelect
      
      ;\\ post repaint canvas
      If Not *this\disable
        If *this\root\repaint = 1
          ; Debug ""+" ["+*this\ColorState( )+"] "+*this\class +" "+ ClassFromEvent(eventtype)
          PostEventRepaint( *this\root )
          *this\root\repaint = 0
        EndIf
      EndIf
    EndProcedure
    
    ;-
    Procedure CanvasEvents( )
      Protected eventtype = EventType( )
      Protected eventGadget = EventGadget( )
      
      EventHandler( #PB_Event_Gadget, EventGadget( ), EventType( ), EventData( ) )
    EndProcedure
    
    Procedure EventHandler( event = - 1, eventgadget = - 1, eventtype = - 1, eventdata = 0 )
      ;Debug ""+ event +" "+ eventgadget +" "+ eventtype
      
      Static EnteredCanvasID
      Protected *root._s_root, repaint, mouse_x , mouse_y
      
      ;\\
      If event = #PB_Event_Repaint
        If eventdata
          If eventdata <> root( )\canvas\gadgetID
            ChangeCurrentCanvas( eventdata )
          EndIf
          If root( )\canvas\post = 1
            If __gui\eventexit <> 1
              Repost( )
            EndIf
            
            Repaint( root( ) )
            root( )\canvas\post = 0
          EndIf
          If EnteredCanvasID
            If EnteredCanvasID <> root( )\canvas\gadgetID
              ChangeCurrentCanvas( EnteredCanvasID )
            EndIf
          EndIf
        EndIf
        ProcedureReturn event
      EndIf
      
      ;\\
      
      ;\\
      
      ;\\
      If event = #PB_Event_Gadget
        ; from PB event to widget event 
        If eventtype = #PB_EventType_Resize
          eventtype = #__event_Resize
        EndIf
        If eventtype = #PB_EventType_MouseEnter
          eventtype = #__event_MouseEnter
        EndIf
        If eventtype = #PB_EventType_MouseMove
          eventtype = #__event_MouseMove
        EndIf
        If eventtype = #PB_EventType_MouseLeave
          eventtype = #__event_MouseLeave
        EndIf
        ;
        If eventtype = #PB_EventType_KeyDown
          eventtype = #__event_KeyDown
        EndIf
        If eventtype = #PB_EventType_Input
          eventtype = #__event_Input
        EndIf
        If eventtype = #PB_EventType_KeyUp
          eventtype = #__event_KeyUp
        EndIf
        ;
        If eventtype = #PB_EventType_LeftButtonDown
          eventtype = #__event_LeftButtonDown
        EndIf
        If eventtype = #PB_EventType_MiddleButtonDown
          eventtype = #__event_MiddleButtonDown
        EndIf
        If eventtype = #PB_EventType_RightButtonDown
          eventtype = #__event_RightButtonDown
        EndIf
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          eventtype = #__event_LeftButtonUp
        EndIf
        If eventtype = #PB_EventType_MiddleButtonUp
          eventtype = #__event_MiddleButtonUp
        EndIf
        If eventtype = #PB_EventType_RightButtonUp
          eventtype = #__event_RightButtonUp
        EndIf
        ;
        If eventtype = #PB_EventType_Focus
          eventtype = #__event_Focus
        EndIf
        If eventtype = #PB_EventType_LostFocus
          eventtype = #__event_LostFocus
        EndIf
        ;
        If eventtype = #PB_EventType_MouseWheelX
          eventtype = #__event_MouseWheelX
          mouse( )\wheel\x = eventdata
        EndIf
        If eventtype = #PB_EventType_MouseWheelY
          eventtype = #__event_MouseWheelY
          mouse( )\wheel\y = eventdata
        EndIf
        
        ;\\
        If eventtype = #__event_Resize ;: PB(ResizeGadget)( eventgadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Debug "resize - canvas ["+eventgadget+"]"
          ; ;               *root = root( )
          ;PushMapPosition( roots( ) )
          If Not ( root( ) And root( )\canvas\gadget = eventgadget )
            ChangeCurrentCanvas( GadgetID( eventgadget ) )
          EndIf   
          Resize( root( ), 0, 0, PB(GadgetWidth)( eventgadget ), PB(GadgetHeight)( eventgadget ) )
          
          ;PopMapPosition( roots( ) )
          ; ; ;                ;root( ) = *root
          ProcedureReturn event
        EndIf
        
        ;\\
        If eventtype = #__event_MouseEnter
          If Not mouse( )\interact
            If IsGadget( eventgadget ) And
               GadgetType( eventgadget ) = #PB_GadgetType_Canvas
              EnteredCanvasID = GadgetID( eventgadget )
              If Not ( root( ) And root( )\canvas\gadgetID = EnteredCanvasID )
                ChangeCurrentCanvas( EnteredCanvasID )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_MouseLeave
          If PressedWidget( ) And
             root( ) <> PressedWidget( )\root
            eventgadget = PressedWidget( )\root\canvas\gadget
            ChangeCurrentCanvas( GadgetID( eventgadget ) )
          EndIf
          EnteredCanvasID = #Null
        EndIf
        
        ;\\
        If eventtype = #__event_LeftButtonUp Or
           eventtype = #__event_RightButtonDown Or
           eventtype = #__event_MiddleButtonDown
          ;
          If EnteredCanvasID
            If EnteredCanvasID <> root( )\canvas\gadgetID
              ChangeCurrentCanvas( EnteredCanvasID )
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_KeyDown Or
           eventtype = #__event_Input Or
           eventtype = #__event_KeyUp
          
          ;\\
          If GetActive( )
            Keyboard( )\key[1] = GetGadgetAttribute( GetActive( )\root\canvas\gadget, #PB_Canvas_Modifiers )
            ;
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              If Keyboard( )\key[1] & #PB_Canvas_Command
                Keyboard( )\key[1] & ~ #PB_Canvas_Command
                Keyboard( )\key[1] | #PB_Canvas_Control
              EndIf
            CompilerEndIf
            ;
            ;\\
            If eventtype = #__event_Input
              Keyboard( )\input = GetGadgetAttribute( GetActive( )\root\canvas\gadget, #PB_Canvas_Input )
            Else
              Keyboard( )\Key = GetGadgetAttribute( GetActive( )\root\canvas\gadget, #PB_Canvas_Key )
            EndIf
            ;
            ;\\ keyboard events
            If eventtype = #__event_KeyDown
              DoEvents( GetActive( ), eventtype )
              ;
              ;\\ tab focus
              Select Keyboard( )\Key
                Case #PB_Shortcut_Tab
                  
              EndSelect
            EndIf
            If eventtype = #__event_Input
              DoEvents( GetActive( ), eventtype )
            EndIf
            If eventtype = #__event_KeyUp
              DoEvents( GetActive( ), eventtype )
              ;
              Keyboard( )\key[1] = 0
              Keyboard( )\Key    = 0
            EndIf
          EndIf
        EndIf
        
        ;             If root( )
        ;                Debug " "+root( )\class +" "+ ClassFromEvent(eventtype) +" "+ root( )\canvas\gadget +" "+ eventgadget
        ;             EndIf
        
        ;\\
        ;\\
        Select eventtype
          Case #__event_MouseEnter,
               #__event_MouseLeave,
               #__event_MouseMove
            
            If root( ) And
               root( )\canvas\gadget = eventgadget
              mouse_x               = CanvasMouseX( eventgadget )
              mouse_y               = CanvasMouseY( eventgadget )
              
              ;\\
              If eventtype = #__event_MouseEnter
                mouse( )\change = 1 << 0
                mouse( )\x      = mouse_x
                mouse( )\y      = mouse_y
              EndIf
              If eventtype = #__event_MouseLeave
                mouse( )\change = - 1
                mouse( )\x      = - 1
                mouse( )\y      = - 1
              EndIf
              If eventtype = #__event_MouseMove
                ;\\
                If mouse( )\x <> mouse_x
                  If mouse( )\x < mouse_x
                    mouse( )\change | 1 << 3
                  Else
                    mouse( )\change | 1 << 1
                  EndIf
                  mouse( )\x = mouse_x
                EndIf
                If mouse( )\y <> mouse_y
                  If mouse( )\y < mouse_y
                    mouse( )\change | 1 << 4
                  Else
                    mouse( )\change | 1 << 2
                  EndIf
                  mouse( )\y = mouse_y
                EndIf
                
              EndIf
            EndIf
            
          Case #__event_LeftButtonDown,
               #__event_RightButtonDown,
               #__event_MiddleButtonDown
            ;Debug "      canvas down " + eventgadget
            ;
            ;\\
            Static ClickTime.q
            Protected ElapsedMilliseconds.q = ElapsedMilliseconds( )
            If DoubleClickTime( ) > ( ElapsedMilliseconds - ClickTime ) ;+ Bool( #PB_Compiler_OS = #PB_OS_Windows ) * 492
              mouse( )\click + 1
            Else
              mouse( )\click = 1
            EndIf
            ClickTime = ElapsedMilliseconds
            ;
            mouse( )\press  = 1
            mouse( )\change = 1 << 5
            ;
            mouse( )\delta.allocate( POINT )
            mouse( )\delta\x = mouse( )\x
            mouse( )\delta\y = mouse( )\y
            ;
            If eventtype = #__event_LeftButtonDown : mouse( )\buttons | #PB_Canvas_LeftButton : EndIf
            If eventtype = #__event_RightButtonDown : mouse( )\buttons | #PB_Canvas_RightButton : EndIf
            If eventtype = #__event_MiddleButtonDown : mouse( )\buttons | #PB_Canvas_MiddleButton : EndIf
            ;
          Case #__event_LeftButtonUp,
               #__event_RightButtonUp,
               #__event_MiddleButtonUp
            ;Debug "     canvas up " + eventgadget
            ;
            If mouse( )\interact = 1
              mouse( )\interact = - 1
            EndIf
            ;
            ;\\
            ; mouse( )\delta = 0
            mouse( )\press = 0
            mouse( )\change = 1 << 6
            ;
            If root( ) And
               root( )\canvas\gadget = eventgadget
              mouse( )\x            = CanvasMouseX( eventgadget )
              mouse( )\y            = CanvasMouseY( eventgadget )
            EndIf
        EndSelect
        
        ;\\ get enter&leave widget address
        If mouse( )\interact <> 1
          If mouse( )\change
            If root( ) And root( )\canvas\gadget = eventgadget
              ;                      If root( )
              ;                          Debug "    "+root( )\class +" "+ ClassFromEvent(eventtype)
              ;                      EndIf
              ;                      If ListSize( __gui\intersect( ) )
              ;                         GetAtPoint( root( ), mouse( )\x, mouse( )\y, __gui\intersect( ) )
              ;                      Else
              GetAtPoint( root( ), mouse( )\x, mouse( )\y, widgets( ) )
              ;                      EndIf
              
              If eventtype = #__event_LeftButtonDown Or
                 eventtype = #__event_MiddleButtonDown Or
                 eventtype = #__event_RightButtonDown
                
                If EnteredWidget( )
                  If EnteredWidget( )\image[#__image_background]\id And
                     EnteredWidget( )\image[#__image_background]\depth > 31  
                    
                    ;If is_innerside_(EnteredWidget( )\image[#__image_background]\img ))
                    If StartDrawing( ImageOutput(  EnteredWidget( )\image[#__image_background]\img ) )
                      DrawingMode( #PB_2DDrawing_AlphaChannel )
                      
                      If Not Alpha( Point( mouse( )\x - EnteredWidget( )\inner_x( ), mouse( )\y - EnteredWidget( )\inner_y( ) ) )
                        GetAtPoint( root( ), mouse( )\x, mouse( )\y, widgets( ), EnteredWidget( )\address )
                      EndIf
                      
                      StopDrawing( )
                    EndIf
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
            EndIf
          EndIf
        EndIf
        
        ;\\ do all events
        If eventtype = #__event_Focus
          
        ElseIf eventtype = #__event_LostFocus
          
        ElseIf eventtype = #__event_MouseMove
          If mouse( )\change > 1
            ;\\ mouse-pressed-widget move event
            If PressedWidget( ) And 
               PressedWidget( ) <> EnteredWidget( )
              ;
              If root( ) <> PressedWidget( )\root
                mouse( )\x = CanvasMouseX( PressedWidget( )\root\canvas\gadget )
                mouse( )\y = CanvasMouseY( PressedWidget( )\root\canvas\gadget )
              EndIf
              DoEvents( PressedWidget( ), eventtype )
            EndIf
            
            ;\\ mouse-entered-widget move event
            If EnteredWidget( ) And
               EnteredWidget( )\mouseenter
              ;
              If PressedWidget( ) And
                 PressedWidget( )\root <> root( )
                mouse( )\x = CanvasMouseX( root( )\canvas\gadget )
                mouse( )\y = CanvasMouseY( root( )\canvas\gadget )
              EndIf
              DoEvents( EnteredWidget( ), eventtype )
            EndIf
          EndIf
          
        ElseIf eventtype = #__event_LeftButtonDown Or
               eventtype = #__event_MiddleButtonDown Or
               eventtype = #__event_RightButtonDown
          ;
          If EnteredWidget( )
            ;
            ;\\ mouse delta (x&y)
            If eventtype <> #__event_MiddleButtonDown
              ;If Not a_index( )
              If Not EnteredWidget( )\anchors
                If EnteredWidget( )\bar And EnteredButton( ) > 0
                  mouse( )\delta\x - EnteredWidget( )\bar\thumb\pos
                  mouse( )\delta\y - EnteredWidget( )\bar\thumb\pos
                Else
                  mouse( )\delta\x - EnteredWidget( )\container_x( )
                  mouse( )\delta\y - EnteredWidget( )\container_y( )
                  ;
                  If EnteredWidget( )\parent
                    If Not EnteredWidget( )\child
                      mouse( )\delta\x - EnteredWidget( )\parent\scroll_x( )
                      mouse( )\delta\y - EnteredWidget( )\parent\scroll_y( )
                    EndIf
                  EndIf
                EndIf
              EndIf
              ;EndIf
            EndIf
            ;
            ;\\ set active widget
            If EnteredWidget( )\disable
              
            Else
              PressedWidget( )       = EnteredWidget( )
              PressedWidget( )\press = #True
              
            EndIf
            ;
            ;\\
            DoEvents( EnteredWidget( ), #__event_Down )
            ;
            If mouse( )\click = 1
              DoEvents( EnteredWidget( ), eventtype )
            EndIf
          EndIf
          
        ElseIf eventtype = #__event_LeftButtonUp Or
               eventtype = #__event_MiddleButtonUp Or
               eventtype = #__event_RightButtonUp
          
          ;\\
          If PressedWidget( )
            ;\\ do up&click events
            If PressedWidget( )\press
              
              ;\\ do drop events
              If mouse( )\drag
                ;\\ reset dragged cursor
                If Cursor( PressedWidget( ) ) <> PressedWidget( )\cursor
                  Debug "free drop CURSOR "
                  Cursor( PressedWidget( ) ) = PressedWidget( )\cursor 
                EndIf
                
                ;\\ reset
                FreeStructure( mouse( )\drag)
                mouse( )\drag = #Null
              EndIf
              
              ;\\ do enter&leave events
              ;
              PressedWidget( )\press = #False
              ;\\
              DoEvents( PressedWidget( ), #__event_Up )
              
              ;\\ do up events
              If mouse( )\click = 1
                DoEvents( PressedWidget( ), eventtype )
              EndIf
              
              ;\\ do 1click events
              If PressedWidget( ) = EnteredWidget( )
                If eventtype = #__event_LeftButtonUp
                  DoEvents( PressedWidget( ), #__event_LeftClick )
                EndIf
                If eventtype = #__event_RightButtonUp
                  DoEvents( PressedWidget( ), #__event_RightClick )
                EndIf
              EndIf
              
              ;\\ do 2click events
              If mouse( )\click = 2
                If eventtype = #__event_LeftButtonUp
                  DoEvents( PressedWidget( ), #__event_Left2Click )
                EndIf
                If eventtype = #__event_RightButtonUp
                  DoEvents( PressedWidget( ), #__event_Right2Click )
                EndIf
                
                ;\\ do 3click events
              ElseIf mouse( )\click = 3
                If eventtype = #__event_LeftButtonUp
                  DoEvents( PressedWidget( ), #__event_Left3Click )
                EndIf
                If eventtype = #__event_RightButtonUp
                  DoEvents( PressedWidget( ), #__event_Right3Click )
                EndIf
                
              EndIf
            EndIf
            
            PressedWidget( ) = 0
          EndIf
          
        ElseIf eventtype = #__event_MouseWheelX Or
               eventtype = #__event_MouseWheelY
          ;
          If EnteredWidget( );
            If eventtype = #__event_MouseWheelX
              ;                      If EnteredWidget( )
              ;                         If EnteredWidget( )\scroll And EnteredWidget( )\scroll\h
              ;                            DoEvents( EnteredWidget( )\scroll\h, eventtype, -1, eventdata )
              ;                         Else
              ;                            DoEvents( EnteredWidget( ), eventtype, -1, eventdata )
              ;                         EndIf
              ;                      EndIf
            EndIf
            
            If eventtype = #__event_MouseWheelY
              ;                      If EnteredWidget( )
              ;                         If EnteredWidget( )\scroll And EnteredWidget( )\scroll\v
              ;                            DoEvents( EnteredWidget( )\scroll\v, eventtype, -1, eventdata )
              ;                         Else
              ;                            DoEvents( EnteredWidget( ), eventtype, -1, eventdata )
              ;                         EndIf
              ;                      EndIf
            EndIf
            
            If is_integral_( EnteredWidget( ) )
              DoEvents( EnteredWidget( )\parent, eventtype, -1, eventdata )
            Else
              DoEvents( EnteredWidget( ), eventtype, -1, eventdata )
            EndIf
          EndIf
        EndIf
        
        ; reset
        If eventtype = #__event_LeftButtonUp Or
           eventtype = #__event_MiddleButtonUp Or
           eventtype = #__event_RightButtonUp
          ;
          
          ;\\ reset mouse states
          mouse( )\interact = 0
          mouse( )\buttons = 0
          If mouse( )\delta
            mouse( )\delta\x = 0
            mouse( )\delta\y = 0
            mouse( )\delta = #Null
          EndIf
        EndIf
        ;
        If mouse( )\change <> #False
          mouse( )\change = #False
        EndIf
        ProcedureReturn #PB_Event_Gadget
      EndIf
      
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = PB(GetWindowData)( PB(EventWindow)( ))
      Debug "- resize - os - window -"
      ; PB(ResizeGadget)( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
      PB(ResizeGadget)( canvas, #PB_Ignore, #PB_Ignore, PB(WindowWidth)( PB(EventWindow)( )) - PB(GadgetX)( canvas ) * 2, PB(WindowHeight)( PB(EventWindow)( )) - PB(GadgetY)( canvas ) * 2 ) ; bug
    EndProcedure
    
    Procedure EventRepaint( )
      If EventData( )
        EventHandler( #PB_Event_Repaint, EventGadget( ), #PB_Default, EventData( ) )
      EndIf
    EndProcedure
    
    Procedure EventActivate( )
      EventHandler( #PB_Event_ActivateWindow, #PB_Default, #PB_Default, #Null )
    EndProcedure
    
    Procedure EventDeactivate( )
      EventHandler( #PB_Event_DeactivateWindow, #PB_Default, #PB_Default, #Null )
    EndProcedure
    
    ;-
    Procedure.i CloseList( )
      Protected *open._s_WIDGET
      ; Debug "close - "+Opened( )\_index;text\string
      
      ;\\ 1-test splitter
      If Opened( ) And
         Opened( )\type = #__type_Splitter
        
        Opened( )\split_1( ) = Opened( )\FirstWidget( )
        Opened( )\split_2( ) = Opened( )\LastWidget( )
        
        bar_Update( Opened( ), #True )
      EndIf
      
      If Opened( ) And
         Opened( )\parent
        
        If Opened( )\parent\type = #__type_MDI
          *open = Opened( )\parent\parent
        Else
          If Opened( )\Lastroot( )
            *open                 = Opened( )\Lastroot( )
            Opened( )\Lastroot( ) = #Null
          Else
            If Opened( ) = Opened( )\root
              *open = Opened( )\root\Beforeroot( )
            Else
              *open = Opened( )\parent
            EndIf
          EndIf
        EndIf
      Else
        *open = root( )
      EndIf
      
      If *open = Opened( )
        If *open\root\Beforeroot( )
          UseGadgetList( WindowID(*open\root\Beforeroot( )\canvas\window))
          ; Debug ""+*open\root\Beforeroot( )\canvas\window +" "+Opened( )\root\canvas\window
          *open = *open\root\Beforeroot( )
        EndIf
      EndIf
      
      If *open And
         Opened( ) <> *open
        Opened( ) = *open
        ; OpenList( *open )
      EndIf
    EndProcedure
    
    Procedure.i OpenList( *this._s_WIDGET, item.l = 0 )
      Protected result.i = Opened( )
      
      If *this = Opened( )
        If *this\TabAddIndex( ) = item
          ProcedureReturn result
        EndIf
      EndIf
      
      If *this
        If *this\parent <> Opened( )
          *this\Lastroot( ) = Opened( )
        EndIf
        
        If *this\root
          If *this\root <> root( )
            If Opened( )\root
              Opened( )\root\Afterroot( ) = *this\root
            EndIf
            *this\root\Beforeroot( ) = Opened( )\root
            
            If is_root_( *this )
              ChangeCurrentCanvas(*this\root\canvas\GadgetID )
            EndIf
          EndIf
        EndIf
        
        ; add 
        If *this\TabBox( ) And 
           *this\TabBox( )\type = #__type_TabBarBar
          *this\TabAddIndex( ) = item
        EndIf
        
        Opened( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure Open( window, x.l = 0, y.l = 0, width.l = #PB_Ignore, height.l = #PB_Ignore, title$ = #Null$, flag.q = #Null, *parentID = #Null, Canvas = #PB_Any )
      Protected result, w, g, canvasflag = #PB_Canvas_Keyboard, UseGadgetList, *root._s_root 
      
      ; init
      If Not MapSize( roots( ) )
        events::SetCallback( @EventHandler( ) )
      EndIf
      
      If PB(IsWindow)( Window )
        w = WindowID( Window )
        ;
        ;             If BinaryFlag( Flag, #PB_Window_NoGadgets )
        ;                flag &~ #PB_Window_NoGadgets
        ;             EndIf
        If BinaryFlag( Flag, #PB_Canvas_Container ) 
          flag &~ #PB_Canvas_Container
          canvasflag | #PB_Canvas_Container
        EndIf
        If width = #PB_Ignore And 
           height = #PB_Ignore
          canvasflag | #PB_Canvas_Container
        EndIf
      Else
        If BinaryFlag( Flag, #PB_Window_NoGadgets ) 
          flag &~ #PB_Window_NoGadgets
        Else
          canvasflag | #PB_Canvas_Container
        EndIf
        ;
        ; then bug in windows
        If Window = #PB_Any
          Window = 300 + MapSize( roots( ) )
        EndIf
        ;
        w = OpenWindow( Window, x, y, width, height, title$, flag, *parentID )
        If Window = #PB_Any 
          Window = w 
          w = WindowID( Window ) 
        EndIf
        ;
        If BinaryFlag( Flag, #PB_Window_BorderLess )
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            If CocoaMessage(0, w, "hasShadow") = 0
              CocoaMessage(0, w, "setHasShadow:", 1)
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If GetClassLongPtr_( w, #GCL_STYLE ) & #CS_DROPSHADOW = 0
              SetClassLongPtr_( w, #GCL_STYLE, #CS_DROPSHADOW )
            EndIf
            ;SetWindowLongPtr_(w,#GWL_STYLE,GetWindowLongPtr_(w,#GWL_STYLE)&~#WS_BORDER) 
            SetWindowLongPtr_(w,#GWL_STYLE,GetWindowLongPtr_(w,#GWL_STYLE)&~#WS_CAPTION) 
            SetWindowLongPtr_(w,#GWL_EXSTYLE,GetWindowLongPtr_(w,#GWL_EXSTYLE)|#WS_EX_NOPARENTNOTIFY) 
          CompilerElse
            ;  
          CompilerEndIf
        EndIf
        ;
        x = 0
        y = 0
      EndIf
      
      ;\\ get a handle from the previous usage list
      If w
        UseGadgetList = UseGadgetList( w )
      EndIf
      ;
      If x = #PB_Ignore : x = 0 : EndIf
      If y = #PB_Ignore : y = 0 : EndIf
      ;
      If width = #PB_Ignore
        width = WindowWidth( Window, #PB_Window_InnerCoordinate )
        If x <> #PB_Ignore
          If x > 0 And x < 50 
            width - x * 2
          EndIf
        EndIf
      EndIf
      ;
      If height = #PB_Ignore
        height = WindowHeight( Window, #PB_Window_InnerCoordinate )
        If y <> #PB_Ignore
          If y > 0 And y < 50 
            height - y * 2
          EndIf
        EndIf
      EndIf
      ;
      If PB(IsGadget)(Canvas)
        g = GadgetID( Canvas )
      Else
        g = CanvasGadget( Canvas, x, y, width, height, canvasflag )
        If Canvas = - 1 : Canvas = g : g = PB(GadgetID)(Canvas) : EndIf
      EndIf
      ;
      If UseGadgetList And w <> UseGadgetList
        UseGadgetList( UseGadgetList )
      EndIf
      
      ;
      If Not FindMapElement( roots( ), Str( g ) ) ; ChangeCurrentCanvas(g)
        result     = AddMapElement( roots( ), Str( g ) )
        roots( ) = AllocateStructure( _s_root )
        root( )    = roots( )
        *root      = roots( )
        
        
        ;
        *root\root      = *root
        
        *root\container = 1
        *root\address   = result
        *root\type      = #__type_Container
        
        *root\class     = "root"
        ;*root\window   = *root
        ;*root\parent   = Opened( )
        
        ;
        *root\color       = _get_colors_( )
        SetFontID( *root, PB( GetGadgetFont )( #PB_Default ))
        
        ;
        *root\canvas\GadgetID = g
        *root\canvas\window   = Window
        *root\canvas\gadget   = Canvas
        
        ;\\
        Post( *root, #__event_create )
        
        ;\\
        If width Or height
          Resize( *root, #PB_Ignore, #PB_Ignore, width, height )
        EndIf
        
        ;\\
        If Not BinaryFlag( Flag, #PB_Window_NoGadgets ) 
          If Opened( )
            Opened( )\Afterroot( ) = *root
          EndIf
          *root\Beforeroot( ) = Opened( )
          
          Opened( ) = *root
          ; OpenList( *root)
        EndIf
        
        
      EndIf
      
      If g
        SetWindowData( Window, Canvas )
        
        ;\\ Bug fixed in the windows mouse-(enter&leave)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Events::BindGadget( Canvas, @EventHandler( ))
        CompilerElse
          BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_MouseEnter )
          BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_MouseLeave )
        CompilerEndIf
        
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_Resize )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_MouseMove )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_LeftButtonDown )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_LeftButtonUp )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_RightButtonDown )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_RightButtonUp )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_MiddleButtonDown )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_MiddleButtonUp )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_Focus )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_LostFocus )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_Input )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_KeyDown )
        BindGadgetEvent( Canvas, @CanvasEvents( ), #PB_EventType_KeyUp )
        
        ; BindGadgetEvent( Canvas, @CanvasEvents( ))
        ; BindEvent( #PB_Event_Gadget, @CanvasEvents( ), Window, Canvas )
        BindEvent( #PB_Event_Repaint, @EventRepaint( ), Window )
        BindEvent( #PB_Event_ActivateWindow, @EventActivate( ), Window )
        BindEvent( #PB_Event_DeactivateWindow, @EventDeactivate( ), Window )
        If BinaryFlag( canvasflag, #PB_Canvas_Container )
          BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window )
        EndIf
        
        ;\\ z - order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          ;SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPCHILDREN )
          SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( g, #GW_HWNDFIRST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE )
          
          ; RedrawWindow_(WindowID(a), 0, 0, #RDW_ERASE | #RDW_FRAME | #RDW_INVALIDATE | #RDW_ALLCHILDREN)
          
          RemoveKeyboardShortcut( Window, #PB_Shortcut_Tab )
        CompilerEndIf
        
        ;\\
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ; CocoaMessage(0, g, "setBoxType:", #NSBoxCustom)
          ; CocoaMessage(0, g, "setBorderType:", #NSLineBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSGrooveBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSBezelBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSNoBorder)
          
          ;;;CocoaMessage(0, w, "makeFirstResponder:", g)
          
          ; CocoaMessage(0, GadgetID(0), "setFillColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          ; CocoaMessage(0, WindowID(w), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          ; CocoaMessage(0, g,"setFocusRingType:",1)
        CompilerEndIf
      EndIf
      
      widget( ) = *root
      PostEventRepaint( *root )
      ProcedureReturn *root
    EndProcedure
    
    Procedure.i Free( *this._s_WIDGET )
      If *this
        If Not Send( *this, #__event_free )
          ; еще не проверял
          ;                If  *this\haseventhook
          ;                   Define i
          ;                   For i = 0 To #__event_free
          ;                      If *this\eventhook[i]
          ;                         ; Debug "free-events " + *this\eventhook[i]
          ;                         Unbind( *this, *this\eventhook[i]\function, i, *this\eventhook[i]\item )
          ;                      EndIf
          ;                   Next
          ;                EndIf
          
          ;\\
          If Not *this\parent
            *this\parent = *this
          EndIf
          
          If PopupWindow( ) = *this
            PopupWindow( ) = #Null
          EndIf
          
          ;\\
          If Opened( ) = *this
            OpenList( *this\parent )
          EndIf
          
          If GetActive( ) = *this
            If *this <> *this\parent
              GetActive( ) = *this\parent
            Else
              GetActive( ) = #Null
            EndIf
          EndIf
          
          If *this\parent\FirstWidget( ) = *this
            *this\parent\FirstWidget( ) = *this\AfterWidget( )
          EndIf
          
          If *this\parent\LastWidget( ) = *this
            *this\parent\LastWidget( ) = *this\BeforeWidget( )
          EndIf
          
          If *this\parent\TabBox( )
            If *this\parent\TabBox( ) = *this
              FreeStructure( *this\parent\TabBox( ) )
              *this\parent\TabBox( ) = 0
            EndIf
            *this\parent\TabBox( ) = #Null
          EndIf
          
          If *this\parent\scroll
            If *this\parent\scroll\v = *this
              FreeStructure( *this\parent\scroll\v )
              *this\parent\scroll\v = 0
            EndIf
            If *this\parent\scroll\h = *this
              FreeStructure( *this\parent\scroll\h )
              *this\parent\scroll\h = 0
            EndIf
            ; *this\parent\scroll = #Null
          EndIf
          
          If *this\parent\type = #__type_Splitter
            If *this\parent\split_1( ) = *this
              FreeStructure( *this\parent\split_1( ) )
              *this\parent\split_1( ) = 0
            EndIf
            If *this\parent\split_2( ) = *this
              FreeStructure( *this\parent\split_2( ) )
              *this\parent\split_2( ) = 0
            EndIf
          EndIf
          
          ;
          If *this\parent\haschildren
            ; With *this\root
            LastElement(widgets( ))
            Repeat
              If widgets( ) = *this Or IsChild( widgets( ), *this )
                If widgets( )\root\haschildren > 0
                  widgets( )\root\haschildren - 1
                  
                  If widgets( )\parent <> widgets( )\root
                    widgets( )\parent\haschildren - 1
                  EndIf
                  
                  If widgets( )\TabBox( )
                    If widgets( )\TabBox( ) = widgets( )
                      Debug "   free - tab " + widgets( )\TabBox( )\class
                      FreeStructure( widgets( )\TabBox( ) )
                      widgets( )\TabBox( ) = 0
                    EndIf
                    widgets( )\TabBox( ) = #Null
                  EndIf
                  
                  If widgets( )\scroll
                    If widgets( )\scroll\v
                      Debug "   free - scroll-v " + widgets( )\scroll\v\class
                      FreeStructure( widgets( )\scroll\v )
                      widgets( )\scroll\v = 0
                    EndIf
                    If widgets( )\scroll\h
                      Debug "   free scroll-h - " + widgets( )\scroll\h\class
                      FreeStructure( widgets( )\scroll\h )
                      widgets( )\scroll\h = 0
                    EndIf
                    ; widgets( )\scroll = #Null
                  EndIf
                  
                  If widgets( )\type = #__type_Splitter
                    If widgets( )\split_1( )
                      Debug "   free - splitter - first " + widgets( )\split_1( )\class
                      FreeStructure( widgets( )\split_1( ) )
                      widgets( )\split_1( ) = 0
                    EndIf
                    If widgets( )\split_2( )
                      Debug "   free - splitter - second " + widgets( )\split_2( )\class
                      FreeStructure( widgets( )\split_2( ) )
                      widgets( )\split_2( ) = 0
                    EndIf
                  EndIf
                  
                  If widgets( )\bounds\attach
                    ;Debug " free - attach " +widgets( )\bounds\attach\parent\class
                    widgets( )\bounds\attach\parent = 0
                    FreeStructure( widgets( )\bounds\attach )
                    widgets( )\bounds\attach = #Null
                  EndIf
                  
                  If PressedWidget( ) = widgets( )
                    PressedWidget( ) = #Null
                  EndIf
                  If GetActive( ) = widgets( )
                    GetActive( ) = #Null
                  EndIf
                  
                  Debug " free - " + widgets( )\class
                  If widgets( )\BeforeWidget( )
                    widgets( )\BeforeWidget( )\AfterWidget( ) = widgets( )\AfterWidget( )
                  EndIf
                  If widgets( )\AfterWidget( )
                    widgets( )\AfterWidget( )\BeforeWidget( ) = widgets( )\BeforeWidget( )
                  EndIf
                  
                  widgets( )\parent  = #Null
                  widgets( )\address = #Null
                  
                  DeleteElement( widgets( ), 1 )
                EndIf
                
                If *this\root\haschildren = 0
                  Break
                EndIf
              ElseIf PreviousElement( widgets( )) = 0
                Break
              EndIf
            ForEver
            ; EndWith
          EndIf
          
          ;\\
          If PressedWidget( ) = *this
            PressedWidget( ) = #Null
          EndIf
          
          ;\\
          If roots( ) = *this
            roots( )\address = #Null
            DeleteMapElement( roots( ) )
            ; DeleteMapElement( roots( ), MapKey( roots( ) ) )
            ; ResetMap( roots( ) )
            Debug " FREE - " + *this\class + " " + *this\address
            
            If Not MapSize( roots( ) )
              __gui\eventquit = 1
            EndIf
          EndIf
          
          ProcedureReturn 1
        EndIf
      EndIf
    EndProcedure
    
    Procedure Repost( ) ; root = #PB_All )
      Static *repaint._s_root
      Protected *root._s_root, __widget, __type, __item, __data
      
      ;\\
      If __gui\eventexit <> 1
        __gui\eventexit = 1
        
        ;\\ send posted events (queue events) 
        If ListSize( __gui\eventqueue( ) )
          ForEach __gui\eventqueue( )
            *root    = __gui\eventqueue( )\widget\root
            __widget = __gui\eventqueue( )\widget
            __type   = __gui\eventqueue( )\type
            __item   = __gui\eventqueue( )\item
            __data   = __gui\eventqueue( )\data
            DeleteElement( __gui\eventqueue( ) )
            
            ;\\
            If *root <> root( )
              If *repaint
                If ChangeCurrentCanvas( *repaint\canvas\gadgetID )
                  *repaint\canvas\post = 0
                  PostEventRepaint( *repaint )
                EndIf
              EndIf
              If ChangeCurrentCanvas( *root\canvas\gadgetID )
                *repaint = root( )
                ; Debug "    change canvas "
              EndIf
            EndIf
            
            ;\\
            If #__event_Repaint = __type
              Debug "#__event_Repaint"
              
            ElseIf #__event_Close = __type
              Debug "Post close...."
              Send( __widget, __type, __item, __data )
              Break
              
            ElseIf #__event_Focus = __type Or
                   #__event_LostFocus = __type
              
              If Not Send( __widget, __type, __item, __data )
                DoEvents( __widget, __type )
              EndIf
              
            Else
              Send( __widget, __type, __item, __data )
            EndIf
            ;EndIf
          Next
        EndIf
        
        ;\\
        If *repaint
          *repaint\canvas\post = 0
          PostEventRepaint( *repaint )
          *repaint = 0
        EndIf
        
        ;\\ call message
        If EnteredWidget( ) And
           EnteredWidget( )\root <> root( )
          ; Debug " Change Current Canvas "
          ChangeCurrentCanvas( EnteredWidget( )\root\canvas\gadgetID )
        EndIf
        
        Debug "     -     "
      EndIf
    EndProcedure
    
    
  EndModule
  ;- <<<
CompilerEndIf


;-
Macro UseWidgets( )
  UseModule widget
  UseModule constants
  UseModule structures
EndMacro

CompilerIf #PB_Compiler_IsMainFile ;= 100
  Macro GetIndex( this )
    MacroExpandedCount
  EndMacro
  UseWidgets( )
  EnableExplicit
  #__flag_TextBorder = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  
  Procedure events_widgets()
    Select WidgetEvent( )
      Case #__event_Change
        Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetState(EventWidget( )) +" "+ WidgetHeight( WidgetID(0) ) +" "+ WidgetHeight( WidgetID(1) )
    EndSelect
  EndProcedure


  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::Open(0, 100,100,800,600, "ide", flag)
  window_ide = widget::GetCanvasWindow(root())
  canvas_ide = widget::GetCanvasGadget(root())
  
  s_tbar = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  s_desi = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  s_view = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  s_list = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  s_insp = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  s_help  = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = widget::Splitter(0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = widget::Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = widget::Splitter(0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = widget::Splitter(0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = widget::Splitter(0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
;         ; set splitter default minimum size
;     widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
;     widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
;     widget::SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
;     widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
;     widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
;     widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
;     widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    
;   ; set splitter default minimum size
    widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
   ; widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    widget::SetState(Splitter_ide, widget::WidgetWidth(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::WidgetHeight(splitter_help)-80)
    widget::SetState(splitter_debug, widget::WidgetHeight(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetGadgetText(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(GetIndex( widget::GetParent( s_tbar ))))
  SetGadgetText(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(GetIndex( widget::GetParent( s_desi ))))
  SetGadgetText(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(GetIndex( widget::GetParent( s_view ))))
  SetGadgetText(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(GetIndex( widget::GetParent( s_list ))))
  SetGadgetText(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(GetIndex( widget::GetParent( s_insp ))))
  SetGadgetText(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(GetIndex( widget::GetParent( s_help ))))
  
  Bind(#PB_All, @events_widgets(), #__event_Change)
    
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 9512
; FirstLine = 9502
; Folding = ---------------------------------------------------------------
; EnableXP
; DPIAware