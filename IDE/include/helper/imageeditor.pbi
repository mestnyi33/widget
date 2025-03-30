; CompilerIf #PB_Compiler_IsMainFile
;   XIncludeFile "../../../widgets.pbi"
; CompilerEndIf

Declare  Open_EDITORIMAGES( root, flag = #PB_Window_TitleBar )
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

EnableExplicit
UseWidgets( )

UsePNGImageDecoder( )

Global EDITORIMAGES = - 1

Global IMAGE_VIEW = - 1
Global BUTTON_OPEN = - 1
Global BUTTON_SAVE = - 1
Global BUTTON_COPY = - 1
Global BUTTON_CUT = - 1
Global BUTTON_PASTE = - 1
Global BUTTON_OK = - 1
Global BUTTON_CANCEL = - 1

Global LOADIMAGE = - 1
Global OPEN_IMAGE = - 1
Global SAVE_IMAGE = - 1
Global COPY_IMAGE = - 1
Global CUT_IMAGE = - 1
Global PASTE_IMAGE = - 1

Procedure Load_IMAGES( )
   OPEN_IMAGE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png" )
   SAVE_IMAGE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png" )
   COPY_IMAGE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png" )
   CUT_IMAGE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png" )
   PASTE_IMAGE = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" )
   
   CompilerIf #PB_Compiler_DPIAware
      ResizeImage(OPEN_IMAGE, DesktopScaledX(ImageWidth(OPEN_IMAGE)), DesktopScaledY(ImageHeight(OPEN_IMAGE)), #PB_Image_Raw )
      ResizeImage(SAVE_IMAGE, DesktopScaledX(ImageWidth(SAVE_IMAGE)), DesktopScaledY(ImageHeight(SAVE_IMAGE)), #PB_Image_Raw )
      ResizeImage(COPY_IMAGE, DesktopScaledX(ImageWidth(COPY_IMAGE)), DesktopScaledY(ImageHeight(COPY_IMAGE)), #PB_Image_Raw )
      ResizeImage(CUT_IMAGE, DesktopScaledX(ImageWidth(CUT_IMAGE)), DesktopScaledY(ImageHeight(CUT_IMAGE)), #PB_Image_Raw )
      ResizeImage(PASTE_IMAGE, DesktopScaledX(ImageWidth(PASTE_IMAGE)), DesktopScaledY(ImageHeight(PASTE_IMAGE)), #PB_Image_Raw )
   CompilerEndIf
EndProcedure

Procedure Free_IMAGES( )
   If IsImage( OPEN_IMAGE ) : FreeImage( OPEN_IMAGE ) : EndIf
   If IsImage( SAVE_IMAGE ) : FreeImage( SAVE_IMAGE ) : EndIf
   If IsImage( COPY_IMAGE ) : FreeImage( COPY_IMAGE ) : EndIf
   If IsImage( CUT_IMAGE ) : FreeImage( CUT_IMAGE ) : EndIf
   If IsImage( PASTE_IMAGE ) : FreeImage( PASTE_IMAGE ) : EndIf
EndProcedure

Procedure Events_EDITORIMAGES( )
   
   Select WidgetEvent( )
      Case #__event_free
         Debug "free "+ EventWidget( )\class +" "+ GetImage( EventWidget( ))
         
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
                        Disable( BUTTON_SAVE, #True )
                        Disable( BUTTON_COPY, #True )
                        Disable( BUTTON_CUT, #True )
                        Disable( BUTTON_OK, #True )
                        ReDraw( root( ))
                     EndIf
                  EndIf
               EndIf
               
            Case BUTTON_PASTE
               SetImage( IMAGE_VIEW, GetClipboardImage( #PB_Any, 32 ))
               SetText( IMAGE_VIEW, "" )
               ;
               Disable( BUTTON_SAVE, #False )
               Disable( BUTTON_COPY, #False )
               Disable( BUTTON_CUT, #False )
               Disable( BUTTON_OK, #False )
               Disable( BUTTON_PASTE, #True )
               ReDraw( root( ))
                  
            Case BUTTON_OPEN
               Define file$ = OpenFileRequester( "Пожалуйста выберите изображение для загрузки","",
                                                 "Image (*.png,*.bmp,*.ico,*.tiff)|*.png;*.bmp;*.ico;*.tiff|All files (*.*)|*.*", 
                                                 0,0);, WindowID(EventWindow( )) )
               ;
               If file$
                  If IsImage( LOADIMAGE )
                     FreeImage( LOADIMAGE )
                  EndIf
                  ;LOADIMAGE = LoadImage( #PB_Any, file$ )
                  LOADIMAGE = AddImage( "", file$ )
                  SetImage( IMAGE_VIEW, LOADIMAGE )
                  SetText( IMAGE_VIEW, "" )
                  Debug GetImageKey( IMAGE_VIEW );
                  Disable( BUTTON_SAVE, #False )
                  Disable( BUTTON_COPY, #False )
                  Disable( BUTTON_CUT, #False )
                  ; Disable( BUTTON_PASTE, #False )
                  Disable( BUTTON_OK, #False )
                  ReDraw( root( ))
               EndIf
               
            Case BUTTON_OK
               PostQuit( )
                          
            Case BUTTON_CANCEL
               LOADIMAGE = - 1
               PostQuit( )
               
         EndSelect
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure Open_EDITORIMAGES( root, flag = #PB_Window_TitleBar )
   Protected result
   Load_IMAGES( )
   
   EDITORIMAGES = Open( #PB_Any, 20, 20, 392, 232, "Редактор изображения", flag | #PB_Window_WindowCentered | #PB_Window_Invisible, WindowID( GetCanvasWindow( root )) )
   SetBackgroundColor( EDITORIMAGES, $DCDCDC )
   SetClass( EDITORIMAGES, "EDITORIMAGES" )
   
   IMAGE_VIEW = Image( 7, 7, 253, 218, (-1), #__image_Center|#__flag_border_Flat )
   SetBackgroundColor( IMAGE_VIEW, $54EDDE )
   
   SetText( IMAGE_VIEW, "Загрузите изображения" )
   widget( )\txt\x = - 145
   widget( )\txt\y = - 18
   
   BUTTON_OPEN = Button( 266, 7, 119, 22, "Загрузить", #__image_Left )
   SetImage( BUTTON_OPEN, OPEN_IMAGE )
   
   BUTTON_SAVE = Button( 266, 35, 119, 22, "Сохранить", #__image_Left )
   SetImage( BUTTON_SAVE, SAVE_IMAGE )
   Disable( BUTTON_SAVE, #True )
   
   BUTTON_COPY = Button( 266, 77, 119, 22, "Копировать", #__image_Left )
   SetImage( BUTTON_COPY, COPY_IMAGE )
   Disable( BUTTON_COPY, #True )
   
   BUTTON_CUT = Button( 266, 105, 119, 22, "Вырезать", #__image_Left )
   SetImage( BUTTON_CUT, CUT_IMAGE )
   Disable( BUTTON_CUT, #True )
   
   BUTTON_PASTE = Button( 266, 133, 119, 22, "Вставить", #__image_Left )
   SetImage( BUTTON_PASTE, PASTE_IMAGE )
   Disable( BUTTON_PASTE, #True )
   
   BUTTON_OK = Button( 266, 175, 119, 22, "Ок", #__image_Left )
   Disable( BUTTON_OK, #True )
   
   BUTTON_CANCEL = Button( 266, 203, 119, 22, "Отмена", #__image_Left )
   
   Bind( #PB_All, @Events_EDITORIMAGES( ))
   ReDraw(EDITORIMAGES)
   HideWindow( GetCanvasWindow( EDITORIMAGES), #False )
   WaitQuit( EDITORIMAGES )
   Free_Images( )
   
   ChangeCurrentCanvas( GadgetID( GetCanvasGadget( root )))
   ; Debug ""+GetCanvasWindow(EDITORIMAGES) +" "+ IsWindow(GetCanvasWindow(EDITORIMAGES))
   
   If IsImage( LOADIMAGE )
      result = ChangeImage( LOADIMAGE )
      FreeImage( LOADIMAGE )
      LOADIMAGE = - 1
   EndIf
               
   ProcedureReturn result
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile
   Procedure button_left_click_event( )
      Define widget = EventWidget( )
      Define root = EventWidget( )\root
      Define img = Open_EDITORIMAGES( root )
      ; Define img = Open_EDITORIMAGES( root, -1, #PB_Window_BorderLess )
      
      If IsImage( img)
         Debug "Это изображение " + img
         SetImage( root, img )
      EndIf
      
      Disable( widget, #False )
   EndProcedure
   
   Define root = Open( 0, 20, 20, 600, 600, "Загрузка изображения",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
   SetBackgroundColor( widget( ), $54DE94 )
   Button( 600-300-10, 600-30-10, 300, 30, ~"Открыть окно \"Редактор изображения\"", #__image_Left )
   Disable( widget( ), #True )
   
   Bind( widget( ), @button_left_click_event( ), #__event_LeftClick )
   Post( widget( ), #__event_LeftClick )
   
   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 110
; FirstLine = 87
; Folding = ----
; EnableXP
; DPIAware