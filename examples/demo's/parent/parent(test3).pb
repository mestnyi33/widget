XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseWidgets( )
  
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
              EventType.i = WidgetEvent(),
              EventItem.i = WidgetEventItem(), 
              EventData.i = WidgetEventData()
    
   Select EventType
        Case #__Event_LeftClick
          ClearDebugOutput()
          
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
          EndSelect
         
      EndSelect 
  EndProcedure
  
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow(10, 0, 0, 425, 350, "demo set gadget new parent", Flags)
  OpenRootWidget(10) : SetTextWidget(Root(), "*root1" )
  ;*window_10 = WindowWidget(0, 0, 425, 350,"demo set gadget new parent", Flags)
  *window_10 = ContainerWidget(0, 0, 425, 350) : SetTextWidget(*window_10, "*window_10" )
  
  *CHILD = ButtonWidget(-30,10,160,70,"child") 
  *_6 = ButtonWidget(30,90,160,25,"Button >>(Window)")
  
  *PANEL0 = ButtonWidget(30,120,160,20,"Button >>(Panel (0))") 
  *PANEL1 = ButtonWidget(30,140,160,20,"Button >>(Panel (1))") 
  *PANEL2 = ButtonWidget(30,160,160,20,"Button >>(Panel (2))") 
  
  *PANEL = PanelWidget(10,180,200,160) : SetTextWidget(*PANEL, "*PANEL" )
  AddItem(*PANEL,-1,"Panel") 
  *_60 = ButtonWidget(30,90,160,30,">>(Panel (0))") 
  AddItem(*PANEL,-1,"First") 
  *_61 = ButtonWidget(35,90,160,30,">>(Panel (1))") 
  AddItem(*PANEL,-1,"Second") 
  *_62 = ButtonWidget(40,90,160,30,">>(Panel (2))") 
  CloseWidgetList()
  
  *CONTAINER = ContainerWidget(215,10,200,160,#PB_Container_Flat)  : SetTextWidget(*CONTAINER, "*CONTAINER" )
  *_7 = ButtonWidget(30,90,160,30,">>(Container)") 
  CloseWidgetList()
  
  *SCROLLAREA = ScrollAreaWidget(215,180,200,160,200,160,10,#PB_ScrollArea_Flat)  : SetTextWidget(*SCROLLAREA, "*SCROLLAREA" )
  *_8 = ButtonWidget(30,90,160,30,">>(ScrollArea)") 
  CloseWidgetList()
  
  
  HideWindow(GetCanvasWindow(GetRoot(*window_10)),0)
 
  BindWidgetEvent(GetRoot(*window_10), @Widgets_CallBack())
;   BindWidgetEvent(GetRoot(*window_20), @Widgets_CallBack())
  
  Define Event
  Repeat
     Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; FirstLine = 22
; Folding = --
; EnableXP
; DPIAware