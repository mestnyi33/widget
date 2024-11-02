
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
      
;        Button(0,0,0,0,"auto-resize-root-size" )
;        SetAlignment( widget( ), #__align_full )
      
      WaitEvent( @resize_events( ), #__event_resize )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 3
; Folding = -
; EnableXP