XIncludeFile "../../../widgets.pbi"
Uselib(widget)

Procedure BoundsPosition( *this._s_widget, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
  ; If the value is set to #PB_Ignore, the current value is not changed. 
  ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
  *this\bounds.allocate(BOUNDS)
  
  *this\bounds\x\min = MinimumX
  *this\bounds\x\max = MaximumX
  
  *this\bounds\y\min = MinimumY
  *this\bounds\y\max = MaximumY
  
  *this\bounds\width\min = #PB_Ignore
  *this\bounds\width\max = #PB_Ignore
  
  *this\bounds\height\min = #PB_Ignore
  *this\bounds\height\max = #PB_Ignore
  
;   Protected x.l = #PB_Ignore
;   If *this\bounds\x\min > *this\x[#__c_inner]
;     x = *this\bounds\x\min
;   EndIf
;   Resize( *this, x, #PB_Ignore, #PB_Ignore, #PB_Ignore )
EndProcedure

Procedure Bounds( *this._s_widget, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
  ; If the value is set to #PB_Ignore, the current value is not changed. 
  ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
  *this\bounds.allocate(BOUNDS)
  
  *this\bounds\width\min = MinimumWidth
  *this\bounds\width\max = MaximumWidth
  
  *this\bounds\height\min = MinimumHeight
  *this\bounds\height\max = MaximumHeight
EndProcedure

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 0)
  
  Window(150, 150, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  ;Bounds(widget(), 200, 200, 400, 400)
  BoundsPosition(widget(), 200, 200, 400, 400)
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP