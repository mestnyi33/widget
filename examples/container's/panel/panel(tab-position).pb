IncludePath "../../../"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   XIncludeFile "include/os/id.pbi"
   XIncludeFile "include/os/win/ClipGadgets.pbi"
CompilerEndIf
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
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
      ProcedureReturn BarPosition(*this\tabbar, position, size)
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
      
      SetActive( *panel )
   EndProcedure
   
   
   Define img_new = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png")
   Define img_open = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   Define img_save = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png")
   If DesktopResolutionX() = 2.0
     ResizeImage(img_new,32,32)
     ResizeImage(img_open,32,32)
     ResizeImage(img_save,32,32)
   EndIf
   
   Open(0, 270, 100, 300, 310, "Change tab location")
   
   *panel = Panel(10, 10, 300 - 20, 180)
   ;ToolBar( widget( ));, #PB_ToolBar_Small )
   AddItem(*panel, 0, "", img_new )
   AddItem(*panel, 1, "open directory", img_open, #PB_ToolBar_Normal)
   AddItem(*panel, 2, "", img_save )
   CloseList() ; *panel
   
   Frame(30, 200, 300 - 60, 100, "Tab location")
   Option(130, 220, 80, 20, "Top", #__flag_Transparent) : SetState(Widget(), #True)
   Option(50, 245, 80, 20, "Left", #__flag_Transparent)
   Option(130, 245, 80, 20, "Hide", #__flag_Transparent)
   Option(130, 270, 80, 20, "Bottom", #__flag_Transparent)
   Option(210, 245, 80, 20, "Right", #__flag_Transparent)
   Bind( #PB_All, @events_widget( ), #__event_Change )
   
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 2
; Folding = --
; EnableXP
; DPIAware