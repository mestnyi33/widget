IncludePath "../../../"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   XIncludeFile "include/os/win/id.pbi"
   XIncludeFile "include/os/win/ClipGadgets.pbi"
CompilerEndIf
XIncludeFile "widgets.pbi"

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
   
   Procedure TabViewType( *this._s_widget, position.i, size.i = #PB_Default )
      ; reset position
      *this\fs[1] = 0
      *this\fs[2] = 0
      *this\fs[3] = 0
      *this\fs[4] = 0
      
      If position = 4
         *this\TabBox( )\hide = 1
      Else
         *this\TabBox( )\hide = 0
      EndIf
      
      If position = 1
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[1] = *this\ToolBarHeight + 2 ; #__panel_width
         Else
            *this\fs[1] = size
         EndIf
      EndIf
      
      If position = 3
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[3] = *this\ToolBarHeight + 2 ; #__panel_width
         Else
            *this\fs[3] = size
         EndIf
      EndIf
      
      If position = 0
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[2] = *this\ToolBarHeight + 2 ; #__panel_height
         Else
            *this\fs[2] = size
         EndIf
      EndIf
      
      If position = 2
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[4] = *this\ToolBarHeight + 2 ; #__panel_height
         Else
            *this\fs[4] = size
         EndIf
      EndIf
      
      If Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         PostEventRepaint( *this\root )
      EndIf
   EndProcedure
   
   ;   Procedure events_widget( )
   ;     
   ;     Select GetText( EventWidget( ) )
   ;       Case "Top"
   ;         TabViewType( *panel, 2 )
   ;       Case "Left"
   ;         TabViewType( *panel, 1 )
   ;       Case "Right"
   ;         TabViewType( *panel, 3 )
   ;       Case "Bottom"
   ;         TabViewType( *panel, 4 )
   ;       Case "Hide"
   ;         TabViewType( *panel, 0 )
   ;     EndSelect
   ;     
   ;   EndProcedure
   
   Procedure GadgetTabViewType( gadget, position.i )
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         CocoaMessage(0, GadgetID(gadget), "setTabViewType:", position)
      CompilerEndIf
   EndProcedure
   
   Procedure events_gadget( )
      
      Select GetGadgetText( EventGadget( ) )
         Case "Top"
            GadgetTabViewType( 0, 0 )
            TabViewType( *panel, 0 )
         Case "Left"
            GadgetTabViewType( 0, 1 )
            TabViewType( *panel, 1 )
         Case "Right"
            GadgetTabViewType( 0, 3 )
            TabViewType( *panel, 3 )
         Case "Bottom"
            GadgetTabViewType( 0, 2 )
            TabViewType( *panel, 2 )
         Case "Hide"
            GadgetTabViewType( 0, 4 )
            TabViewType( *panel, 4 )
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
   
   BindGadgetEvent(2, @events_gadget( ), #PB_EventType_LeftClick )
   BindGadgetEvent(3, @events_gadget( ), #PB_EventType_LeftClick )
   BindGadgetEvent(4, @events_gadget( ), #PB_EventType_LeftClick )
   BindGadgetEvent(5, @events_gadget( ), #PB_EventType_LeftClick )
   BindGadgetEvent(13, @events_gadget( ), #PB_EventType_LeftClick )
   
   
   ; *panel = Panel(300+10, 10, 300 - 20, 180)
   *panel = Container(300+10, 10, 300 - 20, 180)
   ToolBar( widget( ));, #PB_ToolBar_Small )
   ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
   ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
   ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"))
   CloseList() ; *panel
   
   ;   Frame(300+30, 200, 300 - 60, 100, "Tab location")
   ;   *option = Option(300+130, GadgetY(1) + 20, 80, 20, "Top")
   ;   Option(300+50, GadgetY(1) + 45, 80, 20, "Left")
   ;   Option(300+130, GadgetY(1) + 45, 80, 20, "Hide")
   ;   Option(300+130, GadgetY(1) + 70, 80, 20, "Bottom")
   ;   Option(300+210, GadgetY(1) + 45, 80, 20, "Right")
   ;   SetState(*option, #True)
   ;   Bind( #PB_All, @events_widget( ), #PB_EventType_Change )
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets( UseGadgetList(0) )
   CompilerEndIf
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
            Break
            
      EndSelect
   ForEver
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 151
; FirstLine = 144
; Folding = ----
; EnableXP