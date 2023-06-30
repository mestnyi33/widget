;- TOP
; https://www.purebasic.fr/english/viewtopic.php?t=81788&sid=7612bdc15503ade13323bb9f4031a87b
;.-------------------------------------------------------------------------------------------------------------------------------
;|
;|  Title            : DragCanvasGadget
;|  Version          : v0.1.0
;|  Author					 : Mesa make a fork with or without module of Kenmo's CanvasDragGadget
;|  Copyright        : Kenmo: See at https://github.com/kenmo-pb/includes/blob/master/CanvasDrag.pbi
;|                     
;|  PureBasic        : 6.01+
;|  
;|  Operating System : Windows (XP to W11+), Linux (not tested), MacOS (not tested)
;|  Processor        : x86, x64
;|
;|  API							 : Api used + PB internal tricks (but it's possible to bypass Apis, see #DragCanvasGadget_EnableWinAPIText)
;|
;|-------------------------------------------------------------------------------------------------------------------------------
;|
;|  Description      : A canvas gadget with three more events: Start dragging, dragging and stop dragging
;|
;|  Forum Topic      : http://www.purebasic.fr/french/viewtopic.php?t=215912
;|                     http://www.purebasic.fr/english/viewtopic.php?t=81788
;|  Website          : 
;|
;|  Documentation    : 
;|
;|	Date 						 : 06/2023
;|
;|  Misc.						 : I confess to being inspired (in a shameless way) in large part by the robust 
;|										 code of Stargate's TabBar gadget. So, if you have analyzed his code then mine 
;|										 will be very easy to understand and improve. 
;|										 See http://forums.purebasic.com/english/viewtopic.php?t=47588&sid=f357a15fde8f37263dfef4f236ee0443
;|										 
;|										 I use parts of the mk-soft's module system, https://www.purebasic.fr/english/viewtopic.php?f=12&t=72980
;|
;.-------------------------------------------------------------------------------------------------------------------------------



;.-------------------------------------------------------------------------------------------------------------------------------
;|
;|  How to  use 		 : 1) Create a DragCanvasGadget	with DragCanvasGadget(...)	 
;|									 : 2) Optionnal: Create your own update procedure and bind it with BindDragCanvasGadgetUpdate(Gadget, Proc)
;|  			           : 3) Create your own drawing procedure and bind it with BindDragCanvasGadgetDrawing(Gadget, Proc) 
;|  				         : 4)	New dragging events	can be use as usual by the PB BindGadgetEvent() or by using the main loop 
;|
;.-------------------------------------------------------------------------------------------------------------------------------



;.-------------------------------------------------------------------------------------------------------------------------------
;|
;|  New events
;|  ================================================================
;|  		#DragCanvasGadget_EventType_Start		
;|  		#DragCanvasGadget_EventType_Stop						
;|  		#DragCanvasGadget_EventType_Change
;|  		#DragCanvasGadget_EventType_Updated	
;|  	
;|  Drawing management
;|  =================
;|  		SetDragCanvasGadgetCancel(Gadget): Cancel a drawing movement
;|  		SetDragCanvasGadgetClamp(Gadget, State): Clamp before dragging
;|  		SetDragCanvasGadgetThreshold(Gadget, Pixels): Threshold area
;|  			 
;.-------------------------------------------------------------------------------------------------------------------------------



;.-------------------------------------------------------------------------------------------------------------------------------
;|
;|  License Mesa.
;|  The license Mesa is, do what you like but make the World better, easier and enjoyable.
;|
;|
;|
;| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;| SOFTWARE.
;| 
;.-------------------------------------------------------------------------------------------------------------------------------



; kenmo
; https://github.com/kenmo-pb/includes/blob/master/CanvasDrag.pbi
; +------------+
; | Canvas     |
; +------------+
; | 2019-04-25 : Creation
; | 2019-11-03 : Added L/R/M mouse button handling
; | 2019-11-04 : Added Start/Stop/Change custom EventTypes, threshold/clamp
; | 2019-11-05 : Added GetClickWasDragStop() to avoid double-handling
; | 2019-11-26 : Added LockXY(), ScaleX(), ScaleY(), demo text instructions
; | 2019-11-27 : Get real parent window (WindowFromGadget.pbi included)

; TODO
; release drag on MouseLeave ? depends on OS ?




;- DeclareModule 
DeclareModule DragCanvas
	
	CompilerIf (Not Defined(DragCanvas_Included, #PB_Constant))
		#DragCanvas_Included = #True
		
		CompilerIf (#PB_Compiler_IsMainFile)
			EnableExplicit
		CompilerEndIf
		
		
		;-  1. Constants & Imports
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		
		
		; Gadget Events
		Enumeration
			#DragCanvasGadget_EventType_Start = #PB_EventType_FirstCustomValue
			#DragCanvasGadget_EventType_Stop
			#DragCanvasGadget_EventType_Change
			#DragCanvasGadget_EventType_Updated
		EndEnumeration
		
		; Gadget Datas
		EnumerationBinary 
			#AnchorX
			#AnchorY
			#Attributes
			#BottomY
			#Button
			#CameraX
			#CameraY
			#Clamp
			#ClickWasDrag
			#DataValue
			#DirX
			#DirY
			#Down
			#Dragging
			#FontID
			#Gadget
			#Height
			#LeftX
			#Number
			#PreviousSelX
			#PreviousSelY
			#ProcDrawing											
			#ProcUpdate	
			#RightX
			#SelX
			#SelY
			#Threshold
			#TopY
			#UpdatePosted
			#UserX
			#UserY
			#Width
			#Window	
			#X
			#Y
		EndEnumeration
		
		; Compile switch for extra safety - could affect callback performance!
		CompilerIf Not Defined(DragCanvasGadget_EnableCallbackGadgetCheck, #PB_Constant)
			#DragCanvasGadget_EnableCallbackGadgetCheck = #False
		CompilerEndIf
		
		; Compile switch to use WinAPI for drawing clearer text
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			CompilerIf Not Defined(Gadget_EnableWinAPIText, #PB_Constant)
				#DragCanvasGadget_EnableWinAPIText = #True
			CompilerEndIf
		CompilerElse
			#DragCanvasGadget_EnableWinAPIText = #False
		CompilerEndIf
		
		
		
		
		
		
		;-
		;-  2. Structure
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		
		
		Structure DragCanvasGadget
			Attributes.i
			Number.i
			Gadget.i
			Window.i	
			DataValue.i
			
			Down.i					; = #False
			Dragging.i			; = #False
			Clamp.i					; = #False
			Threshold.i			; = 3
			
			ClickWasDrag.i	; = #False
			Button.i
			AnchorX.i
			AnchorY.i
			PreviousSelX.i
			PreviousSelY.i
			SelX.i
			SelY.i
			LeftX.i
			RightX.i
			TopY.i
			BottomY.i
			X.i
			Y.i
			Width.i
			Height.i
			DirX.i
			DirY.i
			UserX.d
			UserY.d
			CameraX.i
			CameraY.i
			CompilerIf #DragCanvasGadget_EnableWinAPIText
				DrawingID.i                     ; Drawing handle for API text drawing
				PrevFont.i											; Store previous font handle to restore
				DrawRect.RECT										; Allocate a RECT struct for WinAPI
				
			CompilerEndIf
			ProcDrawing.i											;Adress of your own drawing procedure
			ProcUpdate.i											;Adress of your own update procedure
			UpdatePosted.i
			FontID.i
		EndStructure
		
		
		
		;-
		;-  3a. Initializations / Globals
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		; NOTHING... because there are NO GLOBAL variables
		; Everything is in the GadgetData
		; And "initializations" are made inside the Procedure DragCanvasGadget()
		
		
		;-  3b.Declaration Procedures:. 
		
		; Fast procedures
		Declare DragCanvasGadget_ContainsBox(*DragCanvasGadget.DragCanvasGadget, x, y, Width, Height)
		Declare DragCanvasGadget_ContainsPoint(*DragCanvasGadget.DragCanvasGadget, x, y)
		Declare DragCanvasGadget_IntersectsBox(*DragCanvasGadget.DragCanvasGadget, x, y, Width, Height)
		
		; Procedures for the gadget
		Declare UpdateDragCanvasGadget(Gadget) 
		Declare FreeDragCanvasGadget(Gadget) 	
		Declare DragCanvasGadget(Gadget, X, Y, Width, Height, Attributes = 0)	
		Declare BindDragCanvasGadget(Gadget)	
		Declare UnBindDragCanvasGadget(Gadget)	
		; You have to bind your own drawing procedure (for each canvas)
		Declare BindDragCanvasGadgetDrawing(Gadget, Proc)	
		Declare UnBindDragCanvasGadgetDrawing(Gadget)
		; You have the possibility to bind your own update procedure (for each canvas),
		; to do extra calculations (for example) before drawing
		Declare BindDragCanvasGadgetUpdate(Gadget, Proc)
		Declare UnBindDragCanvasGadgetUpdate(Gadget)
		
		; Getters & Setters
		Declare GetDragCanvasGadgetAnchorX(Gadget)		
		Declare GetDragCanvasGadgetAnchorY(Gadget)
		Declare GetDragCanvasGadgetBottomY(Gadget)		
		Declare GetDragCanvasGadgetButton(Gadget)		
		Declare SetDragCanvasGadgetCancel(Gadget)	
		Declare SetDragCanvasGadgetClamp(Gadget, State)	
		Declare GetDragCanvasGadgetClickWasDragStop(Gadget)	
		Declare GetDragCanvasGadgetContainsBox(Gadget, x, y, Width, Height)	
		Declare GetDragCanvasGadgetContainsPoint(Gadget, x, y)		
		Declare GetDragCanvasGadgetCursorX(Gadget)			
		Declare GetDragCanvasGadgetCursorY(Gadget)		
		Declare SetDragCanvasGadgetData(Gadget, DataValue)			
		Declare GetDragCanvasGadgetData(Gadget)		
		Declare GetDragCanvasGadgetDatas(Gadget, Datas)		
		Declare GetDragCanvasGadgetDeltaX(Gadget)			
		Declare GetDragCanvasGadgetDeltaY(Gadget)			
		Declare GetDragCanvasGadgetDirX(Gadget)		
		Declare GetDragCanvasGadgetDirY(Gadget)			
		Declare GetDragCanvasGadgetDragging(Gadget)		
		Declare GetDragCanvasGadget(Gadget)		
		Declare GetDragCanvasGadgetHeight(Gadget)		
		Declare GetDragCanvasGadgetIntersectsBox(Gadget, x, y, Width, Height)			
		Declare GetDragCanvasGadgetLeftX(Gadget)			
		Declare SetDragCanvasGadgetLockXY(Gadget,UserX.d, UserY.d)			
		Declare GetDragCanvasGadgetRelativeX(Gadget)		
		Declare GetDragCanvasGadgetRelativeY(Gadget)		
		Declare GetDragCanvasGadgetRightX(Gadget)		
		Declare.d GetDragCanvasGadgetScaleX(Gadget, ScaleX.d = 1.0)		
		Declare.d GetDragCanvasGadgetScaleY(Gadget, ScaleY.d = 1.0)		
		Declare GetDragCanvasGadgetTopY(Gadget)	
		Declare SetDragCanvasGadgetThreshold(Gadget, Pixels)		
		Declare GetDragCanvasGadgetWidth(Gadget)
		
		
	EndDeclareModule
	
	
	;-
	;- Module
	
	
	
	Module DragCanvas
		
		
		
		; Imports PB internals to retrieve the window ID
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		; From mk-soft https://www.purebasic.fr/english/viewtopic.php?f=12&t=72980
		
		CompilerIf (Not Defined(_WindowFromGadget_Included, #PB_Constant))
			#_WindowFromGadget_Included = #True
			
			CompilerIf (Not Defined(PB_Object_EnumerateStart, #PB_Procedure))
				
				CompilerIf #PB_Compiler_OS = #PB_OS_Windows
					Import ""
						PB_Object_EnumerateStart(PB_Objects)
						PB_Object_EnumerateNext(PB_Objects, *IDnteger)
						PB_Object_EnumerateAbort(PB_Objects)
						PB_Object_GetObject(PB_Object , DynamicOrArrayID)
						PB_Window_Objects
						PB_Gadget_Objects
						PB_Image_Objects
						PB_Font_Objects
					EndImport
				CompilerElse
					ImportC ""
						PB_Object_EnumerateStart(PB_Objects)
						PB_Object_EnumerateNext(PB_Objects, *IDnteger)
						PB_Object_EnumerateAbort(PB_Objects)
						PB_Object_GetObject(PB_Object , DynamicOrArrayID)
						PB_Window_Objects
						PB_Gadget_Objects
						PB_Image_Objects
						PB_Font_Objects
					EndImport
				CompilerEndIf
				
			CompilerEndIf
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				; PB Internal Structure Gadget MacOS
				Structure sdkGadget
					*DragCanvasGadget
					*container
					*vt
					UserData.i
					Window.i
					Type.i
					Flags.i
				EndStructure
			CompilerEndIf 
			
			Procedure GetWindowFromID(WindowID)
				Protected Result = -1
				If (WindowID)
					PB_Object_EnumerateStart(PB_Window_Objects)
					If (PB_Window_Objects)
						Protected Window
						While (PB_Object_EnumerateNext(PB_Window_Objects, @Window))
							If (WindowID(Window) = WindowID)
								Result = Window
								Break
							EndIf
						Wend
						PB_Object_EnumerateAbort(PB_Window_Objects)
					EndIf
				EndIf
				ProcedureReturn (Result)
			EndProcedure
			
			Procedure GetParentWindowID(Gadget) ; Retval handle
				Protected WindowID
				
				If IsGadget(Gadget)
					CompilerSelect #PB_Compiler_OS
						CompilerCase #PB_OS_MacOS
							Protected *DragCanvasGadget.sdkGadget = IsGadget(Gadget)
							WindowID = WindowID(*DragCanvasGadget\Window)
						CompilerCase #PB_OS_Linux
							WindowID = gtk_widget_get_toplevel_(GadgetID(Gadget))
						CompilerCase #PB_OS_Windows           
							WindowID = GetAncestor_(GadgetID(Gadget), #GA_ROOT)
					CompilerEndSelect
				EndIf
				ProcedureReturn WindowID
			EndProcedure
			
			Procedure GetWindowFromGadget(Gadget)
				Protected Result = -1
				Result = GetWindowFromID(GetParentWindowID(Gadget))
				ProcedureReturn (Result)
			EndProcedure
			
		CompilerEndIf
		
		
		
		;-
		;-  4. Procedures & Macros
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		
		
		;-  4.1 Private procedures for internal calculations 
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		Procedure DragCanvasGadget_StartVectorDrawing(*DragCanvasGadget.DragCanvasGadget)
			CompilerIf #DragCanvasGadget_EnableWinAPIText
				With *DragCanvasGadget
					\DrawingID = StartVectorDrawing(CanvasVectorOutput(*DragCanvasGadget\Number))
					If \DrawingID
						\PrevFont = SelectObject_(\DrawingID, \FontID)
						\DrawRect\right  = VectorOutputWidth()
						\DrawRect\bottom = VectorOutputHeight()
						SetBkMode_(\DrawingID, #TRANSPARENT)
					EndIf
					ProcedureReturn \DrawingID
				EndWith
			CompilerElse
				
				ProcedureReturn StartVectorDrawing(CanvasVectorOutput(*DragCanvasGadget\Number))
			CompilerEndIf
		EndProcedure
		
		; StopDrawing() wrapper which clears handle for WinAPI drawing
		Procedure DragCanvasGadget_StopVectorDrawing(*DragCanvasGadget.DragCanvasGadget)
			CompilerIf #DragCanvasGadget_EnableWinAPIText
				With *DragCanvasGadget
					If (\DrawingID)
						SelectObject_(\DrawingID, \PrevFont)
						\DrawingID = #Null
					EndIf
				EndWith
			CompilerEndIf
			StopVectorDrawing()
		EndProcedure
		
		Procedure DragCanvasGadget_Button(*DragCanvasGadget.DragCanvasGadget)
			ProcedureReturn (*DragCanvasGadget\Button)
		EndProcedure
		
		Procedure DragCanvasGadget_ClickWasDragStop(*DragCanvasGadget.DragCanvasGadget)
			Protected Result 
			With *DragCanvasGadget
				Result= \ClickWasDrag
				\ClickWasDrag = #False
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure DragCanvasGadget_ContainsBox(*DragCanvasGadget.DragCanvasGadget, x, y, Width, Height)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x >= \LeftX) And (x + \Width <= \RightX))
						If ((y >= \TopY) And (y + \Height <= \BottomY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure DragCanvasGadget_ContainsPoint(*DragCanvasGadget.DragCanvasGadget, x, y)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x >= \LeftX) And (x <= \RightX))
						If ((y >= \TopY) And (y <= \BottomY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure DragCanvasGadget_IntersectsBox(*DragCanvasGadget.DragCanvasGadget, x, y, Width, Height)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x <= \RightX) And (x + Width >= \LeftX))
						If ((y <= \BottomY) And (y + Height >= \TopY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure DragCanvasGadget_LockXY(*DragCanvasGadget.DragCanvasGadget,UserX.d, UserY.d)
			With *DragCanvasGadget
				\UserX = UserX
				\UserY = UserY
			EndWith
		EndProcedure
		
		Procedure.d DragCanvasGadget_ScaleX(*DragCanvasGadget.DragCanvasGadget, ScaleX.d = 1.0)
			ProcedureReturn (ScaleX * *DragCanvasGadget\X + *DragCanvasGadget\UserX)
		EndProcedure
		
		Procedure.d DragCanvasGadget_ScaleY(*DragCanvasGadget.DragCanvasGadget, ScaleY.d = 1.0)
			ProcedureReturn (ScaleY * *DragCanvasGadget\Y + *DragCanvasGadget\UserY)
		EndProcedure
		
		; Manage canvas events (extra events are managed in the callback)
		Procedure DragCanvasGadget_Examine(*DragCanvasGadget.DragCanvasGadget)
			
			With *DragCanvasGadget
				
				If ((Not \Down) Or (\Gadget = EventGadget()))
					Select (EventType())
						Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown, #PB_EventType_MiddleButtonDown
							If (Not \Down)
								\Down = #True
								\Gadget = EventGadget():\Number=\Gadget
								\AnchorX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
								\AnchorY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
								\PreviousSelX = \AnchorX
								\PreviousSelY = \AnchorY
								Select (EventType())
									Case #PB_EventType_LeftButtonDown
										\Button = #PB_Canvas_LeftButton
									Case #PB_EventType_RightButtonDown
										\Button = #PB_Canvas_RightButton
									Case #PB_EventType_MiddleButtonDown
										\Button = #PB_Canvas_MiddleButton
								EndSelect
							EndIf
						Case #PB_EventType_LeftButtonUp, #PB_EventType_RightButtonUp, #PB_EventType_MiddleButtonUp
							If (\Down)
								If (((EventType() = #PB_EventType_LeftButtonUp) And (\Button = #PB_Canvas_LeftButton)) Or
								    ((EventType() = #PB_EventType_RightButtonUp) And (\Button = #PB_Canvas_RightButton)) Or
								    ((EventType() = #PB_EventType_MiddleButtonUp) And (\Button = #PB_Canvas_MiddleButton)))
									\Down = #False
									If (\Dragging)
										\Dragging = #False
										PostEvent(#PB_Event_Gadget, \Window, EventGadget(), #DragCanvasGadget_EventType_Stop)
									EndIf
								EndIf
							EndIf
						Case #PB_EventType_MouseLeave
							;
						Case #PB_EventType_MouseMove
							If (\Down)
								\SelX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
								\SelY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
								If (\Clamp)
									If (\SelX < 0)
										\SelX = 0
									ElseIf (\SelX >= GadgetWidth(EventGadget()))
										\SelX = GadgetWidth(EventGadget()) - 1
									EndIf
									If (\SelY < 0)
										\SelY = 0
									ElseIf (\SelY >= GadgetHeight(EventGadget()))
										\SelY = GadgetHeight(EventGadget()) - 1
									EndIf
								EndIf
								If (Not \Dragging)
									If ((Abs(\SelX - \AnchorX) + Abs(\SelY - \AnchorY)) >= \Threshold)
										\ClickWasDrag = #True
										\Dragging = #True
										\Window = GetWindowFromGadget(\Gadget)
										PostEvent(#PB_Event_Gadget, \Window, EventGadget(), #DragCanvasGadget_EventType_Start)
									EndIf
								EndIf
								If (\Dragging)
									If (\SelX > \AnchorX)
										\LeftX  = \AnchorX
										\RightX = \SelX
										\DirX   =  1
									Else
										\LeftX  = \SelX
										\RightX = \AnchorX
										\DirX   = -1
									EndIf
									If (\SelY > \AnchorY)
										\TopY    = \AnchorY
										\BottomY = \SelY
										\DirY    =  1
									Else
										\TopY    = \SelY
										\BottomY = \AnchorY
										\DirY    = -1
									EndIf
									\X      = \SelX    - \AnchorX
									\Y      = \SelY    - \AnchorY
									\Width  = \RightX  - \LeftX
									\Height = \BottomY - \TopY
									PostEvent(#PB_Event_Gadget, \Window, EventGadget(), #DragCanvasGadget_EventType_Change)
								EndIf
							EndIf
					EndSelect
				EndIf
				
			EndWith
			
		EndProcedure
		
		; Update (make some extra calculation, layout, ...)
		Procedure DragCanvasGadget_Update(*DragCanvasGadget.DragCanvasGadget)
			
			With *DragCanvasGadget
				
				If \ProcUpdate
					CallCFunctionFast(\ProcUpdate)
				EndIf
				
			EndWith
			
		EndProcedure
		
		; Draw
		Procedure DragCanvasGadget_Draw(*DragCanvasGadget.DragCanvasGadget)
			
			With *DragCanvasGadget
				
				If \ProcDrawing
					CallCFunctionFast(\ProcDrawing)
				EndIf
				
			EndWith
			
		EndProcedure
		
		; Sends an event to update the gadget.
		Procedure DragCanvasGadget_PostUpdate(*DragCanvasGadget.DragCanvasGadget) 
			
			If *DragCanvasGadget\UpdatePosted = #False
				*DragCanvasGadget\UpdatePosted = #True
				PostEvent(#PB_Event_Gadget, *DragCanvasGadget\Window, *DragCanvasGadget\Number, #DragCanvasGadget_EventType_Updated, -1)
			EndIf
			
		EndProcedure
		
		; Callback for BindGadgetEvent()
		Procedure DragCanvasGadget_Callback()
			
			CompilerIf (#DragCanvasGadget_EnableCallbackGadgetCheck)
				If Not IsGadget(EventGadget())
					ProcedureReturn
				EndIf
			CompilerEndIf
			
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(EventGadget())
			
			If ((EventType() = #PB_EventType_LeftClick) Or
			    (EventType() = #PB_EventType_RightClick))
				If (Not DragCanvasGadget_ClickWasDragStop(*DragCanvasGadget))
					Debug "Click without drag"
				EndIf
			EndIf	
			
			With *DragCanvasGadget
				If EventType() >= #PB_EventType_FirstCustomValue
					
					Select EventType()
						Case #DragCanvasGadget_EventType_Start 
							;Debug "Start dragging"+" canvas "+Str(*DragCanvasGadget\Number)
							DragCanvasGadget_LockXY(*DragCanvasGadget,\CameraX, \CameraY)
						Case #DragCanvasGadget_EventType_Stop
							;Debug "Stop"
						Case  #DragCanvasGadget_EventType_Change
							;Debug "Dragging"
							If (DragCanvasGadget_Button(*DragCanvasGadget) = #PB_Canvas_MiddleButton)
								\CameraX = DragCanvasGadget_ScaleX(*DragCanvasGadget)
								\CameraY = DragCanvasGadget_ScaleY(*DragCanvasGadget)
							EndIf
							If DragCanvasGadget_StartVectorDrawing(*DragCanvasGadget)
								DragCanvasGadget_Update(*DragCanvasGadget)
								DragCanvasGadget_Draw(*DragCanvasGadget)
								DragCanvasGadget_StopVectorDrawing(*DragCanvasGadget)
							EndIf
						Case #DragCanvasGadget_EventType_Updated
							If DragCanvasGadget_StartVectorDrawing(*DragCanvasGadget)
								DragCanvasGadget_Examine(*DragCanvasGadget);
								DragCanvasGadget_Update(*DragCanvasGadget)
								DragCanvasGadget_Draw(*DragCanvasGadget)
								DragCanvasGadget_StopVectorDrawing(*DragCanvasGadget)
							Else
								*DragCanvasGadget\UpdatePosted = #False
							EndIf
					EndSelect
				Else
					If DragCanvasGadget_StartVectorDrawing(*DragCanvasGadget)
						DragCanvasGadget_Examine(*DragCanvasGadget);
						DragCanvasGadget_Update(*DragCanvasGadget)
						DragCanvasGadget_Draw(*DragCanvasGadget)
						DragCanvasGadget_StopVectorDrawing(*DragCanvasGadget)
					EndIf
				EndIf
				
			EndWith
			
		EndProcedure
		
		
		;-
		;-  4.2 Procedures for the Gadget
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		
		
		Procedure UpdateDragCanvasGadget(Gadget) 
			
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			
			If DragCanvasGadget_StartVectorDrawing(*DragCanvasGadget)
				DragCanvasGadget_Update(*DragCanvasGadget)
				DragCanvasGadget_Draw(*DragCanvasGadget)
				DragCanvasGadget_StopVectorDrawing(*DragCanvasGadget)
			EndIf
			
		EndProcedure
		
		Procedure FreeDragCanvasGadget(Gadget) 
			
			If Not IsGadget(Gadget)
				ProcedureReturn
			EndIf
			
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			SetGadgetData(Gadget, #Null)
			
			UnbindGadgetEvent(*DragCanvasGadget\Number, @DragCanvasGadget_Callback())
			FreeGadget(Gadget)
			ClearStructure(*DragCanvasGadget, DragCanvasGadget)
			FreeMemory(*DragCanvasGadget)
			
		EndProcedure
		
		Procedure DragCanvasGadget(Gadget, X, Y, Width, Height, Attributes = 0)
			
			Protected *DragCanvasGadget.DragCanvasGadget = AllocateMemory(SizeOf(DragCanvasGadget))
			Protected Result, OldGadgetList, DummyGadget, Window
			DummyGadget = TextGadget(#PB_Any,0,0,0,0,"")
			Window = GetWindowFromGadget(DummyGadget)
			FreeGadget(DummyGadget)
			InitializeStructure(*DragCanvasGadget, DragCanvasGadget)
			OldGadgetList = UseGadgetList(WindowID(Window))
			Result = CanvasGadget(Gadget, X, Y, Width, Height, Attributes)
			UseGadgetList(OldGadgetList)
			If Gadget = #PB_Any
				Gadget = Result
			EndIf
			SetGadgetData(Gadget, *DragCanvasGadget)
			
			
			
			With *DragCanvasGadget
				\Attributes                  = Attributes
				\Number                      = Gadget
				\Window                      = Window
				\DataValue									 = 0
				\Down 											 = #False
				\Dragging 									 = #False
				\Clamp 											 = #False
				\Threshold 							     = 3
				\ClickWasDrag 							 = #False
			EndWith
			
			BindGadgetEvent(Gadget, @DragCanvasGadget_Callback())
			
			UpdateDragCanvasGadget(Gadget)
			
			ProcedureReturn Result
			
		EndProcedure
		
		
		Procedure BindDragCanvasGadget(Gadget)
			BindGadgetEvent(Gadget, @DragCanvasGadget_Callback())
		EndProcedure
		
		Procedure UnBindDragCanvasGadget(Gadget)
			UnbindGadgetEvent(Gadget, @DragCanvasGadget_Callback())
		EndProcedure
		
		; You have to bind your own drawing procedure (for each canvas)
		Procedure BindDragCanvasGadgetDrawing(Gadget, Proc)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			*DragCanvasGadget\ProcDrawing = Proc
			UpdateDragCanvasGadget(Gadget)
		EndProcedure
		
		Procedure UnBindDragCanvasGadgetDrawing(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			*DragCanvasGadget\ProcDrawing = 0
			UpdateDragCanvasGadget(Gadget)
		EndProcedure
		
		; You have the possibility to bind your own update procedure (for each canvas),
		; to do extra calculations (for example) before drawing
		Procedure BindDragCanvasGadgetUpdate(Gadget, Proc)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			*DragCanvasGadget\ProcUpdate = Proc
			UpdateDragCanvasGadget(Gadget)
		EndProcedure
		
		Procedure UnBindDragCanvasGadgetUpdate(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			*DragCanvasGadget\ProcUpdate = 0
			UpdateDragCanvasGadget(Gadget)
		EndProcedure
		
		
		
		;-
		;-  4.3 Set- & Get-Procedure
		;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		
		
		Procedure GetDragCanvasGadgetAnchorX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\AnchorX)
		EndProcedure
		
		Procedure GetDragCanvasGadgetAnchorY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\AnchorY)
		EndProcedure
		
		Procedure GetDragCanvasGadgetBottomY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\BottomY)
		EndProcedure
		
		Procedure GetDragCanvasGadgetButton(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Button)
		EndProcedure
		
		Procedure SetDragCanvasGadgetCancel(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			With *DragCanvasGadget
				If (\Dragging)
					\Down = #False
					\Dragging = #False
				EndIf
			EndWith
		EndProcedure
		
		Procedure SetDragCanvasGadgetClamp(Gadget, State)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			With *DragCanvasGadget
				\Clamp = Bool(State)
			EndWith
		EndProcedure
		
		Procedure GetDragCanvasGadgetClickWasDragStop(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result 
			With *DragCanvasGadget
				Result= \ClickWasDrag
				\ClickWasDrag = #False
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetContainsBox(Gadget, x, y, Width, Height)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x >= \LeftX) And (x + \Width <= \RightX))
						If ((y >= \TopY) And (y + \Height <= \BottomY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetContainsPoint(Gadget, x, y)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x >= \LeftX) And (x <= \RightX))
						If ((y >= \TopY) And (y <= \BottomY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetCursorX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\SelX)
		EndProcedure
		
		Procedure GetDragCanvasGadgetCursorY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\SelY)
		EndProcedure
		
		Procedure SetDragCanvasGadgetData(Gadget, DataValue) 
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			*DragCanvasGadget\DataValue = DataValue
		EndProcedure
		
		Procedure GetDragCanvasGadgetData(Gadget) 
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)	
			ProcedureReturn *DragCanvasGadget\DataValue
		EndProcedure
		
		Procedure GetDragCanvasGadgetDatas(Gadget, Datas)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			With *DragCanvasGadget
				Select Datas
					Case #AnchorX:ProcedureReturn (*DragCanvasGadget\AnchorX)
					Case #AnchorY:ProcedureReturn (*DragCanvasGadget\AnchorY)
					Case #Attributes:ProcedureReturn (*DragCanvasGadget\Attributes)
					Case #BottomY:ProcedureReturn (*DragCanvasGadget\BottomY)
					Case #Button:ProcedureReturn (*DragCanvasGadget\Button)
					Case #CameraX:ProcedureReturn (*DragCanvasGadget\CameraX)
					Case #CameraY:ProcedureReturn (*DragCanvasGadget\CameraY)
					Case #Clamp:ProcedureReturn (*DragCanvasGadget\Clamp)
					Case #ClickWasDrag:ProcedureReturn (*DragCanvasGadget\ClickWasDrag)
					Case #DataValue:ProcedureReturn (*DragCanvasGadget\DataValue)
					Case #DirX:ProcedureReturn (*DragCanvasGadget\DirX)
					Case #DirY:ProcedureReturn (*DragCanvasGadget\DirY)
					Case #Down:ProcedureReturn (*DragCanvasGadget\Down)
					Case #Dragging:ProcedureReturn (*DragCanvasGadget\Dragging)
					Case #FontID:ProcedureReturn (*DragCanvasGadget\FontID)
					Case #Gadget:ProcedureReturn (*DragCanvasGadget\Gadget)
					Case #Height:ProcedureReturn (*DragCanvasGadget\Height)
					Case #LeftX:ProcedureReturn (*DragCanvasGadget\LeftX)
					Case #Number:ProcedureReturn (*DragCanvasGadget\Number)
					Case #PreviousSelX:ProcedureReturn (*DragCanvasGadget\PreviousSelX)
					Case #PreviousSelY:ProcedureReturn (*DragCanvasGadget\PreviousSelY)
					Case #ProcDrawing:ProcedureReturn (*DragCanvasGadget\ProcDrawing)
					Case #ProcUpdate:ProcedureReturn (*DragCanvasGadget\ProcUpdate)
					Case #RightX:ProcedureReturn (*DragCanvasGadget\RightX)
					Case #SelX:ProcedureReturn (*DragCanvasGadget\SelX)
					Case #SelY:ProcedureReturn (*DragCanvasGadget\SelY)
					Case #Threshold:ProcedureReturn (*DragCanvasGadget\Threshold)
					Case #TopY:ProcedureReturn (*DragCanvasGadget\TopY)
					Case #UpdatePosted:ProcedureReturn (*DragCanvasGadget\UpdatePosted)
					Case #UserX:ProcedureReturn (*DragCanvasGadget\UserX)
					Case #UserY:ProcedureReturn (*DragCanvasGadget\UserY)
					Case #Width:ProcedureReturn (*DragCanvasGadget\Width)
					Case #Window:ProcedureReturn (*DragCanvasGadget\Window)
					Case #X:ProcedureReturn (*DragCanvasGadget\X)
					Case #Y:ProcedureReturn (*DragCanvasGadget\Y)
						
					Default
						;?
						ProcedureReturn -1
				EndSelect
			EndWith
		EndProcedure
		
		Procedure GetDragCanvasGadgetDeltaX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result 
			With *DragCanvasGadget
				Result= \SelX - \PreviousSelX
				\PreviousSelX = \SelX
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetDeltaY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result 
			With *DragCanvasGadget
				Result= \SelY - \PreviousSelY
				\PreviousSelY = \SelY
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetDirX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\DirX)
		EndProcedure
		
		Procedure GetDragCanvasGadgetDirY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\DirY)
		EndProcedure
		
		Procedure GetDragCanvasGadgetDragging(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Dragging)
		EndProcedure
		
		Procedure GetDragCanvasGadget(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Gadget)
		EndProcedure
		
		Procedure GetDragCanvasGadgetHeight(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Height)
		EndProcedure
		
		Procedure GetDragCanvasGadgetIntersectsBox(Gadget, x, y, Width, Height)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			Protected Result = #False
			With *DragCanvasGadget
				If (\Dragging)
					If ((x <= \RightX) And (x + Width >= \LeftX))
						If ((y <= \BottomY) And (y + Height >= \TopY))
							Result = #True
						EndIf
					EndIf
				EndIf
			EndWith
			ProcedureReturn (Result)
		EndProcedure
		
		Procedure GetDragCanvasGadgetLeftX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\LeftX)
		EndProcedure
		
		Procedure SetDragCanvasGadgetLockXY(Gadget,UserX.d, UserY.d)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			With *DragCanvasGadget
				\UserX = UserX
				\UserY = UserY
			EndWith
		EndProcedure
		
		Procedure GetDragCanvasGadgetRelativeX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\X)
		EndProcedure
		
		Procedure GetDragCanvasGadgetRelativeY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Y)
		EndProcedure
		
		Procedure GetDragCanvasGadgetRightX(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\RightX)
		EndProcedure
		
		Procedure.d GetDragCanvasGadgetScaleX(Gadget, ScaleX.d = 1.0)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (ScaleX * *DragCanvasGadget\X + *DragCanvasGadget\UserX)
		EndProcedure
		
		Procedure.d GetDragCanvasGadgetScaleY(Gadget, ScaleY.d = 1.0)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (ScaleY * *DragCanvasGadget\Y + *DragCanvasGadget\UserY)
		EndProcedure
		
		Procedure GetDragCanvasGadgetTopY(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\TopY)
		EndProcedure
		
		Procedure SetDragCanvasGadgetThreshold(Gadget, Pixels)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			With *DragCanvasGadget
				If (Pixels >= 0)
					\Threshold = Pixels
				EndIf
			EndWith	
		EndProcedure
		
		Procedure GetDragCanvasGadgetWidth(Gadget)
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(Gadget)
			ProcedureReturn (*DragCanvasGadget\Width)
		EndProcedure
		
		
	EndModule
	
	
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	;-
	;-
	;- Demo Program
	
	CompilerIf (#PB_Compiler_IsMainFile)
		DisableExplicit
		
		UseModule DragCanvas
		
		; You can use the new event Start Dragging with this
		Procedure Demo_StartDraggingCanvas0()
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(EventGadget())
			Debug "Start dragging canvas " + Str(*DragCanvasGadget\Number)
		EndProcedure
		Procedure Demo_StartDraggingCanvas1()
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(EventGadget())
			Debug "HELLO Start dragging canvas " + Str(*DragCanvasGadget\Number)
		EndProcedure
		
		; You can use the new event Stop Dragging with this
		; Here i choose the same proc for both canvas0 and canvas1
		Procedure Demo_StopDragging()
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(EventGadget())
			Debug "Stop dragging canvas " + Str(*DragCanvasGadget\Number)
		EndProcedure
		
		; You can use the new event Dragging with this
		; Idem
		Procedure Demo_Dragging()
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(EventGadget())
			Debug "Dragging canvas " + Str(*DragCanvasGadget\Number)
		EndProcedure
		
		; Your own drawing procedure for the canvas 0
		; There are two ways to do that, here i use Getter and Setter procedures
		Procedure Demo_Drawcanvas0()
			
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(0)
			Protected Selecting, Color
			
			With *DragCanvasGadget
				Selecting= Bool(GetDragCanvasGadgetDragging(0) And (GetDragCanvasGadgetButton(0) <> #PB_Canvas_MiddleButton))
				
				; Clear background
				If (Selecting And GetDragCanvasGadgetContainsPoint(0, \CameraX + VectorOutputWidth()/2, \CameraY + VectorOutputHeight()/2))
					VectorSourceColor($FF0000FF);
				Else
					VectorSourceColor($FFC0FFFF)
				EndIf
				FillVectorOutput()
				
				
				; Draw box to select
				VectorSourceColor($FFC0C0C0)
				If (Selecting)
					If (GetDragCanvasGadgetDirX(0) > 0) And GetDragCanvasGadgetContainsBox(0, \CameraX + 100, \CameraY + 100, 50, 50)
						VectorSourceColor($FFFF0000)
					ElseIf (GetDragCanvasGadgetDirX(0) < 0) And GetDragCanvasGadgetIntersectsBox(0, \CameraX + 100, \CameraY + 100, 50, 50)
						VectorSourceColor($FF00FF00)
					EndIf
				EndIf
				AddPathBox(\CameraX + 100, \CameraY + 100, 50, 50)
				FillPath()
				
				; Draw text instructions
				VectorSourceColor($FFf0d0d0)
				VectorFont(FontID(0))
				MovePathCursor(\CameraX + 200, \CameraY + 100)
				DrawVectorText("Drag rightward for contain select")
				MovePathCursor(\CameraX + 200, \CameraY + 100 + VectorTextHeight(" "))
				DrawVectorText("Drag leftward for intersect select")
				MovePathCursor(\CameraX + 200, \CameraY + 100 + 2*VectorTextHeight(" "))
				DrawVectorText("Pan with the Middle mouse button")
				
				; Draw selection box
				If (Selecting)
					AddPathBox(GetDragCanvasGadgetLeftX(0), GetDragCanvasGadgetTopY(0), GetDragCanvasGadgetWidth(0) + 1, GetDragCanvasGadgetHeight(0) + 1)
					If (GetDragCanvasGadgetDirX(0) > 0)
						VectorSourceColor($FFFF0000)
						StrokePath(1)
					Else
						VectorSourceColor($FF00FF00)
						DashPath(1, 10)
					EndIf
					
				EndIf
				
			EndWith
		EndProcedure
		
		; Your own drawing procedure for the canvas 1
		; There are two ways to do that, here i use internal variables and procedures, it should be faster (?)
		Procedure Demo_Drawcanvas1()
			
			Protected *DragCanvasGadget.DragCanvasGadget = GetGadgetData(1)
			Protected Selecting, Color 
			
			With *DragCanvasGadget
				
				Selecting= Bool(\Dragging And (\Button <> #PB_Canvas_MiddleButton))
				
				
				; Clear background
				; 				If (Selecting And DragCanvasGadget_ContainsPoint(*DragCanvasGadget, \CameraX + VectorOutputWidth()/2, \CameraY + VectorOutputHeight()/2))
				; 					VectorSourceColor($FFC0FFFF)
				; 				Else
				VectorSourceColor($FFFFFFFF)
				; 				EndIf
				FillVectorOutput()
				
				; Draw box to select
				VectorSourceColor($FFC0C0C0)
				If (Selecting)
					If (\DirX > 0) And DragCanvasGadget_ContainsBox(*DragCanvasGadget, \CameraX + 100, \CameraY + 100, 50, 50)
						VectorSourceColor($FFFF0000);Bleu
					ElseIf (\DirX < 0) And DragCanvasGadget_IntersectsBox(*DragCanvasGadget, \CameraX + 100, \CameraY + 100, 50, 50)
						VectorSourceColor($FF00FF00);Vert
					EndIf
				EndIf
				AddPathBox(\CameraX + 100, \CameraY + 100, 50, 50)
				FillPath()
				
				; Draw text instructions
				VectorSourceColor($FFf0d0d0);violet clair
				VectorFont(FontID(0))
				MovePathCursor(\CameraX + 200, \CameraY + 100)
				DrawVectorText("Drag rightward for contain select")
				MovePathCursor(\CameraX + 200, \CameraY + 100 + VectorTextHeight(" "))
				DrawVectorText("Drag leftward for intersect select")
				MovePathCursor(\CameraX + 200, \CameraY + 100 + 2*VectorTextHeight(" "))
				DrawVectorText("Pan with the Middle mouse button")
				
				; Draw selection box
				If (Selecting)
					If (\DirX > 0)
						Color = #Blue
					Else
						Color = #Green
					EndIf
					Color | $FF000000
					AddPathBox(\LeftX, \TopY, \Width + 1, \Height + 1)
					VectorSourceColor(Color)
					If (\DirX > 0)
						StrokePath(1)
					Else
						DashPath(1, 10)
					EndIf
					
				EndIf
				
			EndWith
		EndProcedure	
		
		; We can choose to cancel a dragging movement with this
		Procedure Demo_Cancel(Gadget)
			SetDragCanvasGadgetCancel(Gadget)
			UpdateDragCanvasGadget(Gadget)
		EndProcedure
		
		
		
		;- main.......
		
		#Win = 10
		#Canvas0 = 0
		#Canvas1 = 1
		
		LoadFont(0, "Arial", 14)
		OpenWindow(#Win, 0, 0, 640, 490, "Canvas", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
		DragCanvasGadget(#Canvas0, 10, 10, 620, 230)
		DragCanvasGadget(#Canvas1, 10, 250,620, 230)
		
		; Some options
		; 		SetDragCanvasThreshold(0, 40)
		; 		SetDragCanvasClamp(0, #True)
		
		; To use the new events, either you use 'BindGadgetEvent()' or you use the main loop (see under)
		; Here i use 'BindGadgetEvent()' for the canvas 0 and the main loop for the canvas 1
		BindGadgetEvent(#Canvas0, @Demo_StartDraggingCanvas0(),#DragCanvasGadget_EventType_Start)
		BindGadgetEvent(#Canvas0, @Demo_StopDragging(),#DragCanvasGadget_EventType_Stop)
		BindGadgetEvent(#Canvas0, @Demo_Dragging(),#DragCanvasGadget_EventType_Change)
		
		; You could bind your own update procedure but no extra calculation to do here before drawing
		;	BindDragCanvasGadgetUpdate(...)
		
		; You have to bind your own drawing procedure
		BindDragCanvasGadgetDrawing(#Canvas0,@Demo_Drawcanvas0())
		BindDragCanvasGadgetDrawing(#Canvas1,@Demo_Drawcanvas1())
		
		
		;Esc to cancel a dragging movement
		AddKeyboardShortcut(#Win, #PB_Shortcut_Escape, 1)
		
		
		
		;- loop........
		Repeat
			event=WaitWindowEvent()
			
			Select Event
					
				Case #PB_Event_Menu            
					Select  EventMenu()
						Case 1;Menu Escape
							Demo_Cancel(0)
							Demo_Cancel(1)
					EndSelect
					
				Case #PB_Event_Gadget
					Select EventGadget()
						Case #Canvas0 
							Select (EventType())
								Case #PB_EventType_LeftButtonDown
									;Debug "main loop 0"
							EndSelect
						Case #Canvas1 
							Select (EventType())
								Case #PB_EventType_LeftButtonDown
									;Debug "main loop 1"
								Case #DragCanvasGadget_EventType_Start
									Demo_StartDraggingCanvas1()
								Case #DragCanvasGadget_EventType_Stop
									Demo_StopDragging()
								Case #DragCanvasGadget_EventType_Change
									Demo_Dragging()
							EndSelect
					EndSelect
					
			EndSelect
		Until Event = #PB_Event_CloseWindow
		
	CompilerEndIf
CompilerEndIf
;-



; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---------------------------
; EnableXP