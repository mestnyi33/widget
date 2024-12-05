
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure resize_events( )
       Debug "resize - " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
   EndProcedure
   
   If Open(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu |
                                            #PB_Window_SizeGadget |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget | 
                                            #PB_Window_ScreenCentered )
      SetBackgroundColor( widget(), $fff000f0)
      
;        Button(0,0,0,0,"auto-resize-root-size" )
;        SetAlign( widget( ), #__align_full )
      
      WaitEvent( @resize_events( ), #__event_resize )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 17
; Folding = -
; EnableXP