
; Example07_SaveAndLoad.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory


; --------- Example ---------


; Program constants
Enumeration 1
	#Window
	#Font
	#Canvas1
	#Canvas2
	#SaveButton1
	#LoadButton2
EndEnumeration

; Object constants starting from 1
Enumeration 1
	#Object1
EndEnumeration

; ----------------------------------------------

; Callback procedure to draw on the object.
Runtime Procedure MyDrawing(Object.i, Width.i, Height.i, iData.i)
	AddPathBox(0.5, 0.5, Width-1, Height-1)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	MovePathCursor(10, 10)
	VectorFont(FontID(#Font))
	DrawVectorText("Object #"+Str(Object))
	StrokePath(1)
EndProcedure

; ----------------------------------------------

; Load a font
LoadFont(#Font, "Arial", 14)

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 7: Save and load objects", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create canvas gadgets and some buttons
CanvasGadget(#Canvas1, 0, 0, WindowWidth(#Window)/2, WindowHeight(#Window)-30, #PB_Canvas_Keyboard|#PB_Canvas_Border)
CanvasGadget(#Canvas2, WindowWidth(#Window)/2, 0, WindowWidth(#Window)/2, WindowHeight(#Window)-30, #PB_Canvas_Keyboard|#PB_Canvas_Border)
ButtonGadget(#SaveButton1, 0, WindowHeight(#Window)-30, 200, 30, "Save selected objects")
ButtonGadget(#LoadButton2, WindowWidth(#Window)/2, WindowHeight(#Window)-30, 200, 30, "Load objects")

; Initializes the object management for the canvas gadgets
If (Not InitializeCanvasObjects(#Canvas1, #Window)) Or (Not InitializeCanvasObjects(#Canvas2, #Window))
	Debug "Unable to initialize the object manager !"    
EndIf
SetCursorSelectionStyle(#Canvas1, #SelectionStyle_Dashed)

; Creates and adds an object to the specified canvas object. By default it is grey and has no handles
CreateObject(#Canvas1, #Object1, 20, 20, 300, 100)
Define Object2.i = CreateObject(#Canvas1, #PB_Any, 20, 140, 300, 100)
Define Object3.i = CreateObject(#Canvas1, #PB_Any, 20, 260, 300, 100)
Define SubObject.i = CreateObject(#Canvas1, #PB_Any, 20, 40, 250, 50, #Object1)

; Sets a custom drawing procedure (as defined above) to the specified object. The last parameter is used as a color
SetObjectDrawingCallback(#Object1, "MyDrawing()", RGB(128, 192, 64))
SetObjectDrawingCallback(Object2, "MyDrawing()", RGB(192, 64, 128))
SetObjectDrawingCallback(Object3, "MyDrawing()", RGB(64, 128, 192))
SetObjectDrawingCallback(SubObject, "MyDrawing()", RGB(192, 128, 64))

; Add handles for resize and movement
AddObjectHandle(#Object_All, #Handle_Size | #Handle_Position)

Define FileName.s

; The window's event loop
Repeat
	
	Select WaitWindowEvent()
		
		Case #PB_Event_Gadget
			Select EventGadget()
				Case #SaveButton1
					FileName = SaveFileRequester("Save ...", "Objects.json", "JSON|*.json", 0)
					If FileName
						SaveObject(#Object_Selected, FileName, #Canvas1)  ; Save all selected objects from #Canvas1
					EndIf
				Case #LoadButton2
					FileName = OpenFileRequester("Load ...", "Objects.json", "JSON|*.json", 0)
					If FileName
						LoadObject(#Canvas2, #PB_Ignore, FileName)  ; Load objects into #Canvas2
					EndIf
			EndSelect
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
ForEver

End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = --
; EnableXP
; EnableCompileCount = 69
; EnableBuildCount = 0
; EnableExeConstant