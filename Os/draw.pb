LoadFont(0, "Arial", 20)
  LoadFont(1, "Times New Roman", 14, #PB_Font_Italic)
  LoadFont(2, "Monotype Corsiva", 24)
 
  If OpenWindow(0, 0, 0, 500, 200, "VectorDrawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0, 0, 0, 500, 200)
    text$ = "ABCDefghIJK"
    
    If StartVectorDrawing(CanvasVectorOutput(0))      
      VectorFont(FontID(0), 120)
      h1.f = VectorTextHeight(Text$,#PB_VectorText_Visible)
      hb1.f = VectorTextHeight(Text$,#PB_VectorText_Baseline)
      scale1.f = hb1/h1
                
      VectorFont(FontID(1), 120)
      h2.f = VectorTextHeight(Text$,#PB_VectorText_Visible)
      hb2.f = VectorTextHeight(Text$,#PB_VectorText_Baseline)
      scale2.f = hb2/h2
     
      VectorFont(FontID(2), 120)
      h3.f = VectorTextHeight(Text$,#PB_VectorText_Visible)
      hb3.f = VectorTextHeight(Text$,#PB_VectorText_Baseline)
      scale3.f = hb3/h3
      StopVectorDrawing()
    EndIf
    
    If StartDrawing(CanvasOutput(0))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawingFont(FontID(0))
      x1.f = TextWidth(Text$)
      h1.f = TextHeight(Text$)
      DrawText(10 ,10 ,Text$,$0)
           
      DrawingFont(FontID(1))
      x2.f = TextWidth(Text$)
      h2.f = TextHeight(Text$)
      DrawText(12+x1,10 + h1*scale1 - h2*scale2 , Text$ , $00FF00)
     
      DrawingFont(FontID(2))
      x3.f = TextWidth(Text$)
      h3.f = TextHeight(Text$)
      DrawText(14+x1+x2,10 + h1*scale1- h3*scale3 , Text$ ,$0000FF)
      
      Line(10,10+h1*scale3,x1+x2+x3,1,$FF0000)      
      StopDrawing()
    EndIf
   
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP