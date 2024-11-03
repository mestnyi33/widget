
; Example01_Basics.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory


; --------- Example ---------


; Program constants
Enumeration 1
	#Window
	#Canvas
EndEnumeration

; Object constants starting from 1
Enumeration 1
	#Object1
EndEnumeration

; ----------------------------------------------

; Callback procedure to draw on the object
;   Object.i is the number of the object, you can use it to get properties of the currently drawn object
;   Width.i is the current width of the object
;   Height.i is the current height of the object
;   iData.i is a custom data value set in SetObjectDrawingCallback, here it is used as the color
; This procedure will automatically called during the draw of the Object
Procedure MyDrawing(Object.i, Width.i, Height.i, iData.i)
	AddPathBox(0.5, 0.5, Width-1, Height-1)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(1)
EndProcedure

; ----------------------------------------------

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

; Creates and adds an object to the specified canvas object. By default it is grey and hase no handles
CreateObject(#Canvas, #Object1, 20, 20, 200, 100)
Define Object.i = CreateObject(#Canvas, #PB_Any, 320, 20, 200, 100)
Define Child.i = CreateObject(#Canvas, #PB_Any, 20, 20, 100, 100, Object)

; Sets a custom drawing Procedure (As defined above) To the specified object. The last parameter is used As a color
SetObjectDrawingCallback(#Object1, @MyDrawing(), RGB(128, 192, 64))
SetObjectDrawingCallback(Object, @MyDrawing(), RGB(192, 64, 128))
SetObjectDrawingCallback(Child, @MyDrawing(), RGB(128, 192, 64))

; Add handles for resize and movement
AddObjectHandle(#Object1, #Handle_Size | #Handle_Position)
AddObjectHandle(Object, #Handle_Size | #Handle_Position)
AddObjectHandle(Child, #Handle_Size | #Handle_Position)



; The window's event loop
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
ForEver

End
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP
; EnableUser
; EnableOnError
; EnableCompileCount = 64
; EnableBuildCount = 0
; EnableExeConstant