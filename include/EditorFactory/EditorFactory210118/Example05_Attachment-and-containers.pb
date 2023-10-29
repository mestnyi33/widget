
; Example05_Attachment-and-containers.pb

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
	#Object6
	#Object7
	#Object8
EndEnumeration

; ----------------------------------------------

; Callback procedure to draw on the object
;   Object.i is the number of the object, you can use it to get properties of the currently drawn object
;   Width.i is the current width of the object
;   Height.i is the current height of the object
;   iData.i is a custom data value set in SetObjectDrawingCallback, here it is used as the color
; This procedure will automatically called during the draw of the Object
Procedure MyDrawingObject(Object.i, Width.i, Height.i, iData.i)
	AddPathBox(0, 0, Width, Height)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	VectorFont(FontID(#Font))
	StrokePath(2)
	If VisibleObjectFrame(Object)
		MovePathCursor(5,5)
		VectorFont(FontID(#Font))
		VectorSourceColor($FF000000)
		DrawVectorText("Frame: "+Str(VisibleObjectFrame(Object)))
		StrokePath(2)
	EndIf
EndProcedure

; ----------------------------------------------

; Load a font
LoadFont(#Font, "Arial", 12)

; Create a window
OpenWindow(#Window, 0, 0, 800, 450, "Example 5: Attachment and containers", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

UsePNGImageDecoder()


; --- Attachment ---
; You can attach an object on another object directly during creation or later with AttachObject

CreateObject(#Canvas, #Object1, 50, 50, 300, 100) ; Main object
SetObjectDrawingCallback(#Object1, @MyDrawingObject(), RGB(128, 192, 64))
AddObjectHandle(#Object1, #Handle_Position | #Handle_Size)

CreateObject(#Canvas, #Object2, 0, 120, 140, 100, #Object1) ; Attach object 2 directly to object 1, the position is then relative to object 1
SetObjectDrawingCallback(#Object2, @MyDrawingObject(), RGB(64, 128, 0))
AddObjectHandle(#Object2, #Handle_Position | #Handle_Size)

CreateObject(#Canvas, #Object3, 160, 170, 140, 100)
SetObjectDrawingCallback(#Object3, @MyDrawingObject(), RGB(64, 128, 0))
AddObjectHandle(#Object3, #Handle_Position | #Handle_Size)
AttachObject(#Object3, #Object1, #Attachment_X) ; Attach object 3 to object 1 but just the x-position


; --- Container ---
; If you attach an object to another and set its boundaries, it acts like a container.
; Here you can also swap between the different frames with the small handle on top right.

CreateObject(#Canvas, #Object4, 450, 50, 300, 300) ; Main object
SetObjectDrawingCallback(#Object4, @MyDrawingObject(), RGB(192, 64, 128))
AddObjectHandle(#Object4, #Handle_Position | #Handle_Size)
AddObjectHandle(#Object4, #Handle_Custom1, CatchImage(#PB_Any, ?layer_redraw), #Alignment_Top | #Alignment_Right, -25, 0) ; This is the handle the swap the frame

CreateObject(#Canvas, #Object5, 50, 50, 140, 100, #Object4, 1) ; Attach object 5 directly to object 1 into the first frame
SetObjectDrawingCallback(#Object5, @MyDrawingObject(), RGB(128, 0, 64))
AddObjectHandle(#Object5, #Handle_Position | #Handle_Size)
SetObjectBoundaries(#Object5, 0, 0, #Boundary_ParentSize, #Boundary_ParentSize) ; Set the boundaries to the parent size.

CreateObject(#Canvas, #Object6, 150, 50, 140, 100, #Object4, 2) ; Attach object 6 directly to object 1 into the second frame
SetObjectDrawingCallback(#Object6, @MyDrawingObject(), RGB(128, 0, 64))
AddObjectHandle(#Object6, #Handle_Position | #Handle_Size)
SetObjectBoundaries(#Object6, 0, 0, #Boundary_ParentSize, #Boundary_ParentSize) ; Set the boundaries to the parent size.

; Containers here works a bit like the PureBasic PanelGadgets in a way
; but the objects may or may not be constrained in position within it.
; Each object can have frames (containers for other objects). These frames are numbered from 1 to n.
; If you attach an object (children) to another object (parent), you can specify to which frame it should be attached,
; otherwise it will be automatically added to the current visible frame.
; You can later change the displayed frame with the ShowObjectFrame() command.


; The window's event loop and gadgets.
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_Gadget ; A Gadget type event.
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
	; The Objects events loop.
	Repeat
		
		Select CanvasObjectsEvent(#Canvas) ; Something happened in the Canvas.
			Case #Event_Handle
				Select CanvasObjectsEventType(#Canvas) ; What type of Events happened on the Handle ?
					Case #EventType_LeftMouseClick
						; Here the currently shown frame is changed.
						If EventHandle(#Canvas) = #Handle_Custom1 And CountObjectFrames(EventObject(#Canvas)) > 0
							ShowObjectFrame(EventObject(#Canvas), VisibleObjectFrame(EventObject(#Canvas)) % CountObjectFrames(EventObject(#Canvas)) + 1)
						EndIf
				EndSelect
			Case #Event_None ; No Events.
				Break
		EndSelect
		
	ForEver
	
ForEver

End


; Data section for the icon
DataSection
	; This icon is licensed under a Creative Commons Attribution 3.0 License.
	; Credits: https://www.fatcow.com/free-icons
	layer_redraw:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$5845741900000061
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA7854414449A502
	Data.q $FF145193485F538C,$305A945736FBEFDD,$E159249148FECCC5,$D526198851A5A6B0,$2284220A8934F68B
	Data.q $4F6654845C130A31,$A83D412F5A926419,$843419B17C319860,$0D9D36B53250D4B0,$EFDCEDDBEDB82596
	Data.q $EE72E5C0F0282A3A,$65EF77E77E77E739,$46B51E90D9FE3DD5,$2A4C032A0C619639,$C51344E2490C2BF3
	Data.q $20A614E90849450D,$AA617CC6018B0C05,$6155A09EAAF68B4A,$0C23F894E34CE311,$65A7AF00A391CC8C
	Data.q $494FF407E89A6E72,$618EAF47809B03E0,$2C01B9FB0503B460,$049ACDDD16489AE2,$2ED4F8458024D388
	Data.q $07DA6AF9D2252571,$3E547DC541E0763E,$A004B29D8898B061,$934BCDD24F8F0147,$B99981DEEBDCE8BB
	Data.q $05943D3133418321,$EA2732CE0E72F9BC,$8226981A15F2D59E,$9D1667BFAB300221,$D6087BBB916BC647
	Data.q $6B911C3518823944,$D4D0384F1716A164,$4B60048B060DC6D5,$F19BD06166790291,$F00FB3A066C363B7
	Data.q $08DF481DBE4025F9,$7A1B6B56E1E7C5A4,$350349840066C0AF,$F0CFB308F5228A26,$C6D638C178E3A64E
	Data.q $2D8306F4A0D43903,$C0D570FD2DF50133,$00888A268F08DA56,$888193B211C9BF86,$8E7B68502BE263AE
	Data.q $5ED9CC2A51C02DC2,$61B4B6EE070CEC81,$E4CF14D3C642DD1F,$8A4CB488862B8F94,$D3CE2090B5E62EEC
	Data.q $C33AE4A177535B1C,$76515B47061A5385,$C7E7DF1CD5ED15B0,$0B74BAD9316CEBA0,$021F064AB2C84211
	Data.q $0C9C4701D6727AF2,$E47BE7F66266CED7,$4A9557C9372E05EF,$AF0DD9DCC0F6F32C,$C94899C5E3FD1001
	Data.q $7975431D70F11238,$B78920A417C1BC31,$CE0B0A192E56D81E,$2550A2697441F893,$3E4715581905E998
	Data.q $383237CF54487831,$CD3E0EE044C25E4F,$317A47C8D95E6300,$BAAAC751377DA31D,$FDFF9C3594CE01BD
	Data.q $6E0129B30CC51469,$9F1F2A33473DC337,$123CBA2511CEDD81,$603497E7322FAB9E,$B3FFD27B19DA1058
	Data.q $2E978F38BB78DBE2,$FC5C6B851D2EAE27,$2B4D96B96187A0DD,$2A000C025F815FFD,$00A43BC08246DEFE
	Data.q $AE444E4549000000,$0000000000826042
EndDataSection
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP
; EnableCompileCount = 372
; EnableBuildCount = 0
; EnableExeConstant