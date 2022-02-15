; ver: 3.0.0.0 ; 
; sudo adduser your_username vboxsf
; https://linuxrussia.com/sh-ubuntu.html

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  #path = "/media/sf_as/Documents/GitHub/widget"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  #path = "Z:/Documents/GitHub/widget"
  ;#path "C:\Users\as\Desktop\Widget_15_08_2020"
CompilerEndIf

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


CompilerIf Not Defined( Widget, #PB_Module )
  ;-  >>>
  DeclareModule Widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    
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
      ForEach _root_\canvas\child( ) 
        If _root_\canvas\child( ) <> _root_\canvas\child( )\root
          If _root_\canvas\child( )\before\widget And _root_\canvas\child( )\after\widget
            Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +" "+ _root_\canvas\child( )\class +" "+ _root_\canvas\child( )\after\widget\class
          ElseIf _root_\canvas\child( )\after\widget
            Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class +" "+ _root_\canvas\child( )\after\widget\class
          ElseIf _root_\canvas\child( )\before\widget
            Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +" "+ _root_\canvas\child( )\class +" none"
          Else
            Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class + " none " 
          EndIf
          
          ;           If _root_\canvas\child( )\before\widget And _root_\canvas\child( )\after\widget
          ;             Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +"-"+ _root_\canvas\child( )\before\widget\position +" "+ _root_\canvas\child( )\class +"-"+ _root_\canvas\child( )\position +" "+ _root_\canvas\child( )\after\widget\class +"-"+ _root_\canvas\child( )\after\widget\position
          ;           ElseIf _root_\canvas\child( )\after\widget
          ;             Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class +"-"+ _root_\canvas\child( )\position +" "+ _root_\canvas\child( )\after\widget\class +"-"+ _root_\canvas\child( )\after\widget\position
          ;           ElseIf _root_\canvas\child( )\before\widget
          ;             Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +"-"+ _root_\canvas\child( )\before\widget\position +" "+ _root_\canvas\child( )\class +"-"+ _root_\canvas\child( )\position +" none"
          ;           Else
          ;             Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class +"-"+ _root_\canvas\child( )\position + " none " 
          ;           EndIf
          ;           
          ;           ;         If _root_\canvas\child( )\before\widget And _root_\canvas\child( )\after\widget
          ;           ;           Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +" "+ _root_\canvas\child( )\class +" "+ _root_\canvas\child( )\after\widget\class
          ;           ;         ElseIf _root_\canvas\child( )\after\widget
          ;           ;           Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class +" "+ _root_\canvas\child( )\after\widget\class
          ;           ;         ElseIf _root_\canvas\child( )\before\widget
          ;           ;           Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" "+ _root_\canvas\child( )\before\widget\class +" "+ _root_\canvas\child( )\class +" none"
          ;           ;         Else
          ;           ;           Debug " - "+ Str(ListIndex(Widget( ))) +" "+ _root_\canvas\child( )\index +" none "+ _root_\canvas\child( )\class + " none " 
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
      _S_#_struct_name_#_struct_type_ = AllocateStructure( _S_#_struct_name_ )
    EndMacro
    
    Macro PB( _pb_function_name_ ) : _pb_function_name_: EndMacro
    ;     Macro This( ) : widget::*canvas: EndMacro
    Macro Drawing( ): widget::*canvas\drawing : EndMacro
    Macro Root( ) : widget::*canvas\roots( ): EndMacro
    Macro Mouse( ) : widget::*canvas\mouse: EndMacro
    Macro Keyboard( ) : widget::*canvas\keyboard: EndMacro
    
    Macro Widget( ) : WidgetList( Root( ) ): EndMacro ; Returns last created widget 
    Macro EventList( _address_ ) : _address_\canvas\events( ) : EndMacro
    Macro WidgetList( _address_ ) : _address_\canvas\child( ) : EndMacro
    Macro RowList( _this_ ): _this_\row\_s( ): EndMacro
    Macro TabList( _this_ ): _this_\bar\_s( ): EndMacro
    
    Macro EnteredRow( _this_ ): _this_\row\entered: EndMacro; Returns mouse entered widget
    Macro LeavedRow( _this_ ): _this_\row\leaved: EndMacro  ; Returns mouse entered widget
    Macro PressedRow( _this_ ): _this_\row\pressed: EndMacro; Returns key focus item address
    Macro FocusedRow( _this_ ): _this_\row\active: EndMacro ; Returns key focus item address
    
    Macro VisibleRowList( _this_ ): _this_\row\visible\_s( ): EndMacro
    Macro VisibleFirstRow( _this_ ): _this_\row\visible\first: EndMacro
    Macro VisibleLastRow( _this_ ): _this_\row\visible\last: EndMacro
    
    Macro EnteredRowindex( _this_ ): _this_\index[#__S_1]: EndMacro ; Returns mouse entered widget
    Macro PressedRowindex( _this_ ): _this_\index[#__S_2]: EndMacro ; Returns mouse entered widget
    
    Macro EnteredButton( ) : Mouse( )\entered\button: EndMacro
    Macro LeavedButton( ) : Mouse( )\leaved\button: EndMacro
    Macro FocusedButton( ) :  Keyboard( )\focused\button: EndMacro
    
    Macro EnteredTab( _this_ ): _this_\bar\hover: EndMacro ; Returns mouse entered tab
    Macro FocusedTab( _this_ ): _this_\bar\active: EndMacro; Returns mouse entered tab
    Macro EnteredTabindex( _this_ ): _this_\index[#__tab_1]: EndMacro ; Returns mouse entered widget
    Macro FocusedTabindex( _this_ ): _this_\index[#__tab_2]: EndMacro ; Returns mouse entered widget
    
    Macro ParentTabIndex( _this_ ): _this_\parent\index: EndMacro       ; Returns mouse entered widget
    Macro OpenTabIndex( _this_ ): _this_\tab\index: EndMacro            ; Returns mouse entered widget
    
    Macro EnteredWidget( ) : Mouse( )\entered\widget: EndMacro ; Returns mouse entered widget
    Macro LeavedWidget( ) : Mouse( )\leaved\widget: EndMacro   ; Returns mouse entered widget
    Macro PressedWidget( ) : Mouse( )\pressed\widget: EndMacro
    Macro FocusedWidget( ) : Keyboard( )\focused\widget: EndMacro ; Returns keyboard focus widget
    
    Macro OpenedWidget( ) : widget::*canvas\opened: EndMacro
    Macro StickyWindow( ) : widget::*canvas\sticky\window: EndMacro
    Macro PopupWidget( ) : widget::*canvas\sticky\widget: EndMacro
    
    Macro EventWidget( ) : widget::*canvas\widget: EndMacro
    Macro EventIndex( ) : EventWidget( )\index: EndMacro
    
    Macro WidgetEvent( ) : widget::*canvas\event: EndMacro
    Macro WidgetEventType( ) : WidgetEvent( )\type: EndMacro
    Macro WidgetEventItem( ) : WidgetEvent( )\item: EndMacro
    Macro WidgetEventData( ) : WidgetEvent( )\data: EndMacro
    
    Macro  ChangeCurrentRoot(_canvas_gadget_address_ )
      FindMapElement( Root( ), Str( _canvas_gadget_address_ ) )
    EndMacro
    
    
    ;-
    Macro Transform( ) : Mouse( )\_transform: EndMacro
    
    Macro _add_action_( _this_ )
      ;       If This( )\action_type <> #PB_Compiler_Procedure 
      ;         If This( )\action_type = "AddItem"
      ;           If This( )\action_widget And This( )\action_widget\type = #__type_combobox
      ;             This( )\action_widget\change = 1
      ;             ;Redraw( This( )\action_widget\root )
      ;           EndIf
      ;         EndIf
      ;         
      ;         If This( )\action_type = "Resize"
      ;           If This( )\action_widget
      ;             DoEvents( This( )\action_widget, #PB_EventType_ResizeEnd )
      ;           EndIf
      ;         EndIf
      ;         
      ;         This( )\action_widget = _this_
      ;         This( )\action_type = #PB_Compiler_Procedure 
      ;       EndIf
    EndMacro
    
    Macro Clip( _address_, _mode_=[#__c_clip] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        PB(ClipOutput)( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    Macro UnClip( )
      PB(UnclipOutput)( )
    EndMacro
    
    Macro _content_clip_( _address_, _mode_= )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        ; ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    
    Macro _content_clip2_( _address_, _mode_= )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        ; ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
        Clip( _address_, _mode_ )
        
        ; Post( _address_, #PB_EventType_Draw ) 
        
      CompilerEndIf
    EndMacro
    
    
    Macro Repaints( )
      PostEventRepaint( Root( ) )
    EndMacro
    
    Macro PostEventRepaint( _address_ ) 
      If _address_\root\state\repaint = #False
        _address_\root\state\repaint = #True
        ;;; Debug "-- post --- event -- repaint --"
        PostEvent( #PB_Event_Gadget, _address_\root\canvas\window, _address_\root\canvas\gadget, #PB_EventType_Repaint, _address_\root )
      ElseIf _address_\state\repaint = #False
        _address_\state\repaint = #True
      EndIf
    EndMacro
    
    Macro PostEventCanvas( _root_address_, _event_data_ = #Null )
      ;       If _root_address_\canvas\gadget <> PB(EventGadget)( )
      ;         If _root_address_\canvas\postevent = #False 
      ;           _root_address_\canvas\postevent = #True
      ;           PostEvent( #PB_Event_Gadget, _root_address_\canvas\window, _root_address_\canvas\gadget, #PB_EventType_Repaint, _event_data_ )
      ;         EndIf
      ;       EndIf
      PostEventRepaint( _root_address_ )
    EndMacro
    
    ;-
    Macro GetActive( ): Keyboard( )\window: EndMacro   ; Returns activeed window
    Macro GetMouseX( _mode_ = #__c_screen ): Mouse( )\x[_mode_]: EndMacro ; Returns mouse x
    Macro GetMouseY( _mode_ = #__c_screen ): Mouse( )\y[_mode_]: EndMacro ; Returns mouse y
    
    ;-
    Macro scroll_x_( _this_ ): _this_\x[#__c_required]: EndMacro
    Macro scroll_y_( _this_ ):  _this_\y[#__c_required]: EndMacro
    Macro scroll_width_( _this_ ): _this_\width[#__c_required]: EndMacro
    Macro scroll_height_( _this_ ): _this_\height[#__c_required]: EndMacro
    
    ;-
    Macro StartEnumerate( _parent_ )
      Bool( _parent_\count\childrens )
      If Root( ) <> _parent_\root
        ChangeCurrentRoot(_parent_\root\canvas\address )
      EndIf
      
      PushListPosition( Widget( ) )
      If _parent_\address
        ChangeCurrentElement( Widget( ), _parent_\address )
      Else
        ResetList( Widget( ))
      EndIf
      
      While NextElement( Widget( ))
        If IsChild( Widget( ), _parent_ ) ; Not ( _parent_\after\widget And _parent_\after\widget = widget( )) ; 
        EndMacro
        
        Macro AbortEnumerate( )
          Break
        EndMacro
        
        Macro StopEnumerate( ) 
        Else
          Break
        EndIf
      Wend
      PopListPosition( Widget( ))
    EndMacro
    
    
    ;-
    Macro _get_colors_( ) : colors::*this\blue : EndMacro
    
    ;- 
    Macro is_root_(_this_ ) : Bool( _this_ > 0 And _this_ = _this_\root ): EndMacro
    Macro is_item_( _this_, _item_ ) : Bool( _item_ >= 0 And _item_ < _this_\count\items ) : EndMacro
    Macro is_widget_( _this_ ) : Bool( _this_ > 0 And _this_\address ) : EndMacro
    Macro is_window_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type = constants::#__type_window ) : EndMacro
    
    Macro is_parent_( _this_, _parent_ )
      Bool( _parent_ = _this_\parent\widget And ( _parent_\tab\widget And ParentTabIndex( _this_ ) = FocusedTabindex( _parent_\tab\widget ) ))
    EndMacro
    Macro is_parent_one_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\parent\widget = _address_2\parent\widget And ParentTabIndex( _address_1 ) = ParentTabIndex( _address_2 ) )
    EndMacro
    
    Macro is_root_container_( _this_ )
      Bool( _this_ = _this_\root\canvas\container )
    EndMacro
    
    Macro splitter_first_gadget_( _this_ ): _this_\gadget[#__split_1]: EndMacro
    Macro splitter_second_gadget_( _this_ ): _this_\gadget[#__split_2]: EndMacro
    Macro splitter_is_first_gadget_( _this_ ): _this_\index[#__split_1]: EndMacro
    Macro splitter_is_second_gadget_( _this_ ): _this_\index[#__split_2]: EndMacro
    
    Macro is_scrollbars_( _this_ ) 
      Bool( _this_\parent\widget And _this_\parent\widget\scroll And ( _this_\parent\widget\scroll\v = _this_ Or _this_\parent\widget\scroll\h = _this_ )) 
    EndMacro
    
    Macro is_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child = 1 )
    EndMacro
    
    Macro is_at_box_v_( _position_y_, _size_height_, _mouse_y_ )
      Bool( _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
    EndMacro
    
    Macro is_at_box_h_( _position_x_, _size_width_, _mouse_x_ )
      Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 )
    EndMacro
    
    Macro is_at_box_( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
      Bool( is_at_box_h_( _position_x_, _size_width_, _mouse_x_ ) And is_at_box_v_( _position_y_, _size_height_, _mouse_y_ ) )
    EndMacro
    
    Macro is_at_circle_( _position_x_, _position_y_, _mouse_x_, _mouse_y_, _circle_radius_ )
      Bool( Sqr( Pow((( _position_x_ + _circle_radius_ ) - _mouse_x_ ), 2 ) + Pow((( _position_y_ + _circle_radius_ ) - _mouse_y_ ), 2 )) <= _circle_radius_ )
    EndMacro
    
    Macro is_at_point_y_( _address_, _mouse_y_, _mode_ = )
      is_at_box_v_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ )
    EndMacro
    
    Macro is_at_point_x_( _address_, _mouse_x_, _mode_ = )
      is_at_box_v_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ )
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
    
    Macro is_current_( _address_ )
      1;Bool( Not Mouse( )\buttons Or _address_\state\press )
       ; Bool( Not ( mouse( )\buttons And Not _address_\state\press ))
    EndMacro
    
    Macro is_text_gadget_( _this_ )
      Bool( _this_\type = #PB_GadgetType_Editor Or
            _this_\type = #PB_GadgetType_HyperLink Or
            _this_\type = #PB_GadgetType_IPAddress Or
            _this_\type = #PB_GadgetType_CheckBox Or
            _this_\type = #PB_GadgetType_Option Or
            _this_\type = #PB_GadgetType_Button Or
            _this_\type = #PB_GadgetType_String Or
            _this_\type = #PB_GadgetType_Text )
    EndMacro
    
    Macro is_list_gadget_( _this_ )
      Bool( _this_\type = #PB_GadgetType_Tree Or
            _this_\type = #PB_GadgetType_ListView Or
            _this_\type = #PB_GadgetType_ListIcon Or
            _this_\type = #PB_GadgetType_ExplorerTree Or
            _this_\type = #PB_GadgetType_ExplorerList )
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
    
    Macro _post_repaint_items_( _this_ )
      If _this_\count\items = 0 Or 
         ( Not _this_\hide And _this_\row\count And 
           ( _this_\count\items % _this_\row\count ) = 0 )
        
        Debug #PB_Compiler_Procedure
        _this_\change = 1
        _this_\row\count = _this_\count\items
        PostEventCanvas( _this_\root )
      EndIf  
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
    Macro a_focus_widget( ) 
      transform( )\_a_widget
    EndMacro
    Macro a_enter_widget( )
      transform( )\widget
    EndMacro
    Macro a_enter_index( _this_ ) 
      _this_\_a_\id\index
    EndMacro
    
    Macro a_reset( )
      ; reset multi group
      If ListSize( transform( )\group( ))
        ForEach transform( )\group( )
          transform( )\group( )\widget\_a_\transform = 1
          transform( )\group( )\widget\root\_a_\transform = 1
          transform( )\group( )\widget\parent\widget\_a_\transform = 1
        Next
        
        transform( )\id[0]\x = 0
        transform( )\id[0]\y = 0
        transform( )\id[0]\width = 0
        transform( )\id[0]\height = 0
        ClearList( transform( )\group( ))
      EndIf
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
    Macro DrawBox_( _x_,_y_,_width_,_height_, _color_=$ffffffff )
      Box( _x_,_y_,_width_,_height_, _color_ )
    EndMacro
    
    Macro DrawRoundBox_( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_=$ffffffff )
      If _round_x_ Or _round_y_
        RoundBox( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_ ) ; bug _round_y_ = 0 
      Else
        DrawBox_( _x_,_y_,_width_,_height_, _color_ )
      EndIf
    EndMacro
    
    ;     Macro draw_mode_( _this_, _mode_ )
    ;       If _this_\color\alpha And _this_\color\alpha\frame
    ;         DrawingModeAlpha_( _mode_ )
    ;       Else
    ;         DrawingMode_( _mode_ )
    ;       EndIf
    ;     EndMacro
    
    Macro DrawingMode_( _mode_ )
      ;       If Widget( )\_drawing <> _mode_
      ;         Widget( )\_drawing = _mode_
      ;Debug _mode_
      DrawingMode( _mode_ )
      ;       EndIf
    EndMacro
    
    Macro DrawingModeAlpha_( _mode_ )
      ;       If Widget( )\_draw_alpha <> _mode_
      ;         Widget( )\_draw_alpha = _mode_
      
      DrawingMode_( _mode_ | #PB_2DDrawing_AlphaBlend )
      ;       EndIf
    EndMacro
    
    Macro draw_font_( _draw_address_ )
      ; drawing font
      If _draw_address_\text\fontID = #Null
        _draw_address_\text\fontID = _draw_address_\root\text\fontID 
        _draw_address_\text\change = #True
      EndIf
      
      If _draw_address_\root\canvas\fontID <> _draw_address_\text\fontID
        _draw_address_\root\canvas\fontID = _draw_address_\text\fontID
        
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
            _this_\text\fontID = _this_\parent\widget\text\fontID 
            _this_\text\height = _this_\parent\widget\text\height 
          Else
            _this_\text\fontID = _this_\root\text\fontID 
            _this_\text\height = _this_\root\text\height 
          EndIf
        EndIf
        
        _item_\text\fontID = _this_\text\fontID
        _item_\text\height = _this_\text\height
        _item_\text\change = #True
      EndIf
      ;Debug ""+_this_\root\canvas\fontID +" "+ _item_\text\fontID
      ; drawing item font
      If _this_\root\canvas\fontID <> _item_\text\fontID
        ;;Debug " item fontID - "+ _item_\text\fontID
        _this_\root\canvas\fontID = _item_\text\fontID
        
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
      
      DrawRoundBox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      
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
      
      DrawRoundBox_( _x_,_y_,_width_,_height_, _round_,_round_ )
      
      BackColor( #PB_Default ) : FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_box_( _address_, _color_type_, _mode_= )
      DrawRoundBox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, 
                     _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
    EndMacro
    
    Macro draw_box_button_( _address_, _color_type_ )
      If Not _address_\hide
        DrawRoundBox_( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        DrawRoundBox_( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
        DrawRoundBox_( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
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
        DrawRoundBox_( _address_\x, _address_\y, _address_\width, _address_\height, 
                       _address_\round, _address_\round, _address_\color\frame[_address_\color\state]&$FFFFFF | _address_\color\_alpha<<24 )
      EndIf
    EndMacro
    
    Macro draw_option_button_( _address_, _size_, _color_ )
      If _address_\round > 2
        If _address_\width % 2
          DrawRoundBox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, _size_ + 1,_size_ + 1, _color_ ) 
        Else
          DrawRoundBox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_,_size_, _size_,_size_, _color_ ) 
        EndIf
      Else
        If _address_\width % 2
          DrawRoundBox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
        Else
          DrawRoundBox_( _address_\x + ( _address_\width - _size_ )/2,_address_\y + ( _address_\height - _size_ )/2, _size_ + 1,_size_ + 1, 1,1, _color_ ) 
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
      DrawingModeAlpha_( #PB_2DDrawing_Gradient )
      LinearGradient( _x_,_y_, _x_, ( _y_ + _height_ ))
      
      If _checked_
        BackColor( _color_fore2_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back2_&$FFFFFF | _alpha_<<24 )
      Else
        BackColor( _color_fore_&$FFFFFF | _alpha_<<24 )
        FrontColor( _color_back_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      DrawRoundBox_( _x_,_y_,_width_,_height_, _round_,_round_ )
      
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
              DrawRoundBox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5, 5,5 ) 
            Else
              DrawRoundBox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4, 4,4 ) 
            EndIf
          Else
            If _checked_ =- 1
              If _width_%2
                DrawBox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 5,5 ) 
              Else
                DrawBox_( _x_ + ( _width_ - 4 )/2,_y_ + ( _height_ - 4 )/2, 4,4 ) 
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
      
      DrawingModeAlpha_( #PB_2DDrawing_Outlined )
      
      If _checked_
        FrontColor( _color_frame2_&$FFFFFF | _alpha_<<24 )
      Else
        FrontColor( _color_frame_&$FFFFFF | _alpha_<<24 )
      EndIf
      
      DrawRoundBox_( _x_,_y_,_width_,_height_, _round_,_round_ );, _color_frame_&$FFFFFF | _alpha_<<24 )
    EndMacro
    
    
    ;-
    Macro _mdi_update_( _this_,  _x_,_y_, _width_, _height_ )
      scroll_x_( _this_ ) = _x_
      scroll_y_( _this_ ) = _y_
      scroll_width_( _this_ ) = _width_
      scroll_height_( _this_ ) = _height_
      
      If StartEnumerate( _this_ )
        If Widget( )\parent\widget = _this_
          If scroll_x_( _this_ ) > Widget( )\x[#__c_container] 
            scroll_x_( _this_ ) = Widget( )\x[#__c_container] 
          EndIf
          If scroll_y_( _this_ ) > Widget( )\y[#__c_container] 
            scroll_y_( _this_ ) = Widget( )\y[#__c_container] 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If StartEnumerate( _this_ )
        If Widget( )\parent\widget = _this_
          If scroll_width_( _this_ ) < Widget( )\x[#__c_container] + Widget( )\width[#__c_frame] - scroll_x_( _this_ ) 
            scroll_width_( _this_ ) = Widget( )\x[#__c_container] + Widget( )\width[#__c_frame] - scroll_x_( _this_ ) 
          EndIf
          If scroll_height_( _this_ ) < Widget( )\y[#__c_container] + Widget( )\height[#__c_frame] - scroll_y_( _this_ ) 
            scroll_height_( _this_ ) = Widget( )\y[#__c_container] + Widget( )\height[#__c_frame] - scroll_y_( _this_ ) 
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If bar_Updates( _this_, 0, 0, _this_\width[#__c_container], _this_\height[#__c_container] )
        
        _this_\width[#__c_inner] = _this_\scroll\h\bar\page\len
        _this_\height[#__c_inner] = _this_\scroll\v\bar\page\len
        
      EndIf
      
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
    Declare a_set( *this, size.l = #__a_size, position.l = #PB_Ignore )
    Declare a_update( *parent )
    
    Declare.i SetAttachment( *this, *parent, mode.a )
    Declare.i SetAlignmentFlag( *this, Mode.l, Type.l = 1 )
    Declare.i SetAlignment( *this, left.l, top.l, right.l, bottom.l, auto.b = #True )
    Declare   SetFrame( *this, size.a, mode.i = 0 )
    Declare   Object( x.l,y.l,width.l,height.l, text.s, Color.l, flag.i=#Null, framesize=1 )
    
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
    Declare.b Change( *this, ScrollPos.f )
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
    
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    
    Declare.i bar_tab_SetState( *this._S_widget, State.l )
    Declare   bar_Updates( *this, x.l,y.l,width.l,height.l )
    Declare   bar_Resizes( *this, x.l,y.l,width.l,height.l )
    Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.i = 0 )
    Declare   AddColumn( *this, Position.l, Text.s, Width.l, Image.i =- 1 )
    
    Declare.b Arrow( x.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
    
    Declare   Free( *this )
    Declare.i Bind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Unbind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Post( *this, eventtype.l, *button = #PB_All, *data = #Null )
    
    ;
    Declare   DoEvents( *this, eventtype.l, *button = #PB_All, *data = #Null ) ;, mouse_x.l, mouse_y.l
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    Declare.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l,height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  Window = -1, *CallBack = #Null )
    ;}
    
  EndDeclareModule
  
  Module Widget
    ;-
    ;- DECLARE_private_functions
    ;-
    Declare.b bar_tab_draw( *this )
    Declare.b bar_Update( *bar )
    Declare.b bar_Resize( *bar )
    Declare.b bar_SetState( *bar, state.f )
    
    Declare.l draw_items_( *this._S_widget, List *row._S_rows( ), _scroll_x_, _scroll_y_ )
    
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
    
    Macro set_cursor_( _this_, _cursor_ )
      If _this_\root\canvas\cursor <> _cursor_ 
        _this_\root\canvas\cursor = _cursor_
        If 65535 >= _cursor_
          SetGadgetAttribute( _this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_ )
        Else
          SetGadgetAttribute( _this_\root\canvas\gadget, #PB_Canvas_CustomCursor, _cursor_ )
        EndIf
      EndIf
    EndMacro
    
    Macro _cursor_set_( _this_ )
      If Not Mouse( )\buttons And
         ; _this_\color\state = #__S_1 And 
        _this_\cursor And Not _this_\state\press 
        
        set_cursor_( _this_, _this_\cursor )
      EndIf
    EndMacro
    
    Macro _cursor_remove_( _this_ )
      If Not Mouse( )\buttons
        ; Debug "remove cursor "+_this_ +" "+ EnteredWidget( )
        
        If EnteredWidget( ) And EnteredWidget( )\cursor And EnteredWidget( )\cursor <> EnteredWidget( )\root\canvas\cursor ; Not is_root_(EnteredWidget( ))  
          set_cursor_( _this_, EnteredWidget( )\cursor )
        Else
          set_cursor_( _this_, #PB_Cursor_Default )
        EndIf
      EndIf
    EndMacro
    
    
    
    ;-
    Procedure   CreateIcon( img.l, type.l )
      Protected x,y,Pixel, size = 8, index.i
      
      index = CreateImage( img, size, size ) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing( ImageOutput( img ))
        DrawBox_( 0, 0, size, size, $fff0f0f0 );GetSysColor_( #COLOR_bTNFACE ))
        
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
                Dot = transform( )\dotted\dot, 
                Space.b = transform( )\dotted\space, 
                line.b = transform( )\dotted\line
      
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
    
    ;     Global *drop._S_DD
    ;     Global NewMap *droped._S_DD( )
    
    Macro _DD_drop_( _address_ )
      _address_\drop
    EndMacro
    
    Macro _DD_drag_( )
      Mouse( )\_drag
    EndMacro
    
    Macro _DD_action_( _address_ )
      Bool( _DD_drop_( _address_ ) And _DD_drag_( ) And 
            _DD_drop_( _address_ )\format = _DD_drag_( )\format And 
            _DD_drop_( _address_ )\actions & _DD_drag_( )\actions And
            _DD_drop_( _address_ )\PrivateType = _DD_drag_( )\PrivateType )
    EndMacro
    
    Macro _DD_event_enter_( _result_, _this_ )
      ;       If _this_\state\flag & #__S_drop = #False
      ;         _this_\state\flag | #__S_drop
      ;         
      ;         If _DD_drag_( ) 
      ;           If _DD_action_( EnteredWidget( ) )
      ;             DD_cursor( _this_, #PB_Cursor_Drop )
      ;           Else
      ;             DD_cursor( _this_, #PB_Cursor_Drag )
      ;           EndIf
      ;           
      ;           _result_ = #True
      ;         EndIf
      ;       EndIf
    EndMacro
    
    Macro _DD_event_leave_( _result_, _this_ )
      ;       If _this_\state\flag & #__S_drop
      ;         _this_\state\flag &~ #__S_drop
      ;         
      ;         If _DD_drag_( ) 
      ;           DD_cursor( _this_, #PB_Cursor_Drag )
      ;           _result_ = #True
      ;         EndIf
      ;       EndIf
    EndMacro
    
    Macro _DD_event_drag_( _result_, _this_ )
      ;       If _this_\state\flag & #__S_drag = #False
      ;         _this_\state\flag | #__S_drag 
      ;         
      ;         DoEvents( _this_, #PB_EventType_DragStart )
      ;         
      ;         If _DD_drag_( ) And Not _this_\container
      ;           DD_cursor( _this_, #PB_Cursor_Drag )
      ;           
      ;           _result_ = #True
      ;         Else
      ;           ;           If transform( ) And transform( )\index = #__a_moved 
      ;           ;               Debug "move - cursor"
      ;           ;             set_cursor_( _this_, #PB_Cursor_Arrows )
      ;           ;           ElseIf transform( ) And transform( )\type
      ;           ;             If Not ( transform( ) And transform( )\index )
      ;           ;               Debug "move drag - cursor"
      ;           ;               set_cursor_( _this_, #PB_Cursor_Cross )
      ;           ;             EndIf
      ;           ;           EndIf
      ;         EndIf
      ;       EndIf
    EndMacro
    
    Macro _DD_event_drop_( _result_, _this_ )
      ;       If PressedWidget( )\state\flag & #__S_drag
      ;         PressedWidget( )\state\flag &~ #__S_drag
      ;         
      ;         Debug "drag - cursor - reset"
      ;         set_cursor_( _this_, _this_\cursor )
      ;         
      ;         ;
      ;         If PressedWidget( )\container And 
      ;            Not ( transform( ) And transform( )\index )
      ;           _this_ = PressedWidget( )
      ;         EndIf
      ;         
      ;         If _DD_drag_( )
      ;           
      ;           ; drag stop 
      ;           If _DD_action_( _this_ )
      ;             If transform( ) And
      ;                transform( )\type
      ;               
      ;               _DD_drag_( )\x = transform( )\id[0]\x - _this_\x[#__c_inner]
      ;               _DD_drag_( )\y = transform( )\id[0]\y - _this_\y[#__c_inner]
      ;               
      ;               _DD_drag_( )\width = transform( )\id[0]\width 
      ;               _DD_drag_( )\height = transform( )\id[0]\height 
      ;               
      ;               transform( )\type = 0
      ;             Else
      ;               _DD_drag_( )\x = Mouse( )\x - _this_\x[#__c_inner]
      ;               _DD_drag_( )\y = Mouse( )\y - _this_\y[#__c_inner]
      ;             EndIf
      ;             
      ;             DoEvents( _this_, #PB_EventType_Drop )
      ;           EndIf
      ;           
      ;           ; reset
      ;           FreeStructure( _DD_drag_( )) : _DD_drag_( ) = #Null
      ;           _DD_event_leave_( _result_, _this_ )
      ;           
      ;           ;         If _result_
      ;           ;           ;_get_entered_( _result_ )
      ;           ;           EventHandler( )
      ;           PostEventCanvas( _this_\root )
      ;           ;         EndIf
      ;           
      ;         EndIf
      ;       EndIf
    EndMacro
    
    ;
    Procedure.i DD_cursor( *this._S_widget, type )
      Protected x = 2, y = 2, cursor
      UsePNGImageDecoder( )
      
      If type = #PB_Cursor_Drop
        cursor = CatchImage( #PB_Any, ?add, 601 )
      ElseIf type = #PB_Cursor_Drag
        cursor = CatchImage( #PB_Any, ?copy, 530 )
      EndIf
      
      set_cursor_( *this, CreateCursor( ImageID( cursor ), x, y ))
      
      ;       If cursor
      ;         If *this\root\canvas\cursor <> cursor
      ;           *this\root\canvas\cursor = cursor
      ;           SetGadgetAttribute( *this\root\canvas\gadget, #PB_Canvas_CustomCursor, func::CreateCursor( ImageID( cursor ), x, y ))
      ;         EndIf
      ;       EndIf
      
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
    
    Procedure   DD_draw( *this._S_widget )
      ; if you drag to the widget-dropped
      If _DD_drag_( ) And *this\state\flag & #__S_drop
        
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        
        If _DD_drop_( EnteredWidget( ) ) ; *this\drop 
          If _DD_action_( EnteredWidget( ) )
            If EnteredRow( *this ) And EnteredRow( *this )\state\enter
              DrawBox_( EnteredRow( *this )\x, EnteredRow( *this )\y, EnteredRow( *this )\width, EnteredRow( *this )\height, $2000ff00 )
            EndIf  
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $1000ff00 )
          Else
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff0000 )
          EndIf
        Else
          If *this\state\flag & #__S_drag 
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff00ff )
          Else
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $100000ff )
          EndIf
        EndIf
        
        DrawingMode_( #PB_2DDrawing_Outlined )
        
        If _DD_drop_( EnteredWidget( ) ) ; *this\drop 
          If _DD_action_( EnteredWidget( ) )
            If EnteredRow( *this ) And EnteredRow( *this )\state\enter
              DrawBox_( EnteredRow( *this )\x, EnteredRow( *this )\y, EnteredRow( *this )\width, EnteredRow( *this )\height, $ff00ff00 )
            EndIf
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff00ff00 )
          Else
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
          EndIf
        Else
          If *this\state\flag & #__S_drag 
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff00ff )
          Else
            DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff0000ff )
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
      If _DD_action_( EnteredWidget( ) ) 
        ProcedureReturn _DD_drop_( EnteredWidget( ) )\format 
      EndIf
    EndProcedure
    
    Procedure.i DD_DropAction( )
      If _DD_action_( EnteredWidget( ) ) 
        ProcedureReturn _DD_drop_( EnteredWidget( ) )\Actions 
      EndIf
    EndProcedure
    
    Procedure.s DD_DropFiles( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop files - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.s DD_DropText( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop text - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.i DD_DropPrivate( )
      If _DD_action_( EnteredWidget( ) )
        Debug "   event drop type - "+_DD_drag_( )\PrivateType
        ProcedureReturn _DD_drag_( )\PrivateType
      EndIf
    EndProcedure
    
    Procedure.i DD_DropImage( Image.i = -1, Depth.i = 24 )
      Protected result.i
      
      If _DD_action_( EnteredWidget( ) ) And _DD_drag_( )\value
        Debug "   event drop image - "+_DD_drag_( )\value
        
        If Image  = - 1
          Result = CreateImage( #PB_Any, _DD_drag_( )\Width, _DD_drag_( )\Height ) : Image = Result
        Else
          Result = IsImage( Image )
        EndIf
        
        If Result And StartDrawing( ImageOutput( Image ))
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
        
        ;         If StartDrawing( ImageOutput( ID ))
        DrawingMode_( #PB_2DDrawing_AllChannels )
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
        
        ;           StopDrawing( )
        ;         EndIf
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
    
    Macro a_is_at_point_( _this_ )
      ( _this_ And _this_\_a_\id And _this_\_a_\id\index And (( _this_\_a_\id\index <> #__a_moved ) Or ( _this_\container And _this_\_a_\id\index = #__a_moved )))
      ; ( _this_ And _this_\_a_\id And _this_\_a_\id\index And _this_\_a_\id\index <> #__a_moved )
    EndMacro
    
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
    
    Macro a_move( _address_, _x_, _y_, _width_, _height_, _a_moved_type_ )
      If _address_[0] ; frame
        _address_[0]\x = _x_ + transform( )\pos
        _address_[0]\y = _y_ + transform( )\pos
        _address_[0]\width = _width_ - transform( )\pos * 2
        _address_[0]\height = _height_ - transform( )\pos * 2
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
          _address_[#__a_moved]\width = transform( )\size * 2
          _address_[#__a_moved]\height = transform( )\size * 2
        Else
          _address_[#__a_moved]\x = _x_ + transform( )\pos
          _address_[#__a_moved]\y = _y_ + transform( )\pos
          _address_[#__a_moved]\width = _width_ - transform( )\pos * 2
          _address_[#__a_moved]\height = _height_ - transform( )\pos * 2
        EndIf
        ;Debug _address_[#__a_moved]\height
      EndIf
      
      If a_focus_widget( ) And 
         transform( )\id[10] And 
         transform( )\id[11] And
         transform( )\id[12] And
         transform( )\id[13]
        ;a_lines( a_focus_widget( ) )
        
        transform( )\id[10]\color\state = 0
        transform( )\id[11]\color\state = 0
        transform( )\id[12]\color\state = 0
        transform( )\id[13]\color\state = 0
        
        ; line size
        transform( )\id[10]\width = 1
        transform( )\id[11]\height = 1
        transform( )\id[12]\width = 1
        transform( )\id[13]\height = 1
        
        ;
        transform( )\id[10]\height = a_focus_widget( )\height[#__c_frame]
        transform( )\id[11]\width = a_focus_widget( )\width[#__c_frame]
        transform( )\id[12]\height = a_focus_widget( )\height[#__c_frame]
        transform( )\id[13]\width = a_focus_widget( )\width[#__c_frame]
        
        ; line pos
        transform( )\id[10]\x = a_focus_widget( )\x[#__c_frame]
        transform( )\id[10]\y = a_focus_widget( )\y[#__c_frame]
        
        transform( )\id[11]\x = a_focus_widget( )\x[#__c_frame]
        transform( )\id[11]\y = a_focus_widget( )\y[#__c_frame]
        
        transform( )\id[12]\x = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - transform( )\id[12]\width
        transform( )\id[12]\y = a_focus_widget( )\y[#__c_frame]
        
        transform( )\id[13]\x = a_focus_widget( )\x[#__c_frame]
        transform( )\id[13]\y = (a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]) - transform( )\id[13]\height
        
        If ListSize( Widget( ))
          ;PushListPosition( Widget( ))
          ForEach Widget( )
            If Not Widget( )\hide And Widget( )\_a_\transform And
               is_parent_one_( Widget( ), a_focus_widget( ))
              
              ;Left_line
              If a_focus_widget( )\x[#__c_frame] = Widget( )\x[#__c_frame]
                If transform( )\id[10]\y > Widget( )\y[#__c_frame] 
                  transform( )\id[10]\y = Widget( )\y[#__c_frame] 
                EndIf
                If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] < Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame]
                  transform( )\id[10]\height = ( Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame] ) - transform( )\id[10]\y
                Else
                  transform( )\id[10]\height = ( a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] ) - transform( )\id[10]\y
                EndIf
                
                transform( )\id[10]\color\state = 2
              EndIf
              
              ;Right_line
              If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] = Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame]
                If transform( )\id[12]\y > Widget( )\y[#__c_frame] 
                  transform( )\id[12]\y = Widget( )\y[#__c_frame] 
                EndIf
                If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] < Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame] 
                  transform( )\id[12]\height = (Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame]) - transform( )\id[12]\y
                Else
                  transform( )\id[12]\height = (a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]) - transform( )\id[12]\y
                EndIf
                
                transform( )\id[12]\color\state = 2
              EndIf
              
              ;Top_line
              If a_focus_widget( )\y[#__c_frame] = Widget( )\y[#__c_frame] 
                If transform( )\id[11]\x > Widget( )\x[#__c_frame] 
                  transform( )\id[11]\x = Widget( )\x[#__c_frame] 
                EndIf
                If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] < Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame]
                  transform( )\id[11]\width = (Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame]) - transform( )\id[11]\x
                Else
                  transform( )\id[11]\width = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - transform( )\id[11]\x
                EndIf
                
                transform( )\id[11]\color\state = 1
              EndIf
              
              ;Bottom_line
              If a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame] = Widget( )\y[#__c_frame] + Widget( )\height[#__c_frame]
                If transform( )\id[13]\x > Widget( )\x[#__c_frame] 
                  transform( )\id[13]\x = Widget( )\x[#__c_frame] 
                EndIf
                If a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame] < Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame] 
                  transform( )\id[13]\width = (Widget( )\x[#__c_frame] + Widget( )\width[#__c_frame]) - transform( )\id[13]\x
                Else
                  transform( )\id[13]\width = (a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]) - transform( )\id[13]\x
                EndIf
                
                transform( )\id[13]\color\state = 1
              EndIf
            EndIf
          Next
          ;PopListPosition( Widget( ))
        EndIf
      EndIf
      
    EndMacro
    
    Macro a_size_auto( _this_, _size_ )
      ; auto size
      transform( )\size = _size_
      ;_this_\bs = _this_\fs + transform( )\pos
      If _this_\container And _this_\fs > 1 : transform( )\size + _this_\fs : EndIf
      ;
      a_size( _this_\_a_\id, transform( )\size )
    EndMacro
    
    Macro a_resize( _this_, _size_ )
      If _this_\_a_\transform
        a_size_auto( _this_, _size_ )
        a_move( _this_\_a_\id,
                _this_\x[#__c_screen],
                _this_\y[#__c_screen], 
                _this_\width[#__c_screen], 
                _this_\height[#__c_screen], _this_\container )
      EndIf
    EndMacro
    
    Macro a_draw_box( _address_ )
      DrawingMode_( #PB_2DDrawing_Outlined )
      
      If _address_ = a_focus_widget( )\_a_\id
        a_draw_line( a_focus_widget( ))
      Else
        If _address_[0] :DrawBox_( _address_[0]\x, _address_[0]\y, _address_[0]\width, _address_[0]\height ,_address_[0]\color\back[_address_[0]\color\state] ) : EndIf
      EndIf
      
      ;If _address_\container 
      If _address_[#__a_moved] And ( _address_[#__a_moved]\width <> _address_[0]\width And _address_[#__a_moved]\height <> _address_[0]\height  )
        DrawBox_( _address_[#__a_moved]\x, _address_[#__a_moved]\y, _address_[#__a_moved]\width, _address_[#__a_moved]\height, _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] ) 
      EndIf
      ;EndIf
      
      DrawingModeAlpha_( #PB_2DDrawing_Default )
      
      ; draw background anchors
      If _address_[1] :DrawBox_( _address_[1]\x, _address_[1]\y, _address_[1]\width, _address_[1]\height ,_address_[1]\color\back[_address_[1]\color\state] ) : EndIf
      If _address_[2] :DrawBox_( _address_[2]\x, _address_[2]\y, _address_[2]\width, _address_[2]\height ,_address_[2]\color\back[_address_[2]\color\state] ) : EndIf
      If _address_[3] :DrawBox_( _address_[3]\x, _address_[3]\y, _address_[3]\width, _address_[3]\height ,_address_[3]\color\back[_address_[3]\color\state] ) : EndIf
      If _address_[4] :DrawBox_( _address_[4]\x, _address_[4]\y, _address_[4]\width, _address_[4]\height ,_address_[4]\color\back[_address_[4]\color\state] ) : EndIf
      If _address_[5] :DrawBox_( _address_[5]\x, _address_[5]\y, _address_[5]\width, _address_[5]\height ,_address_[5]\color\back[_address_[5]\color\state] ) : EndIf
      If _address_[6] :DrawBox_( _address_[6]\x, _address_[6]\y, _address_[6]\width, _address_[6]\height ,_address_[6]\color\back[_address_[6]\color\state] ) : EndIf
      If _address_[7] :DrawBox_( _address_[7]\x, _address_[7]\y, _address_[7]\width, _address_[7]\height ,_address_[7]\color\back[_address_[7]\color\state] ) : EndIf
      If _address_[8] :DrawBox_( _address_[8]\x, _address_[8]\y, _address_[8]\width, _address_[8]\height ,_address_[8]\color\back[_address_[8]\color\state] ) : EndIf
      
      DrawingMode_( #PB_2DDrawing_Outlined )
      
      ; draw frame anchors
      If _address_[1] :DrawBox_( _address_[1]\x, _address_[1]\y, _address_[1]\width, _address_[1]\height, _address_[1]\color\frame[_address_[1]\color\state] ) : EndIf
      If _address_[2] :DrawBox_( _address_[2]\x, _address_[2]\y, _address_[2]\width, _address_[2]\height, _address_[2]\color\frame[_address_[2]\color\state] ) : EndIf
      If _address_[3] :DrawBox_( _address_[3]\x, _address_[3]\y, _address_[3]\width, _address_[3]\height, _address_[3]\color\frame[_address_[3]\color\state] ) : EndIf
      If _address_[4] :DrawBox_( _address_[4]\x, _address_[4]\y, _address_[4]\width, _address_[4]\height, _address_[4]\color\frame[_address_[4]\color\state] ) : EndIf
      If _address_[5] :DrawBox_( _address_[5]\x, _address_[5]\y, _address_[5]\width, _address_[5]\height, _address_[5]\color\frame[_address_[5]\color\state] ) : EndIf
      If _address_[6] :DrawBox_( _address_[6]\x, _address_[6]\y, _address_[6]\width, _address_[6]\height, _address_[6]\color\frame[_address_[6]\color\state] ) : EndIf
      If _address_[7] :DrawBox_( _address_[7]\x, _address_[7]\y, _address_[7]\width, _address_[7]\height, _address_[7]\color\frame[_address_[7]\color\state] ) : EndIf
      If _address_[8] :DrawBox_( _address_[8]\x, _address_[8]\y, _address_[8]\width, _address_[8]\height, _address_[8]\color\frame[_address_[8]\color\state] ) : EndIf
    EndMacro
    
    Macro a_draw_line( _address_ )
      ; left line
      If transform( )\id[10] 
        If a_focus_widget( )\_a_\id[#__a_moved] And transform( )\id[10]\y = a_focus_widget( )\y[#__c_frame] And transform( )\id[10]\height = a_focus_widget( )\height[#__c_frame]
          DrawBox_( transform( )\id[10]\x, transform( )\id[10]\y, transform( )\id[10]\width, transform( )\id[10]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
        Else
          DrawBox_( transform( )\id[10]\x, transform( )\id[10]\y, transform( )\id[10]\width, transform( )\id[10]\height ,transform( )\id[10]\color\frame[transform( )\id[10]\color\state] ) 
        EndIf
      EndIf
      
      ; top line
      If transform( )\id[12] 
        If a_focus_widget( )\_a_\id[#__a_moved] And transform( )\id[12]\y = a_focus_widget( )\y[#__c_frame] And transform( )\id[12]\height = a_focus_widget( )\height[#__c_frame]
          DrawBox_( transform( )\id[12]\x, transform( )\id[12]\y, transform( )\id[12]\width, transform( )\id[12]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
        Else
          DrawBox_( transform( )\id[12]\x, transform( )\id[12]\y, transform( )\id[12]\width, transform( )\id[12]\height ,transform( )\id[12]\color\frame[transform( )\id[12]\color\state] ) 
        EndIf
      EndIf
      
      ; right line
      If transform( )\id[11] 
        If a_focus_widget( )\_a_\id[#__a_moved] And transform( )\id[11]\x = a_focus_widget( )\x[#__c_frame] And transform( )\id[11]\width = a_focus_widget( )\width[#__c_frame]
          DrawBox_( transform( )\id[11]\x, transform( )\id[11]\y, transform( )\id[11]\width, transform( )\id[11]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
        Else
          DrawBox_( transform( )\id[11]\x, transform( )\id[11]\y, transform( )\id[11]\width, transform( )\id[11]\height ,transform( )\id[11]\color\frame[transform( )\id[11]\color\state] ) 
        EndIf
      EndIf
      
      ; bottom line
      If transform( )\id[13] 
        If a_focus_widget( )\_a_\id[#__a_moved] And transform( )\id[13]\x = a_focus_widget( )\x[#__c_frame] And transform( )\id[13]\width = a_focus_widget( )\width[#__c_frame]
          DrawBox_( transform( )\id[13]\x, transform( )\id[13]\y, transform( )\id[13]\width, transform( )\id[13]\height ,a_focus_widget( )\_a_\id[#__a_moved]\color\frame[a_focus_widget( )\_a_\id[#__a_moved]\color\state] ) 
        Else
          DrawBox_( transform( )\id[13]\x, transform( )\id[13]\y, transform( )\id[13]\width, transform( )\id[13]\height ,transform( )\id[13]\color\frame[transform( )\id[13]\color\state] ) 
        EndIf
      EndIf
    EndMacro
    
    Macro a_draw( _address_ )
      DrawingModeAlpha_( #PB_2DDrawing_Default )
      
      ; draw grab background 
      If transform( )\grab
        DrawImage( ImageID( transform( )\grab ), 0,0 )
        If Not transform( )\type
          CustomFilterCallback( @Draw_Datted( ))
        EndIf 
      EndIf
      
      ; clip drawing coordinate
      ;;_content_clip_( transform( )\main, [#__c_clip2] )
      
      If transform( )\grab
        If transform( )\id[0]\color\back[0]
          DrawBox_( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\back[0] )
        EndIf
        
        If transform( )\type
          DrawText( transform( )\id[0]\x + 3, transform( )\id[0]\y + 1, Str( transform( )\id[0]\width ) +"x"+ Str( transform( )\id[0]\height ), transform( )\id[0]\color\front[0], transform( )\id[0]\color\back[0] )
          
          If transform( )\id[0]\color\frame[0]
            DrawingMode_( #PB_2DDrawing_Outlined )
            DrawBox_( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\frame[0] )
          EndIf
        Else
          DrawingMode_( #PB_2DDrawing_CustomFilter | #PB_2DDrawing_Outlined ) 
          DrawBox_( transform( )\id[0]\x, transform( )\id[0]\y, transform( )\id[0]\width, transform( )\id[0]\height, transform( )\id[0]\color\frame[0] ) 
        EndIf
      Else
        ; draw back transparent
        If a_focus_widget( ) And a_focus_widget( )\_a_\transform =- 1 And transform( )\id[0]\width And transform( )\id[0]\height And transform( )\id[0]\color\back[0]
          DrawBox_(  a_focus_widget( )\_a_\id[#__a_moved]\x,  a_focus_widget( )\_a_\id[#__a_moved]\y,  a_focus_widget( )\_a_\id[#__a_moved]\width,  a_focus_widget( )\_a_\id[#__a_moved]\height,  a_focus_widget( )\_a_\id[0]\color\back[0] )
          ;DrawBox_( transform( )\id[0]\x+transform( )\pos, transform( )\id[0]\y+transform( )\pos, transform( )\id[0]\width-transform( )\pos*2, transform( )\id[0]\height-transform( )\pos*2, transform( )\id[0]\color\frame[0] )
        EndIf
      EndIf
      
      ; draw anchor buttons
      a_draw_box( _address_\_a_\id )
      
    EndMacro
    
    Macro a_remove( _this_, _index_ )
      For _index_ = 0 To #__a_moved
        If _this_\_a_\id[_index_]
          FreeStructure( _this_\_a_\id[_index_] )
          _this_\_a_\id[_index_] = #Null
        EndIf
      Next
    EndMacro
    
    Macro a_add( _result_, _this_, _index_ )
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
        
        _this_\_a_\id[_index_]\color\back[#__S_0] = $ffFFFFFF
        _this_\_a_\id[_index_]\color\back[#__S_1] = $80FF0000 
        _this_\_a_\id[_index_]\color\back[#__S_2] = $800000FF
      Next _index_
    EndMacro
    
    Procedure.i a_set( *this._S_widget, size.l = #__a_size, position.l = #PB_Ignore )
      Protected value, result.i, i
      Static *before._S_widget
      ; 
      If *this = transform( )\main And a_focus_widget( )
        *this = transform( )\main\first\widget
      EndIf
      
      ;
      If *this And ( *this\_a_\transform =- 1 And Not transform( )\index ) Or
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
          ;           If *this <> *this\parent\widget\last\widget
          ;             SetPosition( *this, #PB_List_Last ) 
          ;           EndIf
          
          ;
          a_remove( a_focus_widget( ), i ) 
        EndIf
        
        ; a_add
        a_add( result, *this, i )
        a_grid_change( *this\parent\widget )
        
        
        If position = #PB_Ignore
          transform( )\pos = size - size / 3 - 2
        Else
          transform( )\pos = position
        EndIf
        
        *this\bs = transform( )\pos + *this\fs
        
        result = a_focus_widget( )
        a_focus_widget( ) = *this
        FocusedWidget( ) = *this
        
        a_resize( *this, size )
        
        ; reset entered anchor index
        transform( )\index = 0 
        
        ; get transform index
        ;a_index( value, *this\_a_\id, i )
        For i = 1 To #__a_moved 
          If *this\_a_\id[i]  
            If is_at_point_( *this\_a_\id[i], Mouse( )\x, Mouse( )\y ) 
              
              If *this\_a_\id[i]\color\state <> #__S_1
                ;set_cursor_( a_focus_widget( ), *this\_a_\id[i]\cursor )
                *this\_a_\id[i]\color\state = #__S_1
                value = 1
              EndIf
              
              transform( )\index = i
              Break
              
            ElseIf *this\_a_\id[i]\color\state <> #__S_0
              ;set_cursor_( a_focus_widget( ), #PB_Cursor_Default )
              *this\_a_\id[i]\color\state = #__S_0
              transform( )\index = 0
              value = 1
            EndIf
          EndIf
        Next
        
        ;
        Post( *this, #PB_EventType_StatusChange, transform( )\index )
        If Not result
          result =- 1
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i a_init( *this._S_widget, grid_size.a = 7, grid_type.b = 0 )
      Protected i
      
      If Not *this\_a_\transform
        *this\_a_\transform = #True
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
    
    Procedure   a_update( *parent._S_widget )
      If *parent\_a_\transform = 1 ; Not ListSize( transform( )\group( ))
                                  ; check transform group
        ForEach Widget( )
          If Widget( ) <> *parent And ; IsChild( widget( ), *parent ) And 
             is_parent_( Widget( ), *parent ) And 
             is_inter_sect_( Widget( ), transform( )\id[0], [#__c_frame] )
            
            ; Debug " -- "+widget( )\class +"_"+ widget( )\count\index 
            
            Widget( )\_a_\transform = 2
            Widget( )\root\_a_\transform =- 1
            Widget( )\parent\widget\_a_\transform =- 1
          EndIf
        Next
        
        ; reset
        transform( )\id[0]\x = 0
        transform( )\id[0]\y = 0
        transform( )\id[0]\width = 0
        transform( )\id[0]\height = 0
        ; ClearList( transform( )\group( ))
        
        ; init min group pos
        ForEach Widget( )
          If Widget( )\_a_\transform = 2
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
          If Widget( )\_a_\transform = 2
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
          If Widget( )\_a_\transform = 2
            If AddElement( transform( )\group( ))
              transform( )\group.allocate( GROUP, ( ))
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
      a_size( transform( )\id, transform( )\size )
      a_move( transform( )\id, 
              transform( )\id[0]\x - transform( )\pos, 
              transform( )\id[0]\y - transform( )\pos, 
              transform( )\id[0]\width + transform( )\pos*2, 
              transform( )\id[0]\height + transform( )\pos*2, 0 )
      
    EndProcedure
    
    Procedure   a_events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      If transform( )  
        Static xx, yy, *before
        Static move_x, move_y
        Protected Repaint, i
        Protected mxw, myh
        Protected.l mx, my, mw, mh
        Protected.l Px,Py, IsGrid = Bool( transform( )\grid\size>1 )
        
        Protected text.s
        
        ;
        ; a_hide
        If eventtype = #PB_EventType_MouseLeave
          Debug " a-#PB_EventType_MouseLeave"
          
          If *this <> a_focus_widget( )
            a_remove( *this, i )
            a_enter_widget( ) = #Null
            Repaint = #True
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_MouseEnter
          Debug " a-#PB_EventType_MouseEnter"
          
          If *this <> a_enter_widget( )
            ; a_hide
            If a_enter_widget( ) And 
               a_focus_widget( ) <> a_enter_widget( )
              
              If Not a_is_at_point_( a_enter_widget( ) )
                a_remove( a_enter_widget( ), i )
                a_enter_widget( ) = #Null
                Repaint = #True
              EndIf
            EndIf
            
            a_enter_widget( ) = *this
            
            a_add( Repaint, *this, i )
            a_resize( *this, #__a_size )
            
            If *this\_a_\id[0]\color\state <> #__S_1
              *this\_a_\id[0]\color\state = #__S_1
            EndIf
            
            Repaint = #True
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          If a_focus_widget( )
            ; return layout position
            If *before
              Repaint = SetPosition( a_focus_widget( ), #PB_List_After, *before ) 
            Else 
              Repaint = SetPosition( a_focus_widget( ), #PB_List_First ) 
            EndIf
            
            If a_focus_widget( )\_a_\id[transform( )\index] 
              If is_at_point_(  a_focus_widget( )\_a_\id[transform( )\index], mouse_x, mouse_y )
                a_focus_widget( )\_a_\id[transform( )\index]\color\state = #__S_1
              Else
                a_focus_widget( )\_a_\id[transform( )\index]\color\state = #__S_0
              EndIf
              Repaint = #True
            EndIf
            
            If *this = transform( )\main
              a_focus_widget( ) = #Null
            EndIf
          EndIf
          ;  Repaint = #True
          
          ; init multi group selector
          If transform( )\grab And Not transform( )\type 
            a_update( *this )
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown 
          If *this = transform( )\main
            If a_focus_widget( )
              *before = GetPosition( a_focus_widget( ), #PB_List_Before )
              a_remove( a_focus_widget( ), i ) 
            EndIf
          Else
            ; get layout current position
            *before = GetPosition( *this, #PB_List_Before )
            ; set layout last position
            If *this <> *this\parent\widget\last\widget
              Repaint = SetPosition( *this, #PB_List_Last ) 
            EndIf
            
            ; set current transformer
            If a_set( *this )
              a_reset( )
              Repaint = #True
            EndIf
          EndIf
          
          ; change frame color
          If transform( )\type > 0
            transform( )\id[0]\color\back = $9F646565
            transform( )\id[0]\color\frame = $BA161616
            transform( )\id[0]\color\front = $ffffffff
          Else
            transform( )\dotted\dot = 1 
            transform( )\dotted\space = 3
            transform( )\dotted\line = 5
            
            transform( )\id[0]\color\back = $80DFE2E2 
            transform( )\id[0]\color\frame = $BA161616
          EndIf
          
          If transform( )\index And a_focus_widget( )\_a_\id
            ; set current transform index
            a_focus_widget( )\_a_\id[transform( )\index]\color\state = #__S_2
            
            ; 
            ; set delta pos
            ;
            If a_focus_widget( )\parent\widget 
              If a_focus_widget( )\_a_\transform = 1
                If Not ( a_focus_widget( )\attach And a_focus_widget( )\attach\mode = 2 )
                  mouse_x + a_focus_widget( )\parent\widget\x[#__c_inner]
                EndIf
                If Not ( a_focus_widget( )\attach And a_focus_widget( )\attach\mode = 1 )
                  mouse_y + a_focus_widget( )\parent\widget\y[#__c_inner]
                EndIf
                
                If Not is_integral_( a_focus_widget( ))
                  mouse_x - scroll_x_( a_focus_widget( )\parent\widget )
                  mouse_y - scroll_y_( a_focus_widget( )\parent\widget )
                EndIf
              EndIf
            EndIf
            Mouse( )\delta\x = mouse_x - a_focus_widget( )\_a_\id[transform( )\index]\x
            Mouse( )\delta\y = mouse_y - a_focus_widget( )\_a_\id[transform( )\index]\y
            
            ;
            If Not ( a_focus_widget( )\container = 0 And transform( )\index = #__a_moved )
              ; horizontal
              Select transform( )\index
                Case 1, 5, 8, #__a_moved ; left
                  Mouse( )\delta\x - transform( )\pos - a_focus_widget( )\parent\widget\fs
                  
                Case 3, 6, 7 ; right
                  Mouse( )\delta\x - ( transform( )\size-transform( )\pos )
              EndSelect
              
              ; vertical
              Select transform( )\index
                Case 2, 5, 6, #__a_moved ; top
                  Mouse( )\delta\y - transform( )\pos - a_focus_widget( )\parent\widget\fs
                  
                Case 4, 8, 7 ; bottom
                  Mouse( )\delta\y - ( transform( )\size-transform( )\pos ) 
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
              mouse_x = (( mouse_x ) / transform( )\grid\size ) * transform( )\grid\size
              mouse_y = (( mouse_y ) / transform( )\grid\size ) * transform( )\grid\size 
            EndIf
            
            ; set delta pos
            Mouse( )\delta\x = mouse_x
            Mouse( )\delta\y = mouse_y
          EndIf
          
          ;
          If a_is_at_point_( *this )
            Repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_DragStart 
          
          If transform( )\index = #__a_moved And a_focus_widget( )\_a_\id[#__a_moved]
            set_cursor_( *this, a_focus_widget( )\_a_\id[#__a_moved]\cursor )
          EndIf
          
          If *this\container And 
             Not transform( )\index And 
             is_at_point_( *this, mouse_x, mouse_y, [#__c_inner] )
            
            a_grid_change( *this, #True )
            set_cursor_( *this, #PB_Cursor_Cross )
            
            If StartDrawing( CanvasOutput( *this\root\canvas\gadget ))
              transform( )\grab = GrabDrawingImage( #PB_Any, 0,0, *this\root\width, *this\root\height )
              StopDrawing( )
            EndIf
          EndIf
        EndIf
        
        ; 
        If eventtype = #PB_EventType_MouseMove
          If Not transform( )\grab And a_focus_widget( )
            If Mouse( )\buttons And transform( )\index And a_focus_widget( )\_a_\id[transform( )\index] And a_focus_widget( )\_a_\id[transform( )\index]\color\state = #__S_2
              mouse_x - Mouse( )\delta\x
              mouse_y - Mouse( )\delta\y
              
              If transform( )\grid\size > 0
                mouse_x = ( mouse_x / transform( )\grid\size ) * transform( )\grid\size
                mouse_y = ( mouse_y / transform( )\grid\size ) * transform( )\grid\size
              EndIf
              
              If xx <> mouse_x Or yy <> mouse_y : xx = mouse_x : yy = mouse_y
                
                If a_focus_widget( )\_a_\transform = 1
                  mw = #PB_Ignore
                  mh = #PB_Ignore
                  
                  If transform( )\index = #__a_moved   
                    ; move boundaries
                    If a_focus_widget( )\bounds\move
                      If a_focus_widget( )\bounds\move\x\min <> #PB_Ignore And
                         mouse_x <= a_focus_widget( )\bounds\move\x\min
                        mouse_x = a_focus_widget( )\bounds\move\x\min
                      EndIf
                      If a_focus_widget( )\bounds\move\x\max <> #PB_Ignore And
                         mouse_x >= a_focus_widget( )\bounds\move\x\max - a_focus_widget( )\width[#__c_frame]
                        mouse_x = a_focus_widget( )\bounds\move\x\max - a_focus_widget( )\width[#__c_frame]
                      EndIf
                      If a_focus_widget( )\bounds\move\y\min <> #PB_Ignore And 
                         mouse_y <= a_focus_widget( )\bounds\move\y\min
                        mouse_y = a_focus_widget( )\bounds\move\y\min
                      EndIf
                      If a_focus_widget( )\bounds\move\y\max <> #PB_Ignore And
                         mouse_y >= a_focus_widget( )\bounds\move\y\max - a_focus_widget( )\height[#__c_frame]
                        mouse_y = a_focus_widget( )\bounds\move\y\max - a_focus_widget( )\height[#__c_frame]
                      EndIf
                    EndIf
                    
                  Else
                    ; horizontal 
                    Select transform( )\index
                      Case 1, 5, 8 ; left
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move
                          If a_focus_widget( )\bounds\move\x\min <> #PB_Ignore And
                             mouse_x <= a_focus_widget( )\bounds\move\x\min
                            mouse_x = a_focus_widget( )\bounds\move\x\min
                          EndIf
                        EndIf
                        mw = ( a_focus_widget( )\x[#__c_container] - mouse_x ) + a_focus_widget( )\width[#__c_frame] + (a_focus_widget( )\parent\widget\fs); - a_focus_widget( )\fs[1])
                        If mw <= 0
                          mw = 0
                          mouse_x = a_focus_widget( )\x[#__c_frame] + a_focus_widget( )\width[#__c_frame]
                        EndIf
                        
                      Case 3, 6, 7 ; right
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move And 
                           a_focus_widget( )\bounds\move\x\max <> #PB_Ignore And
                           mouse_x >= a_focus_widget( )\bounds\move\x\max 
                          mouse_x = a_focus_widget( )\bounds\move\x\max
                        EndIf
                        mw = ( mouse_x - a_focus_widget( )\x[#__c_container] ) + IsGrid 
                    EndSelect
                    
                    ; vertical
                    Select transform( )\index
                      Case 2, 5, 6 ; top
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move
                          If a_focus_widget( )\bounds\move\y\min <> #PB_Ignore And
                             mouse_y <= a_focus_widget( )\bounds\move\y\min
                            mouse_y = a_focus_widget( )\bounds\move\y\min
                          EndIf
                        EndIf
                        mh = ( a_focus_widget( )\y[#__c_container] - mouse_y ) + a_focus_widget( )\height[#__c_frame] + (a_focus_widget( )\parent\widget\fs); - a_focus_widget( )\fs[2])
                        If mh <= 0
                          mh = 0
                          mouse_y = a_focus_widget( )\y[#__c_frame] + a_focus_widget( )\height[#__c_frame]
                        EndIf
                        
                      Case 4, 8, 7 ; bottom 
                                   ; move boundaries
                        If a_focus_widget( )\bounds\move And 
                           a_focus_widget( )\bounds\move\y\max <> #PB_Ignore And
                           mouse_y >= a_focus_widget( )\bounds\move\y\max 
                          mouse_y = a_focus_widget( )\bounds\move\y\max
                        EndIf
                        mh = ( mouse_y - a_focus_widget( )\y[#__c_container] ) + IsGrid
                    EndSelect
                    
                    ;
                    If transform( )\index <> 5
                      If transform( )\index <> 1 And transform( )\index <> 8
                        mouse_x = #PB_Ignore
                      EndIf
                      If transform( )\index <> 2 And transform( )\index <> 6
                        mouse_y = #PB_Ignore
                      EndIf
                    EndIf
                    
                    If a_focus_widget( )\bounds\size 
                      ; size boundaries
                      If (( a_focus_widget( )\bounds\size\width\min <> #PB_Ignore And mw <= a_focus_widget( )\bounds\size\width\min ) Or
                          ( a_focus_widget( )\bounds\size\width\max <> #PB_Ignore And mw >= a_focus_widget( )\bounds\size\width\max ))
                        mw = #PB_Ignore
                        mouse_x = #PB_Ignore
                      EndIf
                      ; size boundaries
                      If (( a_focus_widget( )\bounds\size\height\min <> #PB_Ignore And mh <= a_focus_widget( )\bounds\size\height\min ) Or
                          ( a_focus_widget( )\bounds\size\height\max <> #PB_Ignore And mh >= a_focus_widget( )\bounds\size\height\max ))
                        mh = #PB_Ignore
                        mouse_y = #PB_Ignore
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint | Resize( a_focus_widget( ), mouse_x, mouse_y, mw, mh )
                  
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
                  
                  ;;a_resize_( Repaint, transform( )\id[0]\x,transform( )\id[0]\y,transform( )\id[0]\width,transform( )\id[0]\height )
                  
                  ; multi resize
                  ;                   transform( )\id[0]\x = _x_
                  ;                   transform( )\id[0]\y = _y_
                  ;                   
                  ;                   transform( )\id[0]\width = _width_
                  ;                   transform( )\id[0]\height = _height_
                  
                  a_move( transform( )\id, 
                          transform( )\id[0]\x - transform( )\pos, 
                          transform( )\id[0]\y - transform( )\pos, 
                          transform( )\id[0]\width + transform( )\pos*2, 
                          transform( )\id[0]\height + transform( )\pos*2, 0)
                  
                  Select transform( )\index
                    Case 1, 5, 8, #__a_moved ; left
                      ForEach transform( )\group( )
                        Repaint | Resize( transform( )\group( )\widget, 
                                          ( transform( )\id[0]\x - a_focus_widget( )\x[#__c_inner] ) + transform( )\group( )\x,
                                          #PB_Ignore, transform( )\id[0]\width - transform( )\group( )\width, #PB_Ignore )
                      Next
                      
                    Case 3, 6, 7 ; right
                      ForEach transform( )\group( )
                        Repaint | Resize( transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, transform( )\id[0]\width - transform( )\group( )\width, #PB_Ignore )
                      Next
                  EndSelect
                  
                  Select transform( )\index
                    Case 2, 5, 6, #__a_moved ; top
                      ForEach transform( )\group( )
                        Repaint | Resize( transform( )\group( )\widget, #PB_Ignore, 
                                          ( transform( )\id[0]\y - a_focus_widget( )\y[#__c_inner] ) + transform( )\group( )\y,
                                          #PB_Ignore, transform( )\id[0]\height - transform( )\group( )\height )
                      Next
                      
                    Case 4, 8, 7 ; bottom 
                      ForEach transform( )\group( )
                        Repaint | Resize( transform( )\group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, transform( )\id[0]\height - transform( )\group( )\height )
                      Next
                  EndSelect
                  
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
              If Mouse( )\delta\x > mouse_x
                transform( )\id[0]\x = mouse_x + transform( )\grid\size
                transform( )\id[0]\width = Mouse( )\delta\x - mouse_x
              Else
                transform( )\id[0]\x = Mouse( )\delta\x
                transform( )\id[0]\width = mouse_x - Mouse( )\delta\x
              EndIf
              
              transform( )\id[0]\x + transform( )\main\x[#__c_container]
              If transform( )\grid\size > 0 
                transform( )\id[0]\width + 1 
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
              If Mouse( )\delta\y > mouse_y
                transform( )\id[0]\y = mouse_y + transform( )\grid\size
                transform( )\id[0]\height = Mouse( )\delta\y - mouse_y 
              Else
                transform( )\id[0]\y = Mouse( )\delta\y 
                transform( )\id[0]\height = mouse_y - Mouse( )\delta\y 
              EndIf
              
              transform( )\id[0]\y + transform( )\main\y[#__c_container]
              If transform( )\grid\size > 0 
                transform( )\id[0]\height + 1 
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
              If a_focus_widget( )\parent\widget And
                 a_focus_widget( )\parent\widget\container ;;> 0
                mx + a_focus_widget( )\parent\widget\fs
                my + a_focus_widget( )\parent\widget\fs
              EndIf
              
            Else
              mx = transform( )\id[0]\x
              my = transform( )\id[0]\y
              mw = transform( )\id[0]\width
              mh = transform( )\id[0]\height
            EndIf
            
            Select Keyboard( )\Key[1] 
              Case (#PB_Canvas_Alt | #PB_Canvas_Control), #PB_Canvas_Shift
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left  : mw - transform( )\grid\size : transform( )\index = 3  
                  Case #PB_Shortcut_Right : mw + transform( )\grid\size : transform( )\index = 3
                    
                  Case #PB_Shortcut_Up    : mh - transform( )\grid\size : transform( )\index = 4
                  Case #PB_Shortcut_Down  : mh + transform( )\grid\size : transform( )\index = 4
                EndSelect
                
                Repaint | Resize( a_focus_widget( ), mx, my, mw, mh )
                
              Case (#PB_Canvas_Shift | #PB_Canvas_Control), #PB_Canvas_Alt ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control | #PB_Canvas_Command
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left  : mx - transform( )\grid\size : transform( )\index = #__a_moved
                  Case #PB_Shortcut_Right : mx + transform( )\grid\size : transform( )\index = #__a_moved
                    
                  Case #PB_Shortcut_Up    : my - transform( )\grid\size : transform( )\index = #__a_moved
                  Case #PB_Shortcut_Down  : my + transform( )\grid\size : transform( )\index = #__a_moved
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
                    If a_focus_widget( )\parent\widget
                      Repaint = a_set( a_focus_widget( )\parent\widget )
                    EndIf
                    
                  Case #PB_Shortcut_Right 
                    If a_focus_widget( )\first\widget
                      Repaint = a_set( a_focus_widget( )\first\widget )
                    ElseIf a_focus_widget( )\parent\widget And a_focus_widget( )\parent\widget\last\widget
                      Repaint = a_set( a_focus_widget( )\parent\widget\last\widget )
                    EndIf
                    
                EndSelect
                
            EndSelect
          EndIf
        EndIf
        
        ; 
        Post( *this, eventtype, EnteredRowIndex( *this ) )
        
        If eventtype = #PB_EventType_LeftButtonUp
          transform( )\grab = 0
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  PRIVATEs
    ;-
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
      If _flag_ & #__flag_autosize = #__flag_autosize
        _this_\align.allocate( ALIGN )
        _this_\align\anchor\left = 125
        _this_\align\anchor\top = 125
        _this_\align\anchor\right = 125
        _this_\align\anchor\bottom = 125
        
        
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
    
    Macro set_hide_state_( _this_ )
      _this_\hide = Bool( _this_\hide[1] Or _this_\parent\widget\hide Or ( _this_\parent\widget\type = #__type_Panel And FocusedTabindex( _this_\parent\widget\tab\widget ) <> ParentTabIndex( _this_ ) ))
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
    Procedure  ClipPut( *this._S_widget, x, y, width, height )
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
        *parent = *this\attach\parent\widget
      Else
        *parent = *this\parent\widget
      EndIf
      
      _p_x2_ = *parent\x[#__c_inner] + *parent\width[#__c_inner]
      _p_y2_ = *parent\y[#__c_inner] + *parent\height[#__c_inner]
      
      ; for the splitter childrens
      If *parent\type = #__type_Splitter
        If splitter_first_gadget_( *parent ) = *this
          _p_x2_ = *parent\bar\button[#__split_b1]\x + *parent\bar\button[#__split_b1]\width
          _p_y2_ = *parent\bar\button[#__split_b1]\y + *parent\bar\button[#__split_b1]\height
        EndIf
        If splitter_second_gadget_( *parent ) = *this
          _p_x2_ = *parent\bar\button[#__split_b2]\x + *parent\bar\button[#__split_b2]\width
          _p_y2_ = *parent\bar\button[#__split_b2]\y + *parent\bar\button[#__split_b2]\height
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
      
      
      ; then move and size parent set clip coordinate
      ; x&y - clip screen coordinate  
      If *parent And                                  ;Not is_integral_( *this ) And  
         *parent\x[#__c_inner] > *this\x[#__c_screen] And
         *parent\x[#__c_inner] > *parent\x[#__c_clip]
        *this\x[#__c_clip] = *parent\x[#__c_inner]
      ElseIf *parent And *parent\x[#__c_clip] > *this\x[#__c_screen] 
        *this\x[#__c_clip] = *parent\x[#__c_clip]
      Else
        *this\x[#__c_clip] = *this\x[#__c_screen]
      EndIf
      If *parent And                                  ;Not is_integral_( *this ) And 
         *parent\y[#__c_inner] > *this\y[#__c_screen] And 
         *parent\y[#__c_inner] > *parent\y[#__c_clip]
        *this\y[#__c_clip] = *parent\y[#__c_inner]
      ElseIf *parent And *parent\y[#__c_clip] > *this\y[#__c_screen] 
        *this\y[#__c_clip] = *parent\y[#__c_clip]
      Else
        *this\y[#__c_clip] = *this\y[#__c_screen]
      EndIf
      If *this\x[#__c_clip] < 0 : *this\x[#__c_clip] = 0 : EndIf
      If *this\y[#__c_clip] < 0 : *this\y[#__c_clip] = 0 : EndIf
      
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
      _clip_width_( *this, *parent, *this\x[#__c_screen] + *this\width[#__c_screen], _p_x2_, [#__c_clip] )
      _clip_height_( *this, *parent, *this\y[#__c_screen] + *this\height[#__c_screen], _p_y2_, [#__c_clip] )
      
      ; width&height - clip inner coordinate
      If scroll_width_( *this ) And scroll_width_( *this ) < *this\width[#__c_inner]  
        _clip_width_( *this, *parent, *this\x[#__c_inner] + scroll_width_( *this ), _p_x2_, [#__c_clip2] )
      Else
        _clip_width_( *this, *parent, *this\x[#__c_inner] + *this\width[#__c_inner], _p_x2_, [#__c_clip2] )
      EndIf
      If scroll_height_( *this ) And scroll_height_( *this ) < *this\height[#__c_inner]
        _clip_height_( *this, *parent, *this\y[#__c_inner] + scroll_height_( *this ), _p_y2_, [#__c_clip2] )
      Else
        _clip_height_( *this, *parent, *this\y[#__c_inner] + *this\height[#__c_inner], _p_y2_, [#__c_clip2] )
      EndIf
      
      ;       
      ; clip child bar
      If *this\tab\widget 
        *this\tab\widget\x[#__c_clip] = *this\x[#__c_clip]
        *this\tab\widget\y[#__c_clip] = *this\y[#__c_clip]
        *this\tab\widget\width[#__c_clip] = *this\width[#__c_clip]
        *this\tab\widget\height[#__c_clip] = *this\height[#__c_clip]
      EndIf
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\x[#__c_clip] = *this\x[#__c_clip]
          *this\scroll\v\y[#__c_clip] = *this\y[#__c_clip]
          *this\scroll\v\width[#__c_clip] = *this\width[#__c_clip]
          *this\scroll\v\height[#__c_clip] = *this\height[#__c_clip]
        EndIf
        If *this\scroll\h
          *this\scroll\h\x[#__c_clip] = *this\x[#__c_clip]
          *this\scroll\h\y[#__c_clip] = *this\y[#__c_clip]
          *this\scroll\h\width[#__c_clip] = *this\width[#__c_clip]
          *this\scroll\h\height[#__c_clip] = *this\height[#__c_clip]
        EndIf
      EndIf
      
      
      ProcedureReturn Bool( *this\width[#__c_clip] > 0 And *this\height[#__c_clip] > 0 )
    EndProcedure
    
    Procedure.b Resize( *this._S_widget, x.l,y.l,width.l,height.l )
      Protected.b result
      Protected.l ix,iy,iwidth,iheight,  Change_x, Change_y, Change_width, Change_height
      
      ; 
      If *this\_a_\transform And transform( )
        If *this\bs < *this\fs + transform( )\pos
          *this\bs = *this\fs + transform( )\pos
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
      
      With *this
        ; #__flag_autoSize
        If *this\align And 
           *this\parent\widget And Not is_root_container_( *this ) And 
           *this\parent\widget\type <> #__type_Splitter And
           *this\align\anchor\left = 125 And 
           *this\align\anchor\top = 125 And 
           *this\align\anchor\right = 125 And
           *this\align\anchor\bottom = 125
          
          x = 0
          Y = 0
          width = *this\parent\widget\width[#__c_inner] 
          height = *this\parent\widget\height[#__c_inner]
          
          If is_root_(*this\parent\widget )
            width - *this\fs*2 - *this\fs[1]
            height - *this\fs*2 - *this\fs[2]
          EndIf
        EndIf
        
        ; Debug " resize - "+*this\class
        
        ;
        If transform( ) And 
           transform( )\grid\size And
           *this = a_focus_widget( ) And 
           *this <> transform( )\main ;And 1=3
          
          If x <> #PB_Ignore 
            If transform( )\grid\size > 1
              x + ( x%transform( )\grid\size ) 
              x = ( x/transform( )\grid\size ) * transform( )\grid\size
            EndIf
            If *this\parent\widget And *this\parent\widget\container
              x - *this\parent\widget\fs
            EndIf
          EndIf
          
          If y <> #PB_Ignore 
            If transform( )\grid\size > 1
              y + ( y%transform( )\grid\size ) 
              y = ( y/transform( )\grid\size ) * transform( )\grid\size
            EndIf
            If *this\parent\widget And *this\parent\widget\container
              y - *this\parent\widget\fs
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
          If *this\parent\widget 
            If Not is_integral_( *this )
              x + scroll_x_( *this\parent\widget ) 
            EndIf 
            *this\x[#__c_container] = x
          EndIf 
        EndIf  
        
        If y = #PB_Ignore 
          y = *this\y[#__c_container] 
        Else
          If *this\parent\widget 
            If Not is_integral_( *this )
              y + scroll_y_( *this\parent\widget ) 
            EndIf 
            *this\y[#__c_container] = y
          EndIf 
        EndIf  
        
        If width = #PB_Ignore 
          If *this\type = #__type_window And Not *this\_a_\transform
            width = \width[#__c_container] + \fs*2 + ( *this\fs[1] + *this\fs[3] )
          Else
            width = \width[#__c_frame] 
          EndIf
        Else
          If *this\type = #__type_window And Not *this\_a_\transform
            width + *this\fs*2 + ( *this\fs[1] + *this\fs[3] )
          EndIf
        EndIf  
        If width < 0 
          width = 0 
        EndIf
        
        If height = #PB_Ignore 
          If *this\type = #__type_window And Not *this\_a_\transform 
            height = \height[#__c_container] + \fs*2 + ( *this\fs[2] + *this\fs[4] )
          Else
            height = \height[#__c_frame]
          EndIf
        Else
          If *this\type = #__type_window And Not *this\_a_\transform 
            height + *this\fs*2 + ( *this\fs[2] + *this\fs[4] )
          EndIf
        EndIf
        If Height < 0 
          Height = 0 
        EndIf
        
        ;
        If *this\parent\widget                        
          ;           If *this\attach 
          ;             x + *this\parent\widget\x[#__c_frame]
          ;             y + *this\parent\widget\y[#__c_frame]
          ;           Else
          If Not ( *this\attach And *this\attach\mode = 2 )
            x + *this\parent\widget\x[#__c_inner]
          EndIf
          If Not ( *this\attach And *this\attach\mode = 1 )
            y + *this\parent\widget\y[#__c_inner]
          EndIf
          ;           EndIf
        EndIf
        
        ;
        If is_root_container_( *this )
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
          If *this\window
            *this\x[#__c_window] = x - *this\window\x[#__c_inner]
          EndIf
        EndIf 
        If Change_y
          *this\resize | #__resize_y | #__resize_change
          
          *this\y[#__c_frame] = y 
          *this\y[#__c_inner] = iy
          *this\y[#__c_screen] = y - ( *this\bs - *this\fs )
          If *this\window
            *this\y[#__c_window] = y - *this\window\y[#__c_inner]
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
        
        ;
        If Change_height Or Change_width
          If *this\type = #__type_Image Or
             *this\type = #__type_ButtonImage
            *this\image\change = 1
          EndIf
          
          If Change_height And *this\count\items And 
             scroll_height_( *this ) >= *this\height[#__c_inner] ; #__c_container
            *this\change = 1
          EndIf
          
          If Change_width And *this\count\items
            If *this\type <> #__type_Tree
              *this\change | #__resize_width
            EndIf
          EndIf
        EndIf
        
        ; parent mdi
        If *this\parent\widget And 
           is_integral_( *this ) And 
           *this\parent\widget\type = #__type_MDI And 
           *this\parent\widget\scroll And
           *this\parent\widget\scroll\v <> *this And 
           *this\parent\widget\scroll\h <> *this And
           *this\parent\widget\scroll\v\bar\page\change = 0 And
           *this\parent\widget\scroll\h\bar\page\change = 0
          
          _mdi_update_( *this\parent\widget, *this\x[#__c_container], *this\y[#__c_container], *this\width[#__c_frame], *this\height[#__c_frame] )
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
            *this\bar\change_tab_items =- 1
            bar_Update( *this\bar )
          EndIf
          bar_Resize( *this\bar )  
        EndIf
        
        If *this\type = #__type_Window
          result = Update( *this )
        EndIf
        
        
        ;         ; if the widgets is composite
        ;         If *this\type = #__type_Spin
        ;         ;  *this\width[#__c_inner] = *this\width[#__c_container] - *this\bs*2 - *this\bar\button[#__b_3]\size
        ;         EndIf
        
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
            bar_Resizes( *this, 0, 0, *this\width[#__c_container], *this\height[#__c_container] )
          EndIf
          
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; if the integral tab bar 
        If *this\tab\widget And is_integral_( *this\tab\widget )
          *this\x[#__c_inner] - *this\fs - *this\fs[1]
          *this\y[#__c_inner] - *this\fs - *this\fs[2] 
          
          If *this\type = #__type_Panel
            If *this\tab\widget\vertical
              Resize( *this\tab\widget, *this\fs+*this\fs[1]-*this\barHeight, *this\fs, *this\barHeight, *this\height[#__c_inner] )
            Else
              Resize( *this\tab\widget, *this\fs, *this\fs+*this\fs[2]-*this\barHeight, *this\width[#__c_inner], *this\barHeight)
            EndIf
          EndIf
          If *this\type = #__type_window
            Resize( *this\tab\widget, *this\fs, *this\fs+*this\fs[2]-*this\ToolBarHeight , *this\width[#__c_frame], *this\ToolBarHeight )
          EndIf
          
          *this\x[#__c_inner] + *this\fs + ( *this\fs[1] + *this\fs[3] )
          *this\y[#__c_inner] + *this\fs + ( *this\fs[2] + *this\fs[4] )
        EndIf
        
        ;-
        ; then move and size parent resize all childrens
        If *this\count\childrens And *this\container 
          ; Protected.l x, y, width, height
          Protected x2,y2,pw,ph, pwd,phd, frame = #__c_frame
          
          Protected delta_width, delta_height
          
          If StartEnumerate( *this ) 
            If Not is_scrollbars_( Widget( ))
              
              If Widget( )\align
                x2 = Widget( )\align\indent\right 
                y2 = Widget( )\align\indent\bottom
                
                
                If Widget( )\parent\widget\align
                  If Widget( )\parent\widget\type = #__type_window
                    frame = #__c_inner
                  Else
                    frame = #__c_frame
                  EndIf
                  ;Debug ""+  Widget( )\parent\widget\align\width +" "+ Widget( )\parent\widget\align\indent\right +" "+ Widget( )\parent\widget\align\indent\left
                  ;delta_width = Widget( )\parent\widget\align\width  
                  ;delta_height = Widget( )\parent\widget\align\height
                  delta_width = Widget( )\parent\widget\align\indent\right - Widget( )\parent\widget\align\indent\left ;- Widget( )\parent\widget\fs
                  delta_height = Widget( )\parent\widget\align\indent\bottom - Widget( )\parent\widget\align\indent\top; - Widget( )\parent\widget\fs*2 
                  pw = ( Widget( )\parent\widget\width[frame] - delta_width )
                  ph = ( Widget( )\parent\widget\height[frame] - delta_height )
                  pwd = pw/2 
                  phd = ph/2 
                EndIf
                
                ; horizontal
                If Widget( )\align\anchor\right > 0
                  x = Widget( )\align\indent\left  
                  If Widget( )\align\anchor\left = 0
                    x + pw 
                  EndIf
                  width = x2 + pw
                Else
                  If Widget( )\align\anchor\left > 0
                    ; 1
                    x = Widget( )\align\indent\left  
                    width = x2
                  Else
                    If Widget( )\align\anchor\right < 0
                      If Widget( )\align\anchor\left < 0
                        ; 6
                        x = Widget( )\align\indent\left * Widget( )\parent\widget\width[frame] / delta_width
                        width = x2 * Widget( )\parent\widget\width[frame] / delta_width
                      Else
                        ; 5
                        x = Widget( )\align\indent\left + pwd
                        width = x2 + pw 
                      EndIf
                    Else
                      x = Widget( )\align\indent\left   
                      If Widget( )\align\anchor\left = 0
                        x + pwd
                      EndIf
                      width = x2 + pwd
                    EndIf
                  EndIf
                EndIf
                
                ; vertical
                If Widget( )\align\anchor\bottom > 0
                  y = Widget( )\align\indent\top  
                  If Widget( )\align\anchor\top = 0
                    y + ph
                  EndIf
                  height = y2 + ph
                Else
                  If Widget( )\align\anchor\top > 0
                    ; 1
                    y = Widget( )\align\indent\top  
                    height = y2
                  Else
                    If Widget( )\align\anchor\bottom < 0
                      If Widget( )\align\anchor\top < 0
                        ; 6
                        y = Widget( )\align\indent\top * Widget( )\parent\widget\height[frame] / delta_height
                        height = y2 * Widget( )\parent\widget\height[frame] / delta_height
                      Else
                        ; 5
                        y = Widget( )\align\indent\top + phd 
                        height = y2 + ph
                      EndIf
                    Else
                      y = Widget( )\align\indent\top 
                      If Widget( )\align\anchor\top = 0
                        y + phd 
                      EndIf
                      height = y2 + phd
                    EndIf
                  EndIf
                EndIf
                
                Resize( Widget( ), x, y, width - x, height - y )
              Else
                If (Change_x Or Change_y)
                  Resize( Widget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                EndIf
              EndIf
            EndIf
            
            StopEnumerate( )
          EndIf
        EndIf
        
        ;
        If *this\type = #__type_MDI
          _mdi_update_( *this, 0,0,0,0 )
        EndIf
        
        
        
        ; 
        If ( Change_x Or Change_y Or Change_width Or Change_height )
          If *this\_a_\id
            a_move( *this\_a_\id, 
                    *this\x[#__c_screen],
                    *this\y[#__c_screen], 
                    *this\width[#__c_screen], 
                    *this\height[#__c_screen], *this\container )
            
            Post( *this, #PB_EventType_Resize, transform( )\index, *this\resize )
          ElseIf ( *this\container And Not *this\root ) 
            Post( *this, #PB_EventType_Resize, -1, *this\resize )
          ElseIf *this\event And ListSize( *this\event\call( ) ) 
            ;And *this\event\call( ) = #PB_EventType_resize
            Protected _check_
            _check_expression_( _check_, *this\event\call( ), = #PB_EventType_Resize )
            If _check_
              
              Post( *this, #PB_EventType_Resize, -1, *this\resize )
            EndIf
          EndIf
          
          ;PostEventCanvas( *this\root )
          ProcedureReturn 1
        EndIf
        
      EndWith
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
        ;_content_clip_( _this_, [#__c_clip] )
        
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And
           ( _this_\scroll\v\width[#__c_clip] > 0 And _this_\scroll\v\height[#__c_clip] > 0 )
          bar_draw( _this_\scroll\v )
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And 
           ( _this_\scroll\h\width[#__c_clip] > 0 And _this_\scroll\h\height[#__c_clip] > 0 )
          bar_draw( _this_\scroll\h )
        EndIf
        
        If #__draw_scroll_box 
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          ; Scroll area coordinate
          DrawBox_( _this_\x[#__c_inner] + scroll_x_( _this_ ) + _this_\text\padding\x, _this_\y[#__c_inner] + scroll_y_( _this_ ) + _this_\text\padding\y, scroll_width_( _this_ ) - _this_\text\padding\x*2, scroll_height_( _this_ ) - _this_\text\padding\y*2, $FFFF0000 )
          DrawBox_( _this_\x[#__c_inner] + scroll_x_( _this_ ), _this_\y[#__c_inner] + scroll_y_( _this_ ), scroll_width_( _this_ ), scroll_height_( _this_ ), $FF0000FF )
          
          If _this_\scroll\v And _this_\scroll\h
            DrawBox_( _this_\scroll\h\x[#__c_frame] + scroll_x_( _this_ ), _this_\scroll\v\y[#__c_frame] + scroll_y_( _this_ ), scroll_width_( _this_ ), scroll_height_( _this_ ), $FF0000FF )
            
            ; Debug "" +  scroll_x_( _this_ )  + " " +  scroll_y_( _this_ )  + " " +  scroll_width_( _this_ )  + " " +  scroll_height_( _this_ )
            ;DrawBox_( _this_\scroll\h\x[#__c_frame] - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y[#__c_frame] - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF )
            
            ; page coordinate
            DrawBox_( _this_\scroll\h\x[#__c_frame], _this_\scroll\v\y[#__c_frame], _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00 )
          EndIf
        EndIf
      EndIf
    EndMacro
    
    ;-
    Procedure.i bar_tab_SetState_( *this._S_widget, State.l )
      Protected result.b
      
      ; prevent selection of a non-existent tab
      If State < 0 : State =- 1 : EndIf
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If FocusedTabindex( *this ) <> State 
        FocusedTabindex( *this ) = State
        *this\bar\change_tab_items = #True
        ;;Debug " - - - "
        
        If is_integral_( *this ) ; *this\parent\widget\tab\widget = *this 
          If StartEnumerate( *this\parent\widget )
            ;; Debug widget( )\text\string
            
            set_hide_state_( Widget( ))
            StopEnumerate( )
          EndIf
          ;           
          ;           Post( *this\parent\widget, #PB_EventType_Change, State )
          ;         Else
          ;           Post( *this, #PB_EventType_Change, State )
        EndIf
        
        ; scroll to active tab
        *this\state\flag | #__S_scroll
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i bar_tab_SetState( *this._S_widget, State.l )
      ; ProcedureReturn bar_tab_SetState_( *this, State )
      Protected result.b
      
      ; prevent selection of a non-existent tab
      If State < 0 
        State =- 1 
      EndIf
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If FocusedTab( *this ) 
        If State =- 1
          FocusedTab( *this ) = #Null
        Else 
          If FocusedTab( *this )\Index <> State 
            FocusedTab( *this ) = SelectElement( TabList( *this ), State )
            *this\bar\change_tab_items = #True
            result = #True
            
            FocusedTabindex( *this ) = State ; temp
          EndIf
        EndIf
      EndIf
      
      If result
        If is_integral_( *this ) ; *this\parent\widget\tab\widget = *this 
                                 ; enumerate all parent childrens
          PushListPosition( WidgetList( *this\parent\widget\root ) )
          ChangeCurrentElement( WidgetList( *this\parent\widget\root ), *this\parent\widget\address )
          While NextElement( WidgetList( *this\parent\widget\root ) )
            If WidgetList( *this\parent\widget\root ) = *this\parent\widget\after\widget 
              Break
            EndIf
            
            ; hide all children except those whose parent-item is selected
            set_hide_state_( WidgetList( *this\parent\widget\root ) )
          Wend
          PopListPosition( WidgetList( *this\parent\widget\root ) )
          
          ;           
          ;           DoEvents( *this\parent\widget, #PB_EventType_Change, State, FocusedTab( *this ) )
          ;         Else
          ;           DoEvents( *this, #PB_EventType_Change, State, FocusedTab( *this ) )
        EndIf
        
        ; to scroll the active tab
        *this\state\flag | #__S_scroll
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   bar_tab_AddItem( *this._S_widget, Item.i, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected result
      
      With *this
        ; 
        *this\bar\change_tab_items = #True
        
        If ( Item =- 1 Or Item > ListSize( TabList( *this )) - 1 )
          LastElement( TabList( *this ))
          AddElement( TabList( *this )) 
          Item = ListIndex( TabList( *this ))
        Else
          If SelectElement( TabList( *this ), Item )
            If FocusedTabindex( *this ) >= Item
              FocusedTabindex( *this ) + 1
            EndIf
            
            If *this = *this\parent\widget\tab\widget
              If StartEnumerate( *this\parent\widget )
                If Widget( )\parent\widget = *this\parent\widget And
                   ParentTabIndex( Widget( ) ) = Item
                  ParentTabIndex( Widget( ) ) + 1
                EndIf
                
                set_hide_state_( Widget( ))
                StopEnumerate( )
              EndIf
            EndIf
            
            InsertElement( TabList( *this ))
            
            PushListPosition( TabList( *this ))
            While NextElement( TabList( *this ))
              TabList( *this )\index = ListIndex( TabList( *this ))
            Wend
            PopListPosition( TabList( *this ))
          EndIf
        EndIf
        
        ; TabBar last opened item 
        OpenTabIndex( *this ) = Item
        
        ;
        *this\bar\_s.allocate( TABS, ( ))
        TabList( *this )\color = _get_colors_( )
        TabList( *this )\height = *this\height - 1
        TabList( *this )\text\string = Text.s
        TabList( *this )\index = item
        
        ; set default selected tab
        If item = 0 
          FocusedTabindex( *this ) = 0
          FocusedTab( *this ) = TabList( *this )
        EndIf
        
        If is_integral_( *this ) 
          *this\parent\widget\count\items + 1 
        EndIf
        *this\count\items + 1 
        
        set_image_( *this, TabList( *this )\Image, Image )
        PostEventCanvas( *this\root )
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i bar_tab_removeItem( *this._S_widget, Item.l )
      If SelectElement( TabList( *this ), item )
        *this\bar\change_tab_items = #True
        
        If FocusedTabindex( *this ) = TabList( *this )\index
          FocusedTabindex( *this ) = item - 1
        EndIf
        
        DeleteElement( TabList( *this ), 1 )
        
        If *this\parent\widget\tab\widget = *this
          Post( *this\parent\widget, #PB_EventType_CloseItem, Item )
          *this\parent\widget\count\items - 1
        Else
          Post( *this, #PB_EventType_CloseItem, Item )
        EndIf
        
        *this\count\items - 1
      EndIf
    EndProcedure
    
    Procedure   bar_tab_clearItems( *this._S_widget ) ; Ok
      If *this\count\items <> 0
        
        *this\bar\change_tab_items = #True
        ClearList( TabList( *this ))
        
        If *this\parent\widget\tab\widget = *this
          Post( *this\parent\widget, #PB_EventType_CloseItem, #PB_All )
          *this\parent\widget\count\items = 0
        Else
          Post( *this, #PB_EventType_CloseItem, #PB_All )
        EndIf
        
        *this\count\items = 0
      EndIf
    EndProcedure
    
    Procedure.s bar_tab_GetItemText( *this._S_widget, Item.l, Column.l = 0 )
      Protected result.s
      
      If is_item_( *this, Item ) And 
         SelectElement( TabList( *this ), Item ) 
        result = TabList( *this )\text\string
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Macro bar_tab_item_draw_( _vertical_, _address_,_x_, _y_, _fore_color_, _back_color_, _frame_color_, _text_color_, _round_)
      ;Draw back
      DrawingModeAlpha_( #PB_2DDrawing_Gradient )
      draw_gradient_box_( _vertical_,_x_ + _address_\x,_y_ + _address_\y, _address_\width, _address_\height, _fore_color_, _back_color_, _round_, _address_\color\_alpha )
      ; Draw frame
      DrawingModeAlpha_( #PB_2DDrawing_Outlined )
      DrawRoundBox_( _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _round_, _round_, _frame_color_&$FFFFFF | _address_\color\_alpha<<24 )
      ; Draw items image
      If _address_\image\id
        DrawingModeAlpha_( #PB_2DDrawing_Transparent )
        DrawAlphaImage( _address_\image\id, _x_ + _address_\image\x, _y_ + _address_\image\y, _address_\color\_alpha )
      EndIf
      ; Draw items text
      If _address_\text\string
        DrawingMode_( #PB_2DDrawing_Transparent )
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
        Protected framecolor = $FF808080;&$FFFFFF | TabList( *this )\color\_alpha<<24
        Protected Item_Color_Background
        Protected widget_backcolor1 = $FFD0D0D0
        Protected widget_backcolor = $FFD0D0D0;$FFEEEEEE ; $FFE6E5E5;
        
        Protected typ = 0
        Protected pos = 1
        If *this\parent\widget And *this\parent\widget\type = #PB_GadgetType_Panel
          pos = 2
        EndIf
        
        pos + Bool(typ)*2
        
        Protected layout = pos*2
        Protected text_pos = 6
        
        If Not \hide And \color\_alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            DrawRoundBox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back&$FFFFFF | \color\_alpha<<24 )
          EndIf
          
          ;- widget::bar_tab_update_( )
          If *this\bar\change_tab_items
            *this\image\x = ( *this\height - 16 - pos - 1 ) / 2
            Debug " --- widget::Tab_Update( ) - "+*this\image\x
            
            If *this\vertical
              *this\text\y = text_pos
            Else
              *this\text\x = text_pos
            EndIf
            
            *this\bar\max = 0
            ; *this\text\width = *this\width
            
            ForEach TabList( *this )
              ; if not visible then skip
              If TabList( *this )\hide
                Continue
              EndIf
              
              ; 
              draw_font_item_( *this, TabList( *this ), TabList( *this )\change )
              
              ; init items position
              If *this\vertical
                TabList( *this )\y = *this\bar\max + pos 
                
                If FocusedTabindex( *this ) = TabList( *this )\index
                  TabList( *this )\x = 0
                  TabList( *this )\width = *this\bar\button[#__b_3]\width + 1
                Else
                  TabList( *this )\x = 0
                  TabList( *this )\width = *this\bar\button[#__b_3]\width - 1
                EndIf
                
                *this\text\x = ( TabList( *this )\width - TabList( *this )\text\width )/2 ; - Bool(FocusedTabindex( *this ) <> TabList( *this )\index And typ)*2
                
                TabList( *this )\text\y = *this\text\y + TabList( *this )\y
                TabList( *this )\text\x = *this\text\x + TabList( *this )\x
                TabList( *this )\height = *this\text\y*2 + TabList( *this )\text\height
                
                *this\bar\max + TabList( *this )\height + Bool( TabList( *this )\index <> *this\count\items - 1 ) - Bool(typ)*2 +  Bool( TabList( *this )\index = *this\count\items - 1 ) * layout 
                ;
                If typ And FocusedTabindex( *this ) = TabList( *this )\index
                  TabList( *this )\height + 4
                  TabList( *this )\y - 2
                EndIf
              Else
                TabList( *this )\x = *this\bar\max + pos 
                
                If FocusedTabindex( *this ) = TabList( *this )\index
                  TabList( *this )\y = pos;pos - Bool( pos>0 )*2
                  TabList( *this )\height = *this\bar\button[#__b_3]\height - TabList( *this )\y + 1
                Else
                  TabList( *this )\y = pos;pos
                  TabList( *this )\height = *this\bar\button[#__b_3]\height - TabList( *this )\y - 1
                EndIf
                
                *this\text\y = ( TabList( *this )\height - TabList( *this )\text\height )/2 
                ;
                TabList( *this )\image\y = TabList( *this )\y + ( TabList( *this )\height - TabList( *this )\image\height )/2 
                TabList( *this )\text\y = TabList( *this )\y + *this\text\y
                
                ;
                TabList( *this )\image\x = TabList( *this )\x + Bool( TabList( *this )\image\width ) * *this\image\x ;+ Bool( TabList( *this )\text\width ) * ( *this\text\x ) 
                TabList( *this )\text\x = TabList( *this )\image\x + TabList( *this )\image\width + *this\text\x
                TabList( *this )\width = Bool( TabList( *this )\text\width ) * ( *this\text\x*2 ) + TabList( *this )\text\width +
                                         Bool( TabList( *this )\image\width ) * ( *this\image\x*2 ) + TabList( *this )\image\width - ( Bool( TabList( *this )\image\width And TabList( *this )\text\width ) * ( *this\text\x ))
                
                *this\bar\max + TabList( *this )\width + Bool( TabList( *this )\index <> *this\count\items - 1 ) - Bool(typ)*2 + Bool( TabList( *this )\index = *this\count\items - 1 ) * layout 
                ;                                                                                                           
                If typ And FocusedTabindex( *this ) = TabList( *this )\index
                  TabList( *this )\width + 4
                  TabList( *this )\x - 2
                EndIf
              EndIf
              
              ; then set tab state
              If TabList( *this )\index = FocusedTabindex( *this ) 
                TabList( *this )\state\press = #True
                
                If FocusedTab( *this ) <> TabList( *this ) 
                  If FocusedTab( *this )
                    FocusedTab( *this )\state\press = #False
                  EndIf
                  
                  FocusedTab( *this ) = TabList( *this )
                  
                  If *this\state\flag & #__S_scroll
                    *this\state\flag &~ #__S_scroll
                    FocusedTab( *this )\state\flag | #__S_scroll
                  EndIf
                EndIf
              EndIf
            Next
            
            ;
            bar_Update( *this\bar )
            If FocusedTab( *this ) And 
               FocusedTab( *this )\state\flag & #__S_scroll
              FocusedTab( *this )\state\flag &~ #__S_scroll
              Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
              
              Protected ThumbPos = *this\bar\max - ( FocusedTab( *this )\x + FocusedTab( *this )\width ) - 3 ; to right
              ThumbPos = *this\bar\max - ( FocusedTab( *this )\x + FocusedTab( *this )\width ) - ( *this\bar\thumb\end - FocusedTab( *this )\width ) / 2 - 3   ; to center
              Protected ScrollPos = bar_page_pos_( *this\bar, ThumbPos )
              ScrollPos = bar_invert_page_pos_( *this\bar, ScrollPos )
              *this\bar\page\pos = ScrollPos
            EndIf
            bar_Resize( *this\bar )
            
            *this\bar\change_tab_items = #False
          EndIf
          
          ; 
          If *this\vertical 
            *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2            
            *this\bar\button[#__b_1]\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2              
          Else 
            *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_2]\size )/2           
            *this\bar\button[#__b_1]\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] +pos- *this\bar\button[#__b_1]\size )/2            
          EndIf
          
          
          Protected State_3, Color_frame
          Protected x = *this\bar\button[#__b_3]\x
          Protected y = *this\bar\button[#__b_3]\y
          
          
          
          ;           DrawingModeAlpha_( #PB_2DDrawing_Default )
          ;                 color = *this\parent\widget\color\frame[0]
          ;                DrawBox_( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_frame], *this\parent\widget\width[#__c_frame], *this\parent\widget\fs-1, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
          
          ; draw all visible items
          ForEach TabList( *this )
            draw_font_item_( *this, TabList( *this ), 0 )
            
            ; real visible items
            If *this\vertical
              TabList( *this )\visible = Bool( Not TabList( *this )\hide And 
                                               (( y + TabList( *this )\y + TabList( *this )\height ) > *this\y[#__c_inner]  And 
                                                ( y + TabList( *this )\y ) < ( *this\y[#__c_inner] + *this\height[#__c_inner] ) ))
            Else
              TabList( *this )\visible = Bool( Not TabList( *this )\hide And 
                                               (( x + TabList( *this )\x + TabList( *this )\width ) > *this\x[#__c_inner]  And 
                                                ( x + TabList( *this )\x ) < ( *this\x[#__c_inner] + *this\width[#__c_inner] ) ))
            EndIf
            
            ; &~ entered &~ focused
            If TabList( *this )\visible And 
               TabList( *this ) <> EnteredTab( *this ) And 
               TabList( *this ) <> FocusedTab( *this )
              
              bar_item_draw_( *this, TabList( *this ), x, y, *this\bar\button[#__b_3]\round, [0] )
            EndIf
          Next
          
          ; draw mouse-enter visible item
          If EnteredTab( *this ) And 
             EnteredTab( *this )\visible And 
             EnteredTab( *this ) <> FocusedTab( *this )
            
            draw_font_item_( *this, EnteredTab( *this ), 0 )
            
            bar_item_draw_( *this, EnteredTab( *this ), x, y, *this\bar\button[#__b_3]\round, [1] )
          EndIf
          
          ; draw key-focus visible item
          If FocusedTab( *this ) And 
             FocusedTab( *this )\visible
            
            draw_font_item_( *this, FocusedTab( *this ), 0 )
            
            bar_item_draw_( *this, FocusedTab( *this ), x, y, *this\bar\button[#__b_3]\round, [2] )
          EndIf
          
          
          
          
          color = $FF909090
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          
          ; draw lines
          If FocusedTab( *this )  
            If *this\vertical
              color = FocusedTab( *this )\color\frame[2]
              ; frame on the selected item
              If FocusedTab( *this )\visible
                Line( x + FocusedTab( *this )\x, y + FocusedTab( *this )\y, 1, FocusedTab( *this )\height, color )
                Line( x + FocusedTab( *this )\x, y + FocusedTab( *this )\y, FocusedTab( *this )\width, 1, color )
                Line( x + FocusedTab( *this )\x, y + FocusedTab( *this )\y + FocusedTab( *this )\height -1, FocusedTab( *this )\width, 1, color )
                Line( x + FocusedTab( *this )\x + FocusedTab( *this )\width -1, y + FocusedTab( *this )\y, FocusedTab( *this )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              ; vertical tab right line 
              If FocusedTab( *this )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, *this\y[#__c_screen], 1, ( y + FocusedTab( *this )\y ) - *this\x[#__c_frame], color ) ;TabList( *this )\color\fore[2] )
                Line( *this\x[#__c_frame]+*this\width[#__c_frame]-1, y + FocusedTab( *this )\y + FocusedTab( *this )\height, 1, *this\y[#__c_frame] + *this\height[#__c_frame] - ( y + FocusedTab( *this )\y + FocusedTab( *this )\height ), color ) ; TabList( *this )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen]+*this\width[#__c_screen]-1, *this\y[#__c_screen], 1, *this\height[#__c_screen], color )
              EndIf
              
              If is_integral_( *this ) 
                color = *this\parent\widget\color\back[0]
                ; selected tab inner frame
                Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y +1, 1, FocusedTab( *this )\height-2, color )
                Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y +1, *this\bar\button[#__b_3]\width, 1, color )
                Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y + FocusedTab( *this )\height -2, *this\bar\button[#__b_3]\width, 1, color )
                Line( x + FocusedTab( *this )\x + FocusedTab( *this )\width -1, y + FocusedTab( *this )\y +1, *this\bar\button[#__b_3]\width, 1, color )
                
                Protected size1 = 5
                ;               
                ;Arrow( *this\x[#__c_screen] + selected_tab_pos + ( FocusedTab( *this )\width - size1 )/2, *this\y[#__c_frame]+*this\height[#__c_frame] - 5, 11, $ff000000, 1, 1)
                
                Arrow( x + FocusedTab( *this )\x + ( FocusedTab( *this )\width - size1 ),
                       y + FocusedTab( *this )\y + ( FocusedTab( *this )\height - size1 )/2, size1, 0, color, -1 )
                
                
                
                color = *this\parent\widget\color\frame[0]
                Line( *this\parent\widget\x[#__c_inner] - 1, *this\parent\widget\y[#__c_inner] - 1, *this\parent\widget\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                Line( *this\parent\widget\x[#__c_inner] - 1, *this\parent\widget\y[#__c_inner] + *this\parent\widget\height[#__c_inner], *this\parent\widget\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                Line( *this\parent\widget\x[#__c_inner] + *this\parent\widget\width[#__c_inner], *this\parent\widget\y[#__c_inner] - 1, 1, *this\parent\widget\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
              EndIf
            Else
              ; frame on the selected item
              If FocusedTab( *this )\visible
                color = FocusedTab( *this )\color\frame[2]
                Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y, FocusedTab( *this )\width, 1, color )
                Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y, 1, FocusedTab( *this )\height-FocusedTab( *this )\y, color )
                Line( x + FocusedTab( *this )\x + FocusedTab( *this )\width -1, y + FocusedTab( *this )\y, 1, FocusedTab( *this )\height-FocusedTab( *this )\y, color )
                ;Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y + FocusedTab( *this )\height - 1, FocusedTab( *this )\width, 1, color )
                ;color = $ffff00ff
                ;Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y+FocusedTab( *this )\height-1, FocusedTab( *this )\width, 1, color )
                ;Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y+FocusedTab( *this )\height, FocusedTab( *this )\width, 1, color )
                ;Line( x + FocusedTab( *this )\x , y + FocusedTab( *this )\y+FocusedTab( *this )\height+1, FocusedTab( *this )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              color = *this\parent\widget\color\frame[2]
              
              ; horizontal tab bottom line 
              If FocusedTab( *this )
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, ( x + FocusedTab( *this )\x ) - *this\x[#__c_frame], 1, color ) ;TabList( *this )\color\fore[2] )
                Line( x + FocusedTab( *this )\x + FocusedTab( *this )\width, *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\x[#__c_frame] + *this\width[#__c_frame] - ( x + FocusedTab( *this )\x + FocusedTab( *this )\width ), 1, color ) ; TabList( *this )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen], *this\y[#__c_frame]+*this\height[#__c_frame]-1, *this\width[#__c_screen], 1, color )
              EndIf
              
              If is_integral_( *this ) 
                color = *this\parent\widget\color\back[0] ;*this\parent\widget\color\front[2]
                                                          ; selected tab inner frame
                Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y +1, FocusedTab( *this )\width-2, 1, color )
                Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y +1, 1, FocusedTab( *this )\height-1, color )
                Line( x + FocusedTab( *this )\x + FocusedTab( *this )\width - 2, y + FocusedTab( *this )\y +1, 1, FocusedTab( *this )\height-1, color )
                ;Line( x + FocusedTab( *this )\x +1, y + FocusedTab( *this )\y + FocusedTab( *this )\height-1, FocusedTab( *this )\width-2, 1, color )
                
                ;;DrawingModeAlpha_( #PB_2DDrawing_Default )
                color = *this\parent\widget\color\frame[0]
                ;Box( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_frame], *this\parent\widget\width[#__c_frame], *this\parent\widget\fs+*this\parent\widget\fs[2], color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                
                ; ;                DrawBox_( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_inner] - *this\parent\widget\fs, *this\parent\widget\fs + pos, *this\parent\widget\fs, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ; ;                DrawBox_( *this\parent\widget\x[#__c_frame] + *this\parent\widget\width[#__c_frame] - (*this\parent\widget\fs + pos), *this\parent\widget\y[#__c_inner] - *this\parent\widget\fs, *this\parent\widget\fs + pos, *this\parent\widget\fs, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ;                DrawBox_( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_inner] - *this\parent\widget\fs[2] - 1, *this\parent\widget\fs-1, *this\parent\widget\fs[2], color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ;                DrawBox_( *this\parent\widget\x[#__c_inner] + *this\parent\widget\width[#__c_inner]+1, *this\parent\widget\y[#__c_inner] - *this\parent\widget\fs[2] - 1, *this\parent\widget\fs-1, *this\parent\widget\fs[2], color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ;                 
                ;                DrawBox_( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_inner] - 1, *this\parent\widget\fs, *this\parent\widget\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ;                DrawBox_( *this\parent\widget\x[#__c_inner] + *this\parent\widget\width[#__c_inner], *this\parent\widget\y[#__c_inner] - 1, *this\parent\widget\fs, *this\parent\widget\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                ;                DrawBox_( *this\parent\widget\x[#__c_frame], *this\parent\widget\y[#__c_inner] + *this\parent\widget\height[#__c_inner], *this\parent\widget\width[#__c_frame], *this\parent\widget\fs, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                
                Line( *this\parent\widget\x[#__c_inner] - 1, *this\parent\widget\y[#__c_inner] - 1, 1, *this\parent\widget\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                Line( *this\parent\widget\x[#__c_inner] + *this\parent\widget\width[#__c_inner], *this\parent\widget\y[#__c_inner] - 1, 1, *this\parent\widget\height[#__c_inner] + 2, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                Line( *this\parent\widget\x[#__c_inner] - 1, *this\parent\widget\y[#__c_inner] + *this\parent\widget\height[#__c_inner], *this\parent\widget\width[#__c_inner] + 2, 1, color);*this\color\frame ) ; [Bool( FocusedTabindex( *this\tab\widget )  <>-1 )*2 ] )
                
              EndIf
            EndIf
          EndIf
          
          ; Navigation
          Protected fabe_pos, fabe_out, button_size = 20, round=0, Size = 60
          backcolor = $ffffffff;\parent\widget\parent\widget\color\back[\parent\widget\parent\widget\color\state]
          If Not backcolor
            backcolor = \parent\widget\color\back[\parent\widget\color\state]
          EndIf
          If Not backcolor
            backcolor = *this\bar\button[#__b_2]\color\back[\color\state]
          EndIf
          
          
          DrawingModeAlpha_( #PB_2DDrawing_Gradient )
          ResetGradientColors( )
          GradientColor( 0.0, backcolor&$FFFFFF )
          GradientColor( 0.5, backcolor&$FFFFFF | $A0<<24 )
          GradientColor( 1.0, backcolor&$FFFFFF | 245<<24 )
          
          fabe_out = Size - button_size
          ;
          If *this\vertical
            ; to top
            If Not *this\bar\button[#__b_2]\hide 
              fabe_pos = \y + ( size ) - \fs
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos - fabe_out )
              DrawRoundBox_( \x + \bs, fabe_pos, \width - \bs-1,  - Size, round,round )
            EndIf
            
            ; to bottom
            If Not *this\bar\button[#__b_1]\hide 
              fabe_pos = \y + \height - ( size ) + \fs*2
              LinearGradient( \x + \bs, fabe_pos, \x + \bs, fabe_pos + fabe_out )
              DrawRoundBox_( \x + \bs, fabe_pos, \width - \bs-1 ,Size, round,round )
            EndIf
          Else
            ; to left
            If Not *this\bar\button[#__b_2]\hide
              fabe_pos = \x + ( size ) - \fs
              LinearGradient( fabe_pos, \y + \bs, fabe_pos - fabe_out, \y + \bs )
              DrawRoundBox_( fabe_pos, \y + \bs,  - Size, \height - \bs-1, round,round )
            EndIf
            
            ; to right
            If Not *this\bar\button[#__b_1]\hide
              fabe_pos = \x + \width - ( size ) + \fs*2
              LinearGradient( fabe_pos, \y + \bs, fabe_pos + fabe_out, \y + \bs )
              DrawRoundBox_( fabe_pos, \y + \bs, Size, \height - \bs-1 ,round,round )
            EndIf
          EndIf
          
          ResetGradientColors( )
          
          
          
          ; draw navigator
          ; Draw buttons back
          If Not *this\bar\button[#__b_2]\hide
            ;             Color = $FF202020
            ;             ; Color = $FF101010
            ;             Item_Color_Background = TabBarGadget_ColorMinus(widget_backcolor1, Color)
            ;             ;Item_Color_Background = TabBarGadget_ColorPlus(widget_backcolor1, Color)
            ;             forecolor = TabBarGadget_ColorPlus(Item_Color_Background, Color)
            ;             ;backcolor = TabBarGadget_ColorMinus(Item_Color_Background, Color)
            ;             
            ;             If *this\bar\button[#__b_1]\color\state = 3
            ;               Color = $FF303030
            ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ;              *this\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ;              *this\bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ; ;               
            ;             ElseIf *this\bar\button[#__b_1]\color\state = 1
            ; ;                Color = $FF303030
            ; ;              framecolor = TabBarGadget_ColorMinus(\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state], Color)
            ; ;              framecolor = TabBarGadget_ColorMinus(framecolor, Color)
            ; ;              *this\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = framecolor
            ; ;              *this\bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state] = framecolor
            ;              
            ;                *this\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = *this\bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state];backcolor
            ;               *this\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;             *this\bar\button[#__b_1]\arrow\size = 6               
            ;                
            ;             ElseIf *this\bar\button[#__b_1]\color\state = 0
            ;               *this\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state] = backcolor
            ;               *this\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] = backcolor               
            ;               *this\bar\button[#__b_1]\arrow\size = 4               
            ;             EndIf
            
            ; Draw buttons
            If *this\bar\button[#__b_2]\color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical,\bar\button[#__b_2], *this\bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              DrawRoundBox_( *this\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | *this\bar\button[#__b_2]\color\_alpha<<24 )
            EndIf
          EndIf
          If Not *this\bar\button[#__b_1]\hide 
            ; Draw buttons
            If *this\bar\button[#__b_1]\color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical, *this\bar\button[#__b_1], *this\bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              DrawRoundBox_( *this\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | *this\bar\button[#__b_1]\color\_alpha<<24 )
            EndIf
          EndIf
          
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          
          ; Draw buttons frame
          If Not *this\bar\button[#__b_1]\hide 
            DrawRoundBox_( *this\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF | *this\bar\button[#__b_1]\color\_alpha<<24 )
            
            ; Draw arrows
            If Not *this\bar\button[#__b_1]\hide And *this\bar\button[#__b_1]\arrow\size
              draw_arrows_( *this\bar\button[#__b_1], Bool( \vertical ) + 2 ) 
            EndIf
          EndIf
          If Not *this\bar\button[#__b_2]\hide 
            DrawRoundBox_( *this\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF | *this\bar\button[#__b_2]\color\_alpha<<24 )
            
            ; Draw arrows
            If *this\bar\button[#__b_2]\arrow\size
              draw_arrows_( *this\bar\button[#__b_2], Bool( \vertical )) 
            EndIf
          EndIf
          
          
        EndIf
        
      EndWith 
    EndProcedure
    
    Procedure.b bar_scroll_draw( *this._S_widget )
      With *this
        
        ;         DrawImage( ImageID( UpImage ),\bar\button[#__b_1]\x,\bar\button[#__b_1]\y )
        ;         DrawImage( ImageID( DownImage ),\bar\button[#__b_2]\x,\bar\button[#__b_2]\y )
        ;         ProcedureReturn 
        
        If *this\color\_alpha
          ; Draw scroll bar background
          If *this\color\back <>- 1
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            draw_box_(*this, color\back, [#__c_frame])
          EndIf
          
          ;
          ; background buttons draw
          If Not*this\bar\button[#__b_1]\hide
            If *this\bar\button[#__b_1]\color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\vertical,*this\bar\button[#__b_1],*this\bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              draw_box_(*this\bar\button[#__b_1], color\back)
            EndIf
          EndIf
          If Not*this\bar\button[#__b_2]\hide
            If *this\bar\button[#__b_2]\color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\vertical,\bar\button[#__b_2],*this\bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              draw_box_(*this\bar\button[#__b_2], color\back)
            EndIf
          EndIf
          
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          
          If *this\type = #__type_ScrollBar
            If *this\vertical
              If (*this\bar\page\len + Bool(*this\round )*(*this\width/4 )) = *this\height[#__c_frame]
                Line(*this\x[#__c_frame],*this\y[#__c_frame], 1,*this\bar\page\len + 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line(*this\x[#__c_frame],*this\y[#__c_frame]+\bar\button[#__b_1]\round, 1,*this\height-\bar\button[#__b_1]\round-\bar\button[#__b_2]\round,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            Else
              If (*this\bar\page\len + Bool(*this\round )*(*this\height/4 )) = *this\width[#__c_frame]
                Line(*this\x[#__c_frame],*this\y[#__c_frame],*this\bar\page\len + 1, 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              Else
                Line(*this\x[#__c_frame]+\bar\button[#__b_1]\round,*this\y[#__c_frame],*this\width[#__c_frame]-\bar\button[#__b_1]\round-\bar\button[#__b_2]\round, 1,*this\color\front&$FFFFFF |*this\color\_alpha<<24 ) ; $FF000000 ) ;   
              EndIf
            EndIf
          EndIf
          
          ; frame buttons draw
          If Not *this\bar\button[#__b_1]\hide
            If *this\bar\button[#__b_1]\arrow\size
              draw_arrows_( *this\bar\button[#__b_1], Bool(*this\vertical )) 
            EndIf
            draw_box_(*this\bar\button[#__b_1], color\frame)
          EndIf
          If Not *this\bar\button[#__b_2]\hide
            If *this\bar\button[#__b_2]\arrow\size
              draw_arrows_( *this\bar\button[#__b_2], Bool(*this\vertical ) + 2 ) 
            EndIf
            draw_box_(\bar\button[#__b_2], color\frame)
          EndIf
          
          
          If *this\bar\thumb\len And*this\type <> #__type_ProgressBar
            ; Draw thumb
            DrawingModeAlpha_( #PB_2DDrawing_Gradient )
            draw_gradient_(*this\vertical,\bar\button[#__b_3],*this\bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\back[\bar\button[#__b_3]\color\state])
            
            If *this\bar\button[#__b_3]\arrow\type ;*this\type = #__type_ScrollBar
              If *this\bar\button[#__b_3]\arrow\size
                DrawingModeAlpha_( #PB_2DDrawing_Default )
                ;                 Arrow(*this\bar\button[#__b_3]\x + (*this\bar\button[#__b_3]\width -*this\bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y + (*this\bar\button[#__b_3]\height -*this\bar\button[#__b_3]\arrow\size )/2, 
                ;                       *this\bar\button[#__b_3]\arrow\size,*this\bar\button[#__b_3]\arrow\direction,*this\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\bar\button[#__b_3]\color\_alpha<<24,*this\bar\button[#__b_3]\arrow\type )
                
                draw_arrows_( *this\bar\button[#__b_3],*this\bar\button[#__b_3]\arrow\direction ) 
              EndIf
            Else
              ; Draw thumb lines
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              If *this\vertical
                Line(*this\bar\button[#__b_3]\x + (*this\bar\button[#__b_3]\width -*this\bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y +*this\bar\button[#__b_3]\height/2 - 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(*this\bar\button[#__b_3]\x + (*this\bar\button[#__b_3]\width -*this\bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y +*this\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(*this\bar\button[#__b_3]\x + (*this\bar\button[#__b_3]\width -*this\bar\button[#__b_3]\arrow\size )/2,\bar\button[#__b_3]\y +*this\bar\button[#__b_3]\height/2 + 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
              Else
                Line(*this\bar\button[#__b_3]\x +*this\bar\button[#__b_3]\width/2 - 3,\bar\button[#__b_3]\y + (*this\bar\button[#__b_3]\height -*this\bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(*this\bar\button[#__b_3]\x +*this\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y + (*this\bar\button[#__b_3]\height -*this\bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
                Line(*this\bar\button[#__b_3]\x +*this\bar\button[#__b_3]\width/2 + 3,\bar\button[#__b_3]\y + (*this\bar\button[#__b_3]\height -*this\bar\button[#__b_3]\arrow\size )/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF |*this\color\_alpha<<24 )
              EndIf
            EndIf
            
            ; Draw thumb frame
            DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            draw_box_(\bar\button[#__b_3], color\frame)
          EndIf
          
        EndIf
      EndWith 
    EndProcedure
    
    Procedure.b bar_progress_draw( *this._S_widget )
      With *this
        Protected i,a, _position_, _frame_size_ = 1, _gradient_ = 1
        Protected _vertical_ = *this\vertical
        Protected _reverse_ = *this\bar\invert
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
        DrawingMode_(#PB_2DDrawing_Outlined)
        DrawRoundBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, *this\height[#__c_frame] - _frame_size_*2, _round_,_round_)
        ;   DrawRoundBox_(*this\x[#__c_frame] + _frame_size_+1, *this\y[#__c_frame] + _frame_size_+1, *this\width[#__c_frame] - _frame_size_*2-2, *this\height[#__c_frame] - _frame_size_*2-2, _round_,_round_)
        ;   ; ;   DrawRoundBox_(*this\x[#__c_frame] + _frame_size_+2, *this\y[#__c_frame] + _frame_size_+2, *this\width[#__c_frame] - _frame_size_*2-4, *this\height[#__c_frame] - _frame_size_*2-4, _round_,_round_)
        ;   ;   
        ;   ;   For i = 0 To 1
        ;   ;     DrawRoundBox_(*this\x[#__c_frame] + (_frame_size_+i), *this\y[#__c_frame] + (_frame_size_+i), *this\width[#__c_frame] - (_frame_size_+i)*2, *this\height[#__c_frame] - (_frame_size_+i)*2, _round_,_round_)
        ;   ;   Next
        
        If _gradient_
          DrawingModeAlpha_( #PB_2DDrawing_Gradient )
          If _vertical_
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], (*this\x[#__c_frame] + *this\width[#__c_frame]), *this\y[#__c_frame])
          Else
            LinearGradient(*this\x[#__c_frame],*this\y[#__c_frame], *this\x[#__c_frame], (*this\y[#__c_frame] + *this\height[#__c_frame]))
          EndIf
        Else
          DrawingMode_( #PB_2DDrawing_Default )
        EndIf 
        
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If Not _round_
          If _vertical_
            DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _frame_size_ - (_position_)))
          Else
            DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, (_position_) - _frame_size_, *this\height[#__c_frame] - _frame_size_*2)
          EndIf
        Else 
          
          If _vertical_
            If (*this\height[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)))
                Else
                  DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_*2, (*this\height[#__c_frame] - _round_ - (_position_)))
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
                  DrawBox_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) , *this\height[#__c_frame] - _frame_size_*2)
                Else
                  DrawBox_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) + (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
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
            DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_*2, (_position_) - _frame_size_)
          Else 
            DrawBox_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _frame_size_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
          EndIf 
        Else 
          If _vertical_
            If (_position_) > _round_
              If *this\height[#__c_frame] > _round_*2
                ; рисуем прямоуголную часть
                If _round_ > (*this\height[#__c_frame] - (_position_))
                  DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_) + (*this\height[#__c_frame] - _round_ - (_position_)))
                Else
                  DrawBox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_*2, ((_position_) - _round_))
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
                  DrawBox_(*this\x[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
                Else
                  DrawBox_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_*2)
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
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state] )
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i bar_spin_draw( *this._S_widget ) 
      DrawingModeAlpha_( #PB_2DDrawing_Gradient )
      draw_gradient_(*this\vertical,*this\bar\button[#__b_1],*this\bar\button[#__b_1]\color\fore[*this\bar\button[#__b_1]\color\state],*this\bar\button[#__b_1]\color\back[*this\bar\button[#__b_1]\color\state] )
      draw_gradient_(*this\vertical,*this\bar\button[#__b_2],*this\bar\button[#__b_2]\color\fore[*this\bar\button[#__b_2]\color\state],*this\bar\button[#__b_2]\color\back[*this\bar\button[#__b_2]\color\state] )
      
      DrawingMode_( #PB_2DDrawing_Outlined )
      
      ; spin-buttons center line
      If EnteredButton( ) <> *this\bar\button[#__b_1] And *this\bar\button[#__b_1]\color\state <> #__S_3
        DrawBox_( *this\bar\button[#__b_1]\x,*this\bar\button[#__b_1]\y,*this\bar\button[#__b_1]\width,*this\bar\button[#__b_1]\height, *this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state] )
      EndIf
      If EnteredButton( ) <> *this\bar\button[#__b_2] And *this\bar\button[#__b_2]\color\state <> #__S_3
        DrawBox_( *this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\y,*this\bar\button[#__b_2]\width,*this\bar\button[#__b_2]\height, *this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state] )
      EndIf
      
      If FocusedWidget( ) = *this
        If *this\fs[1] ;And Not bar_in_start_( *this\bar )
          DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\fs[1] + 1, *this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[2] ;And Not bar_in_stop_( *this\bar )
          DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs[2] + 1, *this\color\frame[2] )
        EndIf
        If *this\fs[3] ;And Not bar_in_stop_( *this\bar )
          DrawBox_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs[3] - 1,*this\y[#__c_frame],*this\fs[3] + 1,*this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[4] ;And Not bar_in_start_( *this\bar )
          DrawBox_( *this\x[#__c_frame],*this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs[4] - 1,*this\width[#__c_frame],*this\fs[4] + 1, *this\color\frame[2] )
        EndIf
      EndIf
      
      If *this\bar\button[#__b_1]\color\state = #__S_3
        DrawBox_( *this\bar\button[#__b_1]\x,*this\bar\button[#__b_1]\y,*this\bar\button[#__b_1]\width,*this\bar\button[#__b_1]\height, *this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state] )
      EndIf
      
      If *this\bar\button[#__b_2]\color\state = #__S_3
        DrawBox_( *this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\y,*this\bar\button[#__b_2]\width,*this\bar\button[#__b_2]\height, *this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state] )
      EndIf
      
      If EnteredButton( ) 
        DrawBox_( EnteredButton( )\x,EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, EnteredButton( )\color\frame[EnteredButton( )\color\state] )
      EndIf
      
      ;
      If *this\flag & #__spin_Plus
        ; -/+
        draw_plus_( *this\bar\button[#__b_1], Bool( *this\bar\invert ) )
        draw_plus_( *this\bar\button[#__b_2], Bool( Not *this\bar\invert ) )
      Else
        ; arrows on the buttons
        If *this\bar\button[#__b_1]\arrow\size
          draw_arrows_( *this\bar\button[#__b_1], Bool(*this\vertical )) 
        EndIf
        If *this\bar\button[#__b_2]\arrow\size
          draw_arrows_( *this\bar\button[#__b_2], Bool(*this\vertical ) + 2 ) 
        EndIf
      EndIf
      
      
      DrawingMode_( #PB_2DDrawing_Default )
      ; draw split-string back
      ;Box( *this\bar\button[#__b_3]\x,*this\bar\button[#__b_3]\y,*this\bar\button[#__b_3]\width,*this\bar\button[#__b_3]\height, *this\color\back[*this\color\state] )
      DrawBox_( *this\x[#__c_frame] + *this\fs[1],*this\y[#__c_frame] + *this\fs[2],*this\width[#__c_frame] - *this\fs[1] - *this\fs[3],*this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\back[*this\color\state] )
      
      DrawingMode_( #PB_2DDrawing_Outlined )
      ; draw split-string frame
      DrawBox_( *this\x[#__c_frame] + *this\fs[1],*this\y[#__c_frame] + *this\fs[2],*this\width[#__c_frame] - *this\fs[1] - *this\fs[3],*this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\frame[Bool(FocusedWidget( ) = *this)*2] )
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingModeAlpha_( #PB_2DDrawing_Transparent )
        DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0] ) ; *this\color\state] )
      EndIf
    EndProcedure
    
    Procedure.b bar_track_draw( *this._S_widget )
      bar_scroll_draw( *this )
      ;bar_progress_draw( *this )
      
      With *this
        If \type = #__type_TrackBar
          Protected i, x,y
          DrawingMode_( #PB_2DDrawing_XOr )
          
          If \vertical
            x = *this\bar\button[#__b_3]\x + Bool( *this\bar\invert )*( *this\bar\button[#__b_3]\width - 3 + 4 ) - 2
            y = *this\y + *this\bar\area\pos + *this\bar\button[#__b_3]\size/2  
            
            If *this\bar\widget\flag & #PB_TrackBar_Ticks
              For i = 0 To *this\bar\page\end
                Line( x, y + bar_thumb_pos_( *this\bar, i ),6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3,1,\bar\button[#__b_3]\color\frame )
              Next
            EndIf
            
            Line( x-3, y,3,1,\bar\button[#__b_3]\color\frame )
            Line( x-3, y + *this\bar\area\len - *this\bar\thumb\len,3,1,\bar\button[#__b_3]\color\frame )
            
          Else
            x = *this\x + *this\bar\area\pos + *this\bar\button[#__b_3]\size/2 
            y = *this\bar\button[#__b_3]\y + Bool( Not *this\bar\invert )*( *this\bar\button[#__b_3]\height - 3 + 4 ) - 2
            
            If *this\bar\widget\flag & #PB_TrackBar_Ticks
              For i = *this\bar\min To *this\bar\max
                Line( x + bar_thumb_pos_( *this\bar, i ), y,1,6-Bool(i>*this\bar\min And i<>0 And i<*this\bar\max)*3,\bar\button[#__b_3]\color\frame )
              Next
            EndIf
            
            Line( x, y-3,1,3,*this\bar\button[#__b_3]\color\frame )
            Line( x + *this\bar\area\len - *this\bar\thumb\len, y-3,1,3, *this\bar\button[#__b_3]\color\frame )
          EndIf
        EndIf
      EndWith    
      
    EndProcedure
    
    Procedure.b bar_splitter_draw( *this._S_widget )
      With *this
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        
        ; draw the splitter background
        DrawBox_( *this\bar\button[#__split_b3]\x, *this\bar\button[#__split_b3]\y, *this\bar\button[#__split_b3]\width, *this\bar\button[#__split_b3]\height, *this\color\back[*this\bar\button[#__split_b3]\color\state]&$ffffff|210<<24 )
        
        ; if there is no first child, draw the background
        If Not ( splitter_is_first_gadget_( *this ) Or splitter_first_gadget_( *this ) )
          DrawBox_( *this\bar\button[#__split_b1]\x, *this\bar\button[#__split_b1]\y,\bar\button[#__split_b1]\width,\bar\button[#__split_b1]\height,\color\frame[\bar\button[#__split_b1]\color\state] )
        EndIf
        
        ; if there is no second child, draw the background
        If Not ( splitter_is_second_gadget_( *this ) Or splitter_second_gadget_( *this ) )
          DrawBox_( *this\bar\button[#__split_b2]\x, *this\bar\button[#__split_b2]\y,\bar\button[#__split_b2]\width,\bar\button[#__split_b2]\height,\color\frame[\bar\button[#__split_b2]\color\state] )
        EndIf
        
        DrawingMode_( #PB_2DDrawing_Outlined )
        
        ; if there is no first child, draw the frame
        If Not ( splitter_is_first_gadget_( *this ) Or splitter_first_gadget_( *this ) )
          DrawBox_( *this\bar\button[#__split_b1]\x, *this\bar\button[#__split_b1]\y,\bar\button[#__split_b1]\width,*this\bar\button[#__split_b1]\height,*this\color\frame[*this\bar\button[#__split_b1]\color\state] )
        EndIf
        
        ; if there is no second child, draw the frame
        If Not ( splitter_is_second_gadget_( *this ) Or splitter_second_gadget_( *this ) )
          DrawBox_( *this\bar\button[#__split_b2]\x, *this\bar\button[#__split_b2]\y,\bar\button[#__split_b2]\width,*this\bar\button[#__split_b2]\height,*this\color\frame[*this\bar\button[#__split_b2]\color\state] )
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
            If *this\bar\button[#__split_b3]\width > 35
              Circle( circle_x - ( *this\bar\button[#__split_b3]\round*2 + 2 )*2 - 2, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
              Circle( circle_x + ( *this\bar\button[#__split_b3]\round*2 + 2 )*2 + 2, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
            EndIf
            If *this\bar\button[#__split_b3]\width > 20
              Circle( circle_x - ( *this\bar\button[#__split_b3]\round*2 + 2 ), circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
              Circle( circle_x + ( *this\bar\button[#__split_b3]\round*2 + 2 ), circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
            EndIf
          Else
            If *this\bar\button[#__split_b3]\height > 35
              Circle( circle_x,circle_y - ( *this\bar\button[#__split_b3]\round*2 + 2 )*2 - 2, *this\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
              Circle( circle_x,circle_y + ( *this\bar\button[#__split_b3]\round*2 + 2 )*2 + 2, *this\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
            EndIf
            If *this\bar\button[#__split_b3]\height > 20
              Circle( circle_x,circle_y - ( *this\bar\button[#__split_b3]\round*2 + 2 ), *this\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
              Circle( circle_x,circle_y + ( *this\bar\button[#__split_b3]\round*2 + 2 ), *this\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
            EndIf
          EndIf
          
          Circle( circle_x, circle_y,\bar\button[#__split_b3]\round,\bar\button[#__split_b3]\color\frame[#__S_2] )
        EndIf
      EndWith
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
        
        ;DrawingMode_( #PB_2DDrawing_Outlined ) :DrawBox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00 )
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        
      EndWith
    EndProcedure
    
    ;-
    Procedure.b bar_Resize( *bar._S_BAR )
      Protected result.b, fixed.l, ScrollPos.f, ThumbPos.i
      
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
        If ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar )
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
          *bar\button[#__split_1]\fixed = *bar\thumb\pos
        Else
          *bar\button[#__split_2]\fixed = *bar\area\len - *bar\thumb\len - *bar\thumb\pos
        EndIf
      EndIf
      
      ; buttons state
      If ( *bar\widget\type = #__type_ScrollBar Or ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ) )
        ; disable/enable button-scroll(left&top)-tab(right&bottom)
        If *bar\button[#__b_1]\size 
          If bar_in_start_( *bar )
            If *bar\button[#__b_1]\color\state <> #__S_3
              *bar\button[#__b_1]\color\state = #__S_3
            EndIf
          Else
            If *bar\button[#__b_1]\color\state <> #__S_2
              *bar\button[#__b_1]\color\state = #__S_0
            EndIf
          EndIf 
        Else
        EndIf
        
        ; disable/enable button-scroll(right&bottom)-tab(left&top)
        If *bar\button[#__b_2]\size And bar_in_stop_( *bar ) 
          If *bar\button[#__b_2]\color\state <> #__S_3 
            *bar\button[#__b_2]\color\state = #__S_3
          EndIf
        Else
          If *bar\button[#__b_2]\color\state <> #__S_2
            *bar\button[#__b_2]\color\state = #__S_0
          EndIf
        EndIf
        
        ; disable/enable button-thumb
        If *bar\widget\type = #__type_ScrollBar
          If *bar\thumb\len 
            If *bar\button[#__b_1]\color\state = #__S_3 And
               *bar\button[#__b_2]\color\state = #__S_3 
              
              If *bar\button[#__b_3]\color\state <> #__S_3
                *bar\button[#__b_3]\color\state = #__S_3
              EndIf
            Else
              If *bar\button[#__b_3]\color\state <> #__S_2
                *bar\button[#__b_3]\color\state = #__S_0
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; show/hide button-(right&bottom)
        If *bar\button[#__b_2]\size > 0
          If *bar\button[#__b_2]\hide <> Bool( *bar\button[#__b_2]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
            *bar\button[#__b_2]\hide = Bool( *bar\button[#__b_2]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
          EndIf
        Else
          If *bar\button[#__b_2]\hide <> #True
            *bar\button[#__b_2]\hide = #True
          EndIf
        EndIf
        
        ; show/hide button-(left&top)
        If *bar\button[#__b_1]\size > 0
          If *bar\button[#__b_1]\hide <> Bool( *bar\button[#__b_1]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
            *bar\button[#__b_1]\hide = Bool( *bar\button[#__b_1]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
          EndIf
        Else
          If *bar\button[#__b_1]\hide <> #True
            *bar\button[#__b_1]\hide = #True
          EndIf
        EndIf
      EndIf
      
      ; spin-buttons state
      If *bar\widget\type = #__type_spin 
        ; disable/enable button(left&top)-tab(right&bottom)
        If *bar\button[#__b_1]\size 
          If bar_in_start_( *bar )
            If *bar\button[#__b_1]\color\state <> #__S_3
              *bar\button[#__b_1]\color\state = #__S_3
            EndIf
          Else
            If *bar\button[#__b_1]\color\state <> #__S_2
              *bar\button[#__b_1]\color\state = #__S_0
            EndIf
          EndIf 
        EndIf
        
        ; disable/enable button(right&bottom)-tab(left&top)
        If *bar\button[#__b_2]\size And bar_in_stop_( *bar ) 
          If *bar\button[#__b_2]\color\state <> #__S_3 
            *bar\button[#__b_2]\color\state = #__S_3
          EndIf
        Else
          If *bar\button[#__b_2]\color\state <> #__S_2
            *bar\button[#__b_2]\color\state = #__S_0
          EndIf
        EndIf
        
        ; show/hide button-(right&bottom)
        If *bar\button[#__b_2]\size > 0
          If *bar\button[#__b_2]\hide <> Bool( *bar\button[#__b_2]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
            *bar\button[#__b_2]\hide = Bool( *bar\button[#__b_2]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
          EndIf
        Else
          If *bar\button[#__b_2]\hide <> #True
            *bar\button[#__b_2]\hide = #True
          EndIf
        EndIf
        
        ; show/hide button-(left&top)
        If *bar\button[#__b_1]\size > 0
          If *bar\button[#__b_1]\hide <> Bool( *bar\button[#__b_1]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
            *bar\button[#__b_1]\hide = Bool( *bar\button[#__b_1]\color\state = #__S_3 And ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar ))
          EndIf
        Else
          If *bar\button[#__b_1]\hide <> #True
            *bar\button[#__b_1]\hide = #True
          EndIf
        EndIf
      EndIf
      
      
      
      ; if enter buttons disabled 
      If EnteredButton( ) And
         EnteredButton( )\color\state = #__S_3
        EnteredButton( ) = #Null
      EndIf
      
      
      ; buttons resize coordinate
      If ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar )
        ; inner coordinate
        If *bar\widget\vertical
          *bar\widget\x[#__c_inner] = *bar\widget\x[#__c_frame] 
          *bar\widget\width[#__c_inner] = *bar\widget\width[#__c_frame] - 1
          *bar\widget\y[#__c_inner] = *bar\widget\y[#__c_frame] + Bool( *bar\button[#__b_2]\hide = #False ) * ( *bar\button[#__b_2]\size + *bar\widget\fs )
          *bar\widget\height[#__c_inner] = *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] - *bar\widget\y[#__c_inner] - Bool( *bar\button[#__b_1]\hide = #False ) * ( *bar\button[#__b_1]\size + *bar\widget\fs )
        Else
          *bar\widget\y[#__c_inner] = *bar\widget\y[#__c_frame]
          *bar\widget\height[#__c_inner] = *bar\widget\height[#__c_frame] - 1
          *bar\widget\x[#__c_inner] = *bar\widget\x[#__c_frame] + Bool( *bar\button[#__b_2]\hide = #False ) * ( *bar\button[#__b_2]\size + *bar\widget\fs )
          *bar\widget\width[#__c_inner] = *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] - *bar\widget\x[#__c_inner] - Bool( *bar\button[#__b_1]\hide = #False ) * ( *bar\button[#__b_1]\size + *bar\widget\fs )
        EndIf
        
        If *bar\button[#__b_2]\size And Not *bar\button[#__b_2]\hide 
          If *bar\widget\vertical 
            ; Top button coordinate on vertical scroll bar
            ;  *bar\button[#__b_2]\x = *bar\widget\x[#__c_frame] + ( *bar\widget\width[#__c_frame] - *bar\button[#__b_2]\size )/2            
            *bar\button[#__b_2]\y = *bar\widget\y[#__c_inner] - *bar\button[#__b_2]\size
          Else 
            ; Left button coordinate on horizontal scroll bar
            *bar\button[#__b_2]\x = *bar\widget\x[#__c_inner] - *bar\button[#__b_2]\size
            ;  *bar\button[#__b_2]\y = *bar\widget\y[#__c_frame] + ( *bar\widget\height[#__c_frame] - *bar\button[#__b_2]\size )/2           
          EndIf
          If *bar\button[#__b_2]\width <> *bar\button[#__b_2]\size
            *bar\button[#__b_2]\width = *bar\button[#__b_2]\size
          EndIf
          If *bar\button[#__b_2]\height <> *bar\button[#__b_2]\size
            *bar\button[#__b_2]\height = *bar\button[#__b_2]\size                   
          EndIf
        EndIf
        
        If *bar\button[#__b_1]\size And Not *bar\button[#__b_1]\hide
          If *bar\widget\vertical 
            ; Botom button coordinate on vertical scroll bar
            ;  *bar\button[#__b_1]\x = *bar\widget\x[#__c_frame] + ( *bar\widget\width[#__c_frame] - *bar\button[#__b_1]\size )/2              
            *bar\button[#__b_1]\y = *bar\widget\y[#__c_inner] + *bar\widget\height[#__c_inner]
          Else 
            ; Right button coordinate on horizontal scroll bar
            *bar\button[#__b_1]\x = *bar\widget\x[#__c_inner] + *bar\widget\width[#__c_inner]
            ;  *bar\button[#__b_1]\y = *bar\widget\y[#__c_frame] + ( *bar\widget\height[#__c_frame] - *bar\button[#__b_1]\size )/2            
          EndIf
          If *bar\button[#__b_1]\width <> *bar\button[#__b_1]\size
            *bar\button[#__b_1]\width = *bar\button[#__b_1]\size
          EndIf
          If *bar\button[#__b_1]\height <> *bar\button[#__b_1]\size 
            *bar\button[#__b_1]\height = *bar\button[#__b_1]\size 
          EndIf
        EndIf
        
        ;If *bar\thumb\len
        If *bar\widget\vertical
          *bar\button[#__b_3]\x = *bar\widget\x[#__c_inner]          
          *bar\button[#__b_3]\width = *bar\widget\width[#__c_inner]
          *bar\button[#__b_3]\height = *bar\max                             
          *bar\button[#__b_3]\y = *bar\widget\y[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
        Else
          *bar\button[#__b_3]\y = *bar\widget\y[#__c_inner]         
          *bar\button[#__b_3]\height = *bar\widget\height[#__c_inner]
          *bar\button[#__b_3]\width = *bar\max
          *bar\button[#__b_3]\x = *bar\widget\x[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
        EndIf
        ;EndIf
        
        
        result = Bool( *bar\widget\resize & #__resize_change )
      EndIf
      
      ;
      If *bar\widget\type = #__type_ScrollBar
        If *bar\thumb\len 
          If *bar\widget\vertical
            *bar\button[#__b_3]\x = *bar\widget\x[#__c_frame]           + 1 ; white line size 
            *bar\button[#__b_3]\width = *bar\widget\width[#__c_frame]   - 1 ; white line size 
            *bar\button[#__b_3]\y = *bar\widget\y[#__c_inner_b] + *bar\thumb\pos
            *bar\button[#__b_3]\height = *bar\thumb\len                              
          Else
            *bar\button[#__b_3]\y = *bar\widget\y[#__c_frame]           + 1 ; white line size
            *bar\button[#__b_3]\height = *bar\widget\height[#__c_frame] - 1 ; white line size
            *bar\button[#__b_3]\x = *bar\widget\x[#__c_inner_b] + *bar\thumb\pos 
            *bar\button[#__b_3]\width = *bar\thumb\len                                  
          EndIf
        EndIf
        
        If *bar\button[#__b_1]\size 
          If *bar\widget\vertical 
            ; Top button coordinate on vertical scroll bar
            *bar\button[#__b_1]\x = *bar\button[#__b_3]\x
            *bar\button[#__b_1]\width = *bar\button[#__b_3]\width
            *bar\button[#__b_1]\y = *bar\widget\y[#__c_frame] 
            *bar\button[#__b_1]\height = *bar\button[#__b_1]\size                   
          Else 
            ; Left button coordinate on horizontal scroll bar
            *bar\button[#__b_1]\y = *bar\button[#__b_3]\y
            *bar\button[#__b_1]\height = *bar\button[#__b_3]\height
            *bar\button[#__b_1]\x = *bar\widget\x[#__c_frame] 
            *bar\button[#__b_1]\width = *bar\button[#__b_1]\size 
          EndIf
        EndIf
        
        If *bar\button[#__b_2]\size 
          If *bar\widget\vertical 
            ; Botom button coordinate on vertical scroll bar
            *bar\button[#__b_2]\x = *bar\button[#__b_3]\x
            *bar\button[#__b_2]\width = *bar\button[#__b_3]\width
            *bar\button[#__b_2]\height = *bar\button[#__b_2]\size 
            *bar\button[#__b_2]\y = *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] - *bar\button[#__b_2]\height
          Else 
            ; Right button coordinate on horizontal scroll bar
            *bar\button[#__b_2]\y = *bar\button[#__b_3]\y
            *bar\button[#__b_2]\height = *bar\button[#__b_3]\height
            *bar\button[#__b_2]\width = *bar\button[#__b_2]\size 
            *bar\button[#__b_2]\x = *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] - *bar\button[#__b_2]\width 
          EndIf
        EndIf
        
        ; Thumb coordinate on scroll bar
        If Not *bar\thumb\len
          ; auto resize buttons
          If *bar\widget\vertical
            *bar\button[#__b_2]\height = *bar\widget\height[#__c_frame]/2 
            *bar\button[#__b_2]\y = *bar\widget\y[#__c_frame] + *bar\button[#__b_2]\height + Bool( *bar\widget\height[#__c_frame]%2 ) 
            
            *bar\button[#__b_1]\y = *bar\widget\y 
            *bar\button[#__b_1]\height = *bar\widget\height/2 - Bool( Not *bar\widget\height[#__c_frame]%2 )
            
          Else
            *bar\button[#__b_2]\width = *bar\widget\width[#__c_frame]/2 
            *bar\button[#__b_2]\x = *bar\widget\x[#__c_frame] + *bar\button[#__b_2]\width + Bool( *bar\widget\width[#__c_frame]%2 ) 
            
            *bar\button[#__b_1]\x = *bar\widget\x[#__c_frame] 
            *bar\button[#__b_1]\width = *bar\widget\width[#__c_frame]/2 - Bool( Not *bar\widget\width[#__c_frame]%2 )
          EndIf
          
          If *bar\widget\vertical
            *bar\button[#__b_3]\width = 0 
            *bar\button[#__b_3]\height = 0                             
          Else
            *bar\button[#__b_3]\height = 0
            *bar\button[#__b_3]\width = 0                                 
          EndIf
        EndIf
      EndIf
      
      ; Ok
      If *bar\widget\type = #__type_Spin
        *bar\button[#__b_3]\x = *bar\widget\x[#__c_inner] 
        *bar\button[#__b_3]\y = *bar\widget\y[#__c_inner] 
        *bar\button[#__b_3]\width = *bar\widget\width[#__c_inner] 
        *bar\button[#__b_3]\height = *bar\widget\height[#__c_inner] 
        
        If Not *bar\widget\flag & #__spin_Plus
          If *bar\button[#__b_1]\size 
            *bar\button[#__b_1]\x = ( *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] ) - *bar\button[#__b_3]\size
            *bar\button[#__b_1]\y = *bar\widget\y[#__c_frame] 
            *bar\button[#__b_1]\width = *bar\button[#__b_3]\size
            *bar\button[#__b_1]\height = *bar\button[#__b_1]\size                   
          EndIf
          If *bar\button[#__b_2]\size 
            *bar\button[#__b_2]\x = *bar\button[#__b_1]\x
            *bar\button[#__b_2]\y = ( *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] ) - *bar\button[#__b_2]\size
            *bar\button[#__b_2]\height = *bar\button[#__b_2]\size 
            *bar\button[#__b_2]\width = *bar\button[#__b_3]\size
          EndIf
          
        Else
          ; spin buttons numeric plus -/+ 
          If *bar\widget\vertical
            If *bar\button[#__b_1]\size 
              *bar\button[#__b_1]\x = *bar\widget\x[#__c_frame]
              *bar\button[#__b_1]\y = ( *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] ) - *bar\button[#__b_1]\size
              *bar\button[#__b_1]\width = *bar\widget\width[#__c_frame]
              *bar\button[#__b_1]\height = *bar\button[#__b_1]\size
            EndIf
            If *bar\button[#__b_2]\size 
              *bar\button[#__b_2]\x = *bar\widget\x[#__c_frame]
              *bar\button[#__b_2]\y = *bar\widget\y[#__c_frame] 
              *bar\button[#__b_2]\width = *bar\widget\width[#__c_frame]
              *bar\button[#__b_2]\height = *bar\button[#__b_2]\size              
            EndIf
          Else
            If *bar\button[#__b_1]\size 
              *bar\button[#__b_1]\x = *bar\widget\x[#__c_frame]
              *bar\button[#__b_1]\y = *bar\widget\y[#__c_frame] 
              *bar\button[#__b_1]\width = *bar\button[#__b_1]\size
              *bar\button[#__b_1]\height = *bar\widget\height[#__c_frame]               
            EndIf
            If *bar\button[#__b_2]\size 
              *bar\button[#__b_2]\x = ( *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] ) - *bar\button[#__b_2]\size
              *bar\button[#__b_2]\y = *bar\widget\y[#__c_frame]
              *bar\button[#__b_2]\width = *bar\button[#__b_2]\size
              *bar\button[#__b_2]\height = *bar\widget\height[#__c_frame] 
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If *bar\widget\type = #__type_Splitter 
        If *bar\thumb\len 
          If *bar\widget\vertical
            *bar\button[#__b_3]\x = *bar\widget\x[#__c_frame]           + 1 ; white line size 
            *bar\button[#__b_3]\width = *bar\widget\width[#__c_frame]   - 1 ; white line size 
            *bar\button[#__b_3]\y = *bar\widget\y[#__c_inner_b] + *bar\thumb\pos
            *bar\button[#__b_3]\height = *bar\thumb\len                              
          Else
            *bar\button[#__b_3]\y = *bar\widget\y[#__c_frame]           + 1 ; white line size
            *bar\button[#__b_3]\height = *bar\widget\height[#__c_frame] - 1 ; white line size
            *bar\button[#__b_3]\x = *bar\widget\x[#__c_inner_b] + *bar\thumb\pos 
            *bar\button[#__b_3]\width = *bar\thumb\len                                  
          EndIf
        EndIf
        
        If *bar\widget\vertical
          *bar\button[#__split_b1]\width    = *bar\widget\width[#__c_frame]
          *bar\button[#__split_b1]\height   = *bar\thumb\pos
          
          *bar\button[#__split_b1]\x        = *bar\widget\x[#__c_frame]
          *bar\button[#__split_b2]\x        = *bar\widget\x[#__c_frame]
          
          If Not (( #PB_Compiler_OS = #PB_OS_MacOS ) And splitter_is_first_gadget_( *bar\widget ) And Not *bar\widget\parent\widget )
            *bar\button[#__split_b1]\y      = *bar\widget\y[#__c_frame] 
            *bar\button[#__split_b2]\y      = ( *bar\thumb\pos + *bar\thumb\len ) + *bar\widget\y[#__c_frame] 
          Else
            *bar\button[#__split_b1]\y      = *bar\widget\height[#__c_frame] - *bar\button[#__split_b1]\height
          EndIf
          
          *bar\button[#__split_b2]\height   = *bar\widget\height[#__c_frame] - ( *bar\button[#__split_b1]\height + *bar\thumb\len )
          *bar\button[#__split_b2]\width    = *bar\widget\width[#__c_frame]
          
        Else
          *bar\button[#__split_b1]\width    = *bar\thumb\pos
          *bar\button[#__split_b1]\height   = *bar\widget\height[#__c_frame]
          
          *bar\button[#__split_b1]\y        = *bar\widget\y[#__c_frame]
          *bar\button[#__split_b2]\y        = *bar\widget\y[#__c_frame]
          *bar\button[#__split_b1]\x        = *bar\widget\x[#__c_frame]
          *bar\button[#__split_b2]\x        = ( *bar\thumb\pos + *bar\thumb\len ) + *bar\widget\x[#__c_frame]
          
          *bar\button[#__split_b2]\width    = *bar\widget\width[#__c_frame] - ( *bar\button[#__split_b1]\width + *bar\thumb\len )
          *bar\button[#__split_b2]\height   = *bar\widget\height[#__c_frame]
          
        EndIf
        
        
        ; Splitter childrens auto resize       
        If splitter_first_gadget_( *bar\widget )
          If splitter_is_first_gadget_( *bar\widget )
            If *bar\widget\root\canvas\container
              ResizeGadget( splitter_first_gadget_( *bar\widget ),
                            *bar\button[#__split_b1]\x,
                            *bar\button[#__split_b1]\y,
                            *bar\button[#__split_b1]\width, *bar\button[#__split_b1]\height )
            Else
              ResizeGadget( splitter_first_gadget_( *bar\widget ),
                            *bar\button[#__split_b1]\x + GadgetX( *bar\widget\root\canvas\gadget ), 
                            *bar\button[#__split_b1]\y + GadgetY( *bar\widget\root\canvas\gadget ),
                            *bar\button[#__split_b1]\width, *bar\button[#__split_b1]\height )
            EndIf
          Else
            If splitter_first_gadget_( *bar\widget )\x <> *bar\button[#__split_b1]\x Or
               splitter_first_gadget_( *bar\widget )\y <> *bar\button[#__split_b1]\y Or
               splitter_first_gadget_( *bar\widget )\width <> *bar\button[#__split_b1]\width Or
               splitter_first_gadget_( *bar\widget )\height <> *bar\button[#__split_b1]\height
              ; Debug "splitter_1_resize " + splitter_first_gadget_( *bar\widget )
              
              If splitter_first_gadget_( *bar\widget )\type = #__type_window
                Resize( splitter_first_gadget_( *bar\widget ),
                        *bar\button[#__split_b1]\x - *bar\widget\x[#__c_frame],
                        *bar\button[#__split_b1]\y - *bar\widget\y[#__c_frame], 
                        *bar\button[#__split_b1]\width - #__window_frame_size*2, *bar\button[#__split_b1]\height - #__window_frame_size*2 - #__window_caption_height)
              Else
                Resize( splitter_first_gadget_( *bar\widget ),
                        *bar\button[#__split_b1]\x - *bar\widget\x[#__c_frame],
                        *bar\button[#__split_b1]\y - *bar\widget\y[#__c_frame], 
                        *bar\button[#__split_b1]\width, *bar\button[#__split_b1]\height )
              EndIf
              
            EndIf
          EndIf
        EndIf
        
        If splitter_second_gadget_( *bar\widget )
          If splitter_is_second_gadget_( *bar\widget )
            If *bar\widget\root\canvas\container 
              ResizeGadget( splitter_second_gadget_( *bar\widget ),
                            *bar\button[#__split_b2]\x, 
                            *bar\button[#__split_b2]\y,
                            *bar\button[#__split_b2]\width, *bar\button[#__split_b2]\height )
            Else
              ResizeGadget( splitter_second_gadget_( *bar\widget ), 
                            *bar\button[#__split_b2]\x + GadgetX( *bar\widget\root\canvas\gadget ),
                            *bar\button[#__split_b2]\y + GadgetY( *bar\widget\root\canvas\gadget ),
                            *bar\button[#__split_b2]\width, *bar\button[#__split_b2]\height )
            EndIf
          Else
            If splitter_second_gadget_( *bar\widget )\x <> *bar\button[#__split_b2]\x Or 
               splitter_second_gadget_( *bar\widget )\y <> *bar\button[#__split_b2]\y Or
               splitter_second_gadget_( *bar\widget )\width <> *bar\button[#__split_b2]\width Or
               splitter_second_gadget_( *bar\widget )\height <> *bar\button[#__split_b2]\height 
              ; Debug "splitter_2_resize " + splitter_second_gadget_( *bar\widget )
              
              If splitter_second_gadget_( *bar\widget )\type = #__type_window
                Resize( splitter_second_gadget_( *bar\widget ), 
                        *bar\button[#__split_b2]\x - *bar\widget\x[#__c_frame], 
                        *bar\button[#__split_b2]\y - *bar\widget\y[#__c_frame], 
                        *bar\button[#__split_b2]\width - #__window_frame_size*2, *bar\button[#__split_b2]\height - #__window_frame_size*2 - #__window_caption_height )
              Else
                Resize( splitter_second_gadget_( *bar\widget ), 
                        *bar\button[#__split_b2]\x - *bar\widget\x[#__c_frame], 
                        *bar\button[#__split_b2]\y - *bar\widget\y[#__c_frame], 
                        *bar\button[#__split_b2]\width, *bar\button[#__split_b2]\height )
              EndIf
              
            EndIf
          EndIf   
        EndIf      
        
        result = Bool( *bar\widget\resize & #__resize_change )
      EndIf
      
      ;
      If *bar\widget\type = #__type_TrackBar
        If *bar\direction > 0 
          If *bar\thumb\pos = *bar\area\end Or *bar\widget\flag & #PB_TrackBar_Ticks
            *bar\button[#__b_3]\arrow\direction = Bool( Not *bar\widget\vertical ) + Bool( *bar\widget\vertical = *bar\invert ) * 2
          Else
            *bar\button[#__b_3]\arrow\direction = Bool( *bar\widget\vertical ) + Bool( Not *bar\invert ) * 2
          EndIf
        Else
          If *bar\thumb\pos = *bar\area\pos Or *bar\widget\flag & #PB_TrackBar_Ticks 
            *bar\button[#__b_3]\arrow\direction = Bool( Not *bar\widget\vertical ) + Bool( *bar\widget\vertical = *bar\invert ) * 2
          Else
            *bar\button[#__b_3]\arrow\direction = Bool( *bar\widget\vertical ) + Bool( *bar\invert ) * 2
          EndIf
        EndIf
        
        ; button draw color
        *bar\button[#__b_3]\color\state = #__S_2
        If Not *bar\widget\flag & #PB_TrackBar_Ticks
          If *bar\invert
            *bar\button[#__b_2]\color\state = #__S_2
            ; *bar\button[#__b_1]\color\state = #__S_3
          Else
            ; *bar\button[#__b_2]\color\state = #__S_3
            *bar\button[#__b_1]\color\state = #__S_2
          EndIf
        EndIf
        
        ; track bar draw coordinate
        If *bar\widget\vertical
          If *bar\thumb\len
            *bar\button[#__b_3]\y      = *bar\widget\y[#__c_inner_b] + *bar\thumb\pos
            *bar\button[#__b_3]\height = *bar\thumb\len                              
          EndIf
          
          *bar\button[#__b_1]\width    = 4
          *bar\button[#__b_2]\width    = 4
          *bar\button[#__b_3]\width    = *bar\button[#__b_3]\size + ( Bool( *bar\button[#__b_3]\size<10 )**bar\button[#__b_3]\size )
          
          *bar\button[#__b_1]\y        = *bar\widget\y
          *bar\button[#__b_1]\height   = *bar\thumb\pos + *bar\thumb\len/2 
          
          *bar\button[#__b_2]\y        = *bar\widget\y[#__c_inner_b] + *bar\thumb\pos + *bar\thumb\len/2
          *bar\button[#__b_2]\height   = *bar\widget\height - ( *bar\thumb\pos + *bar\thumb\len/2 )
          
          If *bar\invert
            *bar\button[#__b_1]\x      = *bar\widget\x[#__c_frame] + 6
            *bar\button[#__b_2]\x      = *bar\widget\x[#__c_frame] + 6
            *bar\button[#__b_3]\x      = *bar\button[#__b_1]\x - *bar\button[#__b_3]\width/4 - 1 -  Bool( *bar\button[#__b_3]\size>10 )
          Else
            *bar\button[#__b_1]\x      = *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] - *bar\button[#__b_1]\width - 6
            *bar\button[#__b_2]\x      = *bar\widget\x[#__c_frame] + *bar\widget\width[#__c_frame] - *bar\button[#__b_2]\width - 6 
            *bar\button[#__b_3]\x      = *bar\button[#__b_1]\x - *bar\button[#__b_3]\width/2 + Bool( *bar\button[#__b_3]\size>10 )
          EndIf
        Else
          If *bar\thumb\len
            *bar\button[#__b_3]\x      = *bar\widget\x[#__c_inner_b] + *bar\thumb\pos 
            *bar\button[#__b_3]\width  = *bar\thumb\len                                  
          EndIf
          
          *bar\button[#__b_1]\height   = 4
          *bar\button[#__b_2]\height   = 4
          *bar\button[#__b_3]\height   = *bar\button[#__b_3]\size + ( Bool( *bar\button[#__b_3]\size<10 )**bar\button[#__b_3]\size )
          
          *bar\button[#__b_1]\x        = *bar\widget\x[#__c_frame]
          *bar\button[#__b_1]\width    = *bar\thumb\pos + *bar\thumb\len/2
          
          *bar\button[#__b_2]\x        = *bar\widget\x[#__c_inner_b] + *bar\thumb\pos + *bar\thumb\len/2
          *bar\button[#__b_2]\width    = *bar\widget\width[#__c_frame] - ( *bar\thumb\pos + *bar\thumb\len/2 )
          
          If *bar\invert
            *bar\button[#__b_1]\y      = *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] - *bar\button[#__b_1]\height - 6
            *bar\button[#__b_2]\y      = *bar\widget\y[#__c_frame] + *bar\widget\height[#__c_frame] - *bar\button[#__b_2]\height - 6 
            *bar\button[#__b_3]\y      = *bar\button[#__b_1]\y - *bar\button[#__b_3]\height/2 + Bool( *bar\button[#__b_3]\size>10 )
          Else
            *bar\button[#__b_1]\y      = *bar\widget\y[#__c_frame] + 6
            *bar\button[#__b_2]\y      = *bar\widget\y[#__c_frame] + 6
            *bar\button[#__b_3]\y      = *bar\button[#__b_1]\y - *bar\button[#__b_3]\height/4 - 1 -  Bool( *bar\button[#__b_3]\size>10 )
          EndIf
        EndIf
        
      EndIf
      
      
      
      ;
      If *bar\page\change <> 0
        ;- widget::bar_parent_area_update_( )
        If *bar\widget\parent\widget And *bar\widget\parent\widget\scroll And *bar\widget\type = #__type_ScrollBar
          
          If *bar\widget\vertical
            If *bar\widget\parent\widget\scroll\v = *bar\widget
              *bar\widget\parent\widget\change =- 1
              scroll_y_( *bar\widget\parent\widget ) =- *bar\page\pos
              
              ; row pos update
              If *bar\widget\parent\widget\row
                If *bar\widget\parent\widget\text\editable
                  Editor_Update( *bar\widget\parent\widget, RowList( *bar\widget\parent\widget ))
                Else
                  update_visible_items_( *bar\widget\parent\widget )
                EndIf 
                
                *bar\widget\parent\widget\change = 0
              EndIf
              
              ; Area childrens x&y auto move 
              If *bar\widget\parent\widget\container
                If StartEnumerate( *bar\widget\parent\widget ) 
                  If *bar\widget\parent\widget = Widget( )\parent\widget And 
                     *bar\widget\parent\widget\scroll\v <> Widget( ) And 
                     *bar\widget\parent\widget\scroll\h <> Widget( ) And Not Widget( )\align
                    
                    If is_integral_( Widget( ))
                      Resize( Widget( ), #PB_Ignore, ( Widget( )\y[#__c_container] + *bar\page\change ), #PB_Ignore, #PB_Ignore )
                    Else
                      Resize( Widget( ), #PB_Ignore, ( Widget( )\y[#__c_container] + *bar\page\change ) - scroll_y_( *bar\widget\parent\widget ), #PB_Ignore, #PB_Ignore )
                    EndIf
                  EndIf
                  
                  StopEnumerate( )
                EndIf
              EndIf
            EndIf
          Else
            If *bar\widget\parent\widget\scroll\h = *bar\widget
              *bar\widget\parent\widget\change =- 2
              scroll_x_( *bar\widget\parent\widget ) =- *bar\page\pos
              
              ; Area childrens x&y auto move 
              If *bar\widget\parent\widget\container
                If StartEnumerate( *bar\widget\parent\widget ) 
                  If *bar\widget\parent\widget = Widget( )\parent\widget And 
                     *bar\widget\parent\widget\scroll\v <> Widget( ) And 
                     *bar\widget\parent\widget\scroll\h <> Widget( ) And Not Widget( )\align
                    
                    If is_integral_( Widget( ))
                      Resize( Widget( ), ( Widget( )\x[#__c_container] + *bar\page\change ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                    Else
                      Resize( Widget( ), ( Widget( )\x[#__c_container] + *bar\page\change ) - scroll_x_( *bar\widget\parent\widget ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                    EndIf
                  EndIf
                  
                  StopEnumerate( )
                EndIf
              EndIf
            EndIf
          EndIf
          
        EndIf
        
        ;
        If *bar\widget\type = #__type_Spin Or
           *bar\widget\type = #__type_ProgressBar
          
          Protected i
          For i = 0 To 3
            If *bar\widget\scroll\increment = ValF(StrF(*bar\widget\scroll\increment, i))
              *bar\widget\text\string = StrF(*bar\page\pos, i)
              *bar\widget\text\change = 1
              Break
            EndIf
          Next
        EndIf
        
        ;
        If *bar\widget\root\canvas\gadget <> PB(EventGadget)( ) And PB(IsGadget)( PB(EventGadget)( )) 
          Debug "bar redraw - "+*bar\widget\root\canvas\gadget +" "+ PB(EventGadget)( ) +" "+ EventGadget( )
          ReDraw( *bar\widget\root ) 
        EndIf
        
        ;         If is_integral_( *bar\widget )
        ;           If *bar\widget\type = #__type_ScrollBar ; is_scrollbars_( *bar\widget )
        ;             Post( *bar\widget\parent\widget, #PB_EventType_ScrollChange, *bar\widget, *bar\page\change )
        ;           EndIf
        ;         Else
        ;           Post( *bar\widget, #PB_EventType_Change, EnteredButton( ), *bar\page\change )
        ;         EndIf
        
        *bar\page\change = 0
      EndIf 
      
      ; 
      If *bar\thumb\change <> 0
        If *bar\widget\root\canvas\gadget = PB(EventGadget)( ) 
          result = *bar\thumb\change
        EndIf
        
        *bar\thumb\change = 0
      EndIf  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b bar_Update( *bar._S_BAR )
      Protected fixed.l, result.b, ScrollPos.f, ThumbPos.i
      Protected bordersize = 0;*bar\widget\bs
      Protected width = *bar\widget\width[#__c_frame]
      Protected height = *bar\widget\height[#__c_frame]
      
      If *bar\widget\type = #__type_Spin 
        If *bar\widget\vertical
          *bar\area\len = height 
        Else
          *bar\area\len = width 
        EndIf
        
        ; set real spin-buttons height
        If Not *bar\widget\flag & #__spin_Plus
          *bar\button[#__b_1]\size =  height/2 + Bool( height % 2 )
          *bar\button[#__b_2]\size = *bar\button[#__b_1]\size
        EndIf
        
        ;*bar\area\pos = ( *bar\button[#__b_1]\size + *bar\min[1] )
        *bar\thumb\end = *bar\area\len - ( *bar\button[#__b_1]\size + *bar\button[#__b_2]\size )
        
        *bar\page\end = *bar\max 
        *bar\area\end = *bar\max - *bar\thumb\Len 
        *bar\percent = ( *bar\area\end - *bar\area\pos ) / ( *bar\page\end - *bar\min )
        
      Else
        ; get area size
        If *bar\widget\vertical
          *bar\area\len = height 
        Else
          *bar\area\len = width 
        EndIf
        
        If *bar\widget\type = #__type_ScrollBar 
          ; default button size
          If *bar\max 
            If *bar\button[#__b_1]\size =- 1 And *bar\button[#__b_2]\size =- 1
              If *bar\widget\vertical And width > 7 And width < 21
                *bar\button[#__b_1]\size = width - 1
                *bar\button[#__b_2]\size = width - 1
                
              ElseIf Not *bar\widget\vertical And height > 7 And height < 21
                *bar\button[#__b_1]\size = height - 1
                *bar\button[#__b_2]\size = height - 1
                
              Else
                *bar\button[#__b_1]\size = *bar\button[#__b_3]\size
                *bar\button[#__b_2]\size = *bar\button[#__b_3]\size
              EndIf
            EndIf
            
            ;           If *bar\button[#__b_3]\size
            ;             If *bar\widget\vertical
            ;               If *bar\widget\width = 0
            ;                 *bar\widget\width = *bar\button[#__b_3]\size
            ;               EndIf
            ;             Else
            ;               If *bar\widget\height = 0
            ;                 *bar\widget\height = *bar\button[#__b_3]\size
            ;               EndIf
            ;             EndIf
            ;           EndIf
          EndIf
        EndIf
        
        
        *bar\area\pos = ( *bar\button[#__b_1]\size + *bar\min[1] ) + bordersize
        *bar\thumb\end = *bar\area\len - ( *bar\button[#__b_1]\size + *bar\button[#__b_2]\size ) - bordersize*2
        
        If ( *bar\widget\type = #__type_TabBar Or *bar\widget\type = #__type_ToolBar )
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
            If *bar\thumb\len < *bar\button[#__b_3]\size 
              If *bar\thumb\end > *bar\button[#__b_3]\size + *bar\thumb\len
                *bar\thumb\len = *bar\button[#__b_3]\size 
              ElseIf *bar\button[#__b_3]\size > 7
                Debug "get thumb size - ????? "+*bar\widget\class
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
              *bar\thumb\len = *bar\button[#__b_3]\size
              ;*bar\thumb\len = Round(( *bar\thumb\end / ( *bar\max - *bar\min )), #PB_Round_Nearest )
              *bar\page\end = *bar\max
            Else
              ; get thumb size
              *bar\thumb\len = *bar\button[#__b_3]\size
              
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
          *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\page\end - *bar\min )
        Else
          *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\min )
        EndIf
        
        *bar\area\end = *bar\area\len - *bar\thumb\len - ( *bar\button[#__b_2]\size + *bar\min[2] + bordersize )
      EndIf
      
      ;Debug ""+*bar\thumb\len +" "+ *bar\thumb\end +" "+ *bar\widget\class
      ProcedureReturn 1;bar_Resize( *bar )  
    EndProcedure
    
    Procedure.b bar_Change( *bar._S_BAR, ScrollPos.f )
      With *this
        ;Debug ""+ScrollPos +" "+ *bar\page\end
        
        ;If ScrollPos < *bar\min : ScrollPos = *bar\min : EndIf 
        If ScrollPos < *bar\min 
          If *bar\max > *bar\page\len 
            ScrollPos = *bar\min 
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
          If is_integral_( *bar\widget )
            If *bar\widget\type = #__type_ScrollBar ; is_scrollbars_( *bar\widget )
              DoEvents( *bar\widget\parent\widget, #PB_EventType_ScrollChange, *bar\widget, *bar\page\change )
            EndIf
          Else
            Post( *bar\widget, #PB_EventType_Change, EnteredButton( ), *bar\page\change )
          EndIf
          
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b bar_SetState( *bar._S_BAR, state.f )
      ;       If *bar\widget\type = #__type_TabBar
      ;         bar_tab_SetState( *bar\widget, state )
      ;       Else
      If bar_Change( *bar, state ) 
        bar_Update( *bar ) 
        ProcedureReturn bar_Resize( *bar )
      EndIf
      ;       EndIf
    EndProcedure
    
    Procedure.b bar_SetPos( *bar._S_BAR, ThumbPos.i )
      Protected ScrollPos.f
      
      If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
      If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
      
      If *bar\thumb\pos <> ThumbPos 
        ScrollPos = bar_page_pos_( *bar, ThumbPos )
        ScrollPos = bar_invert_page_pos_( *bar, ScrollPos )
        
        ;
        If *bar\widget\scroll\increment > 1
          ScrollPos - Mod( ScrollPos, *bar\widget\scroll\increment )
        EndIf
        
        ; thumb move tick steps
        If *bar\widget\type = #__type_trackbar And 
           *bar\widget\flag & #PB_TrackBar_Ticks
          ThumbPos = bar_thumb_pos_( *bar, ScrollPos )
          ThumbPos = bar_invert_thumb_pos_( *bar, ThumbPos )
        EndIf
        
        If *bar\thumb\change <> *bar\thumb\pos - ThumbPos 
          *bar\thumb\change = *bar\thumb\pos - ThumbPos 
          *bar\thumb\pos = ThumbPos
          If bar_Change( *bar, ScrollPos )
            *bar\widget\state\flag | #__S_scroll
          EndIf
          ProcedureReturn bar_Resize( *bar )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.l bar_SetAttribute( *this._S_widget, Attribute.l, *value )
      Protected result.l
      
      With *this
        If \type = #__type_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              *this\bar\min[1] = *value 
              ;*this\bar\button[#__b_1]\size = *value 
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *this\bar\min[2] = *value
              ;*this\bar\button[#__b_2]\size = *value 
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_FirstGadget
              splitter_first_gadget_( *this ) = *value
              splitter_is_first_gadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
            Case #PB_Splitter_SecondGadget
              splitter_second_gadget_( *this ) = *value
              splitter_is_second_gadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If *this\bar\min <> *value ;And Not *value < 0
                *this\bar\area\change = *this\bar\min - *value
                If *this\bar\page\pos < *value
                  *this\bar\page\pos = *value
                EndIf
                *this\bar\min = *value
                ; Debug  " min " + *this\bar\min + " max " + *this\bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If *this\bar\max <> *value And Not ( *value < 0 And Not #__bar_minus)
                *this\bar\area\change = *this\bar\max - *value
                
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
                *this\bar\area\change = *this\bar\page\len - *value
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
              If *this\bar\button[#__b_3]\size <> *value
                *this\bar\button[#__b_3]\size = *value
                
                If *this\type = #__type_spin
                  If *this\flag & #__spin_plus
                    ; set real spin-buttons width
                    *this\bar\button[#__b_1]\size = *value
                    *this\bar\button[#__b_2]\size = *value
                    
                    If *this\vertical
                      *this\fs[2] = *this\bar\button[#__b_2]\size - 1
                      *this\fs[4] = *this\bar\button[#__b_1]\size - 1
                    Else
                      *this\fs[1] = *this\bar\button[#__b_1]\size - 1
                      *this\fs[3] = *this\bar\button[#__b_2]\size - 1                      
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
                      *this\bar\button[#__b_1]\size = #PB_Default
                      *this\bar\button[#__b_2]\size = #PB_Default
                    Else
                      *this\bar\button[#__b_1]\size = 0
                      *this\bar\button[#__b_2]\size = 0
                    EndIf
                  EndIf
                  
                  ; if it is a composite element of the parent
                  If *this\child > 0 And *this\parent\widget And *value
                    *value + 1
                    If *this\vertical
                      Resize(*this, *this\parent\widget\width[#__c_container]-*value, #PB_Ignore, *value, #PB_Ignore)
                    Else
                      Resize(*this, #PB_Ignore, *this\parent\widget\width[#__c_container]-*value, #PB_Ignore, *value)
                    EndIf
                  EndIf
                  
                  bar_Update( *this\bar )
                  bar_Resize( *this\bar )
                  PostEventCanvas( *this\root )
                  
                  ProcedureReturn #True
                EndIf
              EndIf
              
            Case #__bar_invert
              *this\bar\invert = Bool( *value )
              bar_Update( *this\bar )
              ProcedureReturn bar_Resize( *this\bar )  
            Case #__bar_ScrollStep 
              \scroll\increment = *value
              
          EndSelect
        EndIf
        
        If result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\page\change = #True
                  ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
          
          If *this\root ;And *this\root\canvas\postevent = #False
            bar_Update( *this\bar ) ; \hide = 
            bar_Resize( *this\bar )  
          EndIf
          
          ; after update and resize bar
          If *this\type = #__type_ScrollBar And
             Attribute = #__bar_buttonsize
            *this\bar\button[#__b_1]\size =- 1
            *this\bar\button[#__b_2]\size =- 1
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
    
    Procedure   bar_Updates( *this._S_widget, x.l,y.l,width.l,height.l )
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
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
          ;           *this\scroll\h\hide = bar_Update( *this\scroll\h\bar )
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
          ;           *this\scroll\v\hide = bar_Update( *this\scroll\v\bar )
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
        bar_Resize( *this\scroll\v\bar )  
        *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len )) 
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        bar_Update( *this\scroll\h\bar ) 
        bar_Resize( *this\scroll\h\bar )  
        *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len )) 
      EndIf
      
      ProcedureReturn result
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
            \v\height[#__c_clip] = \v\parent\widget\height[#__c_clip]
            
            bar_Update( \v\bar )
            bar_Resize( \v\bar )
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
                bar_Resize( \v\bar )
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
            \h\width[#__c_clip] = \h\parent\widget\width[#__c_clip]
            
            bar_Update( \h\bar )
            bar_Resize( \h\bar )
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
                bar_Resize( \h\bar )
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
            \v\hide = #True
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If bar_Change( \v\bar, \v\bar\min )
                bar_Resize( \v\bar )
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
            \h\hide = #True
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If bar_Change( \h\bar, \h\bar\min )
                bar_Resize( \h\bar )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ProcedureReturn Bool( \v\bar\area\change Or \h\bar\area\change )
      EndWith
    EndProcedure
    
    
    Procedure   bar_Events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
      Protected Repaint
      
      If eventtype = #PB_EventType_LeftButtonDown
        If FocusedButton( ) <> EnteredButton( ) 
          FocusedButton( ) = EnteredButton( )
        EndIf
        ; change the color state of non-disabled buttons
        
        If EnteredButton( ) And 
           EnteredButton( )\color\state <> #__S_3 And 
           EnteredButton( )\state\flag & #__S_disable = #False
          EnteredButton( )\state\press = #True
          
          If Not ( *this\type = #__type_TrackBar Or 
                   ( *this\type = #__type_Splitter And 
                     EnteredButton( ) <> *this\bar\button[#__b_3] ))
            EnteredButton( )\color\state = #__S_2
          EndIf
          
          If *this\bar\button[#__b_3]\state\press
            Repaint = #True
          ElseIf ( *this\bar\button[#__b_1]\state\press And *this\bar\invert ) Or
                 ( *this\bar\button[#__b_2]\state\press And Not *this\bar\invert )
            
            Post( *this, #PB_EventType_Down )
            ;;Repaint | bar_SetState( *this\bar, *this\bar\page\pos + *this\scroll\increment )
            If bar_Change( *this\bar, *this\bar\page\pos + *this\scroll\increment ) 
              bar_Update( *this\bar ) 
              Repaint = bar_Resize( *this\bar )  
            EndIf
            
          ElseIf ( *this\bar\button[#__b_2]\state\press And *this\bar\invert ) Or 
                 ( *this\bar\button[#__b_1]\state\press And Not *this\bar\invert )
            
            Post( *this, #PB_EventType_Up )
            ;; Repaint | bar_SetState( *this\bar, *this\bar\page\pos - *this\scroll\increment )
            If bar_Change( *this\bar, *this\bar\page\pos - *this\scroll\increment ) 
              bar_Update( *this\bar ) 
              Repaint = bar_Resize( *this\bar )  
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If FocusedButton( ) And
           FocusedButton( )\state\press = #True  
          FocusedButton( )\state\press = #False 
          
          If FocusedButton( )\color\state <> #__S_3 And 
             FocusedButton( )\state\flag & #__S_disable = #False 
            
            ; change color state
            If FocusedButton( )\color\state = #__S_2 And
               Not ( *this\type = #__type_TrackBar Or 
                     ( *this\type = #__type_Splitter And 
                       FocusedButton( ) <> *this\bar\button[#__b_3] ))
              
              If FocusedButton( )\state\enter
                FocusedButton( )\color\state = #__S_1
              Else
                ; for the splitter thumb
                If *this\bar\button[#__b_3] = FocusedButton( ) And 
                   *this\bar\button[#__b_2]\size <> $ffffff
                  _cursor_remove_( *this )
                EndIf
                
                FocusedButton( )\color\state = #__S_0 
              EndIf
            EndIf
            
            ;- widget::tab_bar_events_( up )
            If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
              ;Debug Bool( *this\state\flag & #__S_scroll ) ; ""+*this\bar\page\change+" "+*this\bar\thumb\change
              ; that is, if you did not move the items
              If Not *this\state\flag & #__S_scroll And
                 FocusedButton( ) = *this\bar\button[#__b_3] 
                
                
                If EnteredTabindex( *this ) >= 0 And 
                   FocusedTabindex( *this ) <> EnteredTabindex( *this )
                  ;; Debug EnteredTabindex( *this )
                  Repaint | bar_tab_SetState( *this, EnteredTabindex( *this ) )
                EndIf
                ;                 If EnteredTab( *this )\index >= 0 And 
                ;                    FocusedTabindex( *this ) <> EnteredTab( *this )\index
                ;                   Debug EnteredTabindex( *this )
                ;                   Repaint | bar_tab_SetState( *this, EnteredTab( *this )\index )
                ;                 EndIf
              EndIf
              
              *this\state\flag &~ #__S_scroll
            EndIf
            
            Repaint = 1
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_MouseMove
        If *this\state\press And FocusedButton( ) = *this\bar\button[#__b_3]
          If *this\vertical
            Repaint | bar_SetPos( *this\bar, ( mouse_y - Mouse( )\delta\y ))
          Else
            Repaint | bar_SetPos( *this\bar, ( mouse_x - Mouse( )\delta\x ))
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
      ( row_x_( _this_, RowList( _this_ ) ) + RowList( _this_ )\text\edit#_mode_\x )
    EndMacro
    
    Macro edit_row_edit_text_y_( _this_, _mode_ ) ; пока не используется
      ( row_y_( _this_, RowList( _this_ ) ) + RowList( _this_ )\text\edit#_mode_\y )
    EndMacro
    
    Macro edit_row_select_( _this_, _address_, _index_ )
      _address_\state\focus = 0
      ;_address_\state\enter = 0
      _address_\color\state = 0
      
      _address_ = SelectElement( RowList( _this_ ), _index_ )
      
      If _address_
        _address_\color\state = 1
        ;_address_\state\enter = 1
        _address_\state\focus = 1
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
    
    Macro edit_caret_pos_( _this_ ): _this_\text\caret\pos[0]: EndMacro
    Macro edit_caret_pos_delta_( _this_ ): _this_\text\caret\pos[1]: EndMacro
    
    Macro edit_row_caret_pos_( _this_ ): _this_\text\caret\pos[2]: EndMacro
    
    Macro edit_row_caret_left_pos_( _address_ )
      edit_caret_pos_( _address_ )
    EndMacro
    
    Macro edit_row_caret_right_pos_( _address_ )
      edit_caret_pos_delta_( _address_ )
    EndMacro
    
    Macro edit_line_pos_( _this_ ): _this_\text\caret\line[0]: EndMacro ; Returns mouse entered widget
    Macro edit_line_pos_delta_( _this_ ): _this_\text\caret\line[1]: EndMacro ; Returns mouse entered widget
    
    Macro edit_change_text_( _address_, _char_len_ = 0, _position_ = )
      _address_\text\edit#_position_\len + _char_len_
      _address_\text\len = _address_\text\edit[1]\len + _address_\text\edit[3]\len
      _address_\text\string.s = Left( _address_\text\string.s, _address_\text\edit[1]\len ) + Right( _address_\text\string.s, _address_\text\edit[3]\len )
    EndMacro
    
    Procedure.l edit_caret_( *this._S_widget )
      ; Get caret position
      Protected i.l, mouse_x.l, caret_x.l, caret.l =- 1
      Protected Distance.f, MinDistance.f = Infinity( )
      
      If EnteredRow( *this )
        mouse_x = Mouse( )\x - row_text_x_( *this, EnteredRow( *this ) ) - scroll_x_( *this ) 
        
        For i = 0 To EnteredRow( *this )\text\len
          caret_x = TextWidth( Left( EnteredRow( *this )\text\string, i ))
          
          Distance = ( mouse_x - caret_x )*( mouse_x - caret_x )
          
          If MinDistance > Distance 
            MinDistance = Distance
            ; *this\text\caret\x = *this\text\padding\x + caret_x
            caret = EnteredRow( *this )\text\pos + i
          Else
            Break
          EndIf
        Next 
      EndIf
      
      ProcedureReturn caret
    EndProcedure
    
    Procedure   edit_sel_row_text_( *this._S_widget, *row._S_rows, mode.l = 0, drawing.b = 0 )
      Protected CaretLeftPos, CaretRightPos, CaretLastLen= 0
      Debug "edit_sel_row_text - "+*row\index +" "+ mode
      
      If drawing
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
          StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
          DrawingFont( *row\text\fontid )
        CompilerEndIf
      EndIf
      
      
      If mode =- 14 ; ok leave from
        edit_caret_pos_( *this ) = *row\text\pos
        
        ; Debug ""+edit_caret_pos_( *this ) +" "+ *row\text\pos
        CaretLeftPos = 0
        CaretRightPos = 0 
        
      ElseIf mode =- 6 ; 
        
        CaretLeftPos = 0
        CaretRightPos = 0 
        
      ElseIf mode =- 5 ; 
        
        CaretLeftPos = 0
        CaretRightPos = *row\text\len  
        CaretLastLen = *this\mode\fullselection
        
      ElseIf mode =- 10 ; ok leave bottom
        If *row = PressedRow( *this )
          CaretLeftPos = edit_caret_pos_delta_( *this ) - *row\text\pos
        Else
          CaretLeftPos = 0
        EndIf
        CaretRightPos = *row\text\len 
        If *row\index <> *this\count\items - 1
          CaretLastLen = *this\mode\fullselection
        EndIf
        edit_caret_pos_( *this ) = *row\text\pos + *row\text\len 
        
      ElseIf mode =- 9 ; ok leave top
        CaretLeftPos = 0
        If *row = PressedRow( *this )
          CaretRightPos = edit_caret_pos_delta_( *this ) - *row\text\pos
        Else
          CaretRightPos = *row\text\len
          CaretLastLen = *this\mode\fullselection
        EndIf
        edit_caret_pos_( *this ) = *row\text\pos 
        
      Else
        If edit_caret_pos_( *this ) >= edit_caret_pos_delta_( *this )
          If *row\text\pos <= edit_caret_pos_delta_( *this )
            CaretLeftPos = edit_caret_pos_delta_( *this ) - *row\text\pos
          EndIf
          CaretRightPos = edit_caret_pos_( *this ) - *row\text\pos
        Else
          CaretLeftPos = edit_caret_pos_( *this ) - *row\text\pos
          If edit_caret_pos_delta_( *this ) > ( *row\text\pos + *row\text\len )
            CaretLastLen = *this\mode\fullselection
            CaretRightPos = *row\text\len
          Else
            CaretRightPos = edit_caret_pos_delta_( *this ) - *row\text\pos
          EndIf
        EndIf
      EndIf
      
      ; Debug "caret change " + CaretLeftPos +" "+ CaretRightPos
      
      *row\text\edit[1]\pos = 0 
      *row\text\edit[2]\pos = CaretLeftPos  ; - *row\text\pos
      *row\text\edit[3]\pos = CaretRightPos ; - *row\text\pos
      
      *row\text\edit[1]\len = *row\text\edit[2]\pos
      *row\text\edit[2]\len = *row\text\edit[3]\pos - *row\text\edit[2]\pos
      *row\text\edit[3]\len = *row\text\len - *row\text\edit[3]\pos
      
      ; item left text
      If *row\text\edit[1]\len > 0
        *row\text\edit[1]\string = Left( *row\text\string, *row\text\edit[1]\len )
        *row\text\edit[1]\width = TextWidth( *row\text\edit[1]\string ) 
        *row\text\edit[1]\y = *row\text\y
        *row\text\edit[1]\height = *row\text\height
      Else
        *row\text\edit[1]\string = ""
        *row\text\edit[1]\width = 0
      EndIf
      ; item right text
      If *row\text\edit[3]\len > 0
        *row\text\edit[3]\y = *row\text\y
        *row\text\edit[3]\height = *row\text\height
        If *row\text\edit[3]\len = *row\text\len
          *row\text\edit[3]\string = *row\text\string
          *row\text\edit[3]\width = *row\text\width
        Else
          *row\text\edit[3]\string = Right( *row\text\string, *row\text\edit[3]\len )
          *row\text\edit[3]\width = TextWidth( *row\text\edit[3]\string )  
        EndIf
      Else
        *row\text\edit[3]\string = ""
        *row\text\edit[3]\width = 0
      EndIf
      ; item edit text
      If *row\text\edit[2]\len > 0
        If *row\text\edit[2]\len = *row\text\len
          *row\text\edit[2]\string = *row\text\string
          *row\text\edit[2]\width = *row\text\width
        Else
          *row\text\edit[2]\string = Mid( *row\text\string, 1 + *row\text\edit[2]\pos, *row\text\edit[2]\len )
          *row\text\edit[2]\width = *row\text\width - ( *row\text\edit[1]\width + *row\text\edit[3]\width )
          ; Debug ""+*row\text\edit[2]\width +" "+ TextWidth( *row\text\edit[2]\string )
        EndIf
        *row\text\edit[2]\y = *row\text\y
        *row\text\edit[2]\height = *row\text\height
      Else
        *row\text\edit[2]\string = ""
        *row\text\edit[2]\width = 0
      EndIf
      
      If CaretLastLen
        *row\text\edit[2]\width + CaretLastLen
      EndIf
      
      ; set text position
      *row\text\edit[1]\x = *row\text\x
      *row\text\edit[2]\x = *row\text\x + *row\text\edit[1]\width 
      *row\text\edit[3]\x = *row\text\x + *row\text\edit[1]\width + *row\text\edit[2]\width 
      
      ;       If edit_caret_pos_( *this ) > edit_caret_pos_delta_( *this )
      ;         *this\text\caret\x = *row\x + *row\text\edit[3]\x - 1
      ;       ElseIf edit_caret_pos_( *this ) < edit_caret_pos_delta_( *this )
      ;         *this\text\caret\x = *row\x + *row\text\edit[2]\x - 1
      ;       Else
      ;         If mode = 0
      ;          *this\text\caret\x = *row\x + *row\text\edit[2]\x - 1
      ;         EndIf
      ;         If mode = 3
      ;          *this\text\caret\x = *row\x + *row\text\edit[2]\x - 1
      ;         EndIf
      ;         If mode = 2
      ;           *this\text\caret\x = *row\x + *row\text\edit[3]\x - 1
      ;         EndIf
      ;       EndIf
      ;       *this\text\caret\height = *row\text\height
      ;       *this\text\caret\y = *row\y
      ;       
      
      If drawing
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
          StopDrawing( ) 
        CompilerEndIf
      EndIf
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_sel_text_( *this._S_widget, *line._S_rows )
      If *line < 0
        ; edit sel all items
        PushListPosition( RowList( *this ) )
        ForEach RowList( *this )
          edit_sel_row_text_( *this, RowList( *this ), - 10 )
        Next
        PopListPosition( RowList( *this ) )
        
        ; set caret to begin start
        edit_caret_pos_( *this ) = 0
        edit_caret_pos_delta_( *this ) = *this\text\len
        ;
        *line = FocusedRow( *this )
      EndIf
      
      If edit_caret_pos_( *this ) > edit_caret_pos_delta_( *this )
        *this\text\edit[2]\pos = edit_caret_pos_delta_( *this )
        *this\text\edit[3]\pos = edit_caret_pos_( *this )
        *this\text\caret\x = *line\x + *line\text\edit[3]\x - 1
      Else
        *this\text\edit[2]\pos = edit_caret_pos_( *this )
        *this\text\edit[3]\pos = edit_caret_pos_delta_( *this )
        *this\text\caret\x = *line\x + *line\text\edit[2]\x - 1
      EndIf
      *this\text\caret\height = *line\text\height
      *this\text\caret\y = *line\y
      
      ;       ;*this\text\caret\x = 13
      ;       ;Debug ""+*this\text\padding\x +" "+ *this\text\caret\x +" "+ edit_caret_pos_( *this ) +" "+ *line\text\edit[1]\string
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
    Declare DoEventItems( *this._S_widget, eventtype.l, *row._S_rows, *data )
    
    Procedure   edit_sel_pos( *this._S_widget, *entered._S_rows, *pressed._S_rows, caret, reset = 0, drawing.b=1 )
      Protected result.b, *row._S_rows
      
      If *this And *entered And *entered\state\enter
        If drawing
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
            StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
            DrawingFont( *entered\text\fontid )
          CompilerEndIf
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ; draw_font_item_( *this, *entered, 0 )
        CompilerEndIf
        
        If caret < 0
          If caret <- 1
            result =- 1
          EndIf
          caret = edit_caret_( *this )
        EndIf
        
        ; Debug ""+caret +" "+ edit_caret_pos_( *this ) +" "+ *this\text\caret\x +" "+ *entered\text\edit[3]\x +" "+ *entered\text\width
        If edit_caret_pos_( *this ) <> caret
          edit_caret_pos_( *this ) = caret
          
          If reset
            edit_caret_pos_delta_( *this ) = caret
            edit_row_caret_pos_( *this ) = caret - *entered\text\pos
            edit_line_pos_delta_( *this ) = *entered\index
            
            If *this\text\multiLine 
              ForEach RowList( *this ) 
                ;
                If RowList( *this )\text\edit[2]\width <> 0 
                  ; Debug " remove - " +" "+ RowList( *this )\text\string
                  edit_sel_row_text_( *this, RowList( *this ), - 6 )
                  ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                EndIf
                
                If RowList( *this )\state\focus = #True
                  RowList( *this )\state\focus = #False
                  ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                EndIf
              Next
            EndIf
            
            FocusedRow( *this ) = *entered
          EndIf
          
          If FocusedRow( *this ) <> *entered
            FocusedRow( *this ) = *entered
            
            If *this\text\multiLine 
              ; Debug "status change - " +  EnteredRow( *this )\index
              ForEach RowList( *this ) 
                If Bool(( FocusedRow( *this )\index >= RowList( *this )\index And 
                          PressedRow( *this )\index <= RowList( *this )\index ) Or ; верх
                        ( FocusedRow( *this )\index <= RowList( *this )\index And 
                          PressedRow( *this )\index >= RowList( *this )\index )) ; вниз
                  
                  ;
                  If RowList( *this )\index <> PressedRow( *this )\index And  
                     RowList( *this )\index <> FocusedRow( *this )\index 
                    
                    ;; Debug RowList( *this )\index
                    
                    If RowList( *this )\text\edit[2]\width <> RowList( *this )\text\width + *this\mode\fullselection
                      ; Debug "set - " +" "+ RowList( *this )\text\string
                      edit_sel_row_text_( *this, RowList( *this ), - 5 )
                      ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                    EndIf
                  EndIf
                  
                  If RowList( *this )\state\focus = #False
                    RowList( *this )\state\focus = #True
                    ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                  EndIf
                  
                Else
                  ;
                  If RowList( *this )\text\edit[2]\width <> 0 
                    ; Debug " remove - " +" "+ RowList( *this )\text\string
                    edit_sel_row_text_( *this, RowList( *this ), - 6 )
                    ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                  EndIf
                  
                  If RowList( *this )\state\focus = #True
                    RowList( *this )\state\focus = #False
                    ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                  EndIf
                  
                EndIf
              Next
              
              ;DoEvents( *this, #PB_EventType_StatusChange, EnteredRow( *this )\index, EnteredRow( *this ) )
            EndIf
          EndIf
          
          result = 1
          ;           edit_sel_row_text_( *this, *entered )
          ;           edit_sel_text_( *this, *entered )
          DoEventItems( *this, #PB_EventType_Repaint, *entered, 1 )
          DoEventItems( *this, #PB_EventType_MouseEnter, *entered, 0 )
          DoEventItems( *this, #PB_EventType_Repaint, *entered, - 1 )
          
          ; edit_line_pos_( *this ) = *entered\index
          ; DoEvents( *this, #PB_EventType_StatusChange, *entered\index, *entered )
          *this\state\repaint = 1
        EndIf
        
        If drawing
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
            StopDrawing( )
          CompilerEndIf
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
      Bool( RowList( _this_ )\text\edit[2]\width And 
            Mouse( )\x > RowList( _this_ )\text\edit[2]\x - scroll_x_( _this_ ) And
            Mouse( )\y > RowList( _this_ )\text\y - scroll_y_( _this_ ) And 
            Mouse( )\y < ( RowList( _this_ )\text\y + RowList( _this_ )\text\height ) - scroll_y_( _this_ ) And
            Mouse( )\x < ( RowList( _this_ )\text\edit[2]\x + RowList( _this_ )\text\edit[2]\width ) - scroll_x_( _this_ ) )
    EndMacro
    
    
    Procedure.i edit_sel_start_( *this._S_widget, caret, *row._S_rows )
      Protected result.i = *row\text\pos, i.i, char.i
      caret - *row\text\pos
      
      Macro edit_sel_end_( _char_ )
        Bool(( _char_ >= ' ' And _char_ <= '/' ) Or 
             ( _char_ >= ':' And _char_ <= '@' ) Or 
             ( _char_ >= '[' And _char_ <= 96 ) Or 
             ( _char_ >= '{' And _char_ <= '~' ))
      EndMacro
      
      ; | <<<<<< left edge of the word 
      If caret >= 0 
        For i = caret - 1 To 1 Step - 1
          char = Asc( Mid( *row\text\string.s, i, 1 ))
          If edit_sel_end_( char )
            result = *row\text\pos + i
            Break
          EndIf
        Next 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i edit_sel_stop_( *this._S_widget, caret, *row._S_rows )
      Protected result.i = *row\text\pos + *row\text\len, i.i, char.i
      caret - *row\text\pos
      
      ; >>>>>> | right edge of the word
      For i = caret + 2 To *row\text\len
        char = Asc( Mid( *row\text\string.s, i, 1 ))
        If edit_sel_end_( char )
          result = *row\text\pos + ( i - 1 )
          Break
        EndIf
      Next 
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_row_align( *this._S_widget )
      ; Debug ""+*this\text\align\anchor\left +" "+ *this\text\align\anchor\top +" "+ *this\text\align\anchor\right +" "+ *this\text\align\anchor\bottom
      ; set align position
      ForEach RowList( *this )
        If *this\vertical
        Else ; horizontal
          If *this\text\rotate = 180
            RowList( *this )\y - ( *this\height[#__c_inner] - scroll_height_( *this ) )
          EndIf
          
          ; changed
          set_align_y_( *this\text, RowList( *this )\text, - 1, *this\text\rotate )
          set_align_x_( *this\text, RowList( *this )\text, scroll_width_( *this ), *this\text\rotate )
          
          ;           If *this\type = #PB_GadgetType_String
          ;             Debug RowList( *this )\text\string
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
                left.s = Left( \text\string, edit_caret_pos_( *this ) )
                Select CountString( left.s, "." )
                  Case 0 : left.s = StringField( left.s, 1, "." )
                  Case 1 : left.s = StringField( left.s, 2, "." )
                  Case 2 : left.s = StringField( left.s, 3, "." )
                  Case 3 : left.s = StringField( left.s, 4, "." )
                EndSelect                                           
                count = Len( left.s + Trim( StringField( Mid( \text\string, edit_caret_pos_( *this )  + 1 ), 1, "." ), #LF$ ))
                If count < 3 And ( Val( left.s ) > 25 Or Val( left.s + Chr.s ) > 255 )
                  Continue
                  ;               ElseIf Mid( \text\string, edit_caret_pos_( *this ) + 1, 1 ) = "."
                  ;                 edit_caret_pos_( *this ) + 1 : edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid( \text\string, edit_caret_pos_( *this ) + 1, 1 ) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid( \text\string, edit_caret_pos_( *this ) + 1, 1 ) <> " - "
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
      Protected result.b, String.s, Count.i, *row._S_rows
      
      Chr.s = edit_make_insert_text( *this, Chr.s)
      
      If Chr.s
        *row = FocusedRow( *this )
        If *row
          Count = CountString( Chr.s, #LF$)
          
          If edit_caret_pos_( *this ) > edit_caret_pos_delta_( *this ) 
            edit_caret_pos_( *this ) = edit_caret_pos_delta_( *this ) 
          Else
            edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
          EndIf
          
          edit_caret_pos_( *this ) + Len( Chr.s )
          edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
          
          If count Or *row\index <> edit_line_pos_delta_( *this )
            *this\text\change =- 1
          EndIf
          
          If *row\text\edit[2]\width <> 0 
            *row\text\edit[2]\len = 0 
            *row\text\edit[2]\string.s = "" 
          Else
            *row\text\edit[1]\len + Len( Chr.s )
            *row\text\edit[1]\string.s + Chr.s
            
            *row\text\len = *row\text\edit[1]\len + *row\text\edit[3]\len 
            *row\text\string.s = *row\text\edit[1]\string.s + *row\text\edit[3]\string.s
            *row\text\width = TextWidth( *row\text\string )
          EndIf
          
          *this\text\edit[1]\len + Len( Chr.s )
          *this\text\edit[1]\string.s + Chr.s
          
          *this\text\len = *this\text\edit[1]\len + *this\text\edit[3]\len 
          *this\text\string.s = *this\text\edit[1]\string + *this\text\edit[3]\string
          
          ;
          If *row\index > edit_line_pos_delta_( *this )
            edit_line_pos_( *this ) = edit_line_pos_delta_( *this ) + Count
          Else
            edit_line_pos_( *this ) = *row\index + Count
          EndIf
          edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
          
          ; 
          If Not *this\text\change
            If scroll_width_( *this ) < *row\text\width
              scroll_width_( *this ) = *row\text\width
              
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
      If edit_line_pos_delta_( _this_ ) <> _index_
        _this_\text\change =- 1
      EndIf
      
      If edit_caret_pos_( _this_ ) > edit_caret_pos_delta_( _this_ ) 
        edit_caret_pos_( _this_ ) = edit_caret_pos_delta_( _this_ ) 
      Else
        edit_caret_pos_delta_( _this_ ) = edit_caret_pos_( _this_ ) 
      EndIf
      
      If edit_line_pos_delta_( _this_ ) > _index_
        edit_line_pos_( _this_ ) = _index_
        edit_line_pos_delta_( _this_ ) = _index_
      Else
        edit_line_pos_( _this_ ) = edit_line_pos_delta_( _this_ )
      EndIf
    EndMacro
    
    Procedure   edit_key_page_up_down_( *this._S_widget, wheel, row_select )
      Protected repaint, select_index, page_height
      Protected first_index = 0, last_index = *this\count\items - 1
      
      If wheel =- 1 ; page-up
        If row_select
          If row_select > 0
            select_index = VisibleFirstRow( *this )\index
          Else
            select_index = first_index
          EndIf 
          If FocusedRow( *this )\index <> select_index
            edit_row_select_( *this, FocusedRow( *this ), select_index )
            
            If select_index = first_index
              edit_caret_pos_( *this ) = 0
            Else  
              edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos + edit_row_caret_pos_( *this )
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint = 1
          EndIf
        Else
          If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos
            edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos
            repaint = 1
          EndIf
        EndIf
        
      ElseIf wheel = 1 ; page-down
        If row_select
          If row_select > 0
            select_index = VisibleLastRow( *this )\index
          Else
            select_index = last_index
          EndIf 
          If FocusedRow( *this )\index <> select_index
            edit_row_select_( *this, FocusedRow( *this ), select_index )
            
            If select_index = last_index
              edit_caret_pos_( *this ) = *this\text\len 
            Else  
              edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos + edit_row_caret_pos_( *this )
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint = 1
          EndIf
        Else
          If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
            edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
            repaint = 1
          EndIf
        EndIf
      EndIf
      
      If repaint
        edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
        edit_line_pos_( *this ) = FocusedRow( *this )\index
        edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
        
        If wheel =- 1
          row_scroll_y_( *this, FocusedRow( *this ), - page_height )
        ElseIf wheel = 1
          row_scroll_y_( *this, FocusedRow( *this ), + page_height )
        EndIf
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure   edit_key_caret_move_( *this._S_widget, _top_line_, _bottom_line_, move_position = 0, scroll_row_step = 1 )
      Protected result, caret =- 1
      
      If _top_line_ <> - 1 
        ; left in line
        If move_position And 
           edit_caret_pos_( *this ) > FocusedRow( *this )\text\pos 
          caret = edit_caret_pos_( *this ) - move_position
          edit_row_caret_pos_( *this ) = caret - FocusedRow( *this )\text\pos
          result = 1
        EndIf
        
        If result = 0
          ; prev line
          If FocusedRow( *this )\index > _top_line_ 
            If FocusedRow( *this )
              edit_row_select_( *this, FocusedRow( *this ), FocusedRow( *this )\index - scroll_row_step )
            EndIf
            
            If move_position
              ; перешли снизу верх
              caret = FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len 
            Else
              caret = FocusedRow( *this )\text\pos + edit_row_caret_pos_( *this )
            EndIf
            
            result =- 1
          Else
            ; first line
            If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos
              caret = FocusedRow( *this )\text\pos
              result = 1
            EndIf
          EndIf
        EndIf
        
      ElseIf _bottom_line_ <> - 1
        ; right in line
        If move_position And 
           edit_caret_pos_( *this ) < FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len 
          caret = edit_caret_pos_( *this ) + move_position
          edit_row_caret_pos_( *this ) = caret - FocusedRow( *this )\text\pos
          result = 1
        EndIf
        
        If result = 0
          ; next line
          If FocusedRow( *this )\index < _bottom_line_
            If FocusedRow( *this )
              edit_row_select_( *this, FocusedRow( *this ), FocusedRow( *this )\index + scroll_row_step )
            EndIf
            
            If move_position
              ; перешли сверху с конца вниз
              caret = FocusedRow( *this )\text\pos 
            Else
              caret = FocusedRow( *this )\text\pos + edit_row_caret_pos_( *this )
            EndIf
            
            result =- 1
          Else
            ; last line
            If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
              caret = FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
              result = 1
            EndIf
          EndIf
        EndIf
      EndIf
      
      If result
        If FocusedRow( *this ) <> RowList( *this )
          FocusedRow( *this ) = SelectElement( RowList( *this ), FocusedRow( *this )\index )
        EndIf             
        
        If keyboard( )\key[1] & #PB_Canvas_Shift
          Protected *entered._s_rows = SelectElement( RowList( *this ), FocusedRow( *this )\index )
          Protected *pressed._s_rows = SelectElement( RowList( *this ), edit_line_pos_delta_( *this ) )
          edit_sel_pos( *this, *entered, *pressed, caret )
        Else
          edit_caret_pos_( *this ) = caret
          edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
          
          edit_line_pos_( *this ) = FocusedRow( *this )\index 
          edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
        EndIf
        
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure   edit_key_home_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control 
        If edit_caret_pos_( *this ) <> 0
          edit_caret_pos_( *this ) = 0
          edit_line_pos_( *this ) = 0
          
          Debug "key ctrl home"
          result = 1
        EndIf
      Else
        If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos
          edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos
          edit_line_pos_( *this ) = FocusedRow( *this )\index
          
          Debug "key home"
          result = 1
        EndIf
      EndIf
      
      If result
        edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
        edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
        edit_row_caret_pos_( *this ) = edit_caret_pos_( *this ) - FocusedRow( *this )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_key_end_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control 
        If edit_caret_pos_( *this ) <> *this\text\len 
          edit_caret_pos_( *this ) = *this\text\len 
          edit_line_pos_( *this ) = *this\count\items - 1
          
          Debug "key ctrl end"
          result = 1
        EndIf
      Else
        If edit_caret_pos_( *this ) <> FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
          edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len 
          edit_line_pos_( *this ) = FocusedRow( *this )\index
          
          Debug "key end"
          result = 1
        EndIf
      EndIf
      
      If result
        edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
        edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
        edit_row_caret_pos_( *this ) = edit_caret_pos_( *this ) - FocusedRow( *this )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   edit_key_backup_( *this._S_widget )
      Protected Repaint, remove_chr_len, *row._S_rows = FocusedRow( *this ) 
      
      If *this\text\edit[2]\len
        edit_caret_change_( *this, *row\index )
        
        remove_chr_len = 0
        edit_change_text_( *row, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint =- 1
        
      ElseIf edit_caret_pos_( *this ) > *row\text\pos 
        edit_caret_pos_( *this ) - 1 
        edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
        edit_line_pos_( *this ) = *row\index
        
        remove_chr_len = 1
        edit_change_text_( *row, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint =- 1
      Else
        If *row\index > 0
          remove_chr_len = Len( #LF$ )
          edit_caret_pos_( *this ) - remove_chr_len
          edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
          
          edit_line_pos_( *this ) = *row\index - 1
          edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
          *this\text\change =- 1 
          ;*this\row\count = 0
          
          edit_change_text_( *row, - remove_chr_len, [1] )
          edit_change_text_( *this, - remove_chr_len, [1] )
          Repaint =- 1
          
        Else
          *this\notify = 2
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   edit_key_delete_( *this._S_widget )
      Protected Repaint, remove_chr_len, *row._S_rows = FocusedRow( *this )
      
      If *this\text\edit[2]\len
        edit_caret_change_( *this, *row\index )
        
        remove_chr_len = 1
        Repaint =- 1
        
      ElseIf edit_caret_pos_( *this ) < *this\text\len ; ok
        If edit_caret_pos_( *this ) = *row\text\pos + *row\text\len
          remove_chr_len = Len( #LF$ )
          *this\text\change =- 1
        Else
          remove_chr_len = 1
        EndIf
        
        ;Debug ""+edit_caret_pos_( *this ) +" "+ *this\text\len
        ; change caret
        edit_line_pos_( *this ) = *row\index
        edit_line_pos_delta_( *this ) = *row\index
        
        Repaint =- 1
      EndIf
      
      If Repaint
        edit_change_text_( *row, - remove_chr_len, [3] )
        edit_change_text_( *this, - remove_chr_len, [3] )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   edit_key_return_( *this._S_widget ) 
      Protected *row._S_rows 
      
      If *this\text\multiline
        *row._S_rows = FocusedRow( *this ) 
        
        If edit_line_pos_delta_( *this ) >= *row\index 
          If edit_caret_pos_( *this ) > edit_caret_pos_delta_( *this ) 
            edit_caret_pos_( *this ) = edit_caret_pos_delta_( *this ) 
          EndIf
          edit_caret_pos_( *this ) + Len( #LF$ )
          edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
          edit_line_pos_( *this ) = *row\index + 1
        Else
          edit_caret_pos_delta_( *this ) + Len( #LF$ )
          edit_caret_pos_( *this ) = edit_caret_pos_delta_( *this )
          edit_line_pos_( *this ) = edit_line_pos_delta_( *this ) + 1
        EndIf
        edit_line_pos_delta_( *this ) = edit_line_pos_( *this )
        
        ; Debug ""+edit_caret_pos_( *this ) +" "+ edit_caret_pos_delta_( *this ) +" "+ edit_line_pos_( *this ) +" "+ edit_line_pos_delta_( *this )
        
        *this\text\string.s = *this\text\edit[1]\string + #LF$ + *this\text\edit[3]\string
        *this\text\change =- 1 
        
        ;         
        ;         _AddItem( *this, edit_line_pos_delta_( *this ), *row\text\edit[3]\string )
        ;         
        ;         *this\text\string.s = *this\text\edit[1]\string + #LF$ + *row\text\edit[3]\string + #LF$ + Right( *this\text\string.s, *this\text\len - (*row\text\pos + *row\text\len + 1))
        ;         *row\text\edit[3]\len = Len( #LF$ )
        ;         *row\text\edit[3]\string = #LF$
        ;         *row\text\len = *row\text\edit[1]\len + *row\text\edit[3]\len
        ;         *row\text\string.s = *row\text\edit[1]\string + *row\text\edit[3]\string
        ;          *this\text\change = 0
        ;          *this\change = 0  
        ;          
        ; ;                 ForEach RowList( *this )
        ; ;                   Debug RowList( *this )\text\string
        ; ;                 Next
        
        ProcedureReturn - 1
      Else
        *this\notify = 3
      EndIf
    EndProcedure
    
    
    ;-
    Procedure   edit_AddItem( *this._S_widget, List row._S_rows( ), position, *text.Character, string_len )
      Protected *row._S_rows
      Protected add_index =- 1, add_y, add_pos, add_height
      
      If position < 0 Or position > ListSize( row( )) - 1
        LastElement( row( ))
        *row = AddElement( row( )) 
        
        ;If position < 0 
        position = ListIndex( row( ))
        ;EndIf
        
      Else
        
        *row = SelectElement( row( ), position )
        add_index = row( )\index
        add_y = row( )\y           + Bool( #PB_Compiler_OS = #PB_OS_Windows )
        add_pos = row( )\text\pos
        add_height = row( )\height + *this\mode\gridlines 
        *row = InsertElement( row( ))
        
        PushListPosition( row( )) 
        While NextElement( row( )) 
          row( )\index = ListIndex( row( ) )
          row( )\y + add_height 
          row( )\text\pos + string_len + Len( #LF$ )
        Wend
        PopListPosition(row( ))
        
        
        ;         *row = SelectElement( row( ), position )
        ;         add_index = row( )\index
        ;         add_y = row( )\y
        ;         add_pos = row( )\text\pos
        ;         add_height = row( )\height
        ;         PushListPosition( row( )) 
        ;         Repeat 
        ;           row( )\index = ListIndex( row( ) ) + 1 
        ;           row( )\y + add_height
        ;           row( )\text\pos + string_len + Len( #LF$ )
        ;         Until Not NextElement( row( ))
        ;         PopListPosition(row( ))
        ;         *row = InsertElement( row( ))
      EndIf
      
      row( )\index = position
      row( )\text\len = string_len
      row( )\text\string = PeekS ( *text, string_len )
      
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;         StopDrawing( )
      ;         StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
      ;         DrawingFont( *this\root\text\fontid )
      ;       CompilerEndIf
      draw_font_item_( *this, row( ), row( )\text\change )
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;         StopDrawing( )
      ;       CompilerEndIf
      
      row( )\height = row( )\text\height ; + 10
      row( )\width = *this\width[#__c_inner]
      row( )\color = _get_colors_( )
      
      ; make line position
      If *this\vertical
      Else ; horizontal
        If scroll_width_( *this ) < row( )\text\width + *this\text\padding\x*2
          scroll_width_( *this ) = row( )\text\width + *this\text\padding\x*2
        EndIf
        
        If *this\text\rotate = 0
          If add_index >= 0
            row( )\text\pos = add_pos 
            row( )\y = add_y                                                                     - *this\text\padding\y
          Else
            row( )\text\pos = *this\text\len 
            row( )\y = scroll_height_( *this )                                                   - *this\text\padding\y
          EndIf
        ElseIf *this\text\rotate = 180
          row( )\y = ( *this\height[#__c_inner] - scroll_height_( *this ) - row( )\text\height ) + *this\text\padding\y 
        EndIf
        
        scroll_height_( *this ) + row( )\height + *this\mode\gridlines
      EndIf
      
      *this\count\items + 1
      *this\text\len + string_len + Len( #LF$ )
      *this\text\string = InsertString( *this\text\string, row( )\text\string + #LF$, 1 + row( )\text\pos )
      
      ;       If *this\type = #PB_GadgetType_Editor
      ;         ; Debug "e - "+row( )\text\pos +" "+ row( )\text\string +" "+ row( )\y +" "+ row( )\width +" "+ row( )\height
      ;         ;  Debug "e - "+row( )\text\pos +" "+ row( )\text\string +" "+ row( )\text\y +" "+ row( )\text\width +" "+ row( )\text\height
      ;       EndIf
      ;       
      ;       
      *this\text\change = 0
      *this\change = 0
      
      ; ;       If scroll_height_( *this ) > *this\height[#__c_inner]; bar_make_scroll_area( *this )
      ; ;         PostEventRepaint( *this\root ) 
      ; ;       EndIf
    EndProcedure
    
    Procedure   edit_ClearItems( *this._S_widget )
      *this\count\items = 0
      *this\text\change =- 1
      *this\text\string = ""
      
      If *this\text\editable
        edit_caret_pos_( *this ) = 0
        edit_caret_pos_delta_( *this ) = 0
        edit_line_pos_delta_( *this ) = 0
        edit_line_pos_( *this ) = 0
      EndIf
      
      PostEventCanvas( *this\root ) ;?
      ProcedureReturn 1
    EndProcedure
    
    Procedure   edit_RemoveItem( *this._S_widget, item )
      *this\count\items - 1
      
      If *this\count\items =- 1 
        edit_ClearItems( *this )
      Else
        *this\text\change =- 1
        *this\text\string = RemoveString( *this\text\string, StringField( *this\text\string, item + 1, #LF$ ) + #LF$ )
        
        If ListSize( RowList( *this ) )
          SelectElement( RowList( *this ), item  )
          DeleteElement( RowList( *this ), 1 )
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
      
      Protected enter_index =- 1: If EnteredRow( *this ): enter_index = EnteredRow( *this )\index: EnteredRow( *this ) = #Null: EndIf
      Protected focus_index =- 1: If FocusedRow( *this ): focus_index = FocusedRow( *this )\index: FocusedRow( *this ) = #Null: EndIf
      Protected press_index =- 1: If PressedRow( *this ): press_index = PressedRow( *this )\index: PressedRow( *this ) = #Null: EndIf
      
      If *this\count\items
        *this\count\items = 0
        ClearList( RowList( *this ))
      Else
        Protected count = 1
      EndIf
      
      ;        CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
      ;             StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
      ;             draw_font_( *this )
      ;             StopDrawing( )
      ;           CompilerEndIf
      
      While *end\c 
        If *end\c = #LF 
          edit_AddItem( *this, RowList( *this ), - 1, *str, (*end-*str)>>#PB_Compiler_Unicode )
          
          If enter_index = RowList( *this )\index: EnteredRow( *this ) = RowList( *this ): EndIf
          If focus_index = RowList( *this )\index: EnteredRow( *this ) = RowList( *this ): EndIf
          If press_index = RowList( *this )\index: EnteredRow( *this ) = RowList( *this ): EndIf
          
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
        
        If edit_caret_pos_delta_( *this ) <> State
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
                
                edit_caret_pos_( *this ) = state
                edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
                edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) + len + Item
                
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
            
            edit_caret_pos_( *this ) = state
            edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
            edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) + len + Item
          EndIf
        EndIf
        
        ; ;       PushListPosition( RowList( *this ))
        ; ;       result = SelectElement( RowList( *this ), Item ) 
        ; ;       
        ; ;       If result 
        ; ;         \index[1] = RowList( *this )\index
        ; ;         \index[2] = RowList( *this )\index
        ; ;         \row\index = RowList( *this )\index
        ; ;        ; edit_caret_pos_( *this ) = State
        ; ;        ; edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this ) 
        ; ;       EndIf
        ; ;       PopListPosition( RowList( *this ))
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
          If *this\change > 0 ;<> 0
            Editor_Update( *this, RowList( *this ))
            
            If edit_line_pos_( *this )
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
            If edit_line_pos_( *this ) >= 0
              If Not ( FocusedRow( *this ) And FocusedRow( *this )\index = edit_line_pos_( *this ) )
                FocusedRow( *this ) = SelectElement( RowList( *this ), edit_line_pos_( *this ) )
              EndIf
              Debug "    key - change caret pos " + ListSize( RowList( *this ) ) +" "+ FocusedRow( *this )\index +" "+ edit_line_pos_delta_( *this )
              
              ;
              edit_sel_row_text_( *this, FocusedRow( *this ) )
              edit_sel_text_( *this, FocusedRow( *this ) )
              
              ;
              ; edit_make_text_position( *this )
              ;               ;bar_make_scroll_area( *this )
              ;               make_scrollarea_x( *this, *this\text )
              ;               If *this\scroll\h And 
              ;                  bar_SetState( *this\scroll\h\bar, -scroll_x_( *this ) ) 
              ;               EndIf
              
              If *this\scroll\v And Not *this\scroll\v\hide
                If FocusedRow( *this )\y + scroll_y_( *this ) < 0 Or 
                   FocusedRow( *this )\y + FocusedRow( *this )\height + scroll_y_( *this ) > *this\height[#__c_inner]
                  
                  If FocusedRow( *this )\y + scroll_y_( *this ) < 0
                    Debug "       key - scroll ^"
                  ElseIf FocusedRow( *this )\y + FocusedRow( *this )\height + scroll_y_( *this ) > *this\height[#__c_inner]
                    Debug "       key - scroll v"
                  EndIf
                  
                  ;row_scroll_y_( *this, FocusedRow( *this ) )
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
              
              
              edit_line_pos_( *this ) =- 1
            EndIf
          EndIf
          
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           DrawingMode_( #PB_2DDrawing_Gradient )
          ;           draw_gradient_( \vertical, *this,\color\fore[\color\state],\color\back[\color\state], [#__c_frame] )
          ;         Else
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawRoundBox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back[\color\state] )
          ;         EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If ( \text\change Or \resize )
              \row\margin\x = \x[#__c_inner]
              \row\margin\y = \y[#__c_inner]
              \row\margin\height = \height[#__c_inner]
            EndIf
            
            ; Draw margin
            DrawingModeAlpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
            DrawBox_( \row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back )
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
            visible_items_y = 0;*this\y[#__c_inner] ; *this\y[#__c_clip] ; 
          EndIf
          If Not visible_items_height
            If *this\height[#__c_clip] > *this\height[#__c_inner]
              visible_items_height = *this\height[#__c_inner] ; 
            Else
              visible_items_height = *this\height[#__c_clip]
            EndIf
          EndIf
          
          scroll_x = scroll_x_( *this )
          scroll_y = scroll_y_( *this )
          
          ; Debug ""+ scroll_x +" "+ scroll_x_ +" "+ scroll_y +" "+ scroll_y_
          
          ; Draw Lines text
          If \count\items
            VisibleFirstRow( *this ) = 0
            VisibleLastRow( *this ) = 0
            
            PushListPosition( RowList( *this ))
            ForEach RowList( *this )
              ; Is visible lines - -  - 
              RowList( *this )\visible = Bool( Not RowList( *this )\hide And 
                                               (( RowList( *this )\y - scroll_y_ ) < visible_items_y + visible_items_height ) And
                                               ( RowList( *this )\y + RowList( *this )\height - scroll_y_ ) > visible_items_y )
              
              
              ; Draw selections
              If RowList( *this )\visible 
                If Not VisibleFirstRow( *this )
                  VisibleFirstRow( *this ) = RowList( *this )
                EndIf
                VisibleLastRow( *this ) = RowList( *this )
                
                
                
                
                
                
                
                Y = row_y_( *this, RowList( *this ) ) + scroll_y
                Text_x = row_text_x_( *this, RowList( *this ) ) + scroll_x
                Text_Y = row_text_y_( *this, RowList( *this ) ) + scroll_y
                
                Protected sel_text_x1 = edit_row_edit_text_x_( *this, [1] ) + scroll_x
                Protected sel_text_x2 = edit_row_edit_text_x_( *this, [2] ) + scroll_x
                Protected sel_text_x3 = edit_row_edit_text_x_( *this, [3] ) + scroll_x
                
                Protected sel_x = \x[#__c_inner] + *this\text\x
                Protected sel_width = \width[#__c_inner] - *this\text\y*2
                
                Protected text_sel_state = 2 + Bool( Not *this\state\focus )
                Protected text_sel_width = RowList( *this )\text\edit[2]\width + Bool( Not *this\state\focus ) * *this\text\caret\width
                Protected text_state = RowList( *this )\color\state
                
                text_state = Bool(RowList( *this ) = FocusedRow( *this )) ; RowList( *this )\color\state ; Bool( RowList( *this )\color\state ) ; Bool( RowList( *this )\index = EnteredRow( *this )\index ) + Bool( RowList( *this )\index = EnteredRow( *this )\index And Not *this\state\focus )*2
                
                ;                 If PressedRow( *this ) = RowList( *this );Keyboard()\key And RowList( *this )\color\state
                ;                   Debug "state - "+RowList( *this )\index +" "+ RowList( *this )\color\state
                ;                 EndIf
                ;                 
                ;                 If *this\text\caret\y+1 + scroll_y = y
                ;                   ;Debug " state "+ RowList( *this )\index +" "+ RowList( *this )\color\state; text_state = 1
                ;                   text_state = 1
                ;                 EndIf
                If RowList( *this )\color\state = 2
                  ; Debug RowList( *this )\index
                  
                EndIf
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный 
                  ; фон отличный от заднего фона едитора
                  If RowList( *this )\color\back  
                    DrawingModeAlpha_( #PB_2DDrawing_Default )
                    DrawRoundBox_( sel_x,Y,sel_width ,RowList( *this )\height, RowList( *this )\round,RowList( *this )\round, RowList( *this )\color\back[0] )
                    
                    If *this\color\back And 
                       *this\color\back <> RowList( *this )\color\back
                      ; Draw margin back color
                      If *this\row\margin\width > 0
                        ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                        DrawingModeAlpha_( #PB_2DDrawing_Default )
                        DrawBox_( *this\row\margin\x, RowList( *this )\y, *this\row\margin\width, RowList( *this )\height, *this\row\margin\color\back )
                        Line( *this\x[#__c_inner] + *this\row\margin\width, RowList( *this )\y, 1, RowList( *this )\height, *this\color\back ) ; $FF000000 );
                      EndIf
                    EndIf
                  EndIf
                  
                  ; Draw entered selection
                  If text_state ; RowList( *this )\index = *this\index[1] ; \color\state;
                    If RowList( *this )\color\back[text_state] <>- 1              ; no draw transparent
                      DrawingModeAlpha_( #PB_2DDrawing_Default )
                      DrawRoundBox_( sel_x,Y,sel_width ,RowList( *this )\height, RowList( *this )\round,RowList( *this )\round, RowList( *this )\color\back[text_state] )
                    EndIf
                    
                    If RowList( *this )\color\frame[text_state] <>- 1 ; no draw transparent
                      DrawingModeAlpha_( #PB_2DDrawing_Outlined )
                      DrawRoundBox_( sel_x,Y,sel_width ,RowList( *this )\height, RowList( *this )\round,RowList( *this )\round, RowList( *this )\color\frame[text_state] )
                    EndIf
                  EndIf
                EndIf
                
                ; Draw text
                ; Draw string
                If *this\text\editable And 
                   RowList( *this )\text\edit[2]\width And 
                   RowList( *this )\color\front[2] <> *this\color\front
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    If RowList( *this )\text\string.s
                      DrawingModeAlpha_( #PB_2DDrawing_Transparent )
                      DrawRotatedText( Text_x, Text_Y, RowList( *this )\text\string.s, *this\text\rotate, RowList( *this )\color\front[RowList( *this )\color\state] )
                    EndIf
                    
                    If RowList( *this )\text\edit[2]\width
                      DrawingModeAlpha_( #PB_2DDrawing_Default )
                      DrawBox_( sel_text_x2, Y, text_sel_width, RowList( *this )\height, RowList( *this )\color\back[text_sel_state] )
                    EndIf
                    
                    DrawingModeAlpha_( #PB_2DDrawing_Transparent )
                    
                    ; to right select
                    If ( EnteredRowindex( *this ) > PressedRowindex( *this ) Or 
                         ( EnteredRowindex( *this ) = PressedRowindex( *this ) And edit_caret_pos_( *this ) > edit_caret_pos_delta_( *this ) ))
                      
                      If RowList( *this )\text\edit[2]\string.s
                        DrawRotatedText( sel_text_x2, Text_Y, RowList( *this )\text\edit[2]\string.s, *this\text\rotate, RowList( *this )\color\front[text_sel_state] )
                      EndIf
                      
                      ; to left select
                    Else
                      If RowList( *this )\text\edit[2]\string.s
                        DrawRotatedText( Text_x, Text_Y, RowList( *this )\text\edit[1]\string.s + RowList( *this )\text\edit[2]\string.s, *this\text\rotate, RowList( *this )\color\front[text_sel_state] )
                      EndIf
                      
                      If RowList( *this )\text\edit[1]\string.s
                        DrawRotatedText( Text_x, Text_Y, RowList( *this )\text\edit[1]\string.s, *this\text\rotate, RowList( *this )\color\front[RowList( *this )\color\state] )
                      EndIf
                    EndIf
                    
                  CompilerElse
                    If RowList( *this )\text\edit[2]\width
                      DrawingModeAlpha_( #PB_2DDrawing_Default )
                      DrawBox_( sel_text_x2, Y, text_sel_width, RowList( *this )\height, RowList( *this )\color\back[text_sel_state] )
                    EndIf
                    
                    DrawingModeAlpha_( #PB_2DDrawing_Transparent )
                    
                    If RowList( *this )\text\edit[1]\string.s
                      DrawRotatedText( sel_text_x1, Text_Y, RowList( *this )\text\edit[1]\string.s, *this\text\rotate, RowList( *this )\color\front[RowList( *this )\color\state] )
                    EndIf
                    If RowList( *this )\text\edit[2]\string.s
                      DrawRotatedText( sel_text_x2, Text_Y, RowList( *this )\text\edit[2]\string.s, *this\text\rotate, RowList( *this )\color\front[text_sel_state] )
                    EndIf
                    If RowList( *this )\text\edit[3]\string.s
                      DrawRotatedText( sel_text_x3, Text_Y, RowList( *this )\text\edit[3]\string.s, *this\text\rotate, RowList( *this )\color\front[RowList( *this )\color\state] )
                    EndIf
                  CompilerEndIf
                  
                Else
                  If RowList( *this )\text\edit[2]\width
                    DrawingModeAlpha_( #PB_2DDrawing_Default )
                    DrawBox_( sel_text_x2, Y, text_sel_width, RowList( *this )\height, $FFFBD9B7 );RowList( *this )\color\back[2] )
                  EndIf
                  
                  If *this\color\state = 2
                    DrawingMode_( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, RowList( *this )\text\string.s, *this\text\rotate, RowList( *this )\color\front[text_sel_state] )
                  Else
                    DrawingMode_( #PB_2DDrawing_Transparent )
                    DrawRotatedText( Text_x, Text_Y, RowList( *this )\text\string.s, *this\text\rotate, RowList( *this )\color\front[RowList( *this )\color\state] )
                  EndIf
                EndIf
                
                ; Draw margin text
                If *this\row\margin\width > 0
                  DrawingMode_( #PB_2DDrawing_Transparent )
                  DrawRotatedText( RowList( *this )\margin\x + Bool( *this\vertical ) * scroll_x,
                                   RowList( *this )\margin\y + Bool( Not *this\vertical ) * scroll_y, 
                                   RowList( *this )\margin\string, *this\text\rotate, *this\row\margin\color\front )
                EndIf
                
                ; Horizontal line
                If *this\mode\GridLines And
                   RowList( *this )\color\line And 
                   RowList( *this )\color\line <> RowList( *this )\color\back 
                  DrawingModeAlpha_( #PB_2DDrawing_Default )
                  DrawBox_( row_x_( *this, RowList( *this ) ), y + RowList( *this )\height, RowList( *this )\width, 1, *this\color\line )
                EndIf
              EndIf
            Next
            PopListPosition( RowList( *this )) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And *this\state\focus
            DrawingMode_( #PB_2DDrawing_XOr )             
            DrawBox_( *this\x[#__c_inner] + *this\text\caret\x + scroll_x, *this\y[#__c_inner] + *this\text\caret\y + scroll_y, *this\text\caret\width, *this\text\caret\height, $FFFFFFFF )
          EndIf
          
          ; Draw frames
          If *this\notify
            DrawingMode_( #PB_2DDrawing_Outlined )
            DrawRoundBox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round, $FF0000FF )
            If \round : DrawRoundBox_( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round, $FF0000FF ) : EndIf  ; Сглаживание краев ) ))
          ElseIf *this\bs
            DrawingMode_( #PB_2DDrawing_Outlined )
            DrawRoundBox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\frame[\color\state] )
            If \round : DrawRoundBox_( \x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round,\color\front[\color\state] ) : EndIf  ; Сглаживание краев ) ))
          EndIf
          
          ; Draw scroll bars
          bar_area_draw_( *this )
          
          If *this\text\change : *this\text\change = 0 : EndIf
          If *this\change : *this\change = 0 : EndIf
          If *this\resize : *this\resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure   Editor_Events_Key( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Static _caret_last_pos_, DoubleClick.i
      Protected Repaint.i, Caret.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = RowList( *this )\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
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
                Repaint = edit_key_caret_move_( *this, _line_first_, -1 )
                
              Case #PB_Shortcut_Down     ; Ok
                Repaint = edit_key_caret_move_( *this, -1, _line_last_ )
                
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
                    FocusedRow( *this ) = SelectElement( RowList( *this ), 0 )
                    edit_line_pos_delta_( *this ) = *this\count\items - 1 
                    
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
      Protected *currentRow._S_rows, mouse_x.l = Mouse( )\x, mouse_y.l = Mouse( )\y
      Static click_time
      
      
      With *this
        
        If *this\row
          Select eventtype 
            Case #PB_EventType_LeftButtonUp  
            Case #PB_EventType_LeftDoubleClick 
              If click_time = 0
                
                ;edit_line_pos_( *this ) = edit_line_pos_delta_( *this )
                edit_caret_pos_delta_( *this ) = edit_sel_start_( *this, edit_caret_pos_( *this ), EnteredRow( *this ) )
                edit_caret_pos_( *this ) = edit_sel_stop_( *this, edit_caret_pos_( *this ), EnteredRow( *this ) )
                
                edit_sel_row_text_( *this, FocusedRow( *this ), 0 )
                edit_sel_text_( *this, FocusedRow( *this ) )
                
                click_time = ElapsedMilliseconds( )
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If click_time And 
                 ( ElapsedMilliseconds( ) - click_time ) < 500
                
                ; edit_line_pos_( *this ) = edit_line_pos_delta_( *this ) + 1
                edit_caret_pos_delta_( *this ) = FocusedRow( *this )\text\pos
                edit_caret_pos_( *this ) = FocusedRow( *this )\text\pos + FocusedRow( *this )\text\len
                edit_sel_row_text_( *this, FocusedRow( *this ), - 2, 1 )
                
                If *this\text\multiline
                  FocusedRow( *this ) = SelectElement( RowList( *this ), edit_line_pos_delta_( *this ) + 1 )
                  edit_sel_row_text_( *this, RowList( *this ), - 3, 1 )
                EndIf
                
                edit_sel_text_( *this, FocusedRow( *this ) )
                
              Else
                edit_sel_pos( *this, EnteredRow( *this ), EnteredRow( *this ), - 1, 1 )
              EndIf
              
              click_time = 0
              
            Case #PB_EventType_MouseMove  
              
            Case #PB_EventType_StatusChange  
              
              
          EndSelect
          
          ; edit key events
          If eventtype = #PB_EventType_Input Or
             eventtype = #PB_EventType_KeyDown Or
             eventtype = #PB_EventType_KeyUp
            
            Repaint | Editor_Events_Key( *this, eventtype, Mouse( )\x, Mouse( )\y )
          EndIf
        EndIf
        
      EndWith
      
      If *this\text\change 
        *this\change = 1
      EndIf
      
      If Repaint
        ; *this\state\repaint = #True
        PushListPosition( RowList( *this ) )
        ; DoEvents( *this, #PB_EventType_StatusChange, 0, 0 )
        
        If *this\text\change
          DoEvents( *this, #PB_EventType_Change, 0, 0 )
        EndIf
        PopListPosition( RowList( *this ) )
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
          
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawBox_( 0,1,\width,\height - 2, *color\back[*color\state] )
          DrawingMode_( #PB_2DDrawing_Transparent )
          DrawText( \text\x, \text\y, \text\string, *color\front[*color\state] )
          DrawingMode_( #PB_2DDrawing_Outlined )
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
      ;     If FocusedRow( EventWidget( ) )
      ;       FocusedRow( EventWidget( ) )\color\state = 0
      ;     EndIf
      ;     
      ;     FocusedRow( EventWidget( ) ) = EventWidget( )RowList( *this )
      ;     EventWidget( )RowList( *this )\color\state = 2
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
          \row\_tt\x = x + RowList( *this )\x + RowList( *this )\width - 1
          \row\_tt\y = y + RowList( *this )\y - \scroll\v\bar\page\pos
          
          \row\_tt\width = RowList( *this )\text\width - \width[#__c_inner] + ( RowList( *this )\text\x - RowList( *this )\x ) + 5 ; -  ( scroll_width_( *this ) - RowList( *this )\width )  ; - 32 + 5 
          
          If \row\_tt\width < 6
            \row\_tt\width = 0
          EndIf
          
          Debug \row\_tt\width ;Str( RowList( *this )\text\x - RowList( *this )\x )
          
          \row\_tt\height = RowList( *this )\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\_tt\window = OpenWindow( #PB_Any, \row\_tt\x, \row\_tt\y, \row\_tt\width, \row\_tt\height, "", 
                                        #PB_Window_BorderLess | #PB_Window_NoActivate | flag, WindowID( \root\canvas\window ))
          
          \row\_tt\gadget = CanvasGadget( #PB_Any,0,0, \row\_tt\width, \row\_tt\height )
          \row\_tt\color = RowList( *this )\color
          \row\_tt\text = RowList( *this )\text
          \row\_tt\text\fontID = RowList( *this )\text\fontID
          \row\_tt\text\x =- ( \width[#__c_inner] - ( RowList( *this )\text\x - RowList( *this )\x )) + 1
          \row\_tt\text\y = ( RowList( *this )\text\y - RowList( *this )\y ) + \scroll\v\bar\page\pos
          
          BindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), \row\_tt\window )
          SetWindowData( \row\_tt\window, \row\_tt )
          tt_tree_Draw( \row\_tt )
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close( *this._S_tt )
      If IsWindow( *this\window )
        *this\visible = 0
        ; UnbindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), *this\window )
        CloseWindow( *this\window )
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
            
            PushListPosition( RowList( *this ))
            ForEach RowList( *this )
              RowList( *this )\index = ListIndex( RowList( *this ))
              
              If RowList( *this )\hide
                RowList( *this )\visible = 0
              Else
                If _change_ > 0
                  ; check box size
                  If ( *this\mode\check = #__m_checkselect Or 
                       *this\mode\check = #__m_optionselect )
                    RowList( *this )\checkbox\width = boxsize
                    RowList( *this )\checkbox\height = boxsize
                  EndIf
                  
                  ; collapse box size
                  If ( *this\mode\lines Or *this\mode\buttons ) And
                     Not ( RowList( *this )\sublevel And *this\mode\check = #__m_optionselect )
                    RowList( *this )\button\width = buttonsize
                    RowList( *this )\button\height = buttonsize
                  EndIf
                  
                  ; drawing item font
                  draw_font_item_( *this, RowList( *this ), RowList( *this )\text\change )
                  
                  ; draw items height
                  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                    CompilerIf Subsystem("qt")
                      RowList( *this )\height = RowList( *this )\text\height - 1
                    CompilerElse
                      RowList( *this )\height = RowList( *this )\text\height + 3
                    CompilerEndIf
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
                    RowList( *this )\height = RowList( *this )\text\height + 4
                  CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
                    If *this\type = #__type_ListView
                      RowList( *this )\height = RowList( *this )\text\height
                    Else
                      RowList( *this )\height = RowList( *this )\text\height + 2
                    EndIf
                  CompilerEndIf
                  
                  If RowList( *this )\x <> bs
                    RowList( *this )\x = bs
                  EndIf
                  
                  If RowList( *this )\width <> *this\width[#__c_inner] - bs*2
                    RowList( *this )\width = *this\width[#__c_inner] - bs*2
                  EndIf
                  
                  RowList( *this )\y = scroll_height_( *this )
                EndIf
                
                ; sublevel position
                RowList( *this )\sublevelsize = RowList( *this )\sublevel * *this\row\sublevelsize + Bool( *this\mode\check ) * (boxpos + boxsize) + Bool( *this\mode\lines Or *this\mode\buttons ) * ( buttonpos + buttonsize )
                
                ; check & option box position
                If ( *this\mode\check = #__m_checkselect Or 
                     *this\mode\check = #__m_optionselect )
                  
                  If RowList( *this )\parent\row And *this\mode\check = #__m_optionselect
                    RowList( *this )\checkbox\x = RowList( *this )\sublevelsize - RowList( *this )\checkbox\width
                  Else
                    RowList( *this )\checkbox\x = boxpos
                  EndIf
                  RowList( *this )\checkbox\y = ( RowList( *this )\height ) - ( RowList( *this )\height + RowList( *this )\checkbox\height )/2
                EndIf
                
                ; expanded & collapsed box position
                If ( *this\mode\lines Or *this\mode\buttons ) And Not ( RowList( *this )\sublevel And *this\mode\check = #__m_optionselect )
                  
                  If *this\mode\check = #__m_optionselect
                    RowList( *this )\button\x = RowList( *this )\sublevelsize - 10
                  Else
                    RowList( *this )\button\x = RowList( *this )\sublevelsize - (( buttonpos + buttonsize ) - 4)
                  EndIf
                  
                  RowList( *this )\button\y = ( RowList( *this )\height ) - ( RowList( *this )\height + RowList( *this )\button\height )/2
                EndIf
                
                ; image position
                If RowList( *this )\image\id
                  RowList( *this )\image\x = RowList( *this )\sublevelsize + *this\image\padding\x + 2
                  RowList( *this )\image\y = ( RowList( *this )\height - RowList( *this )\image\height )/2
                EndIf
                
                ; text position
                If RowList( *this )\text\string
                  RowList( *this )\text\x = RowList( *this )\sublevelsize + *this\row\margin\width + *this\text\padding\x
                  RowList( *this )\text\y = ( RowList( *this )\height - RowList( *this )\text\height )/2
                EndIf
                
                If RowList( *this )\text\edit\string
                  If *this\bar
                    RowList( *this )\text\edit\x = RowList( *this )\text\x + *this\bar\page\pos
                  Else
                    RowList( *this )\text\edit\x = RowList( *this )\text\x
                  EndIf
                  RowList( *this )\text\edit\y = RowList( *this )\text\y
                EndIf
                
                ; vertical & horizontal scroll max value
                If _change_ > 0
                  scroll_height_( *this ) + RowList( *this )\height + Bool( RowList( *this )\index <> *this\count\items - 1 ) * *this\mode\GridLines
                  
                  ;;If *this\scroll\h
                  If scroll_width_( *this ) < ( RowList( *this )\text\x + RowList( *this )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ); - *this\x[#__c_inner]
                    scroll_width_( *this ) = ( RowList( *this )\text\x + RowList( *this )\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos ) ; - *this\x[#__c_inner]
                                                                                                                                                                ;;EndIf
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition( RowList( *this ))
            
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
          If FocusedRow( *this ) And 
             FocusedRow( *this )\state\flag & #__S_scroll
            row_scroll_y_( *this, FocusedRow( *this ) )
            FocusedRow( *this )\state\flag &~ #__S_scroll
            *this\scroll\v\change = 0 
          EndIf
          
        EndIf  
      EndWith
      
    EndProcedure
    
    Procedure.l update_visible_items_( *this._S_widget, visible_items_height.l = 0 )
      Protected result, scroll_y = *this\scroll\v\bar\page\pos
      Protected visible_items_y.l = 0
      
      PushListPosition( RowList( *this ))
      
      If Not visible_items_y
        visible_items_y = 0;*this\y[#__c_inner] ; *this\y[#__c_clip] ; 
      EndIf
      If Not visible_items_height
        If *this\height[#__c_clip] > *this\height[#__c_inner]
          visible_items_height = *this\height[#__c_inner] ; 
        Else
          visible_items_height = *this\height[#__c_clip]
        EndIf
      EndIf
      
      ; reset draw list
      ClearList( VisibleRowList( *this ))
      VisibleFirstRow( *this ) = 0
      VisibleLastRow( *this ) = 0
      
      ForEach RowList( *this )
        RowList( *this )\visible = Bool( Not RowList( *this )\hide And 
                                         (( RowList( *this )\y - scroll_y ) < visible_items_y + visible_items_height ) And
                                         ( RowList( *this )\y + RowList( *this )\height - scroll_y ) > visible_items_y )
        
        ; add new draw list
        If RowList( *this )\visible And 
           AddElement( VisibleRowList( *this ))
          VisibleRowList( *this ) = RowList( *this )
          
          If Not VisibleFirstRow( *this )
            VisibleFirstRow( *this ) = RowList( *this )
            ; Debug ""+VisibleFirstRow( *this )\x+" "+VisibleFirstRow( *this )\y 
          EndIf
          VisibleLastRow( *this ) = RowList( *this )
          
          ; Debug ""+VisibleLastRow( *this )\index +" "+ VisibleLastRow( *this )\y
          result = 1
        EndIf
      Next
      
      PopListPosition( RowList( *this ))
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
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            DrawRoundBox_( *this\x[#__c_inner],*this\y[#__c_inner], *this\width[#__c_inner],*this\height[#__c_inner], *this\round,*this\round,*this\color\back[*this\color\state] )
          EndIf
          
          ; Draw background image
          If *this\image\id
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *this\image\id, *this\image\x, *this\image\y, *this\color\_alpha )
          EndIf
          
          ;
          ;_content_clip_( *this, [#__c_clip2] )
          
          
          draw_items_( *this, VisibleRowList( *this ), *this\scroll\h\bar\page\pos, *this\scroll\v\bar\page\pos )
          
          ; Draw scroll bars
          bar_area_draw_( *this )
          
          ; Draw frames
          If *this\fs
            DrawingMode_( #PB_2DDrawing_Outlined )
            draw_box_( *this, color\frame, [#__c_frame] )
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.i Tree_AddItem( *this._S_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected *row._S_rows, last, *last_row._S_rows, *parent_row._S_rows
      ; sublevel + 1
      
      ;With *this
      If *this
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize( RowList( *this )) - 1
          LastElement( RowList( *this ))
          *row = AddElement( RowList( *this )) 
          
          If position < 0 
            position = ListIndex( RowList( *this ))
          EndIf
        Else
          *row = SelectElement( RowList( *this ), position )
          
          ; for the tree( )
          If sublevel > RowList( *this )\sublevel
            PushListPosition( RowList( *this ))
            If PreviousElement( RowList( *this ))
              *this\row\last_add = RowList( *this )
              ;;NextElement( RowList( *this ))
            Else
              last = *this\row\last_add
              sublevel = RowList( *this )\sublevel
            EndIf
            PopListPosition( RowList( *this ))
          Else
            last = *this\row\last_add
            sublevel = RowList( *this )\sublevel
          EndIf
          
          *row = InsertElement( RowList( *this ))
        EndIf
        ;}
        
        If *row
          ;*row\index = ListIndex( RowList( *this ) )
          
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
                    ;                     *row\before = *this\row\last_add\parent\row
                    ;                     *this\row\last_add\parent\row\after = *row
                    
                    If *this\type = #__type_Editor
                      *parent_row = *this\row\last_add\parent\row
                      *parent_row\last = *row
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
            *row\parent\row = *parent_row
          EndIf
          
          If sublevel
            *row\sublevel = sublevel
          EndIf
          
          If last
            ; *this\row\last_add = last
          Else
            *this\row\last_add = *row
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
            *this\row\first = *row
          EndIf
          
          If *this\mode\collapse And *row\parent\row And 
             *row\sublevel > *row\parent\row\sublevel
            *row\parent\row\button\___state= 1 
            *row\hide = 1
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
          *row\color = _get_colors_( )
          *row\color\state = 0
          *row\color\back = 0 
          *row\color\frame = 0
          
          *row\color\fore[0] = 0 
          *row\color\fore[1] = 0
          *row\color\fore[2] = 0
          *row\color\fore[3] = 0
          
          If Text
            *row\text\change = 1
            *row\text\string = StringField( Text.s, 1, #LF$ )
            *row\text\edit\string = StringField( Text.s, 2, #LF$ )
          EndIf
          
          set_image_( *this, *row\Image, Image )
          
          If FocusedRow( *this ) 
            FocusedRow( *this )\color\state = #__S_0
            
            If FocusedRow( *this )\state\flag & #__S_scroll
              FocusedRow( *this )\state\flag &~ #__S_scroll
            EndIf
            
            FocusedRow( *this ) = *row 
            FocusedRow( *this )\state\flag | #__S_scroll | #__S_select
            FocusedRow( *this )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            
            PostEventCanvas( *this\root )
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
    
    Procedure.l Tree_events_Key( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected result, from =- 1
      Static cursor_change, Down, *row_selected._S_rows
      
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
                If FocusedRow( *this )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf FocusedRow( *this )\index > 0
                    ; select modifiers key
                    If ( Keyboard( )\key = #PB_Shortcut_Home Or
                         ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                      SelectElement( RowList( *this ), 0 )
                    Else
                      _select_prev_item_( RowList( *this ), FocusedRow( *this )\index )
                    EndIf
                    
                    If FocusedRow( *this ) <> RowList( *this )
                      FocusedRow( *this )\color\state = 0
                      FocusedRow( *this )  = RowList( *this )
                      RowList( *this )\color\state = 2
                      *row_selected = RowList( *this )
                      
                      If RowList( *this )\y + scroll_y_( *this ) <= 0
                        *this\change =- row_scroll_y_( *this, FocusedRow( *this ) )
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, RowList( *this )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If FocusedRow( *this )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    
                    If bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + 18 ) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf FocusedRow( *this )\index < ( *this\count\items - 1 )
                    ; select modifiers key
                    If ( Keyboard( )\key = #PB_Shortcut_End Or
                         ( Keyboard( )\key[1] & #PB_Canvas_Alt ))
                      SelectElement( RowList( *this ), ( *this\count\items - 1 ))
                    Else
                      _select_next_item_( RowList( *this ), FocusedRow( *this )\index )
                    EndIf
                    
                    If FocusedRow( *this ) <> RowList( *this )
                      FocusedRow( *this )\color\state = 0
                      FocusedRow( *this )  = RowList( *this )
                      RowList( *this )\color\state = 2
                      *row_selected = RowList( *this )
                      
                      If RowList( *this )\y >= *this\height[#__c_inner]
                        *this\change =- row_scroll_y_( *this, FocusedRow( *this ) )
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, RowList( *this )\index )
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
    
    Procedure.l Tree_events( *this._S_widget, eventtype.l, *item._S_rows, item =- 1 )
      Protected Repaint, mouse_x.l = Mouse( )\x, mouse_y.l = Mouse( )\y
      
      ;
      If eventtype = #PB_EventType_StatusChange
        If Mouse( )\buttons
          If *item\state\focus = #True 
            ;If *this\state\press 
            If *item\color\state <> #__S_2
              *item\color\state = #__S_2
              Post( *this, #PB_EventType_Change, *item\index )
            Else
              Debug 4555
            EndIf
            ;EndIf
          Else
            If *this\state\drag
              If *item\color\state <> #__S_0
                *item\color\state = #__S_0
              EndIf
            Else
              If *item\color\state = #__S_0
                ; *item\color\state = #__S_1
              EndIf
            EndIf
          EndIf
        Else
          If *item\color\state = #__S_0
            ; *item\color\state = #__S_1
          EndIf
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonDown
        If EnteredRow( *this ) 
          ; collapsed/expanded button
          If EnteredRow( *this )\count\childrens And 
             is_at_point_( EnteredRow( *this )\button,
                           mouse_x + *this\scroll\h\bar\page\pos - EnteredRow( *this )\x,
                           mouse_y + *this\scroll\v\bar\page\pos - EnteredRow( *this )\y )
            
            If EnteredRow( *this )\button\___state 
              Repaint | SetItemState( *this, EnteredRow( *this )\index, #__tree_expanded )
            Else
              Repaint | SetItemState( *this, EnteredRow( *this )\index, #__tree_collapsed )
            EndIf
          Else
            ; change box ( option&check )
            If is_at_point_( EnteredRow( *this )\checkbox,
                             mouse_x + *this\scroll\h\bar\page\pos - EnteredRow( *this )\x,
                             mouse_y + *this\scroll\v\bar\page\pos - EnteredRow( *this )\y )
              ;*this\row\box\___state= 1
              
              ; change box option
              If *this\mode\check = #__m_optionselect
                If EnteredRow( *this )\parent\row And EnteredRow( *this )\option_group  
                  If EnteredRow( *this )\option_group\parent\row And 
                     EnteredRow( *this )\option_group\checkbox\___state
                    EnteredRow( *this )\option_group\checkbox\___state= #PB_Checkbox_Unchecked
                  EndIf
                  
                  If EnteredRow( *this )\option_group\option_group <> EnteredRow( *this )
                    If EnteredRow( *this )\option_group\option_group
                      EnteredRow( *this )\option_group\option_group\checkbox\___state= #PB_Checkbox_Unchecked
                    EndIf
                    EnteredRow( *this )\option_group\option_group = EnteredRow( *this )
                  EndIf
                EndIf
              EndIf
              
              ; change box check
              set_check_state_( EnteredRow( *this )\checkbox, *this\mode\threestate )
              
              ;
              If EnteredRow( *this )\color\state = #__S_2 
                Post( *this, #PB_EventType_Change, EnteredRow( *this )\index )
              EndIf
            EndIf
            
            
            If *this\mode\check = #__m_clickselect
              If EnteredRow( *this )\state\press = #True
                EnteredRow( *this )\state\press = #False
              Else
                EnteredRow( *this )\state\press = #True
              EndIf
              
              FocusedRow( *this ) = EnteredRow( *this )
              
            Else
              ; reset selected items
              ForEach RowList( *this )
                If RowList( *this ) <> EnteredRow( *this ) And 
                   RowList( *this )\state\press = #True
                  RowList( *this )\state\press = #False
                  RowList( *this )\color\state = #__S_0
                EndIf
              Next
              
              If FocusedRow( *this ) <> EnteredRow( *this )
                FocusedRow( *this ) = EnteredRow( *this )
                EnteredRow( *this )\state\press = #True
              EndIf
            EndIf
            
            ; set draw color state
            If EnteredRow( *this )\state\press = #True 
              ;               If EnteredRow( *this )\color\state <> #__S_2
              ;                 EnteredRow( *this )\color\state = #__S_2
              ;                 
              ;                 Post( *this, #PB_EventType_Change, EnteredRow( *this )\index )
              ;                 
              ;               EndIf
            Else
              EnteredRow( *this )\color\state = #__S_1
            EndIf
          EndIf
          
          ; Repaint = #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If EnteredRow( *this ) And
           EnteredRow( *this )\state\enter  
          
          If EnteredRow( *this )\color\state = #__S_0
            EnteredRow( *this )\color\state = #__S_1
            
            ; Post event item status change
            Post( *this, #PB_EventType_StatusChange, EnteredRow( *this )\index )
            ; Repaint = #True 
          Else
            If EnteredRow( *this )\count\childrens And 
               is_at_point_( EnteredRow( *this )\button, 
                             mouse_x + *this\scroll\h\bar\page\pos - EnteredRow( *this )\x,
                             mouse_y + *this\scroll\v\bar\page\pos - EnteredRow( *this )\y )
              
              Post( *this, #PB_EventType_Up, EnteredRow( *this )\index )
            Else
              Post( *this, #PB_EventType_LeftClick, EnteredRow( *this )\index )
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      If eventtype = #PB_EventType_Focus Or 
         eventtype = #PB_EventType_LostFocus
        
        If *this\count\items
          PushListPosition( RowList( *this )) 
          ForEach RowList( *this )
            If eventtype = #PB_EventType_Focus
              If RowList( *this )\color\state = #__S_3
                RowList( *this )\color\state = #__S_2
                RowList( *this )\state\press = #True
                Repaint = #True
              EndIf
              
            ElseIf eventtype = #PB_EventType_LostFocus
              If RowList( *this )\color\state = #__S_2
                RowList( *this )\color\state = #__S_3
                RowList( *this )\state\press = #False
                Repaint = #True
              EndIf
            EndIf
          Next
          PopListPosition( RowList( *this )) 
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_RightButtonUp Or
         eventtype = #PB_EventType_LeftDoubleClick
        
        Post( *this, eventtype, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      
      ; mouse wheel verticl and horizontal
      If eventtype = #PB_EventType_MouseWheelX
        ;         If mouse( )\wheel\x > 0
        ;           ;Post( *this\scroll\h, #PB_EventType_Up )
        Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - Mouse( )\wheel\x )
        
        ;         ElseIf mouse( )\wheel\x < 0
        ;           ;Post( #PB_EventType_Down, *this\scroll\h )
        ;           Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
        ;         EndIf
      EndIf
      
      If eventtype = #PB_EventType_MouseWheelY
        ;         If mouse( )\wheel\y > 0
        ;           ;Post( *this\scroll\v, #PB_EventType_Up )
        Repaint | bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - Mouse( )\wheel\y )
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
    
    Macro set_state_list_1( _address_, _state_ )
      If _state_ > 0 
        If *this\mode\check = #__m_clickselect
          If _address_\color\state <> #__S_2
            _address_\color\state = #__S_1
            _address_\state\enter = #True
          EndIf
        Else
          _address_\color\state = #__S_2
          _address_\state\press = #True
        EndIf
        
      ElseIf _address_ 
        If *this\mode\check = #__m_clickselect
          If _address_\color\state <> #__S_2
            _address_\color\state = #__S_0
            _address_\state\enter = #False
          EndIf
        Else
          _address_\color\state = #__S_0
          _address_\state\press = #False
        EndIf
      EndIf
    EndMacro
    
    Macro _multi_select_items_( _this_ )
      PushListPosition( RowList( *this )) 
      ForEach RowList( *this )
        If RowList( *this )\visible
          If Bool(( PressedRow( *this )\index >= RowList( *this )\index And FocusedRow( *this )\index <= RowList( *this )\index ) Or ; верх
                  ( FocusedRow( *this )\index >= RowList( *this )\index And PressedRow( *this )\index <= RowList( *this )\index ))   ; вниз
            
            If RowList( *this )\color\state <> #__S_2
              RowList( *this )\color\state = #__S_2
              Repaint | #True
            EndIf
            
          Else
            
            If RowList( *this )\color\state <> #__S_0
              RowList( *this )\color\state = #__S_0
              
              ; example( sel 5;6;7, click 5, no post change )
              If RowList( *this )\state\press = #True
                RowList( *this )\state\press = #False
              EndIf
              
              Repaint | #True
            EndIf
            
          EndIf
        EndIf
      Next
      PopListPosition( RowList( *this )) 
    EndMacro
    
    
    Procedure.l ListView_Events( *this._S_widget, eventtype.l, *item._S_rows, item =- 1 )
      Protected Repaint, mouse_x.l = Mouse( )\x, mouse_y.l = Mouse( )\y
      
      If eventtype = #PB_EventType_DragStart
        Post( *this, #PB_EventType_DragStart, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_Focus
        PushListPosition( RowList( *this )) 
        ForEach RowList( *this )
          If RowList( *this )\color\state = #__S_3
            RowList( *this )\color\state = #__S_2
            RowList( *this )\state\press = #True
          EndIf
        Next
        PopListPosition( RowList( *this )) 
        
        ; Post( *this, #PB_EventType_Focus, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_LostFocus
        PushListPosition( RowList( *this )) 
        ForEach RowList( *this )
          If RowList( *this )\color\state = #__S_2
            RowList( *this )\color\state = #__S_3
            RowList( *this )\state\press = #False
          EndIf
        Next
        PopListPosition( RowList( *this )) 
        
        ; Post( *this, #PB_EventType_lostFocus, WidgetEvent( )\item )
        Repaint | #True
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If FocusedRow( *this ) 
          If *this\mode\check = #__m_multiselect
            EnteredRow( *this ) = FocusedRow( *this )
          EndIf
          
          If *this\mode\check <> #__m_clickselect 
            If FocusedRow( *this )\state\press  = #False
              FocusedRow( *this )\state\press = #True
              Post( *this, #PB_EventType_Change, FocusedRow( *this )\index )
              Repaint | #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftClick
        If EnteredRow( *this )
          Post( *this, #PB_EventType_LeftClick, EnteredRow( *this )\index )
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_LeftDoubleClick
        If EnteredRow( *this )
          Post( *this, #PB_EventType_LeftDoubleClick, EnteredRow( *this )\index )
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_RightClick
        If EnteredRow( *this )
          Post( *this, #PB_EventType_RightClick, EnteredRow( *this )\index )
          Repaint | #True
        EndIf
      EndIf
      
      
      If eventtype = #PB_EventType_MouseEnter Or
         eventtype = #PB_EventType_MouseMove Or
         eventtype = #PB_EventType_MouseLeave Or
         eventtype = #PB_EventType_RightButtonDown Or
         eventtype = #PB_EventType_LeftButtonDown ;Or eventtype = #PB_EventType_leftButtonUp
        
        If *this\count\items
          ForEach VisibleRowList( *this )
            ; If VisibleRowList( *this )\visible
            If is_at_point_( *this, mouse_x, mouse_y, [#__c_inner] ) And 
               is_at_point_( VisibleRowList( *this ),
                             mouse_x + *this\scroll\h\bar\page\pos,
                             mouse_y + *this\scroll\v\bar\page\pos )
              
              ;  
              If Not VisibleRowList( *this )\state\enter 
                VisibleRowList( *this )\state\enter = #True 
                
                ; 
                If Not Mouse( )\buttons
                  EnteredRow( *this ) = VisibleRowList( *this )
                EndIf
                
                If VisibleRowList( *this )\color\state = #__S_0
                  VisibleRowList( *this )\color\state = #__S_1
                  Repaint | #True
                EndIf
                
                ;
                If Not ( Mouse( )\buttons And *this\mode\check )
                  Post( *this, #PB_EventType_StatusChange, VisibleRowList( *this )\index )
                  Repaint | #True
                EndIf
              EndIf
              
              If Mouse( )\buttons
                If *this\mode\check
                  FocusedRow( *this ) = VisibleRowList( *this )
                  
                  ; clickselect items
                  If *this\mode\check = #__m_clickselect
                    If eventtype = #PB_EventType_LeftButtonDown
                      If VisibleRowList( *this )\state\press = #True 
                        VisibleRowList( *this )\state\press = #False
                        VisibleRowList( *this )\color\state = #__S_1
                      Else
                        VisibleRowList( *this )\state\press = #True
                        VisibleRowList( *this )\color\state = #__S_2
                      EndIf
                      
                      Post( *this, #PB_EventType_Change, VisibleRowList( *this )\index )
                      Repaint | #True
                    EndIf
                  EndIf
                  
                  If FocusedRow( *this )
                    PushListPosition( RowList( *this )) 
                    ForEach RowList( *this )
                      If RowList( *this )\visible
                        If Bool(( EnteredRow( *this )\index >= RowList( *this )\index And FocusedRow( *this )\index <= RowList( *this )\index ) Or ; верх
                                ( EnteredRow( *this )\index <= RowList( *this )\index And FocusedRow( *this )\index >= RowList( *this )\index ))   ; вниз
                          
                          If *this\mode\check = #__m_clickselect
                            If EnteredRow( *this )\state\press = #True
                              If RowList( *this )\color\state <> #__S_2
                                RowList( *this )\color\state = #__S_2
                                
                                If RowList( *this )\state\press  = #False
                                  ; entered to no selected
                                  Post( *this, #PB_EventType_Change, RowList( *this )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf RowList( *this )\state\enter
                              If RowList( *this )\color\state <> #__S_1
                                RowList( *this )\color\state = #__S_1
                                
                                If RowList( *this )\state\press = #True
                                  If EnteredRow( *this )\state\press  = #False
                                    ; entered to selected
                                    Post( *this, #PB_EventType_Change, RowList( *this )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          ; multiselect items
                          If *this\mode\check = #__m_multiselect
                            If RowList( *this )\color\state <> #__S_2
                              RowList( *this )\color\state = #__S_2
                              Repaint | #True
                              
                              ; reset select before this 
                              ; example( sel 5;6;7, click 7, reset 5;6 )
                            ElseIf eventtype = #PB_EventType_LeftButtonDown
                              If FocusedRow( *this ) <> RowList( *this )
                                RowList( *this )\color\state = #__S_0
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                        Else
                          
                          If *this\mode\check = #__m_clickselect
                            If RowList( *this )\state\press = #True 
                              If RowList( *this )\color\state <> #__S_2
                                RowList( *this )\color\state = #__S_2
                                
                                If EnteredRow( *this )\state\press  = #False
                                  ; leaved from selected
                                  Post( *this, #PB_EventType_Change, RowList( *this )\index )
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf RowList( *this )\state\enter = #False
                              If RowList( *this )\color\state <> #__S_0
                                RowList( *this )\color\state = #__S_0
                                
                                If EnteredRow( *this )\state\press = #True
                                  If RowList( *this )\state\press  = #False
                                    ; leaved from no selected
                                    Post( *this, #PB_EventType_Change, RowList( *this )\index )
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          If *this\mode\check = #__m_multiselect
                            If RowList( *this )\color\state <> #__S_0
                              RowList( *this )\color\state = #__S_0
                              
                              ; example( sel 5;6;7, click 5, no post change )
                              If RowList( *this )\state\press = #True
                                RowList( *this )\state\press = #False
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                          
                        EndIf
                      EndIf
                    Next
                    PopListPosition( RowList( *this )) 
                  EndIf
                Else
                  If FocusedRow( *this ) And
                     FocusedRow( *this ) <> VisibleRowList( *this )
                    FocusedRow( *this )\state\press = #False
                    FocusedRow( *this )\color\state = #__S_0
                  EndIf
                  
                  VisibleRowList( *this )\color\state = #__S_2
                  FocusedRow( *this ) = VisibleRowList( *this )
                  ; *this\change =- row_scroll_y_( *this\scroll\v, FocusedRow( *this ) )
                  Repaint | #True
                EndIf
              EndIf
              
            ElseIf VisibleRowList( *this )\state\enter
              VisibleRowList( *this )\state\enter = #False 
              
              
              If VisibleRowList( *this )\color\state = #__S_1
                VisibleRowList( *this )\color\state = #__S_0
              EndIf
              
              ;
              If Mouse( )\buttons And *this\mode\check
                If *this\mode\check = #__m_multiselect
                  If VisibleRowList( *this )\state\press  = #False
                    VisibleRowList( *this )\state\press = #True
                  EndIf
                  
                  Post( *this, #PB_EventType_Change, VisibleRowList( *this )\index )
                EndIf
              EndIf
              
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      
      If eventtype = #PB_EventType_MouseWheelX
        Repaint | bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos - Mouse( )\wheel\x )
      EndIf
      
      If eventtype = #PB_EventType_MouseWheelY
        Repaint | bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos - Mouse( )\wheel\y )
      EndIf
      
      
      ;- widget::ListView_Events_Key
      If eventtype = #PB_EventType_KeyDown 
        Protected *current._S_rows
        Protected result, from =- 1
        Static cursor_change, Down
        
        If *this\state\focus
          
          If *this\mode\check = #__m_clickselect
            *current = EnteredRow( *this )
          Else
            *current = FocusedRow( *this )
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
                  FocusedRow( *this ) = *current
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
                    SelectElement( RowList( *this ), 0 )
                  Else
                    _select_prev_item_( RowList( *this ), *current\index )
                  EndIf
                  
                  If *current <> RowList( *this )
                    If *current 
                      set_state_list_( *current, #False )
                    EndIf
                    set_state_list_( RowList( *this ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      FocusedRow( *this ) = RowList( *this )
                    EndIf
                    
                    If Not Keyboard( )\key[1] & #PB_Canvas_Shift
                      EnteredRow( *this ) = FocusedRow( *this )
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = RowList( *this )
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
                    SelectElement( RowList( *this ), ( *this\count\items - 1 ))
                  Else
                    _select_next_item_( RowList( *this ), *current\index )
                  EndIf
                  
                  If *current <> RowList( *this )
                    If *current 
                      set_state_list_( *current, #False )
                    EndIf
                    set_state_list_( RowList( *this ), #True )
                    
                    If *this\mode\check <> #__m_clickselect
                      FocusedRow( *this ) = RowList( *this )
                    EndIf
                    
                    If Not Keyboard( )\key[1] & #PB_Canvas_Shift
                      EnteredRow( *this ) = FocusedRow( *this )
                    EndIf
                    
                    If *this\mode\check = #__m_multiselect
                      _multi_select_items_( *this )
                    EndIf
                    
                    *current = RowList( *this )
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
            EnteredRow( *this ) = *current
          Else
            FocusedRow( *this ) = *current
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
          
          *this\caption\height = *this\barHeight + *this\fs  
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
    
    Procedure   _Window_Draw( *this._S_widget )
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
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawRoundBox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,\color\back[\interact * \color\state] )
        EndIf
        
        ; draw frame back
        If \fs
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          If \fs = 1 
            For i = 1 To \caption\round
              Line( \x[#__c_frame] + i - 1,\y[#__c_frame] + caption_height - 1,1,Bool( \round )*( i - \round ),\caption\color\back[\color\state] )
              Line( \x[#__c_frame] + \width[#__c_frame] + i - \round - 1,\y[#__c_frame] + caption_height - 1,1, - Bool( \round )*( i ),\caption\color\back[\color\state] )
            Next
          Else
            For i = 1 To \fs
              DrawRoundBox_( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i - 1, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2 + 2,\round,\round, \caption\color\back[\color\state] )
              DrawRoundBox_( \x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i, \width[#__c_frame] - i*2 + 2, Bool( \height[#__c_frame] - \fs[2]>0 )*( \height[#__c_frame] - \fs[2] ) - i*2,\round,\round, \caption\color\back[\color\state] )
            Next
          EndIf
        EndIf 
        
        ; frame draw
        If \fs
          DrawingMode_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
          If \fs = 1 
            DrawRoundBox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
          Else
            ; draw out frame
            DrawRoundBox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[\color\state] )
            
            ; draw inner frame 
            If \type = #__type_ScrollArea Or \type = #__type_MDI ; \scroll And \scroll\v And \scroll\h
              DrawRoundBox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \scroll\v\color\line )
            Else
              DrawRoundBox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, iwidth, iheight, round, round, \color\frame[\color\state] )
            EndIf
          EndIf
        EndIf
        
        
        If caption_height
          ; Draw caption back
          If \caption\color\back 
            DrawingModeAlpha_( #PB_2DDrawing_Gradient )
            draw_gradient_( 0, \caption, \caption\color\fore[\color\state], \caption\color\back[\color\state] )
          EndIf
          
          ; Draw caption frame
          If \fs
            DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            DrawRoundBox_( \caption\x, \caption\y, \caption\width, caption_height - 1,\caption\round,\caption\round,\color\frame[\color\state] )
            
            ; erase the bottom edge of the frame
            DrawingModeAlpha_( #PB_2DDrawing_Gradient )
            BackColor( \caption\color\fore[\color\state] )
            FrontColor( \caption\color\back[\color\state] )
            
            ;Protected i
            For i = \caption\round/2 + 2 To caption_height - 1
              Line( \x[#__c_frame],\y[#__c_frame] + i,\width[#__c_frame],1, \caption\color\back[\color\state] )
            Next
            
            ; two edges of the frame
            DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            Line( \x[#__c_frame],\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
            Line( \x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \caption\round/2 + 2,1,caption_height - \caption\round/2,\color\frame[\color\state] )
          EndIf
          
          ; buttins background
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          draw_box_button_( \caption\button[#__wb_close], color\back )
          draw_box_button_( \caption\button[#__wb_maxi], color\back )
          draw_box_button_( \caption\button[#__wb_mini], color\back )
          draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( \caption\button[#__wb_close], 6 )
          draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; Draw image
          If \image\id
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
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
            
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            ;             DrawRoundBox_( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
          EndIf
        EndIf
        
        ;_content_clip_( *this, [#__c_clip2] )
        
        ; background image draw 
        If *this\image[#__img_background]\id
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__img_background]\id,
                          *this\x[#__c_inner] + *this\image[#__img_background]\x, 
                          *this\y[#__c_inner] + *this\image[#__img_background]\y, *this\color\_alpha )
        EndIf
        
        ;_content_clip_( *this, [#__c_clip] )
        
        ; UnclipOutput( )
        ; DrawingModeAlpha_( #PB_2DDrawing_Outlined )
        ; DrawRoundBox_( \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; DrawRoundBox_( \x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure   Window_Draw( *this._S_widget )
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
          DrawingModeAlpha_( #PB_2DDrawing_Gradient )
          DrawRoundBox_(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], caption_height, _round_,_round_)
          
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          DrawRoundBox_( \x[#__c_frame], \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          DrawRoundBox_( \x[#__c_frame]+\width[#__c_frame]-caption_height, \y[#__c_frame], caption_height, caption_height, _round_,_round_, \caption\color\frame[window_color_state] )
          
          DrawingModeAlpha_( #PB_2DDrawing_Gradient )
          DrawRoundBox_(*this\x[#__c_frame]+1, *this\y[#__c_frame]+1, *this\width[#__c_frame]-2, caption_height, _round_,_round_)
          DrawBox_( \x[#__c_frame], \y[#__c_frame]+caption_height/2, \width[#__c_frame], \fs[2]-caption_height/2+\fs, \caption\color\back[window_color_state] )
        EndIf
        
        ; _content_clip2_( *this, [#__c_clip2] )
        
        If Not ( *this\image[#__img_background]\id And *this\image[#__img_background]\depth > 31 ) ; *this\image[#__img_background]\transparent )
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawBox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, \color\back[0] )
        EndIf
        
        If \fs
          If \fs = 1 
            DrawingMode_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
            DrawRoundBox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], \height[#__c_frame], round, round, \color\frame[window_color_state] )
          Else
            If \type = #__type_ScrollArea Or \type = #__type_MDI
              color_inner_line = \scroll\v\color\line
            Else                                                                                             
              color_inner_line = \color\frame[window_color_state]
            EndIf
            
            DrawingModeAlpha_( #PB_2DDrawing_Gradient )
            DrawRoundBox_( \x[#__c_frame], \y[#__c_inner] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            DrawRoundBox_( \x[#__c_frame], \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            DrawRoundBox_( \x[#__c_frame]+\width[#__c_frame]-\fs, \y[#__c_inner] - \fs, \fs, \height[#__c_frame], \round,\round, \caption\color\back[window_color_state] )
            DrawRoundBox_( \x[#__c_frame], \y[#__c_frame]+\height[#__c_frame] - \fs, \width[#__c_frame], \fs, \round,\round, \caption\color\back[window_color_state] )
            
            ; draw inner frame 
            DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            DrawRoundBox_( \x[#__c_inner] - 1, \y[#__c_inner] - 1, \width[#__c_inner] + 2, \height[#__c_inner] + 2, round, round, color_inner_line )
            
            ; draw out frame
            ;DrawRoundBox_( \x[#__c_frame], \y[#__c_frame] + caption_height, \width[#__c_frame], fheight, round, round, \color\frame[window_color_state] )
            Line(\x[#__c_frame]+caption_height/2, \y[#__c_frame], \width[#__c_frame]-caption_height, 1, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame] + \width[#__c_frame] - 1, \y[#__c_frame]+caption_height/2, 1, \height[#__c_frame]-caption_height/2, color_inner_line)
            Line(\x[#__c_frame], \y[#__c_frame] + \height[#__c_frame] - 1, \width[#__c_frame], 1, color_inner_line)
          EndIf
        EndIf
        
        
        If caption_height
          ; buttins background
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          draw_box_button_( \caption\button[#__wb_close], color\back )
          draw_box_button_( \caption\button[#__wb_maxi], color\back )
          draw_box_button_( \caption\button[#__wb_mini], color\back )
          draw_box_button_( \caption\button[#__wb_help], color\back )
          
          ; buttons image
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( \caption\button[#__wb_close], 6 )
          draw_maximize_button_( \caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( \caption\button[#__wb_mini], 4 )
          draw_help_button_( \caption\button[#__wb_help], 4 )
          
          ; draw caption image
          If \image\id
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
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
            
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
            DrawText( \caption\text\x, \caption\text\y, \caption\text\string, \color\front[window_color_state]&$FFFFFF | \color\_alpha<<24 )
            
            ;             DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            ;             DrawRoundBox_( \caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000 )
          EndIf
        EndIf
        
        _content_clip2_( *this, [#__c_clip2] )
        
        ; background image draw 
        If *this\image[#__img_background]\id
          DrawingModeAlpha_( #PB_2DDrawing_Default )
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
          Resize( *this, *this\root\x[#__c_rootrestore], *this\root\y[#__c_rootrestore], 
                  *this\root\width[#__c_rootrestore], *this\root\height[#__c_rootrestore] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_RestoreWindow, *this\root\canvas\window, *this )
          EndIf
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post( *this, #PB_EventType_MaximizeWindow )
          If Not *this\resize & #__resize_minimize
            *this\root\x[#__c_rootrestore] = *this\x[#__c_container]
            *this\root\y[#__c_rootrestore] = *this\y[#__c_container]
            *this\root\width[#__c_rootrestore] = *this\width[#__c_frame]
            *this\root\height[#__c_rootrestore] = *this\height[#__c_frame]
          EndIf
          
          *this\resize | #__resize_maximize
          Resize( *this, 0,0, *this\parent\widget\width[#__c_container], *this\parent\widget\height[#__c_container] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MaximizeWindow, *this\root\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post( *this, #PB_EventType_MinimizeWindow )
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
          
          Resize( *this, *this\root\x[#__c_rootrestore], *this\parent\widget\height[#__c_container] - *this\fs[2], *this\root\width[#__c_rootrestore], *this\fs[2] )
          SetAlignmentFlag( *this, #__align_bottom )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MinimizeWindow, *this\root\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_Close( *this._S_widget )
      Protected.b result
      
      ; close window
      If Not Post( *this, #PB_EventType_closeWindow )
        Free( *this )
        
        If is_root_(*this )
          PostEvent( #PB_Event_CloseWindow, *this\root\canvas\window, *this )
        EndIf
        
        result = #True
      EndIf
    EndProcedure
    
    Procedure   Window_Events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      
      If eventtype = #PB_EventType_Focus
        *this\color\state = #__S_2
        Post( *this, eventtype )
        Repaint = #True
      EndIf
      
      If eventtype = #PB_EventType_LostFocus
        *this\color\state = #__S_3
        Post( *this, eventtype )
        Repaint = #True
      EndIf
      
      If eventtype = #PB_EventType_MouseEnter
        Repaint = #True
      EndIf
      
      If eventtype = #PB_EventType_MouseMove
        ;         If *this\state\press
        ;           ;           If *this\container = #__type_root
        ;           ;             ResizeWindow(*this\root\canvas\window, (DesktopMouseX( ) - *this\root\mouse\delta\x), (DesktopMouseY( ) - *this\root\mouse\delta\y), #PB_Ignore, #PB_Ignore)
        ;           ;           Else
        ;           Repaint = Resize(*this, (mouse_x - Mouse( )\delta\x), (mouse_y - Mouse( )\delta\y), #PB_Ignore, #PB_Ignore)
        ;           ;           EndIf
        ;         EndIf
      EndIf
      
      If eventtype = #PB_EventType_MouseLeave
        Repaint = #True
      EndIf
      
      ;       If eventtype = #PB_EventType_MouseMove
      ;         If *this\state\press
      ;           If *this = *this\root\canvas\container
      ;             ResizeWindow( *this\root\canvas\window, ( DesktopMousex( ) - mouse( )\delta\x ), ( DesktopMouseY( ) - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           Else
      ;             Repaint = Resize( *this, ( mouse_x - mouse( )\delta\x ), ( mouse_y - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
      ;           EndIf
      ;         EndIf
      ;       EndIf
      
      If eventtype = #PB_EventType_LeftClick
        If *this\type = #__type_Window
          *this\caption\interact = is_at_point_( *this\caption, mouse_x, mouse_y, [2] )
          ;*this\color\state = 2
          
          ; close button
          If is_at_point_( *this\caption\button[#__wb_close], mouse_x, mouse_y )
            ProcedureReturn Window_close( *this )
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
    Procedure.b IsContainer( *this._S_widget )
      ProcedureReturn *this\container
    EndProcedure
    
    Procedure.i GetItem( *this._S_widget, parent_sublevel.l =- 1 )
      Protected result
      Protected *row._S_rows
      Protected *widget._S_widget
      
      If *this 
        If parent_sublevel =- 1
          *widget = *this
          result = ParentTabIndex( *widget )
          
        Else
          *row = *this
          
          While *row And *row <> *row\parent\row
            
            If parent_sublevel = *row\parent\row\sublevel
              result = *row
              Break
            EndIf
            
            *row = *row\parent\row
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
                  PushListPosition( RowList( *this ))
                  ForEach RowList( *this )
                    If RowList( *this )\parent\row And 
                       RowList( *this )\parent\row\count\childrens
                      RowList( *this )\sublevel = state
                    EndIf
                  Next
                  PopListPosition( RowList( *this ))
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
                PushListPosition( RowList( *this ))
                ForEach RowList( *this )
                  If RowList( *this )\parent\row
                    RowList( *this )\checkbox\___state= #PB_Checkbox_Unchecked
                    RowList( *this )\option_group = Bool( state ) * GetItem( RowList( *this ), 0 ) 
                  EndIf
                Next
                PopListPosition( RowList( *this ))
              EndIf
            EndIf
            If flag & #__tree_gridlines
              *this\mode\gridlines = state
            EndIf
            If flag & #__tree_collapse 
              *this\mode\collapse = state
              
              If *this\count\items
                PushListPosition( RowList( *this ))
                ForEach RowList( *this )
                  If RowList( *this )\parent\row 
                    RowList( *this )\parent\row\button\___state= state
                    RowList( *this )\hide = state
                  EndIf
                Next
                PopListPosition( RowList( *this ))
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
    
    Procedure.b Disable( *this._S_widget, State.b =- 1 )
      If State =- 1
        ProcedureReturn Bool( *this\state\flag & #__S_disable )
      Else
        If *this\state\flag & #__S_disable
          *this\state\flag &~ #__S_disable
          ; *this\color\state = #__S_0
        Else
          *this\state\flag | #__S_disable
          ; *this\color\state = #__S_3
          *this\color\state = #__S_0
        EndIf
        
        If StartEnumerate( *this )
          Widget( )\color\state = #__S_3 
          StopEnumerate( )
        EndIf
        PostEventCanvas(*this\root)
      EndIf
    EndProcedure
    
    Procedure.b Hide( *this._S_widget, State.b =- 1 )
      With *this
        If State =- 1
          ProcedureReturn *this\hide 
        Else
          *this\hide = State
          *this\hide[1] = *this\hide
          
          ;           If StartEnumerate( *this ) ;  *this\container And 
          ;             set_hide_state_( Widget( ))
          ;             StopEnumerate( )
          ;           EndIf
          
          ; enumerate all parent childrens
          PushListPosition( WidgetList( *this\parent\widget\root ) )
          ChangeCurrentElement( WidgetList( *this\parent\widget\root ), *this\parent\widget\address )
          While NextElement( WidgetList( *this\parent\widget\root ) )
            If WidgetList( *this\parent\widget\root ) = *this\parent\widget\after\widget 
              Break
            EndIf
            
            ; hide all children except those whose parent-item is selected
            set_hide_state_( WidgetList( *this\parent\widget\root ) )
          Wend
          PopListPosition( WidgetList( *this\parent\widget\root ) )
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure   IsChild( *this._S_widget, *parent._S_widget )
      Protected result 
      
      If *this And *parent\count\childrens
        Repeat
          If *parent = *this\parent\widget
            result = *this
            Break
          EndIf
          
          *this = *this\parent\widget
        Until *this = *this\root  ; is_root_( *this )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Update( *this._S_widget )
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Panel
        bar_Update( *this\tab\widget\bar )
        result = bar_Resize( *this\tab\widget\bar )  
      EndIf  
      
      If *this\type = #__type_Window
        result = Window_Update( *this )
      EndIf
      
      ; ;       If *this\type = #__type_tree
      ; ;         If StartDrawing( CanvasOutput( *this\root\canvas\gadget ))
      ; ;           Tree_Update( *this, RowList( *this ))
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
        
        bar_Update( *this\bar )
        result = bar_Resize( *this\bar )  
      Else
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change( *this._S_widget, ScrollPos.f )
      Select *this\type
        Case #__type_TabBar,#__type_ToolBar,
             #__type_Spin,
             #__type_Splitter,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar
          
          ProcedureReturn bar_Change( *this\bar, ScrollPos )
      EndSelect
    EndProcedure
    
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
    
    Procedure.i Display( *this._S_widget, *display._S_widget, x = #PB_Ignore, y = #PB_Ignore )
      Protected display_height = 0
      
      PopupWidget( ) = *this
      *this\state\flag | #__S_collapse
      
      ForEach RowList( *this )
        If Not RowList( *this )\hide
          display_height + RowList( *this )\height
        EndIf
        If ( ListIndex(RowList( *this )) + 1 )>= 10;30
          Break
        EndIf
      Next
      
      If scroll_height_( *this ) > display_height 
        Resize( *this, x, y, #PB_Ignore, display_height ) 
      Else
        Resize( *this, x, y, #PB_Ignore, scroll_height_( *this ) + *this\barheight + *this\fs*2 + *this\ToolBarHeight ) 
      EndIf
      
      ;*this\change = 1
      update_visible_items_( *this )
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
        ;         ;      ;   PostEventCanvas( *this\root )
        ;         ;       EndIf
      EndWith
    EndProcedure
    
    Procedure   AddItem( *this._S_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0 )
      Protected result
      
      _add_action_( *this )
      
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
        ProcedureReturn edit_AddItem( *this, RowList( *this ), item, @text, Len(Text) )
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
        ProcedureReturn bar_tab_AddItem( *this\tab\widget, Item,Text,Image,flag )
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
        
        If is_no_select_item_( RowList( *this ), Item )
          ProcedureReturn #False
        EndIf
        
        Protected sublevel = RowList( *this )\sublevel
        Protected *parent._S_rows = RowList( *this )\parent\row
        
        ; if is last parent item then change to the prev element of his level
        If *parent And *parent\last = RowList( *this )
          PushListPosition( RowList( *this ))
          While PreviousElement( RowList( *this ))
            If *parent = RowList( *this )\parent\row
              *parent\last = RowList( *this )
              Break
            EndIf
          Wend
          PopListPosition( RowList( *this ))
          
          ; if the remove last parent childrens
          If *parent\last = RowList( *this )
            *parent\count\childrens = #False
            *parent\last = #Null
          Else
            *parent\count\childrens = #True
          EndIf
        EndIf
        
        ; before deleting a parent, we delete its children
        If RowList( *this )\count\childrens
          PushListPosition( RowList( *this ))
          While NextElement( RowList( *this ))
            If RowList( *this )\sublevel > sublevel 
              DeleteElement( RowList( *this )) 
              *this\count\items - 1 
              *this\row\count - 1
            Else
              Break
            EndIf
          Wend
          PopListPosition( RowList( *this ))
        EndIf
        
        ; if the item to be removed is selected, 
        ; then we set the next item of its level as selected
        If FocusedRow( *this ) = RowList( *this )
          FocusedRow( *this )\state\press = #False
          
          ; if he is a parent then we find the next item of his level
          PushListPosition( RowList( *this ))
          While NextElement( RowList( *this ))
            If RowList( *this )\sublevel = FocusedRow( *this )\sublevel 
              Break
            EndIf
          Wend
          
          ; if we remove the last selected then 
          If FocusedRow( *this ) = RowList( *this ) 
            FocusedRow( *this ) = PreviousElement( RowList( *this ))
          Else
            FocusedRow( *this ) = RowList( *this ) 
          EndIf
          PopListPosition( RowList( *this ))
          
          If FocusedRow( *this )
            If FocusedRow( *this )\parent\row And 
               FocusedRow( *this )\parent\row\button\___state 
              FocusedRow( *this ) = FocusedRow( *this )\parent\row
            EndIf 
            
            FocusedRow( *this )\state\press = #True
            FocusedRow( *this )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          EndIf
        EndIf
        
        *this\change = 1  
        *this\count\items - 1
        DeleteElement( RowList( *this ))
        PostEventCanvas( *this\root )
        result = #True
      EndIf
      
      If *this\type = #__type_Panel
        result = bar_tab_removeItem( *this\tab\widget, Item )
        
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
          
          If FocusedRow( *this ) 
            FocusedRow( *this )\color\state = 0
            ClearStructure(FocusedRow( *this ), _S_rows)
            FocusedRow( *this ) = 0
          EndIf
          
          ClearList( RowList( *this ))
          
          PostEventCanvas( *this\root )
          ;           ReDraw( *this )
          ;           
        EndIf
      EndIf
      
      ; - Panel_ClearItems( )
      If *this\type = #__type_Panel
        result = bar_tab_clearItems( *this\tab\widget )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_clearItems( *this )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CloseList( )
      Protected *last._S_root
      
      If OpenedWidget( ) And 
         OpenedWidget( )\parent\widget And
         OpenedWidget( )\root\canvas\gadget = Root( )\canvas\gadget 
        
        ; Debug "" + OpenedWidget( ) + " - " + OpenedWidget( )\class + " " + OpenedWidget( )\parent\widget + " - " + OpenedWidget( )\parent\widget\class
        If OpenedWidget( )\parent\widget\type = #__type_MDI
          OpenList( OpenedWidget( )\parent\widget\parent\widget )
        Else
          If OpenedWidget( ) = OpenedWidget( )\root
            
            OpenedWidget( ) = OpenedWidget( )\root\before\root 
            If OpenedWidget( )
              ChangeCurrentRoot(OpenedWidget( )\root\canvas\address )
            EndIf
            
          Else
            OpenList( OpenedWidget( )\parent\widget )
          EndIf
        EndIf
      Else
        OpenList( Root( ) )
      EndIf
    EndProcedure
    
    Procedure.i OpenList( *this._S_widget, item.l = 0 )
      Protected result.i = OpenedWidget( )
      
      If *this
        If *this\root <> Root( )
          If OpenedWidget( )\root
            OpenedWidget( )\root\after\root = *this\root
          EndIf
          *this\root\before\root = OpenedWidget( )\root
          
          If *this = *this\root 
            ChangeCurrentRoot(*this\root\canvas\address )
          EndIf
        EndIf
        
        If *this\tab\widget 
          OpenTabIndex( *this\tab\widget ) = item
        EndIf
        
        OpenedWidget( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure   GetWidget( index )
      Protected result
      
      If index =- 1
        ProcedureReturn Widget( )
      Else
        ForEach Widget( )
          If Widget( )\index = index +  1
            result = Widget( )
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Getaddress( *this._S_widget )
      ProcedureReturn *this\address
    EndProcedure
    
    Procedure.l GetIndex( *this._S_widget )
      ProcedureReturn *this\index - 1
    EndProcedure
    
    Procedure.l GetLevel( *this._S_widget )
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass( *this._S_widget )
      ProcedureReturn *this\class
    EndProcedure
    
    Procedure.l GetDeltaX( *this._S_widget )
      ProcedureReturn ( Mouse( )\delta\x + *this\x[#__c_container] )
    EndProcedure
    
    Procedure.l GetDeltaY( *this._S_widget )
      ProcedureReturn ( Mouse( )\delta\y + *this\y[#__c_container] )
    EndProcedure
    
    Procedure.l GetButtons( *this._S_widget )
      ProcedureReturn Mouse( )\buttons
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
      ProcedureReturn *this\root ; Returns root element
    EndProcedure
    
    Procedure.i GetGadget( *this._S_widget = #Null )
      If *this = #Null : *this = Root( ) : EndIf
      
      If is_root_(*this )
        ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow( *this._S_widget )
      If is_root_(*this )
        ProcedureReturn *this\root\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\window ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParent( *this._S_widget )
      ProcedureReturn *this\parent\widget
    EndProcedure
    
    Procedure  GetFirst( *this._S_widget, tabindex.l )
      Protected *result._S_widget
      
      If *this\count\childrens
        PushListPosition( WidgetList( *this\root ) )
        ChangeCurrentElement( WidgetList( *this\root ), *this\address )
        While NextElement( WidgetList( *this\root ) )
          If WidgetList( *this\root ) = *this\last\widget Or
             ParentTabIndex( WidgetList( *this\root ) ) = tabindex
            *result = WidgetList( *this\root )
            Break
          EndIf
        Wend
        PopListPosition( WidgetList( *this\root ) )
      Else
        *result = *this
      EndIf
      
      ; Debug "   "+*result\class
      
      ProcedureReturn *result
    EndProcedure
    
    Procedure  GetLast( *this._S_widget, tabindex.l )
      Protected result
      
      If *this\last\widget
        If *this\count\childrens
          PushListPosition( WidgetList( *this\root ) )
          If *this\after\widget
            ChangeCurrentElement( WidgetList( *this\root ), *this\after\widget\address )
            
            While PreviousElement( WidgetList( *this\root ) )
              If ParentTabIndex( WidgetList( *this\root ) ) = tabindex Or 
                 WidgetList( *this\root ) = *this 
                Break
              EndIf
            Wend
          Else
            LastElement( WidgetList( *this\root ) )
          EndIf
          
          result = WidgetList( *this\root )\last\widget
          ; Debug "get-last - "+WidgetList( *this\root )\class +" "+ WidgetList( *this\root )\last\widget\class
          PopListPosition( WidgetList( *this\root ) )
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
          result = GetFirst( *this\parent\widget, ParentTabIndex( *this ) )
        Case #PB_List_Before 
          result = *this\before\widget
        Case #PB_List_After 
          result = *this\after\widget
        Case #PB_List_Last   
          result = GetLast( *this\parent\widget, ParentTabIndex( *this ) )
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
          Case #PB_Splitter_FirstGadget       : result = splitter_first_gadget_( *this )
          Case #PB_Splitter_SecondGadget      : result = splitter_second_gadget_( *this )
          Case #PB_Splitter_FirstMinimumSize  : result = *this\bar\button[#__b_1]\size
          Case #PB_Splitter_SecondMinimumSize : result = *this\bar\button[#__b_2]\size
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
            
          Case #__bar_buttonsize : result = *this\bar\button[#__b_1]\size   
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
        
        If FocusedRow( *this )
          ProcedureReturn FocusedRow( *this )\index
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
        ProcedureReturn PressedRowindex( *this ) ; edit_caret_pos_delta_( *this )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn FocusedTabindex( *this\tab\widget )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn FocusedTabindex( *this ) 
        
      Else
        If *this\bar
          ProcedureReturn *this\bar\page\pos
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s GetText( *this._S_widget )
      If *this\type = #__type_Tree
        If FocusedRow( *this ) 
          ProcedureReturn FocusedRow( *this )\text\string
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
      *this\cursor = *cursor
    EndProcedure
    
    Procedure   SetFrame( *this._S_widget, size.a, mode.i = 0 )
      Protected result
      If *this\fs <> size
        result = *this\fs 
        *this\fs = size
        
        If *this\_a_\transform
          ;           transform( )\size = #__a_size
          ;           If *this\container And *this\fs > 1
          ;             transform( )\size + *this\fs
          ;           EndIf
          ;           ;
          ;           a_size( *this\_a_\id, transform( )\size )
          a_size_auto( *this, #__a_size )
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
      
      _add_action_( *this )
      
      If *this\type = #__type_ComboBox
        If is_no_select_item_( RowList( *this ), State )
          ProcedureReturn #False
        EndIf
        
        If FocusedRow( *this ) <> RowList( *this )
          
          If FocusedRow( *this )
            If FocusedRow( *this )\state\press = #True
              FocusedRow( *this )\state\press = #False
            EndIf
            ;             If FocusedRow( *this )\state\flag & #__S_scroll
            ;               FocusedRow( *this )\state\flag &~ #__S_scroll
            ;             EndIf
            
            FocusedRow( *this )\color\state = #__S_0
          EndIf
          
          FocusedRow( *this ) = RowList( *this )
          FocusedRow( *this )\state\press = #True 
          ;           FocusedRow( *this )\state\flag | #__S_scroll 
          ;           If *this = FocusedWidget( )
          FocusedRow( *this )\color\state = #__S_2
          ;           Else
          ;             FocusedRow( *this )\color\state = #__S_3
          ;           EndIf
          
          *this\text\string = FocusedRow( *this )\text\string
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
          ReDraw( *this\root )
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
          ReDraw( *this\root )
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
        
        If edit_caret_pos_delta_( *this ) <> State
          edit_caret_pos_delta_( *this ) = State
          
          Protected i.l, len.l
          Protected *str.Character = @*this\text\string 
          Protected *end.Character = @*this\text\string 
          
          While *end\c 
            If *end\c = #LF 
              len + ( *end - *str )/#__sOC
              ; Debug "" + i + " " + Str( len + i )  + " " +  state
              
              If len + i >= state
                edit_line_pos_( *this ) = i
                edit_line_pos_delta_( *this ) = i
                
                edit_caret_pos_( *this ) = state - ( len - ( *end - *str )/#__sOC ) - i
                edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
                
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
            
            edit_caret_pos_( *this ) = ( state - len - i ) 
            edit_caret_pos_delta_( *this ) = edit_caret_pos_( *this )
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
          If FocusedRow( *this ) 
            If *this\mode\check <> #__m_optionselect
              If FocusedRow( *this )\state\press = #True
                FocusedRow( *this )\state\press = #False
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, FocusedRow( *this )\index, - 1 )
                EndIf
              EndIf
            EndIf
            
            If FocusedRow( *this )\state\flag & #__S_scroll
              FocusedRow( *this )\state\flag &~ #__S_scroll
            EndIf
            
            FocusedRow( *this )\color\state = #__S_0
            FocusedRow( *this ) = #Null
          EndIf
        EndIf
        
        ; 
        If is_no_select_item_( RowList( *this ), State )
          ProcedureReturn #False
        EndIf
        
        If *this\count\items
          If FocusedRow( *this ) <> RowList( *this )
            If FocusedRow( *this ) 
              If FocusedRow( *this )\state\press = #True
                FocusedRow( *this )\state\press = #False
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, FocusedRow( *this )\index, - 1 )
                EndIf
              EndIf
              
              If FocusedRow( *this )\state\flag & #__S_scroll
                FocusedRow( *this )\state\flag &~ #__S_scroll
              EndIf
              
              FocusedRow( *this )\color\state = #__S_0
            EndIf
            
            ; click select mode 
            If *this\mode\check = #__m_clickselect
              If RowList( *this )\state\press = #True 
                RowList( *this )\state\press = #False
                RowList( *this )\color\state = #__S_0
              Else
                RowList( *this )\state\press = #True
                RowList( *this )\color\state = #__S_3
              EndIf
              
              Post( *this, #PB_EventType_Change, RowList( *this )\index )
            Else
              If RowList( *this )\state\press  = #False
                RowList( *this )\state\press = #True
                ; multi select mode 
                If *this\mode\check = #__m_multiselect
                  Post( *this, #PB_EventType_Change, RowList( *this )\index, 1 )
                EndIf
              EndIf
              
              RowList( *this )\color\state = #__S_3
            EndIf
            
            RowList( *this )\state\flag | #__S_scroll
            FocusedRow( *this ) = RowList( *this )
            
            ;_post_repaint_items_( *this )
            
            ;*this\change = 1
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      
      ; - Panel_SetState( )
      If *this\type = #__type_Panel
        result = bar_tab_SetState( *this\tab\widget, state )
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
            *this\scroll\increment = *value
            
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
        If FocusedRow( *this ) 
          FocusedRow( *this )\text\string = Text
        EndIf
      EndIf
      
      If *this\type = #__type_Editor Or *this\type = #__type_String Or *this\type = #__type_Button
        
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
          ;           If StartDrawing( CanvasOutput( *this\root\canvas\gadget ))
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
      If result : PostEventCanvas( *this\root ) : EndIf
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
        *this = *this\window
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
    
    Procedure.i SetActive( *this._S_widget )
      Protected result.i, *active._S_widget
      
      If *this 
        FocusedWidget( ) = *this
        
        If *this\state\focus = #False
          *this\state\focus = #True
          
          If GetActive( ) 
            If GetActive( ) <> *this\window And 
               GetActive( )\state\focus = #True
              GetActive( )\state\focus = #False
              result | DoEvents( GetActive( ), #PB_EventType_LostFocus )
            EndIf
            
            ; when we deactivate the window 
            ; we will deactivate his last active gadget
            If GetActive( )\gadget And 
               GetActive( )\gadget\state\focus = #True 
              GetActive( )\gadget\state\focus = #False
              result | DoEvents( GetActive( )\gadget, #PB_EventType_LostFocus )
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
              While PreviousElement( Widget( ))
                If Widget( ) = *this\window
                  Break
                EndIf
                If IsChild( *active, Widget( ))
                  If Widget( )\state\focus = #True
                    Widget( )\state\focus = #False
                    result | DoEvents( Widget( ), #PB_EventType_LostFocus )
                  EndIf
                EndIf
              Wend 
            EndIf
          EndIf
          
          ; set active all parents
          If *this\address
            ChangeCurrentElement( Widget( ), *this\address )
            While PreviousElement( Widget( ))
              ;If Widget( )\type = #PB_GadgetType_Window
              If IsChild( *this, Widget( )) ;And Widget( )\container
                If Widget( )\state\focus = #False
                  Widget( )\state\focus = #True
                  result | DoEvents( Widget( ), #PB_EventType_Focus )
                EndIf
              EndIf
              ;EndIf
            Wend 
          EndIf
          
          ; 
          If is_window_( *this ) Or is_root_(*this )
            GetActive( ) = *this
          Else
            If is_integral_( *this )
              GetActive( ) = *this\parent\widget\window
              GetActive( )\gadget = *this\parent\widget
            Else
              GetActive( ) = *this\window
              GetActive( )\gadget = *this
            EndIf  
            
            ; when we activate the gadget
            ; first we activate its parent window
            If GetActive( )\state\focus = #False
              GetActive( )\state\focus = #True
              result | DoEvents( GetActive( ), #PB_EventType_Focus )
            EndIf
          EndIf
          
          result | DoEvents( *this, #PB_EventType_Focus )
          ; when we activate the window
          ; we will activate his last gadget that lost focus
          If GetActive( )\gadget And 
             GetActive( )\gadget\state\focus = #False
            GetActive( )\gadget\state\focus = #True
            result | DoEvents( GetActive( )\gadget, #PB_EventType_Focus )
          EndIf
          
          ; set window foreground position
          SetForeground( GetActive( ))
        EndIf
        
      Else
        If GetActive( ) 
          If GetActive( )\state\focus = #True
            GetActive( )\state\focus = #False
            result | DoEvents( GetActive( ), #PB_EventType_LostFocus )
          EndIf
          
          ; when we deactivate the window 
          ; we will deactivate his last active gadget
          If GetActive( )\gadget And 
             GetActive( )\gadget\state\focus = #True 
            GetActive( )\gadget\state\focus = #False
            result | DoEvents( GetActive( )\gadget, #PB_EventType_LostFocus )
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
            While PreviousElement( Widget( ))
              If IsChild( *active, Widget( )) ;And Widget( )\container
                If Widget( )\state\focus = #True
                  Widget( )\state\focus = #False
                  result | DoEvents( Widget( ), #PB_EventType_LostFocus )
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
    
    Procedure AddWidget( *this._S_widget, *parent._S_widget )
      ProcedureReturn SetParent( *this, *parent, #PB_Default )
    EndProcedure
    
    Procedure   SetPosition( *this._S_widget, position.l, *widget._S_widget = #Null ) ; Ok
      If *widget = #Null
        Select Position 
          Case #PB_List_First  : *widget = *this\parent\widget\first\widget
          Case #PB_List_Before : *widget = *this\before\widget
          Case #PB_List_After  : *widget = *this\after\widget
          Case #PB_List_Last   : *widget = *this\parent\widget\last\widget
        EndSelect
      EndIf
      
      If *widget And *this <> *widget And ParentTabIndex( *this ) = ParentTabIndex( *widget )
        If Position = #PB_List_First Or Position = #PB_List_Before
          
          PushListPosition( WidgetList( *this\root ))
          ChangeCurrentElement( WidgetList( *this\root ), *this\address )
          MoveElement( WidgetList( *this\root ), #PB_List_Before, *widget\address )
          
          If *this\count\childrens
            While PreviousElement( WidgetList( *this\root )) 
              If IsChild( WidgetList( *this\root ), *this )
                MoveElement( WidgetList( *this\root ), #PB_List_After, *widget\address )
              EndIf
            Wend
            
            While NextElement( WidgetList( *this\root )) 
              If IsChild( WidgetList( *this\root ), *this )
                MoveElement( WidgetList( *this\root ), #PB_List_Before, *widget\address )
              EndIf
            Wend
          EndIf
          PopListPosition( WidgetList( *this\root ))
        EndIf  
        
        If Position = #PB_List_Last Or Position = #PB_List_After
          Protected *last._S_widget = GetLast( *widget, ParentTabIndex( *widget )) 
          
          PushListPosition( WidgetList( *this\root ))
          ChangeCurrentElement( WidgetList( *this\root ), *this\address )
          MoveElement( WidgetList( *this\root ), #PB_List_After, *last\address )
          
          If *this\count\childrens
            While NextElement( WidgetList( *this\root )) 
              If IsChild( WidgetList( *this\root ), *this )
                MoveElement( WidgetList( *this\root ), #PB_List_Before, *last\address )
              EndIf
            Wend
            
            While PreviousElement( WidgetList( *this\root )) 
              If IsChild( WidgetList( *this\root ), *this )
                MoveElement( WidgetList( *this\root ), #PB_List_After, *this\address )
              EndIf
            Wend
          EndIf
          PopListPosition( WidgetList( *this\root ))
        EndIf
        
        ;
        If *this\before\widget
          *this\before\widget\after\widget = *this\after\widget
        EndIf
        If *this\after\widget
          *this\after\widget\before\widget = *this\before\widget
        EndIf
        If *this\parent\widget\first\widget = *this
          *this\parent\widget\first\widget = *this\after\widget
        EndIf
        If *this\parent\widget\last\widget = *this
          *this\parent\widget\last\widget = *this\before\widget
        EndIf
        
        ;
        If Position = #PB_List_First Or Position = #PB_List_Before
          
          *this\after\widget = *widget
          *this\before\widget = *widget\before\widget 
          *widget\before\widget = *this
          
          If *this\before\widget
            *this\before\widget\after\widget = *this
          Else
            If *this\parent\widget\first\widget
              *this\parent\widget\first\widget\before\widget = *this
            EndIf
            *this\parent\widget\first\widget = *this
          EndIf
        EndIf
        
        If Position = #PB_List_Last Or Position = #PB_List_After
          
          *this\before\widget = *widget
          *this\after\widget = *widget\after\widget 
          *widget\after\widget = *this
          
          If *this\after\widget
            *this\after\widget\before\widget = *this
          Else
            If *this\parent\widget\last\widget
              *this\parent\widget\last\widget\after\widget = *this
            EndIf
            *this\parent\widget\last\widget = *this
          EndIf
        EndIf
        
        ProcedureReturn #True
      EndIf
      
    EndProcedure
    
    Procedure   SetParent( *this._S_widget, *parent._S_widget, tabindex.l = 0 )
      Protected ReParent.b, x,y, *last._S_widget, *lastParent._S_widget, NewList *D._S_widget( ), NewList *C._S_widget( )
      
      If *parent
        ;TODO
        If tabindex < 0 
          If *parent\tab\widget
            tabindex = OpenTabIndex( *parent\tab\widget )
          Else
            tabindex = 0
          EndIf
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex%2
              splitter_first_gadget_( *parent ) = *this
              splitter_is_first_gadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If splitter_is_first_gadget_( *parent )
                ProcedureReturn 0
              EndIf
            Else
              splitter_second_gadget_( *parent ) = *this
              splitter_is_second_gadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If splitter_is_second_gadget_( *parent )
                ProcedureReturn 0
              EndIf
            EndIf    
          EndIf    
        EndIf
        
        ParentTabIndex( *this ) = tabindex
        
        ; set hide state 
        If *parent\hide
          *this\hide = #True
        ElseIf *parent\tab\widget
          ; hide all children except the selected tab
          *this\hide = Bool( FocusedTabindex( *parent\tab\widget ) <> tabindex)
        EndIf
        
        If *parent\last\widget
          *last = GetLast( *parent, tabindex )
        EndIf
        
        If *this And 
           *this\parent\widget
          If *this\parent\widget = *parent
            ProcedureReturn #False
          EndIf
          
          If *this\address
            *lastParent = *this\parent\widget
            *lastParent\count\childrens - 1
            
            ChangeCurrentElement( WidgetList( *this\root ), *this\address )
            AddElement( *D( ) ) : *D( ) = WidgetList( *this\root )
            
            If *this\count\childrens
              PushListPosition( WidgetList( *this\root ) )
              While NextElement( WidgetList( *this\root ) )
                If Not IsChild( WidgetList( *this\root ), *this ) 
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) = WidgetList( *this\root )
                *D( )\window = *parent\window
                *D( )\root = *parent\root
                ;; Debug " children - "+ *D( )\data +" - "+ *this\data
                
              Wend 
              PopListPosition( WidgetList( *this\root ) )
            EndIf
            
            ; move with a parent and his children
            If *this\root = *parent\root
              ; move inside the list
              LastElement( *D( ) )
              Repeat
                ChangeCurrentElement( WidgetList( *this\root ), *D( )\address )
                MoveElement( WidgetList( *this\root ), #PB_List_After, *last\address )
              Until PreviousElement( *D( ) ) = #False
            Else
              ForEach *D( )
                ChangeCurrentElement( WidgetList( *this\root ), *D( )\address )
                ; go to the end of the list to split the list
                MoveElement( WidgetList( *this\root ), #PB_List_Last ) 
              Next
              
              ; now we split the list and transfer it to another list
              ChangeCurrentElement( WidgetList( *this\root ), *this\address )
              SplitList( WidgetList( *this\root ), *D( ) )
              
              ; move between lists
              ChangeCurrentElement( WidgetList( *parent\root ), *last\address )
              MergeLists( *D( ), WidgetList( *parent\root ), #PB_List_After )
            EndIf
            
            ReParent = #True 
          EndIf
          
        Else
          If *parent\root
            If *last
              ChangeCurrentElement( WidgetList( *parent\root ), *last\address )
            Else
              LastElement( WidgetList( *parent\root ) )
            EndIf
            
            AddElement( WidgetList( *parent\root ) ) 
            WidgetList( *parent\root ) = *this
            *this\index = ListIndex( WidgetList( *parent\root ) ) 
            *this\address = @WidgetList( *parent\root )
          EndIf
        EndIf
        
        
        ; position in list
        If *this\after\widget
          *this\after\widget\before\widget = *this\before\widget
        EndIf
        If *this\before\widget
          *this\before\widget\after\widget = *this\after\widget
        EndIf
        If *this\parent\widget
          If *this\parent\widget\first\widget = *this
            ;             If *this\after\widget
            *this\parent\widget\first\widget = *this\after\widget
            ;             Else
            ;               *this\parent\widget\first\widget = *this\parent\widget ; if last type
            ;             EndIf
          EndIf 
          If *this\parent\widget\last\widget = *this
            If *this\before\widget
              *this\parent\widget\last\widget = *this\before\widget
            Else
              *this\parent\widget\last\widget = *this\parent\widget ; if last type
            EndIf
          EndIf 
        Else
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
          If *this\parent\widget
            *this\before\widget = *last
            ; for the panel element
            If ParentTabIndex( *last ) = ParentTabIndex( *this )
              *this\after\widget = *last\after\widget
            EndIf
          Else
            ; for the panel element
            If ParentTabIndex( *parent\last\widget ) = ParentTabIndex( *this )
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
        *this\root = *parent\root
        If is_window_( *parent ) 
          *this\window = *parent
        Else
          *this\window = *parent\window
        EndIf
        *this\parent\widget = *parent
        *this\level = *parent\level + 1
        *this\parent\widget\count\childrens + 1
        *this\count\parents = *parent\count\parents + 1
        
        ; TODO
        If *this\window
          Static NewMap typecount.l( )
          
          *this\count\index = typecount( Hex( *this\window + *this\type ))
          typecount( Hex( *this\window + *this\type )) + 1
          
          If *parent\_a_\transform
            *this\count\type = typecount( Hex( *parent ) + "_" + Hex( *this\type ))
            typecount( Hex( *parent ) + "_" + Hex( *this\type )) + 1
          EndIf
        EndIf
        ; set transformation for the child
        If Not *this\_a_\transform And *parent\_a_\transform 
          *this\_a_\transform = Bool( *parent\_a_\transform )
          *this\_a_\mode = #__a_full | #__a_position
          a_set( *this )
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
          
          PostEventRepaint( *parent )
          PostEventRepaint( *lastParent )
        EndIf
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i SetAlignmentFlag( *this._S_widget, Mode.l, Type.l = 1 ) ; ok
      Protected rx.b, ry.b
      
      With *this
        Select Type
          Case 1 ; widget
            If \parent\widget
              If Not \parent\widget\align
                \parent\widget\align.allocate( ALIGN )
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
              
              If *this\parent\widget\type = #__type_window
                parent_width = \parent\widget\width[#__c_inner]
                parent_height = \parent\widget\height[#__c_inner]
              Else
                parent_width = \parent\widget\width[#__c_frame]
                parent_height = \parent\widget\height[#__c_frame]
              EndIf
              
              ;
              If \parent\widget\align\indent\right = 0
                \parent\widget\align\indent\left = \parent\widget\x[#__c_container] 
                \parent\widget\align\indent\right = \parent\widget\align\indent\left + parent_width
              EndIf
              If \parent\widget\align\indent\bottom = 0
                \parent\widget\align\indent\top = \parent\widget\y[#__c_container] 
                \parent\widget\align\indent\bottom = \parent\widget\align\indent\top + parent_height 
              EndIf
              
              \align\indent\left = \x[#__c_container]
              \align\indent\right = \align\indent\left + \width
              
              \align\indent\top = \y[#__c_container]
              \align\indent\bottom = \align\indent\top + \height
              
              
              ; docking
              If Mode & #__align_auto = #__align_auto
                parent_width = ( \parent\widget\align\indent\right - \parent\widget\align\indent\left - \parent\widget\fs*2 )
                parent_height = ( \parent\widget\align\indent\bottom - \parent\widget\align\indent\top - \parent\widget\fs*2 )
                
                ; full horizontal
                If \align\anchor\right = 1 And \align\anchor\left = 1 
                  \align\indent\left = \x[#__c_container]
                  \align\indent\right = \align\indent\left + parent_width
                  ;; Debug ""+ \text\string +" "+ \parent\widget\x +" "+ \parent\widget\align\indent\left +" "+ \parent\widget\align\indent\right +" "+ \parent\widget\width[#__c_inner]
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
                  If StartEnumerate( *this\parent\widget ) 
                    If Widget( )\align 
                      
                      If ( Widget( )\align\anchor\left = 0 Or Widget( )\align\anchor\right = 0 ) And 
                         ( Widget( )\align\anchor\top = 1 And Widget( )\align\anchor\bottom = 1 )
                        Widget( )\align\indent\top = Widget( )\parent\widget\align\auto\top
                        Widget( )\align\indent\bottom = parent_height - Widget( )\parent\widget\align\auto\bottom
                      EndIf
                      
                      ;                         If ( Widget( )\align\anchor\top = 0 Or Widget( )\align\anchor\bottom = 0 ) And 
                      ;                            ( Widget( )\align\anchor\left = 1 And Widget( )\align\anchor\right = 1 )
                      ;                           Debug Widget( )\text\string
                      ;                           Widget( )\align\indent\left = Widget( )\parent\widget\align\auto\left
                      ;                           Widget( )\align\indent\right = parent_width - Widget( )\parent\widget\align\auto\right
                      ;                         EndIf
                    EndIf
                    StopEnumerate( )
                  EndIf
                EndIf
                ;                 
              EndIf
              
              ; update parent childrens coordinate
              Resize( \parent\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
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
        
        If*this\parent\widget
          If Not *this\parent\widget\align
            *this\parent\widget\align.allocate( ALIGN )
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
              *this\parent\widget\align\auto\left - *this\align\indent\right
            EndIf
            If *this\align\anchor\right And *this\align\anchor\left = 0
              *this\parent\widget\align\auto\right - ( ( *this\parent\widget\align\indent\right - *this\parent\widget\align\indent\left - *this\parent\widget\fs*2 ) - *this\align\indent\left )
            EndIf
            If *this\align\anchor\top And *this\align\anchor\bottom = 0
              *this\parent\widget\align\auto\top - *this\align\indent\bottom
            EndIf
            If *this\align\anchor\bottom And *this\align\anchor\top = 0
              *this\parent\widget\align\auto\bottom - ( ( *this\parent\widget\align\indent\bottom - *this\parent\widget\align\indent\top - *this\parent\widget\fs*2 ) - *this\align\indent\top )
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
          If *this\parent\widget\type = #__type_window
            parent_width = *this\parent\widget\width[#__c_inner]
            parent_height = *this\parent\widget\height[#__c_inner]
          Else
            parent_width = *this\parent\widget\width[#__c_frame]
            parent_height = *this\parent\widget\height[#__c_frame]
          EndIf
          
          ;
          If*this\parent\widget\align\indent\right = 0
            *this\parent\widget\align\indent\left = *this\parent\widget\x[#__c_container] 
            *this\parent\widget\align\indent\right = *this\parent\widget\align\indent\left + parent_width
          EndIf
          If*this\parent\widget\align\indent\bottom = 0
            *this\parent\widget\align\indent\top = *this\parent\widget\y[#__c_container] 
            *this\parent\widget\align\indent\bottom = *this\parent\widget\align\indent\top + parent_height 
          EndIf
          
          ;
          If flag & #__align_auto = #__align_auto
            parent_width = ( *this\parent\widget\align\indent\right - *this\parent\widget\align\indent\left - *this\parent\widget\fs*2 )
            parent_height = ( *this\parent\widget\align\indent\bottom - *this\parent\widget\align\indent\top - *this\parent\widget\fs*2 )
            
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
        If *this\parent\widget\align 
          If left = #__align_auto And 
             *this\parent\widget\align\auto\left
            left =- *this\parent\widget\align\auto\left
          EndIf
          If right = #__align_auto And 
             *this\parent\widget\align\auto\right
            right =- *this\parent\widget\align\auto\right
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
             *this\parent\widget\align\auto\top
            top =- *this\parent\widget\align\auto\top
          EndIf
          If bottom = #__align_auto And 
             *this\parent\widget\align\auto\bottom
            bottom =- *this\parent\widget\align\auto\bottom
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
          *this\parent\widget\align\auto\left = *this\align\indent\right
        EndIf
        If *this\align\anchor\right And *this\align\anchor\left = 0
          *this\parent\widget\align\auto\right = ( *this\parent\widget\align\indent\right - *this\parent\widget\align\indent\left - *this\parent\widget\fs*2 ) - *this\align\indent\left 
        EndIf
        If *this\align\anchor\top And *this\align\anchor\bottom = 0
          *this\parent\widget\align\auto\top = *this\align\indent\bottom
        EndIf
        If *this\align\anchor\bottom And *this\align\anchor\top = 0
          *this\parent\widget\align\auto\bottom = ( *this\parent\widget\align\indent\bottom - *this\parent\widget\align\indent\top - *this\parent\widget\fs*2 ) - *this\align\indent\top
        EndIf
        
        If ( *this\parent\widget\align\auto\left Or
             *this\parent\widget\align\auto\top Or
             *this\parent\widget\align\auto\right Or
             *this\parent\widget\align\auto\bottom )
          
          ;         Protected parent_width = ( *this\parent\widget\align\indent\right - *this\parent\widget\align\indent\left - *this\parent\widget\fs*2 )
          ;         Protected parent_height = ( *this\parent\widget\align\indent\bottom - *this\parent\widget\align\indent\top - *this\parent\widget\fs*2 )
          
          ; loop enumerate widgets
          If StartEnumerate( *this\parent\widget ) 
            If Widget( )\align 
              If Widget( )\align\anchor\left And Widget( )\align\anchor\right And 
                 Widget( )\align\anchor\top And Widget( )\align\anchor\bottom 
                
                Widget( )\align\indent\top = Widget( )\parent\widget\align\auto\top
                Widget( )\align\indent\bottom = parent_height - Widget( )\parent\widget\align\auto\bottom
                Widget( )\align\indent\left = Widget( )\parent\widget\align\auto\left
                Widget( )\align\indent\right = parent_width - Widget( )\parent\widget\align\auto\right
                
                Debug Widget( )\class +""+ Widget( )\parent\widget\align\auto\left +" "+ Widget( )\parent\widget\align\auto\right
              EndIf
              
              If flag & #__align_full = #__align_full
                If ( Widget( )\align\anchor\left = 0 Or Widget( )\align\anchor\right = 0 ) And 
                   ( Widget( )\align\anchor\top = 1 And Widget( )\align\anchor\bottom = 1 )
                  Widget( )\align\indent\top = Widget( )\parent\widget\align\auto\top
                  Widget( )\align\indent\bottom = parent_height - Widget( )\parent\widget\align\auto\bottom
                EndIf
                ;           
                ;           ;                         If ( Widget( )\align\anchor\top = 0 Or Widget( )\align\anchor\bottom = 0 ) And 
                ;           ;                            ( Widget( )\align\anchor\left = 1 And Widget( )\align\anchor\right = 1 )
                ;           ;                           Debug Widget( )\text\string
                ;           ;                           Widget( )\align\indent\left = Widget( )\parent\widget\align\auto\left
                ;           ;                           Widget( )\align\indent\right = parent_width - Widget( )\parent\widget\align\auto\right
                ;           ;                         EndIf
              EndIf
            EndIf
            StopEnumerate( )
          EndIf
        EndIf
        
        ; update parent childrens coordinate
        Resize( *this\parent\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        PostEventRepaint( *this\root )
      EndIf
      
    EndProcedure
    
    
    Procedure.i SetAttachment( *this._S_widget, *parent._S_widget, mode.a )
      If *parent 
        *this\attach.allocate( ATTACH )
        If *this\attach
          *this\attach\mode = mode
          
          ; get attach-element first-parent
          *this\attach\parent\widget = *parent
          While *this\attach\parent\widget\attach
            *this\attach\parent\widget = *this\attach\parent\widget\parent\widget
          Wend
          *this\attach\parent\widget = *this\attach\parent\widget\parent\widget
          
          ;AddWidget( *this, *parent )
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
      
      *this\bounds\move\x\min = MinimumX
      *this\bounds\move\x\max = MaximumX
      
      *this\bounds\move\y\min = MinimumY
      *this\bounds\move\y\max = MaximumY
      
      ;
      If *this\bounds\move\x\min <> #PB_Ignore And
         *this\x[#__c_frame] < *this\bounds\move\x\min
        x = *this\bounds\move\x\min
        If *this\width[#__c_frame] > *this\bounds\move\x\max - x
          width = *this\bounds\move\x\max - x
        EndIf
      ElseIf *this\bounds\move\x\max <> #PB_Ignore And 
             *this\width[#__c_frame] > ( *this\bounds\move\x\max - *this\x[#__c_frame] )
        width = *this\bounds\move\x\max - *this\x[#__c_frame]
      EndIf
      If *this\bounds\move\y\min <> #PB_Ignore And 
         *this\y[#__c_frame] < *this\bounds\move\y\min 
        y = *this\bounds\move\y\min
        If *this\height[#__c_frame] > *this\bounds\move\y\max - y
          height = *this\bounds\move\y\max - y
        EndIf
      ElseIf *this\bounds\move\y\max <> #PB_Ignore And
             *this\height[#__c_frame] > ( *this\bounds\move\y\max - *this\y[#__c_frame] )
        height = *this\bounds\move\y\max - *this\y[#__c_frame]
      EndIf
      
      ProcedureReturn Resize( *this, x, y, width, height )
    EndProcedure
    
    Procedure   SizeBounds( *this._S_widget, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
      ; If the value is set to #PB_Ignore, the current value is not changed. 
      ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
      Protected.l x = #PB_Ignore, y = #PB_Ignore, width = #PB_Ignore, height = #PB_Ignore
      
      *this\bounds\size.allocate(BOUNDSize)
      
      *this\bounds\size\width\min = MinimumWidth
      *this\bounds\size\width\max = MaximumWidth
      
      *this\bounds\size\height\min = MinimumHeight
      *this\bounds\size\height\max = MaximumHeight
      
      ;
      If *this\bounds\size\width\min <> #PB_Ignore And
         *this\width[#__c_frame] < *this\bounds\size\width\min
        width = *this\bounds\size\width\min
      ElseIf *this\bounds\size\width\max <> #PB_Ignore And
             *this\width[#__c_frame] > *this\bounds\size\width\max
        width = *this\bounds\size\width\max
      EndIf
      If *this\bounds\size\height\min <> #PB_Ignore And 
         *this\height[#__c_frame] < *this\bounds\size\height\min 
        height = *this\bounds\size\height\min
      ElseIf *this\bounds\size\height\max <> #PB_Ignore And 
             *this\height[#__c_frame] > *this\bounds\size\height\max
        height = *this\bounds\size\height\max
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
            
            ;             PushListPosition( RowList( *this )) 
            ;             ForEach RowList( *this )
            ;               If RowList( *this )\index = Item 
            ;                 result = RowList( *this )\data
            ;                 ; Debug RowList( *this )\text\string
            ;                 Break
            ;               EndIf
            ;             Next
            ;             PopListPosition( RowList( *this ))
            ; 
            If is_no_select_item_( RowList( *this ), item )
              ProcedureReturn #False
            EndIf
            
            result = RowList( *this )\data
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
        ProcedureReturn bar_tab_GetItemText( *this\tab\widget, Item, Column )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn bar_tab_GetItemText( *this, Item, Column )
      EndIf
      
      If *this\count\items ; row\count
        If is_no_select_item_( RowList( *this ), Item ) 
          ProcedureReturn ""
        EndIf
        
        If *this\type = #__type_property And Column 
          result = RowList( *this )\text\edit\string
        Else
          result = RowList( *this )\text\string
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
        
        If is_no_select_item_( RowList( *this ), Item ) 
          ProcedureReturn #PB_Default
        EndIf
        
        result = RowList( *this )\image\img
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont( *this._S_widget, Item.l )
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_ListView Or
         *this\type = #__type_Tree
        
        If is_no_select_item_( RowList( *this ), Item ) 
          ProcedureReturn #False
        EndIf
        
        result = RowList( *this )\text\fontID
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemState( *this._S_widget, Item.l )
      Protected result
      
      ; 
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( TabList( *this ), Item ) 
          ProcedureReturn #False
        EndIf
        
        ProcedureReturn TabList( *this )\state\flag
      EndIf
      
      If *this\type = #__type_Editor
        If item =- 1
          ProcedureReturn edit_caret_pos_delta_( *this )
        Else
          ProcedureReturn edit_caret_pos_( *this )
        EndIf
        
      ElseIf *this\type = #__type_Tree
        If is_item_( *this, item ) And SelectElement( RowList( *this ), Item ) 
          If RowList( *this )\color\state
            result | #__tree_selected
          EndIf
          
          If RowList( *this )\checkbox\___state 
            If *this\mode\threestate And 
               RowList( *this )\checkbox\___state= #PB_Checkbox_Inbetween
              result | #__tree_Inbetween
            Else
              result | #__tree_checked
            EndIf
          EndIf
          
          If RowList( *this )\count\childrens And
             RowList( *this )\button\___state= 0
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
        If is_item_( *this, item ) And SelectElement( RowList( *this ), Item )
          *color = RowList( *this )\color
        EndIf
      ElseIf *this\type = #__type_Tree 
        If is_item_( *this, item ) And SelectElement( RowList( *this ), Item )
          *color = RowList( *this )\color
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
        If is_no_select_item_( RowList( *this ), Item )
          ProcedureReturn #False
        EndIf
        
        Select Attribute
          Case #__tree_sublevel
            result = RowList( *this )\sublevel
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i SetItemData( *This._S_widget, item.l, *data )
      If *this\count\items 
        If is_no_select_item_( RowList( *this ), item )
          ProcedureReturn #False
        EndIf
        
        RowList( *this )\data = *Data
      EndIf
    EndProcedure
    
    Procedure.l SetItemText( *this._S_widget, Item.l, Text.s, Column.l = 0 )
      Protected result
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( TabList( *this ), item )
          ProcedureReturn #False
        EndIf
        
        *this\bar\change_tab_items = #True
        TabList( *this )\text\string = Text.s
        PostEventCanvas( *this\root )
      EndIf
      
      If *this\type = #__type_Tree Or 
         *this\type = #__type_property
        
        ;Item = *this\row\i( Hex( Item ))
        
        If is_no_select_item_( RowList( *this ), item )
          ProcedureReturn #False
        EndIf
        
        Protected row_count = CountString( Text.s, #LF$ )
        
        If Not row_count
          RowList( *this )\text\string = Text.s
        Else
          RowList( *this )\text\string = StringField( Text.s, 1, #LF$ )
          RowList( *this )\text\edit\string = StringField( Text.s, 2, #LF$ )
        EndIf
        
        RowList( *this )\text\change = 1
        *this\change = 1
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText( *this\tab\widget, Item, Text, Column )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) 
        If is_item_( *this, Item ) And
           SelectElement( TabList( *this ), Item ) And 
           TabList( *this )\text\string <> Text 
          TabList( *this )\text\string = Text 
          TabList( *this )\text\change = 1
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
        
        If is_item_( *this, item ) And SelectElement( RowList( *this ), Item )
          If RowList( *this )\image\img <> Image
            set_image_( *this, RowList( *this )\Image, Image )
            _post_repaint_items_( *this )
            *this\change = 1
            ;;PostEventCanvas( *this\root )
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
           SelectElement( RowList( *this ), Item ) And 
           RowList( *this )\text\fontID <> FontID
          RowList( *this )\text\fontID = FontID
          ;       RowList( *this )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      ElseIf *this\type = #__type_Panel
        If is_item_( *this\tab\widget, item ) And 
           SelectElement( TabList( *this\tab\widget ), Item ) And 
           TabList( *this\tab\widget )\text\fontID <> FontID
          TabList( *this\tab\widget )\text\fontID = FontID
          ;       RowList( *this )\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState( *this._S_widget, Item.l, State.b )
      Protected result
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_no_select_item_( TabList( *this ), Item )
          ProcedureReturn #False
        EndIf
        
        If State & #__tree_selected = #__tree_selected
          ;           If FocusedRow( *this ) <> TabList( *this )
          ;             FocusedRow( *this ) = TabList( *this )
          ;             FocusedRow( *this )\state\press = #true
          ;             FocusedRow( *this )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          ;           EndIf
          bar_tab_SetState( *this, Item )
        EndIf
        
        If State & #__tree_inbetween = #__tree_inbetween
          TabList( *this )\checkbox\___state= #PB_Checkbox_Inbetween
        ElseIf State & #__tree_checked = #__tree_checked
          TabList( *this )\checkbox\___state= #PB_Checkbox_Checked
        EndIf
        
        PostEventCanvas( *this\root )
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
          If is_no_select_item_( RowList( *this ), Item )
            ProcedureReturn #False
          EndIf
          
          Protected *this_current_row._S_rows = RowList( *this )
          
          If State & #__tree_selected = #__tree_selected
            If FocusedRow( *this ) <> RowList( *this )
              FocusedRow( *this ) = RowList( *this )
              FocusedRow( *this )\state\press = #True
              FocusedRow( *this )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
          EndIf
          
          If State & #__tree_inbetween = #__tree_inbetween
            RowList( *this )\checkbox\___state= #PB_Checkbox_Inbetween
          ElseIf State & #__tree_checked = #__tree_checked
            RowList( *this )\checkbox\___state= #PB_Checkbox_Checked
          EndIf
          
          If RowList( *this )\count\childrens
            If State & #__tree_expanded = #__tree_expanded Or 
               State & #__tree_collapsed = #__tree_collapsed
              
              *this\change = #True
              RowList( *this )\button\___state= Bool( State & #__tree_collapsed )
              
              PushListPosition( RowList( *this ))
              While NextElement( RowList( *this ))
                If RowList( *this )\parent\row 
                  RowList( *this )\hide = Bool( RowList( *this )\parent\row\button\___state| RowList( *this )\parent\row\hide )
                EndIf
                
                If RowList( *this )\sublevel = *this_current_row\sublevel 
                  PostEventCanvas( *this\root )
                  Break
                EndIf
              Wend
              PopListPosition( RowList( *this ))
            EndIf
          EndIf
          
          result = *this_current_row\button\___state 
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
      If ListSize( RowList( *this ) ) ;*this\type = #__type_Tree Or *this\type = #__type_Editor
        If Item = #PB_All
          PushListPosition( RowList( *this )) 
          ForEach RowList( *this )
            set_color_( result, RowList( *this )\color, ColorType, Color, alpha, [Column] )
          Next
          PopListPosition( RowList( *this )) 
          
        Else
          If is_item_( *this, item ) And SelectElement( RowList( *this ), Item )
            set_color_( result, RowList( *this )\color, ColorType, Color, alpha, [Column] )
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
      Protected ScrollBars, *this.allocate( Widget )
      
      If *parent
        If Bool( Flag & #__flag_child = #__flag_child )
          *this\child = 1
          *this\parent\widget = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\address = *parent\address
          ;;Debug  ""+ *this\class+" "+*this\scroll\increment
          
        Else
          set_align_flag_( *this, *parent, flag )
          
          AddWidget( *this, *parent )
        EndIf
      EndIf
      
      With *this
        *this\flag = Flag
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        *this\type = type
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
          
          edit_line_pos_( *this ) =- 1
          
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
              If Widget( )\type = #__type_Option
                *this\_group = Widget( )\_group 
              Else
                *this\_group = Widget( ) 
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
            
            *this\cursor = #PB_Cursor_Hand
            
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
          
          ;*this\row\index =- 1
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
          
          *this\fs = Bool( Not Flag&#__flag_borderLess ) * #__border_scroll
        EndIf
        
        ; - Create Bars
        If *this\type = #__type_ScrollBar Or 
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_TrackBar Or
           ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
           *this\type = #__type_Spin Or
           *this\type = #__type_Splitter
          
          *this\bar.allocate( BAR )
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
            
            If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\class = class+"-v"
            Else
              *this\class = class+"-h"
            EndIf
            
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            *this\bar\button[#__b_3]\color = _get_colors_( )
            
            If Not Flag & #__flag_nobuttons = #__flag_nobuttons
              *this\bar\button[#__b_1]\size =- 1
              *this\bar\button[#__b_2]\size =- 1
            EndIf
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            *this\bar\button[#__b_3]\size = size
            
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
            *this\color = _get_colors_( )
            *this\color\_alpha = 255
            *this\color\back = $FFFFFFFF
            
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
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
              *this\bar\button[#__b_1]\arrow\size = #__arrow_size
              *this\bar\button[#__b_2]\arrow\size = #__arrow_size
              
              *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
              *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
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
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            ;*this\bar\button[#__b_3]\interact = #True
            
            
            set_text_flag_( *this, flag )
            
            
          EndIf
          
          ; - Create Tab
          If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
            ;;*this\text\change = 1
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #False )
            
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
            
            set_text_flag_( *this, flag )
          EndIf
          
          ; - Create Track
          If *this\type = #__type_TrackBar
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            *this\bar\button[#__b_3]\color = _get_colors_( )
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\invert = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            ;             If flag & #PB_Trackbar_Ticks = #PB_Trackbar_Ticks
            ;               *this\bar\widget\flag | #PB_Trackbar_Ticks
            ;             EndIf
            
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
            
            set_text_flag_( *this, flag )
            
          EndIf
          
          ; - Create Progress
          If *this\type = #__type_ProgressBar
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_( )
            *this\bar\button[#__b_2]\color = _get_colors_( )
            ;*this\bar\button[#__b_3]\color = _get_colors_( )
            
            
            If Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\invert = Bool( Not Flag & #__bar_invert )
            Else
              *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            EndIf
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            
            *this\text\change = #True
            set_text_flag_( *this, flag | #__text_center )
          EndIf
          
          ; - Create Splitter
          If *this\type = #__type_Splitter
            *this\color\back =- 1
            
            ;         *this\bar\button[#__b_1]\color = _get_colors_( )
            ;         *this\bar\button[#__b_2]\color = _get_colors_( )
            ;         *this\bar\button[#__b_3]\color = _get_colors_( )
            
            ;;Debug ""+*param_1 +" "+ PB(IsGadget)( *param_1 )
            
            ;*this\container =- *this\type 
            splitter_first_gadget_( *this ) = *param_1
            splitter_second_gadget_( *this ) = *param_2
            splitter_is_first_gadget_( *this ) = Bool( PB(IsGadget)( splitter_first_gadget_( *this ) ))
            splitter_is_second_gadget_( *this ) = Bool( PB(IsGadget)( splitter_second_gadget_( *this ) ))
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            ;             If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
            ;               *this\bar\widget\flag | #PB_Splitter_Separator
            ;             EndIf
            
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
            
          EndIf
        EndIf
        
        ;
        If *this\child = 0
          ; splitter 
          If *this\type = #__type_Splitter
            If splitter_first_gadget_( *this ) And Not splitter_is_first_gadget_( *this )
              SetParent( splitter_first_gadget_( *this ), *this )
            EndIf
            
            If splitter_second_gadget_( *this ) And Not splitter_is_second_gadget_( *this )
              SetParent( splitter_second_gadget_( *this ), *this )
            EndIf
          EndIf
          
          ;
          If *this\type = #__type_Panel 
            *this\tab\widget = Create( *this, *this\class+"_TabBar", #__type_TabBar, 0,0,0,0, #Null$, Flag | #__flag_child, 0,0,0, 0,0,30 )
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
          
        EndIf
        
        ;         ; AddObject( )
        ;         DoEvents( *this, #PB_EventType_Create )
        ;         PostEventRepaint( *this )
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
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ListIcon, x,y,width,height, "", Flag )
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
      
      set_align_flag_( *this, *parent, *this\flag )
      AddWidget( *this, *parent )
      
      _add_action_( *this )
      
      
      *this\x[#__c_inner] =- 2147483648
      *this\y[#__c_inner] =- 2147483648
      
      *this\type = #__type_ComboBox
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 1 
      *this\bs = *this\fs
      *this\flag = Flag
      
      *this\row.allocate( ROW )
      
      If *this\flag & #PB_ComboBox_Editable
        *this\flag &~ #PB_ComboBox_Editable
      Else
        *this\flag | #__text_readonly
      EndIf
      
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
      
      set_align_flag_( *this, *parent, flag )
      AddWidget( *this, *parent )
      
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
    Procedure.l draw_items_( *this._S_widget, List *row._S_rows( ), _scroll_x_, _scroll_y_ )
      Protected state.b, x.l, y.l, _box_x_.l, _box_y_.l, minus.l = 7
      
      ;
      ;_content_clip_( *this, [#__c_clip2] )
      
      PushListPosition( *row( ))
      Protected bs = Bool( *this\fs )
      ; Debug ""+*this\x +" "+ *this\x[#__c_inner]
      ; Draw all items
      ForEach *row( )
        If *row( )\visible 
          ;           If *row( )\x <> *this\x[#__c_inner] + bs
          ;             *row( )\x = *this\x[#__c_inner] + bs
          ;           EndIf
          If *row( )\width <> *this\width[#__c_inner] - bs*2
            *row( )\width = *this\width[#__c_inner] - bs*2
          EndIf
          
          X = row_x_( *this, *row( ) ) + scroll_x_( *this )
          Y = row_y_( *this, *row( ) ) + scroll_y_( *this )
          state = *row( )\color\state  
          
          ; init real drawing font
          draw_font_item_( *this, *row( ), 0 )
          
          ; Draw selector back
          If *row( )\count\childrens And *this\flag & #__tree_property
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            DrawRoundBox_( x, y, *this\width[#__c_inner],*row( )\height,*row( )\round,*row( )\round,*row( )\color\back )
            ;DrawRoundBox_( *this\x[#__c_inner] + *this\row\sublevelsize,Y,*this\width[#__c_inner] - *this\row\sublevelsize,*row( )\height,*row( )\round,*row( )\round,*row( )\color\back[state] )
            Line( x + *this\row\sublevelsize, y + *row( )\height, *this\width[#__c_inner] - *this\row\sublevelsize, 1, $FFACACAC )
            
          Else
            If *row( )\color\back[state]
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              DrawRoundBox_( x, y, *row( )\width, *row( )\height,*row( )\round,*row( )\round,*row( )\color\back[state] )
            EndIf
          EndIf
          
          ;               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  *this\_dd And
          ;                  
          ;               If mouse( )\buttons And 
          ;                  *row( )\state\enter And 
          ;                  Not *this\state\press
          ;                 
          ;                 DrawingModeAlpha_( #PB_2DDrawing_Default )
          ;                 If (y + *row( )\height/2) > mouse( )\y 
          ;                   Line( *row( )\x, y - *this\mode\gridlines, *row( )\width, 1, $ff000000 )
          ;                 Else
          ;                   Line( *row( )\x, y + *row( )\height, *row( )\width, 1, $ff000000 )
          ;                 EndIf
          ;               EndIf
          
          ; Draw items image
          If *row( )\image\id
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *row( )\image\id, x + *row( )\image\x, y + *row( )\image\y, *row( )\color\_alpha )
          EndIf
          
          ; Draw items text
          If *row( )\text\string.s
            DrawingMode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( x + *row( )\text\x, y + *row( )\text\y, *row( )\text\string.s, *this\text\rotate, *row( )\color\front[state] )
          EndIf
          
          ; Draw items data text
          If *row( )\text\edit\string.s
            DrawingMode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( x + *row( )\text\edit\x - _scroll_x_, *row( )\y + *row( )\text\edit\y - _scroll_y_, *row( )\text\edit\string.s, *this\text\rotate, *row( )\color\front[state] )
          EndIf
          
          ; Draw selector frame
          If *row( )\count\childrens And *this\flag & #__tree_property
          Else
            If *row( )\color\frame[state]
              DrawingMode_( #PB_2DDrawing_Outlined )
              DrawRoundBox_( x, y, *row( )\width, *row( )\height, *row( )\round,*row( )\round, *row( )\color\frame[state] )
            EndIf
          EndIf
          
          ; Horizontal line
          If *this\mode\GridLines And *row( )\color\line <> *row( )\color\back
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            DrawBox_( x, y + *row( )\height + Bool( *this\mode\gridlines>1 ) , *row( )\width, 1, *this\color\line )
          EndIf
        EndIf
      Next
      
      ;           DrawingModeAlpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
      ;          DrawBox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevelsize, *this\height[#__c_inner], RowList( *this )\parent\row\color\back )
      
      
      ; Draw plots
      If *this\mode\lines ;= 1
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ; DrawingMode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
        
        ForEach *row( )
          If *row( )\visible And Not *row( )\hide 
            X = row_x_( *this, *row( ) ) + scroll_x_( *this )
            Y = row_y_( *this, *row( ) ) + scroll_y_( *this )
            
            ; for the tree vertical line
            If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
              Line((x + *row( )\last\button\x+*row( )\last\button\width/2), (y+*row( )\height), 1, (*row( )\last\y-*row( )\y)-*row( )\last\height/2, *row( )\color\line )
            EndIf
            If *row( )\parent\row And Not *row( )\parent\row\visible And *row( )\parent\row\last = *row( ) And *row( )\sublevel
              Line((x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\row\y+*row( )\parent\row\height) - _scroll_y_, 1, (*row( )\y-*row( )\parent\row\y)-*row( )\height/2, *row( )\parent\row\color\line )
            EndIf
            
            ; for the tree horizontal line
            If Not (*this\mode\buttons And *row( )\count\childrens)
              Line((x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 7, 1, *row( )\color\line )
            EndIf
          EndIf    
        Next
        
        ; for the tree item first vertical line
        If *this\row\first And *this\row\last
          Line((*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - _scroll_x_, (*this\row\first\y+*this\row\first\height/2) - _scroll_y_, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
        EndIf
        
      ElseIf *this\mode\lines = 2
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ; DrawingMode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
        
        ForEach *row( )
          If *row( )\visible And Not *row( )\hide 
            X = row_x_( *this, *row( ) ) + scroll_x_( *this ) - Bool(*row( )\parent\row Or *row( )\count\childrens) * *this\row\sublevelsize
            Y = row_y_( *this, *row( ) ) + scroll_y_( *this )
            
            If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
              Line((x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
            EndIf
            If *row( )\parent\row And Not *row( )\parent\row\visible And *row( )\parent\row\last = *row( ) And *row( )\sublevel
              Line((x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\row\y+*row( )\parent\row\height/2) - _scroll_y_, 1, (*row( )\y-*row( )\parent\row\y), *row( )\parent\row\color\line )
            EndIf
            
            ; for the tree horizontal line
            If *row( )\parent\row
              Line((x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 7, 1, *row( )\color\line )
            EndIf
            
            If (Not *this\mode\buttons And *row( )\count\childrens)
              Line((x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize-3, (y+*row( )\height/2), 3, 1, *row( )\color\line )
            EndIf
          EndIf    
        Next
        
      ElseIf *this\mode\lines = 3
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ; DrawingMode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
        ; for the tree item first vertical line
        If *this\row\first And *this\row\last
          Line((*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - _scroll_x_ - minus, (*this\row\first\y+*this\row\first\height/2) - _scroll_y_, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
        EndIf
        
        
        ForEach *row( )
          If *row( )\visible And Not *row( )\hide 
            X = row_x_( *this, *row( ) ) + scroll_x_( *this ) - Bool(*row( )\parent\row Or *row( )\count\childrens) * *this\row\sublevelsize
            Y = row_y_( *this, *row( ) ) + scroll_y_( *this )
            
            ; for the tree vertical line
            If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
              Line((x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
            EndIf
            If *row( )\parent\row And Not *row( )\parent\row\visible And *row( )\parent\row\last = *row( ) And *row( )\sublevel
              Line((x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\row\y+*row( )\parent\row\height/2) - _scroll_y_, 1, (*row( )\y-*row( )\parent\row\y), *row( )\parent\row\color\line )
            EndIf
            
            ; for the tree horizontal line
            If (Not *this\mode\buttons And *row( )\count\childrens) 
              If *row( )\last\sublevel > 1 Or minus
                Line((x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize-4-Bool(minus And *row( )\last\sublevel < 2)*3, (y+*row( )\height/2), 4+Bool(minus And *row( )\last\sublevel < 2)*3, 1, *row( )\color\line )
              EndIf
            ElseIf *row( )\parent\row
              Line((x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 5, 1, *row( )\color\line )
            ElseIf Not (*this\mode\buttons And *row( )\count\childrens) Or *row( ) = *this\row\first Or *row( ) = *this\row\last
              If *row( ) = *this\row\first Or *row( ) = *this\row\last
                x + Bool(*row( )\parent\row Or *row( )\count\childrens) * *this\row\sublevelsize
              EndIf
              Line((x + *row( )\button\x+*row( )\button\width/2) - minus, (y+*row( )\height/2), 7, 1, *row( )\color\line )
            EndIf
          EndIf    
        Next
      ElseIf *this\mode\lines ;= 4
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ; DrawingMode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
        
        ; for the tree item first vertical line
        If *this\row\first And *this\row\last
          Line((*this\x[#__c_inner] + *this\row\first\button\x+*this\row\first\button\width/2) - _scroll_x_, (*this\row\first\y+*this\row\first\height/2) - _scroll_y_, 1, (*this\row\last\y-*this\row\first\y), *this\row\first\color\line )
        EndIf
        
        ForEach *row( )
          If *row( )\visible And Not *row( )\hide 
            X = row_x_( *this, *row( ) ) + scroll_x_( *this ) - Bool(*row( )\parent\row Or *row( )\count\childrens) * *this\row\sublevelsize
            Y = row_y_( *this, *row( ) ) + scroll_y_( *this )
            
            ; for the tree vertical line
            If *row( )\last And Not *row( )\last\hide And *row( )\last\sublevel
              Line((x + *row( )\last\button\x+*row( )\button\width/2), (y+*row( )\height/2), 1, (*row( )\last\y-*row( )\y), *row( )\color\line )
            EndIf
            If *row( )\parent\row And Not *row( )\parent\row\visible And *row( )\parent\row\last = *row( ) And *row( )\sublevel
              Line((x + *row( )\button\x+*row( )\button\width/2), (*row( )\parent\row\y+*row( )\parent\row\height/2) - _scroll_y_, 1, (*row( )\y-*row( )\parent\row\y), *row( )\parent\row\color\line )
            EndIf
            
            ; for the tree horizontal line
            If (Not *this\mode\buttons And *row( )\count\childrens) And *row( )\sublevel
              Line((x + *row( )\button\x+*row( )\button\width/2) + *this\row\sublevelsize, (y+*row( )\height/2), 5, 1, *row( )\color\line )
            EndIf
            
            If *row( ) = *this\row\first Or *row( ) = *this\row\last Or (*row( )\count\childrens And *row( )\sublevel = 0)
              x + Bool(*row( )\parent\row Or *row( )\count\childrens) * *this\row\sublevelsize
            EndIf
            
            If Not ( *this\mode\buttons And *row( )\count\childrens And *row( )\sublevel = 0 )
              Line((x + *row( )\button\x+*row( )\button\width/2), (y+*row( )\height/2), 5, 1, *row( )\color\line )
            EndIf
          EndIf    
        Next
      EndIf
      
      ; Draw buttons
      If *this\mode\buttons Or
         ( *this\mode\check = #__m_checkselect Or *this\mode\check = #__m_optionselect )
        
        ; Draw boxs ( check&option )
        ForEach *row( )
          If *row( )\visible And *this\mode\check
            X = row_x_( *this, *row( ) ) + *row( )\checkbox\x + scroll_x_( *this )
            Y = row_y_( *this, *row( ) ) + *row( )\checkbox\y + scroll_y_( *this )
            
            If *row( )\parent\row And *this\mode\check = #__m_optionselect
              ; option
              draw_button_( 1, x, y, *row( )\checkbox\width, *row( )\checkbox\height, *row( )\checkbox\___state , 4 );, \color )
            Else                                                                                                     ;If Not ( *this\mode\buttons And *row( )\count\childrens And *this\mode\check = #__m_optionselect )
                                                                                                                     ; check
              draw_button_( 3, x, y, *row( )\checkbox\width, *row( )\checkbox\height, *row( )\checkbox\___state , 2 );, \color )
            EndIf
          EndIf    
        Next
        
        DrawingMode_( #PB_2DDrawing_Outlined); | #PB_2DDrawing_AlphaBlend )
        
        ; Draw buttons ( expanded&collapsed )
        ForEach *row( )
          If *row( )\visible And Not *row( )\hide 
            X = row_x_( *this, *row( ) ) + *row( )\button\x + scroll_x_( *this )
            Y = row_y_( *this, *row( ) ) + *row( )\button\y + scroll_y_( *this )
            
            If *this\mode\buttons And *row( )\count\childrens And
               Not ( *row( )\sublevel And *this\mode\check = #__m_optionselect )
              
              If #PB_Compiler_OS = #PB_OS_Windows Or 
                 (*row( )\parent\row And *row( )\parent\row\last And *row( )\parent\row\sublevel = *row( )\parent\row\last\sublevel)
                
                draw_button_( 0, x, y, *row( )\button\width, *row( )\button\height, 0,2)
                draw_box_( *row( )\button, color\frame )
                
                Line(x + 2, y + *row( )\button\height/2, *row( )\button\width - 4, 1, $ff000000)
                If *row( )\button\___state 
                  Line(x + *row( )\button\width/2, y + 2, 1, *row( )\button\height - 4, $ff000000)
                EndIf
                
              Else
                
                Arrow( x + ( *row( )\button\width - 4 )/2,
                       y + ( *row( )\button\height - 4 )/2, 4, 
                       Bool( Not *row( )\button\___state) + 2, *row( )\color\front[0] ,0,0 ) 
                
              EndIf
              
            EndIf
          EndIf    
        Next
      EndIf
      
      ; 
      PopListPosition( *row( )) ; 
      
    EndProcedure
    
    Procedure   draw_Container_( *this._S_widget, x,y )
      With *this
        
        ; background draw
        If Not ( *this\image[#__img_background]\id And 
                 ( *this\image[#__img_background]\width > *this\width[#__c_inner] Or 
                   *this\image[#__img_background]\height > *this\height[#__c_inner] ) )
          
          If *this\color\back <>- 1
            If *this\color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( *this\vertical, *this,\color\fore[\color\state],\color\back[Bool( *this\__state&#__ss_back )*\color\state], [#__c_frame] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              draw_box_( *this, color\back, [#__c_inner])
            EndIf
          EndIf
        EndIf
        
        ;
        If *this\image\id Or *this\image[#__img_background]\id Or *this\text\string
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
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
          If *this\row And ListSize( RowList( *this ) )
            ForEach RowList( *this )
              DrawRotatedText( x + RowList( *this )\text\x, y + RowList( *this )\text\y,
                               RowList( *this )\text\String.s, *this\text\rotate, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] ) ; RowList( *this )\color\font )
              
              If *this\mode\lines
                Protected i, count = Bool( func::GetFontSize( RowList( *this )\text\fontID ) > 13 )
                For i = 0 To count
                  Line( x + RowList( *this )\text\x, y + RowList( *this )\text\y + RowList( *this )\text\height - count + i - 1, RowList( *this )\text\width,1, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] )
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
          
          Editor_Update( *this, RowList( *this ))
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
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__img_background]\id, x + *this\image[#__img_background]\x, x + *this\image[#__img_background]\y, *this\color\_alpha )
        Else
          If *this\color\back <>- 1
            If \color\fore <>- 1
              DrawingModeAlpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( \vertical, *this,\color\fore[\color\state],\color\back[Bool( *this\__state&#__ss_back )*\color\state], [#__c_frame] )
            Else
              DrawingModeAlpha_( #PB_2DDrawing_Default )
              draw_box_( *this, color\back, [#__c_frame])
            EndIf
          EndIf
        EndIf
        
        ; draw text items
        If \text\string.s
          ;_content_clip_( *this, [#__c_clip1] )
          ;Debug *this\text\string
          
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          ForEach RowList( *this )
            DrawRotatedText( x + RowList( *this )\x + RowList( *this )\text\x, y + RowList( *this )\y + RowList( *this )\text\y,
                             RowList( *this )\text\String.s, *this\text\rotate, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] ) ; RowList( *this )\color\font )
            
            If *this\mode\lines
              Protected i, count = Bool( func::GetFontSize( RowList( *this )\text\fontID ) > 13 )
              For i=0 To count
                Line( x + RowList( *this )\x + RowList( *this )\text\x, y + RowList( *this )\y + RowList( *this )\text\y + RowList( *this )\text\height - count + i - 1, RowList( *this )\text\width,1, *this\color\front[Bool( *this\__state & #__ss_front ) * *this\color\state] )
              Next
            EndIf
            
          Next 
          
          ;_content_clip_( *this, [#__c_clip] )
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
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( \image\id, x + \image\x, y + \image\y, \color\_alpha )
        EndIf
        
        ; defaul focus widget frame draw
        If *this\flag & #__button_default
          DrawingMode_( #PB_2DDrawing_Outlined )
          ;; DrawRoundBox_( \x[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\width[#__c_inner]-4+2,\height[#__c_inner]-4+2,\round,\round,*this\color\frame[1] )
          If \round 
            DrawRoundBox_( \x[#__c_inner]+2,\Y[#__c_inner]+2-1,\width[#__c_inner]-4,\height[#__c_inner]-4+2,\round,\round,*this\color\frame[1] ) 
          EndIf
          DrawRoundBox_( \x[#__c_inner]+2,\Y[#__c_inner]+2,\width[#__c_inner]-4,\height[#__c_inner]-4,\round,\round,*this\color\frame[1] )
        EndIf
        
        ; area scrollbars draw 
        bar_area_draw_( *this )
        
        ; frame draw
        If *this\fs
          DrawingMode_( #PB_2DDrawing_Outlined )
          draw_box_( *this, color\frame, [#__c_frame])
        EndIf
      EndWith
    EndProcedure
    
    Procedure   draw_Container1( *this._S_widget )
      With *this
        ;
        _content_clip_( *this, [#__c_clip2] )
        
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ;DrawRoundBox_( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;DrawRoundBox_( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        DrawRoundBox_( *this\x[#__c_inner],*this\y[#__c_inner],*this\width[#__c_inner],*this\height[#__c_inner], *this\round, *this\round, *this\color\back[*this\color\state] )
        
        
        If \image\id Or *this\image[#__img_background]\id
          If *this\image\change <> 0
            set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\image\change = 0
          EndIf
          
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          
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
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_inner] + scroll_x_( *this ) + \text\x, 
                    *this\y[#__c_inner] + scroll_y_( *this ) + \text\y, 
                    \text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
        EndIf
        
        ;
        _content_clip_( *this, [#__c_clip] )
        
        ; area scrollbars draw 
        bar_area_draw_( *this )
        
        If *this\fs
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          Protected i
          For i=0 To *this\fs
            DrawRoundBox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            If i<*this\fs
              DrawRoundBox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i+1,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2-2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            EndIf
          Next
        EndIf
        
        
      EndWith
    EndProcedure
    Procedure   draw_Container( *this._S_widget )
      With *this
        
        If *this\fs
          DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          Protected i
          For i=0 To *this\fs
            DrawRoundBox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            If i<*this\fs
              DrawRoundBox_( *this\x[#__c_frame]+i,*this\y[#__c_frame]+i+1,*this\width[#__c_frame]-i*2,*this\height[#__c_frame]-i*2-2, *this\round, *this\round, *this\color\frame[*this\color\state] )
            EndIf
          Next
        EndIf
        
        ; area scrollbars draw 
        bar_area_draw_( *this )
        ;
        _content_clip2_( *this, [#__c_clip] ) ;2
        
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        ;DrawRoundBox_( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;DrawRoundBox_( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        DrawRoundBox_( *this\x[#__c_inner],*this\y[#__c_inner],*this\width[#__c_inner],*this\height[#__c_inner], *this\round, *this\round, *this\color\back[*this\color\state] )
        
        
        If \image\id Or *this\image[#__img_background]\id
          If *this\image\change <> 0
            set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\image\change = 0
          EndIf
          
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          
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
          DrawingModeAlpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_inner] + scroll_x_( *this ) + \text\x, 
                    *this\y[#__c_inner] + scroll_y_( *this ) + \text\y, 
                    \text\string, \color\front[\color\state]&$FFFFFF | \color\_alpha<<24 )
        EndIf
        
        
        
      EndWith
    EndProcedure
    
    Macro draw_clip_frame_( _this_ )
      ;         ; TEST  
      ;         If test_draw_box_clip_type = #PB_All Or 
      ;            test_draw_box_clip_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff0000ff )
      ;         EndIf
      ;         
      ;         If test_draw_box_clip1_type = #PB_All Or 
      ;            test_draw_box_clip1_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_clip1], *this\y[#__c_clip1], *this\width[#__c_clip1], *this\height[#__c_clip1], $ffff0000 )
      ;         EndIf
      ;         
      ;         If test_draw_box_clip2_type = #PB_All Or 
      ;            test_draw_box_clip2_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_clip2], *this\y[#__c_clip2], *this\width[#__c_clip2], *this\height[#__c_clip2], $ff00ff00 )
      ;         EndIf
      ;         
      ;         If test_draw_box_screen_type = #PB_All Or 
      ;            test_draw_box_screen_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_screen], *this\y[#__c_screen], *this\width[#__c_screen], *this\height[#__c_screen], $ff0000ff )
      ;         EndIf
      ;         
      ;         If test_draw_box_frame_type = #PB_All Or 
      ;            test_draw_box_frame_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff00ff00 )
      ;         EndIf
      ;         
      ;         If test_draw_box_inner_type = #PB_All Or 
      ;            test_draw_box_inner_type = *this\type
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;          DrawBox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff0000 )
      ;         EndIf
      ;         
      ;         
      ;         If *this\parent\widget
      ;           If test_draw_box_clip2_type = *this\parent\widget\type
      ;             DrawingMode_( #PB_2DDrawing_Outlined )
      ;            DrawBox_( *this\parent\widget\x[#__c_clip2], *this\parent\widget\y[#__c_clip2], *this\parent\widget\width[#__c_clip2], *this\parent\widget\height[#__c_clip2], $ff00ff00 )
      ;           EndIf
      ;           If test_draw_box_inner_type = *this\parent\widget\type
      ;             DrawingMode_( #PB_2DDrawing_Outlined )
      ;            DrawBox_( *this\parent\widget\x[#__c_inner], *this\parent\widget\y[#__c_inner], *this\parent\widget\width[#__c_inner], *this\parent\widget\height[#__c_inner], $ffff0000 )
      ;           EndIf
      ;         EndIf
      ;         ; ENDTEST
      
      
    EndMacro
    
    ;-
    Macro DrawFirst( _this_ )
      ; limit drawing boundaries
      _content_clip2_( _this_, [#__c_clip] )
      
      ; draw widgets
      Select _this_\type
        Case #__type_Window         : Window_Draw( _this_ )
        Case #__type_MDI            : draw_Container( _this_ )
        Case #__type_Container      : draw_Container( _this_ )
        Case #__type_ScrollArea     : draw_Container( _this_ )
        Case #__type_Image          : draw_Container( _this_ )
          
          ;- widget::_draw_Panel( )
        Case #__type_Panel         
          ;             If _this_\tab\widget And _this_\tab\widget\count\items
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawBox_( _this_\x[#__c_inner], _this_\y[#__c_inner], _this_\width[#__c_inner], _this_\height[#__c_inner], _this_\color\back[0] )
          
          If _this_\fs > 1
            DrawRoundBox_( \x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\fs-1, _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            DrawRoundBox_( \x[#__c_frame], _this_\y[#__c_frame], _this_\fs-1, _this_\height[#__c_frame], _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            DrawRoundBox_( \x[#__c_frame] + _this_\width[#__c_frame] - _this_\fs+1, _this_\y[#__c_frame], _this_\fs-1, _this_\height[#__c_frame], _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
            DrawRoundBox_( \x[#__c_frame], _this_\y[#__c_frame]+_this_\height[#__c_frame] - _this_\fs+1, _this_\width[#__c_frame], _this_\fs-1, _this_\round,_this_\round, _this_\color\frame[_this_\color\state] )
          EndIf
          
          ;             Else
          ;               DrawingModeAlpha_( #PB_2DDrawing_Default )
          ;              DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\color\back[0] )
          ;               
          ;               DrawingModeAlpha_( #PB_2DDrawing_Outlined )
          ;              DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\color\frame[Bool( FocusedTabindex( _this_\tab\widget ) <>- 1 )*2 ] )
          ;             EndIf
          
          ;- widget::_draw_String( )
        Case #__type_String         : Editor_Draw( _this_ )
          
          If _this_\scroll\v And _this_\scroll\h
            DrawingModeAlpha_( #PB_2DDrawing_Outlined )
            ; Scroll area coordinate
            DrawBox_(_this_\scroll\h\x + _this_\scroll\x, _this_\scroll\v\y + _this_\scroll\y, _this_\scroll\width, _this_\scroll\height, $FF0000FF)
            
            ; Debug ""+ _this_\scroll\x +" "+ _this_\scroll\y +" "+ _this_\scroll\width +" "+ _this_\scroll\height
            DrawBox_(_this_\scroll\h\x - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FFFF0000)
            
            ; page coordinate
            DrawBox_(_this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
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
            DrawingModeAlpha_( #PB_2DDrawing_Default )
            DrawBox_( _this_\x[#__c_inner], _this_\y[#__c_frame] + _this_\fs, _this_\width[#__c_inner], _this_\barheight, $ffffffff )
          Else
            DrawingModeAlpha_( #PB_2DDrawing_Gradient )
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
            DrawingModeAlpha_( #PB_2DDrawing_Transparent )
            DrawText( _this_\x[#__c_frame] + _this_\text\x, 
                      _this_\y[#__c_frame] + _this_\text\y, 
                      _this_\text\string, _this_\color\front[_this_\color\state]&$FFFFFF | _this_\color\_alpha<<24 )
          EndIf
          
          ;
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          If arrow_right
            Arrow( _this_\_box_\x + ( _this_\_box_\width - _this_\_box_\arrow\size*2 - 4 ),
                   _this_\_box_\y + ( _this_\_box_\height - _this_\_box_\arrow\size )/2, _this_\_box_\arrow\size, _this_\_box_\arrow\direction, 
                   _this_\_box_\color\front[_this_\_box_\color\state]&$FFFFFF | _this_\_box_\color\_alpha<<24, _this_\_box_\arrow\type )
          Else
            draw_arrows_( _this_\_box_, _this_\_box_\arrow\direction ) 
          EndIf
          
          
          ; Draw combo-popup-menu backcolor
          DrawingModeAlpha_( #PB_2DDrawing_Default )
          DrawBox_( _this_\x[#__c_inner], _this_\y[#__c_inner], _this_\width[#__c_inner], _this_\height[#__c_inner], $ffffffff )
          
          ; Draw combo-popup-menu all rows
          draw_items_( _this_, VisibleRowList( _this_ ), _this_\scroll\h\bar\page\pos, _this_\scroll\v\bar\page\pos )
          
          ; frame draw
          If _this_\fs
            DrawingMode_( #PB_2DDrawing_Outlined )
            DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\barheight, _this_\color\frame[_this_\color\state] )
            DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_inner]-1, _this_\width[#__c_frame], _this_\height[#__c_inner]+2, _this_\color\frame[_this_\color\state] )
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
      If _this_\tab\widget And _this_\tab\widget\count\items
        bar_tab_draw( _this_\tab\widget ) 
      EndIf
      
      ; draw disable state
      If _this_\state\flag & #__S_disable
        DrawingModeAlpha_( #PB_2DDrawing_Default )
        DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $80f0f0f0 )
      EndIf
      
      ; draw drag & drop
      If _this_\state\enter And 
         Not _this_\state\flag & #__S_disable And _DD_drag_( )
        DD_draw( _this_ )
      EndIf
      
    EndMacro
    Macro DrawLast( _this_ )
      _content_clip2_( _this_, [#__c_clip] )
      
      ; draw keyboard focus widget frame
      If _this_\state\focus And _this_\type = #__type_window
        ;         DrawingModeAlpha_( #PB_2DDrawing_Outlined )
        ;         If _this_\round
        ;           RoundBox( _this_\x[#__c_frame]-1, _this_\y[#__c_frame]-1, _this_\width[#__c_frame]+2, _this_\height[#__c_frame]+2, _this_\round, _this_\round, $ffff0000 )
        ;           RoundBox( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], _this_\round, _this_\round, $ffff0000 )
        ;           RoundBox( _this_\x[#__c_frame]+1, _this_\y[#__c_frame]+1, _this_\width[#__c_frame]-2, _this_\height[#__c_frame]-2, _this_\round, _this_\round, $ffff0000 )
        ;         Else
        ;          DrawBox_( _this_\x[#__c_frame]-1, _this_\y[#__c_frame]-1, _this_\width[#__c_frame]+2, _this_\height[#__c_frame]+2, $ffff0000 )
        ;          DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $ffff0000 )
        ;          DrawBox_( _this_\x[#__c_frame]+1, _this_\y[#__c_frame]+1, _this_\width[#__c_frame]-2, _this_\height[#__c_frame]-2, $ffff0000 )
        ;         EndIf
      EndIf
      
      If _this_\_a_\id And a_focus_widget( ) And
         _this_ <> a_focus_widget( )
        a_draw( _this_ )
      EndIf
      
      ;         If _this_\_a_\transform 
      ;           DrawingMode_( #PB_2DDrawing_Outlined )
      ;           
      ;           If _this_\_a_\transform = 2
      ;             _content_clip_( _this_, [#__c_frame] )
      ;             ; draw group transform widgets frame
      ;            DrawBox_( _this_\x[#__c_frame], _this_\y[#__c_frame], _this_\width[#__c_frame], _this_\height[#__c_frame], $ffff00ff )
      ;           Else
      ;             _content_clip_( _this_, [#__c_inner] )
      ;             ; draw clip out transform widgets frame
      ;            DrawBox_( _this_\x[#__c_inner], _this_\y[#__c_inner], _this_\width[#__c_inner], _this_\height[#__c_inner], $ff00ffff )
      ;           EndIf
      ;         EndIf
      
      ;;Debug _this_\class
      Post( _this_, #PB_EventType_Draw ) 
      
    EndMacro
    
    Procedure.b Draw( *this._S_widget )
      Protected arrow_right
      
      With *this
        ; init drawing font
        draw_font_( *this )
        
        ; we call the event dispatched before the binding 
        If *this\event And 
           *this\count\events = 0 ;And ListSize( *this\event\queue( ))
          *this\count\events = 1
          
          ForEach *this\event\queue( )
            Post( *this, *this\event\queue( )\type, *this\event\queue( )\item, *this\event\queue( )\data ) 
          Next
          ; ClearList( *this\event\queue( ))
        EndIf
        
        ; draw belowe drawing
        If Not *this\hide And Reclip( *this )
          DrawFirst( *this )
        EndIf
        
        ;         ; draw above drawing
        ;         If Not *this\last\widget 
        ;           DrawLast( *this )
        ;         EndIf
        ;         If *this\position & #PB_List_Last And *this\parent\widget 
        ;           DrawLast( *this\parent\widget )
        ;         EndIf
        If *this\_a_\id And a_focus_widget( ) And *this <> a_focus_widget( )
          a_draw( *this )
        EndIf
        
        If *this\data And *this\container
          DrawingMode_( #PB_2DDrawing_Transparent )
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
        
        ;         ;
        ;         If *this\event
        ;           If *this\repaint 
        ;             SendEvent( #PB_EventType_Draw, *this )
        ;             
        ;             *this\repaint = #False
        ;           EndIf
        ;         EndIf
        
      EndWith
    EndProcedure
    
    Procedure   ReDraw( *this._S_widget )
      If Drawing( ) = 0
        Drawing( ) = StartDrawing( CanvasOutput( *this\root\canvas\gadget ))
      EndIf
      
      If Drawing( )
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
                   #PB_Compiler_OS = #PB_OS_Windows
          ; difference in system behavior
          If *this\root\canvas\fontID
            DrawingFont( *this\root\canvas\fontID ) 
          EndIf
        CompilerEndIf
        
        ;
        If Not ( transform( ) And transform( )\grab )
          If is_root_(*this )
            ;If *this\root\canvas\repaint = #True
            CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
              ; good transparent canvas
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
            CompilerElse
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
            CompilerEndIf
            ; EndIf
            
            ;
            Reclip( *this\root )
            *this\root\width[#__c_clip] = *this\root\width
            *this\root\height[#__c_clip] = *this\root\height
            
            PushListPosition( Widget( ))
            ForEach Widget( )
              If Widget( )\root\canvas\gadget = *this\root\canvas\gadget
                
                ; begin draw all widgets
                Draw( Widget( ))
                
              EndIf
            Next
            
            ;
            Unclip( )
            
            DrawingMode_( #PB_2DDrawing_Outlined )
            ForEach Widget( )
              If Widget( )\root\canvas\gadget = *this\root\canvas\gadget And 
                 Not ( Widget( )\hide = 0 And Widget( )\width[#__c_clip] > 0 And Widget( )\height[#__c_clip] > 0 )
                
                
                ; draw group transform widgets frame
                ;If Widget( )\_a_\transform = 2
                ; DrawBox_( Widget( )\x[#__c_frame], Widget( )\y[#__c_frame], Widget( )\width[#__c_frame], Widget( )\height[#__c_frame], $ffff00ff )
                ;EndIf
                ;Else
                ; draw clip out transform widgets frame
                ;If Widget( )\_a_\transform 
                If is_parent_( widget( ), widget( )\parent\widget ) And Not Widget( )\parent\widget\hide 
                  DrawBox_( Widget( )\x[#__c_inner], Widget( )\y[#__c_inner], Widget( )\width[#__c_inner], Widget( )\height[#__c_inner], $ff00ffff )
                EndIf
                ;EndIf
              EndIf
            Next
            PopListPosition( Widget( ))
            
          Else
            Draw( *this )
          EndIf
        EndIf
        
        ; draw current popup-widget
        If PopupWidget( ) And PopupWidget( )\root = *this\root
          Draw( PopupWidget( ) )
          ;Tree_Draw( PopupWidget( ), VisibleRowList( PopupWidget( ) ))
          
        EndIf
        
        
        ; draw movable-sizable anchors
        If transform( )
          If a_focus_widget( ) And a_focus_widget( )\_a_\id And 
             a_focus_widget( )\root\canvas\gadget = *this\root\canvas\gadget 
            
            ; draw mouse selected widget anchors
            _content_clip_( transform( )\main, [#__c_clip2] )
            a_draw_box( a_focus_widget( )\_a_\id )
          EndIf
          
          If transform( ) And a_focus_widget( ) And 
             a_focus_widget( )\root\canvas\gadget = *this\root\canvas\gadget 
            
            ; draw mouse selected widget anchors
            _content_clip_( transform( )\main, [#__c_clip2] )
            a_draw_box( transform( )\id )
          EndIf
        EndIf
        
        ; reset
        If *this\root\canvas\postevent <> #False
          *this\root\canvas\postevent = #False
        EndIf
        
        ; Post( *this\root, #PB_EventType_Repaint ) 
        
        Drawing( ) = 0
        StopDrawing( )
      EndIf
    EndProcedure
    
    ;-
    Procedure.i Post( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      Protected result
      
      If *this = #PB_All
        ; 4)
      Else
        
        If WidgetEvent( )\back
          
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
                  
                  WidgetEvent( )\back = *this\event\call( )\back
                  
                  result = WidgetEvent( )\back( )
                  
                  If result
                    Break 
                  EndIf
                EndIf
              Next
            EndIf
            
            ;             ; second call current-widget-window bind event function
            ;             If result <> #PB_Ignore And
            ;                Not is_window_( *this ) And 
            ;                Not is_root_(*this\window ) And *this\window\event
            ;               
            ;               ForEach *this\window\event\call( )
            ;                 If *this\window\event\call( )\type = #PB_All Or  
            ;                    *this\window\event\call( )\type = eventtype
            ;                   
            ;                   WidgetEvent( )\back = *this\window\event\call( )\back
            ;                   
            ;                   result = WidgetEvent( )\back( )
            ;                   
            ;                   If result
            ;                     Break 
            ;                   EndIf
            ;                 EndIf
            ;               Next
            ;             EndIf
          EndIf
          
          ;           ; theard call current-widget-root bind event function
          ;           If result <> #PB_Ignore And *this\root\event
          ;             
          ;             ForEach *this\root\event\call( )
          ;               If *this\root\event\call( )\type = #PB_All Or  
          ;                  *this\root\event\call( )\type = eventtype
          ;                 
          ;                 WidgetEvent( )\back = *this\root\event\call( )\back
          ;                 
          ;                 result = WidgetEvent( )\back( )
          ;                 
          ;                 If result
          ;                   Break 
          ;                 EndIf
          ;               EndIf
          ;             Next
          ;           EndIf
          
          EventWidget( ) = #Null
          WidgetEvent( )\type = #PB_All
          WidgetEvent( )\item = #PB_All
          WidgetEvent( )\data = #Null
          
          
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
      If *this = #PB_All
        ; 4)
      Else
        If Not *this\event
          *this\event.allocate( EVENT )
        EndIf
        
        ; is bind event callback
        ForEach *this\event\call( )
          If *this\event\call( )\back = *callback And 
             *this\event\call( )\type = eventtype And 
             *this\event\call( )\item = item
            ProcedureReturn *this\event\call( )
          EndIf
        Next
        
        LastElement( *this\event\call( ))
        AddElement( *this\event\call( ))
        *this\event\call.allocate( EVENTDATA, ( )) 
        *this\event\call( )\back = *callback
        *this\event\call( )\type = eventtype
        *this\event\call( )\item = item
      EndIf
    EndProcedure
    
    Procedure.i Unbind( *this._S_widget, *callback, eventtype.l = #PB_All, item.l = #PB_All )
      If *this = #PB_All
        ; 4)
      Else
        If *this\event
          ForEach *this\event\call( )
            If *this\event\call( )\back = *callback And 
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
    Procedure DoEventItems( *this._S_widget, eventtype.l, *row._S_rows, *data )
      Static redraw.b
      ; Debug "DoEventItems "+ *row\index +" "+ eventtype +" "+ *data
      If eventtype = #PB_EventType_Repaint
        If *data = 1
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            redraw = StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
          CompilerEndIf
        EndIf
        If *data =- 1
          *this\state\repaint = edit_sel_text_( *this, *row )
          
          If redraw
            redraw = 0
            StopDrawing( )
          EndIf
        EndIf
      Else
        If redraw
          DrawingFont( *row\text\fontid )
        EndIf
        *this\state\repaint = edit_sel_row_text_( *this, *row, *data )
      EndIf
    EndProcedure
    
    Procedure GetAtPointItems( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected repaint
      
      If *this\row
        mouse_x = Mouse( )\x - *this\x[#__c_inner] ; - scroll_x_( *this ) 
        mouse_y = Mouse( )\y - *this\y[#__c_inner] - scroll_y_( *this ) 
      EndIf
      
      If *this\bar
        mouse_x = Mouse( )\x - *this\bar\button[#__b_3]\x
        mouse_y = Mouse( )\y - *this\bar\button[#__b_3]\y
      EndIf
      
      ;
      ;
      If eventtype = #PB_EventType_MouseLeave 
        ; reset entered button
        EnteredButton( ) = #Null
        
        If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
          EnteredTabindex( *this ) =- 1
          EnteredTab( *this ) = #Null
        EndIf
        
      EndIf
      
      ; at point row
      If eventtype = #PB_EventType_MouseEnter Or
         eventtype = #PB_EventType_MouseWheelY Or
         eventtype = #PB_EventType_LeftButtonDown Or
         eventtype = #PB_EventType_LeftButtonUp Or
         eventtype = #PB_EventType_MouseLeave Or 
         eventtype = #PB_EventType_MouseMove
        
        ;
        ; get at-point-item address
        If *this\row  
          ;
          If *this\state\drag And eventtype = #PB_EventType_MouseMove
            If PressedRow( *this ) And EnteredRow( *this ) And edit_caret_pos_delta_( *this ) >= 0 
              edit_sel_pos( *this, EnteredRow( *this ), PressedRow( *this ), - 1 )
            EndIf
          EndIf
          
          If Not *this\state\drag And
             ListSize( VisibleRowList( *this ) ) 
            If Not ( EnteredRow( *this ) And 
                     EnteredRow( *this )\visible And 
                     EnteredRow( *this )\hide = 0 And 
                     is_at_point_( EnteredRow( *this ), mouse_x, mouse_y)) Or eventtype = #PB_EventType_MouseLeave
              
              ; reset entered item
              EnteredRow( *this ) = #Null
              
              ; search entered item
              If eventtype <> #PB_EventType_MouseLeave 
                LastElement( VisibleRowList( *this )) 
                Repeat                                 
                  If VisibleRowList( *this )\visible And 
                     VisibleRowList( *this )\hide = 0 And 
                     is_at_point_( VisibleRowList( *this ), mouse_x, mouse_y )
                    EnteredRow( *this ) = VisibleRowList( *this ) 
                    Break
                  EndIf
                Until PreviousElement( VisibleRowList( *this )) = #False 
              EndIf
            EndIf
          Else
            If ListSize( RowList( *this ) ) 
              If Not ( EnteredRow( *this ) And 
                       EnteredRow( *this )\hide = 0 And 
                       is_at_point_( EnteredRow( *this ), mouse_x, mouse_y ))
                
                ; reset not pressed-entered item
                If EnteredRow( *this )
                  LeavedRow( *this ) = EnteredRow( *this )
                  EnteredRow( *this ) = #Null
                EndIf
                
                ; search presed-entered item
                LastElement( RowList( *this )) 
                Repeat  
                  If RowList( *this )\hide = 0 And 
                     is_at_point_( RowList( *this ), mouse_x, mouse_y )
                    EnteredRow( *this ) = RowList( *this ) 
                    EnteredRow( *this )\state\enter = #True
                    
                    If *this\state\drag
                      If EnteredRow( *this )\index >= PressedRow( *this )\index
                        If *this\x[#__c_inner] + *this\text\caret\x + scroll_x_( *this ) - *this\mode\fullselection <= Mouse( )\x
                          DoEventItems( *this, #PB_EventType_Repaint, EnteredRow( *this ), 1 )
                          DoEventItems( *this, #PB_EventType_MouseEnter, EnteredRow( *this ), 0 )
                          DoEventItems( *this, #PB_EventType_Repaint, EnteredRow( *this ), - 1 )
                        EndIf
                      EndIf
                    EndIf
                    
                    Break
                  EndIf
                Until PreviousElement( RowList( *this )) = #False 
                
                If LeavedRow( *this ) And
                   LeavedRow( *this ) <> EnteredRow( *this ) And
                   LeavedRow( *this )\state\enter
                  LeavedRow( *this )\state\enter = #False
                  
                  If *this\state\drag
                    If Mouse( )\y >= row_y_( *this, LeavedRow( *this )) + LeavedRow( *this )\height - *this\scroll\v\bar\page\pos 
                      DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), 1 )
                      If PressedRow( *this )\index > LeavedRow( *this )\index
                        DoEventItems( *this, #PB_EventType_MouseLeave, LeavedRow( *this ), - 14 )
                        
                        If *this\text\multiline And LeavedRow( *this )\index < *this\count\items - 1
                          FocusedRow( *this ) = SelectElement( RowList( *this ), LeavedRow( *this )\index + 1 )
                          edit_caret_pos_( *this ) = RowList( *this )\text\pos 
                          
                          DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), 0 )
                          DoEventItems( *this, #PB_EventType_Repaint, RowList( *this ), - 1 )
                        Else
                          DoEventItems( *this, #PB_EventType_Repaint, LeavedRow( *this ), - 1 )
                        EndIf
                      Else
                        DoEventItems( *this, #PB_EventType_MouseLeave, LeavedRow( *this ), - 10 )
                        DoEventItems( *this, #PB_EventType_Repaint, LeavedRow( *this ), - 1 )
                      EndIf
                    Else
                      DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), 1 )
                      If PressedRow( *this )\index < LeavedRow( *this )\index
                        DoEventItems( *this, #PB_EventType_MouseLeave, LeavedRow( *this ), - 14 )
                      Else
                        DoEventItems( *this, #PB_EventType_MouseLeave, LeavedRow( *this ), - 9 )
                      EndIf
                      DoEventItems( *this, #PB_EventType_Repaint, LeavedRow( *this ), - 1 )
                    EndIf
                  EndIf
                  
                EndIf
              EndIf
            EndIf
          EndIf
          
          
          
          ; Debug EnteredRow( *this )
        EndIf
        ;
        ; get at-point-tab address
        If *this\bar
          If *this\count\items And is_at_point_( *this, Mouse( )\x, Mouse( )\y, [#__c_inner] )
            ; splitter хурмит
            If ListSize( TabList( *this ))
              ForEach TabList( *this )
                ; If TabList( *this )\visible
                If is_at_point_( TabList( *this ), mouse_x, mouse_y )
                  If EnteredTabindex( *this ) <> TabList( *this )\index
                    If EnteredTabindex( *this ) >= 0
                      Debug " leave tab - " + EnteredTabindex( *this )
                      Repaint | #True
                    EndIf
                    
                    EnteredTabindex( *this ) = TabList( *this )\index
                    Debug " enter tab - " + EnteredTabindex( *this )
                    EnteredTab( *this ) = TabList( *this )
                    Repaint | #True
                  EndIf
                  Break
                  
                ElseIf EnteredTabindex( *this ) = TabList( *this )\index
                  Debug " -leave tab - " + EnteredTabindex( *this )
                  EnteredTabindex( *this ) =- 1
                  EnteredTab( *this ) = #Null
                  Repaint | #True
                  Break
                EndIf
                ; EndIf
              Next
            EndIf
          ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
            If EnteredTabindex( *this ) <> - 1
              EnteredTabindex( *this ) = - 1
              EnteredTab( *this ) = #Null
            EndIf
          EndIf
        EndIf
        
        ;
        ; get at-point-button address
        If *this\bar
          If Not ( EnteredButton( ) And 
                   is_at_point_( EnteredButton( ), Mouse( )\x, Mouse( )\y ) And 
                   is_at_point_( *this, Mouse( )\x, Mouse( )\y, [#__c_inner] ))
            
            ; reset entered button
            EnteredButton( ) = #Null
            
            ; search entered button
            If *this\bar\button[#__b_1]\interact And 
               is_at_point_( *this\bar\button[#__b_1], Mouse( )\x, Mouse( )\y )
              
              If EnteredButton( ) <> *this\bar\button[#__b_1]
                EnteredButton( ) = *this\bar\button[#__b_1]
              EndIf
            ElseIf *this\bar\button[#__b_2]\interact And
                   is_at_point_( *this\bar\button[#__b_2], Mouse( )\x, Mouse( )\y )
              
              If EnteredButton( ) <> *this\bar\button[#__b_2]
                EnteredButton( ) = *this\bar\button[#__b_2]
              EndIf
            ElseIf *this\bar\button[#__b_3]\interact And
                   is_at_point_( *this, Mouse( )\x, Mouse( )\y, [#__c_inner] ) And
                   is_at_point_( *this\bar\button[#__b_3], Mouse( )\x, Mouse( )\y, )
              
              If EnteredButton( ) <> *this\bar\button[#__b_3]
                EnteredButton( ) = *this\bar\button[#__b_3]
              EndIf
            EndIf
          EndIf
        EndIf
        
        
        ; do items events entered & leaved & focused
        If *this\row
          ;
          If eventtype = #PB_EventType_LeftButtonDown
            If EnteredRow( *this ) 
              EnteredRow( *this )\state\press = #True
              PressedRow( *this ) = EnteredRow( *this )
              
              ; reset items select
              If FocusedRow( *this )
                ForEach RowList( *this ) 
                  If EnteredRow( *this ) <> RowList( *this )
                    If RowList( *this )\state\focus = #True
                      RowList( *this )\state\focus = #False
                      RowList( *this )\color\state = #__S_0
                      ; DoEvents( *this, #PB_EventType_StatusChange, RowList( *this )\index, RowList( *this ) )
                    EndIf
                    If RowList( *this )\text\edit[2]\width <> 0 
                      ; Debug " remove - " +" "+ RowList( *this )\text\string
                      edit_sel_row_text_( *this, RowList( *this ), -6 )
                    EndIf
                  EndIf
                Next
              EndIf
              
              If EnteredRow( *this )\state\focus = #False
                EnteredRow( *this )\state\focus = #True
                
                FocusedRow( *this ) = EnteredRow( *this )
                If is_list_gadget_( *this ) 
                  DoEvents( *this, #PB_EventType_StatusChange, EnteredRow( *this )\index, EnteredRow( *this ) )
                EndIf
              EndIf
            EndIf
          EndIf  
          
          ;
          If eventtype = #PB_EventType_LeftButtonUp
            If PressedRow( *this ) 
              If PressedRow( *this )\state\press
                PressedRow( *this )\state\press = #False
                
                ; DoEvents( *this, #PB_EventType_StatusChange, PressedRow( *this )\index, PressedRow( *this ) )
              EndIf
              
              PressedRow( *this ) = #Null
            EndIf
          EndIf  
          
        EndIf
        
        ; do buttons events entered & leaved 
        If LeavedButton( ) <> EnteredButton( ) 
          
          If LeavedButton( ) And
             LeavedButton( )\state\enter
            LeavedButton( )\state\enter = #False
            
            If is_current_( EnteredWidget( )) 
              If LeavedButton( )\color\state = #__S_1
                LeavedButton( )\color\state = #__S_0
                
                ; for the splitter thumb
                If LeavedWidget( ) And 
                   LeavedWidget( )\type = #__type_Splitter And 
                   LeavedWidget( )\bar\button[#__b_3] = LeavedButton( ) And 
                   LeavedWidget( )\bar\button[#__b_2]\size <> $ffffff
                  
                  _cursor_remove_( LeavedWidget( ))
                EndIf
                
                repaint = #True
              EndIf
            EndIf
          EndIf
          
          If EnteredButton( ) And 
             EnteredButton( )\state\enter = #False
            EnteredButton( )\state\enter = #True
            
            If is_current_( EnteredWidget( ))
              ; draw item color state entered
              If EnteredButton( )\color\state = #__S_0
                If Not ( EnteredWidget( )\type = #__type_TrackBar Or 
                         ( EnteredWidget( )\type = #__type_Splitter And 
                           EnteredWidget( )\bar\button[#__b_3] <> EnteredButton( ) ))
                  
                  EnteredButton( )\color\state = #__S_1
                  
                  ; for the splitter thumb
                  If EnteredWidget( )\type = #__type_Splitter And 
                     EnteredWidget( )\bar\button[#__b_3] = EnteredButton( ) And 
                     EnteredWidget( )\bar\button[#__b_2]\size <> $ffffff
                    
                    _cursor_set_( EnteredWidget( ))
                  EndIf
                  
                  repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
          
          LeavedButton( ) = EnteredButton( )
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
        If *this\root <> Root( )
          Mouse( )\x = CanvasMouseX( *this\root\canvas\gadget )
          Mouse( )\y = CanvasMouseY( *this\root\canvas\gadget )
        EndIf
        
        If Not is_at_point_y_( *this, Mouse( )\y, [#__c_inner] ) And *this\scroll\v
          If Mouse( )\y < Mouse( )\delta\y
            If Not bar_in_start_( *this\scroll\v\bar )
              scroll_y = Mouse( )\y - ( *this\y[#__c_inner] )
              bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + scroll_y )
              Editor_Update( *this, RowList( *this ))
              ReDraw(   *this\root ) 
              Debug "scroll v top " + scroll_y +" "+ VisibleFirstRow( *this )\index
              
            Else
              ; Debug "scroll v stop top"
            EndIf
          ElseIf Mouse( )\y > Mouse( )\delta\y
            If Not bar_in_stop_( *this\scroll\v\bar )
              scroll_y = 400;Mouse( )\y - ( *this\y[#__c_inner] + *this\height[#__c_inner] )
                            ;bar_SetState( *this\scroll\v\bar, *this\scroll\v\bar\page\pos + scroll_y )
                            ;Editor_Update( *this, RowList( *this ))
                            ;ReDraw(   *this\root ) 
              Debug "scroll v bottom "+ scroll_y +" "+ VisibleLastRow( *this )\index
              
              ;               If FocusedRow( *this ) <> VisibleLastRow( *this )
              ;                 ;                 If EnteredRow( *this )
              ;                 ;                   EnteredRow( *this )\state\enter = 0
              ;                 ;                   EnteredRow( *this )\color\state = 0
              ;                 ;                 EndIf
              ;                 ;                 EnteredRow( *this ) = VisibleLastRow( *this )
              ;                 ;                 EnteredRow( *this )\state\enter = 1
              ;                 ;                 EnteredRow( *this )\color\state = 1
              ;                 
              ;                 If FocusedRow( *this )
              ;                   ; Debug "scroll v bottom "+ scroll_y +" "+ VisibleLastRow( *this )\index +" "+ FocusedRow( *this )\index
              ;                   FocusedRow( *this )\state\focus = 0
              ;                   FocusedRow( *this )\color\state = 0
              ;                 EndIf
              ;                 
              ;                 ; edit_sel__( *this, VisibleLastRow( *this ), PressedRow( *this ), FocusedRow( *this ), 0, FocusedRow( *this )\text\len )
              ;                 FocusedRow( *this ) = VisibleLastRow( *this )
              ;                 ;FocusedRow( *this ) = SelectElement( RowList( *this ), VisibleLastRow( *this )\index )
              ;                 FocusedRow( *this )\state\focus = 1
              ;                 FocusedRow( *this )\color\state = 1
              ;                 FocusedRow( *this )\state\repaint = 1
              ;                 
              ;                 Debug FocusedRow( *this )\index
              ;                 edit_set_sel_( *this, FocusedRow( *this ), PressedRow( *this ) )
              ;                 
              ;                 *this\state\repaint = 1
              ;               EndIf             
              
              ;                 result = 1
            Else
              ; Debug "scroll v stop bottom"
            EndIf
          EndIf
        EndIf
        
        If Not is_at_point_x_( *this, Mouse( )\x, [#__c_inner] ) And *this\scroll\h
          If Mouse( )\x < Mouse( )\delta\x
            If Not bar_in_start_( *this\scroll\h\bar )
              scroll_x = Mouse( )\x - ( *this\x[#__c_inner] )
              Debug "scroll h top " + scroll_x
              bar_SetState( *this\scroll\h\bar, *this\scroll\h\bar\page\pos + scroll_x )
              result = 1
            Else
              ; Debug "scroll h stop top"
            EndIf
          ElseIf Mouse( )\x > Mouse( )\delta\x
            If Not bar_in_stop_( *this\scroll\h\bar )
              scroll_x = Mouse( )\x - ( *this\x[#__c_inner] + *this\height[#__c_inner] )
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
          ;           ReDraw(   *this\root ) 
          ;           PostEventRepaint( *this\root )
          ;           DoEvents( *this, #PB_EventType_StatusChange, #PB_All, #Null )
        EndIf 
      EndIf
      
    EndProcedure
    
    Procedure _DoEvents( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      Protected Repaint, mouse_x.l = Mouse( )\x, mouse_y.l = Mouse( )\y, _wheel_x_.b = 0, _wheel_y_.b = 0
      Protected *item._S_rows
      
      *this\events\type = eventtype
      *this\events\item = *button
      *this\events\data = *data
      
      If *this\state\drag ; Or eventtype = #PB_EventType_LeftButtonUp \focus
        If eventtype = #PB_EventType_LeftButtonUp Or
           eventtype = #PB_EventType_MouseEnter Or
           eventtype = #PB_EventType_MouseLeave Or
           eventtype = #PB_EventType_MouseMove
          
          ;If bar_in_stop_( *this\scroll\v\bar ) Or bar_in_start_( *this\scroll\v\bar )
          If eventtype = #PB_EventType_LeftButtonUp Or
             is_at_point_( *this, Mouse( )\x, Mouse( )\y, [#__c_inner] )
            
            If *this\state\press =- 1
              *this\state\press = 1
              
              If *this\row
                
                Debug "stop timer - " + EnteredRow( *this )
                ;                 UnbindEvent( #PB_Event_Timer, @Row_timer_events( ), *this\root\canvas\window );, *this\root\canvas\gadget )
                ;                 RemoveWindowTimer( *this\root\canvas\window, 99 )
                
                If PressedRow( *this )
                  ChangeCurrentElement( RowList( *this ), PressedRow( *this ) )
                  DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), 1 )
                  
                  If Mouse( )\y < row_y_( *this, PressedRow( *this )) + PressedRow( *this )\height - *this\scroll\v\bar\page\pos 
                    LastElement( RowList( *this ) )
                    Repeat
                      If RowList( *this )\index > PressedRow( *this )\index Or 
                         Mouse( )\y >= row_y_( *this, RowList( *this )) + RowList( *this )\height - *this\scroll\v\bar\page\pos 
                        If RowList( *this )\text\edit[2]\width <> 0
                          If RowList( *this )\state\enter
                            RowList( *this )\state\enter = #False
                          EndIf
                          DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 14 )
                        EndIf
                      Else
                        If Not EnteredRow( *this )
                          If RowList( *this )\state\enter
                            RowList( *this )\state\enter = #False
                          EndIf
                          FocusedRow( *this ) = RowList( *this )
                          DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 9 )
                        EndIf
                      EndIf
                    Until Not PreviousElement( RowList( *this ) )
                    
                  Else
                    ForEach RowList( *this )
                      If RowList( *this )\index < PressedRow( *this )\index Or 
                         Mouse( )\y <= row_y_( *this, RowList( *this )) - *this\scroll\v\bar\page\pos 
                        If RowList( *this )\text\edit[2]\width <> 0
                          If RowList( *this )\state\enter
                            RowList( *this )\state\enter = #False
                          EndIf
                          DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 14 )
                        EndIf
                      Else
                        If Not EnteredRow( *this )
                          If RowList( *this )\state\enter
                            RowList( *this )\state\enter = #False
                          EndIf
                          FocusedRow( *this ) = RowList( *this )
                          DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 10 )
                        EndIf
                      EndIf
                    Next
                  EndIf
                  
                  DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), - 1 )
                EndIf
                
              EndIf
            EndIf
          Else
            If *this\state\press = 1
              *this\state\press =- 1
              
              If *this\row
                
                Debug "start timer - " ; +LeavedRow( *this )\index +" "+ EnteredRow( *this )
                                       ;                 AddWindowTimer( *this\root\canvas\window, 99, 100 )
                                       ;                 BindEvent( #PB_Event_Timer, @Row_timer_events( ), *this\root\canvas\window );, *this\root\canvas\gadget )
                
                ;
                If PressedRow( *this )
                  ChangeCurrentElement( RowList( *this ), PressedRow( *this ) )
                  DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), 1 )
                  
                  If Mouse( )\y < row_y_( *this, PressedRow( *this )) + PressedRow( *this )\height - *this\scroll\v\bar\page\pos 
                    While PreviousElement( RowList( *this ) )
                      If RowList( *this )\state\enter
                        RowList( *this )\state\enter = #False
                      EndIf
                      If RowList( *this )\text\edit[2]\width = 0
                        DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 9 )
                      EndIf
                    Wend
                  Else
                    While NextElement( RowList( *this ) )
                      If RowList( *this )\state\enter
                        RowList( *this )\state\enter = #False
                      EndIf
                      If RowList( *this )\text\edit[2]\width = 0
                        DoEventItems( *this, #PB_EventType_MouseLeave, RowList( *this ), - 10 )
                      EndIf
                    Wend
                  EndIf
                  
                  FocusedRow( *this ) = RowList( *this )
                  DoEventItems( *this, #PB_EventType_Repaint, FocusedRow( *this ), - 1 )
                EndIf
              EndIf
              
            EndIf
          EndIf
          
        EndIf
      EndIf
      
      ;       If eventtype = #PB_EventType_LeftButtonUp
      ;         Debug *this\text\edit[2]\string
      ;       EndIf
      
      ; mouse position inside widget 
      Select eventtype
        Case #PB_EventType_MouseMove,
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave
          
          If *this\state\enter = 1
            If *this\scroll\h
              Mouse( )\x[#__c_inner] = Mouse( )\x - *this\x[#__c_inner]    + *this\scroll\h\bar\page\pos
            Else
              Mouse( )\x[#__c_inner] = Mouse( )\x - *this\x[#__c_inner]
            EndIf
            If *this\scroll\v
              Mouse( )\y[#__c_inner] = Mouse( )\y - *this\y[#__c_inner]    + *this\scroll\v\bar\page\pos   
            Else
              Mouse( )\y[#__c_inner] = Mouse( )\y - *this\y[#__c_inner]
            EndIf
          Else
            Mouse( )\x[#__c_inner] =- 1
            Mouse( )\y[#__c_inner] =- 1
          EndIf 
      EndSelect
      
      ;       If eventtype = #PB_EventType_StatusChange
      ;         Debug Mouse( )\y[#__c_inner]
      ;       EndIf
      
      Select eventtype
        Case #PB_EventType_MouseMove
          If *this\bar And *this\state\drag
            *this\state\repaint = #True
          EndIf
          
          
        Case #PB_EventType_MouseStatus
          If *this\state\drag
            *item._S_rows = *data
            Debug  "MouseStatus - "+ *button +" "+ *item\index
            
          EndIf
          
        Case #PB_EventType_StatusChange
          *this\state\repaint = #True
          
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_KeyDown,
             #PB_EventType_KeyUp,
             #PB_EventType_LeftButtonUp,
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave,
             #PB_EventType_ScrollChange,
             ;           ;; #PB_EventType_Repaint,
             ;              #PB_EventType_Create,
             ;              #PB_EventType_Focus,
             ;              #PB_EventType_LostFocus,
             ;              #PB_EventType_DragStart,
             ;              #PB_EventType_Resize,
          #PB_EventType_Drop
          
          *this\state\repaint = #True
      EndSelect
      
      Select eventtype
        Case #PB_EventType_Create,
             #PB_EventType_Focus,
             #PB_EventType_LostFocus,
             #PB_EventType_DragStart,
             #PB_EventType_Drop
          
          ;  Debug " DoEvent - " +*this+" "+*this\root +" "+ ClassFromEvent( eventtype )
          ; *this\state\repaint = #True
      EndSelect
      
      ;       If *this\event
      ;         *this\event\type = eventtype
      ;       EndIf
      
      ;       ;
      ;       If Not is_widget_( *this )
      ;         If Not is_root_(*this )
      ;           Debug "not event widget - " + *this
      ;         EndIf
      ;         ProcedureReturn 0
      ;       EndIf
      ;       ;Debug Mouse( )\change
      ;             If eventtype = #PB_EventType_LeftButtonDown Or 
      ;                eventtype = #PB_EventType_LeftButtonUp 
      ;             ;  Debug "     "+ eventtype +" "+ *this\class +" "+ *this\text\string
      ;             *this\repaint = 1
      ;           EndIf
      ;             
      ;             If eventtype = #PB_EventType_MouseEnter Or 
      ;                eventtype = #PB_EventType_MouseLeave
      ;             ;;  Debug "     "+ eventtype +" "+ *this\class +" "+ *this\text\string
      ;             *this\repaint = 1
      ;         EndIf
      ;             
      ;             If eventtype = #PB_EventType_Focus Or 
      ;                eventtype = #PB_EventType_LostFocus 
      ;              ; Debug "     "+ eventtype +" "+ *this\class +" "+ *this\text\string
      ;              *this\repaint = 1
      ;         EndIf
      ;       
      
      If eventtype = #PB_EventType_MouseLeave
        If *this\type = #PB_GadgetType_Editor
          ; Debug ""+edit_caret_pos_( *this ) +" "+ edit_caret_pos_delta_( *this ) +" "+ edit_caret_pos_delta_( *this ) +" "+ edit_caret_pos_( *this )
        EndIf
      EndIf
      ; widget::_events_all( )
      
      ; change current cursor
      If *this\cursor ; And Not mouse( )\buttons
        If eventtype = #PB_EventType_MouseEnter
          ;           Protected Alpha = HitTest( *this, mouse_x, mouse_y ) 
          ;           
          ;           
          ;           Debug Alpha
          ;           
          set_cursor_( *this, *this\cursor )
        EndIf
        If eventtype = #PB_EventType_MouseLeave
          
          If Not EnteredWidget( )
            set_cursor_( *this, #PB_Cursor_Default )
          Else
            set_cursor_( EnteredWidget( ), EnteredWidget( )\cursor )
          EndIf
        EndIf 
      EndIf 
      
      ; widget::_events_Anchors( )
      If *this\_a_\transform
        If eventtype = #PB_EventType_MouseLeave
          If *this = a_enter_widget( ) 
            If a_events( *this, eventtype, mouse_x, mouse_y )
              Repaint = 1
              *this\state\repaint = #True
            EndIf
          EndIf
        Else
          If a_events( *this, eventtype, mouse_x, mouse_y )
            Repaint = 1
            *this\state\repaint = #True
          EndIf
        EndIf
      EndIf    
      
      If *this\state\flag & #__S_disable = #False           And Not (Transform( ) And a_is_at_point_( *this ))
        ; widget::_events_Window( )
        If *this\type = #__type_window
          Repaint | Window_Events( *this, eventtype, mouse_x, mouse_y )
        EndIf
        
        ; widget::_events_Properties( )
        If *this\type = #__type_property
          Repaint | Tree_events( *this, eventtype, *data, *button )
        EndIf
        
        ; widget::_events_Tree( )
        If *this\type = #__type_Tree
          Repaint | Tree_events( *this, eventtype, *data, *button )
        EndIf
        
        ; widget::_events_ListView( )
        If *this\type = #__type_ListView
          Repaint | ListView_Events( *this, eventtype, *data, *button )
        EndIf
        
        ; widget::_events_Editor( )
        If *this\type = #__type_Editor 
          Repaint | Editor_Events( *this, eventtype, *data, *button )
        EndIf
        
        ; widget::_events_String( )
        If *this\type = #__type_String
          Repaint | Editor_Events( *this, eventtype, *data, *button )
        EndIf
        
        ;- widget::_events_CheckBox( )
        If *this\type = #__type_Option Or
           *this\type = #__type_CheckBox
          
          Select eventtype
            Case #PB_EventType_LeftButtonDown : Repaint = #True
            Case #PB_EventType_LeftButtonUp   : Repaint = #True
            Case #PB_EventType_LeftClick
              If *this\type = #__type_CheckBox
                Repaint = SetState( *this, Bool( *this\_box_\___state! 1 ))
              Else
                Repaint = SetState( *this, 1 )
              EndIf
              
              If Repaint
                Post( *this, #PB_EventType_LeftClick ) 
              EndIf
          EndSelect
        EndIf
        
        ;- widget::_events_ComboBox( )
        If *this\type = #__type_combobox
          If eventtype = #PB_EventType_LeftButtonDown 
            If is_at_point_( *this\_box_, mouse_x, mouse_y )
              If *this\state\flag & #__S_collapse
                If Not EnteredRow( *this )
                  *this\state\flag &~ #__S_collapse
                EndIf
              Else
                *this\state\flag | #__S_collapse
              EndIf
              
              If *this\state\flag & #__S_collapse
                ;Debug "collapsed"
                Display( *this, *this\parent\widget );, *this\x[#__c_frame], *this\y[#__c_frame] )+ *this\height[#__c_frame] )
              EndIf
              
              Repaint = #True
            EndIf
          EndIf
          
          ; combobox-popup-list events
          If PopupWidget( )
            Repaint | ListView_events( PopupWidget( ), eventtype, *data, *button )
          EndIf
          
          If eventtype = #PB_EventType_Up Or eventtype = #PB_EventType_Down
            Debug "expanded"
            Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\barheight ) 
            update_visible_items_( *this )
            ; ClearList( VisibleRowList( *this ) )
            
            If FocusedRow( *this )
              *this\text\string = FocusedRow( *this )\text\string
            EndIf
            Repaint = #True
          EndIf
        EndIf
        
        ;- widget::_events_Button( )
        If *this\type = #__type_Button
          If Not *this\state\flag & #__S_check
            Select eventtype
              Case #PB_EventType_MouseLeave     : Repaint = #True 
                *this\color\state = #__S_0 
              Case #PB_EventType_LeftButtonDown 
                ;If *this\state\enter
                *this\color\state = #__S_2  
                ;EndIf
                Repaint = #True 
              Case #PB_EventType_MouseEnter     : Repaint = #True 
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
            
            ;; Post( *this, eventtype, #PB_All, 0 )
            ;EndIf
          EndIf
          
          If *this\image[#__img_released]\id Or *this\image[#__img_pressed]\id
            *this\image = *this\image[1 + Bool( *this\color\state = #__S_2 )]
          EndIf
        EndIf
        
        ;- widget::_events_Hyper( )
        If *this\type = #__type_HyperLink
          If Not Mouse( )\buttons
            If is_at_point_( *this, mouse_x - *this\x, mouse_y - *this\y, [#__c_required] )
              If *this\color\state = #__S_0
                *this\color\state = #__S_1
                set_cursor_( *this, #PB_Cursor_Hand )
                Repaint = #True
              EndIf
            Else 
              If *this\color\state = #__S_1
                *this\color\state = #__S_0
                set_cursor_( *this, #PB_Cursor_Default )
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
          ; if mouse enter text
          If *this\color\state = #__S_1
            If eventtype = #PB_EventType_LeftClick
              Post( *this, #PB_EventType_LeftClick, *this )
            EndIf
            If eventtype = #PB_EventType_LeftButtonUp
              set_cursor_( *this, #PB_Cursor_Hand )
              Repaint = #True
            EndIf
            If eventtype = #PB_EventType_LeftButtonDown
              set_cursor_( *this, #PB_Cursor_Default )
              *this\color\state = #__S_0 
              Repaint = 1
            EndIf
          EndIf
          If eventtype = #PB_EventType_MouseEnter
            set_cursor_( *this, #PB_Cursor_Default )
          EndIf
          
        EndIf
        
        ;- widget::_events_Bars( )
        If *this\type = #__type_Spin Or
           ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
           *this\type = #__type_TrackBar Or
           *this\type = #__type_ScrollBar Or
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_Splitter
          
          Repaint | bar_Events( *this, eventtype, mouse_x, mouse_y, _wheel_x_, _wheel_y_ )
        EndIf
        
        
        ;;*this\repaint = Repaint
        
        ;- widget::_events_Bind( )
        If *this\event 
          ;           If *item
          ;             If *this\row
          ;               Post( *this, eventtype, *item ) 
          ;             ElseIf *this\bar
          ;               Post( *this, eventtype, *item ) 
          ;             EndIf
          ;           Else
          ;; Post( *this, eventtype, *button, *data ) 
          ;           EndIf
        EndIf
      EndIf
      
      
      If *this\state\enter
        If Mouse( )\buttons
          *this\color\back = $FF00F7FF
        Else
          ;*this\color\back = $FF301DE8
          *this\color\state = #__S_1
        EndIf
        
      Else
        If eventtype = #PB_EventType_Repaint
          If *this\fs
            *this\color\back = $FFF3F3F3
          Else
            *this\color\back = $FF07EAF6
          EndIf
        Else
          ;*this\color\back = $FF13FF00
          *this\color\state = #__S_0 
        EndIf
      EndIf
      
      If *this\state\press
        If *this\state\drag 
          *this\color\back = $FFFFB1F8
        Else
          *this\color\back = $FFFFAA00
        EndIf
        
      ElseIf *this\state\focus
        *this\color\back = $FFCFCFCF
        
      EndIf
      ;       
      ;       ;   If *item
      ;       ;     
      ;       ;     If *item\state\enter
      ;       ;       If *this\state\press
      ;       ;         *item\color\back = $00F7FF
      ;       ;       Else
      ;       ;         *item\color\back = $301DE8
      ;       ;       EndIf
      ;       ;       
      ;       ;     Else
      ;       ;       If eventtype = #PB_EventType_Repaint
      ;       ;         *item\color\back = $F3F3F3
      ;       ;       Else
      ;       ;         *item\color\back = $13FF00
      ;       ;       EndIf
      ;       ;     EndIf
      ;       ;     
      ;       ;     If *item\state\press
      ;       ;       If *item\state\drag 
      ;       ;         *item\color\back = $FFB1F8
      ;       ;       Else
      ;       ;         *item\color\back = $FFAA00
      ;       ;       EndIf
      ;       ;       
      ;       ;     ElseIf *item\state\focus
      ;       ;       *item\color\back = $FF0090
      ;       ;       
      ;       ;     EndIf
      ;       ;     *this\state\repaint = #True
      ;       ;   EndIf
      
      
      ;
      If *this\state\repaint = #True
        *this\state\repaint = #False
        
        ;; Debug " PostReDraw - " +*this+" "+*this\root +" "+ ClassFromEvent( eventtype )
        PostEventRepaint( *this\root ) ; ReDraw( *this\root )
      EndIf
      
      ProcedureReturn 1;Repaint
    EndProcedure
    
    Procedure DoEvents( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      
      ;       If Not ( eventtype = #PB_EventType_Focus And FocusedWidget( ) <> *this ) And eventtype <> #PB_EventType_MouseMove
      ;         AddElement( EventList( *this\root ) )
      ;         *this\root\canvas\events.allocate( eventdata, ( ) )
      ;         EventList( *this\root )\id = *this
      ;         EventList( *this\root )\type = eventtype
      ;         EventList( *this\root )\item = *button
      ;         EventList( *this\root )\data = *data
      ;       EndIf
      
      ;       Select eventtype
      ;         Case #PB_EventType_MouseLeave 
      ;           ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseLeave "
      ;           *this\color\state = #__S_0 
      ;           PostEventRepaint( *this\root )
      ;         Case #PB_EventType_MouseEnter    
      ;           ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseEnter "
      ;           *this\color\state = #__S_1
      ;           PostEventRepaint( *this\root )
      ;       EndSelect
      
      ;       Select EventType
      ;           
      ;         Case #PB_EventType_DragStart
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_DragStart " 
      ;         Case #PB_EventType_Drop
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_Drop " 
      ;         Case #PB_EventType_Focus
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_Focus " 
      ;         Case #PB_EventType_LostFocus
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LostFocus " 
      ;         Case #PB_EventType_LeftButtonDown
      ;           Debug ""
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftButtonDown " 
      ;         Case #PB_EventType_LeftButtonUp
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftButtonUp " 
      ;         Case #PB_EventType_LeftClick
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftClick " 
      ;         Case #PB_EventType_LeftDoubleClick
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftDoubleClick " 
      ;         Case #PB_EventType_MouseEnter
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseEnter " 
      ;         Case #PB_EventType_MouseLeave
      ;           Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseLeave " 
      ;         Case #PB_EventType_MouseMove
      ;           ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseMove " 
      ;           
      ;       EndSelect
      
      _DoEvents( *this, eventtype, *button, *data )
    EndProcedure
    
    Procedure a_under_mouse( canvas, *enter.Integer = 0, *leave.Integer = 0)
      Protected i, result
      
      If a_enter_widget( ) And 
         a_enter_widget( )\_a_\id And 
         a_enter_widget( )\root\canvas\gadget = canvas
        
        If a_enter_index( a_enter_widget( ) ) And 
           a_enter_widget( )\_a_\id[a_enter_index( a_enter_widget( ) )] And 
           Not is_at_point_( a_enter_widget( )\_a_\id[a_enter_index( a_enter_widget( ) )], Mouse( )\x, Mouse( )\y ) 
          
          If a_enter_index( a_enter_widget( ) ) <> #__a_moved
            a_enter_widget( )\_a_\id[a_enter_index( a_enter_widget( ) )]\color\state = #__S_0
            If *leave And *leave\i <> a_enter_widget( )
              *leave\i = a_enter_widget( )
              Debug "" +a_enter_index( a_enter_widget( ) )+ " - a_leaved all"
            Else
              Debug "" +a_enter_index( a_enter_widget( ) )+ " - a_leave"
            EndIf
            PostEventRepaint( a_enter_widget( )\root )
          EndIf
          
          a_enter_index( a_enter_widget( ) ) = 0
        EndIf
        
        ; From point anchor
        For i = 1 To #__a_moved 
          If a_enter_widget( )\_a_\id[i] And 
             is_at_point_( a_enter_widget( )\_a_\id[i], Mouse( )\x, Mouse( )\y ) 
            ;
            If a_enter_index( a_enter_widget( ) ) <> i
              a_enter_index( a_enter_widget( ) ) = i
              Transform( )\index = i
              
              If i 
                If i <> #__a_moved
                  a_enter_widget( )\_a_\id[i]\color\state = #__S_1
                  Debug "" +i+ " - a_enter"
                  If *enter
                    *enter\i = a_enter_widget( )
                  EndIf
                EndIf
              EndIf
              
              PostEventRepaint( a_enter_widget( )\root )
            EndIf
            Break
          EndIf
        Next
      EndIf
      
      If a_focus_widget( ) And 
         a_focus_widget( )\_a_\id And
        a_focus_widget( )\root\canvas\gadget = canvas
        
        ; From point anchor
        For i = 1 To #__a_moved 
          If a_focus_widget( )\_a_\id[i] And is_at_point_( a_focus_widget( )\_a_\id[i], Mouse( )\x, Mouse( )\y ) 
            If a_enter_widget( ) <> a_focus_widget( )
              If a_enter_widget( ) And 
                 a_enter_widget( )\_a_\id And 
                 a_enter_index( a_enter_widget( ) ) <> #__a_moved
                
                a_enter_widget( )\_a_\id[a_enter_index( a_enter_widget( ) )]\color\state = #__S_0
                a_enter_index( a_enter_widget( ) ) = 0
                If *leave
                  *leave\i = a_enter_widget( )
                EndIf
              EndIf
            EndIf
            
            If *enter
              *enter\i = a_focus_widget( )
            EndIf
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure UnderMouse( *root._S_ROOT )
      Protected i, Repaint, *widget._S_WIDGET
      
      Static *leaved_widget._s_widget
      
      ; get at point address
      If *root\count\childrens
        ; Debug *root\canvas\address 
        ; *widget = *root 
        
        LastElement( WidgetList( *root )) 
        Repeat   
          If WidgetList( *root )\address And Not WidgetList( *root )\hide And 
             WidgetList( *root )\root\canvas\gadget = *root\canvas\gadget And
             is_at_point_( WidgetList( *root ), Mouse( )\x, Mouse( )\y, [#__c_frame] ) And 
             is_at_point_( WidgetList( *root ), Mouse( )\x, Mouse( )\y, [#__c_clip] ) 
            
            ;                   ; enter-widget mouse pos
            ;                   If is_at_point_( WidgetList( *root ), Mouse( )\x, Mouse( )\y, [#__c_inner] )
            ;                     ; get alpha
            ;                     If WidgetList( *root )\image[#__img_background]\id And
            ;                        WidgetList( *root )\image[#__img_background]\depth > 31 And 
            ;                        StartDrawing( ImageOutput( WidgetList( *root )\image[#__img_background]\img ) )
            ;                       
            ;                       DrawingMode_( #PB_2DDrawing_AlphaChannel )
            ;                       
            ;                       If Not Alpha( Point( ( Mouse( )\x - WidgetList( *root )\x[#__c_inner] ) - 1, ( Mouse( )\y - WidgetList( *root )\y[#__c_inner] ) - 1 ) )
            ;                         StopDrawing( )
            ;                         Continue
            ;                       EndIf
            ;                       
            ;                       StopDrawing( )
            ;                     EndIf
            ;                   EndIf
            
            ;
            If PopupWidget( ) And 
               is_at_point_( PopupWidget( ), Mouse( )\x, Mouse( )\y, [#__c_frame] ) And 
               is_at_point_( PopupWidget( ), Mouse( )\x, Mouse( )\y, [#__c_clip] ) 
              *widget = PopupWidget( )
            Else
              *widget = WidgetList( *root )
            EndIf
            
            ; is integral scroll bars
            If *widget\scroll
              If *widget\scroll\v And Not *widget\scroll\v\hide And *widget\scroll\v\type And 
                 is_at_point_( *widget\scroll\v, Mouse( )\x, Mouse( )\y, [#__c_frame] ) And
                 is_at_point_( *widget\scroll\v, Mouse( )\x, Mouse( )\y, [#__c_clip] ) 
                *widget = *widget\scroll\v
              EndIf
              If *widget\scroll\h And Not *widget\scroll\h\hide And *widget\scroll\h\type And
                 is_at_point_( *widget\scroll\h, Mouse( )\x, Mouse( )\y, [#__c_frame] ) And 
                 is_at_point_( *widget\scroll\h, Mouse( )\x, Mouse( )\y, [#__c_clip] ) 
                *widget = *widget\scroll\h
              EndIf
            EndIf
            
            ; is integral tab bar
            If *widget\tab\widget And Not *widget\tab\widget\hide And *widget\tab\widget\type And 
               is_at_point_( *widget\tab\widget, Mouse( )\x, Mouse( )\y, [#__c_frame] ) And
               is_at_point_( *widget\tab\widget, Mouse( )\x, Mouse( )\y, [#__c_clip] ) 
              *widget = *widget\tab\widget
            EndIf
            
            
            ; entered anchor widget
            If transform( ) 
              a_under_mouse( *root\canvas\gadget, @*widget, @*leaved_widget )  
            EndIf
            
            ;
            EnteredWidget( ) = *widget
            
            ; do events entered & leaved 
            If *leaved_widget <> *widget
              ; 
              If Not a_is_at_point_( *leaved_widget )
                If *leaved_widget And *leaved_widget\state\enter <> #False And Not IsChild( *widget, *leaved_widget )
                  
                  ;
                  *leaved_widget\state\enter = #False
                  ; GetAtPointItems( *leaved_widget, #PB_EventType_MouseLeave, Mouse()\x, Mouse()\y )
                  repaint | DoEvents( *leaved_widget, #PB_EventType_MouseLeave )
                  
                  If *leaved_widget\address ; And Not is_integral_( *leaved_widget )
                    ChangeCurrentElement( widget( ), *leaved_widget\address )
                    Repeat                 
                      If widget( )\count\childrens And widget( )\state\enter <> #False And 
                         Not is_at_point_( widget( ), Mouse( )\x, Mouse( )\y, [#__c_clip] ) And IsChild( *leaved_widget, widget( ))
                        
                        ;
                        widget( )\state\enter = #False
                        DoEvents( widget( ), #PB_EventType_MouseLeave )
                      EndIf
                    Until PreviousElement( widget( )) = #False 
                  EndIf
                  
                  _DD_event_leave_( repaint, *leaved_widget)
                EndIf
                
                ;
                If *widget And *widget\state\enter = #False
                  If *widget\address
                    ; first entered all parents
                    ChangeCurrentElement( widget( ), *widget\address )
                    While PreviousElement( widget( ))
                      If widget( )\count\childrens And 
                         widget( )\state\enter <> #True And
                         IsChild( *widget, widget( ))
                        ;
                        widget( )\state\enter = #True
                        DoEvents( widget( ), #PB_EventType_MouseEnter )
                      EndIf
                    Wend
                  EndIf
                  
                  ; 
                  *widget\state\enter = #True
                  repaint | DoEvents( *widget, #PB_EventType_MouseEnter )
                  ; GetAtPointItems( *widget, #PB_EventType_MouseEnter, Mouse()\x, Mouse()\y )
                  
                  ;
                  a_under_mouse( *widget\root\canvas\gadget )
                  
                  _DD_event_enter_( repaint, *widget)
                EndIf
              EndIf
              
              ;If Not ( Mouse()\buttons And *widget )
              *leaved_widget = *widget
              ;EndIf
            EndIf  
            
            
            Break
          EndIf
        Until PreviousElement( WidgetList( *root )) = #False 
      EndIf
      
      ProcedureReturn *widget
    EndProcedure
    
    Procedure EventHandler( Canvas =- 1, EventType =- 1 )
      Protected *event_widget._s_widget
      
      If Root( )
        Protected Repaint, mouse_x , mouse_y 
        ; Protected eventtype.i = PB(EventType)( )
        ; Protected Canvas.i
        
        Select eventtype
          Case #PB_EventType_Change
            ; bug mouse-enter fixed
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              ChangeCurrentRoot( PB(EventData)( ) )
              Canvas.i = Root( )\canvas\gadget
            CompilerEndIf
            
          Case #PB_EventType_MouseEnter
            ChangeCurrentRoot( GadgetID(Canvas) )
            ;+ ChangeCurrentRoot( GadgetID(PB(EventGadget)( )) )
            ;+ Canvas.i = Root( )\canvas\gadget
            
            ;           Case #PB_EventType_MouseEnter
            ;             ChangeCurrentRoot( GadgetID(Canvas) )
            ;             Mouse( )\change = 1
            ;             
            ;           Case #PB_EventType_MouseLeave
            ;             Mouse( )\change =- 1
            ;             
            ;           Case #PB_EventType_LeftButtonDown
            ;             Mouse( )\buttons | #PB_Canvas_LeftButton
            ;             
            ;           Case #PB_EventType_RightButtonDown
            ;             Mouse( )\buttons | #PB_Canvas_RightButton
            ;             
            ;           Case #PB_EventType_MiddleButtonDown
            ;             Mouse( )\buttons | #PB_Canvas_MiddleButton
            ;             
            ;           Case #PB_EventType_LeftButtonUp, 
            ;                #PB_EventType_RightButtonUp,
            ;                #PB_EventType_MiddleButtonUp
            ;             
            ;             Mouse( )\interact = 1
            ;             Mouse( )\change =- 1
            ;           
            
          Case #PB_EventType_Repaint
            If EventData( ) <> #PB_Ignore
              PushMapPosition( Root( ) )
              ChangeCurrentRoot( GadgetID(Canvas) )
              ;+ ChangeCurrentRoot(GadgetID(PB(EventGadget)( )) )
              ;+ Canvas.i = Root( )\canvas\gadget
              
              Protected result
              
              ;               Static repaint_count
              ;               Debug ""+repaint_count+" ----------- canvas "+ Canvas +" -------------- "
              ;               repaint_count + 1
              
              ForEach widget( )
                If widget( )\root\canvas\gadget = Canvas 
                  PushListPosition( widget( ) )
                  
                  Select EventData( )
                    Case #PB_EventType_Create 
                      widget( )\state\create = 1
                      
                      If widget( )\event
                        If ListSize(widget( )\event\call( ))
                          WidgetEvent( )\back = widget( )\event\call( )\back
                        EndIf
                        
                        ;                         If ListSize(widget( )\event\queue( ))
                        ;                           ForEach widget( )\event\queue( )
                        ;                             ForEach widget( )\event\call( )
                        ;                               If widget( )\event\call( )\type = #PB_All Or  
                        ;                                  widget( )\event\call( )\type = widget( )\event\queue( )\type
                        ;                                 
                        ;                                 EventWidget( ) = widget( )
                        ;                                 WidgetEvent( )\type = widget( )\event\queue( )\type
                        ;                                 WidgetEvent( )\item = widget( )\event\queue( )\item
                        ;                                 WidgetEvent( )\data = widget( )\event\queue( )\data
                        ;                                 WidgetEvent( )\back = widget( )\event\call( )\back
                        ;                                 
                        ;                                 result = WidgetEvent( )\back( )
                        ;                                 
                        ;                                 EventWidget( ) = #Null
                        ;                                 WidgetEvent( )\type = #PB_All
                        ;                                 WidgetEvent( )\item = #PB_All
                        ;                                 WidgetEvent( )\data = #Null
                        ;                                 
                        ;                                 If result
                        ;                                   Break 
                        ;                                 EndIf
                        ;                               EndIf
                        ;                             Next
                        ;                           Next
                        ;                           
                        ;                           ClearList(widget( )\event\queue( ))
                        ;                         EndIf
                      EndIf
                      
                      ;                       ; DoEvents( widget( ), #PB_EventType_Create )
                      ;                       If widget( )\state\focus = #True
                      ;                         widget( )\state\focus = #False
                      ;                         SetActive( widget( ) ) 
                      ;                       EndIf
                      
                  EndSelect
                  
                  widget( )\state\repaint = #False
                  ; DoEvents( widget( ), eventtype )
                  PopListPosition( widget( ) )
                Else
                  Debug "repaint error widget( )"
                EndIf
              Next
              
              ;Root( )\canvas\repaint = #True
              ;;; Debug " ReDraw - " + Canvas +" "+ Root( ) +" #PB_EventType_Repaint"
              ; DoEvents( Root( ), #PB_EventType_Repaint )
              ReDraw( Root( ) )
              PopMapPosition( Root( ) )
            EndIf
            
          Case #PB_EventType_Resize : ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            
            ;+ Canvas.i = PB(EventGadget)( )
            Protected Width = PB(GadgetWidth)( Canvas )
            Protected Height = PB(GadgetHeight)( Canvas )
            Repaint = Resize( Root( ), #PB_Ignore, #PB_Ignore, width, height )  
            ReDraw( Root( ) ) 
            Repaint = 1
            
        EndSelect
        
        
        ; init default canvas values
        If eventtype = #PB_EventType_LeftButtonDown
          Mouse( )\buttons | #PB_Canvas_LeftButton
          
        ElseIf eventtype = #PB_EventType_RightButtonDown
          Mouse( )\buttons | #PB_Canvas_RightButton
          
        ElseIf eventtype = #PB_EventType_MiddleButtonDown
          Mouse( )\buttons | #PB_Canvas_MiddleButton
          
          ; enable mouse behavior
        ElseIf eventtype = #PB_EventType_LeftButtonUp Or 
               eventtype = #PB_EventType_RightButtonUp Or
               eventtype = #PB_EventType_MiddleButtonUp
          
          Mouse( )\interact = 1
          Mouse( )\change =- 1
          
          ; x&y mouse
        ElseIf  eventtype = #PB_EventType_MouseMove Or 
                eventtype = #PB_EventType_MouseEnter Or eventtype = #PB_EventType_MouseLeave
          
          mouse_x = CanvasMouseX( Root( )\canvas\gadget )
          mouse_y = CanvasMouseY( Root( )\canvas\gadget )
          
          If Mouse( )\x <> mouse_x
            Mouse( )\x = mouse_x
            Mouse( )\change | 1<<1
          EndIf
          
          If Mouse( )\y <> mouse_y
            Mouse( )\y = mouse_y
            Mouse( )\change | 1<<2
          EndIf
          
        ElseIf eventtype = #PB_EventType_MouseLeave   
          Mouse( )\x =- 1
          Mouse( )\y =- 1
          Mouse( )\change =- 1
          
        EndIf
        
        
        ; get enter&leave widget address
        If Mouse( )\change
          ; enter&leave mouse events
          If Mouse( )\interact
            UnderMouse( Root( ) )
          EndIf
        EndIf
        
        ;         If Mouse( )\buttons
        ;           If Mouse( )\change
        ;             Debug ""+Root( ) +" "+ EnteredWidget( )
        ;           EndIf
        ;         EndIf
        
        ; do events all
        If eventtype = #PB_EventType_MouseEnter 
          If EnteredWidget( ) And 
             EnteredWidget( )\state\enter = #False
            EnteredWidget( )\state\enter = #True
            ; Debug "enter " + EnteredWidget( )\class
            
            Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseEnter )
            ; GetAtPointItems( EnteredWidget( ), #PB_EventType_MouseEnter, Mouse()\x, Mouse()\y )
          EndIf
          
        ElseIf eventtype = #PB_EventType_MouseLeave 
          ;Debug 555
          If EnteredWidget( ) And 
             EnteredWidget( )\state\enter = #True
            EnteredWidget( )\state\enter = #False
            ; Debug "leave " + EnteredWidget( )\class
            
            ; GetAtPointItems( EnteredWidget( ), #PB_EventType_MouseLeave, Mouse()\x, Mouse()\y )
            Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseLeave )
          EndIf
          
        ElseIf eventtype = #PB_EventType_Focus
          ;           If FocusedWidget( )                          And Not FocusedWidget( )\_a_\transform 
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
          ;           Repaint = SetActive( 0 ) 
          
        ElseIf eventtype = #PB_EventType_LeftButtonDown Or
               eventtype = #PB_EventType_MiddleButtonDown Or
               eventtype = #PB_EventType_RightButtonDown
          
          PressedWidget( ) = EnteredWidget( )
          ;PressedRow( EnteredWidget( ) ) = EnteredRow( EnteredWidget( ) )
          
          ;
          If EnteredWidget( )
            EnteredWidget( )\state\press = #True
            ;If Not EnteredWidget( )\time_down
            ;EndIf
            ; Debug ""+ EnteredWidget( )\class +" "+ EventGadget( ) + " #PB_EventType_LeftButtonDown" 
            
            If ( eventtype = #PB_EventType_LeftButtonDown Or
                 eventtype = #PB_EventType_RightButtonDown ) 
              
              
              ; disabled mouse behavior
              If EnteredWidget( )\_a_\transform Or EnteredButton( ) > 0
                Mouse( )\interact = #False
              EndIf
              
              If Not EnteredWidget( )\_a_\transform 
                If EnteredButton( ) > 0 And EnteredWidget( )\bar
                  ; bar mouse delta pos
                  ;; Debug "   bar delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                  ;If EnteredButton( ) = EnteredWidget( )\bar\button[#__b_3] ; EnteredButton( )\index = #__b_3
                  Mouse( )\delta\x = Mouse( )\x - EnteredWidget( )\bar\thumb\pos
                  Mouse( )\delta\y = Mouse( )\y - EnteredWidget( )\bar\thumb\pos
                  ;EndIf
                Else
                  ;; Debug "  widget delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                  Mouse( )\delta\x = Mouse( )\x - EnteredWidget( )\x[#__c_container]
                  Mouse( )\delta\y = Mouse( )\y - EnteredWidget( )\y[#__c_container]
                  
                  If Not is_integral_( EnteredWidget( ))
                    Mouse( )\delta\x - scroll_x_( EnteredWidget( )\parent\widget )
                    Mouse( )\delta\y - scroll_y_( EnteredWidget( )\parent\widget )
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ; set active widget
            ;               If eventtype = #PB_EventType_LeftButtonDown
            ;                 GetAtPointItems( EnteredWidget( ), #PB_EventType_LeftButtonDown, Mouse()\x, Mouse()\y )
            ;                 If EnteredWidget( ) <> FocusedWidget( ) 
            ;                   SetActive( EnteredWidget( ))
            ;                 EndIf
            ;               EndIf
            
            ; GetAtPointItems( PressedWidget( ), eventtype, Mouse()\x, Mouse()\y )
            Repaint | DoEvents( EnteredWidget( ), eventtype )
            
          EndIf
          
          
        ElseIf eventtype = #PB_EventType_MouseMove 
          If Mouse( )\change > 1
            If EnteredWidget( )
              ; mouse entered-widget move event
              GetAtPointItems( EnteredWidget( ), #PB_EventType_MouseMove, Mouse()\x, Mouse()\y )
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseMove )
            EndIf
            
            If PressedWidget( )
              If PressedWidget( )\root <> Root( )
                Mouse( )\x = CanvasMouseX( PressedWidget( )\root\canvas\gadget )
                Mouse( )\y = CanvasMouseY( PressedWidget( )\root\canvas\gadget )
              EndIf
              
              ; mouse drag start
              _DD_event_drag_( Repaint, PressedWidget( ) )
              
              ; mouse drag start
              If PressedWidget( ) And
                 PressedWidget( )\state\press = #True And
                 PressedWidget( )\state\drag = #False 
                PressedWidget( )\state\drag = #True
                
                DoEvents( PressedWidget( ), #PB_EventType_DragStart);, PressedItem( ) )
              EndIf
              
              If EnteredWidget( ) <> PressedWidget( )
                ; mouse pressed-widget move event
                GetAtPointItems( PressedWidget( ), #PB_EventType_MouseMove, Mouse()\x, Mouse()\y )
                Repaint | DoEvents( PressedWidget( ), #PB_EventType_MouseMove )
              EndIf
            EndIf
            
            Mouse( )\change = 0
          EndIf
          
        ElseIf eventtype = #PB_EventType_LeftButtonUp Or 
               eventtype = #PB_EventType_MiddleButtonUp Or
               eventtype = #PB_EventType_RightButtonUp
          
          If PressedWidget( ) 
            ; do drop events
            If EnteredWidget( ) And
               PressedWidget( )\state\drag <> #False
              ; PressedWidget( )\state\drag = #False
              
              DoEvents( EnteredWidget( ), #PB_EventType_Drop)
            EndIf
            
            ; do up events
            Repaint | DoEvents( PressedWidget( ), #PB_EventType_LeftButtonUp )
          EndIf
          
          ; reset mouse buttons
          If Mouse( )\buttons
            If eventtype = #PB_EventType_LeftButtonUp
              Mouse( )\buttons &~ #PB_Canvas_LeftButton
            ElseIf eventtype = #PB_EventType_RightButtonUp
              Mouse( )\buttons &~ #PB_Canvas_RightButton
            ElseIf eventtype = #PB_EventType_MiddleButtonUp
              Mouse( )\buttons &~ #PB_Canvas_MiddleButton
            EndIf
            
            Mouse( )\delta\x = 0
            Mouse( )\delta\y = 0
          EndIf
          
          If PressedWidget( ) 
            PressedWidget( )\state\press = #False 
            PressedWidget( )\state\drag = #False
          EndIf  
          
        ElseIf eventtype = #PB_EventType_Input Or
               eventtype = #PB_EventType_KeyDown Or
               eventtype = #PB_EventType_KeyUp
          
          If FocusedWidget( )
            Keyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Modifiers )
            
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              If Keyboard( )\key[1] & #PB_Canvas_Command
                Keyboard( )\key[1] &~ #PB_Canvas_Command
                Keyboard( )\key[1] | #PB_Canvas_Control
              EndIf
            CompilerEndIf
            
            If eventtype = #PB_EventType_Input 
              Keyboard( )\input = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Input )
            ElseIf ( eventtype = #PB_EventType_KeyDown Or
                     eventtype = #PB_EventType_KeyUp )
              Keyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Key )
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
                  ElseIf FocusedWidget( ) <> FocusedWidget( )\root\first\widget
                    Repaint = SetActive( FocusedWidget( )\root\first\widget )
                  EndIf
              EndSelect
            EndIf
          EndIf
          
        ElseIf eventtype = #PB_EventType_MouseWheel
          If EnteredWidget( )
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Protected app, ev
              app = CocoaMessage(0,0,"NSApplication sharedApplication")
              If app
                ev = CocoaMessage(0,app,"currentEvent")
                If ev
                  Mouse( )\wheel\x = CocoaMessage(0,ev,"scrollingDeltaX")
                EndIf
              EndIf
            CompilerEndIf
            
            Mouse( )\wheel\y = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_WheelDelta )
            
            ; mouse wheel events
            If Mouse( )\wheel\y
              GetAtPointItems( EnteredWidget( ), #PB_EventType_MouseWheelY, Mouse()\x, Mouse()\y )
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelY )
              Mouse( )\wheel\y = 0
            ElseIf Mouse( )\wheel\x
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelX )
              Mouse( )\wheel\x = 0
            EndIf
          EndIf
          
        ElseIf eventtype = #PB_EventType_LeftClick 
          If EnteredWidget( ) = PressedWidget( )
            Repaint | DoEvents( PressedWidget( ), #PB_EventType_LeftClick )
          EndIf      
        ElseIf eventtype = #PB_EventType_LeftDoubleClick 
          Repaint | DoEvents( PressedWidget( ), #PB_EventType_LeftDoubleClick )
          
        ElseIf eventtype = #PB_EventType_RightClick 
        ElseIf eventtype = #PB_EventType_RightDoubleClick 
        ElseIf eventtype = #PB_EventType_DragStart 
          
        ElseIf eventtype = #PB_EventType_Change 
        ElseIf eventtype = #PB_EventType_Resize 
        ElseIf eventtype = #PB_EventType_Repaint 
        Else        
          If eventtype <> #PB_EventType_MouseMove
            Mouse( )\change | 1<<0|1<<1
          EndIf
          Debug  #PB_Compiler_Procedure + " - else eventtype - "+eventtype
          
          If EnteredWidget( ) And Mouse( )\change
            Repaint | DoEvents( EnteredWidget( ), eventtype )
          EndIf
          If FocusedWidget( ) And EnteredWidget( ) <> FocusedWidget( ) And FocusedWidget( )\state\press And Mouse( )\change 
            Repaint | DoEvents( FocusedWidget( ), eventtype )
          EndIf
        EndIf
        
        ;         ; repaints all elements
        ;         If Repaint 
        ;           ReDraw( Root( ))
        ;         EndIf
        
        ; reset
        If Mouse( )\change <> #False
          Mouse( )\change = #False
        EndIf
        
        If ListSize( EventList( Root( ) ) )
          ; Debug ListSize( EventList( Root( ) ) )
          ForEach EventList( Root( ) )
            ;If EventList( Root( ) )\type = #PB_EventType_LeftClick 
            ; Debug 333
            If EventList( Root( ) )\type <> #PB_EventType_MouseMove
              ; Debug "" +EventList( Root( ) )\type +" "+ EventList( Root( ) )\id +" "+ ClassFromEvent( EventList( Root( ) )\type )
            EndIf
            
            ;_DoEvents( EventList( Root( ) )\id, EventList( Root( ) )\type, EventList( Root( ) )\item, EventList( Root( ) )\data )
            Post( EventList( Root( ) )\id, EventList( Root( ) )\type, EventList( Root( ) )\item, EventList( Root( ) )\data )
            ;EndIf
          Next
          
          ; Debug ""
          ClearList( EventList( Root( ) ) )
        EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = GetWindowData( EventWindow( ))
      ; Protected *this._S_widget = GetGadgetData( Canvas )
      ;PostEventCanvas( *this\root ) 
      ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
    EndProcedure
    
    
    
    ;-
    Procedure   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g, UseGadgetList, result
      
      If width = #PB_Ignore And
         height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If PB(IsWindow)(Window) 
        w = WindowID( Window )
      Else
        If Not MapSize( Root( ))
          w = OpenWindow( Window, x,y,width,height, title$, flag ) : If Window =- 1 : Window = w : w = WindowID( Window ) : EndIf
          x = 0
          y = 0
        Else
          Window = GetWindow( Root( ))
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
      
      ; get a handle from the previous usage list
      If w
        UseGadgetList = UseGadgetList( w )
      EndIf
      
      ;
      If PB(IsGadget)(Canvas)
        g = GadgetID( Canvas )
        If MapSize( Root( ) )
          Root( )\container = Canvas
        EndIf
      Else
        If MapSize( Root( ) )
          Root( )\container = #__type_root
        EndIf
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
        Root( )\type = #PB_GadgetType_Container
        Root( )\container = #PB_GadgetType_Container
        
        Root( )\class = "Root"
        Root( )\root = Root( )
        Root( )\window = Root( )
        
        Root( )\fs = Bool( flag & #__flag_BorderLess = 0 )
        Root( )\bs = Root( )\fs
        
        Root( )\color = _get_colors_( )
        Root( )\text\fontID = PB_( GetGadgetFont )( #PB_Default )
        
        
        ; check the elements under the mouse
        Mouse( )\interact = #True
        
        Root( )\canvas\window = Window
        Root( )\canvas\gadget = Canvas
        Root( )\canvas\address = g
        
        AddWidget( Root( ), Root( ) )
        
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
        PostEvent( #PB_Event_Gadget, Window, Canvas, #PB_EventType_Repaint, #PB_EventType_Create )
        ; BindGadgetEvent( Canvas, @EventHandler( ))
      EndIf
      
      If g
        SetGadgetData( Canvas, result ) ;@*canvas\_root( ))
        SetWindowData( Window, Canvas )
        
        If flag & #PB_Canvas_Container = #PB_Canvas_Container
          BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window );, Canvas )
        EndIf
        
        ; z - order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( g, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE | #SWP_NOSIZE )
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
        ;
        set_align_flag_( *this, *parent, flag )
        AddWidget( *this, *parent )
        
        
        *this\fs = constants::_check_( flag, #__flag_borderless, #False ) * #__window_frame_size
        *this\child = Bool( Flag & #__window_child = #__window_child )
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        
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
          *this\barHeight = constants::_check_( flag, #__flag_borderless, #False ) * ( #__window_caption_height ); + #__window_frame_size )
          *this\round = 7
          
          *this\caption\text\padding\x = 5
          *this\caption\text\string = Text
        EndIf
        
        If x = #PB_Ignore : If transform( ) : x = pos_x + transform( )\grid\size : Else : x = pos_x : EndIf : EndIf : pos_x = x + #__window_frame_size
        If y = #PB_Ignore : If transform( ) : y = pos_y + transform( )\grid\size : Else : y = pos_y : EndIf : EndIf : pos_y = y + #__window_frame_size + #__window_caption_height
        
        ; open root list
        If Not MapSize( Root( ))
          Protected Root = Open( OpenWindow( #PB_Any, x,y,width + *this\fs*2,height + *this\fs*2 + *this\barHeight, "", #PB_Window_BorderLess, *parent ))
          Flag | #__flag_autosize
          x = 0
          y = 0
          Root( )\width[#__c_inner] = width
          Root( )\height[#__c_inner] = height
        EndIf
        
        If *parent
          If Root( ) = *parent 
            Root( )\parent\widget = *this
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
        
        If *parent And
           *this\child = 0 And 
           SetAttachment( *this, *parent, 0 )
          x - *parent\x[#__c_container] - *parent\fs[1]
          y - *parent\y[#__c_container] - *parent\fs[2] 
        EndIf
        Resize( *this, x,y,width,height )
        
        If flag & #__Window_NoGadgets = #False
          OpenList( *this )
        EndIf
        
        If flag & #__Window_NoActivate = #False And Not *this\_a_\transform
          SetActive( *this )
        EndIf 
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
      SetGadgetData( Gadget, *this )
      
      EnteredWidget( ) = *this
      
      ProcedureReturn g
    EndProcedure
    
    Procedure   Object( x.l,y.l,width.l,height.l, text.s, Color.l, flag.i=#Null, framesize=1  )
      If Not Alpha(Color)
        Color = Color&$FFFFFF | 255<<24
      EndIf
      
      Container(x,y,width,height, #__flag_nogadgets) 
      If text
        SetText(widget( ), text)
      EndIf
      
      SetFrame(widget( ), framesize)
      
      SetColor(widget( ), #__color_back, Color)
      SetColor(widget( ), #__color_frame, Color&$FFFFFF | 255<<24)
      ProcedureReturn widget( )
    EndProcedure
    
    Procedure.i Free( *this._S_widget )
      Protected result.i
      
      With *this
        If *this
          If \scroll
            If \scroll\v : FreeStructure( \scroll\v ) : \scroll\v = 0 : EndIf
            If \scroll\h : FreeStructure( \scroll\h )  : \scroll\h = 0 : EndIf
            ; *this\scroll = 0
          EndIf
          
          If \type = #__type_Splitter
            If splitter_first_gadget_( *this ) : FreeStructure( splitter_first_gadget_( *this ) ) : splitter_first_gadget_( *this ) = 0 : EndIf
            If splitter_second_gadget_( *this ) : FreeStructure( splitter_second_gadget_( *this ) ) : splitter_second_gadget_( *this ) = 0 : EndIf
          EndIf
          
          If \tab\widget
          EndIf
          
          If *this\parent\widget 
            If *this\parent\widget\scroll\v = *this
              FreeStructure( *this\parent\widget\scroll\v ) 
              *this\parent\widget\scroll\v = 0
            EndIf
            If *this\parent\widget\scroll\h = *this
              FreeStructure( *this\parent\widget\scroll\h )  
              *this\parent\widget\scroll\h = 0
            EndIf
            
            If *this\parent\widget\type = #__type_Splitter
              If splitter_first_gadget_( *this\parent\widget ) = *this
                FreeStructure( splitter_first_gadget_( *this\parent\widget ) ) 
                splitter_first_gadget_( *this\parent\widget ) = 0
              EndIf
              If splitter_second_gadget_( *this\parent\widget ) = *this
                FreeStructure( splitter_second_gadget_( *this\parent\widget ) )  
                splitter_second_gadget_( *this\parent\widget ) = 0
              EndIf
            EndIf
          EndIf
          
          
          Debug  " free - " + ListSize( WidgetList( *this\root ))  + " " +  *this\root\count\childrens  + " " +  *this\parent\widget\count\childrens
          If *this\parent\widget And
             *this\parent\widget\count\childrens 
            
            
            LastElement( WidgetList( *this\root ))
            Repeat
              If WidgetList( *this\root ) = *this Or IsChild( WidgetList( *this\root ), *this )
                
                If WidgetList( *this\root )\root\count\childrens > 0 
                  WidgetList( *this\root )\root\count\childrens - 1
                  If WidgetList( *this\root )\parent\widget <> WidgetList( *this\root )\root
                    WidgetList( *this\root )\parent\widget\count\childrens - 1
                  EndIf
                  If StickyWindow( ) = WidgetList( *this\root )
                    StickyWindow( ) = #Null
                  EndIf
                  ;  Debug 88888
                  DeleteElement( WidgetList( *this\root ), 1 )
                EndIf
                
                If Not *this\root\count\childrens
                  Break
                EndIf
              ElseIf PreviousElement( WidgetList( *this\root )) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  "   free - " + ListSize( WidgetList( *this\root ))  + " " +  *this\root\count\childrens  + " " +  *this\parent\widget\count\childrens
          
          
          If EnteredWidget( ) = *this
            EnteredWidget( ) = *this\parent\widget
          EndIf
          If FocusedWidget( ) = *this
            FocusedWidget( ) = *this\parent\widget
          EndIf
          
          ; *this = 0
          ;ClearStructure( *this, _S_widget )
        EndIf
      EndWith
      
      
      ;       Debug " free - "
      ;       ForEach WidgetList( *this\root ) 
      ;         If WidgetList( *this\root )\before\widget And WidgetList( *this\root )\after\widget
      ;           Debug " free - "+ WidgetList( *this\root )\before\widget\class +" "+ WidgetList( *this\root )\class +" "+ WidgetList( *this\root )\after\widget\class
      ;         ElseIf WidgetList( *this\root )\after\widget
      ;           Debug " free - none "+ WidgetList( *this\root )\class +" "+ WidgetList( *this\root )\after\widget\class
      ;         ElseIf WidgetList( *this\root )\before\widget
      ;           Debug " free - "+ WidgetList( *this\root )\before\widget\class +" "+ WidgetList( *this\root )\class +" none"
      ;         Else
      ;           Debug " free - "+ WidgetList( *this\root )\class 
      ;         EndIf
      ;       Next
      ;       Debug ""
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure EventMessageHandler( )
      Protected result
      Protected *widget._S_widget = EnteredWidget( )
      
      If *widget And *widget\window And *widget\window\class = "Message"
        ;Debug *widget\events\type
        
        If *widget\events\type = #PB_EventType_LeftClick And *widget\type = #PB_GadgetType_Button
          
          Select *widget\text\string
            Case "Yes" : result = #PB_MessageRequester_Yes    ; yes
            Case "No" : result = #PB_MessageRequester_No      ; no
            Case "Cancel" : result = #PB_MessageRequester_Cancel ; cancel
          EndSelect
          
          WidgetEventData( ) = result
          PostEvent( #PB_Event_CloseWindow, EventWindow( ), *widget\window )
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure Message( Title.s, Text.s, Flag.i = #Null )
      ;       Procedure DoEvents( )
      ;         msg.MSG
      ;         If PeekMessage_(@msg,0,0,0,1)
      ;           TranslateMessage_(@msg)
      ;           DispatchMessage_(@msg)
      ;         Else
      ;           Sleep_(1)
      ;         EndIf
      ;       EndProcedure
      Protected result
      Protected img =- 1, f1 =- 1, f2=8, width = 400, height = 120
      Protected bw = 85, bh = 25, iw = height-bh-f1 - f2*4 - 2-1
      
      Protected x = ( Root( )\width-width-#__window_frame_size*2 )/2
      Protected y = ( Root( )\height-height-#__window_caption_height-#__window_frame_size*2 )/2
      ;       Protected x = ( root( )\width-width )/2
      ;       Protected y = ( root( )\height-height )/2
      Protected *parent;._S_widget = EventWidget( )\window ; OpenedWidget( )
      
      Protected Window = Window( x,y, width, height, Title, #__window_titlebar, *parent)
      SetClass( Window, #PB_Compiler_Procedure )
      ;SetAlignmentFlag( Window, #__align_center )
      ;Bind( Window, @message_events( ))
      Sticky( Window, #True )
      
      
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
      SetAlignmentFlag( Widget( ), #__align_bottom | #__align_right )
      
      If Flag & #PB_MessageRequester_YesNo Or 
         Flag & #PB_MessageRequester_YesNoCancel
        SetText( Widget( ), "Yes" )
        Button( width-( bw+f2 )*2-f2,height-bh-f2,bw,bh,"No" )
        SetAlignmentFlag( Widget( ), #__align_bottom | #__align_right )
      EndIf
      
      If Flag & #PB_MessageRequester_YesNoCancel
        Button( width-( bw+f2 )*3-f2*2,height-bh-f2,bw,bh,"Cancel" )
        SetAlignmentFlag( Widget( ), #__align_bottom | #__align_right )
      EndIf
      
      
      ; EventHandler( )
      
      WaitClose( Window )
      result = WidgetEventData( )
      
      ;; Sticky( window, #False )
      ;; result = GetData( Window )
      ProcedureReturn result
    EndProcedure
    
    Procedure   WaitClose( *this._S_widget = #PB_Any, waittime.l = 0 )
      Protected result 
      Protected *window._S_widget = *this;\window
      Protected PBWindow = PB(EventWindow)( )
      
      If Root( )
        ; ReDraw( Root( ))
        If ListSize( EventList( Root( ) ) )
          ClearList( EventList( Root( ) ) )
        EndIf
        
        Repeat 
          Select WaitWindowEvent( waittime ) 
              ; Case #PB_Event_Message
              
            Case #PB_Event_Gadget
              If Root( )\canvas\bindevent = #False
                Root( )\canvas\repaint = #True
                EventHandler( )
                
                result = EventMessageHandler( )
                
              EndIf
              
            Case #PB_Event_CloseWindow
              If *window = #PB_Any 
                If EventWidget( )
                  Debug " - close - " + EventWidget( ) ; +" "+ GetWindow( *window )
                  If EventWidget( )\container = #__type_window
                    ;Else
                    
                    ForEach Root( )
                      Debug Root( )
                      free( Root( ))
                      ;               ForEach widget( )
                      ;                 Debug ""+widget( )\root +" "+ is_root_(widget( ))
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


CompilerIf #PB_Compiler_IsMainFile
  
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
  Define *root._S_widget = Open(#window_0,0,0,424, 352)
  SetData(*root, 1 )
  ;BindWidgetEvent( *root, @BindEvents( ) )
  Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
  view = Container(10, 10, 406, 238, #PB_Container_Flat)
  SetColor(view, #PB_Gadget_BackColor,RGB(213,213,213))
  ;a_enable( widget( ), 15 )
  a_init( view, 15 )
  image( 5,5,60,60, -1 )
  Define *a._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
  image( 150,110,60,60, -1 )
  
  ; a_init( *a, 15 )
  a_set( *a )
  CloseList()
  size_value = Track(56, 262, 240, 26, 0, 30)
  pos_value = Track(56, 292, 240, 26, 0, 30)
  grid_value = Track(56, 320, 240, 26, 0, 30)
  back_color = Button(304, 264, 112, 32, "BackColor")
  frame_color = Button(304, 304, 112, 32, "FrameColor")
  size_text = Text(8, 256, 40, 24, "0")
  pos_text = Text(8, 288, 40, 24, "0")
  grid_text = Text(8, 320, 40, 24, "0")
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;{ OpenRoot0
  Define *root0._S_widget = Open(#window,10,10,300-20,300-20)
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
  
  
  Define *root1._S_widget = Open(#window,300,10,300-20,300-20)
  ;BindWidgetEvent( *root1, @BindEvents( ) )
  
  
  Define *root2._S_widget = Open(#window,10,300,300-20,300-20)
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  *w = ComboBox( 20,20, 150,40)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  
  Define *root3._S_widget = Open(#window,300,300,300-20,300-20)
  ;BindWidgetEvent( *root3, @BindEvents( ) )
  
  Define *root4._S_widget = Open(#window, 590, 10, 200, 600-20)
  ;BindWidgetEvent( *root4, @BindEvents( ) )
  
  
  
  Define count = 2;0000
  #st = 1
  Global  mx=#st,my=#st
  
  Define time = ElapsedMilliseconds( )
  
  OpenList( *root1 )
  Define *panel._S_widget = Panel(20, 20, 180+40, 180+60, editable) : SetData(*panel, 100)
  AddItem( *panel, -1, "item_1" )
  SetData(Container(20, 20, 180, 180, editable), 1) 
  SetData(Container(70, 10, 70, 180, #__Flag_NoGadgets|editable), 2) 
  SetData(Container(40, 20, 180, 180, editable), 3)
  SetData(Container(20, 20, 180, 180, editable), 4)
  
  SetData(Container(5, 30, 180, 30, #__Flag_NoGadgets|editable), 5) 
  SetData(Container(5, 45, 180, 30, #__Flag_NoGadgets|editable), 6) 
  SetData(Container(5, 60, 180, 30, #__Flag_NoGadgets|editable), 7) 
  
  ;   SetData(Splitter(5, 80, 180, 50, 
  ;                    Container(0,0,0,0, #__Flag_NoGadgets|editable), 
  ;                    Container(0,0,0,0, #__Flag_NoGadgets|editable),
  ;                    #PB_Splitter_Vertical|editable), 8) 
  
  CloseList( ) ; 3
  CloseList( ) ; 4
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
  SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
  SetData(Container(10, 45, 70, 180, editable), 111) 
  SetData(Container(10, 5, 70, 180, editable), 1111) 
  SetData(Container(10, 5, 70, 180, editable), 11111) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  CloseList( ) ; 11111
  CloseList( ) ; 1111
  CloseList( ) ; 111
  CloseList( ) ; 11
  CloseList( ) ; 1
  AddItem( *panel, -1, "item_2" )
  Button( 10,10, 80,80, "item_2")
  AddItem( *panel, -1, "item_3" )
  Button( 20,20, 80,80, "item_3")
  AddItem( *panel, -1, "item_4" )
  Button( 30,30, 80,80, "item_4")
  AddItem( *panel, -1, "item_5" )
  Button( 40,40, 80,80, "item_5")
  CloseList( ) ; *panel
  CloseList( ) ; *root1
  
  ;
  OpenList( *root2 )
  SetData(*root2, 11 )
  ;Define *p3._S_widget = Container( 80,80, 150,150 )
  Define *p3._S_widget = ScrollArea( 80,80, 150+30,150+30, 300,300 )
  SetData(*p3, 12 )
  SetData(Container( 40,-30, 50,50, #__Flag_NoGadgets ), 13 )
  
  Define *p2._S_widget = Container( 40,40, 70,70 ) : SetData(*p2, 4 )
  SetData(Container( 5,5, 70,70 ), 5 )
  SetData(Container( -30,40, 50,50, #__Flag_NoGadgets ), 6)
  CloseList( )
  Define *c._S_widget = Container( 40,-30, 50,50, #__Flag_NoGadgets ) : SetData(*c, 3 )
  CloseList( )
  
  SetData(Container( 50,130, 50,50, #__Flag_NoGadgets ), 14 )
  SetData(Container( -30,40, 50,50, #__Flag_NoGadgets ), 15 )
  SetData(Container( 130,50, 50,50, #__Flag_NoGadgets ), 16 )
  CloseList( )
  CloseList( )
  
  OpenList( *root3 )
  *w = Tree( 10,20, 150,200, #__tree_multiselect)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 100,30, 100,260-20+300, #__flag_borderless)
  SetColor( *w, #__color_back, $FF07EAF6 )
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 180,40, 100,260-20+300)
  For i=1 To 100;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  Debug "--------  time --------- "+Str(ElapsedMilliseconds( ) - time)
  
  
  ;
  Define *window._S_widget
  Define i,y = 5
  OpenList( *root4 )
  For i = 1 To 4
    Window(5, y, 150, 95+2, "Window_" + Trim(Str(i)));, #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    Container(5, 5, 120+2,85+2)                      ;, #PB_Container_Flat)                                                                         ; Gadget(i, 
    Button(10,10,100,30,"Button_" + Trim(Str(i+10))) ; Gadget(i+10,
    Button(10,45,100,30,"Button_" + Trim(Str(i+20))) ; Gadget(i+20,
    CloseList( )                                     ; Gadget
    y + 130
  Next
  
  Define event, handle, enter, result
  Repeat 
    event = events::WaitEvent( @EventHandler( ), WaitWindowEvent( ) )
    ; event = WaitEvent( WaitWindowEvent( ) )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------0--z+--------------------------
; EnableXP