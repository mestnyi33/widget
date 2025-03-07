XIncludeFile "../../../widgets.pbi"
;bug когда с левого якорья переходит на сам сплиттер 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_docursor = 1
   test_changecursor = 1
   test_setcursor = 1
   
   Global object, object1, object2, parent
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   Define fs = 10
   ;\\
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
   parent = Container(50, 50, 500, 500)
   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
   SetColor(parent, #pb_gadget_backcolor, $FFE9E9E9)
   
   ;\\
   object = Button(50, 50, 150, 150, "button")
   object1 = String(150, 150, 150, 150, "string")
   object2 = Splitter(250, 250, 150, 150, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
   
;    ;\\
;    object = Splitter(50, 50, 150, 150, #PB_Default, Button(50, 50, 80, 50,"02") )
;    object1 = Splitter(150, 150, 150, 150, Button(10, 10, 80, 50,"01"), #PB_Default )
;    object2 = Splitter(250, 250, 150, 150, #PB_Default, #PB_Default )
;    
   
   ;   ;\\
   ;   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
   
   ;\\
   Define anchor_size = 30
   a_set(parent, #__a_full, anchor_size/2)
   If object
      a_set(object, #__a_full, anchor_size)
   EndIf
   If object1
      a_set(object1, #__a_full, anchor_size)
   EndIf
   If object2
      a_set(object2, #__a_full, anchor_size)
   EndIf
   
   ;\\
   If object
      ;SetSizeBounds(object, anchor_size*2, anchor_size*2, 360, 360)
      SetMoveBounds(object, 0, 0, 500, 500)
   EndIf
   
   ;\\
   Bind( parent, @CustomEvents(), #__event_statuschange )
   Bind( parent, @CustomEvents(), #__event_resize )
   
   ;\\
   If object
      Bind( object, @CustomEvents(), #__event_statuschange )
      Bind( object, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   If object1
      Bind( object1, @CustomEvents(), #__event_statuschange )
      Bind( object1, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   If object2
      Bind( object2, @CustomEvents(), #__event_statuschange )
      Bind( object2, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
             
         Case #__event_statuschange
            Debug "statuschange "
            
         Case #__event_resize
            Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware