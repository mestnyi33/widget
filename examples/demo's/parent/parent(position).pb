
XIncludeFile "../../../widgets.pbi" 
 ;Macro widget( ) : enumwidget( ) : EndMacro

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLib(widget)
  
  Global  pos_x = 10
  Global._S_widget *PANEL, *WINDOW, *CONTAINER, *SCROLLAREA, *CONTAINER_0, *SCROLLAREA_0
  Global._S_widget *CHILD, *WINDOW_0, *PANEL0, *PANEL1, *PANEL2, *PANEL_0, *PANEL_1, *PANEL_2
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  
  Procedure Widgets_CallBack()
    Protected EventWidget.i = EventWidget( ),
              EventType.i = WidgetEvent( )\type,
              EventItem.i = WidgetEvent( )\item;, EventData.i = WidgetEvent( )\data
    
    Select EventType
      Case #PB_EventType_MouseEnter
        ; bug in mac os
        If IsGadget(EventGadget()) And GetActiveGadget() <> EventGadget()
          SetActiveGadget(EventGadget())
          Debug 555
        EndIf
        
      Case #PB_EventType_LeftClick, #PB_EventType_Change
        
        Select EventWidget
          Case *WINDOW_0        : SetParent(*CHILD, *WINDOW)
          Case *PANEL0 : SetParent(*CHILD, *PANEL, 0) : SetState(*PANEL, 0)
          Case *PANEL1 : SetParent(*CHILD, *PANEL, 1) : SetState(*PANEL, 1)
          Case *PANEL2 : SetParent(*CHILD, *PANEL, 2) : SetState(*PANEL, 2)
          Case *PANEL_0 : SetParent(*CHILD, *PANEL, 0)
          Case *PANEL_1 : SetParent(*CHILD, *PANEL, 1)
          Case *PANEL_2 : SetParent(*CHILD, *PANEL, 2)
          Case *CONTAINER_0        : SetParent(*CHILD, *CONTAINER)
          Case *SCROLLAREA_0        : SetParent(*CHILD, *SCROLLAREA)
        EndSelect
        
        debug_position(root(), "re")
    
    
    EndSelect
    
  EndProcedure
  
  Define X,Y,Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 425, 315, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  If Open(10)
    *WINDOW = Root()
    *WINDOW = Container(0,0,0,0,#__flag_autosize) : SetClass(*WINDOW, "*WINDOW") 
    SetColor(*WINDOW, #PB_Gadget_BackColor, $ff00ff00)
   
    *WINDOW_0 = Button(pos_x,90,160,30,">>(Window)") : SetClass(*WINDOW_0, GetText(*WINDOW_0))
    *PANEL0 = Button(12,126,56,20,">>(0)") 
    *PANEL1 = Button(20+50,126,56,20,">>(1)") 
    *PANEL2 = Button(30+98,126,56,20,">>(2)") 
    
    *PANEL = Panel(10,145,200,160) 
    AddItem(*PANEL, -1, "item (0)") : *PANEL_0 = Button(pos_x,90,160,30,">>(Panel (0))") : SetClass(*PANEL_0, GetText(*PANEL_0))
    AddItem(*PANEL, -1, "item (1)") : *PANEL_1 = Button(pos_x+5,90,160,30,">>(Panel (1))") : SetClass(*PANEL_1, GetText(*PANEL_1)) 
    AddItem(*PANEL, -1, "item (2)") : *PANEL_2 = Button(pos_x+10,90,160,30,">>(Panel (2))") : SetClass(*PANEL_2, GetText(*PANEL_2)) 
    CloseList()
    
    *CONTAINER = Container(215,10,200,130,#PB_Container_Flat) : SetClass(*CONTAINER, "*CONTAINER") 
    *CONTAINER_0 = Button(pos_x,90,160,30,">>(Container)") : SetClass(*CONTAINER_0, GetText(*CONTAINER_0)) 
    CloseList()
    
    *SCROLLAREA = ScrollArea(215,145,200,160,200,160,10,#PB_ScrollArea_Flat) : SetClass(*SCROLLAREA, "*SCROLLAREA") 
    *SCROLLAREA_0 = Button(pos_x,90,160,30,">>(ScrollArea)") : SetClass(*SCROLLAREA_0, GetText(*SCROLLAREA_0)) 
    *CHILD = Button(pos_x,10,160,70,"*CHILD") : SetClass(*CHILD, GetText(*CHILD)) 
    CloseList()
    
    debug_position(root(), "")
    
    SetParent(*CHILD, *PANEL, 0)
    
    debug_position(root(), "container")
    
    
    Bind(Root(), @Widgets_CallBack())
  EndIf
  
  
  WaitClose()
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = B+
; EnableXP