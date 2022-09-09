XIncludeFile "../../../widget-events.pbi" : Uselib(widget)
;XIncludeFile "../../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - gadget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_Change
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
     
    Case #PB_EventType_Up
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget up " + GetGadgetState(EventGadget())
     
   Case #PB_EventType_Down
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget down " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Up
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget up " + GetState(EventWidget( ))
      
    Case #PB_EventType_Down
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget down " + GetState(EventWidget( ))
       
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget change " + GetState(EventWidget( ))
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 200, "SpinGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 320,0,320,200)
  SpinGadget(0, 10,  30, 250, 18, 0, 30)
  SpinGadget(1, 10,  30+18+1, 250, 21, 0, 30)
  SpinGadget(2, 10,  30+18+1+21+1, 250, 25, 0, 30)
  SetGadgetState(0, 0)
  SetGadgetState(1, 15)
  SetGadgetState(2, 30)
  
  SpinGadget(3, 10, 120, 250, 25, 0, 30, #PB_Spin_Numeric)
  SetGadgetState(3, 2000)
  
; ; ;   SpinGadget(2, 270, 10, 20, 170, 0, 10000, #PB_Spin_ReadOnly)
; ; ;   SetGadgetState(2, 8000)
  
  TextGadget    (#PB_Any, 10,  10, 250, 20,"Spin Standard", #PB_Text_Center)
  TextGadget    (#PB_Any, 10, 100, 250, 20, "Spin Ticks", #PB_Text_Center)
;   TextGadget    (#PB_Any,  90, 180, 200, 20, "Spin Vertical", #PB_Text_Right)
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(0),"setAlignment:", 0)
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE) & $FFFFFFFC | #ES_LEFT)
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLongPtr_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER) 
      Else
        SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE)|#SS_LEFT)
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(0), 0)
      gtk_entry_set_alignment(GadgetID(1), 0.5)
    CompilerEndIf
    
    
  Spin(10, 30, 250, 18, 0, 30)
  Spin(10, 30+18+1, 250, 21, 0, 30, #__text_center);|#__bar_Vertical)
  Spin(10, 30+18+1+21+1, 250, 25, 0, 30, #__text_right)
  SetState(GetWidget(0), 0)
  SetState(GetWidget(1), 15)
  SetState(GetWidget(2), 30)
  
  Spin(10, 120, 250, 25, 5, 30, #__spin_Plus)
  Spin(270, 10, 40, 180, 5, 30, #__spin_Plus|#__bar_vertical);|#__bar_invert)
  SetState(widget( ), 5000)
  
; ; ;   Spin(270, 10, 20, 170, 0, 10000, #__Spin_Vertical)
; ; ;   SetState(GetWidget(2), 8000)
  
  Text(10,  10, 250, 20,"Spin Standard", #__Text_Center)
  Text(10, 100, 250, 20, "Spin Ticks", #__Text_Center)
;   Text(90, 180, 200, 20, "Spin Vertical", #__Text_Right)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP