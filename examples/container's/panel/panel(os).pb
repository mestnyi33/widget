IncludePath "../../../"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   XIncludeFile "include/os/win/id.pbi"
   XIncludeFile "include/os/win/ClipGadgets.pbi"
CompilerEndIf
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;UsePNGImageDecoder()
   
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
   
   Macro BarPositon_( this, position, size=-1 )
      BarPosition( this, position, size )
   EndMacro
   
   ;   Procedure events_widget( )
   ;     
   ;     Select GetTextWidget( EventWidget( ) )
   ;       Case "Top"
   ;         BarPositon_( *panel, 2 )
   ;       Case "Left"
   ;         BarPositon_( *panel, 1 )
   ;       Case "Right"
   ;         BarPositon_( *panel, 3 )
   ;       Case "Bottom"
   ;         BarPositon_( *panel, 4 )
   ;       Case "Hide"
   ;         BarPositon_( *panel, 0 )
   ;     EndSelect
   ;     
   ;   EndProcedure
   
   Procedure GadgetBarPositon_( gadget, position.i )
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         If position = 2
            position = 0
         ElseIf position = 4
            position = 2
         ElseIf position = 0
            position = 4
         EndIf
         
         CocoaMessage(0, GadgetID(gadget), "setTabViewType:", position)
      CompilerEndIf
   EndProcedure
   
   Procedure events_gadget( )
      
      Select GetGadgetTextWidget( EventGadget( ) )
         Case "Top"
            GadgetBarPositon_( 0, 2 )
            BarPositon_( *panel, 2 )
         Case "Left"
            GadgetBarPositon_( 0, 1 )
            BarPositon_( *panel, 1 )
         Case "Right"
            GadgetBarPositon_( 0, 3 )
            BarPositon_( *panel, 3 )
         Case "Bottom"
            GadgetBarPositon_( 0, 4 )
            BarPositon_( *panel, 4 )
         Case "Hide"
            GadgetBarPositon_( 0, 0 )
            BarPositon_( *panel, 0 )
      EndSelect
      
   EndProcedure
   
   Procedure events_widget( )
      Select WidgetEvent( )
         Case #__event_Focus
            Debug "active - event " + EventWidget( )\class
            
         Case #__event_LostFocus
            Debug "deactive - event " + EventWidget( )\class
            
      EndSelect
   EndProcedure
   
   OpenRootWidget(0, 270, 100, 600, 310, "Change tab location")
   ;a_init(root(),0)
   SetWidgetColor(root(), #__color_back, $FFF2F2F2)
   
   PanelGadget(0, 10, 10, 300 - 20, 180)
   AddGadgetItem (0, -1, "Tab 1", LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"))
   AddGadgetItem (0, -1, "Tab 2", LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
   ButtonGadget( -1, 0,0,50,50,"Button" )
   ButtonGadget( -1, 0,180-95,50,50,"Button" )
   AddGadgetItem (0, -1, "Tab 3", LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
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
   
   
   *panel = PanelWidget(300+10, 10, 300 - 20, 180)
   AddItem (*panel, -1, "Tab 1",  LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"))
   AddItem (*panel, -1, "Tab 2", LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
   ButtonWidget( 0,0,50,50,"Button" )
   ButtonWidget( 0,180-79+1,50,50,"Button" )
   AddItem (*panel, -1, "Tab 3", LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
   CloseWidgetList() ; *panel
   
   SetWidgetColor(*panel, #__color_back, $FFAFF8FF)
   SetGadGetWidgetColor(0, #PB_Gadget_BackColor, $FFAFF8FF)
   
   ;SetState(*panel, -1)
   
   ;   FrameWidget(300+30, 200, 300 - 60, 100, "Tab location")
   ;   *option = OptionWidget(300+130, GadgetY(1) + 20, 80, 20, "Top")
   ;   OptionWidget(300+50, GadgetY(1) + 45, 80, 20, "Left")
   ;   OptionWidget(300+130, GadgetY(1) + 45, 80, 20, "Hide")
   ;   OptionWidget(300+130, GadgetY(1) + 70, 80, 20, "Bottom")
   ;   OptionWidget(300+210, GadgetY(1) + 45, 80, 20, "Right")
   ;   SetState(*option, #True)
   ;   BindWidgetEvent( #PB_All, @events_widget( ), #PB_EventType_Change )
   
   
    BindWidgetEvent( #PB_All, @events_widget( ) )
   
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 142
; FirstLine = 128
; Folding = ---
; EnableXP