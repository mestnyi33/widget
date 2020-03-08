IncludePath "../"
XIncludeFile "widgets()/bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Bar
  UseModule constants
  UseModule structures
  
  Global NewMap Widgets.i()
  Global.i Canvas_0, gEvent, gQuit, x=10,y=10
  
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure.i _SetAlignment(*This._S_widget, Mode.i, Type.i=1)
      ProcedureReturn SetAlignment(*This._S_widget, Mode.i, Type.i)
    
      With *this
      Select Type
        Case 1 ; widget
          If \parent
            If Not \align
              \align.structures::_s_align = AllocateStructure(structures::_s_align)
            EndIf
            
            If Bool(Mode&#__flag_autoSize=#__flag_autoSize)
              \align\top = Bool(Not Mode&#__align_bottom)
              \align\left = Bool(Not Mode&#__align_right)
              \align\right = Bool(Not Mode&#__align_left)
              \align\bottom = Bool(Not Mode&#__align_top)
              \align\autoSize = 0
              
              ; Auto dock
              Static y2,x2,y1,x1
              Protected width = #PB_Ignore
              Protected height = #PB_Ignore
              
              If \align\left And \align\right
                \x = x2
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              If \align\top And \align\bottom 
                \y = y2
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              
              If \align\left And Not \align\right
                \x = x2
                \y = y2
                x2 + \width
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              If \align\right And Not \align\left
                \x = \parent\width[#__c_2] - \width - x1
                \y = y2
                x1 + \width
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              
              If \align\top And Not \align\bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              If \align\bottom And Not \align\top
                \x = 0
                \y = \parent\height[#__c_2] - \height - y1
                y1 + \height
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
            Else
              \align\top = Bool(Mode&#__align_top=#__align_top)
              \align\left = Bool(Mode&#__align_left=#__align_left)
              \align\right = Bool(Mode&#__align_right=#__align_right)
              \align\bottom = Bool(Mode&#__align_bottom=#__align_bottom)
              
              If Bool(Mode&#__align_center=#__align_center)
                \align\horizontal = Bool(Not \align\right And Not \align\left)
                \align\vertical = Bool(Not \align\bottom And Not \align\top)
              EndIf
            EndIf
            
            If \align\right
              If \align\left
                \align\width = \parent\width[#__c_2] - \width
              Else
                If \parent\type = #PB_GadgetType_ScrollArea
                  \align\width = (\parent\scroll\h\bar\max-\x[#__c_3])
                Else
                  \align\width = (\parent\width[#__c_2]-\x[#__c_3])
                EndIf
              EndIf
            EndIf
            
            If \align\bottom
              If \align\top
                \align\height = \parent\height[#__c_2] - \height
              Else
                If \parent\type = #PB_GadgetType_ScrollArea
                  \align\width = (\parent\scroll\v\bar\max-\x[#__c_3])
                Else
                  \align\height = (\parent\height[#__c_2]-\y[#__c_3])
                EndIf
              EndIf
            EndIf
            
            ; update parent childrens coordinate
            Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
 
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
      
      Define *w._S_widget = Canvas(0, 10, 10, 580, 600-50)
      ;Canvas_0 = GetGadget(Root())
      
      Protected b = 4
      Protected iw = 280
      ;Widgets(Hex(0)) = Form(50, 50, 280, 200, "Demo dock widgets");, #__flag_AnchorsGadget)
       Widgets(Hex(0)) = Container(50, 50, 280, 200);, #__flag_AnchorsGadget);#__flag_AutoSize)
      ;Widgets(Hex(0)) = Panel(50, 50, 280, 200) : AddItem(Widgets(Hex(0)), -1, "panel")
     ;Widgets(Hex(0)) = ScrollArea(50, 50, 280, 200, iw,300)
      
      Widgets(Hex(1)) = Button(0, (200-20)/2, 80, 20, "Left_Center_"+Str(1))
      Widgets(Hex(2)) = Button((iw-80)/2, 0, 80, 20, "Top_Center_"+Str(2))
      Widgets(Hex(3)) = Button(iw-80-b, (200-20)/2, 80, 20, Str(3)+"_Center_Right")
      Widgets(Hex(4)) = Button((iw-80)/2, 200-20-b, 80, 20, Str(4)+"_Center_Bottom")
      Widgets(Hex(5)) = Button(0, 0, 80, 20, "Default_"+Str(5))
      Widgets(Hex(6)) = Button(iw-80-b, 0, 80, 20, "Right_"+Str(6))
      Widgets(Hex(7)) = Button(iw-80-b, 200-20-b, 80, 20, "Bottom_"+Str(7))
      Widgets(Hex(8)) = Button(0, 200-20-b, 80, 20, Str(8)+"_Bottom_Right")
      Widgets(Hex(9)) = Button((iw-80)/2, (200-20)/2, 80, 20, "Bottom_"+Str(9))
      
      CloseList()
      
      _SetAlignment(Widgets(Hex(1)), #__align_Center|#__align_left)
      _SetAlignment(Widgets(Hex(2)), #__align_Center|#__align_top)
      _SetAlignment(Widgets(Hex(3)), #__align_Center|#__align_right)
      _SetAlignment(Widgets(Hex(4)), #__align_Center|#__align_bottom)
      _SetAlignment(Widgets(Hex(5)), 0)
      _SetAlignment(Widgets(Hex(6)), #__align_right)
      _SetAlignment(Widgets(Hex(7)), #__align_right|#__align_bottom)
      _SetAlignment(Widgets(Hex(8)), #__align_bottom)
      _SetAlignment(Widgets(Hex(9)), #__align_Center)
      
      
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Procedure Window_1()
;     CreateImage(0,200,60):StartDrawing(ImageOutput(0)):Define i:For i=0 To 200:Circle(100,30,200-i,(i+50)*$010101):Next:StopDrawing()
;     
;     If OpenWindow(0, 0, 0, 700, 600, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
;       WindowBounds(0, WindowWidth(0), WindowHeight(0), #PB_Ignore, #PB_Ignore)
;       ButtonGadget   (0, 5, 600-35, 690,  30, "resize", #PB_Button_Toggle)
;       
;       Define bs, *w._S_widget = Canvas(0, 10, 10, 680, 600-50)
;       
;       ; ; ;Widgets(Hex(0)) = Form(50, 50, 512, 200, "Demo dock widgets");, #__flag_AnchorsGadget)
;                                                                           ;Widgets(Hex(0)) = Container(50, 50, 512, 200) : bs = 2 ;, #__flag_AnchorsGadget)
;                                                                    ; ; ;       ;Widgets(Hex(0)) = Panel(50, 50, 280, 200) : AddItem(Widgets(Hex(0)), -1, "panel")
;                                                                    ; ; ;       ;Widgets(Hex(0)) = ScrollArea(50, 50, 280, 200, 280,200)
;       
;       Widgets(Hex(1)) = Text(10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized",#PB_Text_Center)
;       Widgets(Hex(3)) = Button(10, 70, 200, 60, "", 0, 0)
;       Widgets(Hex(2)) = Editor(10,  140, 200, 20) : SetText(Widgets(Hex(2)),"Editor")
;       Widgets(Hex(4)) = Button(10, 170, 490, 20, "Button / toggle", #PB_Button_Toggle)
;       Widgets(Hex(5)) = Text(220,10,190,20,"Text",#PB_Text_Center) : SetColor(Widgets(Hex(5)), #PB_Gadget_BackColor, $00FFFF)
;       Widgets(Hex(6)) = Container( 220, 30, 190, 100,#PB_Container_Single) : SetColor(Widgets(Hex(6)), #PB_Gadget_BackColor, $cccccc) 
;       Widgets(Hex(7)) = Editor(10,  10, 170, 50) : SetText(Widgets(Hex(7)),"Editor")
;       Widgets(Hex(8)) = Button(10, 70, 80, 20, "Button") 
;       Widgets(Hex(9)) = Button(100, 70, 80, 20, "Button") 
;       CloseList() 
;       Widgets(Hex(10)) = String(220,  140, 190, 20, "String")
;       Widgets(Hex(11)) = Button(420,  10, 80, 80, "Bouton")
;       Widgets(Hex(12)) = CheckBox(420,  90, 80, 20, "CheckBox")
;       Widgets(Hex(13)) = CheckBox(420,  110, 80, 20, "CheckBox")
;       Widgets(Hex(14)) = CheckBox(420,  130, 80, 20, "CheckBox")
;       Widgets(Hex(15)) = CheckBox(420,  150, 80, 20, "CheckBox")
;       
;       
;       ;SetAlignment(Widgets(Hex(1)), #PB_Vertical)
;       SetAlignment(Widgets(Hex(2)), #__align_top|#__align_left|#__align_bottom)
;       ;       SetAlignment(Widgets(Hex(3)), #__flag_Vertical|#__align_right)
;       SetAlignment(Widgets(Hex(4)), #__align_bottom|#__align_right|#__align_left)
;       SetAlignment(Widgets(Hex(5)), #__align_top|#__align_left|#__align_right)
;       SetAlignment(Widgets(Hex(6)), #__align_full)
;       SetAlignment(Widgets(Hex(7)), #__align_full)
;       
;       SetAlignment(Widgets(Hex(8)), #__align_bottom|#__align_right|#__align_left)
;       SetAlignment(Widgets(Hex(9)), #__align_bottom|#__align_right|#__align_left)
;       
;       SetAlignment(Widgets(Hex(10)), #__align_bottom|#__align_right|#__align_left)
;       SetAlignment(Widgets(Hex(11)), #__align_bottom|#__align_right|#__align_top)
;       
;       SetAlignment(Widgets(Hex(12)), #__align_bottom|#__align_right)
;       SetAlignment(Widgets(Hex(13)), #__align_bottom|#__align_right)
;       SetAlignment(Widgets(Hex(14)), #__align_bottom|#__align_right)
;       SetAlignment(Widgets(Hex(15)), #__align_bottom|#__align_right)
;       
;       ReDraw(Root())
;       
;       BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
;     EndIf
   EndProcedure
  
  Window_0()
  
  Define direction = 1
  Define Width, Height
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Width = 480
          direction = 1
        ElseIf Width = Width(Root())-100
          direction =- 1
        EndIf
        ;         
        Width + direction
        Height + direction
        
        Resize(Widgets(Hex(0)), #PB_Ignore, #PB_Ignore, Width, Height)
        ReDraw(Root())
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Define *th._s_widget = Widgets(Str(0))
            Width = Width(*th)
            Height = Height(*th)
            
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----
; EnableXP