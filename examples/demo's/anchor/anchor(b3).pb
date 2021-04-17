	XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
Global alpha = 128
Global *Object1,*Object2,*Object3,*Object4,*Object5

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
EndProcedure

Procedure Bounds( *this._s_widget, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
  ; If the value is set to #PB_Ignore, the current value is not changed. 
  ; If the value is set to #PB_Default, the value is reset to the system default (as it was before this command was invoked).
  *this\bounds.allocate(BOUNDS)
  
  *this\bounds\x\min = #PB_Ignore
  *this\bounds\x\max = #PB_Ignore
  
  *this\bounds\y\min = #PB_Ignore
  *this\bounds\y\max = #PB_Ignore
  
  *this\bounds\width\min = MinimumWidth
  *this\bounds\width\max = MaximumWidth
  
  *this\bounds\height\min = MinimumHeight
  *this\bounds\height\max = MaximumHeight
EndProcedure

Procedure _Object( x.l,y.l,width.l,height.l, text.s, frameSize, Color.l  )
  Container(x,y,width,height, #__flag_nogadgets) 
  If text
    SetText(widget(), text)
  EndIf
  SetColor(widget(), #__color_back, Color)
  SetColor(widget(), #__color_frame, Color&$FFFFFF | 255<<24)
  SetColor(widget(), #__color_front, Color&$FFFFFF | 255<<24)
  SetFrame(widget(), frameSize);, -1), -2) ; bug
  ProcedureReturn widget( )
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 3: Object boundaries to position and size", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  ; Define handles to all objects
  a_init(root(), 0)
  SetColor(root(), #__color_back, RGBA(64, 128, 192, alpha))
  
  *Object1 = _Object(50, 50, 200, 100, "Canvas boundaries", 3, RGBA(64, 128, 192, alpha))
  *Object2 = _Object(300, 50, 200, 100, "Boundary in X", 3, RGBA(64, 128, 192, alpha))
  *Object3 = _Object(550, 50, 200, 100, "Boundary in Y", 3, RGBA(64, 128, 192, alpha))
  *Object4 = _Object(50, 250, 200, 100, "Limit in width", 3, RGBA(64, 128, 192, alpha))
  *Object5 = _Object(300, 250, 200, 100, "Limit in height", 3, RGBA(64, 128, 192, alpha))
  
  ;TextGadget( -1, 50, 50, 200, 100, "",#PB_Text_Border )
  ContainerGadget( -1, 50, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  ContainerGadget( -1, 300, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  ContainerGadget( -1, 550, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  
  
;   ; Limits the position as well as the minimum and maximum size of the objects
;   BoundsPosition(*Object1, 0, 0, #Boundary_ParentSize, #Boundary_ParentSize)
;   BoundsPosition(*Object2, 250, #Boundary_Ignore, 550, #Boundary_Ignore)
;   BoundsPosition(*Object3, #Boundary_Ignore, 50, #Boundary_Ignore, 200)
;   BoundsPosition(*Object4, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, 150, #Boundary_Ignore, 250, #Boundary_Ignore)
;   BoundsPosition(*Object5, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore, #Boundary_Ignore,  50, #Boundary_Ignore, 150)
  ;Bounds(*Object1, #PB_Ignore, #PB_Ignore, 800, #PB_Ignore)
  
  BoundsPosition(*Object2, 250, #PB_Ignore, 550, #PB_Ignore)
  BoundsPosition(*Object3, #PB_Ignore, 50, #PB_Ignore, 200)
  
  Bounds(*Object4, 150, #PB_Ignore, 250, #PB_Ignore)
  Bounds(*Object5, #PB_Ignore, 50, #PB_Ignore, 150)

  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP