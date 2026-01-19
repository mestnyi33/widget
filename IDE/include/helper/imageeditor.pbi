; CompilerIf #PB_Compiler_IsMainFile
;   XIncludeFile "../../../widgets.pbi"
; CompilerEndIf

Declare  Open_EDITORIMAGES( Root, Flag = #PB_Window_TitleBar )
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

EnableExplicit
UseWidgets( )

UsePNGImageDecoder( )

Global EDITORIMAGES = - 1

Global IMAGE_VIEW = - 1
Global TEXT_SIZE = - 1
Global TRACK_SIZE = - 1
Global OPTION_SMOOTH = - 1
Global OPTION_RAW = - 1

Global BUTTON_OPEN = - 1
Global BUTTON_SAVE = - 1
Global BUTTON_COPY = - 1
Global BUTTON_CUT = - 1
Global BUTTON_PASTE = - 1
Global BUTTON_OK = - 1
Global BUTTON_CANCEL = - 1

Global IMG_LOAD = - 1
Global IMG_OPEN = - 1
Global IMG_SAVE = - 1
Global IMG_COPY = - 1
Global IMG_CUT = - 1
Global IMG_PASTE = - 1

Procedure Load_IMAGES( )
   IMG_OPEN = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png" )
   IMG_SAVE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png" )
   IMG_COPY = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png" )
   IMG_CUT = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png" )
   IMG_PASTE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" )
   
   CompilerIf #PB_Compiler_DPIAware
      ResizeImage(IMG_OPEN, DesktopScaledX(ImageWidth(IMG_OPEN)), DesktopScaledY(ImageHeight(IMG_OPEN)), #PB_Image_Raw )
      ResizeImage(IMG_SAVE, DesktopScaledX(ImageWidth(IMG_SAVE)), DesktopScaledY(ImageHeight(IMG_SAVE)), #PB_Image_Raw )
      ResizeImage(IMG_COPY, DesktopScaledX(ImageWidth(IMG_COPY)), DesktopScaledY(ImageHeight(IMG_COPY)), #PB_Image_Raw )
      ResizeImage(IMG_CUT, DesktopScaledX(ImageWidth(IMG_CUT)), DesktopScaledY(ImageHeight(IMG_CUT)), #PB_Image_Raw )
      ResizeImage(IMG_PASTE, DesktopScaledX(ImageWidth(IMG_PASTE)), DesktopScaledY(ImageHeight(IMG_PASTE)), #PB_Image_Raw )
   CompilerEndIf
EndProcedure

Procedure Free_IMAGES( )
   If IsImage( IMG_OPEN ) : FreeImage( IMG_OPEN ) : EndIf
   If IsImage( IMG_SAVE ) : FreeImage( IMG_SAVE ) : EndIf
   If IsImage( IMG_COPY ) : FreeImage( IMG_COPY ) : EndIf
   If IsImage( IMG_CUT ) : FreeImage( IMG_CUT ) : EndIf
   If IsImage( IMG_PASTE ) : FreeImage( IMG_PASTE ) : EndIf
EndProcedure

Procedure Disable_BUTTONS( state )
   Disable( BUTTON_SAVE, state )
   Disable( BUTTON_COPY, state )
   Disable( BUTTON_CUT, state )
   Disable( BUTTON_OK, state )
   
   Disable( TEXT_SIZE, state )
   Disable( TRACK_SIZE, state )
   Disable( OPTION_RAW, state )
   Disable( OPTION_SMOOTH, state )
EndProcedure

Procedure Events_EDITORIMAGES( )
   Static size
   Static CopyImage =- 1
               
   Select WidgetEvent( )
      Case #__event_free
         Protected img = GetImage( EventWidget( ))
         Debug "free "+ EventWidget( )\class ;+" "+ img
         If IsImage(img)
            Debug "    free image " + img
            FreeImage( img )
         EndIf
         
      Case #__event_leftClick
         Select EventWidget( )
            Case BUTTON_COPY,
                 BUTTON_CUT
               ;
               Define img = GetImage( IMAGE_VIEW )
               If IsImage( img )
                  SetClipboardImage( img )
                  Disable( BUTTON_PASTE, #False )
                  ;
                  If BUTTON_CUT = EventWidget( )
                     If RemoveImage( IMAGE_VIEW, img )
                        SetText( IMAGE_VIEW, "Загрузите изображения" )
                        ;
                        Disable_BUTTONS( #True )
                     EndIf
                  EndIf
               EndIf
               
            Case BUTTON_PASTE
               SetImage( IMAGE_VIEW, GetClipboardImage( #PB_Any, 32 ))
               SetText( IMAGE_VIEW, "" )
               ;
               Disable( BUTTON_PASTE, #True )
               Disable_BUTTONS( #False )
                  
            Case BUTTON_OPEN
               Define file$ = OpenFileRequester( "Пожалуйста выберите изображение для загрузки","",
                                                 "Image (*.png,*.bmp,*.ico,*.tiff)|*.png;*.bmp;*.ico;*.tiff|All files (*.*)|*.*", 
                                                 0,0);, WindowID(EventWindow( )) )
               ;
               If file$
                  If IsImage( IMG_LOAD )
                     FreeImage( IMG_LOAD )
                  EndIf
                  IMG_LOAD = AddImage( "", file$ )
                  Define state = ImageWidth( IMG_LOAD )/8 - 2
                  If state
                     If state > 10
                        SetAttribute( TRACK_SIZE, #PB_TrackBar_Maximum, state )
                     EndIf
                     SetState( TRACK_SIZE, state )
                  Else
                     SetImage( IMAGE_VIEW, IMG_LOAD )
                  EndIf
                  SetText( IMAGE_VIEW, "" )
                  ;Debug GetImageKey( IMAGE_VIEW );
                  
                  Disable_BUTTONS( #False )
               EndIf
               
            Case BUTTON_OK
               If size
                  ResizeImage( IMG_LOAD, size, size, GetState(OPTION_RAW) )
                  size = 0
               EndIf
               PostQuit( )
                          
            Case BUTTON_CANCEL
               IMG_LOAD = - 1
               PostQuit( )
         EndSelect
         
         ;
         Repaint( )

      Case #__event_Change
         Select EventWidget( )
            Case TRACK_SIZE, OPTION_RAW, OPTION_SMOOTH
               If IsImage( IMG_LOAD )
                  If IsImage( CopyImage )
                     FreeImage( CopyImage )
                  EndIf
                  size = ( 16 + (GetState(TRACK_SIZE) * 8) )
                  SetText(TEXT_SIZE, "x"+Str(SIZE))
                  CopyImage = CopyImage( IMG_LOAD, #PB_Any )
                  ResizeImage( CopyImage, size, size, GetState(OPTION_RAW) )
                  SetImage(IMAGE_VIEW, CopyImage )
               EndIf
         EndSelect
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure Open_EDITORIMAGES( Root, Flag = #PB_Window_TitleBar )
   Protected result
   Load_IMAGES( )
   
   EDITORIMAGES = Open( #PB_Any, 20, 20, 392, 232, "Редактор изображения", Flag | #PB_Window_WindowCentered | #PB_Window_Invisible, WindowID( GetCanvasWindow( Root )) )
   SetBackgroundColor( EDITORIMAGES, $D4F8F8F8 )
   SetClass( EDITORIMAGES, "EDITORIMAGES" )
   
   IMAGE_VIEW = Image( 7, 35, 253, 162, (-1), #__flag_Center|#__flag_BorderFlat )
   SetBackgroundColor( IMAGE_VIEW, $54EDDE )
   SetText( IMAGE_VIEW, "Загрузите изображения" )
   Widget( )\text\x = - 145
   Widget( )\text\y = - 18
   
   TEXT_SIZE = Text( 7, 7, 253, 22, "x16" )
   Disable( TEXT_SIZE, #True )
   
   TRACK_SIZE = Track( 40, 7, 220, 22, 0, 10, #PB_TrackBar_Ticks );| #__flag_invert);, 8.0 )
   Disable( TRACK_SIZE, #True )
   
   OPTION_RAW = Option( 7, 203, 120, 22, "Raw", #__flag_transparent|#__flag_Borderless )
   Disable( OPTION_RAW, #True )
   SetState( OPTION_RAW, 1 )
   
   OPTION_SMOOTH = Option( 140, 203, 120, 22, "Smooth", #__flag_transparent|#__flag_Borderless )
   Disable( OPTION_SMOOTH, #True )
      
   BUTTON_OPEN = Button( 266, 7, 119, 22, "Загрузить", #__flag_ImageLeft )
   SetImage( BUTTON_OPEN, IMG_OPEN )
   
   BUTTON_SAVE = Button( 266, 35, 119, 22, "Сохранить", #__flag_ImageLeft )
   Disable( BUTTON_SAVE, #True )
   SetImage( BUTTON_SAVE, IMG_SAVE )
   
   BUTTON_COPY = Button( 266, 77, 119, 22, "Копировать", #__flag_ImageLeft )
   Disable( BUTTON_COPY, #True )
   SetImage( BUTTON_COPY, IMG_COPY )
   
   BUTTON_CUT = Button( 266, 105, 119, 22, "Вырезать", #__flag_ImageLeft )
   Disable( BUTTON_CUT, #True )
   SetImage( BUTTON_CUT, IMG_CUT )
   
   BUTTON_PASTE = Button( 266, 133, 119, 22, "Вставить", #__flag_ImageLeft )
   Disable( BUTTON_PASTE, #True )
   SetImage( BUTTON_PASTE, IMG_PASTE )
   
   BUTTON_OK = Button( 266, 175, 119, 22, "Ок", #__flag_ImageLeft )
   Disable( BUTTON_OK, #True )
   
   BUTTON_CANCEL = Button( 266, 203, 119, 22, "Отмена", #__flag_ImageLeft )
   
   Bind( #PB_All, @Events_EDITORIMAGES( ))
   ReDraw(EDITORIMAGES)
   HideWindow( GetCanvasWindow( EDITORIMAGES), #False )
   Define Canvas = GetCanvasGadget( Root )
   ;
;    Debug ""+IsGadget( Canvas )+" "+Canvas
;    Debug ""+ GetCanvasGadget( root) +" "+ GetCanvasGadget( GetRoot( EDITORIMAGES ))
   WaitQuit( @EDITORIMAGES )
   ; Debug ""+IsGadget( Canvas )+" "+Canvas
   
   ; Debug ""+GetCanvasWindow(EDITORIMAGES) +" "+ IsWindow(GetCanvasWindow(EDITORIMAGES))
   ; ChangeCurrentCanvas( GadgetID( GetCanvasGadget( Root )))
   Free_Images( )
   
   If IsImage( IMG_LOAD )
      result = ChangeImage( IMG_LOAD )
      ; Debug ""+result+" "+IMG_LOAD
      FreeImage( IMG_LOAD )
      IMG_LOAD = - 1
   EndIf
   
   ProcedureReturn result
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile
   Procedure BUTTON_left_click_event( )
      Define Widget = EventWidget( )
      Define Root = EventWidget( )\root
      Define img = Open_EDITORIMAGES( Root )
      ; Define img = Open_EDITORIMAGES( root, -1, #PB_Window_BorderLess )
      
      If IsImage( img)
         Debug "Это изображение " + img
         SetImage( Root, img )
      EndIf
      
      Disable( Widget, #False )
   EndProcedure
   
   Define Root = Open( 0, 20, 20, 600, 600, "Загрузка изображения",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
   SetBackgroundColor( Widget( ), $54DE94 )
   Button( 600-300-10, 600-30-10, 300, 30, ~"Открыть окно \"Редактор изображения\"", #__flag_ImageLeft )
   Disable( Widget( ), #True )
   
   Bind( Widget( ), @BUTTON_left_click_event( ), #__event_LeftClick )
   Post( Widget( ), #__event_LeftClick )
   
   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 178
; FirstLine = 173
; Folding = ------
; EnableXP
; DPIAware