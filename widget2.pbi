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
  x.i
  y.i
EndStructure
;--     COORDINATE
Structure s_COORDINATE Extends s_POINT
  width.i
  height.i
EndStructure
;--     OBJECT
Structure s_OBJECT
  *window.s_WIDGET
  *widget.s_WIDGET
EndStructure
;--     KEYBOARD
Structure s_KEYBOARD ; Ok
                     ; *widget.s_WIDGET   ; keyboard focus element
                     ; *window.s_WIDGET   ; active window element ; GetActive( )\
  focus.s_OBJECT
  change.b
  input.c
  key.i[2]
EndStructure
;--     MOUSE
Structure s_MOUSE Extends s_POINT
  ;   interact.b ; determines the behavior of the mouse in a clamped (pushed) state
  ;              ;*behavior
  ;   *bar_row._s_tabs[3]     ; at point element item
  ;   *row._s_rows[2]         ; at point element item
  ;   *button._s_buttons[3]   ; at point element button
  
  *entered.s_WIDGET      ; mouse entered element
  *pressed.s_WIDGET      ; mouse button's pushed element
  *leaved.s_WIDGET       ; mouse leaved element
  
  ;   wheel._s_POINT
  ;   delta._s_POINT
  ;   
  ;   *_drag._S_DD
  ;   *_transform._s_transform
  ;   
  ;   *grid
  buttons.l               ; 
                          ;   change.b                ; if moved mouse this value #true
EndStructure
;--     COUNT
Structure s_COUNT
  ;   index.l
  ;   type.l
  items.l
  ;   events.l
  *parents
  *childrens
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
;--     EVENTDATA
Structure s_EVENT
  *widget.s_WIDGET
  *type ; EventType( )
  *item ; EventItem( )
  *data ; EventData( )
EndStructure
;--     ITEM
Structure s_ITEM Extends s_COORDINATE
  *address
  *parent.s_WIDGET
  String.s
  
  visible.b
  draw.s_coordinate
  color.s_COLOR
  count.s_count
  
  *data
  *state
  
  List item.s_ITEM()
EndStructure
;--     WIDGET
Structure s_WIDGET Extends s_COORDINATE
  *address
  ;*root.s_WIDGET
  *parent.s_WIDGET
  *canvas.s_CANVAS
  
  *data
  *state
  
  fs.l
  
  visible.b
  count.s_count
  color.s_COLOR
  draw.s_coordinate
  
  ;
  *item_entered.s_ITEM
  *item_leaved.s_ITEM
  
  List item.s_ITEM()
  List *child.s_WIDGET()
EndStructure
;--     CANVAS
Structure s_CANVAS
  repaint.b
  
  window.i
  gadget.i
  *parent.s_WIDGET 
  *widget.s_WIDGET
  
  List *child.s_WIDGET()
EndStructure
;--     STRUCTURE
Structure s_STRUCT
  *canvas.s_CANVAS
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
Macro WidgetMouse( )
  *widget\mouse
EndMacro

Macro WidgetKeyboard( ) 
  *widget\keyboard
EndMacro

Macro WidgetCanvas( ) 
  *widget\canvas
EndMacro

Macro WidgetEvent( )
  *widget\event
EndMacro

;-
Macro EnteredItem( _this_ )
  _this_\item_entered
EndMacro

Macro LeavedItem( _this_ )
  _this_\item_leaved
EndMacro

;-
Macro Root( )
  WidgetCanvas( )\widget
EndMacro ; Returns first created widget 

Macro Widget( ) 
  WidgetCanvas( )\parent\child( ) 
EndMacro ; Returns last created widget address

Macro OpenedWidget( )
  WidgetCanvas( )\parent
EndMacro ; Returns last parent opened-widget-list

Macro EnteredWidget( )
  WidgetMouse( )\entered
EndMacro ; Returns mouse entered widget 

Macro LeavedWidget( )
  WidgetMouse( )\leaved
EndMacro ; Returns mouse leaved widget 

Macro PressedWidget( )
  WidgetMouse( )\pressed
EndMacro ; Returns mouse button's pressed widget

Macro FocusedWidget( ) 
  WidgetKeyboard( )\focus\widget
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
  
  ;   If _address_\canvas\repaint = #False 
  ;     _address_\canvas\repaint = #True
  If _address_\state & #__s_repaint = 0
    _address_\state | #__s_repaint
    PostEvent( #PB_Event_Gadget, _address_\canvas\window, _address_\canvas\gadget, #PB_EventType_Repaint, _address_ );_event_data_ )
  EndIf
  ;   EndIf
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
Enumeration
  #__s_normal     = 0<<0  ; 0
  #__s_select     = 1<<0  ; 1
  #__s_expand     = 1<<1  ; 2
  #__s_check      = 1<<2  ; 4
  #__s_collapse   = 1<<3  ; 8
  #__s_inbetween  = 1<<4  ; 16
  
  #__s_enter      = 1<<5  ; 32  ; mouse enter
  #__s_focus      = 1<<6  ; 128 ; keyboard focus
  #__s_disable    = 1<<7  ; 64  ; 
  #__s_repaint    = 1<<8  ; 256
  #__s_scroll     = 1<<9  ; 512
  
  #__s_drag       = 1<<10  ; 1024
  #__s_drop       = 1<<11  ; 2048 ; drop enter state
  
  #__s_current    = 1<<12 ; 
EndEnumeration

#__Flag_NoGadgets = 1024

Enumeration #PB_EventType_FirstCustomValue
  #PB_EventType_Repaint
  #PB_EventType_Create
EndEnumeration
;}

;- DECLARE
;{         }
Declare DoWidgetEvents( *this.s_WIDGET, eventtype )
;}


;-
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
            *this\draw\width = *this\x-*this\draw\x
            *this\draw\width = *this\parent\draw\width + *this\draw\width
          Else
            *this\draw\width = *this\width
          EndIf
        EndIf
        
        If *this\height > (*this\parent\draw\height - *this\parent\fs) - *this\y
          *this\draw\height = (*this\parent\draw\height - *this\parent\fs) - *this\y
        Else
          If *this\draw\y > *this\y
            *this\draw\height = *this\y-*this\draw\y
            *this\draw\height = *this\parent\draw\height + *this\draw\height
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
    ;       AddElement(*draw())
    ;       *draw() = *this
    ;     EndIf
    
    
    ; *this\visible = 1
  EndIf
EndProcedure

Procedure DrawFrame( *this.s_WIDGET, x, y, FrameColor )
  
  If *this\draw\y = *this\y
    Line( x+*this\draw\x, y+*this\draw\y, *this\draw\width, 1, FrameColor )
  EndIf
  If *this\draw\x = *this\x
    Line( x+*this\draw\x, y+*this\draw\y, 1, *this\draw\height, FrameColor )
  EndIf
  If Not ( *this\draw\x = *this\x And *this\width > *this\draw\width ) ; *this\parent And *this\x+*this\width < *this\parent\draw\width
    Line( x+*this\draw\x+*this\draw\width-1, y+*this\draw\y, 1, *this\draw\height, FrameColor )
  EndIf
  If Not ( *this\draw\y = *this\y And *this\height > *this\draw\height ) ; *this\parent And *this\y+*this\height < *this\parent\draw\height
    Line( x+*this\draw\x, y+*this\draw\y+*this\draw\height-1, *this\draw\width, 1, FrameColor )
  EndIf
  
EndProcedure

Procedure DrawFirst( *this.s_WIDGET, x, y  )
  DrawingMode( #PB_2DDrawing_Default )
  Box( x+*this\draw\x, y+*this\draw\y, *this\draw\width, *this\draw\height, *this\color\back[*this\color\state] )
  
  Define yy = *this\fs
  ForEach *this\item( )
    If *this\height > yy
      *this\item( )\visible = 1
    EndIf
    
    
    If *this\item( )\visible
      *this\item( )\y = yy 
      
      DrawingMode( #PB_2DDrawing_Default )
      Box( x+*this\x+*this\item( )\x, y+*this\y+*this\item( )\y, *this\item( )\width, *this\item( )\height, *this\item( )\color\back )
      
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( x+*this\x+*this\item( )\x, y+*this\y+*this\item( )\y, *this\item( )\width, *this\item( )\height, *this\color\frame )
      
      DrawingMode( #PB_2DDrawing_Transparent )
      DrawText( x+*this\x+*this\item( )\x, y+*this\y+*this\item( )\y, *this\item()\String, 0)
    EndIf
    
    yy + *this\item( )\height
  Next
  
  
  If *this\data
    DrawingMode( #PB_2DDrawing_Transparent )
    DrawText(  x+*this\x, y+*this\y, Str(*this\data), 0)
  EndIf
EndProcedure

Procedure DrawLast( *this.s_WIDGET, x, y  )
  DrawingMode( #PB_2DDrawing_Outlined )
  Box( x+*this\x, y+*this\y, *this\width, *this\height, $1DE6E8 )
  
  DrawFrame( *this, x,y, *this\color\frame )
EndProcedure

Procedure DrawWidget( *this.s_WIDGET, x, y )
  If *this\address
    If *this\visible 
      ;
      DrawFirst( *this, x, y )
      
      If *this\count\childrens
        ForEach *this\child( )
          If *this\child( )\visible 
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
  
  If *this\address
    If *this\parent
      If *this\parent\count\childrens
        ChangeCurrentElement( *this\parent\child( ), *this\address )
        DeleteElement( *this\parent\child( ) )
        *this\parent\count\childrens - 1
      EndIf
    Else 
      ; it's root widget
      If *this = GetGadgetData( *this\canvas\gadget ) 
        SetGadgetData( *this\canvas\gadget, #Null )
        ChangeCurrentElement( widget( ), *this\address )
        DeleteElement( widget( ) )
      EndIf
    EndIf
    
    *this\address = #Null
  EndIf
  
  ;FreeStructure( *this )
EndProcedure

Procedure SetParentWidget( *this.s_WIDGET, *parent.s_WIDGET )
  If *parent
    *parent\count\childrens + 1
    
    If *this\parent
      *this\parent\count\childrens - 1
    EndIf
    
    ;*this\root = *parent\root
    *this\count\parents = *parent\count\parents + 1
    *this\canvas = *parent\canvas
    *this\parent = *parent
  EndIf
EndProcedure

Procedure AddItem( *this.s_WIDGET, position, text.s )
  If *this
    LastElement( *this\item( ) )
    *this\item( )\address = AddElement( *this\item( ) )
    *this\item()\string = text
    
    *this\item( )\x = *this\fs
    *this\item()\height = 20
    *this\item()\width = *this\width - *this\fs*2
    
    *this\item( )\color\back = $8ED4C4
    
    *this\count\items + 1
    
    ;     If *this\item( )\address
    ;       SetParentWidget( *this\item( ), *this )
    ;       ResizeWidget( *this\item( ), x,y,width,height )
    ;       
    ;       DoWidgetEvents( *this\item( ), #PB_EventType_Create )
    ;       PostRepaint( *this\item( ), #PB_EventType_Repaint )
    ProcedureReturn *this\item( )
    ;     EndIf
  EndIf
EndProcedure

Procedure AddWidget( *this.s_WIDGET, x,y,width,height)
  Protected result
  
  If *this
    LastElement( *this\child( ) )
    result = AddElement( *this\child( ) )
    *this\child( ) = AllocateStructure( s_WIDGET )
    *this\child( )\address = result
    *this\child( )\fs = 1
    
    *this\child( )\color\back = $F3F3F3
    
    If *this\child( )\address
      SetParentWidget( *this\child( ), *this )
      ResizeWidget( *this\child( ), x,y,width,height )
      
      DoWidgetEvents( *this\child( ), #PB_EventType_Create )
      PostRepaint( *this\child( ), #PB_EventType_Repaint )
      ProcedureReturn *this\child( )
    EndIf
  EndIf
EndProcedure

Procedure OpenWidget( window, gadget, x,y,width,height, flag = 0 )
  Protected g, w
  Protected *this.s_WIDGET = AllocateStructure( s_WIDGET )
  
  If *this
    *this\canvas = AllocateStructure( s_CANVAS )
    *this\address = AddElement( *this\canvas\child( ) )
    ;*this\fs = 5
    
    If *this\address
      If window =- 1
        window = OpenWindow( window, x,y,width,height, "", flag )
        x = 0
        y = 0
      EndIf
      
      If Not ( IsGadget( gadget ) And 
               GadgetType( gadget ) = #PB_GadgetType_Canvas )
        g = CanvasGadget( gadget, x,y,width,height ) 
        If gadget =- 1 : gadget = g : EndIf 
        x = 0 : y = 0
      EndIf
      
      *this\canvas\widget = *this
      *this\canvas\window = window
      *this\canvas\gadget = gadget
      
      ResizeWidget( *this, x,y,width,height )
      SetGadgetData( gadget, *this )
      
      ;WidgetCanvas( ) = *this\canvas
      ;WidgetCanvas( )\child( ) = *this\address
      ;Root( ) = *this
      CopyStructure( @*this\canvas, @WidgetCanvas( ), s_CANVAS )
      CopyList( *this\canvas\child( ), WidgetCanvas( )\child( ) )
      
      DoWidgetEvents( *this, #PB_EventType_Create )
      PostRepaint( *this, #PB_EventType_Repaint ) ;
    EndIf
    
    ProcedureReturn *this
  EndIf
EndProcedure

Procedure GetAtPointWidget( List *child.s_WIDGET(), mouse_x, mouse_y )
  Protected result 
  
  LastElement( *child( ) )
  Repeat 
    If *child( )\visible And Atbox( *child( )\draw\x, *child( )\draw\y, *child( )\draw\width, *child( )\draw\height, mouse_x-*child( )\parent\x, mouse_y-*child( )\parent\y )
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

Procedure GetAtPointItem( List item.s_ITEM( ), mouse_x, mouse_y )
  Protected result
  
  LastElement( item( ) )
  Repeat 
    If item( )\visible And 
       Atbox( item( )\x, item( )\y, item( )\width, item( )\height, mouse_x, mouse_y )
      
      If item( )\count\childrens
        result = GetAtPointItem( item( )\item( ), mouse_x, mouse_y )
      EndIf
      
      If result = 0
        result = item( )
      EndIf
      
      If result
        Break
      EndIf
    EndIf
  Until PreviousElement( item( ) ) = 0
  
  ProcedureReturn result
EndProcedure

Procedure DoItemEvents( *this.s_WIDGET, *item.s_ITEM, eventtype )
  If *item
    If *item\state & #__s_enter
      If WidgetMouse( )\buttons
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
    If *item\state & #__s_select
      *item\color\back = $FFAA00
    Else
      If *item\state & #__s_focus
        *item\color\back = $FF0090
      EndIf
    EndIf
  EndIf
  
  *this\state | #__s_repaint
  
EndProcedure

Procedure DoWidgetEvents( *this.s_WIDGET, eventtype )
  EventWidget( ) = *this
  
  ; 
  If *this\count\items
    If Atbox( *this\draw\x+*this\fs, *this\draw\y+*this\fs, *this\draw\width-*this\fs*2, *this\draw\height-*this\fs*2, WidgetMouse( )\x, WidgetMouse( )\y )
      EnteredItem( *this ) = GetAtPointItem( *this\item( ), WidgetMouse( )\x-*this\x, WidgetMouse( )\y-*this\y )
      
      If LeavedItem( *this ) <> EnteredItem( *this )
        If LeavedItem( *this )
          LeavedItem( *this )\state &~ #__s_enter
          LeavedItem( *this )\state | #__s_repaint
          ;Debug "leaved1"
          DoItemEvents( *this, LeavedItem( *this ), #PB_EventType_MouseLeave )
        EndIf
        
        LeavedItem( *this ) = EnteredItem( *this )
        
        If EnteredItem( *this ) And
           EnteredItem( *this )\state & #__s_enter = 0
          EnteredItem( *this )\state | #__s_enter 
          EnteredItem( *this )\state | #__s_repaint
          ;Debug "enterd"
          DoItemEvents( *this,  EnteredItem( *this ), #PB_EventType_MouseEnter )
        EndIf
      EndIf
    EndIf  
  EndIf
  
  ;Debug ""+ *this +" "+ eventtype
  If *this\state & #__s_enter
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
  If *this\state & #__s_select
    *this\color\back = $FFAA00
  Else
    If *this\state & #__s_focus
      *this\color\back = $FF0090
    EndIf
  EndIf
  
  
  
  ;
  If *this\state & #__s_repaint
    *this\state &~ #__s_repaint
    ReDrawWidget( *this\canvas\widget )
  EndIf
EndProcedure


Procedure WidgetEvents( Canvas, eventtype )
  If eventtype = #PB_EventType_Repaint
    ; DoWidgetEvents( EventWidget( ), EventData() )
    DoWidgetEvents( EventData( ), eventtype )
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
    
    If eventtype = #PB_EventType_MouseLeave   
      WidgetMouse( )\x =- 1
      WidgetMouse( )\y =- 1
    EndIf
    If eventtype = #PB_EventType_MouseEnter
      WidgetMouse( )\x = GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
      WidgetMouse( )\y = GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
    EndIf
    If eventtype = #PB_EventType_MouseMove
      WidgetMouse( )\x = GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
      WidgetMouse( )\y = GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
      
      ;
      If PressedWidget( )
        DoWidgetEvents( PressedWidget( ), eventtype )
      ElseIf EnteredWidget( )
        DoWidgetEvents( EnteredWidget( ), eventtype )
      EndIf
    EndIf
    
    If eventtype = #PB_EventType_MouseEnter Or
       eventtype = #PB_EventType_MouseLeave
      Root( ) = GetGadgetData( Canvas )
    EndIf
    
    If Root( )
      If Root( )\count\childrens
        ; Define time = ElapsedMilliseconds()
        EnteredWidget( ) = GetAtPointWidget( Root( )\child( ), WidgetMouse( )\x, WidgetMouse( )\y )
        ; Debug ElapsedMilliseconds() - time
        
        If Not EnteredWidget( ) And Root( )\visible And 
           Atbox( Root( )\draw\x, Root( )\draw\y, Root( )\draw\width, Root( )\draw\height, WidgetMouse( )\x, WidgetMouse( )\y )
            EnteredWidget( ) = Root( )
        EndIf
        
        If LeavedWidget( ) <> EnteredWidget( )
          If LeavedWidget( )
            LeavedWidget( )\state &~ #__s_enter
            LeavedWidget( )\state | #__s_repaint
            ;Debug "leaved"
            DoWidgetEvents( LeavedWidget( ), #PB_EventType_MouseLeave )
          EndIf
          
          LeavedWidget( ) = EnteredWidget( )
          
          If EnteredWidget( ) And
             EnteredWidget( )\state & #__s_enter = 0
            EnteredWidget( )\state | #__s_enter 
            EnteredWidget( )\state | #__s_repaint
            ;Debug "entered"
            DoWidgetEvents( EnteredWidget( ), #PB_EventType_MouseEnter )
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown Or 
           eventtype = #PB_EventType_RightButtonDown Or
           eventtype = #PB_EventType_MiddleButtonDown
          
          If eventtype = #PB_EventType_LeftButtonDown
            WidgetMouse( )\buttons | #PB_Canvas_LeftButton
          ElseIf eventtype = #PB_EventType_RightButtonDown
            WidgetMouse( )\buttons | #PB_Canvas_RightButton
          ElseIf eventtype = #PB_EventType_MiddleButtonDown
            WidgetMouse( )\buttons | #PB_Canvas_MiddleButton
          EndIf
          
          If EnteredWidget( )
            If FocusedWidget( ) <> EnteredWidget( )
              If FocusedWidget( )
                FocusedWidget( )\state &~ #__s_focus
                DoWidgetEvents( FocusedWidget( ), #PB_EventType_LostFocus )
              EndIf
              
              FocusedWidget( ) = EnteredWidget( )
              FocusedWidget( )\state | #__s_focus
              DoWidgetEvents( FocusedWidget( ), #PB_EventType_Focus )
            EndIf
            
            PressedWidget( ) = EnteredWidget( )
            PressedWidget( )\state | #__s_select
            EnteredWidget( )\state | #__s_repaint
            DoWidgetEvents( PressedWidget( ), eventtype )
          EndIf 
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp Or 
           eventtype = #PB_EventType_RightButtonUp Or
           eventtype = #PB_EventType_MiddleButtonUp
          
          If eventtype = #PB_EventType_LeftButtonUp
            WidgetMouse( )\buttons &~ #PB_Canvas_LeftButton
          ElseIf eventtype = #PB_EventType_RightButtonUp
            WidgetMouse( )\buttons &~ #PB_Canvas_RightButton
          ElseIf eventtype = #PB_EventType_MiddleButtonUp
            WidgetMouse( )\buttons &~ #PB_Canvas_MiddleButton
          EndIf
          
          If PressedWidget( )
            PressedWidget( )\state &~ #__s_select
            PressedWidget( )\state | #__s_repaint
            DoWidgetEvents( PressedWidget( ), eventtype )
            PressedWidget( ) = #Null
          EndIf
        EndIf
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



Procedure OpenList( *this.s_WIDGET )
  OpenedWidget( ) = *this
EndProcedure

Procedure CloseList( )
  If OpenedWidget( ) And OpenedWidget( )\parent 
    OpenedWidget( ) = OpenedWidget( )\parent
  Else
    OpenedWidget( ) = Root( )
  EndIf
EndProcedure

Procedure Container( x,y,width,height, flag )
  Protected result = AddWidget( OpenedWidget( ), x,y,width,height )
  
  If flag & #__Flag_NoGadgets = 0
    OpenedWidget( ) = result
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure SetData( *this.s_WIDGET, *data )
  *this\data = *data
EndProcedure

Procedure Splitter( x,y,width,height, first,second, flag)
  ProcedureReturn  Container( x,y,width,height, flag )
EndProcedure


;-
OpenWindow(0,100,100,600,600,"")

Define *root1.s_WIDGET = OpenWidget(0,-1, 10,10,300-20,300-20)

;Define *root4.s_WIDGET = OpenWidget(0,-1, 300,300,300,300)

Define *root3.s_WIDGET = OpenWidget(0,-1, 300,10,300-20,600-20)

Define *root2.s_WIDGET = OpenWidget(0,-1, 10,300,300-20,300-20)


Define count = 2;0000
#st = 1
Global  mx=#st,my=#st

Define time = ElapsedMilliseconds()


AddWidget(*root2, 80,80, 150,50)
Debug "2 - "+*root2 +" "+ Str(widget( )) +" "+ Str(*root2\child( ))
AddWidget(*root2\child(), 20,-30, 50,50)
AddWidget(*root2\child(), 30,30, 50,50)
AddWidget(*root2\child(), 80,-60, 50,50)
AddWidget(*root2\child(), 90,60, 50,50)


AddWidget(*root3, 20,20, 200,260-20+300)
Debug "3 - "+*root3 +" "+ Str(widget( )) +" "+ Str(*root3\child( ))
Define i
For i=1 To 10;00000
  AddItem(*root3\child( ), i, "text-"+Str(i))
Next

OpenList( *root1 )

Define editable
SetData(Container(20, 20, 180, 180, editable), 1)
Debug "1 - "+*root1 +" "+ Str(widget( )); +" "+ Str(*root1\child( ))
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

CloseList()
CloseList()
SetData(Container(10, 45, 70, 180, editable), 11) 
SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
SetData(Container(10, 45, 70, 180, editable), 11) 
SetData(Container(10, 5, 70, 180, editable), 11) 
SetData(Container(10, 5, 70, 180, editable), 11) 
SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
CloseList()
CloseList()
CloseList()
CloseList()


Debug ElapsedMilliseconds() - time

; Define *first.s_WIDGET = FirstElement(*root1\child())
; ;ResizeWidget(*first, 100,10,10,150)
; ;FreeWidget( *first )
; ;FreeWidget( *root1 )
; 
; *first.s_WIDGET = FirstElement(*root2\child())
; ;ResizeWidget(*first, 100,10,10,150)
; 
; 
; ; ;Enumerate( *root1 )
; ; ReDrawWidget( *root1 )
; ; ;
; ; ReDrawWidget( *root2 )

Define event
Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    
    WidgetEvents( EventGadget( ), EventType( ) )
    
  EndIf
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------------------------
; EnableXP