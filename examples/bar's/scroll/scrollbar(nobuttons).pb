XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets()
   
   Global *bar
   Global.i gEvent, gQuit, g_Canvas, buttonsize
   
   Procedure change_event()
      Protected state = GetState(EventWidget())
      Debug ""+ state +" "+ WidgetEventItem() +" "+ WidgetEventData() +" [CHANGE] - "+ GetClass(EventWidget())
      SetWindowTitle(0, Str(state))
   EndProcedure
   
   Procedure spin_change_event()
      buttonsize = DPIScaled(GetState(EventWidget()))
      SetAttribute(*bar, #__bar_ButtonSize, buttonsize)
   EndProcedure
   
   If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      If Open(0, 10, 10, 380, 80)
         g_Canvas = GetCanvasGadget(root())
         *bar = Scroll(5, 10, 370, 30, 20, 50, 8)
         SetAttribute(*bar, #__bar_ButtonSize, DPIScaled(30))
         buttonsize = GetAttribute(*bar, #__bar_ButtonSize)
         Debug "button-size - "+buttonsize
         
         Splitter(5, 5, 340, 70, *bar, - 1)
         SetState(widget(), 70)
         
         Track(350, 5, 25, 70, 0, 50, #__flag_Vertical|#__flag_Invert)
         Bind(widget(), @spin_change_event(), #__event_Change)
         SetState(widget(), DPIUnscaled(buttonsize))
         
         Bind(*bar, @change_event(), #__event_Change)
         SetWindowTitle(0, Str(GetState(*bar)))
      EndIf
      
      ButtonGadget(0, 5, 95, 390, 30, "", #PB_Button_Toggle)
      SetGadgetState(0, buttonsize)
      If GetGadgetState(0)
         SetGadgetText(0, "hide scrollbar buttons")
      Else
         SetGadgetText(0, "show scrollbar buttons")
      EndIf
   EndIf
   
   Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit= #True
            
         Case #PB_Event_Gadget
            
            Select EventGadget()
               Case 0
                  If GetGadgetState(0)
                     SetGadgetText(0, "hide scrollbar buttons")
                     SetAttribute(*bar, #__bar_ButtonSize, buttonsize)
                  Else
                     SetGadgetText(0, "show scrollbar buttons")
                     SetAttribute(*bar, #__bar_ButtonSize, 0)
                  EndIf
                  
                  PostRepaint()
            EndSelect
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 73
; FirstLine = 37
; Folding = --
; EnableXP
; DPIAware