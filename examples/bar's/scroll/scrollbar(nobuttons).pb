XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *scrollbar
   Global.i gEvent, gQuit, g_Canvas, buttonsize
   
   Procedure Window_0()
      If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         ButtonGadget   (0,    5,   95, 390,  30, "", #PB_Button_Toggle)
         
         If OpenRoot(0, 10, 10, 380, 80)
            g_Canvas = GetCanvasGadget(root())
            *scrollbar = ScrollBarWidget(5, 10, 370, 30, 20, 50, 8 )
            SetWidgetAttribute(*scrollbar, #__Bar_ButtonSize, 30 )
            buttonsize = GetWidgetAttribute( *scrollbar, #__Bar_ButtonSize )
            Debug "button-size - "+buttonsize
            
            SplitterWidget(5, 5, 370, 70, *scrollbar,-1)
            SetWidgetState(widget(), 70)
            
            SetGadGetWidgetState(0, buttonsize)
            SetWindowTitle(0, Str(GetWidgetState(*scrollbar)))
            
            If GetGadGetWidgetState(0)
               SetGadGetWidgetText(0, "hide scrollbar buttons")
            Else
               SetGadGetWidgetText(0, "show scrollbar buttons")
            EndIf
            
         EndIf
      EndIf
   EndProcedure
   
   Window_0()
   
   Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit= #True
            
         Case #PB_Event_Gadget
            
            Select EventGadget()
               Case 0
                  SetWindowTitle(0, Str(GetWidgetState(*scrollbar)))
                  
                  If GetGadGetWidgetState(0)
                     SetGadGetWidgetText(0, "hide scrollbar buttons")
                     SetWidgetAttribute(*scrollbar, #__Bar_ButtonSize, buttonsize)
                  Else
                     SetGadGetWidgetText(0, "show scrollbar buttons")
                     SetWidgetAttribute(*scrollbar, #__Bar_ButtonSize, 0)
                  EndIf
                  
               Case g_Canvas
                  If widget()\change
                     ; SetWindowTitle(0, Str(GetWidgetState(widget())))
                     Debug GetWidgetState(widget())
                     widget()\change = 0
                  EndIf
                  
            EndSelect
            
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = --
; EnableXP