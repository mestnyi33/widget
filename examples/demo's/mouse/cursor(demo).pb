XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   test_docursor = 1
   test_changecursor = 1
   test_setcursor = 1
   #_DD_reParent = 1<<2
   
   Global btn1, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   Procedure events_widgets( )
      Protected drop, source, selectedIndex, selectedText$
      
      Select WidgetEvent( )
         Case #__event_DragStart      
            
            Select EventWidget( )         
               Case btn1, Button_0    
                  Debug "event( DRAGSTART )"
                  
                  If EventWidget( ) = btn1
                     If DDragPrivate( #_DD_reParent )
                        ChangeCurrentCursor( btn1, #PB_Cursor_Arrows ) 
                     EndIf
                  Else
                     selectedIndex = GetState(EventWidget())           
                     selectedText$ = GetItemText(EventWidget(), selectedIndex)
                     DDragText(selectedText$)                                           
                  EndIf
            EndSelect
            
         Case #__event_Drop   
            Debug "event( DROP )"
            
         Case #__event_Cursor      
            Debug Index(EventWidget( ))
            ProcedureReturn #__cursor_Hand
      EndSelect
      
   EndProcedure
   
   If Open(0, 0, 0, 430, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetBackgroundColor(widget(), $FFAC97DB)
      
      ;\\
      a_init(root( ))
      Window(230,10,180,100,"form1")
         btn1 = Button(10,10,110,80, "btn1") 
      CloseList( )
      
      ;\\
      Splitter_1 = Splitter(30, 10, 180, 100, -1, -1, #PB_Splitter_Vertical)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      Splitter_2 = Splitter(30, 10, 180, 100, Splitter_1, -1)
      ;SetFrame( Splitter_1, 20)
      
      Button_0 = Button(30,120,110,80, "Button 0") 
      Button_1 = Button(80,130,80,40, "Button 1")
      Button_2 = Button(120,120,110,80, "Button 2") 
      Button_3 = String(180,120,110,80, "String") 
      SetFrame( Button_3, 20)
      Button_4 = String(250,120,110,80, "String") 
      Button_5 = Button(320,120,110,80, "Button 3") 
      
      Disable( Button_1, 1 )
      
      SetCursor( Button_0, #__cursor_Hand )
      SetCursor( Button_1, #__cursor_Cross )
      SetCursor( Button_2, #__cursor_IBeam )
      
      EnableDDrop(Button_1, #PB_Drop_Text, #PB_Drag_Copy)
      EnableDDrop(Button_4, #PB_Drop_Text, #PB_Drag_Copy)
      EnableDDrop(Button_5, #PB_Drop_Text, #PB_Drag_Copy)
      Bind( #PB_All, @events_widgets( ), #__event_DragStart )
      Bind( #PB_All, @events_widgets( ), #__event_Drop )
      
      SetMoveBounds( btn1, -1,-1,-1,-1 )
      SetMoveBounds( Button_0, -1,-1,-1,-1 )
      
      ;\\ change current cursor
      ; Bind( #PB_All, @events_widgets( ), #__event_Cursor )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = +-
; EnableXP
; DPIAware