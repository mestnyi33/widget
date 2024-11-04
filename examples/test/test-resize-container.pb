XIncludeFile "../../widgets.pbi"
; fixed 778 commit
;-

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Declare ParentEvents( )
   Declare ObjectEvents( )
   Global object1, object2, object3, parent
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   
   ;\\
   parent = Container(50, 50, 200, 500)
   
   object1 = Text(10, 10, 30, 150, "thisis text element", #__flag_Textwordwrap)
   object2 = String(10, 170, 30, 150, "thisis text element", #__flag_Textwordwrap)
   object3 = Editor(10, 330, 30, 150, #__flag_Textwordwrap) : SetText(object3, "thisis text element")
   
   SetColor(object1, #__color_back, $FFC2C2C2)
   SetColor(object2, #__color_back, $FFC2C2C2)
   SetColor(object3, #__color_back, $FFC2C2C2)
   
   a_free( object1 )
   a_free( object2 )
   a_free( object3 )
   
   ;\\
   Bind( parent, @ParentEvents(), #__event_resize )
   
   ;\\
   Bind( object1, @ObjectEvents(), #__event_resize )
   Bind( object2, @ObjectEvents(), #__event_resize )
   Bind( object3, @ObjectEvents(), #__event_resize )
   WaitClose( )
   
   ;\\
   Procedure ParentEvents( )
      Protected width 
      Select WidgetEvent( )
         Case #__event_resize
            width = WidgetWidth( EventWidget( ), #__c_inner ) - 20
            
            Debug ">"
            Resize( object1, #PB_Ignore, #PB_Ignore, width, #PB_Ignore) 
            Resize( object2, #PB_Ignore, #PB_Ignore, width, #PB_Ignore) 
            Resize( object3, #PB_Ignore, #PB_Ignore, width, #PB_Ignore) 
            Debug "<"
            Debug "---"
      EndSelect
   EndProcedure
   
   Procedure ObjectEvents( )
      Select WidgetEvent( )
            
         Case #__event_resize
            Debug "  resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
            
      EndSelect
   EndProcedure
   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 21
; FirstLine = 17
; Folding = -
; EnableXP
; DPIAware