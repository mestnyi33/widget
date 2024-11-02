 XIncludeFile "../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object1, object2, object3, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  
  ;\\
  parent = Container(50, 50, 500, 500)
  
  object1 = Button(50, 50, 30, 150, "button")
  object2 = Button(100, 150, 30, 150, "button wordwrap text", #__flag_textwordwrap)
  object3 = Button(150, 250, 30, 150, "button"+#LF$+" multiline "+#LF$+"text", #__flag_textmultiline)
  
  
  ;\\
  Bind( parent, @CustomEvents(), #__event_statuschange )
  Bind( parent, @CustomEvents(), #__event_resize )
  
  ;\\
  Bind( object1, @CustomEvents(), #__event_statuschange )
  Bind( object1, @CustomEvents(), #__event_resize )
  Bind( object2, @CustomEvents(), #__event_statuschange )
  Bind( object2, @CustomEvents(), #__event_resize )
  Bind( object3, @CustomEvents(), #__event_statuschange )
  Bind( object3, @CustomEvents(), #__event_resize )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
          
       Case #__event_statuschange
          If EventWidget( )\hide=0;show
             Debug "statuschange "
          EndIf
          
       Case #__event_resize
         ; Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
          
    EndSelect
 EndProcedure
 
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware