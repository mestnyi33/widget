EnableExplicit

Declare Ev_MouseMove()
Declare Ev_Repaint()
Declare Ev_MousePan()
Declare Ev_MouseWheel()

Global.i Event
Global.d x_PosOrigin, y_PosOrigin, Zoom, Zoom_Factor, y_WscreenSize, x_WscreenSize

Zoom_Factor = 1.10 : Zoom = 1.0

;{ Evènements personnalisés
Enumeration #PB_Event_FirstCustomValue
   #Ev_Repaint
EndEnumeration
;}

;{ Structure Mouse/Curseur }
Structure Str_Mouse
   x_Wld.d                        ;// Coordonnée X monde avant "TranslateCoordinates"
   y_Wld.d                        ;// Coordonnée Y monde avant "TranslateCoordinates"
   
   x_CoordW.d                  ;// Coordonnée X monde
   y_CoordW.d                  ;// Coordonnée X monde
   
   x_PrW.d                        ;// Coordonnée X monde précédente
   y_PrW.d                        ;// Coordonnée Y monde précédente
   
   x_Can.l                        ;// Coordonnée Souris X sur le Canvas
   y_Can.l                        ;// Coordonnée Souris Y sur le Canvas
   
   Move.b                        ;// La souris se déplace
   Pan.b                           ;// Déplacement panoramique
   Wheel.b                        ;// Molette Souris
EndStructure

;Init Structure
Global Mouse.Str_Mouse
;}

Procedure Ev_MouseMove()
   Mouse\x_Can = GetGadgetAttribute(0, #PB_Canvas_MouseX)
   Mouse\y_Can = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   Mouse\Move ! 1
   PostEvent(#Ev_Repaint)
EndProcedure

Procedure Ev_MousePan()
   Mouse\Pan ! 1 ; inverse la valeur 0|1
EndProcedure

Procedure Ev_MouseWheel()
   Mouse\Wheel ! 1
   Select GetGadgetAttribute(0, #PB_Canvas_WheelDelta)
      Case 1
         ;Debug "in"
         Zoom =  Zoom * Zoom_Factor
      Case -1
         ;Debug "out"
         Zoom = Zoom / Zoom_Factor   
   EndSelect
   PostEvent(#Ev_Repaint)
EndProcedure

Procedure Ev_Repaint()
   ;Debug "Repaint"
   If StartVectorDrawing(CanvasVectorOutput(0, #PB_Unit_Millimeter))
     
      VectorFont(FontID(0), 3)
     
      FlipCoordinatesY(y_WscreenSize / 2, #PB_Coordinate_User) ; 0,0 en bas à gauche
      ScaleCoordinates(Zoom, Zoom, #PB_Coordinate_User)
     
      If Mouse\Move And Not Mouse\Pan
         ;Debug "Move"
         Mouse\Move ! 1
         Mouse\x_Wld = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_Wld = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         TranslateCoordinates(x_PosOrigin, y_PosOrigin, #PB_Coordinate_User)
         Mouse\x_CoordW = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_CoordW = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
      ElseIf Mouse\Move And Mouse\Pan
         ;Debug "Move et Pan"
         Mouse\Move ! 1
         Mouse\x_PrW = Mouse\x_Wld
         Mouse\y_PrW = Mouse\y_Wld
         Mouse\x_Wld = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_Wld = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         x_PosOrigin = x_PosOrigin + Mouse\x_Wld - Mouse\x_PrW
         y_PosOrigin = y_PosOrigin + Mouse\y_Wld - Mouse\y_PrW
         TranslateCoordinates(x_PosOrigin, y_PosOrigin, #PB_Coordinate_User)
         Mouse\x_CoordW = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_CoordW = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
      ElseIf Mouse\Wheel
         ;Debug "Wheel"
         Mouse\x_PrW = Mouse\x_Wld
         Mouse\y_PrW = Mouse\y_Wld
         Mouse\x_Wld = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_Wld = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         x_PosOrigin = x_PosOrigin  +  Mouse\x_Wld - Mouse\x_PrW
         y_PosOrigin = y_PosOrigin  +    Mouse\y_Wld - Mouse\y_PrW
         TranslateCoordinates(x_PosOrigin, y_PosOrigin, #PB_Coordinate_User)
         Mouse\x_CoordW = ConvertCoordinateX(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
         Mouse\y_CoordW = ConvertCoordinateY(Mouse\x_Can, Mouse\y_Can, #PB_Coordinate_Device, #PB_Coordinate_User)
      EndIf
     
      If Mouse\Pan Or Mouse\Wheel
         ;Debug "draw"
         Mouse\Wheel ! 1
         VectorSourceColor(RGBA(80, 80, 80, 255)) : FillVectorOutput()
         
         AddPathBox(0, 0, x_WscreenSize, y_WscreenSize)
         VectorSourceColor(RGBA(255,0,0,255))
         StrokePath(0.2)
         
         VectorSourceColor(RGBA(255,255,0,255))
         AddPathCircle(0, 0, 1)
         StrokePath(0.5)
         
         MovePathCursor(-4, 5)
         SaveVectorState()
            FlipCoordinatesY(y_WscreenSize / 2, #PB_Coordinate_User)
            AddPathText("Origin")
         RestoreVectorState()
         FillPath()
         
         MovePathCursor(15, 45)
         SaveVectorState()
            FlipCoordinatesY(y_WscreenSize / 2, #PB_Coordinate_User)
            DrawVectorImage(ImageID(0), 255)
         RestoreVectorState()
      EndIf
     
      StopVectorDrawing()
   EndIf
   StatusBarText(0, 0, "World Coord.: " + StrF(Mouse\x_CoordW, 2) + ", " + StrF(Mouse\y_CoordW, 2))
   StatusBarText(0, 1, "Screen Coord.: " + Str(Mouse\x_Can) + ", " + Str(Mouse\y_Can))
EndProcedure

If OpenWindow(0,0,0,500,300,"Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   CanvasGadget(0,0,0,500,277, #PB_Canvas_Keyboard )
   CreateStatusBar(0,WindowID(0))
   
   AddStatusBarField(200)
   AddStatusBarField(200)
   
   LoadFont(0, "Calibri", 20, #PB_Font_Italic)
   LoadImage(0, #PB_Compiler_Home + "examples/Sources/Data/PureBasicLogo.bmp")
   
   BindGadgetEvent(0,    @Ev_MouseWheel(),    #PB_EventType_MouseWheel)
   BindGadgetEvent(0,    @Ev_MouseMove(),       #PB_EventType_MouseMove)
   BindGadgetEvent(0,    @Ev_MousePan(),       #PB_EventType_MiddleButtonDown)
   BindGadgetEvent(0,    @Ev_MousePan(),       #PB_EventType_MiddleButtonUp)
   BindEvent(#Ev_Repaint, @Ev_Repaint())
   
   If StartVectorDrawing(CanvasVectorOutput(0, #PB_Unit_Millimeter))
      ; Init
      x_WscreenSize = VectorOutputWidth()
      y_WscreenSize = VectorOutputHeight()
      StopVectorDrawing()
   EndIf
   
   Mouse\Move = 1 : Mouse\Wheel = 1
   PostEvent(#Ev_Repaint)
   
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
   
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---
; EnableXP