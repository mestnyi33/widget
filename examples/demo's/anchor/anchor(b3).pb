XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
Global alpha = 128
Global *Object1,*Object2,*Object3,*Object4,*Object5

Procedure _Object( x.l,y.l,width.l,height.l, text.s, frameSize, Color.l  )
  If Not Alpha(Color)
    Color = Color&$FFFFFF | 255<<24
  EndIf
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

If Open(OpenWindow(#PB_Any, 0, 0, 782, 452, "Example 3: Object boundaries to position and size", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  ; Define handles to all objects
  a_init(root(), 10)
  SetColor(root(), #__color_back, RGBA(64, 128, 192, alpha))
  
  ; Create five different objects
  *Object1 = _Object(50, 50, 200, 100, "Canvas boundaries", 3, RGBA(64, 128, 192, alpha))
  *Object2 = _Object(300, 50, 200, 100, "Boundary in X", 3, RGBA(64, 128, 192, alpha))
  *Object3 = _Object(550, 50, 200, 100, "Boundary in Y", 3, RGBA(64, 128, 192, alpha))
  *Object4 = _Object(50, 250, 200, 100, "Limit in width", 3, RGBA(64, 128, 192, alpha))
  *Object5 = _Object(300, 250, 200, 100, "Limit in height", 3, RGBA(64, 128, 192, alpha))
  
  ; Limits the position as well as the minimum and maximum size of the objects (#Boundary_ParentSize)
  MoveBounds(*Object1, 0, 0, 782, 452)
  MoveBounds(*Object2, 250, #PB_Ignore, 550, #PB_Ignore)
  MoveBounds(*Object3, #PB_Ignore, 50, #PB_Ignore, 200)
  SizeBounds(*Object4, 150, #PB_Ignore, 250, #PB_Ignore)
  SizeBounds(*Object5, #PB_Ignore, 50, #PB_Ignore, 150)
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP