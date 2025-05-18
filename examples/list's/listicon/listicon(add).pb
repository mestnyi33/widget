XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Open(0, 0, 0, 400, 150, "ListIcon - Add Columns", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ListIcon = ListIcon(10, 10, 380, 100, "Standard Column", 150, #PB_ListIcon_GridLines)
   ButtonGadget(1, 10, 120, 150, 20, "Add new column")
   
   Define event, Index = 1     ; "Standard column" has already index 0
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventGadget() = 1
            AddColumn(ListIcon, Index, "Column " + Str(Index), 80)
            AddItem(ListIcon, Index - 1, "Row" + Str(Index))
            
            SetItemText(ListIcon, Index - 1, Str(Index), Index)
            
            Index + 1
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 17
; Folding = -
; EnableXP
; DPIAware