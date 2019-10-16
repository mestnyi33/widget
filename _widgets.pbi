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
      Bool(*Drag And _this_ And MapSize(*Drop()) And FindMapElement(*Drop(), Hex(_this_)) And *Drop()\Format = *Drag\Format And *Drop()\Type = *Drag\Type And *Drop()\Actions)
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
        *Drop()\Format = Format
        *Drop()\Actions = Actions
        *Drop()\Type = PrivateType
        *Drop()\widget = *this
      EndIf
      
    EndProcedure
    
    Procedure.i Text(Text.s, Actions.i=#PB_Drag_Copy)
      Debug "Drag text - " + Text
      *Drag = AllocateStructure(_S_drop)
      *Drag\Format = #PB_Drop_Text
      *Drag\Text = Text
      *Drag\Actions = Actions
      Cur(0)
    EndProcedure
    
    Procedure.i Image(Image.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag image - " + Image
      *Drag = AllocateStructure(_S_drop)
      *Drag\Format = #PB_Drop_Image
      *Drag\ImageID = ImageID(Image)
      *Drag\Width = ImageWidth(Image)
      *Drag\Height = ImageHeight(Image)
      *Drag\Actions = Actions
      Cur(0)
    EndProcedure
    
    Procedure.i Private(Type.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag private - " + Type
      *Drag = AllocateStructure(_S_drop)
      *Drag\Format = #PB_Drop_Private
      *Drag\Actions = Actions
      *Drag\Type = Type
      Cur(0)
    EndProcedure
    
    Procedure.i DropAction()
      If _action_(*Drag\widget) 
        ProcedureReturn *Drop()\Actions 
      EndIf
    EndProcedure
    
    Procedure.i DropType()
      If _action_(*Drag\widget) 
        ProcedureReturn *Drop()\Type 
      EndIf
    EndProcedure
    
    Procedure.s DropText()
      Protected result.s
      
      If _action_(*Drag\widget)
        Debug "  Drop text - "+*Drag\Text
        result = *Drag\Text
        FreeStructure(*Drag) 
        *Drag = 0
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    Procedure.i DropPrivate()
      Protected result.i
      
      If _action_(*Drag\widget)
        Debug "  Drop type - "+*Drag\Type
        result = *Drag\Type
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
          Result = CreateImage(#PB_Any, *Drag\Width, *Drag\Height) : Image = Result
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
  
  
  
  ;-
  ;- - CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Drop
  EndEnumeration
  
  #Anchors = 9+4
  
  #Anchor_moved = 9
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version<547 : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    
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
  
  #PB_GadgetType_Root =- 5
  #PB_GadgetType_Toolbar =- 4
  #PB_GadgetType_Popup =- 3
  #PB_GadgetType_Menu =- 2
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Property = 40
  ;
;   #PB_Bar_Minimum = 1
;   #PB_Bar_Maximum = 2
;   #PB_Bar_PageLength = 3
;   
;   EnumerationBinary 4
;     #PB_Bar_NoButtons ;= 5
;     #PB_Bar_Inverted 
;     #PB_Bar_Direction ;= 6
;     #PB_Bar_Smooth 
;     #PB_Bar_Ticks 
;   EndEnumeration
  
  
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
    
    #PB_Bar_First
    #PB_Bar_Second
    #PB_Bar_FirstFixed
    #PB_Bar_SecondFixed
    #PB_Bar_FirstMinimumSize
    #PB_Bar_SecondMinimumSize
  EndEnumeration
  
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
    
    #PB_Flag_Limit
  EndEnumeration
  
  ;#PB_Bar_Vertical = #PB_Vertical
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
  
  Prototype pFunc()
  
  
  ;- - STRUCTUREs
  ;- - _S_point
  Structure _S_point
    y.i
    x.i
  EndStructure
  
  ;- - _S_Coordinate
  Structure _S_coordinate Extends _S_point
    height.i
    width.i
  EndStructure
  
  ;- - _S_Mouse
  Structure _S_mouse Extends _S_point
    buttons.i 
    direction.i
    *delta._S_mouse
  EndStructure
  
  ;- - _S_Keyboard
  Structure _S_keyboard
    input.c
    key.i[2]
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    interact.b
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_box
  Structure _S_box
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
    
    size.i[4]
    hide.b[4]
    checked.b[2] 
    ;toggle.b
    
    arrow_size.a[3]
    arrow_type.b[3]
    
    threeState.b
    *color._S_color[4]
  EndStructure
  
  ;- - _S_Color
  Structure _S_color
    state.b ; entered; selected; focused; lostfocused
    front.i[4]
    line.i[4]
    fore.i[4]
    back.i[4]
    frame.i[4]
    alpha.a[2]
  EndStructure
  
  ;- - _S_anchor
  Structure _S_anchor Extends _S_coordinate
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
  
  ;- - _S_Page
  Structure _S_page
    pos.i
    len.i
    *end
  EndStructure
  
  ;- - _S_Align
  Structure _S_align Extends _S_point
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
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
  
  ;- - _S_Flag
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
  
  ;- - _S_Image
  Structure _S_image
    y.i[3]
    x.i[3]
    height.i
    width.i
    
    index.i
    imageID.i[2] ; - editor
    change.b
    
    align._S_align
  EndStructure
  
  ;- - _S_Text
  Structure _S_text 
    y.i[3]
    x.i[3]
    height.i[2]
    width.i[2]
    
    big.i[3]
    pos.i
    len.i
    caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    fontID.i
    string.s[3]
    change.b
    
    lower.b
    upper.b
    pass.b
    editable.b
    numeric.b
    multiLine.b
    vertical.b
    rotate.f
    
    align._S_align
  EndStructure
  
  ;- - _S_Scroll
  Structure _S_scroll
    y.i
    x.i
    height.i[4] ; - EditorGadget
    width.i[4]
    
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;- - _S_Items
  Structure _S_items Extends _S_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    drawing.i
    
    image._S_image
    text._S_text[4]
    *box._S_box
    *i_parent._S_items
    
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
  
  ;- - _S_Popup
  Structure _S_popup
    gadget.i
    window.i
    
    ; *Widget._S_widget
  EndStructure
  
  ;- - _S_Margin
  Structure _S_margin
    FonyID.i
    Width.i
    Color._S_color
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget 
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
    
    *event._S_event 
    *splitter._S_splitter
  *_gadget._S_widget ; active gadget
    
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *parent._S_widget ; adress parent
    *scroll._S_scroll 
    
    mode.b  ; track bar
    
    from.i
    type.b[3] ; [2] for splitter
    radius.a
    cursor.i[2]
    
    
    hide.b[2]
    *box._S_box
    
    focus.b
    change.i[2]
    resize.b
    vertical.b
    inverted.b
    direction.i
    scrollstep.i
    
    max.i
    min.i
    page._S_page
    area._S_page
    thumb._S_page
    button._S_button[4]
    
    color._S_color[4]
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    parent_item.i ; index parent tab item
    *i_Parent._S_items
    *data
    
    *Deactive._S_widget
    *Leave._S_widget
    
    *Popup._S_widget
    *option_group._S_widget
    
    fs.i 
    bs.i
    Grid.i
    Enumerate.i
    TabHeight.i
    
    Level.l ; Вложенность виджета
    Class.s ; 
    
    type_index.l ; 
    type_count.l ; 
    
    List *childrens._S_widget()
    List *items._S_items()
    List *columns._S_widget()
    ;List *draws._S_items()
    
    Flag._S_flag
    *Text._S_text[4]
    *Image._S_image[2]
    *Align._S_align
    
    sublevellen.i
    Drag.i[2]
    Attribute.i
    
    Mouse._S_mouse 
    
    ; editor
    Keyboard._S_keyboard
    margin._S_margin
    
    ;create.b
    
    repaint.i
    *anchor._S_anchor[#Anchors+1]
    *selector._S_anchor[#Anchors+1]
  EndStructure
  
  ;- - _S_canvas
  Structure _S_canvas
    window.i
    gadget.i
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._S_bar
    *second;._S_bar
    
    fixed.i[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_event
  Structure _S_event 
    *callback.pFunc
    *widget._S_widget
    type.l
    item.l
    *data
    
    ;*leave._S_widget  
    *enter._S_widget  
    *root._S_root
    
    ;draw.b
  EndStructure
  
  ;- - _S_root
  Structure _S_root Extends _S_widget
    canvas._S_canvas
    *opened._S_widget
    *active._S_widget
    
    eventbind.b
    List *eventlist._S_event()
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
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root)
  EndMacro
  
  Macro _Gadget()
    Root()\canvas\gadget
  EndMacro
  
  Macro _Window()
    Root()\canvas\window
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
  
  Macro GetFocus() ; active gadget 
    Root()\active\_gadget
  EndMacro
  
  Macro GetActive() ; active window
    Root()\active
  EndMacro
  
  Macro Adress(_this_)
    _this_\adress
  EndMacro
  
  
  ;   Macro IsBar(_this_)
  ;     Bool(_this_ And (_this_\type = #PB_GadgetType_ScrollBar Or _this_\type = #PB_GadgetType_TrackBar Or _this_\type = #PB_GadgetType_ProgressBar Or _this_\type = #PB_GadgetType_Splitter))
  ;   EndMacro
  
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
  ;   Debug Root()\this
  ;   Debug IsWidget(345345345999)
  
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
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
  
  ; Then scroll bar start position
  Macro _scroll_in_start_(_this_) : Bool(_this_\page\pos =< _this_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\page\pos >= (_this_\max-_this_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
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
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  Macro IsFunction(_this_)
    (Bool(_this_\function) << 1) + (Bool(_this_\window And 
                                         _this_\window\function And 
                                         _this_\window<>_this_\root And 
                                         _this_\window<>_this_ And 
                                         _this_\root<>_this_) << 2) + (Bool(_this_\root And _this_\root\function) << 3)
  EndMacro
  
  ;   Macro Match(_value_, _grid_, _max_=$7FFFFFFF)
  ;     ((Bool((_value_)>(_max_)) * (_max_)) + (Bool((_grid_) And (_value_)<(_max_)) * (Round(((_value_)/(_grid_)), #PB_Round_Nearest) * (_grid_))))
  ;   EndMacro
  
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget())
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget())
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget(), _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget(), _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget(), _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget(), _type_, _actions_)
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
  
;   Declare.i GetFocus()
;   Declare.i GetActive()
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
  Declare.i Event_Widgets(*this, EventType.i, EventItem.i=-1, EventData.i=0)
  Declare.i Events(*this, at.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i = 0)
  
  ;- GLOBALs
  Global def_colors._S_color
  
   With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#Normal] = $FFE2E2E2 ; $80E2E2E2
    \frame[#Normal] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFEAEAEA ; $FFFAF8F8
    \back[#Entered] = $FFCECECE ; $80FCEADA
    \frame[#Entered] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#Selected] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#Selected] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    
  EndWith
  
  Macro _set_def_colors_(_this_)
    ;*event\widget = _this_
    _this_\scrollstep = 1
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\color[#_b_1] = def_colors
    _this_\color[#_b_2] = def_colors
    _this_\color[#_b_3] = def_colors
  EndMacro
  
  
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
   Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    *event\widget = _this_
    _this_\type = _type_
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    If _parent_
      SetParent(_this_, _parent_, _parent_\o_i)
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
    (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    If _this_\Vertical 
      _this_\button\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\y = _this_\area\pos
      _this_\button\width = _this_\width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\height = _this_\area\len               
    Else 
      _this_\button\x = _this_\area\pos
      _this_\button\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\width = _this_\area\len
      _this_\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\button[#_b_1]\len And _this_\button[#_b_1]\len <> 1
      If _scroll_pos_ = _this_\min
        _this_\color[#_b_1]\state = #Disabled
        _this_\button[#_b_1]\interact = 0
      Else
        _this_\color[#_b_1]\state = #Normal
        _this_\button[#_b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\button[#_b_1]\x = _this_\button\x
        _this_\button[#_b_1]\y = _this_\Y 
        _this_\button[#_b_1]\width = _this_\button\width
        _this_\button[#_b_1]\height = _this_\button[#_b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\button[#_b_1]\x = _this_\X 
        _this_\button[#_b_1]\y = _this_\button\y
        _this_\button[#_b_1]\width = _this_\button[#_b_1]\len 
        _this_\button[#_b_1]\height = _this_\button\height 
      EndIf
    Else
      _this_\button[#_b_1]\x = _this_\X
      _this_\button[#_b_1]\y = _this_\Y
      
      If _this_\Vertical
        _this_\button[#_b_1]\width = _this_\width
        _this_\button[#_b_1]\height = _this_\thumb\pos-_this_\y
      Else
        _this_\button[#_b_1]\width = _this_\thumb\pos-_this_\x
        _this_\button[#_b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\button[#_b_2]\len And _this_\button[#_b_2]\len <> 1
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_b_2]\state = #Disabled
        _this_\button[#_b_2]\interact = 0
      Else
        _this_\color[#_b_2]\state = #Normal
        _this_\button[#_b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\button[#_b_2]\x = _this_\button\x
        _this_\button[#_b_2]\width = _this_\button\width
        _this_\button[#_b_2]\height = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\y = _this_\Y+_this_\Height-_this_\button[#_b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\button[#_b_2]\y = _this_\button\y
        _this_\button[#_b_2]\height = _this_\button\height
        _this_\button[#_b_2]\width = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\x = _this_\X+_this_\width-_this_\button[#_b_2]\width 
      EndIf
      
    Else
      If _this_\Vertical
        _this_\button[#_b_2]\x = _this_\x
        _this_\button[#_b_2]\y = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\width = _this_\width
        _this_\button[#_b_2]\height = _this_\height-(_this_\thumb\pos+_this_\thumb\len-_this_\y)
      Else
        _this_\button[#_b_2]\x = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\y = _this_\Y
        _this_\button[#_b_2]\width = _this_\width-(_this_\thumb\pos+_this_\thumb\len-_this_\x)
        _this_\button[#_b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\thumb\len
      If _this_\button[#_b_3]\len <> _this_\thumb\len
        _this_\button[#_b_3]\len = _this_\thumb\len
      EndIf
      
      If _this_\Vertical
        _this_\button[#_b_3]\x = _this_\button\x 
        _this_\button[#_b_3]\width = _this_\button\width 
        _this_\button[#_b_3]\y = _this_\thumb\pos
        _this_\button[#_b_3]\height = _this_\thumb\len                              
      Else
        _this_\button[#_b_3]\y = _this_\button\y 
        _this_\button[#_b_3]\height = _this_\button\height
        _this_\button[#_b_3]\x = _this_\thumb\pos 
        _this_\button[#_b_3]\width = _this_\thumb\len                                  
      EndIf
      
    Else
      If _this_\type <> #PB_GadgetType_ProgressBar
        ; Эфект спин гаджета
        If _this_\Vertical
          _this_\button[#_b_2]\Height = _this_\Height/2 
          _this_\button[#_b_2]\y = _this_\y+_this_\button[#_b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\button[#_b_1]\y = _this_\y 
          _this_\button[#_b_1]\Height = _this_\Height/2
          
        Else
          _this_\button[#_b_2]\width = _this_\width/2 
          _this_\button[#_b_2]\x = _this_\x+_this_\button[#_b_2]\width+Bool(_this_\width%2) 
          
          _this_\button[#_b_1]\x = _this_\x 
          _this_\button[#_b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\text
      _this_\text\change = 1
    EndIf
    
    ; Splitter childrens auto resize       
    If _this_\Splitter
      splitter_size(_this_)
    EndIf
    
    If _this_\change
      Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\direction)
    EndIf
  EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\vertical
      _this_\area\pos = _this_\y + _this_\button[#_b_1]\len
      _this_\area\len = _this_\height - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    Else
      _this_\area\pos = _this_\x + _this_\button[#_b_1]\len
      _this_\area\len = _this_\width - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\thumb\pos-_this_\y)
      Resize(_this_\splitter\second, 0, (_this_\thumb\pos+_this_\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\thumb\pos+_this_\thumb\len)-_this_\y))
    Else
      Resize(_this_\splitter\first, 0, 0, _this_\thumb\pos-_this_\x, _this_\height)
      Resize(_this_\splitter\second, (_this_\thumb\pos+_this_\thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Procedure.b splitter_size(*this._S_widget)
;     Debug 5555
     Resize_Splitter(*this)
      ProcedureReturn
     
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, (*this\button[#_b_2]\height+*this\thumb\len)-*this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          ; splitter_size(*this\splitter\first)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, (*this\button[#_b_1]\height+*this\thumb\len)-*this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          ; splitter_size(*this\splitter\second)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
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
      Protected.i Px,Py, Grid = \Grid, IsGrid = Bool(Grid>1)
      
      If \parent
        Px = \parent\x[#_c_2]
        Py = \parent\y[#_c_2]
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
  
  Procedure CallBack_Anchors(*this._S_widget, EventType.i, Buttons.i, MouseX.i,MouseY.i)
    Protected i 
    
    With *this
      If \root\anchor 
        Select EventType 
          Case #PB_EventType_MouseMove
            If \root\anchor\state = 2
              
              ProcedureReturn Anchors_Events(\root\anchor\widget, MouseX-\root\anchor\delta_x, MouseY-\root\anchor\delta_y)
              
            ElseIf Not Buttons
              ; From anchor
              For i = 1 To #Anchors 
                If \root\anchor[i]
                  If (MouseX>\root\anchor[i]\x And MouseX=<\root\anchor[i]\x+\root\anchor[i]\width And 
                      MouseY>\root\anchor[i]\y And MouseY=<\root\anchor[i]\y+\root\anchor[i]\height)
                    
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
            \root\anchor\delta_x = MouseX-\root\anchor\x
            \root\anchor\delta_y = MouseY-\root\anchor\y
            
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
        
        \Grid = \parent\Grid
      Else
        If \container
          \Grid = Size
        Else
          \Grid = Size
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
    Protected MouseX =- 1
    Protected MouseY =- 1
    
    If *this
      With *this
        Select Event()
          Case #PB_Event_ActivateWindow
            Protected *Widget._S_widget = GetGadgetData(\root\canvas\gadget)
            
            If CallBack(\childrens(), #PB_EventType_LeftButtonDown, WindowMouseX(\root\canvas\window), WindowMouseY(\root\canvas\window))
              ; If \childrens()\index[2] <> \childrens()\index[1]
              *Widget\index[2] = \childrens()\index[1]
              Post(#PB_EventType_Change, *Widget, \childrens()\index[1])
              
              SetText(*Widget, GetItemText(\childrens(), \childrens()\index[1]))
              \childrens()\index[2] = \childrens()\index[1]
              \childrens()\mouse\buttons = 0
              \childrens()\index[1] =- 1
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
            MouseX = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            MouseY= GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
            
            If CallBack(From(*this, MouseX, MouseY), EventType(), MouseX, MouseY)
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
        
        ForEach *Widget\childrens()\Items()
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
      If Style > 0 : x-1 : y+1
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
      If Style > 0 : y-1 ;: x + 1
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
  Macro Resize_Childrens(_this_, _change_x_, _change_y_)
    ForEach _this_\childrens()
      Resize(_this_\childrens(), (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_, (_this_\childrens()\y-_this_\y-_this_\bs-_this_\tabHeight) + _change_y_, #PB_Ignore, #PB_Ignore)
    Next
  EndMacro
  
  Procedure Init_Event( *this._S_widget)
    If *this
      With *this
        If ListSize(\childrens())
          ForEach \childrens()
            If \childrens()\deactive
              If \childrens()\deactive <> \childrens()
                Events(\childrens()\deactive, \childrens()\deactive\from, #PB_EventType_LostFocus, 0, 0)
              EndIf
              
              Events(\childrens(), \childrens()\from, #PB_EventType_Focus, 0, 0)
              \childrens()\deactive = 0
            EndIf
            
            If ListSize(\childrens()\childrens())
              Init_Event(\childrens())
            EndIf
          Next
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      Right =- TextWidth(Mid(\text\string.s, \Items()\text\pos, \text\caret))
      Left = (Width + Right)
      
      If \scroll\x < Right
        ; Scroll::SetState(\scroll\h, -Right)
        \scroll\x = Right
      ElseIf \scroll\x > Left
        ; Scroll::SetState(\scroll\h, -Left) 
        \scroll\x = Left
      ElseIf (\scroll\x < 0 And \Keyboard\Input = 65535 ) : \Keyboard\Input = 0
        \scroll\x = (Width-\Items()\text[3]\width) + Right
        If \scroll\x>0 : \scroll\x=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  ; SET_
  Procedure.i Set_State(*this._S_widget, List *this_item._S_items(), State.i)
    Protected Repaint.i, sublevel.i, Mouse_X.i, Mouse_Y.i
    
    With *this
      If ListSize(*this_Item())
        Mouse_X = \mouse\x
        Mouse_Y = \mouse\y
        
        If State >= 0 And SelectElement(*this_Item(), State) 
          If (Mouse_Y > (*this_Item()\box\y[1]) And Mouse_Y =< ((*this_Item()\box\y[1]+*this_Item()\box\height[1]))) And 
             ((Mouse_X > *this_Item()\box\x[1]) And (Mouse_X =< (*this_Item()\box\x[1]+*this_Item()\box\width[1])))
            
            *this_Item()\box\checked[1] ! 1
          ElseIf (\flag\buttons And *this_Item()\childrens) And
                 (Mouse_Y > (*this_Item()\box\y[0]) And Mouse_Y =< ((*this_Item()\box\y[0]+*this_Item()\box\height[0]))) And 
                 ((Mouse_X > *this_Item()\box\x[0]) And (Mouse_X =< (*this_Item()\box\x[0]+*this_Item()\box\width[0])))
            
            sublevel = *this_Item()\sublevel
            *this_Item()\box\checked ! 1
            \change = 1
            
            PushListPosition(*this_Item())
            While NextElement(*this_Item())
              If sublevel = *this_Item()\sublevel
                Break
              ElseIf sublevel < *this_Item()\sublevel And *this_Item()\i_Parent
                *this_Item()\hide = Bool(*this_Item()\i_Parent\box\checked Or *this_Item()\i_Parent\hide) * 1
              EndIf
            Wend
            PopListPosition(*this_Item())
            
          ElseIf \index[2] <> State : *this_Item()\state = 2
            If \index[2] >= 0 And SelectElement(*this_Item(), \index[2])
              *this_Item()\state = 0
            EndIf
            ; GetState() - Value = \index[2]
            \index[2] = State
            
            Debug "set_state() - "+State;\index[1]+" "+ListIndex(\items())
                                        ; Post change event to widget (tree, listview)
            Event_Widgets(*this, #PB_EventType_Change, State)
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
              CursorX.i, MouseX.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      If Line < 0 And FirstElement(*this\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*this\Items()) And 
             SelectElement(*this\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          Len = \Items()\text\len
          FontID = \Items()\text\fontID
          String.s = \Items()\text\string.s
          If Not FontID : FontID = \text\fontID : EndIf
          MouseX = \mouse\x - (\Items()\text\x+\scroll\x)
          
          If StartDrawing(CanvasOutput(\root\canvas\gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (MouseX-X)*(MouseX-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \text\caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\Items())
            ;             If \mouse\y < \y+(\text\height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\mouse\y-\y-\text\y)-\scroll\y) / (\text\height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \Index[1] Or LastItem <> Item
            ;               \Items()\text[2]\width[2] = 0
            ;               
            ;               If (\Items()\text\string.s = "" And Item = \Index[1] And Position = len) Or
            ;                  \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
            ;                  (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*this\Items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \Items()\text[2]\len : \Items()\text[2]\len = 1
            ;                   \Items()\text[2]\x = \Items()\text\x+\Items()\text\width
            ;                 EndIf 
            ;                 
            ;                 ; \Items()\text[2]\width = (\Items()\width-\Items()\text\width) + TextWidth(\Items()\text[2]\string.s)
            ;                 
            ;                 If \flag\fullSelection
            ;                   \Items()\text[2]\width[2] = \flag\fullSelection
            ;                 Else
            ;                   \Items()\text[2]\width[2] = \Items()\width-\Items()\text\width
            ;                 EndIf
            ;               EndIf
            ;               
            ;               LastItem = Item
            ;               LastLine = \Index[1]
            ;             EndIf
            ;             PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*this\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\text\len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Editor_Change(*this._S_widget, Pos.i, Len.i)
    With *this
      \Items()\text[2]\pos = Pos
      \Items()\text[2]\len = Len
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \text[1]\change = #True
      EndIf
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \text[3]\change = 1
      EndIf
      
      ; lines string/pos/len/state
      \Items()\text[1]\change = #True
      \Items()\text[1]\len = \Items()\text[2]\pos
      \Items()\text[1]\string.s = Left(\Items()\text\string.s, \Items()\text[1]\len) 
      
      \Items()\text[3]\change = #True
      \Items()\text[3]\pos = (\Items()\text[2]\pos + \Items()\text[2]\len)
      \Items()\text[3]\len = (\Items()\text\len - \Items()\text[3]\pos)
      \Items()\text[3]\string.s = Right(\Items()\text\string.s, \Items()\text[3]\len) 
      
      If \Items()\text[1]\len = \Items()\text[3]\pos
        \Items()\text[2]\string.s = ""
        \Items()\text[2]\width = 0
      Else
        \Items()\text[2]\change = #True 
        \Items()\text[2]\string.s = Mid(\Items()\text\string.s, 1 + \Items()\text[2]\pos, \Items()\text[2]\len) 
      EndIf
      
      If (\text[1]\change Or \text[3]\change)
        If \text[1]\change
          \text[1]\len = (\Items()\text[0]\pos + \Items()\text[1]\len)
          \text[1]\string.s = Left(\text\string.s[1], \text[1]\len) 
          \text[2]\pos = \text[1]\len
        EndIf
        
        If \text[3]\change
          \text[3]\pos = (\Items()\text[0]\pos + \Items()\text[3]\pos)
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
      ;         Debug "chang "+\Items()\text\string.s +" "+ CountString(\text[3]\string.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure.i Editor_SelText(*this._S_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *this
      ;Debug "7777    "+\text\caret +" "+ \text\caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\text\string
      
      If (Caret <> \text\caret Or Line <> \Index[1] Or (\text\caret[1] >= 0 And Caret1 <> \text\caret[1]))
        \Items()\text[2]\string.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \text\caret[1] = \text\caret And \Items()\text[2]\len 
            \Items()\text[2]\len = 0 
            \Items()\text[2]\width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\text[2]\len 
            \Items()\text[2]\width[2] = 0 
            \Items()\text[2]\len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\text[2]\len 
            \Items()\text[2]\len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\text[2]\len 
            \Items()\text[2]\len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \text\caret[1] = \text\caret 
            Pos = \text\caret[1]
            ;             If \text\caret[1] = \Items()\text\len
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
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \text\caret
          Len = \Items()\text\len-Pos
          ; Len - Bool(\Items()\text\len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \text\caret
        EndIf
        
        Editor_Change(*this, Pos, Len)
        
        Line = \Index[1]
        Caret = \text\caret
        Caret1 = \text\caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i Editor_SelReset(*this._S_widget)
    With *this
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\text[2]\len <> 0
          \Items()\text[2]\len = 0 
          \Items()\text[2]\width[2] = 0 
          \Items()\text[1]\string = ""
          \Items()\text[2]\string = "" 
          \Items()\text[3]\string = ""
          \Items()\text[2]\width = 0 
        EndIf
      Next
      PopListPosition(\Items())
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
      char = Asc(Mid(\Items()\text\string.s, \text\caret + 1, 1))
      If _is_selection_end_(char)
        \text\caret + 1
        \Items()\text[2]\len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \text\caret To 1 Step - 1
          char = Asc(Mid(\Items()\text\string.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \text\caret To \Items()\text\len
          char = Asc(Mid(\Items()\text\string.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \text\caret = i - 1
        \Items()\text[2]\len = \text\caret[1] - \text\caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Editor_Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \text\big) ;And \Items()\text\x+\Items()\text\width > \Items()\x+\Items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \Items()\text\string.s
        Protected string_len.i = \Items()\text\len
        Protected mouse_x.i = \mouse\x-(\Items()\text\x+\scroll\x)
        
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
        \Items()\text[3]\width = TextWidth(Right(String.s, string_len-Caret))
        
        If \scroll\x < Right
          SetState(\scroll\h, -Right) ;: \scroll\x = Right
        ElseIf \scroll\x > Left
          SetState(\scroll\h, -Left) ;: \scroll\x = Left
        ElseIf (\scroll\x < 0 And \Keyboard\Input = 65535 ) : \Keyboard\Input = 0
          \scroll\x = (Width-\Items()\text[3]\width) + Right
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
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        Editor_SelReset(*this)
        
        If Count
          \Index[2] + Count
          \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \text\caret = 0
        Else
          \text\caret = \Items()\text[1]\len + Len(Chr.s)
        EndIf
        
        \text\caret[1] = \text\caret
        \Index[1] = \Index[2]
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
          If \Items()\text[2]\len 
            If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
            \Items()\text[2]\len = 0 : \Items()\text[2]\string.s = "" : \Items()\text[2]\change = 1
          EndIf
          
          \Items()\text[1]\change = 1
          \Items()\text[1]\string.s + Chr.s
          \Items()\text[1]\len = Len(\Items()\text[1]\string.s)
          
          \Items()\text\string.s = \Items()\text[1]\string.s + \Items()\text[3]\string.s
          \Items()\text\len = \Items()\text[1]\len + \Items()\text[3]\len : \Items()\text\change = 1
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \text\caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret + Len(Chr.s) 
          EndIf
          
          \text\string.s[1] = \text[1]\string + Chr.s + \text[3]\string
          \text\caret[1] = \text\caret 
          ; \countItems = CountString(\text\string.s[1], #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\Items(), \index[2]) 
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
      If _this_\scroll And Not _this_\hide And Not _this_\Items()\hide
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
        
        ;       If _this_\scroll\width < _this_\width[#_c_2]-(Bool(Not _this_\scroll\v\hide) * _this_\scroll\v\width)
        ;         _this_\scroll\width = _this_\width[#_c_2]-(Bool(Not _this_\scroll\v\hide) * _this_\scroll\v\width)
        ;       EndIf
        
        ;        If _this_\scroll\height < _this_\height[#_c_2]-(Bool(Not _this_\scroll\h\hide) * _this_\scroll\h\height)
        ;         _this_\scroll\height = _this_\height[#_c_2]-(Bool(Not _this_\scroll\h\hide) * _this_\scroll\h\height)
        ;       EndIf
        
        _this_\text\big = _this_\Items()\Index ; Позиция в тексте самой длинной строки
        _this_\text\big[1] = _this_\Items()\text\pos ; Может и не понадобятся
        _this_\text\big[2] = _this_\Items()\text\len ; Может и не понадобятся
        
        
        ; _this_\scroll\h\max = _this_\scroll\width
        ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
      EndIf
    EndMacro
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\ImageID
        If _this_\flag\InLine
          Text_Y=((Height-(_this_\text\height*_this_\countItems))/2)
          Image_Y=((Height-_this_\Image\height)/2)
        Else
          If _this_\text\align\bottom
            Text_Y=((Height-_this_\Image\height-(_this_\text\height*_this_\countItems))/2)-Indent/2
            Image_Y=(Height-_this_\Image\height+(_this_\text\height*_this_\countItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\text\height*_this_\countItems)+_this_\Image\height)/2)+Indent/2
            Image_Y=(Height-(_this_\text\height*_this_\countItems)-_this_\Image\height)/2-Indent/2
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
      If _this_\Image\ImageID
        If _this_\flag\InLine
          If _this_\text\align\right
            Text_X=((Width-_this_\Image\width-_this_\Items()\text\width)/2)-Indent/2
            Image_X=(Width-_this_\Image\width+_this_\Items()\text\width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\text\width+_this_\Image\width)/2)+Indent
            Image_X=(Width-_this_\Items()\text\width-_this_\Image\width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\width)/2 
          Text_X=(Width-_this_\Items()\text\width)/2 
        EndIf
      Else
        If _this_\text\align\right
          Text_X=(Width-_this_\Items()\text\width)
        ElseIf _this_\text\align\horizontal
          Text_X=(Width-_this_\Items()\text\width-Bool(_this_\Items()\text\width % 2))/2 
        Else
          Text_X=_this_\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\x + 5
      _this_\Items()\width = Width
      _this_\Items()\text\x = _this_\Items()\x+Text_X
      
      _this_\Image\x = _this_\text\x+Image_X
      _this_\Items()\Image\x = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\y+_this_\scroll\height+Text_Y + 2
      _this_\Items()\height = _this_\text\height - Bool(_this_\countItems<>1 And _this_\flag\GridLines)
      _this_\Items()\text\y = _this_\Items()\y + (_this_\text\height-_this_\text\height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\countItems<>1)
      _this_\Items()\text\height = _this_\text\height[1]
      
      _this_\Image\y = _this_\text\y+Image_Y
      _this_\Items()\Image\y = _this_\Items()\y + (_this_\text\height-_this_\Items()\Image\height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\Items()\text\pos = _this_\text\pos - Bool(_this_\text\multiLine = 1)*_this_\Items()\index ; wordwrap
      _this_\Items()\text\len = Len(_this_\Items()\text\string.s)
      _this_\text\pos + _this_\Items()\text\len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *this
      \countItems = ListSize(\Items())
      
      Width = \width[#_c_2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) - \margin\width
      Height = \height[#_c_2] - Bool(Not \scroll\h\hide) * \scroll\h\height
      
      \Items()\Index[1] =- 1
      ;\Items()\focus =- 1
      \Items()\Index = Line
      \Items()\radius = \radius
      \Items()\text\string.s = String.s
      
      ; Set line default color state           
      \Items()\state = 1
      
      ; Update line pos in the text
      _set_line_pos_(*this)
      
      _set_content_X_(*this)
      _line_resize_X_(*this)
      _line_resize_Y_(*this)
      
      ;       ; Is visible lines
      ;       \Items()\hide = Bool(Not Bool(\Items()\y>=\y[#_c_2] And (\Items()\y-\y[#_c_2])+\Items()\height=<\height[#_c_2]))
      
      ; Scroll width length
      _set_scroll_width_(*this)
      
      ; Scroll hight length
      _set_scroll_height_(*this)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\text[1]\string.s = Left(\Items()\text\string.s, \text\caret) : \Items()\text[1]\change = #True
        \Items()\text[3]\string.s = Right(\Items()\text\string.s, \Items()\text\len-(\text\caret + \Items()\text[2]\len)) : \Items()\text[3]\change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i Editor_MultiLine(*this._S_widget)
    Protected Repaint, String.s, text_width, Len.i
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      Width = \width[#_c_2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) - \margin\width
      Height = \height[#_c_2] - Bool(Not \scroll\h\hide) * \scroll\h\height
      
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
        If ListSize(\Items()) 
          Protected Left = Editor_Move(*this, Width)
        EndIf
        
        If \countItems[1] <> \countItems Or \text\Vertical
          \countItems[1] = \countItems
          
          ; Scroll hight reset 
          \scroll\height = 0
          ClearList(\Items())
          
          If \text\Vertical
            For IT = \countItems To 1 Step - 1
              If AddElement(\Items())
                \Items() = AllocateStructure(_S_items)
                String = StringField(\text\string.s[2], IT, #LF$)
                
                ;\Items()\focus =- 1
                \Items()\Index[1] =- 1
                
                If \type = #PB_GadgetType_Button
                  \Items()\text\width = TextWidth(RTrim(String))
                Else
                  \Items()\text\width = TextWidth(String)
                EndIf
                
                If \text\align\right
                  Text_X=(Width-\Items()\text\width) 
                ElseIf \text\align\horizontal
                  Text_X=(Width-\Items()\text\width-Bool(\Items()\text\width % 2))/2 
                EndIf
                
                \Items()\x = \x[#_c_2]+\text\y+\scroll\height+Text_Y
                \Items()\y = \y[#_c_2]+\text\x+Text_X
                \Items()\width = \text\height
                \Items()\height = Width
                \Items()\Index = ListIndex(\Items())
                
                \Items()\text\Editable = \text\Editable 
                \Items()\text\Vertical = \text\Vertical
                If \text\rotate = 270
                  \Items()\text\x = \Image\width+\Items()\x+\text\height+\text\x
                  \Items()\text\y = \Items()\y
                Else
                  \Items()\text\x = \Image\width+\Items()\x
                  \Items()\text\y = \Items()\y+\Items()\text\width
                EndIf
                \Items()\text\height = \text\height
                \Items()\text\string.s = String.s
                \Items()\text\len = Len(String.s)
                
                _set_scroll_height_(*this)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \text\string.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\Items())
                    \Items() = AllocateStructure(_S_items)
                    
                    \Items()\text\string.s = Trim(RegularExpressionMatchString(0), #LF$)
                    \Items()\text\width = TextWidth(\Items()\text\string.s) ; Нужен для скролл бара
                    
                    ;\Items()\focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\state = 1 ; Set line default colors
                    \Items()\radius = \radius
                    \Items()\Index = ListIndex(\Items())
                    
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
            ;               If *End\c = #LF And AddElement(\Items())
            ;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
            ;                 
            ;                 \Items()\text\string.s = PeekS (*Sta, Len) ;Trim(, #LF$)
            ;                 
            ; ;                 If \type = #PB_GadgetType_Button
            ; ;                   \Items()\text\width = TextWidth(RTrim(\Items()\text\string.s))
            ; ;                 Else
            ; ;                   \Items()\text\width = TextWidth(\Items()\text\string.s)
            ; ;                 EndIf
            ;                 
            ;                 \Items()\focus =- 1
            ;                 \Items()\Index[1] =- 1
            ;                 \Items()\color\state = 1 ; Set line default colors
            ;                 \Items()\radius = \radius
            ;                 \Items()\Index = ListIndex(\Items())
            ;                 
            ;                 ; Update line pos in the text
            ;                 ; _set_line_pos_(*this)
            ;                 \Items()\text\pos = \text\pos - Bool(\text\multiLine = 1)*\Items()\index ; wordwrap
            ;                 \Items()\text\len = Len                                                  ; (\Items()\text\string.s)
            ;                 \text\pos + \Items()\text\len + 1                                        ; Len(#LF$)
            ;                 
            ;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\text\pos +" "+ \Items()\text\len
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
                
                If SelectElement(\Items(), IT-1)
                  If \Items()\text\string.s <> String.s
                    \Items()\text\string.s = String.s
                    
                    If \type = #PB_GadgetType_Button
                      \Items()\text\width = TextWidth(RTrim(String.s))
                    Else
                      \Items()\text\width = TextWidth(String.s)
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
        
        ForEach \Items()
          If Not \Items()\hide
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
          
          \text\height[1] = TextHeight("A") + Bool(\countItems<>1 And \flag\GridLines)
          If \type = #PB_GadgetType_Tree
            \text\height = 20
          Else
            \text\height = \text\height[1]
          EndIf
          \text\width = TextWidth(\text\string.s[1])
          
          If \margin\width 
            \countItems = CountString(\text\string.s[1], #LF$)
            \margin\width = TextWidth(Str(\countItems))+11
            ;  Resizes(\scroll, \x[#_c_2]+\margin\width+1,\y[#_c_2],\width[#_c_2]-\margin\width-1,\height[#_c_2])
          EndIf
        EndIf
        
        ; Then resized widget
        If \resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \root\canvas\window, *this, #PB_EventType_Resize, \resize)
          
          CompilerIf Defined(Bar, #PB_Module)
            ;  Resizes(\scroll, \x[#_c_2]+\margin\width,\y[#_c_2],\width[#_c_2]-\margin\width,\height[#_c_2])
            Resizes(\scroll, \x[#_c_2],\y[#_c_2],\width[#_c_2],\height[#_c_2])
            \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
            \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
          CompilerElse
            \scroll\width[2] = \width[#_c_2]
            \scroll\height[2] = \height[#_c_2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\x[#_c_2]
        iY=\y[#_c_2]
        iWidth = \width[#_c_2] - (Bool(Not \scroll\v\hide) * \scroll\v\width) ; - \margin\width
        iHeight = \height[#_c_2] - Bool(Not \scroll\h\hide) * \scroll\h\height
        
        ; Make output multi line text
        If (\text\change Or \resize)
          Editor_MultiLine(*this)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \text\change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \scroll\v And \scroll\v\max <> \scroll\height And 
                 SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\GridLines)) 
                
                \scroll\v\scrollstep = \text\height
                
                If \text\editable And (\Items()\y >= (\scroll\height[2]-\Items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  SetState(\scroll\v, (\Items()\y-((\scroll\height[2]+\text\y)-\Items()\height)))
                EndIf
                
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                
                If \scroll\v\hide 
                  \scroll\width[2] = \width[#_c_2]
                  \Items()\width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\scroll\v\hide +" "+ \scroll\height
                EndIf
              EndIf
              
              If \scroll\h And \scroll\h\max<>\scroll\width And 
                 SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
                Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\scroll\h\page\len ; x(*this\scroll\v)-*this\scroll\h\x ; 
                \scroll\height[2] = *this\scroll\v\page\len; y(*this\scroll\h)-*this\scroll\v\y ;
                                                           ;  \scroll\width[2] = \width[#_c_2] - Bool(Not \scroll\v\hide)*\scroll\v\width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \Keyboard\Input And \Items()\text\x+\Items()\text\width > \Items()\x+\Items()\width
                Debug ""+\scroll\h\max +" "+ Str(\Items()\text\x+\Items()\text\width)
                
                If \scroll\h\max = (\Items()\text\x+\Items()\text\width)
                  SetState(\scroll\h, \scroll\h\max)
                Else
                  SetState(\scroll\h, \scroll\h\page\pos + TextWidth(Chr(\Keyboard\Input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        
        ;
        If \text\Editable And ListSize(\Items())
          If \text\change =- 1
            \text[1]\change = 1
            \text[3]\change = 1
            \text\len = Len(\text\string.s[1])
            Editor_Change(*this, \text\caret, 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \root\canvas\window, *this, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \Items()\text[1]\change : \Items()\text[1]\change = #False
            \Items()\text[1]\width = TextWidth(\Items()\text[1]\string.s)
            
            ; demo
            ;             Protected caret1, caret = \text\caret[2]
            
            ; Положение карета
            If \text\caret[1] = \text\caret
              \text\caret[2] = \Items()\text[1]\width
              ;               caret1 = \text\caret[2]
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \text\caret[2] = 0
            ElseIf \index[1] = ListSize(\Items())
              \text\caret[2] = \Items()\text\width
            ElseIf \Items()\text\len = \Items()\text[2]\len
              \text\caret[2] = \Items()\text\width
            EndIf
            
            ;             If Caret<>\text\caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \text\caret[2] +" "+\index[1] +" "+\index[2]
            ;               caret = \text\caret[2]
            ;             EndIf
            
          EndIf
          
          If \Items()\text[2]\change : \Items()\text[2]\change = #False 
            \Items()\text[2]\x = \Items()\text\x+\Items()\text[1]\width
            \Items()\text[2]\width = TextWidth(\Items()\text[2]\string.s) ; + Bool(\Items()\text[2]\len =- 1) * \flag\fullSelection ; TextWidth() - bug in mac os
            
            \Items()\text[3]\x = \Items()\text[2]\x+\Items()\text[2]\width
          EndIf 
          
          If \Items()\text[3]\change : \Items()\text[3]\change = #False 
            \Items()\text[3]\width = TextWidth(\Items()\text[3]\string.s)
          EndIf 
          
          If (\focus And \mouse\buttons And (Not \scroll\v\from And Not \scroll\h\from)) 
            Protected Left = Editor_Move(*this, \Items()\width)
          EndIf
        EndIf
        
        ; Draw back color
        If \color\fore[_S_widgettate]
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\Vertical,\x[#_c_1],\y[#_c_1],\width[#_c_1],\height[#_c_1],\color\fore[_S_widgettate],\color\back[_S_widgettate],\radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[#_c_1],\y[#_c_1],\width[#_c_1],\height[#_c_1],\radius,\radius,\color\back[_S_widgettate])
        EndIf
        
        ; Draw margin back color
        If \margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \margin\width, \height[#_c_2], \margin\color\back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *this\Items()
        If ListSize(*this\Items())
          PushListPosition(*this\Items())
          ForEach *this\Items()
            Protected Item_state = \state
            
            ; Is visible lines ---
            Drawing = Bool(Not \hide And (\y+\height+*this\scroll\y>*this\y[#_c_2] And (\y-*this\y[#_c_2])+*this\scroll\y<iheight))
            
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
            If Drawing And (\Index=*this\Index[1] Or \Index=\Index[1]) ; Or \Index=\focus Item_state;
              If *this\color\back[Item_state]<>-1                      ; no draw transparent
                If *this\color\fore[Item_state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  _box_gradient_(\Vertical,*this\x[#_c_2],Y,iwidth,\height,*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24, *this\color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24) ;*this\color\fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24 ,RowBackColor(*this, Item_state) ,\radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*this\x[#_c_2],Y,iwidth,\height,\radius,\radius,*this\color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
                EndIf
              EndIf
              
              If *this\color\frame[Item_state]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\x[#_c_2],Y,iwidth,\height,\radius,\radius, *this\color\frame[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
              EndIf
            EndIf
            
            If Drawing
              
              ;               Protected State_3, item_alpha = 255, back_color=$FFFFFF
              ;               
              ;               If Bool(\index = *this\index[2])
              ;                 State_3 = 2
              ;               Else
              ;                 State_3 = Bool(\index = *this\index[1])
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
                  If (*this\text\caret[1] > *this\text\caret And *this\Index[2] = *this\Index[1]) Or
                     (\Index = *this\Index[1] And *this\Index[2] > *this\Index[1])
                    \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
                    
                    If *this\Index[2] = *this\Index[1]
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
                DrawText(ix+*this\margin\width-TextWidth(Str(\Index))-3, \y+*this\scroll\y, Str(\Index), *this\margin\color\front);, *this\margin\color\back)
              EndIf
            EndIf
            
            ;             ; text x
            ;             box(\text\x, *this\y, 2, *this\height, $FFFF0000)
            ;         
          Next
          PopListPosition(*this\Items()) ; 
        EndIf
      EndWith  
      
      
      With *this
        ; Draw image
        If \Image\ImageID
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\ImageID, \Image\x, \Image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\Items()) And (\text\Editable Or \Items()\text\Editable) And \focus : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\text\x+\scroll\x) + \text\caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \scroll\x), \Items()\y+\scroll\y, 1, Height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \scroll\v And \scroll\v\max <> \scroll\height And 
          ;              SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\GridLines))
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
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        ;If (\Items()\y+\scroll\y =< \y[#_c_2])
        SetState(\scroll\v, (\Items()\y-((\scroll\height[2]+\text\y)-\Items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \Items()\text\x+\Items()\text\width > \Items()\x+\Items()\width
          SetState(\scroll\h, (\Items()\text\x+\Items()\text\width))
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
    Protected Repaint, Shift.i = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If Shift
        
        If \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[1]) 
          Editor_Change(*this, \text\caret[1], \Items()\text\len-\text\caret[1])
        Else
          SelectElement(\Items(), \Index[2]) 
          Editor_Change(*this, 0, \Items()\text\len)
        EndIf
        ; Debug \text\caret[1]
        \Index[2] + 1
        ;         \text\caret = Editor_Caret(*this, \Index[2]) 
        ;         \text\caret[1] = \text\caret
        SelectElement(\Items(), \Index[2]) 
        Editor_Change(*this, 0, \text\caret[1]) 
        Editor_SelText(*this)
        Repaint = 1 
        
      Else
        If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[2]) 
          ;If (\Items()\y >= (\scroll\height[2]-\Items()\height))
          SetState(\scroll\v, (\Items()\y-((\scroll\height[2]+\text\y)-\Items()\height)))
          ;EndIf
          
          If \Items()\text\x+\Items()\text\width > \Items()\x+\Items()\width
            SetState(\scroll\h, (\Items()\text\x+\Items()\text\width))
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
    Protected Repaint.i, Shift.i = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Shift)
    
    With *this
      If \Items()\text[2]\len And Not Shift
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\text[1]\string.s = Left(\Items()\text\string.s, \text\caret[1]) 
            \Items()\text[1]\change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \text\caret[1] > \text\caret
          Swap \text\caret[1], \text\caret
        ElseIf \text\caret > \text\caret[1] 
          Swap \text\caret, \text\caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*this)
          \Index[1] = \Index[2]
        Else
          \text\caret[1] = \text\caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \text\caret > 0
        If \text\caret > \Items()\text\len - CountString(\Items()\text\string.s, #CR$) ; Без нее удаляеть последнюю строку 
          \text\caret = \Items()\text\len - CountString(\Items()\text\string.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \text\caret - 1 
        
        If Not Shift
          \text\caret[1] = \text\caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf Editor_ToUp(*this._S_widget)
        \text\caret = \Items()\text\len
        \text\caret[1] = \text\caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToRight(*this._S_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Shift)
    
    With *this
      ;       If \Index[1] <> \Index[2]
      ;         If Shift 
      ;           \text\caret + 1
      ;           Swap \Index[2], \Index[1] 
      ;         Else
      ;           If \Index[1] > \Index[2] 
      ;             Swap \Index[1], \Index[2] 
      ;             Swap \text\caret, \text\caret[1]
      ;             
      ;             If SelectElement(\Items(), \Index[2]) 
      ;               \Items()\text[1]\string.s = Left(\Items()\text\string.s, \text\caret[1]) 
      ;               \Items()\text[1]\change = #True
      ;             EndIf
      ;             
      ;             Editor_SelReset(*this)
      ;             \text\caret = \text\caret[1] 
      ;             \Index[1] = \Index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \Items()\text[2]\len
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
      If \Items()\text[2]\len And Not Shift
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \text\caret, \text\caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\text[1]\string.s = Left(\Items()\text\string.s, \text\caret[1]) 
            \Items()\text[1]\change = #True
          EndIf
          
          ;           Editor_SelReset(*this)
          ;           \text\caret = \text\caret[1] 
          ;           \Index[1] = \Index[2]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*this)
          \Index[1] = \Index[2]
        Else
          \text\caret = \text\caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \text\caret < \Items()\text\len - CountString(\Items()\text\string.s, #CR$) ; Без нее удаляеть последнюю строку
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
      If \Keyboard\Input
        Repaint = Editor_Insert(*this, Chr(\Keyboard\Input))
        
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
        \Index[2] + 1
        \text\caret = 0
        \Index[1] = \Index[2]
        \text\caret[1] = \text\caret
        \text\change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i Editor_ToBack(*this._S_widget)
    Protected Repaint, String.s, Cut.i
    
    If *this\Keyboard\Input : *this\Keyboard\Input = 0
      Editor_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    *this\Keyboard\Input = 65535
    
    With *this 
      If Not Editor_Cut(*this)
        If \Items()\text[2]\len
          
          If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
          \Items()\text[2]\len = 0 : \Items()\text[2]\string.s = "" : \Items()\text[2]\change = 1
          
          \Items()\text\string.s = \Items()\text[1]\string.s + \Items()\text[3]\string.s
          \Items()\text\len = \Items()\text[1]\len + \Items()\text[3]\len : \Items()\text\change = 1
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret[1] > 0 : \text\caret - 1 
          \Items()\text[1]\string.s = Left(\Items()\text\string.s, \text\caret)
          \Items()\text[1]\len = Len(\Items()\text[1]\string.s) : \Items()\text[1]\change = 1
          
          \Items()\text\string.s = \Items()\text[1]\string.s + \Items()\text[3]\string.s
          \Items()\text\len = \Items()\text[1]\len + \Items()\text[3]\len : \Items()\text\change = 1
          
          \text\string.s[1] = Left(\text\string.s[1], \Items()\text\pos+\text\caret) + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$, #PB_String_CaseSensitive, \Items()\text\pos+\text\caret, 1)
            
            Editor_ToUp(*this)
            
            \text\caret = \Items()\text\len - CountString(\Items()\text\string.s, #CR$)
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
        If \Items()\text[2]\len
          If \text\caret > \text\caret[1] : \text\caret = \text\caret[1] : EndIf
          \Items()\text[2]\len = 0 : \Items()\text[2]\string.s = "" : \Items()\text[2]\change = 1
          
          \Items()\text\string.s = \Items()\text[1]\string.s + \Items()\text[3]\string.s
          \Items()\text\len = \Items()\text[1]\len + \Items()\text[3]\len : \Items()\text\change = 1
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret[1] < \Items()\text\len - CountString(\Items()\text\string.s, #CR$)
          \Items()\text[3]\string.s = Right(\Items()\text\string.s, \Items()\text\len - \text\caret - 1)
          \Items()\text[3]\len = Len(\Items()\text[3]\string.s) : \Items()\text[3]\change = 1
          
          \Items()\text\string.s = \Items()\text[1]\string.s + \Items()\text[3]\string.s
          \Items()\text\len = \Items()\text[1]\len + \Items()\text[3]\len : \Items()\text\change = 1
          
          \text[3]\string = Right(\text\string.s,  \text\len - (\Items()\text\pos + \text\caret) - 1)
          \text[3]\len = Len(\text[3]\string.s)
          
          \text\string.s[1] = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\countItems-1) ; ListSize(\Items()) - 1
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$, #PB_String_CaseSensitive, \Items()\text\pos+\text\caret, 1)
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
        
        \index[1] = \items()\index
        SetState(\scroll\v, (\Items()\y-((\scroll\height[2]+\text\y)-\Items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \text\caret = Bool(Pos =- 1) * \items()\text\len 
        SetState(\scroll\h, Bool(Pos =- 1) * \scroll\h\max)
      EndIf
      
      \text\caret[1] = \text\caret
      \index[2] = \index[1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Editable(*this._S_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *this
      Shift = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\Keyboard\Key[1] & #PB_Canvas_Control) Or (\Keyboard\Key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
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
          Select \Keyboard\Key
            Case #PB_Shortcut_Home : Repaint = Editor_ToPos(*this, 1, Control)
            Case #PB_Shortcut_End : Repaint = Editor_ToPos(*this, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = Editor_ToPos(*this, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = Editor_ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\text[2]\len <> \text\len Or Not \text[2]\len)
                ForEach \items()
                  \Items()\text[2]\len = \Items()\text\len - Bool(Not \Items()\text\len) ; Выделение пустой строки
                  \Items()\text[2]\string = \Items()\text\string : \Items()\text[2]\change = 1
                  \Items()\text[1]\string = "" : \Items()\text[1]\change = 1 : \Items()\text[1]\len = 0
                  \Items()\text[3]\string = "" : \Items()\text[3]\change = 1 : \Items()\text[3]\len = 0
                Next
                
                \text[1]\len = 0 : \text[1]\string = ""
                \text[3]\len = 0 : \text[3]\string = #LF$
                \index[2] = 0 : \index[1] = ListSize(\Items()) - 1
                \text\caret = \Items()\text\len : \text\caret[1] = \text\caret
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
                
                If \Keyboard\Key = #PB_Shortcut_X
                  Repaint = Editor_Cut(*this)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \text\Editable And Control
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
      
      If \Index[1] <> Line And Line =< ListSize(\Items())
        If isItem(\Index[1], \Items()) 
          If \Index[1] <> ListIndex(\Items())
            SelectElement(\Items(), \Index[1]) 
          EndIf
          
          If \Index[1] > Line
            \text\caret = 0
          Else
            \text\caret = \Items()\text\len
          EndIf
          
          Repaint | Editor_SelText(*this)
        EndIf
        
        \Index[1] = Line
      EndIf
      
      If isItem(Line, \Items()) 
        \text\caret = Editor_Caret(*this, Line) 
        Repaint | Editor_SelText(*this)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\Items()) 
      ForEach \Items()
        If (\Index[1] = \Items()\Index Or \Index[2] = \Items()\Index)
          \Items()\text[2]\change = 1
          \Items()\text[2]\len - Bool(Not \Items()\text\len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
          
          \Items()\text[2]\change = 1
          \Items()\text[2]\string = \Items()\text\string 
          \Items()\text[2]\len - Bool(Not \Items()\text\len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \Items()\text[2]\len
          \Items()\text[2]\change = 1
          \Items()\text[2]\string =  "" 
          \Items()\text[2]\len = 0 
        EndIf
      Next
      PopListPosition(\Items()) 
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Events(*this._S_widget, EventType.i)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *this
      If *this 
        If ListSize(*this\items())
          If Not \hide ;And Not \disable And \Interact
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
                \Items()\text\caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Editor_SelLimits(*this)     ; Выделяем слово
                Editor_SelText(*this)
                
                ;                 \Items()\text[2]\change = 1
                ;                 \Items()\text[2]\len - Bool(Not \Items()\text\len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                itemSelect(Item, \Items())
                Caret = Editor_Caret(*this, Item)
                
                If \Items()\text\caret[1] =- 1 : \Items()\text\caret[1] = 0
                  *this\text\caret[1] = 0
                  *this\text\caret = \Items()\text\len
                  Editor_SelText(*this)
                  Repaint = 1
                  
                Else
                  Editor_SelReset(*this)
                  
                  If \Items()\text[2]\len
                    
                    
                    
                  Else
                    
                    \text\caret = Caret
                    \text\caret[1] = \text\caret
                    \Index[1] = \Items()\Index 
                    \Index[2] = \Index[1]
                    
                    PushListPosition(\Items())
                    ForEach \Items() 
                      If \Index[2] <> ListIndex(\Items())
                        \Items()\text[1]\string = ""
                        \Items()\text[2]\string = ""
                        \Items()\text[3]\string = ""
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    If \text\caret = DoubleClick
                      DoubleClick =- 1
                      \text\caret[1] = \Items()\text\len
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
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If \focus And (*this\text\Editable Or \text\Editable)
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
            \Keyboard\Input = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Input)
            \Keyboard\Key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \Keyboard\Key = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Key)
            \Keyboard\Key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
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
  
  ;-
  Procedure.b Draw_Scroll(*this._S_widget)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x,\y,\width,\height,\radius,\radius,\color\back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\color[3]\fore[\color[3]\state],\color[3]\back[\color[3]\state], \radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\radius,\radius,\color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2-3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2+3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2-3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2+3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\color[#_b_1]\fore[\color[#_b_1]\state],\color[#_b_1]\back[\color[#_b_1]\state], \radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\color[#_b_2]\fore[\color[#_b_2]\state],\color[#_b_2]\back[\color[#_b_2]\state], \radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\radius,\radius,\color[#_b_1]\frame[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\radius,\radius,\color[#_b_2]\frame[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_1]\x+(\button[#_b_1]\width-\button[#_b_1]\arrow_size)/2,\button[#_b_1]\y+(\button[#_b_1]\height-\button[#_b_1]\arrow_size)/2, \button[#_b_1]\arrow_size, Bool(\Vertical), \color[#_b_1]\front[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_1]\arrow_type)
          Arrow(\button[#_b_2]\x+(\button[#_b_2]\width-\button[#_b_2]\arrow_size)/2,\button[#_b_2]\y+(\button[#_b_2]\height-\button[#_b_2]\arrow_size)/2, \button[#_b_2]\arrow_size, Bool(\Vertical)+2, \color[#_b_2]\front[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Track(*this._S_widget)
    With *This
      
      If Not \Hide
        Protected _pos_ = 6, _size_ = 4
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X,\Y,\Width,\Height,\Color\Back)
        
        If \Vertical
          ; _frame_(*this, _pos_, _size_)
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
        Else
          ; _frame_(*this, _pos_, _size_)
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        
        If \thumb\len
          Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(\button[3]\x+\button[3]\width-4,track_pos,4, 1,\Color[3]\Frame)
              Next
            Else
              Line(\button[3]\x+\button[3]\width-4,\area\pos + _thumb_,4, 1,\Color[3]\Frame)
              Line(\button[3]\x+\button[3]\width-4,\area\pos + \area\len + _thumb_,4, 1,\Color[3]\Frame)
            EndIf
          Else
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Next
            Else
              Line(\area\pos + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Line(\area\pos + \area\len + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Color[3]\fore[#_b_2],\Color[3]\Back[#_b_2], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Radius,\Radius,\Color[3]\frame[#_b_2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_3]\x+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(\Vertical),\button[#_b_3]\y+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(Not \Vertical), 
                \button[#_b_3]\arrow_size, Bool(\Vertical)+Bool(Not \inverted And \direction>0)*2+Bool(\inverted And \direction=<0)*2, \Color[#_b_3]\frame[\color[#_b_3]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_3]\arrow_type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.i Draw_Progress(*this._S_widget)
    With *this 
      
      If \Vertical
        ; Normal Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\width,\thumb\pos-\y,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state])
        
        ; Selected Back 
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical,\x, \thumb\pos+\thumb\len,\width,\height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\pos
          Line(\X,\Y,1,\thumb\pos-\y,\Color[#_b_1]\frame[\color[#_b_1]\state])
          Line(\X,\Y,\width,1,\Color[#_b_1]\frame[\color[#_b_1]\state])
          Line(\X+\width-1,\Y,1,\thumb\pos-\y,\Color[#_b_1]\frame[\color[#_b_1]\state])
        Else
          Line(\X,\Y,\width,1,\Color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\end
          Line(\x,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\frame[\color[#_b_2]\state])
          Line(\x,\Y+\height-1,\width,1,\Color[#_b_2]\frame[\color[#_b_2]\state])
          Line(\x+\width-1,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\frame[\color[#_b_2]\state])
        Else
          Line(\x,\Y+\height-1,\width,1,\Color[#_b_1]\frame[\color[#_b_1]\state])
        EndIf
        
      Else
        ; Selected Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\thumb\pos-\x,\height,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state])
        
        ; Normal Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),\height,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\pos
          Line(\X,\Y,\thumb\pos-\x,1,\Color[#_b_1]\frame[\color[#_b_1]\state])
          Line(\X,\Y,1,\height,\Color[#_b_1]\frame[\color[#_b_1]\state])
          Line(\X,\Y+\height-1,\thumb\pos-\x,1,\Color[#_b_1]\frame[\color[#_b_1]\state])
        Else
          Line(\X,\Y,1,\height,\Color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\end
          Line(\thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_b_2]\frame[\color[#_b_2]\state])
          Line(\x+\width-1,\Y,1,\height,\Color[#_b_2]\frame[\color[#_b_2]\state])
          Line(\thumb\pos+\thumb\len,\Y+\height-1,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_b_2]\frame[\color[#_b_2]\state])
        Else
          Line(\x+\width-1,\Y,1,\height,\Color[#_b_1]\frame[\color[#_b_1]\state])
        EndIf
      EndIf
      
      ; Text
      ;If \mode
        If \vertical
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawRotatedText(\x+(\width-TextHeight("A"))/2, \y+(\height+TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 90, \Color[3]\frame)
          ; DrawRotatedText(\x+(\width+TextHeight("A")+Bool(#PB_Compiler_OS = #PB_OS_MacOS)*2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, \Color[3]\frame)
        Else
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),\Color[3]\frame)
        EndIf
      ;EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Splitter(*this._S_widget)
     Protected Pos, Size, X,Y,Width,Height, Color, Radius.d = 2
    
    With *this
      If *this > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        If \mode
          DrawingMode(#PB_2DDrawing_Outlined)
          Protected *first._S_widget = \splitter\first
          Protected *second._S_widget = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Color[3]\frame[\color[#_b_1]\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Color[3]\frame[\color[#_b_2]\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \Thumb\len/2
          Pos = \Thumb\Pos+Size
          
          Color = \Color[3]\Frame[#_b_2]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Pos,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),      Pos,Radius,Color)
            Circle(X+((Width-Radius)/2),                   Pos,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),      Pos,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Pos,Radius,Color)
          Else
            Circle(Pos,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2-(Radius*2+2)),      Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2),                   Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2+(Radius*2+2)),      Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Draw_String(*this._S_widget)
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw frame
      If \color\back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, \color\back&$FFFFFF|Alpha)
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
          If (*this\text\caret[1] > *this\text\caret And *this\index[2] = *this\index[1]) Or
             (\index = *this\index[1] And *this\index[2] > *this\index[1])
            \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret[1])) 
            
            If *this\index[2] = *this\index[1]
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
      If \text\Editable And \focus : DrawingMode(#PB_2DDrawing_XOr)   
        Line(\text\x + \text[1]\width + Bool(\text\caret[1] > \text\caret) * \text[2]\width - Bool(#PB_Compiler_OS = #PB_OS_Windows), \text\y, 1, \text\height, $FFFFFFFF)
      EndIf
      
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
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
        _box_gradient_( \Vertical, \box\x, \box\y, \box\width, \box\height, \box\color\fore[\focus*2], \box\color\back[\focus*2], \radius, \box\color\alpha)
      EndIf
      
      ; Draw image
      If \image\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\ImageID, \image\x, \image\y, \color\alpha)
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
        RoundBox(\x[#_c_1], \y+\bs-\fs, \width[#_c_1], \tabHeight+\fs, \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \color\back[State_3]<>-1
        If \color\fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \Vertical, \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \color\fore, \color\back, \radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \color\frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color\frame[State_3]&$FFFFFF|Alpha)
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
        RoundBox( \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string, \color\front[State_3]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*this._S_widget)
      
      If \box\size[2]
        Protected Radius = \height[#_c_2]/7
        If Radius > 4
          Radius = 7
        EndIf
        
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \Vertical, \box\x[1], \box\y[1], \box\width[1], \box\height[1], \color[1]\fore[State_1], \color[1]\back[State_1], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \Vertical, \box\x[2], \box\y[2], \box\width[2], \box\height[2], \color[2]\fore[State_2], \color[2]\back[State_2], Radius, \color\alpha)
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
        
        
        Line(\box\x[1]-2, \y[#_c_2],1,\height[#_c_2], \color\frame&$FFFFFF|Alpha)
      EndIf      
    EndWith
  EndProcedure
  
  Procedure.i Draw_ScrollArea(*this._S_widget)
    With *this 
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, \color\back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
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
        RoundBox(\x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, \color\back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|\color\alpha<<24)
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
      ;       If \image[1]\ImageID
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      ;       EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \tabHeight/2
        Box(\x[#_c_1], \y+h, 6, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\text\x+\text\width+3, \y+h, \width[#_c_1]-((\text\x+\text\width)-\x)-3, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[#_c_1], \y[#_c_1]-h, \fs, \height[#_c_1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[#_c_1]+\width[#_c_1]-\fs, \y[#_c_1]-h, \fs, \height[#_c_1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[#_c_1], \y[#_c_1]+\height[#_c_1]-\fs, \width[#_c_1], \fs, \color\frame&$FFFFFF|\color\alpha<<24)
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
        RoundBox(\x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      If \width[#_c_2]>(\box\width[1]+\box\width[2]+4)
        ClipOutput(clip_x, \y[#_c_4], clip_width, \height[#_c_4])
        
        ForEach \items()
          If \index[2] = \items()\index
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
              _box_gradient_( \Vertical, \items()\x, \items()\y, \items()\width, \items()\height, \color\fore[State_3], Bool(State_3 <> 2)*\color\back[State_3] + (Bool(State_3 = 2)*\color\front[State_3]), \radius, \color\alpha)
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
            start = Bool(\items()\x=<\x[#_c_2]+\box\size[1]+1 And \items()\x+\items()\width>=\x[#_c_2]+\box\size[1]+1)*2
            stop = Bool(\items()\x=<\x[#_c_2]+\width[#_c_2]-\box\size[2]-2 And \items()\x+\items()\width>=\x[#_c_2]+\width[#_c_2]-\box\size[2]-2)*2
          EndIf
          
        Next
        
        ClipOutput(\x[#_c_4], \y[#_c_4], \width[#_c_4], \height[#_c_4])
        
        If ListSize(\items())
          Protected Value = \box\size[1]+((\items()\x+\items()\width+\page\pos)-\x[#_c_2])
          
          If \max <> Value : \max = Value
            \area\pos = \x[#_c_2]+\box\size[1]
            \area\len = \width[#_c_2]-(\box\size[1]+\box\size[2])
            \thumb\len = _thumb_len_(*this)
            ;\scrollstep = 10;\thumb\len
            
            If \change > 0 And SelectElement(\Items(), \change-1)
              Protected State = (\box\size[1]+((\items()\x+\items()\width+\page\pos)-\x[#_c_2]))-\page\len ;
                                                                                                       ;               Debug (\box\size[1]+(\items()\x+\items()\width)-\x[#_c_2])-\page\len
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
        Line(\x[#_c_2], \y+\tabHeight, \area\pos-\x+2, 1, \color\frame&$FFFFFF|Alpha)
        
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
              If Bool(\items()\index = \index[2])
                State_3 = 2
              Else
                State_3 = Bool(\items()\index = \index[1])
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
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Checkbox(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      \box\x = \x[#_c_2]+3
      \box\y = \y[#_c_2]+(\height[#_c_2]-\box\height)/2
      
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
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Option(*this._S_widget)
    Protected i.i, y.i
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1, box_color=$7E7E7E
    
    With *this
      Protected Alpha = \color\alpha<<24
      Protected Radius = \box\width/2
      \box\x = \x[#_c_2]+3
      \box\y = \y[#_c_2]+(\height[#_c_2]-\box\width)/2
      
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
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Image(*this._S_widget)
    With *this 
      
      ClipOutput(\x[#_c_2],\y[#_c_2],\scroll\h\page\len,\scroll\v\page\len)
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
      
      ; 2 - frame
      If \color\back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, \color\back)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame)
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
        _box_gradient_( \Vertical, \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \color\fore[State], \color\back[State], \radius, \color\alpha)
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
        RoundBox(\x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
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
        _box_gradient_( \Vertical, \x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \color\fore[State], \color\back[State], \radius, \color\alpha)
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
      \box\height = \height[#_c_2]
      \box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\box\x+(\box\width-\box\arrow_size)/2, \box\y+(\box\height-\box\arrow_size)/2, \box\arrow_size, Bool(\box\checked)+2, \color\front[State]&$FFFFFF|Alpha, \box\arrow_type)
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
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
        RoundBox( \x[#_c_1], \y[#_c_1], \width[#_c_1], \height[#_c_1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_ListIcon(*this._S_widget)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*this\flag\GridLines, FirstColumn.i
    
    With *this 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[#_c_2]-\scroll\h\page\pos
      Protected start, stop, n
      
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#_c_2], \y[#_c_2], \width[#_c_2], \height[#_c_2], \radius, \radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[#_c_2]>1;(\box\width[1]+\box\width[2]+4)
      ForEach \columns()
        FirstColumn = Bool(Not ListIndex(\columns()))
        n = Bool(\flag\checkboxes)*16 + Bool(\Image\width)*28
        
        
        y = \y[#_c_2]-\scroll\v\page\pos
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
        
        \columns()\drawing = Bool(Not \columns()\hide And \columns()\x+\columns()\width>\x[#_c_2] And \columns()\x<\x[#_c_2]+\width[#_c_2])
        
        
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
                
                \columns()\items()\box\x[1] = \x[#_c_2] + 4 - \scroll\h\page\pos
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
            \columns()\items()\drawing = Bool(\columns()\items()\y+\columns()\items()\height>\y[#_c_2] And \columns()\items()\y<\y[#_c_2]+\height[#_c_2])
            
            y + \columns()\items()\height + \flag\GridLines + GridLines * 2
          EndIf
          
          If \index[2] = \columns()\items()\index
            State_3 = 2
          Else
            State_3 = \columns()\items()\state
          EndIf
          
          If \columns()\items()\drawing
            ; Draw selections
            If \flag\fullSelection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[#_c_2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height, \color\back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[#_c_2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, \color\frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \focus
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#_c_2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#_c_2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\alwaysSelection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#_c_2],\columns()\items()\y+1,\scroll\h\page\len,\columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#_c_2],\columns()\items()\y,\scroll\h\page\len,\columns()\items()\height, $C8C8C8&back_color|Alpha)
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
              If \flag\GridLines
                DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Line(\columns()\items()\x-n, \columns()\items()\y+\columns()\items()\height + GridLines, \columns()\width+n+1 + (\width[#_c_2]-(\columns()\x-\x[#_c_2]+\columns()\width)), 1, \color\frame&$FFFFFF|\color\alpha<<24)                   ; top
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
              _box_gradient_( \Vertical, \x[#_c_2], \columns()\y, n, \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            ElseIf ListIndex(\columns()) = ListSize(\columns()) - 1
              _box_gradient_( \Vertical, \columns()\x+\columns()\width, \columns()\y, 1 + (\width[#_c_2]-(\columns()\x-\x[#_c_2]+\columns()\width)), \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \radius, \color\alpha)
            EndIf
            
            _box_gradient_( \Vertical, \columns()\x, \columns()\y, \columns()\width, \columns()\height, \color\fore[\columns()\state], Bool(\columns()\state <> 2) * \color\back[\columns()\state] + (Bool(\columns()\state = 2) * \color\front[\columns()\state]), \radius, \color\alpha)
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
            Line(\columns()\x-1, \columns()\y, 1, \columns()\height + Bool(\flag\GridLines) * \height[#_c_1], \color\frame&$FFFFFF|\color\alpha<<24)                     ; left
          EndIf
          Line(\columns()\x+\columns()\width, \columns()\y, 1, \columns()\height + Bool(\flag\GridLines) * \height[#_c_1], \color\frame&$FFFFFF|\color\alpha<<24)      ; right
          Line(\x[#_c_2], \columns()\y+\columns()\height-1, \width[#_c_2], 1, \color\frame&$FFFFFF|\color\alpha<<24)                                                       ; bottom
          
          If \columns()\state = 2
            DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\columns()\x, \columns()\y+1, \columns()\width, \columns()\height-2, \radius, \radius, \color\frame[\columns()\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        \columns()\text\change = 0
      Next
      
      \scroll\height = (y+\scroll\v\page\pos)-\y[#_c_2]-1;\flag\GridLines
                                                     ; set vertical scrollbar max value
      If \scroll\v And \scroll\v\page\len And \scroll\v\max<>\scroll\height And 
         SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\scrollstep = \text\height
        Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \scroll\width = (x+\scroll\h\page\pos)-\x[#_c_2]-Bool(Not \scroll\v\hide)*\scroll\v\width+n
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
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      ; Get text size
      If (\text And \text\change)
        \text\width = TextWidth(\text\string.s[1])
        \text\height = TextHeight("A")
      EndIf
      
      If \Image 
        If (\Image\change Or \resize Or \change)
          ; Image default position
          If \image\imageID
            If (\type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\scroll\h\page\len>\image\width And (\image\align\right Or \image\align\horizontal)) * (\scroll\h\page\len-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\scroll\v\page\len>\image\height And (\image\align\bottom Or \image\align\Vertical)) * (\scroll\v\page\len-\image\height)) / (\image\align\Vertical+1)
              \image\y = \scroll\y+\image\y[1]+\y[#_c_2]
              \image\x = \scroll\x+\image\x[1]+\x[#_c_2]
              
            ElseIf (\type = #PB_GadgetType_Window)
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[#_c_2]
              \image\y = \image\y[1]+\y+\bs+(\tabHeight-\image\height)/2
              \text\x[2] = \image\x[2] + \image\width
            Else
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[#_c_2]
              \image\y = \image\y[1]+\y[#_c_2]
            EndIf
          EndIf
        EndIf
        
        Protected image_width = \Image\width
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
          \text\x[1] = \text\x[2] + (Bool((\text\align\right Or \text\align\horizontal)) * (\width[#_c_2]-\text\width-image_width)) / (\text\align\horizontal+1)
          \text\y[1] = \text\y[2] + (Bool((\text\align\bottom Or \text\align\Vertical)) * (\height[#_c_2]-\text\height)) / (\text\align\Vertical+1)
          
          If \type = #PB_GadgetType_Frame
            \text\x = \text\x[1]+\x[#_c_2]+8
            \text\y = \text\y[1]+\y
            
          ElseIf \type = #PB_GadgetType_Window
            \text\x = \text\x[1]+\x[#_c_2]+5
            \text\y = \text\y[1]+\y+\bs+(\tabHeight-\text\height)/2
          Else
            \text\x = \text\x[1]+\x[#_c_2]
            \text\y = \text\y[1]+\y[#_c_2]
          EndIf
        EndIf
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
        
        If \Image[1] And \container
          \image[1]\x = \x[#_c_2] 
          \image[1]\y = \y[#_c_2]
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
          parent_item = Bool(\type = #PB_GadgetType_Panel) * \index[2]
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
            
          Next
        EndIf
        
        If \width[#_c_4] > 0 And \height[#_c_4] > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4], $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $F00F00)
        EndIf
        
        UnclipOutput()
        
      EndIf
      
      ; reset 
      \change = 0
      \resize = 0
      If \text
        \text\change = 0
      EndIf
      If \Image
        \image\change = 0
      EndIf
      
      ; Root()\type =- 1 
      ; Root()\this = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      Init_Event(*this)
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        ;DrawingMode(#PB_2DDrawing_Default)
        ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
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
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          ;\Items() = AllocateMemory(SizeOf(_S_items) )
          \Items() = AllocateStructure(_S_items)
          
          ;\Items()\handle = adress
          \Items()\change = Bool(\type = #PB_GadgetType_Tree)
          ;\Items()\text\fontID = \text\fontID
          \Items()\Index[1] =- 1
          ;\Items()\focus =- 1
          ;\Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            ;             Select \fromtribute
            ;               Case #PB_Attribute_LargeIcon
            ;                 \Items()\Image\width = 32
            ;                 \Items()\Image\height = 32
            ;                 ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
            ;                 
            ;               Case #PB_Attribute_SmallIcon
            ;                 \Items()\Image\width = 16
            ;                 \Items()\Image\height = 16
            ;                 ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
            ;                 
            ;               Default
            ;                 \Items()\Image\width = ImageWidth(Image)
            ;                 \Items()\Image\height = ImageHeight(Image)
            ;             EndSelect   
            
            \Items()\Image\ImageID = ImageID(Image)
            \Items()\Image\ImageID[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          Editor_AddLine(*this, Item.i, Text.s)
          \text\change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \Items()\color = Colors
                           ;           \Items()\color\state = 1
                           ;           \Items()\color\fore[0] = 0 
                           ;           \Items()\color\fore[1] = 0
                           ;           \Items()\color\fore[2] = 0
          
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
        
        PushListPosition(\Items())
        While PreviousElement(\Items()) 
          If subLevel = \Items()\subLevel
            \i_Parent = \Items()\i_Parent
            Break
          ElseIf subLevel > \Items()\subLevel
            \i_Parent = \Items()
            Break
          EndIf
        Wend 
        PopListPosition(\Items())
        
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
      \items()\index[1] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \text\height
      \Items()\i_Parent = \i_Parent
      
      Set_Image(\items(), Image)
      
      \items()\y = \scroll\height
      \scroll\height + \items()\height
      
      \Image = AllocateStructure(_S_image)
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
        \columns()\items()\index[1] =- 1
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
        
        
        \columns()\Items()\text\string.s = StringField(Text.s, ListIndex(\columns()) + 1, #LF$)
        \columns()\color = def_colors
        \columns()\color\fore[0] = 0 
        \columns()\color\fore[1] = 0
        \columns()\color\fore[2] = 0
        
        \columns()\Items()\y = \scroll\height
        \columns()\Items()\height = height
        \columns()\Items()\change = 1
        
        \image\width = \columns()\Items()\image\width
        ;         If ListIndex(\columns()\Items()) = 0
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
      \items()\index[1] =- 1
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
    ProcedureReturn *this\x[Mode]
  EndProcedure
  
  Procedure.i Y(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\y[Mode]
  EndProcedure
  
  Procedure.i Width(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\width[Mode]
  EndProcedure
  
  Procedure.i Height(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\height[Mode]
  EndProcedure
  
  Procedure.i CountItems(*this._S_widget)
    ProcedureReturn *this\countItems
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
  
  Procedure.i ClearItems(*this._S_widget) 
    With *this
      \countItems = 0
      \text\change = 1 
      If \text\Editable
        \text\string = #LF$
      EndIf
      
      ClearList(\Items())
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
      \countItems = ListSize(\Items()) ; - 1
      \text\change = 1
      
      If \countItems =- 1 
        \countItems = 0 
        \text\string = #LF$
        ;         If Not \repaint : \repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug Item
        If SelectElement(\Items(), Item)
          DeleteElement(\Items())
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
      
      If Not \Enumerate
        Result = FirstElement(\childrens())
      Else
        Result = NextElement(\childrens())
      EndIf
      
      \Enumerate = Result
      
      If Result
        If \childrens()\parent_item <> parent_item 
          ProcedureReturn Enumerate(*this, *Parent, parent_item)
        EndIf
        
        ;         If ListSize(\childrens()\childrens())
        ;           ProcedureReturn Enumerate(*this, \childrens(), Item)
        ;         EndIf
        
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
          \o_i = ListIndex(\Items())
          
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
      
      \columns()\index[1] =- 1
      \columns()\index[2] =- 1
      \columns()\index = Position
      \columns()\width = Width
      
      \columns()\Image = AllocateStructure(_S_image)
      \columns()\image\x[1] = 5
      
      \columns()\text = AllocateStructure(_S_text)
      \columns()\text\string.s = Title.s
      \columns()\text\change = 1
      
      \columns()\x = \x[#_c_2]+\scroll\width
      \columns()\height = \tabHeight
      \scroll\height = \bs*2+\columns()\height
      \scroll\width + Width + 1
    EndWith
  EndProcedure
  
  
  ;- GET
  Procedure.i GetAdress(*this._S_widget)
    ProcedureReturn *this\adress
  EndProcedure
  
  Procedure.i GetButtons(*this._S_widget)
    ProcedureReturn *this\mouse\buttons
  EndProcedure
  
  Procedure.i GetDisplay(*this._S_widget)
    ProcedureReturn *this\root\canvas\gadget
  EndProcedure
  
  Procedure.i GetMouseX(*this._S_widget)
    ProcedureReturn *this\mouse\x-*this\x[#_c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetMouseY(*this._S_widget)
    ProcedureReturn *this\mouse\y-*this\y[#_c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetDeltaX(*this._S_widget)
    ;If *this\mouse\delta
    ; ProcedureReturn (*this\mouse\delta\x-*this\x[#_c_2]-*this\fs)+*this\x[#_c_3]
    ProcedureReturn (*this\root\mouse\delta\x-*this\x[#_c_2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.i GetDeltaY(*this._S_widget)
    ;If *this\mouse\delta
    ; ProcedureReturn (*this\mouse\delta\y-*this\y[#_c_2]-*this\fs)+*this\y[#_c_3]
    ProcedureReturn (*this\root\mouse\delta\y-*this\y[#_c_2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.s GetClass(*this._S_widget)
    ProcedureReturn *this\class
  EndProcedure
  
  Procedure.i GetCount(*this._S_widget)
    ProcedureReturn *this\type_Index ; Parent\count(Hex(*this\parent)+"_"+Hex(*this\type))
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
          Case #PB_List_Before : ChangeCurrentElement(\parent\childrens(), Adress(*this)) : Result = PreviousElement(\parent\childrens())
          Case #PB_List_After  : ChangeCurrentElement(\parent\childrens(), Adress(*this)) : Result = NextElement(\parent\childrens())
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
          
        Case #PB_GadgetType_IPAddress : Result = \index[2]
        Case #PB_GadgetType_ComboBox : Result = \index[2]
        Case #PB_GadgetType_Tree : Result = \index[2]
        Case #PB_GadgetType_ListIcon : Result = \index[2]
        Case #PB_GadgetType_ListView : Result = \index[2]
        Case #PB_GadgetType_Panel : Result = \index[2]
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = \page\pos ; _scroll_invert_(*this, \page\pos, \inverted)
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
                width = \parent\width[#_c_2] - x1 - x2
              EndIf
              If \align\top And \align\bottom 
                \y = y2
                height = \parent\height[#_c_2] - y1 - y2
              EndIf
              
              If \align\left And Not \align\right
                \x = x2
                \y = y2
                x2 + \width
                height = \parent\height[#_c_2] - y1 - y2
              EndIf
              If \align\right And Not \align\left
                \x = \parent\width[#_c_2] - \width - x1
                \y = y2
                x1 + \width
                height = \parent\height[#_c_2] - y1 - y2
              EndIf
              
              If \align\top And Not \align\bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \parent\width[#_c_2] - x1 - x2
              EndIf
              If \align\bottom And Not \align\top
                \x = 0
                \y = \parent\height[#_c_2] - \height - y1
                y1 + \height
                width = \parent\width[#_c_2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
              \align\top = Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              \align\left = Bool(Mode&#PB_Left=#PB_Left)+Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Top=#PB_Top)
              \align\right = Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Bottom=#PB_Bottom)
              \align\bottom = Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              
            EndIf
            
            If \align\right
              If \align\left And \align\right
                \align\x = \parent\width[#_c_2] - \width
              Else
                \align\x = \parent\width[#_c_2] - (\x-\parent\x[#_c_2]) ; \parent\width[#_c_2] - (\parent\width[#_c_2] - \width)
              EndIf
            EndIf
            If \align\bottom
              If \align\top And \align\bottom
                \align\y = \parent\height[#_c_2] - \height
              Else
                \align\y = \parent\height[#_c_2] - (\y-\parent\y[#_c_2]) ; \parent\height[#_c_2] - (\parent\height[#_c_2] - \height)
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
          parent_item = *Parent\index[2]
        EndIf
        
        If *Parent <> \parent Or \parent_item <> parent_item
          x = \x[#_c_3]
          y = \y[#_c_3]
          
          If \parent And ListSize(\parent\childrens())
            ChangeCurrentElement(\parent\childrens(), Adress(*this)) 
            DeleteElement(\parent\childrens())
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \parent_item = parent_item
          \parent = *Parent
          \root = \parent\root
          
          \root\countItems + 1 
          
          If \parent <> \root
            \parent\countItems + 1 
            \Level = \parent\Level + 1
            \Window = \parent\Window
          Else
            \Window = \parent
          EndIf
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \hide = Bool(\parent\hide Or \parent_item <> \parent\index[2])
          
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
          \index = \root\countItems 
          \adress = AddElement(\parent\childrens())
          
          If \adress
            \parent\childrens() = *this 
          EndIf
          
          ; Make count type
          If \Window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\Type))
            typecount(Hex(\window)+"_"+Hex(\Type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\Type))
            typecount(Hex(\parent)+"__"+Hex(\Type)) + 1
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
        
        ChangeCurrentElement(\parent\childrens(), Adress(*this))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\parent\childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\parent\childrens()) : MoveElement(\parent\childrens(), #PB_List_After, Adress(\parent\childrens()))
            Case #PB_List_After  : NextElement(\parent\childrens())     : MoveElement(\parent\childrens(), #PB_List_Before, Adress(\parent\childrens()))
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
  
  Procedure.i SetFocus(*this._S_widget, State.i)
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
        
        PostEvent(#PB_Event_Gadget, Root()\active\root\canvas\window, Root()\active\root\canvas\gadget, #PB_EventType_Repaint)
      EndIf
      
      If Root()\active\_gadget
        Root()\active\_gadget\focus = _state_
        If _state_
          Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
      EndIf
    EndMacro
    
    With *this
      If \type > 0
        If Root()\active\_gadget <> *this
          
          If Root()\active <> \window
            If Root()\active
              _set_active_state_(0)
            EndIf
            
            Root()\active = \window
            Root()\active\_gadget = *this
            
            _set_active_state_(1)
          Else
            If Root()\active\_gadget
              Root()\active\_gadget\focus = 0
              Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_LostFocus, -1, -1)
            EndIf
            
            Root()\active\_gadget = *this
            Root()\active\_gadget\focus = 1
            Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_Focus, -1, -1)
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
  
  Procedure.i SetForeground(*this._S_widget)
    Protected repaint
    
    With *this
      ; SetActiveGadget(\root\canvas\gadget)
      SetPosition(\window, #PB_List_Last)
      SetActive(*this)
    EndWith
    
    ProcedureReturn repaint
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
  
  ;Declare.b Resize_Bar(*this._S_widget, X.l,Y.l,Width.l,Height.l)
  
  Procedure.i SetPos_Bar(*this._S_widget, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _set_area_coordinate_(*this)
      EndIf
      
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If \thumb\end <> ThumbPos 
        \thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \area\end <> ThumbPos
          ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical
          ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState_Bar(*this._S_widget, ScrollPos.l)
    Protected Result.b
    
    With *this
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      ;       If ScrollPos > \page\end 
      ;         ScrollPos = \page\end 
      ;         Debug \page\end
      ;       EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
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
              \direction = _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, ScrollPos, \inverted))
        ; Debug ""+\thumb\pos+" "+\area\end+" "+\page\pos+" "+\page\end+" "+\page\len+" "+\max+" "+\min+" "+\height
        
        If \splitter And \splitter\fixed = #_b_1
          \splitter\fixed[\splitter\fixed] = \thumb\pos - \area\pos
          \page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #_b_2
          \splitter\fixed[\splitter\fixed] = \area\len - ((\thumb\pos+\thumb\len)-\area\pos)
          \page\pos = \max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute_Bar(*this._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      Select Attribute
        Case #PB_Bar_ScrollStep 
          \scrollstep = Value
          
        Case #PB_Bar_FirstMinimumSize
          \button[#_b_1]\len = Value
          Result = #True
          
        Case #PB_Bar_SecondMinimumSize
          \button[#_b_2]\len = Value
          Result = #True
          
        Case #PB_Bar_NoButtons
          If \button\len <> Value
            \button\len = Value
            \button[#_b_1]\len = Value
            \button[#_b_2]\len = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Inverted
          If \inverted <> Bool(Value)
            \inverted = Bool(Value)
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          EndIf
          
        Case #PB_Bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_Bar_PageLength
          If \page\len <> Value
            If Value > (\max-\min) 
              \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
      
      If Result
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
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
            If \index[2] <> State : \index[2] = State
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
            
            If *t\index[2] <> State
              If *t\index[2] >= 0 And SelectElement(*t\items(), *t\index[2]) 
                *t\items()\state = 0
              EndIf
              
              *t\index[2] = State
              \index[2] = State
              
              If SelectElement(*t\items(), State)
                *t\items()\state = 2
                *t\change = State+1
                
                \text\string[1] = *t\Items()\text\string
                \text\string = \text\string[1]
                ;                 \text[1]\string = \text\string[1]
                ;                 \text\caret = 1
                ;                 \text\caret[1] = \text\caret
                \text\change = 1
                
                Event_Widgets(*this, #PB_EventType_Change, State)
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \countItems - 1 : State = \countItems - 1 :  EndIf
            
            If \index[2] <> State
              If \index[2] >= 0 And 
                 SelectElement(\items(), \index[2]) 
                \items()\state = 0
              EndIf
              
              \index[2] = State
              
              If SelectElement(\items(), \index[2])
                \items()\state = 2
                \change = \index[2]+1
                ; Event_Widgets(*this, #PB_EventType_Change, \index[2])
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
            
            If \index[2] <> State : \index[2] = State
              
              ForEach \childrens()
                set_hide_state(\childrens(), Bool(\childrens()\parent_item<>State))
              Next
              
              \change = State + 1
              Result = 1
            EndIf
            
          Case #PB_GadgetType_ScrollBar,
               #PB_GadgetType_ProgressBar, 
               #PB_GadgetType_TrackBar, 
               #PB_GadgetType_Splitter
            
            Result = SetState_Bar(*this, State)
            
          Default
            If (\Vertical And \type = #PB_GadgetType_TrackBar)
              State = _scroll_invert_(*this, State, \inverted)
            EndIf
            
            State = PagePos(*this, State)
            
            If \page\pos <> State 
              \thumb\pos = _thumb_pos_(*this, State)
              
              If \inverted
                If \page\pos > State
                  \direction = _scroll_invert_(*this, State, \inverted)
                Else
                  \direction =- _scroll_invert_(*this, State, \inverted)
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
                ; Resize_Splitter(*this)
                
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
              
              Event_Widgets(*this, #PB_EventType_Change, State, \direction)
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
            
          Case #PB_GadgetType_ScrollBar,
               #PB_GadgetType_ProgressBar, 
               #PB_GadgetType_TrackBar, 
               #PB_GadgetType_Splitter
               
            Resize = SetAttribute_Bar(*this, Attribute, Value)
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \box\size[0] = Value
                \box\size[1] = Value
                \box\size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \page\pos = _scroll_invert_(*this, \page\pos)
                \thumb\pos = _thumb_pos_(*this, \page\pos)
                
                ; \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
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
          ;       If \index[2] <> Item
          ;         If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
          ;           \items()\state = 0
          ;         EndIf
          ;         
          ;         If SelectElement(\items(), Item)
          ;           Root()\type = #PB_EventType_Change
          ;           Root()\widget = *this
          ;           \items()\state = 2
          ;           \change = Item+1
          ;           
          ;           PostEvent(#PB_Event_Widget, Root()\window, *this, #PB_EventType_Change)
          ;           PostEvent(#PB_Event_Gadget, Root()\window, Root()\Gadget, #PB_EventType_Repaint)
          ;         EndIf
          ;         
          ;         \index[2] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\flag\multiSelect Or \flag\clickSelect)
          PushListPosition(\Items())
          Result = SelectElement(\Items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \Items()\Index[1] = \Items()\Index
              \Items()\state = Bool(State)+1
            EndIf
            
            \Items()\box\checked = Bool(State&#PB_Tree_Collapsed)
            
            If \Items()\box\checked Or State&#PB_Tree_Expanded
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#PB_Tree_Collapsed
                    \Items()\hide = 1
                  ElseIf State&#PB_Tree_Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            
          EndIf
          PopListPosition(\Items())
          ; EndIf
          
          ;          If \index[1] >= 0 And SelectElement(\items(), \index[1]) 
          ;                 Protected sublevel.i
          ;                 
          ;                 If (MouseY > (\items()\box\y[1]) And MouseY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
          ;                    ((MouseX > \items()\box\x[1]) And (MouseX =< (\items()\box\x[1]+\items()\box\width[1])))
          ;                   
          ;                   \items()\box\checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (MouseY > (\items()\box\y[0]) And MouseY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
          ;                        ((MouseX > \items()\box\x[0]) And (MouseX =< (\items()\box\x[0]+\items()\box\width[0])))
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
          ;                 ElseIf \index[2] <> \index[1] : \items()\state = 2
          ;                   If \index[2] >= 0 And SelectElement(\items(), \index[2])
          ;                     \items()\state = 0
          ;                   EndIf
          ;                   \index[2] = \index[1]
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
  
  Procedure.i SetData(*this._S_widget, *Data)
    Protected Result.i
    
    With *this
      \data = *Data
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
  Procedure.b Resize_Bar(*this._S_widget, X.l,Y.l,Width.l,Height.l)
  With *this
      If X<>#PB_Ignore 
        \x = X 
      EndIf 
      If Y<>#PB_Ignore 
        \y = Y 
      EndIf 
      If Width<>#PB_Ignore 
        \width = Width 
      EndIf 
      If Height<>#PB_Ignore 
        \height = height 
      EndIf
      
      ;
      If (\max-\min) >= \page\len
        ; Get area screen coordinate pos (x&y) and len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \max And \width And \height
          \max = \area\len-\button\len
          
          If Not \page\pos
            \page\pos = \max/2
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #_b_1
          ;             \splitter\fixed[\splitter\fixed] = \page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #_b_2
          ;             \splitter\fixed[\splitter\fixed] = \area\len-\page\pos-\button\len
          ;           EndIf
        EndIf
        
        ;
        If \splitter 
          If \splitter\fixed
            If \area\len - \button\len > \splitter\fixed[\splitter\fixed] 
              \page\pos = Bool(\splitter\fixed = 2) * \max
              
              If \splitter\fixed[\splitter\fixed] > \button\len
                \area\pos + \splitter\fixed[1]
                \area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \area\len - \button\len
              \page\pos = Bool(\splitter\fixed = 1) * \max
            EndIf
          EndIf
          
          ; Debug ""+\area\len +" "+ Str(\button[#_b_1]\len + \button[#_b_2]\len)
          
          If \area\len =< \button\len
            \page\pos = \max/2
            
            If \Vertical
              \area\pos = \Y 
              \area\len = \Height
            Else
              \area\pos = \X
              \area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \area\len > \button\len
          \thumb\len = Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest)
          
          If \thumb\len > \area\len 
            \thumb\len = \area\len 
          EndIf 
          
          If \thumb\len > \button\len
            \area\end = \area\pos + (\area\len-\thumb\len)
          Else
            \area\len = \area\len - (\button\len-\thumb\len)
            \area\end = \area\pos + (\area\len-\thumb\len)                              
            \thumb\len = \button\len
          EndIf
          
        Else
          If \splitter
            \thumb\len = \width
          Else
            \thumb\len = 0
          EndIf
          
          If \Vertical
            \area\pos = \Y
            \area\len = \Height
          Else
            \area\pos = \X
            \area\len = \width 
          EndIf
          
          \area\end = \area\pos + (\area\len - \thumb\len)
        EndIf
        
        \page\end = \max - \page\len
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
        
        If \thumb\pos = \area\end And \type = #PB_GadgetType_ScrollBar
          ; Debug " line-" + #PB_Compiler_Line +" "+  \type 
          SetState(*this, \max)
        EndIf
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.i Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #PB_Flag_AutoSize
        If \parent And \parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\x
          Y = 0; \align\y
          Width = \parent\width[#_c_2] ; - \align\x
          Height = \parent\height[#_c_2] ; - \align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \parent : \x[#_c_3] = X : X+\parent\x+\parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[#_c_2] = \x+\bs : \x[#_c_1] = \x[#_c_2]-\fs : \resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \parent : \y[#_c_3] = Y : Y+\parent\y+\parent\bs+\parent\tabHeight : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[#_c_2] = \y+\bs+\tabHeight : \y[#_c_1] = \y[#_c_2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[#_c_2] = \width-\bs*2 : \width[#_c_1] = \width[#_c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[#_c_2] = \height-\bs*2-\tabHeight : \height[#_c_1] = \height[#_c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[#_c_2] = width-Bool(\type<>-1)*(\bs*2) : \width[#_c_1] = \width[#_c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\tabHeight+\bs*2) : \height[#_c_2] = height-Bool(\type<>-1)*(\tabHeight+\bs*2) : \height[#_c_1] = \height[#_c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        If \box And \resize
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
          
          If \box\size
            \box\size[1] = \box\size
            \box\size[2] = \box\size
          EndIf
          
          If \max
            If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
              \area\pos = \y[#_c_2]+\box\size[1]
              \area\len = \height[#_c_2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            Else
              \area\pos = \x[#_c_2]+\box\size[1]
              \area\len = \width[#_c_2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
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
                  \area\end = \area\pos + (\height[#_c_2]-\box\size[3]) 
                  \thumb\len = \box\size[3]
                EndIf
              EndIf
            Else
              \area\end = \area\pos + (\height[#_c_2]-\area\len)
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
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
            
            If \type <> #PB_GadgetType_TrackBar And \thumb\pos = \area\end
              SetState(*this, \max)
            EndIf
          EndIf
          
          Select \type
            Case #PB_GadgetType_Window
              \box\x = \x[#_c_2]
              \box\y = \y+\bs
              \box\width = \width[#_c_2]
              \box\height = \tabHeight
              
              \box\width[1] = \box\size
              \box\width[2] = \box\size
              \box\width[3] = \box\size
              
              \box\height[1] = \box\size
              \box\height[2] = \box\size
              \box\height[3] = \box\size
              
              \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\width[1]-5
              \box\x[2] = \box\x[1]-Bool(Not \box\hide[2]) * \box\width[2]-5
              \box\x[3] = \box\x[2]-Bool(Not \box\hide[3]) * \box\width[3]-5
              
              \box\y[1] = \y+\bs+(\tabHeight-\box\size)/2
              \box\y[2] = \box\y[1]
              \box\y[3] = \box\y[1]
              
            Case #PB_GadgetType_Panel
              \page\len = \width[#_c_2]-2
              
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
              
              \box\x[1] = \x[#_c_2]+1
              \box\y[1] = \y[#_c_2]-\tabHeight+\bs+2
              \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\width[2]-1
              \box\y[2] = \box\y[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \box\y[1] = \y[#_c_2]+\height[#_c_2]/2+Bool(\height[#_c_2]%2) : \box\height[1] = \height[#_c_2]/2 : \box\width[1] = \box\size[2] : \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\size[2] ; Top button coordinate
                \box\y[2] = \y[#_c_2] : \box\height[2] = \height[#_c_2]/2 : \box\width[2] = \box\size[2] : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2]                                 ; Bottom button coordinate
              Else
                \box\y[1] = \y[#_c_2] : \box\height[1] = \height[#_c_2] : \box\width[1] = \box\size[2]/2 : \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\size[2]                                 ; Left button coordinate
                \box\y[2] = \y[#_c_2] : \box\height[2] = \height[#_c_2] : \box\width[2] = \box\size[2]/2 : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \box\size
                  \box\x[1] = \x[#_c_2] + Lines : \box\y[1] = \y[#_c_2] : \box\width[1] = \width - Lines : \box\height[1] = \box\size[1]                         ; Top button coordinate on scroll bar
                  \box\x[2] = \x[#_c_2] + Lines : \box\width[2] = \width - Lines : \box\height[2] = \box\size[2] : \box\y[2] = \y[#_c_2]+\height[#_c_2]-\box\size[2] ; (\area\pos+\area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \box\x[3] = \x[#_c_2] + Lines : \box\width[3] = \width - Lines : \box\y[3] = \thumb\pos : \box\height[3] = \thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \box 
                If \box\size
                  \box\x[1] = \x[#_c_2] : \box\y[1] = \y[#_c_2] + Lines : \box\height[1] = \height - Lines : \box\width[1] = \box\size[1]                        ; Left button coordinate on scroll bar
                  \box\y[2] = \y[#_c_2] + Lines : \box\height[2] = \height - Lines : \box\width[2] = \box\size[2] : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2] ; (\area\pos+\area\len)  ; Right button coordinate on scroll bar
                EndIf
                \box\y[3] = \y[#_c_2] + Lines : \box\height[3] = \height - Lines : \box\x[3] = \thumb\pos : \box\width[3] = \thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        If \type = #PB_GadgetType_ScrollBar Or
           \type = #PB_GadgetType_ProgressBar Or
           \type = #PB_GadgetType_TrackBar Or
           \type = #PB_GadgetType_Splitter
          
          Resize_Bar(*this, x,y,width,height)
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
          clip_width = ((\parent\x[#_c_4]+\parent\width[#_c_4])-Bool((\parent\x[#_c_4]+\parent\width[#_c_4])>(\parent\x[#_c_2]+\parent\width[#_c_2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#_c_4]+\parent\height[#_c_4])-Bool((\parent\y[#_c_4]+\parent\height[#_c_4])>(\parent\y[#_c_2]+\parent\height[#_c_2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#_c_4] = clip_x : Else : \x[#_c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#_c_4] = clip_y : Else : \y[#_c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#_c_4] = clip_width - \x[#_c_4] : Else : \width[#_c_4] = \width - (\x[#_c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#_c_4] = clip_height - \y[#_c_4] : Else : \height[#_c_4] = \height - (\y[#_c_4]-\y) : EndIf
        
        ; Resize scrollbars
        If \scroll And \scroll\v And \scroll\h
          Resizes(\scroll, 0,0, \width[#_c_2],\height[#_c_2])
        EndIf
        
        ; Resize childrens
        If ListSize(\childrens())
          If \type = #PB_GadgetType_Splitter
            Resize_Splitter(*this)
          Else
            ForEach \childrens()
              If \childrens()\align
                If \childrens()\align\horizontal
                  x = (\width[#_c_2] - (\childrens()\align\x+\childrens()\width))/2
                ElseIf \childrens()\align\right And Not \childrens()\align\left
                  x = \width[#_c_2] - \childrens()\align\x
                Else
                  If \x[#_c_2]
                    x = (\childrens()\x-\x[#_c_2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \childrens()\align\Vertical
                  y = (\height[#_c_2] - (\childrens()\align\y+\childrens()\height))/2 
                ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                  y = \height[#_c_2] - \childrens()\align\y
                Else
                  If \y[#_c_2]
                    y = (\childrens()\y-\y[#_c_2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \childrens()\align\top And \childrens()\align\bottom
                  Height = \height[#_c_2] - \childrens()\align\y
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \childrens()\align\left And \childrens()\align\right
                  Width = \width[#_c_2] - \childrens()\align\x
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\childrens(), x, y, Width, Height)
              Else
                Resize(\childrens(), (\childrens()\x-\x[#_c_2]) + Change_x, (\childrens()\y-\y[#_c_2]) + Change_y, #PB_Ignore, #PB_Ignore)
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
    With *scroll
      Protected iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x, iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      ;Protected iWidth = \h\page\len, iHeight = \v\page\len
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
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      ;       If -\v\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      ;       If -\h\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      If -\v\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\Page\Pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\page\pos > ScrollArea_X And ScrollArea_X<>\h\Page\Pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      *Scroll\Y =- \v\Page\Pos
      *Scroll\X =- \h\Page\Pos
      *Scroll\width = \v\Max
      *Scroll\height = \h\Max
      
      
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
    With *scroll
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
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
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
      If Caret <> *this\text\caret Or Line <> *this\index[1] Or (*this\text\caret[1] >= 0 And Caret1 <> *this\text\caret[1])
        \text[2]\string.s = ""
        
        If *this\index[2] = *this\index[1]
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
            If *this\index[1] > *this\index[2]
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
        
        Line = *this\index[1]
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
      If \Keyboard\Input
        Chr.s = Text_Make(*this, Chr(\Keyboard\Input))
        
        If Chr.s
          If \text[2]\len 
            String_Remove(*this)
          EndIf
          
          \text\caret + 1
          ; \items()\text\string.s[1] = \items()\text[1]\string.s + Chr(\Keyboard\Input) + \items()\text[3]\string.s ; сним не выравнивается строка при вводе слов
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
    
    If *this\Keyboard\Input : *this\Keyboard\Input = 0
      String_ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    
    With *this
      \Keyboard\Input = 65535
      
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
  
  Procedure String_Editable(*this._S_widget, EventType.i, MouseX.i, MouseY.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *this
      *this\index[1] = 0
      
      With *this
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If \root\canvas\gadget And #PB_Cursor_Default = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
            EndIf
            
            If *this\text\Editable And *this\drag[1] : *this\drag[1] = 0
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
          Control = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Command)
        CompilerElse
          Control = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Control)
        CompilerEndIf
        
        Select EventType
          Case #PB_EventType_Input
            If Not Control
              Repaint = String_ToInput(*this)
            EndIf
            
          Case #PB_EventType_KeyUp
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *this\Keyboard\Key
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
  Procedure.i Area(*parent, X.l,Y.l,Width.l,Height.l, Size, mode.i=0)
    Protected *this._S_scroll = AllocateStructure(_S_scroll)
    
    *this\v._S_widget = AllocateStructure(_S_widget)
    
    With *this\v
      _set_def_colors_(*this\v)
      \type = #PB_GadgetType_ScrollBar
      \vertical = 1
      \radius = 7
    
      \button\len = Size-1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      \button[#_b_1]\arrow_type =- 1
      \button[#_b_2]\arrow_type =- 1
      \button[#_b_1]\arrow_size = 4
      \button[#_b_2]\arrow_size = 4
      \button[#_b_1]\len = \button\len
      \button[#_b_2]\len = \button\len
      
      \parent = *parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      Resize_Bar(*this\v, Width-Size,0,Size,Height)
    EndWith
    
    *this\h._S_widget = AllocateStructure(_S_widget)
    
    With *this\h
      _set_def_colors_(*this\h)
      \type = #PB_GadgetType_ScrollBar
      \radius = 7
      \button\len = Size-1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      \button[#_b_1]\arrow_type =- 1
      \button[#_b_2]\arrow_type =- 1
      \button[#_b_1]\arrow_size = 4
      \button[#_b_2]\arrow_size = 4
      \button[#_b_1]\len = \button\len
      \button[#_b_2]\len = \button\len
      
      \parent = *parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      Resize_Bar(*this\h, 0,Height-Size,Width,Bool(mode)*Size)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      _set_def_colors_(*this)
      _set_last_parameters_(*this, #PB_GadgetType_ScrollBar, Flag, Root()\opened) 
      
      \radius = Radius
      \vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
    
      ;\interact = 1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      
      \button[#_b_1]\arrow_type = 1
      \button[#_b_2]\arrow_type = 1
      \button[#_b_1]\arrow_size = 6
      \button[#_b_2]\arrow_size = 6
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If \vertical
          If width < 21
            \button\len = width - 1
          Else
            \button\len = 17
          EndIf
        Else
          If height < 21
            \button\len = height - 1
          Else
            \button\len = 17
          EndIf
        EndIf
        
        \button[#_b_1]\len = \button\len
        \button[#_b_2]\len = \button\len
      EndIf
      
      SetAttribute_Bar(*this, #PB_Bar_Minimum, Min)
      SetAttribute_Bar(*this, #PB_Bar_Maximum, Max)
      SetAttribute_Bar(*this, #PB_Bar_PageLength, PageLength) 
      
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      _set_def_colors_(*this)
      _set_last_parameters_(*this, #PB_GadgetType_TrackBar, Flag, Root()\opened)
      
      \vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks) * #PB_Bar_Ticks
      
      \radius = 7
      \button\len = 15
      \inverted = \vertical
      \button[#_b_3]\interact = 1
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      \button[#_b_1]\len = 1
      \button[#_b_2]\len = 1
      
      \button[#_b_3]\arrow_size = 4
      \button[#_b_3]\arrow_type = 0
      
      \cursor = #PB_Cursor_Hand
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      SetAttribute_Bar(*this, #PB_Bar_Minimum, Min)
      SetAttribute_Bar(*this, #PB_Bar_Maximum, Max)
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      _set_def_colors_(*this)
      _set_last_parameters_(*this, #PB_GadgetType_ProgressBar, Flag, Root()\opened) 
      
      \vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \inverted = \vertical
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      ;\mode = 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      SetAttribute_Bar(*this, #PB_Bar_Minimum, Min)
      SetAttribute_Bar(*this, #PB_Bar_Maximum, Max)
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
     _set_def_colors_(*this)
     _set_last_parameters_(*this, #PB_GadgetType_Splitter, Flag, Root()\opened) 
      
      \vertical = Bool(Flag&#PB_Splitter_Vertical=0)
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If \vertical
        \cursor = #PB_Cursor_UpDown
      Else
        \cursor = #PB_Cursor_LeftRight
      EndIf
      
      \Splitter = AllocateStructure(_S_splitter)
      \Splitter\first = First
      \Splitter\second = Second
;       \splitter\resize = @splitter_size()
;       \splitter\g_first = IsGadget(First)
;       \splitter\g_second = IsGadget(Second)
      \button[#_b_3]\interact = 1
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      If Bool(Flag&#PB_Splitter_Separator)
        \mode = #PB_Splitter_Separator
        \button\len = 7
      Else
        \mode = 1
        \button\len = 3
      EndIf
      
      SetParent(\Splitter\First, *this)
      SetParent(\Splitter\Second, *this)
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
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
      ;\ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      ;\smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
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
      
      ;\radius = Radius
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      ;\smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
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
      \text\Editable = 1
      
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
    _set_last_parameters_(*this, #PB_GadgetType_Image, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \Image = AllocateStructure(_S_image)
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
      
      \Image = AllocateStructure(_S_image)
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
      
      \Image = AllocateStructure(_S_image)
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
    _set_last_parameters_(*this, #PB_GadgetType_Frame, Flag, Root()\opened)
    
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
    _set_last_parameters_(*this, #PB_GadgetType_ComboBox, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \index[1] =- 1
      \index[2] =- 1
      
      \text = AllocateStructure(_S_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      \text\height = 20
      
      \Image = AllocateStructure(_S_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\height = Height
      \box\width = 15
      \box\arrow_size = 4
      \box\arrow_type =- 1
      
      \index[1] =- 1
      \index[2] =- 1
      
      \sublevellen = 18
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \popup = Popup(*this, 0,0,0,0)
      OpenList(\popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) : \popup\childrens()\scroll\h\height=0
      CloseList()
      
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
    
    If ListSize(Root()\opened\childrens()) 
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
      \text\Editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      \text\align\Vertical = 1
      
      \text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
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
      \text\Editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      \text\align\Vertical = 1
      
      \text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
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
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      \Image = AllocateStructure(_S_image)
      
      
      \text = AllocateStructure(_S_text)
      \text[1] = AllocateStructure(_S_text)
      \text[2] = AllocateStructure(_S_text)
      \text[3] = AllocateStructure(_S_text)
      \text\Editable = 1
      \text\x[2] = 3
      \text\y[2] = 0
      ;\text\align\Vertical = 1
      
      ;       \text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
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
      
      
      
      If \text\Editable
        \color\back[0] = $FFFFFFFF 
      Else
        \color\back[0] = $FFF0F0F0  
      EndIf
      
      
      \Interact = 1
      \text\caret[1] =- 1
      \Index[1] =- 1
      \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
      \flag\lines = Bool(flag&#PB_Flag_NoLines)
      \flag\fullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
      ;\flag\alwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12 ; Это еще будет размер чек бокса
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      
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
    _set_last_parameters_(*this, #PB_GadgetType_Tree, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = Area(*this, 0,0,0,0, size, Bool(\flag\buttons Or \flag\lines))
    
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
      
      \index[1] =- 1
      \index[2] =- 1
      
      
      \text = AllocateStructure(_S_text)
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        
        \text\height = TextHeight("A")
        
        StopDrawing()
      EndIf
      
      \sublevellen = 0
      \flag\lines = 0
      \flag\buttons = 0
      
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = Area(*this, 0,0,0,0, size, Bool(\flag\buttons Or \flag\lines))
    
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    
    With *this
     _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag, Root()\opened)
     
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \tabHeight = 24
      
      \Image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = Area(*this, 0,0,0,0, size, Bool(\flag\buttons Or \flag\lines))
    
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
      
      \index[1] =- 1
      \index[2] =- 1
      \tabHeight = 24
      
      \Image = AllocateStructure(_S_image)
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = Area(*this, 0,0,0,0, size, Bool(\flag\buttons Or \flag\lines))
      
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
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(_S_image)
      
      \text = AllocateStructure(_S_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = Area(*this, 0,0,0,0, size, Bool(\flag\buttons Or \flag\lines))
    
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- Containers
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
      
      \index[1] =- 1
      \index[2] = 0
      
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
      \Image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X,Y,Width,Height)
      OpenList(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Container, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \color = def_colors
      \color\alpha = 255
      \color\fore = 0
      \color\back = $FFF6F6F6
      
      \index[1] =- 1
      \index[2] = 0
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X,Y,Width,Height)
      OpenList(*this)
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
      \Image[1] = AllocateStructure(_S_image)
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,ScrollAreaHeight,Height, #PB_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *this)
      ;       Resize(\scroll\v, #PB_Ignore,#PB_Ignore,Size,#PB_Ignore)
      ;       Resize(\scroll\h, #PB_Ignore,#PB_Ignore,#PB_Ignore,Size)
      
      Resize(*this, X,Y,Width,Height)
      OpenList(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;-
  Procedure.i CloseList()
    If Root()\opened\parent And Root()\opened\parent\root = Root()\opened\root
      Root()\opened = Root()\opened\parent
    Else
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
      Root()\opened\o_i = Item
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent._S_widget=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    If *parent 
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag, *parent) 
    Else
      OpenList(Root())
      
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag, Root()\opened) 
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
    
    If Root() And Root()\active 
      _set_active_state_(0)
    EndIf
    
    With *this
      Root() = *this
      \root = Root()
      \window = Root()
      
      \x =- 1
      \y =- 1
      \index[#Entered] =- 1
      \index[#Selected] = 0
      
      \class = "Root"
      \type = #PB_GadgetType_Window
      \container = #PB_GadgetType_Window
      
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      
      If Not flag&#PB_Window_BorderLess
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
      
      If Text.s
        SetText(*this, Text.s)
        \tabHeight = 23
      EndIf
      ;
      Width + \bs*2
      Height + \tabHeight + \bs*2
      
      OpenList(Root())
      SetActive(Root())
      Resize(Root(), 0, 0, Width,Height)
      
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
        If \Image : FreeStructure(\Image) : \Image = 0 : EndIf
        If \Image[1] : FreeStructure(\Image[1]) : \Image[1] = 0 : EndIf
        
        Root()\active = 0
        Root()\active\_gadget = 0
        
        If \parent And ListSize(\parent\childrens()) : \parent\countItems - 1
          ChangeCurrentElement(\parent\childrens(), Adress(*this))
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
    
    
    If Not *this\root\eventbind
      ; 
      Select eventtype 
        Case #PB_EventType_Focus, 
             #PB_EventType_LostFocus
          
          ForEach Root()\eventlist()
            If Root()\eventlist()\widget = *this And Root()\eventlist()\type = eventtype
              result = 1
            EndIf
          Next
          
          If Not result
            AddElement(Root()\eventlist())
            Root()\eventlist() = AllocateStructure(_S_event)
            Root()\eventlist()\widget = *this
            Root()\eventlist()\type = eventtype
            Root()\eventlist()\item = eventitem
            Root()\eventlist()\data = *data
          EndIf
          
      EndSelect
    EndIf
    
    If *this And *this\root\eventbind
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
    
    If Not *this\root\eventbind
      *this\root\eventbind = 1
    EndIf
    
    *this\event\type = eventtype
    *this\event\callback = *callback
    
    If ListSize(Root()\eventlist())
      ForEach Root()\eventlist()
        Post(Root()\eventlist()\type, Root()\eventlist()\widget, Root()\eventlist()\item, Root()\eventlist()\data)
      Next
      ClearList(Root()\eventlist())
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
  Procedure.i From(*this._S_widget, MouseX.i, MouseY.i)
    Protected *Result._S_widget, Change.b, X.l,Y.l,Width.l,Height.l, parent_item.i
    Static *r._S_widget
    
    If Root()\mouse\x <> MouseX
      Root()\mouse\x = MouseX
      Change = 1
    EndIf
    
    If Root()\mouse\y <> MouseY
      Root()\mouse\y = MouseY
      Change = 1
    EndIf
    
    If Not *this
      *this = Root() ; GetGadgetData(EventGadget())
    EndIf
    
    If Change 
      With *this
        If *this And ListSize(\childrens()) ; \countItems ; Not Root()\mouse\buttons
          parent_item = Bool(\type = #PB_GadgetType_Panel) * \index[2]
          
          PushListPosition(\childrens())    ;
          LastElement(\childrens())         ; Что бы начать с последнего элемента
          Repeat                            ; Перебираем с низу верх
            X = \childrens()\x[#_c_4]
            Y = \childrens()\y[#_c_4]
            Width = X+\childrens()\width[#_c_4]
            Height = Y+\childrens()\height[#_c_4]
            
            If Not \childrens()\hide And \childrens()\parent_item = parent_item And 
               (MouseX >=  X And MouseX < Width And MouseY >=  Y And MouseY < Height)
              
              If ListSize(\childrens()\childrens())
                Root()\mouse\x = 0
                Root()\mouse\y = 0
                *Result = From(\childrens(), MouseX, MouseY)
                
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
        \mouse\x = MouseX
        \mouse\y = MouseY
        
        If \scroll
          ; scrollbars events
          If \scroll\v And Not \scroll\v\hide And \scroll\v\type And (MouseX>\scroll\v\x And MouseX=<\scroll\v\x+\scroll\v\width And  MouseY>\scroll\v\y And MouseY=<\scroll\v\y+\scroll\v\height)
            *Result = \scroll\v
          ElseIf \scroll\h And Not \scroll\h\hide And \scroll\h\type And (MouseX>\scroll\h\x And MouseX=<\scroll\h\x+\scroll\h\width And  MouseY>\scroll\h\y And MouseY=<\scroll\h\y+\scroll\h\height)
            *Result = \scroll\h
          EndIf
        EndIf
        
        If \box 
          If (MouseX>\box\x[3] And MouseX=<\box\x[3]+\box\width[3] And MouseY>\box\y[3] And MouseY=<\box\y[3]+\box\height[3])
            \from = 3
          ElseIf (MouseX>\box\x[2] And MouseX=<\box\x[2]+\box\width[2] And MouseY>\box\y[2] And MouseY=<\box\y[2]+\box\height[2])
            \from = 2
          ElseIf (MouseX>\box\x[1] And MouseX=<\box\x[1]+\box\width[1] And  MouseY>\box\y[1] And MouseY=<\box\y[1]+\box\height[1])
            \from = 1
          ElseIf (MouseX>\box\x And MouseX=<\box\x+\box\width And MouseY>\box\y And MouseY=<\box\y+\box\height)
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
                If (MouseX>=\columns()\x And MouseX=<\columns()\x+\columns()\width+1 And 
                    MouseY>=\columns()\y And MouseY=<\columns()\y+\columns()\height)
                  
                  \index[1] = \columns()\index
                  Break
                Else
                  \index[1] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \columns()\items()
                If \columns()\items()\drawing
                  If (MouseX>\x[#_c_2] And MouseX=<\x[#_c_2]+\width[#_c_2] And 
                      MouseY>\columns()\items()\y And MouseY=<\columns()\items()\y+\columns()\items()\height)
                    \columns()\index[1] = \columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          ElseIf ListSize(\items())
            
            ; items at point
            ForEach \items()
              If \items()\drawing
                If (MouseX>\items()\x And MouseX=<\items()\x+\items()\width And 
                    MouseY>\items()\y And MouseY=<\items()\y+\items()\height)
                  
                  \index[1] = \items()\index
                  ; Debug " i "+\index[1]+" "+ListIndex(\items())
                  Break
                Else
                  \index[1] =- 1
                EndIf
              EndIf
            Next
            
          EndIf
        EndIf
        
      EndWith
    EndIf
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure.i Event_Widgets(*this._S_widget, EventType.i, EventItem.i=-1, EventData.i=0)
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
        
        
        If *this And *this <> \root And \root\drag And DD::EventDrop(*this, EventType)
          
          Post(#PB_EventType_Drop, DD::*Drag\widget, \index[2], EventData)
        Else
          Post(EventType, *this, EventItem, EventData)
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*this._S_widget, at.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *this > 0
      
      ;       Root()\type = EventType
      ;       Root()\this = *this
      
      With *this
        Protected canvas = \root\canvas\gadget
        Protected window = \root\canvas\window
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1 : Repaint | Event_Widgets(*this, EventType, at, \deactive)
            
          Case #PB_EventType_LostFocus : Repaint = 1 : Repaint | Event_Widgets(*this, EventType, at)
            
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0  : Repaint | Event_Widgets(*this, EventType, at)
            ;             Debug "events() LeftButtonUp "+\type +" "+ at +" "+ *this
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                  Repaint = SetPos_Bar(*this, (MouseY-\thumb\len/2))
                Else
                  Repaint = SetPos_Bar(*this, (MouseX-\thumb\len/2))
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
                  Repaint | Event_Widgets(*this, EventType, \index[1])
                EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonDown : Repaint | Event_Widgets(*this, EventType, at)
            ;             Debug "events() LeftButtonDown "+\type +" "+ at +" "+ *this
            Select \type 
              Case #PB_GadgetType_Window
                If at = 1
                  Free(*this)
                  
                  If *this = \root
                    PostEvent(#PB_Event_CloseWindow, \root\canvas\window, *this)
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
                Repaint = Set_State(*this, \Items(), \index[1]) 
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\columns(), 0)
                  Repaint = Set_State(*this, \columns()\items(), \columns()\index[1]) 
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
                    If \index[1] >= 0
                      Repaint = SetState(*this, \index[1])
                    EndIf
                EndSelect
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin, #PB_GadgetType_Splitter
                Select at
                  Case 1 : Repaint = SetState(*this, (\page\pos - \scrollstep)) ; Up button
                  Case 2 : Repaint = SetState(*this, (\page\pos + \scrollstep)) ; Down button
                  Case 3                                                        ; Thumb button
                    If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                      delta = MouseY - \thumb\pos
                    Else
                      delta = MouseX - \thumb\pos
                    EndIf
                EndSelect
                
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
                Repaint = SetPos_Bar(*this, (MouseY-delta))
              Else
                Repaint = SetPos_Bar(*this, (MouseX-delta))
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
            ;             If Not Root()\mouse\buttons And IsGadget(canvas)
            ;               \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor)
            ;               ;             Debug "events() MouseEnter " +" "+ at +" "+ *this;+\type +" "+ \cursor[1]  +" "+ \cursor
            ;             EndIf
            
          Case #PB_EventType_MouseLeave
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
              \index[1] =- 1
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
                  \parent\index[1] =- 1
                  
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
        
        If \text And \text[1] And \text[2] And \text[3] And \text\Editable
          Select \type
            Case #PB_GadgetType_String
              Repaint | String_Editable(*this, EventType, MouseX.i, MouseY.i)
              
            Case #PB_GadgetType_Editor
              Repaint | Editor_Events(*this, EventType)
              
          EndSelect
        EndIf
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Macro _mouse_pos_(_this_)
    
    ; Enter/Leave events
    If *event\enter <> _this_
      If *event\enter<>Root()
        
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
          Event_Widgets(*event\enter, #PB_EventType_MouseLeave, *event\enter\from)
          Events(*event\enter, *event\enter\from, #PB_EventType_MouseLeave, MouseX, MouseY)
        EndIf
      EndIf
      
      If _this_
        If (Not *event\enter Or (*event\enter And *event\enter\parent <> _this_))
          ;             If Not *event\enter
          ;               Debug "enter first"
          ;             EndIf
          ;             
          ;             If (*event\enter And *event\enter\parent <> _this_)
          ;               Debug "leave parent"
          ;             EndIf
          
          If _this_\mouse\buttons
            ;               Debug "selected ower"
          Else
            Event_Widgets(_this_, #PB_EventType_MouseEnter, _this_\from)
            Events(_this_, _this_\from, #PB_EventType_MouseEnter, MouseX, MouseY)
          EndIf
        EndIf
        
        _this_\leave = *event\enter
        *event\enter = _this_
      Else
        Root()\leave = *event\enter
        *event\enter = Root()
      EndIf
    EndIf
    
  EndMacro
  
  Declare.b CallBack_Bar(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  Procedure.b _CallBack_Bar(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static LastX, LastY, Last, *thisis._S_widget, Cursor, Drag, Down
    
    With *this
      
      If \splitter And \from <> #_b_3
        If \splitter\first And Not \splitter\g_first
          If CallBack_Bar(\splitter\first, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack_Bar(\splitter\second, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If Not \hide And (Mousex>=\x And Mousex<\x+\width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If \button[#_b_3]\len And (MouseX>\button[#_b_3]\x And MouseX=<\button[#_b_3]\x+\button[#_b_3]\width And MouseY>\button[#_b_3]\y And MouseY=<\button[#_b_3]\y+\button[#_b_3]\height)
              from = #_b_3
            ElseIf \button[#_b_2]\len And (MouseX>\button[#_b_2]\x And MouseX=<\button[#_b_2]\x+\button[#_b_2]\width And MouseY>\button[#_b_2]\y And MouseY=<\button[#_b_2]\y+\button[#_b_2]\height)
              from = #_b_2
            ElseIf \button[#_b_1]\len And (MouseX>\button[#_b_1]\x And MouseX=<\button[#_b_1]\x+\button[#_b_1]\width And  MouseY>\button[#_b_1]\y And MouseY=<\button[#_b_1]\y+\button[#_b_1]\height)
              from = #_b_1
            Else
              from =- 1
            EndIf
            
            If \type = #PB_GadgetType_TrackBar
              Select from
                Case #_b_1, #_b_2
                  from =- 1
              EndSelect
              ; ElseIf \type = #PB_GadgetType_ProgressBar
              ;  from = 0
            EndIf
            
          Else
            from =- 1
          EndIf 
        EndIf 
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *thisis = *this
            Select WheelDelta
              Case-1 : Result = SetState(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*this, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *thisis = *this : EndIf
          
          Select from
            Case - 1
              If *thisis = *this
                If \Vertical
                  Result = SetPos_Bar(*this, (MouseY-\thumb\len/2))
                Else
                  Result = SetPos_Bar(*this, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 
              If \button[from]\len > 1 And \color[from]\state <> #Disabled
                If \inverted
                  Result = SetState_Bar(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
                Else
                  Result = SetState_Bar(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
                EndIf
              EndIf
            Case 2 
              If \button[from]\len > 1 And \color[from]\state <> #Disabled
                If \inverted
                  Result = SetState_Bar(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
                Else
                  Result = SetState_Bar(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
                EndIf
              EndIf
              
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            
            If *thisis = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = SetPos_Bar(*this, (MouseY-LastY))
              Else
                Result = SetPos_Bar(*this, (MouseX-LastX))
              EndIf
            EndIf
            
          Else
            If from
              If \from <> from
                If *thisis > 0 
                  CallBack(*thisis, #PB_EventType_MouseLeave, MouseX, MouseY) 
                EndIf
                
                If *thisis <> *this 
                  ;Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *thisis = *this
                EndIf
                
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *thisis = *this
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                ;Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *thisis = 0
              ;               Last = 0
            EndIf
            
          EndIf
          
      EndSelect
      
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \focus = 1 : Result = #True
        Case #PB_EventType_LostFocus : \focus = 0 : Result = #True
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_LeftButtonUp, 
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave
          Static cursor_change
          
          If from > 0 And \color[from]\state <> #Disabled
            If \button[from]\len > 1
              \color[from]\state = #Entered + Bool(EventType=#PB_EventType_LeftButtonDown)
              
              ; Post(EventType, *this)
            EndIf
            
            ; Set splitter cursor
            If from = #_b_3 And \type = #PB_GadgetType_Splitter
              cursor_change = 1
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \cursor)
            EndIf
            
          ElseIf Not Drag And Not from 
            If \color\state <> #Disabled : \color\state = #Normal : EndIf
            If \button[#_b_1]\len > 1 And \color[#_b_1]\state <> #Disabled : \color[#_b_1]\state = #Normal : EndIf
            If \button[#_b_2]\len > 1 And \color[#_b_2]\state <> #Disabled : \color[#_b_2]\state = #Normal : EndIf
            If \button[#_b_3]\len > 1 And \color[#_b_3]\state <> #Disabled : \color[#_b_3]\state = #Normal : EndIf
            
            ; Reset splitter cursor
            If cursor_change : cursor_change = 0
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
          EndIf
          
          Result = #True
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b CallBack_Bar(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static cursor_change, LastX, LastY, Last, *leave._S_widget, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave
          ; Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Normal 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          Result = #True
          
        Case #PB_EventType_MouseEnter
          ; Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          
          ; Set splitter cursor
          If _this_\from = #_b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          Result = #True
          
        Case #PB_EventType_LeftButtonDown
           ; Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          Select _this_\from
            Case 1 
              If _this_\inverted
                Result = SetState_Bar(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState_Bar(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 2 
              If _this_\inverted
                Result = SetState_Bar(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState_Bar(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 3 
              LastX = MouseX - _this_\thumb\pos 
              LastY = MouseY - _this_\thumb\pos
              
            Default
              Result = #True
              
          EndSelect
          
          _this_\color[_this_\from]\state = #Selected
          
        Case #PB_EventType_LeftButtonUp
          ; Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          Result = #True
          
      EndSelect
    EndMacro
    
    With *this
;       ; from the very beginning we'll process 
;       ; the splitter children’s widget
;       If \from <> #_b_3
;         If \splitter And \splitter\first And Not \splitter\g_first
;           If CallBack_Bar(\splitter\first, EventType, MouseX, MouseY)
;             ProcedureReturn 1
;           EndIf
;         EndIf
;         If \splitter And \splitter\second And Not \splitter\g_second
;           If CallBack_Bar(\splitter\second, EventType, MouseX, MouseY)
;             ProcedureReturn 1
;           EndIf
;         EndIf
;       EndIf
;            
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        If \from =- 1 Or (\from > 0 And MouseX>\button[\from ]\x And MouseX=<\button[\from ]\x+\button[\from ]\width And 
                          MouseY>\button[\from ]\y And MouseY=<\button[\from ]\y+\button[\from ]\height)
          from = \from 
        EndIf
      Else
        If Not \hide And (Mousex>=\x And Mousex<\x+\width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If \button[#_b_3]\len And (MouseX>\button[#_b_3]\x And MouseX=<\button[#_b_3]\x+\button[#_b_3]\width And 
                                       MouseY>\button[#_b_3]\y And MouseY=<\button[#_b_3]\y+\button[#_b_3]\height)
              from = #_b_3
            ElseIf \button[#_b_2]\len And (MouseX>\button[#_b_2]\x And MouseX=<\button[#_b_2]\x+\button[#_b_2]\width And 
                                           MouseY>\button[#_b_2]\y And MouseY=<\button[#_b_2]\y+\button[#_b_2]\height)
              from = #_b_2
            ElseIf \button[#_b_1]\len And (MouseX>\button[#_b_1]\x And MouseX=<\button[#_b_1]\x+\button[#_b_1]\width And 
                                           MouseY>\button[#_b_1]\y And MouseY=<\button[#_b_1]\y+\button[#_b_1]\height)
              from = #_b_1
            ElseIf (MouseX>\button\x And MouseX=<\button\x+\button\width And 
                    MouseY>\button\y And MouseY=<\button\y+\button\height)
              from =- 1
            EndIf
            
            If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
              Select from
                Case #_b_1, #_b_2
                  from =- 1
                  
              EndSelect
              ; ElseIf \type = #PB_GadgetType_ProgressBar
              ;  from = 0
            EndIf
            
          Else
            from =- 1
          EndIf 
        Else
          If \from > 0 And \button[\from]\interact
            If EventType = #PB_EventType_LeftButtonUp
              _callback_(*this, #PB_EventType_LeftButtonUp)
            EndIf
            
           ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
            _callback_(*this, #PB_EventType_MouseLeave)
          EndIf 
          
          \from = 0
        EndIf 
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *leave = *this
            Select WheelDelta
              Case-1 : Result = SetState_Bar(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState_Bar(*this, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp 
          Down = 0 : LastX = 0 : LastY = 0
          
          If \from > 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If Not from > 0
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from = 0
            EndIf
          EndIf
        
        Case #PB_EventType_LeftButtonDown
          If from =- 1 And \button[#_b_3]\interact 
            If \Vertical
              Result = SetPos_Bar(*this, (MouseY-\thumb\len/2))
            Else
              Result = SetPos_Bar(*this, (MouseX-\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from > 0 And \button[from]\interact
            Down = 1
            \from = from 
            *leave = *this
            
            _callback_(*this, #PB_EventType_LeftButtonDown)
          EndIf
          
          ; Чтобы не пропускать событие
          ; внутри детей сплиттера
          If \from ; > 0 And \button[\from]\interact 
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down
            
            If *leave = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = SetPos_Bar(*this, (MouseY-LastY))
              Else
                Result = SetPos_Bar(*this, (MouseX-LastX))
              EndIf
            EndIf
            
          Else
            If from
              If \from <> from
                If *leave > 0 And *leave\from > 0
                  If Not (MouseX>*leave\button[*leave\from]\x And MouseX=<*leave\button[*leave\from]\x+*leave\button[*leave\from]\width And 
                          MouseY>*leave\button[*leave\from]\y And MouseY=<*leave\button[*leave\from]\y+*leave\button[*leave\from]\height)
                    
                    ; set mouse leave from item
                    If *leave\button[*leave\from]\interact
                      _callback_(*leave, #PB_EventType_MouseLeave)
                      *leave\from = 0
                    EndIf
                  Else
                    *leave\from = 0 
                    *leave = 0
                  EndIf
                EndIf
                
                \from = from
                
                If \from > 0 And \button[\from]\interact
                  ; 10>>20>>30 
;                   If (*leave And *leave\from =- 1)
; ;                     If *leave
; ;                       Debug ""+#PB_Compiler_Line +" "+ *this +" "+ *leave +" "+ *this\from +" "+ *leave\from
; ;                     Else
; ;                       Debug ""+#PB_Compiler_Line +" "+ *this +" "+ *leave +" "+ *this\from
; ;                     EndIf
;                     _callback_(*this, #PB_EventType_MouseEnter)
;                    ; *leave\from = 0
;                    ; ProcedureReturn
;                   EndIf
;                   
;                   If Not (*leave And *leave\from =- 1)
                    _callback_(*this, #PB_EventType_MouseEnter)
;                   EndIf
                EndIf
                
                If *leave <> *this 
                  
                  *leave = *this
                EndIf
              EndIf
              
            ElseIf *leave = *this
              If \from > 0 And \button[\from]\interact
               ; Debug ""+#PB_Compiler_Line +" Мышь перешел с итем"
               _callback_(*this, #PB_EventType_MouseLeave)
              EndIf 
              
               ; Debug ""+#PB_Compiler_Line +" Мышь находится снаружи"
              \from = 0
              *leave = 0
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CallBack(*this._S_widget, EventType.i, MouseX.i=0, MouseY.i=0)
    Protected repaint.i, Parent.i, Window.i, Canvas = EventGadget()
    ;Static lastat.i, Down.i, *Lastat._S_widget, *Last._S_widget, *mouseat._S_widget
    
    ; ProcedureReturn Editor_CallBack(*this, EventType.i)
    
    With *this
      If Not Bool(*this And *this\root)
        ProcedureReturn
      EndIf
      
      Window = \window 
      Parent = \parent 
      Canvas = \root\canvas\gadget
      
      If Not MouseX
        MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      EndIf
      If Not MouseY
        MouseY= GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
      EndIf
      
;       If \scroll And \scroll\v\from
;         *this = \scroll\v
;       EndIf
;       If \scroll And \scroll\h\from
;         *this = \scroll\h
;       EndIf
      
      ; anchors events
      If CallBack_Anchors(*this, EventType, \mouse\buttons, MouseX,MouseY)
        ProcedureReturn 1
      EndIf
      
      ; Enter/Leave mouse events
      _mouse_pos_(*this)
      
      ; bars events
      If CallBack_Bar(*this, EventType, MouseX,MouseY) Or *this\from
        ProcedureReturn 1
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
                Event_Widgets(*this, #PB_EventType_DragStart, \index[2])
              EndIf
            EndIf
            
            If Root()\active\_gadget 
              ;repaint | Event_Widgets(Root()\active\_gadget, #PB_EventType_MouseMove, Root()\active\_gadget\from)
              repaint | Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_MouseMove, MouseX, MouseY)
            EndIf  
            
          ElseIf *this And *this = *event\enter
            ;repaint | Event_Widgets(*this, #PB_EventType_MouseMove, \from)
            repaint | Events(*this, \from, #PB_EventType_MouseMove, MouseX, MouseY)
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
              \mouse\delta\x = Root()\mouse\x-\x[#_c_3]
              \mouse\delta\y = Root()\mouse\y-\y[#_c_3]
              \mouse\buttons = Root()\mouse\buttons
              
              \state = 2 
              SetForeground(*this)
              
              If \deactive
                If \deactive <> *this
                  repaint | Events(\deactive, \deactive\from, #PB_EventType_LostFocus, MouseX, MouseY)
                EndIf
                
                repaint | Events(*this, \from, #PB_EventType_Focus, MouseX, MouseY)
                \deactive = 0
              EndIf
              
              repaint | Events(*this, \from, EventType, MouseX, MouseY)
              repaint = 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp,
             #PB_EventType_RightButtonUp 
          
          If EventType <> #PB_EventType_MiddleButtonDown
            If Root()\active\_gadget And
               Root()\active\_gadget\state = 2 
              Root()\active\_gadget\state = 1 
              
              repaint | Events(Root()\active\_gadget, Root()\active\_gadget\from, EventType, MouseX, MouseY)
              
              If Bool(MouseX>=Root()\active\_gadget\x[#_c_4] And MouseX<Root()\active\_gadget\x[#_c_4]+Root()\active\_gadget\width[#_c_4] And 
                      MouseY>Root()\active\_gadget\y[#_c_4] And MouseY=<Root()\active\_gadget\y[#_c_4]+Root()\active\_gadget\height[#_c_4]) 
                
                If Root()\active\_gadget = *this       
                  If EventType = #PB_EventType_LeftButtonUp
                    ;  repaint | Event_Widgets(Root()\active\_gadget, #PB_EventType_LeftClick, Root()\active\_gadget\from)
                    repaint | Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_LeftClick, MouseX, MouseY)
                  EndIf
                  If EventType = #PB_EventType_RightClick
                    ;  repaint | Event_Widgets(Root()\active\_gadget, #PB_EventType_RightClick, Root()\active\_gadget\from)
                    repaint | Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_RightClick, MouseX, MouseY)
                  EndIf
                EndIf
                
              Else
                Root()\active\_gadget\state = 0
                ;repaint | Event_Widgets(Root()\active\_gadget, #PB_EventType_MouseLeave, Root()\active\_gadget\from)
                repaint | Events(Root()\active\_gadget, Root()\active\_gadget\from, #PB_EventType_MouseLeave, MouseX, MouseY)
              EndIf
              
              Root()\active\_gadget\mouse\buttons = 0   
              If Root()\active\_gadget\mouse\delta
                FreeStructure(Root()\active\_gadget\mouse\delta)
                Root()\active\_gadget\mouse\delta = 0
                Root()\active\_gadget\drag = 0
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
          
          If *this And (Root()\active\_gadget = *this Or *this = Root()\active)
            
            \Keyboard\Input = GetGadgetAttribute(Canvas, #PB_Canvas_Input)
            \Keyboard\Key = GetGadgetAttribute(Canvas, #PB_Canvas_Key)
            \Keyboard\Key[1] = GetGadgetAttribute(Canvas, #PB_Canvas_Modifiers)
            
            repaint | Events(*this, 0, EventType, MouseX, MouseY)
          EndIf
          
      EndSelect
      
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *this._S_widget
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *root._S_widget = GetGadgetData(Canvas)
    
    Select EventType
        ;       Case #PB_EventType_Repaint ;: Repaint = 1
        ;         MouseX = 0
        ;         MouseY = 0
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Resize(*root, #PB_Ignore, #PB_Ignore, Width, Height)  
        Repaint = 1
        
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        Repaint | CallBack(From(*root, MouseX, MouseY), EventType, MouseX, MouseY)
    EndSelect
    
    If Repaint 
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
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
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
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
      Static Last_X, Last_Y
      If Last_Y <> Mousey
        Last_Y = Mousey
        Result | Canvas_Events(EventGadget, EventType)
      EndIf
      If Last_x <> Mousex
        Last_x = Mousex
        Result | Canvas_Events(EventGadget, EventType)
      EndIf
    Else
      Result | Canvas_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure Widgets_Gadget_Events()
    Protected EventWidget.i, EventType.i, EventItem.i, EventData.i
    
    EventWidget = Widget()
    EventType = Type()
    EventItem = Item()
    EventData = Data()
    
    If EventType <> #PB_EventType_MouseMove
      Debug " gadget "+ EventType
    EndIf
   
    Select EventType 
      Case #PB_EventType_LeftButtonDown
        Protected *This._S_widget
     
        *This = GetAnchors(EventWidget)
        If *This   
          If SetAnchors(*This)
            Debug "изменено down"+ *This
           ; Unbind(@Widgets_Gadget_Events(), *This)
           ; Debug DropText()
          EndIf
        EndIf
        
    EndSelect
    
    ; Отключает передачу сообщений в 
    ; оконную и рутовскую процедуру
    ProcedureReturn #PB_Ignore
  EndProcedure
  
  Procedure Widgets_Window_Events()
    Protected EventWidget.i, EventType.i, EventItem.i, EventData.i
    
    EventWidget = Widget()
    EventType = Type()
    EventItem = Item()
    EventData = Data()
    
    If EventType <> #PB_EventType_MouseMove
      Debug " window "+ EventType
    EndIf
  EndProcedure
  
  Procedure Widgets_Root_Events()
    Protected EventWidget.i, EventType.i, EventItem.i, EventData.i
    
    EventWidget = Widget()
    EventType = Type()
    EventItem = Item()
    EventData = Data()
    
    If EventType <> #PB_EventType_MouseMove
      Debug " root "+ EventType
    EndIf
  EndProcedure
  
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      Define Editable ; = #PB_Flag_AnchorsGadget
      
      If Open(0, 10,10, 580, 550," root ")
        *win=Form(80, 100, 400, 360, "Window_2", Editable)
        
        Container(30,30,400-60, 360-60, Editable)
        Container(20,20,400-60, 360-60, Editable)
        *but=Button(100, 20, 80, 80, "Button_1", Editable)
        
        Tree(130, 80, 180, 180, Editable|#PB_Flag_Checkboxes|#PB_Tree_ThreeState)
        
        Define i
        For i=0 To 20
          AddItem(Widget(), i, "item_"+ Str(i))
        Next
        
        Define *progress = Progress(30, 80, 80+40, 80, 30, 60, Editable)
        Define *track = Track(30, 170, 80+40, 30, 30, 60, Editable)
        Define *splitter = Splitter(10, 80, 130, 150, *progress, *track, #PB_Splitter_Separator)
        SetState(*progress, 50)
        SetState(*track, 50)
        
        CloseList()
        CloseList()
        
        
        Bind(@Widgets_Gadget_Events(), *but)
        Bind(@Widgets_Window_Events(), *win)
        Bind(@Widgets_Root_Events())
        ReDraw(Root())
      EndIf
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
        ;       Case #PB_Event_Gadget;Widget
        ;         Debug ""+gettext(EventWidget()) +" "+ WidgetEvent() ;+" "+ Root()\this +" "+ Root()\type
        ;         
        ;         Select EventWidget()
        ;           Case *but
        ;             
        ;             Debug *but
        ;             
        ;         EndSelect
        ;         
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = +---------LIAF3-HYxYEAg8+PAbbwPAA505TAAE5PAAA+BAAAAJIBBAAghAwAAAAAAgBAAAABBAAAAA5Z--+0DAAAAAAAAAAAQAKAAQAe0OgOAAAAAAAAAAAADg5hP1BgAAAQwfUGQQ+AAAAAAAA97jA-PAPGBDAHfM5iYAAAAg6OAAYE+--3DAAByvBA-z-fE1AAAAAP+HAAc5--B--6ffw----Gv--P+BB+-zDPAAAO------4-----+6-4MAIA9-
; EnableXP