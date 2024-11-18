; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define editable = 1
   Global colorback = colors::*this\blue\fore,
          colorframe = colors::*this\blue\frame, 
          colorback1 = $ff00ff00,
          colorframe1 = $ff0000ff
   
   ;\\
   Procedure events_widgets()
      Protected repaint
      
      Select WidgetEvent( )
         Case #__event_MouseEnter,
              #__event_MouseLeave,
              #__event_MouseMove
            Protected *this._s_WIDGET = EventWidget( )
            
;             If WidgetEvent( ) = #__event_MouseEnter
;                Debug "e "+Trim(GetWidgetText( *this ))
;             EndIf
;             
;             If WidgetEvent( ) = #__event_MouseLeave
;                Debug "l "+Trim(GetWidgetText( *this ))
;             EndIf
            
            With *this
               If \enter > 0
                  If \color\frame <> colorframe1 
                     \color\frame = colorframe1
                     repaint = 1 
                  EndIf
                  
                  If \enter = 2
                     If \color\back <> colorback1 
                        \color\back = colorback1
                        repaint = 1 
                     EndIf
                  Else
                     If \color\back <> colorback
                        \color\back = colorback
                        repaint = 1 
                     EndIf
                  EndIf
               Else   
                  If \color\back <> colorback 
                     \color\back = colorback
                     repaint = 1
                  EndIf
                  If \color\frame <> colorframe1 
                     \color\frame = colorframe1
                     repaint = 1 
                  EndIf
               EndIf
            EndWith 
      EndSelect
      
      If repaint                                              
       ;  Debug "change state"
      EndIf
   EndProcedure
   
   ;\\
   If OpenWindow(0, 0, 0, 800, 600, "enter&leave demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetWindowColor(0, $FF61E0FF)
      ;
      ;\\
      ;
      OpenRoot(0, 10, 10, 240, 240 ) : SetWidgetFrame(root(), 1 ) : SetWidgetText(root()," root_1")
      If editable
         a_init(root(),0)
      EndIf
      
      SetWidgetText(ContainerWidget(30, 30, 180, 180), "1" )
      SetWidgetText(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetWidgetText(ContainerWidget(40, 20, 180, 180), "3" )
      SetWidgetText(ContainerWidget(20, 20, 180, 180), "      4" )
      
      SetWidgetText(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetWidgetText(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetWidgetText(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetWidgetText(Splitter(5, 80, 180, 50, 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets), 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetWidgetText(widget( )\FirstWidget( ), "     9")
      SetWidgetText(widget( )\LastWidget( ), "10")
      
      CloseWidgetList()
      CloseWidgetList()
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "11" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetWidgetText(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetWidgetText(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "15" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "16" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "17" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      
      ;
      ;\\
      ;
      OpenRoot(0, 260, 10, 240, 240) : SetWidgetFrame(root(), 1 ) : SetWidgetText(root()," root_2")
      If editable
         a_init(root(),0)
      EndIf
      
      SetWidgetText(ContainerWidget(30, 30, 180, 180), "1" )
      SetWidgetText(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetWidgetText(ContainerWidget(40, 20, 180, 180), "3" )
      SetWidgetText(ContainerWidget(20, 20, 180, 180), "      4" )
      
      SetWidgetText(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetWidgetText(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetWidgetText(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetWidgetText(Splitter(5, 80, 180, 50, 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets), 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetWidgetText(widget( )\FirstWidget( ), "     9")
      SetWidgetText(widget( )\LastWidget( ), "10")
      
      CloseWidgetList()
      CloseWidgetList()
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "11" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetWidgetText(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetWidgetText(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "15" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "16" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "17" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      
      ;
      ;\\
      ;
      OpenRoot(0, 10, 260, 240, 240) : SetWidgetFrame(root(), 1 ) : SetWidgetText(root()," root_3")
      If editable
         a_init(root(),0)
      EndIf
      ;
      SetWidgetText(ContainerWidget(30, 30, 180, 180), "1" )
      SetWidgetText(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetWidgetText(ContainerWidget(40, 20, 180, 180), "3" )
      SetWidgetText(ContainerWidget(20, 20, 180, 180), "      4" )
      
      SetWidgetText(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetWidgetText(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetWidgetText(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetWidgetText(Splitter(5, 80, 180, 50, 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets), 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetWidgetText(widget( )\FirstWidget( ), "     9")
      SetWidgetText(widget( )\LastWidget( ), "10")
      
      CloseWidgetList()
      CloseWidgetList()
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "11" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetWidgetText(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetWidgetText(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "15" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "16" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "17" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      
      ;
      ;\\
      ;
      OpenRoot(0, 260, 260, 240, 240) : SetWidgetFrame(root(), 1 ) : SetWidgetText(root()," root_4")
      If editable
         a_init(root(),0)
      EndIf
      
      ;\\
      SetWidgetText(ContainerWidget(30, 30, 180, 180), "1" )
      SetWidgetText(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetWidgetText(ContainerWidget(40, 20, 180, 180), "3" )
      SetWidgetText(ContainerWidget(20, 20, 180, 180), "      4" )
      
      SetWidgetText(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetWidgetText(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetWidgetText(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetWidgetText(Splitter(5, 80, 180, 50, 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets), 
                       ContainerWidget(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetWidgetText(widget( )\FirstWidget( ), "     9")
      SetWidgetText(widget( )\LastWidget( ), "10")
      
      CloseWidgetList()
      CloseWidgetList()
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "11" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetWidgetText(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetWidgetText(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetWidgetText(ContainerWidget(10, 45, 70, 180), "15" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "16" ) 
      SetWidgetText(ContainerWidget(10, 5, 70, 180), "17" ) 
      SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      CloseWidgetList()
      
      ;\\
      BindWidgetEvent(#PB_All, @events_widgets(), #__event_MouseEnter)
      BindWidgetEvent(#PB_All, @events_widgets(), #__event_MouseMove)
      BindWidgetEvent(#PB_All, @events_widgets(), #__event_MouseLeave)
      
      ;\\
      WaitCloseRoot( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 13
; Folding = ---
; EnableXP