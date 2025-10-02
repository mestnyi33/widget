XIncludeFile "../../../widgets.pbi" 

Global alpha = 125
Global *Object1,*Object2,*Object3,*Object4,*Object5
UseWidgets( )

; 
Procedure SetSelectionStyle( *this._s_widget, mode.i, color, size )
  ;;*this\_a_set = mode  
  SetFrame(*this, size)
  If color <> #SelectionStyle_None
    SetColor(*this, #__FrameColor, Color&$FFFFFF | 255<<24)
  EndIf    
EndProcedure

If Open(0, 0, 0, 800, 450, "Exemple 2: Multiple object, different handles, cursors and selection styles as well as event management", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;
  Define *g = Container(0,0,0,0, #__flag_autosize);|#__flag_transparent)
  a_init(*g, 8)
  ;SetColor(*g, #PB_Gadget_BackColor, RGBA(255, 255, 255, 255))
  
  ; Create five different objects
  *Object1 = a_object(20, 20, 200, 100, " vertically", RGBA(192, 64, 128, alpha))
  *Object2 = a_object(20, 140, 200, 100, " horizontally", RGBA(64, 128, 192, alpha)) 
  *Object3 = a_object(20, 260, 200, 100, " vertically & horizontally", RGBA(128, 192, 64, alpha))
  *Object4 = a_object(240, 20, 200, 100, " diagonally", RGBA(192, 128, 64, alpha))
  *Object5 = a_object(240, 140, 200, 100, " full", RGBA(128, 64, 192, alpha))
  
  ; Define different handles to the objects
  a_set(*Object1, #__a_height | #__a_position, 10)
  a_set(*Object2, #__a_width | #__a_position, 10)
  a_set(*Object3, #__a_edge | #__a_position, 10)
  a_set(*Object4, #__a_corner | #__a_position, 10)
  a_set(*Object5, #__a_full | #__a_position, 10)
  
  ; Define different cursors to the objects
  SetCursor(*Object2, #PB_Cursor_Hand)
  SetCursor(*Object3, #PB_Cursor_Cross)
  
  ; ; Sets the selection frame style of the specified object.
  SetSelectionStyle(*Object1, #SelectionStyle_None, #SelectionStyle_None, 15)
  SetSelectionStyle(*Object2, #SelectionStyle_Dotted, RGBA(255, 0, 0, 255), 8)
  SetSelectionStyle(*Object3, #SelectionStyle_Dashed, RGBA(0, 255, 0, 255), 2)
  SetSelectionStyle(*Object4, #SelectionStyle_Solid, RGBA(192, 128, 64, 255), 1)
  SetSelectionStyle(*Object5, #SelectionStyle_Solid, RGBA(128, 64, 192, 255), 0)
  ; ; Object 5 has no selection defined (None).
  ; 
  ; ; Enables and customizes the mouse cursor selection to select objects on the canvas gadget,
  ; ; by default no selection with cursor frame is possible.
  ; SetCursorSelectionStyle(#Canvas, #SelectionStyle_Solid|#SelectionStyle_Partially, RGBA(0, 128, 255, 255), 3, RGBA(0, 128, 255, 50)) 

  ;
  WaitClose( )
EndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 6
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware