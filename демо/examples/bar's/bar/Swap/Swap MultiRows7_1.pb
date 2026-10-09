EnableExplicit

Structure CustomTab
  Title$ : X.i : Y.i : Width.i : Height.i : Row.i : ContainerID.i : IsHovered.a
EndStructure

Structure MultiRowTabControl
  CanvasID.i : FontID.i : *active.CustomTab : TabHeight.i : PaddingX.i : BgColor.l : CloseHovered.a : List Tabs.CustomTab()
EndStructure

Global TabBar.MultiRowTabControl, Slant = 20, bottom_size = 5

Procedure AddCustomTab(*Control.MultiRowTabControl, Title$, WindowID, CanvasHeight, ImageID.i=0, TabColor.l=0)
  AddElement(*Control\Tabs()) : *Control\Tabs()\Title$ = Title$
  If Not TabColor : TabColor = RGB(Random(50)+200, Random(50)+200, Random(50)+200) : EndIf
  *Control\Tabs()\ContainerID = ContainerGadget(#PB_Any, 0, CanvasHeight, WindowWidth(WindowID), WindowHeight(WindowID)-CanvasHeight, #PB_Container_BorderLess)
  SetGadgetColor(*Control\Tabs()\ContainerID, #PB_Gadget_BackColor, TabColor) : CloseGadgetList()
  If *Control\active = 0 : *Control\active = @*Control\Tabs() : HideGadget(*Control\Tabs()\ContainerID, #False) : Else : HideGadget(*Control\Tabs()\ContainerID, #True) : EndIf
EndProcedure

Procedure.i RecalculateTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID), CurrentX = 4, CurrentY = 6, CurrentRow = 0, MaxHeight = 0, MaxWidth = CanvasW - 4
  Protected i.i, k.i, StartIdx.i, EndIdx.i, TotalRowWidth.i, ExtraSpace.i, AddPixels.i, Remainder.i, TabCount = ListSize(*Control\Tabs())
  If TabCount = 0 : ProcedureReturn *Control\TabHeight + bottom_size : EndIf
  Dim *RowTabs.CustomTab(TabCount - 1)
  If StartDrawing(CanvasOutput(*Control\CanvasID))
      DrawingFont(*Control\FontID)
   i = 0 : ForEach *Control\Tabs() : *RowTabs(i) = @*Control\Tabs() : *RowTabs(i)\Height = *Control\TabHeight : *RowTabs(i)\Width = TextWidth(*RowTabs(i)\Title$) + (*Control\PaddingX * 2) + (Slant * 2) + 16 : i + 1 : Next
  StartIdx = 0 : CurrentX = 4
  For i = 0 To TabCount - 1
    Protected TabW = *RowTabs(i)\Width
    If CurrentX + TabW > MaxWidth And i > StartIdx
      EndIdx = i - 1 : TotalRowWidth = 4
      For k = StartIdx To EndIdx : TotalRowWidth + *RowTabs(k)\Width : If k < EndIdx : TotalRowWidth - (Slant * 4 / 3) : EndIf : Next
      ExtraSpace = MaxWidth - TotalRowWidth
      Protected TabsInRow = (EndIdx - StartIdx) + 1
      If ExtraSpace > 0 And TabsInRow > 0
        AddPixels = ExtraSpace / TabsInRow : Remainder = ExtraSpace % TabsInRow
        For k = StartIdx To EndIdx : *RowTabs(k)\Width + AddPixels : If Remainder > 0 : *RowTabs(k)\Width + 1 : Remainder - 1 : EndIf : Next
      EndIf
      Protected TempX = 4
      For k = StartIdx To EndIdx : *RowTabs(k)\X = TempX : *RowTabs(k)\Y = CurrentY : *RowTabs(k)\Row = CurrentRow : If CurrentY + *RowTabs(k)\Height > MaxHeight : MaxHeight = CurrentY + *RowTabs(k)\Height : EndIf : TempX + *RowTabs(k)\Width - (Slant * 4 / 3) : Next
      CurrentRow + 1 : CurrentY + *Control\TabHeight + 2 : CurrentX = 4 : StartIdx = i
    EndIf
    CurrentX + *RowTabs(i)\Width - (Slant * 4 / 3)
  Next
  CurrentX = 4
  For k = StartIdx To TabCount - 1 : *RowTabs(k)\X = CurrentX : *RowTabs(k)\Y = CurrentY : *RowTabs(k)\Row = CurrentRow : If CurrentY + *RowTabs(k)\Height > MaxHeight : MaxHeight = CurrentY + *RowTabs(k)\Height : EndIf : CurrentX + *RowTabs(k)\Width - (Slant * 4 / 3) : Next
     StopDrawing()
   EndIf
   ProcedureReturn MaxHeight + bottom_size
EndProcedure

Declare RedrawTabs(*Control.MultiRowTabControl)

Procedure CloseCustomTab(*Control.MultiRowTabControl, *TabToClose.CustomTab, WindowID.i)
  ChangeCurrentElement(*Control\Tabs(), *TabToClose) : If IsGadget(*TabToClose\ContainerID) : FreeGadget(*TabToClose\ContainerID) : EndIf
  If *Control\active = *TabToClose
    If PreviousElement(*Control\Tabs()) : *Control\active = @*Control\Tabs() : Else : NextElement(*Control\Tabs())
      If NextElement(*Control\Tabs()) : *Control\active = @*Control\Tabs() : PreviousElement(*Control\Tabs()) : Else : *Control\active = 0 : EndIf
    EndIf
  EndIf
  DeleteElement(*Control\Tabs()) : If *Control\active <> 0 : HideGadget(*Control\active\ContainerID, #False) : EndIf
  ResizeGadget(*Control\CanvasID, 0, 0, WindowWidth(WindowID), #PB_Ignore) : Protected NewHeight = RecalculateTabs(*Control)
  ResizeGadget(*Control\CanvasID, #PB_Ignore, #PB_Ignore, #PB_Ignore, NewHeight)
  ForEach *Control\Tabs() : ResizeGadget(*Control\Tabs()\ContainerID, 0, NewHeight, WindowWidth(WindowID), WindowHeight(WindowID) - NewHeight) : Next
  *Control\CloseHovered = 0 : RedrawTabs(*Control)
EndProcedure

Procedure DrawOldChromeTab(X, Y, W, H, IsActive, ActiveColor.l, NonActiveColor.l = -1, OuterBorderColor.l = -1, InnerHighlightColor.l = -1)
  Protected i, dy, LocalSlant = Slant, CurrentColor.l, BaseR.a, BaseG.a, BaseB.a, Factor.f, CurrentSlant.f, R.a, G.a, B.a
  If LocalSlant > H: LocalSlant = H: EndIf
  If IsActive : CurrentColor = ActiveColor : Else : If NonActiveColor = -1 : NonActiveColor = RGB(215, 225, 240) : EndIf : CurrentColor = NonActiveColor : EndIf
  If OuterBorderColor = -1 : OuterBorderColor = RGB(Red(CurrentColor) * 0.6, Green(CurrentColor) * 0.6, Blue(CurrentColor) * 0.6) : EndIf
  If InnerHighlightColor = -1 : R = Red(CurrentColor) : G = Green(CurrentColor) : B = Blue(CurrentColor) : InnerHighlightColor = RGB(R + (255 - R) * 0.3, G + (255 - G) * 0.3, B + (255 - B) * 0.3) : EndIf
  If IsActive : FrontColor(ActiveColor) : For dy = 0 To H - 1 : CurrentSlant = LocalSlant * (1.0 - (dy / H)) : LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy) : Next
  Else : BaseR = Red(NonActiveColor) : BaseG = Green(NonActiveColor) : BaseB = Blue(NonActiveColor)
    For dy = 0 To H - 1 : Factor = dy / (H - 1) : R = BaseR + ((BaseR - 25) - BaseR) * Factor : G = BaseG + ((BaseG - 20) - BaseG) * Factor : B = BaseB + ((BaseB - 20) - BaseB) * Factor : CurrentSlant = LocalSlant * (1.0 - (dy / H)) : LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy, RGB(R, G, B)) : Next
  EndIf : FrontColor(OuterBorderColor) : LineXY(X, Y + H - 1, X + LocalSlant, Y) : LineXY(X + LocalSlant, Y, X + W - LocalSlant, Y) : LineXY(X + W - LocalSlant, Y, X + W, Y + H - 1)
  If IsActive : FrontColor(InnerHighlightColor) : LineXY(X + 2, Y + H - 1, X + LocalSlant + 1, Y + 1) : LineXY(X + LocalSlant + 1, Y + 1, X + W - LocalSlant - 1, Y + 1) : LineXY(X + W - LocalSlant - 1, Y + 1, X + W - 2, Y + H - 1) : Else : LineXY(X, Y + H - 1, X + W, Y + H - 1) : EndIf 
EndProcedure

Procedure RedrawTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID), CanvasH = GadgetHeight(*Control\CanvasID), TabColor.l, CanvasBgColor.l, NonActiveColor.l, NABaseR.i, NABaseG.i, NABaseB.i, TxtW.i, ContentW.i, StartX.i, TextBgR.i, TextBgG.i, TextBgB.i, TextColor.l, CloseX.i, CloseY.i
  If *Control\BgColor <> 0 : CanvasBgColor = *Control\BgColor : Else : CanvasBgColor = RGB(180, 195, 215) : EndIf
  If StartDrawing(CanvasOutput(*Control\CanvasID)) : Box(0, 0, CanvasW, CanvasH, CanvasBgColor) : DrawingFont(*Control\FontID)
    LineXY(0, CanvasH - 1, CanvasW, CanvasH - 1, RGB(Red(CanvasBgColor) * 0.7, Green(CanvasBgColor) * 0.7, Blue(CanvasBgColor) * 0.7))
    ForEach *Control\Tabs() : If @*Control\Tabs() <> *Control\active : NABaseR = Red(CanvasBgColor) + 25 : NABaseG = Green(CanvasBgColor) + 20 : NABaseB = Blue(CanvasBgColor) + 20
        If *Control\Tabs()\IsHovered : NABaseR + 30 : NABaseG + 30 : NABaseB + 30 : EndIf : If NABaseR > 255 : NABaseR = 255 : EndIf : If NABaseG > 255 : NABaseG = 255 : EndIf : If NABaseB > 255 : NABaseB = 255 : EndIf : NonActiveColor = RGB(NABaseR, NABaseG, NABaseB)
        DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False, 0, NonActiveColor)
        TxtW = TextWidth(*Control\Tabs()\Title$) : ContentW = TxtW + 16 : StartX = *Control\Tabs()\X + (*Control\Tabs()\Width - ContentW) / 2
        TextBgR = NABaseR - 5 : TextBgG = NABaseG - 4 : TextBgB = NABaseB - 4 : TextColor = RGB(Red(CanvasBgColor) * 0.3, Green(CanvasBgColor) * 0.3, Blue(CanvasBgColor) * 0.3)
        DrawText(StartX, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, TextColor, RGB(TextBgR, TextBgG, TextBgB))
        CloseX = *Control\Tabs()\X + *Control\Tabs()\Width - Slant - 14 : CloseY = *Control\Tabs()\Y + (*Control\Tabs()\Height - 8) / 2
        If *Control\Tabs()\IsHovered And *Control\CloseHovered : Circle(CloseX + 4, CloseY + 4, 7, RGB(NABaseR - 30, NABaseG - 30, NABaseB - 30)) : LineXY(CloseX, CloseY, CloseX + 8, CloseY + 8, RGB(255, 255, 255)) : LineXY(CloseX + 8, CloseY, CloseX, CloseY + 8, RGB(255, 255, 255)) : Else : LineXY(CloseX, CloseY, CloseX + 8, CloseY + 8, RGB(140, 150, 160)) : LineXY(CloseX + 8, CloseY, CloseX, CloseY + 8, RGB(140, 150, 160)) : EndIf
      EndIf : Next
    If *Control\active <> 0 : TabColor = GetGadgetColor(*Control\active\ContainerID, #PB_Gadget_BackColor) : If TabColor = -1 : TabColor = RGB(255, 255, 255) : EndIf
      DrawOldChromeTab(*Control\active\X, *Control\active\Y, *Control\active\Width, *Control\active\Height + bottom_size, #True, TabColor)
      TxtW = TextWidth(*Control\active\Title$) : ContentW = TxtW + 16 : StartX = *Control\active\X + (*Control\active\Width - ContentW) / 2
      DrawText(StartX, *Control\active\Y + 6, *Control\active\Title$, RGB(0, 0, 0), TabColor) 
      CloseX = *Control\active\X + *Control\active\Width - Slant - 14 
      CloseY = *Control\active\Y + (*Control\active\Height - 8) / 2
      If *Control\CloseHovered 
         Circle(CloseX + 4, CloseY + 4, 7, RGB(240, 70, 70)) 
         LineXY(CloseX, CloseY, CloseX + 8, CloseY + 8, RGB(255, 255, 255)) 
         LineXY(CloseX + 8, CloseY, CloseX, CloseY + 8, RGB(255, 255, 255)) 
      Else 
         LineXY(CloseX, CloseY, CloseX + 8, CloseY + 8, RGB(160, 50, 50)) 
         LineXY(CloseX + 8, CloseY, CloseX, CloseY + 8, RGB(160, 50, 50)) 
      EndIf
    EndIf : StopDrawing() : EndIf
EndProcedure

Procedure HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX), MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY), LocalSlant = Slant, InsideTab.i, RelX.i, RelY.i, *HoveredTab.CustomTab = 0, NeedRedraw.i = #False, WindowID = 0, EType = EventType(), IsOverClose.a = 0, CloseX.i, ShouldHover.i
  If EType = #PB_EventType_MouseMove Or EType = #PB_EventType_LeftButtonDown
    If ListSize(*Control\Tabs()) > 0 : LastElement(*Control\Tabs())
      Repeat : InsideTab = #False : If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height : If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width : RelX = MX - *Control\Tabs()\X : RelY = MY - *Control\Tabs()\Y
              If LocalSlant > *Control\Tabs()\Height: LocalSlant = *Control\Tabs()\Height: EndIf
              If RelX < LocalSlant : If RelX >= LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height)) : InsideTab = #True : EndIf : ElseIf RelX > *Control\Tabs()\Width - LocalSlant : If RelX <= *Control\Tabs()\Width - (LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height))) : InsideTab = #True : EndIf : Else : InsideTab = #True : EndIf
            EndIf : EndIf : If InsideTab : *HoveredTab = @*Control\Tabs() : Break : EndIf
      Until PreviousElement(*Control\Tabs()) = 0 : EndIf
      If *HoveredTab <> 0 : CloseX = *HoveredTab\X + *HoveredTab\Width - LocalSlant - 14 
         If MX >= CloseX - 2 And MX <= CloseX + 10 
            If MY >= *HoveredTab\Y + (*HoveredTab\Height - 12)/2 And MY <= *HoveredTab\Y + (*HoveredTab\Height + 12)/2 
               IsOverClose = 1 
            EndIf 
         EndIf 
      EndIf
    If EType = #PB_EventType_LeftButtonDown And *HoveredTab <> 0 : If IsOverClose : CloseCustomTab(*Control, *HoveredTab, WindowID) : Else : If *Control\active <> *HoveredTab : If *Control\active <> 0 : HideGadget(*Control\active\ContainerID, #True) : EndIf : *Control\active = *HoveredTab : HideGadget(*Control\active\ContainerID, #False) : *Control\CloseHovered = 0 : NeedRedraw = #True : EndIf : EndIf
    ElseIf EType = #PB_EventType_MouseMove : If *Control\CloseHovered <> IsOverClose : *Control\CloseHovered = IsOverClose : NeedRedraw = #True : EndIf
      ForEach *Control\Tabs() : If @*Control\Tabs() = *Control\active : If *Control\Tabs()\IsHovered <> 0 : *Control\Tabs()\IsHovered = 0 : NeedRedraw = #True : EndIf : Else : ShouldHover = 0 : If @*Control\Tabs() = *HoveredTab : ShouldHover = 1 : EndIf : If *Control\Tabs()\IsHovered <> ShouldHover : *Control\Tabs()\IsHovered = ShouldHover : NeedRedraw = #True : EndIf : EndIf : Next
    EndIf : If NeedRedraw : RedrawTabs(*Control) : EndIf
  ElseIf EType = #PB_EventType_MouseLeave : *Control\CloseHovered = 0 : ForEach *Control\Tabs() : If *Control\Tabs()\IsHovered <> 0 : *Control\Tabs()\IsHovered = 0 : NeedRedraw = #True : EndIf : Next : If NeedRedraw : RedrawTabs(*Control) : EndIf : EndIf
EndProcedure

Define Event, WindowW = 650, WindowH = 350, RealCanvasHeight
If OpenWindow(0, 0, 0, WindowW, WindowH, "Monolithic Multi-Row Chrome Canvas Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   With TabBar 
      \CanvasID = CanvasGadget(#PB_Any, 0, 0, WindowW, 40) 
      \FontID = LoadFont(0, "Tahoma", 9) 
      \TabHeight = 29 
      \PaddingX = 6 
      \BgColor = RGB(180, 195, 215) 
   EndWith
  AddCustomTab(TabBar, "Главная панель", 0, 40) : AddCustomTab(TabBar, "Настройки", 0, 40) : AddCustomTab(TabBar, "База данных системы", 0, 40) : AddCustomTab(TabBar, "Логирование процессов", 0, 40) : AddCustomTab(TabBar, "О программе", 0, 40)
  ResizeGadget(TabBar\CanvasID, 0, 0, WindowWidth(0), #PB_Ignore) : RealCanvasHeight = RecalculateTabs(TabBar) : ResizeGadget(TabBar\CanvasID, #PB_Ignore, #PB_Ignore, #PB_Ignore, RealCanvasHeight)
  ForEach TabBar\Tabs() : ResizeGadget(TabBar\Tabs()\ContainerID, 0, RealCanvasHeight, WindowWidth(0), WindowHeight(0) - RealCanvasHeight) : Next : RedrawTabs(TabBar)
  Repeat : Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget : If EventGadget() = TabBar\CanvasID : HandleTabsEvents(TabBar) : EndIf
      Case #PB_Event_SizeWindow : ResizeGadget(TabBar\CanvasID, 0, 0, WindowWidth(0), #PB_Ignore) : RealCanvasHeight = RecalculateTabs(TabBar) : ResizeGadget(TabBar\CanvasID, #PB_Ignore, #PB_Ignore, #PB_Ignore, RealCanvasHeight)
        ForEach TabBar\Tabs() : ResizeGadget(TabBar\Tabs()\ContainerID, 0, RealCanvasHeight, WindowWidth(0), WindowHeight(0) - RealCanvasHeight) : Next : RedrawTabs(TabBar)
      Case #PB_Event_CloseWindow : End
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 128
; FirstLine = 113
; Folding = ---------
; EnableXP
; DPIAware