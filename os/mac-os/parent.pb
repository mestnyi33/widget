DeclareModule Parent
  Declare GetParentID( Handle )
  Declare GetWindowID( Handle )
  
  Declare GetWindow( Gadget )
  Declare GetParent( Gadget )
  Declare SetParent( Gadget, ParentID, Item = #PB_Default )
EndDeclareModule

Module Parent
  Import ""
    PB_Window_GetID(hWnd) 
  EndImport
  
  Procedure.s GetClass( handle.i )
    Protected Result
    
    CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
    
    If Result
      ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  Procedure NSView( GadgetID )
    Protected handle
    
    Select GetClass( GadgetID )
      Case "PBEditorGadgetTextView", "PBScintillaView", "PBListViewTableView", "PBTreeOutlineView", 
           "PB_NSTextField", "PB_NSTableView", "PB_NSOutlineView", "PB_WebView"
        handle = GadgetID
        
        While handle
          Select GetClass( handle )
            Case "PB_SpinView", "PBTreeScrollView", "PBWebScrollView", "NSScrollView", "NSBox"
              GadgetID = handle
              Break
            Default
              handle = CocoaMessage( 0, handle, "superview" )
          EndSelect
        Wend
    EndSelect
    
    ProcedureReturn GadgetID
  EndProcedure
  
  Procedure IDWindow(Handle)
    ProcedureReturn PB_Window_GetID(Handle)
  EndProcedure
  
  Procedure IDGadget(Handle)
    ProcedureReturn CocoaMessage( 0, Handle, "tag" )
  EndProcedure
  
  Procedure GetWindowID( Handle ) ; Return the handle of the parent window from the handle
    ProcedureReturn CocoaMessage( 0, Handle, "window" )
  EndProcedure
  
  Procedure GetParentID( Handle ) ; Return the handle of the parent from the gadget handle
    Protected GadgetID
    Protected WindowID
    
    While Handle
      GadgetID = Handle
      Handle = CocoaMessage( 0, Handle, "superview" )
      
      If Handle
        WindowID = GetWindowID( Handle )
        
        If WindowID 
          If CocoaMessage( 0, WindowID, "contentView" ) = Handle
            ProcedureReturn WindowID
          Else
            ProcedureReturn CocoaMessage( 0, CocoaMessage( 0, NSView( GadgetID ), "superview" ), "superview" )
          EndIf
        EndIf
      EndIf
    Wend
  EndProcedure
  
  Procedure GetWindow( Gadget ) ; Return the id of the parent window from the gadget id
    If IsGadget( Gadget )
      ProcedureReturn IDWindow( GetWindowID( GadgetID( Gadget ) ) )
    EndIf
  EndProcedure
  
  Procedure GetParent( Gadget ) ; Return the id of the parent gadget from the gadget id
    If IsGadget( Gadget )
      Protected GadgetID = GadgetID( Gadget )  
      Protected handle = GetParentID( GadgetID )
      Protected WindowID = GetWindowID( GadgetID )
      
      If WindowID = handle
        ProcedureReturn - 1 ; IDWindow( handle )
      Else
        ProcedureReturn IDGadget( handle )
      EndIf
    EndIf
  EndProcedure
  
  Procedure SetParent( Gadget, ParentID, Item = #PB_Default ) ; Set a new parent for the gadget
    Protected GadgetID =  GadgetID ( Gadget )
    
    If IsGadget( Gadget )
      If ParentID
        Select GetClass( ParentID )
          Case "PBTabView"
            Protected Panel = IDGadget( ParentID )
            Protected i = item
            If item <> #PB_Default
              i = GetGadgetState( Panel )
            EndIf
            If i <> item 
              SetGadgetState( Panel, item )
            EndIf
            ParentID = CocoaMessage( 0, ParentID, "subviews" )
            ParentID = CocoaMessage( 0, ParentID, "objectAtIndex:", CocoaMessage( 0, ParentID, "count" ) - 1 )
            If i <> item 
              SetGadgetState( Panel, i )
            EndIf
          Case "PB_CanvasView"
            ParentID = CocoaMessage( 0, ParentID, "subviews" )
            ParentID = CocoaMessage( 0, ParentID, "objectAtIndex:", CocoaMessage( 0, ParentID, "count" ) - 1 )
          Default
            ParentID = CocoaMessage( 0, ParentID, "contentView" )
        EndSelect
        
        CocoaMessage ( 0, ParentID, "addSubview:", NSView( GadgetID ) ) 
      Else
        ; to desktop move
      EndIf
      
      ProcedureReturn ParentID
    EndIf
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Parent
  
  Enumeration 20
    #CANVAS
    #PANEL
    #CONTAINER
    #SCROLLAREA
    #CHILD
    #RETURN
    #COMBO
    #DESKTOP
    #PANEL0
    #PANEL1
    #PANEL2
  EndEnumeration
  
  Define ParentID
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow( 10, 0, 0, 425, 350, "demo set gadget new parent", Flags )
  
  ButtonGadget( 6, 30,90,160,25,"Button >>( Window )" )
  
  ButtonGadget( #PANEL0, 30,120,160,20,"Button >>( Panel ( 0 ) )" ) 
  ButtonGadget( #PANEL1, 30,140,160,20,"Button >>( Panel ( 1 ) )" ) 
  ButtonGadget( #PANEL2, 30,160,160,20,"Button >>( Panel ( 2 ) )" ) 
  
  PanelGadget( #PANEL, 10,180,200,160 ) 
  AddGadgetItem( #PANEL,-1,"Panel" ) 
  ButtonGadget( 60, 30,90,160,30,"Button >>( Panel ( 0 ) )" ) 
  AddGadgetItem( #PANEL,-1,"First" ) 
  ButtonGadget( 61, 35,90,160,30,"Button >>( Panel ( 1 ) )" ) 
  AddGadgetItem( #PANEL,-1,"Second" ) 
  ButtonGadget( 62, 40,90,160,30,"Button >>( Panel ( 2 ) )" ) 
  CloseGadgetList( )
  
  ContainerGadget( #CONTAINER, 215,10,200,160,#PB_Container_Flat ) 
  ButtonGadget( 7, 30,90,160,30,"Button >>( Container )" ) 
  CloseGadgetList( )
  
  ScrollAreaGadget( #SCROLLAREA, 215,180,200,160,200,160,10,#PB_ScrollArea_Flat ) 
  ButtonGadget( 8, 30,90,160,30,"Button >>( ScrollArea )" ) 
  CloseGadgetList( )
  
  
  ;
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow( 20, WindowX( 10 )-210, WindowY( 10 ), 240, 350, "old parent", Flags, WindowID( 10 ) )
  
  ButtonGadget( #CHILD,30,10,160,70,"ButtonGadget" ) 
  ButtonGadget( #RETURN, 30,90,160,25,"Button <<( Return )" ) 
  
  ComboBoxGadget( #COMBO,30,120,160,25 ) 
  AddGadgetItem( #COMBO, -1, "Selected gadget to move" )
  AddGadgetItem( #COMBO, -1, "ButtonGadget" )
  AddGadgetItem( #COMBO, -1, "StringGadget" )
  AddGadgetItem( #COMBO, -1, "TextGadget" )
  AddGadgetItem( #COMBO, -1, "CheckBoxGadget" )
  AddGadgetItem( #COMBO, -1, "OptionGadget" )
  AddGadgetItem( #COMBO, -1, "ListViewGadget" )
  AddGadgetItem( #COMBO, -1, "FrameGadget" )
  AddGadgetItem( #COMBO, -1, "ComboBoxGadget" )
  AddGadgetItem( #COMBO, -1, "ImageGadget" )
  AddGadgetItem( #COMBO, -1, "HyperLinkGadget" )
  AddGadgetItem( #COMBO, -1, "ContainerGadget" )
  AddGadgetItem( #COMBO, -1, "ListIconGadget" )
  AddGadgetItem( #COMBO, -1, "IPAddressGadget" )
  AddGadgetItem( #COMBO, -1, "ProgressBarGadget" )
  AddGadgetItem( #COMBO, -1, "ScrollBarGadget" )
  AddGadgetItem( #COMBO, -1, "ScrollAreaGadget" )
  AddGadgetItem( #COMBO, -1, "TrackBarGadget" )
  AddGadgetItem( #COMBO, -1, "WebGadget" )
  AddGadgetItem( #COMBO, -1, "ButtonImageGadget" )
  AddGadgetItem( #COMBO, -1, "CalendarGadget" )
  AddGadgetItem( #COMBO, -1, "DateGadget" )
  AddGadgetItem( #COMBO, -1, "EditorGadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerListGadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerTreeGadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerComboGadget" )
  AddGadgetItem( #COMBO, -1, "SpinGadget" )        
  AddGadgetItem( #COMBO, -1, "TreeGadget" )         
  AddGadgetItem( #COMBO, -1, "PanelGadget" )        
  AddGadgetItem( #COMBO, -1, "SplitterGadget" )    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( #COMBO, -1, "MDIGadget" ) 
  CompilerEndIf
  AddGadgetItem( #COMBO, -1, "ScintillaGadget" ) 
  AddGadgetItem( #COMBO, -1, "ShortcutGadget" )  
  AddGadgetItem( #COMBO, -1, "CanvasGadget" )    
  
  SetGadgetState( #COMBO, #PB_GadgetType_Button );:  PostEvent( #PB_Event_Gadget, #CHILD, #COMBO, #PB_EventType_Change )
  
  ButtonGadget( #DESKTOP, 30,150,160,20,"Button >>( Desktop )" ) 
  CompilerIf #PB_Compiler_Version > 546
    CanvasGadget( #CANVAS, 30,180,200,160,#PB_Canvas_Container ) 
    ButtonGadget( 11, 30,90,160,30,"Button >>( Canvas )" ) 
    CloseGadgetList( )
  CompilerEndIf
  
  ;
  HideWindow( 10,0 )
  HideWindow( 20,0 )
  
  Repeat
    Define Event = WaitWindowEvent( )
    
    If Event = #PB_Event_Gadget 
      Select EventType( )
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget( )
            Case  #DESKTOP:  SetParent( #CHILD, 0 )
            Case  6:  SetParent( #CHILD, WindowID( 10 ) )
            Case 60, #PANEL0:  SetParent( #CHILD, GadgetID( #PANEL ), 0 )
            Case 61, #PANEL1:  SetParent( #CHILD, GadgetID( #PANEL ), 1 )
            Case 62, #PANEL2:  SetParent( #CHILD, GadgetID( #PANEL ), 2 )
            Case  7:  SetParent( #CHILD, GadgetID( #CONTAINER ) )
            Case  8:  SetParent( #CHILD, GadgetID( #SCROLLAREA ) )
            Case 11:  SetParent( #CHILD, GadgetID( #CANVAS ) )
            Case  #RETURN:  SetParent( #CHILD, WindowID( 20 ) )
              
            Case #COMBO
              Select EventType( )
                Case #PB_EventType_Change
                  Define ParentID = GetParentID( GadgetID( #CHILD ) )
                  
                  Select GetGadgetState( #COMBO )
                    Case  1: ButtonGadget( #CHILD,30,20,150,30,"ButtonGadget" ) 
                    Case  2: StringGadget( #CHILD,30,20,150,30,"StringGadget" ) 
                    Case  3: TextGadget( #CHILD,30,20,150,30,"TextGadget", #PB_Text_Border ) 
                    Case  4: OptionGadget( #CHILD,30,20,150,30,"OptionGadget" ) 
                    Case  5: CheckBoxGadget( #CHILD,30,20,150,30,"CheckBoxGadget" ) 
                    Case  6: ListViewGadget( #CHILD,30,20,150,30 ) 
                    Case  7: FrameGadget( #CHILD,30,20,150,30,"FrameGadget" ) 
                    Case  8: ComboBoxGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"ComboBoxGadget" ): SetGadgetState( #CHILD,0 )
                    Case  9: ImageGadget( #CHILD,30,20,150,30,0,#PB_Image_Border ) 
                    Case 10: HyperLinkGadget( #CHILD,30,20,150,30,"HyperLinkGadget",0 ) 
                    Case 11: ContainerGadget( #CHILD,30,20,150,30,#PB_Container_Flat ): ButtonGadget( -1,0,0,80,20,"ButtonGadget" ): CloseGadgetList( ) ; ContainerGadget
                    Case 12: ListIconGadget( #CHILD,30,20,150,30,"",88 ) 
                    Case 13: IPAddressGadget( #CHILD,30,20,150,30 ) 
                    Case 14: ProgressBarGadget( #CHILD,30,20,150,30,0,5 )
                    Case 15: ScrollBarGadget( #CHILD,30,20,150,30,5,335,9 )
                    Case 16: ScrollAreaGadget( #CHILD,30,20,150,30,305,305,9,#PB_ScrollArea_Flat ): ButtonGadget( -1,0,0,80,20,"ButtonGadget" ): CloseGadgetList( )
                    Case 17: TrackBarGadget( #CHILD,30,20,150,30,0,5 )
                    Case 18: WebGadget( #CHILD,30,20,150,30,"" ) ; bug 531 linux
                    Case 19: ButtonImageGadget( #CHILD,30,20,150,30,0 )
                    Case 20: CalendarGadget( #CHILD,30,20,150,30 ) 
                    Case 21: DateGadget( #CHILD,30,20,150,30 )
                    Case 22: EditorGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"EditorGadget" )
                    Case 23: ExplorerListGadget( #CHILD,30,20,150,30,"" )
                    Case 24: ExplorerTreeGadget( #CHILD,30,20,150,30,"" )
                    Case 25: ExplorerComboGadget( #CHILD,30,20,150,30,"" )
                    Case 26: SpinGadget( #CHILD,30,20,150,30,0,5,#PB_Spin_Numeric )
                    Case 27: TreeGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"TreeGadget" ):  AddGadgetItem( #CHILD,-1,"SubLavel",0,1 )
                    Case 28: PanelGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"PanelGadget" ): CloseGadgetList( )
                    Case 29 
                      ButtonGadget( 201,0,0,30,30,"1" )
                      ButtonGadget( 202,0,0,30,30,"2" )
                      SplitterGadget( #CHILD,30,20,150,30,201,202 )
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadgetState( #COMBO )
                      Case 30: MDIGadget( #CHILD,30,10,150,70,0,0 )
                      Case 31: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 32: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 33: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerElse
                    Select GetGadgetState( #COMBO )
                      Case 30: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 31: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 32: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget( #CHILD,30,10,150,70 )
                  SetParent( #CHILD, ParentID ) 
                  
              EndSelect
          EndSelect
          
          If ( EventGadget( ) <> #CHILD )
            Define Parent = GetParent( #CHILD )
            
            If IsGadget( Parent )
              Debug "parent - gadget (" + Parent + ")"
            Else
              Debug "parent - window (" + GetWindow( #CHILD ) + ")"
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = v------
; EnableXP