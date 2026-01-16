IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *panel, *option
   Global SelectedGadget
   
   Procedure TabViewType( *this._s_widget, position.i, size.i = #PB_Default )
      ProcedureReturn BarPosition(*this\tabbar, position, size)
   EndProcedure
   
   Procedure TabViewVertical( *this._s_widget, state )
      If state
         ;*this\tabbar\flag | #__flag_Vertical ; BarInlineText 
         *this\tabbar\text\invert = 1
         *this\tabbar\text\vertical = 1
         
         ;_address_\text\rotate = Bool( _address_\text\invert ) * 180 + Bool( _address_\text\vertical ) * 90
            
      Else
;          *this\tabbar\flag &~ #__flag_Vertical 
;          *this\tabbar\bar\vertical = 0
         *this\tabbar\text\invert = 0
         *this\tabbar\text\vertical = 0
       ;   *this\tabbar\text\rotate = 270
     EndIf
      
      ;ProcedureReturn BarPosition(*this\tabbar, position, size)
   EndProcedure
   
   Procedure change_events( )
      
      Select GetText( EventWidget( ) )
         Case "Vertical"
            TabViewVertical( *panel, GetState(EventWidget( )))
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
   
   Frame(10, 200, 300 - 20, 100, "");Tab location")
   CheckBox(130, 200, 80, 20, "Vertical", #__flag_Transparent)
   ;
   Option(130, 230, 80, 20, "Top", #__flag_Transparent) : SetState(Widget(), #True)
   Option(50, 255, 80, 20, "Left", #__flag_Transparent)
   Option(130, 255, 80, 20, "Hide", #__flag_Transparent)
   Option(210, 255, 80, 20, "Right", #__flag_Transparent)
   Option(130, 280, 80, 20, "Bottom", #__flag_Transparent)
   Bind( #PB_All, @change_events( ), #__event_Change )
   
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
            Break
            
      EndSelect
   ForEver
   
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 18
; FirstLine = 11
; Folding = --
; EnableXP
; DPIAware