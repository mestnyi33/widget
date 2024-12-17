
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
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
   
   Procedure OpenGadget( X,Y,Width,Height, Text.s )
      Protected *PARENT 
      *PARENT = Container( X,Y,Width,Height ) 
      SetClass(*PARENT, Text )
      SetText(*PARENT, Text )
      ProcedureReturn *PARENT
   EndProcedure
   
   If Open(10, 0, 0, 260, 270, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PARENT = Panel(10,10,240,160)  : SetClass(*PARENT, "PANEL") 
      AddItem(*PARENT, -1, "item (0)")
      ;              ;
      ;              OpenGadget(10,20,220,80, "(Panel(0))")
      ;              OpenGadget(10,20,220,80, "((0>))")
      ;              OpenGadget(10,20,220,80, "((0>>))") : CloseList( )
      ;              CloseList( )
      ;              CloseList( )
      ;              ;
      AddItem(*PARENT, -1, "item (1)")
      ;       ;
      ;       OpenGadget(10,20,220,80, "(Panel(1))")
      ;       OpenGadget(10,20,220,80, "((1>))")
      ;       OpenGadget(10,20,220,80, "((1>>))") : CloseList( )
      ;       CloseList( )
      ;       CloseList( )
      ;       ;
      AddItem(*PARENT, -1, "item (2)") ;: *PARENT_2 = Button(20,90,220,60,"(Panel(2))") : SetClass(*PARENT_2, GetText(*PARENT_2)) 
                                       ;
      OpenGadget(10,20,220,80, "(Panel(2))")
      OpenGadget(10,20,220,80, "((2>))")
      OpenGadget(10,20,220,80, "((2>>))") : CloseList( )
      CloseList( )
      CloseList( )
      
      CloseList()
      
      ;
      Debug ">"
      OpenList( *PARENT, 0 )
      OpenGadget(10,20,220,80, "(Panel(0))")
      OpenGadget(10,20,220,80, "((0>))")
      OpenGadget(10,20,220,80, "((0>>))") : CloseList( )
      CloseList( )
      CloseList( )
      CloseList( )
      Debug "<"
      
      ;\\
      *CHILD = OpenGadget(10,180,240,80, "CHILD") 
      OpenGadget(10,20,240,80, "(CH>)") 
      OpenGadget(10,20,240,80, "(CH>>)") 
      Button(5,20,60,20,"(CH>>>0)") : SetClass(widget(), "(CH>>>0)")  
      Button(70,20,60,20,"(CH>>>1)") : SetClass(widget(), "(CH>>>1)")  
      Button(135,20,60,20,"(CH>>>2)") : SetClass(widget(), "(CH>>>2)")  
      CloseList( )
      CloseList( )
      CloseList( )
      ;  
      
      
      Debug "--- enumerate all gadgets ---"
      If StartEnum( root( ) )
         If Not is_window_( widget(  ) )
            Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
         EndIf
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all gadgets PANEL ---"
      If StartEnum( *PARENT )
         Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 0) PANEL ---"
      If StartEnum( *PARENT, 0 )
         Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 1) PANEL ---"
      If StartEnum( *PARENT, 1 )
         Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 2) PANEL ---"
      If StartEnum( *PARENT, 2 )
         Debug "     gadget - "+ Index( widget( ) ) +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 85
; FirstLine = 87
; Folding = --
; EnableXP
; DPIAware