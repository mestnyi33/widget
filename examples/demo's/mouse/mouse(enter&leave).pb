 XIncludeFile "../../../widgets.pbi"
; ;bug когда переходишь с якорья который находится под обЬектом не убираются якорья

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Declare CustomEvents( )
   Global object, object1, object2, object3, parent
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 4)
   
   ;\\
   parent = Window(50, 50, 450, 450, "parent", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   SetColor(parent, #__color_back, $FFAC97DB)
   SetFrame(parent, 20 )
   
   ;\\
   object = ScrollArea(50, 50, 150, 150, 300,300,1, #__flag_noGadgets) : SetFrame( object, 30)
   object1 = Button(125, 140, 150, 150, "Button")
   object2 = Splitter(250, 50, 150, 150, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
   object3 = ScrollArea(0, 250, 150, 150, 300,300,1, #__flag_noGadgets) : SetFrame( object3, 0)
   

   ;\\
   Define anchor_size = 30
   a_set(parent, #__a_full|#__a_zoom, anchor_size/2)
   a_set(object, #__a_full, anchor_size)
   a_set(object1, #__a_full, anchor_size)
   a_set(object2, #__a_full, anchor_size)
   a_set(object3, #__a_full, anchor_size)
   
   DisableExplicit
   Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   Button_4   = Progress(0, 0, 0, 0, 0, 100) : SetState(Button_4, 50) ; No need to specify size or coordinates
   Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
   Button_5   = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
   Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
   Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = widget::Splitter(180, 310, 250, 120, 0, Splitter_4, #PB_Splitter_Vertical)
   SetState(Splitter_5, 50)
   SetState(Splitter_4, 50)
   SetState(Splitter_3, 40)
   SetState(Splitter_1, 50)
   
   SetClass( Splitter_1, "Splitter_1")
   SetClass( Splitter_2, "Splitter_2")
   SetClass( Splitter_3, "Splitter_3")
   SetClass( Splitter_4, "Splitter_4")
   SetClass( Splitter_5, "Splitter_5")
   
   
   Bind( #PB_All, @CustomEvents( ), #__event_MouseEnter )
   Bind( #PB_All, @CustomEvents( ), #__event_MouseLeave )
  
   ;\\
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
         Case #__event_MouseEnter
            Debug "enter " + EventWidget( )\class
           
         Case #__event_MouseLeave
            Debug "leave " + EventWidget( )\class
            
      EndSelect
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; Folding = -
; EnableXP
; DPIAware