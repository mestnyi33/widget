EnableExplicit

Macro Atbox( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
  Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 And 
        _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
EndMacro

Macro Interrect( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
                 _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
  
  Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And 
       ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ) );And ((( _address_2_x_ + _address_2_width_ ) - ( _address_1_x_ + _address_1_width_ ) ) Or (( _address_2_y_ + _address_2_height_ ) - ( _address_1_y_ + _address_1_height_ ) )) )
EndMacro


;- STRUCTURE
;{           }
;--     POINT
Structure s_POINT
  x.l
  y.l
EndStructure
;--     COORDINATE
Structure s_COORDINATE Extends s_POINT
  width.l
  height.l
EndStructure
;--     STATE
Structure s_STATE
  press.b
  enter.b
  drag.b
  focus.b
  ;active.b
  repaint.b
EndStructure
;--     COUNT
Structure s_COUNT
  ;   index.l
  ;   type.l
  ;   events.l
  
  *items ; CountItems( ) 
  *parents
  *childrens
EndStructure
;--     DROP
Structure s_DROP Extends s_COORDINATE
  format.i
  actions.i
  privatetype.i
EndStructure
;--     DRAG
Structure s_DRAG Extends s_DROP
  value.i
  string.s
EndStructure
;--     OBJECT_TYPE
Structure s_OBJECT_TYPE
  *row.s_ROW
  *widget.s_WIDGET
EndStructure
;--     KEYBOARD
Structure s_KEYBOARD ; Ok
  focused.s_OBJECT_TYPE ; keyboard focus element
  change.b
  input.c
  key.i[2]
EndStructure
;--     MOUSE
Structure s_MOUSE Extends s_POINT
  ;   interact.b ; determines the behavior of the mouse in a clamped (pushed) state
  ;   *button._s_buttons[3]   ; at point element button
  
  entered.s_OBJECT_TYPE      ; mouse entered element
  pressed.s_OBJECT_TYPE      ; mouse button's pushed element
  leaved.s_OBJECT_TYPE       ; mouse leaved element
  
  *drag.s_DRAG
  wheel.s_POINT
  delta.s_POINT
  buttons.l               ; 
                          ;   change.b                ; if moved mouse this value #true
EndStructure
;--     COLOR
Structure s_COLOR
  state.b ; entered; selected; disabled;
          ;   front.i[4]
          ;   line.i[4]
          ;   fore.i[4]
  back.i[4]
  frame.i[4]
  ;   _alpha.a[2]
  ;   *alpha._s_color
EndStructure
;--     EDIT
Structure s_EDIT Extends s_COORDINATE
  pos.l
  len.l
  
  string.s
  change.b
  
  *color._s_color
EndStructure
;--     TEXT
Structure s_TEXT Extends s_EDIT
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
  ;   ; short._s_edit ; ".."
  ;   edit._s_edit[4]
  ;   caret._s_caret
  ;   syntax._s_syntax
  ;   
  ;   ; short._s_text ; сокращенный текст
  ;   
  ;   rotate.f
  ;   align._s_align
  ;   padding._s_point
EndStructure
;--     EVENT
Structure s_PARENT
  *window.s_WIDGET
  *widget.s_WIDGET
  *item.s_ROW
EndStructure
;--     EVENT
Structure s_EVENT
  *widget.s_WIDGET
  *type ; EventType( )
  *item ; Eventitems( )
  *data ; EventData( )
EndStructure
;--     OBJECT
Structure s_OBJECT Extends s_COORDINATE
  index.i
  type.i
  *Data
  *address
  
  visible.b
  
  *parent.s_WIDGET
  draw.s_COORDINATE
  color.s_COLOR
  count.s_COUNT
  state.s_STATE
  text.s_TEXT
  
  List *items.s_OBJECT( )
EndStructure
;--     ROW
Structure s_ROW Extends s_OBJECT
  *selected.s_ROW
EndStructure
;--     WIDGET
Structure s_WIDGET Extends s_OBJECT
  *window.s_WIDGET
  
  fs.l
  *canvas.s_CANVAS
  *drop.s_DROP
  *event.s_EVENT
  
  ;
  *row.s_ROW
  
  
  List *child.s_WIDGET( )
EndStructure
;--     ROOT
Structure s_ROOT
  window.i
  gadget.i
  *widget.s_WIDGET
EndStructure
;--     CANVAS
Structure s_CANVAS Extends s_ROOT
  repaint.b
  
  ;*last.s_WIDGET
  *parent.s_WIDGET 
  
  *event.s_EVENT
EndStructure
;--     STRUCTURE
Structure s_STRUCT
  Map *canvas.s_ROOT( )
  List *child.s_WIDGET( )
  
  mouse.s_MOUSE
  keyboard.s_KEYBOARD
  event.s_EVENT
EndStructure


;}

;- MACRO
;{       }
Macro allocate( _struct_name_, _struct_type_= )
  s_#_struct_name_#_struct_type_ = AllocateStructure( s_#_struct_name_ )
EndMacro

;-
Macro RootWidget( )
  *widget\canvas( )\widget ;*widget\root
EndMacro                   ; Returns first created widget 

Macro WidgetCanvas( ) 
  RootWidget( )\canvas
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
  *widget\child( ) ;RootWidget( )\canvas\last
EndMacro           ; Returns last created widget address

Macro OpenedWidget( )
  WidgetCanvas( )\parent
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

Macro PostRepaint( _address_, _event_data_ = #Null )
  
  ;   If _address_\canvas\state\repaint = #False 
  ;     _address_\canvas\state\repaint = #True
  If _address_\state\repaint = #False
    _address_\state\repaint = #True
    PostEvent( #PB_Event_Gadget, _address_\canvas\window, _address_\canvas\gadget, #PB_EventType_Repaint, _address_ );_event_data_ )
  EndIf
  ;   EndIf
EndMacro

Macro GetCanvasData( _address_ )
  *widget\canvas( Str( _address_ ) )\widget
EndMacro

Macro SetCanvasData( _gadget_, _data_ )
  If Not FindMapElement( *widget\canvas( ), Str( GadgetID( _gadget_ ) ) )
    AddMapElement( *widget\canvas( ), Str( GadgetID( _gadget_ ) ) )
    *widget\canvas.allocate( ROOT, ( ) )
    *widget\canvas( )\widget = _data_
    *widget\canvas( )\gadget = _gadget_
    *widget\canvas( )\window = *widget\canvas( )\widget\canvas\window
  EndIf
EndMacro


Macro StartEnumerate( _parent_ )
  Bool( _parent_\count\childrens )
  
  PushListPosition( Widget( ))
  If _parent_\address
    ChangeCurrentElement( Widget( ), _parent_\address )
  Else
    ResetList( Widget( ))
  EndIf
  
  While NextElement( Widget( ))
    If ChildWidget( Widget( ), _parent_ )
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
  PopListPosition( Widget( ))
EndMacro



;}

;-

;- GLOBAL
;{        }
Global *widget.allocate( STRUCT )
Global NewList *draw.s_WIDGET( )
;}

;- CONSTANT
;{          }
; Enumeration
;   #__s_normal     = 0<<0  ; 0
;   ;#__s_select     = 1<<0  ; 1
;   #__s_expand     = 1<<1  ; 2
;   #__s_check      = 1<<2  ; 4
;   #__s_collapse   = 1<<3  ; 8
;   #__s_inbetween  = 1<<4  ; 16
;   
;   ;#__s_enter      = 1<<5  ; 32  ; mouse enter
;   ;#__s_focus      = 1<<6  ; 128 ; keyboard focus
;   ;#__s_disable    = 1<<7  ; 64  ; 
;   ;#__s_repaint    = 1<<8  ; 256
;   ;#__s_scroll     = 1<<9  ; 512
;   
;   ;#__s_drag       = 1<<10  ; 1024
;   ;#__s_drop       = 1<<11  ; 2048 ; drop enter state
;   
;   ;#__s_current    = 1<<12 ; 
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
Declare DoWidgetEvents( *this.s_WIDGET, eventtype, *item.s_ROW = #Null )
;}


;-
Macro is_root( _address_ )
  Bool( _address_ = _address_\canvas\widget )
EndMacro

Procedure   ChildWidget( *this.s_WIDGET, *parent.s_WIDGET )
  Protected result 
  
  Repeat
    If *parent = *this\parent
      result = *this
      Break
    EndIf
    
    *this = *this\parent
  Until *this = *this\canvas\widget ; is_root( *this )
  
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

Procedure EnterGadgetID( ) 
  Protected EnterGadgetID, GadgetID
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      
      Protected WindowID
      Protected Cursorpos.q
      
      GetCursorPos_( @Cursorpos )
      WindowID = WindowFromPoint_( Cursorpos )
      ScreenToClient_(WindowID, @Cursorpos) 
      GadgetID = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      GetCursorPos_( @Cursorpos )
      WindowID = GetAncestor_( WindowID, #GA_ROOT )
      ScreenToClient_(WindowID, @Cursorpos) 
      WindowID = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      If IsGadget( GetDlgCtrlID_( GadgetID )) 
        If GadgetID = GadgetID( GetDlgCtrlID_( GadgetID ))
          WindowID = GadgetID
        Else
          ; SpinGadget
          If GetWindow_( GadgetID, #GW_HWNDPREV ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            EndIf
            WindowID = GetWindow_( GadgetID, #GW_HWNDPREV)
            
          ElseIf GetWindow_( GadgetID, #GW_HWNDNEXT ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
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
      
  CompilerEndSelect
EndProcedure    

Procedure ResizeWidget( *this.s_WIDGET, x,y,width,height )
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

Procedure DrawFrame( *this.s_WIDGET, x, y, FrameColor, mode = 0 )
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

Procedure DrawFirst( *this.s_WIDGET, x, y  )
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

Procedure DrawLast( *this.s_WIDGET, x, y  )
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

Procedure DrawWidget( *this.s_WIDGET, x, y )
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

Procedure ReDrawWidget( *this.s_WIDGET )
  Protected x,y
  
  If *this\address
    If *this\parent
      x = *this\parent\x
      y = *this\parent\y
    EndIf
    If StartDrawing( CanvasOutput( *this\canvas\gadget ) )
      FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
      DrawWidget( *this, x,y )
      StopDrawing( )
    EndIf
  EndIf
EndProcedure

Procedure FreeWidget( *this.s_WIDGET )
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
    If *this = GetGadgetData( *this\canvas\gadget ) 
      SetGadgetData( *this\canvas\gadget, #Null )
    EndIf
  EndIf
  
  FreeStructure( @*this )
EndProcedure

Procedure SetParentWidget( *this.s_WIDGET, *parent.s_WIDGET )
  If *parent
    *parent\count\childrens + 1
    
    If *this\parent And *this\parent
      *this\parent\count\childrens - 1
    EndIf
    
    *this\canvas = *parent\canvas
    *this\parent = *parent
    *this\window = *parent\window
    *this\count\parents = *parent\count\parents + 1
  EndIf
EndProcedure

Procedure AddItem( *this.s_WIDGET, position, text.s )
  Protected result, *item.s_OBJECT
  
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

Procedure AddObject( *this.s_WIDGET, x,y,width,height, FrameSize = 1 )
  Protected result
  
  If *this
    LastElement( *this\child( ) )
    result = AddElement( *this\child( ) )
    If result
      *this\child( ) = AllocateStructure( s_WIDGET )
      CopyList( *this\child( ), widget( ) )
      
      *this\child( )\fs = FrameSize
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

Procedure OpenList( *this.s_WIDGET )
  OpenedWidget( ) = *this
EndProcedure

Procedure CloseList( )
  If OpenedWidget( ) And OpenedWidget( )\parent And OpenedWidget( )\parent 
    OpenedWidget( ) = OpenedWidget( )\parent
  Else
    OpenedWidget( ) = RootWidget( )
  EndIf
EndProcedure

Procedure OpenWidget( window, gadget, x,y,width,height, flag = 0 )
  Protected g, w
  Protected *this.s_WIDGET = AllocateStructure( s_WIDGET )
  
  If *this
    *this\canvas = AllocateStructure( s_CANVAS )
    *this\address = *this 
    *this\fs = 1
    
    If *this\address
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
      
      *this\canvas\widget = *this
      *this\canvas\window = window
      *this\canvas\gadget = gadget
      
      ResizeWidget( *this, x,y,width,height )
      ;SetGadgetData( gadget, *this )
      SetCanvasData( gadget, *this )
      
      RootWidget( ) = *this
      OpenList( *this )
      
      DoWidgetEvents( *this, #PB_EventType_Create )
      PostRepaint( *this, #PB_EventType_Repaint ) ;
    EndIf
    
    ProcedureReturn *this
  EndIf
EndProcedure

Procedure GetAtPointWidget( List *child.s_WIDGET( ), mouse_x, mouse_y )
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

Procedure GetAtPointItem( List *object.s_OBJECT( ), mouse_x, mouse_y )
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
Procedure SetWidgetFocus( *this.s_WIDGET )
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
Procedure.i PostEventWidget( eventtype.l, *this.s_WIDGET, *button = #PB_All, *data = #Null )
  
EndProcedure

Procedure.i PostWidgetEvent( *this.s_WIDGET, eventtype.l, *button = #PB_All, *data = #Null )
  ; WidgetEvent( ) = *this\canvas\event
  WidgetEvent( )\widget = *this
  WidgetEvent( )\type = eventtype
  WidgetEvent( )\item = *button
  WidgetEvent( )\data = *data
  
  CallCFunctionFast( *this\canvas\event\data )
EndProcedure

Procedure.i BindWidgetEvent( *this.s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  If *this = *this\canvas\widget
    If *callback
      If Not RootWidget( )\canvas\event
        RootWidget( )\canvas\event.allocate( EVENT )
      EndIf
      RootWidget( )\canvas\event\data = *callback
      RootWidget( )\canvas\event\type = eventtype
      RootWidget( )\canvas\event\item = item
    EndIf
  Else
    ;
    
  EndIf
EndProcedure

Procedure DoWidgetEvents( *this.s_WIDGET, eventtype, *item.s_ROW = #Null )
  EventItem( ) = *item
  EventWidget( ) = *this
  
  ;Debug ""+ *this +" "+ eventtype
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
  
  
  Select eventtype
      ;       Case #PB_EventType_Draw          : Debug "draw"         
    Case #PB_EventType_MouseWheelX     : Debug  ""+ *this +" - wheel-x"
    Case #PB_EventType_MouseWheelY     : Debug  ""+ *this +" - wheel-y"
    Case #PB_EventType_Input           : Debug  ""+ *this +" - input"
    Case #PB_EventType_KeyDown         : Debug  ""+ *this +" - key-down"
    Case #PB_EventType_KeyUp           : Debug  ""+ *this +" - key-up"
    Case #PB_EventType_Focus           : Debug  ""+ *this +" - focus"
    Case #PB_EventType_LostFocus       : Debug  ""+ *this +" - lfocus"
    Case #PB_EventType_MouseEnter      : Debug  ""+ *this +" - enter"
    Case #PB_EventType_MouseLeave      : Debug  ""+ *this +" - leave"
    Case #PB_EventType_LeftButtonDown  : Debug  ""+ *this +" - down"
    Case #PB_EventType_DragStart       : Debug  ""+ *this +" - drag"
    Case #PB_EventType_Drop            : Debug  ""+ *this +" - drop"
    Case #PB_EventType_LeftButtonUp    : Debug  ""+ *this +" - up"
    Case #PB_EventType_LeftClick       : Debug  ""+ *this +" - click"
    Case #PB_EventType_LeftDoubleClick : Debug  ""+ *this +" - 2_click"
  EndSelect
  
  ;
  If *this\canvas\event
    PostWidgetEvent( *this, eventtype, *item )
  EndIf
  
  ;
  If *this\state\repaint
    *this\state\repaint = 0
    ReDrawWidget( *this\canvas\widget )
  EndIf
EndProcedure

Procedure WidgetEvents( Canvas, eventtype )
  If eventtype = #PB_EventType_Repaint
    ; DoWidgetEvents( EventWidget( ), EventData( ) )
    DoWidgetEvents( EventData( ), eventtype )
  EndIf
  
  ;     
  If eventtype = #PB_EventType_MouseEnter Or
     eventtype = #PB_EventType_MouseLeave
    ;RootWidget( ) = GetGadgetData( Canvas )
    RootWidget( ) = GetCanvasData( GadgetID( Canvas ) ) 
  EndIf
  If eventtype = #PB_EventType_MouseEnter Or 
     eventtype = #PB_EventType_MouseMove
    WidgetMouse( )\x = WindowMouseX( EventWindow( ) ) - GadgetX( Canvas, #PB_Gadget_WindowCoordinate ) ; GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
    WidgetMouse( )\y = WindowMouseY( EventWindow( ) ) - GadgetY( Canvas, #PB_Gadget_WindowCoordinate ) ; GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
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
    If RootWidget( )
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
              DoWidgetEvents( LeavedWidget( ), #PB_EventType_StatusChange, LeavedItem( ) )
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
        WidgetKeyboard( )\input = GetGadgetAttribute( FocusedWidget( )\canvas\gadget, #PB_Canvas_Input )
        DoWidgetEvents( FocusedWidget( ), #PB_EventType_Input, FocusedItem( ) )
      Else
        WidgetKeyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\canvas\gadget, #PB_Canvas_Key )
        WidgetKeyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\canvas\gadget, #PB_Canvas_Modifiers )
        DoWidgetEvents( FocusedWidget( ), eventtype, FocusedItem( ) )
      EndIf
      
      ; change keyboard focus-widget
      If eventtype = #PB_EventType_KeyDown 
        Select WidgetKeyboard( )\Key
          Case #PB_Shortcut_Tab
           Protected NewList *child.s_WIDGET( ) 
           
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
                 CopyList( FocusedWidget( )\canvas\widget\child( ), *child( ) )
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
  
  
EndProcedure



;-
Procedure Enumerate( *this.s_WIDGET )
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

Procedure SetData( *this.s_WIDGET, *data )
  *this\data = *data
EndProcedure

Procedure SetText( *this.s_WIDGET, text.s )
  *this\text\string = text
EndProcedure



;-
Procedure Window( x,y,width,height, text.s, flag=0 )
  If OpenedWidget( ) <> RootWidget( )
    OpenList( OpenedWidget( )\parent )
  EndIf
  Protected result = AddObject( OpenedWidget( ), x,y,width,height, 5 )
  widget()\type = #PB_GadgetType_Window
  
  If flag & #__Flag_NoGadgets = 0
   OpenList( result )
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure Container( x,y,width,height, flag=0 )
  Protected result = AddObject( OpenedWidget( ), x,y,width,height )
  widget()\type = #PB_GadgetType_Container
  
  If flag & #__Flag_NoGadgets = 0
   OpenList( result )
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure Button( x,y,width,height, text.s, flag=0 )
  Protected result = AddObject( OpenedWidget( ), x,y,width,height )
  widget()\type = #PB_GadgetType_Button
  
  ;widget( )\data = Val(text)
  ProcedureReturn result
EndProcedure

Procedure Splitter( x,y,width,height, first,second, flag=0)
  ProcedureReturn  Container( x,y,width,height, flag )
EndProcedure



;-
Procedure BindEvents( )
  Protected *this.s_WIDGET = EventWidget( )
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

OpenWindow(0,100,100,600,600,"")

Define *root1.s_WIDGET = OpenWidget(0,-1, 10,10,300-20,300-20)
;BindWidgetEvent( *root1, @BindEvents( ) )


;Define *root4.s_WIDGET = OpenWidget(0,-1, 300,300,300,300)

Define *root2.s_WIDGET = OpenWidget(0,-1, 10,300,300-20,300-20)
;BindWidgetEvent( *root2, @BindEvents( ) )


Define *root3.s_WIDGET = OpenWidget(0,-1, 300,10,300-20,600-20)
;BindWidgetEvent( *root3, @BindEvents( ) )



Define count = 2;0000
#st = 1
Global  mx=#st,my=#st

Define time = ElapsedMilliseconds( )

OpenList( *root1 )

Define editable
SetData(Container(20, 20, 180, 180, editable), 1)
;Debug OpenedWidget( )\parent\child( )

Debug "1 - "+*root1\address +" "+ Str(widget( )) +" "+ Str(*root1\child( ))
widget( )\data = 333
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


AddObject(*root2, 80,80, 150,150)
Debug "2 - "+*root2\address +" "+ Str(widget( )) +" "+ Str(*root2\child( ))
AddObject(*root2\child( ), 40,-30, 50,50)
AddObject(*root2\child( ), 50,130, 50,50)
AddObject(*root2\child( ), -30,40, 50,50)
AddObject(*root2\child( ), 130,50, 50,50)



AddObject(*root3, 20,20, 100,260-20+300)
Debug "3 - "+*root3\address +" "+ Str(widget( )) +" "+ Str(*root3\child( ))
Define i
For i=1 To 10;00000
  AddItem(*root3\child( ), i, "text-"+Str(i))
Next

AddObject(*root3, 100,30, 100,260-20+300)
Debug "3 - "+*root3\address +" "+ Str(widget( )) +" "+ Str(*root3\child( ))
Define i
For i=1 To 10;00000
  AddItem(*root3\child( ), i, "text-"+Str(i))
Next

Debug "time - "+Str(ElapsedMilliseconds( ) - time)

ForEach widget( )
  Debug widget( )
Next

; Define *first.s_WIDGET = FirstElement(*root1\child( ))
; ;ResizeWidget(*first, 100,10,10,150)
; ;FreeWidget( *first )
; ;FreeWidget( *root1 )
; 
; *first.s_WIDGET = FirstElement(*root2\child( ))
; ;ResizeWidget(*first, 100,10,10,150)
; 
; 
; ; ;Enumerate( *root1 )
; ; ReDrawWidget( *root1 )
; ; ;
; ; ReDrawWidget( *root2 )

Define event, EnterGadgetID, Canvas
Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    
    ;     If eventtype = #PB_EventType_MouseMove
    ;       EventType = EventType( )
    ;       Canvas = EventGadget( )
    ;       EnterGadgetID = EnterGadgetID( )
    ;       If GadgetID( Canvas ) <> EnterGadgetID
    ;         If FindMapElement( *widget\canvas( ), Str( EnterGadgetID ) )
    ;           If RootWidget( ) <> *widget\canvas( )\widget
    ;             ; PostEvent( #PB_Event_Gadget, EventWindow( ), *widget\canvas( )\gadget, #PB_EventType_MouseEnter )
    ;             RootWidget( ) = *widget\canvas( )\widget ; GetCanvasData( GadgetID( Canvas ) ) 
    ;           EndIf
    ;           ; PostEvent( #PB_Event_Gadget, EventWindow( ), *widget\canvas( )\gadget, #PB_EventType_MouseMove )
    ;           Canvas = *widget\canvas( )\gadget
    ;         EndIf
    ;       Else
    ;         RootWidget( ) = GetCanvasData( GadgetID( Canvas ) ) 
    ;       EndIf
    ;     EndIf
    
    
    
    WidgetEvents( EventGadget( ), EventType( ) )
    
  EndIf
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------------------------w5b--+--8----
; EnableXP