IncludePath "../../../"
XIncludeFile "widgets.pbi"

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
      
      Select EventWidget
         Case *COMBO
            Select EventType
               Case #__event_Change
                  If *CHILD
                     Define class$ = GetClass(*CHILD)
                     Debug "change " + class$
                     ParentID = GetParent(*CHILD)
                     ;*CHILD = #PB_All
                     ;Destroy( *CHILD )
                     Free( *CHILD )
;                      If Free( *CHILD )
;                         Debug "free " + class$ 
;                      EndIf
                     
                     Debug "is "+*CHILD
                  EndIf
                  *CHILD = Button(150,20,150,70,"Button") 
                  ;PushListPosition(widgets())
                  SetParent(*CHILD, ParentID) 
                  ;PopListPosition(widgets())
            EndSelect
      EndSelect
      
      ; ProcedureReturn #PB_Ignore
   EndProcedure
   
   Define Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
   *window_20 = Open(20, 0, 0, 425, 350, "demo set gadget new parent", Flags)
   
     *CHILD = Container(30,10,160,70)
     Button(5,5,70,30,"Button1") 
     Button(15,15,70,30,"Button2") 
     Button(25,25,70,30,"Button3") 
     CloseList( )
   ;*CHILD = Button(30,10,160,70,"Button") 
   *RETURN = Button(30,90,160,25,"Button <<(Return)") 
   
   
   *COMBO = ComboBox(30,120,160,25) 
   ; Hide(*COMBO, 1)
   AddItem(*COMBO, -1, "Selected  to move")
   AddItem(*COMBO, -1, "Button")
   SetState(*COMBO, #PB_GadgetType_Button)
  Bind(*RETURN, @Widgets_CallBack())
   ; Bind(*COMBO, @Widgets_CallBack())
  
   
   
   *DESKTOP = Button(30,150,160,20,"Button >>(Desktop)") 
   *CANVASCONTAINER = Container(30,180,200,160) : SetColor(*CANVASCONTAINER, #PB_Gadget_BackColor, $ffffffff) ;Canvas(30,180,200,160,#PB_Canvas_Container) 
   *_11 = Button(30,90,160,30,"Button >>(Canvas)") 
   CloseList()
   
   Bind(GetRoot(*window_20), @Widgets_CallBack())
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 74
; FirstLine = 53
; Folding = --
; EnableXP
; DPIAware