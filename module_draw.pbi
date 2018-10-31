DeclareModule Draw
  EnableExplicit
  Global DrawingMode = #PB_2DDrawing_Default
  
  Declare.i _Point(X,Y)
  Declare.i _DrawingFont(FontID.i)
  Declare.i _SetOrigin(X,Y)
  Declare.i _OutputWidth()
  Declare.i _OutputHeight()
  Declare.i _StopDrawing()
  Declare.i _DrawingMode(Mode.i)
  Declare.i _FrontColor(Color.i)
  Declare.i _BackColor(Color.i)
  Declare.i _TextWidth(Text.s)
  Declare.i _TextHeight(Text.s)
  Declare.i _ImageOutput(Image.i)
  Declare.i _CanvasOutput(Gadget)
  Declare.i _StartDrawing(Output.i)
  Declare.i _Circle(X.d,Y.d,Radius.d, Color.i)
  Declare.i _Line(X.i,Y.i,Width.i,Height.i, Color.i)
  Declare.i _Box(X.i,Y.i,Width.i,Height.i, Color.i)
  Declare.i _RoundBox(X.i,Y.i,Width.i,Height.i, RoundX.i, RoundY.i, Color.i)
  Declare.i _ClipOutput(X.i,Y.i,Width.i,Height.i)
  Declare.i _DrawText(X.i,Y.i,Text.s, FontColor=$FFFFFFFF, BackColor=0)
  Declare.i _DrawRotatedText(X.i,Y.i,Text.s, Angle.f, FontColor.i=$FFFFFFFF)
  Declare.i _LinearGradient(X1.d,Y1.d, X2.d,Y2.d)
  Declare.i _UnclipOutput()
  Declare.i _DrawImage(ImageID.i, X.i,Y.i,Width.i,Height.i)
  Declare.i _DrawAlphaImage(ImageID.i, X.d,Y.d, Alpha.i, Width.d=0,Height.d=0)
  
  ; Демонстрация подмени функции PB
  Macro LinearGradient(X1,Y1, X2,Y2) : _LinearGradient(X1,Y1, X2,Y2) : EndMacro
  Macro DrawingFont(FontID) : _DrawingFont(FontID) : EndMacro
  Macro FrontColor(Color) : _FrontColor(Color) : EndMacro
  Macro BackColor(Color) : _BackColor(Color) : EndMacro
  Macro UnclipOutput () : _UnclipOutput() : EndMacro
  Macro Point (X,Y) : _Point(X,Y) : EndMacro
  Macro StopDrawing () : _StopDrawing() : EndMacro
  Macro OutputWidth () : _OutputWidth() : EndMacro
  Macro OutputHeight () : _OutputHeight() : EndMacro
  Macro SetOrigin (X,Y) : _SetOrigin(X,Y) : EndMacro
  Macro TextWidth (Text) : _TextWidth(Text) : EndMacro
  Macro TextHeight (Text) : _TextHeight(Text) : EndMacro
  Macro DrawingMode (Mode) : _DrawingMode(Mode) : EndMacro
  Macro ImageOutput (Image) : _ImageOutput(Image) : EndMacro
  Macro CanvasOutput (Gadget) : _CanvasOutput(Gadget) : EndMacro
  Macro StartDrawing (Output) : _StartDrawing(Output) : EndMacro
  Macro Circle (X,Y,Radius, Color) : _Circle(X,Y,Radius, Color) : EndMacro
  Macro ClipOutput (X,Y,Width,Height) : _ClipOutput(X,Y,Width,Height) : EndMacro
  Macro DrawImage (ImageID, X,Y,Width,Height) : _DrawImage(ImageID, X,Y,Width,Height) : EndMacro
  Macro DrawAlphaImage (ImageID, X,Y, Alpha,Width=0,Height=0) : _DrawAlphaImage(ImageID, X,Y, Alpha,Width,Height) : EndMacro
  Macro Box (X,Y,Width,Height, Color=0) : _Box(X,Y,Width,Height, Color) : EndMacro
  Macro Line (X,Y,Width,Height, Color=0) : _Line(X,Y,Width,Height, Color) : EndMacro
  Macro RoundBox (X,Y,Width,Height, RoundX,RoundY, Color=0) : _RoundBox(X,Y,Width,Height, RoundX,RoundY, Color) : EndMacro
  Macro DrawText (X,Y,Text, FontColor=$FFFFFF, BackColor=0) : _DrawText(X,Y,Text, FontColor, BackColor) : EndMacro
  Macro DrawRotatedText (X,Y,Text, Angle, FontColor=$FFFFFF) : _DrawRotatedText(X,Y,Text, Angle, FontColor) : EndMacro
  
EndDeclareModule

Module Draw
  Global Clip
  
  Procedure AddPathRoundBox(x.d,y.d,Width.d,Height.d,radius.d, RoundY.d, flags=#PB_Path_Default)
    MovePathCursor(x+radius,y,flags)
    Protected i=radius
    If i%2
      Protected xx=2
    ; ProcedureReturn
    EndIf
    
;     AddPathArc(Width+radius,0,Width+radius,radius,radius,#PB_Path_Relative)
;     AddPathArc(radius,Height-radius,radius,Height-radius,radius,#PB_Path_Relative)
;     AddPathArc(-(Width+radius),0,-(Width-radius),-radius,radius,#PB_Path_Relative)
;     AddPathArc(0,-(Height-radius),radius,-(Height-radius),radius,#PB_Path_Relative)
    
    AddPathArc(Width-radius-2,0,Width-radius-2,radius,radius,#PB_Path_Relative)
    AddPathArc(0,Height-radius,-radius,Height-radius,radius,#PB_Path_Relative)
    AddPathArc(-(Width-radius-2),0,-(Width-radius-2),-radius,radius,#PB_Path_Relative)
    AddPathArc(0,-(Height-radius),radius,-(Height-radius),radius,#PB_Path_Relative)
    ClosePath()
  EndProcedure
  
  Procedure.i _DrawAlphaImage(ImageID.i, X.d,Y.d, Alpha.i, Width.d=0,Height.d=0)
    MovePathCursor(X,Y) 
    VectorSourceImage(ImageID, Alpha, Width,Height, #PB_VectorImage_Repeat)
  EndProcedure
  
  Procedure.i _DrawImage(ImageID.i, X.i,Y.i,Width.i,Height.i)
    MovePathCursor(X,Y) 
    VectorSourceImage(ImageID, 255, Width,Height, #PB_VectorImage_Repeat)
  EndProcedure
  
  Procedure.i _Point(X.i,Y.i)
    ProcedureReturn ;VectorTextWidth(Text.s)
  EndProcedure
  
  Procedure.i _SetOrigin(X.i,Y.i)
    ProcedureReturn ;VectorTextWidth(Text.s)
  EndProcedure
  
  Procedure.i _UnclipOutput()
    ProcedureReturn _ClipOutput(0,0,VectorOutputWidth(), VectorOutputHeight())
  EndProcedure
  
  Procedure.i _TextWidth(Text.s)
    ProcedureReturn VectorTextWidth(Text.s)
  EndProcedure
  
  Procedure.i _TextHeight(Text.s)
    ProcedureReturn VectorTextHeight(Text.s) + 2
  EndProcedure
  
  Procedure.i _OutputHeight()
    ProcedureReturn VectorOutputHeight()
  EndProcedure
  
  Procedure.i _OutputWidth()
    ProcedureReturn VectorOutputWidth()
  EndProcedure
  
  Procedure.i _DrawingMode(Mode.i)
    DrawingMode = Mode
  EndProcedure
  
  Procedure.i _FrontColor(Color.i)
    ; VectorSourceColor(Color)
  EndProcedure
  
  Procedure.i _BackColor(Color.i)
    ;BackColor(Color.i)
  EndProcedure
  
  Procedure.i _StartDrawing(Output.i)
    If Output
      ProcedureReturn StartVectorDrawing(Output)
    EndIf
  EndProcedure
  
  Procedure.i _CanvasOutput(Gadget.i)
    ProcedureReturn CanvasVectorOutput(Gadget)
  EndProcedure
  
  Procedure.i _DrawingFont(FontID.i)
    If FontID
      ProcedureReturn VectorFont(FontID)
    EndIf
  EndProcedure
  
  Procedure.i _ImageOutput(Image.i)
    ProcedureReturn ImageVectorOutput(Image)
  EndProcedure
  
  Procedure.i _StopDrawing()
    Clip = 0
    ProcedureReturn StopVectorDrawing()
  EndProcedure
  
  Procedure.i _ClipOutput(X.i,Y.i,Width.i,Height.i)
    If Not Clip : Clip = 1
      SaveVectorState()
    Else
      RestoreVectorState()
      SaveVectorState()
    EndIf
    
    AddPathBox(X,Y,Width,Height) 
    ClipPath()
  EndProcedure
  
  Procedure.i _Circle(X.d,Y.d,Radius.d, Color.i)
    VectorSourceColor(Color)
    AddPathCircle(X,Y,Radius) 
    
    If DrawingMode = #PB_2DDrawing_Outlined
      StrokePath(1, #PB_Path_SquareEnd)
    Else
      FillPath()
    EndIf
    
    ClosePath()
  EndProcedure
  
  Procedure.i _RoundBox(X.i,Y.i,Width.i,Height.i, RoundX.i,RoundY.i, Color.i)
    VectorSourceColor(Color)
    ;AddPathRoundBox(X+Bool(Not RoundX)-1,Y+1,Width-Bool(Not RoundX)*2,Height-2, RoundX,RoundY)
    AddPathRoundBox(X+1,Y+1,Width,Height-2, RoundX,RoundY)
    
    If DrawingMode = #PB_2DDrawing_Outlined
      StrokePath(1, #PB_Path_SquareEnd)
    Else
      FillPath()
    EndIf
    
    ClosePath()
  EndProcedure
  
  Procedure.i _Box(X.i,Y.i,Width.i,Height.i, Color.i)
    VectorSourceColor(Color)
    
    If DrawingMode = #PB_2DDrawing_Outlined
      AddPathBox(X+1,Y+1,Width-2,Height-2)
      StrokePath(1, #PB_Path_SquareEnd)
    Else
      AddPathBox(X,Y,Width,Height)
      FillPath()
    EndIf
    
    ClosePath()
  EndProcedure
  
  Procedure.i _Line(X.i,Y.i,Width.i,Height.i, Color.i)
    VectorSourceColor(Color)
    
    If DrawingMode = #PB_2DDrawing_Outlined
      AddPathLine(X+1,Y+1)
      StrokePath(1, #PB_Path_SquareEnd)
    Else
      AddPathLine(X,Y)
      FillPath()
    EndIf
    
    ClosePath()
  EndProcedure
  
  Procedure.i _LinearGradient(X1.d,Y1.d, X2.d,Y2.d)
    VectorSourceLinearGradient(x1, y1, x2, y2)
  EndProcedure
  
  Procedure.i _DrawText(X.i,Y.i,Text.s, FontColor.i=$FFFFFFFF, BackColor.i=0)
    MovePathCursor(X,Y) 
    VectorSourceColor(FontColor)
    DrawVectorText(Text.s)
  EndProcedure
  
  Procedure.i _DrawRotatedText(X.i,Y.i,Text.s, Angle.f, FontColor.i=$FFFFFFFF)
    MovePathCursor(X,Y) 
    VectorSourceColor(FontColor)
    DrawVectorText(Text.s)
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
  UseModule Draw
  
  If OpenWindow(0, 0, 0, 200, 200, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(16, 0, 0, 400, 200)
    x=50
    w = 100
    If StartDrawing(CanvasOutput(16))
      DrawingFont(GetGadgetFont(-1))
      
      ClipOutput(x, 10, w, 20) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,10+(20-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      RoundBox(x, 10, w, 20, 15,10,$FF000000)
      
      ClipOutput(x, 50, w, 20) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,50+(20-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      RoundBox(x, 50, w, 20, 8,8, $FF000000)
      
      ClipOutput(x, 90, w, 20) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,90+(20-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      RoundBox(x, 90, w, 20, 7,7, $FF000000)
      
      ClipOutput(x, 130, w, 20) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,130+(20-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      RoundBox(x, 130, w, 20, 0,0, $FF000000)
      
      UnclipOutput()
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x-3, 10-3, w+6, 146, $FF000000)
      
      StopDrawing() 
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  If OpenWindow(0, 0, 0, 200, 200, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(16, 0, 0, 400, 200)
    
    If StartDrawing(CanvasOutput(16))
      ClipOutput(50, 50, 100, 100) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Default)
      Circle( 50,  50, 50, $FF0000FF)  
      Circle( 50, 150, 50, $Ff00FF00)  
      Circle(150,  50, 50, $FFFF0000)  
      Circle(150, 150, 50, $FF00FFFF)  
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40,50+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(50, 50, 100, 100, $FF000000)
      
      StopDrawing() 
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ------------
; EnableXP