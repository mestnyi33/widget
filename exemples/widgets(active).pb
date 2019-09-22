IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit
  Global *window, NewMap Widget.i()
  
  Procedure Widget_Handler(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    Select EventType
      Case #PB_EventType_Focus   
        If GetType(EventWidget) =- 1
          Debug "Active "+ GetData(EventWidget)
        Else
          Debug "Focus "+ GetData(EventWidget)
        EndIf
        
      Case #PB_EventType_LostFocus 
        If GetType(EventWidget) =- 1
          Debug " DeActive "+ GetData(EventWidget) ;Val(StringField(GetText(EventWidget), 2, "_")) ; +\Type +" "+ at +" "+ *This
        Else
          Debug " LostFocus "+ GetData(EventWidget) ;Val(StringField(GetText(EventWidget), 2, "_")) ; +\Type +" "+ at +" "+ *This
        EndIf
    EndSelect
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 900, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      *window = Open(0, 10,10, 880, 550, "")
      
      If *window
        Widget(Hex(100)) = Form(520, 140, 200+2, 260+26+2, "Window_100", #PB_Window_ScreenCentered) : SetData(Widget(Hex(100)), 100)
        Widget(Hex(500)) = Panel(0,0, 200+2, 260+26+2)
        AddItem(Widget(Hex(500)),-1,"Panel")
        
        Widget(Hex(101)) = Button(10, 10, 180, 20, "101 Active window - 0") : SetData(Widget(Hex(101)), 101)
        Widget(Hex(102)) = Button(10, 35, 180, 20, "102 Focus gadget - 1") : SetData(Widget(Hex(102)), 102)
        Widget(Hex(103)) = Button(10, 60, 180, 20, "103 Focus gadget - 2") : SetData(Widget(Hex(103)), 103)
        
        Widget(Hex(104)) = Button(10, 85+10, 180, 20, "104 Active window - 10") : SetData(Widget(Hex(104)), 104)
        Widget(Hex(105)) = Button(10, 85+35, 180, 20, "105 Focus gadget - 11") : SetData(Widget(Hex(105)), 105)
        Widget(Hex(106)) = Button(10, 85+60, 180, 20, "106 Focus gadget - 12") : SetData(Widget(Hex(106)), 106)
        
        Widget(Hex(107)) = Button(10, 85+85+10, 180, 20, "107 Active window - 20") : SetData(Widget(Hex(107)), 107)
        Widget(Hex(108)) = Button(10, 85+85+35, 180, 20, "108 Focus gadget - 21") : SetData(Widget(Hex(108)), 108)
        Widget(Hex(109)) = Button(10, 85+85+60, 180, 20, "109 Focus gadget - 22") : SetData(Widget(Hex(109)), 109)
        CloseList()
        
        Widget(Hex(0)) = Form(100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu) : SetData(Widget(Hex(0)), 0)
        Widget(Hex(1)) = String(10, 10, 180, 85, "String_1") : SetData(Widget(Hex(1)), 1)
        Widget(Hex(2)) = String(10, 105, 180, 85, "String_2") : SetData(Widget(Hex(2)), 2) 
        
        Widget(Hex(10)) = Form(160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu) : SetData(Widget(Hex(10)), 10)
        Widget(Hex(11)) = String(10, 10, 180, 85, "String_11") : SetData(Widget(Hex(11)), 11)
        Widget(Hex(12)) = String(10, 105, 180, 85, "String_12") : SetData(Widget(Hex(12)), 12)
        
        Widget(Hex(20)) = Form(220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu) : SetData(Widget(Hex(20)), 20)
        Widget(Hex(21)) = String(10, 10, 180, 85, "String_21") : SetData(Widget(Hex(21)), 21)
        Widget(Hex(22)) = String(10, 105, 180, 85, "String_22") : SetData(Widget(Hex(22)), 22)
        
        Bind(@Widget_Handler())
        ReDraw(*window)
      EndIf
      
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventType()
          Case #PB_EventType_LeftClick
            Debug ""
            
            Select GetData(from(*window, GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX), GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)))
              Case 101
                SetActive(Widget(Hex(0)))
              Case 102
                SetActive(Widget(Hex(1)))
              Case 103
                SetActive(Widget(Hex(2)))
                
              Case 104
                SetActive(Widget(Hex(10)))
              Case 105
                SetActive(Widget(Hex(11)))
              Case 106
                SetActive(Widget(Hex(12)))
                
              Case 107
                SetActive(Widget(Hex(20)))
                
              Case 108
                SetActive(Widget(Hex(21)))
              Case 109
                SetActive(Widget(Hex(22)))
            EndSelect
            
            ReDraw(*window)
            
        EndSelect
     EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP