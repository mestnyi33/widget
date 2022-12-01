IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  #BorderNone = 0
  #BorderLine = 1
  #BorderBezel = 2
  
  #TopTabsBezelBorder    = 0
  #LeftTabsBezelBorder   = 1
  #BottomTabsBezelBorder = 2
  #RightTabsBezelBorder  = 3
  
  #noTabsBezelBorder = 4
  #noTabsLineBorder = 5
  #noTabsNoBorder = 6
  
  Global *panel, *option
  Global SelectedGadget
  
  Procedure TabViewType( *this._s_widget, position.i )
    *this\fs[1] = 0
    *this\fs[2] = 0
    *this\fs[3] = 0
    *this\fs[4] = 0
    
    If position = 0
      *this\TabWidget( )\hide = 1
    Else
      *this\TabWidget( )\hide = 0
    EndIf
    
    If position = 1
      *this\TabWidget( )\bar\vertical = 1
      *this\fs[1] = #__panel_width
    EndIf
    
    If position = 3
      *this\TabWidget( )\bar\vertical = 1
      *this\fs[3] = #__panel_width
    EndIf
    
    If position = 2
      *this\TabWidget( )\bar\vertical = 0
      *this\fs[2] = #__panel_height
    EndIf
    
    If position = 4
      *this\TabWidget( )\bar\vertical = 0
      *this\fs[4] = #__panel_height
    EndIf
    
    Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  EndProcedure
  
  Procedure events_widget( )
    
    Select GetText( EventWidget( ) )
      Case "Top"
        TabViewType( *panel, 2 )
      Case "Left"
        TabViewType( *panel, 1 )
      Case "Right"
        TabViewType( *panel, 3 )
      Case "Bottom"
        TabViewType( *panel, 4 )
      Case "Hide"
        TabViewType( *panel, 0 )
    EndSelect
    
  EndProcedure
  
  Open(0, 270, 100, 600, 310, "Change tab location")
  
  PanelGadget(0, 10, 10, 300 - 20, 180)
  AddGadgetItem (0, -1, "Tab 1")
  AddGadgetItem (0, -1, "Tab 2")
  CloseGadgetList()
  
  FrameGadget(1, 30, 200, 300 - 60, 100, "Tab location")
  OptionGadget(2, 130, GadgetY(1) + 20, 80, 20, "Top")
  OptionGadget(3, 50, GadgetY(1) + 45, 80, 20, "Left")
  OptionGadget(13, 130, GadgetY(1) + 45, 80, 20, "Hide")
  OptionGadget(4, 130, GadgetY(1) + 70, 80, 20, "Bottom")
  OptionGadget(5, 210, GadgetY(1) + 45, 80, 20, "Right")
  SetGadgetState(2, #True)
  
  
  *panel = Panel(300+10, 10, 300 - 20, 180)
  AddItem (*panel, -1, "Tab 1")
  AddItem (*panel, -1, "Tab 2")
  CloseList() ; *panel
  
  Frame(300+30, 200, 300 - 60, 100, "Tab location")
  *option = Option(300+130, GadgetY(1) + 20, 80, 20, "Top")
  Option(300+50, GadgetY(1) + 45, 80, 20, "Left")
  Option(300+130, GadgetY(1) + 45, 80, 20, "Hide")
  Option(300+130, GadgetY(1) + 70, 80, 20, "Bottom")
  Option(300+210, GadgetY(1) + 45, 80, 20, "Right")
  SetState(*option, #True)
  Bind( #PB_All, @events_widget( ), #PB_EventType_Change )
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        SelectedGadget = EventGadget()
        
        If SelectedGadget = 13
          ; SetGadgetAttribute(0, #PB_Panel_TabHeight, 0 )
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            
            CocoaMessage(0, GadgetID(0), "setTabViewType:", 4)
           ; CocoaMessage(0, GadgetID(0), "setTabViewBorderType:", 1)
          CompilerEndIf
        EndIf
        If SelectedGadget >= 2 And SelectedGadget <= 5
          ; SetGadgetAttribute(0, #PB_Panel_TabHeight, 30 )
         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            CocoaMessage(0, GadgetID(0), "setTabViewType:", SelectedGadget - 2)
          CompilerEndIf
        EndIf
    EndSelect
  ForEver
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 0--
; EnableXP