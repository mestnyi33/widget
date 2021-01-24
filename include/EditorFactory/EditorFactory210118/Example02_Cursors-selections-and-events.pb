
; Example02_Cursors-Selections-and-Events.pb

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
	AddPathBox(0.5, 0.5, Width-1, Height-1)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(1)
EndProcedure

; ----------------------------------------------

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Exemple 2: Multiple object, different handles, cursors and selection styles as well as event management", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

; Create five different objects
CreateObject(#Canvas, #Object1, 20, 20, 200, 100)
CreateObject(#Canvas, #Object2, 20, 140, 200, 100)
CreateObject(#Canvas, #Object3, 20, 260, 200, 100)
CreateObject(#Canvas, #Object4, 240, 20, 200, 100)
CreateObject(#Canvas, #Object5, 240, 140, 200, 100)

; Set the custom drawing procedures (as defined above) to the specified object. The last parameter is used as a color
SetObjectDrawingCallback(#Object1, @MyDrawingObject(), RGB(64, 128, 192))
SetObjectDrawingCallback(#Object2, @MyDrawingObject(), RGB(192, 64, 128))
SetObjectDrawingCallback(#Object3, @MyDrawingObject(), RGB(128, 192, 64))
SetObjectDrawingCallback(#Object4, @MyDrawingObject(), RGB(192, 128, 64))
SetObjectDrawingCallback(#Object5, @MyDrawingObject(), RGB(128, 64, 192))

; Define different handles to the objects
AddObjectHandle(#Object1, #Handle_Width | #Handle_Position)
AddObjectHandle(#Object2, #Handle_Height | #Handle_Position)
AddObjectHandle(#Object3, #Handle_Edge | #Handle_Position)
AddObjectHandle(#Object4, #Handle_Corner | #Handle_Position)
AddObjectHandle(#Object5, #Handle_Size | #Handle_Position)

; Define different cursors to the objects
SetObjectCursor(#Object1, #PB_Cursor_Default)
SetObjectCursor(#Object2, #PB_Cursor_Hand)
SetObjectCursor(#Object3, #PB_Cursor_Cross)
SetObjectCursor(#Object4, #PB_Cursor_Busy)
SetObjectCursor(#Object5, #PB_Cursor_Denied)


; Sets the selection frame style of the specified object.
SetObjectSelectionStyle(#Object1, #SelectionStyle_None, #SelectionStyle_None, 3)
SetObjectSelectionStyle(#Object2, #SelectionStyle_Dotted, RGBA(255, 0, 0, 255), 3)
SetObjectSelectionStyle(#Object3, #SelectionStyle_Dashed, RGBA(0, 255, 0, 255), 3)
SetObjectSelectionStyle(#Object4, #SelectionStyle_Solid, RGBA(192, 128, 64, 255), 3)
; Object 5 has no selection defined (None).

; Enables and customizes the mouse cursor selection to select objects on the canvas gadget,
; by default no selection with cursor frame is possible.
SetCursorSelectionStyle(#Canvas, #SelectionStyle_Solid, RGBA(0, 128, 255, 255), 1, RGBA(0, 128, 255, 50)) 


; The window's event loop
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_Gadget ; A Gadget type event.
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
	; Event loop of the objects in the canvas gadget
	Repeat
		
		Select CanvasObjectsEvent(#Canvas) ;  Something happened in the canvas.
				
			Case #Event_Object ; It is an object event
				
				Select CanvasObjectsEventType(#Canvas) ; What type of events happened on the object?
						
					Case #EventType_MouseEnter
						Debug "The mouse enters Object #" + EventObject(#Canvas)
					Case #EventType_MouseLeave
						Debug "The mouse leaves Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseBottonDown
						Debug "The left mouse button has been pressed on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseBottonUp
						Debug "The left mouse button has been released on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseClick
						Debug "A left click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseDoubleClick
						Debug "A double left mouse click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseBottonDown
						Debug "The middle mouse button has been pressed on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseBottonUp
						Debug "The middle mouse button has been released on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseClick
						Debug "A middle click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseDoubleClick
						Debug "A double middle click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseBottonDown
						Debug "The right mouse button has been pressed on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseBottonUp
						Debug "The right mouse button has been released on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseClick
						Debug "A right click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseDoubleClick
						Debug "A double right click happens on the Object #" + EventObject(#Canvas)
					Case #EventType_MouseWheel
						If CanvasObjectsEventData(#Canvas) > 0
							Debug "The mouse wheel has been turned up on the Object #" + EventObject(#Canvas)
						Else
							Debug "The mouse wheel has been turned down on the Object #" + EventObject(#Canvas)
						EndIf
					Case #EventType_KeyUp
						Debug "The keyboard key "+ Chr(CanvasObjectsEventData(#Canvas)) +" has been pressed on the Object #" + EventObject(#Canvas) ; See the Ascii Table.
					Case #EventType_KeyDown
						Debug "The keyboard key " + Chr(CanvasObjectsEventData(#Canvas)) + " has been released on the Object #" + EventObject(#Canvas) ; See the Ascii Table.
					Case #EventType_Selected
						Debug "Object #" + EventObject(#Canvas) + " has been selected."
					Case #EventType_Unselected
						Debug "Object #" + EventObject(#Canvas) + " has been unselected."
					Case #EventType_Moved
						Debug "Object #" + EventObject(#Canvas) + " has been moved."
					Case #EventType_Resized
						Debug "Object #" + EventObject(#Canvas) + " has been resized."
					Case #EventType_Selection
						Debug "A selection has been drawn: ({" + CanvasObjectsEventData(#Canvas, #EventTypeData_MinX) + ", " + CanvasObjectsEventData(#Canvas, #EventTypeData_MinY) + " }, {" + CanvasObjectsEventData(#Canvas, #EventTypeData_MaxX) + ", " + CanvasObjectsEventData(#Canvas, #EventTypeData_MaxY) + "})"
				EndSelect
				
			Case #Event_Handle ; It is a handle event
				
				Select CanvasObjectsEventType(#Canvas) ; What type of events happened on the handle ?
						
					Case #EventType_MouseEnter
						Debug "The mouse enters Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MouseLeave
						Debug "The mouse leaves Handle #" + EventHandle(#Canvas) + " on the Object n°" + EventObject(#Canvas)
					Case #EventType_LeftMouseBottonDown
						Debug "The left mouse button has been pressed on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseBottonUp
						Debug "The left mouse button has been released on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseClick
						Debug "A left click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_LeftMouseDoubleClick
						Debug "A double left mouse click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseBottonDown
						Debug "The middle mouse button has been pressed on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseBottonUp
						Debug "The middle mouse button has been released on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseClick
						Debug "A middle click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MiddleMouseDoubleClick
						Debug "A double middle mouse click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseBottonDown
						Debug "The right mouse button has been pressed on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseBottonUp
						Debug "The right mouse button has been released on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseClick
						Debug "A right click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_RightMouseDoubleClick
						Debug "A double right mouse click happens on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
					Case #EventType_MouseWheel
						If CanvasObjectsEventData(#Canvas) > 0
							Debug "The mouse wheel has been turned up on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
						Else
							Debug "The mouse wheel has been turned down on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas)
						EndIf
					Case #EventType_KeyUp
						Debug "The keyboard key "+ Chr(CanvasObjectsEventData(#Canvas)) +" has been pressed on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas) ; See the Ascii Table.
					Case #EventType_KeyDown
						Debug "The keyboard key " + Chr(CanvasObjectsEventData(#Canvas)) + " has been released on the Handle #" + EventHandle(#Canvas) + " on the Object #" + EventObject(#Canvas) ; See the Ascii Table.
				EndSelect
				
			Case #Event_None ; No Events.
				Break
				
		EndSelect
		
	ForEver
	
ForEver

End
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP
; EnableUser
; EnableOnError
; EnableCompileCount = 159
; EnableBuildCount = 0
; EnableExeConstant