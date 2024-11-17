; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Declare events_widgets( )

Define editable = #__flag_BorderFlat;|  ; #__flag_flat ; 
Global colorback = colors::*this\blue\fore,
       colorframe=colors::*this\blue\frame, 
       colorback1 = $ff00ff00,
       colorframe1=$ff0000ff

;\\
Open(0, 0, 0, 240, 240, "enter&leave demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
If editable 
   a_init(root())
EndIf

;\\
SetData(ContainerWidget(30, 30, 180, 180, editable), 1)
SetData(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets|editable), 2) 
SetData(ContainerWidget(40, 20, 180, 180, editable), 3)
SetData(ContainerWidget(20, 20, 180, 180, editable), 4)

SetData(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets|editable), 5) 
SetData(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets|editable), 6) 
SetData(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets|editable), 7) 

SetData(Splitter(5, 80, 180, 50, 
                 ContainerWidget(0,0,0,0, #__Flag_NoGadgets|editable), 
                 ContainerWidget(0,0,0,0, #__Flag_NoGadgets|editable),
                 #PB_Splitter_Vertical|editable), 8) 

CloseList()
CloseList()
SetData(ContainerWidget(10, 45, 70, 180, editable), 11) 
SetData(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
SetData(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
SetData(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
SetData(ContainerWidget(10, 45, 70, 180, editable), 11) 
SetData(ContainerWidget(10, 5, 70, 180, editable), 11) 
SetData(ContainerWidget(10, 5, 70, 180, editable), 11) 
SetData(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
CloseList()
CloseList()
CloseList()
CloseList()

;\\
Bind(#PB_All, @events_widgets(), #__event_MouseEnter)
Bind(#PB_All, @events_widgets(), #__event_MouseMove)
Bind(#PB_All, @events_widgets(), #__event_MouseLeave)

;\\
WaitClose( )

;\\
Procedure events_widgets()
   Protected repaint
   
   Select WidgetEvent( )
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
         
         If EventWidget( ) <> Root( )
            If EventWidget( )\enter 
               If EventWidget( )\color\frame <> colorframe1 
                  EventWidget( )\color\frame = colorframe1
                  repaint = 1 
               EndIf
               
               If EventWidget( )\enter = 2
                  If EventWidget( )\color\back <> colorback1 
                     EventWidget( )\color\back = colorback1
                     repaint = 1 
                  EndIf
               Else
                  If EventWidget( )\color\back = colorback1
                     EventWidget( )\color\back = colorback
                     repaint = 1 
                  EndIf
               EndIf
            Else   
               If EventWidget( )\color\back <> colorback 
                  EventWidget( )\color\back = colorback
                  repaint = 1
               EndIf
               If EventWidget( )\color\frame = colorframe1 
                  EventWidget( )\color\frame = colorframe
                  repaint = 1 
               EndIf
            EndIf
         EndIf
         
   EndSelect
   
   If repaint                                              
      Debug "change state"
   EndIf
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = ---
; EnableXP
; DPIAware