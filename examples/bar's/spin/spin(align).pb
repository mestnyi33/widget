XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_align = 1
   test_draw_area = 1
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
   
   Define Image = 1
   Define i, Width = 250
   
   Procedure ComboButton( X,Y,Width,Height, Text.s, flags)
      Protected *g._s_WIDGET
      *g = Spin( X,Y,Width,Height, 0,100, flags|#__flag_Center)
     ; AddItem( *g, -1, Text )
      SetState( *g, 10 )
   EndProcedure
   
   #__flag_Reverse = 1<<1
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ComboButton(10,  10, Width/2-5, 65, "left&top"                    , #__flag_BorderFlat|#__flag_Right   )
      ComboButton(10+Width/2+5,  10, Width/2-5, 65, "right&top"         , #__flag_BorderFlat|#__flag_Reverse   )
      ComboButton(10,  10+65+10, Width/2-5, 65, "left&bottom"           , #__flag_BorderFlat|#__flag_Left |#__flag_Bottom)
      ComboButton(10+Width/2+5,  10+65+10, Width/2-5, 65, "right&bottom", #__flag_BorderFlat|#__flag_Right|#__flag_Bottom)
      
      ComboButton(10, 160, Width/2-5, 65, "left"                        , #__flag_BorderFlat|#__flag_Left  )
      ComboButton(10+Width/2+5, 160, Width/2-5, 65, "right"             , #__flag_BorderFlat|#__flag_Right )
      ComboButton(10, 160+65+10, Width/2-5, 65, "top"                   , #__flag_BorderFlat|#__flag_Top   )
      ComboButton(10+Width/2+5, 160+65+10, Width/2-5, 65, "bottom"      , #__flag_BorderFlat|#__flag_Bottom)
      
      ComboButton(10, 310, Width, 65, "left&center"                     , #__flag_BorderFlat|#__flag_TextLeft  )
      ComboButton(10, 310+65+10, Width, 65, "right&center"              , #__flag_BorderFlat|#__flag_TextCenter )
      ComboButton(10, 460, Width, 65, "top&center"                      , #__flag_BorderFlat|#__flag_TextRight   )
      ComboButton(10, 460+65+10, Width, 65, "bottom&center"             , #__flag_BorderFlat|#__spin_Plus)
      
      ComboButton(10, 610, Width, 140, "center"                         , #__flag_BorderFlat);|#__flag_ImageCenter)
      
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 39
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware