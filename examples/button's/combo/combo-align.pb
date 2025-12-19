XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ; test_align = 1
   test_draw_area = 1
   
   Global img = 1
   If Not LoadImage(img, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DPIResolutionX() > 1
      ResizeImage(img, DPIScaledX(ImageWidth(img)),DPIScaledY(ImageHeight(img)))
   EndIf
   
   Define Width = 250
   Global.s word$ = "&"
   word$ = #LF$ ; BUG
   
   Procedure Combo( X,Y,Width,Height, Text.s, flags=0 )
      Protected._s_WIDGET *g = ComboBox( X,Y,Width,Height, flags)
      AddItem( *g, -1, Text,img )
      SetState( *g, 0 )
      SetAlign( *g, 0, 1,0,1,0)
   EndProcedure
   
   If Open(0, 0, 0, Width + 20, 535, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Combo(10, 10, Width, 65, "left"           , #__flag_Left  )
      Combo(10, 85, Width, 65, "left"+word$+"center"    , #__flag_ImageLeft  )
      Combo(10, 160, Width, 65, "top"+word$+"center"    , #__flag_ImageTop   )
      Combo(10, 235, Width, 65, "bottom"+word$+"center" , #__flag_ImageBottom)
      Combo(10, 310, Width, 65, "right"+word$+"center"  , #__flag_ImageRight )
      Combo(10, 385, Width, 65, "right"         , #__flag_Right )
      Combo(10, 460, Width, 65, "default"      );, #__flag_TextCenter)  ; #__flag_Center
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 19
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware