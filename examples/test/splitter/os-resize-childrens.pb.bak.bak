; windows 3528 - time add gadget
; macos 4014 - time add gadget ; прокрутка по лучше


CompilerIf #PB_Compiler_IsMainFile
  Global g=-1,i, time, Sw = 350, Sh = 300, count = 5000
  
  If OpenWindow(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g = ContainerGadget(-1,310, 10, 290, 300) : CloseGadgetList()
    
    ;
    ; SplitterGadget(-1,10,10,590,480, TextGadget(-1,0,0,0,0,""),g, #PB_Splitter_Separator) ; bug
    SplitterGadget(-1,10,10,590,480, ButtonGadget(-1,0,0,0,0,""),g, #PB_Splitter_Separator)
    
    If count
      OpenGadgetList(g)
      time = ElapsedMilliseconds()
      For i=0 To count
        If Bool(i>count-110)
          ButtonGadget(-1,(count-i)*2, (count-i)*2, 130, 30,"Button"+Str(i))
        Else
          ButtonGadget(-1,Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      Debug  Str(ElapsedMilliseconds()-time) + " - time add gadget"
      CloseGadgetList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP