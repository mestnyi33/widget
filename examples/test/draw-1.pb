;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../widgets.pbi" : UseWidgets( )
   EnableExplicit
   Global Event, Progress, Scroll
   
   Procedure scrolled( )
      Debug ""+GetState( Scroll ) +" "+ EventWidget( )\bar\page\change 
      SetState( Progress, GetState( Scroll ))
   EndProcedure
   
   If Open(0, 0, 0, 995, 605, "demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Progress = ProgressBarWidget(10, 150, 975,95,0,100, 0) 
      ; SetState(progress, 50)
      
      Scroll = ScrollBarWidget(10, 250, 975,95,0,120,20) 
      SetState(Scroll, 50)
      
      ;\\
      Bind(Scroll, @scrolled(), #__event_Change )
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = -
; EnableXP