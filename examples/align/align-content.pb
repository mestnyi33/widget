XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_align = 1
   test_draw_area = 1
   
   Macro add_image( _address_, _img_, _size_ = 0 )
      ;
      If IsImage( _img_ )
         If _size_
            _address_\width  = _size_
            _address_\height = _size_
            ResizeImage( _img_, _size_, _size_, #PB_Image_Raw )
         Else
            _address_\width  = ImageWidth( _img_ )
            _address_\height = ImageHeight( _img_ )
         EndIf
         
         _address_\change  = 1
         _address_\image   = _img_
         _address_\imageID = ImageID( _img_ )
      Else
         _address_\change  = - 1
         _address_\image   = - 1
         _address_\imageID = 0
         _address_\width   = 0
         _address_\height  = 0
      EndIf
   EndMacro
   
   Procedure _SetImage( *this._s_WIDGET, img )
      If *this = #PB_All
         PushMapPosition( roots( ))
         ForEach roots( ) 
            If StartEnum( roots( ) )
               If widgets( )\picture\image = img
                  ; Debug widgets( )\class
                  ; widgets( )\picturesize = ImageWidth(img)
                  add_image( widgets( )\picture, img )
               EndIf
               StopEnum( )
            EndIf    
         Next 
         PopMapPosition( roots( ))
      EndIf
   EndProcedure
   
   Define Image = 1
   Define i, Width = 250
   
   If Not LoadImage(Image, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(Image, DesktopScaledX(ImageWidth(Image)),DesktopScaledY(ImageHeight(Image)))
   EndIf
   
   Global test, change_text, change_img
   
   Procedure Click_Events( )
      If GetState( change_img )
         ResizeImage(1, 16,16, #PB_Image_Raw)
      Else
         ResizeImage(1, 32,32, #PB_Image_Raw)
      EndIf
      _SetImage( #PB_All, 1 )
   EndProcedure
   
   Procedure Change_Events( )
      If test
         SetText( test, GetText( change_text))
      EndIf
   EndProcedure
   
   Procedure Test_Events( )
      test = EventWidget( )
      SetText( change_text, GetText( test))
   EndProcedure
  
   Procedure TestAlign( X,Y,Width,Height, txt$, img, flags=0, align.q=0 )
      Protected._s_WIDGET *g
      If flags & #__flag_Center
         flags &~ #__flag_Center
         flags | #__align_image
      EndIf
      ;
      ; flags|#__flag_TextMultiLine
      
      *g = Button( X,Y,Width,Height, txt$, flags) : SetImage( *g, img )
      ;*g = ButtonImage( X,Y,Width,Height, img, flags) : SetText( *g, txt$ )
      
      Alignment( *g, align )
      Bind(*g, @Test_Events( ), #__event_LeftClick)
   EndProcedure
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      TestAlign(10,  10, Width/2-5, 65, "left&top"                     , Image, #__flag_Left |#__flag_Top,    #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5,  10, Width/2-5, 65, "right&top"          , Image, #__flag_Right|#__flag_Top,    #__align_proportional|#__align_right )
      TestAlign(10,  10+65+10, Width/2-5, 65, "left&bottom"            , Image, #__flag_Left |#__flag_Bottom, #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5,  10+65+10, Width/2-5, 65, "right&bottom" , Image, #__flag_Right|#__flag_Bottom, #__align_proportional|#__align_right )
      
      TestAlign(10, 160, Width/2-5, 65, "left"                         , Image, #__flag_Left,                 #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5, 160, Width/2-5, 65, "right"              , Image, #__flag_Right,                #__align_proportional|#__align_right )
      TestAlign(10, 160+65+10, Width/2-5, 65, "  top  "                    , Image, #__flag_Top,                  #__align_proportional|#__align_left )
      TestAlign(10+Width/2+5, 160+65+10, Width/2-5, 65, "bottom"       , Image, #__flag_Bottom,               #__align_proportional|#__align_right )
      
      TestAlign(10, 310, Width, 65, "left&center"                      , Image, #__flag_TextLeft,             #__align_left|#__align_right )
      TestAlign(10, 310+65+10, Width, 65, "right&center"               , Image, #__flag_TextRight,            #__align_left|#__align_right )
      TestAlign(10, 460, Width, 65, "top&center"                       , Image, #__flag_TextTop,              #__align_left|#__align_right )
      TestAlign(10, 460+65+10, Width, 65, "bottom&center"              , Image, #__flag_TextBottom,           #__align_left|#__align_right )
      
      TestAlign(10, 610, Width, 65, "default"                         , Image,0,                             #__align_left|#__align_right)
      
      ;  
      ;  
      change_text = Editor(10, 685, Width, 40)
      Alignment( change_text, #__align_left|#__align_right)
      Bind(change_text, @Change_Events( ), #__event_Change)
      
      change_img = Button(10, 725, Width, 25, "change image size", #PB_Button_Toggle )
      Alignment( change_img, #__align_left|#__align_right)
      Bind(change_img, @Click_Events( ), #__event_LeftClick)
      
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
; CursorPosition = 124
; FirstLine = 104
; Folding = ---
; EnableXP
; DPIAware