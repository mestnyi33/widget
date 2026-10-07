XIncludeFile "../../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_align = 1
   test_draw_area = 1
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
   
   Define Image = 1
   Define i, Width = 250
   
   Global test, str
   Procedure Change_Events( )
      If test
         SetText( test, GetText( str))
      EndIf
   EndProcedure
   
   Procedure Test_Events( )
      test = EventWidget( )
      SetText( str, GetText( test))
   EndProcedure
   
   Procedure TestAlign( X,Y,Width,Height, txt$, flags=0, align.q=0 )
      Protected._s_WIDGET *g = Button( X,Y,Width,Height, txt$, flags);|#__FLAG_TextMultiLine )
      
      Alignment( *g, align )
      Bind(*g, @Test_Events( ), #__event_LeftClick)
   EndProcedure
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      TestAlign(10,  10, Width/2-5, 65, "left&top"                     , #__FLAG_Left |#__FLAG_Top, #__FLAG_proportional|#__FLAG_left   )
      TestAlign(10+Width/2+5,  10, Width/2-5, 65, "right&top"          , #__FLAG_Right|#__FLAG_Top  , #__FLAG_proportional|#__FLAG_right )
      TestAlign(10,  10+65+10, Width/2-5, 65, "left&bottom"            , #__FLAG_Left |#__FLAG_Bottom, #__FLAG_proportional|#__FLAG_left)
      TestAlign(10+Width/2+5,  10+65+10, Width/2-5, 65, "right&bottom" , #__FLAG_Right|#__FLAG_Bottom, #__FLAG_proportional|#__FLAG_right)
      
      TestAlign(10, 160, Width/2-5, 65, "left"                         , #__FLAG_Left, #__FLAG_proportional|#__FLAG_left  )
      TestAlign(10+Width/2+5, 160, Width/2-5, 65, "right"              , #__FLAG_Right, #__FLAG_proportional|#__FLAG_right )
      TestAlign(10, 160+65+10, Width/2-5, 65, "top"                    , #__FLAG_Top, #__FLAG_proportional|#__FLAG_left   )
      TestAlign(10+Width/2+5, 160+65+10, Width/2-5, 65, "bottom"       , #__FLAG_Bottom, #__FLAG_proportional|#__FLAG_right)
      
      TestAlign(10, 310, Width, 65, "left&center"                      , #__FLAG_Left, #__FLAG_left|#__FLAG_right  )
      TestAlign(10, 310+65+10, Width, 65, "right&center"               , #__FLAG_Right, #__FLAG_left|#__FLAG_right )
      TestAlign(10, 460, Width, 65, "top&center"                       , #__FLAG_Top, #__FLAG_left|#__FLAG_right   )
      TestAlign(10, 460+65+10, Width, 65, "bottom&center"              , #__FLAG_Bottom, #__FLAG_left|#__FLAG_right)
      
      TestAlign(10, 610, Width, 65, "default"                         ,0, #__FLAG_left|#__FLAG_right);, #__FLAG_Center)
      
      ;  
      str = Editor(10, 685, Width, 65)
      Bind(str, @Change_Events( ), #__event_Change)
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 31
; FirstLine = 28
; Folding = --
; EnableXP
; DPIAware