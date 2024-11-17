;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  #CHILD = 5
  Global *enable, *disable, *item1, *item2, *item3, *LIST
  
  Procedure Disable( Gadget, state = #PB_Default )
    If IsGadget(Gadget) 
      If state >= 0
        DisableGadget( Gadget, state )
        SetGadgetData( Gadget, state )
      EndIf
      
      ProcedureReturn GetGadgetData( Gadget )
    EndIf
  EndProcedure
  
  Procedure events( )
    Select EventGadget( ) 
      Case *item1
        SetGadgetState( #CHILD, 0)
      Case *item2
        SetGadgetState( #CHILD, 1)
      Case *item3
        SetGadgetState( #CHILD, 2)
        
      Case *enable
        Debug "enable"
        Disable( #CHILD, 0 )
        Disable( *enable, 1 )
        If Disable( *disable )
          Disable( *disable, 0 )
        EndIf
        
      Case *disable
        Debug "disable"
        Disable( #CHILD, 1 )
        Disable( *disable, 1 )
        If Disable( *enable )
          Disable( *enable, 0 )
        EndIf
        
      Case *LIST
        Select EventType( )
          Case #PB_EventType_LeftClick
            Select GetGadgetState( *LIST )
              Case  1: ButtonGadget( #CHILD,30,20,150,30,"Buttongadget" ) 
              Case  2: StringGadget( #CHILD,30,20,150,30,"Stringgadget" ) 
              Case  3: TextGadget( #CHILD,30,20,150,30,"Textgadget", #PB_Text_Border ) 
              Case  4: OptionGadget( #CHILD,30,20,150,30,"Optiongadget" ) 
              Case  5: CheckBoxGadget( #CHILD,30,20,150,30,"CheckBoxgadget" ) 
              Case  6: ListViewGadget( #CHILD,30,20,150,30 ) 
              Case  7: FrameGadget( #CHILD,30,20,150,30,"Framegadget" ) 
              Case  8: ComboBoxGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"ComboBoxgadget" ): SetGadgetState( #CHILD,0 )
              Case  9: ImageGadget( #CHILD,30,20,150,30,0,#PB_Image_Border ) 
              Case 10: HyperLinkGadget( #CHILD,30,20,150,30,"HyperLinkgadget",0 ) 
              Case 11: ContainerGadget( #CHILD,30,20,150,30,#PB_Container_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( ) ; Containergadget
              Case 12: ListIconGadget( #CHILD,30,20,150,30,"",88 ) 
              Case 13: IPAddressGadget( #CHILD,30,20,150,30 ) 
              Case 14: ProgressBarGadget( #CHILD,30,20,150,30,0,5 )
              Case 15: ScrollBarGadget( #CHILD,30,20,150,30,5,335,9 )
              Case 16: ScrollAreaGadget( #CHILD,30,20,150,30,305,305,9,#PB_ScrollArea_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( )
              Case 17: TrackBarGadget( #CHILD,30,20,150,30,0,5 )
              ;Case 18: WebGadget( #CHILD,30,20,150,30,"" ) ; bug 531 linux
              Case 19: ButtonImageGadget( #CHILD,30,20,150,30,0 )
              Case 20: CalendarGadget( #CHILD,30,20,150,30 ) 
              Case 21: DateGadget( #CHILD,30,20,150,30 )
              Case 22: EditorGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Editorgadget" )
              Case 23: ExplorerListGadget( #CHILD,30,20,150,30,"" )
              Case 24: ExplorerTreeGadget( #CHILD,30,20,150,30,"" )
              Case 25: ExplorerComboGadget( #CHILD,30,20,150,30,"" )
              Case 26: SpinGadget( #CHILD,30,20,150,30,0,5,#PB_Spin_Numeric )
              Case 27: TreeGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Treegadget" ):  AddGadgetItem( #CHILD,-1,"SubLavel",0,1 )
              Case 28: PanelGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"Panel" ): AddGadgetItem( #CHILD,-1,"gadget" ): CloseGadgetList( )
              Case 29 
                ButtonGadget( 201,0,0,30,30,"1" )
                ButtonGadget( 202,0,0,30,30,"2" )
                SplitterGadget( #CHILD,30,20,150,30,201,202 )
            EndSelect
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              Select GetGadgetState( *LIST )
                Case 30: MDIGadget( #CHILD,30,10,150,70,0,0 )
                Case 31: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                Case 32: ShortcutGadget( #CHILD,30,10,150,70,0 )
                Case 33: CanvasGadget( #CHILD,30,10,150,70 ) 
              EndSelect
            CompilerElse
              Select GetGadgetState( *LIST )
                Case 30: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                Case 31: ShortcutGadget( #CHILD,30,10,150,70,0 )
                Case 32: CanvasGadget( #CHILD,30,10,150,70 ) 
              EndSelect
            CompilerEndIf
            
            ResizeGadget( #CHILD,10,40, 280, 150 )
            Disable( #CHILD, 1 )
            Disable( *disable, 1 )
            Disable( *enable, 0 )
            
        EndSelect
        
    EndSelect
    
     Debug " active - "+GetActiveGadget( )
  EndProcedure
  
  If OpenWindow(#PB_Any, 0, 0, 450, 200, "Disable-demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *item1 = ButtonGadget( #PB_Any, 10, 10, 50, 25, "item-1") ;: SetClass( *item1, "button-item-1" )
    *item2 = ButtonGadget( #PB_Any, 60, 10, 50, 25, "item-2") ;: SetClass( *item2, "button-item-2" )
    *item3 = ButtonGadget( #PB_Any, 110, 10, 50, 25, "item-3") ;: SetClass( *item3, "button-item-3" )
    BindGadgetEvent( *item1, @events( ), #PB_EventType_LeftClick )
    BindGadgetEvent( *item2, @events( ), #PB_EventType_LeftClick )
    BindGadgetEvent( *item3, @events( ), #PB_EventType_LeftClick )
    
    *disable = ButtonGadget( #PB_Any, 180, 10, 50, 25, "disable") ;: SetClass( *disable, "button-disable" )
    *enable = ButtonGadget( #PB_Any, 240, 10, 50, 25, "enable") ;: SetClass( *enable, "button-enable" )
    BindGadgetEvent( *enable, @events( ), #PB_EventType_LeftClick )
    BindGadgetEvent( *disable, @events( ), #PB_EventType_LeftClick )
    
ListViewGadget( *LIST,300,10,150,180 ) 
  BindGadgetEvent( *LIST, @events( ), #PB_EventType_LeftClick )
    AddGadgetItem( *LIST, -1, "Selected gadget to move" )
  AddGadgetItem( *LIST, -1, "Buttongadget" )
  AddGadgetItem( *LIST, -1, "Stringgadget" )
  AddGadgetItem( *LIST, -1, "Textgadget" )
  AddGadgetItem( *LIST, -1, "CheckBoxgadget" )
  AddGadgetItem( *LIST, -1, "Optiongadget" )
  AddGadgetItem( *LIST, -1, "ListViewgadget" )
  AddGadgetItem( *LIST, -1, "Framegadget" )
  AddGadgetItem( *LIST, -1, "ComboBoxgadget" )
  AddGadgetItem( *LIST, -1, "Imagegadget" )
  AddGadgetItem( *LIST, -1, "HyperLinkgadget" )
  AddGadgetItem( *LIST, -1, "Containergadget" )
  AddGadgetItem( *LIST, -1, "ListIcongadget" )
  AddGadgetItem( *LIST, -1, "IPAddressgadget" )
  AddGadgetItem( *LIST, -1, "ProgressBargadget" )
  AddGadgetItem( *LIST, -1, "ScrollBargadget" )
  AddGadgetItem( *LIST, -1, "ScrollAreagadget" )
  AddGadgetItem( *LIST, -1, "TrackBargadget" )
  AddGadgetItem( *LIST, -1, "Webgadget" )
  AddGadgetItem( *LIST, -1, "ButtonImagegadget" )
  AddGadgetItem( *LIST, -1, "Calendargadget" )
  AddGadgetItem( *LIST, -1, "Dategadget" )
  AddGadgetItem( *LIST, -1, "Editorgadget" )
  AddGadgetItem( *LIST, -1, "ExplorerListgadget" )
  AddGadgetItem( *LIST, -1, "ExplorerTreegadget" )
  AddGadgetItem( *LIST, -1, "ExplorerCombogadget" )
  AddGadgetItem( *LIST, -1, "Spingadget" )        
  AddGadgetItem( *LIST, -1, "Treegadget" )         
  AddGadgetItem( *LIST, -1, "Panelgadget" )        
  AddGadgetItem( *LIST, -1, "Splittergadget" )    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( *LIST, -1, "MDIgadget" ) 
  CompilerEndIf
  AddGadgetItem( *LIST, -1, "Scintillagadget" ) 
  AddGadgetItem( *LIST, -1, "Shortcutgadget" )  
  AddGadgetItem( *LIST, -1, "Canvasgadget" )    
  
  SetGadgetState( *LIST, #PB_GadgetType_Button );:  PostEvent( #PB_Event_gadget, #CHILD, *LIST, #PB_EventType_Change )
  ButtonGadget( #CHILD, 10,40, 280, 150,"Button") 
    Disable( #CHILD, 1 )
    Disable( *disable, 1 )
    
   
    
    Repeat
      Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; FirstLine = 2
; Folding = ---
; EnableXP