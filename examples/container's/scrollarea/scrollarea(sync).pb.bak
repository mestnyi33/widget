XIncludeFile "../../../widgets.pbi" ; ok

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global *g._S_WIDGET, Quit, *scroll1._s_widget,*scroll2._s_widget,x_0,y_0
  
  Procedure syncCB()
     Protected *eWidget = EventWidget( )
; ;      *g = *eWidget
; ;      If *g\bar
; ;         Debug "-------"+Str(*g)+"-------"
; ;         Debug *g\bar\page\pos  ; 2268 ; 0
; ;         Debug *g\bar\page\len  ; 232  
; ;         Debug *g\bar\page\end  ; 2268
; ;         Debug *g\bar\page\change ; 0
; ;         Debug *g\bar\percent     ; 0.08245149999857
; ;         Debug *g\bar\area\end    ; 202
; ;         Debug *g\bar\thumb\pos   ; 202 ; 15
; ;         Debug *g\bar\thumb\len   ; 19
; ;         Debug *g\bar\thumb\end   ; 206
; ;         Debug *g\bar\thumb\change; 0
; ;         Debug ""
; ;         ;*g\bar\page\change = 0
; ;         ;*g\bar\thumb\change = 0
; ;      EndIf
    x_0 = GetAttribute(*eWidget, #PB_ScrollArea_X)
    y_0 = GetAttribute(*eWidget, #PB_ScrollArea_Y)
    
    Select *eWidget 
    	Case *scroll1
    		SetAttribute(*scroll2, #PB_ScrollArea_X, x_0)
    		SetAttribute(*scroll2, #PB_ScrollArea_Y, y_0)
    		
    	Case *scroll2
    		SetAttribute(*scroll1, #PB_ScrollArea_X,x_0)
    		SetAttribute(*scroll1, #PB_ScrollArea_Y,y_0) 
    		
    EndSelect
    
    If *eWidget <> EventWidget( )
    	Debug "test - "+ *eWidget +" "+ EventWidget( )
    EndIf
    
 EndProcedure
  
  LoadImage(0, #PB_Compiler_Home + "examples/Sources/Data/PureBasicLogo.bmp")
  Define imgw = ImageWidth(0)
  Define imgh = ImageHeight(0)
  
  Open(0, 0, 0, 500, 430,"demonstration of how to sync two scroll area bars", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
  *scroll1 = ScrollArea(10, 10, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  *scroll2 = ScrollArea(10, 220, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  Splitter( 10, 10, 480, 410, *scroll1,*scroll2 )
  
;    SetState( *scroll1\scroll\v, *scroll1\scroll\v\bar\max )
;    SetState( *scroll1\scroll\h, *scroll1\scroll\h\bar\max )
  
;   *g = *scroll1\scroll\v
;   
;   Debug ""
;   Debug *g\bar\page\pos  ; 2268 ; 0
;   Debug *g\bar\page\len  ; 232  
;   Debug *g\bar\page\end  ; 2268
;   Debug *g\bar\page\change ; 0
;   Debug *g\bar\percent     ; 0.08245149999857
;   Debug *g\bar\area\end    ; 202
;   Debug *g\bar\thumb\pos   ; 202 ; 15
;   Debug *g\bar\thumb\len   ; 19
;   Debug *g\bar\thumb\end   ; 206
;   Debug *g\bar\thumb\change; 0
;   Debug ""
      
  Bind(*scroll1, @syncCB(), #__Event_ScrollChange)
  Bind(*scroll2, @syncCB(), #__Event_ScrollChange)
  
  Repeat
    Select WaitWindowEvent(1)
      Case #PB_Event_CloseWindow
        Quit = 1
        
    EndSelect
  Until Quit = 1
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS - C Backend (MacOS X - x64)
; CursorPosition = 65
; FirstLine = 52
; Folding = -
; EnableXP
; DPIAware