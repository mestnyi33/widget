IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   
   Global *g
   Define img_new = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png")
   Define img_open = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   Define img_save = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png")
   If DesktopResolutionX() = 2.0
     ResizeImage(img_new,32,32)
     ResizeImage(img_open,32,32)
     ResizeImage(img_save,32,32)
   EndIf
   
   Open(0, 270, 100, 430, 430, "Change tab location")
   
   *g = Panel(10, 10, 200, 200, #__flag_Top) 
   AddItem(*g, 0, "", img_new )
   AddItem(*g, 1, "open top", img_open, #PB_ToolBar_Normal)
   AddItem(*g, 2, "", img_save )
   CloseList() ; *g
  
   *g = Panel(220, 10, 200, 200, #__flag_Bottom)
   AddItem(*g, 0, "", img_new )
   AddItem(*g, 1, "open bottom", img_open, #PB_ToolBar_Normal)
   AddItem(*g, 2, "", img_save )
   CloseList() ; *g
  
   *g = Panel(10, 220, 200, 200, #__flag_Left)
   AddItem(*g, 0, "", img_new )
   AddItem(*g, 1, "open left", img_open, #PB_ToolBar_Normal)
   AddItem(*g, 2, "", img_save )
   CloseList() ; *g
  
   *g = Panel(220, 220, 200, 200, #__flag_Right)
   AddItem(*g, 0, "", img_new )
   AddItem(*g, 1, "open right", img_open);, #PB_ToolBar_Normal)
   AddItem(*g, 2, "", img_save )
   CloseList() ; *g
   
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
            Break
            
      EndSelect
   ForEver
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 45
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware