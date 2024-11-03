 XIncludeFile "../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global object1, object2, object3, parent, width = 60
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  
  ;\\
  parent = Container(50, 50, 500, 500)
  
  object1 = Text(50, 50, width, 150, "thisis text element", #__flag_textwordwrap)
  object2 = String(100, 150, width, 150, "thisis text element", #__flag_textwordwrap)
  object3 = Editor(150, 250, width, 150, #__flag_textwordwrap) : SetText(object3, "thisis text element")
  
;   a_free( object1 )
;   a_free( object2 )
;   a_free( object3 )a
  
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
; CursorPosition = 44
; FirstLine = 40
; Folding = -
; EnableXP