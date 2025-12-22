XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_align = 1
   test_draw_area = 1
   
   Define Image = 1
   Define i, Width = 250
   
   If Not LoadImage(Image, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(Image, DesktopScaledX(ImageWidth(Image)),DesktopScaledY(ImageHeight(Image)))
   EndIf
   
   Procedure TestAlign( X,Y,Width,Height, txt$, img, flags=0, align.q=0 )
      If flags & #__flag_Center
         flags &~ #__flag_Center
         flags | #__align_image
      EndIf
      
      Protected._s_WIDGET *g = ButtonImage( X,Y,Width,Height, img, flags)
      SetText( *g, txt$ )
      Alignment( *g, align )
   EndProcedure
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      TestAlign(10,  10, Width/2-5, 65, "left&top"                     , Image, #__flag_Left |#__flag_Top,    #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5,  10, Width/2-5, 65, "right&top"          , Image, #__flag_Right|#__flag_Top,    #__align_proportional|#__align_right )
      TestAlign(10,  10+65+10, Width/2-5, 65, "left&bottom"            , Image, #__flag_Left |#__flag_Bottom, #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5,  10+65+10, Width/2-5, 65, "right&bottom" , Image, #__flag_Right|#__flag_Bottom, #__align_proportional|#__align_right )
      
      TestAlign(10, 160, Width/2-5, 65, "left"                         , Image, #__flag_Left,                 #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5, 160, Width/2-5, 65, "right"              , Image, #__flag_Right,                #__align_proportional|#__align_right )
      TestAlign(10, 160+65+10, Width/2-5, 65, "top"                    , Image, #__flag_Top,                  #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5, 160+65+10, Width/2-5, 65, "bottom"       , Image, #__flag_Bottom,               #__align_proportional|#__align_right )
      
      TestAlign(10, 310, Width, 65, "left&center"                      , Image, #__flag_TextLeft,             #__align_left|#__align_right )
      TestAlign(10, 310+65+10, Width, 65, "right&center"               , Image, #__flag_TextRight,            #__align_left|#__align_right )
      TestAlign(10, 460, Width, 65, "top&center"                       , Image, #__flag_TextTop,              #__align_left|#__align_right )
      TestAlign(10, 460+65+10, Width, 65, "bottom&center"              , Image, #__flag_TextBottom,           #__align_left|#__align_right )
      
      TestAlign(10, 610, Width, 140, "default"                         , Image,0,                             #__align_left|#__align_right)
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
      
;       Button 1 1  0 0  0 0  0 0 left
;       Button 0 0  0 0  1 1  0 0 right
;       Button 0 0  1 1  0 0  0 0 top
;       Button 0 0  0 0  0 0  1 1 bottom
;       Button 1 0  0 0  0 0  0 0 left&center
;       Button 0 0  0 0  1 0  0 0 right&center
;       Button 0 0  1 0  0 0  0 0 top&center
;       Button 0 0  0 0  0 0  1 0 bottom&center
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 29
; FirstLine = 20
; Folding = --
; EnableXP
; DPIAware