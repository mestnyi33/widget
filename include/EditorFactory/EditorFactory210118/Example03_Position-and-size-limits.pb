
; Example03_ Position-and-size-limits.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory


; --------- Example ---------


; Program constants
Enumeration 1
	#Window
	#Canvas
	#Font
EndEnumeration

; Object constants startingh from 1
Enumeration 1
	#Object1
	#Object2
	#Object3
	#Object4
	#Object5
EndEnumeration

; ----------------------------------------------

; Callback procedure to draw on the object
;   Object.i is the number of the object, you can use it to get properties of the currently drawn object
;   Width.i is the current width of the object
;   Height.i is the current height of the object
;   iData.i is a custom data value set in SetObjectDrawingCallback, here it is used as the color
; This procedure will automatically called during the draw of the Object
Procedure MyDrawingObject(Object.i, Width.i, Height.i, iData.i)
	Protected String.s = PeekS(iData)
	AddPathBox(1.5, 1.5, Width-3, Height-3)
	VectorSourceColor($80C08040)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor($FFC08040)
	StrokePath(3, #PB_Path_RoundCorner)
	MovePathCursor(10, 10)
	VectorFont(FontID(#Font))
	DrawVectorText(String)
EndProcedure

; ----------------------------------------------

; Load a font
LoadFont(#Font, "Arial", 14)

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 3: Object boundaries to position and size", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

; Create five different objects
CreateObject(#Canvas, #Object1, 50, 50, 200, 100)
CreateObject(#Canvas, #Object2, 300, 50, 200, 100)
CreateObject(#Canvas, #Object3, 550, 50, 200, 100)
CreateObject(#Canvas, #Object4, 50, 250, 200, 100)
CreateObject(#Canvas, #Object5, 300, 250, 200, 100)

; Set the custom drawing procedures (as defined above) to the specified object. The last parameter is used as a string pointer
SetObjectDrawingCallback(#Object1, @MyDrawingObject(), @"Canvas boundaries")
SetObjectDrawingCallback(#Object2, @MyDrawingObject(), @"Boundary in X")
SetObjectDrawingCallback(#Object3, @MyDrawingObject(), @"Boundary in Y")
SetObjectDrawingCallback(#Object4, @MyDrawingObject(), @"Limit in width")
SetObjectDrawingCallback(#Object5, @MyDrawingObject(), @"Limit in height") 

; Define handles to all objects
AddObjectHandle(#Object1, #Handle_Size | #Handle_Position)
AddObjectHandle(#Object2, #Handle_Size | #Handle_Position)
AddObjectHandle(#Object3, #Handle_Size | #Handle_Position)
AddObjectHandle(#Object4, #Handle_Size | #Handle_Position)
AddObjectHandle(#Object5, #Handle_Size | #Handle_Position)

; Limits the position as well as the minimum and maximum size of the objects
SetObjectBoundaries(#Object1, 0, 0, #Boundary_ParentSize, #Boundary_ParentSize)
SetObjectBoundaries(#Object2, 250, #Boundary_Ignore, 550, #Boundary_Ignore)
SetObjectBoundaries(#Object3, #Boundary_Ignore, 50, #Boundary_Ignore, 200)
SetObjectBoundaries(#Object4, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, 150, #Boundary_Ignore, 250, #Boundary_Ignore)
SetObjectBoundaries(#Object5, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore,  50, #Boundary_Ignore, 150)


; The window's event loop and gadgets.
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
ForEver

End
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP
; EnableUser
; EnableOnError
; EnableCompileCount = 245
; EnableBuildCount = 0
; EnableExeConstant