XIncludeFile "../../../widgets.pbi" : UseWidgets( )

Procedure events_gadgets()
   ;ClearDebugOutput()
   ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
   
   Select EventType()
      Case #PB_EventType_LeftClick
         SetState(ID(EventGadget()), GetGadgetState(EventGadget()))
         Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
   EndSelect
EndProcedure

Procedure events_widgets()
   ;ClearDebugOutput()
   ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(EventWidget( )) ; 
   
   Select WidgetEvent( )
      Case #PB_EventType_LeftClick
         SetGadgetState(Index(EventWidget( )), GetState(EventWidget( )))
         Debug  Str(Index(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
   EndSelect
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   LoadFont(5, "Arial", 16)
CompilerElse
   LoadFont(5, "Arial", 12)
CompilerEndIf

; Shows possible flags of ButtonGadget in action...
If OpenWindow(0, 0, 0, 270+270, 100, "HyperLinkGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   HyperLinkGadget(0, 10, 10, 250,20,"Red HyperLink", RGB(255,0,0), #PB_HyperLink_Underline)
   HyperLinkGadget(1, 10, 40, 250,40,"Text = Arial Underlined"+#LF$+"Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
   SetGadgetFont(1, FontID(5))
   SetGadgetColor(1, #PB_Gadget_FrontColor, $ff0000)
   SetGadgetColor(1, #PB_Gadget_BackColor, $0000ff)
   
   For i = 0 To 1
      BindGadgetEvent(i, @events_gadgets())
   Next
EndIf 

;
If Open(0, 270,0,270,100)
   HyperLink(10, 10, 250,20,"Red HyperLink", RGB(255,0,0), #PB_HyperLink_Underline)
   HyperLink(10, 40, 250,40,"Text = Arial Underlined"+#LF$+"Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
   SetFont(ID(1), FontID(5))
   SetColor(ID(1), #PB_Gadget_FrontColor, $ffff0000)
   SetColor(ID(1), #PB_Gadget_BackColor, $ff0000ff)
   
   ;Bind(#PB_All, @events_widgets())
   
   For i = 0 To 1
      Bind(ID(i), @events_widgets(), #PB_EventType_LeftClick)
   Next
EndIf

;\\
WaitClose( )

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 20
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware