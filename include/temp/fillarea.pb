; https://www.purebasic.fr/english/viewtopic.php?f=13&t=78061

Enumeration
	#Window
	#Gadget
	#Slider
	#Image
EndEnumeration

Structure Vector
	X.i
	Y.i
EndStructure

; Calculate the distance between two colors. This value is between 0.0 and 441.67
Procedure.f ColorDistance(Color1.l, Color2.l)

	Protected dR.i = Abs(Red(Color1)-Red(Color2))
	Protected dG.i = Abs(Green(Color1)-Green(Color2))
	Protected dB.i = Abs(Blue(Color1)-Blue(Color2))

	ProcedureReturn Sqr(dR*dR + dG*dG + dB*dB)

EndProcedure

; Mix two colors with a linear interpolation. color = color1*(1-factor) + color2*factor
Procedure.l ColorMix(Color1.l, Color2.l, Factor.f)

	Protected R.i = Red(Color1)*(1-Factor) + Red(Color2)*Factor
	Protected G.i = Green(Color1)*(1-Factor) + Green(Color2)*Factor
	Protected B.i = Blue(Color1)*(1-Factor) + Blue(Color2)*Factor

	ProcedureReturn RGB(R, G, B)

EndProcedure

; Perform a smooth filling of area (x,y) with color FillColor using the max color distance MaxColorDistance
Procedure SmoothFillArea(X.i, Y.i, FillColor.l, MaxColorDistance.f)

	Protected Dim Filled.i(OutputWidth()-1, OutputHeight()-1)
	Protected NewList Seeds.Vector()
	Protected Factor.f
	Protected SeedColor.l = Point(X, Y)

	AddElement(Seeds()) : Seeds()\X = X : Seeds()\Y = Y : Filled(X, Y) = #True

	ResetList(Seeds())
	While NextElement(Seeds())
		*Seed.Vector = @Seeds()
		With *Seed
			If MaxColorDistance = 0
				Factor = Bool(ColorDistance(Point(\X, Seeds()\Y), SeedColor) <> 0.0)
			Else
				Factor = ColorDistance(Point(\X, Seeds()\Y), SeedColor) / MaxColorDistance
			EndIf
			If Factor < 1.0
				Plot(\X, \Y, ColorMix(FillColor, Point(\X, \Y), Factor*Factor))
				If \X > 0 And Filled(\X-1, \Y) = #False
					AddElement(Seeds()) : Seeds()\X = \X-1 : Seeds()\Y = \Y : Filled(\X-1, \Y) = #True
				EndIf
				If \X < OutputWidth()-1 And Filled(\X+1, \Y) = #False
					AddElement(Seeds()) : Seeds()\X = \X+1 : Seeds()\Y = \Y : Filled(\X+1, \Y) = #True
				EndIf
				If \Y > 0 And Filled(\X, \Y-1) = #False
					AddElement(Seeds()) : Seeds()\X = \X : Seeds()\Y = \Y-1 : Filled(\X, \Y-1) = #True
				EndIf
				If \Y < OutputHeight()-1 And Filled(\X, \Y+1) = #False
					AddElement(Seeds()) : Seeds()\X = \X : Seeds()\Y = \Y+1 : Filled(\X, \Y+1) = #True
				EndIf
				ChangeCurrentElement(Seeds(), *Seed)
			EndIf
		EndWith
	Wend

EndProcedure


;- Example

InitNetwork()

UsePNGImageDecoder()

CatchImage(#Image, ReceiveHTTPMemory("https://i.ibb.co/WP4XVGd/cat3.png"))

width=ImageWidth(#Image)
height=ImageHeight(#Image)

OpenWindow(#Window,0,0,width,height+30,"Smooth Fill Area",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CanvasGadget(#Gadget,0,0,width,height)
TrackBarGadget(#Slider,0,height,width,30,0,440)

If StartDrawing(CanvasOutput(#Gadget))
	DrawImage(ImageID(#Image), 0, 0)
	StopDrawing()
EndIf

Define FillColor.l = $FFB040       ; Filling color
Define MaxColorDistance.f = 400.0  ; Max distance of the colors: 0.0 until 441.67
; 0.0 meens only exacly same pixel color. Value over 441.67 fills all pixels

SetGadgetState(#Slider,MaxColorDistance)

Repeat
	Select WaitWindowEvent()
	Case #PB_Event_CloseWindow
		Break
	Case #PB_Event_Gadget
		Select EventGadget()
		Case #Slider
			MaxColorDistance=GetGadgetState(#Slider)
			SetWindowTitle(#Window,"Distance = "+Str(MaxColorDistance))
		Case #Gadget
			Select EventType()
			Case #PB_EventType_LeftClick
				If StartDrawing(CanvasOutput(#Gadget))
					SmoothFillArea(GetGadgetAttribute(#Gadget, #PB_Canvas_MouseX), GetGadgetAttribute(#Gadget, #PB_Canvas_MouseY), FillColor, MaxColorDistance)
					StopDrawing()
				EndIf
			EndSelect
		EndSelect
	EndSelect
ForEver

End
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP