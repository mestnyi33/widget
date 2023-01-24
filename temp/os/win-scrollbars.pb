; https://www.purebasic.fr/english/viewtopic.php?p=282837
; https://www.purebasic.fr/english/viewtopic.php?t=16166
; Title   : Owner-Draw Scrollbars
;
; Author  : Fluid Byte
; Version : PureBasic V4.30
; Platform: Windows
; E-Mail  : fluidbyte@web.de

Import ""
	PB_Gadget_SendGadgetCommand(hWnd,EventType)
EndImport 

; Core Parameters
#SCB_DefButtonCY = 17 ; Default button height for new scrollbars (XP-Standard)
#SCB_InitDelay = 450  ; Delay after first mouse click
#SCB_ScrollDelay = 40 ; Delay between steps during continuous scrolling
#SCB_ThumbMinCY = 7   ; Minimum height of scrollbar thumb

; States
Enumeration 1
	#SCBSV_Top_ButtonIn
	#SCBSV_Top_ButtonOut
	#SCBSV_Bottom_ButtonIn
	#SCBSV_Bottom_ButtonOut
	#SCBSH_Left_ButtonIn
	#SCBSH_Left_ButtonOut
	#SCBSH_Right_ButtonIn
	#SCBSH_Right_ButtonOut	
	#SCBSV_Top_ShapeIn
	#SCBSV_Bottom_ShapeIn
	#SCBSH_Left_ShapeIn
	#SCBSH_Right_ShapeIn	
	#SCBSV_Top_ShapeOut
	#SCBSV_Bottom_ShapeOut	
	#SCBSH_Left_ShapeOut	
	#SCBSH_Right_ShapeOut		
	#SCBSV_ThumbDrag
	#SCBSH_ThumbDrag
EndEnumeration

; Colors
Enumeration
	#SCB_Color_Light3D
	#SCB_Color_Highlight
	#SCB_Color_Face	
	#SCB_Color_Shadow
	#SCB_Color_DkShadow
	#SCB_Color_Shape
	#SCB_Color_ShapeClick
	#SCB_Color_Arrow
EndEnumeration

; Flags: Public
#SCB_Horizontal = 0
#SCB_Vertical = 1
#SCB_SystemColors = 2

; Flags: Private
#SCB_TrackInactive = 4
#SCB_Disabled = 8

Structure SCB_COLORS
	Face.l
	Highlight.l
	Light3D.l
	Shadow.l
	DkShadow.l
	Shape.l
	ShapeClick.l
	Arrow.l
EndStructure

Structure SCB_SCROLLDATA
	Min.l
	Max.l
	PageLength.l
	Value.l
	ButtonCY.w
	Flags.b
	hMenHorz.i
	hMenVert.i
	lpPrevFunc.i
	sclr.SCB_COLORS
EndStructure

; ------------------------------------------------------------------------------------------------------
;-PRIVATE FUNCTIONS
; ------------------------------------------------------------------------------------------------------

Procedure SCB_DrawShape(*scb.SCB_SCROLLDATA,hdc,X,Y,Width,Height,Arrow=0,State=0)
	Protected hPenFace, hbrFace, hPen3DLight, hPenDarkShadow, hPenHighlight, hPenShadow, hPenArrow

	If State
		; Mousedown
		hPenFace = CreatePen_(#PS_SOLID,1,*scb\sclr\Shadow)
		hbrFace = CreateSolidBrush_(*scb\sclr\Face)
		SelectObject_(hdc,hPenFace)
		SelectObject_(hdc,hbrFace)
		Rectangle_(hdc,X,Y,X + Width,Y + Height)
		DeleteObject_(hPenFace)
		DeleteObject_(hbrFace)
		X + 1 : Y + 1
	Else
		; Outter Box, Top/Left
		hPen3DLight = CreatePen_(#PS_SOLID,1,*scb\sclr\Light3D)
		SelectObject_(hdc,hPen3DLight)
		MoveToEx_(hdc,X,Y,0) : LineTo_(hdc,X + Width,Y)
		MoveToEx_(hdc,X,Y,0) : LineTo_(hdc,X,Y + Height)
		DeleteObject_(hPen3DLight)
	
		; Outter Box, Bottom/Right
		hPenDarkShadow = CreatePen_(#PS_SOLID,1,*scb\sclr\DkShadow)
		SelectObject_(hdc,hPenDarkShadow)
		MoveToEx_(hdc,X,Y + Height - 1,0) : LineTo_(hdc,X + Width,Y + Height - 1)
		MoveToEx_(hdc,X + Width - 1,Y,0) : LineTo_(hdc,X + Width - 1,Y + Height)
		DeleteObject_(hPenDarkShadow)
		
		; Inner Box, Top/Left
		hPenHighlight = CreatePen_(#PS_SOLID,1,*scb\sclr\Highlight)
		SelectObject_(hdc,hPenHighlight)
		MoveToEx_(hdc,X + 1,Y + 1,0) : LineTo_(hdc,X + Width - 2,Y + 1)
		MoveToEx_(hdc,X + 1,Y + 1,0) : LineTo_(hdc,X + 1,Y + Height - 2)
		DeleteObject_(hPenHighlight)
		
		; Inner Box, Bottom/Right
		hPenShadow = CreatePen_(#PS_SOLID,1,*scb\sclr\Shadow)
		SelectObject_(hdc,hPenShadow)
	 	MoveToEx_(hdc,X + 1,Y + Height - 2,0) : LineTo_(hdc,X + Width - 1,Y + Height - 2)
	 	MoveToEx_(hdc,X + Width - 2,Y + 1,0) : LineTo_(hdc,X + Width - 2,Y + Height - 2)
		DeleteObject_(hPenShadow)
		
		; Face
		hPenFace = CreatePen_(#PS_SOLID,1,*scb\sclr\Face)
		hbrFace = CreateSolidBrush_(*scb\sclr\Face)
		SelectObject_(hdc,hPenFace)
		SelectObject_(hdc,hbrFace)
	 	Rectangle_(hdc,X + 2,Y + 2,X + Width - 2,Y + Height - 2)
		DeleteObject_(hPenFace)
		DeleteObject_(hbrFace)
	EndIf
	
	; Arrows
	If Arrow
		If *scb\Flags & #SCB_Disabled
			hPenArrow = CreatePen_(#PS_SOLID,1,*scb\sclr\Shadow)			
		Else
			hPenArrow = CreatePen_(#PS_SOLID,1,*scb\sclr\Arrow)
		EndIf
		
		SelectObject_(hdc,hPenArrow)
		
		If Arrow < 3
			X + (Width / 2) - 3 : Y + (Height / 2) - 2
		Else
			X + (Width / 2) - 2 : Y + (Height / 2) - 3
		EndIf
		
		Select Arrow
			Case 1
			MoveToEx_(hdc,X + 3,Y + 0,0) : LineTo_(hdc,X + 4,Y + 0)
			MoveToEx_(hdc,X + 2,Y + 1,0) : LineTo_(hdc,X + 5,Y + 1)
			MoveToEx_(hdc,X + 1,Y + 2,0) : LineTo_(hdc,X + 6,Y + 2)
			MoveToEx_(hdc,X + 0,Y + 3,0) : LineTo_(hdc,X + 7,Y + 3)
			
			Case 2
			MoveToEx_(hdc,X + 3,Y + 3,0) : LineTo_(hdc,X + 4,Y + 3)
			MoveToEx_(hdc,X + 2,Y + 2,0) : LineTo_(hdc,X + 5,Y + 2)
			MoveToEx_(hdc,X + 1,Y + 1,0) : LineTo_(hdc,X + 6,Y + 1)
			MoveToEx_(hdc,X + 0,Y + 0,0) : LineTo_(hdc,X + 7,Y + 0)
			
			Case 3
			MoveToEx_(hdc,X + 0,Y + 3,0) : LineTo_(hdc,X + 0,Y + 4)
			MoveToEx_(hdc,X + 1,Y + 2,0) : LineTo_(hdc,X + 1,Y + 5)
			MoveToEx_(hdc,X + 2,Y + 1,0) : LineTo_(hdc,X + 2,Y + 6)
			MoveToEx_(hdc,X + 3,Y + 0,0) : LineTo_(hdc,X + 3,Y + 7)
			
			Case 4
			MoveToEx_(hdc,X + 3,Y + 3,0) : LineTo_(hdc,X + 3,Y + 4)
			MoveToEx_(hdc,X + 2,Y + 2,0) : LineTo_(hdc,X + 2,Y + 5)
			MoveToEx_(hdc,X + 1,Y + 1,0) : LineTo_(hdc,X + 1,Y + 6)
			MoveToEx_(hdc,X + 0,Y + 0,0) : LineTo_(hdc,X + 0,Y + 7)		
		EndSelect
		
		DeleteObject_(hPenArrow)
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_ContainerProc(hWnd,uMsg,wParam,lParam)
	Static TX, TY, TW, TH, State, tmpState, tmpMX, tmpMY, tmpDiff
	
	Protected crc.RECT, MX, MY, SBW, SBH, *scb.SCB_SCROLLDATA = GetWindowLongPtr_(hwnd,#GWL_USERDATA)
	
	GetClientRect_(hwnd,crc) : SBW = crc\right : SBH = crc\bottom

	Select uMsg
		;-// #WM_COMMAND //
		
		Case #WM_COMMAND
		Select wParam & $FFFF
			Case 4096 : *scb\Value - 1
			Case 4097 : *scb\Value + 1
			Case 4098 : *scb\Value - *scb\PageLength
			Case 4099 : *scb\Value + *scb\PageLength
			Case 4102 : *scb\Value = 0
			Case 4103 : *scb\Value = *scb\Max
			
			Case 4100
			If *scb\Flags & #SCB_Vertical
				*scb\Value = (tmpMY - *scb\ButtonCY - TH/2) * *scb\Max / (SBH - ((*scb\ButtonCY * 2) + TH))
			Else
				*scb\Value = (tmpMX - *scb\ButtonCY - TW/2) * *scb\Max / (SBW - ((*scb\ButtonCY * 2) + TW))
			EndIf
		EndSelect
		
		If *scb\Value < 0 : *scb\Value = 0 : EndIf
		If *scb\Value > *scb\Max : *scb\Value = *scb\Max : EndIf	

		InvalidateRect_(hwnd,0,0)
		
		ProcedureReturn 0

		;-// #WM_DESTROY //
		
		Case #WM_DESTROY
		DestroyMenu_(*scb\hMenHorz) : DestroyMenu_(*scb\hMenVert) : FreeMemory(*scb)
		ProcedureReturn 0
		
 		;-// #WM_ENABLE //
 		
      Case #WM_ENABLE 		
		If wParam = 0 : *scb\Flags | #SCB_Disabled : Else : *scb\Flags &~ #SCB_Disabled  : EndIf
 		ProcedureReturn 0
 				
		;-// #WM_ERASEBKGND //

 		Case #WM_ERASEBKGND
 		ProcedureReturn 0

		;-// #WM_LBUTTONDOWN //
		
      Case #WM_LBUTTONDOWN
      MX = lParam & $FFFF : MY = lParam >> 16

      If *scb\Flags & #SCB_Vertical
			; VERT -> Track Button [Top]
			If MY < *scb\ButtonCY
				State = #SCBSV_Top_ButtonIn
				If *scb\Value > 0 : *scb\Value - 1 : EndIf
			EndIf
			
			; VERT -> Track Button [Bottom]
	 		If MY >= (SBH - *scb\ButtonCY)
				State = #SCBSV_Bottom_ButtonIn
				If *scb\Value < *scb\Max : *scb\Value + 1 : EndIf
			EndIf
			
			; VERT -> Trackbar
			If *scb\Flags & #SCB_TrackInactive = 0
				TH = (SBH - (*scb\ButtonCY * 2)) * *scb\PageLength / *scb\Max
				If TH < #SCB_ThumbMinCY : TH = #SCB_ThumbMinCY : EndIf
				TY = (*scb\ButtonCY + ((SBH - TH - (*scb\ButtonCY * 2))) * *scb\Value / *scb\Max)

				If MY >= TY And MY < (TY + TH)
					State = #SCBSV_ThumbDrag
					tmpMY = MY : tmpState = *scb\Value : tmpDiff = *scb\Value
				EndIf	
			EndIf
			
			; VERT -> Backshape
			If MY >= *scb\ButtonCY And MY < (SBH - *scb\ButtonCY) And State = 0
				If MY < TY
					State = #SCBSV_Top_ShapeIn : tmpMY = MY
					*scb\Value - *scb\PageLength
					If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf
				Else
					State = #SCBSV_Bottom_ShapeIn : tmpMY = MY
					*scb\Value + *scb\PageLength
					If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
				EndIf
			EndIf
		Else
			; HORZ -> Track Button [Left]
			If MX < *scb\ButtonCY
				State = #SCBSH_Left_ButtonIn
				If *scb\Value > 0 : *scb\Value - 1 : EndIf
			EndIf
			
			; HORZ -> Track Button [Right]
	 		If MX >= (SBW - *scb\ButtonCY)
				State = #SCBSH_Right_ButtonIn
				If *scb\Value < *scb\Max : *scb\Value + 1 : EndIf
			EndIf	
			
			; HORZ -> Trackbar
			If *scb\Flags & #SCB_TrackInactive = 0
				TW = (SBW - (*scb\ButtonCY * 2)) * *scb\PageLength / *scb\Max
				If TW < #SCB_ThumbMinCY : TW = #SCB_ThumbMinCY : EndIf
				TX = *scb\ButtonCY + ((SBW - TW - (*scb\ButtonCY * 2))) * *scb\Value / *scb\Max

				If MX >= TX And MX < (TX + TW)
					State = #SCBSH_ThumbDrag
					tmpMX = MX : tmpState = *scb\Value : tmpDiff = *scb\Value
				EndIf
			EndIf
			
			; HORZ -> Backshape
			If MX >= *scb\ButtonCY And MX < (SBW - *scb\ButtonCY) And State = 0
				If MX < TX
					State = #SCBSH_Left_ShapeIn : tmpMX = MX
					*scb\Value - *scb\PageLength
					If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf	
				Else
					State = #SCBSH_Right_ShapeIn : tmpMX = MX
					*scb\Value + *scb\PageLength
					If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
				EndIf
			EndIf				
		EndIf

		If State ! #SCBSV_ThumbDrag And State ! #SCBSH_ThumbDrag
			SetTimer_(hwnd,0,#SCB_InitDelay,0) : InvalidateRect_(hwnd,0,0)
		EndIf

		SetCapture_(hwnd)	: PB_Gadget_SendGadgetCommand(hwnd,0)
     	
     	ProcedureReturn 0
     	
     	;-// #WM_LBUTTONUP //
     	
      Case #WM_LBUTTONUP
      State = 0
      KillTimer_(hwnd,0) : KillTimer_(hwnd,1)
      ReleaseCapture_() : InvalidateRect_(hwnd,0,0)
      ProcedureReturn 0
		
		;-// #WM_MOUSEMOVE //
		
     	Case #WM_MOUSEMOVE
      MX = lParam & $FFFF : MY = lParam >> 16
     	
     	If *scb\Flags & #SCB_Vertical
	     	; VERT -> Track Button [Top]
			If MX < SBW And MY >= 0 And MY < *scb\ButtonCY
				If State = #SCBSV_Top_ButtonOut
					State = #SCBSV_Top_ButtonIn
					If *scb\Value > *scb\Min : *scb\Value - 1 : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
			ElseIf State = #SCBSV_Top_ButtonIn
				State = #SCBSV_Top_ButtonOut
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			EndIf
			
			; VERT -> Track Button [Bottom]
			If MX < SBW And MY >= (SBH - *scb\ButtonCY) And MY < SBH
				If State = #SCBSV_Bottom_ButtonOut
					State = #SCBSV_Bottom_ButtonIn
					If *scb\Value < *scb\Max : *scb\Value + 1 : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
			ElseIf State = #SCBSV_Bottom_ButtonIn
				State = #SCBSV_Bottom_ButtonOut				
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			EndIf
			
			; VERT -> Trackbar
			If State = #SCBSV_ThumbDrag
				*scb\Value = tmpState + ((MY - tmpMY) * *scb\Max) / (SBH - ((*scb\ButtonCY * 2) + TH))											
				If *scb\Value < *scb\Min : *scb\Value = *scb\Min : EndIf
				If *scb\Value > *scb\Max : *scb\Value = *scb\Max : EndIf
				If *scb\Value <> tmpDiff : tmpDiff = *scb\Value : PB_Gadget_SendGadgetCommand(hwnd,0) : EndIf
				InvalidateRect_(hwnd,0,0)
			EndIf
			
			; VERT -> Backshape
			If MX >=0 And MX < SBW
				If State = #SCBSV_Top_ShapeIn Or State = #SCBSV_Bottom_ShapeIn : tmpMY = MY : EndIf
				
				If MY < TY And State = #SCBSV_Top_ShapeOut
					State = #SCBSV_Top_ShapeIn
					*scb\Value - *scb\PageLength
					If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
							
				If MY > TY + TH And State = #SCBSV_Bottom_ShapeOut
					State = #SCBSV_Bottom_ShapeIn
					*scb\Value + *scb\PageLength
					If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf					
			ElseIf State = #SCBSV_Top_ShapeIn
				State = #SCBSV_Top_ShapeOut
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			ElseIf State = #SCBSV_Bottom_ShapeIn
				State = #SCBSV_Bottom_ShapeOut
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			EndIf	
		Else
	     	; HORZ -> Track Button [Left]
			If MX >= 0 And MX < *scb\ButtonCY And MY >= 0 And MY < SBH
				If State = #SCBSH_Left_ButtonOut
					State = #SCBSH_Left_ButtonIn
					If *scb\Value > *scb\Min : *scb\Value - 1 : EndIf					
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
			ElseIf State = #SCBSH_Left_ButtonIn		
				State = #SCBSH_Left_ButtonOut				
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			EndIf
			
			; HORZ -> Track Button [Right]
			If MX >= (SBW - *scb\ButtonCY) And MX < SBW And MY >= 0 And MY < SBH
				If State = #SCBSH_Right_ButtonOut
					State = #SCBSH_Right_ButtonIn
					If *scb\Value < *scb\Max : *scb\Value + 1 : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
			ElseIf State = #SCBSH_Right_ButtonIn
				State = #SCBSH_Right_ButtonOut				
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			EndIf
			
			; HORZ -> Trackbar
			If State = #SCBSH_ThumbDrag
				*scb\Value = tmpState + ((MX - tmpMX) * *scb\Max) / (SBW - ((*scb\ButtonCY * 2) + TW))							
				If *scb\Value < *scb\Min : *scb\Value = *scb\Min : EndIf
				If *scb\Value > *scb\Max : *scb\Value = *scb\Max : EndIf			 		
	 			If *scb\Value <> tmpDiff : tmpDiff = *scb\Value : PB_Gadget_SendGadgetCommand(hwnd,0) : EndIf
	 			InvalidateRect_(hwnd,0,0)
			EndIf
			
			; HORZ -> Backshape
			If MY >=0 And MY < SBH
				If State = #SCBSH_Left_ShapeIn Or State = #SCBSH_Right_ShapeIn : tmpMX = MX : EndIf
				
				If MX < TX And State = #SCBSH_Left_ShapeOut
					State = #SCBSH_Left_ShapeIn
					*scb\Value - *scb\PageLength
					If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf	
							
				If MX > TX + TW And State = #SCBSH_Right_ShapeOut 
					State = #SCBSH_Right_ShapeIn
					*scb\Value + *scb\PageLength
					If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
					SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : InvalidateRect_(hwnd,0,0)
				EndIf
			ElseIf State = #SCBSH_Left_ShapeIn
				State = #SCBSH_Left_ShapeOut
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)
			ElseIf State = #SCBSH_Right_ShapeIn
				State = #SCBSH_Right_ShapeOut
				KillTimer_(hwnd,0) : KillTimer_(hwnd,1) : InvalidateRect_(hwnd,0,0)			
			EndIf
		EndIf
		
      ProcedureReturn 0
      
      ;-// #WM_PAINT //
      
		Case #WM_PAINT
		Protected hdc, ps.PAINTSTRUCT, hdcMem, hbmOutput, hbrBackshape

		hdc = BeginPaint_(hwnd,ps)			
		hdcMem = CreateCompatibleDC_(hdc)
		hbmOutput = CreateCompatibleBitmap_(hdc,SBW,SBH)
		SelectObject_(hdcMem,hbmOutput)
		
		; -> Backshape
		hbrBackshape = CreateSolidBrush_(*scb\sclr\Shape)		
		FillRect_(hdcMem,crc,hbrBackshape)
		DeleteObject_(hbrBackshape)
					
		If *scb\Flags & #SCB_Vertical
			; VERT -> Track Button [TOP]
			If State = #SCBSV_Top_ButtonIn
				SCB_DrawShape(*scb,hdcMem,0,0,SBW,*scb\ButtonCY,1,1)
			Else
				SCB_DrawShape(*scb,hdcMem,0,0,SBW,*scb\ButtonCY,1)
			EndIf
			
			; VERT -> Track Button [BOTTOM]
			If State = #SCBSV_Bottom_ButtonIn
				SCB_DrawShape(*scb,hdcMem,0,SBH - *scb\ButtonCY,SBW,*scb\ButtonCY,2,1)
			Else
				SCB_DrawShape(*scb,hdcMem,0,SBH - *scb\ButtonCY,SBW,*scb\ButtonCY,2)
			EndIf
			
			; VERT -> Trackbar
			If *scb\Flags & #SCB_Disabled = 0 And *scb\Flags & #SCB_TrackInactive = 0
				TH = (SBH - (*scb\ButtonCY * 2)) * *scb\PageLength / *scb\Max
				If TH < #SCB_ThumbMinCY : TH = #SCB_ThumbMinCY : EndIf
				TY = *scb\ButtonCY + ((SBH - TH - (*scb\ButtonCY * 2))) * *scb\Value / *scb\Max				
				SCB_DrawShape(*scb,hdcMem,0,TY,SBW,TH)
			EndIf		
		Else
			; HORZ -> Track Button [LEFT]		
			If State = #SCBSH_Left_ButtonIn
				SCB_DrawShape(*scb,hdcMem,0,0,*scb\ButtonCY,SBH,3,1)
			Else
				SCB_DrawShape(*scb,hdcMem,0,0,*scb\ButtonCY,SBH,3)
			EndIf	
			
			; HORZ -> Track Button [RIGHT]
			If State = #SCBSH_Right_ButtonIn
				SCB_DrawShape(*scb,hdcMem,SBW - *scb\ButtonCY,0,*scb\ButtonCY,SBH,4,1)
			Else
				SCB_DrawShape(*scb,hdcMem,SBW - *scb\ButtonCY,0,*scb\ButtonCY,SBH,4)
			EndIf	
			
			; HORZ -> Trackbar
			If *scb\Flags & #SCB_Disabled = 0 And *scb\Flags & #SCB_TrackInactive = 0
				TW = (SBW - (*scb\ButtonCY * 2)) * *scb\PageLength / *scb\Max
				If TW < #SCB_ThumbMinCY : TW = #SCB_ThumbMinCY : EndIf
				TX = *scb\ButtonCY + ((SBW - TW - (*scb\ButtonCY * 2))) * *scb\Value / *scb\Max
				SCB_DrawShape(*scb,hdcMem,TX,0,TW,SBH)
			EndIf			
		EndIf
		
		; -> Shapeclick
		If State >= #SCBSV_Top_ShapeIn And State <= #SCBSH_Right_ShapeIn
			hbrBackshape = CreateSolidBrush_(*scb\sclr\ShapeClick)			
			Select State
				Case #SCBSV_Top_ShapeIn    : SetRect_(crc,0,*scb\ButtonCY,SBW,TY)
				Case #SCBSV_Bottom_ShapeIn : SetRect_(crc,0,TY + TH,SBW,crc\bottom - *scb\ButtonCY)
				Case #SCBSH_Left_ShapeIn   : SetRect_(crc,*scb\ButtonCY,0,TX,SBH)
				Case #SCBSH_Right_ShapeIn  : SetRect_(crc,TX + TW,0,crc\right - *scb\ButtonCY,SBH)				
			EndSelect
			FillRect_(hdcMem,crc,hbrBackshape)
			DeleteObject_(hbrBackshape)
		EndIf
		
		; -> Blit Bitmap to Screen
		BitBlt_(hdc,0,0,SBW,SBH,hdcMem,0,0,#SRCCOPY)
		DeleteDC_(hdcMem)
		DeleteObject_(hbmOutput)
		
		EndPaint_(hwnd,ps)

		ProcedureReturn 0
		
		;-// #WM_RBUTTONDOWN //

		Case #WM_RBUTTONDOWN
		If State = 0
			Protected ppt.POINT
			ppt\x = lParam & $FFFF : ppt\y = lParam >> 16
			tmpMX = ppt\x : tmpMY = ppt\y : tmpState = *scb\Value
			ClientToScreen_(hwnd,ppt)
			If *scb\Flags & #SCB_Vertical
				TrackPopupMenu_(GetSubMenu_(*scb\hMenVert,0),0,ppt\x,ppt\y,0,hwnd,0)
			Else
				TrackPopupMenu_(GetSubMenu_(*scb\hMenHorz,0),0,ppt\x,ppt\y,0,hwnd,0)
			EndIf
		EndIf			
		ProcedureReturn 0
		
		;-// #WM_SIZE //
		
		Case #WM_SIZE
		InvalidateRect_(hwnd,0,0) : UpdateWindow_(hwnd)	
		ProcedureReturn 0

		;-// #WM_TIMER //
		
		Case #WM_TIMER
		If wParam = 0 : KillTimer_(hwnd,0) : SetTimer_(hwnd,1,#SCB_ScrollDelay,0) : EndIf
		
		Select State
			Case #SCBSV_Top_ButtonIn, #SCBSH_Left_ButtonIn
      	If *scb\Value > *scb\Min : *scb\Value - 1 : EndIf
      	PB_Gadget_SendGadgetCommand(hwnd,0)
      	
      	Case #SCBSV_Bottom_ButtonIn, #SCBSH_Right_ButtonIn
     		If *scb\Value < *scb\Max : *scb\Value + 1 : EndIf
     		PB_Gadget_SendGadgetCommand(hwnd,0)
     		
     		Case #SCBSV_Top_ShapeIn
      	If tmpMY < TY
				*scb\Value - *scb\PageLength
				If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf
				PB_Gadget_SendGadgetCommand(hwnd,0)
			EndIf
     		
     		Case #SCBSV_Bottom_ShapeIn
			If tmpMY > TY + TH
				*scb\Value + *scb\PageLength
				If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
				PB_Gadget_SendGadgetCommand(hwnd,0)
			EndIf
			
     		Case #SCBSH_Left_ShapeIn
      	If tmpMX < TX
				*scb\Value - *scb\PageLength
				If *scb\Value < *scb\Min + *scb\PageLength : *scb\Value = *scb\Min : EndIf
				PB_Gadget_SendGadgetCommand(hwnd,0)
			EndIf
     		
     		Case #SCBSH_Right_ShapeIn
			If tmpMX > TX + TW
				*scb\Value + *scb\PageLength
				If *scb\Value > *scb\Max - *scb\PageLength : *scb\Value = *scb\Max : EndIf
				PB_Gadget_SendGadgetCommand(hwnd,0)
			EndIf 			
		EndSelect		
		
		InvalidateRect_(hwnd,0,0)

		ProcedureReturn 0
		
		;-// #WM_WINDOWPOSCHANGING //
		
		Case #WM_WINDOWPOSCHANGING
		Protected *lpwp.WINDOWPOS = lParam, MinVal = *scb\ButtonCY * 2
		
		*scb\Flags &~ #SCB_TrackInactive
		
		If *scb\Flags & #SCB_Vertical
			If *lpwp\cy < MinVal : *lpwp\cy = MinVal : EndIf
			If *lpwp\cy < MinVal + #SCB_ThumbMinCY : *scb\Flags | #SCB_TrackInactive : EndIf	
		Else
			If *lpwp\cx < MinVal : *lpwp\cx = MinVal : EndIf			
			If *lpwp\cx < MinVal + #SCB_ThumbMinCY : *scb\Flags | #SCB_TrackInactive : EndIf
		EndIf
		
		ProcedureReturn 0
	EndSelect
	
	ProcedureReturn CallWindowProc_(*scb\lpPrevFunc,hWnd,uMsg,wParam,lParam)
EndProcedure

; ------------------------------------------------------------------------------------------------------
;-BASE FUNCTIONS
; ------------------------------------------------------------------------------------------------------

Procedure SCB_CreateScrollbar(Gadget,X,Y,Width,Height,Min,Max,PageLength,Flags=0)
	Protected Result, hwndContainer, hLibUser32, *scb.SCB_SCROLLDATA
	
	Result = ContainerGadget(Gadget,X,Y,Width,Height) : CloseGadgetList()

	If Gadget = #PB_Any : hwndContainer = GadgetID(Result) : Else : hwndContainer = Result : EndIf
	
	hLibUser32 = OpenLibrary(#PB_Any,"user32.dll")

	If Min < 0 : Min = 0 : EndIf
	If Max > $7FFFFFFF : Max = $7FFFFFFF: EndIf
 	
	*scb = AllocateMemory(SizeOf(SCB_SCROLLDATA))
	*scb\Min = Min
	*scb\Max = Max
	*scb\PageLength = PageLength
	*scb\ButtonCY = #SCB_DefButtonCY
	*scb\Flags = Flags
	*scb\hMenHorz = LoadMenu_(LibraryID(hLibUser32),"#64")
	*scb\hMenVert = LoadMenu_(LibraryID(hLibUser32),"#80")
	*scb\lpPrevFunc = SetWindowLongPtr_(hwndContainer,#GWL_WNDPROC,@SCB_ContainerProc())
	
	If Flags & #SCB_SystemColors
		*scb\sclr\Face = GetSysColor_(#COLOR_3DFACE)
		*scb\sclr\Highlight = GetSysColor_(#COLOR_3DHIGHLIGHT)
		*scb\sclr\Light3D = GetSysColor_(#COLOR_3DLIGHT)
		*scb\sclr\Shadow = GetSysColor_(#COLOR_3DSHADOW)
		*scb\sclr\DkShadow = GetSysColor_(#COLOR_3DDKSHADOW)
		*scb\sclr\Shape = GetSysColor_(#COLOR_3DHIGHLIGHT)
		*scb\sclr\Arrow = GetSysColor_(#COLOR_BTNTEXT)
	EndIf
	
	SetWindowLongPtr_(hwndContainer,#GWL_USERDATA,*scb)

	CloseLibrary(hLibUser32)

	ProcedureReturn Result
EndProcedure

; ------------------------------------------------------------------------------------------------------
;-GADGET INFORMATION
; ------------------------------------------------------------------------------------------------------

Procedure SCB_GetGadgetColor(Gadget,Type)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA), Color		
		Select Type
			Case #SCB_Color_Face       : Color = *scb\sclr\Face
			Case #SCB_Color_Highlight  : Color = *scb\sclr\Highlight
			Case #SCB_Color_Light3D    : Color = *scb\sclr\Light3D
			Case #SCB_Color_Shadow     : Color = *scb\sclr\Shadow
			Case #SCB_Color_DkShadow   : Color = *scb\sclr\DkShadow
			Case #SCB_Color_Shape      : Color = *scb\sclr\Shape
			Case #SCB_Color_ShapeClick : Color = *scb\sclr\ShapeClick
			Case #SCB_Color_Arrow      : Color = *scb\sclr\Arrow
		EndSelect
		ProcedureReturn Color
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetColorIndirect(Gadget,*sclr.SCB_COLORS)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		*sclr\Face = *scb\sclr\Face
		*sclr\Highlight = *scb\sclr\Highlight
		*sclr\Light3D = *scb\sclr\Light3D
		*sclr\Shadow = *scb\sclr\Shadow
		*sclr\DkShadow = *scb\sclr\DkShadow
		*sclr\Shape = *scb\sclr\Shape
		*sclr\ShapeClick = *scb\sclr\ShapeClick
		*sclr\Arrow = *scb\sclr\Arrow
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetGadgetState(Gadget)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		ProcedureReturn *scb\Value
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetGadgetMin(Gadget)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		ProcedureReturn *scb\Min
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetGadgetMax(Gadget)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		ProcedureReturn *scb\Max
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetGadgetPage(Gadget)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		ProcedureReturn *scb\PageLength
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_GetButtonHeight(Gadget)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		ProcedureReturn *scb\ButtonCY
	EndIf
EndProcedure

; ------------------------------------------------------------------------------------------------------
;-GADGET MODIFICATION
; ------------------------------------------------------------------------------------------------------

Procedure SCB_SetGadgetColor(Gadget,Type,Color)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)		
		Select Type
			Case #SCB_Color_Face       : *scb\sclr\Face = Color
			Case #SCB_Color_Highlight  : *scb\sclr\Highlight = Color
			Case #SCB_Color_Light3D    : *scb\sclr\Light3D = Color
			Case #SCB_Color_Shadow     : *scb\sclr\Shadow = Color
			Case #SCB_Color_DkShadow   : *scb\sclr\DkShadow = Color
			Case #SCB_Color_Shape      : *scb\sclr\Shape = Color
			Case #SCB_Color_ShapeClick : *scb\sclr\ShapeClick = Color
			Case #SCB_Color_Arrow      : *scb\sclr\Arrow = Color
		EndSelect
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetColorIndirect(Gadget,*sclr.SCB_COLORS)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		*scb\sclr\Face = *sclr\Face
		*scb\sclr\Highlight = *sclr\Highlight
		*scb\sclr\Light3D = *sclr\Light3D
		*scb\sclr\Shadow = *sclr\Shadow
		*scb\sclr\DkShadow = *sclr\DkShadow
		*scb\sclr\Shape = *sclr\Shape
		*scb\sclr\ShapeClick = *sclr\ShapeClick
		*scb\sclr\Arrow = *sclr\Arrow
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetGadgetState(Gadget,State)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		If State >= 0 And State <= *scb\Max : *scb\Value = State : EndIf		
		InvalidateRect_(GadgetID(Gadget),0,0)
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetGadgetMin(Gadget,Min)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		If Min < 0 : Min = 0 : EndIf : *scb\Min = Min
		InvalidateRect_(GadgetID(Gadget),0,0)
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetGadgetMax(Gadget,Max)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		If Max > $7FFFFFFF : Max = $7FFFFFFF : EndIf : *scb\Max = Max
		InvalidateRect_(GadgetID(Gadget),0,0)
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetGadgetPage(Gadget,PageLength)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		If PageLength >= 0 : *scb\PageLength = PageLength : EndIf
		InvalidateRect_(GadgetID(Gadget),0,0)
		ProcedureReturn 1
	EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Procedure SCB_SetButtonHeight(Gadget,Height)
	If IsGadget(Gadget)
		Protected *scb.SCB_SCROLLDATA = GetWindowLongPtr_(GadgetID(Gadget),#GWL_USERDATA)
		If Height < 5 : Height = 5 : EndIf
		If Height > 255 : Height = 255 : EndIf
		*scb\ButtonCY = Height : InvalidateRect_(GadgetID(Gadget),0,0)
		ProcedureReturn 1
	EndIf
EndProcedure


;\\
EnableExplicit

;;XIncludeFile "Scrollbar.pbi"

Define EventID, i, sclr.SCB_COLORS, CXVS = GetSystemMetrics_(#SM_CXVSCROLL)

OpenWindow(0,0,0,600,400,"OwnerDraw Scrollbar",#WS_OVERLAPPEDWINDOW | 1)
SetWindowColor(0,RGB(230,230,230))

; // VERTICAL SCROLLBARS //

SCB_CreateScrollbar(0,0,0,0,0,0,100,10,#SCB_Vertical | #SCB_SystemColors)
SCB_CreateScrollbar(1,0,0,0,0,0,100,10,#SCB_Vertical)
SCB_CreateScrollbar(2,0,0,0,0,0,100,10,#SCB_Vertical)
SCB_CreateScrollbar(3,0,0,0,0,0,100,10,#SCB_Vertical)
SCB_CreateScrollbar(4,0,0,0,0,0,100,10,#SCB_Vertical)

SCB_SetGadgetColor(1,#SCB_Color_Light3D,RGB(255,191,0))
SCB_SetGadgetColor(1,#SCB_Color_Highlight,RGB(255,227,145))
SCB_SetGadgetColor(1,#SCB_Color_Face,RGB(255,191,0))
SCB_SetGadgetColor(1,#SCB_Color_Shadow,RGB(234,147,0))
SCB_SetGadgetColor(1,#SCB_Color_DkShadow,RGB(170,106,0))
SCB_SetGadgetColor(1,#SCB_Color_Shape,RGB(255,227,145))
SCB_SetGadgetColor(1,#SCB_Color_Arrow,RGB(149,74,0))

SCB_SetGadgetColor(2,#SCB_Color_Light3D,RGB(96,175,37))
SCB_SetGadgetColor(2,#SCB_Color_Highlight,RGB(96,175,37))
SCB_SetGadgetColor(2,#SCB_Color_Face,RGB(138,218,80))
SCB_SetGadgetColor(2,#SCB_Color_Shadow,RGB(96,175,37))
SCB_SetGadgetColor(2,#SCB_Color_DkShadow,RGB(96,175,37))
SCB_SetGadgetColor(2,#SCB_Color_Shape,RGB(202,238,174))

SCB_SetGadgetColor(3,#SCB_Color_Highlight,$bbbbbb)
SCB_SetGadgetColor(3,#SCB_Color_Face,#White)
SCB_SetGadgetColor(3,#SCB_Color_Shadow,$bbbbbb)
SCB_SetGadgetColor(3,#SCB_Color_Shape,#White)

sclr\Highlight = RGB(143,152,157)
sclr\Face = RGB(95,104,109)
sclr\Shadow = RGB(143,152,157)
sclr\Shape = RGB(61,70,75)
SCB_SetColorIndirect(4,sclr)

SCB_SetButtonHeight(0,CXVS)
SCB_SetButtonHeight(1,23)
SCB_SetButtonHeight(2,23)
SCB_SetButtonHeight(3,23)
SCB_SetButtonHeight(4,23)

SCB_SetGadgetState(0,5)
SCB_SetGadgetState(1,25)
SCB_SetGadgetState(2,15)
SCB_SetGadgetState(3,35)
SCB_SetGadgetState(4,10)

; // HORIZONTAL SCROLLBARS //

SCB_CreateScrollbar(5,0,0,0,0,0,100,10,#SCB_SystemColors)
SCB_CreateScrollbar(6,0,0,0,0,0,100,10)
SCB_CreateScrollbar(7,0,0,0,0,0,100,10)
SCB_CreateScrollbar(8,0,0,0,0,0,100,10)
SCB_CreateScrollbar(9,0,0,0,0,0,100,10)

SCB_GetColorIndirect(1,sclr) : SCB_SetColorIndirect(6,sclr)
SCB_GetColorIndirect(2,sclr) : SCB_SetColorIndirect(7,sclr)
SCB_GetColorIndirect(3,sclr) : SCB_SetColorIndirect(8,sclr)
SCB_GetColorIndirect(4,sclr) : SCB_SetColorIndirect(9,sclr)

SCB_SetButtonHeight(5,CXVS)
SCB_SetButtonHeight(6,23)
SCB_SetButtonHeight(7,23)
SCB_SetButtonHeight(8,23)
SCB_SetButtonHeight(9,23)

SCB_SetGadgetState(5,5)
SCB_SetGadgetState(6,25)
SCB_SetGadgetState(7,15)
SCB_SetGadgetState(8,35)
SCB_SetGadgetState(9,10)

; // MAIN LOOP //

Repeat
	EventID = WaitWindowEvent()
	
	If EventID = #PB_Event_Gadget
		Debug "Gadget = " + Str(EventGadget())
		Debug "State = " + Str(SCB_GetGadgetState(EventGadget()))
		Debug "-----------------------------"
	EndIf
	
	If EventID = #PB_Event_SizeWindow
		ResizeGadget(0,20,20,CXVS,WindowHeight(0)-40)
		For i=0 To 3
 			ResizeGadget(i+1,70 + i*50,20,23,WindowHeight(0)-40)
		Next
 		ResizeGadget(5,260,20,WindowWidth(0)-280,CXVS)
		For i=0 To 3
 			ResizeGadget(i+6,260,70 + i*50,WindowWidth(0)-280,23)
		Next		
	EndIf
Until EventID = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------------------------
; EnableXP