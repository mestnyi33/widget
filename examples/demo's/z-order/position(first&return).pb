
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
   Global after
   Global before
   Global before1, after1 
   Global  pos_x = 10
   Global._S_widget *PARENT, *WINDOW, *CONTAINER, *SCROLLAREA, *CONTAINER_0, *SCROLLAREA_0
   Global._S_widget *CHILD, *WINDOW_0, *PARENT0, *PARENT1, *PARENT2, *PARENT_0, *PARENT_1, *PARENT_2
   
   UsePNGImageDecoder()
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   Procedure widget_events()
      Select WidgetEvent( )
         Case #__Event_LeftDown 
            ClearDebugOutput( )
            before = GetPosition(EventWidget( ), #PB_List_Before)
            after = GetPosition(EventWidget( ), #PB_List_After)
            
            If before
               Debug "Before - "+GetClass(before)
               SetPosition( EventWidget( ), #PB_List_First)
            EndIf
            If after
               Debug "After - "+GetClass(after)
            EndIf
            
            Debug "--- enumerate all gadgets ---"
            If StartEnum( EventWidget( )\parent, EventWidget( )\tabindex( ) )
               If Not is_window_( widget(  ) )
                  Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
               EndIf
               StopEnum( )
            EndIf
            
         Case #__Event_LeftUp
            If before
               ClearDebugOutput( )
               SetPosition( EventWidget( ), #PB_List_After, before)
               
               Debug " --- up "
               before = GetPosition(EventWidget( ), #PB_List_Before)
               after = GetPosition(EventWidget( ), #PB_List_After)
               
               If before
                  Debug "Before - "+GetClass(before)
               EndIf
               If after
                  Debug "After - "+GetClass(after)
               EndIf
               
               Debug "--- enumerate all gadgets ---"
               If StartEnum( EventWidget( )\parent, EventWidget( )\tabindex( ) )
                  If Not is_window_( widget(  ) )
                     Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
                  EndIf
                  StopEnum( )
               EndIf
            EndIf
      EndSelect
   EndProcedure
   
   Procedure CreateWidget( X,Y,Width,Height, Text.s )
      Protected *PARENT 
      *PARENT = Button( X,Y,Width,Height, Text ) 
      SetClass(*PARENT, Text )
      ProcedureReturn *PARENT
   EndProcedure
   
   If Open( 10, 0, 0, 260, 270, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PARENT = Panel(10,10,240,250)  : SetClass(*PARENT, "PANEL") 
      AddItem(*PARENT, -1, "item (0)")
      ;
      CreateWidget(10,10,100,90, "(Panel(0))")
      CreateWidget(30,30,100,90, "((0>))")
      CreateWidget(50,50,100,90, "((0>>))") 
      ;
      AddItem(*PARENT, -1, "item (1)")
      ;       ;
      ;       CreateWidget(30,10,100,90, "(Panel(1))")
      ;       CreateWidget(50,30,100,90, "((1>))")
      ;       CreateWidget(70,50,100,90, "((1>>))") 
      ;       ;
      AddItem(*PARENT, -1, "item (2)") 
      ;
      CreateWidget(50,10,100,90, "(Panel(2))")
      CreateWidget(70,30,100,90, "((2>))")
      CreateWidget(90,50,100,90, "((2>>))") 
      
      CloseList( )
      
      SetState( *PARENT, 2 )
      
      If StartEnum( *PARENT )
         Bind(widget( ), @widget_events( ), #__Event_LeftDown)
         Bind(widget( ), @widget_events( ), #__Event_LeftUp)
         ;
         StopEnum( )
      EndIf
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 110
; FirstLine = 102
; Folding = ----
; EnableXP
; DPIAware