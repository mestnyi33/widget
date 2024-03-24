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
   
   Procedure   BarPosition2( *this._s_widget, position.i, size.i = #PB_Default )
      Protected fs = 2
      If *this\type <> #__type_Panel
         *this = *this\parent
      EndIf
      
      ; reset position
      *this\fs[1] = 0
      *this\fs[2] = 0
      *this\fs[3] = 0
      *this\fs[4] = 0
      
      If size = #PB_Default
         If *this\TabBox( )\flag & #PB_ToolBar_Small 
            size = 25
         ElseIf *this\TabBox( )\flag & #PB_ToolBar_Large 
            size = 45
         Else ; If *this\flag & #PB_ToolBar_Normal 
            size = 35
         EndIf
      EndIf   
      
      *this\TabBox( )\TabChange( ) = 1
      
      If position = 1 Or position = 3
         If *this\TabBox( )\flag & #PB_ToolBar_InlineText
            size = 80
         Else
            size = 50;- (1 + fs)
         EndIf
      EndIf
      
      If position = 0
         *this\TabBox( )\hide = 1
      Else
         *this\TabBox( )\hide = 0
      EndIf
      
      If position = 1
         *this\TabBox( )\bar\vertical = 1
         *this\fs[1] = size + fs ; #__panel_width
      EndIf
      
      If position = 3
         *this\TabBox( )\bar\vertical = 1
         *this\fs[3] = size + fs ; #__panel_width
      EndIf
      
      If position = 2
         *this\TabBox( )\bar\vertical = 0
         *this\fs[2] = size + fs ; #__panel_height
      EndIf
      
      If position = 4
         *this\TabBox( )\bar\vertical = 0
         *this\fs[4] = size + fs ; #__panel_height
      EndIf
      
      If Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         PostEventRepaint( *this\root )
      EndIf
   EndProcedure
   
   Procedure   BarPosition1( *this._s_widget, position.i, size.i = #PB_Default )
      If *this\type <> #__type_Panel
         *this = *this\parent
      EndIf
      
      
      ; reset position
      *this\fs[1] = 0
      *this\fs[2] = 0
      *this\fs[3] = 0
      *this\fs[4] = 0
      
      If position = 0
         *this\TabBox( )\hide = 1
      Else
         *this\TabBox( )\hide = 0
      EndIf
      
      If position = 1
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[1] = #__panel_width
         Else
            *this\fs[1] = size
         EndIf
      EndIf
      
      If position = 3
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[3] = #__panel_width
         Else
            *this\fs[3] = size
         EndIf
      EndIf
      
      If position = 2
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[2] = #__panel_height
         Else
            *this\fs[2] = size
         EndIf
      EndIf
      
      If position = 4
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[4] = #__panel_height
         Else
            *this\fs[4] = size
         EndIf
      EndIf
      
      If Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         PostEventRepaint( *this\root )
      EndIf
   EndProcedure
   
   
   Macro BarPositon_( this, position, size=-1 )
      BarPosition2( this, position, size )
   EndMacro
   
   ;   Procedure events_widget( )
   ;     
   ;     Select GetText( EventWidget( ) )
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
      
      Select GetGadgetText( EventGadget( ) )
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
   
   Open(0, 270, 100, 600, 310, "Change tab location")
   a_init(root(),0)
   
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
   
   
   *panel = Panel(300+10, 10, 300 - 20, 180)
   AddItem (*panel, -1, "Tab 1",  LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"))
   AddItem (*panel, -1, "Tab 2", LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
   Button( 0,0,50,50,"Button" )
   Button( 0,180-79,50,50,"Button" )
   AddItem (*panel, -1, "Tab 3", LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
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
; CursorPosition = 52
; FirstLine = 26
; Folding = --8---
; EnableXP