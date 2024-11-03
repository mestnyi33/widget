
; Example04_Object-order.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory


; --------- Example ---------


; Program constants
Enumeration 1
  #Window
  #Canvas
  #Menu
  #Font
EndEnumeration

; Object constants starting from 1
Enumeration 1
  #Object1
  #Object2
  #Object3
  #Object4
  #Object5
EndEnumeration

; Constants for the context menu.
Enumeration 1
  #MenuItem_ZOrder_Top
  #MenuItem_ZOrder_Up
  #MenuItem_ZOrder_Down
  #MenuItem_ZOrder_Bottom
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
	VectorSourceColor(iData|$C0000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(1)
	MovePathCursor(10, 10)
	VectorSourceColor($FF000000)
	VectorFont(FontID(#Font))
	DrawVectorText("Layer = "+Str(GetObjectLayer(Object)))
EndProcedure

; ----------------------------------------------

; Load a font
LoadFont(#Font, "Arial", 14)
 
; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    
; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

; Creation of the context menu to change the layer position of the selected object.
CreatePopupMenu(#Menu)
MenuItem(#MenuItem_ZOrder_Top, "Push to top most layer")
MenuItem(#MenuItem_ZOrder_Up, "Push one layer up")
MenuItem(#MenuItem_ZOrder_Down, "Push one layer down")
MenuItem(#MenuItem_ZOrder_Bottom, "Push to the deepest layer")

; Create five different objects, the ordering is defined by the moment of creation.
CreateObject(#Canvas, #Object1, 20, 20, 200, 100)
CreateObject(#Canvas, #Object2, 50, 50, 200, 100)
CreateObject(#Canvas, #Object3, 80, 80, 200, 100)
CreateObject(#Canvas, #Object4, 110, 110, 200, 100)
CreateObject(#Canvas, #Object5, 140, 140, 200, 100)

; Set the custom drawing procedures (as defined above) to the specified object. The last parameter is used as a color
SetObjectDrawingCallback(#Object1, @MyDrawingObject(), RGB(64, 128, 192))
SetObjectDrawingCallback(#Object2, @MyDrawingObject(), RGB(192, 64, 128))
SetObjectDrawingCallback(#Object3, @MyDrawingObject(), RGB(128, 192, 64)) 
SetObjectDrawingCallback(#Object4, @MyDrawingObject(), RGB(192, 128, 64))
SetObjectDrawingCallback(#Object5, @MyDrawingObject(), RGB(128, 64, 192))

; Define different cursors to the objects
AddObjectHandle(#Object_All, #Handle_Size | #Handle_Position)

Define CurrentObject.i 

; The window's event loop
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_Gadget
			
		Case #PB_Event_Menu
			
			Select EventMenu()
				Case #MenuItem_ZOrder_Top
					SetObjectLayer(CurrentObject, -1, #PB_Absolute) ; Push to the last layer (-1)
				Case #MenuItem_ZOrder_Up
					SetObjectLayer(CurrentObject, 1, #PB_Relative) ; Push one layer up (+1)
				Case #MenuItem_ZOrder_Down
					SetObjectLayer(CurrentObject, -1, #PB_Relative) ; Push one layer up (-1)
				Case #MenuItem_ZOrder_Bottom
					SetObjectLayer(CurrentObject, 1, #PB_Absolute) ; Push to the first layer (1)
			EndSelect
			
		Case #PB_Event_CloseWindow
			Break
			
	EndSelect
	
	; Event loop of the objects in the canvas gadget
	Repeat
		
		Select CanvasObjectsEvent(#Canvas) ;  Something happened in the canvas.
				
			Case #Event_Object ; It is an object event
				
				Select CanvasObjectsEventType(#Canvas) ; What type of events happened on the object?
						
					Case #EventType_RightMouseClick
						CurrentObject.i = EventObject(#Canvas)
						DisplayPopupMenu(#Menu, WindowID(#Window)) ; The context menu is displayed.
						
				EndSelect
				
			Case #Event_None ; No Events.
				Break
				
		EndSelect
		
	ForEver
	
ForEver

End
; IDE Options = PureBasic 5.72 (Windows - x64)
; Folding = -
; EnableXP
; EnableUser
; EnableOnError
; EnableCompileCount = 78
; EnableBuildCount = 0
; EnableExeConstant