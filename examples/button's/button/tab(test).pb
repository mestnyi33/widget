IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global size = 27
   Global size2 = 130
   Global *b16, *b32, *b0
   Global._s_WIDGET *g, *g1, *g2, *g3, *g4
   Global padding = 10
   Global Width = 340
   
   UsePNGImageDecoder()
   
   Define img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
   If Not img
      End
   EndIf
   
   CopyImage( img, 16 ) : ResizeImage( 16, 16, 16 )
   CopyImage( img, 32 ) : ResizeImage( 32, 32, 32 )
   
   Procedure change_events( )
      Protected size = GetState( EventWidget( ))
      SetWindowTitle(EventWindow(), Str(size))
      
      Resize( *g1, 10+size, #PB_Ignore, #PB_Ignore, size )
      Resize( *g2, #PB_Ignore, 10+size, size, #PB_Ignore )
      Resize( *g3, size2+10+size, 10+size, size, #PB_Ignore )
      Resize( *g4, 10+size, size2+10+size, #PB_Ignore, size )
   EndProcedure
   
   Procedure change_image_events( )
      Select EventWidget( )
         Case *b16
            SetItemImage( *g1\tabbar, 0, 16)
            SetItemImage( *g2\tabbar, 0, 16)
            SetItemImage( *g3\tabbar, 0, 16)
            SetItemImage( *g4\tabbar, 0, 16)
            SetState( *g, 16+padding)
         Case *b32
            SetItemImage( *g1\tabbar, 0, 32)
            SetItemImage( *g2\tabbar, 0, 32)
            SetItemImage( *g3\tabbar, 0, 32)
            SetItemImage( *g4\tabbar, 0, 32)
            SetState( *g, 32+padding)
         Case *b0
            SetItemImage( *g1\tabbar, 0, 0)
            SetItemImage( *g2\tabbar, 0, 0)
            SetItemImage( *g3\tabbar, 0, 0)
            SetItemImage( *g4\tabbar, 0, 0)
            SetState( *g, size)
      EndSelect
   EndProcedure
   
   Procedure Test( X,Y,Width,Height,txt$, Flag.q=0)
      Protected._s_WIDGET *g
      
      If Flag & #__flag_Left
         Flag &~ #__flag_Left
      EndIf
      
      If Flag & #__flag_Vertical And Flag & #__flag_Invert
         Flag | #__flag_Right
      ElseIf Flag & #__flag_Vertical
         Flag | #__flag_Left
      ElseIf Flag & #__flag_Invert
         Flag | #__flag_Bottom
      EndIf
      
      ;*g = Button( X,Y,Width,Height,txt$, Flag)
      *g = Panel( X,Y,Width,Height, Flag) : AddItem( *g,-1, txt$, 16 ):CloseList()
      
      ProcedureReturn *g
    EndProcedure
   
   If Open( 0, 0, 0, Width, 300, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *g1 = Test( 10+size, 10, size2, size, "top button", #__flag_left )
      *g2 = Test( 10, 10+size, size, size2, "left button", #__flag_Bottom|#__flag_Vertical)
      *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__flag_Top|#__flag_Vertical|#__flag_Invert)
      *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__flag_Right|#__flag_Invert)
      
      ;
      *b0 = Button( Width-40, 10, 30,30, "0")
      *b16 = Button( Width-40, 10+40, 30,30, "16")
      *b32 = Button( Width-40, 10+80, 30,30, "32")
      Bind( *b0, @change_image_events( ), #__event_LeftClick )
      Bind( *b16, @change_image_events( ), #__event_LeftClick )
      Bind( *b32, @change_image_events( ), #__event_LeftClick )
      
      *g = Track( 10, 300-10-20, Width-20, 20, 0, 32+padding )
      SetState( *g, size )
      Bind( *g, @change_events( ), #__event_Change )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 73
; FirstLine = 69
; Folding = --
; EnableXP
; DPIAware