XIncludeFile "../../../widgets.pbi"
; commit 1796 ok

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global Container_0, Container_1, Container_2, Container_3, Container_4, Container_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 470, 280, "tab focus demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(0);, 425, 40)
       Container_0 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 0") ; as they will be sized automatically
       CloseList( )
       Container_1 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 1") ; as they will be sized automatically
       CloseList( )
       
       Container_2 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 2") ; No need to specify size or coordinates
       CloseList( )
       Container_3 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 3") ; as they will be sized automatically
       CloseList( )
       Container_4 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 4") ; No need to specify size or coordinates
       CloseList( )
       Container_5 = Container(0, 0, 0, 0)
       Button( 10,10,50,30, "Container 5") ; as they will be sized automatically
       CloseList( )
       
;       Hide(Container_0, 1 ) 
;       Hide(Container_1, 1 ) 
;       Hide(Container_2, 1 ) 
;       Hide(Container_3, 1 ) 
;       Hide(Container_4, 1 ) 
;       Hide(Container_5, 1 ) 

;       Container_0 = 0
;       Container_1 = 0
;       Container_2 = 0
;       Container_3 = 0
;       Container_4 = 0
;       Container_5 = 0
      
      Splitter_0 = Splitter(0, 0, 0, 0, Container_0, Container_1, #PB_Splitter_FirstFixed) ; #PB_Splitter_Vertical|
      Splitter_1 = Splitter(0, 0, 0, 0, Container_3, Container_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
      Splitter_2 = Splitter(0, 0, 0, 0, Splitter_1, Container_5)
      Splitter_3 = Splitter(0, 0, 0, 0, Container_2, Splitter_2)
      Splitter_4 = Splitter(30, 30, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
      
      SetText(Splitter_0, "0")
      SetText(Splitter_1, "1")
      SetText(Splitter_2, "2")
      SetText(Splitter_3, "3")
      SetText(Splitter_4, "4")
      
      SetState(Splitter_1, 20)
      ;SetState(Splitter_1, 410-20)
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 26
; FirstLine = 23
; Folding = -
; EnableXP
; DPIAware