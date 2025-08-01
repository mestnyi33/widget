
Global oldCallback

Procedure LVcallback(hWnd, uMsg, wParam, lParam)
  
  result = CallWindowProc_(oldCallback, hWnd, uMsg, wParam, lParam)
  Select uMsg
      
     Case #WM_VSCROLL,#WM_MOUSEWHEEL
        If hwnd = GadgetID(1)
           gid = GadgetID(0)
        ElseIf hwnd = GadgetID(0)
           gid = GadgetID(1)
        EndIf
        Item_Sp = SendMessage_(hwnd, #LVM_GETITEMSPACING, 1, 0) >> 16 
        SelItem = GetScrollPos_(hwnd,#SB_VERT) - GetScrollPos_(gid,#SB_VERT)
        SendMessage_(gid, #LVM_SCROLL, 0, SelItem * Item_Sp)
        
    Case #WM_HSCROLL
      If hwnd = GadgetID(1)
        SelItem = GetScrollPos_(hwnd,#SB_HORZ) - GetScrollPos_(GadgetID(0),#SB_HORZ)
        SendMessage_(GadgetID(0), #LVM_SCROLL, SelItem , 0)
      ElseIf hwnd = GadgetID(0)
        SelItem = GetScrollPos_(hwnd,#SB_HORZ) - GetScrollPos_(GadgetID(1),#SB_HORZ)
        SendMessage_(GadgetID(1), #LVM_SCROLL, SelItem , 0)
      EndIf
      
      
   Case #WM_KEYDOWN ,#WM_MENUSELECT
      If hwnd = GadgetID(1)
         gid = GadgetID(0)
      ElseIf hwnd = GadgetID(0)
         gid = GadgetID(1)
      EndIf
      If wParam=#VK_UP Or wParam=#VK_DOWN
         Item_Sp = SendMessage_(hwnd, #LVM_GETITEMSPACING, 1, 0) >> 16 
         SelItem = GetScrollPos_(hwnd, #SB_VERT) - GetScrollPos_(gid,#SB_VERT)
      ElseIf wParam=#VK_LEFT Or wParam=#VK_RIGHT
         SelItem = GetScrollPos_(hwnd, #SB_HORZ) - GetScrollPos_(gid,#SB_HORZ)
      EndIf         
      SendMessage_(Gid, #LVM_SCROLL, 0, SelItem * Item_Sp)
      
EndSelect
  
  ProcedureReturn result
EndProcedure

OpenWindow(0, 0, 0, 620, 400,"Syncronize ListIcon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
ListIconGadget(0, 10, 10, 300, 380, "Column 0", 150, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection|#LVS_NOCOLUMNHEADER)
ListIconGadget(1, 310, 10, 300, 380, "Column 0", 150, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection|#LVS_NOCOLUMNHEADER)

For n = 0 To 1
  For i = 0 To 100
    AddGadgetItem(n,-1,"Line " + Str(i) + " Column 0" + Chr(10) + "Line " + Str(i) + " Column 1"+ Chr(10) + "Line " + Str(i) + " Column 2"+ Chr(10) + "Line " + Str(i) + " Column 3"+ Chr(10) + "Line " + Str(i) + " Column 4"+ Chr(10) + "Line " + Str(i) + " Column 5")
  Next i
Next

oldCallback = SetWindowLongPtr_(GadgetID(0), #GWL_WNDPROC, @LVcallback())
oldCallback = SetWindowLongPtr_(GadgetID(1), #GWL_WNDPROC, @LVcallback())  

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow 
      Quit = 1
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 0
          
      EndSelect 
      
  EndSelect
  
Until Quit = 1

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 20
; Folding = --
; EnableXP