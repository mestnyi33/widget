XIncludeFile "id.pbi"

DeclareModule Parent
  EnableExplicit
  Declare WindowWidget( gadget.i )
  Declare Gadget( gadget.i )
  Declare Get( handle.i )
  Declare Set( gadget.i, ParentID.i, Item.i = #PB_Default )
EndDeclareModule

Module Parent
  Procedure.s ObjectInheritance( Object ) ; temp
    
    Protected.i Result
    Protected.i MutableArray = CocoaMessage( 0, 0, "NSMutableArray arrayWithCapacity:", 10 )
    
    Repeat
      CocoaMessage( 0, MutableArray, "addObject:", CocoaMessage( 0, Object, "className" ) )
      CocoaMessage( @Object, Object, "superclass" )
    Until Object = 0
    
    CocoaMessage( @Result, MutableArray, "componentsJoinedByString:$", @"  -->  " )
    CocoaMessage( @Result, Result, "UTF8String" )
    
    ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
    
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the Parent window from the handle
    ProcedureReturn CocoaMessage( 0, handle, "window" )
  EndProcedure
  
  Procedure.s ClassName( handle.i )
    Protected Result
    CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
    If Result
      ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  Procedure WindowWidget( gadget.i ) ; Return the id of the Parent window from the gadget id
    If IsGadget( gadget )
      ProcedureReturn ID::Window( GetWindowID( GadgetID( gadget ) ) )
    EndIf
  EndProcedure
  
  Procedure Gadget( gadget.i ) ; Return the id of the Parent gadget from the gadget id
    If IsGadget( gadget )
      Protected gadgetID = GadgetID( gadget )  
      Protected handle = Get( gadgetID )
      
      If handle = GetWindowID( gadgetID )
        ProcedureReturn - 1 ; IDWindow( handle )
      Else
        ProcedureReturn ID::Gadget( handle )
      EndIf
    EndIf
  EndProcedure
  
  Procedure Get( handle.i ) ; Return the handle of the Parent from the gadget handle
    Protected GadgetID = handle
    Protected WindowID = GetWindowID( handle )
    
    While handle 
      handle = CocoaMessage( 0, handle, "superview" )
      
      If handle 
        If ID::Gadget( handle ) >= 0
          ProcedureReturn handle
        EndIf
        If Not CocoaMessage(  0, handle, "window" )
          ; Debug CocoaMessage( 0, handle, "superview" )
          Define Object = handle
          CocoaMessage( @Object, Object, "superclass" ) ; NSView
          CocoaMessage( @Object, Object, "superclass" ) ; NSResponder
          CocoaMessage( @Object, Object, "superclass" ) ; NSObject
          Debug ClassName( Object )
          ; Debug CocoaMessage( 0, Object, "superview" )
          ;Debug ObjectInheritance( GadgetID ) ; PBButtonGadgetView  -->  NSButton  -->  NSControl  -->  NSView  -->  NSResponder  -->  NSObject
          ;Debug ObjectInheritance( GadgetID( 23 ) ) ;#PANEL ; PBContainerView  -->  NSBox  -->  NSView  -->  NSResponder  -->  NSObject
          Debug ObjectInheritance( handle ) ; PB_NSFlippedView  -->  NSView  -->  NSResponder  -->  NSObject
          Debug " - panel "+handle
          ; ProcedureReturn Object
        EndIf
      Else
        ProcedureReturn WindowID
      EndIf
    Wend
  EndProcedure
  
  Procedure Set( gadget.i, ParentID.i, Item.i = #PB_Default ) ; Set a new Parent for the gadget
    If IsGadget( gadget )
      Protected i = item
      Protected GadgetID = GadgetID( gadget )
      ;Debug CocoaMessage( 0, GadgetID, "contentView" )
      
      If ParentID ; And ParentID <>Parent::Get(  GadgetID )
        Select GadgetType( gadget )
          Case #PB_GadgetType_ListView,                               ; PBListViewTableView    -> NSClipView -> NSScrollView
               #PB_GadgetType_Editor,                                 ; PBEditorGadGetWidgetTextView -> NSClipView -> NSScrollView
               #PB_GadgetType_ListIcon,                               ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerList,                           ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerTree,                           ; PB_NSOutlineView       -> NSClipView -> NSScrollView
               #PB_GadgetType_Tree,                                   ; PBTreeOutlineView      -> NSClipView -> PBTreeScrollView
               #PB_GadgetType_Web                                     ; PB_WebView             -> NSClipView -> PBWebScrollView
            GadgetID = CocoaMessage( 0, GadgetID, "superview" )       
            GadgetID = CocoaMessage( 0, GadgetID, "superview" )       
          Case #PB_GadgetType_Spin,                                   ; PB_NSTextField         -> PB_SpinView
               #PB_GadgetType_Scintilla                               ; PBScintillaView        -> NSBox
            GadgetID = CocoaMessage( 0, GadgetID, "superview" )       
        EndSelect
        
        Select ClassName(  ParentID )
          Case "PBTabView"        ;             Case #PB_GadgetType_Panel                                 ; PBTabView              -> PB_NSFlippedView
            Protected selectedTabViewItem = CocoaMessage( 0, ParentID, "selectedTabViewItem" )
            If item <> #PB_Default
              i = CocoaMessage( 0, ParentID, "indexOfTabViewItem:@", @selectedTabViewItem )
            EndIf
            If i <> item 
              CocoaMessage( 0, ParentID, "selectTabViewItemAtIndex:", item )
            EndIf
            ParentID = CocoaMessage(  0, ParentID, "subviews" )
            ParentID = CocoaMessage(  0, ParentID, "objectAtIndex:", CocoaMessage(  0, ParentID, "count" ) - 1 )
            If i <> item 
              CocoaMessage( 0, CocoaMessage( 0, selectedTabViewItem, "tabView" ), "selectTabViewItemAtIndex:", i )
            EndIf
            
          Case "PB_CanvasView"    ;             Case #PB_GadgetType_Canvas                                ; PB_CanvasView          -> PB_NSFlippedView
            ParentID = CocoaMessage(  0, ParentID, "subviews" )
            ParentID = CocoaMessage(  0, ParentID, "objectAtIndex:", CocoaMessage(  0, ParentID, "count" ) - 1 )
            
          Case "PBContainerView", ;             Case #PB_GadgetType_Container,                            ; PBContainerView        -> PB_NSFlippedView
               "PBScrollView"     ;                  #PB_GadgetType_ScrollArea                            ; PBScrollView           -> NSClipView
            ParentID = CocoaMessage( 0, ParentID, "contentView" ) 
            
          Default
            ParentID = CocoaMessage(  0, ParentID, "contentView" )
            ;ParentID = CocoaMessage( 0, GetWindowID( ParentID ), "contentView" )
        EndSelect
        
        ; 
        CocoaMessage ( 0, ParentID, "addSubview:", GadgetID ) 
      Else
;         ; to desktop move
         ParentID = CocoaMessage(0,0, "NSScreen mainScreen")
;         
;         
;         ParentID = CocoaMessage(  0, ParentID, "subviews" )
;         CocoaMessage ( 0, ParentID, "addSubview:", GadgetID ) 
        ; CocoaMessage(0, CocoaMessage(0, GadgetID, "window"), "setParentWindow:", ParentID)
      EndIf
      
      ProcedureReturn ParentID
    EndIf
  EndProcedure
EndModule

;-\\ example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Parent
  
  Procedure IsContainerOC(Gadget)
  ; Procedure IsContainer based on procedure IsCanvasContainer by mk-soft: https://www.purebasic.fr/english/viewtopic.php?t=79002
  Select GadgetType(Gadget)
    Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea, #PB_GadgetType_Splitter
      ProcedureReturn #True
    Case #PB_GadgetType_Canvas
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          If GetWindowLongPtr_(GadgetID(Gadget), #GWL_STYLE) & #WS_CLIPCHILDREN
            ProcedureReturn #True
          EndIf
        CompilerCase #PB_OS_MacOS
          Protected sv, count
          sv    = CocoaMessage(0, GadgetID(Gadget), "subviews")
          count = CocoaMessage(0, sv, "count")
          ProcedureReturn count
        CompilerCase #PB_OS_Linux
          Protected GList, count
          GList = gtk_container_get_children_(GadgetID(Gadget))
          If GList
            count = g_list_length_(GList)
            g_list_free_(GList)
            ProcedureReturn count
          EndIf
      CompilerEndSelect
  EndSelect
  ProcedureReturn #False
EndProcedure

  Procedure GadgetIDType(  GadgetID )
    If GadgetID
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows
          Protected Class$ = Space(  16 )
          GetClassName_(  GadgetID, @Class$, Len(  Class$ ) )
          
          Select Class$
            Case "PureContainer":  ProcedureReturn #PB_GadgetType_Container
            Case "PureScrollArea":  ProcedureReturn #PB_GadgetType_ScrollArea
            Case "SysTabControl32":  ProcedureReturn #PB_GadgetType_Panel
          EndSelect 
          
        CompilerCase #PB_OS_Linux
          Protected *notebook.GtkNotebook = GadgetID
          If *notebook\children
            If *notebook\first_tab = *notebook\children
              ProcedureReturn #PB_GadgetType_Panel
            ElseIf *notebook\packed_flags
              ProcedureReturn - 1
            Else
              ProcedureReturn #PB_GadgetType_ScrollArea
            EndIf
          Else
            ProcedureReturn #PB_GadgetType_Container
          EndIf
      CompilerEndSelect
    EndIf
  EndProcedure 
  
  Enumeration 21
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
  OpenWindow( 10, 0, 0, 425, 350, "demo set gadget new Parent", Flags )
  
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
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_ScreenCentered 
  OpenWindow( 20, 0, 0, 240, 350, "old Parent", Flags, WindowID( 10 ) )
  
  ButtonGadget( #CHILD,30,10,160,70,"Buttongadget" ) 
  ButtonGadget( #RETURN, 30,90,160,25,"Button <<( Return )" ) 
  
  ComboBoxGadget( #COMBO,30,120,160,25 ) 
  AddGadgetItem( #COMBO, -1, "Selected gadget to move" )
  AddGadgetItem( #COMBO, -1, "Buttongadget" )
  AddGadgetItem( #COMBO, -1, "Stringgadget" )
  AddGadgetItem( #COMBO, -1, "Textgadget" )
  AddGadgetItem( #COMBO, -1, "CheckBoxgadget" )
  AddGadgetItem( #COMBO, -1, "Optiongadget" )
  AddGadgetItem( #COMBO, -1, "ListViewgadget" )
  AddGadgetItem( #COMBO, -1, "Framegadget" )
  AddGadgetItem( #COMBO, -1, "ComboBoxgadget" )
  AddGadgetItem( #COMBO, -1, "Imagegadget" )
  AddGadgetItem( #COMBO, -1, "HyperLinkgadget" )
  AddGadgetItem( #COMBO, -1, "Containergadget" )
  AddGadgetItem( #COMBO, -1, "ListIcongadget" )
  AddGadgetItem( #COMBO, -1, "IPAddressgadget" )
  AddGadgetItem( #COMBO, -1, "ProgressBargadget" )
  AddGadgetItem( #COMBO, -1, "ScrollBargadget" )
  AddGadgetItem( #COMBO, -1, "ScrollAreagadget" )
  AddGadgetItem( #COMBO, -1, "TrackBargadget" )
  AddGadgetItem( #COMBO, -1, "Webgadget" )
  AddGadgetItem( #COMBO, -1, "ButtonImagegadget" )
  AddGadgetItem( #COMBO, -1, "Calendargadget" )
  AddGadgetItem( #COMBO, -1, "Dategadget" )
  AddGadgetItem( #COMBO, -1, "Editorgadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerListgadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerTreegadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerCombogadget" )
  AddGadgetItem( #COMBO, -1, "Spingadget" )        
  AddGadgetItem( #COMBO, -1, "Treegadget" )         
  AddGadgetItem( #COMBO, -1, "Panelgadget" )        
  AddGadgetItem( #COMBO, -1, "Splittergadget" )    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( #COMBO, -1, "MDIgadget" ) 
  CompilerEndIf
  AddGadgetItem( #COMBO, -1, "Scintillagadget" ) 
  AddGadgetItem( #COMBO, -1, "Shortcutgadget" )  
  AddGadgetItem( #COMBO, -1, "Canvasgadget" )    
  
  SetGadGetWidgetState( #COMBO, #PB_GadgetType_Button );:  PostEvent( #PB_Event_gadget, #CHILD, #COMBO, #PB_EventType_Change )
  
  ButtonGadget( #DESKTOP, 30,150,160,20,"Button >>( Desktop )" ) 
  CompilerIf #PB_Compiler_Version > 546
    CanvasGadget( #CANVAS, 30,180,200,160,#PB_Canvas_Container ) 
    ButtonGadget( 11, 30,90,160,30,"Button >>( Canvas )" ) 
    CloseGadgetList( )
  CompilerEndIf
  
  
  ResizeWindow( 20, WindowX( 20 )-WindowWidth( 20 ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
  ResizeWindow( 10, WindowX( 10 )+WindowWidth( 20 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  ;
  HideWindow( 10,0 )
  HideWindow( 20,0 )
  
  Repeat
    Define Event = WaitWindowEvent( )
    
    If Event = #PB_Event_Gadget 
      Select EventType( )
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget( )
            Case  #DESKTOP:  Parent::Set( #CHILD, 0 )
            Case  6:  Parent::Set( #CHILD, WindowID( 10 ) )
            Case 60, #PANEL0:  Parent::Set( #CHILD, GadgetID( #PANEL ), 0 )
            Case 61, #PANEL1:  Parent::Set( #CHILD, GadgetID( #PANEL ), 1 )
            Case 62, #PANEL2:  Parent::Set( #CHILD, GadgetID( #PANEL ), 2 )
            Case  7:  Parent::Set( #CHILD, GadgetID( #CONTAINER ) )
            Case  8:  Parent::Set( #CHILD, GadgetID( #SCROLLAREA ) )
            Case 11:  Parent::Set( #CHILD, GadgetID( #CANVAS ) )
            Case  #RETURN:  Parent::Set( #CHILD, WindowID( 20 ) )
              
            Case #COMBO
              Select EventType( )
                Case #PB_EventType_Change
                  Define ParentID = Parent::Get( GadgetID( #CHILD ) )
                  
                  Select GetGadGetWidgetState( #COMBO )
                    Case  1: ButtonGadget( #CHILD,30,20,150,30,"Buttongadget" ) 
                    Case  2: StringGadget( #CHILD,30,20,150,30,"Stringgadget" ) 
                    Case  3: TextGadget( #CHILD,30,20,150,30,"Textgadget", #PB_Text_Border ) 
                    Case  4: OptionGadget( #CHILD,30,20,150,30,"Optiongadget" ) 
                    Case  5: CheckBoxGadget( #CHILD,30,20,150,30,"CheckBoxgadget" ) 
                    Case  6: ListViewGadget( #CHILD,30,20,150,30 ) 
                    Case  7: FrameGadget( #CHILD,30,20,150,30,"Framegadget" ) 
                    Case  8: ComboBoxGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"ComboBoxgadget" ): SetGadGetWidgetState( #CHILD,0 )
                    Case  9: ImageGadget( #CHILD,30,20,150,30,0,#PB_Image_Border ) 
                    Case 10: HyperLinkGadget( #CHILD,30,20,150,30,"HyperLinkgadget",0 ) 
                    Case 11: ContainerGadget( #CHILD,30,20,150,30,#PB_Container_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( ) ; Containergadget
                    Case 12: ListIconGadget( #CHILD,30,20,150,30,"",88 ) 
                    Case 13: IPAddressGadget( #CHILD,30,20,150,30 ) 
                    Case 14: ProgressBarGadget( #CHILD,30,20,150,30,0,5 )
                    Case 15: ScrollBarGadget( #CHILD,30,20,150,30,5,335,9 )
                    Case 16: ScrollAreaGadget( #CHILD,30,20,150,30,305,305,9,#PB_ScrollArea_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( )
                    Case 17: TrackBarGadget( #CHILD,30,20,150,30,0,5 )
                    Case 18: WebGadget( #CHILD,30,20,150,30,"" ) ; bug 531 linux
                    Case 19: ButtonImageGadget( #CHILD,30,20,150,30,0 )
                    Case 20: CalendarGadget( #CHILD,30,20,150,30 ) 
                    Case 21: DateGadget( #CHILD,30,20,150,30 )
                    Case 22: EditorGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Editorgadget" )
                    Case 23: ExplorerListGadget( #CHILD,30,20,150,30,"" )
                    Case 24: ExplorerTreeGadget( #CHILD,30,20,150,30,"" )
                    Case 25: ExplorerComboGadget( #CHILD,30,20,150,30,"" )
                    Case 26: SpinGadget( #CHILD,30,20,150,30,0,5,#PB_Spin_Numeric )
                    Case 27: TreeGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Treegadget" ):  AddGadgetItem( #CHILD,-1,"SubLavel",0,1 )
                    Case 28: PanelGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"Panelgadget" ): CloseGadgetList( )
                    Case 29 
                      ButtonGadget( 201,0,0,30,30,"1" )
                      ButtonGadget( 202,0,0,30,30,"2" )
                      SplitterGadget( #CHILD,30,20,150,30,201,202 )
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadGetWidgetState( #COMBO )
                      Case 30: MDIGadget( #CHILD,30,10,150,70,0,0 )
                      Case 31: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 32: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 33: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerElse
                    Select GetGadGetWidgetState( #COMBO )
                      Case 30: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 31: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 32: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget( #CHILD,30,10,150,70 )
                  Parent::Set( #CHILD, ParentID ) 
                  
              EndSelect
          EndSelect
          
          If EventType( ) = #PB_EventType_LeftClick
            If ( EventGadget( ) <> #CHILD )
              Define Parent = Parent::Gadget( #CHILD )
              
              If IsGadget( Parent )
                Debug "Parent - gadget ( " + Parent + " )"
              Else
                Debug "Parent - window ( " + Parent::Window( #CHILD ) + " )"
              EndIf
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 144
; FirstLine = 130
; Folding = --------
; EnableXP