IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
      
      If GetParent( g )
         If event = #__event_MouseEnter
            If MousePress( ) Or MousePress( g )
               Debug "["+MousePress( ) +"-"+ MousePress( g ) +"] press"
            EndIf
         EndIf
         
         ;\\  различать состояние кнопок
         If MousePress( ) <> MouseRelease( )
            If MousePress( )
               If Not MouseDragStart( )
                  Debug "[press] "+ EventString(event) 
               EndIf
            Else
               Debug "[release] "+ EventString(event)
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   If OpenWindow(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 10,10, 480, 480)
         Bind(#PB_All, @EventsHandler( ))
         Button( 10, 50, 200, 80, "1")
         Button( 220, 50, 200, 80, "2")
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 22
; FirstLine = 2
; Folding = --
; EnableXP
; DPIAware