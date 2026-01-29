
IncludePath "../../../"
XIncludeFile "widgets.pbi"
; ;XIncludeFile "../empty.pb"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type
  Global f, f_0, f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8
  Global Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Define Y = 205, vert=100, horiz=100, Width=460, Height=460
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  If Not LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If DesktopResolutionX() > 1
    ResizeImage(0, DesktopScaledX(ImageWidth(0)),DesktopScaledY(ImageHeight(0)))
    ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
    ResizeImage(2, DesktopScaledX(ImageWidth(2)),DesktopScaledY(ImageHeight(2)))
  EndIf
  
  Procedure.i get_image(m.s=#LF$)
  ProcedureReturn 2
  EndProcedure
  
  Procedure events_widgets()
    Protected Flag
    
    Select WidgetEvent()
      Case #__event_LeftClick
        Select EventWidget()
          Case *this
            If Flag(*this, #PB_Button_Toggle)
              SetState(f_4, GetState(EventWidget()))
            EndIf
            
          Case Button_type 
            If GetState(EventWidget())
              Hide(*this, 1)
              HideGadget(gadget, 0)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
              EndIf
              SetText(EventWidget(), "widget")
            Else
              Hide(*this, 0)
              HideGadget(gadget, 1)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
              EndIf
              SetText(EventWidget(), "gadget")
            EndIf
            
          Case f_0 : Flag = #__flag_button_Default
          Case f_1 : Flag = #__flag_Textmultiline
          Case f_4 : Flag = #PB_Button_Toggle
            
          Case f_5 : Flag = #__flag_Top
            ;SetState(f_6, 0)
          Case f_2 : Flag = #__flag_left
          Case f_3 : Flag = #__flag_Right
          Case f_6 : Flag = #__flag_Bottom
            
          Case f_7 : Flag = #__flag_Invert
          Case f_8 : Flag = #__flag_Vertical
        EndSelect
        
        If Flag
          Flag(*this, Flag, GetState(EventWidget()))
        EndIf
        
        ; PostCanvasRepaint( *this\root )
    EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, Width+180, Height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) : HideGadget(gadget,1)
    *this = Widget::Image(100, 100, 250, 250, get_image())
    
    ; flag
    f = Widget::Tree(Width+20, 10, 150, Y+10, #__flag_NoLines|#__flag_NoButtons|#__flag_OptionBoxes|#__flag_CheckBoxes|#__flag_threestate)
    ; AddItem(f, -1, "align", -1,0)
    AddItem(f, -1, "top", -1,1)
    AddItem(f, -1, "left", -1,1)
    AddItem(f, -1, "center", -1,1)
    AddItem(f, -1, "right", -1,1)
    AddItem(f, -1, "bottom", -1,1)
    AddItem(f, -1, "default")
    AddItem(f, -1, "multiline")
    AddItem(f, -1, "toggle")
    AddItem(f, -1, "vertical")
    AddItem(f, -1, "invert")
    
    Button_type = Widget::Button(Width+20,   Y, 150, 26, "gadget", #PB_Button_Toggle) 
    f_5 = Widget::Button(Width+20, Y+30*1, 150, 26, "top", #PB_Button_Toggle) 
    f_2 = Widget::Button(Width+20, Y+30*2, 73, 26, "left", #PB_Button_Toggle) 
    f_3 = Widget::Button(Width+20 + 21 + 55, Y+30*2, 73, 26, "right", #PB_Button_Toggle) 
    f_6 = Widget::Button(Width+20, Y+30*3, 150, 26, "bottom", #PB_Button_Toggle) 
    
    f_0 = Widget::Button(Width+20, Y+30*4, 150, 26, "center", #PB_Button_Toggle) 
    f_1 = Widget::Button(Width+20, Y+30*5, 150, 26, "strech", #PB_Button_Toggle) 
    f_4 = Widget::Button(Width+20, Y+30*6, 150, 26, "proportional", #PB_Button_Toggle) 
    
    f_8 = Widget::Button(Width+20, Y+30*7, 150, 26, "auto", #PB_Button_Toggle) 
;     f_7 = widget::Button(width+20, y+30*8, 150, 26, "invert", #PB_Button_Toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(f_1, Flag(*this, #__flag_Textmultiline))
    SetState(f_5, Flag(*this, #__flag_Top))
    SetState(f_2, Flag(*this, #__flag_left))
    SetState(f_3, Flag(*this, #__flag_Right))
    SetState(f_6, Flag(*this, #__flag_Bottom))
    
    If Button_type
       Hide(Button_type, 1)
    EndIf

    Splitter_0 = Widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = Widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = Widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = Widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    Define pos = 80
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, Width-pos-#__bar_splitter_size)
    SetState(Splitter_2, Height-pos-#__bar_splitter_size)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 76
; FirstLine = 41
; Folding = ---
; EnableXP
; DPIAware