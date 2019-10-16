; 23 мая 2019
; Window() > Form()
; RootGadget() > _Gadget()
; RootWindow() > _Window()

;
;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
;

;- <<<
CompilerIf Not Defined(DD, #PB_Module)
  DeclareModule DD
    EnableExplicit
    
    ;- - _S_drop
    Structure _S_drop
      widget.i
      cursor.i
      
      Type.i
      Format.i
      Actions.i
      Text.s
      ImageID.i
      
      Width.i
      Height.i
    EndStructure
    
    Global *Drag._S_drop
    Global NewMap *Drop._S_drop()
    
    Macro EventDropText()
      DD::DropText()
    EndMacro
    
    Macro EventDropAction()
      DD::DropAction()
    EndMacro
    
    Macro EventDropType()
      DD::DropType()
    EndMacro
    
    Macro EventDropImage(_image_, _depth_=24)
      DD::DropImage(_image_, _depth_)
    EndMacro
    
    Macro DragText(_text_, _actions_=#PB_Drag_Copy)
      DD::Text(_text_, _actions_)
    EndMacro
    
    Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
      DD::Image(_image_, _actions_)
    EndMacro
    
    Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
      DD::Private(_type_, _actions_)
    EndMacro
    
    Macro EnableGadgetDrop(_this_, _format_, _actions_, _private_type_=0)
      DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
    EndMacro
    Macro EnableWindowDrop(_this_, _format_, _actions_, _private_type_=0)
      DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
    EndMacro
    
    
    Declare.s DropText()
    Declare.i DropType()
    Declare.i DropAction()
    Declare.i DropImage(Image.i=-1, Depth.i=24)
    
    Declare.i Text(Text.S, Actions.i=#PB_Drag_Copy)
    Declare.i Image(Image.i, Actions.i=#PB_Drag_Copy)
    Declare.i Private(Type.i, Actions.i=#PB_Drag_Copy)
    
    Declare.i EnableDrop(*this, Format.i, Actions.i, PrivateType.i=0)
    Declare.i EventDrop(*this, eventtype.l)
  EndDeclareModule
  
  Module DD
    Macro _action_(_this_)
      Bool(*Drag And _this_ And MapSize(*Drop()) And FindMapElement(*Drop(), Hex(_this_)) And *Drop()\format = *Drag\format And *Drop()\type = *Drag\type And *Drop()\actions)
    EndMacro
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Import ""
        PB_Object_EnumerateStart( PB_Objects )
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
        ;PB_Object_GetObject( PB_Object , DynamicOrArrayID)
        PB_Window_Objects.i
        PB_Gadget_Objects.i
        PB_Image_Objects.i
        ;PB_Font_Objects.i
      EndImport
    CompilerElse
      ImportC ""
        PB_Object_EnumerateStart( PB_Objects )
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
        ;PB_Object_GetObject( PB_Object , DynamicOrArrayID)
        PB_Window_Objects.i
        PB_Gadget_Objects.i
        PB_Image_Objects.i
        ;PB_Font_Objects.i
      EndImport
    CompilerEndIf
    
    ;   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ;     ; PB Interne Struktur Gadget MacOS
    ;     Structure sdkGadget
    ;       *gadget
    ;       *container
    ;       *vt
    ;       UserData.i
    ;       Window.i
    ;       Type.i
    ;       Flags.i
    ;     EndStructure
    ;   CompilerEndIf
    
    Procedure WindowPB(WindowID) ; Find pb-id over handle
      Protected result, window
      result = -1
      PB_Object_EnumerateStart(PB_Window_Objects)
      While PB_Object_EnumerateNext(PB_Window_Objects, @window)
        If WindowID = WindowID(window)
          result = window
          Break
        EndIf
      Wend
      PB_Object_EnumerateAbort(PB_Window_Objects)
      ProcedureReturn result
    EndProcedure
    
    Procedure GadgetPB(GadgetID) ; Find pb-id over handle
      Protected result, Gadget
      result = -1
      PB_Object_EnumerateStart(PB_Gadget_Objects)
      While PB_Object_EnumerateNext(PB_Gadget_Objects, @Gadget)
        If GadgetID = GadgetID(Gadget)
          result = Gadget
          Break
        EndIf
      Wend
      PB_Object_EnumerateAbort(PB_Gadget_Objects)
      ProcedureReturn result
    EndProcedure
    
    Procedure GetWindowUnderMouse()
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
        
        CocoaMessage(@Point, 0, "NSEvent mouseLocation")
        WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
        NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
        NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
        
        ProcedureReturn NSWindow
      CompilerEndIf
      
    EndProcedure
    
    Procedure enterID()
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected.i NSWindow = GetWindowUnderMouse()
        Protected pt.NSPoint
        
        If NSWindow
          Protected CV = CocoaMessage(0, NSWindow, "contentView")
          CocoaMessage(@pt, NSWindow, "mouseLocationOutsideOfEventStream")
          Protected NsGadget = CocoaMessage(0, CV, "hitTest:@", @pt)
        EndIf
        
        If NsGadget <> CV And NsGadget
          If CV = CocoaMessage(0, NsGadget, "superview")
            ProcedureReturn GadgetPB(NsGadget)
          Else
            ProcedureReturn GadgetPB(CocoaMessage(0, NsGadget, "superview"))
          EndIf
        Else
          ProcedureReturn WindowPB(NSWindow)
        EndIf
        
      CompilerEndIf
    EndProcedure
    
    
    
    Procedure.i SetCursor(Canvas, ImageID.i, x=0, y=0)
      Protected Result.i
      
      With *this
        If Canvas And ImageID
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              Protected ico.ICONINFO
              ico\fIcon = 0
              ico\xHotspot =- x 
              ico\yHotspot =- y 
              ico\hbmMask = ImageID
              ico\hbmColor = ImageID
              
              Protected *Cursor = CreateIconIndirect_(ico)
              If Not *Cursor 
                *Cursor = ImageID 
              EndIf
              
            CompilerCase #PB_OS_Linux
              Protected *Cursor.GdkCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(), ImageID, x, y)
              
            CompilerCase #PB_OS_MacOS
              Protected Hotspot.NSPoint
              Hotspot\x = x
              Hotspot\y = y
              Protected *Cursor = CocoaMessage(0, 0, "NSCursor alloc")
              CocoaMessage(0, *Cursor, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
              
          CompilerEndSelect
          
          SetGadgetAttribute(Canvas, #PB_Canvas_CustomCursor, *Cursor)
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i Cur(type)
      Protected x=1,y=1
      UsePNGImageDecoder()
      
      If type And *Drop()
        *Drop()\cursor = CatchImage(#PB_Any, ?add, 601)
        SetCursor(EventGadget(), ImageID(*Drop()\cursor), x,y)
      Else
        *Drag\cursor = CatchImage(#PB_Any, ?copy, 530)
        SetCursor(EventGadget(), ImageID(*Drag\cursor), x,y)
      EndIf
      
      DataSection
        add: ; memory_size - (601)
        Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000017000000,$0FBDF60000000408,$4D416704000000F5,$61FC0B8FB1000041,
               $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
               $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
               $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$3854414449300100,$1051034ABB528DCB,
               $58DB084146C5293D,$82361609B441886C,$AA4910922C455E92,$C2C105F996362274,$FC2FF417B0504FC2,$DEF7BB3BB9ACF1A0,
               $B99CE66596067119,$2DB03A16C1101E67,$12D0B4D87B0D0B8F,$11607145542B450C,$190D04A4766FDCAA,$4129428FD14DCD04,
               $98F0D525AEFE8865,$A1C4924AD95B44D0,$26A2499413E13040,$F4F9F612B8726298,$62A6ED92C07D5B54,$E13897C2BE814222,
               $A75C5C6365448A6C,$D792BBFAE41D2925,$1A790C0B8161DC2F,$224D78F4C611BD60,$A1E8C72566AB9F6F,$2023A32BDB05D21B,
               $0E3BC7FEBAF316E4,$8E25C73B08CF01B1,$385C7629FEB45FBE,$8BB5746D80621D9F,$9A5AC7132FE2EC2B,$956786C4AE73CBF3,
               $FE99E13C707BB5EB,$C2EA47199109BF48,$01FE0FA33F4D71EF,$EE0F55B370F8C437,$F12CD29C356ED20C,$CBC4BD4A70C833B1,
               $FFCD97200103FC1C,$742500000019D443,$3A65746164745845,$3200657461657263,$312D38302D393130,$3A35313A31315439,
               $30303A30302B3930,$25000000B3ACC875,$6574616474584574,$00796669646F6D3A,$2D38302D39313032,$35313A3131543931,
               $303A30302B35303A,$0000007B7E35C330,$6042AE444E454900
        Data.b $82
        add_end:
        ;     EndDataSection
        ;       
        ;     DataSection
        copy: ; memory_size - (530)
        Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000010000000,$1461140000000408,$4D4167040000008C,$61FC0B8FB1000041,
               $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
               $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
               $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$2854414449E90000,$1040C20A31D27DCF,
               $8B08226C529FD005,$961623685304458D,$05E8A288B1157A4A,$785858208E413C44,$AD03C2DE8803C505,$74CCDD93664D9893,
               $5C25206CCCECC7D9,$0AF51740A487B038,$E4950624ACF41B10,$0B03925602882A0F,$504520607448C0E1,$714E75682A0F7A22,
               $1EC4707FBC91940F,$EF1F26F801E80C33,$6FE840E84635C148,$47D13D78D54EC071,$5BDF86398A726F4D,$7DD0539F268C6356,
               $39B40B3759101A3E,$2EEB2D02D7DBC170,$49172CA44A415AD2,$52B82E69FF1E0AC0,$CC0D0D97E9B7299E,$046FA509CA4B09C0,
               $CB03993630382B86,$5E4840261A49AA98,$D3951E21331B30CF,$262C1B127F8F8BD3,$250000007DB05216,$6574616474584574,
               $006574616572633A,$2D38302D39313032,$35313A3131543931,$303A30302B37303A,$000000EED7F72530,$7461647458457425,
               $796669646F6D3A65,$38302D3931303200,$313A31315439312D,$3A30302B35303A35,$00007B7E35C33030,$42AE444E45490000
        Data.b $60,$82
        copy_end:
      EndDataSection
      
    EndProcedure
    
    Procedure.i EnableDrop(*this, Format.i, Actions.i, PrivateType.i=0)
      ; Format
      ; #PB_Drop_Text    : Accept text on this gadget
      ; #PB_Drop_Image   : Accept images on this gadget
      ; #PB_Drop_Files   : Accept filenames on this gadget
      ; #PB_Drop_Private : Accept a "private" Drag & Drop on this gadgetProtected Result.i
      
      ; Actions
      ; #PB_Drag_None    : The Data format will Not be accepted on the gadget
      ; #PB_Drag_Copy    : The Data can be copied
      ; #PB_Drag_Move    : The Data can be moved
      ; #PB_Drag_Link    : The Data can be linked
      
      If AddMapElement(*Drop(), Hex(*this))
        Debug "Enable drop - " + *this
        *Drop() = AllocateStructure(_S_drop)
        *Drop()\format = Format
        *Drop()\actions = Actions
        *Drop()\type = PrivateType
        *Drop()\widget = *this
      EndIf
      
    EndProcedure
    
    Procedure.i Text(Text.s, Actions.i=#PB_Drag_Copy)
      Debug "Drag text - " + Text
      *Drag = AllocateStructure(_S_drop)
      *Drag\format = #PB_Drop_Text
      *Drag\text = Text
      *Drag\actions = Actions
      Cur(0)
    EndProcedure
    
    Procedure.i Image(Image.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag image - " + Image
      *Drag = AllocateStructure(_S_drop)
      *Drag\format = #PB_Drop_Image
      *Drag\imageID = ImageID(Image)
      *Drag\width = ImageWidth(Image)
      *Drag\height = ImageHeight(Image)
      *Drag\actions = Actions
      Cur(0)
    EndProcedure
    
    Procedure.i Private(Type.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag private - " + Type
      *Drag = AllocateStructure(_S_drop)
      *Drag\format = #PB_Drop_Private
      *Drag\actions = Actions
      *Drag\type = Type
      Cur(0)
    EndProcedure
    
    Procedure.i DropAction()
      If _action_(*Drag\widget) 
        ProcedureReturn *Drop()\actions 
      EndIf
    EndProcedure
    
    Procedure.i DropType()
      If _action_(*Drag\widget) 
        ProcedureReturn *Drop()\type 
      EndIf
    EndProcedure
    
    Procedure.s DropText()
      Protected result.s
      
      If _action_(*Drag\widget)
        Debug "  Drop text - "+*Drag\text
        result = *Drag\text
        FreeStructure(*Drag) 
        *Drag = 0
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    Procedure.i DropPrivate()
      Protected result.i
      
      If _action_(*Drag\widget)
        Debug "  Drop type - "+*Drag\type
        result = *Drag\type
        FreeStructure(*Drag)
        *Drag = 0
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    Procedure.i DropImage(Image.i=-1, Depth.i=24)
      Protected result.i
      
      If _action_(*Drag\widget) And *Drag\imageID
        Debug "  Drop image - "+*Drag\imageID
        
        If Image =- 1
          Result = CreateImage(#PB_Any, *Drag\width, *Drag\height) : Image = Result
        Else
          Result = IsImage(Image)
        EndIf
        
        If Result And StartDrawing(ImageOutput(Image))
          If Depth = 32
            DrawAlphaImage(*Drag\imageID, 0, 0)
          Else
            DrawImage(*Drag\imageID, 0, 0)
          EndIf
          StopDrawing()
        EndIf  
        
        FreeStructure(*Drag)
        *Drag = 0
        
        ProcedureReturn Result
      EndIf
      
    EndProcedure
    
    Procedure.i EventDrop(*this, eventtype.l)
      If *this =- 1
        *this = enterID()
        Debug "is gadget - "+IsGadget(*this)
        Debug "is window - "+IsWindow(*this)
        
        ;       ;               If IsWindow(*this)
        ;       ;                 Debug "title - "+GetWindowTitle(*this)
        ;       ;               EndIf
        
        If _action_(*this)
          *Drag\widget = *this
          
          If IsGadget(*this)
            PostEvent(#PB_Event_GadgetDrop, WindowPB(GetWindowUnderMouse()), *this)
          ElseIf IsWindow(*this)
            PostEvent(#PB_Event_WindowDrop, *this, 0)
          EndIf
        EndIf
        
      Else
        
        Select eventtype
          Case #PB_EventType_MouseEnter
            If _action_(*this)
              If Not *Drop()\cursor
                *Drag\widget = *this
                *Drag\cursor = 0
                Cur(1)
              EndIf
            ElseIf *Drag
              If Not *Drag\cursor
                *Drop()\cursor = 0
                *Drag\widget = 0
                Cur(0)
              EndIf
            EndIf
            
          Case #PB_EventType_MouseLeave
            If *Drag And Not *Drag\cursor
              *Drop()\cursor = 0
              *Drag\widget = 0
              Cur(0)
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            
            If *Drag And MapSize(*Drop())
              If *Drag\cursor Or *Drop()\cursor
                *Drag\cursor = 0
                *Drop()\cursor = 0
                ;Debug "set default cursor"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
              EndIf
              
              ProcedureReturn _action_(*this)
            EndIf  
        EndSelect
        
      EndIf
      
    EndProcedure
  EndModule
CompilerEndIf
;- >>>

;-
DeclareModule Widget
  EnableExplicit
  #Anchors = 9+4
  
  #Anchor_moved = 9
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  ; coordinate widget
  #_c_0 = 0
  #_c_1 = 1 ; frame
  #_c_2 = 2 ; inner
  #_c_3 = 3 ; container
  #_c_4 = 4 ; clip
            ;   #_c_5 = 5
  
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version<547 : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    #PB_EventType_Drop
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ;   EnumerationBinary (#PB_Window_BorderLess<<1)
  ;     #PB_Window_Transparent 
  ;     #PB_Window_Flat
  ;     #PB_Window_Single
  ;     #PB_Window_Double
  ;     #PB_Window_Raised
  ;     #PB_Window_MoveGadget
  ;     #PB_Window_CloseGadget
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Container_Double<<1)
  ;     #PB_Container_Transparent 
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Gadget_ActualSize<<1)
  ;     #PB_Gadget_Left   
  ;     #PB_Gadget_Top    
  ;     #PB_Gadget_Right  
  ;     #PB_Gadget_Bottom 
  ;     
  ;     #PB_Gadget_VCenter
  ;     #PB_Gadget_HCenter
  ;     #PB_Gadget_Full
  ;     #PB_Gadget_Center = (#PB_Gadget_HCenter|#PB_Gadget_VCenter)
  ;   EndEnumeration
  
  ;   Enumeration - 7 ; Type
  ;     #_Type_Message
  ;     #_Type_PopupMenu
  ;     #_Type_Desktop
  ;     #_Type_StatusBar
  ;     #_Type_Menu           ;  "Menu"
  ;     #_Type_Toolbar        ;  "Toolbar"
  ;     #_Type_Window         ;  "Window"
  ;     #_Type_Unknown        ;  "create" 0
  ;     #_Type_Button         ;  "Button"
  ;     #_Type_String         ;  "String"
  ;     #_Type_Text           ;  "Text"
  ;     #_Type_Checkbox       ;  "Checkbox"
  ;     #_Type_Option         ;  "Option"
  ;     #_Type_ListView       ;  "ListView"
  ;     #_Type_Frame          ;  "Frame"
  ;     #_Type_Combobox       ;  "Combobox"
  ;     #_Type_Image          ;  "Image"
  ;     #_Type_HyperLink      ;  "HyperLink"
  ;     #_Type_Container      ;  "Container"
  ;     #_Type_ListIcon       ;  "ListIcon"
  ;     #_Type_IPAddress      ;  "IPAddress"
  ;     #_Type_ProgressBar    ;  "ProgressBar"
  ;     #_Type_ScrollBar      ;  "ScrollBar"
  ;     #_Type_ScrollArea     ;  "ScrollArea"
  ;     #_Type_TrackBar       ;  "TrackBar"
  ;     #_Type_Web            ;  "Web"
  ;     #_Type_ButtonImage    ;  "ButtonImage"
  ;     #_Type_Calendar       ;  "Calendar"
  ;     #_Type_Date           ;  "Date"
  ;     #_Type_Editor         ;  "Editor"
  ;     #_Type_ExplorerList   ;  "ExplorerList"
  ;     #_Type_ExplorerTree   ;  "ExplorerTree"
  ;     #_Type_ExplorerCombo  ;  "ExplorerCombo"
  ;     #_Type_Spin           ;  "Spin"
  ;     #_Type_Tree           ;  "Tree"
  ;     #_Type_Panel          ;  "Panel"
  ;     #_Type_Splitter       ;  "Splitter"
  ;     #_Type_MDI           
  ;     #_Type_Scintilla      ;  "Scintilla"
  ;     #_Type_Shortcut       ;  "Shortcut"
  ;     #_Type_Canvas         ;  "Canvas"
  ;     
  ;     #_Type_ImageButton    ;  "ImageButton"
  ;     #_Type_Properties     ;  "Properties"
  ;     
  ;     #_Type_StringImageButton    ;  "ImageButton"
  ;     #_Type_StringButton         ;  "ImageButton"
  ;     #_Type_AnchorButton         ;  "ImageButton"
  ;     #_Type_ComboButton          ;  "ImageButton"
  ;     #_Type_DropButton           ;  "ImageButton"
  ;     
  ;   EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_NoButtons ;= 5
    #PB_Bar_Inverted 
    #PB_Bar_Direction ;= 6
    #PB_Bar_Smooth 
    #PB_Bar_Ticks 
  EndEnumeration
  
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_Checkboxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
                                                              ; #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  
  #PB_Widget_First = 1<<7
  #PB_Widget_Second = 1<<8
  #PB_Widget_FirstFixed = 1<<9
  #PB_Widget_SecondFixed = 1<<10
  #PB_Widget_FirstMinimumSize = 1<<11
  #PB_Widget_SecondMinimumSize = 1<<12
  
  EnumerationBinary WidgetFlags
    #PB_Center
    #PB_Right
    #PB_Left = 4
    #PB_Top
    #PB_Bottom
    #PB_Vertical 
    #PB_Horizontal
    #PB_Flag_AutoSize
    
    ;#PB_Toggle
    #PB_BorderLess
    
    #PB_Text_Numeric
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
    #PB_Text_InLine
    
    #PB_Flag_Double
    #PB_Flag_Flat
    #PB_Flag_Raised
    #PB_Flag_Single
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    #PB_Flag_AnchorsGadget
    
    #PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    #PB_Flag_NoGadget
    ;#PB_Flag_Root
    
    #PB_Flag_Limit
  EndEnumeration
  
  #PB_Bar_Vertical = #PB_Vertical
  #PB_AutoSize = #PB_Flag_AutoSize
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Full = #PB_Left|#PB_Right|#PB_Top|#PB_Bottom
  #PB_Gadget_FrameColor = 10
  
  ; Set/Get Attribute
  #PB_DisplayMode = 1<<13
  #PB_Image = 1<<13
  #PB_Text = 1<<14
  #PB_Flag = 1<<15
  #PB_State = 1<<16
  
  
  #PB_DisplayMode_Default =- 1
  
  Enumeration
    #PB_DisplayMode_SmallIcon ;  = #PB_ListIcon_LargeIcon                 ; 0 0
    #PB_DisplayMode_LargeIcon ;  = #PB_ListIcon_SmallIcon                 ; 1 1
  EndEnumeration
  
  EnumerationBinary Attribute
    #PB_State_Selected        ; = #PB_Tree_Selected                       ; 1
    #PB_State_Expanded        ; = #PB_Tree_Expanded                       ; 2
    #PB_State_Checked         ; = #PB_Tree_Checked                        ; 4
    #PB_State_Collapsed       ; = #PB_Tree_Collapsed                      ; 8
    
    #PB_Image_Center
    #PB_Image_Mosaic
    #PB_S_imagetretch
    #PB_Image_Proportionally
    
    #PB_DisplayMode_AlwaysShowSelection                                    ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  EndEnumeration
  ;}
  
  ;   Structure _S_type
  ;     b.b
  ;     i.i 
  ;     s.s
  ;   EndStructure
  
  ;-
  ;- - STRUCTUREs
  ;- - _S_point
  Structure _S_point
    y.l
    x.l
  EndStructure
  
  ;- - _S_color
  Structure _S_color
    state.b ; entered; selected; disabled;
    front.i[4]
    line.i[4]
    fore.i[4]
    back.i[4]
    frame.i[4]
    alpha.a[2]
  EndStructure
  
  ;- - _S_mouse
  Structure _S_mouse Extends _S_point
    buttons.l 
    *delta._S_mouse
  EndStructure
  
  ;- - _S_keyboard
  Structure _S_keyboard
    input.c
    key.i[2]
  EndStructure
  
  ;- - _S_coordinate
  Structure _S_coordinate
    y.l[4]
    x.l[4]
    height.l[4]
    width.l[4]
  EndStructure
  
  ;- - _S_align
  Structure _S_align Extends _S_point
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_box
  Structure _S_box Extends _S_coordinate
    size.i[4]
    hide.b[4]
    checked.b[2] 
    ;toggle.b
    
    arrow_size.a[3]
    arrow_type.b[3]
    
    threeState.b
    *color._S_color[4]
  EndStructure
  
  ;- - _S_anchor
  Structure _S_anchor
    x.i
    y.i
    width.i
    height.i
    
    delta_x.i
    delta_y.i
    
    class.s
    hide.i
    pos.i ; anchor position on the widget
    state.b ; mouse state 
    cursor.i[2]
    
    *widget._S_widget
    color._S_color[4]
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _S_WindowFlag
  Structure _S_windowFlag
    SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
    MinimizeGadget.b ; 13238272   - #PB_Window_MinimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    MaximizeGadget.b ; 13172736   - #PB_Window_MaximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
    Invisible.b      ; 268435456  - #PB_Window_Invisible       ; creates the Window but don't display.
    TitleBar.b       ; 12582912   - #PB_Window_TitleBar        ; creates a Window With a titlebar.
    Tool.b           ; 4          - #PB_Window_Tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
    BorderLess.b     ; 2147483648 - #PB_Window_BorderLess      ; creates a Window without any borders.
    ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
    WindowCentered.b ; 2          - #PB_Window_WindowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
                     ;                X,Y parameters are ignored.
    Maximize.b       ; 16777216   - #PB_Window_Maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
    Minimize.b       ; 536870912  - #PB_Window_Minimize        ; Opens the Window minimized.
    NoGadgets.b      ; 8          - #PB_Window_NoGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    NoActivate.b     ; 33554432   - #PB_Window_NoActivate      ; Don't activate the window after opening.
  EndStructure
  
  ;- - _S_flag
  Structure _S_flag
    Window._S_windowFlag
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    Checkboxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - _S_image
  Structure _S_image
    y.l[3]
    x.l[3]
    height.l
    width.l
    
    index.l
    imageID.i[2] ; - editor
    change.b
    
    align._S_align
  EndStructure
  
  ;- - _S_text
  Structure _S_text Extends _S_coordinate
    big.l[3]
    pos.l
    len.l
    caret.l[3] ; 0 = Pos ; 1 = PosFixed
    
    fontID.i
    string.s[3]
    change.b
    
    pass.b
    lower.b
    upper.b
    numeric.b
    editable.b
    multiLine.b
    vertical.b
    rotate.f
    
    align._S_align
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first._S_widget
    *second._S_widget
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_bar
  Structure _S_bar
    y.l[5]
    x.l[5]
    height.l[5]
    width.l[5]
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    from.l
    
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *parent._S_widget ; adress parent
    *scroll._S_scroll 
    *splitter._S_splitter
    ;*first._S_widget
    ;*second._S_widget
    
    ticks.b  ; track bar
    
    type.b[3] ; [2] for splitter
    radius.a
    cursor.l[2]
    
    max.l
    min.l
    
    hide.b[2]
    *box._S_box
    
    focus.b
    change.l[2]
    resize.b
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
  EndStructure
  
  ;- - _S_scroll
  Structure _S_scroll
    y.l
    x.l
    height.l[4] ; - EditorGadget
    width.l[4]
    
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;- - _S_items
  Structure _S_items Extends _S_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *i_parent._S_items
    drawing.i
    
    image._S_image
    text._S_text[4]
    *box._S_box
    
    state.b
    hide.b[2]
    caret.i[3]  ; 0 = Pos ; 1 = PosFixed
    vertical.b
    radius.a
    
    change.b
    sublevel.i
    sublevellen.i
    
    childrens.i
    *data      ; set/get item data
  EndStructure
  
  ;- - _S_popup
  Structure _S_popup
    gadget.i
    window.i
    
    ; *Widget._S_widget
  EndStructure
  
  ;- - _S_margin
  Structure _S_margin
    FonyID.i
    Width.i
    Color._S_color
  EndStructure
  
  
  ;- - _S_widget
  Structure _S_widget Extends _S_bar
    
    adress.i
    drawing.i
    container.i
    countItems.i[2]
    interact.i
    *_window._S_widget
    *_gadget._S_widget
    
    state.i
    o_i.i ; parent opened item
    parent_item.i ; index parent tab item
    *i_Parent._S_items
    *data
    
    ;*deactive._S_widget
    *leave._S_widget
    
    *Popup._S_widget
    *option_group._S_widget
    
    fs.i 
    bs.i
    grid.i
    enumerate.i
    tabHeight.i
    
    class.s ; 
    level.l ; Вложенность виджета
    type_index.l
    type_count.l
    
    List *childrens._S_widget()
    List *items._S_items()
    List *columns._S_widget()
    ;List *draws._S_items()
    
    flag._S_flag
    *text._S_text[4]
    *image._S_image[2]
    *align._S_align
    
    *function[4] ; IsFunction *Function=0 >> Gadget *Function=1 >> Window *Function=2 >> Root *Function=3
    sublevellen.i
    drag.i[2]
    attribute.i
    
    mouse._S_mouse
    keyboard._S_keyboard
    
    margin._S_margin
    create.b
    
    ;message.i
    repaint.i
    *anchor._S_anchor[#Anchors+1]
    *selector._S_anchor[#Anchors+1]
    
    *event._S_event
  EndStructure
  
  ;- - _S_canvas
  Structure _S_canvas
    window.i
    gadget.i
  EndStructure
  
  ;- - _S_root
  Structure _S_root Extends _S_widget
    canvas._S_canvas
    
    *_open._S_widget
  EndStructure
  
  Prototype fcallback()
  
  ;- - _S_event
  Structure _S_event 
    *callback.fcallback
    *widget._S_widget
    type.l
    item.l
    *data
    ;*leave._S_widget  
    
    *enter._S_widget  
    
    ;draw.b
    
    bind.b
    List *list._S_event()
  EndStructure
  
  ;- - _S_value
  Structure _S_value
    *root._S_root
  EndStructure
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *event._S_event = AllocateStructure(_S_event)
  Global *value._S_value = AllocateStructure(_S_value)
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    *value\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Active()
    Root()\_window
  EndMacro
  
  Macro GetAdress(_this_)
    _this_\adress
  EndMacro
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root)
  EndMacro
  
  Macro IsWidget(_this_)
    Bool(_this_>Root() And _this_<AllocateStructure(_S_widget)) * _this_ ; Bool(MemorySize(_this_)=MemorySize(AllocateStructure(_S_widget))) * _this_
  EndMacro
  
  Macro IsChildrens(_this_)
    ListSize(_this_\childrens())
  EndMacro
  
  ;   Define w  ;TypeOf(_this_)  ; 
  ;   Define *w._S_widget=AllocateStructure(_S_widget)
  ;   Define *w1._S_widget=AllocateStructure(_S_widget)
  ;   Debug ""+*w+" "+*w1+" "+MemorySize(*w)+" "+MemorySize(*w1)
  ;   Debug MemorySize(AllocateStructure(_S_widget))
  ;   Debug *value\this
  ;   Debug IsWidget(345345345999)
  
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  Macro boxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  ; Then scroll bar start position
  Macro _scroll_in_start_(_this_) : Bool(_this_\page\pos =< _this_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\page\pos >= (_this_\max-_this_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro Set_Image(_item_, _image_)
    IsImage(_image_)
    
    _item_\image\change = 1
    _item_\image\index = _image_
    
    If IsImage(_image_)
      _item_\image\imageID = ImageID(_image_)
      _item_\image\width = ImageWidth(_image_)
      _item_\image\height = ImageHeight(_image_)
    Else
      _item_\image\imageID = 0
      _item_\image\width = 0
      _item_\image\height = 0
    EndIf
  EndMacro
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget::*value\this)
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget::*value\this)
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget::*value\this, _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget::*value\this, _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget::*value\this, _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget::*value\this, _type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.s Class(Type.i)
  Declare.i ClassType(Class.s)
  Declare.i SetFont(*this, FontID.i)
  Declare.i IsContainer(*this)
  Declare.i Enumerate(*this.Integer, *Parent, parent_item.i=0)
  
  Declare.i ReDraw(*this=#Null)
  Declare.i Draw(*this, Childrens=0)
  Declare.i Y(*this, Mode.i=0)
  Declare.i X(*this, Mode.i=0)
  Declare.i Width(*this, Mode.i=0)
  Declare.i Height(*this, Mode.i=0)
  Declare.i CountItems(*this)
  Declare.i ClearItems(*this)
  Declare.i RemoveItem(*this, Item.i)
  Declare.b Hide(*this, State.b=-1)
  
  Declare.i GetFocus()
  Declare.i GetActive()
  Declare.i GetState(*this)
  Declare.i GetButtons(*this)
  Declare.i GetDeltaX(*this)
  Declare.i GetDeltaY(*this)
  Declare.i GetMouseX(*this)
  Declare.i GetMouseY(*this)
  Declare.i GetImage(*this)
  Declare.i GetType(*this)
  Declare.i GetData(*this)
  Declare.s GetText(*this)
  Declare.i GetAttribute(*this, Attribute.i)
  Declare.i GetItemData(*this, Item.i)
  Declare.i GetItemImage(*this, Item.i)
  Declare.s GetItemText(*this, Item.i, Column.i=0)
  Declare.i GetItemAttribute(*this, Item.i, Attribute.i)
  
  Declare.i GetLevel(*this)
  Declare.i GetRoot(*this)
  Declare.i GetGadget(*this)
  Declare.i GetWindow(*this)
  Declare.i GetParent(*this)
  Declare.i GetParentItem(*this)
  Declare.i GetPosition(*this, Position.i)
  Declare.i GetAnchors(*this, index.i=-1)
  Declare.i GetCount(*this)
  Declare.s GetClass(*this)
  
  Declare.i SetTransparency(*this, Transparency.a)
  Declare.i SetAnchors(*this)
  Declare.s SetClass(*this, Class.s)
  Declare.i SetActive(*this)
  Declare.i SetState(*this, State.i)
  Declare.i SetAttribute(*this, Attribute.i, Value.i)
  Declare.i CallBack(*this, EventType.i, mouse_x=0, mouse_y=0)
  Declare.i SetColor(*this, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i SetImage(*this, Image.i)
  Declare.i SetData(*this, *Data)
  Declare.i SetText(*this, Text.s)
  Declare.i GetItemState(*this, Item.i)
  Declare.i SetItemState(*this, Item.i, State.i)
  Declare.i From(*this, mouse_x.i, mouse_y.i)
  Declare.i SetPosition(*this, Position.i, *Widget_2 =- 1)
  Declare.i Free(*this)
  
  Declare.i SetParent(*this, *Parent, parent_item.i=-1)
  Declare.i SetAlignment(*this, Mode.i, Type.i=1)
  Declare.i SetItemData(*this, Item.i, *Data)
  Declare.i SetItemAttribute(*this, Item.i, Attribute.i, Value.i)
  Declare.i SetItemText(*this, Item.i, Text.s)
  Declare.i SetFlag(*this, Flag.i)
  Declare.i SetItemImage(*this, Item.i, Image.i)
  
  Declare.i AddItem(*this, Item.i, Text.s, Image.i=-1, Flag.i=0)
  Declare.i AddColumn(*this, Position.i, Title.s, Width.i)
  Declare.i Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.i Popup(*Widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
  Declare.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
  Declare.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1)
  Declare.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Property(X.l,Y.l,Width.l,Height.l, SplitterPos.i = 80, Flag.i=0)
  Declare.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
  Declare.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
  Declare.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  Declare.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *Widget=0)
  Declare.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
  Declare.i IPAddress(X.l,Y.l,Width.l,Height.l)
  Declare.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
  Declare.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
  Declare.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Panel(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  
  Declare.i CloseList()
  Declare.i OpenList(*this, Item.l=0)
  Declare.i Bind(*callback, *this=#PB_All, eventtype.l=#PB_All)
  Declare.i Post(eventtype.l, *this, eventitem.l=#PB_All, *data=0)
  Declare.i Open(Window.i, X.l,Y.l,Width.l,Height.l, Text.s="", Flag.i=0, WindowID.i=0)
  Declare.i Create(Type.i, X.l,Y.l,Width.l,Height.l, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, parent_item.i=0)
  
  Declare.i Resizes(*Scroll, X.l,Y.l,Width.l,Height.l)
  Declare.i Updates(*Scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
  Declare.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
EndDeclareModule

Module Widget
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If Value>Max 
        Value=Max 
      EndIf
    EndIf
    
    ProcedureReturn Value
    ;   Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ;     ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_Round_Nearest) * Grid)))
  EndProcedure
  
  ;- MODULE
  ;
  Declare.i g_Callback()
  Declare.i w_Events(*this, EventType.i, EventItem.i=-1, EventData.i=0)
  Declare.i Events(*this, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
  
  ;- GLOBALs
  Global def_colors._S_color
  
  With def_colors                          
    \state = 0
    \alpha = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[0] = $FFE2E2E2 ; $80E2E2E2
    \frame[0] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFEAEAEA ; $FFFAF8F8
    \back[1] = $FFCECECE ; $80FCEADA
    \frame[1] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
  EndWith
  
  ;- MACOS
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
    
    Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        CocoaMessage(@alpha, nscolorspace, "alphaComponent")
        rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
        ProcedureReturn rgba
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
        ProcedureReturn rgb
      EndIf
    EndProcedure
    
  CompilerEndIf
  
  ;-
  Macro _set_last_parameters_(_this_, _type_, _flag_)
    *event\widget = _this_
    _this_\type = _type_
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    If Root()\_open
      If _this_\type = #PB_GadgetType_Option
        If ListSize(Root()\_open\childrens()) 
          If Root()\_open\childrens()\type = #PB_GadgetType_Option
            _this_\option_group = Root()\_open\childrens()\option_group 
          Else
            _this_\option_group = Root()\_open\childrens() 
          EndIf
        Else
          _this_\option_group = Root()\_open
        EndIf
      EndIf
      
      SetParent(_this_, Root()\_open, Root()\_open\o_i)
    EndIf
    
    ; _set_auto_size_
    If Bool(_flag_ & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
      _this_\align = AllocateStructure(_S_align)
      _this_\align\autoSize = 1
      _this_\align\left = 1
      _this_\align\top = 1
      _this_\align\right = 1
      _this_\align\bottom = 1
    EndIf
    
    If Bool(_flag_ & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget) And _this_\root And Not _this_\root\anchor
      
      AddAnchors(_this_\root)
      SetAnchors(_this_)
      
    EndIf
  EndMacro
  
  Macro Set_Cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_Cursor(_this_)
    GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor)
  EndMacro
  
  ; ; ;   ; Extract thumb len from (max area page) len
  ; ; ;   Macro _thumb_len_(_this_)
  ; ; ;     Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
  ; ; ;     
  ; ; ;     If _this_\thumb\len > _this_\area\len 
  ; ; ;       _this_\thumb\len = _this_\area\len 
  ; ; ;     EndIf 
  ; ; ;     
  ; ; ; ;     If _this_\Vertical
  ; ; ; ;       _this_\button[#Thumb]\height = _this_\thumb\len
  ; ; ; ;     Else
  ; ; ; ;       _this_\button[#Thumb]\width = _this_\thumb\len
  ; ; ; ;     EndIf
  ; ; ;     If _this_\box 
  ; ; ;       If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
  ; ; ;         _this_\box\height[3] = _this_\thumb\len 
  ; ; ;       Else 
  ; ; ;         _this_\box\width[3] = _this_\thumb\len 
  ; ; ;       EndIf
  ; ; ;     EndIf
  ; ; ;     
  ; ; ;     _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  ; ; ;   EndMacro
  ; ; ;   
  ; ; ;   Macro _thumb_pos_(_this_, _scroll_pos_)
  ; ; ;     (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
  ; ; ;     
  ; ; ;     If _this_\thumb\pos < _this_\area\pos 
  ; ; ;       _this_\thumb\pos = _this_\area\pos 
  ; ; ;     EndIf 
  ; ; ;     
  ; ; ;     If _this_\thumb\pos > _this_\area\end
  ; ; ;       _this_\thumb\pos = _this_\area\end
  ; ; ;     EndIf
  ; ; ;     
  ; ; ;     ; _start_
  ; ; ;     If _this_\thumb\pos = _this_\area\pos
  ; ; ;       _this_\color[1]\state = 3
  ; ; ;     Else
  ; ; ;       _this_\color[1]\state = 0
  ; ; ;     EndIf 
  ; ; ;     
  ; ; ;     ; _stop_
  ; ; ;     If _this_\thumb\pos = _this_\area\end
  ; ; ;       _this_\color[2]\state = 3
  ; ; ;     Else
  ; ; ;       _this_\color[2]\state = 0
  ; ; ;     EndIf 
  ; ; ;     
  ; ; ; ; ;     If _this_\vertical
  ; ; ; ; ;       _this_\button[#Thumb]\y = _this_\thumb\pos
  ; ; ; ; ;     Else
  ; ; ; ; ;       _this_\button[#Thumb]\x = _this_\thumb\pos
  ; ; ; ; ;     EndIf
  ; ; ;     If _this_\box
  ; ; ;       If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
  ; ; ;         _this_\box\y[3] = _this_\thumb\pos 
  ; ; ;       Else 
  ; ; ;         _this_\box\x[3] = _this_\thumb\pos 
  ; ; ;       EndIf
  ; ; ;     EndIf
  ; ; ;       
  ; ; ;     _this_\page\end = (_this_\min + Round((_this_\area\end - _this_\area\pos) / (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
  ; ; ;   EndMacro
  
  
  ; SCROLLBAR
  Macro _thumb_len_(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    ;     If _this_\thumb\len > _this_\area\len 
    ;       _this_\thumb\len = _this_\area\len 
    ;     EndIf 
    
    If _this_\box 
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\height[3] = _this_\thumb\len 
      Else 
        _this_\box\width[3] = _this_\thumb\len 
      EndIf
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    ;     If _this_\thumb\pos < _this_\area\pos 
    ;       _this_\thumb\pos = _this_\area\pos 
    ;     EndIf 
    ;     
    ;     If _this_\thumb\pos > _this_\area\pos+_this_\area\len 
    ;       _this_\thumb\pos = (_this_\area\pos+_this_\area\len)-_this_\thumb\len 
    ;     EndIf 
    
    If _this_\box
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\y[3] = _this_\thumb\pos 
      Else 
        _this_\box\x[3] = _this_\thumb\pos 
      EndIf
    EndIf
  EndMacro
  
  Procedure.i PagePos(*this._S_widget, State.i)
    With *this
      If State < \min : State = \min : EndIf
      
      If \max And State > \max-\page\len
        If \max > \page\len 
          State = \max-\page\len
        Else
          State = \min 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn State
  EndProcedure
  
  Procedure.i _ScrollPos(*this._S_widget, _thumb_pos_.i)
    Static ScrollPos.i
    Protected Result.i
    
    With *this
      _thumb_pos_ = \min + Round((_thumb_pos_ - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
      If \scrollstep > 1
        _thumb_pos_ = Round(_thumb_pos_ / \scrollstep, #PB_Round_Nearest) * \scrollstep
      EndIf
      
      If _thumb_pos_ < \min : _thumb_pos_ = \min : EndIf
      If _thumb_pos_ > (\max-\page\len) : _thumb_pos_ = (\max-\page\len) : EndIf
      
      If ScrollPos <> _thumb_pos_ 
        If #PB_GadgetType_TrackBar = \type And \vertical 
          _thumb_pos_ = _invert_(*this, _thumb_pos_, \inverted)
        EndIf
        
        Result = SetState(*this, _thumb_pos_)
        ScrollPos = _thumb_pos_
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i ScrollPos(*this._S_widget, _thumb_pos_.i)
    Static Pos.i
    Protected Result.i
    Protected ScrollPos.i
    
    With *this
      ;       Protected ThumbLen 
      ;       If \thumb\len = \box\size
      ;        ; ThumbLen = (Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest) - \thumb\len) - \thumb\len - 1
      ;        ThumbLen = (Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest) - \thumb\len) - \thumb\len - 1 - 2
      ;       Else
      ;         ThumbLen = \thumb\len - 1
      ;       EndIf
      ;       Debug ""+ThumbLen +" "+ \areaend +" "+ Str(\area\pos+(\area\len-ThumbLen)) +" "+ \area\len
      
      If _thumb_pos_ < \area\pos : _thumb_pos_ = \area\pos : EndIf
      If _thumb_pos_ > \area\end : _thumb_pos_ = \area\end : EndIf
      
      If Pos <> _thumb_pos_ 
        ScrollPos = \min + Round((_thumb_pos_ - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        ;         If \scrollstep > 1
        ;           ScrollPos = Round(ScrollPos / \scrollstep, #PB_Round_Nearest) * \scrollstep
        ;         EndIf
        
        ;         If ScrollPos < \min : ScrollPos = \min : EndIf
        ;         If ScrollPos > (\max-\page\len) : ScrollPos = (\max-\page\len) : EndIf
        
        ;       If Pos <> ScrollPos 
        If #PB_GadgetType_TrackBar = \type And \vertical 
          ScrollPos = _invert_(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
        ;         Pos = ScrollPos
        
        Pos = _thumb_pos_
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- Anchors
  Macro Draw_Anchors(_this_)
    If _this_\root\anchor
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\anchor[#Anchor_moved] : Box(_this_\root\anchor[#Anchor_moved]\x, _this_\root\anchor[#Anchor_moved]\y, _this_\root\anchor[#Anchor_moved]\width, _this_\root\anchor[#Anchor_moved]\height ,_this_\root\anchor[#Anchor_moved]\color[_this_\root\anchor[#Anchor_moved]\state]\frame) : EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      If _this_\root\anchor[1] : Box(_this_\root\anchor[1]\x, _this_\root\anchor[1]\y, _this_\root\anchor[1]\width, _this_\root\anchor[1]\height ,_this_\root\anchor[1]\color[_this_\root\anchor[1]\state]\back) : EndIf
      If _this_\root\anchor[2] : Box(_this_\root\anchor[2]\x, _this_\root\anchor[2]\y, _this_\root\anchor[2]\width, _this_\root\anchor[2]\height ,_this_\root\anchor[2]\color[_this_\root\anchor[2]\state]\back) : EndIf
      If _this_\root\anchor[3] : Box(_this_\root\anchor[3]\x, _this_\root\anchor[3]\y, _this_\root\anchor[3]\width, _this_\root\anchor[3]\height ,_this_\root\anchor[3]\color[_this_\root\anchor[3]\state]\back) : EndIf
      If _this_\root\anchor[4] : Box(_this_\root\anchor[4]\x, _this_\root\anchor[4]\y, _this_\root\anchor[4]\width, _this_\root\anchor[4]\height ,_this_\root\anchor[4]\color[_this_\root\anchor[4]\state]\back) : EndIf
      If _this_\root\anchor[5] And Not _this_\container : Box(_this_\root\anchor[5]\x, _this_\root\anchor[5]\y, _this_\root\anchor[5]\width, _this_\root\anchor[5]\height ,_this_\root\anchor[5]\color[_this_\root\anchor[5]\state]\back) : EndIf
      If _this_\root\anchor[6] : Box(_this_\root\anchor[6]\x, _this_\root\anchor[6]\y, _this_\root\anchor[6]\width, _this_\root\anchor[6]\height ,_this_\root\anchor[6]\color[_this_\root\anchor[6]\state]\back) : EndIf
      If _this_\root\anchor[7] : Box(_this_\root\anchor[7]\x, _this_\root\anchor[7]\y, _this_\root\anchor[7]\width, _this_\root\anchor[7]\height ,_this_\root\anchor[7]\color[_this_\root\anchor[7]\state]\back) : EndIf
      If _this_\root\anchor[8] : Box(_this_\root\anchor[8]\x, _this_\root\anchor[8]\y, _this_\root\anchor[8]\width, _this_\root\anchor[8]\height ,_this_\root\anchor[8]\color[_this_\root\anchor[8]\state]\back) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\anchor[1] : Box(_this_\root\anchor[1]\x, _this_\root\anchor[1]\y, _this_\root\anchor[1]\width, _this_\root\anchor[1]\height ,_this_\root\anchor[1]\color[_this_\root\anchor[1]\state]\frame) : EndIf
      If _this_\root\anchor[2] : Box(_this_\root\anchor[2]\x, _this_\root\anchor[2]\y, _this_\root\anchor[2]\width, _this_\root\anchor[2]\height ,_this_\root\anchor[2]\color[_this_\root\anchor[2]\state]\frame) : EndIf
      If _this_\root\anchor[3] : Box(_this_\root\anchor[3]\x, _this_\root\anchor[3]\y, _this_\root\anchor[3]\width, _this_\root\anchor[3]\height ,_this_\root\anchor[3]\color[_this_\root\anchor[3]\state]\frame) : EndIf
      If _this_\root\anchor[4] : Box(_this_\root\anchor[4]\x, _this_\root\anchor[4]\y, _this_\root\anchor[4]\width, _this_\root\anchor[4]\height ,_this_\root\anchor[4]\color[_this_\root\anchor[4]\state]\frame) : EndIf
      If _this_\root\anchor[5] : Box(_this_\root\anchor[5]\x, _this_\root\anchor[5]\y, _this_\root\anchor[5]\width, _this_\root\anchor[5]\height ,_this_\root\anchor[5]\color[_this_\root\anchor[5]\state]\frame) : EndIf
      If _this_\root\anchor[6] : Box(_this_\root\anchor[6]\x, _this_\root\anchor[6]\y, _this_\root\anchor[6]\width, _this_\root\anchor[6]\height ,_this_\root\anchor[6]\color[_this_\root\anchor[6]\state]\frame) : EndIf
      If _this_\root\anchor[7] : Box(_this_\root\anchor[7]\x, _this_\root\anchor[7]\y, _this_\root\anchor[7]\width, _this_\root\anchor[7]\height ,_this_\root\anchor[7]\color[_this_\root\anchor[7]\state]\frame) : EndIf
      If _this_\root\anchor[8] : Box(_this_\root\anchor[8]\x, _this_\root\anchor[8]\y, _this_\root\anchor[8]\width, _this_\root\anchor[8]\height ,_this_\root\anchor[8]\color[_this_\root\anchor[8]\state]\frame) : EndIf
      
      
      If _this_\root\anchor[10] : Box(_this_\root\anchor[10]\x, _this_\root\anchor[10]\y, _this_\root\anchor[10]\width, _this_\root\anchor[10]\height ,_this_\root\anchor[10]\color[_this_\root\anchor[10]\state]\frame) : EndIf
      If _this_\root\anchor[11] : Box(_this_\root\anchor[11]\x, _this_\root\anchor[11]\y, _this_\root\anchor[11]\width, _this_\root\anchor[11]\height ,_this_\root\anchor[11]\color[_this_\root\anchor[11]\state]\frame) : EndIf
      If _this_\root\anchor[12] : Box(_this_\root\anchor[12]\x, _this_\root\anchor[12]\y, _this_\root\anchor[12]\width, _this_\root\anchor[12]\height ,_this_\root\anchor[12]\color[_this_\root\anchor[12]\state]\frame) : EndIf
      If _this_\root\anchor[13] : Box(_this_\root\anchor[13]\x, _this_\root\anchor[13]\y, _this_\root\anchor[13]\width, _this_\root\anchor[13]\height ,_this_\root\anchor[13]\color[_this_\root\anchor[13]\state]\frame) : EndIf
    EndIf
  EndMacro
  
  Macro Resize_Anchors(_this_)
    If _this_\root\anchor[1] ; left
      _this_\root\anchor[1]\x = _this_\x-_this_\root\anchor[1]\width+_this_\root\anchor[1]\pos
      _this_\root\anchor[1]\y = _this_\y+(_this_\height-_this_\root\anchor[1]\height)/2
    EndIf
    If _this_\root\anchor[2] ; top
      _this_\root\anchor[2]\x = _this_\x+(_this_\width-_this_\root\anchor[2]\width)/2
      _this_\root\anchor[2]\y = _this_\y-_this_\root\anchor[2]\height+_this_\root\anchor[2]\pos
    EndIf
    If  _this_\root\anchor[3] ; right
      _this_\root\anchor[3]\x = _this_\x+_this_\width-_this_\root\anchor[3]\pos
      _this_\root\anchor[3]\y = _this_\y+(_this_\height-_this_\root\anchor[3]\height)/2
    EndIf
    If _this_\root\anchor[4] ; bottom
      _this_\root\anchor[4]\x = _this_\x+(_this_\width-_this_\root\anchor[4]\width)/2
      _this_\root\anchor[4]\y = _this_\y+_this_\height-_this_\root\anchor[4]\pos
    EndIf
    
    If _this_\root\anchor[5] ; left&top
      _this_\root\anchor[5]\x = _this_\x-_this_\root\anchor[5]\width+_this_\root\anchor[5]\pos
      _this_\root\anchor[5]\y = _this_\y-_this_\root\anchor[5]\height+_this_\root\anchor[5]\pos
    EndIf
    If _this_\root\anchor[6] ; right&top
      _this_\root\anchor[6]\x = _this_\x+_this_\width-_this_\root\anchor[6]\pos
      _this_\root\anchor[6]\y = _this_\y-_this_\root\anchor[6]\height+_this_\root\anchor[6]\pos
    EndIf
    If _this_\root\anchor[7] ; right&bottom
      _this_\root\anchor[7]\x = _this_\x+_this_\width-_this_\root\anchor[7]\pos
      _this_\root\anchor[7]\y = _this_\y+_this_\height-_this_\root\anchor[7]\pos
    EndIf
    If _this_\root\anchor[8] ; left&bottom
      _this_\root\anchor[8]\x = _this_\x-_this_\root\anchor[8]\width+_this_\root\anchor[8]\pos
      _this_\root\anchor[8]\y = _this_\y+_this_\height-_this_\root\anchor[8]\pos
    EndIf
    
    If _this_\root\anchor[#Anchor_moved] 
      _this_\root\anchor[#Anchor_moved]\x = _this_\x
      _this_\root\anchor[#Anchor_moved]\y = _this_\y
      _this_\root\anchor[#Anchor_moved]\width = _this_\width
      _this_\root\anchor[#Anchor_moved]\height = _this_\height
    EndIf
    
    If _this_\root\anchor[10] And _this_\root\anchor[11] And _this_\root\anchor[12] And _this_\root\anchor[13]
      Lines_Anchors(_this_)
    EndIf
    
  EndMacro
  
  Procedure Lines_Anchors(*Gadget._S_widget=-1, distance=0)
    Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    With *Gadget
      If *Gadget
        checked_x1 = \x
        checked_y1 = \y
        checked_x2 = checked_x1+\width
        checked_y2 = checked_y1+\height
        
        top_x1 = checked_x1 : top_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 
        right_y1 = checked_y1 : right_y2 = checked_y2
        bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        
        PushListPosition(\parent\childrens())
        ForEach \parent\childrens()
          If Not \parent\childrens()\hide
            relative_x1 = \parent\childrens()\x
            relative_y1 = \parent\childrens()\y
            relative_x2 = relative_x1+\parent\childrens()\width
            relative_y2 = relative_y1+\parent\childrens()\height
            
            ;Left_line
            If checked_x1 = relative_x1
              If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
              If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
              
              ; \root\anchor[10]\color[0]\frame = $0000FF
              \root\anchor[10]\hide = 0
              \root\anchor[10]\x = checked_x1
              \root\anchor[10]\y = left_y1
              \root\anchor[10]\width = ls
              \root\anchor[10]\height = left_y2-left_y1
            Else
              ; \root\anchor[10]\color[0]\frame = $000000
              \root\anchor[10]\hide = 1
            EndIf
            
            ;Right_line
            If checked_x2 = relative_x2
              If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
              If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
              
              \root\anchor[12]\hide = 0
              \root\anchor[12]\x = checked_x2-ls
              \root\anchor[12]\y = right_y1
              \root\anchor[12]\width = ls
              \root\anchor[12]\height = right_y2-right_y1
            Else
              \root\anchor[12]\hide = 1
            EndIf
            
            ;Top_line
            If checked_y1 = relative_y1 
              If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
              If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
              
              \root\anchor[11]\hide = 0
              \root\anchor[11]\x = top_x1
              \root\anchor[11]\y = checked_y1
              \root\anchor[11]\width = top_x2-top_x1
              \root\anchor[11]\height = ls
            Else
              \root\anchor[11]\hide = 1
            EndIf
            
            ;Bottom_line
            If checked_y2 = relative_y2 
              If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
              If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
              
              \root\anchor[13]\hide = 0
              \root\anchor[13]\x = bottom_x1
              \root\anchor[13]\y = checked_y2-ls
              \root\anchor[13]\width = bottom_x2-bottom_x1
              \root\anchor[13]\height = ls
            Else
              \root\anchor[13]\hide = 1
            EndIf
          EndIf
        Next
        PopListPosition(\parent\childrens())
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure Anchors_Events(*this._S_widget, mouse_x.i, mouse_y.i)
    With *this
      Protected.i Px,Py, Grid = \grid, IsGrid = Bool(Grid>1)
      
      If \parent
        Px = \parent\x[2]
        Py = \parent\y[2]
      EndIf
      
      Protected mx = Match(mouse_x-Px, Grid)
      Protected my = Match(mouse_y-Py, Grid)
      Protected mw = Match((\x+\width-IsGrid)-mouse_x, Grid)+IsGrid
      Protected mh = Match((\y+\height-IsGrid)-mouse_y, Grid)+IsGrid
      Protected mxw = Match(mouse_x-\x, Grid)+IsGrid
      Protected myh = Match(mouse_y-\y, Grid)+IsGrid
      
      Select \root\anchor
        Case \root\anchor[1] : Resize(*this, mx, #PB_Ignore, mw, #PB_Ignore)
        Case \root\anchor[2] : Resize(*this, #PB_Ignore, my, #PB_Ignore, mh)
        Case \root\anchor[3] : Resize(*this, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
        Case \root\anchor[4] : Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
          
        Case \root\anchor[5] 
          If \container ; Form, Container, ScrollArea, Panel
            Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
          Else
            Resize(*this, mx, my, mw, mh)
          EndIf
          
        Case \root\anchor[6] : Resize(*this, #PB_Ignore, my, mxw, mh)
        Case \root\anchor[7] : Resize(*this, #PB_Ignore, #PB_Ignore, mxw, myh)
        Case \root\anchor[8] : Resize(*this, mx, #PB_Ignore, mw, myh)
          
        Case \root\anchor[#Anchor_moved] 
          If Not \container
            Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure CallBack_Anchors(*this._S_widget, EventType.i, Buttons.i, mouse_x.i,mouse_y.i)
    Protected i 
    
    With *this
      If \root\anchor 
        Select EventType 
          Case #PB_EventType_MouseMove
            If \root\anchor\state = 2
              
              ProcedureReturn Anchors_Events(\root\anchor\widget, mouse_x-\root\anchor\delta_x, mouse_y-\root\anchor\delta_y)
              
            ElseIf Not Buttons
              ; From anchor
              For i = 1 To #Anchors 
                If \root\anchor[i]
                  If (mouse_x>\root\anchor[i]\x And mouse_x=<\root\anchor[i]\x+\root\anchor[i]\width And 
                      mouse_y>\root\anchor[i]\y And mouse_y=<\root\anchor[i]\y+\root\anchor[i]\height)
                    
                    \root\anchor\state = 0
                    \root\anchor\widget = 0
                    \root\anchor = \root\anchor[i]
                    \root\anchor\widget = *this
                    Break
                  EndIf
                EndIf
              Next
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            \root\anchor\state = 2 
            \root\anchor\delta_x = mouse_x-\root\anchor\x
            \root\anchor\delta_y = mouse_y-\root\anchor\y
            
          Case #PB_EventType_LeftButtonUp
            \root\anchor\state = 1 
            
        EndSelect
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i AddAnchors(*this._S_widget, Size.i=5)
    Structure DataBuffer
      cursor.i[#Anchors+1]
    EndStructure
    
    Protected i, *Cursor.DataBuffer = ?CursorsBuffer
    
    With *this
      If \parent
        If \parent\type = #PB_GadgetType_Splitter
          ProcedureReturn
        EndIf
        
        \grid = \parent\grid
      Else
        If \container
          \grid = Size
        Else
          \grid = Size
        EndIf
      EndIf
      
      For i = 1 To #Anchors
        \root\anchor[i] = AllocateStructure(_S_anchor)
        \root\anchor[i]\color[0]\frame = $000000
        \root\anchor[i]\color[1]\frame = $FF0000
        \root\anchor[i]\color[2]\frame = $0000FF
        
        \root\anchor[i]\color[0]\back = $FFFFFF
        \root\anchor[i]\color[1]\back = $FFFFFF
        \root\anchor[i]\color[2]\back = $FFFFFF
        
        \root\anchor[i]\width = 6
        \root\anchor[i]\height = 6
        
        If \container And i = 5
          \root\anchor[5]\width * 2
          \root\anchor[5]\height * 2
        EndIf
        
        If i=10 Or i=12
          \root\anchor[i]\color[0]\frame = $0000FF
          ;           \root\anchor[i]\color[1]\frame = $0000FF
          ;           \root\anchor[i]\color[2]\frame = $0000FF
        EndIf
        If i=11 Or i=13
          \root\anchor[i]\color[0]\frame = $FF0000
          ;           \root\anchor[i]\color[1]\frame = $FF0000
          ;           \root\anchor[i]\color[2]\frame = $FF0000
        EndIf
        
        \root\anchor[i]\pos = \root\anchor[i]\width-3
      Next i
      
      
      \root\anchor[1]\class = "left"
      \root\anchor[2]\class = "top"
      \root\anchor[3]\class = "right"
      \root\anchor[4]\class = "botom"
      \root\anchor[5]\class = "lefttop"
      \root\anchor[6]\class = "righttop"
      \root\anchor[7]\class = "rightbottom"
      \root\anchor[8]\class = "leftbottom"
      \root\anchor[9]\class = "move"
      
      
    EndWith
    
    DataSection
      CursorsBuffer:
      Data.i 0
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_Arrows
    EndDataSection
  EndProcedure
  
  
  Procedure.i GetAnchors(*this._S_widget, index.i=-1)
    ProcedureReturn Bool(*this\root\anchor[(Bool(index.i=-1) * #Anchor_moved) + (Bool(index.i>0) * index)]) * *this
  EndProcedure
  
  Procedure.i RemoveAnchors(*this._S_widget)
    Protected Result.i
    
    With *this
      If \root\anchor
        Result = \root\anchor
        \root\anchor = 0
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAnchors(*this._S_widget)
    Protected Result.i
    Static *LastPos, *Last._S_widget
    
    With *this
      If \root\anchor[#Anchor_moved] And *Last <> *this
        If *Last
          If *LastPos
            ; Возврашаем на место
            SetPosition(*Last, #PB_List_Before, *LastPos)
            *LastPos = 0
          EndIf
        EndIf
        
        *LastPos = GetPosition(*this, #PB_List_After)
        SetPosition(*this, #PB_List_Last)
        *Last = *this
        
        \root\anchor = \root\anchor[#Anchor_moved]
        \root\anchor\widget = *this
        
        If \container
          \root\anchor[5]\width = 12
          \root\anchor[5]\height = 12
        Else
          \root\anchor[5]\width = 6
          \root\anchor[5]\height = 6
        EndIf
        \root\anchor[5]\pos = \root\anchor[5]\width-3
        
        Resize_Anchors(*this)
        
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  ;- DRAWPOPUP
  ;-
  Procedure CallBack_Popup()
    Protected *this._S_widget = GetWindowData(EventWindow())
    Protected EventItem.i
    Protected mouse_x =- 1
    Protected mouse_y =- 1
    
    If *this
      With *this
        Select Event()
          Case #PB_Event_ActivateWindow
            Protected *Widget._S_widget = GetGadgetData(\root\canvas\gadget)
            
            If CallBack(\childrens(), #PB_EventType_LeftButtonDown, WindowMouseX(\root\canvas\window), WindowMouseY(\root\canvas\window))
              ; If \childrens()\index[#Selected] <> \childrens()\index[#Entered]
              *Widget\index[#Selected] = \childrens()\index[#Entered]
              Post(#PB_EventType_Change, *Widget, \childrens()\index[#Entered])
              
              SetText(*Widget, GetItemText(\childrens(), \childrens()\index[#Entered]))
              \childrens()\index[#Selected] = \childrens()\index[#Entered]
              \childrens()\mouse\buttons = 0
              \childrens()\index[#Entered] =- 1
              \childrens()\focus = 1
              \mouse\buttons = 0
              ReDraw(*this)
              ; EndIf
            EndIf
            
            SetActiveGadget(*Widget\root\canvas\gadget)
            *Widget\color\state = 0
            *Widget\box\checked = 0
            SetActive(*Widget)
            ReDraw(*Widget\root)
            HideWindow(\root\canvas\window, 1)
            
          Case #PB_Event_Gadget
            mouse_x = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            mouse_y= GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
            
            If CallBack(From(*this, mouse_x, mouse_y), EventType(), mouse_x, mouse_y)
              ReDraw(*this)
            EndIf
            
        EndSelect
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Display_Popup(*this._S_widget, *Widget._S_widget, x.i=#PB_Ignore,y.i=#PB_Ignore)
    With *this
      If X=#PB_Ignore 
        X = \x+GadgetX(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        
        ForEach *Widget\childrens()\items()
          If *Widget\childrens()\items()\text\change = 1
            *Widget\childrens()\items()\text\height = TextHeight("A")
            *Widget\childrens()\items()\text\width = TextWidth(*Widget\childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\childrens()\scroll\width < (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\page\pos
            *Widget\childrens()\scroll\width = (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\page\pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      SetActive(*Widget\childrens())
      ;*Widget\childrens()\focus = 1
      
      Protected Width = *Widget\childrens()\scroll\width + *Widget\childrens()\bs*2 
      Protected Height = *Widget\childrens()\scroll\height + *Widget\childrens()\bs*2 
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, #PB_Ignore,#PB_Ignore, width, Height )
      If *Widget\resize
        ResizeWindow(*Widget\root\canvas\window, x, y, width, Height)
        ResizeGadget(*Widget\root\canvas\gadget, #PB_Ignore, #PB_Ignore, width, Height)
      EndIf
    EndWith
    
    ReDraw(*Widget)
    
    HideWindow(*Widget\root\canvas\window, 0, #PB_Window_NoActivate)
  EndProcedure
  
  Procedure.i Popup(*Widget._S_widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    With *this
      If *this
        \root = *this
        \type = #PB_GadgetType_Popup
        \container = #PB_GadgetType_Popup
        \color = def_colors
        \color\fore = 0
        \color\back = $FFF0F0F0
        \color\alpha = 255
        \color[1]\alpha = 128
        \color[2]\alpha = 128
        \color[3]\alpha = 128
        
        If X=#PB_Ignore 
          X = *Widget\x+GadgetX(*Widget\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        If IsWindow(*Widget\root\canvas\window)
          Protected WindowID = WindowID(*Widget\root\canvas\window)
        EndIf
        
        \root\parent = *Widget
        \root\canvas\window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \root\canvas\gadget = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(\root, 1,1, width, Height)
        
        SetWindowData(\root\canvas\window, *this)
        SetGadgetData(\root\canvas\gadget, *Widget)
        
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \root\canvas\window);, \canvas\gadget )
        BindGadgetEvent(\root\canvas\gadget, @CallBack_Popup())
      EndIf
    EndWith  
    
    ProcedureReturn *this
  EndProcedure
  
  
  
  ;-
  Procedure.s Class(Type.i)
    Protected Result.s
    
    Select Type
      Case #PB_GadgetType_Button         : Result = "Button"
      Case #PB_GadgetType_ButtonImage    : Result = "ButtonImage"
      Case #PB_GadgetType_Calendar       : Result = "Calendar"
      Case #PB_GadgetType_Canvas         : Result = "Canvas"
      Case #PB_GadgetType_CheckBox       : Result = "Checkbox"
      Case #PB_GadgetType_ComboBox       : Result = "Combobox"
      Case #PB_GadgetType_Container      : Result = "Container"
      Case #PB_GadgetType_Date           : Result = "Date"
      Case #PB_GadgetType_Editor         : Result = "Editor"
      Case #PB_GadgetType_ExplorerCombo  : Result = "ExplorerCombo"
      Case #PB_GadgetType_ExplorerList   : Result = "ExplorerList"
      Case #PB_GadgetType_ExplorerTree   : Result = "ExplorerTree"
      Case #PB_GadgetType_Frame          : Result = "Frame"
      Case #PB_GadgetType_HyperLink      : Result = "HyperLink"
      Case #PB_GadgetType_Image          : Result = "Image"
      Case #PB_GadgetType_IPAddress      : Result = "IPAddress"
      Case #PB_GadgetType_ListIcon       : Result = "ListIcon"
      Case #PB_GadgetType_ListView       : Result = "ListView"
      Case #PB_GadgetType_MDI            : Result = "MDI"
      Case #PB_GadgetType_OpenGL         : Result = "OpenGL"
      Case #PB_GadgetType_Option         : Result = "Option"
      Case #PB_GadgetType_Popup          : Result = "Popup"
      Case #PB_GadgetType_Panel          : Result = "Panel"
      Case #PB_GadgetType_Property       : Result = "Property"
      Case #PB_GadgetType_ProgressBar    : Result = "ProgressBar"
      Case #PB_GadgetType_Scintilla      : Result = "Scintilla"
      Case #PB_GadgetType_ScrollArea     : Result = "ScrollArea"
      Case #PB_GadgetType_ScrollBar      : Result = "ScrollBar"
      Case #PB_GadgetType_Shortcut       : Result = "Shortcut"
      Case #PB_GadgetType_Spin           : Result = "Spin"
      Case #PB_GadgetType_Splitter       : Result = "Splitter"
      Case #PB_GadgetType_String         : Result = "String"
      Case #PB_GadgetType_Text           : Result = "Text"
      Case #PB_GadgetType_TrackBar       : Result = "TrackBar"
      Case #PB_GadgetType_Tree           : Result = "Tree"
      Case #PB_GadgetType_Unknown        : Result = "Unknown"
      Case #PB_GadgetType_Web            : Result = "Web"
      Case #PB_GadgetType_Window         : Result = "Window"
      Case #PB_GadgetType_Root           : Result = "Root"
    EndSelect
    
    ProcedureReturn Result.s
  EndProcedure
  
  Procedure.i ClassType(Class.s)
    Protected Result.i
    
    Select Trim(Class.s)
      Case "Button"         : Result = #PB_GadgetType_Button
      Case "ButtonImage"    : Result = #PB_GadgetType_ButtonImage
      Case "Calendar"       : Result = #PB_GadgetType_Calendar
      Case "Canvas"         : Result = #PB_GadgetType_Canvas
      Case "Checkbox"       : Result = #PB_GadgetType_CheckBox
      Case "Combobox"       : Result = #PB_GadgetType_ComboBox
      Case "Container"      : Result = #PB_GadgetType_Container
      Case "Date"           : Result = #PB_GadgetType_Date
      Case "Editor"         : Result = #PB_GadgetType_Editor
      Case "ExplorerCombo"  : Result = #PB_GadgetType_ExplorerCombo
      Case "ExplorerList"   : Result = #PB_GadgetType_ExplorerList
      Case "ExplorerTree"   : Result = #PB_GadgetType_ExplorerTree
      Case "Frame"          : Result = #PB_GadgetType_Frame
      Case "HyperLink"      : Result = #PB_GadgetType_HyperLink
      Case "Image"          : Result = #PB_GadgetType_Image
      Case "IPAddress"      : Result = #PB_GadgetType_IPAddress
      Case "ListIcon"       : Result = #PB_GadgetType_ListIcon
      Case "ListView"       : Result = #PB_GadgetType_ListView
      Case "MDI"            : Result = #PB_GadgetType_MDI
      Case "OpenGL"         : Result = #PB_GadgetType_OpenGL
      Case "Option"         : Result = #PB_GadgetType_Option
      Case "Popup"          : Result = #PB_GadgetType_Popup
      Case "Panel"          : Result = #PB_GadgetType_Panel
      Case "Property"       : Result = #PB_GadgetType_Property
      Case "ProgressBar"    : Result = #PB_GadgetType_ProgressBar
      Case "Scintilla"      : Result = #PB_GadgetType_Scintilla
      Case "ScrollArea"     : Result = #PB_GadgetType_ScrollArea
      Case "ScrollBar"      : Result = #PB_GadgetType_ScrollBar
      Case "Shortcut"       : Result = #PB_GadgetType_Shortcut
      Case "Spin"           : Result = #PB_GadgetType_Spin
      Case "Splitter"       : Result = #PB_GadgetType_Splitter
      Case "String"         : Result = #PB_GadgetType_String
      Case "Text"           : Result = #PB_GadgetType_Text
      Case "TrackBar"       : Result = #PB_GadgetType_TrackBar
      Case "Tree"           : Result = #PB_GadgetType_Tree
      Case "Unknown"        : Result = #PB_GadgetType_Unknown
      Case "Web"            : Result = #PB_GadgetType_Web
      Case "Window"         : Result = #PB_GadgetType_Window
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Style.b = 1, Length.i = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  ;-
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\thumb\pos-_this_\y)
      Resize(_this_\splitter\second, 0, (_this_\thumb\pos+_this_\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\thumb\pos+_this_\thumb\len)-_this_\y))
    Else
      Resize(_this_\splitter\first, 0, 0, _this_\thumb\pos-_this_\x, _this_\height)
      Resize(_this_\splitter\second, (_this_\thumb\pos+_this_\thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro Resize_Childrens(_this_, _change_x_, _change_y_)
    ForEach _this_\childrens()
      Resize(_this_\childrens(), (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_, (_this_\childrens()\y-_this_\y-_this_\bs-_this_\tabHeight) + _change_y_, #PB_Ignore, #PB_Ignore)
    Next
  EndMacro
  
  Procedure Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      Right =- TextWidth(Mid(\text\string.s, \items()\text\pos, \text\caret))
      Left = (Width + Right)
      
      If \scroll\x < Right
        ; Scroll::SetState(\scroll\h, -Right)
        \scroll\x = Right
      ElseIf \scroll\x > Left
        ; Scroll::SetState(\scroll\h, -Left) 
        \scroll\x = Left
      ElseIf (\scroll\x < 0 And \keyboard\input = 65535 ) : \keyboard\input = 0
        \scroll\x = (Width-\items()\text[3]\width) + Right
        If \scroll\x>0 : \scroll\x=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  ; SET_
  Procedure.i Set_State(*this._S_widget, List *Item._S_items(), State.i)
    Protected Repaint.i, sublevel.i, Mouse_X.i, Mouse_Y.i
    
    With *this
      If ListSize(*Item())
        Mouse_X = \mouse\x
        Mouse_Y = \mouse\y
        
        If State >= 0 And SelectElement(*Item(), State) 
          If (Mouse_Y > (*Item()\box\y[1]) And Mouse_Y =< ((*Item()\box\y[1]+*Item()\box\height[1]))) And 
             ((Mouse_X > *Item()\box\x[1]) And (Mouse_X =< (*Item()\box\x[1]+*Item()\box\width[1])))
            
            *Item()\box\checked[1] ! 1
          ElseIf (\flag\buttons And *Item()\childrens) And
                 (Mouse_Y > (*Item()\box\y[0]) And Mouse_Y =< ((*Item()\box\y[0]+*Item()\box\height[0]))) And 
                 ((Mouse_X > *Item()\box\x[0]) And (Mouse_X =< (*Item()\box\x[0]+*Item()\box\width[0])))
            
            sublevel = *Item()\sublevel
            *Item()\box\checked ! 1
            \change = 1
            
            PushListPosition(*Item())
            While NextElement(*Item())
              If sublevel = *Item()\sublevel
                Break
              ElseIf sublevel < *Item()\sublevel And *Item()\i_Parent
                *Item()\hide = Bool(*Item()\i_Parent\box\checked | *Item()\i_Parent\hide)
              EndIf
            Wend
            PopListPosition(*Item())
            
          ElseIf \index[#Selected] <> State : *Item()\state = 2
            If \index[#Selected] >= 0 And SelectElement(*Item(), \index[#Selected])
              *Item()\state = 0
            EndIf
            ; GetState() - Value = \index[#Selected]
            \index[#Selected] = State
            
            Debug "set_state() - "+State;\index[#Entered]+" "+ListIndex(\items())
                                        ; Post change event to widget (tree, listview)
            w_Events(*this, #PB_EventType_Change, State)
          EndIf
          
          Repaint = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure.s Text_Make(*this._S_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *this
      If \text\Numeric And Text.s <> #LF$
        Static Dot, Minus
        Protected Chr.s, Input.i, left.s, count.i
        
        Len = Len(Text.s) 
        For i = 1 To Len 
          Chr = Mid(Text.s, i, 1)
          Input = Asc(Chr)
          
          Select Input
            Case '0' To '9', '.','-'
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
            Default
              Input = 0
          EndSelect
          
          If Input
            If \type = #PB_GadgetType_IPAddress
              left.s = Left(\text\string.s[1], \text\caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\text\string.s[1], \text\caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\text\string, \text\caret + 1, 1) = "."
                ;                 \text\caret + 1 : \text\caret[1]=\text\caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\text\string.s[1], \text\caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\text\string.s[1], \text\caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \text\pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \text\lower : String.s = LCase(Text.s)
          Case \text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.s Text_Wrap(*this._S_widget, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$="", TextWidth
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;  
    
    
    CountString = CountString(Text.s, #LF$) 
    ; Protected time = ElapsedMilliseconds()
    
    ; ;     Protected Len
    ; ;     Protected *s_0.Character = @Text.s
    ; ;     Protected *e_0.Character = @Text.s 
    ; ;     #SOC = SizeOf (Character)
    ; ;       While *e_0\c 
    ; ;         If *e_0\c = #LF
    ; ;           Len = (*e_0-*s_0)>>#PB_Compiler_Unicode
    ; ;           line$ = PeekS(*s_0, Len) ;Trim(, #LF$)
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
        If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ;   
          Break
        Else
          length - 1
        EndIf
      Wend 
      
      ;  Debug ""+start +" "+ length
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
              found + FindString(delimList$, Mid(RTrim(line$),ii,1))
              If found <> 2
                Continue
              EndIf
            Else
              found = FindString(delimList$, Mid(line$,ii,1))
            EndIf
            
            If found
              start = ii
              Break
            EndIf
          Next
        EndIf
        
        If found
          found = 0
        Else
          start = length
        EndIf
        
        LineRet$ + Left(line$, start) + nl$
        line$ = LTrim(Mid(line$, start+1))
        start = Len(line$)
        length = start
        
        ; Get text len
        While length > 1
          ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
          If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ; 
            Break
          Else
            length - 1
          EndIf
        Wend 
        
      Wend   
      
      ret$ + LineRet$ + line$ + #CR$+nl$
      LineRet$=""
    Next
    
    ; ;       *s_0 = *e_0 + #SOC : EndIf : *e_0 + #SOC : Wend
    ;Debug  ElapsedMilliseconds()-time
    ; MessageRequester("",Str( ElapsedMilliseconds()-time))
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.i Editor_Caret(*this._S_widget, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, mouse_x.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      If Line < 0 And FirstElement(*this\items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*this\items()) And 
             SelectElement(*this\items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\items())
          Len = \items()\text\len
          FontID = \items()\text\fontID
          String.s = \items()\text\string.s
          If Not FontID : FontID = \text\fontID : EndIf
          mouse_x = \mouse\x - (\items()\text\x+\scroll\x)
          
          If StartDrawing(CanvasOutput(\root\canvas\gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (mouse_x-X)*(mouse_x-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \text\caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\items())
            ;             If \mouse\y < \y+(\text\height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\mouse\y-\y-\text\y)-\scroll\y) / (\text\height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \index[#Entered] Or LastItem <> Item
            ;               \items()\text[2]\width[2] = 0
            ;               
            ;               If (\items()\text\string.s = "" And Item = \index[#Entered] And Position = len) Or
            ;                  \index[#Selected] > \index[#Entered] Or                                            ; Если выделяем снизу вверх
            ;                  (\index[#Selected] =< \index[#Entered] And \index[#Entered] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\index[#Selected] < \index[#Entered] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*this\items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \items()\text[2]\len : \items()\text[2]\len = 1
            ;                   \items()\text[2]\x = \items()\text\x+\items()\text\width
            ;                 EndIf 
            ;                 
            ;                 ; \items()\text[2]\width = (\items()\width-\items()\text\width) + TextWidth(\items()\text[2]\string.s)
            ;                 
            ;                 If \flag\fullSelection
            ;                   \items()\text[2]\width[2] = \flag\fullSelection
            ;                 Else
            ;                   \items()\text[2]\width[2] = \items()\width-\items()\text\width
            ;                 EndIf
            ;               EndIf
            ;               
            ;               LastItem = Item
            ;               LastLine = \index[#Entered]
            ;             EndIf
            ;             PopListPosition(\items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*this\items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \items()\text\len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Editor_Change(*this._S_widget, Pos.i, Len.i)
    With *this
      \items()\text[2]\pos = Pos
      \items()\text[2]\len = Len
      
      ; text string/pos/len/state
      If (\index[#Selected] > \index[#Entered] Or \index[#Selected] = \items()\index)
        \text[1]\change = #True
      EndIf
      If (\index[#Selected] < \index[#Entered] Or \index[#Selected] = \items()\index) 
        \text[3]\change = 1
      EndIf
      
      ; lines string/pos/len/state
      \items()\text[1]\change = #True
      \items()\text[1]\len = \items()\text[2]\pos
      \items()\text[1]\string.s = Left(\items()\text\string.s, \items()\text[1]\len) 
      
      \items()\text[3]\change = #True
      \items()\text[3]\pos = (\items()\text[2]\pos + \items()\text[2]\len)
      \items()\text[3]\len = (\items()\text\len - \items()\text[3]\pos)
      \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text[3]\len) 
      
      If \items()\text[1]\len = \items()\text[3]\pos
        \items()\text[2]\string.s = ""
        \items()\text[2]\width = 0
      Else
        \items()\text[2]\change = #True 
        \items()\text[2]\string.s = Mid(\items()\text\string.s, 1 + \items()\text[2]\pos, \items()\text[2]\len) 
      EndIf
      
      If (\text[1]\change Or \text[3]\change)
        If \text[1]\change
          \text[1]\len = (\items()\text[0]\pos + \items()\text[1]\len)
          \text[1]\string.s = Left(\text\string.s[1], \text[1]\len) 
          \text[2]\pos = \text[1]\len
        EndIf
        
        If \text[3]\change
          \text[3]\pos = (\items()\text[0]\pos + \items()\text[3]\pos)
          \text[3]\len = (\text\len - \text[3]\pos)
          \text[3]\string.s = Right(\text\string.s[1], \text[3]\len)
        EndIf
        
        If \text[1]\len <> \text[3]\pos 
          \text[2]\change = 1 
          \text[2]\len = (\text[3]\pos-\text[2]\pos)
          \text[2]\string.s = Mid(\text\string.s[1], 1 + \text[2]\pos, \text[2]\len) 
        Else
          \text[2]\len = 0 : \text[2]\string.s = ""
        EndIf
        
        \text[1]\change = 0 : \text[3]\change = 0 
      EndIf
      
      
      
      ;       If CountString(\text[3]\string.s, #LF$)
      ;         Debug "chang "+\items()\text\string.s +" "+ CountString(\text[3]\string.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure.i Editor_SelText(*this._S_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *this
      ;Debug "7777    "+\text\caret +" "+ \text\caret[1] +" "+\index[#Entered] +" "+ \index[#Selected] +" "+ \items()\text\string
      
      If (Caret <> \text\caret Or Line <> \index[#Entered] Or (\text\caret[1] >= 0 And Caret1 <> \text\caret[1]))
        \items()\text[2]\string.s = ""
        
        PushListPosition(\items())
        If \index[#Selected] = \index[#Entered]
          If \text\caret[1] = \text\caret And \items()\text[2]\len 
            \items()\text[2]\len = 0 
            \items()\text[2]\width = 0 
          EndIf
          If PreviousElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\width[2] = 0 
            \items()\text[2]\len = 0 
          EndIf
        ElseIf \index[#Selected] > \index[#Entered]
          If PreviousElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\len = 0 
          EndIf
        Else
          If NextElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\len = 0 
          EndIf
        EndIf
        PopListPosition(\items())
        
        If \index[#Selected] = \index[#Entered]
          If \text\caret[1] = \text\caret 
            Pos = \text\caret[1]
            ;             If \text\caret[1] = \items()\text\len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \text\caret[1] > \text\caret 
            ; |<<<<<< to left
            Pos = \text\caret
            Len = (\text\caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \text\caret[1]
            Len = (\text\caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \index[#Selected] > \index[#Entered]
          ; <<<<<|
          Pos = \text\caret
          Len = \items()\text\len-Pos
          ; Len - Bool(\items()\text\len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \text\caret
        EndIf
        
        Editor_Change(*this, Pos, Len)
        
        Line = \index[#Entered]
        Caret = \text\caret
        Caret1 = \text\caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i Editor_SelReset(*this._S_widget)
    With *this
      PushListPosition(\items())
      ForEach \items() 
        If \items()\text[2]\len <> 0
          \items()\text[2]\len = 0 
          \items()\text[2]\width[2] = 0 
          \items()\text[1]\string = ""
          \items()\text[2]\string = "" 
          \items()\text[3]\string = ""
          \items()\text[2]\width = 0 
        EndIf
      Next
      PopListPosition(\items())
    EndWith
  EndProcedure
  
  
  Procedure.i Editor_SelLimits(*this._S_widget)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *this
      char = Asc(Mid(\items()\text\string.s, \text\caret + 1, 1))
      If _is_selection_end_(char)
        \text\caret + 1
        \items()\text[2]\len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \text\caret To 1 Step - 1
          char = Asc(Mid(\items()\text\string.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \text\caret To \items()\text\len
          char = Asc(Mid(\items()\text\string.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret = i - 1
        \items()\text[2]\len = \text\caret[1] - \text\caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Editor_Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \text\big) ;And \items()\text\x+\items()\text\width > \items()\x+\items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \items()\text\string.s
        Protected string_len.i = \items()\text\len
        Protected mouse_x.i = \mouse\x-(\items()\text\x+\scroll\x)
        
        For i = 0 To string_len
          cursor_x = TextWidth(Left(String.s, i))
          Distance = (mouse_x-cursor_x)*(mouse_x-cursor_x)
          
          If MinDistance > Distance 
            MinDistance = Distance
            Right =- cursor_x
            Caret = i
          EndIf
        Next
        
        Left = (Width + Right)
        \items()\text[3]\width = TextWidth(Right(String.s, string_len-Caret))
        
        If \scroll\x < Right
          SetState(\scroll\h, -Right) ;: \scroll\x = Right
        ElseIf \scroll\x > Left
          SetState(\scroll\h, -Left) ;: \scroll\x = Left
        ElseIf (\scroll\x < 0 And \keyboard\input = 65535 ) : \keyboard\input = 0
          \scroll\x = (Width-\items()\text[3]\width) + Right
          If \scroll\x>0 : \scroll\x=0 : EndIf
        EndIf
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.i Editor_Paste(*this._S_widget, Chr.s, Count.i=0)
    Protected Repaint.i
    
    With *this
      If \index[#Entered] <> \index[#Selected] ; Это значить строки выделени
        If \index[#Selected] > \index[#Entered] : Swap \index[#Selected], \index[#Entered] : EndIf
        
        Editor_SelReset(*this)
        
        If Count
          \index[#Selected] + Count
          \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \index[#Selected] + 1
          \text\caret = 0
        Else
          \text\caret = \items()\text[1]\len + Len(Chr.s)
        EndIf
        
        \text\caret[1] = \text\caret
        \index[#Entered] = \index[#Selected]
        \text\change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      \text\string.s[1] = \text[1]\string + Chr.s + \text[3]\string
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Insert(*this._S_widget, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *this
      Chr.s = Text_Make(*this, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Editor_Paste(*this, Chr.s, Count)
          If \items()\text[2]\len 
            If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
            \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          EndIf
          
          \items()\text[1]\change = 1
          \items()\text[1]\string.s + Chr.s
          \items()\text[1]\len = Len(\items()\text[1]\string.s)
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          If Count
            \index[#Selected] + Count
            \index[#Entered] = \index[#Selected] 
            \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret + Len(Chr.s) 
          EndIf
          
          \text\string.s[1] = \text[1]\string + Chr.s + \text[3]\string
          \text\caret[1] = \text\caret 
          ; \countItems = CountString(\text\string.s[1], #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\items(), \index[#Selected]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Cut(*this._S_widget)
    ProcedureReturn Editor_Paste(*this._S_widget, "")
  EndProcedure
  
  
  ;-
  Procedure Editor_AddLine(*this._S_widget, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_scroll_height_(_this_)
      If _this_\scroll And Not _this_\hide And Not _this_\items()\hide
        _this_\scroll\height+_this_\text\height
        
        
        ; _this_\scroll\v\max = _this_\scroll\height
      EndIf
    EndMacro
    
    Macro _set_scroll_width_(_this_)
      If _this_\scroll And Not _this_\items()\hide And
         _this_\scroll\width<(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        _this_\scroll\width=(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        ;        _this_\scroll\width<(_this_\margin\width + (_this_\sublevellen -Bool(_this_\scroll\h\radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        ;       _this_\scroll\width=(_this_\margin\width + (_this_\sublevellen -Bool(_this_\scroll\h\radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        
        ;       If _this_\scroll\width < _this_\width[2]-(Bool(Not _this_\scroll\v\hide) * _this_\scroll\v\width)
        ;         _this_\scroll\width = _this_\width[2]-(Bool(Not _this_\scroll\v\hide) * _this_\scroll\v\width)
        ;       EndIf
        
        ;        If _this_\scroll\height < _this_\height[2]-(Bool(Not _this_\scroll\h\hide) * _this_\scroll\h\height)
        ;         _this_\scroll\height = _this_\height[2]-(Bool(Not _this_\scroll\h\hide) * _this_\scroll\h\height)
        ;       EndIf
        
        _this_\text\big = _this_\items()\index ; Позиция в тексте самой длинной строки
        _this_\text\big[1] = _this_\items()\text\pos ; Может и не понадобятся
        _this_\text\big[2] = _this_\items()\text\len ; Может и не понадобятся
        
        
        ; _this_\scroll\h\max = _this_\scroll\width
        ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
      EndIf
    EndMacro
    
    Macro _set_content_Y_(_this_)
      If _this_\image\imageID
        If _this_\flag\inLine
          Text_Y=((Height-(_this_\text\height*_this_\countItems))/2)
          Image_Y=((Height-_this_\image\height)/2)
        Else
          If _this_\text\align\bottom
            Text_Y=((Height-_this_\image\height-(_this_\text\height*_this_\countItems))/2)-Indent/2
            Image_Y=(Height-_this_\image\height+(_this_\text\height*_this_\countItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\text\height*_this_\countItems)+_this_\image\height)/2)+Indent/2
            Image_Y=(Height-(_this_\text\height*_this_\countItems)-_this_\image\height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\text\align\bottom
          Text_Y=(Height-(_this_\text\height*_this_\countItems)-Text_Y-Image_Y) 
        ElseIf _this_\text\align\Vertical
          Text_Y=((Height-(_this_\text\height*_this_\countItems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\image\imageID
        If _this_\flag\inLine
          If _this_\text\align\right
            Text_X=((Width-_this_\image\width-_this_\items()\text\width)/2)-Indent/2
            Image_X=(Width-_this_\image\width+_this_\items()\text\width)/2+Indent
          Else
            Text_X=((Width-_this_\items()\text\width+_this_\image\width)/2)+Indent
            Image_X=(Width-_this_\items()\text\width-_this_\image\width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\image\width)/2 
          Text_X=(Width-_this_\items()\text\width)/2 
        EndIf
      Else
        If _this_\text\align\right
          Text_X=(Width-_this_\items()\text\width)
        ElseIf _this_\text\align\horizontal
          Text_X=(Width-_this_\items()\text\width-Bool(_this_\items()\text\width % 2))/2 
        Else
          Text_X=_this_\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\items()\x = _this_\x + 5
      _this_\items()\width = Width
      _this_\items()\text\x = _this_\items()\x+Text_X
      
      _this_\image\x = _this_\text\x+Image_X
      _this_\items()\image\x = _this_\items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\items()\y = _this_\y+_this_\scroll\height+Text_Y + 2
      _this_\items()\height = _this_\text\height - Bool(_this_\countItems<>1 And _this_\flag\gridLines)
      _this_\items()\text\y = _this_\items()\y + (_this_\text\height-_this_\text\height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\countItems<>1)
      _this_\items()\text\height = _this_\text\height[1]
      
      _this_\image\y = _this_\text\y+Image_Y
      _this_\items()\image\y = _this_\items()\y + (_this_\text\height-_this_\items()\image\height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\items()\text\pos = _this_\text\pos - Bool(_this_\text\multiLine = 1)*_this_\items()\index ; wordwrap
      _this_\items()\text\len = Len(_this_\items()\text\string.s)
      _this_\text\pos + _this_\items()\text\len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *this
      \countItems = ListSize(\items())
      
      Width = \width[2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) - \margin\width
      Height = \height[2] - Bool(Not \scroll\h\hide) * \scroll\h\height
      
      \items()\index[#Entered] =- 1
      ;\items()\focus =- 1
      \items()\index = Line
      \items()\radius = \radius
      \items()\text\string.s = String.s
      
      ; Set line default color state           
      \items()\state = 1
      
      ; Update line pos in the text
      _set_line_pos_(*this)
      
      _set_content_X_(*this)
      _line_resize_X_(*this)
      _line_resize_Y_(*this)
      
      ;       ; Is visible lines
      ;       \items()\hide = Bool(Not Bool(\items()\y>=\y[2] And (\items()\y-\y[2])+\items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*this)
      
      ; Scroll hight length
      _set_scroll_height_(*this)
      
      If \index[#Selected] = ListIndex(\items())
        ;Debug " string "+String.s
        \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret) : \items()\text[1]\change = #True
        \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text\len-(\text\caret + \items()\text[2]\len)) : \items()\text[3]\change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i Editor_MultiLine(*this._S_widget)
    Protected Repaint, String.s, text_width, Len.i
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      Width = \width[2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) - \margin\width
      Height = \height[2] - Bool(Not \scroll\h\hide) * \scroll\h\height
      
      If \text\multiLine > 0
        String.s = Text_Wrap(*this, \text\string.s[1], Width, \text\multiLine)
      Else
        String.s = \text\string.s[1]
      EndIf
      
      \text\pos = 0
      
      If \text\string.s[2] <> String.s Or \text\Vertical
        \text\string.s[2] = String.s
        \countItems = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \scroll\width = 0
        _set_content_Y_(*this)
        
        ; 
        If ListSize(\items()) 
          Protected Left = Editor_Move(*this, Width)
        EndIf
        
        If \countItems[1] <> \countItems Or \text\Vertical
          \countItems[1] = \countItems
          
          ; Scroll hight reset 
          \scroll\height = 0
          ClearList(\items())
          
          If \text\Vertical
            For IT = \countItems To 1 Step - 1
              If AddElement(\items())
                \items() = AllocateStructure(_S_items)
                String = StringField(\text\string.s[2], IT, #LF$)
                
                ;\items()\focus =- 1
                \items()\index[#Entered] =- 1
                
                If \type = #PB_GadgetType_Button
                  \items()\text\width = TextWidth(RTrim(String))
                Else
                  \items()\text\width = TextWidth(String)
                EndIf
                
                If \text\align\right
                  Text_X=(Width-\items()\text\width) 
                ElseIf \text\align\horizontal
                  Text_X=(Width-\items()\text\width-Bool(\items()\text\width % 2))/2 
                EndIf
                
                \items()\x = \x[2]+\text\y+\scroll\height+Text_Y
                \items()\y = \y[2]+\text\x+Text_X
                \items()\width = \text\height
                \items()\height = Width
                \items()\index = ListIndex(\items())
                
                \items()\text\editable = \text\editable 
                \items()\text\Vertical = \text\Vertical
                If \text\rotate = 270
                  \items()\text\x = \image\width+\items()\x+\text\height+\text\x
                  \items()\text\y = \items()\y
                Else
                  \items()\text\x = \image\width+\items()\x
                  \items()\text\y = \items()\y+\items()\text\width
                EndIf
                \items()\text\height = \text\height
                \items()\text\string.s = String.s
                \items()\text\len = Len(String.s)
                
                _set_scroll_height_(*this)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \text\string.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\items())
                    \items() = AllocateStructure(_S_items)
                    
                    \items()\text\string.s = Trim(RegularExpressionMatchString(0), #LF$)
                    \items()\text\width = TextWidth(\items()\text\string.s) ; Нужен для скролл бара
                    
                    ;\items()\focus =- 1
                    \items()\index[#Entered] =- 1
                    \items()\state = 1 ; Set line default colors
                    \items()\radius = \radius
                    \items()\index = ListIndex(\items())
                    
                    ; Update line pos in the text
                    _set_line_pos_(*this)
                    
                    _set_content_X_(*this)
                    _line_resize_X_(*this)
                    _line_resize_Y_(*this)
                    
                    ; Scroll width length
                    _set_scroll_width_(*this)
                    
                    ; Scroll hight length
                    _set_scroll_height_(*this)
                  EndIf
                Wend
              EndIf
              
              FreeRegularExpression(0)
            Else
              Debug RegularExpressionError()
            EndIf
            
            
            
            
            ;             ;; 294 ; 124
            ;             Protected *Sta.Character = @\text\string.s[2], *End.Character = @\text\string.s[2] : #SOC = SizeOf (Character)
            ;While *End\c 
            ;               If *End\c = #LF And AddElement(\items())
            ;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
            ;                 
            ;                 \items()\text\string.s = PeekS (*Sta, Len) ;Trim(, #LF$)
            ;                 
            ; ;                 If \type = #PB_GadgetType_Button
            ; ;                   \items()\text\width = TextWidth(RTrim(\items()\text\string.s))
            ; ;                 Else
            ; ;                   \items()\text\width = TextWidth(\items()\text\string.s)
            ; ;                 EndIf
            ;                 
            ;                 \items()\focus =- 1
            ;                 \items()\index[#Entered] =- 1
            ;                 \items()\color\state = 1 ; Set line default colors
            ;                 \items()\radius = \radius
            ;                 \items()\index = ListIndex(\items())
            ;                 
            ;                 ; Update line pos in the text
            ;                 ; _set_line_pos_(*this)
            ;                 \items()\text\pos = \text\pos - Bool(\text\multiLine = 1)*\items()\index ; wordwrap
            ;                 \items()\text\len = Len                                                  ; (\items()\text\string.s)
            ;                 \text\pos + \items()\text\len + 1                                        ; Len(#LF$)
            ;                 
            ;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \items()\text\pos +" "+ \items()\text\len
            ;                 
            ;                 _set_content_X_(*this)
            ;                 _line_resize_X_(*this)
            ;                 _line_resize_Y_(*this)
            ;                 
            ;                 ; Scroll width length
            ;                 _set_scroll_width_(*this)
            ;                 
            ;                 ; Scroll hight length
            ;                 _set_scroll_height_(*this)
            ;                 
            ;                 *Sta = *End + #SOC 
            ;               EndIf 
            ;               
            ;               *End + #SOC 
            ;             Wend
            ;;;;  FreeMemory(*End)
            
            ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
            Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          EndIf
        Else
          Protected time2 = ElapsedMilliseconds()
          
          If CreateRegularExpression(0, ~".*\n?")
            If ExamineRegularExpression(0, \text\string.s[2])
              While NextRegularExpressionMatch(0) : IT+1
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                If SelectElement(\items(), IT-1)
                  If \items()\text\string.s <> String.s
                    \items()\text\string.s = String.s
                    
                    If \type = #PB_GadgetType_Button
                      \items()\text\width = TextWidth(RTrim(String.s))
                    Else
                      \items()\text\width = TextWidth(String.s)
                    EndIf
                  EndIf
                  
                  ; Update line pos in the text
                  _set_line_pos_(*this)
                  
                  ; Resize item
                  If (Left And Not  Bool(\scroll\x = Left))
                    _set_content_X_(*this)
                  EndIf
                  
                  _line_resize_X_(*this)
                  
                  ; Set scroll width length
                  _set_scroll_width_(*this)
                EndIf
                
              Wend
            EndIf
            
            FreeRegularExpression(0)
          Else
            Debug RegularExpressionError()
          EndIf
          
          Debug Str(ElapsedMilliseconds()-time2) + " text parse time2 "
          
        EndIf
      Else
        ; Scroll hight reset 
        \scroll\height = 0
        _set_content_Y_(*this)
        
        ForEach \items()
          If Not \items()\hide
            _set_content_X_(*this)
            _line_resize_X_(*this)
            _line_resize_Y_(*this)
            
            ; Scroll hight length
            _set_scroll_height_(*this)
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure.i Draw_Editor(*this._S_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f, _S_widgettate
    
    If Not *this\hide
      
      With *this
        _S_widgettate = \color\state
        
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        
        ; Then changed text
        If \text\change
          ;           If set_text_width
          ;             SetTextWidth(set_text_width, Len(set_text_width))
          ;             set_text_width = ""
          ;           EndIf
          
          \text\height[1] = TextHeight("A") + Bool(\countItems<>1 And \flag\gridLines)
          If \type = #PB_GadgetType_Tree
            \text\height = 20
          Else
            \text\height = \text\height[1]
          EndIf
          \text\width = TextWidth(\text\string.s[1])
          
          If \margin\width 
            \countItems = CountString(\text\string.s[1], #LF$)
            \margin\width = TextWidth(Str(\countItems))+11
            ;  Resizes(\scroll, \x[2]+\margin\width+1,\y[2],\width[2]-\margin\width-1,\height[2])
          EndIf
        EndIf
        
        ; Then resized widget
        If \resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \root\canvas\window, *this, #PB_EventType_Resize, \resize)
          
          CompilerIf Defined(Bar, #PB_Module)
            ;  Resizes(\scroll, \x[2]+\margin\width,\y[2],\width[2]-\margin\width,\height[2])
            Resizes(\scroll, \x[2],\y[2],\width[2],\height[2])
            \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
            \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
          CompilerElse
            \scroll\width[2] = \width[2]
            \scroll\height[2] = \height[2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\x[2]
        iY=\y[2]
        iWidth = \width[2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) ; - \margin\width
        iHeight = \height[2] - Bool(Not \scroll\h\hide) * \scroll\h\height
        
        ; Make output multi line text
        If (\text\change Or \resize)
          Editor_MultiLine(*this)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \text\change And \index[#Selected] >= 0 And \index[#Selected] < ListSize(\items())
            SelectElement(\items(), \index[#Selected])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \scroll\v And \scroll\v\max <> \scroll\height And 
                 SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\gridLines)) 
                
                \scroll\v\scrollstep = \text\height
                
                If \text\editable And (\items()\y >= (\scroll\height[2]-\items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
                EndIf
                
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                
                If \scroll\v\hide 
                  \scroll\width[2] = \width[2]
                  \items()\width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\scroll\v\hide +" "+ \scroll\height
                EndIf
              EndIf
              
              If \scroll\h And \scroll\h\max<>\scroll\width And 
                 SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                                                           ;  \scroll\width[2] = \width[2] - Bool(Not \scroll\v\hide)*\scroll\v\width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \keyboard\input And \items()\text\x+\items()\text\width > \items()\x+\items()\width
                Debug ""+\scroll\h\max +" "+ Str(\items()\text\x+\items()\text\width)
                
                If \scroll\h\max = (\items()\text\x+\items()\text\width)
                  SetState(\scroll\h, \scroll\h\max)
                Else
                  SetState(\scroll\h, \scroll\h\page\pos + TextWidth(Chr(\keyboard\input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        
        ;
        If \text\editable And ListSize(\items())
          If \text\change =- 1
            \text[1]\change = 1
            \text[3]\change = 1
            \text\len = Len(\text\string.s[1])
            Editor_Change(*this, \text\caret, 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \root\canvas\window, *this, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \items()\text[1]\change : \items()\text[1]\change = #False
            \items()\text[1]\width = TextWidth(\items()\text[1]\string.s)
            
            ; demo
            ;             Protected caret1, caret = \text\caret[2]
            
            ; Положение карета
            If \text\caret[1] = \text\caret
              \text\caret[2] = \items()\text[1]\width
              ;               caret1 = \text\caret[2]
            EndIf
            
            ; Если перешли за границы итемов
            If \index[#Entered] =- 1
              \text\caret[2] = 0
            ElseIf \index[#Entered] = ListSize(\items())
              \text\caret[2] = \items()\text\width
            ElseIf \items()\text\len = \items()\text[2]\len
              \text\caret[2] = \items()\text\width
            EndIf
            
            ;             If Caret<>\text\caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \text\caret[2] +" "+\index[#Entered] +" "+\index[#Selected]
            ;               caret = \text\caret[2]
            ;             EndIf
            
          EndIf
          
          If \items()\text[2]\change : \items()\text[2]\change = #False 
            \items()\text[2]\x = \items()\text\x+\items()\text[1]\width
            \items()\text[2]\width = TextWidth(\items()\text[2]\string.s) ; + Bool(\items()\text[2]\len =- 1) * \flag\fullSelection ; TextWidth() - bug in mac os
            
            \items()\text[3]\x = \items()\text[2]\x+\items()\text[2]\width
          EndIf 
          
          If \items()\text[3]\change : \items()\text[3]\change = #False 
            \items()\text[3]\width = TextWidth(\items()\text[3]\string.s)
          EndIf 
          
          If (\focus And \mouse\buttons And (Not \scroll\v\from And Not \scroll\h\from)) 
            Protected Left = Editor_Move(*this, \items()\width)
          EndIf
        EndIf
        
        ; Draw back color
        If \color\fore[_S_widgettate]
          DrawingMode(#PB_2DDrawing_Gradient)
          boxGradient(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[_S_widgettate],\color\back[_S_widgettate],\radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\radius,\radius,\color\back[_S_widgettate])
        EndIf
        
        ; Draw margin back color
        If \margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \margin\width, \height[2], \margin\color\back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *this\items()
        If ListSize(*this\items())
          PushListPosition(*this\items())
          ForEach *this\items()
            Protected Item_state = \state
            
            ; Is visible lines ---
            Drawing = Bool(Not \hide And (\y+\height+*this\scroll\y>*this\y[2] And (\y-*this\y[2])+*this\scroll\y<iheight))
            
            \drawing = Drawing
            
            If Drawing
              If \text\fontID 
                DrawingFont(\text\fontID) 
                ;               ElseIf *this\text\fontID 
                ;                 DrawingFont(*this\text\fontID) 
              EndIf
              
              If \text\change : \text\change = #False
                \text\width = TextWidth(\text\string.s) 
                
                If \text\fontID 
                  \text\height = TextHeight("A") 
                Else
                  \text\height = *this\text\height[1]
                EndIf
              EndIf 
              
              If \text[1]\change : \text[1]\change = #False
                \text[1]\width = TextWidth(\text[1]\string.s) 
              EndIf 
              
              If \text[3]\change : \text[3]\change = #False 
                \text[3]\width = TextWidth(\text[3]\string.s)
              EndIf 
              
              If \text[2]\change : \text[2]\change = #False 
                \text[2]\x = \text\x+\text[1]\width
                ; Debug "get caret "+\text[3]\len
                \text[2]\width = TextWidth(\text[2]\string.s) + Bool(\text\len = \text[2]\len Or \text[2]\len =- 1 Or \text[3]\len = 0) * *this\flag\fullSelection ; TextWidth() - bug in mac os
                \text[3]\x = \text[2]\x+\text[2]\width
              EndIf 
            EndIf
            
            
            Height = \height
            Y = \y+*this\scroll\y
            Text_X = \text\x+*this\scroll\x
            Text_Y = \text\y+*this\scroll\y
            ; Debug Text_X
            
            ; Draw selections
            If Drawing And (\index=*this\index[#Entered] Or \index=\index[#Entered]) ; Or \index=\focus Item_state;
              If *this\color\back[Item_state]<>-1                                    ; no draw transparent
                If *this\color\fore[Item_state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  boxGradient(\Vertical,*this\x[2],Y,iwidth,\height,*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24, *this\color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24) ;*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24 ,RowBackColor(*this, Item_state) ,\radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*this\x[2],Y,iwidth,\height,\radius,\radius,*this\color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
                EndIf
              EndIf
              
              If *this\color\frame[Item_state]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\x[2],Y,iwidth,\height,\radius,\radius, *this\color\frame[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
              EndIf
            EndIf
            
            If Drawing
              
              ;               Protected State_3, item_alpha = 255, back_color=$FFFFFF
              ;               
              ;               If Bool(\index = *this\index[#Selected])
              ;                 State_3 = 2
              ;               Else
              ;                 State_3 = Bool(\index = *this\index[#Entered])
              ;               EndIf
              ;               
              ;               ; Draw selections
              ;               If *this\flag\fullSelection
              ;                 If State_3 = 1
              ;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+1+*this\scroll\h\page\pos,\y+1,\width-2,\height-2, *this\color\back[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                   
              ;                   DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+*this\scroll\h\page\pos,\y,\width,\height, *this\color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                 EndIf
              ;                 
              ;                 If State_3 = 2
              ;                   If *this\focus : item_alpha = 200
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\scroll\h\page\pos,\y+1,\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\scroll\h\page\pos,\y,\width,\height, $DC9338&back_color|item_alpha<<24)
              ;                   Else
              ;                     ;If \flag\alwaysSelection
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\scroll\h\page\pos,\y+1,\width-2,\height-2, $E2E2E2&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\scroll\h\page\pos,\y,\width,\height, $C8C8C8&back_color|item_alpha<<24)
              ;                     ;EndIf
              ;                   EndIf
              ;                 EndIf
              ;                 
              ;               EndIf
              
              ; Draw text
              Angle = Bool(\text\Vertical)**this\text\rotate
              Protected Front_BackColor_1 = *this\color\front[_S_widgettate]&$FFFFFFFF|*this\color\alpha<<24
              Protected Front_BackColor_2 = *this\color\front[2]&$FFFFFFFF|*this\color\alpha<<24
              
              ; Draw string
              If \text[2]\len And *this\color\front <> *this\color\front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*this\text\caret[1] > *this\text\caret And *this\index[#Selected] = *this\index[#Entered]) Or
                     (\index = *this\index[#Entered] And *this\index[#Selected] > *this\index[#Entered])
                    \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
                    
                    If *this\index[#Selected] = *this\index[#Entered]
                      \text[2]\x = \text[3]\x-\text[2]\width
                    EndIf
                    
                    If \text[3]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\text[3]\x+*this\scroll\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *this\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      boxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, *this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24 )
                    EndIf
                    
                    If \text[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \text[1]\string.s+\text[2]\string.s, angle, Front_BackColor_2)
                    EndIf
                    
                    If \text[1]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \text\string.s, angle, Front_BackColor_1)
                    
                    If *this\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      boxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, *this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                    EndIf
                    
                    If \text[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\text[2]\x+*this\scroll\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \text[1]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *this\color\fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    boxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, *this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                  EndIf
                  
                  If \text[2]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\text[2]\x+*this\scroll\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \text[3]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\text[3]\x+*this\scroll\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \text[2]\len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, *this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                EndIf
                
                If Item_state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *this\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(ix+*this\margin\width-TextWidth(Str(\index))-3, \y+*this\scroll\y, Str(\index), *this\margin\color\front);, *this\margin\color\back)
              EndIf
            EndIf
            
            ;             ; text x
            ;             box(\text\x, *this\y, 2, *this\height, $FFFF0000)
            ;         
          Next
          PopListPosition(*this\items()) ; 
        EndIf
      EndWith  
      
      
      With *this
        ; Draw image
        If \image\imageID
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\items()) And (\text\editable Or \items()\text\editable) And \focus : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\items()\text\x+\scroll\x) + \text\caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \scroll\x), \items()\y+\scroll\y, 1, Height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \scroll\v And \scroll\v\max <> \scroll\height And 
          ;              SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\gridLines))
          ;             Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \scroll\h And \scroll\h\max<>\scroll\width And 
          ;              SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
          ;             Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Draw(\scroll\v)
          Draw(\scroll\h)
          ; (_this_\margin\width + (_this_\sublevellen -Bool(_this_\scroll\h\radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*this\scroll\h\x-GetState(*this\scroll\h), *this\scroll\v\y-GetState(*this\scroll\v), *this\scroll\h\max, *this\scroll\v\max, $FF0000)
          Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\page\len, *this\scroll\v\page\len, $FF00FF00)
          Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\area\len, *this\scroll\v\area\len, $FF00FFFF)
        CompilerEndIf
      EndWith
      
      ; Draw frames
      With *this
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i Editor_ToUp(*this._S_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If (\index[#Selected] > 0 And \index[#Entered] = \index[#Selected]) : \index[#Selected] - 1 : \index[#Entered] = \index[#Selected]
        SelectElement(\items(), \index[#Selected])
        ;If (\items()\y+\scroll\y =< \y[2])
        SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \items()\text\x+\items()\text\width > \items()\x+\items()\width
          SetState(\scroll\h, (\items()\text\x+\items()\text\width))
        Else
          SetState(\scroll\h, 0)
        EndIf
        ;Editor_Change(*this, \text\caret, 0)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToDown(*this._S_widget)
    Static Line
    Protected Repaint, Shift.i = Bool(*this\keyboard\key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If Shift
        
        If \index[#Entered] = \index[#Selected]
          SelectElement(\items(), \index[#Entered]) 
          Editor_Change(*this, \text\caret[1], \items()\text\len-\text\caret[1])
        Else
          SelectElement(\items(), \index[#Selected]) 
          Editor_Change(*this, 0, \items()\text\len)
        EndIf
        ; Debug \text\caret[1]
        \index[#Selected] + 1
        ;         \text\caret = Editor_Caret(*this, \index[#Selected]) 
        ;         \text\caret[1] = \text\caret
        SelectElement(\items(), \index[#Selected]) 
        Editor_Change(*this, 0, \text\caret[1]) 
        Editor_SelText(*this)
        Repaint = 1 
        
      Else
        If (\index[#Entered] < ListSize(\items()) - 1 And \index[#Entered] = \index[#Selected]) : \index[#Selected] + 1 : \index[#Entered] = \index[#Selected]
          SelectElement(\items(), \index[#Selected]) 
          ;If (\items()\y >= (\scroll\height[2]-\items()\height))
          SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
          ;EndIf
          
          If \items()\text\x+\items()\text\width > \items()\x+\items()\width
            SetState(\scroll\h, (\items()\text\x+\items()\text\width))
          Else
            SetState(\scroll\h, 0)
          EndIf
          
          ;Editor_Change(*this, \text\caret, 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToLeft(*this._S_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      If \items()\text[2]\len And Not Shift
        If \index[#Selected] > \index[#Entered] 
          Swap \index[#Selected], \index[#Entered]
          
          If SelectElement(\items(), \index[#Selected]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
            \items()\text[1]\change = #True
          EndIf
        ElseIf \index[#Entered] > \index[#Selected] And 
               \text\caret[1] > \text\caret
          Swap \text\caret[1], \text\caret
        ElseIf \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf
        
        If \index[#Entered] <> \index[#Selected]
          Editor_SelReset(*this)
          \index[#Entered] = \index[#Selected]
        Else
          \text\caret[1] = \text\caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \text\caret > 0
        If \text\caret > \items()\text\len - CountString(\items()\text\string.s, #CR$) ; Без нее удаляеть последнюю строку 
          \text\caret = \items()\text\len - CountString(\items()\text\string.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \text\caret - 1 
        
        If Not Shift
          \text\caret[1] = \text\caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf Editor_ToUp(*this._S_widget)
        \text\caret = \items()\text\len
        \text\caret[1] = \text\caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToRight(*this._S_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      ;       If \index[#Entered] <> \index[#Selected]
      ;         If Shift 
      ;           \text\caret + 1
      ;           Swap \index[#Selected], \index[#Entered] 
      ;         Else
      ;           If \index[#Entered] > \index[#Selected] 
      ;             Swap \index[#Entered], \index[#Selected] 
      ;             Swap \text\caret, \text\caret[1]
      ;             
      ;             If SelectElement(\items(), \index[#Selected]) 
      ;               \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
      ;               \items()\text[1]\change = #True
      ;             EndIf
      ;             
      ;             Editor_SelReset(*this)
      ;             \text\caret = \text\caret[1] 
      ;             \index[#Entered] = \index[#Selected]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \items()\text[2]\len
      ;         If \text\caret[1] > \text\caret 
      ;           Swap \text\caret[1], \text\caret 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \text\caret[1] = \text\caret 
      ;         Else
      ;           \text\caret + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \items()\text[2]\len And Not Shift
        If \index[#Entered] > \index[#Selected] 
          Swap \index[#Entered], \index[#Selected] 
          Swap \text\caret, \text\caret[1]
          
          If SelectElement(\items(), \index[#Selected]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
            \items()\text[1]\change = #True
          EndIf
          
          ;           Editor_SelReset(*this)
          ;           \text\caret = \text\caret[1] 
          ;           \index[#Entered] = \index[#Selected]
        EndIf
        
        If \index[#Entered] <> \index[#Selected]
          Editor_SelReset(*this)
          \index[#Entered] = \index[#Selected]
        Else
          \text\caret = \text\caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \text\caret < \items()\text\len - CountString(\items()\text\string.s, #CR$) ; Без нее удаляеть последнюю строку
        \text\caret + 1
        
        If Not Shift
          \text\caret[1] = \text\caret 
        EndIf
        
        Repaint =- 1 
      ElseIf Editor_ToDown(*this)
        \text\caret = 0
        \text\caret[1] = \text\caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToInput(*this._S_widget)
    Protected Repaint
    
    With *this
      If \keyboard\input
        Repaint = Editor_Insert(*this, Chr(\keyboard\input))
        
        ;         If Not Repaint
        ;           \default = *this
        ;         EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToReturn(*this._S_widget) ; Ok
    
    With  *this
      If Not Editor_Paste(*this, #LF$)
        \index[#Selected] + 1
        \text\caret = 0
        \index[#Entered] = \index[#Selected]
        \text\caret[1] = \text\caret
        \text\change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i Editor_ToBack(*this._S_widget)
    Protected Repaint, String.s, Cut.i
    
    If *this\keyboard\input : *this\keyboard\input = 0
      Editor_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    *this\keyboard\input = 65535
    
    With *this 
      If Not Editor_Cut(*this)
        If \items()\text[2]\len
          
          If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
          \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret[1] > 0 : \text\caret - 1 
          \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret)
          \items()\text[1]\len = Len(\items()\text[1]\string.s) : \items()\text[1]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s[1] = Left(\text\string.s[1], \items()\text\pos+\text\caret) + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \index[#Selected] > 0 
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$, #PB_String_CaseSensitive, \items()\text\pos+\text\caret, 1)
            
            Editor_ToUp(*this)
            
            \text\caret = \items()\text\len - CountString(\items()\text\string.s, #CR$)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \text\change
        \text\caret[1] = \text\caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToDelete(*this._S_widget)
    Protected Repaint, String.s
    
    With *this 
      If Not Editor_Cut(*this)
        If \items()\text[2]\len
          If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
          \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret[1] < \items()\text\len - CountString(\items()\text\string.s, #CR$)
          \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text\len - \text\caret - 1)
          \items()\text[3]\len = Len(\items()\text[3]\string.s) : \items()\text[3]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text[3]\string = Right(\text\string.s,  \text\len - (\items()\text\pos + \text\caret) - 1)
          \text[3]\len = Len(\text[3]\string.s)
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          If \index[#Selected] < (\countItems-1) ; ListSize(\items()) - 1
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$, #PB_String_CaseSensitive, \items()\text\pos+\text\caret, 1)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \text\change
        \text\caret[1] = \text\caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToPos(*this._S_widget, Pos.i, Len.i)
    Protected Repaint
    
    With *this
      Editor_SelReset(*this)
      
      If Len
        Select Pos
          Case 1 : FirstElement(\items()) : \text\caret = 0
          Case - 1 : LastElement(\items()) : \text\caret = \items()\text\len
        EndSelect
        
        \index[#Entered] = \items()\index
        SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
      Else
        SelectElement(\items(), \index[#Entered]) 
        \text\caret = Bool(Pos =- 1) * \items()\text\len 
        SetState(\scroll\h, Bool(Pos =- 1) * \scroll\h\max)
      EndIf
      
      \text\caret[1] = \text\caret
      \index[#Selected] = \index[#Entered] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Editable(*this._S_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *this
      Shift = Bool(*this\keyboard\key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\keyboard\key[1] & #PB_Canvas_Control) Or (\keyboard\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*this\keyboard\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not Control         ; And Not Shift
            Repaint = Editor_ToInput(*this)
          EndIf
          
        Case #PB_EventType_KeyUp ; Баг в мак ос не происходить событие если зажать cmd
                                 ;  Debug "#PB_EventType_KeyUp "
                                 ;           If \items()\text\Numeric
                                 ;             \items()\text\string.s[3]=\items()\text\string.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \keyboard\key
            Case #PB_Shortcut_Home : Repaint = Editor_ToPos(*this, 1, Control)
            Case #PB_Shortcut_End : Repaint = Editor_ToPos(*this, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = Editor_ToPos(*this, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = Editor_ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\text[2]\len <> \text\len Or Not \text[2]\len)
                ForEach \items()
                  \items()\text[2]\len = \items()\text\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                  \items()\text[2]\string = \items()\text\string : \items()\text[2]\change = 1
                  \items()\text[1]\string = "" : \items()\text[1]\change = 1 : \items()\text[1]\len = 0
                  \items()\text[3]\string = "" : \items()\text[3]\change = 1 : \items()\text[3]\len = 0
                Next
                
                \text[1]\len = 0 : \text[1]\string = ""
                \text[3]\len = 0 : \text[3]\string = #LF$
                \index[#Selected] = 0 : \index[#Entered] = ListSize(\items()) - 1
                \text\caret = \items()\text\len : \text\caret[1] = \text\caret
                \text[2]\string = \text\string : \text[2]\len = \text\len
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up     : Repaint = Editor_ToUp(*this)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = Editor_ToLeft(*this)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = Editor_ToRight(*this)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = Editor_ToDown(*this)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = Editor_ToBack(*this)
            Case #PB_Shortcut_Return : Repaint = Editor_ToReturn(*this) 
            Case #PB_Shortcut_Delete : Repaint = Editor_ToDelete(*this)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\text[2]\string)
                
                If \keyboard\key = #PB_Shortcut_X
                  Repaint = Editor_Cut(*this)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \text\editable And Control
                Repaint = Editor_Insert(*this, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \text\caret<\text\caret[1]
          ; Debug \text\caret[1]-\text\caret
          Editor_Change(*this, \text\caret, \text\caret[1]-\text\caret)
        Else
          ; Debug \text\caret-\text\caret[1]
          Editor_Change(*this, \text\caret[1], \text\caret-\text\caret[1])
        EndIf
      EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_SelSet(*this._S_widget, Line.i)
    Macro isItem(_item_, _list_)
      Bool(_item_ >= 0 And _item_ < ListSize(_list_))
    EndMacro
    
    Macro itemSelect(_item_, _list_)
      Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
    EndMacro
    
    Protected Repaint.i
    
    With *this
      
      If \index[#Entered] <> Line And Line =< ListSize(\items())
        If isItem(\index[#Entered], \items()) 
          If \index[#Entered] <> ListIndex(\items())
            SelectElement(\items(), \index[#Entered]) 
          EndIf
          
          If \index[#Entered] > Line
            \text\caret = 0
          Else
            \text\caret = \items()\text\len
          EndIf
          
          Repaint | Editor_SelText(*this)
        EndIf
        
        \index[#Entered] = Line
      EndIf
      
      If isItem(Line, \items()) 
        \text\caret = Editor_Caret(*this, Line) 
        Repaint | Editor_SelText(*this)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\items()) 
      ForEach \items()
        If (\index[#Entered] = \items()\index Or \index[#Selected] = \items()\index)
          \items()\text[2]\change = 1
          \items()\text[2]\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\index[#Selected] < \index[#Entered] And \index[#Selected] < \items()\index And \index[#Entered] > \items()\index) Or
                (\index[#Selected] > \index[#Entered] And \index[#Selected] > \items()\index And \index[#Entered] < \items()\index)) 
          
          \items()\text[2]\change = 1
          \items()\text[2]\string = \items()\text\string 
          \items()\text[2]\len - Bool(Not \items()\text\len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \items()\text[2]\len
          \items()\text[2]\change = 1
          \items()\text[2]\string =  "" 
          \items()\text[2]\len = 0 
        EndIf
      Next
      PopListPosition(\items()) 
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Events(*this._S_widget, EventType.i)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *this
      If *this 
        If ListSize(*this\items())
          If Not \hide ;And Not \disable And \interact
                       ; Get line position
            If \mouse\buttons
              If \mouse\y < \y
                Item.i =- 1
              Else
                Item.i = ((\mouse\y-\y-\scroll\y) / \text\height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \items()\text\caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Editor_SelLimits(*this)     ; Выделяем слово
                Editor_SelText(*this)
                
                ;                 \items()\text[2]\change = 1
                ;                 \items()\text[2]\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                itemSelect(Item, \items())
                Caret = Editor_Caret(*this, Item)
                
                If \items()\text\caret[1] =- 1 : \items()\text\caret[1] = 0
                  *this\text\caret[1] = 0
                  *this\text\caret = \items()\text\len
                  Editor_SelText(*this)
                  Repaint = 1
                  
                Else
                  Editor_SelReset(*this)
                  
                  If \items()\text[2]\len
                    
                    
                    
                  Else
                    
                    \text\caret = Caret
                    \text\caret[1] = \text\caret
                    \index[#Entered] = \items()\index 
                    \index[#Selected] = \index[#Entered]
                    
                    PushListPosition(\items())
                    ForEach \items() 
                      If \index[#Selected] <> ListIndex(\items())
                        \items()\text[1]\string = ""
                        \items()\text[2]\string = ""
                        \items()\text[3]\string = ""
                      EndIf
                    Next
                    PopListPosition(\items())
                    
                    If \text\caret = DoubleClick
                      DoubleClick =- 1
                      \text\caret[1] = \items()\text\len
                      \text\caret = 0
                    EndIf 
                    
                    Editor_SelText(*this)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = Editor_SelSet(*this, Item)
                EndIf
                
              Default
                itemSelect(\index[#Selected], \items())
            EndSelect
          EndIf
          
          ; edit events
          If \focus And (*this\text\editable Or \text\editable)
            Repaint | Editor_Editable(*this, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_CallBack(*this._S_widget, EventType.i)
    If *this
      With *this
        Select EventType
          Case #PB_EventType_Repaint
            Debug " -- Canvas repaint -- "
          Case #PB_EventType_Input 
            \keyboard\input = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Input)
            \keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \keyboard\key = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Key)
            \keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \mouse\x = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            \mouse\y = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            \focus = 1
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                               (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                               (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \mouse\buttons = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Buttons)
            CompilerEndIf
        EndSelect
      EndWith
      
      
      ProcedureReturn  CallFunctionFast(@Editor_Events(), *this, EventType)
    EndIf
    
    ; ProcedureReturn Text_CallBack(@Editor_Events(), *this, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  ;-
  ;- DRAWING
  Procedure.i Draw_Box(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i Draw_String(*this._S_widget)
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw frame
      If \color\back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back&$FFFFFF|Alpha)
      EndIf
      
      ;       If \text\change : \text\change = #False
      ;         \text\width = TextWidth(\text\string.s) 
      ;         
      ;         If \text\fontID 
      ;           \text\height = TextHeight("A") 
      ;         Else
      ;           \text\height = *this\text\height[1]
      ;         EndIf
      ;       EndIf 
      
      If \text[1]\change : \text[1]\change = #False
        \text[1]\width = TextWidth(\text[1]\string.s) 
      EndIf 
      
      If \text[3]\change : \text[3]\change = #False 
        \text[3]\width = TextWidth(\text[3]\string.s)
      EndIf 
      
      If \text[2]\change : \text[2]\change = #False 
        \text[2]\x = \text\x+\text[1]\width
        ; Debug "get caret "+\text[3]\len
        \text[2]\width = TextWidth(\text[2]\string.s) ;+ Bool(\text\len = \text[2]\len Or \text[2]\len =- 1 Or \text[3]\len = 0) * *this\flag\fullSelection ; TextWidth() - bug in mac os
        \text[3]\x = \text[2]\x+\text[2]\width
      EndIf 
      
      Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
      Protected angle.f
      
      
      Height = \text\height
      Y = \text\y
      Text_X = \text\x
      Text_Y = \text\y
      Angle = Bool(\text\Vertical) * *this\text\rotate
      Protected Front_BackColor_1 = *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24
      Protected Front_BackColor_2 = *this\color\front[2]&$FFFFFF|*this\color\alpha<<24 
      
      ; Draw string
      If \text[2]\len And *this\color\front <> *this\color\front[2]
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          If (*this\text\caret[1] > *this\text\caret And *this\index[#Selected] = *this\index[#Entered]) Or
             (\index = *this\index[#Entered] And *this\index[#Selected] > *this\index[#Entered])
            \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
            
            If *this\index[#Selected] = *this\index[#Entered]
              \text[2]\x = \text[3]\x-\text[2]\width
            EndIf
            
            If \text[3]\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\text[3]\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
            EndIf
            
            If *this\color\fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              boxGradient(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height, \color\back[2]&$FFFFFF|\color\alpha<<24 )
            EndIf
            
            If \text[2]\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \text[1]\string.s+\text[2]\string.s, angle, Front_BackColor_2)
            EndIf
            
            If \text[1]\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(Text_X, Text_Y, \text\string.s, angle, Front_BackColor_1)
            
            If *this\color\fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              boxGradient(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height, \color\back[2]&$FFFFFF|\color\alpha<<24)
            EndIf
            
            If \text[2]\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\text[2]\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
            EndIf
          EndIf
        CompilerElse
          If \text[1]\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
          EndIf
          
          If *this\color\fore[2]
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            boxGradient(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height, \color\back[2]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \text[2]\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\text[2]\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
          EndIf
          
          If \text[3]\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\text[3]\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
          EndIf
        CompilerEndIf
        
      Else
        If \text[2]\len
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box(\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height, \color\back[2]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \color\state = 2
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_2)
        Else
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_1)
        EndIf
      EndIf
      
      ; Draw caret
      If \text\editable And \focus : DrawingMode(#PB_2DDrawing_XOr)   
        Line(\text\x + \text[1]\width + Bool(\text\caret[1] > \text\caret) * \text[2]\width - Bool(#PB_Compiler_OS = #PB_OS_Windows), \text\y, 1, \text\height, $FFFFFFFF)
      EndIf
      
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Window(*this._S_widget)
    With *this 
      Protected sx,sw,x = \x
      Protected px=2,py
      Protected start, stop
      
      Protected State_3 = \color\state
      Protected Alpha = \color\alpha<<24
      
      ; Draw caption frame
      If \box\color\back[State_3]<>-1
        If \box\color\fore[\focus*2]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \box\x, \box\y, \box\width, \box\height, \box\color\fore[\focus*2], \box\color\back[\focus*2], \radius, \box\color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[\focus*2]&$FFFFFF|Alpha)
      EndIf
      Protected Radius = 4
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], Radius, Radius, $FF0000FF&$FFFFFF|\color[1]\alpha<<24)
      RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], Radius, Radius, $FFFF0000&$FFFFFF|\color[2]\alpha<<24)
      RoundBox( \box\x[3], \box\y[3], \box\width[3], \box\height[3], Radius, Radius, $FF00FF00&$FFFFFF|\color[3]\alpha<<24)
      
      ; Draw caption frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y+\bs-\fs, \width[1], \tabHeight+\fs, \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \color\back[State_3]<>-1
        If \color\fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore, \color\back, \radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\imageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \color\frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color\frame[State_3]&$FFFFFF|Alpha)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Scroll(*this._S_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\area\pos+\area\len) +" "+ \box\x[2]
      ;       Debug ""+Str(\area\pos+\area\len) +" "+ \box\y[2]
      ;Debug \width
      State_0 = \color[0]\state
      State_1 = \color[1]\state
      State_2 = \color[2]\state
      State_3 = \color[3]\state
      Alpha = \color\alpha<<24
      LinesColor = \color[3]\front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \color\back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        ; Roundbox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \color\line[State_0]<>-1
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \thumb\len 
        ; Draw thumb  
        If \color[3]\back[State_3]<>-1
          If \color[3]\fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[3], \box\y[3], \box\width[3], \box\height[3], \color[3]\fore[State_3], \color[3]\back[State_3], \radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \color[3]\frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[3], \box\y[3], \box\width[3], \box\height[3], \radius, \radius, \color[3]\frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \box\size[1]
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[1], \box\y[1], \box\width[1], \box\height[1], \color[1]\fore[State_1], \color[1]\back[State_1], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[1]\frame[State_1]
          RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], \radius, \radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[1]+( \box\width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool( \Vertical),
               (Bool(Not _scroll_in_start_(*this)) * \color[1]\front[State_1] + _scroll_in_start_(*this) * \color[1]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
      EndIf
      
      If \box\size[2]
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[2], \box\y[2], \box\width[2], \box\height[2], \color[2]\fore[State_2], \color[2]\back[State_2], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[2]\frame[State_2]
          RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], \radius, \radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[2]+( \box\width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool( \Vertical)+2, 
               (Bool(Not _scroll_in_stop_(*this)) * \color[2]\front[State_2] + _scroll_in_stop_(*this) * \color[2]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
      EndIf
      
      If \thumb\len And \color[3]\fore[State_3]<>-1  ; Draw thumb lines
        If \focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \box\arrow_size[2]+3
        
        If \Vertical
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2-3,size,1, LinesColor)
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2,size,1, LinesColor)
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2+3,size,1, LinesColor)
        Else
          Line( \box\x[3]+\box\width[3]/2-3, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\width[3]/2, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\width[3]/2+3, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*this._S_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      State_0 = \color[0]\state
      State_1 = \color[1]\state
      State_2 = \color[2]\state
      State_3 = \color[3]\state
      Alpha = \color\alpha<<24
      LinesColor = \color[3]\front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \color\back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string, \color\front[State_3]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*this._S_widget)
      
      If \box\size[2]
        Protected Radius = \height[2]/7
        If Radius > 4
          Radius = 7
        EndIf
        
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[1], \box\y[1], \box\width[1], \box\height[1], \color[1]\fore[State_1], \color[1]\back[State_1], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[2], \box\y[2], \box\width[2], \box\height[2], \color[2]\fore[State_2], \color[2]\back[State_2], Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[1]\frame[State_1]
          RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], Radius, Radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw buttons frame
        If \color[2]\frame[State_2]
          RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], Radius, Radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[1]+( \box\width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool(\Vertical)*3,
               (Bool(Not _scroll_in_start_(*this)) * \color[1]\front[State_1] + _scroll_in_start_(*this) * \color[1]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
        
        ; Draw arrows
        Arrow( \box\x[2]+( \box\width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool(Not \Vertical)+1, 
               (Bool(Not _scroll_in_stop_(*this)) * \color[2]\front[State_2] + _scroll_in_stop_(*this) * \color[2]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
        
        
        Line(\box\x[1]-2, \y[2],1,\height[2], \color\frame&$FFFFFF|Alpha)
      EndIf      
    EndWith
  EndProcedure
  
  Procedure.i Draw_ScrollArea(*this._S_widget)
    With *this 
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\imageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \scroll And (\scroll\v And \scroll\h)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\scroll\h\x-GetState(\scroll\h), \scroll\v\y-GetState(\scroll\v), \scroll\h\max, \scroll\v\max, $FFFF0000)
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\page\len, \scroll\v\page\len, $FF00FF00)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Container(*this._S_widget)
    With *this 
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\imageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Frame(*this._S_widget)
    With *this 
      If \text\string.s
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ;       ; Draw background image
      ;       If \image[1]\imageID
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\imageID, \image[1]\x, \image[1]\y, \color\alpha)
      ;       EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \tabHeight/2
        Box(\x[1], \y+h, 6, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\text\x+\text\width+3, \y+h, \width[1]-((\text\x+\text\width)-\x)-3, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[1], \y[1]-h, \fs, \height[1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1]+\width[1]-\fs, \y[1]-h, \fs, \height[1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1], \y[1]+\height[1]-\fs, \width[1], \fs, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Panel(*this._S_widget)
    Protected State_3.i, Alpha.i, Color_Frame.i
    
    With *this 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \x
      Protected start, stop
      
      Protected clip_x = \x[#_c_4]+\box\size[1]+3
      Protected clip_width = \width[#_c_4]-\box\size[1]-\box\size[2]-6
      
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\imageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      If \width[2]>(\box\width[1]+\box\width[2]+4)
        ClipOutput(clip_x, \y[#_c_4], clip_width, \height[#_c_4])
        
        ForEach \items()
          If \index[#Selected] = \items()\index
            State_3 = 2
            \items()\y = \y+2
            \items()\height=\tabHeight-1
          Else
            State_3 = \items()\state
            \items()\y = \y+4
            \items()\height=\tabHeight-4-1
          EndIf
          Color_Frame = \color\frame[State_3]&$FFFFFF|Alpha
          
          \items()\image\x[1] = 8 ; Bool(\items()\image\width) * 4
          
          If \items()\text\change
            \items()\text\width = TextWidth(\items()\text\string)
            \items()\text\height = TextHeight("A")
          EndIf
          
          \items()\x = 2+x-\page\pos+\box\size[1]+1
          \items()\width = \items()\text\width + \items()\image\x[1]*2 + \items()\image\width + Bool(\items()\image\width) * 3
          x + \items()\width + 1
          
          \items()\image\x = \items()\x+\items()\image\x[1] - 1
          \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
          
          \items()\text\x = \items()\image\x + \items()\image\width + Bool(\items()\image\width) * 3
          \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
          
          \items()\drawing = Bool(Not \items()\hide And \items()\x+\items()\width>\x+\bs And \items()\x<\x+\width-\bs)
          
          If \items()\drawing
            ; Draw thumb  
            If \color\back[State_3]<>-1
              If \color\fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              boxGradient( \Vertical, \items()\x, \items()\y, \items()\width, \items()\height, \color\fore[State_3], Bool(State_3 <> 2)*\color\back[State_3] + (Bool(State_3 = 2)*\color\front[State_3]), \radius, \color\alpha)
            EndIf
            
            ; Draw string
            If \items()\text\string
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \color\front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \items()\image\imageID
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, \color\alpha)
            EndIf
            
            ; Draw thumb frame
            If \color\frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\items()\x, \items()\y, \items()\width, 1, Color_Frame)                     ; top
                Line(\items()\x, \items()\y, 1, \items()\height, Color_Frame)                    ; left
                Line((\items()\x+\items()\width)-1, \items()\y, 1, \items()\height, Color_Frame) ; right
              Else
                RoundBox( \items()\x, \items()\y, \items()\width, \items()\height, \radius, \radius, Color_Frame)
              EndIf
            EndIf
          EndIf
          
          \items()\text\change = 0
          
          If State_3 = 2
            sx = \items()\x
            sw = \items()\width
            start = Bool(\items()\x=<\x[2]+\box\size[1]+1 And \items()\x+\items()\width>=\x[2]+\box\size[1]+1)*2
            stop = Bool(\items()\x=<\x[2]+\width[2]-\box\size[2]-2 And \items()\x+\items()\width>=\x[2]+\width[2]-\box\size[2]-2)*2
          EndIf
          
        Next
        
        ClipOutput(\x[#_c_4], \y[#_c_4], \width[#_c_4], \height[#_c_4])
        
        If ListSize(\items())
          Protected Value = \box\size[1]+((\items()\x+\items()\width+\page\pos)-\x[2])
          
          If \max <> Value : \max = Value
            \area\pos = \x[2]+\box\size[1]
            \area\len = \width[2]-(\box\size[1]+\box\size[2])
            \thumb\len = _thumb_len_(*this)
            ;\scrollstep = 10;\thumb\len
            
            If \change > 0 And SelectElement(\items(), \change-1)
              Protected State = (\box\size[1]+((\items()\x+\items()\width+\page\pos)-\x[2]))-\page\len ;
                                                                                                       ;               Debug (\box\size[1]+(\items()\x+\items()\width)-\x[2])-\page\len
                                                                                                       ;               Debug State
              If State < \min : State = \min : EndIf
              If State > \max-\page\len
                If \max > \page\len 
                  State = \max-\page\len
                Else
                  State = \min 
                EndIf
              EndIf
              
              \page\pos = State
            EndIf
          EndIf
        EndIf
        
        ; Линии на концах для красоты
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        If Not _scroll_in_start_(*this)
          Line(\box\x[1]+\box\width[1]+1, \box\y[1], 1, \tabHeight-5+start, \color\frame[start]&$FFFFFF|Alpha)
        EndIf
        If Not _scroll_in_stop_(*this)
          Line(\box\x[2]-2, \box\y[1], 1, \tabHeight-5+stop, \color\frame[stop]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Line(\x[2], \y+\tabHeight, \area\pos-\x+2, 1, \color\frame&$FFFFFF|Alpha)
        
        Line(\area\pos, \y+\tabHeight, sx-\area\pos, 1, \color\frame&$FFFFFF|Alpha)
        Line(sx+sw, \y+\tabHeight, \width-((sx+sw)-\x), 1, \color\frame&$FFFFFF|Alpha)
        
        Line(\box\x[2]-2, \y+\tabHeight, \area\pos-\x+2, 1, \color\frame&$FFFFFF|Alpha)
        
        Line(\x, \y+\tabHeight, 1, \height-\tabHeight, \color\frame&$FFFFFF|Alpha)
        Line(\x+\width-1, \y+\tabHeight, 1, \height-\tabHeight, \color\frame&$FFFFFF|Alpha)
        Line(\x, \y+\height-1, \width, 1, \color\frame&$FFFFFF|Alpha)
      EndIf
      
    EndWith
    
    With *this
      If \box\size[1] Or \box\size[2]
        ; Draw buttons
        
        If \color[1]\state 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], \radius, \radius, \box\color[1]\back[\color[1]\state]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], \radius, \radius, \box\color[1]\frame[\color[1]\state]&$FFFFFF|Alpha)
        EndIf
        
        If \color[2]\state 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], \radius, \radius, \box\color[2]\back[\color[2]\state]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], \radius, \radius, \box\color[2]\frame[\color[2]\state]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Arrow( \box\x[1]+( \box\width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool( \Vertical),
               (Bool(Not _scroll_in_start_(*this)) * \box\color[1]\front[\color[1]\state] + _scroll_in_start_(*this) * \box\color[1]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
        
        Arrow( \box\x[2]+( \box\width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool( \Vertical)+2, 
               (Bool(Not _scroll_in_stop_(*this)) * \box\color[2]\front[\color[2]\state] + _scroll_in_stop_(*this) * \box\color[2]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Progress(*this._S_widget)
    With *this 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x+2,\y,\width-4,\thumb\pos, \radius, \radius,\color[3]\back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\x+2,\y+2,\width-4,\thumb\pos-2, \radius, \radius,\color[3]\frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x+2,\thumb\pos+\y,\width-4,(\height-\thumb\pos), \radius, \radius,\color[3]\back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\page\pos)))/2, "%"+Str(\page\pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\thumb\pos,\y+2,\width-(\thumb\pos-\x),\height-4, \radius, \radius,\color[3]\back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\thumb\pos,\y+2,\width-(\thumb\pos-\x)-2,\height-4, \radius, \radius,\color[3]\frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x,\y+2,(\thumb\pos-\x),\height-4, \radius, \radius,\color[3]\back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\page\pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\page\pos),0)
        
        ;Debug ""+\x+" "+\thumb\pos
      EndIf
      
      ; 2 - frame
      If \color\back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \x+1, \y+1, \width-2, \height-2, \radius, \radius, \color\back)
      EndIf
      
      ; 1 - frame
      If \color[3]\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color[3]\frame)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Property(*this._S_widget)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 255
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    
    With *this
      If *this > 0
        If \text\fontID : DrawingFont(\text\fontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          X = \x
          Y = \y
          Width = \width 
          Height = \height
          
          ; Позиция сплиттера 
          Size = \thumb\len
          
          If \Vertical
            Pos = \thumb\pos-y
          Else
            Pos = \thumb\pos-x
          EndIf
          
          
          ; set vertical bar state
          If \scroll\v\max And \change > 0
            If (\change*\text\height-\scroll\h\page\len) > \scroll\h\max
              \scroll\h\page\pos = (\change*\text\height-\scroll\h\page\len)
            EndIf
          EndIf
          
          \scroll\width=0
          \scroll\height=0
          
          ForEach \items()
            ;             If Not \items()\text\change And Not \resize And Not \change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\scroll\h\page\len
              \items()\x=\scroll\h\x-\scroll\h\page\pos
              \items()\y=(\scroll\v\y+\scroll\height)-\scroll\v\page\pos
              
              If \items()\text\change = 1
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = box_size
              \items()\box\height = box_size
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = box_1_size
                \items()\box\height[1] = box_1_size
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \scroll\height+\items()\height
              
              If \scroll\width < (\items()\text\x-\x+\items()\text\width)+\scroll\h\page\pos
                \scroll\width = (\items()\text\x-\x+\items()\text\width)+\scroll\h\page\pos
              EndIf
            EndIf
            
            \items()\drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; Задаем размеры скролл баров
          If \scroll\v And \scroll\v\page\len And \scroll\v\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height)
            Widget::Resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
            \scroll\v\scrollstep = \text\height
          EndIf
          
          If \scroll\h And \scroll\h\page\len And \scroll\h\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
            Widget::Resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
          EndIf
          
          
          
          ForEach \items()
            ;           If Drawing
            ;             \drawing = Drawing
            ;           EndIf
            ;           
            ;           If \drawing
            ;             ChangeCurrentElement(\items(), \drawing)
            ;             Repeat 
            If \items()\drawing
              \items()\width = \scroll\h\page\len
              State_3 = \items()\state
              
              ; Draw selections
              If Not \items()\childrens And \flag\fullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\x[0]+(\items()\box\width[0]-6)/2,\items()\box\y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\box\checked)+2, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\box\checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\i_Parent 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\scroll\v\page\pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\box\checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4]-(\width-(\thumb\pos-\x)),\height[#_c_4])
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\x[#_c_4]+(\thumb\pos-\x),\y[#_c_4],\width[#_c_4]-(\thumb\pos-\x),\height[#_c_4])
              
              ;\items()\text[1]\x[1] = 5
              \items()\text[1]\x = \x+\items()\text[1]\x[1]+\thumb\len
              \items()\text[1]\y = \items()\text\y
              ; Draw string
              If \items()\text[1]\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text[1]\x+pos, \items()\text[1]\y, \items()\text[1]\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
          ; Draw Splitter
          DrawingMode(#PB_2DDrawing_Outlined) 
          Line((X+Pos)+Size/2,Y,1,Height, \color\frame)
        EndIf
        
        
        ;         If \bs
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           box(\x, \y, \width, \height, $ADADAE)
        ;         EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Tree(*this._S_widget)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF,alpha = 255, item_alpha = 255
    Protected box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    With *this
      If *this > 0
        If \text\fontID : DrawingFont(\text\fontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          ; set vertical bar state
          If \scroll And \scroll\v\max And \change > 0
            \scroll\v\max = \scroll\height
            ; \scroll\v\max = \countItems*\text\height
            ; Debug ""+Str(\change*\text\height-\scroll\v\page\len+\scroll\v\thumb\len) +" "+ \scroll\v\max
            If (\change*\text\height-\scroll\v\page\len) <> \scroll\v\page\pos  ;> \scroll\v\max
                                                                                ; \scroll\v\page\pos = (\change*\text\height-\scroll\v\page\len)
              SetState(\scroll\v, (\change*\text\height-\scroll\v\page\len))
              Debug ""+\scroll\v\page\pos+" "+Str(\change*\text\height-\scroll\v\page\len)  +" "+\scroll\v\max                                               
              
            EndIf
          EndIf
          
          If \scroll
            \scroll\width=0
            \scroll\height=0
          EndIf
          
          ; Resize items
          ForEach \items()
            ;\items()\height = 20
            ;             If Not \items()\text\change And Not \resize And Not \change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;               \scroll\width=0
            ;               \scroll\height=0
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\scroll\h\page\len
              \items()\x=\scroll\h\x-\scroll\h\page\pos
              \items()\y=(\scroll\v\y+\scroll\height)-\scroll\v\page\pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = \flag\buttons
              \items()\box\height = \flag\buttons
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = \flag\checkboxes
                \items()\box\height[1] = \flag\checkboxes
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \scroll\height+\items()\height
              
              If \scroll\width < (\items()\text\x-\x+\items()\text\width)+\scroll\h\page\pos
                \scroll\width = (\items()\text\x-\x+\items()\text\width)+\scroll\h\page\pos
              EndIf
            EndIf
            
            \items()\drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; set vertical scrollbar max value
          If \scroll\v And \scroll\v\page\len And \scroll\v\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\scrollstep = \text\height
            Widget::Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \scroll\h And \scroll\h\page\len And \scroll\h\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
            Widget::Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; Draw items
          ForEach \items()
            
            
            ;           If Drawing
            ;             \drawing = Drawing
            ;           EndIf
            ;           
            ;           If \drawing
            ;             ChangeCurrentElement(\items(), \drawing)
            ;             Repeat 
            
            If \items()\drawing
              \items()\width=\scroll\h\page\len
              If Bool(\items()\index = \index[#Selected])
                State_3 = 2
              Else
                State_3 = Bool(\items()\index = \index[#Entered])
              EndIf
              
              ; Draw selections
              If \flag\fullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\page\pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
                
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\x[0]+(\items()\box\width[0]-6)/2,\items()\box\y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\box\checked)+2, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\box\checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,\flag\lines,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\i_Parent 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\scroll\v\page\pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-\flag\lines
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\box\checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
        EndIf
        
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Track(*this._S_widget)
    With *this 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*this\x[0],*this\y[0],*this\width[0],*this\height[0],\color[0]\back)
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x[0]+5,\y[0],a,\height[0],\color[3]\frame)
        Box(\x[0]+5,\y[0]+\thumb\pos,a,(\y+\height)-\thumb\pos,\color[3]\back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x[0],\y[0]+5,\width[0],a,\color[3]\frame)
        Box(\x[0],\y[0]+5,\thumb\pos-\x,a,\color[3]\back[2])
      EndIf
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\box\x[3],\box\y[3],\box\width[3]/2,\box\height[3],\color[3]\back[\color[3]\state])
        
        Line(\box\x[3],\box\y[3],1,\box\height[3],\color[3]\frame[\color[3]\state])
        Line(\box\x[3],\box\y[3],\box\width[3]/2,1,\color[3]\frame[\color[3]\state])
        Line(\box\x[3],\box\y[3]+\box\height[3]-1,\box\width[3]/2,1,\color[3]\frame[\color[3]\state])
        Line(\box\x[3]+\box\width[3]/2,\box\y[3],\box\width[3]/2,\box\height[3]/2+1,\color[3]\frame[\color[3]\state])
        Line(\box\x[3]+\box\width[3]/2,\box\y[3]+\box\height[3]-1,\box\width[3]/2,-\box\height[3]/2-1,\color[3]\frame[\color[3]\state])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\box\x[3],\box\y[3],\box\width[3],\box\height[3]/2,\color[3]\back[\color[3]\state])
        
        Line(\box\x[3],\box\y[3],\box\width[3],1,\color[3]\frame[\color[3]\state])
        Line(\box\x[3],\box\y[3],1,\box\height[3]/2,\color[3]\frame[\color[3]\state])
        Line(\box\x[3]+\box\width[3]-1,\box\y[3],1,\box\height[3]/2,\color[3]\frame[\color[3]\state])
        Line(\box\x[3],\box\y[3]+\box\height[3]/2,\box\width[3]/2+1,\box\height[3]/2,\color[3]\frame[\color[3]\state])
        Line(\box\x[3]+\box\width[3]-1,\box\y[3]+\box\height[3]/2,-\box\width[3]/2-1,\box\height[3]/2,\color[3]\frame[\color[3]\state])
      EndIf
      
      If \ticks
        Protected ii.f, _thumb_ = (\thumb\len/2-2)
        For i=0 To \page\end
          ii = (\area\pos + Round(((i)-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
          LineXY(\x+ii,\box\y[3]+\box\height[3]-1,\x+ii,\box\y[3]+\box\height[3]-4,\color[3]\frame)
        Next
        
        ;         Protected PlotStep = 5;(\width)/(\max-\min)
        ;         
        ;         For i=3 To (\width-PlotStep)/2 
        ;           If Not ((\x+i-3)%PlotStep)
        ;             Box(\x+i, \y[3]+\box\height[3]-4, 1, 4, $FF808080)
        ;           EndIf
        ;         Next
        ;         For i=\width To (\width-PlotStep)/2+3 Step - 1
        ;           If Not ((\x+i-6)%PlotStep)
        ;             Box(\x+i, \box\y[3]+\box\height[3]-4, 1, 4, $FF808080)
        ;           EndIf
        ;         Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Text(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\text\string.s
          Protected *End.Character = @\text\string.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\text\x, \text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \color\front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \countItems
          ;           DrawText(\text\x, \text\y+y, StringField(\text\string.s, i, #LF$), \color\front&$FFFFFF|Alpha)
          ;           y+\text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Checkbox(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\box\height)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \radius, \radius, \color\back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \radius, \radius, \color\frame[\focus*2]&$FFFFFF|Alpha)
      
      If \box\checked = #PB_Checkbox_Checked
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        For i = 0 To 2
          LineXY((\box\x+3),(i+\box\y+8),(\box\x+7),(i+\box\y+9), \color\frame[\focus*2]&$FFFFFF|Alpha) 
          LineXY((\box\x+10+i),(\box\y+3),(\box\x+6+i),(\box\y+10), \color\frame[\focus*2]&$FFFFFF|Alpha)
        Next
      ElseIf \box\checked = #PB_Checkbox_Inbetween
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \box\x+2,\box\y+2,\box\width-4,\box\height-4, \radius-2, \radius-2, \color\frame[\focus*2]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\text\string.s
          Protected *End.Character = @\text\string.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\text\x, \text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \color\front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \countItems
          ;           DrawText(\text\x, \text\y+y, StringField(\text\string.s, i, #LF$), \color\front&$FFFFFF|Alpha)
          ;           y+\text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Option(*this._S_widget)
    Protected i.i, y.i
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1, box_color=$7E7E7E
    
    With *this
      Protected Alpha = \color\alpha<<24
      Protected Radius = \box\width/2
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\box\width)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\width, Radius, Radius, \color\back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(\box\x+Radius,\box\y+Radius, Radius, \color\frame[\focus*2]&$FFFFFF|Alpha)
      
      If \box\checked > 0
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Circle(\box\x+Radius,\box\y+Radius, 2, \color\frame[\focus*2]&$FFFFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\text\string.s
          Protected *End.Character = @\text\string.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\text\x, \text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \color\front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \countItems
          ;           DrawText(\text\x, \text\y+y, StringField(\text\string.s, i, #LF$), \color\front&$FFFFFF|Alpha)
          ;           y+\text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Splitter(*this._S_widget)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      If *this > 0
        X = \x
        Y = \y
        Width = \width 
        Height = \height
        
        ; Позиция сплиттера 
        Size = \thumb\len
        
        If \Vertical
          Pos = \thumb\pos-y
        Else
          Pos = \thumb\pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \area\len)
          fColor = \color\frame&$FFFFFF|Alpha;\color[3]\frame[0]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            If \type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Width,Pos,fColor) 
            EndIf
            If \type[2]<>#PB_GadgetType_Splitter
              Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),fColor)
            EndIf
          Else
            If \type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Pos,Height,fColor) 
            EndIf 
            If \type[2]<>#PB_GadgetType_Splitter
              Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = $FF000000;\color[3]\frame[\color[3]\state]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          Else
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            ;box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,\color\frame&$FFFFFF|Alpha)
          Else
            ;box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\color\frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \Vertical
        ; ;           ;box(\box\x[3], \box\y[3]+\box\height[3]-\thumb\len, \box\width[3], \thumb\len, $FF0000)
        ; ;           box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;box(\box\x[3]+\box\width[3]-\thumb\len, \box\y[3], \thumb\len, \box\height[3], $FF0000)
        ; ;           box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Image(*this._S_widget)
    With *this 
      
      ClipOutput(\x[2],\y[2],\scroll\h\page\len,\scroll\v\page\len)
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
      
      ; 2 - frame
      If \color\back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame)
      EndIf
    EndWith
    
    With *this\scroll
      ; Scroll area coordinate
      Box(\h\x-\h\page\pos, \v\y-\v\page\pos, \h\max, \v\max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\page\len, \v\page\len, $00FF00)
    EndWith
  EndProcedure
  
  Procedure.i Draw_Button(*this._S_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Combobox(*this._S_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      If \box\checked
        State = 2
      EndIf
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4]-\box\width-\text\x[2],\height[#_c_4])
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
        ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
      EndIf
      
      \box\x = \x+\width-\box\width -\box\arrow_size/2
      \box\height = \height[2]
      \box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\box\x+(\box\width-\box\arrow_size)/2, \box\y+(\box\height-\box\arrow_size)/2, \box\arrow_size, Bool(\box\checked)+2, \color\front[State]&$FFFFFF|Alpha, \box\arrow_type)
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_HyperLink(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        If \flag\lines
          Line(\text\x, \text\y+\text\height-2, \text\width, 1, \color\front[\color\state]&$FFFFFF|Alpha)
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\text\x, \text\y, \text\string.s, \color\front[\color\state]&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\text\string.s
          Protected *End.Character = @\text\string.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\text\x, \text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \color\front[\color\state]&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \countItems
          ;           DrawText(\text\x, \text\y+y, StringField(\text\string.s, i, #LF$), \color\front&$FFFFFF|Alpha)
          ;           y+\text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_ListIcon(*this._S_widget)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*this\flag\gridLines, FirstColumn.i
    
    With *this 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[2]-\scroll\h\page\pos
      Protected start, stop, n
      
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[2]>1;(\box\width[1]+\box\width[2]+4)
      ForEach \columns()
        FirstColumn = Bool(Not ListIndex(\columns()))
        n = Bool(\flag\checkboxes)*16 + Bool(\image\width)*28
        
        
        y = \y[2]-\scroll\v\page\pos
        \columns()\y = \y+\bs-\fs
        \columns()\height=\tabHeight
        
        If \columns()\text\change
          \columns()\text\width = TextWidth(\columns()\text\string)
          \columns()\text\height = TextHeight("A")
        EndIf
        
        \columns()\x = x + n : x + \columns()\width + 1
        
        \columns()\image\x = \columns()\x+\columns()\image\x[1] - 1
        \columns()\image\y = \columns()\y+(\columns()\height-\columns()\image\height)/2
        
        \columns()\text\x = \columns()\image\x + \columns()\image\width + Bool(\columns()\image\width) * 3
        \columns()\text\y = \columns()\y+(\columns()\height-\columns()\text\height)/2
        
        \columns()\drawing = Bool(Not \columns()\hide And \columns()\x+\columns()\width>\x[2] And \columns()\x<\x[2]+\width[2])
        
        
        ForEach \columns()\items()
          If Not \columns()\items()\hide 
            If \columns()\items()\text\change = 1
              \columns()\items()\text\height = TextHeight("A")
              \columns()\items()\text\width = TextWidth(\columns()\items()\text\string.s)
            EndIf
            
            \columns()\items()\width=\columns()\width
            \columns()\items()\x=\columns()\x
            \columns()\items()\y=y ; + GridLines
            
            ;\columns()\items()\sublevellen=2+\columns()\items()\x+((Bool(\flag\buttons) * \sublevellen)+\columns()\items()\sublevel * \sublevellen)
            
            If FirstColumn
              If \flag\checkboxes 
                \columns()\items()\box\width[1] = \flag\checkboxes
                \columns()\items()\box\height[1] = \flag\checkboxes
                
                \columns()\items()\box\x[1] = \x[2] + 4 - \scroll\h\page\pos
                \columns()\items()\box\y[1] = (\columns()\items()\y+\columns()\items()\height)-(\columns()\items()\height+\columns()\items()\box\height[1])/2
              EndIf
              
              If \columns()\items()\image\imageID 
                \columns()\items()\image\x = \columns()\x - \columns()\items()\image\width - 6
                \columns()\items()\image\y = \columns()\items()\y+(\columns()\items()\height-\columns()\items()\image\height)/2
                
                \image\imageID = \columns()\items()\image\imageID
                \image\width = \columns()\items()\image\width+4
              EndIf
            EndIf
            
            \columns()\items()\text\x = \columns()\text\x
            \columns()\items()\text\y = \columns()\items()\y+(\columns()\items()\height-\columns()\items()\text\height)/2
            \columns()\items()\drawing = Bool(\columns()\items()\y+\columns()\items()\height>\y[2] And \columns()\items()\y<\y[2]+\height[2])
            
            y + \columns()\items()\height + \flag\gridLines + GridLines * 2
          EndIf
          
          If \index[#Selected] = \columns()\items()\index
            State_3 = 2
          Else
            State_3 = \columns()\items()\state
          EndIf
          
          If \columns()\items()\drawing
            ; Draw selections
            If \flag\fullSelection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height, \color\back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, \color\frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \focus
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\alwaysSelection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, $C8C8C8&back_color|Alpha)
                EndIf
              EndIf
            EndIf
            
            If \columns()\drawing 
              ;\columns()\items()\width = \scroll\h\page\len
              
              ; Draw checkbox
              If \flag\checkboxes And FirstColumn
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(\columns()\items()\box\x[1],\columns()\items()\box\y[1],\columns()\items()\box\width[1],\columns()\items()\box\height[1], 3, 3, \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                
                If \columns()\items()\box\checked[1] = #PB_Checkbox_Checked
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  For i =- 1 To 1
                    LineXY((\columns()\items()\box\x[1]+2),(i+\columns()\items()\box\y[1]+7),(\columns()\items()\box\x[1]+6),(i+\columns()\items()\box\y[1]+8), \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha) 
                    LineXY((\columns()\items()\box\x[1]+9+i),(\columns()\items()\box\y[1]+2),(\columns()\items()\box\x[1]+5+i),(\columns()\items()\box\y[1]+9), \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                  Next
                ElseIf \columns()\items()\box\checked[1] = #PB_Checkbox_Inbetween
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\columns()\items()\box\x[1]+2,\columns()\items()\box\y[1]+2,\columns()\items()\box\width[1]-4,\columns()\items()\box\height[1]-4, 3-2, 3-2, \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                EndIf
              EndIf
              
              ; Draw image
              If \columns()\items()\image\imageID And FirstColumn 
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\columns()\items()\image\imageID, \columns()\items()\image\x, \columns()\items()\image\y, 255)
              EndIf
              
              ; Draw string
              If \columns()\items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\columns()\items()\text\x, \columns()\items()\text\y, \columns()\items()\text\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|\color\alpha<<24)
              EndIf
              
              ; Draw grid line
              If \flag\gridLines
                DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Line(\columns()\items()\x-n, \columns()\items()\y+\columns()\items()\height + GridLines, \columns()\width+n+1 + (\width[2]-(\columns()\x-\x[2]+\columns()\width)), 1, \color\frame&$FFFFFF|\color\alpha<<24)                   ; top
              EndIf
            EndIf
          EndIf
          
          \columns()\items()\text\change = 0
          \columns()\items()\change = 0
        Next
        
        
        If \columns()\drawing
          ; Draw thumb  
          If \color\back[\columns()\state]<>-1
            If \color\fore[\columns()\state]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            
            If FirstColumn And n
              boxGradient( \Vertical, \x[2], \columns()\y, n, \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            ElseIf ListIndex(\columns()) = ListSize(\columns()) - 1
              boxGradient( \Vertical, \columns()\x+\columns()\width, \columns()\y, 1 + (\width[2]-(\columns()\x-\x[2]+\columns()\width)), \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            EndIf
            
            boxGradient( \Vertical, \columns()\x, \columns()\y, \columns()\width, \columns()\height, \color\fore[\columns()\state], Bool(\columns()\state <> 2) * \color\back[\columns()\state] + (Bool(\columns()\state = 2) * \color\front[\columns()\state]), \radius, \color\alpha)
          EndIf
          
          ; Draw string
          If \columns()\text\string
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\columns()\text\x, \columns()\text\y, \columns()\text\string.s, \color\front[0]&$FFFFFF|Alpha)
          EndIf
          
          ; Draw image
          If \columns()\image\imageID
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\columns()\image\imageID, \columns()\image\x, \columns()\image\y, \color\alpha)
          EndIf
          
          ; Draw line 
          If FirstColumn And n
            Line(\columns()\x-1, \columns()\y, 1, \columns()\height + Bool(\flag\gridLines) * \height[1], \color\frame&$FFFFFF|\color\alpha<<24)                     ; left
          EndIf
          Line(\columns()\x+\columns()\width, \columns()\y, 1, \columns()\height + Bool(\flag\gridLines) * \height[1], \color\frame&$FFFFFF|\color\alpha<<24)      ; right
          Line(\x[2], \columns()\y+\columns()\height-1, \width[2], 1, \color\frame&$FFFFFF|\color\alpha<<24)                                                       ; bottom
          
          If \columns()\state = 2
            DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\columns()\x, \columns()\y+1, \columns()\width, \columns()\height-2, \radius, \radius, \color\frame[\columns()\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        \columns()\text\change = 0
      Next
      
      \scroll\height = (y+\scroll\v\page\pos)-\y[2]-1;\flag\gridLines
                                                     ; set vertical scrollbar max value
      If \scroll\v And \scroll\v\page\len And \scroll\v\max<>\scroll\height And 
         SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\scrollstep = \text\height
        Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \scroll\width = (x+\scroll\h\page\pos)-\x[2]-Bool(Not \scroll\v\hide)*\scroll\v\width+n
      If \scroll\h And \scroll\h\page\len And \scroll\h\max<>\scroll\width And 
         SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
        Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x, \y, \width, \height, \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw(*this._S_widget, Childrens=0)
    Protected parent_item.i
    
    With *this
      If \root And \root\create And Not \create 
        If Not IsRoot(*this)
          \function[2] = Bool(\window And \window\function[1] And \window<>\root And \window<>*this) * \window\function[1]
          \function[3] = Bool(\root And \root\function[1]) * \root\function[1]
        EndIf
        \function = Bool(\function[1] Or \function[2] Or \function[3])
        
        w_Events(*this, #PB_EventType_create, - 1)
        
        \create = 1
      EndIf
      
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      ; Get text size
      If (\text And \text\change)
        \text\width = TextWidth(\text\string.s[1])
        \text\height = TextHeight("A")
      EndIf
      
      If \image 
        If (\image\change Or \resize Or \change)
          ; Image default position
          If \image\imageID
            If (\type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\scroll\h\page\len>\image\width And (\image\align\right Or \image\align\horizontal)) * (\scroll\h\page\len-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\scroll\v\page\len>\image\height And (\image\align\bottom Or \image\align\Vertical)) * (\scroll\v\page\len-\image\height)) / (\image\align\Vertical+1)
              \image\y = \scroll\y+\image\y[1]+\y[2]
              \image\x = \scroll\x+\image\x[1]+\x[2]
              
            ElseIf (\type = #PB_GadgetType_Window)
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y+\bs+(\tabHeight-\image\height)/2
              \text\x[2] = \image\x[2] + \image\width
            Else
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y[2]
            EndIf
          EndIf
        EndIf
        
        Protected image_width = \image\width
      EndIf
      
      If \text And (\text\change Or \resize Or \change)
        ; Make multi line text
        If \text\multiLine > 0
          \text\string.s = Text_Wrap(*this, \text\string.s[1], \width-\bs*2, \text\multiLine)
          \countItems = CountString(\text\string.s, #LF$)
        Else
          \text\string.s = \text\string.s[1]
        EndIf
        
        ; Text default position
        If \text\string
          \text\x[1] = \text\x[2] + (Bool((\text\align\right Or \text\align\horizontal)) * (\width[2]-\text\width-image_width)) / (\text\align\horizontal+1)
          \text\y[1] = \text\y[2] + (Bool((\text\align\bottom Or \text\align\Vertical)) * (\height[2]-\text\height)) / (\text\align\Vertical+1)
          
          If \type = #PB_GadgetType_Frame
            \text\x = \text\x[1]+\x[2]+8
            \text\y = \text\y[1]+\y
            
          ElseIf \type = #PB_GadgetType_Window
            \text\x = \text\x[1]+\x[2]+5
            \text\y = \text\y[1]+\y+\bs+(\tabHeight-\text\height)/2
          Else
            \text\x = \text\x[1]+\x[2]
            \text\y = \text\y[1]+\y[2]
          EndIf
        EndIf
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
        
        If \image[1] And \container
          \image[1]\x = \x[2] 
          \image[1]\y = \y[2]
        EndIf
        
        ;           SetOrigin(\x,\y)
        ;           
        ;           If Not Post(#PB_EventType_Repaint, *this)
        ;             SetOrigin(0,0)
        
        
        Select \type
          Case #PB_GadgetType_Window : Draw_Window(*this)
          Case #PB_GadgetType_HyperLink : Draw_HyperLink(*this)
          Case #PB_GadgetType_Property : Draw_Property(*this)
            
          Case #PB_GadgetType_Editor : Draw_Editor(*this)
            
          Case #PB_GadgetType_String : Draw_String(*this)
          Case #PB_GadgetType_IPAddress : Draw_String(*this)
            
          Case #PB_GadgetType_ExplorerList : Draw_ListIcon(*this)
          Case #PB_GadgetType_ListIcon : Draw_ListIcon(*this)
            
          Case #PB_GadgetType_ListView : Draw_Tree(*this)
          Case #PB_GadgetType_Tree : Draw_Tree(*this)
          Case #PB_GadgetType_Text : Draw_Text(*this)
          Case #PB_GadgetType_ComboBox : Draw_Combobox(*this)
          Case #PB_GadgetType_CheckBox : Draw_Checkbox(*this)
          Case #PB_GadgetType_Option : Draw_Option(*this)
          Case #PB_GadgetType_Panel : Draw_Panel(*this)
          Case #PB_GadgetType_Frame : Draw_Frame(*this)
          Case #PB_GadgetType_Image : Draw_Image(*this)
          Case #PB_GadgetType_Button : Draw_Button(*this)
          Case #PB_GadgetType_TrackBar : Draw_Track(*this)
          Case #PB_GadgetType_Spin : Draw_Spin(*this)
          Case #PB_GadgetType_ScrollBar : Draw_Scroll(*this)
          Case #PB_GadgetType_Splitter : Draw_Splitter(*this)
          Case #PB_GadgetType_Container : Draw_Container(*this)
          Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
          Case #PB_GadgetType_ScrollArea : Draw_ScrollArea(*this)
        EndSelect
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
        
        ; Draw Childrens
        If Childrens And ListSize(\childrens())
          ; Only selected item widgets draw
          parent_item = Bool(\type = #PB_GadgetType_Panel) * \index[#Selected]
          
          ForEach \childrens() 
            ;If Not Send(\childrens(), #PB_EventType_Repaint)
            
            If \childrens()\width[#_c_4] > 0 And 
               \childrens()\height[#_c_4] > 0 And 
               \childrens()\parent_item = parent_item
              Draw(\childrens(), Childrens) 
            EndIf
            
            ;EndIf
            
            ; Draw anchors 
            If \childrens()\root And \childrens()\root\anchor And \childrens()\root\anchor\widget = \childrens()
              Draw_Anchors(\childrens()\root\anchor\widget)
            EndIf
            
            SetOrigin(\childrens()\x,\childrens()\y)
            Post(#PB_EventType_Repaint, \childrens())
            SetOrigin(0,0)
            
            
          Next
        EndIf
        
        If \width[#_c_4] > 0 And \height[#_c_4] > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4], $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $00FF00)
          
          If *this\focus And (*this = Active()\_gadget Or *this = Active())  ; Demo default coordinate
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\x,\y,\width,\height, $FF0000)
          EndIf
        EndIf
        
        UnclipOutput()
        
      EndIf
      
      ; reset 
      \change = 0
      \resize = 0
      If \text
        \text\change = 0
      EndIf
      If \image
        \image\change = 0
      EndIf
      
      ; *value\type =- 1 
      ; *value\this = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        If \root\color\back
          ;DrawingMode(#PB_2DDrawing_Default)
          ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
          FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), \root\color\back)
        EndIf
        
        Draw(*this, 1)
        
        
        ;       ; Selector
        ;         If \root\anchor 
        ;           box(\root\anchor\x, \root\anchor\y, \root\anchor\width, \root\anchor\height ,\root\anchor\color[\root\anchor\state]\frame) 
        ;         EndIf
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  ;-
  ;-
  Procedure.i AddItem_Editor(*this._S_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    
    If *this
      With *this
        If \type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\items()) - 1
          LastElement(\items())
          *Item = AddElement(\items()) 
          Item = ListIndex(\items())
        Else
          SelectElement(\items(), Item)
          If \items()\sublevel>sublevel
            sublevel=\items()\sublevel 
          EndIf
          *Item = InsertElement(\items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\items())
          While NextElement(\items())
            \items()\index = ListIndex(\items())
          Wend
          PopListPosition(\items())
        EndIf
        ;}
        
        If *Item
          ;\items() = AllocateMemory(SizeOf(_S_items) )
          \items() = AllocateStructure(_S_items)
          
          ;\items()\handle = adress
          \items()\change = Bool(\type = #PB_GadgetType_Tree)
          ;\items()\text\fontID = \text\fontID
          \items()\index[#Entered] =- 1
          ;\items()\focus =- 1
          ;\items()\lostfocus =- 1
          \items()\text\change = 1
          
          If IsImage(Image)
            
            ;             Select \fromtribute
            ;               Case #PB_Attribute_LargeIcon
            ;                 \items()\image\width = 32
            ;                 \items()\image\height = 32
            ;                 ResizeImage(Image, \items()\image\width,\items()\image\height)
            ;                 
            ;               Case #PB_Attribute_SmallIcon
            ;                 \items()\image\width = 16
            ;                 \items()\image\height = 16
            ;                 ResizeImage(Image, \items()\image\width,\items()\image\height)
            ;                 
            ;               Default
            ;                 \items()\image\width = ImageWidth(Image)
            ;                 \items()\image\height = ImageHeight(Image)
            ;             EndSelect   
            
            \items()\image\imageID = ImageID(Image)
            \items()\image\imageID[1] = Image
            
            \image\width = \items()\image\width
          EndIf
          
          ; add lines
          Editor_AddLine(*this, Item.i, Text.s)
          \text\change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \items()\color = Colors
                           ;           \items()\color\state = 1
                           ;           \items()\color\fore[0] = 0 
                           ;           \items()\color\fore[1] = 0
                           ;           \items()\color\fore[2] = 0
          
          If Item = 0
            If Not \repaint : \repaint = 1
              PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
            EndIf
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure AddItem_Tree(*this._S_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last._S_items
    
    If Not *this
      ProcedureReturn 0
    EndIf
    
    With *this
      ;{ Генерируем идентификатор
      If 0 > Item Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        If \items()\sublevel>sublevel
          sublevel=\items()\sublevel
        EndIf
        InsertElement(\items())
        
        PushListPosition(\items())
        While NextElement(\items())
          \items()\index = ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(_S_items)
      \items()\box = AllocateStructure(_S_box)
      
      Static first.i
      If Item = 0
        First = \items()
      EndIf
      
      If subLevel
        If sublevel>Item
          sublevel=Item
        EndIf
        
        PushListPosition(\items())
        While PreviousElement(\items()) 
          If subLevel = \items()\subLevel
            \i_Parent = \items()\i_Parent
            Break
          ElseIf subLevel > \items()\subLevel
            \i_Parent = \items()
            Break
          EndIf
        Wend 
        PopListPosition(\items())
        
        If \i_Parent
          If subLevel > \i_Parent\subLevel
            sublevel = \i_Parent\sublevel + 1
            \i_Parent\childrens + 1
            ;  \i_Parent\box\checked = 1
            ;  \i_Parent\hide = 1
          EndIf
        EndIf
      Else                                      
        \i_Parent = first
      EndIf
      
      \items()\change = 1
      \items()\index= Item
      \items()\index[#Entered] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \text\height
      \items()\i_Parent = \i_Parent
      
      Set_Image(\items(), Image)
      
      \items()\y = \scroll\height
      \scroll\height + \items()\height
      
      \image = AllocateStructure(_S_image)
      \image\imageID = \items()\image\imageID
      \image\width = \items()\image\width+4
      \countItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure AddItem_ListIcon(*this._S_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last._S_items
    Static adress.i
    Protected Childrens.i, hide.b, height.i
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    If Not *this
      ProcedureReturn -1
    EndIf
    
    With *this
      ForEach \columns()
        
        ;{ Генерируем идентификатор
        If 0 > Item Or Item > ListSize(\columns()\items()) - 1
          LastElement(\columns()\items())
          AddElement(\columns()\items()) 
          Item = ListIndex(\columns()\items())
        Else
          SelectElement(\columns()\items(), Item)
          ;       PreviousElement(\columns()\items())
          ;       If \i_Parent\sublevel = \columns()\items()\sublevel
          ;          \i_Parent = \columns()\items()
          ;       EndIf
          
          ;       SelectElement(\columns()\items(), Item)
          If \i_Parent\sublevel = *last\sublevel
            \i_Parent = *last
          EndIf
          
          If \columns()\items()\sublevel>sublevel
            sublevel=\columns()\items()\sublevel
          EndIf
          InsertElement(\columns()\items())
          
          PushListPosition(\columns()\items())
          While NextElement(\columns()\items())
            \columns()\items()\index = ListIndex(\columns()\items())
          Wend
          PopListPosition(\columns()\items())
        EndIf
        ;}
        
        \columns()\items() = AllocateStructure(_S_items)
        \columns()\items()\box = AllocateStructure(_S_box)
        
        If subLevel
          If sublevel>ListIndex(\columns()\items())
            sublevel=ListIndex(\columns()\items())
          EndIf
        EndIf
        
        If \i_Parent
          If subLevel = \i_Parent\subLevel 
            \columns()\items()\i_Parent = \i_Parent\i_Parent
          ElseIf subLevel > \i_Parent\subLevel 
            \columns()\items()\i_Parent = \i_Parent
            *last = \columns()\items()
          ElseIf \i_Parent\i_Parent
            \columns()\items()\i_Parent = \i_Parent\i_Parent\i_Parent
          EndIf
          
          If \columns()\items()\i_Parent And subLevel > \columns()\items()\i_Parent\subLevel
            sublevel = \columns()\items()\i_Parent\sublevel + 1
            \columns()\items()\i_Parent\childrens + 1
            ;             \columns()\items()\i_Parent\box\checked = 1
            ;             \columns()\items()\hide = 1
          EndIf
        Else
          \columns()\items()\i_Parent = \columns()\items()
        EndIf
        
        
        \i_Parent = \columns()\items()
        \columns()\items()\change = 1
        \columns()\items()\index= Item
        \columns()\items()\index[#Entered] =- 1
        \columns()\items()\text\change = 1
        \columns()\items()\text\string.s = Text.s
        \columns()\items()\sublevel = sublevel
        \columns()\items()\height = \text\height
        
        Set_Image(\columns()\items(), Image)
        
        \columns()\items()\y = \scroll\height
        \scroll\height + \columns()\items()\height
        
        \image\imageID = \columns()\items()\image\imageID
        \image\width = \columns()\items()\image\width+4
        \countItems + 1
        
        
        \columns()\items()\text\string.s = StringField(Text.s, ListIndex(\columns()) + 1, #LF$)
        \columns()\color = def_colors
        \columns()\color\fore[0] = 0 
        \columns()\color\fore[1] = 0
        \columns()\color\fore[2] = 0
        
        \columns()\items()\y = \scroll\height
        \columns()\items()\height = height
        \columns()\items()\change = 1
        
        \image\width = \columns()\items()\image\width
        ;         If ListIndex(\columns()\items()) = 0
        ;           PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
        ;         EndIf
      Next
      
      \scroll\height + height
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure AddItem_Property(*this._S_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *adress._S_items
    
    If Not *this
      ProcedureReturn 0
    EndIf
    
    With *this
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        If \items()\sublevel>sublevel
          sublevel=\items()\sublevel 
        EndIf
        
        InsertElement(\items())
        
        PushListPosition(\items())
        While NextElement(\items())
          \items()\index= ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(_S_items)
      \items()\box = AllocateStructure(_S_box)
      
      If subLevel
        If sublevel>ListIndex(\items())
          sublevel=ListIndex(\items())
        EndIf
        
        PushListPosition(\items()) 
        While PreviousElement(\items()) 
          If subLevel = \items()\subLevel
            *adress = \items()\i_Parent
            Break
          ElseIf subLevel > \items()\subLevel
            *adress = \items()
            Break
          EndIf
        Wend 
        PopListPosition(\items()) 
        
        If *adress
          If subLevel > *adress\subLevel
            sublevel = *adress\sublevel + 1
            *adress\childrens + 1
            ;             *adress\box\checked = 1
            ;             \items()\hide = 1
          EndIf
        EndIf
      EndIf
      
      \items()\change = 1
      \items()\index= Item
      \items()\index[#Entered] =- 1
      \items()\i_Parent = *adress
      \items()\text\change = 1
      
      Protected Type$ = Trim(StringField(Text, 1, " "))
      Protected Info$ = Trim(StringField(Text, 2, " ")) 
      
      If sublevel
        If Info$ : Info$+":" : EndIf
      EndIf
      
      Protected Title$ = Trim(StringField(Text, 3, " "))
      
      
      \items()\text\string.s = Info$
      \items()\text[1]\string.s = Title$
      \items()\sublevel = sublevel
      \items()\height = \text\height
      
      Set_Image(\items(), Image)
      \countItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  ;-
  ;- ADD & GET & SET
  ;-
  Procedure.i X(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \x[Mode]
        Else
          Result = \x[Mode]+\width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \y[Mode]
        Else
          Result = \y[Mode]+\height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \width[Mode] And \color\alpha
          Result = \width[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \height[Mode] And \color\alpha
          Result = \height[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b set_hide_state(*this._S_widget, State.b)
    With *this
      \hide = Bool(State Or \hide[1] Or \parent\hide Or \parent_item <> \parent\index[#Selected])
      
      If \scroll And \scroll\v And \scroll\h
        \scroll\v\hide = \scroll\v\hide[1]
        \scroll\h\hide = \scroll\h\hide[1] 
      EndIf
      
      If ListSize(\childrens())
        ForEach \childrens()
          set_hide_state(\childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b Hide(*this._S_widget, State.b=-1)
    With *this
      If State =- 1
        ProcedureReturn \hide 
      Else
        \hide = State
        \hide[1] = \hide
        
        If ListSize(\childrens())
          ForEach \childrens()
            set_hide_state(\childrens(), State)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i CountItems(*this._S_widget)
    ProcedureReturn *this\countItems
  EndProcedure
  
  Procedure.i ClearItems(*this._S_widget) 
    With *this
      \countItems = 0
      \text\change = 1 
      If \text\editable
        \text\string = #LF$
      EndIf
      
      ClearList(\items())
      If \scroll
        \scroll\v\hide = 1
        \scroll\h\hide = 1
      EndIf
      
      ;       If Not \repaint : \repaint = 1
      ;        PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
      ;       EndIf
    EndWith
  EndProcedure
  
  Procedure.i RemoveItem(*this._S_widget, Item.i) 
    With *this
      \countItems = ListSize(\items()) ; - 1
      \text\change = 1
      
      If \countItems =- 1 
        \countItems = 0 
        \text\string = #LF$
        ;         If Not \repaint : \repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug Item
        If SelectElement(\items(), Item)
          DeleteElement(\items())
        EndIf
        
        \text\string = RemoveString(\text\string, StringField(\text\string, Item+1, #LF$) + #LF$)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Enumerate(*this.Integer, *Parent._S_widget, parent_item.i=0)
    Protected Result.i
    
    With *Parent
      If Not *this
        ;  ProcedureReturn 0
      EndIf
      
      If Not \enumerate
        Result = FirstElement(\childrens())
      Else
        Result = NextElement(\childrens())
      EndIf
      
      \enumerate = Result
      
      If Result
        If \childrens()\parent_item <> parent_item 
          ProcedureReturn Enumerate(*this, *Parent, parent_item)
        EndIf
        ;         
        ;                 If ListSize(\childrens()\childrens())
        ;                   ProcedureReturn Enumerate(*this, \childrens(), parent_item)
        ;                 EndIf
        
        PokeI(*this, PeekI(@\childrens()))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i IsContainer(*this._S_widget)
    ProcedureReturn *this\container
  EndProcedure
  
  
  ;- ADD
  Procedure.i AddItem(*this._S_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *this
      
      Select \type
        Case #PB_GadgetType_Panel
          LastElement(\items())
          AddElement(\items())
          
          ; last opened item of the parent
          \o_i = ListIndex(\items())
          
          \items() = AllocateStructure(_S_items)
          \items()\index = ListIndex(\items())
          \items()\text\string = Text.s
          \items()\text\change = 1
          \items()\height = \tabHeight
          \countItems + 1 
          
          Set_Image(\items(), Image)
          
        Case #PB_GadgetType_Property
          ProcedureReturn AddItem_Property(*this, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
          ProcedureReturn AddItem_Tree(*this, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Editor
          ProcedureReturn AddItem_Editor(*this, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ListIcon
          ProcedureReturn AddItem_ListIcon(*this, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ComboBox
          Protected *Tree._S_widget = \popup\childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(_S_items)
          *Tree\items()\box = AllocateStructure(_S_box)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\text\string = Text.s
          *Tree\items()\text\change = 1
          *Tree\items()\height = \text\height
          *Tree\countItems + 1 
          
          *Tree\items()\y = *Tree\scroll\height
          *Tree\scroll\height + *Tree\items()\height
          
          Set_Image(*Tree\items(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  Procedure.i AddColumn(*this._S_widget, Position.i, Title.s, Width.i)
    With *this
      LastElement(\columns())
      AddElement(\columns()) 
      \columns() = AllocateStructure(_S_widget)
      
      If Position =- 1
        Position = ListIndex(\columns())
      EndIf
      
      \columns()\index[#Entered] =- 1
      \columns()\index[#Selected] =- 1
      \columns()\index = Position
      \columns()\width = Width
      
      \columns()\image = AllocateStructure(_S_image)
      \columns()\image\x[1] = 5
      
      \columns()\text = AllocateStructure(_S_text)
      \columns()\text\string.s = Title.s
      \columns()\text\change = 1
      
      \columns()\x = \x[2]+\scroll\width
      \columns()\height = \tabHeight
      \scroll\height = \bs*2+\columns()\height
      \scroll\width + Width + 1
    EndWith
  EndProcedure
  
  
  ;- GET
  Procedure.i GetGetAdress(*this._S_widget)
    ProcedureReturn *this\adress
  EndProcedure
  
  Procedure GetActive() 
    ProcedureReturn Active()
  EndProcedure
  
  Procedure GetFocus()
    ProcedureReturn Active()\_gadget
  EndProcedure
  
  Procedure.i GetButtons(*this._S_widget)
    ProcedureReturn *this\mouse\buttons
  EndProcedure
  
  Procedure.i GetMouseX(*this._S_widget)
    ProcedureReturn *this\mouse\x-*this\x[2]-*this\fs
  EndProcedure
  
  Procedure.i GetMouseY(*this._S_widget)
    ProcedureReturn *this\mouse\y-*this\y[2]-*this\fs
  EndProcedure
  
  Procedure.i GetDeltaX(*this._S_widget)
    ;If *this\mouse\delta
    ; ProcedureReturn (*this\mouse\delta\x-*this\x[2]-*this\fs)+*this\x[3]
    ProcedureReturn (*this\root\mouse\delta\x-*this\x[2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.i GetDeltaY(*this._S_widget)
    ;If *this\mouse\delta
    ; ProcedureReturn (*this\mouse\delta\y-*this\y[2]-*this\fs)+*this\y[3]
    ProcedureReturn (*this\root\mouse\delta\y-*this\y[2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.s GetClass(*this._S_widget)
    ProcedureReturn *this\class
  EndProcedure
  
  Procedure.i GetCount(*this._S_widget)
    ProcedureReturn *this\type_Index ; Parent\type_count(Hex(*this\parent)+"_"+Hex(*this\type))
  EndProcedure
  
  Procedure.i GetLevel(*this._S_widget)
    ProcedureReturn *this\level
  EndProcedure
  
  Procedure.i GetRoot(*this._S_widget)
    ProcedureReturn *this\root
  EndProcedure
  
  Procedure.i GetWindow(*this._S_widget)
    If *this = *this\root
      ProcedureReturn *this\root\canvas\window
    Else
      ProcedureReturn *this\window
    EndIf
  EndProcedure
  
  Procedure.i GetGadget(*this._S_widget)
    ProcedureReturn *this\root\canvas\gadget
  EndProcedure
  
  Procedure.i GetParent(*this._S_widget)
    ProcedureReturn *this\parent
  EndProcedure
  
  Procedure.i GetParentItem(*this._S_widget)
    ProcedureReturn *this\parent_item
  EndProcedure
  
  Procedure.i GetPosition(*this._S_widget, Position.i)
    Protected Result.i
    
    With *this
      If *this And \parent
        ; 
        If (\type = #PB_GadgetType_ScrollBar And 
            \parent\type = #PB_GadgetType_ScrollArea) Or
           \parent\type = #PB_GadgetType_Splitter
          *this = \parent
        EndIf
        
        Select Position
          Case #PB_List_First  : Result = FirstElement(\parent\childrens())
          Case #PB_List_Before : ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) : Result = PreviousElement(\parent\childrens())
          Case #PB_List_After  : ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) : Result = NextElement(\parent\childrens())
          Case #PB_List_Last   : Result = LastElement(\parent\childrens())
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetState(*this._S_widget)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Option,
             #PB_GadgetType_CheckBox 
          Result = \box\checked
          
        Case #PB_GadgetType_IPAddress : Result = \index[#Selected]
        Case #PB_GadgetType_ComboBox : Result = \index[#Selected]
        Case #PB_GadgetType_Tree : Result = \index[#Selected]
        Case #PB_GadgetType_ListIcon : Result = \index[#Selected]
        Case #PB_GadgetType_ListView : Result = \index[#Selected]
        Case #PB_GadgetType_Panel : Result = \index[#Selected]
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = _invert_(*this, \page\pos, \inverted)
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : Result = \box\size[1]
            Case #PB_Splitter_SecondMinimumSize : Result = \box\size[2] - \box\size[3]
          EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \min  ; 1
            Case #PB_Bar_Maximum : Result = \max  ; 2
            Case #PB_Bar_Inverted : Result = \inverted
            Case #PB_Bar_NoButtons : Result = \box\size ; 4
            Case #PB_Bar_Direction : Result = \direction
            Case #PB_Bar_PageLength : Result = \page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._S_widget, Item.i, Attribute.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Tree
          ForEach \items()
            If \items()\index = Item 
              Select Attribute
                Case #PB_Tree_SubLevel
                  Result = \items()\sublevel
                  
              EndSelect
              Break
            EndIf
          Next
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*this._S_widget, Item.i)
  EndProcedure
  
  Procedure.i GetItemState(*this._S_widget, Item.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemData(*this._S_widget, Item.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          PushListPosition(\items()) 
          ForEach \items()
            If \items()\index = Item 
              Result = \items()\data
              ; Debug \items()\text\string
              Break
            EndIf
          Next
          PopListPosition(\items())
      EndSelect
    EndWith
    
    ;     If Result
    ;       Protected *w._S_widget = Result
    ;       
    ;       Debug "GetItemData "+Item +" "+ Result +" "+  *w\class
    ;     EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._S_widget, Item.i, Column.i=0)
    Protected Result.s
    
    With *this
      
      Select \type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
          ForEach \items()
            If \items()\index = Item 
              Result = \items()\text\string.s
              Break
            EndIf
          Next
          
        Case #PB_GadgetType_ListIcon
          SelectElement(\columns(), Column)
          
          ForEach \columns()\items()
            If \columns()\items()\index = Item 
              Result = \columns()\items()\text\string.s
              Break
            EndIf
          Next
      EndSelect
      
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetData(*this._S_widget)
    ProcedureReturn *this\data
  EndProcedure
  
  Procedure.i GetImage(*this._S_widget)
    ProcedureReturn *this\image\index
  EndProcedure
  
  Procedure.s GetText(*this._S_widget)
    If *this\text
      ProcedureReturn *this\text\string.s
    EndIf
  EndProcedure
  
  Procedure.i GetType(*this._S_widget)
    ProcedureReturn *this\type
  EndProcedure
  
  
  ;- SET
  Procedure.i SetAlignment(*this._S_widget, Mode.i, Type.i=1)
    With *this
      Select Type
        Case 1 ; widget
          If \parent
            If Not \align
              \align._S_align = AllocateStructure(_S_align)
            EndIf
            
            If Not \align\autoSize
              \align\top = Bool(Mode&#PB_Top=#PB_Top)
              \align\left = Bool(Mode&#PB_Left=#PB_Left)
              \align\right = Bool(Mode&#PB_Right=#PB_Right)
              \align\bottom = Bool(Mode&#PB_Bottom=#PB_Bottom)
              
              If Bool(Mode&#PB_Center=#PB_Center)
                \align\horizontal = 1
                \align\Vertical = 1
              Else
                \align\horizontal = Bool(Mode&#PB_Horizontal=#PB_Horizontal)
                \align\Vertical = Bool(Mode&#PB_Vertical=#PB_Vertical)
              EndIf
            EndIf
            
            If Bool(Mode&#PB_Flag_AutoSize=#PB_Flag_AutoSize)
              If Bool(Mode&#PB_Full=#PB_Full) 
                \align\top = 1
                \align\left = 1
                \align\right = 1
                \align\bottom = 1
                \align\autoSize = 0
              EndIf
              
              ; Auto dock
              Static y2,x2,y1,x1
              Protected width = #PB_Ignore, height = #PB_Ignore
              
              If \align\left And \align\right
                \x = x2
                width = \parent\width[2] - x1 - x2
              EndIf
              If \align\top And \align\bottom 
                \y = y2
                height = \parent\height[2] - y1 - y2
              EndIf
              
              If \align\left And Not \align\right
                \x = x2
                \y = y2
                x2 + \width
                height = \parent\height[2] - y1 - y2
              EndIf
              If \align\right And Not \align\left
                \x = \parent\width[2] - \width - x1
                \y = y2
                x1 + \width
                height = \parent\height[2] - y1 - y2
              EndIf
              
              If \align\top And Not \align\bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \parent\width[2] - x1 - x2
              EndIf
              If \align\bottom And Not \align\top
                \x = 0
                \y = \parent\height[2] - \height - y1
                y1 + \height
                width = \parent\width[2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
              \align\top = Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              \align\left = Bool(Mode&#PB_Left=#PB_Left)+Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Top=#PB_Top)
              \align\right = Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Bottom=#PB_Bottom)
              \align\bottom = Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              
            EndIf
            
            If \align\right
              If \align\left And \align\right
                \align\x = \parent\width[2] - \width
              Else
                \align\x = \parent\width[2] - (\x-\parent\x[2]) ; \parent\width[2] - (\parent\width[2] - \width)
              EndIf
            EndIf
            If \align\bottom
              If \align\top And \align\bottom
                \align\y = \parent\height[2] - \height
              Else
                \align\y = \parent\height[2] - (\y-\parent\y[2]) ; \parent\height[2] - (\parent\height[2] - \height)
              EndIf
            EndIf
            
            Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i SetTransparency(*this._S_widget, Transparency.a) ; opacity
    Protected Result.i
    
    With *this
      \color\alpha = Transparency
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s SetClass(*this._S_widget, Class.s)
    Protected Result.s
    
    With *this
      Result.s = \class
      
      ;       If Class.s
      \class = Class
      ;       Else
      ;         \class = Class(\type)
      ;       EndIf
      
    EndWith
    
    ProcedureReturn Result.s
  EndProcedure
  
  Procedure.i SetParent(*this._S_widget, *Parent._S_widget, parent_item.i=-1)
    Protected x.i,y.i, *LastParent._S_widget
    
    With *this
      If *this > 0 
        If parent_item =- 1
          parent_item = *Parent\index[#Selected]
        EndIf
        
        If *Parent <> \parent Or \parent_item <> parent_item
          x = \x[3]
          y = \y[3]
          
          If \parent And ListSize(\parent\childrens())
            ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) 
            DeleteElement(\parent\childrens())
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \parent_item = parent_item
          \parent = *Parent
          \root = *Parent\root
          
          \root\countItems + 1 
          
          If \parent <> \root
            \parent\countItems + 1 
            \level = \parent\level + 1
            \window = \parent\window
          Else
            \window = \parent
          EndIf
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \hide = Bool(\parent\hide Or \parent_item <> \parent\index[#Selected])
          
          If \scroll
            If \scroll\v
              \scroll\v\window = \window
            EndIf
            If \scroll\h
              \scroll\h\window = \window
            EndIf
          EndIf
          
          If \parent\scroll
            x-\parent\scroll\h\page\pos
            y-\parent\scroll\v\page\pos
          EndIf
          
          ; Add new children 
          LastElement(\parent\childrens()) 
          \adress = AddElement(\parent\childrens())
          
          If \adress
            \parent\childrens() = *this 
            \index = \root\countItems 
          EndIf
          
          ; Make count type
          If \window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\type))
            typecount(Hex(\window)+"_"+Hex(\type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\type))
            typecount(Hex(\parent)+"__"+Hex(\type)) + 1
          EndIf
          
          ;
          Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
          
          If *LastParent
            ;             Debug ""+*root\width+" "+*LastParent\root\width+" "+*Parent\root\width 
            ;             Debug "From ("+ Class(*LastParent\type) +") to (" + Class(*Parent\type) +") - SetParent()"
            
            If *LastParent <> *Parent
              Select Root()
                Case *Parent\root     : ReDraw(*Parent)
                Case *LastParent\root : ReDraw(*LastParent)
              EndSelect
            EndIf
            
          EndIf
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetPosition(*this._S_widget, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
    With *this
      If IsRoot(*this)
        ProcedureReturn
      EndIf
      
      If \parent
        ;
        If (\type = #PB_GadgetType_ScrollBar And \parent\type = #PB_GadgetType_ScrollArea) Or
           \parent\type = #PB_GadgetType_Splitter
          *this = \parent
        EndIf
        
        ChangeCurrentElement(\parent\childrens(), GetAdress(*this))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\parent\childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\parent\childrens()) : MoveElement(\parent\childrens(), #PB_List_After, GetAdress(\parent\childrens()))
            Case #PB_List_After  : NextElement(\parent\childrens())     : MoveElement(\parent\childrens(), #PB_List_Before, GetAdress(\parent\childrens()))
            Case #PB_List_Last   : MoveElement(\parent\childrens(), #PB_List_Last)
          EndSelect
          
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\parent\childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\parent\childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
        ; \parent\childrens()\adress = @\parent\childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  Procedure.i SetActive(*this._S_widget)
    Protected Result.i
    
    Macro _set_active_state_(_state_)
      ;If Active()
      Active()\focus = _state_
      
      If Active() <> Active()\root
        If _state_
          Events(Active(), Active()\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Active(), Active()\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
      EndIf
      
      If Active()\_gadget
        Active()\_gadget\focus = _state_
        If _state_
          Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
      EndIf
      ;EndIf
    EndMacro
    
    With *this
      Protected *DeActive._S_widget = Active()
      
      If \type > 0
        If Active()\_gadget <> *this
          
          If Active() <> \window
            If Active()
              _set_active_state_(0)
            EndIf
            
            Active() = \window
            Active()\_gadget = *this
            
            _set_active_state_(1)
          Else
            If Active()\_gadget
              Active()\_gadget\focus = 0
              Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_LostFocus, -1, -1)
            EndIf
            
            Active()\_gadget = *this
            Active()\_gadget\focus = 1
            Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_Focus, -1, -1)
          EndIf
          
          Result = #True 
        EndIf
        
      ElseIf Active() <> *this
        If Active()
          _set_active_state_(0)
        EndIf
        
        Active() = *this
        
        _set_active_state_(1)
        
        Result = #True
      EndIf
      
      SetPosition(Active(), #PB_List_Last)
      
      If *DeActive And *DeActive <> Active()
         PostEvent(#PB_Event_Gadget, *DeActive\root\canvas\window, *DeActive\root\canvas\gadget, #PB_EventType_Repaint)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFlag(*this._S_widget, Flag.i)
    
    With *this
      If Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget
        ;         AddAnchors(*this)
        Resize_Anchors(*this)
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*this._S_widget, FontID.i)
    
    With *this
      \text\fontID = FontID
    EndWith
    
  EndProcedure
  
  Procedure.i SetText(*this._S_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    
    With *this
      If \text And \text\string.s[1] <> Text.s
        \text\string.s[1] = Text_Make(*this, Text.s)
        
        If \text\string.s[1]
          If \text\multiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \text\multiLine > 0
              Text.s + #LF$
            EndIf
            
            \text\string.s[1] = Text.s
            \countItems = CountString(\text\string.s[1], #LF$)
          Else
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$) ; + #LF$
                                                                      ; \text\string.s = RTrim(ReplaceString(\text\string.s[1], #LF$, " ")) + #LF$
          EndIf
          
          \text\string.s = \text\string.s[1]
          \text\len = Len(\text\string.s[1])
          \text\change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*this._S_widget, State.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *this
      If *this > 0
        Select \type
          Case #PB_GadgetType_IPAddress
            If \index[#Selected] <> State : \index[#Selected] = State
              SetText(*this, Str(IPAddressField(State,0))+"."+
                             Str(IPAddressField(State,1))+"."+
                             Str(IPAddressField(State,2))+"."+
                             Str(IPAddressField(State,3)))
            EndIf
            
          Case #PB_GadgetType_CheckBox
            Select State
              Case #PB_Checkbox_Unchecked,
                   #PB_Checkbox_Checked
                \box\checked = State
                ProcedureReturn 1
                
              Case #PB_Checkbox_Inbetween
                If \box\threeState 
                  \box\checked = State
                  ProcedureReturn 1
                EndIf
            EndSelect
            
          Case #PB_GadgetType_Option
            If \option_group And \box\checked <> State
              If \option_group\option_group <> *this
                If \option_group\option_group
                  \option_group\option_group\box\checked = 0
                EndIf
                \option_group\option_group = *this
              EndIf
              \box\checked = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_ComboBox
            Protected *t._S_widget = \popup\childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\countItems - 1 : State = *t\countItems - 1 :  EndIf
            
            If *t\index[#Selected] <> State
              If *t\index[#Selected] >= 0 And SelectElement(*t\items(), *t\index[#Selected]) 
                *t\items()\state = 0
              EndIf
              
              *t\index[#Selected] = State
              \index[#Selected] = State
              
              If SelectElement(*t\items(), State)
                *t\items()\state = 2
                *t\change = State+1
                
                \text\string[1] = *t\items()\text\string
                \text\string = \text\string[1]
                ;                 \text[1]\string = \text\string[1]
                ;                 \text\caret = 1
                ;                 \text\caret[1] = \text\caret
                \text\change = 1
                
                w_Events(*this, #PB_EventType_Change, State)
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \countItems - 1 : State = \countItems - 1 :  EndIf
            
            If \index[#Selected] <> State
              If \index[#Selected] >= 0 And 
                 SelectElement(\items(), \index[#Selected]) 
                \items()\state = 0
              EndIf
              
              \index[#Selected] = State
              
              If SelectElement(\items(), \index[#Selected])
                \items()\state = 2
                \change = \index[#Selected]+1
                ; w_Events(*this, #PB_EventType_Change, \index[#Selected])
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            Result = Set_Image(*this, State)
            
            If Result
              If \scroll
                SetAttribute(\scroll\v, #PB_Bar_Maximum, \image\height)
                SetAttribute(\scroll\h, #PB_Bar_Maximum, \image\width)
                
                \resize = 1<<1|1<<2|1<<3|1<<4 
                Resize(*this, \x, \y, \width, \height) 
                \resize = 0
              EndIf
            EndIf
            
          Case #PB_GadgetType_Panel
            If State < 0 : State = 0 : EndIf
            If State > \countItems - 1 : State = \countItems - 1 :  EndIf
            
            If \index[#Selected] <> State : \index[#Selected] = State
              
              ForEach \childrens()
                set_hide_state(\childrens(), Bool(\childrens()\parent_item<>\childrens()\parent\index[#Selected]))
              Next
              
              \change = State + 1
              Result = 1
            EndIf
            
          Default
            If (\Vertical And \type = #PB_GadgetType_TrackBar)
              State = _invert_(*this, State, \inverted)
            EndIf
            
            State = PagePos(*this, State)
            
            If \page\pos <> State 
              \thumb\pos = _thumb_pos_(*this, State)
              
              If \inverted
                If \page\pos > State
                  \direction = _invert_(*this, State, \inverted)
                Else
                  \direction =- _invert_(*this, State, \inverted)
                EndIf
              Else
                If \page\pos > State
                  \direction =- State
                Else
                  \direction = State
                EndIf
              EndIf
              
              \change = \page\pos - State
              \page\pos = State
              
              If \type = #PB_GadgetType_Spin
                \text\string.s[1] = Str(\page\pos) : \text\change = 1
                
              ElseIf \type = #PB_GadgetType_Splitter
                Resize_Splitter(*this)
                
              ElseIf \parent
                \parent\change =- 1
                
                If \parent\scroll
                  If \Vertical
                    \parent\scroll\y =- \page\pos
                    Resize_Childrens(\parent, 0, \change)
                  Else
                    \parent\scroll\x =- \page\pos
                    Resize_Childrens(\parent, \change, 0)
                  EndIf
                EndIf
              EndIf
              
              w_Events(*this, #PB_EventType_Change, State, \direction)
              Result = #True
            EndIf
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*this._S_widget, Attribute.i, Value.i)
    Protected Resize.i
    
    With *this
      If *this > 0
        Select \type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                Set_Image(*this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \box\size[1] = Value
              Case #PB_Splitter_SecondMinimumSize : \box\size[2] = \box\size[3] + Value
            EndSelect 
            
            If \Vertical
              \area\pos = \y+\box\size[1]
              \area\len = (\height-\box\size[1]-\box\size[2])
            Else
              \area\pos = \x+\box\size[1]
              \area\len = (\width-\box\size[1]-\box\size[2])
            EndIf
            
            ProcedureReturn 1
            
          Case #PB_GadgetType_Image
            Select Attribute
              Case #PB_DisplayMode
                
                Select Value
                  Case 0 ; Default
                    \image\align\Vertical = 0
                    \image\align\horizontal = 0
                    
                  Case 1 ; Center
                    \image\align\Vertical = 1
                    \image\align\horizontal = 1
                    
                  Case 3 ; Mosaic
                  Case 2 ; Stretch
                    
                  Case 5 ; Proportionally
                EndSelect
                
                ;Resize = 1
                \resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*this, \x, \y, \width, \height)
                \resize = 0
            EndSelect
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \box\size[0] = Value
                \box\size[1] = Value
                \box\size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \page\pos = _invert_(*this, \page\pos)
                \thumb\pos = _thumb_pos_(*this, \page\pos)
                
                ; \thumb\pos = _thumb_pos_(*this, _invert_(*this, \page\pos, \inverted))
                ProcedureReturn 1
                
              Case #PB_Bar_Minimum ; 1 -m&l
                If \min <> Value 
                  \min = Value
                  \page\pos + Value
                  
                  If \page\pos > \max-\page\len
                    If \max > \page\len 
                      \page\pos = \max-\page\len
                    Else
                      \page\pos = \min 
                    EndIf
                  EndIf
                  
                  If \max > \min
                    \thumb\pos = _thumb_pos_(*this, \page\pos)
                    \thumb\len = _thumb_len_(*this)
                  Else
                    \thumb\pos = \area\pos
                    \thumb\len = \area\len
                    
                    If \Vertical 
                      \box\y[3] = \thumb\pos  
                      \box\height[3] = \thumb\len
                    Else 
                      \box\x[3] = \thumb\pos 
                      \box\width[3] = \thumb\len
                    EndIf
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_Maximum ; 2 -m&l
                If \max <> Value
                  \max = Value
                  
                  If \page\len > \max 
                    \page\pos = \min
                  EndIf
                  
                  \thumb\pos = _thumb_pos_(*this, \page\pos)
                  
                  If \max > \min
                    \thumb\len = _thumb_len_(*this)
                  Else
                    \thumb\len = \area\len
                    
                    If \Vertical 
                      \box\height[3] = \thumb\len
                    Else 
                      \box\width[3] = \thumb\len
                    EndIf
                  EndIf
                  
                  If \scrollstep = 0
                    \scrollstep = 1
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_PageLength ; 3 -m&l
                If \page\len <> Value
                  If Value > (\max-\min)
                    If \max = 0 
                      \max = Value 
                    EndIf
                    Value = (\max-\min)
                    \page\pos = \min
                  EndIf
                  \page\len = Value
                  
                  \thumb\pos = _thumb_pos_(*this, \page\pos)
                  
                  If \page\len > \min
                    \thumb\len = _thumb_len_(*this)
                  Else
                    \thumb\len = \box\size[3]
                  EndIf
                  
                  If \scrollstep = 0
                    \scrollstep = 1
                  EndIf
                  If \scrollstep < 2 And \page\len
                    \scrollstep = (\max-\min) / \page\len 
                  EndIf
                  
                  Resize = 1
                EndIf
                
            EndSelect
            
        EndSelect
        
        If Resize
          \resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetItemAttribute(*this._S_widget, Item.i, Attribute.i, Value.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Panel
          If SelectElement(\items(), Item)
            Select Attribute 
              Case #PB_Button_Image
                Result = Set_Image(\items(), Value)
            EndSelect
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._S_widget, Item.i, Image.i)
    Protected Result.i
    
    With *this
      Select Item
        Case 0
          \image[Item]\change = 1
          
          If IsImage(Image)
            \image[Item]\index = Image
            \image[Item]\imageID = ImageID(Image)
            \image[Item]\width = ImageWidth(Image)
            \image[Item]\height = ImageHeight(Image)
          Else
            \image[Item]\index =- 1
            \image[Item]\imageID = 0
            \image[Item]\width = 0
            \image[Item]\height = 0
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*this._S_widget, Item.i, State.i)
    Protected Result, sublevel
    
    With *this
      Select \type
        Case #PB_GadgetType_ListView
          If (\flag\multiSelect Or \flag\clickSelect)
            Result = SelectElement(\items(), Item) 
            If Result 
              \items()\state = Bool(State)+1
            EndIf
          EndIf
          
        Case #PB_GadgetType_Tree
          
          If Item < 0 : Item = 0 : EndIf
          If Item > \countItems : Item = \countItems :  EndIf
          ;       
          ;       If \index[#Selected] <> Item
          ;         If \index[#Selected] >= 0 And SelectElement(\items(), \index[#Selected]) 
          ;           \items()\state = 0
          ;         EndIf
          ;         
          ;         If SelectElement(\items(), Item)
          ;           *value\type = #PB_EventType_Change
          ;           *value\widget = *this
          ;           \items()\state = 2
          ;           \change = Item+1
          ;           
          ;           PostEvent(#PB_Event_Widget, *value\window, *this, #PB_EventType_Change)
          ;           PostEvent(#PB_Event_Gadget, *value\window, *value\gadget, #PB_EventType_Repaint)
          ;         EndIf
          ;         
          ;         \index[#Selected] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\flag\multiSelect Or \flag\clickSelect)
          PushListPosition(\items())
          Result = SelectElement(\items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \items()\index[#Entered] = \items()\index
              \items()\state = Bool(State)+1
            EndIf
            
            \items()\box\checked = Bool(State&#PB_Tree_Collapsed)
            
            If \items()\box\checked Or State&#PB_Tree_Expanded
              
              sublevel = \items()\sublevel
              
              PushListPosition(\items())
              While NextElement(\items())
                If sublevel = \items()\sublevel
                  Break
                ElseIf sublevel < \items()\sublevel 
                  If State&#PB_Tree_Collapsed
                    \items()\hide = 1
                  ElseIf State&#PB_Tree_Expanded
                    \items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            
          EndIf
          PopListPosition(\items())
          ; EndIf
          
          ;          If \index[#Entered] >= 0 And SelectElement(\items(), \index[#Entered]) 
          ;                 Protected sublevel.i
          ;                 
          ;                 If (mouse_y > (\items()\box\y[1]) And mouse_y =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
          ;                    ((mouse_x > \items()\box\x[1]) And (mouse_x =< (\items()\box\x[1]+\items()\box\width[1])))
          ;                   
          ;                   \items()\box\checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (mouse_y > (\items()\box\y[0]) And mouse_y =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
          ;                        ((mouse_x > \items()\box\x[0]) And (mouse_x =< (\items()\box\x[0]+\items()\box\width[0])))
          ;                   
          ;                   sublevel = \items()\sublevel
          ;                   \items()\box\checked ! 1
          ;                   \change = 1
          ;                   
          ;                   PushListPosition(\items())
          ;                   While NextElement(\items())
          ;                     If sublevel = \items()\sublevel
          ;                       Break
          ;                     ElseIf sublevel < \items()\sublevel And \items()\a
          ;                       \items()\hide = Bool(\items()\a\box\checked Or \items()\a\hide) * 1
          ;                     EndIf
          ;                   Wend
          ;                   PopListPosition(\items())
          ;                   
          ;                 ElseIf \index[#Selected] <> \index[#Entered] : \items()\state = 2
          ;                   If \index[#Selected] >= 0 And SelectElement(\items(), \index[#Selected])
          ;                     \items()\state = 0
          ;                   EndIf
          ;                   \index[#Selected] = \index[#Entered]
          ;                 EndIf
          ;                 
          ;                 Repaint = 1
          ;               EndIf
      EndSelect     
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemData(*this._S_widget, Item.i, *Data)
    Protected Result.i;, *w._S_widget = *Data
    
    ;Debug "SetItemData "+Item +" "+ *Data ;+" "+  *w\index
    ;     
    With *this
      PushListPosition(\items()) 
      ForEach \items()
        If \items()\index = Item  ;  ListIndex(\items()) = Item ;  
          \items()\data = *Data
          Break
        EndIf
      Next
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemText(*this._S_widget, Item.i, Text.s)
    Protected Result.i
    
    With *this
      ForEach \items()
        If \items()\index = Item 
          
          If \type = #PB_GadgetType_Property
            \items()\text[1]\string.s = Text
          Else
            \items()\text\string.s = Text
          EndIf
          
          ;\items()\text\string.s = Text.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetData(*this._S_widget, *data)
    Protected Result.i
    
    With *this
      \data = *data
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetImage(*this._S_widget, Image.i)
    Protected i.i, Result.i = IsImage(Image)
    
    With *this
      i = Bool(\container)
      
      \image[i]\change = 1
      
      If IsImage(Image)
        \image[i]\index = Image
        \image[i]\imageID = ImageID(Image)
        \image[i]\width = ImageWidth(Image)
        \image[i]\height = ImageHeight(Image)
      Else
        \image[i]\index =- 1
        \image[i]\imageID = 0
        \image[i]\width = 0
        \image[i]\height = 0
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*this._S_widget, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *this
      If State =- 1
        Count = 2
        \color\state = 0
      Else
        Count = State
        \color\state = State
      EndIf
      
      For State = \color\state To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \color[Item]\line[State] <> Color 
              \color[Item]\line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \color[Item]\back[State] <> Color 
              \color[Item]\back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \color[Item]\front[State] <> Color 
              \color[Item]\front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \color[Item]\frame[State] <> Color 
              \color[Item]\frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetCursor(*this._S_widget)
    ProcedureReturn *this\cursor
  EndProcedure
  
  Procedure.i SetCursor(*this._S_widget, Cursor.i, CursorType.i=#PB_Canvas_Cursor)
    Protected Result.i
    
    With *this
      If \cursor <> Cursor
        If CursorType = #PB_Canvas_CustomCursor
          If Cursor
            Protected.i x, y, ImageID = Cursor
            
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Windows
                Protected ico.ICONINFO
                ico\fIcon = 0
                ico\xHotspot =- x 
                ico\yHotspot =- y 
                ico\hbmMask = ImageID
                ico\hbmColor = ImageID
                
                Protected *Cursor = createIconIndirect_(ico)
                If Not *Cursor 
                  *Cursor = ImageID 
                EndIf
                
              CompilerCase #PB_OS_Linux
                Protected *Cursor.GdkCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(), ImageID, x, y)
                
              CompilerCase #PB_OS_MacOS
                Protected Hotspot.NSPoint
                Hotspot\x = x
                Hotspot\y = y
                Protected *Cursor = CocoaMessage(0, 0, "NSCursor alloc")
                CocoaMessage(0, *Cursor, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
                
            CompilerEndSelect
            
            Cursor = *Cursor
          EndIf
        EndIf
        
        
        SetGadgetAttribute(\root\canvas\gadget, CursorType, Cursor)
        
        \cursor = Cursor
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- CHANGE
  Procedure.i Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #PB_Flag_AutoSize
        If \parent And \parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\x
          Y = 0; \align\y
          Width = \parent\width[2] ; - \align\x
          Height = \parent\height[2] ; - \align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \parent : \x[3] = X : X+\parent\x+\parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \parent : \y[3] = Y : Y+\parent\y+\parent\bs+\parent\tabHeight : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[2] = \y+\bs+\tabHeight : \y[1] = \y[2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[2] = \height-\bs*2-\tabHeight : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[2] = width-Bool(\type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\tabHeight+\bs*2) : \height[2] = height-Bool(\type<>-1)*(\tabHeight+\bs*2) : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        If \box And \resize
          If \type = #PB_GadgetType_ScrollBar
            \hide[1] = Bool(\page\len And Not ((\max-\min) > \page\len))
            
            If \vertical
              If Not \width
                \hide[1] = 1
              EndIf
            Else
              If Not \height
                \hide[1] = 1
              EndIf
            EndIf
          EndIf
          
          If \box\size
            \box\size[1] = \box\size
            \box\size[2] = \box\size
          EndIf
          
          If \max
            If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
              \area\pos = \y[2]+\box\size[1]
              \area\len = \height[2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            Else
              \area\pos = \x[2]+\box\size[1]
              \area\len = \width[2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            EndIf
          EndIf
          
          If (\type <> #PB_GadgetType_Splitter) And Bool(\resize & (1<<4 | 1<<3))
            \thumb\len = _thumb_len_(*this)
            
            
            If (\area\len > \box\size)
              If \box\size
                If (\thumb\len < \box\size)
                  \area\len = Round(\area\len - (\box\size[2]-\thumb\len), #PB_Round_Nearest)
                  \area\end = \area\pos + (\area\len- (\box\size[2]-\thumb\len))
                  \thumb\len = \box\size[2] 
                EndIf
              Else
                If (\thumb\len < \box\size[3]) And (\type <> #PB_GadgetType_ProgressBar)
                  \area\len = Round(\area\len - (\box\size[3]-\thumb\len), #PB_Round_Nearest)
                  \area\end = \area\pos + (\height[2]-\box\size[3]) 
                  \thumb\len = \box\size[3]
                EndIf
              EndIf
            Else
              \area\end = \area\pos + (\height[2]-\area\len)
              \thumb\len = \area\len 
            EndIf
          EndIf
          
          ;           If \area\len > 0 And \type <> #PB_GadgetType_Panel
          ;             If _scroll_in_stop_(*this) And (\type = #PB_GadgetType_ScrollBar)
          ;               SetState(*this, \max)
          ;             EndIf
          ;             
          ;             \thumb\pos = _thumb_pos_(*this, \page\pos)
          ;           EndIf
          If \area\len > 0 And \type <> #PB_GadgetType_Panel
            \thumb\pos = _thumb_pos_(*this, _invert_(*this, \page\pos, \inverted))
            
            If \type <> #PB_GadgetType_TrackBar And \thumb\pos = \area\end
              SetState(*this, \max)
            EndIf
          EndIf
          
          Select \type
            Case #PB_GadgetType_Window
              \box\x = \x[2]
              \box\y = \y+\bs
              \box\width = \width[2]
              \box\height = \tabHeight
              
              \box\width[1] = \box\size
              \box\width[2] = \box\size
              \box\width[3] = \box\size
              
              \box\height[1] = \box\size
              \box\height[2] = \box\size
              \box\height[3] = \box\size
              
              \box\x[1] = \x[2]+\width[2]-\box\width[1]-5
              \box\x[2] = \box\x[1]-Bool(Not \box\hide[2]) * \box\width[2]-5
              \box\x[3] = \box\x[2]-Bool(Not \box\hide[3]) * \box\width[3]-5
              
              \box\y[1] = \y+\bs+(\tabHeight-\box\size)/2
              \box\y[2] = \box\y[1]
              \box\y[3] = \box\y[1]
              
            Case #PB_GadgetType_Panel
              \page\len = \width[2]-2
              
              If _scroll_in_stop_(*this)
                If \max < \min : \max = \min : EndIf
                
                If \max > \max-\page\len
                  If \max > \page\len
                    \max = \max-\page\len
                  Else
                    \max = \min 
                  EndIf
                EndIf
                
                \page\pos = \max
                \thumb\pos = _thumb_pos_(*this, \page\pos)
              EndIf
              
              \box\width[1] = \box\size : \box\height[1] = \tabHeight-1-4
              \box\width[2] = \box\size : \box\height[2] = \box\height[1]
              
              \box\x[1] = \x[2]+1
              \box\y[1] = \y[2]-\tabHeight+\bs+2
              \box\x[2] = \x[2]+\width[2]-\box\width[2]-1
              \box\y[2] = \box\y[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \box\y[1] = \y[2]+\height[2]/2+Bool(\height[2]%2) : \box\height[1] = \height[2]/2 : \box\width[1] = \box\size[2] : \box\x[1] = \x[2]+\width[2]-\box\size[2] ; Top button coordinate
                \box\y[2] = \y[2] : \box\height[2] = \height[2]/2 : \box\width[2] = \box\size[2] : \box\x[2] = \x[2]+\width[2]-\box\size[2]                                 ; Bottom button coordinate
              Else
                \box\y[1] = \y[2] : \box\height[1] = \height[2] : \box\width[1] = \box\size[2]/2 : \box\x[1] = \x[2]+\width[2]-\box\size[2]                                 ; Left button coordinate
                \box\y[2] = \y[2] : \box\height[2] = \height[2] : \box\width[2] = \box\size[2]/2 : \box\x[2] = \x[2]+\width[2]-\box\size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \box\size
                  \box\x[1] = \x[2] + Lines : \box\y[1] = \y[2] : \box\width[1] = \width - Lines : \box\height[1] = \box\size[1]                         ; Top button coordinate on scroll bar
                  \box\x[2] = \x[2] + Lines : \box\width[2] = \width - Lines : \box\height[2] = \box\size[2] : \box\y[2] = \y[2]+\height[2]-\box\size[2] ; (\area\pos+\area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \box\x[3] = \x[2] + Lines : \box\width[3] = \width - Lines : \box\y[3] = \thumb\pos : \box\height[3] = \thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \box 
                If \box\size
                  \box\x[1] = \x[2] : \box\y[1] = \y[2] + Lines : \box\height[1] = \height - Lines : \box\width[1] = \box\size[1]                        ; Left button coordinate on scroll bar
                  \box\y[2] = \y[2] + Lines : \box\height[2] = \height - Lines : \box\width[2] = \box\size[2] : \box\x[2] = \x[2]+\width[2]-\box\size[2] ; (\area\pos+\area\len)  ; Right button coordinate on scroll bar
                EndIf
                \box\y[3] = \y[2] + Lines : \box\height[3] = \height - Lines : \box\x[3] = \thumb\pos : \box\width[3] = \thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        ; set clip coordinate
        If Not IsRoot(*this) And \parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \parent\scroll 
            If \parent\scroll\v : clip_v = Bool(\parent\width=\parent\width[#_c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\parent\scroll\v\width : EndIf
            If \parent\scroll\h : clip_h = Bool(\parent\height=\parent\height[#_c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \parent\x[#_c_4]+Bool(\parent\x[#_c_4]<\parent\x+\parent\bs)*\parent\bs
          clip_y = \parent\y[#_c_4]+Bool(\parent\y[#_c_4]<\parent\y+\parent\bs)*(\parent\bs+\parent\tabHeight) 
          clip_width = ((\parent\x[#_c_4]+\parent\width[#_c_4])-Bool((\parent\x[#_c_4]+\parent\width[#_c_4])>(\parent\x[2]+\parent\width[2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#_c_4]+\parent\height[#_c_4])-Bool((\parent\y[#_c_4]+\parent\height[#_c_4])>(\parent\y[2]+\parent\height[2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#_c_4] = clip_x : Else : \x[#_c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#_c_4] = clip_y : Else : \y[#_c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#_c_4] = clip_width - \x[#_c_4] : Else : \width[#_c_4] = \width - (\x[#_c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#_c_4] = clip_height - \y[#_c_4] : Else : \height[#_c_4] = \height - (\y[#_c_4]-\y) : EndIf
        
        ; Resize scrollbars
        If \scroll And \scroll\v And \scroll\h
          Resizes(\scroll, 0,0, \width[2],\height[2])
        EndIf
        
        ; Resize childrens
        If ListSize(\childrens())
          If \type = #PB_GadgetType_Splitter
            Resize_Splitter(*this)
          Else
            ForEach \childrens()
              If \childrens()\align
                If \childrens()\align\horizontal
                  x = (\width[2] - (\childrens()\align\x+\childrens()\width))/2
                ElseIf \childrens()\align\right And Not \childrens()\align\left
                  x = \width[2] - \childrens()\align\x
                Else
                  If \x[2]
                    x = (\childrens()\x-\x[2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \childrens()\align\Vertical
                  y = (\height[2] - (\childrens()\align\y+\childrens()\height))/2 
                ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                  y = \height[2] - \childrens()\align\y
                Else
                  If \y[2]
                    y = (\childrens()\y-\y[2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \childrens()\align\top And \childrens()\align\bottom
                  Height = \height[2] - \childrens()\align\y
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \childrens()\align\left And \childrens()\align\right
                  Width = \width[2] - \childrens()\align\x
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\childrens(), x, y, Width, Height)
              Else
                Resize(\childrens(), (\childrens()\x-\x[2]) + Change_x, (\childrens()\y-\y[2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        ; anchors widgets
        If \root And \root\anchor And \root\anchor\widget = *this
          Resize_Anchors(*this)
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v), iHeight = Y(\h)
      ;;Protected iWidth = X(\v)-(\v\width-\v\radius/2)+1, iHeight = Y(\h)-(\h\height-\h\radius/2)+1
      Static hPos, vPos : vPos = \v\page\pos : hPos = \h\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\page\pos+iWidth 
        ScrollArea_Width=\h\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\page\pos And
             ScrollArea_Width=\h\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\page\pos+iHeight
        ScrollArea_Height=\v\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\page\pos And
             ScrollArea_Height=\v\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\radius And \h\radius)*(\v\box\size[2]/4+1)) ; #PB_Ignore, \h) 
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\radius And \h\radius)*(\v\box\size[2]/4+1), #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  
  Procedure.i Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
    With *Scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\radius And \h\radius)*(\v\box\size/4+1), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\v\radius And \h\radius)*(\h\box\size/4+1))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  ;- STRING_EDITABLE
  Procedure String_Remove(*this._S_widget)
    With *this
      If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
      \text\string.s[1] = RemoveString(\text\string.s[1], \text[2]\string.s, #PB_String_CaseSensitive, \text\pos+\text\caret, 1)
      \text\len = Len(\text\string.s[1])
    EndWith
  EndProcedure
  
  Procedure String_SelLimits(*this._S_widget)
    Protected i, char.i
    
    Macro _string_is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *this
      char = Asc(Mid(\text\string.s[1], \text\caret + 1, 1))
      If _string_is_selection_end_(char)
        \text\caret + 1
        \text[2]\len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \text\caret To 1 Step - 1
          char = Asc(Mid(\text\string.s[1], i, 1))
          If _string_is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \text\caret To \text\len
          char = Asc(Mid(\text\string.s[1], i, 1))
          If _string_is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret = i - 1
        \text[2]\len = \text\caret[1] - \text\caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure String_Caret(*this._S_widget, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      If \scroll
        X = (\text\x+\scroll\x)
      Else
        X = \text\x
      EndIf
      
      Len = \text\len
      FontID = \text\fontID
      String.s = \text\string.s[1]
      
      If \root\canvas\gadget And StartDrawing(CanvasOutput(\root\canvas\gadget)) 
        If FontID : DrawingFont(FontID) : EndIf
        
        For i = 0 To Len
          CursorX = X + TextWidth(Left(String.s, i))
          Distance = (\mouse\x-CursorX)*(\mouse\x-CursorX)
          
          ; Получаем позицию коpректора
          If MinDistance > Distance 
            MinDistance = Distance
            Position = i
          EndIf
        Next
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure String_SelectionText(*this._S_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *this
      If Caret <> *this\text\caret Or Line <> *this\index[#Entered] Or (*this\text\caret[1] >= 0 And Caret1 <> *this\text\caret[1])
        \text[2]\string.s = ""
        
        If *this\index[#Selected] = *this\index[#Entered]
          If *this\text\caret[1] > *this\text\caret 
            ; |<<<<<< to left
            Position = *this\text\caret
            \text[2]\len = (*this\text\caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *this\text\caret[1]
            \text[2]\len = (*this\text\caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *this\text\caret > *this\text\caret[1]
              ; <<<<<|
              Position = *this\text\caret[1]
              \text[2]\len = \text\len-Position
            Else
              ; >>>>>|
              Position = 0
              \text[2]\len = *this\text\caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *this\text\caret[1] > *this\text\caret 
              ; |<<<<<< to left
              Position = *this\text\caret
              \text[2]\len = (*this\text\caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *this\text\caret[1]
              \text[2]\len = (*this\text\caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *this\index[#Entered] > *this\index[#Selected]
              ; <<<<<|
              Position = *this\text\caret[1]
              \text[2]\len = \text\len-Position
            Else
              ; >>>>>|
              Position = 0
              \text[2]\len = *this\text\caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \text[1]\string.s = Left(*this\text\string.s[1], \text\pos+Position) : \text[1]\change = #True
        If \text[2]\len > 0
          \text[2]\string.s = Mid(\text\string.s[1], 1+\text\pos+Position, \text[2]\len) : \text[2]\change = #True
        EndIf
        \text[3]\string.s = Trim(Right(*this\text\string.s[1], *this\text\len-(\text\pos+Position + \text[2]\len)), #LF$) : \text[3]\change = #True
        
        Line = *this\index[#Entered]
        Caret = *this\text\caret
        Caret1 = *this\text\caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure String_ToLeft(*this._S_widget)
    Protected Repaint
    
    With *this
      If \text[2]\len
        If \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf  
      ElseIf \text\caret[1] > 0 
        \text\caret - 1 
      EndIf
      
      If \text\caret[1] <> \text\caret
        \text\caret[1] = \text\caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToRight(*this._S_widget)
    Protected Repaint
    
    With *this
      If \text[2]\len 
        If \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf
      ElseIf \text\caret[1] < \text\len
        \text\caret[1] + 1 
      EndIf
      
      If \text\caret <> \text\caret[1] 
        \text\caret = \text\caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToDelete(*this._S_widget)
    Protected Repaint
    
    With *this
      If \text\caret[1] < \text\len
        If \text[2]\len 
          String_Remove(*this)
        Else
          \text\string.s[1] = Left(\text\string.s[1], \text\pos+\text\caret) + Mid(\text\string.s[1],  \text\pos+\text\caret + 2)
          \text\len = Len(\text\string.s[1]) 
        EndIf
        
        \text\change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToInput(*this._S_widget)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *this
      If \keyboard\input
        Chr.s = Text_Make(*this, Chr(\keyboard\input))
        
        If Chr.s
          If \text[2]\len 
            String_Remove(*this)
          EndIf
          
          \text\caret + 1
          ; \items()\text\string.s[1] = \items()\text[1]\string.s + Chr(\keyboard\input) + \items()\text[3]\string.s ; сним не выравнивается строка при вводе слов
          \text\string.s[1] = InsertString(\text\string.s[1], Chr.s, \text\pos+\text\caret)
          \text\len = Len(\text\string.s[1]) 
          \text\caret[1] = \text\caret 
          \text\change =- 1
        Else
          ;\default = *this
        EndIf
        
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToBack(*this._S_widget)
    Protected Repaint, String.s 
    
    If *this\keyboard\input : *this\keyboard\input = 0
      String_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    
    With *this
      \keyboard\input = 65535
      
      If \text[2]\len
        If \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf  
        String_Remove(*this)
        
      ElseIf \text\caret[1] > 0 
        \text\string.s[1] = Left(\text\string.s[1], \text\pos+\text\caret - 1) + Mid(\text\string.s[1],  \text\pos+\text\caret + 1)
        \text\len = Len(\text\string.s[1])  
        \text\caret - 1 
      EndIf
      
      If \text\caret[1] <> \text\caret
        \text\caret[1] = \text\caret 
        \text\change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_Editable(*this._S_widget, EventType.i, mouse_x.i, mouse_y.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *this
      *this\index[#Entered] = 0
      
      With *this
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If \root\canvas\gadget And #PB_Cursor_Default = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
            EndIf
            
            If *this\text\editable And *this\drag[1] : *this\drag[1] = 0
              If \text\caret[2] > 0 And Not Bool(\text\caret[2] < *this\text\caret + 1 And *this\text\caret + 1 < \text\caret[2] + \text[2]\len)
                
                *this\text\string.s[1] = RemoveString(*this\text\string.s[1], \text[2]\string.s, #PB_String_CaseSensitive, \text\caret[2], 1)
                
                If \text\caret[2] > *this\text\caret 
                  \text\caret[2] = *this\text\caret 
                  *this\text\caret[1] = *this\text\caret + \text[2]\len
                Else
                  \text\caret[2] = (*this\text\caret-\text[2]\len)
                  *this\text\caret[1] = \text\caret[2]
                EndIf
                
                *this\text\string.s[1] = InsertString(*this\text\string.s[1], \text[2]\string.s, \text\pos+\text\caret[2] + 1)
                *this\text\len = Len(*this\text\string.s[1])
                \text\string.s[1] = InsertString(\text\string.s[1], \text[2]\string.s, \text\pos+\text\caret[2] + 1)
                \text\len = Len(\text\string.s[1])
                
                *this\text\change =- 1
                \text\caret[2] = 0
                Repaint =- 1
              EndIf
            Else
              Repaint =- 1
              \text\caret[2] = 0
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            Caret = String_Caret(*this)
            
            If \text\caret[1] =- 1 : \text\caret[1] = 0
              *this\text\caret = 0
              *this\text\caret[1] = \text\len
              \text[2]\len = \text\len
              Repaint =- 1
            Else
              Repaint = 1
              
              If \text[2] And \text[2]\len
                If *this\text\caret[1] > *this\text\caret : *this\text\caret[1] = *this\text\caret : EndIf
                
                If *this\text\caret[1] < Caret And Caret < *this\text\caret[1] + \text[2]\len
                  SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  \text\caret[2] = *this\text\caret[1] + 1
                Else
                  Repaint =- 1
                EndIf
              Else
                Repaint =- 1
              EndIf
              
              *this\text\caret = Caret
              *this\text\caret[1] = *this\text\caret
            EndIf 
            
          Case #PB_EventType_LeftDoubleClick 
            \text\caret[1] =- 1 ; Запоминаем что сделали двойной клик
            String_SelLimits(*this)    ; Выделяем слово
            Repaint =- 1
            
          Case #PB_EventType_MouseMove
            If *this\mouse\buttons & #PB_Canvas_LeftButton 
              Caret = String_Caret(*this)
              If *this\text\caret <> Caret
                
                If \text\caret[2] ; *this\cursor <> GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
                  If \text\caret[2] < Caret + 1 And Caret + 1 < \text\caret[2] + \text[2]\len
                    SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  Else
                    \text[1]\string.s = Left(*this\text\string.s[1], \text\pos+*this\text\caret) : \text[1]\change = #True
                  EndIf
                  
                  *this\text\caret[1] = Caret
                  Repaint = 1
                Else
                  Repaint =- 1
                EndIf
                
                *this\text\caret = Caret
              EndIf
            EndIf
        EndSelect
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          Control = Bool(*this\keyboard\key[1] & #PB_Canvas_Command)
        CompilerElse
          Control = Bool(*this\keyboard\key[1] & #PB_Canvas_Control)
        CompilerEndIf
        
        Select EventType
          Case #PB_EventType_Input
            If Not Control
              Repaint = String_ToInput(*this)
            EndIf
            
          Case #PB_EventType_KeyUp
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *this\keyboard\key
              Case #PB_Shortcut_Home : \text[2]\string.s = "" : \text[2]\len = 0 : *this\text\caret = 0 : *this\text\caret[1] = *this\text\caret : Repaint = #True 
              Case #PB_Shortcut_End : \text[2]\string.s = "" : \text[2]\len = 0 : *this\text\caret = \text\len : *this\text\caret[1] = *this\text\caret : Repaint = #True 
                
              Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = String_ToLeft(*this) ; Ok
              Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = String_ToRight(*this) ; Ok
              Case #PB_Shortcut_Back : Repaint = String_ToBack(*this)
              Case #PB_Shortcut_Delete : Repaint = String_ToDelete(*this)
                
              Case #PB_Shortcut_A
                If Control
                  *this\text\caret = 0
                  *this\text\caret[1] = \text\len
                  \text[2]\len = \text\len
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_X
                If Control And \text[2]\string.s 
                  SetClipboardText(\text[2]\string.s)
                  String_Remove(*this)
                  *this\text\caret[1] = *this\text\caret
                  \text\len = Len(\text\string.s[1])
                  Repaint = #True 
                EndIf
                
              Case #PB_Shortcut_C
                If Control And \text[2]\string.s 
                  SetClipboardText(\text[2]\string.s)
                EndIf
                
              Case #PB_Shortcut_V
                If Control
                  Protected ClipboardText.s = GetClipboardText()
                  
                  If ClipboardText.s
                    If \text[2]\string.s
                      String_Remove(*this)
                    EndIf
                    
                    Select #True
                      Case *this\text\lower : ClipboardText.s = LCase(ClipboardText.s)
                      Case *this\text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                      Case *this\text\Numeric 
                        If Val(ClipboardText.s)
                          ClipboardText.s = Str(Val(ClipboardText.s))
                        EndIf
                    EndSelect
                    
                    \text\string.s[1] = InsertString(\text\string.s[1], ClipboardText.s, *this\text\caret + 1)
                    *this\text\caret + Len(ClipboardText.s)
                    *this\text\caret[1] = *this\text\caret
                    \text\len = Len(\text\string.s[1])
                    Repaint = #True
                  EndIf
                EndIf
                
            EndSelect 
            
        EndSelect
        
        If Repaint =- 1
          String_SelectionText(*this)
        EndIf
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, Size.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7, Parent.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \x =- 1
      \y =- 1
      \type = Type
      \parent = Parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      \radius = Radius
      \ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      \box = AllocateStructure(_S_box)
      \box\size[3] = SliderLen ; min thumb size
      
      \box\arrow_size[1] = 4
      \box\arrow_size[2] = 4
      \box\arrow_type[1] =- 1 ; -1 0 1
      \box\arrow_type[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \color\state = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      
      \color[1] = def_colors
      \color[2] = def_colors
      \color[3] = def_colors
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If Size < 21
          \box\size = Size - 1
        Else
          \box\size = 17
        EndIf
        
        If \Vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *this._S_widget, Size
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Vertical)
    
    If Vertical
      Size = width
    Else
      Size =  height
    EndIf
    
    *this = Bar(#PB_GadgetType_ScrollBar, Size, Min, Max, PageLength, Flag|Vertical, Radius)
    _set_last_parameters_(*this, #PB_GadgetType_ScrollBar, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth ; |(Bool(#PB_Vertical) * #PB_Bar_Inverted)
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Smooth|Vertical|#PB_Bar_NoButtons, 0)
    _set_last_parameters_(*this, #PB_GadgetType_ProgressBar, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_TrackBar, 0, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
    _set_last_parameters_(*this, #PB_GadgetType_TrackBar, Flag)
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar._S_widget, *this._S_widget, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    
    *this = Bar(0, 0, 0, Max, 0, Auto|Vertical|#PB_Bar_NoButtons, 0, 7)
    *this\class = #PB_Compiler_Procedure
    
    _set_last_parameters_(*this, #PB_GadgetType_Splitter, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    With *this
      \thumb\len = 7
      \splitter = AllocateStructure(_S_splitter)
      \splitter\first = First
      \splitter\second = Second
      
      If \splitter\first
        \type[1] = \splitter\first\type
      EndIf
      
      If \splitter\second
        \type[2] = \splitter\second\type
      EndIf
      
      SetParent(\splitter\first, *this)
      SetParent(\splitter\second, *this)
      
      If \Vertical
        \cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _set_last_parameters_(*this, #PB_GadgetType_Spin, Flag) 
    
    ;Flag | Bool(Not Flag&#PB_Vertical) * (#PB_Bar_Inverted)
    
    With *this
      \x =- 1
      \y =- 1
      
      \fs = 1
      \bs = 2
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      
      ;\radius = Radius
      \ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Vertical = Bool(Not Flag&#PB_Vertical=#PB_Vertical)
      \box = AllocateStructure(_S_box)
      
      \text\string.s[1] = Str(Min)
      \text\change = 1
      
      \box\arrow_size[1] = 4
      \box\arrow_size[2] = 4
      \box\arrow_type[1] =- 1 ; -1 0 1
      \box\arrow_type[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \text\editable = 1
      
      \color[1] = def_colors
      \color[2] = def_colors
      \color[3] = def_colors
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      
      \box\size[2] = 17
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      ;\page\len = 10
      \scrollstep = 1
      
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Image, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \image = AllocateStructure(_S_image)
      Set_Image(*this, Image)
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Button, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      \text\align\horizontal = 1
      
      \image = AllocateStructure(_S_image)
      \image\align\Vertical = 1
      \image\align\horizontal = 1
      
      SetText(*this, Text.s)
      Set_Image(*this, Image)
      
      ;       ; временно из-за этого (контейнер \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget))
      ;       If \parent And \parent\root\anchor[1]
      ;         x+\parent\fs
      ;         y+\parent\fs
      ;       EndIf
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_HyperLink, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \color\front[1] = Color
      \color\front[2] = Color
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\multiLine = 1
      \text\x[2] = 5
      
      \image = AllocateStructure(_S_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      \flag\lines = Bool(Flag&#PB_HyperLink_Underline=#PB_HyperLink_Underline)
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Frame, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \container =- 2
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \tabHeight = 16
      
      \bs = 1
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\string.s[1] = Text.s
      \text\string.s = Text.s
      \text\change = 1
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Text, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\x[2] = 3
      \text\y[2] = 0
      
      Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
      
      If Bool(Flag&#PB_Text_WordWrap)
        Flag&~#PB_Text_MultiLine
        \text\multiLine =- 1
      EndIf
      
      If Bool(Flag&#PB_Text_MultiLine)
        Flag&~#PB_Text_WordWrap
        \text\multiLine = 1
      EndIf
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ComboBox, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      \text\height = 20
      
      \image = AllocateStructure(_S_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\height = Height
      \box\width = 15
      \box\arrow_size = 4
      \box\arrow_type =- 1
      
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \popup = Popup(*this, 0,0,0,0)
      OpenList(\popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) 
      \popup\childrens()\scroll\h\height=0
      CloseList()
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_CheckBox, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \color\frame = $FF7E7E7E
      
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      \text\multiLine = 1
      \text\x[2] = 25
      
      \radius = 3
      \box = AllocateStructure(_S_box)
      \box\height = 15
      \box\width = 15
      \box\threeState = Bool(Flag&#PB_CheckBox_ThreeState=#PB_CheckBox_ThreeState)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Option, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \color\frame = $FF7E7E7E
      
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      \text\multiLine = 1
      \text\x[2] = 25
      
      \box = AllocateStructure(_S_box)
      \box\height = 15
      \box\width = 15
      \radius = 0
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_String, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \scroll = AllocateStructure(_S_scroll) 
      \cursor = #PB_Cursor_IBeam
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text[1] = AllocateStructure(_S_text)
      \text[2] = AllocateStructure(_S_text)
      \text[3] = AllocateStructure(_S_text)
      \text\editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      \text\align\Vertical = 1
      
      \text\editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \text\multiLine = (Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
      \text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \text\lower = Bool(Flag&#PB_Text_LowerCase)
      \text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \text\pass = Bool(Flag&#PB_Text_Password)
      
      ;\text\align\Vertical = Bool(Not Flag&#PB_Text_Top)
      \text\align\horizontal = Bool(Flag&#PB_Text_Center)
      \text\align\right = Bool(Flag&#PB_Text_Right)
      ;\text\align\bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i IPAddress(X.l,Y.l,Width.l,Height.l)
    Protected Text.s="0.0.0.0", Flag.i=#PB_Text_Center
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_IPAddress, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \scroll = AllocateStructure(_S_scroll) 
      \cursor = #PB_Cursor_IBeam
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text[1] = AllocateStructure(_S_text)
      \text[2] = AllocateStructure(_S_text)
      \text[3] = AllocateStructure(_S_text)
      \text\editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      \text\align\Vertical = 1
      
      \text\editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \text\multiLine = (Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
      \text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \text\lower = Bool(Flag&#PB_Text_LowerCase)
      \text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \text\pass = Bool(Flag&#PB_Text_Password)
      
      ;\text\align\Vertical = Bool(Not Flag&#PB_Text_Top)
      \text\align\horizontal = Bool(Flag&#PB_Text_Center)
      \text\align\right = Bool(Flag&#PB_Text_Right)
      ;\text\align\bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Editor, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_IBeam
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      \image = AllocateStructure(_S_image)
      
      
      \text = AllocateStructure(_S_text)
      \text[1] = AllocateStructure(_S_text)
      \text[2] = AllocateStructure(_S_text)
      \text[3] = AllocateStructure(_S_text)
      \text\editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      ;\text\align\Vertical = 1
      
      ;       \text\editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \text\multiLine = 1;(Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
                         ;\text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \text\lower = Bool(Flag&#PB_Text_LowerCase)
      \text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \text\pass = Bool(Flag&#PB_Text_Password)
      
      ;       ;\text\align\Vertical = Bool(Not Flag&#PB_Text_Top)
      ;       \text\align\horizontal = Bool(Flag&#PB_Text_Center)
      ;       \text\align\right = Bool(Flag&#PB_Text_Right)
      ;       ;\text\align\bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      
      \color = def_colors
      \color\fore[0] = 0
      
      \margin\width = 100;Bool(Flag&#PB_Flag_Numeric)
      \margin\color\back = $C8F0F0F0 ; \color\back[0] 
      
      \color\alpha = 255
      \color = def_colors
      \color\fore[0] = 0
      \color\fore[1] = 0
      \color\fore[2] = 0
      \color\back[0] = \color\back[1]
      \color\frame[0] = \color\frame[1]
      ;\color\back[1] = \color\back[0]
      
      
      
      If \text\editable
        \color\back[0] = $FFFFFFFF 
      Else
        \color\back[0] = $FFF0F0F0  
      EndIf
      
      
      \interact = 1
      \text\caret[1] =- 1
      \index[#Entered] =- 1
      \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
      \flag\lines = Bool(flag&#PB_Flag_NoLines)
      \flag\fullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
      ;\flag\alwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12 ; Это еще будет размер чек бокса
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      
      ;\text\Vertical = Bool(Flag&#PB_Flag_Vertical)
      
      
      SetText(*this, "")
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;- 
  ;- Lists
  Procedure.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Tree, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      
      \image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Bool(\flag\buttons Or \flag\lines) * Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListView, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      
      
      \text = AllocateStructure(_S_text)
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        
        \text\height = TextHeight("A")
        
        StopDrawing()
      EndIf
      
      \sublevellen = 0
      \flag\lines = 0
      \flag\buttons = 0
      
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      \tabHeight = 24
      
      \image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      AddColumn(*this, 0, FirstColumnTitle, FirstColumnWidth)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      \tabHeight = 24
      
      \image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      AddColumn(*this, 0, "Name", 200)
      AddColumn(*this, 0, "Size", 100)
      AddColumn(*this, 0, "Type", 100)
      AddColumn(*this, 0, "Modified", 100)
      
      If Directory.s = ""
        Directory.s = GetHomeDirectory() ; Lists all files and folder in the home directory
      EndIf
      Protected Size$, Type$, Modified$
      
      If ExamineDirectory(0, Directory.s, "*.*")  
        
        While NextDirectoryEntry(0)
          If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
            Type$ = "[Directory] "
            Size$ = "" ; A directory doesn't have a size
            Modified$ = FormatDate("%mm/%dd/%yyyy", DirectoryEntryDate(0, #PB_Date_Modified))
            AddItem(*this, -1, DirectoryEntryName(0) +#LF$+ Size$ +#LF$+ Type$ +#LF$+ Modified$)
          EndIf
        Wend
        FinishDirectory(0)
      EndIf
      
      If ExamineDirectory(0, Directory.s, "*.*")  
        While NextDirectoryEntry(0)
          If DirectoryEntryType(0) = #PB_DirectoryEntry_File
            Type$ = "[File] "
            Size$ = " (Size: " + DirectoryEntrySize(0) + ")"
            Modified$ = FormatDate("%mm/%dd/%yyyy", DirectoryEntryDate(0, #PB_Date_Modified))
            AddItem(*this, -1, DirectoryEntryName(0) +#LF$+ Size$ +#LF$+ Type$ +#LF$+ Modified$)
          EndIf
        Wend
        
        FinishDirectory(0)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Property(X.l,Y.l,Width.l,Height.l, SplitterPos.i = 80, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Property, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \index[#Entered] =- 1
      \index[#Selected] =- 1
      
      \box = AllocateStructure(_S_box)
      \thumb\len = 7
      \box\size[3] = 7 ; min thumb size
      SetAttribute(*this, #PB_Bar_Maximum, Width) 
      
      ;\container = 1
      
      
      \cursor = #PB_Cursor_LeftRight
      SetState(*this, SplitterPos)
      
      
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \image = AllocateStructure(_S_image)
      
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- Containers
  Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ScrollArea, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \fs = 1
      \bs = 2
      
      ; Background image
      \image[1] = AllocateStructure(_S_image)
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,ScrollAreaHeight,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *this)
      ;       Resize(\scroll\v, #PB_Ignore,#PB_Ignore,Size,#PB_Ignore)
      ;       Resize(\scroll\h, #PB_Ignore,#PB_Ignore,#PB_Ignore,Size)
      
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Container, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \index[#Entered] =- 1
      \index[#Selected] = 0
      
      \color = def_colors
      \color\alpha = 255
      \color\fore = 0
      \color\back = $FFF6F6F6
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Panel(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Panel, Flag)
    
    With *this
      \x =- 1
      \y =- 1
      \index[#Entered] =- 1
      \index[#Selected] = 0
      
      \container = 1
      
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \box = AllocateStructure(_S_box)
      \box\size = 13 
      
      \box\arrow_size[1] = 6
      \box\arrow_size[2] = 6
      \box\arrow_type[1] =- 1
      \box\arrow_type[2] =- 1
      
      \box\color[1] = def_colors
      \box\color[2] = def_colors
      
      \box\color[1]\alpha = 255
      \box\color[2]\alpha = 255
      
      \page\len = Width
      
      \tabHeight = 25
      \scrollstep = 10
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i CloseList()
    If Root()\_open\parent And Root()\_open\parent\root = Root()\_open\root
      Root()\_open = Root()\_open\parent
    Else
      Root()\_open = Root()
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._S_widget, Item.l=0)
    Protected result.i
    
    With *this
      If *this > 0
        If \Type = #PB_GadgetType_Window
          \Window = *this
        EndIf
        
        Root()\_open = *this
        Root()\_open\o_i = Item
        
      EndIf
    EndWith
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *Widget._S_widget=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    
    If *Widget 
      *event\widget = *this
      *this\type = #PB_GadgetType_Window
      *this\class = #PB_Compiler_Procedure
      
      SetParent(*this, *Widget)
      
      ; _set_auto_size_
      If Bool(Flag & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
        *this\align = AllocateStructure(_S_align)
        *this\align\autoSize = 1
        *this\align\left = 1
        *this\align\top = 1
        *this\align\right = 1
        *this\align\bottom = 1
      EndIf
      
      If Bool(Flag & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget) And *this\root And Not *this\root\anchor
        
        AddAnchors(*this\root)
        SetAnchors(*this)
        
      EndIf
    Else
      OpenList(Root())
      
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag) 
    EndIf
    
    With *this
      \x =- 1
      \y =- 1
      \index[#Entered] =- 1
      \index[#Selected] = 0
      
      \container =- 1
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      If Not flag&#PB_Window_BorderLess
        \tabHeight = 23
      EndIf
      
      \image = AllocateStructure(_S_image)
      \image\x[2] = 5 ; padding 
      
      \text = AllocateStructure(_S_text)
      \text\align\horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\size = 12
      \box\color = def_colors
      \box\color\alpha = 255
      
      \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \flag\window\borderLess = Bool(Flag&#PB_Window_BorderLess)
      
      \fs = 1
      \bs = 1 ;Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \image[1] = AllocateStructure(_S_image)
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
      SetActive(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Open(Window.i, X.l,Y.l,Width.l,Height.l, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, Canvas.i=-1, *this._S_root = AllocateStructure(_S_root)
    
    If Root() And Active() 
      _set_active_state_(0)
    EndIf
    
    With *this
      Root() = *this
      \x =- 1
      \y =- 1
      \class = "Root"
      \root = Root()
      \window = Root()
      \event = AllocateStructure(_S_event)
      
      If Text.s
        \type =- 1
        \container =- 1
        \color = def_colors
        \color\fore = 0
        \color\back = $FFF0F0F0
        \color\alpha = 255
        \color[1]\alpha = 128
        \color[2]\alpha = 128
        \color[3]\alpha = 128
        
        \index[#Entered] =- 1
        \index[#Selected] = 0
        
        If Not flag&#PB_Window_BorderLess
          \tabHeight = 23
        EndIf
        
        \image = AllocateStructure(_S_image)
        \image\x[2] = 5 ; padding 
        
        \text = AllocateStructure(_S_text)
        \text\align\horizontal = 1
        
        \box = AllocateStructure(_S_box)
        \box\size = 12
        \box\color = def_colors
        \box\color\alpha = 255
        
        \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
        \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
        \flag\window\borderLess = Bool(Flag&#PB_Window_BorderLess)
        
        \fs = 1
        \bs = 1
        
        ; Background image
        \image[1] = AllocateStructure(_S_image)
        
        SetText(*this, Text.s)
        ;
        Width + \bs*2
        Height + \tabHeight + \bs*2
      Else
        \type = #PB_GadgetType_Root
        \container = #PB_GadgetType_Root
        
        \text = AllocateStructure(_S_text) ; без него в окнах вилетает ошибка
        
        \color\alpha = 255
      EndIf
      
      SetActive(*this)
      Resize(Root(), 0, 0, Width,Height)
      OpenList(Root())
      
      If Not IsWindow(Window) 
        If Text
          w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess, WindowID) 
          ;Root()\color\back = 0
        Else
          w = OpenWindow(Window, X,Y,Width,Height, "", Flag, WindowID) 
          Root()\color\back = $FFF0F0F0
        EndIf
        If Window =- 1 : Window = w : EndIf
        X = 0 : Y = 0
      Else
        Root()\color\back = $FFFFFFFF
      EndIf
      
      Root()\canvas\window = Window
      Root()\canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
      
      If IsGadget(Root()\canvas\gadget)
        SetGadgetData(Root()\canvas\gadget, Root())
        SetWindowData(Root()\canvas\window, Root()\canvas\gadget)
        BindGadgetEvent(Root()\canvas\gadget, @g_Callback())
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i _Open(Window.i, X.l,Y.l,Width.l,Height.l, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, Canvas.i=-1, *this._S_root = AllocateStructure(_S_root) 
    
    If Root() And Active()
      _set_active_state_(0)
    EndIf
    
    Root() = *this
    Root()\x =- 1
    Root()\y =- 1
    Root()\class = "Root"
    Root()\root = Root()
    Root()\color\alpha = 255
    Root()\type = #PB_GadgetType_Root
    Root()\container = #PB_GadgetType_Root
    Root()\event = AllocateStructure(_S_event)
    ;Root()\text = AllocateStructure(_S_text) ; без него в окнах вилетает ошибка
    
    OpenList(Root())
    
    If Text
      *this = Form(0,0,Width,Height, Text.s, Flag, Root())
      Width = Width(*this)
      Height = Height(*this)
    Else
      SetActive(Root())
    EndIf
    
    If Not IsWindow(Window) 
      If Text
        w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess, WindowID) 
        Root()\color\back = 0
      Else
        w = OpenWindow(Window, X,Y,Width,Height, "", Flag, WindowID) 
        Root()\color\back = $FFF0F0F0
      EndIf
      If Window =- 1 : Window = w : EndIf
      X = 0 : Y = 0
    Else
      Root()\color\back = $FFFFFFFF
    EndIf
    
    Root()\canvas\window = Window
    Root()\canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
    
    If IsGadget(Root()\canvas\gadget)
      SetGadgetData(Root()\canvas\gadget, Root())
      SetWindowData(Root()\canvas\window, Root()\canvas\gadget)
      BindGadgetEvent(Root()\canvas\gadget, @g_Callback())
    EndIf
    
    Resize(Root(), 0, 0, Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Create(Type.i, X.l,Y.l,Width.l,Height.l, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, parent_item.i=0)
    Protected Result
    
    If Type = #PB_GadgetType_Window
      Result = Form(X,Y,Width,Height, Text.s, Flag, Parent)
    Else
      If Parent
        OpenList(Parent, parent_item)
      EndIf
      
      Select Type
        Case #PB_GadgetType_Panel      : Result = Panel(X,Y,Width,Height, Flag)
        Case #PB_GadgetType_Container  : Result = Container(X,Y,Width,Height, Flag)
        Case #PB_GadgetType_ScrollArea : Result = ScrollArea(X,Y,Width,Height, Param_1, Param_2, Param_3, Flag)
        Case #PB_GadgetType_Button     : Result = Button(X,Y,Width,Height, Text.s, Flag)
        Case #PB_GadgetType_String     : Result = String(X,Y,Width,Height, Text.s, Flag)
        Case #PB_GadgetType_Text       : Result = Text(X,Y,Width,Height, Text.s, Flag)
      EndSelect
      
      If Parent
        CloseList()
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Free(*this._S_widget)
    Protected Result.i
    
    With *this
      If *this
        If \scroll
          If \scroll\v
            FreeStructure(\scroll\v) : \scroll\v = 0
          EndIf
          If \scroll\h
            FreeStructure(\scroll\h)  : \scroll\h = 0
          EndIf
          FreeStructure(\scroll) : \scroll = 0
        EndIf
        
        If \box : FreeStructure(\box) : \box = 0 : EndIf
        If \text : FreeStructure(\text) : \text = 0 : EndIf
        If \image : FreeStructure(\image) : \image = 0 : EndIf
        If \image[1] : FreeStructure(\image[1]) : \image[1] = 0 : EndIf
        
        ;         Active()\_gadget = 0
        ;         Active() = 0
        
        If \parent And ListSize(\parent\childrens()) : \parent\countItems - 1
          ChangeCurrentElement(\parent\childrens(), GetAdress(*this))
          Result = DeleteElement(\parent\childrens())
        EndIf
        
        ; FreeStructure(*this) 
        ClearStructure(*this, _S_widget) 
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure.i Post(eventtype.l, *this._S_widget, eventitem.l=#PB_All, *data=0)
    Protected result.i
    
    *event\widget = *this
    *event\data = *data
    *event\type = eventtype
    
    If Not Root()\event\bind
      AddElement(Root()\event\list())
      Root()\event\list() = AllocateStructure(_S_event)
      Root()\event\list()\widget = *this
      Root()\event\list()\type = eventtype
      Root()\event\list()\item = eventitem
      Root()\event\list()\data = *data
    EndIf
    
    If *this
      If *this\event And
       *this\root <> *this And 
       (*this\event\type = #PB_All Or
        *this\event\type = eventtype)
      
      result = *this\event\callback()
    EndIf
    
    If *this\window And 
       *this\window\event And 
       result <> #PB_Ignore And 
       *this\window <> *this And 
       *this\window <> *this\root And 
       (*this\window\event\type = #PB_All Or
        *this\window\event\type = eventtype)
      
      result = *this\window\event\callback()
    EndIf
    
    If *this\root And 
       *this\root\event And 
       result <> #PB_Ignore And 
       (*this\root\event\type = #PB_All Or 
        *this\root\event\type = eventtype) 
      
      result = *this\root\event\callback()
    EndIf
  EndIf
  
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Bind(*callback, *this._S_widget=#PB_All, eventtype.l=#PB_All)
    If *this = #PB_All
      *this = Root()
    EndIf
    
    If Not *this\event
      *this\event = AllocateStructure(_S_event)
    EndIf
    
    *this\event\bind = 1
    *this\event\type = eventtype
    *this\event\callback = *callback
    
    If ListSize(Root()\event\list()) 
      ForEach Root()\event\list()
        Post(Root()\event\list()\type, Root()\event\list()\widget, Root()\event\list()\item, Root()\event\list()\data)
      Next
      FreeStructure(Root()\event\list())
    EndIf
    
    ProcedureReturn *this\event
  EndProcedure
  
  Procedure.i Unbind(*callback, *this._S_widget=#PB_All, eventtype.l=#PB_All)
    If *this\event
      *this\event\type = 0
      *this\event\callback = 0
      FreeStructure(*this\event)
      *this\event = 0
    EndIf
    
    ProcedureReturn *this\event
  EndProcedure
  
  ;- 
  Procedure.i w_Events(*this._S_widget, EventType.i, EventItem.i=-1, EventData.i=0)
    Protected Result.i 
    
    With *this 
      If *this
        ; Scrollbar
        If \parent And 
           \parent\scroll 
          Select *this 
            Case \parent\scroll\v, 
                 \parent\scroll\h 
              *this = \parent
          EndSelect
        EndIf
        
        If \mouse\buttons And EventType = #PB_EventType_MouseMove
          If \from = 0 Or (\root\anchor And Not \container)
            ;Events_Anchors(*this, Root()\mouse\x, Root()\mouse\y)
            Resize(*this, Root()\mouse\x-\mouse\delta\x, Root()\mouse\y-\mouse\delta\y, #PB_Ignore, #PB_Ignore)
            Result = 1
          EndIf
        EndIf
        
        Post(EventType, *this, EventItem, EventData)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i From(*this._S_widget, mouse_x.i, mouse_y.i)
    Protected *Result._S_widget, Change.b, X.l,Y.l,Width.l,Height.l, parent_item.i
    Static *r._S_widget
    
    If Root()\mouse\x <> mouse_x
      Root()\mouse\x = mouse_x
      Change = 1
    EndIf
    
    If Root()\mouse\y <> mouse_y
      Root()\mouse\y = mouse_y
      Change = 1
    EndIf
    
    If Not *this
      *this = Root() ; GetGadgetData(EventGadget())
    EndIf
    
    If Change 
      With *this
        If *this And ListSize(\childrens()) ; \countItems ; Not Root()\mouse\buttons
          PushListPosition(\childrens())    ;
          LastElement(\childrens())         ; Что бы начать с последнего элемента
          Repeat                            ; Перебираем с низу верх
            If Not \childrens()\hide And _from_point_(mouse_x,mouse_y, \childrens(), [#_c_4])
              
              If ListSize(\childrens()\childrens())
                Root()\mouse\x = 0
                Root()\mouse\y = 0
                *Result = From(\childrens(), mouse_x, mouse_y)
                
                If Not *Result
                  *Result = \childrens()
                EndIf
              Else
                *Result = \childrens()
              EndIf
              
              Break
            EndIf
            
          Until PreviousElement(\childrens()) = #False 
          PopListPosition(\childrens())
        EndIf
      EndWith
      *r = *Result
    Else
      *Result = *r
    EndIf
    
    If *Result
      With *Result 
        \mouse\x = mouse_x
        \mouse\y = mouse_y
        
        If \scroll
          ; scrollbars events
          If \scroll\v And Not \scroll\v\hide And \scroll\v\type And _from_point_(mouse_x,mouse_y, \scroll\v)
            *Result = \scroll\v
          ElseIf \scroll\h And Not \scroll\h\hide And \scroll\h\type And _from_point_(mouse_x,mouse_y, \scroll\h)
            *Result = \scroll\h
          EndIf
        EndIf
        
        If \box 
          If _from_point_(mouse_x,mouse_y, \box, [#_c_3])
            \from = 3
          ElseIf _from_point_(mouse_x,mouse_y, \box, [#_c_2])
            \from = 2
          ElseIf _from_point_(mouse_x,mouse_y, \box, [#_c_1])
            \from = 1
          ElseIf _from_point_(mouse_x,mouse_y, \box, [#_c_0])
            \from = 0
          Else
            \from =- 1
          EndIf
        Else
          \from =- 1
        EndIf 
        
        If \from =- 1 And \type <> #PB_GadgetType_Editor
          ; Columns at point
          If ListSize(\columns())
            
            ForEach \columns()
              If \columns()\drawing
                If (mouse_x>=\columns()\x And mouse_x=<\columns()\x+\columns()\width+1 And 
                    mouse_y>=\columns()\y And mouse_y=<\columns()\y+\columns()\height)
                  
                  \index[#Entered] = \columns()\index
                  Break
                Else
                  \index[#Entered] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \columns()\items()
                If \columns()\items()\drawing
                  If (mouse_x>\x[2] And mouse_x=<\x[2]+\width[2] And 
                      mouse_y>\columns()\items()\y And mouse_y=<\columns()\items()\y+\columns()\items()\height)
                    \columns()\index[#Entered] = \columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          ElseIf ListSize(\items())
            
            ; items at point
            ForEach \items()
              If \items()\drawing
                If (mouse_x>\items()\x And mouse_x=<\items()\x+\items()\width And 
                    mouse_y>\items()\y And mouse_y=<\items()\y+\items()\height)
                  
                  \index[#Entered] = \items()\index
                  ; Debug " i "+\index[#Entered]+" "+ListIndex(\items())
                  Break
                Else
                  \index[#Entered] =- 1
                EndIf
              EndIf
            Next
            
          EndIf
        EndIf
        
      EndWith
    EndIf
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure.i Events(*this._S_widget, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *this > 0
      
      ;       *value\type = EventType
      ;       *value\this = *this
      
      With *this
        Protected canvas = \root\canvas\gadget
        Protected window = \root\canvas\window
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LostFocus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0  : Repaint | w_Events(*this, EventType, at)
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                  Repaint = ScrollPos(*this, (mouse_y-\thumb\len/2))
                Else
                  Repaint = ScrollPos(*this, (mouse_x-\thumb\len/2))
                EndIf
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ;             Debug "events() LeftClick "+\type +" "+ at +" "+ *this
            Select \type
              Case #PB_GadgetType_Button,
                   #PB_GadgetType_Tree, 
                   #PB_GadgetType_ListView, 
                   #PB_GadgetType_ListIcon
                
                If Not \root\drag
                  Repaint | w_Events(*this, EventType, \index[#Entered])
                EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonDown : Repaint | w_Events(*this, EventType, at)
            ;             Debug "events() LeftButtonDown "+\type +" "+ at +" "+ *this
            Select \type 
              Case #PB_GadgetType_Window
                If at = 1
                  Free(*this)
                  
                  If *this = \root
                    PostEvent(#PB_Event_CloseWindow, \root\canvas\window, *this)
                    ;Post(#PB_Event_CloseWindow, *this, EventItem, EventData)
                  EndIf
                EndIf
                
              Case #PB_GadgetType_ComboBox
                \box\checked ! 1
                
                If \box\checked
                  Display_Popup(*this, \popup)
                Else
                  HideWindow(\popup\root\canvas\window, 1)
                EndIf
                
              Case #PB_GadgetType_Option
                Repaint = SetState(*this, 1)
                
              Case #PB_GadgetType_CheckBox
                Repaint = SetState(*this, Bool(\box\checked=#PB_Checkbox_Checked) ! 1)
                
              Case #PB_GadgetType_Tree,
                   #PB_GadgetType_ListView
                Repaint = Set_State(*this, \items(), \index[#Entered]) 
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\columns(), 0)
                  Repaint = Set_State(*this, \columns()\items(), \columns()\index[#Entered]) 
                EndIf
                
              Case #PB_GadgetType_HyperLink
                If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                
              Case #PB_GadgetType_Panel
                Select at
                  Case 1 : \page\pos = PagePos(*this, (\page\pos - \scrollstep)) : Repaint = 1
                  Case 2 : \page\pos = PagePos(*this, (\page\pos + \scrollstep)) : Repaint = 1
                  Default
                    If \index[#Entered] >= 0
                      Repaint = SetState(*this, \index[#Entered])
                    EndIf
                EndSelect
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin, #PB_GadgetType_Splitter
                Select at
                  Case 1 : Repaint = SetState(*this, (\page\pos - \scrollstep)) ; Up button
                  Case 2 : Repaint = SetState(*this, (\page\pos + \scrollstep)) ; Down button
                  Case 3                                                        ; Thumb button
                    If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                      delta = mouse_y - \thumb\pos
                    Else
                      delta = mouse_x - \thumb\pos
                    EndIf
                EndSelect
                
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            w_Events(*this, EventType, *this\from)
            
            If delta
              If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                Repaint = ScrollPos(*this, (mouse_y-delta))
              Else
                Repaint = ScrollPos(*this, (mouse_x-delta))
              EndIf
            Else
              If lastat <> at
                If lastat > 0 
                  If lastat<4
                    \color[lastat]\state = 0
                  EndIf
                  
                EndIf
                
                If \max And ((at = 1 And _scroll_in_start_(*this)) Or (at = 2 And _scroll_in_stop_(*this)))
                  \color[at]\state = 0
                  
                ElseIf at>0 
                  
                  If at<4
                    \color[at]\state = 1
                    \color[at]\alpha = 255
                  EndIf
                  
                ElseIf at =- 1
                  \color[1]\state = 0
                  \color[2]\state = 0
                  \color[3]\state = 0
                  
                  \color[1]\alpha = 128
                  \color[2]\alpha = 128
                  \color[3]\alpha = 128
                EndIf
                
                Repaint = #True
                lastat = at
              EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \scrollstep = 1
                  Repaint + ((\max-\min) / 100)
                Else
                  Repaint + \scrollstep
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \scrollstep = 1
                  Repaint - ((\max-\min) / 100)
                Else
                  Repaint - \scrollstep
                EndIf
              EndIf
              
              Repaint = SetState(*this, (\page\pos + Repaint))
            EndIf  
            
          Case #PB_EventType_MouseEnter
            w_Events(*this, EventType, *this\from)
            ;             If Not Root()\mouse\buttons And IsGadget(canvas)
            ;               \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor)
            ;               ;             Debug "events() MouseEnter " +" "+ at +" "+ *this;+\type +" "+ \cursor[1]  +" "+ \cursor
            ;             EndIf
            
          Case #PB_EventType_MouseLeave
            w_Events(*this, EventType, *this\from)
            
            ;             If Not Root()\mouse\buttons And IsGadget(canvas)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
            ;               ;             Debug "events() MouseLeave " +" "+ at +" "+ *this;+\type +" "+ \cursor[1]  +" "+ \cursor
            ;             EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            
            \color\state = 0
            If at>0 And at<4
              \color[at]\state = 0
            EndIf
            
            If \type <> #PB_GadgetType_Panel 
              If ListSize(\columns())
                SelectElement(\columns(), 0)
              EndIf
              ForEach \items()
                If \items()\state = 1
                  \items()\state = 0
                EndIf
              Next
              \index[#Entered] =- 1
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            
            If EventType = #PB_EventType_MouseEnter
              If \type = #PB_GadgetType_ScrollBar
                If \parent And \parent\scroll And 
                   (\parent\scroll\v = *this Or *this = \parent\scroll\h)
                  
                  If ListSize(\parent\columns())
                    SelectElement(\parent\columns(), 0)
                  EndIf
                  ForEach \parent\items()
                    If \parent\items()\state = 1
                      \parent\items()\state = 0
                    EndIf
                  Next
                  \parent\index[#Entered] =- 1
                  
                EndIf
              EndIf
            EndIf
            
            Select \type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \color\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              Case #PB_GadgetType_Window
              Default
                
                If at>0 And at<4 And EventType<>#PB_EventType_MouseEnter
                  \color[at]\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
                EndIf
            EndSelect
        EndSelect
        
        If \text And \text[1] And \text[2] And \text[3] And \text\editable
          Select \type
            Case #PB_GadgetType_String
              Repaint | String_Editable(*this, EventType, mouse_x.i, mouse_y.i)
              
            Case #PB_GadgetType_Editor
              Repaint | Editor_Events(*this, EventType)
              
          EndSelect
        EndIf
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*this._S_widget, EventType.i, mouse_x.i=0, mouse_y.i=0)
    Protected repaint.i, Parent.i, Window.i, Canvas = EventGadget()
    
    With *this
      If Not Bool(*this And *this\root)
        ProcedureReturn
      EndIf
      
      Window = \window 
      Parent = \parent 
      Canvas = \root\canvas\gadget
      
      If Not mouse_x
        mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      EndIf
      If Not mouse_y
        mouse_y= GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
      EndIf
      
      ; anchors events
      If CallBack_Anchors(*this, EventType, \mouse\buttons, mouse_x,mouse_y)
        ProcedureReturn 1
      EndIf
      
      ; Enter/Leave mouse events
      If *event\enter <> *this
        If *event\enter <> Root()
          
          ;           If *event\enter = Parent
          ;             Debug "leave first"
          ;           Else
          ;             Debug "enter Parent"
          ;           EndIf
          
          repaint = 1
        EndIf
        
        If *event\enter And *event\enter <> Parent And *event\enter <> Window And *event\enter <> Root() 
          If *event\enter\mouse\buttons
            ;             Debug "selected out"
          Else
            Events(*event\enter, *event\enter\from, #PB_EventType_MouseLeave, mouse_x, mouse_y)
          EndIf
        EndIf
        
        If *this
          If (Not *event\enter Or (*event\enter And *event\enter\parent <> *this))
            ;             If Not *event\enter
            ;               Debug "enter first"
            ;             EndIf
            ;             
            ;             If (*event\enter And *event\enter\parent <> *this)
            ;               Debug "leave parent"
            ;             EndIf
            
            If *this\mouse\buttons
              ;               Debug "selected ower"
            Else
              Events(*this, *this\from, #PB_EventType_MouseEnter, mouse_x, mouse_y)
            EndIf
          EndIf
          
          *this\leave = *event\enter
          *event\enter = *this
        Else
          Root()\leave = *event\enter
          *event\enter = Root()
        EndIf
      EndIf
      
      Select EventType 
        Case #PB_EventType_MouseMove,
             #PB_EventType_MouseEnter, 
             #PB_EventType_MouseLeave
          
          If Root()\mouse\buttons
            ; Drag start
            If Root()\mouse\delta And
               Not (Root()\mouse\x>Root()\mouse\delta\x-1 And 
                    Root()\mouse\x<Root()\mouse\delta\x+1 And 
                    Root()\mouse\y>Root()\mouse\delta\y-1 And
                    Root()\mouse\y<Root()\mouse\delta\y+1)
              
              If Not Root()\drag : Root()\drag = 1
                w_Events(*this, #PB_EventType_DragStart, \index[#Selected])
              EndIf
            EndIf
            
            If Active()\_gadget 
              repaint | Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_MouseMove, mouse_x, mouse_y)
            EndIf  
            
          ElseIf *this And *this = *event\enter
            repaint | Events(*this, \from, #PB_EventType_MouseMove, mouse_x, mouse_y)
            repaint = 1 ; нужен для итемов при проведении мыши чтобы виделялся
          EndIf
          
        Case #PB_EventType_LeftButtonDown, #PB_EventType_MiddleButtonDown, #PB_EventType_RightButtonDown 
          Root()\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                 (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                 (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          
          If EventType <> #PB_EventType_MiddleButtonDown
            ; Drag & Drop
            Root()\mouse\delta = AllocateStructure(_S_mouse)
            Root()\mouse\delta\x = Root()\mouse\x
            Root()\mouse\delta\y = Root()\mouse\y
            
            If *this And *this = *event\enter
              \mouse\delta = AllocateStructure(_S_mouse)
              \mouse\delta\x = Root()\mouse\x-\x[3]
              \mouse\delta\y = Root()\mouse\y-\y[3]
              \mouse\buttons = Root()\mouse\buttons
              
              \state = 2 
              SetActive(*this)
              
              repaint | Events(*this, \from, EventType, mouse_x, mouse_y)
              repaint = 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp,
             #PB_EventType_RightButtonUp 
          
          If EventType <> #PB_EventType_MiddleButtonDown
            If Active()\_gadget And
               Active()\_gadget\state = 2 
              Active()\_gadget\state = 1 
              
              repaint | Events(Active()\_gadget, Active()\_gadget\from, EventType, mouse_x, mouse_y)
              
              If _from_point_(mouse_x, mouse_y, Active()\_gadget, [#_c_4])
                
                If Active()\_gadget = *this       
                  If EventType = #PB_EventType_LeftButtonUp
                    repaint | Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_LeftClick, mouse_x, mouse_y)
                  EndIf
                  If EventType = #PB_EventType_RightClick
                    repaint | Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_RightClick, mouse_x, mouse_y)
                  EndIf
                EndIf
                
              Else
                Active()\_gadget\state = 0
                repaint | Events(Active()\_gadget, Active()\_gadget\from, #PB_EventType_MouseLeave, mouse_x, mouse_y)
              EndIf
              
              Active()\_gadget\mouse\buttons = 0   
              If Active()\_gadget\mouse\delta
                FreeStructure(Active()\_gadget\mouse\delta)
                Active()\_gadget\mouse\delta = 0
                Active()\_gadget\drag = 0
              EndIf
              
              repaint = 1
            EndIf
            
            ; Drag & Drop
            Root()\mouse\buttons = 0
            If Root()\mouse\delta
              FreeStructure(Root()\mouse\delta)
              Root()\mouse\delta = 0
              Root()\drag = 0
            EndIf
          EndIf
          
          ; active widget key state
        Case #PB_EventType_Input, 
             #PB_EventType_KeyDown, 
             #PB_EventType_KeyUp
          
          If *this And (Active()\_gadget = *this Or *this = Active())
            
            \keyboard\input = GetGadgetAttribute(Canvas, #PB_Canvas_Input)
            \keyboard\key = GetGadgetAttribute(Canvas, #PB_Canvas_Key)
            \keyboard\key[1] = GetGadgetAttribute(Canvas, #PB_Canvas_Modifiers)
            
            repaint | Events(*this, 0, EventType, mouse_x, mouse_y)
          EndIf
          
      EndSelect
      
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure g_Events(Canvas.i, EventType.i)
    Protected Repaint, *this._S_widget
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      mouse_x = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      mouse_y = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *root._S_widget = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Repaint : Repaint = 1
        ;         mouse_x = 0
        ;         mouse_y = 0
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Resize(*root, #PB_Ignore, #PB_Ignore, Width, Height)  
        Repaint = 1
        
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        Repaint | CallBack(From(*root, mouse_x, mouse_y), EventType, mouse_x, mouse_y)
    EndSelect
    
    If Repaint 
      ; create widgets
      If Not *root\create
        *root\create = 1
      EndIf
      
      ReDraw(*root)
    EndIf
  EndProcedure
  
  Procedure.i g_Callback()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected mouse_x = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      If #PB_Compiler_OS = #PB_OS_MacOS And EventType = #PB_EventType_MouseEnter And GetActiveGadget()<>EventGadget
        SetActiveGadget(EventGadget)
      EndIf
      
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) And GetActiveGadget()=EventGadget
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((mouse_x>=0 And mouse_x<Width) And (mouse_y>=0 And mouse_y<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | g_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | g_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
      Static Last_X, Last_Y
      If Last_Y <> mouse_y
        Last_Y = mouse_y
        Result | g_Events(EventGadget, EventType)
      EndIf
      If Last_x <> mouse_x
        Last_x = mouse_x
        Result | g_Events(EventGadget, EventType)
      EndIf
    Else
      Result | g_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit
  Global *this, *root, *window, NewMap w_list.i()
  
  Procedure Widget_Handler()
    Protected EventWidget.i = *event\widget,
              EventType.i = *event\type,
              EventItem.i = *event\item, 
              EventData.i = *event\data
    
    Select EventType
      Case #PB_EventType_Focus   
        If *event\widget\type =- 1
          Debug "Active "+ *event\widget\data
        Else
          Debug "Focus "+ *event\widget\data
        EndIf
        
      Case #PB_EventType_LostFocus 
        If *event\widget\type =- 1
          Debug " DeActive "+ *event\widget\data
        Else
          Debug " LostFocus "+ *event\widget\data
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    w_list(Hex(110)) = Open(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
    SetWindowTitle(Root()\canvas\window, "Window_110") 
    ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
    ;       w_list(Hex(110)) = Form(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
    w_list(Hex(111)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(111)), 111)
    w_list(Hex(112)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(112)), 112) 
    
    ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
    Bind(@Widget_Handler())
    ReDraw(Root())
  EndProcedure
  
  Procedure Window_1()
    If OpenWindow(0, 0, 0, 830, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      If Open(0, 10,10, 400, 550, "")
        w_list(Hex(10)) = Form(100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu) : SetData(w_list(Hex(10)), 10)
        w_list(Hex(11)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(11)), 11)
        w_list(Hex(12)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(12)), 12) 
        
        w_list(Hex(20)) = Form(160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu) : SetData(w_list(Hex(20)), 20)
        w_list(Hex(21)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(21)), 21)
        w_list(Hex(22)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(22)), 22)
        
        w_list(Hex(30)) = Form(220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu) : SetData(w_list(Hex(30)), 30)
        w_list(Hex(31)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(31)), 31)
        w_list(Hex(32)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(32)), 32)
        
        ;         SetActive(w_list(Hex(22)))
        ;         SetActive(w_list(Hex(2)))
        
        Bind(@Widget_Handler())
        ReDraw(Root())
      EndIf
      
      Debug ""
      
      If Open(0, 420,10, 400, 550, "")
        w_list(Hex(110)) = Form(100, 200, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
        w_list(Hex(111)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(111)), 111)
        w_list(Hex(112)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(112)), 112)
        
        w_list(Hex(120)) = Form(160, 220, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
        w_list(Hex(121)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(121)), 121)
        w_list(Hex(122)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(122)), 122)
        
        w_list(Hex(130)) = Form(220, 240, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
        w_list(Hex(131)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(131)), 131)
        w_list(Hex(132)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(132)), 132) 
        
        ;         SetActive(w_list(Hex(1022)))
        ;         SetActive(w_list(Hex(102)))
        
        Bind(@Widget_Handler())
        ReDraw(Root())
      EndIf
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Procedure Window_2()
    If OpenWindow(0, 0, 0, 900, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      w_list(Hex(-1)) = Open(0, 10,10, 880, 550, "") : SetData(w_list(Hex(-1)), -1)
      
      If w_list(Hex(-1))
        w_list(Hex(1)) = Form(520, 140, 200+2, 260+26+2, "Window_1", #PB_Window_ScreenCentered) : SetData(w_list(Hex(1)), 1)
        w_list(Hex(2)) = Container(20, 20, 180, 180) : SetData(w_list(Hex(2)), 2)
        
        w_list(Hex(10)) = Container(70, 10, 70, 180, #PB_Flag_NoGadget) : SetData(w_list(Hex(10)), 10)
        
        w_list(Hex(3)) = Container(20, 20, 180, 180) : SetData(w_list(Hex(3)), 3)
        w_list(Hex(4)) = Container(20, 20, 180, 180)
        
        w_list(Hex(5)) = Container(0, 20, 180, 30, #PB_Flag_NoGadget)
        w_list(Hex(6)) = Container(0, 35, 180, 30, #PB_Flag_NoGadget)
        w_list(Hex(7)) = Container(0, 50, 180, 30, #PB_Flag_NoGadget)
        w_list(Hex(8)) = Container(20, 70, 180, 180, #PB_Flag_NoGadget)
        
        CloseList()
        CloseList()
        
        w_list(Hex(9)) = Container(10, 70, 70, 180)
        w_list(Hex(10)) = Container(10, 10, 70, 30, #PB_Flag_NoGadget)
        w_list(Hex(12)) = Container(10, 20, 70, 30, #PB_Flag_NoGadget)
        w_list(Hex(13)) = Container(10, 30, 70, 30, #PB_Flag_NoGadget)
        CloseList()
        
        
        w_list(Hex(110)) = Form(100, 200, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
        w_list(Hex(111)) = Container( 10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(111)), 111)
        w_list(Hex(112)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(112)), 112)
        
        w_list(Hex(120)) = Form(160, 220, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
        w_list(Hex(121)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(121)), 121)
        w_list(Hex(122)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(122)), 122)
        
        w_list(Hex(130)) = Form(220, 240, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
        w_list(Hex(131)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(131)), 131)
        w_list(Hex(132)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(132)), 132) 
        
        SetActive(w_list(Hex(132)))
        SetActive(w_list(Hex(112)))
        
        Bind(@Widget_Handler())
        ReDraw(Root())
      EndIf
      
      w_list(Hex(140)) = Open(#PB_Any, 100, 100, 200, 200, "", #PB_Window_SystemMenu) : SetData(w_list(Hex(140)), 140)
      SetWindowTitle(Root()\canvas\window, "Window_140") 
      ;       Open(OpenWindow(-1, 100, 100, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(110)) = Form(0, 0, 200, 200, "Window_110", #PB_Window_SystemMenu) : SetData(w_list(Hex(110)), 110)
      w_list(Hex(141)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(141)), 141)
      w_list(Hex(142)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(142)), 142) 
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(@Widget_Handler())
      ReDraw(Root())
      ;       
      w_list(Hex(150)) = Open(#PB_Any, 160, 120, 200, 200, "Window_150", #PB_Window_SystemMenu) : SetData(w_list(Hex(150)), 150)
      ;       Open(OpenWindow(-1, 160, 120, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(120)) = Form(0, 0, 200, 200, "Window_120", #PB_Window_SystemMenu) : SetData(w_list(Hex(120)), 120)
      w_list(Hex(151)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(121)), 121)
      w_list(Hex(152)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(122)), 122)
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(@Widget_Handler())
      ReDraw(Root())
      
      w_list(Hex(160)) = Open(#PB_Any, 220, 140, 200, 200, "Window_160") : SetData(w_list(Hex(160)), 160)
      ;       Open(OpenWindow(-1, 220, 140, 200, 200, "", #PB_Window_BorderLess), 0, 0, 200, 200, "")
      ;       w_list(Hex(130)) = Form(0, 0, 200, 200, "Window_130", #PB_Window_SystemMenu) : SetData(w_list(Hex(130)), 130)
      w_list(Hex(161)) = Container(10, 10, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(161)), 161)
      w_list(Hex(162)) = Container(10, 105, 180, 85, #PB_Flag_NoGadget) : SetData(w_list(Hex(162)), 162)
      
      ;       ResizeWindow(Root()\canvas\window, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      ;       ResizeGadget(Root()\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height(w_list(Hex(110))))
      Bind(@Widget_Handler())
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_2()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
    EndSelect
    
  Until gQuit
CompilerEndIf


; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP