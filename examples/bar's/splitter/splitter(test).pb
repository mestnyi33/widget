XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
OpenWindow(0, 0, 0, 500+500, 340, "disable - state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

If Open(0, 500,0, 500)
   SplitterGadget(1, 10, 10, 300, 100, ButtonGadget(-1,0,0,0,0,""), ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical) 
   SetGadgetAttribute(1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(1, #PB_Splitter_SecondMinimumSize, 40)
   ResizeGadget(1, #PB_Ignore, #PB_Ignore, 200, #PB_Ignore )
   SetGadgetState(1,  200)
   
   Define *splitter = Splitter(10, 10, 300, 100, -1, -1, #PB_Splitter_Vertical)
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, 40)
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, 40)
   Resize(*splitter, #PB_Ignore, #PB_Ignore, 200, #PB_Ignore )
   SetState(*splitter,  200)
   
   
;    Debug GetGadgetState   (1)
;    
;    Debug " - "
;    Debug widget( )\bar\page\pos
;    Debug widget( )\bar\page\len
;    Debug widget( )\bar\page\end
;    Debug widget( )\bar\page\change
;    Debug widget( )\bar\percent
;    Debug widget( )\bar\area\len
;    Debug widget( )\bar\area\end
;    Debug widget( )\bar\thumb\pos
;    Debug widget( )\bar\thumb\len
;    Debug widget( )\bar\thumb\end
;    Debug widget( )\bar\thumb\change
;    Debug ""
   
   WaitClose( )
EndIf



; XIncludeFile "../../../widgets.pbi" 
; ; ; 
; Uselib(widget)
; Define vertical = 0
; 
; ; Splitter( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
; 
; If vertical
;    #PB_SplitterBar_Vertical = #PB_Splitter_Vertical
;    ;\\ vertical
;    If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;       
;       Define *spin1 = Splitter(20, 50, 50, 250,  #PB_Default, #PB_Default, #PB_SplitterBar_Vertical|#__flag_invert)
;       SetState(*spin1, 10)
;       
;       Define *spin2 = Splitter(80, 50, 50, 250,  #PB_Default, #PB_Default, #PB_SplitterBar_Vertical)
;       SetState(*spin2, 10)
;       
;       Define *spin3 = Splitter(140, 50, 50, 250,  #PB_Default, #PB_Default, #PB_SplitterBar_Vertical)
;       SetState(*spin3, 0)
;       
;       
;       WaitClose( )
;    EndIf
; Else
;    
;    ;\\ horizontal
;    If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;       
;       Define *spin1 = Splitter(50, 20, 250, 50,  #PB_Default, #PB_Default, #__flag_invert)
;       SetState(*spin1, 0)
;       
;       Define *spin2 = Splitter(50, 80, 250, 50,  #PB_Default, #PB_Default)
;       SetState(*spin2, 10)
;       
;       Define *spin3 = Splitter(50, 140, 250, 50,  #PB_Default, #PB_Default)
;       SetState(*spin3, 0)
;       
;       
;       WaitClose( )
;    EndIf
; EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 6
; Folding = -
; EnableXP