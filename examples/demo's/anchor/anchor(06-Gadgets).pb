
; Example06_Gadgets.pb

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

Procedure.i HSVA(Hue.i, Saturation.i, Value.i, Aplha.i=255) ; [0,360], [0,100], [0,255], [0,255]
	Protected H.i = Int(Hue/60)
	Protected f.f = (Hue/60-H)
	Protected p = Value * (1-Saturation/100.0)
	Protected q = Value * (1-Saturation/100.0*f)
	Protected t = Value * (1-Saturation/100.0*(1-f))
	Select H
		Case 1 : ProcedureReturn RGBA(q,Value,p, Aplha)
		Case 2 : ProcedureReturn RGBA(p,Value,t, Aplha)
		Case 3 : ProcedureReturn RGBA(p,q,Value, Aplha)  
		Case 4 : ProcedureReturn RGBA(t,p,Value, Aplha)
		Case 5 : ProcedureReturn RGBA(Value,p,q, Aplha)  
		Default : ProcedureReturn RGBA(Value,t,p, Aplha)
	EndSelect
EndProcedure


Procedure Callback_Canvas(Gadget.i, DataValue.i)
	VectorSourceColor($FFF0F0F0)
	FillVectorOutput()
EndProcedure


;  - - -  Button Gadget - - -


; Callback procedure for a button gadget. Runtime keyword is needed here!
Runtime Procedure Callback_Button(Object.i, Width.i, Height.i, DataValue.i)
	
	Protected Text.s = GetObjectDictionary(Object, "Text")
	Protected Hue = DataValue
	
	; Box background
	AddPathBox(0.0, 0.0, Width, Height)
	VectorSourceLinearGradient(0.0, 0.0, 0.0, Height)
	If ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
		VectorSourceGradientColor(HSVA(Hue, 10, $FF), 0.00)
		VectorSourceGradientColor(HSVA(Hue, 20, $F8), 0.45)
		VectorSourceGradientColor(HSVA(Hue, 30, $F0), 0.50)
		VectorSourceGradientColor(HSVA(Hue, 40, $E8), 1.00)
	ElseIf ObjectState(Object) & #State_Hovered And GetGadgetAttribute(#Canvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = 0
		VectorSourceGradientColor(HSVA(Hue, 5, $FF), 0.00)
		VectorSourceGradientColor(HSVA(Hue, 10, $F8), 0.45)
		VectorSourceGradientColor(HSVA(Hue, 15, $F0), 0.50)
		VectorSourceGradientColor(HSVA(Hue, 20, $E8), 1.00)
	Else
		VectorSourceGradientColor(HSVA(0, 0, $F8), 0.00)
		VectorSourceGradientColor(HSVA(0, 0, $F0), 0.45)
		VectorSourceGradientColor(HSVA(0, 0, $E8), 0.50)
		VectorSourceGradientColor(HSVA(0, 0, $D8), 1.00)
	EndIf
	FillPath()
	
	; Box frame
	If ObjectState(Object) & #State_Disabled
		AddPathBox(0.5, 0.5, Width-1, Height-1)
		VectorSourceColor(HSVA(0, 0, $D0))
		StrokePath(1)
		AddPathBox(1.5, 1.5, Width-3, Height-3)
		VectorSourceColor(HSVA(0, 0, $F0))
		StrokePath(1)
	ElseIf ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
		AddPathBox(0.5, 0.5, Width-1, Height-1)
		VectorSourceColor(HSVA(Hue, 100, $80))
		StrokePath(1)
		AddPathBox(1.5, 1.5, Width-3, Height-3)
		VectorSourceColor(HSVA(Hue, 50, $FF))
		StrokePath(1)
	ElseIf ObjectState(Object) & #State_Hovered And GetGadgetAttribute(#Canvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = 0
		AddPathBox(0.5, 0.5, Width-1, Height-1)
		VectorSourceColor(HSVA(0, 0, $A0))
		StrokePath(1)
		AddPathBox(1.5, 1.5, Width-3, Height-3)
		VectorSourceColor(HSVA(Hue, 10, $FF))
		StrokePath(1)
	Else
		AddPathBox(0.5, 0.5, Width-1, Height-1)
		VectorSourceColor(HSVA(0, 0, $A0))
		StrokePath(1)
		AddPathBox(1.5, 1.5, Width-3, Height-3)
		VectorSourceColor(HSVA(0, 0, $FF))
		StrokePath(1)
	EndIf
	
	; Text
	AddPathBox(0.0, 0.0, Width, Height)
	ClipPath()
	VectorFont(FontID(#Font))
	If ObjectState(Object) & #State_Disabled
		VectorSourceColor($40000000)
	Else
		VectorSourceColor($FF000000)
	EndIf
	If Height - 6 > 0 And Width - 6 > 0
		If ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
			MovePathCursor(3, (Height-VectorParagraphHeight(Text, Width-6, Height-6))/2)
		Else
			MovePathCursor(3, (Height-VectorParagraphHeight(Text, Width-6, Height-6))/2-1)
		EndIf
		DrawVectorParagraph(Text, Width-6, Height-6, #PB_VectorParagraph_Center)
	EndIf
	
EndProcedure

; Custom procedure to create a button object
Procedure Form_AddButton(Object.i, X.i, Y.i, Width.i, Height.i, Text.s, HighlightColorHue.i=205)
	
	CreateObject(#Canvas, Object, X, Y, Width, Height)
	SetObjectDictionary(Object, "Text", Text)                                 ; Set the button text as a dictionary entry
	SetObjectDrawingCallback(Object, "Callback_Button()", HighlightColorHue)  ; Set the drawing callback with the specified highlighting color
	AddObjectHandle(Object, #Handle_Size|#Handle_Position)                    ; Add handles if you want to edit the buttons.
	
EndProcedure


;  - - -  Check box form - - -


; Callback procedure for a button form. Runtime keyword is needed here!
Runtime Procedure Callback_CheckBox(Object.i, Width.i, Height.i, DataValue.i)
	
	Protected Text.s = GetObjectDictionary(Object, "Text")
	Protected State.i = Val(GetObjectDictionary(Object, "State"))
	Protected Y.i = Int((Height-19)/2)
	Protected Hue = 205
	
	; Box background
	AddPathBox(0, Y, 19, 19)
	VectorSourceLinearGradient(0.0, Y, 0.0, Y+19)
	If ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
		VectorSourceGradientColor(HSVA(Hue, 40, $E8), 0.00)
		VectorSourceGradientColor(HSVA(Hue, 10, $FF), 1.00)
	ElseIf ObjectState(Object) & #State_Hovered And GetGadgetAttribute(#Canvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = 0
		VectorSourceGradientColor(HSVA(Hue, 20, $E8), 0.00)
		VectorSourceGradientColor(HSVA(Hue, 5, $FF), 1.00)
	Else
		VectorSourceGradientColor(HSVA(0, 0, $D8), 0.00)
		VectorSourceGradientColor(HSVA(0, 0, $F8), 1.00)
	EndIf
	FillPath()
	
	; Box frame
	If ObjectState(Object) & #State_Disabled
		AddPathBox(0.5, Y+0.5, 18, 18)
		VectorSourceColor(HSVA(0, 0, $D0))
		StrokePath(1)
		AddPathBox(1.5, Y+1.5, 16, 16)
		VectorSourceColor(HSVA(0, 0, $F0))
		StrokePath(1)
	ElseIf ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
		AddPathBox(0.5, Y+0.5, 18, 18)
		VectorSourceColor(HSVA(Hue, 100, $80))
		StrokePath(1)
		AddPathBox(1.5, Y+1.5, 16, 16)
		VectorSourceColor(HSVA(Hue, 50, $FF))
		StrokePath(1)
	ElseIf ObjectState(Object) & #State_Hovered And GetGadgetAttribute(#Canvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = 0
		AddPathBox(0.5, Y+0.5, 18, 18)
		VectorSourceColor(HSVA(0, 0, $A0))
		StrokePath(1)
		AddPathBox(1.5, Y+1.5, 16, 16)
		VectorSourceColor(HSVA(Hue, 10, $FF))
		StrokePath(1)
	Else
		AddPathBox(0.5, Y+0.5, 18, 18)
		VectorSourceColor(HSVA(0, 0, $A0))
		StrokePath(1)
		AddPathBox(1.5, Y+1.5, 16, 16)
		VectorSourceColor(HSVA(0, 0, $FF))
		StrokePath(1)
	EndIf
	
	; Check
	If State
		MovePathCursor(9.5, Y+10.5+Bool(ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)))
		AddPathLine(10.5, -10.5, #PB_Path_Relative)
		AddPathLine(2.5, 2.5, #PB_Path_Relative)
		AddPathLine(-13, 13, #PB_Path_Relative)
		AddPathLine(-5, -5, #PB_Path_Relative)
		AddPathLine(2.5, -2.5, #PB_Path_Relative)
		ClosePath()
		If ObjectState(Object) & #State_Disabled
			VectorSourceColor(HSVA(Hue, 0, $C0))
		Else
			VectorSourceColor(HSVA(Hue, 100, $C0))
		EndIf
		FillPath()
	EndIf
	
	; Text
	AddPathBox(25, 0, Width-25, Height)
	ClipPath()
	VectorFont(FontID(#Font))
	If ObjectState(Object) & #State_Disabled
		VectorSourceColor($40000000)
	Else
		VectorSourceColor($FF000000)
	EndIf
	If Height > 0 And Width - 25 > 0
		If ObjectState(Object) & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
			MovePathCursor(25, (Height-VectorParagraphHeight(Text, Width-25, Height))/2)
		Else
			MovePathCursor(25, (Height-VectorParagraphHeight(Text, Width-25, Height))/2-1)
		EndIf
		DrawVectorParagraph(Text, Width-25, Height, #PB_VectorParagraph_Left)
	EndIf
	
EndProcedure

; Custom procedure to create a button object
Procedure Form_AddCheckBox(Object.i, X.i, Y.i, Width.i, Height.i, Text.s)
	
	CreateObject(#Canvas, Object, X, Y, Width, Height)
	SetObjectDictionary(Object, "Text", Text)                ; Set the button text as a dictionary entry
	SetObjectDrawingCallback(Object, "Callback_CheckBox()")  ; Set the drawing callback
	AddObjectHandle(Object, #Handle_Size|#Handle_Position)   ; Add handles if you want to edit the buttons.
	
EndProcedure


; ----------------------------------------------



; Object constants starting from 1
Enumeration 1
	#Object_Button1
	#Object_Button2
	#Object_Button3
	#Object_CheckBox1
	#Object_CheckBox2
	#Object_CheckBox3
EndEnumeration

; Load a font
LoadFont(#Font, "Arial", 12)

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf
SetCanvasDrawingCallback(#Canvas, @Callback_Canvas(), #Null)

; Creates some customized buttons
Form_AddButton(#Object_Button1, 50, 50, 200, 30, "Normal button")
Form_AddButton(#Object_Button2, 50, 100, 200, 30, "Disabled Button")
Form_AddButton(#Object_Button3, 50, 150, 200, 70, "Another button with a very long text", 20)

; Creates some customized check boxes
Form_AddCheckBox(#Object_CheckBox1, 300, 50, 200, 30, "Check Box")
Form_AddCheckBox(#Object_CheckBox2, 300, 100, 200, 30, "Disabled Check Box")
Form_AddCheckBox(#Object_CheckBox3, 300, 150, 200, 50, "Another Check Box with longer text")

DisableObject(#Object_Button2)
DisableObject(#Object_CheckBox2)
SetObjectDictionary(#Object_CheckBox2, "State", "1")
SetObjectDictionary(#Object_CheckBox3, "State", "1")

; The window's event loop
Repeat
	
	Select WaitWindowEvent()
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
	EndSelect
	
	; Event loop of the objects in the canvas gadget
	Repeat
		Select CanvasObjectsEvent(#Canvas) ;  Something happened in the canvas.
			Case #Event_Object ; It is an object event
				Select CanvasObjectsEventType(#Canvas) ; What type of events happened on the object?
					Case #EventType_LeftMouseClick
						Debug "Button '" + GetObjectDictionary(EventObject(#Canvas), "Text") + "' was clicked."
						Select EventObject(#Canvas)
							Case #Object_CheckBox1 To #Object_CheckBox3
								SetObjectDictionary(EventObject(#Canvas), "State", Str(1-Val(GetObjectDictionary(EventObject(#Canvas), "State"))))
						EndSelect
				EndSelect
			Case #Event_None ; No Events.
				Break
		EndSelect
	ForEver

ForEver

End
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----
; EnableXP