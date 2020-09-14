XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure Points(Steps = 5, line=0, Color = 0)
  Static ID
  Protected hDC, x,y
  
  If Not ID
    ;Steps - 1
    
    ExamineDesktops()
    Protected width = DesktopWidth(0)   
    Protected height = DesktopHeight(0)
    ID = CreateImage(#PB_Any, width, height, 32, #PB_Image_Transparent)
    
    If Color = 0 : Color = $ff808080 : EndIf
    
    If StartDrawing(ImageOutput(ID))
      DrawingMode(#PB_2DDrawing_AllChannels)
      ;Box(0, 0, width, height, BoxColor)
      
      For x = 0 To width - 1
        
        For y = 0 To height - 1
          
          If line
            Line(x, 0, 1,height, Color)
            Line(0, y, width,1, Color)
          Else
            Line(x, y, 1,1, Color)
          EndIf
          
          y + Steps
        Next
        
        
        x + Steps
      Next
      
      StopDrawing()
    EndIf
  EndIf
  
  ProcedureReturn ID
EndProcedure

Define *new

Open(OpenWindow(#PB_Any, 150, 150, 600, 500, "PB (window_1)", #__Window_SizeGadget | #__Window_SystemMenu))

Container(0,0,0,0, #__flag_autosize) : a_init(widget()) 

*new = Window(100, 100, 200, 200, "window_2", #__Window_SizeGadget | #__Window_SystemMenu, widget())
SetBackgroundImage(*new, Points(Mouse()\grid-1, 8, $FF000000)) ; $BDC5C6C6))

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = +
; EnableXP