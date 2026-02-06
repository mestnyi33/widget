XIncludeFile "../../../widgets.pbi" 

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define vertical = 0
   Global._s_WIDGET *g1, *g2, *Spin1,*Spin2,*Spin3
   
   ; Test( x.l, y.l, width.l, height.l, Min.l, Max.l.l, flag.q = 0, round.l = 0 )
   Define min = - 3
   Define max = 3
   Define event = #__event_LeftClick
   
   Procedure button_events( )
      Protected state = GetState( *Spin2 )
      Debug "click " + MouseClick( )
      
      Select EventWidget( )
         Case *g1
            state - 1
         Case *g2
            state + 1
      EndSelect
      
      If SetState( *Spin2, state )
         ;       Debug ""+
         ;             *Spin2\bar\button[1]\disable +" "+ 
         ;             *Spin2\bar\button[2]\disable
      EndIf
   EndProcedure
   
   Procedure change_events( )
      If Events( ) = #__event_Change
         SetWindowTitle( EventWindow(), "stste ["+Str(GetState( *Spin2 ))+"]" )
         Disable( *g1, *Spin2\bar\button[1]\disable )
         Disable( *g2, *Spin2\bar\button[2]\disable )
         Debug " -changestate- " + Widget( )\class
      EndIf
   EndProcedure
   
   Procedure Test( X,Y,Width,Height, param1,param2, Flag.q=0)
      Protected._s_WIDGET *g
      *g = Spin( X,Y,Width,Height, param1,param2, Flag.q )
      ;*g = Scroll( X,Y,Width,Height, param1,param2, Flag.q )
      
      ProcedureReturn *g
   EndProcedure
   
   If vertical
      ;\\ vertical
      If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         *Spin1 = Test(20, 50, 50, 250,  0, 30, #__flag_Vertical|#__flag_Invert)
         
         *g1=Button(90, 10, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
         *Spin2 = Test(80, 50, 50, 250,  min, max, #__flag_Vertical) : Bind( *Spin2, @change_events( ), #__event_Change)
         *g2=Button(90, 310, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
         
         *Spin3 = Test(140, 50, 50, 250,  0, 30, #__flag_Vertical)
         
         Debug " -setstate-v "
         SetState(*Spin1, 5)
         ; SetState(*Spin2, 0)
         SetState(*Spin3, 5)
         
         WaitClose( )
      EndIf
   Else
      
      ;\\ horizontal
      If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         *Spin1 = Test(50, 20, 250, 50,  1, 3)
         
         *g1=Button(10, 90, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
         *Spin2 = Test(50, 80, 250, 50,  min, max ) ;: Bind( *Spin2, @change_events( ), #__event_Change)
         *g2=Button(310, 90, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
         
         *Spin3 = Test(50, 140, 250, 50,  1, 3, #__flag_Invert)
         
         Debug " -setstate-h "
         SetState(*Spin1, 2)
         ; SetState(*Spin2, 0)
         SetState(*Spin3, 2)
         
         WaitClose( @change_events( ))
      EndIf
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 38
; FirstLine = 21
; Folding = --
; EnableXP
; DPIAware