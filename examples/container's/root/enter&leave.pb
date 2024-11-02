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
;                Debug "e "+Trim(GetText( *this ))
;             EndIf
;             
;             If WidgetEvent( ) = #__event_MouseLeave
;                Debug "l "+Trim(GetText( *this ))
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
      Open(0, 10, 10, 240, 240 ) : SetFrame(root(), 1 ) : SetText(root()," root_1")
      If editable
         a_init(root(),0)
      EndIf
      
      SetText(Container(30, 30, 180, 180), "1" )
      SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetText(Container(40, 20, 180, 180), "3" )
      SetText(Container(20, 20, 180, 180), "      4" )
      
      SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetText(Splitter(5, 80, 180, 50, 
                       Container(0,0,0,0, #__Flag_NoGadgets), 
                       Container(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetText(widget( )\FirstWidget( ), "     9")
      SetText(widget( )\LastWidget( ), "10")
      
      CloseList()
      CloseList()
      SetText(Container(10, 45, 70, 180), "11" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetText(Container(10, 45, 70, 180), "15" ) 
      SetText(Container(10, 5, 70, 180), "16" ) 
      SetText(Container(10, 5, 70, 180), "17" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      ;
      ;\\
      ;
      Open(0, 260, 10, 240, 240) : SetFrame(root(), 1 ) : SetText(root()," root_2")
      If editable
         a_init(root(),0)
      EndIf
      
      SetText(Container(30, 30, 180, 180), "1" )
      SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetText(Container(40, 20, 180, 180), "3" )
      SetText(Container(20, 20, 180, 180), "      4" )
      
      SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetText(Splitter(5, 80, 180, 50, 
                       Container(0,0,0,0, #__Flag_NoGadgets), 
                       Container(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetText(widget( )\FirstWidget( ), "     9")
      SetText(widget( )\LastWidget( ), "10")
      
      CloseList()
      CloseList()
      SetText(Container(10, 45, 70, 180), "11" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetText(Container(10, 45, 70, 180), "15" ) 
      SetText(Container(10, 5, 70, 180), "16" ) 
      SetText(Container(10, 5, 70, 180), "17" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      ;
      ;\\
      ;
      Open(0, 10, 260, 240, 240) : SetFrame(root(), 1 ) : SetText(root()," root_3")
      If editable
         a_init(root(),0)
      EndIf
      ;
      SetText(Container(30, 30, 180, 180), "1" )
      SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetText(Container(40, 20, 180, 180), "3" )
      SetText(Container(20, 20, 180, 180), "      4" )
      
      SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetText(Splitter(5, 80, 180, 50, 
                       Container(0,0,0,0, #__Flag_NoGadgets), 
                       Container(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetText(widget( )\FirstWidget( ), "     9")
      SetText(widget( )\LastWidget( ), "10")
      
      CloseList()
      CloseList()
      SetText(Container(10, 45, 70, 180), "11" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetText(Container(10, 45, 70, 180), "15" ) 
      SetText(Container(10, 5, 70, 180), "16" ) 
      SetText(Container(10, 5, 70, 180), "17" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      ;
      ;\\
      ;
      Open(0, 260, 260, 240, 240) : SetFrame(root(), 1 ) : SetText(root()," root_4")
      If editable
         a_init(root(),0)
      EndIf
      
      ;\\
      SetText(Container(30, 30, 180, 180), "1" )
      SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets), "2" ) 
      SetText(Container(40, 20, 180, 180), "3" )
      SetText(Container(20, 20, 180, 180), "      4" )
      
      SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets), "     5" ) 
      SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets), "     6" ) 
      SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets), "     7" ) 
      
      SetText(Splitter(5, 80, 180, 50, 
                       Container(0,0,0,0, #__Flag_NoGadgets), 
                       Container(0,0,0,0, #__Flag_NoGadgets),
                       #PB_Splitter_Vertical), "8" ) 
      SetText(widget( )\FirstWidget( ), "     9")
      SetText(widget( )\LastWidget( ), "10")
      
      CloseList()
      CloseList()
      SetText(Container(10, 45, 70, 180), "11" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "12" ) 
      SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets), "13" ) 
      SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets), "14" ) 
      SetText(Container(10, 45, 70, 180), "15" ) 
      SetText(Container(10, 5, 70, 180), "16" ) 
      SetText(Container(10, 5, 70, 180), "17" ) 
      SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets), "18" ) 
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
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 13
; Folding = ---
; EnableXP