
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure resize_events( )
       Debug "resize - " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
   EndProcedure
   
   If Open(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu |
                                            #PB_Window_SizeGadget |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget | 
                                            #PB_Window_ScreenCentered )
      
;       Button(0,0,0,0,"auto-resize-root-size" )
;       
; ;       SetAlignment( widget( ), #__align_full )
; ;       ;SetAlignment( widget( ), #__align_auto|#__align_full )
; ;       ; SetAlignment( widget( ), 0, 1,1,1,1 )
;       
;       Resize( root( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      WaitEvent( #__event_resize, @resize_events( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 27
; Folding = -
; EnableXP