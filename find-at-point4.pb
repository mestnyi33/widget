Macro Atbox( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
  Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 And 
        _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
EndMacro

Structure widget
  x.i
  y.i
  width.i
  height.i
  List child.widget()
EndStructure

Global NewList widget.widget( )

Macro add_widget(this, x_,y_,width_,height_)
  this\x = x_
  this\y = y_
  this\width = width_
  this\height = height_
EndMacro

Procedure Add(x,y,width,height)
  AddElement(widget())
  add_widget(widget(), x,y,width,height)
EndProcedure

Procedure added( count )
  Protected i
  For i=0 To count/2 ;Step #st
    Add(i,i, 50,50)
    If ListIndex(widget()) = 0
      PushListPosition(widget())
      Add(i-count/2,i-count/2, 50,50)
      AddElement(widget())
      add_widget(widget(), x,y,width,height)
      PopListPosition(widget())
    EndIf
  Next
EndProcedure

Define count = 1000000
#st = 1
Define mx=#st,my=#st

For i=0 To count Step 5
  AddElement(widget())
  add_widget(widget(), i,i, 50,50)
  
  If ListIndex(widget()) = 0
    For ii=0 To count Step 5
      AddElement(widget()\child())
      add_widget(widget()\child(), ii,ii, 50,50)
      
      If ListIndex(widget()\child()) = 0
        For iii=0 To count Step 5
          AddElement(widget()\child()\child())
          add_widget(widget()\child()\child(), iii,iii, 50,50)
          
            If ListIndex(widget()\child()\child()) = 0
        For iiii=0 To count Step 5
          ;PushListPosition(widget())
          AddElement(widget()\child()\child()\child())
          add_widget(widget()\child()\child()\child(), iiii,iiii, 50,50)
          ;PopListPosition(widget())
        Next
      EndIf
    
        Next
      EndIf
    Next
  EndIf
Next

i=0
ForEach widget()
  i+1;Debug ""+widget()\x +" "+ widget()\y +" "+ widget()\width +" "+ widget()\height
  ForEach widget()\child()
    i+1;Debug "  "+widget()\child()\x +" "+ widget()\child()\y +" "+ widget()\child()\width +" "+ widget()\child()\height
    ForEach widget()\child()\child()
      i+1;Debug "    "+widget()\child()\child()\x +" "+ widget()\child()\child()\y +" "+ widget()\child()\child()\width +" "+ widget()\child()\child()\height
      ForEach widget()\child()\child()\child()
      i+1;Debug "    "+widget()\child()\child()\x +" "+ widget()\child()\child()\y +" "+ widget()\child()\child()\width +" "+ widget()\child()\child()\height
    Next
  Next
  Next
Next
Debug i

Define time = ElapsedMilliseconds()


If ListSize( widget() )
  LastElement( widget() )
  Repeat
    If Atbox(widget()\x, widget()\y, widget()\width, widget()\height, mx,my)
      Debug "enter - " + ListIndex(widget())
      
      If ListSize( widget()\child() )
        LastElement( widget()\child() )
        Repeat
          If Atbox(widget()\child()\x, widget()\child()\y, widget()\child()\width, widget()\child()\height, mx,my)
            Debug "  enter - " + ListIndex(widget()\child())
            Break
          EndIf
        Until PreviousElement(widget()\child()) = 0
      EndIf
      
      Break
    EndIf
  Until PreviousElement(widget()) = 0
EndIf

Debug ElapsedMilliseconds() - time
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP