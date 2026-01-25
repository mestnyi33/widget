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
   
   Procedure _SetText( *this._s_WIDGET, txt$ )
      If *this = #PB_All
         PushMapPosition( roots( ))
         ForEach roots( ) 
            If StartEnum( roots( ) )
               If widgets( )\picture\image = 1
                  SetText( widgets( ), txt$ )
               EndIf
               StopEnum( )
            EndIf    
         Next 
         PopMapPosition( roots( ))
      EndIf
   EndProcedure
   
   ;-
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
   
   Define i, h=65, Width = 200
   
   Global multiline = 0
   Global test, change_line, change_txt, change_img
   
   Procedure Click_Events( )
      Select EventWidget( )
         Case change_img
            If GetState( change_img )
               ResizeImage(1, 16,16, #PB_Image_Raw)
            Else
               ResizeImage(1, 32,32, #PB_Image_Raw)
            EndIf
            _SetImage( #PB_All, 1 )
            
         Case change_txt
            If multiline
               If GetState( change_txt )
                  _SetText( #PB_All, "text"+#LF$+"line" )
               Else
                  _SetText( #PB_All, "change"+#LF$+"line" )
               EndIf
            Else
               If GetState( change_txt )
                  _SetText( #PB_All, "text" )
               Else
                  _SetText( #PB_All, "change" )
               EndIf
            EndIf
            
      EndSelect
   EndProcedure
   
   Procedure Change_Events( )
      If test
         SetText( test, GetText( change_line))
      EndIf
   EndProcedure
   
   Procedure Test_Events( )
      test = EventWidget( )
      SetText( change_line, GetText( test))
   EndProcedure
   
   Procedure TestAlign( X,Y,Width,Height, flags.q=0 )
      Protected._s_WIDGET *g  
      Protected img = 1
      Protected txt$ = "text"
      
      If multiline
         txt$+#LF$+"line"
         flags|#__flag_TextMultiLine
      EndIf
      
      ;txt$ = ""
      ;img =- 1
      
      ;*g = CheckBox( X,Y,Width,Height, txt$, flags) : SetImage( *g, img ) 
      *g = Button( X,Y,Width,Height, txt$, flags) : SetImage( *g, img ) 
      ;*g = Text( X,Y,Width,Height, txt$, #__flag_BorderFlat|flags) : SetImage( *g, img )
      
      ;*g = ButtonImage( X,Y,Width,Height, img, flags) : SetText( *g, txt$ )
      ;*g = Image( X,Y,Width,Height, img, #__flag_BorderFlat|flags) : SetText( *g, txt$ )
      
      Alignment( *g, #__align_left|#__align_right)
      Bind(*g, @Test_Events( ), #__event_LeftClick)
      ProcedureReturn *g
   EndProcedure
   
   
   If Open(0, 0, 0, Width+20, 760, "test content alignment", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      TestAlign(10,  10,       Width, h, #__flag_Left)
      TestAlign(10,  10+65+10, Width, h, #__flag_Top)
      TestAlign(10, 160,       Width, h, #__flag_Right)
      TestAlign(10, 160+65+10, Width, h, #__flag_Bottom)
      
      TestAlign(10, 310,       Width, h, #__flag_Center|#__flag_Left)
      TestAlign(10, 310+65+10, Width, h, #__flag_Center|#__flag_Top)
      TestAlign(10, 460,       Width, h, #__flag_Center|#__flag_Right)
      TestAlign(10, 460+65+10, Width, h, #__flag_Center|#__flag_Bottom)
      
      TestAlign(10, 610, Width, h, #__flag_Center)
      ;  
      change_line = Editor(10, 685, Width, 40)
      Alignment( change_line, #__align_left|#__align_right)
      Bind(change_line, @Change_Events( ), #__event_Change)
      
      change_txt = Button(10, 725, Width/2, 25, "change txt", #PB_Button_Toggle )
      Alignment( change_txt, #__align_left|#__align_right)
      Bind(change_txt, @Click_Events( ), #__event_LeftClick)
      
      change_img = Button(10+Width/2, 725, Width/2, 25, "change img", #PB_Button_Toggle )
      Alignment( change_img, #__align_left|#__align_right)
      Bind(change_img, @Click_Events( ), #__event_LeftClick)
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 121
; FirstLine = 67
; Folding = 6+---
; EnableXP
; DPIAware