XIncludeFile "../../widgets.pbi" : Uselib(widget)

Global enumerate_count

Procedure StartWindow( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure NextWindow( *this.Integer ) 
  Protected *element
  ; Widget() = GetChildrens(Root())
  
  If Not enumerate_count
    *element = FirstElement(Widget())
  Else
    *element = NextElement(Widget())
  EndIf
  
  enumerate_count + 1
  
  If Widget()\type <> #__type_window
    While *element
      *element = NextElement(Widget())
      
      If Widget()\type = #__type_window
        Break
      EndIf 
    Wend
  EndIf
  
  If Widget()\type <> #__type_window
    ProcedureReturn 0
  EndIf
  
  *this\i = Widget()\index ; ListIndex(Widget())
  ProcedureReturn *element
  
EndProcedure

Procedure AbortWindow( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure StartGadget( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

Procedure NextGadget( *this.Integer, parent =- 1 ) 
  Protected *element
  
  If Not enumerate_count
    *element = FirstElement(Widget())
  Else
    *element = NextElement(Widget())
  EndIf
  
  enumerate_count + 1
  
  If Widget()\type = #__type_window
    While *element
      *element = NextElement(Widget())
      
      If Widget()\type <> #__type_window And
         Not (Widget()\parent\index <> parent And parent <> #PB_Any)
        Break
      EndIf 
    Wend
  EndIf
  
  If Widget()\type = #__type_window Or
     (Widget()\parent\index <> parent And parent <> #PB_Any)
    enumerate_count = 0
    ProcedureReturn 0
  EndIf
  
  *this\i = Widget()\index ; ListIndex(Widget())
                                       ;Debug Widget()\text\string
  ProcedureReturn *element
  
EndProcedure

Procedure AbortGadget( )
  enumerate_count = 0
  ProcedureReturn 1
EndProcedure

; Shows using of several panels...
If Open(OpenWindow(#PB_Any, 0, 0, 322, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  Define y = 5
  For i = 1 To 4
    Window(5, y, 150, 95+#__window_frame, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    Container(5, 5, 120,85, #PB_Container_Flat)                                                                         ; Gadget(i, 
    Button(10,10,100,30,"Button_" + Trim(Str(i+10)))                                                                    ; Gadget(i+10,
    Button(10,45,100,30,"Button_" + Trim(Str(i+20)))                                                                    ; Gadget(i+20,
    CloseList()                                                                                                         ; Gadget
    y + 130
  Next
  
  
  Debug "Begen enumerate window"
  If StartWindow( )
    While NextWindow( @Window )
      Debug "Window "+Window
    Wend
    AbortWindow()
  EndIf
  
  Debug "Begen enumerate all gadget"
  If StartGadget( )
    While NextGadget( @Gadget )
      Debug "Gadget "+Gadget
    Wend
    AbortGadget()
  EndIf
  
  Window = 8
  
  Debug "Begen enumerate gadget window = "+ Str(Window)
  If StartGadget( )
    While NextGadget( @Gadget, Window )
      Debug "Gadget "+Str(Gadget) +" Window "+ Window
    Wend
    AbortGadget()
  EndIf
  
  
  Debug "Begen enumerate alls"
  ForEach Widget()
    Debug "Widget "+ Widget()\index
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ----
; EnableXP