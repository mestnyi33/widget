XIncludeFile "../../../widgets.pbi" 

Global alpha = 125
Global *Object1,*Object2,*Object3,*Object4,*Object5
UseWidgets( )

; ;- TEMP DPI
; Macro a_set( this, mode, size )
;   PB(a_set)( this, mode, DPIScaled(size) )
; EndMacro

Procedure SetSelectionStyle( *this._s_widget, mode.i, color, size )
  ;;*this\_a_set = mode  
  SetWidgetFrame(*this, size)
  If color <> #SelectionStyle_None
    SetWidgetColor(*this, #__color_frame, Color&$FFFFFF | 255<<24)
  EndIf    
EndProcedure

If OpenRoot(0, 0, 0, 800, 450, "Exemple 2: Multiple object, different handles, cursors and selection styles as well as event management", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;
  Define *g = ContainerWidget(0,0,0,0, #__flag_autosize)
  a_init(*g, 8)
  ;SetWidgetColor(*g, #__color_back, RGBA(128, 192, 64, alpha))
  ;SetWidgetColor(root( ), #__color_back, RGBA(255, 255, 255, 255))
  
  ; Create five different objects
  *Object1 = a_object(20, 20, 200, 100, "", RGBA(64, 128, 192, alpha)) 
  *Object2 = a_object(20, 140, 200, 100, "", RGBA(192, 64, 128, alpha))
  *Object3 = a_object(20, 260, 200, 100, "", RGBA(128, 192, 64, alpha))
  *Object4 = a_object(240, 20, 200, 100, "", RGBA(192, 128, 64, alpha))
  *Object5 = a_object(240, 140, 200, 100, "", RGBA(128, 64, 192, alpha))
  
  ; Define different handles to the objects
  a_set(*Object1, #__a_width | #__a_position, 10)
  a_set(*Object2, #__a_height | #__a_position, 10)
  a_set(*Object3, #__a_edge | #__a_position, 10)
  a_set(*Object4, #__a_corner | #__a_position, 10)
  a_set(*Object5, #__a_full | #__a_position, 10)
  
  ; Define different cursors to the objects
  SetCursor(*Object2, #PB_Cursor_Hand)
  SetCursor(*Object3, #PB_Cursor_Cross)
  
  ; ; Sets the selection frame style of the specified object.
  SetSelectionStyle(*Object1, #SelectionStyle_None, #SelectionStyle_None, 13)
  SetSelectionStyle(*Object2, #SelectionStyle_Dotted, RGBA(255, 0, 0, 255), 13)
  SetSelectionStyle(*Object3, #SelectionStyle_Dashed, RGBA(0, 255, 0, 255), 13)
  SetSelectionStyle(*Object4, #SelectionStyle_Solid, RGBA(192, 128, 64, 255), 13)
  SetSelectionStyle(*Object5, #SelectionStyle_Solid, RGBA(128, 64, 192, 255), 13)
  ; ; Object 5 has no selection defined (None).
  ; 
  ; ; Enables and customizes the mouse cursor selection to select objects on the canvas gadget,
  ; ; by default no selection with cursor frame is possible.
  ; SetCursorSelectionStyle(#Canvas, #SelectionStyle_Solid|#SelectionStyle_Partially, RGBA(0, 128, 255, 255), 3, RGBA(0, 128, 255, 50)) 

  ;
  WaitCloseRoot( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware