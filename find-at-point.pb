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

Procedure Add(x,y,width,height)
  AddElement(widget())
  widget()\x = x
  widget()\y = y
  widget()\width = width
  widget()\height = height
EndProcedure

Define count = 1000000
count * 4
#st = 1
Define mx=#st,my=#st

For i=0 To count Step 5
  Add(i,i, 50,50)
Next

i=0
ForEach widget()
  i+1;Debug ""+widget()\x +" "+ widget()\y +" "+ widget()\width +" "+ widget()\height
Next
Debug i

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