 XIncludeFile "../../../widgets.pbi"
; ;bug когда переходишь с якорья который находится под обЬектом не убираются якорья

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global object, object1, object2, parent
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   
   ;\\
   parent = Window(50, 50, 450, 450, "parent", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   SetColor(parent, #__color_back, $FFE9E9E9)
   SetFrame(parent, 20 )
   ;a_init(parent, 4)
   
   ;\\
   object = ScrollArea(50, 50, 150, 150, 300,300,1, #__flag_noGadgets) : SetFrame( object, 0)
   ;object = Button(50, 50, 150, 150, "button")
   ;;object1 = Button(150, 150, 150, 150, "Button")
   object1 = Button(125, 140, 150, 150, "Button")
   ;object1 = String(150, 150, 150, 150, "string")
   object2 = Splitter(250, 250, 150, 150, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
   

   ;\\
   Define anchor_size = 30
   a_set(parent, #__a_full|#__a_zoom, anchor_size/2)
   a_set(object, #__a_full, anchor_size)
   a_set(object1, #__a_full, anchor_size)
   a_set(object2, #__a_full, anchor_size)
   
   ;\\
   Bind( parent, @CustomEvents(), #__event_cursor )
;    Bind( object, @CustomEvents(), #__event_cursor )
;    Bind( object1, @CustomEvents(), #__event_cursor )
;    Bind( object2, @CustomEvents(), #__event_cursor )
   
   ;\\
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEventType( )
            
            ;\\ demo change current cursor
         Case #__event_cursor
           ; Debug " SETCURSOR " + EventWidget( )\class +" "+ GetCursor( )
            
            If EventWidget( ) = object2
               If a_transform( )
                  If GetCursor( )
                     If a_index( )
                        ProcedureReturn cursor::#__cursor_Hand
                     Else
                        ProcedureReturn cursor::#__cursor_Cross
                     EndIf
                  EndIf
               EndIf
            EndIf
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 31
; FirstLine = 8
; Folding = --
; EnableXP