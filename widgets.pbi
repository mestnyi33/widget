;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
; 43025500559246
; Regex Trim(Arguments)
; https://regex101.com/r/zxBLgG/2
; ~"((?:(?:\".*?\")|(?:\\(.*?\\))|[^,])+)"
; ~"(?:\"(?:.*?)\"|(?:\\w*)\\s*\\((?:(?>[^( )]+|(?R))*)\\)|[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\])+"
; #Button_0, ReadPreferenceLong("x", WindowWidth(#Window_0)/WindowWidth(#Window_0)+20), 20, WindowWidth(#Window_0)-(390-155), WindowHeight(#Window_0) - 180 * 2, GetWindowTitle(#Window_0) + Space( 1 ) +"("+ "Button" + "_" + Str(1)+")"

; Regex Trim(Captions)
; https://regex101.com/r/3TwOgS/1
; ~"((?:\"(.*?)\"|\\((.*?)\\)|[^+\\s])+)"
; ~"(?:(\\w*)\\s*\\(((?>[^( )\"]+|(?R))+)\\))|\"(.*?)\"|[^+\\s]+"
; ~"(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^( )\"]+|(?R))+)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\/])|([\\*])|([\\-])|([\\+])"
; ~"(?:(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^( )\"]+|(?R))*)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+)|([\\/])|([\\*])|([\\-])|([\\+]))"
; Str(ListIndex(List( )))+"Число между"+Chr(10)+"это 2!"+
; ListIndex(List( )) ; вот так не работает

; ; https://regex101.com/r/RFubVd/14
; ; #Эта часть нужна для поиска переменных
; ; #Например, "Window" в выражении "Window=OpenWindow(#PB_Any...)"
; ; (?:(\b[^:\n\s]+)\s*=\s*)?
; ;
; ; #Эта часть для поиска процедур
; ; (?:\".*\"|(\w+)\s*\(((?>(?R)|[^)(])*)\))
; ;
; ; #После выполнения:
; ; # - В группе \1 будет находиться название переменной
; ; # - В группе \2 - название процедуры
; ; # - В группе \3 - перечень всех аргументов найденной процедуры
; ; ~"(?:(\\b[^:\\n\\s]+)\\s*=\\s*)?(?:\".*\"|(\\w+)\\s*\\(((?>(?R)|[^)(])*)\\))"
#RegEx_Pattern_FindFunction = ~"(?P<Comments>;).*|(?:(?P<Handle>\\b[^:\\n\\s]+)\\s*=\\s*)?(?:\".*\"|(?P<Function>\\w+)\\s*\\((?P<Arguments>(?>(?R)|[^)(])*)\\))" ; "(;).*|\b(?:.*(=)\s*\w*\(.*\)|([A-Za-z0-9_.]*)\b[^:\n\(]*\s*\((?>[^)(]|(?R))*\))"

; Найти
; https://regex101.com/r/u60Wqt/1
; https://regex101.com/r/rQCwws/3
; https://regex101.com/r/RFubVd/22
; https://regex101.com/r/D4Jxuh/24
; https://regex101.com/r/mBkJTA/29

; ver: 3.0.0.1 ;
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  #path = ""
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  #path = "Z:\Documents\GitHub\Widget\"
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

; fix all pb bug's
CompilerIf Not Defined( fix, #PB_Module )
  XIncludeFile "include/fix.pbi"
CompilerEndIf

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
    Macro Debugger( _text_ = "" )
      CompilerIf #PB_Compiler_Debugger  ; Only enable assert in debug mode
        Debug " " + _macro_call_count_ + _text_ + "   ( debug >> " + #PB_Compiler_Procedure + " ( " + #PB_Compiler_Line + " ))"
        _macro_call_count_ + 1
      CompilerEndIf
    EndMacro
    
    ;- demo text
    Macro debug_position( _root_, _text_ = "" )
      Debug " " + _text_ + " - "
      ForEach _root_\_widgets( )
        If _root_\_widgets( ) <> _root_\_widgets( )\_root( )
          If _root_\_widgets( )\before\widget And _root_\_widgets( )\after\widget
            Debug " - " + Str(ListIndex( _root_\_widgets( ))) + " " + _root_\_widgets( )\index + " " + _root_\_widgets( )\before\widget\class + " " + _root_\_widgets( )\class + " " + _root_\_widgets( )\after\widget\class
          ElseIf _root_\_widgets( )\after\widget
            Debug " - " + Str(ListIndex( _root_\_widgets( ))) + " " + _root_\_widgets( )\index + " none " + _root_\_widgets( )\class + " " + _root_\_widgets( )\after\widget\class
          ElseIf _root_\_widgets( )\before\widget
            Debug " - " + Str(ListIndex( _root_\_widgets( ))) + " " + _root_\_widgets( )\index + " " + _root_\_widgets( )\before\widget\class + " " + _root_\_widgets( )\class + " none"
          Else
            Debug " - " + Str(ListIndex( _root_\_widgets( ))) + " " + _root_\_widgets( )\index + " none " + _root_\_widgets( )\class + " none "
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
    Macro CreateCursor( _imageID_, _x_ = 0, _y_ = 0 )
      func::CreateCursor( _imageID_, _x_, _y_ )
    EndMacro
    ;     Macro CreateCursor( ImageID, x = 0, y = 0 )
    ;       Cursor::Create( ImageID, x, y )
    ;     EndMacro
    
    ;-  Drag & Drop
    Macro EventDropX( ): DropX( ): EndMacro
    Macro EventDropY( ): DropY( ): EndMacro
    Macro EventDropWidth( ): DropWidth( ): EndMacro
    Macro EventDropHeight( ): DropHeight( ): EndMacro
    
    Macro EventDropType( ): DropType( ): EndMacro
    Macro EventDropAction( ): DropAction( ): EndMacro
    Macro EventDropPrivate( ): DropPrivate( ): EndMacro
    Macro EventDropFiles( ): DropFiles( ): EndMacro
    Macro EventDropText( ): DropText( ): EndMacro
    Macro EventDropImage( Image = - 1, Depth = 24 ): DropImage( Image, Depth ): EndMacro
    
    Macro DragType( )
      EventWidget( )\state\drag
    EndMacro
    Macro DragText( Text, Actions = #PB_Drag_Copy ): DragText_( Text, Actions ): EndMacro
    Macro DragImage( Image, Actions = #PB_Drag_Copy ): DragImage_( Image, Actions ): EndMacro
    Macro DragFiles( Files, Actions = #PB_Drag_Copy ): DragFiles_( Files, Actions ): EndMacro
    Macro DragPrivate( PrivateType, Actions = #PB_Drag_Copy ): DragPrivate_( PrivateType, Actions ): EndMacro
    
    Macro EnableDrop( Widget, Format, Actions, PrivateType = 0 ) : DropEnable( Widget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableGadgetDrop( Gadget, Format, Actions, PrivateType = 0 ) : DropEnable( Gadget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableWindowDrop( Window, Format, Actions, PrivateType = 0 ) : DropEnable( Window, Format, Actions, PrivateType ) : EndMacro
    
    Declare.l DropX( )
    Declare.l DropY( )
    Declare.l DropWidth( )
    Declare.l DropHeight( )
    
    Declare.s DropFiles( )
    Declare.s DropText( )
    Declare.i DropType( )
    Declare.i DropAction( )
    Declare.i DropPrivate( )
    Declare.i DropImage( Image.i = -1, Depth.i = 24 )
    
    Declare.i DragText_( Text.S, Actions.i = #PB_Drag_Copy )
    Declare.i DragImage_( Image.i, Actions.i = #PB_Drag_Copy )
    Declare.i DragPrivate_( Type.i, Actions.i = #PB_Drag_Copy )
    Declare.i DragFiles_( Files.s, Actions.i = #PB_Drag_Copy )
    
    Declare.i DropEnable( *this, Format.i, Actions.i, PrivateType.i = 0 )
    
    ;-
    Macro allocate( _struct_name_, _struct_type_ = )
      _S_#_struct_name_#_struct_type_ = AllocateStructure( _S_#_struct_name_ )
    EndMacro
    Macro _root( ): root: EndMacro
    Macro _window( ): window: EndMacro
    Macro _parent( ): parent: EndMacro ; Returns last created widget
    
    Macro _tabs( ): bar\_s( ): EndMacro
    ;Macro _rows( ): row\_s( ): EndMacro
    Macro _rows( ): columns( )\items( ): EndMacro
    
    Macro Root( ) : widget::*canvas\_roots( ): EndMacro
    Macro _events( ): _root( )\canvas\events( ): EndMacro
    Macro _widgets( ): _root( )\canvas\child( ): EndMacro ; Returns last created widget
    
    Macro enumWidget( ): Root( )\_widgets( ): EndMacro       ; temp
    Macro Widget( ): Root( )\_widgets( ): EndMacro           ; Returns last created widget
    
    Macro PB( _pb_function_name_ ) : _pb_function_name_: EndMacro
    Macro Mouse( ) : widget::*canvas\mouse: EndMacro
    Macro Keyboard( ) : widget::*canvas\keyboard: EndMacro
    Macro Drawing( ): widget::*canvas\drawing : EndMacro
    
    ;-
    Macro StringBox( ): StringWidget: EndMacro
    Macro PopupBox( ): PopupWidget: EndMacro
    Macro GroupBox( ): GroupWidget: EndMacro
    
    Macro TabBox( ): tab\widget: EndMacro
    Macro TabIndex( ): tab\index: EndMacro
    
    Macro TabChange( ): tab\change: EndMacro
    Macro TextChange( ): text\change: EndMacro ; temp
    Macro ImageChange( ): image\change: EndMacro ; temp
    Macro AreaChange( ): area\change: EndMacro   ; temp
    Macro PageChange( ): page\change: EndMacro   ; temp
    Macro ThumbChange( ): thumb\change: EndMacro ; temp
    Macro WidgetChange( ): change: EndMacro      ; temp
    
    Macro splitter_gadget_1( ): gadget[1]: EndMacro
    Macro splitter_gadget_2( ): gadget[2]: EndMacro
    Macro splitter_is_gadget_1( ): index[1]: EndMacro
    Macro splitter_is_gadget_2( ): index[2]: EndMacro
    
    Macro EnteredTab( ): tab\entered: EndMacro         ; Returns mouse entered tab
    Macro PressedTab( ): tab\pressed: EndMacro         ; Returns mouse focused tab
    Macro FocusedTab( ): tab\focused: EndMacro         ; Returns mouse focused tab
    
    Macro OpenedTabIndex( ): index[1]: EndMacro  ;
    Macro FocusedTabIndex( ): index[2]: EndMacro ;
    Macro TabBoxFocusedIndex( ): TabBox( )\FocusedTabIndex( ): EndMacro;
    
    Macro ParentRow( ): parent: EndMacro
    Macro LeavedRow( ): row\leaved: EndMacro  ; Returns mouse entered widget
    Macro EnteredRow( ): row\entered: EndMacro; Returns mouse entered widget
    Macro PressedRow( ): row\pressed: EndMacro; Returns key focus item address
    Macro FocusedRow( ): row\focused: EndMacro; Returns key focus item address
    
    Macro VisibleRows( ): row\visible\_s( ): EndMacro
    Macro VisibleFirstRow( ): row\visible\first: EndMacro
    Macro VisibleLastRow( ): row\visible\last: EndMacro
    
    Macro EnteredLineIndex( ): index[1]: EndMacro ; *this\ Returns mouse entered row  ; 31 count
    Macro FocusedLineIndex( ): index[2]: EndMacro ; *this\ Returns key focused row    ; 11 count
    Macro PressedLineIndex( ): index[3]: EndMacro ; *this\ Returns mouse pressed line ; 23 count
    
    Macro EnteredButton( ): mouse( )\entered\button: EndMacro
    Macro PressedButton( ): mouse( )\pressed\button: EndMacro
    
    Macro LeavedWidget( ): mouse( )\leaved\widget: EndMacro   ; Returns mouse leaved widget
    Macro EnteredWidget( ): mouse( )\entered\widget: EndMacro ; Returns mouse entered widget
    Macro PressedWidget( ): mouse( )\pressed\widget: EndMacro
    Macro FocusedWidget( ): Keyboard( )\focused\widget: EndMacro ; Returns keyboard focus widget
    Macro EnteredItem( ): EnteredWidget( )\EnteredRow( ): EndMacro
    
    Macro ClosedWidget( ): last\root : EndMacro
    Macro OpenedWidget( ): widget::*canvas\opened: EndMacro
    
    Macro PopupWindow( ): widget::*canvas\sticky\window: EndMacro
    Macro PopupWidget( ): widget::*canvas\sticky\widget: EndMacro
    
    Macro EventWidget( ): widget::*canvas\widget: EndMacro
    Macro EventIndex( ): EventWidget( )\index: EndMacro
    
    Macro WidgetEvent( ): widget::*canvas\event: EndMacro
    Macro WidgetEventType( ): WidgetEvent( )\type: EndMacro
    Macro WidgetEventItem( ): WidgetEvent( )\item: EndMacro
    Macro WidgetEventData( ): WidgetEvent( )\data: EndMacro
    
    ;-
    Macro WindowEvent( )
      events::WaitEvent( PB(WindowEvent)( ) )
    EndMacro
    Macro WaitWindowEvent( waittime = )
      events::WaitEvent( PB(WaitWindowEvent)( waittime ) )
    EndMacro
    
    
    
    ;-
    Macro ChangeCurrentRoot(_canvas_gadget_address_ )
      FindMapElement( widget::Root( ), Str( _canvas_gadget_address_ ) )
    EndMacro
    
    Macro PostCanvasRepaint( _address_, _data_ = #Null )
      ; Debug "-- post --- event -- repaint --1"
      If _address_\_root( ) And
         _address_\_root( )\canvas\repaint = #False
        _address_\_root( )\canvas\repaint = #True
        ; Debug "-- post --- event -- repaint --2 " +_address_\class +" "+ #PB_Compiler_Procedure
        If _data_ = #Null
          PostEvent( #PB_Event_Gadget, _address_\_root( )\canvas\window, _address_\_root( )\canvas\gadget, #__event_Repaint, _address_\_root( ) )
        Else
          PostEvent( #PB_Event_Gadget, _address_\_root( )\canvas\window, _address_\_root( )\canvas\gadget, #__event_Repaint, _data_ )
        EndIf
      EndIf
    EndMacro
    
    ;-
    Macro GetActive( ): Keyboard( )\window: EndMacro   ; Returns activeed window
    Macro GetMouseX( _mode_ = #__c_screen ): mouse( )\x[_mode_]: EndMacro ; Returns mouse x
    Macro GetMouseY( _mode_ = #__c_screen ): mouse( )\y[_mode_]: EndMacro ; Returns mouse y
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
    Macro scroll_x( ): x[#__c_required]: EndMacro
    Macro scroll_y( ): y[#__c_required]: EndMacro
    Macro scroll_width( ): width[#__c_required]: EndMacro
    Macro scroll_height( ): height[#__c_required]: EndMacro
    
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
      Bool( _parent_ = _this_\_parent( ) And Not ( _parent_\TabBox( ) And _this_\TabIndex( ) <> _parent_\TabBoxFocusedIndex( ) ))
    EndMacro
    Macro is_parent_one_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\_parent( ) = _address_2\_parent( ) And _address_1\TabIndex( ) = _address_2\TabIndex( ) )
    EndMacro
    
    Macro is_root_container_( _this_ )
      Bool( _this_\_root( ) And _this_ = _this_\_root( )\canvas\container )
    EndMacro
    
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
    
    Macro is_at_point_vertical_( _address_, _mouse_y_, _mode_ = )
      is_at_plane_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ )
    EndMacro
    
    Macro is_at_point_horizontal_( _address_, _mouse_x_, _mode_ = )
      is_at_plane_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ )
    EndMacro
    
    Macro is_at_point_( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( is_at_point_horizontal_( _address_, _mouse_x_, _mode_ ) And is_at_point_vertical_( _address_, _mouse_y_, _mode_ ))
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
    
    Macro is_interact_row_( _this_ )
      Bool( _this_\type = #__type_TabBar Or
            _this_\type = #__type_Splitter Or
            _this_\type = #__type_Editor Or
            _this_\type = #__type_IPAddress Or
            _this_\type = #__type_String Or
            _this_\type = #__type_Button Or
            _this_\type = #__type_Tree Or
            _this_\type = #__type_ListView Or
            _this_\type = #__type_ListIcon Or
            _this_\type = #__type_ExplorerTree Or
            _this_\type = #__type_ExplorerList )
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
    Macro a_transform( )
      mouse( )\_transform
    EndMacro
    Macro a_index( )
      a_transform( )\index
    EndMacro
    Macro a_selector( _index_= )
      a_transform( )\id#_index_
    EndMacro
    Macro a_anchors( _index_= )
      a_focused( )\_a_\id#_index_
    EndMacro
    Macro a_entered( )
      a_transform( )\e_widget
    EndMacro
    Macro a_focused( )
      a_transform( )\widget
    EndMacro
    Macro a_group( )
      a_transform( )\group( )
    EndMacro
    Macro a_set_state( _this_, _state_ )
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
      If _this_\TabBox( ) And Not _this_\TabBox( )\hide And _this_\TabBox( )\type
        _this_\TabBox( )\_a_\transform = _this_\_a_\transform
      EndIf
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
    
    Macro draw_font_( _this_ )
      ; drawing font
      If _this_\_root( )
        If _this_\text\fontID = #Null
          If _this_\_root( )\text\fontID
            _this_\text\fontID   = _this_\_root( )\text\fontID
            _this_\TextChange( ) = #True
          EndIf
        EndIf
        
        If _this_\text\fontID And (( _this_\_root( )\canvas\fontID <> _this_\text\fontID ) Or ( _this_ = _this_\_root( ) And _this_\_root( )\canvas\fontID ))
          _this_\_root( )\canvas\fontID = _this_\text\fontID
          
          ;; Debug "draw current font - " + #PB_Compiler_Procedure  + " " +  _this_ + " fontID - "+ _this_\text\fontID
          DrawingFont( _this_\text\fontID )
          _this_\TextChange( ) = #True
        EndIf
      EndIf
      
      If _this_\TextChange( )
        If _this_\text\string
          _this_\text\width = TextWidth( _this_\text\string )
        EndIf
        
        _this_\text\height = TextHeight( "A" ); - Bool( #PB_Compiler_OS <> #PB_OS_Windows ) * 2
        _this_\text\rotate = Bool( _this_\text\invert ) * 180 + Bool( _this_\text\vertical ) * 90
      EndIf
    EndMacro
    
    Macro draw_font_item_( _this_, _item_, _change_ )
      If _this_\_root( )
        If _item_\text\fontID = #Null
          If _this_\text\fontID = #Null
            If _this_\_parent( ) And is_integral_( _this_ )
              _this_\text\fontID = _this_\_parent( )\text\fontID
              _this_\text\height = _this_\_parent( )\text\height
            Else
              _this_\text\fontID = _this_\_root( )\text\fontID
              _this_\text\height = _this_\_root( )\text\height
            EndIf
          EndIf
          
          _item_\text\fontID   = _this_\text\fontID
          _item_\text\height   = _this_\text\height
          _item_\TextChange( ) = #True
        EndIf
        ;Debug ""+_this_\_root( )\canvas\fontID +" "+ _item_\text\fontID
        
        ;\\ drawing item font
        If _item_\text\fontID And _this_\_root( )\canvas\fontID <> _item_\text\fontID
          ;;Debug " item fontID - "+ _item_\text\fontID
          _this_\_root( )\canvas\fontID = _item_\text\fontID
          
          Debug "draw current item font - " + #PB_Compiler_Procedure + " " + _this_ + " " + _item_\index + " fontID - " + _item_\text\fontID
          DrawingFont( _item_\text\fontID )
          _item_\text\height   = TextHeight( "A" )
          _item_\TextChange( ) = #True
        EndIf
      EndIf
      
      ;\\ Получаем один раз после изменения текста
      If _item_\TextChange( )
        If _item_\text\string
          _item_\text\width = TextWidth( _item_\text\string )
        EndIf
        
        _item_\TextChange( ) = #False
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
    
    Macro draw_size_all_(_x_, _y_, _size_, _back_color_, _frame_color_)
    EndMacro
    
    Macro draw_plus_( _address_, _plus_, _size_ = 5 )
      Line(_address_\x + (_address_\width - _size_) / 2, _address_\y + (_address_\height - 1) / 2, _size_, 1, _address_\color\front[_address_\color\state])
      If _plus_
        Line(_address_\x + (_address_\width - 1) / 2, _address_\y + (_address_\height - _size_) / 2, 1, _size_, _address_\color\front[_address_\color\state])
      EndIf
    EndMacro
    
    Macro draw_arrows_( _address_, _type_ )
      Arrow( _address_\x + ( _address_\width - _address_\arrow\size ) / 2,
             _address_\y + ( _address_\height - _address_\arrow\size ) / 2, _address_\arrow\size, _type_,
             _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24, _address_\arrow\type )
    EndMacro
    
    Macro draw_gradient_( _vertical_, _address_, _color_fore_, _color_back_, _mode_ = )
      BackColor( _color_fore_ & $FFFFFF | _address_\color\_alpha << 24 )
      FrontColor( _color_back_ & $FFFFFF | _address_\color\_alpha << 24 )
      
      If _vertical_  ; _address_\vertical
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, ( _address_\x#_mode_ + _address_\width#_mode_ ), _address_\y#_mode_ )
      Else
        LinearGradient( _address_\x#_mode_, _address_\y#_mode_, _address_\x#_mode_, ( _address_\y#_mode_ + _address_\height#_mode_ ))
      EndIf
      
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      
      BackColor( #PB_Default )
      FrontColor( #PB_Default ) ; bug
    EndMacro
    
    Macro draw_gradient_box_( _vertical_, _x_, _y_, _width_, _height_, _color_1_, _color_2_, _round_ = 0, _alpha_ = 255 )
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
    
    Macro draw_box( _address_, _color_type_, _mode_ = )
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_,
                      _address_\round, _address_\round, _address_\_color_type_[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
    EndMacro
    
    Macro draw_box_button_( _address_, _color_type_ )
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
        draw_roundbox_( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
        draw_roundbox_( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
      EndIf
    EndMacro
    
    Macro draw_close_button_( _address_, _size_ )
      ; close button
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          
          Line( _address_\x - 1 + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_maximize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          
          Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_minimize_button_( _address_, _size_ )
      If Not _address_\hide
        If _address_\color\state
          Line( _address_\x + 1 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x + 0 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          
          Line( _address_\x - 1 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
          Line( _address_\x - 2 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
        EndIf
        
        draw_box_button_( _address_, color\frame )
      EndIf
    EndMacro
    
    Macro draw_help_button_( _address_, _size_ )
      If Not _address_\hide
        draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height,
                        _address_\round, _address_\round, _address_\color\frame[_address_\color\state] & $FFFFFF | _address_\color\_alpha << 24 )
      EndIf
    EndMacro
    
    Macro draw_option_button_( _address_, _size_, _color_ )
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
    
    Macro draw_check_button_( _address_, _size_, _color_ )
      If _address_\state\check
        LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 4 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
        LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
        
        LineXY(( _address_\x + 5 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 2 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
        LineXY(( _address_\x + 6 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 3 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
      EndIf
    EndMacro
    
    Macro draw_button_( _type_, _x_, _y_, _width_, _height_, _checked_, _round_, _color_fore_ = $FFFFFFFF, _color_fore2_ = $FFE9BA81, _color_back_ = $80E2E2E2, _color_back2_ = $FFE89C3D, _color_frame_ = $80C8C8C8, _color_frame2_ = $FFDC9338, _alpha_ = 255 )
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
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
      
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _checked_
        FrontColor( _color_frame2_ & $FFFFFF | _alpha_ << 24 )
      Else
        FrontColor( _color_frame_ & $FFFFFF | _alpha_ << 24 )
      EndIf
      
      draw_roundbox_( _x_, _y_, _width_, _height_, _round_, _round_, _color_frame_ & $FFFFFF | _alpha_ << 24 )
    EndMacro
    
    Macro Close( )
      PB(CloseGadgetList)( )
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
    
    Declare EventHandler ( canvas.i = - 1, eventtype.i = - 1, eventdata = 0 )
    Declare WaitClose( *this = #PB_Any, waittime.l = 0 )
    Declare Message( Title.s, Text.s, flag.q = #Null )
    
    Declare.i Tree_properties( x.l, y.l, width.l, height.l, flag.q = 0 )
    
    Declare a_init( *this, grid_size.a = 7, grid_type.b = 0 )
    Declare a_set( *this, size.l = #PB_Ignore, position.l = #PB_Ignore )
    Declare a_update( *parent )
    
    Declare.i SetAttachment( *this, *parent, mode.a )
    Declare.i SetAlignment( *this, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
    Declare SetFrame( *this, size.a, mode.i = 0 )
    Declare a_object( x.l, y.l, width.l, height.l, text.s, Color.l, flag.q = #Null, framesize = 1 )
    
    Declare.i TypeFromClass( class.s )
    Declare.s ClassFromType( type.i )
    Declare.b IsContainer( *this )
    
    Declare.b Draw( *this )
    Declare ReDraw( *this )
    
    Declare.l x( *this, mode.l = #__c_frame )
    Declare.l Y( *this, mode.l = #__c_frame )
    Declare.l Width( *this, mode.l = #__c_frame )
    Declare.l Height( *this, mode.l = #__c_frame )
    
    Declare.b Hide( *this, State.b = #PB_Default )
    Declare.b Disable( *this, State.b = #PB_Default )
    Declare.i Sticky( *window = #PB_Default, state.b = #PB_Default )
    Declare.i Display( *this, *display, x = #PB_Ignore, y = #PB_Ignore )
    
    Declare.b Update( *this )
    Declare IsChild( *this, *parent )
    Declare.q Flag( *this, flag.q = #Null, state.b = #PB_Default )
    Declare.b Resize( *this, ix.l, iy.l, iwidth.l, iheight.l )
    Declare MoveBounds( *this, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
    Declare SizeBounds( *this, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
    
    Declare.l CountItems( *this )
    Declare.l ClearItems( *this )
    Declare RemoveItem( *this, Item.l )
    
    ;;Declare.b GetFocus( *this )
    Declare.l GetButtons( )
    Declare.l GetIndex( *this )
    Declare.l GetDeltaX( *this )
    Declare.l GetDeltaY( *this )
    Declare.l GetLevel( *this )
    Declare.l GetType( *this )
    Declare.i GetRoot( *this )
    
    Declare.i GetWindow( *this = #Null )
    Declare.i GetGadget( *this = #Null )
    
    Declare GetWidget( index )
    Declare.l GetCount( *this, mode.b = #False )
    Declare.i GetItem( *this, parent_sublevel.l = - 1 )
    
    Declare GetLast( *last, tabindex.l )
    
    Declare.i GetAddress( *this )
    ;
    Declare.i SetActive( *this )
    
    Declare.s GetClass( *this )
    Declare SetClass( *this, class.s )
    
    Declare.s GetText( *this )
    Declare SetText( *this, Text.s )
    
    Declare.i GetData( *this )
    Declare.i SetData( *this, *data )
    
    Declare.i GetFont( *this )
    Declare.i SetFont( *this, FontID.i )
    
    Declare.f GetState( *this )
    Declare.b SetState( *this, state.f )
    
    Declare.i GetParent( *this )
    Declare SetParent( *this, *parent, tabindex.l = 0 )
    
    Declare GetPosition( *this, position.l )
    Declare SetPosition( *this, position.l, *widget = #Null )
    
    Declare.l GetColor( *this, ColorType.l )
    Declare.l SetColor( *this, ColorType.l, Color.l, Column.l = 0 )
    
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
    
    Declare.i GetItemAttribute( *this, Item.l, Attribute.l, Column.l = 0 )
    Declare.i SetItemAttribute( *this, Item.l, Attribute.l, *value, Column.l = 0 )
    
    Declare SetCursor( *this, *cursor )
    
    Declare SetImage( *this, *image )
    Declare SetBackgroundImage( *this, *image )
    
    Declare.i Create( *parent, class.s, type.l, x.l, y.l, width.l, height.l, Text.s = #Null$, flag.q = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 0, ScrollStep.f = 1.0 )
    
    ; button
    Declare.i Text( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
    Declare.i String( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
    Declare.i Button( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, Image.i = -1, round.l = 0 )
    Declare.i Option( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
    Declare.i Checkbox( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
    Declare.i HyperLink( x.l, y.l, width.l, height.l, Text.s, Color.i, flag.q = 0 )
    Declare.i ComboBox( x.l, y.l, width.l, height.l, flag.q = 0 )
    
    ; bar
    Declare.i Spin( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0, increment.f = 1.0 )
    Declare.i Tab( x.l, y.l, width.l, height.l, flag.q = 0, round.l = 0 )
    Declare.i Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
    Declare.i Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 7 )
    Declare.i Progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
    Declare.i Splitter( x.l, y.l, width.l, height.l, First.i, Second.i, flag.q = 0 )
    
    ; list
    Declare.i Tree( x.l, y.l, width.l, height.l, flag.q = 0 )
    Declare.i ListView( x.l, y.l, width.l, height.l, flag.q = 0 )
    Declare.i Editor( x.l, Y.l, width.l, height.l, flag.q = 0, round.i = 0 )
    Declare.i ListIcon( x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.i, flag.q = 0 )
    
    Declare.i ExplorerList( x.l, y.l, width.l, height.l, Directory.s, flag.q = 0 )
    
    Declare.i Image( x.l, y.l, width.l, height.l, image.i, flag.q = 0 )
    Declare.i ButtonImage( x.l, y.l, width.l, height.l, Image.i = -1, flag.q = 0, round.l = 0 )
    
    ; container
    Declare.i Panel( x.l, y.l, width.l, height.l, flag.q = 0 )
    Declare.i Container( x.l, y.l, width.l, height.l, flag.q = 0 )
    Declare.i Frame( x.l, y.l, width.l, height.l, Text.s, flag.q = #__flag_nogadgets )
    Declare.i Window( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, *parent = 0 )
    Declare.i ScrollArea( x.l, y.l, width.l, height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, flag.q = 0 )
    Declare.i MDI( x.l, y.l, width.l, height.l, flag.q = 0 )
    
    ; menu
    Declare ToolBar( *parent, flag.q = #PB_ToolBar_Small )
    ;     Declare   Menus( *parent, flag.q )
    ;     Declare   PopupMenu( *parent, flag.q )
    
    Declare.l bar_setAttribute( *this, Attribute.l, *value )
    Declare.i bar_tab_SetState( *this, State.l )
    Declare bar_mdi_update( *this, x.l, y.l, width.l, height.l )
    Declare bar_Resizes( *this, x.l, y.l, width.l, height.l )
    Declare.b bar_Change( *this, ScrollPos.l )
    
    Declare AddItem( *this, Item.l, Text.s, Image.i = -1, flag.q = 0 )
    Declare AddColumn( *this, Position.l, Text.s, Width.l, Image.i = - 1 )
    
    Declare.b Arrow( x.l, Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
    
    Declare.i Post( *this, eventtype.l, *button = #PB_All, *data = #Null )
    Declare.i Bind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    Declare.i Unbind( *this, *callback, eventtype.l = #PB_All, item.l = #PB_All )
    
    ;
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    ;
    Declare DoEvents( *this, eventtype.l, *data = #Null, *button = #PB_All ) ;, mouse_x.l, mouse_y.l
    Declare Open( Window, x.l = 0, y.l = 0, width.l = #PB_Ignore, height.l = #PB_Ignore, title$ = #Null$, flag.q = #Null, *parentID = #Null, *callback = #Null, canvas = #PB_Any )
    Declare.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l, height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, flag.q = #Null, Window = -1, *CallBack = #Null )
    Declare Free( *this )
    ;}
  EndDeclareModule
  
  Module Widget
    ;-
    ;-\\ DECLARE PRIVATEs
    ;-
    Declare.b bar_tab_draw( *this )
    Declare.b bar_Update( *this, mode.b = 1 )
    Declare.b bar_SetState( *this, state.l )
    
    Declare.l update_visible_items_( *this._S_widget, visible_items_height.l = 0 )
    Declare.l draw_items_( *this._S_widget, List *rows._S_rows( ), _scroll_x_, _scroll_y_ )
    Declare Text_Update( *this._S_widget )
    
    ;\\
    Macro row_x_( _this_, _address_ )
      ( _this_\x[#__c_inner] + _address_\x )  ; + _this_\scroll_x( )
    EndMacro
    
    Macro row_y_( _this_, _address_ )
      ( _this_\y[#__c_inner] + _address_\y )
    EndMacro
    
    Macro row_scroll_y_( _this_, _row_, _page_height_ = )
      bar_scroll_pos_( _this_\scroll\v, ( row_y_( _this_, _row_ ) _page_height_ ) - _this_\scroll\v\y, _row_\height )
    EndMacro
    
    ;-
    Macro make_scrollarea_x( _this_, _address_ )
      ; make horizontal scroll x
      If _address_\align\right
        _this_\scroll_x( ) = ( _this_\width[#__c_inner] - _this_\scroll_width( ) )
      ElseIf Not _address_\align\left ; horizontal center
        _this_\scroll_x( ) = ( _this_\width[#__c_inner] - _this_\scroll_width( )) / 2
      Else
        If _this_\scroll\h
          _this_\scroll_x( ) = - ( _this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min )
        Else
          _this_\scroll_x( ) = 0
        EndIf
      EndIf
    EndMacro
    
    Macro make_scrollarea_y( _this_, _address_, _rotate_ = 0 )
      ; make vertical scroll y
      If _address_\align\bottom
        _this_\scroll_y( ) = ( _this_\height[#__c_inner] - _this_\scroll_height( ) )
      ElseIf Not _address_\align\top ; vertical center
        _this_\scroll_y( ) = ( _this_\height[#__c_inner] - _this_\scroll_height( ) ) / 2
        ;           If _this_\_box_ And _this_\_box_\height And Not _address_\align\left And Not _address_\align\right
        ;             If _rotate_ = 0
        ;               _this_\scroll_y( ) = ( _this_\height[#__c_inner] - _this_\scroll_height( ) + _this_\_box_\height ) / 2
        ;             Else
        ;               _this_\scroll_y( ) = ( _this_\height[#__c_inner] - _this_\scroll_height( ) - _this_\_box_\height ) / 2
        ;             EndIf
        ;           Else
        ;             _this_\scroll_y( ) = ( _this_\height[#__c_inner] - _this_\scroll_height( ) ) / 2
        ;           EndIf
      Else
        If _this_\scroll\v
          _this_\scroll_y( ) = - ( _this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min )
        Else
          _this_\scroll_y( ) = 0
        EndIf
      EndIf
    EndMacro
    
    
    ;-
    Macro set_align_x_( _this_, _address_, _width_, _rotate_ )
      If _rotate_ = 180
        If _this_\align\right
          _address_\x = _width_ - _this_\padding\x
        ElseIf Not _this_\align\left
          _address_\x = ( _width_ + _address_\width ) / 2
        Else
          _address_\x = _address_\width + _this_\padding\x
        EndIf
      EndIf
      
      If _rotate_ = 0
        If _this_\align\right
          _address_\x = ( _width_ - _address_\width ) - _this_\padding\x
        ElseIf Not _this_\align\left
          _address_\x = ( _width_ - _address_\width ) / 2
        Else
          _address_\x = _this_\padding\x
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
          _address_\y = - Bool( #PB_Compiler_OS = #PB_OS_MacOS )
        EndIf
      EndIf
      
      If _height_ >= 0
        If _rotate_ = 90
          If _this_\align\bottom
            _address_\y = _height_ - _this_\padding\y
          ElseIf Not _this_\align\top
            _address_\y = ( _height_ + _address_\width ) / 2
          Else
            _address_\y = _address_\width + _this_\padding\y
          EndIf
        EndIf
        
        If _rotate_ = 270
          If _this_\align\bottom
            _address_\y = ( _height_ - _address_\width ) - _this_\padding\y
          ElseIf Not _this_\align\top
            _address_\y = ( _height_ - _address_\width ) / 2
          Else
            _address_\y = _this_\padding\y
          EndIf
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
        
        If _this_\row
          _this_\row\margin\width = _address_\padding\x +
                                    _address_\width + 2
        EndIf
      Else
        _address_\change = - 1
        _address_\img    = - 1
        _address_\id     = 0
        _address_\width  = 0
        _address_\height = 0
      EndIf
    EndMacro
    
    Macro set_text_flag_( _this_, _text_, _flag_, _x_ = 0, _y_ = 0 )
      ;     If Not _this_\text
      ;       _this_\text.allocate( TEXT )
      ;     EndIf
      
      If _this_\text
        _this_\TextChange( ) = 1
        _this_\text\x        = _x_
        _this_\text\y        = _y_
        
        _this_\text\editable = Bool( Not constants::_check_( _flag_, #__text_readonly ))
        _this_\text\lower    = constants::_check_( _flag_, #__text_lowercase )
        _this_\text\upper    = constants::_check_( _flag_, #__text_uppercase )
        _this_\text\pass     = constants::_check_( _flag_, #__text_password )
        _this_\text\invert   = constants::_check_( _flag_, #__text_invert )
        _this_\text\vertical = constants::_check_( _flag_, #__text_vertical )
        
        ;
        _this_\text\align\left  = constants::_check_( _flag_, #__text_left )
        _this_\text\align\right = constants::_check_( _flag_, #__text_right )
        
        _this_\text\align\top    = constants::_check_( _flag_, #__text_top )
        _this_\text\align\bottom = constants::_check_( _flag_, #__text_bottom )
        
        If Not _this_\text\align\top And
           Not _this_\text\align\left And
           Not _this_\text\align\right And
           Not _this_\text\align\bottom And
           Not constants::_check_( _flag_, #__text_center )
          
          If Not _this_\text\align\right
            _this_\flag | #__text_left
            _this_\text\align\left = #True
          EndIf
          If Not _this_\text\align\bottom
            _this_\flag | #__text_top
            _this_\text\align\top = #True
          EndIf
        EndIf
        
        
        If constants::_check_( _flag_, #__text_wordwrap )
          _this_\text\multiLine = - 1
        ElseIf constants::_check_( _flag_, #__text_multiline )
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0
        EndIf
        
        ;         ; padding
        ;       If _this_\type = #__type_Text
        ;         _this_\text\padding\x = 1
        ;       ElseIf _this_\type = #__type_Button
        ;         _this_\text\padding\x = 4
        ;         _this_\text\padding\y = 4
        ;       ElseIf _this_\type = #__type_Editor
        ;         _this_\text\padding\y = 6
        ;         _this_\text\padding\x = 6
        ;       ElseIf _this_\type = #__type_String
        ;         _this_\text\padding\x = 3
        ;         _this_\text\padding\y = 0
        ;
        ;       ElseIf _this_\type = #__type_Option Or
        ;              _this_\type = #__type_CheckBox
        ;         _this_\text\padding\x = _this_\_box_\width + 8
        ;       EndIf
        
        ;\\
        text_rotate_( _this_\text )
        
        ;\\
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0]    = $FFFFFFFF
          Else
            _this_\color\back[0] = $FFF0F0F0
          EndIf
          
          ;\\
          If _this_\type = #__type_Editor
            If Not _this_\text\multiLine
              _this_\text\multiLine = 1
            EndIf
            ;           Else
            ;             _this_\text\multiline = constants::_check_( _this_\flag, #__string_multiline )
          EndIf
        EndIf
        
        ;\\
        If _this_\type = #__type_Option Or
           _this_\type = #__type_CheckBox Or
           _this_\type = #__type_HyperLink
          
          _this_\text\multiline = - CountString( _text_, #LF$ )
        EndIf
        
        If _this_\type = #__type_String
          If _this_\text\multiline
            _this_\row\margin\hide        = 0
            _this_\row\margin\color\front = $C8000000 ; \color\back[0]
            _this_\row\margin\color\back  = $C8F0F0F0 ; \color\back[0]
          Else
            _this_\row\margin\hide = 1
            _this_\text\numeric    = Bool( _flag_ & #__string_numeric )
          EndIf
        EndIf
        
        If _text_
          SetText( _this_, _text_ )
        EndIf
      EndIf
      
    EndMacro
    
    Macro set_check_state_( _address_, _three_state_ )
      ; change checkbox state
      Select _address_\state\check
        Case #PB_Checkbox_Unchecked
          If _three_state_
            _address_\state\check = #PB_Checkbox_Inbetween
          Else
            _address_\state\check = #PB_Checkbox_Checked
          EndIf
        Case #PB_Checkbox_Checked : _address_\state\check = #PB_Checkbox_Unchecked
        Case #PB_Checkbox_Inbetween : _address_\state\check = #PB_Checkbox_Checked
      EndSelect
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
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ;     Macro OSX_NSColorToRGB( _color_ )
      ;       _color_
      ;     EndMacro
      ;     Macro BlendColor_(Color1, Color2, Scale=50)
      ;       Color1
      ;     EndMacro
      
      Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i = 50)
        Define.i R1, G1, B1, R2, G2, B2
        Define.f Blend = Scale / 100
        
        R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
        R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
        
        ProcedureReturn RGB((R1*Blend) + (R2 * (1 - Blend)), (G1*Blend) + (G2 * (1 - Blend)), (B1*Blend) + (B2 * (1 - Blend)))
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
    
    Procedure CreateIcon( img.l, type.l )
      Protected x, y, Pixel, size = 8, index.i
      
      index = CreateImage( img, size, size )
      If img = - 1 : img = index : EndIf
      
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
          For y = size - 1 To 0 Step - 1
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
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        Data.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        
        
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
          Line(_x_ + 8, _y_ - 2, 1, 11, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_ + 7, _y_ - 1, _frame_color_ ) : Plot(_x_ + 7, _y_ + 7, _frame_color_ )
          Plot(_x_ + 6, _y_ + 0, _frame_color_ ) : Plot(_x_ + 6, _y_ + 6, _frame_color_ )
          Plot(_x_ + 5, _y_ + 1, _frame_color_ ) : Plot(_x_ + 5, _y_ + 5, _frame_color_ )
          Plot(_x_ + 4, _y_ + 2, _frame_color_ ) : Plot(_x_ + 4, _y_ + 4, _frame_color_ )
          Plot(_x_ + 3, _y_ + 3, _frame_color_)
        EndIf
        Line(_x_ + 7, _y_ + 0, 1, 7, _back_color_)
        Line(_x_ + 6, _y_ + 1, 1, 5, _back_color_)
        Line(_x_ + 5, _y_ + 2, 1, 3, _back_color_)
        Plot(_x_ + 4, _y_ + 3, _back_color_)
      ElseIf _direction_ = 1 ; up
        If _frame_color_ <> _back_color_
          Line(_x_ - 1, _y_ + 7, 11, 1, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_ + 0, _y_ + 6, _frame_color_ ) : Plot(_x_ + 8, _y_ + 6, _frame_color_ )
          Plot(_x_ + 1, _y_ + 5, _frame_color_ ) : Plot(_x_ + 7, _y_ + 5, _frame_color_ )
          Plot(_x_ + 2, _y_ + 4, _frame_color_ ) : Plot(_x_ + 6, _y_ + 4, _frame_color_ )
          Plot(_x_ + 3, _y_ + 3, _frame_color_ ) : Plot(_x_ + 5, _y_ + 3, _frame_color_ )
          Plot(_x_ + 4, _y_ + 2, _frame_color_)
        EndIf
        Line(_x_ + 1, _y_ + 6, 7, 1, _back_color_)
        Line(_x_ + 2, _y_ + 5, 5, 1, _back_color_)
        Line(_x_ + 3, _y_ + 4, 3, 1, _back_color_)
        Plot(_x_ + 4, _y_ + 3, _back_color_)
      ElseIf _direction_ = 2 ; right
        If _frame_color_ <> _back_color_
          Line(_x_ + 3, _y_ - 2, 1, 11, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_ + 4, _y_ - 1, _frame_color_ ) : Plot(_x_ + 4, _y_ + 7, _frame_color_ )
          Plot(_x_ + 5, _y_ + 0, _frame_color_ ) : Plot(_x_ + 5, _y_ + 6, _frame_color_ )
          Plot(_x_ + 6, _y_ + 1, _frame_color_ ) : Plot(_x_ + 6, _y_ + 5, _frame_color_ )
          Plot(_x_ + 7, _y_ + 2, _frame_color_ ) : Plot(_x_ + 7, _y_ + 4, _frame_color_ )
          Plot(_x_ + 8, _y_ + 3, _frame_color_)
        EndIf
        Line(_x_ + 4, _y_ + 0, 1, 7, _back_color_)
        Line(_x_ + 5, _y_ + 1, 1, 5, _back_color_)
        Line(_x_ + 6, _y_ + 2, 1, 3, _back_color_)
        Plot(_x_ + 7, _y_ + 3, _back_color_)
      ElseIf _direction_ = 3 ; down
        If _frame_color_ <> _back_color_
          Line(_x_ - 1, _y_ + 2, 11, 1, _frame_color_)                                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0
          Plot(_x_ + 0, _y_ + 3, _frame_color_ ) : Plot(_x_ + 8, _y_ + 3, _frame_color_ )
          Plot(_x_ + 1, _y_ + 4, _frame_color_ ) : Plot(_x_ + 7, _y_ + 4, _frame_color_ )
          Plot(_x_ + 2, _y_ + 5, _frame_color_ ) : Plot(_x_ + 6, _y_ + 5, _frame_color_ )
          Plot(_x_ + 3, _y_ + 6, _frame_color_ ) : Plot(_x_ + 5, _y_ + 6, _frame_color_ )
          Plot(_x_ + 4, _y_ + 7, _frame_color_)
        EndIf
        Line(_x_ + 1, _y_ + 3, 7, 1, _back_color_)
        Line(_x_ + 2, _y_ + 4, 5, 1, _back_color_)
        Line(_x_ + 3, _y_ + 5, 3, 1, _back_color_)
        Plot(_x_ + 4, _y_ + 6, _back_color_)
      EndIf
    EndMacro
    
    Procedure DrawArrow( x.l, y.l, Direction.l, color.l )
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
        Plot( x + 1, y + 4, color ) : Plot( x + 2, y + 4, color ) : Plot( x + 4, y + 4, color ) : Plot( x + 5, y + 4, color )                               ; 0,1,1,0,1,1,0
        Plot( x + 1, y + 5, color ) : Plot( x + 5, y + 5, color )                                                                                           ; 0,1,0,0,0,1,0
                                                                                                                                                            ; 0,0,0,0,0,0,0
                                                                                                                                                            ; 0,0,0,0,0,0,0
      EndIf
      If Direction = 3
        ; down                                                                                                                                                ; 0,0,0,0,0,0,0
        Plot( x + 1, y + 1, color ) : Plot( x + 5, y + 1, color )   ; 0,1,0,0,0,1,0
        Plot( x + 1, y + 2, color ) : Plot( x + 2, y + 2, color ) : Plot( x + 4, y + 2, color ) : Plot( x + 5, y + 2, color )   ; 0,1,1,0,1,1,0
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
        
        : Plot( x + 5, y, color )
        : Plot( x + 4, y + 1, color ) : Plot( x + 5, y + 1, color ) : Plot( x + 6, y + 1, color )
        : Plot( x + 3, y + 2, color ) : Plot( x + 4, y + 2, color ) : Plot( x + 6, y + 2, color ) : Plot( x + 7, y + 2, color )
        : Plot( x + 2, y + 3, color ) : Plot( x + 3, y + 3, color ) : Plot( x + 7, y + 3, color ) : Plot( x + 8, y + 3, color )
        : Plot( x + 1, y + 4, color ) : Plot( x + 2, y + 4, color ) : Plot( x + 8, y + 4, color ) : Plot( x + 9, y + 4, color )
        : Plot( x, y + 5, color ) : Plot( x + 1, y + 5, color ) : Plot( x + 9, y + 5, color ) : Plot( x + 10, y + 5, color )
        
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
        
        : Plot( x, y, color ) : Plot( x + 1, y, color ) : Plot( x + 9, y, color ) : Plot( x + 10, y, color )
        : Plot( x + 1, y + 1, color ) : Plot( x + 2, y + 1, color ) : Plot( x + 8, y + 1, color ) : Plot( x + 9, y + 1, color )
        : Plot( x + 2, y + 2, color ) : Plot( x + 3, y + 2, color ) : Plot( x + 7, y + 2, color ) : Plot( x + 8, y + 2, color )
        : Plot( x + 3, y + 3, color ) : Plot( x + 4, y + 3, color ) : Plot( x + 6, y + 3, color ) : Plot( x + 7, y + 3, color )
        : Plot( x + 4, y + 4, color ) : Plot( x + 5, y + 4, color ) : Plot( x + 6, y + 4, color )
        : Plot( x + 5, y + 5, color )
        
        :
      EndIf
      
    EndProcedure
    
    Procedure.b Arrow( x.l, Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1 )
      ; ProcedureReturn DrawArrow( x,y, Direction, Color )
      
      Protected I
      ;Size - 2
      
      If Not Length
        Style = - 1
      EndIf
      Length = ( Size + 2 ) / 2
      
      
      If Direction = 1 ; top
        If Style > 0 : x - 1 : y + 2
          Size / 2
          For i = 0 To Size
            LineXY(( x + 1 + i ) + Size, ( Y + i - 1 ) - ( Style ), ( x + 1 + i ) + Size, ( Y + i - 1 ) + ( Style ), Color )         ; Левая линия
            LineXY(( ( x + 1 + ( Size )) - i ), ( Y + i - 1 ) - ( Style ), (( x + 1 + ( Size )) - i ), ( Y + i - 1 ) + ( Style ), Color ) ; правая линия
          Next
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style = - 1
              LineXY( x + i, ( Size + y ), x + Length, y, Color )
              LineXY( x + Length * 2 - i, ( Size + y ), x + Length, y, Color )
            Else
              LineXY( x + i, ( Size + y ) - i / 2, x + Length, y, Color )
              LineXY( x + Length * 2 - i, ( Size + y ) - i / 2, x + Length, y, Color )
            EndIf
          Next
          i                                              = Bool( Style = - 1 )
          LineXY( x, ( Size + y ) + Bool( i              = 0 ), x + Length, y + 1, Color )
          LineXY( x + Length * 2, ( Size + y ) + Bool( i = 0 ), x + Length, y + 1, Color ) ; bug
        EndIf
      ElseIf Direction = 3 ; bottom
        If Style > 0 : x - 1 : y + 1;2
          Size / 2
          For i = 0 To Size
            LineXY(( x + 1 + i ), ( Y + i ) - ( Style ), ( x + 1 + i ), ( Y + i ) + ( Style ), Color ) ; Левая линия
            LineXY(( ( x + 1 + ( Size * 2 )) - i ), ( Y + i ) - ( Style ), (( x + 1 + ( Size * 2 )) - i ), ( Y + i ) + ( Style ), Color ) ; правая линия
          Next
        Else : x - 1 : y + 1
          For i = 0 To Length
            If Style = - 1
              LineXY( x + i, y, x + Length, ( Size + y ), Color )
              LineXY( x + Length * 2 - i, y, x + Length, ( Size + y ), Color )
            Else
              LineXY( x + i, y + i / 2 - Bool( i              = 0 ), x + Length, ( Size + y ), Color )
              LineXY( x + Length * 2 - i, y + i / 2 - Bool( i = 0 ), x + Length, ( Size + y ), Color )
            EndIf
          Next
        EndIf
      ElseIf Direction = 0 ; в лево
        If Style > 0 : y - 1
          Size / 2
          For i = 0 To Size
            ; в лево
            LineXY(( ( x + 1 ) + i ) - ( Style ), (( ( Y + 1 ) + ( Size )) - i ), (( x + 1 ) + i ) + ( Style ), (( ( Y + 1 ) + ( Size )) - i ), Color ) ; правая линия
            LineXY(( ( x + 1 ) + i ) - ( Style ), (( Y + 1 ) + i ) + Size, (( x + 1 ) + i ) + ( Style ), (( Y + 1 ) + i ) + Size, Color )               ; Левая линия
          Next
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style = - 1
              LineXY(( Size + x ), y + i, x, y + Length, Color )
              LineXY(( Size + x ), y + Length * 2 - i, x, y + Length, Color )
            Else
              LineXY(( Size + x ) - i / 2, y + i, x, y + Length, Color )
              LineXY(( Size + x ) - i / 2, y + Length * 2 - i, x, y + Length, Color )
            EndIf
          Next
          i                             = Bool( Style = - 1 )
          LineXY(( Size + x ) + Bool( i = 0 ), y, x + 1, y + Length, Color )
          LineXY(( Size + x ) + Bool( i = 0 ), y + Length * 2, x + 1, y + Length, Color )
        EndIf
      ElseIf Direction = 2 ; в право
        If Style > 0 : y - 1 ;: x + 1
          Size / 2
          For i = 0 To Size
            ; в право
            LineXY(( ( x + 1 ) + i ) - ( Style ), (( Y + 1 ) + i ), (( x + 1 ) + i ) + ( Style ), (( Y + 1 ) + i ), Color ) ; Левая линия
            LineXY(( ( x + 1 ) + i ) - ( Style ), (( ( Y + 1 ) + ( Size * 2 )) - i ), (( x + 1 ) + i ) + ( Style ), (( ( Y + 1 ) + ( Size * 2 )) - i ), Color ) ; правая линия
          Next
        Else : y - 1 : x + 1
          For i = 0 To Length
            If Style = - 1
              LineXY( x, y + i, Size + x, y + Length, Color )
              LineXY( x, y + Length * 2 - i, Size + x, y + Length, Color )
            Else
              LineXY( x + i / 2 - Bool( i = 0 ), y + i, Size + x, y + Length, Color )
              LineXY( x + i / 2 - Bool( i = 0 ), y + Length * 2 - i, Size + x, y + Length, Color )
            EndIf
          Next
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i Match( *value, Grid.i, Max.i = $7FFFFFFF )
      If Grid
        *value = Round(( *value / Grid ), #PB_Round_Nearest ) * Grid
        
        If *value > Max
          *value = Max
        EndIf
      EndIf
      
      ProcedureReturn *value
      ;   Procedure.i Match( *value.i, Grid.i, Max.i = $7FFFFFFF )
      ;     ProcedureReturn (( Bool( *value>Max ) * Max ) + ( Bool( Grid And *value<Max ) * ( Round(( *value/Grid ), #PB_round_nearest ) * Grid ) ))
    EndProcedure
    
    Procedure Draw_Datted( x, Y, SourceColor, TargetColor )
      Static Len.b
      Protected Color,
                Dot = a_transform( )\dot_ted,
                Space.b = a_transform( )\dot_space,
                line.b = a_transform( )\dot_line
      
      ;             Dot = 1
      ;             Space = 4
      ;             line = 8
      
      If Len <= Bool(Dot) * (space + 1) + Space + line
        If Len <= Bool(Dot) * (space + 1) + Space
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
    
    Procedure Draw_Plot( x, Y, SourceColor, TargetColor )
      Protected Color
      
      If (y % 2 And Not x % 2) Or
         (x % 2 And Not y % 2)
        
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    
    
    ;-\\ DD
    Macro DropState( _this_ )
      If _this_\drop And _this_\state\enter = 2 And
         _this_\drop\format = mouse( )\drag\format And
         _this_\drop\actions & mouse( )\drag\actions And
         ( _this_\drop\private = mouse( )\drag\private Or
           _this_\drop\private & mouse( )\drag\private )
        
        If mouse( )\drag\state <> #PB_Drag_Enter
          mouse( )\drag\state = #PB_Drag_Enter
          
          If Not mouse( )\drag\cursor
            SetCursor( PressedWidget( ), Cursor::#PB_Cursor_Drop )
          Else
            If PressedWidget( )\cursor = Cursor::#PB_Cursor_Drag
              Cursor::Free( Cursor::#PB_Cursor_Drag )
              PressedWidget( )\cursor = Cursor::#PB_Cursor_Drop
            EndIf
          EndIf
          
          _this_\state\repaint = #True
        EndIf
      Else
        If mouse( )\drag\state <> #PB_Drag_Leave
          mouse( )\drag\state = #PB_Drag_Leave
          
          If Not mouse( )\drag\cursor
            SetCursor( PressedWidget( ), Cursor::#PB_Cursor_Drag )
          Else
            If PressedWidget( )\cursor = Cursor::#PB_Cursor_Drop
              Cursor::Free( Cursor::#PB_Cursor_Drop )
              PressedWidget( )\cursor = Cursor::#PB_Cursor_Drag
            EndIf
          EndIf
          
          _this_\state\repaint = #True
        EndIf
      EndIf
    EndMacro
    
    Procedure DropDraw( *this._S_widget )
      Protected jj = 2, ss = 7, tt = 3
      Protected j = 5, s = 3, t = 1
      
      ;\\ if you drag to the widget-dropped
      If mouse( )\drag
        If is_scrollbars_( *this )
          *this = *this\_parent( )
        EndIf
        
        ;\\ first draw backgraund color
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        If *this\drop
          If *this\state\enter = 2
            If mouse( )\drag\state = #PB_Drag_Enter
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $1000ff00 )
              
              If *this\row
                If *this\FocusedRow( ) And *this\FocusedRow( )\state\enter
                  If *this\FocusedRow( )\state\enter < 0
                    draw_box_( row_x_( *this, *this\FocusedRow( ) ) + jj, row_y_( *this, *this\FocusedRow( ) ) - tt, *this\FocusedRow( )\width - jj * 2, ss, $2000ff00 )
                  Else
                    draw_box_( row_x_( *this, *this\FocusedRow( ) ) + jj, row_y_( *this, *this\FocusedRow( ) ) + *this\FocusedRow( )\height - tt, *this\FocusedRow( )\width - jj * 2, ss, $2000ff00 )
                  EndIf
                Else
                  If *this\count\items And *this\VisibleLastRow( )
                    draw_box_(row_x_( *this, *this\VisibleLastRow( ) ) + jj, row_y_( *this, *this\VisibleLastRow( ) ) + *this\VisibleLastRow( )\height - tt, *this\VisibleLastRow( )\width - jj * 2, ss, $2000ff00 )
                  Else
                    draw_box_( *this\x[#__c_inner] + jj, *this\y[#__c_inner] - tt, *this\width[#__c_inner] - jj * 2, ss, $2000ff00 )
                  EndIf
                EndIf
              EndIf
            Else
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $10ff0000 )
            EndIf
          Else
            ; draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff0000 )
          EndIf
        Else
          If *this\state\enter = 2
            If *this\state\drag
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $10ff00ff )
            Else
              ; draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $100000ff )
            EndIf
          Else
            ; draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $100000ff )
          EndIf
        EndIf
        
        ;\\ second draw frame color
        drawing_mode_( #PB_2DDrawing_Outlined )
        If *this\drop
          If *this\state\enter = 2
            If mouse( )\drag\state = #PB_Drag_Enter
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ff00ff00 )
              
              If *this\row
                If *this\FocusedRow( ) And *this\FocusedRow( )\state\enter
                  If *this\FocusedRow( )\state\enter < 0
                    draw_box_( row_x_( *this, *this\FocusedRow( ) ) + j, row_y_( *this, *this\FocusedRow( ) ) - t, *this\FocusedRow( )\width - j * 2, s, $ff00ff00 )
                  Else
                    draw_box_( row_x_( *this, *this\FocusedRow( ) ) + j, row_y_( *this, *this\FocusedRow( ) ) + *this\FocusedRow( )\height - t, *this\FocusedRow( )\width - j * 2, s, $ff00ff00 )
                  EndIf
                Else
                  If *this\count\items And *this\VisibleLastRow( )
                    draw_box_(row_x_( *this, *this\VisibleLastRow( ) ) + j, row_y_( *this, *this\VisibleLastRow( ) ) + *this\VisibleLastRow( )\height - t, *this\VisibleLastRow( )\width - j * 2, s, $ff00ff00 )
                  Else
                    draw_box_( *this\x[#__c_inner] + j, *this\y[#__c_inner] - t, *this\width[#__c_inner] - j * 2, s, $ff00ff00 )
                  EndIf
                EndIf
              EndIf
            Else
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff0000 )
            EndIf
          Else
            ; draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
          EndIf
        Else
          If *this\state\enter = 2
            If *this\state\drag
              draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ffff00ff )
            Else
              ; draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], $ff0000ff )
            EndIf
          Else
            ; draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff0000ff )
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.l DropX( )
      ProcedureReturn mouse( )\drag\x
    EndProcedure
    
    Procedure.l DropY( )
      ProcedureReturn mouse( )\drag\y
    EndProcedure
    
    Procedure.l DropWidth( )
      ProcedureReturn mouse( )\drag\width
    EndProcedure
    
    Procedure.l DropHeight( )
      ProcedureReturn mouse( )\drag\height
    EndProcedure
    
    Procedure.i DropType( )
      ; эта функция возвращает формат отброшенных данных.
      ; после того, как произошло событие #__event_Drop
      ProcedureReturn mouse( )\drag\format
    EndProcedure
    
    Procedure.i DropAction( )
      ; эта функция возвращает действие, которое следует выполнить с данными.
      ; после того, как произошло событие #__event_Drop
      ProcedureReturn mouse( )\drag\actions
    EndProcedure
    
    Procedure.i DropPrivate( )
      ; эта функция возвращает 'PrivateType', который был сброшен.
      ; после того, как произошло событие #__event_Drop с форматом #PB_Drop_Private (формат можно получить с помощью EventDropType( ))
      ProcedureReturn mouse( )\drag\private
    EndProcedure
    
    Procedure.s DropFiles( )
      ; эта функция возвращает имена файлов, который был сброшен.
      ; после того, как произошло событие #__event_Drop с форматом #PB_Drop_Files (формат можно получить с помощью EventDropType( ))
      ; ProcedureReturn mouse( )\drag\files
    EndProcedure
    
    Procedure.s DropText( )
      ; эта функция возвращает текст, который был сброшен.
      ; после того, как произошло событие #__event_Drop с форматом #PB_Drop_Text (формат можно получить с помощью EventDropType( ))
      ProcedureReturn mouse( )\drag\string
    EndProcedure
    
    Procedure.i DropImage( Image.i = - 1, Depth.i = 24 )
      ; эта функция возвращает изображения, который был сброшен.
      ; после того, как произошло событие #__event_Drop с форматом #PB_Drop_Image (формат можно получить с помощью EventDropType( ))
      If mouse( )\drag\imageID
        If Image = - 1
          Image = CreateImage( #PB_Any, DropWidth( ), DropHeight( ) )
        EndIf
        
        If IsImage( Image ) And
           StartDrawing( ImageOutput( Image ))
          If Depth = 32
            DrawAlphaImage( mouse( )\drag\imageID, 0, 0 )
          Else
            DrawImage( mouse( )\drag\imageID, 0, 0 )
          EndIf
          StopDrawing( )
          
          ProcedureReturn 1
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i DropEnable( *this._S_widget, Format.i, Actions.i, PrivateType.i = 0 )
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
      ; #PB_Drag_Enter         ; = 1     ; 1          ; 1     ; The mouse entered the (gadget Or window)
      ; #PB_Drag_Update        ; = 2     ; 2          ; 2     ; The mouse was moved inside the (gadget Or window), Or the intended action changed
      ; #PB_Drag_Leave         ; = 3     ; 3          ; 3     : The mouse left the (gadget Or window) (Format, Action, x, y are 0 here)
      ; #PB_Drag_Finish        ; = 4     ; 4          ; 4     : The Drag & Drop finished
      ;
      
      If IsGadget(*this)
        ProcedureReturn PB(EnableGadgetDrop)(*this, Format, Actions, PrivateType )
      EndIf
      
      If Not *this\drop
        ;Debug "Enable dropped - " + *this\class
        *this\drop.allocate( DROP )
      EndIf
      
      *this\drop\format  = Format
      *this\drop\actions = Actions
      *this\drop\private = PrivateType
    EndProcedure
    
    Procedure.i DragText_( Text.s, Actions.i = #PB_Drag_Copy )
      ;Debug "  drag text - " + Text
      
      If Not mouse( )\drag
        mouse( )\drag.allocate( DRAG )
      EndIf
      mouse( )\drag\format  = #PB_Drop_Text
      mouse( )\drag\actions = Actions
      mouse( )\drag\string  = Text
      
      ProcedureReturn mouse( )\drag
    EndProcedure
    
    Procedure.i DragImage_( Image.i, Actions.i = #PB_Drag_Copy )
      ;Debug "  drag image - " + Image
      
      If Not mouse( )\drag
        mouse( )\drag.allocate( DRAG )
      EndIf
      mouse( )\drag\format  = #PB_Drop_Image
      mouse( )\drag\actions = Actions
      
      If IsImage( Image )
        mouse( )\drag\imageID = ImageID( Image )
        mouse( )\drag\width   = ImageWidth( Image )
        mouse( )\drag\height  = ImageHeight( Image )
      EndIf
      
      ProcedureReturn mouse( )\drag
    EndProcedure
    
    Procedure.i DragFiles_( Files.s, Actions.i = #PB_Drag_Copy )
      ;         ;Debug "  drag files - " + Files
      ;
      ;         If Not mouse( )\drag
      ;           mouse( )\drag.allocate( DRAG )
      ;         EndIf
      ;         mouse( )\drag\format  = #PB_Drop_Files
      ;         mouse( )\drag\actions = Actions
      ;         mouse( )\drag\files  = Files
      
      ProcedureReturn mouse( )\drag
    EndProcedure
    
    Procedure.i DragPrivate_( PrivateType.i, Actions.i = #PB_Drag_Copy )
      ; Debug "  drag PrivateType - " + PrivateType +" - Actions - "+ Actions
      
      If Not mouse( )\drag
        mouse( )\drag.allocate( DRAG )
      EndIf
      mouse( )\drag\format  = #PB_Drop_Private
      mouse( )\drag\actions = Actions
      mouse( )\drag\private = PrivateType
      
      ProcedureReturn mouse( )\drag
    EndProcedure
    
    ;-
    ;-\\  ANCHORs
    Structure _S_DATA_TRANSFORM_CURSOR
      cursor.i[#__a_count + 1]
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
      
;       Data.i #PB_Cursor_LeftRight        ; 10
;       Data.i #PB_Cursor_UpDown           ; 11
;       Data.i #PB_Cursor_LeftRight        ; 12
;       Data.i #PB_Cursor_UpDown           ; 13
    EndDataSection
    
    Global *Data_Transform_Cursor._S_DATA_TRANSFORM_CURSOR = ?DATA_TRANSFORM_CURSOR
    
    Macro a_draw( _address_ )
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _address_ = a_anchors( )
        ; left line
        If a_selector([#__a_line_left])
          If _address_[#__a_moved] And a_selector([#__a_line_left])\y = a_focused( )\y[#__c_frame] And a_selector([#__a_line_left])\height = a_focused( )\height[#__c_frame]
            draw_box_( a_selector([#__a_line_left])\x, a_selector([#__a_line_left])\y, a_selector([#__a_line_left])\width, a_selector([#__a_line_left])\height , _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] )
          Else
            draw_box_( a_selector([#__a_line_left])\x, a_selector([#__a_line_left])\y, a_selector([#__a_line_left])\width, a_selector([#__a_line_left])\height , a_selector([#__a_line_left])\color\frame[a_selector([#__a_line_left])\color\state] )
          EndIf
        EndIf
        
        ; top line
        If a_selector([#__a_line_top])
          If _address_[#__a_moved] And a_selector([#__a_line_top])\y = a_focused( )\y[#__c_frame] And a_selector([#__a_line_top])\height = a_focused( )\height[#__c_frame]
            draw_box_( a_selector([#__a_line_top])\x, a_selector([#__a_line_top])\y, a_selector([#__a_line_top])\width, a_selector([#__a_line_top])\height , _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] )
          Else
            draw_box_( a_selector([#__a_line_top])\x, a_selector([#__a_line_top])\y, a_selector([#__a_line_top])\width, a_selector([#__a_line_top])\height , a_selector([#__a_line_top])\color\frame[a_selector([#__a_line_top])\color\state] )
          EndIf
        EndIf
        
        ; right line
        If a_selector([#__a_line_right])
          If _address_[#__a_moved] And a_selector([#__a_line_right])\x = a_focused( )\x[#__c_frame] And a_selector([#__a_line_right])\width = a_focused( )\width[#__c_frame]
            draw_box_( a_selector([#__a_line_right])\x, a_selector([#__a_line_right])\y, a_selector([#__a_line_right])\width, a_selector([#__a_line_right])\height , _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] )
          Else
            draw_box_( a_selector([#__a_line_right])\x, a_selector([#__a_line_right])\y, a_selector([#__a_line_right])\width, a_selector([#__a_line_right])\height , a_selector([#__a_line_right])\color\frame[a_selector([#__a_line_right])\color\state] )
          EndIf
        EndIf
        
        ; bottom line
        If a_selector([#__a_line_bottom])
          If _address_[#__a_moved] And a_selector([#__a_line_bottom])\x = a_focused( )\x[#__c_frame] And a_selector([#__a_line_bottom])\width = a_focused( )\width[#__c_frame]
            draw_box_( a_selector([#__a_line_bottom])\x, a_selector([#__a_line_bottom])\y, a_selector([#__a_line_bottom])\width, a_selector([#__a_line_bottom])\height , _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] )
          Else
            draw_box_( a_selector([#__a_line_bottom])\x, a_selector([#__a_line_bottom])\y, a_selector([#__a_line_bottom])\width, a_selector([#__a_line_bottom])\height , a_selector([#__a_line_bottom])\color\frame[a_selector([#__a_line_bottom])\color\state] )
          EndIf
        EndIf
      Else
        If _address_[0] :draw_box_( _address_[0]\x, _address_[0]\y, _address_[0]\width, _address_[0]\height , _address_[0]\color\back[_address_[0]\color\state] ) : EndIf
      EndIf
      
      ;If _address_\container
      If _address_[#__a_moved] And ( _address_[#__a_moved]\width <> _address_[0]\width And _address_[#__a_moved]\height <> _address_[0]\height )
        draw_box_( _address_[#__a_moved]\x, _address_[#__a_moved]\y, _address_[#__a_moved]\width, _address_[#__a_moved]\height, _address_[#__a_moved]\color\frame[_address_[#__a_moved]\color\state] )
      EndIf
      ;EndIf
      
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw background anchors
      If _address_[#__a_left] :draw_box_( _address_[#__a_left]\x, _address_[#__a_left]\y, _address_[#__a_left]\width, _address_[#__a_left]\height , _address_[#__a_left]\color\back[_address_[#__a_left]\color\state] ) : EndIf
      If _address_[#__a_top] :draw_box_( _address_[#__a_top]\x, _address_[#__a_top]\y, _address_[#__a_top]\width, _address_[#__a_top]\height , _address_[#__a_top]\color\back[_address_[#__a_top]\color\state] ) : EndIf
      If _address_[#__a_right] :draw_box_( _address_[#__a_right]\x, _address_[#__a_right]\y, _address_[#__a_right]\width, _address_[#__a_right]\height , _address_[#__a_right]\color\back[_address_[#__a_right]\color\state] ) : EndIf
      If _address_[#__a_bottom] :draw_box_( _address_[#__a_bottom]\x, _address_[#__a_bottom]\y, _address_[#__a_bottom]\width, _address_[#__a_bottom]\height , _address_[#__a_bottom]\color\back[_address_[#__a_bottom]\color\state] ) : EndIf
      If _address_[#__a_left_top] :draw_box_( _address_[#__a_left_top]\x, _address_[#__a_left_top]\y, _address_[#__a_left_top]\width, _address_[#__a_left_top]\height , _address_[#__a_left_top]\color\back[_address_[#__a_left_top]\color\state] ) : EndIf
      If _address_[#__a_right_top] :draw_box_( _address_[#__a_right_top]\x, _address_[#__a_right_top]\y, _address_[#__a_right_top]\width, _address_[#__a_right_top]\height , _address_[#__a_right_top]\color\back[_address_[#__a_right_top]\color\state] ) : EndIf
      If _address_[#__a_right_bottom] :draw_box_( _address_[#__a_right_bottom]\x, _address_[#__a_right_bottom]\y, _address_[#__a_right_bottom]\width, _address_[#__a_right_bottom]\height , _address_[#__a_right_bottom]\color\back[_address_[#__a_right_bottom]\color\state] ) : EndIf
      If _address_[#__a_left_bottom] :draw_box_( _address_[#__a_left_bottom]\x, _address_[#__a_left_bottom]\y, _address_[#__a_left_bottom]\width, _address_[#__a_left_bottom]\height , _address_[#__a_left_bottom]\color\back[_address_[#__a_left_bottom]\color\state] ) : EndIf
      
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      
      ; draw frame anchors
      If _address_[#__a_left] :draw_box_( _address_[#__a_left]\x, _address_[#__a_left]\y, _address_[#__a_left]\width, _address_[#__a_left]\height, _address_[#__a_left]\color\frame[_address_[#__a_left]\color\state] ) : EndIf
      If _address_[#__a_top] :draw_box_( _address_[#__a_top]\x, _address_[#__a_top]\y, _address_[#__a_top]\width, _address_[#__a_top]\height, _address_[#__a_top]\color\frame[_address_[#__a_top]\color\state] ) : EndIf
      If _address_[#__a_right] :draw_box_( _address_[#__a_right]\x, _address_[#__a_right]\y, _address_[#__a_right]\width, _address_[#__a_right]\height, _address_[#__a_right]\color\frame[_address_[#__a_right]\color\state] ) : EndIf
      If _address_[#__a_bottom] :draw_box_( _address_[#__a_bottom]\x, _address_[#__a_bottom]\y, _address_[#__a_bottom]\width, _address_[#__a_bottom]\height, _address_[#__a_bottom]\color\frame[_address_[#__a_bottom]\color\state] ) : EndIf
      If _address_[#__a_left_top] :draw_box_( _address_[#__a_left_top]\x, _address_[#__a_left_top]\y, _address_[#__a_left_top]\width, _address_[#__a_left_top]\height, _address_[#__a_left_top]\color\frame[_address_[#__a_left_top]\color\state] ) : EndIf
      If _address_[#__a_right_top] :draw_box_( _address_[#__a_right_top]\x, _address_[#__a_right_top]\y, _address_[#__a_right_top]\width, _address_[#__a_right_top]\height, _address_[#__a_right_top]\color\frame[_address_[#__a_right_top]\color\state] ) : EndIf
      If _address_[#__a_right_bottom] :draw_box_( _address_[#__a_right_bottom]\x, _address_[#__a_right_bottom]\y, _address_[#__a_right_bottom]\width, _address_[#__a_right_bottom]\height, _address_[#__a_right_bottom]\color\frame[_address_[#__a_right_bottom]\color\state] ) : EndIf
      If _address_[#__a_left_bottom] :draw_box_( _address_[#__a_left_bottom]\x, _address_[#__a_left_bottom]\y, _address_[#__a_left_bottom]\width, _address_[#__a_left_bottom]\height, _address_[#__a_left_bottom]\color\frame[_address_[#__a_left_bottom]\color\state] ) : EndIf
    EndMacro
    
    Macro a_transform_( _this_ )
      Bool( _this_\_a_\transform Or ( is_integral_( _this_ ) And _this_\_parent( )\_a_\transform ) )
    EndMacro
    
    Macro a_is_at_point_( _this_ )
      Bool( _this_ And a_index( ) And (( a_index( ) <> #__a_moved ) Or ( _this_\container And a_index( ) = #__a_moved )))
      ; Bool( _this_ And _this_\_a_\id And a_index( ) And a_index( ) <> #__a_moved )
    EndMacro
    
    Procedure a_grid_image( Steps = 5, line = 0, Color = 0, startx = 0, starty = 0 )
      Macro a_grid_change( _this_, _redraw_ = #False )
        If a_transform( )\grid_widget <> _this_
          If a_transform( )\grid_size > 1 And a_transform( )\grid_widget
            SetBackgroundImage( a_transform( )\grid_widget, #PB_Default )
          EndIf
          a_transform( )\grid_widget = _this_
          
          If _this_\container > 0 And _this_\type <> #__type_MDI
            _this_\image[#__image_background]\x = - _this_\fs
            _this_\image[#__image_background]\y = - _this_\fs
          EndIf
          
          If a_transform( )\grid_size > 1
            SetBackgroundImage( a_transform( )\grid_widget, a_transform( )\grid_image )
          EndIf
          
          If _redraw_
            ReDraw( _this_\_root( ) )
          EndIf
        EndIf
      EndMacro
      
      Static ID
      Protected hDC, x, y
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
                Line( x, 0, 1, height, Color )
                Line( 0, y, width, 1, Color )
              Else
                Line( x, y, 1, 1, Color )
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
    
    Macro a_size( _address_, _size_ )
      If _address_[#__a_left] ; left
        _address_[#__a_left]\width  = _size_
        _address_[#__a_left]\height = _size_
      EndIf
      If _address_[#__a_top] ; top
        _address_[#__a_top]\width  = _size_
        _address_[#__a_top]\height = _size_
      EndIf
      If _address_[#__a_right] ; right
        _address_[#__a_right]\width  = _size_
        _address_[#__a_right]\height = _size_
      EndIf
      If _address_[#__a_bottom] ; bottom
        _address_[#__a_bottom]\width  = _size_
        _address_[#__a_bottom]\height = _size_
      EndIf
      
      If _address_[#__a_left_top] ; left&top
        _address_[#__a_left_top]\width  = _size_
        _address_[#__a_left_top]\height = _size_
      EndIf
      If _address_[#__a_right_top] ; right&top
        _address_[#__a_right_top]\width  = _size_
        _address_[#__a_right_top]\height = _size_
      EndIf
      If _address_[#__a_right_bottom] ; right&bottom
        _address_[#__a_right_bottom]\width  = _size_
        _address_[#__a_right_bottom]\height = _size_
      EndIf
      If _address_[#__a_left_bottom] ; left&bottom
        _address_[#__a_left_bottom]\width  = _size_
        _address_[#__a_left_bottom]\height = _size_
      EndIf
    EndMacro
    
    Macro a_pos( _this_ )
      _this_\_a_\pos
    EndMacro
    
    Procedure a_test( *this._s_widget )
      Protected i = #__c_frame
      Protected x = a_focused( )\x[i]
      Protected y = a_focused( )\y[i]
      
      
      ForEach enumWidget( )
        If Not enumWidget( )\hide And enumWidget( )\_a_\transform And 
           ( is_parent_one_( enumWidget( ), a_focused( ) ) Or 
             ( EnteredWidget( ) And EnteredWidget( )\container And
               EnteredWidget( ) <> a_focused( )\_parent( )))
          
          ;Left_line
          If x = enumWidget( )\x[i]
            If a_selector([#__a_line_left])\y > enumWidget( )\y[i]
              a_selector([#__a_line_left])\y = enumWidget( )\y[i]
            EndIf
            If y + a_focused( )\height[i] < enumWidget( )\y[i] + enumWidget( )\height[i]
              a_selector([#__a_line_left])\height = ( enumWidget( )\y[i] + enumWidget( )\height[i] ) - a_selector([#__a_line_left])\y
            Else
              a_selector([#__a_line_left])\height = ( y + a_focused( )\height[i] ) - a_selector([#__a_line_left])\y
            EndIf
            
            a_selector([#__a_line_left])\color\state = 2
          EndIf
          
          ;Right_line
          If x + a_focused( )\width[i] = enumWidget( )\x[i] + enumWidget( )\width[i]
            If a_selector([#__a_line_top])\y > enumWidget( )\y[i]
              a_selector([#__a_line_top])\y = enumWidget( )\y[i]
            EndIf
            If y + a_focused( )\height[i] < enumWidget( )\y[i] + enumWidget( )\height[i]
              a_selector([#__a_line_top])\height = ( enumWidget( )\y[i] + enumWidget( )\height[i]) - a_selector([#__a_line_top])\y
            Else
              a_selector([#__a_line_top])\height = (y + a_focused( )\height[i]) - a_selector([#__a_line_top])\y
            EndIf
            
            a_selector([#__a_line_top])\color\state = 2
          EndIf
          
          ;Top_line
          If y = enumWidget( )\y[i]
            If a_selector([#__a_line_right])\x > enumWidget( )\x[i]
              a_selector([#__a_line_right])\x = enumWidget( )\x[i]
            EndIf
            If x + a_focused( )\width[i] < enumWidget( )\x[i] + enumWidget( )\width[i]
              a_selector([#__a_line_right])\width = ( enumWidget( )\x[i] + enumWidget( )\width[i]) - a_selector([#__a_line_right])\x
            Else
              a_selector([#__a_line_right])\width = (x + a_focused( )\width[i]) - a_selector([#__a_line_right])\x
            EndIf
            
            a_selector([#__a_line_right])\color\state = 1
          EndIf
          
          ;Bottom_line
          If y + a_focused( )\height[i] = enumWidget( )\y[i] + enumWidget( )\height[i]
            If a_selector([#__a_line_bottom])\x > enumWidget( )\x[i]
              a_selector([#__a_line_bottom])\x = enumWidget( )\x[i]
            EndIf
            If x + a_focused( )\width[i] < enumWidget( )\x[i] + enumWidget( )\width[i]
              a_selector([#__a_line_bottom])\width = ( enumWidget( )\x[i] + enumWidget( )\width[i]) - a_selector([#__a_line_bottom])\x
            Else
              a_selector([#__a_line_bottom])\width = (x + a_focused( )\width[i]) - a_selector([#__a_line_bottom])\x
            EndIf
            
            a_selector([#__a_line_bottom])\color\state = 1
          EndIf
        EndIf
      Next
    EndProcedure
    
    Macro a_move( _address_, _a_moved_type_, _x_, _y_, _width_, _height_ )
      If _address_[0] And a_entered( ) ; frame
        _address_[0]\x      = _x_ + a_pos( a_entered( ) ) ; a_transform( )\pos
        _address_[0]\y      = _y_ + a_pos( a_entered( ) ) ; a_transform( )\pos
        _address_[0]\width  = _width_ - a_pos( a_entered( ) ) * 2; a_transform( )\pos * 2
        _address_[0]\height = _height_ - a_pos( a_entered( ) ) * 2; a_transform( )\pos * 2
      EndIf
      
      If _address_ <> a_selector( )
        If _address_[#__a_left] ; left
          _address_[#__a_left]\x = _x_
          _address_[#__a_left]\y = _y_ + ( _height_ - _address_[#__a_left]\height ) / 2
        EndIf
        If _address_[#__a_top] ; top
          _address_[#__a_top]\x = _x_ + ( _width_ - _address_[#__a_top]\width ) / 2
          _address_[#__a_top]\y = _y_
        EndIf
        If _address_[#__a_right] ; right
          _address_[#__a_right]\x = _x_ + _width_ - _address_[#__a_right]\width
          _address_[#__a_right]\y = _y_ + ( _height_ - _address_[#__a_right]\height ) / 2
        EndIf
        If _address_[#__a_bottom] ; bottom
          _address_[#__a_bottom]\x = _x_ + ( _width_ - _address_[#__a_bottom]\width ) / 2
          _address_[#__a_bottom]\y = _y_ + _height_ - _address_[#__a_bottom]\height
        EndIf
        
        If _address_[#__a_left_top] ; left&top
          _address_[#__a_left_top]\x = _x_
          _address_[#__a_left_top]\y = _y_
        EndIf
        If _address_[#__a_right_top] ; right&top
          _address_[#__a_right_top]\x = _x_ + _width_ - _address_[#__a_right_top]\width
          _address_[#__a_right_top]\y = _y_
        EndIf
        If _address_[#__a_right_bottom] ; right&bottom
          _address_[#__a_right_bottom]\x = _x_ + _width_ - _address_[#__a_right_bottom]\width
          _address_[#__a_right_bottom]\y = _y_ + _height_ - _address_[#__a_right_bottom]\height
        EndIf
        If _address_[#__a_left_bottom] ; left&bottom
          _address_[#__a_left_bottom]\x = _x_
          _address_[#__a_left_bottom]\y = _y_ + _height_ - _address_[#__a_left_bottom]\height
        EndIf
        
        If _address_[#__a_moved] ; moved
          If _a_moved_type_
            _address_[#__a_moved]\x = _x_
            _address_[#__a_moved]\y = _y_
            If a_focused( )
              _address_[#__a_moved]\width  = a_focused( )\_a_\size * 2
              _address_[#__a_moved]\height = a_focused( )\_a_\size * 2
            Else
              _address_[#__a_moved]\width  = a_entered( )\_a_\size * 2
              _address_[#__a_moved]\height = a_entered( )\_a_\size * 2
            EndIf
          ElseIf a_entered( )
            _address_[#__a_moved]\x      = _x_ + a_pos( a_entered( ) ) ; a_transform( )\pos
            _address_[#__a_moved]\y      = _y_ + a_pos( a_entered( ) ) ; a_transform( )\pos
            _address_[#__a_moved]\width  = _width_ - a_pos( a_entered( ) ) * 2; ;a_transform( )\pos * 2
            _address_[#__a_moved]\height = _height_ - a_pos( a_entered( ) ) * 2; a_transform( )\pos * 2
          EndIf
          ;Debug _address_[#__a_moved]\height
        EndIf
      EndIf
      
      If a_focused( ) And
         a_selector([#__a_line_left]) And
         a_selector([#__a_line_right]) And
         a_selector([#__a_line_top]) And
         a_selector([#__a_line_bottom])
        ;a_lines( a_focused( ) )
        
        a_selector([#__a_line_left])\color\state   = 0
        a_selector([#__a_line_right])\color\state  = 0
        a_selector([#__a_line_top])\color\state    = 0
        a_selector([#__a_line_bottom])\color\state = 0
        
        ; line size
        a_selector([#__a_line_left])\width    = 1
        a_selector([#__a_line_right])\height  = 1
        a_selector([#__a_line_top])\width     = 1
        a_selector([#__a_line_bottom])\height = 1
        
        ;
        a_selector([#__a_line_left])\height  = a_focused( )\height[#__c_frame]
        a_selector([#__a_line_right])\width  = a_focused( )\width[#__c_frame]
        a_selector([#__a_line_top])\height   = a_focused( )\height[#__c_frame]
        a_selector([#__a_line_bottom])\width = a_focused( )\width[#__c_frame]
        
        ; line pos
        a_selector([#__a_line_left])\x = a_focused( )\x[#__c_frame]
        a_selector([#__a_line_left])\y = a_focused( )\y[#__c_frame]
        
        a_selector([#__a_line_right])\x = a_focused( )\x[#__c_frame]
        a_selector([#__a_line_right])\y = a_focused( )\y[#__c_frame]
        
        a_selector([#__a_line_top])\x = (a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame]) - a_selector([#__a_line_top])\width
        a_selector([#__a_line_top])\y = a_focused( )\y[#__c_frame]
        
        a_selector([#__a_line_bottom])\x = a_focused( )\x[#__c_frame]
        a_selector([#__a_line_bottom])\y = (a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame]) - a_selector([#__a_line_bottom])\height
        
          
        
        If ListSize( enumWidget( ))
          PushListPosition( enumWidget( ))
;           If a_index( ) = #__a_moved And a_focused( )\state\press
;             a_test( a_focused( ) )
;           Else
            ForEach enumWidget( )
              ;               If Not enumWidget( )\hide And enumWidget( )\_a_\transform And
              ;                  is_parent_one_( enumWidget( ), a_focused( ))
              If Not enumWidget( )\hide And enumWidget( )\_a_\transform And 
                 ( is_parent_one_( enumWidget( ), a_focused( ) ) Or 
                   ( EnteredWidget( ) And EnteredWidget( )\container And
                     EnteredWidget( ) <> a_focused( )\_parent( )))
          
                ;Left_line
                If a_focused( )\x[#__c_frame] = enumWidget( )\x[#__c_frame]
                  If a_selector([#__a_line_left])\y > enumWidget( )\y[#__c_frame]
                    a_selector([#__a_line_left])\y = enumWidget( )\y[#__c_frame]
                  EndIf
                  If a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame] < enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]
                    a_selector([#__a_line_left])\height = ( enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame] ) - a_selector([#__a_line_left])\y
                  Else
                    a_selector([#__a_line_left])\height = ( a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame] ) - a_selector([#__a_line_left])\y
                  EndIf
                  
                  a_selector([#__a_line_left])\color\state = 2
                EndIf
                
                ;Right_line
                If a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame] = enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]
                  If a_selector([#__a_line_top])\y > enumWidget( )\y[#__c_frame]
                    a_selector([#__a_line_top])\y = enumWidget( )\y[#__c_frame]
                  EndIf
                  If a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame] < enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]
                    a_selector([#__a_line_top])\height = ( enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]) - a_selector([#__a_line_top])\y
                  Else
                    a_selector([#__a_line_top])\height = (a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame]) - a_selector([#__a_line_top])\y
                  EndIf
                  
                  a_selector([#__a_line_top])\color\state = 2
                EndIf
                
                ;Top_line
                If a_focused( )\y[#__c_frame] = enumWidget( )\y[#__c_frame]
                  If a_selector([#__a_line_right])\x > enumWidget( )\x[#__c_frame]
                    a_selector([#__a_line_right])\x = enumWidget( )\x[#__c_frame]
                  EndIf
                  If a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame] < enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]
                    a_selector([#__a_line_right])\width = ( enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]) - a_selector([#__a_line_right])\x
                  Else
                    a_selector([#__a_line_right])\width = (a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame]) - a_selector([#__a_line_right])\x
                  EndIf
                  
                  a_selector([#__a_line_right])\color\state = 1
                EndIf
                
                ;Bottom_line
                If a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame] = enumWidget( )\y[#__c_frame] + enumWidget( )\height[#__c_frame]
                  If a_selector([#__a_line_bottom])\x > enumWidget( )\x[#__c_frame]
                    a_selector([#__a_line_bottom])\x = enumWidget( )\x[#__c_frame]
                  EndIf
                  If a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame] < enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]
                    a_selector([#__a_line_bottom])\width = ( enumWidget( )\x[#__c_frame] + enumWidget( )\width[#__c_frame]) - a_selector([#__a_line_bottom])\x
                  Else
                    a_selector([#__a_line_bottom])\width = (a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame]) - a_selector([#__a_line_bottom])\x
                  EndIf
                  
                  a_selector([#__a_line_bottom])\color\state = 1
                EndIf
              EndIf
            Next
;           EndIf
          PopListPosition( enumWidget( ))
        EndIf
      EndIf
      
    EndMacro
    
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
          If _index_ = #__a_left Or
             _index_ = #__a_top Or
             _index_ = #__a_right Or
             _index_ = #__a_bottom
            Continue
          EndIf
        Else
          If _this_\_a_\mode & #__a_height = 0
            If _index_ = #__a_top Or
               _index_ = #__a_bottom
              Continue
            EndIf
          EndIf
          If _this_\_a_\mode & #__a_width = 0
            If _index_ = #__a_left Or
               _index_ = #__a_right
              Continue
            EndIf
          EndIf
        EndIf
        
        If _this_\_a_\mode & #__a_corner = 0
          If _index_ = #__a_left_top Or
             _index_ = #__a_right_top Or
             _index_ = #__a_right_bottom Or
             _index_ = #__a_left_bottom
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
        
        ;_this_\_a_\id[_index_]\cursor = *Data_Transform_Cursor\cursor[_index_]
        a_transform( )\cursor[_index_] = *Data_Transform_Cursor\cursor[_index_]
        
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
    
    Procedure.i a_set( *this._S_widget, size.l = #PB_Ignore, position.l = #PB_Ignore )
      Protected value, result.i, i
      Static *before._S_widget
      
      If is_integral_( *this )
        *this = *this\_parent( )
      EndIf
      
      ;
      If *this = a_transform( )\main And a_focused( )
        *this = a_transform( )\main\first\widget
      EndIf
      
      ;
      If *this And ( *this\_a_\transform = - 1 And Not a_index( ) ) Or
         ( *this\_a_\transform = 1 And a_focused( ) <> *this )
        
        If a_focused( )
          ;           ; return layout position
          ;           If *before
          ;             SetPosition( a_focused( ), #PB_List_After, *before )
          ;           Else
          ;             SetPosition( a_focused( ), #PB_List_First )
          ;           EndIf
          ;           ;
          ;           *before = GetPosition( *this, #PB_List_Before )
          ;           If *this <> *this\_parent( )\last\widget
          ;             SetPosition( *this, #PB_List_Last )
          ;           EndIf
          
          ;
          a_remove( a_focused( ), i )
        EndIf
        
        ; a_add
        a_add( *this, i )
        a_grid_change( *this\_parent( ) )
        
        
        result           = a_focused( )
        a_focused( )     = *this
        FocusedWidget( ) = *this
        a_entered( )     = *this
        
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
          *this\bs      = position + *this\fs
        EndIf
        
        ;
        a_size( *this\_a_\id, *this\_a_\size )
        a_move( *this\_a_\id, *this\container,
                *this\x[#__c_screen],
                *this\y[#__c_screen],
                *this\width[#__c_screen],
                *this\height[#__c_screen] )
        
        ; get transform index
        For i = 1 To #__a_moved
          If *this\_a_\id[i]
            If is_at_point_( *this\_a_\id[i], mouse( )\x, mouse( )\y )
              
              If *this\_a_\id[i]\color\state <> #__S_1
                ;set_cursor_( a_focused( ), *this\_a_\id[i]\cursor )
                *this\_a_\id[i]\color\state = #__S_1
                value                       = 1
              EndIf
              
              a_index( ) = i
              Break
              
            ElseIf *this\_a_\id[i]\color\state <> #__S_0
              ;set_cursor_( a_focused( ), #PB_Cursor_Default )
              *this\_a_\id[i]\color\state = #__S_0
              a_index( )                  = 0
              value                       = 1
            EndIf
          EndIf
        Next
        
        ;
        Post( *this, #__event_StatusChange, a_index( ) )
        If Not result
          result = - 1
        EndIf
      EndIf
      
      If result
        ; reset multi group
        If ListSize( a_group( ))
          ForEach a_group( )
            ;           a_group( )\widget\_a_\transform = 1
            ;           a_group( )\widget\_root( )\_a_\transform = 1
            ;           a_group( )\widget\_parent( )\_a_\transform = 1
            
            a_set_state( a_group( )\widget, 1 )
            a_set_state( a_group( )\widget\_root( ), 1 )
            a_set_state( a_group( )\widget\_parent( ), 1 )
          Next
          
          a_selector( )\x      = 0
          a_selector( )\y      = 0
          a_selector( )\width  = 0
          a_selector( )\height = 0
          ClearList( a_group( ))
        EndIf
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i a_init( *this._S_widget, grid_size.a = 7, grid_type.b = 0 )
      Protected i
      
      If Not *this\_a_\transform
        a_set_state( *this, - 1 )
        
        If Not a_transform( )
          a_transform( ).allocate( TRANSFORM )
          
          a_transform( )\main = *this
          
          a_transform( )\grid_type  = grid_type
          a_transform( )\grid_size  = grid_size + 1
          a_transform( )\grid_image = a_grid_image( a_transform( )\grid_size - 1, a_transform( )\grid_type, $FF000000, *this\fs, *this\fs )
          
          For i = 0 To #__a_count
            ;?a_selector([i])\cursor = *Data_Transform_Cursor\cursor[i]
            a_transform( )\cursor[i] = *Data_Transform_Cursor\cursor[i]
            
            a_selector([i])\color\frame[0] = $ff000000
            a_selector([i])\color\frame[1] = $ffFF0000
            a_selector([i])\color\frame[2] = $ff0000FF
            
            a_selector([i])\color\back[0] = $ffFFFFFF
            a_selector([i])\color\back[1] = $ffFFFFFF
            a_selector([i])\color\back[2] = $ffFFFFFF
          Next i
          
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure a_update( *parent._S_widget )
      If *parent\_a_\transform = 1 ; Not ListSize( a_group( ))
        
        ; check transform group
        ForEach *parent\_widgets( )
          If *parent\_widgets( ) <> *parent And
             is_parent_( *parent\_widgets( ), *parent ) And
             is_inter_sect_( *parent\_widgets( ), a_selector( ), [#__c_frame] )
            
            ;             *parent\_widgets( )\_a_\transform = 2
            ;             *parent\_widgets( )\_root( )\_a_\transform =- 1
            ;             *parent\_widgets( )\_parent( )\_a_\transform =- 1
            a_set_state( *parent\_widgets( ), 2 )
            a_set_state( *parent\_widgets( )\_root( ), - 1 )
            a_set_state( *parent\_widgets( )\_parent( ), - 1 )
          EndIf
        Next
        
        ; reset
        a_selector( )\x      = 0
        a_selector( )\y      = 0
        a_selector( )\width  = 0
        a_selector( )\height = 0
        ;ClearList( a_group( ))
        
        ; init group pos
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If a_selector( )\x = 0 Or
               a_selector( )\x > *parent\_widgets( )\x[#__c_frame]
              a_selector( )\x = *parent\_widgets( )\x[#__c_frame]
            EndIf
            If a_selector( )\y = 0 Or
               a_selector( )\y > *parent\_widgets( )\y[#__c_frame]
              a_selector( )\y = *parent\_widgets( )\y[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init group size
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If a_selector( )\x + a_selector( )\width < *parent\_widgets( )\x[#__c_frame] + *parent\_widgets( )\width[#__c_frame]
              a_selector( )\width = ( *parent\_widgets( )\x[#__c_frame] - a_selector( )\x ) + *parent\_widgets( )\width[#__c_frame]
            EndIf
            If a_selector( )\y + a_selector( )\height < *parent\_widgets( )\y[#__c_frame] + *parent\_widgets( )\height[#__c_frame]
              a_selector( )\height = ( *parent\_widgets( )\y[#__c_frame] - a_selector( )\y ) + *parent\_widgets( )\height[#__c_frame]
            EndIf
          EndIf
        Next
        
        ; init group list ( & delta size )
        ForEach *parent\_widgets( )
          If *parent\_widgets( )\_a_\transform = 2
            If AddElement( a_group( ))
              a_transform( )\group.allocate( A_GROUP, ( ))
              ;a_group( )\widget.allocate( WIDGET )
              
              a_group( )\widget = *parent\_widgets( )
              a_group( )\x      = a_group( )\widget\x[#__c_frame] - a_selector( )\x
              a_group( )\y      = a_group( )\widget\y[#__c_frame] - a_selector( )\y
              
              a_group( )\width  = a_selector( )\width - a_group( )\widget\width[#__c_frame]
              a_group( )\height = a_selector( )\height - a_group( )\widget\height[#__c_frame]
            EndIf
          EndIf
        Next
        
      Else
        ; update group pos
        ForEach a_group( )
          If a_selector( )\x = 0 Or
             a_selector( )\x > a_group( )\widget\x[#__c_frame]
            a_selector( )\x = a_group( )\widget\x[#__c_frame]
          EndIf
          If a_selector( )\y = 0 Or
             a_selector( )\y > a_group( )\widget\y[#__c_frame]
            a_selector( )\y = a_group( )\widget\y[#__c_frame]
          EndIf
        Next
        
        ; update group size
        ForEach a_group( )
          If a_selector( )\x + a_selector( )\width < a_group( )\widget\x[#__c_frame] + a_group( )\widget\width[#__c_frame]
            a_selector( )\width = ( a_group( )\widget\x[#__c_frame] - a_selector( )\x ) + a_group( )\widget\width[#__c_frame]
          EndIf
          If a_selector( )\y + a_selector( )\height < a_group( )\widget\y[#__c_frame] + a_group( )\widget\height[#__c_frame]
            a_selector( )\height = ( a_group( )\widget\y[#__c_frame] - a_selector( )\y ) + a_group( )\widget\height[#__c_frame]
          EndIf
        Next
        
        ; update delta size
        ForEach a_group( )
          a_group( )\x = a_group( )\widget\x[#__c_frame] - a_selector( )\x
          a_group( )\y = a_group( )\widget\y[#__c_frame] - a_selector( )\y
          
          a_group( )\width  = a_selector( )\width - a_group( )\widget\width[#__c_frame]
          a_group( )\height = a_selector( )\height - a_group( )\widget\height[#__c_frame]
        Next
      EndIf
      
      ;
      a_size( a_selector( ), 7);a_transform( )\size )
      a_move( a_selector( ), 0,
              a_selector( )\x - a_transform( )\pos,
              a_selector( )\y - a_transform( )\pos,
              a_selector( )\width + a_transform( )\pos * 2,
              a_selector( )\height + a_transform( )\pos * 2 )
      
    EndProcedure
    
    Procedure a_show( *this._S_widget, state )
      Protected i
      
      If Not ( a_focused( ) And a_focused( )\state\press )
        If is_integral_( *this )
          *this = *this\_parent( )
        EndIf
        
        If state
          If a_entered( ) <> *this
            ;
            If a_entered( ) And
               a_focused( ) <> a_entered( ) And
               *this\_parent( ) = a_entered( )
              
              ;;Debug " a---#__event_MouseLeave"
              
              a_remove( a_entered( ), i )
            EndIf
            
            a_entered( ) = *this
            
            ;; Debug " a-#__event_MouseEnter"
            
            If a_focused( ) <> *this
              a_add( *this, i )
              
              ; a_resize( *this, *this\_a_\size )
              If *this\_a_\transform
                a_size( *this\_a_\id, *this\_a_\size )
                a_move( *this\_a_\id, *this\container,
                        *this\x[#__c_screen],
                        *this\y[#__c_screen],
                        *this\width[#__c_screen],
                        *this\height[#__c_screen] )
              EndIf
              
              ;\\
              If *this\_a_\id[0]\color\state <> #__S_1
                *this\_a_\id[0]\color\state = #__S_1
              EndIf
              
              *this\state\repaint = #True
            EndIf
            ;           Else
            ;             Debug 88888
          EndIf
          
        Else
          If a_entered( ) = *this
            ; Debug " a-#__event_MouseLeave"
            
            If a_focused( ) <> *this
              a_remove( *this, i )
              a_entered( )        = #Null
              *this\state\repaint = #True
            EndIf
            
            ;
            If *this\_parent( ) And *this\_parent( ) = EnteredWidget( ) And
               EnteredWidget( )\_a_\transform And
               a_entered( ) <> EnteredWidget( )
              a_entered( ) = EnteredWidget( )
              
              If a_focused( ) <> EnteredWidget( )
                ;;Debug " a---#__event_MouseEnter"
                
                a_add( EnteredWidget( ), i )
                
                ; a_resize( EnteredWidget( ), EnteredWidget( )\_a_\size )
                If EnteredWidget( )\_a_\transform
                  a_size( EnteredWidget( )\_a_\id, EnteredWidget( )\_a_\size )
                  a_move( EnteredWidget( )\_a_\id, EnteredWidget( )\container,
                          EnteredWidget( )\x[#__c_screen],
                          EnteredWidget( )\y[#__c_screen],
                          EnteredWidget( )\width[#__c_screen],
                          EnteredWidget( )\height[#__c_screen] )
                EndIf
                
                ;\\
                If EnteredWidget( )\_a_\id[0]\color\state <> #__S_1
                  EnteredWidget( )\_a_\id[0]\color\state = #__S_1
                EndIf
                ;               EnteredWidget( )\state\repaint = 1
                
                EnteredWidget( )\state\repaint = #True
              EndIf
            EndIf
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn *this\state\repaint
    EndProcedure
    
    Procedure a_events( *this._S_widget, eventtype.l, *button, *data )
      Protected mouse_x.l = mouse( )\x
      Protected mouse_y.l = mouse( )\y
      
      If a_transform( )
        Static xx, yy, *after
        Static move_x, move_y
        Protected i
        Protected mxw, myh
        Protected.l mx, my, mw, mh
        Protected.l Px, Py, IsGrid = Bool( a_transform( )\grid_size > 1 )
        
        Protected text.s
        
        ;\\
        If eventtype = #__event_MouseEnter
          If a_show( *this, 1 )
            *this\state\repaint = 1
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_MouseLeave
          If a_show( *this, 0 )
            *this\state\repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_LeftButtonDown
          If *this = a_transform( )\main
            ;
            ; если нажали в главном "окне"
            ; где находятся "изменяемые" виджеты
            ; то будем убырать все якорья
            ;
            If a_focused( )
              a_remove( a_focused( ), i )
            EndIf
          Else
            ;             ; get layout current position
            ;             ; set layout last position
            ;             *after = GetPosition( *this, #PB_List_After )
            ;             If *after
            ;                 *this\state\repaint = SetPosition( *this, #PB_List_Last )
            ;             EndIf
            
            ; set current transformer
            If a_set( *this, #__a_size )
              *this\state\repaint = 1
            EndIf
          EndIf
          
          ; change frame color
          If a_transform( )\type = 0
            a_transform( )\dot_ted   = 1
            a_transform( )\dot_space = 3
            a_transform( )\dot_line  = 5
            
            a_selector( )\color\back  = $80DFE2E2
            a_selector( )\color\frame = $BA161616
          Else
            a_selector( )\color\back  = $9F646565
            a_selector( )\color\frame = $BA161616
            a_selector( )\color\front = $ffffffff
          EndIf
          
          If a_index( ) And a_focused( ) And a_focused( )\_parent( ) And
             a_focused( )\_a_ And a_anchors([a_index( )])
            ;\\ set current transform index
            a_anchors([a_index( )])\color\state = #__S_2
            
            ;\\ set delta pos
            If a_focused( )\_parent( )
              If a_focused( )\_a_\transform = 1
                If Not ( a_focused( )\attach And a_focused( )\attach\mode = 2 )
                  mouse_x + a_focused( )\_parent( )\x[#__c_inner]
                EndIf
                If Not ( a_focused( )\attach And a_focused( )\attach\mode = 1 )
                  mouse_y + a_focused( )\_parent( )\y[#__c_inner]
                EndIf
                
                If Not is_integral_( a_focused( ))
                  mouse_x + a_focused( )\_parent( )\scroll_x( )
                  mouse_y + a_focused( )\_parent( )\scroll_y( )
                EndIf
              EndIf
            EndIf
            mouse( )\delta\x = mouse_x - a_anchors([a_index( )])\x
            mouse( )\delta\y = mouse_y - a_anchors([a_index( )])\y
            
            ;\\
            mouse( )\delta\x - a_focused( )\_parent( )\fs - ( a_focused( )\_a_\size - a_pos( a_focused( ) ) )
            mouse( )\delta\y - a_focused( )\_parent( )\fs - ( a_focused( )\_a_\size - a_pos( a_focused( ) ) )
            
            If a_index( ) = #__a_moved
              i = 3
              Debug "  parent "+ a_focused( )\_parent( )\class +" "+ a_focused( )\x[i] +" "+ a_focused( )\y[i] +" "+ a_focused( )\width[i] +" "+ a_focused( )\height[i]
            EndIf
            
          Else
            If a_transform( )\main
              mouse_x - a_transform( )\main\x[#__c_container]
              mouse_y - a_transform( )\main\y[#__c_container]
            EndIf
            
            ; for the selector
            ; grid mouse pos
            If a_transform( )\grid_size > 0
              mouse_x = (( mouse_x ) / a_transform( )\grid_size ) * a_transform( )\grid_size
              mouse_y = (( mouse_y ) / a_transform( )\grid_size ) * a_transform( )\grid_size
            EndIf
            
            ; set delta pos
            mouse( )\delta\x = mouse_x
            mouse( )\delta\y = mouse_y
          EndIf
          
          ;\\
          If a_is_at_point_( *this )
            *this\state\repaint = 1
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_LeftButtonUp
          If a_focused( )
            ;             If *after
            ;               *this\state\repaint = SetPosition( a_focused( ), #PB_List_Before, *after )
            ;             EndIf
            
            If a_anchors([a_index( )])
              If is_at_point_( a_anchors([a_index( )]), mouse_x, mouse_y )
                a_anchors([a_index( )])\color\state = #__S_1
              Else
                a_anchors([a_index( )])\color\state = #__S_0
              EndIf
              *this\state\repaint = 1
            EndIf
            
            If *this = a_transform( )\main
              a_focused( ) = #Null
            EndIf
          EndIf
          ;  *this\state\repaint = 1
          
          ; init multi group selector
          If a_transform( )\grab And a_transform( )\type = 0
            a_update( *this )
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_DragStart
          If a_index( ) = #__a_moved
            If Keyboard( )\key = #PB_Key_Space
              Keyboard( )\key             = 0
              PressedWidget( )\state\drag = #PB_Drag_Copy
              ProcedureReturn 0
            Else
              PressedWidget( )\state\drag = #PB_Drag_Move
            EndIf
          Else
            If a_index( )
              PressedWidget( )\state\drag =  - 1
            EndIf
          EndIf
          
          If a_focused( ) And a_index( ) = #__a_moved And a_anchors([#__a_moved])
            ; set_cursor_( *this, a_anchors([#__a_moved])\cursor )
          EndIf
          
          If Not a_index( ) And
             *this\container And
             *this\state\enter = 2
            
            a_grid_change( *this, #True )
            ; set_cursor_( *this, #PB_Cursor_Cross )
            
            If StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
              a_transform( )\grab = GrabDrawingImage( #PB_Any, 0, 0, *this\_root( )\width, *this\_root( )\height )
              StopDrawing( )
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_MouseMove
          If Not a_transform( )\grab And a_focused( ) And a_focused( )\state\press
            If mouse( )\buttons And a_index( ) And a_anchors([a_index( )]) And a_anchors([a_index( )])\color\state = #__S_2
              mouse_x - mouse( )\delta\x
              mouse_y - mouse( )\delta\y
              If a_transform( )\grid_size > 0
                mouse_x + ( mouse_x % a_transform( )\grid_size )
                mouse_y + ( mouse_y % a_transform( )\grid_size )
                mouse_x = ( mouse_x / a_transform( )\grid_size ) * a_transform( )\grid_size
                mouse_y = ( mouse_y / a_transform( )\grid_size ) * a_transform( )\grid_size
              EndIf
              
              If xx <> mouse_x Or yy <> mouse_y
                xx = mouse_x
                yy = mouse_y
                ; Debug mouse_x
                
                If a_focused( )\_a_\transform = 1
                  mw = #PB_Ignore
                  mh = #PB_Ignore
                  
                  If a_index( ) <> #__a_moved
                    ;\\ horizontal
                    Select a_index( )
                      Case #__a_left, #__a_left_top, #__a_left_bottom ; left
                        mw = ( a_focused( )\x[#__c_container] - mouse_x ) + a_focused( )\width[#__c_frame] 
                        If mw <= 0
                          mw      = 0
                          mouse_x = a_focused( )\x[#__c_frame] + a_focused( )\width[#__c_frame]
                        EndIf
                        
                      Case #__a_right, #__a_right_top, #__a_right_bottom ; right
                        mw = ( mouse_x - a_focused( )\x[#__c_container] ) + IsGrid
                    EndSelect
                    
                    ;\\ vertical
                    Select a_index( )
                      Case #__a_top, #__a_left_top, #__a_right_top ; top
                        mh = ( a_focused( )\y[#__c_container] - mouse_y ) + a_focused( )\height[#__c_frame] 
                        If mh <= 0
                          mh      = 0
                          mouse_y = a_focused( )\y[#__c_frame] + a_focused( )\height[#__c_frame]
                        EndIf
                        
                      Case #__a_bottom, #__a_left_bottom, #__a_right_bottom ; bottom
                        mh = ( mouse_y - a_focused( )\y[#__c_container] ) + IsGrid
                    EndSelect
                    
                    ;\\
                    If a_index( ) <> #__a_left_top
                      If a_index( ) <> #__a_left And a_index( ) <> #__a_left_bottom
                        mouse_x = #PB_Ignore
                      EndIf
                      If a_index( ) <> #__a_top And a_index( ) <> #__a_right_top
                        mouse_y = #PB_Ignore
                      EndIf
                    EndIf
                  EndIf
                  
                  ;Debug " " + mw + " " + mh
                  *this\state\repaint | Resize( a_focused( ), mouse_x, mouse_y, mw, mh )
                  
                Else
                  If a_transform( )\main
                    mouse_x + a_transform( )\main\x[#__c_container]
                    mouse_y + a_transform( )\main\y[#__c_container]
                  EndIf
                  
                  ; horizontal
                  Select a_index( )
                    Case #__a_left, #__a_left_top, #__a_left_bottom, #__a_moved ; left
                      If a_index( ) <> #__a_moved
                        a_selector( )\width = ( a_selector( )\x - mouse_x ) + a_selector( )\width
                      EndIf
                      a_selector( )\x = mouse_x
                      
                    Case #__a_right, #__a_right_top, #__a_right_bottom ; right
                      a_selector( )\width = ( mouse_x - a_selector( )\x ) + IsGrid
                  EndSelect
                  
                  ; vertical
                  Select a_index( )
                    Case #__a_top, #__a_left_top, #__a_right_top, #__a_moved ; top
                      If a_index( ) <> #__a_moved
                        a_selector( )\height = ( a_selector( )\y - mouse_y ) + a_selector( )\height
                      EndIf
                      a_selector( )\y = mouse_y
                      
                    Case #__a_bottom, #__a_left_bottom, #__a_right_bottom ; bottom
                      a_selector( )\height = ( mouse_y - a_selector( )\y ) + IsGrid
                  EndSelect
                  
                  ;
                  ;\\\ multi resize
                  ;
                  
                  ;                   a_selector( )\x = _x_
                  ;                   a_selector( )\y = _y_
                  ;
                  ;                   a_selector( )\width = _width_
                  ;                   a_selector( )\height = _height_
                  
                  a_move( a_selector( ), 0,
                          a_selector( )\x - a_transform( )\pos,
                          a_selector( )\y - a_transform( )\pos,
                          a_selector( )\width + a_transform( )\pos * 2,
                          a_selector( )\height + a_transform( )\pos * 2)
                  
                  Select a_index( )
                    Case #__a_left, #__a_left_top, #__a_left_bottom, #__a_moved ; left
                      ForEach a_group( )
                        *this\state\repaint | Resize( a_group( )\widget,
                                                      ( a_selector( )\x - a_focused( )\x[#__c_inner] ) + a_group( )\x,
                                                      #PB_Ignore, a_selector( )\width - a_group( )\width, #PB_Ignore )
                      Next
                      
                    Case #__a_right, #__a_right_top, #__a_right_bottom ; right
                      ForEach a_group( )
                        *this\state\repaint | Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, a_selector( )\width - a_group( )\width, #PB_Ignore )
                      Next
                  EndSelect
                  
                  Select a_index( )
                    Case #__a_top, #__a_left_top, #__a_right_top, #__a_moved ; top
                      ForEach a_group( )
                        *this\state\repaint | Resize( a_group( )\widget, #PB_Ignore,
                                                      ( a_selector( )\y - a_focused( )\y[#__c_inner] ) + a_group( )\y,
                                                      #PB_Ignore, a_selector( )\height - a_group( )\height )
                      Next
                      
                    Case #__a_bottom, #__a_left_bottom, #__a_right_bottom ; bottom
                      ForEach a_group( )
                        *this\state\repaint | Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, a_selector( )\height - a_group( )\height )
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
            
            If a_transform( )\grid_size > 0
              mouse_x = ( mouse_x / a_transform( )\grid_size ) * a_transform( )\grid_size
              mouse_y = ( mouse_y / a_transform( )\grid_size ) * a_transform( )\grid_size
            EndIf
            
            If move_x <> mouse_x
              If move_x > mouse_x
                *this\state\repaint = - 1
              Else
                *this\state\repaint = 1
              EndIf
              
              ; to left
              If mouse( )\delta\x > mouse_x
                a_selector( )\x     = mouse_x + a_transform( )\grid_size
                a_selector( )\width = mouse( )\delta\x - mouse_x
              Else
                a_selector( )\x     = mouse( )\delta\x
                a_selector( )\width = mouse_x - mouse( )\delta\x
              EndIf
              
              a_selector( )\x + a_transform( )\main\x[#__c_container]
              If a_transform( )\grid_size > 0
                a_selector( )\width + 1
              EndIf
              move_x = mouse_x
            EndIf
            
            If move_y <> mouse_y
              If move_y > mouse_y
                *this\state\repaint = - 2
              Else
                *this\state\repaint = 2
              EndIf
              
              ; to top
              If mouse( )\delta\y > mouse_y
                a_selector( )\y      = mouse_y + a_transform( )\grid_size
                a_selector( )\height = mouse( )\delta\y - mouse_y
              Else
                a_selector( )\y      = mouse( )\delta\y
                a_selector( )\height = mouse_y - mouse( )\delta\y
              EndIf
              
              a_selector( )\y + a_transform( )\main\y[#__c_container]
              If a_transform( )\grid_size > 0
                a_selector( )\height + 1
              EndIf
              move_y = mouse_y
            EndIf
          EndIf
        EndIf
        
        ;- widget::a_key_events
        If eventtype = #__event_KeyDown
          If a_focused( )
            If a_focused( )\_a_\transform = 1
              mx = a_focused( )\x[#__c_container]
              my = a_focused( )\y[#__c_container]
              mw = a_focused( )\width[#__c_frame]
              mh = a_focused( )\height[#__c_frame]
              
              ; fixed in container
              If a_focused( )\_parent( ) And
                 a_focused( )\_parent( )\container ;;> 0
                mx + a_focused( )\_parent( )\fs
                my + a_focused( )\_parent( )\fs
              EndIf
              
            Else
              mx = a_selector( )\x
              my = a_selector( )\y
              mw = a_selector( )\width
              mh = a_selector( )\height
            EndIf
            
            Select Keyboard( )\Key[1]
              Case (#PB_Canvas_Alt | #PB_Canvas_Control), #PB_Canvas_Shift
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left : mw - a_transform( )\grid_size : a_index( ) = #__a_right
                  Case #PB_Shortcut_Right : mw + a_transform( )\grid_size : a_index( ) = #__a_right
                    
                  Case #PB_Shortcut_Up : mh - a_transform( )\grid_size : a_index( ) = #__a_bottom
                  Case #PB_Shortcut_Down : mh + a_transform( )\grid_size : a_index( ) = #__a_bottom
                EndSelect
                
                *this\state\repaint | Resize( a_focused( ), mx, my, mw, mh )
                
              Case (#PB_Canvas_Shift | #PB_Canvas_Control), #PB_Canvas_Alt ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control | #PB_Canvas_Command
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Left : mx - a_transform( )\grid_size : a_index( ) = #__a_moved
                  Case #PB_Shortcut_Right : mx + a_transform( )\grid_size : a_index( ) = #__a_moved
                    
                  Case #PB_Shortcut_Up : my - a_transform( )\grid_size : a_index( ) = #__a_moved
                  Case #PB_Shortcut_Down : my + a_transform( )\grid_size : a_index( ) = #__a_moved
                EndSelect
                
                *this\state\repaint | Resize( a_focused( ), mx, my, mw, mh )
                
              Default
                
                Select Keyboard( )\Key
                  Case #PB_Shortcut_Up
                    If a_focused( )\before\widget
                      *this\state\repaint = a_set( a_focused( )\before\widget )
                    EndIf
                    
                  Case #PB_Shortcut_Down
                    If a_focused( )\after\widget
                      *this\state\repaint = a_set( a_focused( )\after\widget )
                    EndIf
                    
                  Case #PB_Shortcut_Left
                    If a_focused( )\_parent( )
                      *this\state\repaint = a_set( a_focused( )\_parent( ) )
                    EndIf
                    
                  Case #PB_Shortcut_Right
                    If a_focused( )\first\widget
                      *this\state\repaint = a_set( a_focused( )\first\widget )
                    ElseIf a_focused( )\_parent( ) And a_focused( )\_parent( )\last\widget
                      *this\state\repaint = a_set( a_focused( )\_parent( )\last\widget )
                    EndIf
                    
                EndSelect
                
            EndSelect
          EndIf
        EndIf
        
        If eventtype = #__event_LeftButtonUp
          a_transform( )\grab = 0
        EndIf
      EndIf
      
      ProcedureReturn *this\state\repaint
    EndProcedure
    
    
    ;-
    Procedure.i TypeFromClass( class.s )
      Protected result.i
      
      Select Trim( LCase( class.s ))
        Case "popupmenu" : result = #__type_popupmenu
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
        Case #__type_popupmenu : result.s = "popupmenu"
        Case #__type_menu : result.s = "menu"
        Case #__type_ToolBar : result.s = "tool"
          
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
    
    Procedure.s ClassFromEvent( event.i )
      Protected result.s
      
      Select event
        Case #__event_free : result.s = "#__event_Free"
        Case #__event_drop : result.s = "#__event_Drop"
        Case #__event_create : result.s = "#__event_Create"
        Case #__event_SizeItem : result.s = "#__event_SizeItem"
          
        Case #__event_repaint : result.s = "#__event_Repaint"
        Case #__event_resizeend : result.s = "#__event_ResizeEnd"
        Case #__event_scrollchange : result.s = "#__event_ScrollChange"
          
        Case #__event_closewindow : result.s = "#__event_CloseWindow"
        Case #__event_maximizewindow : result.s = "#__event_MaximizeWindow"
        Case #__event_minimizewindow : result.s = "#__event_MinimizeWindow"
        Case #__event_restorewindow : result.s = "#__event_RestoreWindow"
          
        Case #__event_MouseEnter : result.s = "#__event_MouseEnter"       ; The mouse cursor entered the gadget
        Case #__event_MouseLeave : result.s = "#__event_MouseLeave"       ; The mouse cursor left the gadget
        Case #__event_MouseMove : result.s = "#__event_MouseMove"         ; The mouse cursor moved
        Case #__event_MouseWheel : result.s = "#__event_MouseWheel"       ; The mouse wheel was moved
        Case #__event_LeftButtonDown : result.s = "#__event_LeftButtonDown"   ; The left mouse button was pressed
        Case #__event_LeftButtonUp : result.s = "#__event_LeftButtonUp"       ; The left mouse button was released
        Case #__event_LeftClick : result.s = "#__event_LeftClick"             ; A click With the left mouse button
        Case #__event_LeftDoubleClick : result.s = "#__event_LeftDoubleClick" ; A double-click With the left mouse button
        Case #__event_RightButtonDown : result.s = "#__event_RightButtonDown" ; The right mouse button was pressed
        Case #__event_RightButtonUp : result.s = "#__event_RightButtonUp"     ; The right mouse button was released
        Case #__event_RightClick : result.s = "#__event_RightClick"           ; A click With the right mouse button
        Case #__event_RightDoubleClick : result.s = "#__event_RightDoubleClick" ; A double-click With the right mouse button
        Case #__event_MiddleButtonDown : result.s = "#__event_MiddleButtonDown" ; The middle mouse button was pressed
        Case #__event_MiddleButtonUp : result.s = "#__event_MiddleButtonUp"     ; The middle mouse button was released
        Case #__event_Focus : result.s = "#__event_Focus"                       ; The gadget gained keyboard focus
        Case #__event_LostFocus : result.s = "#__event_LostFocus"               ; The gadget lost keyboard focus
        Case #__event_KeyDown : result.s = "#__event_KeyDown"                   ; A key was pressed
        Case #__event_KeyUp : result.s = "#__event_KeyUp"                       ; A key was released
        Case #__event_Input : result.s = "#__event_Input"                       ; Text input was generated
        Case #__event_Resize : result.s = "#__event_Resize"                     ; The gadget has been resized
        Case #__event_StatusChange : result.s = "#__event_StatusChange"
        Case #__event_TitleChange : result.s = "#__event_TitleChange"
        Case #__event_Change : result.s = "#__event_Change"
        Case #__event_DragStart : result.s = "#__event_DragStart"
        Case #__event_ReturnKey : result.s = "#__event_returnKey"
        Case #__event_CloseItem : result.s = "#__event_CloseItem"
          
        Case #__event_Down : result.s = "#__event_Down"
        Case #__event_Up : result.s = "#__event_Up"
          
        Case #__event_mousewheelX : result.s = "#__event_MouseWheelX"
        Case #__event_mousewheelY : result.s = "#__event_MouseWheelY"
      EndSelect
      
      ProcedureReturn result.s
    EndProcedure
    
    ;-
    Macro Clip( _address_, _mode_ = [#__c_draw] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( draw, #PB_Module ))
        PB(ClipOutput)( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    
    Procedure ClipPut( *this._S_widget, x, y, width, height )
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
    
    Procedure Reclip( *this._S_widget )
      Macro _clip_caption_( _this_ )
        ClipPut( _this_, _this_\caption\x[#__c_inner], _this_\caption\y[#__c_inner], _this_\caption\width[#__c_inner], _this_\caption\height[#__c_inner] )
      EndMacro
      
      Macro _clip_width_( _address_, _parent_, _x_width_, _parent_ix_iwidth_, _mode_ = )
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
          *this\width[#__c_draw]  = *this\width
          *this\width[#__c_draw2] = *this\width
        EndIf
        If *this\height[#__c_draw] <> *this\height
          *this\height[#__c_draw]  = *this\height
          *this\height[#__c_draw2] = *this\height
        EndIf
      Else
        If *parent
          _p_x2_ = *parent\x[#__c_inner] + *parent\width[#__c_inner]
          _p_y2_ = *parent\y[#__c_inner] + *parent\height[#__c_inner]
          
          ; for the splitter childrens
          If *parent\type = #__type_Splitter
            If *parent\splitter_gadget_1( ) = *this
              _p_x2_ = *parent\bar\button[1]\x + *parent\bar\button[1]\width
              _p_y2_ = *parent\bar\button[1]\y + *parent\bar\button[1]\height
            EndIf
            If *parent\splitter_gadget_2( ) = *this
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
            If *parent\scroll_width( ) And
               _p_x2_ > *parent\x[#__c_inner] + *parent\scroll_x( ) + *parent\scroll_width( )
              _p_x2_ = *parent\x[#__c_inner] + *parent\scroll_x( ) + *parent\scroll_width( )
            EndIf
            If *parent\scroll_height( ) And
               _p_y2_ > *parent\y[#__c_inner] + *parent\scroll_y( ) + *parent\scroll_height( )
              _p_y2_ = *parent\y[#__c_inner] + *parent\scroll_y( ) + *parent\scroll_height( )
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
          If *this\scroll_width( ) And *this\scroll_width( ) < *this\width[#__c_inner]
            _clip_width_( *this, *parent, *this\x[#__c_inner] + *this\scroll_width( ), _p_x2_, [#__c_draw2] )
          Else
            _clip_width_( *this, *parent, *this\x[#__c_inner] + *this\width[#__c_inner], _p_x2_, [#__c_draw2] )
          EndIf
          If *this\scroll_height( ) And *this\scroll_height( ) < *this\height[#__c_inner]
            _clip_height_( *this, *parent, *this\y[#__c_inner] + *this\scroll_height( ), _p_y2_, [#__c_draw2] )
          Else
            _clip_height_( *this, *parent, *this\y[#__c_inner] + *this\height[#__c_inner], _p_y2_, [#__c_draw2] )
          EndIf
        EndIf
      EndIf
      
      ;
      ; clip child bar
      If *this\TabBox( )
        *this\TabBox( )\x[#__c_draw]      = *this\x[#__c_draw]
        *this\TabBox( )\y[#__c_draw]      = *this\y[#__c_draw]
        *this\TabBox( )\width[#__c_draw]  = *this\width[#__c_draw]
        *this\TabBox( )\height[#__c_draw] = *this\height[#__c_draw]
      EndIf
      If *this\StringBox( )
        *this\StringBox( )\x[#__c_draw]      = *this\x[#__c_draw]
        *this\StringBox( )\y[#__c_draw]      = *this\y[#__c_draw]
        *this\StringBox( )\width[#__c_draw]  = *this\width[#__c_draw]
        *this\StringBox( )\height[#__c_draw] = *this\height[#__c_draw]
      EndIf
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\x[#__c_draw]      = *this\x[#__c_draw]
          *this\scroll\v\y[#__c_draw]      = *this\y[#__c_draw]
          *this\scroll\v\width[#__c_draw]  = *this\width[#__c_draw]
          *this\scroll\v\height[#__c_draw] = *this\height[#__c_draw]
        EndIf
        If *this\scroll\h
          *this\scroll\h\x[#__c_draw]      = *this\x[#__c_draw]
          *this\scroll\h\y[#__c_draw]      = *this\y[#__c_draw]
          *this\scroll\h\width[#__c_draw]  = *this\width[#__c_draw]
          *this\scroll\h\height[#__c_draw] = *this\height[#__c_draw]
        EndIf
      EndIf
      
      ProcedureReturn Bool( *this\width[#__c_draw] > 0 And *this\height[#__c_draw] > 0 )
    EndProcedure
    
    Procedure.b Resize( *this._S_widget, x.l, y.l, width.l, height.l )
      Protected.b result
      Protected.l ix, iy, iwidth, iheight, Change_x, Change_y, Change_width, Change_height
      ; Debug " resize - "+*this\class +" "+x +" "+ width
      
      
      
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
      
      If *this\type = #__type_Window Or
         *this\type = #__type_Container
        If *this\barHeight
          Debug "" + *this\class + " " + *this\barHeight + " " + *this\MenuBarHeight + " " + *this\ToolBarHeight
        EndIf
        
        If *this\fs[2] <> *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
          *this\fs[2] = *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
        EndIf
      EndIf
      
      ;
      If is_root_container_( *this ) ;??????
        ResizeWindow( *this\_root( )\canvas\window, #PB_Ignore, #PB_Ignore, width, height )
        PB(ResizeGadget)( *this\_root( )\canvas\gadget, #PB_Ignore, #PB_Ignore, width, height )
        x = ( *this\bs * 2 - *this\fs * 2 )
        y = ( *this\bs * 2 - *this\fs * 2 )
        width - ( *this\bs * 2 - *this\fs * 2 ) * 2
        height - ( *this\bs * 2 - *this\fs * 2 ) * 2
        
        *this\x[#__c_frame] = #PB_Ignore
        *this\y[#__c_frame] = #PB_Ignore
        ;           *this\width[#__c_frame] = #PB_Ignore
        ;           *this\height[#__c_frame] = #PB_Ignore
      ElseIf *this\autosize
        If *this\_parent( ) And *this <> *this\_parent( )
          x      = *this\_parent( )\x[#__c_inner]
          Y      = *this\_parent( )\y[#__c_inner]
          width  = *this\_parent( )\width[#__c_inner]
          height = *this\_parent( )\height[#__c_inner]
        EndIf
        
      Else
        ;\\
        If a_transform( ) And a_transform( )\grid_size > 1 And *this = a_focused( ) And *this <> a_transform( )\main
          If *this\_a_\transform > 0
            If x <> #PB_Ignore
              x + ( x % a_transform( )\grid_size )
              x = ( x / a_transform( )\grid_size ) * a_transform( )\grid_size
            EndIf
            
            If y <> #PB_Ignore
              y + ( y % a_transform( )\grid_size )
              y = ( y / a_transform( )\grid_size ) * a_transform( )\grid_size
            EndIf
            
            If width <> #PB_Ignore
              width + ( width % a_transform( )\grid_size )
              width = ( width / a_transform( )\grid_size ) * a_transform( )\grid_size + 1
            EndIf
            
            If height <> #PB_Ignore
              height + ( height % a_transform( )\grid_size )
              height = ( height / a_transform( )\grid_size ) * a_transform( )\grid_size + 1
            EndIf
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
                If x > *this\bounds\move\max\x - *this\width[#__c_frame]
                  x = *this\bounds\move\max\x - *this\width[#__c_frame]
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
                If y > *this\bounds\move\max\y - *this\height[#__c_frame]
                  y = *this\bounds\move\max\y - *this\height[#__c_frame]
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ size boundaries
        If *this\bounds\size
          If width <> #PB_Ignore  
            If #PB_Ignore <> *this\bounds\size\min\width And 
               width < *this\bounds\size\min\width 
              If x <> #PB_Ignore 
                x + ( width - *this\bounds\size\min\width )
              EndIf
              width = *this\bounds\size\min\width
            EndIf
            If #PB_Ignore <> *this\bounds\size\max\width And
               width > *this\bounds\size\max\width 
              width = *this\bounds\size\max\width
            EndIf
            
            ;\\
            If *this\bounds\move
              If x <> #PB_Ignore 
                If width > *this\bounds\size\max\width - ( x - *this\bounds\move\min\x ) 
                  width = *this\bounds\size\max\width - ( x - *this\bounds\move\min\x )
                EndIf
              Else
                If width > *this\bounds\size\max\width - ( *this\x[#__c_frame] - *this\bounds\move\min\x ) 
                  width = *this\bounds\size\max\width - ( *this\x[#__c_frame] - *this\bounds\move\min\x )
                EndIf
              EndIf
            EndIf
          EndIf
          If height <> #PB_Ignore  
            If #PB_Ignore <> *this\bounds\size\min\height And
               height < *this\bounds\size\min\height 
              If y <> #PB_Ignore  
                y + ( height - *this\bounds\size\min\height )
              EndIf
              height = *this\bounds\size\min\height
            EndIf
            If #PB_Ignore <> *this\bounds\size\max\height And
               height > *this\bounds\size\max\height 
              height = *this\bounds\size\max\height
            EndIf
            
            ;\\
            If *this\bounds\move
              If y <> #PB_Ignore 
                If height > *this\bounds\size\max\height - ( y - *this\bounds\move\min\y ) 
                  height = *this\bounds\size\max\height - ( y - *this\bounds\move\min\y )
                EndIf
              Else
                If height > *this\bounds\size\max\height - ( *this\y[#__c_frame] - *this\bounds\move\min\y ) 
                  height = *this\bounds\size\max\height - ( *this\y[#__c_frame] - *this\bounds\move\min\y )
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If x = #PB_Ignore
          x = *this\x[#__c_container]
        Else
          If *this\_parent( )
            If Not is_integral_( *this )
              x + *this\_parent( )\scroll_x( )
            EndIf
            *this\x[#__c_container] = x
          EndIf
        EndIf
        If y = #PB_Ignore
          y = *this\y[#__c_container]
        Else
          If *this\_parent( )
            If Not is_integral_( *this )
              y + *this\_parent( )\scroll_y( )
            EndIf
            *this\y[#__c_container] = y
          EndIf
        EndIf
        
        ;\\
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
        
        ;\\
        If *this\_parent( ) And *this <> *this\_parent( ) And *this <> *this\_root( )
          If Not ( *this\attach And *this\attach\mode = 2 )
            x + *this\_parent( )\x[#__c_inner]
          EndIf
          If Not ( *this\attach And *this\attach\mode = 1 )
            y + *this\_parent( )\y[#__c_inner]
          EndIf
          
          ;\\ потому что точки внутри контейнера перемешаем надо перемести и детей
          If Not *this\attach 
            If *this\_a_\transform And  
               (*this\_parent( )\container > 0 And
                *this\_parent( )\type <> #__type_MDI)
              y - *this\_parent( )\fs
              x - *this\_parent( )\fs
            EndIf
          EndIf
        EndIf
        
        ;\\ потому что окну задаются внутренные размеры
        If *this\type = #__type_window
          width + *this\fs * 2 + ( *this\fs[1] + *this\fs[3] )
          Height + *this\fs * 2 + ( *this\fs[2] + *this\fs[4] )
        EndIf
      EndIf
      
      ;\\
      If PopupWidget( )
        Debug "resize - " + *this\autosize + " " + *this\class + " " + x + " " + y + " " + width + " " + height
      EndIf
      
        
      ; inner x&y position
      ix      = ( x + *this\fs + *this\fs[1] )
      iy      = ( y + *this\fs + *this\fs[2] )
      iwidth  = width - *this\fs * 2 - ( *this\fs[1] + *this\fs[3] )
      iheight = height - *this\fs * 2 - ( *this\fs[2] + *this\fs[4] )
      
      ;
      If *this\x[#__c_frame] <> x : Change_x = x - *this\x[#__c_frame] : EndIf
      If *this\y[#__c_frame] <> y : Change_y = y - *this\y[#__c_frame] : EndIf
      If *this\width[#__c_frame] <> width : Change_width = width - *this\width[#__c_frame] : EndIf
      If *this\height[#__c_frame] <> height : Change_height = height - *this\height[#__c_frame] : EndIf
      
      If *this\x[#__c_inner] <> ix : Change_x = ix - *this\x[#__c_inner] : EndIf
      If *this\y[#__c_inner] <> iy : Change_y = iy - *this\y[#__c_inner] : EndIf
      If *this\width[#__c_container] <> iwidth : Change_width = iwidth - *this\width[#__c_container] : EndIf
      If *this\height[#__c_container] <> iheight : Change_height = iheight - *this\height[#__c_container] : EndIf
      
      ;
      If Change_x
        *this\resize | #__resize_x
        
        *this\x[#__c_frame]  = x
        *this\x[#__c_inner]  = ix
        *this\x[#__c_screen] = x - ( *this\bs - *this\fs )
        If *this\_window( )
          *this\x[#__c_window] = x - *this\_window( )\x[#__c_inner]
        EndIf
      EndIf
      If Change_y
        *this\resize | #__resize_y
        
        *this\y[#__c_frame]  = y
        *this\y[#__c_inner]  = iy
        *this\y[#__c_screen] = y - ( *this\bs - *this\fs )
        If *this\_window( )
          *this\y[#__c_window] = y - *this\_window( )\y[#__c_inner]
        EndIf
      EndIf
      If Change_width
        *this\resize | #__resize_width
        
        *this\width[#__c_frame]     = width
        *this\width[#__c_container] = iwidth
        *this\width[#__c_screen]    = width + ( *this\bs * 2 - *this\fs * 2 )
        If *this\width[#__c_container] < 0
          *this\width[#__c_container] = 0
        EndIf
        *this\width[#__c_inner] = *this\width[#__c_container]
      EndIf
      If Change_height
        *this\resize | #__resize_height
        
        *this\height[#__c_frame]     = height
        *this\height[#__c_container] = iheight
        *this\height[#__c_screen]    = height + ( *this\bs * 2 - *this\fs * 2 )
        If *this\height[#__c_container] < 0
          *this\height[#__c_container] = 0
        EndIf
        *this\height[#__c_inner] = *this\height[#__c_container]
      EndIf
      
      ;\\
      If ( Change_x Or Change_y Or Change_width Or Change_height )
        *this\resize | #__resize_change
        *this\state\repaint = #True
        
        
        ;\\
        If ( Change_width Or Change_height )
          If *this\type = #__type_Image Or
             *this\type = #__type_ButtonImage
            *this\ImageChange( ) = 1
          EndIf
          
          If *this\type = #__type_Button
            *this\WidgetChange( ) = #True
            *this\TextChange( )   = #True
          EndIf
          
          If *this\count\items
            If Change_height
              If *this\scroll_height( ) >= *this\height[#__c_inner]
                *this\WidgetChange( ) = 1
              EndIf
            EndIf
            
            If Change_width
              If *this\scroll_width( ) >= *this\width[#__c_inner]
                If *this\type <> #__type_Tree
                  *this\WidgetChange( ) = #__resize_width
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; if the integral scroll bars
        ;\\ resize vertical&horizontal scrollbars
        If *this\scroll And *this\scroll\v And *this\scroll\h
          bar_Resizes( *this, 0, 0, *this\width[#__c_container], *this\height[#__c_container] )
        EndIf
        
        ;\\ if the integral tab bar
        If *this\TabBox( ) And is_integral_( *this\TabBox( ) )
          *this\x[#__c_inner] = x ; - *this\fs - *this\fs[1]
          *this\y[#__c_inner] = y ; - *this\fs - *this\fs[2]
          
          ;\\
          If *this\type = #__type_Panel
            If *this\TabBox( )\bar\vertical
              If *this\fs[1]
                Resize( *this\TabBox( ), *this\fs, *this\fs, *this\fs[1], *this\height[#__c_inner] )
              EndIf
              If *this\fs[3]
                Resize( *this\TabBox( ), *this\width[#__c_inner], *this\fs, *this\fs[3], *this\height[#__c_inner] )
              EndIf
            Else
              If *this\fs[2]
                Resize( *this\TabBox( ), *this\fs, *this\fs, *this\width[#__c_inner], *this\fs[2])
              EndIf
              If *this\fs[4]
                Resize( *this\TabBox( ), *this\fs, *this\height[#__c_inner], *this\width[#__c_inner], *this\fs[4])
              EndIf
            EndIf
          EndIf
          
          ;\\
          If *this\type = #__type_window
            ;If *this\TabBox( )
            Resize( *this\TabBox( ), *this\fs, (*this\fs + *this\fs[2]) - *this\ToolBarHeight , *this\width[#__c_frame], *this\ToolBarHeight )
            ;EndIf
          EndIf
          
          *this\x[#__c_inner] + *this\fs + *this\fs[1]
          *this\y[#__c_inner] + *this\fs + *this\fs[2]
        EndIf
        
        ;\\
        If *this\type = #__type_Window
          result = Update( *this )
        EndIf
        
        ;\\
        If *this\type = #__type_ComboBox
          If *this\StringBox( )
            *this\_box_\width = *this\fs[3]
            *this\_box_\x     = *this\x + *this\width - *this\_box_\width
          Else
            *this\_box_\width = *this\width[#__c_inner]
            *this\_box_\x     = *this\x[#__c_inner]
          EndIf
          
          *this\_box_\y      = *this\y[#__c_inner]
          *this\_box_\height = *this\height[#__c_inner]
        EndIf
        
        ;\\ if the widgets is composite
        ;If *this\type = #__type_Spin
        If *this\StringBox( )
          Resize( *this\StringBox( ), *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner] )
        EndIf
        ;EndIf
        
        ;\\ parent mdi
        If *this\_parent( ) And
           is_integral_( *this ) And
           *this\_parent( )\type = #__type_MDI And
           *this\_parent( )\scroll And
           *this\_parent( )\scroll\v <> *this And
           *this\_parent( )\scroll\h <> *this And
           *this\_parent( )\scroll\v\bar\PageChange( ) = 0 And
           *this\_parent( )\scroll\h\bar\PageChange( ) = 0
          
          bar_mdi_update( *this\_parent( ), *this\x[#__c_container], *this\y[#__c_container], *this\width[#__c_frame], *this\height[#__c_frame] )
        EndIf
        
        ;\\
        If *this\type = #__type_Spin Or
           *this\type = #__type_TabBar Or
           *this\type = #__type_ToolBar Or
           *this\type = #__type_TrackBar Or
           *this\type = #__type_ScrollBar Or
           *this\type = #__type_ProgressBar Or
           *this\type = #__type_Splitter
          
          If ( Change_width Or Change_height )
            *this\TabChange( ) = - 1
          EndIf
          
          ; Debug "-- bar_Update -- "+" "+ *this\class
          bar_Update( *this, Bool( Change_width Or Change_height ) )
        EndIf
        
        ;-\\ childrens resize
        ;\\ then move and size parent resize all childrens
        If *this\count\childrens And *this\container
          Protected pw, ph
          
          If StartEnumerate( *this )
            If Not is_scrollbars_( enumWidget( ))
              If enumWidget( )\align
                ;\\
                If enumWidget( )\_parent( )\align
                  pw = ( enumWidget( )\_parent( )\width[#__c_inner] - enumWidget( )\_parent( )\align\width )
                  ph = ( enumWidget( )\_parent( )\height[#__c_inner] - enumWidget( )\_parent( )\align\height )
                EndIf
                
                ;\\
                ;\\ horizontal
                ;\\
                If enumWidget( )\align\left > 0
                  x = enumWidget( )\align\x
                  If enumWidget( )\align\right < 0
                    If enumWidget( )\align\left = 0
                      x + pw / 2
                    EndIf
                    width = (( enumWidget( )\align\x + enumWidget( )\align\width ) + pw / 2 ) - x
                  EndIf
                EndIf
                If Not enumWidget( )\align\right
                  width = enumWidget( )\align\width
                  
                  If Not enumWidget( )\align\left
                    x = enumWidget( )\align\x
                    If enumWidget( )\align\left = 0
                      x + pw / 2
                    EndIf
                    width = (( enumWidget( )\align\x + enumWidget( )\align\width ) + pw / 2 ) - x
                  EndIf
                EndIf
                If enumWidget( )\align\right > 0
                  x = enumWidget( )\align\x
                  If enumWidget( )\align\left < 0
                    ;\\ ( left = proportional & right = 1 )
                    x     = enumWidget( )\align\x + pw / 2
                    width = (( enumWidget( )\align\x + enumWidget( )\align\width ) + pw ) - x
                  Else
                    If enumWidget( )\align\left = 0
                      x + pw
                    EndIf
                    width = (( enumWidget( )\align\x + enumWidget( )\align\width ) + pw ) - x
                  EndIf
                EndIf
                ;\\ horizontal proportional
                If ( enumWidget( )\align\left < 0 And enumWidget( )\align\right <= 0 ) Or
                   ( enumWidget( )\align\right < 0 And enumWidget( )\align\left <= 0 )
                  Protected ScaleX.f = enumWidget( )\_parent( )\width[#__c_inner] / enumWidget( )\_parent( )\align\width
                  width = ScaleX * enumWidget( )\align\width
                  ;\\ center proportional
                  If enumWidget( )\align\left < 0 And enumWidget( )\align\right < 0
                    x = ( enumWidget( )\_parent( )\width[#__c_inner] - width ) / 2
                  ElseIf enumWidget( )\align\left < 0 And enumWidget( )\align\right = 0
                    ;\\ right proportional
                    x = enumWidget( )\_parent( )\width[#__c_inner] - ( enumWidget( )\_parent( )\align\width - enumWidget( )\align\x - enumWidget( )\align\width ) - width
                  ElseIf ( enumWidget( )\align\right < 0 And enumWidget( )\align\left = 0 )
                    ;\\ left proportional
                    x = enumWidget( )\align\x
                  EndIf
                EndIf
                
                ;\\
                ;\\ vertical
                ;\\
                If enumWidget( )\align\top > 0
                  y = enumWidget( )\align\y
                  If enumWidget( )\align\bottom < 0
                    If enumWidget( )\align\top = 0
                      y + ph / 2
                    EndIf
                    height = (( enumWidget( )\align\y + enumWidget( )\align\height ) + ph / 2 ) - y
                  EndIf
                EndIf
                If Not enumWidget( )\align\bottom
                  height = enumWidget( )\align\height
                  
                  If Not enumWidget( )\align\top
                    y = enumWidget( )\align\y
                    If enumWidget( )\align\top = 0
                      y + ph / 2
                    EndIf
                    height = (( enumWidget( )\align\y + enumWidget( )\align\height ) + ph / 2 ) - y
                  EndIf
                EndIf
                If enumWidget( )\align\bottom > 0
                  y = enumWidget( )\align\y
                  If enumWidget( )\align\top < 0
                    ;\\ ( top = proportional & bottom = 1 )
                    y      = enumWidget( )\align\y + ph / 2
                    height = (( enumWidget( )\align\y + enumWidget( )\align\height ) + ph ) - y
                  Else
                    If enumWidget( )\align\top = 0
                      y + ph
                    EndIf
                    height = (( enumWidget( )\align\y + enumWidget( )\align\height ) + ph ) - y
                  EndIf
                EndIf
                ;\\ vertical proportional
                If ( enumWidget( )\align\top < 0 And enumWidget( )\align\bottom <= 0 ) Or
                   ( enumWidget( )\align\bottom < 0 And enumWidget( )\align\top <= 0 )
                  Protected ScaleY.f = enumWidget( )\_parent( )\height[#__c_inner] / enumWidget( )\_parent( )\align\height
                  height = ScaleY * enumWidget( )\align\height
                  ;\\ center proportional
                  If enumWidget( )\align\top < 0 And enumWidget( )\align\bottom < 0
                    y = ( enumWidget( )\_parent( )\height[#__c_inner] - height ) / 2
                  ElseIf enumWidget( )\align\top < 0 And enumWidget( )\align\bottom = 0
                    ;\\ bottom proportional
                    y = enumWidget( )\_parent( )\height[#__c_inner] - ( enumWidget( )\_parent( )\align\height - enumWidget( )\align\y - enumWidget( )\align\height ) - height
                  ElseIf ( enumWidget( )\align\bottom < 0 And enumWidget( )\align\top = 0 )
                    ;\\ top proportional
                    y = enumWidget( )\align\y
                  EndIf
                EndIf
                
                
                Resize( enumWidget( ), x, y, width, height )
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
        
        ;\\
        If PopupWidget( )
          If *this = PopupWidget( )\_parent( )
            Resize( PopupWidget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          EndIf
        EndIf
        
        If *this\_root( ) And *this\_root( )\canvas\ResizeBeginWidget = #Null
          ;Debug "  start - resize"
          *this\_root( )\canvas\ResizeBeginWidget = *this
          Post( *this, #__event_ResizeBegin )
        EndIf
        
        If *this\_a_ And *this\_a_\id And *this\_a_\transform
          a_move( *this\_a_\id, *this\container,
                  *this\x[#__c_screen],
                  *this\y[#__c_screen],
                  *this\width[#__c_screen],
                  *this\height[#__c_screen] )
        EndIf
        
        If *this\_a_\transform Or *this\container
          Post( *this, #__event_Resize )
        EndIf
      EndIf
      
      ;
      ProcedureReturn *this\state\repaint
    EndProcedure
    
    ;-
    Macro set_hide_state_( _this_ )
      _this_\hide = Bool( _this_\state\hide Or
                          _this_\_parent( )\hide Or
                          ( _this_\_parent( )\TabBox( ) And
                            _this_\_parent( )\TabBoxFocusedIndex( ) <> _this_\TabIndex( ) ))
      _this_\resize | #__resize_change
    EndMacro
    
    Procedure HideChildrens( *this._S_widget )
      If *this\address
        PushListPosition( *this\_widgets( ) )
        ChangeCurrentElement( *this\_widgets( ), *this\address )
        While NextElement( *this\_widgets( ) )
          If *this\_widgets( ) = *this\after\widget
            Break
          EndIf
          
          ; hide all children except those whose parent-item is selected
          set_hide_state_( *this\_widgets( ) )
        Wend
        PopListPosition( *this\_widgets( ) )
      EndIf
    EndProcedure
    
    Procedure.b Hide( *this._S_widget, State.b = #PB_Default )
      If State = #PB_Default
        ProcedureReturn *this\hide
      Else
        *this\hide       = State
        *this\state\hide = *this\hide
        
        If *this\count\childrens
          HideChildrens( *this )
        EndIf
      EndIf
    EndProcedure
    
    ;
    Macro set_disable_state_( _this_ )
      ;       _this_\disable = Bool( _this_\state\disable Or
      ;                           _this_\_parent( )\disable Or
      ;                           ( _this_\_parent( )\TabBox( ) And
      ;                             _this_\_parent( )\TabBoxFocusedIndex( ) <> _this_\TabIndex( ) ))
      ;       _this_\resize | #__resize_change
    EndMacro
    
    Procedure DisableChildrens( *this._S_widget )
      If *this\address
        PushListPosition( *this\_widgets( ) )
        ChangeCurrentElement( *this\_widgets( ), *this\address )
        While NextElement( *this\_widgets( ) )
          If *this\_widgets( ) = *this\after\widget
            Break
          EndIf
          
          ; disable all children except those whose parent-item is selected
          ; set_disable_state_(  *this\_widgets( ) )
          If *this\state\disable
            *this\_widgets( )\state\disable = - 1
          Else
            *this\_widgets( )\state\disable = 0
          EndIf
          
          If *this\_widgets( )\TabBox( )
            If *this\_widgets( )\state\disable
              *this\_widgets( )\TabBox( )\state\disable = - 1
            Else
              *this\_widgets( )\TabBox( )\state\disable = 0
            EndIf
          EndIf
          If *this\_widgets( )\StringBox( )
            If *this\_widgets( )\state\disable
              *this\_widgets( )\StringBox( )\state\disable = - 1
            Else
              *this\_widgets( )\StringBox( )\state\disable = 0
            EndIf
          EndIf
          If *this\_widgets( )\scroll
            If *this\_widgets( )\scroll\v
              If *this\_widgets( )\state\disable
                *this\_widgets( )\scroll\v\state\disable = - 1
              Else
                *this\_widgets( )\scroll\v\state\disable = 0
              EndIf
            EndIf
            If *this\_widgets( )\scroll\h
              If *this\_widgets( )\state\disable
                *this\_widgets( )\scroll\h\state\disable = - 1
              Else
                *this\_widgets( )\scroll\h\state\disable = 0
              EndIf
            EndIf
          EndIf
          
        Wend
        PopListPosition( *this\_widgets( ) )
        
        ; ;                 PushListPosition(enumWidget( ))
        ; ;                 If StartEnumerate( *this )
        ; ;                   ; Debug "disable "+enumWidget( )\text\string
        ; ;                   If *this\state\disable
        ; ;                     enumWidget( )\state\disable =- 1
        ; ;                   Else
        ; ;                     enumWidget( )\state\disable = 0
        ; ;                   EndIf
        ; ;                   StopEnumerate( )
        ; ;                 EndIf
        ; ;                 PopListPosition(enumWidget( ))
        
      EndIf
    EndProcedure
    
    Procedure.b Disable( *this._S_widget, State.b = #PB_Default )
      Protected result.b = *this\state\disable
      
      If State >= 0 And
         *this\state\disable <> State
        Debug " DISABLE - " + *this\class + " " + State
        ;         ;
        ;         If *this\state\disable =- 1
        ;           If *this\count\childrens
        ;             PushListPosition(enumWidget( ))
        ;             If StartEnumerate( *this )
        ;               ; Debug "enable "+enumWidget( )\text\string
        ;               enumWidget( )\state\disable = 0
        ;               StopEnumerate( )
        ;             EndIf
        ;             PopListPosition(enumWidget( ))
        ;           EndIf
        ;         EndIf
        
        *this\state\disable = State
        
        If *this\TabBox( )
          If *this\state\disable
            *this\TabBox( )\state\disable = - 1
          Else
            *this\TabBox( )\state\disable = 0
          EndIf
        EndIf
        If *this\StringBox( )
          If *this\state\disable
            *this\StringBox( )\state\disable = - 1
          Else
            *this\StringBox( )\state\disable = 0
          EndIf
        EndIf
        If *this\scroll
          If *this\scroll\v
            If *this\state\disable
              *this\scroll\v\state\disable = - 1
            Else
              *this\scroll\v\state\disable = 0
            EndIf
          EndIf
          If *this\scroll\h
            If *this\state\disable
              *this\scroll\h\state\disable = - 1
            Else
              *this\scroll\h\state\disable = 0
            EndIf
          EndIf
        EndIf
        
        If *this\count\childrens
          DisableChildrens( *this._S_widget )
        EndIf
        
        PostCanvasRepaint( *this )
      EndIf
      
      ProcedureReturn result
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
      Bool( Bool(((( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) < 0 And bar_SetState( _this_, (( _pos_ ) + _this_\bar\min ) )) Or
            Bool(( (( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) > ( _this_\bar\page\len - ( _len_ )) And bar_SetState( _this_, (( _pos_ ) + _this_\bar\min ) - ( _this_\bar\page\len - ( _len_ ) ))) )
    EndMacro
    
    Macro bar_invert_page_pos_( _bar_, _scroll_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min )) + Bool( Not _bar_\invert ) * ( _scroll_pos_ ))
    EndMacro
    
    Macro bar_invert_thumb_pos_( _bar_, _thumb_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\area\end - _thumb_pos_ ) +
        Bool( Not _bar_\invert ) * ( _bar_\area\pos + _thumb_pos_ ))
    EndMacro
    
    ;-
    Procedure bar_tab_AddItem( *this._S_widget, Item.i, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected result
      
      If Item = - 1 Or
         Item > *this\count\items - 1
        LastElement( *this\_tabs( ))
        AddElement( *this\_tabs( ))
        Item = ListIndex( *this\_tabs( ))
      Else
        If SelectElement( *this\_tabs( ), Item )
          If *this\FocusedTabIndex( ) >= Item
            *this\FocusedTabIndex( ) + 1
          EndIf
          
          If *this = *this\_parent( )\TabBox( )
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
      
      ;\\ TabBar last opened item
      *this\OpenedTabIndex( ) = Item
      *this\TabChange( )      = #True
      *this\count\items + 1
      
      ;\\
      *this\bar\_s.allocate( TABS, ( ))
      *this\_tabs( )\color       = _get_colors_( )
      *this\_tabs( )\height      = *this\height - 1
      *this\_tabs( )\text\string = Text.s
      *this\_tabs( )\index       = item
      
      ;\\ set default selected tab
      If item = 0
        If *this\FocusedTab( )
          *this\FocusedTab( )\state\focus = #False
        EndIf
        
        *this\FocusedTabIndex( )        = 0
        *this\FocusedTab( )             = *this\_tabs( )
        *this\FocusedTab( )\state\focus = - 1 ; scroll to active tab
      EndIf
      
      set_image_( *this, *this\_tabs( )\Image, Image )
      PostCanvasRepaint( *this )
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i bar_tab_SetState( *this._S_widget, State.l )
      Protected result.b
      
      ; prevent selection of a non-existent tab
      If State < 0
        State = - 1
      EndIf
      If State > *this\count\items - 1
        State = *this\count\items - 1
      EndIf
      
      If *this\FocusedTabIndex( ) <> State
        *this\FocusedTabIndex( ) = State
        
        *this\TabChange( ) = #True
        
        If state = - 1
          *this\FocusedTab( ) = #Null
        Else
          ;PushListPosition( *this\_tabs( ) )
          SelectElement( *this\_tabs( ), state )
          
          If *this\FocusedTab( )
            *this\FocusedTab( )\state\focus = #False
          EndIf
          
          *this\FocusedTab( )             = *this\_tabs( )
          *this\FocusedTab( )\state\focus = - 1 ; scroll to active tab
          
          ;PopListPosition( *this\_tabs( ) )
        EndIf
        
        If is_integral_( *this )
          
          ; enumerate all parent childrens
          If *this\_parent( )\count\childrens
            HideChildrens( *this\_parent( ) )
          EndIf
          ;
          ;           DoEvents( *this\_parent( ), #__event_Change, *this\FocusedTab( ), State )
          ;         Else
          ;           DoEvents( *this, #__event_Change, *this\FocusedTab( ), State )
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure bar_tab_AtPoint( *this._S_widget, eventtype.l, mouse_x.l = - 1, mouse_y.l = - 1 )
      Protected repaint, *tabRow._S_ROWS
      
      If *this\bar
        Protected._s_BUTTONS *SB
        *SB = *this\bar\button
        ;\\
        mouse_x - *SB\x
        mouse_y - *SB\y
        
        ;\\ get at point items if enter inner coordinate                           ;
        If *this\state\enter = 2
          If ListSize( *this\_tabs( ) )
            If Not ( *this\EnteredTab( ) And
                     *this\EnteredTab( )\visible And
                     *this\EnteredTab( )\hide = 0 And
                     ( ( *this\state\enter And is_at_point_( *this\EnteredTab( ), mouse_x, mouse_y )) Or
                       ( *this\state\drag And is_at_point_horizontal_( *this\EnteredTab( ), mouse_x )) ))
              
              ; Debug "seach "+*this\class +" "+ *this\EnteredTab( )
              ; search entered item
              LastElement( *this\_tabs( ))
              Repeat
                If *this\_tabs( )\visible And
                   *this\_tabs( )\hide = 0 And
                   ( ( *this\state\enter And is_at_point_( *this\_tabs( ), mouse_x, mouse_y )) Or
                     ( *this\state\drag And is_at_point_horizontal_( *this\_tabs( ), mouse_x )) )
                  *tabRow = *this\_tabs( )
                  Break
                EndIf
              Until PreviousElement( *this\_tabs( )) = #False
            Else
              *tabRow = *this\EnteredTab( )
            EndIf
          EndIf
        EndIf
        
        ; change enter/leave state
        If *this\EnteredTab( ) <> *tabRow And Not *this\state\drag
          ;\\ leaved tabs
          If *this\EnteredTab( )
            If *this\EnteredTab( )\state\enter = #True
              *this\EnteredTab( )\state\enter = #False
              
              If *this\EnteredTab( )\color\state = #__S_1
                *this\EnteredTab( )\color\state = #__S_0
              EndIf
              
              *this\state\repaint = #True
            EndIf
          EndIf
          
          *this\EnteredTab( ) = *tabRow
          
          ;\\ entered tabs
          If *this\EnteredTab( )
            If *this\state\enter
              If *this\EnteredTab( )\state\enter = #False
                *this\EnteredTab( )\state\enter = #True
                
                If *this\EnteredTab( )\color\state = #__S_0
                  *this\EnteredTab( )\color\state = #__S_1
                EndIf
                
                *this\state\repaint = #True
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i bar_tab_RemoveItem( *this._S_widget, Item.l )
      If SelectElement( *this\_tabs( ), item )
        *this\TabChange( ) = #True
        
        If *this\FocusedTabIndex( ) = *this\_tabs( )\index
          *this\FocusedTabIndex( ) = item - 1
        EndIf
        
        DeleteElement( *this\_tabs( ), 1 )
        
        If *this\_parent( )\TabBox( ) = *this
          Post( *this\_parent( ), #__event_CloseItem, Item )
        Else
          Post( *this, #__event_CloseItem, Item )
        EndIf
        
        *this\count\items - 1
      EndIf
    EndProcedure
    
    Procedure bar_tab_ClearItems( *this._S_widget ) ; Ok
      If *this\count\items <> 0
        
        *this\TabChange( ) = #True
        ClearList( *this\_tabs( ))
        
        If *this\_parent( )\TabBox( ) = *this
          Post( *this\_parent( ), #__event_CloseItem, #PB_All )
        Else
          Post( *this, #__event_CloseItem, #PB_All )
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
    Macro bar_tab_item_draw_( _vertical_, _address_, _x_, _y_, _fore_color_, _back_color_, _frame_color_, _text_color_, _round_)
      ;Draw back
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
      draw_gradient_box_( _vertical_, _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _fore_color_, _back_color_, _round_, _address_\color\_alpha )
      ; Draw frame
      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
      draw_roundbox_( _x_ + _address_\x, _y_ + _address_\y, _address_\width, _address_\height, _round_, _round_, _frame_color_ & $FFFFFF | _address_\color\_alpha << 24 )
      ; Draw items image
      If _address_\image\id
        drawing_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawAlphaImage( _address_\image\id, _x_ + _address_\image\x, _y_ + _address_\image\y, _address_\color\_alpha )
      EndIf
      ; Draw items text
      If _address_\text\string
        drawing_mode_( #PB_2DDrawing_Transparent )
        DrawText( _x_ + _address_\text\x, _y_ + _address_\text\y, _address_\text\string, _text_color_ & $FFFFFF | _address_\color\_alpha << 24 )
      EndIf
    EndMacro
    
    Macro bar_item_draw_( _this_, _item_, x, y, _round_, _mode_ = )
      ;_draw_font_item_( _this_, _item_, 0 )
      
      bar_tab_item_draw_( _this_\bar\vertical, _item_, x, y,
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
        Protected._s_BUTTONS *BB1, *BB2, *SB
        *SB  = *this\bar\button
        *BB1 = *this\bar\button[1]
        *BB2 = *this\bar\button[2]
        
        If *this\_parent( ) And *this\_parent( )\type = #__type_Panel
          pos = 2
        EndIf
        
        pos + Bool(typ) * 2
        
        Protected layout = pos * 2
        Protected text_pos = 6
        
        If Not *this\hide And *this\color\_alpha
          If *this\color\back <> - 1
            ; Draw scroll bar background
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\back & $FFFFFF | *this\color\_alpha << 24 )
          EndIf
          
          ; - widget::bar_tab_update_( )
          If *this\TabChange( )
            *this\image\x = ( *this\height - 16 - pos - 1 ) / 2
            ;Debug " --- widget::Tab_Update( ) - " + *this\image\x
            
            If *this\bar\vertical
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
              If *this\bar\vertical
                *this\_tabs( )\y = *this\bar\max + pos
                
                If *this\FocusedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\x     = 0
                  *this\_tabs( )\width = *SB\width + 1
                Else
                  *this\_tabs( )\x     = 0
                  *this\_tabs( )\width = *SB\width - 1
                EndIf
                
                *this\text\x = ( *this\_tabs( )\width - *this\_tabs( )\text\width ) / 2
                
                *this\_tabs( )\text\y = *this\text\y + *this\_tabs( )\y
                *this\_tabs( )\text\x = *this\text\x + *this\_tabs( )\x
                *this\_tabs( )\height = *this\text\y * 2 + *this\_tabs( )\text\height
                
                *this\bar\max + *this\_tabs( )\height + Bool( *this\_tabs( )\index <> *this\count\items - 1 ) - Bool(typ) * 2 + Bool( *this\_tabs( )\index = *this\count\items - 1 ) * layout
                ;
                If typ And *this\FocusedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\height + 4
                  *this\_tabs( )\y - 2
                EndIf
              Else
                *this\_tabs( )\x = *this\bar\max + pos
                
                If *this\FocusedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\y      = pos;pos - Bool( pos>0 )*2
                  *this\_tabs( )\height = *SB\height - *this\_tabs( )\y + 1
                Else
                  *this\_tabs( )\y      = pos;pos
                  *this\_tabs( )\height = *SB\height - *this\_tabs( )\y - 1
                EndIf
                
                *this\text\y = ( *this\_tabs( )\height - *this\_tabs( )\text\height ) / 2
                ;
                *this\_tabs( )\image\y = *this\_tabs( )\y + ( *this\_tabs( )\height - *this\_tabs( )\image\height ) / 2
                *this\_tabs( )\text\y  = *this\_tabs( )\y + *this\text\y
                
                ;
                *this\_tabs( )\image\x = *this\_tabs( )\x + Bool( *this\_tabs( )\image\width ) * *this\image\x ;+ Bool( *this\_tabs( )\text\width ) * ( *this\text\x )
                *this\_tabs( )\text\x  = *this\_tabs( )\image\x + *this\_tabs( )\image\width + *this\text\x
                *this\_tabs( )\width   = Bool( *this\_tabs( )\text\width ) * ( *this\text\x * 2 ) + *this\_tabs( )\text\width +
                                         Bool( *this\_tabs( )\image\width ) * ( *this\image\x * 2 ) + *this\_tabs( )\image\width - ( Bool( *this\_tabs( )\image\width And *this\_tabs( )\text\width ) * ( *this\text\x ))
                
                *this\bar\max + *this\_tabs( )\width + Bool( *this\_tabs( )\index <> *this\count\items - 1 ) - Bool(typ) * 2 + Bool( *this\_tabs( )\index = *this\count\items - 1 ) * layout
                ;
                If typ And *this\FocusedTabIndex( ) = *this\_tabs( )\index
                  *this\_tabs( )\width + 4
                  *this\_tabs( )\x - 2
                EndIf
              EndIf
              
            Next
            
            ;
            bar_Update( *this, 2 )
            ; scroll to active tab
            If *this\FocusedTab( ) And *this\FocusedTab( )\state\enter = #False
              If *this\FocusedTab( )\state\focus = - 1
                *this\FocusedTab( )\state\focus = 1
                ;Debug " tab max - " + *this\bar\max + " " + *this\width[#__c_inner] + " " + *this\bar\page\pos + " " + *this\bar\page\end
                
                Protected ThumbPos = *this\bar\max - ( *this\FocusedTab( )\x + *this\FocusedTab( )\width ) - 3 ; to right
                ThumbPos = *this\bar\max - ( *this\FocusedTab( )\x + *this\FocusedTab( )\width ) - ( *this\bar\thumb\end - *this\FocusedTab( )\width ) / 2 - 3   ; to center
                Protected ScrollPos = bar_page_pos_( *this\bar, ThumbPos )
                ScrollPos          = bar_invert_page_pos_( *this\bar, ScrollPos )
                *this\bar\page\pos = ScrollPos
              EndIf
            EndIf
            bar_Update( *this, 0 )
            
            *this\TabChange( ) = #False
          EndIf
          
          ;
          ; drawin
          ;
          If *this\bar\vertical
            *BB2\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] + pos - *BB2\size ) / 2
            *BB1\x = *this\x[#__c_frame] + ( *this\width[#__c_frame] + pos - *BB1\size ) / 2
          Else
            *BB2\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] + pos - *BB2\size ) / 2
            *BB1\y = *this\y[#__c_frame] + ( *this\height[#__c_frame] + pos - *BB1\size ) / 2
          EndIf
          
          
          Protected State_3, Color_frame
          Protected x = *SB\x
          Protected y = *SB\y
          
          
          
          ;           drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;                 color = *this\_parent( )\color\frame[0]
          ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_frame], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs-1, color);*this\color\frame )
          
          ; draw all visible items
          ForEach *this\_tabs( )
            draw_font_item_( *this, *this\_tabs( ), 0 )
            
            ; real visible items
            If *this\bar\vertical
              *this\_tabs( )\visible = Bool( Not *this\_tabs( )\hide And
                                             (( y + *this\_tabs( )\y + *this\_tabs( )\height ) > *this\y[#__c_inner] And
                                              ( y + *this\_tabs( )\y ) < ( *this\y[#__c_inner] + *this\height[#__c_inner] ) ))
            Else
              *this\_tabs( )\visible = Bool( Not *this\_tabs( )\hide And
                                             (( x + *this\_tabs( )\x + *this\_tabs( )\width ) > *this\x[#__c_inner] And
                                              ( x + *this\_tabs( )\x ) < ( *this\x[#__c_inner] + *this\width[#__c_inner] ) ))
            EndIf
            
            ;no &~ entered &~ focused
            If *this\_tabs( )\visible And
               *this\_tabs( )\state\enter = #False And
               *this\_tabs( )\state\press = #False And
               *this\_tabs( )\state\focus = #False
              
              ;                ( *this\_tabs( )\state\enter = #False Or
              ;                  *this\_tabs( )\state\press = #True ) And
              ;                *this\_tabs( )\state\focus = #False
              ;
              bar_item_draw_( *this, *this\_tabs( ), x, y, *SB\round, [0] )
            EndIf
          Next
          
          ; draw mouse-enter visible item
          If *this\EnteredTab( ) And
             *this\EnteredTab( )\visible And
             *this\EnteredTab( )\state\focus = #False
            
            draw_font_item_( *this, *this\EnteredTab( ), 0 )
            bar_item_draw_( *this, *this\EnteredTab( ), x, y, *SB\round, [*this\EnteredTab( )\color\state] )
          EndIf
          
          ; draw key-focus visible item
          If *this\FocusedTab( ) And
             *this\FocusedTab( )\visible
            
            draw_font_item_( *this, *this\FocusedTab( ), 0 )
            bar_item_draw_( *this, *this\FocusedTab( ), x, y, *SB\round, [2] )
          EndIf
          
          
          color = $FF909090
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          ; draw lines
          If *this\FocusedTab( )
            If *this\bar\vertical
              color = *this\FocusedTab( )\color\frame[2]
              ; frame on the selected item
              If *this\FocusedTab( )\visible
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height, color )
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y, *this\FocusedTab( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height - 1, *this\FocusedTab( )\width, 1, color )
              EndIf
              
              color = *this\color\frame[0]
              ; vertical tab right line
              If *this\FocusedTab( )
                Line( *this\x[#__c_frame] + *this\width[#__c_frame] - 1, *this\y[#__c_screen], 1, ( y + *this\FocusedTab( )\y ) - *this\x[#__c_frame], color ) ;*this\_tabs( )\color\fore[2] )
                Line( *this\x[#__c_frame] + *this\width[#__c_frame] - 1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height, 1, *this\y[#__c_frame] + *this\height[#__c_frame] - ( y + *this\FocusedTab( )\y + *this\FocusedTab( )\height ), color ) ; *this\_tabs( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen] + *this\width[#__c_screen] - 1, *this\y[#__c_screen], 1, *this\height[#__c_screen], color )
              EndIf
              
              If is_integral_( *this )
                color = *this\_parent( )\color\back[0]
                ; selected tab inner frame
                Line( x + *this\FocusedTab( )\x + 1, y + *this\FocusedTab( )\y + 1, 1, *this\FocusedTab( )\height - 2, color )
                Line( x + *this\FocusedTab( )\x + 1, y + *this\FocusedTab( )\y + 1, *SB\width, 1, color )
                Line( x + *this\FocusedTab( )\x + 1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height - 2, *SB\width, 1, color )
                
                Protected size1 = 5
                ;
                ;Arrow( *this\x[#__c_screen] + selected_tab_pos + ( *this\FocusedTab( )\width - size1 )/2, *this\y[#__c_frame]+*this\height[#__c_frame] - 5, 11, $ff000000, 1, 1)
                
                Arrow( x + *this\FocusedTab( )\x + ( *this\FocusedTab( )\width - size1 ),
                       y + *this\FocusedTab( )\y + ( *this\FocusedTab( )\height - size1 ) / 2, size1, 0, color, -1 )
                
                
                
                color = *this\_parent( )\color\frame[0]
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame )
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame )
                Line( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame )
              EndIf
            Else
              ; frame on the selected item
              If *this\FocusedTab( )\visible
                color = *this\FocusedTab( )\color\frame[2]
                Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y, *this\FocusedTab( )\width, 1, color )
                Line( x + *this\FocusedTab( )\x , y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height - *this\FocusedTab( )\y, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width - 1, y + *this\FocusedTab( )\y, 1, *this\FocusedTab( )\height - *this\FocusedTab( )\y, color )
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
                Line( *this\x[#__c_screen], *this\y[#__c_frame] + *this\height[#__c_frame] - 1, ( x + *this\FocusedTab( )\x ) - *this\x[#__c_frame], 1, color ) ;*this\_tabs( )\color\fore[2] )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width, *this\y[#__c_frame] + *this\height[#__c_frame] - 1, *this\x[#__c_frame] + *this\width[#__c_frame] - ( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width ), 1, color ) ; *this\_tabs( )\color\fore[2] )
              Else
                Line( *this\x[#__c_screen], *this\y[#__c_frame] + *this\height[#__c_frame] - 1, *this\width[#__c_screen], 1, color )
              EndIf
              
              If is_integral_( *this )
                color = *this\_parent( )\color\back[0] ;*this\_parent( )\color\front[2]
                                                       ; selected tab inner frame
                Line( x + *this\FocusedTab( )\x + 1, y + *this\FocusedTab( )\y + 1, *this\FocusedTab( )\width - 2, 1, color )
                Line( x + *this\FocusedTab( )\x + 1, y + *this\FocusedTab( )\y + 1, 1, *this\FocusedTab( )\height - 1, color )
                Line( x + *this\FocusedTab( )\x + *this\FocusedTab( )\width - 2, y + *this\FocusedTab( )\y + 1, 1, *this\FocusedTab( )\height - 1, color )
                ;Line( x + *this\FocusedTab( )\x +1, y + *this\FocusedTab( )\y + *this\FocusedTab( )\height-1, *this\FocusedTab( )\width-2, 1, color )
                
                ;;drawing_mode_alpha_( #PB_2DDrawing_Default )
                color = *this\_parent( )\color\frame[0]
                ;Box( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_frame], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs+*this\_parent( )\fs[2], color);*this\color\frame )
                
                ; ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs, *this\_parent( )\fs + pos, *this\_parent( )\fs, color);*this\color\frame )
                ; ;                draw_box_( *this\_parent( )\x[#__c_frame] + *this\_parent( )\width[#__c_frame] - (*this\_parent( )\fs + pos), *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs, *this\_parent( )\fs + pos, *this\_parent( )\fs, color);*this\color\frame )
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs[2] - 1, *this\_parent( )\fs-1, *this\_parent( )\fs[2], color);*this\color\frame )
                ;                draw_box_( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner]+1, *this\_parent( )\y[#__c_inner] - *this\_parent( )\fs[2] - 1, *this\_parent( )\fs-1, *this\_parent( )\fs[2], color);*this\color\frame )
                ;
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\fs, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame )
                ;                draw_box_( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, *this\_parent( )\fs, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame )
                ;                draw_box_( *this\_parent( )\x[#__c_frame], *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_frame], *this\_parent( )\fs, color);*this\color\frame )
                
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame )
                Line( *this\_parent( )\x[#__c_inner] + *this\_parent( )\width[#__c_inner], *this\_parent( )\y[#__c_inner] - 1, 1, *this\_parent( )\height[#__c_inner] + 2, color);*this\color\frame )
                Line( *this\_parent( )\x[#__c_inner] - 1, *this\_parent( )\y[#__c_inner] + *this\_parent( )\height[#__c_inner], *this\_parent( )\width[#__c_inner] + 2, 1, color);*this\color\frame )
                
              EndIf
            EndIf
          EndIf
          
          ; Navigation
          Protected fabe_pos, fabe_out, button_size = 20, round = 0, Size = 60
          backcolor = $ffffffff;\_parent( )\_parent( )\color\back[\_parent( )\_parent( )\color\state]
          If Not backcolor
            backcolor = *this\_parent( )\color\back[\_parent( )\color\state]
          EndIf
          If Not backcolor
            backcolor = *BB2\color\back[\color\state]
          EndIf
          
          
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          ResetGradientColors( )
          GradientColor( 0.0, backcolor & $FFFFFF )
          GradientColor( 0.5, backcolor & $FFFFFF | $A0 << 24 )
          GradientColor( 1.0, backcolor & $FFFFFF | 245 << 24 )
          
          fabe_out = Size - button_size
          ;
          If *this\bar\vertical
            ; to top
            If Not *BB2\hide
              fabe_pos = *this\y + ( size ) - *this\fs
              LinearGradient( *this\x + *this\bs, fabe_pos, *this\x + *this\bs, fabe_pos - fabe_out )
              draw_roundbox_( *this\x + *this\bs, fabe_pos, *this\width - *this\bs - 1, - Size, round, round )
            EndIf
            
            ; to bottom
            If Not *BB1\hide
              fabe_pos = *this\y + *this\height - ( size ) + *this\fs * 2
              LinearGradient( *this\x + *this\bs, fabe_pos, *this\x + *this\bs, fabe_pos + fabe_out )
              draw_roundbox_( *this\x + *this\bs, fabe_pos, *this\width - *this\bs - 1 , Size, round, round )
            EndIf
          Else
            ; to left
            If Not *BB2\hide
              fabe_pos = *this\x + ( size ) - *this\fs
              LinearGradient( fabe_pos, *this\y + *this\bs, fabe_pos - fabe_out, *this\y + *this\bs )
              draw_roundbox_( fabe_pos, *this\y + *this\bs, - Size, *this\height - *this\bs - 1, round, round )
            EndIf
            
            ; to right
            If Not *BB1\hide
              fabe_pos = *this\x + *this\width - ( size ) + *this\fs * 2
              LinearGradient( fabe_pos, *this\y + *this\bs, fabe_pos + fabe_out, *this\y + *this\bs )
              draw_roundbox_( fabe_pos, *this\y + *this\bs, Size, *this\height - *this\bs - 1 , round, round )
            EndIf
          EndIf
          
          ResetGradientColors( )
          
          
          
          ; draw navigator
          ; Draw buttons back
          If Not *BB2\hide
            ;             Color = $FF202020
            ;             ; Color = $FF101010
            ;             Item_Color_Background = TabBarGadget_ColorMinus(widget_backcolor1, Color)
            ;             ;Item_Color_Background = TabBarGadget_ColorPlus(widget_backcolor1, Color)
            ;             forecolor = TabBarGadget_ColorPlus(Item_Color_Background, Color)
            ;             ;backcolor = TabBarGadget_ColorMinus(Item_Color_Background, Color)
            ;
            ;             If *BB1\color\state = 3
            ;               Color = $FF303030
            ;              framecolor = TabBarGadget_ColorMinus(*BB1\color\back[*BB1\color\state], Color)
            ;              *BB1\color\frame[*BB1\color\state] = framecolor
            ;              *BB1\color\front[*BB1\color\state] = framecolor
            ; ;
            ;             ElseIf *BB1\color\state = 1
            ; ;                Color = $FF303030
            ; ;              framecolor = TabBarGadget_ColorMinus(*BB1\color\back[*BB1\color\state], Color)
            ; ;              framecolor = TabBarGadget_ColorMinus(framecolor, Color)
            ; ;              *BB1\color\frame[*BB1\color\state] = framecolor
            ; ;              *BB1\color\front[*BB1\color\state] = framecolor
            ;
            ;                *BB1\color\frame[*BB1\color\state] = *BB1\color\front[*BB1\color\state];backcolor
            ;               *BB1\color\back[*BB1\color\state] = backcolor
            ;             *BB1\arrow\size = 6
            ;
            ;             ElseIf *BB1\color\state = 0
            ;               *BB1\color\frame[*BB1\color\state] = backcolor
            ;               *BB1\color\back[*BB1\color\state] = backcolor
            ;               *BB1\arrow\size = 4
            ;             EndIf
            
            ; Draw buttons
            If *BB2\color\fore <> - 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( *this\bar\vertical, *BB2, *BB2\color\fore[*BB2\color\state], *BB2\color\back[*BB2\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_roundbox_( *BB2\x, *BB2\y, *BB2\width, *BB2\height, *BB2\round, *BB2\round, *BB2\color\frame[*BB2\color\state] & $FFFFFF | *BB2\color\_alpha << 24 )
            EndIf
          EndIf
          If Not *BB1\hide
            ; Draw buttons
            If *BB1\color\fore <> - 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( *this\bar\vertical, *BB1, *BB1\color\fore[*BB1\color\state], *BB1\color\back[*BB1\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_roundbox_( *BB1\x, *BB1\y, *BB1\width, *BB1\height, *BB1\round, *BB1\round, *BB1\color\frame[*BB1\color\state] & $FFFFFF | *BB1\color\_alpha << 24 )
            EndIf
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          ; Draw buttons frame
          If Not *BB1\hide
            draw_roundbox_( *BB1\x, *BB1\y, *BB1\width, *BB1\height, *BB1\round, *BB1\round, *BB1\color\frame[*BB1\color\state] & $FFFFFF | *BB1\color\_alpha << 24 )
            
            ; Draw arrows
            If Not *BB1\hide And *BB1\arrow\size
              draw_arrows_( *BB1, Bool( *this\bar\vertical ) + 2 )
            EndIf
          EndIf
          If Not *BB2\hide
            draw_roundbox_( *BB2\x, *BB2\y, *BB2\width, *BB2\height, *BB2\round, *BB2\round, *BB2\color\frame[*BB2\color\state] & $FFFFFF | *BB2\color\_alpha << 24 )
            
            ; Draw arrows
            If *BB2\arrow\size
              draw_arrows_( *BB2, Bool( *this\bar\vertical ))
            EndIf
          EndIf
          
          
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure.b bar_scroll_draw( *this._S_widget )
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *this\bar\button
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      With *this
        
        ;         DrawImage( ImageID( UpImage ), *BB1\x, *BB1\y )
        ;         DrawImage( ImageID( DownImage ), *BB2\x, *BB2\y )
        ;         ProcedureReturn
        
        If *this\color\_alpha
          ; Draw scroll bar background
          If *this\color\back <> - 1
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            If *this\child
              If *this\bar\vertical
                draw_box_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\_parent( )\height[#__c_container], *this\color\back )
              Else
                draw_box_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner] - *this\round / 2, *this\height[#__c_inner], *this\color\back )
              EndIf
            Else
              draw_roundbox_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back )
            EndIf
          EndIf
          
          ;
          ; background buttons draw
          If Not *BB1\hide
            If *BB1\color\fore <> - 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\bar\vertical, *BB1, *BB1\color\fore[*BB1\color\state], *BB1\color\back[*BB1\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(*BB1, color\back)
            EndIf
          EndIf
          If Not *BB2\hide
            If *BB2\color\fore <> - 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_(*this\bar\vertical, *BB2, *BB2\color\fore[*BB2\color\state], *BB2\color\back[*BB2\color\state] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box(*BB2, color\back)
            EndIf
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          
          If *this\type = #__type_ScrollBar
            If *this\bar\vertical
              If (*this\bar\page\len + Bool(*this\round ) * (*this\width / 4 )) = *this\height[#__c_frame]
                Line(*this\x[#__c_frame], *this\y[#__c_frame], 1, *this\bar\page\len + 1, *this\color\front & $FFFFFF | *this\color\_alpha << 24 ) ; $FF000000 ) ;
              Else
                Line(*this\x[#__c_frame], *this\y[#__c_frame] + *BB1\round, 1, *this\height - *BB1\round - *BB2\round, *this\color\front & $FFFFFF | *this\color\_alpha << 24 ) ; $FF000000 ) ;
              EndIf
            Else
              If (*this\bar\page\len + Bool(*this\round ) * (*this\height / 4 )) = *this\width[#__c_frame]
                Line(*this\x[#__c_frame], *this\y[#__c_frame], *this\bar\page\len + 1, 1, *this\color\front & $FFFFFF | *this\color\_alpha << 24 ) ; $FF000000 ) ;
              Else
                Line(*this\x[#__c_frame] + *BB1\round, *this\y[#__c_frame], *this\width[#__c_frame] - *BB1\round - *BB2\round, 1, *this\color\front & $FFFFFF | *this\color\_alpha << 24 ) ; $FF000000 ) ;
              EndIf
            EndIf
          EndIf
          
          ; frame buttons draw
          If Not *BB1\hide
            If *BB1\arrow\size
              draw_arrows_( *BB1, Bool(*this\bar\vertical ))
            EndIf
            draw_box(*BB1, color\frame)
          EndIf
          If Not *BB2\hide
            If *BB2\arrow\size
              draw_arrows_( *BB2, Bool(*this\bar\vertical ) + 2 )
            EndIf
            draw_box(*BB2, color\frame)
          EndIf
          
          
          If *this\bar\thumb\len And *this\type <> #__type_ProgressBar
            ; Draw thumb
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            draw_gradient_(*this\bar\vertical, *SB, *SB\color\fore[*SB\color\state], *SB\color\back[*SB\color\state])
            
            If *SB\arrow\type ;*this\type = #__type_ScrollBar
              If *SB\arrow\size
                drawing_mode_alpha_( #PB_2DDrawing_Default )
                ;                 Arrow(*SB\x + (*SB\width -*SB\arrow\size )/2, *SB\y + (*SB\height -*SB\arrow\size )/2,
                ;                       *SB\arrow\size, *SB\arrow\direction, *SB\color\front[*SB\color\state]&$FFFFFF |*SB\color\_alpha<<24, *SB\arrow\type )
                
                draw_arrows_( *SB, *SB\arrow\direction )
              EndIf
            Else
              ; Draw thumb lines
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              If *this\bar\vertical
                Line(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 - 3, *SB\arrow\size, 1, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
                Line(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2, *SB\arrow\size, 1, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
                Line(*SB\x + (*SB\width - *SB\arrow\size ) / 2, *SB\y + *SB\height / 2 + 3, *SB\arrow\size, 1, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
              Else
                Line(*SB\x + *SB\width / 2 - 3, *SB\y + (*SB\height - *SB\arrow\size ) / 2, 1, *SB\arrow\size, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
                Line(*SB\x + *SB\width / 2, *SB\y + (*SB\height - *SB\arrow\size ) / 2, 1, *SB\arrow\size, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
                Line(*SB\x + *SB\width / 2 + 3, *SB\y + (*SB\height - *SB\arrow\size ) / 2, 1, *SB\arrow\size, *SB\color\front[*SB\color\state] & $FFFFFF | *this\color\_alpha << 24 )
              EndIf
            EndIf
            
            ; Draw thumb frame
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_box(*SB, color\frame)
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b bar_progress_draw( *this._S_widget )
      With *this
        Protected i, a, _position_, _frame_size_ = 1, _gradient_ = 1
        Protected _vertical_ = *this\bar\vertical
        Protected _reverse_ = *this\bar\invert
        Protected _round_ = *this\round
        Protected alpha = 230
        Protected _frame_color_ = $FF000000 ; *this\color\frame
        Protected _fore_color1_
        Protected _back_color1_
        Protected _fore_color2_
        Protected _back_color2_
        
        Protected state1 = Bool(Not *this\bar\invert) * #__s_2
        Protected state2 = Bool(*this\bar\invert) * #__s_2
        
        alpha         = 230
        _fore_color1_ = *this\color\fore[state1] & $FFFFFF | alpha << 24 ; $f0E9BA81 ;
        _back_color1_ = *this\color\back[state1] & $FFFFFF | alpha << 24 ; $f0E89C3D ;
        
        alpha - 15
        _fore_color2_ = *this\color\fore[state2] & $FFFFFF | alpha << 24 ; $e0F8F8F8 ;
        _back_color2_ = *this\color\back[state2] & $FFFFFF | alpha << 24 ; $e0E2E2E2 ;
        
        If _vertical_
          
          ;           If _reverse_
          ;             _position_ = *this\bar\thumb\pos
          ;           Else
          _position_ = *this\height[#__c_frame] - *this\bar\thumb\pos
          ;           EndIf
        Else
          ;           If _reverse_
          ;             _position_ = *this\width[#__c_frame] - *this\bar\thumb\pos
          ;           Else
          _position_ = *this\bar\thumb\pos
          ;           EndIf
          
        EndIf
        
        If _position_ < 0
          _position_ = 0
        EndIf
        
        ; Debug "_position_ "+_position_ +" "+ *this\bar\page\pos
        
        ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
        ; FrontColor(_frame_color_) ; не работает
        drawing_mode_alpha_(#PB_2DDrawing_Outlined)
        draw_roundbox_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_ * 2, *this\height[#__c_frame] - _frame_size_ * 2, _round_, _round_, _frame_color_)
        ;   draw_roundbox_(*this\x[#__c_frame] + _frame_size_+1, *this\y[#__c_frame] + _frame_size_+1, *this\width[#__c_frame] - _frame_size_*2-2, *this\height[#__c_frame] - _frame_size_*2-2, _round_,_round_)
        ;   ; ;   draw_roundbox_(*this\x[#__c_frame] + _frame_size_+2, *this\y[#__c_frame] + _frame_size_+2, *this\width[#__c_frame] - _frame_size_*2-4, *this\height[#__c_frame] - _frame_size_*2-4, _round_,_round_)
        ;   ;
        ;   ;   For i = 0 To 1
        ;   ;     draw_roundbox_(*this\x[#__c_frame] + (_frame_size_+i), *this\y[#__c_frame] + (_frame_size_+i), *this\width[#__c_frame] - (_frame_size_+i)*2, *this\height[#__c_frame] - (_frame_size_+i)*2, _round_,_round_)
        ;   ;   Next
        
        If _gradient_
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          If _vertical_
            LinearGradient(*this\x[#__c_frame], *this\y[#__c_frame], (*this\x[#__c_frame] + *this\width[#__c_frame]), *this\y[#__c_frame])
          Else
            LinearGradient(*this\x[#__c_frame], *this\y[#__c_frame], *this\x[#__c_frame], (*this\y[#__c_frame] + *this\height[#__c_frame]))
          EndIf
        Else
          drawing_mode_alpha_( #PB_2DDrawing_Default )
        EndIf
        
        
        BackColor(_fore_color1_)
        FrontColor(_back_color1_)
        
        If Not _round_
          If _vertical_
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_ * 2, (*this\height[#__c_frame] - _frame_size_ - (_position_)))
          Else
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, (_position_) - _frame_size_, *this\height[#__c_frame] - _frame_size_ * 2)
          EndIf
        Else
          
          If _vertical_
            If (*this\height[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\height[#__c_frame] > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\width[#__c_frame] - _frame_size_ * 2, (*this\height[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)))
                Else
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + (_position_), *this\width[#__c_frame] - _frame_size_ * 2, (*this\height[#__c_frame] - _round_ - (_position_)))
                EndIf
              EndIf
              
              For a = (*this\height[#__c_frame] - _round_) To (*this\height[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (_position_)
                For a = _frame_size_ + (_position_) To _round_
                  For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                    If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = (_position_) - _frame_size_ To (*this\height[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          Else
            If (_position_) > _round_
              ; рисуем прямоуголную часть
              If *this\width[#__c_frame] > _round_ * 2
                If (*this\width[#__c_frame] - (_position_)) > _round_
                  draw_box_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) , *this\height[#__c_frame] - _frame_size_ * 2)
                Else
                  draw_box_(*this\x[#__c_frame] + _round_, *this\y[#__c_frame] + _frame_size_, ((_position_) - _round_) + (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_ * 2)
                EndIf
              EndIf
              
              For a = _frame_size_ To _round_
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\width[#__c_frame] - (_position_))
                For a = (*this\width[#__c_frame] - _frame_size_ - _round_) To (_position_) - _frame_size_
                  For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                    If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = _frame_size_ To (_position_) + _frame_size_ - 1
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
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
            draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _frame_size_, *this\width[#__c_frame] - _frame_size_ * 2, (_position_) - _frame_size_)
          Else
            draw_box_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _frame_size_ - (_position_)), *this\height[#__c_frame] - _frame_size_ * 2)
          EndIf
        Else
          If _vertical_
            If (_position_) > _round_
              If *this\height[#__c_frame] > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > (*this\height[#__c_frame] - (_position_))
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_ * 2, ((_position_) - _round_) + (*this\height[#__c_frame] - _round_ - (_position_)))
                Else
                  draw_box_(*this\x[#__c_frame] + _frame_size_, *this\y[#__c_frame] + _round_, *this\width[#__c_frame] - _frame_size_ * 2, ((_position_) - _round_))
                EndIf
              EndIf
              
              For a = _frame_size_ To _round_
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (*this\height[#__c_frame] - (_position_))
                For a = (*this\height[#__c_frame] - _frame_size_ - _round_) To (_position_) - _frame_size_
                  For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_ * 2)
                    If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = _frame_size_ To (_position_) + _frame_size_ - 1
                For i = _frame_size_ To (*this\width[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + i, *this\y[#__c_frame] + a, *this\width[#__c_frame] - i * 2, 1)
                    Break
                  EndIf
                Next i
              Next a
            EndIf
          Else
            If (*this\width[#__c_frame] - _round_ - (_position_)) > _round_
              If *this\width[#__c_frame] > _round_ * 2
                ; рисуем прямоуголную часть
                If _round_ > (_position_)
                  draw_box_(*this\x[#__c_frame] + (_position_) + (_round_ - (_position_)), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)) - (_round_ - (_position_)), *this\height[#__c_frame] - _frame_size_ * 2)
                Else
                  draw_box_(*this\x[#__c_frame] + (_position_), *this\y[#__c_frame] + _frame_size_, (*this\width[#__c_frame] - _round_ - (_position_)), *this\height[#__c_frame] - _frame_size_ * 2)
                EndIf
              EndIf
              
              For a = (*this\width[#__c_frame] - _round_) To (*this\width[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
                    Break
                  EndIf
                Next i
              Next a
              
              ; если позиция ползунка больше начало второго округленыя
              If _round_ > (_position_)
                For a = _frame_size_ + (_position_) To _round_
                  For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                    If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                      Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
                      Break
                    EndIf
                  Next i
                Next a
              EndIf
              
            Else
              For a = (_position_) - _frame_size_ To (*this\width[#__c_frame] - _frame_size_)
                For i = _frame_size_ To (*this\height[#__c_frame] - _frame_size_ * 2)
                  If Point(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i) & $FFFFFF = _frame_color_ & $FFFFFF
                    Line(*this\x[#__c_frame] + a, *this\y[#__c_frame] + i, 1, *this\height[#__c_frame] - i * 2)
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
          DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, $ff000000)
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i bar_spin_draw( *this._S_widget )
      Protected._s_BUTTONS *BB1, *BB2
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      drawing_mode_alpha_( #PB_2DDrawing_Gradient )
      draw_gradient_(*this\bar\vertical, *BB1, *BB1\color\fore[*BB1\color\state], *BB1\color\back[*BB1\color\state] )
      draw_gradient_(*this\bar\vertical, *BB2, *BB2\color\fore[*BB2\color\state], *BB2\color\back[*BB2\color\state] )
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      
      ; spin-buttons center line
      If EnteredButton( ) <> *BB1 And *BB1\color\state <> #__S_3
        draw_box_( *BB1\x, *BB1\y, *BB1\width, *BB1\height, *BB1\color\frame[*BB1\color\state] )
      EndIf
      If EnteredButton( ) <> *BB2 And *BB2\color\state <> #__S_3
        draw_box_( *BB2\x, *BB2\y, *BB2\width, *BB2\height, *BB2\color\frame[*BB2\color\state] )
      EndIf
      
      If FocusedWidget( ) = *this
        If *this\fs[1] ;And Not bar_in_start_( *this\bar )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\fs[1] + 1, *this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[2] ;And Not bar_in_stop_( *this\bar )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs[2] + 1, *this\color\frame[2] )
        EndIf
        If *this\fs[3] ;And Not bar_in_stop_( *this\bar )
          draw_box_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs[3] - 1, *this\y[#__c_frame], *this\fs[3] + 1, *this\height[#__c_frame], *this\color\frame[2] )
        EndIf
        If *this\fs[4] ;And Not bar_in_start_( *this\bar )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs[4] - 1, *this\width[#__c_frame], *this\fs[4] + 1, *this\color\frame[2] )
        EndIf
      EndIf
      
      If *BB1\color\state = #__S_3
        draw_box_( *BB1\x, *BB1\y, *BB1\width, *BB1\height, *BB1\color\frame[*BB1\color\state] )
      EndIf
      
      If *BB2\color\state = #__S_3
        draw_box_( *BB2\x, *BB2\y, *BB2\width, *BB2\height, *BB2\color\frame[*BB2\color\state] )
      EndIf
      
      If EnteredButton( )
        draw_box_( EnteredButton( )\x, EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, EnteredButton( )\color\frame[EnteredButton( )\color\state] )
      EndIf
      
      ;
      If *this\flag & #__spin_Plus
        ; -/+
        draw_plus_( *BB1, Bool( *this\bar\invert ) )
        draw_plus_( *BB2, Bool( Not *this\bar\invert ) )
      Else
        ; arrows on the buttons
        If *BB1\arrow\size
          draw_arrows_( *BB1, Bool(*this\bar\vertical ))
        EndIf
        If *BB2\arrow\size
          draw_arrows_( *BB2, Bool(*this\bar\vertical ) + 2 )
        EndIf
      EndIf
      
      
      drawing_mode_( #PB_2DDrawing_Default )
      ; draw split-string back
      ;Box( *SB\x, *SB\y, *SB\width, *SB\height, *this\color\back[*this\color\state] )
      draw_box_( *this\x[#__c_frame] + *this\fs[1], *this\y[#__c_frame] + *this\fs[2], *this\width[#__c_frame] - *this\fs[1] - *this\fs[3], *this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\back[*this\color\state] )
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      ; draw split-string frame
      draw_box_( *this\x[#__c_frame] + *this\fs[1], *this\y[#__c_frame] + *this\fs[2], *this\width[#__c_frame] - *this\fs[1] - *this\fs[3], *this\height[#__c_frame] - *this\fs[2] - *this\fs[4], *this\color\frame[Bool(FocusedWidget( ) = *this) * 2] )
      
      ; Draw string
      If *this\text And *this\text\string
        drawing_mode_alpha_( #PB_2DDrawing_Transparent )
        DrawRotatedText( *this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0] ) ; *this\color\state] )
      EndIf
    EndProcedure
    
    Procedure.b bar_track_draw( *this._S_widget )
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *this\bar\button
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      bar_scroll_draw( *this )
      ;bar_progress_draw( *this )
      
      With *this
        If *this\type = #__type_TrackBar
          Protected i, x, y
          drawing_mode_( #PB_2DDrawing_XOr )
          
          If *this\bar\vertical
            x = *SB\x + Bool( *this\bar\invert ) * ( *SB\width - 3 + 4 ) - 2
            y = *this\y + *this\bar\area\pos + *SB\size / 2
            
            If *this\flag & #PB_TrackBar_Ticks
              For i = 0 To *this\bar\page\end
                Line( x, y + bar_thumb_pos_( *this\bar, i ), 6 - Bool(i > *this\bar\min And i <> 0 And i < *this\bar\max) * 3, 1, *SB\color\frame )
              Next
            EndIf
            
            Line( x - 3, y, 3, 1, *SB\color\frame )
            Line( x - 3, y + *this\bar\area\len - *this\bar\thumb\len, 3, 1, *SB\color\frame )
            
          Else
            x = *this\x + *this\bar\area\pos + *SB\size / 2
            y = *SB\y + Bool( Not *this\bar\invert ) * ( *SB\height - 3 + 4 ) - 2
            
            If *this\flag & #PB_TrackBar_Ticks
              For i = *this\bar\min To *this\bar\max
                Line( x + bar_thumb_pos_( *this\bar, i ), y, 1, 6 - Bool(i > *this\bar\min And i <> 0 And i < *this\bar\max) * 3, *SB\color\frame )
              Next
            EndIf
            
            Line( x, y - 3, 1, 3, *SB\color\frame )
            Line( x + *this\bar\area\len - *this\bar\thumb\len, y - 3, 1, 3, *SB\color\frame )
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.b bar_splitter_draw( *this._S_widget )
      Protected circle_x, circle_y
      Protected._s_BUTTONS *SB1, *SB2, *SB
      *SB  = *this\bar\button
      *SB1 = *this\bar\button[1]
      *SB2 = *this\bar\button[2]
      
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw the splitter background
      draw_box_( *SB\x, *SB\y, *SB\width, *SB\height, *this\color\back[*SB\color\state] & $ffffff | 210 << 24 )
      
      ; draw the first\second background
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      
      ; draw the frame
      If Not *SB1\hide : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If Not *SB2\hide : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      ;
      If *this\bar\thumb\len
        If *this\bar\vertical
          circle_y = ( *SB\y + *SB\height / 2 )
          circle_x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *SB\round ) / 2 + Bool( *this\width % 2 )
        Else
          circle_x = ( *SB\x + *SB\width / 2 ) ; - *this\x
          circle_y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *SB\round ) / 2 + Bool( *this\height % 2 )
        EndIf
        
        If *this\bar\vertical ; horisontal line
          If *SB\width > 35
            Circle( circle_x - ( *SB\round * 2 + 2 ) * 2 - 2, circle_y, *SB\round, *SB\color\frame[#__S_2] )
            Circle( circle_x + ( *SB\round * 2 + 2 ) * 2 + 2, circle_y, *SB\round, *SB\color\frame[#__S_2] )
          EndIf
          If *SB\width > 20
            Circle( circle_x - ( *SB\round * 2 + 2 ), circle_y, *SB\round, *SB\color\frame[#__S_2] )
            Circle( circle_x + ( *SB\round * 2 + 2 ), circle_y, *SB\round, *SB\color\frame[#__S_2] )
          EndIf
        Else
          If *SB\height > 35
            Circle( circle_x, circle_y - ( *SB\round * 2 + 2 ) * 2 - 2, *SB\round, *SB\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB\round * 2 + 2 ) * 2 + 2, *SB\round, *SB\color\frame[#__S_2] )
          EndIf
          If *SB\height > 20
            Circle( circle_x, circle_y - ( *SB\round * 2 + 2 ), *SB\round, *SB\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB\round * 2 + 2 ), *SB\round, *SB\color\frame[#__S_2] )
          EndIf
        EndIf
        
        Circle( circle_x, circle_y, *SB\round, *SB\color\frame[#__S_2] )
      EndIf
    EndProcedure
    
    Procedure.b bar_draw( *this._S_widget )
      With *this
        If *this\text\string And ( *this\type = #__type_Spin Or
                                   *this\type = #__type_ProgressBar )
          
          draw_font_( *this )
          
          If *this\TextChange( ) Or *this\resize & #__resize_change
            
            Protected _x_ = *this\x[#__c_inner]
            Protected _y_ = *this\y[#__c_inner]
            Protected _width_ = *this\width[#__c_inner]
            Protected _height_ = *this\height[#__c_inner]
            
            If *this\type = #PB_GadgetType_ProgressBar
              *this\text\rotate = ( Bool( *this\bar\vertical And Not *this\bar\invert ) * 90 ) +
                                  ( Bool( *this\bar\vertical And *this\bar\invert ) * 270 )
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
          Case #__type_Spin : bar_spin_draw( *this )
          Case #__type_TabBar : bar_tab_draw( *this )
          Case #__type_ToolBar : bar_tab_draw( *this )
          Case #__type_TrackBar : bar_track_draw( *this )
          Case #__type_ScrollBar : bar_scroll_draw( *this )
          Case #__type_ProgressBar : bar_progress_draw( *this )
          Case #__type_Splitter : bar_splitter_draw( *this )
        EndSelect
        
        ;drawing_mode_( #PB_2DDrawing_Outlined ) :draw_box_( *this\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00 )
        
        If *this\TextChange( ) <> 0
          *this\TextChange( ) = 0
        EndIf
        
      EndWith
    EndProcedure
    
    ;-
    Macro bar_area_create_( _parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True )
      If Not _parent_\scroll\bars
        _parent_\scroll\bars = 1
        ;         If _parent_\text\invert
        ;           _parent_\scroll\v = Create( _parent_, _parent_\class + "-" + _parent_\index + "-vertical", #__type_ScrollBar, 0, 0, #__scroll_buttonsize, 0, #Null$, #__flag_child | #__bar_vertical | #__bar_invert, 0, _area_height_, _height_, #__scroll_buttonsize, 7, _scroll_step_ )
        ;         Else
        _parent_\scroll\v = Create( _parent_, _parent_\class + "-" + _parent_\index + "-vertical", #__type_ScrollBar, 0, 0, #__scroll_buttonsize, 0, #Null$, #__flag_child | #__bar_vertical, 0, _area_height_, _height_, #__scroll_buttonsize, 7, _scroll_step_ )
        ;         EndIf
        _parent_\scroll\h = Create( _parent_, _parent_\class + "-" + _parent_\index + "-horizontal", #__type_ScrollBar, 0, 0, 0, #__scroll_buttonsize, #Null$, #__flag_child, 0, _area_width_, _width_, Bool( _mode_ ) * #__scroll_buttonsize, 7, _scroll_step_ )
      EndIf
    EndMacro
    
    Macro bar_area_draw_( _this_ )
      If _this_\scroll
        ;Clip( _this_, [#__c_draw] )
        
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And
           ( _this_\scroll\v\width[#__c_draw] > 0 And _this_\scroll\v\height[#__c_draw] > 0 )
          bar_scroll_draw( _this_\scroll\v )
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And
           ( _this_\scroll\h\width[#__c_draw] > 0 And _this_\scroll\h\height[#__c_draw] > 0 )
          bar_scroll_draw( _this_\scroll\h )
        EndIf
        
        ;If #__draw_scroll_box
        drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        ; Scroll area coordinate
        draw_box_( _this_\x[#__c_inner] + _this_\scroll_x( ) + _this_\text\padding\x, _this_\y[#__c_inner] + _this_\scroll_y( ) + _this_\text\padding\y, _this_\scroll_width( ) - _this_\text\padding\x * 2, _this_\scroll_height( ) - _this_\text\padding\y * 2, $FFFF0000 )
        draw_box_( _this_\x[#__c_inner] + _this_\scroll_x( ), _this_\y[#__c_inner] + _this_\scroll_y( ), _this_\scroll_width( ), _this_\scroll_height( ), $FF0000FF )
        
        If _this_\scroll\v And _this_\scroll\h
          draw_box_( _this_\scroll\h\x[#__c_frame] + _this_\scroll_x( ), _this_\scroll\v\y[#__c_frame] + _this_\scroll_y( ), _this_\scroll_width( ), _this_\scroll_height( ), $FF0000FF )
          
          ; Debug "" +  _this_\scroll_x( )  + " " +  _this_\scroll_y( )  + " " +  _this_\scroll_width( )  + " " +  _this_\scroll_height( )
          ;draw_box_( _this_\scroll\h\x[#__c_frame] - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y[#__c_frame] - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF )
          
          ; page coordinate
          draw_box_( _this_\scroll\h\x[#__c_frame], _this_\scroll\v\y[#__c_frame], _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00 )
        EndIf
        ;EndIf
      EndIf
    EndMacro
    
    Procedure.b bar_area_update( *this._S_widget )
      Protected result.b
      
      ;\\ change vertical scrollbar max
      If *this\scroll\v And *this\scroll\v\bar\max <> *this\scroll_height( ) And
         bar_SetAttribute( *this\scroll\v, #PB_ScrollBar_Maximum, *this\scroll_height( ) )
        result = #True
      EndIf
      
      ;\\ change horizontal scrollbar max
      If *this\scroll\h And *this\scroll\h\bar\max <> *this\scroll_width( ) And
         bar_SetAttribute( *this\scroll\h, #PB_ScrollBar_Maximum, *this\scroll_width( ) )
        result = #True
      EndIf
      
      If result
        bar_Resizes( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure.b bar_Update( *this._S_widget, mode.b = 1 )
      Protected fixed.l, result.b, ScrollPos.f, ThumbPos.i, bordersize, width, height
      
      Protected *bar._S_BAR = *this\bar
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *this\bar\button
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      width  = *this\width[#__c_frame]
      height = *this\height[#__c_frame]
      
      ;\\
      If *this\child
        If *this\bar\vertical
          If height = 0
            height = *this\_parent( )\height[#__c_inner]
            ;  Debug "hi - "+height
            If Not *this\height And *this\_parent( )\scroll\h
              *this\height[#__c_frame]     = height - *this\_parent( )\scroll\v\width + Bool( *this\round And *this\_parent( )\scroll\v\round ) * ( *this\_parent( )\scroll\v\width / 4 )
              *this\height[#__c_container] = height
              *this\height[#__c_screen]    = height + ( *this\bs * 2 - *this\fs * 2 )
              If *this\height[#__c_container] < 0
                *this\height[#__c_container] = 0
              EndIf
              *this\height[#__c_inner] = *this\height[#__c_container]
            EndIf
          EndIf
        Else
          If width = 0
            width = *this\_parent( )\width[#__c_inner]
            ;  Debug "wi - "+width
            If Not *this\width And *this\_parent( )\scroll\v
              *this\width[#__c_frame]     = width - *this\_parent( )\scroll\h\height + Bool( *this\round And *this\_parent( )\scroll\h\round ) * ( *this\_parent( )\scroll\h\height / 4 )
              *this\width[#__c_container] = width
              *this\width[#__c_screen]    = width + ( *this\bs * 2 - *this\fs * 2 )
              If *this\width[#__c_container] < 0
                *this\width[#__c_container] = 0
              EndIf
              *this\width[#__c_inner] = *this\width[#__c_container]
            EndIf
          EndIf
        EndIf
      EndIf
      
      ; Debug ""+height +" "+width+" "+ *this\height +" "+ *this\bar\vertical+" "+ *this\class
      
      ;\\
      If mode > 0
        ;\\ get area size
        If *this\bar\vertical
          *bar\area\len = height
        Else
          *bar\area\len = width
        EndIf
        
        If *this\type = #__type_Spin
          ; set real spin-buttons height
          If Not *this\flag & #__spin_Plus
            *BB1\size = height / 2 + Bool( height % 2 )
            *BB2\size = *BB1\size
          EndIf
          
          ;*bar\area\pos = ( *BB1\size + *bar\min[1] )
          *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size )
          
          *bar\page\end = *bar\max
          *bar\area\end = *bar\max - *bar\thumb\Len
          *bar\percent  = ( *bar\area\end - *bar\area\pos ) / ( *bar\page\end - *bar\min )
          
        Else
          If *this\type = #__type_ScrollBar
            ; default button size
            If *bar\max
              If *BB1\size = - 1 And *BB2\size = - 1
                If *this\bar\vertical And width > 7 And width < 21
                  *BB1\size = width - 1
                  *BB2\size = width - 1
                  
                ElseIf Not *this\bar\vertical And height > 7 And height < 21
                  *BB1\size = height - 1
                  *BB2\size = height - 1
                  
                Else
                  *BB1\size = *SB\size
                  *BB2\size = *SB\size
                EndIf
              EndIf
              
              ;           If *SB\size
              ;             If *this\bar\vertical
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
          
          ; Debug ""+*bar\area\len +" "+ *bar\thumb\end
          If *bar\area\len ; TODO - ?
            *bar\area\pos  = ( *BB1\size + *bar\min[1] ) + bordersize
            *bar\thumb\end = *bar\area\len - ( *BB1\size + *BB2\size ) - bordersize * 2
            
            If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
              If *bar\max
                *bar\thumb\len = *bar\thumb\end - ( *bar\max - *bar\area\len )
                *bar\page\end  = *bar\max - ( *bar\thumb\end - *bar\thumb\len )
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
                  ElseIf *SB\size > 7
                    Debug "get thumb size - ????? " + *this\class + " " + *this\width + " " + *this\height + " " + *this\_parent( )\width + " " + *this\_parent( )\height
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
                  *bar\thumb\len = *SB\size
                  If *bar\thumb\len > *bar\area\len
                    *bar\thumb\len = *bar\area\len
                  EndIf
                  ;*bar\thumb\len = Round(( *bar\thumb\end / ( *bar\max - *bar\min )), #PB_Round_Nearest )
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
                    EndIf
                    
                    ; if splitter fixed
                    ; set splitter pos to center
                    If *bar\fixed
                      If *bar\fixed = #PB_Splitter_FirstMinimumSize
                        *bar\fixed[*bar\fixed] = *bar\page\pos
                      Else
                        *bar\fixed[*bar\fixed] = *bar\page\end - *bar\page\pos
                      EndIf
                    EndIf
                  Else
                    If *bar\PageChange( ) Or *bar\fixed = 1
                      *bar\page\end = *bar\area\len - *bar\thumb\len
                    EndIf
                  EndIf
                EndIf
                
              EndIf
            EndIf
            
            ; Debug ""+*bar\vertical +" "+ *bar\thumb\len +" "+ *SB\size
            
            If *bar\page\end
              ; *bar\percent = ( *bar\thumb\end - *bar\thumb\len-*this\scroll\increment ) / ( *bar\page\end - *bar\min-*this\scroll\increment )
              *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\page\end - *bar\min )
            Else
              *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\min )
            EndIf
            
            *bar\area\end = *bar\area\len - *bar\thumb\len - ( *BB2\size + *bar\min[2] + bordersize ) ; [2]
                                                                                                      ;  *bar\area\end = *bar\area\len - *bar\thumb\len - ( *BB2\size + bordersize ) ; так не уменшается 1 фиксированый
          EndIf
        EndIf
      EndIf
      
      ;\\
      If mode < 2
        ;\\ get thumb pos
        If *bar\fixed And Not *bar\PageChange( )
          If *bar\fixed = #PB_Splitter_FirstMinimumSize
            ThumbPos = *bar\fixed[*bar\fixed]
            
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
            ;ThumbPos = ( *bar\area\end + *bar\min[2] ) - *bar\fixed[*bar\fixed] ;[2]
            ThumbPos = *bar\area\end - *bar\fixed[*bar\fixed]                    ;[1]
            
            If ThumbPos < *bar\min[1]
              If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                ThumbPos = ( *bar\area\end + *bar\min[2] )
              Else
                ThumbPos = *bar\min[1]
              EndIf
            EndIf
          EndIf
          
          If *bar\thumb\pos <> ThumbPos
            *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
            *bar\thumb\pos      = ThumbPos
          EndIf
          
        Else
          If *this\type = #__type_TabBar Or
             *this\type = #__type_ToolBar
            
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
                  Debug "error page\end - " + *bar\page\end
                EndIf
              EndIf
            EndIf
            
            ; for the scrollarea childrens
            If *bar\page\end And *bar\page\pos > *bar\page\end
              ; Debug " bar end change - " + *bar\page\pos +" "+ *bar\page\end
              *bar\PageChange( ) = *bar\page\pos - *bar\page\end
              *bar\page\pos      = *bar\page\end
            EndIf
          EndIf
          
          If Not *bar\ThumbChange( )
            ThumbPos = bar_thumb_pos_( *bar, *bar\page\pos )
            ThumbPos = bar_invert_thumb_pos_( *bar, ThumbPos )
            
            If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
            If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
            
            If *bar\thumb\pos <> ThumbPos
              *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
              *bar\thumb\pos      = ThumbPos
            EndIf
          EndIf
        EndIf
        
        ;\\ get fixed size
        If *bar\fixed And *bar\PageChange( )
          If *bar\fixed = #PB_Splitter_FirstMinimumSize
            *bar\fixed[*bar\fixed] = *bar\thumb\pos
          Else
            ; Debug "splitter - "+Str( *bar\area\len - *bar\thumb\len ) +" "+ Str( *bar\area\end + *bar\min[2] ) +" "+ *bar\area\end
            ; *bar\fixed[*bar\fixed] = ( *bar\area\len - *bar\thumb\len ) - *bar\thumb\pos ;[2]
            ; *bar\fixed[*bar\fixed] = ( *bar\area\end + *bar\min[2] ) - *bar\thumb\pos    ;[2]
            *bar\fixed[*bar\fixed] = *bar\area\end - *bar\thumb\pos                        ;[1]
          EndIf
        EndIf
        
        ;
        ;\\ disable/enable
        ;
        ;\\ buttons(left&top)-tab(right&bottom)
        If bar_in_start_( *bar )
          If *BB1\state\disable = #False
            *BB1\state\disable = #True
            
            ;\\
            If *this\type = #__type_ScrollBar Or
               *this\type = #__type_spin Or
               *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              
              *BB1\color\state = #__S_3
            EndIf
            
            ;\\
            If *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              *BB1\hide = 1
            EndIf
            
            ;\\
            If *this\type = #__type_splitter
              If *this\bar\vertical
                *this\cursor = cursor::#PB_Cursor_Down
              Else
                *this\cursor = cursor::#PB_Cursor_Right
              EndIf
            EndIf
          EndIf
        Else
          If *BB1\state\disable = #True
            *BB1\state\disable = #False
            
            ;\\
            If *this\type = #__type_ScrollBar Or
               *this\type = #__type_spin Or
               *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              
              *BB1\color\state = #__S_0
            EndIf
            
            ;\\
            If *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              *BB1\hide = 0
            EndIf
            
            ;\\
            If *this\type = #__type_splitter
              If *this\bar\vertical
                *this\cursor = cursor::#PB_Cursor_UpDown
              Else
                *this\cursor = cursor::#PB_Cursor_LeftRight
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ buttons(right&bottom)-tab(left&top)
        If bar_in_stop_( *bar )
          If *BB2\state\disable = #False
            *BB2\state\disable = #True
            
            ;\\
            If *this\type = #__type_ScrollBar Or
               *this\type = #__type_spin Or
               *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              
              *BB2\color\state = #__S_3
            EndIf
            
            ;\\
            If *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              *BB2\hide = 1
            EndIf
            
            ;\\
            If *this\type = #__type_splitter
              If *this\bar\vertical
                *this\cursor = cursor::#PB_Cursor_Up
              Else
                *this\cursor = cursor::#PB_Cursor_Left
              EndIf
            EndIf
          EndIf
        Else
          If *BB2\state\disable = #True
            *BB2\state\disable = #False
            ;\\
            If *this\type = #__type_ScrollBar Or
               *this\type = #__type_spin Or
               *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              
              *BB2\color\state = #__S_0
            EndIf
            
            ;\\
            If *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar
              *BB2\hide = 0
            EndIf
            
            ;\\
            If *this\type = #__type_splitter
              If *this\bar\vertical
                *this\cursor = cursor::#PB_Cursor_UpDown
              Else
                *this\cursor = cursor::#PB_Cursor_LeftRight
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ button-thumb
        If *this\type = #__type_ScrollBar
          If *bar\thumb\len
            If *BB1\color\state = #__S_3 And
               *BB2\color\state = #__S_3
              
              If *SB\state\disable = #False
                *SB\state\disable = #True
                
                *SB\color\state = #__S_3
              EndIf
            Else
              If *SB\state\disable = #True
                *SB\state\disable = #False
                
                *SB\color\state = #__S_0
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        ;\\ resize buttons coordinate
        ;
        ;\\
        If *this\type = #__type_TabBar Or
           *this\type = #__type_ToolBar
          
          ; inner coordinate
          If *this\bar\vertical
            *this\x[#__c_inner]      = *this\x[#__c_frame]
            *this\width[#__c_inner]  = *this\width[#__c_frame] - 1
            *this\y[#__c_inner]      = *this\y[#__c_frame] + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
            *this\height[#__c_inner] = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\y[#__c_inner] - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
          Else
            *this\y[#__c_inner]      = *this\y[#__c_frame]
            *this\height[#__c_inner] = *this\height[#__c_frame] - 1
            *this\x[#__c_inner]      = *this\x[#__c_frame] + Bool( *BB2\hide = #False ) * ( *BB2\size + *this\fs )
            *this\width[#__c_inner]  = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\x[#__c_inner] - Bool( *BB1\hide = #False ) * ( *BB1\size + *this\fs )
          EndIf
          
          If *BB2\size And Not *BB2\hide
            If *this\bar\vertical
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
            If *this\bar\vertical
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
          If *this\bar\vertical
            *SB\x      = *this\x[#__c_inner]
            *SB\width  = *this\width[#__c_inner]
            *SB\height = *bar\max
            *SB\y      = *this\y[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
          Else
            *SB\y      = *this\y[#__c_inner]
            *SB\height = *this\height[#__c_inner]
            *SB\width  = *bar\max
            *SB\x      = *this\x[#__c_frame] + ( *bar\thumb\pos - *bar\area\end )
          EndIf
          ;EndIf
          
          
          result = Bool( *this\resize & #__resize_change )
        EndIf
        
        ;\\
        If *this\type = #__type_ScrollBar
          If *bar\thumb\len
            If *this\bar\vertical
              *SB\x      = *this\x[#__c_frame] + 1 ; white line size
              *SB\width  = *this\width[#__c_frame] - 1 ; white line size
              *SB\y      = *this\y[#__c_inner] + *bar\thumb\pos
              *SB\height = *bar\thumb\len
            Else
              *SB\y      = *this\y[#__c_frame] + 1 ; white line size
              *SB\height = *this\height[#__c_frame] - 1 ; white line size
              *SB\x      = *this\x[#__c_inner] + *bar\thumb\pos
              *SB\width  = *bar\thumb\len
            EndIf
          EndIf
          
          If *BB1\size
            If *this\bar\vertical
              ; Top button coordinate on vertical scroll bar
              *BB1\x      = *SB\x
              *BB1\width  = *SB\width
              *BB1\y      = *this\y[#__c_frame]
              *BB1\height = *BB1\size
            Else
              ; Left button coordinate on horizontal scroll bar
              *BB1\y      = *SB\y
              *BB1\height = *SB\height
              *BB1\x      = *this\x[#__c_frame]
              *BB1\width  = *BB1\size
            EndIf
          EndIf
          
          If *BB2\size
            If *this\bar\vertical
              ; Botom button coordinate on vertical scroll bar
              *BB2\x      = *SB\x
              *BB2\width  = *SB\width
              *BB2\height = *BB2\size
              *BB2\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB2\height
            Else
              ; Right button coordinate on horizontal scroll bar
              *BB2\y      = *SB\y
              *BB2\height = *SB\height
              *BB2\width  = *BB2\size
              *BB2\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB2\width
            EndIf
          EndIf
          
          ; Thumb coordinate on scroll bar
          If Not *bar\thumb\len
            ; auto resize buttons
            If *this\bar\vertical
              *BB2\height = *this\height[#__c_frame] / 2
              *BB2\y      = *this\y[#__c_frame] + *BB2\height + Bool( *this\height[#__c_frame] % 2 )
              
              *BB1\y      = *this\y
              *BB1\height = *this\height / 2 - Bool( Not *this\height[#__c_frame] % 2 )
              
            Else
              *BB2\width = *this\width[#__c_frame] / 2
              *BB2\x     = *this\x[#__c_frame] + *BB2\width + Bool( *this\width[#__c_frame] % 2 )
              
              *BB1\x     = *this\x[#__c_frame]
              *BB1\width = *this\width[#__c_frame] / 2 - Bool( Not *this\width[#__c_frame] % 2 )
            EndIf
            
            If *this\bar\vertical
              *SB\width  = 0
              *SB\height = 0
            Else
              *SB\height = 0
              *SB\width  = 0
            EndIf
          EndIf
        EndIf
        
        ;\\ Ok
        If *this\type = #__type_Spin
          *SB\x      = *this\x[#__c_inner]
          *SB\y      = *this\y[#__c_inner]
          *SB\width  = *this\width[#__c_inner]
          *SB\height = *this\height[#__c_inner]
          
          If Not *this\flag & #__spin_Plus
            If *BB1\size
              *BB1\x      = ( *this\x[#__c_frame] + *this\width[#__c_frame] ) - *SB\size
              *BB1\y      = *this\y[#__c_frame]
              *BB1\width  = *SB\size
              *BB1\height = *BB1\size
            EndIf
            If *BB2\size
              *BB2\x      = *BB1\x
              *BB2\y      = ( *this\y[#__c_frame] + *this\height[#__c_frame] ) - *BB2\size
              *BB2\height = *BB2\size
              *BB2\width  = *SB\size
            EndIf
            
          Else
            ; spin buttons numeric plus -/+
            If *this\bar\vertical
              If *BB1\size
                *BB1\x      = *this\x[#__c_frame]
                *BB1\y      = ( *this\y[#__c_frame] + *this\height[#__c_frame] ) - *BB1\size
                *BB1\width  = *this\width[#__c_frame]
                *BB1\height = *BB1\size
              EndIf
              If *BB2\size
                *BB2\x      = *this\x[#__c_frame]
                *BB2\y      = *this\y[#__c_frame]
                *BB2\width  = *this\width[#__c_frame]
                *BB2\height = *BB2\size
              EndIf
            Else
              If *BB1\size
                *BB1\x      = *this\x[#__c_frame]
                *BB1\y      = *this\y[#__c_frame]
                *BB1\width  = *BB1\size
                *BB1\height = *this\height[#__c_frame]
              EndIf
              If *BB2\size
                *BB2\x      = ( *this\x[#__c_frame] + *this\width[#__c_frame] ) - *BB2\size
                *BB2\y      = *this\y[#__c_frame]
                *BB2\width  = *BB2\size
                *BB2\height = *this\height[#__c_frame]
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ Ok
        If *this\type = #__type_Splitter
          ;
          If *this\bar\vertical
            *BB1\width  = *this\width[#__c_frame]
            *BB1\height = *bar\thumb\pos
            
            *BB1\x = *this\x[#__c_frame]
            *BB2\x = *this\x[#__c_frame]
            
            ;             If Not (( #PB_Compiler_OS = #PB_OS_MacOS ) And *this\splitter_is_gadget_1( ) And Not *this\_parent( ) )
            *BB1\y = *this\y[#__c_frame]
            *BB2\y = ( *bar\thumb\pos + *bar\thumb\len ) + *this\y[#__c_frame]
            ;             Else
            ;               *BB1\y      = *this\height[#__c_frame] - *BB1\height
            ;             EndIf
            
            *BB2\height = *this\height[#__c_frame] - ( *BB1\height + *bar\thumb\len )
            *BB2\width  = *this\width[#__c_frame]
            
            ; seperatior pos&size
            If *bar\thumb\len
              *SB\x      = *this\x[#__c_frame]
              *SB\width  = *this\width[#__c_frame]
              *SB\y      = *this\y[#__c_inner] + *bar\thumb\pos
              *SB\height = *bar\thumb\len
            EndIf
            
          Else
            *BB1\width  = *bar\thumb\pos
            *BB1\height = *this\height[#__c_frame]
            
            *BB1\y = *this\y[#__c_frame]
            *BB2\y = *this\y[#__c_frame]
            *BB1\x = *this\x[#__c_frame]
            *BB2\x = ( *bar\thumb\pos + *bar\thumb\len ) + *this\x[#__c_frame]
            
            *BB2\width  = *this\width[#__c_frame] - ( *BB1\width + *bar\thumb\len )
            *BB2\height = *this\height[#__c_frame]
            
            ; seperatior pos&size
            If *bar\thumb\len
              *SB\y      = *this\y[#__c_frame]
              *SB\height = *this\height[#__c_frame]
              *SB\x      = *this\x[#__c_inner] + *bar\thumb\pos
              *SB\width  = *bar\thumb\len
            EndIf
          EndIf
          
          ; Splitter first-child auto resize
          If *this\splitter_is_gadget_1( )
            ;             If *this\_root( )\canvas\container
            PB(ResizeGadget)( *this\splitter_gadget_1( ), *BB1\x, *BB1\y, *BB1\width, *BB1\height )
            ;             Else
            ;               PB(ResizeGadget)( *this\splitter_gadget_1( ),
            ;                                 *BB1\x + GadgetX( *this\_root( )\canvas\gadget ),
            ;                                 *BB1\y + GadgetY( *this\_root( )\canvas\gadget ),
            ;                                 *BB1\width, *BB1\height )
            ;             EndIf
            
          Else
            If *this\splitter_gadget_1( )
              If *this\splitter_gadget_1( )\x <> *BB1\x Or
                 *this\splitter_gadget_1( )\y <> *BB1\y Or
                 *this\splitter_gadget_1( )\width <> *BB1\width Or
                 *this\splitter_gadget_1( )\height <> *BB1\height
                ; Debug "splitter_1_resize " + *this\splitter_gadget_1( )
                
                If *this\splitter_gadget_1( )\type = #__type_window
                  Resize( *this\splitter_gadget_1( ),
                          *BB1\x - *this\x[#__c_frame],
                          *BB1\y - *this\y[#__c_frame],
                          *BB1\width - #__window_frame_size * 2, *BB1\height - #__window_frame_size * 2 - #__window_caption_height)
                Else
                  Resize( *this\splitter_gadget_1( ),
                          *BB1\x - *this\x[#__c_frame],
                          *BB1\y - *this\y[#__c_frame],
                          *BB1\width, *BB1\height )
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          ; Splitter second-child auto resize
          If *this\splitter_is_gadget_2( )
            ;             If *this\_root( )\canvas\container
            PB(ResizeGadget)( *this\splitter_gadget_2( ), *BB2\x, *BB2\y, *BB2\width, *BB2\height )
            ;             Else
            ;               PB(ResizeGadget)( *this\splitter_gadget_2( ),
            ;                                 *BB2\x + GadgetX( *this\_root( )\canvas\gadget ),
            ;                                 *BB2\y + GadgetY( *this\_root( )\canvas\gadget ),
            ;                                 *BB2\width, *BB2\height )
            ;             EndIf
            
          Else
            If *this\splitter_gadget_2( )
              If *this\splitter_gadget_2( )\x <> *BB2\x Or
                 *this\splitter_gadget_2( )\y <> *BB2\y Or
                 *this\splitter_gadget_2( )\width <> *BB2\width Or
                 *this\splitter_gadget_2( )\height <> *BB2\height
                ; Debug "splitter_2_resize " + *this\splitter_gadget_2( )
                
                If *this\splitter_gadget_2( )\type = #__type_window
                  Resize( *this\splitter_gadget_2( ),
                          *BB2\x - *this\x[#__c_frame],
                          *BB2\y - *this\y[#__c_frame],
                          *BB2\width - #__window_frame_size * 2, *BB2\height - #__window_frame_size * 2 - #__window_caption_height )
                Else
                  Resize( *this\splitter_gadget_2( ),
                          *BB2\x - *this\x[#__c_frame],
                          *BB2\y - *this\y[#__c_frame],
                          *BB2\width, *BB2\height )
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          result = Bool( *this\resize & #__resize_change )
        EndIf
        
        ;\\
        If *this\type = #__type_TrackBar
          If *bar\direction > 0
            If *bar\thumb\pos = *bar\area\end Or *this\flag & #PB_TrackBar_Ticks
              *SB\arrow\direction = Bool( Not *bar\vertical ) + Bool( *bar\vertical = *bar\invert ) * 2
            Else
              *SB\arrow\direction = Bool( *bar\vertical ) + Bool( Not *bar\invert ) * 2
            EndIf
          Else
            If *bar\thumb\pos = *bar\area\pos Or *this\flag & #PB_TrackBar_Ticks
              *SB\arrow\direction = Bool( Not *bar\vertical ) + Bool( *bar\vertical = *bar\invert ) * 2
            Else
              *SB\arrow\direction = Bool( *bar\vertical ) + Bool( *bar\invert ) * 2
            EndIf
          EndIf
          
          
          ; track bar draw coordinate
          If *bar\vertical
            If *bar\thumb\len
              *SB\y      = *this\y[#__c_frame] + *bar\thumb\pos
              *SB\height = *bar\thumb\len
            EndIf
            
            *BB1\width = 4
            *BB2\width = 4
            *SB\width  = *SB\size + ( Bool( *SB\size < 10 ) * *SB\size )
            
            *BB1\y      = *this\y[#__c_frame]
            *BB1\height = *bar\thumb\pos
            
            *BB2\y      = *BB1\y + *BB1\height + *bar\thumb\len
            *BB2\height = *this\height[#__c_frame] - *bar\thumb\pos - *bar\thumb\len
            
            If *bar\invert
              *BB1\x = *this\x[#__c_frame] + 6
              *BB2\x = *this\x[#__c_frame] + 6
              *SB\x  = *BB1\x - *SB\width / 4 - 1 - Bool( *SB\size > 10 )
            Else
              *BB1\x = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB1\width - 6
              *BB2\x = *this\x[#__c_frame] + *this\width[#__c_frame] - *BB2\width - 6
              *SB\x  = *BB1\x - *SB\width / 2 + Bool( *SB\size > 10 )
            EndIf
          Else
            If *bar\thumb\len
              *SB\x     = *this\x[#__c_frame] + *bar\thumb\pos
              *SB\width = *bar\thumb\len
            EndIf
            
            *BB1\height = 4
            *BB2\height = 4
            *SB\height  = *SB\size + ( Bool( *SB\size < 10 ) * *SB\size )
            
            *BB1\x     = *this\x[#__c_frame]
            *BB1\width = *bar\thumb\pos
            
            *BB2\x     = *BB1\x + *BB1\width + *bar\thumb\len
            *BB2\width = *this\width[#__c_frame] - *bar\thumb\pos - *bar\thumb\len
            
            If *bar\invert
              *BB1\y = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB1\height - 6
              *BB2\y = *this\y[#__c_frame] + *this\height[#__c_frame] - *BB2\height - 6
              *SB\y  = *BB1\y - *SB\height / 2 + Bool( *SB\size > 10 )
            Else
              *BB1\y = *this\y[#__c_frame] + 6
              *BB2\y = *this\y[#__c_frame] + 6
              *SB\y  = *BB1\y - *SB\height / 4 - 1 - Bool( *SB\size > 10 )
            EndIf
          EndIf
        EndIf
        
        
        ;\\
        If *bar\PageChange( ) <> 0
          ;\\
          If *this\type = #__type_ScrollBar
            ;- widget::bar_update_parent_area_( )
            If *this\_parent( ) And *this\_parent( )\scroll
              If *this\bar\vertical
                If *this\_parent( )\scroll\v = *this
                  *this\_parent( )\change      = - 1
                  *this\_parent( )\scroll_y( ) = - *bar\page\pos
                  
                  ;                   ; row pos update
                  ;                   If *this\_parent( )\row
                  ;                     If *this\_parent( )\text\editable
                  ;                       Text_Update( *this\_parent( ) )
                  ;                     Else
                  ;                       update_visible_items_( *this\_parent( ) )
                  ;                     EndIf
                  ;
                  ;                     *this\_parent( )\change = 0
                  ;                   EndIf
                  
                  ;\\ Area childrens x&y auto move
                  If *this\_parent( )\container
                    If StartEnumerate( *this\_parent( ) )
                      If *this\_parent( ) = enumWidget( )\_parent( ) And
                         *this\_parent( )\scroll\v <> enumWidget( ) And
                         *this\_parent( )\scroll\h <> enumWidget( ) And Not enumWidget( )\align
                        
                        If is_integral_( enumWidget( ))
                          Resize( enumWidget( ), #PB_Ignore, ( enumWidget( )\y[#__c_container] + *bar\PageChange( ) ), #PB_Ignore, #PB_Ignore )
                        Else
                          Resize( enumWidget( ), #PB_Ignore, ( enumWidget( )\y[#__c_container] + *bar\PageChange( ) ) - *this\_parent( )\scroll_y( ), #PB_Ignore, #PB_Ignore )
                        EndIf
                      EndIf
                      
                      StopEnumerate( )
                    EndIf
                  EndIf
                EndIf
              Else
                If *this\_parent( )\scroll\h = *this
                  *this\_parent( )\change      = - 2
                  *this\_parent( )\scroll_x( ) = - *bar\page\pos
                  
                  ;\\ Area childrens x&y auto move
                  If *this\_parent( )\container
                    If StartEnumerate( *this\_parent( ) )
                      If *this\_parent( ) = enumWidget( )\_parent( ) And
                         *this\_parent( )\scroll\v <> enumWidget( ) And
                         *this\_parent( )\scroll\h <> enumWidget( ) And Not enumWidget( )\align
                        
                        If is_integral_( enumWidget( ))
                          Resize( enumWidget( ), ( enumWidget( )\x[#__c_container] + *bar\PageChange( ) ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                        Else
                          Resize( enumWidget( ), ( enumWidget( )\x[#__c_container] + *bar\PageChange( ) ) - *this\_parent( )\scroll_x( ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                        EndIf
                      EndIf
                      
                      StopEnumerate( )
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;\\
          If *this\type = #__type_ProgressBar
            *this\text\string = "%" + Str( *bar\page\pos )
          EndIf
          
          ;\\
          If *this\type = #__type_Spin
            Debug " update spin-change " + *bar\PageChange( )
            Protected i
            For i = 0 To 3
              If *this\scroll\increment = ValF( StrF( *this\scroll\increment, i ) )
                *this\TextChange( ) = 1
                *this\text\string   = StrF( *bar\page\pos, i )
                If *this\StringBox( )
                  SetText( *this\StringBox( ), *this\text\string )
                EndIf
                Break
              EndIf
            Next
          EndIf
          
          ;         ;\\
          ;         If is_integral_( *this )
          ;           If *this\type = #__type_ScrollBar ; is_scrollbars_( *this )
          ;             Post( *this\_parent( ), #__event_ScrollChange, *this, *bar\PageChange( ) )
          ;           EndIf
          ;         Else
          ;           Post( *this, #__event_Change, EnteredButton( ), *bar\PageChange( ) )
          ;         EndIf
          
          *bar\PageChange( ) = 0
        EndIf
        
        ;
        If *bar\ThumbChange( ) <> 0
          If *this\_root( ) And *this\_root( )\canvas\gadget = PB(EventGadget)( )
            result = *bar\ThumbChange( )
          EndIf
          
          *bar\ThumbChange( ) = 0
        EndIf
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b bar_Change( *this._S_widget, ScrollPos.l )
      Protected *bar._S_BAR = *this\bar
      ;Protected *this._S_widget = *bar\widget
      ;Debug ""+ScrollPos +" "+ *bar\page\end
      
      If Not *bar\button\state\disable ; *bar\thumb\len <> *bar\thumb\end   ; TODO - good in editor scrollbars and other test
                                       ; If ScrollPos < *bar\min : ScrollPos = *bar\min : EndIf
        If ScrollPos < *bar\min
          If *bar\max > *bar\page\len
            ScrollPos = *bar\min
          Else
            ;ScrollPos = *bar\page\end + ScrollPos
            Debug "" + #PB_Compiler_Procedure + " - " + " child - " + *this\child + " " + *this\class + " " + *bar\page\end + " " + ScrollPos
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
            *bar\direction = - ScrollPos
          Else
            *bar\direction = ScrollPos
          EndIf
          
          *bar\PageChange( ) = *bar\page\pos - ScrollPos
          *bar\page\pos      = ScrollPos
          
          ; example-scroll(area) fixed
          If is_integral_( *this )
            If *this\type = #__type_ScrollBar ; is_scrollbars_( *bar\widget )
              DoEvents( *this\_parent( ), #__event_ScrollChange, *bar\PageChange( ), *this )
            EndIf
          Else
            Post( *this, #__event_Change, *bar\PageChange( ), EnteredButton( ) )
          EndIf
          
          ProcedureReturn #True
        EndIf
      EndIf
    EndProcedure
    
    Procedure.b bar_SetState( *this._S_widget, state.l )
      If bar_Change( *this, state )
        ProcedureReturn bar_Update( *this )
      EndIf
    EndProcedure
    
    Procedure.b bar_SetThumbPos( *this._S_widget, ThumbPos.i )
      ;Protected *this._S_widget = *bar\widget
      Protected *bar._S_BAR = *this\bar
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
        
        If *bar\ThumbChange( ) <> *bar\thumb\pos - ThumbPos
          *bar\ThumbChange( ) = *bar\thumb\pos - ThumbPos
          *bar\thumb\pos      = ThumbPos
          If bar_Change( *this, ScrollPos )
          EndIf
          ProcedureReturn bar_Update( *this, 0 )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.l bar_SetAttribute( *this._S_widget, Attribute.l, *value )
      Protected result.l
      Protected value = *value
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *this\bar\button
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      With *this
        ;\\
        If Attribute = #__bar_invert
          If *this\bar\invert <> Bool( value )
            *this\bar\invert = Bool( value )
            result           = 1
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
              *this\bar\min[1] = *value
              ;*BB1\size = *value
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *this\bar\min[2] = *value
              ;*BB2\size = *value
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_FirstGadget
              *this\splitter_gadget_1( )    = *value
              *this\splitter_is_gadget_1( ) = Bool( PB(IsGadget)( *value ))
              result                        = - 1
              
            Case #PB_Splitter_SecondGadget
              *this\splitter_gadget_2( )    = *value
              *this\splitter_is_gadget_2( ) = Bool( PB(IsGadget)( *value ))
              result                        = - 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If *this\bar\min <> *value ;And Not *value < 0
                *this\bar\AreaChange( ) = *this\bar\min - value
                If *this\bar\page\pos < *value
                  *this\bar\page\pos = *value
                EndIf
                *this\bar\min = *value
                ; Debug  " min " + *this\bar\min + " max " + *this\bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If *this\bar\max <> *value And Not ( *value < 0 And Not #__bar_minus)
                *this\bar\AreaChange( ) = *this\bar\max - value
                
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
                
                ;\bar\PageChange( ) = #True
                result = #True
              EndIf
              
            Case #__bar_pagelength
              If *this\bar\page\len <> *value And Not ( *value < 0 And Not #__bar_minus )
                *this\bar\AreaChange( ) = *this\bar\page\len - value
                *this\bar\page\len      = *value
                
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
              If *SB\size <> *value
                *SB\size = *value
                
                If *this\type = #__type_spin
                  If *this\flag & #__spin_plus
                    ; set real spin-buttons width
                    *BB1\size = *value
                    *BB2\size = *value
                    
                    If *this\bar\vertical
                      *this\fs[2] = *BB2\size - 1
                      *this\fs[4] = *BB1\size - 1
                    Else
                      *this\fs[1] = *BB1\size - 1
                      *this\fs[3] = *BB2\size - 1
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
                      *BB1\size = - 1
                      *BB2\size = - 1
                    Else
                      *BB1\size = 0
                      *BB2\size = 0
                    EndIf
                  EndIf
                  
                  ; if it is a composite element of the parent
                  If *this\child > 0 And *this\_parent( ) And *value
                    *value + 1
                    If *this\bar\vertical
                      Resize(*this, *this\_parent( )\width[#__c_container] - *value, #PB_Ignore, *value, #PB_Ignore)
                    Else
                      Resize(*this, #PB_Ignore, *this\_parent( )\width[#__c_container] - *value, #PB_Ignore, *value)
                    EndIf
                  EndIf
                  
                  bar_Update( *this )
                  PostCanvasRepaint( *this )
                  ProcedureReturn #True
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If result ; And *this\width And *this\height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\PageChange( ) = #True
                  ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          
          ;If *this\_root( ) ;And *this\_root( )\canvas\postevent = #False
          If ( *this\bar\vertical And *this\height ) Or ( *this\bar\vertical = 0 And *this\width )
            ; Debug "bar_SetAttribute - "+*this\height +" "+ *this\width +" "+ *this\bar\vertical
            bar_Update( *this ) ; ??????????????
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
    
    Procedure bar_mdi_update( *this._S_widget, x.l, y.l, width.l, height.l )
      *this\scroll_x( )      = x
      *this\scroll_y( )      = y
      *this\scroll_width( )  = width
      *this\scroll_height( ) = height
      
      If StartEnumerate( *this )
        If enumWidget( )\_parent( ) = *this
          If *this\scroll_x( ) > enumWidget( )\x[#__c_container]
            *this\scroll_x( ) = enumWidget( )\x[#__c_container]
          EndIf
          If *this\scroll_y( ) > enumWidget( )\y[#__c_container]
            *this\scroll_y( ) = enumWidget( )\y[#__c_container]
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      If StartEnumerate( *this )
        If enumWidget( )\_parent( ) = *this
          If *this\scroll_width( ) < enumWidget( )\x[#__c_container] + enumWidget( )\width[#__c_frame] - *this\scroll_x( )
            *this\scroll_width( ) = enumWidget( )\x[#__c_container] + enumWidget( )\width[#__c_frame] - *this\scroll_x( )
          EndIf
          If *this\scroll_height( ) < enumWidget( )\y[#__c_container] + enumWidget( )\height[#__c_frame] - *this\scroll_y( )
            *this\scroll_height( ) = enumWidget( )\y[#__c_container] + enumWidget( )\height[#__c_frame] - *this\scroll_y( )
          EndIf
        EndIf
        StopEnumerate( )
      EndIf
      
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
      x      = 0
      y      = 0
      width  = *this\width[#__c_container]
      height = *this\height[#__c_container]
      
      If *this\scroll\v\bar\page\len <> height - Bool( *this\scroll_width( ) > width ) * *this\scroll\h\height
        *this\scroll\v\bar\page\len = height - Bool( *this\scroll_width( ) > width ) * *this\scroll\h\height
      EndIf
      
      If *this\scroll\h\bar\page\len <> width - Bool( *this\scroll_height( ) > height ) * *this\scroll\v\width
        *this\scroll\h\bar\page\len = width - Bool( *this\scroll_height( ) > height ) * *this\scroll\v\width
      EndIf
      
      If *this\scroll_x( ) < x
        ; left set state
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        sx = ( *this\scroll_x( ) - x )
        *this\scroll_width( ) + sx
        *this\scroll_x( ) = x
      EndIf
      
      If *this\scroll_y( ) < y
        ; top set state
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        sy = ( *this\scroll_y( ) - y )
        *this\scroll_height( ) + sy
        *this\scroll_y( ) = y
      EndIf
      
      If *this\scroll_width( ) > *this\scroll\h\bar\page\len - ( *this\scroll_x( ) - x )
        If *this\scroll_width( ) - sx <= width And *this\scroll_height( ) = *this\scroll\v\bar\page\len - ( *this\scroll_y( ) - y )
          ;Debug "w - " + Str( *this\scroll_height( ) - sx )
          
          ; if on the h - scroll
          If *this\scroll\v\bar\max > height - *this\scroll\h\height
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll_height( )      = *this\scroll\v\bar\max
            ;  Debug "w - " + *this\scroll\v\bar\max  + " " +  *this\scroll\v\height  + " " +  *this\scroll\v\bar\page\len
          Else
            *this\scroll_height( ) = *this\scroll\v\bar\page\len - ( *this\scroll_x( ) - x ) - *this\scroll\h\height
          EndIf
        EndIf
        
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        *this\scroll\h\bar\max = *this\scroll_width( )
        *this\scroll_width( )  = *this\scroll\h\bar\page\len - ( *this\scroll_x( ) - x )
      EndIf
      
      If *this\scroll_height( ) > *this\scroll\v\bar\page\len - ( *this\scroll_y( ) - y )
        If *this\scroll_height( ) - sy <= Height And *this\scroll_width( ) = *this\scroll\h\bar\page\len - ( *this\scroll_x( ) - x )
          ;Debug " h - " + Str( *this\scroll_height( ) - sy )
          
          ; if on the v - scroll
          If *this\scroll\h\bar\max > width - *this\scroll\v\width
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll_width( )       = *this\scroll\h\bar\max
            ;  Debug "h - " + *this\scroll\h\bar\max  + " " +  *this\scroll\h\width  + " " +  *this\scroll\h\bar\page\len
          Else
            *this\scroll_width( ) = *this\scroll\h\bar\page\len - ( *this\scroll_x( ) - x ) - *this\scroll\v\width
          EndIf
        EndIf
        
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        *this\scroll\v\bar\max = *this\scroll_height( )
        *this\scroll_height( ) = *this\scroll\v\bar\page\len - ( *this\scroll_y( ) - y )
      EndIf
      
      If *this\scroll\h\round And
         *this\scroll\v\round And
         *this\scroll\h\bar\page\len < width And
         *this\scroll\v\bar\page\len < height
        round = ( *this\scroll\h\height / 4 )
      EndIf
      
      If *this\scroll_width( ) >= *this\scroll\h\bar\page\len
        If *this\scroll\h\bar\Max <> *this\scroll_width( )
          *this\scroll\h\bar\Max = *this\scroll_width( )
          
          If *this\scroll_x( ) <= x
            *this\scroll\h\bar\page\pos = - ( *this\scroll_x( ) - x )
          EndIf
        EndIf
        
        If *this\scroll\h\width <> *this\scroll\h\bar\page\len + round
          ; Debug  "h " + *this\scroll\h\bar\page\len
          Resize( *this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len + round, #PB_Ignore )
          *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len ))
          ;           *this\scroll\h\width = *this\scroll\h\bar\page\len + round
          ;           *this\scroll\h\hide = bar_Update( *this\scroll\h, 2 )
          result = 1
        EndIf
      EndIf
      
      If *this\scroll_height( ) >= *this\scroll\v\bar\page\len
        If *this\scroll\v\bar\Max <> *this\scroll_height( )
          *this\scroll\v\bar\Max = *this\scroll_height( )
          
          If *this\scroll_y( ) <= y
            ;If *this\scroll\v\bar\page\pos <>- ( *this\scroll_y( ) - y )
            *this\scroll\v\bar\page\pos = - ( *this\scroll_y( ) - y )
            
            ; Post( *this\scroll\v, #__event_change )
            ;EndIf
          EndIf
        EndIf
        
        If *this\scroll\v\height <> *this\scroll\v\bar\page\len + round
          ; Debug  "v " + *this\scroll\v\bar\page\len
          Resize( *this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len + round )
          *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len ))
          ;           *this\scroll\v\height = *this\scroll\v\bar\page\len + round
          ;           *this\scroll\v\hide = bar_Update( *this\scroll\v, 2 )
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
        bar_Update( *this\scroll\v )
        *this\scroll\v\hide = Bool( Not ( *this\scroll\v\bar\max > *this\scroll\v\bar\page\len ))
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        bar_Update( *this\scroll\h )
        *this\scroll\h\hide = Bool( Not ( *this\scroll\h\bar\max > *this\scroll\h\bar\page\len ))
      EndIf
      
      If result
        
        *this\width[#__c_inner]  = *this\scroll\h\bar\page\len
        *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        *this\resize | #__resize_change
        
      EndIf
      
      
    EndProcedure
    
    Procedure bar_Resizes( *this._S_widget, x.l, y.l, width.l, height.l )
      If ( *this\width = 0 And *this\height = 0)
        If *this\scroll
          *this\scroll\v\hide = #True
          *this\scroll\h\hide = #True
        EndIf
        ProcedureReturn 0
      EndIf
      
      With *this\scroll
        Protected v1, h1, x1 = #PB_Ignore, y1 = #PB_Ignore, width1 = #PB_Ignore, height1 = #PB_Ignore, iwidth, iheight, w, h
        ;Protected v1, h1, x1 = *this\x[#__c_container], y1 = *this\y[#__c_container], width1 = *this\width[#__c_container], height1 = *this\height[#__c_container], iwidth, iheight, w, h
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
        
        w = Bool( *this\scroll_width( ) > width )
        h = Bool( *this\scroll_height( ) > height )
        
        \v\bar\page\len = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        \h\bar\page\len = width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
        
        iheight = height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
        If \v\bar\page\len <> iheight
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
        If \h\bar\page\len <> iwidth
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
        
        If \v\x[#__c_frame] <> width - \v\width
          v1 = 1
          x1 = width - \v\width
        EndIf
        
        If \h\y[#__c_frame] <> height - \h\height
          h1 = 1
          y1 = height - \h\height
        EndIf
        
        If \v\bar\max > \v\bar\page\len
          v1      = 1
          height1 = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
          If \v\hide <> #False
            \v\hide = #False
            If \h\hide
              width1 = \h\bar\page\len
            EndIf
          EndIf
        Else
          If \v\hide <> #True
            \v\hide = #True
            *this\resize | #__resize_change
            ; reset page pos then hide scrollbar
            If \v\bar\page\pos > \v\bar\min
              If bar_Change( \v, \v\bar\min )
                bar_Update( \v, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \h\bar\max > \h\bar\page\len
          h1     = 1
          width1 = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width / 4 ))
          If \h\hide <> #False
            \h\hide = #False
            If \v\hide
              height1 = \v\bar\page\len
            EndIf
          EndIf
        Else
          If \h\hide <> #True
            \h\hide = #True
            *this\resize | #__resize_change
            ; reset page pos then hide scrollbar
            If \h\bar\page\pos > \h\bar\min
              If bar_Change( \h, \h\bar\min )
                bar_Update( \h, 0 )
              EndIf
            EndIf
          EndIf
        EndIf
        
        If v1
          Resize( \v, x1 , y, #PB_Ignore, height1 )
        EndIf
        If h1
          Resize( \h, x, y1, width1, #PB_Ignore )
        EndIf
        
        
        If \v\bar\AreaChange( ) Or
           \h\bar\AreaChange( )
          ;           *this\resize | #__resize_change
          ; Debug ""+*this\width[#__c_inner]  +" "+ \h\bar\page\len
          
          ;\\ update inner coordinate
          *this\width[#__c_inner]  = \h\bar\page\len
          *this\height[#__c_inner] = \v\bar\page\len
          
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure bar_Events( *this._S_widget, eventtype.l, *button._S_buttons, *data )
      Protected Repaint
      Protected._s_BUTTONS *BB1, *BB2, *SB
      *SB  = *this\bar\button
      *BB1 = *this\bar\button[1]
      *BB2 = *this\bar\button[2]
      
      ;\\
      If eventtype = #__event_Down
        If mouse( )\buttons & #PB_Canvas_LeftButton
          ;\\
          If EnteredButton( ) And
             EnteredButton( )\state\disable = #False And
             EnteredButton( )\color\state <> #__S_3 And ; change the color state of non-disabled buttons
             EnteredButton( )\state\press = #False
            
            PressedButton( )             = EnteredButton( )
            PressedButton( )\state\press = #True
            ;PressedButton( )\color\state                              = #__S_2
            If Not ( *this\type = #__type_TrackBar Or
                     ( *this\type = #__type_Splitter And PressedButton( ) <> *SB ))
              PressedButton( )\color\state = #__S_2
            EndIf
            PressedButton( )\color\back[PressedButton( )\color\state] = $FF2C70F5
            
            ;
            If ( *BB2\state\press And *this\bar\invert ) Or
               ( *BB1\state\press And Not *this\bar\invert )
              
              If bar_SetState( *this, *this\bar\page\pos - *this\scroll\increment )
                *this\state\repaint = #True
              EndIf
            ElseIf ( *BB1\state\press And *this\bar\invert ) Or
                   ( *BB2\state\press And Not *this\bar\invert )
              
              If bar_SetState( *this, *this\bar\page\pos + *this\scroll\increment )
                *this\state\repaint = #True
              EndIf
            EndIf
          EndIf
          
          ;\\
          If *this\tab
            *this\PressedTab( ) = *this\EnteredTab( )
            
            ;                                              ;
            If Not ( EnteredButton( ) And EnteredButton( )\state\press And EnteredButton( ) <> *SB )
              If *this\PressedTab( )
                If *this\PressedTab( )\state\press = #False
                  *this\PressedTab( )\state\press = #True
                  
                  *this\PressedTab( )\color\state                                 = #__S_2
                  *this\PressedTab( )\color\back[*this\PressedTab( )\color\state] = $FF2C70F5
                  
                  *this\state\repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_Up
        If mouse( )\buttons & #PB_Canvas_LeftButton
          ;\\
          If PressedButton( ) And
             PressedButton( )\state\press = #True
            PressedButton( )\state\press = #False
            
            If PressedButton( )\state\disable = #False And
               PressedButton( )\color\state <> #__S_3
              
              ; change color state
              If PressedButton( )\color\state = #__S_2 And
                 Not ( *this\type = #__type_TrackBar Or
                       ( *this\type = #__type_Splitter And PressedButton( ) <> *SB ))
                
                If PressedButton( )\state\enter
                  PressedButton( )\color\state = #__S_1
                Else
                  PressedButton( )\color\state = #__S_0
                EndIf
              EndIf
              
              *this\state\repaint = #True
            EndIf
          EndIf
          
          ;\\
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
                
                If *this\PressedTab( ) And bar_tab_SetState( *this, *this\PressedTab( )\index )
                  *this\state\repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_MouseMove
        If *this\state\press And *SB\state\press
          If *this\bar\vertical
            Repaint | bar_SetThumbPos( *this, ( mouse( )\y - mouse( )\delta\y ))
          Else
            Repaint | bar_SetThumbPos( *this, ( mouse( )\x - mouse( )\delta\x ))
          EndIf
          
          SetWindowTitle( EventWindow( ), Str( *this\bar\page\pos ) + " " + Str( *this\bar\thumb\pos - *this\bar\area\pos ))
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
        If bar_scroll_pos_( *this\scroll\h, (_this_\text\caret\x - _this_\text\padding\x) - _this_\x[#__c_inner], ( _this_\text\padding\x * 2 + _this_\row\margin\width )) ; ok
          *this\WidgetChange( ) = - 1
        EndIf
      EndIf
    EndMacro
    
    Macro edit_text_scroll_y_( _this_ )
      If *this\scroll\v And Not *this\scroll\v\hide
        If bar_scroll_pos_( *this\scroll\v, (_this_\text\caret\y - _this_\text\padding\y) - _this_\y[#__c_inner], ( _this_\text\padding\y * 2 + _this_\text\caret\height )) ; ok
          *this\WidgetChange( ) = - 1
        EndIf
      EndIf
    EndMacro
    
    Macro edit_caret_0( ): text\caret\pos[0]: EndMacro
    Macro edit_caret_1( ): text\caret\pos[1]: EndMacro
    Macro edit_caret_2( ): text\caret\pos[2]: EndMacro
    
    ;\\ Macro edit_row_caret_1_( _this_ ): _this_\text\caret\pos[3]: EndMacro
    
    Procedure.l edit_caret_( *this._S_widget )
      ; Get caret position
      Protected i.l, mouse_x.l, caret_x.l, caret.l = - 1
      Protected Distance.f, MinDistance.f = Infinity( )
      
      If *this\EnteredRow( )
        If Not Drawing( )
          Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ) )
          draw_font_item_( *this, *this\EnteredRow( ), 1 ) ;*this\EnteredRow( )\TextChange( ) )
        EndIf
        
        mouse_x = mouse( )\x - row_x_( *this, *this\EnteredRow( ) ) - *this\EnteredRow( )\text\x - *this\scroll_x( ) - Bool( #PB_Compiler_OS = #PB_OS_MacOS ) ; надо узнать, думаю это связано с DrawRotateText( )
        
        For i = 0 To *this\EnteredRow( )\text\len
          caret_x = TextWidth( Left( *this\EnteredRow( )\text\string, i ))
          
          Distance = ( mouse_x - caret_x ) * ( mouse_x - caret_x )
          
          If MinDistance > Distance
            MinDistance = Distance
            ; *this\text\caret\x = *this\text\padding\x + caret_x
            caret = i
          Else
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn caret
    EndProcedure
    
    Procedure edit_sel_row_text_( *this._S_widget, *rowLine._S_rows, mode.l = #__sel_to_line )
      Protected CaretLeftPos, CaretRightPos, CaretLastLen = 0
      Debug "edit_sel_row_text - " + *rowLine\index + " " + mode
      
      *this\state\repaint = #True
      ;\\ *rowLine\color\state = #__s_2
      *rowLine\state\focus = #True
      
      If mode = #__sel_to_remove
        
        CaretLeftPos         = 0
        CaretRightPos        = 0
        *rowLine\color\state = #__s_0
        *rowLine\state\focus = #False
        
      ElseIf mode = #__sel_to_set
        
        CaretLeftPos  = 0
        CaretRightPos = *rowLine\text\len
        CaretLastLen  = *this\mode\fullselection
        
      ElseIf mode = #__sel_to_first
        
        CaretLeftPos = 0
        If *rowLine = *this\PressedRow( )
          CaretRightPos = *this\edit_caret_2( ) - *rowLine\text\pos
        Else
          CaretRightPos = *rowLine\text\len
          CaretLastLen  = *this\mode\fullselection
        EndIf
        ;\\ *this\edit_caret_1( ) = *rowLine\text\pos
        
      ElseIf mode = #__sel_to_last
        
        If *rowLine = *this\PressedRow( )
          CaretLeftPos = *this\edit_caret_2( ) - *rowLine\text\pos
        Else
          CaretLeftPos = 0
        EndIf
        CaretRightPos = *rowLine\text\len
        
        If *rowLine\index <> *this\count\items - 1
          CaretLastLen = *this\mode\fullselection
        EndIf
        ;\\ *this\edit_caret_1( ) = *rowLine\text\pos + *rowLine\text\len
        
      ElseIf mode = #__sel_to_line
        
        If *this\edit_caret_1( ) >= *this\edit_caret_2( )
          If *rowLine\text\pos <= *this\edit_caret_2( )
            CaretLeftPos = *this\edit_caret_2( ) - *rowLine\text\pos
          EndIf
          CaretRightPos = *this\edit_caret_1( ) - *rowLine\text\pos
        Else
          CaretLeftPos = *this\edit_caret_1( ) - *rowLine\text\pos
          If *this\edit_caret_2( ) > ( *rowLine\text\pos + *rowLine\text\len )
            If *rowLine <> *this\PressedRow( )
              CaretLastLen = *this\mode\fullselection
            EndIf
            CaretRightPos = *rowLine\text\len
          Else
            CaretRightPos = *this\edit_caret_2( ) - *rowLine\text\pos
          EndIf
        EndIf
        
      EndIf
      
      ; Debug "caret change " + CaretLeftPos +" "+ CaretRightPos
      
      *rowLine\text\edit[1]\pos = 0
      *rowLine\text\edit[2]\pos = CaretLeftPos  ; - *rowLine\text\pos
      *rowLine\text\edit[3]\pos = CaretRightPos ; - *rowLine\text\pos
      
      *rowLine\text\edit[1]\len = *rowLine\text\edit[2]\pos
      *rowLine\text\edit[2]\len = *rowLine\text\edit[3]\pos - *rowLine\text\edit[2]\pos
      *rowLine\text\edit[3]\len = *rowLine\text\len - *rowLine\text\edit[3]\pos
      
      If Not Drawing( )
        Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
      EndIf
      
      ; item left text
      If *rowLine\text\edit[1]\len > 0
        *rowLine\text\edit[1]\string = Left( *rowLine\text\string, *rowLine\text\edit[1]\len )
        *rowLine\text\edit[1]\width  = TextWidth( *rowLine\text\edit[1]\string )
        *rowLine\text\edit[1]\y      = *rowLine\text\y
        *rowLine\text\edit[1]\height = *rowLine\text\height
      Else
        *rowLine\text\edit[1]\string = ""
        *rowLine\text\edit[1]\width  = 0
      EndIf
      ; item right text
      If *rowLine\text\edit[3]\len > 0
        *rowLine\text\edit[3]\y      = *rowLine\text\y
        *rowLine\text\edit[3]\height = *rowLine\text\height
        If *rowLine\text\edit[3]\len = *rowLine\text\len
          *rowLine\text\edit[3]\string = *rowLine\text\string
          *rowLine\text\edit[3]\width  = *rowLine\text\width
        Else
          *rowLine\text\edit[3]\string = Right( *rowLine\text\string, *rowLine\text\edit[3]\len )
          *rowLine\text\edit[3]\width  = TextWidth( *rowLine\text\edit[3]\string )
        EndIf
      Else
        *rowLine\text\edit[3]\string = ""
        *rowLine\text\edit[3]\width  = 0
      EndIf
      ; item edit text
      If *rowLine\text\edit[2]\len > 0
        If *rowLine\text\edit[2]\len = *rowLine\text\len
          *rowLine\text\edit[2]\string = *rowLine\text\string
          *rowLine\text\edit[2]\width  = *rowLine\text\width
        Else
          *rowLine\text\edit[2]\string = Mid( *rowLine\text\string, 1 + *rowLine\text\edit[2]\pos, *rowLine\text\edit[2]\len )
          *rowLine\text\edit[2]\width  = *rowLine\text\width - ( *rowLine\text\edit[1]\width + *rowLine\text\edit[3]\width )
        EndIf
        *rowLine\text\edit[2]\y      = *rowLine\text\y
        *rowLine\text\edit[2]\height = *rowLine\text\height
      Else
        *rowLine\text\edit[2]\string = ""
        *rowLine\text\edit[2]\width  = 0
      EndIf
      
      ;
      If CaretLastLen
        *rowLine\text\edit[2]\width + CaretLastLen
      EndIf
      
      ; Чтобы знать что строки выделени
      If *rowLine\text\edit[2]\width
        *this\text\edit[2]\width = *rowLine\text\edit[2]\width
      EndIf
      
      ; set text position
      *rowLine\text\edit[1]\x = *rowLine\text\x
      *rowLine\text\edit[2]\x = *rowLine\text\x + *rowLine\text\edit[1]\width
      *rowLine\text\edit[3]\x = *rowLine\text\x + *rowLine\text\edit[1]\width + *rowLine\text\edit[2]\width
      
      ProcedureReturn #True
    EndProcedure
    
    Procedure edit_sel_text_( *this._S_widget, *line._S_rows )
      ; edit sel all items
      If *line = #PB_All
        *line                 = *this\FocusedRow( )
        *this\PressedRow( )   = #Null
        *this\edit_caret_0( ) = 0
        *this\edit_caret_1( ) = 0
        *this\edit_caret_2( ) = 0
        PushListPosition( *this\_rows( ) )
        ForEach *this\_rows( )
          edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_last )
        Next
        ;*this\PressedRow( ) = *this\_rows( )
        PopListPosition( *this\_rows( ) )
        *this\edit_caret_1( ) = 0
        *this\edit_caret_2( ) = *this\text\len
        *this\PressedRow( )   = *this\FocusedRow( )
      EndIf
      
      If *this\edit_caret_1( ) > *this\edit_caret_2( )
        *this\text\edit[2]\pos = *this\edit_caret_2( )
        *this\text\edit[3]\pos = *this\edit_caret_1( )
        *this\text\caret\x     = *line\x + *line\text\edit[3]\x - 1
      Else
        *this\text\edit[2]\pos = *this\edit_caret_1( )
        *this\text\edit[3]\pos = *this\edit_caret_2( )
        *this\text\caret\x     = *line\x + *line\text\edit[2]\x - 1
      EndIf
      
      *this\text\caret\height = *line\text\height
      *this\text\caret\y      = *line\y
      
      ;       ;*this\text\caret\x = 13
      ;       ;Debug ""+*this\text\padding\x +" "+ *this\text\caret\x +" "+ *this\edit_caret_1( ) +" "+ *line\text\edit[1]\string
      ;       ;Debug TextWidth("W")
      
      ;
      *this\text\edit[1]\len = *this\text\edit[2]\pos
      *this\text\edit[3]\len = ( *this\text\len - *this\text\edit[3]\pos )
      
      If *this\text\edit[2]\len <> ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
        *this\text\edit[2]\len = ( *this\text\edit[3]\pos - *this\text\edit[2]\pos )
      EndIf
      ;;Debug ""+*this\edit_caret_1( ) +" "+ *this\text\edit[3]\pos;*this\text\edit[2]\len;*this\text\edit[2]\string
      
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
    
    Macro edit_sel_reset_( _this_ )
      If _this_\text\edit[2]\width <> 0
        ; вызывать если только строки выделени
        If _this_\text\multiLine
          PushListPosition( _this_\_rows( ) )
          ForEach _this_\_rows( )
            If _this_\_rows( )\text\edit[2]\width <> 0
              ; Debug " remove - " +" "+ _this_\_rows( )\text\string
              edit_sel_row_text_( _this_, _this_\_rows( ), #__sel_to_remove )
            EndIf
          Next
          PopListPosition( _this_\_rows( ) )
        EndIf
      EndIf
    EndMacro
    
    Macro edit_sel_is_line_pos_( _this_ )
      Bool( _this_\_rows( )\text\edit[2]\width And
            mouse( )\x > _this_\_rows( )\text\edit[2]\x - _this_\scroll_x( ) And
            mouse( )\y > _this_\_rows( )\text\y - _this_\scroll_y( ) And
            mouse( )\y < ( _this_\_rows( )\text\y + _this_\_rows( )\text\height ) - _this_\scroll_y( ) And
            mouse( )\x < ( _this_\_rows( )\text\edit[2]\x + _this_\_rows( )\text\edit[2]\width ) - _this_\scroll_x( ) )
    EndMacro
    
    Macro edit_sel_end_( _char_ )
      Bool(( _char_ >= ' ' And _char_ <= '/' ) Or               ; ! " # $ % & ' ( ) * + , - .
           ( _char_ >= ':' And _char_ <= '@' ) Or               ;   ; < = > ?
           ( _char_ >= '[' And _char_ <= '^' ) Or               ; \ ] ^ _ `
           ( _char_ >= '{' And _char_ <= '~' ) Or _char_ = '`') ; | }
      
    EndMacro
    
    Procedure.i edit_sel_start_word( *this._S_widget, caret, *rowLine._S_rows )
      Protected result.i, i.i, char.i
      
      ; | <<<<<< left edge of the word
      char = Asc( Mid( *rowLine\text\string, caret + 1, 1 ))
      If edit_sel_end_( char )
        result = *rowLine\text\pos + caret
      Else
        result = *rowLine\text\pos
        For i = caret To 1 Step - 1
          char = Asc( Mid( *rowLine\text\string, i, 1 ))
          If edit_sel_end_( char )
            result = *rowLine\text\pos + i
            Break
          EndIf
        Next
      EndIf
      ;Debug result - *rowLine\text\pos
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i edit_sel_stop_word( *this._S_widget, caret, *rowLine._S_rows )
      Protected result.i, i.i, char.i
      
      ; >>>>>> | right edge of the word
      char = Asc( Mid( *rowLine\text\string, caret, 1 ))
      If edit_sel_end_( char )
        result.i = *rowLine\text\pos + caret
      Else
        result.i = *rowLine\text\pos + *rowLine\text\len
        For i = caret + 1 To *rowLine\text\len
          char = Asc( Mid( *rowLine\text\string, i, 1 ))
          If edit_sel_end_( char )
            result = *rowLine\text\pos + ( i - 1 )
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure edit_row_align( *this._S_widget )
      ; Debug ""+*this\text\align\left +" "+ *this\text\align\top +" "+ *this\text\align\right +" "+ *this\text\align\bottom
      ; set align position
      ForEach *this\_rows( )
        If *this\text\vertical
        Else ; horizontal
          If *this\text\rotate = 180
            *this\_rows( )\y - ( *this\height[#__c_inner] - *this\scroll_height( ) )
          EndIf
          
          ; changed
          set_align_y_( *this\text, *this\_rows( )\text, - 1, *this\text\rotate )
          set_align_x_( *this\text, *this\_rows( )\text, *this\scroll_width( ), *this\text\rotate )
          
          ;           If *this\type = #__type_String
          ;             Debug *this\_rows( )\text\string
          ;           EndIf
        EndIf
      Next
    EndProcedure
    
    ;-
    Procedure edit_make_text_position( *this._S_widget )
      edit_row_align( *this )
      
      ;
      bar_area_update( *this )
      
      ; make horizontal scroll x
      make_scrollarea_x( *this, *this\text )
      
      ; make vertical scroll y
      make_scrollarea_y( *this, *this\text )
      
      If *this\scroll\v And
         bar_SetState( *this\scroll\v, - *this\scroll_y( ) )
      EndIf
      
      If *this\scroll\h And
         bar_SetState( *this\scroll\h, - *this\scroll_x( ) )
      EndIf
    EndProcedure
    
    Procedure.s edit_make_insert_text( *this._S_widget, Text.s )
      Protected String.s, i.i, Len.i
      
      With *this
        If *this\text\numeric And Text.s <> #LF$
          Static Dot, Minus
          Protected Chr.s, Input.i, left.s, count.i
          
          Len = Len( Text.s )
          For i = 1 To Len
            Chr   = Mid( Text.s, i, 1 )
            Input = Asc( Chr )
            
            Select Input
              Case '0' To '9', '.', '-'
              Case 'Ю', 'ю', 'Б', 'б', 44, 47, 60, 62, 63 : Input = '.' : Chr = Chr( Input )
                
              Default
                Input = 0
            EndSelect
            
            If Input
              If *this\type = #__type_IPAddress
                left.s = Left( *this\text\string, *this\edit_caret_1( ) )
                Select CountString( left.s, "." )
                  Case 0 : left.s = StringField( left.s, 1, "." )
                  Case 1 : left.s = StringField( left.s, 2, "." )
                  Case 2 : left.s = StringField( left.s, 3, "." )
                  Case 3 : left.s = StringField( left.s, 4, "." )
                EndSelect
                count = Len( left.s + Trim( StringField( Mid( *this\text\string, *this\edit_caret_1( ) + 1 ), 1, "." ), #LF$ ))
                If count < 3 And ( Val( left.s ) > 25 Or Val( left.s + Chr.s ) > 255 )
                  Continue
                  ;               ElseIf Mid( *this\text\string, *this\edit_caret_1( ) + 1, 1 ) = "."
                  ;                 *this\edit_caret_1( ) + 1 : *this\edit_caret_2( ) = *this\edit_caret_1( )
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid( *this\text\string, *this\edit_caret_1( ) + 1, 1 ) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid( *this\text\string, *this\edit_caret_1( ) + 1, 1 ) <> " - "
                Minus = 1
              ElseIf Input <> ' - '
                Minus = 0
              Else
                Continue
              EndIf
              
              String.s + Chr
            EndIf
          Next
          
        ElseIf *this\text\pass
          Len = Len( Text.s )
          ;For i = 1 To Len : String.s + "●" : Next
          For i = 1 To Len : String.s + "•" : Next
          
        Else
          Select #True
            Case *this\text\lower : String.s = LCase( Text.s )
            Case *this\text\upper : String.s = UCase( Text.s )
            Default
              String.s = Text.s
          EndSelect
        EndIf
      EndWith
      
      ProcedureReturn String.s
    EndProcedure
    
    Procedure.b edit_insert_text( *this._s_widget, Chr.s )
      Protected result.b, String.s, Count.i, *rowLine._S_rows
      
      Chr.s = edit_make_insert_text( *this, Chr.s)
      
      If Chr.s
        *rowLine = *this\FocusedRow( )
        If *rowLine
          Count = CountString( Chr.s, #LF$)
          
          If *this\edit_caret_1( ) > *this\edit_caret_2( )
            *this\edit_caret_1( ) = *this\edit_caret_2( )
          Else
            *this\edit_caret_2( ) = *this\edit_caret_1( )
          EndIf
          
          *this\edit_caret_1( ) + Len( Chr.s )
          *this\edit_caret_2( ) = *this\edit_caret_1( )
          
          If count Or *rowLine\index <> *this\PressedLineIndex( )
            *this\TextChange( ) = - 1
          EndIf
          
          If *rowLine\text\edit[2]\width <> 0
            *rowLine\text\edit[2]\len      = 0
            *rowLine\text\edit[2]\string.s = ""
          Else
            *rowLine\text\edit[1]\len + Len( Chr.s )
            *rowLine\text\edit[1]\string.s + Chr.s
            
            *rowLine\text\len      = *rowLine\text\edit[1]\len + *rowLine\text\edit[3]\len
            *rowLine\text\string.s = *rowLine\text\edit[1]\string.s + *rowLine\text\edit[3]\string.s
            *rowLine\text\width    = TextWidth( *rowLine\text\string )
          EndIf
          
          *this\text\edit[1]\len + Len( Chr.s )
          *this\text\edit[1]\string.s + Chr.s
          
          *this\text\len      = *this\text\edit[1]\len + *this\text\edit[3]\len
          *this\text\string.s = *this\text\edit[1]\string + *this\text\edit[3]\string
          
          ;
          If *rowLine\index > *this\PressedLineIndex( )
            *this\EnteredLineIndex( ) = *this\PressedLineIndex( ) + Count
          Else
            *this\EnteredLineIndex( ) = *rowLine\index + Count
          EndIf
          *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
          
          ;
          If Not *this\TextChange( )
            If *this\scroll_width( ) < *rowLine\text\width
              *this\scroll_width( ) = *rowLine\text\width
              
              bar_area_update( *this )
            EndIf
          EndIf
          
          result              = 1
          *this\state\repaint = 1
        EndIf
      Else
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Macro edit_change_text_( _address_, _char_len_ = 0, _position_ = )
      _address_\text\edit#_position_\len + _char_len_
      _address_\text\len      = _address_\text\edit[1]\len + _address_\text\edit[3]\len
      _address_\text\string.s = Left( _address_\text\string.s, _address_\text\edit[1]\len ) + Right( _address_\text\string.s, _address_\text\edit[3]\len )
    EndMacro
    
    Macro edit_change_caret_( _this_, _index_ )
      If _this_\PressedLineIndex( ) <> _index_
        _this_\TextChange( ) = - 1
      EndIf
      
      If _this_\edit_caret_1( ) > _this_\edit_caret_2( )
        _this_\edit_caret_1( ) = _this_\edit_caret_2( )
      Else
        _this_\edit_caret_2( ) = _this_\edit_caret_1( )
      EndIf
      
      If _this_\PressedLineIndex( ) > _index_
        _this_\EnteredLineIndex( ) = _index_
        _this_\PressedLineIndex( ) = _index_
      Else
        _this_\EnteredLineIndex( ) = _this_\PressedLineIndex( )
      EndIf
    EndMacro
    
    Procedure edit_key_page_up_down_( *this._S_widget, wheel, row_select )
      Protected repaint, select_index, page_height
      Protected first_index = 0, last_index = *this\count\items - 1
      
      If wheel = - 1 ; page-up
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
              ;\\ *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\edit_caret_0( )
              *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( )
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint     = 1
          EndIf
        Else
          If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos
            *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
            repaint               = 1
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
              ;\\ *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\edit_caret_0( )
              *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\edit_caret_1( )
            EndIf
            
            page_height = *this\height[#__c_inner]
            repaint     = 1
          EndIf
        Else
          If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
            *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
            repaint               = 1
          EndIf
        EndIf
      EndIf
      
      If repaint
        *this\edit_caret_2( )     = *this\edit_caret_1( )
        *this\EnteredLineIndex( ) = *this\FocusedRow( )\index
        *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
        
        If wheel = - 1
          row_scroll_y_( *this, *this\FocusedRow( ), - page_height )
        ElseIf wheel = 1
          row_scroll_y_( *this, *this\FocusedRow( ), + page_height )
        EndIf
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure edit_key_home_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control
        If *this\edit_caret_1( ) <> 0
          *this\edit_caret_1( )     = 0
          *this\EnteredLineIndex( ) = 0
          
          Debug "key ctrl home"
          result = 1
        EndIf
      Else
        If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos
          *this\edit_caret_1( )     = *this\FocusedRow( )\text\pos
          *this\EnteredLineIndex( ) = *this\FocusedRow( )\index
          
          Debug "key home"
          result = 1
        EndIf
      EndIf
      
      If result
        *this\edit_caret_2( )     = *this\edit_caret_1( )
        *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
        ;\\ *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
        *this\FocusedRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure edit_key_end_( *this._S_widget )
      Protected result
      
      If Keyboard( )\key[1] & #PB_Canvas_Control
        If *this\edit_caret_1( ) <> *this\text\len
          *this\edit_caret_1( )     = *this\text\len
          *this\EnteredLineIndex( ) = *this\count\items - 1
          
          Debug "key ctrl end"
          result = 1
        EndIf
      Else
        If *this\edit_caret_1( ) <> *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
          *this\edit_caret_1( )     = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
          *this\EnteredLineIndex( ) = *this\FocusedRow( )\index
          
          Debug "key end"
          result = 1
        EndIf
      EndIf
      
      If result
        *this\edit_caret_2( )     = *this\edit_caret_1( )
        *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
        ;\\ *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
        *this\FocusedRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure edit_key_backup_( *this._S_widget )
      Protected Repaint, remove_chr_len, *rowLine._S_rows = *this\FocusedRow( )
      
      If *this\text\edit[2]\len
        edit_change_caret_( *this, *rowLine\index )
        
        Debug "" + #PB_Compiler_Procedure + " " + 1111111111
        remove_chr_len = 0
        edit_change_text_( *rowLine, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint = - 1
        
      ElseIf *this\edit_caret_1( ) > *rowLine\text\pos
        Debug "" + #PB_Compiler_Procedure + " " + 2222222222 + " " + *this\text\len
        *this\edit_caret_1( ) - 1
        *this\edit_caret_2( )     = *this\edit_caret_1( )
        *this\EnteredLineIndex( ) = *rowLine\index
        
        remove_chr_len = 1
        edit_change_text_( *rowLine, - remove_chr_len, [1] )
        edit_change_text_( *this, - remove_chr_len, [1] )
        Repaint = - 1
        
      Else
        Debug "" + #PB_Compiler_Procedure + " " + 3333333333 + " " + *this\text\len
        If *rowLine\index > 0
          remove_chr_len = Len( #LF$ )
          *this\edit_caret_1( ) - remove_chr_len
          *this\edit_caret_2( ) = *this\edit_caret_1( )
          
          *this\EnteredLineIndex( ) = *rowLine\index - 1
          *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
          *this\TextChange( )       = - 1
          
          edit_change_text_( *rowLine, - remove_chr_len, [1] )
          edit_change_text_( *this, - remove_chr_len, [1] )
          Repaint = - 1
          
        Else
          *this\notify = 2
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure edit_key_delete_( *this._S_widget )
      Protected Repaint, remove_chr_len, *rowLine._S_rows = *this\FocusedRow( )
      
      If *this\text\edit[2]\len
        edit_change_caret_( *this, *rowLine\index )
        
        remove_chr_len = 1
        Repaint        = - 1
        
      ElseIf *this\edit_caret_1( ) < *this\text\len ; ok
        If *this\edit_caret_1( ) = *rowLine\text\pos + *rowLine\text\len
          remove_chr_len      = Len( #LF$ )
          *this\TextChange( ) = - 1
        Else
          remove_chr_len = 1
        EndIf
        
        ;Debug ""+*this\edit_caret_1( ) +" "+ *this\text\len
        ; change caret
        *this\EnteredLineIndex( ) = *rowLine\index
        *this\PressedLineIndex( ) = *rowLine\index
        
        Repaint = - 1
      EndIf
      
      If Repaint
        edit_change_text_( *rowLine, - remove_chr_len, [3] )
        edit_change_text_( *this, - remove_chr_len, [3] )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure edit_key_return_( *this._S_widget )
      Protected *rowLine._S_rows
      
      If *this\text\multiline
        *rowLine._S_rows = *this\FocusedRow( )
        
        If *this\PressedLineIndex( ) >= *rowLine\index
          If *this\edit_caret_1( ) > *this\edit_caret_2( )
            *this\edit_caret_1( ) = *this\edit_caret_2( )
          EndIf
          *this\edit_caret_1( ) + Len( #LF$ )
          *this\edit_caret_2( )     = *this\edit_caret_1( )
          *this\EnteredLineIndex( ) = *rowLine\index + 1
        Else
          *this\edit_caret_2( ) + Len( #LF$ )
          *this\edit_caret_1( )     = *this\edit_caret_2( )
          *this\EnteredLineIndex( ) = *this\PressedLineIndex( ) + 1
        EndIf
        *this\PressedLineIndex( ) = *this\EnteredLineIndex( )
        
        ; Debug ""+*this\edit_caret_1( ) +" "+ *this\edit_caret_2( ) +" "+ *this\EnteredLineIndex( ) +" "+ *this\PressedLineIndex( )
        
        *this\text\string.s = *this\text\edit[1]\string + #LF$ + *this\text\edit[3]\string
        *this\TextChange( ) = - 1
        
        ;
        ;         _AddItem( *this, *this\PressedLineIndex( ), *rowLine\text\edit[3]\string )
        ;
        ;         *this\text\string.s = *this\text\edit[1]\string + #LF$ + *rowLine\text\edit[3]\string + #LF$ + Right( *this\text\string.s, *this\text\len - (*rowLine\text\pos + *rowLine\text\len + 1))
        ;         *rowLine\text\edit[3]\len = Len( #LF$ )
        ;         *rowLine\text\edit[3]\string = #LF$
        ;         *rowLine\text\len = *rowLine\text\edit[1]\len + *rowLine\text\edit[3]\len
        ;         *rowLine\text\string.s = *rowLine\text\edit[1]\string + *rowLine\text\edit[3]\string
        ;          *this\TextChange( ) = 0
        ;          *this\WidgetChange( ) = 0
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
    Procedure edit_SetItem( *this._S_widget, position, *text.Character, string_len )
      Protected *rowLine._S_rows
      Protected add_index = - 1, add_y, add_pos, add_height
      
      If position < 0 Or position > ListSize( *this\_rows( )) - 1
        LastElement( *this\_rows( ))
        *rowLine = AddElement( *this\_rows( ))
        
        ;If position < 0
        position = ListIndex( *this\_rows( ))
        ;EndIf
        
      Else
        
        *rowLine   = SelectElement( *this\_rows( ), position )
        add_index  = *this\_rows( )\index
        add_y      = *this\_rows( )\y + Bool( #PB_Compiler_OS = #PB_OS_Windows )
        add_pos    = *this\_rows( )\text\pos
        add_height = *this\_rows( )\height + *this\mode\gridlines
        *rowLine   = InsertElement( *this\_rows( ))
        
        PushListPosition( *this\_rows( ))
        While NextElement( *this\_rows( ))
          *this\_rows( )\index = ListIndex( *this\_rows( ) )
          *this\_rows( )\y + add_height
          *this\_rows( )\text\pos + string_len + Len( #LF$ )
        Wend
        PopListPosition(*this\_rows( ))
        
      EndIf
      
      *this\_rows( )\index       = position
      *this\_rows( )\text\len    = string_len
      *this\_rows( )\text\string = PeekS ( *text, string_len )
      
      If Not Drawing( )
        Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ) )
      EndIf
      
      draw_font_item_( *this, *this\_rows( ), *this\_rows( )\TextChange( ) )
      
      *this\_rows( )\height = *this\_rows( )\text\height ; + 10
      *this\_rows( )\width  = *this\width[#__c_inner]
      *this\_rows( )\color  = _get_colors_( )
      ;*this\_rows( )\color\back = $FFF9F9F9
      
      ; make line position
      If *this\text\vertical
      Else ; horizontal
        If *this\scroll_width( ) < *this\_rows( )\text\width + *this\text\padding\x * 2
          *this\scroll_width( ) = *this\_rows( )\text\width + *this\text\padding\x * 2
        EndIf
        
        If *this\text\rotate = 0
          If add_index >= 0
            *this\_rows( )\text\pos = add_pos
            *this\_rows( )\y        = add_y - *this\text\padding\y
          Else
            *this\_rows( )\text\pos = *this\text\len
            *this\_rows( )\y        = *this\scroll_height( ) - *this\text\padding\y
          EndIf
        ElseIf *this\text\rotate = 180
          *this\_rows( )\y = ( *this\height[#__c_inner] - *this\scroll_height( ) - *this\_rows( )\text\height ) + *this\text\padding\y
        EndIf
        
        *this\scroll_height( ) + *this\_rows( )\height + *this\mode\gridlines
      EndIf
      
      *this\count\items + 1
      *this\text\len + string_len + Len( #LF$ )
      
      set_align_y_( *this\text, *this\_rows( )\text, - 1, *this\text\rotate )
      set_align_x_( *this\text, *this\_rows( )\text, *this\scroll_width( ), *this\text\rotate )
    EndProcedure
    
    Procedure edit_AddItem( *this._S_widget, position, *text.Character, string_len )
      edit_SetItem(*this, position, *text, string_len)
      
      If *this\_rows( )\text\pos = 0
        *this\text\string = InsertString( *this\text\string, *this\_rows( )\text\string, 1 )
      Else
        *this\text\string = InsertString( *this\text\string, #LF$ + *this\_rows( )\text\string, 1 + *this\_rows( )\text\pos )
      EndIf
      ;*this\text\string = InsertString( *this\text\string, *this\_rows( )\text\string + #LF$, 1 + *this\_rows( )\text\pos )
      
      ;       If *this\type = #__type_Editor
      ;         ; Debug "e - "+*this\_rows( )\text\pos +" "+ *this\_rows( )\text\string +" "+ *this\_rows( )\y +" "+ *this\_rows( )\width +" "+ *this\_rows( )\height
      ;         ;  Debug "e - "+*this\_rows( )\text\pos +" "+ *this\_rows( )\text\string +" "+ *this\_rows( )\text\y +" "+ *this\_rows( )\text\width +" "+ *this\_rows( )\text\height
      ;       EndIf
      ;
      ;
      *this\WidgetChange( )  = 0
      *this\TextChange( )    = 1
      *this\text\edit\string = *this\text\string
    EndProcedure
    
    Procedure edit_ClearItems( *this._S_widget )
      *this\WidgetChange( )  = - 1
      *this\count\items      = - 1
      *this\TextChange( )    = - 1
      *this\text\string      = ""
      *this\text\edit\string = ""
      
      If *this\text\editable
        *this\edit_caret_1( )     = 0
        *this\edit_caret_2( )     = 0
        *this\PressedLineIndex( ) = 0
        *this\EnteredLineIndex( ) = 0
      EndIf
      
      PostCanvasRepaint( *this ) ;?
      ProcedureReturn 1
    EndProcedure
    
    Procedure edit_RemoveItem( *this._S_widget, item )
      *this\count\items - 1
      
      If *this\count\items = - 1
        edit_ClearItems( *this )
      Else
        *this\TextChange( ) = - 1
        *this\text\string   = RemoveString( *this\text\string, StringField( *this\text\string, item + 1, #LF$ ) + #LF$ )
        
        If ListSize( *this\_rows( ) )
          SelectElement( *this\_rows( ), item )
          DeleteElement( *this\_rows( ), 1 )
        EndIf
      EndIf
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure edit_SetText( *this._S_widget, text.s )
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
      
      
      *this\scroll_width( )  = *this\text\padding\x * 2
      *this\scroll_height( ) = *this\text\padding\y * 2
      
      Protected enter_index = - 1: If *this\EnteredRow( ): enter_index = *this\EnteredRow( )\index: *this\EnteredRow( ) = #Null: EndIf
      Protected focus_index = - 1: If *this\FocusedRow( ): focus_index = *this\FocusedRow( )\index: *this\FocusedRow( ) = #Null: EndIf
      Protected press_index = - 1: If *this\PressedRow( ): press_index = *this\PressedRow( )\index: *this\PressedRow( ) = #Null: EndIf
      
      If *this\count\items
        *this\count\items = 0
        ClearList( *this\_rows( ))
      Else
        Protected count = 1
      EndIf
      
      ; ; ;       *this\text\len = Len( string )
      ; ; ;       *this\text\string = string
      ; ; ;       *this\count\items = CountString( String, #LF$ )
      ; ; ;       *this\TextChange( ) = 1
      ; ; ;       *this\WidgetChange( ) = 1
      
      *this\text\len    = 0
      *this\text\string = string
      
      While *end\c
        If *end\c = #LF
          edit_SetItem( *this, - 1, *str, (*end - *str) >> #PB_Compiler_Unicode )
          
          If enter_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If focus_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If press_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          
          *str = *end + #__sOC
        EndIf
        *end + #__sOC
      Wend
      
      *this\text\len - Len( #LF$ )
      *this\text\string = Left( *this\text\string, *this\text\len )
      
      *this\WidgetChange( ) = 1
      *this\TextChange( )   = 1
      
      If count
        *this\text\edit\string = *this\text\string
      EndIf
      
      ;Debug ""+*this\scroll_height( ) +" "+ *this\scroll_width( )
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure edit_SetItemState( *this._S_widget, Item.l, State.i )
      If *this\FocusedLineIndex( ) <> Item
        *this\FocusedLineIndex( ) = Item
        
        SelectElement( *this\_rows( ), Item )
        
        If *this\FocusedRow( ) <> *this\_rows( )
          If *this\FocusedRow( )
            If *this\FocusedRow( )\state\focus <> #False
              *this\FocusedRow( )\state\focus = #False
            EndIf
            
            ;*this\FocusedRow( )\color\state = #__s_0
          EndIf
          
          *this\FocusedRow( ) = *this\_rows( )
          
          If *this\FocusedRow( )\state\focus = #False
            *this\FocusedRow( )\state\focus = #True
          EndIf
          
          ;
          *this\FocusedRow( )\color\state = #__s_2
        EndIf
        
        ;
        If state < 0 Or
           state > *this\FocusedRow( )\text\len
          state = *this\FocusedRow( )\text\len
        EndIf
        
        *this\edit_caret_0( ) = State
        *this\edit_caret_1( ) = State + *this\FocusedRow( )\text\pos
        *this\edit_caret_2( ) = State + *this\FocusedRow( )\text\pos
        
        ;
        edit_sel_row_text_( *this, *this\FocusedRow( ) )
        edit_sel_text_( *this, *this\FocusedRow( ) )
        row_scroll_y_( *this, *this\FocusedRow( ) )
        ProcedureReturn #True
      EndIf
    EndProcedure
    
    Procedure edit_SetState( *this._S_widget, State.i )
      If state < 0 Or
         state > *this\text\len
        state = *this\text\len
      EndIf
      
      If *this\edit_caret_1( ) <> State
        PushListPosition( *this\_rows( ) )
        ForEach *this\_rows( )
          If *this\_rows( )\text\pos <= state And
             *this\_rows( )\text\pos + *this\_rows( )\text\len >= state
            
            If *this\FocusedRow( ) <> *this\_rows( )
              If *this\FocusedRow( )
                If *this\FocusedRow( )\state\focus <> #False
                  *this\FocusedRow( )\state\focus = #False
                EndIf
                
                *this\FocusedRow( )\color\state = #__s_0
              EndIf
              
              *this\FocusedRow( )       = *this\_rows( )
              *this\FocusedLineIndex( ) = *this\_rows( )\index
              
              If *this\FocusedRow( )\state\focus = #False
                *this\FocusedRow( )\state\focus = #True
              EndIf
              
              *this\FocusedRow( )\color\state = #__s_2
            EndIf
            Break
          EndIf
        Next
        PopListPosition( *this\_rows( ) )
        
        ;
        *this\edit_caret_1( ) = State
        *this\edit_caret_2( ) = State
        *this\edit_caret_0( ) = State - *this\FocusedRow( )\text\pos
        
        ;
        edit_sel_row_text_( *this, *this\FocusedRow( ) )
        edit_sel_text_( *this, *this\FocusedRow( ) )
        row_scroll_y_( *this, *this\FocusedRow( ) )
        ProcedureReturn #True
      EndIf
    EndProcedure
    
    
    ;-
    Procedure edit_Update_SetText( *this._S_widget, text.s )
      *this\text\edit\string = *this\text\string
      
      *this\scroll_width( )  = *this\text\padding\x * 2
      *this\scroll_height( ) = *this\text\padding\y * 2
      
      Protected string.s = text.s + #LF$
      Protected *str.Character = @string
      Protected *end.Character = @string
      
      Protected enter_index = - 1: If *this\EnteredRow( ): enter_index = *this\EnteredRow( )\index: *this\EnteredRow( ) = #Null: EndIf
      Protected focus_index = - 1: If *this\FocusedRow( ): focus_index = *this\FocusedRow( )\index: *this\FocusedRow( ) = #Null: EndIf
      Protected press_index = - 1: If *this\PressedRow( ): press_index = *this\PressedRow( )\index: *this\PressedRow( ) = #Null: EndIf
      
      *this\text\len = 0
      If *this\count\items
        *this\count\items = 0
        ClearList( *this\_rows( ))
      EndIf
      
      While *End\c
        If *end\c = #LF
          edit_SetItem( *this, - 1, *str, (*end - *str) >> #PB_Compiler_Unicode )
          
          If enter_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If focus_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          If press_index = *this\_rows( )\index: *this\EnteredRow( ) = *this\_rows( ): EndIf
          
          *str = *end + #__sOC
        EndIf
        *end + #__sOC
      Wend
      
      *this\text\len - Len( #LF$ )
      *this\TextChange( )   = 0
      *this\WidgetChange( ) = 0
      
      ProcedureReturn 1
    EndProcedure
    
    Procedure Text_Update( *this._s_WIDGET )
      With *this
        
        If *this\text\string.s
          ;If #debug_update_text
          ;  Debug ""+#PB_Compiler_Procedure +" - "+  *this\index
          ; EndIf
          
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = *this\text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, width
          Protected ColorFont = *this\color\front[\color\state]
          
          ; *this\max
          If *this\text\vertical
            If *this\scroll_height( ) > *this\height[#__c_inner]
              *this\TextChange( ) = #__text_update
            EndIf
            Width = *this\height[#__c_inner] - *this\text\padding\x * 2
            
          Else
            If *this\scroll_width( ) > *this\width[#__c_inner]
              *this\TextChange( ) = #__text_update
            EndIf
            
            width = *this\width[#__c_inner] - *this\text\padding\x * 2
          EndIf
          
          If *this\text\multiLine
            ; make multiline text
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString( text$, #LFCR$, #LF$ )
            ;     text$ = ReplaceString( text$, #CRLF$, #LF$ )
            ;     text$ = ReplaceString( text$, #CR$, #LF$ )
            
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
                  start  = ( *end - *str ) >> #PB_Compiler_Unicode
                  line$  = PeekS ( *str, start )
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
                      If FindString( " ", Mid( line$, found, 1 ))
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
              
              ;String + #LF$
            EndIf
            
            CountString = CountString( String, #LF$ )
          Else
            String.s    = RemoveString( *this\text\string, #LF$ ) + #LF$
            CountString = 1
          EndIf
          
          If *this\count\items <> CountString
            If *this\count\items > CountString
              *this\TextChange( ) = 1
            Else
              *this\TextChange( ) = #__text_update
            EndIf
            
            *this\count\items = CountString
          EndIf
          
          If *this\TextChange( )
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos = 0
            *this\text\len = Len( *this\text\string )
            
            ;\\
            ClearList( *this\_rows( ))
            *this\scroll_width( )  = *this\text\padding\x * 2
            *this\scroll_height( ) = *this\text\padding\y * 2
            
            ;
            While *end\c
              If *end\c = #LF
                AddElement( *this\_rows( ))
                *this\_rows( )\text\len    = ( *end - *str ) >> #PB_Compiler_Unicode
                *this\_rows( )\text\string = PeekS ( *str, *this\_rows( )\text\len )
                ;;*this\_rows( )\text\width = TextWidth( *this\_rows( )\text\string )
                
                ; drawing item font
                draw_font_item_( *this, *this\_rows( ), *this\_rows( )\TextChange( ) )
                
                ;; editor
                *this\_rows( )\index = ListIndex( *this\_rows( ))
                
                *this\_rows( )\height = *this\_rows( )\text\height
                *this\_rows( )\width  = *this\width[#__c_inner]
                *this\_rows( )\color  = _get_colors_( )
                
                
                
                If *this\EnteredLineIndex( ) = *this\_rows( )\index Or
                   *this\FocusedLineIndex( ) = *this\_rows( )\index
                  *this\_rows( )\TextChange( ) = 1
                EndIf
                
                ; make line position
                If *this\text\vertical
                  If *this\scroll_height( ) < *this\_rows( )\text\height + *this\text\padding\y * 2 + *this\mode\fullselection
                    *this\scroll_height( ) = *this\_rows( )\text\height + *this\text\padding\y * 2 + *this\mode\fullselection
                  EndIf
                  
                  If *this\text\rotate = 90
                    *this\_rows( )\x = *this\scroll_width( ) - *this\text\padding\x
                  ElseIf *this\text\rotate = 270
                    *this\_rows( )\x = ( *this\width[#__c_inner] - *this\scroll_width( ) - *this\_rows( )\text\width ) + *this\text\padding\x
                  EndIf
                  
                  *this\scroll_width( ) + TxtHeight + Bool( *this\_rows( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                Else ; horizontal
                  If *this\scroll_width( ) < *this\_rows( )\text\width + *this\text\padding\x * 2 + *this\mode\fullselection
                    *this\scroll_width( ) = *this\_rows( )\text\width + *this\text\padding\x * 2 + *this\mode\fullselection
                  EndIf
                  
                  If *this\text\rotate = 0
                    *this\_rows( )\y = *this\scroll_height( ) - *this\text\padding\y
                  ElseIf *this\text\rotate = 180
                    *this\_rows( )\y = ( *this\height[#__c_inner] - *this\scroll_height( ) - *this\_rows( )\text\height ) + *this\text\padding\y
                  EndIf
                  
                  *this\scroll_height( ) + TxtHeight + Bool( *this\_rows( )\index <> *this\count\items - 1 ) * *this\mode\gridlines
                EndIf
                
                *str = *end + #__sOC
              EndIf
              
              *end + #__sOC
            Wend
            
            
            ;
            ForEach *this\_rows( )
              *this\_rows( )\text\pos = *this\text\pos
              *this\text\pos + *this\_rows( )\text\len + 1 ; Len( #LF$ )
              
              If *this\text\vertical
                If *this\text\rotate = 270
                  *this\_rows( )\x - ( *this\width[#__c_inner] - *this\scroll_width( ) )
                EndIf
                
                ; changed
                If *this\text\rotate = 0
                  *this\_rows( )\text\x = 0
                ElseIf *this\text\rotate = 270
                  *this\_rows( )\text\x = Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + *this\_rows( )\text\width
                Else
                  *this\_rows( )\text\x = - Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                EndIf
                
                set_align_y_( *this\text, *this\_rows( )\text, *this\scroll_height( ), *this\text\rotate )
              Else ; horizontal
                If *this\text\rotate = 180
                  *this\_rows( )\y - ( *this\height[#__c_inner] - *this\scroll_height( ) )
                EndIf
                
                ; changed
                If *this\text\rotate = 90
                  *this\_rows( )\text\y = 0
                ElseIf *this\text\rotate = 180
                  *this\_rows( )\text\y = Bool( #PB_Compiler_OS = #PB_OS_MacOS ) * 2 + Bool( #PB_Compiler_OS = #PB_OS_Linux ) + *this\_rows( )\text\height
                Else
                  *this\_rows( )\text\y = - Bool( #PB_Compiler_OS = #PB_OS_MacOS )
                EndIf
                
                set_align_x_( *this\text, *this\_rows( )\text, *this\scroll_width( ), *this\text\rotate )
              EndIf
              
              
              If *this\_rows( )\TextChange( ) <> 0
                ; edit_sel_update_( *this )
                
                *this\_rows( )\TextChange( ) = 0
              EndIf
            Next
          EndIf
        EndIf
        
        If *this\TextChange( )
          bar_area_update( *this )
          
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\text )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\text )
          
          ;           ; This is for the caret and scroll
          ;           ; when entering the key - ( enter & backspace )
          ;           If *this\scroll\v
          ;             edit_text_*this\scroll_y( )
          ;           EndIf
          ;           If *this\scroll\h
          ;             edit_text_*this\scroll_x( )
          ;           EndIf
          
          
          ; vertical bar one before displaying
          If *this\scroll\v And Not *this\scroll\v\bar\ThumbChange( )
            If *this\scroll\v\bar\max > *this\scroll\v\bar\page\len
              If *this\text\align\bottom
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end )
                  Bar_Update( *this\scroll\v )
                  ;                   Bar_Resize( *this\scroll\v\bar )
                EndIf
                
              ElseIf Not *this\text\align\top
                If Bar_Change( *this\scroll\v, *this\scroll\v\bar\page\end / 2 )
                  Bar_Update( *this\scroll\v )
                  ;                   Bar_Resize( *this\scroll\v\bar )
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; horizontal bar one before displaying
          If *this\scroll\h And Not *this\scroll\h\bar\ThumbChange( )
            If *this\scroll\h\bar\max > *this\scroll\h\bar\page\len
              If *this\text\align\right
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end )
                  Bar_Update( *this\scroll\h )
                  ;                   Bar_Resize( *this\scroll\h\bar )
                EndIf
                
              ElseIf Not *this\text\align\left
                If Bar_Change( *this\scroll\h, *this\scroll\h\bar\page\end / 2 )
                  Bar_Update( *this\scroll\h )
                  ;                   Bar_Resize( *this\scroll\h\bar )
                EndIf
              EndIf
            EndIf
          EndIf
          
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure Editor_Draw( *this._S_widget )
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT, Text_Y, Text_x, x, Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Make output multi line text
          If *this\TextChange( )
            Text_Update( *this )
            
            ;             If *this\EnteredLineIndex( ) >= 0
            ;               Debug " key - update draw lines"
            ;             Else
            ;               Debug " edit update draw lines"
            ;             EndIf
          EndIf
          
          ;;;;;;;;;;;;;;;;;;;;
          If *this\state\create
            edit_make_text_position( *this )
            ;             *this\scroll\v\hide = 0
            ;             *this\scroll\h\hide = 0
            ; Debug *this\class +" "+ *this\class
            ;If *this\state\repaint
            ;EndIf
            *this\state\create = 0
          EndIf
          ;
          ; then change text update cursor pos
          If *this\text\editable
            If *this\EnteredLineIndex( ) >= 0
              If Not ( *this\FocusedRow( ) And *this\FocusedRow( )\index = *this\EnteredLineIndex( ) )
                *this\FocusedRow( ) = SelectElement( *this\_rows( ), *this\EnteredLineIndex( ) )
              EndIf
              Debug "----- " + *this\text\string
              Debug "    key - change caret pos " + ListSize( *this\_rows( ) ) + " " + *this\FocusedRow( )\index + " " + *this\PressedLineIndex( )
              
              ;
              edit_sel_row_text_( *this, *this\FocusedRow( ) )
              edit_sel_text_( *this, *this\FocusedRow( ) )
              
              ;
              ; edit_make_text_position( *this )
              ;               ;bar_area_update( *this )
              ;               make_scrollarea_x( *this, *this\text )
              ;               If *this\scroll\h And
              ;                  bar_SetState( *this\scroll\h, -*this\scroll_x( ) )
              ;               EndIf
              
              If *this\scroll\v And Not *this\scroll\v\hide
                If *this\FocusedRow( )\y + *this\scroll_y( ) < 0 Or
                   *this\FocusedRow( )\y + *this\FocusedRow( )\height + *this\scroll_y( ) > *this\height[#__c_inner]
                  
                  If *this\FocusedRow( )\y + *this\scroll_y( ) < 0
                    Debug "       key - scroll ^"
                  ElseIf *this\FocusedRow( )\y + *this\FocusedRow( )\height + *this\scroll_y( ) > *this\height[#__c_inner]
                    Debug "       key - scroll v"
                  EndIf
                  
                  ;row_scroll_y_( *this, *this\FocusedRow( ) )
                  bar_scroll_pos_( *this\scroll\v, *this\text\caret\y, *this\text\caret\height ) ; ok
                EndIf
              EndIf
              
              If *this\scroll\h And Not *this\scroll\h\hide
                If *this\text\caret\x + *this\scroll_x( ) < 0 Or
                   *this\text\caret\x + *this\text\caret\width + *this\scroll_x( ) > *this\width[#__c_inner]
                  
                  If *this\text\caret\x + *this\scroll_x( ) < 0
                    Debug "       key - scroll <"
                  ElseIf *this\text\caret\x + *this\text\caret\width + *this\scroll_x( ) > *this\width[#__c_inner]
                    Debug "       key - scroll >"
                  EndIf
                  
                  ; bar_scroll_pos_( *this\scroll\h, (*this\text\caret\x - *this\text\padding\x), ( *this\text\padding\x * 2 + *this\row\margin\width )) ; ok
                  bar_scroll_pos_( *this\scroll\h, *this\text\caret\x, *this\text\caret\width ) ; ok
                EndIf
              EndIf
              
              
              *this\EnteredLineIndex( ) = - 1
            EndIf
          EndIf
          
          ; Draw back color
          ;         If *this\color\fore[\color\state]
          ;           drawing_mode_( #PB_2DDrawing_Gradient )
          ;           draw_gradient_( *this\text\vertical, *this,\color\fore[\color\state],\color\back[\color\state], [#__c_frame] )
          ;         Else
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\back[0] )
          ;         EndIf
          
          ; Draw margin back color
          If *this\row\margin\width > 0
            If ( *this\TextChange( ) Or *this\resize )
              *this\row\margin\x      = *this\x[#__c_inner]
              *this\row\margin\y      = *this\y[#__c_inner]
              *this\row\margin\height = *this\height[#__c_inner]
            EndIf
            
            ; Draw margin
            drawing_mode_alpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
            draw_box_( *this\row\margin\x, *this\row\margin\y, *this\row\margin\width, *this\row\margin\height, *this\row\margin\color\back )
          EndIf
          
          ; widget inner coordinate
          ix      = *this\x[#__c_inner] + *this\row\margin\width
          iY      = *this\y[#__c_inner]
          iwidth  = *this\width[#__c_inner]
          iheight = *this\height[#__c_inner]
          
          
          Protected result, scroll_x, scroll_y, scroll_x_, scroll_y_
          Protected visible_items_y.l = 0, visible_items_height
          
          If *this\scroll\v
            scroll_y_ = *this\scroll\v\bar\page\pos
          EndIf
          
          If *this\scroll\h
            scroll_x_ = *this\scroll\h\bar\page\pos
          EndIf
          scroll_x = *this\scroll_x( )
          scroll_y = *this\scroll_y( )
          
          ; Debug ""+ scroll_x +" "+ scroll_x_ +" "+ scroll_y +" "+ scroll_y_
          
          
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
          
          ; Draw Lines text
          If *this\count\items
            *this\VisibleFirstRow( ) = 0
            *this\VisibleLastRow( )  = 0
            
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
                
                
                
                
                
                
                
                Y      = row_y_( *this, *this\_rows( ) ) + scroll_y
                Text_x = row_x_( *this, *this\_rows( ) ) + *this\_rows( )\text\x + scroll_x
                Text_Y = row_y_( *this, *this\_rows( ) ) + *this\_rows( )\text\y + scroll_y
                
                Protected sel_text_x1 = edit_row_edit_text_x_( *this, [1] ) + scroll_x
                Protected sel_text_x2 = edit_row_edit_text_x_( *this, [2] ) + scroll_x
                Protected sel_text_x3 = edit_row_edit_text_x_( *this, [3] ) + scroll_x
                
                Protected sel_x = *this\x[#__c_inner] + *this\text\x
                Protected sel_width = *this\width[#__c_inner] - *this\text\y * 2
                
                Protected text_sel_state_2 = 0;2 + Bool( *this\state\focus = #False )
                Protected text_sel_width = *this\_rows( )\text\edit[2]\width + Bool( *this\state\focus = #False ) * *this\text\caret\width
                
                ;                 ;                 If *this\PressedRow( ) = *this\_rows( );Keyboard( )\key And *this\_rows( )\color\state
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
                  
                  Protected text_enter_state = Bool( *this\_rows( )\color\state Or *this\_rows( ) = *this\PressedRow( ))
                  ;Bool( *this\_rows( ) = *this\EnteredRow( ) ); *this\_rows( )\color\state ; Bool( *this\_rows( )\color\state = 1 Or *this\_rows( ) = *this\PressedRow( ))
                  
                  ; text_enter_state = Bool(*this\_rows( ) = *this\FocusedRow( )) ; *this\_rows( )\color\state ; Bool( *this\_rows( )\color\state ) ; Bool( *this\_rows( )\index = *this\EnteredRow( )\index ) + Bool( *this\_rows( )\index = *this\EnteredRow( )\index And *this\state\focus = #False )*2
                  ; Draw entered selection
                  If text_enter_state = 1
                    If *this\_rows( )\color\back[text_enter_state] <> - 1              ; no draw transparent
                      drawing_mode_alpha_( #PB_2DDrawing_Default )
                      draw_roundbox_( sel_x, Y, sel_width , *this\_rows( )\height, *this\_rows( )\round, *this\_rows( )\round, *this\_rows( )\color\back[text_enter_state] )
                    EndIf
                    
                    If *this\_rows( )\color\frame[text_enter_state] <> - 1 ; no draw transparent
                      drawing_mode_alpha_( #PB_2DDrawing_Outlined )
                      draw_roundbox_( sel_x, Y, sel_width , *this\_rows( )\height, *this\_rows( )\round, *this\_rows( )\round, *this\_rows( )\color\frame[text_enter_state] )
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
                    If ( ( *this\EnteredRow( ) And *this\PressedRow( ) And *this\EnteredRow( )\index > *this\PressedRow( )\Index ) Or
                         ( *this\EnteredRow( ) = *this\PressedRow( ) And *this\edit_caret_1( ) > *this\edit_caret_2( ) ))
                      
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
                  DrawRotatedText( *this\_rows( )\margin\x + Bool( *this\text\vertical ) * scroll_x,
                                   *this\_rows( )\margin\y + Bool( Not *this\text\vertical ) * scroll_y,
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
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, $FF0000FF )
            If *this\round : draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame] - 1, *this\width[#__c_frame], *this\height[#__c_frame] + 2, *this\round, *this\round, $FF0000FF ) : EndIf  ; Сглаживание краев ) ))
          ElseIf *this\bs
            drawing_mode_( #PB_2DDrawing_Outlined )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\frame[\color\state] )
            If *this\round : draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame] - 1, *this\width[#__c_frame], *this\height[#__c_frame] + 2, *this\round, *this\round, *this\color\front[\color\state] ) : EndIf  ; Сглаживание краев ) ))
          EndIf
          
          If *this\TextChange( ) : *this\TextChange( ) = 0 : EndIf
          If *this\WidgetChange( ) : *this\WidgetChange( ) = 0 : EndIf
          ;;;If *this\resize : *this\resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure Editor_Events_Key( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Static _caret_last_pos_, DoubleClick.i
      Protected i.i, caret.i
      
      Protected Repaint.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\_rows( )\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
      Protected page_height = *this\height[#__c_inner]
      
      With *this
        Select EventType
          Case #__event_Input ;- Input ( key )
            If Not Keyboard( )\key[1] & #PB_Canvas_Control
              If Not *this\notify And Keyboard( )\input
                
                edit_insert_text( *this, Chr( Keyboard( )\input ))
                
              EndIf
            EndIf
            
          Case #__event_KeyUp
            ; Чтобы перерисовать
            ; рамку вокруг едитора
            ; reset all errors
            If *this\notify
              *this\notify = 0
              ProcedureReturn - 1
            EndIf
            
            
          Case #__event_KeyDown
            Select Keyboard( )\key
              Case #PB_Shortcut_Home
                Repaint = edit_key_home_( *this )
                
              Case #PB_Shortcut_End
                Repaint = edit_key_end_( *this )
                
              Case #PB_Shortcut_PageUp : Debug "key PageUp"
                Repaint = edit_key_page_up_down_( *this, - 1, 1 )
                
              Case #PB_Shortcut_PageDown : Debug "key PageDown"
                Repaint = edit_key_page_up_down_( *this, 1, 1 )
                
              Case #PB_Shortcut_Up       ; Ok
                If *this\FocusedRow( ) And *this\edit_caret_1( ) > 0
                  If keyboard( )\key[1] & #PB_Canvas_Shift
                    If *this\FocusedRow( ) = *this\PressedRow( )
                      ;Debug " le top remove - Pressed  " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_first )
                      edit_sel_text_( *this, *this\FocusedRow( ))
                    ElseIf *this\FocusedRow( )\index > *this\PressedRow( )\index
                      ;Debug "  le top remove - " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_remove )
                      edit_sel_text_( *this, SelectElement(*this\_rows( ), *this\FocusedRow( )\index - 1))
                    Else
                      ;Debug " ^le bottom  set - " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_set )
                      edit_sel_text_( *this, *this\FocusedRow( ))
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Alt
                    *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
                    *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
                  Else
                    If *this\FocusedRow( )\index > 0
                      *this\FocusedRow( )\color\state = #__s_0
                      *this\FocusedRow( )             = SelectElement( *this\_rows( ), *this\FocusedRow( )\index - 1 )
                      *this\FocusedRow( )\color\state = #__s_1
                      
                      If *this\edit_caret_0( ) > *this\FocusedRow( )\text\len
                        *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                      Else
                        *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\edit_caret_0( )
                      EndIf
                    Else
                      *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                    edit_sel_reset_( *this )
                    
                    If *this\PressedRow( ) <> *this\FocusedRow( )
                      If *this\PressedRow( ) And
                         *this\PressedRow( )\state\press
                        *this\PressedRow( )\state\press = #False
                      EndIf
                      *this\PressedRow( )             = *this\FocusedRow( )
                      *this\PressedRow( )\state\press = #True
                    EndIf
                    
                    *this\edit_caret_2( ) = *this\edit_caret_1( )
                  EndIf
                  
                  edit_sel_row_text_( *this, *this\FocusedRow( ) )
                  edit_sel_text_( *this, *this\FocusedRow( ) )
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                If *this\FocusedRow( ) And *this\edit_caret_1( ) < *this\text\len
                  If keyboard( )\key[1] & #PB_Canvas_Shift
                    If *this\FocusedRow( ) = *this\PressedRow( )
                      ;Debug " le bottom  set - Pressed  " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_last )
                      edit_sel_text_( *this, *this\FocusedRow( ))
                    ElseIf *this\FocusedRow( )\index < *this\PressedRow( )\index
                      ;Debug "  ^le top remove - " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_remove )
                      edit_sel_text_( *this, SelectElement(*this\_rows( ), *this\FocusedRow( )\index + 1))
                    Else
                      ;Debug " le bottom  set - " +" "+ *this\FocusedRow( )\text\string
                      edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_set )
                      edit_sel_text_( *this, *this\FocusedRow( ))
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Alt
                    *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                    *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
                  Else
                    If *this\FocusedRow( )\index < ( *this\count\items - 1 )
                      *this\FocusedRow( )\color\state = #__s_0
                      *this\FocusedRow( )             = SelectElement( *this\_rows( ), *this\FocusedRow( )\index + 1 )
                      *this\FocusedRow( )\color\state = #__s_1
                      
                      If *this\edit_caret_0( ) > *this\FocusedRow( )\text\len
                        *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                      Else
                        *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\edit_caret_0( )
                      EndIf
                    Else
                      *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                    edit_sel_reset_( *this )
                    
                    If *this\PressedRow( ) <> *this\FocusedRow( )
                      If *this\PressedRow( ) And
                         *this\PressedRow( )\state\press
                        *this\PressedRow( )\state\press = #False
                      EndIf
                      *this\PressedRow( )             = *this\FocusedRow( )
                      *this\PressedRow( )\state\press = #True
                    EndIf
                    
                    *this\edit_caret_2( ) = *this\edit_caret_1( )
                  EndIf
                  
                  edit_sel_row_text_( *this, *this\FocusedRow( ) )
                  edit_sel_text_( *this, *this\FocusedRow( ) )
                EndIf
                
              Case #PB_Shortcut_Left     ; Ok
                If *this\FocusedRow( ) And *this\edit_caret_1( ) > 0
                  If *this\edit_caret_1( ) > *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                    *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                  EndIf
                  
                  If *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos
                    If *this\FocusedRow( )\index > 0
                      *this\FocusedRow( )\color\state = #__s_0
                      *this\FocusedRow( )             = SelectElement( *this\_rows( ), *this\FocusedRow( )\index - 1 )
                      *this\FocusedRow( )\color\state = #__s_1
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Alt
                    *this\edit_caret_1( ) = edit_sel_start_word( *this, *this\edit_caret_0( ) - 1, *this\FocusedRow( ) )
                  Else
                    *this\edit_caret_1( ) - 1
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                    edit_sel_reset_( *this )
                    
                    *this\edit_caret_2( ) = *this\edit_caret_1( )
                  EndIf
                  
                  *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
                  
                  edit_sel_row_text_( *this, *this\FocusedRow( ) )
                  edit_sel_text_( *this, *this\FocusedRow( ) )
                EndIf
                
              Case #PB_Shortcut_Right    ; Ok
                If *this\FocusedRow( ) And *this\edit_caret_1( ) < *this\text\len
                  If *this\edit_caret_1( ) > *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                    *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                  EndIf
                  
                  If *this\edit_caret_1( ) = *this\FocusedRow( )\text\pos + *this\FocusedRow( )\text\len
                    If *this\FocusedRow( )\index < *this\count\items - 1
                      
                      If keyboard( )\key[1] & #PB_Canvas_Shift
                        If *this\FocusedRow( ) = *this\PressedRow( )
                          ;Debug " le bottom  set - Pressed  " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_last )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        ElseIf *this\FocusedRow( )\index < *this\PressedRow( )\index
                          ;Debug "  ^le top remove - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_remove )
                          edit_sel_text_( *this, SelectElement(*this\_rows( ), *this\FocusedRow( )\index + 1))
                        Else
                          ;Debug " le bottom  set - " +" "+ *this\FocusedRow( )\text\string
                          edit_sel_row_text_( *this, *this\FocusedRow( ), #__sel_to_set )
                          edit_sel_text_( *this, *this\FocusedRow( ))
                        EndIf
                      EndIf
                      
                      *this\FocusedRow( )\color\state = #__s_0
                      *this\FocusedRow( )             = SelectElement( *this\_rows( ), *this\FocusedRow( )\index + 1 )
                      *this\FocusedRow( )\color\state = #__s_1
                    EndIf
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Alt
                    *this\edit_caret_1( ) = edit_sel_stop_word( *this, *this\edit_caret_0( ) + 1, *this\FocusedRow( ) )
                  Else
                    *this\edit_caret_1( ) + 1
                  EndIf
                  
                  If keyboard( )\key[1] & #PB_Canvas_Shift = #False
                    edit_sel_reset_( *this )
                    
                    *this\edit_caret_2( ) = *this\edit_caret_1( )
                  EndIf
                  
                  *this\edit_caret_0( ) = *this\edit_caret_1( ) - *this\FocusedRow( )\text\pos
                  
                  edit_sel_row_text_( *this, *this\FocusedRow( ) )
                  edit_sel_text_( *this, *this\FocusedRow( ) )
                EndIf
                
              Case #PB_Shortcut_Back
                If Not *this\notify
                  Repaint = edit_key_backup_( *this )
                EndIf
                
              Case #PB_Shortcut_Delete
                If Not *this\notify
                  Repaint = edit_key_delete_( *this )
                EndIf
                
              Case #PB_Shortcut_Return
                If Not *this\notify
                  Repaint = edit_key_return_( *this )
                EndIf
                
                
              Case #PB_Shortcut_A        ; Ok
                If Keyboard( )\key[1] & #PB_Canvas_Control
                  If *this\text\edit[2]\len <> *this\text\len
                    
                    ; select first and last items
                    *this\PressedLineIndex( ) = *this\count\items - 1
                    *this\FocusedRow( )       = SelectElement( *this\_rows( ), 0 )
                    
                    edit_sel_text_( *this, #PB_All )
                    
                    Repaint = 1
                  EndIf
                EndIf
                
              Case #PB_Shortcut_C, #PB_Shortcut_X
                If Keyboard( )\key[1] & #PB_Canvas_Control
                  If *this\text\edit[2]\len
                    SetClipboardText( *this\text\edit[2]\string )
                    
                    If Keyboard( )\key = #PB_Shortcut_X
                      edit_ClearItems( *this )
                    EndIf
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
                    
                    edit_insert_text( *this, Text )
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
                  *this\notify = - 1
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
    
    Procedure Editor_Events( *this._S_widget, eventtype.l, *item._S_rows, item = - 1 )
      Static DoubleClick.i = -1
      Protected Repaint.i, Caret.i, _line_.l, String.s
      Protected *currentRow._S_rows, mouse_x.l = mouse( )\x, mouse_y.l = mouse( )\y
      Static click_time
      
      
      With *this
        
        If *this\row
          ; edit key events
          If eventtype = #__event_Input Or
             eventtype = #__event_KeyDown Or
             eventtype = #__event_KeyUp
            
            Repaint | Editor_Events_Key( *this, eventtype, mouse( )\x, mouse( )\y )
          EndIf
        EndIf
        
      EndWith
      
      If *this\TextChange( )
        *this\WidgetChange( ) = 1
      EndIf
      
      If Repaint
        ; *this\state\repaint = #True
        PushListPosition( *this\_rows( ) )
        ; DoEvents( *this, #__event_StatusChange);, 0, 0 )
        
        If *this\TextChange( )
          DoEvents( *this, #__event_Change);, 0, 0 )
        EndIf
        PopListPosition( *this\_rows( ) )
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;-
    Declare tt_close( *this._S_tt )
    
    Procedure tt_tree_Draw( *this._S_tt, *color._S_color = 0 )
      With *this
        If *this And PB(IsGadget)( *this\gadget ) And StartDrawing( CanvasOutput( *this\gadget ))
          If Not *color
            *color = *this\color
          EndIf
          
          ;_draw_font_( *this )
          If *this\text\fontID
            DrawingFont( *this\text\fontID )
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_( 0, 1, *this\width, *this\height - 2, *color\back[*color\state] )
          drawing_mode_( #PB_2DDrawing_Transparent )
          DrawText( *this\text\x, *this\text\y, *this\text\string, *color\front[*color\state] )
          drawing_mode_( #PB_2DDrawing_Outlined )
          Line( 0, 0, *this\width, 1, *color\frame[*color\state] )
          Line( 0, *this\height - 1, *this\width, 1, *color\frame[*color\state] )
          Line( *this\width - 1, 0, 1, *this\height, *color\frame[*color\state] )
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
    
    Procedure tt_creare( *this._S_widget, x, y )
      With *this
        If *this
          EventWidget( ) = *this
          *this\row\_tt.allocate( TT )
          *this\row\_tt\visible = 1
          *this\row\_tt\x       = x + *this\_rows( )\x + *this\_rows( )\width - 1
          *this\row\_tt\y       = y + *this\_rows( )\y - *this\scroll\v\bar\page\pos
          
          *this\row\_tt\width = *this\_rows( )\text\width - *this\width[#__c_inner] + ( *this\_rows( )\text\x - *this\_rows( )\x ) + 5 ; - ( *this\scroll_width( ) - *this\_rows( )\width )  ; - 32 + 5
          
          If *this\row\_tt\width < 6
            *this\row\_tt\width = 0
          EndIf
          
          ;Debug *this\row\_tt\width ;Str( *this\_rows( )\text\x - *this\_rows( )\x )
          
          *this\row\_tt\height = *this\_rows( )\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          *this\row\_tt\window = OpenWindow( #PB_Any, *this\row\_tt\x, *this\row\_tt\y, *this\row\_tt\width, *this\row\_tt\height, "",
                                             #PB_Window_BorderLess | #PB_Window_NoActivate | flag, WindowID( *this\_root( )\canvas\window ))
          
          *this\row\_tt\gadget      = CanvasGadget( #PB_Any, 0, 0, *this\row\_tt\width, *this\row\_tt\height )
          *this\row\_tt\color       = *this\_rows( )\color
          *this\row\_tt\text        = *this\_rows( )\text
          *this\row\_tt\text\fontID = *this\_rows( )\text\fontID
          *this\row\_tt\text\x      = - ( *this\width[#__c_inner] - ( *this\_rows( )\text\x - *this\_rows( )\x )) + 1
          *this\row\_tt\text\y      = ( *this\_rows( )\text\y - *this\_rows( )\y ) + *this\scroll\v\bar\page\pos
          
          BindEvent( #PB_Event_ActivateWindow, @tt_tree_callBack( ), *this\row\_tt\window )
          SetWindowData( *this\row\_tt\window, *this\row\_tt )
          tt_tree_Draw( *this\row\_tt )
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
    ;-  TREE
    Procedure.l update_items_( *this._S_widget, _change_ = 1 )
      Protected state.b, x.l, y.l
      
      With *this
        If Not *this\hide
          ;\\ update coordinate
          If _change_ > 0
            ; Debug "   " + #PB_Compiler_Procedure + "( )"
            If Not Drawing( )
              Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
            EndIf
            
            ;\\ if the item list has changed
            *this\scroll_width( ) = 0
            If ListSize( *this\columns( ) )
              *this\scroll_height( ) = *this\columns( )\height
            Else
              *this\scroll_height( ) = 0
            EndIf
            
            ; reset item z - order
            Protected buttonpos = 6
            Protected buttonsize = 9
            Protected boxpos = 4
            Protected boxsize = 11
            Protected bs = Bool( *this\fs )
            
            ;\\
            PushListPosition( *this\_rows( ))
            ForEach *this\_rows( )
              *this\_rows( )\index = ListIndex( *this\_rows( ))
              
              If *this\_rows( )\hide
                *this\_rows( )\visible = 0
              Else
                ;\\ drawing item font
                draw_font_item_( *this, *this\_rows( ), *this\_rows( )\TextChange( ) )
                
                ;\\ draw items height
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
                
                *this\_rows( )\y = *this\scroll_height( )
                
                If *this\row\column = 0
                  ;\\ check box size
                  If ( *this\mode\check = #__m_checkselect Or
                       *this\mode\check = #__m_optionselect )
                    *this\_rows( )\checkbox\width  = boxsize
                    *this\_rows( )\checkbox\height = boxsize
                  EndIf
                  
                  ;\\ collapse box size
                  If ( *this\mode\lines Or *this\mode\buttons ) And
                     Not ( *this\_rows( )\sublevel And *this\mode\check = #__m_optionselect )
                    *this\_rows( )\collapsebox\width  = buttonsize
                    *this\_rows( )\collapsebox\height = buttonsize
                  EndIf
                  
                  ;\\ sublevel position
                  *this\row\sublevelpos = *this\_rows( )\sublevel * *this\row\sublevelsize + Bool( *this\mode\check ) * (boxpos + boxsize) + Bool( *this\mode\lines Or *this\mode\buttons ) * ( buttonpos + buttonsize )
                  
                  ;\\ check & option box position
                  If ( *this\mode\check = #__m_checkselect Or
                       *this\mode\check = #__m_optionselect )
                    
                    If *this\_rows( )\ParentRow( ) And *this\mode\check = #__m_optionselect
                      *this\_rows( )\checkbox\x = *this\row\sublevelpos - *this\_rows( )\checkbox\width
                    Else
                      *this\_rows( )\checkbox\x = boxpos
                    EndIf
                    *this\_rows( )\checkbox\y = ( *this\_rows( )\height ) - ( *this\_rows( )\height + *this\_rows( )\checkbox\height ) / 2
                  EndIf
                  
                  ;\\ expanded & collapsed box position
                  If ( *this\mode\lines Or *this\mode\buttons ) And Not ( *this\_rows( )\sublevel And *this\mode\check = #__m_optionselect )
                    
                    If *this\mode\check = #__m_optionselect
                      *this\_rows( )\collapsebox\x = *this\row\sublevelpos - 10
                    Else
                      *this\_rows( )\collapsebox\x = *this\row\sublevelpos - (( buttonpos + buttonsize ) - 4)
                    EndIf
                    
                    *this\_rows( )\collapsebox\y = ( *this\_rows( )\height ) - ( *this\_rows( )\height + *this\_rows( )\collapsebox\height ) / 2
                  EndIf
                  
                  ;\\ image position
                  If *this\_rows( )\image\id
                    *this\_rows( )\image\x = *this\row\sublevelpos + *this\image\padding\x + 2
                    *this\_rows( )\image\y = ( *this\_rows( )\height - *this\_rows( )\image\height ) / 2
                    
                    If *this\type = #__type_ListIcon
                      *this\row\sublevelpos = *this\_rows( )\image\x
                    EndIf
                  Else
                    If *this\type = #__type_ListIcon
                      ;*this\row\sublevelpos = *this\_rows( )\x
                    EndIf
                  EndIf
                  
                EndIf
                
                If *this\row\column = 0
                  *this\_rows( )\x = *this\columns( )\x
                Else
                  *this\_rows( )\x = *this\columns( )\x + *this\row\sublevelpos + *this\row\margin\width
                EndIf
                
                ;\\ text position
                If *this\_rows( )\text\string
                  If *this\row\column > 0
                    *this\_rows( )\text\x = *this\text\padding\x
                  Else
                    *this\_rows( )\text\x = *this\row\sublevelpos + *this\row\margin\width + *this\text\padding\x
                  EndIf
                  *this\_rows( )\text\y = ( *this\_rows( )\height - *this\_rows( )\text\height ) / 2
                EndIf
                
                ;\\ vertical scroll max value
                *this\scroll_height( ) + *this\_rows( )\height + Bool( *this\_rows( )\index <> *this\count\items - 1 ) * *this\mode\GridLines
                
                ;\\ horizontal scroll max value
                If *this\type = #__type_ListIcon
                  If *this\scroll_width( ) < ( *this\row\sublevelpos + *this\text\padding\x + *this\row\margin\width + *this\columns( )\x + *this\columns( )\width )
                    *this\scroll_width( ) = ( *this\row\sublevelpos + *this\text\padding\x + *this\row\margin\width + *this\columns( )\x + *this\columns( )\width )
                  EndIf
                Else
                  If *this\scroll_width( ) < ( *this\_rows( )\x + *this\_rows( )\text\x + *this\_rows( )\text\width + *this\mode\fullSelection + *this\text\padding\x * 2 ) ; - *this\x[#__c_inner]
                    *this\scroll_width( ) = ( *this\_rows( )\x + *this\_rows( )\text\x + *this\_rows( )\text\width + *this\mode\fullSelection + *this\text\padding\x * 2 )  ; - *this\x[#__c_inner]
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition( *this\_rows( ))
            
            ;\\
            If *this\mode\gridlines
              ; *this\scroll_height( ) - *this\mode\gridlines
            EndIf
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
      
      
      ForEach *this\_rows( )
        *this\_rows( )\visible = Bool( Not *this\_rows( )\hide And
                                       (( *this\_rows( )\y - scroll_y ) < visible_items_y + visible_items_height ) And
                                       ( *this\_rows( )\y + *this\_rows( )\height - scroll_y ) > visible_items_y )
        
        ;;Debug ""+*this\class +" "+ visible_items_height  +" "+ *this\_rows( )\height
        
        ;\\ add new draw list
        If *this\_rows( )\visible And
           AddElement( *this\VisibleRows( ))
          *this\VisibleRows( ) = *this\_rows( )
          
          ;\\
          If *this\row\column = 0
            If ListSize( *This\Columns( ) ) = 1
              *this\columns( )\width = *this\width[#__c_inner] - *this\columns( )\x
              *this\_rows( )\width   = *this\columns( )\width
            Else
              *this\_rows( )\width = *this\columns( )\width + *this\row\sublevelpos + *this\row\margin\width
            EndIf
          Else
            ;\\
            If *this\_rows( )\width <> *this\columns( )\width
              *this\_rows( )\width = *this\columns( )\width
            EndIf
          EndIf
          
          ;\\
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
    
    Procedure.l draw_items_( *this._S_widget, List *rows._S_rows( ), _scroll_x_, _scroll_y_ )
      Protected state.b, x.l, y.l, xs.l, ys.l, _box_x_.l, _box_y_.l, minus.l = 7
      Protected bs = Bool( *this\fs )
      
      ;
      ; Clip( *this, [#__c_draw2] ) ; 2
      
      ;\\
      PushListPosition( *rows( ))
      ForEach *rows( )
        If *rows( )\visible
          ;\\
          state = *rows( )\color\state
          X     = row_x_( *this, *rows( ) )
          Y     = row_y_( *this, *rows( ) )
          Xs    = x - _scroll_x_
          Ys    = y - _scroll_y_
          
          ;\\ init real drawing font
          draw_font_item_( *this, *rows( ), 0 )
          
          ;\\ Draw selector back
          If *rows( )\color\back[state]
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            If *this\flag & #__Flag_FullSelection
              draw_roundbox_( *this\x[#__c_inner], ys, *this\width[#__c_inner], *rows( )\height, *rows( )\round, *rows( )\round, *rows( )\color\back[state] )
            Else
              draw_roundbox_( x, ys, *rows( )\width, *rows( )\height, *rows( )\round, *rows( )\round, *rows( )\color\back[state] )
            EndIf
          EndIf
          
          ;\\ Draw items image
          If *rows( )\image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *rows( )\image\id, xs + *rows( )\image\x, ys + *rows( )\image\y, *rows( )\color\_alpha )
          EndIf
          
          ;\\ Draw items text
          If *rows( )\text\string.s
            drawing_mode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( xs + *rows( )\text\x, ys + *rows( )\text\y, *rows( )\text\string.s, *this\text\rotate, *rows( )\color\front[state] )
          EndIf
          
          ;\\ Draw selector frame
          If *rows( )\color\frame[state]
            drawing_mode_( #PB_2DDrawing_Outlined )
            If *this\flag & #__Flag_FullSelection
              draw_roundbox_( *this\x[#__c_inner], ys, *this\width[#__c_inner], *rows( )\height, *rows( )\round, *rows( )\round, *rows( )\color\frame[state] )
            Else
              draw_roundbox_( x, ys, *rows( )\width, *rows( )\height, *rows( )\round, *rows( )\round, *rows( )\color\frame[state] )
            EndIf
          EndIf
          
          ;\\ Horizontal line
          If *this\mode\GridLines And
             ;*rows( )\color\line And
            *rows( )\color\line <> *rows( )\color\back
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_box_( x, ys + *rows( )\height, *rows( )\width, *this\mode\GridLines, $fff0f0f0 )
          EndIf
        EndIf
      Next
      
      
      ;           drawing_mode_alpha_( #PB_2DDrawing_Default ); | #PB_2DDrawing_AlphaBlend )
      ;          draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevelsize, *this\height[#__c_inner], *this\_rows( )\ParentRow( )\color\back )
      
      If *this\row\column = 0
        ;         SelectElement( *this\columns( ), 0 )
        ;         *rows( ) = *this\_rows( )
        Protected._S_buttons *collapsebox
        
        ; Draw plots
        If *this\mode\lines
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          ; drawing_mode_( #PB_2DDrawing_CustomFilter ) : CustomFilterCallback( @Draw_Plot( ))
          
          ForEach *rows( )
            If *rows( )\visible And Not *rows( )\hide
              *collapsebox = *rows( )\last\collapsebox
              Xs           = row_x_( *this, *rows( ) ) - _scroll_x_
              Ys           = row_y_( *this, *rows( ) ) - _scroll_y_
              ; Debug " 9999 "+*rows( )\text\string
              
              ; for the tree vertical line
              If *rows( )\last And Not *rows( )\last\hide And *rows( )\last\sublevel
                Line((xs + *collapsebox\x + *collapsebox\width / 2), (ys + *rows( )\height), 1, (*rows( )\last\y - *rows( )\y) - *rows( )\last\height / 2, *rows( )\color\line )
              EndIf
              If *rows( )\ParentRow( ) And Not *rows( )\ParentRow( )\visible And *rows( )\ParentRow( )\last = *rows( ) And *rows( )\sublevel
                Line((xs + *rows( )\collapsebox\x + *rows( )\collapsebox\width / 2), (*rows( )\ParentRow( )\y + *rows( )\ParentRow( )\height) - _scroll_y_, 1, (*rows( )\y - *rows( )\ParentRow( )\y) - *rows( )\height / 2, *rows( )\ParentRow( )\color\line )
              EndIf
              
              ; for the tree horizontal line
              If Not (*this\mode\buttons And *rows( )\childrens)
                Line((xs + *rows( )\collapsebox\x + *rows( )\collapsebox\width / 2), (ys + *rows( )\height / 2), 7, 1, *rows( )\color\line )
              Else
                If Bool( Not *rows( )\collapsebox\state\check)
                  ;  LineXY((xs + *collapsebox\x+2), (ys + 9), (x + *collapsebox\x + *collapsebox\width / 2-1), ys + *rows( )\height-1, *rows( )\color\line )
                  LineXY((xs + *collapsebox\x - 1), (ys + 10), (xs + *collapsebox\x + *collapsebox\width / 2 - 1), ys + *rows( )\height - 1, *rows( )\color\line )
                  ;  LineXY((xs + *collapsebox\x-2), (ys + 12), (x + *collapsebox\x + *collapsebox\width / 2-1), ys + *rows( )\height-1, *rows( )\color\line )
                EndIf
              EndIf
            EndIf
          Next
          
          ; for the tree item first vertical line
          If *this\row\first And *this\row\last
            Line((*this\x[#__c_inner] + *this\row\first\collapsebox\x + *this\row\first\collapsebox\width / 2) - _scroll_x_, (row_y_( *this, *this\row\first ) + *this\row\first\height / 2) - _scroll_y_, 1, (*this\row\last\y - *this\row\first\y), *this\row\first\color\line )
          EndIf
        EndIf
        
        ;\\ Draw buttons
        If *this\mode\buttons Or
           ( *this\mode\check = #__m_checkselect Or *this\mode\check = #__m_optionselect )
          
          ;\\ Draw boxs ( check&option )
          ForEach *rows( )
            If *rows( )\visible And *this\mode\check
              X = row_x_( *this, *rows( ) ) - _scroll_x_
              Y = row_y_( *this, *rows( ) ) - _scroll_y_
              
              If *rows( )\ParentRow( ) And *this\mode\check = #__m_optionselect
                ; option box
                draw_button_( 1, x + *rows( )\checkbox\x, y + *rows( )\checkbox\y, *rows( )\checkbox\width, *rows( )\checkbox\height, *rows( )\checkbox\state\check , 4 )
              Else
                ; check box
                draw_button_( 3, x + *rows( )\checkbox\x, y + *rows( )\checkbox\y, *rows( )\checkbox\width, *rows( )\checkbox\height, *rows( )\checkbox\state\check , 2 )
              EndIf
            EndIf
          Next
          
          ;drawing_mode_alpha_( #PB_2DDrawing_Outlined ); | #PB_2DDrawing_AlphaBlend )
          ; Draw buttons ( expanded&collapsed )
          ForEach *rows( )
            If *rows( )\visible And Not *rows( )\hide
              
              X = row_x_( *this, *rows( ) ) + *rows( )\collapsebox\x - _scroll_x_
              Y = row_y_( *this, *rows( ) ) + *rows( )\collapsebox\y - _scroll_y_
              
              If *this\mode\buttons And *rows( )\childrens And
                 Not ( *rows( )\sublevel And *this\mode\check = #__m_optionselect )
                
                ;               If #PB_Compiler_OS = #PB_OS_Windows Or
                ;                  (*rows( )\ParentRow( ) And *rows( )\ParentRow( )\last And *rows( )\ParentRow( )\sublevel = *rows( )\ParentRow( )\last\sublevel)
                ;
                ;                 draw_button_( 0, x, y, *rows( )\collapsebox\width, *rows( )\collapsebox\height, 0,2)
                ;                 draw_box( *rows( )\collapsebox, color\frame )
                ;
                ;                 Line(x + 2, y + *rows( )\collapsebox\height/2, *rows( )\collapsebox\width - 4, 1, $ff000000)
                ;                 If *rows( )\collapsebox\state\check
                ;                   Line(x + *rows( )\collapsebox\width/2, y + 2, 1, *rows( )\collapsebox\height - 4, $ff000000)
                ;                 EndIf
                ;
                ;               Else
                
                
                If (x - 7 >= 0 And x + 7 <= *this\_root( )\width) And ; в мак ос эти строки не нужны так как plot( ) может рисовать за пределамы границы
                   (y - 7 >= 0 And y + 7 <= *this\_root( )\height)
                  
                  If *rows( )\color\state
                    DrawArrow2(x, y, 3 - Bool(*rows( )\collapsebox\state\check))
                  Else
                    DrawArrow2(x, y, 3 - Bool(*rows( )\collapsebox\state\check), $ff000000)
                  EndIf
                EndIf
                
                ;               EndIf
                
              EndIf
            EndIf
          Next
        EndIf
      Else
        ;Debug 777777
      EndIf
      ;
      PopListPosition( *rows( )) ;
      
    EndProcedure
    
    Procedure.l Tree_Draw( *this._S_widget )
      Protected state.b, x.l, y.l, scroll_x, scroll_y
      
      If Not *this\hide
        If *this\WidgetChange( ) = - 2 : *this\WidgetChange( ) = 1 : EndIf
        If *this\WidgetChange( ) = - 1 : *this\WidgetChange( ) = 1 : EndIf
        
        ;;Debug " "+*this\WidgetChange( )
        update_items_( *this, *this\WidgetChange( ) )
        ;;Debug "   "+*this\WidgetChange( )
        
        
        ;\\
        If *this\WidgetChange( ) > 0
          ; Debug "   " + #PB_Compiler_Procedure + "( )"+*this\width +" "+*this\height+" "+*this\scroll_width( )+" "+*this\scroll_height( )
          bar_area_update( *this )
          *this\WidgetChange( ) = - 2
        EndIf
        
        ;\\ SetState( scroll-to-see )
        If *this\FocusedRow( ) And *this\scroll\state = - 1
          
          row_scroll_y_( *this, *this\FocusedRow( ) )
          
          *this\scroll\v\change = 0
          *this\scroll\state    = #True
        EndIf
        
        ;\\
        If *this\WidgetChange( ) < 0
          ; reset draw list
          ClearList( *this\VisibleRows( ))
          *this\VisibleFirstRow( ) = 0
          *this\VisibleLastRow( )  = 0
          
          update_visible_items_( *this )
        EndIf
        
        
        ;\\ Draw background
        If *this\color\_alpha
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;draw_roundbox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back);[*this\color\state] )
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\back )
        EndIf
        
        ;\\ Draw background image
        If *this\image\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image\id, *this\image\x, *this\image\y, *this\color\_alpha )
        EndIf
        
        ;\\
        draw_items_( *this, *this\VisibleRows( ), *this\scroll\h\bar\page\pos, *this\scroll\v\bar\page\pos )
        
        ;\\ draw frames
        If *this\bs
          drawing_mode_( #PB_2DDrawing_Outlined )
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state] )
          If *this\round : draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame] - 1, *this\width[#__c_frame], *this\height[#__c_frame] + 2, *this\round, *this\round, *this\color\front[*this\color\state] ) : EndIf  ; Сглаживание краев ) ))
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure.i Tree_AddItem( *this._S_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0 )
      Protected *rows._S_rows, last, *last_row._S_rows, *parent_row._S_rows
      ; sublevel + 1
      
      ;With *this
      If *this
        
        ;         If IsImage(Image) Or *this\mode\check
        ;               If *this\row\sublevelcolumn = 0
        ;                 *this\row\sublevelcolumn = 1
        ;                 Debug 88888
        ;                 AddColumn( *this, 0, "N", 50 )
        ;                ; *this\row\column = 1
        ;               EndIf
        ;             EndIf
        
        
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
              *this\row\added = *this\_rows( )
              ;;NextElement( *this\_rows( ))
            Else
              last     = *this\row\added
              sublevel = *this\_rows( )\sublevel
            EndIf
            PopListPosition( *this\_rows( ))
          Else
            last     = *this\row\added
            sublevel = *this\_rows( )\sublevel
          EndIf
          
          *rows = InsertElement( *this\_rows( ))
        EndIf
        ;}
        
        If *rows
          *rows\index = position ; ListIndex( *this\_rows( ) )
          
          If sublevel > position
            sublevel = position
          EndIf
          
          If *this\row\added
            If sublevel > *this\row\added\sublevel
              sublevel    = *this\row\added\sublevel + 1
              *parent_row = *this\row\added
              
            ElseIf *this\row\added\ParentRow( )
              If sublevel > *this\row\added\ParentRow( )\sublevel
                *parent_row = *this\row\added\ParentRow( )
                
              ElseIf sublevel < *this\row\added\sublevel
                If *this\row\added\ParentRow( )\ParentRow( )
                  *parent_row = *this\row\added\ParentRow( )\ParentRow( )
                  
                  While *parent_row
                    If sublevel >= *parent_row\sublevel
                      If sublevel = *parent_row\sublevel
                        *parent_row = *parent_row\ParentRow( )
                      EndIf
                      Break
                    Else
                      *parent_row = *parent_row\ParentRow( )
                    EndIf
                  Wend
                EndIf
                
                ; for the editor( )
                If *this\row\added\ParentRow( )
                  If *this\row\added\ParentRow( )\sublevel = sublevel
                    ;                     *rows\before = *this\row\added\ParentRow( )
                    ;                     *this\row\added\ParentRow( )\after = *rows
                    
                    If *this\type = #__type_Editor
                      *parent_row      = *this\row\added\ParentRow( )
                      *parent_row\last = *rows
                      *this\row\added  = *parent_row
                      last             = *parent_row
                    EndIf
                    
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          If *parent_row
            *parent_row\childrens + 1
            *rows\ParentRow( ) = *parent_row
          EndIf
          
          If sublevel
            *rows\sublevel = sublevel
          EndIf
          
          If last
            ; *this\row\added = last
          Else
            *this\row\added = *rows
          EndIf
          
          ; for the tree( )
          If *this\row\added\ParentRow( ) And
             *this\row\added\ParentRow( )\sublevel < sublevel
            *this\row\added\ParentRow( )\last = *this\row\added
          EndIf
          
          If *this\row\added\sublevel = 0
            *this\row\last = *this\row\added
          EndIf
          
          If position = 0
            *this\row\first = *rows
          EndIf
          
          If *this\mode\collapsed And *rows\ParentRow( ) And
             *rows\sublevel > *rows\ParentRow( )\sublevel
            *rows\ParentRow( )\collapsebox\state\check = 1
            *rows\hide                                 = 1
          EndIf
          
          ; properties
          If *this\flag & #__tree_property
            If *parent_row And Not *parent_row\sublevel And Not *parent_row\text\fontID
              *parent_row\color\back     = $FFF9F9F9
              *parent_row\color\back[1]  = *parent_row\color\back
              *parent_row\color\back[2]  = *parent_row\color\back
              *parent_row\color\frame    = *parent_row\color\back
              *parent_row\color\frame[1] = *parent_row\color\back
              *parent_row\color\frame[2] = *parent_row\color\back
              *parent_row\color\front[1] = *parent_row\color\front
              *parent_row\color\front[2] = *parent_row\color\front
              *parent_row\text\fontID    = FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic ))
            EndIf
          EndIf
          
          ; add lines
          *rows\color       = _get_colors_( )
          *rows\color\state = 0
          *rows\color\back  = 0
          *rows\color\frame = 0
          
          *rows\color\fore[0] = 0
          *rows\color\fore[1] = 0
          *rows\color\fore[2] = 0
          *rows\color\fore[3] = 0
          
          If Text
            *rows\TextChange( ) = 1
            *rows\text\string   = StringField( Text.s, *this\row\column + 1, #LF$);Chr(9) )
                                                                                  ;*rows\text\edit\string = StringField( Text.s, 2, #LF$ )
          EndIf
          
          ;\\
          If *this\row\column = 0
            *this\count\items + 1
            *this\WidgetChange( ) = 1
            set_image_( *this, *rows\Image, Image )
            
            If *this\FocusedRow( )
              *this\FocusedRow( )\state\focus = 0
              *this\FocusedRow( )\color\state = #__S_0
              
              *this\FocusedRow( )             = *rows
              *this\FocusedRow( )\state\focus = 1
              *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
            
            If *this\scroll\state = #True
              *this\scroll\state = - 1
            EndIf
            
          EndIf
        EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *this\count\items - 1
    EndProcedure
    
    Procedure.l Tree_events_Key( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected result, from = - 1
      Static cursor_change, Down, *rows_selected._S_rows
      
      With *this
        Select eventtype
          Case #__event_KeyDown
            
            Select Keyboard( )\key
              Case #PB_Shortcut_PageUp
                If bar_SetState( *this\scroll\v, 0 )
                  *this\WidgetChange( ) = 1
                  result                = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\end )
                  *this\WidgetChange( ) = 1
                  result                = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\FocusedRow( )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - 18 )
                      *this\WidgetChange( ) = 1
                      result                = 1
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
                      *this\FocusedRow( )             = *this\_rows( )
                      *this\_rows( )\color\state      = 2
                      *rows_selected                  = *this\_rows( )
                      
                      If *this\_rows( )\y + *this\scroll_y( ) <= 0
                        If row_scroll_y_( *this, *this\FocusedRow( ) )
                          *this\WidgetChange( ) = - 1
                        EndIf
                      EndIf
                      
                      Post( *this, #__event_Change, *this\_rows( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\FocusedRow( )
                  If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                     ( Keyboard( )\key[1] & #PB_Canvas_Control )
                    
                    If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + 18 )
                      *this\WidgetChange( ) = 1
                      result                = 1
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
                      *this\FocusedRow( )             = *this\_rows( )
                      *this\_rows( )\color\state      = 2
                      *rows_selected                  = *this\_rows( )
                      
                      If *this\_rows( )\y >= *this\height[#__c_inner]
                        If row_scroll_y_( *this, *this\FocusedRow( ) )
                          *this\WidgetChange( ) = - 1
                        EndIf
                      EndIf
                      
                      Post( *this, #__event_Change, *this\_rows( )\index )
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  If bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end / 10 ))
                    *this\WidgetChange( ) = 1
                  EndIf
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  If bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end / 10 ))
                    *this\WidgetChange( ) = 1
                  EndIf
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
      If eventtype = #__event_LeftButtonDown
        If *this\EnteredRow( )
          
          ; collapsed/expanded button
          If *this\EnteredRow( )\childrens And
             is_at_point_( *this\EnteredRow( )\collapsebox, mouse_x - *this\EnteredRow( )\x, mouse_y - *this\EnteredRow( )\y )
            
            If *this\EnteredRow( )\collapsebox\state\check
              Repaint | SetItemState( *this, *this\EnteredRow( )\index, #PB_Tree_Expanded )
            Else
              Repaint | SetItemState( *this, *this\EnteredRow( )\index, #PB_Tree_Collapsed )
            EndIf
          Else
            ; change box ( option&check )
            If is_at_point_( *this\EnteredRow( )\checkbox, mouse_x - *this\EnteredRow( )\x, mouse_y - *this\EnteredRow( )\y )
              ; change box option
              If *this\mode\check = #__m_optionselect
                If *this\EnteredRow( )\ParentRow( ) And *this\EnteredRow( )\OptionGroupRow
                  If *this\EnteredRow( )\OptionGroupRow\ParentRow( ) And
                     *this\EnteredRow( )\OptionGroupRow\checkbox\state\check
                    *this\EnteredRow( )\OptionGroupRow\checkbox\state\check = #PB_Checkbox_Unchecked
                  EndIf
                  
                  If *this\EnteredRow( )\OptionGroupRow\OptionGroupRow <> *this\EnteredRow( )
                    If *this\EnteredRow( )\OptionGroupRow\OptionGroupRow
                      *this\EnteredRow( )\OptionGroupRow\OptionGroupRow\checkbox\state\check = #PB_Checkbox_Unchecked
                    EndIf
                    *this\EnteredRow( )\OptionGroupRow\OptionGroupRow = *this\EnteredRow( )
                  EndIf
                EndIf
              EndIf
              
              ; tree checkbox change check
              set_check_state_( *this\EnteredRow( )\checkbox, *this\mode\threestate )
              
              ;
              If *this\EnteredRow( )\color\state = #__S_2
                Post( *this, #__event_Change, *this\EnteredRow( )\index )
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
                *this\FocusedRow( )             = *this\EnteredRow( )
                *this\EnteredRow( )\state\press = #True
              EndIf
            EndIf
            
            ; set draw color state
            If *this\EnteredRow( )\state\press = #True
              ;               If *this\EnteredRow( )\color\state <> #__S_2
              ;                 *this\EnteredRow( )\color\state = #__S_2
              ;
              ;                 Post( *this, #__event_Change, *this\EnteredRow( )\index )
              ;
              ;               EndIf
            Else
              *this\EnteredRow( )\color\state = #__S_1
            EndIf
          EndIf
          
          ; Repaint = #True
        EndIf
      EndIf
      
      If eventtype = #__event_LeftButtonUp
        If *this\EnteredRow( ) And
           *this\EnteredRow( )\state\enter
          
          If *this\EnteredRow( )\color\state = #__S_0
            *this\EnteredRow( )\color\state = #__S_1
            
            ; Post event item status change
            Post( *this, #__event_StatusChange, *this\EnteredRow( )\index )
            ; Repaint = #True
          Else
            If *this\EnteredRow( )\childrens And
               is_at_point_( *this\EnteredRow( )\collapsebox,
                             mouse_x + *this\scroll\h\bar\page\pos - *this\EnteredRow( )\x,
                             mouse_y + *this\scroll\v\bar\page\pos - *this\EnteredRow( )\y )
              
              Post( *this, #__event_Up, *this\EnteredRow( )\index )
            Else
              ;;;;;Post( *this, #__event_LeftClick, *this\EnteredRow( )\index )
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If eventtype = #__event_RightButtonUp Or
         eventtype = #__event_LeftDoubleClick
        
        Post( *this, eventtype, WidgetEvent( )\item )
        Repaint | #True
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
    Macro set_state_list_( _address_, _state_ )
      If _state_ > 0
        If *this\mode\check = #__m_clickselect
          If _address_\state\enter = #False
            _address_\state\enter = #True
          EndIf
        Else
          If _address_\state\press = #False
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
        
        If _address_\state\press = #False
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
    
    
    Procedure.l ListView_Events( *this._S_widget, eventtype.l, *item._S_rows, item = - 1 )
      Protected Repaint, mouse_x.l = mouse( )\x, mouse_y.l = mouse( )\y
      
      ;- widget::ListView_Events_Key
      If eventtype = #__event_KeyDown
        Protected *current._S_rows
        Protected result, from = - 1
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
                  *this\FocusedRow( )  = *current
                EndIf
                
                Post( *this, #__event_Change, *current\index )
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageUp
              ; TODO scroll to first visible
              If bar_SetState( *this\scroll\v, 0 )
                *this\WidgetChange( ) = 1
                Repaint               = 1
              EndIf
              
            Case #PB_Shortcut_PageDown
              ; TODO scroll to last visible
              If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\end )
                *this\WidgetChange( ) = 1
                Repaint               = 1
              EndIf
              
            Case #PB_Shortcut_Up,
                 #PB_Shortcut_Home
              
              If *current
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  ; scroll to top
                  If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - 18 )
                    *this\WidgetChange( ) = 1
                    Repaint               = 1
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
                    If row_scroll_y_( *this, *current )
                      *this\WidgetChange( ) = - 1
                    EndIf
                    Post( *this, #__event_Change, *current\index )
                    Repaint = 1
                  EndIf
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Down,
                 #PB_Shortcut_End
              
              If *current
                If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                   ( Keyboard( )\key[1] & #PB_Canvas_Control )
                  
                  If bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + 18 )
                    *this\WidgetChange( ) = 1
                    Repaint               = 1
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
                    If row_scroll_y_( *this, *current )
                      *this\WidgetChange( ) = - 1
                    EndIf
                    Post( *this, #__event_Change, *current\index )
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Left
              If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( Keyboard( )\key[1] & #PB_Canvas_Control )
                
                If bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - ( *this\scroll\h\bar\page\end / 10 ))
                  *this\WidgetChange( ) = 1
                EndIf
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Right
              If ( Keyboard( )\key[1] & #PB_Canvas_Alt ) And
                 ( Keyboard( )\key[1] & #PB_Canvas_Control )
                
                If bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + ( *this\scroll\h\bar\page\end / 10 ))
                  *this\WidgetChange( ) = 1
                EndIf
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
    Procedure Window_Update( *this._S_widget )
      If *this\type = #__type_window
        ; чтобы закруглять только у окна с титлебаром
        If *this\fs[2]
          If *this\round
            *this\caption\round = *this\round
            *this\round         = 0
          EndIf
        EndIf
        
        ; caption title bar
        If Not *this\caption\hide
          *this\caption\x     = *this\x[#__c_frame]
          *this\caption\y     = *this\y[#__c_frame]
          *this\caption\width = *this\width[#__c_frame] ; - *this\fs*2
          
          *this\caption\height = *this\barHeight + *this\fs - 1
          If *this\caption\height > *this\height[#__c_frame] - *this\fs ;*2
            *this\caption\height = *this\height[#__c_frame] - *this\fs  ;*2
          EndIf
          
          ;
          *this\caption\x[#__c_inner]      = *this\caption\x + *this\fs
          *this\caption\y[#__c_inner]      = *this\caption\y + *this\fs
          *this\caption\width[#__c_inner]  = *this\caption\width - *this\fs * 2
          *this\caption\height[#__c_inner] = *this\caption\height - *this\fs * 2
          
          ; caption close button
          If Not *this\caption\button[#__wb_close]\hide
            *this\caption\button[#__wb_close]\x = ( *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] ) - ( *this\caption\button[#__wb_close]\width + *this\caption\_padding )
            *this\caption\button[#__wb_close]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_close]\height ) / 2
          EndIf
          
          ; caption maximize button
          If Not *this\caption\button[#__wb_maxi]\hide
            If *this\caption\button[#__wb_close]\hide
              *this\caption\button[#__wb_maxi]\x = ( *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] ) - ( *this\caption\button[#__wb_maxi]\width + *this\caption\_padding )
            Else
              *this\caption\button[#__wb_maxi]\x = *this\caption\button[#__wb_close]\x - ( *this\caption\button[#__wb_maxi]\width + *this\caption\_padding )
            EndIf
            *this\caption\button[#__wb_maxi]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_maxi]\height ) / 2
          EndIf
          
          ; caption minimize button
          If Not *this\caption\button[#__wb_mini]\hide
            If *this\caption\button[#__wb_maxi]\hide
              *this\caption\button[#__wb_mini]\x = *this\caption\button[#__wb_close]\x - ( *this\caption\button[#__wb_mini]\width + *this\caption\_padding )
            Else
              *this\caption\button[#__wb_mini]\x = *this\caption\button[#__wb_maxi]\x - ( *this\caption\button[#__wb_mini]\width + *this\caption\_padding )
            EndIf
            *this\caption\button[#__wb_mini]\y = *this\caption\y + ( *this\caption\height - *this\caption\button[#__wb_mini]\height ) / 2
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
    
    Procedure Window_Draw( *this._S_widget )
      Protected caption_height = *this\caption\height - *this\fs
      
      With *this
        ; чтобы закруглять только у окна с титлебаром
        Protected gradient = 1
        Protected r = 9
        
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        
        If *this\fs And *this\round And Not *this\fs[2]
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\caption\color\back[\color\state] )
        EndIf
        
        ; Draw back
        If *this\color\back[\interact * *this\color\state]
          If *this\fs > *this\round / 3 And *this\round
            draw_box_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\color\back[\interact * *this\color\state] )
          Else
            If *this\round
              draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\back[\interact * *this\color\state] )
            Else
              draw_roundbox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back[\interact * *this\color\state] )
            EndIf
          EndIf
        EndIf
        
        If gradient And Not *this\round
          drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          BackColor( *this\color\fore[\color\state] & $FFFFFF | 255 << 24 )
          FrontColor( *this\color\frame[\color\state] & $FFFFFF | 255 << 24 )
        EndIf
        
        If *this\fs[2] And Not *this\round
          Protected ch = *this\fs[2]
          If Not *this\round
            ch = *this\fs[2] - 1             ; (*this\fs+*this\fs[2])/2
          EndIf
          
          ; top
          If gradient
            LinearGradient( *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame], *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame] + (*this\fs[2] + *this\fs) * 2)
          EndIf
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs[2] + *this\fs, r, r, *this\color\frame[\color\state] )
          
          If *this\fs[2]
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs[2] + *this\fs, r, r, *this\color\frame[\color\state] )
          EndIf
          
          If gradient
            drawing_mode_alpha_( #PB_2DDrawing_Gradient )
            BackColor( *this\color\fore[\color\state] & $FFFFFF | 255 << 24 )
            FrontColor( *this\color\frame[\color\state] & $FFFFFF | 255 << 24 )
            LinearGradient( *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame], *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame] + (*this\fs[2] + *this\fs) * 2)
          EndIf
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame] + *this\fs[2] - r, *this\width[#__c_frame], r + *this\fs, *this\color\frame[\color\state] )
        EndIf
        
        ; Draw frame
        If *this\fs > 0
          If Not gradient
            drawing_mode_alpha_( #PB_2DDrawing_Default )
          EndIf
          If Not *this\round
            If *this\fs = 1
              gradient = 0
            EndIf
            ; left
            If gradient
              LinearGradient( *this\x[#__c_frame] + *this\fs * 2, *this\y[#__c_frame] + *this\fs + ch, *this\x[#__c_frame] - *this\fs, *this\y[#__c_frame] + *this\fs + ch )
            EndIf
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame] + *this\fs + ch, *this\fs, *this\height[#__c_frame] - *this\fs * 2 - ch, *this\color\frame[\color\state] )
            ; right
            If gradient
              LinearGradient( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs * 2, *this\y[#__c_frame] + *this\fs + ch, *this\x[#__c_frame] + *this\width[#__c_frame] + *this\fs, *this\y[#__c_frame] + *this\fs + ch )
            EndIf
            draw_box_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs, *this\y[#__c_frame] + *this\fs + ch, *this\fs, *this\height[#__c_frame] - *this\fs * 2 - ch, *this\color\frame[\color\state] )
            ; bottom
            If gradient
              LinearGradient( *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs * 2, *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame] + *this\height[#__c_frame] + *this\fs )
            EndIf
            draw_box_( *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs, *this\width[#__c_frame] - *this\fs * 2, *this\fs, *this\color\frame[\color\state] )
            
            ; left&bottom
            If gradient
              BoxedGradient(*this\x[#__c_frame], *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs * 2, *this\fs * 2, *this\fs * 2)
            EndIf
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs, *this\fs, *this\fs, *this\color\frame[\color\state] )
            
            ; right&bottom
            If gradient
              BoxedGradient(*this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs * 2, *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs * 2, *this\fs * 2, *this\fs * 2)
            EndIf
            draw_box_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs, *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs, *this\fs, *this\fs, *this\color\frame[\color\state] )
            
          EndIf
        EndIf
        
        If *this\fs[2] Or (*this\fs > *this\round / 3 And *this\round) Or Not *this\round
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          ; inner top
          Line( *this\x[#__c_frame] + *this\fs + *this\fs[1], *this\y[#__c_frame] + *this\fs + *this\fs[2] - 1, *this\width[#__c_frame] - *this\fs[1] - *this\fs[3] - *this\fs * 2, 1, *this\color\frame[\color\state] )
          If *this\fs
            ; inner bottom
            Line( *this\x[#__c_frame] + *this\fs + *this\fs[1], *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs[4] - *this\fs, *this\width[#__c_frame] - *this\fs[1] - *this\fs[3] - *this\fs * 2, 1, *this\color\frame[\color\state] )
            ; inner left
            Line( *this\x[#__c_frame] + *this\fs + *this\fs[1] - 1, *this\y[#__c_frame] + *this\fs + *this\fs[2], 1, *this\height[#__c_frame] - *this\fs[2] - *this\fs[4] - *this\fs * 2, *this\color\frame[\color\state] )
            ; inner right
            Line( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs[3] - *this\fs, *this\y[#__c_frame] + *this\fs + *this\fs[2], 1, *this\height[#__c_frame] - *this\fs[2] - *this\fs[4] - *this\fs * 2, *this\color\frame[\color\state] )
          EndIf
        Else
          If *this\round
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\caption\color\back[\color\state] )
          EndIf
        EndIf
        
        If Not *this\round
          If Not *this\fs[2]
            ; left&top
            draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\fs, *this\fs, *this\color\frame[\color\state] )
            ; top
            draw_box_( *this\x[#__c_frame] + *this\fs, *this\y[#__c_frame], *this\width[#__c_frame] - *this\fs * 2, *this\fs, *this\color\frame[\color\state] )
            ; right&top
            draw_box_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs, *this\y[#__c_frame], *this\fs, *this\fs, *this\color\frame[\color\state] )
          EndIf
          
          If *this\fs
            ; frame bottom
            Line( *this\x[#__c_frame], *this\y[#__c_frame] + *this\height[#__c_frame] - 1, *this\width[#__c_frame], 1, *this\color\frame[\color\state] )
            ; frame left
            Line( *this\x[#__c_frame], *this\y[#__c_frame] + *this\fs[2] - r, 1, *this\height[#__c_frame] - *this\fs[2] + r, *this\color\frame[\color\state] )
            ; frame right
            Line( *this\x[#__c_frame] + *this\width[#__c_frame] - 1, *this\y[#__c_frame] + *this\fs[2] - r, 1, *this\height[#__c_frame] - *this\fs[2] + r, *this\color\frame[\color\state] )
          ElseIf *this\fs[2]
            ; frame left
            Line( *this\x[#__c_frame], *this\y[#__c_frame] + *this\fs[2] - r, 1, r + *this\fs, *this\color\frame[\color\state] )
            ; frame right
            Line( *this\x[#__c_frame] + *this\width[#__c_frame] - 1, *this\y[#__c_frame] + *this\fs[2] - r, 1, r + *this\fs, *this\color\frame[\color\state] )
          EndIf
        EndIf
        
        ; then caption
        If *this\fs[2]
          ;                   ; Draw caption back
          ;                   If *this\caption\color\back
          ;                     drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          ;                     draw_gradient_( 0, *this\caption, *this\caption\color\fore[\color\state], *this\caption\color\back[\color\state] )
          ;                   EndIf
          ;
          ;                   ; Draw caption frame
          ;                   If *this\fs
          ;                     drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          ;                     draw_roundbox_( *this\caption\x, *this\caption\y, *this\caption\width, *this\fs + *this\fs[2], *this\caption\round, *this\caption\round, *this\color\frame[\color\state] )
          ;
          ;                     ; erase the bottom edge of the frame
          ;                     drawing_mode_alpha_( #PB_2DDrawing_Gradient )
          ;                     BackColor( *this\caption\color\fore[\color\state] )
          ;                     FrontColor( *this\caption\color\back[\color\state] )
          ;
          ;                     ;Protected i
          ;                     For i = 0 To *this\caption\round
          ;                       Line( *this\x[#__c_inner] - *this\fs + 1, *this\y[#__c_frame] + (*this\fs + *this\fs[2] - *this\caption\round) + i - 2, *this\width[#__c_frame] - 2, 1, *this\caption\color\back[\color\state] )
          ;                     Next
          ;
          ;                     ; two edges of the frame
          ;                     drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          ;                     Line( *this\x[#__c_frame], *this\y[#__c_frame] + *this\caption\round / 2 + 2, 1, caption_height - *this\caption\round / 2, *this\color\frame[\color\state] )
          ;                     Line( *this\x[#__c_frame] + *this\width[#__c_frame] - 1, *this\y[#__c_frame] + *this\caption\round / 2 + 2, 1, caption_height - *this\caption\round / 2, *this\color\frame[\color\state] )
          ;                   EndIf
          
          ; buttins background
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_button_( *this\caption\button[#__wb_close], color\back )
          draw_box_button_( *this\caption\button[#__wb_maxi], color\back )
          draw_box_button_( *this\caption\button[#__wb_mini], color\back )
          draw_box_button_( *this\caption\button[#__wb_help], color\back )
          
          ; buttons image
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          draw_close_button_( *this\caption\button[#__wb_close], 6 )
          draw_maximize_button_( *this\caption\button[#__wb_maxi], 4 )
          draw_minimize_button_( *this\caption\button[#__wb_mini], 4 )
          draw_help_button_( *this\caption\button[#__wb_help], 4 )
          
          ; Draw image
          If *this\image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *this\image\id,
                            *this\x[#__c_frame] + *this\bs + *this\scroll_x( ) + *this\image\x,
                            *this\y[#__c_frame] + *this\bs + *this\scroll_y( ) + *this\image\y - 2, *this\color\_alpha )
          EndIf
          
          If *this\caption\text\string
            _clip_caption_( *this )
            
            ; Draw string
            If *this\resize & #__resize_change
              If *this\image\id
                *this\caption\text\x = *this\caption\x[#__c_inner] + *this\caption\text\padding\x + *this\image\width + 10;\image\padding\x
              Else
                *this\caption\text\x = *this\caption\x[#__c_inner] + *this\caption\text\padding\x
              EndIf
              *this\caption\text\y = *this\caption\y[#__c_inner] + ( *this\caption\height[#__c_inner] - TextHeight( "A" )) / 2
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( *this\caption\text\x, *this\caption\text\y, *this\caption\text\string, *this\color\front[\color\state] & $FFFFFF | *this\color\_alpha << 24 )
            
            ;             drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            ;             draw_roundbox_( *this\caption\x[#__c_inner], *this\caption\y[#__c_inner], *this\caption\width[#__c_inner], *this\caption\height[#__c_inner], *this\round, *this\round, $FF000000 )
            Clip( *this, [#__c_draw] )
          EndIf
        EndIf
        
        ;Clip( *this, [#__c_draw2] )
        
        ; background image draw
        If *this\image[#__image_background]\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__image_background]\id,
                          *this\x[#__c_inner] + *this\image[#__image_background]\x,
                          *this\y[#__c_inner] + *this\image[#__image_background]\y, *this\color\_alpha )
        EndIf
        
        ;Clip( *this, [#__c_draw] )
        
        ; UnclipOutput( )
        ; drawing_mode_alpha_( #PB_2DDrawing_Outlined )
        ; draw_roundbox_( *this\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], round,round,$ff000000 )
        ; draw_roundbox_( *this\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], round,round,$ff000000 )
        
      EndWith
    EndProcedure
    
    Procedure Window_SetState( *this._S_widget, state.l )
      Protected.b result
      
      ; close state
      If state = #__Window_Close
        If Not Post( *this, #__event_CloseWindow )
          Free( *this )
          
          If is_root_(*this )
            PostEvent( #PB_Event_CloseWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; restore state
      If state = #__Window_Normal
        If Not Post( *this, #__event_restoreWindow )
          If *this\resize & #__resize_minimize
            *this\resize & ~ #__resize_minimize
            *this\caption\button[#__wb_close]\hide = 0
            *this\caption\button[#__wb_mini]\hide  = 0
          EndIf
          *this\resize & ~ #__resize_maximize
          *this\resize | #__resize_restore
          
          SetAlignment( *this, 0, 0, 0, 0, 0 )
          Resize( *this, *this\_root( )\x[#__c_restore], *this\_root( )\y[#__c_restore],
                  *this\_root( )\width[#__c_restore], *this\_root( )\height[#__c_restore] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_RestoreWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post( *this, #__event_MaximizeWindow )
          If Not *this\resize & #__resize_minimize
            *this\_root( )\x[#__c_restore]      = *this\x[#__c_container]
            *this\_root( )\y[#__c_restore]      = *this\y[#__c_container]
            *this\_root( )\width[#__c_restore]  = *this\width[#__c_frame]
            *this\_root( )\height[#__c_restore] = *this\height[#__c_frame]
          EndIf
          
          *this\resize | #__resize_maximize
          Resize( *this, 0, 0, *this\_parent( )\width[#__c_container], *this\_parent( )\height[#__c_container] )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MaximizeWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post( *this, #__event_MinimizeWindow )
          If Not *this\resize & #__resize_maximize
            *this\_root( )\x[#__c_restore]      = *this\x[#__c_container]
            *this\_root( )\y[#__c_restore]      = *this\y[#__c_container]
            *this\_root( )\width[#__c_restore]  = *this\width[#__c_frame]
            *this\_root( )\height[#__c_restore] = *this\height[#__c_frame]
          EndIf
          
          *this\caption\button[#__wb_close]\hide = 1
          If *this\caption\button[#__wb_maxi]\hide = 0
            *this\caption\button[#__wb_mini]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize( *this, *this\_root( )\x[#__c_restore], *this\_parent( )\height[#__c_container] - *this\fs[2], *this\_root( )\width[#__c_restore], *this\fs[2] )
          SetAlignment( *this, 0, 0, 0, 0, 1 )
          
          If is_root_(*this )
            PostEvent( #PB_Event_MinimizeWindow, *this\_root( )\canvas\window, *this )
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure Window_Events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l )
      Protected Repaint
      mouse_x = mouse( )\x
      mouse_y = mouse( )\y
      
      If eventtype = #__event_MouseMove
        If *this\state\press And Not *this\_a_\transform
          If *this = *this\_root( )\canvas\container
            ResizeWindow( *this\_root( )\canvas\window, ( DesktopMouseX( ) - mouse( )\delta\x ), ( DesktopMouseY( ) - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
          Else
            Repaint = Resize( *this, ( mouse_x - mouse( )\delta\x ), ( mouse_y - mouse( )\delta\y ), #PB_Ignore, #PB_Ignore )
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__event_LeftClick
        If *this\type = #__type_Window
          *this\caption\interact = is_at_point_( *this\caption, mouse_x, mouse_y, [2] )
          ;*this\color\state = 2
          
          Debug "" + #PB_Compiler_Procedure + " " + mouse_x + " " + *this\caption\button[#__wb_close]\x
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
    Procedure.l X( *this._S_widget, mode.l = #__c_frame )
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
    
    Procedure.b Update( *this._S_widget )
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Panel
        result = bar_Update( *this\TabBox( ) )
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
        
        result = bar_Update( *this )
      Else
        result = Bool( *this\resize & #__resize_change )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure ChangeParent( *this._S_widget, *parent._S_widget )
      ;\\
      *this\_parent( ) = *parent
      *this\_root( )   = *parent\_root( )
      
      ;\\
      If is_window_( *parent )
        *this\_window( ) = *parent
      Else
        *this\_window( ) = *parent\_window( )
      EndIf
      
      ;\\ is integrall scroll bars
      If *this\scroll
        If *this\scroll\v
          *this\scroll\v\_root( )   = *this\_root( )
          *this\scroll\v\_window( ) = *this\_window( )
        EndIf
        If *this\scroll\h
          *this\scroll\h\_root( )   = *this\_root( )
          *this\scroll\h\_window( ) = *this\_window( )
        EndIf
      EndIf
      
      ;\\ is integrall tab bar
      If *this\TabBox( )
        *this\TabBox( )\_root( )   = *this\_root( )
        *this\TabBox( )\_window( ) = *this\_window( )
      EndIf
      
      ;\\ is integrall string bar
      If *this\StringBox( )
        *this\StringBox( )\_root( )   = *this\_root( )
        *this\StringBox( )\_window( ) = *this\_window( )
      EndIf
    EndProcedure
    
    Procedure.i Display( *this._S_widget, *display._S_widget, x = #PB_Ignore, y = #PB_Ignore )
      Protected display_width
      Protected display_height
      Protected display_mode = 0
      
      *this\hide ! 1
      
      ;\\
      If *display\_box_
        If *this\hide = 0
          *display\_box_\arrow\direction = 3
        Else
          *display\_box_\arrow\direction = 2
        EndIf
      EndIf
      
      ;\\
      If x = #PB_Ignore
        x = GadgetX( *display\_root( )\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + *display\x
      EndIf
      If y = #PB_Ignore
        y = GadgetY( *display\_root( )\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + *display\y + *display\height
      EndIf
      
      ;\\
      If *this\hide
        PopupWidget( ) = #Null
      Else
        PopupWidget( ) = *this
        
        ;\\
        If *this\row
          If Not ( *this\_root( ) And
                   *this\_root( )\canvas\window <> *display\_root( )\canvas\window )
            
            Debug "display - update"
            ChangeParent( *this, *display )
            update_items_( *this )
          EndIf
        EndIf
        
        ;\\
        If *this\scroll And *this\scroll\v
          display_width = *this\scroll\v\width
        EndIf
        display_width + *this\scroll_width( )
        If display_width < *display\width
          display_width = *display\width
        EndIf
        If display_mode
          x = GadgetX( *display\_root( )\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + Mouse( )\x - display_width / 2
        EndIf
        ;\\
        If *this\row
          ForEach *this\_rows( )
            display_height + *this\_rows( )\height
            
            If display_mode
              If *this\_rows( )\state\focus
                y = GadgetY( *display\_root( )\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + ( Mouse( )\y - row_y_( *this, *this\_rows( ) ) - *this\_rows( )\height / 2 )
              EndIf
            EndIf
            
            If ( ListIndex(*this\_rows( )) + 1 ) >= 10
              Break
            EndIf
          Next
        Else
          display_height = *this\height
        EndIf
      EndIf
      
      ;\\
      If *this\_root( ) And *this\_root( )\canvas\window <> *display\_root( )\canvas\window
        If *this\hide
          Debug "display - hide"
          
          HideWindow( *this\_root( )\canvas\window, #True, #PB_Window_NoActivate )
        Else
          Debug "display - show"
          
          HideWindow( *this\_root( )\canvas\window, #False, #PB_Window_NoActivate )
          PostCanvasRepaint( *this )
        EndIf
      Else
        If Not *this\hide
          Protected window
          Protected *root._s_root
          Debug "display - create"
          
          *this\autosize = #True
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            window = OpenWindow( #PB_Any, 0, 0, 0, 0, "", #PB_Window_NoActivate | #PB_Window_BorderLess, WindowID( *display\_root( )\canvas\window ) )
            ;             If CocoaMessage(0, WindowID(window), "hasShadow") = 0
            CocoaMessage(0, WindowID(window), "setHasShadow:", 1)
            ;             EndIf
            ;             ;CocoaMessage(0, WindowID(*root\canvas\window), "borderless:", 1)
            ;             ; CocoaMessage(0, WindowID(*root\canvas\window), "styleMask") ; get
            ;CocoaMessage(0, WindowID(window), "setStyleMask:", #NSMiniaturizableWindowMask )
          CompilerElse
            window = OpenWindow( #PB_Any, 0, 0, 0, 0, "", #PB_Window_NoActivate | #PB_Window_BorderLess, WindowID( *display\_root( )\canvas\window ) )
          CompilerEndIf
          
          ; StickyWindow( window, #True )
          
          *root            = Open( window )
          *root\_parent( ) = *display
          ChangeParent( *this, *root )
          
          ChangeCurrentRoot( *display\_root( )\canvas\address )
        EndIf
      EndIf
      
      If Not *this\hide
        ;\\
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ; var windowLevel: UIWindow.Level { get set }
          CocoaMessage(0, WindowID(*this\_root( )\canvas\window), "setLevel:", 3) ; stay on top
                                                                                  ; Debug CocoaMessage(0, WindowID(*this\_root( )\canvas\window), "level")
        CompilerEndIf
        
        ;\\
        ; Resize( *this, 0, 0, display_width, display_height )
        ResizeWindow( *this\_root( )\canvas\window, x, y, display_width, display_height )
        ;  ResizeWindow( *this\_root( )\canvas\window, x+*display\round, y, display_width-*display\round*2, display_height )
        ProcedureReturn #True
      EndIf
    EndProcedure
    
    Procedure IsChild( *this._S_widget, *parent._S_widget )
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
                                      ; Until ( *this And *this = *this\_root( ) ) = #Null
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b IsContainer( *this._S_widget )
      ProcedureReturn *this\container
    EndProcedure
    
    
    Procedure.i GetItem( *this._S_widget, parent_sublevel.l = - 1 ) ;???
      Protected result
      Protected *rows._S_rows
      Protected *widget._S_widget
      
      If *this
        If parent_sublevel = - 1
          *widget = *this
          result  = *widget\TabIndex( )
          
        Else
          *rows = *this
          
          While *rows And *rows <> *rows\ParentRow( )
            
            If parent_sublevel = *rows\ParentRow( )\sublevel
              result = *rows
              Break
            EndIf
            
            *rows = *rows\ParentRow( )
          Wend
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.q FromPBFlag( Type, PBFlag.q )
      Protected flags.q = PBFlag
      
      Select Type
        Case #__type_CheckBox
          If PBFlag & #PB_CheckBox_Right = #PB_CheckBox_Right
            flags & ~ #PB_CheckBox_Right
            flags | #__text_right
          EndIf
          If PBFlag & #PB_CheckBox_Center = #PB_CheckBox_Center
            flags & ~ #PB_CheckBox_Center
            flags | #__text_center
          EndIf
          
        Case #__type_Text
          If PBFlag & #PB_Text_Center = #PB_Text_Center
            flags & ~ #PB_Text_Center
            flags | #__text_center
          EndIf
          If PBFlag & #PB_Text_Right = #PB_Text_Right
            flags & ~ #PB_Text_Right
            flags | #__text_right
          EndIf
          
        Case #__type_Button
          If PBFlag & #PB_Button_MultiLine
            flags & ~ #PB_Button_MultiLine
            flags | #__text_wordwrap
          EndIf
          If PBFlag & #PB_Button_Left = #PB_Button_Left
            flags & ~ #PB_Button_Left
            flags | #__text_left
          EndIf
          If PBFlag & #PB_Button_Right = #PB_Button_Right
            flags & ~ #PB_Button_Right
            flags | #__text_right
          EndIf
          
        Case #__type_Tree, #__type_listicon
          If PBFlag & #PB_Tree_AlwaysShowSelection = #PB_Tree_AlwaysShowSelection
            flags & ~ #PB_Tree_AlwaysShowSelection
          EndIf
          If PBFlag & #PB_Tree_CheckBoxes = #PB_Tree_CheckBoxes
            flags & ~ #PB_Tree_CheckBoxes
            flags | #__tree_checkboxes
          EndIf
          If PBFlag & #PB_Tree_ThreeState = #PB_Tree_ThreeState
            flags & ~ #PB_Tree_ThreeState
            flags | #__tree_threestate
          EndIf
          If PBFlag & #PB_Tree_NoButtons = #PB_Tree_NoButtons
            flags & ~ #PB_Tree_NoButtons
            flags | #__tree_nobuttons
          EndIf
          If PBFlag & #PB_Tree_NoLines = #PB_Tree_NoLines
            flags & ~ #PB_Tree_NoLines
            flags | #__tree_nolines
          EndIf
          
      EndSelect
      
      ProcedureReturn flags
    EndProcedure
    
    Procedure.q ToPBFlag( Type, Flag.q )
      Protected flags.q = Flag
      
      Select Type
        Case #__type_Button
          If Flag & #__text_wordwrap = #__text_wordwrap
            flags & ~ #__text_wordwrap
            flag | #PB_Button_MultiLine
          EndIf
          If Flag & #__text_left = #__text_left
            flags & ~ #__text_left
            flags | #PB_Button_Left
          EndIf
          If Flag & #__text_right = #__text_right
            flags & ~ #__text_right
            flags | #PB_Button_Right
          EndIf
      EndSelect
      
      ProcedureReturn flags
    EndProcedure
    
    Procedure.q Flag( *this._S_widget, flag.q = #Null, state.b = - 1 )
      Protected result.q
      
      ;\\ get widget flags
      If Not flag
        ;result = *this\flag
        result = ToPBFlag( *this\type, *this\flag )
      Else
        ;\\ replace pb flag
        flag = FromPBFlag( *this\type, flag )
        
        ;\\ is flag on the widget
        If state = - 1
          result = Bool( *this\flag & flag )
        Else
          *this\WidgetChange( ) = 1
          
          ;\\ set & remove flags
          If state
            *this\flag | flag
          Else
            *this\flag & ~ flag
          EndIf
          
          ;\\ text align
          If *this\type = #__type_Text Or
             *this\type = #__type_Editor Or
             *this\type = #__type_String Or
             *this\type = #__type_Button Or
             *this\type = #__type_Option Or
             *this\type = #__type_Hyperlink Or
             *this\type = #__type_CheckBox
            
            If flag & #__text_multiline
              *this\text\multiline = state
            EndIf
            
            If flag & #__text_wordwrap
              *this\text\multiline = - state
            EndIf
            
            If flag & #__text_vertical
              *this\text\vertical = state
            EndIf
            
            If flag & #__text_invert
              *this\text\invert = state
            EndIf
            
            If flag & #__text_left
              *this\text\align\left = state
              If Not state And *this\flag & #__text_right
                *this\text\align\right = #True
              EndIf
            EndIf
            
            If flag & #__text_right
              *this\text\align\right = state
              If Not state And *this\flag & #__text_left
                *this\text\align\left = #True
              EndIf
            EndIf
            
            If flag & #__text_top
              *this\text\align\top = state
              If Not state And *this\flag & #__text_bottom
                *this\text\align\bottom = #True
              EndIf
            EndIf
            
            If flag & #__text_bottom
              *this\text\align\bottom = state
              If Not state And *this\flag & #__text_top
                *this\text\align\top = #True
              EndIf
            EndIf
            
            If flag & #__text_center
              *this\text\align\left   = #False
              *this\text\align\top    = #False
              *this\text\align\right  = #False
              *this\text\align\bottom = #False
            EndIf
            
            ;\\
            If *this\type = #__type_Button
              If flag & #PB_Button_Toggle
                If state
                  *this\state\check = #True
                  *this\color\state = #__S_2
                Else
                  *this\state\check = #False
                  *this\color\state = #__S_0
                EndIf
              EndIf
              
              ;\\
              If *this\text\align\top = #True And
                 *this\text\align\bottom = #True
                *this\text\align\top    = #False
                *this\text\align\bottom = #False
              EndIf
              If *this\text\align\left = #True And
                 *this\text\align\right = #True
                *this\text\align\left  = #False
                *this\text\align\right = #False
              EndIf
            EndIf
            
            *this\TextChange( ) = #__text_update
          EndIf
          
          
          ;\\
          If *this\type = #__type_Tree Or
             *this\type = #__type_ListIcon Or
             *this\type = #__type_ListView Or
             *this\type = #__type_property
            
            If flag & #__tree_nolines
              *this\mode\lines = Bool( state )
            EndIf
            If flag & #__tree_nobuttons
              *this\mode\buttons = state
              
              If *this\count\items
                If *this\flag & #__tree_OptionBoxes
                  PushListPosition( *this\_rows( ))
                  ForEach *this\_rows( )
                    If *this\_rows( )\ParentRow( ) And
                       *this\_rows( )\ParentRow( )\childrens
                      *this\_rows( )\sublevel = state
                    EndIf
                  Next
                  PopListPosition( *this\_rows( ))
                EndIf
              EndIf
            EndIf
            
            
            If flag & #__tree_checkboxes = #__tree_checkboxes
              If *this\flag & #__tree_OptionBoxes
                *this\mode\check = Bool( state ) * #__m_optionselect
              Else
                *this\mode\check = Bool( state )
              EndIf
            EndIf
            
            If flag & #__tree_threestate
              *this\mode\threestate = Bool( *this\flag & #__tree_checkboxes )
            EndIf
            
            If flag & #__tree_clickselect = #__tree_clickselect
              ;Debug "#__tree_clickselect "+#__tree_clickselect +" "+#__tree_nobuttons +" "+ #__flag_nobuttons
              
              *this\mode\check = Bool( state ) * #__m_clickselect
            EndIf
            If flag & #__tree_multiselect = #__tree_multiselect
              *this\mode\check = Bool( state ) * #__m_multiselect
            EndIf
            If flag & #__tree_OptionBoxes
              If state
                *this\mode\check = #__m_optionselect
              Else
                *this\mode\check = Bool( *this\flag & #__tree_checkboxes )
              EndIf
              
              ; set option group
              If *this\count\items
                PushListPosition( *this\_rows( ))
                ForEach *this\_rows( )
                  If *this\_rows( )\ParentRow( )
                    *this\_rows( )\checkbox\state\check = #PB_Checkbox_Unchecked
                    *this\_rows( )\OptionGroupRow       = Bool( state ) * GetItem( *this\_rows( ), 0 )
                  EndIf
                Next
                PopListPosition( *this\_rows( ))
              EndIf
            EndIf
            If flag & #__flag_gridLines
              *this\mode\gridlines = state * 10
            EndIf
            If flag & #__tree_collapse
              *this\mode\collapsed = state
              
              If *this\count\items
                PushListPosition( *this\_rows( ))
                ForEach *this\_rows( )
                  If *this\_rows( )\ParentRow( )
                    *this\_rows( )\ParentRow( )\collapsebox\state\check = state
                    *this\_rows( )\hide                                 = state
                  EndIf
                Next
                PopListPosition( *this\_rows( ))
              EndIf
              
              If *this\_root( )
                ReDraw( *this )
              EndIf
            EndIf
            
            
            If ( *this\mode\lines Or *this\mode\buttons Or *this\mode\check ) And Not ( *this\flag & #__tree_property Or *this\flag & #__tree_OptionBoxes )
              *this\row\sublevelsize = 6;18
            Else
              *this\row\sublevelsize = 0
            EndIf
            
            If *this\count\items
              *this\WidgetChange( ) = 1
            EndIf
          EndIf
          
          ;           If flag & #__text_bottom
          ;             *this\ImageChange( )              = #__text_update
          ;             *this\image\align\top    = 0
          ;             *this\image\align\bottom = state
          ;           EndIf
          
          
          ; ;           If flag & #__text_right
          ; ;             *this\image\align\left  = 0
          ; ;             *this\ImageChange( )             = #__text_update
          ; ;             *this\image\align\right = state
          ; ;           EndIf
          
          
          
          ;\\
          If *this\TextChange( )
            text_rotate_( *this\text )
          EndIf
          
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    
    ;-
    Procedure.i AddColumn( *this._S_widget, position.l, text.s, width.l, image.i = -1 )
      Protected *columns._s_COLUMN
      
      ;\\ Генерируем идентификатор
      If position < 0 Or
         position > ListSize( *this\Columns( )) - 1
        LastElement( *this\Columns( ))
        *columns = AddElement( *this\Columns( ))
        
        If position < 0
          position = ListIndex( *this\Columns( ))
        EndIf
      Else
        ;\\
        *columns = SelectElement( *this\Columns( ), position )
        
        ;\\
        
        ;\\
        *columns = InsertElement( *this\Columns( ))
      EndIf
      
      ;\\
      *this\Columns( )\y     = 0
      *this\Columns( )\width = width
      
      ;\\
      If position = 0 And ListSize( *this\columns( ) ) > 1
        *this\scroll_width( ) = *this\Columns( )\x
        Debug text
        PushListPosition( *this\columns( ) )
        ForEach *this\columns( )
          *this\Columns( )\x = *this\scroll_width( ): *this\scroll_width( ) + *this\Columns( )\width
        Next
        PopListPosition( *this\columns( ) )
      Else
        *this\Columns( )\x = *this\text\padding\x + *this\scroll_width( )
      EndIf
      
      *this\scroll_width( ) + width
      
      ;\\
      ;*this\fs[2] = 24
      If *this\type = #__type_listicon
        *this\Columns( )\height = 24
      EndIf
      ;\\
      *this\Columns( )\index         = Position
      *this\Columns( )\text\string.s = Text.s
      *this\Columns( )\TextChange( ) = 1
    EndProcedure
    
    Procedure AddItem( *this._S_widget, Item.l, Text.s, Image.i = - 1, flag.q = 0 )
      Protected result
      
      If *this\type = #__type_ListIcon
        ForEach *This\Columns( )
          *this\row\column = *this\columns( )\index
          Tree_AddItem( *this, Item, Text, Image, flag )
        Next
      EndIf
      
      If *this\type = #__type_MDI
        *this\count\items + 1
        ;         Static pos_x, pos_y
        ;         Protected x = a_transform( )\grid_size, y = a_transform( )\grid_size, width.l = 280, height.l = 180
        ;
        ;         ;         If a_transform( ) And a_transform( )\grid_size
        ;         ;           x = ( x/a_transform( )\grid_size ) * a_transform( )\grid_size
        ;         ;           y = ( y/a_transform( )\grid_size ) * a_transform( )\grid_size
        ;         ;
        ;         ;           width = ( width/a_transform( )\grid_size ) * a_transform( )\grid_size - ( #__window_frame_size * 2 )%a_transform( )\grid_size + 1
        ;         ;           height = ( height/a_transform( )\grid_size ) * a_transform( )\grid_size - ( #__window_frame_size*2+#__window_caption_height )%a_transform( )\grid_size + 1
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
        ProcedureReturn edit_AddItem( *this, item, @text, Len(Text) )
      EndIf
      
      If *this\type = #__type_Tree Or
         *this\type = #__type_property
        ProcedureReturn Tree_AddItem( *this, Item, Text, Image, flag )
      EndIf
      
      If *this\type = #__type_ListView
        ProcedureReturn Tree_AddItem( *this, Item, Text, Image, flag )
      EndIf
      
      If *this\type = #__type_combobox
        If *this\PopupBox( )
          ProcedureReturn Tree_AddItem( *this\PopupBox( ), Item, Text, Image, flag )
        Else
          ProcedureReturn Tree_AddItem( *this, Item, Text, Image, flag )
        EndIf
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn bar_tab_AddItem( *this, Item, Text, Image, flag )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn bar_tab_AddItem( *this\TabBox( ), Item, Text, Image, flag )
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure RemoveItem( *this._S_widget, Item.l )
      Protected result
      
      If *this\type = #__type_Editor
        edit_RemoveItem( *this, Item )
        
        result = #True
      EndIf
      
      ;- widget::tree_remove_item( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
        If is_no_select_item_( *this\_rows( ), Item )
          ProcedureReturn #False
        EndIf
        
        ;         ;\\ тормозить удаление итемов
        ;         ; поэтому изменения сделал в setState
        ;         PushListPosition( *this\_rows( ))
        ;         While NextElement( *this\_rows( ))
        ;           *this\_rows( )\index - 1
        ;         Wend
        ;         PopListPosition( *this\_rows( ))
        
        ;\\
        Protected sublevel = *this\_rows( )\sublevel
        Protected *parent_row._S_rows = *this\_rows( )\ParentRow( )
        
        ; if is last parent item then change to the prev element of his level
        If *parent_row And *parent_row\last = *this\_rows( )
          PushListPosition( *this\_rows( ))
          While PreviousElement( *this\_rows( ))
            If *parent_row = *this\_rows( )\ParentRow( )
              *parent_row\last = *this\_rows( )
              Break
            EndIf
          Wend
          PopListPosition( *this\_rows( ))
          
          ; if the remove last parent childrens
          If *parent_row\last = *this\_rows( )
            *parent_row\childrens = #False
            *parent_row\last      = #Null
          Else
            *parent_row\childrens = #True
          EndIf
        EndIf
        
        ; before deleting a parent, we delete its children
        If *this\_rows( )\childrens
          PushListPosition( *this\_rows( ))
          While NextElement( *this\_rows( ))
            If *this\_rows( )\sublevel > sublevel
              DeleteElement( *this\_rows( ))
              *this\count\items - 1
            Else
              Break
            EndIf
          Wend
          PopListPosition( *this\_rows( ))
        EndIf
        
        ; if the item to be removed is selected,
        ; then we set the next item of its level as selected
        If *this\FocusedRow( ) = *this\_rows( )
          If *this\FocusedRow( )\state\press
            *this\FocusedRow( )\state\press = 0
          EndIf
          *this\FocusedRow( )\state\focus = 0 ;???
          
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
            If *this\FocusedRow( )\ParentRow( ) And
               *this\FocusedRow( )\ParentRow( )\collapsebox\state\check
              *this\FocusedRow( ) = *this\FocusedRow( )\ParentRow( )
            EndIf
            
            ;;;*this\PressedRow( ) = *this\FocusedRow( ) ; ?
            *this\FocusedRow( )\state\press = #True
            *this\FocusedRow( )\state\focus = 1
            *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          EndIf
        EndIf
        
        *this\WidgetChange( ) = 1
        *this\count\items - 1
        DeleteElement( *this\_rows( ))
        PostCanvasRepaint( *this )
        result = #True
      EndIf
      
      If *this\type = #__type_Panel
        result = bar_tab_removeItem( *this\TabBox( ), Item )
        
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
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
        If *this\count\items <> 0
          ;; Post( *this, #__event_Change, #PB_All ) ;
          
          *this\WidgetChange( ) = 1
          *this\count\items     = 0
          
          If *this\FocusedRow( )
            *this\FocusedRow( )\color\state = 0
            ClearStructure(*this\FocusedRow( ), _S_rows)
            *this\FocusedRow( ) = 0
          EndIf
          
          ClearList( *this\_rows( ))
          PostCanvasRepaint( *this )
        EndIf
      EndIf
      
      ; - Panel_ClearItems( )
      If *this\type = #__type_Panel
        result = bar_tab_clearItems( *this\TabBox( ) )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_clearItems( *this )
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
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
    
    Procedure.l GetButtons( )
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
      ProcedureReturn *this\type ; Returns create widget-type
    EndProcedure
    
    Procedure.i GetRoot( *this._S_widget ) ; Returns root widget
      If *this = #Null
        ProcedureReturn Root( )
      Else
        ProcedureReturn *this\_root( )
      EndIf
    EndProcedure
    
    Procedure.i GetGadget( *this._S_widget = #Null )
      If *this = #Null
        ProcedureReturn Root( )\canvas\gadget ; Returns current root canvas-gadget
      ElseIf is_window_( *this )
        ProcedureReturn *this\gadget ; Returns active gadget
      Else
        ProcedureReturn *this\_root( )\canvas\gadget ; Returns canvas-gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow( *this._S_widget = #Null )
      If *this = #Null
        ProcedureReturn Root( )\canvas\window ; Returns current root canvas-window
      ElseIf is_window_( *this )
        ProcedureReturn *this\_window( ) ; Returns parent window
      Else
        ProcedureReturn *this\_root( )\canvas\window ; Returns canvas-window
      EndIf
    EndProcedure
    
    Procedure GetWidget( index )
      Protected result
      
      If index = - 1
        ProcedureReturn enumWidget( )
      Else
        PushListPosition( enumWidget( ) )
        ForEach enumWidget( )
          If enumWidget( )\index = index
            result = enumWidget( )
            Break
          EndIf
        Next
        PopListPosition( enumWidget( ) )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetParent( *this._S_widget )
      ProcedureReturn *this\_parent( )
    EndProcedure
    
    Procedure GetFirst( *this._S_widget, tabindex.l )
      Protected *result._S_widget
      
      If *this\count\childrens
        PushListPosition( *this\_widgets( ) )
        ChangeCurrentElement( *this\_widgets( ), *this\address )
        While NextElement( *this\_widgets( ) )
          If *this\_widgets( ) = *this\last\widget Or
             *this\_widgets( )\TabIndex( ) = tabindex
            *result = *this\_widgets( )
            Break
          EndIf
        Wend
        PopListPosition( *this\_widgets( ) )
      Else
        *result = *this
      EndIf
      
      ; Debug "   "+*result\class
      
      ProcedureReturn *result
    EndProcedure
    
    Procedure GetLast( *this._S_widget, tabindex.l )
      Protected result, *after._S_widget, *parent._S_widget
      
      If *this\last\widget
        If *this\count\childrens
          LastElement( *this\_widgets( ) )
          result = *this\_widgets( )\last\widget
          
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
            PushListPosition( *this\_widgets( ) )
            ChangeCurrentElement( *this\_widgets( ), *after\address )
            While PreviousElement( *this\_widgets( ) )
              If *this\_widgets( )\TabIndex( ) = tabindex ;Or *this\_widgets( ) = *this
                Break
              EndIf
            Wend
            result = *this\_widgets( )\last\widget
            PopListPosition( *this\_widgets( ) )
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
        If Attribute = #PB_Tree_Collapsed
          result = *this\mode\collapsed
        EndIf
      EndIf
      
      If *this\type = #__type_Splitter
        Select Attribute
          Case #PB_Splitter_FirstGadget : result = *this\splitter_gadget_1( )
          Case #PB_Splitter_SecondGadget : result = *this\splitter_gadget_2( )
          Case #PB_Splitter_FirstMinimumSize : result = *this\bar\button[1]\size
          Case #PB_Splitter_SecondMinimumSize : result = *this\bar\button[2]\size
        EndSelect
      EndIf
      
      ; is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or
         *this\type = #__type_MDI
        Select Attribute
          Case #PB_ScrollArea_X : result = *this\scroll\h\bar\page\pos
          Case #PB_ScrollArea_Y : result = *this\scroll\v\bar\page\pos
          Case #PB_ScrollArea_InnerWidth : result = *this\scroll\h\bar\max
          Case #PB_ScrollArea_InnerHeight : result = *this\scroll\v\bar\max
          Case #PB_ScrollArea_ScrollStep : result = *this\scroll\increment
        EndSelect
      EndIf
      
      If *this\type = #__type_Spin Or
         ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar ) Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar ; Or *this\type = #__type_Splitter
        
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
    
    Procedure.f GetState( *this._S_widget )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
        
        If *this\FocusedRow( )
          ProcedureReturn *this\FocusedRow( )\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #__type_ComboBox And *this\PopupBox( )
        If *this\PopupBox( )\FocusedRow( )
          ProcedureReturn *this\PopupBox( )\FocusedRow( )\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage Or
         *this\type = #__type_Option Or
         *this\type = #__type_CheckBox
        
        ProcedureReturn *this\state\check
      EndIf
      
      If *this\type = #__type_Editor
        ProcedureReturn *this\FocusedLineIndex( )
      EndIf
      
      If *this\type = #__type_Panel
        ProcedureReturn *this\TabBoxFocusedIndex( )
      EndIf
      
      If *this\type = #__type_TabBar Or
         *this\type = #__type_ToolBar
        
        ProcedureReturn *this\FocusedTabIndex( )
      Else
        If *this\bar
          ProcedureReturn *this\bar\page\pos
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s GetText( *this._S_widget );, column.l = 0 )
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
          Case #__color_line : Color = *this\color\line
          Case #__color_back : Color = *this\color\back
          Case #__color_front : Color = *this\color\front
          Case #__color_frame : Color = *this\color\frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;-
    Procedure.l SetColor( *this._S_widget, ColorType.l, Color.l, Column.l = 0 )
      *this\color\alpha.allocate( COLOR )
      Protected result.l, alpha.a = Alpha( Color )
      
      If Not alpha
        Color = Color & $FFFFFF | 255 << 24
      EndIf
      
      set_color_( result, *this\color, ColorType, Color, alpha, [Column] )
      
      If *this\scroll
        If ColorType = #__color_back
          If *this\scroll\v
            *this\scroll\v\color\back[Column] = color
          EndIf
          If *this\scroll\h
            *this\scroll\h\color\back[Column] = color
          EndIf
        EndIf
      EndIf
      
      If result
        PostCanvasRepaint( *this )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure SetCursor( *this._S_widget, *cursor )
      Protected result = *this\cursor
      Debug "set-cursor "+*cursor
      ;\\
      If mouse( )\drag
        If *this\state\drag = #PB_Drag_Finish
          mouse( )\drag\cursor = *cursor
        Else
          mouse( )\drag\cursor = *this\cursor
        EndIf
        If mouse( )\drag\cursor = 0
          mouse( )\drag\cursor = - 1
        EndIf
      EndIf
      
      ;\\
      If *this\cursor <> *cursor
        *this\cursor = *cursor
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure SetClass( *this._S_widget, class.s )
      *this\class = class
      ProcedureReturn *this
    EndProcedure
    
    Procedure.b SetState( *this._S_widget, state.f )
      Protected result
      
      ;\\
      If *this\type = #__type_ComboBox
        If *this\PopupBox( )
          
          If is_no_select_item_( *this\PopupBox( )\_rows( ), State )
            ProcedureReturn #False
          EndIf
          
          If *this\PopupBox( )\FocusedRow( ) <> *this\PopupBox( )\_rows( )
            
            If *this\PopupBox( )\FocusedRow( )
              If *this\PopupBox( )\FocusedRow( )\state\focus
                *this\PopupBox( )\FocusedRow( )\state\focus = #False
              EndIf
              
              *this\PopupBox( )\FocusedRow( )\color\state = #__S_0
            EndIf
            
            *this\PopupBox( )\FocusedRow( )             = *this\PopupBox( )\_rows( )
            *this\PopupBox( )\FocusedRow( )\state\focus = #True
            *this\PopupBox( )\FocusedRow( )\color\state = #__S_2
            Debug "SETSTATE - combo "
            ;*this\text\string = *this\PopupBox( )\FocusedRow( )\text\string
            
            SetText( *this, GetItemText( *this\PopupBox( ), GetState( *this\PopupBox( ) ) ) )
          EndIf
        EndIf
      EndIf
      
      ;\\
      If *this\type = #__type_Button Or
         *this\type = #__type_ButtonImage
        
        If *this\flag & #PB_Button_Toggle
          If *this\state\check <> state
            *this\state\check = state
            If state
              *this\color\state = #__S_2
            Else
              If *this\state\enter
                *this\color\state = #__S_1
              Else
                *this\color\state = #__S_0
              EndIf
            EndIf
            
            Post( *this, #__event_Change )
            PostCanvasRepaint( *this )
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      
      ;\\
      If *this\type = #__type_CheckBox Or
         *this\type = #__type_Option
        
        If *this\state\check <> State
          If *this\GroupBox( )
            If *this\GroupBox( )\GroupBox( ) <> *this
              If *this\GroupBox( )\GroupBox( )
                *this\GroupBox( )\GroupBox( )\state\check = 0
              EndIf
              *this\GroupBox( )\GroupBox( ) = *this
            EndIf
          EndIf
          *this\state\check = State
          
          Post( *this, #__event_Change )
          PostCanvasRepaint( *this )
          ProcedureReturn #True
        EndIf
      EndIf
      
      ;\\ - widget::IPaddress_SetState( )
      If *this\type = #__type_IPAddress
        If *this\FocusedLineIndex( ) <> State
          *this\FocusedLineIndex( ) = State
          SetText( *this, Str( IPAddressField( State, 0 )) + "." +
                          Str( IPAddressField( State, 1 )) + "." +
                          Str( IPAddressField( State, 2 )) + "." +
                          Str( IPAddressField( State, 3 ) ))
        EndIf
      EndIf
      
      ;\\ - widget::Window_SetState( )
      If *this\type = #__type_Window
        result = Window_SetState( *this, state )
      EndIf
      
      ;\\ - widget::Editor_SetState( )
      If *this\type = #__type_Editor
        edit_SetState( *this, State )
      EndIf
      
      ;\\ - widget::tree_setState
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        ; Debug *this\mode\check
        
        
        ; reset all selected items
        If State = - 1
          If *this\FocusedRow( )
            If *this\mode\check <> #__m_optionselect
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode
                If *this\mode\check = #__m_multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
            EndIf
            
            *this\FocusedRow( )\color\state = #__S_0
            *this\FocusedRow( )             = #Null
          EndIf
        EndIf
        
        ;
        If is_no_select_item_( *this\_rows( ), State )
          ProcedureReturn #False
        EndIf
        
        ;\\
        If *this\count\items
          ;\\ example file "D&D-items"
          If *this\drop
            If *this\PressedRow( )
              If *this\_rows( )\index <> State
                *this\_rows( )\index = State
              EndIf
              Protected position
              
              Debug " ---------- *this\PressedRow( )\childrens " + *this\PressedRow( )\childrens
              
              PushListPosition( *this\_rows( ))
              If *this\_rows( )\index > *this\PressedRow( )\index
                ;\\ drag up and drop down
                While PreviousElement( *this\_rows( ))
                  If *this\_rows( )\index > *this\PressedRow( )\index
                    *this\_rows( )\index - 1 - *this\PressedRow( )\childrens
                  EndIf
                Wend
              ElseIf *this\_rows( )\index < *this\PressedRow( )\index
                ;\\ drag down and drop up
                While NextElement( *this\_rows( ))
                  If *this\_rows( )\index < *this\PressedRow( )\index
                    *this\_rows( )\index + 1 + *this\PressedRow( )\childrens
                  EndIf
                Wend
              EndIf
              PopListPosition( *this\_rows( ))
              
              position = state
              
              PushListPosition( *this\_rows( ))
              While NextElement( *this\_rows( ))
                If *this\_rows( )\sublevel = *this\PressedRow( )\sublevel
                  Break
                EndIf
                If *this\_rows( )\sublevel > *this\PressedRow( )\sublevel
                  position + 1
                  *this\_rows( )\index = position
                EndIf
              Wend
              PopListPosition( *this\_rows( ))
            EndIf
          EndIf
          
          ;\\
          If *this\FocusedRow( ) <> *this\_rows( )
            If *this\FocusedRow( )
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode
                If *this\mode\check = #__m_multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
              
              *this\FocusedRow( )\color\state = #__S_0
            EndIf
            
            *this\FocusedRow( ) = *this\_rows( )
            *this\scroll\state  = - 1
            
            ; click select mode
            If *this\mode\check = #__m_clickselect
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = 0
                *this\FocusedRow( )\color\state = #__S_0
              Else
                *this\FocusedRow( )\state\focus = 1
                *this\FocusedRow( )\color\state = #__S_3
              EndIf
              
              Post( *this, #__event_Change, *this\FocusedRow( )\index )
            Else
              If *this\FocusedRow( )\state\focus = 0 ; ???
                *this\FocusedRow( )\state\focus = 1
                ; multi select mode
                If *this\mode\check = #__m_multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, 1 )
                EndIf
              EndIf
              
              *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
            
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      
      ;\\ - Panel_SetState( )
      If *this\type = #__type_Panel
        result = bar_tab_SetState( *this\TabBox( ), state )
      EndIf
      
      ;\\ - Tabbar_SetState( )
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        result = bar_tab_SetState( *this, state )
      EndIf
      
      ;\\
      Select *this\type
        Case #__type_Spin ,
             #__type_TabBar, #__type_ToolBar,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter
          
          result = bar_SetState( *this, state )
      EndSelect
      
      PostCanvasRepaint( *this )
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
            set_image_( *this, *this\image[#__image_released], *value )
            
          Case #PB_Button_PressedImage
            set_image_( *this, *this\image[#__image_pressed], *value )
            
        EndSelect
      EndIf
      
      ;  is_scrollbars_( *this )
      If *this\type = #__type_ScrollArea Or
         *this\type = #__type_MDI
        
        Select Attribute
          Case #PB_ScrollArea_X
            If bar_SetState( *this\scroll\h, *value )
              ; *this\scroll_x( ) = *this\scroll\h\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_Y
            If bar_SetState( *this\scroll\v, *value )
              ; *this\scroll_y( ) = *this\scroll\v\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerWidth
            If bar_SetAttribute( *this\scroll\h, #__bar_maximum, *value )
              *this\scroll_width( ) = *this\scroll\h\bar\max
              result                = 1
            EndIf
            
          Case #PB_ScrollArea_InnerHeight
            If bar_SetAttribute( *this\scroll\v, #__bar_maximum, *value )
              *this\scroll_height( ) = *this\scroll\v\bar\max
              result                 = 1
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
      
      If *this\type = #PB_GadgetType_Image
        Select Attribute
          Case #__DisplayMode
            Select Value
              Case 0 ; Default
                     ;                 *this\image\Align\Vertical = 0
                     ;                 *this\image\Align\Horizontal = 0
                
              Case 1 ; Center
                     ;                 *this\image\Align\Vertical = 1
                     ;                 *this\image\Align\Horizontal = 1
                
              Case 3 ; Mosaic
              Case 2 ; Stretch
                
              Case 5 ; Proportionally
            EndSelect
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
      
      If *this\type = #__type_ComboBox
        If *this\StringBox( )
          ProcedureReturn edit_SetText( *this\StringBox( ), Text )
        Else
          ; ProcedureReturn edit_SetText( *this, Text )
          If *This\text\string.s <> Text.s
            *This\text\string.s = Text.s
            *This\TextChange( ) = #True
            result              = #True
            PostCanvasRepaint( *This )
          EndIf
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
          *This\TextChange( ) = #True
          result              = #True
          PostCanvasRepaint( *This )
        EndIf
      EndIf
      
      *this\WidgetChange( ) = 1
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetFont( *this._S_widget, FontID.i )
      Protected result
      
      If *this\text\fontID <> FontID
        *this\text\fontID = FontID
        
        If *this\type = #__type_Editor
          *this\TextChange( ) = 1
          
          Redraw( *this )
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
    
    Procedure SetImage( *this._S_widget, *image )
      set_image_( *this, *this\Image, *image )
    EndProcedure
    
    Procedure SetBackgroundImage( *this._S_widget, *image )
      set_image_( *this, *this\Image[#__image_background], *image )
    EndProcedure
    
    Procedure SetData( *this._S_widget, *data )
      *this\data = *data
    EndProcedure
    
    Procedure SetForeground( *this._S_widget )
      While is_window_( *this )
        SetPosition( *this, #PB_List_Last )
        *this = *this\_window( )
      Wend
      
      If PopupWindow( )
        SetPosition( PopupWindow( ), #PB_List_Last )
      EndIf
    EndProcedure
    
    Procedure.i Sticky( *window._S_widget = #PB_Default, state.b = #PB_Default )
      Protected result = PopupWindow( )
      
      If state <> #PB_Default
        If is_window_( *window )
          If state
            PopupWindow( ) = *window
          Else
            PopupWindow( ) = #Null
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
          ; GetActive( )\color\state = #__S_3
          result | DoEvents( GetActive( ), #__event_LostFocus )
        EndIf
      EndIf
      
      ; when we deactivate the window
      ; we will deactivate his last active gadget
      If GetActive( )\gadget And
         GetActive( )\gadget\state\focus = #True
        GetActive( )\gadget\state\focus = #False
        ;GetActive( )\gadget\color\state = #__S_3
        result | DoEvents( GetActive( )\gadget, #__event_LostFocus )
        
        ; is integral scroll bars
        If GetActive( )\gadget\scroll
          If GetActive( )\gadget\scroll\v And
             Not GetActive( )\gadget\scroll\v\hide And
             GetActive( )\gadget\scroll\v\type
            
            If GetActive( )\gadget\scroll\v\state\focus = #True
              GetActive( )\gadget\scroll\v\state\focus = #False
              ;GetActive( )\gadget\scroll\v\color\state = #__S_3
              result | DoEvents( GetActive( )\gadget\scroll\v, #__event_LostFocus )
            EndIf
          EndIf
          If GetActive( )\gadget\scroll\h And
             Not GetActive( )\gadget\scroll\h\hide And
             GetActive( )\gadget\scroll\h\type
            
            If GetActive( )\gadget\scroll\h\state\focus = #True
              GetActive( )\gadget\scroll\h\state\focus = #False
              ;GetActive( )\gadget\scroll\h\color\state = #__S_3
              result | DoEvents( GetActive( )\gadget\scroll\h, #__event_LostFocus )
            EndIf
          EndIf
        EndIf
        
        ; is integral tab bar
        If GetActive( )\gadget\TabBox( ) And
           Not GetActive( )\gadget\TabBox( )\hide And
           GetActive( )\gadget\TabBox( )\type
          
          If GetActive( )\gadget\TabBox( )\state\focus = #True
            GetActive( )\gadget\TabBox( )\state\focus = #False
            ;GetActive( )\gadget\color\state              = #__S_3
            result | DoEvents( GetActive( )\gadget\TabBox( ), #__event_LostFocus )
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
        ;                   ;;  result | DoEvents( *active\_widgets( ), #__event_LostFocus )
        ;                   EndIf
        ;                 EndIf
        ;               Wend
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetActive( *this._S_widget )
      Protected result.i, *active._S_widget
      
      If *this And Not *this\state\disable
        If *this\_root( ) And GetActiveGadget( ) <> *this\_root( )\canvas\gadget
          SetActiveGadget( *this\_root( )\canvas\gadget )
        EndIf
        If a_transform_( *this ) Or is_root_( *this ) ;
          ProcedureReturn 0
        EndIf
        
        If *this = PopupWidget( )
          Debug " PopupWidget( activate ) "
          ; *this = *this\PopupBox( )
          ProcedureReturn 0
        EndIf
        
        FocusedWidget( ) = *this
        ;         ; если нужно отключить событие интегрированного гаджета
        ;         If is_integral_( *this )
        ;           *this = *this\_parent( )
        ;         EndIf
        
        ;         ; is integral string bar
        ;         If *this\type = #__type_spin
        ;           *this = *this\StringBox( )
        ;         EndIf
        
        If *this\state\focus = #False
          *this\state\focus = #True
          *this\color\state = #__S_2
          
          ; deactive
          If GetActive( )
            SetDeactive( *this )
          EndIf
          
          ; set active all parents
          If *this\address
            ;             ChangeCurrentElement( *this\_widgets( ), *this\address )
            ;             While PreviousElement( *this\_widgets( ))
            ;               ;If *this\_widgets( )\type = #__type_Window
            ;               If IsChild( *this, *this\_widgets( )) ;And *this\_widgets( )\container
            ;                 If *this\_widgets( )\state\focus = #False
            ;                   *this\_widgets( )\state\focus = #True
            ;                   *this\_widgets( )\color\state = #__S_2
            ;                   result | DoEvents( *this\_widgets( ), #__event_Focus )
            ;                 EndIf
            ;               EndIf
            ;               ;EndIf
            ;             Wend
          EndIf
          
          ; get active window
          If is_window_( *this ) Or is_root_( *this )
            GetActive( ) = *this
          Else
            If is_integral_( *this )
              GetActive( )        = *this\_parent( )\_window( )
              GetActive( )\gadget = *this\_parent( )
            Else
              GetActive( )        = *this\_window( )
              GetActive( )\gadget = *this
            EndIf
          EndIf
          
          ; when we activate the gadget
          ; first we activate its parent window
          If GetActive( ) And Not is_root_( GetActive( ) ) And
             GetActive( )\state\focus = #False
            GetActive( )\state\focus = #True
            GetActive( )\color\state = #__S_2
            DoEvents( GetActive( ), #__event_Focus )
          EndIf
          
          ;
          DoEvents( *this, #__event_Focus )
          
          If GetActive( )
            ; when we activate the window
            ; we will activate his last gadget that lost focus
            If GetActive( )\gadget And
               GetActive( )\gadget\state\focus = #False
              GetActive( )\gadget\state\focus = #True
              GetActive( )\gadget\color\state = #__S_2
              DoEvents( GetActive( )\gadget, #__event_Focus )
            EndIf
            
            ; set window foreground position
            SetForeground( GetActive( ))
          EndIf
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
    
    Procedure SetPosition( *this._S_widget, position.l, *widget._S_widget = #Null ) ; Ok
      If *widget = #Null
        Select Position
          Case #PB_List_First : *widget = *this\_parent( )\first\widget
          Case #PB_List_Before : *widget = *this\before\widget
          Case #PB_List_After : *widget = *this\after\widget
          Case #PB_List_Last : *widget = *this\_parent( )\last\widget
        EndSelect
      EndIf
      
      If *widget And *this <> *widget And *this\TabIndex( ) = *widget\TabIndex( )
        If Position = #PB_List_First Or Position = #PB_List_Before
          
          PushListPosition( *this\_widgets( ))
          ChangeCurrentElement( *this\_widgets( ), *this\address )
          MoveElement( *this\_widgets( ), #PB_List_Before, *widget\address )
          
          If *this\count\childrens
            While PreviousElement( *this\_widgets( ))
              If IsChild( *this\_widgets( ), *this )
                MoveElement( *this\_widgets( ), #PB_List_After, *widget\address )
              EndIf
            Wend
            
            While NextElement( *this\_widgets( ))
              If IsChild( *this\_widgets( ), *this )
                MoveElement( *this\_widgets( ), #PB_List_Before, *widget\address )
              EndIf
            Wend
          EndIf
          PopListPosition( *this\_widgets( ))
        EndIf
        
        If Position = #PB_List_Last Or Position = #PB_List_After
          Protected *last._S_widget = GetLast( *widget, *widget\TabIndex( ))
          
          PushListPosition( *this\_widgets( ))
          ChangeCurrentElement( *this\_widgets( ), *this\address )
          MoveElement( *this\_widgets( ), #PB_List_After, *last\address )
          
          If *this\count\childrens
            While NextElement( *this\_widgets( ))
              If IsChild( *this\_widgets( ), *this )
                MoveElement( *this\_widgets( ), #PB_List_Before, *last\address )
              EndIf
            Wend
            
            While PreviousElement( *this\_widgets( ))
              If IsChild( *this\_widgets( ), *this )
                MoveElement( *this\_widgets( ), #PB_List_After, *this\address )
              EndIf
            Wend
          EndIf
          PopListPosition( *this\_widgets( ))
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
          
          *this\after\widget    = *widget
          *this\before\widget   = *widget\before\widget
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
          
          *this\before\widget  = *widget
          *this\after\widget   = *widget\after\widget
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
    
    Procedure SetParent( *this._S_widget, *parent._S_widget, tabindex.l = 0 )
      Protected parent, ReParent.b, x, y, *last._S_widget, *lastParent._S_widget, NewList *D._S_widget( ), NewList *C._S_widget( )
      
      If *parent
        If *parent\child And Not *parent\container
          Debug "SetParent("
          *parent = *parent\_parent( )
        EndIf
        
        If *this\_parent( ) = *parent And
           *this\TabIndex( ) = tabindex
          ProcedureReturn #False
        EndIf
        
        ;TODO
        If tabindex < 0
          If *parent\TabBox( )
            tabindex = *parent\TabBox( )\OpenedTabIndex( )
          Else
            tabindex = 0
          EndIf
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex % 2
              *parent\splitter_gadget_1( )    = *this
              *parent\splitter_is_gadget_1( ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If *parent\splitter_is_gadget_1( )
                ProcedureReturn 0
              EndIf
            Else
              *parent\splitter_gadget_2( )    = *this
              *parent\splitter_is_gadget_2( ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If *parent\splitter_is_gadget_2( )
                ProcedureReturn 0
              EndIf
            EndIf
          EndIf
        EndIf
        
        *this\TabIndex( ) = tabindex
        
        ; set hide state
        If *parent\hide
          *this\hide = #True
        ElseIf *parent\TabBox( )
          ; hide all children except the selected tab
          *this\hide = Bool(*parent\TabBoxFocusedIndex( ) <> tabindex)
        EndIf
        
        If *parent\last\widget
          *last = GetLast( *parent, tabindex )
          
        EndIf
        
        If *this And
           *this\_parent( )
          
          If *this\address
            *lastParent = *this\_parent( )
            *lastParent\count\childrens - 1
            
            ChangeCurrentElement( *this\_widgets( ), *this\address )
            AddElement( *D( ) ) : *D( ) = *this\_widgets( )
            
            If *this\count\childrens
              PushListPosition( *this\_widgets( ) )
              While NextElement( *this\_widgets( ) )
                If Not IsChild( *this\_widgets( ), *this )
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) = *this\_widgets( )
                
                *D( )\_window( ) = *parent\_window( )
                *D( )\_root( )   = *parent\_root( )
                ;; Debug " children - "+ *D( )\data +" - "+ *this\data
                
                ;\\ integrall childrens
                If *D( )\scroll
                  If *D( )\scroll\v
                    *D( )\scroll\v\_root( )   = *D( )\_root( )
                    *D( )\scroll\v\_window( ) = *D( )\_window( )
                  EndIf
                  If *D( )\scroll\h
                    *D( )\scroll\h\_root( )   = *D( )\_root( )
                    *D( )\scroll\h\_window( ) = *D( )\_window( )
                  EndIf
                EndIf
                
              Wend
              PopListPosition( *this\_widgets( ) )
            EndIf
            
            ; move with a parent and his children
            If *this\_root( ) = *parent\_root( )
              If *last
                ; move inside the list
                LastElement( *D( ) )
                Repeat
                  ChangeCurrentElement( *this\_widgets( ), *D( )\address )
                  MoveElement( *this\_widgets( ), #PB_List_After, *last\address )
                Until PreviousElement( *D( ) ) = #False
              Else
                ; root position
                MoveElement( *this\_widgets( ), #PB_List_Last )
                *last = *this\_widgets( )
              EndIf
            Else
              ForEach *D( )
                ChangeCurrentElement( *this\_widgets( ), *D( )\address )
                ; go to the end of the list to split the list
                MoveElement( *this\_widgets( ), #PB_List_Last )
              Next
              
              ; now we split the list and transfer it to another list
              ChangeCurrentElement( *this\_widgets( ), *this\address )
              SplitList( *this\_widgets( ), *D( ) )
              
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
              LastElement( *parent\_widgets( ) )
            EndIf
            
            AddElement( *parent\_widgets( ) )
            *parent\_widgets( ) = *this
            *this\index         = ListIndex( *parent\_widgets( ) )
            *this\address       = @*parent\_widgets( )
          EndIf
          
          *this\last\widget = *this ; if last type
        EndIf
        
        If *parent\last\widget = *parent
          *parent\first\widget = *this
          *parent\last\widget  = *this
          *this\before\widget  = #Null
          *this\after\widget   = #Null
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
            *this\after\widget  = #Null
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this
          EndIf
        EndIf
        
        
        ;\\
        ChangeParent( *this, *parent )
        
        ;\\
        *parent\count\childrens + 1
        If *parent <> *parent\_root( )
          *parent\_root( )\count\childrens + 1
        EndIf
        
        ;\\
        *this\level         = *parent\level + 1
        *this\count\parents = *parent\count\parents + 1
        
        
        ;\\ TODO
        If *this\_window( )
          Static NewMap typeCount.l( )
          typeCount( Hex( *this\_window( ) + *this\type ) ) + 1
          *this\count\index = typeCount( ) - 1
          If *parent\_a_\transform
            typeCount( Str( *parent + *this\type ) ) + 1
            *this\count\type = typeCount( ) - 1
          EndIf
          
          ; ;           If *this\type > 0
          ; ;             *this\count\index = *this\_window( )\type[*this\type]
          ; ;             *this\_window( )\type[*this\type] + 1
          ; ;
          ; ;             *this\_window( )\count\type[*this\type] + 1
          ; ;             *this\_window( )\count\type[*this\type] + 1
          ; ;           EndIf
        EndIf
        
        ;\\ Anchor init
        If *this\type = #__type_MDI
          ; this before Resize( )
          ; and after SetParent( )
          ;
          If Not *this\_a_\transform And
             Bool( *this\flag & #__mdi_editable = #__mdi_editable )
            a_init( *this )
          EndIf
        EndIf
        
        ;\\ set transformation for the child
        If Not *this\_a_\transform And *parent\_a_\transform
          a_set_state( *this, Bool( *parent\_a_\transform ) )
          
          *this\_a_\mode = #__a_full | #__a_position
          a_set( *this, #__a_size )
        EndIf
        
        ;\\
        If ReParent
          ;
          If *this\state\drag = #PB_Drag_Move
            *this\resize | #__resize_x | #__resize_y | #__resize_change
            
            x = *this\x[#__c_frame] - *parent\x[#__c_inner]
            y = *this\y[#__c_frame] - *parent\y[#__c_inner]
            
            If *this\_a_\transform > 0
              ;\\ потому что точки внутри контейнера перемешаем надо перемести и детей
              If Not *this\attach 
                If *parent\container > 0 And
                   *parent\type <> #__type_MDI
                  
                  y + *parent\fs
                  x + *parent\fs
                EndIf
              EndIf
              
              x + ( x % a_transform( )\grid_size )
              x = ( x / a_transform( )\grid_size ) * a_transform( )\grid_size
              
              y + ( y % a_transform( )\grid_size )
              y = ( y / a_transform( )\grid_size ) * a_transform( )\grid_size
            EndIf
            
            *this\x[#__c_container] = x
            *this\y[#__c_container] = y
          Else
            ;\\ resize
            x = *this\x[#__c_container]
            y = *this\y[#__c_container]
            
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
            
            Resize( *this, x - *parent\scroll_x( ), y - *parent\scroll_y( ), #PB_Ignore, #PB_Ignore )
          EndIf
          
          ;
          If *this\_root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( *this\_root( )\canvas\ResizeBeginWidget, #__event_ResizeEnd )
            *this\_root( )\canvas\ResizeBeginWidget = #Null
          EndIf
          
          PostCanvasRepaint( *parent )
          PostCanvasRepaint( *lastParent )
          
          ;           ChangeCurrentRoot(*parent\_root( )\canvas\address)
          ;           ReDraw(Root( ))
          ;           ChangeCurrentRoot(*lastParent\_root( )\canvas\address)
          ;           ReDraw(Root( ))
          
        EndIf
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure SetFrame( *this._S_widget, size.a, mode.i = 0 )
      Protected result
      If *this\fs <> size
        result   = *this\fs
        *this\fs = size
        
        If *this\_a_\transform
          a_size( *this\_a_\id, *this\_a_\size )
        EndIf
        ;;
        If mode = - 1 ; auto pos
          Resize( *this, *this\x[#__c_container] - size, *this\y[#__c_container] - size, *this\width[#__c_frame] + size * 2, *this\height[#__c_frame] + size * 2 )
        ElseIf mode = - 2 ; auto pos
                          ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Resize( *this, *this\x[#__c_container] - (size - result), *this\y[#__c_container] - (size - result), #PB_Ignore, #PB_Ignore )
        Else
          Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        EndIf
        
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
    
    Procedure SetAlignment( *this._S_widget, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
      Protected flag.q
      ;\\
      If mode & #__align_auto
        If left = 0 And top = 0 And right = 0 And bottom = 0
          If mode & #__align_left : left = #__align_auto
          ElseIf mode & #__align_top : top = #__align_auto
          ElseIf mode & #__align_right : right = #__align_auto
          ElseIf mode & #__align_bottom : bottom = #__align_auto
          Else
            left   = #__align_auto
            top    = #__align_auto
            right  = #__align_auto
            bottom = #__align_auto
          EndIf
        Else
          If left > 0 : left = #__align_auto : EndIf
          If top > 0 : top = #__align_auto : EndIf
          If right > 0 : right = #__align_auto : EndIf
          If bottom > 0 : bottom = #__align_auto : EndIf
        EndIf
      EndIf
      
      ;\\
      If mode & #__align_full
        If left = 0 And top = 0 And right = 0 And bottom = 0
          If mode & #__align_left : left = #__align_full
          ElseIf mode & #__align_top : top = #__align_full
          ElseIf mode & #__align_right : right = #__align_full
          ElseIf mode & #__align_bottom : bottom = #__align_full
          Else
            left   = #__align_full
            top    = #__align_full
            right  = #__align_full
            bottom = #__align_full
          EndIf
        Else
          If left > 0 : left = #__align_full : EndIf
          If top > 0 : top = #__align_full : EndIf
          If right > 0 : right = #__align_full : EndIf
          If bottom > 0 : bottom = #__align_full : EndIf
        EndIf
      EndIf
      
      ;\\
      If left = #__align_full
        left   = #__align_auto
        top    = #True
        bottom = #True
        flag | #__align_full
      EndIf
      If right = #__align_full
        right  = #__align_auto
        top    = #True
        bottom = #True
        flag | #__align_full
      EndIf
      If top = #__align_full
        top   = #__align_auto
        left  = #True
        right = #True
        flag | #__align_full
      EndIf
      If bottom = #__align_full
        bottom = #__align_auto
        left   = #True
        right  = #True
        flag | #__align_full
      EndIf
      If mode And
         left > 0 And top > 0 And right > 0 And bottom > 0
        flag | #__align_full
      EndIf
      
      ;\\
      If mode & #__align_proportional
        If left = 0 And right = 0
          left  = #__align_proportional
          right = #__align_proportional
        EndIf
        If top = 0 And bottom = 0
          top    = #__align_proportional
          bottom = #__align_proportional
        EndIf
        
        If left And left <> #__align_proportional
          If right = 0
            left = 0
          EndIf
          right = #__align_proportional
        EndIf
        If top And top <> #__align_proportional
          If bottom = 0
            top = 0
          EndIf
          bottom = #__align_proportional
        EndIf
        If right And right <> #__align_proportional
          If left = 0
            right = 0
          EndIf
          left = #__align_proportional
        EndIf
        If bottom And bottom <> #__align_proportional
          If top = 0
            bottom = 0
          EndIf
          top = #__align_proportional
        EndIf
        
        If mode & #__align_right
          left = #__align_proportional
        EndIf
        
        If mode & #__align_left
          right = #__align_proportional
        EndIf
        
        If mode & #__align_top
          bottom = #__align_proportional
        EndIf
        
        If mode & #__align_bottom
          top = #__align_proportional
        EndIf
        
        mode = 0
      EndIf
      
      ;\\
      If *this\_parent( )
        If Not *this\_parent( )\align
          *this\_parent( )\align.allocate( ALIGN )
        EndIf
        If Not *this\align
          *this\align.allocate( ALIGN )
        EndIf
        
        ;\\
        If *this\align
          ;\\ horizontal
          If left Or ( Not right And flag & #__align_full = #__align_full )
            If left = #__align_proportional ;Or ( left And mode & #__align_proportional = #__align_proportional )
              *this\align\left = - 1
            Else
              *this\align\left = 1
            EndIf
          Else
            *this\align\left = 0
          EndIf
          If right Or ( Not left And flag & #__align_full = #__align_full )
            If right = #__align_proportional ;Or ( right And mode & #__align_proportional = #__align_proportional )
              *this\align\right = - 1
            Else
              *this\align\right = 1
            EndIf
          Else
            *this\align\right = 0
          EndIf
          
          ;\\ vertical
          If top Or ( Not bottom And flag & #__align_full = #__align_full )
            If top = #__align_proportional ;Or ( top And mode & #__align_proportional = #__align_proportional )
              *this\align\top = - 1
            Else
              *this\align\top = 1
            EndIf
          Else
            *this\align\top = 0
          EndIf
          If bottom Or ( Not top And flag & #__align_full = #__align_full )
            If bottom = #__align_proportional ;Or ( bottom And mode & #__align_proportional = #__align_proportional )
              *this\align\bottom = - 1
            Else
              *this\align\bottom = 1
            EndIf
          Else
            *this\align\bottom = 0
          EndIf
          
          ;\\ ?-надо тестировать
          If Not *this\_parent( )\align\width
            *this\_parent( )\align\x     = *this\_parent( )\x[#__c_container]
            *this\_parent( )\align\width = *this\_parent( )\width[#__c_frame]
            If *this\_parent( )\type = #__type_window
              *this\_parent( )\align\x + *this\_parent( )\fs
              *this\_parent( )\align\width - *this\_parent( )\fs * 2 - ( *this\_parent( )\fs[1] + *this\_parent( )\fs[3] )
            EndIf
          EndIf
          If Not *this\_parent( )\align\height
            *this\_parent( )\align\y      = *this\_parent( )\y[#__c_container]
            *this\_parent( )\align\height = *this\_parent( )\height[#__c_frame]
            If *this\_parent( )\type = #__type_window
              *this\_parent( )\align\y + *this\_parent( )\fs
              *this\_parent( )\align\height - *this\_parent( )\fs * 2 - ( *this\_parent( )\fs[2] + *this\_parent( )\fs[4] )
            EndIf
          EndIf
          
          ;\\
          If mode
            ;\\ full horizontal
            If *this\align\right And *this\align\left
              *this\align\x     = 0
              *this\align\width = *this\_parent( )\align\width
              If *this\type = #__type_window
                *this\align\width - *this\fs * 2
              EndIf
            Else
              *this\align\width = *this\width[#__c_frame]
              If Not *this\align\right And *this\align\left
                ; left
                *this\align\x = 0
              ElseIf Not *this\align\right And Not *this\align\left
                ; center
                *this\align\x = ( *this\_parent( )\align\width - *this\width[#__c_frame] ) / 2
              ElseIf *this\align\right And Not *this\align\left
                ; right
                *this\align\x = *this\_parent( )\align\width - *this\width[#__c_frame]
                If *this\type = #__type_window
                  *this\align\x - *this\fs * 2
                EndIf
              EndIf
            EndIf
            
            ;\\ full vertical
            If *this\align\bottom And *this\align\top
              *this\align\y      = 0
              *this\align\height = *this\_parent( )\align\height
              If *this\type = #__type_window
                *this\align\height - *this\fs * 2
              EndIf
            Else
              *this\align\height = *this\height[#__c_frame]
              If Not *this\align\bottom And *this\align\top
                ; top
                *this\align\y = 0
              ElseIf Not *this\align\bottom And Not *this\align\top
                ; center
                *this\align\y = ( *this\_parent( )\align\height - *this\height[#__c_frame] ) / 2
              ElseIf *this\align\bottom And Not *this\align\top
                ; bottom
                *this\align\y = *this\_parent( )\align\height - *this\height[#__c_frame]
                If *this\type = #__type_window
                  *this\align\y - *this\fs * 2
                EndIf
              EndIf
            EndIf
            
            ;
            ;\\ auto stick change
            If *this\_parent( )\align
              If left = #__align_auto And
                 *this\_parent( )\align\autodock\x
                left = - *this\_parent( )\align\autodock\x
              EndIf
              If right = #__align_auto And
                 *this\_parent( )\align\autodock\width
                right = - *this\_parent( )\align\autodock\width
              EndIf
              If left < 0 Or right < 0
                If left And right
                  *this\align\x - left
                  *this\align\width - *this\align\x + right
                Else
                  *this\align\x - left + right
                EndIf
              EndIf
              
              If top = #__align_auto And
                 *this\_parent( )\align\autodock\y
                top = - *this\_parent( )\align\autodock\y
              EndIf
              If bottom = #__align_auto And
                 *this\_parent( )\align\autodock\height
                bottom = - *this\_parent( )\align\autodock\height
              EndIf
              If top < 0 Or bottom < 0
                If top And bottom
                  *this\align\y - top
                  *this\align\height - *this\align\y + bottom
                Else
                  *this\align\y - top + bottom
                EndIf
              EndIf
            EndIf
            
            ;\\ auto stick position
            If Not *this\align\right And *this\align\left
              *this\_parent( )\align\autodock\x = *this\align\x + *this\align\width
              If *this\type = #__type_window
                *this\_parent( )\align\autodock\x + *this\fs * 2
              EndIf
            EndIf
            If Not *this\align\bottom And *this\align\top
              *this\_parent( )\align\autodock\y = *this\align\y + *this\align\height
              If *this\type = #__type_window
                *this\_parent( )\align\autodock\y + *this\fs * 2
              EndIf
            EndIf
            If Not *this\align\left And *this\align\right
              *this\_parent( )\align\autodock\width = *this\_parent( )\width[#__c_inner] - *this\align\x
            EndIf
            If Not *this\align\top And *this\align\bottom
              *this\_parent( )\align\autodock\height = *this\_parent( )\height[#__c_inner] - *this\align\y
            EndIf
            
            ;\\ auto stick update
            If flag & #__align_full = #__align_full
              If ( *this\_parent( )\align\autodock\x Or
                   *this\_parent( )\align\autodock\y Or
                   *this\_parent( )\align\autodock\width Or
                   *this\_parent( )\align\autodock\height )
                
                ; loop enumerate widgets
                If StartEnumerate( *this\_parent( ) )
                  If enumWidget( )\align
                    If enumWidget( )\align\top And enumWidget( )\align\bottom
                      enumWidget( )\align\y      = enumWidget( )\_parent( )\align\autodock\y
                      enumWidget( )\align\height = enumWidget( )\_parent( )\height[#__c_inner] - ( enumWidget( )\_parent( )\align\autodock\y + enumWidget( )\_parent( )\align\autodock\height )
                      
                      If enumWidget( )\align\left And enumWidget( )\align\right
                        enumWidget( )\align\x     = enumWidget( )\_parent( )\align\autodock\x
                        enumWidget( )\align\width = enumWidget( )\_parent( )\width[#__c_inner] - ( enumWidget( )\_parent( )\align\autodock\x + enumWidget( )\_parent( )\align\autodock\width )
                        
                        If enumWidget( )\type = #__type_window
                          enumWidget( )\align\width - enumWidget( )\fs * 2
                        EndIf
                      EndIf
                      
                      If enumWidget( )\type = #__type_window
                        enumWidget( )\align\height - enumWidget( )\fs * 2
                      EndIf
                    EndIf
                  EndIf
                  StopEnumerate( )
                EndIf
              EndIf
            EndIf
          EndIf
          
          ;\\
          If Not mode
            *this\align\x = *this\x[#__c_container]
            *this\align\y = *this\y[#__c_container]
            ;\\
            If *this\type = #__type_window
              *this\align\width  = *this\width[#__c_inner]
              *this\align\height = *this\height[#__c_inner]
            Else
              *this\align\width  = *this\width[#__c_frame]
              *this\align\height = *this\height[#__c_frame]
            EndIf
          EndIf
          
          ; update parent childrens coordinate
          Resize( *this\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
          PostCanvasRepaint( *this )
        EndIf
      EndIf
    EndProcedure
    
    ;-
    Procedure MoveBounds( *this._S_widget, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
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
    
    Procedure SizeBounds( *this._S_widget, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
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
        Select *this\type
          Case #__type_Tree,
               #__type_ListIcon,
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
        ProcedureReturn bar_tab_GetItemText( *this\TabBox( ), Item, Column )
      EndIf
      
      If ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        ProcedureReturn bar_tab_GetItemText( *this, Item, Column )
      EndIf
      
      If *this\count\items ; row count
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
         *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
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
         *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
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
        
        ProcedureReturn *this\_tabs( )\state\check
      EndIf
      
      If *this\type = #__type_Editor
        If item = - 1
          ProcedureReturn *this\edit_caret_2( )
        Else
          ProcedureReturn *this\edit_caret_1( )
        EndIf
        
      ElseIf *this\type = #__type_Tree Or *this\type = #__type_ListIcon
        
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
          If *this\_rows( )\color\state
            result | #PB_Tree_Selected
          EndIf
          
          If *this\_rows( )\checkbox\state\check
            If *this\mode\threestate And
               *this\_rows( )\checkbox\state\check = #PB_Checkbox_Inbetween
              result | #PB_Tree_Inbetween
            Else
              result | #PB_Tree_Checked
            EndIf
          EndIf
          
          If *this\_rows( )\childrens And
             *this\_rows( )\collapsebox\state\check = 0
            result | #PB_Tree_Expanded
          Else
            result | #PB_Tree_Collapsed
          EndIf
        EndIf
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemColor( *this._S_widget, Item.l, ColorType.l, Column.l = 0 )
      Protected result, *color._S_color
      
      Select *this\type
        Case #__type_Editor, #__type_Tree, #__type_ListIcon
          
          If is_item_( *this, item ) And
             SelectElement( *this\_rows( ), Item )
            *color = *this\_rows( )\color
          EndIf
        Default
          *color = *this\bar\button[Item]\color
      EndSelect
      
      Select ColorType
        Case #__color_line : result = *color\line[Column]
        Case #__color_back : result = *color\back[Column]
        Case #__color_front : result = *color\front[Column]
        Case #__color_frame : result = *color\frame[Column]
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemAttribute( *this._S_widget, Item.l, Attribute.l, Column.l = 0 )
      Protected result
      
      If *this\type = #__type_Tree Or *this\type = #__type_ListIcon
        
        If is_no_select_item_( *this\_rows( ), Item )
          ProcedureReturn #False
        EndIf
        
        If *this\type = #__type_Tree
          If Attribute = #PB_Tree_SubLevel
            result = *this\_rows( )\sublevel
          EndIf
        EndIf
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
        
        *this\TabChange( )         = #True
        *this\_tabs( )\text\string = Text.s
        *this\state\repaint        = #True
      EndIf
      
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_property
        
        ;Item = *this\row\i( Hex( Item ))
        
        If is_no_select_item_( *this\_rows( ), item )
          ProcedureReturn #False
        EndIf
        
        Protected row_count = CountString( Text.s, #LF$ )
        
        If Not row_count
          *this\_rows( )\text\string = Text.s
        Else
          *this\_rows( )\text\string      = StringField( Text.s, 1, #LF$ )
          *this\_rows( )\text\edit\string = StringField( Text.s, 2, #LF$ )
        EndIf
        
        *this\_rows( )\TextChange( ) = 1
        *this\WidgetChange( )        = 1
        result                       = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText( *this\TabBox( ), Item, Text, Column )
        
      ElseIf ( *this\type = #__type_TabBar Or *this\type = #__type_ToolBar )
        If is_item_( *this, Item ) And
           SelectElement( *this\_tabs( ), Item ) And
           *this\_tabs( )\text\string <> Text
          *this\_tabs( )\text\string   = Text
          *this\_tabs( )\TextChange( ) = 1
          *this\WidgetChange( )        = 1
          result                       = #True
        EndIf
        
      Else
      EndIf
      
      If *this\state\repaint = #True
        PostCanvasRepaint( *this )
        *this\state\repaint = #False
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemImage( *this._S_widget, Item.l, Image.i )
      Protected result
      
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
        If is_item_( *this, item ) And SelectElement( *this\_rows( ), Item )
          If *this\_rows( )\image\img <> Image
            set_image_( *this, *this\_rows( )\Image, Image )
            *this\WidgetChange( ) = 1
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont( *this._S_widget, Item.l, Font.i )
      Protected result, FontID.i = FontID( Font )
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        
        If is_item_( *this, item ) And
           SelectElement( *this\_rows( ), Item ) And
           *this\_rows( )\text\fontID <> FontID
          *this\_rows( )\text\fontID = FontID
          ;       *this\_rows( )\TextChange( ) = 1
          ;       *this\WidgetChange( ) = 1
          result = #True
        EndIf
        
      ElseIf *this\type = #__type_Panel Or
             *this\type = #__type_TabBar
        
        Protected *TabBar._S_widget
        If *this\type = #__type_Panel
          *TabBar = *this\TabBox( )
        EndIf
        If *this\type = #__type_TabBar
          *TabBar = *this
        EndIf
        
        If is_item_( *TabBar, item ) And
           SelectElement( *TabBar\_tabs( ), Item ) And
           *TabBar\_tabs( )\text\fontID <> FontID
          *TabBar\_tabs( )\text\fontID = FontID
          ;       *this\_rows( )\TextChange( ) = 1
          ;       *this\WidgetChange( ) = 1
          result = #True
        EndIf
        
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState( *this._S_widget, Item.l, State.b )
      Protected result
      
      If *this\type = #__type_TabBar Or
         *this\type = #__type_ToolBar
        
        If is_no_select_item_( *this\_tabs( ), Item )
          ProcedureReturn #False
        EndIf
        
        If State & #PB_Tree_Selected = #PB_Tree_Selected
          If bar_tab_SetState( *this, Item )
            *this\state\repaint = #True
          EndIf
        EndIf
        
        ; ???????????????????????
        ;         If State & #pb_tree_inbetween = #pb_tree_inbetween
        ;           *this\_tabs( )\checkbox\state\check = #PB_Checkbox_Inbetween
        ;         ElseIf State & #pb_tree_checked = #pb_tree_checked
        ;           *this\_tabs( )\checkbox\state\check = #PB_Checkbox_Checked
        ;         EndIf
        
      EndIf
      
      ; - widget::windowset_item_state( )
      If *this\type = #__type_window
        ; result = Window_SetState( *this, state )
        
        ; - widget::editorset_item_state( )
      ElseIf *this\type = #__type_Editor
        result = edit_SetItemState( *this, Item, state )
        
        ;- widget::treeset_item_state( )
      ElseIf *this\type = #__type_Tree Or *this\type = #__type_ListIcon
        
        If *this\count\items
          If is_no_select_item_( *this\_rows( ), Item )
            ProcedureReturn #False
          EndIf
          
          Protected *this_current_row._S_rows = *this\_rows( )
          
          If State & #PB_Tree_Selected = #PB_Tree_Selected
            If *this\FocusedRow( ) <> *this\_rows( )
              *this\FocusedRow( )             = *this\_rows( )
              *this\FocusedRow( )\state\focus = - 1
              *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
          EndIf
          
          If State & #PB_Tree_Inbetween = #PB_Tree_Inbetween
            *this\_rows( )\checkbox\state\check = #PB_Checkbox_Inbetween
          ElseIf State & #PB_Tree_Checked = #PB_Tree_Checked
            *this\_rows( )\checkbox\state\check = #PB_Checkbox_Checked
          EndIf
          
          If *this\_rows( )\childrens
            If State & #PB_Tree_Expanded = #PB_Tree_Expanded Or
               State & #PB_Tree_Collapsed = #PB_Tree_Collapsed
              
              *this\WidgetChange( )                  = #True
              *this\_rows( )\collapsebox\state\check = Bool( State & #PB_Tree_Collapsed )
              
              PushListPosition( *this\_rows( ))
              While NextElement( *this\_rows( ))
                If *this\_rows( )\ParentRow( )
                  *this\_rows( )\hide = Bool( *this\_rows( )\ParentRow( )\collapsebox\state\check | *this\_rows( )\ParentRow( )\hide )
                EndIf
                
                If *this\_rows( )\sublevel = *this_current_row\sublevel
                  *this\state\repaint = #True
                  Break
                EndIf
              Wend
              PopListPosition( *this\_rows( ))
            EndIf
          EndIf
          
          result = *this_current_row\collapsebox\state\check
        EndIf
        
        ; - widget::panelset_item_state( )
      ElseIf *this\type = #__type_Panel
        ; result = Panel_SetItemState( *this, state )
        
      Else
        ; result = bar_SetState( *this, state )
      EndIf
      
      If *this\state\repaint = #True
        PostCanvasRepaint( *this )
        *this\state\repaint = #False
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetItemColor( *this._S_widget, Item.l, ColorType.l, Color.l, Column.l = 0 )
      Protected result, alpha.a
      
      ;
      If *this\row And ListSize( *this\_rows( ) ) ;*this\type = #__type_Tree Or *this\type = #__type_Editor
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
        
      ElseIf *this\type = #__type_Tree Or *this\type = #__type_ListIcon
        
        Select Attribute
          Case #__tree_OptionBoxes
            *this\mode\check = Bool( *value ) * #__m_clickselect
            
          Case #PB_Tree_Collapsed
            *this\mode\collapsed = Bool( Not *value )
            
          Case #PB_Tree_SubLevel
            If is_no_select_item_( *this\_rows( ), Item )
              ProcedureReturn #False
            EndIf
            
            *this\_rows( )\sublevel = *value
            
        EndSelect
        
      ElseIf *this\type = #__type_Editor
        
      ElseIf *this\type = #__type_Panel
        
      Else
      EndIf
      
      
      ProcedureReturn result
    EndProcedure
    
    
    ;-
    ;-  CREATEs
    Procedure.i Create( *parent._S_widget, class.s, type.l, x.l, y.l, width.l, height.l, Text.s = #Null$, flag.q = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 0, ScrollStep.f = 1.0 )
      Protected *root._s_root = Root( )  ; @*canvas\_roots( ) ;
      If *root\canvas\ResizeBeginWidget
        ; Debug "   end - resize " + #PB_Compiler_Procedure
        Post( *root\canvas\ResizeBeginWidget, #__event_ResizeEnd )
        *root\canvas\ResizeBeginWidget = #Null
      EndIf
      
      Protected color, image;, *this.allocate( Widget )
      
      Protected *this._S_widget
      If Flag & #__flag_autosize = #__flag_autosize And
         Not ListSize(EnumWidget( ))
        x              = 0
        y              = 0
        width          = *root\width
        height         = *root\height
        *root\autosize = #True
        *this          = *root
      Else
        *this.allocate( Widget )
      EndIf
      
      ;\\
      *this\color         = _get_colors_( )
      *this\type          = type
      *this\class         = class
      *this\round         = round
      *this\state\create  = #True
      *this\state\repaint = #True
      
      *this\x[#__c_frame]      = #PB_Ignore
      *this\y[#__c_frame]      = #PB_Ignore
      *this\width[#__c_frame]  = #PB_Ignore
      *this\height[#__c_frame] = #PB_Ignore
      
      ;\\ replace pb flag
      flag = FromPBFlag( *this\type, flag )
      
      ;\\ Flags
      *this\flag = Flag
      If *this\type = #__type_Button
        *this\flag | #__text_center
        
      ElseIf *this\type = #__type_ComboBox Or
             *this\type = #__type_Spin Or
             *this\type = #__type_String Or
             *this\type = #__type_Option Or
             *this\type = #__type_CheckBox
        
        If Not flag & #__text_center
          *this\flag | #__text_center | #__text_left
        EndIf
        
        If *this\type = #__type_CheckBox And Flag & #PB_CheckBox_Right
          *this\flag & ~ #__text_left
          *this\flag | #__text_right
        EndIf
      EndIf
      
      ;\\ Border & Frame size
      If *this\type = #__type_TabBar Or
         *this\type = #__type_ToolBar
        
        If *this\child
          *this\fs = *parent\fs
        Else
          *this\fs = #__border_scroll
        EndIf
      EndIf
      If *this\type = #__type_ScrollArea Or
         *this\type = #__type_MDI Or
         *this\type = #__type_String Or
         *this\type = #__type_Editor Or
         *this\type = #__type_Tree Or
         *this\type = #__type_ListView Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ExplorerList Or
         *this\type = #__type_Property
        ;
        If Not *this\Flag & #__flag_borderLess
          *this\fs = #__border_scroll
        EndIf
      Else
        If *this\type = #__type_Container Or
           *this\type = #__type_ComboBox Or
           *this\type = #__type_Spin Or
           *this\type = #__type_Button Or
           *this\type = #__type_Panel Or
           *this\type = #__type_Frame
          
          ;
          If *this\Flag & #__flag_borderLess
          Else
            *this\fs = 1
            ;             If *this\flag = #__flag_Single
            ;             ElseIf *this\flag = #__flag_Double
            ;             ElseIf *this\flag = #__flag_Flat
            ;             ElseIf *this\flag = #__flag_Raised
            ;             Else
            ;             EndIf
          EndIf
        EndIf
      EndIf
      If *this\type = #__type_Text
        *this\fs = Bool( Flag & #PB_Text_Border = #PB_Text_Border )
      EndIf
      *this\bs = *this\fs
      
      *this\child = Bool( Flag & #__flag_child = #__flag_child )
      
      ;\\
      If *parent
        ;\\
        If flag & #__flag_autosize = #__flag_autosize
          If *parent\type <> #__type_Splitter
            *this\autosize = 1
            ; set transparent parent
            *parent\color\back      = - 1
            *parent\color\_alpha    = 0
            *parent\color\_alpha[1] = 0
          EndIf
        EndIf
        
        ;\\
        If *this\child
          *this\_parent( ) = *parent
          *this\_root( )   = *parent\_root( )
          *this\_window( ) = *parent\_window( )
          ;
          *this\index   = *parent\index
          *this\address = *parent\address
          ; Debug  "Create(child) "+ *this\type
        Else
          ; AddWidget( *this, *parent )
          SetParent( *this, *parent, #PB_Default )
        EndIf
      EndIf
      
      ;\\ - Create Texts
      If *this\type = #__type_Text Or
         *this\type = #__type_Editor Or
         *this\type = #__type_String Or
         *this\type = #__type_Button Or
         *this\type = #__type_Option Or
         *this\type = #__type_CheckBox Or
         *this\type = #__type_HyperLink
        
        *this\row.allocate( ROW )
        *this\FocusedLineIndex( ) = - 1
        *this\EnteredLineIndex( ) = - 1
        
        
        ;\\ - Create Text
        If *this\type = #__type_Text
          *this\color\fore  = - 1
          *this\color\back  = _get_colors_( )\fore
          *this\color\front = _get_colors_( )\front
          If *this\fs
            *this\color\frame = _get_colors_( )\frame
          EndIf
          
          *this\text\x         = 1
          *this\text\multiline = - 1
        EndIf
        
        ;\\ - Create Editor
        If *this\type = #__type_Editor
          *this\text\padding\y = 3
          *this\text\padding\x = 3
          
          *this\mode\fullselection = constants::_check_( *this\flag, #__flag_fullselection, #False ) * 7
          *this\mode\gridlines     = constants::_check_( *this\flag, #__flag_gridlines ) * 10
          
          *this\row\margin\hide        = constants::_check_( *this\flag, #__text_numeric, #False )
          *this\row\margin\color\front = $C8000000 ; *this\color\back[0]
          *this\row\margin\color\back  = $C8F0F0F0 ; *this\color\back[0]
        EndIf
        
        ;\\ - Create String
        If *this\type = #__type_String
          *this\text\padding\x = 3
          *this\text\padding\y = 0
          *this\text\caret\x   = *this\text\padding\x
        EndIf
        
        ; - Create Button
        If *this\type = #__type_Button
          *this\text\padding\x = 4
          *this\text\padding\y = 4
        EndIf
        
        If *this\type = #__type_Option
          ;\\
          If *this\before\widget
            If *this\before\widget\type = #__type_Option
              *this\GroupBox( ) = *this\before\widget\GroupBox( )
            Else
              *this\GroupBox( ) = *this\before\widget
            EndIf
          Else
            *this\GroupBox( ) = *parent
          EndIf
          
          ;       *this\color\back =- 1; _get_colors_( ); - 1
          ;       *this\color\fore =- 1
          
          *this\color\fore  = - 1
          *this\color\back  = _get_colors_( )\fore
          *this\color\front = _get_colors_( )\front
          
          *this\_box_.allocate( BUTTONS )
          *this\_box_\color      = _get_colors_( )
          *this\_box_\color\back = $ffffffff
          
          *this\_box_\round    = 7
          *this\_box_\width    = 15
          *this\_box_\height   = *this\_box_\width
          *this\text\padding\x = *this\_box_\width + 8
        EndIf
        
        If *this\type = #__type_CheckBox
          *this\mode\threestate = constants::_check_( Flag, #PB_CheckBox_ThreeState )
          
          *this\color\fore  = - 1
          *this\color\back  = _get_colors_( )\fore
          *this\color\front = _get_colors_( )\front
          
          *this\_box_.allocate( BUTTONS )
          *this\_box_\color      = _get_colors_( )
          *this\_box_\color\back = $ffffffff
          
          *this\_box_\round    = 2
          *this\_box_\height   = 15
          *this\_box_\width    = *this\_box_\height
          *this\text\padding\x = *this\_box_\width + 8
        EndIf
        
        If *this\type = #__type_HyperLink
          Color = *param_1
          
          *this\mode\lines = constants::_check_( Flag, #PB_HyperLink_Underline )
          
          *this\color\fore[#__S_0]  = - 1
          *this\color\back[#__S_0]  = _get_colors_( )\fore
          *this\color\front[#__S_0] = _get_colors_( )\front
          
          If Not Alpha( Color )
            Color = Color & $FFFFFF | 255 << 24
          EndIf
          *this\color\front[#__S_1] = Color
        EndIf
        
      EndIf
      
      ;\\ - Create Lists
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListView Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ExplorerList Or
         *this\type = #__type_Property
        
        ;*this\fs[1] = 50
        ;*this\fs[2] = 50
        ;*this\fs[3] = 50
        ;*this\fs[4] = 50
        *this\color\fore    = 0
        *this\color\back[0] = $FFFFFFFF
        
        *this\row.allocate( ROW )
        ;
        *this\FocusedLineIndex( ) = - 1
        
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
        
        *this\color\_alpha        = 255
        *this\color\fore[#__S_0]  = - 1
        *this\color\back[#__S_0]  = $ffffffff ; _get_colors_( )\fore
        *this\color\front[#__S_0] = _get_colors_( )\front
        *this\color\frame[#__S_0] = _get_colors_( )\frame
        
        ;Row( *this )\index =- 1
        *this\WidgetChange( ) = 1
        
        *this\interact = 1
        ;*this\round = round
        
        *this\TextChange( ) = 1
        *this\text\height   = 18
        
        *this\image\padding\x = 2
        *this\text\padding\x  = 4
        
        If Flag & #__tree_multiselect = #__tree_multiselect
          *this\mode\check = #__m_multiselect
        EndIf
        
        If flag & #__tree_nolines
          flag & ~ #__tree_nolines
        Else
          flag | #__tree_nolines
        EndIf
        
        If flag & #__tree_NoButtons
          flag & ~ #__tree_NoButtons
        Else
          flag | #__tree_NoButtons
        EndIf
        
        If flag
          Flag( *this, flag, #True )
        EndIf
      EndIf
      
      ;\\ - Create Containers
      If *this\type = #__type_Container Or
         *this\type = #__type_ScrollArea Or
         *this\type = #__type_Panel Or
         *this\type = #__type_MDI Or
         *this\type = #__type_Frame
        
        *this\container  = *this\type
        *this\color\back = $FFF9F9F9
        
        ;\\
        If *this\type = #__type_Frame
          *this\color\back = $96D8D8D8
          
          If Text
            *this\fs[2] = 8
          EndIf
          
          set_text_flag_( *this, text, flag, 12, - *this\fs[2] - 1 )
        EndIf
        
        ;\\
        If *this\type = #__type_Panel
          If Flag & #__bar_vertical = #False
            *this\fs[2] = #__panel_height
          Else
            *this\fs[1] = #__panel_width
          EndIf
          
          *this\TabBox( ) = Create( *this, *this\class + "_TabBar", #__type_TabBar, 0, 0, 0, 0, #Null$, Flag | #__flag_child, 0, 0, 0, 0, 0, 30 )
        EndIf
        
        ;\\ Open gadget list
        If *this\container And
           *this\flag & #__flag_nogadgets = #False
          OpenList( *this )
        EndIf
      EndIf
      
      ;\\ - Create Bars
      If *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_TabBar Or
         *this\type = #__type_ToolBar Or
         *this\type = #__type_Spin Or
         *this\type = #__type_Splitter
        
        *this\bar.allocate( BAR )
        *this\bar\button.allocate( BUTTONS )
        *this\bar\button.allocate( BUTTONS, [1] )
        *this\bar\button.allocate( BUTTONS, [2] )
        
        *this\bar\PageChange( ) = 1
        *this\scroll\increment  = ScrollStep
        Protected._s_BUTTONS *BB1, *BB2, *SB
        *SB  = *this\bar\button
        *BB1 = *this\bar\button[1]
        *BB2 = *this\bar\button[2]
        
        ; - Create Scroll
        If *this\type = #__type_ScrollBar
          *this\color\back  = $FFF9F9F9 ; - 1
          *this\color\front = $FFFFFFFF
          
          *this\bar\invert   = Bool( Flag & #__bar_invert = #__bar_invert )
          *this\bar\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                     Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical )
          
          If *this\bar\vertical
            *this\class = class + "-v"
          Else
            *this\class = class + "-h"
          EndIf
          
          *BB1\color = _get_colors_( )
          *BB2\color = _get_colors_( )
          *SB\color  = _get_colors_( )
          
          ;
          If Not Flag & #__flag_nobuttons = #__flag_nobuttons
            *BB1\size = - 1
            *BB2\size = - 1
          EndIf
          *SB\size = size
          
          ;
          *BB1\interact = #True
          *BB2\interact = #True
          *SB\interact  = #True
          
          *BB1\round = *this\round
          *BB2\round = *this\round
          *SB\round  = *this\round
          
          *BB1\arrow\type = #__arrow_type ; -1 0 1
          *BB2\arrow\type = #__arrow_type ; -1 0 1
          
          *BB1\arrow\size = #__arrow_size
          *BB2\arrow\size = #__arrow_size
          *SB\arrow\size  = 3
        EndIf
        
        ; - Create Spin
        If *this\type = #__type_Spin
          *this\color\back   = - 1
          *this\color\_alpha = 255
          *this\color\back   = $FFFFFFFF
          
          *BB1\color = _get_colors_( )
          *BB2\color = _get_colors_( )
          ;*SB\color = _get_colors_( )
          
          ;
          *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
          
          If *this\flag & #__spin_Plus
            If ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
              *this\bar\vertical = #True
            EndIf
            *this\flag = flag | #__text_center
          Else
            If Not ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
              *this\bar\vertical = #True
              *this\bar\invert   = #True
            EndIf
            
            *BB1\arrow\size = #__arrow_size
            *BB2\arrow\size = #__arrow_size
            
            *BB1\arrow\type = #__arrow_type ; -1 0 1
            *BB2\arrow\type = #__arrow_type ; -1 0 1
          EndIf
          
          
          *BB1\interact = #True
          *BB2\interact = #True
          ;*SB\interact = #True
          
          *this\StringBox( ) = String(0, 0, 0, 0, "0", Flag | #__text_numeric | #__flag_child | #__flag_borderless )
        EndIf
        
        ; - Create Track
        If *this\type = #__type_TrackBar
          *this\color\back = - 1
          *BB1\color       = _get_colors_( )
          *BB2\color       = _get_colors_( )
          *SB\color        = _get_colors_( )
          
          *this\bar\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                     Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical )
          
          ;           If *this\bar\vertical
          ;             *this\bar\invert = Bool( Flag & #__bar_invert = 0 )
          ;           Else
          *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
          ;           EndIf
          
          ;             If flag & #PB_Trackbar_Ticks = #PB_Trackbar_Ticks
          ;               *this\flag | #PB_Trackbar_Ticks
          ;             EndIf
          
          *BB1\interact = #True
          *BB2\interact = #True
          *SB\interact  = #True
          
          *SB\arrow\size = #__arrow_size
          *SB\arrow\type = #__arrow_type
          
          *BB1\round = 2
          *BB2\round = 2
          *SB\round  = *this\round
          
          If *this\round < 7
            *SB\size = 9
          Else
            *SB\size = 15
          EndIf
          
          ; button draw color
          *SB\state\focus = 1
          *SB\color\state = #__S_2
          
          If Not *this\flag & #PB_TrackBar_Ticks
            If *this\bar\invert
              *BB2\state\focus = 1
              *BB2\color\state = #__S_2
            Else
              *BB1\state\focus = 1
              *BB1\color\state = #__S_2
            EndIf
          EndIf
        EndIf
        
        ; - Create Tab
        If *this\type = #__type_TabBar Or
           *this\type = #__type_ToolBar
          
          ;;*this\TextChange( ) = 1
          *this\color\back = - 1
          *BB1\color       = _get_colors_( )
          *BB2\color       = _get_colors_( )
          ;*SB\color = _get_colors_( )
          
          *this\bar\invert   = Bool( Flag & #__bar_invert = #False )
          *this\bar\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical )
          
          If Not Flag & #__bar_buttonsize = #__bar_buttonsize
            *SB\size  = size
            *BB1\size = 15
            *BB2\size = 15
          EndIf
          
          *BB1\interact = #True
          *BB2\interact = #True
          *SB\interact  = #True
          
          *BB1\round = 7
          *BB2\round = 7
          *SB\round  = *this\round
          
          *BB1\arrow\type = -1 ; -1 0 1
          *BB2\arrow\type = -1 ; -1 0 1
          
          *BB1\arrow\size = #__arrow_size
          *BB2\arrow\size = #__arrow_size
          ;*SB\arrow\size = 3
        EndIf
        
        ; - Create Progress
        If *this\type = #__type_ProgressBar
          *this\bar\vertical = Bool( Flag & #__bar_vertical = #__bar_vertical Or
                                     Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical )
          
          *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
          ;           If *this\bar\vertical
          ;             *this\bar\invert = Bool( Flag & #__bar_invert = 0 )
          ;           Else
          ;             *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
          ;           EndIf
          
          *this\color         = _get_colors_( )
          *this\TextChange( ) = #True
          
          ;           *BB1\round = *this\round
          ;           *BB2\round = *this\round
          ; ;           *BB1\color = *this\color
          ; ;           *BB2\color = *this\color
          ; ;           ;*SB\color = *this\color
        EndIf
        
        ; - Create Splitter
        If *this\type = #__type_Splitter
          *this\color\back = - 1
          
          *this\bar\invert   = Bool( Flag & #__bar_invert = #__bar_invert )
          *this\bar\vertical = Bool( Flag & #__bar_vertical = #False And Flag & #PB_Splitter_Vertical = #False )
          
          If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
            *this\bar\fixed = #PB_Splitter_FirstMinimumSize
          ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
            *this\bar\fixed = #PB_Splitter_SecondMinimumSize
          EndIf
          
          ;\\
          If *param_1 >= 0
            *this\splitter_gadget_1( ) = *param_1
          EndIf
          If *param_2 >= 0
            *this\splitter_gadget_2( ) = *param_2
          EndIf
          
          *this\splitter_is_gadget_1( ) = Bool( PB(IsGadget)( *param_1 ))
          *this\splitter_is_gadget_2( ) = Bool( PB(IsGadget)( *param_2 ))
          
          *this\bar\button[1]\hide = Bool( *this\splitter_is_gadget_1( ) Or *this\splitter_gadget_1( ) )
          *this\bar\button[2]\hide = Bool( *this\splitter_is_gadget_2( ) Or *this\splitter_gadget_2( ) )
          *SB\size                 = #__splitter_buttonsize
          *SB\interact             = #True
          *SB\round                = 2
          
          ;\\
          ; If *this\type = #__type_Splitter
          If *this\splitter_is_gadget_1( )
            Debug "bar_is_first_gadget_ " + *this\splitter_is_gadget_1( )
            parent::set( *this\splitter_gadget_1( ), *this\_root( )\canvas\address )
          ElseIf *this\splitter_gadget_1( )
            SetParent( *this\splitter_gadget_1( ), *this )
          EndIf
          
          If *this\splitter_is_gadget_2( )
            Debug "bar_is_second_gadget_ " + *this\splitter_is_gadget_2( )
            parent::set( *this\splitter_gadget_2( ), *this\_root( )\canvas\address )
          ElseIf *this\splitter_gadget_2( )
            SetParent( *this\splitter_gadget_2( ), *this )
          EndIf
          ; EndIf
          
        EndIf
        
      EndIf
      
      ;\\ - Create image
      If *this\type = #__type_Image
        *this\color\back = $FFF9F9F9
      EndIf
      
      ;\\ - Create ComboBox
      If *this\type = #__type_ComboBox
        ;*this\round = 16
        
        *this\_box_.allocate( BUTTONS )
        *this\_box_\color           = _get_colors_( )
        *this\_box_\arrow\direction = 2
        
        ;\\
        If *this\flag & #PB_ComboBox_Editable
          *this\StringBox( ) = String(0, 0, 0, 0, "", Flag | #__flag_child | #__flag_borderless )
          *this\fs[3]        = 17
        EndIf
        
        ;\\
        *this\PopupBox( ) = Create( 0, *this\class + "_ListView", #__type_ListView, 0, 0, 0, 0, #Null$, Flag | #__flag_child | #__flag_borderless )
        ;;*this\PopupBox( ) = ListView(0, 0, width, height, #__flag_child);|#__flag_borderless )
        
        *this\PopupBox( )\hide = 1
      EndIf
      
      ;\\ Set Attribute
      If *this\type = #__type_ScrollBar Or
         *this\type = #__type_ProgressBar Or
         *this\type = #__type_TrackBar Or
         *this\type = #__type_TabBar Or
         *this\type = #__type_ToolBar Or
         *this\type = #__type_Spin
        
        If *this\type = #__type_Spin
          bar_SetAttribute( *this, #__bar_buttonsize, Size )
        EndIf
        
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
      
      ;\\ Set image
      If *this\type = #__type_Image Or
         *this\type = #__type_Button
        
        Image = *param_1
        set_image_( *this, *this\Image, Image )
        set_image_( *this, *this\image[#__image_released], Image )
        
        *this\image\align\left   = constants::_check_( *this\flag, #__image_left )
        *this\image\align\right  = constants::_check_( *this\flag, #__image_right )
        *this\image\align\top    = constants::_check_( *this\flag, #__image_top )
        *this\image\align\bottom = constants::_check_( *this\flag, #__image_bottom )
        
        If Not *this\image\align\top And
           Not *this\image\align\left And
           Not *this\image\align\right And
           Not *this\image\align\bottom And
           Not constants::_check_( *this\flag, #__image_center )
          
          If Not *this\image\align\right
            *this\flag | #__image_left
            *this\image\align\left = #True
          EndIf
          If Not *this\image\align\bottom
            *this\flag | #__image_top
            *this\image\align\top = #True
          EndIf
        EndIf
      EndIf
      
      ;\\ Cursor
      If *this\type = #__type_Editor Or
         *this\type = #__type_String
        *this\cursor = #PB_Cursor_IBeam
      EndIf
      If *this\type = #__type_HyperLink
        *this\cursor = #PB_Cursor_Hand
      EndIf
      If *this\type = #__type_Splitter
        If *this\bar\vertical
          *this\cursor = #PB_Cursor_UpDown
        Else
          *this\cursor = #PB_Cursor_LeftRight
        EndIf
      EndIf
      
      ;\\
      If *this\row
        ;  If *this\type = #__type_ListIcon
        AddColumn( *this, 0, Text, *param_1 )
        ; EndIf
      EndIf
      
      ;\\ Scroll bars
      If flag & #__flag_noscrollbars = #False
        If *this\type = #__type_Editor Or
           *this\type = #__type_String Or
           *this\type = #__type_Tree Or
           *this\type = #__type_ListView Or
           *this\type = #__type_ListIcon Or
           *this\type = #__type_ExplorerList Or
           *this\type = #__type_Property
          
          bar_area_create_( *this, 1, 0, 0, 0, 0, Bool(( *this\mode\buttons = 0 And *this\mode\lines = 0 ) = 0 ))
        ElseIf *this\type = #__type_MDI Or
               *this\type = #__type_Image Or
               *this\type = #__type_ScrollArea
          If *this\type = #__type_Image
            bar_area_create_( *this, 1, *this\image\width, *this\image\height, 0, 0 )
          Else
            bar_area_create_( *this, 1, *param_1, *param_2, 0, 0 )
          EndIf
        EndIf
      EndIf
      
      ;\\ Resize
      If *this\child
        
        If *this\type = #__type_ScrollBar
          If *this\bar\vertical
            *this\width[#__c_frame]     = width
            *this\width[#__c_container] = width
            *this\width[#__c_screen]    = width + ( *this\bs * 2 - *this\fs * 2 )
            If *this\width[#__c_container] < 0
              *this\width[#__c_container] = 0
            EndIf
            *this\width[#__c_inner] = *this\width[#__c_container]
          Else
            *this\height[#__c_frame]     = height
            *this\height[#__c_container] = height
            *this\height[#__c_screen]    = height + ( *this\bs * 2 - *this\fs * 2 )
            If *this\height[#__c_container] < 0
              *this\height[#__c_container] = 0
            EndIf
            *this\height[#__c_inner] = *this\height[#__c_container]
          EndIf
        EndIf
        
      Else
        Resize( *this, x, y, width, height )
      EndIf
      
      ;\\
      If *this\row
        set_text_flag_( *this, text, *this\flag )
      EndIf
      
      ;; Debug ""+*this\class+" "+*this\_root( )
      PostCanvasRepaint( *this, #__event_Create)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab( x.l, y.l, width.l, height.l, flag.q = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_TabBar, x, y, width, height, #Null$, flag, 0, 0, 0, 40, round, 40 )
    EndProcedure
    
    Procedure.i Spin( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0, Increment.f = 1.0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Spin, x, y, width, height, #Null$, flag, min, max, 0, #__spin_barsize, round, Increment )
    EndProcedure
    
    Procedure.i Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ScrollBar, x, y, width, height, #Null$, flag, min, max, pagelength, #__scroll_buttonsize, round, 1 )
    EndProcedure
    
    Procedure.i Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 7 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_TrackBar, x, y, width, height, #Null$, flag, min, max, 0, 0, round, 1 )
    EndProcedure
    
    Procedure.i Progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ProgressBar, x, y, width, height, #Null$, flag, min, max, 0, 0, round, 1 )
    EndProcedure
    
    Procedure.i Splitter( x.l, y.l, width.l, height.l, First.i, Second.i, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Splitter, x, y, width, height, #Null$, flag, First, Second, 0, 0, 0, 1 )
    EndProcedure
    
    
    ;-
    Procedure.i Tree( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Tree, x, y, width, height, "", Flag )
    EndProcedure
    
    Procedure.i ListView( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ListView, x, y, width, height, "", Flag | #__tree_nobuttons | #__tree_nolines )
    EndProcedure
    
    Procedure.i ListIcon( x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.i, flag.q = 0 )
      ;  ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_tree, x, y, width, height, "", Flag ); #__type_ListIcon
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ListIcon, x, y, width, height, ColumnTitle, Flag, ColumnWidth ); #__type_ListIcon
    EndProcedure
    
    Procedure.i ExplorerList( x.l, y.l, width.l, height.l, Directory.s, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ExplorerList, x, y, width, height, "", Flag | #__tree_nobuttons | #__tree_nolines )
    EndProcedure
    
    Procedure.i Tree_properties( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Property, x, y, width, height, "", Flag )
    EndProcedure
    
    
    ;-
    Procedure.i Editor( x.l, Y.l, width.l, height.l, flag.q = 0, round.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Editor, x, y, width, height, "", flag, 0, 0, 0, 0, round, 0 )
    EndProcedure
    
    Procedure.i String( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_String, x, y, width, height, Text, flag, 0, 0, 0, 0, round, 0 )
    EndProcedure
    
    Procedure.i Text( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Text, x, y, width, height, Text, flag, 0, 0, 0, 0, round, 0 )
    EndProcedure
    
    Procedure.i Button( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, Image.i = -1, round.l = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Button, x, y, width, height, Text, flag, Image, 0, 0, 0, round )
    EndProcedure
    
    Procedure.i Option( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Option, x, y, width, height, Text, flag, 0, 0, 0, 0, 0, 0 )
    EndProcedure
    
    Procedure.i Checkbox( x.l, y.l, width.l, height.l, Text.s, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_CheckBox, x, y, width, height, Text, flag, 0, 0, 0, 0, 0, 0 )
    EndProcedure
    
    Procedure.i HyperLink( x.l, y.l, width.l, height.l, Text.s, Color.i, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_HyperLink, x, y, width, height, Text, flag, Color, 0, 0, 0, 0, 0 )
    EndProcedure
    
    Procedure.i ButtonImage( x.l, y.l, width.l, height.l, Image.i = -1 , flag.q = 0, round.l = 0 )
      Button( x, y, width, height, "", Flag, Image, round )
      widget( )\type = #__type_ButtonImage
      ProcedureReturn widget( )
    EndProcedure
    
    Procedure.i ComboBox( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ComboBox, x, y, width, height, "", flag, 0, 0, 0, 0, 0, 0 )
    EndProcedure
    
    ;-
    Procedure.i MDI( x.l, y.l, width.l, height.l, flag.q = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_MDI, x, y, width, height, #Null$, flag | #__flag_nogadgets, 0, 0, 0, #__scroll_buttonsize, 0, 1 )
    EndProcedure
    
    Procedure.i Panel( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Panel, x, y, width, height, #Null$, flag | #__flag_noscrollbars, 0, 0, 0, #__scroll_buttonsize, 0, 0 )
    EndProcedure
    
    Procedure.i Container( x.l, y.l, width.l, height.l, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Container, x, y, width, height, #Null$, flag | #__flag_noscrollbars, 0, 0, 0, #__scroll_buttonsize, 0, 0 )
    EndProcedure
    
    Procedure.i ScrollArea( x.l, y.l, width.l, height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, flag.q = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_ScrollArea, x, y, width, height, #Null$, flag, ScrollAreaWidth, ScrollAreaHeight, 0, #__scroll_buttonsize, 0, ScrollStep )
    EndProcedure
    
    Procedure.i Frame( x.l, y.l, width.l, height.l, Text.s, flag.q = #__flag_nogadgets )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Frame, x, y, width, height, Text, flag, 0, 0, 0, 0, 7 )
    EndProcedure
    
    Procedure.i Image( x.l, y.l, width.l, height.l, image.i, flag.q = 0 ) ; , Menu.i, SubMenu.l, FirstMenuItem.l )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Image, x, y, width, height, #Null$, flag, image, 0, 0, #__scroll_buttonsize, 0, 1 )
    EndProcedure
    
    ;-
    Procedure ToolBar( *parent._S_widget, flag.q = #PB_ToolBar_Small )
      ProcedureReturn ListView( 0, 0, *parent\width[#__c_inner], 20, flag )
    EndProcedure
    
    Procedure ToolTip( *this._S_widget, Text.s, item = - 1 )
      *this\_tt\text\string = Text
    EndProcedure
    
    ;-
    ;-  DRAWINGs
    Procedure.l Draw_ListIcon( *this._S_widget )
      Protected state.b, x.l, y.l, scroll_x, scroll_y
      
      If Not *this\hide
        If *this\WidgetChange( ) = - 2 : *this\WidgetChange( ) = 1 : EndIf
        If *this\WidgetChange( ) = - 1 : *this\WidgetChange( ) = 1 : EndIf
        
        ;\\
        ForEach *this\columns( )
          *this\row\column = *this\columns( )\index
          update_items_( *this, *this\WidgetChange( ) )
        Next
        
        ;\\
        If *this\WidgetChange( ) > 0
          bar_area_update( *this )
          *this\WidgetChange( ) = - 2
        EndIf
        
        ;\\ SetState( scroll-to-see )
        If *this\FocusedRow( ) And *this\scroll\state = - 1
          row_scroll_y_( *this, *this\FocusedRow( ) )
          
          *this\scroll\v\change = 0
          *this\scroll\state    = #True
        EndIf
        
        ;\\
        If *this\WidgetChange( ) < 0
          ;\\ reset draw list
          ClearList( *this\VisibleRows( ))
          *this\VisibleFirstRow( ) = 0
          *this\VisibleLastRow( )  = 0
          
          ForEach *this\columns( )
            *this\row\column = *this\columns( )\index
            update_visible_items_( *this )
          Next
        EndIf
        
        ;\\ Draw background
        If *this\color\_alpha
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_roundbox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back);[*this\color\state] )
        EndIf
        
        ;\\ Draw background image
        If *this\image\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image\id, *this\image\x, *this\image\y, *this\color\_alpha )
        EndIf
        
        ;\\
        ForEach *this\columns( )
          *this\row\column             = *this\columns( )\index
          x                            = *this\x[#__c_frame] + *this\fs + *this\columns( )\x + *this\scroll_x( ) + *this\row\sublevelpos + *this\row\margin\width
          y                            = *this\y[#__c_frame] + *this\fs + *this\columns( )\y
          *this\columns( )\text\height = *this\text\height
          *this\columns( )\text\y      = ( *this\columns( )\height - *this\columns( )\text\height ) / 2
          *this\columns( )\text\x      = *this\text\padding\x
          
          ;\\ Draw selector back
          If *this\color\back
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            If *this\columns( )\index = 0
              draw_roundbox_( *this\x[#__c_frame] + *this\fs + *this\columns( )\x + *this\scroll_x( ), y, *this\columns( )\width + *this\row\sublevelpos + *this\row\margin\width, *this\columns( )\height, *this\round, *this\round, *this\color\frame )
            Else
              draw_roundbox_( x, y, *this\columns( )\width, *this\columns( )\height, *this\round, *this\round, *this\color\frame )
            EndIf
          EndIf
          
          ;\\ Draw items image
          If *this\columns( )\image\id
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawAlphaImage( *this\columns( )\image\id, x + *this\columns( )\image\x, y + *this\columns( )\image\y, *this\color\_alpha )
          EndIf
          
          ;\\ Draw items text
          If *this\columns( )\text\string.s
            drawing_mode_( #PB_2DDrawing_Transparent )
            DrawRotatedText( x + *this\columns( )\text\x, y + *this\columns( )\text\y, *this\columns( )\text\string.s, *this\text\rotate, *this\color\front )
          EndIf
          
          ;\\
          draw_items_( *this, *this\VisibleRows( ), *this\scroll\h\bar\page\pos, *this\scroll\v\bar\page\pos )
          
        Next
        
        ;\\ horizontal lines
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        x = *this\x[#__c_frame] + *this\fs + *this\scroll_x( ) + *this\row\sublevelpos + *this\row\margin\width
        ForEach *this\columns( )
          If *this\columns( )\index = 0
            ; draw_box_( x + *this\columns( )\x, *this\y[#__c_frame], 1, *this\columns( )\height + *this\fs, $ff000000 )
            draw_box_( x + *this\columns( )\x, *this\y[#__c_frame], 1, *this\height[#__c_frame], $ff000000 )
          EndIf
          draw_box_( x + *this\columns( )\x + *this\columns( )\width - 1, *this\y[#__c_frame], 1, *this\height[#__c_frame], $ff000000 )
        Next
      EndIf
      
    EndProcedure
    
    Procedure draw_Button( *this._S_widget )
      ;        drawing_mode_alpha_( #PB_2DDrawing_Default )
      ;              If *this\type = #__type_Button And *this\_parent( )\type = #__type_Splitter
      ;         Debug Drawing( )
      ;         Debug ""+#PB_Compiler_Procedure +" "+ *this\class : ProcedureReturn
      ;       EndIf
      
      Protected x, y
      With *this
        Protected state
        If *this\type = #__type_Button Or
           *this\type = #__type_ButtonImage
          state = *this\color\state
          If *this\state\check
            state = #__s_2
          EndIf
        EndIf
        
        ; update text
        If *this\WidgetChange( )
          Text_Update( *this )
          ; Text_Update( *this )
        EndIf
        
        If *this\ImageChange( )
          *this\image\padding\x = *this\text\padding\x
          *this\image\padding\y = *this\text\padding\y
          
          ; make horizontal scroll max
          If *this\scroll_width( ) < *this\image\width + *this\image\padding\x * 2
            *this\scroll_width( ) = *this\image\width + *this\image\padding\x * 2
          EndIf
          
          ; make vertical scroll max
          If *this\scroll_height( ) < *this\image\height + *this\image\padding\y * 2
            *this\scroll_height( ) = *this\image\height + *this\image\padding\y * 2
          EndIf
          
          ; make horizontal scroll x
          make_scrollarea_x( *this, *this\image )
          
          ; make vertical scroll y
          make_scrollarea_y( *this, *this\image )
          
          
          set_align_x_( *this\image, *this\image, *this\scroll_width( ), 0 )
          set_align_y_( *this\image, *this\image, *this\scroll_height( ), 270 )
        EndIf
        
        If *this\type = #__type_Option Or
           *this\type = #__type_CheckBox
          
          ; update widget ( option&checkbox ) position
          If *this\WidgetChange( )
            *this\_box_\y = *this\y[#__c_inner] + ( *this\height[#__c_inner] - *this\_box_\height ) / 2
            
            If *this\text\align\right
              *this\_box_\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\_box_\height - 3 )
            ElseIf Not *this\text\align\left
              *this\_box_\x = *this\x[#__c_inner] + ( *this\width[#__c_inner] - *this\_box_\width ) / 2
              
              If Not *this\text\align\top
                If *this\text\rotate = 0
                  *this\_box_\y = *this\y[#__c_inner] + *this\scroll_y( ) - *this\_box_\height
                Else
                  *this\_box_\y = *this\y[#__c_inner] + *this\scroll_y( ) + *this\scroll_height( )
                EndIf
              EndIf
            Else
              *this\_box_\x = *this\x[#__c_inner] + 3
            EndIf
          EndIf
        EndIf
        
        
        ; origin position
        x = *this\x[#__c_inner] + *this\scroll_x( )
        y = *this\y[#__c_inner] + *this\scroll_y( )
        
        ; background draw
        If *this\image[#__image_background]\id
          ; background image draw
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image[#__image_background]\id, x + *this\image[#__image_background]\x, x + *this\image[#__image_background]\y, *this\color\_alpha )
        Else
          If *this\color\back <> - 1
            If *this\color\fore <> - 1
              drawing_mode_alpha_( #PB_2DDrawing_Gradient )
              draw_gradient_( *this\text\vertical, *this, *this\color\fore[state], *this\color\back[state], [#__c_frame] )
            Else
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              draw_box( *this, color\back, [#__c_frame])
            EndIf
          EndIf
        EndIf
        
        ; draw text items
        If *this\text\string.s
          ;Clip( *this, [#__c_draw1] )
          ;Debug *this\text\string
          
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          ForEach *this\_rows( )
            DrawRotatedText( x + *this\_rows( )\x + *this\_rows( )\text\x, y + *this\_rows( )\y + *this\_rows( )\text\y,
                             *this\_rows( )\text\String.s, *this\text\rotate, *this\color\front[state] ) ; *this\_rows( )\color\font )
            
            If *this\mode\lines
              Protected i, count = Bool( func::GetFontSize( *this\_rows( )\text\fontID ) > 13 )
              For i = 0 To count
                Line( x + *this\_rows( )\x + *this\_rows( )\text\x, y + *this\_rows( )\y + *this\_rows( )\text\y + *this\_rows( )\text\height - count + i - 1, *this\_rows( )\text\width, 1, *this\color\front[state] )
              Next
            EndIf
            
          Next
          
          ;Clip( *this, [#__c_draw] )
        EndIf
        
        ; box draw
        Protected _box_x_, _box_y_
        If #__type_Option = *this\type
          draw_button_( 1, *this\_box_\x, *this\_box_\y, *this\_box_\width, *this\_box_\height, *this\state\check , *this\_box_\round );, *this\color )
        EndIf
        If #__type_CheckBox = *this\type
          draw_button_( 3, *this\_box_\x, *this\_box_\y, *this\_box_\width, *this\_box_\height, *this\state\check , *this\_box_\round );, *this\color )
        EndIf
        
        ; image draw
        If *this\image\id
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawAlphaImage( *this\image\id, x + *this\image\x, y + *this\image\y, *this\color\_alpha )
        EndIf
        
        ; defaul focus widget frame draw
        If *this\type = #__type_Button
          If *this\flag & #PB_Button_Default
            drawing_mode_( #PB_2DDrawing_Outlined )
            ;; draw_roundbox_( *this\x[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\width[#__c_inner]-4+2,\height[#__c_inner]-4+2,\round,\round,*this\color\frame[1] )
            If *this\round
              draw_roundbox_( *this\x[#__c_inner] + 2, *this\Y[#__c_inner] + 2 - 1, *this\width[#__c_inner] - 4, *this\height[#__c_inner] - 4 + 2, *this\round, *this\round, *this\color\frame[1] )
            EndIf
            draw_roundbox_( *this\x[#__c_inner] + 2, *this\Y[#__c_inner] + 2, *this\width[#__c_inner] - 4, *this\height[#__c_inner] - 4, *this\round, *this\round, *this\color\frame[1] )
          EndIf
        EndIf
        
        ; Draw frames
        If *this\fs
          ;If *this\type = #__type_Button
          drawing_mode_( #PB_2DDrawing_Outlined )
          ; draw_box( *this, color\frame, [#__c_frame] )
          draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame],
                          *this\round, *this\round, *this\color\frame[state] & $FFFFFF | *this\color\_alpha << 24 )
          
          ;EndIf
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure Combo_Draw( *this._S_widget )
      Protected state
      Protected arrow_right
      
      state = *this\color\state
      If state = #__s_3
        state = 0
      EndIf
      
      *this\_box_\arrow\type = #__arrow_type
      *this\_box_\arrow\size = #__arrow_size
      
      *this\text\x = 5
      *this\text\y = ( *this\_box_\height - *this\text\height ) / 2
      
      ;
      If *this\StringBox( )
        Editor_Draw( *this\StringBox( ) )
      Else
        drawing_mode_alpha_( #PB_2DDrawing_Gradient )
        draw_gradient_( *this\text\vertical, *this, *this\color\fore[*this\color\state], *this\color\back[state], [#__c_frame] )
        If *this\text\string
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_frame] + *this\text\x,
                    *this\y[#__c_frame] + *this\text\y,
                    *this\text\string, *this\color\front[state] & $FFFFFF | *this\color\_alpha << 24 )
        EndIf
      EndIf
      
      ;
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      If *this\StringBox( )
        draw_arrows_( *this\_box_, *this\_box_\arrow\direction )
      Else
        Arrow( *this\_box_\x + ( *this\_box_\width - *this\_box_\arrow\size * 2 - 4 ),
               *this\_box_\y + ( *this\_box_\height - *this\_box_\arrow\size ) / 2, *this\_box_\arrow\size, *this\_box_\arrow\direction,
               *this\_box_\color\front[state] & $FFFFFF | *this\_box_\color\_alpha << 24, *this\_box_\arrow\type )
      EndIf
      
      ; frame draw
      If *this\fs
        drawing_mode_( #PB_2DDrawing_Outlined )
        draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\round, *this\round, *this\color\frame[state] )
      EndIf
      
      draw_box_( *this\_box_\x, *this\_box_\y, *this\_box_\width, *this\_box_\height, $ff000000 )
      
    EndProcedure
    
    Procedure draw_Container( *this._S_widget )
      With *this
        
        If *this\type <> #__type_panel And *this\type <> #__type_Frame
          If *this\fs
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            Protected i
            For i = 0 To *this\fs
              draw_roundbox_( *this\x[#__c_frame] + i, *this\y[#__c_frame] + i, *this\width[#__c_frame] - i * 2, *this\height[#__c_frame] - i * 2, *this\round, *this\round, *this\color\frame[*this\color\state] )
              If i < *this\fs
                draw_roundbox_( *this\x[#__c_frame] + i, *this\y[#__c_frame] + i + 1, *this\width[#__c_frame] - i * 2, *this\height[#__c_frame] - i * 2 - 2, *this\round, *this\round, *this\color\frame[*this\color\state] )
              EndIf
            Next
          EndIf
        EndIf
        
        ; Clip( *this, [#__c_draw] ) ; 2
        
        drawing_mode_alpha_( #PB_2DDrawing_Default )
        ;draw_roundbox_( *this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state] )
        ;draw_roundbox_( *this\x[#__c_inner]-1,*this\y[#__c_inner]-1,*this\width[#__c_inner]+2,*this\height[#__c_inner]+2, *this\round, *this\round, *this\color\back[*this\color\state] )
        draw_roundbox_( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back[*this\color\state] )
        
        
        If *this\image\id Or *this\image[#__image_background]\id
          If *this\ImageChange( ) <> 0
            set_align_x_( *this\image, *this\image, *this\width[#__c_inner], 0 )
            set_align_y_( *this\image, *this\image, *this\height[#__c_inner], 270 )
            *this\ImageChange( ) = 0
          EndIf
          
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          
          ; background image draw
          If *this\image[#__image_background]\id
            DrawAlphaImage( *this\image[#__image_background]\id,
                            *this\x[#__c_inner] + *this\image[#__image_background]\x,
                            *this\y[#__c_inner] + *this\image[#__image_background]\y, *this\color\_alpha )
          EndIf
          
          ; scroll image draw
          If *this\image\id
            DrawAlphaImage( *this\image\id,
                            *this\x[#__c_inner] + *this\scroll_x( ) + *this\image\x,
                            *this\y[#__c_inner] + *this\scroll_y( ) + *this\image\y, *this\color\_alpha )
          EndIf
        EndIf
        
        If *this\text\string
          drawing_mode_alpha_( #PB_2DDrawing_Transparent )
          DrawText( *this\x[#__c_inner] + *this\scroll_x( ) + *this\text\x,
                    *this\y[#__c_inner] + *this\scroll_y( ) + *this\text\y,
                    *this\text\string, *this\color\front[\color\state] & $FFFFFF | *this\color\_alpha << 24 )
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   DrawWidget( *this._S_widget )
      ;\\ draw widgets
      Select *this\type
        Case #__type_Window : Window_Draw( *this )
        Case #__type_MDI : draw_Container( *this )
        Case #__type_Container : draw_Container( *this )
          ;Case #__type_Frame          : draw_Container( *this )
        Case #__type_ScrollArea : draw_Container( *this )
        Case #__type_Image : draw_Container( *this )
          
          ;- widget::_draw_Panel( )
        Case #__type_Panel
          ;             If *this\TabBox( ) And *this\TabBox( )\count\items
          draw_Container( *this )
          
          If *this\fs > 1
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\fs - 1, *this\round, *this\round, *this\color\frame[*this\color\state] )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame], *this\fs - 1, *this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state] )
            draw_roundbox_( *this\x[#__c_frame] + *this\width[#__c_frame] - *this\fs + 1, *this\y[#__c_frame], *this\fs - 1, *this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state] )
            draw_roundbox_( *this\x[#__c_frame], *this\y[#__c_frame] + *this\height[#__c_frame] - *this\fs + 1, *this\width[#__c_frame], *this\fs - 1, *this\round, *this\round, *this\color\frame[*this\color\state] )
          EndIf
          
          ;             Else
          ;               drawing_mode_alpha_( #PB_2DDrawing_Default )
          ;              draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\back[0] )
          ;
          ;               drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          ;              draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\frame )
          ;             EndIf
          
          ; Draw frames
        Case #__type_Frame
          If *this\fs
            
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            If *this\flag = #PB_Frame_Single
              draw_roundbox_(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\round, *this\round, $FFAAAAAA )
              
              draw_roundbox_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner] + 1, *this\height[#__c_inner] + 1, *this\round, *this\round, $FFF5F5F5 )
            ElseIf *this\flag = #PB_Frame_Double
              draw_roundbox_(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\round, *this\round, $FFAAAAAA )
              
              draw_roundbox_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner] + 1, *this\height[#__c_inner] + 1, *this\round, *this\round, $FFF5F5F5 )
              
              draw_roundbox_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, $FFAFAFAF )
            ElseIf *this\flag = #PB_Frame_Flat
              draw_roundbox_(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\round, *this\round, $FFAAAAAA )
            Else
              draw_roundbox_(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\round, *this\round, *this\color\frame )
            EndIf
            
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_(*this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner], *this\round, *this\round, *this\color\back )
            
          EndIf
          
          If *this\text\string
            ;
            drawing_mode_alpha_( #PB_2DDrawing_Default )
            draw_roundbox_(*this\x[#__c_inner] + *this\scroll_x( ) + *this\text\x - 6,
                           *this\y[#__c_inner] + *this\scroll_y( ) + *this\text\y + 1, *this\text\width + 12, *this\text\height, *this\round, *this\round, $BEEFEFEF )
            
            ;
            drawing_mode_alpha_( #PB_2DDrawing_Outlined )
            draw_roundbox_(*this\x[#__c_inner] + *this\scroll_x( ) + *this\text\x - 6,
                           *this\y[#__c_inner] + *this\scroll_y( ) + *this\text\y + 1, *this\text\width + 12, *this\text\height, *this\round, *this\round, *this\color\frame )
            
            ;
            drawing_mode_alpha_( #PB_2DDrawing_Transparent )
            DrawText( *this\x[#__c_inner] + *this\scroll_x( ) + *this\text\x,
                      *this\y[#__c_inner] + *this\scroll_y( ) + *this\text\y,
                      *this\text\string, *this\color\front & $FFFFFF | *this\color\_alpha << 24 )
          EndIf
          
          ;- widget::_draw_String( )
        Case #__type_String : Editor_Draw( *this )
          
          ;- widget::_draw_ComboBox( )
        Case #__type_ComboBox : Combo_Draw( *this )
          
          
        Case #__type_Editor : Editor_Draw( *this )
          
        Case #__type_Tree : Tree_Draw( *this )
        Case #__type_Property : Tree_Draw( *this )
        Case #__type_ListView : Tree_Draw( *this )
        Case #__type_ListIcon : Draw_ListIcon( *this )
          
        Case #__type_Text : draw_Button( *this )
        Case #__type_Button : draw_Button( *this )
        Case #__type_ButtonImage : draw_Button( *this )
        Case #__type_Option : draw_Button( *this )
        Case #__type_CheckBox : draw_Button( *this )
        Case #__type_HyperLink : draw_Button( *this )
          
        Case #__type_Spin ,
             #__type_TabBar, #__type_ToolBar,
             #__type_TrackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter
          
          bar_draw( *this )
      EndSelect
      
      ;\\
      If *this\TabBox( ) And
         *this\TabBox( )\count\items
        bar_tab_draw( *this\TabBox( ) )
      EndIf
      
      ;\\
      If *this\StringBox( )
        Draw( *this\StringBox( ) )
      EndIf
      
      ;\\ draw area scrollbars
      If *this\scroll
        bar_area_draw_( *this )
      EndIf
      
    EndProcedure
    
    Procedure.b Draw( *this._S_widget )
      Protected arrow_right
      
      With *this
        If *this\state\repaint = #True
          *this\state\repaint = #False
        EndIf
        
        ;\\ we call the event dispatched before the binding
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
            
            ;\\
            If *this\state\disable = 1
              *this\state\disable = - 1
              
              If *this\count\childrens
                DisableChildrens( *this )
              EndIf
            EndIf
            
            ;\\ limit drawing boundaries
            If Not *this\_root( )\autosize
              Clip( *this, [#__c_draw] )
            EndIf
            
            ;\\ draw widgets
            DrawWidget( *this )
            
            ;\\ test
            If *this\data And *this\container
              drawing_mode_( #PB_2DDrawing_Transparent )
              DrawText( *this\x, *this\y, Str( *this\data ), 0)
            EndIf
            
             ;\\
            If *this\state\enter And
               Not *this\state\disable 
              
              ;\\ draw entered anchors 
              If a_focused( ) And 
                 *this\_a_\transform
                a_draw( *this\_a_\id )
              EndIf
              
              ;\\ draw drag & drop
              If mouse( )\drag
                DropDraw( *this )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\ draw disable state
        If *this\state\disable
          drawing_mode_alpha_( #PB_2DDrawing_Default )
          draw_box_( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $AAE4E4E4 )
        EndIf
        
        ;\\
        If Not *this\hide
          ; reset values
          If *this\WidgetChange( ) <> 0
            *this\WidgetChange( ) = 0
          EndIf
          If *this\TextChange( ) <> 0
            *this\TextChange( ) = 0
          EndIf
          If *this\ImageChange( ) <> 0
            *this\ImageChange( ) = 0
          EndIf
          If *this\resize & #__resize_change
            *this\resize & ~ #__resize_change
          EndIf
        EndIf
        
        ;\\
        If *this\event And
           *this\event\draw
          Post( *this, #__event_Draw )
        EndIf
        
        ;\\
        If *this\resize <> 0
          If *this\container Or *this\_a_\transform
            Post( *this, #__event_Resize )
          EndIf
          *this\resize = 0
        EndIf
      EndWith
    EndProcedure
    
    Procedure ReDraw( *this._S_widget )
      If Drawing( )
        StopDrawing( )
      EndIf
      
      Drawing( ) = StartDrawing( CanvasOutput( *this\_root( )\canvas\gadget ))
      
      If Drawing( )
        If Not ( a_transform( ) And a_transform( )\grab )
          If is_root_(*this )
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              ; good transparent canvas
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
              ;             CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
              ;               FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetSysColor_(#COLOR_BTNFACE) )
            CompilerElse
              ;               Protected *style.GtkStyle, *color.GdkColor
              ;               *style = gtk_widget_get_style_(WindowID(*this\_root( )\canvas\window))
              ;               *color = *style\bg[0]                       ; 0=#GtkStateNormal
              ;               FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8) )
              FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
            CompilerEndIf
            ; FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetWindowColor(*this\_root( )\canvas\window))
            
            Draw( *this\_root( ))
            
            If Not ( *this\_root( )\autosize And
                     *this\_root( )\count\childrens = 0 )
              
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
            EndIf
          Else
            Draw( *this )
          EndIf
          
          EventWidget( )      = #Null
          WidgetEvent( )\type = #PB_All
          WidgetEvent( )\item = #PB_All
          WidgetEvent( )\data = #Null
        EndIf
        
        ;\\
        If EnteredButton( ) And EnteredWidget( ) And
           EnteredWidget( )\bar And EnteredWidget( )\state\enter And
           ( EnteredWidget( )\bar\button[1] = EnteredButton( ) Or
             EnteredWidget( )\bar\button[2] = EnteredButton( ) Or
             EnteredWidget( )\bar\button = EnteredButton( ) )
          
          UnclipOutput( )
          ;Debug ""+EnteredButton( ) +" "+ EnteredButton( )\x +" "+ EnteredButton( )\y +" "+ EnteredButton( )\width +" "+ EnteredButton( )\height
          drawing_mode_alpha_( #PB_2DDrawing_Outlined )
          If EnteredButton( )\state\disable
            draw_box_( EnteredButton( )\x, EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, $ff0000ff )
          Else
            draw_box_( EnteredButton( )\x, EnteredButton( )\y, EnteredButton( )\width, EnteredButton( )\height, $ffff0000 )
          EndIf
        EndIf
        
        
        ;\\ draw movable & sizable anchors
        If a_transform( )
          Clip( a_transform( )\main, [#__c_draw2] )
          
          If a_focused( ) And a_focused( )\_a_\transform And Not a_focused( )\hide And
             a_focused( )\_root( )\canvas\gadget = *this\_root( )\canvas\gadget
            
            If a_focused( ) And a_focused( )\state\press
              If a_index( ) = #__a_moved
                DrawWidget( a_focused( ) )
              EndIf
            EndIf
            
            ; draw key-focused-widget anchors
            a_draw( a_anchors( ) )
          EndIf
          
          If a_transform( )\main And
             a_transform( )\main\_root( )\canvas\gadget = *this\_root( )\canvas\gadget
            
            ; draw mouse selected widget anchors
            ; a_draw( a_selector( ) )
            
            ;\\ draw grab background
            If a_transform( )\grab
              drawing_mode_alpha_( #PB_2DDrawing_Default )
              DrawImage( ImageID( a_transform( )\grab ), 0, 0 )
              
              If Not a_transform( )\type
                CustomFilterCallback( @Draw_Datted( ))
              EndIf
              
              If a_selector( )\color\back
                draw_box_( a_selector( )\x, a_selector( )\y, a_selector( )\width, a_selector( )\height, a_selector( )\color\back )
              EndIf
              
              If a_transform( )\type
                DrawText( a_selector( )\x + 3, a_selector( )\y + 1, Str( a_selector( )\width ) + "x" + Str( a_selector( )\height ), a_selector( )\color\front, a_selector( )\color\back )
                
                If a_selector( )\color\frame
                  drawing_mode_alpha_( #PB_2DDrawing_Outlined )
                  draw_box_( a_selector( )\x, a_selector( )\y, a_selector( )\width, a_selector( )\height, a_selector( )\color\frame )
                EndIf
              Else
                drawing_mode_alpha_( #PB_2DDrawing_CustomFilter | #PB_2DDrawing_Outlined )
                draw_box_( a_selector( )\x, a_selector( )\y, a_selector( )\width, a_selector( )\height, a_selector( )\color\frame )
              EndIf
            EndIf
          EndIf
        EndIf
        
        
        ;\\ draw current popup-widget
        If PopupWidget( ) And PopupWidget( )\_root( ) = *this\_root( )
          Debug "popup - draw " + *this\_root( )\class
          
          Draw( PopupWidget( ) )
        EndIf
        
        Drawing( ) = 0
        StopDrawing( )
      EndIf
    EndProcedure
    
    ;-
    Procedure.i Post( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      Protected result
      ;       Select eventtype
      ;         Case #__event_MouseEnter
      ;           Debug " enter "+*this\class
      ;         Case #__event_MouseLeave
      ;           Debug " leave "+*this\class
      ;       EndSelect
      
      
      If *this = #PB_All
        ; 4)
      Else
        If *this And is_integral_( *this )
          If *this = PopupWidget( )
            *this = *this\_root( )\_parent( )
            ;             If eventtype = #__event_Change
            ;               Debug *this\class
            ;             EndIf
          EndIf
        EndIf
        
        If WidgetEvent( )\pFunc
          EventWidget( )      = *this
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
          
          ; если это оставить то после вызова функции напр setState( ) получается EventWidget( ) будеть равно #Null
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
        
        ;\\
        If eventtype = #__event_Draw : *this\event\draw = 1 : EndIf
        If eventtype = #__event_MouseMove : *this\event\move = 1 : EndIf
        If eventtype = #__event_StatusChange : *this\event\statusChange = 1 : EndIf
        
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
          *this\event\call( )\type  = eventtype
          *this\event\call( )\item  = item
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
    
    
    ;-
    Procedure GetAtPoint( *root._S_ROOT, mouse_x, mouse_y )
      Protected i, Repaint, *widget._S_WIDGET
      Static *leave._s_widget
      
      ; get at point address
      If *root\count\childrens
        LastElement( *root\_widgets( ))
        Repeat
          ; если переместили виджет то его исключаем
          If *root\_widgets( )\state\drag = #PB_Drag_Move
            Continue
          EndIf
          If *root\_widgets( )\address And Not *root\_widgets( )\hide And
             *root\_widgets( )\_root( )\canvas\gadget = *root\canvas\gadget And
             is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_frame] ) And
             is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_draw] )
            
            ; get alpha
            If *root\_widgets( )\_a_\transform = 0 And ( *root\_widgets( )\image[#__image_background]\id And
                                                         *root\_widgets( )\image[#__image_background]\depth > 31 And
                                                         is_at_point_( *root\_widgets( ), mouse_x, mouse_y, [#__c_inner] ) And
                                                         StartDrawing( ImageOutput( *root\_widgets( )\image[#__image_background]\img )))
              
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
            *widget = *root\_widgets( )
            
            Break
          EndIf
        Until PreviousElement( *root\_widgets( )) = #False
      EndIf
      
      ;\\
      If PopupWidget( )
        mouse_x = CanvasMouseX(PopupWidget( )\_root( )\canvas\gadget)
        mouse_y = CanvasMouseY(PopupWidget( )\_root( )\canvas\gadget)
        If is_at_point_( PopupWidget( ), mouse_x, mouse_y, [#__c_frame] ) And
           is_at_point_( PopupWidget( ), mouse_x, mouse_y, [#__c_draw] )
          *widget = PopupWidget( )
        EndIf
      EndIf
      
      ;\\
      If *widget
        ;\\ is integral scroll bar's
        If *widget\scroll
          If *widget\scroll\v And Not *widget\scroll\v\hide And
             is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_frame] ) And
             is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_draw] )
            *widget = *widget\scroll\v
          EndIf
          If *widget\scroll\h And Not *widget\scroll\h\hide And
             is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_frame] ) And
             is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_draw] )
            *widget = *widget\scroll\h 
          EndIf
        EndIf
        
        ;\\ is integral tab bar
        If *widget\TabBox( ) And Not *widget\TabBox( )\hide And
           is_at_point_( *widget\TabBox( ), mouse_x, mouse_y, [#__c_frame] ) And
           is_at_point_( *widget\TabBox( ), mouse_x, mouse_y, [#__c_draw] )
          *widget = *widget\TabBox( )
        EndIf
        
        ;\\ is integral string bar
        If *widget\StringBox( ) And Not *widget\StringBox( )\hide And
           is_at_point_( *widget\StringBox( ), mouse_x, mouse_y, [#__c_frame] ) And
           is_at_point_( *widget\StringBox( ), mouse_x, mouse_y, [#__c_draw] )
          *widget = *widget\StringBox( )
        EndIf
        
      Else
        ;\\ root no enumWidget
        If is_at_point_( *root, mouse_x, mouse_y, [#__c_frame] ) And
           is_at_point_( *root, mouse_x, mouse_y, [#__c_draw] )
          *widget = *root
        EndIf
      EndIf
      
      ;\\ entered anchor widget
      If a_transform( )
        If Not ( PressedWidget( ) And PressedWidget( )\state\press )
          If a_index( ) > 0
            
            If a_index( ) <> #__a_moved
              If a_entered( ) And
                 a_entered( )\_a_\id[a_index( )] And
                 Not is_at_point_( a_entered( )\_a_\id[a_index( )], mouse( )\x, mouse( )\y )
                
                If a_entered( )\_a_\id[a_index( )]\color\state <> #__S_0
                  a_entered( )\_a_\id[a_index( )]\color\state = #__S_0
                  a_entered( )\state\repaint                  = 1
                  Debug "" + a_index( ) + " - e_leave"
                EndIf
              EndIf
              ;               If a_focused( ) And
              ;                  a_focused( ) <> a_entered( ) And
              ;                  a_anchors([a_index( )]) And
              ;                  Not is_at_point_( a_anchors([a_index( )]), mouse( )\x, mouse( )\y )
              ;
              ;                 If a_anchors([a_index( )])\color\state <> #__S_0
              ;                   a_anchors([a_index( )])\color\state = #__S_0
              ;                   a_focused( )\state\repaint = 1
              ;                   Debug "" +a_index( )+ " - f_leave"
              ;                 EndIf
              ;               EndIf
            EndIf
            
            a_index( ) = 0
          EndIf
          
          If a_entered( ) And
             a_entered( )\_root( )\canvas\gadget = *root\canvas\gadget
            
            For i = 1 To #__a_moved
              If a_entered( )\_a_\id[i] And
                 is_at_point_( a_entered( )\_a_\id[i], mouse( )\x, mouse( )\y )
                ;
                If a_index( ) <> i
                  a_index( ) = i
                  
                  If i <> #__a_moved
                    If a_entered( )\_a_\id[i]\color\state <> #__S_1
                      Debug "" + i + " - a_enter"
                      a_entered( )\_a_\id[i]\color\state = #__S_1
                      a_entered( )\state\repaint         = 1
                    EndIf
                  EndIf
                EndIf
                
                *widget = a_entered( )
                Break
              EndIf
            Next
          EndIf
          
          If a_focused( ) And
             a_focused( )\_root( )\canvas\gadget = *root\canvas\gadget
            
            For i = 1 To #__a_moved
              If a_anchors([i]) And is_at_point_( a_anchors([i]), mouse( )\x, mouse( )\y )
                
                If a_index( ) <> i
                  a_index( ) = i
                  
                  If i <> #__a_moved
                    If a_anchors([i])\color\state <> #__S_1
                      Debug "f_enter " + i
                      a_anchors([i])\color\state = #__S_1
                      a_focused( )\state\repaint         = 1
                    EndIf
                  EndIf
                EndIf
                
                *widget = a_focused( )
                Break
              EndIf
            Next
          EndIf
        EndIf
      EndIf
      
      ;\\ do events entered & leaved
      If *leave <> *widget
        ;If Not ( *widget And is_integral_( *widget ) )
        EnteredWidget( ) = *widget
        ;EndIf
        
        ;If Not a_is_at_point_( *leave )
        If *leave And ;Not ( *widget And is_integral_( *widget ) ) And
           *leave\state\enter <> 0
          *leave\state\enter = 0
          
          ;\\
          If mouse( )\drag And is_scrollbars_( *leave ) ;\child And *leave\type = #__type_ScrollBar
            *leave\_parent( )\state\enter = 0
          EndIf
          
          ;\\
          ;Debug " >  leave - "+*leave\class
          repaint | DoEvents( *leave, #__event_MouseLeave )
          
          ;\\
          If Not is_interact_row_( *leave ) And Not a_transform_( *leave )
            If Not IsChild( *widget, *leave )
              ;
              ;DoEvents( *leave, #__event_StatusChange, - 1 )
              
              If *leave\address
                ChangeCurrentElement( *leave\_widgets( ), *leave\address )
                Repeat
                  If *leave\_widgets( )\count\childrens And *leave\_widgets( )\state\enter <> 0
                    If is_at_point_( *leave\_widgets( ), mouse_x, mouse_y, [#__c_draw] )
                      If Not ( *widget And *widget\index > *leave\_widgets( )\index )
                        Break
                      EndIf
                    EndIf
                    
                    ;
                    If Not is_interact_row_( *leave\_widgets( ) ) And *leave\_widgets( )\_a_\transform And
                       IsChild( *leave, *leave\_widgets( )) And
                       Not IsChild( *widget, *leave\_widgets( ))
                      *leave\_widgets( )\state\enter = 0
                      DoEvents( *leave\_widgets( ), #__event_StatusChange, - 1 )
                    EndIf
                  EndIf
                Until PreviousElement( *leave\_widgets( )) = #False
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If *widget And
           *widget\state\enter = 0
          *widget\state\enter = 1
          
          ;\\
          ;Debug " >  enter - "+*widget\class
          DoEvents( *widget, #__event_MouseEnter )
          
          ;\\
          If mouse( )\drag And is_scrollbars_( *widget ) ;\child And *widget\type = #__type_ScrollBar
            *widget\_parent( )\state\enter = 1
          EndIf
          
          ;\\
          If Not is_interact_row_( *widget ) And Not a_transform_( *widget )
            If *widget\address And Not *widget\attach
              ForEach *widget\_widgets( )
                If *widget\_widgets( ) = *widget
                  Break
                EndIf
                
                If *widget\_widgets( )\state\enter = 0 And a_transform_( *widget\_widgets( ) ) And
                   *widget\_widgets( )\count\childrens And
                   Not is_interact_row_( *widget\_widgets( ) ) And
                   IsChild( *widget, *widget\_widgets( ))
                  
                  *widget\_widgets( )\state\enter = - 1
                  DoEvents( *widget\_widgets( ), #__event_StatusChange, 1 )
                EndIf
              Next
            EndIf
            
            DoEvents( *widget, #__event_StatusChange, 1 )
          EndIf
        EndIf
        ;EndIf
        
        ;If Not ( *widget And is_integral_( *widget ) )
        *leave = *widget
        ;EndIf
      EndIf
    EndProcedure
    
    Procedure DoEvent_RowTimerEvents( )
      ; Debug "  timer"
      Protected result
      Protected scroll_x, scroll_y
      Protected *this._S_widget = PressedWidget( )
      
      If *this
        If *this\_root( ) <> Root( )
          mouse( )\x = CanvasMouseX( *this\_root( )\canvas\gadget )
          mouse( )\y = CanvasMouseY( *this\_root( )\canvas\gadget )
        EndIf
        
        If Not is_at_point_vertical_( *this, mouse( )\y, [#__c_inner] ) And *this\scroll\v
          If mouse( )\y < mouse( )\delta\y
            If Not bar_in_start_( *this\scroll\v\bar )
              scroll_y = mouse( )\y - ( *this\y[#__c_inner] )
              bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + scroll_y )
              Text_Update( *this )
              ReDraw( *this\_root( ) )
              Debug "scroll v top " + scroll_y + " " + *this\VisibleFirstRow( )\index
              
            Else
              ; Debug "scroll v stop top"
            EndIf
          ElseIf mouse( )\y > mouse( )\delta\y
            If Not bar_in_stop_( *this\scroll\v\bar )
              scroll_y = 400;mouse( )\y - ( *this\y[#__c_inner] + *this\height[#__c_inner] )
                            ;bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos + scroll_y )
                            ;Text_Update( *this )
                            ;ReDraw(   *this\_root( ) )
              Debug "scroll v bottom " + scroll_y + " " + *this\VisibleLastRow( )\index
              
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
        
        If Not is_at_point_horizontal_( *this, mouse( )\x, [#__c_inner] ) And *this\scroll\h
          If mouse( )\x < mouse( )\delta\x
            If Not bar_in_start_( *this\scroll\h\bar )
              scroll_x = mouse( )\x - ( *this\x[#__c_inner] )
              Debug "scroll h top " + scroll_x
              bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + scroll_x )
              result = 1
            Else
              ; Debug "scroll h stop top"
            EndIf
          ElseIf mouse( )\x > mouse( )\delta\x
            If Not bar_in_stop_( *this\scroll\h\bar )
              scroll_x = mouse( )\x - ( *this\x[#__c_inner] + *this\height[#__c_inner] )
              Debug "scroll h bottom " + scroll_x
              bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos + scroll_x )
              result = 1
            Else
              ; Debug "scroll h stop bottom"
            EndIf
          EndIf
        EndIf
        
        If result = 1
          ;Debug 888
          ;           ReDraw(   *this\_root( ) )
          ;           DoEvents( *this, #__event_StatusChange )
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure DoEvent_Lines( *this._S_widget, eventtype.l, mouse_x.l = - 1, mouse_y.l = - 1 )
      Protected repaint, *item._S_ROWS
      
      ;
      If *this\row
        ;         If PressedWidget( ) And PressedWidget( )\state\press And (mouse( )\drag And mouse( )\drag\private) Or Not ( PressedWidget( )\row  )
        ;           ;Debug "disable items redraw"
        ;           ProcedureReturn 0
        ;         EndIf
        
        ;
        If eventtype = #__event_Focus
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
        If eventtype = #__event_LostFocus
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
        If eventtype = #__event_LeftButtonDown ; Ok
          If *this\EnteredRow( )
            *this\PressedRow( ) = *this\EnteredRow( )
            
            If *this\PressedRow( )\state\press = #False
              *this\PressedRow( )\state\press = #True
            EndIf
            
            If *this\FocusedRow( ) <> *this\EnteredRow( )
              PushListPosition( *this\_rows( ) )
              ForEach *this\_rows( )
                If *this\_rows( )\state\focus <> #False
                  *this\_rows( )\state\focus = #False
                EndIf
                
                If *this\_rows( )\color\state <> #__s_0
                  *this\_rows( )\color\state = #__s_0
                EndIf
              Next
              PopListPosition( *this\_rows( ) )
              
              *this\FocusedRow( )       = *this\EnteredRow( )
              *this\FocusedLineIndex( ) = *this\FocusedRow( )\index
              
              If *this\FocusedRow( )\state\focus = #False
                *this\FocusedRow( )\state\focus = #True
              EndIf
              *this\FocusedRow( )\color\state = #__s_2
            EndIf
            
            
            If mouse( )\click = 1
              *this\edit_caret_0( ) = edit_caret_( *this )
              ;Debug *this\edit_caret_0( )
              
              If *this\edit_caret_1( ) <> *this\edit_caret_0( ) + *this\EnteredRow( )\text\pos
                *this\edit_caret_1( ) = *this\edit_caret_0( ) + *this\EnteredRow( )\text\pos
                *this\edit_caret_2( ) = *this\edit_caret_1( )
                
                *this\PressedLineIndex( )           = *this\EnteredRow( )\index ;????
                *this\EnteredRow( )\edit_caret_1( ) = *this\edit_caret_1( ) - *this\EnteredRow( )\text\pos
                
                ;
                edit_sel_reset_( *this )
                
                edit_sel_row_text_( *this, *this\EnteredRow( ) )
                edit_sel_text_( *this, *this\EnteredRow( ) )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If eventtype = #__event_LeftDoubleClick
          ;Debug "edit - Left2Click"
          *this\edit_caret_1( ) = edit_sel_stop_word( *this, *this\edit_caret_0( ), *this\EnteredRow( ) )
          *this\edit_caret_2( ) = edit_sel_start_word( *this, *this\edit_caret_0( ) + 1, *this\EnteredRow( ) )
          
          edit_sel_row_text_( *this, *this\EnteredRow( ) )
          edit_sel_text_( *this, *this\EnteredRow( ) )
        EndIf
        
        ;
        If eventtype = #__event_Left3Click
          ;Debug "edit - Left3Click"
          *this\edit_caret_2( ) = *this\EnteredRow( )\text\pos
          *this\edit_caret_1( ) = *this\EnteredRow( )\text\pos + *this\EnteredRow( )\text\len
          
          edit_sel_row_text_( *this, *this\EnteredRow( ) )
          edit_sel_text_( *this, *this\EnteredRow( ) )
        EndIf
        
        ;
        If eventtype = #__event_LeftButtonUp ; Ok
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
                     ( *this\state\drag And is_at_point_vertical_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\VisibleRows( ))
            Repeat
              If *this\VisibleRows( )\visible And
                 *this\VisibleRows( )\hide = 0 And
                 ( ( *this\state\enter And is_at_point_( *this\VisibleRows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_vertical_( *this\VisibleRows( ), mouse_y )) )
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
                     ( *this\state\drag And is_at_point_vertical_( *this\EnteredRow( ), mouse_y )) ))
            
            ; search entered item
            LastElement( *this\_rows( ))
            Repeat
              If *this\_rows( )\visible And
                 *this\_rows( )\hide = 0 And
                 ( ( *this\state\enter And is_at_point_( *this\_rows( ), mouse_x, mouse_y )) Or
                   ( *this\state\drag And is_at_point_vertical_( *this\_rows( ), mouse_y )) )
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
          EndIf
        Else
          If eventtype = #__event_MouseMove
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
              
              If *this\state\drag = #PB_Drag_Update
                ;Debug "le - "
                
                If mouse_y > ( *this\EnteredRow( )\y + *this\EnteredRow( )\height / 2 )
                  If *this\EnteredRow( ) = *this\PressedRow( )
                    ;Debug " le bottom  set - Pressed  " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_last )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  ElseIf *this\EnteredRow( )\index < *this\PressedRow( )\index
                    ;Debug "  ^le top remove - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_remove )
                    edit_sel_text_( *this, SelectElement(*this\_rows( ), *this\EnteredRow( )\index + 1))
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
                    edit_sel_text_( *this, SelectElement(*this\_rows( ), *this\EnteredRow( )\index - 1))
                  Else
                    ;Debug " ^le bottom  set - " +" "+ *this\EnteredRow( )\text\string
                    edit_sel_row_text_( *this, *this\EnteredRow( ), #__sel_to_set )
                    edit_sel_text_( *this, *this\EnteredRow( ))
                  EndIf
                EndIf
                
              EndIf
              
            EndIf
          EndIf
          
          ; Debug "lines "+*item+" "+*this\EnteredRow( )
          ;*this\LeavedRow( ) = *this\EnteredRow( )
          *this\EnteredRow( ) = *item
          
          If *this\EnteredRow( )
            ; enter state
            If *this\state\enter
              If *this\EnteredRow( )\state\enter = #False
                *this\EnteredRow( )\state\enter = #True
                
                If *this\EnteredRow( )\color\state = #__S_0
                  *this\EnteredRow( )\color\state = #__S_1
                EndIf
                
                If *this\state\drag = #PB_Drag_Update
                  ; Debug "en - "
                  
                  *this\FocusedRow( )   = *this\EnteredRow( )
                  *this\edit_caret_0( ) = edit_caret_( *this )
                  *this\edit_caret_1( ) = *this\edit_caret_0( ) + *this\EnteredRow( )\text\pos
                  
                  ; это на тот случай если резко выделили строки
                  ; чтобы не пропустить некоторые из них
                  If *this\text\multiLine And *this\PressedRow( )
                    PushListPosition( *this\_rows( ) )
                    ForEach *this\_rows( )
                      If Bool(( *this\FocusedRow( )\index >= *this\_rows( )\index And
                                *this\PressedRow( )\index <= *this\_rows( )\index ) Or ; верх
                              ( *this\FocusedRow( )\index <= *this\_rows( )\index And
                                *this\PressedRow( )\index >= *this\_rows( )\index )) ; вниз
                        
                        ;
                        If *this\_rows( )\index <> *this\PressedRow( )\index And
                           *this\_rows( )\index <> *this\FocusedRow( )\index
                          
                          If *this\_rows( )\text\edit[2]\width <> *this\_rows( )\text\width + *this\mode\fullselection
                            Debug "set - " + " " + *this\_rows( )\text\string
                            edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_set )
                          EndIf
                        EndIf
                      Else
                        ;
                        If *this\_rows( )\text\edit[2]\width <> 0
                          Debug " remove - " + " " + *this\_rows( )\text\string
                          edit_sel_row_text_( *this, *this\_rows( ), #__sel_to_remove )
                        EndIf
                      EndIf
                    Next
                    PopListPosition( *this\_rows( ) )
                  EndIf
                  
                  ;\\ *this\EnteredLineIndex( ) = *this\EnteredRow( )\index
                  edit_sel_row_text_( *this, *this\EnteredRow( ) )
                  edit_sel_text_( *this, *this\EnteredRow( ) )
                  
                Else
                  *this\state\repaint = #True
                EndIf
              EndIf
            EndIf
          EndIf
          
        Else
          If *this\state\drag = #PB_Drag_Update
            If *this\PressedRow( ) And *this\FocusedRow( ) And *this\EnteredRow( )
              
              *this\edit_caret_0( ) = edit_caret_( *this )
              If *this\edit_caret_1( ) <> *this\edit_caret_0( ) + *this\EnteredRow( )\text\pos
                *this\edit_caret_1( ) = *this\edit_caret_0( ) + *this\EnteredRow( )\text\pos
                edit_sel_row_text_( *this, *this\EnteredRow( ) )
                edit_sel_text_( *this, *this\EnteredRow( ) )
              EndIf
            EndIf
          EndIf
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure DoEvent_Items( *this._S_widget, eventtype.l, mouse_x.l = - 1, mouse_y.l = - 1 )
      Protected repaint, *item._S_ROWS
      mouse_x = mouse( )\x - *this\x[#__c_inner] ; - *this\scroll_x( )
      mouse_y = mouse( )\y - *this\y[#__c_inner] - *this\scroll_y( )
      
      ;
      If *this\row
        ;\\ search at point entered items
        If Not *this\state\enter
          *item = #Null
        Else
          If ListSize( *this\VisibleRows( ) )
            If *this\EnteredRow( ) And
               *this\EnteredRow( )\visible And
               Not *this\EnteredRow( )\hide And
               is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )
              *item = *this\EnteredRow( )
            Else
              LastElement( *this\VisibleRows( ))
              Repeat
                If *this\VisibleRows( )\visible And
                   Not *this\VisibleRows( )\hide And
                   is_at_point_( *this\VisibleRows( ), mouse_x, mouse_y )
                  *item = *this\VisibleRows( )
                  Break
                EndIf
              Until PreviousElement( *this\VisibleRows( )) = #False
            EndIf
            
          ElseIf ListSize( *this\_rows( ) )
            If *this\EnteredRow( ) And
               *this\EnteredRow( )\visible And
               Not *this\EnteredRow( )\hide And
               is_at_point_( *this\EnteredRow( ), mouse_x, mouse_y )
              *item = *this\EnteredRow( )
            Else
              LastElement( *this\_rows( ))
              Repeat
                If *this\_rows( )\visible And
                   Not *this\_rows( )\hide And
                   is_at_point_( *this\_rows( ), mouse_x, mouse_y )
                  *item = *this\_rows( )
                  Break
                EndIf
              Until PreviousElement( *this\_rows( )) = #False
            EndIf
          EndIf
        EndIf
        
        ;\\ do enter & leave items events
        If *this\state\drag And *this\state\drag <> #PB_Drag_Finish
          If eventtype = #__event_MouseMove
            If Not Mouse( )\drag Or PressedWidget( )\drop
              ;\\
              If *item = #Null And is_at_point_horizontal_( *this, mouse_x )
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
              EndIf
              
              *this\EnteredRow( ) = *item ;???
              
              ;\\ focus & lostfocus state
              If *item
                If *this\FocusedRow( ) <> *item
                  ;\\ lost-focus state
                  If *this\FocusedRow( )
                    If *this\FocusedRow( )\state\focus
                      *this\FocusedRow( )\state\focus = 0
                      *this\FocusedRow( )\state\enter = 0
                      
                      If *this\FocusedRow( )\state\press = #False
                        *this\FocusedRow( )\color\state = #__S_0
                      EndIf
                      
                      *this\state\repaint = #True
                    EndIf
                  EndIf
                  
                  *this\FocusedRow( ) = *item
                  
                  ;\\ focus state
                  If *this\FocusedRow( )
                    ; Debug *this\FocusedRow( )\state\focus
                    If *this\FocusedRow( )\state\focus = 0
                      *this\FocusedRow( )\state\focus = 1
                      *this\FocusedRow( )\state\enter = 1
                      
                      *this\FocusedRow( )\color\state = #__S_2
                      DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
                    EndIf
                  EndIf
                EndIf
              Else
                If *this\FocusedRow( ) And
                   *this\FocusedRow( )\state\enter
                  *this\FocusedRow( )\state\enter = 0
                  
                  If *this\FocusedRow( ) <> *this\PressedRow( )
                    ;Debug 88888
                    *this\FocusedRow( )\state\focus = 0
                    *this\FocusedRow( )\color\state = #__s_0
                    *this\FocusedRow( )             = 0;*this\PressedRow( )
                                                       ;DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
                    
                  EndIf
                EndIf
              EndIf
              
              ;\\ drag & drop state
              If *this\FocusedRow( ) And
                 *this\FocusedRow( )\state\enter
                
                If ( mouse_y - *this\FocusedRow( )\y ) > *this\FocusedRow( )\height / 2
                  If *this\FocusedRow( )\state\enter <> 1
                    *this\FocusedRow( )\state\enter = 1
                    ; mouse( )\enter =- 1
                    ;Debug "-1 (+1)"
                    *this\state\repaint = 1
                  EndIf
                Else
                  If *this\FocusedRow( )\state\enter <> - 1
                    *this\FocusedRow( )\state\enter = - 1
                    ;Debug "+1 (-1)"
                    ; mouse( )\enter = 1
                    *this\state\repaint = 1
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        Else
          ;\\ change enter/leave state
          If *this\EnteredRow( ) <> *item
            
            ;\\ leave state
            If *this\EnteredRow( )
              If *this\EnteredRow( )\state\enter
                *this\EnteredRow( )\state\enter = 0
                
                If *this\EnteredRow( )\color\state = #__S_1
                  *this\EnteredRow( )\color\state = #__S_0
                EndIf
              EndIf
            EndIf
            
            ; Debug "items - "+*item+" "+*this\EnteredRow( )
            *this\LeavedRow( )  = *this\EnteredRow( )
            *this\EnteredRow( ) = *item
            
            If *this\EnteredRow( )
              ;\\ enter state
              If *this\state\enter
                If *this\EnteredRow( )\state\enter = 0
                  *this\EnteredRow( )\state\enter = 1
                  
                  If *this\EnteredRow( )\color\state = #__S_0
                    *this\EnteredRow( )\color\state = #__S_1
                  EndIf
                  
                  ;\\ update non-focus status
                  If Not ( *this\LeavedRow( ) = #Null And *this\EnteredRow( ) = *this\FocusedRow( ))
                    ; Debug " items status change enter"
                    
                    DoEvents(*this, #__event_StatusChange, *this\EnteredRow( ), *this\EnteredRow( )\index)
                  EndIf
                EndIf
              EndIf
              
              ;\\
            ElseIf *this\FocusedRow( ) <> *this\LeavedRow( )
              ; Debug " items status change leave"
              
              If *this\FocusedRow( )
                DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
              ElseIf *this\LeavedRow( )
                DoEvents(*this, #__event_StatusChange, *this\LeavedRow( ), *this\LeavedRow( )\index)
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_MouseEnter
          If *this\FocusedRow( ) And
             Not ( *this\EnteredRow( ) And *this\FocusedRow( ) <> *this\EnteredRow( ) )
            DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_LeftButtonDown
          If *this\EnteredRow( )
            *this\PressedRow( )             = *this\EnteredRow( )
            *this\PressedRow( )\color\state = #__S_2
            *this\PressedRow( )\state\press = 1
            
            If *this\FocusedRow( ) <> *this\EnteredRow( )
              If *this\FocusedRow( ) And
                 *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = 0
                *this\FocusedRow( )\color\state = #__S_0
              EndIf
              
              *this\FocusedRow( ) = *this\EnteredRow( )
              
              If *this\FocusedRow( )\state\focus = 0
                *this\FocusedRow( )\state\focus = 1
                DoEvents(*this, #__event_Change, *this\FocusedRow( ), *this\FocusedRow( )\index)
                DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_Focus
          If *this\FocusedRow( )
            If *this\FocusedRow( )\state\focus
              *this\FocusedRow( )\color\state = #__S_2
              If *this\FocusedRow( )\state\focus = - 1
                *this\FocusedRow( )\state\focus = 1
                DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_LostFocus
          If *this\FocusedRow( )
            If *this\FocusedRow( )\state\focus
              *this\FocusedRow( )\color\state = #__S_3
            EndIf
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_Drop ; Ok
          If *this\FocusedRow( )
            ;             Debug "drop p - "+*this\PressedRow( ) +" "+ *this\PressedRow( )\text\string +" "+ *this\PressedRow( )\state\press +" "+ *this\PressedRow( )\state\enter +" "+ *this\PressedRow( )\state\focus
            ;             ;Debug "drop e - "+*this\EnteredRow( ) +" "+ *this\EnteredRow( )\text\string +" "+ *this\EnteredRow( )\state\press +" "+ *this\EnteredRow( )\state\enter +" "+ *this\EnteredRow( )\state\focus
            ;             Debug "drop f - "+*this\FocusedRow( ) +" "+ *this\FocusedRow( )\text\string +" "+ *this\FocusedRow( )\state\press +" "+ *this\FocusedRow( )\state\enter +" "+ *this\FocusedRow( )\state\focus
            
            If *this\PressedRow( ) And
               *this\FocusedRow( )\index > *this\PressedRow( )\index
              *this\FocusedRow( )\state\enter = 0
            EndIf
            *this\FocusedRow( )\state\focus = 0
            *this\FocusedRow( )\state\press = 0
            *this\FocusedRow( )\color\state = #__s_0
          EndIf
        EndIf
        
        ;\\
        If eventtype = #__event_LeftButtonUp
          If *item
            Debug "up * - " + *item + " " + *item\text\string + " " + *item\state\press + " " + *item\state\enter + " " + *item\state\focus
          EndIf
          
          If *this\EnteredRow( )
            Debug "up e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\state\focus
          EndIf
          
          ;\\
          If *this\PressedRow( )
            Debug "up p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\state\focus
            *this\PressedRow( )\state\press = 0
          EndIf
          
          ;\\
          If *this\FocusedRow( )
            Debug "up f - " + *this\FocusedRow( ) + " " + *this\FocusedRow( )\text\string + " " + *this\FocusedRow( )\state\press + " " + *this\FocusedRow( )\state\enter + " " + *this\FocusedRow( )\state\focus
            
            If *this\PressedRow( ) = *this\FocusedRow( )
              If Not *this\FocusedRow( )\state\enter
                ; Debug 888
              EndIf
            Else
              If *this\PressedRow( )
                *this\PressedRow( )\state\focus = 0
                *this\PressedRow( )\state\enter = 0
                *this\PressedRow( )\color\state = #__s_0
                *this\PressedRow( )             = 0
              EndIf
              
              ;\\
              DoEvents(*this, #__event_Change, *this\FocusedRow( ), *this\FocusedRow( )\index)
              DoEvents(*this, #__event_StatusChange, *this\FocusedRow( ), *this\FocusedRow( )\index)
            EndIf
          Else
            If *this\PressedRow( )
              *this\FocusedRow( )             = *this\PressedRow( )
              *this\FocusedRow( )\state\focus = 1
            EndIf
          EndIf
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure DoEvents( *this._S_widget, eventtype.l, *data = #Null, *button = #PB_All )
      ; Debug "DoEvents( "+*this +" "+ eventtype
      ;\\
      If Not *this\state\disable
        
        ;\\ entered position state
        If *this\state\enter > 0
          If is_at_point_( *this, mouse( )\x, mouse( )\y, [#__c_inner] )
            If *this\type = #__type_Splitter
              If is_at_point_( *this\bar\button, mouse( )\x, mouse( )\y )
                If *this\state\enter = 1: *this\state\enter = 2: *this\state\repaint = 1: EndIf
              Else
                If *this\state\enter = 2: *this\state\enter = 1: *this\state\repaint = 1: EndIf
              EndIf
            ElseIf *this\type = #__type_HyperLink
              If is_at_point_( *this, mouse( )\x - *this\x, mouse( )\y - *this\y, [#__c_Required] )
                If *this\state\enter = 1: *this\state\enter = 2: *this\state\repaint = 1: EndIf
              Else
                If *this\state\enter = 2: *this\state\enter = 1: *this\state\repaint = 1: EndIf
              EndIf
            Else
              If *this\state\enter = 1: *this\state\enter = 2: *this\state\repaint = 1: EndIf
            EndIf
          Else
            If *this\state\enter = 2: *this\state\enter = 1: *this\state\repaint = 1: EndIf
          EndIf
        EndIf
        
        ;\\ drag & drop state
        If mouse( )\drag
          If eventtype = #__event_MouseEnter Or
             eventtype = #__event_MouseLeave
            DropState( *this )
          EndIf
          If eventtype = #__event_MouseMove
            If *this\state\enter
              DropState( *this )
            EndIf
          EndIf
        EndIf
        
        ;\\ repaint state
        Select eventtype
          Case #__event_Focus
            If *this\color\state = #__s_3
              *this\color\state = #__s_2
            EndIf
            *this\state\repaint = #True
            
          Case #__event_LostFocus
            If *this\color\state = #__s_2
              *this\color\state = #__s_3
            EndIf
            *this\state\repaint = #True
            
          Case #__event_Change
            If *this\row
              ; Debug "change "+*button
            EndIf
            
          Case #__event_StatusChange
            If *this\row
              If *this\FocusedRow( )
                If *this\FocusedRow( )\state\focus ; ???
                  If *this\FocusedRow( )\state\focus = 1
                    *this\FocusedRow( )\state\focus = - 1
                    If *this\FocusedRow( )\color\state <> 3
                      ;Debug *button
                      *this\FocusedRow( )\color\back[*this\FocusedRow( )\color\state] = $FF2C70F5 ; TEMP
                    EndIf
                  EndIf
                Else
                  Debug "no focus statechange"
                EndIf
              EndIf
              *this\state\repaint = #True
            EndIf
            
          Case #__event_Drop
            *this\state\repaint = #True
            
          Case #__event_MouseMove
            If *this\bar And *this\state\drag
              *this\state\repaint = #True
            EndIf
            
          Case #__event_MouseEnter,
               #__event_MouseLeave,
               #__event_RightButtonDown,
               #__event_RightButtonUp,
               #__event_RightDoubleClick,
               #__event_Right3Click,
               #__event_RightClick,
               #__event_Down,
               #__event_Up,
               #__event_LeftButtonDown,
               #__event_LeftButtonUp,
               #__event_LeftDoubleClick,
               #__event_Left3Click,
               #__event_LeftClick,
               #__event_KeyDown,
               #__event_KeyUp,
               #__event_Focus,
               #__event_LostFocus,
               #__event_ScrollChange,
               ;            ; #__event_Repaint,
               ;              #__event_Create,
               ;              #__event_Resize,
            #__event_DragStart
            
            
            *this\state\repaint = #True
        EndSelect
        
        ;\\ buttons events
        Select eventtype
          Case #__event_MouseEnter,
               #__event_MouseLeave,
               #__event_MouseMove,
               #__event_Focus,
               #__event_LostFocus,
               #__event_Down,
               #__event_Up
            
            ;\\ buttons events
            If *this\bar
              Protected._s_BUTTONS *BB0, *BB1, *BB2, *SB
              *SB  = *this\bar\button
              *BB1 = *this\bar\button[1]
              *BB2 = *this\bar\button[2]
              
              ;\\ get at-point-button address
              If Not ( EnteredButton( ) And
                       EnteredButton( )\hide = 0 And
                       is_at_point_( EnteredButton( ), mouse( )\x, mouse( )\y ))
                
                ; search entered button
                If *BB1\interact And *BB1\hide = 0 And
                   is_at_point_( *BB1, mouse( )\x, mouse( )\y )
                  
                  *BB0 = *BB1
                ElseIf *BB2\interact And *BB2\hide = 0 And
                       is_at_point_( *BB2, mouse( )\x, mouse( )\y )
                  
                  *BB0 = *BB2
                ElseIf *SB\interact And *SB\hide = 0 And
                       is_at_point_( *SB, mouse( )\x, mouse( )\y, )
                  
                  *BB0 = *SB
                EndIf
              Else
                *BB0 = EnteredButton( )
              EndIf
              
              ;\\ do buttons events entered & leaved
              If EnteredButton( ) <> *BB0
                If EnteredButton( )
                  If EnteredButton( )\state\enter = #True
                    EnteredButton( )\state\enter = #False
                    
                    If EnteredButton( )\color\state = #__S_1
                      EnteredButton( )\color\state = #__S_0
                    EndIf
                    
                    *this\state\repaint = #True
                  EndIf
                EndIf
                
                EnteredButton( ) = *BB0
                
                If EnteredButton( )
                  If *this\state\enter
                    If EnteredButton( )\state\enter = #False
                      EnteredButton( )\state\enter = #True
                      
                      If EnteredButton( )\color\state = #__S_0
                        EnteredButton( )\color\state = #__S_1
                      EndIf
                      
                      *this\state\repaint = #True
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;\\
            If *this\tab
              bar_tab_AtPoint( *this, eventtype, mouse( )\x, mouse( )\y )
            EndIf
        EndSelect
        
        ;\\ items events
        Select eventtype
          Case #__event_MouseEnter,
               #__event_MouseLeave,
               #__event_MouseMove,
               #__event_Focus,
               #__event_LostFocus,
               #__event_LeftButtonDown,
               #__event_LeftButtonUp,
               #__event_LeftDoubleClick,
               #__event_Left3Click,
               #__event_LeftClick,
               #__event_Drop
            
            
            If *this\row
              Protected mouse_x, mouse_y
              mouse_x = mouse( )\x - *this\x[#__c_inner]
              mouse_y = mouse( )\y - *this\y[#__c_inner] - *this\scroll_y( )
              
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
        
        ;\\ widgets events
        Select *this\type
          Case #__type_Window
            Window_events( *this, eventtype, mouse_x, mouse_y )
            
            ;\\
          Case #__type_combobox
            If eventtype = #__event_Down
              If mouse( )\buttons & #PB_Canvas_LeftButton
                If *this\PopupBox( )
                  Display( *this\PopupBox( ), *this )
                EndIf
              EndIf
            EndIf
            
            ;\\
          Case #__type_Button, #__type_ButtonImage
            If *this\state\check = #False
              Select eventtype
                Case #__event_MouseEnter
                  If *this\state\press
                    *this\color\state = #__S_2
                  Else
                    *this\color\state = #__S_1
                  EndIf
                  
                Case #__event_MouseLeave
                  ; If Not *this\state\press
                  *this\color\state = #__S_0
                  ; EndIf
                  
                Case #__event_Down
                  If mouse( )\buttons & #PB_Canvas_LeftButton
                    *this\color\state = #__S_2
                  EndIf
                  If *this\type = #__type_ButtonImage
                    If *this\image[#__image_pressed]\id
                      *this\image = *this\image[#__image_pressed]
                    EndIf
                  EndIf
                  
                Case #__event_Up
                  If mouse( )\buttons & #PB_Canvas_LeftButton
                    If *this\state\enter
                      *this\color\state = #__S_1
                    Else
                      *this\color\state = #__S_0
                    EndIf
                  EndIf
                  If *this\type = #__type_ButtonImage
                    If *this\image[#__image_released]\id
                      *this\image = *this\image[#__image_released]
                    EndIf
                  EndIf
                  
              EndSelect
            EndIf
            
            If eventtype = #__event_Up
              If *this\state\enter
                If mouse( )\buttons & #PB_Canvas_LeftButton
                  ;\\
                  If *this\flag & #PB_Button_Toggle
                    If SetState( *this, Bool( *this\state\check ! 1 ))
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;\\
          Case #__type_Option
            If eventtype = #__event_LeftClick
              If SetState( *this, #True )
                
              EndIf
            EndIf
            
            ;\\
          Case #__type_checkBox
            If eventtype = #__event_LeftClick
              If SetState( *this, Bool( *this\state\check ! 1 ) )
                
              EndIf
            EndIf
            
          Case #__type_HyperLink
            If *this\state\enter
              ; Debug *this\state\enter
            EndIf
            
            ;             If Not mouse( )\buttons
            ;               If Atpoint( *this, mouse_x - *this\x, mouse_y - *this\y, [#__c_required] )
            ;                 If *this\color\state = #__s_0
            ;                   *this\color\state = #__s_1
            ;                   ;_set_cursor_( *this, #PB_Cursor_Hand )
            ;                   Repaint = #True
            ;                 EndIf
            ;               Else
            ;                 If *this\color\state = #__s_1
            ;                   *this\color\state = #__s_0
            ;                   ;_set_cursor_( *this, #PB_Cursor_Default )
            ;                   Repaint = #True
            ;                 EndIf
            ;               EndIf
            ;             EndIf
            ;
            ;             ; if mouse enter text
            ;             If *this\color\state = #__s_1
            ;               If eventtype = #__event_LeftClick
            ;                 ; Send( #__event_LeftClick, *this )
            ;               EndIf
            ;               If eventtype = #__event_LeftButtonUp
            ;                ; _set_cursor_( *this, #PB_Cursor_Hand )
            ;                 Repaint = #True
            ;               EndIf
            ;               If eventtype = #__event_LeftButtonDown
            ;                 ; _set_cursor_( *this, #PB_Cursor_Default )
            ;                 *this\color\state = #__s_0
            ;                 Repaint = 1
            ;               EndIf
            ;             EndIf
            ;             If eventtype = #__event_MouseEnter
            ;               ;_set_cursor_( *this, #PB_Cursor_Default )
            ;             EndIf
            
            
          Case #__type_Tree, #__type_ListIcon
            Tree_events( *this, eventtype, mouse_x, mouse_y )
            
          Case #__type_Editor, #__type_String
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
        
        ;\\
        If PopupWidget( )
          If PopupWidget( ) = *this
            If eventtype = #__event_LeftClick
              ;\\ ComboBox( )
              If *this\_root( )\_parent( )
                SetText( *this\_root( )\_parent( ), GetItemText( PopupWidget( ), GetState( PopupWidget( ) ) ) )
                ; PostCanvasRepaint( *this\_root( )\_parent( ) )
                
                If IsWindow( GetWindow( GetRoot( PopupWidget( ) ) ) )
                  Display( PopupWidget( ), *this\_root( )\_parent( ) )
                  SetActiveWindow( GetWindow( GetRoot( *this\_root( )\_parent( ) ) ) )
                EndIf
              EndIf
            EndIf
          Else
            ;\\ hide popup widget
            If eventtype = #__event_Down
              If PopupWidget( ) <> *this\_parent( ) And
                 ( *this\PopupBox( ) And PopupWidget( ) = *this\PopupBox( ) ) = 0
                Display( PopupWidget( ), *this )
                PopupWidget( ) = #Null
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;\\ widget::_events_Anchors( )
      If a_transform_( *this )
        If a_events( *this, eventtype, *button, *data)
          *this\state\repaint = #True
        EndIf
      EndIf
      
      ;\\ before post-widget-events change cursor
      If eventtype = #__event_CursorUpdate
        Cursor::Set( *this\_root( )\canvas\gadget, mouse( )\cursor )
      EndIf
      
      ;\\ before post-widget-events drop
      If eventtype = #__event_Drop
        If mouse( )\drag\actions & #PB_Drag_Drop
          mouse( )\drag\x      = a_selector( )\x - *this\x[#__c_inner]
          mouse( )\drag\y      = a_selector( )\y - *this\y[#__c_inner]
          mouse( )\drag\width  = a_selector( )\width
          mouse( )\drag\height = a_selector( )\height
        Else
          mouse( )\drag\x = mouse( )\x - *this\x[#__c_inner] - *this\scroll_x( )
          mouse( )\drag\y = mouse( )\y - *this\y[#__c_inner] - *this\scroll_y( )
          
;           Protected dx =  mouse( )\delta\x - PressedWidget( )\_parent( )\x[#__c_inner] - PressedWidget( )\_parent( )\scroll_x( ) + PressedWidget( )\bs
;           Protected dy =   mouse( )\delta\y - PressedWidget( )\_parent( )\y[#__c_inner] - PressedWidget( )\_parent( )\scroll_y( ) + PressedWidget( )\bs
;           Debug ""+dx+" "+dy
          
;           ;\\ потому что точки внутри контейнера перемешаем надо перемести и детей
;           If Not *this\attach 
;             If *this\_a_\transform And  
;                (*this\_parent( )\container > 0 And
;                 *this\_parent( )\type <> #__type_MDI)
;               mouse( )\drag\x + *this\_parent( )\fs
;               mouse( )\drag\y + *this\_parent( )\fs
;             EndIf
;           EndIf
          
          mouse( )\drag\string = GetClass( PressedWidget( ) )
          mouse( )\drag\width  = #PB_Ignore
          mouse( )\drag\height = #PB_Ignore
        EndIf
        
        ;\\
        If *this\row And
           *this\EnteredRow( ) And
           *this\EnteredRow( )\state\enter
          
          If *this\EnteredRow( )\state\enter < 0
            *button = *this\EnteredRow( )\index
            *data   = mouse( )\x | mouse( )\y
          Else
            *button = *this\EnteredRow( )\index + 1
            *data   = mouse( )\x | mouse( )\y
          EndIf
        EndIf
      EndIf
      
      ;\\ mouse wheel horizontal
      If eventtype = #__event_MouseWheelX
        ; Debug "wheelX " + *data
        If *this\scroll And *this\scroll\h And
           bar_SetState( *this\scroll\h, *this\scroll\h\bar\page\pos - mouse( )\wheel\x )
          *this\state\repaint = #True
        EndIf
      EndIf
      
      ;\\ mouse wheel verticl
      If eventtype = #__event_MouseWheelY
        ; Debug "wheelY " + *data
        If *this\scroll And *this\scroll\v And
           bar_SetState( *this\scroll\v, *this\scroll\v\bar\page\pos - mouse( )\wheel\y )
          *this\state\repaint = #True
        EndIf
      EndIf
      
      ;\\ post-widget-events
      If *this\_root( )
        If Not *this\state\disable
          If eventtype = #__event_MouseMove
            If *this\event And *this\event\move
              Post( *this, eventtype, *button, *data )
            EndIf
          ElseIf eventtype = #__event_StatusChange
            If *this\event And *this\event\statusChange
              Post( *this, eventtype, *button, *data )
            EndIf
          Else
            Post( *this, eventtype, *button, *data )
          EndIf
        EndIf
      EndIf
      
      ;\\ enabled mouse behavior
      If eventtype = #__event_LeftButtonDown
        If *this\type = #__type_Splitter
          If EnteredButton( ) And EnteredButton( )\state\enter
            mouse( )\interact = #True
          EndIf
        EndIf
      EndIf
      
      ;\\ after post-widget-events dragStart
      If eventtype = #__event_DragStart
        If mouse( )\drag
          DropState( *this )
          If mouse( )\drag\actions & #PB_Drag_Drop
            mouse( )\interact = #True
          EndIf
        Else
          ; mouse( )\interact = #True
        EndIf
      EndIf
      
      ;\\ after post-widget-events then drop if create new widget
      If eventtype = #__event_Drop
        If *this <> Widget( )
          ReDraw(Root( ))
          mouse( )\interact = #True
        EndIf
      EndIf
      
      ;\\ cursor update
      Select eventtype
        Case #__event_MouseEnter, #__event_MouseMove, #__event_Up
          If PressedWidget( ) And PressedWidget( )\state\press
            If mouse( )\cursor <> PressedWidget( )\cursor
              ; Debug " cursor-press-change - " + mouse( )\cursor + " >> " + PressedWidget( )\cursor
              mouse( )\cursor = PressedWidget( )\cursor
              DoEvents( PressedWidget( ), #__event_CursorUpdate )
            EndIf
          Else
            If *this\state\enter = 2
              If mouse( )\cursor <> *this\cursor
                ; Debug " cursor-this-change - " + mouse( )\cursor + " >> " + *this\cursor
                mouse( )\cursor = *this\cursor
                DoEvents( *this, #__event_CursorUpdate )
              EndIf
            ElseIf EnteredWidget( ) And
                   EnteredWidget( )\state\enter = 2
              
              If PressedWidget( ) And
                 PressedWidget( )\_root( ) <> EnteredWidget( )\_root( )
                mouse( )\cursor = #PB_Cursor_Default
              EndIf
              
              If mouse( )\cursor <> EnteredWidget( )\cursor
                ; Debug " cursor-entered-change - " + mouse( )\cursor + " >> " + EnteredWidget( )\cursor
                mouse( )\cursor = EnteredWidget( )\cursor
                DoEvents( EnteredWidget( ), #__event_CursorUpdate )
              EndIf
            Else
              If mouse( )\cursor <> #PB_Cursor_Default
                ; Debug " cursor-reset-leave - " + mouse( )\cursor + " >> " + #PB_Cursor_Default +" "+ *this\class
                mouse( )\cursor = #PB_Cursor_Default
                ;               If PressedWidget( ) And PressedWidget( )\_root( ) = Root( )
                ;                 DoEvents( PressedWidget( ), #__event_CursorUpdate )
                ;               Else
                ;                 If *this
                DoEvents( *this, #__event_CursorUpdate )
                ;                 EndIf
                ;               EndIf
              EndIf
            EndIf
          EndIf
      EndSelect
      
      ;\\ post repaint canvas
      If Not *this\state\disable
        If *this\state\repaint = #True
          PostCanvasRepaint( *this )
          *this\state\repaint = #False
        EndIf
      EndIf
    EndProcedure
    
    Procedure EventHandler( Canvas = - 1, eventtype = - 1, eventdata = 0 )
      Protected Repaint, mouse_x , mouse_y
      
      ;\\
      If eventtype = #__event_LeftButtonUp Or
         eventtype = #__event_MiddleButtonUp Or
         eventtype = #__event_RightButtonUp
        
        If Root( )
          If Root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( Root( )\canvas\ResizeBeginWidget, #__event_ResizeEnd )
            Root( )\canvas\ResizeBeginWidget = #Null
          EndIf
          
          ;           ;\\
          ;           If PressedWidget( ) And
          ;              Root( ) <> PressedWidget( )\_root( )
          ;             Canvas = Root( )\canvas\gadget
          ;           EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_MouseEnter
        If Not mouse( )\interact
          If IsGadget( Canvas ) And
             GadgetType( Canvas ) = #PB_GadgetType_Canvas
            ChangeCurrentRoot( GadgetID( Canvas ) )
            ; Debug "canvas - enter "+Canvas +" "+ Root( )
          EndIf
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_MouseLeave
        If PressedWidget( ) And
           Root( ) <> PressedWidget( )\_root( )
          Canvas = PressedWidget( )\_root( )\canvas\gadget
          ChangeCurrentRoot( GadgetID( PressedWidget( )\_root( )\canvas\gadget ) )
          ; Debug "canvas - leave "+Canvas +" "+ Root( )
        EndIf
      EndIf
      
      ;\\
      If eventtype = #__event_Repaint ; = 262150
        If IsGadget( Canvas ) And GadgetType( Canvas ) = #PB_GadgetType_Canvas
          PushMapPosition( Root( ) )
          If ChangeCurrentRoot( GadgetID( Canvas ) )
            
            ;
            If Root( )\canvas\repaint = #True
              
              If EventData( ) = #__event_Create
                If Root( )\canvas\ResizeBeginWidget
                  ; Debug "   end - resize " + #PB_Compiler_Procedure
                  Post( Root( )\canvas\ResizeBeginWidget, #__event_ResizeEnd )
                  Root( )\canvas\ResizeBeginWidget = #Null
                EndIf
              EndIf
              
              ReDraw( Root( ) )
              Root( )\canvas\repaint = #False
            EndIf
          EndIf
          PopMapPosition( Root( ) )
          
          ;
          If Not mouse( )\interact
            If EnteredGadget( ) >= 0 And
               EnteredGadget( ) <> Canvas
              If IsGadget( EnteredGadget( ) )
                ChangeCurrentRoot( GadgetID( EnteredGadget( ) ) )
              Else
                ChangeCurrentRoot( GadgetID( Canvas ) )
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;Debug "  event - "+EventType +" "+ Root( )\canvas\gadget +" "+ Canvas +" "+ EventData( )
      EndIf
      
      ;\\
      If eventtype = #__event_KeyDown Or
         eventtype = #__event_Input Or
         eventtype = #__event_KeyUp
        
        If FocusedWidget( )
          Keyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Modifiers )
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            If Keyboard( )\key[1] & #PB_Canvas_Command
              Keyboard( )\key[1] & ~ #PB_Canvas_Command
              Keyboard( )\key[1] | #PB_Canvas_Control
            EndIf
          CompilerEndIf
          
          ;\\
          If eventtype = #__event_Input
            Keyboard( )\input = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Input )
          ElseIf eventtype = #__event_KeyDown Or eventtype = #__event_KeyUp
            Keyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\_root( )\canvas\gadget, #PB_Canvas_Key )
          EndIf
          
          ;\\ keyboard events
          DoEvents( FocusedWidget( ), eventtype )
          
          ;\\ change keyboard focus-widget
          If eventtype = #__event_KeyDown And Not FocusedWidget( )\_a_\transform
            Select Keyboard( )\Key
              Case #PB_Shortcut_Tab
                If FocusedWidget( )\after\widget And
                   FocusedWidget( ) <> FocusedWidget( )\after\widget
                  SetActive( FocusedWidget( )\after\widget )
                ElseIf FocusedWidget( )\first\widget And
                       FocusedWidget( ) <> FocusedWidget( )\first\widget
                  SetActive( FocusedWidget( )\first\widget )
                ElseIf FocusedWidget( ) <> FocusedWidget( )\_root( )\first\widget
                  SetActive( FocusedWidget( )\_root( )\first\widget )
                EndIf
            EndSelect
          EndIf
          
          ;\\
          If eventtype = #__event_KeyUp
            Keyboard( )\key[1] = 0
            Keyboard( )\Key    = 0
          EndIf
        EndIf
      EndIf
      
      ;\\
      If EventType = #__event_Resize ;: PB(ResizeGadget)( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        PushMapPosition( Root( ) )
        If ChangeCurrentRoot( GadgetID( Canvas ) )
          Resize( Root( ), 0, 0, PB(GadgetWidth)( Canvas ), PB(GadgetHeight)( Canvas ) )
          ReDraw( Root( ) )
        EndIf
        PopMapPosition( Root( ) )
      EndIf
      
      ;\\
      If Root( ) And Root( )\canvas\gadget = Canvas
        ;\\
        Select eventtype
          Case #__event_MouseEnter,
               #__event_MouseLeave,
               #__event_MouseMove
            
            mouse_x = CanvasMouseX( Root( )\canvas\gadget )
            mouse_y = CanvasMouseY( Root( )\canvas\gadget )
            
            ;?
            If mouse_x < 0 : mouse_x = - 1 : EndIf
            If mouse_y < 0 : mouse_y = - 1 : EndIf
            
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
              If mouse( )\x <> mouse_x
                If mouse( )\x < mouse_x
                  mouse( )\change | 1 << 3
                Else
                  mouse( )\change | 1 << 1
                EndIf
                mouse( )\x = mouse_x
              EndIf
              If mouse( )\y <> mouse_y
                If mouse( )\x < mouse_x
                  mouse( )\change | 1 << 4
                Else
                  mouse( )\change | 1 << 2
                EndIf
                mouse( )\y = mouse_y
              EndIf
            EndIf
            
            ;  Debug ""+mouse( )\x +" "+ mouse( )\y
            
          Case #__event_LeftButtonDown,
               #__event_RightButtonDown,
               #__event_MiddleButtonDown
            
            mouse( )\change = 1 << 5
            
            If eventtype = #__event_LeftButtonDown
              mouse( )\buttons | #PB_Canvas_LeftButton
            EndIf
            If eventtype = #__event_RightButtonDown
              mouse( )\buttons | #PB_Canvas_RightButton
            EndIf
            If eventtype = #__event_MiddleButtonDown
              mouse( )\buttons | #PB_Canvas_MiddleButton
            EndIf
            
          Case #__event_LeftButtonUp,
               #__event_RightButtonUp,
               #__event_MiddleButtonUp
            
            mouse( )\x      = CanvasMouseX( Root( )\canvas\gadget )
            mouse( )\y      = CanvasMouseY( Root( )\canvas\gadget )
            mouse( )\change = 1 << 6
        EndSelect
        
        ;\\ get enter&leave widget address
        If mouse( )\change
          ;\\ enter&leave mouse events
          If Not mouse( )\interact
            GetAtPoint( Root( ), mouse( )\x, mouse( )\y )
          EndIf
        EndIf
      EndIf
      
      ;\\ do all events
      If eventtype = #__event_Focus
        If FocusedWidget( )
          ; Debug "canvas - Focus " + FocusedWidget( ) + " " + GadgetType(Canvas)
          DoEvents( FocusedWidget( ), #__event_Focus )
        EndIf
        
      ElseIf eventtype = #__event_LostFocus
        If FocusedWidget( )
          ; Debug "canvas - LostFocus " + FocusedWidget( ) + " " + GadgetType(Canvas)
          DoEvents( FocusedWidget( ), #__event_LostFocus )
        EndIf
        
      ElseIf eventtype = #__event_MouseMove
        ;\\
        If mouse( )\change > 1
          ;\\ mouse-drag-start drag event
          If PressedWidget( ) And
             PressedWidget( )\state\press And
             PressedWidget( )\state\enter = 2 And
             PressedWidget( )\state\drag = #PB_Drag_None
            PressedWidget( )\state\drag = #PB_Drag_Update
            DoEvents( PressedWidget( ), #__event_DragStart )
          EndIf
          
          ;\\ mouse-pressed-widget move event
          If PressedWidget( ) And
             PressedWidget( )\state\drag And
             PressedWidget( ) <> EnteredWidget( )
            mouse( )\x = CanvasMouseX( PressedWidget( )\_root( )\canvas\gadget )
            mouse( )\y = CanvasMouseY( PressedWidget( )\_root( )\canvas\gadget )
            DoEvents( PressedWidget( ), #__event_MouseMove )
          EndIf
          
          ;\\ mouse-entered-widget move event
          If EnteredWidget( ) And
             EnteredWidget( )\state\enter
            mouse( )\x = CanvasMouseX( Root( )\canvas\gadget )
            mouse( )\y = CanvasMouseY( Root( )\canvas\gadget )
            DoEvents( EnteredWidget( ), #__event_MouseMove )
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_LeftButtonDown Or
             eventtype = #__event_MiddleButtonDown Or
             eventtype = #__event_RightButtonDown
        
        ;\\
        If EnteredWidget( )
          PressedWidget( )             = EnteredWidget( )
          PressedWidget( )\state\press = #True
          
          ; Debug "canvas - press "+Canvas +" "+ Root( ) +" "+ PressedWidget( )\class
          
          If eventtype = #__event_LeftButtonDown Or
             eventtype = #__event_RightButtonDown
            
            If EnteredButton( ) > 0 And PressedWidget( )\bar
              ;\\ bar mouse delta pos
              mouse( )\delta\x = mouse( )\x - PressedWidget( )\bar\thumb\pos
              mouse( )\delta\y = mouse( )\y - PressedWidget( )\bar\thumb\pos
            Else
              mouse( )\delta\x = mouse( )\x - PressedWidget( )\x[#__c_container]
              mouse( )\delta\y = mouse( )\y - PressedWidget( )\y[#__c_container]
              
              ;             mouse( )\delta\x = mouse( )\x - PressedWidget( )\x[#__c_frame]
              ;             mouse( )\delta\y = mouse( )\y - PressedWidget( )\y[#__c_frame]
              
              If Not is_integral_( PressedWidget( )) And PressedWidget( )\_parent( )
                mouse( )\delta\x - PressedWidget( )\_parent( )\scroll_x( )
                mouse( )\delta\y - PressedWidget( )\_parent( )\scroll_y( )
              EndIf
            EndIf
          EndIf
          
          ;\\ set active widget
          If eventtype = #__event_LeftButtonDown
            If FocusedWidget( ) <> PressedWidget( )
              SetActive( PressedWidget( ))
            EndIf
          EndIf
          
          ;\\
          Static ClickTime.q
          Protected ElapsedMilliseconds.q = ElapsedMilliseconds( )
          If DoubleClickTime( ) > ( ElapsedMilliseconds - ClickTime ) + Bool( #PB_Compiler_OS = #PB_OS_Windows ) * 492
            mouse( )\click + 1
          Else
            mouse( )\click = 1
          EndIf
          ClickTime = ElapsedMilliseconds
          
          ;\\
          DoEvents( PressedWidget( ), #__event_Down )
          If mouse( )\click = 1
            DoEvents( PressedWidget( ), eventtype )
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_LeftButtonUp Or
             eventtype = #__event_MiddleButtonUp Or
             eventtype = #__event_RightButtonUp
        
        ;\\
        If PressedWidget( )
          ;           ;\\
          ;           If PressedWidget( )\_root( ) <> Root( )
          ;             ; mouse( )\interact = #True
          ;           EndIf
          
          ;\\ drag & drop stop
          If PressedWidget( )\state\drag
            If PressedWidget( )\state\drag <> #PB_Drag_Move
              PressedWidget( )\state\drag = #PB_Drag_Finish
            EndIf
            
            ;\\ do drop events
            If mouse( )\drag
              If mouse( )\drag\actions & #PB_Drag_Drop
                If PressedWidget( )\drop
                  DoEvents( PressedWidget( ), #__event_Drop )
                EndIf
              ElseIf mouse( )\drag\state = #PB_Drag_Enter
                If EnteredWidget( )\drop
                  DoEvents( EnteredWidget( ), #__event_Drop )
                EndIf
                ;               Else
                ;                 ;\\ если бросили на дочерный элемент 
                ;                 ;\\ например: скролл-бар у скроллареа
                ;                 If EnteredWidget( )\child And 
                ;                    Not EnteredWidget( )\container
                ;                   If EnteredWidget( )\_parent( )\drop
                ;                     DoEvents( EnteredWidget( )\_parent( ), #__event_Drop )
                ;                   EndIf
                ;                 EndIf
              EndIf
              
              ;\\ reset dragged cursor
              If mouse( )\drag\cursor = - 1
                mouse( )\drag\cursor = 0
              EndIf
              If PressedWidget( )\cursor <> mouse( )\drag\cursor
                Cursor::Free( PressedWidget( )\cursor )
                PressedWidget( )\cursor = mouse( )\drag\cursor
                mouse( )\drag\cursor    = 0
              EndIf
              
              ;\\ reset
              FreeStructure( mouse( )\drag)
              mouse( )\drag = #Null
            EndIf
          EndIf
          
          ;\\ do up&click events
          If PressedWidget( )\state\press
            If mouse( )\click
              ;\\ do up events
              If mouse( )\click = 1
                DoEvents( PressedWidget( ), eventtype )
              EndIf
              
              ;\\ do 3click events
              If mouse( )\click = 3
                If eventtype = #__event_LeftButtonUp
                  DoEvents( PressedWidget( ), #__event_Left3Click )
                EndIf
                If eventtype = #__event_RightButtonUp
                  DoEvents( PressedWidget( ), #__event_Right3Click )
                EndIf
                
                ;\\ do 2click events
              ElseIf mouse( )\click = 2
                If eventtype = #__event_LeftButtonUp
                  DoEvents( PressedWidget( ), #__event_Left2Click )
                EndIf
                If eventtype = #__event_RightButtonUp
                  DoEvents( PressedWidget( ), #__event_Right2Click )
                EndIf
                
                ;\\ do 1click events
              Else
                If Not PressedWidget( )\state\drag
                  If PressedWidget( ) = EnteredWidget( )
                    If eventtype = #__event_LeftButtonUp
                      DoEvents( PressedWidget( ), #__event_LeftClick )
                    EndIf
                    If eventtype = #__event_RightButtonUp
                      DoEvents( PressedWidget( ), #__event_RightClick )
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;\\ reset state
            PressedWidget( )\state\drag  = #PB_Drag_None
            PressedWidget( )\state\press = #False
            
            ;\\
            DoEvents( PressedWidget( ), #__event_Up )
          EndIf
          
          ;\\
          If mouse( )\interact
            If Canvas <> EnteredGadget( )
              Canvas = EnteredGadget( )
              If IsGadget( Canvas ) And
                 GadgetType( Canvas ) = #PB_GadgetType_Canvas
                ChangeCurrentRoot( GadgetID( Canvas ) )
                ; Debug "canvas - enter "+Canvas +" "+ Root( )
              EndIf
            EndIf
            
            Debug "canvas - up " + Canvas + " " + Root( )
            mouse( )\x = CanvasMouseX( Root( )\canvas\gadget )
            mouse( )\y = CanvasMouseY( Root( )\canvas\gadget )
            GetAtPoint( Root( ), mouse( )\x, mouse( )\y )
            mouse( )\interact = #False
          EndIf
          
          ;\\ then popup close
          If PressedWidget( )\hide And
             PressedWidget( )\_parent( )\type = #__type_ComboBox
            PressedWidget( ) = PressedWidget( )\_parent( )
          EndIf
        EndIf
        
        ;\\ reset mouse buttons
        If mouse( )\buttons
          If eventtype = #__event_LeftButtonUp
            mouse( )\buttons & ~ #PB_Canvas_LeftButton
          ElseIf eventtype = #__event_RightButtonUp
            mouse( )\buttons & ~ #PB_Canvas_RightButton
          ElseIf eventtype = #__event_MiddleButtonUp
            mouse( )\buttons & ~ #PB_Canvas_MiddleButton
          EndIf
          
          mouse( )\delta\x = 0
          mouse( )\delta\y = 0
        EndIf
        
      ElseIf eventtype = #__event_MouseWheelX
        If EnteredWidget( )
          mouse()\wheel\x = eventdata
          If is_integral_( EnteredWidget( ) )
            DoEvents( EnteredWidget( )\_parent( ), eventtype, eventdata )
          Else
            DoEvents( EnteredWidget( ), eventtype, eventdata )
          EndIf
        EndIf
        
      ElseIf eventtype = #__event_MouseWheelY
        If EnteredWidget( )
          mouse()\wheel\y = eventdata
          If is_integral_( EnteredWidget( ) )
            DoEvents( EnteredWidget( )\_parent( ), eventtype, eventdata )
          Else
            DoEvents( EnteredWidget( ), eventtype, eventdata )
          EndIf
        EndIf
        
      EndIf
      
      ; reset
      If mouse( )\change <> #False
        mouse( )\change = #False
      EndIf
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = GetWindowData( EventWindow( ))
      
      ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas ) * 2, WindowHeight( EventWindow( )) - GadgetY( canvas ) * 2 )
      ; PB(ResizeGadget)( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
    EndProcedure
    
    
    ;-
    Procedure.i CloseList( )
      Protected *open._s_WIDGET
      ; Debug "close - "+OpenedWidget( )\index;text\string
      
      If OpenedWidget( ) And
         OpenedWidget( )\_parent( ) ;; And OpenedWidget( )\_root( )\canvas\gadget = Root( )\canvas\gadget ; проблема при добавлении окон
        
        If OpenedWidget( )\_parent( )\type = #__type_MDI
          *open = OpenedWidget( )\_parent( )\_parent( )
        Else
          If OpenedWidget( )\ClosedWidget( )
            *open                           = OpenedWidget( )\ClosedWidget( )
            OpenedWidget( )\ClosedWidget( ) = #Null
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
      
      If *open = OpenedWidget( )
        If *open\_root( )\before\root
          UseGadgetList( WindowID(*open\_root( )\before\root\canvas\window))
          ; Debug ""+*open\_root( )\before\root\canvas\window +" "+OpenedWidget( )\_root( )\canvas\window
          *open = *open\_root( )\before\root
        EndIf
      EndIf
      
      If *open And
         OpenedWidget( ) <> *open
        OpenedWidget( ) = *open
        ; OpenList( *open )
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
        If *this\TabBox( )
          *this\TabBox( )\OpenedTabIndex( ) = item
        EndIf
        
        OpenedWidget( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure OpenPopup( *this._S_widget, x, y, width, height, flag = 0 , *parent = #PB_Any )
      Protected root
      Protected window
      Protected parent
      
      If IsWindow( *parent )
        parent = *parent
      EndIf
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        If flag & #PB_Window_BorderLess
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_MacOS
              window = OpenWindow( #PB_Any, 0, 0, 0, 0, "", 0, parent )
              ;             If CocoaMessage(0, WindowID(window), "hasShadow") = 0
              ;               CocoaMessage(0, WindowID(window), "setHasShadow:", 1)
              ;             EndIf
              ; CocoaMessage(0, WindowID(window), "styleMask") ; get
              
              CocoaMessage(0, WindowID(window), "setStyleMask:", 1 << 5)
              ; CocoaMessage(0, WindowID(window), "setStyleMask:", 1<<6)
              ; CocoaMessage(0, WindowID(0), "setStyleMask:", 1<<3|1<<6)
              
            CompilerDefault
              window = OpenWindow( #PB_Any, 0, 0, 0, 0, "", flag, parent )
          CompilerEndSelect
        Else
          window = OpenWindow( #PB_Any, 0, 0, 0, 0, "", flag, parent )
        EndIf
        
        ResizeWindow( window, x, y, width, height )
      CompilerElse
        window = OpenWindow( #PB_Any, x, y, width, height, "", #PB_Window_BorderLess | flag, parent )
      CompilerEndIf
      
      root = Open( window )
      
      ProcedureReturn root
    EndProcedure
    
    Procedure Open( Window, x.l = 0, y.l = 0, width.l = #PB_Ignore, height.l = #PB_Ignore, title$ = #Null$, flag.q = #Null, *parentID = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g, UseGadgetList, result
      
      ; init
      If Not MapSize(Root( ))
        events::SetCallback( @EventHandler( ) )
      Else
        If Root( )
          If Root( )\canvas\ResizeBeginWidget
            ; Debug "   end - resize " + #PB_Compiler_Procedure
            Post( Root( )\canvas\ResizeBeginWidget, #__event_ResizeEnd )
            Root( )\canvas\ResizeBeginWidget = #Null
          EndIf
        EndIf
      EndIf
      
      If width = #PB_Ignore And height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If PB(IsWindow)(Window) = 0
        If Window > 5000
          Window = #PB_Any
        EndIf
        w = OpenWindow( Window, x, y, width, height, title$, flag, *parentID )
        If Window = - 1 : Window = w : w = WindowID( Window ) : EndIf
        
        x = 0
        y = 0
        flag | #PB_Canvas_Container
      Else
        w = WindowID( Window )
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth( Window, #PB_Window_InnerCoordinate )
        If x And x <> #PB_Ignore
          width - x * 2
        EndIf
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight( Window, #PB_Window_InnerCoordinate )
        If y And y <> #PB_Ignore
          height - y * 2
        EndIf
      EndIf
      
      ; get a handle from the previous usage list
      If w
        UseGadgetList = UseGadgetList( w )
      EndIf
      
      ;
      If PB(IsGadget)(Canvas)
        g = GadgetID( Canvas )
      Else
        g = CanvasGadget( Canvas, x, y, width, height, Flag | #PB_Canvas_Keyboard )
        If Canvas = - 1 : Canvas = g : g = GadgetID( Canvas ) : EndIf
      EndIf
      
      ;
      If UseGadgetList And w <> UseGadgetList
        UseGadgetList( UseGadgetList )
      EndIf
      
      ;
      If Not ChangeCurrentRoot(g)
        result            = AddMapElement( Root( ), Str( g ) )
        Root( )           = AllocateStructure( _S_root )
        Root( )\type      = #__type_Container
        Root( )\container = #__type_Container
        
        ;         Root( )\fs = Bool( flag & #__flag_BorderLess = 0 )
        ;         Root( )\bs = Root( )\fs
        
        Root( )\class      = "Root"
        Root( )\_root( )   = Root( )
        Root( )\_window( ) = Root( )
        
        Root( )\color       = _get_colors_( )
        Root( )\text\fontID = PB_( GetGadgetFont )( #PB_Default )
        
        ;
        Root( )\canvas\window  = Window
        Root( )\canvas\gadget  = Canvas
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
        
        If width Or height
          Resize( Root( ), #PB_Ignore, #PB_Ignore, width, height )
        EndIf
        
        ; post repaint canvas event
        PostCanvasRepaint( Root( ), #__event_Create )
        
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
          SetWindowPos_( g, #GW_HWNDFIRST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE )
        CompilerEndIf
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ; CocoaMessage(0, g, "setBoxType:", #NSBoxCustom)
          ; CocoaMessage(0, g, "setBorderType:", #NSLineBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSGrooveBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSBezelBorder)
          ; CocoaMessage(0, g, "setBorderType:", #NSNoBorder)
          
          ;;;CocoaMessage(0, w, "makeFirstResponder:", g)
          
          ; CocoaMessage(0, GadgetID(0), "setFillColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          ; CocoaMessage(0, WindowID(w), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
          
        CompilerEndIf
      EndIf
      
      If Drawing( )
        StopDrawing( )
      EndIf
      Drawing( ) = StartDrawing( CanvasOutput( Root( )\canvas\gadget ))
      If Drawing( )
        draw_font_( Root( ) )
        ;         ; StopDrawing( )
      EndIf
      
      ProcedureReturn Root( )
    EndProcedure
    
    Procedure.i Window( x.l, y.l, width.l, height.l, Text.s, flag.q = 0, *parent._S_widget = 0 )
      ;Protected *this.allocate( Widget )
      Protected *root._s_root = OpenedWidget( )\_root( )
      Protected MapSize = MapSize( root( ) )
      
      With *this
        Static pos_x.l, pos_y.l
        
        Protected *this._S_widget
        If MapSize And
           Not ListSize( EnumWidget( ) ) And
           Flag & #__flag_autosize = #__flag_autosize
          
          x              = 0
          y              = 0
          width          = *root\width
          height         = *root\height
          *root\autosize = #True
          *this          = *root
        Else
          *this.allocate( Widget )
        EndIf
        
        
        ;
        *this\flag  = Flag
        *this\type  = #__type_window
        *this\class = #PB_Compiler_Procedure
        ;       *this\round = round
        *this\state\create  = #True
        *this\state\repaint = #True
        
        *this\x[#__c_frame]      = #PB_Ignore
        *this\y[#__c_frame]      = #PB_Ignore
        *this\width[#__c_frame]  = #PB_Ignore
        *this\height[#__c_frame] = #PB_Ignore
        
        *this\color = _get_colors_( )
        
        *this\caption\round    = 4
        *this\caption\_padding = *this\caption\round
        *this\caption\color    = _get_colors_( )
        
        ;\caption\hide = constants::_check_( flag, #__flag_borderless )
        *this\caption\hide                     = constants::_check_( *this\flag, #__Window_titleBar, #False )
        *this\caption\button[#__wb_close]\hide = constants::_check_( *this\flag, #__Window_SystemMenu, #False )
        *this\caption\button[#__wb_maxi]\hide  = constants::_check_( *this\flag, #__Window_MaximizeGadget, #False )
        *this\caption\button[#__wb_mini]\hide  = constants::_check_( *this\flag, #__Window_MinimizeGadget, #False )
        *this\caption\button[#__wb_help]\hide  = 1
        
        *this\caption\button[#__wb_close]\color = colors::*this\red
        *this\caption\button[#__wb_maxi]\color  = colors::*this\blue
        *this\caption\button[#__wb_mini]\color  = colors::*this\green
        
        *this\caption\button[#__wb_close]\color\state = 1
        *this\caption\button[#__wb_maxi]\color\state  = 1
        *this\caption\button[#__wb_mini]\color\state  = 1
        
        *this\caption\button[#__wb_close]\round = 4 + 3
        *this\caption\button[#__wb_maxi]\round  = *this\caption\button[#__wb_close]\round
        *this\caption\button[#__wb_mini]\round  = *this\caption\button[#__wb_close]\round
        *this\caption\button[#__wb_help]\round  = *this\caption\button[#__wb_close]\round
        
        *this\caption\button[#__wb_close]\width  = 12 + 2
        *this\caption\button[#__wb_close]\height = 12 + 2
        
        *this\caption\button[#__wb_maxi]\width  = *this\caption\button[#__wb_close]\width
        *this\caption\button[#__wb_maxi]\height = *this\caption\button[#__wb_close]\height
        
        *this\caption\button[#__wb_mini]\width  = *this\caption\button[#__wb_close]\width
        *this\caption\button[#__wb_mini]\height = *this\caption\button[#__wb_close]\height
        
        *this\caption\button[#__wb_help]\width  = *this\caption\button[#__wb_close]\width * 2
        *this\caption\button[#__wb_help]\height = *this\caption\button[#__wb_close]\height
        
        If *this\caption\button[#__wb_maxi]\hide = 0 Or
           *this\caption\button[#__wb_mini]\hide = 0
          *this\caption\button[#__wb_close]\hide = 0
        EndIf
        
        If *this\caption\button[#__wb_close]\hide = 0
          *this\caption\hide = 0
        EndIf
        
        If Not *this\caption\hide
          *this\barHeight = constants::_check_( *this\flag, #__flag_borderless, #False ) * ( #__window_caption_height ); + #__window_frame_size )
          *this\round     = 7
          
          *this\caption\text\padding\x = 5
          *this\caption\text\string    = Text
        EndIf
        
        *this\child = Bool( *this\Flag & #__window_child = #__window_child )
        ; border frame size
        *this\fs = constants::_check_( *this\flag, #__flag_borderless, #False ) * #__window_frame_size
        
        *this\container = *this\type
        
        *this\color      = _get_colors_( )
        *this\color\back = $FFF9F9F9
        
        ; Background image
        *this\image\img = - 1
        
        ;
        *this\bs = *this\fs
        
        If x = #PB_Ignore : If a_transform( ) : x = pos_x + a_transform( )\grid_size : Else : x = pos_x : EndIf : EndIf : pos_x = x + #__window_frame_size
        If y = #PB_Ignore : If a_transform( ) : y = pos_y + a_transform( )\grid_size : Else : y = pos_y : EndIf : EndIf : pos_y = y + #__window_frame_size + #__window_caption_height
        
        ; open root list
        If Not MapSize
          If OpenPopup( *this, x, y, width + *this\fs * 2, height + *this\fs * 2 + *this\barHeight, Flag, *parent )
            x = 0
            y = 0
          EndIf
        EndIf
        
        ;
        If *parent
          If *root = *parent
            *root\_parent( ) = *this
          EndIf
          
        Else
          *parent = *root
        EndIf
        
        If *parent
          If *this\child Or *parent\type <> #__type_window
            SetParent( *this, *parent, #PB_Default )
          Else
            
            If Not *parent\autosize And SetAttachment( *this, *parent, 0 )
              x - *parent\x[#__c_container] - (*parent\fs + (*parent\fs[1] + *parent\fs[3]))
              y - *parent\y[#__c_container] - (*parent\fs + (*parent\fs[2] + *parent\fs[4]))
            Else
              ; Debug "888888 "+ *parent +" "+ Root( )+" "+OpenedWidget( )
              SetParent( *this, *parent, #PB_Default )
            EndIf
          EndIf
        EndIf
        
        Resize( *this, x, y, width, height )
        
        If *this\flag & #__Window_NoGadgets = #False
          OpenList( *this )
        EndIf
        
        If *this\flag & #__Window_NoActivate = #False
          SetActive( *this )
        EndIf
        PostCanvasRepaint( *this, #__event_Create)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Gadget( Type.l, Gadget.i, x.l, Y.l, width.l, height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, flag.q = #Null, Window = -1, *CallBack = #Null )
      Protected *this, g
      
      If Window = - 1
        Window = GetActiveWindow( )
      EndIf
      ;;Debug Window
      Flag = FromPBFlag( Type, Flag ) | #__flag_autosize
      
      Open( Window, x, y, width, height, "", #PB_Canvas_Container, 0, *CallBack, Gadget )
      
      Select Type
        Case #__type_Tree : *this = Tree( 0, 0, width, height, flag )
        Case #__type_Text : *this = Text( 0, 0, width, height, Text, flag )
        Case #__type_Button : *this = Button( 0, 0, width, height, Text, flag )
        Case #__type_Option : *this = Option( 0, 0, width, height, Text, flag )
        Case #__type_CheckBox : *this = Checkbox( 0, 0, width, height, Text, flag )
        Case #__type_HyperLink : *this = HyperLink( 0, 0, width, height, Text, *param1, flag )
        Case #__type_Splitter : *this = Splitter( 0, 0, width, height, *param1, *param2, flag )
      EndSelect
      
      CloseGadgetList( )
      
      If Gadget = - 1
        Gadget = GetGadget( Root( ))
        g      = Gadget
      Else
        g = GadgetID( Gadget )
      EndIf
      
      ProcedureReturn g
    EndProcedure
    
    Procedure a_Object( x.l, y.l, width.l, height.l, text.s, Color.l, flag.q = #Null, framesize = 1 )
      Protected *this._S_widget
      If Not Alpha(Color)
        Color = Color & $FFFFFF | 255 << 24
      EndIf
      
      *this._S_widget = Container(x, y, width, height, #__flag_nogadgets)
      If text
        SetText( *this, text)
      EndIf
      
      SetFrame( *this, framesize)
      
      SetColor( *this, #__color_back, Color)
      If framesize
        SetColor( *this, #__color_frame, Color & $FFFFFF | 255 << 24)
      EndIf
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
          
          If PopupWindow( ) = *this
            PopupWindow( ) = #Null
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
          
          If *this\_parent( )\TabBox( )
            If *this\_parent( )\TabBox( ) = *this
              FreeStructure( *this\_parent( )\TabBox( ) )
              *this\_parent( )\TabBox( ) = 0
            EndIf
            *this\_parent( )\TabBox( ) = #Null
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
            If *this\_parent( )\splitter_gadget_1( ) = *this
              FreeStructure( *this\_parent( )\splitter_gadget_1( ) )
              *this\_parent( )\splitter_gadget_1( ) = 0
            EndIf
            If *this\_parent( )\splitter_gadget_2( ) = *this
              FreeStructure( *this\_parent( )\splitter_gadget_2( ) )
              *this\_parent( )\splitter_gadget_2( ) = 0
            EndIf
          EndIf
          
          ;
          If *this\_parent( )\count\childrens
            LastElement(*this\_widgets( ))
            Repeat
              If *this\_widgets( ) = *this Or IsChild( *this\_widgets( ), *this )
                If *this\_widgets( )\_root( )\count\childrens > 0
                  *this\_widgets( )\_root( )\count\childrens - 1
                  
                  If *this\_widgets( )\_parent( ) <> *this\_widgets( )\_root( )
                    *this\_widgets( )\_parent( )\count\childrens - 1
                  EndIf
                  
                  If *this\_widgets( )\TabBox( )
                    If *this\_widgets( )\TabBox( ) = *this\_widgets( )
                      Debug "   free - tab " + *this\_widgets( )\TabBox( )\class
                      FreeStructure( *this\_widgets( )\TabBox( ) )
                      *this\_widgets( )\TabBox( ) = 0
                    EndIf
                    *this\_widgets( )\TabBox( ) = #Null
                  EndIf
                  
                  If *this\_widgets( )\scroll
                    If *this\_widgets( )\scroll\v
                      Debug "   free - scroll-v " + *this\_widgets( )\scroll\v\class
                      FreeStructure( *this\_widgets( )\scroll\v )
                      *this\_widgets( )\scroll\v = 0
                    EndIf
                    If *this\_widgets( )\scroll\h
                      Debug "   free scroll-h - " + *this\_widgets( )\scroll\h\class
                      FreeStructure( *this\_widgets( )\scroll\h )
                      *this\_widgets( )\scroll\h = 0
                    EndIf
                    ; *this\_widgets( )\scroll = #Null
                  EndIf
                  
                  If *this\_widgets( )\type = #__type_Splitter
                    If *this\_widgets( )\splitter_gadget_1( )
                      Debug "   free - splitter - first " + *this\_widgets( )\splitter_gadget_1( )\class
                      FreeStructure( *this\_widgets( )\splitter_gadget_1( ) )
                      *this\_widgets( )\splitter_gadget_1( ) = 0
                    EndIf
                    If *this\_widgets( )\splitter_gadget_2( )
                      Debug "   free - splitter - second " + *this\_widgets( )\splitter_gadget_2( )\class
                      FreeStructure( *this\_widgets( )\splitter_gadget_2( ) )
                      *this\_widgets( )\splitter_gadget_2( ) = 0
                    EndIf
                  EndIf
                  
                  If *this\_widgets( )\attach
                    ;Debug " free - attach " +*this\_widgets( )\attach\_parent( )\class
                    *this\_widgets( )\attach\_parent( ) = 0
                    FreeStructure( *this\_widgets( )\attach )
                    *this\_widgets( )\attach = #Null
                  EndIf
                  
                  *this\_widgets( )\address = 0
                  Debug " free - " + *this\_widgets( )\class
                  DeleteElement( *this\_widgets( ), 1 )
                EndIf
                
                If *this\_root( )\count\childrens = 0
                  Break
                EndIf
              ElseIf PreviousElement( *this\_widgets( )) = 0
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
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      ProcedureC WindowCloseHandler(*Widget.GtkWidget, *Event.GdkEventAny, UserData.I)
        gtk_main_quit_( )
      EndProcedure
    CompilerEndIf
    
    Procedure WaitEvents( *this._s_WIDGET )
      ; https://www.purebasic.fr/english/viewtopic.php?p=570200&hilit=move+items#p570200
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "run")
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
        g_signal_connect_(*this\_root( )\canvas\window, "delete-event", @WindowCloseHandler( ), 0)
        g_signal_connect_(*this\_root( )\canvas\window, "destroy", @WindowCloseHandler( ), 0)
        gtk_main_( )
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
        Protected msg.MSG
        ;         If PeekMessage_(@msg,0,0,0,1)
        ;           TranslateMessage_(@msg)
        ;           DispatchMessage_(@msg)
        ;         Else
        ;           Sleep_(1)
        ;         EndIf
        
        While GetMessage_(@msg, #Null, 0, 0 )
          TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
          DispatchMessage_(msg)  ; посылает сообщение в функцию WindowProc.
          
          Debug "" + #PB_Compiler_Procedure + " " + msg\message + " " + msg\hwnd + " " + msg\lParam + " " + msg\wParam
          ;   If msg\wParam = #WM_QUIT
          ;     Debug "#WM_QUIT "
          ;   EndIf
        Wend
      CompilerEndIf
    EndProcedure
    
    Procedure MessageEvents( )
      If EventWidget( )
        Protected *this = EventWidget( )
        Protected *message = EventWidget( )\_window( )
        
        Select WidgetEventType( )
          Case #__event_MouseEnter
            ReDraw(Root( ))
          Case #__event_LeftButtonDown
            ReDraw(Root( ))
          Case #__event_LeftClick
            Select GetText( *this )
              Case "No" : SetData( *message, #PB_MessageRequester_No )     ; no
              Case "Yes" : SetData( *message, #PB_MessageRequester_Yes )   ; yes
              Case "Cancel" : SetData( *message, #PB_MessageRequester_Cancel ) ; cancel
            EndSelect
            
            ; exit main loop
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", *this)
            CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
              gtk_main_quit_( )
            CompilerEndIf
        EndSelect
      EndIf
      ProcedureReturn #PB_Ignore
    EndProcedure
    
    Procedure Message( Title.s, Text.s, flag.q = #Null )
      Protected result
      Protected img = - 1, f1 = - 1, f2 = 8, width = 400, height = 120
      Protected bw = 85, bh = 25, iw = height - bh - f1 - f2 * 4 - 2 - 1
      
      Protected x = ( Root( )\width - width - #__window_frame_size * 2 ) / 2
      Protected y = ( Root( )\height - height - #__window_caption_height - #__window_frame_size * 2 ) / 2
      ;       Protected x = ( root( )\width-width )/2
      ;       Protected y = ( root( )\height-height )/2
      Protected *parent;._S_widget = EventWidget( )\_window( ) ; OpenedWidget( )
      
      Protected *message._s_WIDGET = Window( x, y, width, height, Title, #__window_titlebar, *parent)
      SetClass( *message, #PB_Compiler_Procedure )
      ;SetAlignment( Window,1, 0,0,0,0 )
      
      
      If Flag & #PB_MessageRequester_Info
        img = CatchImage( #PB_Any, ?img_info, ?end_img_info - ?img_info )
        
        DataSection
          img_info:
          ; size : 1404 bytes
          Data.q $0A1A0A0D474E5089, $524448490D000000, $2800000028000000, $B8FE8C0000000608, $474B62060000006D
          Data.q $A0FF00FF00FF0044, $493105000093A7BD, $5F98CD8558544144, $3B3BBFC71C47144C, $54C0F03D7F7BB707
          Data.q $14DA0D5AD0348C10, $7C1A6360A90B6D6D, $6D03CAADF49898D3, $D1A87D7AD262545F, $B69B5F469AA9349A
          Data.q $680D82AB6C37D269, $A6220B47FA51A890, $DECFEE38E105102A, $053FB87D333B772E, $CCDD3CF850EE114A
          Data.q $0766FDFE767ECCDC, $F476DC569948E258, $5BCA94AD89227ADA, $3C10B9638C15E085, $7A59504C89240017
          Data.q $8055B371E2774802, $2E678FEAA9A17AFC, $06961711C3AC7F58, $EF905DD4CA91A322, $A159B0EAD38F5EA2
          Data.q $4D30000CA9417358, $1A3033484098DD06, $2C671601A343EB08, $EDD3F547A138B820, $DAFB560A82C89ABE
          Data.q $2E1D2C863E5562A8, $3CD50AAB359173CC, $8D8C00262FCE6397, $83FB0DA43FD7D187, $DDAAFF5D74F85C02
          Data.q $B3A477582D666357, $45754E5D9B42C73C, $16732AAEDD894565, $41FBABA3A6B0899B, $3FAB16311F45A424
          Data.q $8FDB82C66F4B707F, $1595D6EF9001DD5F, $69B32B24BD2B2529, $EA0DEEB7E6181FDC, $9D9F369A5BB6326
          Data.q $A94FBDAEC7BBE0B7, $A732EAE5951BF5F4, $5C114204D2DD216D, $6B9C344C651BD9B9, $5F8FDB82CE66FAAA
          Data.q $5F57EDFEF90841DD, $8469F486ECB61D52, $C2634777AE971D35, $2A9E9FF5E072D5DC, $8DE85A9CB3A47758
          Data.q $4DCF559EDB963737, $0D1DD74741182C67, $C9DDD550E5F86C71, $E68DAFB555E65365, $79E522B2BAF36858
          Data.q $B2DAC765C78001C9, $8DAFB573522C2B62, $8F9455C8929B2E4E, $77B1059330B54E5C, $D579F26E672AD4E3
          Data.q $AC8D0E0F2BD2BD5F, $9F9532F8021F1304, $C910838758FEB56E, $816E0DF732515957, $DAAF81036D5F2CA9
          Data.q $C2E305A5E54F66D7, $73EED922E79850D2, $88B9E6F02BB0E0D9, $2241697952FB2AA2, $B51C5D50B8ACB1A3
          Data.q $69322368555B297F, $A654FC089009A54C, $1E34DD1B45EE65EE, $5F9F7579224403B7, $416D440905240B59
          Data.q $244059B47C668BBE, $56F2A644DDF22B00, $1EBC77E473482920, $E3DCB126CD5175A7, $E720A4816B952854
          Data.q $AA1C1F8C97DBB0A8, $3CE0A0A481CA0015, $2829A74C5DCDCD5F, $0F5481799C981CD6, $9356B8BCB2A56E0A
          Data.q $0B4C0AC3821950B0, $6188962AC4914B75, $8326E2692ED8B632, $32112C58C9006044, $ECE858E5B0989D1A
          Data.q $743677B1BE616735, $07BA4027E44A0623, $6C80F60B188E13D1, $829201DC00066B09, $8C96858E8E2EC9A6
          Data.q $805AC633A82068E1, $371FE43AD04336D4, $3E017C48017AE2C5, $292045C9C672091A, $FE17193FA6FF7E78
          Data.q $24BB170DC670F1B1, $228215E7B04759EC, $8381081FD341E657, $105A57F6BD342FFB, $B487FAFAA7631800
          Data.q $02CD8258AB7E1B4C, $7FAFA533BF1272D8, $0B4E95227E4D3348, $C2283FB0F4FD51EA, $448A12D9E3719E9A
          Data.q $A9D39441710FE231, $C02226AFBB60B4BC, $BE71A320F3D6FF0F, $B80C4880C5A02FD4, $EAE80059B3FE70FC
          Data.q $BFD96D3E2109AFBE, $33433E3653923D3E, $6181FDEF7925044E, $40CCA2BCC151695B, $BFB32F995BDBE050
          Data.q $4BD80C6A38598607, $EED1229FCE4E4FFB, $37BADFD58B1931AB, $9AC9DFBE734207A8, $31180DF76E30F1B1
          Data.q $484A73B9DC7FEBCE, $D7A5B83F9D2F4FFB, $F3E8DECDC7776C64, $77EFE7474D218F98, $BEA6C0F5ABB1CE75
          Data.q $E6D34B630E33E5E9, $D1DDEBF686899CB3, $30F1B1C9EBB3E0B1, $707F829A8EE8DF2E, $EB33FE99E7EAA9A1
          Data.q $92547BE745F7507E, $CF3D5948A6BB587F, $BB773989021B3939, $EE4FFEBB1CE0C06F, $17B5C8FDB00082A9
          Data.q $0D85E5765D9A9161, $D2CFBB3D8776A515, $B091079EAE8A2450, $58699FAF38C60FA6, $AAAC44AE240825E7
          Data.q $524EF9BCCF8048DA, $7CE63B71E6C2BC56, $B1F0FBBCC0BA9B3D, $B389F106710FE236, $E0B19105F4D4FFA4
          Data.q $4964FB2AA2BB5124, $96EF9053D965946A, $5542B5438A9C7B97, $AA218C9B953A9172, $F504091819AC204F
          Data.q $19C68C085CE323C7, $0AFC1667EBA1393B, $9132FEBD1DB62678, $0A88495AE54CAD78, $974C713C10AF0B93
          Data.q $C7A92409E9132188, $DA1DCE5A182B5934, $00FF3496B3E99DD4, $C5E52BD0901E71B2, $444E454900000000
          Data.b $AE, $42, $60, $82
          end_img_info:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Error
        img = CatchImage( #PB_Any, ?img_error, ?end_img_error - ?img_error )
        
        DataSection
          img_error:
          ; size : 1642 bytes
          Data.q $0A1A0A0D474E5089, $524448490D000000, $3000000030000000, $F902570000000608, $474B620600000087
          Data.q $A0FF00FF00FF0044, $491F06000093A7BD, $41D9ED8168544144, $CCEFF1C71DC7546C, $F6A06C4218C6ED7A
          Data.q $E448A410E515497A, $2070C40BB121A4E0, $46DC512B241A4E54, $124BD29004AB2039, $5150F4DA060B2630
          Data.q $52894889E9734815, $42B01552AB888955, $0A9535535581A8E4, $A69B1B838C151352, $0F5F9BEDFAF1DAF1
          Data.q $1B16F7DEBB3635DE, $DBF3D5DEB2E7A873, $8599BCFFBCCDEFCF, $8B999BBFFED0B685, $D94DFC3235B5A893
          Data.q $2AD241A8331E9177, $A24A50090AA21D50, $F4E23494382E38DF, $CDC2449B1FD5A692, $67C9F4601567BBF6
          Data.q $EA910FC176C73A56, $FB3E2C820C026811, $90FA231C4D0CFD92, $77E7A6B4722EFB8E, $3975B5B8601AF37D
          Data.q $E795079E6401C8E9, $718909C7B3E02570, $139E92E751637E23, $67B6C9EA403CB783, $16621CEA8257EE71
          Data.q $51DA72431163C9F8, $ED40125BADFBB67D, $B69198EA40D4D1ED, $E1CFD7F08E620A6A, $649A76066FAEE378
          Data.q $1CAF696A00B39BD2, $F8A5BF1E82DFA931, $B68B1E9F7E92E7EC, $10366C83462792C6, $9B483C679D1EDEDF
          Data.q $E5ADFDD3DFC7CA2B, $679B1D481A900EB3, $FD5FC5A1C6FDEE7C, $789EA5087457C832, $DF27E036FC740DB6
          Data.q $2EDEA7739A99E91B, $7D63573D4FD7C039, $091E176ECB121FEF, $3D92C5F7739E6BA1, $E3F8C8438CEC4B05
          Data.q $E338639DC7E0C287, $93E731F8D0BBE631, $A883C20B9CF064CA, $C03059C99BECC32E, $8A2A927678B696E8
          Data.q $6773962BC31DF31F, $5E32A40D35BC1ED7, $61AE34C8F7C47E20, $B482B75C33F7CFE9, $BD6DC8C3B3E18BF3
          Data.q $F3CE00E87774D0D6, $C8C73B8EC3301077, $1EAA53FC3F1397B7, $A3ED685DBED88879, $889BEB3C515EF88C
          Data.q $FBB987C6E2C3DC1F, $4F437B575A305FF5, $D8C99E55CF67C74C, $B432B0912802A16D, $0BD967DF31F98D05
          Data.q $2244C006A9AB295B, $95211F6B425F3AC4, $131BB7DFAF88CCC9, $17F2C3565D100089, $60D9F045FBE631B7
          Data.q $0C030246B6B523F0, $1BA0F14E30F0BF9F, $EF9127DDBFE58A36, $7DED884489AFFE4F, $0078CCC4F5CBAD05
          Data.q $A1A89BAF79FF3EF9, $AF17ABFAEFE27E38, $B54C2C7A40060436, $9FD33FDED83596F9, $D82EC4FA885E59F8
          Data.q $D0F7C463C6548EB0, $7ABDF473BC7CC6DA, $3F0026054BD3D308, $C1803039A9C479F1, $CC32DA5654B6183D
          Data.q $843D34389FD11F87, $875C6CC25F3AC4B5, $EFC7C8EAEF1236D6, $86D6458670FE883D, $6F207AF2E72123C2
          Data.q $EE229FADFBFAF81E, $E35C19F88FCEA52F, $89B8CABF4FF7EA1A, $F8B374EBF5EC6161, $5A3FDFED5BFB10EC
          Data.q $524EA5751007B45D, $7B2B97B0FD822695, $BC3B99AC09EB4E0F, $A8050B7237754E04, $6194D2B63B9F052A
          Data.q $FCB800F3AFA5E83E, $D12A27E1D9A4A295, $FA6EE7C74A0110E2, $3343761C4CC77B89, $A4788CCDAA213002
          Data.q $66EA532260530BFC, $3698EAEF136AB9F0, $377FBE21937FAE6C, $F026FF1923335366, $598BE240181C3102
          Data.q $3270DA691B56A7E1, $666A6EC0EAEF12D6, $08BE902F11299324, $7D1CEF04E7174011, $C4AF2272F4B8079D
          Data.q $9181BE3CC1EC0FC6, $C085D20F121D8CEC, $B0DECF8273F38800, $621F92BD2E59CCE6, $A6A48DE6EC4EC1E5
          Data.q $181F3A4E3C00A70C, $F4D5891F61D388C0, $FF7BBCB9F7DE3E68, $9675385AC3B9B564, $5373410C15F6BBCB
          Data.q $ECEB025E38B489F6, $8C7F569A4B00C0E9, $4B1CE3220F0C5CB8, $4FE0BA3BE3E5365B, $7F45AC8B952B4C1F
          Data.q $2DEA844889EFC9EC, $AA5D23C40BBE782D, $091207B8325CECFD, $630A823C3166F487, $4543837863E1F7F9
          Data.q $19E4E8B5A54439F1, $CBEF0864EAFCBD2E, $4131B94C3B5E0641, $2D1D5E40D37B9078, $4D6E25BF5A1CA4B8
          Data.q $EEB9F085E5489FE6, $FC565ABAD19F3B4E, $A7A63EFBBDAE05E4, $6E687C654A927037, $E61DAF030B4B7AA2
          Data.q $3330F5B7215D7F8E, $DF6577BFDC7F695E, $FAD5F0000A84AF5F, $73E133C7EE175E27, $6A27DF318E73D6A5
          Data.q $EF9E3E769954FD08, $47491E3068863728, $99CE42CECBFF3FEA, $D060C40EE915C4D7, $1E3436B2A80CBC02
          Data.q $1F8B0DAC8B0C0A89, $CEE0189ADA5B5132, $7C316769C9AF2793, $336A9850616065F1, $19C98BB16DA138F5
          Data.q $ED9F556C6E8B7D37, $3A0F0BB71BC70B7E, $03198A7793FCFF1A, $E71DB45BAAEEE677, $EFB1DD41BC6F9DDE
          Data.q $B7736A17C8317D2C, $077E9A22B2A5A1BF, $E37DE9DE572F3CD8, $B9BF6727F58E9E45, $86F6AD189E4B100B
          Data.q $B13618F9EBF4207E, $F1370F06153E967B, $E8769E1B43D0C703, $DA14BFE31CD96208, $607AA16C6FE6341E
          Data.q $630AEDEA7739AB6A, $7C039E94863A4956, $152AAF8DE711D25A, $E681F06F91FCB30F, $65624DA80766477A
          Data.q $DDC7F71DC8CBF889, $35C804BCEC3342D1, $388C1EF7C0FABD81, $AA70FBA106B9CB35, $887D7214F8B2AA07
          Data.q $FB5D3D9D6F3A4E8B, $B6859B67A164B9D9, $FEEC7FED695A16D0, $00006B709A860323, $42AE444E45490000
          Data.b $60, $82
          
          
          end_img_error:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Warning
        img = CatchImage( #PB_Any, ?img_warning, ?end_img_warning - ?img_warning )
        
        DataSection
          img_warning:
          ; size : 1015 bytes
          Data.q $0A1A0A0D474E5089, $524448490D000000, $2800000028000000, $B8FE8C0000000608, $474B62060000006D
          Data.q $A0FF00FF00FF0044, $49AC03000093A7BD, $DD98ED8558544144, $67339F8718551C6B, $6BA934DBB3B3B267
          Data.q $60255624DDDB3493, $785E2A42F0458295, $068C4AF69BDA17E3, $030B4150FDBB362A, $D9AC514B49409622
          Data.q $86FF825726F0546E, $2968A4290537B482, $7B79EF7CD1F26F42, $CCECECDD9B68DDB1, $3DE7337B07E4DE84
          Data.q $CE73DE666FECFBEF, $BE4895C549A28EC0, $D18003BEE526913D, $1BC8E3E7C60FAABF, $9FECC2827EF8A00B
          Data.q $A661997980015464, $5B7351EBFBE505F3, $47813B9850001351, $53C3D570C7AAE19E, $B23A91C71FB3F205
          Data.q $DEADAC5DE7CBF283, $8B8B83D4866AB9E2, $A3501A8AC0BD75C0, $F5C1DD1FC946EE17, $A401C06F62B271D5
          Data.q $FA6A26F924D8AC80, $7E5A30F4E54A0E48, $5560C8F125D550E7, $EF525E4622D61FC1, $09839A235B0F5C4F
          Data.q $6801C1363A672499, $22528E5162499C81, $1C849B7E9D4CA034, $9B0B11E8E79A47A4, $D4275B0ADE94A961
          Data.q $86766961DF69962D, $ACF075B2DD97A5A7, $D5E5ADCCBFD61B82, $E0E70AD6ED2BCBC9, $01C25A643259C2E2
          Data.q $267D976692740A74, $BDB1C9941DB6A94C, $00648F1BCF26FAD8, $B2C7BE9AE0658040, $5EA769DE2F46A039
          Data.q $1126BD12FA3A0EFB, $4936293C09200E18, $A54A016D72DDA26B, $768E93EC9BC50878, $2E521BC80E33910B
          Data.q $141140605A676E1D, $A093744937932ADA, $8281A48D7ED62F67, $15A3F82459547171, $403871C753A9C1DC
          Data.q $06470A2CF737C256, $804094E82C78A9F8, $D268304CD1725D32, $92EA1CB5051ED691, $7565900D8BC67CFC
          Data.q $D18BC6D5D9712E8E, $117CC62E3760194C, $10E54E54A025BC24, $2A40E3FD026F2319, $6858AA64C64A1498
          Data.q $61F477CD41DADA15, $27D00E40F641C4E3, $8096E855B9759636, $67D2AF1465F163F2, $8B1B13EAEAE0D8EC
          Data.q $535855B2BD295223, $321995650B7DF140, $C60B95CDEEFB4C6E, $B8D66D1F4CB2AB43, $D29243E17FBD28B6
          Data.q $084F4AD2B684774F, $4859A46E52C3D2B8, $3D5D0669FAB94043, $435D5C1B6F49A0CF, $B3ACF95CB8C88D26
          Data.q $D9AFD513076370D1, $EC1E3B578FDB0E23, $4DE1A355F6B926C1, $FEC232053D2E5280, $8171BCABDB194E87
          Data.q $9B43A3CCF63AB911, $1D8D8BF4930EEB37, $1B03C18628DF29A2, $2381EFADB70E37E8, $5E94A941C87A1FFF
          Data.q $4653A34D7B30E2C3, $57BCFD90E834E96B, $37AF4AA6517A9634, $506499A04FDF1404, $4BE860F68ADAA152
          Data.q $7B4EB6B20E173A18, $DF46D1F2B907EA58, $CA9492773F250FFD, $BBF30895BD7115D2, $BF527F49C6E93C04
          Data.q $2DC126EA5CA400A4, $73BAB8046E349A0E, $A6B8292C73E17BD5, $BB85E8D406B15816, $05103AFB551D0735
          Data.q $DA95C00E05160EAE, $1B16FD43CE570957, $DA5DBF1B621FD38E, $EA54075063860747, $5917BB61884A7336
          Data.q $FBD40FF52823CC02, $FE37EB4DCBBCBAE0, $9BF9A436D938F722, $8ED1D8C6E3DEF555, $2EE409553D03EE00
          Data.q $4900000000FAB21F
          Data.b $45, $4E, $44, $AE, $42, $60, $82
          end_img_warning:
        EndDataSection
      EndIf
      
      
      Container( f1, f1, width - f1 * 2, height - bh - f1 - f2 * 2 - 1 )
      Image( f2, f2, iw, iw, img, #PB_Image_Border | #__flag_center )
      Text( f2 + iw + f2, f2, width - iw, iw, Text, #__text_center | #__text_left )
      CloseList( )
      
      Protected._S_widget *ok, *no, *cancel
      
      *ok = Button( width - bw - f2, height - bh - f2, bw, bh, "Ok");, #__button_Default )
      SetAlignment( *ok, 0, 0, 0, 1, 1 )
      
      If Flag & #PB_MessageRequester_YesNo Or
         Flag & #PB_MessageRequester_YesNoCancel
        SetText( *ok, "Yes" )
        *no = Button( width - ( bw + f2 ) * 2 - f2, height - bh - f2, bw, bh, "No" )
        SetAlignment( *no, 0, 0, 0, 1, 1 )
      EndIf
      
      If Flag & #PB_MessageRequester_YesNoCancel
        *cancel = Button( width - ( bw + f2 ) * 3 - f2 * 2, height - bh - f2, bw, bh, "Cancel" )
        SetAlignment( *cancel, 0, 0, 0, 1, 1 )
      EndIf
      
      ;
      Bind( *message, @MessageEvents( ))
      
      ;
      Sticky( *message, #True )
      ReDraw(*message\_root( ))
      
      ;
      WaitEvents( *message )
      
      Sticky( *message, #False )
      ReDraw(*message\_root( ))
      result = GetData( *message )
      ; close
      Free( *message )
      
      ProcedureReturn result
    EndProcedure
    
    Procedure WaitClose( *this._S_widget = #PB_Any, waitTime.l = 0 )
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
                      Debug "" + #PB_Compiler_Procedure + " " + Root( )
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
                ReDraw( Root( ) )
                Break
                
              ElseIf PBWindow = *window
                If Post( *window, #__event_Free )
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
        ;       Case #__event_Draw          : Debug "draw"
      Case #__event_MouseWheelX : Debug " - " + *this + " - wheel-x"
      Case #__event_MouseWheelY : Debug " - " + *this + " - wheel-y"
      Case #__event_Input : Debug " - " + *this + " - input"
      Case #__event_KeyDown : Debug " - " + *this + " - key-down"
      Case #__event_KeyUp : Debug " - " + *this + " - key-up"
      Case #__event_Focus : Debug " - " + *this + " - focus"
      Case #__event_LostFocus : Debug " - " + *this + " - lfocus"
      Case #__event_MouseEnter : Debug " - " + *this + " - enter"
      Case #__event_MouseLeave : Debug " - " + *this + " - leave"
      Case #__event_LeftButtonDown : Debug " - " + *this + " - down"
      Case #__event_DragStart : Debug " - " + *this + " - drag"
      Case #__event_Drop : Debug " - " + *this + " - drop"
      Case #__event_LeftButtonUp : Debug " - " + *this + " - up"
      Case #__event_LeftClick : Debug " - " + *this + " - click"
      Case #__event_LeftDoubleClick : Debug " - " + *this + " - 2_click"
    EndSelect
  EndProcedure
  
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  
  Define i
  Define *w._S_widget, *g._S_widget, editable
  Define *root._S_widget = Open(#window_0, 0, 0, 424, 352): *root\class = "root": SetText(*root, "root")
  
  ;BindWidgetEvent( *root, @BindEvents( ) )
  Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
  view = Container(10, 10, 406, 238, #PB_Container_Flat)
  SetColor(view, #PB_Gadget_BackColor, RGB(213, 213, 213))
  ;a_enable( widget( ), 15 )
  a_init( view, 15 )
  
  ;Define *a1._s_widget = image( 5+170,5+140,60,60, -1 )
  Define *a1._s_widget = Panel( 5 + 170, 5 + 140, 160, 160, #__flag_nogadgets )
  ;Define *a2._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
  Define *a2._s_widget = ScrollArea( 50, 45, 135, 95, 300, 300, 1, #__flag_nogadgets )
  Define *a3._s_widget = image( 150, 110, 60, 60, -1 )
  
  ; a_init( *a, 15 )
  a_set( *a1, #__a_size )
  
  CloseList( )
  size_value  = Track(56, 262, 240, 26, 0, 30)
  pos_value   = Track(56, 292, 240, 26, 0, 30)
  grid_value  = Track(56, 320, 240, 26, 0, 30)
  back_color  = Button(304, 264, 112, 32, "BackColor")
  frame_color = Button(304, 304, 112, 32, "FrameColor")
  size_text   = Text(8, 256, 40, 24, "0")
  pos_text    = Text(8, 288, 40, 24, "0")
  grid_text   = Text(8, 320, 40, 24, "0")
  
  SetState( size_value, 7 )
  SetState( pos_value, 3 )
  SetState( grid_value, 6 )
  
  ;\\Close( )
  
  ;;Bind( *root, @WidgetEventHandler( ) )
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;\\ Open Root0
  Define *root0._S_widget = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  Global *button_panel = Panel(10, 10, 200 + 60, 200)
  Define Text.s, m.s   = #LF$, a
  AddItem(*button_panel, -1, "1")
  *g = Editor(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  ;*g                 = Editor(10, 10, 200 + 60, 200, #__flag_gridlines);, #__flag_autosize)
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
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  
  ;\\
  AddItem(*button_panel, -1, "2")
  *g = Tree(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  a  = - 1
  AddItem(*g, a, "This is a long line.")
  AddItem(*g, a, "Who should show.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "I have to write the text in the box or not.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "The string must be very long.")
  AddItem(*g, a, "Otherwise it will not work.")
  For a = 0 To 2
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  ;\\
  AddItem(*button_panel, -1, "3")
  *g = ListIcon(0, 0, 0, 0, "Column_1", 90, #__flag_autosize | #__Flag_FullSelection | #__Flag_GridLines | #__Flag_CheckBoxes) ;: *g = GetGadgetData(g)
  For a = 1 To 2
    AddColumn(*g, a, "Column_" + Str(a + 1), 90)
  Next
  For a = 0 To 15
    AddItem(*g, a, Str(a) + "_Column_1" + #LF$ + Str(a) + "_Column_2" + #LF$ + Str(a) + "_Column_3" + #LF$ + Str(a) + "_Column_4", 0)
  Next
  
  SetState(*button_panel, 2)
  CloseList( ) ; close panel lists
  
  *g = String(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #__string_password | #__string_right)
  
  ;\\
  Procedure button_panel_events( )
    Select GetText( EventWidget( ) )
      Case "1"
        SetState(*button_panel, 0)
      Case "2"
        SetState(*button_panel, 1)
    EndSelect
  EndProcedure
  Bind(Button( 220, 220, 25, 50, "1"), @button_panel_events( ), #PB_EventType_LeftClick )
  Bind(Button( 220 + 25, 220, 25, 50, "2"), @button_panel_events( ), #PB_EventType_LeftClick )
  ;\\Close( )
  
  ;\\
  Define *root1._S_widget = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetText(*root1, "root1")
  ;BindWidgetEvent( *root1, @BindEvents( ) )
  
  ;\\Close( )
  
  Define *root2._S_widget = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  HyperLink( 10, 10, 80, 40, "HyperLink", RGB(105, 245, 44) )
  String( 60, 20, 60, 40, "String" )
  *w = ComboBox( 108, 30, 152, 40, #PB_ComboBox_Editable )
  For i = 1 To 100;0000
    AddItem(*w, i, "text-" + Str(i))
  Next
  SetState( *w, 3 )
  ;\\Close( )
  
  
  Define *root3._S_widget = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetText(*root3, "root3")
  ;BindWidgetEvent( *root3, @BindEvents( ) )
  ;\\Close( )
  
  Define *root4._S_widget = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetText(*root4, "root4")
  ;BindWidgetEvent( *root4, @BindEvents( ) )
  ;\\Close( )
  
  
  
  Define count = 2;0000
  #st          = 1
  Global mx    = #st, my = #st
  
  Define time = ElapsedMilliseconds( )
  
  Global *c, *panel._S_widget
  Procedure do_Events( )
    Select WidgetEventType( )
      Case #__event_LeftClick
        
        Select GetText( EventWidget( ) )
          Case "hide_2"
            hide(*c, 1)
            ; Disable(*c, 1)
            
          Case "show_2"
            hide(*c, 0)
            
        EndSelect
        
        ;         ;Case #__event_LeftButtonUp
        ;         ClearDebugOutput( )
        ;
        ;         If StartEnumerate(*panel);Root( ))
        ;           If Not hide(widget( )) ;And GetParent(widget( )) = *panel
        ;             Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
        ;           EndIf
        ;           StopEnumerate( )
        ;         EndIf
        
    EndSelect
  EndProcedure
  
  OpenList( *root1 )
  *panel = Panel(20, 20, 180 + 40, 180 + 60, editable) : SetText(*panel, "1")
  AddItem( *panel, -1, "item_1" )
  ;Button( 20,20, 80,80, "item_1")
  *g = Editor(0, 0, 0, 0, #__flag_autosize)
  For a = 0 To 2
    AddItem(*g, a, "Line " + Str(a))
  Next
  AddItem(*g, 3 + a, "")
  AddItem(*g, 4 + a, ~"define W_0 = Window( 282, \"Window_0\" )")
  AddItem(*g, 5 + a, "")
  For a = 6 To 8
    AddItem(*g, a, "Line " + Str(a))
  Next
  
  AddItem( *panel, -1, "item_2" )
  ; Button( 10,10, 80,80, "item_2")
  Bind(Button( 5, 5, 55, 22, "hide_2"), @do_Events( ))
  Bind(Button( 5, 30, 55, 22, "show_2"), @do_Events( ))
  
  *c        = Container(110, 5, 150, 155, #PB_Container_Flat)
  Define *p = Panel(10, 5, 150, 65)
  AddItem(*p, -1, "item-1")
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 25, "butt1")
  CloseList( )
  CloseList( )
  AddItem(*p, -1, "item-2")
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 25, "butt2")
  CloseList( )
  CloseList( )
  CloseList( )
  
  Container(10, 75, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 45, "butt1")
  CloseList( )
  CloseList( )
  CloseList( )
  CloseList( )
  
  AddItem( *panel, -1, "item_3" )
  
  SetText(Container(20, 20, 180, 180, editable), "4")
  SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets | editable), "5")
  SetText(Container(40, 20, 180, 180, editable), "6")
  Define seven = Container(20, 20, 180, 180, editable)
  SetText(seven, "      7")
  
  SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets | editable), "     8")
  SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets | editable), "     9")
  SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets | editable), "     10")
  
  CloseList( ) ; 7
  CloseList( ) ; 6
  SetText(Container(10, 45, 70, 180, editable), "11")
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets | editable), "12")
  SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets | editable), "13")
  SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets | editable), "14")
  
  SetText(Container(10, 45, 70, 180, editable), "15")
  SetText(Container(10, 5, 70, 180, editable), "16")
  SetText(Container(10, 5, 70, 180, editable), "17")
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets | editable), "18")
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
  SetText(Container( - 5, 80, 180, 50, #__Flag_NoGadgets | editable), "container-7")
  CloseList( ) ; 7
               ;OpenList( *panel )
  
  AddItem( *panel, -1, "item_4" )
  Button( 30, 30, 80, 80, "item_4")
  AddItem( *panel, -1, "item_5" )
  Button( 40, 40, 80, 80, "item_5")
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
  
  
  Button_2 = ComboBox( 20, 20, 150, 40)
  For i = 1 To 100;0000
    AddItem(Button_2, i, "text-" + Str(i))
  Next
  SetState( Button_2, 3 )
  
  ;Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3   = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  ;Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_4   = Progress(0, 0, 0, 0, 0, 100) : SetState(Button_4, 50) ; No need to specify size or coordinates
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
  Button_5   = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(10, 80, 250, 120, 0, Splitter_4, #PB_Splitter_Vertical)
  SetState(Splitter_5, 50)
  SetState(Splitter_4, 50)
  SetState(Splitter_3, 40)
  SetState(Splitter_1, 50)
  
  Spin(10, 210, 250, 25, 5, 30 )
  Spin(10, 240, 250, 25, 5, 30, #__spin_Plus)
  
  ;\\
  OpenList( *root3 )
  Define *tree = Tree( 10, 20, 150, 200, #__tree_multiselect)
  For i = 1 To 100;0000
    AddItem(*tree, i, "text-" + Str(i))
  Next
  SetState(*tree, 5 - 1)
  Container( 70, 180, 80, 80): CloseList( )
  
  ;\\
  *w = Tree( 100, 30, 100, 260 - 20 + 300, #__flag_borderless)
  SetColor( *w, #__color_back, $FF07EAF6 )
  For i = 1 To 10;00000
    AddItem(*w, i, "text-" + Str(i))
  Next
  
  ;\\
  *w = Tree( 180, 40, 100, 260 - 20 + 300, #__tree_checkboxes )
  For i = 1 To 100;0000
    If (i & 5)
      AddItem(*w, i, "text-" + Str(i), -1, 1 )
    Else
      AddItem(*w, i, "text-" + Str(i))
    EndIf
  Next
  
  Debug "--------  time --------- " + Str(ElapsedMilliseconds( ) - time)
  
  
  ;\\
  Define *window._S_widget
  Define i, y = 5
  OpenList( *root4 )
  For i = 1 To 4
    Window(5, y, 150, 95 + 2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)
    ;Container(5, y, 150, 95 + 2)
    If i = 2
      Disable( widget( ), 1)
    EndIf
    Container(5, 5, 120 + 2, 85 + 2) ;, #PB_Container_Flat)
    If i = 3
      CheckBox(10, 10, 100, 30, "CheckBox_" + Trim(Str(i + 10)))
      SetState( widget( ), 1 )
    ElseIf i = 4
      Option(10, 10, 100, 30, "Option_" + Trim(Str(i + 10)))
    Else
      Button(10, 10, 100, 30, "Button_" + Trim(Str(i + 10)))
    EndIf
    If i = 3
      Disable( widget( ), 1)
    EndIf
    If i = 4 Or i = 3
      Option(10, 45, 100, 30, "Option_" + Trim(Str(i + 20)))
      SetState( widget( ), 1 )
    Else
      Button(10, 45, 100, 30, "Button_" + Trim(Str(i + 20)))
    EndIf
    If i = 3
      Disable( widget( ), 1)
    EndIf
    CloseList( )
    ;CloseList( )
    y + 130
  Next
  
  SetActive(*tree)
  
  ; redraw(root( ))
  ;
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------------------------------------------------v----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------4--7--4------------------------------------------------------------------------------------------------
; EnableXP