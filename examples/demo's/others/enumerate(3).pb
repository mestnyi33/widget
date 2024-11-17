
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   Define i, time.q, count = 10000
   
   If OpenRootWidget(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      For i = 0 To count
         ContainerWidget( 5*i, 5*i, 50,50)
      Next
      For i = 0 To count
         CloseWidgetList( )
      Next
      
      time = ElapsedMilliseconds( )
      ;Debug "--- enumerate all gadgets ---"
      If StartEnum( root( ) )
         ;Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnum( )
      EndIf
      Debug "--- enumerate all gadgets time --- "+Str(ElapsedMilliseconds( ) - time)
      
      WaitCloseRootWidget()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 23
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware