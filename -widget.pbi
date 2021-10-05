EnableExplicit

Macro Atbox( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
  Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 And 
        _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
EndMacro

Macro Interrect( _addres_s_1_x_, _addres_s_1_y_, _addres_s_1_width_, _addres_s_1_height_,
                 _addres_s_2_x_, _addres_s_2_y_, _addres_s_2_width_, _addres_s_2_height_ )
  
  Bool(( _addres_s_1_x_ + _addres_s_1_width_ ) > _addres_s_2_x_ And _addres_s_1_x_ < ( _addres_s_2_x_ + _addres_s_2_width_ ) And 
       ( _addres_s_1_y_ + _addres_s_1_height_ ) > _addres_s_2_y_ And _addres_s_1_y_ < ( _addres_s_2_y_ + _addres_s_2_height_ ) );And ((( _addres_s_2_x_ + _addres_s_2_width_ ) - ( _addres_s_1_x_ + _addres_s_1_width_ ) ) Or (( _addres_s_2_y_ + _addres_s_2_height_ ) - ( _addres_s_1_y_ + _addres_s_1_height_ ) )) )
EndMacro


;- STRUCTURE
;{           }
;--     POINT
Structure _s_POINT
  x.l
  y.l
EndStructure
;--     COORDINATE
Structure _s_COORDINATE Extends _s_POINT
  width.l
  height.l
EndStructure
;--     STATE
Structure _s_STATE
  press.b
  enter.b
  drag.b
  focus.b
  ;active.b
  repaint.b
EndStructure
;--     COUNT
Structure _s_COUNT
  ;   index.l
  ;   type.l
  ;   events.l
  
  *items ; CountItems( ) 
  *parents
  *childrens
EndStructure
;--     DROP
Structure _s_DROP Extends _s_COORDINATE
  format.i
  actions.i
  privatetype.i
EndStructure
;--     DRAG
Structure _s_DRAG Extends _s_DROP
  value.i
  string.s
EndStructure
;--     OBJECT_TYPE
Structure _s_OBJECT_TYPE
  *row._s_ROW
  *widget._s_WIDGET
EndStructure
;--     STICKY
Structure _s_STICKY
  *tooltip._s_WIDGET ; tool tip element
  *widget._s_WIDGET  ; popup gadget element
  *window._s_WIDGET  ; top level window element
  *message._s_WIDGET ; message window element
EndStructure
;--     KEYBOARD
Structure _s_KEYBOARD ; Ok
  focused._s_OBJECT_TYPE ; keyboard focus element
  change.b
  input.c
  key.i[2]
EndStructure
;--     MOUSE
Structure _s_MOUSE Extends _s_POINT
  ;   interact.b ; determines the behavior of the mouse in a clamped (pushed) state
  ;   *button.__s_buttons[3]   ; at point element button
  
  entered._s_OBJECT_TYPE      ; mouse entered element
  pressed._s_OBJECT_TYPE      ; mouse button's pushed element
  leaved._s_OBJECT_TYPE       ; mouse leaved element
  
  wheel._s_POINT
  delta._s_POINT
  
  *drag._s_DRAG
  buttons.l               ; 
                          ;   change.b                ; if moved mouse this value #true
EndStructure
;--     COLOR
Structure _s_COLOR
  state.b ; entered; selected; disabled;
          ;   front.i[4]
          ;   line.i[4]
          ;   fore.i[4]
  back.i[4]
  frame.i[4]
  ;   _alpha.a[2]
  ;   *alpha.__s_color
EndStructure
;--     EDIT
Structure _s_EDIT Extends _s_COORDINATE
  pos.l
  len.l
  
  string.s
  change.b
  
  *color.__s_color
EndStructure
;--     TEXT
Structure _s_TEXT Extends _s_EDIT
  ;   ;     ;     Char.c
  ;   *fontID 
  ;   
  ;   StructureUnion
  ;     pass.b
  ;     lower.b
  ;     upper.b
  ;     numeric.b
  ;   EndStructureUnion
  ;   
  ;   editable.b
  ;   multiline.b
  ;   
  ;   invert.b
  ;   vertical.b
  ;   
  ;   ; short.__s_edit ; ".."
  ;   edit.__s_edit[4]
  ;   caret.__s_caret
  ;   syntax.__s_syntax
  ;   
  ;   ; short.__s_text ; сокращенный текст
  ;   
  ;   rotate.f
  ;   align.__s_align
  ;   padding.__s_point
EndStructure
;--     EVENT
Structure _s_PARENT
  *window._s_WIDGET
  *widget._s_WIDGET
  *item._s_ROW
EndStructure
;--     EVENT
Structure _s_EVENT
  *widget._s_WIDGET
  *type ; EventType( )
  *item ; Eventitems( )
  *data ; EventData( )
EndStructure
;--     OBJECT
Structure _s_OBJECT Extends _s_COORDINATE
  type.i
  index.i
  *Data
  *address
  
  visible.b
  
  *parent._s_WIDGET
  draw._s_COORDINATE
  color._s_COLOR
  count._s_COUNT
  state._s_STATE
  text._s_TEXT
  
  List *items._s_OBJECT( )
EndStructure
;--     ROW
Structure _s_ROW Extends _s_OBJECT
  ;*evented._s_ROW
  ;*focused._s_ROW
  ;   *entered._s_ROW
  ;   *pressed._s_ROW
  ;   *leaved._s_ROW
  *selected._s_ROW
EndStructure
;--     WIDGET
Structure _s_WIDGET Extends _s_OBJECT
  *window._s_WIDGET
  
  fs.l
  
  *root._s_ROOT     ; this root
  
  *drop._s_DROP
  *event._s_EVENT
  
  ;
  *row._s_ROW
  
  
  List *child._s_WIDGET( )
EndStructure
;--     CANVAS
Structure _s_CANVAS
  repaint.b
  
  window.i
  gadget.i
  
  ;*last._s_WIDGET
  ;*widget._s_WIDGET
  *parent._s_WIDGET 
EndStructure
;--     ROOT
Structure _s_ROOT Extends _s_WIDGET
  canvas._s_CANVAS
EndStructure
;--     STRUCT
Structure _s_STRUCT
  Map *root._s_ROOT( )   ;
  List *address._s_WIDGET( ) ; Widget( )\ - current element
  mouse._s_MOUSE             ; WidgetMouse( )\ - 
                             ; \entered\row._s_OBJECT_TYPE - mouse entered item
                             ; \entered\widget._s_OBJECT_TYPE - mouse entered element
                             ; \pressed\row._s_OBJECT_TYPE - mouse button's pushed item
                             ; \pressed\widget._s_OBJECT_TYPE - mouse button's pushed element
                             ; \leaved\row._s_OBJECT_TYPE - mouse leaved item
                             ; \leaved\widget._s_OBJECT_TYPE - mouse leaved element
                             ; \wheel\x._s_POINT
                             ; \wheel\y._s_POINT
                             ; \delta\x._s_POINT
                             ; \delta\y._s_POINT
  keyboard._s_KEYBOARD       ;
                             ;
  sticky._s_STICKY           ; \sticky\window._s_WIDGET - top level window element
                             ; \sticky\widget._s_WIDGET - popup gadget element
                             ; \sticky\message._s_WIDGET - message window element
                             ; \sticky\tooltip._s_WIDGET - tool tip gadget element
  event._s_EVENT             ;
EndStructure


;}

;- MACRO
;{       }
Macro allocate( _struct_name_, _struct_type_= )
  _s_#_struct_name_#_struct_type_ = AllocateStructure( _s_#_struct_name_ )
EndMacro

;-
Macro RootWidget( ) 
  *widget\root( )
EndMacro

Macro WidgetMouse( )
  *widget\mouse
EndMacro

Macro WidgetKeyboard( ) 
  *widget\keyboard
EndMacro

Macro WidgetEvent( )
  *widget\event
EndMacro

;-
Macro EnteredItem( )
  WidgetMouse( )\entered\row
EndMacro

Macro LeavedItem( )
  WidgetMouse( )\leaved\row
EndMacro

Macro PressedItem( )
  WidgetMouse( )\pressed\row
EndMacro

Macro FocusedItem( )
  WidgetKeyboard( )\focused\row
EndMacro

Macro EventItem( )
  WidgetEvent( )\item
EndMacro

;-
Macro Widget( ) 
  *widget\address( ) ;RootWidget( )\canvas\last
EndMacro             ; Returns last created widget address

Macro OpenedWidget( )
  RootWidget( )\canvas\parent
EndMacro ; Returns last parent opened-widget-list

Macro EnteredWidget( )
  WidgetMouse( )\entered\widget
EndMacro ; Returns mouse entered widget 

Macro LeavedWidget( )
  WidgetMouse( )\leaved\widget
EndMacro ; Returns mouse leaved widget 

Macro PressedWidget( )
  WidgetMouse( )\pressed\widget
EndMacro ; Returns mouse button's pressed widget

Macro FocusedWidget( ) 
  WidgetKeyboard( )\focused\widget
EndMacro ; Returns keyboard focused widget

;-
Macro EventWidget( ) 
  WidgetEvent( )\widget
EndMacro ; Returns current evented widget

Macro WidgetEventType( ) 
  WidgetEvent( )\type
EndMacro ; Returns evented widget event-type

Macro WidgetEventItem( ) 
  WidgetEvent( )\item
EndMacro ; Returns evented widget event-item

Macro WidgetEventData( ) 
  WidgetEvent( )\data
EndMacro ; Returns evented widget event-data

;-

;-
Macro PostRepaint( _addres_s_, _event_data_ = #Null )
  
  ;   If _addres_s_\canvas\state\repaint = #False 
  ;     _addres_s_\canvas\state\repaint = #True
  If _addres_s_\state\repaint = #False
    _addres_s_\state\repaint = #True
    PostEvent( #PB_Event_Gadget, _addres_s_\root\canvas\window, _addres_s_\root\canvas\gadget, #PB_EventType_Repaint, _addres_s_ );_event_data_ )
  EndIf
  ;   EndIf
EndMacro

Macro StartEnumerate( _parent_ )
  Bool( _parent_\count\childrens )
  
  ;   ;PushListPosition( Widget( ))
  ;   If _parent_\address
  ;     ChangeCurrentElement( _parent_\child( ), _parent_\address )
  ;   Else
  ;     ResetList( Widget( ))
  ;   EndIf
  ResetList( _parent_\child( ))
  While NextElement( _parent_\child( ))
    ;If _parent_\child( )\count\childrens
    CopyList( _parent_\child( ), widget())
    ;If ChildWidget( Widget( ), _parent_ )
  EndMacro
  
  ;     Macro AbortEnumerate( )
  ;       Break
  ;     EndMacro
  
  Macro StopEnumerate( ) ; _break_ = #True )
                         ;     Else
                         ;       ; If _break_ = #True
                         ;       Break
                         ;       ; EndIf
                         ;     EndIf
  Wend
  ;PopListPosition( Widget( ))
EndMacro



;}

;-

;- GLOBAL
;{        }
Global *widget.allocate( STRUCT )
Global NewList *draw._s_WIDGET( )
;}

;- CONSTANT
;{          }
; Enumeration
;   #___s_normal     = 0<<0  ; 0
;   ;#___s_select     = 1<<0  ; 1
;   #___s_expand     = 1<<1  ; 2
;   #___s_check      = 1<<2  ; 4
;   #___s_collapse   = 1<<3  ; 8
;   #___s_inbetween  = 1<<4  ; 16
;   
;   ;#___s_enter      = 1<<5  ; 32  ; mouse enter
;   ;#___s_focus      = 1<<6  ; 128 ; keyboard focus
;   ;#___s_disable    = 1<<7  ; 64  ; 
;   ;#___s_repaint    = 1<<8  ; 256
;   ;#___s_scroll     = 1<<9  ; 512
;   
;   ;#___s_drag       = 1<<10  ; 1024
;   ;#___s_drop       = 1<<11  ; 2048 ; drop enter state
;   
;   ;#___s_current    = 1<<12 ; 
; EndEnumeration

#__Flag_NoGadgets = 1024
#PB_GadgetType_Window = 100

Enumeration #PB_EventType_FirstCustomValue
  #PB_EventType_MouseWheelX
  #PB_EventType_MouseWheelY
  #PB_EventType_Repaint
  #PB_EventType_Create
  #PB_EventType_Drop
EndEnumeration
;}

;- DECLARE
;{         }
Declare DoWidgetEvents( *this._s_WIDGET, eventtype, *item._s_ROW = #Null )
;}


;-
Macro i_s_root( _addres_s_ )
  Bool( _addres_s_ = _addres_s_\root )
EndMacro

Procedure.i TypeFromClass( class.s )
  Protected result.i
  
  Select Trim( LCase( class.s ))
      ;Case "popupmenu"      : result = #PB_GadgetType_popupmenu
      ;case "property"       : result = #PB_GadgetType_property
    Case "window"         : result = #PB_GadgetType_window
      
    Case "button"         : result = #PB_GadgetType_Button
    Case "buttonimage"    : result = #PB_GadgetType_ButtonImage
    Case "calendar"       : result = #PB_GadgetType_Calendar
    Case "canvas"         : result = #PB_GadgetType_Canvas
    Case "checkbox"       : result = #PB_GadgetType_CheckBox
    Case "combobox"       : result = #PB_GadgetType_ComboBox
    Case "container"      : result = #PB_GadgetType_Container
    Case "date"           : result = #PB_GadgetType_Date
    Case "editor"         : result = #PB_GadgetType_Editor
    Case "explorercombo"  : result = #PB_GadgetType_ExplorerCombo
    Case "explorerlist"   : result = #PB_GadgetType_ExplorerList
    Case "explorertree"   : result = #PB_GadgetType_ExplorerTree
    Case "frame"          : result = #PB_GadgetType_Frame
    Case "hyperlink"      : result = #PB_GadgetType_HyperLink
    Case "image"          : result = #PB_GadgetType_Image
    Case "ipaddress"      : result = #PB_GadgetType_IPAddress
    Case "listicon"       : result = #PB_GadgetType_ListIcon
    Case "listview"       : result = #PB_GadgetType_ListView
    Case "mdi"            : result = #PB_GadgetType_MDI
    Case "opengl"         : result = #PB_GadgetType_OpenGL
    Case "option"         : result = #PB_GadgetType_Option
    Case "panel"          : result = #PB_GadgetType_Panel
    Case "progress"       : result = #PB_GadgetType_ProgressBar
    Case "scintilla"      : result = #PB_GadgetType_Scintilla
    Case "scrollarea"     : result = #PB_GadgetType_ScrollArea
    Case "scroll"         : result = #PB_GadgetType_ScrollBar
    Case "shortcut"       : result = #PB_GadgetType_Shortcut
    Case "spin"           : result = #PB_GadgetType_Spin
    Case "splitter"       : result = #PB_GadgetType_Splitter
    Case "string"         : result = #PB_GadgetType_String
    Case "text"           : result = #PB_GadgetType_Text
    Case "track"          : result = #PB_GadgetType_TrackBar
    Case "tree"           : result = #PB_GadgetType_Tree
    Case "unknown"        : result = #PB_GadgetType_Unknown
    Case "web"            : result = #PB_GadgetType_Web
  EndSelect
  
  ProcedureReturn result
EndProcedure

Procedure.s ClassFromEvent( event.i )
  Protected result.s
  
  Select event
      ;Case #PB_EventType_free             : result.s = "#PB_EventType_Free"    
    Case #PB_EventType_drop             : result.s = "#PB_EventType_Drop"
    Case #PB_EventType_create           : result.s = "#PB_EventType_Create"
    Case #PB_EventType_SizeItem         : result.s = "#PB_EventType_SizeItem"
      
    Case #PB_EventType_repaint          : result.s = "#PB_EventType_Repaint"
      ;Case #PB_EventType_resizeend        : result.s = "#PB_EventType_ResizeEnd"
      ;Case #PB_EventType_scrollchange     : result.s = "#PB_EventType_ScrollChange"
      
      ;Case #PB_EventType_closewindow      : result.s = "#PB_EventType_CloseWindow"
      ;Case #PB_EventType_maximizewindow   : result.s = "#PB_EventType_MaximizeWindow"
      ;Case #PB_EventType_minimizewindow   : result.s = "#PB_EventType_MinimizeWindow"
      ;Case #PB_EventType_restorewindow    : result.s = "#PB_EventType_RestoreWindow"
      
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
      ;Case #PB_EventType_returnkey        : result.s = "#PB_EventType_returnKey"
    Case #PB_EventType_CloseItem        : result.s = "#PB_EventType_CloseItem"
      
      ;Case #PB_EventType_Down             : result.s = "#PB_EventType_Down"
      ;Case #PB_EventType_Up               : result.s = "#PB_EventType_Up"
      
      ;Case #PB_EventType_mousewheelX      : result.s = "#PB_EventType_MouseWheelX"
      ;Case #PB_EventType_mousewheelY      : result.s = "#PB_EventType_MouseWheelY"
  EndSelect
  
  ProcedureReturn result.s
EndProcedure

Procedure  ChangeCurrentRootWidget( _canvas_gadget_addres_s_ )
  ProcedureReturn FindMapElement( RootWidget( ), Str( _canvas_gadget_addres_s_ ) )
EndProcedure


Procedure   ChildWidget( *this._s_WIDGET, *parent._s_WIDGET )
  Protected result 
  
  Repeat
    If *parent = *this\parent
      result = *this
      Break
    EndIf
    
    *this = *this\parent
  Until *this = *this\root 
  
  ProcedureReturn result
EndProcedure


Procedure EnterGadgetID( ) 
  Protected handle
  Protected EnterGadgetID, GadgetID
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      
      Protected WindowID
      Protected Cursorpos.q
      
      GetCursorPo_s_( @Cursorpos )
      WindowID = WindowFromPoint_( Cursorpos )
      ScreenToClient_(WindowID, @Cursorpos) 
      GadgetID = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      GetCursorPo_s_( @Cursorpos )
      WindowID = GetAncestor_( WindowID, #GA_ROOT )
      ScreenToClient_(WindowID, @Cursorpos) 
      WindowID = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      If IsGadget( GetDlgCtrlID_( GadgetID )) 
        If GadgetID = GadgetID( GetDlgCtrlID_( GadgetID ))
          WindowID = GadgetID
        Else
          ; SpinGadget
          If GetWindow_( GadgetID, #GW_HWNDPREV ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #W_s_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #W_s_CLIPSIBLINGS )
            EndIf
            WindowID = GetWindow_( GadgetID, #GW_HWNDPREV)
            
          ElseIf GetWindow_( GadgetID, #GW_HWNDNEXT ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #W_s_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #W_s_CLIPSIBLINGS )
            EndIf
            WindowID = GetWindow_( GadgetID, #GW_HWNDNEXT)
          EndIf
        EndIf
      Else
        If GetParent_( GadgetID )
          WindowID = GetParent_( GadgetID ) ; С веб гаджетом проблемы
                                            ;Debug WindowID ; 
        EndIf
      EndIf
      
      ; SplitterGadget( ) 
      Protected RealClass.S = Space(13) 
      GetClassName_( GetParent_( WindowID ), @RealClass, Len( RealClass ))
      If RealClass.S = "PureSplitter" : WindowID = GetParent_( WindowID ) : EndIf
      
      ;Debug WindowID
      ProcedureReturn WindowID
      
    CompilerCase #PB_OS_MacOS
      Protected win_id, win_cv, pt.NSPoint
      win_id = WindowID(EventWindow())
      win_cv = CocoaMessage(0, win_id, "contentView")
      CocoaMessage(@pt, win_id, "mouseLocationOutsideOfEventStream")
      handle = CocoaMessage(0, win_cv, "hitTest:@", @pt)
      
      ProcedureReturn handle
    CompilerCase #PB_OS_Linux
      Protected desktop_x, desktop_y, *GdkWindow.GdkWindowObject
      *GdkWindow.GdkWindowObject = gdk_window_at_pointer_(@desktop_x,@desktop_y)
      If *GdkWindow
        gdk_window_get_user_data_(*GdkWindow, @handle)
      Else
        handle = 0
      EndIf
      ProcedureReturn handle
      
  CompilerEndSelect
  
EndProcedure    

Procedure ResizeWidget( *this._s_WIDGET, x,y,width,height )
  If *this
    *this\x = x
    *this\y = y
    *this\width = width
    *this\height = height
    
    ; init draw coordinate
    If *this\parent
      *this\visible = Interrect( 0, 0, *this\parent\width, *this\parent\height, *this\x, *this\y, *this\width, *this\height )
      
      If *this\visible
        If *this\draw\y > *this\y
          *this\draw\y = *this\parent\fs
        Else
          *this\draw\y = *this\y
        EndIf
        
        If *this\draw\x > *this\x
          *this\draw\x = *this\parent\fs
        Else
          *this\draw\x = *this\x
        EndIf
        
        If *this\width > (*this\parent\draw\width - *this\parent\fs) - *this\x
          *this\draw\width = (*this\parent\draw\width - *this\parent\fs) - *this\x
        Else
          If *this\draw\x > *this\x
            *this\draw\width = *this\width + *this\x - *this\parent\fs ;*this\x-*this\draw\x
                                                                       ;*this\draw\width = *this\parent\draw\width + *this\draw\width
          Else
            *this\draw\width = *this\width
          EndIf
        EndIf
        
        If *this\height > (*this\parent\draw\height - *this\parent\fs) - *this\y
          *this\draw\height = (*this\parent\draw\height - *this\parent\fs) - *this\y
        Else
          If *this\draw\y > *this\y
            *this\draw\height = *this\height + *this\y - *this\parent\fs ;*this\y-*this\draw\y
                                                                         ;*this\draw\height = *this\parent\draw\height + *this\draw\height
          Else
            *this\draw\height = *this\height
          EndIf
        EndIf
      EndIf
    Else
      *this\visible = 1
      *this\draw\x = *this\x 
      *this\draw\y = *this\y 
      *this\draw\width = *this\width 
      *this\draw\height = *this\height 
    EndIf
    
    
    ;     If *this\parent
    ;       If *this\parent\parent ;And *this\parent\parent\visible
    ;         *this\parent\visible = Interrect( 0, 0, *this\parent\parent\width, *this\parent\parent\height, *this\parent\x, *this\parent\y, *this\parent\width, *this\parent\height )
    ;       EndIf
    ;       If *this\parent\visible
    ;         *this\visible = Interrect( 0, 0, *this\parent\width, *this\parent\height, *this\x, *this\y, *this\width, *this\height )
    ;       EndIf
    ;     Else
    ;       ;If *this
    ;         Debug "root - "+*this\canvas\root\width
    ;       ;EndIf
    ;       *this\visible = Interrect( 0, 0, *this\canvas\root\width, *this\canvas\root\height, *this\x, *this\y, *this\width, *this\height )
    ;      ; *this\visible = Interrect( 0, 0, GadgetWidth(*this\canvas\gadget), GadgetHeight(*this\canvas\gadget), *this\x, *this\y, *this\width, *this\height )
    ;     EndIf
    ;     
    ;     If *this\visible
    ;       AddElement(*draw( ))
    ;       *draw( ) = *this
    ;     EndIf
    
    
    ; *this\visible = 1
  EndIf
EndProcedure

Procedure DrawFrame( *this._s_WIDGET, x, y, FrameColor, mode = 0 )
  Protected fs , dy, dx
  If mode = 2
    fs = *this\fs - 1
  EndIf
  
  ;   If Not ( *this\draw\y = *this\y And *this\height > *this\draw\height )
  ;     ;dy = fs
  ;   EndIf
  ;   If Not ( *this\draw\x = *this\x And *this\width > *this\draw\width )
  ;     dx = fs
  ;   EndIf
  
  If *this\draw\y = *this\y
    Line( x+*this\draw\x+fs, y+*this\draw\y+fs, *this\draw\width-fs*2, 1, FrameColor )
  EndIf
  If *this\draw\x = *this\x
    Line( x+*this\draw\x+fs, y+*this\draw\y+fs-dy, 1, *this\draw\height-fs*2, FrameColor )
  EndIf
  If Not ( *this\draw\x = *this\x And *this\width > *this\draw\width ) ; *this\parent And *this\x+*this\width < *this\parent\draw\width
    Line( x+*this\draw\x+*this\draw\width-1-fs, y+*this\draw\y+fs-dy, 1, *this\draw\height-fs*2, FrameColor )
  EndIf
  If Not ( *this\draw\y = *this\y And *this\height > *this\draw\height ) ; *this\parent And *this\y+*this\height < *this\parent\draw\height
    Line( x+*this\draw\x+fs, y+*this\draw\y+*this\draw\height-1-fs, *this\draw\width-fs*2, 1, FrameColor )
  EndIf
  
EndProcedure

Procedure DrawFirst( *this._s_WIDGET, x, y  )
  DrawingMode( #PB_2DDrawing_Default )
  Box( x+*this\draw\x, y+*this\draw\y, *this\draw\width, *this\draw\height, *this\color\back[*this\color\state] )
  
  Define yy = *this\fs
  ForEach *this\items( )
    If *this\height > yy
      *this\items( )\visible = 1
    EndIf
    
    
    If *this\items( )\visible
      *this\items( )\y = yy 
      
      DrawingMode( #PB_2DDrawing_Default )
      Box( x+*this\x+*this\items( )\x, y+*this\y+*this\items( )\y, *this\items( )\width, *this\items( )\height, *this\items( )\color\back )
      
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( x+*this\x+*this\items( )\x, y+*this\y+*this\items( )\y, *this\items( )\width, *this\items( )\height, *this\color\frame )
      
      DrawingMode( #PB_2DDrawing_Transparent )
      DrawText( x+*this\x+*this\items( )\x, y+*this\y+*this\items( )\y, *this\items( )\text\String, 0)
    EndIf
    
    yy + *this\items( )\height
  Next
  
  
  If *this\data
    DrawingMode( #PB_2DDrawing_Transparent )
    DrawText(  x+*this\x, y+*this\y, Str(*this\data), 0)
  EndIf
EndProcedure

Procedure DrawLast( *this._s_WIDGET, x, y  )
  DrawingMode( #PB_2DDrawing_Outlined )
  Box( x+*this\x, y+*this\y, *this\width, *this\height, $1DE6E8 )
  ;Box( x+*this\x+*this\fs-1, y+*this\y+*this\fs-1, *this\width-*this\fs*2+2, *this\height-*this\fs*2+2, *this\color\frame )
  
  If *this\fs
    DrawFrame( *this, x,y, *this\color\frame )
    If *this\fs > 1
      DrawFrame( *this, x,y, *this\color\frame, 2 )
    EndIf
  EndIf
EndProcedure

Procedure DrawWidget( *this._s_WIDGET, x, y )
  If *this\address
    If *this\visible 
      ;
      DrawFirst( *this, x, y )
      
      If *this\count\childrens
        ForEach *this\child( )
          If *this\child( ) And *this\child( )\visible 
            DrawWidget( *this\child( ), x+*this\x, y+*this\y )
          EndIf
        Next
      EndIf
      
      ;
      DrawLast( *this, x, y )
    EndIf
  EndIf
EndProcedure

Procedure ReDrawWidget( *this._s_WIDGET )
  Protected x,y
  
  If *this\address
    If *this\parent
      x = *this\parent\x
      y = *this\parent\y
    EndIf
    If StartDrawing( CanvasOutput( *this\root\canvas\gadget ) )
      FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
      DrawWidget( *this, x,y )
      StopDrawing( )
    EndIf
  EndIf
EndProcedure

Procedure FreeWidget( *this._s_WIDGET )
  If *this\count\childrens 
    *this\count\childrens = 0
    FreeList( *this\child( ) )
  EndIf
  
  If *this\parent
    If *this\address
      If *this\parent\count\childrens
        ChangeCurrentElement( *this\parent\child( ), *this\address )
        DeleteElement( *this\parent\child( ) )
        *this\parent\count\childrens - 1
      EndIf
      *this\address = #Null
    EndIf
  Else 
    ; it's root widget
    If *this = GetGadgetData( *this\root\canvas\gadget ) 
      SetGadgetData( *this\root\canvas\gadget, #Null )
    EndIf
  EndIf
  
  FreeStructure( @*this )
EndProcedure

Procedure SetParentWidget( *this._s_WIDGET, *parent._s_WIDGET )
  If *parent
    *parent\count\childrens + 1
    
    If *this\parent 
      *this\parent\count\childrens - 1
    EndIf
    
    *this\parent = *parent
    *this\root = *parent\root
    *this\window = *parent\window
    *this\count\parents = *parent\count\parents + 1
  EndIf
EndProcedure

Procedure AddItem( *this._s_WIDGET, position, text.s )
  Protected result, *item._s_OBJECT
  
  If *this
    *this\row.allocate( ROW )
    LastElement( *this\items( ) )
    result = AddElement( *this\items( ) )
    
    *item.allocate( OBJECT )
    *item\parent = *this
    *item\text\string = text
    
    *item\x = *this\fs
    *item\height = 20
    *item\width = *this\width - *this\fs*2
    
    *item\color\back = $8ED4C4
    
    *item\address = result
    *this\items( ) = *item
    
    
    ;     *this\items.allocate( OBJECT, ( ) )
    ;     *this\items( )\address = result
    ;     *this\items( )\parent = *this
    ;     *this\items( )\text\string = text
    ;     
    ;     *this\items( )\x = *this\fs
    ;     *this\items( )\height = 20
    ;     *this\items( )\width = *this\width - *this\fs*2
    ;     
    ;     *this\items( )\color\back = $8ED4C4
    
    *this\count\items + 1
    
    ;     If *this\items( )\address
    ;       SetParentWidget( *this\items( ), *this )
    ;       ResizeWidget( *this\items( ), x,y,width,height )
    ;       
    ;       DoWidgetEvents( *this\items( ), #PB_EventType_Create )
    ;       PostRepaint( *this\items( ), #PB_EventType_Repaint )
    ProcedureReturn *this\items( )
    ;     EndIf
  EndIf
EndProcedure

Procedure AddObject( *this._s_WIDGET, type, x,y,width,height, frameSize = 1)
  Protected result
  
  If *this
    LastElement( *this\child( ) )
    result = AddElement( *this\child( ) )
    If result
      *this\child( ) = AllocateStructure( _s_WIDGET )
      CopyList( *this\child( ), widget( ) )
      
      *this\child( )\fs = frameSize
      *this\child( )\address = result
      *this\child( )\color\back = $F3F3F3
      
      SetParentWidget( *this\child( ), *this )
      ResizeWidget( *this\child( ), x,y,width,height )
      
      DoWidgetEvents( *this\child( ), #PB_EventType_Create )
      PostRepaint( *this\child( ), #PB_EventType_Repaint )
      ProcedureReturn *this\child( )
    EndIf
  EndIf
EndProcedure

Procedure OpenList( *this._s_WIDGET )
  OpenedWidget( ) = *this
EndProcedure

Procedure CloseList( )
  If OpenedWidget( ) And OpenedWidget( )\parent And OpenedWidget( )\parent 
    OpenedWidget( ) = OpenedWidget( )\parent
  Else
    OpenedWidget( ) = RootWidget( )
  EndIf
EndProcedure

Procedure OpenCanvas( window, gadget, x,y,width,height, flag = 0 )
  Protected g, w
  
  If window =- 1
    window = OpenWindow( window, x,y,width,height, "", flag )
    x = 0
    y = 0
  EndIf
  
  If Not ( IsGadget( gadget ) And 
           GadgetType( gadget ) = #PB_GadgetType_Canvas )
    g = CanvasGadget( gadget, x,y,width,height, #PB_Canvas_Keyboard ) 
    If gadget =- 1 : gadget = g : EndIf 
    x = 0 : y = 0
  EndIf
  
  If Not FindMapElement( RootWidget( ), Str( GadgetID( gadget ) ) )
    AddMapElement( RootWidget( ), Str( GadgetID( gadget ) ) )
    RootWidget( ) = AllocateStructure( _s_ROOT )
    RootWidget( )\address = RootWidget( )
    
    RootWidget( )\fs = 1
    RootWidget( )\root = RootWidget( )
    RootWidget( )\canvas\window = window
    RootWidget( )\canvas\gadget = gadget
    
    ResizeWidget( RootWidget( ), x,y,width,height )
    OpenList( RootWidget( ) )
    
    DoWidgetEvents( RootWidget( ), #PB_EventType_Create )
    PostRepaint( RootWidget( ), #PB_EventType_Repaint ) ;
    ProcedureReturn RootWidget( )
  EndIf
EndProcedure

Procedure GetAtPointWidget( List *child._s_WIDGET( ), mouse_x, mouse_y )
  Protected result 
  
  LastElement( *child( ) )
  Repeat 
    If *child( ) And *child( )\visible And Atbox( *child( )\draw\x, *child( )\draw\y, *child( )\draw\width, *child( )\draw\height, mouse_x-*child( )\parent\x, mouse_y-*child( )\parent\y )
      If *child( )\count\childrens
        result = GetAtPointWidget( *child( )\child( ), mouse_x-*child( )\parent\x, mouse_y-*child( )\parent\y )
      EndIf
      
      If result = 0
        result = *child( )
      EndIf
      
      If result
        Break
      EndIf
    EndIf
  Until PreviousElement( *child( ) ) = 0
  
  ProcedureReturn result
EndProcedure

Procedure GetAtPointItem( List *object._s_OBJECT( ), mouse_x, mouse_y )
  Protected result
  
  LastElement( *object( ) )
  Repeat 
    If *object( )\visible And 
       Atbox( *object( )\x, *object( )\y, *object( )\width, *object( )\height, mouse_x, mouse_y )
      
      If *object( )\count\childrens
        result = GetAtPointItem( *object( )\items( ), mouse_x, mouse_y )
      EndIf
      
      If result = 0
        result = *object( )
      EndIf
      
      If result
        Break
      EndIf
    EndIf
  Until PreviousElement( *object( ) ) = 0
  
  ProcedureReturn result
EndProcedure

;-
Procedure SetWidgetFocus( *this._s_WIDGET )
  If FocusedWidget( ) <> *this
    If FocusedWidget( )
      FocusedWidget( )\state\focus = #False
      FocusedWidget( )\state\repaint = #True
      DoWidgetEvents( FocusedWidget( ), #PB_EventType_LostFocus, FocusedItem( ) )
    EndIf
    
    FocusedWidget( ) = *this
    FocusedWidget( )\state\focus = #True
    FocusedWidget( )\state\repaint = #True
    DoWidgetEvents( FocusedWidget( ), #PB_EventType_Focus, FocusedItem( ) )
  EndIf
EndProcedure

;-
Procedure.i PostEventWidget( eventtype.l, *this._s_WIDGET, *button = #PB_All, *data = #Null )
  
EndProcedure

Procedure.i PostWidgetEvent( *this._s_WIDGET, eventtype.l, *button = #PB_All, *data = #Null )
  ; WidgetEvent( ) = *this\canvas\event
  WidgetEvent( )\widget = *this
  WidgetEvent( )\type = eventtype
  WidgetEvent( )\item = *button
  WidgetEvent( )\data = *data
  
  CallCFunctionFast( *this\root\event\data )
EndProcedure

Procedure.i BindWidgetEvent( *this._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  If *this = *this\root
    If *callback
      If Not RootWidget( )\root\event
        RootWidget( )\root\event.allocate( EVENT )
      EndIf
      RootWidget( )\root\event\data = *callback
      RootWidget( )\root\event\type = eventtype
      RootWidget( )\root\event\item = item
    EndIf
  Else
    ;
    
  EndIf
EndProcedure

Procedure DoWidgetEvents( *this._s_WIDGET, eventtype, *item._s_ROW = #Null )
  EventItem( ) = *item
  EventWidget( ) = *this
  
  If Not *this
    Debug "   "+ ClassFromEvent(eventtype)
  EndIf
  If *this\state\enter
    If WidgetMouse( )\buttons
      *this\color\back = $00F7FF
    Else
      *this\color\back = $301DE8
    EndIf
    
  Else
    If eventtype = #PB_EventType_Repaint
      *this\color\back = $F3F3F3
    Else
      *this\color\back = $13FF00
    EndIf
  EndIf
  
  If *this\state\press
    If *this\state\drag 
      *this\color\back = $FFB1F8
    Else
      *this\color\back = $FFAA00
    EndIf
    
  ElseIf *this\state\focus
    *this\color\back = $FF0090
    
  EndIf
  
  If *item
    
    If *item\state\enter
      If *this\state\press
        *item\color\back = $00F7FF
      Else
        *item\color\back = $301DE8
      EndIf
      
    Else
      If eventtype = #PB_EventType_Repaint
        *item\color\back = $F3F3F3
      Else
        *item\color\back = $13FF00
      EndIf
    EndIf
    
    If *item\state\press
      If *item\state\drag 
        *item\color\back = $FFB1F8
      Else
        *item\color\back = $FFAA00
      EndIf
      
    ElseIf *item\state\focus
      *item\color\back = $FF0090
      
    EndIf
    *this\state\repaint = #True
  EndIf
  
  
  ;   Select eventtype
  ;       ;       Case #PB_EventType_Draw          : Debug "draw"         
  ;     Case #PB_EventType_MouseWheelX     : Debug  ""+ *this +" - wheel-x"
  ;     Case #PB_EventType_MouseWheelY     : Debug  ""+ *this +" - wheel-y"
  ;     Case #PB_EventType_Input           : Debug  ""+ *this +" - input"
  ;     Case #PB_EventType_KeyDown         : Debug  ""+ *this +" - key-down"
  ;     Case #PB_EventType_KeyUp           : Debug  ""+ *this +" - key-up"
  ;     Case #PB_EventType_Focus           : Debug  ""+ *this +" - focus"
  ;     Case #PB_EventType_LostFocus       : Debug  ""+ *this +" - lfocus"
  ;     Case #PB_EventType_MouseEnter      : Debug  ""+ *this +" - enter"
  ;     Case #PB_EventType_MouseLeave      : Debug  ""+ *this +" - leave"
  ;     Case #PB_EventType_LeftButtonDown  : Debug  ""+ *this +" - down"
  ;     Case #PB_EventType_DragStart       : Debug  ""+ *this +" - drag"
  ;     Case #PB_EventType_Drop            : Debug  ""+ *this +" - drop"
  ;     Case #PB_EventType_LeftButtonUp    : Debug  ""+ *this +" - up"
  ;     Case #PB_EventType_LeftClick       : Debug  ""+ *this +" - click"
  ;     Case #PB_EventType_LeftDoubleClick : Debug  ""+ *this +" - 2_click"
  ;   EndSelect
  
  ;
  If *this\root\event
    PostWidgetEvent( *this, eventtype, *item )
  EndIf
  
  ;
  If *this\state\repaint
    *this\state\repaint = 0
    ReDrawWidget( *this\root )
  EndIf
EndProcedure

Procedure WidgetsEvents( eventtype )
  If RootWidget( )
    Protected window = RootWidget( )\canvas\window
    Protected canvas = RootWidget( )\canvas\gadget
    
    If eventtype = #PB_EventType_Repaint
      ; DoWidgetEvents( EventWidget( ), EventData( ) )
      DoWidgetEvents( EventData( ), eventtype )
    EndIf
    
    ;
    If eventtype = #PB_EventType_MouseEnter Or 
       eventtype = #PB_EventType_MouseMove
      WidgetMouse( )\x = WindowMouseX( window ) - GadgetX( canvas, #PB_Gadget_WindowCoordinate ) ; GetGadgetAttribute( canvas, #PB_canvas_MouseX )
      WidgetMouse( )\y = WindowMouseY( window ) - GadgetY( canvas, #PB_Gadget_WindowCoordinate ) ; GetGadgetAttribute( canvas, #PB_canvas_MouseY )
      
      ; Debug " "+ WidgetMouse( )\x +" "+ WidgetMouse( )\y
    ElseIf eventtype = #PB_EventType_MouseLeave   
      WidgetMouse( )\x =- 1
      WidgetMouse( )\y =- 1
    EndIf
    If eventtype = #PB_EventType_LeftButtonDown
      WidgetMouse( )\buttons | #PB_Canvas_LeftButton
    ElseIf eventtype = #PB_EventType_RightButtonDown
      WidgetMouse( )\buttons | #PB_Canvas_RightButton
    ElseIf eventtype = #PB_EventType_MiddleButtonDown
      WidgetMouse( )\buttons | #PB_Canvas_MiddleButton
    EndIf
    If eventtype = #PB_EventType_LeftButtonUp
      WidgetMouse( )\buttons &~ #PB_Canvas_LeftButton
    ElseIf eventtype = #PB_EventType_RightButtonUp
      WidgetMouse( )\buttons &~ #PB_Canvas_RightButton
    ElseIf eventtype = #PB_EventType_MiddleButtonUp
      WidgetMouse( )\buttons &~ #PB_Canvas_MiddleButton
    EndIf
    
    ;
    If eventtype = #PB_EventType_MouseMove Or
       eventtype = #PB_EventType_MouseEnter Or
       eventtype = #PB_EventType_MouseLeave Or
       eventtype = #PB_EventType_LeftButtonDown Or 
       eventtype = #PB_EventType_RightButtonDown Or
       eventtype = #PB_EventType_MiddleButtonDown Or
       eventtype = #PB_EventType_LeftButtonUp Or 
       eventtype = #PB_EventType_RightButtonUp Or
       eventtype = #PB_EventType_MiddleButtonUp
      
      ;
      If RootWidget( )\count\childrens
        ; Define time = ElapsedMilliseconds( )
        EnteredWidget( ) = GetAtPointWidget( RootWidget( )\child( ), WidgetMouse( )\x, WidgetMouse( )\y )
        ; Debug ElapsedMilliseconds( ) - time
      EndIf
      
      If Not EnteredWidget( ) And RootWidget( )\visible And 
         Atbox( RootWidget( )\draw\x, RootWidget( )\draw\y, RootWidget( )\draw\width, RootWidget( )\draw\height, WidgetMouse( )\x, WidgetMouse( )\y )
        EnteredWidget( ) = RootWidget( )
      EndIf
      
      ; Debug ""+EnteredWidget( ) +" "+ WidgetMouse( )\x +" "+ WidgetMouse( )\y
      
      If EnteredWidget( )
        If EnteredWidget( )\count\items
          If Atbox( EnteredWidget( )\draw\x+EnteredWidget( )\fs, EnteredWidget( )\draw\y+EnteredWidget( )\fs, EnteredWidget( )\draw\width-EnteredWidget( )\fs*2, EnteredWidget( )\draw\height-EnteredWidget( )\fs*2, WidgetMouse( )\x, WidgetMouse( )\y )
            EnteredItem( ) = GetAtPointItem( EnteredWidget( )\items( ), WidgetMouse( )\x-EnteredWidget( )\x, WidgetMouse( )\y-EnteredWidget( )\y )
          Else
            EnteredItem( ) = #Null
          EndIf
          
          ; items state enter&leave
          If LeavedItem( ) <> EnteredItem( )
            If LeavedItem( )
              LeavedItem( )\state\enter = #False
              LeavedItem( )\state\repaint = #True
              If LeavedWidget( )
                DoWidgetEvents( LeavedWidget( ), #PB_EventType_StatusChange, LeavedItem( ) )
              EndIf
            EndIf
            
            LeavedItem( ) = EnteredItem( )
            
            If EnteredItem( ) And
               EnteredItem( )\state\enter = #False
              EnteredItem( )\state\enter = #True 
              EnteredItem( )\state\repaint = #True
              DoWidgetEvents( EnteredWidget( ), #PB_EventType_StatusChange, EnteredItem( ) )
            EndIf
          EndIf
        EndIf
      EndIf
      
      ; widgets state enter&leave
      If LeavedWidget( ) <> EnteredWidget( )
        If LeavedWidget( )
          LeavedWidget( )\state\enter = #False
          LeavedWidget( )\state\repaint = #True
          DoWidgetEvents( LeavedWidget( ), #PB_EventType_MouseLeave, LeavedItem( ) )
        EndIf
        
        LeavedWidget( ) = EnteredWidget( )
        
        If EnteredWidget( ) And
           EnteredWidget( )\state\enter = #False
          EnteredWidget( )\state\enter = #True 
          EnteredWidget( )\state\repaint = #True
          DoWidgetEvents( EnteredWidget( ), #PB_EventType_MouseEnter, EnteredItem( ) )
        EndIf
      EndIf
    EndIf
    
    ;
    If eventtype = #PB_EventType_MouseMove
      ;
      If PressedWidget( )
        If PressedWidget( )\state\drag = #False 
          PressedWidget( )\state\drag = #True
          PressedWidget( )\state\repaint = #True
          
          If PressedItem( ) And 
             PressedItem( )\state\drag = #False
            PressedItem( )\state\drag = #True
            PressedItem( )\state\repaint = #True
          EndIf
          
          DoWidgetEvents( PressedWidget( ), #PB_EventType_DragStart, PressedItem( ) )
        EndIf
        
        DoWidgetEvents( PressedWidget( ), eventtype, PressedItem( ) )
      ElseIf EnteredWidget( )
        DoWidgetEvents( EnteredWidget( ), eventtype, EnteredItem( ) )
      EndIf
    EndIf
    
    ;
    If eventtype = #PB_EventType_LeftButtonDown Or 
       eventtype = #PB_EventType_RightButtonDown Or
       eventtype = #PB_EventType_MiddleButtonDown
      
      If EnteredWidget( )
        If EnteredWidget( )\count\items
          If EnteredItem( )
            If EnteredWidget( )\row\selected <> EnteredItem( )
              If EnteredWidget( )\row\selected
                EnteredWidget( )\row\selected\state\focus = #False
                EnteredWidget( )\row\selected\state\repaint = #True
                DoWidgetEvents( EnteredWidget( ), #PB_EventType_StatusChange, EnteredWidget( )\row\selected )
              EndIf
              
              EnteredWidget( )\row\selected = EnteredItem( )
              EnteredWidget( )\row\selected\state\focus = #True
              EnteredWidget( )\row\selected\state\repaint = #True
              FocusedItem( ) = EnteredItem( )
            EndIf
            
            PressedItem( ) = EnteredItem( )
            PressedItem( )\state\press = #True
            PressedItem( )\state\repaint = #True
          EndIf
        EndIf
        
        ; set element focus
        SetWidgetFocus( EnteredWidget( ) )
        
        PressedWidget( ) = EnteredWidget( )
        PressedWidget( )\state\press = #True
        PressedWidget( )\state\repaint = #True
        DoWidgetEvents( PressedWidget( ), eventtype, PressedItem( ) )
      EndIf 
    EndIf
    
    ;
    If eventtype = #PB_EventType_LeftButtonUp Or 
       eventtype = #PB_EventType_RightButtonUp Or
       eventtype = #PB_EventType_MiddleButtonUp
      
      If PressedWidget( )
        PressedWidget( )\state\press = #False
        PressedWidget( )\state\repaint = #True
        
        If PressedItem( )
          PressedItem( )\state\press = #False
          PressedItem( )\state\repaint = #True
        EndIf
        DoWidgetEvents( PressedWidget( ), eventtype, PressedItem( ) )
        
        ;
        If PressedWidget( ) = EnteredWidget( ) 
          Static time_click
          
          ; do click events
          If eventtype = #PB_EventType_LeftButtonUp
            DoWidgetEvents( PressedWidget( ), #PB_EventType_LeftClick )
          EndIf
          If eventtype = #PB_EventType_RightButtonUp
            DoWidgetEvents( PressedWidget( ), #PB_EventType_RightClick )
          EndIf
          
          ; do double-click events 
          If time_click And 
             DoubleClickTime( ) > ( ElapsedMilliseconds( ) - time_click )
            If eventtype = #PB_EventType_LeftButtonUp
              DoWidgetEvents( PressedWidget( ), #PB_EventType_LeftDoubleClick )
            EndIf
            If eventtype = #PB_EventType_RightButtonUp
              DoWidgetEvents( PressedWidget( ), #PB_EventType_RightDoubleClick )
            EndIf
            time_click = 0
          Else
            time_click = ElapsedMilliseconds( )
          EndIf
        EndIf
        
        ;
        If PressedWidget( )\state\drag = #True
          PressedWidget( )\state\drag = #False
          If EnteredWidget( )
            EnteredWidget( )\state\repaint = #True
            
            If PressedItem( )
              If PressedItem( )\state\drag = #True
                PressedItem( )\state\drag = #False
                
                If EnteredItem( )
                  EnteredItem( )\state\repaint = #True
                EndIf
              EndIf
            EndIf
            
            DoWidgetEvents( EnteredWidget( ), #PB_EventType_Drop, EnteredItem( ) )
          EndIf
        EndIf
        
        PressedItem( ) = #Null
        PressedWidget( ) = #Null
      EndIf
    EndIf
    
    ;
    If eventtype = #PB_EventType_Input Or
       eventtype = #PB_EventType_KeyDown Or
       eventtype = #PB_EventType_KeyUp
      
      If FocusedWidget( )
        
        ; keyboard events
        If eventtype = #PB_EventType_Input
          WidgetKeyboard( )\input = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Input )
          DoWidgetEvents( FocusedWidget( ), #PB_EventType_Input, FocusedItem( ) )
        Else
          WidgetKeyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Key )
          WidgetKeyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Modifiers )
          DoWidgetEvents( FocusedWidget( ), eventtype, FocusedItem( ) )
        EndIf
        
        ; change keyboard focus-widget
        If eventtype = #PB_EventType_KeyDown 
          Select WidgetKeyboard( )\Key
            Case #PB_Shortcut_Tab
              Protected NewList *child._s_WIDGET( ) 
              
              If FocusedWidget( )\address
                If FocusedWidget( )\count\childrens
                  CopyList( FocusedWidget( )\child( ), *child( ) )
                  Debug 55
                Else
                  If FocusedWidget( )\parent
                    Debug 77
                    ChangeCurrentElement( *child( ), FocusedWidget( )\address )
                    If NextElement( *child( ) ) = 0
                      Debug *child( )
                      CopyList( *child( )\parent\child( ), *child( ) )
                      
                    EndIf
                  Else
                    CopyList( FocusedWidget( )\root\child( ), *child( ) )
                    Debug 99
                  EndIf
                EndIf
                ;               If FocusedWidget( )\parent
                ;                 CopyList( FocusedWidget( )\parent\child( ), *child( ) )
                ;                 ChangeCurrentElement( *child( ), FocusedWidget( )\address )
                ;                 NextElement( *child( ) )
                ;               Else
                ;                 CopyList( FocusedWidget( )\canvas\widget\child( ), *child( ) )
                ;               EndIf
                ;               If FocusedWidget( ) = *child( ) 
                ;               EndIf
                
                SetWidgetFocus( *child( ) )
              EndIf
              
              ;                 If FocusedWidget( )\after\widget And
              ;                    FocusedWidget( ) <> FocusedWidget( )\after\widget
              ;                   Repaint = SetActive( FocusedWidget( )\after\widget )
              ;                 ElseIf FocusedWidget( )\first\widget And
              ;                        FocusedWidget( ) <> FocusedWidget( )\first\widget
              ;                   Repaint = SetActive( FocusedWidget( )\first\widget )
              ;                 ElseIf FocusedWidget( ) <> FocusedWidget( )\root\first\widget
              ;                   Repaint = SetActive( FocusedWidget( )\root\first\widget )
              ;                 EndIf
          EndSelect
        EndIf
      EndIf
    EndIf
    
    ;
    If eventtype = #PB_EventType_MouseWheel
      If EnteredWidget( )
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          Protected app, ev
          app = CocoaMessage(0,0,"NSApplication sharedApplication")
          If app
            ev = CocoaMessage(0,app,"currentEvent")
            If ev 
              WidgetMouse( )\wheel\x = CocoaMessage(0,ev,"scrollingDeltaX")
              WidgetMouse( )\wheel\y = CocoaMessage(0,ev,"scrollingDeltaY")
            EndIf
          EndIf
        CompilerElse
          WidgetMouse( )\wheel\y = GetGadgetAttribute( EnteredWidget( )\canvas\gadget, #PB_Canvas_WheelDelta )
        CompilerEndIf
        
        If WidgetMouse( )\wheel\y
          DoWidgetEvents( EnteredWidget( ), #PB_EventType_MouseWheelY, EnteredItem( ) )
          WidgetMouse( )\wheel\y = 0
        ElseIf WidgetMouse( )\wheel\x
          DoWidgetEvents( EnteredWidget( ), #PB_EventType_MouseWheelX, EnteredItem( ) )
          WidgetMouse( )\wheel\x = 0
        EndIf
      EndIf
    EndIf  
    
  EndIf
EndProcedure



;-
Procedure Enumerate( *this._s_WIDGET )
  If *this\address
    Debug "widget - "+ *this\x +" "+ *this\y +" "+ *this\width +" "+ *this\height
    
    If *this\count\childrens
      ForEach *this\child( )
        If *this\child( )\visible 
          Enumerate( *this\child( ) )
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

;Debug GetAtPointWidget( widget( ), mx,my )

Procedure SetData( *this._s_WIDGET, *data )
  *this\data = *data
EndProcedure

Procedure SetText( *this._s_WIDGET, text.s )
  *this\text\string = text
EndProcedure



;-
Procedure Window( x,y,width,height, text.s, flag=0 )
  If OpenedWidget( ) <> RootWidget( )
    OpenList( OpenedWidget( )\parent )
  EndIf
  Protected result = AddObject( OpenedWidget( ), TypeFromClass( #PB_Compiler_Procedure ), x,y,width,height, 5 )
  widget()\type = #PB_GadgetType_Window
  
  If flag & #__Flag_NoGadgets = 0
    OpenList( result )
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure Container( x,y,width,height, flag=0 )
  Protected result = AddObject( OpenedWidget( ), TypeFromClass( #PB_Compiler_Procedure ), x,y,width,height )
  widget()\type = #PB_GadgetType_Container
  
  If flag & #__Flag_NoGadgets = 0
    OpenList( result )
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure Button( x,y,width,height, text.s, flag=0 )
  Protected result = AddObject( OpenedWidget( ), TypeFromClass( #PB_Compiler_Procedure ), x,y,width,height )
  widget()\type = #PB_GadgetType_Button
  
  ;widget( )\data = Val(text)
  ProcedureReturn result
EndProcedure

Procedure Tree( x,y,width,height, flag=0 )
  Protected result = AddObject( OpenedWidget( ), TypeFromClass( #PB_Compiler_Procedure ), x,y,width,height )
  widget()\type = #PB_GadgetType_Tree
  
  ;widget( )\data = Val(text)
  ProcedureReturn result
EndProcedure

Procedure Splitter( x,y,width,height, first,second, flag=0)
  ProcedureReturn  Container( x,y,width,height, flag )
EndProcedure


;-


Global enumerate_count

Procedure StartWindow( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure NextWindow( *this.Integer ) 
  Protected *element
  ; Widget() = GetChildrens(Root())
  
  If Not enumerate_count
    *element = FirstElement(Widget())
  Else
    *element = NextElement(Widget())
  EndIf
  
  enumerate_count + 1
  
  If Widget()\type <> #PB_GadgetType_Window
    While *element
      *element = NextElement(Widget())
      
      If Widget()\type = #PB_GadgetType_Window
        Break
      EndIf 
    Wend
  EndIf
  
  If Widget()\type <> #PB_GadgetType_Window
    ProcedureReturn 0
  EndIf
  
  *this\i = Widget()\index ; ListIndex(Widget())
  ProcedureReturn *element
  
EndProcedure

Procedure AbortWindow( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure StartGadget( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure NextGadget( *this.Integer, parent =- 1) 
  Protected *element
  
  If Not enumerate_count
    *element = FirstElement(Widget())
  Else
    *element = NextElement(Widget())
  EndIf
  
  enumerate_count + 1
  
  If Widget()\type = #PB_GadgetType_Window
    While *element
      *element = NextElement(Widget())
      
      If Widget()\type <> #PB_GadgetType_Window And
         Not (Widget()\parent\index <> parent And parent <> #PB_Any)
        Break
      EndIf 
    Wend
  EndIf
  
  If Widget()\type = #PB_GadgetType_Window Or
     (Widget()\parent\index <> parent And parent <> #PB_Any)
    enumerate_count = 0
    ProcedureReturn 0
  EndIf
  
  *this\i = Widget()\index ; ListIndex(Widget())
                           ;Debug Widget()\text\string
  ProcedureReturn *element
  
EndProcedure

Procedure AbortGadget( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Enumeration 
  #window_0
  #window
EndEnumeration


; Shows using of several panels...
Procedure BindEvents( )
  Protected *this._s_WIDGET = EventWidget( )
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

OpenWindow(#window_0, 0, 0, 300, 300, "PanelGadget", #PB_Window_SystemMenu )


Define *w, editable
Define *root._s_WIDGET = OpenCanvas(#window_0,-1, 10,10,300-20,300-20)
;BindWidgetEvent( *root1, @BindEvents( ) )

Container( 80,80, 150,150 )
Container( 40,-30, 50,50, #__Flag_NoGadgets )
Container( 50,130, 50,50, #__Flag_NoGadgets )
Container( -30,40, 50,50, #__Flag_NoGadgets )
Container( 130,50, 50,50, #__Flag_NoGadgets )
CloseList( )
CloseList( )

OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)


Define *w, editable
Define *root1._s_WIDGET = OpenCanvas(#window,-1, 10,10,300-20,300-20)
;BindWidgetEvent( *root1, @BindEvents( ) )


Define *root2._s_WIDGET = OpenCanvas(#window,-1, 10,300,300-20,300-20)
;BindWidgetEvent( *root2, @BindEvents( ) )


Define *root3._s_WIDGET = OpenCanvas(#window,-1, 300,10,300-20,600-20)
;BindWidgetEvent( *root3, @BindEvents( ) )

Define *root4._s_WIDGET = OpenCanvas(#window,-1, 590, 10, 200, 600-20)
BindWidgetEvent( *root4, @BindEvents( ) )



Define count = 2;0000
#st = 1
Global  mx=#st,my=#st

Define time = ElapsedMilliseconds( )

OpenList( *root1 )
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

CloseList( )
CloseList( )
SetData(Container(10, 45, 70, 180, editable), 11) 
SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
SetData(Container(10, 45, 70, 180, editable), 11) 
SetData(Container(10, 5, 70, 180, editable), 11) 
SetData(Container(10, 5, 70, 180, editable), 11) 
SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
CloseList( )
CloseList( )
CloseList( )
CloseList( )

;
OpenList( *root2 )
Container( 80,80, 150,150 )
Container( 40,-30, 50,50, #__Flag_NoGadgets )
Container( 50,130, 50,50, #__Flag_NoGadgets )
Container( -30,40, 50,50, #__Flag_NoGadgets )
Container( 130,50, 50,50, #__Flag_NoGadgets )
CloseList( )
CloseList( )

Define i
OpenList( *root3 )
*w = Tree( 20,20, 100,260-20+300)
For i=1 To 10;00000
  AddItem(*w, i, "text-"+Str(i))
Next

*w = Tree( 100,30, 100,260-20+300)
For i=1 To 10;00000
  AddItem(*w, i, "text-"+Str(i))
Next

Debug "time - "+Str(ElapsedMilliseconds( ) - time)


;
Define *window._s_WIDGET
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

Define Window, Gadget
Debug "Begen enumerate window"
If StartWindow( )
  While NextWindow( @Window )
    Debug "Window "+Window
  Wend
  AbortWindow()
EndIf
;   
;   Debug "Begen enumerate all gadget"
;   If StartGadget( )
;     While NextGadget( @Gadget )
;       Debug "Gadget "+Gadget
;     Wend
;     AbortGadget()
;   EndIf
;   
;   Window = 8
;   
;   Debug "Begen enumerate gadget window = "+ Str(Window)
;   If StartGadget( )
;     While NextGadget( @Gadget, Window )
;       Debug "Gadget "+Str(Gadget) +" Window "+ Window
;     Wend
;     AbortGadget()
;   EndIf
;   
;   
;   Debug "Begen enumerate alls"
;   ForEach Widget()
;     If _is_window_( widget() )
;       Debug "window "+ Widget()\index
;     Else
;       Debug "  gadget - "+ Widget()\index
;     EndIf
;   Next
;   
;  Debug "Begen enumerate window"
;   If StartEnumerate( RootWidget( ) )
;     ;If _is_window_( widget( ) )
;     Debug "window " + widget( )
; ; ;     *window = widget()
;     ;EndIf
;     StopEnumerate( )
;   EndIf
;   
; ;   Debug "Begen enumerate all gadget"
; ;   If StartEnumerate( RootWidget( ) )
; ;     ;If Not _is_window_( widget( ) )
; ;       Debug "gadget - "+widget( )
; ;     ;EndIf
; ;     StopEnumerate( )
; ;   EndIf
;   
; ;   Define Window = 8
; ;   ;*window = GetWidget( Window )
; ;   
; ;   Debug "Begen enumerate gadget window = "+ Window
; ;   Debug "window "+ Window
; ;   If StartEnumerate( *window )
; ;     Debug "  gadget - "+ widget( )
; ;     StopEnumerate( )
; ;   EndIf
; ;   
; ;   
; ;   Debug "Begen enumerate alls"
; ;   If StartEnumerate( RootWidget( ) )
; ;     If _is_window_( widget() )
; ;       Debug "window "+ Widget()\index
; ;     Else
; ;       Debug "  gadget - "+ Widget()\index
; ;     EndIf
; ;     StopEnumerate( )
; ;   EndIf

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule events
    
      Macro PB(Function)
        Function
      EndMacro
      
    EndDeclareModule 
  
  Module events
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ; bug when clicking on the canvas in an inactive window
      #LeftMouseDownMask      = 1 << 1
      #LeftMouseUpMask        = 1 << 2
      #RightMouseDownMask     = 1 << 3
      #RightMouseUpMask       = 1 << 4
      #MouseMovedMask         = 1 << 5
      #LeftMouseDraggedMask   = 1 << 6
      #RightMouseDraggedMask  = 1 << 7
      #KeyDownMask            = 1 << 10
      #KeyUpMask              = 1 << 11
      #FlagsChangedMask       = 1 << 12
      #ScrollWheelMask        = 1 << 22
      #OtherMouseDownMask     = 1 << 25
      #OtherMouseUpMask       = 1 << 26
      #OtherMouseDraggedMask  = 1 << 27
      
      Global psn.q, mask, eventTap, key.s
      
      ImportC ""
        CFRunLoopGetCurrent()
        CFRunLoopAddCommonMode(rl, mode)
        
        GetCurrentProcess(*psn)
        CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
      EndImport
      
      
      mask = #LeftMouseDownMask | #LeftMouseUpMask
      mask | #RightMouseDownMask | #RightMouseUpMask
      mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
      ; mask | #KeyDownMask
      mask = #LeftMouseDraggedMask
      ;
      ; get real event gadget
      ;
      Global event_window =- 1
      Global event_gadget =- 1
      Procedure events_gadgets( )
        If GetActiveWindow( ) <> EventWindow( )
          event_window = EventWindow( )
        EndIf
        event_gadget = EventGadget( )
;         
;         Debug ""+EventType() +" "+ GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons )
      EndProcedure 
      BindEvent( #PB_Event_Gadget, @events_gadgets( ) )
      
      ;
      ; callback function
      ;
      ProcedureC eventTapFunction(proxy, type, event, refcon)
        Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        
        If NSEvent
         Protected Window = CocoaMessage(0, NSEvent, "window")
          
          ;If Window
            CocoaMessage(@Point, NSEvent, "locationInWindow")
            Protected View = CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "hitTest:@", @Point)
          ;EndIf
          
;             win_id = WindowID(EventWindow())
;           CocoaMessage(@pt, win_id, "mouseLocationOutsideOfEventStream")
;           win_cv = CocoaMessage(0, win_id, "contentView")
;           handle = CocoaMessage(0, win_cv, "hitTest:@", @pt)
        
        EndIf
        Debug View
;         If IsWindow( event_window )
           Debug "  "+#PB_Compiler_Procedure  +" "+ GetActiveWindow() +" "+ EventWindow() +" "+ EventGadget() +" "+ event_gadget +" "+ type ;+" "+ root()
;           
;           If type = 1 ; LeftButtonDown
;             PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
;             
;           ElseIf type = 2 ; LeftButtonUp
;             PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp )
;             event_window =- 1
;           EndIf
;         EndIf
        Debug type
      EndProcedure
      
      GetCurrentProcess(@psn.q)
;       eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
;       If eventTap
;         CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
;       EndIf
      eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
  If eventTap
    ;CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"NSEventTrackingRunLoopMode")
     CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
  EndIf
  
     CompilerEndIf
    
  EndModule 
  
CompilerEndIf

UseModule events
Define event, handle, enter, result
Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    If EventType( ) = #PB_EventType_MouseMove
      enter = EnterGadgetID( )
      
      If handle <> enter
        handle = enter
        
        ChangeCurrentRootWidget( handle )
      EndIf
      ;       ElseIf EventType( ) = #PB_EventType_MouseEnter ; bug do't send mouse enter event then press mouse buttons
      ;         RootWidget( ) = GetRootWidget( GadgetID( EventGadget( ) ) )
    EndIf
    
    WidgetsEvents( EventType( ) )
  EndIf
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------------------------------------------
; EnableXP