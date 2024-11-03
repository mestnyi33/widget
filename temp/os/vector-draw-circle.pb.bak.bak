OpenWindow(0, 0, 0, 800, 600, "VectorDrawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 800, 600)

UseJPEGImageDecoder()
LoadImage(0, #PB_Compiler_Home + "/Examples/3D/Data/Textures/dirt.jpg")  

StartVectorDrawing(CanvasVectorOutput(0))

For i=0 To 20
	AddPathCircle(Random(800), Random(600),Random(200))
	VectorSourceImage(ImageID(0), 255, ImageWidth(0), ImageHeight(0), #PB_VectorImage_Repeat)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor($77000000|Random($ffffff))
	FillPath()
Next

StopVectorDrawing()

Repeat
	Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; EnableXP