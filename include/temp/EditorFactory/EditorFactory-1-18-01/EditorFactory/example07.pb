XIncludeFile "EditorFactory.pbi"
UseModule EditorFactory

Enumeration 1
	#Window
	#Gadget_Canvas
	#Gadget_Toggle
EndEnumeration

Enumeration 1
	#Object1
	#Object2
EndEnumeration

; Custon drawing callback to draw the object with the image
Runtime Procedure MyDrawing(Object.i, Width.i, Height.i, iData.i)
	MovePathCursor(0, 0)
	DrawVectorImage(ImageID(GetObjectData(Object))) ; The image is stored in object data.
	AddPathBox(0.5, 0.5, Width-1, Height-1)
	VectorSourceColor($80000000)
	StrokePath(1)
EndProcedure

OpenWindow(#Window, 0, 0, 800, 450, "Draw on objects", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
CanvasGadget(#Gadget_Canvas, 0, 30, WindowWidth(#Window), WindowHeight(#Window)-30, #PB_Canvas_Keyboard)
ButtonGadget(#Gadget_Toggle, 0, 0, 800, 30, "Paint on objects (off) or move/resize objects (on/pushed)", #PB_Button_Toggle)

InitializeCanvasObjects(#Gadget_Canvas, #Window)
SetCursorSelectionStyle(#Gadget_Canvas, #SelectionStyle_Solid) 

; Create two objects with painting images and drawing callbacks:
CreateObject(#Gadget_Canvas, #Object1, 20, 20, 200, 100)
CreateObject(#Gadget_Canvas, #Object2, 320, 20, 200, 100)
SetObjectData(#Object1, CreateImage(#PB_Any, 200, 100, 32, #PB_Image_Transparent))
SetObjectData(#Object2, CreateImage(#PB_Any, 200, 100, 32, #PB_Image_Transparent))

SetObjectDrawingCallback(#Object1, "MyDrawing()")
SetObjectDrawingCallback(#Object2, "MyDrawing()")

Repeat
	
	Select WaitWindowEvent()
		Case #PB_Event_CloseWindow
			Break
		Case #PB_Event_Gadget
			Select EventGadget()
				Case #Gadget_Canvas
					Select EventType()
						Case #PB_EventType_MouseMove
							; Draw on the images of the object when Toggle botton is of, mouse was mouved and pusehd.
							If Not GetGadgetState(#Gadget_Toggle) And ExamineObjects(#Gadget_Canvas)
								Object = NextObject(#Gadget_Canvas)
								While Object
									If ObjectState(Object) & #State_LeftMousePushed
										If StartDrawing(ImageOutput(GetObjectData(Object))) ; Start drawing ob the object image stored in object data.
											DrawingMode(#PB_2DDrawing_AlphaBlend)
											X = GetGadgetAttribute(#Gadget_Canvas, #PB_Canvas_MouseX) - GetObjectX(Object) ; Local position
											Y = GetGadgetAttribute(#Gadget_Canvas, #PB_Canvas_MouseY) - GetObjectY(Object) ; Local position
											Circle(X, Y, 2, RGBA(0, 64, 255, 255))
											StopDrawing()
										EndIf
										ShowObject(Object) ; Trigger a repaint on the canvas gadget.
									EndIf
									Object = NextObject(#Gadget_Canvas)
								Wend
							EndIf
					EndSelect
				Case #Gadget_Toggle ; Painting or object handels
					If GetGadgetState(#Gadget_Toggle)
						AddObjectHandle(#Object1, #Handle_Size | #Handle_Position)
						AddObjectHandle(#Object2, #Handle_Size | #Handle_Position)
					Else
						RemoveObjectHandle(#Object1, #Handle_Size | #Handle_Position)
						RemoveObjectHandle(#Object2, #Handle_Size | #Handle_Position)
					EndIf
			EndSelect
	EndSelect
	
	; Event loop for the objects in the canvas gadget
	Repeat
		Select CanvasObjectsEvent(#Gadget_Canvas)
			Case #Event_Object
				Select CanvasObjectsEventType(#Gadget_Canvas)
					Case #EventType_Resized ; The object was resized, so the image have to be resize as well
						Object = EventObject(#Gadget_Canvas)
						SetObjectData(Object, GrabImage(GetObjectData(Object), #PB_Any, 0, 0, GetObjectWidth(Object), GetObjectHeight(Object)))
				EndSelect
			Case #Event_None
				Break
		EndSelect
	ForEver

ForEver

End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = --
; EnableXP