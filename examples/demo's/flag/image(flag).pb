﻿
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
    Protected flag
    
    Select WidgetEvent()
      Case #__event_LeftClick
        Select EventWidget()
          Case *this
            If Flag(*this, #__flag_ButtonToggle)
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
            
          Case f_0 : flag = #__flag_ButtonDefault
          Case f_1 : flag = #__flag_Textmultiline
          Case f_4 : flag = #__flag_ButtonToggle
            
          Case f_5 : flag = #__text_Top
            ;SetState(f_6, 0)
          Case f_2 : flag = #__text_left
          Case f_3 : flag = #__text_Right
          Case f_6 : flag = #__text_Bottom
            
          Case f_7 : flag = #__text_Invert
          Case f_8 : flag = #__text_Vertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget()))
        EndIf
        
        ; PostCanvasRepaint( *this\root )
    EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, Width+180, Height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) : HideGadget(gadget,1)
    *this = widget::Image(100, 100, 250, 250, get_image())
    
    ; flag
    f = widget::Tree(Width+20, 10, 150, Y+10, #__Tree_NoLines|#__Tree_NoButtons|#__flag_OptionBoxes|#__tree_CheckBoxes|#__Tree_threestate)
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
    
    Button_type = widget::Button(Width+20,   Y, 150, 26, "gadget", #__flag_ButtonToggle) 
    f_5 = widget::Button(Width+20, Y+30*1, 150, 26, "top", #__flag_ButtonToggle) 
    f_2 = widget::Button(Width+20, Y+30*2, 73, 26, "left", #__flag_ButtonToggle) 
    f_3 = widget::Button(Width+20 + 21 + 55, Y+30*2, 73, 26, "right", #__flag_ButtonToggle) 
    f_6 = widget::Button(Width+20, Y+30*3, 150, 26, "bottom", #__flag_ButtonToggle) 
    
    f_0 = widget::Button(Width+20, Y+30*4, 150, 26, "center", #__flag_ButtonToggle) 
    f_1 = widget::Button(Width+20, Y+30*5, 150, 26, "strech", #__flag_ButtonToggle) 
    f_4 = widget::Button(Width+20, Y+30*6, 150, 26, "proportional", #__flag_ButtonToggle) 
    
    f_8 = widget::Button(Width+20, Y+30*7, 150, 26, "auto", #__flag_ButtonToggle) 
;     f_7 = widget::Button(width+20, y+30*8, 150, 26, "invert", #__flag_ButtonToggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(f_1, Flag(*this, #__flag_Textmultiline))
    SetState(f_5, Flag(*this, #__text_Top))
    SetState(f_2, Flag(*this, #__text_left))
    SetState(f_3, Flag(*this, #__text_Right))
    SetState(f_6, Flag(*this, #__text_Bottom))
    
    If Button_type
       Hide(Button_type, 1)
    EndIf

    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    Define pos = 80
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, Width-pos-#__bar_splitter_size)
    SetState(Splitter_2, Height-pos-#__bar_splitter_size)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 128
; FirstLine = 105
; Folding = ---
; Optimizer
; EnableXP
; DPIAware