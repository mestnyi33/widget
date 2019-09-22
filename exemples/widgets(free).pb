IncludePath "../"
XIncludeFile "widgets.pbi"
; 
; Иногда видает ошибку при удалении кнопки
; Fixme - При клике на скролл бар тоже видает ошибку, теперь осталось залипание скролла
;

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit
  
  Procedure.i _Free(*This.Widget_S)
    Protected Result.i
    
    With *This
      If *This
        If \Scroll
          If \Scroll\v
            FreeStructure(\Scroll\v) : \Scroll\v = 0
          EndIf
          If \Scroll\h
            FreeStructure(\Scroll\h)  : \Scroll\h = 0
          EndIf
          FreeStructure(\Scroll) : \Scroll = 0
        EndIf
        
        If \Box
          FreeStructure(\Box) : \Box = 0
        EndIf
        
        If \Image
          FreeStructure(\Image) : \Image = 0
        EndIf
        
        If \Image[1]
          FreeStructure(\Image[1]) : \Image[1] = 0
        EndIf
        
        If \Text
          FreeStructure(\Text) : \Text = 0
        EndIf
        
        FreeStructure(*This) 
        *Value\Active = 0
        *Value\Focus = 0
        
        If \Parent And ListSize(\Parent\Childrens()) : \Parent\CountItems - 1
          ChangeCurrentElement(\Parent\Childrens(), Adress(*This))
          Result = DeleteElement(\Parent\Childrens())
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget_Handler(*This.Widget_S, EventType.i, EventItem.i, EventData.i)
    
    Select EventType
      Case #PB_EventType_LeftButtonDown
        If *This\type>0
          Debug "free - "+ Class(*This\type)
          Free(*This)
        EndIf
        
    EndSelect
    
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo delete widget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "", #PB_Button_Toggle)
      
      Open(0, 10,10, 580, 550);, "h")

      Window(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      Window(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
        Container(30,30,280-60, 200-60)
        Container(20,20,280-60, 200-60)
        Button(100, 20, 80, 80, "Button_1")
        Button(130, 80, 80, 80, "Button_2")
        Button(70, 80, 80, 80, "Button_3")
        CloseList()
        CloseList()
        
      Window(20, 150, 280, 200, "Window_3") ;, #PB_Flag_AnchorsGadget)
      
      Panel(100, 20, 80, 80) : CloseList() ; "Button_1");, #PB_Flag_AnchorsGadget)
      ScrollArea(130, 80, 80, 80, 0,100,100) : CloseList() ; "Button_2");, #PB_Flag_AnchorsGadget)
      ScrollArea(70, 80, 80, 80, 0,100,100) : CloseList() ; "Button_3") ;, #PB_Flag_AnchorsGadget)
      
      Bind(@Widget_Handler())
      ReDraw(Root())
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP