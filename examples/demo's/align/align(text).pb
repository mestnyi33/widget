IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
   ; Shows possible flags of ButtonGadget in action...
   EnableExplicit
   UseWidgets( )
   
    test_draw_area = 1
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
   Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
      
      ;_flag_|#__flag_vertical
      
      Button(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_text_multiline)
      ;
      ;Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_text_multiline)
      ;CheckBox(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_text_multiline)
      ;
      ;Text(_x_,_y_,_width_,_height_,_text_,_flag_)
      ;Editor(_x_,_y_,_width_,_height_, _flag_|#__flag_text_multiline) : SetText(widget(), _text_)
      ;String(_x_,_y_,_width_,_height_,_text_,_flag_)
   EndProcedure
   
   Define m.s = #LF$
   Define Width = 140
   Define Height = 90
   Define space = 5
   Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
   Define X,Y = (Height+space)*3 + 5
   
   
   If Open(0, 0, 0, X+(Width+space)*3 + 15, Y+(Height+space)*3 + 15, "vertical text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor( widget( ), #PB_Gadget_BackColor, $FFffffff )
      a_init( widget() )
      
      ; horizontal
      GadgeCreate(0, 10, 10,                      Width, Height, text_h,                      #PB_Button_Left|#__flag_text_Top);
      GadgeCreate(1, 10, 10+(Height+space)*1, Width, Height, text_h,                      #PB_Button_Left);|#__flag_text_Center) ;
      GadgeCreate(2, 10, 10+(Height+space)*2, Width, Height, text_h,                      #PB_Button_Left|#__flag_text_Bottom) ;
      
      GadgeCreate(3, 10+(Width+space), 10,                      Width, Height, text_h,        #__flag_text_Center|#__flag_text_Top);
      GadgeCreate(4, 10+(Width+space), 10+(Height+space)*1, Width, Height, text_h,        #__flag_text_Center)                ;
      GadgeCreate(5, 10+(Width+space), 10+(Height+space)*2, Width, Height, text_h,        #__flag_text_Center|#__flag_text_Bottom) ;
      
      GadgeCreate(6, 10+(Width+space)*2, 10,                      Width, Height, text_h,      #PB_Button_Right|#__flag_text_Top);
      GadgeCreate(7, 10+(Width+space)*2, 10+(Height+space)*1, Width, Height, text_h,      #PB_Button_Right|#__flag_text_Center) ;
      GadgeCreate(10, 10+(Width+space)*2, 10+(Height+space)*2, Width, Height, text_h,      #PB_Button_Right|#__flag_text_Bottom);
      
      
      ; horizontal invert
      GadgeCreate(20, X+10, Y+10,                      Width, Height, text_h,                      #__flag_text_Invert|#PB_Button_Left|#__flag_text_Top);
      GadgeCreate(21, X+10, Y+10+(Height+space)*1, Width, Height, text_h,                      #__flag_text_Invert|#PB_Button_Left|#__flag_text_Center) ;
      GadgeCreate(22, X+10, Y+10+(Height+space)*2, Width, Height, text_h,                      #__flag_text_Invert|#PB_Button_Left|#__flag_text_Bottom) ;
      
      GadgeCreate(23, X+10+Width+space, Y+10,                      Width, Height, text_h,        #__flag_text_Invert|#__flag_text_Center|#__flag_text_Top);
      GadgeCreate(24, X+10+Width+space, Y+10+(Height+space)*1, Width, Height, text_h,        #__flag_text_Invert|#__flag_text_Center)                ;
      GadgeCreate(25, X+10+Width+space, Y+10+(Height+space)*2, Width, Height, text_h,        #__flag_text_Invert|#__flag_text_Center|#__flag_text_Bottom) ;
      
      GadgeCreate(26, X+10+(Width+space)*2, Y+10,                      Width, Height, text_h,      #__flag_text_Invert|#PB_Button_Right|#__flag_text_Top);
      GadgeCreate(27, X+10+(Width+space)*2, Y+10+(Height+space)*1, Width, Height, text_h,      #__flag_text_Invert|#PB_Button_Right|#__flag_text_Center) ;
      GadgeCreate(210, X+10+(Width+space)*2, Y+10+(Height+space)*2, Width, Height, text_h,      #__flag_text_Invert|#PB_Button_Right|#__flag_text_Bottom);
      
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 47
; FirstLine = 33
; Folding = -
; EnableXP
; DPIAware