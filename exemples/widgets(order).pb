IncludePath "../"
XIncludeFile "widgets().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  UseModule constants
  
  Global.i gEvent, gQuit, value, g_canvas, direction, x=10,y=10
  Global *window
  
  ;-
  ; Получить Z-позицию элемента в окне
  Procedure _GetPosition(*This._S_widget, Position=#PB_Default)
    Protected Result.i
    
    With *This
      If *This And \Parent
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        
        Select Position
          Case #PB_List_First  : Result = FirstElement(\Parent\Childrens())
          Case #PB_List_Before : ChangeCurrentElement(\Parent\Childrens(), GetAdress(*This)) : Result = PreviousElement(\Parent\Childrens())
          Case #PB_List_After  : ChangeCurrentElement(\Parent\Childrens(), GetAdress(*This)) : Result = NextElement(\Parent\Childrens())
          Case #PB_List_Last   : Result = LastElement(\Parent\Childrens())
          Default              : Result = GetAdress(*This)
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i _SetPosition(*This._S_widget, Position, *Widget_2 =- 1) ; Ok
    
    With *This
      If *This And \Parent
        ;Debug "Position "+\text\string
        
;         ForEach \Parent\Childrens()
;           If *This = \Parent\Childrens()
;             Break
;           EndIf
;         Next
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        ;Debug "SetPosition "+\Parent\Childrens()\text\string +" "+ ListIndex(\Parent\Childrens())
        
        ChangeCurrentElement(\Parent\Childrens(), GetAdress(*This))
        Debug *This 
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\Parent\Childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\Parent\Childrens()) : MoveElement(\Parent\Childrens(), #PB_List_After, GetAdress(\Parent\Childrens()))
            Case #PB_List_After  : NextElement(\Parent\Childrens())     : MoveElement(\Parent\Childrens(), #PB_List_Before, GetAdress(\Parent\Childrens()))
            Case #PB_List_Last   : MoveElement(\Parent\Childrens(), #PB_List_Last)
          EndSelect
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\Parent\Childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\Parent\Childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
        ;\Parent\Childrens()\Adress = @\Parent\Childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  Procedure Widget_Handler()
    Protected EventWidget.i = *event\widget,
              EventType.i = *event\type,
              EventItem.i = *event\item, 
              EventData.i = *event\data
    Static *After
    
    Select EventType
      Case #PB_EventType_MouseEnter
        ; bug in mac os
        If GetActiveGadget() <> EventGadget()
          SetActiveGadget(EventGadget())
        EndIf
       
      Case #PB_EventType_LeftButtonDown
        *After = _GetPosition(EventWidget, #PB_List_After)
        
        _SetPosition(EventWidget, #PB_List_Last)
        
      Case #PB_EventType_LeftButtonUp
        _SetPosition(EventWidget, #PB_List_Before, *After)
        
      Case #PB_EventType_Repaint
        ; draw active window focused frame
        If GetActive() = EventWidget
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, width(EventWidget), height(EventWidget), $FFFF00FF)
        EndIf
        
        ; draw active gadget focused frame
        If GetGadget(GetActive()) = EventWidget
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, width(EventWidget), height(EventWidget), $FFFFFF00)
        EndIf
        
    EndSelect
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(g_canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      *window = open(0, 10,10, 580, 550)
      g_canvas = getgadget(root())
      SetGadgetAttribute(g_canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      Form(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      Form(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      Form(20, 150, 280, 200, "Window_3") ;, #PB_Flag_AnchorsGadget)
      
      Panel(100, 20, 80, 80) : CloseList() ; "Button_1");, #PB_Flag_AnchorsGadget)
      ScrollArea(130, 80, 80, 80, 0,100,100) : CloseList() ; "Button_2");, #PB_Flag_AnchorsGadget)
      ScrollArea(70, 80, 80, 80, 0,100,100) : CloseList() ; "Button_3") ;, #PB_Flag_AnchorsGadget)
      
      ;Widgets(Hex(2)) = Button(91, 21, 280-2-182, 200-2-42, "Full_"+Str(5))
      
      CloseList()
      
      
      Bind(@Widget_Handler(), root())
       
      redraw(root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----
; EnableXP