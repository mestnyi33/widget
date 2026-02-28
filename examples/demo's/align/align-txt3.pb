IncludePath "../../" : XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
   ; Shows possible flags of ButtonGadget in action...
   EnableExplicit
   UseWidgets( )
    test_draw_area = 1
   
   Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
      ;Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;CheckBox(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;
      ;Text(_x_,_y_,_width_,_height_,_text_,_flag_)
      Button(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;Editor(_x_,_y_,_width_,_height_, _flag_|#__flag_Textmultiline) : settext(widget(), _text_)
      ;String(_x_,_y_,_width_,_height_,_text_,_flag_)
   EndProcedure
   
   Define m.s = #LF$
   Define Width = 90
   Define Height = 140
   Define space = 5
   Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
   Define Y,X = (Width+space)*3 + 5
   
   If Open(0, 0, 0, X+(Width+space)*3 + 15, Y+(Height+space)*3 + 15, "vertical text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor( Widget( ), #PB_Gadget_BackColor, $FFffffff )
      
      ; vertical
      GadgeCreate(0, 10, 10,                  Width, Height, text_v,                      #__flag_Vertical|#__flag_Left|#__flag_Top)
      GadgeCreate(1, 10, 10+(Height+space)*1, Width, Height, text_v,                      #__flag_Vertical|#__flag_Left) 
      GadgeCreate(2, 10, 10+(Height+space)*2, Width, Height, text_v,                      #__flag_Vertical|#__flag_Left|#__flag_Bottom) 
      
      GadgeCreate(3, 10+(Width+space), 10,                  Width, Height, text_v,        #__flag_Vertical|#__flag_Top)
      GadgeCreate(4, 10+(Width+space), 10+(Height+space)*1, Width, Height, text_v,        #__flag_Vertical|#__flag_Center)                
      GadgeCreate(5, 10+(Width+space), 10+(Height+space)*2, Width, Height, text_v,        #__flag_Vertical|#__flag_Bottom) 
      
      GadgeCreate(6, 10+(Width+space)*2, 10,                   Width, Height, text_v,      #__flag_Vertical|#__flag_Right|#__flag_Top)
      GadgeCreate(7, 10+(Width+space)*2, 10+(Height+space)*1,  Width, Height, text_v,      #__flag_Vertical|#__flag_Right) 
      GadgeCreate(10, 10+(Width+space)*2, 10+(Height+space)*2, Width, Height, text_v,      #__flag_Vertical|#__flag_Right|#__flag_Bottom)
      
      
      ; vertical invert
      GadgeCreate(20, X+10, Y+10,                  Width, Height, text_v,                       #__flag_Vertical|#__flag_Invert|#__flag_Left|#__flag_Top)
      GadgeCreate(21, X+10, Y+10+(Height+space)*1, Width, Height, text_v,                       #__flag_Vertical|#__flag_Invert|#__flag_Left) 
      GadgeCreate(22, X+10, Y+10+(Height+space)*2, Width, Height, text_v,                       #__flag_Vertical|#__flag_Invert|#__flag_Left|#__flag_Bottom) 
      
      GadgeCreate(23, X+10+Width+space, Y+10,                  Width, Height, text_v,           #__flag_Vertical|#__flag_Invert|#__flag_Top)
      GadgeCreate(24, X+10+Width+space, Y+10+(Height+space)*1, Width, Height, text_v,           #__flag_Vertical|#__flag_Invert|#__flag_Center)                
      GadgeCreate(25, X+10+Width+space, Y+10+(Height+space)*2, Width, Height, text_v,           #__flag_Vertical|#__flag_Invert|#__flag_Bottom) 
      
      GadgeCreate(26, X+10+(Width+space)*2, Y+10,                   Width, Height, text_v,      #__flag_Vertical|#__flag_Invert|#__flag_Right|#__flag_Top)
      GadgeCreate(27, X+10+(Width+space)*2, Y+10+(Height+space)*1,  Width, Height, text_v,      #__flag_Vertical|#__flag_Invert|#__flag_Right) 
      GadgeCreate(210, X+10+(Width+space)*2, Y+10+(Height+space)*2, Width, Height, text_v,      #__flag_Vertical|#__flag_Invert|#__flag_Right|#__flag_Bottom)
      
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 46
; FirstLine = 34
; Folding = -
; EnableXP
; DPIAware