EnableExplicit

; --- КОНСТАНТЫ ---
Enumeration
   #SIDE_NONE   = 0
   #SIDE_LEFT   = 1
   #SIDE_TOP    = 2
   #SIDE_RIGHT  = 3
   #SIDE_BOTTOM = 4
EndEnumeration

Enumeration
   #PATH_Z       ; 4 точки
   #PATH_S       ; 6 точек (между блоками)
   #PATH_BYPASS  ; 6 точек (обход снаружи)
EndEnumeration

;-
CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
   Structure POINT
      X.i : Y.i
   EndStructure
   
   Structure RECT
      left.i
      top.i
      right.i
      bottom.i
   EndStructure
CompilerEndIf

Structure PORT Extends POINT
   Side.i : Color.i : Radius.i : Index.i
EndStructure

Structure BLOCK Extends POINT
   w.i : h.i : Color.i : OffX.i : OffY.i 
   ; Счетчики портов: 0-Left, 1-Right, 2-Top, 3-Bottom
   SideCount.i[4] 
   Title.s
   List Ports.PORT()
EndStructure

Structure LINK
   *Block.BLOCK[2] ; Массив указателей на блоки
   *Port.PORT[2]   ; Массив указателей на порты
   
   MidRatio.f      ; центральная ось
   OffsetStart.i   ; вылет от старта
   OffsetEnd.i     ; вылет до финиша
   OffsetMin.i
   
   BypassOffset.i
   BypassSide.i
   
   Type.i
   segment.i
   
   Color.i
   thick.b
   List Path.POINT() ; Список точек маршрута
EndStructure

;-
Global NewList Blocks.BLOCK(), NewList Links.LINK()
Global *EnteredPort.PORT = 0, *EnteredBlock.BLOCK = 0 , *DragBlock.BLOCK = 0
Global *SelectedPort.PORT = 0, *SelectedBlock.BLOCK = 0 
Global *EnteredLink.LINK = 0, *SelectLink.LINK = 0
Global *EnteredPath.POINT = 0, *SelectPath.POINT = 0

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Macro IsMouseOver(mx, my, _ptr_)
   ((mx) >= _ptr_\x And (mx) <= _ptr_\x + _ptr_\w And (my) >= _ptr_\y And (my) <= _ptr_\y + _ptr_\h)
EndMacro

Macro IsMouseOverPort(mx, my, _blk_, _prt_, _dist_)
   (Abs((_blk_\x + _prt_\x) - (mx)) < (_dist_) And Abs((_blk_\y + _prt_\y) - (my)) < (_dist_))
EndMacro

;-
Procedure.i EnteredSide(*B.BLOCK, mx.l, my.l, t.l = 5)
 EndProcedure

;-
Procedure.i EnterPath(mx, my, *L.LINK)
EndProcedure

Procedure AddPath(*L.LINK, X.i, Y.i)
 EndProcedure

Procedure UpdatePath(*L.LINK)
EndProcedure



Procedure MovePath(mx, my, *L.LINK)
EndProcedure
Procedure DrawPath(x1, y1, x2, y2, thick, color)
EndProcedure


;-
; Внутренняя процедура пересчета размеров и позиций
Procedure UpdatePort(*B.BLOCK)
EndProcedure

Procedure RemovePort(*B.BLOCK, *P.PORT)
EndProcedure

Procedure AddPort(*B.BLOCK, side.i, radius.i = 5)
EndProcedure

;-
Procedure RemoveLink(*L.LINK)
EndProcedure

Procedure AddLink( *SelectedBlock.BLOCK, *SelectedPort.PORT, *EnteredBlock.BLOCK, *EnteredPort.PORT, Ratio.f = 0.5, thick.b = 3 )
EndProcedure

Procedure DrawLink(*L.LINK)
EndProcedure


;-
Procedure RemoveBlock(*B.BLOCK)
EndProcedure

Procedure AddBlock(X, Y, Title.s = "Block")
EndProcedure

;-
; --- 1. ВАША ЛОГИКА ОТРИСОВКИ СЕГМЕНТА (вынесена для удобства) ---
; 2. Процедура ОТРИСОВКИ (вызывать в цикле рендера)
Procedure ReDraw(gad)
EndProcedure

;-
Procedure CanvasEvents()
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile
   If OpenWindow(0, 0, 0, 900, 700, "Node Editor Final", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      CanvasGadget(0, 0, 0, 900, 700, #PB_Canvas_Keyboard)
      
      RandomSeed(50)
      
      *SelectedBlock = AddBlock(300, 250, "Source") 
      *EnteredBlock = AddBlock(300, 80, "Target") 
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_LEFT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_RIGHT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_RIGHT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_LEFT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedBlock = 0
      *EnteredBlock = 0
      *SelectedPort = 0
      *EnteredPort = 0
      
      ReDraw(0)
      Repeat : Define Event = WaitWindowEvent() : If Event = #PB_Event_Gadget And EventGadget() = 0 : CanvasEvents() : EndIf : Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 151
; FirstLine = 139
; Folding = -----
; EnableXP
; DPIAware