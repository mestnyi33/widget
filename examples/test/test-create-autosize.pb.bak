XIncludeFile "../../widgets.pbi"
;bug когда с левого якорья переходит на сам сплиттер 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global object, object1, object2, parent
   Declare CustomEvents( )
   Global m.s=#LF$, Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   
   ;\\
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
   parent = Container(50, 50, 500, 500)
   SetFrame(parent, 10)
   
   
   ;\\
   object = Editor(0, 0, 0, 0, #__flag_autosize)
  ;object = Editor(50, 50, 150, 150, #__flag_autosize)
;    object1 = String(150, 150, 150, 150, "string")
;    object2 = Splitter(250, 250, 150, 150, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
   
;    ;\\
;    object = Splitter(50, 50, 150, 150, #PB_Default, Button(50, 50, 80, 50,"02") )
;    object1 = Splitter(150, 150, 150, 150, Button(10, 10, 80, 50,"01"), #PB_Default )
;    object2 = Splitter(250, 250, 150, 150, #PB_Default, #PB_Default )
 SetText( object, Text)
   
   ;   ;\\
   ;   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
   
   ;\\
   Define anchor_size = 30
   a_set(parent, #__a_full, anchor_size)
   If object
      a_set(object, #__a_full, anchor_size)
   EndIf
   If object1
      a_set(object1, #__a_full, anchor_size)
   EndIf
   If object2
      a_set(object2, #__a_full, anchor_size)
   EndIf
   
;    ;\\
;    If object
;       SizeBounds(object, anchor_size*2, anchor_size*2, 360, 360)
;       MoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
;    EndIf
   
   ;\\
   Bind( parent, @CustomEvents(), #__event_statuschange )
   Bind( parent, @CustomEvents(), #__event_resize )
   
   ;\\
   If object
      Bind( object, @CustomEvents(), #__event_cursor )
      Bind( object, @CustomEvents(), #__event_statuschange )
      Bind( object, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   If object1
      Bind( object1, @CustomEvents(), #__event_cursor )
      Bind( object1, @CustomEvents(), #__event_statuschange )
      Bind( object1, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   If object2
      Bind( object2, @CustomEvents(), #__event_cursor )
      Bind( object2, @CustomEvents(), #__event_statuschange )
      Bind( object2, @CustomEvents(), #__event_resize )
   EndIf
   
   ;\\
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
            
         Case #__event_cursor
           ; Debug "cursorchange "
            
         Case #__event_statuschange
            Debug "statuschange "
            
         Case #__event_resize
            Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 100
; FirstLine = 91
; Folding = --
; EnableXP