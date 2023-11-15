XIncludeFile "../../../widgets.pbi" 

; 2097 - time post widget
; 65 - time bind widget

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global g=-1,*g._s_widget, b,*b, i, time, Sw = 350, Sh = 300, count = 5000
  
  Procedure events_widgets()
    ;  Debug "  "+ GetIndex(EventWidget()) +" - widget event - "+ WidgetEventType() +" item - "+ WidgetEventItem() ;;+ " event - " + WidgetEventType()
    EndProcedure
  
  If Open(#PB_Any, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *g = ScrollArea(310, 10, 290, 300, Sw, Sh, 15, #PB_ScrollArea_Flat)
    *b = Button(Sw-130, Sh-30, 130, 30,"Button")
    CloseList()
    
    ;
    Splitter(10,10,590,480, -1, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
    If count
      OpenList(*g)
      time = ElapsedMilliseconds()
      For i=0 To count
;         If Bool(i>count-110)
;          ; Button((count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
;         Else
           Button(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
           Hide(widget( ),1)
;         EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget"
      CloseList()
      
      ;*g\root\canvas\repaint = 0
      
      time = ElapsedMilliseconds()
      If StartEnumerate( *g )
;         ;SetActive(widget())
        Bind(widget(), @events_widgets(), #__event_Focus)
        StopEnumerate( )
      EndIf
      Debug  Str(ElapsedMilliseconds()-time) + " - time bind widget"
      
      time = ElapsedMilliseconds()
      If StartEnumerate( *g )
        Post( widget(), #__event_Focus)
        StopEnumerate( )
      EndIf
      Debug  Str(ElapsedMilliseconds()-time) + " - time post widget"
      
;       time = ElapsedMilliseconds()
;       If StartEnumerate( *g )
; ;         ;SetActive(widget())
;         Bind(widget(), @events_widgets(), #__event_Focus)
;         StopEnumerate( )
;       EndIf
;       Debug  Str(ElapsedMilliseconds()-time) + " - time bind widget"
;       
;       time = ElapsedMilliseconds()
;       If StartEnumerate( *g )
;         Post( widget(), #__event_Focus)
;         StopEnumerate( )
;       EndIf
;       Debug  Str(ElapsedMilliseconds()-time) + " - time post widget"
      
      
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 4
; Folding = -
; EnableXP