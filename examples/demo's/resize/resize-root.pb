
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure resize_events( )
       If WidgetEvent( ) = #__event_resize
         Debug "resize - " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
       EndIf
   EndProcedure
   
   If Open(0, 0, 0, 300, 301, "resize demo", #PB_Window_SystemMenu |
                                            #PB_Window_SizeGadget |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget | 
                                            #PB_Window_ScreenCentered )
      SetBackColor( Widget( ), $fff000f0)
      
      Button(0,0,50,50,"auto-resize-root-size" ) : Widget( )\bindresize = 1
      ;SetAlign( widget( ), #__align_Right ) ; BUG
      SetAlign( Widget( ), #__align_Auto|#__align_Right )
      ;SetAlign( widget( ), #__align_Center|#__align_Right )
      ; Bind( widget( ), @resize_events( ), #__event_resize )
      
      Bind( #PB_All, @resize_events( ));, #__event_resize )
      WaitClose( ) ; @resize_events( ))
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP