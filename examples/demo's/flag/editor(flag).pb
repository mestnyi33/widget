IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Enumeration 
      #tree_item_default
      #tree_item_multiline
      #tree_item_text
      #tree_item_top
      #tree_item_left
      #tree_item_center
      #tree_item_right
      #tree_item_bottom
      #tree_item_toggle
      #tree_item_vertical
      #tree_item_invert
   EndEnumeration
   
   Procedure.s get_text(m.s = #LF$)
      Protected Text.s = "This is a long line." + m.s +
                         "Who should show." + m.s +
                         m.s + ;                        m.s + ;                        m.s +
                         "I have to write the text in the box or not." + m.s +
                         m.s + ;                        m.s + ;                        m.s +
                         "The string must be very long." + m.s +
                         "Otherwise it will not work." ;+ m.s; +
      
      ProcedureReturn Text
   EndProcedure
   
   Define cr.s = #LF$, Text.s
   Text = get_text( )
   Text = "V & H" + cr + " multiline" + cr + "text"
   ;Text = "text ";
   
   Global *b16, *b32, *b0
   Global *this._s_widget,
          Tree,
          gadget,
          Button_type,
          button_default,
          button_multiline,
          button_left,
          button_right,
          Button_wordwrap,
          button_top,
          button_bottom,
          button_center,
          button_vertical,
          button_invert,
          button_mirror,
          Splitter_0,
          Splitter_1,
          Splitter_2,
          Splitter_3,
          Splitter_4
   
   Define Width = 560, Height = 560, pos = 60
   
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
            SetImage( *this, 16)
         Case *b32
            SetImage( *this, 32)
         Case *b0
            SetImage( *this, 0)
      EndSelect
   EndProcedure
   
   Procedure all_events()
      Protected EventWidget = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_LeftClick
            Select EventWidget
               Case Button_type
                  If GetState(EventWidget)
                     Hide(*this, 1)
                     HideGadget(gadget, 0)
                     If Splitter_0
                        SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
                     EndIf
                     SetText(Button_type, "widget")
                  Else
                     Hide(*this, 0)
                     HideGadget(gadget, 1)
                     If Splitter_0
                        SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
                     EndIf
                     SetText(Button_type, "gadget")
                  EndIf
                  
                  ;
               Case button_top,
                    button_left,
                    button_right,
                    button_bottom,
                    button_center
                  
                  
                  ; reset state
                  If EventWidget = button_top Or EventWidget = button_center
                     SetState(button_bottom,0) 
                  EndIf
                  If EventWidget = button_bottom Or EventWidget = button_center
                     SetState(button_top,0) 
                  EndIf
                  If EventWidget = button_left Or EventWidget = button_center
                     SetState(button_right,0) 
                  EndIf
                  If EventWidget = button_right Or EventWidget = button_center
                     SetState(button_left,0) 
                  EndIf
                  If EventWidget = button_top Or
                     EventWidget = button_bottom Or 
                     EventWidget = button_left Or 
                     EventWidget = button_right 
                     ;
                     SetState(button_center,0) 
                  EndIf
                  
                  ;
                  If GetState(button_left)
                     SetFlag(*this, #__flag_Left)
                  Else
                     RemoveFlag(*this, #__flag_Left)
                  EndIf
                  If GetState(button_right) 
                     SetFlag(*this, #__flag_Right)
                  Else
                     RemoveFlag(*this, #__flag_Right)
                  EndIf
                  If GetState(button_bottom)
                     SetFlag(*this, #__flag_Bottom)
                  Else
                     RemoveFlag(*this, #__flag_Bottom)
                  EndIf
                  If GetState(button_top)
                     SetFlag(*this, #__flag_Top)
                  Else
                     RemoveFlag(*this, #__flag_Top)
                  EndIf
                  
                  ;
                  If (GetState(button_left)=0 And 
                      GetState(button_top)=0 And
                      GetState(button_right)=0 And 
                      GetState(button_bottom)=0) 
                     
                     ;
                     If SetState(button_center,1) 
                     EndIf
                     SetFlag(*this, #__flag_Center)
                  EndIf
                  
                  
               Case button_multiline 
                  If GetState(EventWidget)
                     SetState(Button_wordwrap,0) 
                     SetFlag(*this, #__flag_TextMultiline)
                  Else
                     RemoveFlag(*this, #__flag_TextMultiline)
                  EndIf
                  
               Case Button_wordwrap 
                  If GetState(EventWidget)
                     SetState(button_multiline,0) 
                     SetFlag(*this, #__flag_TextWordWrap)
                  Else
                     RemoveFlag(*this, #__flag_TextWordWrap)
                  EndIf
                  
               Case button_invert    
                  If GetState(EventWidget)
                     SetFlag(*this, #__flag_Invert)
                  Else
                     RemoveFlag(*this, #__flag_Invert)
                  EndIf
                  
               Case button_vertical  
                  If GetState(EventWidget)
                     SetFlag(*this, #__flag_Vertical)
                  Else
                     RemoveFlag(*this, #__flag_Vertical)
                  EndIf
                  
               Case button_mirror    ;: flag = #__flag_TextMirror
                  Debug "ЕЩЕ НЕ РЕАЛИЗОВАНО"
            EndSelect
            
      EndSelect
      
   EndProcedure
   
   
   
   If Open(0, 0, 0, Width + 180, Height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, Text, #PB_Button_MultiLine) : HideGadget(gadget, 1)
      *this  = Widget::Editor(100, 100, 250, 200) : SetText( *this, Text )
      ;*this  = Widget::Text(100, 100, 250, 200, Text )
      
      Define Y  = 10
      Define bh = 24
      Define p = bh+5
      ;
      *b0 = Button( Width + 45, Y, 30, bh, "0")
      *b16 = Button( Width + 45 + 35, Y, 30, bh, "16")
      *b32 = Button( Width + 45 + 70, Y, 30, bh, "32")
      Bind( *b0, @change_image_events( ), #__event_LeftClick )
      Bind( *b16, @change_image_events( ), #__event_LeftClick )
      Bind( *b32, @change_image_events( ), #__event_LeftClick )
      
      
      Define Container = Container( Width + 45, Y + bh * 1+10, 100, 100, #__flag_BorderLess | #__flag_Transparent) 
      button_top       = Widget::Button(0,0,bh,bh, "v", #PB_Button_Toggle|#__flag_Invert,20)
      button_left      = Widget::Button(0,0,bh,bh, "v", #PB_Button_Toggle|#__flag_Vertical|#__flag_Invert,20)
      button_center    = Widget::Button(0,0,bh,bh, "O", #PB_Button_Toggle,20)
      button_right     = Widget::Button(0,0,bh,bh, "v", #PB_Button_Toggle|#__flag_Vertical,20)
      button_bottom    = Widget::Button(0,0,bh,bh, "v", #PB_Button_Toggle,20)
      
      SetAlign( button_left, #__align_auto, 1,0,0,0, 0)
      SetAlign( button_top, #__align_auto, 0,1,0,0, 0)
      SetAlign( button_right, #__align_auto, 0,0,1,0, 0)
      SetAlign( button_bottom, #__align_auto, 0,0,0,1, 0)
      SetAlign( button_center, #__align_center, 0,0,0,0, 0)
      
      Resize(Container, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      CloseList( )
      
      
      Button_type      = Widget::Button(Width + 45, Y, 100, p, "gadget", #PB_Button_Toggle)
      Button_wordwrap  = Widget::Button(Width + 45, Y + p * 5, 100, bh, "wordwrap", #PB_Button_Toggle)
      button_multiline = Widget::Button(Width + 45, Y + p * 6, 100, bh, "multiline", #PB_Button_Toggle)
      button_vertical  = Widget::Button(Width + 45, Y + p * 7, 100, bh, "vertical", #PB_Button_Toggle)
      button_invert    = Widget::Button(Width + 45, Y + p * 8, 100, bh, "invert", #PB_Button_Toggle)
      
      Bind(#PB_All, @all_events())
      
      
      ;\\ set button toggled state
      SetState(button_wordwrap, Flag(*this, #__flag_TextWordWrap ))
      SetState(button_vertical, Flag(*this, #__flag_Vertical ))
      SetState(button_invert, Flag(*this, #__flag_Invert ))
      SetState(button_multiline, Flag(*this, #__flag_TextMultiLine ))
      SetState(button_left, Flag(*this, #__flag_Left ))
      SetState(button_Top, Flag(*this, #__flag_Top ))
      SetState(button_Right, Flag(*this, #__flag_Right ))
      SetState(button_Bottom, Flag(*this, #__flag_Bottom ))
      SetState(button_center, Flag(*this, #__flag_TextCenter))
      Hide(Button_type, 1)
      
      ;\\
      Splitter_0 = Widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
      Splitter_1 = Widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
      Splitter_2 = Widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
      Splitter_3 = Widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
      
      
      SetState(Splitter_3, 350 )
      SetState(Splitter_2, 350 )
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 85
; FirstLine = 73
; Folding = -----
; EnableXP
; DPIAware