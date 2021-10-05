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
Structure count
  ;   index.l
  ;   type.l
  ;   items.l
  ;   events.l
  *parents
  *childrens
EndStructure

Structure widget
  *address
  ;*root.widget
  *parent.widget
  *canvas.canvas
  
  x.i
  y.i
  width.i
  height.i
  
  draw.b
  count.count
  ;*childrens
EndStructure

Structure canvas
  window.i
  gadget.i
  *widget.widget
  
  List child.widget()
EndStructure

;- GLOBAL
Global canvas.canvas
;Global NewList widget.widget( )
Global NewList *draw.widget( )

;-
Macro widget( )
  canvas\child( )
EndMacro

Macro Root( )
  canvas\widget
EndMacro

Macro get_root( _this_ )
  _this_\canvas\widget
EndMacro

;-
Procedure ResizeWidget( *this.widget, x,y,width,height )
  If *this
    *this\x = x
    *this\y = y
    *this\width = width
    *this\height = height
    
    ;     If *this\parent
    ;       If *this\parent\parent ;And *this\parent\parent\draw
    ;         *this\parent\draw = Interrect( 0, 0, *this\parent\parent\width, *this\parent\parent\height, *this\parent\x, *this\parent\y, *this\parent\width, *this\parent\height )
    ;       EndIf
    ;       If *this\parent\draw
    ;         *this\draw = Interrect( 0, 0, *this\parent\width, *this\parent\height, *this\x, *this\y, *this\width, *this\height )
    ;       EndIf
    ;     Else
    ;       ;If *this
    ;         Debug "root - "+*this\canvas\root\width
    ;       ;EndIf
    ;       *this\draw = Interrect( 0, 0, *this\canvas\root\width, *this\canvas\root\height, *this\x, *this\y, *this\width, *this\height )
    ;      ; *this\draw = Interrect( 0, 0, GadgetWidth(*this\canvas\gadget), GadgetHeight(*this\canvas\gadget), *this\x, *this\y, *this\width, *this\height )
    ;     EndIf
    ;     
    ;     If *this\draw
    ;       AddElement(*draw())
    ;       *draw() = *this
    ;     EndIf
    
    *this\draw = 1
  EndIf
EndProcedure

Procedure OpenWidget( window, gadget, x,y,width,height, flag = 0 )
  Protected g, w
  widget( )\address = AddElement( widget( ) )
    
  If widget( )\address
    widget( )\canvas = AllocateStructure( canvas )
    
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
    
    widget( )\canvas\window = window
    widget( )\canvas\gadget = gadget
    widget( )\canvas\widget = widget( )
    
    ResizeWidget( widget( ), x,y,width,height )
    SetGadgetData( gadget, widget( ) )
    Root( ) = widget( )
  EndIf
  
  ProcedureReturn widget( )
EndProcedure

Procedure DrawWidget( *this.widget, x, y )
  ;If *this\address
  DrawingMode( #PB_2DDrawing_Outlined )
  Box( x+*this\x, y+*this\y, *this\width, *this\height, color )
  
  ;If *this\count\childrens
  ;     ;If ListSize( widget( ) )
  ;     ForEach widget( )
  ;       If widget( )\draw 
  ;         DrawWidget( widget( ), x+*this\x, y+*this\y )
  ;       EndIf
  ;     Next
  ;   ;EndIf
  ;EndIf
EndProcedure

Procedure ReDrawWidget( *this.widget )
  If *this\address
    StartDrawing( CanvasOutput( *this\canvas\gadget ) )
    FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
    ForEach widget( )
      DrawWidget( widget( ), 0,0 )
    Next
    StopDrawing( )
  EndIf
EndProcedure

Procedure GetAtPointWidget( mouse_x, mouse_y )
  Protected result
  
  If ListSize( widget( ) )
    LastElement( widget( ) )
    Repeat ; Not ( widget( )\parent And widget( )\draw ) And 
      
      If widget( )\draw And Atbox( widget( )\x, widget( )\y, widget( )\width, widget( )\height, mouse_x, mouse_y )
        ;         If widget( )\count\childrens
        ;           result = GetAtPointWidget( widget( )\child( ), mouse_x, mouse_y )
        ;         EndIf
        ;         If result = 0
        result = widget( )
        ;         EndIf
        Break
      EndIf
    Until PreviousElement( widget( ) ) = 0
  EndIf
  
  If result = 0
    If Root( )\draw And Atbox( Root( )\x, Root( )\y, Root( )\width, Root( )\height, mouse_x, mouse_y )
      result = Root( )
    EndIf
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure SetParentWidget( *this.widget, *parent.widget )
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

Procedure FreeWidget( *this.widget )
  If *this\count\childrens 
    *this\count\childrens = 0
    FreeList( widget( ) )
  EndIf
  
  If *this\address
    If *this\parent
      If *this\parent\count\childrens
        ChangeCurrentElement( widget( ), *this\address )
        DeleteElement( widget( ) )
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

Procedure AddWidget( *this.widget, x,y,width,height)
  LastElement( widget( ) )
  widget( )\address = AddElement( widget( ) )
  
  If widget( )\address
    SetParentWidget( widget( ), *this )
    ResizeWidget( widget( ), x,y,width,height )
  EndIf
EndProcedure


;-
OpenWindow(0,100,100,600,600,"")

*root1.widget = OpenWidget(0,-1, 0,0,300,300)

*root2.widget = OpenWidget(0,-1, 300,300,600,600)


Define count = 2;0000
#st = 1
Global  mx=#st,my=#st

Define time = ElapsedMilliseconds()

For i=0 To count ; Step 5
  If i = 0
    s = 0
  ElseIf i = 1
    s = 50
  Else
    s + 5
  EndIf
  AddWidget(*root1, i,i+s, 150,50)
  ;AddWidget(*root2, i+s,i+s, 50,50)
Next

FirstElement(widget())
NextElement(widget())
NextElement(widget())
If ListIndex(widget()) = 2
  *parent.widget = widget()
  
  For ii=0 To count ; Step 5
    If ii = 0
      ss = 50
    ElseIf ii = 1
      ss = 100
    Else
      ss + 10
    EndIf
    PushListPosition( widget() )
    AddWidget(*parent, ii+ss,ii, 50,50)
    ;AddWidget(*root2\child(), ii+ss,ii, 50,50)
    PopListPosition(widget() )
    ;       If ListIndex(widget()\child()) = 0
    ;         For iii=0 To count ; Step 5
    ;           If iii = 0
    ;             sss = 0
    ;           ElseIf i = 1
    ;             sss = 50
    ;           Else
    ;             sss + 15
    ;           EndIf
    ;           AddWidget(widget()\child(), widget()\child()\child(), iii,iii+sss, 50,50)
    ;           ;AddWidget(widget()\child()\child(), iii+sss,iii+sss, 50,50)
    ;           
    ;           If ListIndex(widget()\child()\child()) = 0
    ;             For iiii=0 To count Step 5
    ;               If iiii = 0
    ;                 ssss = 0
    ;               ElseIf i = 1
    ;                 ssss = 50
    ;               Else
    ;                 ssss + 20
    ;               EndIf
    ;               AddWidget(widget()\child()\child(), widget()\child()\child()\child(), iiii+ssss,iiii+ssss, 50,50)
    ;               
    ;             Next
    ;           EndIf
    ;           
    ;         Next
    ;       EndIf
  Next
EndIf
;   


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
Procedure Enumerate( *this.widget )
  If *this\address
    Debug "widget - "+ *this\x +" "+ *this\y +" "+ *this\width +" "+ *this\height
    
    If *this\count\childrens
      ForEach widget( )
        If widget( )\draw 
          Enumerate( widget( ) )
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

;Debug GetAtPointWidget( widget( ), mx,my )


Debug ElapsedMilliseconds() - time

; *first.widget = FirstElement(*root1\child())
; ;ResizeWidget(*first, 100,10,10,150)
; ;FreeWidget( *first )
; ;FreeWidget( *root1 )
; 
; *first.widget = FirstElement(*root2\child())
; ;ResizeWidget(*first, 100,10,10,150)


;Enumerate( *root1 )
ReDrawWidget( *root1 )
;
ReDrawWidget( *root2 )

Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_MouseEnter
      Root( ) = GetGadgetData( EventGadget( ) )
    EndIf
    
    If EventType() = #PB_EventType_MouseMove
      If Root( )
        ;Define time = ElapsedMilliseconds()
        *widget.widget = GetAtPointWidget( GetGadgetAttribute( EventGadget( ), #PB_Canvas_MouseX ), GetGadgetAttribute( EventGadget( ), #PB_Canvas_MouseY ) )
        ; Debug ElapsedMilliseconds() - time
        
        If *widget
          Debug ""+*widget+" "+*widget\count\parents
          
          ReDrawWidget( *widget )
          
        EndIf
      EndIf
    EndIf
  EndIf
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------
; EnableXP