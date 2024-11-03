XIncludeFile "../../../widgets.pbi" 

; windows 474 - time add widget
; macos 571 - time add widget

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global *g._s_widget, i, time, Sw = 350, Sh = 300, count = 5000
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *g = Container(310, 10, 290, 300) : CloseList()
    
    Splitter(10,10,590,480, -1,*g)
    
    If count
      OpenList(*g)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          Button((count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          Button(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add widget"
      CloseList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 4
; Folding = -
; EnableXP