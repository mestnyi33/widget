;-TOP
; Comment : New Window with own ClassName
; Author  : ?
; Author  : mk-soft
; Version : v1.01.3
; Create  : 23.12.2012
; Update  : 21.07.2022

Import ""
  PB_Window_ProcessEvent(a,b,c,d)
  PB_Window_Icon
  PB_Window_Cursor
  PB_Window_Objects
  PB_Object_GetOrAllocateID(*Object,id)
EndImport

Procedure OpenClassWindow(Window ,x ,y , Width, Height, Title.s, ClassName.s, Flags= #WS_VISIBLE | #WS_OVERLAPPEDWINDOW, Parent=0)
  Protected r1
  Protected WindowClass.wndclass
  Protected *PB_Object.integer
  Protected hWnd.i
  Protected rc.rect
  
  With WindowClass
    \style          = #CS_HREDRAW | #CS_VREDRAW
    \lpfnWndProc    = @PB_Window_ProcessEvent()
    \hInstance      = GetModuleHandle_(0)
    \hIcon          = PB_Window_Icon
    \hCursor        = PB_Window_Cursor
    \lpszClassName  = @ClassName
    \hbrBackground  = #COLOR_WINDOW
    \cbWndExtra     = 0
    \cbClsExtra     = 0
  EndWith
  
  If RegisterClass_(WindowClass)
    SetRect_(rc, 0, 0, Width, Height)
    AdjustWindowRectEx_(rc , Flags, 0, #WS_EX_WINDOWEDGE)
    If x = #PB_Ignore Or y = #PB_Ignore
      x = #CW_USEDEFAULT
      y = #CW_USEDEFAULT
    EndIf   
    hWnd = CreateWindowEx_(#WS_EX_WINDOWEDGE, ClassName, Title, Flags, x, y, rc\right-rc\left, rc\bottom-rc\top, Parent, 0, GetModuleHandle_(0), 0)
    If hWnd
      *PB_Object = PB_Object_GetOrAllocateID(PB_Window_Objects, Window)
      If *PB_Object
        *PB_Object\i = hWnd
        If Window = #PB_Any
          SetProp_(hWnd, "Pb_WindowID", *PB_Object + 1)
        Else
          SetProp_(hWnd, "Pb_WindowID", Window + 1)
        EndIf
        UseGadgetList(hWnd)
        If Window = #PB_Any
          r1 = *PB_Object
        Else
          r1 = hWnd
        EndIf
      Else
        CloseWindow_(hwnd)
        UnregisterClass_(GetModuleHandle_(0), ClassName)
      EndIf
    Else
      UnregisterClass_(GetModuleHandle_(0), ClassName)
    EndIf
  EndIf
  ProcedureReturn r1
EndProcedure

; ********

;-Test

CompilerIf #PB_Compiler_IsMainFile
  
  ; ----
  #MyWindowClassName = "MyDataWindow#001"
  
  Procedure IsRunning()
    Protected hWnd, state
    
    hWnd = FindWindow_(#MyWindowClassName, 0)
    If hWnd
      ShowWindow_(hWnd, #SW_RESTORE)
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  Procedure Main()
    Protected dx, dy
    
    hMainWnd = OpenClassWindow(0,#PB_Ignore, #PB_Ignore, 400, 200, "My Data Window", #MyWindowClassName)
    
    dx = WindowWidth(0)
    dy = WindowHeight(0)
    
    ListViewGadget(0, 10, 10, dx - 20, dy - 20)
    
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Break
          
      EndSelect
    ForEver
    
  EndProcedure
  
  If Not IsRunning()
    Main()
  EndIf
  
  
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 116
; FirstLine = 38
; Folding = ---
; EnableXP