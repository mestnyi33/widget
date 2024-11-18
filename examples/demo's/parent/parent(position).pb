
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseWidgets( )
  
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
  
  Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
  Procedure Widgets_CallBack()
    Protected EventWidget.i = EventWidget( ),
              EventType.i = WidgetEvent( ),
              EventItem.i = WidgetEventItem( );, EventData.i = WidgetEventData( )
    
    Select EventType
      Case #__Event_MouseEnter
        ; bug in mac os
        If IsGadget(EventGadget()) And GetActiveWidgetGadget() <> EventGadget()
          SetActiveGadget(EventGadget())
          Debug 555
        EndIf
        
      Case #__Event_LeftClick, #__Event_Change
        
        Select EventWidget
          Case *WINDOW_0        : SetParent(*CHILD, *WINDOW)
          Case *PANEL0 : SetParent(*CHILD, *PANEL, 0) : SetWidgetState(*PANEL, 0)
          Case *PANEL1 : SetParent(*CHILD, *PANEL, 1) : SetWidgetState(*PANEL, 1)
          Case *PANEL2 : SetParent(*CHILD, *PANEL, 2) : SetWidgetState(*PANEL, 2)
          Case *PANEL_0 : SetParent(*CHILD, *PANEL, 0)
          Case *PANEL_1 : SetParent(*CHILD, *PANEL, 1)
          Case *PANEL_2 : SetParent(*CHILD, *PANEL, 2)
          Case *CONTAINER_0        : SetParent(*CHILD, *CONTAINER)
          Case *SCROLLAREA_0        : SetParent(*CHILD, *SCROLLAREA)
        EndSelect
        
        ;\\
        ClearDebugOutput( )
        Show_DEBUG( )
    
    
    EndSelect
    
  EndProcedure
  
  Define X,Y,Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 220, 620, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  If OpenRoot(10)
    *WINDOW = Root()
    *WINDOW = ContainerWidget(0,0,0,0,#__flag_autosize) : SetWidgetClass(*WINDOW, "WINDOW") 
    SetWidgetColor(*WINDOW, #PB_Gadget_BackColor, $ff00ff00)
   
    *WINDOW_0 = ButtonWidget(pos_x,90,160,30,"(Window)") : SetWidgetClass(*WINDOW_0, GetWidgetText(*WINDOW_0))
    *PANEL0 = ButtonWidget(12,126,56,20,"(0)") : SetWidgetClass(*PANEL0, GetWidgetText(*PANEL0)) 
    *PANEL1 = ButtonWidget(20+50,126,56,20,"(1)") : SetWidgetClass(*PANEL1, GetWidgetText(*PANEL1)) 
    *PANEL2 = ButtonWidget(30+98,126,56,20,"(2)") : SetWidgetClass(*PANEL2, GetWidgetText(*PANEL2)) 
    
    *PANEL = PanelWidget(10,145,200,160)  : SetWidgetClass(*PANEL, "PANEL") 
    AddItem(*PANEL, -1, "item (0)") : *PANEL_0 = ButtonWidget(pos_x,90,160,30,"(PanelWidget(0))") : SetWidgetClass(*PANEL_0, GetWidgetText(*PANEL_0))
    AddItem(*PANEL, -1, "item (1)") : *PANEL_1 = ButtonWidget(pos_x+5,90,160,30,"(PanelWidget(1))") : SetWidgetClass(*PANEL_1, GetWidgetText(*PANEL_1)) 
    AddItem(*PANEL, -1, "item (2)") : *PANEL_2 = ButtonWidget(pos_x+10,90,160,30,"(PanelWidget(2))") : SetWidgetClass(*PANEL_2, GetWidgetText(*PANEL_2)) 
    CloseWidgetList()
    
    *CONTAINER = ContainerWidget(10,310,200,130,#PB_Container_Flat) : SetWidgetClass(*CONTAINER, "CONTAINER") 
    *CONTAINER_0 = ButtonWidget(pos_x,90,160,30,"(Container)") : SetWidgetClass(*CONTAINER_0, GetWidgetText(*CONTAINER_0)) 
    CloseWidgetList()
    
    *SCROLLAREA = ScrollAreaWidget(10,445,200,160,200,160,10,#PB_ScrollArea_Flat) : SetWidgetClass(*SCROLLAREA, "SCROLLAREA") 
    *SCROLLAREA_0 = ButtonWidget(pos_x,90,160,30,"(ScrollArea)") : SetWidgetClass(*SCROLLAREA_0, GetWidgetText(*SCROLLAREA_0)) 
    ;
    ; *CHILD = ButtonWidget(pos_x,10,160,70,"(CHILD)") : SetWidgetClass(*CHILD, "CHILD") 
    *CHILD = ContainerWidget(30,10,160,70)
    ButtonWidget(5,5,70,30,"Button1") 
    ButtonWidget(15,15,70,30,"Button2") 
    ButtonWidget(25,25,70,30,"Button3") 
    CloseWidgetList( )
    ;
    CloseWidgetList()
    
    Show_DEBUG()
    
    SetParent(*CHILD, *PANEL, 0)
    
    Show_DEBUG()
    
    ;
    BindWidgetEvent(Root(), @Widgets_CallBack())
  EndIf
  
  
  WaitCloseRoot()
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 22
; Folding = 6z
; EnableXP
; DPIAware