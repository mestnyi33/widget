IncludeFile #PB_Compiler_Home+"tailbite/Helper Libraries/TB_GadgetExtension.pb";If you installed TB somewhere else, you will need to change the path shown here.

Global VT.PB_GadgetVT

#SS_NOTIFY = $100

Structure MyGadgetInfo
  width.l
  height.l
  FColor.l
  BColor.l
  mDC.l
  PenWidth.l
  hPen.l
  hOldPen.l
  hBrush.l
  hOldBrush.l
  hBitmap.l
  hOldBitmap.l
  hOldCursor.l
EndStructure
  
Procedure MyFreeGadget(GadgetID)
  DestroyWindow_(GadgetID)
EndProcedure
  
Procedure MyGetGadgetState(GadgetID)
  *mgi.MyGadgetInfo = GetWindowLongPtr_(GadgetID(GadgetID), #GWL_USERDATA)
  ProcedureReturn *mgi\FColor
EndProcedure

Procedure MySetGadgetState(GadgetID, FColor)
  *mgi.MyGadgetInfo = GetWindowLongPtr_(GadgetID(GadgetID), #GWL_USERDATA)
  result = *mgi\FColor
  *mgi\FColor = FColor
  *mgi\hPen = CreatePen_(#PS_SOLID, *mgi\PenWidth, *mgi\FColor)
  hOldPen = SelectObject_(*mgi\mDC, *mgi\hPen)
  DeleteObject_(hOldPen)
  ProcedureReturn result
EndProcedure

Procedure WndProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_LBUTTONDOWN
      SetCapture_(hWnd)
      GetClientRect_(hWnd, rc.RECT)
      ptClientLR.POINT
      ptClientUL.POINT
      ptClientUL\x = rc\left
      ptClientUL\y = rc\top
      ptClientLR\x = rc\right+1
      ptClientLR\y = rc\bottom+1
      ClientToScreen_(hWnd, @ptClientUL)
      ClientToScreen_(hWnd, @ptClientLR)
      SetRect_(@rc, ptClientUL\x, ptClientUL\y, ptClientLR\x, ptClientLR\y)
      ClipCursor_(@rc)
      *mgi.MyGadgetInfo = GetWindowLongPtr_(hWnd, #GWL_USERDATA)
      MoveToEx_(*mgi\mDC, lParam&$FFFF, lParam>>16, 0)
    Case #WM_LBUTTONUP
      ClipCursor_(#Null)
      ReleaseCapture_()
    Case #WM_SIZE
      *mgi.MyGadgetInfo = GetWindowLongPtr_(hWnd, #GWL_USERDATA)
      If *mgi
        width = lParam&$FFFF
        height = lParam>>16
        If width>*mgi\width Or height>*mgi\height
          hDC = GetDC_(hWnd)
          mDC = CreateCompatibleDC_(hDC)
          ReleaseDC_(hWnd, hDC)
          bmi.BITMAPINFOHEADER
          bmi\biSize = SizeOf(BITMAPINFOHEADER)
          bmi\biWidth = width
          bmi\biHeight = height
          bmi\biPlanes = 1
          bmi\biBitCount = 32
          bmi\biCompression = #BI_RGB 
          hBitmap = CreateDIBSection_(mDC, @bmi, #DIB_RGB_COLORS, @vBits.l, 0, 0)
          GdiFlush_()
          hPen = SelectObject_(*mgi\mDC, *mgi\hOldPen)
          hBrush = SelectObject_(*mgi\mDC, *mgi\hOldBrush)
          hOldBitmap = SelectObject_(mDC, hBitmap)
          hOldBrush = SelectObject_(mDC, hBrush)
          hOldPen = SelectObject_(mDC, hPen)
          rc.RECT
          rc\left = 0
          rc\top = 0
          rc\right = width
          rc\bottom = height
          FillRect_(mDC, @rc, hBrush)
          BitBlt_(mDC, 0, 0, *mgi\width, *mgi\height, *mgi\mDC, 0, 0, #SRCCOPY)
          *mgi\hOldBitmap = hOldBitmap
          hOldBitmap = SelectObject_(*mgi\mDC, *mgi\hBitmap)
          DeleteObject_(hOldBitmap)
          DeleteDC_(*mgi\mDC)
          *mgi\mDC = mDC
          *mgi\hBitmap = hBitmap
          phWnd = GetParent_(hWnd)
;           rc\left = 0
;           rc\top = 0
;           rc\right = *mgi\width-1
;           rc\bottom = *mgi\height-1
;           ValidateRect_(hWnd, @rc)
;           rc\left = *mgi\width-1
;           rc\top = 0
;           rc\right = width-1
;           rc\bottom = height-1
;           InvalidateRect_(hWnd, @rc, #FALSE)
;           rc\left = 0
;           rc\top = *mgi\height-1
;           rc\right = *mgi\width-1
;           rc\bottom = height-1
;           InvalidateRect_(hWnd, @rc, #FALSE)
          rc\left = 0
          rc\top = 0
          rc\right = width-1
          rc\bottom = height-1
          InvalidateRect_(hWnd, @rc, #False)
        EndIf
        *mgi\width = width
        *mgi\height = height
      EndIf
    Case #WM_MOUSEMOVE
      If wParam&#MK_LBUTTON
        *mgi.MyGadgetInfo = GetWindowLongPtr_(hWnd, #GWL_USERDATA)
        MoveToEx_(*mgi\mDC, 0, 0, pt.POINT)
        MoveToEx_(*mgi\mDC, pt\x, pt\y, 0)
        newX = lParam&$FFFF
        newY = lParam>>16
        LineTo_(*mgi\mDC, newX, newY)
        rc.RECT
        If newX<pt\x
          rc\left = newX-(*mgi\PenWidth/2)
          rc\right = pt\x+(*mgi\PenWidth/2)
        Else
          rc\left = pt\x-(*mgi\PenWidth/2)
          rc\right = newX+(*mgi\PenWidth/2)
        EndIf
        If newY<pt\y
          rc\top = newY-(*mgi\PenWidth/2)
          rc\bottom = pt\y+(*mgi\PenWidth/2)
        Else
          rc\top = pt\y-(*mgi\PenWidth/2)
          rc\bottom = newY+(*mgi\PenWidth/2)
        EndIf
        InvalidateRect_(hWnd, @rc, #False)
      EndIf
;     Case #WM_ERASEBKGND
;       *mgi.MyGadgetInfo = GetWindowLongptr_(hWnd, #GWL_USERDATA)
;       rc.RECT
;       rc\left = 0
;       rc\top = 0
;       rc\right = *mgi\width-1
;       rc\bottom = *mgi\height-1
;       InvalidateRect_(hWnd, @rc, #FALSE)
; ;      result = 1
    Case #WM_PAINT
      *mgi.MyGadgetInfo = GetWindowLongPtr_(hWnd, #GWL_USERDATA)
      BeginPaint_(hWnd, ps.PAINTSTRUCT)
      BitBlt_(ps\hDC, ps\rcPaint\left, ps\rcPaint\top, ps\rcPaint\right-ps\rcPaint\left, ps\rcPaint\bottom-ps\rcPaint\top, *mgi\mDC, ps\rcPaint\left, ps\rcPaint\top, #SRCCOPY)
      EndPaint_(hWnd, @ps)
    Case #WM_DESTROY
      *mgi.MyGadgetInfo = GetWindowLongPtr_(hWnd, #GWL_USERDATA)
      hPen = SelectObject_(*mgi\mDC, hOldPen)
      hBrush = SelectObject_(*mgi\mDC, *mgi\hOldBrush)
      hBitmap = SelectObject_(*mgi\mDC, *mgi\hOldBitmap)
      DeleteDC_(*mgi\mDC)
      HeapFree_(GetProcessHeap_(), 0, *mgi)
      DeleteObject_(hPen)
      DeleteObject_(hBrush)
      DeleteObject_(hBitmap)
    Default
      result = DefWindowProc_(hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

ProcedureDLL EC_MyPaintBoxGadget(Gadget, x, y, width, height, PenWidth, FColor, BGColor)
  hInstance = GetModuleHandle_(0)
  wc.WNDCLASSEX
  wc\cbSize = SizeOf(WNDCLASSEX)
  wc\style = #CS_DBLCLKS
  wc\lpfnWndProc = @WndProc()
  wc\hInstance = hInstance
  wc\hCursor = LoadCursor_(0, #IDC_CROSS)
  hBrush = CreateSolidBrush_(BGColor)
  wc\hbrBackground = hBrush
  wc\lpszClassName = @"MyPaintBox"
  If RegisterClassEx_(@wc)=0:ProcedureReturn 0:EndIf
  hWnd = CreateWindowEx_(#Null, "MyPaintBox", "", #WS_CHILD|#WS_CLIPSIBLINGS|#WS_VISIBLE, x, y, width, height, TB_GetGadgetParent(), Gadget, hInstance, 0)
  If hWnd=0:ProcedureReturn 0:EndIf
  *mgi.MyGadgetInfo = HeapAlloc_(GetProcessHeap_(), 0, SizeOf(MyGadgetInfo))
  *mgi\width = width
  *mgi\height = height
  *mgi\FColor = FColor
  hDC = GetDC_(hWnd)
  *mgi\mDC = CreateCompatibleDC_(hDC)
  *mgi\hBrush = hBrush
  *mgi\hOldBrush = SelectObject_(*mgi\mDC, *mgi\hBrush)
  bmi.BITMAPINFOHEADER
  bmi\biSize = SizeOf(BITMAPINFOHEADER)
  bmi\biWidth = width
  bmi\biHeight = height
  bmi\biPlanes = 1
  bmi\biBitCount = 32
  bmi\biCompression = #BI_RGB 
  *mgi\hBitmap = CreateDIBSection_(hDC, @bmi, #DIB_RGB_COLORS, @vBits.l, 0, 0)
  *mgi\hOldBitmap = SelectObject_(*mgi\mDC, *mgi\hBitmap)
  *mgi\hOldCursor = GetClassLongPtr_(hWnd, #GCL_HCURSOR)
  SetWindowLongPtr_(hWnd, #GWL_USERDATA, *mgi)
  rc.RECT
  rc\left = 0
  rc\top = 0
  rc\right = width
  rc\bottom = height
  FillRect_(*mgi\mDC, @rc, *mgi\hBrush)
  BitBlt_(hDC, 0, 0, width, height, *mgi\mDC, 0, 0, #SRCCOPY)
  ReleaseDC_(hWnd, hDC)
  *mgi\PenWidth = PenWidth
  *mgi\hPen = CreatePen_(#PS_SOLID, PenWidth, *mgi\FColor)
  *mgi\hOldPen = SelectObject_(*mgi\mDC, *mgi\hPen)
  ShowWindow_(hWnd, #SW_SHOWNORMAL)
  UpdateWindow_(hWnd)
  VT\FreeGadget = @MyFreeGadget()
  VT\GetGadgetState = @MyGetGadgetState()
  VT\SetGadgetState = @MySetGadgetState()
  ;TB_SetGadget(Gadget, hWnd, @VT)
  ProcedureReturn TB_RegisterGadget(Gadget, hWnd, @VT)
  ;ProcedureReturn hWnd
EndProcedure

; IDE Options = PureBasic 4.30 (Windows - x64)
; Folding = -