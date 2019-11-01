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
      *Drag\ImageID = ImageID(Image)
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
      
      If _action_(*Drag\widget) And *Drag\ImageID
        Debug "  Drop image - "+*Drag\ImageID
        
        If Image =- 1
          Result = CreateImage(#PB_Any, *Drag\width, *Drag\height) : Image = Result
        Else
          Result = IsImage(Image)
        EndIf
        
        If Result And StartDrawing(ImageOutput(Image))
          If Depth = 32
            DrawAlphaImage(*Drag\ImageID, 0, 0)
          Else
            DrawImage(*Drag\ImageID, 0, 0)
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
  
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf (#PB_Compiler_Version<547) : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    #PB_EventType_Drop
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #Anchors = 9+4
  
  #a_moved = 9
  
  ;bar buttons
  Enumeration
    #bb_1 = 1
    #bb_2 = 2
    #bb_3 = 3
  EndEnumeration
  
  ;bar position
  Enumeration
    #bp_0 = 0
    #bp_1 = 1
    #bp_2 = 2
    #bp_3 = 3
  EndEnumeration
  
  ;element position
  Enumeration
    #last =- 1
    #first = 0
    #prev = 1
    #next = 2
    #before = 3
    #after = 4
  EndEnumeration
  
  ;element coordinate 
  Enumeration
    #c_0 = 0 ; 
    #c_1 = 1 ; frame
    #c_2 = 2 ; inner
    #c_3 = 3 ; container
    #c_4 = 4 ; clip
  EndEnumeration
  
  ;color state
  Enumeration
    #s_0
    #s_1
    #s_2
    #s_3
  EndEnumeration
  
  Enumeration 1
    #Color_Front
    #Color_Back
    #Color_Line
    #Color_TitleFront
    #Color_TitleBack
    #Color_GrayText 
    #Color_Frame
  EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_Smooth 
    
    ;#PB_Bar_Vertical
    
    ;#PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
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
    #PB_Flag_Center
    #PB_Flag_Right
    #PB_Flag_Left
    #PB_Flag_Top
    #PB_Flag_Bottom
    #PB_Flag_Vertical 
    #PB_Flag_Horizontal
    #PB_Flag_AutoSize
    ;#PB_Flag_AutoRight
    ;#PB_Flag_AutoBottom
    
    #PB_Flag_Numeric
    #PB_Flag_ReadOnly
    #PB_Flag_LowerCase 
    #PB_Flag_UpperCase
    #PB_Flag_Password
    #PB_Flag_WordWrap
    #PB_Flag_MultiLine 
    #PB_Flag_InLine
    
    #PB_Flag_BorderLess
    ;     #PB_Flag_Double
    ;     #PB_Flag_Flat
    ;     #PB_Flag_Raised
    ;     #PB_Flag_Single
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AnchorsGadget
    
    #PB_Flag_FullSelection
    #PB_Flag_NoGadget
    
    #PB_Flag_Limit
  EndEnumeration
  
  #PB_Bar_Vertical = #PB_Flag_Vertical
  #PB_AutoSize = #PB_Flag_AutoSize
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Flag_Full = #PB_Flag_Left|#PB_Flag_Right|#PB_Flag_Top|#PB_Flag_Bottom
  
  
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
  
  Prototype pFunc()
  
  
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
    change.b
    buttons.l 
    delta._S_point
  EndStructure
  
  ;- - _S_keyboard
  Structure _S_keyboard
    change.b
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
  
  ;- - _S_arrow
  Structure _S_arrow
    size.a
    type.b
    ; direction.b
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    hide.b
    round.a
    ; switched.b
    interact.b
    arrow._S_arrow
    color._S_color
  EndStructure
  
  ;- - _S_box
  Structure _S_box Extends _S_button
    checked.b
  EndStructure
  
  ;- - _S_caption
  Structure _S_caption Extends _S_button
    button._S_button[3]
  EndStructure
  
  ;- - _S_transform
  Structure _S_transform
    x.i
    y.i
    width.i
    height.i
    
    hide.i
    cursor.i
    
    color._S_color[4]
  EndStructure
  
  ;- - _S_anchor
  Structure _S_anchor
    pos.i
    size.l
    index.l
    cursor.l
    delta._S_point
    *widget._S_widget
    id._S_transform[#Anchors+1]
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
    
    threestate.b
    iconsize.b
    transform.b
  EndStructure
  
  ;- - _S_image
  Structure _S_image
    y.l[3]
    x.l[3]
    height.l
    width.l
    
    index.l
    handle.i[2] ; - editor
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
  
  ;- - _S_items
  Structure _S_items Extends _S_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *i_parent._S_items
    drawing.i
    
    image._S_image
    text._S_text[4]
    *box._S_box[2]
    
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
  
  ;- - _S_bar
  Structure _S_bar
    pos.l 
    ;len.l
    
    max.l
    min.l
    
    ; \type = #PB_GadgetType_ScrollBar
    ; \type = #PB_GadgetType_ProgressBar
    ; \type = #PB_GadgetType_TrackBar
    ; \type = #PB_GadgetType_Splitter
    type.l
    
    ; \hide = Bool(\page\len >= (\max-\min))
    hide.b
    change.l
    vertical.b
    inverted.b
    direction.l
    scrollstep.f
    page._S_page
    area._S_page
    thumb._S_page  
    
    ; \button\[#bb_1] = (left&top) 
    ; \button\[#bb_2] = (right&bottom) 
    ; \button\[#bb_3] = (thumb)
    button._S_button[4]
  EndStructure
  
  ;- - _S_tab
  Structure _S_tab
    index.l[3]    ; index[0]-parent tab  ; inex[1]-entered tab ; index[2]-selected tab
    count.l       ; count tab items
    opened.l      ; parent open list item id
    scrolled.l    ; panel set state tab
    bar._S_bar
    
    List tabs._S_items()
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first._S_widget
    *second._S_widget
    
    fixed.l[3]
    
    g_first.b
    g_second.b
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
  Structure _S_widget ; Extends _S_bar
    y.l[5]
    x.l[5]
    height.l[5]
    width.l[5]
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    focus.b
    radius.a
    type.b[3] ; [2] for splitter
    from.l
    
    mode.l  ; track bar
    change.l[2]
    cursor.l[2]
    hide.b[2]
    vertical.b
    
    
    *root._S_root     ; adress root
    *parent._S_widget ; adress parent
    *gadget._S_widget ; this\canvas\gadget ; root\active\gadget
    *window._S_widget ; this\canvas\window ; root\active\window
    *scroll._S_scroll 
    *splitter._S_splitter
    
    bar._S_bar
    caption._S_caption
    color._S_color[4]
    ;box._S_box[4]
    
    
    fs.i 
    bs.i
    grid.i
    enumerate.i
    __height.i ; 
    state.i
    adress.i
    drawing.i
    container.i
    
    countItems.i[2]
    margin._S_margin
    
    interact.i 
    sublevellen.i
    drag.i[2]
    attribute.i
    
    repaint.i
    resize.b
    
    
    *i_Parent._S_items
    *Popup._S_widget
    
    combo_box._S_box
    check_box._S_box
    option_box._S_box
    *option_group._S_widget
    
    
    class.s ; 
    type_index.l
    type_count.l
    
    level.l ; Вложенность виджета
    count.l
    List *childrens._S_widget()
    
    tab._S_tab
    List *items._S_items()
    List *columns._S_widget()
    ;List *draws._S_items()
    
    flag._S_flag
    *text._S_text[4]
    *image._S_image[2]
    *align._S_align
    
    *selector._S_transform[#Anchors+1]
    
    *data
    *event._S_event
  EndStructure
  
  ;- - _S_event
  Structure _S_event 
    type.l
    item.l
    *data
    
    *root._S_root
    *callback.pFunc
    *widget._S_widget
    
    ;draw.b
  EndStructure
  
  ;- - _S_root
  Structure _S_root Extends _S_widget
    canvas.i
    *anchor._S_anchor
    
    *active._S_widget ; active window
    *opened._S_widget ; open list element
    *enter._S_widget  ; at point element
    *leave._S_widget  ; pushed at point element
    
    mouse._S_mouse
    keyboard._S_keyboard
    
    event_count.b
    List *event_list._S_event()
  EndStructure
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *event._S_event = AllocateStructure(_S_event)
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Type()
    *event\type
  EndMacro
  
  Macro Data()
    *event\data
  EndMacro
  
  Macro Item()
    *event\item
  EndMacro
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root)
  EndMacro
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget::*event\widget)
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget::*event\widget)
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget::*event\widget, _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget::*event\widget, _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget::*event\widget, _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget::*event\widget, _type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  Macro SetAnchors(_this_)
    a_Set(_this_)
  EndMacro
  Macro GetAnchors(_this_)
    a_Get(_this_)
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
  Declare.i a_Get(*this, index.i=-1)
  Declare.i GetCount(*this)
  Declare.s GetClass(*this)
  
  Declare.i SetTransparency(*this, Transparency.a)
  Declare.i a_Set(*this)
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
  Declare.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *Parent=0)
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
  
  ;Declare.i Resizes(*Scroll, X.l,Y.l,Width.l,Height.l)
  
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
  Declare.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
  
  Macro _init_default_value_(_this_, _event_type_)
    Select _event_type_
      Case #PB_EventType_Repaint
        Debug " -- Canvas repaint -- " + _this_\row\draw
      Case #PB_EventType_MouseWheel
        _this_\root\mouse\wheel\y = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_WheelDelta)
      Case #PB_EventType_Input 
        _this_\root\input = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Input)
      Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
        _this_\root\Key = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Key)
        _this_\root\Key[1] = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Modifiers)
      Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
        _this_\root\mouse\x = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_MouseX)
        _this_\root\mouse\y = GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_MouseY)
        
      Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
           #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
           #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
        
        _this_\root\mouse\buttons = (Bool(_event_type_ = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                    (Bool(_event_type_ = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                    (Bool(_event_type_ = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
        
    EndSelect
  EndMacro
EndDeclareModule

Module Widget
  ;- MODULE
  ;
  Declare.i g_Callback()
  Declare.i w_Events(*this, EventType.i, EventItem.i=-1, EventData.i=0)
  Declare.i Events(*this, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
  
;   Procedure.i w_Events(*this, EventType.i, EventItem.i=-1, EventData.i=0)
;   EndProcedure
;   
;   Procedure.i Events(*this, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
;   EndProcedure
;   
;   Procedure.i From(*this._S_widget, mouse_x.i, mouse_y.i)
;     ProcedureReturn *this
;   EndProcedure
  
  ;- GLOBALs
  Global def_colors._S_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#s_0] = $80000000
    \fore[#s_0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#s_0] = $FFE2E2E2 ; $80E2E2E2
    \frame[#s_0] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#s_1] = $80000000
    \fore[#s_1] = $FFEAEAEA ; $FFFAF8F8
    \back[#s_1] = $FFCECECE ; $80FCEADA
    \frame[#s_1] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#s_2] = $FFFEFEFE
    \fore[#s_2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#s_2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#s_2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#s_3] = $FFBABABA
    \fore[#s_3] = $FFF6F6F6 
    \back[#s_3] = $FFE2E2E2 
    \frame[#s_3] = $FFBABABA
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  
  Macro _button_draw_(_vertical_, _x_,_y_,_width_,_height_, _arrow_type_, _arrow_size_, _arrow_direction_, _color_fore_,_color_back_,_color_frame_, _color_arrow_, _alpha_, _round_)
    ; Draw buttons   
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    _box_gradient_(_vertical_,_x_,_y_,_width_,_height_, _color_fore_,_color_back_, _round_, _alpha_)
    
    ; Draw buttons frame
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(_x_,_y_,_width_,_height_,_round_,_round_,_color_frame_&$FFFFFF|_alpha_<<24)
    
    ; Draw arrows
    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    Arrow(_x_+(_width_-_arrow_size_)/2,_y_+(_height_-_arrow_size_)/2, _arrow_size_, _arrow_direction_, _color_arrow_&$FFFFFF|_alpha_<<24, _arrow_type_)
    ResetGradientColors()
  EndMacro
  
  Macro _set_image_(_this_, _item_, _image_)
    _item_\image\change = IsImage(_image_)
    
    If _item_\image\change
      If _this_\flag\iconsize
        _item_\image\width = _this_\flag\iconsize
        _item_\image\height = _this_\flag\iconsize
        ResizeImage(_image_, _item_\image\width, _item_\image\height)
      Else
        _item_\image\width = ImageWidth(_image_)
        _item_\image\height = ImageHeight(_image_)
      EndIf  
      
      _item_\image\index = _image_ 
      _item_\image\handle = ImageID(_image_)
      ;_this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    Else
      _item_\image\index =- 1
      _item_\image\handle = 0
      _item_\image\width = 0
      _item_\image\height = 0
      ;_this_\row\sublevel = 0
    EndIf
  EndMacro
  
  Macro GetAdress(_this_)
    _this_\adress
  EndMacro
  
  
  ;-
  Macro set_cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_Cursor(_this_)
    GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Cursor)
  EndMacro
  
  Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    *event\widget = _this_
    _this_\type = _type_
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    SetParent(_this_, _parent_, _parent_\tab\opened)
    
    ; _set_auto_size_
    If Bool(_flag_ & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
      _this_\align = AllocateStructure(_S_align)
      _this_\align\autoSize = 1
      _this_\align\left = 1
      _this_\align\top = 1
      _this_\align\right = 1
      _this_\align\bottom = 1
    EndIf
    
    If Bool(_flag_ & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
      
      a_Add(_this_)
      a_Set(_this_)
      
    EndIf
    
  EndMacro
  
  ;-
  ; SCROLLBAR
  Macro _childrens_move_(_this_, _change_x_, _change_y_)
    If ListSize(_this_\childrens())
      ForEach _this_\childrens()
        Resize(_this_\childrens(), 
               (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_,
               (_this_\childrens()\y-_this_\y-_this_\bs-_this_\__height) + _change_y_, 
               #PB_Ignore, #PB_Ignore)
      Next
    EndIf
  EndMacro
  
  Procedure.b splitter_size(*this._S_widget)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\first, *this\bar\button[#bb_1]\x, (*this\bar\button[#bb_2]\height+*this\bar\thumb\len)-*this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\bar\button[#bb_1]\x, *this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\bar\button[#bb_1]\x, *this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\second, *this\bar\button[#bb_2]\x, (*this\bar\button[#bb_1]\height+*this\bar\thumb\len)-*this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\bar\button[#bb_2]\x, *this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\bar\button[#bb_2]\x, *this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  Macro _bar_splitter_size_(_this_)
    If _this_\bar\Vertical
      Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\bar\thumb\pos-_this_\y)
      Resize(_this_\splitter\second, 0, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y))
    Else
      Resize(_this_\splitter\first, 0, 0, _this_\bar\thumb\pos-_this_\x, _this_\height)
      Resize(_this_\splitter\second, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x, 0, _this_\width-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\bar\area\pos + Round((_scroll_pos_-_this_\bar\min) * (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)), #PB_Round_Nearest)) 
  EndMacro
  
  Macro _thumb_len_(_this_)
    Round(_this_\bar\area\len - (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)) * ((_this_\bar\max-_this_\bar\min) - _this_\bar\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro _bar_update_v_scroll_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\y-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_-_this_\y))) Or
         Bool((_pos_-_this_\y-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              Bar_SetState(_this_, (_pos_-_this_\y) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  Macro _bar_update_h_scroll_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\x-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_-_this_\x))) Or
         Bool((_pos_-_this_\x-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              Bar_SetState(_this_, (_pos_-_this_\x) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  ; Inverted scroll bar position
  Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ; Then scroll bar start position
  Macro _bar_in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _bar_in_stop_(_bar_) : Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) : EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#bb_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#bb_1]\len + _this_\bar\button[#bb_2]\len)
    Else
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#bb_1]\len
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#bb_1]\len + _this_\bar\button[#bb_2]\len)
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len-_this_\bar\thumb\len)
  EndMacro
  
  Macro _bar_set_thumb_pos_(_this_, _scroll_pos_)
    _thumb_pos_(_this_, _scroll_pos_)
    
    If _this_\bar\thumb\pos < _this_\bar\area\pos 
      _this_\bar\thumb\pos = _this_\bar\area\pos 
    EndIf 
    
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
    
    If _this_\bar\vertical 
      _this_\bar\button\x = _this_\X + Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
      _this_\bar\button\y = _this_\bar\area\pos
      _this_\bar\button\width = _this_\width - Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
      _this_\bar\button\height = _this_\bar\area\len               
    Else 
      _this_\bar\button\x = _this_\bar\area\pos
      _this_\bar\button\y = _this_\Y + Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
      _this_\bar\button\width = _this_\bar\area\len
      _this_\bar\button\height = _this_\Height - Bool(_this_\bar\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\bar\button[#bb_1]\len And _this_\bar\page\len
      If _scroll_pos_ = _this_\bar\min
        _this_\bar\button[#bb_1]\Color\state = #s_3
        _this_\bar\button[#bb_1]\interact = 0
      Else
        If _this_\bar\button[#bb_1]\Color\state <> #s_2
          _this_\bar\button[#bb_1]\Color\state = #s_0
        EndIf
        _this_\bar\button[#bb_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type=#PB_GadgetType_ScrollBar
      If _this_\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\bar\button[#bb_1]\x = _this_\bar\button\x
        _this_\bar\button[#bb_1]\y = _this_\Y 
        _this_\bar\button[#bb_1]\width = _this_\bar\button\width
        _this_\bar\button[#bb_1]\height = _this_\bar\button[#bb_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\bar\button[#bb_1]\x = _this_\X 
        _this_\bar\button[#bb_1]\y = _this_\bar\button\y
        _this_\bar\button[#bb_1]\width = _this_\bar\button[#bb_1]\len 
        _this_\bar\button[#bb_1]\height = _this_\bar\button\height 
      EndIf
    Else
      _this_\bar\button[#bb_1]\x = _this_\X
      _this_\bar\button[#bb_1]\y = _this_\Y
      
      If _this_\bar\vertical
        _this_\bar\button[#bb_1]\width = _this_\width
        _this_\bar\button[#bb_1]\height = _this_\bar\thumb\pos-_this_\y
      Else
        _this_\bar\button[#bb_1]\width = _this_\bar\thumb\pos-_this_\x
        _this_\bar\button[#bb_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\bar\button[#bb_2]\len And _this_\bar\page\len
      ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
      If _scroll_pos_ = _this_\bar\page\end
        _this_\bar\button[#bb_2]\Color\state = #s_3
        _this_\bar\button[#bb_2]\interact = 0
      Else
        If _this_\bar\button[#bb_2]\Color\state <> #s_2
          _this_\bar\button[#bb_2]\Color\state = #s_0
        EndIf
        _this_\bar\button[#bb_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type = #PB_GadgetType_ScrollBar
      If _this_\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\bar\button[#bb_2]\x = _this_\bar\button\x
        _this_\bar\button[#bb_2]\width = _this_\bar\button\width
        _this_\bar\button[#bb_2]\height = _this_\bar\button[#bb_2]\len 
        _this_\bar\button[#bb_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#bb_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\bar\button[#bb_2]\y = _this_\bar\button\y
        _this_\bar\button[#bb_2]\height = _this_\bar\button\height
        _this_\bar\button[#bb_2]\width = _this_\bar\button[#bb_2]\len 
        _this_\bar\button[#bb_2]\x = _this_\X+_this_\width-_this_\bar\button[#bb_2]\width 
      EndIf
      
    Else
      If _this_\bar\vertical
        _this_\bar\button[#bb_2]\x = _this_\x
        _this_\bar\button[#bb_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#bb_2]\width = _this_\width
        _this_\bar\button[#bb_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
      Else
        _this_\bar\button[#bb_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#bb_2]\y = _this_\Y
        _this_\bar\button[#bb_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
        _this_\bar\button[#bb_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\bar\thumb\len
      If _this_\bar\button[#bb_3]\len <> _this_\bar\thumb\len
        _this_\bar\button[#bb_3]\len = _this_\bar\thumb\len
      EndIf
      
      If _this_\bar\vertical
        _this_\bar\button[#bb_3]\x = _this_\bar\button\x 
        _this_\bar\button[#bb_3]\width = _this_\bar\button\width 
        _this_\bar\button[#bb_3]\y = _this_\bar\thumb\pos
        _this_\bar\button[#bb_3]\height = _this_\bar\thumb\len                              
      Else
        _this_\bar\button[#bb_3]\y = _this_\bar\button\y 
        _this_\bar\button[#bb_3]\height = _this_\bar\button\height
        _this_\bar\button[#bb_3]\x = _this_\bar\thumb\pos 
        _this_\bar\button[#bb_3]\width = _this_\bar\thumb\len                                  
      EndIf
      
    ElseIf _this_\bar\type <> #PB_GadgetType_ProgressBar
      ; Эфект спин гаджета
      If _this_\bar\vertical
        _this_\bar\button[#bb_2]\Height = _this_\Height/2 
        _this_\bar\button[#bb_2]\y = _this_\y+_this_\bar\button[#bb_2]\Height+Bool(_this_\Height%2) 
        
        _this_\bar\button[#bb_1]\y = _this_\y 
        _this_\bar\button[#bb_1]\Height = _this_\Height/2
        
      Else
        _this_\bar\button[#bb_2]\width = _this_\width/2 
        _this_\bar\button[#bb_2]\x = _this_\x+_this_\bar\button[#bb_2]\width+Bool(_this_\width%2) 
        
        _this_\bar\button[#bb_1]\x = _this_\x 
        _this_\bar\button[#bb_1]\width = _this_\width/2
      EndIf
    EndIf
    
    ;     If _this_\bar\text
    ;       _this_\bar\text\change = 1
    ;     EndIf
    ;     
    ; Splitter childrens auto resize       
    If _this_\Splitter And _this_\bar\change
      ;splitter_size(_this_)
      ;     If \type = #PB_GadgetType_Spin
      ;                 \text\string.s[1] = Str(\bar\page\pos) : \text\change = 1
      ;                 
      ;               ElseIf \type = #PB_GadgetType_Splitter
      _bar_splitter_size_(_this_)
    EndIf
    
    ; ScrollArea childrens auto resize 
    If _this_\parent And _this_\bar\change
      _this_\parent\change =- 1
      
      If _this_\parent\scroll
        If _this_\bar\vertical
          _this_\parent\scroll\y =- _this_\bar\page\pos 
          _childrens_move_(_this_\parent, 0, _this_\bar\change)
        Else
          _this_\parent\scroll\x =- _this_\bar\page\pos
          _childrens_move_(_this_\parent, _this_\bar\change, 0)
        EndIf
      EndIf
    EndIf
    
    ;     If _this_\bar\change
    ;       Post(#PB_EventType_StatusChange, _this_, _this_\bar\from, _this_\bar\direction)
    ;     EndIf
  EndMacro
  
  Procedure.i Bar_ChangePos(*bar._S_bar, ScrollPos.i)
    With *bar
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _bar_invert_(*bar, ScrollPos, \inverted)
      EndIf
      
      If \page\pos <> ScrollPos
        \change = \page\pos - ScrollPos
        
        If \type = #PB_GadgetType_TrackBar Or 
           \type = #PB_GadgetType_ProgressBar
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        Else
          If \page\pos > ScrollPos
            If \inverted
              \direction = _bar_invert_(*bar, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _bar_invert_(*bar, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        ProcedureReturn #True
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b Bar_Update(*this._S_widget)
    With *this
      ;
      If (\bar\max-\bar\min) >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \bar\max And \width And \height
          \bar\max = \bar\area\len-\bar\button\len
          
          If Not \bar\page\pos
            \bar\page\pos = \bar\max/2
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #bb_1
          ;             \splitter\fixed[\splitter\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #bb_2
          ;             \splitter\fixed[\splitter\fixed] = \bar\area\len-\bar\page\pos-\bar\button\len
          ;           EndIf
        EndIf
        
        ;
        If \splitter 
          If \splitter\fixed
            If \bar\area\len - \bar\button\len > \splitter\fixed[\splitter\fixed] 
              \bar\page\pos = Bool(\splitter\fixed = 2) * \bar\max
              
              If \splitter\fixed[\splitter\fixed] > \bar\button\len
                \bar\area\pos + \splitter\fixed[1]
                \bar\area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \bar\area\len - \bar\button\len
              \bar\page\pos = Bool(\splitter\fixed = 1) * \bar\max
            EndIf
          EndIf
          
          ; Debug ""+\bar\area\len +" "+ Str(\bar\button[#bb_1]\len + \bar\button[#bb_2]\len)
          
          If \bar\area\len =< \bar\button\len
            \bar\page\pos = \bar\max/2
            
            If \bar\vertical
              \bar\area\pos = \Y 
              \bar\area\len = \Height
            Else
              \bar\area\pos = \X
              \bar\area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \bar\area\len > \bar\button\len
          \bar\thumb\len = Round(\bar\area\len - (\bar\area\len / (\bar\max-\bar\min)) * ((\bar\max-\bar\min) - \bar\page\len), #PB_Round_Nearest)
          
          If \bar\thumb\len > \bar\area\len 
            \bar\thumb\len = \bar\area\len 
          EndIf 
          
          If \bar\thumb\len > \bar\button\len
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
          Else
            \bar\area\len = \bar\area\len - (\bar\button\len-\bar\thumb\len)
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)                              
            \bar\thumb\len = \bar\button\len
          EndIf
          
        Else
          If \splitter
            \bar\thumb\len = \width
          Else
            \bar\thumb\len = 0
          EndIf
          
          If \bar\vertical
            \bar\area\pos = \Y
            \bar\area\len = \Height
          Else
            \bar\area\pos = \X
            \bar\area\len = \width 
          EndIf
          
          \bar\area\end = \bar\area\pos + (\bar\area\len - \bar\thumb\len)
        EndIf
        
        If \bar\area\len  
          \bar\page\end = \bar\max - \bar\page\len
          \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
          ; Debug " line-" + #PB_Compiler_Line +" "+  \bar\thumb\pos +" "+ \bar\area\end +" "+ \bar\area\len
          
          If \bar\thumb\pos = \bar\area\end And \bar\type = #PB_GadgetType_ScrollBar
            SetState(*this, \bar\max)
          EndIf
        EndIf
      EndIf
      
      If \bar\type = #PB_GadgetType_ScrollBar
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.i Bar_UpdatePos(*this._S_widget, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _set_area_coordinate_(*this)
      EndIf
      
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
      
      If \bar\thumb\end <> ThumbPos 
        \bar\thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \bar\area\end <> ThumbPos
          ScrollPos = \bar\min + Round((ThumbPos - \bar\area\pos) / (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \bar\page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \bar\type Or \bar\type = #PB_GadgetType_ProgressBar) And \bar\vertical
          ScrollPos = _bar_invert_(*this\bar, ScrollPos, \bar\inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Bar_SetState(*this._S_widget, ScrollPos.l)
    Protected Result.b
    
    With *this
      If Bar_ChangePos(*this\bar, ScrollPos)
        \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, ScrollPos, \bar\inverted))
        
        If \splitter And \splitter\fixed = #bb_1
          \splitter\fixed[\splitter\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        
        If \splitter And \splitter\fixed = #bb_2
          \splitter\fixed[\splitter\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Bar_SetAttribute(*this._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#bb_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#bb_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
      Else
        Select Attribute
          Case #PB_Bar_Minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              Result = #True
            EndIf
            
          Case #PB_Bar_Maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If \bar\max = 0
                \bar\page\pos = 0
              EndIf
              
              Result = #True
            EndIf
            
          Case #PB_Bar_PageLength
            If \bar\page\len <> Value
              If Value > (\bar\max-\bar\min) 
                ;\bar\max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
                If \bar\max = 0 
                  \bar\max = Value 
                EndIf
                \bar\page\len = (\bar\max-\bar\min)
              Else
                \bar\page\len = Value
              EndIf
              
              Result = #True
            EndIf
            
          Case #PB_Bar_ScrollStep 
            \bar\scrollstep = Value
            
          Case #PB_Bar_ButtonSize
            If \bar\button\len <> Value
              \bar\button\len = Value
              \bar\button[#bb_1]\len = Value
              \bar\button[#bb_2]\len = Value
              Result = #True
            EndIf
            
          Case #PB_Bar_Inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
            EndIf
            
        EndSelect
      EndIf
      
      If Result
        \hide = Bar_Update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  ;- Anchors
  Macro a_Draw(_this_)
    If _this_\root\anchor
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\anchor\id[1] : Box(_this_\root\anchor\id[1]\x, _this_\root\anchor\id[1]\y, _this_\root\anchor\id[1]\width, _this_\root\anchor\id[1]\height ,_this_\root\anchor\id[1]\color[_this_\root\anchor\id[1]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[2] : Box(_this_\root\anchor\id[2]\x, _this_\root\anchor\id[2]\y, _this_\root\anchor\id[2]\width, _this_\root\anchor\id[2]\height ,_this_\root\anchor\id[2]\color[_this_\root\anchor\id[2]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[3] : Box(_this_\root\anchor\id[3]\x, _this_\root\anchor\id[3]\y, _this_\root\anchor\id[3]\width, _this_\root\anchor\id[3]\height ,_this_\root\anchor\id[3]\color[_this_\root\anchor\id[3]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[4] : Box(_this_\root\anchor\id[4]\x, _this_\root\anchor\id[4]\y, _this_\root\anchor\id[4]\width, _this_\root\anchor\id[4]\height ,_this_\root\anchor\id[4]\color[_this_\root\anchor\id[4]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[5] : Box(_this_\root\anchor\id[5]\x, _this_\root\anchor\id[5]\y, _this_\root\anchor\id[5]\width, _this_\root\anchor\id[5]\height ,_this_\root\anchor\id[5]\color[_this_\root\anchor\id[5]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[6] : Box(_this_\root\anchor\id[6]\x, _this_\root\anchor\id[6]\y, _this_\root\anchor\id[6]\width, _this_\root\anchor\id[6]\height ,_this_\root\anchor\id[6]\color[_this_\root\anchor\id[6]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[7] : Box(_this_\root\anchor\id[7]\x, _this_\root\anchor\id[7]\y, _this_\root\anchor\id[7]\width, _this_\root\anchor\id[7]\height ,_this_\root\anchor\id[7]\color[_this_\root\anchor\id[7]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[8] : Box(_this_\root\anchor\id[8]\x, _this_\root\anchor\id[8]\y, _this_\root\anchor\id[8]\width, _this_\root\anchor\id[8]\height ,_this_\root\anchor\id[8]\color[_this_\root\anchor\id[8]\color\state]\frame) : EndIf
      ;If _this_\root\anchor\id[#a_moved] : Box(_this_\root\anchor\id[#a_moved]\x, _this_\root\anchor\id[#a_moved]\y, _this_\root\anchor\id[#a_moved]\width, _this_\root\anchor\id[#a_moved]\height ,_this_\root\anchor\id[#a_moved]\color[_this_\root\anchor\id[#a_moved]\color\state]\frame) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\anchor\id[10] : Box(_this_\root\anchor\id[10]\x, _this_\root\anchor\id[10]\y, _this_\root\anchor\id[10]\width, _this_\root\anchor\id[10]\height ,_this_\root\anchor\id[10]\color[_this_\root\anchor\id[10]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[11] : Box(_this_\root\anchor\id[11]\x, _this_\root\anchor\id[11]\y, _this_\root\anchor\id[11]\width, _this_\root\anchor\id[11]\height ,_this_\root\anchor\id[11]\color[_this_\root\anchor\id[11]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[12] : Box(_this_\root\anchor\id[12]\x, _this_\root\anchor\id[12]\y, _this_\root\anchor\id[12]\width, _this_\root\anchor\id[12]\height ,_this_\root\anchor\id[12]\color[_this_\root\anchor\id[12]\color\state]\frame) : EndIf
      If _this_\root\anchor\id[13] : Box(_this_\root\anchor\id[13]\x, _this_\root\anchor\id[13]\y, _this_\root\anchor\id[13]\width, _this_\root\anchor\id[13]\height ,_this_\root\anchor\id[13]\color[_this_\root\anchor\id[13]\color\state]\frame) : EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      If _this_\root\anchor\id[1] : Box(_this_\root\anchor\id[1]\x+1, _this_\root\anchor\id[1]\y+1, _this_\root\anchor\id[1]\width-2, _this_\root\anchor\id[1]\height-2 ,_this_\root\anchor\id[1]\color[_this_\root\anchor\id[1]\color\state]\back) : EndIf
      If _this_\root\anchor\id[2] : Box(_this_\root\anchor\id[2]\x+1, _this_\root\anchor\id[2]\y+1, _this_\root\anchor\id[2]\width-2, _this_\root\anchor\id[2]\height-2 ,_this_\root\anchor\id[2]\color[_this_\root\anchor\id[2]\color\state]\back) : EndIf
      If _this_\root\anchor\id[3] : Box(_this_\root\anchor\id[3]\x+1, _this_\root\anchor\id[3]\y+1, _this_\root\anchor\id[3]\width-2, _this_\root\anchor\id[3]\height-2 ,_this_\root\anchor\id[3]\color[_this_\root\anchor\id[3]\color\state]\back) : EndIf
      If _this_\root\anchor\id[4] : Box(_this_\root\anchor\id[4]\x+1, _this_\root\anchor\id[4]\y+1, _this_\root\anchor\id[4]\width-2, _this_\root\anchor\id[4]\height-2 ,_this_\root\anchor\id[4]\color[_this_\root\anchor\id[4]\color\state]\back) : EndIf
      If _this_\root\anchor\id[5] And Not _this_\container : Box(_this_\root\anchor\id[5]\x+1, _this_\root\anchor\id[5]\y+1, _this_\root\anchor\id[5]\width-2, _this_\root\anchor\id[5]\height-2 ,_this_\root\anchor\id[5]\color[_this_\root\anchor\id[5]\color\state]\back) : EndIf
      If _this_\root\anchor\id[6] : Box(_this_\root\anchor\id[6]\x+1, _this_\root\anchor\id[6]\y+1, _this_\root\anchor\id[6]\width-2, _this_\root\anchor\id[6]\height-2 ,_this_\root\anchor\id[6]\color[_this_\root\anchor\id[6]\color\state]\back) : EndIf
      If _this_\root\anchor\id[7] : Box(_this_\root\anchor\id[7]\x+1, _this_\root\anchor\id[7]\y+1, _this_\root\anchor\id[7]\width-2, _this_\root\anchor\id[7]\height-2 ,_this_\root\anchor\id[7]\color[_this_\root\anchor\id[7]\color\state]\back) : EndIf
      If _this_\root\anchor\id[8] : Box(_this_\root\anchor\id[8]\x+1, _this_\root\anchor\id[8]\y+1, _this_\root\anchor\id[8]\width-2, _this_\root\anchor\id[8]\height-2 ,_this_\root\anchor\id[8]\color[_this_\root\anchor\id[8]\color\state]\back) : EndIf
      
    EndIf
  EndMacro
  
  Macro a_Resize(_this_)
    If _this_\root\anchor\id[1] ; left
      _this_\root\anchor\id[1]\x = _this_\x-_this_\root\anchor\pos
      _this_\root\anchor\id[1]\y = _this_\y+(_this_\height-_this_\root\anchor\id[1]\height)/2
    EndIf
    If _this_\root\anchor\id[2] ; top
      _this_\root\anchor\id[2]\x = _this_\x+(_this_\width-_this_\root\anchor\id[2]\width)/2
      _this_\root\anchor\id[2]\y = _this_\y-_this_\root\anchor\pos
    EndIf
    If  _this_\root\anchor\id[3] ; right
      _this_\root\anchor\id[3]\x = _this_\x+_this_\width-_this_\root\anchor\id[3]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[3]\y = _this_\y+(_this_\height-_this_\root\anchor\id[3]\height)/2
    EndIf
    If _this_\root\anchor\id[4] ; bottom
      _this_\root\anchor\id[4]\x = _this_\x+(_this_\width-_this_\root\anchor\id[4]\width)/2
      _this_\root\anchor\id[4]\y = _this_\y+_this_\height-_this_\root\anchor\id[4]\height+_this_\root\anchor\pos
    EndIf
    
    If _this_\root\anchor\id[5] ; left&top
      _this_\root\anchor\id[5]\x = _this_\x-_this_\root\anchor\pos
      _this_\root\anchor\id[5]\y = _this_\y-_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[6] ; right&top
      _this_\root\anchor\id[6]\x = _this_\x+_this_\width-_this_\root\anchor\id[6]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[6]\y = _this_\y-_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[7] ; right&bottom
      _this_\root\anchor\id[7]\x = _this_\x+_this_\width-_this_\root\anchor\id[7]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[7]\y = _this_\y+_this_\height-_this_\root\anchor\id[7]\height+_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[8] ; left&bottom
      _this_\root\anchor\id[8]\x = _this_\x-_this_\root\anchor\pos
      _this_\root\anchor\id[8]\y = _this_\y+_this_\height-_this_\root\anchor\id[8]\height+_this_\root\anchor\pos
    EndIf
    
    If _this_\root\anchor\id[#a_moved] 
      _this_\root\anchor\id[#a_moved]\x = _this_\x
      _this_\root\anchor\id[#a_moved]\y = _this_\y
      _this_\root\anchor\id[#a_moved]\width = _this_\width
      _this_\root\anchor\id[#a_moved]\height = _this_\height
    EndIf
    
    If _this_\root\anchor\id[10] And _this_\root\anchor\id[11] And _this_\root\anchor\id[12] And _this_\root\anchor\id[13]
      a_Lines(_this_)
    EndIf
    
  EndMacro
  
  Procedure a_Lines(*Gadget._S_widget=-1, distance=0)
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
        
        If \parent And ListSize(\parent\childrens())
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
                
                ; \root\anchor\id[10]\color[0]\frame = $0000FF
                \root\anchor\id[10]\hide = 0
                \root\anchor\id[10]\x = checked_x1
                \root\anchor\id[10]\y = left_y1
                \root\anchor\id[10]\width = ls
                \root\anchor\id[10]\height = left_y2-left_y1
              Else
                ; \root\anchor\id[10]\color[0]\frame = $000000
                \root\anchor\id[10]\hide = 1
              EndIf
              
              ;Right_line
              If checked_x2 = relative_x2
                If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                
                \root\anchor\id[12]\hide = 0
                \root\anchor\id[12]\x = checked_x2-ls
                \root\anchor\id[12]\y = right_y1
                \root\anchor\id[12]\width = ls
                \root\anchor\id[12]\height = right_y2-right_y1
              Else
                \root\anchor\id[12]\hide = 1
              EndIf
              
              ;Top_line
              If checked_y1 = relative_y1 
                If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                
                \root\anchor\id[11]\hide = 0
                \root\anchor\id[11]\x = top_x1
                \root\anchor\id[11]\y = checked_y1
                \root\anchor\id[11]\width = top_x2-top_x1
                \root\anchor\id[11]\height = ls
              Else
                \root\anchor\id[11]\hide = 1
              EndIf
              
              ;Bottom_line
              If checked_y2 = relative_y2 
                If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                
                \root\anchor\id[13]\hide = 0
                \root\anchor\id[13]\x = bottom_x1
                \root\anchor\id[13]\y = checked_y2-ls
                \root\anchor\id[13]\width = bottom_x2-bottom_x1
                \root\anchor\id[13]\height = ls
              Else
                \root\anchor\id[13]\hide = 1
              EndIf
            EndIf
          Next
          PopListPosition(\parent\childrens())
        EndIf
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i a_Add(*this._S_widget, Size.l=6, Pos.l=-1)
    Structure DataBuffer
      cursor.i[#Anchors+1]
    EndStructure
    
    Protected i, *Cursor.DataBuffer = ?CursorsBuffer
    
    With *this
      \flag\transform = 1
      If Pos=-1
        Pos = Size-3
      EndIf
      
      If Not \root\anchor
        \root\anchor = AllocateStructure(_S_anchor)
        \root\anchor\index = #a_moved
        \root\anchor\pos = Pos
        \root\anchor\size = Size
        
        For i = 0 To #Anchors
          \root\anchor\id[i]\cursor = *Cursor\cursor[i]
          
          \root\anchor\id[i]\color[0]\frame = $000000
          \root\anchor\id[i]\color[1]\frame = $FF0000
          \root\anchor\id[i]\color[2]\frame = $0000FF
          
          \root\anchor\id[i]\color[0]\back = $FFFFFF
          \root\anchor\id[i]\color[1]\back = $FFFFFF
          \root\anchor\id[i]\color[2]\back = $FFFFFF
          
          \root\anchor\id[i]\width = \root\anchor\size
          \root\anchor\id[i]\height = \root\anchor\size
          
          If \container And i = 5
            \root\anchor\id[5]\width * 2
            \root\anchor\id[5]\height * 2
          EndIf
          
          If i=10 Or i=12
            \root\anchor\id[i]\color[0]\frame = $0000FF
            ;           \root\anchor\id[i]\color[1]\frame = $0000FF
            ;           \root\anchor\id[i]\color[2]\frame = $0000FF
          EndIf
          If i=11 Or i=13
            \root\anchor\id[i]\color[0]\frame = $FF0000
            ;           \root\anchor\id[i]\color[1]\frame = $FF0000
            ;           \root\anchor\id[i]\color[2]\frame = $FF0000
          EndIf
        Next i
        
      EndIf
    EndWith
    
    DataSection
      CursorsBuffer:
      Data.i #PB_Cursor_Default
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
  
  Procedure.i a_Get(*this._S_widget, index.i=-1)
    ProcedureReturn Bool(*this\root\anchor\id[(Bool(index.i=-1) * #a_moved) + (Bool(index.i>0) * index)]) * *this
  EndProcedure
  
  Procedure.i a_Set(*this._S_widget)
    Protected Result.i
    Static *LastPos
    
    With *this
      If Not (\parent And 
              (\parent\scroll And (*this = \parent\scroll\v Or *this = \parent\scroll\h)) Or 
              (\parent\splitter And (*this = \parent\splitter\first Or *this = \parent\splitter\second Or \from = #bb_3)))
        
        If \root\anchor\index = #a_moved And \root\anchor\widget <> *this
          ;         If \root\anchor\widget
          ;           If *LastPos
          ;             ; Возврашаем на место
          ;             SetPosition(\root\anchor\widget, #PB_List_Before, *LastPos)
          ;             *LastPos = 0
          ;           EndIf
          ;         EndIf
          ;         
          ;         *LastPos = GetPosition(*this, #PB_List_After)
          ;         If *LastPos
          ;           SetPosition(*this, #PB_List_Last)
          ;         EndIf
          \root\anchor\widget = *this
          
          If \container
            \root\anchor\id[5]\width = \root\anchor\size * 2
            \root\anchor\id[5]\height = \root\anchor\size * 2
          Else
            \root\anchor\id[5]\width = \root\anchor\size
            \root\anchor\id[5]\height = \root\anchor\size
          EndIf
          
          a_Resize(*this)
          Result = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i a_Remove(*this._S_widget)
    Protected Result.i
    
    With *this
      If \root\anchor
        Result = \root\anchor
        FreeStructure(\root\anchor)
        \root\anchor = 0
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure a_Callback(*this._S_widget, EventType.i, Buttons.i, mouse_x.i,mouse_y.i)
    Protected result, i 
    
    With *this
      If \root\anchor 
        Select EventType 
          Case #PB_EventType_MouseMove
            If \root\anchor\id[\root\anchor\index]\color\state = #s_2
              *this = \root\anchor\widget
              mouse_x-\root\anchor\delta\x
              mouse_y-\root\anchor\delta\y
              
              Protected.i Px,Py, Grid = \grid, IsGrid = Bool(Grid>1)
              
              If \parent
                Px = \parent\x[2]
                Py = \parent\y[2]
              EndIf
              
              Protected mx = Match(mouse_x-Px+\root\anchor\pos, Grid)
              Protected my = Match(mouse_y-Py+\root\anchor\pos, Grid)
              Protected mw = Match((\x+\width-IsGrid)-mouse_x-\root\anchor\pos, Grid)+IsGrid
              Protected mh = Match((\y+\height-IsGrid)-mouse_y-\root\anchor\pos, Grid)+IsGrid
              Protected mxw = Match(mouse_x-\x+\root\anchor\pos, Grid)+IsGrid
              Protected myh = Match(mouse_y-\y+\root\anchor\pos, Grid)+IsGrid
              
              Select \root\anchor\index
                Case 1 : result = Resize(*this, mx, #PB_Ignore, mw, #PB_Ignore)
                Case 2 : result = Resize(*this, #PB_Ignore, my, #PB_Ignore, mh)
                Case 3 : result = Resize(*this, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
                Case 4 : result = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
                  
                Case 5 
                  If \container ; Form, Container, ScrollArea, Panel
                    result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                  Else
                    result = Resize(*this, mx, my, mw, mh)
                  EndIf
                  
                Case 6 : result = Resize(*this, #PB_Ignore, my, mxw, mh)
                Case 7 : result = Resize(*this, #PB_Ignore, #PB_Ignore, mxw, myh)
                Case 8 : result = Resize(*this, mx, #PB_Ignore, mw, myh)
                  
                Case #a_moved 
                  If Not \container
                    If  Not \root\anchor\cursor 
                      Set_Cursor(*this, \root\anchor\id[\root\anchor\index]\cursor)
                      \root\anchor\cursor = 1
                    EndIf
                    
                    result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                  EndIf
              EndSelect
              
            ElseIf Not Buttons
              ; From point anchor
              For i = #Anchors To 0 Step - 1
                If \root\anchor\id[i] And _from_point_(mouse_x, mouse_y, \root\anchor\id[i]) 
                  If i <> #a_moved And Not \root\anchor\cursor
                    If \container And i = 5
                      Set_Cursor(*this, \root\anchor\id[#a_moved]\cursor)
                    Else
                      Set_Cursor(*this, \root\anchor\id[i]\cursor)
                    EndIf
                    \root\anchor\cursor = 1
                  EndIf
                  \root\anchor\id[i]\color\state = 1
                  \root\anchor\index = i
                  Break
                Else
                  \root\anchor\id[i]\color\state = 0
                  If \root\anchor\cursor
                    Set_Cursor(*this, \root\anchor\id[0]\cursor)
                    \root\anchor\cursor = 0
                  EndIf
                EndIf
              Next
            EndIf
            
          Case #PB_EventType_LeftButtonDown  
            If \root\flag\transform
              If a_Set(*this)
              EndIf
              \flag\transform = 1
            EndIf
            
            If \flag\transform
              If _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                \root\anchor\delta\x = mouse_x-\root\anchor\id[\root\anchor\index]\x
                \root\anchor\delta\y = mouse_y-\root\anchor\id[\root\anchor\index]\y
                \root\anchor\id[\root\anchor\index]\color\state = #s_2
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            If \flag\transform
              If \root\anchor\cursor And Not _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                Set_Cursor(*this, \root\anchor\id[0]\cursor)
                \root\anchor\cursor = 0
              EndIf
              
              \root\anchor\id[\root\anchor\index]\color\state = 0
              \root\anchor\index = 0
            EndIf
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn result
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
            Protected *Widget._S_widget = GetGadgetData(\root\canvas)
            
            If CallBack(\childrens(), #PB_EventType_LeftButtonDown, WindowMouseX(\root\window), WindowMouseY(\root\window))
              ; If \childrens()\index[#s_2] <> \childrens()\index[#s_1]
              *Widget\index[#s_2] = \childrens()\index[#s_1]
              Post(#PB_EventType_Change, *Widget, \childrens()\index[#s_1])
              
              SetText(*Widget, GetItemText(\childrens(), \childrens()\index[#s_1]))
              \childrens()\index[#s_2] = \childrens()\index[#s_1]
              ;\childrens()\mouse\buttons = 0
              \childrens()\index[#s_1] =- 1
              \childrens()\focus = 1
              ;\mouse\buttons = 0
              ReDraw(*this)
              ; EndIf
            EndIf
            
            SetActiveGadget(*Widget\root\canvas)
            *Widget\color\state = 0
            ;*Widget\box\checked = 0
            SetActive(*Widget)
            ReDraw(*Widget\root)
            HideWindow(\root\window, 1)
            
          Case #PB_Event_Gadget
            mouse_x = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseX)
            mouse_y= GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseY)
            
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
        X = \x+GadgetX(\root\canvas, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\root\canvas, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas))
        
        ForEach *Widget\childrens()\items()
          If *Widget\childrens()\items()\text\change = 1
            *Widget\childrens()\items()\text\height = TextHeight("A")
            *Widget\childrens()\items()\text\width = TextWidth(*Widget\childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\childrens()\scroll\width < (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
            *Widget\childrens()\scroll\width = (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
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
        ResizeWindow(*Widget\root\window, x, y, width, Height)
        ResizeGadget(*Widget\root\canvas, #PB_Ignore, #PB_Ignore, width, Height)
      EndIf
    EndWith
    
    ReDraw(*Widget)
    
    HideWindow(*Widget\root\window, 0, #PB_Window_NoActivate)
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
          X = *Widget\x+GadgetX(*Widget\root\canvas, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\root\canvas, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        If IsWindow(*Widget\root\window)
          Protected WindowID = WindowID(*Widget\root\window)
        EndIf
        
        \root\parent = *Widget
        \root\window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \root\canvas = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(\root, 1,1, width, Height)
        
        SetWindowData(\root\window, *this)
        SetGadgetData(\root\canvas, *Widget)
        
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \root\window);, \gadget )
        BindGadgetEvent(\root\canvas, @CallBack_Popup())
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
  
  Procedure.i Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
    With *Scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\bar\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len) : EndIf
      If \h\bar\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\bar\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\radius And \h\radius)*(\v\bar\button\len/4+1), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\v\radius And \h\radius)*(\h\bar\button\len/4+1))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
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
      ElseIf (\scroll\x < 0 And \root\keyboard\input = 65535 ) : \root\keyboard\input = 0
        \scroll\x = (Width-\items()\text[3]\width) + Right
        If \scroll\x>0 : \scroll\x=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  ; SET_
  Procedure.i Set_State(*this._S_widget, List *this_item._S_items(), State.i)
    Protected Repaint.i, sublevel.i, Mouse_X.i, Mouse_Y.i
    
    With *this
      If ListSize(*this_item())
        Mouse_X = \root\mouse\x
        Mouse_Y = \root\mouse\y
        
        If State >= 0 And SelectElement(*this_item(), State) 
          If (Mouse_Y > (*this_item()\box[1]\y) And Mouse_Y =< ((*this_item()\box[1]\y+*this_item()\box[1]\height))) And 
             ((Mouse_X > *this_item()\box[1]\x) And (Mouse_X =< (*this_item()\box[1]\x+*this_item()\box[1]\width)))
            
            *this_item()\box[1]\checked ! 1
          ElseIf (\flag\buttons And *this_item()\childrens) And
                 (Mouse_Y > (*this_item()\box[0]\y) And Mouse_Y =< ((*this_item()\box[0]\y+*this_item()\box[0]\height))) And 
                 ((Mouse_X > *this_item()\box[0]\x) And (Mouse_X =< (*this_item()\box[0]\x+*this_item()\box[0]\width)))
            
            sublevel = *this_item()\sublevel
            *this_item()\box[0]\checked ! 1
            \change = 1
            
            PushListPosition(*this_item())
            While NextElement(*this_item())
              If sublevel = *this_item()\sublevel
                Break
              ElseIf sublevel < *this_item()\sublevel And *this_item()\i_Parent
                *this_item()\hide = Bool(*this_item()\i_Parent\box[0]\checked | *this_item()\i_Parent\hide)
              EndIf
            Wend
            PopListPosition(*this_item())
            
          ElseIf \index[#s_2] <> State : *this_item()\state = 2
            If \index[#s_2] >= 0 And SelectElement(*this_item(), \index[#s_2])
              *this_item()\state = 0
            EndIf
            ; GetState() - Value = \index[#s_2]
            \index[#s_2] = State
            
            Debug "set_state() - "+State;\index[#s_1]+" "+ListIndex(\items())
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
          mouse_x = \root\mouse\x - (\items()\text\x+\scroll\x)
          
          If StartDrawing(CanvasOutput(\root\canvas)) 
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
            ;             If \root\mouse\y < \y+(\text\height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\mouse\y-\y-\text\y)-\scroll\y) / (\text\height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \index[#s_1] Or LastItem <> Item
            ;               \items()\text[2]\width[2] = 0
            ;               
            ;               If (\items()\text\string.s = "" And Item = \index[#s_1] And Position = len) Or
            ;                  \index[#s_2] > \index[#s_1] Or                                            ; Если выделяем снизу вверх
            ;                  (\index[#s_2] =< \index[#s_1] And \index[#s_1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\index[#s_2] < \index[#s_1] And                                          ; Если выделяем сверху вниз
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
            ;               LastLine = \index[#s_1]
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
      If (\index[#s_2] > \index[#s_1] Or \index[#s_2] = \items()\index)
        \text[1]\change = #True
      EndIf
      If (\index[#s_2] < \index[#s_1] Or \index[#s_2] = \items()\index) 
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
      ;Debug "7777    "+\text\caret +" "+ \text\caret[1] +" "+\index[#s_1] +" "+ \index[#s_2] +" "+ \items()\text\string
      
      If (Caret <> \text\caret Or Line <> \index[#s_1] Or (\text\caret[1] >= 0 And Caret1 <> \text\caret[1]))
        \items()\text[2]\string.s = ""
        
        PushListPosition(\items())
        If \index[#s_2] = \index[#s_1]
          If \text\caret[1] = \text\caret And \items()\text[2]\len 
            \items()\text[2]\len = 0 
            \items()\text[2]\width = 0 
          EndIf
          If PreviousElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\width[2] = 0 
            \items()\text[2]\len = 0 
          EndIf
        ElseIf \index[#s_2] > \index[#s_1]
          If PreviousElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\len = 0 
          EndIf
        Else
          If NextElement(\items()) And \items()\text[2]\len 
            \items()\text[2]\len = 0 
          EndIf
        EndIf
        PopListPosition(\items())
        
        If \index[#s_2] = \index[#s_1]
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
        ElseIf \index[#s_2] > \index[#s_1]
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
        
        Line = \index[#s_1]
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
        Protected mouse_x.i = \root\mouse\x-(\items()\text\x+\scroll\x)
        
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
        ElseIf (\scroll\x < 0 And \root\keyboard\input = 65535 ) : \root\keyboard\input = 0
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
      If \index[#s_1] <> \index[#s_2] ; Это значить строки выделени
        If \index[#s_2] > \index[#s_1] : Swap \index[#s_2], \index[#s_1] : EndIf
        
        Editor_SelReset(*this)
        
        If Count
          \index[#s_2] + Count
          \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \index[#s_2] + 1
          \text\caret = 0
        Else
          \text\caret = \items()\text[1]\len + Len(Chr.s)
        EndIf
        
        \text\caret[1] = \text\caret
        \index[#s_1] = \index[#s_2]
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
            \index[#s_2] + Count
            \index[#s_1] = \index[#s_2] 
            \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret + Len(Chr.s) 
          EndIf
          
          \text\string.s[1] = \text[1]\string + Chr.s + \text[3]\string
          \text\caret[1] = \text\caret 
          ; \countItems = CountString(\text\string.s[1], #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\items(), \index[#s_2]) 
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
        
        
        ; _this_\scroll\v\bar\max = _this_\scroll\height
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
        
        
        ; _this_\scroll\h\bar\max = _this_\scroll\width
        ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
      EndIf
    EndMacro
    
    Macro _set_content_Y_(_this_)
      If _this_\image\handle
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
      If _this_\image\handle
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
      
      \items()\index[#s_1] =- 1
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
      
      If \index[#s_2] = ListIndex(\items())
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
                \items()\index[#s_1] =- 1
                
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
                    \items()\index[#s_1] =- 1
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
              Debug "RegularExpressionError"+RegularExpressionError()
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
            ;                 \items()\index[#s_1] =- 1
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
            Debug "RegularExpressionError"+RegularExpressionError()
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
          PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Resize, \resize)
          
          CompilerIf Defined(Bar, #PB_Module)
            ;  Resizes(\scroll, \x[2]+\margin\width,\y[2],\width[2]-\margin\width,\height[2])
            Resizes(\scroll, \x[2],\y[2],\width[2],\height[2])
            \scroll\width[2] = *this\scroll\h\bar\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
            \scroll\height[2] = *this\scroll\v\bar\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
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
          If \text\change And \index[#s_2] >= 0 And \index[#s_2] < ListSize(\items())
            SelectElement(\items(), \index[#s_2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \scroll\v And \scroll\v\bar\max <> \scroll\height And 
                 SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\gridLines)) 
                
                \scroll\v\bar\scrollstep = \text\height
                
                If \text\editable And (\items()\y >= (\scroll\height[2]-\items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
                EndIf
                
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\bar\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\bar\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                
                If \scroll\v\hide 
                  \scroll\width[2] = \width[2]
                  \items()\width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\scroll\v\hide +" "+ \scroll\height
                EndIf
              EndIf
              
              If \scroll\h And \scroll\h\bar\max<>\scroll\width And 
                 SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\bar\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\bar\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                                                               ;  \scroll\width[2] = \width[2] - Bool(Not \scroll\v\hide)*\scroll\v\width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \root\keyboard\input And \items()\text\x+\items()\text\width > \items()\x+\items()\width
                Debug "input editor "+\scroll\h\bar\max +" "+ Str(\items()\text\x+\items()\text\width)
                
                If \scroll\h\bar\max = (\items()\text\x+\items()\text\width)
                  SetState(\scroll\h, \scroll\h\bar\max)
                Else
                  SetState(\scroll\h, \scroll\h\bar\page\pos + TextWidth(Chr(\root\keyboard\input)))
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
            PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Change)
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
            If \index[#s_1] =- 1
              \text\caret[2] = 0
            ElseIf \index[#s_1] = ListSize(\items())
              \text\caret[2] = \items()\text\width
            ElseIf \items()\text\len = \items()\text[2]\len
              \text\caret[2] = \items()\text\width
            EndIf
            
            ;             If Caret<>\text\caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \text\caret[2] +" "+\index[#s_1] +" "+\index[#s_2]
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
          
          If (\focus And \root\mouse\buttons And (Not \scroll\v\from And Not \scroll\h\from)) 
            Protected Left = Editor_Move(*this, \items()\width)
          EndIf
        EndIf
        
        ; Draw back color
        If \color\fore[_S_widgettate]
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[_S_widgettate],\color\back[_S_widgettate],\radius)
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
            If Drawing And (\index=*this\index[#s_1] Or \index=\index[#s_1]) ; Or \index=\focus Item_state;
              If *this\color\back[Item_state]<>-1                            ; no draw transparent
                If *this\color\fore[Item_state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  _box_gradient_(\Vertical,*this\x[2],Y,iwidth,\height,*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24, *this\color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24) ;*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24 ,RowBackColor(*this, Item_state) ,\radius)
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
              ;               If Bool(\index = *this\index[#s_2])
              ;                 State_3 = 2
              ;               Else
              ;                 State_3 = Bool(\index = *this\index[#s_1])
              ;               EndIf
              ;               
              ;               ; Draw selections
              ;               If *this\flag\fullSelection
              ;                 If State_3 = 1
              ;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+1+*this\scroll\h\bar\page\pos,\y+1,\width-2,\height-2, *this\color\back[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                   
              ;                   DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+*this\scroll\h\bar\page\pos,\y,\width,\height, *this\color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                 EndIf
              ;                 
              ;                 If State_3 = 2
              ;                   If *this\focus : item_alpha = 200
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\scroll\h\bar\page\pos,\y+1,\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\scroll\h\bar\page\pos,\y,\width,\height, $DC9338&back_color|item_alpha<<24)
              ;                   Else
              ;                     ;If \flag\alwaysSelection
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\scroll\h\bar\page\pos,\y+1,\width-2,\height-2, $E2E2E2&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\scroll\h\bar\page\pos,\y,\width,\height, $C8C8C8&back_color|item_alpha<<24)
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
                  If (*this\text\caret[1] > *this\text\caret And *this\index[#s_2] = *this\index[#s_1]) Or
                     (\index = *this\index[#s_1] And *this\index[#s_2] > *this\index[#s_1])
                    \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
                    
                    If *this\index[#s_2] = *this\index[#s_1]
                      \text[2]\x = \text[3]\x-\text[2]\width
                    EndIf
                    
                    If \text[3]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\text[3]\x+*this\scroll\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *this\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
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
                      _box_gradient_(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
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
                    _box_gradient_(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,*this\color\fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\radius)
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
        If \image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\items()) And (\text\editable Or \items()\text\editable) And \focus : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\items()\text\x+\scroll\x) + \text\caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \scroll\x), \items()\y+\scroll\y, 1, Height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \scroll\v And \scroll\v\bar\max <> \scroll\height And 
          ;              SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\gridLines))
          ;             Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \scroll\h And \scroll\h\bar\max<>\scroll\width And 
          ;              SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
          ;             Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Draw(\scroll\v)
          Draw(\scroll\h)
          ; (_this_\margin\width + (_this_\sublevellen -Bool(_this_\scroll\h\radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*this\scroll\h\x-GetState(*this\scroll\h), *this\scroll\v\y-GetState(*this\scroll\v), *this\scroll\h\bar\max, *this\scroll\v\bar\max, $FF0000)
          Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len, $FF00FF00)
          Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\area\len, *this\scroll\v\bar\area\len, $FF00FFFF)
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
      If (\index[#s_2] > 0 And \index[#s_1] = \index[#s_2]) : \index[#s_2] - 1 : \index[#s_1] = \index[#s_2]
        SelectElement(\items(), \index[#s_2])
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
    Protected Repaint, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If Shift
        
        If \index[#s_1] = \index[#s_2]
          SelectElement(\items(), \index[#s_1]) 
          Editor_Change(*this, \text\caret[1], \items()\text\len-\text\caret[1])
        Else
          SelectElement(\items(), \index[#s_2]) 
          Editor_Change(*this, 0, \items()\text\len)
        EndIf
        ; Debug \text\caret[1]
        \index[#s_2] + 1
        ;         \text\caret = Editor_Caret(*this, \index[#s_2]) 
        ;         \text\caret[1] = \text\caret
        SelectElement(\items(), \index[#s_2]) 
        Editor_Change(*this, 0, \text\caret[1]) 
        Editor_SelText(*this)
        Repaint = 1 
        
      Else
        If (\index[#s_1] < ListSize(\items()) - 1 And \index[#s_1] = \index[#s_2]) : \index[#s_2] + 1 : \index[#s_1] = \index[#s_2]
          SelectElement(\items(), \index[#s_2]) 
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
    Protected Repaint.i, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      If \items()\text[2]\len And Not Shift
        If \index[#s_2] > \index[#s_1] 
          Swap \index[#s_2], \index[#s_1]
          
          If SelectElement(\items(), \index[#s_2]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
            \items()\text[1]\change = #True
          EndIf
        ElseIf \index[#s_1] > \index[#s_2] And 
               \text\caret[1] > \text\caret
          Swap \text\caret[1], \text\caret
        ElseIf \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf
        
        If \index[#s_1] <> \index[#s_2]
          Editor_SelReset(*this)
          \index[#s_1] = \index[#s_2]
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
    Protected Repaint.i, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      ;       If \index[#s_1] <> \index[#s_2]
      ;         If Shift 
      ;           \text\caret + 1
      ;           Swap \index[#s_2], \index[#s_1] 
      ;         Else
      ;           If \index[#s_1] > \index[#s_2] 
      ;             Swap \index[#s_1], \index[#s_2] 
      ;             Swap \text\caret, \text\caret[1]
      ;             
      ;             If SelectElement(\items(), \index[#s_2]) 
      ;               \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
      ;               \items()\text[1]\change = #True
      ;             EndIf
      ;             
      ;             Editor_SelReset(*this)
      ;             \text\caret = \text\caret[1] 
      ;             \index[#s_1] = \index[#s_2]
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
        If \index[#s_1] > \index[#s_2] 
          Swap \index[#s_1], \index[#s_2] 
          Swap \text\caret, \text\caret[1]
          
          If SelectElement(\items(), \index[#s_2]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret[1]) 
            \items()\text[1]\change = #True
          EndIf
          
          ;           Editor_SelReset(*this)
          ;           \text\caret = \text\caret[1] 
          ;           \index[#s_1] = \index[#s_2]
        EndIf
        
        If \index[#s_1] <> \index[#s_2]
          Editor_SelReset(*this)
          \index[#s_1] = \index[#s_2]
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
      If \root\keyboard\input
        Repaint = Editor_Insert(*this, Chr(\root\keyboard\input))
        
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
        \index[#s_2] + 1
        \text\caret = 0
        \index[#s_1] = \index[#s_2]
        \text\caret[1] = \text\caret
        \text\change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i Editor_ToBack(*this._S_widget)
    Protected Repaint, String.s, Cut.i
    
    If *this\root\keyboard\input : *this\root\keyboard\input = 0
      Editor_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    *this\root\keyboard\input = 65535
    
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
          If \index[#s_2] > 0 
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
          If \index[#s_2] < (\countItems-1) ; ListSize(\items()) - 1
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
        
        \index[#s_1] = \items()\index
        SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
      Else
        SelectElement(\items(), \index[#s_1]) 
        \text\caret = Bool(Pos =- 1) * \items()\text\len 
        SetState(\scroll\h, Bool(Pos =- 1) * \scroll\h\bar\max)
      EndIf
      
      \text\caret[1] = \text\caret
      \index[#s_2] = \index[#s_1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Editable(*this._S_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *this
      Shift = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\root\keyboard\key[1] & #PB_Canvas_Control) Or (\root\keyboard\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
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
          Select \root\keyboard\key
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
                \index[#s_2] = 0 : \index[#s_1] = ListSize(\items()) - 1
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
                
                If \root\keyboard\key = #PB_Shortcut_X
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
      
      If \index[#s_1] <> Line And Line =< ListSize(\items())
        If isItem(\index[#s_1], \items()) 
          If \index[#s_1] <> ListIndex(\items())
            SelectElement(\items(), \index[#s_1]) 
          EndIf
          
          If \index[#s_1] > Line
            \text\caret = 0
          Else
            \text\caret = \items()\text\len
          EndIf
          
          Repaint | Editor_SelText(*this)
        EndIf
        
        \index[#s_1] = Line
      EndIf
      
      If isItem(Line, \items()) 
        \text\caret = Editor_Caret(*this, Line) 
        Repaint | Editor_SelText(*this)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\items()) 
      ForEach \items()
        If (\index[#s_1] = \items()\index Or \index[#s_2] = \items()\index)
          \items()\text[2]\change = 1
          \items()\text[2]\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\index[#s_2] < \index[#s_1] And \index[#s_2] < \items()\index And \index[#s_1] > \items()\index) Or
                (\index[#s_2] > \index[#s_1] And \index[#s_2] > \items()\index And \index[#s_1] < \items()\index)) 
          
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
            If \root\mouse\buttons
              If \root\mouse\y < \y
                Item.i =- 1
              Else
                Item.i = ((\root\mouse\y-\y-\scroll\y) / \text\height)
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
                    \index[#s_1] = \items()\index 
                    \index[#s_2] = \index[#s_1]
                    
                    PushListPosition(\items())
                    ForEach \items() 
                      If \index[#s_2] <> ListIndex(\items())
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
                If \root\mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = Editor_SelSet(*this, Item)
                EndIf
                
              Default
                itemSelect(\index[#s_2], \items())
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
      
      If \root\canvas And StartDrawing(CanvasOutput(\root\canvas)) 
        If FontID : DrawingFont(FontID) : EndIf
        
        For i = 0 To Len
          CursorX = X + TextWidth(Left(String.s, i))
          Distance = (\root\mouse\x-CursorX)*(\root\mouse\x-CursorX)
          
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
      If Caret <> *this\text\caret Or Line <> *this\index[#s_1] Or (*this\text\caret[1] >= 0 And Caret1 <> *this\text\caret[1])
        \text[2]\string.s = ""
        
        If *this\index[#s_2] = *this\index[#s_1]
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
            If *this\index[#s_1] > *this\index[#s_2]
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
        
        Line = *this\index[#s_1]
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
      If \root\keyboard\input
        Chr.s = Text_Make(*this, Chr(\root\keyboard\input))
        
        If Chr.s
          If \text[2]\len 
            String_Remove(*this)
          EndIf
          
          \text\caret + 1
          ; \items()\text\string.s[1] = \items()\text[1]\string.s + Chr(\root\keyboard\input) + \items()\text[3]\string.s ; сним не выравнивается строка при вводе слов
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
    
    If *this\root\keyboard\input : *this\root\keyboard\input = 0
      String_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    
    With *this
      \root\keyboard\input = 65535
      
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
  
  Procedure String_Events(*this._S_widget, EventType.i, mouse_x.i, mouse_y.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *this
      *this\index[#s_1] = 0
      
      With *this
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If \root\canvas And #PB_Cursor_Default = GetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor)
              SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, *this\cursor)
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
                  SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
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
            If *this\root\mouse\buttons & #PB_Canvas_LeftButton 
              Caret = String_Caret(*this)
              If *this\text\caret <> Caret
                
                If \text\caret[2] ; *this\cursor <> GetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor)
                  If \text\caret[2] < Caret + 1 And Caret + 1 < \text\caret[2] + \text[2]\len
                    SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
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
          Control = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Command)
        CompilerElse
          Control = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Control)
        CompilerEndIf
        
        Select EventType
          Case #PB_EventType_Input
            If Not Control
              Repaint = String_ToInput(*this)
            EndIf
            
          Case #PB_EventType_KeyUp
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *this\root\keyboard\key
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
  
  ;-
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
          If (*this\text\caret[1] > *this\text\caret And *this\index[#s_2] = *this\index[#s_1]) Or
             (\index = *this\index[#s_1] And *this\index[#s_2] > *this\index[#s_1])
            \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
            
            If *this\index[#s_2] = *this\index[#s_1]
              \text[2]\x = \text[3]\x-\text[2]\width
            EndIf
            
            If \text[3]\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\text[3]\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
            EndIf
            
            If *this\color\fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
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
              _box_gradient_(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
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
            _box_gradient_(\Vertical,\text[2]\x, Y, \text[2]\width+\text[2]\width[2], Height,\color\fore[2]&$FFFFFF|\color\alpha<<24,\color\back[2]&$FFFFFF|\color\alpha<<24,\radius)
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
  
  ;-
  Procedure.i Draw_Scroll(*this._S_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\bar\area\pos+\bar\area\len) +" "+ \box[#bb_2]\x
      ;       Debug ""+Str(\bar\area\pos+\bar\area\len) +" "+ \box[#bb_2]\y
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
        If \bar\Vertical
          Line( \x, \y, 1, \bar\page\len + Bool(\height<>\bar\page\len), \color\line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \x, \y, \bar\page\len + Bool(\width<>\bar\page\len), 1, \color\line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \bar\thumb\len 
        ; Draw thumb  
        If \color[3]\back[State_3]<>-1
          If \color[3]\fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[#bb_3]\x, \bar\button[#bb_3]\y, \bar\button[#bb_3]\width, \bar\button[#bb_3]\height, \color[3]\fore[State_3], \color[3]\back[State_3], \radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \color[3]\frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \bar\button[#bb_3]\x, \bar\button[#bb_3]\y, \bar\button[#bb_3]\width, \bar\button[#bb_3]\height, \radius, \radius, \color[3]\frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \bar\button[#bb_1]\len
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[1]\x, \bar\button[1]\y, \bar\button[1]\width, \bar\button[1]\height, \color[1]\fore[State_1], \color[1]\back[State_1], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[1]\frame[State_1]
          RoundBox( \bar\button[1]\x, \bar\button[1]\y, \bar\button[1]\width, \bar\button[1]\height, \radius, \radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \bar\button[1]\x+( \bar\button[1]\width-\bar\button[1]\arrow\size)/2, \bar\button[1]\y+( \bar\button[1]\height-\bar\button[1]\arrow\size)/2, \bar\button[1]\arrow\size, Bool( \bar\vertical),
               (Bool(Not _bar_in_start_(*this\bar)) * \color[1]\front[State_1] + _bar_in_start_(*this\bar) * \color[1]\frame[0])&$FFFFFF|Alpha, \bar\button[1]\arrow\type)
      EndIf
      
      If \bar\button[#bb_2]\len
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width, \bar\button[#bb_2]\height, \color[2]\fore[State_2], \color[2]\back[State_2], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[2]\frame[State_2]
          RoundBox( \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width, \bar\button[#bb_2]\height, \radius, \radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \bar\button[#bb_2]\x+( \bar\button[#bb_2]\width-\bar\button[2]\arrow\size)/2, \bar\button[#bb_2]\y+( \bar\button[#bb_2]\height-\bar\button[2]\arrow\size)/2, \bar\button[2]\arrow\size, Bool( \bar\Vertical)+2, 
               (Bool(Not _bar_in_stop_(*this\bar)) * \color[2]\front[State_2] + _bar_in_stop_(*this\bar) * \color[2]\frame[0])&$FFFFFF|Alpha, \bar\button[2]\arrow\type)
      EndIf
      
      If \bar\thumb\len And \color[3]\fore[State_3]<>-1  ; Draw thumb lines
        If \focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \bar\button[2]\arrow\size
        
        If \bar\Vertical
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2-3,size,1, LinesColor)
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2,size,1, LinesColor)
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2+3,size,1, LinesColor)
        Else
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2-3, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2+3, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Progress(*this._S_widget)
    With *this 
      ; Draw progress
      If \bar\vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x+2,\y,\width-4,\bar\thumb\pos, \radius, \radius,\color[3]\back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\x+2,\y+2,\width-4,\bar\thumb\pos-2, \radius, \radius,\color[3]\frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x+2,\bar\thumb\pos+\y,\width-4,(\height-\bar\thumb\pos), \radius, \radius,\color[3]\back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\bar\page\pos)))/2, "%"+Str(\bar\page\pos), Bool(\bar\vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\bar\thumb\pos,\y+2,\width-(\bar\thumb\pos-\x),\height-4, \radius, \radius,\color[3]\back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\bar\thumb\pos,\y+2,\width-(\bar\thumb\pos-\x)-2,\height-4, \radius, \radius,\color[3]\frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x,\y+2,(\bar\thumb\pos-\x),\height-4, \radius, \radius,\color[3]\back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\bar\page\pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\bar\page\pos),0)
        
        ;Debug ""+\x+" "+\bar\thumb\pos
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
  
  Procedure.i Draw_Track(*this._S_widget)
    With *this 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*this\x[0],*this\y[0],*this\width[0],*this\height[0],\color[0]\back)
      
      If \bar\vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x[0]+5,\y[0],a,\height[0],\color[3]\frame)
        Box(\x[0]+5,\y[0]+\bar\thumb\pos,a,(\y+\height)-\bar\thumb\pos,\color[3]\back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x[0],\y[0]+5,\width[0],a,\color[3]\frame)
        Box(\x[0],\y[0]+5,\bar\thumb\pos-\x,a,\color[3]\back[2])
      EndIf
      
      If \bar\vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,\bar\button[#bb_3]\width/2,\bar\button[#bb_3]\height,\color[3]\back[\color[3]\state])
        
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,1,\bar\button[#bb_3]\height,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,\bar\button[#bb_3]\width/2,1,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height-1,\bar\button[#bb_3]\width/2,1,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2,\bar\button[#bb_3]\y,\bar\button[#bb_3]\width/2,\bar\button[#bb_3]\height/2+1,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height-1,\bar\button[#bb_3]\width/2,-\bar\button[#bb_3]\height/2-1,\color[3]\frame[\color[3]\state])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,\bar\button[#bb_3]\width,\bar\button[#bb_3]\height/2,\color[3]\back[\color[3]\state])
        
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,\bar\button[#bb_3]\width,1,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y,1,\bar\button[#bb_3]\height/2,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x+\bar\button[#bb_3]\width-1,\bar\button[#bb_3]\y,1,\bar\button[#bb_3]\height/2,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2,\bar\button[#bb_3]\width/2+1,\bar\button[#bb_3]\height/2,\color[3]\frame[\color[3]\state])
        Line(\bar\button[#bb_3]\x+\bar\button[#bb_3]\width-1,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2,-\bar\button[#bb_3]\width/2-1,\bar\button[#bb_3]\height/2,\color[3]\frame[\color[3]\state])
      EndIf
      
      If \mode
        Protected ii.f, _thumb_ = (\bar\thumb\len/2-2)
        For i=0 To \bar\page\end
          ii = (\bar\area\pos + Round(((i)-\bar\min) * (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)) + _thumb_
          LineXY(\x+ii,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height-1,\x+ii,\bar\button[#bb_3]\y+\bar\button[#bb_3]\height-4,\color[3]\frame)
        Next
        
        ;         Protected PlotStep = 5;(\width)/(\bar\max-\bar\min)
        ;         
        ;         For i=3 To (\width-PlotStep)/2 
        ;           If Not ((\x+i-3)%PlotStep)
        ;             Box(\x+i, \y[3]+\bar\button[#bb_3]\height-4, 1, 4, $FF808080)
        ;           EndIf
        ;         Next
        ;         For i=\width To (\width-PlotStep)/2+3 Step - 1
        ;           If Not ((\x+i-6)%PlotStep)
        ;             Box(\x+i, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height-4, 1, 4, $FF808080)
        ;           EndIf
        ;         Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*this._S_widget)
    Protected.i State_0, State_3, Alpha
    
    With *this 
      State_0 = \color\state
      Alpha = \color\alpha<<24
      
      ; Draw scroll bar background
      If \color\back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      Line(\bar\button[#bb_1]\x-2, \y[2],1,\height[2], \color\frame&$FFFFFF|Alpha)
      RoundBox( \x[2]+\width[2]-16, \y[2], 16, \height[2], \radius, \radius, $F0F0F0&$FFFFFF|Alpha)
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string, \color\front[State_0]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*this._S_widget)
      
      If \bar\button\len
        Protected Radius = (\height[2]/2)
        If Radius > 6
          Radius = 7
        Else
          Radius = 3
        EndIf
        
        ; Draw buttons
        If \bar\button[#bb_1]\color\back[\bar\button[#bb_1]\color\state]<>-1
          If \bar\button[#bb_1]\color\fore[\bar\button[#bb_1]\color\state]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\Vertical, \bar\button[#bb_1]\x, \bar\button[#bb_1]\y, \bar\button[#bb_1]\width,
                          \bar\button[#bb_1]\height, \bar\button[#bb_1]\color\fore[\bar\button[#bb_1]\color\state], 
                          \bar\button[#bb_1]\color\back[\bar\button[#bb_1]\color\state], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \bar\button[#bb_2]\color\back[\bar\button[#bb_2]\color\state]<>-1
          If \bar\button[#bb_2]\color\fore[\bar\button[#bb_2]\color\state]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\Vertical, \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width,
                          \bar\button[#bb_2]\height, \bar\button[#bb_2]\color\fore[\bar\button[#bb_2]\color\state], 
                          \bar\button[#bb_2]\color\back[\bar\button[#bb_2]\color\state], Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \bar\button[#bb_1]\color\frame[\bar\button[#bb_1]\color\state]
          RoundBox( \bar\button[#bb_1]\x, \bar\button[#bb_1]\y, \bar\button[#bb_1]\width, 
                    \bar\button[#bb_1]\height, Radius, Radius, \bar\button[#bb_1]\color\frame[\bar\button[#bb_1]\color\state]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw buttons frame
        If \bar\button[#bb_2]\color\frame[\bar\button[#bb_2]\color\state]
          RoundBox( \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width,
                    \bar\button[#bb_2]\height, Radius, Radius, \bar\button[#bb_2]\color\frame[\bar\button[#bb_2]\color\state]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \bar\button[#bb_1]\x+( \bar\button[#bb_1]\width-\bar\button[#bb_1]\arrow\size)/2, 
               \bar\button[#bb_1]\y+( \bar\button[#bb_1]\height-\bar\button[#bb_1]\arrow\size)/2, 
               \bar\button[#bb_1]\arrow\size, Bool(\bar\Vertical)*3,
               (Bool(Not _bar_in_start_(*this\bar)) * \bar\button[#bb_1]\color\front[\bar\button[#bb_1]\color\state] +
                _bar_in_start_(*this\bar) * \bar\button[#bb_1]\color\frame[0])&$FFFFFF|Alpha, \bar\button[#bb_1]\arrow\type)
        
        ; Draw arrows
        Arrow( \bar\button[#bb_2]\x+( \bar\button[#bb_2]\width-\bar\button[#bb_2]\arrow\size)/2, 
               \bar\button[#bb_2]\y+( \bar\button[#bb_2]\height-\bar\button[#bb_2]\arrow\size)/2,
               \bar\button[#bb_2]\arrow\size, Bool(Not \bar\Vertical)+1, 
               (Bool(Not _bar_in_stop_(*this\bar)) * \bar\button[#bb_2]\color\front[\bar\button[#bb_2]\color\state] + 
                _bar_in_stop_(*this\bar) * \bar\button[#bb_2]\color\frame[0])&$FFFFFF|Alpha, \bar\button[#bb_2]\arrow\type)
        
        
      EndIf      
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Draw_Image(*this._S_widget)
    With *this 
      
      ClipOutput(\x[2],\y[2],\scroll\h\bar\page\len,\scroll\v\bar\page\len)
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
      
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
      Box(\h\x-\h\bar\page\pos, \v\y-\v\bar\page\pos, \h\bar\max, \v\bar\max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\bar\page\len, \v\bar\page\len, $00FF00)
    EndWith
  EndProcedure
  
  Procedure.i Draw_Frame(*this._S_widget)
    With *this 
      If \text\string.s
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ;       ; Draw background image
      ;       If \image[1]\handle
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      ;       EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \__height/2
        Box(\x[1], \y+h, 6, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\text\x+\text\width+3, \y+h, \width[1]-((\text\x+\text\width)-\x)-3, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[1], \y[1]-h, \fs, \height[1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1]+\width[1]-\fs, \y[1]-h, \fs, \height[1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1], \y[1]+\height[1]-\fs, \width[1], \fs, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Combobox(*this._S_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      If \combo_box\checked
        State = 2
      EndIf
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \bar\vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4]-\combo_box\width-\text\x[2],\height[#c_4])
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
      EndIf
      
      \combo_box\x = \x+\width-\combo_box\width -\combo_box\arrow\size/2
      \combo_box\height = \height[2]
      \combo_box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\combo_box\x+(\combo_box\width-\combo_box\arrow\size)/2, \combo_box\y+(\combo_box\height-\combo_box\arrow\size)/2, \combo_box\arrow\size, Bool(\combo_box\checked)+2, \color\front[State]&$FFFFFF|Alpha, \combo_box\arrow\type)
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  ;-
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
          If \scroll And \scroll\v\bar\max And \change > 0
            \scroll\v\bar\max = \scroll\height
            ; \scroll\v\bar\max = \countItems*\text\height
            ; Debug ""+Str(\change*\text\height-\scroll\v\bar\page\len+\scroll\v\bar\thumb\len) +" "+ \scroll\v\bar\max
            If (\change*\text\height-\scroll\v\bar\page\len) <> \scroll\v\bar\page\pos  ;> \scroll\v\bar\max
                                                                                        ; \scroll\v\bar\page\pos = (\change*\text\height-\scroll\v\bar\page\len)
              SetState(\scroll\v, (\change*\text\height-\scroll\v\bar\page\len))
              Debug "tree set state"+\scroll\v\bar\page\pos+" "+Str(\change*\text\height-\scroll\v\bar\page\len)  +" "+\scroll\v\bar\max                                               
              
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
              \items()\width=\scroll\h\bar\page\len
              \items()\x=\scroll\h\x-\scroll\h\bar\page\pos
              \items()\y=(\scroll\v\y+\scroll\height)-\scroll\v\bar\page\pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = \flag\buttons
              \items()\box\height = \flag\buttons
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\handle
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\handle = \items()\image\handle
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box[1]\width = \flag\checkboxes
                \items()\box[1]\height = \flag\checkboxes
                
                \items()\box[1]\x = \items()\x+4
                \items()\box[1]\y = (\items()\y+\items()\height)-(\items()\height+\items()\box[1]\height)/2
              EndIf
              
              \scroll\height+\items()\height
              
              If \scroll\width < (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
                \scroll\width = (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
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
          If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\bar\scrollstep = \text\height
            Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
            Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
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
              \items()\width=\scroll\h\bar\page\len
              If Bool(\items()\index = \index[#s_2])
                State_3 = 2
              Else
                State_3 = Bool(\items()\index = \index[#s_1])
              EndIf
              
              ; Draw selections
              If \flag\fullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
                
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box[0]\x+(\items()\box[0]\width-6)/2,\items()\box[0]\y+(\items()\box[0]\height-6)/2, 6, Bool(Not \items()\box[0]\checked)+2, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
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
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\scroll\v\bar\page\pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-\flag\lines
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_Box(\items()\box[1]\x,\items()\box[1]\y,\items()\box[1]\width,\items()\box[1]\height, 3, \items()\box[1]\checked, checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\handle, \items()\image\x, \items()\image\y, alpha)
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
          Size = \bar\thumb\len
          
          If \Vertical
            Pos = \bar\thumb\pos-y
          Else
            Pos = \bar\thumb\pos-x
          EndIf
          
          
          ; set vertical bar state
          If \scroll\v\bar\max And \change > 0
            If (\change*\text\height-\scroll\h\bar\page\len) > \scroll\h\bar\max
              \scroll\h\bar\page\pos = (\change*\text\height-\scroll\h\bar\page\len)
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
              \items()\width=\scroll\h\bar\page\len
              \items()\x=\scroll\h\x-\scroll\h\bar\page\pos
              \items()\y=(\scroll\v\y+\scroll\height)-\scroll\v\bar\page\pos
              
              If \items()\text\change = 1
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = box_size
              \items()\box\height = box_size
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\handle
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\handle = \items()\image\handle
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box[1]\width = box_1_size
                \items()\box[1]\height = box_1_size
                
                \items()\box[1]\x = \items()\x+4
                \items()\box[1]\y = (\items()\y+\items()\height)-(\items()\height+\items()\box[1]\height)/2
              EndIf
              
              \scroll\height+\items()\height
              
              If \scroll\width < (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
                \scroll\width = (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
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
          If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height)
            Resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
            \scroll\v\bar\scrollstep = \text\height
          EndIf
          
          If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
            Resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
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
              \items()\width = \scroll\h\bar\page\len
              State_3 = \items()\state
              
              ; Draw selections
              If Not \items()\childrens And \flag\fullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box[0]\x+(\items()\box[0]\width-6)/2,\items()\box[0]\y+(\items()\box[0]\height-6)/2, 6, Bool(Not \items()\box[0]\checked)+2, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
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
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\scroll\v\bar\page\pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_Box(\items()\box[1]\x,\items()\box[1]\y,\items()\box[1]\width,\items()\box[1]\height, 3, \items()\box[1]\checked, checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\handle, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4]-(\width-(\bar\thumb\pos-\x)),\height[#c_4])
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\x[#c_4]+(\bar\thumb\pos-\x),\y[#c_4],\width[#c_4]-(\bar\thumb\pos-\x),\height[#c_4])
              
              ;\items()\text[1]\x[1] = 5
              \items()\text[1]\x = \x+\items()\text[1]\x[1]+\bar\thumb\len
              \items()\text[1]\y = \items()\text\y
              ; Draw string
              If \items()\text[1]\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text[1]\x+pos, \items()\text[1]\y, \items()\text[1]\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
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
  
  Procedure.i Draw_ListIcon(*this._S_widget)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*this\flag\gridLines, FirstColumn.i
    
    With *this 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[2]-\scroll\h\bar\page\pos
      Protected start, stop, n
      
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[2]>1;(\box[1]\width+\box[#bb_2]\width+4)
      ForEach \columns()
        FirstColumn = Bool(Not ListIndex(\columns()))
        n = Bool(\flag\checkboxes)*16 + Bool(\image\width)*28
        
        
        y = \y[2]-\scroll\v\bar\page\pos
        \columns()\y = \y+\bs-\fs
        \columns()\height=\__height
        
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
                \columns()\items()\box[1]\width = \flag\checkboxes
                \columns()\items()\box[1]\height = \flag\checkboxes
                
                \columns()\items()\box[1]\x = \x[2] + 4 - \scroll\h\bar\page\pos
                \columns()\items()\box[1]\y = (\columns()\items()\y+\columns()\items()\height)-(\columns()\items()\height+\columns()\items()\box[1]\height)/2
              EndIf
              
              If \columns()\items()\image\handle 
                \columns()\items()\image\x = \columns()\x - \columns()\items()\image\width - 6
                \columns()\items()\image\y = \columns()\items()\y+(\columns()\items()\height-\columns()\items()\image\height)/2
                
                \image\handle = \columns()\items()\image\handle
                \image\width = \columns()\items()\image\width+4
              EndIf
            EndIf
            
            \columns()\items()\text\x = \columns()\text\x
            \columns()\items()\text\y = \columns()\items()\y+(\columns()\items()\height-\columns()\items()\text\height)/2
            \columns()\items()\drawing = Bool(\columns()\items()\y+\columns()\items()\height>\y[2] And \columns()\items()\y<\y[2]+\height[2])
            
            y + \columns()\items()\height + \flag\gridLines + GridLines * 2
          EndIf
          
          If \index[#s_2] = \columns()\items()\index
            State_3 = 2
          Else
            State_3 = \columns()\items()\state
          EndIf
          
          If \columns()\items()\drawing
            ; Draw selections
            If \flag\fullSelection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height, \color\back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, \color\frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \focus
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\alwaysSelection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, $C8C8C8&back_color|Alpha)
                EndIf
              EndIf
            EndIf
            
            If \columns()\drawing 
              ;\columns()\items()\width = \scroll\h\bar\page\len
              
              ; Draw checkbox
              If \flag\checkboxes And FirstColumn
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(\columns()\items()\box[1]\x,\columns()\items()\box[1]\y,\columns()\items()\box[1]\width,\columns()\items()\box[1]\height, 3, 3, \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                
                If \columns()\items()\box[1]\checked = #PB_Checkbox_Checked
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  For i =- 1 To 1
                    LineXY((\columns()\items()\box[1]\x+2),(i+\columns()\items()\box[1]\y+7),(\columns()\items()\box[1]\x+6),(i+\columns()\items()\box[1]\y+8), \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha) 
                    LineXY((\columns()\items()\box[1]\x+9+i),(\columns()\items()\box[1]\y+2),(\columns()\items()\box[1]\x+5+i),(\columns()\items()\box[1]\y+9), \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                  Next
                ElseIf \columns()\items()\box[1]\checked = #PB_Checkbox_Inbetween
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\columns()\items()\box[1]\x+2,\columns()\items()\box[1]\y+2,\columns()\items()\box[1]\width-4,\columns()\items()\box[1]\height-4, 3-2, 3-2, \color\front[Bool(\focus)*State_3]&$FFFFFF|Alpha)
                EndIf
              EndIf
              
              ; Draw image
              If \columns()\items()\image\handle And FirstColumn 
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\columns()\items()\image\handle, \columns()\items()\image\x, \columns()\items()\image\y, 255)
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
              _box_gradient_( \Vertical, \x[2], \columns()\y, n, \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            ElseIf ListIndex(\columns()) = ListSize(\columns()) - 1
              _box_gradient_( \Vertical, \columns()\x+\columns()\width, \columns()\y, 1 + (\width[2]-(\columns()\x-\x[2]+\columns()\width)), \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            EndIf
            
            _box_gradient_( \Vertical, \columns()\x, \columns()\y, \columns()\width, \columns()\height, \color\fore[\columns()\state], Bool(\columns()\state <> 2) * \color\back[\columns()\state] + (Bool(\columns()\state = 2) * \color\front[\columns()\state]), \radius, \color\alpha)
          EndIf
          
          ; Draw string
          If \columns()\text\string
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\columns()\text\x, \columns()\text\y, \columns()\text\string.s, \color\front[0]&$FFFFFF|Alpha)
          EndIf
          
          ; Draw image
          If \columns()\image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\columns()\image\handle, \columns()\image\x, \columns()\image\y, \color\alpha)
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
      
      \scroll\height = (y+\scroll\v\bar\page\pos)-\y[2]-1;\flag\gridLines
                                                         ; set vertical scrollbar max value
      If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
         SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\bar\scrollstep = \text\height
        Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \scroll\width = (x+\scroll\h\bar\page\pos)-\x[2]-Bool(Not \scroll\v\hide)*\scroll\v\width+n
      If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
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
  
  ;-
  Procedure.i Draw_Button(*this._S_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
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
  
  Procedure.i Draw_Checkbox(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      \check_box\x = \x[2]+3
      \check_box\y = \y[2]+(\height[2]-\check_box\height)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \check_box\x,\check_box\y,\check_box\width,\check_box\height, \radius, \radius, \color\back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox( \check_box\x,\check_box\y,\check_box\width,\check_box\height, \radius, \radius, \color\frame[\focus*2]&$FFFFFF|Alpha)
      
      If \check_box\checked = #PB_Checkbox_Checked
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        For i = 0 To 2
          LineXY((\check_box\x+3),(i+\check_box\y+8),(\check_box\x+7),(i+\check_box\y+9), \color\frame[\focus*2]&$FFFFFF|Alpha) 
          LineXY((\check_box\x+10+i),(\check_box\y+3),(\check_box\x+6+i),(\check_box\y+10), \color\frame[\focus*2]&$FFFFFF|Alpha)
        Next
        
      ElseIf \check_box\checked = #PB_Checkbox_Inbetween
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \check_box\x+2,\check_box\y+2,\check_box\width-4,\check_box\height-4, \radius-2, \radius-2, \color\frame[\focus*2]&$FFFFFF|Alpha)
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
      Protected Radius = \option_box\width/2
      \option_box\x = \x[2]+3
      \option_box\y = \y[2]+(\height[2]-\option_box\width)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(\option_box\x, \option_box\y, \option_box\width, \option_box\width, Radius, Radius, \color\back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(\option_box\x+Radius, \option_box\y+Radius, Radius, \color\frame[\focus*2]&$FFFFFF|Alpha)
      
      If \option_box\checked > 0
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Circle(\option_box\x+Radius, \option_box\y+Radius, 2, \color\frame[\focus*2]&$FFFFFFFF|Alpha)
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
  
  ;-
  Procedure.b Draw_Splitter(*this._S_widget)
    Protected Pos, Size, Radius.d = 2
    
    With *this
      If *this > 0
        If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
        If \mode
          Protected *first._S_widget = \splitter\first
          Protected *second._S_widget = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\bar\button[#bb_1]\x,\bar\button[#bb_1]\y,\bar\button[#bb_1]\width,\bar\button[#bb_1]\height,\bar\button\color\frame[\bar\button[#bb_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\bar\button[#bb_2]\x,\bar\button[#bb_2]\y,\bar\button[#bb_2]\width,\bar\button[#bb_2]\height,\bar\button\color\frame[\bar\button[#bb_2]\Color\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \bar\thumb\len/2
          Pos = \bar\thumb\Pos+Size
          
          If \bar\vertical ; horisontal
            Circle(\bar\button\X+((\bar\button\Width-Radius)/2-((Radius*2+2)*2+2)), Pos,Radius,\bar\button\Color\Frame[#s_2])
            Circle(\bar\button\X+((\bar\button\Width-Radius)/2-(Radius*2+2)),       Pos,Radius,\bar\button\Color\Frame[#s_2])
            Circle(\bar\button\X+((\bar\button\Width-Radius)/2),                    Pos,Radius,\bar\button\Color\Frame[#s_2])
            Circle(\bar\button\X+((\bar\button\Width-Radius)/2+(Radius*2+2)),       Pos,Radius,\bar\button\Color\Frame[#s_2])
            Circle(\bar\button\X+((\bar\button\Width-Radius)/2+((Radius*2+2)*2+2)), Pos,Radius,\bar\button\Color\Frame[#s_2])
          Else
            Circle(Pos,\bar\button\Y+((\bar\button\Height-Radius)/2-((Radius*2+2)*2+2)),Radius,\bar\button\Color\Frame[#s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-Radius)/2-(Radius*2+2)),      Radius,\bar\button\Color\Frame[#s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-Radius)/2),                   Radius,\bar\button\Color\Frame[#s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-Radius)/2+(Radius*2+2)),      Radius,\bar\button\Color\Frame[#s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-Radius)/2+((Radius*2+2)*2+2)),Radius,\bar\button\Color\Frame[#s_2])
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  Procedure.i _Draw_Splitter(*this._S_widget)
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
        Size = \bar\thumb\len
        
        If \bar\vertical
          Pos = \bar\thumb\pos-y
        Else
          Pos = \bar\thumb\pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \bar\area\len)
          fColor = \color\frame&$FFFFFF|Alpha;\color[3]\frame[0]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \bar\vertical
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
          If \bar\vertical ; horisontal
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
          If \bar\vertical
            ;box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,\color\frame&$FFFFFF|Alpha)
          Else
            ;box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\color\frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \bar\vertical
        ; ;           ;box(\box[#bb_3]\x, \box[#bb_3]\y+\box[#bb_3]\height-\bar\thumb\len, \box[#bb_3]\width, \bar\thumb\len, $FF0000)
        ; ;           box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;box(\box[#bb_3]\x+\box[#bb_3]\width-\bar\thumb\len, \box[#bb_3]\y, \bar\thumb\len, \box[#bb_3]\height, $FF0000)
        ; ;           box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
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
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \scroll And (\scroll\v And \scroll\h)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\scroll\h\x-GetState(\scroll\h), \scroll\v\y-GetState(\scroll\v), \scroll\h\bar\max, \scroll\v\bar\max, $FFFF0000)
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\bar\page\len, \scroll\v\bar\page\len, $FF00FF00)
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
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Macro _resize_panel_(_this_, _bar_button_, _pos_)
    If _bar_in_start_(_this_\tab\bar)
      _this_\tab\bar\button[#bb_1]\width = 0
    Else
      _this_\tab\bar\button[#bb_1]\width = _this_\tab\bar\button[#bb_1]\len 
    EndIf
    
    If _bar_in_stop_(_this_\tab\bar)
      _this_\tab\bar\button[#bb_2]\width = 0
    Else
      _this_\tab\bar\button[#bb_2]\width = _this_\tab\bar\button[#bb_2]\len 
    EndIf
    
    _this_\tab\bar\button[#bb_3]\x = _this_\x[2]+1+_this_\tab\bar\button[#bb_1]\width
    _this_\tab\bar\button[#bb_3]\width = _this_\width[2]-_this_\tab\bar\button[#bb_1]\width-_this_\tab\bar\button[#bb_2]\width-1
    
    If _this_\tab\bar\vertical
      _this_\tab\bar\button[#bb_1]\x = _this_\tab\bar\button[#bb_3]\x-_this_\tab\bar\button[#bb_1]\width
      _this_\tab\bar\button[#bb_2]\x = _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width-1
    Else
      If _this_\tab\bar\button[#bb_1] = _bar_button_ 
        _bar_button_\x = _pos_+1
        _this_\tab\bar\button[#bb_2]\x = _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width-1
      Else
        _bar_button_\x = _pos_-1
        _this_\tab\bar\button[#bb_1]\x = _this_\tab\bar\button[#bb_3]\x-_this_\tab\bar\button[#bb_1]\width
      EndIf
    EndIf
    
    
    _this_\tab\bar\button[#bb_3]\y = _this_\y[2]-_this_\__height+_this_\bs+2
    _this_\tab\bar\button[#bb_3]\height = _this_\__height-1-4
    
    _this_\tab\bar\button[#bb_1]\y = _this_\tab\bar\button[#bb_3]\y
    _this_\tab\bar\button[#bb_2]\y = _this_\tab\bar\button[#bb_3]\y
    
    _this_\tab\bar\button[#bb_1]\height = _this_\tab\bar\button[#bb_3]\height
    _this_\tab\bar\button[#bb_2]\height = _this_\tab\bar\button[#bb_3]\height
    
    _this_\tab\bar\page\len = _this_\width[2] - 1
    
    ;     If _bar_in_stop_(_this_\tab\bar)
    ;       If _this_\tab\bar\max < _this_\tab\bar\min : _this_\tab\bar\max = _this_\tab\bar\min : EndIf
    ;       
    ;       If _this_\tab\bar\max > _this_\tab\bar\max-_this_\tab\bar\page\len
    ;         If _this_\tab\bar\max > _this_\tab\bar\page\len
    ;           _this_\tab\bar\max = _this_\tab\bar\max-_this_\tab\bar\page\len
    ;         Else
    ;           _this_\tab\bar\max = _this_\tab\bar\min 
    ;         EndIf
    ;       EndIf
    ;       
    ;       _this_\tab\bar\page\pos = _this_\tab\bar\max
    ;       _this_\tab\bar\thumb\pos = _thumb_pos_(_this_\tab, _this_\tab\bar\page\pos)
    ;     EndIf
    
  EndMacro
  
  
  Procedure.i Draw_Panel(*this._S_widget)
    Protected State_3.i, Alpha.i, Color_Frame.i
    
    With *this 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \tab\bar\button[#bb_3]\x-\tab\bar\button[#bb_1]\width
      Protected start, stop
      
      ; Draw background image
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      ElseIf \color\back<>-1
        ; draw background
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[2], \y[2], \width[2], \height[2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \tab\count And \width[2]>(\tab\bar\button[#bb_1]\width+\tab\bar\button[#bb_2]\width+4)
        ForEach \tab\tabs()
          If \tab\index[#s_2] = \tab\tabs()\index
            State_3 = 2
            \tab\tabs()\y = \y+2
            \tab\tabs()\height=\__height-1
          Else
            State_3 = \tab\tabs()\state
            \tab\tabs()\y = \y+4
            \tab\tabs()\height=\__height-4-1
          EndIf
          Color_Frame = \color\frame[State_3]&$FFFFFF|Alpha
          
          \tab\tabs()\image\x[1] = 8 ; Bool(\tab\tabs()\image\width) * 4
          
          If \tab\tabs()\text\change
            \tab\tabs()\text\width = TextWidth(\tab\tabs()\text\string)
            \tab\tabs()\text\height = TextHeight("A")
          EndIf
          
          \tab\tabs()\x = x -\tab\bar\page\pos
          \tab\tabs()\width = \tab\tabs()\text\width + \tab\tabs()\image\x[1]*2 + \tab\tabs()\image\width + Bool(\tab\tabs()\image\width) * 3
          x + \tab\tabs()\width + 1
          
          \tab\tabs()\image\x = \tab\tabs()\x+\tab\tabs()\image\x[1] - 1
          \tab\tabs()\image\y = \tab\tabs()\y+(\tab\tabs()\height-\tab\tabs()\image\height)/2
          
          \tab\tabs()\text\x = \tab\tabs()\image\x + \tab\tabs()\image\width + Bool(\tab\tabs()\image\width) * 3
          \tab\tabs()\text\y = \tab\tabs()\y+(\tab\tabs()\height-\tab\tabs()\text\height)/2
          
          \tab\tabs()\drawing = Bool(Not \tab\tabs()\hide And \tab\tabs()\x+\tab\tabs()\width>\x+\bs And \tab\tabs()\x<\x+\width-\bs)
          
          If \tab\tabs()\drawing
            ;             DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
            ;             ResetGradientColors()
            ;             GradientColor(1.0, \color\back[State_3]&$FFFFFF|$FF<<24)
            ;             GradientColor(0.5, \color\back[State_3]&$FFFFFF|$A0<<24)
            ;             GradientColor(0.0, \color\back[State_3]&$FFFFFF)
            
            ; Draw tabs back   
            If \color\back[State_3]<>-1
              If \color\fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              _box_gradient_( \Vertical, \tab\tabs()\x, \tab\tabs()\y, \tab\tabs()\width, \tab\tabs()\height, \color\fore[State_3], Bool(State_3 <> 2)*\color\back[State_3] + (Bool(State_3 = 2)*\color\front[State_3]), \radius, \color\alpha)
            EndIf
            
            ; Draw string
            If \tab\tabs()\text\string
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\tab\tabs()\text\x, \tab\tabs()\text\y, \tab\tabs()\text\string.s, \color\front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \tab\tabs()\image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\tab\tabs()\image\handle, \tab\tabs()\image\x, \tab\tabs()\image\y, \color\alpha)
            EndIf
            
            ; Draw tabs frame
            If \color\frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\tab\tabs()\x, \tab\tabs()\y, \tab\tabs()\width, 1, Color_Frame)                     ; top
                Line(\tab\tabs()\x, \tab\tabs()\y, 1, \tab\tabs()\height, Color_Frame)                    ; left
                Line((\tab\tabs()\x+\tab\tabs()\width)-1, \tab\tabs()\y, 1, \tab\tabs()\height, Color_Frame) ; right
              Else
                RoundBox( \tab\tabs()\x, \tab\tabs()\y, \tab\tabs()\width, \tab\tabs()\height, \radius, \radius, Color_Frame)
              EndIf
            EndIf
          EndIf
          
          \tab\tabs()\text\change = 0
          
          If State_3 = 2
            sx = \tab\tabs()\x
            sw = \tab\tabs()\width
            start = Bool(\tab\tabs()\x=<\x[2]+\tab\bar\button[#bb_1]\len+1 And \tab\tabs()\x+\tab\tabs()\width>=\x[2]+\tab\bar\button[#bb_1]\len+1)*2
            stop = Bool(\tab\tabs()\x=<\x[2]+\width[2]-\tab\bar\button[#bb_2]\len-2 And \tab\tabs()\x+\tab\tabs()\width>=\x[2]+\width[2]-\tab\bar\button[#bb_2]\len-2)*2
          EndIf
        Next
        
        Protected max = ((\tab\tabs()\x+\tab\tabs()\width+\tab\bar\page\pos)-\x[2])
        If \tab\bar\max <> max : \tab\bar\max = max
          \tab\bar\area\pos = \x[2]+\tab\bar\button[#bb_1]\width
          \tab\bar\area\len = \width[2]-(\tab\bar\button[#bb_1]\len+\tab\bar\button[#bb_2]\len)
          _resize_panel_(*this, \tab\bar\button[#bb_1], \x[2])
          
          If \tab\scrolled > 0 And SelectElement(\tab\tabs(), \tab\scrolled-1)
            Protected State = (\tab\bar\button[#bb_1]\len+((\tab\tabs()\x+\tab\tabs()\width+\tab\bar\page\pos)-\x[2]))-\tab\bar\page\len ;
                                                                                                                                         ;               Debug (\tab\bar\button[#bb_1]\len+(\tab\tabs()\x+\tab\tabs()\width)-\x[2])-\tab\bar\page\len
                                                                                                                                         ;               Debug State
            If State < \tab\bar\min : State = \tab\bar\min : EndIf
            If State > \tab\bar\max-\tab\bar\page\len
              If \tab\bar\max > \tab\bar\page\len 
                State = \tab\bar\max-\tab\bar\page\len
              Else
                State = \tab\bar\min 
              EndIf
            EndIf
            
            \tab\bar\page\pos = State
          EndIf
        EndIf
        
        
        Protected fabe_x, fabe_out, button_size, Size = 35, color = \color\back[0]
        
        DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
        ResetGradientColors()
        GradientColor(0.0, Color&$FFFFFF)
        GradientColor(0.5, Color&$FFFFFF|$A0<<24)
        GradientColor(1.0, Color&$FFFFFF|245<<24)
        
        
        If (\tab\bar\button[#bb_1]\x < \tab\bar\button[#bb_3]\x)
          If \tab\bar\button[#bb_2]\x < \tab\bar\button[#bb_3]\x
            button_size = \tab\bar\button[#bb_1]\len+5
          Else
            button_size = \tab\bar\button[#bb_2]\len/2+5
          EndIf
          fabe_out = Size - button_size
        Else
          fabe_out = Size
        EndIf
        
        If Not _bar_in_start_(\tab\bar) : fabe_x = \x[2]+size
          LinearGradient(fabe_x, \y+\bs, fabe_x-fabe_out, \y+\bs)
          Box(fabe_x, \y+\bs, -Size, \__height-\bs, $FFFF00FF)
        EndIf
        
        If \tab\bar\button[#bb_2]\x > \tab\bar\button[#bb_3]\x
          If \tab\bar\button[#bb_1]\x > \tab\bar\button[#bb_3]\x
            button_size = \tab\bar\button[#bb_1]\len+5
          Else
            button_size = \tab\bar\button[#bb_1]\len/2+5
          EndIf
          fabe_out = Size - button_size
        Else
          fabe_out = Size
        EndIf
        
        If Not _bar_in_stop_(\tab\bar) : fabe_x= \x[2]+\width[2]-Size
          LinearGradient(fabe_x, \y+\bs, fabe_x+fabe_out, \y+\bs)
          Box(fabe_x, \y+\bs, Size, \__height-\bs, $FFFF00FF)
        EndIf
        
        ResetGradientColors()
        
        ; 1 - frame
        If \color\frame<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Line(\x, \y+\__height, sx-\x, 1, \color\frame&$FFFFFF|Alpha)
          Line(sx+sw, \y+\__height, \width-((sx+sw)-\x), 1, \color\frame&$FFFFFF|Alpha)
          
          Line(\x, \y+\__height, 1, \height-\__height, \color\frame&$FFFFFF|Alpha)
          Line(\x+\width-1, \y+\__height, 1, \height-\__height, \color\frame&$FFFFFF|Alpha)
          Line(\x, \y+\height-1, \width, 1, \color\frame&$FFFFFF|Alpha)
        EndIf
        
        Protected h.f = 2.5
        
        ; Draw arrow left button
        If \tab\bar\button[#bb_1]\width ;And \color[1]\state 
          _button_draw_(0,\tab\bar\button[#bb_1]\x, \tab\bar\button[#bb_1]\y+h, \tab\bar\button[#bb_1]\width, \tab\bar\button[#bb_1]\height-h*2, 
                        \tab\bar\button[#bb_1]\arrow\type, \tab\bar\button[#bb_1]\arrow\size, 0,
                        \tab\bar\button[#bb_1]\color\fore[\tab\bar\button[#bb_1]\color\state], \tab\bar\button[#bb_1]\color\back[\tab\bar\button[#bb_1]\color\state],
                        \tab\bar\button[#bb_1]\color\frame[\tab\bar\button[#bb_1]\color\state], \tab\bar\button[#bb_1]\color\front[\tab\bar\button[#bb_1]\color\state],\tab\bar\button[#bb_1]\color\alpha,\tab\bar\button[#bb_1]\round)
        EndIf
        
        ; Draw arrow right button
        If \tab\bar\button[#bb_2]\width ;And \color[2]\state 
          _button_draw_(0,\tab\bar\button[#bb_2]\x, \tab\bar\button[#bb_2]\y+h, \tab\bar\button[#bb_2]\width, \tab\bar\button[#bb_2]\height-h*2, 
                        \tab\bar\button[#bb_2]\arrow\type, \tab\bar\button[#bb_2]\arrow\size, 2,
                        \tab\bar\button[#bb_2]\color\fore[\tab\bar\button[#bb_2]\color\state], \tab\bar\button[#bb_2]\color\back[\tab\bar\button[#bb_2]\color\state], 
                        \tab\bar\button[#bb_2]\color\frame[\tab\bar\button[#bb_2]\color\state], \tab\bar\button[#bb_2]\color\front[\tab\bar\button[#bb_2]\color\state],\tab\bar\button[#bb_2]\color\alpha,\tab\bar\button[#bb_2]\round)
        EndIf
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
      If \caption\color\back > 0
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        _box_gradient_( \Vertical, \caption\x, \caption\y, \caption\width, \caption\height, \caption\color\fore[\focus*2], \caption\color\back[\focus*2], \radius, \caption\color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[\focus*2]&$FFFFFF|Alpha)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, \caption\round, \caption\round, $FF0000FF&$FFFFFF|\color[1]\alpha<<24)
      RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height, \caption\round, \caption\round, $FFFF0000&$FFFFFF|\color[2]\alpha<<24)
      RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, \caption\round, \caption\round, $FF00FF00&$FFFFFF|\color[3]\alpha<<24)
      
      ; Draw caption frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y+\bs-\fs, \width[1], \__height+\fs, \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \color\back[State_3]<>-1
        If \color\fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore, \color\back, \radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
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
  
  ;-
  Procedure.i Draw(*this._S_widget, Childrens=0)
    Protected parent_item.i
    
    With *this
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
          If \image\handle
            If (\type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\scroll\h\bar\page\len>\image\width And (\image\align\right Or \image\align\horizontal)) * (\scroll\h\bar\page\len-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\scroll\v\bar\page\len>\image\height And (\image\align\bottom Or \image\align\Vertical)) * (\scroll\v\bar\page\len-\image\height)) / (\image\align\Vertical+1)
              \image\y = \scroll\y+\image\y[1]+\y[2]
              \image\x = \scroll\x+\image\x[1]+\x[2]
              
            ElseIf (\type = #PB_GadgetType_Window)
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y+\bs+(\__height-\image\height)/2
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
            \text\y = \text\y[1]+\y+\bs+(\__height-\text\height)/2
          Else
            \text\x = \text\x[1]+\x[2]
            \text\y = \text\y[1]+\y[2]
          EndIf
        EndIf
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
        
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
          
          ForEach \childrens() 
            ;If Not Send(\childrens(), #PB_EventType_Repaint)
            
            If \childrens()\width[#c_4] > 0 And 
               \childrens()\height[#c_4] > 0 And 
               \childrens()\tab\index = \tab\index[#s_2]
              Draw(\childrens(), Childrens) 
            EndIf
            
            ;EndIf
            
            ;             ; Draw anchors 
            ;             If \childrens()\root And \childrens()\root\anchor And \childrens()\root\anchor\widget = \childrens()
            ;               a_Draw(\childrens()\root\anchor\widget)
            ;             EndIf
            ;             
            SetOrigin(\childrens()\x,\childrens()\y)
            Post(#PB_EventType_Repaint, \childrens())
            SetOrigin(0,0)
            
            
          Next
        EndIf
        
        If \width[#c_4] > 0 And \height[#c_4] > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4], $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $00FF00)
          
          If *this\focus And (*this = Root()\active\gadget Or *this = Root()\active)  ; Demo default coordinate
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\x,\y,\width,\height, $FF0000)
          EndIf
        EndIf
        
        UnclipOutput()
        
        ; Draw anchors 
        If \root And \root\anchor And \root\anchor\widget
          ;Debug \root\anchor\widget
          a_Draw(\root\anchor\widget)
        EndIf
        
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
      ; *event\widget = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas))
        ;If \root\color\back
        ; ;DrawingMode(#PB_2DDrawing_Default)
        ; ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
        ; FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), \root\color\back)
        ;EndIf
        
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
      \hide = Bool(State Or \hide[1] Or \parent\hide Or (\tab\index <> \parent\tab\index[#s_2]))
      
      If \scroll And \scroll\v And \scroll\h
        \scroll\v\hide = \scroll\v\bar\hide
        \scroll\h\hide = \scroll\h\bar\hide 
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
      ;        PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
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
        ;           PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug "remove item - "+Item
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
        If \childrens()\tab\index <> parent_item 
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
  
  
  ;- GET
  Procedure GetActive() ; Returns active window
    ProcedureReturn Root()\active
  EndProcedure
  
  ;   Procedure.i GetAdress(*this._S_widget)
  ;     ProcedureReturn *this\adress
  ;   EndProcedure
  
  Procedure.i GetButtons(*this._S_widget)
    ProcedureReturn *this\root\mouse\buttons
  EndProcedure
  
  Procedure.i GetPush(*this._S_widget) ; pressed pulled ; get traction
    ProcedureReturn *this\root\drag
  EndProcedure
  
  Procedure.i GetMouseX(*this._S_widget)
    ProcedureReturn *this\root\mouse\x-*this\x[#c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetMouseY(*this._S_widget)
    ProcedureReturn *this\root\mouse\y-*this\y[#c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetDeltaX(*this._S_widget)
    ProcedureReturn (*this\root\mouse\delta\x-*this\x[#c_2]-*this\fs)
  EndProcedure
  
  Procedure.i GetDeltaY(*this._S_widget)
    ProcedureReturn (*this\root\mouse\delta\y-*this\y[#c_2]-*this\fs)
  EndProcedure
  
  Procedure.s GetClass(*this._S_widget)
    ProcedureReturn *this\class
  EndProcedure
  
  Procedure.i GetCount(*this._S_widget)
    ProcedureReturn *this\type_Index ; Parent\type_count(Hex(*this\parent)+"_"+Hex(*this\type))
  EndProcedure
  
  Procedure.i GetLevel(*this._S_widget)
    ProcedureReturn *this\level - 1
  EndProcedure
  
  Procedure.i GetRoot(*this._S_widget)
    ProcedureReturn *this\root ; Returns root element
  EndProcedure
  
  Procedure.i GetWindow(*this._S_widget)
    If *this = *this\root
      ProcedureReturn *this\root\window ; Returns canvas window
    Else
      ProcedureReturn *this\window ; Returns element window
    EndIf
  EndProcedure
  
  Procedure.i GetGadget(*this._S_widget)
    If *this = *this\root
      ProcedureReturn *this\root\canvas ; Returns canvas gadget
    Else
      ProcedureReturn *this\gadget ; Returns active gadget
    EndIf
  EndProcedure
  
  Procedure.i GetParent(*this._S_widget)
    ProcedureReturn *this\parent
  EndProcedure
  
  Procedure.i GetParentItem(*this._S_widget)
    ProcedureReturn *this\tab\index
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
          ;         Case #PB_GadgetType_Option,
          ;              #PB_GadgetType_CheckBox 
          ;           Result = \box\checked
          ;           
        Case #PB_GadgetType_Tree : Result = \index[#s_2]
        Case #PB_GadgetType_Panel : Result = \index[#s_2]
        Case #PB_GadgetType_ComboBox : Result = \index[#s_2]
        Case #PB_GadgetType_ListIcon : Result = \index[#s_2]
        Case #PB_GadgetType_ListView : Result = \index[#s_2]
        Case #PB_GadgetType_IPAddress : Result = \index[#s_2]
          
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = *this\bar\page\pos
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
          ;           Select Attribute
          ;             Case #PB_Splitter_FirstMinimumSize : Result = \box[#bb_1]\len
          ;             Case #PB_Splitter_SecondMinimumSize : Result = \box[#bb_2]\len - \box[#bb_3]\len
          ;           EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \bar\min  ; 1
            Case #PB_Bar_Maximum : Result = \bar\max  ; 2
            Case #PB_Bar_Inverted : Result = \bar\inverted
            Case #PB_Bar_ButtonSize : Result = \bar\button\len ; 4
            Case #PB_Bar_Direction : Result = \bar\direction
            Case #PB_Bar_PageLength : Result = \bar\page\len ; 3
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
              \align\top = Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)
              \align\left = Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              \align\right = Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)
              \align\bottom = Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)
              
              If Bool(Mode&#PB_Flag_Center=#PB_Flag_Center)
                \align\horizontal = 1
                \align\Vertical = 1
              Else
                \align\horizontal = Bool(Mode&#PB_Flag_Horizontal=#PB_Flag_Horizontal)
                \align\Vertical = Bool(Mode&#PB_Flag_Vertical=#PB_Flag_Vertical)
              EndIf
            EndIf
            
            If Bool(Mode&#PB_Flag_AutoSize=#PB_Flag_AutoSize)
              If Bool(Mode&#PB_Flag_Full=#PB_Flag_Full) 
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
              
              \align\top = Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)+Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              \align\left = Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)+Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)+Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)
              \align\right = Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)+Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)
              \align\bottom = Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)+Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              
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
        ; set root parent
        If Not *Parent\type And *this <> *Parent\parent
          ;  Debug ""+*this+" "+*Parent+" "+*Parent\parent+" "+*Parent\type
          *Parent = *Parent\parent
        EndIf
        
        If parent_item =- 1
          parent_item = *Parent\index[#s_2]
        EndIf
        
        If *Parent <> \parent Or \tab\index <> parent_item : \tab\index = parent_item
          x = \x[3]
          y = \y[3]
          
          If \parent And \parent\count > 0
            ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) 
            DeleteElement(\parent\childrens())  
            \parent\count - 1
            If SelectElement(\root\childrens(), *this\index) 
            DeleteElement(\root\childrens())  
            EndIf
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \parent = *Parent
          \root = *Parent\root
          
          \index = \root\count : \root\count + 1 
          
          If \parent = \root
            \window = \parent
            
            LastElement(\root\childrens()) : \adress = AddElement(\root\childrens()) : \root\childrens() = *this 
          Else
            \window = \parent\window
            \parent\count + 1 
            \level = \parent\level + 1
            
             LastElement(\root\childrens()) : \adress = AddElement(\root\childrens()) : \root\childrens() = *this 
            
            ; Add new children to the parent
            LastElement(\parent\childrens()) : \adress = AddElement(\parent\childrens()) : \parent\childrens() = *this 
          EndIf
          
          
          
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \hide = Bool(\parent\hide Or \tab\index <> \parent\tab\index[#s_2])
          
          ; ????????
          If \scroll
            If \scroll\v
              \scroll\v\window = \window
            EndIf
            If \scroll\h
              \scroll\h\window = \window
            EndIf
          EndIf
          
          ; for the scroll area childrens
          If \parent\scroll
            x-\parent\scroll\h\bar\page\pos
            y-\parent\scroll\v\bar\page\pos
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
                Case *Parent\root : ReDraw(*Parent)
                Case *LastParent\root     : ReDraw(*LastParent)
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
      
      If \parent And \parent\count
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
      Root()\active\focus = _state_
      
      If Not(Root()\active = Root()\active\root And Root()\active\root\type =- 5)
        If _state_
          Events(Root()\active, Root()\active\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Root()\active, Root()\active\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
        
        PostEvent(#PB_Event_Gadget, Root()\active\root\window, Root()\active\root\canvas, #PB_EventType_Repaint)
      EndIf
      
      If Root()\active\gadget
        Root()\active\gadget\focus = _state_
        If _state_
          Events(Root()\active\gadget, Root()\active\gadget\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Root()\active\gadget, Root()\active\gadget\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
      EndIf
    EndMacro
    
    With *this
      If \type > 0
        If Root()\active\gadget <> *this
          
          If Root()\active <> \window
            If Root()\active
              _set_active_state_(0)
            EndIf
            
            Root()\active = \window
            Root()\active\gadget = *this
            
            _set_active_state_(1)
          Else
            If Root()\active\gadget
              Root()\active\gadget\focus = 0
              Events(Root()\active\gadget, Root()\active\gadget\from, #PB_EventType_LostFocus, -1, -1)
            EndIf
            
            Root()\active\gadget = *this
            Root()\active\gadget\focus = 1
            Events(Root()\active\gadget, Root()\active\gadget\from, #PB_EventType_Focus, -1, -1)
          EndIf
          
          Result = #True 
        EndIf
        
      ElseIf Root()\active <> *this
        If Root()\active
          _set_active_state_(0)
        EndIf
        
        Root()\active = *this
        
        _set_active_state_(1)
        
        Result = #True
      EndIf
      
      SetPosition(Root()\active, #PB_List_Last)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFlag(*this._S_widget, Flag.i)
    
    With *this
      If Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget
        ;         a_Add(*this)
        a_Resize(*this)
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
            If \index[#s_2] <> State : \index[#s_2] = State
              SetText(*this, Str(IPAddressField(State,0))+"."+
                             Str(IPAddressField(State,1))+"."+
                             Str(IPAddressField(State,2))+"."+
                             Str(IPAddressField(State,3)))
            EndIf
            
          Case #PB_GadgetType_CheckBox
            Select State
              Case #PB_Checkbox_Unchecked,
                   #PB_Checkbox_Checked
                \check_box\checked = State
                ProcedureReturn 1
                
              Case #PB_Checkbox_Inbetween
                If \flag\threestate 
                  \check_box\checked = State
                  ProcedureReturn 1
                EndIf
            EndSelect
            
          Case #PB_GadgetType_Option
            If \option_group And \option_box\checked <> State
              If \option_group\option_group <> *this
                If \option_group\option_group
                  \option_group\option_group\option_box\checked = 0
                EndIf
                \option_group\option_group = *this
              EndIf
              \option_box\checked = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_ComboBox
            Protected *t._S_widget = \popup\childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\countItems - 1 : State = *t\countItems - 1 :  EndIf
            
            If *t\index[#s_2] <> State
              If *t\index[#s_2] >= 0 And SelectElement(*t\items(), *t\index[#s_2]) 
                *t\items()\state = 0
              EndIf
              
              *t\index[#s_2] = State
              \index[#s_2] = State
              
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
            
            If \index[#s_2] <> State
              If \index[#s_2] >= 0 And 
                 SelectElement(\items(), \index[#s_2]) 
                \items()\state = 0
              EndIf
              
              \index[#s_2] = State
              
              If SelectElement(\items(), \index[#s_2])
                \items()\state = 2
                \change = \index[#s_2]+1
                ; w_Events(*this, #PB_EventType_Change, \index[#s_2])
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            _set_image_(*this, *this, State) 
            Result = *this\image\change
            
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
            If State > \tab\count - 1 : State = \tab\count - 1 :  EndIf
            
            If \tab\index[#s_2] <> State : \tab\index[#s_2] = State
              
              ForEach \childrens()
                set_hide_state(\childrens(), Bool(\childrens()\tab\index<>\tab\index[#s_2]))
              Next
              
              ;\tab\selected = SelectElement(\tab\tabs(), State)
              
              \tab\scrolled = State + 1
              Result = 1
            EndIf
            
          Default
            ProcedureReturn Bar_SetState(*this, State)
            
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
                _set_image_(*this, *this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \bar\button[#bb_1]\len = Value
              Case #PB_Splitter_SecondMinimumSize : \bar\button[#bb_2]\len = \bar\button[#bb_3]\len + Value
            EndSelect 
            
            If \bar\Vertical
              \bar\area\pos = \y+\bar\button[#bb_1]\len
              \bar\area\len = (\height-\bar\button[#bb_1]\len-\bar\button[#bb_2]\len)
            Else
              \bar\area\pos = \x+\bar\button[#bb_1]\len
              \bar\area\len = (\width-\bar\button[#bb_1]\len-\bar\button[#bb_2]\len)
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
            
            Resize = Bar_SetAttribute(*this, Attribute, Value)
            
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
          If SelectElement(\tab\tabs(), Item)
            Select Attribute 
              Case #PB_Button_Image
                _set_image_(*this, \tab\tabs(), Value) 
                Result = \tab\tabs()\image\change
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
            \image[Item]\handle = ImageID(Image)
            \image[Item]\width = ImageWidth(Image)
            \image[Item]\height = ImageHeight(Image)
          Else
            \image[Item]\index =- 1
            \image[Item]\handle = 0
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
          ;       If \index[#s_2] <> Item
          ;         If \index[#s_2] >= 0 And SelectElement(\items(), \index[#s_2]) 
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
          ;         \index[#s_2] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\flag\multiSelect Or \flag\clickSelect)
          PushListPosition(\items())
          Result = SelectElement(\items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \items()\index[#s_1] = \items()\index
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
          
          ;          If \index[#s_1] >= 0 And SelectElement(\items(), \index[#s_1]) 
          ;                 Protected sublevel.i
          ;                 
          ;                 If (mouse_y > (\items()\box[1]\y) And mouse_y =< ((\items()\box[1]\y+\items()\box[1]\height))) And 
          ;                    ((mouse_x > \items()\box[1]\x) And (mouse_x =< (\items()\box[1]\x+\items()\box[1]\width)))
          ;                   
          ;                   \items()\box\checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (mouse_y > (\items()\box[0]\y) And mouse_y =< ((\items()\box[0]\y+\items()\box[0]\height))) And 
          ;                        ((mouse_x > \items()\box[0]\x) And (mouse_x =< (\items()\box[0]\x+\items()\box[0]\width)))
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
          ;                 ElseIf \index[#s_2] <> \index[#s_1] : \items()\state = 2
          ;                   If \index[#s_2] >= 0 And SelectElement(\items(), \index[#s_2])
          ;                     \items()\state = 0
          ;                   EndIf
          ;                   \index[#s_2] = \index[#s_1]
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
    ;     Debug *this
    ;     
    ;     If Not *this
    ;       ProcedureReturn
    ;     EndIf
    
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
        \image[i]\handle = ImageID(Image)
        \image[i]\width = ImageWidth(Image)
        \image[i]\height = ImageHeight(Image)
      Else
        \image[i]\index =- 1
        \image[i]\handle = 0
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
          Case #Color_Line
            If \color[Item]\line[State] <> Color 
              \color[Item]\line[State] = Color
              Result = #True
            EndIf
            
          Case #Color_Back
            If \color[Item]\back[State] <> Color 
              \color[Item]\back[State] = Color
              Result = #True
            EndIf
            
          Case #Color_Front
            If \color[Item]\front[State] <> Color 
              \color[Item]\front[State] = Color
              Result = #True
            EndIf
            
          Case #Color_Frame
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
        
        
        SetGadgetAttribute(\root\canvas, CursorType, Cursor)
        
        \cursor = Cursor
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;- ADD
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
          \items()\index[#s_1] =- 1
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
            
            \items()\image\handle = ImageID(Image)
            \items()\image\handle[1] = Image
            
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
              PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
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
      \items()\box[0] = AllocateStructure(_S_box)
      \items()\box[1] = AllocateStructure(_S_box)
      
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
      \items()\index[#s_1] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \text\height
      \items()\i_Parent = \i_Parent
      
      _set_image_(*this, \items(), Image)
      
      \items()\y = \scroll\height
      \scroll\height + \items()\height
      
      \image = AllocateStructure(_S_image)
      \image\handle = \items()\image\handle
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
        \columns()\items()\index[#s_1] =- 1
        \columns()\items()\text\change = 1
        \columns()\items()\text\string.s = Text.s
        \columns()\items()\sublevel = sublevel
        \columns()\items()\height = \text\height
        
        _set_image_(*this, \columns()\items(), Image)
        
        \columns()\items()\y = \scroll\height
        \scroll\height + \columns()\items()\height
        
        \image\handle = \columns()\items()\image\handle
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
        ;           PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
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
      \items()\index[#s_1] =- 1
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
      
      _set_image_(*this, \items(), Image)
      \countItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure AddItem_Panel(*this._S_widget, Item.i, Text.s, Image.i=-1, sublevel.i=0)
    With *this
      If (Item =- 1 Or Item > ListSize(\tab\tabs()) - 1)
        LastElement(\tab\tabs())
        AddElement(\tab\tabs()) 
        Item = ListIndex(\tab\tabs())
      Else
        SelectElement(\tab\tabs(), Item)
        
        ForEach \childrens()
          If \childrens()\tab\index = Item
            \childrens()\tab\index + 1
          EndIf
        Next
        
        InsertElement(\tab\tabs())
        
        PushListPosition(\tab\tabs())
        While NextElement(\tab\tabs())
          \tab\tabs()\index = ListIndex(\tab\tabs())
        Wend
        PopListPosition(\tab\tabs())
      EndIf
      
      \tab\tabs()\index = Item
      \tab\tabs()\text\change = 1
      \tab\tabs()\text\string = Text.s
      \tab\tabs()\height = \__height
      
      ; last opened item of the parent
      \tab\opened = \tab\tabs()\index
      \tab\count + 1 
      
      _set_image_(*this, \tab\tabs(), Image)
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  ;-
  Procedure.i AddItem(*this._S_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *this
      ;       If Not *this
      ;         ProcedureReturn 0
      ;       EndIf
      
      Select \type
        Case #PB_GadgetType_Panel
          ProcedureReturn AddItem_Panel(*this, Item, Text.s, Image, Flag)
          
        Case #PB_GadgetType_Property
          ProcedureReturn AddItem_Property(*this, Item,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
          ProcedureReturn AddItem_Tree(*this, Item,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Editor
          ProcedureReturn AddItem_Editor(*this, Item,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ListIcon
          ProcedureReturn AddItem_ListIcon(*this, Item,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ComboBox
          Protected *Tree._S_widget = \popup\childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(_S_items)
          *Tree\items()\box[0] = AllocateStructure(_S_box)
          *Tree\items()\box[1] = AllocateStructure(_S_box)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\text\string = Text.s
          *Tree\items()\text\change = 1
          *Tree\items()\height = \text\height
          *Tree\countItems + 1 
          
          *Tree\items()\y = *Tree\scroll\height
          *Tree\scroll\height + *Tree\items()\height
          
          _set_image_(*Tree, *Tree\items(), Image)
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
      
      \columns()\index[#s_1] =- 1
      \columns()\index[#s_2] =- 1
      \columns()\index = Position
      \columns()\width = Width
      
      \columns()\image = AllocateStructure(_S_image)
      \columns()\image\x[1] = 5
      
      \columns()\text = AllocateStructure(_S_text)
      \columns()\text\string.s = Title.s
      \columns()\text\change = 1
      
      \columns()\x = \x[2]+\scroll\width
      \columns()\height = \__height
      \scroll\height = \bs*2+\columns()\height
      \scroll\width + Width + 1
    EndWith
  EndProcedure
  
  ;-
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
        If Y<>#PB_Ignore : If \parent : \y[3] = Y : Y+\parent\y+\parent\bs+\parent\__height : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[2] = \y+\bs+\__height : \y[1] = \y[2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[2] = \height-\bs*2-\__height-\__height : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[2] = width-Bool(\type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\__height+\bs*2) : \height[2] = height-Bool(\type<>-1)*(\__height+\bs*2) : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        Select \type
          Case #PB_GadgetType_Panel
            _resize_panel_(*this, \tab\bar\button[#bb_1], \x[2])
            
            If _bar_in_stop_(\tab\bar)
              If \tab\bar\max < \tab\bar\min : \tab\bar\max = \tab\bar\min : EndIf
              
              If \tab\bar\max > \tab\bar\max-\tab\bar\page\len
                If \tab\bar\max > \tab\bar\page\len
                  \tab\bar\max = \tab\bar\max-\tab\bar\page\len
                Else
                  \tab\bar\max = \tab\bar\min 
                EndIf
              EndIf
              
              \tab\bar\page\pos = \tab\bar\max
              \tab\bar\thumb\pos = _thumb_pos_(\tab, \tab\bar\page\pos)
            EndIf
            
            
          Case #PB_GadgetType_Window
            \caption\x = \x[2]
            \caption\y = \y+\bs
            \caption\width = \width[2]
            \caption\height = \__height
            
            \caption\button[0]\width = \caption\len
            \caption\button[1]\width = \caption\len
            \caption\button[2]\width = \caption\len
            
            \caption\button[0]\height = \caption\len
            \caption\button[1]\height = \caption\len
            \caption\button[2]\height = \caption\len
            
            \caption\button[0]\x = \x[2]+\width[2]-\caption\button[0]\width-5
            \caption\button[1]\x = \caption\button[0]\x-Bool(Not \caption\button[1]\hide) * \caption\button[1]\width-5
            \caption\button[2]\x = \caption\button[1]\x-Bool(Not \caption\button[2]\hide) * \caption\button[2]\width-5
            
            \caption\button[0]\y = \y+\bs+(\__height-\caption\len)/2
            \caption\button[1]\y = \caption\button[0]\y
            \caption\button[2]\y = \caption\button[0]\y
            
          Case #PB_GadgetType_Spin
            If \bar\vertical      
              ; Top button coordinate
              \bar\button[#bb_1]\y = \y[2]+\height[2]/2 + Bool(\height[2]%2) 
              \bar\button[#bb_1]\height = \height[2]/2 
              \bar\button[#bb_1]\width = \bar\button\len 
              \bar\button[#bb_1]\x = \x[2]+\width[2]-\bar\button\len
              
              ; Bottom button coordinate
              \bar\button[#bb_2]\y = \y[2] 
              \bar\button[#bb_2]\height = \height[2]/2 
              \bar\button[#bb_2]\width = \bar\button\len 
              \bar\button[#bb_2]\x = \x[2]+\width[2]-\bar\button\len                                 
            Else    
              ; Left button coordinate
              \bar\button[#bb_1]\y = \y[2] 
              \bar\button[#bb_1]\height = \height[2] 
              \bar\button[#bb_1]\width = \bar\button\len/2 
              \bar\button[#bb_1]\x = \x[2]+\width[2]-\bar\button\len    
              
              ; Right button coordinate
              \bar\button[#bb_2]\y = \y[2] 
              \bar\button[#bb_2]\height = \height[2] 
              \bar\button[#bb_2]\width = \bar\button\len/2 
              \bar\button[#bb_2]\x = \x[2]+\width[2]-\bar\button\len/2                               
            EndIf
            
            
          Default
            
            Bar_Update(*this)
            
        EndSelect
        
        ; set clip coordinate
        If Not IsRoot(*this) And \parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \parent\scroll 
            If \parent\scroll\v : clip_v = Bool(\parent\width=\parent\width[#c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\parent\scroll\v\width : EndIf
            If \parent\scroll\h : clip_h = Bool(\parent\height=\parent\height[#c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \parent\x[#c_4]+Bool(\parent\x[#c_4]<\parent\x+\parent\bs)*\parent\bs
          clip_y = \parent\y[#c_4]+Bool(\parent\y[#c_4]<\parent\y+\parent\bs)*(\parent\bs+\parent\__height) 
          clip_width = ((\parent\x[#c_4]+\parent\width[#c_4])-Bool((\parent\x[#c_4]+\parent\width[#c_4])>(\parent\x[2]+\parent\width[2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#c_4]+\parent\height[#c_4])-Bool((\parent\y[#c_4]+\parent\height[#c_4])>(\parent\y[2]+\parent\height[2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#c_4] = clip_x : Else : \x[#c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#c_4] = clip_y : Else : \y[#c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#c_4] = clip_width - \x[#c_4] : Else : \width[#c_4] = \width - (\x[#c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#c_4] = clip_height - \y[#c_4] : Else : \height[#c_4] = \height - (\y[#c_4]-\y) : EndIf
        
        ; Resize vertical&horizontal scrollbar
        If (\scroll And \scroll\v And \scroll\h)
          Resizes(\scroll, 0,0, \width[2],\height[2])
        EndIf
        
        ; Resize childrens
        If \count
          If \type = #PB_GadgetType_Splitter
            _bar_splitter_size_(*this)
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
        If (\root And \root\anchor And \root\anchor\widget = *this)
          a_Resize(*this)
        EndIf
        
        If \type = #PB_GadgetType_ScrollBar
          ProcedureReturn \bar\hide
        ElseIf (Change_x Or Change_y Or Change_width Or Change_height)
          ProcedureReturn 1
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, Size.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7, Parent.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \x =- 1
      \y =- 1
      \type = Type
      \bar\type = Type
      
      \parent = Parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      \radius = Radius
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \bar\vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \bar\inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      \bar\button[#bb_3]\len = SliderLen ; min thumb size
      
      \bar\button[1]\arrow\size = 4
      \bar\button[2]\arrow\size = 4
      \bar\button[1]\arrow\type =- 1 ; -1 0 1
      \bar\button[2]\arrow\type =- 1 ; -1 0 1
      
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
      
      If Not Bool(Flag&#PB_Bar_ButtonSize=#PB_Bar_ButtonSize)
        If Size < 21
          \bar\button\len = Size - 1
        Else
          \bar\button\len = 17
        EndIf
        
        If \bar\vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If Type = #PB_GadgetType_ScrollBar
        \bar\button[#bb_1]\len = \bar\button\len
        \bar\button[#bb_2]\len = \bar\button\len
      EndIf
      
      If \bar\min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *this._S_widget, Size
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Flag_Vertical)
    
    If Vertical
      Size = width
    Else
      Size =  height
    EndIf
    
    *this = Bar(#PB_GadgetType_ScrollBar, Size, Min, Max, PageLength, Flag|Vertical, Radius)
    _set_last_parameters_(*this, #PB_GadgetType_ScrollBar, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth ; |(Bool(#PB_Vertical) * #PB_Bar_Inverted)
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Flag_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Smooth|Vertical|#PB_Bar_ButtonSize, 0)
    _set_last_parameters_(*this, #PB_GadgetType_ProgressBar, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Flag_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_TrackBar, 0, Min, Max, 0, Ticks|Vertical|#PB_Bar_ButtonSize, 0)
    _set_last_parameters_(*this, #PB_GadgetType_TrackBar, Flag, Root()\opened)
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _set_last_parameters_(*this, #PB_GadgetType_Spin, Flag, Root()\opened) 
    
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
      
      \text\string.s[1] = Str(Min)
      \text\change = 1
      
      ; Цвет фона скролла
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \text\editable = 1
      
      \bar\scrollstep = 1
      
      \bar\button\color = def_colors
      \bar\button[#bb_1]\color = def_colors
      \bar\button[#bb_2]\color = def_colors
      
      \bar\button[#bb_1]\arrow\size = 2
      \bar\button[#bb_2]\arrow\size = 2
      
      \bar\button[#bb_1]\arrow\type =- 1 ; -1 0 1
      \bar\button[#bb_2]\arrow\type =- 1 ; -1 0 1
      
      \bar\button\len = 15
      \bar\button[#bb_1]\len = \bar\button\len
      \bar\button[#bb_2]\len = \bar\button\len
      
      \bar\Vertical = Bool(Not Flag&#PB_Flag_Vertical=#PB_Flag_Vertical)
      
      If \bar\min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Image, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \image = AllocateStructure(_S_image)
      _set_image_(*this, *this, Image)
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Frame, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \container =- 2
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \__height = 16
      
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
  
  Procedure.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ComboBox, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      \text\height = 20
      
      \image = AllocateStructure(_S_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      \combo_box\height = Height
      \combo_box\width = 15
      \combo_box\arrow\size = 4
      \combo_box\arrow\type =- 1
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
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
      Protected *open = OpenList(\popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) 
      \popup\childrens()\scroll\h\height=0
      OpenList(*open)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Button, Flag, Root()\opened) 
    
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
      _set_image_(*this, *this, Image)
      
      ;       ; временно из-за этого (контейнер \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget))
      ;       If \parent And \parent\root\anchor\id[1]
      ;         x+\parent\fs
      ;         y+\parent\fs
      ;       EndIf
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_HyperLink, Flag, Root()\opened) 
    
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
  
  Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_CheckBox, Flag, Root()\opened) 
    
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
      \check_box\height = 15
      \check_box\width = 15
      \flag\threestate = Bool(Flag&#PB_CheckBox_ThreeState=#PB_CheckBox_ThreeState)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    If Root()\opened\count
      If Root()\opened\childrens()\type = #PB_GadgetType_Option
        *this\option_group = Root()\opened\childrens()\option_group 
      Else
        *this\option_group = Root()\opened\childrens() 
      EndIf
    Else
      *this\option_group = Root()\opened
    EndIf
    
    _set_last_parameters_(*this, #PB_GadgetType_Option, Flag, Root()\opened) 
    
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
      
      \option_box\height = 15
      \option_box\width = 15
      \radius = 0
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Text, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      
      \text = AllocateStructure(_S_text)
      \text\x[2] = 3
      \text\y[2] = 0
      
      Flag|#PB_Flag_MultiLine|#PB_Flag_ReadOnly;|#PB_Flag_BorderLess
      
      If Bool(Flag&#PB_Flag_WordWrap)
        Flag&~#PB_Flag_MultiLine
        \text\multiLine =- 1
      EndIf
      
      If Bool(Flag&#PB_Flag_MultiLine)
        Flag&~#PB_Flag_WordWrap
        \text\multiLine = 1
      EndIf
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_String, Flag, Root()\opened)
    
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
      
      \text\editable = Bool(Not Flag&#PB_Flag_ReadOnly)
      \text\multiLine = (Bool(Flag&#PB_Flag_MultiLine) * 1)+(Bool(Flag&#PB_Flag_WordWrap) * - 1)
      \text\Numeric = Bool(Flag&#PB_Flag_Numeric)
      \text\lower = Bool(Flag&#PB_Flag_LowerCase)
      \text\Upper = Bool(Flag&#PB_Flag_UpperCase)
      \text\pass = Bool(Flag&#PB_Flag_Password)
      
      ;\text\align\Vertical = Bool(Not Flag&#PB_Flag_Top)
      \text\align\horizontal = Bool(Flag&#PB_Flag_Center)
      \text\align\right = Bool(Flag&#PB_Flag_Right)
      ;\text\align\bottom = Bool(Flag&#PB_Flag_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i IPAddress(X.l,Y.l,Width.l,Height.l)
    Protected Text.s="0.0.0.0", Flag.i=#PB_Flag_Center
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_IPAddress, Flag, Root()\opened)
    
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
      
      \text\editable = Bool(Not Flag&#PB_Flag_ReadOnly)
      \text\multiLine = (Bool(Flag&#PB_Flag_MultiLine) * 1)+(Bool(Flag&#PB_Flag_WordWrap) * - 1)
      \text\Numeric = Bool(Flag&#PB_Flag_Numeric)
      \text\lower = Bool(Flag&#PB_Flag_LowerCase)
      \text\Upper = Bool(Flag&#PB_Flag_UpperCase)
      \text\pass = Bool(Flag&#PB_Flag_Password)
      
      ;\text\align\Vertical = Bool(Not Flag&#PB_Flag_Top)
      \text\align\horizontal = Bool(Flag&#PB_Flag_Center)
      \text\align\right = Bool(Flag&#PB_Flag_Right)
      ;\text\align\bottom = Bool(Flag&#PB_Flag_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Editor, Flag, Root()\opened)
    
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
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
      
      ;       \text\editable = Bool(Not Flag&#PB_Flag_ReadOnly)
      \text\multiLine = 1;(Bool(Flag&#PB_Flag_MultiLine) * 1)+(Bool(Flag&#PB_Flag_WordWrap) * - 1)
                         ;\text\Numeric = Bool(Flag&#PB_Flag_Numeric)
      \text\lower = Bool(Flag&#PB_Flag_LowerCase)
      \text\Upper = Bool(Flag&#PB_Flag_UpperCase)
      \text\pass = Bool(Flag&#PB_Flag_Password)
      
      ;       ;\text\align\Vertical = Bool(Not Flag&#PB_Flag_Top)
      ;       \text\align\horizontal = Bool(Flag&#PB_Flag_Center)
      ;       \text\align\right = Bool(Flag&#PB_Flag_Right)
      ;       ;\text\align\bottom = Bool(Flag&#PB_Flag_Bottom)
      
      
      
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
      \index[#s_1] =- 1
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
  Procedure.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Tree, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Bool(\flag\buttons Or \flag\lines) * Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListView, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      
      \text = AllocateStructure(_S_text)
      If StartDrawing(CanvasOutput(\root\canvas))
        
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      \__height = 24
      
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      AddColumn(*this, 0, FirstColumnTitle, FirstColumnWidth)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      \__height = 24
      
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
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
    _set_last_parameters_(*this, #PB_GadgetType_Property, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      \bar\thumb\len = 7
      \bar\button[#bb_3]\len = 7 ; min thumb size
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Flag_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar._S_widget, *this._S_widget, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    
    *this = Bar(0, 0, 0, Max, 0, Auto|Vertical|#PB_Bar_ButtonSize, 0, 7)
    
    _set_last_parameters_(*this, #PB_GadgetType_Splitter, Flag, Root()\opened) 
    
    With *this
      \bar\button\len = 7
      \bar\thumb\len = 7
      \mode = #PB_Splitter_Separator
      
      \splitter = AllocateStructure(_S_splitter)
      \splitter\first = First
      \splitter\second = Second
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      Resize(*this, X,Y,Width,Height)
      
      If \bar\vertical
        \cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
      
      SetParent(\splitter\first, *this)
      SetParent(\splitter\second, *this)
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ScrollArea, Flag, Root()\opened)
    
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar, Size, 0,ScrollAreaHeight,Height, #PB_Bar_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar, Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *this)
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
    _set_last_parameters_(*this, #PB_GadgetType_Container, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \index[#s_1] =- 1
      \index[#s_2] = 0
      
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
    _set_last_parameters_(*this, #PB_GadgetType_Panel, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      
      \container = 1
      
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \tab\bar\page\len = Width
      \tab\bar\scrollstep = 10
      
      
      \__height = 25
      \from =- 1
      \tab\index[#s_1] =- 1
      \tab\index[#s_2] = 0
      
      \tab\bar\button[#bb_1]\len = 13 + 2
      \tab\bar\button[#bb_2]\len = 13 + 2
      \tab\bar\button[#bb_1]\round = 7
      \tab\bar\button[#bb_2]\round = 7
      
      \tab\bar\button[#bb_1]\arrow\size = 6
      \tab\bar\button[#bb_2]\arrow\size = 6
      \tab\bar\button[#bb_1]\arrow\type =- 1
      \tab\bar\button[#bb_2]\arrow\type =- 1
      
      \tab\bar\button[#bb_1]\color = def_colors
      \tab\bar\button[#bb_2]\color = def_colors
      
      \tab\bar\button[#bb_1]\color\alpha = 255
      \tab\bar\button[#bb_2]\color\alpha = 255
      
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
    ;Debug ""+Root() +" "+ Root()\opened +" "+ Root()\opened\parent +" "+ Root()\opened\parent\parent +" "+ Root()\parent
    
    If Root()\opened\parent And Root()\opened\root\canvas = Root()\canvas ;And Root()\opened\parent\parent <> Root()\parent
      Root()\opened = Root()\opened\parent
    Else
      ;Debug 6666
      Root()\opened = Root()
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._S_widget, Item.l=0)
    Protected result.i = Root()\opened
    
    If *this
      If *this\type = #PB_GadgetType_Window
        *this\window = *this
      EndIf
      
      Root()\opened = *this
      Root()\opened\tab\opened = Item
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *Parent._S_widget=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    If *Parent 
      If *Parent = Root() ; And Not Root()\parent 
                          ;Debug 5555555
        Root()\parent = *this
      EndIf
      
    Else
      ;OpenList(Root())
      *Parent = Root()
    EndIf
    
    _set_last_parameters_(*this, #PB_GadgetType_Window, Flag, *Parent) 
    
    With *this
      \x =- 1
      \y =- 1
      \index[#s_1] =- 1
      \index[#s_2] = 0
      
      \container =- 1
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      If Not flag&#PB_Flag_BorderLess
        \__height = 23
      EndIf
      
      \image = AllocateStructure(_S_image)
      \image\x[2] = 5 ; padding 
      
      \text = AllocateStructure(_S_text)
      \text\align\horizontal = 1
      
      \caption\color = def_colors
      \caption\color\alpha = 255
      
      \caption\len = 12
      \caption\round = 4
      
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
    Protected w.i=-1, Canvas.i=-1, *this._S_widget
    
    ; deactive active window
    If Root() And Root()\active 
      _set_active_state_(0)
    EndIf
    
    With *this
      Root() = AllocateStructure(_S_root)
      Root()\root = Root()
      Root()\width = Width
      Root()\height = Height
      Root()\color = def_colors
      
      If Bool(flag & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
        Root()\flag\transform = 1
      EndIf
      
      *this = Form(0, 0, Width,Height, Text.s, Flag,  Root())
      
      Width + \bs*2
      Height + \__height + \bs*2
      
      If Not IsWindow(Window) 
        If Text
          If flag&#PB_Window_ScreenCentered
            w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, WindowID) 
          Else
            w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess, WindowID) 
          EndIf
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
      
      Root()\window = Window
      Root()\canvas = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
      
      If IsGadget(Root()\canvas)
        SetGadgetData(Root()\canvas, Root())
        SetWindowData(Root()\window, Root()\canvas)
        BindGadgetEvent(Root()\canvas, @g_Callback())
      EndIf
    EndWith
    
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
        
        ;If \box : FreeStructure(\box) : \box = 0 : EndIf
        If \text : FreeStructure(\text) : \text = 0 : EndIf
        If \image : FreeStructure(\image) : \image = 0 : EndIf
        If \image[1] : FreeStructure(\image[1]) : \image[1] = 0 : EndIf
        
        ;         Root()\active\gadget = 0
        ;         Root()\active = 0
        
        If \parent And ListSize(\parent\childrens()) : \parent\count - 1
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
    
    If Not *this\root\event_count
      ; 
      Select eventtype 
        Case #PB_EventType_Focus, 
             #PB_EventType_LostFocus
          
          ForEach Root()\event_list()
            If Root()\event_list()\widget = *this And Root()\event_list()\type = eventtype
              result = 1
            EndIf
          Next
          
          If Not result
            AddElement(Root()\event_list())
            Root()\event_list() = AllocateStructure(_S_event)
            Root()\event_list()\widget = *this
            Root()\event_list()\type = eventtype
            Root()\event_list()\item = eventitem
            Root()\event_list()\data = *data
          EndIf
          
      EndSelect
    EndIf
    
    If *this And *this\root\event_count
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
    
    If Not *this\root\event_count
      *this\root\event_count = 1
    EndIf
    
    *this\event\type = eventtype
    *this\event\callback = *callback
    
    If ListSize(Root()\event_list())
      ForEach Root()\event_list()
        Post(Root()\event_list()\type, Root()\event_list()\widget, Root()\event_list()\item, Root()\event_list()\data)
      Next
      ClearList(Root()\event_list())
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
        
        Post(EventType, *this, EventItem, EventData)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Macro _events_panel_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    
    If _event_type_ = #PB_EventType_MouseMove
      If _this_\tab\count
        If _this_\tab\bar\button[#bb_2]\len And 
           _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2])
          
          If _this_\tab\bar\button[#bb_2]\color\state <> #s_1
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_3
              _this_\tab\bar\button[#bb_2]\color\state = #s_1
            EndIf
            
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_0
              Debug " leave tab button - left to right"
              If _this_\tab\bar\button[#bb_1]\color\state <> #s_3 
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\index[#s_1] >= 0
              Debug " leave tab - " + _this_\tab\index[#s_1]
              _this_\tab\index[#s_1] =- 1
            EndIf
            Debug " enter tab button - right"
          EndIf
          
        ElseIf _this_\tab\bar\button[#bb_1]\len And
               _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1])
          
          If _this_\tab\bar\button[#bb_1]\color\state <> #s_1
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_3
              _this_\tab\bar\button[#bb_1]\color\state = #s_1
            EndIf
            
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_0
              Debug " leave tab button - right to left"
              If _this_\tab\bar\button[#bb_2]\color\state <> #s_3  
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\index[#s_1] >= 0
              Debug " leave tab - " + _this_\tab\index[#s_1]
              _this_\tab\index[#s_1] =- 1
            EndIf
            Debug " enter tab button - left"
          EndIf
          
        Else
          If _this_\tab\index[#s_1] =- 1
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_0
              Debug " leave tab button - left"
              If _this_\tab\bar\button[#bb_1]\color\state <> #s_3 
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_0
              Debug " leave tab button - right"
              If _this_\tab\bar\button[#bb_2]\color\state <> #s_3  
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
            EndIf
          EndIf
          
          ForEach _this_\tab\tabs()
            If _this_\tab\tabs()\drawing
              If _from_point_(mouse_x, mouse_y, _this_\tab\tabs()) And
                 _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_3])
                
                If _this_\tab\index[#s_1] <> _this_\tab\tabs()\index
                  If _this_\tab\index[#s_1] >= 0
                    Debug " leave tab - " + _this_\tab\index[#s_1]
                  EndIf
                  
                  _this_\tab\index[#s_1] = _this_\tab\tabs()\index
                  Debug " enter tab - " + _this_\tab\index[#s_1]
                EndIf
                Break
                
              ElseIf _this_\tab\index[#s_1] = _this_\tab\tabs()\index
                Debug " leave tab - " + _this_\tab\index[#s_1]
                _this_\tab\index[#s_1] =- 1
                Break
              EndIf
            EndIf
          Next
        EndIf
      EndIf
      
    ElseIf _event_type_ = #PB_EventType_LeftButtonDown
      If _this_\tab\index[#s_1] =- 1
        Select #s_1
          Case _this_\tab\bar\button[#bb_1]\color\state
            If Bar_ChangePos(_this_\tab\bar, (_this_\tab\bar\page\pos - _this_\tab\bar\scrollstep))   
              If Not _bar_in_start_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#bb_2]\color\state = #s_3 
                
                Debug " enable tab button - right"
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
              
              _this_\tab\bar\button[#bb_1]\color\state = #s_2
              Repaint = #True
            Else
              _this_\tab\bar\button[#bb_1]\color\state = #s_3
            EndIf
            
          Case _this_\tab\bar\button[#bb_2]\color\state 
            If Bar_ChangePos(_this_\tab\bar, (_this_\tab\bar\page\pos + _this_\tab\bar\scrollstep)) 
              If Not _bar_in_stop_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#bb_1]\color\state = #s_3 
                
                Debug " enable tab button - left"
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
              
              _this_\tab\bar\button[#bb_2]\color\state = #s_2 
              Repaint = #True
            Else
              _this_\tab\bar\button[#bb_2]\color\state = #s_3
            EndIf
            
        EndSelect
      Else
        Repaint = SetState(_this_, _this_\tab\index[#s_1])
      EndIf
    EndIf
    
    If _this_\width[2] > 90
      ; Минимальный размер когда будет показыватся вторая кнопка
      
      If _this_\tab\bar\button[#bb_2]\x > _this_\tab\bar\button[#bb_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1])
          If _this_\tab\bar\button[#bb_1]\color\state = #s_3 Or
             _this_\tab\bar\button[#bb_2]\color\state = #s_3 Or
             (Not _this_\tab\bar\button[#bb_1]\color\state And
              Not _this_\tab\bar\button[#bb_2]\color\state)
            
            If _this_\tab\bar\button[#bb_1]\x > _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#bb_1], _this_\x[2])
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#bb_1]\x < _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width
            If Not _bar_in_start_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#bb_1], _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#bb_1]\color\state And 
           _this_\tab\bar\button[#bb_1]\color\state <> #s_3
          _this_\tab\bar\button[#bb_1]\color\state = #s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#bb_2]\color\state And 
           _this_\tab\bar\button[#bb_2]\color\state <> #s_3
          _this_\tab\bar\button[#bb_2]\color\state = #s_3
        EndIf
      EndIf
      
      If _this_\tab\bar\button[#bb_1]\x < _this_\tab\bar\button[#bb_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2])
          If _this_\tab\bar\button[#bb_1]\color\state = #s_3 Or
             _this_\tab\bar\button[#bb_2]\color\state = #s_3 Or
             (Not _this_\tab\bar\button[#bb_1]\color\state And
              Not _this_\tab\bar\button[#bb_2]\color\state)
            
            If _this_\tab\bar\button[#bb_2]\x < _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#bb_2], _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width)
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#bb_2]\x > _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width
            If Not _bar_in_stop_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#bb_2], _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#bb_1]\color\state And 
           _this_\tab\bar\button[#bb_1]\color\state <> #s_3
          _this_\tab\bar\button[#bb_1]\color\state = #s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#bb_2]\color\state And 
           _this_\tab\bar\button[#bb_2]\color\state <> #s_3
          _this_\tab\bar\button[#bb_2]\color\state = #s_3
        EndIf
      EndIf
    EndIf
  EndMacro
  
  Macro _events_spin_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    
    If _event_type_ = #PB_EventType_MouseMove
      ;If _this_\tab\count
      If _this_\bar\button[#bb_2]\len And 
         _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_2])
        
        If _this_\bar\button[#bb_2]\color\state <> #s_1
          If _this_\bar\button[#bb_2]\color\state <> #s_3
            _this_\bar\button[#bb_2]\color\state = #s_1
          EndIf
          
          If _this_\bar\button[#bb_1]\color\state <> #s_0
            Debug " leave spin button - left to right"
            If _this_\bar\button[#bb_1]\color\state <> #s_3 
              _this_\bar\button[#bb_1]\color\state = #s_0
            EndIf
          EndIf
          
          If _this_\tab\index[#s_1] >= 0
            Debug " leave spin - " + _this_\tab\index[#s_1]
            _this_\tab\index[#s_1] =- 1
          EndIf
          Debug " enter spin button - right"
        EndIf
        
      ElseIf _this_\bar\button[#bb_1]\len And
             _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_1])
        
        If _this_\bar\button[#bb_1]\color\state <> #s_1
          If _this_\bar\button[#bb_1]\color\state <> #s_3
            _this_\bar\button[#bb_1]\color\state = #s_1
          EndIf
          
          If _this_\bar\button[#bb_2]\color\state <> #s_0
            Debug " leave spin button - right to left"
            If _this_\bar\button[#bb_2]\color\state <> #s_3  
              _this_\bar\button[#bb_2]\color\state = #s_0
            EndIf
          EndIf
          
          If _this_\tab\index[#s_1] >= 0
            Debug " leave spin - " + _this_\tab\index[#s_1]
            _this_\tab\index[#s_1] =- 1
          EndIf
          Debug " enter spin button - left"
        EndIf
        
      Else
        If _this_\tab\index[#s_1] =- 1
          If _this_\bar\button[#bb_1]\color\state <> #s_0
            Debug " leave spin button - left"
            If _this_\bar\button[#bb_1]\color\state <> #s_3 
              _this_\bar\button[#bb_1]\color\state = #s_0
            EndIf
          EndIf
          
          If _this_\bar\button[#bb_2]\color\state <> #s_0
            Debug " leave spin button - right"
            If _this_\bar\button[#bb_2]\color\state <> #s_3  
              _this_\bar\button[#bb_2]\color\state = #s_0
            EndIf
          EndIf
        EndIf
        
        ;           ForEach _this_\tab\tabs()
        ;             If _this_\tab\tabs()\drawing
        ;               If _from_point_(mouse_x, mouse_y, _this_\tab\tabs()) And
        ;                  _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_3])
        ;                 
        ;                 If _this_\tab\index[#s_1] <> _this_\tab\tabs()\index
        ;                   If _this_\tab\index[#s_1] >= 0
        ;                     Debug " leave tab - " + _this_\tab\index[#s_1]
        ;                   EndIf
        ;                   
        ;                   _this_\tab\index[#s_1] = _this_\tab\tabs()\index
        ;                   Debug " enter tab - " + _this_\tab\index[#s_1]
        ;                 EndIf
        ;                 Break
        ;                 
        ;               ElseIf _this_\tab\index[#s_1] = _this_\tab\tabs()\index
        ;                 Debug " leave tab - " + _this_\tab\index[#s_1]
        ;                 _this_\tab\index[#s_1] =- 1
        ;                 Break
        ;               EndIf
        ;             EndIf
        ;           Next
      EndIf
      ; EndIf
      
    ElseIf _event_type_ = #PB_EventType_LeftButtonDown
      ;       If _this_\tab\index[#s_1] =- 1
      ;         Select #s_1
      ;           Case _this_\bar\button[#bb_1]\color\state
      ;             If Bar_ChangePos(_this_\bar, (_this_\bar\page\pos - _this_\bar\scrollstep))   
      ;               If Not _bar_in_start_(_this_\bar) And 
      ;                  _this_\bar\button[#bb_2]\color\state = #s_3 
      ;                 
      ;                 Debug " enable tab button - right"
      ;                 _this_\bar\button[#bb_2]\color\state = #s_0
      ;               EndIf
      ;               
      ;               _this_\bar\button[#bb_1]\color\state = #s_2
      ;               Repaint = #True
      ;             Else
      ;               _this_\bar\button[#bb_1]\color\state = #s_3
      ;             EndIf
      ;             
      ;           Case _this_\bar\button[#bb_2]\color\state 
      ;             If Bar_ChangePos(_this_\bar, (_this_\bar\page\pos + _this_\bar\scrollstep)) 
      ;               If Not _bar_in_stop_(_this_\bar) And 
      ;                  _this_\bar\button[#bb_1]\color\state = #s_3 
      ;                 
      ;                 Debug " enable tab button - left"
      ;                 _this_\bar\button[#bb_1]\color\state = #s_0
      ;               EndIf
      ;               
      ;               _this_\bar\button[#bb_2]\color\state = #s_2 
      ;               Repaint = #True
      ;             Else
      ;               _this_\bar\button[#bb_2]\color\state = #s_3
      ;             EndIf
      ;             
      ;         EndSelect
      ;       Else
      ;         Repaint = SetState(_this_, _this_\tab\index[#s_1])
      ;       EndIf
    EndIf
    
  EndMacro
  
  Macro _events_bar_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    If _event_type_ = #PB_EventType_MouseMove
      If Not _this_\root\mouse\buttons
        If _this_\bar\button[#bb_3]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_3])
          If _this_\color[#bb_3]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_3
            Debug _this_\from
            _this_\color[#bb_3]\state = #s_1
            
;             If _this_\cursor
;               set_cursor(_this_, _this_\cursor)
;             EndIf
          EndIf
          
        ElseIf _this_\bar\button[#bb_2]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_2])
          If _this_\color[#bb_2]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_2
            Debug _this_\from
            _this_\color[#bb_2]\state = #s_1
          EndIf
          
        ElseIf _this_\bar\button[#bb_1]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_1])
          If _this_\color[#bb_1]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_1
            Debug _this_\from
            _this_\color[#bb_1]\state = #s_1
          EndIf
          
        Else
          If _this_\from <>- 1 ;And Not _from_point_(mouse_x,mouse_y, _this_\bar\button[_this_\from])
            If _this_\from >= 0
              ;_this_\color[_this_\from]\state = #s_0
              
;               If _this_\from = #bb_3
;                 If _this_\cursor
;                   set_cursor(_this_, #PB_Cursor_Default)
;                 EndIf
;               EndIf
              
            EndIf
            
            ;Debug _this_\from
            ;_this_\from =- 1
          EndIf
        EndIf
      EndIf
    EndIf
    
  EndMacro
  
  
  Procedure.i From(*this._S_widget, mouse_x.i, mouse_y.i)
  EndProcedure
  
  Procedure.i Events(*this._S_widget, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *this > 0
      
      ;       Root()\type = EventType
      ;       Root()\this = *this
      
      With *this
        Protected canvas = \root\canvas
        Protected window = \root\window
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LostFocus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0  : Repaint | w_Events(*this, EventType, at)
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                  Repaint = Bar_UpdatePos(*this, (mouse_y-\bar\thumb\len/2))
                Else
                  Repaint = Bar_UpdatePos(*this, (mouse_x-\bar\thumb\len/2))
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
                  Repaint | w_Events(*this, EventType, \index[#s_1])
                EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonDown : Repaint | w_Events(*this, EventType, at)
            ;             Debug "events() LeftButtonDown "+\type +" "+ at +" "+ *this
            Select \type 
              Case #PB_GadgetType_Window
                If at = 1
                  Free(*this)
                  
                  If *this = \root
                    PostEvent(#PB_Event_CloseWindow, \root\window, *this)
                    ;Post(#PB_Event_CloseWindow, *this, EventItem, EventData)
                  EndIf
                EndIf
                
              Case #PB_GadgetType_ComboBox
                \combo_box\checked ! 1
                
                If \combo_box\checked
                  Display_Popup(*this, \popup)
                Else
                  HideWindow(\popup\root\window, 1)
                EndIf
                
              Case #PB_GadgetType_Option
                Repaint = SetState(*this, 1)
                
              Case #PB_GadgetType_CheckBox
                Repaint = SetState(*this, Bool(\check_box\checked=#PB_Checkbox_Checked) ! 1)
                
              Case #PB_GadgetType_Tree,
                   #PB_GadgetType_ListView
                Repaint = Set_State(*this, \items(), \index[#s_1]) 
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\columns(), 0)
                  Repaint = Set_State(*this, \columns()\items(), \columns()\index[#s_1]) 
                EndIf
                
              Case #PB_GadgetType_HyperLink
                If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                
              Case #PB_GadgetType_Panel
                _events_panel_(*this, #PB_EventType_LeftButtonDown, mouse_x, mouse_y)
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin, #PB_GadgetType_Splitter
                Select at
                  Case #bb_1 : Repaint = SetState(*this, (\bar\page\pos - \bar\scrollstep)) ; Up button
                  Case #bb_2 : Repaint = SetState(*this, (\bar\page\pos + \bar\scrollstep)) ; Down button
                  Case #bb_3                                                                ; Thumb button
                    If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                      delta = mouse_y - \bar\thumb\pos
                    Else
                      delta = mouse_x - \bar\thumb\pos
                    EndIf
                EndSelect
                
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            w_Events(*this, EventType, *this\from)
            
            If delta
              If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                Repaint = Bar_UpdatePos(*this, (mouse_y-delta))
              Else
                Repaint = Bar_UpdatePos(*this, (mouse_x-delta))
              EndIf
            Else
              ;               If lastat <> at
              ;                 If lastat > 0 
              ;                   If lastat<4
              ;                     \color[lastat]\state = 0
              ;                   EndIf
              ;                   
              ;                 EndIf
              ;                 
              ;                 If \bar\max And ((at = 1 And _bar_in_start_(*this\bar)) Or (at = 2 And _bar_in_stop_(*this\bar)))
              ;                   \color[at]\state = 0
              ;                   
              ;                 ElseIf at>0 
              ;                   
              ;                   If at<4
              ;                     \color[at]\state = 1
              ;                     \color[at]\alpha = 255
              ;                   EndIf
              ;                   
              ;                 ElseIf at =- 1
              ;                   \color[1]\state = 0
              ;                   \color[2]\state = 0
              ;                   \color[3]\state = 0
              ;                   
              ;                   \color[1]\alpha = 128
              ;                   \color[2]\alpha = 128
              ;                   \color[3]\alpha = 128
              ;                 EndIf
              ;                 
              ;                 Repaint = #True
              ;                 lastat = at
              ;               EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \bar\scrollstep = 1
                  Repaint + ((\bar\max-\bar\min) / 100)
                Else
                  Repaint + \bar\scrollstep
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \bar\scrollstep = 1
                  Repaint - ((\bar\max-\bar\min) / 100)
                Else
                  Repaint - \bar\scrollstep
                EndIf
              EndIf
              
              Repaint = SetState(*this, (\bar\page\pos + Repaint))
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
              \index[#s_1] =- 1
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
                  \parent\index[#s_1] =- 1
                  
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
              Repaint | String_Events(*this, EventType, mouse_x.i, mouse_y.i)
              
            Case #PB_GadgetType_Editor
              Repaint | Editor_Events(*this, EventType)
              
          EndSelect
        EndIf
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*this._S_widget, EventType.i, mouse_x.i=0, mouse_y.i=0) ;.l CallBack(*this._S_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected result, enter, leave, Change
    
    If Root()\mouse\x <> mouse_x
      Root()\mouse\x = mouse_x
      Change = 1
    EndIf
    
    If Root()\mouse\y <> mouse_y
      Root()\mouse\y = mouse_y
      Change = 1
    EndIf
    
    If Change And LastElement(*this\childrens())
      Repeat 
        If Not *this\childrens()\hide
          enter = Bool(Root()\enter <> *this\childrens() And 
                       Not (Root()\enter And Root()\enter\index > *this\childrens()\index) And _from_point_(mouse_x, mouse_y, *this\childrens(), [#c_4]))
          leave = Bool(Root()\enter And (enter Or (Root()\enter = *this\childrens() And Not _from_point_(mouse_x, mouse_y, Root()\enter, [#c_4]))))
          
          If leave
            If Root()\enter\color\state <> #s_0
              Root()\enter\color\state = #s_0
              
              ;Post(#PB_EventType_MouseLeave, Root()\enter)
              result | Events(Root()\enter, Root()\enter\from, #PB_EventType_MouseLeave, mouse_x, mouse_y)
     
            EndIf
            
            Root()\enter = 0
          EndIf
          
          If enter
            Root()\enter = *this\childrens()
            
            If *this\childrens()\color\state <> #s_1
              *this\childrens()\color\state = #s_1
              
              ;Post(#PB_EventType_MouseEnter, Root()\enter)
              result | Events(*this\childrens(), *this\childrens()\from, #PB_EventType_MouseEnter, mouse_x, mouse_y)
     
            EndIf
            
            Break
          EndIf
        EndIf
        
      Until Not PreviousElement(*this\childrens())
    EndIf
    
    If Root()\enter 
      Protected *enter._S_widget = Root()\enter 
      
      If EventType = #PB_EventType_LeftButtonDown
        Root()\enter\state = 2 
        SetActive(Root()\enter)
      EndIf     
      
        If *enter
      With *enter 
        \root\mouse\x = mouse_x
        \root\mouse\y = mouse_y
        
        ; scrollbars events
        If \scroll
          If \scroll\v And Not \scroll\v\hide And \scroll\v\type And _from_point_(mouse_x,mouse_y, \scroll\v)
            *enter = \scroll\v
          ElseIf \scroll\h And Not \scroll\h\hide And \scroll\h\type And _from_point_(mouse_x,mouse_y, \scroll\h)
            *enter = \scroll\h
          EndIf
        EndIf
        
        
        ;_from_point_button_(*enter)
        ;_from_point_tab_(*enter, mouse_x, mouse_y, \tab)
        Protected Repaint
        _events_bar_(*enter, #PB_EventType_MouseMove, mouse_x, mouse_y)
        _events_panel_(*enter, #PB_EventType_MouseMove, mouse_x, mouse_y)
        _events_spin_(*enter, #PB_EventType_MouseMove, mouse_x, mouse_y)
        
        If ListSize(\items())
          ; items at point
          ForEach \items()
            If \items()\drawing
              If (mouse_x>\items()\x And mouse_x=<\items()\x+\items()\width And 
                  mouse_y>\items()\y And mouse_y=<\items()\y+\items()\height)
                
                \index[#s_1] = \items()\index
                ; Debug " i "+\index[#s_1]+" "+ListIndex(\items())
                Break
              Else
                \index[#s_1] =- 1
              EndIf
            EndIf
          Next
        EndIf
        
        If \type <> #PB_GadgetType_Editor
          ; Columns at point
          If ListSize(\columns())
            
            ForEach \columns()
              If \columns()\drawing
                If (mouse_x>=\columns()\x And mouse_x=<\columns()\x+\columns()\width+1 And 
                    mouse_y>=\columns()\y And mouse_y=<\columns()\y+\columns()\height)
                  
                  \index[#s_1] = \columns()\index
                  Break
                Else
                  \index[#s_1] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \columns()\items()
                If \columns()\items()\drawing
                  If (mouse_x>\x[2] And mouse_x=<\x[2]+\width[2] And 
                      mouse_y>\columns()\items()\y And mouse_y=<\columns()\items()\y+\columns()\items()\height)
                    \columns()\index[#s_1] = \columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          EndIf
        EndIf
        
      EndWith
    EndIf
    
     result | Events(*enter, *enter\from, EventType, mouse_x, mouse_y)
      ;  Debug Root()\enter
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure g_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      mouse_x = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      mouse_y = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Protected *root._S_root = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Repaint 
        Repaint = 1
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        ;Resize(*root, #PB_Ignore, #PB_Ignore, Width, Height)  
        *root\Width = Width
        *root\Height = Height 
        Repaint = 1
        
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        ; set mouse buttons
        If EventType = #PB_EventType_LeftButtonDown
          *root\mouse\buttons | #PB_Canvas_LeftButton
        ElseIf EventType = #PB_EventType_RightButtonDown
          *root\mouse\buttons | #PB_Canvas_RightButton
        ElseIf EventType = #PB_EventType_MiddleButtonDown
          *root\mouse\buttons | #PB_Canvas_MiddleButton
        EndIf
        
        ;Repaint | CallBack(From(*root, mouse_x, mouse_y), EventType, mouse_x, mouse_y)
        Repaint | CallBack(*root, EventType, mouse_x, mouse_y)
        
        ; reset mouse buttons
        If *root\mouse\buttons
          If EventType = #PB_EventType_LeftButtonUp
            *root\mouse\buttons &~ #PB_Canvas_LeftButton
          ElseIf EventType = #PB_EventType_RightButtonUp
            *root\mouse\buttons &~ #PB_Canvas_RightButton
          ElseIf EventType = #PB_EventType_MiddleButtonUp
            *root\mouse\buttons &~ #PB_Canvas_MiddleButton
          EndIf
        EndIf
    EndSelect
    
    If Repaint 
      Debug 777
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
    
    
    ;     If EventType = #PB_EventType_MouseMove
    ;       Static Last_X, Last_Y
    ;       If Last_Y <> mouse_y
    ;         Last_Y = mouse_y
    ;         Result | g_Events(EventGadget, EventType)
    ;       EndIf
    ;       If Last_x <> mouse_x
    ;         Last_x = mouse_x
    ;         Result | g_Events(EventGadget, EventType)
    ;       EndIf
    ;     Else
    Result | g_Events(EventGadget, EventType)
    ;     EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Procedure Events()
    Select *event\type
      Case #PB_EventType_MouseEnter
        Debug "enter - "+*event\widget\index
        If GetButtons(*event\widget)
          *event\widget\color\back = $00FF00
        Else
          *event\widget\color\back = $0000FF
        EndIf
        
      Case #PB_EventType_MouseLeave
        Debug "leave - "+*event\widget\index
        *event\widget\color\back = $FF0000
        
      Case #PB_EventType_Repaint
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(2,0, Str(*event\widget\index), 0)
        
    EndSelect
  EndProcedure
  
  Procedure Enumerates(*this._S_widget, *callback)
    With *this
      If *callback
        CallCFunctionFast(*callback, *this)
        
        If \count ; ListSize(\Childrens())
          ForEach \childrens()
            Enumerates(\childrens(), *callback)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure enum(*this._S_widget)
    ;  Bind(@Events(), *this)
  EndProcedure
  
  If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
    
    ; 
    Open(0, 0, 0, 220, 220, "", #PB_Flag_BorderLess)
    ;     Container(1, 20, 20, 180, 180)
    ;     Container(9,70, 10, 70, 180, #PB_Flag_NoGadget) ; bug
    ;     Container(2,20, 20, 180, 180)
    ;     Container(3,20, 20, 180, 180)
    ;     ;     Container(20, 20, 180, 180), 30)
    ;     Container(4,0, 20, 180, 30, #PB_Flag_NoGadget)
    ;     Container(5,0, 35, 180, 30, #PB_Flag_NoGadget)
    ;     Container(6,0, 50, 180, 30, #PB_Flag_NoGadget)
    ;     Container(7,20, 70, 180, 180, #PB_Flag_NoGadget)
    ;     ;  Container(20, 20, 180, 50), 200)
    ;     CloseList()
    ;     CloseList()
    ;     
    ;     Container(8,10, 70, 70, 180)
    ;     Container(10,10, 10, 70, 30, #PB_Flag_NoGadget)
    ;     Container(11,10, 20, 70, 30, #PB_Flag_NoGadget)
    ;     Container(12,10, 30, 70, 30, #PB_Flag_NoGadget)
    ;     CloseList()
    
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(70, 10, 70, 180, #PB_Flag_NoGadget), 9) 
    SetData(Container(20, 20, 180, 180), 2)
    SetData(Container(20, 20, 180, 180), 3)
    
    SetData(Container(0, 20, 180, 30, #PB_Flag_NoGadget), 4) 
    SetData(Container(0, 35, 180, 30, #PB_Flag_NoGadget), 5) 
    SetData(Container(0, 50, 180, 30, #PB_Flag_NoGadget), 6) 
    SetData(Splitter(20, 70, 180, 50, Container(0,0,0,0, #PB_Flag_NoGadget), Container(0,0,0,0, #PB_Flag_NoGadget), #PB_Splitter_Vertical), 7) 
    
    CloseList()
    CloseList()
    SetData(Container(10, 70, 70, 180), 8) 
    SetData(Container(10, 10, 70, 30, #PB_Flag_NoGadget), 10) 
    SetData(Container(10, 20, 70, 30, #PB_Flag_NoGadget), 11) 
    SetData(Container(10, 30, 70, 30, #PB_Flag_NoGadget), 12) 
    CloseList()
    
    ;     Define widget
    ;     While Enumerate(@widget, root())
    ;       Debug widget
    ;       Bind(@Events(), widget)
    ;     Wend
    Enumerates(root(), @enum())
    
    Bind(@Events(), root())
    Redraw(Root())
    
    
    If Open(-1, 0, 0, 755, 605, "Root", #PB_Flag_AnchorsGadget|#PB_Window_ScreenCentered);|#PB_Flag_AutoSize)
      Define *w,*w1,*w2
      
      Form     (8, 8, 356, 203, "window0")
      *w=Panel     (8, 8, 356, 203)
      AddItem (*w, -1, "Панель 1")
      
      *w1=Panel (5, 30, 340, 166)
      AddItem(*w1, -1, "Под-Панель 1")
      
      Tree(5, 5, 150, 100, #PB_Flag_Checkboxes|#PB_Tree_ThreeState)
      
      Define i
      For i=0 To 20
        If i=3
          AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
        Else
          AddItem(Widget(), i, "item_"+ Str(i))
        EndIf
      Next
      
      Editor(165, 5, 150, 100, #PB_Flag_Checkboxes|#PB_Tree_ThreeState)
      
      Define i
      For i=0 To 20
        If i=3
          AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
        Else
          AddItem(Widget(), i, "item_"+ Str(i))
        EndIf
      Next
      
      AddItem(*w1, -1, "Под-Панель 2")
      Bind(@Events(), Button( 5, 5, 55, 22, "hide_2"))
      Bind(@Events(), Button( 5, 30, 55, 22, "show_2"))
      
      *c=Container(110,5,150,155, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt") 
      CloseList()
      CloseList()
      CloseList()
      
      Container(10,75,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt1") 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      AddItem(*w1, -1, "Под-Панель 3")
      ;       Bind(@Events(), Button( 5, 5, 55, 22,"hide_3"))
      ;       Bind(@Events(), Button( 5, 30, 55, 22,"show_3"))
      
      *s=Splitter(110, 5, 300, 152, Splitter(5,5, 300, 152, Button(0, 0, 0, 0,"кнопка 15"), 
      Button(0, 0, 0, 0,"кнопка 15")), Button(0, 0, 0, 0,"кнопка 15"), #PB_Splitter_Vertical|#PB_Flag_AutoSize) 
      
      AddItem(*w1, -1, "Под-Панель 4")
      
      *w2=Panel (5, 30, 340, 166)
      AddItem(*w2, -1, "Под--Панель 1")
      AddItem(*w2, -1, "Под--Панель 2")
      Button( 5, 5, 55, 22, "кнопка 5")
      Button( 5, 30, 55, 22, "кнопка 30")
      AddItem(*w2, -1, "Под--Панель 3")
      AddItem(*w2, -1, "Под--Панель 4")
      AddItem(*w2, 1, "Под--Панель -2-")
      Button( 15, 5, 55, 22, "кнопка 15")
      Button( 20, 30, 55, 22, "кнопка 20")
      CloseList()
      SetState(*w2, 3)
      
      
      CloseList()
      
      Button(5, 5, 55, 22,"кнопка 5")
      
      AddItem (*w, -1,"Панель 2")
      Button(10, 15, 80, 24,"Кнопка 1")
      Button(95, 15, 80, 24,"Кнопка 2")
      CloseList()
      
      ;       Bind(@Events(), *w)
      ;       Bind(@Events(), *w1)
      ;       Bind(@Events(), *w2)
      
      Define *f=Form     (388, 8, 356, 303, "window1", 0)
      ;       Form     ( 8, 8, 256, 303, "window3", 0, Root()\opened)
      ;       Form     ( 8, 8, 256, 303, "window4", 0, Root()\opened)
      Define *sa = ScrollArea(10,10,140,140, 200,200)
      ;Button(10, 15, 80, 24,"Кнопка 1")
      Combobox(10, 15, 80, 24)
      AddItem(Widget(), -1, "Combobox")
      SetState(Widget(), 0)
      
      Button(95, 15, 80, 24,"Кнопка 2")
      CloseList()
      
      Spin(160, 10, 90, 41, 0, 10)
      Spin(160, 60, 90, 41, 0, 10, #PB_Flag_Vertical)
      
      *s=Splitter(10, 155, 300, 152, Splitter(5,5, 300, 152, Button(0, 0, 0, 0,"кнопка 3"), 
      Button(0, 0, 0, 0,"кнопка 1")), *sa, #PB_Splitter_Vertical) ;Button(0, 0, 0, 0,"кнопка 2"), #PB_Splitter_Vertical) 
      
      ;       ForEach Root()\childrens()
      ;         Debug Root()\childrens()\text\string
      ;       Next
      
      ReDraw(Root())
    EndIf
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------
; EnableXP