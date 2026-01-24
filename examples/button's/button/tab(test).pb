IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global size = 27
   Global size2 = 130
   Global *g, *g1, *g2, *g3, *g4
   
   Procedure change_events( )
      Protected size = GetState( EventWidget( ))
      SetWindowTitle(EventWindow(), Str(size))
      
      Resize( *g1, 10+size, #PB_Ignore, #PB_Ignore, size )
      Resize( *g2, #PB_Ignore, 10+size, size, #PB_Ignore )
      Resize( *g3, size2+10+size, 10+size, size, #PB_Ignore )
      Resize( *g4, 10+size, size2+10+size, #PB_Ignore, size )
   EndProcedure
   
   Procedure Test( X,Y,Width,Height,txt$, Flag.q=0)
      Protected._s_WIDGET *g
      
      If Flag & #__flag_Vertical And Flag & #__flag_Invert
         Flag | #__flag_Right
      ElseIf Flag & #__flag_Vertical
         Flag | #__flag_Left
      ElseIf Flag & #__flag_Invert
         Flag | #__flag_Bottom
      EndIf
      
      ;*g = Button( X,Y,Width,Height,txt$, Flag)
      *g = Panel( X,Y,Width,Height, Flag) : AddItem( *g,-1,txt$ ):CloseList()
      
      ProcedureReturn *g
    EndProcedure
   
   If Open( 0, 0, 0, 300, 300, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *g1 = Test( 10+size, 10, size2, size, "top button" )
      *g2 = Test( 10, 10+size, size, size2, "left button", #__flag_Vertical)
      *g3 = Test( size2+10+size, 10+size, size, size2, "right button", #__flag_Vertical|#__flag_Invert)
      *g4 = Test( 10+size, size2+10+size, size2, size, "bottom button", #__flag_Invert)
      
      *g = Track( 10, 300-10-20, 280, 20, 0, 50 )
      SetState( *g, size )
      Bind( *g, @change_events( ), #__event_Change )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP
; DPIAware