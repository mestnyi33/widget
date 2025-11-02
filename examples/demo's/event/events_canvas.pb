XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   test_canvas_events = 1
   
   Define flag.q = #PB_Canvas_DrawFocus
   
   Procedure TestRoot( gadget, X,Y,Width,Height, flag )
      Protected *g
      *g = Open(0, X,Y,Width,Height,"", flag, 0, gadget) 
      SetText(*g, Str(gadget))
      SetClass(*g, Str(gadget))
   EndProcedure
   
   If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      TestRoot(10, 10, 10, 150, 150,flag) 
      
      TestRoot(20, 210, 10, 150, 150,flag) 
      
      TestRoot(30, 10, 210, 150, 150,flag) 
      
      TestRoot(40, 210, 210, 150, 150,flag) 
      
     
      WaitClose( )
   EndIf

CompilerEndIf


;  ; windows
;  LostFocus 10
;  LostFocus 20
;  LostFocus 30
;  LostFocus 40
 
;  ; linux
;  Focus 10
;  LostFocus 10
;  LostFocus 10
;  Focus 20
;  LostFocus 20
;  LostFocus 20
;  Focus 30
;  LostFocus 30
;  LostFocus 30
;  Focus 40
;  LostFocus 40
;  LostFocus 40
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 32
; FirstLine = 18
; Folding = -
; EnableXP
; DPIAware