XIncludeFile "-widgets-plus.pbi"
;IncludePath "../../../" : XIncludeFile "-widgets-edit.pbi"
; XIncludeFile "../empty5.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  Procedure events_widgets()
    Protected String.s
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
      Case #PB_EventType_Focus
        String.s = "focus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #PB_EventType_Change
        String.s = "change "+Str(EventWidget( )\index-1)+" "+eventtype
    EndSelect
    
    If eventtype = #PB_EventType_Focus
      Debug String.s +" - widget" +" get text - "+ GetText(EventWidget( ))
    Else
     ; Debug String.s +" - widget"
    EndIf
    
  EndProcedure
  
  
  If Open(OpenWindow(#PB_Any, 0, 0, 600, 600, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    
    ;WaitClose( ) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP