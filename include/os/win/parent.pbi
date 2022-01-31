
;
DeclareModule Parent
  Declare GetWindowID( handle.i )
  Declare GetParentID( handle.i )
  
  Declare GetWindow( gadget.i )
  Declare GetParent( gadget.i )
  Declare SetParent( gadget.i, ParentID.i, Item.i = #PB_Default )
EndDeclareModule

Module Parent
  Procedure.s GetClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
  
  Procedure IDWindow( handle.i ) ; Return the id of the window from the window handle
    Protected Window = GetProp_( handle, "PB_WindowID" ) - 1
    If IsWindow( Window ) And WindowID( Window ) = handle
      ProcedureReturn Window
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  Procedure IDgadget( handle.i )  ; Return the id of the gadget from the gadget handle
    Protected gadget = GetProp_( handle, "PB_ID" )
    If IsGadget( gadget ) And GadgetID( gadget ) = handle
      ProcedureReturn gadget
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  Procedure GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure GetParentID( handle.i ) ; Return the handle of the parent from the handle ; Debug GetWindow_( ParentID, #GW_OWNER )
    While handle
      handle = GetParent_( handle )
      
      If IsWindow( IDWindow( handle ) ) Or IsGadget( IDgadget( handle ) )
        ProcedureReturn handle
      ElseIf IsGadget( IDgadget( GetParent_( handle ) ) ) ; Это для скролл ареа гаджет
        ProcedureReturn GetParent_( handle )
      EndIf
    Wend
  EndProcedure
  
  Procedure GetWindow( gadget.i ) ; Return the handle of the parent window from the gadget handle
    If IsGadget( gadget )
      ProcedureReturn IDWindow( GetWindowID( GadgetID( gadget ) ) )
    EndIf
  EndProcedure
  
  Procedure GetParent( gadget.i ) ; Return the handle of the parent gadget from the gadget handle
   If IsGadget( gadget )
     ProcedureReturn IDgadget( GetParentID( GadgetID( gadget ) ) )
   EndIf
 EndProcedure
  
  Procedure SetParent( gadget.i, ParentID.i, Item.i = #PB_Default ) ; Set a new parent for the gadget ; SetWindowLongPtr_( gadgetID( gadget ), #GWLP_HWNDPARENT, ParentID )
    If IsGadget( gadget )
      Select GetClassName( ParentID )
        Case "PureScrollArea"  
          ParentID = FindWindowEx_( ParentID, 0, 0, 0 ) ; get child
        Case "SysTabControl32" 
          ; Get selected tab of the panel
          Protected TC_ITEM.TC_ITEM\Mask = #TCIF_PARAM 
          If Item = #PB_Default
            Item = SendMessage_( ParentID, #TCM_GETCURSEL, 0, 0 )
          EndIf
          SendMessage_( ParentID, #TCM_GETITEM, Item, @TC_ITEM )
          ParentID = TC_ITEM\lParam
      EndSelect 
      
      ; Set spin up/down control in the new parent
      If GadgetType( gadget ) = #PB_GadgetType_Spin
        SetParent_( GetWindow_( GadgetID( gadget ), #GW_HWNDNEXT ), ParentID )
      EndIf
      
      SetParent_( GadgetID( gadget ), ParentID )
      
      ProcedureReturn ParentID
    EndIf
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Parent
  
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
  
  SetGadgetState( #COMBO, #PB_GadgetType_Button ): PostEvent( #PB_Event_Gadget, #CHILD, #COMBO, #PB_EventType_Change )
  
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
              Debug "parent - gadget ( " + Parent + " )"
            Else
              Debug "parent - window ( " + GetWindow( #CHILD ) + " )"
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 14
; FirstLine = 6
; Folding = -v-0--
; EnableXP