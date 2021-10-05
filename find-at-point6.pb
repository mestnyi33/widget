Macro Atbox( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
  Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 And 
        _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
EndMacro

Macro Interrect( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
                 _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
  
  Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And 
       ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ) );And ((( _address_2_x_ + _address_2_width_ ) - ( _address_1_x_ + _address_1_width_ ) ) Or (( _address_2_y_ + _address_2_height_ ) - ( _address_1_y_ + _address_1_height_ ) )) )
EndMacro



Structure canvas
  window.i
  gadget.i
EndStructure

Structure widget
  *address
  *parent.widget
  *root.root
  
  x.i
  y.i
  width.i
  height.i
  
  draw.b
  childrens.b
  List child.widget()
EndStructure
Structure root Extends widget
  canvas.canvas
EndStructure

Global NewList widget.widget( )
Global NewList *draw.widget( )
Global *enter_widget.widget

;-
Macro root( )
  widget( )\root
EndMacro

Procedure GetAtPointWidget( List this.widget( ), mouse_x, mouse_y )
  Protected result
  
  If ListSize( this( ) )
    LastElement( this( ) )
    Repeat
      If Not ( this( )\parent And this( )\draw ) And Atbox( this( )\x, this( )\y, this( )\width, this( )\height, mouse_x, mouse_y )
        If this( )\childrens
          result = GetAtPointWidget( this( )\child( ), mouse_x, mouse_y )
        EndIf
        If result = 0
          result = this( )
        EndIf
        Break
      EndIf
    Until PreviousElement( this( ) ) = 0
  EndIf
  
  ProcedureReturn result
EndProcedure

Procedure SetParentWidget( *this.widget, *parent.widget )
  If *parent
    ;Debug *parent\width
    *parent\childrens + 1
    
    If *this\parent
      *this\parent\childrens - 1
    EndIf
    
    *this\root = *parent\root
    *this\parent = *parent
  EndIf
EndProcedure

Procedure ResizeWidget( *this.widget, x,y,width,height )
  If *this
    *this\x = x
    *this\y = y
    *this\width = width
    *this\height = height
    
    If *this\parent
      If *this\parent\parent
        *this\parent\draw = Interrect( 0, 0, *this\parent\parent\width, *this\parent\parent\height, *this\parent\x, *this\parent\y, *this\parent\width, *this\parent\height )
      EndIf
      If *this\parent\draw
        *this\draw = Interrect( 0, 0, *this\parent\width, *this\parent\height, *this\x, *this\y, *this\width, *this\height )
      EndIf
    Else
      ;If *this\root
        ; Debug "root - "+*this\root\width
      ;EndIf
     ;; *this\draw = Interrect( 0, 0, GadgetWidth(*this\root\canvas\gadget), GadgetHeight(*this\root\canvas\gadget), *this\x, *this\y, *this\width, *this\height )
      *this\draw = Interrect( 0, 0, *this\root\width, *this\root\height, *this\x, *this\y, *this\width, *this\height )
    EndIf
    
;     If *this\draw
;       AddElement(*draw())
;       *draw() = *this
;     EndIf
  EndIf
EndProcedure

Procedure AddWidget( *parent.widget, List this.widget( ), x,y,width,height)
  LastElement( this() )
  If AddElement( this( ) )
    SetParentWidget( this(), *parent )
    ResizeWidget( this(), x,y,width,height )
  EndIf
EndProcedure

Procedure DrawWidget( *this.widget, x, y )
  DrawingMode( #PB_2DDrawing_Outlined )
  Box( x+*this\x, y+*this\y, *this\width, *this\height, color )
  
  If *this\childrens
    ForEach *this\child( )
      If *this\child( )\draw 
        DrawWidget( *this\child( ), x+*this\x, y+*this\y )
      EndIf
    Next
  EndIf
EndProcedure


Procedure OpenWidget( window, gadget, x,y,width,height )
  Protected g, result = AddElement( widget( ) )
  
  If result
    g = CanvasGadget( gadget, x,y,width,height ) 
    If gadget =- 1 : gadget = g : EndIf
    root( ) = widget( );AllocateStructure( root )
    root( )\canvas\window = window
    root( )\canvas\gadget = gadget
    
    ResizeWidget( root(), x,y,width,height )
  EndIf
  
  ProcedureReturn result
EndProcedure

OpenWindow(0,100,100,500,500,"")

OpenWidget(0,1, 0,0,500,500)


Define count = 100;0000
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
  AddWidget(widget(), widget()\child(), i+s,i+s, 50,50)
  
  If ListIndex(widget()\child()) = 0
    For ii=0 To count ; Step 5
      If ii = 0
        ss = 0
      ElseIf i = 1
        ss = 50
      Else
        ss + 10
      EndIf
      AddWidget(widget()\child(), widget()\child()\child(), ii+ss,ii, 50,50)
      ;AddWidget(widget()\child(), ii+ss,ii+ss, 50,50)
      
      If ListIndex(widget()\child()\child()) = 0
        For iii=0 To count ; Step 5
          If iii = 0
            sss = 0
          ElseIf i = 1
            sss = 50
          Else
            sss + 15
          EndIf
          AddWidget(widget()\child()\child(), widget()\child()\child()\child(), iii,iii+sss, 50,50)
          ;AddWidget(widget()\child()\child(), iii+sss,iii+sss, 50,50)
          
          If ListIndex(widget()\child()\child()\child()) = 0
            For iiii=0 To count Step 5
              If iiii = 0
                ssss = 0
              ElseIf i = 1
                ssss = 50
              Else
                ssss + 20
              EndIf
              AddWidget(widget()\child()\child()\child(), widget()\child()\child()\child()\child(), iiii+ssss,iiii+ssss, 50,50)
              
            Next
          EndIf
          
        Next
      EndIf
    Next
  EndIf
Next


; i=0
; ForEach widget()
;   i+1;Debug ""+widget()\x +" "+ widget()\y +" "+ widget()\width +" "+ widget()\height
;   ForEach widget()\child()
;     i+1;Debug "  "+widget()\child()\x +" "+ widget()\child()\y +" "+ widget()\child()\width +" "+ widget()\child()\height
;     ForEach widget()\child()\child()
;       i+1;Debug "    "+widget()\child()\child()\x +" "+ widget()\child()\child()\y +" "+ widget()\child()\child()\width +" "+ widget()\child()\child()\height
;     Next
;   Next
; Next
; Debug i


;Debug GetAtPointWidget( widget( ), mx,my )


Debug ElapsedMilliseconds() - time

; ;*first.widget = FirstElement(widget())
; ;*first = *first\child()\child()
; ;ResizeWidget(*first, 100,10,10,150)
; StartDrawing(CanvasOutput(1))
; ; DrawWidget( *first, 0,0 )
; ; ForEach widget()
; ;   DrawWidget( widget(), 0,0 )
; ; Next
; ForEach *draw()
;   DrawWidget( *draw(), 0,0 )
; Next
; StopDrawing()
; 
; ; *first.widget = FirstElement(widget())
; ; ;*first = *first\child()\child()
; ; ResizeWidget(*first, 10,10,50,50)

Repeat 
  event = WaitWindowEvent( )
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_MouseMove
      ;Define time = ElapsedMilliseconds()
      *widget.widget = GetAtPointWidget( widget( ), GetGadgetAttribute( EventGadget( ), #PB_Canvas_MouseX ) ,GetGadgetAttribute( EventGadget( ), #PB_Canvas_MouseY ) )
     ; Debug ElapsedMilliseconds() - time
      
      If *widget
        Debug ""+*widget+" "+*widget\width +" "+ *widget\y 
        
        StartDrawing( CanvasOutput( 1 ) )
        FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
        DrawWidget( *widget, 0, 0 )
        StopDrawing( )
      EndIf
    EndIf
  EndIf
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------
; EnableXP