DeclareModule Parent
  Declare GetParentID(handle.i)
  Declare _GetParentID(handle.i)
  Declare __GetParentID(handle.i)
  Declare GetWindowID(handle.i)
  
  Declare GetWindow(gadget.i)
  Declare GetParent(gadget.i)
  Declare SetParent(gadget.i, ParentID.i, Item.i = #PB_Default)
EndDeclareModule

Module Parent
  Import ""
    PB_Window_GetID(hWnd) 
  EndImport
  
  Procedure.s GetClassName(handle.i)
    Protected Result
    CocoaMessage(@Result, CocoaMessage(0, handle, "className"), "UTF8String")
    If Result
      ProcedureReturn PeekS(Result, -1, #PB_UTF8)
    EndIf
  EndProcedure
  
  Procedure IDWindow(handle.i)
    Protected Window = PB_Window_GetID(handle)
    ;If IsWindow(Window) And WindowID(Window) = handle
      ProcedureReturn Window
    ;EndIf
    ;ProcedureReturn - 1
  EndProcedure
  
  Procedure IDGadget(handle.i)
    Protected gadget = CocoaMessage(0, handle, "tag")
    ; Debug "id - "+handle +" "+ gadget
;     If IsGadget(gadget) And GadgetID(gadget) = handle
      ProcedureReturn gadget
;     EndIf
;     ProcedureReturn - 1
  EndProcedure
  
  Procedure NSView(gadget.i) ; Return the handle of the parent from the gadget handle
    If IsGadget(gadget)
      Protected handle = GadgetID(gadget)
      Select GadgetType(gadget)
        Case #PB_GadgetType_ListView,                     ; PBListViewTableView
             #PB_GadgetType_Editor,                       ; PBEditorGadgetTextView
             #PB_GadgetType_ListIcon,                     ; PB_NSTableView
             #PB_GadgetType_ExplorerList,                 ; PB_NSTableView
             #PB_GadgetType_ExplorerTree,                 ; PB_NSOutlineView
             #PB_GadgetType_Tree,                         ; PBTreeOutlineView
             #PB_GadgetType_Web                           ; PB_WebView
          handle = CocoaMessage(0, handle, "superview") ; NSClipView
          handle = CocoaMessage(0, handle, "superview") ; real - NSScrollView ; PBTreeScrollView ; PBWebScrollView
        Case #PB_GadgetType_Spin,                         ; PB_NSTextField
             #PB_GadgetType_Scintilla                     ; PBScintillaView
          handle = CocoaMessage(0, handle, "superview") ; real - PB_SpinView ; NSBox
      EndSelect
      ProcedureReturn handle ; CocoaMessage(0, handle, "superview") ; PBFlippedWindowView
    EndIf
  EndProcedure
  
  Procedure GetWindowID(handle.i) ; Return the handle of the parent window from the handle
    ProcedureReturn CocoaMessage(0, handle, "window")
  EndProcedure
  
  Procedure GetParentID(handle.i) ; Return the handle of the parent from the gadget handle
    Protected WindowID = GetWindowID(handle)
    
    While handle 
      handle = CocoaMessage(0, handle, "superview")
      
      If Not handle 
        ProcedureReturn WindowID
      EndIf
      
      If IDGadget(handle) >= 0
        ProcedureReturn handle
      EndIf
    Wend
  EndProcedure
  
  Procedure _GetParentID(handle.i) ; Return the handle of the parent from the gadget handle
    Protected WindowID = GetWindowID(handle)
    Protected contentView = CocoaMessage(0, WindowID, "contentView")
    
    If WindowID 
      While handle
        If contentView = CocoaMessage(0, handle, "superview")
          ProcedureReturn WindowID
        Else
          ProcedureReturn CocoaMessage(0, CocoaMessage(0, NSView(IDGadget(handle)), "superview"), "superview")
        EndIf
        
        handle = CocoaMessage(0, handle, "superview")
      Wend
    EndIf
  EndProcedure
  
  Procedure __GetParentID(handle.i) ; Return the handle of the parent from the gadget handle
    Protected gadgetID
    Protected WindowID
    
    While handle
      gadgetID = handle
      handle = CocoaMessage(0, handle, "superview")
      
      If handle
        WindowID = GetWindowID(handle)
        
        If WindowID 
          If handle = CocoaMessage(0, WindowID, "contentView")
            ProcedureReturn WindowID
          Else
            ProcedureReturn CocoaMessage(0, CocoaMessage(0, NSView(IDGadget(gadgetID)), "superview"), "superview")
          EndIf
        EndIf
      EndIf
    Wend
  EndProcedure
  
  Procedure GetWindow(gadget.i) ; Return the id of the parent window from the gadget id
    If IsGadget(gadget)
      ProcedureReturn IDWindow(GetWindowID(GadgetID(gadget)))
    EndIf
  EndProcedure
  
  Procedure GetParent(gadget.i) ; Return the id of the parent gadget from the gadget id
    If IsGadget(gadget)
      Protected gadgetID = GadgetID(gadget)  
      Protected handle = GetParentID(gadgetID)
      Protected WindowID = GetWindowID(gadgetID)
      
      If WindowID = handle
        ProcedureReturn - 1 ; IDWindow(handle)
      Else
        ProcedureReturn IDgadget(handle)
      EndIf
    EndIf
  EndProcedure
  
  Procedure SetParent(gadget.i, ParentID.i, Item.i = #PB_Default) ; Set a new parent for the gadget
    If IsGadget(gadget)
      Protected i = item
      Protected GadgetID = GadgetID(gadget)
      
      If ParentID
        Select GadgetType(gadget)
          Case #PB_GadgetType_ListView,                               ; PBListViewTableView    -> NSClipView -> NSScrollView
               #PB_GadgetType_Editor,                                 ; PBEditorGadgetTextView -> NSClipView -> NSScrollView
               #PB_GadgetType_ListIcon,                               ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerList,                           ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerTree,                           ; PB_NSOutlineView       -> NSClipView -> NSScrollView
               #PB_GadgetType_Tree,                                   ; PBTreeOutlineView      -> NSClipView -> PBTreeScrollView
               #PB_GadgetType_Web                                     ; PB_WebView             -> NSClipView -> PBWebScrollView
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
          Case #PB_GadgetType_Spin,                                   ; PB_NSTextField         -> PB_SpinView
               #PB_GadgetType_Scintilla                               ; PBScintillaView        -> NSBox
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
        EndSelect
        
;         Protected parent = IDGadget(ParentID)
;         
;         If IsGadget(parent)
;           Select GadgetType(parent)
;             Case #PB_GadgetType_Container,                            ; PBContainerView        -> PB_NSFlippedView
;                  #PB_GadgetType_ScrollArea                            ; PBScrollView           -> NSClipView
;               ParentID = CocoaMessage(0, ParentID, "contentView") 
;             Case #PB_GadgetType_Canvas                                ; PB_CanvasView          -> PB_NSFlippedView
;               ParentID = CocoaMessage(0, ParentID, "subviews")        ; __NSArrayM
;               ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)  
;             Case #PB_GadgetType_Panel                                 ; PBTabView              -> PB_NSFlippedView
;               If item <> #PB_Default
;                 i = GetGadgetState(parent)
;               EndIf
;               If i <> item 
;                 SetGadgetState(parent, item)
;               EndIf
;               ParentID = CocoaMessage(0, ParentID, "subviews")        ; __NSArrayM
;               ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)  
;               If i <> item 
;                 SetGadgetState(parent, i)
;               EndIf
;             Default
;               ParentID = CocoaMessage(0, GetWindowID(ParentID), "contentView")
;           EndSelect
;         Else
;           ParentID = CocoaMessage(0, ParentID, "contentView")
;         EndIf
        
        
        Select GetClassName(ParentID)
          Case "PBTabView"
            Protected parent = IDgadget(ParentID)
            If item <> #PB_Default 
              Protected selectedTabViewItem = CocoaMessage(0, ParentID, "selectedTabViewItem")
              ; i = GetGadgetState(parent)
              i = CocoaMessage(0, ParentID, "indexOfTabViewItem:@", @selectedTabViewItem)
              CocoaMessage(0, GadgetID(parent), "selectTabViewItem:@", @"2")
              ; CocoaMessage(0, GadgetID(parent), "selectTabViewItem:@", @selectedTabViewItem)
              
;               ; tabViewItem ; indexOfTabViewItem
;               ;Debug CocoaMessage(0, selectedTabViewItem, "tabViewItem:") ; tabViewItem ; indexOfTabViewItem
;               Debug i
;               ;Debug CocoaMessage(0, selectedTabViewItem, "indexOfTabViewItem")
;               Debug CocoaMessage(0, selectedTabViewItem, "tabView")
;               Debug CocoaMessage(0, selectedTabViewItem, "view")
;               Debug GetClassName(CocoaMessage(0, selectedTabViewItem, "tabView")) ; PBTabView
;               Debug GetClassName(CocoaMessage(0, selectedTabViewItem, "view"))    ; PB_NSFlippedView
            EndIf
            If i <> item 
              SetGadgetState(parent, item)
              ;;CocoaMessage(0, GadgetID(parent), "selectTabViewItem:", item)
            EndIf
            ParentID = CocoaMessage(0, ParentID, "subviews")
            ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
            If i <> item 
              ;;Debug  CocoaMessage(0, gadgetID(parent), "selectedItem")
              ;SetGadgetState(parent, i)
              ;                 CocoaMessage(0, gadgetID(parent), "tabView:", i)
              
                            CocoaMessage(0, GadgetID(parent), "selectTabViewItem:@", @i)
              ;  CocoaMessage(0, GadgetID(parent), "selectTabViewItem:", i)
            EndIf
          Case "PB_CanvasView"
            ParentID = CocoaMessage(0, ParentID, "subviews")
            ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
          Default
            ParentID = CocoaMessage(0, ParentID, "contentView")
        EndSelect
        
        CocoaMessage (0, ParentID, "addSubview:", GadgetID) 
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
  OpenWindow(10, 0, 0, 425, 350, "demo set gadget new parent", Flags)
  
  ButtonGadget(6, 30,90,160,25,"Button >>(Window)")
  
  ButtonGadget(#PANEL0, 30,120,160,20,"Button >>(Panel (0))") 
  ButtonGadget(#PANEL1, 30,140,160,20,"Button >>(Panel (1))") 
  ButtonGadget(#PANEL2, 30,160,160,20,"Button >>(Panel (2))") 
  
  PanelGadget(#PANEL, 10,180,200,160) 
  AddGadgetItem(#PANEL,-1,"Panel") 
  ButtonGadget(60, 30,90,160,30,"Button >>(Panel (0))") 
  AddGadgetItem(#PANEL,-1,"First") 
  ButtonGadget(61, 35,90,160,30,"Button >>(Panel (1))") 
  AddGadgetItem(#PANEL,-1,"Second") 
  ButtonGadget(62, 40,90,160,30,"Button >>(Panel (2))") 
  CloseGadgetList()
  
  ContainerGadget(#CONTAINER, 215,10,200,160,#PB_Container_Flat) 
  ButtonGadget(7, 30,90,160,30,"Button >>(Container)") 
  CloseGadgetList()
  
  ScrollAreaGadget(#SCROLLAREA, 215,180,200,160,200,160,10,#PB_ScrollArea_Flat) 
  ButtonGadget(8, 30,90,160,30,"Button >>(ScrollArea)") 
  CloseGadgetList()
  
  
  ;
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow(20, WindowX(10)-210, WindowY(10), 240, 350, "old parent", Flags, WindowID(10))
  
  ButtonGadget(#CHILD,30,10,160,70,"Buttongadget") 
  ButtonGadget(#RETURN, 30,90,160,25,"Button <<(Return)") 
  
  ComboBoxGadget(#COMBO,30,120,160,25) 
  AddGadgetItem(#COMBO, -1, "Selected gadget to move")
  AddGadgetItem(#COMBO, -1, "Buttongadget")
  AddGadgetItem(#COMBO, -1, "Stringgadget")
  AddGadgetItem(#COMBO, -1, "Textgadget")
  AddGadgetItem(#COMBO, -1, "CheckBoxgadget")
  AddGadgetItem(#COMBO, -1, "Optiongadget")
  AddGadgetItem(#COMBO, -1, "ListViewgadget")
  AddGadgetItem(#COMBO, -1, "Framegadget")
  AddGadgetItem(#COMBO, -1, "ComboBoxgadget")
  AddGadgetItem(#COMBO, -1, "Imagegadget")
  AddGadgetItem(#COMBO, -1, "HyperLinkgadget")
  AddGadgetItem(#COMBO, -1, "Containergadget")
  AddGadgetItem(#COMBO, -1, "ListIcongadget")
  AddGadgetItem(#COMBO, -1, "IPAddressgadget")
  AddGadgetItem(#COMBO, -1, "ProgressBargadget")
  AddGadgetItem(#COMBO, -1, "ScrollBargadget")
  AddGadgetItem(#COMBO, -1, "ScrollAreagadget")
  AddGadgetItem(#COMBO, -1, "TrackBargadget")
  AddGadgetItem(#COMBO, -1, "Webgadget")
  AddGadgetItem(#COMBO, -1, "ButtonImagegadget")
  AddGadgetItem(#COMBO, -1, "Calendargadget")
  AddGadgetItem(#COMBO, -1, "Dategadget")
  AddGadgetItem(#COMBO, -1, "Editorgadget")
  AddGadgetItem(#COMBO, -1, "ExplorerListgadget")
  AddGadgetItem(#COMBO, -1, "ExplorerTreegadget")
  AddGadgetItem(#COMBO, -1, "ExplorerCombogadget")
  AddGadgetItem(#COMBO, -1, "Spingadget")        
  AddGadgetItem(#COMBO, -1, "Treegadget")         
  AddGadgetItem(#COMBO, -1, "Panelgadget")        
  AddGadgetItem(#COMBO, -1, "Splittergadget")    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem(#COMBO, -1, "MDIgadget") 
  CompilerEndIf
  AddGadgetItem(#COMBO, -1, "Scintillagadget") 
  AddGadgetItem(#COMBO, -1, "Shortcutgadget")  
  AddGadgetItem(#COMBO, -1, "Canvasgadget")    
  
  SetGadgetState(#COMBO, #PB_GadgetType_Button);:  PostEvent(#PB_Event_gadget, #CHILD, #COMBO, #PB_EventType_Change)
  
  ButtonGadget(#DESKTOP, 30,150,160,20,"Button >>(Desktop)") 
  CompilerIf #PB_Compiler_Version > 546
    CanvasGadget(#CANVAS, 30,180,200,160,#PB_Canvas_Container) 
    ButtonGadget(11, 30,90,160,30,"Button >>(Canvas)") 
    CloseGadgetList()
  CompilerEndIf
  
  ;
  HideWindow(10,0)
  HideWindow(20,0)
  
  Repeat
    Define Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget 
      Select EventType()
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget()
            Case  #DESKTOP:  SetParent(#CHILD, 0)
            Case  6:  SetParent(#CHILD, WindowID(10))
            Case 60, #PANEL0:  SetParent(#CHILD, GadgetID(#PANEL), 0)
            Case 61, #PANEL1:  SetParent(#CHILD, GadgetID(#PANEL), 1)
            Case 62, #PANEL2:  SetParent(#CHILD, GadgetID(#PANEL), 2)
            Case  7:  SetParent(#CHILD, GadgetID(#CONTAINER))
            Case  8:  SetParent(#CHILD, GadgetID(#SCROLLAREA))
            Case 11:  SetParent(#CHILD, GadgetID(#CANVAS))
            Case  #RETURN:  SetParent(#CHILD, WindowID(20))
              
            Case #COMBO
              Select EventType()
                Case #PB_EventType_Change
                  Define ParentID = GetParentID(GadgetID(#CHILD))
                  
                  Select GetGadgetState(#COMBO)
                    Case  1: ButtonGadget(#CHILD,30,20,150,30,"Buttongadget") 
                    Case  2: StringGadget(#CHILD,30,20,150,30,"Stringgadget") 
                    Case  3: TextGadget(#CHILD,30,20,150,30,"Textgadget", #PB_Text_Border) 
                    Case  4: OptionGadget(#CHILD,30,20,150,30,"Optiongadget") 
                    Case  5: CheckBoxGadget(#CHILD,30,20,150,30,"CheckBoxgadget") 
                    Case  6: ListViewGadget(#CHILD,30,20,150,30) 
                    Case  7: FrameGadget(#CHILD,30,20,150,30,"Framegadget") 
                    Case  8: ComboBoxGadget(#CHILD,30,20,150,30): AddGadgetItem(#CHILD,-1,"ComboBoxgadget"): SetGadgetState(#CHILD,0)
                    Case  9: ImageGadget(#CHILD,30,20,150,30,0,#PB_Image_Border) 
                    Case 10: HyperLinkGadget(#CHILD,30,20,150,30,"HyperLinkgadget",0) 
                    Case 11: ContainerGadget(#CHILD,30,20,150,30,#PB_Container_Flat): ButtonGadget(-1,0,0,80,20,"Buttongadget"): CloseGadgetList() ; Containergadget
                    Case 12: ListIconGadget(#CHILD,30,20,150,30,"",88) 
                    Case 13: IPAddressGadget(#CHILD,30,20,150,30) 
                    Case 14: ProgressBarGadget(#CHILD,30,20,150,30,0,5)
                    Case 15: ScrollBarGadget(#CHILD,30,20,150,30,5,335,9)
                    Case 16: ScrollAreaGadget(#CHILD,30,20,150,30,305,305,9,#PB_ScrollArea_Flat): ButtonGadget(-1,0,0,80,20,"Buttongadget"): CloseGadgetList()
                    Case 17: TrackBarGadget(#CHILD,30,20,150,30,0,5)
                    Case 18: WebGadget(#CHILD,30,20,150,30,"") ; bug 531 linux
                    Case 19: ButtonImageGadget(#CHILD,30,20,150,30,0)
                    Case 20: CalendarGadget(#CHILD,30,20,150,30) 
                    Case 21: DateGadget(#CHILD,30,20,150,30)
                    Case 22: EditorGadget(#CHILD,30,20,150,30):  AddGadgetItem(#CHILD,-1,"Editorgadget")
                    Case 23: ExplorerListGadget(#CHILD,30,20,150,30,"")
                    Case 24: ExplorerTreeGadget(#CHILD,30,20,150,30,"")
                    Case 25: ExplorerComboGadget(#CHILD,30,20,150,30,"")
                    Case 26: SpinGadget(#CHILD,30,20,150,30,0,5,#PB_Spin_Numeric)
                    Case 27: TreeGadget(#CHILD,30,20,150,30):  AddGadgetItem(#CHILD,-1,"Treegadget"):  AddGadgetItem(#CHILD,-1,"SubLavel",0,1)
                    Case 28: PanelGadget(#CHILD,30,20,150,30): AddGadgetItem(#CHILD,-1,"Panelgadget"): CloseGadgetList()
                    Case 29 
                      ButtonGadget(201,0,0,30,30,"1")
                      ButtonGadget(202,0,0,30,30,"2")
                      SplitterGadget(#CHILD,30,20,150,30,201,202)
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadgetState(#COMBO)
                      Case 30: MDIgadget(#CHILD,30,10,150,70,0,0)
                      Case 31: InitScintilla(): ScintillaGadget(#CHILD,30,10,150,70,0)
                      Case 32: ShortcutGadget(#CHILD,30,10,150,70,0)
                      Case 33: CanvasGadget(#CHILD,30,10,150,70) 
                    EndSelect
                  CompilerElse
                    Select GetGadgetState(#COMBO)
                      Case 30: InitScintilla(): ScintillaGadget(#CHILD,30,10,150,70,0)
                      Case 31: ShortcutGadget(#CHILD,30,10,150,70,0)
                      Case 32: CanvasGadget(#CHILD,30,10,150,70) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget(#CHILD,30,10,150,70)
                  SetParent(#CHILD, ParentID) 
                  
              EndSelect
          EndSelect
          
          If (EventGadget() <> #CHILD)
            Define Parent = GetParent(#CHILD)
            
            If IsGadget(Parent)
              Debug "parent - gadget (" + Parent + ")"
            Else
              Debug "parent - window (" + GetWindow(#CHILD) + ")"
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------
; EnableXP