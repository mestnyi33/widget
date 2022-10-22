; ver: 3.0.0.0 ; 
; sudo adduser your_username vboxsf
; https://linuxrussia.com/sh-ubuntu.html
; http://forums.purebasic.com/english/viewtopic.php?p=577957

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  #path = "/media/sf_as/Documents/GitHub/widget"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  #path = "Z:/Documents/GitHub/widget"
  ;#path "C:\Users\as\Desktop\Widget_15_08_2020"
CompilerEndIf

; IncludePath #path
; 
; 
; XIncludeFile "include/modules.pbi"
; 
; CompilerIf Not Defined( constants, #PB_Module )
;   XIncludeFile "include/constants.pbi"
; CompilerEndIf
; 
; CompilerIf Not Defined( structures, #PB_Module )
;   XIncludeFile "include/structures.pbi"
; CompilerEndIf
; 
; CompilerIf Not Defined( func, #PB_Module )
;   XIncludeFile "include/func.pbi"
; CompilerEndIf
; 
; CompilerIf Not Defined( colors, #PB_Module )
;   XIncludeFile "include/colors.pbi"
; CompilerEndIf
; 
; ; fix all (PB) bug's
; CompilerIf Not Defined( fix, #PB_Module )
;   XIncludeFile "include/fix.pbi"
; CompilerEndIf
; 
; XIncludeFile "include/events.pbi"

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

CompilerIf Not Defined( fix, #PB_Module )
  ; fix all pb bug's
  XIncludeFile "include/fix.pbi"
CompilerEndIf
;XIncludeFile "include/os/mac/cursor.pbi"

CompilerIf Not Defined( Widget, #PB_Module )
  ;-  >>>
  DeclareModule Widget
    EnableExplicit
    UseModule constants
    UseModule structures
    
    CompilerIf Defined( fix, #PB_Module )
      UseModule fix
    CompilerElse
      Macro PB(Function)
        Function
      EndMacro
      
      Macro PB_(Function)
        Function
      EndMacro
    CompilerEndIf
    
    UseModule events
    
    ;-  ----------------
    ;-   DECLARE_macros
    ;-  ----------------
    Macro Debugger( _text_="" )
      CompilerIf #PB_Compiler_Debugger  ; Only enable assert in debug mode
        Debug  " " +_macro_call_count_ +_text_+ "   ( debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ))"
        _macro_call_count_ + 1
      CompilerEndIf
    EndMacro
    
    ;- demo text
    Macro debug_position( _root_, _text_="" )
      Debug " " +_text_+ " - "
      ForEach _root_\_widgets( ) 
        If _root_\_widgets( ) <> _root_\_widgets( )\_root( )
          If _root_\_widgets( )\before\widget And _root_\_widgets( )\after\widget
            Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +" "+ _root_\_widgets( )\class +" "+ _root_\_widgets( )\after\widget\class
          ElseIf _root_\_widgets( )\after\widget
            Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class +" "+ _root_\_widgets( )\after\widget\class
          ElseIf _root_\_widgets( )\before\widget
            Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +" "+ _root_\_widgets( )\class +" none"
          Else
            Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class + " none " 
          EndIf
          
          ;           If _root_\_widgets( )\before\widget And _root_\_widgets( )\after\widget
          ;             Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +"-"+ _root_\_widgets( )\before\widget\position +" "+ _root_\_widgets( )\class +"-"+ _root_\_widgets( )\position +" "+ _root_\_widgets( )\after\widget\class +"-"+ _root_\_widgets( )\after\widget\position
          ;           ElseIf _root_\_widgets( )\after\widget
          ;             Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class +"-"+ _root_\_widgets( )\position +" "+ _root_\_widgets( )\after\widget\class +"-"+ _root_\_widgets( )\after\widget\position
          ;           ElseIf _root_\_widgets( )\before\widget
          ;             Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +"-"+ _root_\_widgets( )\before\widget\position +" "+ _root_\_widgets( )\class +"-"+ _root_\_widgets( )\position +" none"
          ;           Else
          ;             Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class +"-"+ _root_\_widgets( )\position + " none " 
          ;           EndIf
          ;           
          ;           ;         If _root_\_widgets( )\before\widget And _root_\_widgets( )\after\widget
          ;           ;           Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +" "+ _root_\_widgets( )\class +" "+ _root_\_widgets( )\after\widget\class
          ;           ;         ElseIf _root_\_widgets( )\after\widget
          ;           ;           Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class +" "+ _root_\_widgets( )\after\widget\class
          ;           ;         ElseIf _root_\_widgets( )\before\widget
          ;           ;           Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" "+ _root_\_widgets( )\before\widget\class +" "+ _root_\_widgets( )\class +" none"
          ;           ;         Else
          ;           ;           Debug " - "+ Str(ListIndex( _root_\_widgets( ))) +" "+ _root_\_widgets( )\index +" none "+ _root_\_widgets( )\class + " none " 
          ;           ;         EndIf
        EndIf
      Next
      Debug ""
    EndMacro
    
    
    ;- Replacement >> PB( )
    Macro CreateCursor( _imageID_, _x_, _y_ )
      func::CreateCursor( _imageID_, _x_, _y_ )
    EndMacro
    
    ;-  Drag & Drop
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
    
    Macro DragItem( Row, Actions = #PB_Drag_Copy ): DD_DragItem( Row, Actions ): EndMacro
    Macro DragText( Text, Actions = #PB_Drag_Copy ): DD_DragText( Text, Actions ): EndMacro
    Macro DragImage( Image, Actions = #PB_Drag_Copy ): DD_DragImage( Image, Actions ): EndMacro
    Macro DragFiles( Files, Actions = #PB_Drag_Copy ): DD_DragFiles( Files, Actions ): EndMacro
    Macro DragPrivate( PrivateType, Actions = #PB_Drag_Copy ): DD_DragPrivate( PrivateType, Actions ): EndMacro
    
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
    
    Declare.i DD_DragText( Text.S, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragImage( Image.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragPrivate( Type.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragFiles( Files.s, Actions.i = #PB_Drag_Copy )
    
    Declare.i DD_DropEnable( *this, Format.i, Actions.i, PrivateType.i = 0 )
    
    ;-
    Macro allocate( _struct_name_, _struct_type_= )
      _S_#_struct_name_#_struct_type_ = AllocateStructure( _S_#_struct_name_ )
    EndMacro
    Macro _root( ): parent\root: EndMacro
    Macro _window( ): parent\window: EndMacro
    Macro _parent( ): parent\widget: EndMacro ; Returns last created widget 
    Macro _widgets( ): _root( )\canvas\child( ): EndMacro ; Returns last created widget 
    Macro _events( ): _root( )\canvas\events( ): EndMacro
    Macro _rows( ): row\_s( ): EndMacro
    Macro _tabs( ): bar\_s( ): EndMacro
    
    Macro enumWidget( ): Root( )\_widgets( ): EndMacro       ; temp 
    
    Macro PB( _pb_function_name_ ) : _pb_function_name_: EndMacro
    Macro Root( ) : widget::*canvas\roots( ): EndMacro
    Macro mouse( ) : widget::*canvas\mouse: EndMacro
    Macro Keyboard( ) : widget::*canvas\keyboard: EndMacro
    Macro Drawing( ): widget::*canvas\drawing : EndMacro
    Macro widget( ): Root( )\_widgets( ): EndMacro ; Returns last created widget 
    
    ;-
    
    Macro TabWidget( ): tab\widget: EndMacro           ; parent\ 
    Macro TabIndex( ): tab\index: EndMacro             ; parent\
                                                       ;     Macro EnteredTab( ): bar\entered: EndMacro ; Returns mouse entered tab
                                                       ;     Macro PressedTab( ): bar\pressed: EndMacro; Returns mouse focused tab
                                                       ;     Macro FocusedTab( ): bar\active: EndMacro ; Returns mouse focused tab
    Macro EnteredTab( ): tab\entered: EndMacro         ; Returns mouse entered tab
    Macro PressedTab( ): tab\pressed: EndMacro         ; Returns mouse focused tab
    Macro FocusedTab( ): tab\active: EndMacro          ; Returns mouse focused tab
    Macro OpenedTabIndex( ): index[#__tab_1]: EndMacro ; parent\
    Macro SelectedTabIndex( ): index[#__tab_2]: EndMacro ; 
    Macro ChangeTabIndex( ): tab\change: EndMacro        ; bar\change_tab_items
    
    Macro EnteredRow( ): row\entered: EndMacro; Returns mouse entered widget
    Macro LeavedRow( ): row\leaved: EndMacro  ; Returns mouse entered widget
    Macro PressedRow( ): row\pressed: EndMacro; Returns key focus item address
    Macro FocusedRow( ): row\active: EndMacro ; Returns key focus item address
    Macro VisibleFirstRow( ): row\visible\first: EndMacro
    Macro VisibleLastRow( ): row\visible\last: EndMacro
    Macro VisibleRows( ): row\visible\_s( ): EndMacro
    
    Macro EnteredRowindex( _this_ ): _this_\index[#__S_1]: EndMacro ; Returns mouse entered row
    Macro PressedRowindex( _this_ ): _this_\index[#__S_2]: EndMacro ; Returns mouse pressed row
    
    Macro BB1( ) : *this\bar\button[#__b_1]: EndMacro
    Macro BB2( ) : *this\bar\button[#__b_2]: EndMacro
    Macro BB3( ) : *this\bar\button[#__b_3]: EndMacro
    
    Macro EnteredButton( ) : mouse( )\entered\button: EndMacro
    Macro PressedButton( ) : Keyboard( )\focused\button: EndMacro
    Macro FocusedButton( ) : Keyboard( )\focused\button: EndMacro
    
    
    Macro EnteredItem( ) : EnteredWidget( )\EnteredRow( ) : EndMacro
    Macro EnteredWidget( ) : mouse( )\entered\widget: EndMacro ; Returns mouse entered widget
    Macro LeavedWidget( ) : mouse( )\leaved\widget: EndMacro   ; Returns mouse leaved widget
    Macro PressedWidget( ) : mouse( )\pressed\widget: EndMacro
    Macro FocusedWidget( ) : Keyboard( )\focused\widget: EndMacro ; Returns keyboard focus widget
    
    Macro ClosedWidget( ) : last\root : EndMacro
    Macro OpenedWidget( ) : widget::*canvas\opened: EndMacro
    Macro StickyWindow( ) : widget::*canvas\sticky\window: EndMacro
    Macro Popu_parent( ) : widget::*canvas\sticky\widget: EndMacro
    
    Macro EventWidget( ) : widget::*canvas\widget: EndMacro
    Macro EventIndex( ) : EventWidget( )\index: EndMacro
    
    Macro WidgetEvent( ) : widget::*canvas\event: EndMacro
    Macro WidgetEventType( ) : WidgetEvent( )\type: EndMacro
    Macro WidgetEventItem( ) : WidgetEvent( )\item: EndMacro
    Macro WidgetEventData( ) : WidgetEvent( )\data: EndMacro
    
    ;-
    Macro WindowEvent(  )
      events::WaitEvent( PB(WindowEvent)( ) ) ; @EventHandler( ), 
    EndMacro
    Macro WaitWindowEvent( waittime = )
      events::WaitEvent( PB(WaitWindowEvent)( waittime ) ) ; @EventHandler( ), 
    EndMacro
    
    
    
    ;-
    Macro  ChangeCurrentRoot(_canvas_gadget_address_ )
      FindMapElement( Root( ), Str( _canvas_gadget_address_ ) )
    EndMacro
    
    Macro PostCanvasRepaint( _address_, _data_ = #Null ) 
      ; Debug "-- post --- event -- repaint --1"
      If _address_\_root( )\canvas\repaint = #False
        _address_\_root( )\canvas\repaint = #True
        ; Debug "-- post --- event -- repaint --2"
        If _data_ = #Null
          PostEvent( #PB_Event_Gadget, _address_\_root( )\canvas\window, _address_\_root( )\canvas\gadget, #PB_EventType_Repaint, _address_\_root( ) )
        Else
          PostEvent( #PB_Event_Gadget, _address_\_root( )\canvas\window, _address_\_root( )\canvas\gadget, #PB_EventType_Repaint, _data_ )
        EndIf
      EndIf
    EndMacro
    
    
    ;-
    Macro GetActive( ): Keyboard( )\window: EndMacro   ; Returns activeed window
    Macro GetMouseX( _mode_ = #__c_screen ): mouse( )\x[_mode_]: EndMacro ; Returns mouse x
    Macro GetMouseY( _mode_ = #__c_screen ): mouse( )\y[_mode_]: EndMacro ; Returns mouse y
    
    ;-
    Macro scroll_x_( _this_ ): _this_\x[#__c_required]: EndMacro
    Macro scroll_y_( _this_ ):  _this_\y[#__c_required]: EndMacro
    Macro scroll_width_( _this_ ): _this_\width[#__c_required]: EndMacro
    Macro scroll_height_( _this_ ): _this_\height[#__c_required]: EndMacro
    
    ;-
    Macro StartEnumerate( _parent_ )
      Bool( _parent_\count\childrens )
      
      ;       PushMapPosition( Root( ) )
      ;       ChangeCurrentRoot(_parent_\_root( )\canvas\address )
      PushListPosition( enumWidget( ) )
      
      If _parent_\address
        ChangeCurrentElement( enumWidget( ), _parent_\address )
      Else
        ResetList( enumWidget( ))
      EndIf
      
      While NextElement( enumWidget( ))
        If IsChild( enumWidget( ), _parent_ ) ; Not ( _parent_\after\widget And _parent_\after\widget = enumWidget( )) ; 
        EndMacro
        
        Macro AbortEnumerate( )
          Break
        EndMacro
        
        Macro StopEnumerate( ) 
        Else
          Break
        EndIf
      Wend
      PopListPosition( enumWidget( ))
      ;       PushMapPosition( Root( ) )
    EndMacro
    
    
    ;-
    Macro _get_colors_( ) : colors::*this\blue : EndMacro
    
    ;- 
    Macro is_root_(_this_ ) : Bool( _this_ > 0 And _this_ = _this_\_root( ) ): EndMacro
    Macro is_item_( _this_, _item_ ) : Bool( _item_ >= 0 And _item_ < _this_\count\items ) : EndMacro
    Macro is_widget_( _this_ ) : Bool( _this_ > 0 And _this_\address ) : EndMacro
    Macro is_window_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type = constants::#__type_window ) : EndMacro
    
    Macro is_parent_( _this_, _parent_ )
      Bool( _parent_ = _this_\_parent( ) And ( _parent_\TabWidget( ) And _this_\TabIndex( ) = _parent_\TabWidget( )\SelectedTabIndex( ) ))
    EndMacro
    Macro is_parent_one_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\_parent( ) = _address_2\_parent( ) And _address_1\TabIndex( ) = _address_2\TabIndex( ) )
    EndMacro
    
    Macro is_root_container_( _this_ )
      Bool( _this_\_root( ) And _this_ = _this_\_root( )\canvas\container )
    EndMacro
    
    Macro bar_first_gadget_( _this_ ): _this_\gadget[#__split_1]: EndMacro
    Macro bar_second_gadget_( _this_ ): _this_\gadget[#__split_2]: EndMacro
    Macro bar_is_first_gadget_( _this_ ): _this_\index[#__split_1]: EndMacro
    Macro bar_is_second_gadget_( _this_ ): _this_\index[#__split_2]: EndMacro
    
    Macro is_scrollbars_( _this_ ) 
      Bool( _this_\_parent( ) And _this_\_parent( )\scroll And ( _this_\_parent( )\scroll\v = _this_ Or _this_\_parent( )\scroll\h = _this_ )) 
    EndMacro
    
    Macro is_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child = 1 )
    EndMacro
    
    Macro is_at_circle_( _position_x_, _position_y_, _mouse_x_, _mouse_y_, _circle_radius_ )
      Bool( Sqr( Pow((( _position_x_ + _circle_radius_ ) - _mouse_x_ ), 2 ) + Pow((( _position_y_ + _circle_radius_ ) - _mouse_y_ ), 2 )) <= _circle_radius_ )
    EndMacro
    
    Macro is_at_plane_( _position_, _size_, _mouse_ )
      Bool( _mouse_ > _position_ And _mouse_ <= ( _position_ + _size_ ) And ( _position_ + _size_ ) > 0 )
    EndMacro
    
    Macro is_at_box_( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
      Bool( is_at_plane_( _position_x_, _size_width_, _mouse_x_ ) And 
            is_at_plane_( _position_y_, _size_height_, _mouse_y_ ) )
    EndMacro
    
    Macro is_at_point_y_( _address_, _mouse_y_, _mode_ = )
      is_at_plane_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ )
    EndMacro
    
    Macro is_at_point_x_( _address_, _mouse_x_, _mode_ = )
      is_at_plane_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ )
    EndMacro
    
    Macro is_at_point_( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( is_at_point_x_( _address_, _mouse_x_, _mode_ ) And is_at_point_y_( _address_, _mouse_y_, _mode_ ))
    EndMacro
    
    Macro is_inter_rect_( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
                          _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
      
      Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And 
           ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ))
    EndMacro
    
    Macro is_inter_sect_( _address_1_, _address_2_, _address_1_mode_ = )
      Bool(( _address_1_\x#_address_1_mode_ + _address_1_\width#_address_1_mode_ ) > _address_2_\x And _address_1_\x#_address_1_mode_ < ( _address_2_\x + _address_2_\width ) And 
           ( _address_1_\y#_address_1_mode_ + _address_1_\height#_address_1_mode_ ) > _address_2_\y And _address_1_\y#_address_1_mode_ < ( _address_2_\y + _address_2_\height ))
    EndMacro
    
    Macro is_text_gadget_( _this_ )
      Bool( _this_\type = #__Type_Editor Or
            _this_\type = #__Type_HyperLink Or
            _this_\type = #__Type_IPAddress Or
            _this_\type = #__Type_CheckBox Or
            _this_\type = #__Type_Option Or
            _this_\type = #__Type_Button Or
            _this_\type = #__Type_String Or
            _this_\type = #__Type_Text )
    EndMacro
    
    Macro is_list_gadget_( _this_ )
      Bool( _this_\type = #__Type_Tree Or
            _this_\type = #__Type_ListView Or
            _this_\type = #__Type_ListIcon Or
            _this_\type = #__Type_ExplorerTree Or
            _this_\type = #__Type_ExplorerList )
    EndMacro
    
    Macro  is_interact_row_( _this_ )
      Bool( _this_\type = #__Type_TabBar Or
            _this_\type = #__Type_Splitter Or
            _this_\type = #__Type_Editor Or
            _this_\type = #__Type_IPAddress Or
            _this_\type = #__Type_String Or
            _this_\type = #__Type_Button Or
            _this_\type = #__Type_Tree Or
            _this_\type = #__Type_ListView Or
            _this_\type = #__Type_ListIcon Or
            _this_\type = #__Type_ExplorerTree Or
            _this_\type = #__Type_ExplorerList )
    EndMacro
    
    Macro is_no_select_item_( _list_, _item_ )
      Bool( _item_ < 0 Or _item_ >= ListSize( _list_ ) Or (ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) )) 
      ; Bool( _item_ >= 0 And ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ )) 
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
    
    Macro _check_expression_( _result_, _address_, _key_ )
      Bool( ListSize( _address_ ))
      _result_ = #False
      ForEach _address_
        If _address_#_key_ 
          _result_ = #True
          Break
        EndIf
      Next
    EndMacro
    
    Macro text_rotate_( _address_ )
      _address_\rotate = Bool( Not _address_\invert ) * ( Bool( _address_\vertical ) * 90 ) + Bool( _address_\invert ) * ( Bool( _address_\vertical ) * 270 + Bool( Not _address_\vertical ) * 180 )
    EndMacro
    
    Macro get_image_width( _image_id_ )
      func::GetImageWidth( _image_id_ )
    EndMacro
    
    Macro get_image_height( _image_id_ )
      func::GetImageHeight( _image_id_ )
    EndMacro
    
    Macro resize_image( _image_id_, _width_, _height_ )
      func::SetImageWidth( _image_id_, _width_ )
      func::SetImageHeight( _image_id_, _height_ )
    EndMacro
    
    ;-
    Macro CanvasMouseX( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      DesktopMouseX( ) - GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
    EndMacro
    
    Macro CanvasMouseY( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      DesktopMouseY( ) - GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
    EndMacro
    
    
    ;-
    Macro a_transform( ) 
      mouse( )\_transform
    EndMacro
    Macro a_focus_widget( ) 
      a_transform( )\_a_widget
    EndMacro
    Macro a_enter_widget( )
      a_transform( )\widget
    EndMacro
    Macro a_enter_index( _this_ ) 
      _this_\_a_\index
    EndMacro
    
    
    
    ;-
    Macro MidF(_string_, _start_pos_, _length_=-1)
      func::MidFast(_string_, _start_pos_, _length_)
    EndMacro 
    
    Macro ICase( String ) ; sTRinG = StrINg
      func::IinvertCase( String )
    EndMacro
    
    Macro ULCase( String ) ; sTRinG = String
      InsertString( UCase( Left( String, 1 )), LCase( Right( String, Len( String ) - 1 )), 2 )
    EndMacro
    
    
    ;-
    Macro draw_box_( _x_,_y_,_width_,_height_, _color_=$ffffffff )
      Box( _x_,_y_,_width_,_height_, _color_ )
    EndMacro
    
    Macro draw_roundbox_( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_=$ffffffff )
      If _round_x_ Or _round_y_
        RoundBox( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_ ) ; bug _round_y_ = 0 
      Else
        draw_box_( _x_,_y_,_width_,_height_, _color_ )
      EndIf
    EndMacro
    
    ;     Macro draw_mode_( _this_, _mode_ )
    ;       If _this_\color\alpha And _this_\color\alpha\frame
    ;         drawing_mode_alpha_( _mode_ )
    ;       Else
    ;         drawing_mode_( _mode_ )
    ;       EndIf
    ;     EndMacro
    
    Macro drawing_mode_( _mode_ )
      ;       If enumWidget( )\_drawing <> _mode_
      ;         enumWidget( )\_drawing = _mode_
      ;Debug _mode_
      DrawingMode( _mode_ )
      ;       EndIf
    EndMacro
    
    Macro drawing_mode_alpha_( _mode_ )
      ;       If enumWidget( )\_draw_alpha <> _mode_
      ;         enumWidget( )\_draw_alpha = _mode_
      
      drawing_mode_( _mode_ | #PB_2DDrawing_AlphaBlend )
      ;       EndIf
    EndMacro
    
    Macro draw_font_( _draw_address_ )
      ; drawing font
      If _draw_address_\text\fontID = #Null
        _draw_address_\text\fontID = _draw_address_\_root( )\text\fontID 
        _draw_address_\text\change = #True
      EndIf
      
      If _draw_address_\_root( )\canvas\fontID <> _draw_address_\text\fontID
        _draw_address_\_root( )\canvas\fontID = _draw_address_\text\fontID
        
        ;; Debug "draw current font - " + #PB_Compiler_Procedure  + " " +  _draw_address_ + " fontID - "+ _draw_address_\text\fontID
        DrawingFont( _draw_address_\text\fontID ) 
        _draw_address_\text\change = #True
      EndIf
      
      If _draw_address_\text\change
        If _draw_address_\text\string 
          _draw_address_\text\width = TextWidth( _draw_address_\text\string ) 
        EndIf
        
        _draw_address_\text\height = TextHeight( "A" ); - Bool( #PB_Compiler_OS <> #PB_OS_Windows ) * 2
        _draw_address_\text\rotate = Bool( _draw_address_\text\invert ) * 180 + Bool( _draw_address_\text\vertical ) * 90
      EndIf
    EndMacro
    
    Macro draw_font_item_( _this_, _item_, _change_ )
      If _item_\text\fontID = #Null
        If _this_\text\fontID = #Null
          If is_integral_( _this_ )
            _this_\text\fontID = _this_\_parent( )\text\fontID 
            _this_\text\height = _this_\_parent( )\text\height 
          Else
            _this_\text\fontID = _this_\_root( )\text\fontID 
            _this_\text\height = _this_\_root( )\text\height 
          EndIf
        EndIf
        
        _item_\text\fontID = _this_\text\fontID
        _item_\text\height = _this_\text\height
        _item_\text\change = #True
      EndIf
      ;Debug ""+_this_\_root( )\canvas\fontID +" "+ _item_\text\fontID
      ; drawing item font
      If _this_\_root( )\canvas\fontID <> _item_\text\fontID
        ;;Debug " item fontID - "+ _item_\text\fontID
        _this_\_root( )\canvas\fontID = _item_\text\fontID
        
        Debug "draw current item font - " + #PB_Compiler_Procedure  + " " +  _this_  + " " +  _item_\index + " fontID - "+ _item_\text\fontID
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
    
    ;-
    Macro draw_up_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Line(_x_+7, _y_, 2, 1, _frame_color_)                                                                                                                  ; 0,0,0,0,0,0,0,0,0,0
      Plot(_x_+6, _y_+1, _frame_color_ ) : Line(_x_+7, _y_+1, 2, 1, _back_color_) : Plot(_x_+9, _y_+1, _frame_color_ )                                       ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_+5, _y_+2, _frame_color_ ) : Line(_x_+6, _y_+2, 4, 1, _back_color_) : Plot(_x_+10, _y_+2, _frame_color_ )                                      ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_+4, _y_+3, _frame_color_ ) : Line(_x_+5, _y_+3, 6, 1, _back_color_) : Plot(_x_+11, _y_+3, _frame_color_ )                                      ; 0,0,1,1,1,1,1,1,0,0
      Line(_x_+3, _y_+4, _size_/3-1, 1, _frame_color_) : Line(_x_+7, _y_+4, 2, 1, _back_color_) : Line(_x_+_size_/2+1, _y_+4, _size_/3-1 , 1, _frame_color_) ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_+_size_/2-2, _y_+5, _frame_color_ ) : Line(_x_+7, _y_+5, 2, 1, _back_color_) : Plot(_x_+_size_/2+1, _y_+5, _frame_color_ )                     ; 0,0,0,0,1,1,0,0,0,0
                                                                                                                                                             ;                                                                                                                                                      ;
                                                                                                                                                             ;                                                                                                                                                      ;
    EndMacro
    Macro draw_down_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Plot(_x_+_size_/2-2, _y_+4, _frame_color_ ) : Line(_x_+7, _y_+4, 2, 1, _back_color_) : Plot(_x_+_size_/2+1, _y_+4, _frame_color_ )                     ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_+3, _y_+5, _size_/3-1, 1, _frame_color_) : Line(_x_+7, _y_+5, 2, 1, _back_color_) : Line(_x_+_size_/2+1, _y_+5, _size_/3-1, 1, _frame_color_)  ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_+4, _y_+6, _frame_color_ ) : Line(_x_+5, _y_+6, 6, 1, _back_color_) : Plot(_x_+11, _y_+6, _frame_color_ )                                      ; 0,0,1,1,1,1,1,1,0,0
      Plot(_x_+5, _y_+7, _frame_color_ ) : Line(_x_+6, _y_+7, 4, 1, _back_color_) : Plot(_x_+10, _y_+7, _frame_color_ )                                      ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_+6, _y_+8, _frame_color_ ) : Line(_x_+7, _y_+8, 2, 1, _back_color_) : Plot(_x_+9, _y_+8, _frame_color_ )                                       ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_+7, _y_+9, 2, 1, _frame_color_)                                                                                                                ; 0,0,0,0,0,0,0,0,0,0
                                                                                                                                                             ;                                                                                                                                                      ;
                                                                                                                                                             ;                                                                                                                                                      ;
    EndMacro
    Macro draw_left_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Line(_x_, _y_+7, 1, 2, _frame_color_)                                                                                                                  ; 0,0,1,0,0,0
      Plot(_x_+1, _y_+6, _frame_color_ ) : Line(_x_+1, _y_+7, 1, 2, _back_color_) : Plot(_x_+1, _y_+9, _frame_color_ )                                       ; 0,0,1,1,0,0
      Plot(_x_+2, _y_+5, _frame_color_ ) : Line(_x_+2, _y_+6, 1, 4, _back_color_) : Plot(_x_+2, _y_+10, _frame_color_ )                                      ; 1,1,1,1,1,0
      Plot(_x_+3, _y_+4, _frame_color_ ) : Line(_x_+3, _y_+5, 1, 6, _back_color_) : Plot(_x_+3, _y_+11, _frame_color_ )                                      ; 1,1,1,1,1,0
      Line(_x_+4, _y_+3, 1, _size_/3-1, _frame_color_) : Line(_x_+4, _y_+7, 1, 2, _back_color_) : Line(_x_+4, _y_+_size_/2+1, 1, _size_/3-1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_+5, _y_+_size_/2-2, _frame_color_ ) : Line(_x_+5, _y_+7, 1, 2, _back_color_) : Plot(_x_+5, _y_+_size_/2+1, _frame_color_ )                     ; 0,0,1,0,0,0
                                                                                                                                                             ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                             ;                                                                                                                                                      ; 0,0,0,0,0,0
    EndMacro  
    Macro draw_right_(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Plot(_x_+4, _y_+_size_/2-2, _frame_color_ ) : Line(_x_+4, _y_+7, 1, 2, _back_color_) : Plot(_x_+4, _y_+_size_/2+1, _frame_color_ )                     ; 0,0,0,1,0,0
      Line(_x_+5, _y_+3, 1, _size_/3-1, _frame_color_) : Line(_x_+5, _y_+7, 1, 2, _back_color_) : Line(_x_+5, _y_+_size_/2+1, 1, _size_/3-1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_+6, _y_+4, _frame_color_ ) : Line(_x_+6, _y_+5, 1, 6, _back_color_) : Plot(_x_+6, _y_+11, _frame_color_ )                                      ; 0,1,1,1,1,1
      Plot(_x_+7, _y_+5, _frame_color_ ) : Line(_x_+7, _y_+6, 1, 4, _back_color_) : Plot(_x_+7, _y_+10, _frame_color_ )                                      ; 0,1,1,1,1,1
      Plot(_x_+8, _y_+6, _frame_color_ ) : Line(_x_+8, _y_+7, 1, 2, _back_color_) : Plot(_x_+8, _y_+9, _frame_color_ )                                       ; 0,0,1,1,0,0
      Line(_x_+9, _y_+7, 1, 2, _frame_color_)                                                                                                                ; 0,0,0,1,0,0
                                                                                                                                                             ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                             ;                                                                                                                                                      ; 0,0,0,0,0,0
    EndMacro
    
    Macro draw_size_all_(_x_, _y_, _size_, _back_color_, _frame_color_)
    EndMacro
    
    Macro draw_plus_( _address_, _plus_, _size_ = 5 )
      Line(_address_\x+(_address_\width-_size_)/2, _address_\y+(_address_\height-1)/2, _size_, 1, _address_\color\front[_address_\color\state])
      If _plus_
        Line(_address_\x+(_address_\width-1)/2, _address_\y+(_address_\height-_size_)/2, 1, _size_, _address_\color\front[_address_\color\state])
      EndIf
    EndMacro
    
    Macro draw_arrows_( _address_, _type_ )
      Arrow( _address_\x + ( _address_\width - _address_\arrow\size )/2,
             _address_\y + ( _address_\height - _address_\arrow\size )/2, _address_\arrow\size, _type_, 
             _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24, _address_\arrow\type )
    EndMacro   
    
    Macro draw_gradient_( _vertical_, _address_, _color_fore_, _color_back_, _mode_= )
      BackColor( _color_fore_&$FFFFFF | _address_\color\_alpha<<24 )
      FrontColor( _color_back_&$FFFFFF | _address_\color\_alpha<<24 )
      
      If _vertical_  ; _address_\vertical
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, ( _address_\x#_mode_ + _address_\width#_mode_ ), _address_\y#_mode_ )
      Else
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, _address_\x#_mode_, ( _address_\y#_mode_ + _address_\height#_mode_ ))
      EndIf
      
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      
      BackColor( #PB_Default ) 
      FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_gradient_box_( _vertical_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_ = 0, _alpha_ = 255 )
      BackColor( _color_1_&$FFFFFF | _alpha_<<24 )
      FrontColor( _color_2_&$FFFFFF | _alpha_<<24 )
      
      If _vertical_
        LinearGradient( _x_,_y_, ( _x_ + _width_ ), _y_ )
      Else
        LinearGradient( _x_,_y_, _x_, ( _y_ + _height_ ))
      EndIf
      
      draw_roundbox_( _x_,_y_,_width_,_height_, _round_,_round_ )
      
      BackColor( #PB_Default ) : FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_box( _address_, _color_type_, _mode_= )
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, 
                      _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
    EndMacro
    
    Macro draw_box_button_( _address_, _color_type_ )
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        draw_roundbox_( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        draw_roundbox_( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro draw_close_button_( _address_, _size_ )
      ; close button
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x - 1 + _size_ + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + _size_ + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_maximize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 2 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x + 1 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 2 + ( _address_\width - _size_ )/2, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_minimize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width )/2 - _size_, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x + 0 + ( _address_\width )/2 - _size_, _address_\y + ( _address_\height - _size_ )/2, _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          
          Line( _address_\x - 1 + ( _address_\width )/2 + _size_, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
          Line( _address_\x - 2 + ( _address_\width )/2 + _size_, _address_\y + ( _address_\height - _size_ )/2,  - _size_, _size_, _address_\color\front[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_help_button_( _address_, _size_ )
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height, 
                        _address_\round, _address_\round, _address_\color\frame[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro draw_option_button_( _address_, _size_, _color_ )
      If _address_\round > 2
        If _address_\width % 2
          draw_roundbox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, _size_ + 1,_size_ + 1, _color_ ) 
        Else
          draw_roundbox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_,_size_, _size_,_size_, _color_ ) 
        EndIf
      Else
        If _address_\width % 2
          draw_roundbox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
        Else
          draw_roundbox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
        EndIf
      EndIf
    EndMacro
    
    Macro draw_check_button_( _address_, _size_, _color_ )
      If _address_\___state 
        LineXY(( _address_\x +0+ ( _address_\width-_size_ )/2 ),( _address_\y +4+ ( _address_\height-_size_ )/2 ),( _address_\x +1+ ( _address_\width-_size_ )/2 ),( _address_\y +5+ ( _address_\height-_size_ )/2 ), _color_ ) ; Левая линия
        LineXY(( _address_\x +0+ ( _address_\width-_size_ )/2 ),( _address_\y +5+ ( _address_\height-_size_ )/2 ),( _address_\x +1+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; Левая линия
        
        LineXY(( _address_\x +5+ ( _address_\width-_size_ )/2 ),( _address_\y +0+ ( _address_\height-_size_ )/2 ),( _address_\x +2+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; правая линия
        LineXY(( _address_\x +6+ ( _address_\width-_size_ )/2 ),( _address_\y +0+ ( _address_\height-_size_ )/2 ),( _address_\x +3+ ( _address_\width-_size_ )/2 ),( _address_\y +6+ ( _address_\height-_size_ )/2 ), _color_ ) ; правая линия
      EndIf
    EndMacro
    
    Macro draw_button_( _type_, _x_,_y_, _width_, _height_, _checked_, _round_, _color_fore_=$FFFFFFFF, _color_fore2_=$FFE9BA81, _color_back_=$80E2E2E2, _color_back2_=$FFE89C3D, _color_frame_=$80C8C8C8, _color_frame2_=$FFDC9338, _alpha_ = 255 ) 
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
      LinearGradient( _x_,_y_, _x_, ( _y_ + _height_ ))
      
      If _checked_
        BackColor( _color_fore2_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back2_&$FFFFFF | _alpha_<<24 )
      Else
        BackColor( _color_fore_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      draw_roundbox_( _x_,_y_,_width_,_height_, _round_,_round_ )
      
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
              draw_roundbox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5, 5,5 ) 
            Else
              draw_roundbox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4, 4,4 ) 
            EndIf
          Else
            If _checked_ =- 1
              If _width_%2
                draw_box_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5 ) 
              Else
                draw_box_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4 ) 
              EndIf
            Else
              _box_x_ = _width_/2 - 4
              _box_y_ = _box_x_ + Bool( _width_%2 ) 
              
              LineXY(( _x_ + 1+_box_x_ ),( _y_ +4+ _box_y_ ),( _x_ +2+ _box_x_ ),( _y_ +5+ _box_y_ )) ; Левая линия
              LineXY(( _x_ + 1+_box_x_ ),( _y_ +5+ _box_y_ ),( _x_ +2+ _box_x_ ),( _y_ +6+ _box_y_ )) ; Левая линия
              
              LineXY(( _x_ + 6+_box_x_ ),( _y_ +0+ _box_y_ ),( _x_ +3+ _box_x_ ),( _y_ +6+ _box_y_ )) ; правая линия
              LineXY(( _x_ + 7+_box_x_ ),( _y_ +0+ _box_y_ ),( _x_ +4+ _box_x_ ),( _y_ +6+ _box_y_ )) ; правая линия
            EndIf
          EndIf
        EndIf
        
      EndIf    
      
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _checked_
        FrontColor( _color_frame2_&$FFFFFF | _alpha_<<24 )
      Else
        FrontColor( _color_frame_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      draw_roundbox_( _x_,_y_,_width_,_height_, _round_,_round_, _color_frame_&$FFFFFF | _alpha_<<24 )
    EndMacro
    
    
    ;-  -----------------
    ;-   DECLARE_globals
    ;-  -----------------
    Global _macro_call_count_
    Global *canvas.allocate( STRUCT )
    
    ;-  -------------------
    ;-   DECLARE_functions
    ;-  -------------------
    ;{
    ; Requester
    Global resize_one
    Declare   EventHandler ( canvas.i=- 1, eventtype.i =- 1 )
    Declare   WaitClose( *this = #PB_Any, waittime.l = 0 )
    Declare   Message( Title.s, Text.s, Flag.i = #Null )
    
    Declare.i Tree_properties( x.l,y.l,width.l,height.l, Flag.i = 0 )
    
    Declare a_init( *this, grid_size.a = 7, grid_type.b = 0 )
    Declare a_set( *this, size.l = #PB_Ignore, position.l = #PB_Ignore )
    Declare a_update( *parent )
    
    Declare.i SetAttachment( *this, *parent, mode.a )
    Declare.i SetAlignmentFlag( *this, Mode.l, Type.l = 1 )
    Declare.i SetAlignment( *this, left.l, top.l, right.l, bottom.l, auto.b = #True )
    Declare   SetFrame( *this, size.a, mode.i = 0 )
    Declare   a_object( x.l,y.l,width.l,height.l, text.s, Color.l, flag.i=#Null, framesize=1 )
    
    Declare.i TypeFromClass( class.s )
    Declare.s ClassFromType( type.i )
    Declare.b IsContainer( *this )
    
    Declare.b Draw( *this )
    Declare   ReDraw( *this )
    
    Declare.l x( *this, mode.l = #__c_frame )
    Declare.l Y( *this, mode.l = #__c_frame )
    Declare.l Width( *this, mode.l = #__c_frame )
    Declare.l Height( *this, mode.l = #__c_frame )
    
    Declare.b Hide( *this, State.b = #PB_Default )
    Declare.b Disable( *this, State.b = #PB_Default )
    Declare.i Sticky( *window = #PB_Default, state.b = #PB_Default )
    Declare.i Display( *this, *display, x = #PB_Ignore, y = #PB_Ignore )
    
    Declare.b Update( *this )
    Declare   IsChild( *this, *parent )
    Declare   Flag( *this, flag.i = #Null, state.b = #PB_Default )
    Declare.b Resize( *this, ix.l, iy.l, iwidth.l, iheight.l )
    Declare   MoveBounds( *this, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
    Declare   SizeBounds( *this, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
    
    Declare.l CountItems( *this )
    Declare.l ClearItems( *this )
    Declare   RemoveItem( *this, Item.l ) 
    
    ;;Declare.b GetFocus( *this )
    Declare.l GetIndex( *this )
    Declare   GetWidget( index )
    
    Declare.l GetDeltaX( *this )
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
    
    Declare   GetPosition( *this, position.l )
    Declare   SetPosition( *this, position.l, *widget = #Null )
    
    Declare.l GetColor( *this, ColorType.l )
    Declare.l SetColor( *this, ColorType.l, Color.l )
    
    Declare.i GetAttribute( *this, Attribute.l )
    Declare.i SetAttribute( *this, Attribute.l, *value )
    
    
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
    
    Declare   SetImage( *this, *image )
    Declare   SetBackgroundImage( *this, *image )
    
    Declare.i Create( *parent, class.s, type.l, x.l,y.l,width.l,height.l, Text.s = #Null$, flag.i = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 7, ScrollStep.f = 1.0 )
    
    ; button
    Declare.i Text( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
    Declare.i String( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
    Declare.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
    Declare.i Option( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
    Declare.i Checkbox( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
    Declare.i HyperLink( x.l,y.l,width.l,height.l, Text.s, Color.i, Flag.i = 0 )
    Declare.i ComboBox( x.l,y.l,width.l,height.l, Flag.i = 0 )
    
    ; bar
    ;Declare.i bar_area_( *parent, ScrollStep, AreaWidth, AreaHeight, width, height, Mode = 1 )
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
    
    Declare.i bar_tab_SetState( *this._S_widget, State.l )
    Declare   mdi_bar_update_( *this, x.l,y.l,width.l,height.l )
    Declare   bar_Resizes( *this, x.l,y.l,width.l,height.l )
    Declare.b bar_Change( *this, ScrollPos.l )
    
    Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.i = 0 )
    Declare   AddColumn( *this, Position.l, Text.s, Width.l, Image.i =- 1 )
    
    Declare.b Arrow( x.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
    
    Declare.i Post( *this, eventtype.l, *button = #PB_All, *data = #Null )
    Declare.i Bind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Unbind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    
    ;
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    ;
    Declare   DoEvents( *this, eventtype.l, *button = #PB_All, *data = #Null ) ;, mouse_x.l, mouse_y.l
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    Declare.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l,height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  Window = -1, *CallBack = #Null )
    Declare   Free( *this )
    ;}
  EndDeclareModule
  
  Module Widget
    ;-
    ;- DECLARE_private_functions
    ;-
    Declare.b bar_tab_draw( *this )
    Declare.b bar_Update( *bar, mode.b = 1 )
    Declare.b bar_SetState( *bar, state.l )
    
    Declare.l draw_items_( *this._S_widget, List *rows._S_rows( ), _scroll_x_, _scroll_y_ )
    
    Macro row_x_( _this_, _address_ )
      ( _this_\x[#__c_inner] + _address_\x )  ;  + scroll_x_( _this_ )
    EndMacro
    
    Macro row_y_( _this_, _address_ )
      ( _this_\y[#__c_inner] + _address_\y )
    EndMacro
    
    Macro row_text_x_( _this_, _address_ )
      ( row_x_( _this_, _address_ ) + _address_\text\x )
    EndMacro
    
    Macro row_text_y_( _this_, _address_ )
      ( row_y_( _this_, _address_ ) + _address_\text\y )
    EndMacro
    
    Macro row_scroll_y_( _this_, _row_, _page_height_= )
      bar_scroll_pos_( _this_\scroll\v, ( row_y_( _this_, _row_ ) _page_height_ ) - _this_\scroll\v\y, _row_\height )
    EndMacro
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ;     Macro OSX_NSColorToRGB( _color_ )
      ;       _color_
      ;     EndMacro
      ;     Macro BlendColor_(Color1, Color2, Scale=50)
      ;       Color1
      ;     EndMacro
      
      Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
        Define.i R1, G1, B1, R2, G2, B2
        Define.f Blend = Scale / 100
        
        R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
        R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
        
        ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
      EndProcedure
      
      Procedure OSX_NSColorToRGBA(NSColor)
        Protected.cgfloat red, green, blue, alpha
        Protected nscolorspace, rgba
        nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
        If nscolorspace
          CocoaMessage(@red, nscolorspace, "redComponent")
          CocoaMessage(@green, nscolorspace, "greenComponent")
          CocoaMessage(@blue, nscolorspace, "blueComponent")
          CocoaMessage(@alpha, nscolorspace, "alphaComponent")
          rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
          ProcedureReturn rgba
        EndIf
      EndProcedure
      
      Procedure OSX_NSColorToRGB(NSColor)
        Protected.cgfloat red, green, blue
        Protected r, g, b, a
        Protected nscolorspace, rgb
        nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
        If nscolorspace
          CocoaMessage(@red, nscolorspace, "redComponent")
          CocoaMessage(@green, nscolorspace, "greenComponent")
          CocoaMessage(@blue, nscolorspace, "blueComponent")
          rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
          ProcedureReturn rgb
        EndIf
      EndProcedure
    CompilerEndIf
    
    ;     CompilerSelect #PB_Compiler_OS ;{ Color
    ;       CompilerCase #PB_OS_Windows
    ;         _get_colors_( )\Front         = GetSysColor_(#COLOR_WINDOWTEXT)
    ;         _get_colors_( )\Back          = GetSysColor_(#COLOR_WINDOW)
    ;         _get_colors_( )\Focus         = GetSysColor_(#COLOR_HIGHLIGHT)
    ;         _get_colors_( )\Gadget        = GetSysColor_(#COLOR_mENU)
    ;         _get_colors_( )\Button        = GetSysColor_(#COLOR_3DLIGHT)
    ;         _get_colors_( )\Border        = GetSysColor_(#COLOR_WINDOWFRAME)
    ;         _get_colors_( )\WordColor     = GetSysColor_(#COLOR_HOTLIGHT)
    ;         _get_colors_( )\Highlight     = GetSysColor_(#COLOR_HIGHLIGHT)
    ;         _get_colors_( )\HighlightText = GetSysColor_(#COLOR_HIGHLIGHTTEXT)
    ;         
    ;       CompilerCase #PB_OS_MacOS
    ;         _get_colors_( )\Front         = OSX_NSColorToRGBa(CocoaMessage(0, 0, "NSColor textColor"))
    ;         ;_get_colors_( )\Back          = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
    ;         ;_get_colors_( )\back[2]      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor keyboardFocusIndicatorColor"))
    ;         ;_get_colors_( )\Back         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
    ;         _get_colors_( )\Back         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
    ;         _get_colors_( )\frame         = OSX_NSColorToRGBa(CocoaMessage(0, 0, "NSColor grayColor"))
    ;         ;_get_colors_( )\back[2]       = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextBackgroundColor"))
    ;         ;_get_colors_( )\front[2]      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextColor"))
    ;       CompilerCase #PB_OS_Linux
    ;         
    ;     CompilerEndSelect ;}        
    
    ;-
    Procedure   CreateIcon( img.l, type.l )
      Protected x,y,Pixel, size = 8, index.i
      
      index = CreateImage( img, size, size ) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing( ImageOutput( img ))
        draw_box_( 0, 0, size, size, $fff0f0f0 );GetSysColor_( #COLOR_bTNFACE ))
        
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
    
    Macro DrawArrow2( _x_, _y_, _direction_, _frame_color_ = $ffffffff, _back_color_ = $ff000000)
      If _direction_ = 0 ; left
        If _frame_color_ <> _back_color_
          Line(_x_+8, _y_-2, 1, 11, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_+7, _y_-1, _frame_color_ ) : Plot(_x_+7, _y_+7, _frame_color_ ) 
          Plot(_x_+6, _y_+0, _frame_color_ ) : Plot(_x_+6, _y_+6, _frame_color_ )                                      
          Plot(_x_+5, _y_+1, _frame_color_ ) : Plot(_x_+5, _y_+5, _frame_color_ )                                      
          Plot(_x_+4, _y_+2, _frame_color_ ) : Plot(_x_+4, _y_+4, _frame_color_ )                                       
          Plot(_x_+3, _y_+3, _frame_color_)                                       
        EndIf
        Line(_x_+7, _y_+0, 1, 7, _back_color_) 
        Line(_x_+6, _y_+1, 1, 5, _back_color_) 
        Line(_x_+5, _y_+2, 1, 3, _back_color_) 
        Plot(_x_+4, _y_+3, _back_color_)       
      ElseIf _direction_ = 1 ; up
        If _frame_color_ <> _back_color_
          Line(_x_- 1, _y_+7, 11, 1, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_+0, _y_+6, _frame_color_ ) : Plot(_x_+8, _y_+6, _frame_color_ )                                      
          Plot(_x_+1, _y_+5, _frame_color_ ) : Plot(_x_+7, _y_+5, _frame_color_ )                                      
          Plot(_x_+2, _y_+4, _frame_color_ ) : Plot(_x_+6, _y_+4, _frame_color_ )                                       
          Plot(_x_+3, _y_+3, _frame_color_ ) : Plot(_x_+5, _y_+3, _frame_color_ )                                       
          Plot(_x_+4, _y_+2, _frame_color_)                                        
        EndIf
        Line(_x_+1, _y_+6, 7, 1, _back_color_) 
        Line(_x_+2, _y_+5, 5, 1, _back_color_) 
        Line(_x_+3, _y_+4, 3, 1, _back_color_) 
        Plot(_x_+4, _y_+3, _back_color_)       
      ElseIf _direction_ = 2 ; right
        If _frame_color_ <> _back_color_
          Line(_x_+3, _y_-2, 1, 11, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_+4, _y_-1, _frame_color_ ) : Plot(_x_+4, _y_+7, _frame_color_ ) 
          Plot(_x_+5, _y_+0, _frame_color_ ) : Plot(_x_+5, _y_+6, _frame_color_ )                                      
          Plot(_x_+6, _y_+1, _frame_color_ ) : Plot(_x_+6, _y_+5, _frame_color_ )                                      
          Plot(_x_+7, _y_+2, _frame_color_ ) : Plot(_x_+7, _y_+4, _frame_color_ )                                       
          Plot(_x_+8, _y_+3, _frame_color_)                                       
        EndIf
        Line(_x_+4, _y_+0, 1, 7, _back_color_) 
        Line(_x_+5, _y_+1, 1, 5, _back_color_) 
        Line(_x_+6, _y_+2, 1, 3, _back_color_) 
        Plot(_x_+7, _y_+3, _back_color_)       
      ElseIf _direction_ = 3 ; down
        If _frame_color_ <> _back_color_
          Line(_x_- 1, _y_+2, 11, 1, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_+0, _y_+3, _frame_color_ ) : Plot(_x_+8, _y_+3, _frame_color_ )                                      
          Plot(_x_+1, _y_+4, _frame_color_ ) : Plot(_x_+7, _y_+4, _frame_color_ )                                      
          Plot(_x_+2, _y_+5, _frame_color_ ) : Plot(_x_+6, _y_+5, _frame_color_ )                                       
          Plot(_x_+3, _y_+6, _frame_color_ ) : Plot(_x_+5, _y_+6, _frame_color_ )                                       
          Plot(_x_+4, _y_+7, _frame_color_)                                        
        EndIf
        Line(_x_+1, _y_+3, 7, 1, _back_color_) 
        Line(_x_+2, _y_+4, 5, 1, _back_color_) 
        Line(_x_+3, _y_+5, 3, 1, _back_color_) 
        Plot(_x_+4, _y_+6, _back_color_)       
      EndIf
    EndMacro
    
    Procedure   DrawArrow( x.l, y.l, Direction.l, color.l )
      If Direction = 0
        ; left                                                                                  ; 0,0,0,0,0,0,0,0
        Plot( x + 3, y + 1, color ) : Plot( x + 4, y + 1, color ) : Plot( x + 5, y + 1, color ) ; 0,0,0,1,1,1,0,0                    
        Plot( x + 2, y + 2, color ) : Plot( x + 3, y + 2, color ) : Plot( x + 4, y + 2, color ) ; 0,0,1,1,1,0,0,0 
        Plot( x + 1, y + 3, color ) : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) ; 0,1,1,1,0,0,0,0
        Plot( x + 3, y + 4, color ) : Plot( x + 2, y + 4, color ) : Plot( x + 4, y + 4, color ) ; 0,0,1,1,1,0,0,0   
        Plot( x + 3, y + 5, color ) : Plot( x + 4, y + 5, color ) : Plot( x + 5, y + 5, color ) ; 0,0,0,1,1,1,0,0               
                                                                                                ; 0,0,0,0,0,0,0,0    
      EndIf
      If Direction = 2
        ; right                                                                                  ; 0,0,0,0,0,0,0,0
        Plot( x + 1, y + 1, color ) : Plot( x + 2, y + 1, color ) : Plot( x + 3, y + 1, color )  ; 0,0,1,1,1,0,0,0                       
        Plot( x + 2, y + 2, color ) : Plot( x + 3, y + 2, color ) : Plot( x + 4, y + 2, color )  ; 0,0,0,1,1,1,0,0                    
        Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 5, y + 3, color )  ; 0,0,0,0,1,1,1,0
        Plot( x + 2, y + 4, color ) : Plot( x + 3, y + 4, color ) : Plot( x + 4, y + 4, color )  ; 0,0,0,1,1,1,0,0                        
        Plot( x + 1, y + 5, color ) : Plot( x + 2, y + 5, color ) : Plot( x + 3, y + 5, color )  ; 0,0,1,1,1,0,0,0  
                                                                                                 ; 0,0,0,0,0,0,0,0
      EndIf
      
      If Direction = 1
        ; up                                                                                                                                                  ; 0,0,0,0,0,0,0
        : Plot( x + 3, y + 1, color )                                                             ; 0,0,0,1,0,0,0
        : Plot( x + 2, y + 2, color ) : Plot( x + 3, y + 2, color ) : Plot( x + 4, y + 2, color ) ; 0,0,1,1,1,0,0
        Plot( x + 1, y + 3, color ) : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 5, y + 3, color ) ; 0,1,1,1,1,1,0
        Plot( x + 1, y + 4, color ) : Plot( x + 2, y + 4, color )                               : Plot( x + 4, y + 4, color ) : Plot( x + 5, y + 4, color ) ; 0,1,1,0,1,1,0
        Plot( x + 1, y + 5, color )                                                                                           : Plot( x + 5, y + 5, color ) ; 0,1,0,0,0,1,0    
                                                                                                                                                            ; 0,0,0,0,0,0,0
                                                                                                                                                            ; 0,0,0,0,0,0,0
      EndIf
      If Direction = 3
        ; down                                                                                                                                                ; 0,0,0,0,0,0,0
        Plot( x + 1, y + 1, color )                                                                                           : Plot( x + 5, y + 1, color )   ; 0,1,0,0,0,1,0
        Plot( x + 1, y + 2, color ) : Plot( x + 2, y + 2, color )                               : Plot( x + 4, y + 2, color ) : Plot( x + 5, y + 2, color )   ; 0,1,1,0,1,1,0
        Plot( x + 1, y + 3, color ) : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 5, y + 3, color )   ; 0,1,1,1,1,1,0
        : Plot( x + 2, y + 4, color ) : Plot( x + 3, y + 4, color ) : Plot( x + 4, y + 4, color )                                                             ; 0,0,1,1,1,0,0
        : Plot( x + 3, y + 5, color )                                                                                                                         ; 0,0,0,1,0,0,0
                                                                                                                                                              ; 0,0,0,0,0,0,0
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
        : Plot( x+4, y+1, color ) : Plot( x+5, y+1, color )         : Plot( x+6, y+1, color ) 
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
            LineXY(( x + 1 + i ) + Size,( Y + i - 1 ) - ( Style ),( x + 1 + i ) + Size,( Y + i - 1 ) + ( Style ),Color )         ; Левая линия
            LineXY(( ( x + 1 + ( Size )) - i ),( Y + i - 1 ) - ( Style ),(( x + 1 + ( Size )) - i ),( Y + i - 1 ) + ( Style ),Color ) ; правая линия
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
            LineXY(( x + 1 + i ),( Y + i ) - ( Style ),( x + 1 + i ),( Y + i ) + ( Style ),Color ) ; Левая линия
            LineXY(( ( x + 1 + ( Size*2 )) - i ),( Y + i ) - ( Style ),(( x + 1 + ( Size*2 )) - i ),( Y + i ) + ( Style ),Color ) ; правая линия
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
            LineXY(( ( x + 1 ) + i ) - ( Style ),(( ( Y + 1 ) + ( Size )) - i ),(( x + 1 ) + i ) + ( Style ),(( ( Y + 1 ) + ( Size )) - i ),Color ) ; правая линия
            LineXY(( ( x + 1 ) + i ) - ( Style ),(( Y + 1 ) + i ) + Size,(( x + 1 ) + i ) + ( Style ),(( Y + 1 ) + i ) + Size,Color )               ; Левая линия
          Next  
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style =- 1
              LineXY(( Size + x ), y + i, x, y + Length, Color )
              LineXY(( Size + x ), y + Length*2 - i, x, y + Length, Color )
            Else
              LineXY(( Size + x ) - i/2, y + i, x, y + Length, Color )
              LineXY(( Size + x ) - i/2, y + Length*2 - i, x, y + Length, Color )
            EndIf
          Next 
          i = Bool( Style =- 1 ) 
          LineXY(( Size + x ) + Bool( i = 0 ), y, x + 1, y + Length, Color ) 
          LineXY(( Size + x ) + Bool( i = 0 ), y + Length*2, x + 1, y + Length, Color )
        EndIf
      ElseIf Direction = 2 ; в право
        If Style > 0 : y - 1 ;: x + 1
          Size / 2
          For i = 0 To Size 
            ; в право
            LineXY(( ( x + 1 ) + i ) - ( Style ),(( Y + 1 ) + i ),(( x + 1 ) + i ) + ( Style ),(( Y + 1 ) + i ),Color ) ; Левая линия
            LineXY(( ( x + 1 ) + i ) - ( Style ),(( ( Y + 1 ) + ( Size*2 )) - i ),(( x + 1 ) + i ) + ( Style ),(( ( Y + 1 ) + ( Size*2 )) - i ),Color ) ; правая линия
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
        *value = Round(( *value/Grid ), #PB_Round_Nearest ) * Grid 
        
        If *value > Max 
          *value = Max 
        EndIf
      EndIf
      
      ProcedureReturn *value
      ;   Procedure.i Match( *value.i, Grid.i, Max.i = $7FFFFFFF )
      ;     ProcedureReturn (( Bool( *value>Max ) * Max ) + ( Bool( Grid And *value<Max ) * ( Round(( *value/Grid ), #PB_round_nearest ) * Grid ) ))
    EndProcedure
    
    Procedure   Draw_Datted( x, Y, SourceColor, TargetColor )
      Static Len.b
      Protected Color,
                Dot = a_transform( )\dotted\dot, 
                Space.b = a_transform( )\dotted\space, 
                line.b = a_transform( )\dotted\line
      
      ;             Dot = 1 
      ;             Space = 4
      ;             line = 8
      
      If Len<=Bool(Dot) * (space+1)+Space+line
        If Len<=Bool(Dot) * (space+1)+Space
          If Len = Space
            Color = SourceColor
          Else
            Color = TargetColor
          EndIf
        Else
          Color = SourceColor
        EndIf
      Else
        If Space
          Color = TargetColor
        Else
          Color = SourceColor
        EndIf
        Len = 0
      EndIf
      
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
    
    
    
    ;- DD
    #PB_Drop_Item =- 5
    #PB_Cursor_Drag = 50
    #PB_Cursor_Drop = 51
    #PB_Drag_Drop = 32
    
    Macro _DD_action_( _address_ )
      Bool( _address_\drop And mouse( )\drag And 
            _address_\drop\format = mouse( )\drag\format And 
            _address_\drop\actions & mouse( )\drag\actions And
            _address_\drop\PrivateType = mouse( )\drag\PrivateType )
    EndMacro
    
    Procedure   DD_Cursor( *this._S_widget )
      If mouse( )\drag 
        If _DD_action_( *this)
          SetCursor( *this, ImageID( CatchImage( #PB_Any, ?add, 601 ) ))
        Else
          SetCursor( *this, ImageID( CatchImage( #PB_Any, ?copy, 530 ) ))
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
      EndIf
    EndProcedure
    
    Procedure   DD_Draw( *this._S_widget )
      Protected *e._S_widget = EnteredWidget( )
      Protected jj = 2, ss = 7, tt = 3
      Protected j = 5, s = 3, t = 1
      ; if you drag to the widget-dropped
      If mouse( )\drag And *e ;;And *this\state\flag & #__S_drop
        
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        
        If *e\drop 
          If _DD_action_( *e )
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $1000ff00 )
            If *this\row 
              If *this\EnteredRow( ) And *this\EnteredRow( )\state\enter
                If *this\EnteredRow( )\state\enter < 0
                  draw_box_( row_x_( *this, *this\EnteredRow( ) ) + jj, row_y_( *this, *this\EnteredRow( ) ) - tt, *this\EnteredRow( )\width - jj*2, ss, $2000ff00 )
                Else
                  draw_box_( row_x_( *this, *this\EnteredRow( ) ) + jj, row_y_( *this, *this\EnteredRow( ) ) + *this\EnteredRow( )\height - tt, *this\EnteredRow( )\width - jj*2, ss, $2000ff00 )
                EndIf
              Else
                If *this\count\items And *this\VisibleLastRow( )
                  draw_box_(row_x_( *this, *this\VisibleLastRow( ) ) + jj,  row_y_( *this, *this\VisibleLastRow( ) ) + *this\VisibleLastRow( )\height - tt, *this\VisibleLastRow( )\width - jj*2, ss, $2000ff00 )
                Else
                  draw_box_( *this\x[#__c_inner] + jj, *this\y[#__c_inner] - tt, *this\width[#__c_inner] - jj*2, ss, $2000ff00 )
                EndIf
              EndIf
            EndIf
          Else
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff0000 )
          EndIf
        Else
          If *this\state\flag & #__S_drag 
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff00ff )
          Else
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $100000ff )
          EndIf
        EndIf
        
        drawing_mode_( #PB_2DDrawing_Outlined )
        
        If *e\drop ; *this\drop 
          If _DD_action_( *e )
            draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ff00ff00 )
            If *this\row 
              If *this\EnteredRow( ) And *this\EnteredRow( )\state\enter
                If *this\EnteredRow( )\state\enter < 0
                  draw_box_( row_x_( *this, *this\EnteredRow( ) ) + j, row_y_( *this, *this\EnteredRow( ) ) - t, *this\EnteredRow( )\width - j*2, s, $ff00ff00 )
                Else
                  draw_box_( row_x_( *this, *this\EnteredRow( ) ) + j, row_y_( *this, *this\EnteredRow( ) ) + *this\EnteredRow( )\height - t, *this\EnteredRow( )\width - j*2, s, $ff00ff00 )
                EndIf
              Else
                If *this\count\items And *this\VisibleLastRow( )
                  draw_box_(row_x_( *this, *this\VisibleLastRow( ) ) + j,  row_y_( *this, *this\VisibleLastRow( ) ) + *this\VisibleLastRow( )\height - t, *this\VisibleLastRow( )\width - j*2, s, $ff00ff00 )
                Else
                  draw_box_( *this\x[#__c_inner] + j, *this\y[#__c_inner] - t, *this\width[#__c_inner] - j*2, s, $ff00ff00 )
                EndIf
              EndIf
            EndIf
          Else
            draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff0000 )
          EndIf
        Else
          If *this\state\flag & #__S_drag 
            draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff00ff )
          Else
            draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ff0000ff )
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.l DD_DropX( )
      ProcedureReturn mouse( )\drag\x
    EndProcedure
    
    Procedure.l DD_DropY( )
      ProcedureReturn mouse( )\drag\y
    EndProcedure
    
    Procedure.l DD_DropWidth( )
      ProcedureReturn mouse( )\drag\width
    EndProcedure
    
    Procedure.l DD_DropHeight( )
      ProcedureReturn mouse( )\drag\height
    EndProcedure
    
    Procedure.i DD_DropType( )
      If _DD_action_( EnteredWidget( ) ) 
        ProcedureReturn EnteredWidget( )\drop\format 
      EndIf
    EndProcedure
    
    Procedure.i DD_DropAction( )
      If _DD_action_( EnteredWidget( ) ) 
        ProcedureReturn EnteredWidget( )\drop\Actions 
      EndIf
    EndProcedure
    
    Procedure.s DD_DropFiles( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop files - "+mouse( )\drag\string
        ProcedureReturn mouse( )\drag\string
      EndIf
    EndProcedure
    
    Procedure.s DD_DropText( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop text - "+mouse( )\drag\string
        ProcedureReturn mouse( )\drag\string
      EndIf
    EndProcedure
    
    Procedure.i DD_DropPrivate( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop type - "+mouse( )\drag\PrivateType
        ProcedureReturn mouse( )\drag\PrivateType
      EndIf
    EndProcedure
    
    Procedure.i DD_DropImage( Image.i = -1, Depth.i = 24 )
      Protected result.i
      
      If _DD_action_( EnteredWidget( ) ) And mouse( )\drag\value
        Debug "   event drop image - "+mouse( )\drag\value
        
        If Image  = - 1
          Result = CreateImage( #PB_Any, mouse( )\drag\Width, mouse( )\drag\Height ) : Image = Result
        Else
          Result = IsImage( Image )
        EndIf
        
        If Result And StartDrawing( ImageOutput( Image ))
          If Depth = 32
            DrawAlphaImage( mouse( )\drag\value, 0, 0 )
          Else
            DrawImage( mouse( )\drag\value, 0, 0 )
          EndIf
          StopDrawing( )
        EndIf  
        
        ProcedureReturn Result
      EndIf
    EndProcedure
    
    Procedure.i DD_DropEnable( *this._S_widget, Format.i, Actions.i, PrivateType.i = 0 )
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
      
      ; If Not FindMapElement( *droped( ), Hex( *this ))
      ;   Debug "Enable dropped - " + *this
      ;   AddMapElement( *droped( ), Hex( *this ))
      ;   *droped.allocate( DD, ( ))
      ; EndIf
      ; 
      ; *droped( )\format = Format
      ; *droped( )\actions = Actions
      ; *droped( )\PrivateType = PrivateType
      
      If IsGadget(*this)
        ProcedureReturn PB(EnableGadgetDrop)(*this, Format, Actions, PrivateType )
      EndIf
      
      If Not *this\drop
        Debug "Enable dropped - " + *this\class
        *this\drop.allocate( DD )
      EndIf
      
      *this\drop\format = Format
      *this\drop\actions = Actions
      *this\drop\PrivateType = PrivateType
    EndProcedure
    
    
    Procedure.i DD_DragItem( *rows, Actions.i = #PB_Drag_Copy )
      Debug "  drag Item - " + *rows
      
      If *rows
        mouse( )\drag.allocate( DD )
        mouse( )\drag\format = #PB_Drop_Item
        mouse( )\drag\actions = Actions
        mouse( )\drag\value = *rows
        DD_Cursor( PressedWidget( ) )
      EndIf
    EndProcedure
    
    Procedure.i DD_DragText( Text.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag text - " + Text
      
      If Text
        mouse( )\drag.allocate( DD )
        mouse( )\drag\format = #PB_Drop_Text
        mouse( )\drag\actions = Actions
        mouse( )\drag\string = Text
        DD_Cursor( PressedWidget( ) )
      EndIf
    EndProcedure
    
    Procedure.i DD_DragImage( Image.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag image - " + Image
      
      If IsImage( Image )
        mouse( )\drag.allocate( DD )
        mouse( )\drag\format = #PB_Drop_Image
        mouse( )\drag\actions = Actions
        mouse( )\drag\value = ImageID( Image )
        mouse( )\drag\width = ImageWidth( Image )
        mouse( )\drag\height = ImageHeight( Image )
        DD_Cursor( PressedWidget( ) )
      EndIf
    EndProcedure
    
    Procedure.i DD_DragFiles( Files.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag files - " + Files
      
      If Files
        mouse( )\drag.allocate( DD )
        mouse( )\drag\format = #PB_Drop_Files
        mouse( )\drag\actions = Actions
        mouse( )\drag\string = Files
        DD_Cursor( PressedWidget( ) )
      EndIf
    EndProcedure
    
    Procedure.i DD_DragPrivate( PrivateType.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag private - " + PrivateType
      
      If PrivateType
        mouse( )\drag.allocate( DD )
        mouse( )\drag\format = #PB_Drop_Private
        mouse( )\drag\actions = Actions
        mouse( )\drag\PrivateType = PrivateType
        DD_Cursor( PressedWidget( ) )
      EndIf
    EndProcedure
    
    ;- 
    ;-  ANCHORs
    Structure _S_DATA_TRANSFORM_CURSOR
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
    
    Global *Data_Transform_Cursor._S_DATA_TRANSFORM_CURSOR = ?DATA_TRANSFORM_CURSOR
    
    Macro a_transform_( _this_ )
      Bool( _this_\_a_\transform Or ( is_integral_( _this_ ) And _this_\_parent( )\_a_\transform ) )
    EndMacro
    
    Macro a_set_transform_state_( _this_, _state_ )
      _this_\_a_\transform = _state_
      
      ; is integral scrol bar's
      If _this_\scroll
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\type 
          _this_\scroll\v\_a_\transform = _this_\_a_\transform
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\type 
          _this_\scroll\h\_a_\transform = _this_\_a_\transform
        EndIf
      EndIf
      
      ; is integral tab bar
      If _this_\TabWidget( ) And Not _this_\TabWidget( )\hide And _this_\TabWidget( )\type 
        _this_\TabWidget( )\_a_\transform = _this_\_a_\transform
      EndIf
    EndMacro
    
    Macro a_is_at_point_( _this_ )
      Bool( _this_ And a_enter_index( _this_ ) And (( a_enter_index( _this_ ) <> #__a_moved ) Or ( _this_\container And a_enter_index( _this_ ) = #__a_moved )))
      ; Bool( _this_ And _this_\_a_\id And a_enter_index( _this_ ) And a_enter_index( _this_ ) <> #__a_moved )
    EndMacro
    
    Procedure a_grid_image( Steps = 5, line=0, Color = 0, startx = 0, starty = 0 )
      Macro a_grid_change( _this_, _redraw_ = #False )
        If a_transform( )\grid\widget <> _this_
          If a_transform( )\grid\size > 1 And a_transform( )\grid\widget
            SetBackgroundImage( a_transform( )\grid\widget, #PB_Default )
          EndIf
          a_transform( )\grid\widget = _this_
          
          If _this_\container > 0 And _this_\type <> #__type_MDI
            _this_\image[#__img_background]\x =- _this_\fs
            _this_\image[#__img_background]\y =- _this_\fs
          EndIf
          
          If a_transform( )\grid\size > 1
            SetBackgroundImage( a_transform( )\grid\widget, a_transform( )\grid\image )
          EndIf
          
          If _redraw_
            ReDraw( _this_\_root( ) )
          EndIf
        EndIf
      EndMacro
      
      Static ID
      Protected hDC, x,y
      startx = 0
      starty = 0
      If Not ID
        ;Steps - 1
        
        ExamineDesktops( )
        Protected width = DesktopWidth( 0 )   
        Protected height = DesktopHeight( 0 )
        ID = CreateImage( #PB_Any, width, height, 32, #PB_Image_Transparent )
        
        If Color = 0 : Color = $ff808080 : EndIf
        
        
        If Drawing( )
          StopDrawing( )
          Drawing( ) = 0
        EndIf
        
        If StartDrawing( ImageOutput( ID ))
          drawing_mode_( #PB_2DDrawing_AllChannels )
          ;Box( 0, 0, width, height, BoxColor )
          
          For x = startx To width - 1
            
            For y = starty To height - 1
              
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
    
    Macro a_set_size( _address_, _size_ )
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
    
    Macro a_pos( _this_ )
      _this_\_a_\pos
    EndMacro
    
    Macro a_move( _address_, _x_, _y_, _width_, _height_, _a_moved_type_ )
      If _address_[0] And a_enter_widget( ) ; frame
        _address_[0]\x = _x_ + a_pos( a_enter_widget( ) ) ; a_transform( )\pos
        _address_[0]\y = _y_ + a_pos( a_enter_widget( ) ) ; a_transform( )\pos
        _address_[0]\width = _width_ - a_pos( a_enter_widget( ) ) * 2; a_transform( )\pos * 2
        _address_[0]\height = _height_ - a_pos( a_enter_widget( ) ) * 2; a_transform( )\pos * 2
      EndIf  
      
      If _address_[1] ; left
        _address_[1]\x = _x_   
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
      
      If _address_[#__a_moved] ; moved
        If _a_moved_type_
          _address_[#__a_moved]\x = _x_
          _address_[#__a_moved]\y = _y_
          _address_[#__a_moved]\width = a_focus_widget( )\_a_\size * 2
          _address_[#__a_moved]\height = a_focus_widget( )\_a_\size * 2
        Else
          _address_[#__a_moved]\x = _x_ + a_pos( a_enter_widget( ) ) ; a_transform( )\pos
          _address_[#__a_moved]\y = _y_ + a_pos( a_enter_widget( ) ) ; a_transform( )\pos
          _address_[#__a_moved]\width = _width_ - a_pos( a_enter_widget( ) ) * 2; ;a_transform( )\pos * 2
          _address_[#__a_moved]\height = _height_ - a_pos( a_enter_widget( ) ) * 2; a_transform( )\pos * 2
        EndIf
        ;Debug _address_[#__a_moved]\height
      EndIf
      
      If a_focus_widget( ) And 
         a_transform( )\id[10] And 
         a_transform( )\id[11] And
         a_transform( )\id[12] And
         a_transform( )\id[13]
        ;a_lines( a_focus_widget( ) )
        
        a_transform( )\id[10]\color\state = 0
        a_transform( )\id[11]\color\state = 0
        a_transform( )\id[12]\color\state = 0
        a_transform( )\id[13]\color\state = 0
        
        ; line size
        a_transform( )\id[10]\width = 1
        a_transform( )\id[11]\height = 1
        a_transform( )\id[12]\width = 1
        a_transform( )\id[13]\height = 1
        
        ;
        a_transform( )\id[10]\height = a_focus_widget( )\height[#__c_frame]
        a_transform( )\id[11]\width = a_focus_widget( )\width[#__c_frame]
        a_transform( )\id[12]\height = a_focus_widget( )\height[#__c_frame]
        a_transform( )\id[13]\width = a_focus_widget( )\width[#__c_frame]
        
        ; line pos
        a_transform( )\id[10]\x = a_focus_widget( )\x[#__c_frame]
        a_transform( )\id[10]\y = a_focus_widget( )\y[#__c_frame]
        
        a_transform( )\id[11]\x = a_focus_widget( )\x[#__c_frame]
        a_transform( )\id[11]\y = a_focus_widget( )\y[#__c_frame]
        
        a_transform( )\id[12]\x = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - a_transform( )\id[12]\width
        a_transform( )\id[12]\y = a_focus_widget( )\y[#__c_frame]
        
        a_transform( )\id[13]\x = a_focus_widget( )\x[#__c_frame]
        a_transform( )\id[13]\y = (a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]) - a_transform( )\id[13]\height
        
        If ListSize( enumWidget( ))
          PushListPosition( enumWidget( ))
          ForEach enumWidget( )
            If Not enumWidget( )\hide And enumWidget( )\_a_\transform And
               is_parent_one_( enumWidget( ), a_focus_widget( ))
              
              ;Left_line
              If a_focus_widget( )\x[#__c_frame] = enumWidget( )\x[#__c_frame]
                If a_transform( )\id[10]\y > enumWidget( )\y[#__c_frame] 
                  a_transform( )\id[10]\y = enumWidget( )\y[#__c_frame] 
                EndIf
                If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] < enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]
                  a_transform( )\id[10]\height = ( enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame] ) - a_transform( )\id[10]\y
                Else
                  a_transform( )\id[10]\height = ( a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] ) - a_transform( )\id[10]\y
                EndIf
                
                a_transform( )\id[10]\color\state = 2
              EndIf
              
              ;Right_line
              If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] = enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]
                If a_transform( )\id[12]\y > enumWidget( )\y[#__c_frame] 
                  a_transform( )\id[12]\y = enumWidget( )\y[#__c_frame] 
                EndIf
                If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] < enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame] 
                  a_transform( )\id[12]\height = ( enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]) - a_transform( )\id[12]\y
                Else
                  a_transform( )\id[12]\height = (a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]) - a_transform( )\id[12]\y
                EndIf
                
                a_transform( )\id[12]\color\state = 2
              EndIf
              
              ;Top_line
              If a_focus_widget( )\y[#__c_frame] = enumWidget( )\y[#__c_frame] 
                If a_transform( )\id[11]\x > enumWidget( )\x[#__c_frame] 
                  a_transform( )\id[11]\x = enumWidget( )\x[#__c_frame] 
                EndIf
                If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] < enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]
                  a_transform( )\id[11]\width = ( enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]) - a_transform( )\id[11]\x
                Else
                  a_transform( )\id[11]\width = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - a_transform( )\id[11]\x
                EndIf
                
                a_transform( )\id[11]\color\state = 1
              EndIf
              
              ;Bottom_line
              If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] = enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]
                If a_transform( )\id[13]\x > enumWidget( )\x[#__c_frame] 
                  a_transform( )\id[13]\x = enumWidget( )\x[#__c_frame] 
                EndIf
                If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] < enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame] 
                  a_transform( )\id[13]\width = ( enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]) - a_transform( )\id[13]\x
                Else
                  a_transform( )\id[13]\width = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - a_transform( )\id[13]\x
                EndIf
                
                a_transform( )\id[13]\color\state = 1
              EndIf
            EndIf
          Next
          PopListPosition( enumWidget( ))
        EndIf
      EndIf
      
    EndMacro 
    
    Macro a_draw( _address_ )
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _address_ = a_focus_widget( )\_a_\id
        ; left line
        If a_transform( )\id[10] 
          If a_focus_widget( )\_a_\id[#__a_moved] And a_transform( )\id[10]\y = a_focus_widget( )\y[#__c_frame] And a_transform( )\id[10]\height = a_focus_widget( )\height[#__c_frame]
            draw_box_( a_transform( )\id[10]\x, a_transform( )\id[10]\y, a_transform( )\id[10]\width, a_transform( )\id[10]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
          Else
            draw_box_( a_transform( )\id[10]\x, a_transform( )\id[10]\y, a_transform( )\id[10]\width, a_transform( )\id[10]\height ,a_transform( )\id[10]\color\frame[a_transform( )\id[10]\color\state] ) 
          EndIf
        EndIf
        
        ; top line
        If a_transform( )\id[12] 
          If a_focus_widget( )\_a_\id[#__a_moved] And a_transform( )\id[12]\y = a_focus_widget( )\y[#__c_frame] And a_transform( )\id[12]\height = a_focus_widget( )\height[#__c_frame]
            draw_box_( a_transform( )\id[12]\x, a_transform( )\id[12]\y, a_transform( )\id[12]\width, a_transform( )\id[12]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
          Else
            draw_box_( a_transform( )\id[12]\x, a_transform( )\id[12]\y, a_transform( )\id[12]\width, a_transform( )\id[12]\height ,a_transform( )\id[12]\color\frame[a_transform( )\id[12]\color\state] ) 
          EndIf
        EndIf
        
        ; right line
        If a_transform( )\id[11] 
          If a_focus_widget( )\_a_\id[#__a_moved] And a_transform( )\id[11]\x = a_focus_widget( )\x[#__c_frame] And a_transform( )\id[11]\width = a_focus_widget( )\width[#__c_frame]
            draw_box_( a_transform( )\id[11]\x, a_transform( )\id[11]\y, a_transform( )\id[11]\width, a_transform( )\id[11]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
          Else
            draw_box_( a_transform( )\id[11]\x, a_transform( )\id[11]\y, a_transform( )\id[11]\width, a_transform( )\id[11]\height ,a_transform( )\id[11]\color\frame[a_transform( )\id[11]\color\state] ) 
          EndIf
        EndIf
        
        ; bottom line
        If a_transform( )\id[13] 
          If a_focus_widget( )\_a_\id[#__a_moved] And a_transform( )\id[13]\x = a_focus_widget( )\x[#__c_frame] And a_transform( )\id[13]\width = a_focus_widget( )\width[#__c_frame]
            draw_box_( a_transform( )\id[13]\x, a_transform( )\id[13]\y, a_transform( )\id[13]\width, a_transform( )\id[13]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
          Else
            draw_box_( a_transform( )\id[13]\x, a_transform( )\id[13]\y, a_transform( )\id[13]\width, a_transform( )\id[13]\height ,a_transform( )\id[13]\color\frame[a_transform( )\id[13]\color\state] ) 
          EndIf
        EndIf
      Else
        If _address_[0] :draw_box_( _address_[0]\x, _address_[0]\y, _address_[0]\width, _address_[0]\height ,_address_[0]\color\back[_address_[0]\color\state] ) : EndIf
      EndIf
      
      ;If _address_\container 
      If _address_[#__a_moved] And ( _address_[#__a_moved]\width <> _address_[0]\width And _address_[#__a_moved]\height <> _address_[0]\height  )
        draw_box_( _address_[#__a_moved]\x, _address_[#__a_moved]\y, _address_[#__a_moved]\width, _address_[#__a_moved]\height, _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] ) 
      EndIf
      ;EndIf
      
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw background anchors
      If _address_[1] :draw_box_( _address_[1]\x, _address_[1]\y, _address_[1]\width, _address_[1]\height ,_address_[1]\color\back[_address_[1]\color\state] ) : EndIf
      If _address_[2] :draw_box_( _address_[2]\x, _address_[2]\y, _address_[2]\width, _address_[2]\height ,_address_[2]\color\back[_address_[2]\color\state] ) : EndIf
      If _address_[3] :draw_box_( _address_[3]\x, _address_[3]\y, _address_[3]\width, _address_[3]\height ,_address_[3]\color\back[_address_[3]\color\state] ) : EndIf
      If _address_[4] :draw_box_( _address_[4]\x, _address_[4]\y, _address_[4]\width, _address_[4]\height ,_address_[4]\color\back[_address_[4]\color\state] ) : EndIf
      If _address_[5] :draw_box_( _address_[5]\x, _address_[5]\y, _address_[5]\width, _address_[5]\height ,_address_[5]\color\back[_address_[5]\color\state] ) : EndIf
      If _address_[6] :draw_box_( _address_[6]\x, _address_[6]\y, _address_[6]\width, _address_[6]\height ,_address_[6]\color\back[_address_[6]\color\state] ) : EndIf
      If _address_[7] :draw_box_( _address_[7]\x, _address_[7]\y, _address_[7]\width, _address_[7]\height ,_address_[7]\color\back[_address_[7]\color\state] ) : EndIf
      If _address_[8] :draw_box_( _address_[8]\x, _address_[8]\y, _address_[8]\width, _address_[8]\height ,_address_[8]\color\back[_address_[8]\color\state] ) : EndIf
      
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      ; draw frame anchors
      If _address_[1] :draw_box_( _address_[1]\x, _address_[1]\y, _address_[1]\width, _address_[1]\height, _address_[1]\color\frame[_address_[1]\color\state] ) : EndIf
      If _address_[2] :draw_box_( _address_[2]\x, _address_[2]\y, _address_[2]\width, _address_[2]\height, _address_[2]\color\frame[_address_[2]\color\state] ) : EndIf
      If _address_[3] :draw_box_( _address_[3]\x, _address_[3]\y, _address_[3]\width, _address_[3]\height, _address_[3]\color\frame[_address_[3]\color\state] ) : EndIf
      If _address_[4] :draw_box_( _address_[4]\x, _address_[4]\y, _address_[4]\width, _address_[4]\height, _address_[4]\color\frame[_address_[4]\color\state] ) : EndIf
      If _address_[5] :draw_box_( _address_[5]\x, _address_[5]\y, _address_[5]\width, _address_[5]\height, _address_[5]\color\frame[_address_[5]\color\state] ) : EndIf
      If _address_[6] :draw_box_( _address_[6]\x, _address_[6]\y, _address_[6]\width, _address_[6]\height, _address_[6]\color\frame[_address_[6]\color\state] ) : EndIf
      If _address_[7] :draw_box_( _address_[7]\x, _address_[7]\y, _address_[7]\width, _address_[7]\height, _address_[7]\color\frame[_address_[7]\color\state] ) : EndIf
      If _address_[8] :draw_box_( _address_[8]\x, _address_[8]\y, _address_[8]\width, _address_[8]\height, _address_[8]\color\frame[_address_[8]\color\state] ) : EndIf
    EndMacro
    
    Procedure  a_draw_sel( *sel._s_TRANSFORM )
      ; draw grab background 
      If *sel\grab
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        DrawImage( ImageID( *sel\grab ), 0,0 )
        
        If Not *sel\type
          CustomFilterCallback( @Draw_Datted( ))
        EndIf 
        
        If *sel\id[0]\color\back[0]
          draw_box_( *sel\id[0]\x, *sel\id[0]\y, *sel\id[0]\width, *sel\id[0]\height, *sel\id[0]\color\back[0] )
        EndIf
        
        If *sel\type
          DrawText( *sel\id[0]\x + 3, *sel\id[0]\y + 1, Str( *sel\id[0]\width ) +"x"+ Str( *sel\id[0]\height ), *sel\id[0]\color\front[0], *sel\id[0]\color\back[0] )
          
          If *sel\id[0]\color\frame[0]
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_box_( *sel\id[0]\x, *sel\id[0]\y, *sel\id[0]\width, *sel\id[0]\height, *sel\id[0]\color\frame[0] )
          EndIf
        Else
          drawing_mode_alpha_( #PB_2DDrawing_CustomFilter | #PB_2DDrawing_Outlined ) 
          draw_box_( *sel\id[0]\x, *sel\id[0]\y, *sel\id[0]\width, *sel\id[0]\height, *sel\id[0]\color\frame[0] ) 
        EndIf
      EndIf
    EndProcedure
    
    Macro a_remove( _this_, _index_ )
      For _index_ = 0 To #__a_moved
        If _this_\_a_\id[_index_]
          FreeStructure( _this_\_a_\id[_index_] )
          _this_\_a_\id[_index_] = #Null
        EndIf
      Next
    EndMacro
    
    Macro a_add( _this_, _index_ )
      For _index_ = 0 To #__a_moved
        If _this_\_a_\mode & #__a_height = 0 And 
           _this_\_a_\mode & #__a_width = 0
          If _index_ = 1 Or
             _index_ = 2 Or
             _index_ = 3 Or
             _index_ = 4
            Continue
          EndIf
        Else
          If _this_\_a_\mode & #__a_height = 0
            If _index_ = 2 Or
               _index_ = 4
              Continue
            EndIf
          EndIf
          If _this_\_a_\mode & #__a_width = 0
            If _index_ = 1 Or
               _index_ = 3
              Continue
            EndIf
          EndIf
        EndIf
        
        If _this_\_a_\mode & #__a_corner = 0
          If _index_ = 5 Or
             _index_ = 6 Or
             _index_ = 7 Or
             _index_ = 8
            Continue
          EndIf
        EndIf
        
        If _this_\_a_\mode & #__a_position = 0
          If _index_ = #__a_moved
            Continue
          EndIf
        EndIf
        
        ;
        If Not _this_\_a_\id[_index_]
          _this_\_a_\id.allocate( BUTTONS, [_index_] )
        EndIf
        
        _this_\_a_\id[_index_]\cursor = *Data_Transform_Cursor\cursor[_index_]
        
        _this_\_a_\id[_index_]\color\frame[#__S_0] = $ff000000
        _this_\_a_\id[_index_]\color\frame[#__S_1] = $ffFF0000
        _this_\_a_\id[_index_]\color\frame[#__S_2] = $ff0000FF
        
        If _index_ = 0 
          _this_\_a_\id[_index_]\color\back[#__S_0] = $ff000000
        Else
          _this_\_a_\id[_index_]\color\back[#__S_0] = $ffFFFFFF
        EndIf
        _this_\_a_\id[_index_]\color\back[#__S_1] = $80FF0000 
        _this_\_a_\id[_index_]\color\back[#__S_2] = $800000FF
      Next _index_
    EndMacro
    
    Macro a_enter_anchor_( _this_ )
      _this_\_a_\id[a_enter_index( _this_ )]
    EndMacro
    
    Procedure a_at_point( canvas, *enter.Integer = 0, *leave.Integer = 0)
      Protected i, *a_ew._S_widget = a_enter_widget( )
      
      If Not mouse( )\buttons
        If *a_ew And 
           *a_ew\_root( )\canvas\gadget = canvas
          
          If a_enter_index( *a_ew ) And 
             a_enter_anchor_( *a_ew ) And 
             Not is_at_point_( a_enter_anchor_( *a_ew ), mouse( )\x, mouse( )\y ) 
            
            If a_enter_index( *a_ew ) <> #__a_moved
              a_enter_anchor_( *a_ew )\color\state = #__S_0
              
              ; ;             If *leave And PeekI(*leave) <> *a_ew
              ; ;               PokeI(*leave, *a_ew) 
              ; ;               ;;Debug "" +a_enter_index( *a_ew )+ " - a_leaved all"
              ; ;             Else
              ; ;               ;;Debug "" +a_enter_index( *a_ew )+ " - a_leave"
              ; ;             EndIf
              
              If *leave And *leave\i <> *a_ew
                *leave\i = *a_ew
                ;;Debug "" +a_enter_index( *a_ew )+ " - a_leaved all"
              Else
                ;;Debug "" +a_enter_index( *a_ew )+ " - a_leave"
              EndIf
              
              DoEvents( *a_ew, #PB_EventType_CursorChange, a_enter_anchor_( *a_ew ), *a_ew\_a_\id[i]\cursor )
              ; PostCanvasRepaint( *a_ew\_root( ) )
            EndIf
            
            a_enter_index( *a_ew ) = 0
          EndIf
          
          ; From point anchor
          For i = 1 To #__a_moved 
            If *a_ew\_a_\id[i] And 
               is_at_point_( *a_ew\_a_\id[i], mouse( )\x, mouse( )\y ) 
              ;
              If a_enter_index( *a_ew ) <> i
                a_enter_index( *a_ew ) = i
                
                If i <> #__a_moved
                  ;;Debug "" +i+ " - a_enter"
                  If *enter And *enter\i <> *a_ew
                    *enter\i = *a_ew
                  EndIf
                  *a_ew\_a_\id[i]\color\state = #__S_1
                EndIf
                
                DoEvents( *a_ew, #PB_EventType_CursorChange, a_enter_anchor_( *a_ew ), *a_ew\_a_\id[i]\cursor )
                ; PostCanvasRepaint( *a_ew\_root( ) )
              EndIf
              Break
            EndIf
          Next
        EndIf
        
        If a_focus_widget( ) And 
           a_focus_widget( )\_root( )\canvas\gadget = canvas
          
          ; From point anchor
          For i = 1 To #__a_moved 
            If a_focus_widget( )\_a_\id[i] And is_at_point_( a_focus_widget( )\_a_\id[i], mouse( )\x, mouse( )\y ) 
              If a_enter_index( a_focus_widget( ) ) <> i
                a_enter_index( a_focus_widget( ) ) = i
                
                If i <> #__a_moved
                  If *a_ew And
                     *a_ew <> a_focus_widget( ) And 
                     a_enter_anchor_( *a_ew )
                    
                    a_enter_anchor_( *a_ew )\color\state = #__S_0
                    DoEvents( *a_ew, #PB_EventType_CursorChange, a_enter_anchor_( *a_ew ), a_enter_anchor_( *a_ew )\cursor )
                    a_enter_index( *a_ew ) = 0
                    
                    If *leave And *leave\i <> *a_ew
                      *leave\i = *a_ew
                    EndIf
                  EndIf
                  
                  If *enter And *enter\i <> a_focus_widget( )
                    *enter\i = a_focus_widget( )
                  EndIf
                  a_focus_widget( )\_a_\id[i]\color\state = #__S_1
                  DoEvents( a_focus_widget( ), #PB_EventType_CursorChange, a_enter_anchor_( a_focus_widget( ) ), a_focus_widget( )\_a_\id[i]\cursor )
                EndIf
              EndIf
              Break
            EndIf
          Next
          
        EndIf
      EndIf
      
      ProcedureReturn a_is_at_point_( *a_ew )
    EndProcedure
    
    Procedure.i a_set( *this._S_widget, size.l = #PB_Ignore, position.l = #PB_Ignore )
      Protected value, result.i, i
      Static *before._S_widget
      
      If is_integral_( *this )
        *this = *this\_parent( )
      EndIf
      
      ; 
      If *this = a_transform( )\main And a_focus_widget( )
        *this = a_transform( )\main\first\widget
      EndIf
      
      ;
      If *this And ( *this\_a_\transform =- 1 And Not a_enter_index( *this ) ) Or
         ( *this\_a_\transform = 1 And a_focus_widget( ) <> *this )
        
        If a_focus_widget( )
          ;           ; return layout position
          ;           If *before
          ;             SetPosition( a_focus_widget( ), #PB_List_After, *before ) 
          ;           Else 
          ;             SetPosition( a_focus_widget( ), #PB_List_First ) 
          ;           EndIf
          ;           ;
          ;           *before = GetPosition( *this, #PB_List_Before )
          ;           If *this <> *this\_parent( )\last\widget
          ;             SetPosition( *this, #PB_List_Last ) 
          ;           EndIf
          
          ;
          a_remove( a_focus_widget( ), i ) 
        EndIf
        
        ; a_add
        a_add( *this, i )
        a_grid_change( *this\_parent( ) )
        
        
        result = a_focus_widget( )
        a_focus_widget( ) = *this
        FocusedWidget( ) = *this
        a_enter_widget( ) = *this
        
        ; a_resize( *this, size )
        If size <> #PB_Ignore
          ;_this_\bs = _this_\fs + a_transform( )\pos
          If *this\container And *this\fs > 1 
            *this\_a_\size = size + *this\fs 
          Else
            *this\_a_\size = size
          EndIf
          
          If position = #PB_Ignore
            position = size - size / 3 - 2
          EndIf
          
          *this\_a_\pos = position
          *this\bs = position + *this\fs
        EndIf
        
        ;
        a_set_size( *this\_a_\id, *this\_a_\size )
        a_move( *this\_a_\id,
                *this\x[#__c_screen],
                *this\y[#__c_screen], 
                *this\width[#__c_screen], 
                *this\height[#__c_screen], *this\container )
        
        ; get transform index
        ;a_index( value, *this\_a_\id, i )
        For i = 1 To #__a_moved 
          If *this\_a_\id[i]  
            If is_at_point_( *this\_a_\id[i], mouse( )\x, mouse( )\y ) 
              
              If *this\_a_\id[i]\color\state <> #__S_1
                ;set_cursor_( a_focus_widget( ), *this\_a_\id[i]\cursor )
                *this\_a_\id[i]\color\state = #__S_1
                value = 1
              EndIf
              
              a_enter_index( *this ) = i
              Break
              
            ElseIf *this\_a_\id[i]\color\state <> #__S_0
              ;set_cursor_( a_focus_widget( ), #PB_Cursor_Default )
              *this\_a_\id[i]\color\state = #__S_0
              a_enter_index( *this ) = 0
              value = 1
            EndIf
          EndIf
        Next
        
        ;
        Post( *this, #PB_EventType_StatusChange, a_enter_index( *this ) )
        If Not result
          result =- 1
        EndIf
      EndIf
      
      If result
        ; reset multi group
        If ListSize( a_transform( )\group( ))
          ForEach a_transform( )\group( )
            ;           a_transform( )\group( )\widget\_a_\transform = 1
            ;           a_transform( )\group( )\widget\_root( )\_a_\transform = 1
            ;           a_transform( )\group( )\widget\_parent( )\_a_\transform = 1
            
            a_set_transform_state_( a_transform( )\group( )\widget, 1 )
            a_set_transform_state_( a_transform( )\group( )\widget\_root( ), 1 )
            a_set_transform_state_( a_transform( )\group( )\widget\_parent( ), 1 )
          Next
          
          a_transform( )\id[0]\x = 0
          a_transform( )\id[0]\y = 0
          a_transform( )\id[0]\width = 0
          a_transform( )\id[0]\height = 0
          ClearList( a_transform( )\group( ))
        EndIf
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i a_init( *this._S_widget, grid_size.a = 7, grid_type.b = 0 )
      Protected i
      
      If Not *this\_a_\transform
        a_set_transform_state_( *this, 1 )
        
        If Not a_transform( )
          a_transform( ).allocate( TRANSFORM )
          
          a_transform( )\main = *this
          
          a_transform( )\grid\type = grid_type
          a_transform( )\grid\size = grid_size + 1
          a_transform( )\grid\image = a_grid_image( a_transform( )\grid\size - 1, a_transform( )\grid\type, $FF000000, *this\fs, *this\fs )
          
          For i = 0 To #__a_count
            a_transform( )\id[i]\cursor = *Data_Transform_Cursor\cursor[i]
            
            a_transform( )\id[i]\color\frame[0] = $ff000000
            a_transform( )\id[i]\color\frame[1] = $ffFF0000
            a_transform( )\id[i]\color\frame[2] = $ff0000FF
            
            a_transform( )\id[i]\color\back[0] = $ffFFFFFF
            a_transform( )\id[i]\color\back[1] = $ffFFFFFF
            a_transform( )\id[i]\color\back[2] = $ffFFFFFF
          Next i
          
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure   a_update( *parent._S_widget )
      If *parent\_a_\transform = 1 ; Not ListSize( a_transform( )\group( ))
                                   ; check transform group
        ForEach *parent\_widgets( )
          If *parent\_widgets( ) <> *parent And ; IsChild( *parent\_widgets( ), *parent ) And 
             is_parent_( *parent\_widgets( ), *parent ) And 
             is_inter_sect_( *parent\_widgets( ), a_transform( )\id[0], [#__c_frame] )
            
            ; Debug " -- "+ *parent\_widgets( )\class +"_"+ *parent\_widgets( )\count\index 
            
            ;             *parent\_widgets( )\_a_\transform = 2
            ;             *parent\_widgets( )\_root( )\_a_\transform =- 1
            ;             *parent\_widgets( )\_parent( )\_a_\transform =- 1
            a_set_transform_state_( *parent\_widgets( ), 2 )
            a_set_transform_state_( *parent\_widgets( )\_root( ), - 1 )
            a_set_transform_state_( *parent\_widgets( )\_parent( ), - 1 )
          EndIf
        Next
        
        ; reset
        a_transform( )\id[0]\x = 0
        a_transform( )\id[0]\y = 0
        a_transform( )\id[0]\width = 0
        a_transform( )\id[0]\height = 0
        ; ClearList( a_transform( )\group( ))
        
        ; init min group pos
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If a_transform( )\id[0]\x = 0 Or 
               a_transform( )\id[0]\x > *parent\_widgets( )\x[#__c_frame]
              a_transform( )\id[0]\x = *parent\_widgets( )\x[#__c_frame]
            EndIf
            If a_transform( )\id[0]\y = 0 Or 
               a_transform( )\id[0]\y > *parent\_widgets( )\y[#__c_frame]
              a_transform( )\id[0]\y = *parent\_widgets( )\y[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init max group size
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If a_transform( )\id[0]\x + a_transform( )\id[0]\width < *parent\_widgets( )\x[#__c_frame] + *parent\_widgets( )\width[#__c_frame]
              a_transform( )\id[0]\width = ( *parent\_widgets( )\x[#__c_frame] - a_transform( )\id[0]\x ) + *parent\_widgets( )\width[#__c_frame]
            EndIf
            If a_transform( )\id[0]\y + a_transform( )\id[0]\height < *parent\_widgets( )\y[#__c_frame] + *parent\_widgets( )\height[#__c_frame]
              a_transform( )\id[0]\height = ( *parent\_widgets( )\y[#__c_frame] - a_transform( )\id[0]\y ) + *parent\_widgets( )\height[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init group list ( & delta size )
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If AddElement( a_transform( )\group( ))
              a_transform( )\group.allocate( GROUP, ( ))
              ;a_transform( )\group( )\widget.allocate( WIDGET )
              
              a_transform( )\group( )\widget = *parent\_widgets( )
              a_transform( )\group( )\x = a_transform( )\group( )\widget\x[#__c_frame] - a_transform( )\id[0]\x
              a_transform( )\group( )\y = a_transform( )\group( )\widget\y[#__c_frame] - a_transform( )\id[0]\y
              
              a_transform( )\group( )\width = a_transform( )\id[0]\width - a_transform( )\group( )\widget\width[#__c_frame]
              a_transform( )\group( )\height = a_transform( )\id[0]\height - a_transform( )\group( )\widget\height[#__c_frame]
            EndIf
          EndIf
        Next
        
      Else
        ; update min group pos
        ForEach a_transform( )\group( )
          If a_transform( )\id[0]\x = 0 Or 
             a_transform( )\id[0]\x > a_transform( )\group( )\widget\x[#__c_frame]
            a_transform( )\id[0]\x = a_transform( )\group( )\widget\x[#__c_frame]
          EndIf
          If a_transform( )\id[0]\y = 0 Or 
             a_transform( )\id[0]\y > a_transform( )\group( )\widget\y[#__c_frame]
            a_transform( )\id[0]\y = a_transform( )\group( )\widget\y[#__c_frame]
          EndIf
        Next
        
        ; update max group size
        ForEach a_transform( )\group( )
          If a_transform( )\id[0]\x + a_transform( )\id[0]\width < a_transform( )\group( )\widget\x[#__c_frame] + a_transform( )\group( )\widget\width[#__c_frame]
            a_transform( )\id[0]\width = ( a_transform( )\group( )\widget\x[#__c_frame] - a_transform( )\id[0]\x ) + a_transform( )\group( )\widget\width[#__c_frame]
          EndIf
          If a_transform( )\id[0]\y + a_transform( )\id[0]\height < a_transform( )\group( )\widget\y[#__c_frame] + a_transform( )\group( )\widget\height[#__c_frame]
            a_transform( )\id[0]\height = ( a_transform( )\group( )\widget\y[#__c_frame] - a_transform( )\id[0]\y ) + a_transform( )\group( )\widget\height[#__c_frame]
          EndIf
        Next
        
        ; update delta size
        ForEach a_transform( )\group( )
          a_transform( )\group( )\x = a_transform( )\group( )\widget\x[#__c_frame] - a_transform( )\id[0]\x
          a_transform( )\group( )\y = a_transform( )\group( )\widget\y[#__c_frame] - a_transform( )\id[0]\y
          
          a_transform( )\group( )\width = a_transform( )\id[0]\width - a_transform( )\group( )\widget\width[#__c_frame]
          a_transform( )\group( )\height = a_transform( )\id[0]\height - a_transform( )\group( )\widget\height[#__c_frame]
        Next
      EndIf   
      
      ;
      a_set_size( a_transform( )\id, 7);a_transform( )\size )
      a_move( a_transform( )\id, 
              a_transform( )\id[0]\x - a_transform( )\pos, 
              a_transform( )\id[0]\y - a_transform( )\pos, 
              a_transform( )\id[0]\width + a_transform( )\pos*2, 
              a_transform( )\id[0]\height + a_transform( )\pos*2, 0 )
      
    EndProcedure
    
    Procedure a_show_( *this._S_widget, state )
      Protected Repaint, i 
      
      If Not ( a_focus_widget( ) And a_focus_widget( )\state\drag )
        If is_integral_( *this )
          *this = *this\_parent( )
        EndIf
        
        If state
          If a_enter_widget( ) <> *this 
            ;
            If a_enter_widget( ) And 
               *this\_parent( ) = a_enter_widget( ) And 
               a_focus_widget( ) <> a_enter_widget( ) 
              
              ;;Debug " a---#PB_EventType_MouseLeave"
              
              a_remove( a_enter_widget( ), i )
            EndIf
            
            a_enter_widget( ) = *this
            
            ;; Debug " a-#PB_EventType_MouseEnter"
            
            If a_focus_widget( ) <> *this 
              a_add( *this, i )
              
              ; a_resize( *this, *this\_a_\size )
              If *this\_a_\transform
                a_set_size( *this\_a_\id, *this\_a_\size )
                a_move( *this\_a_\id,
                        *this\x[#__c_screen],
                        *this\y[#__c_screen], 
                        *this\width[#__c_screen], 
                        *this\height[#__c_screen], *this\container )
              EndIf
              
              a_at_point( *this\_root( )\canvas\gadget )
              
              If *this\_a_\id[0]\color\state <> #__S_1
                *this\_a_\id[0]\color\state = #__S_1
              EndIf
              
              Repaint = #True
            EndIf
          EndIf
          
        Else
          If a_enter_widget( ) = *this 
            ; Debug " a-#PB_EventType_MouseLeave"
            
            If a_focus_widget( ) <> *this 
              a_remove( *this, i )
              a_enter_widget( ) = #Null
              Repaint = #True
            EndIf
            
            ;
            If *this\_parent( ) And *this\_parent( ) = EnteredWidget( ) And 
               EnteredWidget( )\_a_\transform And 
               a_enter_widget( ) <> EnteredWidget( )
              a_enter_widget( ) = EnteredWidget( )
              
              If a_focus_widget( ) <> EnteredWidget( ) 
                ;;Debug " a---#PB_EventType_MouseEnter"
                
                a_add( EnteredWidget( ), i )
                
                ; a_resize( EnteredWidget( ), EnteredWidget( )\_a_\size )
                If EnteredWidget( )\_a_\transform
                  a_set_size( EnteredWidget( )\_a_\id, EnteredWidget( )\_a_\size )
                  a_move( EnteredWidget( )\_a_\id,
                          EnteredWidget( )\x[#__c_screen],
                          EnteredWidget( )\y[#__c_screen], 
                          EnteredWidget( )\width[#__c_screen], 
                          EnteredWidget( )\height[#__c_screen], EnteredWidget( )\container )
                EndIf
                
                a_at_point( EnteredWidget( )\_root( )\canvas\gadget )
                
                If EnteredWidget( )\_a_\id[0]\color\state <> #__S_1
                  EnteredWidget( )\_a_\id[0]\color\state = #__S_1
                EndIf
                ;               EnteredWidget( )\state\repaint = 1
                
                Repaint = #True
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   a_events( *this._S_widget, eventtype.l, *button, *data )
      Protected mouse_x.l = mouse( )\x
      Protected mouse_y.l = mouse( )\y
      
      If a_transform( )  
        Static xx, yy, *after
        Static move_x, move_y
        Protected Repaint, i
        Protected mxw, myh
        Protected.l mx, my, mw, mh
        Protected.l Px,Py, IsGrid = Bool( a_transform( )\grid\size>1 )
        
        Protected text.s
        
        If eventtype = #PB_EventType_CursorChange
          If *button And *this\_a_\id
            If mouse( )\cursor <> *data
              ;Debug "cursor-change " + *data +" "+ *this\_root( )\canvas\gadget
              SetCursor( *this, *data )
              mouse( )\cursor = *data
            EndIf
          EndIf
        EndIf       
        
        ;
        If eventtype = #PB_EventType_MouseEnter
          If a_show_( *this, 1 )
            Repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_MouseLeave
          If a_show_( *this, 0 )
            Repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown 
          If *this = a_transform( )\main
            ;
            ; если нажали в главном "окне" 
            ; где находятся "изменяемые" виджеты
            ; то будем убырать все якорья
            ;
            If a_focus_widget( )
              a_remove( a_focus_widget( ), i ) 
            EndIf
          Else
            ;             ; get layout current position
            ;             ; set layout last position
            ;             *after = GetPosition( *this, #PB_List_After )
            ;             If *after
            ;               Repaint = SetPosition( *this, #PB_List_Last ) 
            ;             EndIf
            
            ; set current transformer
            If a_set( *this, #__a_size )
              Repaint = #True
            EndIf
          EndIf
          
          ; change frame color
          If a_transform( )\type > 0
            a_transform( )\id[0]\color\back = $9F646565
            a_transform( )\id[0]\color\frame = $BA161616
            a_transform( )\id[0]\color\front = $ffffffff
          Else
            a_transform( )\dotted\dot = 1 
            a_transform( )\dotted\space = 3
            a_transform( )\dotted\line = 5
            
            a_transform( )\id[0]\color\back = $80DFE2E2 
            a_transform( )\id[0]\color\frame = $BA161616
          EndIf
          
          If a_focus_widget( ) And a_focus_widget( )\_parent( ) And a_focus_widget( )\_a_ And a_enter_index( a_focus_widget( ) ) And a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]
            ; set current transform index
            a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\color\state = #__S_2
            
            ; 
            ; set delta pos
            ;
            If a_focus_widget( )\_parent( ) 
              If a_focus_widget( )\_a_\transform = 1
                If Not ( a_focus_widget( )\attach And a_focus_widget( )\attach\mode = 2 )
                  mouse_x + a_focus_widget( )\_parent( )\x[#__c_inner]
                EndIf
                If Not ( a_focus_widget( )\attach And a_focus_widget( )\attach\mode = 1 )
                  mouse_y + a_focus_widget( )\_parent( )\y[#__c_inner]
                EndIf
                
                If Not is_integral_( a_focus_widget( ))
                  mouse_x - scroll_x_( a_focus_widget( )\_parent( ) )
                  mouse_y - scroll_y_( a_focus_widget( )\_parent( ) )
                EndIf
              EndIf
            EndIf
            mouse( )\delta\x = mouse_x - a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\x
            mouse( )\delta\y = mouse_y - a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\y
            
            ;
            If Not ( a_focus_widget( )\container = 0 And a_enter_index( a_focus_widget( ) ) = #__a_moved )
              ; horizontal
              Select a_enter_index( a_focus_widget( ) )
                Case 1, 5, 8, #__a_moved ; left
                  mouse( )\delta\x - a_pos( a_focus_widget( ) ) - a_focus_widget( )\_parent( )\fs
                  
                Case 3, 6, 7 ; right
                  mouse( )\delta\x - ( a_focus_widget( )\_a_\size-a_pos( a_focus_widget( ) ) )
              EndSelect
              
              ; vertical
              Select a_enter_index( a_focus_widget( ) )
                Case 2, 5, 6, #__a_moved ; top
                  mouse( )\delta\y - a_pos( a_focus_widget( ) ) - a_focus_widget( )\_parent( )\fs
                  
                Case 4, 8, 7 ; bottom
                  mouse( )\delta\y - ( a_focus_widget( )\_a_\size-a_pos( a_focus_widget( ) ) ) 
              EndSelect
            EndIf
            
          Else
            If a_transform( )\main 
              mouse_x - a_transform( )\main\x[#__c_container]
              mouse_y - a_transform( )\main\y[#__c_container]
            EndIf
            
            ; for the selector
            ; grid mouse pos
            If a_transform( )\grid\size > 0
              mouse_x = (( mouse_x ) / a_transform( )\grid\size ) * a_transform( )\grid\size
              mouse_y = (( mouse_y ) / a_transform( )\grid\size ) * a_transform( )\grid\size 
            EndIf
            
            ; set delta pos
            mouse( )\delta\x = mouse_x
            mouse( )\delta\y = mouse_y
          EndIf
          
          ;
          If a_is_at_point_( *this )
            Repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          If a_focus_widget( )
            ;             If *after
            ;               Repaint = SetPosition( a_focus_widget( ), #PB_List_Before, *after ) 
            ;             EndIf
            
            If a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )] 
              If is_at_point_(  a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )], mouse_x, mouse_y )
                a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\color\state = #__S_1
              Else
                a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\color\state = #__S_0
              EndIf
              Repaint = #True
            EndIf
            
            If *this = a_transform( )\main
              a_focus_widget( ) = #Null
            EndIf
          EndIf
          ;  Repaint = #True
          
          ; init multi group selector
          If a_transform( )\grab And Not a_transform( )\type 
            a_update( *this )
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_DragStart 
          
          If a_focus_widget( ) And a_enter_index( a_focus_widget( ) ) = #__a_moved And a_focus_widget( )\_a_\id[#__a_moved]
            ; set_cursor_( *this, a_focus_widget( )\_a_\id[#__a_moved]\cursor )
          EndIf
          
          If *this\container And a_focus_widget( ) And 
             Not a_enter_index( a_focus_widget( ) ) And 
             is_at_point_( *this, mouse_x, mouse_y, [#__c_inner] )
            
            a_grid_change( *this, #True )
            ; set_cursor_( *this, #PB_Cursor_Cross )
            
            If StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
              a_transform( )\grab = GrabDrawingImage( #PB_Any, 0,0, *this\_root( )\width, *this\_root( )\height )
              StopDrawing( )
            EndIf
          EndIf
        EndIf
        
        ; 
        If eventtype = #PB_EventType_MouseMove
          
          If Not a_transform( )\grab And a_focus_widget( )
            If mouse( )\buttons And a_enter_index( a_focus_widget( ) ) And a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )] And a_focus_widget( )\_a_\id[a_enter_index( a_focus_widget( ) )]\color\state = #__S_2
              mouse_x - mouse( )\delta\x
              mouse_y - mouse( )\delta\y
              
              If a_transform( )\grid\size > 0
                mouse_x = ( mouse_x / a_transform( )\grid\size ) * a_transform( )\grid\size
                mouse_y = ( mouse_y / a_transform( )\grid\size ) * a_transform( )\grid\size
              EndIf
              
              If xx <> mouse_x Or yy <> mouse_y : xx = mouse_x : yy = mouse_y
                ; Debug mouse_x
                
                If a_focus_widget( )\_a_\transform = 1
                  mw = #PB_Ignore
                  mh = #PB_Ignore
                  
                  If a_enter_index( a_focus_widget( ) ) = #__a_moved   
                    ; move boundaries
                    If a_focus_widget( )\bounds\move
                      If a_focus_widget( )\bounds\move\min\x <> #PB_Ignore And
                         mouse_x <= a_focus_widget( )\bounds\move\min\x
                        mouse_x = a_focus_widget( )\bounds\move\min\x
                      EndIf
                      If a_focus_widget( )\bounds\move\max\x <> #PB_Ignore And
                         mouse_x >= a_focus_widget( )\bounds\move\max\x - a_focus_widget( )\width[#__c_frame]
                        mouse_x = a_focus_widget( )\bounds\move\max\x - a_focus_widget( )\width[#__c_frame]
                      EndIf
                      If a_focus_widget( )\bounds\move\min\y <> #PB_Ignore And 
                         mouse_y <= a_focus_widget( )\bounds\move\min\y
                        mouse_y = a_focus_widget( )\bounds\move\min\y
                      EndIf
                      If a_focus_widget( )\bounds\move\max\y <> #PB_Ignore And
                         mouse_y >= a_focus_widget( )\bounds\move\max\y - a_focus_widget( )\height[#__c_frame]
                        mouse_y = a_focus_widget( )\bounds\move\max\y - a_focus_widget( )\height[#__c_frame]
                      EndIf
                    EndIf
                    
                  Else
                    ; horizontal 
                    Select a_enter_index( a_focus_widget( ) )
                      Case 1, 5, 8 ; left
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move
                          If a_focus_widget( )\bounds\move\min\x <> #PB_Ignore And
                             mouse_x <= a_focus_widget( )\bounds\move\min\x
                            mouse_x = a_focus_widget( )\bounds\move\min\x
                          EndIf
                        EndIf
                        mw = ( a_focus_widget( )\x[#__c_container] - mouse_x ) + a_focus_widget( )\width[#__c_frame] + (a_focus_widget( )\_parent( )\fs); - a_focus_widget( )\fs[1])
                        If mw <= 0
                          mw = 0
                          mouse_x = a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]
                        EndIf
                        
                      Case 3, 6, 7 ; right
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move And 
                           a_focus_widget( )\bounds\move\max\x <> #PB_Ignore And
                           mouse_x >= a_focus_widget( )\bounds\move\max\x 
                          mouse_x = a_focus_widget( )\bounds\move\max\x
                        EndIf
                        mw = ( mouse_x - a_focus_widget( )\x[#__c_container] ) + IsGrid
                    EndSelect
                    
                    ; vertical
                    Select a_enter_index( a_focus_widget( ) )
                      Case 2, 5, 6 ; top
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move
                          If a_focus_widget( )\bounds\move\min\y <> #PB_Ignore And
                             mouse_y <= a_focus_widget( )\bounds\move\min\y
                            mouse_y = a_focus_widget( )\bounds\move\min\y
                          EndIf
                        EndIf
                        mh = ( a_focus_widget( )\y[#__c_container] - mouse_y ) + a_focus_widget( )\height[#__c_frame] + (a_focus_widget( )\_parent( )\fs); - a_focus_widget( )\fs[2])
                        If mh <= 0
                          mh = 0
                          mouse_y = a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]
                        EndIf
                        
                      Case 4, 8, 7 ; bottom 
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move And 
                           a_focus_widget( )\bounds\move\max\y <> #PB_Ignore And
                           mouse_y >= a_focus_widget( )\bounds\move\max\y 
                          mouse_y = a_focus_widget( )\bounds\move\max\y
                        EndIf
                        mh = ( mouse_y - a_focus_widget( )\y[#__c_container] ) + IsGrid
                    EndSelect
                    
                    ;
                    If a_enter_index( a_focus_widget( ) ) <> 5
                      If a_enter_index( a_focus_widget( ) ) <> 1 And a_enter_index( a_focus_widget( ) ) <> 8
                        mouse_x = #PB_Ignore
                      EndIf
                      If a_enter_index( a_focus_widget( ) ) <> 2 And a_enter_index( a_focus_widget( ) ) <> 6
                        mouse_y = #PB_Ignore
                      EndIf
                    EndIf
                    
                    If a_focus_widget( )\bounds\size 
                      ; size boundaries
                      If (( a_focus_widget( )\bounds\size\min\width <> #PB_Ignore And mw <= a_focus_widget( )\bounds\size\min\width ) Or
                          ( a_focus_widget( )\bounds\size\max\width <> #PB_Ignore And mw >= a_focus_widget( )\bounds\size\max\width ))
                        mw = #PB_Ignore
                        mouse_x = #PB_Ignore
                      EndIf
                      ; size boundaries
                      If (( a_focus_widget( )\bounds\size\min\height <> #PB_Ignore And mh <= a_focus_widget( )\bounds\size\min\height ) Or
                          ( a_focus_widget( )\bounds\size\max\height <> #PB_Ignore And mh >= a_focus_widget( )\bounds\size\max\height ))
                        mh = #PB_Ignore
                        mouse_y = #PB_Ignore
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint | Resize( a_focus_widget( ), mouse_x, mouse_y, mw, mh )
                  
                Else
                  If a_transform( )\main 
                    mouse_x + a_transform( )\main\x[#__c_container]
                    mouse_y + a_transform( )\main\y[#__c_container]
                  EndIf
                  
                  ; horizontal 
                  Select a_enter_index( a_focus_widget( ) )
                    Case 1, 5, 8, #__a_moved ; left
                      If a_enter_index( a_focus_widget( ) ) <> #__a_moved
                        a_transform( )\id[0]\width = ( a_transform( )\id[0]\x - mouse_x ) + a_transform( )\id[0]\width
                      EndIf     
                      a_transform( )\id[0]\x = mouse_x
                      
                    Case 3, 6, 7 ; right
                      a_transform( )\id[0]\width = ( mouse_x - a_transform( )\id[0]\x ) + IsGrid
                  EndSelect
                  
                  ; vertical
                  Select a_enter_index( a_focus_widget( ) )
                    Case 2, 5, 6, #__a_moved ; top
                      If a_enter_index( a_focus_widget( ) ) <> #__a_moved
                        a_transform( )\id[0]\height = ( a_transform( )\id[0]\y - mouse_y ) + a_transform( )\id[0]\height
                      EndIf  
                      a_transform( )\id[0]\y = mouse_y
                      
                    Case 4, 8, 7 ; bottom
                      a_transform( )\id[0]\height = ( mouse_y - a_transform( )\id[0]\y ) + IsGrid
                  EndSelect
                  
                  ;
                  ;\\\ multi resize
                  ;
                  
                  ;                   a_transform( )\id[0]\x = _x_
                  ;                   a_transform( )\id[0]\y = _y_
                  ;                   
                  ;                   a_transform( )\id[0]\width = _width_
                  ;                   a_transform( )\id[0]\height = _height_
                  
                  a_move( a_transform( )\id, 
                          a_transform( )\id[0]\x - a_transform( )\pos, 
                          a_transform( )\id[0]\y - a_transform( )\pos, 
                          a_transform( )\id[0]\width + a_transform( )\pos*2, 
                          a_transform( )\id[0]\height + a_transform( )\pos*2, 0)
                  
                  Select a_enter_index( a_transform( )\group( )\widget )
                    Case 1, 5, 8, #__a_moved ; left
                      ForEach a_transform( )\group( )
                        Repaint | Resize( a_transform( )\group( )\widget, 
                                          ( a_transform( )\id[0]\x - a_focus_widget( )\x[#__c_inner] ) + a_transform( )\group( )\x,
                                          #PB_Ignore, a_transform( )\id[0]\width - a_transform( )\group( )\width, #PB_Ignore )
                      Next
                      
                    Case 3, 6, 7 ; right
                      ForEach a_transform( )\group( )
                        Repaint | Resize( a_transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, a_transform( )\id[0]\width - a_transform( )\group( )\width, #PB_Ignore )
                      Next
                  EndSelect
                  
                  Select a_enter_index( a_transform( )\group( )\widget )
                    Case 2, 5, 6, #__a_moved ; top
                      ForEach a_transform( )\group( )
                        Repaint | Resize( a_transform( )\group( )\widget, #PB_Ignore, 
                                          ( a_transform( )\id[0]\y - a_focus_widget( )\y[#__c_inner] ) + a_transform( )\group( )\y,
                                          #PB_Ignore, a_transform( )\id[0]\height - a_transform( )\group( )\height )
                      Next
                      
                    Case 4, 8, 7 ; bottom 
                      ForEach a_transform( )\group( )
                        Repaint | Resize( a_transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, a_transform( )\id[0]\height - a_transform( )\group( )\height )
                      Next
                  EndSelect
                  
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          ; change selector coordinate
          If a_transform( )\grab
            If a_transform( )\main 
              mouse_x - a_transform( )\main\x[#__c_container]
              mouse_y - a_transform( )\main\y[#__c_container]
            EndIf
            
            If a_transform( )\grid\size > 0
              mouse_x = ( mouse_x / a_transform( )\grid\size ) * a_transform( )\grid\size
              mouse_y = ( mouse_y / a_transform( )\grid\size ) * a_transform( )\grid\size
            EndIf
            
            If move_x <> mouse_x
              If move_x > mouse_x
                Repaint =- 1
              Else
                Repaint = 1
              EndIf
              
              ; to left
              If mouse( )\delta\x > mouse_x
                a_transform( )\id[0]\x = mouse_x + a_transform( )\grid\size
                a_transform( )\id[0]\width = mouse( )\delta\x - mouse_x
              Else
                a_transform( )\id[0]\x = mouse( )\delta\x
                a_transform( )\id[0]\width = mouse_x - mouse( )\delta\x
              EndIf
              
              a_transform( )\id[0]\x + a_transform( )\main\x[#__c_container]
              If a_transform( )\grid\size > 0 
                a_transform( )\id[0]\width + 1 
              EndIf
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
                a_transform( )\id[0]\y = mouse_y + a_transform( )\grid\size
                a_transform( )\id[0]\height = mouse( )\delta\y - mouse_y 
              Else
                a_transform( )\id[0]\y = mouse( )\delta\y 
                a_transform( )\id[0]\height = mouse_y - mouse( )\delta\y 
              EndIf
              
              a_transform( )\id[0]\y + a_transform( )\main\y[#__c_container]
              If a_transform( )\grid\size > 0 
                a_transform( )\id[0]\height + 1 
              EndIf
              move_y = mouse_y
            EndIf
          EndIf
        EndIf
        
        ;- widget::a_key_events
        If eventtype = #PB_EventType_KeyDown
          If a_focus_widget( )
            If a_focus_widget( )\_a_\transform = 1
              mx = a_focus_widget( )\x[#__c_container]
              my = a_focus_widget( )\y[#__c_container]
              mw = a_focus_widget( )\width[#__c_frame]
              mh = a_focus_widget( )\height[#__c_frame] 
              
              ; fixed in container
              If a_focus_widget( )\_parent( ) And
                 a_focus_widget( )\_parent( )\container ;;> 0
                mx + a_focus_widget( )\_parent( )\fs
                my + a_focus_widget( )\_parent( )\fs
              EndIf
              
            Else
              mx = a_transform( )\id[0]\x
              my = a_transform( )\id[0]\y
              mw = a_transform( )\id[0]\width
              mh = a_transform( )\id[0]\height
            EndIf
            
            Select Keyboard( )\Key[1] 
              Case (#PB_Canvas_Alt | #PB_Canvas_Control), #PB_Canvas_Shift
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left  : mw - a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = 3  
                  Case #PB_Shortcut_Right : mw + a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = 3
                    
                  Case #PB_Shortcut_Up    : mh - a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = 4
                  Case #PB_Shortcut_Down  : mh + a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = 4
                EndSelect
                
                Repaint | Resize( a_focus_widget( ), mx, my, mw, mh )
                
              Case (#PB_Canvas_Shift | #PB_Canvas_Control), #PB_Canvas_Alt ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control | #PB_Canvas_Command
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left  : mx - a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = #__a_moved
                  Case #PB_Shortcut_Right : mx + a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = #__a_moved
                    
                  Case #PB_Shortcut_Up    : my - a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = #__a_moved
                  Case #PB_Shortcut_Down  : my + a_transform( )\grid\size : a_enter_index( a_focus_widget( ) ) = #__a_moved
                EndSelect
                
                Repaint | Resize( a_focus_widget( ), mx, my, mw, mh )
                
              Default
                
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Up   
                    If a_focus_widget( )\before\widget
                      Repaint = a_set( a_focus_widget( )\before\widget )
                    EndIf
                    
                  Case #PB_Shortcut_Down  
                    If a_focus_widget( )\after\widget
                      Repaint = a_set( a_focus_widget( )\after\widget )
                    EndIf
                    
                  Case #PB_Shortcut_Left  
                    If a_focus_widget( )\_parent( )
                      Repaint = a_set( a_focus_widget( )\_parent( ) )
                    EndIf
                    
                  Case #PB_Shortcut_Right 
                    If a_focus_widget( )\first\widget
                      Repaint = a_set( a_focus_widget( )\first\widget )
                    ElseIf a_focus_widget( )\_parent( ) And a_focus_widget( )\_parent( )\last\widget
                      Repaint = a_set( a_focus_widget( )\_parent( )\last\widget )
                    EndIf
                    
                EndSelect
                
            EndSelect
          EndIf
        EndIf
        
        If eventtype = #PB_EventType_LeftButtonUp
          a_transform( )\grab = 0
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  PRIVATEs
    ;-
    ;-
    Macro make_scrollarea_x( _this_, _address_ )
      ; make horizontal scroll x
      If _address_\align\anchor\right
        scroll_x_( _this_ ) = ( _this_\width[#__c_inner] - scroll_width_( _this_ ) )
      ElseIf Not _address_\align\anchor\left ; horizontal center
        scroll_x_( _this_ ) = ( _this_\width[#__c_inner] -  scroll_width_( _this_ ))/2
      Else
        If _this_\scroll\h
          scroll_x_( _this_ ) =- ( _this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min )
        Else
          scroll_x_( _this_ ) = 0
        EndIf
      EndIf
    EndMacro    
    
    Macro make_scrollarea_y( _this_, _address_, _rotate_=0 )
      ; make vertical scroll y
      If _address_\align\anchor\bottom
        scroll_y_( _this_ ) = ( _this_\height[#__c_inner] - scroll_height_( _this_ ) )
      ElseIf Not _address_\align\anchor\top ; vertical center
        scroll_y_( _this_ ) = ( _this_\height[#__c_inner] - scroll_height_( _this_ ) )/2
        ;           If _this_\_box_ And _this_\_box_\height And Not _address_\align\anchor\left And Not _address_\align\anchor\right
        ;             If _rotate_ = 0
        ;               scroll_y_( _this_ ) = ( _this_\height[#__c_inner] - scroll_height_( _this_ ) + _this_\_box_\height ) / 2
        ;             Else
        ;               scroll_y_( _this_ ) = ( _this_\height[#__c_inner] - scroll_height_( _this_ ) - _this_\_box_\height ) / 2
        ;             EndIf
        ;           Else
        ;             scroll_y_( _this_ ) = ( _this_\height[#__c_inner] - scroll_height_( _this_ ) ) / 2
        ;           EndIf
      Else
        If _this_\scroll\v
          scroll_y_( _this_ ) =- ( _this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min )
        Else
          scroll_y_( _this_ ) = 0
        EndIf
      EndIf
    EndMacro
    
    
    ;-
    Macro set_align_( _address_, _left_, _top_, _right_, _bottom_, _center_ )
      _address_\align\anchor\left = _left_
      _address_\align\anchor\right = _right_
      
      _address_\align\anchor\top = _top_
      _address_\align\anchor\bottom = _bottom_
      
      If Not _center_ And 
         Not _address_\align\anchor\top And 
         Not _address_\align\anchor\left And
         Not _address_\align\anchor\right And 
         Not _address_\align\anchor\bottom
        
        If Not _address_\align\anchor\right
          _address_\align\anchor\left = #True 
        EndIf
        If Not _address_\align\anchor\bottom
          _address_\align\anchor\top = #True
        EndIf
      EndIf
    EndMacro
    
    Macro set_align_x_( _this_, _address_, _width_, _rotate_ )
      If _rotate_ = 180
        If _this_\align\anchor\right
          _address_\x = _width_                          - _this_\padding\x
        ElseIf Not _this_\align\anchor\left
          _address_\x = ( _width_ + _address_\width ) / 2
        Else
          _address_\x = _address_\width                   + _this_\padding\x
        EndIf
      EndIf
      
      If _rotate_ = 0
        If _this_\align\anchor\right
          _address_\x = ( _width_ - _address_\width )       - _this_\padding\x
        ElseIf Not _this_\align\anchor\left
          _address_\x = ( _width_ - _address_\width ) / 2           
        Else
          _address_\x =                                   _this_\padding\x
        EndIf
      EndIf
    EndMacro
    
    Macro set_align_y_( _this_, _address_, _height_, _rotate_ )
      If _height_ < 0 
        If _rotate_ = 90
          _address_\y = 0 
        ElseIf _rotate_ = 180
          _address_\y = Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + _address_\height
        Else
          _address_\y =- Bool( #PB_Compiler_OS = #PB_OS_MacOS )
        EndIf
      EndIf
      
      If _height_ >= 0
        If _rotate_ = 90                  
          If _this_\align\anchor\bottom
            _address_\y = _height_                         - _this_\padding\y
          ElseIf Not _this_\align\anchor\top
            _address_\y = ( _height_ + _address_\width ) / 2
          Else
            _address_\y = _address_\width                   + _this_\padding\y
          EndIf
        EndIf
        
        If _rotate_ = 270                 
          If _this_\align\anchor\bottom
            _address_\y = ( _height_ - _address_\width )      - _this_\padding\y
          ElseIf Not _this_\align\anchor\top
            _address_\y = ( _height_ - _address_\width ) / 2
          Else
            _address_\y =                                    _this_\padding\y
          EndIf
        EndIf
      EndIf
    EndMacro
    
    Macro set_align_flag_( _this_, _parent_, _flag_ )
      If _flag_ & #__flag_autosize = #__flag_autosize And
         _parent_ And Not is_root_container_( _this_ ) And 
         _parent_\type <> #__type_Splitter 
        _this_\autosize = 1
        
        
        If _parent_
          _parent_\color\back =- 1
          ;          _this_\align\delta\width = _parent_\width[#__c_inner]
          ;          _this_\align\delta\height = _parent_\height[#__c_inner] 
          ;           _parent_\color\_alpha = 0
          ;           _parent_\color\_alpha[1] = 0
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Macro set_text_( _this_, _text_, _flag_ )
      ;     If Not _this_\text
      ;       _this_\text.allocate( TEXT )
      ;     EndIf
      
      If _this_\text
        _this_\text\change = #True
        
        _this_\text\editable = Bool( Not constants::_check_( _flag_, #__text_readonly ))
        _this_\text\lower = constants::_check_( _flag_, #__text_lowercase )
        _this_\text\upper = constants::_check_( _flag_, #__text_uppercase )
        _this_\text\pass = constants::_check_( _flag_, #__text_password )
        _this_\text\invert = constants::_check_( _flag_, #__text_invert )
        
        set_align_( _this_\text, 
                    constants::_check_( _flag_, #__text_left ),
                    constants::_check_( _flag_, #__text_top ),
                    constants::_check_( _flag_, #__text_right ),
                    constants::_check_( _flag_, #__text_bottom ),
                    constants::_check_( _flag_, #__text_center ))
        
        text_rotate_( _this_\text )
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          
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
        _this_\text\padding\x = _this_\_box_\width + 8
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
    
    Macro set_image_( _this_, _address_, _image_ )
      If IsImage( _image_ )
        _address_\change = 1
        _address_\img = _image_ 
        _address_\id = ImageID( _image_ )
        
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
          
          _address_\width = _address_\size
          _address_\height = _address_\size
        Else
          _address_\width = ImageWidth( _image_ )
          _address_\height = ImageHeight( _image_ )
        EndIf  
        ;         CompilerEndIf
        
        _address_\depth = ImageDepth( _image_, #PB_Image_OriginalDepth )
        
        If _this_\row
          _this_\row\margin\width = _address_\padding\x + 
                                    _address_\width + 2
        EndIf
      Else
        _address_\change =- 1
        _address_\img =- 1
        _address_\id = 0
        _address_\width = 0
        _address_\height = 0
      EndIf
    EndMacro
    
    Macro set_text_flag_( _this_, _flag_, _x_ = 0, _y_ = 0 )
      ;     If Not _this_\text
      ;       _this_\text.allocate( TEXT )
      ;     EndIf
      
      If _this_\text
        _this_\text\x = _x_
        _this_\text\y = _y_
        ; _this_\text\_padding = 5
        _this_\text\change = #True
        
        _this_\text\editable = Bool( Not constants::_check_( _flag_, #__text_readonly ))
        _this_\text\lower = constants::_check_( _flag_, #__text_lowercase )
        _this_\text\upper = constants::_check_( _flag_, #__text_uppercase )
        _this_\text\pass = constants::_check_( _flag_, #__text_password )
        _this_\text\invert = constants::_check_( _flag_, #__text_invert )
        
        set_align_( _this_\text, 
                    constants::_check_( _flag_, #__text_left ),
                    constants::_check_( _flag_, #__text_top ),
                    constants::_check_( _flag_, #__text_right ),
                    constants::_check_( _flag_, #__text_bottom ),
                    constants::_check_( _flag_, #__text_center ))
        
        
        If constants::_check_( _flag_, #__text_wordwrap )
          _this_\text\multiLine =- 1
        ElseIf constants::_check_( _flag_, #__text_multiline )
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0 
        EndIf
        
        text_rotate_( _this_\text )
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          
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
    
    Macro set_hide_state_( _this_ )
      ;  _this_\hide = Bool( _this_\state\hide Or _this_\_parent( )\hide Or ( _this_\_parent( )\type = #__type_Panel And SelectedTabIndex( _this_\_parent( )\TabWidget( ) ) <> _this_\TabIndex( ) ))
      _this_\hide = Bool( _this_\state\hide Or 
                          _this_\_parent( )\hide Or
                          ( _this_\_parent( )\TabWidget( ) And _this_\_parent( )\TabWidget( )\SelectedTabIndex( ) <> _this_\TabIndex( ) ))
      _this_\resize | #__resize_change
    EndMacro
    
    Macro set_check_state_( _address_, _three_state_ )
      ; change checkbox state
      Select _address_\___state
        Case #PB_Checkbox_Unchecked 
          If _three_state_
            _address_\___state= #PB_Checkbox_Inbetween
          Else
            _address_\___state= #PB_Checkbox_Checked
          EndIf
        Case #PB_Checkbox_Checked : _address_\___state= #PB_Checkbox_Unchecked
        Case #PB_Checkbox_Inbetween : _address_\___state= #PB_Checkbox_Checked
      EndSelect
    EndMacro
    
    Macro set_color_( _result_, _address_, _color_type_, _color_, _alpha_, _column_= )
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
    Procedure.i TypeFromClass( class.s )
      Protected result.i
      
      Select Trim( LCase( class.s ))
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
        Case "track"          : result = #__type_TrackBar
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
        Case #PB_EventType_free             : result.s = "#PB_EventType_Free"    
        Case #PB_EventType_drop             : result.s = "#PB_EventType_Drop"
        Case #PB_EventType_create           : result.s = "#PB_EventType_Create"
        Case #PB_EventType_SizeItem         : result.s = "#PB_EventType_SizeItem"
          
        Case #PB_EventType_repaint          : result.s = "#PB_EventType_Repaint"
        Case #PB_EventType_resizeend        : result.s = "#PB_EventType_ResizeEnd"
        Case #PB_EventType_scrollchange     : result.s = "#PB_EventType_ScrollChange"
          
        Case #PB_EventType_closewindow      : result.s = "#PB_EventType_CloseWindow"
        Case #PB_EventType_maximizewindow   : result.s = "#PB_EventType_MaximizeWindow"
        Case #PB_EventType_minimizewindow   : result.s = "#PB_EventType_MinimizeWindow"
        Case #PB_EventType_restorewindow    : result.s = "#PB_EventType_RestoreWindow"
          
        Case #PB_EventType_MouseEnter       : result.s = "#PB_EventType_MouseEnter"       ; The mouse cursor entered the gadget
        Case #PB_EventType_MouseLeave       : result.s = "#PB_EventType_MouseLeave"       ; The mouse cursor left the gadget
        Case #PB_EventType_MouseMove        : result.s = "#PB_EventType_MouseMove"        ; The mouse cursor moved
        Case #PB_EventType_MouseWheel       : result.s = "#PB_EventType_MouseWheel"       ; The mouse wheel was moved
        Case #PB_EventType_LeftButtonDown   : result.s = "#PB_EventType_LeftButtonDown"   ; The left mouse button was pressed
        Case #PB_EventType_LeftButtonUp     : result.s = "#PB_EventType_LeftButtonUp"     ; The left mouse button was released
        Case #PB_EventType_LeftClick        : result.s = "#PB_EventType_LeftClick"        ; A click With the left mouse button
        Case #PB_EventType_LeftDoubleClick  : result.s = "#PB_EventType_LeftDoubleClick"  ; A double-click With the left mouse button
        Case #PB_EventType_RightButtonDown  : result.s = "#PB_EventType_RightButtonDown"  ; The right mouse button was pressed
        Case #PB_EventType_RightButtonUp    : result.s = "#PB_EventType_RightButtonUp"    ; The right mouse button was released
        Case #PB_EventType_RightClick       : result.s = "#PB_EventType_RightClick"       ; A click With the right mouse button
        Case #PB_EventType_RightDoubleClick : result.s = "#PB_EventType_RightDoubleClick" ; A double-click With the right mouse button
        Case #PB_EventType_MiddleButtonDown : result.s = "#PB_EventType_MiddleButtonDown" ; The middle mouse button was pressed
        Case #PB_EventType_MiddleButtonUp   : result.s = "#PB_EventType_MiddleButtonUp"   ; The middle mouse button was released
        Case #PB_EventType_Focus            : result.s = "#PB_EventType_Focus"            ; The gadget gained keyboard focus
        Case #PB_EventType_LostFocus        : result.s = "#PB_EventType_LostFocus"        ; The gadget lost keyboard focus
        Case #PB_EventType_KeyDown          : result.s = "#PB_EventType_KeyDown"          ; A key was pressed
        Case #PB_EventType_KeyUp            : result.s = "#PB_EventType_KeyUp"            ; A key was released
        Case #PB_EventType_Input            : result.s = "#PB_EventType_Input"            ; Text input was generated
        Case #PB_EventType_Resize           : result.s = "#PB_EventType_Resize"           ; The gadget has been resized
        Case #PB_EventType_StatusChange     : result.s = "#PB_EventType_StatusChange"
        Case #PB_EventType_TitleChange      : result.s = "#PB_EventType_TitleChange"
        Case #PB_EventType_Change           : result.s = "#PB_EventType_Change"
        Case #PB_EventType_DragStart        : result.s = "#PB_EventType_DragStart"
        Case #PB_EventType_ReturnKey        : result.s = "#PB_EventType_returnKey"
        Case #PB_EventType_CloseItem        : result.s = "#PB_EventType_CloseItem"
          
        Case #PB_EventType_Down             : result.s = "#PB_EventType_Down"
        Case #PB_EventType_Up               : result.s = "#PB_EventType_Up"
          
        Case #PB_EventType_mousewheelX      : result.s = "#PB_EventType_MouseWheelX"
        Case #PB_EventType_mousewheelY      : result.s = "#PB_EventType_MouseWheelY"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    
    ;-
    Macro Clip( _address_, _mode_=[#__c_draw] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( draw, #PB_Module ))
        PB(ClipOutput)( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    
    Procedure  ClipPut( *this._S_widget, x, y, width, height )
      Protected clip_x, clip_y, clip_w, clip_h
      
      ; clip inner coordinate
      If *this\x[#__c_draw] < x
        clip_x = x
      Else
        clip_x = *this\x[#__c_draw]
      EndIf
      
      If *this\y[#__c_draw] < y
        clip_y = y
      Else
        clip_y = *this\y[#__c_draw]
      EndIf
      
      If *this\width[#__c_draw] > width
        clip_w = width
      Else
        clip_w = *this\width[#__c_draw]
      EndIf
      
      If *this\height[#__c_draw] > height
        clip_h = height
      Else
        clip_h = *this\height[#__c_draw]
      EndIf
      
      PB(ClipOutput)( clip_x, clip_y, clip_w, clip_h )
    EndProcedure
    
    Declare Reclip( *this._S_widget )
    
    Procedure   Reclip( *this._S_widget )
      Macro _clip_caption_( _this_ )
        ClipPut( _this_, _this_\caption\x[#__c_inner], _this_\caption\y[#__c_inner], _this_\caption\width[#__c_inner], _this_\caption\height[#__c_inner] )
        
        ;ClipPut( _this_, _this_\x[#__c_frame] + _this_\bs, _this_\y[#__c_frame] + _this_\fs, _this_\width[#__c_frame] - _this_\bs*2, _this_\fs[2] - _this_\fs*2 )
      EndMacro
      
      Macro _clip_width_( _address_, _parent_, _x_width_, _parent_ix_iwidth_, _mode_ = )
        If _parent_ And 
           (_parent_\x#_mode_ + _parent_\width#_mode_) > 0 And
           (_parent_\x#_mode_ + _parent_\width#_mode_) < (_x_width_) And 
           (_parent_ix_iwidth_) > (_parent_\x#_mode_ + _parent_\width#_mode_)  
          
          _address_\width#_mode_ = (_parent_\x#_mode_ + _parent_\width#_mode_)  - _address_\x#_mode_
        ElseIf _parent_ And (_parent_ix_iwidth_) > 0 And (_parent_ix_iwidth_) < (_x_width_)
          
          _address_\width#_mode_ = (_parent_ix_iwidth_) - _address_\x#_mode_
        Else
          _address_\width#_mode_ = (_x_width_) - _address_\x#_mode_
        EndIf
        
        If _address_\width#_mode_ < 0
          _address_\width#_mode_ = 0
        EndIf
      EndMacro
      
      Macro _clip_height_( _address_, _parent_, _y_height_, _parent_iy_iheight_, _mode_ = )
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
      Protected *parent._S_widget 
      
      If *this\attach 
        *parent = *this\attach\_parent( )
      Else
        *parent = *this\_parent( )
      EndIf
      
      If *this\_root( ) = *this
        If *this\width[#__c_draw] <> *this\width
          *this\width[#__c_draw] = *this\width
          *this\width[#__c_draw2] = *this\width
        EndIf
        If *this\height[#__c_draw] <> *this\height
          *this\height[#__c_draw] = *this\height
          *this\height[#__c_draw2] = *this\height
        EndIf
      EndIf
      
      ;       If Not *parent
      ;         ProcedureReturn 1
      ;       EndIf
      
      If *parent
        _p_x2_ = *parent\x[#__c_inner] + *parent\width[#__c_inner]
        _p_y2_ = *parent\y[#__c_inner] + *parent\height[#__c_inner]
        
        ; for the splitter childrens
        If *parent\type = #__type_Splitter
          If bar_first_gadget_( *parent ) = *this
            _p_x2_ = *parent\bar\button[1]\x + *parent\bar\button[1]\width
            _p_y2_ = *parent\bar\button[1]\y + *parent\bar\button[1]\height
          EndIf
          If bar_second_gadget_( *parent ) = *this
            _p_x2_ = *parent\bar\button[2]\x + *parent\bar\button[2]\width
            _p_y2_ = *parent\bar\button[2]\y + *parent\bar\button[2]\height
          EndIf
        EndIf
        
        If is_integral_( *this ) And Not *this\attach
          If *this\type = #__type_TabBar Or 
             *this\type = #__type_ToolBar Or 
             *this\type = #__type_ScrollBar 
            _p_x2_ = *parent\x[#__c_inner] + *parent\width[#__c_container]
            _p_y2_ = *parent\y[#__c_inner] + *parent\height[#__c_container]
          EndIf
          
          ; for the scrollarea childrens except scrollbars
        Else   
          If scroll_width_( *parent ) And
             _p_x2_ > *parent\x[#__c_inner] + scroll_x_( *parent ) + scroll_width_( *parent )
            _p_x2_ = *parent\x[#__c_inner] + scroll_x_( *parent ) + scroll_width_( *parent )
          EndIf
          If scroll_height_( *parent ) And 
             _p_y2_ > *parent\y[#__c_inner] + scroll_y_( *parent ) + scroll_height_( *parent )
            _p_y2_ = *parent\y[#__c_inner] + scroll_y_( *parent ) + scroll_height_( *parent )
          EndIf
        EndIf
      EndIf
      
      ; then move and size parent set clip coordinate
      ; x&y - clip screen coordinate  
      If *parent And                                  ;Not is_integral_( *this ) And  
         *parent\x[#__c_inner] > *this\x[#__c_screen] And
         *parent\x[#__c_inner] > *parent\x[#__c_draw]
        *this\x[#__c_draw] = *parent\x[#__c_inner]
      ElseIf *parent And *parent\x[#__c_draw] > *this\x[#__c_screen] 
        *this\x[#__c_draw] = *parent\x[#__c_draw]
      Else
        *this\x[#__c_draw] = *this\x[#__c_screen]
      EndIf
      If *parent And                                  ;Not is_integral_( *this ) And 
         *parent\y[#__c_inner] > *this\y[#__c_screen] And 
         *parent\y[#__c_inner] > *parent\y[#__c_draw]
        *this\y[#__c_draw] = *parent\y[#__c_inner]
      ElseIf *parent And *parent\y[#__c_draw] > *this\y[#__c_screen] 
        *this\y[#__c_draw] = *parent\y[#__c_draw]
      Else
        *this\y[#__c_draw] = *this\y[#__c_screen]
      EndIf
      If *this\x[#__c_draw] < 0 : *this\x[#__c_draw] = 0 : EndIf
      If *this\y[#__c_draw] < 0 : *this\y[#__c_draw] = 0 : EndIf
      
      ; x&y - clip inner coordinate
      If *this\x[#__c_draw] < *this\x[#__c_inner] 
        *this\x[#__c_draw2] = *this\x[#__c_inner] 
      Else
        *this\x[#__c_draw2] = *this\x[#__c_draw]
      EndIf
      If *this\y[#__c_draw] < *this\y[#__c_inner] 
        *this\y[#__c_draw2] = *this\y[#__c_inner] 
      Else
        *this\y[#__c_draw2] = *this\y[#__c_draw]
      EndIf
      
      ; width&height - clip coordinate
      _clip_width_( *this, *parent, *this\x[#__c_screen] + *this\width[#__c_screen], _p_x2_, [#__c_draw] )
      _clip_height_( *this, *parent, *this\y[#__c_screen] + *this\height[#__c_screen], _p_y2_, [#__c_draw] )
      
      ; width&height - clip inner coordinate
      If *parent
        If scroll_width_( *this ) And scroll_width_( *this ) < *this\width[#__c_inner]  
          _clip_width_( *this, *parent, *this\x[#__c_inner] + scroll_width_( *this ), _p_x2_, [#__c_draw2] )
        Else
          _clip_width_( *this, *parent, *this\x[#__c_inner] + *this\width[#__c_inner], _p_x2_, [#__c_draw2] )
        EndIf
        If scroll_height_( *this ) And scroll_height_( *this ) < *this\height[#__c_inner]
          _clip_height_( *this, *parent, *this\y[#__c_inner] + scroll_height_( *this ), _p_y2_, [#__c_draw2] )
        Else
          _clip_height_( *this, *parent, *this\y[#__c_inner] + *this\height[#__c_inner], _p_y2_, [#__c_draw2] )
        EndIf
      EndIf
      
      ;       
      ; clip child bar
      If *this\TabWidget( ) 
        *this\TabWidget( )\x[#__c_draw] = *this\x[#__c_draw]
        *this\TabWidget( )\y[#__c_draw] = *this\y[#__c_draw]
        *this\TabWidget( )\width[#__c_draw] = *this\width[#__c_draw]
        *this\TabWidget( )\height[#__c_draw] = *this\height[#__c_draw]
      EndIf
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\x[#__c_draw] = *this\x[#__c_draw]
          *this\scroll\v\y[#__c_draw] = *this\y[#__c_draw]
          *this\scroll\v\width[#__c_draw] = *this\width[#__c_draw]
          *this\scroll\v\height[#__c_draw] = *this\height[#__c_draw]
        EndIf
        If *this\scroll\h
          *this\scroll\h\x[#__c_draw] = *this\x[#__c_draw]
          *this\scroll\h\y[#__c_draw] = *this\y[#__c_draw]
          *this\scroll\h\width[#__c_draw] = *this\width[#__c_draw]
          *this\scroll\h\height[#__c_draw] = *this\height[#__c_draw]
        EndIf
      EndIf
      
      ProcedureReturn Bool( *this\width[#__c_draw] > 0 And *this\height[#__c_draw] > 0 )
    EndProcedure
    
    Procedure.b Resize( *this._S_widget, x.l,y.l,width.l,height.l )
      Protected.b result
      Protected.l ix,iy,iwidth,iheight,  Change_x, Change_y, Change_width, Change_height
      ; Debug " resize - "+*this\class
      
      ;       If *this\resize & #__resize_start = #False
      ;         *this\resize | #__resize_start
      ;         Debug "resize - start "+*this\class
      ;       EndIf
      ; 
      If *this\_a_\transform And a_transform( )
        If *this\bs < *this\fs + a_pos( *this )
          *this\bs = *this\fs + a_pos( *this )
        EndIf
      Else
        If *this\bs < *this\fs 
          *this\bs = *this\fs 
        EndIf
      EndIf
      
      If *this\type <> #__type_spin 
        If *this\fs[1] <> *this\barWidth 
          *this\fs[1] = *this\barWidth
        EndIf
        
        If *this\fs[2] <> *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
          *this\fs[2] = *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
        EndIf
      EndIf
      
      ;
      If is_root_container_( *this ) ;??????
        ResizeWindow( *this\_root( )\canvas\window, #PB_Ignore,#PB_Ignore,width,height )
        PB(ResizeGadget)( *this\_root( )\canvas\gadget, #PB_Ignore,#PB_Ignore,width,height )
        
        x = ( *this\bs*2 - *this\fs*2 )
        y = ( *this\bs*2 - *this\fs*2 )
        width - ( *this\bs*2 - *this\fs*2 )*2
        height - ( *this\bs*2 - *this\fs*2 )*2
        
        *this\x[#__c_frame] = #PB_Ignore
        *this\y[#__c_frame] = #PB_Ignore
        ;           *this\width[#__c_frame] = #PB_Ignore
        ;           *this\height[#__c_frame] = #PB_Ignore
      ElseIf *this\autosize
        If *this\_parent( )
          x = *this\_parent( )\x[#__c_inner]
          Y = *this\_parent( )\y[#__c_inner]
          width = *this\_parent( )\width[#__c_inner] 
          height = *this\_parent( )\height[#__c_inner] 
        EndIf
        
      Else
        If a_transform( ) And 
           a_transform( )\grid\size > 1 And
           *this = a_focus_widget( ) And 
           *this <> a_transform( )\main 
          
          If x <> #PB_Ignore 
            x + ( x%a_transform( )\grid\size ) 
            x = ( x/a_transform( )\grid\size ) * a_transform( )\grid\size
          EndIf
          
          If y <> #PB_Ignore 
            y + ( y%a_transform( )\grid\size ) 
            y = ( y/a_transform( )\grid\size ) * a_transform( )\grid\size
          EndIf
          
          If width <> #PB_Ignore 
            width + ( width%a_transform( )\grid\size ) 
            width = ( width/a_transform( )\grid\size ) * a_transform( )\grid\size + 1 
          EndIf
          
          If height <> #PB_Ignore
            height + ( height%a_transform( )\grid\size ) 
            height = ( height/a_transform( )\grid\size ) * a_transform( )\grid\size + 1 
          EndIf
        EndIf
        
        ;
        If x = #PB_Ignore 
          x = *this\x[#__c_container]
        Else
          If *this\_parent( ) 
            If Not is_integral_( *this )
              x + scroll_x_( *this\_parent( ) ) 
            EndIf 
            *this\x[#__c_container] = x
          EndIf 
        EndIf  
        If y = #PB_Ignore 
          y = *this\y[#__c_container] 
        Else
          If *this\_parent( ) 
            If Not is_integral_( *this )
              y + scroll_y_( *this\_parent( ) ) 
            EndIf 
            *this\y[#__c_container] = y
          EndIf 
        EndIf  
        
        ;
        If width = #PB_Ignore 
          If *this\type = #__type_window 
            width = *this\width[#__c_container]
          Else
            width = *this\width[#__c_frame] 
          EndIf
        EndIf  
        If height = #PB_Ignore 
          If *this\type = #__type_window 
            height = *this\height[#__c_container] 
          Else
            height = *this\height[#__c_frame]
          EndIf
        EndIf
        
        ;
        If width < 0 
          width = 0 
        EndIf
        If Height < 0 
          Height = 0 
        EndIf
        
        ;
        If *this\_parent( ) And *this <> *this\_parent( )                       
          If Not ( *this\attach And *this\attach\mode = 2 )
            x + *this\_parent( )\x[#__c_inner]
          EndIf
          If Not ( *this\attach And *this\attach\mode = 1 )
            y + *this\_parent( )\y[#__c_inner]
          EndIf
          
          ; потому что точки внутри контейнера перемешаем надо перемести и детей
          If *this\_a_\transform And
             (*this\_parent( )\container > 0 And 
              *this\_parent( )\type <> #__type_MDI)
            y - *this\_parent( )\fs
            x - *this\_parent( )\fs
          EndIf
        EndIf
        
        ; потому что окну задаются внутренные размеры
        If *this\type = #__type_window 
          width + *this\fs*2 + ( *this\fs[1] + *this\fs[3] )
          Height + *this\fs*2 + ( *this\fs[2] + *this\fs[4] )
        EndIf
      EndIf
      
      ; inner x&y position
      ix = ( x + *this\fs + *this\fs[1] )
      iy = ( y + *this\fs + *this\fs[2] )
      iwidth = width - *this\fs*2 - ( *this\fs[1] + *this\fs[3] )
      iheight = height - *this\fs*2 - ( *this\fs[2] + *this\fs[4] )
      
      ; 
      If *this\x[#__c_frame] <> x : Change_x = x - *this\x[#__c_frame] : EndIf
      If *this\y[#__c_frame] <> y : Change_y = y - *this\y[#__c_frame] : EndIf 
      If *this\x[#__c_inner] <> ix : Change_x = ix - *this\x[#__c_inner] : EndIf
      If *this\y[#__c_inner] <> iy : Change_y = iy - *this\y[#__c_inner] : EndIf 
      If *this\width[#__c_frame] <> width : Change_width = width - *this\width[#__c_frame] : EndIf 
      If *this\height[#__c_frame] <> height : Change_height = height - *this\height[#__c_frame] : EndIf 
      If *this\width[#__c_container] <> iwidth : Change_width = iwidth - *this\width[#__c_container] : EndIf 
      If *this\height[#__c_container] <> iheight : Change_height = iheight - *this\height[#__c_container] : EndIf 
      
      ;
      If Change_x
        *this\resize | #__resize_x | #__resize_change
        
        *this\x[#__c_frame] = x 
        *this\x[#__c_inner] = ix 
        *this\x[#__c_screen] = x - ( *this\bs - *this\fs ) 
        If *this\_window( )
          *this\x[#__c_window] = x - *this\_window( )\x[#__c_inner]
        EndIf
      EndIf 
      If Change_y
        *this\resize | #__resize_y | #__resize_change
        
        *this\y[#__c_frame] = y 
        *this\y[#__c_inner] = iy
        *this\y[#__c_screen] = y - ( *this\bs - *this\fs )
        If *this\_window( )
          *this\y[#__c_window] = y - *this\_window( )\y[#__c_inner]
        EndIf
      EndIf
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
      
      If ( Change_x Or Change_y Or Change_width Or Change_height )
        *this\state\repaint = #True
        
        If *this\_root( )\canvas\ResizeBeginWidget = #Null
          ;Debug "  start - resize"
          *this\_root( )\canvas\ResizeBeginWidget = *this
          Post( *this, #PB_EventType_ResizeBegin )
        EndIf
        
        If *this\_a_ And *this\_a_\id And *this\_a_\transform
          a_move( *this\_a_\id, 
                  *this\x[#__c_screen],
                  *this\y[#__c_screen], 
                  *this\width[#__c_screen], 
                  *this\height[#__c_screen], *this\container )
        EndIf
        
        If *this\_a_\transform Or *this\container 
          Post( *this, #PB_EventType_Resize )
        EndIf
      EndIf
      
      If ( Change_width Or Change_height )
        If *this\type = #__type_Image Or
           *this\type = #__type_ButtonImage
          *this\image\change = 1
        EndIf
        
        If *this\count\items
          If Change_height 
            If scroll_height_( *this ) >= *this\height[#__c_inner]
              *this\change = 1
            EndIf
          EndIf
          
          If Change_width 
            If scroll_width_( *this ) >= *this\width[#__c_inner] 
              If *this\type <> #__type_Tree
                *this\change | #__resize_width
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; if the integral scroll bars 
        ; resize vertical&horizontal scrollbars
        If *this\scroll And *this\scroll\v And *this\scroll\h
          bar_Resizes( *this, 0, 0, *this\width[#__c_container], *this\height[#__c_container] )
          
          ; update inner coordinate
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
      EndIf
      
      ; parent mdi
      If *this\_parent( ) And 
         is_integral_( *this ) And 
         *this\_parent( )\type = #__type_MDI And 
         *this\_parent( )\scroll And
         *this\_parent( )\scroll\v <> *this And 
         *this\_parent( )\scroll\h <> *this And
         *this\_parent( )\scroll\v\bar\page\change = 0 And
         *this\_parent( )\scroll\h\bar\page\change = 0
        
        mdi_bar_update_( *this\_parent( ), *this\x[#__c_container], *this\y[#__c_container], *this\width[#__c_frame], *this\height[#__c_frame] )
      EndIf
      
      ;
      ; ---------------------------------
      ;
      If *this\type = #__type_Spin Or
         ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_Splitter
        
        If ( Change_width Or Change_height )
          *this\ChangeTabIndex( ) =- 1
        EndIf
        
        bar_Update( *this\bar, Bool( Change_width Or Change_height ) )
      EndIf
      
      If *this\type = #__type_Window
        result = Update( *this )
      EndIf
      
      
      ;         ; if the widgets is composite
      ;         If *this\type = #__type_Spin
      ;         ;  *this\width[#__c_inner] = *this\width[#__c_container] - *this\bs*2 - BB3( )\size
      ;         EndIf
      
      ; if the integral tab bar 
      If *this\TabWidget( ) And is_integral_( *this\TabWidget( ) )
        *this\x[#__c_inner] - *this\fs - *this\fs[1]
        *this\y[#__c_inner] - *this\fs - *this\fs[2] 
        
        If *this\type = #__type_Panel
          If *this\TabWidget( )\vertical
            Resize( *this\TabWidget( ), *this\fs+*this\fs[1]-*this\barHeight, *this\fs, *this\barHeight, *this\height[#__c_inner] )
          Else
            Resize( *this\TabWidget( ), *this\fs, *this\fs+*this\fs[2]-*this\barHeight, *this\width[#__c_inner], *this\barHeight)
          EndIf
        EndIf
        If *this\type = #__type_window
          Resize( *this\TabWidget( ), *this\fs, *this\fs+*this\fs[2]-*this\ToolBarHeight , *this\width[#__c_frame], *this\ToolBarHeight )
        EndIf
        
        *this\x[#__c_inner] + *this\fs + ( *this\fs[1] + *this\fs[3] )
        *this\y[#__c_inner] + *this\fs + ( *this\fs[2] + *this\fs[4] )
      EndIf
      
      ;- resize childrens
      ; then move and size parent resize all childrens
      If *this\count\childrens And *this\container
        Protected x2,y2,pw,ph, pwd,phd, delta_width, delta_height, frame = #__c_frame
        
        If StartEnumerate( *this ) 
          If Not is_scrollbars_( enumWidget( ))
            If enumWidget( )\align
              x2 = enumWidget( )\align\indent\right 
              y2 = enumWidget( )\align\indent\bottom
              
              
              If enumWidget( )\_parent( )\align
                If enumWidget( )\_parent( )\type = #__type_window
                  frame = #__c_inner
                Else
                  frame = #__c_frame
                EndIf
                ;Debug ""+  enumWidget( )\_parent( )\align\width +" "+ enumWidget( )\_parent( )\align\indent\right +" "+ enumWidget( )\_parent( )\align\indent\left
                ;delta_width = enumWidget( )\_parent( )\align\width  
                ;delta_height = enumWidget( )\_parent( )\align\height
                delta_width = enumWidget( )\_parent( )\align\indent\right - enumWidget( )\_parent( )\align\indent\left ; - enumWidget( )\_parent( )\fs
                delta_height = enumWidget( )\_parent( )\align\indent\bottom - enumWidget( )\_parent( )\align\indent\top; - enumWidget( )\_parent( )\fs*2 
                pw = ( enumWidget( )\_parent( )\width[frame] - delta_width )
                ph = ( enumWidget( )\_parent( )\height[frame] - delta_height )
                pwd = pw/2 
                phd = ph/2 
              EndIf
              
              ; horizontal
              If enumWidget( )\align\anchor\right > 0
                x = enumWidget( )\align\indent\left  
                If enumWidget( )\align\anchor\left = 0
                  x + pw 
                EndIf
                width = x2 + pw
              Else
                If enumWidget( )\align\anchor\left > 0
                  ; 1
                  x = enumWidget( )\align\indent\left  
                  width = x2
                Else
                  If enumWidget( )\align\anchor\right < 0
                    If enumWidget( )\align\anchor\left < 0
                      ; 6
                      x = enumWidget( )\align\indent\left * enumWidget( )\_parent( )\width[frame] / delta_width
                      width = x2 * enumWidget( )\_parent( )\width[frame] / delta_width
                    Else
                      ; 5
                      x = enumWidget( )\align\indent\left + pwd
                      width = x2 + pw 
                    EndIf
                  Else
                    x = enumWidget( )\align\indent\left   
                    If enumWidget( )\align\anchor\left = 0
                      x + pwd
                    EndIf
                    width = x2 + pwd
                  EndIf
                EndIf
              EndIf
              
              ; vertical
              If enumWidget( )\align\anchor\bottom > 0
                y = enumWidget( )\align\indent\top  
                If enumWidget( )\align\anchor\top = 0
                  y + ph
                EndIf
                height = y2 + ph
              Else
                If enumWidget( )\align\anchor\top > 0
                  ; 1
                  y = enumWidget( )\align\indent\top  
                  height = y2
                Else
                  If enumWidget( )\align\anchor\bottom < 0
                    If enumWidget( )\align\anchor\top < 0
                      ; 6
                      y = enumWidget( )\align\indent\top * enumWidget( )\_parent( )\height[frame] / delta_height
                      height = y2 * enumWidget( )\_parent( )\height[frame] / delta_height
                    Else
                      ; 5
                      y = enumWidget( )\align\indent\top + phd 
                      height = y2 + ph
                    EndIf
                  Else
                    y = enumWidget( )\align\indent\top 
                    If enumWidget( )\align\anchor\top = 0
                      y + phd 
                    EndIf
                    height = y2 + phd
                  EndIf
                EndIf
              EndIf
              
              Resize( enumWidget( ), x, y, width - x, height - y )
            Else
              If (Change_x Or Change_y)
                Resize( enumWidget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
              Else
                If enumWidget( )\autosize
                  Resize( enumWidget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                Else
                  enumWidget( )\resize | #__resize_change
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;Next
          StopEnumerate( )
        EndIf
      EndIf
      
      ; 
      ProcedureReturn *this\state\repaint
    EndProcedure
    
    ;-
    Procedure   HideChildrens( *this._S_widget )
      If *this\address
        PushListPosition(  *this\_widgets( ) )
        ChangeCurrentElement(  *this\_widgets( ), *this\address )
        While NextElement(  *this\_widgets( ) )
          If  *this\_widgets( ) = *this\after\widget 
            Break
          EndIf
          
          ; hide all children except those whose parent-item is selected
          set_hide_state_(  *this\_widgets( ) )
        Wend
        PopListPosition(  *this\_widgets( ) )
      EndIf
    EndProcedure
    
    
    
    ;-
    ;-  BARs
    Declare.l update_visible_items_( *this._S_widget, visible_items_height.l = 0 )
    Declare   Editor_Update( *this._S_widget, List row._S_rows( ))
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
    
    
    
    ;{
    Macro bar_in_stop_( _bar_ ) 
      Bool( _bar_\thumb\pos >= _bar_\area\end )
    EndMacro
    
    Macro bar_in_start_( _bar_ ) 
      Bool( _bar_\thumb\pos <= _bar_\area\pos )
    EndMacro
    
    Macro bar_page_pos_( _bar_, _thumb_pos_ )
      ( _bar_\min + Round((( _thumb_pos_ ) - _bar_\area\pos ) / _bar_\percent, #PB_Round_Nearest ))
    EndMacro
    
    Macro bar_thumb_pos_( _bar_, _scroll_pos_ )
      Round((( _scroll_pos_ ) - _bar_\min - _bar_\min[1] ) * _bar_\percent, #PB_Round_Nearest ) 
    EndMacro
    
    Macro bar_scroll_pos_( _this_, _pos_, _len_ )
      Bool( Bool(((( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) < 0 And bar_SetState( _this_\bar, (( _pos_ ) + _this_\bar\min ) )) Or
            Bool(( (( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) > ( _this_\bar\page\len - ( _len_ )) And bar_SetState( _this_\bar, (( _pos_ ) + _this_\bar\min ) - ( _this_\bar\page\len - ( _len_ ) ))) )
    EndMacro
    
    Macro bar_invert_page_pos_( _bar_, _scroll_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min )) + Bool( Not _bar_\invert ) * ( _scroll_pos_ ))
    EndMacro
    
    Macro bar_invert_thumb_pos_( _bar_, _thumb_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\area\end - _thumb_pos_ ) +
        Bool( Not _bar_\invert ) * ( _bar_\area\pos + _thumb_pos_ ))
    EndMacro
    
    ;-
    Macro bar_area_( _parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True )
      _parent_\scroll\v = Create( _parent_, _parent_\class+"-"+_parent_\index+"-vertical", #__type_ScrollBar, 0,0,#__scroll_buttonsize,0, #Null$, #__flag_child | #__bar_vertical,  0,_area_height_,_height_, #__scroll_buttonsize, 7, _scroll_step_ )
      _parent_\scroll\h = Create( _parent_, _parent_\class+"-"+_parent_\index+"-horizontal", #__type_ScrollBar, 0,0,0,#__scroll_buttonsize, #Null$, #__flag_child,  0,_area_width_,_width_, Bool( _mode_ )*#__scroll_buttonsize, 7, _scroll_step_ )
    EndMacro                                                  
    
    Macro bar_area_draw_( _this_ )
      If _this_\scroll
        ;Clip( _this_, [#__c_draw] )
        
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And
           ( _this_\scroll\v\width[#__c_draw] > 0 And _this_\scroll\v\height[#__c_draw] > 0 )
          bar_draw( _this_\scroll\v )
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And 
           ( _this_\scroll\h\width[#__c_draw] > 0 And _this_\scroll\h\height[#__c_draw] > 0 )
          bar_draw( _this_\scroll\h )
        EndIf
        
        If #__draw_scroll_box 
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          ; Scroll area coordinate
          draw_box_( _this_\x[#__c_inner] + scroll_x_( _this_ ) + _this_\text\padding\x, _this_\y[#__c_inner] + scroll_y_( _this_ ) + _this_\text\padding\y, scroll_width_( _this_ ) - _this_\text\padding\x*2, scroll_height_( _this_ ) - _this_\text\padding\y*2, $FFFF0000 )
          draw_box_( _this_\x[#__c_inner] + scroll_x_( _this_ ), _this_\y[#__c_inner] + scroll_y_( _this_ ), scroll_width_( _this_ ), scroll_height_( _this_ ), $FF0000FF )
          
          If _this_\scroll\v And _this_\scroll\h
            draw_box_( _this_\scroll\h\x[#__c_frame] + scroll_x_( _this_ ), _this_\scroll\v\y[#__c_frame] + scroll_y_( _this_ ), scroll_width_( _this_ ), scroll_height_( _this_ ), $FF0000FF )
            
            ; Debug "" +  scroll_x_( _this_ )  + " " +  scroll_y_( _this_ )  + " " +  scroll_width_( _this_ )  + " " +  scroll_height_( _this_ )
            ;draw_box_( _this_\scroll\h\x[#__c_frame] - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y[#__c_frame] - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF )
            
            ; page coordinate
            draw_box_( _this_\scroll\h\x[#__c_frame], _this_\scroll\v\y[#__c_frame], _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00 )
          EndIf
        EndIf
      EndIf
    EndMacro
    
    ;-
    Procedure.i bar_tab_SetState( *this._S_widget, State.l )
      Protected result.b
      
      ; prevent selection of a non-existent tab
      If State < 0 
        State =- 1 
      EndIf
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If *this\SelectedTabIndex( ) <> State 
        *this\SelectedTabIndex( ) = State
        *this\ChangeTabIndex( ) = #True
        ;;Debug " - - - "
        
        If is_integral_( *this ) 
          
          ; enumerate all parent childrens         
          If *this\_parent( )\count\childrens
            HideChildrens( *this\_parent( ) )
          EndIf
          ;           
          ;           DoEvents( *this\_parent( ), #PB_EventType_Change, State, *this\FocusedTab( ) )
          ;         Else
          ;           DoEvents( *this, #PB_EventType_Change, State, *this\FocusedTab( ) )
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   bar_tab_AddItem( *this._S_widget, Item.i, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected result
      
      With *this
        ; 
        *this\ChangeTabIndex( ) = #True
        
        If ( Item =- 1 Or Item > ListSize( *this\_tabs( )) - 1 )
          LastElement( *this\_tabs( ))
          AddElement( *this\_tabs( )) 
          Item = ListIndex( *this\_tabs( ))
        Else
          If SelectElement( *this\_tabs( ), Item )
            If *this\SelectedTabIndex( ) >= Item
              *this\SelectedTabIndex( ) + 1
            EndIf
            
            If *this = *this\_parent( )\TabWidget( )
              If StartEnumerate( *this\_parent( ) )
                If enumWidget( )\_parent( ) = *this\_parent( ) And
                   enumWidget( )\TabIndex( ) = Item
                  enumWidget( )\TabIndex( ) + 1
                EndIf
                
                set_hide_state_( enumWidget( ) )
                StopEnumerate( )
              EndIf
            EndIf
            
            InsertElement( *this\_tabs( ))
            
            PushListPosition( *this\_tabs( ))
            While NextElement( *this\_tabs( ))
              *this\_tabs( )\index = ListIndex( *this\_tabs( ))
            Wend
            PopListPosition( *this\_tabs( ))
          EndIf
        EndIf
        
        ; TabBar last opened item 
        *this\OpenedTabIndex( ) = Item
        
        ;
        *this\bar\_s.allocate( TABS, ( ))
        *this\_tabs( )\color = _get_colors_( )
        *this\_tabs( )\height = *this\height - 1
        *this\_tabs( )\text\string = Text.s
        *this\_tabs( )\index = item
        
        ; set default selected tab
        If item = 0 
          *this\SelectedTabIndex( ) = 0
          PushListPosition( *this\_tabs( ) )
          *this\FocusedTab( ) = FirstElement( *this\_tabs( ) )
          PopListPosition( *this\_tabs( ) )
        EndIf
        
        If is_integral_( *this ) 
          *this\_parent( )\count\items + 1 
        EndIf
        *this\count\items + 1 
        
        set_image_( *this, *this\_tabs( )\Image, Image )
        PostCanvasRepaint( *this\_root( ) )
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i bar_tab_removeItem( *this._S_widget, Item.l )
      If SelectElement( *this\_tabs( ), item )
        *this\ChangeTabIndex( ) = #True
        
        If *this\SelectedTabIndex( ) = *this\_tabs( )\index
          *this\SelectedTabIndex( ) = item - 1
        EndIf
        
        DeleteElement( *this\_tabs( ), 1 )
        
        If *this\_parent( )\TabWidget( ) = *this
          Post( *this\_parent( ), #PB_EventType_CloseItem, Item )
          *this\_parent( )\count\items - 1
        Else
          Post( *this, #PB_EventType_CloseItem, Item )
        EndIf
        
        *this\count\items - 1
      EndIf
    EndProcedure
    
    Procedure   bar_tab_clearItems( *this._S_widget ) ; Ok
      If *this\count\items <> 0
        
        *this\ChangeTabIndex( ) = #True
        ClearList( *this\_tabs( ))
        
        If *this\_parent( )\TabWidget( ) = *this
          Post( *this\_parent( ), #PB_EventType_CloseItem, #PB_All )
          *this\_parent( )\count\items = 0
        Else
          Post( *this, #PB_EventType_CloseItem, #PB_All )
        EndIf
        
        *this\count\items = 0
      EndIf
    EndProcedure
    
    Procedure.s bar_tab_GetItemText( *this._S_widget, Item.l, Column.l = 0 )
      Protected result.s
      
      If is_item_( *this, Item ) And 
         SelectElement( *this\_tabs( ), Item ) 
        result = *this\_tabs( )\text\string
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Macro bar_tab_item_draw_( _vertical_, _address_,_x_, _y_, _fore_color_, _back_color_, _frame_color_, _text_color_, _round_)
      ;Draw back
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
      draw_gradient_box_( _vertical_,_x_ + _address_\x,_y_ + _address_\y, _address_\width, _address_\height, _fore_color_, _back_color_, _round_, _address_\color\_alpha )
      ; Draw frame
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      draw_roundbox_( _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _round_, _round_, _frame_color_&$FFFFFF | _address_\color\_alpha<<24 )
      ; Draw items image
      If _address_\image\id
        drawing_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawAlphaImage( _address_\image\id, _x_ + _address_\image\x, _y_ + _address_\image\y, _address_\color\_alpha )
      EndIf
      ; Draw items text
      If _address_\text\string
        drawing_mode_( #PB_2DDrawing_Transparent )
        DrawText( _x_ + _address_\text\x, _y_ + _address_\text\y, _address_\text\string, _text_color_&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro bar_item_draw_( _this_, _item_, x, y, _round_, _mode_= )
      ;_draw_font_item_( _this_, _item_, 0 )
      
      bar_tab_item_draw_( _this_\vertical, _item_, x, y,
                          _item_\color\fore#_mode_,
                          _item_\color\back#_mode_,
                          _item_\color\frame#_mode_, 
                          _item_\color\front#_mode_, _round_ )
    EndMacro
    
    Procedure.b bar_tab_draw( *this._S_widget )
      With *this
        Protected Color
        Protected ActivColorPlus = $FF101010
        Protected HoverColorPlus = $FF101010
        Protected forecolor
        Protected backcolor
        Protected textcolor = $ff000000
        Protected framecolor = $FF808080;&$FFFFFF | *this\_tabs( )\color\_alpha<<24
        Protected Item_Color_Background
        Protected widget_backcolor1 = $FFD0D0D0
        Protected widget_backcolor = $FFD0D0D0;$FFEEEEEE ; $FFE6E5E5;
        
        Protected typ = 0
        Protected pos = 1
        If *this\_parent( ) And *this\_parent( )\type = #__Type_Panel
          pos = 2
        EndIf
        
        pos + Bool(typ)*2
        
        Protected layout = pos*2
        Protected text_pos = 6
        
        If Not \hide And \color\_alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back&$FFFFFF | \color\_alpha<<24 )
          EndIf
          
          ;- widget::bar_tab_update_( )
          If *this\ChangeTabIndex( )
            *this\image\x = ( *this\height - 16 - pos - 1 ) / 2
            Debug " --- widget::Tab_Update( ) - "+*this\image\x
            
            If *this\vertical
              *this\text\y = text_pos
            Else
              *this\text\x = text_pos
            EndIf
            
            *this\bar\max = 0
            ; *this\text\width = *this\width
            
            ForEach *this\_tabs( )
              ; if not visible then skip
              If *this\_tabs( )\hide
                Continue
              EndIf
              
              ; 
              draw_font_item_( *this, *this\_tabs( ), *this\_tabs( )\change )
              
              ; init items position
              If *this\vertical
                *this\_tabs( )\y = *this\bar\max + pos 
                
                If *this\SelectedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\x = 0
                  *this\_tabs( )\width = BB3( )\width + 1
                Else
                  *this\_tabs( )\x = 0
                  *this\_tabs( )\width = BB3( )\width - 1
                EndIf
                
                *this\text\x = ( *this\_tabs( )\width - *this\_tabs( )\text\width )/2 ; - Bool(*this\SelectedTabIndex( ) <> *this\_tabs( )\index And typ)*2
                
                *this\_tabs( )\text\y = *this\text\y + *this\_tabs( )\y
                *this\_tabs( )\text\x = *this\text\x + *this\_tabs( )\x
                *this\_tabs( )\height = *this\text\y*2 + *this\_tabs( )\text\height
                
                *this\bar\max + *this\_tabs( )\height + Bool( *this\_tabs( )\index <> *this\count\items - 1 ) - Bool(typ)*2 +  Bool( *this\_tabs( )\index = *this\count\items - 1 ) * layout 
                ;
                If typ And *this\SelectedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\height + 4
                  *this\_tabs( )\y - 2
                EndIf
              Else
                *this\_tabs( )\x = *this\bar\max + pos 
                
                If *this\SelectedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\y = pos;pos - Bool( pos>0 )*2
                  *this\_tabs( )\height = BB3( )\height - *this\_tabs( )\y + 1
                Else
                  *this\_tabs( )\y = pos;pos
                  *this\_tabs( )\height = BB3( )\height - *this\_tabs( )\y - 1
                EndIf
                
                *this\text\y = ( *this\_tabs( )\height - *this\_tabs( )\text\height )/2 
                ;
                *this\_tabs( )\image\y = *this\_tabs( )\y + ( *this\_tabs( )\height - *this\_tabs( )\image\height )/2 
                *this\_tabs( )\text\y = *this\_tabs( )\y + *this\text\y
                
                ;
                *this\_tabs( )\image\x = *this\_tabs( )\x + Bool( *this\_tabs( )\image\width ) * *this\image\x ;+ Bool( *this\_tabs( )\text\width ) * ( *this\text\x ) 
                *this\_tabs( )\text\x = *this\_tabs( )\image\x + *this\_tabs( )\image\width + *this\text\x
                *this\_tabs( )\width = Bool( *this\_tabs( )\text\width ) * ( *this\text\x*2 ) + *this\_tabs( )\text\width +
                                       Bool( *this\_tabs( )\image\width ) * ( *this\image\x*2 ) + *this\_tabs( )\image\width - ( Bool( *this\_tabs( )\image\width And *this\_tabs( )\text\width ) * ( *this\text\x ))
                
                *this\bar\max + *this\_tabs( )\width + Bool( *this\_tabs( )\index <> *this\count\items - 1 ) - Bool(typ)*2 + Bool( *this\_tabs( )\index = *this\count\items - 1 ) * layout 
                ;                                                                                                           
                If typ And *this\SelectedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\width + 4
                  *this\_tabs( )\x - 2
                EndIf
              EndIf
              
              ; then set tab state
              If *this\_tabs( )\index = *this\SelectedTabIndex( ) 
                
                If *this\FocusedTab( ) <> *this\_tabs( ) 
                  If *this\FocusedTab( )
                    *this\FocusedTab( )\state\focus = #False
                  EndIf
                  
                  *this\FocusedTab( ) = *this\_tabs( )
                  *this\FocusedTab( )\state\focus = #True
                  
                  ; scroll to active tab
                  If *this\FocusedTab( )\state\enter = #False 
                    Protected tab_scroll = #True
                  EndIf
                EndIf
              EndIf
            Next
            
            ;
            bar_Update( *this\bar, 2 )
            If tab_scroll And *this\FocusedTab( )
              Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
              
              Protected ThumbPos = *this\bar\max - ( *this\FocusedTab( )\x + *this\FocusedTab( )\width ) - 3 ; to right
              ThumbPos = *this\bar\max - ( *this\FocusedTab( )\x + *this\FocusedTab( )\width ) - ( *this\bar\thumb\end - *this\FocusedTab( )\width ) / 2 - 3   ; to center
              Protected ScrollPos = bar_page_pos_( *this\bar, ThumbPos )
              ScrollPos = bar_invert_page_pos_( *this\bar, ScrollPos )
              *this\bar\page\pos = ScrollPos
            EndIf
            bar_Update( *this\bar, 0 )
            
            *this\ChangeTabIndex( ) = #False
          EndIf
          
          ;
          ; drawin
          ; 
          If *this\vertical 
            BB2( )\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- BB2( )\size )/2            
            BB1( )\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- BB1( )\size )/2              
          Else 
            BB2( )\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- BB2( )\size )/2           
            BB1( )\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- BB1( )\size )/2            
          EndIf
          
          
          Protected State_3, Color_frame
          Protected x = BB3( )\x
          Protected y = BB3( )\y
          
          
          
          ;           drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;                 color = *this\_parent( )\color\frame[0]
          ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_frame], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs-1, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
          
          ; draw all visible items
          ForEach *this\_tabs( )
            draw_font_item_( *this, *this\_tabs( ), 0 )
            
            ; real visible items
            If *this\vertical
              *this\_tabs( )\visible = Bool( Not *this\_tabs( )\hide And 
                                             (( y + *this\_tabs( )\y + *this\_tabs( )\height ) > *this\y[#__c_inner]  And 
                                              ( y + *this\_tabs( )\y ) < ( *this\y[#__c_inner] + *this\height[#__c_inner] ) ))
            Else
              *this\_tabs( )\visible = Bool( Not *this\_tabs( )\hide And 
                                             (( x + *this\_tabs( )\x + *this\_tabs( )\width ) > *this\x[#__c_inner]  And 
                                              ( x + *this\_tabs( )\x ) < ( *this\x[#__c_inner] + *this\width[#__c_inner] ) ))
            EndIf
            
            ; &~ entered &~ focused
            If *this\_tabs( )\visible And 
               ( *this\_tabs( )\state\enter = #False Or 
                 *this\_tabs( )\state\press = #True ) And
               *this\_tabs( )\state\focus = #False
              
              bar_item_draw_( *this, *this\_tabs( ), x, y, BB3( )\round, [0] )
            EndIf
          Next
          
          ; draw mouse-enter visible item
          If *this\EnteredTab( ) And 
             *this\EnteredTab( )\visible And 
             *this\EnteredTab( )\state\focus = #False
            
            draw_font_item_( *this, *this\EnteredTab( ), 0 )
            bar_item_draw_( *this, *this\EnteredTab( ), x, y, BB3( )\round, [1] )
          EndIf
          
          ; draw key-focus visible item
          If *this\FocusedTab( ) And 
             *this\FocusedTab( )\visible
            
            draw_font_item_( *this, *this\FocusedTab( ), 0 )
            bar_item_draw_( *this, *this\FocusedTab( ), x, y, BB3( )\round, [2] )
          EndIf
          
          
          
          
          color = $FF909090
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          ; draw lines
          If *this\FocusedTab( )  
            If *this\vertical
              color = *this\FocusedTab( )\color\frame[2]
              ; frame on the selected item
              If *this\FocusedTab( )\visible
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height, color )
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y, *this\FocusedTab( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height -1, *this\FocusedTab( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width -1, y + *this\FocusedTab( )\y, *this\FocusedTab( )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              ; vertical tab right line 
              If *this\FocusedTab( )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, *this\y[#__c_screen], 1, ( y + *this\FocusedTab( )\y ) - *this\x[#__c_frame], color ) ;*this\_tabs( )\color\fore[2] )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height, 1, *this\y[#__c_frame] + *this\height[#__c_frame] - ( y + *this\FocusedTab( )\y + *this\FocusedTab( )\height ), color ) ; *this\_tabs( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen]+*this\width[#__c_screen]-1, *this\y[#__c_screen], 1, *this\height[#__c_screen], color )
              EndIf
              
              If is_integral_( *this ) 
                color = *this\_parent( )\color\back[0]
                ; selected tab inner frame
                Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y +1, 1, *this\FocusedTab( )\height-2, color )
                Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y +1, BB3( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height -2, BB3( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width -1, y + *this\FocusedTab( )\y +1, BB3( )\width, 1, color )
                
                Protected size1 = 5
                ;               
                ;Arrow( *this\x[#__c_screen] + selected_tab_pos + ( *this\FocusedTab( )\width - size1 )/2, *this\y[#__c_frame]+*this\height[#__c_frame] - 5, 11, $ff000000, 1, 1)
                
                Arrow( x + *this\FocusedTab( )\x + ( *this\FocusedTab( )\width - size1 ),
                       y + *this\FocusedTab( )\y + ( *this\FocusedTab( )\height - size1 )/2, size1, 0, color, -1 )
                
                
                
                color = *this\_parent( )\color\frame[0]
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                Line( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
              EndIf
            Else
              ; frame on the selected item
              If *this\FocusedTab( )\visible
                color = *this\FocusedTab( )\color\frame[2]
                Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y, *this\FocusedTab( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height-*this\FocusedTab( )\y, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width -1, y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height-*this\FocusedTab( )\y, color )
                ;Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y + *this\FocusedTab( )\height - 1, *this\FocusedTab( )\width, 1, color )
                ;color = $ffff00ff
                ;Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y+*this\FocusedTab( )\height-1, *this\FocusedTab( )\width, 1, color )
                ;Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y+*this\FocusedTab( )\height, *this\FocusedTab( )\width, 1, color )
                ;Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y+*this\FocusedTab( )\height+1, *this\FocusedTab( )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              color = *this\_parent( )\color\frame[2]
              
              ; horizontal tab bottom line 
              If *this\FocusedTab( )
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, ( x + *this\FocusedTab( )\x ) - *this\x[#__c_frame], 1, color ) ;*this\_tabs( )\color\fore[2] )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width, *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\x[#__c_frame] + *this\width[#__c_frame] - ( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width ), 1, color ) ; *this\_tabs( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\width[#__c_screen], 1, color )
              EndIf
              
              If is_integral_( *this ) 
                color = *this\_parent( )\color\back[0] ;*this\_parent( )\color\front[2]
                                                       ; selected tab inner frame
                Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y +1, *this\FocusedTab( )\width-2, 1, color )
                Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y +1, 1, *this\FocusedTab( )\height-1, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width - 2, y + *this\FocusedTab( )\y +1, 1, *this\FocusedTab( )\height-1, color )
                ;Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height-1, *this\FocusedTab( )\width-2, 1, color )
                
                ;;drawing_mode_alpha_( #PB_2DDrawing_Default )
                color = *this\_parent( )\color\frame[0]
                ;Box( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_frame], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs+*this\_parent( )\fs[2], color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                
                ; ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs, *this\_parent( )\fs + pos, *this\_parent( )\fs, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ; ;                draw_box_( *this\_parent( )\x[#__c_frame] + *this\_parent( )\width[#__c_frame] - (*this\_parent( )\fs + pos), *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs, *this\_parent( )\fs + pos, *this\_parent( )\fs, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs[2] - 1, *this\_parent( )\fs-1, *this\_parent( )\fs[2], color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ;                draw_box_( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner]+1, *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs[2] - 1, *this\_parent( )\fs-1, *this\_parent( )\fs[2], color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ;                 
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\fs, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ;                draw_box_( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\fs, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                Line( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( *this\TabWidget( )\SelectedTabIndex( )  <>-1 )*2 ] )
                
              EndIf
            EndIf
          EndIf
          
          ; Navigation
          Protected fabe_pos, fabe_out, button_size = 20, round=0, Size = 60
          backcolor = $ffffffff;\_parent( )\_parent( )\color\back[\_parent( )\_parent( )\color\state]
          If Not backcolor
            backcolor = \_parent( )\color\back[\_parent( )\color\state]
          EndIf
          If Not backcolor
            backcolor = BB2( )\color\back[\color\state]
          EndIf
          
          
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          ResetGradientColors( )
          GradientColor( 0.0, backcolor&$FFFFFF )
          GradientColor( 0.5, backcolor&$FFFFFF | $A0<<24 )
          GradientColor( 1.0, backcolor&$FFFFFF | 245<<24 )
          
          fabe_out = Size - button_size
          ;
          If *this\vertical
            ; to top
            If Not BB2( )\hide 
              fabe_pos = \y + ( size ) - \fs
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos - fabe_out )
              draw_roundbox_( \x + \bs, fabe_pos, \width - \bs-1,  - Size, round,round )
            EndIf
            
            ; to bottom
            If Not BB1( )\hide 
              fabe_pos = \y + \height - ( size ) + \fs*2
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos + fabe_out )
              draw_roundbox_( \x + \bs, fabe_pos, \width - \bs-1 ,Size, round,round )
            EndIf
          Else
            ; to left
            If Not BB2( )\hide
              fabe_pos = \x + ( size ) - \fs
              LinearGradient( fabe_pos, \y + \bs, fabe_pos - fabe_out, \y + \bs )
              draw_roundbox_( fabe_pos, \y + \bs,  - Size, \height - \bs-1, round,round )
            EndIf
            
            ; to right
            If Not BB1( )\hide
              fabe_pos = \x + \width - ( size ) + \fs*2
              LinearGradient( fabe_pos, \y + \bs, fabe_pos + fabe_out, \y + \bs )
              draw_roundbox_( fabe_pos, \y + \bs, Size, \height - \bs-1 ,round,round )
            EndIf
          EndIf
          
          ResetGradientColors( )
          
          
          
          ; draw navigator
          ; Draw buttons back
          If Not BB2( )\hide
            ;             Color = $FF202020
            ;             ; Color = $FF101010
            ;             Item_Color_Background = TabBarGadget_ColorMinus(widget_backcolor1, Color)
            ;             ;Item_Color_Background = TabBarGadget_ColorPlus(widget_backcolor1, Color)
            ;             forecolor = TabBarGadget_ColorPlus(Item_Color_Background, Color)
            ;             ;backcolor = TabBarGadget_ColorMinus(Item_Color_Background, Color)
            ;             
            ;             If BB1( )\color\state = 3
            ;               Color = $FF303030
            ;              framecolor = TabBarGadget_ColorMinus(BB1( )\color\back[BB1( )\color\state], Color)
            ;              BB1( )\color\frame[BB1( )\color\state] = framecolor
            ;              BB1( )\color\front[BB1( )\color\state] = framecolor
            ; ;               
            ;             ElseIf BB1( )\color\state = 1
            ; ;                Color = $FF303030
            ; ;              framecolor = TabBarGadget_ColorMinus(BB1( )\color\back[BB1( )\color\state], Color)
            ; ;              framecolor = TabBarGadget_ColorMinus(framecolor, Color)
            ; ;              BB1( )\color\frame[BB1( )\color\state] = framecolor
            ; ;              BB1( )\color\front[BB1( )\color\state] = framecolor
            ;              
            ;                BB1( )\color\frame[BB1( )\color\state] = BB1( )\color\front[BB1( )\color\state];backcolor
            ;               BB1( )\color\back[BB1( )\color\state] = backcolor               
            ;             BB1( )\arrow\size = 6               
            ;                
            ;             ElseIf BB1( )\color\state = 0
            ;               BB1( )\color\frame[BB1( )\color\state] = backcolor
            ;               BB1( )\color\back[BB1( )\color\state] = backcolor               
            ;               BB1( )\arrow\size = 4               
            ;             EndIf
            
            ; Draw buttons
            If BB2( )\color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical, BB2( ), BB2( )\color\fore[BB2( )\color\state], BB2( )\color\back[BB2( )\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_roundbox_( BB2( )\x, BB2( )\y, BB2( )\width, BB2( )\height, BB2( )\round, BB2( )\round, BB2( )\color\frame[BB2( )\color\state]&$FFFFFF | BB2( )\color\_alpha<<24 )
            EndIf
          EndIf
          If Not BB1( )\hide 
            ; Draw buttons
            If BB1( )\color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical, BB1( ), BB1( )\color\fore[BB1( )\color\state], BB1( )\color\back[BB1( )\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_roundbox_( BB1( )\x, BB1( )\y, BB1( )\width, BB1( )\height, BB1( )\round, BB1( )\round, BB1( )\color\frame[BB1( )\color\state]&$FFFFFF | BB1( )\color\_alpha<<24 )
            EndIf
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          ; Draw buttons frame
          If Not BB1( )\hide 
            draw_roundbox_( BB1( )\x, BB1( )\y, BB1( )\width, BB1( )\height, BB1( )\round, BB1( )\round, BB1( )\color\frame[BB1( )\color\state]&$FFFFFF | BB1( )\color\_alpha<<24 )
            
            ; Draw arrows
            If Not BB1( )\hide And BB1( )\arrow\size
              draw_arrows_( BB1( ), Bool( \vertical ) + 2 ) 
            EndIf
          EndIf
          If Not BB2( )\hide 
            draw_roundbox_( BB2( )\x, BB2( )\y, BB2( )\width, BB2( )\height, BB2( )\round, BB2( )\round, BB2( )\color\frame[BB2( )\color\state]&$FFFFFF | BB2( )\color\_alpha<<24 )
            
            ; Draw arrows
            If BB2( )\arrow\size
              draw_arrows_( BB2( ), Bool( \vertical )) 
            EndIf
          EndIf
          
          
        EndIf
        
      EndWith 
    EndProcedure
    
    Procedure.b bar_scroll_draw( *this._S_widget )
      With *this
        
        ;         DrawImage( ImageID( UpImage ), BB1( )\x, BB1( )\y )
        ;         DrawImage( ImageID( DownImage ), BB2( )\x, BB2( )\y )
        ;         ProcedureReturn 
        
        If *this\color\_alpha
          ; Draw scroll bar background
          If *this\color\back <>- 1
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_box(*this, color\back, [#__c_frame])
          EndIf
          
          ;
          ; background buttons draw
          If Not BB1( )\hide
            If BB1( )\color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\vertical, BB1( ), BB1( )\color\fore[BB1( )\color\state], BB1( )\color\back[BB1( )\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(BB1( ), color\back)
            EndIf
          EndIf
          If Not BB2( )\hide
            If BB2( )\color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\vertical, BB2( ), BB2( )\color\fore[BB2( )\color\state], BB2( )\color\back[BB2( )\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(BB2( ), color\back)
            EndIf
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          If *this\type = #__type_ScrollBar
            If *this\vertical
              If (*this\bar\page\len + Bool(*this\round )*(*this\width/4 )) = *this\height[#__c_frame]
                Line(*this\x[#__c_frame],*this\y[#__c_frame], 1,*this\bar\page\len + 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line(*this\x[#__c_frame],*this\y[#__c_frame]+BB1( )\round, 1,*this\height-BB1( )\round-BB2( )\round,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            Else
              If (*this\bar\page\len + Bool(*this\round )*(*this\height/4 )) = *this\width[#__c_frame]
                Line(*this\x[#__c_frame],*this\y[#__c_frame],*this\bar\page\len + 1, 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line(*this\x[#__c_frame]+BB1( )\round,*this\y[#__c_frame],*this\width[#__c_frame]-BB1( )\round-BB2( )\round, 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            EndIf
          EndIf
          
          ; frame buttons draw
          If Not BB1( )\hide
            If BB1( )\arrow\size
              draw_arrows_( BB1( ), Bool(*this\vertical )) 
            EndIf
            draw_box(BB1( ), color\frame)
          EndIf
          If Not BB2( )\hide
            If BB2( )\arrow\size
              draw_arrows_( BB2( ), Bool(*this\vertical ) + 2 ) 
            EndIf
            draw_box(BB2( ), color\frame)
          EndIf
          
          
          If *this\bar\thumb\len And*this\type <> #__type_ProgressBar
            ; Draw thumb
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_(*this\vertical, BB3( ), BB3( )\color\fore[BB3( )\color\state], BB3( )\color\back[BB3( )\color\state])
            
            If BB3( )\arrow\type ;*this\type = #__type_ScrollBar
              If BB3( )\arrow\size
                drawing_mode_alpha_( #PB_2DDrawing_Default )
                ;                 Arrow(BB3( )\x + (BB3( )\width -BB3( )\arrow\size )/2, BB3( )\y + (BB3( )\height -BB3( )\arrow\size )/2, 
                ;                       BB3( )\arrow\size, BB3( )\arrow\direction, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |BB3( )\color\_alpha<<24, BB3( )\arrow\type )
                
                draw_arrows_( BB3( ), BB3( )\arrow\direction ) 
              EndIf
            Else
              ; Draw thumb lines
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              If *this\vertical
                Line(BB3( )\x + (BB3( )\width -BB3( )\arrow\size )/2, BB3( )\y +BB3( )\height/2 - 3, BB3( )\arrow\size,1, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(BB3( )\x + (BB3( )\width -BB3( )\arrow\size )/2, BB3( )\y +BB3( )\height/2, BB3( )\arrow\size,1, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(BB3( )\x + (BB3( )\width -BB3( )\arrow\size )/2, BB3( )\y +BB3( )\height/2 + 3, BB3( )\arrow\size,1, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
              Else
                Line(BB3( )\x +BB3( )\width/2 - 3, BB3( )\y + (BB3( )\height -BB3( )\arrow\size )/2,1, BB3( )\arrow\size, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(BB3( )\x +BB3( )\width/2, BB3( )\y + (BB3( )\height -BB3( )\arrow\size )/2,1, BB3( )\arrow\size, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(BB3( )\x +BB3( )\width/2 + 3, BB3( )\y + (BB3( )\height -BB3( )\arrow\size )/2,1, BB3( )\arrow\size, BB3( )\color\front[BB3( )\color\state]&$FFFFFF |*this\color\_alpha<<24 )
              EndIf
            EndIf
            
            ; Draw thumb frame
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_box(BB3( ), color\frame)
          EndIf
          
        EndIf
      EndWith 
    EndProcedure
    
    Procedure.b bar_progress_draw( *this._S_widget )
      With *this
        Protected i,a, _position_, _frame_size_ = 1, _gradient_ = 1
        Protected _vertical_ = *this\vertical
        Protected _reverse_ = *this\bar\invert
        Protected _round_ = BB1( )\round
        Protected alpha = 230
        Protected _frame_color_ = $000000 ; BB1( )\color\frame[0]
        Protected _fore_color1_
        Protected _back_color1_
        Protected _fore_color2_ 
        Protected _back_color2_
        
        alpha = 230
        _fore_color1_ = BB1( )\color\fore[2]&$FFFFFF | alpha<<24 ; $f0E9BA81 ; 
        _back_color1_ = BB1( )\color\back[2]&$FFFFFF | alpha<<24 ; $f0E89C3D ; 
        alpha - 15
        _fore_color2_ = BB1( )\color\fore[0]&$FFFFFF | alpha<<24 ; $e0F8F8F8 ; 
        _back_color2_ = BB1( )\color\back[0]&$FFFFFF | alpha<<24 ; $e0E2E2E2 ; 
        
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
        drawing_mode_(#PB_2DDrawing_Outlined)
        draw_roundbox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, *this\height[#__c_frame] - _frame_size_*2, _round_,_round_)
        ;   draw_roundbox_(*this\x[#__c_frame] + _frame_size_+1, *this\y[#__c_frame] + _frame_size_+1, *this\width[#__c_frame] - _frame_size_*2-2, *this\height[#__c_frame] - _frame_size_*2-2, _round_,_round_)
        ;   ; ;   draw_roundbox_(*this\x[#__c_frame] + _frame_size_+2, *this\y[#__c_frame] + _frame_size_+2, *this\width[#__c_frame] - _frame_size_*2-4, *this\height[#__c_frame] - _frame_size_*2-4, _round_,_round_)
        ;   ;   
        ;   ;   For i = 0 To 1
        ;   ;     draw_roundbox_(*this\x[#__c_frame] + (_frame_size_+i), *this\y[#__c_frame] + (_frame_size_+i), *this\width[#__c_frame] - (_frame_size_+i)*2, *this\height[#__c_frame] - (_frame_size_+i)*2, _round_,_round_)
        ;   ;   Next
        
        If _gradient_
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          If _vertical_
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], (*this\x[#__c_frame] + *this\width[#__c_frame]), *this\y[#__c_frame])
          Else
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], *this\x[#__c_frame], (*this\y[#__c_frame] + *this\height[#__c_frame]))
          EndIf
        Else
          drawing_mode_( #PB_2DDrawing_Default )
        EndIf 
        
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If Not _round_
          If _vertical_
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _frame_size_ - (_position_)))
          Else
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, (_position_) - _frame_size_, *this\height[#__c_frame] - _frame_size_*2)
          EndIf
        Else 
          
          If _vertical_
            If (*this\height[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)))
                Else
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)))
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
                  draw_box_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) , *this\height[#__c_frame] - _frame_size_*2)
                Else
                  draw_box_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) + (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
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
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, (_position_) - _frame_size_)
          Else 
            draw_box_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _frame_size_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
          EndIf 
        Else 
          If _vertical_
            If (_position_) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (*this\height[#__c_frame] - (_position_))
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_) + (*this\height[#__c_frame] - _round_ - (_position_)))
                Else
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_))
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
                  draw_box_(*this\x[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
                Else
                  draw_box_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
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
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, BB3( )\color\frame[BB3( )\color\state] )
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i bar_spin_draw( *this._S_widget ) 
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
      draw_gradient_(*this\vertical, BB1( ), BB1( )\color\fore[BB1( )\color\state], BB1( )\color\back[BB1( )\color\state] )
      draw_gradient_(*this\vertical, BB2( ), BB2( )\color\fore[BB2( )\color\state], BB2( )\color\back[BB2( )\color\state] )
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      
      ; spin-buttons center line
      If EnteredButton( ) <> BB1( ) And BB1( )\color\state <> #__S_3
        draw_box_( BB1( )\x, BB1( )\y, BB1( )\width, BB1( )\height, BB1( )\color\frame[BB1( )\color\state] )
      EndIf
      If EnteredButton( ) <> BB2( ) And BB2( )\color\state <> #__S_3
        draw_box_( BB2( )\x, BB2( )\y, BB2( )\width, BB2( )\height, BB2( )\color\frame[BB2( )\color\state] )
      EndIf
      
      If FocusedWidget( ) = *this
        If *this\fs[1] ;And Not bar_in_start_( *this\bar )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\fs[1] + 1, *this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[2] ;And Not bar_in_stop_( *this\bar )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs[2] + 1, *this\color\frame[2] )
        EndIf
        If *this\fs[3] ;And Not bar_in_stop_( *this\bar )
          draw_box_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs[3] - 1,*this\y[#__c_frame],*this\fs[3] + 1,*this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[4] ;And Not bar_in_start_( *this\bar )
          draw_box_( *this\x[#__c_frame],*this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs[4] - 1,*this\width[#__c_frame],*this\fs[4] + 1, *this\color\frame[2] )
        EndIf
      EndIf
      
      If BB1( )\color\state = #__S_3
        draw_box_( BB1( )\x, BB1( )\y, BB1( )\width, BB1( )\height, BB1( )\color\frame[BB1( )\color\state] )
      EndIf
      
      If BB2( )\color\state = #__S_3
        draw_box_( BB2( )\x, BB2( )\y, BB2( )\width, BB2( )\height, BB2( )\color\frame[BB2( )\color\state] )
      EndIf
      
      If EnteredButton( ) 
        draw_box_( EnteredButton( )\x,EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, EnteredButton( )\color\frame[EnteredButton( )\color\state] )
      EndIf
      
      ;
      If *this\flag & #__spin_Plus
        ; -/+
        draw_plus_( BB1( ), Bool( *this\bar\invert ) )
        draw_plus_( BB2( ), Bool( Not *this\bar\invert ) )
      Else
        ; arrows on the buttons
        If BB1( )\arrow\size
          draw_arrows_( BB1( ), Bool(*this\vertical )) 
        EndIf
        If BB2( )\arrow\size
          draw_arrows_( BB2( ), Bool(*this\vertical ) + 2 ) 
        EndIf
      EndIf
      
      
      drawing_mode_( #PB_2DDrawing_Default )
      ; draw split-string back
      ;Box( BB3( )\x, BB3( )\y, BB3( )\width, BB3( )\height, *this\color\back[*this\color\state] )
      draw_box_( *this\x[#__c_frame] + *this\fs[1],*this\y[#__c_frame] + *this\fs[2],*this\width[#__c_frame] - *this\fs[1] - *this\fs[3],*this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\back[*this\color\state] )
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      ; draw split-string frame
      draw_box_( *this\x[#__c_frame] + *this\fs[1],*this\y[#__c_frame] + *this\fs[2],*this\width[#__c_frame] - *this\fs[1] - *this\fs[3],*this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\frame[Bool(FocusedWidget( ) = *this)*2] )
      
      ; Draw string
      If *this\text And *this\text\string
        drawing_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0] ) ; *this\color\state] )
      EndIf
    EndProcedure
    
    Procedure.b bar_track_draw( *this._S_widget )
      bar_scroll_draw( *this )
      ;bar_progress_draw( *this )
      
      With *this
        If \type = #__type_TrackBar
          Protected i, x,y
          drawing_mode_( #PB_2DDrawing_XOr )
          
          If \vertical
            x = BB3( )\x + Bool( *this\bar\invert )*( BB3( )\width - 3 + 4 ) - 2
            y = *this\y + *this\bar\area\pos + BB3( )\size/2  
            
            If *this\bar\widget\flag & #PB_TrackBar_Ticks
              For i = 0 To *this\bar\page\end
                Line( x, y + bar_thumb_pos_( *this\bar, i ),6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3,1, BB3( )\color\frame )
              Next
            EndIf
            
            Line( x-3, y,3,1, BB3( )\color\frame )
            Line( x-3, y + *this\bar\area\len - *this\bar\thumb\len,3,1, BB3( )\color\frame )
            
          Else
            x = *this\x + *this\bar\area\pos + BB3( )\size/2 
            y = BB3( )\y + Bool( Not *this\bar\invert )*( BB3( )\height - 3 + 4 ) - 2
            
            If *this\bar\widget\flag & #PB_TrackBar_Ticks
              For i = *this\bar\min To *this\bar\max
                Line( x + bar_thumb_pos_( *this\bar, i ), y,1,6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3, BB3( )\color\frame )
              Next
            EndIf
            
            Line( x, y-3,1,3, BB3( )\color\frame )
            Line( x + *this\bar\area\len - *this\bar\thumb\len, y-3,1,3, BB3( )\color\frame )
          EndIf
        EndIf
      EndWith    
      
    EndProcedure
    
    Procedure.b bar_splitter_draw( *this._S_widget )
      Protected circle_x, circle_y
      Protected._s_BUTTONS *SB1, *SB2, *SB3
      *SB1 = *this\bar\button[#__b_1]
      *SB2 = *this\bar\button[#__b_2]
      *SB3 = *this\bar\button[#__b_3]
      
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw the splitter background
      draw_box_( *SB3\x, *SB3\y, *SB3\width, *SB3\height, *this\color\back[*SB3\color\state]&$ffffff|210<<24 )
      
      ; draw the first\second background
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      
      ; draw the frame
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      ; 
      If *this\bar\thumb\len
        If *this\vertical
          circle_y = ( *SB3\y + *SB3\height / 2 )
          circle_x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *SB3\round ) / 2 + Bool( *this\width % 2 )
        Else
          circle_x = ( *SB3\x + *SB3\width / 2 ) ; - *this\x
          circle_y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *SB3\round ) / 2 + Bool( *this\height % 2 )
        EndIf
        
        If *this\vertical ; horisontal line
          If *SB3\width > 35
            Circle( circle_x - ( *SB3\round * 2 + 2 ) * 2 - 2, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x + ( *SB3\round * 2 + 2 ) * 2 + 2, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
          If *SB3\width > 20
            Circle( circle_x - ( *SB3\round * 2 + 2 ), circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x + ( *SB3\round * 2 + 2 ), circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
        Else
          If *SB3\height > 35
            Circle( circle_x, circle_y - ( *SB3\round * 2 + 2 )*2 - 2, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB3\round * 2 + 2 )*2 + 2, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
          If *SB3\height > 20
            Circle( circle_x, circle_y - ( *SB3\round * 2 + 2 ), *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB3\round * 2 + 2 ), *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
        EndIf
        
        Circle( circle_x, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
      EndIf
    EndProcedure
    
    Procedure.b bar_draw( *this._S_widget )
      With *this
        If \text\string  And ( *this\type = #__type_Spin Or
                               *this\type = #__type_ProgressBar )
          
          draw_font_( *this )
          
          If \text\change Or *this\resize & #__resize_change
            
            Protected _x_ = *this\x[#__c_inner]
            Protected _y_ = *this\y[#__c_inner]
            Protected _width_ = *this\width[#__c_inner]
            Protected _height_ = *this\height[#__c_inner]
            
            If *this\text\rotate = 0
              *this\text\y = _y_ + ( _height_ - *this\text\height )/2
              
              If *this\text\align\anchor\right
                *this\text\x = _x_ + ( _width_ - *this\text\align\delta\x - *this\text\width - *this\text\padding\x ) 
              ElseIf Not *this\text\align\anchor\left
                *this\text\x = _x_ + ( _width_ - *this\text\align\delta\x - *this\text\width )/2
              Else
                *this\text\x = _x_ + *this\text\padding\x
              EndIf
              
            ElseIf *this\text\rotate = 180
              *this\text\y = _y_ + ( _height_ - *this\y )
              
              If *this\text\align\anchor\right
                *this\text\x = _x_ + *this\text\padding\x + *this\text\width
              ElseIf Not *this\text\align\anchor\left
                *this\text\x = _x_ + ( _width_ + *this\text\width )/2 
              Else
                *this\text\x = _x_ + _width_ - *this\text\padding\x 
              EndIf
              
            ElseIf *this\text\rotate = 90
              *this\text\x = _x_ + ( _width_ - *this\text\height )/2
              
              If *this\text\align\anchor\right
                *this\text\y = _y_  + *this\text\align\delta\y +  *this\text\padding\y + *this\text\width
              ElseIf Not *this\text\align\anchor\left
                *this\text\y = _y_ + ( _height_ + *this\text\align\delta\y + *this\text\width )/2
              Else
                *this\text\y = _y_ + _height_ - *this\text\padding\y
              EndIf
              
            ElseIf *this\text\rotate = 270
              *this\text\x = _x_ + ( _width_ - 4 )
              
              If *this\text\align\anchor\right
                *this\text\y = _y_ + ( _height_ - *this\text\width - *this\text\padding\y ) 
              ElseIf Not *this\text\align\anchor\left
                *this\text\y = _y_ + ( _height_ - *this\text\width )/2 
              Else
                *this\text\y = _y_ + *this\text\padding\y 
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        Select \type
          Case #__type_Spin           : bar_spin_draw( *this )
          Case #__type_TabBar,#__type_ToolBar         : bar_tab_draw( *this )
          Case #__type_TrackBar       : bar_track_draw( *this )
          Case #__type_ScrollBar      : bar_scroll_draw( *this )
          Case #__type_ProgressBar    : bar_progress_draw( *this )
          Case #__type_Splitter       : bar_splitter_draw( *this )
        EndSelect
        
        ;drawing_mode_( #PB_2DDrawing_Outlined ) :draw_box_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00 )
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        
      EndWith
    EndProcedure
    
    ;-
    Procedure.b bar_Update( *bar._S_BAR, mode.b = 1 )
      Protected fixed.l, result.b, ScrollPos.f, ThumbPos.i, bordersize, width, height
      Protected._S_widget *this
      Protected._s_BUTTONS *BB1, *BB2, *BB3
      
      *this = *bar\widget
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      *BB3 = *this\bar\button[3]
      
      width = *this\width[#__c_frame]
      height = *this\height[#__c_frame]
      ;Debug ""+height +" "+ *this\class
      
      If mode > 0
        If *this\type = #__type_Spin 
          If *this\vertical
            *bar\area\len = height 
          Else
            *bar\area\len = width 
          EndIf
          
          ; set real spin-buttons height
          If Not *this\flag & #__spin_Plus
            *BB1\size =  height/2 + Bool( height % 2 )
            *BB2\size = *BB1\size
          EndIf
          
          ;*bar\area\pos = ( *BB1\size + *bar\min[1] )
          *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size )
          
          *bar\page\end = *bar\max 
          *bar\area\end = *bar\max - *bar\thumb\Len 
          *bar\percent = ( *bar\area\end - *bar\area\pos ) / ( *bar\page\end - *bar\min )
          
        Else
          ; get area size
          If *this\vertical
            *bar\area\len = height 
          Else
            *bar\area\len = width 
          EndIf
          
          If *this\type = #__type_ScrollBar 
            ; default button size
            If *bar\max 
              If *BB1\size =- 1 And *BB2\size =- 1
                If *this\vertical And width > 7 And width < 21
                  *BB1\size = width - 1
                  *BB2\size = width - 1
                  
                ElseIf Not *this\vertical And height > 7 And height < 21
                  *BB1\size = height - 1
                  *BB2\size = height - 1
                  
                Else
                  *BB1\size = *BB3\size
                  *BB2\size = *BB3\size
                EndIf
              EndIf
              
              ;           If *BB3\size
              ;             If *this\vertical
              ;               If *this\width = 0
              ;                 *this\width = *BB3\size
              ;               EndIf
              ;             Else
              ;               If *this\height = 0
              ;                 *this\height = *BB3\size
              ;               EndIf
              ;             EndIf
              ;           EndIf
            EndIf
          EndIf
          
          
          *bar\area\pos = ( *BB1\size + *bar\min[1] ) + bordersize
          *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size ) - bordersize*2
          
          If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
            If *bar\max
              *bar\thumb\len = *bar\thumb\end - ( *bar\max - *bar\area\len )
              *bar\page\end = *bar\max - ( *bar\thumb\end - *bar\thumb\len )
            EndIf
          Else
            If *bar\page\len
              ; get thumb size
              *bar\thumb\len = Round(( *bar\thumb\end / ( *bar\max - *bar\min )) * *bar\page\len, #PB_Round_Nearest )
              If *bar\thumb\len > *bar\thumb\end 
                *bar\thumb\len = *bar\thumb\end 
              EndIf
              If *bar\thumb\len < *BB3\size 
                If *bar\thumb\end > *BB3\size + *bar\thumb\len
                  *bar\thumb\len = *BB3\size 
                ElseIf *BB3\size > 7
                  Debug "get thumb size - ????? "+*this\class
                  *bar\thumb\len = 0
                EndIf
              EndIf
              
              ; for the scroll-bar
              If *bar\max > *bar\page\len
                *bar\page\end = *bar\max - *bar\page\len
              Else
                *bar\page\end = *bar\page\len - *bar\max
              EndIf
            Else
              ; get page end
              If *bar\max
                *bar\thumb\len = *BB3\size
                If *bar\thumb\len > *bar\area\len
                  *bar\thumb\len = *bar\area\len
                EndIf
                ;*bar\thumb\len = Round(( *bar\thumb\end / ( *bar\max - *bar\min )), #PB_Round_Nearest )
                *bar\page\end = *bar\max
              Else
                ; get thumb size
                *bar\thumb\len = *BB3\size
                If *bar\thumb\len > *bar\area\len
                  *bar\thumb\len = *bar\area\len
                EndIf
                
                ; one set end
                If Not *bar\page\end And *bar\area\len 
                  *bar\page\end = *bar\area\len - *bar\thumb\len
                  
                  If Not *bar\page\pos
                    *bar\page\pos = *bar\page\end/2 
                  EndIf
                  
                  ; if splitter fixed 
                  ; set splitter pos to center
                  If *bar\fixed
                    If *bar\fixed = #__split_1
                      *bar\button[*bar\fixed]\fixed = *bar\page\pos
                    Else
                      *bar\button[*bar\fixed]\fixed = *bar\page\end - *bar\page\pos
                    EndIf
                  EndIf
                Else
                  If *bar\page\change Or *bar\fixed = 1
                    *bar\page\end = *bar\area\len - *bar\thumb\len 
                  EndIf
                EndIf
              EndIf
              
            EndIf
          EndIf
          
          If *bar\page\end
            ; *bar\percent = ( *bar\thumb\end - *bar\thumb\len-*this\scroll\increment ) / ( *bar\page\end - *bar\min-*this\scroll\increment )
            *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\page\end - *bar\min )
          Else
            *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\min )
          EndIf
          
          *bar\area\end = *bar\area\len - *bar\thumb\len - ( *BB2\size + *bar\min[2] + bordersize )
        EndIf
      EndIf
      
      If mode < 2
        ; get thumb pos
        If *bar\fixed And Not *bar\page\change
          If *bar\fixed = #__split_1
            ThumbPos = *bar\button[*bar\fixed]\fixed
            
            If ThumbPos > *bar\area\end
              If *bar\min[1] < *bar\area\end
                ThumbPos = *bar\area\end
              Else
                If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                  ThumbPos = ( *bar\area\end + *bar\min[2] )
                Else
                  ThumbPos = *bar\min[1]
                EndIf
              EndIf
            EndIf
            
          Else 
            ThumbPos = ( *bar\area\end + *bar\min[2] ) - *bar\button[*bar\fixed]\fixed
            
            If ThumbPos < *bar\min[1]
              If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                ThumbPos = ( *bar\area\end + *bar\min[2] )
              Else
                ThumbPos = *bar\min[1]
              EndIf
            EndIf
          EndIf
          
          If *bar\thumb\pos <> ThumbPos
            *bar\thumb\change = *bar\thumb\pos - ThumbPos
            *bar\thumb\pos = ThumbPos
          EndIf
          
        Else
          If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
            If *bar\page\pos < *bar\min
              ; If *bar\max > *bar\page\len 
              *bar\page\pos = *bar\min
              ; EndIf
            EndIf
          Else
            ; fixed mac-OS splitterGadget
            If *bar\page\pos < *bar\min
              If *bar\max > *bar\page\len 
                If *bar\page\end 
                  *bar\page\pos = *bar\page\end + *bar\page\pos
                Else
                  Debug "error page\end - "+*bar\page\end
                EndIf
              EndIf
            EndIf
            
            ; for the scrollarea childrens
            If *bar\page\end And *bar\page\pos > *bar\page\end 
              ; Debug " bar end change - " + *bar\page\pos +" "+ *bar\page\end 
              *bar\page\change = *bar\page\pos - *bar\page\end
              *bar\page\pos = *bar\page\end
            EndIf
          EndIf
          
          If Not *bar\thumb\change
            ThumbPos = bar_thumb_pos_( *bar, *bar\page\pos )
            ThumbPos = bar_invert_thumb_pos_( *bar, ThumbPos )
            
            If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
            If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
            
            If *bar\thumb\pos <> ThumbPos
              *bar\thumb\change = *bar\thumb\pos - ThumbPos
              *bar\thumb\pos = ThumbPos
            EndIf
          EndIf
        EndIf
        
        ; get fixed size
        If *bar\fixed And *bar\page\change
          If *bar\fixed = #__split_1
            *BB1\fixed = *bar\thumb\pos
          Else
            *BB2\fixed = *bar\area\len - *bar\thumb\len - *bar\thumb\pos
          EndIf
        EndIf
        
        ; buttons state
        If *this\type = #__type_ScrollBar Or
           *this\type = #__type_TabBar Or
           *this\type = #__type_ToolBar
          
          ; disable/enable button-scroll(left&top)-tab(right&bottom)
          If *BB1\size And bar_in_start_( *bar )
            *BB1\state\disable = 1
            If *BB1\color\state <> #__S_3
              *BB1\color\state = #__S_3
            EndIf
          Else
            *BB1\state\disable = 0
            If *BB1\color\state <> #__S_2
              *BB1\color\state = #__S_0
            EndIf
          EndIf
          
          ; disable/enable button-scroll(right&bottom)-tab(left&top)
          If *BB2\size And bar_in_stop_( *bar ) 
            *BB2\state\disable = 1
            If *BB2\color\state <> #__S_3 
              *BB2\color\state = #__S_3
            EndIf
          Else
            *BB2\state\disable = 0
            If *BB2\color\state <> #__S_2
              *BB2\color\state = #__S_0
            EndIf
          EndIf
          
          ; disable/enable button-thumb
          If *this\type = #__type_ScrollBar
            If *bar\thumb\len 
              If *BB1\color\state = #__S_3 And
                 *BB2\color\state = #__S_3 
                
                If *BB3\color\state <> #__S_3
                  *BB3\color\state = #__S_3
                EndIf
              Else
                If *BB3\color\state <> #__S_2
                  *BB3\color\state = #__S_0
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; show/hide button-(right&bottom)
          If *BB2\size > 0
            If *BB2\hide <> Bool( *BB2\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
              *BB2\hide = Bool( *BB2\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
            EndIf
          Else
            If *BB2\hide <> #True
              *BB2\hide = #True
            EndIf
          EndIf
          
          ; show/hide button-(left&top)
          If *BB1\size > 0
            If *BB1\hide <> Bool( *BB1\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
              *BB1\hide = Bool( *BB1\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
            EndIf
          Else
            If *BB1\hide <> #True
              *BB1\hide = #True
            EndIf
          EndIf
        EndIf
        
        ; spin-buttons state
        If *this\type = #__type_spin 
          ; disable/enable button(left&top)-tab(right&bottom)
          If *BB1\size 
            If bar_in_start_( *bar )
              If *BB1\color\state <> #__S_3
                *BB1\color\state = #__S_3
              EndIf
            Else
              If *BB1\color\state <> #__S_2
                *BB1\color\state = #__S_0
              EndIf
            EndIf 
          EndIf
          
          ; disable/enable button(right&bottom)-tab(left&top)
          If *BB2\size And bar_in_stop_( *bar ) 
            If *BB2\color\state <> #__S_3 
              *BB2\color\state = #__S_3
            EndIf
          Else
            If *BB2\color\state <> #__S_2
              *BB2\color\state = #__S_0
            EndIf
          EndIf
          
          ; show/hide button-(right&bottom)
          If *BB2\size > 0
            If *BB2\hide <> Bool( *BB2\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
              *BB2\hide = Bool( *BB2\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
            EndIf
          Else
            If *BB2\hide <> #True
              *BB2\hide = #True
            EndIf
          EndIf
          
          ; show/hide button-(left&top)
          If *BB1\size > 0
            If *BB1\hide <> Bool( *BB1\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
              *BB1\hide = Bool( *BB1\color\state = #__S_3 And ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ))
            EndIf
          Else
            If *BB1\hide <> #True
              *BB1\hide = #True
            EndIf
          EndIf
        EndIf
        
        
        
        
        ; if enter buttons disabled 
        If EnteredButton( ) And
           EnteredButton( )\color\state = #__S_3
          EnteredButton( ) = #Null
        EndIf
        
        
        ; buttons resize coordinate
        If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
          ; inner coordinate
          If *this\vertical
            *this\x[#__c_inner] = *this\x[#__c_frame] 
            *this\width[#__c_inner] = *this\width[#__c_frame] - 1
            *this\y[#__c_inner] = *this\y[#__c_frame] + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
            *this\height[#__c_inner] = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\y[#__c_inner] - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
          Else
            *this\y[#__c_inner] = *this\y[#__c_frame]
            *this\height[#__c_inner] = *this\height[#__c_frame] - 1
            *this\x[#__c_inner] = *this\x[#__c_frame] + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
            *this\width[#__c_inner] = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\x[#__c_inner] - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
          EndIf
          
          If *BB2\size And Not *BB2\hide 
            If *this\vertical 
              ; Top button coordinate on vertical scroll bar
              ;  *BB2\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *BB2\size )/2            
              *BB2\y = *this\y[#__c_inner] - *BB2\size
            Else 
              ; Left button coordinate on horizontal scroll bar
              *BB2\x = *this\x[#__c_inner] - *BB2\size
              ;  *BB2\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *BB2\size )/2           
            EndIf
            If *BB2\width <> *BB2\size
              *BB2\width = *BB2\size
            EndIf
            If *BB2\height <> *BB2\size
              *BB2\height = *BB2\size                   
            EndIf
          EndIf
          
          If *BB1\size And Not *BB1\hide
            If *this\vertical 
              ; Botom button coordinate on vertical scroll bar
              ;  *BB1\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *BB1\size )/2              
              *BB1\y = *this\y[#__c_inner] + *this\height[#__c_inner]
            Else 
              ; Right button coordinate on horizontal scroll bar
              *BB1\x = *this\x[#__c_inner] + *this\width[#__c_inner]
              ;  *BB1\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *BB1\size )/2            
            EndIf
            If *BB1\width <> *BB1\size
              *BB1\width = *BB1\size
            EndIf
            If *BB1\height <> *BB1\size 
              *BB1\height = *BB1\size 
            EndIf
          EndIf
          
          ;If *bar\thumb\len
          If *this\vertical
            *BB3\x = *this\x[#__c_inner]          
            *BB3\width = *this\width[#__c_inner]
            *BB3\height = *bar\max                             
            *BB3\y = *this\y[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
          Else
            *BB3\y = *this\y[#__c_inner]         
            *BB3\height = *this\height[#__c_inner]
            *BB3\width = *bar\max
            *BB3\x = *this\x[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
          EndIf
          ;EndIf
          
          
          result = Bool( *this\resize & #__resize_change )
        EndIf
        
        ;
        If *this\type = #__type_ScrollBar
          If *bar\thumb\len 
            If *this\vertical
              *BB3\x = *this\x[#__c_frame]           + 1 ; white line size 
              *BB3\width = *this\width[#__c_frame]   - 1 ; white line size 
              *BB3\y = *this\y[#__c_inner_b] + *bar\thumb\pos
              *BB3\height = *bar\thumb\len                              
            Else
              *BB3\y = *this\y[#__c_frame]           + 1 ; white line size
              *BB3\height = *this\height[#__c_frame] - 1 ; white line size
              *BB3\x = *this\x[#__c_inner_b] + *bar\thumb\pos 
              *BB3\width = *bar\thumb\len                                  
            EndIf
          EndIf
          
          If *BB1\size 
            If *this\vertical 
              ; Top button coordinate on vertical scroll bar
              *BB1\x = *BB3\x
              *BB1\width = *BB3\width
              *BB1\y = *this\y[#__c_frame] 
              *BB1\height = *BB1\size                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *BB1\y = *BB3\y
              *BB1\height = *BB3\height
              *BB1\x = *this\x[#__c_frame] 
              *BB1\width = *BB1\size 
            EndIf
          EndIf
          
          If *BB2\size 
            If *this\vertical 
              ; Botom button coordinate on vertical scroll bar
              *BB2\x = *BB3\x
              *BB2\width = *BB3\width
              *BB2\height = *BB2\size 
              *BB2\y = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB2\height
            Else 
              ; Right button coordinate on horizontal scroll bar
              *BB2\y = *BB3\y
              *BB2\height = *BB3\height
              *BB2\width = *BB2\size 
              *BB2\x = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB2\width 
            EndIf
          EndIf
          
          ; Thumb coordinate on scroll bar
          If Not *bar\thumb\len
            ; auto resize buttons
            If *this\vertical
              *BB2\height = *this\height[#__c_frame]/2 
              *BB2\y = *this\y[#__c_frame] + *BB2\height + Bool( *this\height[#__c_frame]%2 ) 
              
              *BB1\y = *this\y 
              *BB1\height = *this\height/2 - Bool( Not *this\height[#__c_frame]%2 )
              
            Else
              *BB2\width = *this\width[#__c_frame]/2 
              *BB2\x = *this\x[#__c_frame] + *BB2\width + Bool( *this\width[#__c_frame]%2 ) 
              
              *BB1\x = *this\x[#__c_frame] 
              *BB1\width = *this\width[#__c_frame]/2 - Bool( Not *this\width[#__c_frame]%2 )
            EndIf
            
            If *this\vertical
              *BB3\width = 0 
              *BB3\height = 0                             
            Else
              *BB3\height = 0
              *BB3\width = 0                                 
            EndIf
          EndIf
        EndIf
        
        ; Ok
        If *this\type = #__type_Spin
          *BB3\x = *this\x[#__c_inner] 
          *BB3\y = *this\y[#__c_inner] 
          *BB3\width = *this\width[#__c_inner] 
          *BB3\height = *this\height[#__c_inner] 
          
          If Not *this\flag & #__spin_Plus
            If *BB1\size 
              *BB1\x = ( *this\x[#__c_frame] + *this\width[#__c_frame] ) - *BB3\size
              *BB1\y = *this\y[#__c_frame] 
              *BB1\width = *BB3\size
              *BB1\height = *BB1\size                   
            EndIf
            If *BB2\size 
              *BB2\x = *BB1\x
              *BB2\y = ( *this\y[#__c_frame] + *this\height[#__c_frame] ) - *BB2\size
              *BB2\height = *BB2\size 
              *BB2\width = *BB3\size
            EndIf
            
          Else
            ; spin buttons numeric plus -/+ 
            If *this\vertical
              If *BB1\size 
                *BB1\x = *this\x[#__c_frame]
                *BB1\y = ( *this\y[#__c_frame] + *this\height[#__c_frame] ) - *BB1\size
                *BB1\width = *this\width[#__c_frame]
                *BB1\height = *BB1\size
              EndIf
              If *BB2\size 
                *BB2\x = *this\x[#__c_frame]
                *BB2\y = *this\y[#__c_frame] 
                *BB2\width = *this\width[#__c_frame]
                *BB2\height = *BB2\size              
              EndIf
            Else
              If *BB1\size 
                *BB1\x = *this\x[#__c_frame]
                *BB1\y = *this\y[#__c_frame] 
                *BB1\width = *BB1\size
                *BB1\height = *this\height[#__c_frame]               
              EndIf
              If *BB2\size 
                *BB2\x = ( *this\x[#__c_frame] + *this\width[#__c_frame] ) - *BB2\size
                *BB2\y = *this\y[#__c_frame]
                *BB2\width = *BB2\size
                *BB2\height = *this\height[#__c_frame] 
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; Ok
        If *this\type = #__type_Splitter 
          ; is current button
          If *BB3\state\press Or 
             ( *BB3\state\enter And Not mouse( )\buttons )
            ; disable/enable buttons(left&top)-tab(right&bottom)
            If bar_in_start_( *bar )
              If *BB1\state\disable = #False
                *BB1\state\disable = #True
                If *this\vertical
                  DoEvents( *this, #PB_EventType_CursorChange, *BB1, cursor::#PB_Cursor_Down )
                Else
                  DoEvents( *this, #PB_EventType_CursorChange, *BB1, cursor::#PB_Cursor_Right )
                EndIf
              EndIf 
            Else
              If *BB1\state\disable = #True 
                *BB1\state\disable = #False
                If *this\vertical
                  DoEvents( *this, #PB_EventType_CursorChange, *BB1, cursor::#PB_Cursor_UpDown )
                Else
                  DoEvents( *this, #PB_EventType_CursorChange, *BB1, cursor::#PB_Cursor_LeftRight )
                EndIf
              EndIf
            EndIf
            
            ; disable/enable buttons(right&bottom)-tab(left&top)
            If bar_in_stop_( *bar ) 
              If *BB2\state\disable = #False
                *BB2\state\disable = #True
                If *this\vertical
                  DoEvents( *this, #PB_EventType_CursorChange, *BB2, cursor::#PB_Cursor_Up )
                Else
                  DoEvents( *this, #PB_EventType_CursorChange, *BB2, cursor::#PB_Cursor_Left )
                EndIf
              EndIf 
            Else
              If *BB2\state\disable = #True
                *BB2\state\disable = #False
                If *this\vertical
                  DoEvents( *this, #PB_EventType_CursorChange, *BB2, cursor::#PB_Cursor_UpDown )
                Else
                  DoEvents( *this, #PB_EventType_CursorChange, *BB2, cursor::#PB_Cursor_LeftRight )
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;
          If *this\vertical
            *BB1\width    = *this\width[#__c_frame]
            *BB1\height   = *bar\thumb\pos
            
            *BB1\x        = *this\x[#__c_frame]
            *BB2\x        = *this\x[#__c_frame]
            
            If Not (( #PB_Compiler_OS = #PB_OS_MacOS ) And bar_is_first_gadget_( *this ) And Not *this\_parent( ) )
              *BB1\y      = *this\y[#__c_frame] 
              *BB2\y      = ( *bar\thumb\pos + *bar\thumb\len ) + *this\y[#__c_frame] 
            Else
              *BB1\y      = *this\height[#__c_frame] - *BB1\height
            EndIf
            
            *BB2\height   = *this\height[#__c_frame] - ( *BB1\height + *bar\thumb\len )
            *BB2\width    = *this\width[#__c_frame]
            
            ; seperatior pos&size
            If *bar\thumb\len 
              *BB3\x = *this\x[#__c_frame]        
              *BB3\width = *this\width[#__c_frame] 
              *BB3\y = *this\y[#__c_inner_b] + *bar\thumb\pos
              *BB3\height = *bar\thumb\len                              
            EndIf
            
          Else
            *BB1\width    = *bar\thumb\pos
            *BB1\height   = *this\height[#__c_frame]
            
            *BB1\y        = *this\y[#__c_frame]
            *BB2\y        = *this\y[#__c_frame]
            *BB1\x        = *this\x[#__c_frame]
            *BB2\x        = ( *bar\thumb\pos + *bar\thumb\len ) + *this\x[#__c_frame]
            
            *BB2\width    = *this\width[#__c_frame] - ( *BB1\width + *bar\thumb\len )
            *BB2\height   = *this\height[#__c_frame]
            
            ; seperatior pos&size
            If *bar\thumb\len 
              *BB3\y = *this\y[#__c_frame]          
              *BB3\height = *this\height[#__c_frame]
              *BB3\x = *this\x[#__c_inner_b] + *bar\thumb\pos 
              *BB3\width = *bar\thumb\len                                  
            EndIf
          EndIf
          
          ; Splitter first-child auto resize       
          If bar_first_gadget_( *this ) >= 0 And bar_is_first_gadget_( *this )
            If *this\_root( )\canvas\container
              PB(ResizeGadget)( bar_first_gadget_( *this ), *BB1\x, *BB1\y, *BB1\width, *BB1\height )
            Else
              PB(ResizeGadget)( bar_first_gadget_( *this ),
                                *BB1\x + GadgetX( *this\_root( )\canvas\gadget ), 
                                *BB1\y + GadgetY( *this\_root( )\canvas\gadget ),
                                *BB1\width, *BB1\height )
            EndIf
          Else
            If bar_first_gadget_( *this )
              If bar_first_gadget_( *this )\x <> *BB1\x Or
                 bar_first_gadget_( *this )\y <> *BB1\y Or
                 bar_first_gadget_( *this )\width <> *BB1\width Or
                 bar_first_gadget_( *this )\height <> *BB1\height
                ; Debug "splitter_1_resize " + bar_first_gadget_( *this )
                
                If bar_first_gadget_( *this )\type = #__type_window
                  Resize( bar_first_gadget_( *this ),
                          *BB1\x - *this\x[#__c_frame],
                          *BB1\y - *this\y[#__c_frame], 
                          *BB1\width - #__window_frame_size*2, *BB1\height - #__window_frame_size*2 - #__window_caption_height)
                Else
                  Resize( bar_first_gadget_( *this ),
                          *BB1\x - *this\x[#__c_frame],
                          *BB1\y - *this\y[#__c_frame], 
                          *BB1\width, *BB1\height )
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          ; Splitter second-child auto resize       
          If bar_second_gadget_( *this ) >= 0 And bar_is_second_gadget_( *this )
            If *this\_root( )\canvas\container 
              PB(ResizeGadget)( bar_second_gadget_( *this ), *BB2\x, *BB2\y, *BB2\width, *BB2\height )
            Else
              PB(ResizeGadget)( bar_second_gadget_( *this ), 
                                *BB2\x + GadgetX( *this\_root( )\canvas\gadget ),
                                *BB2\y + GadgetY( *this\_root( )\canvas\gadget ),
                                *BB2\width, *BB2\height )
            EndIf
          Else
            If bar_second_gadget_( *this )
              If bar_second_gadget_( *this )\x <> *BB2\x Or 
                 bar_second_gadget_( *this )\y <> *BB2\y Or
                 bar_second_gadget_( *this )\width <> *BB2\width Or
                 bar_second_gadget_( *this )\height <> *BB2\height 
                ; Debug "splitter_2_resize " + bar_second_gadget_( *this )
                
                If bar_second_gadget_( *this )\type = #__type_window
                  Resize( bar_second_gadget_( *this ), 
                          *BB2\x - *this\x[#__c_frame], 
                          *BB2\y - *this\y[#__c_frame], 
                          *BB2\width - #__window_frame_size*2, *BB2\height - #__window_frame_size*2 - #__window_caption_height )
                Else
                  Resize( bar_second_gadget_( *this ), 
                          *BB2\x - *this\x[#__c_frame], 
                          *BB2\y - *this\y[#__c_frame], 
                          *BB2\width, *BB2\height )
                EndIf
                
              EndIf
            EndIf
          EndIf   
          
          result = Bool( *this\resize & #__resize_change )
        EndIf
        
        ;
        If *this\type = #__type_TrackBar
          If *bar\direction > 0 
            If *bar\thumb\pos = *bar\area\end Or *this\flag & #PB_TrackBar_Ticks
              *BB3\arrow\direction = Bool( Not *this\vertical ) + Bool( *this\vertical = *bar\invert ) * 2
            Else
              *BB3\arrow\direction = Bool( *this\vertical ) + Bool( Not *bar\invert ) * 2
            EndIf
          Else
            If *bar\thumb\pos = *bar\area\pos Or *this\flag & #PB_TrackBar_Ticks 
              *BB3\arrow\direction = Bool( Not *this\vertical ) + Bool( *this\vertical = *bar\invert ) * 2
            Else
              *BB3\arrow\direction = Bool( *this\vertical ) + Bool( *bar\invert ) * 2
            EndIf
          EndIf
          
          
          ; track bar draw coordinate
          If *this\vertical
            If *bar\thumb\len
              *BB3\y      = *this\y[#__c_frame] + *bar\thumb\pos
              *BB3\height = *bar\thumb\len                              
            EndIf
            
            *BB1\width    = 4
            *BB2\width    = 4
            *BB3\width    = *BB3\size + ( Bool( *BB3\size < 10 ) * *BB3\size )
            
            *BB1\y        = *this\y[#__c_frame]
            *BB1\height   = *bar\thumb\pos
            
            *BB2\y        = *BB1\y + *BB1\height + *bar\thumb\len
            *BB2\height   = *this\height[#__c_frame] - *bar\thumb\pos - *bar\thumb\len
            
            If *bar\invert
              *BB1\x      = *this\x[#__c_frame] + 6
              *BB2\x      = *this\x[#__c_frame] + 6
              *BB3\x      = *BB1\x - *BB3\width / 4 - 1 - Bool( *BB3\size > 10 )
            Else
              *BB1\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB1\width - 6
              *BB2\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB2\width - 6 
              *BB3\x      = *BB1\x - *BB3\width / 2 + Bool( *BB3\size > 10 )
            EndIf
          Else
            If *bar\thumb\len
              *BB3\x      = *this\x[#__c_frame] + *bar\thumb\pos 
              *BB3\width  = *bar\thumb\len                                  
            EndIf
            
            *BB1\height   = 4
            *BB2\height   = 4
            *BB3\height   = *BB3\size + ( Bool( *BB3\size < 10 ) * *BB3\size )
            
            *BB1\x        = *this\x[#__c_frame]
            *BB1\width    = *bar\thumb\pos
            
            *BB2\x        = *BB1\x + *BB1\width + *bar\thumb\len
            *BB2\width    = *this\width[#__c_frame] - *bar\thumb\pos - *bar\thumb\len
            
            If *bar\invert
              *BB1\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB1\height - 6
              *BB2\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB2\height - 6 
              *BB3\y      = *BB1\y - *BB3\height / 2 + Bool( *BB3\size > 10 )
            Else
              *BB1\y      = *this\y[#__c_frame] + 6
              *BB2\y      = *this\y[#__c_frame] + 6
              *BB3\y      = *BB1\y - *BB3\height / 4 - 1 - Bool( *BB3\size > 10 )
            EndIf
          EndIf
        EndIf
        
        
        ;
        If *bar\page\change <> 0
          ;- widget::bar_update_parent_area_( )
          If *this\_parent( ) And *this\_parent( )\scroll And *this\type = #__type_ScrollBar
            
            If *this\vertical
              If *this\_parent( )\scroll\v = *this
                *this\_parent( )\change =- 1
                scroll_y_( *this\_parent( ) ) =- *bar\page\pos
                
                ; row pos update
                If *this\_parent( )\row
                  If *this\_parent( )\text\editable
                    Editor_Update( *this\_parent( ), *this\_parent( )\_rows( ))
                  Else
                    update_visible_items_( *this\_parent( ) )
                  EndIf 
                  
                  *this\_parent( )\change = 0
                EndIf
                
                ; Area childrens x&y auto move 
                If *this\_parent( )\container
                  If StartEnumerate( *this\_parent( ) ) 
                    If *this\_parent( ) = enumWidget( )\_parent( ) And 
                       *this\_parent( )\scroll\v <> enumWidget( ) And 
                       *this\_parent( )\scroll\h <> enumWidget( ) And Not enumWidget( )\align
                      
                      If is_integral_( enumWidget( ))
                        Resize( enumWidget( ), #PB_Ignore, ( enumWidget( )\y[#__c_container] + *bar\page\change ), #PB_Ignore, #PB_Ignore )
                      Else
                        Resize( enumWidget( ), #PB_Ignore, ( enumWidget( )\y[#__c_container] + *bar\page\change ) - scroll_y_( *this\_parent( ) ), #PB_Ignore, #PB_Ignore )
                      EndIf
                    EndIf
                    
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            Else
              If *this\_parent( )\scroll\h = *this
                *this\_parent( )\change =- 2
                scroll_x_( *this\_parent( ) ) =- *bar\page\pos
                
                ; Area childrens x&y auto move 
                If *this\_parent( )\container
                  If StartEnumerate( *this\_parent( ) ) 
                    If *this\_parent( ) = enumWidget( )\_parent( ) And 
                       *this\_parent( )\scroll\v <> enumWidget( ) And 
                       *this\_parent( )\scroll\h <> enumWidget( ) And Not enumWidget( )\align
                      
                      If is_integral_( enumWidget( ))
                        Resize( enumWidget( ), ( enumWidget( )\x[#__c_container] + *bar\page\change ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                      Else
                        Resize( enumWidget( ), ( enumWidget( )\x[#__c_container] + *bar\page\change ) - scroll_x_( *this\_parent( ) ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                      EndIf
                    EndIf
                    
                    StopEnumerate( )
                  EndIf
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          ;
          If *this\type = #__type_Spin Or
             *this\type = #__type_ProgressBar
            
            Protected i
            For i = 0 To 3
              If *this\scroll\increment = ValF( StrF( *this\scroll\increment, i ) )
                *this\text\string = StrF( *bar\page\pos, i )
                *this\text\change = #True
                Break
              EndIf
            Next
          EndIf
          
          ;
          If *this\_root( )\canvas\gadget <> PB(EventGadget)( ) And PB(IsGadget)( PB(EventGadget)( )) 
            Debug "bar redraw - "+*this\_root( )\canvas\gadget +" "+ PB(EventGadget)( ) +" "+ EventGadget( )
            ReDraw( *this\_root( ) ) 
          EndIf
          
          ;         If is_integral_( *this )
          ;           If *this\type = #__type_ScrollBar ; is_scrollbars_( *this )
          ;             Post( *this\_parent( ), #PB_EventType_ScrollChange, *this, *bar\page\change )
          ;           EndIf
          ;         Else
          ;           Post( *this, #PB_EventType_Change, EnteredButton( ), *bar\page\change )
          ;         EndIf
          
          *bar\page\change = 0
        EndIf 
        
        ; 
        If *bar\thumb\change <> 0
          If *this\_root( )\canvas\gadget = PB(EventGadget)( ) 
            result = *bar\thumb\change
          EndIf
          
          *bar\thumb\change = 0
        EndIf  
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b bar_Change( *bar._S_BAR, ScrollPos.l )
      Protected *this._S_widget = *bar\widget
      ;Debug ""+ScrollPos +" "+ *bar\page\end
      
      ;If ScrollPos < *bar\min : ScrollPos = *bar\min : EndIf 
      If ScrollPos < *bar\min 
        If *bar\max > *bar\page\len 
          ScrollPos = *bar\min 
        Else
          ScrollPos = *bar\page\end + ScrollPos
        EndIf
      EndIf 
      If ScrollPos > *bar\page\end 
        If *bar\page\end
          ScrollPos = *bar\page\end 
        Else
          ScrollPos = bar_page_pos_( *bar, *bar\area\end ) - ScrollPos
        EndIf
      EndIf
      
      If *bar\page\pos <> ScrollPos 
        If *bar\page\pos > ScrollPos
          *bar\direction =- ScrollPos
        Else
          *bar\direction = ScrollPos
        EndIf
        
        *bar\page\change = *bar\page\pos - ScrollPos
        *bar\page\pos = ScrollPos
        
        ; example-scroll(area) fixed
        If is_integral_( *this )
          If *this\type = #__type_ScrollBar ; is_scrollbars_( *bar\widget )
            DoEvents( *this\_parent( ), #PB_EventType_ScrollChange, *this, *bar\page\change )
          EndIf
        Else
          Post( *this, #PB_EventType_Change, EnteredButton( ), *bar\page\change )
        EndIf
        
        ProcedureReturn #True
      EndIf
    EndProcedure
    
    Procedure.b bar_SetState( *bar._S_BAR, state.l )
      ;       If *bar\widget\type = #__type_TabBar
      ;         bar_tab_SetState( *bar\widget, state )
      ;       Else
      If bar_Change( *bar, state ) 
        ProcedureReturn bar_Update( *bar ) 
      EndIf
      ;       EndIf
    EndProcedure
    
    Procedure.b bar_SetThumbPos( *bar._S_BAR, ThumbPos.i )
      Protected *this._S_widget = *bar\widget
      Protected ScrollPos.i
      
      If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
      If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
      
      If *bar\thumb\pos <> ThumbPos 
        ScrollPos = bar_page_pos_( *bar, ThumbPos )
        ScrollPos = bar_invert_page_pos_( *bar, ScrollPos )
        
        ;
        If *this\scroll\increment > 1
          ScrollPos - Mod( ScrollPos, *this\scroll\increment )
        EndIf
        
        ; thumb move tick steps
        If ( *this\type = #__type_trackbar And *this\flag & #PB_TrackBar_Ticks )
          ThumbPos = bar_thumb_pos_( *bar, ScrollPos )
          ThumbPos = bar_invert_thumb_pos_( *bar, ThumbPos )
        EndIf
        
        If *bar\thumb\change <> *bar\thumb\pos - ThumbPos 
          *bar\thumb\change = *bar\thumb\pos - ThumbPos 
          *bar\thumb\pos = ThumbPos
          If bar_Change( *bar, ScrollPos )
          EndIf
          ProcedureReturn bar_Update( *bar, 0 )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.l bar_SetAttribute( *this._S_widget, Attribute.l, *value )
      Protected result.l
      Protected value = *value
      
      With *this
        If \type = #__type_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              *this\bar\min[1] = *value 
              ;BB1( )\size = *value 
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *this\bar\min[2] = *value
              ;BB2( )\size = *value 
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_FirstGadget
              bar_first_gadget_( *this ) = *value
              bar_is_first_gadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
            Case #PB_Splitter_SecondGadget
              bar_second_gadget_( *this ) = *value
              bar_is_second_gadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If *this\bar\min <> *value ;And Not *value < 0
                *this\bar\area\change = *this\bar\min - value
                If *this\bar\page\pos < *value
                  *this\bar\page\pos = *value
                EndIf
                *this\bar\min = *value
                ; Debug  " min " + *this\bar\min + " max " + *this\bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If *this\bar\max <> *value And Not ( *value < 0 And Not #__bar_minus)
                *this\bar\area\change = *this\bar\max - value
                
                If *this\bar\min > *value And Not #__bar_minus
                  *this\bar\max = *this\bar\min + 1
                Else
                  *this\bar\max = *value
                EndIf
                ;                 
                If Not *this\bar\max And Not #__bar_minus
                  *this\bar\page\pos = *this\bar\max
                EndIf
                ; Debug  "   min " + *this\bar\min + " max " + *this\bar\max
                
                ;\bar\page\change = #True
                result = #True
              EndIf
              
            Case #__bar_pagelength
              If *this\bar\page\len <> *value And Not ( *value < 0 And Not #__bar_minus )
                *this\bar\area\change = *this\bar\page\len - value
                *this\bar\page\len = *value
                
                If Not *this\bar\max And Not #__bar_minus
                  If *this\bar\min > *value
                    *this\bar\max = *this\bar\min + 1
                  Else
                    *this\bar\max = *value
                  EndIf
                EndIf
                
                result = #True
              EndIf
              
            Case #__bar_buttonsize
              If BB3( )\size <> *value
                BB3( )\size = *value
                
                If *this\type = #__type_spin
                  If *this\flag & #__spin_plus
                    ; set real spin-buttons width
                    BB1( )\size = *value
                    BB2( )\size = *value
                    
                    If *this\vertical
                      *this\fs[2] = BB2( )\size - 1
                      *this\fs[4] = BB1( )\size - 1
                    Else
                      *this\fs[1] = BB1( )\size - 1
                      *this\fs[3] = BB2( )\size - 1                      
                    EndIf
                  Else
                    *this\fs[3] = *value - 1
                  EndIf
                Else
                  ; to reset the button size to default
                  If *this\type = #__type_ScrollBar Or
                     *this\type = #__type_TabBar Or 
                     *this\type = #__type_ToolBar
                    
                    If *value
                      BB1( )\size = #PB_Default
                      BB2( )\size = #PB_Default
                    Else
                      BB1( )\size = 0
                      BB2( )\size = 0
                    EndIf
                  EndIf
                  
                  ; if it is a composite element of the parent
                  If *this\child > 0 And *this\_parent( ) And *value
                    *value + 1
                    If *this\vertical
                      Resize(*this, *this\_parent( )\width[#__c_container]-*value, #PB_Ignore, *value, #PB_Ignore)
                    Else
                      Resize(*this, #PB_Ignore, *this\_parent( )\width[#__c_container]-*value, #PB_Ignore, *value)
                    EndIf
                  EndIf
                  
                  bar_Update( *this\bar )
                  PostCanvasRepaint( *this\_root( ) )
                  
                  ProcedureReturn #True
                EndIf
              EndIf
              
            Case #__bar_invert
              *this\bar\invert = Bool( *value )
              ProcedureReturn bar_Update( *this\bar )
            Case #__bar_ScrollStep 
              \scroll\increment = value
              
          EndSelect
        EndIf
        
        If result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\page\change = #True
                  ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
          
          If *this\_root( ) ;And *this\_root( )\canvas\postevent = #False
            bar_Update( *this\bar ) 
          EndIf
          
          ; after update and resize bar
          If *this\type = #__type_ScrollBar And
             Attribute = #__bar_buttonsize
            BB1( )\size =- 1
            BB2( )\size =- 1
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
    
    Procedure   bar_make_scroll_area( *this._S_widget )
      Protected result
      
      If *this\scroll\v And
         *this\scroll\v\bar\max <> scroll_height_( *this ) And
         bar_SetAttribute( *this\scroll\v, #PB_ScrollBar_Maximum, scroll_height_( *this ) - *this\mode\gridlines )
        scroll_height_( *this ) - *this\mode\gridlines
        result = 1;Bool( *this\scroll\v\bar\max >= *this\scroll\v\bar\page\len )
      EndIf
      
      If *this\scroll\h And 
         *this\scroll\h\bar\max <> scroll_width_( *this ) And  
         bar_SetAttribute( *this\scroll\h, #PB_ScrollBar_Maximum, scroll_width_( *this ) )
        result = 1;Bool( *this\scroll\h\bar\max >= *this\scroll\h\bar\page\len )
      EndIf
      
      If result 
        bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        *this\width[#__c_inner] = *this\scroll\h\bar\page\len 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   mdi_bar_update_( *this._S_widget, x.l,y.l,width.l,height.l )
      scroll_x_( *this ) = x
      scroll_y_( *this ) = y
      scroll_width_( *this ) = width
      scroll_height_( *this ) = height
      
      If StartEnumerate( *this )
        If enumWidget( )\_parent( ) = *this
          If scroll_x_( *this ) > enumWidget( )\x[#__c_container] 
            scroll_x_( *this ) = enumWidget( )\x[#__c_container] 
          EndIf
          If scroll_y_( *this ) > enumWidget( )\y[#__c_container] 
            scroll_y_( *this ) = enumWidget( )\y[#__c_container] 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If StartEnumerate( *this )
        If enumWidget( )\_parent( ) = *this
          If scroll_width_( *this ) < enumWidget( )\x[#__c_container] + enumWidget( )\width[#__c_frame] - scroll_x_( *this ) 
            scroll_width_( *this ) = enumWidget( )\x[#__c_container] + enumWidget( )\width[#__c_frame] - scroll_x_( *this ) 
          EndIf
          If scroll_height_( *this ) < enumWidget( )\y[#__c_container] + enumWidget( )\height[#__c_frame] - scroll_y_( *this ) 
            scroll_height_( *this ) = enumWidget( )\y[#__c_container] + enumWidget( )\height[#__c_frame] - scroll_y_( *this ) 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
      x = 0 
      y = 0
      width = *this\width[#__c_container]
      height = *this\height[#__c_container] 
      
      If *this\scroll\v\bar\page\len <> height - Bool( scroll_width_( *this ) > width ) * *this\scroll\h\height
        *this\scroll\v\bar\page\len = height - Bool( scroll_width_( *this ) > width ) * *this\scroll\h\height
      EndIf
      
      If *this\scroll\h\bar\page\len <> width - Bool( scroll_height_( *this ) > height ) * *this\scroll\v\width
        *this\scroll\h\bar\page\len = width - Bool( scroll_height_( *this ) > height ) * *this\scroll\v\width
      EndIf
      
      If scroll_x_( *this ) < x
        ; left set state
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        sx = ( scroll_x_( *this ) - x ) 
        scroll_width_( *this ) + sx
        scroll_x_( *this ) = x
      EndIf
      
      If scroll_y_( *this ) < y
        ; top set state
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        sy = ( scroll_y_( *this ) - y )
        scroll_height_( *this ) + sy
        scroll_y_( *this ) = y
      EndIf
      
      If scroll_width_( *this ) > *this\scroll\h\bar\page\len - ( scroll_x_( *this ) - x )
        If scroll_width_( *this ) - sx <= width And scroll_height_( *this ) = *this\scroll\v\bar\page\len - ( scroll_y_( *this ) - y )
          ;Debug "w - " + Str( scroll_height_( *this ) - sx )
          
          ; if on the h - scroll
          If *this\scroll\v\bar\max > height - *this\scroll\h\height
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width 
            scroll_height_( *this ) = *this\scroll\v\bar\max
            ;  Debug "w - " + *this\scroll\v\bar\max  + " " +  *this\scroll\v\height  + " " +  *this\scroll\v\bar\page\len
          Else
            scroll_height_( *this ) = *this\scroll\v\bar\page\len - ( scroll_x_( *this ) - x ) - *this\scroll\h\height
          EndIf
        EndIf
        
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
      Else
        *this\scroll\h\bar\max = scroll_width_( *this )
        scroll_width_( *this ) = *this\scroll\h\bar\page\len - ( scroll_x_( *this ) - x )
      EndIf
      
      If scroll_height_( *this ) > *this\scroll\v\bar\page\len - ( scroll_y_( *this ) - y )
        If scroll_height_( *this ) - sy <= Height And scroll_width_( *this ) = *this\scroll\h\bar\page\len - ( scroll_x_( *this ) - x )
          ;Debug " h - " + Str( scroll_height_( *this ) - sy )
          
          ; if on the v - scroll
          If *this\scroll\h\bar\max > width - *this\scroll\v\width
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
            scroll_width_( *this ) = *this\scroll\h\bar\max
            ;  Debug "h - " + *this\scroll\h\bar\max  + " " +  *this\scroll\h\width  + " " +  *this\scroll\h\bar\page\len
          Else
            scroll_width_( *this ) = *this\scroll\h\bar\page\len - ( scroll_x_( *this ) - x ) - *this\scroll\v\width
          EndIf
        EndIf
        
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        *this\scroll\v\bar\max = scroll_height_( *this )
        scroll_height_( *this ) = *this\scroll\v\bar\page\len - ( scroll_y_( *this ) - y )
      EndIf
      
      If *this\scroll\h\round And
         *this\scroll\v\round And
         *this\scroll\h\bar\page\len < width And 
         *this\scroll\v\bar\page\len < height
        round = ( *this\scroll\h\height/4 )
      EndIf
      
      If scroll_width_( *this ) >= *this\scroll\h\bar\page\len  
        If *this\scroll\h\bar\Max <> scroll_width_( *this ) 
          *this\scroll\h\bar\Max = scroll_width_( *this )
          
          If scroll_x_( *this ) <= x 
            *this\scroll\h\bar\page\pos =- ( scroll_x_( *this ) - x )
          EndIf
        EndIf
        
        If *this\scroll\h\width <> *this\scroll\h\bar\page\len + round
          ; Debug  "h " + *this\scroll\h\bar\page\len
          Resize( *this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len + round, #PB_Ignore )
          *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len )) 
          ;           *this\scroll\h\width = *this\scroll\h\bar\page\len + round
          ;           *this\scroll\h\hide = bar_Update( *this\scroll\h\bar, 2 )
          result = 1
        EndIf
      EndIf
      
      If scroll_height_( *this ) >= *this\scroll\v\bar\page\len  
        If *this\scroll\v\bar\Max <> scroll_height_( *this )  
          *this\scroll\v\bar\Max = scroll_height_( *this )
          
          If scroll_y_( *this ) <= y 
            ;If *this\scroll\v\bar\page\pos <>- ( scroll_y_( *this ) - y )
            *this\scroll\v\bar\page\pos =- ( scroll_y_( *this ) - y )
            
            ; Post( *this\scroll\v, #PB_EventType_change )
            ;EndIf
          EndIf
        EndIf
        
        If *this\scroll\v\height <> *this\scroll\v\bar\page\len + round
          ; Debug  "v " + *this\scroll\v\bar\page\len
          Resize( *this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len + round )
          *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len )) 
          ;           *this\scroll\v\height = *this\scroll\v\bar\page\len + round
          ;           *this\scroll\v\hide = bar_Update( *this\scroll\v\bar, 2 )
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
        bar_Update( *this\scroll\v\bar ) 
        *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len )) 
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        bar_Update( *this\scroll\h\bar ) 
        *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len )) 
      EndIf
      
      If result
        
        *this\width[#__c_inner] = *this\scroll\h\bar\page\len
        *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        *this\resize | #__resize_change
        
      EndIf
      
      
    EndProcedure
    
    Procedure   _3bar_Resizes( *this._S_widget, x.l,y.l,width.l,height.l )
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
        
        w = Bool( scroll_width_( *this ) > width )
        h = Bool( scroll_height_( *this ) > height )
        
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
          height = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 )) 
          If \v\height[#__c_frame] <> height
            \v\height[#__c_frame] = height 
            \v\height[#__c_screen] = height + ( \v\bs*2 - \v\fs*2 )
            \v\height[#__c_container] = height - \v\fs*2 
            If \v\height[#__c_container] < 0 : \v\height[#__c_container] = 0 : EndIf
            \v\height[#__c_inner] = \v\height[#__c_container]
            \v\height[#__c_draw] = \v\_parent( )\height[#__c_draw]
            
            bar_Update( \v\bar )
          EndIf
          ;   Resize( \v, #PB_Ignore, y, #PB_Ignore, ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ))
          If \v\hide <> #False
            \v\hide = #False
          EndIf
        Else
          If \v\hide <> #True
            \v\hide = #True
            ;\v\y = y
            \v\height = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 )) 
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If bar_Change( \v\bar, \v\bar\min )
                bar_Update( \v\bar, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          ;\h\x = x
          width = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 ))
          If \h\width[#__c_frame] <> width
            \h\width[#__c_frame] = width 
            \h\width[#__c_screen] = width + ( \h\bs*2 - \h\fs*2 )
            \h\width[#__c_container] = width - \h\fs*2 
            If \h\width[#__c_container] < 0 : \h\width[#__c_container] = 0 : EndIf
            \h\width[#__c_inner] = \h\width[#__c_container]
            \h\width[#__c_draw] = \h\_parent( )\width[#__c_draw]
            
            bar_Update( \h\bar )
          EndIf
          ; Resize( \h, x, #PB_Ignore, ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 )), #PB_Ignore )
          If \h\hide <> #False
            \h\hide = #False
          EndIf
        Else
          If \h\hide <> #True
            \h\hide = #True
            \h\width = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 )) 
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If bar_Change( \h\bar, \h\bar\min )
                bar_Update( \h\bar, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ProcedureReturn Bool( \v\bar\area\change Or \h\bar\area\change )
      EndWith
    EndProcedure
    Procedure   bar_Resizes( *this._S_widget, x.l,y.l,width.l,height.l )
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
        
        w = Bool( scroll_width_( *this ) > width )
        h = Bool( scroll_height_( *this ) > height )
        
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
          Resize( \v, #PB_Ignore, y, #PB_Ignore, ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height/4 ) ))
          If \v\hide <> #False
            \v\hide = #False
          EndIf
        Else
          If \v\hide <> #True
            *this\resize | #__resize_change
            \v\hide = #True
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If bar_Change( \v\bar, \v\bar\min )
                bar_Update( \v\bar, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          Resize( \h, x, #PB_Ignore, ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width/4 )), #PB_Ignore )
          If \h\hide <> #False
            \h\hide = #False
          EndIf
        Else
          If \h\hide <> #True
            *this\resize | #__resize_change
            \h\hide = #True
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If bar_Change( \h\bar, \h\bar\min )
                bar_Update( \h\bar, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;         If Bool( \v\bar\area\change Or \h\bar\area\change )
        ;           *this\resize | #__resize_change
        ;         EndIf
        
        ProcedureReturn Bool( \v\bar\area\change Or \h\bar\area\change )
      EndWith
    EndProcedure
    
    Procedure   bar_Events( *this._S_widget, eventtype.l, *button._S_buttons, *data )
      Protected Repaint
      
      If eventtype = #PB_EventType_CursorChange
        If *this\type = #__type_Splitter
          If mouse( )\cursor <> *data
            ; Debug "cursor-change " + *data +" "+ *this\_root( )\canvas\gadget
            SetCursor( *this, *data )
            mouse( )\cursor = *data
          EndIf
        EndIf
      EndIf       
      
      If eventtype = #PB_EventType_StatusChange
        If *this\type = #__type_Tabbar
          If *this\PressedTab( ) And bar_tab_SetState( *this, *this\PressedTab( )\index ) 
            Repaint = #True 
          EndIf
        EndIf
      EndIf       
      
      If eventtype = #PB_EventType_Down
        If bar_SetState( *this\bar, *this\bar\page\pos + *this\scroll\increment )
          Repaint = #True 
        EndIf
      EndIf       
      
      If eventtype = #PB_EventType_Up
        If bar_SetState( *this\bar, *this\bar\page\pos - *this\scroll\increment )
          Repaint = #True 
        EndIf
      EndIf       
      
      
      If eventtype = #PB_EventType_LeftButtonDown
        If FocusedButton( ) <> EnteredButton( ) 
          FocusedButton( ) = EnteredButton( )
        EndIf
        ; change the color state of non-disabled buttons
        
        If EnteredButton( ) And 
           EnteredButton( )\color\state <> #__S_3 And 
           EnteredButton( )\state\disable = #False
          EnteredButton( )\state\press = #True
          
          If Not ( *this\type = #__type_TrackBar Or 
                   ( *this\type = #__type_Splitter And 
                     EnteredButton( ) <> BB3( ) ))
            EnteredButton( )\color\state = #__S_2
          EndIf
          
          If BB3( )\state\press
            Repaint = #True
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If FocusedButton( ) And
           FocusedButton( )\state\press = #True  
          FocusedButton( )\state\press = #False 
          
          If FocusedButton( )\color\state <> #__S_3 And 
             FocusedButton( )\state\disable = #False 
            
            ; change color state
            If FocusedButton( )\color\state = #__S_2 And
               Not ( *this\type = #__type_TrackBar Or 
                     ( *this\type = #__type_Splitter And 
                       FocusedButton( ) <> BB3( ) ))
              
              If FocusedButton( )\state\enter
                FocusedButton( )\color\state = #__S_1
              Else
                FocusedButton( )\color\state = #__S_0 
              EndIf
            EndIf
            
            Repaint = 1
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_MouseMove
        If *this\state\press And BB3( )\state\press
          If *this\vertical
            Repaint | bar_SetThumbPos( *this\bar, ( mouse( )\y - mouse( )\delta\y ))
          Else
            Repaint | bar_SetThumbPos( *this\bar, ( mouse( )\x - mouse( )\delta\x ))
          EndIf
          
          SetWindowTitle( EventWindow( ), Str( *this\bar\page\pos )  + " " +  Str( *this\bar\thumb\pos - *this\bar\area\pos ))
        EndIf
      EndIf
      
      
      ProcedureReturn Repaint
    EndProcedure
    ;}
    
    
    ;- 
    ;-  EDITOR
    Macro edit_row_edit_text_x_( _this_, _mode_ )
      ( row_x_( _this_, _this_\_rows( ) ) + _this_\_rows( )\text\edit#_mode_\x )
    EndMacro
    
    Macro edit_row_edit_text_y_( _this_, _mode_ ) ; пока не используется
      ( row_y_( _this_, _this_\_rows( ) ) + _this_\_rows( )\text\edit#_mode_\y )
    EndMacro
    
    Macro edit_row_select_( _this_, _address_, _index_ )
      _address_\state\focus = 0
      ;_address_\state\enter = 0
      _address_\color\state = 0
      
      _address_ = SelectElement( _this_\_rows( ), _index_ )
      
      If _address_
        _address_\color\state = 1
        ;_address_\state\enter = 1
        _address_\state\focus = #True
      EndIf
    EndMacro
    
    Macro edit_text_scroll_x_( _this_ )
      If *this\scroll\h And Not *this\scroll\h\hide And _this_\text\caret\x
        ; *this\change =- bar_scroll_pos_( *this\scroll\h, (_this_\text\caret\x - _this_\text\padding\x) - _this_\x, ( _this_\text\padding\x * 2 + _this_\row\margin\width )) ; ok
        *this\change =- bar_scroll_pos_( *this\scroll\h, (_this_\text\caret\x - _this_\text\padding\x) - _this_\x[#__c_inner], ( _this_\text\padding\x * 2 + _this_\row\margin\width )) ; ok
      EndIf
    EndMacro
    
    Macro edit_text_scroll_y_( _this_ )
      If *this\scroll\v And Not *this\scroll\v\hide
        ;  *this\change =- bar_scroll_pos_( *this\scroll\v, (_this_\text\caret\y - _this_\text\padding\y), ( _this_\text\padding\y * 2 + _this_\text\caret\height )) ; ok
        *this\change =- bar_scroll_pos_( *this\scroll\v, (_this_\text\caret\y - _this_\text\padding\y) - _this_\y[#__c_inner], ( _this_\text\padding\y * 2 + _this_\text\caret\height )) ; ok
      EndIf
    EndMacro
    
    Macro edit_linePos( ): text\caret\line[0]: EndMacro ; Returns mouse entered widget
    Macro edit_lineDelta( ): text\caret\line[1]: EndMacro ; Returns mouse entered widget
    
    Macro edit_change_text_( _address_, _char_len_ = 0, _position_ = )
      _address_\text\edit#_position_\len + _char_len_
      _address_\text\len = _address_\text\edit[1]\len + _address_\text\edit[3]\len
      _address_\text\string.s = Left( _address_\text\string.s, _address_\text\edit[1]\len ) + Right( _address_\text\string.s, _address_\text\edit[3]\len )
    EndMacro
    
    Macro edit_caret_1( ): text\caret\pos[0]: EndMacro
    Macro edit_caret_2( ): text\caret\pos[1]: EndMacro
    
    ;\\ Macro edit_row_caret_1_( _this_ ): _this_\text\caret\pos[2]: EndMacro
    
    Procedure.l edit_caret_( *this._S_widget )
      ; Get caret position
      Protected i.l, mouse_x.l, caret_x.l, caret.l =- 1
      Protected Distance.f, MinDistance.f = Infinity( )
      
      If *this\EnteredRow( )
        mouse_x = mouse( )\x - row_text_x_( *this, *this\EnteredRow( ) ) - scroll_x_( *this ) 
        
        For i = 0 To *this\EnteredRow( )\text\len
          caret_x = TextWidth( Left( *this\EnteredRow( )\text\string, i ))
          
          Distance = ( mouse_x - caret_x )*( mouse_x - caret_x )
          
          If MinDistance > Distance 
            MinDistance = Distance
            ; *this\text\caret\x = *this\text\padding\x + caret_x
            caret = *this\EnteredRow( )\text\pos + i
          Else
            Break
          EndIf
        Next 
      EndIf
      
      ProcedureReturn caret
    EndProcedure
    
    Procedure   edit_sel_row_text_( *this._S_widget, *rows._S_rows, mode.l = 0 )
      Protected CaretLeftPos, CaretRightPos, CaretLastLen= 0
      Debug "edit_sel_row_text - "+*rows\index +" "+ mode
      
      *this\state\repaint = #True
      ;*rows\color\state = #__s_2
      *rows\state\focus = #True
      
      If mode =- 14 ; ok leave from
        *this\edit_caret_1( ) = *rows\text\pos
        
        ; Debug ""+*this\edit_caret_1( ) +" "+ *rows\text\pos
        CaretLeftPos = 0
        CaretRightPos = 0 
        
      ElseIf mode = #__sel_to_remove ; 
        
        CaretLeftPos = 0
        CaretRightPos = 0 
        *rows\color\state = #__s_0
        *rows\state\focus = #False
        
      ElseIf mode = #__sel_to_set ; 
        
        CaretLeftPos = 0
        CaretRightPos = *rows\text\len  
        CaretLastLen = *this\mode\fullselection
        
      ElseIf mode = #__sel_to_first 
        CaretLeftPos = 0
        If *rows = *this\PressedRow( )
          CaretRightPos = *this\edit_caret_2( ) - *rows\text\pos
        Else
          CaretRightPos = *rows\text\len
          CaretLastLen = *this\mode\fullselection
        EndIf
        *this\edit_caret_1( ) = *rows\text\pos 
        
      ElseIf mode = #__sel_to_last 
        If *rows = *this\PressedRow( )
          CaretLeftPos = *this\edit_caret_2( ) - *rows\text\pos
        Else
          CaretLeftPos = 0
        EndIf
        CaretRightPos = *rows\text\len 
        If *rows\index <> *this\count\items - 1
          CaretLastLen = *this\mode\fullselection
        EndIf
        *this\edit_caret_1( ) = *rows\text\pos + *rows\text\len 
        
      Else
        
        If *this\edit_caret_1( ) >= *this\edit_caret_2( )
          If *rows\text\pos <= *this\edit_caret_2( )
            CaretLeftPos = *this\edit_caret_2( ) - *rows\text\pos
          EndIf
          CaretRightPos = *this\edit_caret_1( ) - *rows\text\pos
        Else
          CaretLeftPos = *this\edit_caret_1( ) - *rows\text\pos
          If *this\edit_caret_2( ) > ( *rows\text\pos + *rows\text\len )
            CaretLastLen = *this\mode\fullselection
            CaretRightPos = *rows\text\len
          Else
            CaretRightPos = *this\edit_caret_2( ) - *rows\text\pos
          EndIf
        EndIf
      EndIf
      
      ; Debug "caret change " + CaretLeftPos +" "+ CaretRightPos
      
      *rows\text\edit[1]\pos = 0 
      *rows\text\edit[2]\pos = CaretLeftPos  ; - *rows\text\pos
      *rows\text\edit[3]\pos = CaretRightPos ; - *rows\text\pos
      
      *rows\text\edit[1]\len = *rows\text\edit[2]\pos
      *rows\text\edit[2]\len = *rows\text\edit[3]\pos - *rows\text\edit[2]\pos
      *rows\text\edit[3]\len = *rows\text\len - *rows\text\edit[3]\pos
      
      ; item left text
      If *rows\text\edit[1]\len > 0
        *rows\text\edit[1]\string = Left( *rows\text\string, *rows\text\edit[1]\len )
        *rows\text\edit[1]\width = TextWidth( *rows\text\edit[1]\string ) 
        *rows\text\edit[1]\y = *rows\text\y
        *rows\text\edit[1]\height = *rows\text\height
      Else
        *rows\text\edit[1]\string = ""
        *rows\text\edit[1]\width = 0
      EndIf
      ; item right text
      If *rows\text\edit[3]\len > 0
        *rows\text\edit[3]\y = *rows\text\y
        *rows\text\edit[3]\height = *rows\text\height
        If *rows\text\edit[3]\len = *rows\text\len
          *rows\text\edit[3]\string = *rows\text\string
          *rows\text\edit[3]\width = *rows\text\width
        Else
          *rows\text\edit[3]\string = Right( *rows\text\string, *rows\text\edit[3]\len )
          *rows\text\edit[3]\width = TextWidth( *rows\text\edit[3]\string )  
        EndIf
      Else
        *rows\text\edit[3]\string = ""
        *rows\text\edit[3]\width = 0
      EndIf
      ; item edit text
      If *rows\text\edit[2]\len > 0
        If *rows\text\edit[2]\len = *rows\text\len
          *rows\text\edit[2]\string = *rows\text\string
          *rows\text\edit[2]\width = *rows\text\width
        Else
          *rows\text\edit[2]\string = Mid( *rows\text\string, 1 + *rows\text\edit[2]\pos, *rows\text\edit[2]\len )
          *rows\text\edit[2]\width = *rows\text\width - ( *rows\text\edit[1]\width + *rows\text\edit[3]\width )
          ; Debug ""+*rows\text\edit[2]\width +" "+ TextWidth( *rows\text\edit[2]\string )
        EndIf
        *rows\text\edit[2]\y = *rows\text\y
        *rows\text\edit[2]\height = *rows\text\height
      Else
        *rows\text\edit[2]\string = ""
        *rows\text\edit[2]\width = 0
      EndIf
      
      If CaretLastLen
        *rows\text\edit[2]\width + CaretLastLen
      EndIf
      
      ; Чтобы знать что строки выделени
      If *rows\text\edit[2]\width
        *this\text\edit[2]\width = *rows\text\edit[2]\width
      EndIf
      
      ; set text position
      *rows\text\edit[1]\x = *rows\text\x
      *rows\text\edit[2]\x = *rows\text\x + *rows\text\edit[1]\width 
      *rows\text\edit[3]\x = *rows\text\x + *rows\text\edit[1]\width + *rows\text\edit[2]\width 
      
      ;       If *this\edit_caret_1( ) > *this\edit_caret_2( )
      ;         *this\text\caret\x = *rows\x + *rows\text\edit[3]\x - 1
      ;       ElseIf *this\edit_caret_1( ) < *this\edit_caret_2( )
      ;         *this\text\caret\x = *rows\x + *rows\text\edit[2]\x - 1
      ;       Else
      ;         If mode = 0
      ;          *this\text\caret\x = *rows\x + *rows\text\edit[2]\x - 1
      ;         EndIf
      ;         If mode = 3
      ;          *this\text\caret\x = *rows\x + *rows\text\edit[2]\x - 1
      ;         EndIf
      ;         If mode = 2
      ;           *this\text\caret\x = *rows\x + *rows\text\edit[3]\x - 1
      ;         EndIf
      ;       EndIf
      ;       *this\text\caret\height = *rows\text\height
      ;       *this\text\caret\y = *rows\y
      ;       
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_sel_text_( *this._S_widget, *line._S_rows )
      ; edit sel all items
      If *line < 0
        PushListPosition( *this\_rows( ) )
        ForEach *this\_rows( )
          edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_last )
        Next
        PopListPosition( *this\_rows( ) )
        
        ; set caret to begin start
        *this\edit_caret_1( ) = 0
        *this\edit_caret_2( ) = *this\text\len
        ;
        *line = *this\FocusedRow( )
      EndIf
      
      If *this\edit_caret_1( ) > *this\edit_caret_2( )
        *this\text\edit[2]\pos = *this\edit_caret_2( )
        *this\text\edit[3]\pos = *this\edit_caret_1( )
        *this\text\caret\x = *line\x + *line\text\edit[3]\x - 1
      Else
        *this\text\edit[2]\pos = *this\edit_caret_1( )
        *this\text\edit[3]\pos = *this\edit_caret_2( )
        *this\text\caret\x = *line\x + *line\text\edit[2]\x - 1
      EndIf
      
      *this\text\caret\height = *line\text\height
      *this\text\caret\y = *line\y
      
      ;       ;*this\text\caret\x = 13
      ;       ;Debug ""+*this\text\padding\x +" "+ *this\text\caret\x +" "+ *this\edit_caret_1( ) +" "+ *line\text\edit[1]\string
      ;       ;Debug TextWidth("W")
      
      ;
      *this\text\edit[1]\len = *this\text\edit[2]\pos
      *this\text\edit[3]\len = ( *this\text\len - *this\text\edit[3]\pos )
      
      If *this\text\edit[2]\len <> ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
        *this\text\edit[2]\len = ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
      EndIf
      
      ; left text
      If *this\text\edit[1]\len > 0
        *this\text\edit[1]\string = Left( *this\text\string.s, *this\text\edit[1]\len ) 
      Else
        *this\text\edit[1]\string = ""
      EndIf
      ; right text
      If *this\text\edit[3]\len > 0
        *this\text\edit[3]\string = Right( *this\text\string.s, *this\text\edit[3]\len )
      Else
        *this\text\edit[3]\string = ""
      EndIf
      ; edit text
      If *this\text\edit[2]\len > 0
        *this\text\edit[2]\string = Mid( *this\text\string.s, 1 + *this\text\edit[2]\pos, *this\text\edit[2]\len ) 
      Else
        *this\text\edit[2]\string = ""
      EndIf
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_sel_pos( *this._S_widget, *entered._S_rows, *pressed._S_rows, caret, reset = 0 )
      Protected result.b, *rows._S_rows
      
      If *this And *entered And *entered\state\enter
        ; Debug ""+caret +" "+ *this\edit_caret_1( ) +" "+ *this\text\caret\x +" "+ *entered\text\edit[3]\x +" "+ *entered\text\width
        If *this\edit_caret_1( ) <> caret Or reset =- 1
          *this\edit_caret_1( ) = caret
          
          If reset > 0
            *this\edit_caret_2( ) = caret
            ;\\ edit_row_caret_1_( *this ) = caret - *entered\text\pos
            *entered\edit_caret_1( ) = caret - *entered\text\pos
            *this\edit_lineDelta( ) = *entered\index
            
            If *this\text\multiLine 
              ForEach *this\_rows( ) 
                If *this\_rows( )\text\edit[2]\width <> 0 
                  ; Debug " remove - " +" "+ *this\_rows( )\text\string
                  edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                EndIf
              Next
            EndIf
            
            *this\FocusedRow( ) = *entered
          EndIf
          
          If *this\FocusedRow( ) <> *entered 
            *this\FocusedRow( ) = *entered
            
            If *this\text\multiLine And *this\PressedRow( )
              ForEach *this\_rows( ) 
                If Bool(( *this\FocusedRow( )\index >= *this\_rows( )\index And 
                          *this\PressedRow( )\index <= *this\_rows( )\index ) Or ; верх
                        ( *this\FocusedRow( )\index <= *this\_rows( )\index And 
                          *this\PressedRow( )\index >= *this\_rows( )\index )) ; вниз
                  
                  ;
                  If *this\_rows( )\index <> *this\PressedRow( )\index And  
                     *this\_rows( )\index <> *this\FocusedRow( )\index 
                    
                    If *this\_rows( )\text\edit[2]\width <> *this\_rows( )\text\width + *this\mode\fullselection
                      Debug "set - " +" "+ *this\_rows( )\text\string
                      edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_set )
                    EndIf
                  EndIf
                Else
                  ;
                  If *this\_rows( )\text\edit[2]\width <> 0 
                    Debug " remove - " +" "+ *this\_rows( )\text\string
                    edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                  EndIf
                EndIf
              Next
            EndIf
          EndIf
          
          result = 1
          edit_sel_row_text_( *this, *entered )
          edit_sel_text_( *this, *entered )
          
          ; *this\edit_linePos( ) = *entered\index
          ; DoEvents( *this, #PB_EventType_StatusChange, *entered\index, *entered )
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    Macro edit_sel_reset_( _address_ )
      _address_\text\edit[1]\len = 0 
      _address_\text\edit[2]\len = 0 
      _address_\text\edit[3]\len = 0 
      
      _address_\text\edit[1]\pos = 0 
      _address_\text\edit[2]\pos = 0 
      _address_\text\edit[3]\pos = 0 
      
      _address_\text\edit[1]\width = 0 
      _address_\text\edit[2]\width = 0 
      _address_\text\edit[3]\width = 0 
      
      _address_\text\edit[1]\string = ""
      _address_\text\edit[2]\string = "" 
      _address_\text\edit[3]\string = ""
    EndMacro
    
    Macro edit_sel_is_line_pos_( _this_ )
      Bool( _this_\_rows( )\text\edit[2]\width And 
            mouse( )\x > _this_\_rows( )\text\edit[2]\x - scroll_x_( _this_ ) And
            mouse( )\y > _this_\_rows( )\text\y - scroll_y_( _this_ ) And 
            mouse( )\y < ( _this_\_rows( )\text\y + _this_\_rows( )\text\height ) - scroll_y_( _this_ ) And
            mouse( )\x < ( _this_\_rows( )\text\edit[2]\x + _this_\_rows( )\text\edit[2]\width ) - scroll_x_( _this_ ) )
    EndMacro
    
    
    Procedure.i edit_sel_start_( *this._S_widget, caret, *rows._S_rows )
      Protected result.i = *rows\text\pos, i.i, char.i
      caret - *rows\text\pos
      
      Macro edit_sel_end_( _char_ )
        Bool(( _char_ >= ' ' And _char_ <= '/' ) Or 
             ( _char_ >= ':' And _char_ <= '@' ) Or 
             ( _char_ >= '[' And _char_ <= 96 ) Or 
             ( _char_ >= '{' And _char_ <= '~' ))
      EndMacro
      
      ; | <<<<<< left edge of the word 
      If caret >= 0 
        For i = caret - 1 To 1 Step - 1
          char = Asc( Mid( *rows\text\string.s, i, 1 ))
          If edit_sel_end_( char )
            result = *rows\text\pos + i
            Break
          EndIf
        Next 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i edit_sel_stop_( *this._S_widget, caret, *rows._S_rows )
      Protected result.i = *rows\text\pos + *rows\text\len, i.i, char.i
      caret - *rows\text\pos
      
      ; >>>>>> | right edge of the word
      For i = caret + 2 To *rows\text\len
        char = Asc( Mid( *rows\text\string.s, i, 1 ))
        If edit_sel_end_( char )
          result = *rows\text\pos + ( i - 1 )
          Break
        EndIf
      Next 
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_row_align( *this._S_widget )
      ; Debug ""+*this\text\align\anchor\left +" "+ *this\text\align\anchor\top +" "+ *this\text\align\anchor\right +" "+ *this\text\align\anchor\bottom
      ; set align position
      ForEach *this\_rows( )
        If *this\vertical
        Else ; horizontal
          If *this\text\rotate = 180
            *this\_rows( )\y - ( *this\height[#__c_inner] - scroll_height_( *this ) )
          EndIf
          
          ; changed
          set_align_y_( *this\text, *this\_rows( )\text, - 1, *this\text\rotate )
          set_align_x_( *this\text, *this\_rows( )\text, scroll_width_( *this ), *this\text\rotate )
          
          ;           If *this\type = #__Type_String
          ;             Debug *this\_rows( )\text\string
          ;           EndIf
        EndIf
      Next 
    EndProcedure
    
    ;-
    Procedure edit_make_text_position( *this._S_widget )
      edit_row_align( *this )
      
      ;
      bar_make_scroll_area( *this )
      
      ; make horizontal scroll x
      make_scrollarea_x( *this, *this\text )
      
      ; make vertical scroll y
      make_scrollarea_y( *this, *this\text )
      
      If *this\scroll\v And 
         bar_SetState( *this\scroll\v\bar, - scroll_y_( *this ) ) 
      EndIf
      
      If *this\scroll\h And 
         bar_SetState( *this\scroll\h\bar, - scroll_x_( *this ) ) 
      EndIf
    EndProcedure
    
    Procedure.s edit_make_insert_text( *this._S_widget, Text.s )
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
              Case '0' To '9', '.','-'
              Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr( Input )
                
              Default
                Input = 0
            EndSelect
            
            If Input
              If \type = #__type_IPAddress
                left.s = Left( \text\string, *this\edit_caret_1( ) )
                Select CountString( left.s, "." )
                  Case 0 : left.s = StringField( left.s, 1, "." )
                  Case 1 : left.s = StringField( left.s, 2, "." )
                  Case 2 : left.s = StringField( left.s, 3, "." )
                  Case 3 : left.s = StringField( left.s, 4, "." )
                EndSelect                                           
                count = Len( left.s + Trim( StringField( Mid( \text\string, *this\edit_caret_1( )  + 1 ), 1, "." ), #LF$ ))
                If count < 3 And ( Val( left.s ) > 25 Or Val( left.s + Chr.s ) > 255 )
                  Continue
                  ;               ElseIf Mid( \text\string, *this\edit_caret_1( ) + 1, 1 ) = "."
                  ;                 *this\edit_caret_1( ) + 1 : *this\edit_caret_2( ) = *this\edit_caret_1( ) 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid( \text\string, *this\edit_caret_1( ) + 1, 1 ) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid( \text\string, *this\edit_caret_1( ) + 1, 1 ) <> " - "
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
          ;For i = 1 To Len : String.s + "●" : Next
          For i = 1 To Len : String.s + "•" : Next
          
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
    
    Procedure.b edit_insert_text( *this._s_widget, Chr.s )
      Protected result.b, String.s, Count.i, *rows._S_rows
      
      Chr.s = edit_make_insert_text( *this, Chr.s)
      
      If Chr.s
        *rows = *this\FocusedRow( )
        If *rows
          Count = CountString( Chr.s, #LF$)
          
          If *this\edit_caret_1( ) > *this\edit_caret_2( ) 
            *this\edit_caret_1( ) = *this\edit_caret_2( ) 
          Else
            *this\edit_caret_2( ) = *this\edit_caret_1( ) 
          EndIf
          
          *this\edit_caret_1( ) + Len( Chr.s )
          *this\edit_caret_2( ) = *this\edit_caret_1( ) 
          
          If count Or *rows\index <> *this\edit_lineDelta( )
            *this\text\change =- 1
          EndIf
          
          If *rows\text\edit[2]\width <> 0 
            *rows\text\edit[2]\len = 0 
            *rows\text\edit[2]\string.s = "" 
          Else
            *rows\text\edit[1]\len + Len( Chr.s )
            *rows\text\edit[1]\string.s + Chr.s
            
            *rows\text\len = *rows\text\edit[1]\len + *rows\text\edit[3]\len 
            *rows\text\string.s = *rows\text\edit[1]\string.s + *rows\text\edit[3]\string.s
            *rows\text\width = TextWidth( *rows\text\string )
          EndIf
          
          *this\text\edit[1]\len + Len( Chr.s )
          *this\text\edit[1]\string.s + Chr.s
          
          *this\text\len = *this\text\edit[1]\len + *this\text\edit[3]\len 
          *this\text\string.s = *this\text\edit[1]\string + *this\text\edit[3]\string
          
          ;
          If *rows\index > *this\edit_lineDelta( )
            *this\edit_linePos( ) = *this\edit_lineDelta( ) + Count
          Else
            *this\edit_linePos( ) = *rows\index + Count
          EndIf
          *this\edit_lineDelta( ) = *this\edit_linePos( )
          
          ; 
          If Not *this\text\change
            If scroll_width_( *this ) < *rows\text\width
              scroll_width_( *this ) = *rows\text\width
              
              bar_make_scroll_area( *this )
            EndIf
          EndIf
          
          result = 1 
        EndIf
      Else
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Macro edit_caret_change_( _this_, _index_ )
      If _this_\edit_lineDelta( ) <> _index_
        _this_\text\change =- 1
      EndIf
      
      If _this_\edit_caret_1( ) > _this_\edit_caret_2( ) 
        _this_\edit_caret_1( ) = _this_\edit_caret_2( ) 
      Else
        _this_\edit_caret_2( ) = _this_\edit_caret_1( ) 
      EndIf
      
      If _this_\edit_lineDelta( ) > _index_
        _this_\edit_linePos( ) = _index_
        _this_\edit_lineDelta( ) = _index_
      Else
        _this_\edit_linePos( ) = _this_\edit_lineDelta( )
      EndIf
    EndMacro
    
    Procedure   edit_key_page_up_down_( *this._S_widget, wheel, row_select )
      Protected repaint, select_index, page_height
      Protected first_index = 0, last_index = *this\count\items - 1
      
      If wheel =- 1 ; page-up
        If row_select
          If row_select > 0
            select_index = *this\VisibleFirstRow( )\index
          Else
            select_index = first_index
          EndIf 
          If *this\FocusedRow( )\index <> select_index
            edit_row_select_( *this, *this\FocusedRow( ), select_index )
            
            If select_index = first_index
              *this\edit_caret_1( ) = 0
            Else  
              ;\\ *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + edit_row_caret_1_( *this )
              *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( )
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint = 1
          EndIf
        Else
          If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos
            *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
            repaint = 1
          EndIf
        EndIf
        
      ElseIf wheel = 1 ; page-down
        If row_select
          If row_select > 0
            select_index = *this\VisibleLastRow( )\index
          Else
            select_index = last_index
          EndIf 
          If *this\FocusedRow( )\index <> select_index
            edit_row_select_( *this, *this\FocusedRow( ), select_index )
            
            If select_index = last_index
              *this\edit_caret_1( ) = *this\text\len 
            Else  
              ;\\ *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + edit_row_caret_1_( *this )
              *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( ) 
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint = 1
          EndIf
        Else
          If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
            *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
            repaint = 1
          EndIf
        EndIf
      EndIf
      
      If repaint
        *this\edit_caret_2( ) = *this\edit_caret_1( )
        *this\edit_linePos( ) = *this\FocusedRow( )\index
        *this\edit_lineDelta( ) = *this\edit_linePos( )
        
        If wheel =- 1
          row_scroll_y_( *this, *this\FocusedRow( ), - page_height )
        ElseIf wheel = 1
          row_scroll_y_( *this, *this\FocusedRow( ), + page_height )
        EndIf
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure   edit_key_caret_move_( *this._S_widget, _top_line_, _bottom_line_, move_position = 0, scroll_row_step = 1 )
      Protected result, caret =- 1
      
      If _top_line_ <> - 1 
        ; left in line
        If move_position And 
           *this\edit_caret_1( ) > *this\FocusedRow( )\text\pos 
          caret = *this\edit_caret_1( ) - move_position
          ;\\ edit_row_caret_1_( *this ) = caret - *this\FocusedRow( )\text\pos
          *this\FocusedRow( )\edit_caret_1( ) = caret - *this\FocusedRow( )\text\pos
          result = 1
        EndIf
        
        If result = 0
          ; prev line
          If *this\FocusedRow( )\index > _top_line_ 
            If *this\FocusedRow( )
              edit_row_select_( *this, *this\FocusedRow( ), *this\FocusedRow( )\index - scroll_row_step )
            EndIf
            
            If move_position
              ; перешли снизу верх
              caret = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len 
            Else
              ;\\ caret = *this\FocusedRow( )\text\pos + edit_row_caret_1_( *this )
              caret = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( )
            EndIf
            
            result =- 1
          Else
            ; first line
            If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos
              caret = *this\FocusedRow( )\text\pos
              result = 1
            EndIf
          EndIf
        EndIf
        
      ElseIf _bottom_line_ <> - 1
        ; right in line
        If move_position And 
           *this\edit_caret_1( ) < *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len 
          caret = *this\edit_caret_1( ) + move_position
          ;\\ edit_row_caret_1_( *this ) = caret - *this\FocusedRow( )\text\pos
          *this\FocusedRow( )\edit_caret_1( ) = caret - *this\FocusedRow( )\text\pos
          result = 1
        EndIf
        
        If result = 0
          ; next line
          If *this\FocusedRow( )\index < _bottom_line_
            If *this\FocusedRow( )
              edit_row_select_( *this, *this\FocusedRow( ), *this\FocusedRow( )\index + scroll_row_step )
            EndIf
            
            If move_position
              ; перешли сверху с конца вниз
              caret = *this\FocusedRow( )\text\pos 
            Else
              ;\\ caret = *this\FocusedRow( )\text\pos + edit_row_caret_1_( *this )
              caret = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( )
            EndIf
            
            result =- 1
          Else
            ; last line
            If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
              caret = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
              result = 1
            EndIf
          EndIf
        EndIf
      EndIf
      
      If result
        If *this\FocusedRow( ) <> *this\_rows( )
          *this\FocusedRow( ) = *this\_rows( ) ; SelectElement( *this\_rows( ), *this\FocusedRow( )\index )
        EndIf             
        
        If keyboard( )\key[1] & #PB_Canvas_Shift
          Protected *entered._s_rows = *this\FocusedRow( ) ; SelectElement( *this\_rows( ), *this\FocusedRow( )\index )
          Protected *pressed._s_rows = *this\PressedRow( ) ; SelectElement( *this\_rows( ), *this\edit_lineDelta( ) )
          edit_sel_pos( *this, *entered, *pressed, caret )
          Debug 7777
        Else
          *this\edit_caret_1( ) = caret
          *this\edit_caret_2( ) = *this\edit_caret_1( )
          
          *this\edit_linePos( ) = *this\FocusedRow( )\index 
          *this\edit_lineDelta( ) = *this\edit_linePos( )
        EndIf
        
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure   edit_key_home_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control 
        If *this\edit_caret_1( ) <> 0
          *this\edit_caret_1( ) = 0
          *this\edit_linePos( ) = 0
          
          Debug "key ctrl home"
          result = 1
        EndIf
      Else
        If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos
          *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
          *this\edit_linePos( ) = *this\FocusedRow( )\index
          
          Debug "key home"
          result = 1
        EndIf
      EndIf
      
      If result
        *this\edit_caret_2( ) = *this\edit_caret_1( ) 
        *this\edit_lineDelta( ) = *this\edit_linePos( )
        ;\\ edit_row_caret_1_( *this ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
        *this\FocusedRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_key_end_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control 
        If *this\edit_caret_1( ) <> *this\text\len 
          *this\edit_caret_1( ) = *this\text\len 
          *this\edit_linePos( ) = *this\count\items - 1
          
          Debug "key ctrl end"
          result = 1
        EndIf
      Else
        If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
          *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len 
          *this\edit_linePos( ) = *this\FocusedRow( )\index
          
          Debug "key end"
          result = 1
        EndIf
      EndIf
      
      If result
        *this\edit_caret_2( ) = *this\edit_caret_1( )
        *this\edit_lineDelta( ) = *this\edit_linePos( )
        ;\\ edit_row_caret_1_( *this ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
        *this\FocusedRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_key_backup_( *this._S_widget )
      Protected Repaint, remove_chr_len, *rows._S_rows = *this\FocusedRow( ) 
      
      If *this\text\edit[2]\len
        edit_caret_change_( *this, *rows\index )
        
        remove_chr_len = 0
        edit_change_text_( *rows, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint =- 1
        
      ElseIf *this\edit_caret_1( ) > *rows\text\pos 
        *this\edit_caret_1( ) - 1 
        *this\edit_caret_2( ) = *this\edit_caret_1( ) 
        *this\edit_linePos( ) = *rows\index
        
        remove_chr_len = 1
        edit_change_text_( *rows, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint =- 1
      Else
        If *rows\index > 0
          remove_chr_len = Len( #LF$ )
          *this\edit_caret_1( ) - remove_chr_len
          *this\edit_caret_2( ) = *this\edit_caret_1( ) 
          
          *this\edit_linePos( ) = *rows\index - 1
          *this\edit_lineDelta( ) = *this\edit_linePos( )
          *this\text\change =- 1 
          ;Row( *this )\count = 0
          
          edit_change_text_( *rows, - remove_chr_len, [1] )
          edit_change_text_( *this, - remove_chr_len, [1] )
          Repaint =- 1
          
        Else
          *this\notify = 2
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   edit_key_delete_( *this._S_widget )
      Protected Repaint, remove_chr_len, *rows._S_rows = *this\FocusedRow( )
      
      If *this\text\edit[2]\len
        edit_caret_change_( *this, *rows\index )
        
        remove_chr_len = 1
        Repaint =- 1
        
      ElseIf *this\edit_caret_1( ) < *this\text\len ; ok
        If *this\edit_caret_1( ) = *rows\text\pos + *rows\text\len
          remove_chr_len = Len( #LF$ )
          *this\text\change =- 1
        Else
          remove_chr_len = 1
        EndIf
        
        ;Debug ""+*this\edit_caret_1( ) +" "+ *this\text\len
        ; change caret
        *this\edit_linePos( ) = *rows\index
        *this\edit_lineDelta( ) = *rows\index
        
        Repaint =- 1
      EndIf
      
      If Repaint
        edit_change_text_( *rows, - remove_chr_len, [3] )
        edit_change_text_( *this, - remove_chr_len, [3] )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   edit_key_return_( *this._S_widget ) 
      Protected *rows._S_rows 
      
      If *this\text\multiline
        *rows._S_rows = *this\FocusedRow( ) 
        
        If *this\edit_lineDelta( ) >= *rows\index 
          If *this\edit_caret_1( ) > *this\edit_caret_2( ) 
            *this\edit_caret_1( ) = *this\edit_caret_2( ) 
          EndIf
          *this\edit_caret_1( ) + Len( #LF$ )
          *this\edit_caret_2( ) = *this\edit_caret_1( )
          *this\edit_linePos( ) = *rows\index + 1
        Else
          *this\edit_caret_2( ) + Len( #LF$ )
          *this\edit_caret_1( ) = *this\edit_caret_2( )
          *this\edit_linePos( ) = *this\edit_lineDelta( ) + 1
        EndIf
        *this\edit_lineDelta( ) = *this\edit_linePos( )
        
        ; Debug ""+*this\edit_caret_1( ) +" "+ *this\edit_caret_2( ) +" "+ *this\edit_linePos( ) +" "+ *this\edit_lineDelta( )
        
        *this\text\string.s = *this\text\edit[1]\string + #LF$ + *this\text\edit[3]\string
        *this\text\change =- 1 
        
        ;         
        ;         _AddItem( *this, *this\edit_lineDelta( ), *rows\text\edit[3]\string )
        ;         
        ;         *this\text\string.s = *this\text\edit[1]\string + #LF$ + *rows\text\edit[3]\string + #LF$ + Right( *this\text\string.s, *this\text\len - (*rows\text\pos + *rows\text\len + 1))
        ;         *rows\text\edit[3]\len = Len( #LF$ )
        ;         *rows\text\edit[3]\string = #LF$
        ;         *rows\text\len = *rows\text\edit[1]\len + *rows\text\edit[3]\len
        ;         *rows\text\string.s = *rows\text\edit[1]\string + *rows\text\edit[3]\string
        ;          *this\text\change = 0
        ;          *this\change = 0  
        ;          
        ; ;                 ForEach *this\_rows( )
        ; ;                   Debug *this\_rows( )\text\string
        ; ;                 Next
        
        ProcedureReturn - 1
      Else
        *this\notify = 3
      EndIf
    EndProcedure
    
    
    ;-
    Procedure   edit_AddItem( *this._S_widget, List rows._S_rows( ), position, *text.Character, string_len )
      Protected *rows._S_rows
      Protected add_index =- 1, add_y, add_pos, add_height
      
      If position < 0 Or position > ListSize( rows( )) - 1
        LastElement( rows( ))
        *rows = AddElement( rows( )) 
        
        ;If position < 0 
        position = ListIndex( rows( ))
        ;EndIf
        
      Else
        
        *rows = SelectElement( rows( ), position )
        add_index = rows( )\index
        add_y = rows( )\y           + Bool( #PB_Compiler_OS = #PB_OS_Windows )
        add_pos = rows( )\text\pos
        add_height = rows( )\height + *this\mode\gridlines 
        *rows = InsertElement( rows( ))
        
        PushListPosition( rows( )) 
        While NextElement( rows( )) 
          rows( )\index = ListIndex( rows( ) )
          rows( )\y + add_height 
          rows( )\text\pos + string_len + Len( #LF$ )
        Wend
        PopListPosition(rows( ))
        
        
        ;         *rows = SelectElement( rows( ), position )
        ;         add_index = rows( )\index
        ;         add_y = rows( )\y
        ;         add_pos = rows( )\text\pos
        ;         add_height = rows( )\height
        ;         PushListPosition( rows( )) 
        ;         Repeat 
        ;           rows( )\index = ListIndex( rows( ) ) + 1 
        ;           rows( )\y + add_height
        ;           rows( )\text\pos + string_len + Len( #LF$ )
        ;         Until Not NextElement( rows( ))
        ;         PopListPosition(rows( ))
        ;         *rows = InsertElement( rows( ))
      EndIf
      
      rows( )\index = position
      rows( )\text\len = string_len
      rows( )\text\string = PeekS ( *text, string_len )
      
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;         StopDrawing( )
      ;         StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ) )
      ;         DrawingFont( *this\_root( )\text\fontid )
      ;       CompilerEndIf
      draw_font_item_( *this, rows( ), rows( )\text\change )
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;         StopDrawing( )
      ;       CompilerEndIf
      
      rows( )\height = rows( )\text\height ; + 10
      rows( )\width = *this\width[#__c_inner]
      rows( )\color = _get_colors_( )
      ;rows( )\color\back = $FFF9F9F9
      
      ; make line position
      If *this\vertical
      Else ; horizontal
        If scroll_width_( *this ) < rows( )\text\width + *this\text\padding\x*2
          scroll_width_( *this ) = rows( )\text\width + *this\text\padding\x*2
        EndIf
        
        If *this\text\rotate = 0
          If add_index >= 0
            rows( )\text\pos = add_pos 
            rows( )\y = add_y                                                                     - *this\text\padding\y
          Else
            rows( )\text\pos = *this\text\len 
            rows( )\y = scroll_height_( *this )                                                   - *this\text\padding\y
          EndIf
        ElseIf *this\text\rotate = 180
          rows( )\y = ( *this\height[#__c_inner] - scroll_height_( *this ) - rows( )\text\height ) + *this\text\padding\y 
        EndIf
        
        scroll_height_( *this ) + rows( )\height + *this\mode\gridlines
      EndIf
      
      *this\count\items + 1
      *this\text\len + string_len + Len( #LF$ )
      *this\text\string = InsertString( *this\text\string, rows( )\text\string + #LF$, 1 + rows( )\text\pos )
      
      ;       If *this\type = #__Type_Editor
      ;         ; Debug "e - "+rows( )\text\pos +" "+ rows( )\text\string +" "+ rows( )\y +" "+ rows( )\width +" "+ rows( )\height
      ;         ;  Debug "e - "+rows( )\text\pos +" "+ rows( )\text\string +" "+ rows( )\text\y +" "+ rows( )\text\width +" "+ rows( )\text\height
      ;       EndIf
      ;       
      ;       
      *this\text\change = 0
      *this\change = 0
      
      ; ;       If scroll_height_( *this ) > *this\height[#__c_inner]; bar_make_scroll_area( *this )
      ; ;         PostCanvasRepaint( *this\_root( ) ) 
      ; ;       EndIf
    EndProcedure
    
    Procedure   edit_ClearItems( *this._S_widget )
      *this\count\items = 0
      *this\text\change =- 1
      *this\text\string = ""
      
      If *this\text\editable
        *this\edit_caret_1( ) = 0
        *this\edit_caret_2( ) = 0
        *this\edit_lineDelta( ) = 0
        *this\edit_linePos( ) = 0
      EndIf
      
      PostCanvasRepaint( *this\_root( ) ) ;?
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_RemoveItem( *this._S_widget, item )
      *this\count\items - 1
      
      If *this\count\items =- 1 
        edit_ClearItems( *this )
      Else
        *this\text\change =- 1
        *this\text\string = RemoveString( *this\text\string, StringField( *this\text\string, item + 1, #LF$ ) + #LF$ )
        
        If ListSize( *this\_rows( ) )
          SelectElement( *this\_rows( ), item  )
          DeleteElement( *this\_rows( ), 1 )
        EndIf
      EndIf
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_SetText( *this._S_widget, text.s )
      ; If Text.s = "" : Text.s = #LF$ : EndIf
      Text.s = ReplaceString( Text.s, #LFCR$, #LF$ )
      Text.s = ReplaceString( Text.s, #CRLF$, #LF$ )
      Text.s = ReplaceString( Text.s, #CR$, #LF$ )
      
      If *this\text\multiline = 0
        Text.s = edit_make_insert_text( *this, Text.s )
        Text.s = RemoveString( Text.s, #LF$ )
      EndIf
      
      ;       If *this\text\rotate = 180
      ;         *this\scroll\v\bar\invert = 1
      ;       EndIf
      
      Protected string.s = text.s + #LF$
      Protected *str.Character = @string
      Protected *end.Character = @string
      
      *this\text\len  = 0
      *this\text\string = ""
      
      scroll_width_( *this ) = *this\text\padding\x*2
      scroll_height_( *this ) = *this\text\padding\y*2 
      
      Protected enter_index =- 1: If *this\EnteredRow( ): enter_index = *this\EnteredRow( )\index: *this\EnteredRow( ) = #Null: EndIf
      Protected focus_index =- 1: If *this\FocusedRow( ): focus_index = *this\FocusedRow( )\index: *this\FocusedRow( ) = #Null: EndIf
      Protected press_index =- 1: If *this\PressedRow( ): press_index = *this\PressedRow( )\index: *this\PressedRow( ) = #Null: EndIf
      
      If *this\count\items
        *this\count\items = 0
        ClearList( *this\_rows( ))
      Else
        Protected count = 1
      EndIf
      
      ;        CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;             StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ) )
      ;             draw_font_( *this )
      ;             StopDrawing( )
      ;           CompilerEndIf
      
      While *end\c 
        If *end\c = #LF 
          edit_AddItem( *this, *this\_rows( ), - 1, *str, (*end-*str)>>#PB_Compiler_Unicode )
          
          If enter_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If focus_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If press_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          
          *str = *end + #__sOC 
        EndIf 
        *end + #__sOC 
      Wend
      
      *this\text\len - Len( #LF$ )
      *this\text\string = Left( *this\text\string, *this\text\len )
      
      *this\text\change = 0
      *this\change = 0
      
      If count
        *this\text\edit\string = *this\text\string 
      EndIf
      
      ;Debug ""+scroll_height_( *this ) +" "+ scroll_width_( *this )
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_SetItemState( *this._S_widget, Item.l, State.i )
      Protected result
      
      With *this
        If state < 0 Or 
           state > *this\text\len
          state = *this\text\len
        EndIf
        
        If *this\edit_caret_2( ) <> State
          Protected i.l, len.l
          Protected *str.Character = @\text\string 
          Protected *end.Character = @\text\string 
          
          While *end\c 
            If *end\c = #LF 
              i + 1
              len + ( *end - *str )/#__sOC
              ; Debug "" + Item + " " + Str( len + Item )  + " " +  state
              
              If i = Item 
                EnteredRowindex( *this ) = Item
                PressedRowindex( *this ) = Item
                
                *this\edit_caret_1( ) = state
                *this\edit_caret_2( ) = *this\edit_caret_1( )
                *this\edit_caret_2( ) = *this\edit_caret_1( ) + len + Item
                
                Break
              EndIf
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If PressedRowindex( *this ) <> Item 
            PressedRowindex( *this ) = Item
            EnteredRowindex( *this ) = Item
            
            *this\edit_caret_1( ) = state
            *this\edit_caret_2( ) = *this\edit_caret_1( )
            *this\edit_caret_2( ) = *this\edit_caret_1( ) + len + Item
          EndIf
        EndIf
        
        ; ;       PushListPosition( *this\_rows( ))
        ; ;       result = SelectElement( *this\_rows( ), Item ) 
        ; ;       
        ; ;       If result 
        ; ;         \index[1] = *this\_rows( )\index
        ; ;         \index[2] = *this\_rows( )\index
        ; ;         \row\index = *this\_rows( )\index
        ; ;        ; *this\edit_caret_1( ) = State
        ; ;        ; *this\edit_caret_2( ) = *this\edit_caret_1( ) 
        ; ;       EndIf
        ; ;       PopListPosition( *this\_rows( ))
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure   Editor_Update( *this._S_widget, List row._S_rows( ))
      With *this
        
        If *this\change > 0
          If #debug_update_text
            Debug "*this\change > 0 - " + #PB_Compiler_Procedure
          EndIf
          
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s="", String1.s, CountString
          Protected IT, len.l, Position.l, width
          Protected ColorFont = \color\front[Bool( *this\__state & #__ss_front ) * \color\state]
          
          If *this\text\multiLine
            ; make multiline text
            Protected text$ 
            
            If *this\text\multiLine > 0
              String = *this\text\string.s
            Else
              ; \max 
              If *this\vertical
                If scroll_height_( *this ) > *this\height[#__c_inner]
                  *this\text\change = #__text_update
                EndIf
                Width = *this\height[#__c_inner] - *this\text\padding\x*2
                
              Else
                If scroll_width_( *this ) > *this\width[#__c_inner]
                  *this\text\change = #__text_update
                EndIf
                
                width = *this\width[#__c_inner] - *this\text\padding\x*2 
              EndIf
              
              ; make word wrap text
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found=0, length
              Protected$ line$, DelimList$ = " " + Chr( 9 ), nl$ = #LF$
              text$ = *this\text\edit\string.s + #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; If width
              While *end\c 
                If *end\c = #LF
                  start = ( *end - *str ) >> #PB_Compiler_Unicode
                  line$ = PeekS ( *str, start )
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth( RTrim( Left( line$, length ) ))
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString( " ", Mid( line$, found,1 ))
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left( line$, start ) + nl$
                    line$ = LTrim( Mid( line$, start + 1 ))
                    start = Len( line$ )
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth( RTrim( Left( line$, length ) ))
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
              ;EndIf
            EndIf
            ;             String = Trim( String, #LF$  )
            ;             Debug ClearDebugOutput()
            ;             Debug width
            ;  Debug CountString( string, #LF$ )
            ;           Else
            ;             String.s = RemoveString( *this\text\string, #LF$ )
          EndIf
          
          If *this\change > 0
            *this\text\change = 1
          EndIf
          
        EndIf
        
        If *this\text\change
          edit_SetText( *this, string ) 
          
          ; Debug *this\text\string
          
          edit_make_text_position( *this )
        EndIf
        
        
      EndWith
    EndProcedure
    
    Procedure   Editor_Draw( *this._S_widget )
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT,Text_Y,Text_x, x,Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Make output multi line text
          If *this\change > 0
            Editor_Update( *this, *this\_rows( ))
            
            If *this\edit_linePos( )
              Debug " key - update draw lines"
            Else
              Debug " edit update draw lines"
            EndIf
          EndIf
          
          ;;;;;;;;;;;;;;;;;;;;
          If *this\state\create
            edit_make_text_position( *this )
            ; Debug *this\class +" "+ *this\class
            ;If *this\state\repaint
            ;EndIf
            *this\state\create = 0
          EndIf
          ;
          ; then change text update cursor pos
          If *this\text\editable
            If *this\edit_linePos( ) >= 0
              If Not ( *this\FocusedRow( ) And *this\FocusedRow( )\index = *this\edit_linePos( ) )
                *this\FocusedRow( ) = SelectElement( *this\_rows( ), *this\edit_linePos( ) )
              EndIf
              Debug "    key - change caret pos " + ListSize( *this\_rows( ) ) +" "+ *this\FocusedRow( )\index +" "+ *this\edit_lineDelta( )
              
              ;
              edit_sel_row_text_( *this, *this\FocusedRow( ) )
              edit_sel_text_( *this, *this\FocusedRow( ) )
              
              ;
              ; edit_make_text_position( *this )
              ;               ;bar_make_scroll_area( *this )
              ;               make_scrollarea_x( *this, *this\text )
              ;               If *this\scroll\h And 
              ;                  bar_SetState( *this\scroll\h\bar, -scroll_x_( *this ) ) 
              ;               EndIf
              
              If *this\scroll\v And Not *this\scroll\v\hide
                If *this\FocusedRow( )\y + scroll_y_( *this ) < 0 Or 
                   *this\FocusedRow( )\y + *this\FocusedRow( )\height + scroll_y_( *this ) > *this\height[#__c_inner]
                  
                  If *this\FocusedRow( )\y + scroll_y_( *this ) < 0
                    Debug "       key - scroll ^"
                  ElseIf *this\FocusedRow( )\y + *this\FocusedRow( )\height + scroll_y_( *this ) > *this\height[#__c_inner]
                    Debug "       key - scroll v"
                  EndIf
                  
                  ;row_scroll_y_( *this, *this\FocusedRow( ) )
                  bar_scroll_pos_( *this\scroll\v, *this\text\caret\y, *this\text\caret\height ) ; ok
                EndIf
              EndIf
              
              If *this\scroll\h And Not *this\scroll\h\hide
                If *this\text\caret\x + scroll_x_( *this ) < 0 Or 
                   *this\text\caret\x + *this\text\caret\width + scroll_x_( *this ) > *this\width[#__c_inner]
                  
                  If *this\text\caret\x + scroll_x_( *this ) < 0
                    Debug "       key - scroll <"
                  ElseIf *this\text\caret\x + *this\text\caret\width + scroll_x_( *this ) > *this\width[#__c_inner]
                    Debug "       key - scroll >"
                  EndIf
                  
                  ; bar_scroll_pos_( *this\scroll\h, (*this\text\caret\x - *this\text\padding\x), ( *this\text\padding\x * 2 + *this\row\margin\width )) ; ok
                  bar_scroll_pos_( *this\scroll\h, *this\text\caret\x, *this\text\caret\width ) ; ok
                EndIf
              EndIf
              
              
              *this\edit_linePos( ) =- 1
            EndIf
          EndIf
          
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           drawing_mode_( #PB_2DDrawing_Gradient )
          ;           draw_gradient_( \vertical, *this,\color\fore[\color\state],\color\back[\color\state], [#__c_frame] )
          ;         Else
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back[0] )
          ;         EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If ( \text\change Or \resize )
              \row\margin\x = \x[#__c_inner]
              \row\margin\y = \y[#__c_inner]
              \row\margin\height = \height[#__c_inner]
            EndIf
            
            ; Draw margin
            drawing_mode_alpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
            draw_box_( \row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back )
          EndIf
          
          ; widget inner coordinate
          ix = \x[#__c_inner] + \row\margin\width 
          iY = \y[#__c_inner]
          iwidth = \width[#__c_inner]
          iheight = \height[#__c_inner]
          
          
          Protected result, scroll_x, scroll_y, scroll_x_, scroll_y_
          Protected visible_items_y.l = 0, visible_items_height
          
          If *this\scroll\v
            scroll_y_ = *this\scroll\v\bar\page\pos
          EndIf
          
          If *this\scroll\h
            scroll_x_ = *this\scroll\h\bar\page\pos
          EndIf
          
          If Not visible_items_y
            visible_items_y = 0;*this\y[#__c_inner] ; *this\y[#__c_draw] ; 
          EndIf
          If Not visible_items_height
            If *this\height[#__c_draw] > *this\height[#__c_inner]
              visible_items_height = *this\height[#__c_inner] ; 
            Else
              visible_items_height = *this\height[#__c_draw]
            EndIf
          EndIf
          
          scroll_x = scroll_x_( *this )
          scroll_y = scroll_y_( *this )
          
          ; Debug ""+ scroll_x +" "+ scroll_x_ +" "+ scroll_y +" "+ scroll_y_
          
          ; Draw Lines text
          If \count\items
            *this\VisibleFirstRow( ) = 0
            *this\VisibleLastRow( ) = 0
            
            PushListPosition( *this\_rows( ))
            ForEach *this\_rows( )
              ; Is visible lines - -  - 
              *this\_rows( )\visible = Bool( Not *this\_rows( )\hide And 
                                             (( *this\_rows( )\y - scroll_y_ ) < visible_items_y + visible_items_height ) And
                                             ( *this\_rows( )\y + *this\_rows( )\height - scroll_y_ ) > visible_items_y )
              
              
              ; Draw selections
              If *this\_rows( )\visible 
                If Not *this\VisibleFirstRow( )
                  *this\VisibleFirstRow( ) = *this\_rows( )
                EndIf
                *this\VisibleLastRow( ) = *this\_rows( )
                
                
                
                
                
                
                
                Y = row_y_( *this, *this\_rows( ) ) + scroll_y
                Text_x = row_text_x_( *this, *this\_rows( ) ) + scroll_x
                Text_Y = row_text_y_( *this, *this\_rows( ) ) + scroll_y
                
                Protected sel_text_x1 = edit_row_edit_text_x_( *this, [1] ) + scroll_x
                Protected sel_text_x2 = edit_row_edit_text_x_( *this, [2] ) + scroll_x
                Protected sel_text_x3 = edit_row_edit_text_x_( *this, [3] ) + scroll_x
                
                Protected sel_x = \x[#__c_inner] + *this\text\x
                Protected sel_width = \width[#__c_inner] - *this\text\y*2
                
                Protected text_sel_state_2 = 0;2 + Bool( *this\state\focus = #False )
                Protected text_sel_width = *this\_rows( )\text\edit[2]\width + Bool( *this\state\focus = #False ) * *this\text\caret\width
                
                ;                 ;                 If *this\PressedRow( ) = *this\_rows( );Keyboard()\key And *this\_rows( )\color\state
                ;                 ;                   Debug "state - "+*this\_rows( )\index +" "+ *this\_rows( )\color\state
                ;                 ;                 EndIf
                ;                 ;                 
                ;                 ;                 If *this\text\caret\y+1 + scroll_y = y
                ;                 ;                   ;Debug " state "+ *this\_rows( )\index +" "+ *this\_rows( )\color\state; text_enter_state = 1
                ;                 ;                   text_enter_state = 1
                ;                 ;                 EndIf
                ;                 If *this\_rows( )\color\state = 2
                ;                   ; Debug *this\_rows( )\index
                ;                   
                ;                 EndIf
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный 
                  ; фон отличный от заднего фона едитора
                  If *this\_rows( )\color\back  
                    ;                     drawing_mode_alpha_( #PB_2DDrawing_Default )
                    ;                     draw_roundbox_( sel_x,Y,sel_width ,*this\_rows( )\height, *this\_rows( )\round,*this\_rows( )\round, *this\_rows( )\color\back[0] )
                    
                    If *this\color\back And 
                       *this\color\back <> *this\_rows( )\color\back
                      ; Draw margin back color
                      If *this\row\margin\width > 0
                        ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                        drawing_mode_alpha_( #PB_2DDrawing_Default )
                        draw_box_( *this\row\margin\x, *this\_rows( )\y, *this\row\margin\width, *this\_rows( )\height, *this\row\margin\color\back )
                        Line( *this\x[#__c_inner] + *this\row\margin\width, *this\_rows( )\y, 1, *this\_rows( )\height, *this\color\back ) ; $FF000000 );
                      EndIf
                    EndIf
                  EndIf
                  
                  ;                   If *this\_rows( )\state\press
                  ;                     *this\_rows( )\color\state = 0
                  ;                   ElseIf *this\_rows( )\state\enter ;And *this\state\press
                  ;                     *this\_rows( )\color\state = 1
                  ;                   Else
                  ;                     *this\_rows( )\color\state = 0
                  ;                   EndIf
                  
                  Protected text_enter_state = Bool( *this\_rows( )\color\state = 1 Or *this\_rows( ) = *this\PressedRow( ))
                  ;Bool( *this\_rows( ) = *this\EnteredRow( ) ); *this\_rows( )\color\state ; Bool( *this\_rows( )\color\state = 1 Or *this\_rows( ) = *this\PressedRow( ))
                  
                  ; text_enter_state = Bool(*this\_rows( ) = *this\FocusedRow( )) ; *this\_rows( )\color\state ; Bool( *this\_rows( )\color\state ) ; Bool( *this\_rows( )\index = *this\EnteredRow( )\index ) + Bool( *this\_rows( )\index = *this\EnteredRow( )\index And *this\state\focus = #False )*2
                  ; Draw entered selection
                  If text_enter_state = 1
                    If *this\_rows( )\color\back[text_enter_state] <>- 1              ; no draw transparent
                      drawing_mode_alpha_( #PB_2DDrawing_Default )
                      draw_roundbox_( sel_x,Y,sel_width ,*this\_rows( )\height, *this\_rows( )\round,*this\_rows( )\round, *this\_rows( )\color\back[text_enter_state] )
                    EndIf
                    
                    If *this\_rows( )\color\frame[text_enter_state] <>- 1 ; no draw transparent
                      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
                      draw_roundbox_( sel_x,Y,sel_width ,*this\_rows( )\height, *this\_rows( )\round,*this\_rows( )\round, *this\_rows( )\color\frame[text_enter_state] )
                    EndIf
                  EndIf
                EndIf
                
                ;Debug *this\_rows( )\color\state
                Protected text_sel_state = *this\color\state
                Protected text_no_sel_state = 0
                
                ; Draw text
                ; Draw string
                If *this\text\editable And 
                   *this\_rows( )\text\edit[2]\width And 
                   *this\_rows( )\color\front[2] <> *this\color\front
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    If *this\_rows( )\text\string.s
                      drawing_mode_alpha_( #PB_2DDrawing_Transparent )
                      DrawRotatedText( Text_x, Text_Y, *this\_rows( )\text\string.s, *this\text\rotate, *this\_rows( )\color\front[text_no_sel_state] )
                    EndIf
                    
                    If *this\_rows( )\text\edit[2]\width
                      drawing_mode_alpha_( #PB_2DDrawing_Default )
                      draw_box_( sel_text_x2, Y, text_sel_width, *this\_rows( )\height, *this\_rows( )\color\back[text_sel_state] )
                    EndIf
                    
                    drawing_mode_alpha_( #PB_2DDrawing_Transparent )
                    
                    ; to right select
                    If ( EnteredRowindex( *this ) > PressedRowindex( *this ) Or 
                         ( EnteredRowindex( *this ) = PressedRowindex( *this ) And *this\edit_caret_1( ) > *this\edit_caret_2( ) ))
                      
                      If *this\_rows( )\text\edit[2]\string.s
                        DrawRotatedText( sel_text_x2, Text_Y, *this\_rows( )\text\edit[2]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_sel_state] )
                      EndIf
                      
                      ; to left select
                    Else
                      If *this\_rows( )\text\edit[2]\string.s
                        DrawRotatedText( Text_x, Text_Y, *this\_rows( )\text\edit[1]\string.s + *this\_rows( )\text\edit[2]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_sel_state] )
                      EndIf
                      
                      If *this\_rows( )\text\edit[1]\string.s
                        DrawRotatedText( Text_x, Text_Y, *this\_rows( )\text\edit[1]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_no_sel_state] )
                      EndIf
                    EndIf
                    
                  CompilerElse
                    If *this\_rows( )\text\edit[2]\width
                      drawing_mode_alpha_( #PB_2DDrawing_Default )
                      draw_box_( sel_text_x2, Y, text_sel_width, *this\_rows( )\height, *this\_rows( )\color\back[text_sel_state] )
                    EndIf
                    
                    drawing_mode_alpha_( #PB_2DDrawing_Transparent )
                    
                    If *this\_rows( )\text\edit[1]\string.s
                      DrawRotatedText( sel_text_x1, Text_Y, *this\_rows( )\text\edit[1]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_no_sel_state] )
                    EndIf
                    If *this\_rows( )\text\edit[2]\string.s
                      DrawRotatedText( sel_text_x2, Text_Y, *this\_rows( )\text\edit[2]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_sel_state] )
                    EndIf
                    If *this\_rows( )\text\edit[3]\string.s
                      DrawRotatedText( sel_text_x3, Text_Y, *this\_rows( )\text\edit[3]\string.s, *this\text\rotate, *this\_rows( )\color\front[text_no_sel_state] )
                    EndIf
                  CompilerEndIf
                  
                Else
                  If *this\_rows( )\text\edit[2]\width
                    drawing_mode_alpha_( #PB_2DDrawing_Default )
                    draw_box_( sel_text_x2, Y, text_sel_width, *this\_rows( )\height, $FFFBD9B7 );*this\_rows( )\color\back[2] )
                  EndIf
                  
                  If *this\color\state = 2
                    drawing_mode_( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, *this\_rows( )\text\string.s, *this\text\rotate, *this\_rows( )\color\front[text_sel_state_2] )
                  Else
                    drawing_mode_( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, *this\_rows( )\text\string.s, *this\text\rotate, *this\_rows( )\color\front[*this\_rows( )\color\state] )
                  EndIf
                EndIf
                
                ; Draw margin text
                If *this\row\margin\width > 0
                  drawing_mode_( #PB_2DDrawing_Transparent )
                  DrawRotatedText( *this\_rows( )\margin\x + Bool( *this\vertical ) * scroll_x,
                                   *this\_rows( )\margin\y + Bool( Not *this\vertical ) * scroll_y, 
                                   *this\_rows( )\margin\string, *this\text\rotate, *this\row\margin\color\front )
                EndIf
                
                ; Horizontal line
                If *this\mode\GridLines And
                   *this\_rows( )\color\line And 
                   *this\_rows( )\color\line <> *this\_rows( )\color\back 
                  drawing_mode_alpha_( #PB_2DDrawing_Default )
                  draw_box_( row_x_( *this, *this\_rows( ) ), y + *this\_rows( )\height, *this\_rows( )\width, *this\mode\GridLines, $fff0f0f0 )
                EndIf
              EndIf
            Next
            PopListPosition( *this\_rows( )) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And *this\state\focus
            drawing_mode_( #PB_2DDrawing_XOr )             
            draw_box_( *this\x[#__c_inner] + *this\text\caret\x + scroll_x, *this\y[#__c_inner] + *this\text\caret\y + scroll_y, *this\text\caret\width, *this\text\caret\height, $FFFFFFFF )
          EndIf
          
          ; Draw frames
          If *this\notify
            drawing_mode_( #PB_2DDrawing_Outlined )
            draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round, $FF0000FF )
            If \round : draw_roundbox_( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round, $FF0000FF ) : EndIf  ; Сглаживание краев ) ))
          ElseIf *this\bs
            drawing_mode_( #PB_2DDrawing_Outlined )
            draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\frame[\color\state] )
            If \round : draw_roundbox_( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round,\color\front[\color\state] ) : EndIf  ; Сглаживание краев ) ))
          EndIf
          
          ; Draw scroll bars
          bar_area_draw_( *this )
          
          If *this\text\change : *this\text\change = 0 : EndIf
          If *this\change : *this\change = 0 : EndIf
          ;;;If *this\resize : *this\resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure   Editor_Events_Key( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Static _caret_last_pos_, DoubleClick.i
      Protected Repaint.i, Caret.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\_rows( )\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
      Protected page_height = *this\height[#__c_inner]
      
      With *this
        Select EventType
          Case #PB_EventType_Input ;;- Input ( key )
            If Not Keyboard( )\key[1] & #PB_Canvas_Control   ; And Not Keyboard( )\key[1] & #PB_Canvas_Shift
              If Not *this\notify And Keyboard( )\input
                
                Repaint = edit_insert_text( *this, Chr( Keyboard( )\input ))
                
              EndIf
            EndIf
            
          Case #PB_EventType_KeyUp
            ; Чтобы перерисовать 
            ; рамку вокруг едитора 
            ; reset all errors
            If \notify 
              \notify = 0
              ProcedureReturn - 1
            EndIf
            
            Protected *item._S_ROWS 
            
          Case #PB_EventType_KeyDown
            Select Keyboard( )\key
              Case #PB_Shortcut_Home 
                Repaint = edit_key_home_( *this )
                
              Case #PB_Shortcut_End 
                Repaint = edit_key_end_( *this )
                
              Case #PB_Shortcut_PageUp   
                Debug "key PageUp"
                Repaint = edit_key_page_up_down_( *this, - 1, 1 ) 
                
              Case #PB_Shortcut_PageDown 
                Debug "key PageDown"
                Repaint = edit_key_page_up_down_( *this, 1, 1 ) 
                
              Case #PB_Shortcut_Up       ; Ok
                                         ; Repaint = edit_key_caret_move_( *this, _line_first_, -1 )
                If *this\FocusedRow( )\index > 0
                  
                  *item = SelectElement( *this\_rows( ), *this\FocusedRow( )\index - 1 )
                  If *this\FocusedRow( ) <> *item 
                    If *this\FocusedRow( )
                      *this\FocusedRow( )\color\state = #__s_0
                      
                      caret = *this\edit_caret_1( )
                      
                      If keyboard( )\key[1] & #PB_Canvas_Shift
                        If *this\FocusedRow( ) = *this\PressedRow( )
                          ;Debug " le top remove - Pressed  " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_first )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        ElseIf *this\FocusedRow( )\index > *this\PressedRow( )\index 
                          ;Debug "  le top remove - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_remove )
                          edit_sel_text_( *this, SelectElement(*this\_rows(), *this\FocusedRow( )\index - 1))
                        Else
                          ;Debug " ^le bottom  set - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_set )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        EndIf
                      EndIf
                    EndIf
                    
                    *this\FocusedRow( ) = *item
                    If *this\FocusedRow( )
                      *this\FocusedRow( )\color\state = #__s_1
                      *this\edit_caret_1( ) = caret - *this\FocusedRow( )\text\len - 1
                      
                      If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                        ; вызывать если только строки выделени 
                        If *this\text\edit[2]\width <> 0 
                          If *this\text\multiLine 
                            PushListPosition( *this\_rows( ) )
                            ForEach *this\_rows( ) 
                              If *this\_rows( )\text\edit[2]\width <> 0 
                                ; Debug " remove - " +" "+ *this\_rows( )\text\string
                                edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                              EndIf
                            Next
                            PopListPosition( *this\_rows( ) )
                          EndIf
                        EndIf
                        
                        If *this\PressedRow( ) And 
                          *this\PressedRow( )\state\press
                          *this\PressedRow( )\state\press = #False
                        EndIf
                        *this\PressedRow( ) = *this\FocusedRow( )
                        *this\PressedRow( )\state\press = #True
                        
                        *this\edit_caret_2( ) = *this\edit_caret_1( )
                      EndIf
                      
                      edit_sel_row_text_( *this, *this\FocusedRow( ) )
                      edit_sel_text_( *this, *this\FocusedRow( ) )
                    EndIf
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                                         ;\\ Repaint = edit_key_caret_move_( *this, -1, _line_last_ )
                If *this\FocusedRow( )\index < *this\count\items - 1
                  
                  *item = SelectElement( *this\_rows( ), *this\FocusedRow( )\index + 1 )
                  If *this\FocusedRow( ) <> *item 
                    If *this\FocusedRow( )
                      *this\FocusedRow( )\color\state = #__s_0
                      
                      caret = *this\edit_caret_1( ) + *this\FocusedRow( )\text\len + 1
                      
                      If keyboard( )\key[1] & #PB_Canvas_Shift
                        If *this\FocusedRow( ) = *this\PressedRow( )
                          ;Debug " le bottom  set - Pressed  " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_last )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        ElseIf *this\FocusedRow( )\index < *this\PressedRow( )\index
                          ;Debug "  ^le top remove - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_remove )
                          edit_sel_text_( *this, SelectElement(*this\_rows(), *this\FocusedRow( )\index + 1))
                        Else
                          ;Debug " le bottom  set - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_set )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        EndIf
                      EndIf
                    EndIf
                    
                    *this\FocusedRow( ) = *item
                    If *this\FocusedRow( )
                      *this\FocusedRow( )\color\state = #__s_1
                      
                      *this\edit_caret_1( ) = caret
                      
                      If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                        ; вызывать если только строки выделени 
                        If *this\text\edit[2]\width <> 0 
                          Debug 8998899
                          If *this\text\multiLine 
                            PushListPosition( *this\_rows( ) )
                            ForEach *this\_rows( ) 
                              If *this\_rows( )\text\edit[2]\width <> 0 
                                ; Debug " remove - " +" "+ *this\_rows( )\text\string
                                edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                              EndIf
                            Next
                            PopListPosition( *this\_rows( ) )
                          EndIf
                        EndIf
                        
                        If *this\PressedRow( ) And 
                          *this\PressedRow( )\state\press
                          *this\PressedRow( )\state\press = #False
                        EndIf
                        *this\PressedRow( ) = *this\FocusedRow( )
                        *this\PressedRow( )\state\press = #True
                        
                        *this\edit_caret_2( ) = *this\edit_caret_1( )
                      EndIf
                      
                      edit_sel_row_text_( *this, *this\FocusedRow( ) )
                      edit_sel_text_( *this, *this\FocusedRow( ) )
                    EndIf
                  EndIf
                  
                  
                  
                  
                  
                EndIf
                
                
                
                
                
                
              Case #PB_Shortcut_Left     ; Ok
                Repaint = edit_key_caret_move_( *this, _line_first_, -1, #True )
                
              Case #PB_Shortcut_Right    ; Ok
                Repaint = edit_key_caret_move_( *this, -1, _line_last_, #True )
                
                
              Case #PB_Shortcut_Back   
                If Not \notify
                  Repaint = edit_key_backup_( *this )
                EndIf
                
              Case #PB_Shortcut_Delete
                If Not \notify
                  Repaint = edit_key_delete_( *this )
                EndIf
                
              Case #PB_Shortcut_Return 
                If Not \notify
                  Repaint = edit_key_return_( *this )
                EndIf
                
                
              Case #PB_Shortcut_A        ; Ok
                If Keyboard( )\key[1] & #PB_Canvas_Control
                  If *this\text\edit[2]\len <> *this\text\len
                    
                    ; select first and last items
                    *this\FocusedRow( ) = SelectElement( *this\_rows( ), 0 )
                    *this\edit_lineDelta( ) = *this\count\items - 1 
                    
                    edit_sel_text_( *this, - 1 )
                    
                    Repaint = 1
                  EndIf
                EndIf
                
              Case #PB_Shortcut_C, #PB_Shortcut_X
                If Keyboard( )\key[1] & #PB_Canvas_Control
                  SetClipboardText( *this\text\edit[2]\string )
                  
                  If Keyboard( )\key = #PB_Shortcut_X
                    edit_ClearItems( *this )
                  EndIf
                EndIf
                
              Case #PB_Shortcut_V
                ; edit_key_v_
                If Keyboard( )\key[1] & #PB_Canvas_Control 
                  If *this\text\editable
                    Protected Text.s = GetClipboardText( )
                    
                    If Not *this\text\multiLine
                      Text = ReplaceString( Text, #LFCR$, #LF$ )
                      Text = ReplaceString( Text, #CRLF$, #LF$ )
                      Text = ReplaceString( Text, #CR$, #LF$ )
                      Text = RemoveString( Text, #LF$ )
                    EndIf
                    
                    Repaint = edit_insert_text( *this, Text )
                  EndIf
                EndIf  
                
            EndSelect 
            
            Select Keyboard( )\key
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
    
    Procedure   Editor_Events( *this._S_widget, eventtype.l, *item._S_rows, item =- 1 )
      Static DoubleClick.i = -1
      Protected Repaint.i, Caret.i, _line_.l, String.s
      Protected *currentRow._S_rows, mouse_x.l = mouse( )\x, mouse_y.l = mouse( )\y
      Static click_time
      
      
      With *this
        
        If *this\row
          ; edit key events
          If eventtype = #PB_EventType_Input Or
             eventtype = #PB_EventType_KeyDown Or
             eventtype = #PB_EventType_KeyUp
            
            Repaint | Editor_Events_Key( *this, eventtype, mouse( )\x, mouse( )\y )
          EndIf
        EndIf
        
      EndWith
      
      If *this\text\change 
        *this\change = 1
      EndIf
      
      If Repaint
        ; *this\state\repaint = #True
        PushListPosition( *this\_rows( ) )
        ; DoEvents( *this, #PB_EventType_StatusChange, 0, 0 )
        
        If *this\text\change
          DoEvents( *this, #PB_EventType_Change, 0, 0 )
        EndIf
        PopListPosition( *this\_rows( ) )
      EndIf  
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;- 
    ;-  TREE
    Declare.l Tree_Draw( *this._S_widget )
    Declare tt_close( *this._S_tt )
    
    Procedure tt_tree_Draw( *this._S_tt, *color._S_color = 0 )
      With *this
        If *this And PB(IsGadget)( \gadget ) And StartDrawing( CanvasOutput( \gadget ))
          If Not *color
            *color = \color
          EndIf
          
          ;_draw_font_( *this )
          If \text\fontID 
            DrawingFont( \text\fontID ) 
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_( 0,1,\width,\height - 2, *color\back[*color\state] )
          drawing_mode_( #PB_2DDrawing_Transparent )
          DrawText( \text\x, \text\y, \text\string, *color\front[*color\state] )
          drawing_mode_( #PB_2DDrawing_Outlined )
          Line( 0,0,\width,1, *color\frame[*color\state] )
          Line( 0,\height - 1,\width,1, *color\frame[*color\state] )
          Line( \width - 1,0,1,\height, *color\frame[*color\state] )
          StopDrawing( )
        EndIf 
      EndWith
    EndProcedure
    
    Procedure tt_tree_callBack( )
      ;     ;SetActiveWindow( EventWidget( )\_root( )\canvas\window )
      ;     ;SetActiveGadget( EventWidget( )\_root( )\canvas\gadget )
      ;     
      ;     If FocusedRow( EventWidget( ) )
      ;       FocusedRow( EventWidget( ) )\color\state = 0
      ;     EndIf
      ;     
      ;     FocusedRow( EventWidget( ) ) = EventWidget( )*this\_rows( )
      ;     EventWidget( )*this\_rows( )\color\state = 2
      ;     EventWidget( )\color\state = 2
      ;     
      ;     ;Tree_reDraw( EventWidget( ))
      
      tt_close( GetWindowData( EventWindow( ) ))
    EndProcedure
    
    Procedure tt_creare( *this._S_widget, x,y )
      With *this
        If *this
          EventWidget( ) = *this
          \row\_tt.allocate( TT )
          \row\_tt\visible = 1
          \row\_tt\x = x + *this\_rows( )\x + *this\_rows( )\width - 1
          \row\_tt\y = y + *this\_rows( )\y - \scroll\v\bar\page\pos
          
          \row\_tt\width = *this\_rows( )\text\width - \width[#__c_inner] + ( *this\_rows( )\text\x - *this\_rows( )\x ) + 5 ; -  ( scroll_width_( *this ) - *this\_rows( )\width )  ; - 32 + 5 
          
          If \row\_tt\width < 6
            \row\_tt\width = 0
          EndIf
          
          ;Debug \row\_tt\width ;Str( *this\_rows( )\text\x - *this\_rows( )\x )
          
          \row\_tt\height = *this\_rows( )\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\_tt\window = OpenWindow( #PB_Any, \row\_tt\x, \row\_tt\y, \row\_tt\width, \row\_tt\height, "", 
                                        #PB_Window_BorderLess | #PB_Window_NoActivate | flag, WindowID( \_root( )\canvas\window ))
          
          \row\_tt\gadget = CanvasGadget( #PB_Any,0,0, \row\_tt\width, \row\_tt\height )
          \row\_tt\color = *this\_rows( )\color
          \row\_tt\text = *this\_rows( )\text
          \row\_tt\text\fontID = *this\_rows( )\text\fontID
          \row\_tt\text\x =- ( \width[#__c_inner] - ( *this\_rows( )\text\x - *this\_rows( )\x )) + 1
          \row\_tt\text\y = ( *this\_rows( )\text\y - *this\_rows( )\y ) + \scroll\v\bar\page\pos
          
          BindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), \row\_tt\window )
          SetWindowData( \row\_tt\window, \row\_tt )
          tt_tree_Draw( \row\_tt )
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close( *tt._S_tt )
      If IsWindow( *tt\window )
        *tt\visible = 0
        ; UnbindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), *tt\window )
        CloseWindow( *tt\window )
        ; ClearStructure( *this, _S_tt ) ;??????
      EndIf
    EndProcedure
    
    ;- 
    Procedure.l _update_items_( *this._S_widget, _change_ = 1 )
      Protected state.b, x.l,y.l
      
      With *this
        If Not *this\hide
          ; update coordinate
          If _change_ > 0
            ;Debugger( )
            Debug "   "+#PB_Compiler_Procedure +"( )"
            
            ; if the item list has changed
            scroll_x_( *this ) = 0
            scroll_y_( *this ) = 0
            scroll_width_( *this ) = 0
            scroll_height_( *this ) = 0
            ;*this\scroll\v\bar\page\pos = 0
            
            ; reset item z - order
            Protected buttonpos = 6
            Protected buttonsize = 9
            Protected boxpos = 4
            Protected boxsize = 11
            Protected bs = Bool( *this\fs )
            
            PushListPosition( *this\_rows( ))
            ForEach *this\_rows( )
              *this\_rows( )\index = ListIndex( *this\_rows( ))
              
              If *this\_rows( )\hide
                *this\_rows( )\visible = 0
              Else
                If _change_ > 0
                  ; check box size
                  If ( *this\mode\check = #__m_checkselect Or 
                       *this\mode\check = #__m_optionselect )
                    *this\_rows( )\checkbox\width = boxsize
                    *this\_rows( )\checkbox\height = boxsize
                  EndIf
                  
                  ; collapse box size
                  If ( *this\mode\lines Or *this\mode\buttons ) And
                     Not ( *this\_rows( )\sublevel And *this\mode\check = #__m_optionselect )
                    *this\_rows( )\collapsebox\width = buttonsize
                    *this\_rows( )\collapsebox\height = buttonsize
                  EndIf
                  
                  ; drawing item font
                  draw_font_item_( *this, *this\_rows( ), *this\_rows( )\text\change )
                  
                  ; draw items height
                  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                    CompilerIf Subsystem("qt")
                      *this\_rows( )\height = *this\_rows( )\text\height - 1
                    CompilerElse
                      *this\_rows( )\height = *this\_rows( )\text\height + 3
                    CompilerEndIf
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
                    *this\_rows( )\height = *this\_rows( )\text\height + 4
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
                    If *this\type = #__type_ListView
                      *this\_rows( )\height = *this\_rows( )\text\height
                    Else
                      *this\_rows( )\height = *this\_rows( )\text\height + 2
                    EndIf
                  CompilerEndIf
                  
                  If *this\_rows( )\x <> bs
                    *this\_rows( )\x = bs
                  EndIf
                  
                  If *this\_rows( )\width <> *this\width[#__c_inner] - bs*2
                    *this\_rows( )\width = *this\width[#__c_inner] - bs*2
                  EndIf
                  
                  *this\_rows( )\y = scroll_height_( *this )
                EndIf
                
                ; sublevel position
                *this\_rows( )\sublevelsize = *this\_rows( )\sublevel * *this\row\sublevelsize + Bool( *this\mode\check ) * (boxpos + boxsize) + Bool( *this\mode\lines Or *this\mode\buttons ) * ( buttonpos + buttonsize )
                
                ; check & option box position
                If ( *this\mode\check = #__m_checkselect Or 
                     *this\mode\check = #__m_optionselect )
                  
                  If *this\_rows( )\parent\row And *this\mode\check = #__m_optionselect
                    *this\_rows( )\checkbox\x = *this\_rows( )\sublevelsize - *this\_rows( )\checkbox\width
                  Else
                    *this\_rows( )\checkbox\x = boxpos
                  EndIf
                  *this\_rows( )\checkbox\y = ( *this\_rows( )\height ) - ( *this\_rows( )\height + *this\_rows( )\checkbox\height )/2
                EndIf
                
                ; expanded & collapsed box position
                If ( *this\mode\lines Or *this\mode\buttons ) And Not ( *this\_rows( )\sublevel And *this\mode\check = #__m_optionselect )
                  
                  If *this\mode\check = #__m_optionselect
                    *this\_rows( )\collapsebox\x = *this\_rows( )\sublevelsize - 10
                  Else
                    *this\_rows( )\collapsebox\x = *this\_rows( )\sublevelsize - (( buttonpos + buttonsize ) - 4)
                  EndIf
                  
                  *this\_rows( )\collapsebox\y = ( *this\_rows( )\height ) - ( *this\_rows( )\height + *this\_rows( )\collapsebox\height )/2
                EndIf
                
                ; image position
                If *this\_rows( )\image\id
                  *this\_rows( )\image\x = *this\_rows( )\sublevelsize + *this\image\padding\x + 2
                  *this\_rows( )\image\y = ( *this\_rows( )\height - *this\_rows( )\image\height )/2
                EndIf
                
                ; text position
                If *this\_rows( )\text\string
                  *this\_rows( )\text\x = *this\_rows( )\sublevelsize + *this\row\margin\width + *this\text\padding\x
                  *this\_rows( )\text\y = ( *this\_rows( )\height - *this\_rows( )\text\height )/2
                EndIf
                
                If *this\_rows( )\text\edit\string
                  If *this\bar
                    *this\_rows( )\text\edit\x = *this\_rows( )\text\x + *this\bar\page\pos
                  Else
                    *this\_rows( )\text\edit\x = *this\_rows( )\text\x
                  EndIf
                  *this\_rows( )\text\edit\y = *this\_rows( )\text\y
                EndIf
                
                ; vertical & horizontal scroll max value
                If _change_ > 0
                  scroll_height_( *this ) + *this\_rows( )\height + Bool( *this\_rows( )\index <> *this\count\items - 1 ) * *this\mode\GridLines
                  
                  ;;If *this\scroll\h
                  If scroll_width_( *this ) < ( *this\_rows( )\text\x + *this\_rows( )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ); - *this\x[#__c_inner]
                    scroll_width_( *this ) = ( *this\_rows( )\text\x + *this\_rows( )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ) ; - *this\x[#__c_inner]
                                                                                                                                                            ;;EndIf
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition( *this\_rows( ))
            
            ; change vertical scrollbar max
            If *this\scroll\v\bar\max <> scroll_height_( *this ) And
               bar_SetAttribute( *this\scroll\v, #__bar_Maximum, scroll_height_( *this ) )
              
              bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
              *this\width[#__c_inner] = *this\scroll\h\bar\page\len
              *this\height[#__c_inner] = *this\scroll\v\bar\page\len
            EndIf
            
            ; change horizontal scrollbar max
            If *this\scroll\h\bar\max <> scroll_width_( *this ) And
               bar_SetAttribute( *this\scroll\h, #__bar_Maximum, scroll_width_( *this ) )
              
              bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
              *this\width[#__c_inner] = *this\scroll\h\bar\page\len
              *this\height[#__c_inner] = *this\scroll\v\bar\page\len
            EndIf
            
            *this\change =- 2
          EndIf 
          
          ; SetState( )
          If *this\FocusedRow( ) And 
             *this\scroll\state =- 1
            *this\scroll\state = #True
            
            ;row_scroll_y_( *this, *this\FocusedRow( ) )
            bar_scroll_pos_( *this\scroll\v, *this\FocusedRow( )\index * *this\FocusedRow( )\height + ( *this\scroll\v\height + *this\FocusedRow( )\height ) / 2, 0 )
            
            *this\scroll\v\change = 0 
          EndIf
          
        EndIf  
      EndWith
      
    EndProcedure
    
    Procedure.l update_visible_items_( *this._S_widget, visible_items_height.l = 0 )
      Protected result, scroll_y = *this\scroll\v\bar\page\pos
      Protected visible_items_y.l = 0
      
      PushListPosition( *this\_rows( ))
      
      If Not visible_items_y
        visible_items_y = 0;*this\y[#__c_inner] ; *this\y[#__c_draw] ; 
      EndIf
      If Not visible_items_height
        If *this\height[#__c_draw] > *this\height[#__c_inner]
          visible_items_height = *this\height[#__c_inner] ; 
        Else
          visible_items_height = *this\height[#__c_draw]
        EndIf
      EndIf
      
      ; reset draw list
      ClearList( *this\VisibleRows( ))
      *this\VisibleFirstRow( ) = 0
      *this\VisibleLastRow( ) = 0
      
      ForEach *this\_rows( )
        *this\_rows( )\visible = Bool( Not *this\_rows( )\hide And 
                                       (( *this\_rows( )\y - scroll_y ) < visible_items_y + visible_items_height ) And
                                       ( *this\_rows( )\y + *this\_rows( )\height - scroll_y ) > visible_items_y )
        
        ; add new draw list
        If *this\_rows( )\visible And 
           AddElement( *this\VisibleRows( ))
          *this\VisibleRows( ) = *this\_rows( )
          
          If Not *this\VisibleFirstRow( )
            *this\VisibleFirstRow( ) = *this\_rows( )
            ; Debug ""+*this\VisibleFirstRow( )\x+" "+*this\VisibleFirstRow( )\y 
          EndIf
          *this\VisibleLastRow( ) = *this\_rows( )
          
          ; Debug ""+*this\VisibleLastRow( )\index +" "+ *this\VisibleLastRow( )\y
          result = 1
        EndIf
      Next
      
      PopListPosition( *this\_rows( ))
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Tree_Draw( *this._S_widget )
      Protected state.b, x.l,y.l, scroll_x, scroll_y
      
      With *this
        If Not \hide
          _update_items_( *this, *this\change )
          
          If *this\change < 0
            update_visible_items_( *this )
          EndIf
          
          ; Draw background
          If *this\color\_alpha
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_( *this\x[#__c_inner],*this\y[#__c_inner], *this\width[#__c_inner],*this\height[#__c_inner], *this\round,*this\round,*this\color\back[*this\color\state] )
          EndIf
          
          ; Draw background image
          If *this\image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *this\image\id, *this\image\x, *this\image\y, *this\color\_alpha )
          EndIf
          
          ;
          ;Clip( *this, [#__c_draw2] )
          
          
          draw_items_( *this, *this\VisibleRows( ), *this\scroll\h\bar\page\pos, *this\scroll\v\bar\page\pos )
          
          ; Draw scroll bars
          bar_area_draw_( *this )
          
          ; Draw frames
          If *this\fs
            drawing_mode_( #PB_2DDrawing_Outlined )
            draw_box( *this, color\frame, [#__c_frame] )
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.i Tree_AddItem( *this._S_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected *rows._S_rows, last, *last_row._S_rows, *parent_row._S_rows
      ; sublevel + 1
      
      ;With *this
      If *this
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize( *this\_rows( )) - 1
          LastElement( *this\_rows( ))
          *rows = AddElement( *this\_rows( )) 
          
          If position < 0 
            position = ListIndex( *this\_rows( ))
          EndIf
        Else
          *rows = SelectElement( *this\_rows( ), position )
          
          ; for the tree( )
          If sublevel > *this\_rows( )\sublevel
            PushListPosition( *this\_rows( ))
            If PreviousElement( *this\_rows( ))
              *this\row\last_add = *this\_rows( )
              ;;NextElement( *this\_rows( ))
            Else
              last = *this\row\last_add
              sublevel = *this\_rows( )\sublevel
            EndIf
            PopListPosition( *this\_rows( ))
          Else
            last = *this\row\last_add
            sublevel = *this\_rows( )\sublevel
          EndIf
          
          *rows = InsertElement( *this\_rows( ))
        EndIf
        ;}
        
        If *rows
          ;*rows\index = ListIndex( *this\_rows( ) )
          
          If sublevel > position
            sublevel = position
          EndIf
          
          If *this\row\last_add 
            If sublevel > *this\row\last_add\sublevel
              sublevel = *this\row\last_add\sublevel + 1
              *parent_row = *this\row\last_add
              
            ElseIf *this\row\last_add\parent\row 
              If sublevel > *this\row\last_add\parent\row\sublevel 
                *parent_row = *this\row\last_add\parent\row
                
              ElseIf sublevel < *this\row\last_add\sublevel 
                If *this\row\last_add\parent\row\parent\row
                  *parent_row = *this\row\last_add\parent\row\parent\row
                  
                  While *parent_row 
                    If sublevel >= *parent_row\sublevel 
                      If sublevel = *parent_row\sublevel 
                        *parent_row = *parent_row\parent\row
                      EndIf
                      Break
                    Else
                      *parent_row = *parent_row\parent\row
                    EndIf
                  Wend
                EndIf
                
                ; for the editor( )
                If *this\row\last_add\parent\row 
                  If *this\row\last_add\parent\row\sublevel = sublevel 
                    ;                     *rows\before = *this\row\last_add\parent\row
                    ;                     *this\row\last_add\parent\row\after = *rows
                    
                    If *this\type = #__type_Editor
                      *parent_row = *this\row\last_add\parent\row
                      *parent_row\last = *rows
                      *this\row\last_add = *parent_row
                      last = *parent_row
                    EndIf
                    
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          If *parent_row
            *parent_row\count\childrens + 1
            *rows\parent\row = *parent_row
          EndIf
          
          If sublevel
            *rows\sublevel = sublevel
          EndIf
          
          If last
            ; *this\row\last_add = last
          Else
            *this\row\last_add = *rows
          EndIf
          
          ; for the tree( )
          If *this\row\last_add\parent\row And
             *this\row\last_add\parent\row\sublevel < sublevel
            *this\row\last_add\parent\row\last = *this\row\last_add
          EndIf
          
          If *this\row\last_add\sublevel = 0
            *this\row\last = *this\row\last_add
          EndIf
          
          If position = 0
            *this\row\first = *rows
          EndIf
          
          If *this\mode\collapse And *rows\parent\row And 
             *rows\sublevel > *rows\parent\row\sublevel
            *rows\parent\row\collapsebox\___state= 1 
            *rows\hide = 1
          EndIf
          
          ; properties
          If *this\flag & #__tree_property
            If *parent_row And Not *parent_row\sublevel And Not *parent_row\text\fontID
              *parent_row\color\back = $FFF9F9F9
              *parent_row\color\back[1] = *parent_row\color\back
              *parent_row\color\back[2] = *parent_row\color\back
              *parent_row\color\frame = *parent_row\color\back
              *parent_row\color\frame[1] = *parent_row\color\back
              *parent_row\color\frame[2] = *parent_row\color\back
              *parent_row\color\front[1] = *parent_row\color\front
              *parent_row\color\front[2] = *parent_row\color\front
              *parent_row\text\fontID = FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic ))
            EndIf
          EndIf
          
          ; add lines
          *rows\color = _get_colors_( )
          *rows\color\state = 0
          *rows\color\back = 0 
          *rows\color\frame = 0
          
          *rows\color\fore[0] = 0 
          *rows\color\fore[1] = 0
          *rows\color\fore[2] = 0
          *rows\color\fore[3] = 0
          
          If Text
            *rows\text\change = 1
            *rows\text\string = StringField( Text.s, 1, #LF$ )
            *rows\text\edit\string = StringField( Text.s, 2, #LF$ )
          EndIf
          
          set_image_( *this, *rows\Image, Image )
          
          If *this\FocusedRow( ) 
            *this\FocusedRow( )\color\state = #__S_0
            
            *this\FocusedRow( ) = *rows 
            *this\FocusedRow( )\state\flag | #__S_select
            *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            
            ;             PostCanvasRepaint( *this\_root( ) )
          EndIf
          
          If *this\scroll\state = #True
            *this\scroll\state =- 1
          EndIf
          *this\count\items + 1
          *this\change = 1
        EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *this\count\items - 1
    EndProcedure
    
    Procedure.l Tree_events_Key( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected result, from =- 1
      Static cursor_change, Down, *rows_selected._S_rows
      
      With *this
        Select eventtype 
          Case #PB_EventType_KeyDown
            
            Select Keyboard( )\key
              Case #PB_Shortcut_PageUp
                If bar_SetState( *this\scroll\v\bar, 0 ) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\end ) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\FocusedRow( )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\FocusedRow( )\index > 0
                    ; select modifiers key
                    If ( Keyboard( )\key = #PB_Shortcut_Home Or
                         ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                      SelectElement( *this\_rows( ), 0 )
                    Else
                      _select_prev_item_( *this\_rows( ), *this\FocusedRow( )\index )
                    EndIf
                    
                    If *this\FocusedRow( ) <> *this\_rows( )
                      *this\FocusedRow( )\color\state = 0
                      *this\FocusedRow( )  = *this\_rows( )
                      *this\_rows( )\color\state = 2
                      *rows_selected = *this\_rows( )
                      
                      If *this\_rows( )\y + scroll_y_( *this ) <= 0
                        *this\change =- row_scroll_y_( *this, *this\FocusedRow( ) )
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\FocusedRow( )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    
                    If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\FocusedRow( )\index < ( *this\count\items - 1 )
                    ; select modifiers key
                    If ( Keyboard( )\key = #PB_Shortcut_End Or
                         ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                      SelectElement( *this\_rows( ), ( *this\count\items - 1 ))
                    Else
                      _select_next_item_( *this\_rows( ), *this\FocusedRow( )\index )
                    EndIf
                    
                    If *this\FocusedRow( ) <> *this\_rows( )
                      *this\FocusedRow( )\color\state = 0
                      *this\FocusedRow( )  = *this\_rows( )
                      *this\_rows( )\color\state = 2
                      *rows_selected = *this\_rows( )
                      
                      If *this\_rows( )\y >= *this\height[#__c_inner]
                        *this\change =- row_scroll_y_( *this, *this\FocusedRow( ) )
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  *this\change = bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end/10 )) 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  *this\change = bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end/10 )) 
                  result = 1
                EndIf
                
            EndSelect
            
            ;EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Tree_events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      
      ;
      If eventtype = #PB_EventType_LeftButtonDown
        If *this\EnteredRow( ) 
          
          ; collapsed/expanded button
          If *this\EnteredRow( )\count\childrens And 
             is_at_point_( *this\EnteredRow( )\collapsebox, mouse_x - *this\EnteredRow( )\x, mouse_y - *this\EnteredRow( )\y )
            
            If *this\EnteredRow( )\collapsebox\___state 
              Repaint | SetItemState( *this, *this\EnteredRow( )\index, #__tree_expanded )
            Else
              Repaint | SetItemState( *this, *this\EnteredRow( )\index, #__tree_collapsed )
            EndIf
          Else
            ; change box ( option&check )
            If is_at_point_( *this\EnteredRow( )\checkbox, mouse_x - *this\EnteredRow( )\x, mouse_y - *this\EnteredRow( )\y )
              ;Row( *this )\box\___state= 1
              
              ; change box option
              If *this\mode\check = #__m_optionselect
                If *this\EnteredRow( )\parent\row And *this\EnteredRow( )\option_group  
                  If *this\EnteredRow( )\option_group\parent\row And 
                     *this\EnteredRow( )\option_group\checkbox\___state
                    *this\EnteredRow( )\option_group\checkbox\___state= #PB_Checkbox_Unchecked
                  EndIf
                  
                  If *this\EnteredRow( )\option_group\option_group <> *this\EnteredRow( )
                    If *this\EnteredRow( )\option_group\option_group
                      *this\EnteredRow( )\option_group\option_group\checkbox\___state= #PB_Checkbox_Unchecked
                    EndIf
                    *this\EnteredRow( )\option_group\option_group = *this\EnteredRow( )
                  EndIf
                EndIf
              EndIf
              
              ; change box check
              set_check_state_( *this\EnteredRow( )\checkbox, *this\mode\threestate )
              
              ;
              If *this\EnteredRow( )\color\state = #__S_2 
                Post( *this, #PB_EventType_Change, *this\EnteredRow( )\index )
              EndIf
            EndIf
            
            
            If *this\mode\check = #__m_clickselect
              If *this\EnteredRow( )\state\press = #True
                *this\EnteredRow( )\state\press = #False
              Else
                *this\EnteredRow( )\state\press = #True
              EndIf
              
              *this\FocusedRow( ) = *this\EnteredRow( )
              
            Else
              ; reset selected items
              ForEach *this\_rows( )
                If *this\_rows( ) <> *this\EnteredRow( ) And 
                   *this\_rows( )\state\press = #True
                  *this\_rows( )\state\press = #False
                  *this\_rows( )\color\state = #__S_0
                EndIf
              Next
              
              If *this\FocusedRow( ) <> *this\EnteredRow( )
                *this\FocusedRow( ) = *this\EnteredRow( )
                *this\EnteredRow( )\state\press = #True
              EndIf
            EndIf
            
            ; set draw color state
            If *this\EnteredRow( )\state\press = #True 
              ;               If *this\EnteredRow( )\color\state <> #__S_2
              ;                 *this\EnteredRow( )\color\state = #__S_2
              ;                 
              ;                 Post( *this, #PB_EventType_Change, *this\EnteredRow( )\index )
              ;                 
              ;               EndIf
            Else
              *this\EnteredRow( )\color\state = #__S_1
            EndIf
          EndIf
          
          ; Repaint = #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If *this\EnteredRow( ) And
           *this\EnteredRow( )\state\enter  
          
          If *this\EnteredRow( )\color\state = #__S_0
            *this\EnteredRow( )\color\state = #__S_1
            
            ; Post event item status change
            Post( *this, #PB_EventType_StatusChange, *this\EnteredRow( )\index )
            ; Repaint = #True 
          Else
            If *this\EnteredRow( )\count\childrens And 
               is_at_point_( *this\EnteredRow( )\collapsebox, 
                             mouse_x + *this\scroll\h\bar\page\pos - *this\EnteredRow( )\x,
                             mouse_y + *this\scroll\v\bar\page\pos - *this\EnteredRow( )\y )
              
              Post( *this, #PB_EventType_Up, *this\EnteredRow( )\index )
            Else
              ;;;;;Post( *this, #PB_EventType_LeftClick, *this\EnteredRow( )\index )
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If eventtype = #PB_EventType_RightButtonUp Or
         eventtype = #PB_EventType_LeftDoubleClick
        
        Post( *this, eventtype, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      
      ; mouse wheel verticl and horizontal
      If eventtype = #PB_EventType_MouseWheelX
        ;         If mouse( )\wheel\x > 0
        ;           ;Post( *this\scroll\h, #PB_EventType_Up )
        Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
        
        ;         ElseIf mouse( )\wheel\x < 0
        ;           ;Post( #PB_EventType_Down, *this\scroll\h )
        ;           Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
        ;         EndIf
      EndIf
      
      If eventtype = #PB_EventType_MouseWheelY
        ;         If mouse( )\wheel\y > 0
        ;           ;Post( *this\scroll\v, #PB_EventType_Up )
        Repaint | bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
        ;           
        ;         ElseIf mouse( )\wheel\y < 0
        ;           ;Post( *this\scroll\v, #PB_EventType_Down )
        ;           Repaint | bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
        ;         EndIf
      EndIf
      
      
      ; key events
      If eventtype = #PB_EventType_Input Or
         eventtype = #PB_EventType_KeyDown Or
         eventtype = #PB_EventType_KeyUp
        
        Repaint | Tree_events_Key( *this, eventtype, mouse_x, mouse_y )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Macro set_state_list_( _address_, _state_ )
      If _state_ > 0 
        If *this\mode\check = #__m_clickselect
          If _address_\state\enter = #False
            _address_\state\enter = #True
          EndIf
        Else
          If _address_\state\press  = #False
            _address_\state\press = #True
          EndIf
        EndIf 
        
        If _address_\state\press = #True
          _address_\color\state = #__S_2
        ElseIf _address_\state\enter
          _address_\color\state = #__S_1
        EndIf
        
      ElseIf _address_ 
        If *this\mode\check <> #__m_clickselect
          If _address_\state\press = #True
            _address_\state\press = #False
          EndIf
        EndIf 
        
        If _address_\state\enter
          _address_\state\enter = #False
        EndIf
        
        If _address_\state\press  = #False
          _address_\color\state = #__S_0
        EndIf
      EndIf
    EndMacro
    
    Macro _multi_select_items_( _this_ )
      PushListPosition( *this\_rows( )) 
      ForEach *this\_rows( )
        If *this\_rows( )\visible
          If Bool(( *this\PressedRow( )\index >= *this\_rows( )\index And *this\FocusedRow( )\index <= *this\_rows( )\index ) Or ; верх
                  ( *this\FocusedRow( )\index >= *this\_rows( )\index And *this\PressedRow( )\index <= *this\_rows( )\index ))   ; вниз
            
            If *this\_rows( )\color\state <> #__S_2
              *this\_rows( )\color\state = #__S_2
              Repaint | #True
            EndIf
            
          Else
            
            If *this\_rows( )\color\state <> #__S_0
              *this\_rows( )\color\state = #__S_0
              
              ; example( sel 5;6;7, click 5, no post change )
              If *this\_rows( )\state\press = #True
                *this\_rows( )\state\press = #False
              EndIf
              
              Repaint | #True
            EndIf
            
          EndIf
        EndIf
      Next
      PopListPosition( *this\_rows( )) 
    EndMacro
    
    
    Procedure.l ListView_Events( *this._S_widget, eventtype.l, *item._S_rows, item =- 1 )
      Protected Repaint, mouse_x.l = mouse( )\x, mouse_y.l = mouse( )\y
      
      If eventtype = #PB_EventType_DragStart
        Post( *this, #PB_EventType_DragStart, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_Focus
        PushListPosition( *this\_rows( )) 
        ForEach *this\_rows( )
          If *this\_rows( )\color\state = #__S_3
            *this\_rows( )\color\state = #__S_2
            *this\_rows( )\state\press = #True
          EndIf
        Next
        PopListPosition( *this\_rows( )) 
        
        ; Post( *this, #PB_EventType_Focus, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_LostFocus
        PushListPosition( *this\_rows( )) 
        ForEach *this\_rows( )
          If *this\_rows( )\color\state = #__S_2
            *this\_rows( )\color\state = #__S_3
            *this\_rows( )\state\press = #False
          EndIf
        Next
        PopListPosition( *this\_rows( )) 
        
        ; Post( *this, #PB_EventType_lostFocus, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If *this\FocusedRow( ) 
          If *this\mode\check = #__m_multiselect
            *this\EnteredRow( ) = *this\FocusedRow( )
          EndIf
          
          If *this\mode\check <> #__m_clickselect 
            If *this\FocusedRow( )\state\press  = #False
              *this\FocusedRow( )\state\press = #True
              Post( *this, #PB_EventType_Change, *this\FocusedRow( )\index )
              Repaint | #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftClick
        If *this\EnteredRow( )
          ;;;;;Post( *this, #PB_EventType_LeftClick, *this\EnteredRow( )\index )
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftDoubleClick
        If *this\EnteredRow( )
          Post( *this, #PB_EventType_LeftDoubleClick, *this\EnteredRow( )\index )
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_RightClick
        If *this\EnteredRow( )
          Post( *this, #PB_EventType_RightClick, *this\EnteredRow( )\index )
          Repaint | #True
        EndIf
      EndIf
      
      
      If eventtype = #PB_EventType_MouseEnter Or
         eventtype = #PB_EventType_MouseMove Or
         eventtype = #PB_EventType_MouseLeave Or
         eventtype = #PB_EventType_RightButtonDown Or
         eventtype = #PB_EventType_LeftButtonDown ;Or eventtype = #PB_EventType_leftButtonUp
        
        If *this\count\items
          ForEach *this\VisibleRows( )
            ; If *this\VisibleRows( )\visible
            If is_at_point_( *this, mouse_x, mouse_y, [#__c_inner] ) And 
               is_at_point_( *this\VisibleRows( ),
                             mouse_x + *this\scroll\h\bar\page\pos,
                             mouse_y + *this\scroll\v\bar\page\pos )
              
              ;  
              If Not *this\VisibleRows( )\state\enter 
                *this\VisibleRows( )\state\enter = #True 
                
                ; 
                If Not mouse( )\buttons
                  *this\EnteredRow( ) = *this\VisibleRows( )
                EndIf
                
                If *this\VisibleRows( )\color\state = #__S_0
                  *this\VisibleRows( )\color\state = #__S_1
                  Repaint | #True
                EndIf
                
                ;
                If Not ( mouse( )\buttons And *this\mode\check )
                  Post( *this, #PB_EventType_StatusChange, *this\VisibleRows( )\index )
                  Repaint | #True
                EndIf
              EndIf
              
              If mouse( )\buttons
                If *this\mode\check
                  *this\FocusedRow( ) = *this\VisibleRows( )
                  
                  ; clickselect items
                  If *this\mode\check = #__m_clickselect
                    If eventtype = #PB_EventType_LeftButtonDown
                      If *this\VisibleRows( )\state\press = #True 
                        *this\VisibleRows( )\state\press = #False
                        *this\VisibleRows( )\color\state = #__S_1
                      Else
                        *this\VisibleRows( )\state\press = #True
                        *this\VisibleRows( )\color\state = #__S_2
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, *this\VisibleRows( )\index )
                      Repaint | #True
                    EndIf
                  EndIf
                  
                  If *this\FocusedRow( )
                    PushListPosition( *this\_rows( )) 
                    ForEach *this\_rows( )
                      If *this\_rows( )\visible
                        If Bool(( *this\EnteredRow( )\index >= *this\_rows( )\index And *this\FocusedRow( )\index <= *this\_rows( )\index ) Or ; верх
                                ( *this\EnteredRow( )\index <= *this\_rows( )\index And *this\FocusedRow( )\index >= *this\_rows( )\index ))   ; вниз
                          
                          If *this\mode\check = #__m_clickselect
                            If *this\EnteredRow( )\state\press = #True
                              If *this\_rows( )\color\state <> #__S_2
                                *this\_rows( )\color\state = #__S_2
                                
                                If *this\_rows( )\state\press  = #False
                                  ; entered to no selected
                                  Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\_rows( )\state\enter
                              If *this\_rows( )\color\state <> #__S_1
                                *this\_rows( )\color\state = #__S_1
                                
                                If *this\_rows( )\state\press = #True
                                  If *this\EnteredRow( )\state\press  = #False
                                    ; entered to selected
                                    Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          ; multiselect items
                          If *this\mode\check = #__m_multiselect
                            If *this\_rows( )\color\state <> #__S_2
                              *this\_rows( )\color\state = #__S_2
                              Repaint | #True
                              
                              ; reset select before this 
                              ; example( sel 5;6;7, click 7, reset 5;6 )
                            ElseIf eventtype = #PB_EventType_LeftButtonDown
                              If *this\FocusedRow( ) <> *this\_rows( )
                                *this\_rows( )\color\state = #__S_0
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                        Else
                          
                          If *this\mode\check = #__m_clickselect
                            If *this\_rows( )\state\press = #True 
                              If *this\_rows( )\color\state <> #__S_2
                                *this\_rows( )\color\state = #__S_2
                                
                                If *this\EnteredRow( )\state\press  = #False
                                  ; leaved from selected
                                  Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\_rows( )\state\enter = #False
                              If *this\_rows( )\color\state <> #__S_0
                                *this\_rows( )\color\state = #__S_0
                                
                                If *this\EnteredRow( )\state\press = #True
                                  If *this\_rows( )\state\press  = #False
                                    ; leaved from no selected
                                    Post( *this, #PB_EventType_Change, *this\_rows( )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          If *this\mode\check = #__m_multiselect
                            If *this\_rows( )\color\state <> #__S_0
                              *this\_rows( )\color\state = #__S_0
                              
                              ; example( sel 5;6;7, click 5, no post change )
                              If *this\_rows( )\state\press = #True
                                *this\_rows( )\state\press = #False
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                          
                        EndIf
                      EndIf
                    Next
                    PopListPosition( *this\_rows( )) 
                  EndIf
                Else
                  If *this\FocusedRow( ) And
                     *this\FocusedRow( ) <> *this\VisibleRows( )
                    *this\FocusedRow( )\state\press = #False
                    *this\FocusedRow( )\color\state = #__S_0
                  EndIf
                  
                  *this\VisibleRows( )\color\state = #__S_2
                  *this\FocusedRow( ) = *this\VisibleRows( )
                  ; *this\change =- row_scroll_y_( *this\scroll\v, *this\FocusedRow( ) )
                  Repaint | #True
                EndIf
              EndIf
              
            ElseIf *this\VisibleRows( )\state\enter
              *this\VisibleRows( )\state\enter = #False 
              
              
              If *this\VisibleRows( )\color\state = #__S_1
                *this\VisibleRows( )\color\state = #__S_0
              EndIf
              
              ;
              If mouse( )\buttons And *this\mode\check
                If *this\mode\check = #__m_multiselect
                  If *this\VisibleRows( )\state\press  = #False
                    *this\VisibleRows( )\state\press = #True
                  EndIf
                  
                  Post( *this, #PB_EventType_Change, *this\VisibleRows( )\index )
                EndIf
              EndIf
              
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      
      If eventtype = #PB_EventType_MouseWheelX
        Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
      EndIf
      
      If eventtype = #PB_EventType_MouseWheelY
        Repaint | bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
      EndIf
      
      
      ;- widget::ListView_Events_Key
      If eventtype = #PB_EventType_KeyDown 
        Protected *current._S_rows
        Protected result, from =- 1
        Static cursor_change, Down
        
        If *this\state\focus
          
          If *this\mode\check = #__m_clickselect
            *current = *this\EnteredRow( )
          Else
            *current = *this\FocusedRow( )
          EndIf
          
          Select Keyboard( )\key
            Case #PB_Shortcut_Space
              If *this\mode\check = #__m_clickselect 
                If *current\state\press = #True
                  *current\state\press = #False
                  *current\color\state = #__S_1
                Else
                  *current\state\press = #True
                  *current\color\state = #__S_2
                  *this\FocusedRow( ) = *current
                EndIf
                
                Post( *this, #PB_EventType_Change, *current\index )
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageUp
              ; TODO scroll to first visible
              If bar_SetState( *this\scroll\v\bar, 0 ) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageDown
              ; TODO scroll to last visible
              If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\end ) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up,
                 #PB_Shortcut_Home
              
              If *current
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  ; scroll to top
                  If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - 18 ) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *current\index > 0
                  ; select modifiers key item
                  If ( Keyboard( )\key = #PB_Shortcut_Home Or
                       ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                    SelectElement( *this\_rows( ), 0 )
                  Else
                    _select_prev_item_( *this\_rows( ), *current\index )
                  EndIf
                  
                  If *current <> *this\_rows( )
                    If *current 
                      set_state_list_( *current, #False )
                    EndIf
                    set_state_list_( *this\_rows( ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      *this\FocusedRow( ) = *this\_rows( )
                    EndIf
                    
                    If Not Keyboard( )\key[1] & #PB_Canvas_Shift
                      *this\EnteredRow( ) = *this\FocusedRow( )
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = *this\_rows( )
                    *this\change =- row_scroll_y_( *this, *current )
                    Post( *this, #PB_EventType_Change, *current\index )
                    Repaint = 1
                  EndIf
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Down,
                 #PB_Shortcut_End
              
              If *current
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + 18 ) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *current\index < ( *this\count\items - 1 )
                  ; select modifiers key item
                  If ( Keyboard( )\key = #PB_Shortcut_End Or
                       ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                    SelectElement( *this\_rows( ), ( *this\count\items - 1 ))
                  Else
                    _select_next_item_( *this\_rows( ), *current\index )
                  EndIf
                  
                  If *current <> *this\_rows( )
                    If *current 
                      set_state_list_( *current, #False )
                    EndIf
                    set_state_list_( *this\_rows( ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      *this\FocusedRow( ) = *this\_rows( )
                    EndIf
                    
                    If Not Keyboard( )\key[1] & #PB_Canvas_Shift
                      *this\EnteredRow( ) = *this\FocusedRow( )
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = *this\_rows( )
                    *this\change =- row_scroll_y_( *this, *current )
                    Post( *this, #PB_EventType_Change, *current\index )
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Left
              If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( Keyboard( )\key[1] & #PB_Canvas_Control )
                
                *this\change = bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end/10 )) 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Right
              If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( Keyboard( )\key[1] & #PB_Canvas_Control )
                
                *this\change = bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end/10 )) 
                Repaint = 1
              EndIf
              
          EndSelect
          
          If *this\mode\check = #__m_clickselect
            *this\EnteredRow( ) = *current
          Else
            *this\FocusedRow( ) = *current
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  WINDOW - e
    Procedure   Window_Update( *this._S_widget )
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
          
          *this\caption\height = *this\barHeight + *this\fs - 1
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
    
    Procedure   Window_Draw( *this._S_widget )
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
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_roundbox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,\color\back[\interact * \color\state] )
        EndIf
        
        ; Draw frame
        drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        If *this\fs > 0
          For i=1 To *this\fs
            draw_roundbox_( \x[#__c_inner]-i,\y[#__c_inner]-i,\width[#__c_inner]+i*2,\height[#__c_inner]+i*2, round,round,\caption\color\back[\color\state] )
          Next
          draw_roundbox_( \x[#__c_inner]-1,\y[#__c_inner]-1,\width[#__c_inner]+2,\height[#__c_inner]+2, round,round,\color\frame[\color\state] )
        EndIf
        draw_roundbox_( \x[#__c_inner]-*this\fs,\y[#__c_inner]-*this\fs,\width[#__c_inner]+*this\fs*2,\height[#__c_inner]+*this\fs*2, round,round,\color\frame[\color\state] )
        
        ; then caption
        If *this\fs[2]
          ; Draw caption back
          If \caption\color\back 
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_( 0, \caption, \caption\color\fore[\color\state], \caption\color\back[\color\state] )
          EndIf
          
          ; Draw caption frame
          If \fs
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_( \caption\x, \caption\y, \caption\width, *this\fs+*this\fs[2],\caption\round,\caption\round,\color\frame[\color\state] )
            
            ; erase the bottom edge of the frame
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            BackColor( \caption\color\fore[\color\state] )
            FrontColor( \caption\color\back[\color\state] )
            
            ;Protected i
            For i = 0 To \caption\round
              Line( \x[#__c_inner] - *this\fs + 1,\y[#__c_frame] + (*this\fs+*this\fs[2]-\caption\round) + i - 2,\width[#__c_frame]-2,1, \caption\color\back[\color\state] )
            Next
            
            ; two edges of the frame
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            Line( \x[#__c_frame],\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
            Line( \x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
          EndIf
          
          ; buttins background
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_button_( \caption\button[#__wb_close], color\back )
          draw_box_button_( \caption\button[#__wb_maxi], color\back )
          draw_box_button_( \caption\button[#__wb_mini], color\back )
          draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( \caption\button[#__wb_close], 6 )
          draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; Draw image
          If \image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( \image\id,
                            *this\x[#__c_frame] + *this\bs + scroll_x_( *this ) + \image\x,
                            *this\y[#__c_frame] + *this\bs + scroll_y_( *this ) + \image\y - 2, \color\_alpha )
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
              \caption\text\y = \caption\y[#__c_inner] + ( \caption\height[#__c_inner] - TextHeight( "A" ))/2
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ;             draw_roundbox_( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
            Clip( *this, [#__c_draw] )
          EndIf
        EndIf
        
        ;Clip( *this, [#__c_draw2] )
        
        ; background image draw 
        If *this\image[#__img_background]\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__img_background]\id,
                          *this\x[#__c_inner] + *this\image[#__img_background]\x, 
                          *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
        EndIf
        
        ;Clip( *this, [#__c_draw] )
        
        ; UnclipOutput( )
        ; drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        ; draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; draw_roundbox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure   Window_Draw1( *this._S_widget )
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
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_roundbox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,\color\back[\interact * \color\state] )
        EndIf
        
        ; draw frame back
        If \fs
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          If \fs = 1 
            For i = 1 To \caption\round
              Line( \x[#__c_frame] + i - 1,\y[#__c_frame] + caption_height - 1,1,Bool( \round )*( i - \round ),\caption\color\back[\color\state] )
              Line( \x[#__c_frame] + \width[#__c_frame] + i - \round - 1,\y[#__c_frame] + caption_height - 1,1, - Bool( \round )*( i ),\caption\color\back[\color\state] )
            Next
          Else
            For i = 1 To \fs
              draw_roundbox_( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i - 1, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2 + 2,\round,\round, \caption\color\back[\color\state] )
              draw_roundbox_( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2,\round,\round, \caption\color\back[\color\state] )
            Next
          EndIf
        EndIf 
        
        ; frame draw
        If \fs
          drawing_mode_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
          If \fs = 1 
            draw_roundbox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
          Else
            ; draw out frame
            draw_roundbox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
            
            ; draw inner frame 
            If \type = #__type_ScrollArea Or \type = #__type_MDI ; \scroll And \scroll\v And \scroll\h
              draw_roundbox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \scroll\v\color\line )
            Else
              draw_roundbox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \color\frame[\color\state] )
            EndIf
          EndIf
        EndIf
        
        
        If caption_height
          ; Draw caption back
          If \caption\color\back 
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_( 0, \caption, \caption\color\fore[\color\state], \caption\color\back[\color\state] )
          EndIf
          
          ; Draw caption frame
          If \fs
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_( \caption\x, \caption\y, \caption\width, caption_height - 1,\caption\round,\caption\round,\color\frame[\color\state] )
            
            ; erase the bottom edge of the frame
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            BackColor( \caption\color\fore[\color\state] )
            FrontColor( \caption\color\back[\color\state] )
            
            ;Protected i
            For i = \caption\round/2 + 2 To caption_height - 1
              Line( \x[#__c_frame],\y[#__c_frame] + i,\width[#__c_frame],1, \caption\color\back[\color\state] )
            Next
            
            ; two edges of the frame
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            Line( \x[#__c_frame],\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
            Line( \x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
          EndIf
          
          ; buttins background
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_button_( \caption\button[#__wb_close], color\back )
          draw_box_button_( \caption\button[#__wb_maxi], color\back )
          draw_box_button_( \caption\button[#__wb_mini], color\back )
          draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( \caption\button[#__wb_close], 6 )
          draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; Draw image
          If \image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( \image\id,
                            *this\x[#__c_frame] + *this\bs + scroll_x_( *this ) + \image\x,
                            *this\y[#__c_frame] + *this\bs + scroll_y_( *this ) + \image\y - 2, \color\_alpha )
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
              \caption\text\y = \caption\y[#__c_inner] + ( \caption\height[#__c_inner] - TextHeight( "A" ))/2
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ;             draw_roundbox_( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
            Clip( *this, [#__c_draw] )
          EndIf
        EndIf
        
        ;Clip( *this, [#__c_draw2] )
        
        ; background image draw 
        If *this\image[#__img_background]\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__img_background]\id,
                          *this\x[#__c_inner] + *this\image[#__img_background]\x, 
                          *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
        EndIf
        
        ;Clip( *this, [#__c_draw] )
        
        ; UnclipOutput( )
        ; drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        ; draw_roundbox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; draw_roundbox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure   Window_Draw2( *this._S_widget )
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
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          draw_roundbox_(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], caption_height, _round_,_round_)
          
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          draw_roundbox_( \x[#__c_frame], \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          draw_roundbox_( \x[#__c_frame]+\width[#__c_frame]-caption_height, \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          draw_roundbox_(*this\x[#__c_frame]+1, *this\y[#__c_frame]+1, *this\width[#__c_frame]-2, caption_height, _round_,_round_)
          draw_box_( \x[#__c_frame], \y[#__c_frame]+caption_height/2, \width[#__c_frame], \fs[2]-caption_height/2+\fs, \caption\color\back[window_color_state] )
        EndIf
        
        ; Clip( *this, [#__c_draw2] )
        
        If Not ( *this\image[#__img_background]\id And *this\image[#__img_background]\depth > 31 ) ; *this\image[#__img_background]\transparent )
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, \color\back[0] )
        EndIf
        
        If \fs
          If \fs = 1 
            drawing_mode_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
            draw_roundbox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], \height[#__c_frame], round, round, \color\frame[window_color_state] )
          Else
            If \type = #__type_ScrollArea Or \type = #__type_MDI
              color_inner_line = \scroll\v\color\line
            Else                                                                                             
              color_inner_line = \color\frame[window_color_state]
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_roundbox_( \x[#__c_frame], \y[#__c_inner] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            draw_roundbox_( \x[#__c_frame], \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            draw_roundbox_( \x[#__c_frame]+\width[#__c_frame]-\fs, \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            draw_roundbox_( \x[#__c_frame], \y[#__c_frame]+\height[#__c_frame] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            
            ; draw inner frame 
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, round, round, color_inner_line )
            
            ; draw out frame
            ;draw_roundbox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[window_color_state] )
            Line(\x[#__c_frame]+caption_height/2, \y[#__c_frame], \width[#__c_frame]-caption_height, 1, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame] + \width[#__c_frame] - 1, \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame] + \height[#__c_frame] - 1, \width[#__c_frame], 1, color_inner_line)
          EndIf
        EndIf
        
        
        If caption_height
          ; buttins background
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_button_( \caption\button[#__wb_close], color\back )
          draw_box_button_( \caption\button[#__wb_maxi], color\back )
          draw_box_button_( \caption\button[#__wb_mini], color\back )
          draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( \caption\button[#__wb_close], 6 )
          draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; draw caption image
          If \image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( \image\id,
                            *this\x[#__c_frame] + *this\bs + scroll_x_( *this ) + \image\x,
                            *this\y[#__c_frame] + *this\bs + scroll_y_( *this ) + \image\y - 2, \color\_alpha )
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
              \caption\text\y = \caption\y[#__c_inner] + ( \caption\height[#__c_inner] - TextHeight( "A" ))/2
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[window_color_state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ;             draw_roundbox_( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
          EndIf
        EndIf
        
        ; Clip( *this, [#__c_draw] ) ; 2
        
        ; background image draw 
        If *this\image[#__img_background]\id
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          DrawAlphaImage( *this\image[#__img_background]\id,
                          *this\x[#__c_inner] + *this\image[#__img_background]\x, 
                          *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
          ;                   DrawImage( *this\image[#__img_background]\id,
          ;                                   *this\x[#__c_inner] + *this\image[#__img_background]\x, 
          ;                                   *this\y[#__c_inner] + *this\image[#__img_background]\y)
        EndIf
        
        
      EndWith
    EndProcedure
    
    Procedure   Window_SetState( *this._S_widget, state.l )
      Protected.b result
      
      ; close state
      If state = #__Window_Close
        If Not Post( *this, #PB_EventType_CloseWindow )
          Free( *this )
          
          If is_root_(*this )
            PostEvent( #PB_Event_CloseWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; restore state
      If state = #__Window_Normal
        If Not Post( *this, #PB_EventType_restoreWindow )
          If *this\resize & #__resize_minimize
            *this\resize &~ #__resize_minimize
            *this\caption\button[#__wb_close]\hide = 0
            *this\caption\button[#__wb_mini]\hide = 0
          EndIf
          *this\resize &~ #__resize_maximize
          *this\resize | #__resize_restore
          
          SetAlignmentFlag( *this, #__align_none )
          Resize( *this, *this\_root( )\x[#__c_rootrestore], *this\_root( )\y[#__c_rootrestore], 
                  *this\_root( )\width[#__c_rootrestore], *this\_root( )\height[#__c_rootrestore] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_RestoreWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post( *this, #PB_EventType_MaximizeWindow )
          If Not *this\resize & #__resize_minimize
            *this\_root( )\x[#__c_rootrestore] = *this\x[#__c_container]
            *this\_root( )\y[#__c_rootrestore] = *this\y[#__c_container]
            *this\_root( )\width[#__c_rootrestore] = *this\width[#__c_frame]
            *this\_root( )\height[#__c_rootrestore] = *this\height[#__c_frame]
          EndIf
          
          *this\resize | #__resize_maximize
          Resize( *this, 0,0, *this\_parent( )\width[#__c_container], *this\_parent( )\height[#__c_container] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MaximizeWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post( *this, #PB_EventType_MinimizeWindow )
          If Not *this\resize & #__resize_maximize
            *this\_root( )\x[#__c_rootrestore] = *this\x[#__c_container]
            *this\_root( )\y[#__c_rootrestore] = *this\y[#__c_container]
            *this\_root( )\width[#__c_rootrestore] = *this\width[#__c_frame]
            *this\_root( )\height[#__c_rootrestore] = *this\height[#__c_frame]
          EndIf
          
          *this\caption\button[#__wb_close]\hide = 1
          If *this\caption\button[#__wb_maxi]\hide = 0
            *this\caption\button[#__wb_mini]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize( *this, *this\_root( )\x[#__c_rootrestore], *this\_parent( )\height[#__c_container] - *this\fs[2], *this\_root( )\width[#__c_rootrestore], *this\fs[2] )
          SetAlignmentFlag( *this, #__align_bottom )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MinimizeWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_Events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      mouse_x = mouse( )\x
      mouse_y = mouse( )\y
      
      ;       If eventtype = #PB_EventType_MouseMove
      ;         If *this\state\press
      ;           If *this = *this\_root( )\canvas\container
      ;             ResizeWindow( *this\_root( )\canvas\window, ( DesktopMousex( ) - mouse( )\delta\x ), ( DesktopMouseY( ) - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           Else
      ;             Repaint = Resize( *this, ( mouse_x - mouse( )\delta\x ), ( mouse_y - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           EndIf
      ;         EndIf
      ;       EndIf
      
      If eventtype = #PB_EventType_LeftClick
        If *this\type = #__type_Window
          *this\caption\interact = is_at_point_( *this\caption, mouse_x, mouse_y, [2] )
          ;*this\color\state = 2
          
          Debug ""+mouse_x +" "+ *this\caption\button[#__wb_close]\x
          ; close button
          If is_at_point_( *this\caption\button[#__wb_close], mouse_x, mouse_y )
            ProcedureReturn Window_SetState( *this, #__Window_Close )
          EndIf
          
          ; maximize button
          If is_at_point_( *this\caption\button[#__wb_maxi], mouse_x, mouse_y )
            If Not *this\resize & #__resize_maximize And
               Not *this\resize & #__resize_minimize
              
              ProcedureReturn Window_SetState( *this, #__window_maximize )
            Else
              ProcedureReturn Window_SetState( *this, #__window_normal )
            EndIf
          EndIf
          
          ; minimize button
          If is_at_point_( *this\caption\button[#__wb_mini], mouse_x, mouse_y )
            If Not *this\resize & #__resize_minimize
              ProcedureReturn Window_SetState( *this, #__window_minimize )
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Procedure.l x( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\x[mode] )
    EndProcedure
    
    Procedure.l Y( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\y[mode] )
    EndProcedure
    
    Procedure.l Width( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\width[mode] )
    EndProcedure
    
    Procedure.l Height( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\height[mode] )
    EndProcedure
    
    Procedure.b Hide( *this._S_widget, State.b = #PB_Default )
      If State = #PB_Default
        ProcedureReturn *this\hide 
      Else
        *this\hide = State
        *this\state\hide = *this\hide
        
        If *this\count\childrens
          HideChildrens( *this )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.b Disable( *this._S_widget, State.b = #PB_Default )
      If State = #PB_Default
        ProcedureReturn *this\state\disable
      Else
        If *this\state\disable = #True
          *this\state\disable = #False
          ; *this\color\state = #__S_0
        Else
          *this\state\disable = #True
          ; *this\color\state = #__S_3
          *this\color\state = #__S_0
        EndIf
        
        If StartEnumerate( *this )
          enumWidget( )\color\state = #__S_3 
          StopEnumerate( )
        EndIf
        PostCanvasRepaint(*this\_root( ))
      EndIf
    EndProcedure
    
    Procedure.b Update( *this._S_widget )
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Panel
        result = bar_Update( *this\TabWidget( )\bar )
      EndIf  
      
      If *this\type = #__type_Window
        result = Window_Update( *this )
      EndIf
      
      ; ;       If *this\type = #__type_tree
      ; ;         If StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
      ; ;           Tree_Update( *this, *this\_rows( ))
      ; ;           StopDrawing( )
      ; ;         EndIf
      ; ;         
      ; ;         result = 1
      ; ;       EndIf
      
      If *this\type = #__type_ScrollBar Or
         ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_Splitter Or
         *this\type = #__type_Spin
        
        result = bar_Update( *this\bar )
      Else
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Display( *this._S_widget, *display._S_widget, x = #PB_Ignore, y = #PB_Ignore )
      Protected display_height = 0
      
      Popu_parent( ) = *this
      *this\state\flag | #__S_collapse
      
      ForEach *this\_rows( )
        If Not *this\_rows( )\hide
          display_height + *this\_rows( )\height
        EndIf
        If ( ListIndex(*this\_rows( )) + 1 )>= 10;30
          Break
        EndIf
      Next
      
      If scroll_height_( *this ) > display_height 
        Resize( *this, x, y, #PB_Ignore, display_height ) 
      Else
        Resize( *this, x, y, #PB_Ignore, scroll_height_( *this ) + *this\barHeight + *this\fs*2 + *this\ToolBarHeight ) 
      EndIf
      
      ;*this\change = 1
      update_visible_items_( *this )
    EndProcedure
    
    Procedure   IsChild( *this._S_widget, *parent._S_widget )
      Protected result 
      
      If *this And 
         ; *this <> *parent And 
        *parent\count\childrens
        
        Repeat
          If *parent = *this\_parent( )
            result = *this
            Break
          EndIf
          
          *this = *this\_parent( )
          If Not *this
            result = 0
            Break
          EndIf
        Until *this = *this\_root( )  ; is_root_( *this )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b IsContainer( *this._S_widget )
      ProcedureReturn *this\container
    EndProcedure
    
    
    Procedure.i GetItem( *this._S_widget, parent_sublevel.l =- 1 ) ;???
      Protected result
      Protected *rows._S_rows
      Protected *widget._S_widget
      
      If *this 
        If parent_sublevel =- 1
          *widget = *this
          result = *widget\TabIndex( )
          
        Else
          *rows = *this
          
          While *rows And *rows <> *rows\parent\row
            
            If parent_sublevel = *rows\parent\row\sublevel
              result = *rows
              Break
            EndIf
            
            *rows = *rows\parent\row
          Wend
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Flag( *this._S_widget, flag.i=#Null, state.b =- 1 )
      Protected result
      
      If Not flag
        result = *this\flag
        ;       If *this\type = #__type_Button
        ;         ;         If *this\text\align\anchor\left
        ;         ;           result | #__button_left
        ;         ;         EndIf
        ;         ;         If *this\text\align\anchor\right
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
            text_rotate_( *this\text )
          EndIf
          
          If flag & #__text_top
            *this\text\change = #__text_update
            *this\text\align\anchor\bottom = 0
            *this\text\align\anchor\top = state
          EndIf
          If flag & #__text_bottom
            *this\text\change = #__text_update
            *this\text\align\anchor\top = 0
            *this\text\align\anchor\bottom = state
            
            *this\image\change = #__text_update
            *this\image\align\anchor\top = 0
            *this\image\align\anchor\bottom = state
          EndIf
          If flag & #__text_left
            *this\text\change = #__text_update
            *this\text\align\anchor\right = 0
            *this\text\align\anchor\left = state
          EndIf
          If flag & #__text_right
            *this\text\change = #__text_update
            *this\text\align\anchor\left = 0
            *this\text\align\anchor\right = state
            
            *this\image\change = #__text_update
            *this\image\align\anchor\left = 0
            *this\image\align\anchor\right = state
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
              ; *this\text\align\anchor\left = state
            EndIf
            ;             If flag & #__button_left
            ;               *this\text\align\anchor\right = 0
            ;               *this\text\align\anchor\left = state
            ;             EndIf
            ;             If flag & #__button_right
            ;               *this\text\align\anchor\left = 0
            ;               *this\text\align\anchor\right = state
            ;             EndIf
            ;             If flag & #__button_multiline
            ;               *this\text\change = #__text_update
            ;               *this\text\multiline = state
            ;             EndIf
            If flag & #__button_toggle
              If state 
                *this\state\flag | #__S_check
                *this\color\state = #__S_2
              Else
                *this\state\flag &~ #__S_check
                *this\color\state = #__S_0
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
                  PushListPosition( *this\_rows( ))
                  ForEach *this\_rows( )
                    If *this\_rows( )\parent\row And 
                       *this\_rows( )\parent\row\count\childrens
                      *this\_rows( )\sublevel = state
                    EndIf
                  Next
                  PopListPosition( *this\_rows( ))
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
                PushListPosition( *this\_rows( ))
                ForEach *this\_rows( )
                  If *this\_rows( )\parent\row
                    *this\_rows( )\checkbox\___state= #PB_Checkbox_Unchecked
                    *this\_rows( )\option_group = Bool( state ) * GetItem( *this\_rows( ), 0 ) 
                  EndIf
                Next
                PopListPosition( *this\_rows( ))
              EndIf
            EndIf
            If flag & #__tree_gridlines
              *this\mode\gridlines = state
            EndIf
            If flag & #__tree_collapse 
              *this\mode\collapse = state
              
              If *this\count\items
                PushListPosition( *this\_rows( ))
                ForEach *this\_rows( )
                  If *this\_rows( )\parent\row 
                    *this\_rows( )\parent\row\collapsebox\___state= state
                    *this\_rows( )\hide = state
                  EndIf
                Next
                PopListPosition( *this\_rows( ))
              EndIf
              
              If *this\_root( )
                ReDraw( *this )
              EndIf
            EndIf
            
            
            If ( *this\mode\lines Or *this\mode\buttons Or *this\mode\check ) And
               Not ( *this\flag & #__tree_property Or *this\flag & #__tree_optionboxes )
              *this\row\sublevelsize = 6;18 
            Else
              *this\row\sublevelsize = 0
            EndIf
            
            If *this\count\items
              *this\change = 1
            EndIf
          EndIf
          
          If flag & #__text_center
            *this\text\align\anchor\left = 0
            *this\text\align\anchor\top = 0
            *this\text\align\anchor\right = 0
            *this\text\align\anchor\bottom = 0
            
            ;           Else
            ;             If Not *this\text\align\anchor\bottom
            ;               *this\text\align\anchor\top = #True
            ;             EndIf
            ;             
            ;             If Not *this\text\align\anchor\right
            ;               *this\text\align\anchor\left = #True 
            ;             EndIf
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    
    ;- 
    Procedure.i AddColumn( *this._S_widget, Position.l, Text.s, Width.l, Image.i=-1 )
      
      With *This
        ;         LastElement( \Columns( ))
        ;         AddElement( \Columns( )) 
        ;         ;       Position = ListIndex( \Columns( ))
        ;         
        ;         \Columns( )\text\string.s = Text.s
        ;         \Columns( )\text\change = 1
        ;         \Columns( )\x = scroll_width_( *this )
        ;         \Columns( )\width = Width
        ;         \Columns( )\height = 24
        ;         scroll_width_( *this ) + Width
        ;         scroll_height_( *this ) = \bs*2+\Columns( )\height
        ;         ;      ; ReDraw( *This )
        ;         ;       If Position = 0
        ;         ;      ;   PostCanvasRepaint( *this\_root( ) )
        ;         ;       EndIf
      EndWith
    EndProcedure
    
    Procedure   AddItem( *this._S_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0 )
      Protected result
      
      If *this\type = #__type_MDI
        *this\count\items + 1
        ;         Static pos_x, pos_y
        ;         Protected x = a_transform( )\grid\size, y = a_transform( )\grid\size, width.l = 280, height.l = 180
        ;         
        ;         ;         If a_transform( ) And a_transform( )\grid\size
        ;         ;           x = ( x/a_transform( )\grid\size ) * a_transform( )\grid\size
        ;         ;           y = ( y/a_transform( )\grid\size ) * a_transform( )\grid\size
        ;         ;           
        ;         ;           width = ( width/a_transform( )\grid\size ) * a_transform( )\grid\size - ( #__window_frame_size * 2 )%a_transform( )\grid\size + 1
        ;         ;           height = ( height/a_transform( )\grid\size ) * a_transform( )\grid\size - ( #__window_frame_size*2+#__window_caption_height )%a_transform( )\grid\size + 1
        ;         ;         EndIf
        ;         
        
        ;         If flag & #__flag_BorderLess = #__flag_BorderLess
        ;           result = Container( #PB_Ignore, #PB_Ignore, 280, 180, flag|#__flag_nogadgets )
        ;         Else
        flag | #__window_systemmenu | #__window_sizegadget | #__window_maximizegadget | #__window_minimizegadget | #__window_child
        ;         result = Window( x + pos_x, y + pos_y, width, height, Text, flag, *this )
        ;         pos_y + y + #__window_frame_size + #__window_caption_height
        ;         pos_x + x + #__window_frame_size
        
        result = Window( #PB_Ignore, #PB_Ignore, 280, 180, Text, flag, *this )
        ;         EndIf
        If IsImage( Image )
          If flag & #__flag_BorderLess = #__flag_BorderLess
            SetBackgroundImage( result, Image )
          Else
            SetImage( result, Image )
          EndIf
        EndIf
        ProcedureReturn result
      EndIf
      
      If *this\type = #__type_Editor
        ProcedureReturn edit_AddItem( *this, *this\_rows( ), item, @text, Len(Text) )
      EndIf
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_property
        ProcedureReturn Tree_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_ListView
        ProcedureReturn Tree_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_combobox
        ProcedureReturn Tree_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn bar_tab_AddItem( *this, Item,Text,Image,flag )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn bar_tab_AddItem( *this\TabWidget( ), Item,Text,Image,flag )
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure   RemoveItem( *this._S_widget, Item.l )
      Protected result
      
      If *this\type = #__type_Editor
        edit_RemoveItem( *this, Item )
        
        result = #True
      EndIf
      
      ;- widget::tree_remove_item( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If is_no_select_item_( *this\_rows( ), Item )
          ProcedureReturn #False
        EndIf
        
        Protected sublevel = *this\_rows( )\sublevel
        Protected *parent_row._S_rows = *this\_rows( )\parent\row
        
        ; if is last parent item then change to the prev element of his level
        If *parent_row And *parent_row\last = *this\_rows( )
          PushListPosition( *this\_rows( ))
          While PreviousElement( *this\_rows( ))
            If *parent_row = *this\_rows( )\parent\row
              *parent_row\last = *this\_rows( )
              Break
            EndIf
          Wend
          PopListPosition( *this\_rows( ))
          
          ; if the remove last parent childrens
          If *parent_row\last = *this\_rows( )
            *parent_row\count\childrens = #False
            *parent_row\last = #Null
          Else
            *parent_row\count\childrens = #True
          EndIf
        EndIf
        
        ; before deleting a parent, we delete its children
        If *this\_rows( )\count\childrens
          PushListPosition( *this\_rows( ))
          While NextElement( *this\_rows( ))
            If *this\_rows( )\sublevel > sublevel 
              DeleteElement( *this\_rows( )) 
              *this\count\items - 1 
              *this\row\count - 1
            Else
              Break
            EndIf
          Wend
          PopListPosition( *this\_rows( ))
        EndIf
        
        ; if the item to be removed is selected, 
        ; then we set the next item of its level as selected
        If *this\FocusedRow( ) = *this\_rows( )
          *this\FocusedRow( )\state\press = #False
          
          ; if he is a parent then we find the next item of his level
          PushListPosition( *this\_rows( ))
          While NextElement( *this\_rows( ))
            If *this\_rows( )\sublevel = *this\FocusedRow( )\sublevel 
              Break
            EndIf
          Wend
          
          ; if we remove the last selected then 
          If *this\FocusedRow( ) = *this\_rows( ) 
            *this\FocusedRow( ) = PreviousElement( *this\_rows( ))
          Else
            *this\FocusedRow( ) = *this\_rows( ) 
          EndIf
          PopListPosition( *this\_rows( ))
          
          If *this\FocusedRow( )
            If *this\FocusedRow( )\parent\row And 
               *this\FocusedRow( )\parent\row\collapsebox\___state 
              *this\FocusedRow( ) = *this\FocusedRow( )\parent\row
            EndIf 
            
            *this\FocusedRow( )\state\press = #True
            *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          EndIf
        EndIf
        
        *this\change = 1  
        *this\count\items - 1
        DeleteElement( *this\_rows( ))
        PostCanvasRepaint( *this\_root( ) )
        result = #True
      EndIf
      
      If *this\type = #__type_Panel
        result = bar_tab_removeItem( *this\TabWidget( ), Item )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_removeItem( *this, Item )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l CountItems( *this._S_widget )
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure.l ClearItems( *this._S_widget )
      Protected result
      
      ; - widget::editor_clear_items( )
      If *this\type = #__type_Editor
        edit_ClearItems( *this )
        ProcedureReturn #True
      EndIf
      
      ; - widget::tree_clear_items( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If *this\count\items <> 0
          ;; Post( *this, #PB_EventType_Change, #PB_All ) ; 
          
          *this\change = 1
          *this\row\count = 0
          *this\count\items = 0
          
          If *this\FocusedRow( ) 
            *this\FocusedRow( )\color\state = 0
            ClearStructure(*this\FocusedRow( ), _S_rows)
            *this\FocusedRow( ) = 0
          EndIf
          
          ClearList( *this\_rows( ))
          
          PostCanvasRepaint( *this\_root( ) )
          ;           ReDraw( *this )
          ;           
        EndIf
      EndIf
      
      ; - Panel_ClearItems( )
      If *this\type = #__type_Panel
        result = bar_tab_clearItems( *this\TabWidget( ) )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_clearItems( *this )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure   GetWidget( index )
      Protected result
      
      If index =- 1
        ProcedureReturn enumWidget( )
      Else
        PushListPosition( enumWidget( ) )
        ForEach enumWidget( )
          If enumWidget( )\index = index ;+  1
            result = enumWidget( )
            Break
          EndIf
        Next
        PopListPosition( enumWidget( ) )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetIndex( *this._S_widget )
      ProcedureReturn *this\index ; - 1
    EndProcedure
    
    Procedure.i GetAddress( *this._S_widget )
      ProcedureReturn *this\address
    EndProcedure
    
    Procedure.l GetLevel( *this._S_widget )
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass( *this._S_widget )
      ProcedureReturn *this\class
    EndProcedure
    
    Procedure.l GetDeltaX( *this._S_widget )
      ProcedureReturn ( mouse( )\delta\x + *this\x[#__c_container] )
    EndProcedure
    
    Procedure.l GetDeltaY( *this._S_widget )
      ProcedureReturn ( mouse( )\delta\y + *this\y[#__c_container] )
    EndProcedure
    
    Procedure.l GetButtons( *this._S_widget )
      ProcedureReturn mouse( )\buttons
    EndProcedure
    
    Procedure.i GetFont( *this._S_widget )
      ProcedureReturn *this\text\fontID
    EndProcedure
    
    Procedure.l GetCount( *this._S_widget, mode.b = #False )
      If mode
        ProcedureReturn *this\count\type
      Else
        ProcedureReturn *this\count\index
      EndIf
    EndProcedure
    
    Procedure.i GetData( *this._S_widget )
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure.l GetType( *this._S_widget )
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.i GetRoot( *this._S_widget )
      ProcedureReturn *this\_root( ) ; Returns root element
    EndProcedure
    
    Procedure.i GetGadget( *this._S_widget = #Null )
      If *this = #Null : *this = Root( ) : EndIf
      
      If is_root_(*this )
        ProcedureReturn *this\_root( )\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow( *this._S_widget )
      If is_root_(*this )
        ProcedureReturn *this\_root( )\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\_window( ) ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParent( *this._S_widget )
      ProcedureReturn *this\_parent( )
    EndProcedure
    
    Procedure  GetFirst( *this._S_widget, tabindex.l )
      Protected *result._S_widget
      
      If *this\count\childrens
        PushListPosition(  *this\_widgets( ) )
        ChangeCurrentElement(  *this\_widgets( ), *this\address )
        While NextElement(  *this\_widgets( ) )
          If  *this\_widgets( ) = *this\last\widget Or
              *this\_widgets( )\TabIndex( ) = tabindex
            *result =  *this\_widgets( )
            Break
          EndIf
        Wend
        PopListPosition(  *this\_widgets( ) )
      Else
        *result = *this
      EndIf
      
      ; Debug "   "+*result\class
      
      ProcedureReturn *result
    EndProcedure
    
    Procedure  GetLast( *this._S_widget, tabindex.l )
      Protected result, *after._S_widget, *parent._S_widget
      
      If *this\last\widget
        If *this\count\childrens
          LastElement(  *this\_widgets( ) )
          result =  *this\_widgets( )\last\widget
          
          ; get after widget
          If *this\after\widget
            *after = *this\after\widget
          Else
            *parent = *this
            Repeat
              *parent = *parent\_parent( )
              If Not *parent
                ProcedureReturn 0
              EndIf
              If *parent\after\widget
                *after = *parent\after\widget 
                Break
              EndIf
            Until *parent = *parent\_root( )
          EndIf
          
          If *after
            PushListPosition(  *this\_widgets( ) )
            ChangeCurrentElement(  *this\_widgets( ), *after\address )
            While PreviousElement(  *this\_widgets( ) )
              If  *this\_widgets( )\TabIndex( ) = tabindex ;Or  *this\_widgets( ) = *this 
                Break
              EndIf
            Wend
            result =  *this\_widgets( )\last\widget
            PopListPosition(  *this\_widgets( ) )
          EndIf
          
        Else
          result = *this\last\widget
        EndIf
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    Procedure.i GetPosition( *this._S_widget, position.l )
      Protected result
      
      Select position
        Case #PB_List_First 
          result = GetFirst( *this\_parent( ), *this\TabIndex( ) )
        Case #PB_List_Before 
          result = *this\before\widget
        Case #PB_List_After 
          result = *this\after\widget
        Case #PB_List_Last   
          result = GetLast( *this\_parent( ), *this\TabIndex( ) )
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetAttribute( *this._S_widget, Attribute.l )
      Protected result.i
      
      If *this\type = #__type_Tree
        If Attribute = #__tree_collapsed  
          result = *this\mode\collapse
        EndIf
      EndIf
      
      If *this\type = #__type_Splitter
        Select Attribute 
          Case #PB_Splitter_FirstGadget       : result = bar_first_gadget_( *this )
          Case #PB_Splitter_SecondGadget      : result = bar_second_gadget_( *this )
          Case #PB_Splitter_FirstMinimumSize  : result = BB1( )\size
          Case #PB_Splitter_SecondMinimumSize : result = BB2( )\size
        EndSelect
      EndIf
      
      ; is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or
         *this\type = #__type_MDI
        Select Attribute 
          Case #PB_ScrollArea_X               : result = *this\scroll\h\bar\page\pos
          Case #PB_ScrollArea_Y               : result = *this\scroll\v\bar\page\pos
          Case #PB_ScrollArea_InnerWidth      : result = *this\scroll\h\bar\max
          Case #PB_ScrollArea_InnerHeight     : result = *this\scroll\v\bar\max
          Case #PB_ScrollArea_ScrollStep      : result = *this\scroll\increment
        EndSelect
      EndIf
      
      If *this\type = #__type_Spin Or
         ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar ; Or *this\type = #__type_Splitter
        
        Select Attribute
          Case #__bar_minimum    : result = *this\bar\min          ; 1
          Case #__bar_maximum    : result = *this\bar\max          ; 2
          Case #__bar_pagelength : result = *this\bar\page\len     ; 3
          Case #__bar_scrollstep : result = *this\scroll\increment ; 5
            
          Case #__bar_buttonsize : result = BB1( )\size   
          Case #__bar_direction  : result = *this\bar\direction
          Case #__bar_invert     : result = *this\bar\invert
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.f GetState( *this._S_widget )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView Or
         *this\type = #__type_ListIcon
        
        If *this\FocusedRow( )
          ProcedureReturn *this\FocusedRow( )\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        ProcedureReturn Bool( *this\state\flag & #__S_check )
      EndIf
      
      If *this\type = #__type_Option Or
         *this\type = #__type_CheckBox
        
        ProcedureReturn *this\_box_\___state 
      EndIf
      
      If *this\type = #__type_Editor
        ProcedureReturn PressedRowindex( *this ) ; *this\edit_caret_2( )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn *this\TabWidget( )\SelectedTabIndex( )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn *this\SelectedTabIndex( ) 
        
      Else
        If *this\bar
          ProcedureReturn *this\bar\page\pos
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s GetText( *this._S_widget )
      If *this\type = #__type_Tree
        If *this\FocusedRow( ) 
          ProcedureReturn *this\FocusedRow( )\text\string
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
    
    Procedure.l GetColor( *this._S_widget, ColorType.l )
      Protected Color.l
      
      With *This
        Select ColorType
          Case #__color_line  : Color = \color\line
          Case #__color_back  : Color = \color\back
          Case #__color_front : Color = \color\front
          Case #__color_frame : Color = \color\frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;- 
    Procedure   SetCursor( *this._S_widget, *cursor )
      ProcedureReturn Cursor::Set( *this\_root( )\canvas\gadget, *cursor )
    EndProcedure
    
    Procedure   SetFrame( *this._S_widget, size.a, mode.i = 0 )
      Protected result
      If *this\fs <> size
        result = *this\fs 
        *this\fs = size
        
        If *this\_a_\transform
          a_set_size( *this\_a_\id, *this\_a_\size )
        EndIf
        ;;
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
    
    Procedure   SetClass( *this._S_widget, class.s )
      *this\class = class
    EndProcedure
    
    Procedure.b SetState( *this._S_widget, state.f )
      Protected result
      
      If *this\type = #__type_ComboBox
        If is_no_select_item_( *this\_rows( ), State )
          ProcedureReturn #False
        EndIf
        
        If *this\FocusedRow( ) <> *this\_rows( )
          
          If *this\FocusedRow( )
            If *this\FocusedRow( )\state\focus
              *this\FocusedRow( )\state\focus = #False
            EndIf
            ;             If *this\FocusedRow( )\state\flag & #__S_scroll
            ;               *this\FocusedRow( )\state\flag &~ #__S_scroll
            ;             EndIf
            
            *this\FocusedRow( )\color\state = #__S_0
          EndIf
          
          *this\FocusedRow( ) = *this\_rows( )
          *this\FocusedRow( )\state\focus = #True 
          ;           *this\FocusedRow( )\state\flag | #__S_scroll 
          ;           If *this = FocusedWidget( )
          *this\FocusedRow( )\color\state = #__S_2
          ;           Else
          ;             *this\FocusedRow( )\color\state = #__S_3
          ;           EndIf
          
          *this\text\string = *this\FocusedRow( )\text\string
        EndIf
      EndIf
      
      ; - widget::Button_SetState( )
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        If *this\flag & #__button_toggle
          ;           If *this\state\flag & #__S_check
          ;             *this\state\flag &~ #__S_check
          ;             
          ;             If *this\state\enter
          ;               *this\color\state = #__S_1 
          ;             Else
          ;               *this\color\state = #__S_0 
          ;             EndIf
          ;             
          ;           ElseIf state
          ;             *this\state\flag | #__S_check
          ;             *this\color\state = #__S_2 
          ;           EndIf
          
          If state
            *this\state\flag | #__S_check
            *this\color\state = #__S_2 
            result = 1
          ElseIf *this\state\flag & #__S_check
            *this\state\flag &~ #__S_check
            If *this\state\enter
              *this\color\state = #__S_1 
            Else
              *this\color\state = #__S_0 
            EndIf
            result = 1
          EndIf
          
          If result
            Post( *this, #PB_EventType_Change )
          EndIf
        Else
          If *this\color\state <> #__S_1
            *this\color\state = #__S_1
            result = 1
          EndIf
        EndIf
      EndIf
      
      ; - widget::CheckBox_SetState( )
      If *this\type = #__type_CheckBox
        If *this\_box_\___state<> state
          set_check_state_( *this\_box_, Bool( state = #PB_Checkbox_Inbetween ))
          
          Post( *this, #PB_EventType_Change )
          ReDraw( *this\_root( ) )
          ProcedureReturn 1
        EndIf
      EndIf
      
      ; - widget::Option_SetState( )
      If *this\type = #__type_Option
        If *this\_group And 
           *this\_box_\___state<> State
          
          If *this\_group\_group <> *this
            If *this\_group\_group
              *this\_group\_group\_box_\___state= 0
            EndIf
            *this\_group\_group = *this
          EndIf
          *this\_box_\___state= State
          
          Post( *this, #PB_EventType_Change )
          ReDraw( *this\_root( ) )
          ProcedureReturn 1
        EndIf
      EndIf
      
      ; - widget::IPaddress_SetState( )
      If *this\type = #__type_IPAddress
        If PressedRowindex( *this ) <> State : PressedRowindex( *this ) = State
          SetText( *this, Str( IPAddressField( State,0 )) + "." + 
                          Str( IPAddressField( State,1 )) + "." + 
                          Str( IPAddressField( State,2 )) + "." + 
                          Str( IPAddressField( State,3 ) ))
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
        
        If *this\edit_caret_2( ) <> State
          *this\edit_caret_2( ) = State
          
          Protected i.l, len.l
          Protected *str.Character = @*this\text\string 
          Protected *end.Character = @*this\text\string 
          
          While *end\c 
            If *end\c = #LF 
              len + ( *end - *str )/#__sOC
              ; Debug "" + i + " " + Str( len + i )  + " " +  state
              
              If len + i >= state
                *this\edit_linePos( ) = i
                *this\edit_lineDelta( ) = i
                
                *this\edit_caret_1( ) = state - ( len - ( *end - *str )/#__sOC ) - i
                *this\edit_caret_2( ) = *this\edit_caret_1( )
                
                Break
              EndIf
              i + 1
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If EnteredRowindex( *this ) <> i 
            EnteredRowindex( *this ) = i
            PressedRowindex( *this ) = i
            
            *this\edit_caret_1( ) = ( state - len - i ) 
            *this\edit_caret_2( ) = *this\edit_caret_1( )
          EndIf
          
          result = #True 
        EndIf
      EndIf
      
      ;- widget::tree_setState
      If *this\type = #__type_Tree Or 
         *this\type = #__type_Tree Or 
         *this\type = #__type_ListView
        ; Debug *this\mode\check 
        
        
        ; reset all selected items
        If State =- 1
          If *this\FocusedRow( ) 
            If *this\mode\check <> #__m_optionselect
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
            EndIf
            
            *this\FocusedRow( )\color\state = #__S_0
            *this\FocusedRow( ) = #Null
          EndIf
        EndIf
        
        ; 
        If is_no_select_item_( *this\_rows( ), State )
          ProcedureReturn #False
        EndIf
        
        If *this\count\items
          If *this\FocusedRow( ) <> *this\_rows( )
            If *this\FocusedRow( ) 
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
              
              *this\FocusedRow( )\color\state = #__S_0
            EndIf
            
            ; click select mode 
            If *this\mode\check = #__m_clickselect
              If *this\_rows( )\state\focus 
                *this\_rows( )\state\focus = #False
                *this\_rows( )\color\state = #__S_0
              Else
                *this\_rows( )\state\focus = #True
                *this\_rows( )\color\state = #__S_3
              EndIf
              
              Post( *this, #PB_EventType_Change, *this\_rows( )\index )
            Else
              If *this\_rows( )\state\focus = #False
                *this\_rows( )\state\focus = #True
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, *this\_rows( )\index, 1 )
                EndIf
              EndIf
              
              *this\_rows( )\color\state = #__S_3
            EndIf
            
            *this\FocusedRow( ) = *this\_rows( )
            *this\scroll\state =- 1
            
            ;*this\change = 1
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      
      ; - Panel_SetState( )
      If *this\type = #__type_Panel
        result = bar_tab_SetState( *this\TabWidget( ), state )
      EndIf
      
      ; - Tabbar_SetState( )
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_SetState( *this, state )
      EndIf
      
      Select *this\type
        Case #__type_Spin ,
             #__type_TabBar,#__type_ToolBar,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter       
          
          result = bar_SetState( *this\bar, state )
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetAttribute( *this._S_widget, Attribute.l, *value )
      Protected result.i
      Protected value = *value
      
      If *this\type = #__type_Spin Or
         ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_Splitter
        result = bar_SetAttribute( *this, Attribute, *value )
      EndIf
      
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        Select Attribute 
          Case #PB_Button_Image
            set_image_( *this, *this\image, *value )
            set_image_( *this, *this\image[#__img_released], *value )
            
          Case #PB_Button_PressedImage
            set_image_( *this, *this\image[#__img_pressed], *value )
            
        EndSelect
      EndIf
      
      ;  is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or 
         *this\type = #__type_MDI
        
        Select Attribute 
          Case #PB_ScrollArea_X 
            If bar_SetState( *this\scroll\h\bar, *value )
              ; scroll_x_( *this ) = *this\scroll\h\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_Y               
            If bar_SetState( *this\scroll\v\bar, *value )
              ; scroll_y_( *this ) = *this\scroll\v\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerWidth      
            If bar_SetAttribute( *this\scroll\h, #__bar_maximum, *value )
              scroll_width_( *this ) = *this\scroll\h\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerHeight     
            If bar_SetAttribute( *this\scroll\v, #__bar_maximum, *value )
              scroll_height_( *this ) = *this\scroll\v\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_ScrollStep      
            *this\scroll\increment = value
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetText( *this._S_widget, Text.s )
      Protected result.i, Len.i, String.s, i.i
      
      If *this\type = #__type_Window
        *this\caption\text\string = Text
      EndIf
      
      If *this\type = #__type_Tree
        If *this\FocusedRow( ) 
          *this\FocusedRow( )\text\string = Text
        EndIf
      EndIf
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_String Or
         *this\type = #__type_text Or
         *this\type = #__type_hyperlink Or
         *this\type = #__type_Button
        
        ProcedureReturn edit_SetText( *this, Text )
        
        
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
    
    Procedure.i SetFont( *this._S_widget, FontID.i )
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
          ;           If StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
          ;             draw_font_( *this )
          ;             Draw( *this )
          ;             
          ;             StopDrawing( )
          ;           EndIf
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetColor( *this._S_widget, ColorType.l, Color.l )
      *this\color\alpha.allocate( COLOR )
      Protected result.l, alpha.a = Alpha( Color )
      If Not alpha : Color = Color&$FFFFFF | 255<<24 : EndIf
      set_color_( result, *this\color, ColorType, Color, alpha )
      If result : PostCanvasRepaint( *this\_root( ) ) : EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure   SetImage( *this._S_widget, *image )
      set_image_( *this, *this\Image, *image )
    EndProcedure
    
    Procedure   SetBackgroundImage( *this._S_widget, *image )
      set_image_( *this, *this\Image[#__img_background], *image )
    EndProcedure
    
    Procedure   SetData( *this._S_widget, *data )
      *this\data = *data
    EndProcedure
    
    Procedure SetForeground( *this._S_widget )
      While is_window_( *this ) 
        SetPosition( *this, #PB_List_Last )
        *this = *this\_window( )
      Wend
      
      If StickyWindow( )
        SetPosition( StickyWindow( ), #PB_List_Last )
      EndIf
    EndProcedure
    
    Procedure.i Sticky( *window._S_widget = #PB_Default, state.b = #PB_Default )
      Protected result = StickyWindow( )
      
      If state <> #PB_Default 
        If is_window_( *window )
          If state
            StickyWindow( ) = *window
          Else
            StickyWindow( ) = #Null 
          EndIf
          
          SetForeground( *window )
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetDeactive( *this._S_widget )
      Protected result, *active._S_widget
      
      If GetActive( ) <> *this\_window( ) 
        If GetActive( )\state\focus = #True
          GetActive( )\state\focus = #False
          GetActive( )\color\state = #__S_3
          result | DoEvents( GetActive( ), #PB_EventType_LostFocus )
        EndIf
      EndIf
      
      ; when we deactivate the window 
      ; we will deactivate his last active gadget
      If GetActive( )\gadget And 
         GetActive( )\gadget\state\focus = #True 
        GetActive( )\gadget\state\focus = #False
        GetActive( )\gadget\color\state = #__S_3
        result | DoEvents( GetActive( )\gadget, #PB_EventType_LostFocus )
        
        ; is integral scroll bars
        If GetActive( )\gadget\scroll
          If GetActive( )\gadget\scroll\v And 
             Not GetActive( )\gadget\scroll\v\hide And
             GetActive( )\gadget\scroll\v\type
            
            If GetActive( )\gadget\scroll\v\state\focus = #True
              GetActive( )\gadget\scroll\v\state\focus = #False
              GetActive( )\gadget\scroll\v\color\state = #__S_3
              result | DoEvents( GetActive( )\gadget\scroll\v, #PB_EventType_LostFocus )
            EndIf
          EndIf
          If GetActive( )\gadget\scroll\h And
             Not GetActive( )\gadget\scroll\h\hide And 
             GetActive( )\gadget\scroll\h\type
            
            If GetActive( )\gadget\scroll\h\state\focus = #True
              GetActive( )\gadget\scroll\h\state\focus = #False
              GetActive( )\gadget\scroll\h\color\state = #__S_3
              result | DoEvents( GetActive( )\gadget\scroll\h, #PB_EventType_LostFocus )
            EndIf
          EndIf
        EndIf
        
        ; is integral tab bar
        If GetActive( )\gadget\TabWidget( ) And 
           Not GetActive( )\gadget\TabWidget( )\hide And 
           GetActive( )\gadget\TabWidget( )\type
          
          If GetActive( )\gadget\TabWidget( )\state\focus = #True
            GetActive( )\gadget\TabWidget( )\state\focus = #False
            GetActive( )\gadget\color\state = #__S_3
            result | DoEvents( GetActive( )\gadget\TabWidget( ), #PB_EventType_LostFocus )
          EndIf
        EndIf
      EndIf
      
      ; set deactive all parents
      If GetActive( )\gadget And 
         GetActive( )\gadget\address
        *active = GetActive( )\gadget
      ElseIf GetActive( )\address
        *active = GetActive( )
      EndIf
      
      If *active And 
         *active\address
        ;               ChangeCurrentElement( *active\_widgets( ), *active\address )
        ;               While PreviousElement( *active\_widgets( ))
        ;                 If *active\_widgets( ) = *this\_window( )
        ;                   Break
        ;                 EndIf
        ;                 If IsChild( *active, *active\_widgets( ))
        ;                   If *active\_widgets( )\state\focus = #True
        ;                     *active\_widgets( )\state\focus = #False
        ;                     *active\_widgets( )\color\state = 0
        ;                   ;;  result | DoEvents( *active\_widgets( ), #PB_EventType_LostFocus )
        ;                   EndIf
        ;                 EndIf
        ;               Wend 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetActive( *this._S_widget )
      Protected result.i, *active._S_widget
      
      If *this 
        If a_transform_( *this )
          ProcedureReturn 0
        EndIf
        
        FocusedWidget( ) = *this
        ; если нужно отключить событие интегрированного гаджета
        ;         If is_integral_( *this )
        ;           *this = *this\_parent( )
        ;         EndIf 
        
        If *this\state\focus = #False
          *this\state\focus = #True
          
          ; deactive
          If GetActive( ) 
            SetDeactive( *this )
          EndIf
          
          ; set active all parents
          If *this\address
            ;             ChangeCurrentElement( *this\_widgets( ), *this\address )
            ;             While PreviousElement( *this\_widgets( ))
            ;               ;If *this\_widgets( )\type = #__Type_Window
            ;               If IsChild( *this, *this\_widgets( )) ;And *this\_widgets( )\container
            ;                 If *this\_widgets( )\state\focus = #False
            ;                   *this\_widgets( )\state\focus = #True
            ;                   *this\_widgets( )\color\state = #__S_2
            ;                   result | DoEvents( *this\_widgets( ), #PB_EventType_Focus )
            ;                 EndIf
            ;               EndIf
            ;               ;EndIf
            ;             Wend 
          EndIf
          
          ; get active window
          If is_window_( *this ) Or is_root_(*this )
            GetActive( ) = *this
          Else
            If is_integral_( *this )
              GetActive( ) = *this\_parent( )\_window( )
              GetActive( )\gadget = *this\_parent( )
            Else
              GetActive( ) = *this\_window( )
              GetActive( )\gadget = *this
            EndIf  
          EndIf
          
          ; when we activate the gadget
          ; first we activate its parent window
          If GetActive( )\state\focus = #False
            GetActive( )\state\focus = #True
            GetActive( )\color\state = #__S_2
            result | DoEvents( GetActive( ), #PB_EventType_Focus )
          EndIf
          
          ; 
          *this\color\state = #__S_2
          result | DoEvents( *this, #PB_EventType_Focus )
          
          ; when we activate the window
          ; we will activate his last gadget that lost focus
          If GetActive( )\gadget 
            If GetActive( )\gadget\state\focus = #False
              GetActive( )\gadget\state\focus = #True
              GetActive( )\gadget\color\state = #__S_2
              result | DoEvents( GetActive( )\gadget, #PB_EventType_Focus )
            EndIf
          EndIf
          
          ; set window foreground position
          SetForeground( GetActive( ))
        EndIf
        
      Else
        If GetActive( ) 
          SetDeactive( *this )
          GetActive( ) = 0
        EndIf
      EndIf
      
      result = #True
      ProcedureReturn result
    EndProcedure
    
    
    Procedure   SetPosition( *this._S_widget, position.l, *widget._S_widget = #Null ) ; Ok
      If *widget = #Null
        Select Position 
          Case #PB_List_First  : *widget = *this\_parent( )\first\widget
          Case #PB_List_Before : *widget = *this\before\widget
          Case #PB_List_After  : *widget = *this\after\widget
          Case #PB_List_Last   : *widget = *this\_parent( )\last\widget
        EndSelect
      EndIf
      
      If *widget And *this <> *widget And *this\TabIndex( ) = *widget\TabIndex( )
        If Position = #PB_List_First Or Position = #PB_List_Before
          
          PushListPosition(  *this\_widgets( ))
          ChangeCurrentElement(  *this\_widgets( ), *this\address )
          MoveElement(  *this\_widgets( ), #PB_List_Before, *widget\address )
          
          If *this\count\childrens
            While PreviousElement(  *this\_widgets( )) 
              If IsChild(  *this\_widgets( ), *this )
                MoveElement(  *this\_widgets( ), #PB_List_After, *widget\address )
              EndIf
            Wend
            
            While NextElement(  *this\_widgets( )) 
              If IsChild(  *this\_widgets( ), *this )
                MoveElement(  *this\_widgets( ), #PB_List_Before, *widget\address )
              EndIf
            Wend
          EndIf
          PopListPosition(  *this\_widgets( ))
        EndIf  
        
        If Position = #PB_List_Last Or Position = #PB_List_After
          Protected *last._S_widget = GetLast( *widget, *widget\TabIndex( )) 
          
          PushListPosition(  *this\_widgets( ))
          ChangeCurrentElement(  *this\_widgets( ), *this\address )
          MoveElement(  *this\_widgets( ), #PB_List_After, *last\address )
          
          If *this\count\childrens
            While NextElement(  *this\_widgets( )) 
              If IsChild(  *this\_widgets( ), *this )
                MoveElement(  *this\_widgets( ), #PB_List_Before, *last\address )
              EndIf
            Wend
            
            While PreviousElement(  *this\_widgets( )) 
              If IsChild(  *this\_widgets( ), *this )
                MoveElement(  *this\_widgets( ), #PB_List_After, *this\address )
              EndIf
            Wend
          EndIf
          PopListPosition(  *this\_widgets( ))
        EndIf
        
        ;
        If *this\before\widget
          *this\before\widget\after\widget = *this\after\widget
        EndIf
        If *this\after\widget
          *this\after\widget\before\widget = *this\before\widget
        EndIf
        If *this\_parent( )\first\widget = *this
          *this\_parent( )\first\widget = *this\after\widget
        EndIf
        If *this\_parent( )\last\widget = *this
          *this\_parent( )\last\widget = *this\before\widget
        EndIf
        
        ;
        If Position = #PB_List_First Or Position = #PB_List_Before
          
          *this\after\widget = *widget
          *this\before\widget = *widget\before\widget 
          *widget\before\widget = *this
          
          If *this\before\widget
            *this\before\widget\after\widget = *this
          Else
            If *this\_parent( )\first\widget
              *this\_parent( )\first\widget\before\widget = *this
            EndIf
            *this\_parent( )\first\widget = *this
          EndIf
        EndIf
        
        If Position = #PB_List_Last Or Position = #PB_List_After
          
          *this\before\widget = *widget
          *this\after\widget = *widget\after\widget 
          *widget\after\widget = *this
          
          If *this\after\widget
            *this\after\widget\before\widget = *this
          Else
            If *this\_parent( )\last\widget
              *this\_parent( )\last\widget\after\widget = *this
            EndIf
            *this\_parent( )\last\widget = *this
          EndIf
        EndIf
        
        ProcedureReturn #True
      EndIf
      
    EndProcedure
    
    Procedure   SetParent( *this._S_widget, *parent._S_widget, tabindex.l = 0 )
      Protected ReParent.b, x,y, *last._S_widget, *lastParent._S_widget, NewList *D._S_widget( ), NewList *C._S_widget( )
      
      If *parent
        If *this\_parent( ) = *parent And
           *this\TabIndex( ) = tabindex
          ProcedureReturn #False
        EndIf
        
        ;TODO
        If tabindex < 0 
          If *parent\TabWidget( )
            tabindex = *parent\TabWidget( )\OpenedTabIndex( )
          Else
            tabindex = 0
          EndIf
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex%2
              bar_first_gadget_( *parent ) = *this
              bar_is_first_gadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If bar_is_first_gadget_( *parent )
                ProcedureReturn 0
              EndIf
            Else
              bar_second_gadget_( *parent ) = *this
              bar_is_second_gadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If bar_is_second_gadget_( *parent )
                ProcedureReturn 0
              EndIf
            EndIf    
          EndIf    
        EndIf
        
        *this\TabIndex( ) = tabindex
        
        ; set hide state 
        If *parent\hide
          *this\hide = #True
        ElseIf *parent\TabWidget( )
          ; hide all children except the selected tab
          *this\hide = Bool(*parent\TabWidget( )\SelectedTabIndex( ) <> tabindex)
        EndIf
        
        If *parent\last\widget
          *last = GetLast( *parent, tabindex )
          
        EndIf
        
        If *this And 
           *this\_parent( )
          
          If *this\address
            *lastParent = *this\_parent( )
            *lastParent\count\childrens - 1
            
            ChangeCurrentElement(  *this\_widgets( ), *this\address )
            AddElement( *D( ) ) : *D( ) =  *this\_widgets( )
            
            If *this\count\childrens
              PushListPosition(  *this\_widgets( ) )
              While NextElement(  *this\_widgets( ) )
                If Not IsChild(  *this\_widgets( ), *this ) 
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) =  *this\_widgets( )
                *D( )\_window( ) = *parent\_window( )
                *D( )\_root( ) = *parent\_root( )
                ;; Debug " children - "+ *D( )\data +" - "+ *this\data
                
              Wend 
              PopListPosition(  *this\_widgets( ) )
            EndIf
            
            ; move with a parent and his children
            If *this\_root( ) = *parent\_root( )
              ; move inside the list
              LastElement( *D( ) )
              Repeat
                ChangeCurrentElement(  *this\_widgets( ), *D( )\address )
                MoveElement(  *this\_widgets( ), #PB_List_After, *last\address )
              Until PreviousElement( *D( ) ) = #False
            Else
              ForEach *D( )
                ChangeCurrentElement(  *this\_widgets( ), *D( )\address )
                ; go to the end of the list to split the list
                MoveElement(  *this\_widgets( ), #PB_List_Last ) 
              Next
              
              ; now we split the list and transfer it to another list
              ChangeCurrentElement(  *this\_widgets( ), *this\address )
              SplitList(  *this\_widgets( ), *D( ) )
              
              ; move between lists
              ChangeCurrentElement( *parent\_widgets( ) , *last\address )
              MergeLists( *D( ), *parent\_widgets( ) , #PB_List_After )
            EndIf
            
            ReParent = #True 
          EndIf
          
          ; position in list
          If *this\after\widget
            *this\after\widget\before\widget = *this\before\widget
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this\after\widget
          EndIf
          If *this\_parent( )\first\widget = *this
            ;             If *this\after\widget
            *this\_parent( )\first\widget = *this\after\widget
            ;             Else
            ;               *this\_parent( )\first\widget = *this\_parent( ) ; if last type
            ;             EndIf
          EndIf 
          If *this\_parent( )\last\widget = *this
            If *this\before\widget
              *this\_parent( )\last\widget = *this\before\widget
            Else
              *this\_parent( )\last\widget = *this\_parent( ) ; if last type
            EndIf
          EndIf 
        Else
          If *parent\_root( )
            If *last
              ChangeCurrentElement( *parent\_widgets( ) , *last\address )
            Else
              LastElement( *parent\_widgets( )  )
            EndIf
            
            AddElement( *parent\_widgets( )  ) 
            *parent\_widgets( )  = *this
            *this\index = ListIndex( *parent\_widgets( )  ) 
            *this\address = @*parent\_widgets( ) 
          EndIf
          
          *this\last\widget = *this ; if last type
        EndIf
        
        If *parent\last\widget = *parent
          *parent\first\widget = *this
          *parent\last\widget = *this
          *this\before\widget = #Null
          *this\after\widget = #Null
        Else
          ; if the parent had the last item
          ; then we make it "previous" instead of "present"
          ; and "present" becomes "subsequent" instead of "previous"
          If *this\_parent( )
            *this\before\widget = *last
            ; for the panel element
            If *last\TabIndex( ) = *this\TabIndex( )
              *this\after\widget = *last\after\widget
            EndIf
          Else
            ; for the panel element
            If *parent\last\widget And *parent\last\widget\TabIndex( ) = *this\TabIndex( )
              *this\before\widget = *parent\last\widget
            EndIf
            *parent\last\widget = *this
            *this\after\widget = #Null
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this
          EndIf
        EndIf
        
        
        ;           
        *parent\count\childrens + 1
        If *parent <> *parent\_root( )
          *parent\_root( )\count\childrens + 1
        EndIf
        
        ;
        *this\_root( ) = *parent\_root( )
        If is_window_( *parent ) 
          *this\_window( ) = *parent
        Else
          *this\_window( ) = *parent\_window( )
        EndIf
        *this\_parent( ) = *parent
        
        ;
        *this\level = *parent\level + 1
        *this\count\parents = *parent\count\parents + 1
        
        
        ; TODO
        If *this\_window( )
          Static NewMap typecount.l( )
          
          *this\count\index = typecount( Hex( *this\_window( ) + *this\type ))
          typecount( Hex( *this\_window( ) + *this\type )) + 1
          
          If *parent\_a_\transform
            *this\count\type = typecount( Hex( *parent ) + "_" + Hex( *this\type ))
            typecount( Hex( *parent ) + "_" + Hex( *this\type )) + 1
          EndIf
        EndIf
        
        ; set transformation for the child
        If Not *this\_a_\transform And *parent\_a_\transform 
          a_set_transform_state_( *this, Bool( *parent\_a_\transform ) )
          
          *this\_a_\mode = #__a_full | #__a_position
          a_set( *this, #__a_size )
        EndIf
        
        ;
        If ReParent
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
          
          Resize( *this, x - scroll_x_( *parent ), y - scroll_y_( *parent ), #PB_Ignore, #PB_Ignore )
          
          If *this\_root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( *this\_root( )\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
            *this\_root( )\canvas\ResizeBeginWidget = #Null
          EndIf
          
          PostCanvasRepaint( *parent )
          PostCanvasRepaint( *lastParent )
          
          ;           ChangeCurrentRoot(*parent\_root( )\canvas\address)
          ;           ReDraw(Root())
          ;           ChangeCurrentRoot(*lastParent\_root( )\canvas\address)
          ;           ReDraw(Root())
          
        EndIf
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i SetAlignmentFlag( *this._S_widget, Mode.l, Type.l = 1 ) ; ok
      Protected rx.b, ry.b
      
      With *this
        Select Type
          Case 1 ; widget
            If \_parent( )
              If Not \_parent( )\align
                \_parent( )\align.allocate( ALIGN )
              EndIf
              If Not \align
                \align.allocate( ALIGN )
              EndIf
              
              ; horizontal
              If Mode & #__align_left = #__align_left Or 
                 ( Not Mode & #__align_right = #__align_right And 
                   Not Mode & #__align_center = #__align_center )
                \align\anchor\left = 1
              EndIf
              If Mode & #__align_right = #__align_right Or 
                 ( Mode & #__align_full = #__align_full And 
                   Not Mode & #__align_left = #__align_left )
                \align\anchor\right = 1
              EndIf
              ; proportional
              If Mode & #__align_proportional_horizontal = #__align_proportional_horizontal
                If Mode & #__align_left = #__align_left
                  \align\anchor\left =- 1
                EndIf
                If Mode & #__align_right = #__align_right
                  \align\anchor\right =- 1
                EndIf
              EndIf
              
              ; vertical
              If Mode & #__align_top = #__align_top Or 
                 ( Not Mode & #__align_bottom = #__align_bottom And 
                   Not Mode & #__align_center = #__align_center )
                \align\anchor\top = 1
              EndIf
              If Mode & #__align_bottom = #__align_bottom Or 
                 ( Mode & #__align_full = #__align_full And 
                   Not Mode & #__align_top = #__align_top )
                \align\anchor\bottom = 1
              EndIf
              ; proportional
              If Mode & #__align_proportional_vertical = #__align_proportional_vertical
                If Mode & #__align_top = #__align_top
                  \align\anchor\top =- 1
                EndIf
                If Mode & #__align_bottom = #__align_bottom
                  \align\anchor\bottom =- 1
                EndIf
              EndIf
              
              Protected parent_width, parent_height 
              
              If *this\_parent( )\type = #__type_window
                parent_width = \_parent( )\width[#__c_inner]
                parent_height = \_parent( )\height[#__c_inner]
              Else
                parent_width = \_parent( )\width[#__c_frame]
                parent_height = \_parent( )\height[#__c_frame]
              EndIf
              
              ;
              If \_parent( )\align\indent\right = 0
                \_parent( )\align\indent\left = \_parent( )\x[#__c_container] 
                \_parent( )\align\indent\right = \_parent( )\align\indent\left + parent_width
              EndIf
              If \_parent( )\align\indent\bottom = 0
                \_parent( )\align\indent\top = \_parent( )\y[#__c_container] 
                \_parent( )\align\indent\bottom = \_parent( )\align\indent\top + parent_height 
              EndIf
              
              \align\indent\left = \x[#__c_container]
              \align\indent\right = \align\indent\left + \width
              
              \align\indent\top = \y[#__c_container]
              \align\indent\bottom = \align\indent\top + \height
              
              
              ; docking
              If Mode & #__align_auto = #__align_auto
                parent_width = ( \_parent( )\align\indent\right - \_parent( )\align\indent\left - \_parent( )\fs*2 )
                parent_height = ( \_parent( )\align\indent\bottom - \_parent( )\align\indent\top - \_parent( )\fs*2 )
                
                ; full horizontal
                If \align\anchor\right = 1 And \align\anchor\left = 1 
                  \align\indent\left = \x[#__c_container]
                  \align\indent\right = \align\indent\left + parent_width
                  ;; Debug ""+ \text\string +" "+ \_parent( )\x +" "+ \_parent( )\align\indent\left +" "+ \_parent( )\align\indent\right +" "+ \_parent( )\width[#__c_inner]
                  ; center
                ElseIf \align\anchor\right = 0 And \align\anchor\left = 0
                  \align\indent\left = ( parent_width - \width )/2
                  \align\indent\right = \align\indent\left + \width
                  ; right
                ElseIf \align\anchor\right = 1 And \align\anchor\left = 0 
                  \align\indent\left = parent_width - \width
                  \align\indent\right = \align\indent\left + \width
                EndIf
                
                ; full vertical
                If \align\anchor\bottom = 1 And \align\anchor\top = 1
                  \align\indent\top = \y[#__c_container] 
                  \align\indent\bottom = \align\indent\top + parent_height
                  ; center
                ElseIf \align\anchor\bottom = 0 And \align\anchor\top = 0
                  \align\indent\top = ( parent_height - \height )/2
                  \align\indent\bottom = \align\indent\top + \height
                  ; bottom
                ElseIf \align\anchor\bottom = 1
                  \align\indent\top = parent_height - \height
                  \align\indent\bottom = \align\indent\top + \height
                EndIf
                
                ; dock
                If Mode & #__align_full = #__align_full
                  ; loop enumerate widgets
                  If StartEnumerate( *this\_parent( ) ) 
                    If enumWidget( )\align 
                      
                      If ( enumWidget( )\align\anchor\left = 0 Or enumWidget( )\align\anchor\right = 0 ) And 
                         ( enumWidget( )\align\anchor\top = 1 And enumWidget( )\align\anchor\bottom = 1 )
                        enumWidget( )\align\indent\top = enumWidget( )\_parent( )\align\auto\top
                        enumWidget( )\align\indent\bottom = parent_height - enumWidget( )\_parent( )\align\auto\bottom
                      EndIf
                      
                      ;                         If ( enumWidget( )\align\anchor\top = 0 Or enumWidget( )\align\anchor\bottom = 0 ) And 
                      ;                            ( enumWidget( )\align\anchor\left = 1 And enumWidget( )\align\anchor\right = 1 )
                      ;                           Debug enumWidget( )\text\string
                      ;                           enumWidget( )\align\indent\left = enumWidget( )\_parent( )\align\auto\left
                      ;                           enumWidget( )\align\indent\right = parent_width - enumWidget( )\_parent( )\align\auto\right
                      ;                         EndIf
                    EndIf
                    StopEnumerate( )
                  EndIf
                EndIf
                ;                 
              EndIf
              
              ; update parent childrens coordinate
              Resize( \_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            EndIf
          Case 2 ; text
          Case 3 ; image
        EndSelect
      EndWith
    EndProcedure
    
    Procedure SetAlignment( *this._S_widget, left.l, top.l, right.l, bottom.l, auto.b = #True )
      Protected flag
      
      ;If Not *this\align
      ;
      If left = #__align_full
        left = #__align_auto
        top = #__align_auto
        bottom = #__align_auto
        flag | #__align_full
      EndIf
      If right = #__align_full
        right = #__align_auto
        top = #__align_auto
        bottom = #__align_auto
        flag | #__align_full
      EndIf
      If top = #__align_full
        top = #__align_auto
        left = 1;#__align_auto
        right = 1;#__align_auto
        flag | #__align_full
      EndIf
      If bottom = #__align_full
        bottom = #__align_auto
        left = 1;#__align_auto
        right = 1;#__align_auto
        flag | #__align_full
      EndIf
      
      ;
      If left = #__align_proportional Or 
         right = #__align_proportional
        flag | #__align_proportional_horizontal
      EndIf
      If top = #__align_proportional Or
         bottom = #__align_proportional
        flag | #__align_proportional_vertical
      EndIf
      
      ;
      If left
        flag | #__align_left
      EndIf
      If top
        flag | #__align_top
      EndIf
      If right
        flag | #__align_right
      EndIf
      If bottom
        flag | #__align_bottom
      EndIf
      If left > 0 And top > 0 And right > 0 And bottom > 0 
        flag | #__align_full
      ElseIf ( left = 0 And top = 0 And right = 0 And bottom = 0 ) Or
             (( left Or right ) And Not ( bottom Or top )) Or 
             (( bottom Or top ) And Not ( left Or right ))
        flag | #__align_center
      EndIf
      
      ;
      If flag
        If auto
          flag | #__align_auto
        EndIf
        ;;SetAlignmentFlag( *this, flag )
        
        If*this\_parent( )
          If Not *this\_parent( )\align
            *this\_parent( )\align.allocate( ALIGN )
          EndIf
          If Not *this\align
            *this\align.allocate( ALIGN )
            ;               *this\align\delta\x = *this\x[#__c_container]
            ;               *this\align\delta\y = *this\y[#__c_container]
            ;               *this\align\delta\width = *this\width[#__c_frame]
            ;               *this\align\delta\height = *this\height[#__c_frame]
          Else
            ; auto stick reset
            If *this\align\anchor\left And *this\align\anchor\right = 0 
              *this\_parent( )\align\auto\left - *this\align\indent\right
            EndIf
            If *this\align\anchor\right And *this\align\anchor\left = 0
              *this\_parent( )\align\auto\right - ( ( *this\_parent( )\align\indent\right - *this\_parent( )\align\indent\left - *this\_parent( )\fs*2 ) - *this\align\indent\left )
            EndIf
            If *this\align\anchor\top And *this\align\anchor\bottom = 0
              *this\_parent( )\align\auto\top - *this\align\indent\bottom
            EndIf
            If *this\align\anchor\bottom And *this\align\anchor\top = 0
              *this\_parent( )\align\auto\bottom - ( ( *this\_parent( )\align\indent\bottom - *this\_parent( )\align\indent\top - *this\_parent( )\fs*2 ) - *this\align\indent\top )
            EndIf
          EndIf
          
          ;             ; center
          ;             ;If flag & #__align_center = #__align_center
          ;               *this\align\anchor\left = 0
          ;               *this\align\anchor\top = 0
          ;               *this\align\anchor\right = 0
          ;               *this\align\anchor\bottom = 0
          ;             ;EndIf
          
          ; horizontal
          If flag & #__align_left = #__align_left Or 
             ( Not flag & #__align_right = #__align_right And 
               Not flag & #__align_center = #__align_center )
            *this\align\anchor\left = 1
          Else
            *this\align\anchor\left = 0
          EndIf
          If flag & #__align_right = #__align_right Or 
             ( flag & #__align_full = #__align_full And 
               Not flag & #__align_left = #__align_left )
            *this\align\anchor\right = 1
          Else
            *this\align\anchor\right = 0
          EndIf
          ; proportional
          If flag & #__align_proportional_horizontal = #__align_proportional_horizontal
            If flag & #__align_left = #__align_left
              *this\align\anchor\left =- 1
            EndIf
            If flag & #__align_right = #__align_right
              *this\align\anchor\right =- 1
            EndIf
          EndIf
          
          ; vertical
          If flag & #__align_top = #__align_top Or 
             ( Not flag & #__align_bottom = #__align_bottom And 
               Not flag & #__align_center = #__align_center )
            *this\align\anchor\top = 1
          Else
            *this\align\anchor\top = 0
          EndIf
          If flag & #__align_bottom = #__align_bottom Or 
             ( flag & #__align_full = #__align_full And 
               Not flag & #__align_top = #__align_top )
            *this\align\anchor\bottom = 1
          Else
            *this\align\anchor\bottom = 0
          EndIf
          ; proportional
          If flag & #__align_proportional_vertical = #__align_proportional_vertical
            If flag & #__align_top = #__align_top
              *this\align\anchor\top =- 1
            EndIf
            If flag & #__align_bottom = #__align_bottom
              *this\align\anchor\bottom =- 1
            EndIf
          EndIf
          
          ;
          Protected parent_width, parent_height 
          If *this\_parent( )\type = #__type_window
            parent_width = *this\_parent( )\width[#__c_inner]
            parent_height = *this\_parent( )\height[#__c_inner]
          Else
            parent_width = *this\_parent( )\width[#__c_frame]
            parent_height = *this\_parent( )\height[#__c_frame]
          EndIf
          
          ;
          If*this\_parent( )\align\indent\right = 0
            *this\_parent( )\align\indent\left = *this\_parent( )\x[#__c_container] 
            *this\_parent( )\align\indent\right = *this\_parent( )\align\indent\left + parent_width
          EndIf
          If*this\_parent( )\align\indent\bottom = 0
            *this\_parent( )\align\indent\top = *this\_parent( )\y[#__c_container] 
            *this\_parent( )\align\indent\bottom = *this\_parent( )\align\indent\top + parent_height 
          EndIf
          
          ;
          If flag & #__align_auto = #__align_auto
            parent_width = ( *this\_parent( )\align\indent\right - *this\_parent( )\align\indent\left - *this\_parent( )\fs*2 )
            parent_height = ( *this\_parent( )\align\indent\bottom - *this\_parent( )\align\indent\top - *this\_parent( )\fs*2 )
            
            ; full horizontal
            If *this\align\anchor\right = 1 And *this\align\anchor\left = 1 
              If Not *this\align\width
                *this\align\width = *this\width
              EndIf
              *this\align\indent\left = 0
              *this\align\indent\right = *this\align\indent\left + parent_width
            Else
              If *this\align\width 
                *this\width = *this\align\width
                *this\align\width = 0
              EndIf
              
              ; left
              If *this\align\anchor\right = 0 And *this\align\anchor\left = 1
                *this\align\indent\left = 0
                *this\align\indent\right = *this\align\indent\left + *this\width
                ; center
              ElseIf *this\align\anchor\right = 0 And *this\align\anchor\left = 0
                *this\align\indent\left = ( parent_width - *this\width ) / 2
                *this\align\indent\right = *this\align\indent\left + *this\width
                ; right
              ElseIf *this\align\anchor\right = 1 And *this\align\anchor\left = 0 
                *this\align\indent\left = parent_width - *this\width
                *this\align\indent\right = *this\align\indent\left + *this\width
              EndIf
            EndIf
            
            ; full vertical
            If *this\align\anchor\bottom = 1 And *this\align\anchor\top = 1
              If Not *this\align\height
                *this\align\height = *this\height
              EndIf
              *this\align\indent\top = 0 
              *this\align\indent\bottom = *this\align\indent\top + parent_height
            Else
              If *this\align\height 
                *this\height = *this\align\height
                *this\align\height = 0
              EndIf
              
              ; top
              If *this\align\anchor\bottom = 0 And *this\align\anchor\top = 1
                *this\align\indent\top = 0
                *this\align\indent\bottom = *this\align\indent\top + *this\height
                ; center
              ElseIf *this\align\anchor\bottom = 0 And *this\align\anchor\top = 0
                *this\align\indent\top = ( parent_height - *this\height ) / 2
                *this\align\indent\bottom = *this\align\indent\top + *this\height
                ; bottom
              ElseIf *this\align\anchor\bottom = 1
                *this\align\indent\top = parent_height - *this\height
                *this\align\indent\bottom = *this\align\indent\top + *this\height
              EndIf
            EndIf
          Else
            *this\align\indent\left = *this\x[#__c_container]
            *this\align\indent\right = *this\align\indent\left + *this\width
            
            *this\align\indent\top = *this\y[#__c_container]
            *this\align\indent\bottom = *this\align\indent\top + *this\height
          EndIf
        EndIf
        
      EndIf
      ;EndIf
      
      
      If *this\align
        ; auto stick set
        If *this\_parent( )\align 
          If left = #__align_auto And 
             *this\_parent( )\align\auto\left
            left =- *this\_parent( )\align\auto\left
          EndIf
          If right = #__align_auto And 
             *this\_parent( )\align\auto\right
            right =- *this\_parent( )\align\auto\right
          EndIf
          If left < 0 Or right < 0
            If left And right
              *this\align\indent\left - left
              *this\align\indent\right + right
            Else
              *this\align\indent\left - left + right 
              *this\align\indent\right - left + right
            EndIf
          EndIf
          
          If top = #__align_auto And 
             *this\_parent( )\align\auto\top
            top =- *this\_parent( )\align\auto\top
          EndIf
          If bottom = #__align_auto And 
             *this\_parent( )\align\auto\bottom
            bottom =- *this\_parent( )\align\auto\bottom
          EndIf
          If top < 0 Or bottom < 0
            If top And bottom
              *this\align\indent\top - top
              *this\align\indent\bottom + bottom
            Else
              *this\align\indent\top - top + bottom
              *this\align\indent\bottom - top + bottom
            EndIf
          EndIf
        EndIf
        
        ; auto stick get
        If *this\align\anchor\left And *this\align\anchor\right = 0 
          *this\_parent( )\align\auto\left = *this\align\indent\right
        EndIf
        If *this\align\anchor\right And *this\align\anchor\left = 0
          *this\_parent( )\align\auto\right = ( *this\_parent( )\align\indent\right - *this\_parent( )\align\indent\left - *this\_parent( )\fs*2 ) - *this\align\indent\left 
        EndIf
        If *this\align\anchor\top And *this\align\anchor\bottom = 0
          *this\_parent( )\align\auto\top = *this\align\indent\bottom
        EndIf
        If *this\align\anchor\bottom And *this\align\anchor\top = 0
          *this\_parent( )\align\auto\bottom = ( *this\_parent( )\align\indent\bottom - *this\_parent( )\align\indent\top - *this\_parent( )\fs*2 ) - *this\align\indent\top
        EndIf
        
        If ( *this\_parent( )\align\auto\left Or
             *this\_parent( )\align\auto\top Or
             *this\_parent( )\align\auto\right Or
             *this\_parent( )\align\auto\bottom )
          
          ;         Protected parent_width = ( *this\_parent( )\align\indent\right - *this\_parent( )\align\indent\left - *this\_parent( )\fs*2 )
          ;         Protected parent_height = ( *this\_parent( )\align\indent\bottom - *this\_parent( )\align\indent\top - *this\_parent( )\fs*2 )
          
          ; loop enumerate widgets
          If StartEnumerate( *this\_parent( ) ) 
            If enumWidget( )\align 
              If enumWidget( )\align\anchor\left And enumWidget( )\align\anchor\right And 
                 enumWidget( )\align\anchor\top And enumWidget( )\align\anchor\bottom 
                
                enumWidget( )\align\indent\top = enumWidget( )\_parent( )\align\auto\top
                enumWidget( )\align\indent\bottom = parent_height - enumWidget( )\_parent( )\align\auto\bottom
                enumWidget( )\align\indent\left = enumWidget( )\_parent( )\align\auto\left
                enumWidget( )\align\indent\right = parent_width - enumWidget( )\_parent( )\align\auto\right
                
                Debug enumWidget( )\class +""+ enumWidget( )\_parent( )\align\auto\left +" "+ enumWidget( )\_parent( )\align\auto\right
              EndIf
              
              If flag & #__align_full = #__align_full
                If ( enumWidget( )\align\anchor\left = 0 Or enumWidget( )\align\anchor\right = 0 ) And 
                   ( enumWidget( )\align\anchor\top = 1 And enumWidget( )\align\anchor\bottom = 1 )
                  enumWidget( )\align\indent\top = enumWidget( )\_parent( )\align\auto\top
                  enumWidget( )\align\indent\bottom = parent_height - enumWidget( )\_parent( )\align\auto\bottom
                EndIf
                ;           
                ;           ;                         If ( enumWidget( )\align\anchor\top = 0 Or enumWidget( )\align\anchor\bottom = 0 ) And 
                ;           ;                            ( enumWidget( )\align\anchor\left = 1 And enumWidget( )\align\anchor\right = 1 )
                ;           ;                           Debug enumWidget( )\text\string
                ;           ;                           enumWidget( )\align\indent\left = enumWidget( )\_parent( )\align\auto\left
                ;           ;                           enumWidget( )\align\indent\right = parent_width - enumWidget( )\_parent( )\align\auto\right
                ;           ;                         EndIf
              EndIf
            EndIf
            StopEnumerate( )
          EndIf
        EndIf
        
        ; update parent childrens coordinate
        Resize( *this\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        PostCanvasRepaint( *this\_root( ) )
      EndIf
      
    EndProcedure
    
    
    Procedure.i SetAttachment( *this._S_widget, *parent._S_widget, mode.a )
      If *parent 
        *this\attach.allocate( ATTACH )
        If *this\attach
          *this\attach\mode = mode
          
          ; get attach-element first-parent
          *this\attach\_parent( ) = *parent
          While *this\attach\_parent( )\attach
            *this\attach\_parent( ) = *this\attach\_parent( )\_parent( )
          Wend
          If *this\attach\_parent( )\_parent( )
            *this\attach\_parent( ) = *this\attach\_parent( )\_parent( )
          Else
            *this\attach\_parent( ) = *parent
          EndIf
          
          ; AddWidget( *this, *parent )
          SetParent( *this, *parent, #PB_Default )
          ProcedureReturn *this\attach
        EndIf
      EndIf
    EndProcedure
    
    Procedure   MoveBounds( *this._S_widget, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
      ; If the value is set to #PB_Ignore, the current value is not changed. 
      ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
      Protected.l x = #PB_Ignore, y = #PB_Ignore, width = #PB_Ignore, height = #PB_Ignore
      
      *this\bounds\move.allocate(BOUNDMove)
      
      *this\bounds\move\min\x = MinimumX
      *this\bounds\move\max\x = MaximumX
      
      *this\bounds\move\min\y = MinimumY
      *this\bounds\move\max\y = MaximumY
      
      ;
      If *this\bounds\move\min\x <> #PB_Ignore And
         *this\bounds\move\min\x > *this\x[#__c_frame]  
        x = *this\bounds\move\min\x
        If *this\width[#__c_frame] > *this\bounds\move\max\x - *this\bounds\move\min\x
          width = *this\bounds\move\max\x - *this\bounds\move\min\x
        EndIf
      ElseIf *this\bounds\move\max\x <> #PB_Ignore And 
             *this\width[#__c_frame] > ( *this\bounds\move\max\x - *this\x[#__c_frame] )
        width = *this\bounds\move\max\x - *this\x[#__c_frame]
      EndIf
      If *this\bounds\move\min\y <> #PB_Ignore And 
         *this\bounds\move\min\y > *this\y[#__c_frame] 
        y = *this\bounds\move\min\y
        If *this\height[#__c_frame] > *this\bounds\move\max\y - *this\bounds\move\min\y
          height = *this\bounds\move\max\y - *this\bounds\move\min\y
        EndIf
      ElseIf *this\bounds\move\max\y <> #PB_Ignore And
             *this\height[#__c_frame] > ( *this\bounds\move\max\y - *this\y[#__c_frame] )
        height = *this\bounds\move\max\y - *this\y[#__c_frame]
      EndIf
      
      ProcedureReturn Resize( *this, x, y, width, height )
    EndProcedure
    
    Procedure   SizeBounds( *this._S_widget, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
      ; If the value is set to #PB_Ignore, the current value is not changed. 
      ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
      Protected.l x = #PB_Ignore, y = #PB_Ignore, width = #PB_Ignore, height = #PB_Ignore
      
      *this\bounds\size.allocate(BOUNDSize)
      
      *this\bounds\size\min\width = MinimumWidth
      *this\bounds\size\max\width = MaximumWidth
      
      *this\bounds\size\min\height = MinimumHeight
      *this\bounds\size\max\height = MaximumHeight
      
      ;
      If *this\bounds\size\min\width <> #PB_Ignore And
         *this\bounds\size\min\width > *this\width[#__c_frame]
        width = *this\bounds\size\min\width
      ElseIf *this\bounds\size\max\width <> #PB_Ignore And
             *this\bounds\size\max\width < *this\width[#__c_frame]
        width = *this\bounds\size\max\width
      EndIf
      If *this\bounds\size\min\height <> #PB_Ignore And 
         *this\bounds\size\min\height > *this\height[#__c_frame] 
        height = *this\bounds\size\min\height
      ElseIf *this\bounds\size\max\height <> #PB_Ignore And 
             *this\bounds\size\max\height < *this\height[#__c_frame]
        height = *this\bounds\size\max\height
      EndIf
      
      ProcedureReturn Resize( *this, x, y, width, height )
    EndProcedure
    
    
    ;- 
    Procedure.i GetItemData( *this._S_widget, item.l )
      Protected result.i
      
      With *This
        Select \type
          Case #__type_Tree,
               #__type_ListView
            
            ;             PushListPosition( *this\_rows( )) 
            ;             ForEach *this\_rows( )
            ;               If *this\_rows( )\index = Item 
            ;                 result = *this\_rows( )\data
            ;                 ; Debug *this\_rows( )\text\string
            ;                 Break
            ;               EndIf
            ;             Next
            ;             PopListPosition( *this\_rows( ))
            ; 
            If is_no_select_item_( *this\_rows( ), item )
              ProcedureReturn #False
            EndIf
            
            result = *this\_rows( )\data
        EndSelect
      EndWith
      
      ;     If result
      ;       Protected *w.widget_S = result
      ;       
      ;       Debug "GetItemData " + Item  + " " +  result  + " " +   *w\class
      ;     EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s GetItemText( *this._S_widget, Item.l, Column.l = 0 )
      Protected result.s
      
      If *this\type = #__type_Panel
        ProcedureReturn bar_tab_GetItemText( *this\TabWidget( ), Item, Column )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn bar_tab_GetItemText( *this, Item, Column )
      EndIf
      
      If *this\count\items ; row\count
        If is_no_select_item_( *this\_rows( ), Item ) 
          ProcedureReturn ""
        EndIf
        
        If *this\type = #__type_property And Column 
          result = *this\_rows( )\text\edit\string
        Else
          result = *this\_rows( )\text\string
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemImage( *this._S_widget, Item.l ) 
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_ListView Or
         *this\type = #__type_Tree
        
        If is_no_select_item_( *this\_rows( ), Item ) 
          ProcedureReturn #PB_Default
        EndIf
        
        result = *this\_rows( )\image\img
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont( *this._S_widget, Item.l )
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_ListView Or
         *this\type = #__type_Tree
        
        If is_no_select_item_( *this\_rows( ), Item ) 
          ProcedureReturn #False
        EndIf
        
        result = *this\_rows( )\text\fontID
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemState( *this._S_widget, Item.l )
      Protected result
      
      ; 
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( *this\_tabs( ), Item ) 
          ProcedureReturn #False
        EndIf
        
        ProcedureReturn *this\_tabs( )\state\flag
      EndIf
      
      If *this\type = #__type_Editor
        If item =- 1
          ProcedureReturn *this\edit_caret_2( )
        Else
          ProcedureReturn *this\edit_caret_1( )
        EndIf
        
      ElseIf *this\type = #__type_Tree
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item ) 
          If *this\_rows( )\color\state
            result | #__tree_selected
          EndIf
          
          If *this\_rows( )\checkbox\___state 
            If *this\mode\threestate And 
               *this\_rows( )\checkbox\___state= #PB_Checkbox_Inbetween
              result | #__tree_Inbetween
            Else
              result | #__tree_checked
            EndIf
          EndIf
          
          If *this\_rows( )\count\childrens And
             *this\_rows( )\collapsebox\___state= 0
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
    
    Procedure.l GetItemColor( *this._S_widget, Item.l, ColorType.l, Column.l = 0 )
      Protected result, *color._S_color
      
      If *this\type = #__type_Editor
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
          *color = *this\_rows( )\color
        EndIf
      ElseIf *this\type = #__type_Tree 
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
          *color = *this\_rows( )\color
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
    
    Procedure.i GetItemAttribute( *this._S_widget, Item.l, Attribute.l, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_Tree
        If is_no_select_item_( *this\_rows( ), Item )
          ProcedureReturn #False
        EndIf
        
        Select Attribute
          Case #__tree_sublevel
            result = *this\_rows( )\sublevel
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i SetItemData( *This._S_widget, item.l, *data )
      If *this\count\items 
        If is_no_select_item_( *this\_rows( ), item )
          ProcedureReturn #False
        EndIf
        
        *this\_rows( )\data = *Data
      EndIf
    EndProcedure
    
    Procedure.l SetItemText( *this._S_widget, Item.l, Text.s, Column.l = 0 )
      Protected result
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( *this\_tabs( ), item )
          ProcedureReturn #False
        EndIf
        
        *this\ChangeTabIndex( ) = #True
        *this\_tabs( )\text\string = Text.s
        PostCanvasRepaint( *this\_root( ) )
      EndIf
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_property
        
        ;Item = *this\row\i( Hex( Item ))
        
        If is_no_select_item_( *this\_rows( ), item )
          ProcedureReturn #False
        EndIf
        
        Protected row_count = CountString( Text.s, #LF$ )
        
        If Not row_count
          *this\_rows( )\text\string = Text.s
        Else
          *this\_rows( )\text\string = StringField( Text.s, 1, #LF$ )
          *this\_rows( )\text\edit\string = StringField( Text.s, 2, #LF$ )
        EndIf
        
        *this\_rows( )\text\change = 1
        *this\change = 1
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText( *this\TabWidget( ), Item, Text, Column )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) 
        If is_item_( *this, Item ) And
           SelectElement( *this\_tabs( ), Item ) And 
           *this\_tabs( )\text\string <> Text 
          *this\_tabs( )\text\string = Text 
          *this\_tabs( )\text\change = 1
          *this\change = 1
          result = #True
        EndIf
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemImage( *this._S_widget, Item.l, Image.i ) 
      Protected result
      
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView
        
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
          If *this\_rows( )\image\img <> Image
            set_image_( *this, *this\_rows( )\Image, Image )
            *this\change = 1
            ;;PostCanvasRepaint( *this\_root( ) )
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont( *this._S_widget, Item.l, Font.i )
      Protected result, FontID.i = FontID( Font )
      
      If *this\type = #__type_Editor Or 
         *this\type = #__type_property Or 
         *this\type = #__type_ListView Or 
         *this\type = #__type_Tree
        
        If is_item_( *this, item ) And 
           SelectElement( *this\_rows( ), Item ) And 
           *this\_rows( )\text\fontID <> FontID
          *this\_rows( )\text\fontID = FontID
          ;       *this\_rows( )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      ElseIf *this\type = #__type_Panel Or
             *this\type = #__type_tabbar
        
        Protected *TabBar._S_widget
        If *this\type = #__type_Panel 
          *TabBar = *this\TabWidget( )
        EndIf
        If *this\type = #__type_tabbar
          *TabBar = *this
        EndIf
        
        If is_item_( *TabBar, item ) And 
           SelectElement( *TabBar\_tabs( ), Item ) And 
           *TabBar\_tabs( )\text\fontID <> FontID
          *TabBar\_tabs( )\text\fontID = FontID
          ;       *this\_rows( )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState( *this._S_widget, Item.l, State.b )
      Protected result
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( *this\_tabs( ), Item )
          ProcedureReturn #False
        EndIf
        
        If State & #__tree_selected = #__tree_selected
          ;           If *this\FocusedRow( ) <> *this\_tabs( )
          ;             *this\FocusedRow( ) = *this\_tabs( )
          ;             *this\FocusedRow( )\state\focus = #true
          ;             *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          ;           EndIf
          bar_tab_SetState( *this, Item )
        EndIf
        
        If State & #__tree_inbetween = #__tree_inbetween
          *this\_tabs( )\checkbox\___state= #PB_Checkbox_Inbetween
        ElseIf State & #__tree_checked = #__tree_checked
          *this\_tabs( )\checkbox\___state= #PB_Checkbox_Checked
        EndIf
        
        PostCanvasRepaint( *this\_root( ) )
      EndIf  
      
      ; - widget::windowset_item_state( )
      If *this\type = #__type_window
        ; result = Window_SetState( *this, state )
        
        ; - widget::editorset_item_state( )
      ElseIf *this\type = #__type_Editor
        result = edit_SetItemState( *this, Item, state )
        
        ;- widget::treeset_item_state( )
      ElseIf *this\type = #__type_Tree
        If *this\count\items
          If is_no_select_item_( *this\_rows( ), Item )
            ProcedureReturn #False
          EndIf
          
          Protected *this_current_row._S_rows = *this\_rows( )
          
          If State & #__tree_selected = #__tree_selected
            If *this\FocusedRow( ) <> *this\_rows( )
              *this\FocusedRow( ) = *this\_rows( )
              *this\FocusedRow( )\state\focus =- 1
              *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
          EndIf
          
          If State & #__tree_inbetween = #__tree_inbetween
            *this\_rows( )\checkbox\___state = #PB_Checkbox_Inbetween
          ElseIf State & #__tree_checked = #__tree_checked
            *this\_rows( )\checkbox\___state = #PB_Checkbox_Checked
          EndIf
          
          If *this\_rows( )\count\childrens
            If State & #__tree_expanded = #__tree_expanded Or 
               State & #__tree_collapsed = #__tree_collapsed
              
              *this\change = #True
              *this\_rows( )\collapsebox\___state= Bool( State & #__tree_collapsed )
              
              PushListPosition( *this\_rows( ))
              While NextElement( *this\_rows( ))
                If *this\_rows( )\parent\row 
                  *this\_rows( )\hide = Bool( *this\_rows( )\parent\row\collapsebox\___state| *this\_rows( )\parent\row\hide )
                EndIf
                
                If *this\_rows( )\sublevel = *this_current_row\sublevel 
                  PostCanvasRepaint( *this\_root( ) )
                  Break
                EndIf
              Wend
              PopListPosition( *this\_rows( ))
            EndIf
          EndIf
          
          result = *this_current_row\collapsebox\___state 
        EndIf
        
        ; - widget::panelset_item_state( )
      ElseIf *this\type = #__type_Panel
        ; result = Panel_SetItemState( *this, state )
        
      Else
        ; result = bar_SetState( *this\bar, state )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetItemColor( *this._S_widget, Item.l, ColorType.l, Color.l, Column.l = 0 )
      Protected result, alpha.a
      
      ; 
      If ListSize( *this\_rows( ) ) ;*this\type = #__type_Tree Or *this\type = #__type_Editor
        If Item = #PB_All
          PushListPosition( *this\_rows( )) 
          ForEach *this\_rows( )
            set_color_( result, *this\_rows( )\color, ColorType, Color, alpha, [Column] )
          Next
          PopListPosition( *this\_rows( )) 
          
        Else
          If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
            set_color_( result, *this\_rows( )\color, ColorType, Color, alpha, [Column] )
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemAttribute( *this._S_widget, Item.l, Attribute.l, *value, Column.l = 0 )
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
    Procedure.i Create( *parent._S_widget, class.s, type.l, x.l,y.l,width.l,height.l, Text.s = #Null$, flag.i = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 7, ScrollStep.f = 1.0 )
      Protected color, image
      Protected ScrollBars;, *this.allocate( Widget )
      
      Protected *this._S_widget
      If Flag & #__flag_autosize = #__flag_autosize And
         Not ListSize(EnumWidget())
        *this = Root( )
        ;*this\_parent( ) = Root( )
        x = 0
        y = 0
        width = Root( )\width
        height = Root( )\height
        *this\autosize = 1
        *parent = #Null
      Else
        *this.allocate( Widget )
      EndIf
      
      If Root( )\canvas\ResizeBeginWidget
        ; Debug "   end - resize " + #PB_Compiler_Procedure
        Post( Root( )\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
        Root( )\canvas\ResizeBeginWidget = #Null
      EndIf
      
      *this\type = type
      *this\flag = Flag
      *this\child = Bool( Flag & #__flag_child = #__flag_child )
      
      If *parent
        If *this\child
          *this\_parent( ) = *parent
          *this\_root( ) = *parent\_root( )
          *this\_window( ) = *parent\_window( )
          ; 
          *this\index = *parent\index 
          *this\address = *parent\address
          ; Debug  "Create(child) "+ *this\type;+" "+*this\scroll\increment
          
        Else
          
          ; AddWidget( *this, *parent )
          SetParent( *this, *parent, #PB_Default )
        EndIf
      EndIf
      
      With *this
        *this\state\create = #True
        *this\state\repaint = #True
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        *this\round = round
        *this\class = class
        
        EnteredRowindex( *this ) =- 1
        PressedRowindex( *this ) =- 1
        
        ; *this\address = *this
        ; *this\class = #PB_compiler_Procedure
        *this\color = _get_colors_( )
        
        ; - Create Texts
        If *this\type = #__type_Text Or
           *this\type = #__type_Editor Or
           *this\type = #__type_String Or
           *this\type = #__type_Button Or
           *this\type = #__type_Option Or
           *this\type = #__type_CheckBox Or
           *this\type = #__type_HyperLink
          
          *this\edit_linePos( ) =- 1
          
          ; - Create Text
          If *this\type = #__type_Text
            *this\row.allocate( ROW )
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            
            set_text_flag_( *this, flag )
            
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
          EndIf
          
          ; - Create Text
          If *this\type = #__type_Editor
            *this\row.allocate( ROW )
            
            *this\flag = Flag | #__text_left | #__text_top
            *this\color = _get_colors_( )
            *this\color\back = $FFF9F9F9
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            
            ; *this\color\back =- 1 
            
            EnteredRowindex( *this ) =- 1
            PressedRowindex( *this ) = EnteredRowindex( *this )
            
            ; PB 
            *this\fs = constants::_check_( Flag, #__flag_borderLess, #False ) * #__border_scroll
            *this\bs = *this\fs
            
            *this\text\padding\y = Bool( #PB_Compiler_OS = #PB_OS_Windows ) ;; 6
            *this\text\padding\x = 3                                        ; - Bool( #PB_Compiler_OS = #PB_OS_Windows ) * 2 - Bool( #PB_Compiler_OS = #PB_OS_Linux ) * 3 ;; 6
            
            *this\mode\check = #__m_multiselect ; multiselect
            *this\mode\fullselection = constants::_check_( Flag, #__flag_fullselection, #False )*7
            *this\mode\alwaysselection = constants::_check_( Flag, #__flag_alwaysselection )
            *this\mode\gridlines = constants::_check_( Flag, #__flag_gridlines ) * 10
            
            *this\row\margin\hide = constants::_check_( Flag, #__text_numeric, #False )
            *this\row\margin\color\front = $C8000000 ; \color\back[0] 
            *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
            
            set_text_flag_( *this, flag )
            If Not *this\text\multiLine
              *this\text\multiLine = 1
            EndIf
            *this\change = 1
            If flag & #__flag_noscrollbars = #False
              bar_area_( *this, 1, 0,0,0,0, Bool(( \mode\buttons = 0 And \mode\lines = 0 ) = 0 ))
            EndIf
          EndIf
          
          ; - Create Text
          If *this\type = #__type_String
            *this\row.allocate( ROW )
            
            *this\text\multiline = constants::_check_( Flag, #__string_multiline )
            
            *this\color = _get_colors_( )
            *this\color\fore =- 1
            *this\color\back = $FFF9F9F9
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            If Flag & #__flag_borderless = #False
              *this\fs = #__border_scroll
              *this\bs = *this\fs
            EndIf
            
            If *this\text\multiline
              *this\row\margin\hide = 0;Bool( Not Flag&#__string_numeric )
              *this\row\margin\color\front = $C8000000 ; \color\back[0] 
              *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
            Else
              *this\row\margin\hide = 1
              *this\text\numeric = Bool( Flag & #__string_numeric )
            EndIf
            
            set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ))
            
            ; PB 
            *this\text\padding\x = 3
            *this\text\padding\y = 0
            *this\text\caret\x = *this\text\padding\x
            ;Text = RemoveString( Text, #LF$ ) ; +  #LF$
            If flag & #__flag_noscrollbars = #False
              bar_area_( *this, 1, 0,0,0,0, Bool(( \mode\buttons = 0 And \mode\lines = 0 ) = 0 ))
            EndIf
          EndIf
          
          ; - Create Button
          If *this\type = #__type_Button
            *this\row.allocate( ROW )
            Image = *param_1
            *this\color = _get_colors_( )
            *this\__state = #__ss_front | #__ss_back | #__ss_frame
            
            ; PB 
            *this\fs = 1
            *this\bs = *this\fs
            *this\flag = Flag | #__text_center
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            
            
            set_text_flag_( *this, *this\flag )
            
            set_image_( *this, *this\Image, Image )
            
            set_align_( *this\image, 
                        constants::_check_( *this\flag, #__image_left ),
                        constants::_check_( *this\flag, #__image_top ),
                        constants::_check_( *this\flag, #__image_right ),
                        constants::_check_( *this\flag, #__image_bottom ),
                        constants::_check_( *this\flag, #__image_center ))
            
            *this\text\padding\x = 4
            *this\text\padding\y = 4
            
          EndIf
          
          If *this\type = #__type_Option
            *this\row.allocate( ROW )
            
            *this\fs = 0 : *this\bs = *this\fs
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            
            
            If Root( )\count\childrens
              If Root( )\_widgets( )\type = #__type_Option
                *this\_group = Root( )\_widgets( )\_group 
              Else
                *this\_group = Root( )\_widgets( ) 
              EndIf
            Else
              *this\_group = OpenedWidget( )
            EndIf
            
            set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ))
            
            ;       *this\color\back =- 1; _get_colors_( ); - 1
            ;       *this\color\fore =- 1
            
            ; *this\__state = #__ss_front
            *this\color\fore =- 1
            *this\color\back = _get_colors_( )\fore
            *this\color\front = _get_colors_( )\front
            
            *this\_box_.allocate( BUTTONS )
            *this\_box_\color = _get_colors_( )
            *this\_box_\color\back = $ffffffff
            
            *this\_box_\round = 7
            *this\_box_\width = 15
            *this\_box_\height = *this\_box_\width
            *this\text\padding\x = *this\_box_\width + 8
            
            *this\text\multiline =- CountString( Text, #LF$ )
          EndIf
          
          If *this\type = #__type_CheckBox
            *this\row.allocate( ROW )
            
            *this\fs = 0 : *this\bs = *this\fs
            
            If Flag & #__flag_vertical = #__flag_vertical
              *this\vertical = #True
            EndIf
            
            
            set_text_flag_( *this, flag | #__text_center | ( Bool( Not flag & #__text_center ) * #__text_left ))
            
            *this\mode\threestate = constants::_check_( Flag, #PB_CheckBox_ThreeState )
            *this\text\multiline =- CountString( Text, #LF$ )
            
            ; *this\__state = #__ss_front
            *this\color\fore =- 1
            *this\color\back = _get_colors_( )\fore
            *this\color\front = _get_colors_( )\front
            
            *this\_box_.allocate( BUTTONS )
            *this\_box_\color = _get_colors_( )
            *this\_box_\color\back = $ffffffff
            
            *this\_box_\round = 2
            *this\_box_\height = 15
            *this\_box_\width = *this\_box_\height
            *this\text\padding\x = *this\_box_\width + 8
          EndIf
          
          If *this\type = #__type_HyperLink
            *this\row.allocate( ROW )
            Color = *param_1
            
            *this\fs = 0 : *this\bs = *this\fs
            
            set_text_flag_( *this, flag | #__text_center );, 3 )
            
            *this\mode\lines = constants::_check_( Flag, #PB_HyperLink_Underline )
            *this\text\multiline =- CountString( Text, #LF$ )
            
            *this\__state = #__ss_front
            *this\color\fore[#__S_0] =- 1
            *this\color\back[#__S_0] = _get_colors_( )\fore
            *this\color\front[#__S_0] = _get_colors_( )\front
            
            If Not Alpha( Color )
              Color = Color & $FFFFFF | 255<<24
            EndIf
            *this\color\front[#__S_1] = Color
          EndIf
        EndIf
        
        ; - Create Lists
        If *this\type = #__type_Tree Or
           *this\type = #__type_ListView Or
           *this\type = #__type_ListIcon Or
           *this\type = #__type_ExplorerList Or
           *this\type = #__type_Property
          
          *this\row.allocate( ROW )
          *this\vertical = Bool( Flag&#__flag_vertical ) 
          
          ;           If *this\type = #__type_Tree 
          ;             *this\class = "Tree"
          ;           EndIf
          ;           If *this\type = #__type_ListView 
          ;             *this\class = "ListView"
          ;           EndIf
          ;           If *this\type = #__type_ListIcon 
          ;             *this\class = "ListIcon"
          ;           EndIf
          ;           If *this\type = #__type_ExplorerList
          ;             *this\class = "ExplorerList"
          ;           EndIf
          ;           If *this\type = #__type_Property
          ;             *this\class = "Property"
          ;           EndIf
          
          
          If type = #__type_Property
            If *this\bar
              *this\bar\page\pos = 60
            EndIf
          EndIf
          
          ;*this\state\flag = #__ss_front
          *this\color\_alpha = 255
          *this\color\fore[#__S_0] =- 1
          *this\color\back[#__S_0] = $ffffffff ; _get_colors_( )\fore
          *this\color\front[#__S_0] = _get_colors_( )\front
          *this\color\frame[#__S_0] = _get_colors_( )\frame
          
          ;Row( *this )\index =- 1
          *this\change = 1
          
          *this\interact = 1
          ;*this\round = round
          
          *this\text\change = 1 
          *this\text\height = 18 
          
          *this\image\padding\x = 2
          *this\text\padding\x = 4
          
          ;*this\vertical = Bool( Flag&#__flag_vertical )
          *this\fs = Bool( Not Flag&#__flag_borderLess ) * #__border_scroll
          *this\bs = *this\fs
          
          If Flag&#__tree_multiselect = #__tree_multiselect
            *this\mode\check = #__m_multiselect
          EndIf
          
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
          
          If flag & #__flag_noscrollbars = #False
            bar_area_( *this, 1, 0,0,0,0, Bool(( \mode\buttons = 0 And \mode\lines = 0 ) = 0 ))
          EndIf
          ScrollBars = 0
          ; Resize( *this, x,y,width,height )
        EndIf
        
        ; - Create Containers
        If *this\type = #__type_Container Or
           *this\type = #__type_ScrollArea Or
           *this\type = #__type_Panel Or
           *this\type = #__type_MDI
          
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
              *this\barHeight = #__panel_height
            Else
              *this\barWidth = #__panel_width
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
            set_image_( *this, *this\Image, *param_3 )
          EndIf
          
          set_align_( *this\image, 
                      constants::_check_( Flag, #__image_left ),
                      constants::_check_( Flag, #__image_top ),
                      constants::_check_( Flag, #__image_right ),
                      constants::_check_( Flag, #__image_bottom ),
                      constants::_check_( Flag, #__image_center ))
          
          *param_1 = *this\image\width 
          *param_2 = *this\image\height 
          
          *this\color\back = $FFF9F9F9
          
          ;*this\fs = Bool( Not Flag&#__flag_borderLess ) * 2; * #__border_scroll
        EndIf
        
        ; - Create Bars
        If *this\type = #__type_ScrollBar Or 
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_TrackBar Or
           ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
           *this\type = #__type_Spin Or
           *this\type = #__type_Splitter
          
          *this\bar.allocate( BAR )
          *this\bar\button.allocate( BUTTONS, [#__b_1] )
          *this\bar\button.allocate( BUTTONS, [#__b_2] )
          *this\bar\button.allocate( BUTTONS, [#__b_3] )
          *this\bar\widget = *this ; 
          
          *this\scroll\increment = ScrollStep
          
          If *this\type <> #__type_Splitter
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
          
          ; - Create Scroll
          If *this\type = #__type_ScrollBar
            *this\color\back = $FFF9F9F9 ; - 1 
            *this\color\front = $FFFFFFFF
            
            *this\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                   Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical )
            
            If *this\vertical
              *this\class = class+"-v"
            Else
              *this\class = class+"-h"
            EndIf
            
            BB1( )\color = _get_colors_( )
            BB2( )\color = _get_colors_( )
            BB3( )\color = _get_colors_( )
            
            If Not Flag & #__flag_nobuttons = #__flag_nobuttons
              BB1( )\size =- 1
              BB2( )\size =- 1
            EndIf
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            BB3( )\size = size
            
            BB1( )\interact = #True
            BB2( )\interact = #True
            BB3( )\interact = #True
            
            BB1( )\round = *this\round
            BB2( )\round = *this\round
            BB3( )\round = *this\round
            
            BB1( )\arrow\type = #__arrow_type ; -1 0 1
            BB2( )\arrow\type = #__arrow_type ; -1 0 1
            
            BB1( )\arrow\size = #__arrow_size
            BB2( )\arrow\size = #__arrow_size
            BB3( )\arrow\size = 3
          EndIf
          
          ; - Create Spin
          If *this\type = #__type_Spin
            *this\color\back =- 1 
            *this\color = _get_colors_( )
            *this\color\_alpha = 255
            *this\color\back = $FFFFFFFF
            
            BB1( )\color = _get_colors_( )
            BB2( )\color = _get_colors_( )
            ;BB3( )\color = _get_colors_( )
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If *this\flag & #__spin_Plus
              flag | #__text_center
              *this\flag | #__text_center
              If ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical ) 
                *this\vertical = #True
              EndIf
            Else
              If Not ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
                *this\vertical = #True
                *this\bar\invert = #True
              EndIf
            EndIf
            
            *this\fs = Bool( Not Flag&#__flag_borderless );*2
            *this\bs = *this\fs
            
            If Not *this\flag & #__spin_Plus
              BB1( )\arrow\size = #__arrow_size
              BB2( )\arrow\size = #__arrow_size
              
              BB1( )\arrow\type = #__arrow_type ; -1 0 1
              BB2( )\arrow\type = #__arrow_type ; -1 0 1
            EndIf
            
            bar_SetAttribute( *this, #__bar_buttonsize, Size )
            
            ; *this\text.allocate( TEXT )
            Protected i_c
            For i_c = 0 To 3
              If *this\scroll\increment = ValF(StrF(*this\scroll\increment, i_c))
                *this\text\string = StrF(*this\bar\page\pos, i_c)
                *this\text\change = 1
                Break
              EndIf
            Next
            
            *this\text\change = 1
            *this\text\editable = 1
            ;*this\text\align\anchor\top = 1
            
            *this\text\padding\x = #__spin_padding_text
            *this\text\padding\y = #__spin_padding_text
            
            BB1( )\interact = #True
            BB2( )\interact = #True
            ;BB3( )\interact = #True
            
            
            set_text_flag_( *this, flag )
            
            
          EndIf
          
          ; - Create Tab
          If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
            ;;*this\text\change = 1
            *this\color\back =- 1 
            BB1( )\color = _get_colors_( )
            BB2( )\color = _get_colors_( )
            ;BB3( )\color = _get_colors_( )
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #False )
            *this\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical )
            
            If Not Flag & #__bar_buttonsize = #__bar_buttonsize
              BB3( )\size = size
              BB1( )\size = 15
              BB2( )\size = 15
            EndIf
            
            If *this\child
              *this\fs = *parent\fs
            Else
              *this\fs = #__border_scroll
            EndIf
            
            BB1( )\interact = #True
            BB2( )\interact = #True
            BB3( )\interact = #True
            
            BB1( )\round = 7
            BB2( )\round = 7
            BB3( )\round = *this\round
            
            BB1( )\arrow\type = -1 ; -1 0 1
            BB2( )\arrow\type = -1 ; -1 0 1
            
            BB1( )\arrow\size = #__arrow_size
            BB2( )\arrow\size = #__arrow_size
            ;BB3( )\arrow\size = 3
            
            set_text_flag_( *this, flag )
          EndIf
          
          ; - Create Track
          If *this\type = #__type_TrackBar
            *this\color\back =- 1 
            BB1( )\color = _get_colors_( )
            BB2( )\color = _get_colors_( )
            BB3( )\color = _get_colors_( )
            
            *this\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                   Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical )
            
            If *this\vertical
              *this\bar\invert = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            ;             If flag & #PB_Trackbar_Ticks = #PB_Trackbar_Ticks
            ;               *this\bar\widget\flag | #PB_Trackbar_Ticks
            ;             EndIf
            
            BB1( )\interact = #True
            BB2( )\interact = #True
            BB3( )\interact = #True
            
            BB3( )\arrow\size = #__arrow_size
            BB3( )\arrow\type = #__arrow_type
            
            BB1( )\round = 2
            BB2( )\round = 2
            BB3( )\round = *this\round
            
            If *this\round < 7
              BB3( )\size = 9
            Else
              BB3( )\size = 15
            EndIf
            
            set_text_flag_( *this, flag )
            
            ; button draw color
            BB3( )\state\focus = 1
            BB3( )\color\state = #__S_2
            If Not *this\flag & #PB_TrackBar_Ticks
              If *this\bar\invert
                BB2( )\state\focus = 1
                BB2( )\color\state = #__S_2
              Else
                BB1( )\state\focus = 1
                BB1( )\color\state = #__S_2
              EndIf
            EndIf
          EndIf
          
          ; - Create Progress
          If *this\type = #__type_ProgressBar
            *this\color\back =- 1 
            BB1( )\color = _get_colors_( )
            BB2( )\color = _get_colors_( )
            ;BB3( )\color = _get_colors_( )
            
            
            *this\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                   Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical )
            
            If *this\vertical
              *this\bar\invert = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            BB1( )\round = *this\round
            BB2( )\round = *this\round
            
            *this\text\change = #True
            set_text_flag_( *this, flag | #__text_center )
          EndIf
          
          ; - Create Splitter
          If *this\type = #__type_Splitter
            *this\color\back =- 1
            
            If *param_1 >= 0 
              bar_first_gadget_( *this ) = *param_1
            EndIf
            If *param_2 >= 0
              bar_second_gadget_( *this ) = *param_2
            EndIf
            bar_is_first_gadget_( *this ) = Bool( PB(IsGadget)( *param_1 ))
            bar_is_second_gadget_( *this ) = Bool( PB(IsGadget)( *param_2 ))
            
            *this\bar\button[#__b_1]\hide = Bool( bar_is_first_gadget_( *this ) Or bar_first_gadget_( *this ) )
            *this\bar\button[#__b_2]\hide = Bool( bar_is_second_gadget_( *this ) Or bar_second_gadget_( *this ) )
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            *this\vertical = Bool( Flag & #__bar_vertical = #False And Flag & #PB_Splitter_Vertical = #False )
            
            If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
              *this\bar\fixed = #__split_1 
            ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
              *this\bar\fixed = #__split_2 
            EndIf
            ;             
            ;             If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
            ;               *this\bar\widget\flag | #PB_Splitter_Separator
            ;             EndIf
            
            BB3( )\size = #__splitter_buttonsize
            BB3( )\interact = #True
            BB3( )\round = 2
          EndIf
        EndIf
        
        ;
        If *this\child 
          
          If *this\type = #__type_ScrollBar
            If *this\vertical
              *this\width[#__c_frame] = width 
              *this\width[#__c_container] = width
              *this\width[#__c_screen] = width + ( *this\bs*2 - *this\fs*2 ) 
              If *this\width[#__c_container] < 0 
                *this\width[#__c_container] = 0 
              EndIf
              *this\width[#__c_inner] = *this\width[#__c_container]
            Else
              *this\height[#__c_frame] = height 
              *this\height[#__c_container] = height
              *this\height[#__c_screen] = height + ( *this\bs*2 - *this\fs*2 )
              If *this\height[#__c_container] < 0 
                *this\height[#__c_container] = 0 
              EndIf
              *this\height[#__c_inner] = *this\height[#__c_container]
            EndIf
          EndIf
          
        Else  
          ; splitter 
          If *this\type = #__type_Splitter
            If bar_first_gadget_( *this ) And Not bar_is_first_gadget_( *this )
              SetParent( bar_first_gadget_( *this ), *this )
            EndIf
            
            If bar_second_gadget_( *this ) And Not bar_is_second_gadget_( *this )
              SetParent( bar_second_gadget_( *this ), *this )
            EndIf
          EndIf
          
          ;
          If *this\type = #__type_Panel 
            *this\TabWidget( ) = Create( *this, *this\class+"_TabBar", #__type_TabBar, 0,0,0,0, #Null$, Flag | #__flag_child, 0,0,0, 0,0,30 )
          EndIf
          
          ;
          If *this\container And flag & #__flag_nogadgets = #False And *this\type <> #__type_Splitter 
            OpenList( *this )
          EndIf
          
          ;
          If ScrollBars And flag & #__flag_noscrollbars = #False
            bar_area_( *this, ScrollStep, *param_1, *param_2, 0, 0 )
          EndIf
          
          ;
          If *this\type = #__type_MDI
            ; this before Resize( ) 
            ; and after SetParent( )
            ; 
            If Not *this\_a_\transform And
               Bool( flag & #__mdi_editable = #__mdi_editable )
              a_init( *this )
            EndIf
          EndIf
          
          ;
          set_align_flag_( *this, *parent, *this\flag )
          Resize( *this, x,y,width,height )
          If Text.s
            SetText( *this, Text.s )
          EndIf
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            ; ;             scroll_x_( *this ) = *this\x[#__c_inner]
            ; ;             scroll_y_( *this ) = *this\y[#__c_inner] 
            scroll_width_( *this ) = *param_1
            scroll_height_( *this ) = *param_2
          EndIf
          
          PostCanvasRepaint( Root( ), #PB_EventType_Create)
        EndIf
        
        ;         ; Adda_object( )
        ;         DoEvents( *this, #PB_EventType_Create )
        ;         PostCanvasRepaint( *this )
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab( x.l,y.l,width.l,height.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_TabBar, x,y,width,height, #Null$, flag, 0,0,0, 40,round,40 )
    EndProcedure
    
    Procedure.i Spin( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, Increment.f = 1.0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Spin, x,y,width,height, #Null$, flag, min,max,0, #__spin_buttonsize,round,Increment )
    EndProcedure
    
    Procedure.i Scroll( x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ScrollBar, x,y,width,height, #Null$, flag, min,max,pagelength, #__scroll_buttonsize,round,1 )
    EndProcedure
    
    Procedure.i Track( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_TrackBar, x,y,width,height, #Null$, flag, min,max,0, 0,round,1 )
    EndProcedure
    
    Procedure.i Progress( x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ProgressBar, x,y,width,height, #Null$, flag, min,max,0, 0,round,1 )
    EndProcedure
    
    Procedure.i Splitter( x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Splitter, x,y,width,height, #Null$, flag, First,Second,0, 0,0,1 )
    EndProcedure
    
    
    ;- 
    Procedure.i Tree( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Tree, x,y,width,height, "", Flag )
    EndProcedure
    
    Procedure.i ListView( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ListView, x,y,width,height, "", Flag | #__tree_nobuttons | #__list_nolines )
    EndProcedure
    
    Procedure.i ListIcon( x.l,y.l,width.l,height.l, ColumnTitle.s, ColumnWidth.i, flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_tree, x,y,width,height, "", Flag )
      ;  ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ListIcon, x,y,width,height, "", Flag )
    EndProcedure
    
    Procedure.i ExplorerList( x.l,y.l,width.l,height.l, Directory.s, flag.i=0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ExplorerList, x,y,width,height, "", Flag | #__tree_nobuttons | #__list_nolines )
    EndProcedure
    
    Procedure.i Tree_properties( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Property, x,y,width,height, "", Flag )
    EndProcedure
    
    
    ;- 
    Procedure.i Editor( x.l, Y.l, width.l,height.l, Flag.i = 0, round.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Editor, x,y,width,height, "", flag, 0,0,0,0,round,0 )
    EndProcedure
    
    Procedure.i String( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_String, x,y,width,height, Text, flag, 0,0,0,0,round,0 )
    EndProcedure
    
    Procedure.i Text( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Text, x,y,width,height, Text, flag, 0,0,0,0,round,0 )
    EndProcedure
    
    Procedure.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Button, x,y,width,height, Text, flag, Image, 0,0,0, round )
    EndProcedure
    
    Procedure.i Option( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Option, x,y,width,height, Text, flag, 0,0,0,0,0,0 )
    EndProcedure
    
    Procedure.i Checkbox( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_CheckBox, x,y,width,height, Text, flag, 0,0,0,0,0,0 )
    EndProcedure
    
    Procedure.i HyperLink( x.l,y.l,width.l,height.l, Text.s, Color.i, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_HyperLink, x,y,width,height, Text, flag, Color, 0,0,0,0,0 )
    EndProcedure
    
    Procedure.i ButtonImage( x.l,y.l,width.l,height.l, Image.i =-1 , Flag.i = 0, round.l = 0 )
      ProcedureReturn Button( x,y,width,height, "", Flag, Image, round )
    EndProcedure
    
    Procedure.i ComboBox( x.l,y.l,width.l,height.l, Flag.i = 0 )
      Protected *this.allocate( Widget ) 
      Protected *parent._S_widget = OpenedWidget( )
      
      If *this\flag & #PB_ComboBox_Editable
        *this\flag &~ #PB_ComboBox_Editable
      Else
        *this\flag | #__text_readonly
      EndIf
      
      *this\flag = Flag
      *this\type = #__type_ComboBox
      *this\class = #PB_Compiler_Procedure
      
      SetParent( *this, *parent, #PB_Default )
      
      
      
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      
      
      *this\fs = 1 
      *this\bs = *this\fs
      
      *this\row.allocate( ROW )
      
      set_text_flag_( *this, *this\flag | #__text_center | ( Bool( Not *this\flag & #__text_center ) * #__text_left ))
      
      *this\mode\threestate = constants::_check_( *this\Flag, #PB_CheckBox_ThreeState )
      ;;*this\text\multiline =- CountString( Text, #LF$ )
      
      *this\color = _get_colors_( )
      
      *this\_box_.allocate( BUTTONS )
      *this\_box_\color = _get_colors_( )
      ;*this\_box_\color\back = $ffffffff
      ;       
      ;       *this\_box_\round = 2
      ;       *this\_box_\height = 15
      ;       *this\_box_\width = *this\_box_\height
      ;       *this\text\padding\x = *this\_box_\width + 8
      
      If *this\Flag & #__bar_vertical = #False
        *this\barHeight = height
      Else
        *this\barWidth = width
      EndIf
      
      ; *this\ToolBarHeight = 3
      
      ;;;If flag & #__flag_noscrollbars = #False ; bug windows
      bar_area_( *this, 1, 0,0,0,0, Bool(( *this\mode\buttons = 0 And *this\mode\lines = 0 ) = 0 ))
      ;;;EndIf
      Resize( *this, x,y,width,height )
      ;       If Text.s
      ;         SetText( *this, Text.s )
      ;       EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    ;- 
    Procedure.i MDI( x.l,y.l,width.l,height.l, Flag.i = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_MDI, x,y,width,height, #Null$, flag | #__flag_nogadgets, 0,0,0, #__scroll_buttonsize,0,1 )
    EndProcedure
    
    Procedure.i Panel( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Panel, x,y,width,height, #Null$, flag | #__flag_noscrollbars, 0,0,0, #__scroll_buttonsize,0,0 )
    EndProcedure
    
    Procedure.i Container( x.l,y.l,width.l,height.l, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Container, x,y,width,height, #Null$, flag | #__flag_noscrollbars, 0,0,0, #__scroll_buttonsize,0,0 )
    EndProcedure
    
    Procedure.i ScrollArea( x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ScrollArea, x,y,width,height, #Null$, flag, ScrollAreaWidth,ScrollAreaHeight,0, #__scroll_buttonsize,0,ScrollStep )
    EndProcedure
    
    Procedure.i Frame( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0 )
      Protected Size = 16, *this.allocate( Widget ) 
      ;set_last_parameters_( *this, #__type_Frame, Flag, OpenedWidget( ))
      Protected *parent._S_widget = OpenedWidget( )
      
      *this\flag = Flag
      *this\type = #__type_Frame
      *this\class = #PB_Compiler_Procedure
      
      SetParent( *this, *parent, #PB_Default )
      
      With *this
        \x =- 1
        \y =- 1
        \container = #__type_Frame
        \color = _get_colors_( )
        \color\_alpha = 255
        \color\back = $FFF9F9F9
        
        *this\barHeight = 16
        
        \bs = 1
        \fs = 1
        
        ;       ; \text.allocate( TEXT )
        ;       \text\edit\string = Text.s
        ;       \text\string.s = Text.s
        ;       \text\change = 1
        set_text_flag_( *this, flag, 2, - 22 )
        
        *this\text\padding\x = 5
        ;*this\text\align\vertical = Bool( Not *this\text\align\anchor\top And Not *this\text\align\anchor\bottom )
        ;*this\text\align\horizontal = Bool( Not *this\text\align\anchor\left And Not *this\text\align\anchor\right )
        
        
        Resize( *this, x,y,width,height )
        If Text.s
          SetText( *this, Text.s )
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Image( x.l,y.l,width.l,height.l, image.i, Flag.i = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Image, x,y,width,height, #Null$, flag, 0,0,image, #__scroll_buttonsize,0,1 )
    EndProcedure
    
    ;- 
    Procedure ToolBar( *parent._S_widget, flag.i = #PB_ToolBar_Small )
      ProcedureReturn ListView( 0,0,*parent\width[#__c_inner],20, flag )
    EndProcedure
    
    Procedure ToolTip( *this._S_widget, Text.s, item =- 1 )
      
      *this\_tt\text\string = Text 
    EndProcedure
    
    ;- 
    ;- 
    ;-  DRAWINGs
    Procedure.l draw_items_( *this._S_widget, List *rows._S_rows( ), _scroll_x_, _scroll_y_ )
      Protected state.b, x.l, y.l, _box_x_.l, _box_y_.l, minus.l = 7
      
      ;
      ; Clip( *this, [#__c_draw2] ) ; 2
      
      PushListPosition( *rows( ))
      Protected bs = Bool( *this\fs )
      ; Debug ""+*this\x +" "+ *this\x[#__c_inner]
      ; Draw all items
      ForEach *rows( )
        If *rows( )\visible 
          If *rows( )\width <> *this\width[#__c_inner] - bs*2
            *rows( )\width = *this\width[#__c_inner] - bs*2
          EndIf
          
          ;Debug ""+ _scroll_y_ +" "+ scroll_y_( *this )
          X = row_x_( *this, *rows( ) ) - _scroll_x_
          Y = row_y_( *this, *rows( ) ) - _scroll_y_ 
          ; X = row_x_( *this, *rows( ) ) + scroll_x_( *this )
          ; Y = row_y_( *this, *rows( ) ) +  scroll_y_( *this )
          state = *rows( )\color\state  
          
          ; init real drawing font
          draw_font_item_( *this, *rows( ), 0 )
          
          ; Draw selector back
          ;;If Not *this\drop ; *this\drop 
          If *rows( )\count\childrens And *this\flag & #__tree_property
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_( x, y, *this\width[#__c_inner],*rows( )\height,*rows( )\round,*rows( )\round,*rows( )\color\back )
            ;draw_roundbox_( *this\x[#__c_inner] + *this\row\sublevelsize,Y,*this\width[#__c_inner] - *this\row\sublevelsize,*rows( )\height,*rows( )\round,*rows( )\round,*rows( )\color\back[state] )
            Line( x + *this\row\sublevelsize, y + *rows( )\height, *this\width[#__c_inner] - *this\row\sublevelsize, 1, $FFACACAC )
            
          Else
            If *rows( )\color\back[state]
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_roundbox_( x, y, *rows( )\width, *rows( )\height,*rows( )\round,*rows( )\round,*rows( )\color\back[state] )
            EndIf
          EndIf
          ;;EndIf
          ;               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  *this\_dd And
          ;                  
          ;               If mouse( )\buttons And 
          ;                  *rows( )\state\enter And 
          ;                  Not *this\state\press
          ;                 
          ;                 drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;                 If (y + *rows( )\height/2) > mouse( )\y 
          ;                   Line( *rows( )\x, y - *this\mode\gridlines, *rows( )\width, 1, $ff000000 )
          ;                 Else
          ;                   Line( *rows( )\x, y + *rows( )\height, *rows( )\width, 1, $ff000000 )
          ;                 EndIf
          ;               EndIf
          
          ; Draw items image
          If *rows( )\image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *rows( )\image\id, x + *rows( )\image\x, y + *rows( )\image\y, *rows( )\color\_alpha )
          EndIf
          
          ; Draw items text
          If *rows( )\text\string.s
            drawing_mode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( x + *rows( )\text\x, y + *rows( )\text\y, *rows( )\text\string.s, *this\text\rotate, *rows( )\color\front[state] )
          EndIf
          
          ; Draw items data text
          If *rows( )\text\edit\string.s
            drawing_mode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( x + *rows( )\text\edit\x - _scroll_x_, row_y_( *this, *rows( ) ) + *rows( )\text\edit\y - _scroll_y_, *rows( )\text\edit\string.s, *this\text\rotate, *rows( )\color\front[state] )
          EndIf
          
          ; Draw selector frame
          ;;If Not *this\drop 
          If *rows( )\count\childrens And *this\flag & #__tree_property
          Else
            If *rows( )\color\frame[state]
              drawing_mode_( #PB_2DDrawing_Outlined )
              draw_roundbox_( x, y, *rows( )\width, *rows( )\height, *rows( )\round,*rows( )\round, *rows( )\color\frame[state] )
            EndIf
          EndIf
          ;;EndIf
          
          ; Horizontal line
          If *this\mode\GridLines And *rows( )\color\line <> *rows( )\color\back
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_box_( x, y + *rows( )\height + Bool( *this\mode\gridlines>1 ) , *rows( )\width, 1, *this\color\line )
          EndIf
          
          
        EndIf
      Next
      
      
      ;           drawing_mode_alpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
      ;          draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevelsize, *this\height[#__c_inner], *this\_rows( )\parent\row\color\back )
      
      Protected._S_buttons *ibox, *l_ibox
      
      ; Draw plots
      If *this\mode\lines 
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        ; drawing_mode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
        
        ForEach *rows( )
          If *rows( )\visible And Not *rows( )\hide 
            *ibox = *rows()\collapsebox
            *l_ibox = *rows()\last\collapsebox
            X = row_x_( *this, *rows( ) ) + scroll_x_( *this )
            Y = row_y_( *this, *rows( ) ) + scroll_y_( *this )
            
            ; for the tree vertical line
            If *rows( )\last And Not *rows( )\last\hide And *rows( )\last\sublevel
              Line((x + *l_ibox\x + *l_ibox\width / 2), (y + *rows( )\height), 1, (*rows( )\last\y-*rows( )\y)-*rows( )\last\height/2, *rows( )\color\line )
            EndIf
            If *rows( )\parent\row And Not *rows( )\parent\row\visible And *rows( )\parent\row\last = *rows( ) And *rows( )\sublevel
              Line((x + *ibox\x + *ibox\width / 2), (*rows( )\parent\row\y + *rows( )\parent\row\height) - _scroll_y_, 1, (*rows( )\y-*rows( )\parent\row\y)-*rows( )\height/2, *rows( )\parent\row\color\line )
            EndIf
            
            ; for the tree horizontal line
            If Not (*this\mode\buttons And *rows( )\count\childrens)
              Line((x + *ibox\x + *ibox\width / 2), (y + *rows( )\height/2), 7, 1, *rows( )\color\line )
            Else
              If Bool( Not *ibox\___state)
                ;  LineXY((x + *l_ibox\x+2), (y + 9), (x + *l_ibox\x + *l_ibox\width / 2-1), y + *rows( )\height-1, *rows( )\color\line )
                LineXY((x + *l_ibox\x-1), (y + 10), (x + *l_ibox\x + *l_ibox\width / 2-1), y + *rows( )\height-1, *rows( )\color\line )
                ;  LineXY((x + *l_ibox\x-2), (y + 12), (x + *l_ibox\x + *l_ibox\width / 2-1), y + *rows( )\height-1, *rows( )\color\line )
              EndIf
            EndIf
          EndIf    
        Next
        
        ; for the tree item first vertical line
        If *this\row\first And *this\row\last
          Line((*this\x[#__c_inner] + *this\row\first\collapsebox\x + *this\row\first\collapsebox\width/2) - _scroll_x_, (row_y_( *this, *this\row\first ) + *this\row\first\height/2) - _scroll_y_, 1, (*this\row\last\y - *this\row\first\y), *this\row\first\color\line )
        EndIf
      EndIf
      
      ; Draw buttons
      If *this\mode\buttons Or
         ( *this\mode\check = #__m_checkselect Or *this\mode\check = #__m_optionselect )
        
        ; Draw boxs ( check&option )
        ForEach *rows( )
          If *rows( )\visible And *this\mode\check
            X = row_x_( *this, *rows( ) ) + *rows( )\checkbox\x + scroll_x_( *this )
            Y = row_y_( *this, *rows( ) ) + *rows( )\checkbox\y + scroll_y_( *this )
            
            If *rows( )\parent\row And *this\mode\check = #__m_optionselect
              ; option
              draw_button_( 1, x, y, *rows( )\checkbox\width, *rows( )\checkbox\height, *rows( )\checkbox\___state , 4 );, \color )
            Else                                                                                                        ;If Not ( *this\mode\buttons And *rows( )\count\childrens And *this\mode\check = #__m_optionselect )
                                                                                                                        ; check
              draw_button_( 3, x, y, *rows( )\checkbox\width, *rows( )\checkbox\height, *rows( )\checkbox\___state , 2 )
            EndIf
          EndIf    
        Next
        
        ;drawing_mode_alpha_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
        ; Draw buttons ( expanded&collapsed )
        ForEach *rows( )
          If *rows( )\visible And Not *rows( )\hide 
            *ibox = *rows()\collapsebox
            
            X = row_x_( *this, *rows( ) ) + *ibox\x + scroll_x_( *this )
            Y = row_y_( *this, *rows( ) ) + *ibox\y + scroll_y_( *this )
            
            If *this\mode\buttons And *rows( )\count\childrens And
               Not ( *rows( )\sublevel And *this\mode\check = #__m_optionselect )
              
              If #PB_Compiler_OS = #PB_OS_Windows Or 
                 (*rows( )\parent\row And *rows( )\parent\row\last And *rows( )\parent\row\sublevel = *rows( )\parent\row\last\sublevel)
                
                draw_button_( 0, x, y, *ibox\width, *ibox\height, 0,2)
                draw_box( *ibox, color\frame )
                
                Line(x + 2, y + *ibox\height/2, *ibox\width - 4, 1, $ff000000)
                If *ibox\___state 
                  Line(x + *ibox\width/2, y + 2, 1, *ibox\height - 4, $ff000000)
                EndIf
                
              Else
                
                
                If *rows( )\color\state 
                  DrawArrow2(x,y, 3-Bool(*ibox\___state))
                Else
                  DrawArrow2(x,y, 3-Bool(*ibox\___state), $ff000000)
                EndIf
                
              EndIf
              
            EndIf
          EndIf    
        Next
      EndIf
      
      ; 
      PopListPosition( *rows( )) ; 
      
    EndProcedure
    
    Procedure   draw_Container_( *this._S_widget, x,y )
      With *this
        
        ; background draw
        If Not ( *this\image[#__img_background]\id And 
                 ( *this\image[#__img_background]\width > *this\width[#__c_inner] Or 
                   *this\image[#__img_background]\height > *this\height[#__c_inner] ) )
          
          If *this\color\back <>- 1
            If *this\color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( *this\vertical, *this,\color\fore[\color\state],\color\back[Bool( *this\__state&#__ss_back )*\color\state], [#__c_frame] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box( *this, color\back, [#__c_inner])
            EndIf
          EndIf
        EndIf
        
        ;
        If *this\image\id Or *this\image[#__img_background]\id Or *this\text\string
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
        EndIf
        
        ; background image draw 
        If *this\image[#__img_background]\id
          DrawAlphaImage( *this\image[#__img_background]\id,
                          x + *this\image[#__img_background]\x,
                          y + *this\image[#__img_background]\y, *this\color\_alpha )
        EndIf
        
        ; scroll image draw
        If *this\image\id
          DrawAlphaImage( *this\image\id,
                          x + *this\image\x,
                          y + *this\image\y, *this\color\_alpha )
        EndIf
        
        If *this\text\string
          If *this\row And ListSize( *this\_rows( ) )
            ForEach *this\_rows( )
              DrawRotatedText( x + *this\_rows( )\text\x, y + *this\_rows( )\text\y,
                               *this\_rows( )\text\String.s, *this\text\rotate, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] ) ; *this\_rows( )\color\font )
              
              If *this\mode\lines
                Protected i, count = Bool( func::GetFontSize( *this\_rows( )\text\fontID ) > 13 )
                For i = 0 To count
                  Line( x + *this\_rows( )\text\x, y + *this\_rows( )\text\y + *this\_rows( )\text\height - count + i - 1, *this\_rows( )\text\width,1, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] )
                Next
              EndIf
              
            Next 
          Else
            DrawRotatedText( x + *this\text\x, 
                             y + *this\text\y, 
                             *this\text\string, *this\text\rotate, *this\color\front[\color\state]&$FFFFFF | *this\color\_alpha<<24 )
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure   draw_Button( *this._S_widget )
      Protected x, y
      With *this
        ; update text 
        If *this\change 
          Editor_Update( *this, *this\_rows( ))
        EndIf
        
        If *this\image\change
          *this\image\padding\x = *this\text\padding\x 
          *this\image\padding\y = *this\text\padding\y
          
          ; make horizontal scroll max 
          If scroll_width_( *this ) < *this\image\width + *this\image\padding\x * 2
            scroll_width_( *this ) = *this\image\width + *this\image\padding\x * 2
          EndIf
          
          ; make vertical scroll max 
          If scroll_height_( *this ) < *this\image\height + *this\image\padding\y * 2
            scroll_height_( *this ) = *this\image\height + *this\image\padding\y * 2
          EndIf
          
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\image )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\image )
          
          
          set_align_x_( *this\image, *this\image, scroll_width_( *this ), 0 )
          set_align_y_( *this\image, *this\image, scroll_height_( *this ), 270 )
        EndIf
        
        If *this\type = #__type_Option Or 
           *this\type = #__type_CheckBox
          
          ; update widget ( option&checkbox ) position
          If *this\change
            *this\_box_\y = *this\y[#__c_inner] + ( *this\height[#__c_inner] - *this\_box_\height )/2
            
            If *this\text\align\anchor\right
              *this\_box_\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\_box_\height - 3 )
            ElseIf Not *this\text\align\anchor\left
              *this\_box_\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\_box_\width )/2
              
              If Not *this\text\align\anchor\top 
                If *this\text\rotate = 0
                  *this\_box_\y = *this\y[#__c_inner] + scroll_y_( *this ) - *this\_box_\height
                Else
                  *this\_box_\y = *this\y[#__c_inner] + scroll_y_( *this ) + scroll_height_( *this )
                EndIf
              EndIf
            Else
              *this\_box_\x = *this\x[#__c_inner] + 3
            EndIf
          EndIf
        EndIf
        
        
        ; origin position
        x = *this\x[#__c_inner] + scroll_x_( *this )
        y = *this\y[#__c_inner] + scroll_y_( *this )
        
        ; background draw
        If *this\image[#__img_background]\id
          ; background image draw 
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__img_background]\id, x + *this\image[#__img_background]\x, x + *this\image[#__img_background]\y, *this\color\_alpha )
        Else
          If *this\color\back <>- 1
            If \color\fore <>- 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical, *this,\color\fore[\color\state],\color\back[Bool( *this\__state&#__ss_back )*\color\state], [#__c_frame] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box( *this, color\back, [#__c_frame])
            EndIf
          EndIf
        EndIf
        
        ; draw text items
        If \text\string.s
          ;Clip( *this, [#__c_draw1] )
          ;Debug *this\text\string
          
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          ForEach *this\_rows( )
            DrawRotatedText( x + *this\_rows( )\x + *this\_rows( )\text\x, y + *this\_rows( )\y + *this\_rows( )\text\y,
                             *this\_rows( )\text\String.s, *this\text\rotate, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] ) ; *this\_rows( )\color\font )
            
            If *this\mode\lines
              Protected i, count = Bool( func::GetFontSize( *this\_rows( )\text\fontID ) > 13 )
              For i=0 To count
                Line( x + *this\_rows( )\x + *this\_rows( )\text\x, y + *this\_rows( )\y + *this\_rows( )\text\y + *this\_rows( )\text\height - count + i - 1, *this\_rows( )\text\width,1, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] )
              Next
            EndIf
            
          Next 
          
          ;Clip( *this, [#__c_draw] )
        EndIf
        
        ; box draw    
        Protected _box_x_,_box_y_
        If #__type_Option = *this\type
          draw_button_( 1, *this\_box_\x,*this\_box_\y,*this\_box_\width,*this\_box_\height, *this\_box_\___state , *this\_box_\round );, \color )
        EndIf 
        If #__type_CheckBox = *this\type
          draw_button_( 3, *this\_box_\x,*this\_box_\y,*this\_box_\width,*this\_box_\height, *this\_box_\___state , *this\_box_\round );, \color )
        EndIf
        
        ; image draw
        If \image\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( \image\id, x + \image\x, y + \image\y, \color\_alpha )
        EndIf
        
        ; defaul focus widget frame draw
        If *this\flag & #__button_default
          drawing_mode_( #PB_2DDrawing_Outlined )
          ;; draw_roundbox_( \x[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\width[#__c_inner]-4+2,\height[#__c_inner]-4+2,\round,\round,*this\color\frame[1] )
          If \round 
            draw_roundbox_( \x[#__c_inner]+2,\Y[#__c_inner]+2-1,\width[#__c_inner]-4,\height[#__c_inner]-4+2,\round,\round,*this\color\frame[1] ) 
          EndIf
          draw_roundbox_( \x[#__c_inner]+2,\Y[#__c_inner]+2,\width[#__c_inner]-4,\height[#__c_inner]-4,\round,\round,*this\color\frame[1] )
        EndIf
        
        ; area scrollbars draw 
        bar_area_draw_( *this )
        
        ; frame draw
        If *this\fs
          drawing_mode_( #PB_2DDrawing_Outlined )
          draw_box( *this, color\frame, [#__c_frame])
        EndIf
      EndWith
    EndProcedure
    
    Procedure   draw_Container1( *this._S_widget )
      With *this
        ;
        ; Clip( *this, [#__c_draw2] ) ; 2
        
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        ;draw_roundbox_( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;draw_roundbox_( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        draw_roundbox_( *this\x[#__c_inner],*this\y[#__c_inner],*this\width[#__c_inner],*this\height[#__c_inner], *this\round, *this\round, *this\color\back[*this\color\state] )
        
        
        If \image\id Or *this\image[#__img_background]\id
          If *this\image\change <> 0
            set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\image\change = 0
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          
          ; background image draw 
          If *this\image[#__img_background]\id
            DrawAlphaImage( *this\image[#__img_background]\id,
                            *this\x[#__c_inner] + *this\image[#__img_background]\x,
                            *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
          EndIf
          
          ; scroll image draw
          If \image\id
            DrawAlphaImage( \image\id,
                            *this\x[#__c_inner] + scroll_x_( *this ) + *this\image\x,
                            *this\y[#__c_inner] + scroll_y_( *this ) + *this\image\y, *this\color\_alpha )
          EndIf
        EndIf
        
        If \text\string
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_inner] + scroll_x_( *this ) + \text\x, 
                    *this\y[#__c_inner] + scroll_y_( *this ) + \text\y, 
                    \text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
        EndIf
        
        ;
        Clip( *this, [#__c_draw] )
        
        ; area scrollbars draw 
        bar_area_draw_( *this )
        
        If *this\fs
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          Protected i
          For i=0 To *this\fs
            draw_roundbox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            If i<*this\fs
              draw_roundbox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i+1,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2-2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            EndIf
          Next
        EndIf
        
        ; area scrollbars draw 
        If *this\scroll
          bar_area_draw_( *this )
        EndIf 
      EndWith
    EndProcedure
    Procedure   draw_Container( *this._S_widget )
      With *this
        
        If *this\type <> #__type_panel
          If *this\fs 
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            Protected i
            For i=0 To *this\fs
              draw_roundbox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2, *this\round, *this\round, *this\color\frame[*this\color\state] )
              If i<*this\fs
                draw_roundbox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i+1,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2-2, *this\round, *this\round, *this\color\frame[*this\color\state] )
              EndIf
            Next
          EndIf
        EndIf
        
        ; area scrollbars draw 
        ;;bar_area_draw_( *this )
        ;
        ; Clip( *this, [#__c_draw] ) ; 2
        
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        ;draw_roundbox_( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;draw_roundbox_( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        draw_roundbox_( *this\x[#__c_inner],*this\y[#__c_inner],*this\width[#__c_inner],*this\height[#__c_inner], *this\round, *this\round, *this\color\back[*this\color\state] )
        
        
        If \image\id Or *this\image[#__img_background]\id
          If *this\image\change <> 0
            set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\image\change = 0
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          
          ; background image draw 
          If *this\image[#__img_background]\id
            DrawAlphaImage( *this\image[#__img_background]\id,
                            *this\x[#__c_inner] + *this\image[#__img_background]\x,
                            *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
          EndIf
          
          ; scroll image draw
          If \image\id
            DrawAlphaImage( \image\id,
                            *this\x[#__c_inner] + scroll_x_( *this ) + *this\image\x,
                            *this\y[#__c_inner] + scroll_y_( *this ) + *this\image\y, *this\color\_alpha )
          EndIf
        EndIf
        
        If \text\string
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_inner] + scroll_x_( *this ) + \text\x, 
                    *this\y[#__c_inner] + scroll_y_( *this ) + \text\y, 
                    \text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
        EndIf
        
        
        ; area scrollbars draw 
        If *this\scroll
          bar_area_draw_( *this )
        EndIf
      EndWith
    EndProcedure
    
    Macro draw_below_( _this_ )
      ; limit drawing boundaries
      Clip( _this_, [#__c_draw] ) ; 2
      
      ; draw widgets
      Select _this_\type
        Case #__type_Window         : Window_Draw( _this_ )
        Case #__type_MDI            : draw_Container( _this_ )
        Case #__type_Container      : draw_Container( _this_ )
        Case #__type_ScrollArea     : draw_Container( _this_ )
        Case #__type_Image          : draw_Container( _this_ )
          
          ;- widget::_draw_Panel( )
        Case #__type_Panel         
          ;             If _this_\TabWidget( ) And _this_\TabWidget( )\count\items
          draw_Container( _this_ )
          
          If _this_\fs > 1
            draw_roundbox_( \x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\fs-1, _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            draw_roundbox_( \x[#__c_frame], _this_\y[#__c_frame], _this_\fs-1, _this_\height[#__c_frame], _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            draw_roundbox_( \x[#__c_frame] + _this_\width[#__c_frame] - _this_\fs+1, _this_\y[#__c_frame], _this_\fs-1, _this_\height[#__c_frame], _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            draw_roundbox_( \x[#__c_frame], _this_\y[#__c_frame]+_this_\height[#__c_frame] - _this_\fs+1, _this_\width[#__c_frame], _this_\fs-1, _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
          EndIf
          
          ;             Else
          ;               drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;              draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\color\back[0] )
          ;               
          ;               drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          ;              draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\color\frame[Bool( _this_\TabWidget( )\SelectedTabIndex( ) <>- 1 )*2 ] )
          ;             EndIf
          
          ;- widget::_draw_String( )
        Case #__type_String         : Editor_Draw( _this_ )
          
          If _this_\scroll\v And _this_\scroll\h
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ; Scroll area coordinate
            draw_box_(_this_\scroll\h\x + _this_\scroll\x, _this_\scroll\v\y + _this_\scroll\y, _this_\scroll\width, _this_\scroll\height, $FF0000FF)
            
            ; Debug ""+ _this_\scroll\x +" "+ _this_\scroll\y +" "+ _this_\scroll\width +" "+ _this_\scroll\height
            draw_box_(_this_\scroll\h\x - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FFFF0000)
            
            ; page coordinate
            draw_box_(_this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
          EndIf
          
          ;- widget::_draw_ComboBox( )
        Case #__type_ComboBox       
          _this_\_box_\arrow\type = #__arrow_type 
          _this_\_box_\arrow\size = #__arrow_size
          
          If *this\text\editable
            _this_\_box_\width = 17
            _this_\_box_\x = _this_\x + _this_\width - _this_\_box_\width
            arrow_right = 0
          Else
            _this_\_box_\width = _this_\width
            _this_\_box_\x = _this_\x
            arrow_right = 1
          EndIf
          
          _this_\_box_\y = _this_\y
          _this_\_box_\height = _this_\barheight
          
          _this_\text\x = 5
          _this_\text\y = (_this_\_box_\height - _this_\text\height)/2
          
          ;  first update
          If _this_\change > 0
            _update_items_( _this_, _this_\change )
          EndIf
          
          ;
          If *this\text\editable
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_box_( _this_\x[#__c_inner], _this_\y[#__c_frame] + _this_\fs, _this_\width[#__c_inner], _this_\barheight, $ffffffff )
          Else
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_( _this_\vertical, _this_, _this_\color\fore[_this_\color\state], _this_\color\back[Bool( _this_\__state & #__ss_back ) * _this_\color\state], [#__c_frame] )
          EndIf
          
          If _this_\state\flag & #__S_collapse
            ; Draw scroll bars
            bar_area_draw_( _this_ )
            
            _this_\_box_\arrow\direction = 3
          Else
            _this_\_box_\arrow\direction = 2
          EndIf
          
          If _this_\text\string
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( _this_\x[#__c_frame] + _this_\text\x, 
                      _this_\y[#__c_frame] + _this_\text\y, 
                      _this_\text\string, _this_\color\front[_this_\color\state]&$FFFFFF | _this_\color\_alpha<<24 )
          EndIf
          
          ;
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          If arrow_right
            Arrow( _this_\_box_\x + ( _this_\_box_\width - _this_\_box_\arrow\size*2 - 4 ),
                   _this_\_box_\y + ( _this_\_box_\height - _this_\_box_\arrow\size )/2, _this_\_box_\arrow\size, _this_\_box_\arrow\direction, 
                   _this_\_box_\color\front[_this_\_box_\color\state]&$FFFFFF | _this_\_box_\color\_alpha<<24, _this_\_box_\arrow\type )
          Else
            draw_arrows_( _this_\_box_, _this_\_box_\arrow\direction ) 
          EndIf
          
          
          ; Draw combo-popup-menu backcolor
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_( _this_\x[#__c_inner], _this_\y[#__c_inner], _this_\width[#__c_inner], _this_\height[#__c_inner], $ffffffff )
          
          ; Draw combo-popup-menu all rows
          draw_items_( _this_, _this_\VisibleRows( ), _this_\scroll\h\bar\page\pos, _this_\scroll\v\bar\page\pos )
          
          ; frame draw
          If _this_\fs
            drawing_mode_( #PB_2DDrawing_Outlined )
            draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\barheight, _this_\color\frame[_this_\color\state] )
            draw_box_( _this_\x[#__c_frame], _this_\y[#__c_inner]-1, _this_\width[#__c_frame], _this_\height[#__c_inner]+2, _this_\color\frame[_this_\color\state] )
          EndIf
          
          
          
        Case #__type_Editor         : Editor_Draw( _this_ )
          
        Case #__type_Tree           : Tree_Draw( _this_ )
        Case #__type_property       : Tree_Draw( _this_ )
        Case #__type_ListView       : Tree_Draw( _this_ )
          
        Case #__type_Text           : draw_Button( _this_ )
        Case #__type_Button         : draw_Button( _this_ )
        Case #__type_ButtonImage    : draw_Button( _this_ )
        Case #__type_Option         : draw_Button( _this_ )
        Case #__type_CheckBox       : draw_Button( _this_ )
        Case #__type_HyperLink      : draw_Button( _this_ )
          
        Case #__type_Spin ,
             #__type_TabBar,#__type_ToolBar,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter       
          
          bar_draw( _this_ )
      EndSelect
      
      ; 
      If _this_\TabWidget( ) And _this_\TabWidget( )\count\items
        bar_tab_draw( _this_\TabWidget( ) ) 
      EndIf
      
      ; draw disable state
      If _this_\state\disable
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $80f0f0f0 )
      EndIf
      
      ; draw drag & drop
      If _this_\state\enter And 
         Not _this_\state\disable And mouse( )\drag
        DD_draw( _this_ )
      EndIf
      
    EndMacro
    Macro draw_above_( _this_ )
      Clip( _this_, [#__c_draw] ) ; 2
      
      ; draw keyboard focus widget frame
      If _this_\state\focus And _this_\type = #__type_window
        ;         drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        ;         If _this_\round
        ;           RoundBox( _this_\x[#__c_frame]-1, _this_\y[#__c_frame]-1, _this_\width[#__c_frame]+2, _this_\height[#__c_frame]+2, _this_\round, _this_\round, $ffff0000 )
        ;           RoundBox( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\round, _this_\round, $ffff0000 )
        ;           RoundBox( _this_\x[#__c_frame]+1, _this_\y[#__c_frame]+1, _this_\width[#__c_frame]-2, _this_\height[#__c_frame]-2, _this_\round, _this_\round, $ffff0000 )
        ;         Else
        ;          draw_box_( _this_\x[#__c_frame]-1, _this_\y[#__c_frame]-1, _this_\width[#__c_frame]+2, _this_\height[#__c_frame]+2, $ffff0000 )
        ;          draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $ffff0000 )
        ;          draw_box_( _this_\x[#__c_frame]+1, _this_\y[#__c_frame]+1, _this_\width[#__c_frame]-2, _this_\height[#__c_frame]-2, $ffff0000 )
        ;         EndIf
      EndIf
      
      If _this_\_a_\transform And a_focus_widget( ) And
         _this_ <> a_focus_widget( )
        a_draw( _this_ )
      EndIf
      
      ;         If _this_\_a_\transform 
      ;           drawing_mode_( #PB_2DDrawing_Outlined )
      ;           
      ;           If _this_\_a_\transform = 2
      ;             Clip( _this_, [#__c_frame] )
      ;             ; draw group transform widgets frame
      ;            draw_box_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $ffff00ff )
      ;           Else
      ;             Clip( _this_, [#__c_inner] )
      ;             ; draw clip out transform widgets frame
      ;            draw_box_( _this_\x[#__c_inner], _this_\y[#__c_inner], _this_\width[#__c_inner], _this_\height[#__c_inner], $ff00ffff )
      ;           EndIf
      ;         EndIf
      
      ;;Debug _this_\class
      Post( _this_, #PB_EventType_Draw ) 
      
    EndMacro
    
    Procedure.b Draw( *this._S_widget )
      Protected arrow_right
      
      With *this
        If *this\state\repaint = #True
          *this\state\repaint = #False
        EndIf
        
        ; we call the event dispatched before the binding 
        If *this\event And 
           *this\count\events = 0 ;And ListSize( *this\event\queue( ))
          *this\count\events = 1
          
          ForEach *this\event\queue( )
            Post( *this, *this\event\queue( )\type, *this\event\queue( )\item, *this\event\queue( )\data ) 
          Next
          ; ClearList( *this\event\queue( ))
        EndIf
        
        ; init drawing font
        draw_font_( *this )
        
        ; draw belowe drawing
        If Not *this\hide 
          If *this\resize & #__resize_change
            Reclip( *this )
          EndIf
          
          If *this\width[#__c_draw] > 0 And
             *this\height[#__c_draw] > 0
            draw_below_( *this )
          EndIf
        EndIf
        
        ;         ; draw above drawing
        ;         If Not *this\last\widget 
        ;           draw_above_( *this )
        ;         EndIf
        ;         If *this\position & #PB_List_Last And *this\_parent( ) 
        ;           draw_above_( *this\_parent( ) )
        ;         EndIf
        
        If *this\_a_\transform And a_focus_widget( ) And *this <> a_focus_widget( )
          a_draw( *this\_a_\id )
        EndIf
        
        If *this\data And *this\container
          drawing_mode_( #PB_2DDrawing_Transparent )
          DrawText( *this\x, *this\y, Str( *this\data ), 0)
        EndIf
        
        ;
        If Not *this\hide
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
        EndIf
        
        
        ;
        Post( *this, #PB_EventType_Draw )
        If *this\resize <> 0
          ;            Debug 88888884
          ;           If *this\_a_\transform Or *this\container 
          ;            ;  Post( *this, #PB_EventType_Resize )
          ;           EndIf
          ;           If *this ;= *this\_root( )\canvas\ResizeEndWidget
          ;             Debug 8888888
          ;              Post( *this, #PB_EventType_Resize )
          ;              If *this\_root( )\canvas\ResizeEndWidget
          ;             Debug 88888883333
          ;                Post( *this\_root( )\canvas\ResizeEndWidget, #PB_EventType_ResizeEnd )
          ;             *this\_root( )\canvas\ResizeEndWidget = #Null
          ;           EndIf
          ;         EndIf
          *this\resize = 0
        EndIf
      EndWith
    EndProcedure
    
    Procedure   ReDraw( *this._S_widget )
      If Drawing( ) 
        StopDrawing()
      EndIf
      
      Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
      
      If Drawing( )
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
                   #PB_Compiler_OS = #PB_OS_Windows
          ; difference in system behavior
          If *this\_root( )\canvas\fontID
            DrawingFont( *this\_root( )\canvas\fontID ) 
          EndIf
        CompilerEndIf
        
        ;
        If Not ( a_transform( ) And a_transform( )\grab )
          If is_root_(*this )
            
            CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
              ; good transparent canvas
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
            CompilerElse
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
            CompilerEndIf
            
            Draw( *this\_root( ))
            
            PushListPosition( *this\_widgets( ))
            ForEach *this\_widgets( )
              If *this\_widgets( )\_root( )\canvas\gadget = *this\_root( )\canvas\gadget
                
                ; begin draw all widgets
                Draw( *this\_widgets( ))
                
              EndIf
            Next
            
            ;
            UnclipOutput( )
            
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ForEach *this\_widgets( )
              If *this\_widgets( )\_root( )\canvas\gadget = *this\_root( )\canvas\gadget And 
                 Not ( *this\_widgets( )\hide = 0 And *this\_widgets( )\width[#__c_draw] > 0 And *this\_widgets( )\height[#__c_draw] > 0 )
                
                
                ; draw group transform widgets frame
                ;If *this\_widgets( )\_a_\transform = 2
                ; draw_box_( *this\_widgets( )\x[#__c_frame], *this\_widgets( )\y[#__c_frame], *this\_widgets( )\width[#__c_frame], *this\_widgets( )\height[#__c_frame], $ffff00ff )
                ;EndIf
                ;Else
                ; draw clip out transform widgets frame
                ;If *this\_widgets( )\_a_\transform 
                If is_parent_( *this\_widgets( ), *this\_widgets( )\_parent( ) ) And Not *this\_widgets( )\_parent( )\hide 
                  draw_box_( *this\_widgets( )\x[#__c_inner], *this\_widgets( )\y[#__c_inner], *this\_widgets( )\width[#__c_inner], *this\_widgets( )\height[#__c_inner], $ff00ffff )
                EndIf
                ;EndIf
              EndIf
            Next
            PopListPosition( *this\_widgets( ))
            
          Else
            Draw( *this )
          EndIf
          
          EventWidget( ) = #Null
          WidgetEvent( )\type = #PB_All
          WidgetEvent( )\item = #PB_All
          WidgetEvent( )\data = #Null
        EndIf
        
        ; draw current popup-widget
        If Popu_parent( ) And Popu_parent( )\_root( ) = *this\_root( )
          Draw( Popu_parent( ) )
          ;Tree_Draw( Popu_parent( ), VisibleRowList( Popu_parent( ) ))
          
        EndIf
        
        
        ; draw movable-sizable anchors
        If a_transform( )
          If a_focus_widget( ) And a_focus_widget( )\_a_\transform And 
             a_focus_widget( )\_root( )\canvas\gadget = *this\_root( )\canvas\gadget 
            
            ; draw mouse selected widget anchors
            Clip( a_transform( )\main, [#__c_draw2] )
            a_draw( a_focus_widget( )\_a_\id )
          EndIf
          
          If a_transform( ) And a_focus_widget( ) And 
             a_focus_widget( )\_root( )\canvas\gadget = *this\_root( )\canvas\gadget 
            
            ; draw mouse selected widget anchors
            Clip( a_transform( )\main, [#__c_draw2] )
            ;  a_draw( a_transform( )\id )
          EndIf
          
          If a_transform( )\main And 
             a_transform( )\main\_root( )\canvas\gadget = *this\_root( )\canvas\gadget 
            a_draw_sel( a_transform( ) )
          EndIf
        EndIf
        
        Drawing( ) = 0
        StopDrawing( )
      EndIf
    EndProcedure
    
    ;-
    Procedure.i Post( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      Protected result
      ;       Select eventtype
      ;         Case #PB_EventType_MouseEnter
      ;           Debug " enter "+*this\class
      ;         Case #PB_EventType_MouseLeave 
      ;           Debug " leave "+*this\class
      ;       EndSelect
      
      
      If *this = #PB_All
        ; 4)
      Else
        
        If WidgetEvent( )\pFunc
          
          EventWidget( ) = *this
          WidgetEvent( )\type = eventtype
          WidgetEvent( )\item = *button
          WidgetEvent( )\data = *data
          
          ; call event function
          If Not is_root_(*this )
            ; first call current-widget bind event function
            If *this\event
              ForEach *this\event\call( )
                If *this\event\call( )\type = #PB_All Or  
                   *this\event\call( )\type = eventtype
                  
                  result = *this\event\call( )\pFunc( )
                  
                  If result
                    Break 
                  EndIf
                EndIf
              Next
            EndIf
            
            ; second call current-widget-window bind event function
            If result <> #PB_Ignore And
               Not is_window_( *this ) And 
               Not is_root_(*this\_window( ) ) And *this\_window( )\event
              
              ForEach *this\_window( )\event\call( )
                If *this\_window( )\event\call( )\type = #PB_All Or  
                   *this\_window( )\event\call( )\type = eventtype
                  
                  result = *this\_window( )\event\call( )\pFunc( )
                  
                  If result
                    Break 
                  EndIf
                EndIf
              Next
            EndIf
          EndIf
          
          ; If is_root_(*this )
          ; theard call current-widget-root bind event function
          If result <> #PB_Ignore And 
             *this\_root( )\event
            ForEach *this\_root( )\event\call( )
              If *this\_root( )\event\call( )\type = #PB_All Or  
                 *this\_root( )\event\call( )\type = eventtype
                
                result = *this\_root( )\event\call( )\pFunc( )
                
                If result
                  Break 
                EndIf
              EndIf
            Next
          EndIf
          ;EndIf
          
          ; если это оставить то после вызова функции напр setState() получается EventWidget( ) будеть равно #Null 
          ;           EventWidget( ) = #Null
          ;           WidgetEvent( )\type = #PB_All
          ;           WidgetEvent( )\item = #PB_All
          ;           WidgetEvent( )\data = #Null
          
          
        Else
          If Not *this\event
            *this\event.allocate( EVENT )
          EndIf
          AddElement( *this\event\queue( ))
          *this\event\queue.allocate( EVENTDATA, ( )) 
          
          *this\event\queue( )\type = eventtype
          *this\event\queue( )\item = *button
          *this\event\queue( )\data = *data
        EndIf
        
      EndIf
    EndProcedure
    
    Procedure.i Bind( *this._S_widget, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      WidgetEvent( )\pFunc = 1
      
      If *this = #PB_All
        
        PushMapPosition(Root( ))
        ForEach Root( )
          Bind( Root( ), *callback, eventtype, item )
        Next
        PopMapPosition(Root( ))
        
        ; 4)
      Else
        If Not *this\event
          *this\event.allocate( EVENT )
        EndIf
        
        ; is bind event callback
        ForEach *this\event\call( )
          If *this\event\call( )\pFunc = *callback And 
             *this\event\call( )\type = eventtype And 
             *this\event\call( )\item = item
            ProcedureReturn *this\event\call( )
          EndIf
        Next
        
        ;
        LastElement( *this\event\call( ))
        If AddElement( *this\event\call( ))
          *this\event\call.allocate( EVENTDATA, ( )) 
          *this\event\call( )\pFunc = *callback
          *this\event\call( )\type = eventtype
          *this\event\call( )\item = item
          ProcedureReturn 1
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i Unbind( *this._S_widget, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      If *this = #PB_All
        ; 4)
      Else
        If *this\event
          ForEach *this\event\call( )
            If *this\event\call( )\pFunc = *callback And 
               *this\event\call( )\type = eventtype And 
               *this\event\call( )\item = item
              DeleteElement( *this\event\call( ) )
              Break
            EndIf
          Next
        EndIf
      EndIf
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
    Procedure Button_events( *this._S_widget, eventtype.l, *rows._S_rows, *data)
      Protected Repaint
      
      ;- widget::_events_Button( )
      If *this\type = #__type_Button
        If Not *this\state\flag & #__S_check
          Select eventtype
            Case #PB_EventType_MouseLeave     
              *this\color\state = #__S_0 
              Repaint = #True 
              
            Case #PB_EventType_LeftButtonDown 
              ;If *this\state\enter
              *this\color\state = #__S_2  
              ;EndIf
              Repaint = #True 
              
            Case #PB_EventType_MouseEnter     
              Repaint = #True 
              If *this\state\press
                *this\color\state = #__S_2
              Else
                *this\color\state = #__S_1
              EndIf
              
          EndSelect
        EndIf
        
        If eventtype = #PB_EventType_LeftButtonUp 
          ;If *this\color\state = #__S_2
          Repaint = #True
          ;EndIf
        EndIf
        
        If eventtype = #PB_EventType_LeftClick
          ;If *this\color\state = #__S_2
          SetState( *this, Bool( Bool( *this\state\flag & #__S_check ) ! 1 ))
          
          ;Post( *this, eventtype, #PB_All, 0 )
          ;EndIf
        EndIf
        
        If *this\image[#__img_released]\id Or *this\image[#__img_pressed]\id
          *this\image = *this\image[1 + Bool( *this\color\state = #__S_2 )]
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure DoEvent_BarButtons( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected repaint, *button._S_buttons
      
      
      ;
      ; get at-point-tab address
      If *this\bar
        ;
        ; get at-point-button address
        If  *this\state\enter
          If Not ( EnteredButton( ) And 
                   EnteredButton( )\hide = 0 And 
                   is_at_point_( EnteredButton( ), mouse_x, mouse_y ))
            
            ; search entered button
            If BB1( )\interact And 
               is_at_point_( BB1( ), mouse( )\x, mouse( )\y )
              
              *button = BB1( )
            ElseIf BB2( )\interact And
                   is_at_point_( BB2( ), mouse( )\x, mouse( )\y )
              
              *button = BB2( )
            ElseIf BB3( )\interact And
                   is_at_point_( BB3( ), mouse( )\x, mouse( )\y, )
              
              *button = BB3( )
            EndIf
          EndIf
        Else
          *button = EnteredButton( )
        EndIf
        
        ; 
        If eventtype = #PB_EventType_MouseLeave
          *button = #Null
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown
          PressedButton( ) = *button
          
          If PressedButton( ) And
             PressedButton( )\state\disable = #False And 
             PressedButton( )\state\press = #False
            
            PressedButton( )\state\press = #True
            PressedButton( )\color\state = #__S_2
            PressedButton( )\color\back[PressedButton( )\color\state] = $FF2C70F5
            
            ;
            If     ( BB2( )\state\press And *this\bar\invert ) Or
                   ( BB1( )\state\press And Not *this\bar\invert )
              DoEvents( *this, #PB_EventType_Up, *this\bar, *this\bar\page\pos - *this\scroll\increment )
            ElseIf ( BB1( )\state\press And *this\bar\invert ) Or
                   ( BB2( )\state\press And Not *this\bar\invert )
              DoEvents( *this, #PB_EventType_Down, *this\bar, *this\bar\page\pos + *this\scroll\increment )
            EndIf
            
            *this\state\repaint = #True
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          If PressedButton( )
            If PressedButton( )\state\press = #True
              PressedButton( )\state\press = #False
              
              If PressedButton( )\state\disable = #False And PressedButton( )\state\focus = #False
                If PressedButton( )\state\enter
                  PressedButton( )\color\state = #__S_1
                Else
                  PressedButton( )\color\state = #__S_0
                EndIf
                
                *this\state\repaint = #True
              EndIf 
              
              If *this\type = #__type_Splitter
                If EnteredButton( ) <> PressedButton( )  
                  DoEvents( *this, #PB_EventType_CursorChange, PressedButton( ), cursor::#PB_Cursor_Default )
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; drop
          If EnteredWidget( )
            If EnteredWidget( )\type = #__type_Splitter
              If EnteredButton( ) = BB3( ) And
                 EnteredButton( ) <> PressedButton( )
                
                If EnteredWidget( )\vertical
                  DoEvents( EnteredWidget( ), #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_UpDown )
                Else
                  DoEvents( EnteredWidget( ), #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_LeftRight )
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; do buttons events entered & leaved 
        If EnteredButton( ) <> *button 
          If EnteredButton( )
            If EnteredButton( )\state\enter = #True
              EnteredButton( )\state\enter = #False
              
              If EnteredButton( )\color\state = #__S_1
                EnteredButton( )\color\state = #__S_0
              EndIf
            EndIf
            
            If *this\type = #__type_Splitter
              If Not mouse( )\buttons
                DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_Default )
              EndIf
            EndIf
          EndIf
          
          ; Debug ""+*button+" "+EnteredButton( )
          EnteredButton( ) = *button
          
          If EnteredButton( )
            If *this\state\enter
              If EnteredButton( )\state\enter = #False
                EnteredButton( )\state\enter = #True
                
                If EnteredButton( )\color\state = #__S_0
                  EnteredButton( )\color\state = #__S_1
                EndIf
                
                ;
                If *this\type = #__type_Splitter
                  If ( BB3( )\state\enter And Not mouse( )\buttons )
                    BB1()\state\disable = bar_in_start_( *this\bar )
                    BB2()\state\disable = bar_in_stop_( *this\bar )
                    
                    If BB1()\state\disable Or BB2()\state\disable
                      If BB1()\state\disable
                        If *this\vertical
                          DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_Down )
                        Else
                          DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_Right )
                        EndIf
                      EndIf
                      If BB2()\state\disable
                        If *this\vertical
                          DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_Up )
                        Else
                          DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_Left )
                        EndIf
                      EndIf
                    Else
                      If *this\vertical
                        DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_UpDown )
                      Else
                        DoEvents( *this, #PB_EventType_CursorChange, EnteredButton( ), cursor::#PB_Cursor_LeftRight )
                      EndIf
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          *this\state\repaint = #True
        EndIf
        
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure Row_timer_events( )
      ; Debug "  timer"
      Protected result
      Protected scroll_x, scroll_y
      Protected  *this._S_widget = PressedWidget( )
      
      If *this
        If *this\_root( ) <> Root( )
          mouse( )\x = CanvasMouseX( *this\_root( )\canvas\gadget )
          mouse( )\y = CanvasMouseY( *this\_root( )\canvas\gadget )
        EndIf
        
        If Not is_at_point_y_( *this, mouse( )\y, [#__c_inner] ) And *this\scroll\v
          If mouse( )\y < mouse( )\delta\y
            If Not bar_in_start_( *this\scroll\v\bar )
              scroll_y = mouse( )\y - ( *this\y[#__c_inner] )
              bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + scroll_y )
              Editor_Update( *this, *this\_rows( ))
              ReDraw(   *this\_root( ) ) 
              Debug "scroll v top " + scroll_y +" "+ *this\VisibleFirstRow( )\index
              
            Else
              ; Debug "scroll v stop top"
            EndIf
          ElseIf mouse( )\y > mouse( )\delta\y
            If Not bar_in_stop_( *this\scroll\v\bar )
              scroll_y = 400;mouse( )\y - ( *this\y[#__c_inner] + *this\height[#__c_inner] )
                            ;bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + scroll_y )
                            ;Editor_Update( *this, *this\_rows( ))
                            ;ReDraw(   *this\_root( ) ) 
              Debug "scroll v bottom "+ scroll_y +" "+ *this\VisibleLastRow( )\index
              
              ;               If *this\FocusedRow( ) <> *this\VisibleLastRow( )
              ;                 ;                 If *this\EnteredRow( )
              ;                 ;                   *this\EnteredRow( )\state\enter = 0
              ;                 ;                   *this\EnteredRow( )\color\state = 0
              ;                 ;                 EndIf
              ;                 ;                 *this\EnteredRow( ) = *this\VisibleLastRow( )
              ;                 ;                 *this\EnteredRow( )\state\enter = 1
              ;                 ;                 *this\EnteredRow( )\color\state = 1
              ;                 
              ;                 If *this\FocusedRow( )
              ;                   ; Debug "scroll v bottom "+ scroll_y +" "+ *this\VisibleLastRow( )\index +" "+ *this\FocusedRow( )\index
              ;                   *this\FocusedRow( )\state\focus = 0
              ;                   *this\FocusedRow( )\color\state = 0
              ;                 EndIf
              ;                 
              ;                 ; edit_sel__( *this, *this\VisibleLastRow( ), *this\PressedRow( ), *this\FocusedRow( ), 0, *this\FocusedRow( )\text\len )
              ;                 *this\FocusedRow( ) = *this\VisibleLastRow( )
              ;                 ;*this\FocusedRow( ) = SelectElement( *this\_rows( ), *this\VisibleLastRow( )\index )
              ;                 *this\FocusedRow( )\state\focus = 1
              ;                 *this\FocusedRow( )\color\state = 1
              ;                 *this\FocusedRow( )\state\repaint = 1
              ;                 
              ;                 Debug *this\FocusedRow( )\index
              ;                 edit_set_sel_( *this, *this\FocusedRow( ), *this\PressedRow( ) )
              ;                 
              ;                 *this\state\repaint = 1
              ;               EndIf             
              
              ;                 result = 1
            Else
              ; Debug "scroll v stop bottom"
            EndIf
          EndIf
        EndIf
        
        If Not is_at_point_x_( *this, mouse( )\x, [#__c_inner] ) And *this\scroll\h
          If mouse( )\x < mouse( )\delta\x
            If Not bar_in_start_( *this\scroll\h\bar )
              scroll_x = mouse( )\x - ( *this\x[#__c_inner] )
              Debug "scroll h top " + scroll_x
              bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos + scroll_x )
              result = 1
            Else
              ; Debug "scroll h stop top"
            EndIf
          ElseIf mouse( )\x > mouse( )\delta\x
            If Not bar_in_stop_( *this\scroll\h\bar )
              scroll_x = mouse( )\x - ( *this\x[#__c_inner] + *this\height[#__c_inner] )
              Debug "scroll h bottom "+ scroll_x
              bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos + scroll_x )
              result = 1
            Else
              ; Debug "scroll h stop bottom"
            EndIf
          EndIf
        EndIf
        
        If result = 1
          ;Debug 888
          ;           ReDraw(   *this\_root( ) ) 
          ;           PostCanvasRepaint( *this\_root( ) )
          ;           DoEvents( *this, #PB_EventType_StatusChange, #PB_All, #Null )
        EndIf 
      EndIf
      
    EndProcedure
    
    Procedure DoEvent_Lines( *this._S_widget, eventtype.l, mouse_x.l =- 1, mouse_y.l =- 1 )
      Protected repaint, *item._S_ROWS
      
      ;
      If *this\row
        ;         If PressedWidget( ) And PressedWidget( )\state\press And (mouse( )\drag And mouse( )\drag\PrivateType) Or Not ( PressedWidget( )\row  )
        ;           ;Debug "disable items redraw"
        ;           ProcedureReturn 0
        ;         EndIf
        
        ;
        If eventtype = #PB_EventType_Focus
          PushListPosition( *this\_rows( ) )
          ForEach *this\_rows( )
            If *this\_rows( )\state\focus
              If *this\_rows( )\color\state = #__s_3
                *this\_rows( )\color\state = #__s_2
                
                *this\_rows( )\state\repaint = #True
              EndIf
            EndIf
          Next
          PopListPosition( *this\_rows( ) )
        EndIf
        
        ;
        If eventtype = #PB_EventType_LostFocus
          PushListPosition( *this\_rows( ) )
          ForEach *this\_rows( )
            If *this\_rows( )\state\focus
              If *this\_rows( )\color\state = #__s_2
                *this\_rows( )\color\state = #__s_3
                
                *this\_rows( )\state\repaint = #True
              EndIf
            EndIf
          Next
          PopListPosition( *this\_rows( ) )
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown ; Ok
          If *this\EnteredRow( )
            *this\PressedRow( ) = *this\EnteredRow( )
            
            If *this\PressedRow( )\state\press = #False
              *this\PressedRow( )\state\press = #True
            EndIf
            
            If *this\FocusedRow( ) <> *this\EnteredRow( )
              If *this\FocusedRow( ) 
                If *this\FocusedRow( )\state\focus
                  *this\FocusedRow( )\state\focus = #False
                EndIf
              EndIf
              
              *this\FocusedRow( ) = *this\EnteredRow( )
              
              If *this\FocusedRow( )\state\focus = #False
                *this\FocusedRow( )\state\focus = #True
              EndIf
            EndIf
            
            ;\\ edit_sel_pos( *this, *this\EnteredRow( ), *this\PressedRow( ), edit_caret_( *this ), 1 )
            ;# *this\FocusedRow( ) = *this\EnteredRow( )
            *this\edit_caret_1( ) = edit_caret_( *this )
            *this\edit_caret_2( ) = *this\edit_caret_1( )
            *this\edit_lineDelta( ) = *this\EnteredRow( )\index
            ;\\ edit_row_caret_1_( *this ) = *this\edit_caret_1( ) - *this\EnteredRow( )\text\pos
            *this\EnteredRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\EnteredRow( )\text\pos
            If *this\text\edit[2]\width
              If *this\text\multiLine 
                ForEach *this\_rows( ) 
                  If *this\_rows( )\text\edit[2]\width <> 0 
                    ; Debug " remove - " +" "+ *this\_rows( )\text\string
                    edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                  EndIf
                Next
              EndIf
            EndIf
            edit_sel_row_text_( *this, *this\EnteredRow( ) )
            edit_sel_text_( *this, *this\EnteredRow( ) )
            
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp ; Ok
          If *this\PressedRow( )
            If *this\PressedRow( )\state\press = #True
              *this\PressedRow( )\state\press = #False
              
              If *this\PressedRow( )\state\focus = #False
                If *this\PressedRow( )\state\enter
                  *this\PressedRow( )\color\state = #__S_1
                Else
                  *this\PressedRow( )\color\state = #__S_0
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; get at point items 
        If ListSize( *this\VisibleRows( ) ) 
          If Not ( *this\EnteredRow( ) And 
                   *this\EnteredRow( )\visible And 
                   *this\EnteredRow( )\hide = 0 And 
                   ( ( *this\state\enter And is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_y_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\VisibleRows( )) 
            Repeat                                 
              If *this\VisibleRows( )\visible And 
                 *this\VisibleRows( )\hide = 0 And 
                 ( ( *this\state\enter And is_at_point_( *this\VisibleRows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_y_( *this\VisibleRows( ), mouse_y )) )
                *item = *this\VisibleRows( ) 
                Break
              EndIf
            Until PreviousElement( *this\VisibleRows( )) = #False 
          Else
            *item = *this\EnteredRow( )
          EndIf
        ElseIf ListSize( *this\_rows( ) ) 
          If Not ( *this\EnteredRow( ) And 
                   *this\EnteredRow( )\visible And 
                   *this\EnteredRow( )\hide = 0 And 
                   ( ( *this\state\enter And is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_y_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\_rows( )) 
            Repeat                                 
              If *this\_rows( )\visible And 
                 *this\_rows( )\hide = 0 And 
                 ( ( *this\state\enter And is_at_point_( *this\_rows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_y_( *this\_rows( ), mouse_y )) )
                *item = *this\_rows( ) 
                Break
              EndIf
            Until PreviousElement( *this\_rows( )) = #False 
          Else
            *item = *this\EnteredRow( )
          EndIf
        EndIf
        
        ; 
        If *this\state\drag 
          If *item = #Null
            If mouse( )\y < mouse( )\delta\y And mouse( )\y <= *this\y[#__c_inner]
              If *this\VisibleFirstRow( ) And Not bar_in_start_( *this\scroll\v\bar ) 
                ChangeCurrentElement( *this\_rows( ), *this\VisibleFirstRow( ))
                *item = PreviousElement( *this\_rows( ) )
                
                If *item
                  row_scroll_y_( *this, *item )
                EndIf
              Else
                ; *item = *this\VisibleFirstRow( )
              EndIf
            ElseIf mouse( )\y > mouse( )\delta\y And ( mouse( )\y > *this\y[#__c_inner] + *this\height[#__c_inner] )
              If *this\VisibleLastRow( ) And Not bar_in_stop_( *this\scroll\v\bar ) 
                ChangeCurrentElement( *this\_rows( ), *this\VisibleLastRow( ))
                *item = NextElement( *this\_rows( ) )
                
                If *item
                  row_scroll_y_( *this, *item )
                EndIf
              Else
                ; *item = *this\VisibleLastRow( )
              EndIf
            EndIf
            ;             Else
            ; ;               If mouse( )\drag
            ; ;                 If _DD_action_( EnteredWidget( ) )
            ;               *item = *this\FocusedRow( )
          EndIf
        Else
          If eventtype = #PB_EventType_MouseMove
            If *this\state\enter = #False
              *item = #Null
            EndIf
          EndIf
        EndIf
        
        ; change enter/leave state
        If *this\EnteredRow( ) <> *item ;And *item
          
          ; leave state
          If *this\EnteredRow( )
            If *this\EnteredRow( )\state\enter
              *this\EnteredRow( )\state\enter = #False
              
              If *this\EnteredRow( )\color\state = #__S_1 
                *this\EnteredRow( )\color\state = #__S_0
              EndIf
              
              If *this\state\drag > 0
                ;Debug "le - "
                
                If mouse_y > ( *this\EnteredRow( )\y + *this\EnteredRow( )\height / 2 )
                  If *this\EnteredRow( ) = *this\PressedRow( )
                    ;Debug " le bottom  set - Pressed  " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_last )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  ElseIf *this\EnteredRow( )\index < *this\PressedRow( )\index
                    ;Debug "  ^le top remove - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_remove )
                    edit_sel_text_( *this, SelectElement(*this\_rows(), *this\EnteredRow( )\index + 1))
                  Else
                    ;Debug " le bottom  set - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_set )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  EndIf
                Else
                  If *this\EnteredRow( ) = *this\PressedRow( )
                    ;Debug " le top remove - Pressed  " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_first )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  ElseIf *this\EnteredRow( )\index > *this\PressedRow( )\index 
                    ;Debug "  le top remove - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_remove )
                    edit_sel_text_( *this, SelectElement(*this\_rows(), *this\EnteredRow( )\index - 1))
                  Else
                    ;Debug " ^le bottom  set - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_set )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  EndIf
                EndIf
                
              EndIf
              
            EndIf
          EndIf
          
          ; Debug ""+*item+" "+*this\EnteredRow( )
          *this\LeavedRow( ) = *this\EnteredRow( )
          *this\EnteredRow( ) = *item
          
          If *this\EnteredRow( )
            ; enter state
            If *this\state\enter
              If *this\EnteredRow( )\state\enter = #False
                *this\EnteredRow( )\state\enter = #True
                
                If *this\EnteredRow( )\color\state = #__S_0
                  *this\EnteredRow( )\color\state = #__S_1
                EndIf
                
                If *this\state\drag > 0 
                  ; Debug "en - "
                  ;\\ edit_sel_pos( *this, *this\EnteredRow( ), *this\PressedRow( ), edit_caret_( *this ), - 1 )
                  *this\edit_caret_1( ) = edit_caret_( *this )
                  *this\FocusedRow( ) = *this\EnteredRow( )
                  edit_sel_row_text_( *this, *this\EnteredRow( ) )
                  edit_sel_text_( *this, *this\EnteredRow( ) )
                  
                Else
                  *this\state\repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
          
        Else
          If *this\state\drag > 0
            If *this\EnteredRow( ) And *this\PressedRow( ) And *this\FocusedRow( )
              ;\\ edit_sel_pos( *this, *this\EnteredRow( ), *this\PressedRow( ), edit_caret_( *this ) )
              Protected caret = edit_caret_( *this )
              If *this\edit_caret_1( ) <> caret
                *this\edit_caret_1( ) = caret
                ;# *this\FocusedRow( ) = *this\EnteredRow( )
                edit_sel_row_text_( *this, *this\EnteredRow( ) )
                edit_sel_text_( *this, *this\EnteredRow( ) )
              EndIf
              
            EndIf
          EndIf
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure DoEvent_Items( *this._S_widget, eventtype.l, mouse_x.l =- 1, mouse_y.l =- 1 )
      Protected repaint, *item._S_ROWS
      
      ;
      If *this\row
        If PressedWidget( ) And PressedWidget( )\state\press And (mouse( )\drag And mouse( )\drag\PrivateType) Or Not ( PressedWidget( )\row  )
          ;Debug "disable items redraw"
          ProcedureReturn 0
        EndIf
        
        ;
        If eventtype = #PB_EventType_Focus
          If *this\FocusedRow( ) 
            If *this\FocusedRow( )\state\focus
              *this\FocusedRow( )\color\state = #__S_2
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LostFocus
          If *this\FocusedRow( ) 
            If *this\FocusedRow( )\state\focus
              *this\FocusedRow( )\color\state = #__S_3
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown ; Ok
          If *this\EnteredRow( )
            *this\PressedRow( ) = *this\EnteredRow( )
            
            If *this\PressedRow( )\state\press = #False
              *this\PressedRow( )\state\press = #True
              
              *this\PressedRow( )\color\state = #__S_2
              *this\PressedRow( )\color\back[*this\PressedRow( )\color\state] = $FF2C70F5 ; TEMP
            EndIf
            
            If *this\FocusedRow( ) <> *this\EnteredRow( )
              If *this\FocusedRow( ) 
                If *this\FocusedRow( )\state\focus
                  *this\FocusedRow( )\state\focus = #False
                  *this\FocusedRow( )\color\state = #__S_0
                EndIf
              EndIf
              
              *this\FocusedRow( ) = *this\EnteredRow( )
              
              If *this\FocusedRow( )\state\focus = #False
                *this\FocusedRow( )\state\focus = #True
                ;Debug "status-change - focus - LeftButtonDown"
                ;DoEvents(*this, #PB_EventType_StatusChange, *this\FocusedRow( )\index, *this\FocusedRow( ))
                DoEvents(*this, #PB_EventType_Change, *this\FocusedRow( )\index, *this\FocusedRow( ))
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp ; Ok
          If *this\PressedRow( )
            If *this\PressedRow( )\state\press = #True
              *this\PressedRow( )\state\press = #False
              
              If *this\PressedRow( )\state\focus = #False
                If *this\PressedRow( )\state\enter
                  *this\PressedRow( )\color\state = #__S_1
                Else
                  *this\PressedRow( )\color\state = #__S_0
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; get at point items 
        If ListSize( *this\VisibleRows( ) ) 
          If Not ( *this\EnteredRow( ) And 
                   *this\EnteredRow( )\visible And 
                   *this\EnteredRow( )\hide = 0 And 
                   ( ( *this\state\enter And is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_y_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\VisibleRows( )) 
            Repeat                                 
              If *this\VisibleRows( )\visible And 
                 *this\VisibleRows( )\hide = 0 And 
                 ( ( *this\state\enter And is_at_point_( *this\VisibleRows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_y_( *this\VisibleRows( ), mouse_y )) )
                *item = *this\VisibleRows( ) 
                Break
              EndIf
            Until PreviousElement( *this\VisibleRows( )) = #False 
          Else
            *item = *this\EnteredRow( )
          EndIf
        ElseIf ListSize( *this\_rows( ) ) 
          If Not ( *this\EnteredRow( ) And 
                   *this\EnteredRow( )\visible And 
                   *this\EnteredRow( )\hide = 0 And 
                   ( ( *this\state\enter And is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_y_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\_rows( )) 
            Repeat                                 
              If *this\_rows( )\visible And 
                 *this\_rows( )\hide = 0 And 
                 ( ( *this\state\enter And is_at_point_( *this\_rows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_y_( *this\_rows( ), mouse_y )) )
                *item = *this\_rows( ) 
                Break
              EndIf
            Until PreviousElement( *this\_rows( )) = #False 
          Else
            *item = *this\EnteredRow( )
          EndIf
        EndIf
        
        ; 
        If *this\state\drag 
          If *item = #Null
            If mouse( )\y < mouse( )\delta\y And mouse( )\y <= *this\y[#__c_inner]
              If *this\VisibleFirstRow( ) And Not bar_in_start_( *this\scroll\v\bar ) 
                ChangeCurrentElement( *this\_rows( ), *this\VisibleFirstRow( ))
                *item = PreviousElement( *this\_rows( ) )
                
                If *item
                  row_scroll_y_( *this, *item )
                EndIf
              Else
                *item = *this\VisibleFirstRow( )
              EndIf
            ElseIf mouse( )\y > mouse( )\delta\y And ( mouse( )\y > *this\y[#__c_inner] + *this\height[#__c_inner] )
              If *this\VisibleLastRow( ) And Not bar_in_stop_( *this\scroll\v\bar ) 
                ChangeCurrentElement( *this\_rows( ), *this\VisibleLastRow( ))
                *item = NextElement( *this\_rows( ) )
                
                If *item
                  row_scroll_y_( *this, *item )
                EndIf
              Else
                *item = *this\VisibleLastRow( )
              EndIf
            EndIf
            ;             Else
            ; ;               If mouse( )\drag
            ; ;                 If _DD_action_( EnteredWidget( ) )
            ;               *item = *this\FocusedRow( )
          EndIf
        Else
          If eventtype = #PB_EventType_MouseMove
            If *this\state\enter = #False
              *item = #Null
            EndIf
          EndIf
        EndIf
        
        ; change enter/leave state
        If *this\EnteredRow( ) <> *item ;And *item
                                        ; lost-focus state
          If *this\state\drag > 0
            If *this\FocusedRow( )
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False 
                
                ;If *this\FocusedRow( )\state\press = #False
                *this\FocusedRow( )\color\state = #__S_0
                ;EndIf
              EndIf
            EndIf
          EndIf
          
          ; leave state
          If *this\EnteredRow( )
            If *this\EnteredRow( )\state\enter
              *this\EnteredRow( )\state\enter = #False
              
              If *this\EnteredRow( )\color\state = #__S_1 
                *this\EnteredRow( )\color\state = #__S_0
              EndIf
            EndIf
          EndIf
          
          ; Debug ""+*item+" "+*this\EnteredRow( )
          *this\LeavedRow( ) = *this\EnteredRow( )
          *this\EnteredRow( ) = *item
          If *this\state\drag > 0 
            *this\FocusedRow( ) = *item
          EndIf
          
          If *this\EnteredRow( )
            ; focus state
            If *this\state\drag > 0 
              If *this\FocusedRow( )
                If *this\FocusedRow( )\state\focus = #False
                  *this\FocusedRow( )\state\focus = #True
                  
                  ;If *this\FocusedRow( )\state\press = #False
                  *this\FocusedRow( )\color\state = #__S_2
                  ;EndIf
                  *this\FocusedRow( )\color\back[*this\FocusedRow( )\color\state] = $FF2C70F5 ; TEMP
                EndIf
              EndIf
            EndIf
            
            ; enter state
            If *this\state\enter
              If *this\EnteredRow( )\state\enter = #False
                If ( mouse_y - *this\EnteredRow( )\y ) > *this\EnteredRow( )\height / 2
                  *this\EnteredRow( )\state\enter = 1
                  *this\state\enter =- 1
                  ;Debug "-1 (+1)"
                Else
                  ;Debug "+1 (-1)"
                  *this\state\enter = 1
                  *this\EnteredRow( )\state\enter =- 1
                EndIf
                
                If *this\EnteredRow( )\color\state = #__S_0
                  *this\EnteredRow( )\color\state = #__S_1
                EndIf
                
                ; update non-focus status  
                If Not ( *this\LeavedRow( ) = #Null And *this\EnteredRow( ) = *this\FocusedRow( ))
                  DoEvents(*this, #PB_EventType_StatusChange, *this\EnteredRow( )\index, *this\EnteredRow( ))
                EndIf
              EndIf
            EndIf
          Else
            ; 
            If *this\FocusedRow( ) <> *this\LeavedRow( )
              If *this\FocusedRow( ) 
                DoEvents(*this, #PB_EventType_StatusChange, *this\FocusedRow( )\index, *this\FocusedRow( ))
              ElseIf *this\LeavedRow( ) 
                DoEvents(*this, #PB_EventType_StatusChange, *this\LeavedRow( )\index, *this\LeavedRow( ))
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_MouseEnter 
          If *this\FocusedRow( ) And 
             ( *this\EnteredRow( ) And *this\FocusedRow( ) <> *this\EnteredRow( ) ) = 0
            DoEvents(*this, #PB_EventType_StatusChange, *this\FocusedRow( )\index, *this\FocusedRow( ))
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure DoEvent_Tabs( *this._S_widget, eventtype.l, mouse_x.l =- 1, mouse_y.l =- 1 )
      Protected repaint, *tab._S_ROWS
      
      ;
      If *this\bar
        ; get at point items                            ; 
        If Not ( EnteredButton( ) And EnteredButton( )\state\disable = #False And EnteredButton( ) <> BB3( ) )
          If ListSize( *this\_tabs( ) )                 
            If Not ( *this\EnteredTab( ) And 
                     *this\EnteredTab( )\visible And 
                     *this\EnteredTab( )\hide = 0 And 
                     ( ( *this\state\enter And is_at_point_( *this\EnteredTab( ), mouse_x, mouse_y )) Or
                       ( *this\state\drag And is_at_point_y_( *this\EnteredTab( ), mouse_y )) ))
              
              ; search entered item
              LastElement( *this\_tabs( )) 
              Repeat                                 
                If *this\_tabs( )\visible And 
                   *this\_tabs( )\hide = 0 And 
                   ( ( *this\state\enter And is_at_point_( *this\_tabs( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_y_( *this\_tabs( ), mouse_y )) )
                  *tab = *this\_tabs( ) 
                  Break
                EndIf
              Until PreviousElement( *this\_tabs( )) = #False 
            Else
              *tab = *this\EnteredTab( )
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown
          ;If *tab
          *this\PressedTab( ) = *tab
          ;EndIf
          ;                                              ;
          If Not ( EnteredButton( ) And EnteredButton( )\state\press And EnteredButton( ) <> BB3( ) )
            If *this\PressedTab( )                         
              If *this\PressedTab( )\state\press = #False
                *this\PressedTab( )\state\press = #True
                
                *this\PressedTab( )\color\state = #__S_2
                *this\PressedTab( )\color\back[*this\PressedTab( )\color\state] = $FF2C70F5
                
                *this\state\repaint = #True
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          If *this\PressedTab( )
            If *this\PressedTab( )\state\press = #True
              *this\PressedTab( )\state\press = #False
              
              If *this\PressedTab( )\state\enter
                *this\PressedTab( )\color\state = #__S_1
              Else
                *this\PressedTab( )\color\state = #__S_0
              EndIf
              
              ; select new tab item if non-drag the item
              If Not *this\state\drag And 
                 Not *this\PressedTab( )\state\focus
                
                DoEvents( *this, #PB_EventType_StatusChange, *this\PressedTab( ), - 1 )
              EndIf
              
              *this\state\repaint = #True
            EndIf
          EndIf
        EndIf
        
        ; 
        If eventtype = #PB_EventType_MouseMove
          If *this\state\drag = #False 
            If *this\state\enter = #False
              *tab = #Null
            EndIf
          EndIf
        EndIf
        
        ; change enter/leave state
        If *this\EnteredTab( ) <> *tab ;And *tab
          If *this\EnteredTab( )
            If *this\EnteredTab( )\state\enter = #True
              *this\EnteredTab( )\state\enter = #False
              
              If *this\EnteredTab( )\color\state = #__S_1
                *this\EnteredTab( )\color\state = #__S_0
              EndIf
              ;EnteredTabindex( *this ) =- 1
            EndIf
            
            ;             If *this\state\drag 
            ;               If *this\PressedTab( )
            ;                 If *this\PressedTab( )\state\press = #True
            ;                   *this\PressedTab( )\state\press = #False
            ;                   
            ;                   *this\PressedTab( )\color\state = #__S_0
            ;                 EndIf
            ;               EndIf
            ;             EndIf
          EndIf
          
          ; Debug ""+*tab+" "+*this\EnteredTab( )
          *this\EnteredTab( ) = *tab
          ;           If *this\state\drag 
          ;             *this\PressedTab( ) = *tab
          ;           EndIf
          
          If *this\EnteredTab( )
            If *this\state\enter
              If *this\EnteredTab( )\state\enter = #False
                *this\EnteredTab( )\state\enter = #True
                
                If *this\EnteredTab( )\color\state = #__S_0
                  *this\EnteredTab( )\color\state = #__S_1
                EndIf
                ;EnteredTabindex( *this ) = *this\EnteredTab( )\index
                
              EndIf
            EndIf
            
            ;             If *this\state\drag 
            ;               If *this\PressedTab( )
            ;                 If *this\PressedTab( )\state\press = #False
            ;                   *this\PressedTab( )\state\press = #True
            ;                   
            ;                   *this\PressedTab( )\color\state = #__S_2
            ;                   *this\PressedTab( )\color\back[*this\PressedTab( )\color\state] = $FF2C70F5
            ;                 EndIf
            ;               EndIf
            ;             EndIf
          EndIf
          
          *this\state\repaint = #True
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure DoEvents( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      ;
      If Not *this\state\disable 
        ; repaint state 
        Select eventtype
          Case #PB_EventType_MouseWheelX
            Debug "wheelX "+ *data
          Case #PB_EventType_MouseWheelY
            Debug "wheelY "+ *data
            
          Case #PB_EventType_Drop
            *this\state\repaint = #True
            
            ;
            If a_transform( ) And a_transform( )\type : a_transform( )\type = 0
              mouse( )\drag\x = a_transform( )\id[0]\x - *this\x[#__c_inner]
              mouse( )\drag\y = a_transform( )\id[0]\y - *this\y[#__c_inner]
              mouse( )\drag\width = a_transform( )\id[0]\width 
              mouse( )\drag\height = a_transform( )\id[0]\height 
            Else
              mouse( )\drag\x = mouse( )\x - *this\x[#__c_inner]
              mouse( )\drag\y = mouse( )\y - *this\y[#__c_inner]
              mouse( )\drag\width = #PB_Ignore
              mouse( )\drag\height = #PB_Ignore
            EndIf
            
            ;      
            If *this\row And
               *this\EnteredRow( ) And 
               *this\EnteredRow( )\state\enter
              
              If *this\EnteredRow( )\state\enter < 0
                *button = *this\EnteredRow( )\index
                *data = mouse( )\x|mouse( )\y
              Else
                *button = *this\EnteredRow( )\index + 1
                *data = mouse( )\x|mouse( )\y 
              EndIf
            EndIf
            
          Case #PB_EventType_Focus
            If *this\color\state = #__s_3
              *this\color\state = #__s_2
            EndIf
            *this\state\repaint = #True
            
          Case #PB_EventType_LostFocus
            If *this\color\state = #__s_2
              *this\color\state = #__s_3
            EndIf
            *this\state\repaint = #True
            
          Case #PB_EventType_StatusChange
            If *this\row
              *this\state\repaint = #True
            EndIf
            
          Case #PB_EventType_CursorChange
            *this\state\repaint = #True
            
          Case #PB_EventType_MouseMove
            If *this\bar And *this\state\drag
              *this\state\repaint = #True
            EndIf
            
          Case #PB_EventType_MouseEnter,
               #PB_EventType_MouseLeave,
               #PB_EventType_LeftButtonDown,
               #PB_EventType_LeftButtonUp,
               #PB_EventType_KeyDown,
               #PB_EventType_KeyUp,
               #PB_EventType_Focus,
               #PB_EventType_LostFocus,
               #PB_EventType_ScrollChange,
               ;            ; #PB_EventType_Repaint,
               ;              #PB_EventType_Create,
               ;              #PB_EventType_Resize,
            #PB_EventType_DragStart
            
            
            *this\state\repaint = #True
        EndSelect
        
        ; items events
        Select eventtype
          Case #PB_EventType_MouseEnter,
               #PB_EventType_MouseLeave, 
               #PB_EventType_MouseMove,
               #PB_EventType_Focus, 
               #PB_EventType_LostFocus,
               #PB_EventType_LeftButtonDown, 
               #PB_EventType_LeftButtonUp 
            
            Protected mouse_x, mouse_y
            
            If *this\bar 
              mouse_x = mouse( )\x - BB3( )\x
              mouse_y = mouse( )\y - BB3( )\y
              DoEvent_BarButtons( *this, eventtype, mouse_x, mouse_y )
              DoEvent_Tabs( *this, eventtype, mouse_x, mouse_y )
              
            ElseIf *this\row
              mouse_x = mouse( )\x - *this\x[#__c_inner] ; - scroll_x_( *this ) 
              mouse_y = mouse( )\y - *this\y[#__c_inner] - scroll_y_( *this ) 
              
              If *this\type = #__type_Editor Or
                 *this\type = #__type_string
                
                DoEvent_Lines( *this, eventtype, mouse_x, mouse_y )
              Else
                DoEvent_Items( *this, eventtype, mouse_x, mouse_y )
              EndIf
              
              ;               If is_at_point_( *this, mouse_x - *this\x, mouse_y - *this\y, [#__c_required] )
              ;                 Debug 5555;*this\EnteredRow( )
              ;               EndIf
            EndIf
            
        EndSelect
        
        ; widgets events
        Select *this\type
          Case #__Type_Window
            Window_events( *this, eventtype, mouse_x, mouse_y )
            
          Case #__Type_Button
            Button_events( *this, eventtype, mouse_x, mouse_y )
            
          Case #__Type_Tree
            Tree_events( *this, eventtype, mouse_x, mouse_y )
            
          Case #__Type_HyperLink
            
          Case #__Type_Editor
            Editor_events( *this, eventtype, mouse( )\x, mouse( )\y )
            
          Case #__type_TabBar, 
               #__type_TrackBar,
               #__type_ScrollBar,
               #__type_Splitter,
               #__type_Spin,
               #__type_ToolBar, 
               #__type_ProgressBar
            
            If Bar_Events( *this, eventtype, *button, *data )
              *this\state\repaint = #True
            EndIf
        EndSelect
      EndIf
      
      ; widget::_events_Anchors( )
      If a_transform_( *this )
        If a_events( *this, eventtype, *button, *data)
          *this\state\repaint = #True
        EndIf
      EndIf    
      
      
      If Not *this\state\disable 
        ;
        Post( *this, eventtype, *button, *data ) 
        
        ; 
        If *this\state\repaint = #True
          *this\state\repaint = #False
          PostCanvasRepaint( *this )
        EndIf
      EndIf
    EndProcedure
    
    Procedure GetAtPoint( *root._S_ROOT, mouse_x, mouse_y )
      Protected i, Repaint, *widget._S_WIDGET
      Static *leave._s_widget
      
      ; get at point address
      If *root\count\childrens
        LastElement( *root\_widgets( )) 
        Repeat   
          If *root\_widgets( )\address And Not *root\_widgets( )\hide And 
             *root\_widgets( )\_root( )\canvas\gadget = *root\canvas\gadget And
             is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_frame] ) And 
             is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_draw] ) 
            
            ; get alpha
            If *root\_widgets( )\_a_\transform = 0 And (*root\_widgets( )\image[#__img_background]\id And
                                                        *root\_widgets( )\image[#__img_background]\depth > 31 And  
                                                        is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_inner] ) And
                                                        StartDrawing( ImageOutput( *root\_widgets( )\image[#__img_background]\img )))
              
              drawing_mode_( #PB_2DDrawing_AlphaChannel )
              If Not Alpha( Point( ( mouse( )\x - *root\_widgets( )\x[#__c_inner] ) - 1,
                                   ( mouse( )\y - *root\_widgets( )\y[#__c_inner] ) - 1 ) )
                StopDrawing( )
                Continue
              Else
                StopDrawing( )
              EndIf
            EndIf
            
            ; 
            If Popu_parent( ) And 
               is_at_point_( Popu_parent( ), mouse_x, mouse_y, [#__c_frame] ) And 
               is_at_point_( Popu_parent( ), mouse_x, mouse_y, [#__c_draw] ) 
              *widget = Popu_parent( )
            Else
              *widget = *root\_widgets( )
            EndIf
            
            ; is integral scroll bar's
            If *widget\scroll
              If *widget\scroll\v And Not *widget\scroll\v\hide And *widget\scroll\v\type And 
                 is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_frame] ) And
                 is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_draw] ) 
                *widget = *widget\scroll\v ; MouseState( *widget\scroll\v, *leave, mouse_x, mouse_y )
              EndIf
              If *widget\scroll\h And Not *widget\scroll\h\hide And *widget\scroll\h\type And
                 is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_frame] ) And 
                 is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_draw] ) 
                *widget = *widget\scroll\h ; MouseState( *widget\scroll\h, *leave, mouse_x, mouse_y )
              EndIf
            EndIf
            
            ; is integral tab bar
            If *widget\TabWidget( ) And Not *widget\TabWidget( )\hide And *widget\TabWidget( )\type And 
               is_at_point_( *widget\TabWidget( ), mouse_x, mouse_y, [#__c_frame] ) And
               is_at_point_( *widget\TabWidget( ), mouse_x, mouse_y, [#__c_draw] ) 
              *widget = *widget\TabWidget( ) ; MouseState( *widget\TabWidget( ), *leave, mouse_x, mouse_y )
            EndIf
            
            ; entered anchor widget
            If a_transform( ) 
              If a_at_point( *root\canvas\gadget, @*widget, @*leave )  
                *widget = a_enter_widget( )
              EndIf
            EndIf
            Break
          EndIf
        Until PreviousElement( *root\_widgets( )) = #False 
      EndIf
      
      ; root no enumWidget
      If *widget = 0 And
         is_at_point_( *root, mouse_x, mouse_y, [#__c_frame] ) And 
         is_at_point_( *root, mouse_x, mouse_y, [#__c_draw] ) 
        *widget = *root
      EndIf
      
      ; do events entered & leaved 
      If *leave <> *widget
        ;If Not ( *widget And is_integral_( *widget ) )
        EnteredWidget( ) = *widget
        ;EndIf
        
        ;
        If Not a_is_at_point_( *leave )
          If *leave And ;Not ( *widget And is_integral_( *widget ) ) And 
             *leave\state\enter <> #False 
            *leave\state\enter = #False
            repaint | DoEvents( *leave, #PB_EventType_MouseLeave )
            
            If Not is_interact_row_( *leave ) And Not a_transform_( *leave ) 
              If Not IsChild( *widget, *leave )
                ;
                DoEvents( *leave, #PB_EventType_StatusChange, #Null, - 1 )
                
                If *leave\address
                  ChangeCurrentElement( *leave\_widgets( ), *leave\address )
                  Repeat                 
                    If *leave\_widgets( )\count\childrens And *leave\_widgets( )\state\enter <> #False 
                      If is_at_point_( *leave\_widgets( ), mouse_x, mouse_y, [#__c_draw] ) 
                        If Not ( *widget And *widget\index > *leave\_widgets( )\index )
                          Break
                        EndIf
                      EndIf
                      
                      ;
                      If Not is_interact_row_( *leave\_widgets( ) ) And *leave\_widgets( )\_a_\transform And
                         IsChild( *leave, *leave\_widgets( )) And
                         Not IsChild( *widget, *leave\_widgets( ))
                        *leave\_widgets( )\state\enter = #False
                        DoEvents( *leave\_widgets( ), #PB_EventType_StatusChange, #Null, - 1 )
                      EndIf
                    EndIf
                  Until PreviousElement( *leave\_widgets( )) = #False 
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;
          If *widget And 
             *widget\state\enter <> #True
            *widget\state\enter = #True
            
            DoEvents( *widget, #PB_EventType_MouseEnter )
            DD_Cursor( *widget )
            
            If Not is_interact_row_( *widget ) And Not a_transform_( *widget )
              If *widget\address And Not *widget\attach 
                ForEach *widget\_widgets( ) 
                  If *widget\_widgets( ) = *widget
                    Break
                  EndIf
                  
                  If *widget\_widgets( )\state\enter = #False And a_transform_( *widget\_widgets( ) ) And 
                     *widget\_widgets( )\count\childrens And 
                     Not is_interact_row_( *widget\_widgets( ) ) And
                     IsChild( *widget, *widget\_widgets( ))
                    
                    *widget\_widgets( )\state\enter =- 1
                    DoEvents( *widget\_widgets( ), #PB_EventType_StatusChange, #Null, 1 )
                  EndIf
                Next
              EndIf
              
              DoEvents( *widget, #PB_EventType_StatusChange, #Null, 1 )
            EndIf
          EndIf
        EndIf
        
        ;If Not ( *widget And is_integral_( *widget ) )
        *leave = *widget
        ;EndIf
      EndIf  
      ; Debug ""+*leave +" "+ *widget
      
      ;         If a_is_at_point_( a_enter_widget( ) )
      ;           EnteredWidget( ) = a_enter_widget( )
      ;           Debug 888
      ;         EndIf
      ;         
      
    EndProcedure
    
    Procedure EventHandler( Canvas =- 1, EventType =- 1 )
      Protected Repaint, mouse_x , mouse_y 
      
      ;       If eventtype = #PB_EventType_Create
      ;         If IsGadget( Canvas ) And GadgetType( Canvas ) = #__Type_Canvas
      ;           ChangeCurrentRoot( GadgetID( Canvas ) )
      ;         EndIf
      ;       EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If Root( )
          If Root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( Root( )\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
            Root( )\canvas\ResizeBeginWidget = #Null
          EndIf
        EndIf   
      EndIf
      
      If eventtype = #PB_EventType_MouseEnter
        If IsGadget( Canvas ) And GadgetType( Canvas ) = #__Type_Canvas
          ChangeCurrentRoot( GadgetID( Canvas ) )
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_Repaint ; = 262150
        If IsGadget( Canvas ) And GadgetType( Canvas ) = #__Type_Canvas
          ChangeCurrentRoot( GadgetID( Canvas ) )
          
          ;
          If Root( )\canvas\repaint = #True
            
            If EventData() = #PB_EventType_Create
              If Root( )\canvas\ResizeBeginWidget
                ; Debug "   end - resize " + #PB_Compiler_Procedure
                Post( Root( )\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
                Root( )\canvas\ResizeBeginWidget = #Null
              EndIf
            EndIf
            
            ReDraw( Root( ) )
            Root( )\canvas\repaint = #False
          EndIf
          
          ; 
          If EnteredGadget( ) >= 0 And 
             EnteredGadget( ) <> Canvas
            ChangeCurrentRoot( GadgetID( EnteredGadget( ) ) )
          EndIf
        EndIf
        
        ;Debug "  event - "+EventType +" "+ Root( )\canvas\gadget +" "+ Canvas +" "+ EventData( )
      EndIf
      
      
      If eventtype = #PB_EventType_Input Or
         eventtype = #PB_EventType_KeyDown Or
         eventtype = #PB_EventType_KeyUp
        
        If FocusedWidget( )
          Keyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Modifiers )
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If Keyboard( )\key[1] & #PB_Canvas_Command
              Keyboard( )\key[1] &~ #PB_Canvas_Command
              Keyboard( )\key[1] | #PB_Canvas_Control
            EndIf
          CompilerEndIf
          
          If eventtype = #PB_EventType_Input 
            Keyboard( )\input = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Input )
          ElseIf ( eventtype = #PB_EventType_KeyDown Or
                   eventtype = #PB_EventType_KeyUp )
            Keyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Key )
          EndIf
          
          ; keyboard events
          Repaint | DoEvents( FocusedWidget( ), eventtype )
          
          ; change keyboard focus-widget
          If eventtype = #PB_EventType_KeyDown               And Not FocusedWidget( )\_a_\transform 
            Select Keyboard( )\Key
              Case #PB_Shortcut_Tab
                If FocusedWidget( )\after\widget And
                   FocusedWidget( ) <> FocusedWidget( )\after\widget
                  Repaint = SetActive( FocusedWidget( )\after\widget )
                ElseIf FocusedWidget( )\first\widget And
                       FocusedWidget( ) <> FocusedWidget( )\first\widget
                  Repaint = SetActive( FocusedWidget( )\first\widget )
                ElseIf FocusedWidget( ) <> FocusedWidget( )\_root( )\first\widget
                  Repaint = SetActive( FocusedWidget( )\_root( )\first\widget )
                EndIf
            EndSelect
          EndIf
        EndIf
      EndIf  
      
      If Root( ) And Root( )\canvas\gadget = Canvas 
        Select eventtype
          Case #PB_EventType_Resize ;: PB(ResizeGadget)( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            Resize( Root( ), 0, 0, PB(GadgetWidth)( Canvas ), PB(GadgetHeight)( Canvas ) )  
            ;PostCanvasRepaint( Root( ) )
            ReDraw( Root( ) ) 
            Repaint = 1
            
          Case #PB_EventType_MouseEnter,
               #PB_EventType_MouseLeave,
               #PB_EventType_MouseMove
            
            mouse_x = CanvasMouseX( Root( )\canvas\gadget )
            mouse_y = CanvasMouseY( Root( )\canvas\gadget )
            
            If eventtype = #PB_EventType_MouseEnter
              mouse( )\change = 1<<0
              mouse( )\x = mouse_x
              mouse( )\y = mouse_y
            EndIf
            If eventtype = #PB_EventType_MouseLeave
              mouse( )\change =- 1
              mouse( )\x = mouse_x
              mouse( )\y = mouse_y
            EndIf
            If eventtype = #PB_EventType_MouseMove
              If mouse( )\x <> mouse_x
                mouse( )\x = mouse_x
                mouse( )\change | 1<<1
              EndIf
              If mouse( )\y <> mouse_y
                mouse( )\y = mouse_y
                mouse( )\change | 1<<2
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonDown,
               #PB_EventType_RightButtonDown,
               #PB_EventType_MiddleButtonDown
            
            mouse( )\change = 1<<3
            
            If eventtype = #PB_EventType_LeftButtonDown
              mouse( )\buttons | #PB_Canvas_LeftButton
            EndIf 
            If eventtype = #PB_EventType_RightButtonDown
              mouse( )\buttons | #PB_Canvas_RightButton
            EndIf  
            If eventtype = #PB_EventType_MiddleButtonDown
              mouse( )\buttons | #PB_Canvas_MiddleButton
            EndIf 
            
          Case #PB_EventType_LeftButtonUp, 
               #PB_EventType_RightButtonUp,
               #PB_EventType_MiddleButtonUp
            
            mouse( )\change = 1<<4
            
        EndSelect
        
        
        ; get enter&leave widget address
        If mouse( )\change
          If eventtype = #PB_EventType_MouseLeave
            mouse_x =- 1
            mouse_y =- 1
          Else 
            mouse_x = mouse( )\x
            mouse_y = mouse( )\y
          EndIf
          
          ; enter&leave mouse events
          GetAtPoint( Root( ), mouse_x, mouse_y )
          
          
          
          
          ; ;             Protected i, *widget._S_WIDGET, *root._S_root = Root( )
          ; ;             Static *leave._s_widget
          ; ;             
          ; ;             ; get at point address
          ; ;             If *root\count\childrens
          ; ;               LastElement( *root\_widgets( )) 
          ; ;               Repeat   
          ; ;                 If *root\_widgets( )\address And Not *root\_widgets( )\hide And 
          ; ;                    *root\_widgets( )\_root( )\canvas\gadget = *root\canvas\gadget And
          ; ;                    is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_frame] ) And 
          ; ;                    is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_draw] ) 
          ; ;                   
          ; ;                   ;                   ; enter-widget mouse pos
          ; ;                   ;                   If is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_inner] )
          ; ;                   ;                     ; get alpha
          ; ;                   ;                     If *root\_widgets( )\image[#__img_background]\id And
          ; ;                   ;                        *root\_widgets( )\image[#__img_background]\depth > 31 And 
          ; ;                   ;                        StartDrawing( ImageOutput( *root\_widgets( )\image[#__img_background]\img ) )
          ; ;                   ;                       
          ; ;                   ;                       drawing_mode_( #PB_2DDrawing_AlphaChannel )
          ; ;                   ;                       
          ; ;                   ;                       If Not Alpha( Point( ( mouse( )\x - *root\_widgets( )\x[#__c_inner] ) - 1, ( mouse( )\y - *root\_widgets( )\y[#__c_inner] ) - 1 ) )
          ; ;                   ;                         StopDrawing( )
          ; ;                   ;                         Continue
          ; ;                   ;                       EndIf
          ; ;                   ;                       
          ; ;                   ;                       StopDrawing( )
          ; ;                   ;                     EndIf
          ; ;                   ;                   EndIf
          ; ;                   
          ; ;                   ;
          ; ;                   If Popu_parent( ) And 
          ; ;                      is_at_point_( Popu_parent( ), mouse_x, mouse_y, [#__c_frame] ) And 
          ; ;                      is_at_point_( Popu_parent( ), mouse_x, mouse_y, [#__c_draw] ) 
          ; ;                     *widget = Popu_parent( )
          ; ;                   Else
          ; ;                     *widget = *root\_widgets( )
          ; ;                   EndIf
          ; ;                   
          ; ;                   ; is integral scroll bars
          ; ;                   If *widget\scroll
          ; ;                     If *widget\scroll\v And Not *widget\scroll\v\hide And *widget\scroll\v\type And 
          ; ;                        is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_frame] ) And
          ; ;                        is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_draw] ) 
          ; ;                       *widget = *widget\scroll\v ; MouseState( *widget\scroll\v, *leave, mouse_x, mouse_y )
          ; ;                     EndIf
          ; ;                     If *widget\scroll\h And Not *widget\scroll\h\hide And *widget\scroll\h\type And
          ; ;                        is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_frame] ) And 
          ; ;                        is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_draw] ) 
          ; ;                       *widget = *widget\scroll\h ; MouseState( *widget\scroll\h, *leave, mouse_x, mouse_y )
          ; ;                     EndIf
          ; ;                   EndIf
          ; ;                   
          ; ;                   ; is integral tab bar
          ; ;                   If *widget\TabWidget( ) And Not *widget\TabWidget( )\hide And *widget\TabWidget( )\type And 
          ; ;                      is_at_point_( *widget\TabWidget( ), mouse_x, mouse_y, [#__c_frame] ) And
          ; ;                      is_at_point_( *widget\TabWidget( ), mouse_x, mouse_y, [#__c_draw] ) 
          ; ;                     *widget = *widget\TabWidget( ) ; MouseState( *widget\TabWidget( ), *leave, mouse_x, mouse_y )
          ; ;                   EndIf
          ; ;                   
          ; ;                   ; entered anchor widget
          ; ;                   If a_transform( ) 
          ; ;                     If a_at_point( *root\canvas\gadget, @*widget, @*leave )  
          ; ;                       *widget = a_enter_widget( )
          ; ;                     EndIf
          ; ;                   EndIf
          ; ;                   Break
          ; ;                 EndIf
          ; ;               Until PreviousElement( *root\_widgets( )) = #False 
          ; ;               
          ; ;               ; do events entered & leaved 
          ; ;               MouseState( *widget, *leave, mouse_x, mouse_y )
          ; ;               
          ; ;               ;
          ; ;               If a_transform( ) 
          ; ;                 If eventtype = #PB_EventType_LeftButtonDown
          ; ;                   If a_is_at_point_( a_enter_widget( ) )
          ; ;                     EnteredWidget( ) = a_enter_widget( )
          ; ;                     ; Debug 888
          ; ;                   EndIf
          ; ;                 EndIf
          ; ;               EndIf
          ; ;             EndIf
          
          ;                         If eventtype = #PB_EventType_MouseEnter 
          ;                           Debug "e " + Root( )\text\string +" "+ EnteredWidget( )
          ;                         EndIf
          ;                         
          ;                         If eventtype = #PB_EventType_MouseLeave
          ;                           Debug "l " + Root( )\text\string +" "+ EnteredWidget( )
          ;                         EndIf
          
        EndIf
        
        
        ; do events all
        If eventtype = #PB_EventType_Focus
          If FocusedWidget( )
            Debug "canvas - Focus " +FocusedWidget( ) +" "+  GadgetType(Canvas)
            DoEvents( FocusedWidget( ), #PB_EventType_Focus );, PressedItem( ) )
          EndIf
          ;           If FocusedWidget( )                          And Not FocusedWidget( )\_a_\transform ; a_transform_( *leave )
          ;             Repaint | SetActive( FocusedWidget( ) ) 
          ;           Else
          ;             If GetActive( ) 
          ;               If GetActive( )\gadget                 And Not GetActive( )\gadget\_a_\transform 
          ;                 Repaint | SetActive( GetActive( )\gadget ) 
          ;               ElseIf                                     Not GetActive( )\_a_\transform 
          ;                 Repaint | SetActive( GetActive( ) ) 
          ;               EndIf
          ;             Else
          ;               If EnteredWidget( )                      And Not EnteredWidget( )\_a_\transform
          ;                 Repaint = SetActive( EnteredWidget( )) 
          ;               EndIf
          ;             EndIf
          ;           EndIf
          ;           
        ElseIf eventtype = #PB_EventType_LostFocus
          If FocusedWidget( )
            Debug "canvas - LostFocus " +FocusedWidget( ) +" "+  GadgetType(Canvas)
            DoEvents( FocusedWidget( ), #PB_EventType_LostFocus )
          EndIf
          
        ElseIf eventtype = #PB_EventType_MouseEnter 
        ElseIf eventtype = #PB_EventType_MouseLeave 
        ElseIf eventtype = #PB_EventType_MouseMove 
          
          If mouse( )\change > 1
            ; mouse entered-widget move event
            If EnteredWidget( ) And EnteredWidget( )\state\enter
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseMove )
            EndIf
            
            If PressedWidget( )
              If PressedWidget( )\state\press And 
                 PressedWidget( )\_root( ) <> Root( )
                mouse( )\x = CanvasMouseX( PressedWidget( )\_root( )\canvas\gadget )
                mouse( )\y = CanvasMouseY( PressedWidget( )\_root( )\canvas\gadget )
              EndIf
              
              ; mouse drag start
              If PressedWidget( ) And
                 PressedWidget( )\state\press = #True And
                 PressedWidget( )\state\drag = #False 
                PressedWidget( )\state\drag = #True
                
                DoEvents( PressedWidget( ), #PB_EventType_DragStart);, PressedItem( ) )
              EndIf
              
              ; mouse pressed-widget move event
              If EnteredWidget( ) <> PressedWidget( )  
                If PressedWidget( ) And PressedWidget( )\state\drag
                  Repaint | DoEvents( PressedWidget( ), #PB_EventType_MouseMove )
                EndIf
              EndIf
              
              ;               If PressedWidget( )\state\drag
              ;                 If Cursor::UpdateCursor( PressedWidget( )\_root( )\canvas\gadget )
              ;                   ; Debug "cursor-update "+ mouse()\cursor +" "+ *this\_root( )\canvas\gadget
              ;                 EndIf
              ;               EndIf
            EndIf
            
            mouse( )\change = 0
          EndIf
          
        ElseIf eventtype = #PB_EventType_LeftButtonDown Or
               eventtype = #PB_EventType_MiddleButtonDown Or
               eventtype = #PB_EventType_RightButtonDown
          
          ;
          If EnteredWidget( )
            PressedWidget( ) = EnteredWidget( )
            ;PressedRow( EnteredWidget( ) ) = EnteredWidget( )\EnteredRow( )
            
            EnteredWidget( )\state\press = #True
            ;If Not EnteredWidget( )\time_down
            ;EndIf
            ; Debug ""+ EnteredWidget( )\class +" "+ EventGadget( ) + " #PB_EventType_LeftButtonDown" 
            
            If ( eventtype = #PB_EventType_LeftButtonDown Or
                 eventtype = #PB_EventType_RightButtonDown ) 
              
              
              ; disabled mouse behavior
              If EnteredWidget( )\_a_\transform Or EnteredButton( ) > 0
                ; mouse( )\interact = #False
              EndIf
              
              ;If Not EnteredWidget( )\_a_\transform 
              If EnteredButton( ) > 0 And EnteredWidget( )\bar
                ; bar mouse delta pos
                ;; Debug "   bar delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                ;If EnteredButton( ) = EnteredWidget( )\bar\button[#__b_3] ; EnteredButton( )\index = #__b_3
                mouse( )\delta\x = mouse( )\x - EnteredWidget( )\bar\thumb\pos
                mouse( )\delta\y = mouse( )\y - EnteredWidget( )\bar\thumb\pos
                ;EndIf
              Else
                ;; Debug "  widget delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                mouse( )\delta\x = mouse( )\x - EnteredWidget( )\x[#__c_container]
                mouse( )\delta\y = mouse( )\y - EnteredWidget( )\y[#__c_container]
                
                If Not is_integral_( EnteredWidget( )) And EnteredWidget( )\_parent( )
                  mouse( )\delta\x - scroll_x_( EnteredWidget( )\_parent( ) )
                  mouse( )\delta\y - scroll_y_( EnteredWidget( )\_parent( ) )
                EndIf
              EndIf
              ;EndIf
            EndIf
            
            ; set active widget
            If eventtype = #PB_EventType_LeftButtonDown
              If EnteredWidget( ) <> FocusedWidget( ) 
                SetActive( EnteredWidget( ))
              EndIf
            EndIf
            
            Repaint | DoEvents( EnteredWidget( ), eventtype )
            
          EndIf
          
          
        ElseIf eventtype = #PB_EventType_LeftButtonUp Or 
               eventtype = #PB_EventType_MiddleButtonUp Or
               eventtype = #PB_EventType_RightButtonUp
          
          If PressedWidget( ) 
            
            ; do drop events
            If PressedWidget( )\state\drag <> #False
              
              ; drag & drop stop 
              If mouse( )\drag
                ; drag
                If EnteredWidget( ) <> PressedWidget( )  
                  If _DD_action_( PressedWidget( ) )
                    ;
                    DoEvents( PressedWidget( ), #PB_EventType_Drop, - 1, mouse_x|mouse_y )
                    
                    ; then drop if create new widget 
                    If PressedWidget( ) <> Widget()
                      ; ReDraw(Root())
                      Reclip(Widget())
                      GetAtPoint(Root(), mouse()\x, mouse()\y)
                    EndIf
                  EndIf
                EndIf
                
                ; drop
                If EnteredWidget( )  
                  If _DD_action_( EnteredWidget( ) )
                    ;
                    DoEvents( EnteredWidget( ), #PB_EventType_Drop, - 1, mouse_x|mouse_y )
                    
                    ; then drop if create new widget 
                    If EnteredWidget( ) <> Widget()
                      ; ReDraw(Root())
                      Reclip(Widget())
                      GetAtPoint(Root(), mouse()\x, mouse()\y)
                    EndIf
                  EndIf
                EndIf
                
                ; reset 
                FreeStructure( mouse( )\drag) : mouse( )\drag = #Null
                
                ; reset dragged cursor
                SetCursor( Root( ), #PB_Cursor_Default )
              EndIf
            EndIf
            
            ; do up events
            Repaint | DoEvents( PressedWidget( ), #PB_EventType_LeftButtonUp )
            
            ; do click events
            If EnteredWidget( ) And 
               PressedWidget( )\state\drag = 0 And 
               PressedWidget( ) = EnteredWidget( )
              
              If PressedWidget( )\time_click And
                 DoubleClickTime( ) > ElapsedMilliseconds( ) - PressedWidget( )\time_click
                
                ; do double-click events 
                If eventtype = #__event_LeftButtonUp
                  Repaint | DoEvents( PressedWidget( ), #__event_LeftDoubleClick )
                EndIf
                If eventtype = #__event_RightButtonUp
                  Repaint | DoEvents( PressedWidget( ), #__event_RightDoubleClick )
                EndIf
                
                PressedWidget( )\time_click = 0
              Else
                PressedWidget( )\time_click = ElapsedMilliseconds( )
                
                ; do click events
                If eventtype = #__event_LeftButtonUp
                  Repaint | DoEvents( PressedWidget( ), #__event_LeftClick )
                EndIf
                If eventtype = #__event_RightButtonUp
                  Repaint | DoEvents( PressedWidget( ), #__event_RightClick )
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          ; reset mouse buttons
          If mouse( )\buttons
            If eventtype = #PB_EventType_LeftButtonUp
              mouse( )\buttons &~ #PB_Canvas_LeftButton
            ElseIf eventtype = #PB_EventType_RightButtonUp
              mouse( )\buttons &~ #PB_Canvas_RightButton
            ElseIf eventtype = #PB_EventType_MiddleButtonUp
              mouse( )\buttons &~ #PB_Canvas_MiddleButton
            EndIf
            
            mouse( )\delta\x = 0
            mouse( )\delta\y = 0
          EndIf
          
          If PressedWidget( ) 
            PressedWidget( )\state\press = #False 
            PressedWidget( )\state\drag = #False
          EndIf  
          
        ElseIf eventtype = #PB_EventType_MouseWheelX
          Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelX, - 1, EventData( ) )
        ElseIf eventtype = #PB_EventType_MouseWheelY
          Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelY, - 1, EventData( ) )
          
        ElseIf eventtype = #PB_EventType_MouseWheel
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
            If EnteredWidget( )
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
              
              ; mouse wheel events
              If mouse( )\wheel\y
                Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelY, - 1, mouse( )\wheel\y )
                mouse( )\wheel\y = 0
              ElseIf mouse( )\wheel\x
                Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelX, - 1, mouse( )\wheel\x )
                mouse( )\wheel\x = 0
              EndIf
            EndIf
          CompilerEndIf
          
        ElseIf eventtype = #PB_EventType_LeftClick 
          If EnteredWidget( ) And 
             EnteredWidget( ) = PressedWidget( )
            ; Repaint | DoEvents( PressedWidget( ), eventtype )
          EndIf      
          
        ElseIf eventtype = #PB_EventType_LeftDoubleClick 
          If PressedWidget( )
            ;Repaint | DoEvents( PressedWidget( ), eventtype )
          EndIf
          
        ElseIf eventtype = #PB_EventType_Drop
          ;           If EnteredWidget( )
          ;             Repaint | DoEvents( EnteredWidget( ), eventtype )
          ;           EndIf
          
        ElseIf eventtype = #PB_EventType_RightClick 
        ElseIf eventtype = #PB_EventType_DragStart 
        ElseIf eventtype = #PB_EventType_RightDoubleClick 
        ElseIf eventtype = #PB_EventType_Change 
        ElseIf eventtype = #PB_EventType_Resize 
        ElseIf eventtype = #PB_EventType_Repaint 
        ElseIf eventtype = #PB_EventType_Input Or
               eventtype = #PB_EventType_KeyDown Or
               eventtype = #PB_EventType_KeyUp
          
        ElseIf eventtype =- 1        
        Else     
          If eventtype <> #PB_EventType_MouseMove
            mouse( )\change | 1<<0|1<<1
          EndIf
          Debug  #PB_Compiler_Procedure + " - else eventtype - "+eventtype
          
          If EnteredWidget( ) And mouse( )\change
            Repaint | DoEvents( EnteredWidget( ), eventtype )
          EndIf
          If FocusedWidget( ) And EnteredWidget( ) <> FocusedWidget( ) And FocusedWidget( )\state\press And mouse( )\change 
            Repaint | DoEvents( FocusedWidget( ), eventtype )
          EndIf
        EndIf
        
        ; reset
        If mouse( )\change <> #False
          mouse( )\change = #False
        EndIf
        
        If ListSize( Root( )\_events( ) )
          ;Debug ListSize( Root( )\_events( ) )
          ForEach Root( )\_events( )
            ;If Root( )\_events( )\type = #PB_EventType_LeftClick 
            ; Debug 333
            If Root( )\_events( )\type <> #PB_EventType_MouseMove
              ; Debug "" +Root( )\_events( )\type +" "+ Root( )\_events( )\id +" "+ ClassFromEvent( Root( )\_events( )\type )
            EndIf
            
            ;_DoEvents( Root( )\_events( )\id, Root( )\_events( )\type, Root( )\_events( )\item, Root( )\_events( )\data )
            Post( Root( )\_events( )\id, Root( )\_events( )\type, Root( )\_events( )\item, Root( )\_events( )\data )
            ;EndIf
          Next
          
          ; Debug ""
          ClearList( Root( )\_events( ) )
        EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = GetWindowData( EventWindow( ))
      
      ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
      ; PB(ResizeGadget)( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
    EndProcedure
    
    
    
    ;-
    Procedure.i CloseList( )
      Protected *open._s_WIDGET
      ; Debug "close - "+OpenedWidget( )\index;text\string
      
      If OpenedWidget( ) And 
         OpenedWidget( )\_parent( ) And
         OpenedWidget( )\_root( )\canvas\gadget = Root( )\canvas\gadget 
        
        If OpenedWidget( )\ClosedWidget( ) 
          *open = OpenedWidget( )\ClosedWidget( )
          OpenedWidget( )\ClosedWidget( ) = #Null
        Else
          If OpenedWidget( )\_parent( )\type = #__type_MDI
            *open = OpenedWidget( )\_parent( )\_parent( ) 
          Else
            If OpenedWidget( ) = OpenedWidget( )\_root( )
              *open = OpenedWidget( )\_root( )\before\root 
            Else
              *open = OpenedWidget( )\_parent( )
            EndIf
          EndIf
        EndIf
      Else
        *open = Root( ) 
      EndIf
      
      If *open And OpenedWidget( ) <> *open 
        OpenedWidget( ) = *open
        OpenList( OpenedWidget( ) )
      EndIf
    EndProcedure
    
    Procedure.i OpenList( *this._S_widget, item.l = 0 )
      Protected result.i = OpenedWidget( )
      
      If *this = OpenedWidget( )
        ProcedureReturn result
      EndIf
      
      If *this
        ;Debug "open - "+*this\index;text\string
        If *this\_parent( ) <> OpenedWidget( )
          *this\ClosedWidget( ) = OpenedWidget( )
          ;  Debug ""
        EndIf
        
        If *this\_root( ) <> Root( )
          If OpenedWidget( )\_root( )
            OpenedWidget( )\_root( )\after\root = *this\_root( )
          EndIf
          *this\_root( )\before\root = OpenedWidget( )\_root( )
          
          If *this = *this\_root( ) 
            ChangeCurrentRoot(*this\_root( )\canvas\address )
          EndIf
        EndIf
        
        ; 
        If *this\TabWidget( ) 
          *this\TabWidget( )\OpenedTabIndex( ) = item
        EndIf
        
        OpenedWidget( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g, UseGadgetList, result
      
      
      ; init 
      If Not MapSize(Root( ))
        events::SetCallback( @EventHandler( ) )
      Else
        If Root( )
          If Root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( Root( )\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
            Root( )\canvas\ResizeBeginWidget = #Null
          EndIf
        EndIf
      EndIf
      
      If width = #PB_Ignore And height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If PB(IsWindow)(Window) = 0
        w = OpenWindow( Window, x,y,width,height, title$, flag ) 
        If Window =- 1 : Window = w : w = WindowID( Window ) : EndIf
        x = 0
        y = 0
        flag | #PB_Canvas_Container
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
      
      ; get a handle from the previous usage list
      w = WindowID( Window )
      If w
        UseGadgetList = UseGadgetList( w )
      EndIf
      
      ;
      If PB(IsGadget)(Canvas)
        g = GadgetID( Canvas )
      Else
        g = CanvasGadget( Canvas, x, y, width, height, Flag | #PB_Canvas_Keyboard ) 
        If Canvas =- 1 : Canvas = g : g = GadgetID( Canvas ) : EndIf
      EndIf
      
      ; 
      If UseGadgetList
        UseGadgetList( UseGadgetList )
      EndIf
      
      ;
      If Not ChangeCurrentRoot(g) 
        result = AddMapElement( Root( ), Str( g ) )
        Root( ) = AllocateStructure( _S_root )
        Root( )\type = #__Type_Container
        Root( )\container = #__Type_Container
        
        Root( )\class = "Root"
        Root( )\_root( ) = Root( )
        Root( )\_window( ) = Root( )
        
        Root( )\fs = Bool( flag & #__flag_BorderLess = 0 )
        Root( )\bs = Root( )\fs
        
        Root( )\color = _get_colors_( )
        Root( )\text\fontID = PB_( GetGadgetFont )( #PB_Default )
        
        ;
        Root( )\canvas\window = Window
        Root( )\canvas\gadget = Canvas
        Root( )\canvas\address = g
        
        ;; AddWidget( Root( ), Root( ) )
        ; SetParent( Root( ), Root( ), #PB_Default )
        
        If flag & #PB_Window_NoGadgets = #False
          If OpenedWidget( )
            OpenedWidget( )\after\root = Root( )
          EndIf
          Root( )\before\root = OpenedWidget( ) 
          
          OpenedWidget( ) = Root( )
          ; OpenList( Root( ))
        EndIf
        
        If flag & #PB_Window_NoActivate = #False
          ; Root( )\state\focus = #True
          FocusedWidget( ) = Root( )
          ; SetActive( Root( ))
        EndIf 
        
        Resize( Root( ), #PB_Ignore,#PB_Ignore,width,height ) ;??
        
        ; post repaint canvas event
        PostCanvasRepaint( Root( ), #PB_EventType_Create)
        
        ; BindGadgetEvent( Canvas, @EventCanvas( ))
      EndIf
      
      If g
        SetWindowData( Window, Canvas )
        
        If flag & #PB_Canvas_Container = #PB_Canvas_Container
          BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window );, Canvas )
        EndIf
        
        ; z - order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( g, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE | #SWP_NOSIZE )
        CompilerEndIf
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ; CocoaMessage(0, g, "setBoxType:", #NSBoxCustom)
          ; CocoaMessage(0, g, "setBorderType:", #NSLineBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSGrooveBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSBezelBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSNoBorder)
          
          
          ; CocoaMessage(0, GadgetID(0), "setFillColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          ; CocoaMessage(0, WindowID(w), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          
        CompilerEndIf
      EndIf
      
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
      ;                  #PB_Compiler_OS = #PB_OS_Windows
      If Drawing( )
        StopDrawing( )
      EndIf
      
      Drawing( ) = StartDrawing( CanvasOutput( Root( )\canvas\gadget ))
      
      If Drawing( )
        draw_font_( Root( ) )
        ; difference in system behavior
        If Root( )\canvas\fontID
          DrawingFont( Root( )\canvas\fontID ) 
        EndIf
        
        
        ; StopDrawing()
      EndIf
      ;       CompilerEndIf
      
      ProcedureReturn Root( )
    EndProcedure
    
    Procedure.i Window( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, *parent._S_widget = 0 )
      Protected *this.allocate( Widget ) 
      
      With *this
        Static pos_x.l, pos_y.l
        
        *this\type = #__type_window
        *this\class = #PB_Compiler_Procedure
        *this\flag = Flag
        
        
        *this\caption\round = 4
        *this\caption\_padding = *this\caption\round
        *this\caption\color = _get_colors_( )
        
        ;\caption\hide = constants::_check_( flag, #__flag_borderless )
        *this\caption\hide = constants::_check_( *this\flag, #__Window_titleBar, #False )
        *this\caption\button[#__wb_close]\hide = constants::_check_( *this\flag, #__Window_SystemMenu, #False )
        *this\caption\button[#__wb_maxi]\hide = constants::_check_( *this\flag, #__Window_MaximizeGadget, #False )
        *this\caption\button[#__wb_mini]\hide = constants::_check_( *this\flag, #__Window_MinimizeGadget, #False )
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
          *this\barHeight = constants::_check_( *this\flag, #__flag_borderless, #False ) * ( #__window_caption_height ); + #__window_frame_size )
          *this\round = 7
          
          *this\caption\text\padding\x = 5
          *this\caption\text\string = Text
        EndIf
        
        *this\child = Bool( *this\Flag & #__window_child = #__window_child )
        *this\fs = constants::_check_( *this\flag, #__flag_borderless, #False ) * #__window_frame_size
        
        
        If x = #PB_Ignore : If a_transform( ) : x = pos_x + a_transform( )\grid\size : Else : x = pos_x : EndIf : EndIf : pos_x = x + #__window_frame_size
        If y = #PB_Ignore : If a_transform( ) : y = pos_y + a_transform( )\grid\size : Else : y = pos_y : EndIf : EndIf : pos_y = y + #__window_frame_size + #__window_caption_height
        
        ; open root list
        If Not MapSize( Root( ))
          Protected PB_Flag
          If Flag & #PB_Window_ScreenCentered = #PB_Window_ScreenCentered
            PB_Flag | #PB_Window_ScreenCentered
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              PB_Flag | #PB_Window_SystemMenu
            CompilerElse
              PB_Flag | #PB_Window_BorderLess
            CompilerEndIf
          EndIf
          Protected Root = Open( OpenWindow( #PB_Any, x,y,width + *this\fs*2,height + *this\fs*2 + *this\barHeight, "", PB_Flag, *parent ))
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            ;             If CocoaMessage(0, WindowID(Root( )\canvas\window), "hasShadow") = 0
            ;               CocoaMessage(0, WindowID(Root( )\canvas\window), "setHasShadow:", 1)
            ;             EndIf
            ; CocoaMessage(0, WindowID(Root( )\canvas\window), "styleMask") ; get 
            CocoaMessage(0, WindowID(Root( )\canvas\window), "setStyleMask:", #NSMiniaturizableWindowMask|#NSResizableWindowMask)
          CompilerEndIf
          
          Flag | #__flag_autosize
          x = 0
          y = 0
          Root( )\width[#__c_inner] = width
          Root( )\height[#__c_inner] = height
        EndIf
        
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        
        *this\container = *this\type
        
        *this\color = _get_colors_( )
        *this\color\back = $FFF9F9F9
        
        ; Background image
        *this\image\img =- 1
        
        If Root
          Root( )\canvas\container = *this
        EndIf
        
        If Not *parent
          ;*parent = Root( )
        EndIf
        ;Debug *parent
        ;
        If *parent
          If Root( ) = *parent 
            Root( )\_parent( ) = *this
          EndIf
          
          If *this\child 
            ; AddWidget( *this, *parent )
            SetParent( *this, *parent, #PB_Default )
          EndIf
        Else
          If Root( )\canvas\container > 1
            *parent = Root( );\canvas\container 
          Else
            *parent = Root( )
          EndIf
        EndIf
        
        If *parent 
          
          If *this\child = 0 And 
             SetAttachment( *this, *parent, 0 )
            x - *parent\x[#__c_container] - (*parent\fs + (*parent\fs[1] + *parent\fs[3]))
            y - *parent\y[#__c_container] - (*parent\fs + (*parent\fs[2] + *parent\fs[4]))
          EndIf
        EndIf
        
        ;
        set_align_flag_( *this, *parent, *this\flag )
        Resize( *this, x,y,width,height )
        
        If *this\flag & #__Window_NoGadgets = #False
          OpenList( *this )
        EndIf
        
        If *this\flag & #__Window_NoActivate = #False
          SetActive( *this )
        EndIf 
        
        PostCanvasRepaint( Root( ), #PB_EventType_Create)
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
        Gadget = GetGadget( Root( ))
        g = Gadget
      Else
        g = GadgetID( Gadget )
      EndIf
      
      EnteredWidget( ) = *this
      
      ProcedureReturn g
    EndProcedure
    
    Procedure   a_object( x.l,y.l,width.l,height.l, text.s, Color.l, flag.i=#Null, framesize=1  )
      Protected *this._S_widget
      If Not Alpha(Color)
        Color = Color&$FFFFFF | 255<<24
      EndIf
      
      *this._S_widget = Container(x,y,width,height, #__flag_nogadgets) 
      If text
        SetText( *this, text)
      EndIf
      
      SetFrame( *this, framesize)
      
      SetColor( *this, #__color_back, Color)
      SetColor( *this, #__color_frame, Color&$FFFFFF | 255<<24)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Free( *this._S_widget )
      Protected result.i
      
      If *this
        If *this\_parent( ) 
          ; еще не проверял
          If *this\event
            ForEach *this\event\call( )
              If *this\event\call( )\pFunc 
                DeleteElement( *this\event\call( ) )
              EndIf
            Next
          EndIf
          
          If StickyWindow( ) =  *this
            StickyWindow( ) = #Null
          EndIf
          
          ;
          If OpenedWidget( ) = *this
            OpenList( *this\_parent( ) )
          EndIf
          
          If *this\_parent( )\first\widget = *this
            *this\_parent( )\first\widget = *this\after\widget
          EndIf
          
          If *this\_parent( )\last\widget = *this
            *this\_parent( )\last\widget = *this\before\widget
          EndIf
          
          If *this\_parent( )\TabWidget( )
            If *this\_parent( )\TabWidget( ) = *this
              FreeStructure( *this\_parent( )\TabWidget( ) ) 
              *this\_parent( )\TabWidget( ) = 0
            EndIf
            *this\_parent( )\TabWidget( ) = #Null
          EndIf
          
          If *this\_parent( )\scroll
            If *this\_parent( )\scroll\v = *this
              FreeStructure( *this\_parent( )\scroll\v ) 
              *this\_parent( )\scroll\v = 0
            EndIf
            If *this\_parent( )\scroll\h = *this
              FreeStructure( *this\_parent( )\scroll\h )  
              *this\_parent( )\scroll\h = 0
            EndIf
            ; *this\_parent( )\scroll = #Null
          EndIf
          
          If *this\_parent( )\type = #__type_Splitter
            If bar_first_gadget_( *this\_parent( ) ) = *this
              FreeStructure( bar_first_gadget_( *this\_parent( ) ) ) 
              bar_first_gadget_( *this\_parent( ) ) = 0
            EndIf
            If bar_second_gadget_( *this\_parent( ) ) = *this
              FreeStructure( bar_second_gadget_( *this\_parent( ) ) )  
              bar_second_gadget_( *this\_parent( ) ) = 0
            EndIf
          EndIf
          
          ;
          If *this\_parent( )\count\childrens
            LastElement(*this\_widgets( ))
            Repeat
              If  *this\_widgets( ) = *this Or IsChild(  *this\_widgets( ), *this )
                If  *this\_widgets( )\_root( )\count\childrens > 0 
                  *this\_widgets( )\_root( )\count\childrens - 1
                  
                  If  *this\_widgets( )\_parent( ) <>  *this\_widgets( )\_root( )
                    *this\_widgets( )\_parent( )\count\childrens - 1
                  EndIf
                  
                  If *this\_widgets( )\TabWidget( )
                    If *this\_widgets( )\TabWidget( ) = *this\_widgets( )
                      Debug "   free - tab " +*this\_widgets( )\TabWidget( )\class
                      FreeStructure( *this\_widgets( )\TabWidget( ) ) 
                      *this\_widgets( )\TabWidget( ) = 0
                    EndIf
                    *this\_widgets( )\TabWidget( ) = #Null
                  EndIf
                  
                  If *this\_widgets( )\scroll
                    If *this\_widgets( )\scroll\v 
                      Debug "   free - scroll-v " +*this\_widgets( )\scroll\v\class
                      FreeStructure( *this\_widgets( )\scroll\v ) 
                      *this\_widgets( )\scroll\v = 0 
                    EndIf
                    If *this\_widgets( )\scroll\h 
                      Debug "   free scroll-h - " +*this\_widgets( )\scroll\h\class
                      FreeStructure( *this\_widgets( )\scroll\h )  
                      *this\_widgets( )\scroll\h = 0 
                    EndIf
                    ; *this\_widgets( )\scroll = #Null
                  EndIf
                  
                  If *this\_widgets( )\type = #__type_Splitter
                    If bar_first_gadget_( *this\_widgets( ) ) 
                      Debug "   free - splitter - first " +bar_first_gadget_( *this\_widgets( ) )\class
                      FreeStructure( bar_first_gadget_( *this\_widgets( ) ) ) 
                      bar_first_gadget_( *this\_widgets( ) ) = 0 
                    EndIf
                    If bar_second_gadget_( *this\_widgets( ) ) 
                      Debug "   free - splitter - second " +bar_second_gadget_( *this\_widgets( ) )\class
                      FreeStructure( bar_second_gadget_( *this\_widgets( ) ) ) 
                      bar_second_gadget_( *this\_widgets( ) ) = 0 
                    EndIf
                  EndIf
                  
                  If *this\_widgets( )\attach
                    Debug " free - attach " +*this\_widgets( )\attach\_parent( )\class
                    *this\_widgets( )\attach\_parent( ) = 0
                    FreeStructure( *this\_widgets( )\attach )
                    *this\_widgets( )\attach = #Null
                  EndIf
                  
                  *this\_widgets( )\address = 0
                  Debug " free - " +*this\_widgets( )\class
                  DeleteElement(  *this\_widgets( ), 1 )
                EndIf
                
                If *this\_root( )\count\childrens = 0
                  Break
                EndIf
              ElseIf PreviousElement(  *this\_widgets( )) = 0
                Break
              EndIf
            ForEver
          Else ; if it's root
          EndIf
        EndIf
        
        If EnteredWidget( ) = *this
          EnteredWidget( ) = *this\_parent( )
        EndIf
        If FocusedWidget( ) = *this
          FocusedWidget( ) = *this\_parent( )
        EndIf
        
        PostCanvasRepaint( *this\_parent( ) )
        ;ClearStructure( *this, _S_widget )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure   WaitEvents( *this._s_WIDGET )
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "run")
      CompilerElse
        Protected msg.MSG
        ;         If PeekMessage_(@msg,0,0,0,1)
        ;           TranslateMessage_(@msg)
        ;           DispatchMessage_(@msg)
        ;         Else
        ;           Sleep_(1)
        ;         EndIf
        
        While GetMessage_(@msg, #Null, 0, 0 )
          TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
          DispatchMessage_(msg)  ;  посылает сообщение в функцию WindowProc.
          
          Debug ""+msg\message +" "+ msg\hwnd +" "+ msg\lParam +" "+ msg\wParam
          ;   If msg\wParam = #WM_QUIT
          ;     Debug "#WM_QUIT "
          ;   EndIf
        Wend
      CompilerEndIf
    EndProcedure
    
    Procedure   MessageEvents( )
      If EventWidget( )
        Protected *this = EventWidget( )
        Protected *message = EventWidget( )\_window( )
        
        Select WidgetEventType( )
          Case #PB_EventType_MouseEnter
            ReDraw(Root())
          Case #PB_EventType_LeftButtonDown
            ReDraw(Root())
          Case #PB_EventType_LeftClick
            Select GetText( *this )
              Case "No"     : SetData( *message, #PB_MessageRequester_No )     ; no
              Case "Yes"    : SetData( *message, #PB_MessageRequester_Yes )    ; yes
              Case "Cancel" : SetData( *message, #PB_MessageRequester_Cancel ) ; cancel
            EndSelect
            
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "stop:", *this)
            CompilerEndIf
        EndSelect
      EndIf
      ProcedureReturn #PB_Ignore
    EndProcedure
    
    Procedure   Message( Title.s, Text.s, Flag.i = #Null )
      Protected result
      Protected img =- 1, f1 =- 1, f2=8, width = 400, height = 120
      Protected bw = 85, bh = 25, iw = height-bh-f1 - f2*4 - 2-1
      
      Protected x = ( Root( )\width-width-#__window_frame_size*2 )/2
      Protected y = ( Root( )\height-height-#__window_caption_height-#__window_frame_size*2 )/2
      ;       Protected x = ( root( )\width-width )/2
      ;       Protected y = ( root( )\height-height )/2
      Protected *parent;._S_widget = EventWidget( )\_window( ) ; OpenedWidget( )
      
      Protected *message._s_WIDGET = Window( x,y, width, height, Title, #__window_titlebar, *parent)
      SetClass( *message, #PB_Compiler_Procedure )
      ;SetAlignmentFlag( Window, #__align_center )
      
      
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
          Data.q $8FDB82C66F4B707F,$1595D6EF9001DD5F,$69B32B24BD2B2529,$EA0DEEB7E6181FDC,$9D9F369A5BB6326
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
      
      Protected._S_widget *ok, *no, *cancel
      
      *ok = Button( width-bw-f2,height-bh-f2,bw,bh,"Ok");, #__button_default )
      SetAlignment( *ok, 0,0,1,1, 0 )
      
      If Flag & #PB_MessageRequester_YesNo Or 
         Flag & #PB_MessageRequester_YesNoCancel
        SetText( *ok, "Yes" )
        *no = Button( width-( bw+f2 )*2-f2,height-bh-f2,bw,bh,"No" )
        SetAlignment( *no, 0,0,1,1, 0 )
      EndIf
      
      If Flag & #PB_MessageRequester_YesNoCancel
        *cancel = Button( width-( bw+f2 )*3-f2*2,height-bh-f2,bw,bh,"Cancel" )
        SetAlignment( *cancel, 0,0,1,1, 0 )
      EndIf
      
      ;
      Bind( *message, @MessageEvents( ))
      
      ;
      Sticky( *message, #True )
      ReDraw(*message\_root())
      
      ;
      WaitEvents( *message )
      
      Sticky( *message, #False )
      ReDraw(*message\_root())
      result = GetData( *message )
      ; close
      Free( *message )
      
      ProcedureReturn result
    EndProcedure 
    
    Procedure   WaitClose( *this._S_widget = #PB_Any, waitTime.l = 0 )
      Protected result 
      Protected *window._S_widget
      Protected PBWindow = PB(EventWindow)( )
      
      If Root( )
        If *this = #PB_Any
          *window = Root( )\_window( )
        Else
          *window = *this\_window( )
        EndIf
        
        ;
        If ListSize( Root( )\_events( ) )
          ClearList( Root( )\_events( ) )
        EndIf
        
        ;
        PushMapPosition(Root( ))
        ForEach Root( )
          PostCanvasRepaint( Root( ) )
        Next
        PopMapPosition(Root( ))
        
        Repeat 
          Select WaitWindowEvent( waittime )
              ;             Case #PB_Event_Message
              ;             Case #PB_Event_Gadget
            Case #PB_Event_CloseWindow
              If *window = #PB_Any 
                If EventWidget( )
                  Debug " - close - " + EventWidget( ) ; +" "+ GetWindow( *window )
                  If EventWidget( )\container = #__type_window
                    ;Else
                    
                    ForEach Root( )
                      Debug Root( )
                      free( Root( ))
                      ;               ForEach Root( )\_widgets( )
                      ;                 Debug ""+ Root( )\_widgets( )\_root( ) +" "+ is_root_( Root( )\_widgets( ))
                      ;               Next
                    Next
                    Break
                  EndIf
                Else
                  Debug " - close0 - " + PBWindow ; +" "+ GetWindow( *window )
                  Break
                EndIf
                
              ElseIf PB(EventGadget)( ) = *window
                Debug " - close1 - " + PBWindow ; +" "+ GetWindow( *window )
                Free( *window )
                ReDraw( Root() )
                Break
                
              ElseIf PBWindow = *window 
                If Post( *window, #PB_EventType_Free )
                  Debug " - close2 - " + PBWindow ; +" "+ GetWindow( *window )
                  Break
                EndIf
                ;               Else
                ;                Debug 555
                ;                Free( *window )
                ;                 
                ;                 Break
              EndIf
              
          EndSelect
        ForEver
        
        ;         ; ReDraw( Root( ))
        ;         
        ;         If IsWindow( PBWindow)
        ;           Debug " - end - "
        ;           PB(CloseWindow)( PBWindow)
        ;           End 
        ;         EndIf
      EndIf  
      
    EndProcedure
  EndModule
  ;- <<< 
CompilerEndIf

;- 
Macro UseLIB( _name_ )
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro


CompilerIf #PB_Compiler_IsMainFile ;=99
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  
  ; Shows using of several panels...
  Procedure BindEvents( )
    Protected *this._S_widget = EventWidget( )
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
        ;       Case #PB_EventType_Draw          : Debug "draw"         
      Case #PB_EventType_MouseWheelX     : Debug  " - "+ *this +" - wheel-x"
      Case #PB_EventType_MouseWheelY     : Debug  " - "+ *this +" - wheel-y"
      Case #PB_EventType_Input           : Debug  " - "+ *this +" - input"
      Case #PB_EventType_KeyDown         : Debug  " - "+ *this +" - key-down"
      Case #PB_EventType_KeyUp           : Debug  " - "+ *this +" - key-up"
      Case #PB_EventType_Focus           : Debug  " - "+ *this +" - focus"
      Case #PB_EventType_LostFocus       : Debug  " - "+ *this +" - lfocus"
      Case #PB_EventType_MouseEnter      : Debug  " - "+ *this +" - enter"
      Case #PB_EventType_MouseLeave      : Debug  " - "+ *this +" - leave"
      Case #PB_EventType_LeftButtonDown  : Debug  " - "+ *this +" - down"
      Case #PB_EventType_DragStart       : Debug  " - "+ *this +" - drag"
      Case #PB_EventType_Drop            : Debug  " - "+ *this +" - drop"
      Case #PB_EventType_LeftButtonUp    : Debug  " - "+ *this +" - up"
      Case #PB_EventType_LeftClick       : Debug  " - "+ *this +" - click"
      Case #PB_EventType_LeftDoubleClick : Debug  " - "+ *this +" - 2_click"
    EndSelect
  EndProcedure
  
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  
  Define i
  Define *w._S_widget, *g._S_widget, editable
  Define *root._S_widget = Open(#window_0,0,0,424, 352): *root\class = "root": SetText(*root, "root")
  
  ;BindWidgetEvent( *root, @BindEvents( ) )
  Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
  view = Container(10, 10, 406, 238, #PB_Container_Flat)
  SetColor(view, #PB_Gadget_BackColor,RGB(213,213,213))
  ;a_enable( widget( ), 15 )
  a_init( view, 15 )
  
  ;Define *a1._s_widget = image( 5+170,5+140,60,60, -1 )
  Define *a1._s_widget = Panel( 5+170,5+140,160,160, #__flag_nogadgets )
  ;Define *a2._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
  Define *a2._s_widget = ScrollArea( 50,45,135,95, 300,300, 1, #__flag_nogadgets )
  Define *a3._s_widget = image( 150,110,60,60, -1 )
  
  ; a_init( *a, 15 )
  a_set( *a1, #__a_size )
  
  CloseList()
  size_value = Track(56, 262, 240, 26, 0, 30)
  pos_value = Track(56, 292, 240, 26, 0, 30)
  grid_value = Track(56, 320, 240, 26, 0, 30)
  back_color = Button(304, 264, 112, 32, "BackColor")
  frame_color = Button(304, 304, 112, 32, "FrameColor")
  size_text = Text(8, 256, 40, 24, "0")
  pos_text = Text(8, 288, 40, 24, "0")
  grid_text = Text(8, 320, 40, 24, "0")
  
  SetState( size_value, 7 )
  SetState( pos_value, 3 )
  SetState( grid_value, 6 )
  
  ;;Bind( *root, @WidgetEventHandler( ) )
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;{ OpenRoot0
  Define *root0._S_widget = Open(#window,10,10,300-20,300-20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  Define Text.s, m.s=#LF$, a
  *g = Editor(10, 10, 200+60, 200, #__flag_gridlines);, #__flag_autosize) 
  Text.s = "This is a long line." + m.s +
           "Who should show." + m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work."
  
  SetText(*g, Text.s) 
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 7+a, "_")
  For a = 4 To 6
    AddItem(*g, a, "Line "+Str(a))
  Next 
  
  *g = String(10, 220, 200+60, 50, "string gadget text text 1234567890 text text long long very long", #__string_password|#__string_right)
  
  
  Define *root1._S_widget = Open(#window,300,10,300-20,300-20): *root1\class = "root1": SetText(*root1, "root1")
  ;BindWidgetEvent( *root1, @BindEvents( ) )
  
  
  Define *root2._S_widget = Open(#window,10,300,300-20,300-20): *root2\class = "root2": SetText(*root2, "root2")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  HyperLink( 10,10, 80, 40, "HyperLink", RGB(105, 245, 44) )
  String( 60,20, 60, 40, "String" )
  *w = ComboBox( 108,20, 152,40)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  
  Define *root3._S_widget = Open(#window,300,300,300-20,300-20): *root3\class = "root3": SetText(*root3, "root3")
  ;BindWidgetEvent( *root3, @BindEvents( ) )
  
  Define *root4._S_widget = Open(#window, 590, 10, 200, 600-20): *root4\class = "root4": SetText(*root4, "root4")
  ;BindWidgetEvent( *root4, @BindEvents( ) )
  
  
  
  Define count = 2;0000
  #st = 1
  Global  mx=#st,my=#st
  
  Define time = ElapsedMilliseconds( )
  
  Global *c, *panel._S_widget
  Procedure do_Events()
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick
        
        Select GetText( EventWidget( ) )
          Case "hide_2"
            hide(*c, 1)
            ; Disable(*c, 1)
            
          Case "show_2" 
            hide(*c, 0)
            
        EndSelect
        
        ;         ;Case #PB_EventType_LeftButtonUp
        ;         ClearDebugOutput( )
        ;         
        ;         If StartEnumerate(*panel);Root())
        ;           If Not hide(widget( )) ;And GetParent(widget()) = *panel
        ;             Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
        ;           EndIf
        ;           StopEnumerate( )
        ;         EndIf
        
    EndSelect
  EndProcedure
  
  OpenList( *root1 )
  *panel = Panel(20, 20, 180+40, 180+60, editable) : SetText(*panel, "1")
  AddItem( *panel, -1, "item_1" )
  ;Button( 20,20, 80,80, "item_1")
  *g = Editor(0, 0, 0, 0, #__flag_autosize) 
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 3+a, "")
  AddItem(*g, 4+a, "_ The string must be very long. _")
  AddItem(*g, 5+a, "")
  For a = 6 To 8
    AddItem(*g, a, "Line "+Str(a))
  Next 
  
  AddItem( *panel, -1, "item_2" )
  ; Button( 10,10, 80,80, "item_2")
  Bind(Button( 5, 5, 55, 22, "hide_2"), @do_Events())
  Bind(Button( 5, 30, 55, 22, "show_2"), @do_Events())
  
  *c=Container(110,5,150,155, #PB_Container_Flat) 
  Define *p = Panel(10,5,150,65) 
  AddItem(*p, -1, "item-1")
  Container(10,5,150,55, #PB_Container_Flat) 
  Container(10,5,150,55, #PB_Container_Flat) 
  Button(10,5,50,25, "butt1") 
  CloseList()
  CloseList()
  AddItem(*p, -1, "item-2")
  Container(10,5,150,55, #PB_Container_Flat) 
  Container(10,5,150,55, #PB_Container_Flat) 
  Button(10,5,50,25, "butt2") 
  CloseList()
  CloseList()
  CloseList()
  
  Container(10,75,150,55, #PB_Container_Flat) 
  Container(10,5,150,55, #PB_Container_Flat) 
  Container(10,5,150,55, #PB_Container_Flat) 
  Button(10,5,50,45, "butt1") 
  CloseList()
  CloseList()
  CloseList()
  CloseList()
  
  AddItem( *panel, -1, "item_3" )
  
  SetText(Container(20, 20, 180, 180, editable), "4") 
  SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets|editable), "5") 
  SetText(Container(40, 20, 180, 180, editable), "6")
  Define seven = Container(20, 20, 180, 180, editable)
  SetText(seven, "      7")
  
  SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets|editable), "     8") 
  SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets|editable), "     9") 
  SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets|editable), "     10") 
  
  CloseList( ) ; 7
  CloseList( ) ; 6
  SetText(Container(10, 45, 70, 180, editable), "11") 
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), "12") 
  SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), "13") 
  SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), "14") 
  
  SetText(Container(10, 45, 70, 180, editable), "15") 
  SetText(Container(10, 5, 70, 180, editable), "16") 
  SetText(Container(10, 5, 70, 180, editable), "17") 
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), "18") 
  CloseList( ) ; 17
  CloseList( ) ; 16
  CloseList( ) ; 15
  CloseList( ) ; 11
  CloseList( ) ; 1
  
  OpenList( seven )
  ;   Define split_1 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;   Define split_2 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;   Define split_3 = Splitter(5, 80, 180, 50,split_1,split_2,editable)
  ;   Define split_4 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;   SetText(Splitter(5, 80, 180, 50,split_3,split_4,#PB_Splitter_Vertical|editable), "10-1") 
  SetText(Container( -5, 80, 180, 50, #__Flag_NoGadgets|editable), "container-7")
  CloseList( ) ; 7
               ;OpenList( *panel )
  
  AddItem( *panel, -1, "item_4" )
  Button( 30,30, 80,80, "item_4")
  AddItem( *panel, -1, "item_5" )
  Button( 40,40, 80,80, "item_5")
  CloseList( ) ; *panel
  CloseList( ) ; *root1
               ; SetState( *panel, 2 )
  
  ;\\\
  OpenList( *root2 )
  SetText(*root2, "*root2" )
  ;   ;Define *p3._S_widget = Container( 80,80, 150,150 )
  ;   Define *p3._S_widget = ScrollArea( 80,80, 150+30,150+30, 300,300 )
  ;   SetText(*p3, "12" )
  ;   SetText(Container( 40,-30, 50,50, #__Flag_NoGadgets ), "13" )
  ;   
  ;   Define *p2._S_widget = Container( 40,40, 70,70 ) : SetText(*p2, "4" )
  ;   SetText(Container( 5,5, 70,70 ), "5" )
  ;   SetText(Container( -30,40, 50,50, #__Flag_NoGadgets ), "6")
  ;   CloseList( )
  ;   Define *c1._S_widget = Container( 40,-30, 50,50, #__Flag_NoGadgets ) : SetText(*c1, "3" )
  ;   CloseList( )
  ;   
  ;   SetText(Container( 50,130, 50,50, #__Flag_NoGadgets ), "14" )
  ;   SetText(Container( -30,40, 50,50, #__Flag_NoGadgets ), "15" )
  ;   SetText(Container( 130,50, 50,50, #__Flag_NoGadgets ), "16" )
  ;   CloseList( )
  ;   CloseList( )
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  ;   Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  ;   Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  ;   Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  
  
  Button_2 = ComboBox( 20,20, 150,40)
  For i=1 To 100;0000
    AddItem(Button_2, i, "text-"+Str(i))
  Next
  
  ;Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
  Button_5 = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(10, 70, 250, 120, 0, Splitter_4, #PB_Splitter_Vertical)
  SetState(Splitter_5, 50)
  SetState(Splitter_4, 50)
  SetState(Splitter_3, 40)
  SetState(Splitter_1, 50)
  
  OpenList( *root3 )
  *w = Tree( 10,20, 150,200, #__tree_multiselect)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  Container( 70,180, 80,80): CloseList( )
  
  *w = Tree( 100,30, 100,260-20+300, #__flag_borderless)
  SetColor( *w, #__color_back, $FF07EAF6 )
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 180,40, 100,260-20+300, #__tree_checkboxes )
  For i=1 To 100;0000
    If (i & 5)
      AddItem(*w, i, "text-"+Str(i), -1, 1 )
    Else
      AddItem(*w, i, "text-"+Str(i))
    EndIf
  Next
  
  Debug "--------  time --------- "+Str(ElapsedMilliseconds( ) - time)
  
  
  ;
  Define *window._S_widget
  Define i,y = 5
  OpenList( *root4 )
  For i = 1 To 4
    Window(5, y, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    Container(5, 5, 120+2,85+2)                                                                           ;, #PB_Container_Flat)                                                                         ; Gadget(i, 
    Button(10,10,100,30,"Button_" + Trim(Str(i+10)))                                                      ; Gadget(i+10,
    Button(10,45,100,30,"Button_" + Trim(Str(i+20)))                                                      ; Gadget(i+20,
    CloseList( )                                                                                          ; Gadget
    y + 130
  Next
  
  ; redraw(root())
  ; 
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP