CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
       
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False
          If IsGadget( Gadget )
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
               
            EndSelect
          EndIf
         
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
         
          If Height
            ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
          EndIf
         
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
       
      EndIf
     
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  Procedure ClipGadgets( WindowID )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  Structure _NMCUSTOMDRAW
    hdr.NMHDR
    dwDrawStage.l
    hdc.l
    rc.RECT
    dwItemSpec.l
    uItemState.l
    lItemlParam.l
EndStructure

Structure _NMLVCUSTOMDRAW
    nmcd.NMCUSTOMDRAW
    clrText.l
    clrTextBk.l
    iSubItem.l
    dwItemType.l
    clrFace.l
    iIconEffect.l
    iIconPhase.l
    iPartId.l
    iStateId.l
    rcText.RECT
    uAlign.l
EndStructure

#NM_CUSTOMDRAW = #NM_FIRST-12 

#CDDS_ITEM = $10000
#CDDS_SUBITEM = $20000
#CDDS_PREPAINT = $1
#CDDS_ITEMPREPAINT = #CDDS_ITEM|#CDDS_PREPAINT
#CDDS_SUBITEMPREPAINT = #CDDS_SUBITEM|#CDDS_ITEMPREPAINT
#CDRF_DODEFAULT = $0
#CDRF_NEWFONT = $2
#CDRF_NOTIFYITEMDRAW = $20
#CDRF_NOTIFYSUBITEMDRAW = $20

Structure _LVHITTESTINFO
  pt.POINT
  flags.l
  iItem.l
  iSubItem.l
EndStructure

#LVM_SUBITEMHITTEST = #LVM_FIRST+57
#LVM_GETSUBITEMRECT = #LVM_FIRST+56

Global ListGadget, OldLViewProc, OldEditProc, OldButtonProc
Global hEdit, rct.RECT, CellSelectOn, CurItem, CurSubItem, CurSelItem, CurSelSubItem, LastButton
Global LastSubItem, LastItem, LabelWidth, CellHeight, HeaderHeight
Global CurIniSelSubItem, CurIniSelItem, CellSelecting

Declare ButtonProc(hWnd, uMsg, wParam, lParam)
Declare EditProc(hWnd, uMsg, wParam, lParam)
Declare LViewProc(hWnd, uMsg, wParam, lParam)
Declare WndProc(hWnd, uMsg, wParam, lParam) 
Declare KillFocus()
Declare DrawRectangle(hWnd, *rc.RECT)

#CCM_SETVERSION = #CCM_FIRST+7

Global FontReg, FontBold
FontReg = LoadFont(1, "Tahoma", 9) 
FontBold = LoadFont(2, "Tahoma", 9, #PB_Font_Bold) 

If OpenWindow(0, 0, 0, 420, 260, "Color List View Rows", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)=0:End:EndIf


ListGadget = ListIconGadget(1, 10, 10, 400, 240, "", 70, #PB_ListIcon_GridLines)
GetClientRect_(GetWindow_(ListGadget, #GW_CHILD), rct)
HeaderHeight = rct\bottom
HideGadget(1, #True)

SendMessage_(ListGadget, #CCM_SETVERSION, 5, 0)

AddGadgetColumn(1, 1, "Mon", 35)
AddGadgetColumn(1, 2, "Tue", 35)
AddGadgetColumn(1, 3, "Wed", 35)
AddGadgetColumn(1, 4, "Thu", 35)
AddGadgetColumn(1, 5, "Fri", 35)
AddGadgetColumn(1, 6, "Sat", 35)
AddGadgetColumn(1, 7, "Sun", 35)

SendMessage_(ListGadget, #LVM_SETBKCOLOR, 0, RGB(255, 255, 223))
SendMessage_(ListGadget, #WM_SETFONT, FontBold, #True)


For i=18 To 34
  hour12 = i
  If hour12>25
    hour12-24
    Hour$ = " pm"
  Else
    Hour$ = " am"
  EndIf
  If hour12&1
    Hour$=LSet(Str(hour12/2)+":30"+Hour$, 9, " ")
  Else
    Hour$=LSet(Str(hour12/2)+":00"+Hour$, 9, " ")
  EndIf
  AddGadgetItem(1, -1, Hour$+Chr(10)+Str(hour12/2)+"1"+Chr(10)+Str(hour12/2)+"2"+Chr(10)+Str(hour12/2)+"3"+Chr(10)+Str(hour12/2)+"4"+Chr(10)+Str(hour12/2)+"5"+Chr(10)+Str(hour12/2)+"6"+Chr(10)+Str(hour12/2)+"7")
  rct\top = 0
  rct\left = #LVIR_BOUNDS 
  SendMessage_(ListGadget, #LVM_GETSUBITEMRECT, i-18, rct)
  rct\right = rct\left+SendMessage_(ListGadget, #LVM_GETCOLUMNWIDTH, 0, 0)
  ButtonGadget = ButtonGadget(i-15, rct\left, rct\top, rct\right-rct\left, rct\bottom-rct\top, Hour$)
  LabelWidth = rct\right-rct\left
  SendMessage_(ButtonGadget, #WM_SETFONT, FontBold, #True)
  OldButtonProc = SetWindowLong_(ButtonGadget, #GWL_WNDPROC, @ButtonProc())
Next i
LastButton = i-16
LastItem = i-19
LastSubItem = 7

OldLViewProc = SetWindowLong_(ListGadget, #GWL_WNDPROC, @LViewProc())
SetWindowCallback(@WndProc()) 

For i=0 To 7
  SendMessage_(ListGadget, #LVM_SETCOLUMNWIDTH, i, #LVSCW_AUTOSIZE_USEHEADER)
Next i

HideGadget(1, #False)

 ClipGadgets(UseGadgetList(0))
  
Repeat
  EventID = WaitWindowEvent()
Until EventID=#PB_Event_CloseWindow 

End 

Procedure KillFocus()
  If hEdit
    SetGadgetItemTextWidget(1, CurItem, GetGadgetTextWidget(2), CurSubItem)
    FreeGadget(2)
    hEdit = 0
  EndIf
EndProcedure

Procedure DrawRectangle(hWnd, *rc.RECT)
  hDC = GetDC_(hWnd)
  OldPen = SelectObject_(hDC, GetStockObject_(#BLACK_PEN))
  OldBrush = SelectObject_(hDC, GetStockObject_(#NULL_BRUSH))
  Rectangle_(hDC, *rc\left, *rc\top, *rc\right, *rc\bottom)
  SelectObject_(hDC, OldBrush)
  SelectObject_(hDC, OldPen)
  ReleaseDC_(hWnd, hDC)
EndProcedure

Procedure ButtonProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_LBUTTONDOWN
      result = CallWindowProc_(OldButtonProc, hWnd, uMsg, wParam, lParam)
      pt.POINT
      pt\x = lParam&$FFFF
      pt\y = lParam>>16
      ClientToScreen_(hWnd, pt)
      ScreenToClient_(ListGadget, pt)
      lParam = (pt\y<<16)|(pt\x&$FFFF)
      SendMessage_(ListGadget, uMsg, wParam, lParam)
    Default
      result = CallWindowProc_(OldButtonProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

Procedure EditProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_KEYDOWN
      Select wParam
        Case #VK_RETURN
          KillFocus()
          DrawRectangle(ListGadget, rct)
        Case #VK_UP
          KillFocus()
          SendMessage_(ListGadget, uMsg, wParam, lParam)
        Case #VK_DOWN
          KillFocus()
          SendMessage_(ListGadget, uMsg, wParam, lParam)
        Default
          result = CallWindowProc_(OldEditProc, hWnd, uMsg, wParam, lParam)
      EndSelect
    Default
      result = CallWindowProc_(OldEditProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

Procedure LViewProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_KEYDOWN
      Select wParam
        Case #VK_C
          If CellSelectOn And GetAsyncKeyState_(#VK_CONTROL)
            Select CurSelSubItem
              Case 0
                For i=1 To LastSubItem
                  Text$+GetGadgetItemTextWidget(1, CurSelItem, i)+"  "
                Next i
                SetClipboardTextWidget(Text$)
              Default
                SetClipboardTextWidget(GetGadgetItemTextWidget(1, CurSelItem, CurSelSubItem))
            EndSelect
          EndIf
        Case #VK_X
          If CellSelectOn And GetAsyncKeyState_(#VK_CONTROL)
            Select CurSelSubItem
              Case 0
                For i=1 To LastSubItem
                  Text$+GetGadgetItemTextWidget(1, CurSelItem, i)+"  "
                  SetGadgetItemTextWidget(1, CurSelItem, "", i)
                Next i
                SetClipboardTextWidget(Text$)
              Default
                SetClipboardTextWidget(GetGadgetItemTextWidget(1, CurSelItem, CurSelSubItem))
                SetGadgetItemTextWidget(1, CurSelItem, "", CurSelSubItem)
            EndSelect
          EndIf
        Case #VK_V
          If CellSelectOn And GetAsyncKeyState_(#VK_CONTROL)
            Select CurSelSubItem
              Case 0
                Text$ = GetClipboardTextWidget()
                Text$ = ReplaceString(Text$, Chr(7), "  ")
                StartPos = 0
                For i=1 To LastSubItem
                  LastPos = StartPos
                  StartPos = FindStringWidget(Text$, "  ", StartPos)
                  SetGadgetItemTextWidget(1, CurSelItem, Mid(Text$, LastPos+1, StartPos-LastPos-1), i)
                  StartPos+1
                Next i
              Default
                SetGadgetItemTextWidget(1, CurSelItem, GetClipboardTextWidget(), CurSelSubItem)
            EndSelect
          EndIf
        Case #VK_DELETE
          If CellSelectOn
            SetGadgetItemTextWidget(1, CurSelItem, "", CurSelSubItem)
          EndIf
        Case #VK_UP
          If CellSelectOn And CurSelItem
            MouseFlags = #MK_LBUTTON
            If GetAsyncKeyState_(#VK_SHIFT):MouseFlags|#MK_SHIFT:EndIf
            rc.RECT
            rc\top = CurSelSubItem
            rc\left = #LVIR_BOUNDS
            SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem-1, rc)
            rc\top-1
            rc\right+1
            pt.POINT
            If CurSelSubItem
              pt\x = rc\right-((rc\right-rc\left)/2)
            Else
              pt\x = rc\left+(LabelWidth/2)
            EndIf
            pt\y = rc\top+(CellHeight/2)
            lParam = (pt\y<<16)|(pt\x&$FFFF)
            SendMessage_(hWnd, #WM_LBUTTONDOWN, MouseFlags, lParam)
          EndIf
        Case #VK_RIGHT
          If CellSelectOn And CurSelSubItem<LastSubItem
            MouseFlags = #MK_LBUTTON
            If GetAsyncKeyState_(#VK_SHIFT):MouseFlags|#MK_SHIFT:EndIf
            rc.RECT
            rc\top = CurSelSubItem+1
            rc\left = #LVIR_BOUNDS
            SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem, rc)
            rc\top-1
            rc\right+1
            pt.POINT
            pt\x = rc\left+((rc\right-rc\left)/2)
            pt\y = rc\top+(CellHeight/2)
            lParam = (pt\y<<16)|(pt\x&$FFFF)
            SendMessage_(hWnd, #WM_LBUTTONDOWN, MouseFlags, lParam)
          EndIf
        Case #VK_DOWN
          If CellSelectOn And CurSelItem<LastItem
            MouseFlags = #MK_LBUTTON
            If GetAsyncKeyState_(#VK_SHIFT):MouseFlags|#MK_SHIFT:EndIf
            rc.RECT
            rc\top = CurSelSubItem
            rc\left = #LVIR_BOUNDS
            SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem+1, rc)
            rc\top-1
            rc\right+1
            pt.POINT
            If CurSelSubItem
              pt\x = rc\right-((rc\right-rc\left)/2)
            Else
              pt\x = rc\left+(LabelWidth/2)
            EndIf
            pt\y = rc\top+(CellHeight/2)
            lParam = (pt\y<<16)|(pt\x&$FFFF)
            SendMessage_(hWnd, #WM_LBUTTONDOWN, MouseFlags, lParam)
          EndIf
        Case #VK_LEFT
          If CellSelectOn And CurSelSubItem
            MouseFlags = #MK_LBUTTON
            If GetAsyncKeyState_(#VK_SHIFT):MouseFlags|#MK_SHIFT:EndIf
            rc.RECT
            rc\top = CurSelSubItem-1
            rc\left = #LVIR_BOUNDS
            SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem, rc)
            rc\top-1
            rc\right+1
            pt.POINT
            If CurSelSubItem>1
              pt\x = rc\right-((rc\right-rc\left)/2)
            Else
              pt\x = rc\left+(LabelWidth/2)
            EndIf
            pt\y = rc\top+(CellHeight/2)
            lParam = (pt\y<<16)|(pt\x&$FFFF)
            SendMessage_(hWnd, #WM_LBUTTONDOWN, MouseFlags, lParam)
          EndIf
        Default
          result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      EndSelect
    Case #WM_PAINT
      result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      If CellSelectOn
        DrawRectangle(hWnd, rct)
      EndIf
    Case #WM_LBUTTONDOWN
      If hWnd<>hEdit
        KillFocus()
        pInfo.LVHITTESTINFO
        pInfo\pt\x = lParam&$FFFF
        pInfo\pt\y = lParam>>16
        SendMessage_(hWnd, #LVM_SUBITEMHITTEST, 0, pInfo)
        rcc.RECT
        rcc\top = pInfo\iSubItem
        rcc\left = #LVIR_BOUNDS
        SendMessage_(hWnd, #LVM_GETSUBITEMRECT, pInfo\iItem, rcc)
        rcc\top-1
        rcc\right+1
        SendMessage_(hWnd, #LVM_ENSUREVISIBLE, pInfo\iItem, #False)
        rc.RECT
        rc\top = pInfo\iSubItem
        rc\left = #LVIR_BOUNDS
        SendMessage_(hWnd, #LVM_GETSUBITEMRECT, pInfo\iItem, rc)
        rc\top-1
        rc\right+1
        ItemS = rcc\top-rc\top
        If ItemS<>0
          rct\top-ItemS
          rct\bottom-ItemS
        EndIf
        ItemS = rcc\left-rc\left
        If ItemS<>0
          rct\left-ItemS
          rct\right-ItemS
        EndIf
        If CellSelectOn=0
          CellHeight = rc\bottom-rc\top
        EndIf
        If wParam&#MK_SHIFT And CellSelectOn
          If CellSelecting=0
            CurIniSelSubItem = CurSelSubItem
            CurIniSelItem = CurSelItem
            CellSelecting = 1
          EndIf
          If pInfo\iItem<CurIniSelItem
            rc\bottom = rct\bottom
          ElseIf pInfo\iItem>CurIniSelItem
            rc\top = rct\top
          EndIf
          If pInfo\iSubItem<CurIniSelSubItem
            rc\right = rct\right
          ElseIf pInfo\iSubItem>CurIniSelSubItem
            rc\left = rct\left
          EndIf
        ElseIf wParam&#MK_SHIFT=0
          CellSelecting = 0
        EndIf
        If CellSelectOn
          InvalidateRect_(hWnd, rct, #True)
        EndIf
        CellSelectOn = 1
        CurSelItem = pInfo\iItem
        CurSelSubItem = pInfo\iSubItem
        DrawRectangle(hWnd, rc)
        CopyMemory(rc, rct, SizeOf(RECT))
        SetFocus_(hWnd)
      Else
        SetFocus_(hEdit)
        result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      EndIf
    Case #WM_LBUTTONDBLCLK
      If hWnd<>hEdit
        KillFocus()
        pInfo.LVHITTESTINFO
        pInfo\pt\x = lParam&$FFFF
        pInfo\pt\y = lParam>>16
        SendMessage_(hWnd, #LVM_SUBITEMHITTEST, 0, pInfo)
        rc.RECT
        rc\top = pInfo\iSubItem
        rc\left = #LVIR_BOUNDS
        SendMessage_(hWnd, #LVM_GETSUBITEMRECT, pInfo\iItem, rc)
        If hEdit=0
          UseGadgetList(hWnd)
          CurItem = pInfo\iItem
          CurSubItem = pInfo\iSubItem
          Text$ = GetGadgetItemTextWidget(1, CurItem, CurSubItem)
          If CurSubItem=0
            rc\right = rc\left+SendMessage_(hWnd, #LVM_GETCOLUMNWIDTH, 0, 0)
          EndIf
          hEdit = StringGadget(2, rc\left+1, rc\top, rc\right-rc\left-1, rc\bottom-rc\top-1, Text$, #PB_String_BorderLess)
          If CurSubItem=0
            SendMessage_(hEdit, #WM_SETFONT, FontBold, #True)
          Else
            SendMessage_(hEdit, #WM_SETFONT, FontReg, #True)
          EndIf
          OldEditProc = SetWindowLong_(hEdit, #GWL_WNDPROC, @EditProc())
          SetFocus_(hEdit)
        EndIf
      Else
        result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      EndIf
    Case #WM_CTLCOLOREDIT
      If GetFocus_()=lParam
        SetBkMode_(wParam, #TRANSPARENT)
        If CurItem&1=0
          TextBkColor = RGB(255, 255, 223)
          If CurSubItem=3
            TextColor = RGB(255, 0, 0)
          EndIf
        Else
          TextBkColor = RGB(208, 208, 176)
          If CurSubItem=3
            TextColor = RGB(0, 0, 255)
          EndIf
        EndIf
        SetTextColor_(wParam, TextColor)
        result = CreateSolidBrush_(TextBkColor)
      Else
        result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      EndIf
    Case #WM_VSCROLL
      result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      rc.RECT
      TopVisibleItem = SendMessage_(hWnd, #LVM_GETTOPINDEX, 0, 0)
      If CellSelectOn
        rc\top = CurSelSubItem
        rc\left = #LVIR_BOUNDS
        SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem, rc)
        rc\top-1
      EndIf
      If hEdit
        If TopVisibleItem<=CurItem
          ResizeGadget(2, -1, rc\top, -1, -1)
          HideGadget(2, #False)
          RedrawWindow_(hEdit, 0, 0, #RDW_INTERNALPAINT|#RDW_ERASE|#RDW_INVALIDATE)
        Else
          HideGadget(2, #True)
        EndIf
        SetFocus_(hEdit)
      EndIf
    Case #WM_HSCROLL
      result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
      rc.RECT
      TopVisibleItem = SendMessage_(hWnd, #LVM_GETTOPINDEX, 0, 0)
      If CellSelectOn
        rc\top = CurSelSubItem
        rc\left = #LVIR_BOUNDS
        SendMessage_(hWnd, #LVM_GETSUBITEMRECT, CurSelItem, rc)
      EndIf
      If hEdit
        If TopVisibleItem<=CurItem
          ResizeGadget(2, rc\left, -1, -1, -1)
          HideGadget(2, #False)
          RedrawWindow_(hEdit, 0, 0, #RDW_INTERNALPAINT|#RDW_ERASE|#RDW_INVALIDATE)
        Else
          HideGadget(2, #True)
        EndIf
        SetFocus_(hEdit)
      EndIf
    Default
      result = CallWindowProc_(OldLViewProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

Procedure WndProc(hWnd, uMsg, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
  Select uMsg
    Case #WM_NOTIFY
      *pnmh.NMHDR = lParam
      Select *pnmh\code
        Case #NM_CUSTOMDRAW
          *LVCDHeader.NMLVCUSTOMDRAW = lParam
          If *LVCDHeader\nmcd\hdr\hWndFrom=ListGadget
            Select *LVCDHeader\nmcd\dwDrawStage 
              Case #CDDS_PREPAINT
                result = #CDRF_NOTIFYITEMDRAW
              Case #CDDS_ITEMPREPAINT
                result = #CDRF_NOTIFYSUBITEMDRAW
              Case #CDDS_SUBITEMPREPAINT
                If *LVCDHeader\iSubItem>0
                  Row = *LVCDHeader\nmcd\dwItemSpec
                  Col = *LVCDHeader\iSubItem
                  If Col=0
                    SelectObject_(*LVCDHeader\nmcd\hDC, FontBold)
                  Else
                    SelectObject_(*LVCDHeader\nmcd\hDC, FontReg)
                  EndIf
                  If Row&1=0
                    *LVCDHeader\clrTextBk = RGB(255, 255, 223)
                    If Col=3
                      *LVCDHeader\clrText = RGB(255, 0, 0)
                    Else
                      *LVCDHeader\clrText = RGB(0, 0, 0)
                    EndIf
                  Else
                    *LVCDHeader\clrTextBk = RGB(208, 208, 176)
                    If Col=3
                      *LVCDHeader\clrText = RGB(0, 0, 255)
                    Else
                      *LVCDHeader\clrText = RGB(0, 0, 0)
                    EndIf
                  EndIf
                  result = #CDRF_NEWFONT
                Else
                  rc.RECT
                  ColumnWidth = SendMessage_(ListGadget, #LVM_GETCOLUMNWIDTH, 0, 0)
                  LabelWidth = ColumnWidth
                  For i=3 To LastButton
                    rc\top = 0
                    rc\left = #LVIR_BOUNDS
                    SendMessage_(ListGadget, #LVM_GETSUBITEMRECT, i-3, rc)
                    rc\right = rc\left+ColumnWidth
                    ResizeGadget(i, rc\left, rc\top, rc\right-rc\left, rc\bottom-rc\top)
                    If rc\top<HeaderHeight
                      HideGadget(i, #True)
                    Else
                      HideGadget(i, #False)
                    EndIf
                  Next i
                EndIf
            EndSelect
          EndIf
        Case #HDN_FIRST-1
          If CellSelectOn ; TODO: Fix rectangle coords when headers sized (get corner subitems rect)
            InvalidateRect_(ListGadget, rct, #True)
          EndIf
      EndSelect
  EndSelect
  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 136
; FirstLine = 132
; Folding = --------------
; EnableXP