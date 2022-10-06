IncludePath "../../../"
; XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLib(widget)
  
  Global  pos_x = 10
  Global *w._S_widget
  Global *window_10._S_widget, *window_20._S_widget
  Global *_6, *_60, *_61, *_62, *_7, *_8, *_11
  Global ParentID, *PANEL._S_widget, *PANEL0._S_widget, *PANEL1._S_widget, *PANEL2._S_widget, *CONTAINER._S_widget, *SCROLLAREA._S_widget, *CHILD._S_widget, *RETURN._S_widget, *COMBO._S_widget, *DESKTOP._S_widget, *CANVASCONTAINER._S_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  
  Procedure Widgets_CallBack()
    Protected EventWidget.i = EventWidget(),
              EventType.i = WidgetEventType(),
              EventItem.i = WidgetEventItem(), 
              EventData.i = WidgetEventData()
    
   Select EventType
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventWidget
            Case  *DESKTOP:  SetParent(*CHILD, 0)
            Case  *_6:  SetParent(*CHILD, *window_10)
            Case *_60, *PANEL0:  SetParent(*CHILD, *PANEL, 0)
            Case *_61, *PANEL1:  SetParent(*CHILD, *PANEL, 1)
            Case *_62, *PANEL2:  SetParent(*CHILD, *PANEL, 2)
            Case  *_7:  SetParent(*CHILD, *CONTAINER)
            Case  *_8:  SetParent(*CHILD, *SCROLLAREA)
            Case *_11:  SetParent(*CHILD,  *CANVASCONTAINER)
            Case  *RETURN:  SetParent(*CHILD, *window_20)
              
            Case *COMBO
              Select EventType()
                Case #PB_EventType_Change
                  ParentID = GetParent(*CHILD)
                  
                  Select GetState(*COMBO)
                    Case  1: *CHILD = Button(30,20,150,30,"Button") 
                    Case  2: *CHILD = String(30,20,150,30,"String") 
                    Case  3: *CHILD = Text(30,20,150,30,"Text", #PB_Text_Border) 
                    Case  4: *CHILD = Option(30,20,150,30,"Option") 
                    Case  5: *CHILD = CheckBox(30,20,150,30,"CheckBox") 
                    Case  6: *CHILD = ListView(30,20,150,30) 
                    Case  7: *CHILD = Frame(30,20,150,30,"Frame") 
                    Case  8: *CHILD = ComboBox(30,20,150,30): AddItem(*CHILD,-1,"ComboBox"): SetState(*CHILD,0)
                    Case  9: *CHILD = Image(30,20,150,30,0,#PB_Image_Border) 
                    Case 10: *CHILD = HyperLink(30,20,150,30,"HyperLink",0) 
                    Case 11: *CHILD = Container(30,20,150,30,#PB_Container_Flat): Button(0,0,80,20,"Button"): CloseList() ; Container
                    Case 12: *CHILD = ListIcon(30,20,150,30,"",88) 
                    ;Case 13: *CHILD = IPAddress(30,20,150,30) 
                    ;Case 14: *CHILD = ProgressBar(30,20,150,30,0,5)
                    ;Case 15: *CHILD = ScrollBar(30,20,150,30,5,335,9)
                    Case 16: *CHILD = ScrollArea(30,20,150,30,305,305,9,#PB_ScrollArea_Flat): Button(0,0,80,20,"Button"): CloseList()
                    ;Case 17: *CHILD = TrackBar(30,20,150,30,0,5)
                    ;Case 18: *CHILD = Web(30,20,150,30,"") ; bug 531 linux
                    Case 19: *CHILD = ButtonImage(30,20,150,30,0)
                    ;Case 20: *CHILD = Calendar(30,20,150,30) 
                    ;Case 21: *CHILD = Date(30,20,150,30)
                    Case 22: *CHILD = Editor(30,20,150,30):  AddItem(*CHILD,-1,"Editor")
                    ;Case 23: *CHILD = ExplorerList(30,20,150,30,"")
                    ;Case 24: *CHILD = ExplorerTree(30,20,150,30,"")
                    ;Case 25: *CHILD = ExplorerCombo(30,20,150,30,"")
                    Case 26: *CHILD = Spin(30,20,150,30,0,5,#PB_Spin_Numeric)
                    Case 27: *CHILD = Tree(30,20,150,30):  AddItem(*CHILD,-1,"Tree"):  AddItem(*CHILD,-1,"SubLavel",0,1)
                    Case 28: *CHILD = Panel(30,20,150,30): AddItem(*CHILD,-1,"Panel"): CloseList()
                    Case 29 
                      Button(0,0,30,30,"1")
                      Button(0,0,30,30,"2")
                      *CHILD = Splitter(30,20,150,30,201,202)
                      
                    Case 30: *CHILD = MDI(30,10,150,70)
                    ; Case 31: *CHILD = Scintilla(30,10,150,70,0)
                    ; Case 32: *CHILD = Shortcut(30,10,150,70,0)
                    ; Case 33: *CHILD = Canvas(30,10,150,70) 
                  EndSelect
                  
                  Resize(*CHILD,30,10,150,70)
                  SetParent(*CHILD, ParentID) 
                  
              EndSelect
          EndSelect
          
          If (EventWidget <> *CHILD)
            Define Parent = GetParent(*CHILD)
            
;             If Is(Parent)
;               Debug "parent -  (" + Parent + ")"
;             Else
;               Debug "parent - window (" + GetWindow(*CHILD) + ")"
;             EndIf
          EndIf
      EndSelect 
  EndProcedure
  
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow(10, 0, 0, 425, 350, "demo set gadget new parent", Flags)
  Open(10)
  ;*window_10 = Window(0, 0, 425, 350,"demo set gadget new parent", Flags)
  *window_10 = Container(0, 0, 425, 350)
  
  *_6 = Button(30,90,160,25,"Button >>(Window)")
  
  *PANEL0 = Button(30,120,160,20,"Button >>(Panel (0))") 
  *PANEL1 = Button(30,140,160,20,"Button >>(Panel (1))") 
  *PANEL2 = Button(30,160,160,20,"Button >>(Panel (2))") 
  
  *PANEL = Panel(10,180,200,160) 
  AddItem(*PANEL,-1,"Panel") 
  *_60 = Button(30,90,160,30,"Button >>(Panel (0))") 
  AddItem(*PANEL,-1,"First") 
  *_61 = Button(35,90,160,30,"Button >>(Panel (1))") 
  AddItem(*PANEL,-1,"Second") 
  *_62 = Button(40,90,160,30,"Button >>(Panel (2))") 
  CloseList()
  
  *CONTAINER = Container(215,10,200,160,#PB_Container_Flat) 
  *_7 = Button(30,90,160,30,"Button >>(Container)") 
  CloseList()
  
  *SCROLLAREA = ScrollArea(215,180,200,160,200,160,10,#PB_ScrollArea_Flat) 
  *_8 = Button(30,90,160,30,"Button >>(ScrollArea)") 
  CloseList()
  
  
  ;
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow(20, WindowX(10)-210-35, WindowY(10), 240, 350, "old parent", Flags, WindowID(10))
  Open(20)
  ;*window_20 = Window(0,0, 425, 350,"demo set gadget new parent", Flags, *window_10)
  *window_20 = Container(0,0, 425, 350)
  
  *CHILD = Button(30,10,160,70,"Button") 
  *RETURN = Button(30,90,160,25,"Button <<(Return)") 
  
  *COMBO = ComboBox(30,120,160,25) 
  AddItem(*COMBO, -1, "Selected  to move")
  AddItem(*COMBO, -1, "Button")
  AddItem(*COMBO, -1, "String")
  AddItem(*COMBO, -1, "Text")
  AddItem(*COMBO, -1, "CheckBox")
  AddItem(*COMBO, -1, "Option")
  AddItem(*COMBO, -1, "ListView")
  AddItem(*COMBO, -1, "Frame")
  AddItem(*COMBO, -1, "ComboBox")
  AddItem(*COMBO, -1, "Image")
  AddItem(*COMBO, -1, "HyperLink")
  AddItem(*COMBO, -1, "Container")
  AddItem(*COMBO, -1, "ListIcon")
  AddItem(*COMBO, -1, "IPAddress")
  AddItem(*COMBO, -1, "ProgressBar")
  AddItem(*COMBO, -1, "ScrollBar")
  AddItem(*COMBO, -1, "ScrollArea")
  AddItem(*COMBO, -1, "TrackBar")
  AddItem(*COMBO, -1, "Web")
  AddItem(*COMBO, -1, "ButtonImage")
  AddItem(*COMBO, -1, "Calendar")
  AddItem(*COMBO, -1, "Date")
  AddItem(*COMBO, -1, "Editor")
  AddItem(*COMBO, -1, "ExplorerList")
  AddItem(*COMBO, -1, "ExplorerTree")
  AddItem(*COMBO, -1, "ExplorerCombo")
  AddItem(*COMBO, -1, "Spin")        
  AddItem(*COMBO, -1, "Tree")         
  AddItem(*COMBO, -1, "Panel")        
  AddItem(*COMBO, -1, "Splitter")    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddItem(*COMBO, -1, "MDI") 
  CompilerEndIf
  AddItem(*COMBO, -1, "Scintilla") 
  AddItem(*COMBO, -1, "Shortcut")  
  AddItem(*COMBO, -1, "Canvas")    
  
  SetState(*COMBO, #PB_GadgetType_Button);:  PostEvent(#PB_Event_, #CHILD, *COMBO, #PB_EventType_Change)
  
  *DESKTOP = Button(30,150,160,20,"Button >>(Desktop)") 
  *CANVASCONTAINER = Container(30,180,200,160) : SetColor(*CANVASCONTAINER, #__color_back, $ffffffff) ;Canvas(30,180,200,160,#PB_Canvas_Container) 
  *_11 = Button(30,90,160,30,"Button >>(Canvas)") 
  CloseList()
  
  HideWindow(GetWindow(GetRoot(*window_10)),0)
  HideWindow(GetWindow(GetRoot(*window_20)),0)
  
;   ReDraw(GetRoot(*window_10))
;   ReDraw(GetRoot(*window_20))
  
  Bind(GetRoot(*window_10), @Widgets_CallBack())
  Bind(GetRoot(*window_20), @Widgets_CallBack())
  
  Define Event
  Repeat
     Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP