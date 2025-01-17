IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
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
   
   Global Image = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   If Not Image
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(Image, DesktopScaledX(ImageWidth(Image)),DesktopScaledY(ImageHeight(Image)))
   EndIf
   
   
   Global *this._s_widget,
          Tree,
          gadget,
          Button_type,
          button_default,
          button_multiline,
          button_left,
          button_right,
          button_toggle,
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
   
   Procedure Flag_(*this._s_WIDGET, flag.q, state.b=0 )
   EndProcedure
   
   Procedure events_widgets()
      Protected flag.q, EventWidget = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_LeftClick
            Select EventWidget
               Case *this
                  If Flag_(*this, #__flag_ButtonToggle)
                     SetState(button_toggle, GetState(EventWidget))
                  EndIf
                  
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
               Case button_default   : flag = #__Flag_ButtonDefault
               ;Case button_multiline : flag = #__flag_ImageMultiline
                  ;
               Case button_top,
                    button_left,
                    button_right,
                    button_bottom,
                    button_center
                  
                  
                  Flag_(*this, #__flag_ImageLeft|#__flag_ImageRight|#__flag_ImageTop|#__flag_ImageBottom, 0)
                  ;
                  If EventWidget <> button_top And EventWidget <> button_left And EventWidget <> button_right
                     SetState(button_top,0) 
                  EndIf
                  If EventWidget <> button_left And EventWidget <> button_top And EventWidget <> button_bottom 
                     SetState(button_left,0) 
                  EndIf
                  If EventWidget <> button_right And EventWidget <> button_top And EventWidget <> button_bottom  
                     SetState(button_right,0) 
                  EndIf
                  If EventWidget <> button_bottom And EventWidget <> button_left And EventWidget <> button_right 
                     SetState(button_bottom,0) 
                  EndIf
                  If EventWidget <> button_center 
                     Flag_(*this, #__flag_ImageCenter, 0)
                     SetState(button_center,0) 
                  EndIf
                  
                  If GetState(button_left) And GetState(button_bottom)
                     Flag_(*this, #__flag_ImageLeft|#__flag_ImageBottom, 1)
                  ElseIf GetState(button_right) And GetState(button_bottom)
                     Flag_(*this, #__flag_ImageRight|#__flag_ImageBottom, 1)
                  ElseIf GetState(button_left) And GetState(button_top)
                     Flag_(*this, #__flag_ImageLeft|#__flag_ImageTop, 1)
                  ElseIf GetState(button_right) And GetState(button_top)
                     Flag_(*this, #__flag_ImageRight|#__flag_ImageTop, 1)
                  ElseIf GetState(button_left)
                     Flag_(*this, #__flag_ImageLeft, 1)
                  ElseIf GetState(button_right) 
                     Flag_(*this, #__flag_ImageRight, 1)
                  ElseIf GetState(button_bottom)
                     Flag_(*this, #__flag_ImageBottom, 1)
                  ElseIf GetState(button_top)
                     Flag_(*this, #__flag_ImageTop, 1)
                  EndIf
                  
                  If GetState(button_left)=0 And 
                     GetState(button_top)=0 And 
                     GetState(button_right)=0 And
                     GetState(button_bottom)=0
                     SetState(button_center,1) 
                     Flag_(*this, #__flag_ImageCenter, 1)
                  EndIf
                  
                  ;
                  Select EventWidget
                     Case button_top       : flag = #__flag_ImageTop     
                     Case button_left      : flag = #__flag_ImageLeft
                     Case button_right     : flag = #__flag_ImageRight
                     Case button_bottom    : flag = #__flag_ImageBottom
                     Case button_center    : flag = #__flag_ImageCenter
                  EndSelect
                  ;
               Case button_toggle    : flag = #__flag_ButtonToggle
               ;Case button_invert    : flag = #__flag_Imageinvert
               ;Case button_vertical  : flag = #__flag_Imagevertical
               Case button_mirror    ;: flag = #__flag_ImageMirror
                  Debug "ЕЩЕ НЕ РЕАЛИЗОВАНО"
            EndSelect
            
            If flag
               Flag_(*this, flag, GetState(EventWidget))
            EndIf
            
         Case #__event_Change
            ;         If EventWidget <> tree
            ;           SetState(tree, - 1)
            ;         EndIf
            ;         
            ;         Select EventWidget
            ;           Case button_default   
            ;           Case button_multiline 
            ;           Case button_top   
            ;             SetState(tree, #tree_item_top)
            ;           Case button_left      
            ;             SetState(tree, #tree_item_left)
            ;           Case button_right     
            ;             SetState(tree, #tree_item_right)
            ;           Case button_bottom    
            ;             SetState(tree, #tree_item_bottom)
            ;           Case button_center   
            ;             SetState(tree, #tree_item_center)
            ;           Case button_toggle    
            ;           Case button_invert    
            ;           Case button_vertical  
            ;         EndSelect
            
      EndSelect
      
   EndProcedure
   
   
   
   If Open(0, 0, 0, Width + 180, Height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      gadget = ButtonImageGadget(#PB_Any, 100, 100, 250, 200, ImageID(Image)) : HideGadget(gadget, 1)
      ;*this  = widget::ButtonImage(100, 100, 250, 200, Image);|)
      *this  = widget::Image(100, 100, 250, 200, Image);|)
      
      Define Y  = 10
      Define bh = 24
      Define p = bh+5
      ; flag
      Button_type      = widget::Button(Width + 45, Y, 100, p, "gadget", #__flag_ButtonToggle)
      button_default   = widget::Button(Width + 45, Y + p * 1, 100, bh, "default", #__flag_ButtonToggle)
      ;button_multiline = widget::Button(Width + 45, Y + p * 2, 100, bh, "multiline", #__flag_ButtonToggle)
      button_top       = widget::Button(Width + 45, Y + p * 3, 100, bh, "top", #__flag_ButtonToggle)
      button_left      = widget::Button(Width + 45, Y + p * 4, 100, bh, "left", #__flag_ButtonToggle)
      button_center    = widget::Button(Width + 45, Y + p * 5, 100, bh, "center", #__flag_ButtonToggle)
      button_right     = widget::Button(Width + 45, Y + p * 6, 100, bh, "right", #__flag_ButtonToggle)
      button_bottom    = widget::Button(Width + 45, Y + p * 7, 100, bh, "bottom", #__flag_ButtonToggle)
      button_toggle    = widget::Button(Width + 45, Y + p * 8, 100, bh, "toggle", #__flag_ButtonToggle)
      button_vertical  = widget::Button(Width + 45, Y + p * 9, 100, bh, "vertical", #__flag_ButtonToggle)
      button_invert    = widget::Button(Width + 45, Y + p * 10, 100, bh, "invert", #__flag_ButtonToggle)
      button_mirror    = widget::Button(Width + 45, Y + p * 11, 100, bh, "mirror", #__flag_ButtonToggle)
      
      ;     ; flag
      ;     tree = widget::Tree(width + 20, y + bh * 11 + 10, 150, height - (y + bh * 11), #__Tree_NoLines | #__Tree_NoButtons | #__flag_optionboxes | #__tree_CheckBoxes | #__Tree_threestate)
      ;     AddItem(tree, #tree_item_default, "default")
      ;     AddItem(tree, #tree_item_multiline, "multiline")
      ;     AddItem(tree, #tree_item_text, "text alignment", -1, 0)
      ;     AddItem(tree, #tree_item_top, "top", -1, 1)
      ;     AddItem(tree, #tree_item_left, "left", -1, 1)
      ;     AddItem(tree, #tree_item_center, "center", -1, 1)
      ;     AddItem(tree, #tree_item_right, "right", -1, 1)
      ;     AddItem(tree, #tree_item_bottom, "bottom", -1, 1)
      ;     AddItem(tree, #tree_item_toggle, "toggle")
      ;     AddItem(tree, #tree_item_vertical, "vertical")
      ;     AddItem(tree, #tree_item_invert, "invert")
      
      Bind(#PB_All, @events_widgets())
      ;Flag_(*this, #__flag_ImageMultiline)
      ;Debug _Flag_(*this, #__flag_ImageMultiline)
      ;\\ set button toggled state
      ;SetState(button_multiline, Flag_(*this, #__flag_ImageMultiline ))
      SetState(button_center, Flag_(*this, #__flag_ImageCenter))
      Hide(Button_type, 1)
      
      ;\\
      Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
      Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
      Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
      Splitter_3 = widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
      
      
      ;     ;ReDraw(root())
      ;     ;  Flag_(*this, #__flag_ImageTop|#__flag_Imageleft, 1)
      ;     
      
      ;     ;\\
      ;     SetState(Splitter_0, pos)
      ;     SetState(Splitter_1, pos)
      ;     SetState(Splitter_3, Width - pos - #__bar_splitter_size)
      ;     SetState(Splitter_2, Height - pos - #__bar_splitter_size)
      ;     
      ; ;     ReDraw(root())
      ; ;     
      ; ;     Debug ""+*this\scroll_x( )+" "+*this\scroll_width( )
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 35
; Folding = ----
; Optimizer
; EnableXP
; DPIAware