;XIncludeFile "../../../widgets.pbi" 
;XIncludeFile "../../../CE.pb" 
XIncludeFile "../../../widget-events.pbi" 
Uselib(widget)
Global alpha = 125
Global *Object1,*Object2,*Object3,*Object4,*Object5
    
Procedure a_mode( *this._s_widget, mode.i, size.l = #PB_Default )
  *this\_a_\mode = mode  
  *this\_a_mode = mode  
  
  If size.l <> #PB_Default
    transform( )\size = size
    
    *this\_a_\size = size
      *this\_a_\pos = size - size / 3 - 2
        
      ; Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
        ;a_resize( *this, size )
        
  EndIf
EndProcedure

Procedure SetSelectionStyle( *this._s_widget, mode.i, color, size )
  ;;*this\_a_mode = mode  
  SetFrame(*this, size)
  If color <> #SelectionStyle_None
    SetColor(*this, #__color_frame, Color&$FFFFFF | 255<<24)
  EndIf    
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Exemple 2: Multiple object, different handles, cursors and selection styles as well as event management", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ;
  a_init(root(), 10)
  SetColor(root(), #__color_back, RGBA(128, 192, 64, alpha))
  
  ; Create five different objects
  *Object1 = a_object(20, 20, 200, 100, "left & right", RGBA(64, 128, 192, alpha)) 
  *Object2 = a_object(20, 140, 200, 100, "top & bottom" +#LF$+ "cursor = hand", RGBA(192, 64, 128, alpha))
  *Object3 = a_object(20, 260, 200, 100, "left & right" +#LF$+ "top & bottom" +#LF$+ "cursor = cross", RGBA(128, 192, 64, alpha))
  *Object4 = a_object(240, 20, 200, 100, "left-top &" +#LF$+ "left-bottom &" +#LF$+ "right-top &" +#LF$+ "right-bottom &", RGBA(192, 128, 64, alpha))
  *Object5 = a_object(240, 140, 200, 100, "full", RGBA(128, 64, 192, alpha))
  
  ; Define different handles to the objects
  a_mode(*Object1, #__a_width | #__a_position, 15)
  a_mode(*Object2, #__a_height | #__a_position, 12)
  a_mode(*Object3, #__a_edge | #__a_position, 9);
  a_mode(*Object4, #__a_corner | #__a_position, 5)
  a_mode(*Object5, #__a_full | #__a_position)
  
  ; Define different cursors to the objects
  SetCursor(*Object1, #PB_Cursor_Default)
  SetCursor(*Object2, #PB_Cursor_Hand)
  SetCursor(*Object3, #PB_Cursor_Cross)
  SetCursor(*Object4, #PB_Cursor_Busy)
  SetCursor(*Object5, #PB_Cursor_Denied)
  
  ; ; Sets the selection frame style of the specified object.
  SetSelectionStyle(*Object1, #SelectionStyle_None, #SelectionStyle_None, 6)
  SetSelectionStyle(*Object2, #SelectionStyle_Dotted, RGBA(255, 0, 0, 255), 9)
  SetSelectionStyle(*Object3, #SelectionStyle_Dashed, RGBA(0, 255, 0, 255), 13)
  SetSelectionStyle(*Object4, #SelectionStyle_Solid, RGBA(192, 128, 64, 255), 17)
  ; ; Object 5 has no selection defined (None).
  ; 
  ; ; Enables and customizes the mouse cursor selection to select objects on the canvas gadget,
  ; ; by default no selection with cursor frame is possible.
  ; SetCursorSelectionStyle(#Canvas, #SelectionStyle_Solid|#SelectionStyle_Partially, RGBA(0, 128, 255, 255), 3, RGBA(0, 128, 255, 50)) 

  ;
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP