IncludePath "../../"
XIncludeFile "widgets.pbi"
;XIncludeFile "test.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Global multiline = 1
   Global size = 40
   Global size2 = 400
   Global Width = 550
   Global *b16, *b32, *b0
   Global._s_WIDGET *g, *g1, *g2, *g3, *g4, *g5, *g6, *g7, *g8, *g9, *g10, *g11, *g12, *g13, *g14, *g15, *g16
   
   UsePNGImageDecoder()
   
   Global img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
   If Not img
      End
   EndIf
   
   CopyImage( img, 16 ) : ResizeImage( 16, 16, 16 )
   CopyImage( img, 32 ) : ResizeImage( 32, 32, 32 )
   
   Procedure change_image_events( )
      Select EventWidget( )
         Case *b16
            SetImage( *g1, 16)
            SetImage( *g2, 16)
            SetImage( *g3, 16)
            SetImage( *g4, 16)
            SetImage( *g5, 16)
            SetImage( *g6, 16)
            SetImage( *g7, 16)
            SetImage( *g8, 16)
            SetImage( *g9, 16)
            SetImage( *g10, 16)
            SetImage( *g11, 16)
            SetImage( *g12, 16)
            SetImage( *g13, 16)
            SetImage( *g14, 16)
            SetImage( *g15, 16)
            SetImage( *g16, 16)
         Case *b32
            SetImage( *g1, 32)
            SetImage( *g2, 32)
            SetImage( *g3, 32)
            SetImage( *g4, 32)
            SetImage( *g5, 32)
            SetImage( *g6, 32)
            SetImage( *g7, 32)
            SetImage( *g8, 32)
            SetImage( *g9, 32)
            SetImage( *g10, 32)
            SetImage( *g11, 32)
            SetImage( *g12, 32)
            SetImage( *g13, 32)
            SetImage( *g14, 32)
            SetImage( *g15, 32)
            SetImage( *g16, 32)
         Case *b0
            SetImage( *g1, 0)
            SetImage( *g2, 0)
            SetImage( *g3, 0)
            SetImage( *g4, 0)
            SetImage( *g5, 0)
            SetImage( *g6, 0)
            SetImage( *g7, 0)
            SetImage( *g8, 0)
            SetImage( *g9, 0)
            SetImage( *g10, 0)
            SetImage( *g11, 0)
            SetImage( *g12, 0)
            SetImage( *g13, 0)
            SetImage( *g14, 0)
            SetImage( *g15, 0)
            SetImage( *g16, 0)
      EndSelect
   EndProcedure
   
   Procedure Test( X,Y,Width,Height,txt$, Flag.q=0)
      Protected._s_WIDGET *g
      If multiline
         txt$+#LF$+"line"
         flag|#__flag_TextMultiLine
      EndIf
      
      *g = Button(X,Y,Width,Height,txt$, Flag)
      ; *g = ComboBox(X,Y,Width,Height, Flag) : AddItem(*g, -1, txt$) : SetState( *g, 0)
      
      
      ;*g = Text(X,Y,Width,Height,txt$, Flag)
      ;*g = Image( X,Y,Width,Height,-1, Flag) : SetText( *g, txt$ ) 
      ;*g = String( X,Y,Width,Height,txt$, Flag)
      ;*g = CheckBox( X,Y,Width,Height,txt$, Flag)
      ;*g = Option( X,Y,Width,Height,txt$, Flag)
      ;*g = Progress(X,Y,Width,Height,0,100, Flag) : SetState( *g, 50)
      
      SetBackgroundColor( *g, #Yellow )
      SetImage( *g, img )
      ProcedureReturn *g
   EndProcedure
   
   If Open( 0, 0, 0, Width, 500, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *g1 = Test( 10+size, 10, size2, size, "center text right", #__flag_Center)
      *g2 = Test( 10, 10+size, size, size2, "center text top", #__flag_Center|#__flag_Vertical)
      *g3 = Test( size2+10+size, 10+size, size, size2, "center text bottom", #__flag_Center|#__flag_Vertical|#__flag_Invert)
      *g4 = Test( 10+size, size2+10+size, size2, size, "center text left", #__flag_Center|#__flag_Invert)
      
      *g5 = Test( 10+size*2, 10+size, size2-size*2, size, "left text", #__flag_left )
      *g6 = Test( 10+size, 10+size*2, size, size2-size*2, "bottom text", #__flag_Bottom|#__flag_Vertical)
      *g7 = Test( size2-size+10+size, 10+size*2, size, size2-size*2, "top text", #__flag_Top|#__flag_Vertical|#__flag_Invert)
      *g8 = Test( 10+size*2, size2-size+10+size, size2-size*2, size, "right text", #__flag_Right|#__flag_Invert)
      
      *g9 = Test( 10+size*3, 10+size*2, size2-size*4, size, "text right", #__flag_Right )
      *g10 = Test( 10+size*2, 10+size*3, size, size2-size*4, "text top", #__flag_Top|#__flag_Vertical)
      *g11 = Test( size2-size*2+10+size, 10+size*3, size, size2-size*4, "text bottom", #__flag_Bottom|#__flag_Vertical|#__flag_Invert)
      *g12 = Test( 10+size*3, size2-size*2+10+size, size2-size*4, size, "text left", #__flag_Left|#__flag_Invert)
      
      *g13 = Test( 10+size*4, 10+size*3, size2-size*6, size, "default h")
      *g14 = Test( 10+size*3, 10+size*4, size, size2-size*6, "default v", #__flag_Vertical)
      *g15 = Test( size2-size*3+10+size, 10+size*4, size, size2-size*6, "default v invert", #__flag_Vertical|#__flag_Invert)
      *g16 = Test( 10+size*4, size2-size*3+10+size, size2-size*6, size, "default h invert", #__flag_Invert)
      
      ;
      *b0 = Button( Width-40, 10, 30,30, "0")
      *b16 = Button( Width-40, 10+40, 30,30, "16")
      *b32 = Button( Width-40, 10+80, 30,30, "32")
      Bind( *b0, @change_image_events( ), #__event_LeftClick )
      Bind( *b16, @change_image_events( ), #__event_LeftClick )
      Bind( *b32, @change_image_events( ), #__event_LeftClick )
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 86
; FirstLine = 24
; Folding = 4-
; EnableXP
; DPIAware