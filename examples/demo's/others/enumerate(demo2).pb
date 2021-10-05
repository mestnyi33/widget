XIncludeFile "../../../widgets.pbi" : Uselib(widget)


; Shows using of several panels...
If Open(OpenWindow(#PB_Any, 0, 0, 322, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  Define *window._s_Widget
  Define y = 5
  For i = 1 To 4
    Window(5, y, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    Container(5, 5, 120+2,85+2, #PB_Container_Flat)                                                     ; Gadget(i, 
    Button(10,10,100,30,"Button_" + Trim(Str(i+10)))                                                    ; Gadget(i+10,
    Button(10,45,100,30,"Button_" + Trim(Str(i+20)))                                                    ; Gadget(i+20,
    CloseList()                                                                                         ; Gadget
    y + 130
  Next
  
  
  Debug "Begen enumerate window"
  If StartEnumerate( root( ) )
    If _is_window_( widget( ) )
      Debug "window " + widget( )\index
    EndIf
    StopEnumerate( )
  EndIf
  
  Debug "Begen enumerate all gadget"
  If StartEnumerate( root( ) )
    If Not _is_window_( widget( ) )
      Debug "gadget - "+widget( )\index
    EndIf
    StopEnumerate( )
  EndIf
  
  Window = 8
  *window = GetWidget( Window )
  
  Debug "Begen enumerate gadget window = "+ Str(Window)
  Debug "window "+ Window
  If StartEnumerate( *window )
    Debug "  gadget - "+ widget( )\index
    StopEnumerate( )
  EndIf
  
  
  Debug "Begen enumerate alls"
  If StartEnumerate( root( ) )
    If _is_window_( widget() )
      Debug "window "+ Widget()\index
    Else
      Debug "  gadget - "+ Widget()\index
    EndIf
    StopEnumerate( )
  EndIf
  
  bind(-1,-1)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP