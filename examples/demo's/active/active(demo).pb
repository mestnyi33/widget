IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  
  Global.i gEvent, gQuit
  Global *this, *root, NewMap w_list.i()
  
  Procedure Widget_Handler()
    Protected EventWidget.i = EventWidget( ),
              EventType.i = WidgetEvent( )\type,
              EventItem.i = WidgetEvent( )\item, 
              EventData.i = WidgetEvent( )\data
    
    Select EventType
      Case #__Event_MouseEnter
        ; bug in mac os
        If GetActiveGadget() <> EventGadget()
          SetActiveGadget(EventGadget())
        EndIf
       
      Case #__Event_Focus   
        If GetType(EventWidget) > 0
          Debug "Focus "+ GetData(EventWidget)
        Else
          Debug "Active "+ GetData(EventWidget)
        EndIf
        
      Case #__Event_LostFocus 
        If GetType(EventWidget) > 0
          Debug " LostFocus "+ GetData(EventWidget) 
        Else
          Debug " DeActive "+ GetData(EventWidget)
        EndIf
        
      Case #__Event_Repaint
        ; draw active window focused frame
        If GetActive( ) = EventWidget
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, width(EventWidget), height(EventWidget), $FFFF00FF)
        EndIf
        
        ; draw active gadget focused frame
        If GetGadget( GetActive( ) ) = EventWidget
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, width(EventWidget), height(EventWidget), $FFFFFF00)
        EndIf
        
    EndSelect
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    w_list(Hex(110)) = Open(OpenWindow(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu)) : SetData(w_list(Hex(110)), 110)
    SetWindowTitle(GetWindow(Root()), "Window_110") 
    ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
    ;       w_list(Hex(110)) = Window(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
    w_list(Hex(111)) = String(10, 10, 180, 85, "String_111") : SetData(w_list(Hex(111)), 111)
    w_list(Hex(112)) = String(10, 105, 180, 85, "String_112") : SetData(w_list(Hex(112)), 112) 
    
    ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    Bind(#PB_All, @Widget_Handler())
    Bind( #PB_Default, #PB_Default )
    ReDraw(Root())
  EndProcedure
  
  Procedure Window_1()
    w_list(Hex(110)) = Open(OpenWindow(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu)) : SetData(w_list(Hex(110)), 110)
    SetWindowTitle(GetWindow(Root()), "Window_110") 
    ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
    ;       w_list(Hex(110)) = Window(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
    w_list(Hex(111)) = String(10, 10, 180, 85, "String_111") : SetData(w_list(Hex(111)), 111)
    w_list(Hex(112)) = String(10, 105, 180, 85, "String_112") : SetData(w_list(Hex(112)), 112) 
    
    ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    Bind(#PB_All, @Widget_Handler())
    Bind( #PB_Default, #PB_Default )
    ReDraw(Root())
    ;       
    w_list(Hex(120)) = Open(OpenWindow(#PB_Any, 160, 120, 200, 200, "Window_120", #PB_Window_SystemMenu)) : SetData(w_list(Hex(120)), 120)
    ;       Open(OpenWindow(-1, 160, 120, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
    ;       w_list(Hex(120)) = Window(0, 0, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
    w_list(Hex(121)) = String(10, 10, 180, 85, "String_121") : SetData(w_list(Hex(121)), 121)
    w_list(Hex(122)) = String(10, 105, 180, 85, "String_122") : SetData(w_list(Hex(122)), 122)
    
    ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    Bind(#PB_All, @Widget_Handler())
    Bind( #PB_Default, #PB_Default )
    ReDraw(Root())
    
    w_list(Hex(130)) = Open(OpenWindow(#PB_Any, 220, 140, 200, 200, "Window_130")) : SetData(w_list(Hex(130)), 130)
    ;       Open(OpenWindow(-1, 220, 140, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
    ;       w_list(Hex(130)) = Window(0, 0, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
    w_list(Hex(131)) = String(10, 10, 180, 85, "String_131") : SetData(w_list(Hex(131)), 131)
    w_list(Hex(132)) = String(10, 105, 180, 85, "String_132") : SetData(w_list(Hex(132)), 132)
    
    ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    Bind(#PB_All, @Widget_Handler())
    Bind( #PB_Default, #PB_Default )
    ReDraw(Root())
  EndProcedure
  
  Procedure Window_2()
    If OpenWindow(0, 0, 0, 830, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      w_list(Hex(10)) = Open(OpenWindow(0, 10,10, 400, 550, "", #__flag_BorderLess)) : SetData(w_list(Hex(10)), 10)
      If w_list(Hex(10))
        w_list(Hex(110)) = Window(100, 100, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
        w_list(Hex(111)) = String(10, 10, 180, 85, "String_111") : SetData(w_list(Hex(111)), 111)
        w_list(Hex(112)) = String(10, 105, 180, 85, "String_112") : SetData(w_list(Hex(112)), 112) 
        
        w_list(Hex(120)) = Window(160, 120, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
        w_list(Hex(121)) = String(10, 10, 180, 85, "String_121") : SetData(w_list(Hex(121)), 121)
        w_list(Hex(122)) = String(10, 105, 180, 85, "String_122") : SetData(w_list(Hex(122)), 122)
        
        w_list(Hex(130)) = Window(220, 140, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
        w_list(Hex(131)) = String(10, 10, 180, 85, "String_131") : SetData(w_list(Hex(131)), 131)
        w_list(Hex(132)) = String(10, 105, 180, 85, "String_132") : SetData(w_list(Hex(132)), 132)
        
        ;         SetActive(w_list(Hex(22)))
        ;         SetActive(w_list(Hex(2)))
        
        Bind(#PB_All, @Widget_Handler())
        Bind( #PB_Default, #PB_Default )
        ReDraw(Root())
      EndIf
      
      Debug ""
      
      w_list(Hex(20)) = Open(OpenWindow(0, 420,10, 400, 550, "", #__flag_BorderLess)) : SetData(w_list(Hex(20)), 20)
      If w_list(Hex(20))
        w_list(Hex(140)) = Window(100, 100, 200, 200, "Window_140", #PB_Window_SystemMenu) : SetData(w_list(Hex(140)), 140)
        w_list(Hex(141)) = String(10, 10, 180, 85, "String_141") : SetData(w_list(Hex(141)), 141)
        w_list(Hex(142)) = String(10, 105, 180, 85, "String_142") : SetData(w_list(Hex(142)), 142) 
        
        w_list(Hex(150)) = Window(160, 120, 200, 200, "Window_150", #PB_Window_SystemMenu) : SetData(w_list(Hex(150)), 150)
        w_list(Hex(151)) = String(10, 10, 180, 85, "String_151") : SetData(w_list(Hex(151)), 151)
        w_list(Hex(152)) = String(10, 105, 180, 85, "String_152") : SetData(w_list(Hex(152)), 152)
        
        w_list(Hex(160)) = Window(220, 140, 200, 200, "Window_160", #PB_Window_SystemMenu) : SetData(w_list(Hex(160)), 160)
        w_list(Hex(161)) = String(10, 10, 180, 85, "String_161") : SetData(w_list(Hex(161)), 161)
        w_list(Hex(162)) = String(10, 105, 180, 85, "String_162") : SetData(w_list(Hex(162)), 162)
        
        ;         SetActive(w_list(Hex(1022)))
        ;         SetActive(w_list(Hex(102)))
        
        Bind(#PB_All, @Widget_Handler())
        Bind( #PB_Default, #PB_Default )
        ReDraw(Root())
      EndIf
      
      w_list(Hex(210)) = Open(OpenWindow(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu)) : SetData(w_list(Hex(210)), 210)
      SetWindowTitle(GetWindow(Root()), "Window_210") 
      ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(210)) = Window(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(210)), 110)
      w_list(Hex(211)) = String(10, 10, 180, 85, "String_211") : SetData(w_list(Hex(211)), 211)
      w_list(Hex(212)) = String(10, 105, 180, 85, "String_212") : SetData(w_list(Hex(212)), 212) 
      
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      
      w_list(Hex(220)) = Open(OpenWindow(#PB_Any, 160, 120, 200, 200, "Window_220", #PB_Window_SystemMenu)) : SetData(w_list(Hex(220)), 220)
      ;       Open(OpenWindow(-1, 160, 120, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(220)) = Window(0, 0, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(220)), 120)
      w_list(Hex(221)) = String(10, 10, 180, 85, "String_221") : SetData(w_list(Hex(221)), 221)
      w_list(Hex(222)) = String(10, 105, 180, 85, "String_222") : SetData(w_list(Hex(222)), 222)
      
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      
      w_list(Hex(230)) = Open(OpenWindow(#PB_Any, 220, 140, 200, 200, "Window_230")) : SetData(w_list(Hex(230)), 230)
      ;       Open(OpenWindow(-1, 220, 140, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(230)) = Window(0, 0, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(230)), 130)
      w_list(Hex(231)) = String(10, 10, 180, 85, "String_231") : SetData(w_list(Hex(231)), 231)
      w_list(Hex(232)) = String(10, 105, 180, 85, "String_232") : SetData(w_list(Hex(232)), 232)
      
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Procedure Window_3()
    If OpenWindow(0, 0, 0, 900, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      w_list(Hex(-1)) = Open(OpenWindow(0, 10,10, 880, 550, "")) : SetData(w_list(Hex(-1)), -1)
      
      If w_list(Hex(-1))
        w_list(Hex(100)) = Window(520, 140, 200+2, 260+26+2, "Window_100", #PB_Window_ScreenCentered) : SetData(w_list(Hex(100)), 100)
        w_list(Hex(500)) = Panel(0,0, 200+2, 260+26+2)
        AddItem(w_list(Hex(500)),-1,"Panel")
        
        w_list(Hex(101)) = Button(10, 10, 180, 20, "101 Active window - 0") : SetData(w_list(Hex(101)), 101)
        w_list(Hex(102)) = Button(10, 35, 180, 20, "102 Focus gadget - 1") : SetData(w_list(Hex(102)), 102)
        w_list(Hex(103)) = Button(10, 60, 180, 20, "103 Focus gadget - 2") : SetData(w_list(Hex(103)), 103)
        
        w_list(Hex(104)) = Button(10, 85+10, 180, 20, "104 Active window - 10") : SetData(w_list(Hex(104)), 104)
        w_list(Hex(105)) = Button(10, 85+35, 180, 20, "105 Focus gadget - 11") : SetData(w_list(Hex(105)), 105)
        w_list(Hex(106)) = Button(10, 85+60, 180, 20, "106 Focus gadget - 12") : SetData(w_list(Hex(106)), 106)
        
        w_list(Hex(107)) = Button(10, 85+85+10, 180, 20, "107 Active window - 20") : SetData(w_list(Hex(107)), 107)
        w_list(Hex(108)) = Button(10, 85+85+35, 180, 20, "108 Focus gadget - 21") : SetData(w_list(Hex(108)), 108)
        w_list(Hex(109)) = Button(10, 85+85+60, 180, 20, "109 Focus gadget - 22") : SetData(w_list(Hex(109)), 109)
        CloseList()
        
        w_list(Hex(0)) = Window(100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu) : SetData(w_list(Hex(0)), 0)
        w_list(Hex(1)) = String(10, 10, 180, 85, "String_1") : SetData(w_list(Hex(1)), 1)
        w_list(Hex(2)) = String(10, 105, 180, 85, "String_2") : SetData(w_list(Hex(2)), 2) 
        
        w_list(Hex(10)) = Window(160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu) : SetData(w_list(Hex(10)), 10)
        w_list(Hex(11)) = String(10, 10, 180, 85, "String_11") : SetData(w_list(Hex(11)), 11)
        w_list(Hex(12)) = String(10, 105, 180, 85, "String_12") : SetData(w_list(Hex(12)), 12)
        
        w_list(Hex(20)) = Window(220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu) : SetData(w_list(Hex(20)), 20)
        w_list(Hex(21)) = String(10, 10, 180, 85, "String_21") : SetData(w_list(Hex(21)), 21)
        w_list(Hex(22)) = String(10, 105, 180, 85, "String_22") : SetData(w_list(Hex(22)), 22)
        
        SetActive(w_list(Hex(22)))
        SetActive(w_list(Hex(2)))
        
        Bind(#PB_All, @Widget_Handler());, w_list(Hex(22)))
        Bind( #PB_Default, #PB_Default )
        ReDraw(Root())
      EndIf
      
      Debug "-----"
      
      w_list(Hex(110)) = Open(OpenWindow(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu)) : SetData(w_list(Hex(110)), 110)
      SetWindowTitle(GetWindow(Root()), "Window_110") 
      ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(110)) = Window(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
      w_list(Hex(111)) = String(10, 10, 180, 85, "String_111") : SetData(w_list(Hex(111)), 111)
      w_list(Hex(112)) = String(10, 105, 180, 85, "String_112") : SetData(w_list(Hex(112)), 112) 
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      ;       
      w_list(Hex(120)) = Open(OpenWindow(#PB_Any, 160, 120, 200, 200, "Window_120", #PB_Window_SystemMenu)) : SetData(w_list(Hex(120)), 120)
      ;       Open(OpenWindow(-1, 160, 120, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(120)) = Window(0, 0, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
      w_list(Hex(121)) = String(10, 10, 180, 85, "String_121") : SetData(w_list(Hex(121)), 121)
      w_list(Hex(122)) = String(10, 105, 180, 85, "String_122") : SetData(w_list(Hex(122)), 122)
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      
      w_list(Hex(130)) = Open(OpenWindow(#PB_Any, 220, 140, 200, 200, "Window_130")) : SetData(w_list(Hex(130)), 130)
      ;       Open(OpenWindow(-1, 220, 140, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(130)) = Window(0, 0, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
      w_list(Hex(131)) = String(10, 10, 180, 85, "String_131") : SetData(w_list(Hex(131)), 131)
      w_list(Hex(132)) = String(10, 105, 180, 85, "String_132") : SetData(w_list(Hex(132)), 132)
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(#PB_All, @Widget_Handler())
      Bind( #PB_Default, #PB_Default )
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  
  Window_1()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventType()
          Case #__Event_LeftClick
            Debug " --- "
            *root = GetGadgetData(EventGadget())
            ;*this = from(*root, GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX), GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY))
            
            If *this
              Select GetData(*this)
                Case 101
                  SetActive(w_list(Hex(0)))
                Case 102
                  SetActive(w_list(Hex(1)))
                Case 103
                  SetActive(w_list(Hex(2)))
                  
                Case 104
                  SetActive(w_list(Hex(10)))
                Case 105
                  SetActive(w_list(Hex(11)))
                Case 106
                  SetActive(w_list(Hex(12)))
                  
                Case 107
                  SetActive(w_list(Hex(20)))
                  
                Case 108
                  SetActive(w_list(Hex(21)))
                Case 109
                  SetActive(w_list(Hex(22)))
              EndSelect
              
             ; ReDraw(*root)
            EndIf
            
        EndSelect
    EndSelect
    
    If root()\repaint
      redraw(root())
    EndIf
    
    ;Repaint()
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP