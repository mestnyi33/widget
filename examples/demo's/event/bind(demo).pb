﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   
   Procedure events_widgets( )
      If WidgetEvent() <> #__event_MouseMove And 
         WidgetEvent() <> #__event_Draw And 
         WidgetEvent() <> #__event_StatusChange
         
         If EventWidget( )\type = #__Type_Button
            Debug ""+IDWidget(EventWidget())+ " - widget  event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (gadget)"
         EndIf
         
         If IDWidget(EventWidget()) = 1
            ProcedureReturn #PB_Ignore ; no send to (window & root) - event
         EndIf
      EndIf
   EndProcedure
   
   Procedure events_windows( )
      If WidgetEvent() <> #__event_Draw And
         WidgetEvent() <> #__event_MouseMove And 
         WidgetEvent() <> #__event_StatusChange
         
         If EventWidget( )\type = #__Type_Button
            Debug "  "+IDWidget(EventWidget())+ " - widget  event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (window)"
         EndIf
         
         If IDWidget(EventWidget()) = 2
            ProcedureReturn #PB_Ignore ; no send to (root) - event
         EndIf
      EndIf
   EndProcedure
   
   Procedure events_roots( )
      If WidgetEvent() <> #__event_Draw And
         WidgetEvent() <> #__event_MouseMove And 
         WidgetEvent() <> #__event_StatusChange
         
         If EventWidget( )\type = #__Type_Button
            Debug "    "+IDWidget(EventWidget())+ " - widget  event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (root)"
         EndIf
      EndIf
   EndProcedure
   
   ;\\
   If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 10,10, 480, 480)
         Bind(#PB_All, @events_roots())
         Bind(Window(80, 100, 300, 280, "Window_2", #PB_Window_SystemMenu), @events_windows())
         
         Bind(Button(10,  10, 280, 80, "post event for one procedure"), @events_widgets())
         Bind(Button(10, 100, 280, 80, "post event for to two procedure"), @events_widgets())
         Bind(Button(10, 190, 280, 80, "post event for all procedures"), @events_widgets())
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; FirstLine = 6
; Folding = ---
; EnableXP
; DPIAware