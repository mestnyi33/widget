Macro Atbox( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
  Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 And 
        _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
EndMacro

Structure widget
  x.i
  y.i
  width.i
  height.i
  *parent.widget
EndStructure

Global NewList widget.widget( )

Procedure Add(*this.widget, x,y,width,height)
  *this\x = x
  *this\y = y
  *this\width = width
  *this\height = height
EndProcedure

Define count = 1000000
count * 3
 #st = 1
Define mx=#st,my=#st

For i=0 To count Step 5
  AddElement(widget())
  Add(widget(), i,i, 50,50)
Next

Define time = ElapsedMilliseconds()

LastElement( widget() )
Repeat
  If Atbox(widget()\x, widget()\y, widget()\width, widget()\height, mx,my)
    Debug "enter - " + ListIndex(widget())
    Break
  EndIf
Until PreviousElement(widget()) = 0

Debug ElapsedMilliseconds() - time
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP