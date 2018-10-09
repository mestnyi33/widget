DeclareModule Procedures
  
  Declare.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
  Declare.i DrawArrow(X.i,Y.i, Size.i, Direction.i, Color.i, Thickness.i = 1, Length.i = 1)
EndDeclareModule 

Module Procedures
  Procedure.i DrawArrow(X.i,Y.i, Size.i, Direction.i, Color.i, Thickness.i = 1, Length.i = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid : If (Value>Max) : Value=Max : EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.i _Draw(*This.Widget, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    With *This
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas <> \Canvas\Gadget
        ProcedureReturn
      EndIf
      
      If Not \Hide
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[2],\Y[2],\Width[2],\Height[2],\Color[1]\Fore,\Color[1]\Back,\Radius)
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          If \Text\Vertical
            Width = \Height[1]-\Text\X*2
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \Resize
            If \Text\MultiLine
              \Text\String.s[1] = Wrap(\Text\String.s, Width)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            ElseIf \Text\WordWrap
              \Text\String.s[1] = Wrap(\Text\String.s, Width, 1)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            Else
              ;  \Text\String.s[1] = Wrap(\Text\String.s, Width, 0)
              \Text\String.s[1] = \Text\String.s
              \Text\CountString = 1
            EndIf
            \Resize = #False
          EndIf
          
          If \Text\CountString
            If \Text\Align\Bottom
              Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
            ElseIf \Text\Align\Vertical
              Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
            EndIf
            
            ;;;ClipOutput(\X[2],\Y[2],\Width[2],\Height[2]) ; Bug in Mac os
            
            DrawingMode(#PB_2DDrawing_Transparent)
            If \Text\Vertical
              For IT = \Text\CountString To 1 Step - 1
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[1], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  Text_X=(Width-StringWidth)/2 
                EndIf
                
                ;                  DrawRotatedText(\X[1]+\Text\Y+Text_Y, \Y[1]+\Text\X+Text_X+StringWidth, String.s, 90, \Color\Front)
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Width) : Break : EndIf
              Next
            Else
              For IT = 1 To \Text\CountString
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[1], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  If Width > StringWidth
                    Text_X=(Width-StringWidth)/2
                  EndIf
                EndIf
                
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                ;DrawRotatedText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, 0, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
              Next
            EndIf
          EndIf
        EndIf
        
        
        ;         DrawingMode(\DrawingMode)
        ;         If \Width > \Text\X
        ;           BoxGradient(\Vertical,\X[1],\Y[1]+\Text\Y,\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Width[1]-\Text\X,\Y[1],\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;         If \Height > \Text\Y
        ;           BoxGradient(\Vertical,\X[1],\Y[1],\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Text\X,\Y[1]+\Height[1]-\Text\Y,\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;       
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1], \Radius, \Radius, \Color[1]\Frame)
        EndIf
        
      EndIf
    EndWith 
    
  EndProcedure
  
EndModule 

UseModule Procedures
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 225
; FirstLine = 92
; Folding = 8-0----
; EnableXP