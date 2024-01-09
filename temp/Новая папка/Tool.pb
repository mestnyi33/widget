EnableExplicit

Enumeration Window ;- Window
  #Tool
EndEnumeration

Enumeration Gadget ;- Gadget
  #Tool_Container_Mode
  #Tool_Alignment_Mode
  #Tool_Align_To_Grid
  #Tool_Align_To_Line
  #Tool_Grid_Container
  #Tool_Grid_Frame
  #Tool_Grid_Show
  #Tool_Grid_Snap
  #Tool_Grid_Size_Info
  #Tool_Grid_Size
  #Tool_Line_Container
  #Tool_Line_Frame
  #Tool_Line_Show
  #Tool_Line_Snap
  #Tool_Line_Size_Info
  #Tool_Line_Size
EndEnumeration

Procedure Tool_Gadget_Event( )
  Static sSteps
  Select EventGadget()
    Case #Tool_Align_To_Grid
      Select EventType()
        Case #PB_EventType_LeftClick
          If GetGadgetState(EventGadget()) = #PB_Checkbox_Checked
            DisableGadget(#Tool_Grid_Show,0)
            DisableGadget(#Tool_Grid_Snap,0)
            DisableGadget(#Tool_Grid_Size,0)
            DisableGadget(#Tool_Grid_Frame,0)
            DisableGadget(#Tool_Grid_Size_Info,0)
            DisableGadget(#Tool_Grid_Container,0)
            
            DisableGadget(#Tool_Line_Show,1)
            DisableGadget(#Tool_Line_Snap,1)
            DisableGadget(#Tool_Line_Size,1)
            DisableGadget(#Tool_Line_Frame,1)
            DisableGadget(#Tool_Line_Size_Info,1)
            DisableGadget(#Tool_Line_Container,1)
          EndIf
      EndSelect
    Case #Tool_Align_To_Line
      Select EventType()
        Case #PB_EventType_LeftClick
          If GetGadgetState(EventGadget()) = #PB_Checkbox_Checked
            DisableGadget(#Tool_Grid_Show,1)
            DisableGadget(#Tool_Grid_Snap,1)
            DisableGadget(#Tool_Grid_Size,1)
            DisableGadget(#Tool_Grid_Frame,1)
            DisableGadget(#Tool_Grid_Size_Info,1)
            DisableGadget(#Tool_Grid_Container,1)
            
            DisableGadget(#Tool_Line_Show,0)
            DisableGadget(#Tool_Line_Snap,0)
            DisableGadget(#Tool_Line_Size,0)
            DisableGadget(#Tool_Line_Frame,0)
            DisableGadget(#Tool_Line_Size_Info,0)
            DisableGadget(#Tool_Line_Container,0)
          EndIf
      EndSelect
    Case #Tool_Grid_Show
      Select EventType()
        Case #PB_EventType_LeftClick
          If GetGadgetState(EventGadget()) = #PB_Checkbox_Checked

          Else
           
          EndIf
    EndSelect
  EndSelect
EndProcedure

Procedure Tool_Gadget( Window, Width, Height )
  ContainerGadget(#Tool_Container_Mode, 5, 5, Width-10, Height-10)
    Protected Font = LoadFont(#PB_Any, "Arial", 16)
    If Font
      SetGadgetFont(FrameGadget(#PB_Any, 0, 0, 331, 216, "Параметры выравнивания"),FontID(Font))
    EndIf
    
    ContainerGadget(-1, 5, 35, 322, 106)
      FrameGadget(#Tool_Alignment_Mode, 4, 4, 312, 71, "Режим выравнивания")
      OptionGadget(#Tool_Align_To_Grid, 9, 29, 191, 16, "Выровнять по сетке")
      OptionGadget(#Tool_Align_To_Line, 9, 49, 191, 16, "Выровнять по линии")
      
    CloseGadgetList()
    
    ContainerGadget(#Tool_Grid_Container, 5, 110, 161, 103)
      FrameGadget(-1, 4, 4, 151, 93, "Параметры сетки")
      TextGadget(#Tool_Grid_Frame, 12, 4, 100, 16, "Параметры сетки")
      CheckBoxGadget(#Tool_Grid_Show, 9, 24, 126, 16, "Показать сетку")
      CheckBoxGadget(#Tool_Grid_Snap, 9, 44, 136, 16, "Привязать к сетке")
      TextGadget(#Tool_Grid_Size_Info, 24, 72, 76, 16, "Размер сетки:")
      SpinGadget(#Tool_Grid_Size, 104, 69, 46, 23,0,20,#PB_Spin_Numeric)
    CloseGadgetList()
    ContainerGadget(#Tool_Line_Container, 166, 110, 161, 103)
      FrameGadget(-1, 4, 4, 151, 93, "Параметры линии")
      TextGadget(#Tool_Line_Frame, 12, 4, 100, 16, "Параметры линии")
      CheckBoxGadget(#Tool_Line_Show, 9, 24, 126, 16, "Показать линию")
      CheckBoxGadget(#Tool_Line_Snap, 9, 44, 136, 16, "Привязать к линии")
      TextGadget(#Tool_Line_Size_Info, 24, 72, 76, 16, "Размер линии:")
      SpinGadget(#Tool_Line_Size, 104, 69, 46, 23,0,20,#PB_Spin_Numeric)
    CloseGadgetList()
  CloseGadgetList()
  
;   If Point::wSteps
;     SetGadgetState( #Tool_Align_To_Grid, 1)
;     SetGadgetState( #Tool_Grid_Show, 1)
;     SetGadgetState( #Tool_Grid_Snap, 1)
;     SetGadgetState( #Tool_Grid_Size, Point::wSteps)
;   EndIf
  
  SetGadgetState( #Tool_Align_To_Grid, 1)
  DisableGadget(#Tool_Line_Show,1)
  DisableGadget(#Tool_Line_Snap,1)
  DisableGadget(#Tool_Line_Size,1)
  DisableGadget(#Tool_Line_Frame,1)
  DisableGadget(#Tool_Line_Size_Info,1)
  DisableGadget(#Tool_Line_Container,1)
  
  BindEvent(#PB_Event_Gadget, @Tool_Gadget_Event(),Window)
EndProcedure

Procedure Tool_Close_Event( )
  CloseWindow( #Tool )
EndProcedure 

Procedure Tool_Window( Flag = #PB_Window_ScreenCentered, ParentID = 0, Width = 431, Height = 276 )
 Static Window = #Tool
  If IsWindow( Window )
    If ((Flag & #PB_Window_Invisible) = #PB_Window_Invisible)
      HideWindow( Window, #True, Flag )
    Else
      If ((Flag & #PB_Window_NoActivate) = #PB_Window_NoActivate)
        CloseWindow( Window ) :Tool_Window( Flag, ParentID, Width, Height )
      Else
        HideWindow( Window, #False, Flag )
        SetActiveWindow(Window)
      EndIf
    EndIf
  Else
    OpenWindow( Window, 245, 144, Width, Height, "Tool", #PB_Window_Invisible|#PB_Window_SystemMenu, ParentID )
     Tool_Gadget( Window, Width, Height )
    
    BindEvent( #PB_Event_CloseWindow, @Tool_Close_Event(), Window )
    If ((Flag & #PB_Window_Invisible) ! #PB_Window_Invisible)
      HideWindow( Window, #False, Flag )
    EndIf
  EndIf
  ProcedureReturn Window
EndProcedure

Procedure Tool_Window_Show( ParentID = 0, Flag = #PB_Window_ScreenCentered )
 Protected Event
  If Not Flag
    If ParentID 
      Flag = #PB_Window_WindowCentered 
    Else 
      Flag = #PB_Window_ScreenCentered 
    EndIf
  EndIf
  
  Protected Window = Tool_Window( Flag, ParentID )
  
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Define Event
  Tool_Window( )
  
  While IsWindow( #Tool )
    Event = WaitWindowEvent( )
  Wend

  End
CompilerEndIf

DisableExplicit
