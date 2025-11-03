XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ; test_focus_set = 2
   
   Procedure all_events( )
      Protected event$
      If WidgetEvent( ) = #__event_MouseMove
         ProcedureReturn 0
      EndIf
      ;
      If WidgetEvent( ) = #__event_MouseWheel
         If MouseDirection( ) > 0
            event$ = "MouseWheelVertical"
         Else
            event$ = "MouseWheelHorizontal"
         EndIf
      Else
         event$ = ClassFromEvent(WidgetEvent( ))
      EndIf
      
      Debug " ["+GetClass(EventWidget( )) +"] "+ event$ +" "+ WidgetEventData( ) +" "+ MouseData( )
   EndProcedure
   
   Define flag.q = #PB_Canvas_DrawFocus
   
   Procedure TestRoot( gadget, X,Y,Width,Height, flag=0 )
      Protected *g
      *g = Open(gadget, X,Y,Width,Height,"", flag, 0, gadget) 
      SetBackColor(*g, RGB( Random(255), Random(255), Random(255) ))
      SetText(*g, Str(gadget))
      SetClass(*g, Str(gadget))
   EndProcedure
   
   Procedure TestWindow( ID )
     Static X,Y
     OpenWindow( ID, 300+X,150+Y,170,170,"window_"+Str(ID), #PB_Window_BorderLess)
     TestRoot( ID, 10, 0, 160, 170 )
     
     X + 100
     Y + 100
     ProcedureReturn 1
  EndProcedure
  
  If TestWindow( 10 )
     TestWindow( 30 )

;    If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;       TestRoot(10, 10, 10, 150, 150,flag) 
;       
;       TestRoot(20, 210, 10, 150, 150,flag) 
;       
;       TestRoot(30, 10, 210, 150, 150,flag) 
;       
;       TestRoot(40, 210, 210, 150, 150,flag) 
      
     
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
; CursorPosition = 49
; FirstLine = 23
; Folding = --
; EnableXP
; DPIAware