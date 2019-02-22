IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseModule Widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i,NewMap Widgets.i()
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected *This.Widget_S, *main.Widget_S = GetGadgetData(Canvas)
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resize(*main, x, y, Width-x*2, Height-y*2)  
        Repaint = 1 
    EndSelect
    
    *This = at(*main, mouseX, mouseY)
    
    If *This
      Repaint | CallBack(*This, EventType, mouseX,mouseY)
    EndIf
    
    If Repaint
      ReDraw(*main)
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  If OpenWindow(3, 0, 0, 995, 455, "Position de la souris sur la fenêtre", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(100, 0, 0, 995, 455, #PB_Canvas_Keyboard)
    BindGadgetEvent(100, @Canvas_CallBack())
    
    If OpenList(3, 100)
      
      ;Widgets("Container") = Container(0, 0, 995, 455);, #PB_Flag_AutoSize) 
      
      Widgets(Str(#PB_GadgetType_Button)) = Button(5, 5, 160,70, "Button_"+Str(#PB_GadgetType_Button) ) ; ok
      Widgets(Str(#PB_GadgetType_String)) = String(5, 80, 160,70, "String_"+Str(#PB_GadgetType_String)) ; ok
      Widgets(Str(#PB_GadgetType_Text)) = Text(5, 155, 160,70, "Text_"+Str(#PB_GadgetType_Text))        ; ok
      Widgets(Str(#PB_GadgetType_CheckBox)) = CheckBox(5, 230, 160,70, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Str(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween); ok
      Widgets(Str(#PB_GadgetType_Option)) = Option(5, 305, 160,70, "Option_"+Str(#PB_GadgetType_Option) ) : SetState(Widgets(Str(#PB_GadgetType_Option)), 1)                                                       ; ok
      Widgets(Str(#PB_GadgetType_ListView)) = ListView(5, 380, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_ListView)), -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ListView)), i, "item_"+Str(i)) : Next
      
      Widgets(Str(#PB_GadgetType_Frame)) = Frame(170, 5, 160,70, "Frame_"+Str(#PB_GadgetType_Frame) )
      Widgets(Str(#PB_GadgetType_ComboBox)) = ComboBox(170, 80, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), i, "item_"+Str(i)) : Next : SetState(Widgets(Str(#PB_GadgetType_ComboBox)), 0) 
      Widgets(Str(#PB_GadgetType_Image)) = Image(170, 155, 160,70, 0, #PB_Image_Border ) ; ok
      Widgets(Str(#PB_GadgetType_HyperLink)) = HyperLink(170, 230, 160,70,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) ; ok
      Widgets(Str(#PB_GadgetType_Container)) = Container(170, 305, 160,70, #PB_Container_Flat )
      Widgets(Str(101)) = Option(10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetState(Widgets(Str(101)), 1)  
      Widgets(Str(102)) = Option(10, 40, 110,20, "Option_widget" )  
      CloseList()
      ;     ListIconGadget(#PB_GadgetType_ListIcon, 170, 380, 160,70,"ListIconGadget_"+Str(#PB_GadgetType_ListIcon),120 )                           ; ok
      
      ;     IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,70 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    ; ok
      Widgets(Str(#PB_GadgetType_ProgressBar)) = Progress(335, 80, 160,70,0,100) : SetState(Widgets(Str(#PB_GadgetType_ProgressBar)), 50)
      Widgets(Str(#PB_GadgetType_ScrollBar)) = Scroll(335, 155, 160,70,0,100,20) : SetState(Widgets(Str(#PB_GadgetType_ScrollBar)), 40)
      Widgets(Str(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 230, 160,70,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Str(201)) = Button(0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) : Widgets(Str(202)) = Button(180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseList()
      Widgets(Str(#PB_GadgetType_TrackBar)) = Track(335, 305, 160,70,0,100) : SetState(Widgets(Str(#PB_GadgetType_TrackBar)), 25)
      ;     WebGadget(#PB_GadgetType_Web, 335, 380, 160,70,"" )
      
      Widgets(Str(#PB_GadgetType_ButtonImage)) = Button(500, 5, 160,70, "", 0, 1)
      ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 80, 160,70 )
      ;     DateGadget(#PB_GadgetType_Date, 500, 155, 160,70 )
      ;     EditorGadget(#PB_GadgetType_Editor, 500, 230, 160,70 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "EditorGadget_"+Str(#PB_GadgetType_Editor))  
      ;     ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 305, 160,70,"" )
      ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 380, 160,70,"" )
      ;     
      ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,70,"" )
      Widgets(Str(#PB_GadgetType_Spin)) = Spin(665, 80, 160,70,20,100)
      Widgets(Str(#PB_GadgetType_Tree)) = Tree( 665, 155, 160, 70 ) : AddItem(Widgets(Str(#PB_GadgetType_Tree)), -1, "Tree_"+Str(#PB_GadgetType_Tree)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_Tree)), i, "item_"+Str(i)) : Next
      Widgets(Str(#PB_GadgetType_Panel)) = Panel(665, 230, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_Panel)), -1, "Panel_"+Str(#PB_GadgetType_Panel)) : Widgets(Str(255)) = Button(0, 0, 90,20, "Button_255" ) : For i=1 To 15 : AddItem(Widgets(Str(#PB_GadgetType_Panel)), i, "item_"+Str(i)) : Next : CloseList()
      
      OpenList(Widgets(Str(#PB_GadgetType_Panel)), 1)
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt") 
      CloseList()
      CloseList()
      CloseList()
      SetState( Widgets(Str(#PB_GadgetType_Panel)), 12)
      
      Widgets(Str(301)) = Spin(0, 0, 100,20,0,10, #PB_Vertical);, "Button_1")
      Widgets(Str(302)) = Spin(0, 0, 100,20,0,10);, "Button_2")
      Widgets(Str(#PB_GadgetType_Splitter)) = Splitter(665, 305, 160,70,Widgets(Str(301)), Widgets(Str(302)));, #PB_Splitter_Vertical);, Button(0, 0, 100,20, "ButtonGadget"), Button(0, 0, 0,20, "StringGadget")) 
                                                                                                             ;     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                                                                                                             ;       MDIGadget(#PB_GadgetType_MDI, 665, 380, 160,70,1, 2);, #PB_MDI_AutoSize)
                                                                                                             ;     CompilerEndIf
                                                                                                             ;     InitScintilla()
                                                                                                             ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,70,0 )
                                                                                                             ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 80, 160,70 ,-1)
                                                                                                             ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 155, 160,70 )
      
      CloseList()
      
      ReDraw(Root())
    EndIf
    
    Repeat
      Define  Event = WaitWindowEvent()
      ;       If Event
      ;       Define  Window = EventWindow()
      ;         If IsWindow(Window)
      ;            MouseState( )
      ;           Select Window
      ;             Case 1 :EventMain(Event, Window)
      ;           EndSelect
      ;         EndIf
      ;       EndIf
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -0-
; EnableXP