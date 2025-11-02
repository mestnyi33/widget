XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   test_focus_set = 2
   
   Procedure all_events( )
      If WidgetEvent( ) = #__event_MouseMove
         ProcedureReturn 0
      EndIf
      ;
      Debug " ["+GetClass(EventWidget( )) +"] "+ ClassFromEvent(WidgetEvent( )) ;+" "+ EventWidget( )\index
   EndProcedure
   
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
      
     
      Bind( #PB_All, @all_events( ))
      WaitClose( )
   EndIf

CompilerEndIf

; [1] MouseEnter
; [1] Focus
; [1] Down
; [1] LeftButtonDown
; [1] Up
; [1] LeftButtonUp
; [1] LeftClick
; [1] Down
; [1] LeftButtonDown
; [1] DragStart
; [1] Up
; [1] LeftButtonUp
; [1] MouseLeave
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 20
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware