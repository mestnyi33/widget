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
Structure s_POINT
  x.i
  y.i
EndStructure

Structure s_COORDINATE Extends s_POINT
  width.i
  height.i
EndStructure

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
;   buttons.l               ; 
;   change.b                ; if moved mouse this value #true
EndStructure

Structure s_COUNT
  ;   index.l
  ;   type.l
  ;   items.l
  ;   events.l
  *parents
  *childrens
EndStructure

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
  draw.s_coordinate
  ;*childrens
  
  List child.s_WIDGET()
EndStructure

Structure s_CANVAS
  window.i
  gadget.i
  *widget.s_WIDGET
  
  List child.s_WIDGET()
EndStructure


;- GLOBAL
Global *focused_WIDGET.s_WIDGET
Global *opened_WIDGET.s_WIDGET

Global mouse.s_MOUSE
Global canvas.s_CANVAS
;Global NewList widget.s_WIDGET( )
Global NewList *draw.s_WIDGET( )

;-
;Macro Mouse( ) : widget::this( )\mouse: EndMacro
    
Macro widget( ) : canvas\child( ) : EndMacro

Macro EnteredWidget( )
  mouse\entered
EndMacro

Macro LeavedWidget( )
  mouse\leaved
EndMacro

Macro PressedWidget( )
  mouse\pressed
EndMacro ; Returns mouse button's pressed widget

Macro FocusedWidget( ) 
  *focused_WIDGET
EndMacro ; Returns keyboard focus widget

Macro OpenedWidget( )
  *opened_WIDGET
EndMacro

Macro Root( )
  canvas\widget
EndMacro

Macro get_root( _this_ )
  _this_\canvas\widget
EndMacro

;-
;- CONSTANT
Enumeration
  #__s_normal      = 0<<0  ; 0
  #__s_selected    = 1<<0  ; 1
  #__s_expanded    = 1<<1  ; 2
  #__s_checked     = 1<<2  ; 4
  #__s_collapsed   = 1<<3  ; 8
  #__s_inbetween   = 1<<4  ; 16
  
  #__s_entered     = 1<<5  ; 32
  #__s_focused     = 1<<6  ; 128 ; keyboard focus
  #__s_disabled    = 1<<7  ; 64
  #__s_scrolled    = 1<<8  ; 256
  
  #__s_dragged     = 1<<9  ; 512
  #__s_dropped     = 1<<10 ; 1024 ; drop enter state
  
  #__s_current     = 1<<11 ;
EndEnumeration

#__Flag_NoGadgets = 1024

;-
Procedure ResizeWidget( *this.s_WIDGET, x,y,width,height )
  If *this
    *this\x = x
    *this\y = y
    *this\width = width
    *this\height = height
    
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
    
    If *this\parent
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
          *this\draw\width = (*this\parent\draw\width - *this\parent\fs) + *this\draw\width
        Else
          *this\draw\width = *this\width
        EndIf
      EndIf
      
      If *this\height > (*this\parent\draw\height - *this\parent\fs) - *this\y
        *this\draw\height = (*this\parent\draw\height - *this\parent\fs) - *this\y
      Else
        If *this\draw\y > *this\y
          *this\draw\height = *this\y-*this\draw\y
          *this\draw\height = (*this\parent\draw\height - *this\parent\fs) + *this\draw\height
        Else
          *this\draw\height = *this\height
        EndIf
      EndIf
    Else
      *this\draw\x = *this\x 
      *this\draw\y = *this\y 
      *this\draw\width = *this\width 
      *this\draw\height = *this\height 
    EndIf
    
    
    
    *this\visible = 1
  EndIf
EndProcedure

Procedure OpenWidget( window, gadget, x,y,width,height, flag = 0 )
  Protected g, w
  Protected *this.s_WIDGET = AllocateStructure( s_WIDGET )
  
  If *this
    *this\canvas = AllocateStructure( s_CANVAS )
    *this\address = AddElement( widget( ) )
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
      
      *this\canvas\window = window
      *this\canvas\gadget = gadget
      *this\canvas\widget = *this
      
      ResizeWidget( *this, x,y,width,height )
      SetGadgetData( gadget, *this )
      Root( ) = *this
    EndIf
    
    ProcedureReturn *this
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

Procedure DrawWidget( *this.s_WIDGET, x, y )
  Protected BackColor = RGB( 230,230,230)
  Protected FrameColor = 0
  
  If *this\address
    If *this\state & #__s_entered
      BackColor = $301DE8
    Else
      BackColor = $13FF00
    EndIf
    If *this\state & #__s_selected
      BackColor = $FFAA00
    EndIf
    
    DrawingMode( #PB_2DDrawing_Default )
    Box( x+*this\draw\x, y+*this\draw\y, *this\draw\width, *this\draw\height, BackColor )
    
    If *this\count\childrens
      ForEach *this\child( )
        If *this\child( )\visible 
          DrawWidget( *this\child( ), x+*this\x, y+*this\y )
        EndIf
      Next
    EndIf
    
    
    DrawingMode( #PB_2DDrawing_Outlined )
    Box( x+*this\x, y+*this\y, *this\width, *this\height, $1DE6E8 )
    
    If *this\data
      DrawText(  x+*this\x, y+*this\y, Str(*this\data), 0)
    EndIf
    
    DrawFrame( *this, x,y, FrameColor )
    
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

Procedure GetAtPointWidget( *this.s_WIDGET, mouse_x, mouse_y )
  Protected result 
  
  If *this\visible And Atbox( *this\draw\x, *this\draw\y, *this\draw\width, *this\draw\height, mouse_x, mouse_y )
    If *this\count\childrens
      LastElement( *this\child( ) )
      Repeat 
        If *this\child( )\visible And Atbox( *this\child( )\draw\x, *this\child( )\draw\y, *this\child( )\draw\width, *this\child( )\draw\height, mouse_x-*this\x, mouse_y-*this\y )
          result = GetAtPointWidget( *this\child( ), mouse_x-*this\x, mouse_y-*this\y )
          If result
            Break
          EndIf
        EndIf
      Until PreviousElement( *this\child( ) ) = 0
    EndIf
    
    If result = 0
      result = *this
    EndIf
  EndIf
  
  ProcedureReturn result
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

Procedure AddWidget( *this.s_WIDGET, x,y,width,height)
  If *this
    LastElement( *this\child( ) )
    *this\child( )\address = AddElement( *this\child( ) )
    *this\child( )\fs = 1
    
    If *this\child( )\address
      SetParentWidget( *this\child( ), *this )
      ResizeWidget( *this\child( ), x,y,width,height )
      
      ProcedureReturn *this\child( )
    EndIf
  EndIf
EndProcedure


;-
OpenWindow(0,100,100,600,600,"")

Define *root1.s_WIDGET = OpenWidget(0,-1, 0,0,300,300)

Define *root2.s_WIDGET = OpenWidget(0,-1, 300,300,600,600)


Define count = 2;0000
#st = 1
Global  mx=#st,my=#st

Define time = ElapsedMilliseconds()

; For i=0 To count ; Step 5
;   If i = 0
;     s = 10
;   ElseIf i = 1
;     s = 70
;   Else
;     s + 5
;   EndIf
;   AddWidget(*root1, i+10,i+s, 150,50)
;   ;AddWidget(*root2, i+s,i+s, 150,50)
;   
;   If ListIndex(*root1\child()) = 0
;     For ii=0 To count ; Step 5
;       If ii = 0
;         ss = 50
;       ElseIf ii = 1
;         ss = 100
;       Else
;         ss + 10
;       EndIf
;       AddWidget(*root1\child(), ii+ss,ii+10, 50,50)
;       ;AddWidget(*root2\child(), ii+ss,ii, 50,50)
;       
;       ;       If ListIndex(widget()\child()) = 0
;       ;         For iii=0 To count ; Step 5
;       ;           If iii = 0
;       ;             sss = 0
;       ;           ElseIf i = 1
;       ;             sss = 50
;       ;           Else
;       ;             sss + 15
;       ;           EndIf
;       ;           AddWidget(widget()\child(), widget()\child()\child(), iii,iii+sss, 50,50)
;       ;           ;AddWidget(widget()\child()\child(), iii+sss,iii+sss, 50,50)
;       ;           
;       ;           If ListIndex(widget()\child()\child()) = 0
;       ;             For iiii=0 To count Step 5
;       ;               If iiii = 0
;       ;                 ssss = 0
;       ;               ElseIf i = 1
;       ;                 ssss = 50
;       ;               Else
;       ;                 ssss + 20
;       ;               EndIf
;       ;               AddWidget(widget()\child()\child(), widget()\child()\child()\child(), iiii+ssss,iiii+ssss, 50,50)
;       ;               
;       ;             Next
;       ;           EndIf
;       ;           
;       ;         Next
;       ;       EndIf
;     Next
;   EndIf
;   ;   
; Next

AddWidget(*root2, 20,30, 150,50)
AddWidget(*root2\child(), 20,-30, 50,50)
AddWidget(*root2\child(), 30,30, 50,50)

; ; i=0
; ForEach widget()
;   Debug "widget - "+widget()\x +" "+ widget()\y +" "+ widget()\width +" "+ widget()\height
;   ForEach widget()\child()
;     Debug "  widget\child - "+widget()\child()\x +" "+ widget()\child()\y +" "+ widget()\child()\width +" "+ widget()\child()\height
;     ForEach widget()\child()\child()
;       Debug "    widget\child\child - "+widget()\child()\child()\x +" "+ widget()\child()\child()\y +" "+ widget()\child()\child()\width +" "+ widget()\child()\child()\height
;     Next
;   Next
; Next
; ; Debug i

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
  If OpenedWidget( ) And 
     OpenedWidget( )\parent ;And OpenedWidget( )\canvas\gadget = Root( )\canvas\gadget 
    
    ;Debug "8888 " + OpenedWidget( ) ;+ " - " + OpenedWidget( )\class + " " + OpenedWidget( )\parent + " - " + OpenedWidget( )\parent\class
    ;     If OpenedWidget( )\parent\type = #__type_MDI
    ;       OpenedWidget( ) = OpenedWidget( )\parent\parent
    ;     Else
    OpenedWidget( ) = OpenedWidget( )\parent
    ;     EndIf
  Else
    ; Debug 555
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

Define editable
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

Define *first.s_WIDGET = FirstElement(*root1\child())
;ResizeWidget(*first, 100,10,10,150)
;FreeWidget( *first )
;FreeWidget( *root1 )

*first.s_WIDGET = FirstElement(*root2\child())
;ResizeWidget(*first, 100,10,10,150)


Procedure DoEvents( *this.s_WIDGET, eventtype )
  Debug ""+ *this +" "+ eventtype
EndProcedure


Procedure WidgetEvents( eventgadget, eventtype )
  Protected repaint
  
  If eventtype = #PB_EventType_MouseMove Or
     eventtype = #PB_EventType_MouseEnter Or
     eventtype = #PB_EventType_MouseLeave Or
     eventtype = #PB_EventType_LeftButtonDown Or 
     eventtype = #PB_EventType_RightButtonDown Or
     eventtype = #PB_EventType_MiddleButtonDown Or
     eventtype = #PB_EventType_LeftButtonUp Or 
     eventtype = #PB_EventType_RightButtonUp Or
     eventtype = #PB_EventType_MiddleButtonUp
    
    If eventtype = #PB_EventType_MouseEnter Or
       eventtype = #PB_EventType_MouseLeave
      Root( ) = GetGadgetData( eventgadget )
    EndIf
    
    If Root( )
      ; Define time = ElapsedMilliseconds()
      EnteredWidget( ) = GetAtPointWidget( Root( ), GetGadgetAttribute( eventgadget,  #PB_Canvas_MouseX ), GetGadgetAttribute( eventgadget, #PB_Canvas_MouseY ) )
      ; Debug ElapsedMilliseconds() - time
      
      
      ;
      If eventtype = #PB_EventType_LeftButtonDown Or 
         eventtype = #PB_EventType_RightButtonDown Or
         eventtype = #PB_EventType_MiddleButtonDown
        
        If EnteredWidget( )
          FocusedWidget( ) = EnteredWidget( )
          
          
          PressedWidget( ) = EnteredWidget( )
          PressedWidget( )\state | #__s_selected
          DoEvents( PressedWidget( ), eventtype )
          repaint = 1
        EndIf 
      EndIf
      
      ;
      If eventtype = #PB_EventType_LeftButtonUp Or 
         eventtype = #PB_EventType_RightButtonUp Or
         eventtype = #PB_EventType_MiddleButtonUp
        
        If PressedWidget( )
          PressedWidget( )\state &~ #__s_selected
          DoEvents( PressedWidget( ), eventtype )
          PressedWidget( ) = #Null
          repaint = 1
        EndIf
      EndIf
      
      
      If EnteredWidget( )
        If EnteredWidget( )\state & #__s_entered = 0
          EnteredWidget( )\state | #__s_entered 
          
          If LeavedWidget( ) <> EnteredWidget( )
            If LeavedWidget( )
              LeavedWidget( )\state &~ #__s_entered
              DoEvents( LeavedWidget( ), #PB_EventType_MouseLeave )
            EndIf
            LeavedWidget( ) = EnteredWidget( )
          EndIf
          
          DoEvents( EnteredWidget( ), #PB_EventType_MouseEnter )
          repaint = 1
        EndIf
      EndIf
      
      If eventtype = #PB_EventType_MouseLeave
        If LeavedWidget( )
          If LeavedWidget( )\state & #__s_entered
            LeavedWidget( )\state &~ #__s_entered
            DoEvents( LeavedWidget( ), #PB_EventType_MouseLeave )
            repaint = 1
          EndIf
        EndIf
      EndIf
      
      If repaint
       ; repaint = 0
        ReDrawWidget( Root( ) )
      EndIf
    EndIf
  EndIf
  
EndProcedure



;Enumerate( *root1 )
ReDrawWidget( *root1 )
;
ReDrawWidget( *root2 )

Define event
Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    
    WidgetEvents( EventGadget(), EventType( ) )
    
  EndIf
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----------------
; EnableXP