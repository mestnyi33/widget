
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure resize_events( )
      Debug "resize - " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
   EndProcedure
   
   If Open(0, 0, 0, 300, 301, "TreeGadget", #PB_Window_SystemMenu |
                                            #PB_Window_SizeGadget |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget | 
                                            #PB_Window_ScreenCentered )
      SetBackColor( widget(), $fff000f0)
      
;       Button(0,0,0,0,"auto-resize-root-size" )
;       ;ReDraw( root())
;       Debug "--"
;       SetAlign( widget( ), #__align_full )
      
      Bind( #PB_All, @resize_events( ), #__event_resize )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 23
; Folding = -
; EnableXP