IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_widgets()
   ; ClearDebugOutput()
    Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  item - " +*event\item +" (gadget)"
  EndProcedure
  
  Procedure events_windows()
    Debug "  "+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  item - " +*event\item +" (window)"
  EndProcedure
  
  Procedure events_roots()
    Debug "    "+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  item - " +*event\item +" (root)"
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = #__flag_AnchorsGadget
      
      If Open(0, 10,10, 480, 480)
       ; Bind(#PB_All, @events_roots())
        Bind(Window(80, 100, 310, 290, "Window_2", Editable), @events_windows())
        
       Button(10,  10, 280, 80, "post event for one procedure", Editable)
        Button(10, 100, 280, 80, "post event for to two procedure", Editable)
        Button(10, 190, 280, 80, "post event for all procedures", Editable)
        
        ReDraw(Root())
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
;       Case #PB_Event_Gadget;Widget
;         Debug ""+gettext(EventWidget()) +" "+ WidgetEvent() ;+" "+ *Value\This +" "+ *Value\Type
;         
;         Select EventWidget()
;           Case *but
;             
;             Debug *but
;             
;         EndSelect
;         
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP