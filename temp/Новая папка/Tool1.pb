
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure GadgetsClipCallBack( GadgetID, lParam )
    If GadgetID
      Protected Gadget = GetProp_( GadgetID, "PB_ID" )
      If IsGadget( Gadget ) And GadgetID = GadgetID( Gadget )
        Debug "Gadget "+ Gadget +"  -  "+ GadgetID
      Else
        Debug "- Gadget   -  "+ GadgetID
      EndIf
      
      If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
        If IsGadget( Gadget ) 
          Select GadgetType( Gadget )
            Case #PB_GadgetType_ComboBox
              Protected Height = GadgetHeight( Gadget )
              
            ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
            Case #PB_GadgetType_Container 
              SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
              
            ; Для панел гаджета темный фон убирать
            Case #PB_GadgetType_Panel 
              If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
              EndIf
              ; SetClassLongPtr_(GadgetID, #GCL_HBRBACKGROUND, GetStockObject_(#NULL_BRUSH))

          EndSelect
        EndIf
        
        SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
        
        If Height
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
        EndIf
        
        SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      EndIf
      
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
CompilerEndIf


Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
  CompilerEndIf
EndProcedure
Procedure _ClipGadgets( ParentID ) 
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Static II
        Protected WindowID = UseGadgetList(0)
        If ParentID
          Protected GadgetID
          Protected Dim EnumerateList.I(0)
          Protected Gadget = GetProp_( ParentID, "PB_ID" )
          
          
          If (GetWindowLongPtr_(ParentID, #GWL_STYLE) & #WS_CLIPCHILDREN) = #False
            SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) | #WS_CLIPCHILDREN)
            SetWindowLongPtr_(ParentID, #GWL_EXSTYLE, GetWindowLongPtr_(ParentID, #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
          EndIf
          
          If SendMessage_( ParentID, #TCM_GETITEMCOUNT, 0, 0)
            Protected I : For I = 0 To II : GadgetID = FindWindowEx_( ParentID, GadgetID, 0,0) 
              If (GetWindowLongPtr_(GadgetID, #GWL_STYLE) & #WS_CLIPCHILDREN) = #False
                SetWindowLongPtr_(GadgetID, #GWL_STYLE, GetWindowLongPtr_(GadgetID, #GWL_STYLE) | #WS_CLIPCHILDREN)
              EndIf
              If (GetWindowLongPtr_(ParentID, #GWL_STYLE) & #WS_CLIPCHILDREN) And 
                 (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                ;SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
              EndIf
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            Next
            
            GadgetID = FindWindowEx_( GadgetID, 0,0,0 )
          Else
            If ( IsGadget( Gadget ) And GadgetID( Gadget ) = ParentID )
              Debug "ParentID Gadget "+Str(GetProp_( ParentID, "PB_ID" ))
              
              If FindWindowEx_( FindWindowEx_( ParentID, 0,0,0 ), 0,0,0 ) ; ScrollArea
                ParentID = FindWindowEx_( ParentID, 0,0,0 )
              EndIf
              ;ParentID = SendMessage_(ParentID, #LVM_GETHEADER, 0, 0)
              
              If (GetWindowLongPtr_(ParentID, #GWL_STYLE) & #WS_CLIPCHILDREN) = #False
                SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) | #WS_CLIPCHILDREN)
              EndIf
              
              GadgetID = FindWindowEx_( ParentID, 0,0,0 )
            Else
              Debug "ParentID Window "+Str(GetProp_( ParentID, "PB_WindowID" ) - 1)
              
              SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) &~ #WS_CLIPCHILDREN)
              ;SetWindowLongPtr_(ParentID, #GWL_EXSTYLE, GetWindowLongPtr_(ParentID, #GWL_EXSTYLE) &~ #WS_EX_COMPOSITED)
              
              GadgetID = FindWindowEx_( ParentID, 0,0,0 );ParentID 
            EndIf
          EndIf
          
          
          While GadgetID
            If GadgetID
              Gadget = GetProp_( GadgetID, "PB_ID" )
              If ( IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID )
                If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
                  Protected Height = GadgetHeight( Gadget ) 
                  SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
                  ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
                EndIf
                
                If (GetWindowLongPtr_(GetParent_(GadgetID), #GWL_STYLE) & #WS_CLIPCHILDREN)
                  Select GadgetType(Gadget)
                    Case #PB_GadgetType_Frame, #PB_GadgetType_Image
                      If (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                        ;SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                      EndIf
                  EndSelect
                EndIf
              EndIf
              
              ReDim EnumerateList( ArraySize( EnumerateList() ) + (1) ) : EnumerateList( ArraySize( EnumerateList() ) ) = GadgetID
            EndIf
            GadgetID = GetWindow_( GadgetID, #GW_HWNDNEXT )  
          Wend
          
          While ArraySize( EnumerateList() ) 
            If ArraySize( EnumerateList() )
              GadgetID = EnumerateList( ArraySize( EnumerateList() ) ) : ReDim EnumerateList( ArraySize( EnumerateList() ) - (1) )
              SetWindowPos_( GadgetID, #GW_HWNDLAST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
            EndIf 
          Wend
          
          If SendMessage_( ParentID, #TCM_GETITEMCOUNT, 0, 0) : II + (1)
            If (SendMessage_( ParentID, #TCM_GETITEMCOUNT, 0, 0) = II) 
              II = 0
            Else
              _ClipGadgets( ParentID ) 
            EndIf
          EndIf
          
          FreeArray( EnumerateList() )
          ;         Else
          ;           If (GetWindowLongPtr_( WindowID, #GWL_EXSTYLE) & #WS_EX_COMPOSITED ) = #False
          ;             SmartWindowRefresh(( GetProp_( WindowID, "PB_WindowID" ) - 1), #False)
          ;             SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE) | #WS_CLIPCHILDREN)
          ;             SetWindowLongPtr_( WindowID, #GWL_EXSTYLE, GetWindowLongPtr_( WindowID, #GWL_EXSTYLE ) | #WS_EX_COMPOSITED )
          ;           EndIf
          ;           
        EndIf
      CompilerEndIf
    EndProcedure
    
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
            SetGadgetColor(#Tool_Grid_Size_Info, #PB_Gadget_FrontColor, 0)
            DisableGadget(#Tool_Grid_Container,0)
            
            DisableGadget(#Tool_Line_Show,1)
            DisableGadget(#Tool_Line_Snap,1)
            DisableGadget(#Tool_Line_Size,1)
            DisableGadget(#Tool_Line_Frame,1)
            SetGadgetColor(#Tool_Line_Size_Info, #PB_Gadget_FrontColor, $757B7B)
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
            SetGadgetColor(#Tool_Grid_Size_Info, #PB_Gadget_FrontColor, $757B7B)
            DisableGadget(#Tool_Grid_Container,1)
            
            DisableGadget(#Tool_Line_Show,0)
            DisableGadget(#Tool_Line_Snap,0)
            DisableGadget(#Tool_Line_Size,0)
            DisableGadget(#Tool_Line_Frame,0)
            SetGadgetColor(#Tool_Line_Size_Info, #PB_Gadget_FrontColor, 0)
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
      SetGadgetFont(FrameGadget(#PB_Any, 0, 0, 333, 170, "Параметры выравнивания"),FontID(Font))
    EndIf
    
    ContainerGadget(-1, 3, 35, 327, 132)
      FrameGadget(#Tool_Alignment_Mode, 5, 4, 317, 124, "Режим выравнивания")
      
    ContainerGadget(#Tool_Grid_Container, 10, 25, 152, 101)
      FrameGadget(#Tool_Grid_Frame, 1, 4, 150, 93, "")
      CheckBoxGadget(#Tool_Grid_Show, 6, 24, 126, 16, "Показать сетку")
      CheckBoxGadget(#Tool_Grid_Snap, 6, 44, 136, 16, "Привязать к сетке")
      TextGadget(#Tool_Grid_Size_Info, 21, 72, 76, 16, "Размер сетки:")
      SpinGadget(#Tool_Grid_Size, 101, 69, 46, 23,0,20,#PB_Spin_Numeric)
    CloseGadgetList()
    ContainerGadget(#Tool_Line_Container, 165, 25, 152, 101)
      FrameGadget(#Tool_Line_Frame, 1, 4, 150, 93, "")
      CheckBoxGadget(#Tool_Line_Show, 6, 24, 126, 16, "Показать линию")
      CheckBoxGadget(#Tool_Line_Snap, 6, 44, 136, 16, "Привязать к линии")
      TextGadget(#Tool_Line_Size_Info, 21, 72, 76, 16, "Размер линии:")
      SpinGadget(#Tool_Line_Size, 101, 69, 46, 23,0,20,#PB_Spin_Numeric)
    CloseGadgetList()
    
    OptionGadget(#Tool_Align_To_Grid, GadgetX(#Tool_Grid_Container)+6, GadgetY(#Tool_Grid_Container)+2, 121, 16, "Выровнять по сетке")
    OptionGadget(#Tool_Align_To_Line, GadgetX(#Tool_Line_Container)+6, GadgetY(#Tool_Line_Container)+2, 121, 16, "Выровнять по линии")
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
  DisableGadget(#Tool_Line_Container,1)
  SetGadgetColor(#Tool_Align_To_Line, #PB_Gadget_FrontColor, $757B7B)
  
  
  SetGadgetColor(#Tool_Grid_Size_Info, #PB_Gadget_FrontColor, $757B7B)
  SetGadgetColor(#Tool_Line_Size_Info, #PB_Gadget_FrontColor, $757B7B)
  
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
     ClipGadgets( WindowID(Window) )
     
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
