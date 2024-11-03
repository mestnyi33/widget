If OpenWindow(0, 0, 0, 400, 200, "VectorDrawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 400, 200)    
   FontID = LoadFont(0, "Times New Roman", 60, #PB_Font_Bold)
   
   If StartVectorDrawing(CanvasVectorOutput(0))
      
      If StartDrawing(CanvasOutput(0))
         VectorFont(FontID)
         
         VectorSourceColor(RGBA(0, 0, 255, 128))
         MovePathCursor(50, 50)
         DrawVectorText("Test")
         
         SkewCoordinates(45, 0)
         
         VectorSourceColor(RGBA(255, 0, 0, 128))
         MovePathCursor(50, 50)
         DrawVectorText("Test")    
         
         StopDrawing()
      EndIf
      StopVectorDrawing()
   EndIf
   
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP