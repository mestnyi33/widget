XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   test_docursor = 1
   test_changecursor = 1
   test_setcursor = 1
   #_DD_reParent = 1<<2
   
   Global form1, btn1, btn2, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   Procedure CustomDrawing( )
      Protected *e._S_Widget = EventWidget()
      With *e
         DrawingMode(#PB_2DDrawing_Default)
         If *e = Button_3
            Box(\x,\y,\width,\height, $74F6FE)
         EndIf
         If *e = Button_4
            Box(\x,\y,\width,\height, $F674FE)
         EndIf
         Box(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FFFFFF)
      EndWith
   EndProcedure
   
   Procedure events_widgets( )
      Protected drop, source, selectedIndex, selectedText$
      
      Select WidgetEvent( )
         Case #__event_DragStart      
            If EventWidget( ) = form1
               ChangeCursor( form1, #PB_Cursor_Cross ) 
            EndIf
            
            If EventWidget( ) = btn1
               If DragDropPrivate( #_DD_reParent )
                  ChangeCursor( btn1, #PB_Cursor_Denied ) 
               EndIf
            EndIf
            
            If EventWidget( ) = Button_0    
               Debug "event( DRAGSTART )"
               
               selectedIndex = GetState(EventWidget())           
               selectedText$ = GetItemText(EventWidget(), selectedIndex)
               DragDropText(selectedText$)   
               ;ChangeCursor( Button_0, #PB_Cursor_Hand ) 
            EndIf
            
         Case #__event_Drop   
            Debug "event( DROP )"
            
         Case #__event_Cursor      
            Debug Index(EventWidget( ))
            ProcedureReturn #__cursor_Hand
      EndSelect
      
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetBackColor(widget(), $FFAC97DB)
      
      ;\\
      form1 = Window(200,10,200,110,"form1")
         a_init(widget( ))
         btn1 = Button(10,10,80,50, "btn1") 
         SetCursor( btn1, #__cursor_Hand )
         btn2 = Button(60,40,80,50, "btn2") 
         Disable( btn2, 1 )
         SetMoveBounds( btn1, -1,-1,-1,-1 )
      CloseList( )
      
      ;\\
      Splitter_1 = Splitter(10, 10, 180, 120, -1, -1, #PB_Splitter_Vertical) : SetClass( widget(), "1")
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      Splitter_2 = Splitter(10, 10, 180, 120, Splitter_1, -1) : SetClass( widget(), "2")
      ;SetFrame( Splitter_1, 20)
      
      Button_0 = Button(10,140,110,80, "drag", #__flag_text_left) : SetClass( widget(), GetText(widget()))
      Button_1 = Button(60,150,80,40, "disable") : SetClass( widget(), GetText(widget()))
      Button_2 = Button(100,140,110,80, "Ibeam") : SetClass( widget(), GetText(widget())) 
      Button_3 = String(160,140,110,80, "framestring") : SetClass( widget(), GetText(widget())) 
      SetFrame( Button_3, 20)
      Button_4 = String(230,140,110,80, "string") : SetClass( widget(), GetText(widget())) 
      Button_5 = Button(300,140,110,80, "drop", #__flag_text_Right) : SetClass( widget(), GetText(widget())) 
      
      Disable( Button_1, 1 )
      
      SetCursor( Button_0, #__cursor_Hand )
      SetCursor( Button_1, #__cursor_Cross )
      SetCursor( Button_2, #__cursor_IBeam )
      
      EnableDrop(Button_1, #PB_Drop_Text, #PB_Drag_Copy)
      EnableDrop(Button_4, #PB_Drop_Text, #PB_Drag_Copy)
      EnableDrop(Button_5, #PB_Drop_Text, #PB_Drag_Copy)
      ;
      Bind( #PB_All, @events_widgets( ), #__event_DragStart )
      Bind( #PB_All, @events_widgets( ), #__event_Drop )
      Bind(Button_3, @CustomDrawing(), #__event_Draw)
      Bind(Button_4, @CustomDrawing(), #__event_Draw)
      
      ;\\ change current cursor
      ; Bind( #PB_All, @events_widgets( ), #__event_Cursor )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 46
; FirstLine = 42
; Folding = --
; EnableXP
; DPIAware