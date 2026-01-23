
IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   test_draw_area = 1
   
   Global window, i, i1, i2
   
   window = GetCanvasWindow( Open( 5, 70, 70, 200, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget ))
  ; a_init(Root())
   
   window( 50,50, 300,100, "window", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   
;    For i=1 To 9
       Button(0, 0, 20, 20, Str(i))  
;    Next
;    For i1=i To i+9
;       Button(0, 20, 20, 20, Str(i1))  
;    Next
;    
;    For i=1 To 9
;       SetAlign(ID(i), 0, #__align_auto,1,0,0 )   
;    Next
;    
;    For i1=i To i+9
;       SetAlign(ID(i1), 0, #__align_auto,1,0,0 )   
;    Next
;    
;    Repaint( )
    ResizeWindow(window, #PB_Ignore, #PB_Ignore, 600,#PB_Ignore) ;460,360)
   
;    Debug "scroll "+Widget()\scroll_x() +" "+ Widget()\scroll_y() +" "+ Widget()\scroll_width() +" "+ Widget()\scroll_height() 
;    Debug "scroll "+Root()\scroll_x() +" "+ Root()\scroll_y() +" "+ Root()\scroll_width() +" "+ Root()\scroll_height() 
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 14
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware