;-
XIncludeFile "../../../widgets.pbi"

;\\ cursor anchor example
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global object, parent
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   Define fs = 20
   ;\\
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
   parent = Container(50, 50, 500, 500)
   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
   SetColor(parent, #__color_back, $FFE9E9E9)
   
   ;\\
   ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
   ; object = Container(100, 100, 250, 250) : CloseList()
   ;object = String(100, 100, 250, 250, "string", #__flag_borderless)
   object = Button(100, 100, 250, 250, "button", #__flag_borderless)
   
   ;   ;\\
   ;   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
   
   ;\\
   a_set(parent, #__a_full, 40)
   a_set(object, #__a_full, 40)
   
   ;\\
   SizeBounds(object, 80, 80, 501-fs*2, 501-fs*2)
   ;MoveBounds(object, fs, fs, 501-fs, 501-fs)
   MoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
   
   ;\\
   Bind( widget( ), @CustomEvents(), #__event_statuschange )
   Bind( widget( ), @CustomEvents(), #__event_resize )
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEventType( )
            
         Case #__event_statuschange
            Debug "statuschange "
            
         Case #__event_resize
            Debug "resize "+EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 2
; Folding = -
; EnableXP