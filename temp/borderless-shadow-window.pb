Global shadow
Procedure Resize_PopupWindowEvents( )
   Protected win = EventWindow( )
   Protected x = WindowX(win, #PB_Window_FrameCoordinate)
   Protected y = WindowY(win, #PB_Window_FrameCoordinate)
   Protected width = WindowWidth(win, #PB_Window_InnerCoordinate)
   Protected height = WindowHeight(win, #PB_Window_InnerCoordinate)
   Protected bx = WindowWidth(shadow, #PB_Window_FrameCoordinate)-WindowWidth(shadow, #PB_Window_InnerCoordinate)
   Protected by = WindowHeight(shadow, #PB_Window_FrameCoordinate)-WindowHeight(shadow, #PB_Window_InnerCoordinate)
   
   ResizeWindow(shadow, x, y, width-bx, height-by)
EndProcedure

Procedure Create_PopupWindow( window, parentID=0 )
   shadow = OpenWindow(#PB_Any, 0,0,0,0, "Test", #PB_Window_TitleBar, parentID)
   OpenWindow(window, 0,0,0,0, "Test", #PB_Window_BorderLess, WindowID(shadow))
   BindEvent(#PB_Event_MoveWindow, @Resize_PopupWindowEvents(), 0)
   BindEvent(#PB_Event_SizeWindow, @Resize_PopupWindowEvents(), 0)
EndProcedure

Create_PopupWindow( 0 )
ListViewGadget(2,0,0,320,200)
For i=0 To 20
   AddGadgetItem(2,-1,"item_"+Str(i))
Next

;\\
ResizeWindow(0,550,350,320,200)
While WaitWindowEvent() <> #PB_Event_CloseWindow : Wend
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 8
; Folding = -
; EnableXP