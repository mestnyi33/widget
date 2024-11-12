XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   ;EnableExplicit
   UseWidgets( )
   
   Procedure DoFocus( *this._s_WIDGET, event.i )
      Debug ""+*this\class +" "+ ClassFromEvent(event)
   EndProcedure
      
   Procedure Events()
      Protected event = WidgetEvent()
      If event =  #__Event_MouseEnter
         Select IDWidget(EventWidget())
            Case 2 : SetActive(WidgetID(0))   ; Activate StringGadget
            Case 3 : SetActive(WidgetID(1))   ; Activate ComboBoxGadget
         EndSelect
      EndIf
      
      Select event
         Case #__Event_Focus
            Debug "focus ["+IDWidget(EventWidget()) +"]eventgadget ["+ IDWidget(GetActive()) +"]getactivegadget"
            
            If GetActiveGadget( ) <> EventWidget( )\root\canvas\gadget
               SetActiveGadget( EventWidget( )\root\canvas\gadget )
            EndIf
            
         Case #__Event_LostFocus
            Debug "lostfocus ["+IDWidget(EventWidget()) +"]eventgadget ["+ IDWidget(GetActive()) +"]getactivegadget"
      EndSelect
   EndProcedure
   
   Procedure CanvasButton( gadget, x,y,width,height,text.s )
      Button( x,y,width,height, text )
      SetClass(widget(), Str(gadget))
      Bind(widget(), @Events())
   EndProcedure
   
   Procedure CanvasButtonGadget( gadget, x,y,width,height,text.s )
      CanvasGadget(gadget, x,y,width,height, #PB_Canvas_DrawFocus )
      
      If StartDrawing(CanvasOutput(gadget))
         DrawingFont(GetGadgetFont(-1))
         DrawText((DesktopScaledX(width)-TextWidth(text))/2, (DesktopScaledY(height)-TextHeight(text))/2, text)
         StopDrawing()
      EndIf
   EndProcedure


   If OpenWindow(0, 100, 100, 270, 140, "SetActiveGadget", #PB_Window_SystemMenu )
      CanvasButtonGadget(10, 10, 10, 250, 20, "String")
      CanvasButtonGadget(11, 10, 40, 250, 21, "ComboBox")
   EndIf
   
   If Open(1, 300, 300, 270, 140, "SetActiveGadget", #PB_Window_SystemMenu )
      CanvasButton(0, 10, 10, 250, 20, "String")
      CanvasButton(1, 10, 40, 250, 21, "ComboBox")
      
      CanvasButton(2, 10,  90, 250, 20, "mouse enter to activate String")
      CanvasButton(3, 10, 115, 250, 20, "mouse enter to activate ComboBox")
      
      Repeat
         Event = WaitWindowEvent()
         If Event = #PB_Event_Gadget
            If EventType() =  #PB_EventType_MouseEnter
;                Select EventGadget()
;                   Case 10 : SetActiveGadget(10)   ; Activate StringGadget
;                   Case 11 : SetActiveGadget(11)   ; Activate ComboBoxGadget
;                EndSelect
              ; SetActiveGadget(EventGadget())
              SetFocus_( GadgetID(EventGadget()))
            EndIf
         EndIf
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 23
; FirstLine = 9
; Folding = ---
; EnableXP
; DPIAware