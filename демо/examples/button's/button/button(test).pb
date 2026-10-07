IncludePath "../../../../"
XIncludeFile "widgets.pbi"
;XIncludeFile "widgets_free.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Global size = 18
   Global size2 = 160
   Global *b16, *b32, *b0
   Global._s_WIDGET *g, *g1, *g2, *g3, *g4
   Global padding = 10
   Global Width = 340
   
   UsePNGImageDecoder()
   
   Global img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
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
            SetImage( *g1, 16)
            SetImage( *g2, 16)
            SetImage( *g3, 16)
            SetImage( *g4, 16)
            SetState( *g, 16+padding)
         Case *b32
            SetImage( *g1, 32)
            SetImage( *g2, 32)
            SetImage( *g3, 32)
            SetImage( *g4, 32)
            SetState( *g, 32+padding)
         Case *b0
            SetImage( *g1, 0)
            SetImage( *g2, 0)
            SetImage( *g3, 0)
            SetImage( *g4, 0)
            SetState( *g, size)
      EndSelect
   EndProcedure
   
   Procedure Test( X,Y,Width,Height,txt$, Flag.q=0)
      Protected._s_WIDGET *g
      *g = Editor(X,Y,Width,Height, Flag) :SetText(*g,txt$)
      ;*g = String(X,Y,Width,Height,txt$, Flag)
      ;*g = Button(X,Y,Width,Height,txt$, Flag)
      ;*g = Progress(X,Y,Width,Height,txt$, Flag)
       
       
;       If Flag & #__FLAG_Left
;          Flag &~ #__FLAG_Left
;       EndIf
;       If Flag & #__FLAG_Top
;          Flag &~ #__FLAG_Top
;       EndIf
;       If Flag & #__FLAG_Right
;          Flag &~ #__FLAG_Right
;       EndIf
;       If Flag & #__FLAG_Bottom
;          Flag &~ #__FLAG_Bottom
;       EndIf
      
      Protected Center
      ;If Flag & #__FLAG_Center
      ;   Center = #__FLAG_Center
      ;EndIf
      
      
      ;*g = String( X,Y,Width,Height,txt$, Flag)
      ;*g = Option( X,Y,Width,Height,txt$, Flag)
      ;*g = CheckBox( X,Y,Width,Height,txt$, Flag)
      
      ; *g = Button( X,Y,Width,Height,"", Flag) 
      ;*g = ButtonImage( X,Y,Width,Height,-1, Flag) : SetText( *g, txt$ )
      
      SetBackgroundColor( *g, #Yellow )
      SetImage( *g, img )
      ProcedureReturn *g
   EndProcedure
   
   If Open( 0, 0, 0, Width, 300, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
;       *g1 = Test( 10+size, 10, size2, size, "top button", #__FLAG_left )
;       *g2 = Test( 10, 10+size, size, size2, "left button", #__FLAG_Bottom|#__FLAG_Vertical)
;       *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__FLAG_Top|#__FLAG_Vertical|#__FLAG_Invert)
;       *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__FLAG_Right|#__FLAG_Invert)
;       
;       *g1 = Test( 10+size, 10, size2, size, "top button", #__FLAG_Right )
;       *g2 = Test( 10, 10+size, size, size2, "left button", #__FLAG_Top|#__FLAG_Vertical)
;       *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__FLAG_Bottom|#__FLAG_Vertical|#__FLAG_Invert)
;       *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__FLAG_Left|#__FLAG_Invert)
      
      *g1 = Test( 10+size, 10, size2, size, "top button", #__FLAG_Center )
      *g2 = Test( 10, 10+size, size, size2, "left button", #__FLAG_Center|#__FLAG_Vertical)
      *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__FLAG_Center|#__FLAG_Vertical|#__FLAG_Invert)
      *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__FLAG_Center|#__FLAG_Invert)
      
;       *g1 = Test( 10+size, 10, size2, size, "top button" )
;       *g2 = Test( 10, 10+size, size, size2, "left button", #__FLAG_Vertical)
;       *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__FLAG_Vertical|#__FLAG_Invert)
;       *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__FLAG_Invert)
      
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
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 118
; FirstLine = 94
; Folding = --
; EnableXP
; DPIAware