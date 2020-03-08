; 23 ??? 2019
; Window() > Form()
; RootGadget() > _gadget()
; RootWindow() > _window()

; ; CompilerIf #PB_Compiler_OS = #PB_OS_macOS
; ;     ; Addition of mk-soft
; ;   Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
; ;     Define.i R1, G1, B1, R2, G2, B2
; ;     Define.f Blend = Scale / 100
; ;     
; ;     R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
; ;     R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
; ;     
; ;     ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
; ;   EndProcedure
; ;   
; ;   CompilerSelect #PB_Compiler_OS ;{ Color
; ;           CompilerCase #PB_OS_Windows
; ;             StrgEx()\Color\Front         = GetSysColor_(#COLOR_WINDOWTEXT)
; ;             StrgEx()\Color\Back          = GetSysColor_(#COLOR_WINDOW)
; ;             StrgEx()\Color\Focus         = GetSysColor_(#COLOR_HIGHLIGHT)
; ;             StrgEx()\Color\Gadget        = GetSysColor_(#COLOR_mENU)
; ;             StrgEx()\Color\Button        = GetSysColor_(#COLOR_3DLIGHT)
; ;             StrgEx()\Color\Border        = GetSysColor_(#COLOR_WINDOWFRAME)
; ;             StrgEx()\Color\WordColor     = GetSysColor_(#COLOR_HOTLIGHT)
; ;             StrgEx()\Color\Highlight     = GetSysColor_(#COLOR_HIGHLIGHT)
; ;             StrgEx()\Color\HighlightText = GetSysColor_(#COLOR_HIGHLIGHTTEXT)
; ;           CompilerCase #PB_OS_macOS
; ;             StrgEx()\Color\Front         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
; ;             StrgEx()\Color\Back          = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
; ;             StrgEx()\Color\Focus         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor keyboardFocusIndicatorColor"))
; ;             StrgEx()\Color\Gadget        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
; ;             StrgEx()\Color\Button        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
; ;             StrgEx()\Color\Border        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
; ;             StrgEx()\Color\Highlight     = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextBackgroundColor"))
; ;             StrgEx()\Color\HighlightText = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextColor"))
; ;           CompilerCase #PB_OS_Linux
; ; 
; ;         CompilerEndSelect ;}        

;
;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
;
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "fixme(mac).pbi"
CompilerEndIf

;-
;- XIncludeFile
;-
CompilerIf Not Defined(macros, #PB_Module)
  XIncludeFile "macros.pbi"
CompilerEndIf

CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "colors.pbi"
CompilerEndIf


;- <<<
CompilerIf Not Defined(DD, #PB_Module)
  DeclareModule DD
    EnableExplicit
    UseModule constants
    
    ;- - _s_drop
    Structure _s_drop
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
    
    Global *Drag._s_drop
    Global NewMap *Drop._s_drop()
    
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
    
    Macro DragFiles(_files_, _actions_=#PB_Drag_Copy)
      DD::Files(_files_, _actions_)
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
    Declare.s DropFiles()
    Declare.i DropAction()
    Declare.i DropImage(Image.i=-1, Depth.i=24)
    
    Declare.i Files(Files.S, Actions.i=#PB_Drag_Copy)
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
        ;PB_Object_getObject( PB_Object , DynamicOrArrayID)
        PB_Window_Objects.i
        PB_Gadget_Objects.i
        PB_Image_Objects.i
        ;PB_font_Objects.i
      EndImport
    CompilerElse
      ImportC ""
        PB_Object_EnumerateStart( PB_Objects )
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
        ;PB_Object_getObject( PB_Object , DynamicOrArrayID)
        PB_Window_Objects.i
        PB_Gadget_Objects.i
        PB_Image_Objects.i
        ;PB_font_Objects.i
      EndImport
    CompilerEndIf
    
    ;   CompilerIf #PB_compiler_OS = #PB_OS_macOS
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
      ; #PB_drop_text    : Accept text on this gadget
      ; #PB_drop_image   : Accept images on this gadget
      ; #PB_drop_files   : Accept filenames on this gadget
      ; #PB_drop_private : Accept a "private" Drag & Drop on this gadgetProtected Result.i
      
      ; Actions
      ; #PB_drag_none    : The Data format will Not be accepted on the gadget
      ; #PB_drag_copy    : The Data can be copied
      ; #PB_drag_move    : The Data can be moved
      ; #PB_drag_link    : The Data can be linked
      
      If AddMapElement(*Drop(), Hex(*this))
        Debug "Enable drop - " + *this
        *Drop() = AllocateStructure(_s_drop)
        *Drop()\format = Format
        *Drop()\actions = Actions
        *Drop()\type = PrivateType
        *Drop()\widget = *this
      EndIf
      
    EndProcedure
    
    Procedure.i Text(Text.s, Actions.i=#PB_Drag_Copy)
      Debug "Drag text - " + Text
      *Drag = AllocateStructure(_s_drop)
      *Drag\format = #PB_Drop_Text
      *Drag\actions = Actions
      *Drag\text = Text
      Cur(0)
    EndProcedure
    
    Procedure.i Image(Image.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag image - " + Image
      *Drag = AllocateStructure(_s_drop)
      *Drag\format = #PB_Drop_Image
      *Drag\ImageID = ImageID(Image)
      *Drag\width = ImageWidth(Image)
      *Drag\height = ImageHeight(Image)
      *Drag\actions = Actions
      Cur(0)
    EndProcedure
    
    Procedure.i Private(Type.i, Actions.i=#PB_Drag_Copy)
      Debug "Drag private - " + Type
      *Drag = AllocateStructure(_s_drop)
      *Drag\format = #PB_Drop_Private
      *Drag\actions = Actions
      *Drag\type = Type
      Cur(0)
    EndProcedure
    
    Procedure.i Files(Files.s, Actions.i=#PB_Drag_Copy)
      Debug "Drag Files - " + Files
      *Drag = AllocateStructure(_s_drop)
      *Drag\format = #PB_Drop_Files
      *Drag\actions = Actions
      *Drag\Text = Files
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
    
    Procedure.s DropFiles()
      Protected result.s
      
      If _action_(*Drag\widget)
        Debug "  Drop files - "+*Drag\text
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
          Case #__Event_MouseEnter
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
            
          Case #__Event_MouseLeave
            If *Drag And Not *Drag\cursor
              *Drop()\cursor = 0
              *Drag\widget = 0
              Cur(0)
            EndIf
            
          Case #__Event_LeftButtonUp
            
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
  UseModule constants
  
  
  Structure _s_root Extends structures::_s_root : EndStructure
  Structure _s_widget Extends structures::_s_widget : EndStructure
  Structure _s_event Extends structures::_s_event : EndStructure
  Structure _s_scroll Extends structures::_s_scroll : EndStructure
  
  Global *event.structures::_s_event = structures::*event
  Global *row_selected.structures::_s_rows
  
  Structure _struct_
    widget._s_widget 
    event._s_event
  EndStructure
  
  
  ;-
  ;- - DECLAREs GLOBALs
  Macro _get_colors_()
    colors::*this\grey
  EndMacro
  
  
  ;-
  ;- - DECLAREs MACROs
  ;Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    structures::*event\root
  EndMacro
  
  Macro Widget()
    structures::*event\widget
  EndMacro
  
  Macro Type()
    structures::*event\type
  EndMacro
  
  Macro Data()
    structures::*event\data
  EndMacro
  
  Macro Item()
    structures::*event\item
  EndMacro
  
  Macro GetActive() ; Returns active window
    structures::*event\active
  EndMacro
  
  Macro GetAdress(_this_)
    _this_\adress
  EndMacro
  
  Macro _is_widget_(_this_)
    Bool(_this_ And _this_\adress) * _this_
  EndMacro
  
  Macro _is_root_(_this_)
    Bool(_this_ And _this_ = _this_\root) * _this_
  EndMacro
  
  Macro repaint()
    If widget()\root\repaint
      redraw(widget()\root)
    EndIf
  EndMacro
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro selectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText()
  EndMacro
  
  Macro DropFiles()
    DD::DropFiles()
  EndMacro
  
  Macro DropAction()
    DD::DropAction()
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(_image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(_text_, _actions_)
  EndMacro
  
  Macro DragFiles(_files_, _actions_=#PB_Drag_Copy)
    DD::Files(_files_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(_image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(_type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  Macro SetAnchors(_this_)
    a_Set(_this_)
  EndMacro
  Macro GetAnchors(_this_)
    a_get(_this_)
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
  Declare.i GetCount(*this)
  Declare.s GetClass(*this)
  
  Declare.i GetItemState(*this, Item.i)
  Declare.i SetItemState(*this, Item.i, State.i)
  Declare.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
  Declare.i SetItemData(*this, Item.i, *Data)
  Declare.i SetItemAttribute(*this, Item.i, Attribute.i, Value.i)
  Declare.i SetItemImage(*this, Item.i, Image.i)
  Declare.i SetItemText(*this, Item.i, Text.s)
  Declare.i SetItemFont(*this, Item.l, Font.i)
  
  Declare.i SetTransparency(*this, Transparency.a)
  Declare.s SetClass(*this, Class.s)
  Declare.i SetActive(*this)
  Declare.i SetState(*this, State.i)
  Declare.i SetAttribute(*this, Attribute.i, Value.i)
  Declare.i Events(*this, eventtype.i, mouse_x=0, mouse_y=0)
  Declare.i SetColor(*this, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i SetImage(*this, Image.i)
  Declare.i SetData(*this, *Data)
  Declare.i SetText(*this, Text.s)
  Declare.i SetPosition(*this, Position.i, *Widget_2 =- 1)
  Declare.i SetParent(*this, *parent, parent_item.l=0)
  Declare.i SetAlignment(*this, Mode.i, Type.i=1)
  Declare.i SetFlag(*this, Flag.i)
  
  Declare.i AddItem(*this, Item.i, Text.s, Image.i=-1, Flag.i=0)
  Declare.i AddColumn(*this, Position.i, Title.s, Width.i)
  Declare.i Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
  
  Declare.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
  Declare.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
  Declare.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Property(X.l,Y.l,Width.l,Height.l, SplitterPos.i = 80, Flag.i=0)
  Declare.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, round.l=0)
  Declare.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
  Declare.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  Declare.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
  Declare.i IPAddress(X.l,Y.l,Width.l,Height.l)
  Declare.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  
  ; container
  Declare.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, scroll_step.l=1, Flag.i=0)
  Declare.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Panel(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  Declare.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent=0)
  Declare.i Free(*this)
  Declare.i Popup(*widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
  
  Declare.i CallBack()
  Declare.i CloseList()
  Declare.i OpenList(*this, item.l=0)
  Declare.i Bind(*callback, *this=#PB_All, eventtype.l=#PB_All)
  Declare.i Post(eventtype.l, *this, eventitem.l=#PB_All, *data=0)
  Declare.i Open(Window.i, X.l=#PB_Ignore,Y.l=#PB_Ignore,Width.l=#PB_Ignore,Height.l=#PB_Ignore, Text.s="", Flag.i=0, WindowID.i=0)
  
  Declare.i From(*this, mouse_x.l, mouse_y.l)
  Declare.i Create(Type.i, X.l,Y.l,Width.l,Height.l, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, parent_item.i=0)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  Declare.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
  
  Declare.i a_Set(*this)
  Declare.i a_get(*this, index.i=-1)
  Declare.i a_add(*this._s_widget, Size.l=6, Pos.l=-1)
  Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    _this_\type = _type_
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    Widget::SetParent(_this_, _parent_, _parent_\tab\opened)
    
    ; _set_auto_size_
    If Bool(_flag_ & #__flag_autoSize=#__flag_autoSize) : x=0 : y=0
      _this_\align = AllocateStructure(structures::_s_align)
      _this_\align\autoSize = 1
      _this_\align\left = 1
      _this_\align\top = 1
      _this_\align\right = 1
      _this_\align\bottom = 1
    EndIf
    
    If Bool(_flag_ & #__flag_anchorsGadget=#__flag_anchorsGadget)
      
      Widget::a_add(_this_)
      Widget::a_Set(_this_)
      
    EndIf
    
  EndMacro
  
  
EndDeclareModule


;-
;- XIncludeFile
;-
CompilerIf Not Defined(Bar, #PB_Module)
  ;   XIncludeFile "widgets()/bar.pbi"
  
  ; XIncludeFile "widgets()/bar().pb"
  XIncludeFile "widgets()/bar().pbi"
CompilerEndIf

CompilerIf Not Defined(Splitter, #PB_Module)
  XIncludeFile "widgets()/splitter().pbi"
CompilerEndIf

CompilerIf Not Defined(Editor, #PB_Module)
  XIncludeFile "widgets()/string().pbi"
CompilerEndIf


Module Widget
  CompilerIf Defined(fixme, #PB_Module)
    UseModule fixme
  CompilerEndIf
  ;
  ;- MODULE
  ;
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
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
      ;_this_\row\sublevel = _this_\image\_padding + _item_\image\width
    Else
      _item_\image\index =- 1
      _item_\image\handle = 0
      _item_\image\width = 0
      _item_\image\height = 0
      ;_this_\row\sublevel = 0
    EndIf
  EndMacro
  
  Macro _set_repaint_(_this_)
    If _this_\root And 
       _this_\root\repaint = #False
      _this_\root\repaint = #True
    EndIf
  EndMacro
  
  ;-
  Macro set_cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_cursor(_this_)
    GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor)
  EndMacro
  
  ;-
  Macro _draw_box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _round_=2, _alpha_=255) 
    
    If _type_ = 1
      If _checked_
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        RoundBox(_x_,_y_,_width_,_height_, 4,4, $F67905&$FFFFFF|255<<24)
        RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
        RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
        
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        BackColor($FFB775&$FFFFFF|255<<24) 
        FrontColor($F67905&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
        RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
      Else
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        RoundBox(_x_,_y_,_width_,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
        RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
        RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
        
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        BackColor($FFFFFF&$FFFFFF|255<<24)
        FrontColor($EEEEEE&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
        RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
      EndIf
    Else
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      
      If _checked_
        BackColor($FFB775&$FFFFFF|255<<24) 
        FrontColor($F67905&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $F67905&$FFFFFF|255<<24)
        
        If _type_ = 1
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        EndIf
        
      Else
        BackColor($FFFFFF&$FFFFFF|255<<24)
        FrontColor($EEEEEE&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $7E7E7E&$FFFFFF|255<<24)
        
        If _type_ = 1
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        EndIf
      EndIf
    EndIf
    
    If _checked_
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      
      If _type_ = 1
        RoundBox(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, 4,4,_color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
                                                                                             ; RoundBox(_x_+(_width_-8)/2,_y_+(_height_-8)/2, 8,8, 4,4,_color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
      ElseIf _type_ = 3
        If _checked_ > 1
          Box(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, _color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
        Else
          If _width_ = 15
            LineXY((_x_+4),(_y_+8),(_x_+5),(_y_+9),_color_&$FFFFFF|_alpha_<<24) ; ????? ?????
            LineXY((_x_+4),(_y_+9),(_x_+5),(_y_+10),_color_&$FFFFFF|_alpha_<<24); ????? ?????
            
            LineXY((_x_+9),(_y_+4),(_x_+6),(_y_+10),_color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
            LineXY((_x_+10),(_y_+4),(_x_+7),(_y_+10),_color_&$FFFFFF|_alpha_<<24); ?????? ?????
            
          Else
            LineXY((_x_+2),(_y_+6),(_x_+4),(_y_+7),_color_&$FFFFFF|_alpha_<<24) ; ????? ?????
            LineXY((_x_+2),(_y_+7),(_x_+4),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; ????? ?????
            
            LineXY((_x_+8),(_y_+2),(_x_+5),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
            LineXY((_x_+9),(_y_+2),(_x_+6),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; ?????? ?????
          EndIf
        EndIf
      EndIf
    EndIf
    
  EndMacro
  
  Macro _set_item_image_(_this_, _item_, _image_)
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
      _this_\row\sublevel = _this_\image\_padding + _item_\image\width
    Else
      _item_\image\index =- 1
    EndIf
  EndMacro
  
  Macro _tree_set_state_(_this_, _items_, _state_)
    If _this_\flag\option_group And _items_\parent
      If _items_\option_group\option_group <> _items_
        If _items_\option_group\option_group
          _items_\option_group\option_group\box[1]\checked = 0
        EndIf
        _items_\option_group\option_group = _items_
      EndIf
      
      _items_\box[1]\checked ! Bool(_state_)
      
    Else
      If _this_\flag\threestate
        If _state_ & #PB_Tree_Inbetween
          _items_\box[1]\checked = 2
        ElseIf _state_ & #PB_Tree_Checked
          _items_\box[1]\checked = 1
        Else
          Select _items_\box[1]\checked 
            Case 0
              _items_\box[1]\checked = 2
            Case 1
              _items_\box[1]\checked = 0
            Case 2
              _items_\box[1]\checked = 1
          EndSelect
        EndIf
      Else
        _items_\box[1]\checked ! Bool(_state_)
      EndIf
    EndIf
  EndMacro
  
  Macro _tree_bar_update_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\y-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_-_this_\y))) Or
         Bool((_pos_-_this_\y-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              Bar_SetState(_this_, (_pos_-_this_\y) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  Macro _tree_items_repaint_(_this_)
    If _this_\count\items = 0 Or 
       (Not _this_\hide And _this_\row\count And 
        (_this_\count\items % _this_\row\count) = 0)
      
      _this_\change = 1
      _this_\row\count = _this_\count\items
      PostEvent(#PB_Event_Gadget, _this_\root\window, _this_\root\gadget, #__Event_repaint, _this_)
    EndIf  
  EndMacro
  
  Macro _tree_items_multi_select_(_this_,  _index_, _selected_index_)
    PushListPosition(_this_\row\_s()) 
    ForEach _this_\row\_s()
      If _this_\row\_s()\draw
        _this_\row\_s()\color\state =  Bool((_selected_index_ >= _this_\row\_s()\index And _index_ =< _this_\row\_s()\index) Or ; ????
                                            (_selected_index_ =< _this_\row\_s()\index And _index_ >= _this_\row\_s()\index)) * 2  ; ????
      EndIf
    Next
    PopListPosition(_this_\row\_s()) 
    
    ;     PushListPosition(_this_\row\draws()) 
    ;     ForEach _this_\row\draws()
    ;       If _this_\row\draws()\draw
    ;         _this_\row\draws()\color\state =  Bool((_selected_index_ >= _this_\row\draws()\index And _index_ =< _this_\row\draws()\index) Or ; ????
    ;                                            (_selected_index_ =< _this_\row\draws()\index And _index_ >= _this_\row\draws()\index)) * 2  ; ????
    ;       EndIf
    ;     Next
    ;     PopListPosition(_this_\row\draws()) 
  EndMacro
  
  ;-
  ; SCROLLBAR
  Macro _move_childrens_(_this_, _change_x_, _change_y_)
    bar::_move_childrens_(_this_, _change_x_, _change_y_)
  EndMacro
  
  Macro _bar_splitter_size_(_this_)
    bar::_splitter_size_(_this_)
  EndMacro
  
  Macro _bar_thumb_pos_(_bar_, _scroll_pos_)
    bar::_thumb_pos_(_bar_, _scroll_pos_)
  EndMacro
  
  Macro _bar_thumb_len_(_bar_)
    bar::_get_thumb_len_(_bar_)
  EndMacro
  
  ; Then scroll bar start position
  Macro _bar_in_start_(_bar_) 
    bar::_in_start_(_bar_) 
  EndMacro
  
  ; Then scroll bar end position
  Macro _bar_in_stop_(_bar_) 
    bar::_in_stop_(_bar_) 
  EndMacro
  
  ; Inverted scroll bar position
  Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_=#True)
    bar::_invert_(_bar_, _scroll_pos_, _inverted_)
  EndMacro
  
  Macro _bar_scrolled_(_this_, _pos_, _len_)
    bar::_scrolled_(_this_, _pos_, _len_)
  EndMacro
  
  Macro _bar_area_pos_(_this_)
    bar::_area_pos_(_this_)
  EndMacro
  
;   Macro _bar_ThumbPos(_this_, _scroll_pos_)
;     bar::ThumbPos(_this_, _scroll_pos_)
;   EndMacro
  
  Procedure.b Bar_Draw(*this._s_widget)
    ProcedureReturn bar::Draw(*this)
  EndProcedure
  
  Procedure.i Bar_Change(*bar.structures::_s_bar, ScrollPos.f)
    ProcedureReturn bar::Change(*bar, ScrollPos)
  EndProcedure
  
  Procedure.b Bar_Update(*this._s_widget)
    ProcedureReturn bar::update(*this)
  EndProcedure
  
  Procedure.i Bar_SetPos(*this._s_widget, ThumbPos.i)
    ProcedureReturn bar::setpos(*this, ThumbPos)
  EndProcedure
  
  Procedure.b Bar_SetState(*this._s_widget, ScrollPos.f)
    ProcedureReturn bar::setstate(*this, ScrollPos)
  EndProcedure
  
  Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, Value.l)
    ProcedureReturn bar::setattribute(*this, Attribute, Value)
  EndProcedure
  
  Procedure.b Bar_Resizes(*scroll.structures::_s_scroll, X.l,Y.l,Width.l,Height.l )
    bar::resizes(*scroll, X,Y,Width,Height) 
  EndProcedure
  
  Procedure.i bar_create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scroll_step.f=1.0)
    ProcedureReturn bar::create(type, parent, 0,0,0,0, min, max, pagelength, size, flag, round, scroll_step)
  EndProcedure
  
  
  
  
  ;-
  Procedure.l tree_SetState(*this._s_widget, State.l)
    Protected *Result
    
    With *this
      If State >= 0 And State < \count\items
        *Result = SelectElement(\row\_s(), State) 
      EndIf
      
      If \row\selected <> *Result
        If \row\selected
          \row\selected\color\state = 0
        EndIf
        
        \row\selected = *Result
        
        If \row\selected
          \row\selected\color\state = 2
          \row\scrolled = 1
        EndIf
        
        _tree_items_repaint_(*this)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i tree_SetAttribute(*this._s_widget, Attribute.i, Value.l)
    Protected Result.i =- 1
    
    Select Attribute
      Case #__tree_collapse
        *this\flag\collapse = Bool(Not Value) 
        
      Case #__tree_optionboxes
        *this\flag\option_group = Bool(Value)*12
        *this\flag\checkBoxes = *this\flag\option_group
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l tree_SetText(*this._s_widget, Text.s)
    Protected Result.l
    
    If *this\row\selected 
      *this\row\selected\text\string = Text
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i tree_SetFont(*this._s_widget, Font.i)
    Protected Result.i, FontID.i = FontID(Font)
    
    With *this
      If \text\fontID <> FontID 
        \text\fontID = FontID
        \text\change = 1
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l tree_SetItemState(*this._s_widget, Item.l, State.b)
    Protected Result.l, Repaint.b, collapsed.b
    
    ;If (*this\flag\multiselect Or *this\flag\clickselect)
    If Item < 0 Or Item > *this\count\items - 1 
      ProcedureReturn 0
    EndIf
    
    Result = SelectElement(*this\row\_s(), Item) 
    
    If Result 
      If State & #PB_Tree_Selected
        If *this\row\selected <> *this\row\_s()
          If *this\row\selected
            *this\row\selected\color\state = 0
          EndIf
          
          *this\row\selected = *this\row\_s()
          *this\row\selected\color\state = 2 + Bool(GetActive()<>*this)
          Repaint = 1
        Else
          State &~ #PB_Tree_Selected
        EndIf
      EndIf
      
      If State & #PB_Tree_Inbetween Or State & #PB_Tree_Checked
        _tree_set_state_(*this, *this\row\_s(), State)
        
        Repaint = 2
      EndIf
      
      If State & #PB_Tree_Collapsed
        *this\row\_s()\box[0]\checked = 1
        collapsed = 1
      ElseIf State & #PB_Tree_Expanded
        *this\row\_s()\box[0]\checked = 0
        collapsed = 1
      EndIf
      
      If collapsed And *this\row\_s()\childrens
        ; 
        If Not *this\hide And *this\row\count And (*this\count\items % *this\row\count) = 0
          *this\change = 1
          Repaint = 3
        EndIf  
        
        PushListPosition(*this\row\_s())
        While NextElement(*this\row\_s())
          If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
            *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\row\_s())
      EndIf
      
      If Repaint
        If Repaint = 2
          Post(#__Event_StatusChange, *this, Item)
        EndIf
        
        If Repaint = 1
          Post(#__Event_Change, *this, Item)
          ;Events(*this, #__Event_change)
        EndIf
        
        _tree_items_repaint_(*this)
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i tree_SetItemFont(*this._s_widget, Item.l, Font.i)
    Protected Result.i, FontID.i = FontID(Font)
    
    If Item >= 0 And Item < *this\count\items And 
       SelectElement(*this\row\_s(), Item) And 
       *this\row\_s()\text\fontID <> FontID
      *this\row\_s()\text\fontID = FontID
      ;       *this\row\_s()\text\change = 1
      ;       *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemFont(*this._s_widget, Item.l, Font.i)
    Protected Result.i
    
    Select *this\type
      Case #__Type_Tree
        Result = tree_SetItemFont(*this, Item, Font)
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- Anchors
  Macro a_draw(_this_)
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
      ;If _this_\root\anchor\id[#__a_moved] : Box(_this_\root\anchor\id[#__a_moved]\x, _this_\root\anchor\id[#__a_moved]\y, _this_\root\anchor\id[#__a_moved]\width, _this_\root\anchor\id[#__a_moved]\height ,_this_\root\anchor\id[#__a_moved]\color[_this_\root\anchor\id[#__a_moved]\color\state]\frame) : EndIf
      
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
  
  Macro a_resize(_this_)
    If _this_\root\anchor\id[1] ; left
      _this_\root\anchor\id[1]\x = _this_\x[#__c_1]-_this_\root\anchor\pos
      _this_\root\anchor\id[1]\y = _this_\y[#__c_1]+(_this_\height[#__c_1]-_this_\root\anchor\id[1]\height)/2
    EndIf
    If _this_\root\anchor\id[2] ; top
      _this_\root\anchor\id[2]\x = _this_\x[#__c_1]+(_this_\width[#__c_1]-_this_\root\anchor\id[2]\width)/2
      _this_\root\anchor\id[2]\y = _this_\y[#__c_1]-_this_\root\anchor\pos
    EndIf
    If  _this_\root\anchor\id[3] ; right
      _this_\root\anchor\id[3]\x = _this_\x[#__c_1]+_this_\width[#__c_1]-_this_\root\anchor\id[3]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[3]\y = _this_\y[#__c_1]+(_this_\height[#__c_1]-_this_\root\anchor\id[3]\height)/2
    EndIf
    If _this_\root\anchor\id[4] ; bottom
      _this_\root\anchor\id[4]\x = _this_\x[#__c_1]+(_this_\width[#__c_1]-_this_\root\anchor\id[4]\width)/2
      _this_\root\anchor\id[4]\y = _this_\y[#__c_1]+_this_\height[#__c_1]-_this_\root\anchor\id[4]\height+_this_\root\anchor\pos
    EndIf
    
    If _this_\root\anchor\id[5] ; left&top
      _this_\root\anchor\id[5]\x = _this_\x[#__c_1]-_this_\root\anchor\pos
      _this_\root\anchor\id[5]\y = _this_\y[#__c_1]-_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[6] ; right&top
      _this_\root\anchor\id[6]\x = _this_\x[#__c_1]+_this_\width[#__c_1]-_this_\root\anchor\id[6]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[6]\y = _this_\y[#__c_1]-_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[7] ; right&bottom
      _this_\root\anchor\id[7]\x = _this_\x[#__c_1]+_this_\width[#__c_1]-_this_\root\anchor\id[7]\width+_this_\root\anchor\pos
      _this_\root\anchor\id[7]\y = _this_\y[#__c_1]+_this_\height[#__c_1]-_this_\root\anchor\id[7]\height+_this_\root\anchor\pos
    EndIf
    If _this_\root\anchor\id[8] ; left&bottom
      _this_\root\anchor\id[8]\x = _this_\x[#__c_1]-_this_\root\anchor\pos
      _this_\root\anchor\id[8]\y = _this_\y[#__c_1]+_this_\height[#__c_1]-_this_\root\anchor\id[8]\height+_this_\root\anchor\pos
    EndIf
    
    If _this_\root\anchor\id[#__a_moved] 
      _this_\root\anchor\id[#__a_moved]\x = _this_\x[#__c_1]
      _this_\root\anchor\id[#__a_moved]\y = _this_\y[#__c_1]
      _this_\root\anchor\id[#__a_moved]\width = _this_\width[#__c_1]
      _this_\root\anchor\id[#__a_moved]\height = _this_\height[#__c_1]
    EndIf
    
    If _this_\root\anchor\id[10] And _this_\root\anchor\id[11] And _this_\root\anchor\id[12] And _this_\root\anchor\id[13]
      a_lines(_this_)
    EndIf
    
  EndMacro
  
  Procedure a_lines(*Gadget._s_widget=-1, distance=0)
    Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    With *Gadget
      If *Gadget
        checked_x1 = \x[#__c_1]
        checked_y1 = \y[#__c_1]
        checked_x2 = checked_x1+\width[#__c_1]
        checked_y2 = checked_y1+\height[#__c_1]
        
        top_x1 = checked_x1 : top_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 
        right_y1 = checked_y1 : right_y2 = checked_y2
        bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        
        If \parent And ListSize(\parent\childrens())
          PushListPosition(\parent\childrens())
          ForEach \parent\childrens()
            If Not \parent\childrens()\hide
              relative_x1 = \parent\childrens()\x[#__c_1]
              relative_y1 = \parent\childrens()\y[#__c_1]
              relative_x2 = relative_x1+\parent\childrens()\width[#__c_1]
              relative_y2 = relative_y1+\parent\childrens()\height[#__c_1]
              
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
  
  Procedure.i a_add(*this._s_widget, Size.l=6, Pos.l=-1)
    Structure DataBuffer
      cursor.i[#__anchors+1]
    EndStructure
    
    Protected i, *Cursor.DataBuffer = ?CursorsBuffer
    
    With *this
      \flag\transform = 1
      If Pos=-1
        Pos = Size-3
      EndIf
      
      If Not \root\anchor
        \root\anchor = AllocateStructure(structures::_s_anchor)
        \root\anchor\index = #__a_moved
        \root\anchor\pos = Pos
        \root\anchor\size = Size
        
        For i = 0 To #__anchors
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
  
  Procedure.i a_get(*this._s_widget, index.i=-1)
    ProcedureReturn Bool(*this\root\anchor\id[(Bool(index.i=-1) * #__a_moved) + (Bool(index.i>0) * index)]) * *this
  EndProcedure
  
  Procedure.i a_Set(*this._s_widget)
    Protected Result.i
    Static *LastPos
    
    With *this
      If Not (\parent And 
              (\parent\scroll And (*this = \parent\scroll\v Or *this = \parent\scroll\h)) Or 
              (\parent\splitter And (*this = \parent\splitter\first Or *this = \parent\splitter\second Or \from = #__b_3)))
        
        If \root\anchor\index = #__a_moved And \root\anchor\widget <> *this
          ;         If \root\anchor\widget
          ;           If *LastPos
          ;             ; ?????????? ?? ?????
          ;             SetPosition(\root\anchor\widget, #PB_list_before, *LastPos)
          ;             *LastPos = 0
          ;           EndIf
          ;         EndIf
          ;         
          ;         *LastPos = GetPosition(*this, #PB_list_after)
          ;         If *LastPos
          ;           SetPosition(*this, #PB_list_last)
          ;         EndIf
          \root\anchor\widget = *this
          
          If \container
            \root\anchor\id[5]\width = \root\anchor\size * 2
            \root\anchor\id[5]\height = \root\anchor\size * 2
          Else
            \root\anchor\id[5]\width = \root\anchor\size
            \root\anchor\id[5]\height = \root\anchor\size
          EndIf
          
          a_resize(*this)
          Result = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i a_remove(*this._s_widget)
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
  
  Procedure a_callback(*this._s_widget, eventtype.i, Buttons.i, mouse_x.i,mouse_y.i)
    Protected result, i 
    
    With *this
      If \root\anchor 
        Select eventtype 
          Case #__Event_MouseMove
            If \root\anchor\id[\root\anchor\index]\color\state = #__s_2
              *this = \root\anchor\widget
              mouse_x-\root\anchor\delta\x
              mouse_y-\root\anchor\delta\y
              
              Protected.i Px,Py, Grid = \grid, IsGrid = Bool(Grid>1)
              
              If \parent
                Px = \parent\x[#__c_2]
                Py = \parent\y[#__c_2]
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
                  
                Case #__a_moved 
                  If Not \container
                    If  Not \root\anchor\cursor 
                      Set_cursor(*this, \root\anchor\id[\root\anchor\index]\cursor)
                      \root\anchor\cursor = 1
                    EndIf
                    
                    result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                  EndIf
              EndSelect
              
            ElseIf Not Buttons
              ; From point anchor
              For i = #__anchors To 0 Step - 1
                If \root\anchor\id[i] And _from_point_(mouse_x, mouse_y, \root\anchor\id[i]) 
                  If i <> #__a_moved And Not \root\anchor\cursor
                    If \container And i = 5
                      Set_cursor(*this, \root\anchor\id[#__a_moved]\cursor)
                    Else
                      Set_cursor(*this, \root\anchor\id[i]\cursor)
                    EndIf
                    \root\anchor\cursor = 1
                  EndIf
                  \root\anchor\id[i]\color\state = 1
                  \root\anchor\index = i
                  Break
                Else
                  \root\anchor\id[i]\color\state = 0
                  If \root\anchor\cursor
                    Set_cursor(*this, \root\anchor\id[0]\cursor)
                    \root\anchor\cursor = 0
                  EndIf
                EndIf
              Next
            EndIf
            
          Case #__Event_LeftButtonDown  
            If \root\flag\transform
              If a_Set(*this)
              EndIf
              \flag\transform = 1
            EndIf
            
            If \flag\transform
              If _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                \root\anchor\delta\x = mouse_x-\root\anchor\id[\root\anchor\index]\x
                \root\anchor\delta\y = mouse_y-\root\anchor\id[\root\anchor\index]\y
                \root\anchor\id[\root\anchor\index]\color\state = #__s_2
              EndIf
            EndIf
            
          Case #__Event_LeftButtonUp
            If \flag\transform
              If \root\anchor\cursor And Not _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                Set_cursor(*this, \root\anchor\id[0]\cursor)
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
  Procedure  window_draw(*this._s_widget)
    With *this 
      If \__height
        ; Draw caption back
        If \caption\color\back 
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_( 0, \caption\x, \caption\y, \caption\width, \caption\height-1, \caption\color\fore[\color\state], \caption\color\back[\color\state], \round, \caption\color\alpha)
        EndIf
        
        ; Draw caption frame
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\caption\x, \caption\y, \caption\width, \caption\height-1,\round,\round,\color\frame[\color\state])
          
          ; erase the bottom edge of the frame
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BackColor(\caption\color\fore[\color\state])
          FrontColor(\caption\color\back[\color\state])
          
          Protected i
          For i=\round/2+2 To \caption\height-2
            Line(\x[#__c_1],\y[#__c_1]+i,\width[#__c_1],1, \caption\color\back[\color\state])
          Next
          
          ; two edges of the frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Line(\x[#__c_1],\y[#__c_1]+\round/2+2,1,\caption\height-\round/2,\color\frame[\color\state])
          Line(\x[#__c_1]+\width[#__c_1]-1,\y[#__c_1]+\round/2+2,1,\caption\height-\round/2,\color\frame[\color\state])
        EndIf
        
        ;         ; Draw image
        ;         If \caption\image\handle
        ;           DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        ;           DrawAlphaImage(\caption\image\handle, \caption\image\x, \caption\image\y, \caption\color\alpha)
        ;         EndIf
        
        If \caption\text\string
          ;ClipOutput(\caption\x[#__c_4], \caption\y[#__c_4], \caption\width[#__c_4], \caption\height[#__c_4])
          ClipOutput(\caption\x[#__c_2], \caption\y[#__c_2], \caption\width[#__c_2], \caption\height[#__c_2])
          ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ;           RoundBox(\caption\x[#__c_2], \caption\y[#__c_2], \caption\width[#__c_2], \caption\height[#__c_2], \round, \round, $FF000000)
          ; Draw string
          If \resize & #__resize_change
            \caption\text\x = \caption\x[#__c_2] + \caption\text\_padding
            \caption\text\y = \caption\y[#__c_2] + (\caption\height[#__c_2]-TextHeight("A"))/2
          EndIf
          
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawText(\caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
        
        ; draw button back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If Not \caption\button[0]\hide
          RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, 
                   \caption\button[0]\round, \caption\button[0]\round, \caption\button[0]\color\back[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
        EndIf
        If Not \caption\button[1]\hide
          RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height,
                   \caption\button[1]\round, \caption\button[1]\round, \caption\button[1]\color\back[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
        EndIf
        If Not \caption\button[2]\hide
          RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, 
                   \caption\button[2]\round, \caption\button[2]\round, \caption\button[2]\color\back[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
        EndIf
        If Not \caption\button[3]\hide
          RoundBox(\caption\button[3]\x, \caption\button[3]\y, \caption\button[3]\width, \caption\button[3]\height, 
                   \caption\button[3]\round, \caption\button[3]\round, \caption\button[3]\color\back[\caption\button[3]\color\state]&$FFFFFF|\caption\button[3]\color\alpha<<24)
        EndIf
        
        ; draw button frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        If Not \caption\button[0]\hide
          If \caption\button[0]\color\state
            Line(\caption\button[0]\x+1+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
            Line(\caption\button[0]\x+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
            
            Line(\caption\button[0]\x-1+6+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, -6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
            Line(\caption\button[0]\x+6+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, -6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
          EndIf
          
          RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, 
                   \caption\button[0]\round, \caption\button[0]\round, \caption\button[0]\color\frame[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
        EndIf
        If Not \caption\button[1]\hide
          If \caption\button[1]\color\state
            Line(\caption\button[1]\x+2+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
            Line(\caption\button[1]\x+1+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
            
            Line(\caption\button[1]\x+1+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, -4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
            Line(\caption\button[1]\x+2+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, -4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
          EndIf
          
          RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height,
                   \caption\button[1]\round, \caption\button[1]\round, \caption\button[1]\color\frame[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
        EndIf
        If Not \caption\button[2]\hide
          If \caption\button[2]\color\state
            Line(\caption\button[2]\x-2+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
            Line(\caption\button[2]\x-1+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
            
            Line(\caption\button[2]\x-1+6+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, -4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
            Line(\caption\button[2]\x-2+6+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, -4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
          EndIf
          
          RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, 
                   \caption\button[2]\round, \caption\button[2]\round, \caption\button[2]\color\frame[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
        EndIf
        If Not \caption\button[3]\hide
          RoundBox(\caption\button[3]\x, \caption\button[3]\y, \caption\button[3]\width, \caption\button[3]\height, 
                   \caption\button[3]\round, \caption\button[3]\round, \caption\button[3]\color\frame[\caption\button[3]\color\state]&$FFFFFF|\caption\button[3]\color\alpha<<24)
        EndIf
        
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure window_close(*this._s_widget)
    Protected.b result
    
    ; close window
    If Not Post(#__Event_CloseWindow, *this)
      Free(*this)
      
      If _is_root_(*this)
        PostEvent(#PB_Event_CloseWindow, *this\root\window, *this)
      EndIf
      
      result = #True
    EndIf
  EndProcedure
  
  Procedure window_setstate(*this._s_widget, state.l)
    Protected.b result
    
    ; restore state
    If state = #__Window_Normal
      If Not Post(#__Event_RestoreWindow, *this)
        If *this\resize & #__resize_minimize
          *this\resize &~ #__resize_minimize
          *this\caption\button[0]\hide = 0
          *this\caption\button[2]\hide = 0
        EndIf
        *this\resize &~ #__resize_maximize
        *this\resize | #__resize_restore
        
        Resize(*this, *this\root\x[#__c_3], *this\root\y[#__c_3], 
               *this\root\width[#__c_3], *this\root\height[#__c_3])
        
        If _is_root_(*this)
          PostEvent(#PB_Event_RestoreWindow, *this\root\window, *this)
        EndIf
      EndIf
    EndIf
    
    ; maximize state
    If state = #__Window_Maximize
      If Not Post(#__Event_MaximizeWindow, *this)
        If Not *this\resize & #__resize_minimize
          *this\root\x[#__c_3] = *this\x[#__c_3]
          *this\root\y[#__c_3] = *this\y[#__c_3]
          *this\root\width[#__c_3] = *this\width
          *this\root\height[#__c_3] = *this\height
        EndIf
        
        *this\resize | #__resize_maximize
        Resize(*this, 0,0, *this\parent\width, *this\parent\height)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_MaximizeWindow, *this\root\window, *this)
        EndIf
        
        result = #True
      EndIf
    EndIf
    
    ; minimize state
    If state = #__Window_Minimize
      If Not Post(#__Event_MinimizeWindow, *this)
        If Not *this\resize & #__resize_maximize
          *this\root\x[#__c_3] = *this\x[#__c_3]
          *this\root\y[#__c_3] = *this\y[#__c_3]
          *this\root\width[#__c_3] = *this\width
          *this\root\height[#__c_3] = *this\height
        EndIf
        
        *this\caption\button[0]\hide = 1
        If *this\caption\button[1]\hide = 0
          *this\caption\button[2]\hide = 1
        EndIf
        *this\resize | #__resize_minimize
        
        Resize(*this, *this\root\x[#__c_3], *this\parent\height-*this\__height, *this\root\width[#__c_3], *this\__height)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_MinimizeWindow, *this\root\window, *this)
        EndIf
        
        result = #True
      EndIf
    EndIf
    
    ProcedureReturn result 
  EndProcedure
  
  ;-
  ;- DRAWPOPUP
  ;-
  Procedure CallBack_popup()
    Protected *this._s_widget = GetWindowData(EventWindow())
    Protected EventItem.i
    Protected mouse_x =- 1
    Protected mouse_y =- 1
    
    If *this
      With *this
        Select Event()
          Case #PB_Event_ActivateWindow
            Protected *Widget._s_widget = (\root\canvas\gadget)
            
            If Events(\childrens(), #__Event_LeftButtonDown, WindowMouseX(\root\window), WindowMouseY(\root\window))
              ; If \childrens()\index[#__s_2] <> \childrens()\index[#__s_1]
              *Widget\index[#__s_2] = \childrens()\index[#__s_1]
              Post(#__Event_Change, *Widget, \childrens()\index[#__s_1])
              
              SetText(*Widget, GetItemText(\childrens(), \childrens()\index[#__s_1]))
              \childrens()\index[#__s_2] = \childrens()\index[#__s_1]
              ;\childrens()\mouse\buttons = 0
              \childrens()\index[#__s_1] =- 1
              \childrens()\color\state = 1
              ;\mouse\buttons = 0
              ReDraw(*this)
              ; EndIf
            EndIf
            
            SetActiveGadget(*Widget\root\canvas\gadget)
            *Widget\color\state = 0
            ;*Widget\box\checked = 0
            SetActive(*Widget)
            ReDraw(*Widget\root)
            HideWindow(\root\window, 1)
            
          Case #PB_Event_Gadget
            mouse_x = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            mouse_y= GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
            
            If Events(From(*this, mouse_x, mouse_y), EventType(), mouse_x, mouse_y)
              ReDraw(*this)
            EndIf
            
        EndSelect
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Display_popup(*this._s_widget, *Widget._s_widget, x.i=#PB_Ignore,y.i=#PB_Ignore)
    With *this
      If X=#PB_Ignore 
        X = \x+GadgetX(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        
        ForEach *Widget\childrens()\row\_s()
          If *Widget\childrens()\row\_s()\text\change = 1
            *Widget\childrens()\row\_s()\text\height = TextHeight("A")
            *Widget\childrens()\row\_s()\text\width = TextWidth(*Widget\childrens()\row\_s()\text\string.s)
          EndIf
          
          If *Widget\childrens()\scroll\width < (10+*Widget\childrens()\row\_s()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
            *Widget\childrens()\scroll\width = (10+*Widget\childrens()\row\_s()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      SetActive(*Widget\childrens())
      ;*Widget\childrens()\color\state = 1
      
      Protected Width = *Widget\childrens()\scroll\width + *Widget\childrens()\bs*2 
      Protected Height = *Widget\childrens()\scroll\height + *Widget\childrens()\bs*2 
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, #PB_Ignore,#PB_Ignore, width, Height )
      If *Widget\resize & #__resize_change
        ResizeWindow(*Widget\root\window, x, y, width, Height)
        ResizeGadget(*Widget\root\canvas\gadget, #PB_Ignore, #PB_Ignore, width, Height)
      EndIf
    EndWith
    
    ReDraw(*Widget)
    
    HideWindow(*Widget\root\window, 0, #PB_Window_NoActivate)
  EndProcedure
  
  Procedure.i Popup(*Widget._s_widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    With *this
      If *this
        \root = *this
        \type = #__Type_popup
        \container = #__Type_popup
        \color = _get_colors_()
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
        
        If IsWindow(*Widget\root\window)
          Protected WindowID = WindowID(*Widget\root\window)
        EndIf
        
        \root\parent = *Widget
        \root\window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_noGadgets
        \root\canvas\gadget = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(\root, 1,1, width, Height)
        
        SetWindowData(\root\window, *this)
        SetGadgetData(\root\canvas\gadget, *Widget)
        
        BindEvent(#PB_Event_ActivateWindow, @CallBack_popup(), \root\window);, \gadget )
        BindGadgetEvent(\root\canvas\gadget, @CallBack_popup())
      EndIf
    EndWith  
    
    ProcedureReturn *this
  EndProcedure
  
  
  
  ;-
  Procedure.s Class(Type.i)
    Protected Result.s
    
    Select Type
      Case #__Type_Button         : Result = "Button"
      Case #__Type_ButtonImage    : Result = "ButtonImage"
      Case #__Type_Calendar       : Result = "Calendar"
      Case #__Type_Canvas         : Result = "Canvas"
      Case #__Type_CheckBox       : Result = "Checkbox"
      Case #__Type_ComboBox       : Result = "Combobox"
      Case #__Type_Container      : Result = "Container"
      Case #__Type_Date           : Result = "Date"
      Case #__Type_Editor         : Result = "Editor"
      Case #__Type_ExplorerCombo  : Result = "ExplorerCombo"
      Case #__Type_ExplorerList   : Result = "ExplorerList"
      Case #__Type_ExplorerTree   : Result = "ExplorerTree"
      Case #__Type_Frame          : Result = "Frame"
      Case #__Type_HyperLink      : Result = "HyperLink"
      Case #__Type_Image          : Result = "Image"
      Case #__Type_IPAddress      : Result = "IPAddress"
      Case #__Type_ListIcon       : Result = "ListIcon"
      Case #__Type_ListView       : Result = "ListView"
      Case #__Type_MDI            : Result = "MDI"
      Case #__Type_OpenGL         : Result = "OpenGL"
      Case #__Type_Option         : Result = "Option"
      Case #__Type_popup          : Result = "Popup"
      Case #__Type_Panel          : Result = "Panel"
      Case #__Type_property       : Result = "Property"
      Case #__Type_ProgressBar    : Result = "ProgressBar"
      Case #__Type_Scintilla      : Result = "Scintilla"
      Case #__Type_ScrollArea     : Result = "ScrollArea"
      Case #__Type_ScrollBar      : Result = "ScrollBar"
      Case #__Type_Shortcut       : Result = "Shortcut"
      Case #__Type_Spin           : Result = "Spin"
      Case #__Type_Splitter       : Result = "Splitter"
      Case #__Type_String         : Result = "String"
      Case #__Type_Text           : Result = "Text"
      Case #__Type_TrackBar       : Result = "TrackBar"
      Case #__Type_Tree           : Result = "Tree"
      Case #__Type_Unknown        : Result = "Unknown"
      Case #__Type_Web            : Result = "Web"
      Case #__Type_Window         : Result = "Window"
      Case #__Type_root           : Result = "Root"
    EndSelect
    
    ProcedureReturn Result.s
  EndProcedure
  
  Procedure.i ClassType(Class.s)
    Protected Result.i
    
    Select Trim(Class.s)
      Case "Button"         : Result = #__Type_Button
      Case "ButtonImage"    : Result = #__Type_ButtonImage
      Case "Calendar"       : Result = #__Type_Calendar
      Case "Canvas"         : Result = #__Type_Canvas
      Case "Checkbox"       : Result = #__Type_CheckBox
      Case "Combobox"       : Result = #__Type_ComboBox
      Case "Container"      : Result = #__Type_Container
      Case "Date"           : Result = #__Type_Date
      Case "Editor"         : Result = #__Type_Editor
      Case "ExplorerCombo"  : Result = #__Type_ExplorerCombo
      Case "ExplorerList"   : Result = #__Type_ExplorerList
      Case "ExplorerTree"   : Result = #__Type_ExplorerTree
      Case "Frame"          : Result = #__Type_Frame
      Case "HyperLink"      : Result = #__Type_HyperLink
      Case "Image"          : Result = #__Type_Image
      Case "IPAddress"      : Result = #__Type_IPAddress
      Case "ListIcon"       : Result = #__Type_ListIcon
      Case "ListView"       : Result = #__Type_ListView
      Case "MDI"            : Result = #__Type_MDI
      Case "OpenGL"         : Result = #__Type_OpenGL
      Case "Option"         : Result = #__Type_Option
      Case "Popup"          : Result = #__Type_popup
      Case "Panel"          : Result = #__Type_Panel
      Case "Property"       : Result = #__Type_property
      Case "ProgressBar"    : Result = #__Type_ProgressBar
      Case "Scintilla"      : Result = #__Type_Scintilla
      Case "ScrollArea"     : Result = #__Type_ScrollArea
      Case "ScrollBar"      : Result = #__Type_ScrollBar
      Case "Shortcut"       : Result = #__Type_Shortcut
      Case "Spin"           : Result = #__Type_Spin
      Case "Splitter"       : Result = #__Type_Splitter
      Case "String"         : Result = #__Type_String
      Case "Text"           : Result = #__Type_Text
      Case "TrackBar"       : Result = #__Type_TrackBar
      Case "Tree"           : Result = #__Type_Tree
      Case "Unknown"        : Result = #__Type_Unknown
      Case "Web"            : Result = #__Type_Web
      Case "Window"         : Result = #__Type_Window
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i __arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    If Direction = 1 ; top
      If Style > 0 : y + 1 : size / 2 : x+size 
        For i = 0 To Size 
          LineXY(x-i,y+i-Style,x-i,y+i+Style,Color) ; left line
          LineXY(x+i,y+i-Style,x+i,y+i+Style,Color) ; right line
        Next
      Else : x+Length - 1
        For i = 0 To Length 
          LineXY(x-i, y+i, x, y+i, Color)
          LineXY(x+i, y+i, x, y+i, Color)
        Next 
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : y+size - 1 : size / 2 : x+size 
        For i = 0 To Size 
          LineXY(x-i,y-i-Style,x-i,y-i+Style,Color) ; left line
          LineXY(x+i,y-i-Style,x+i,y-i+Style,Color) ; right line
        Next
      Else : x+Length - 1 : y+size
        For i = 0 To Length 
          LineXY(x-i, y-i, x, y-i, Color)
          LineXY(x+i, y-i, x, y-i, Color)
        Next
      EndIf
    ElseIf Direction = 0 ; left
      If Style > 0 : x + 1 : size / 2 : y+size
        For i = 0 To Size 
          LineXY(x+i-Style,y-i,x+i+Style,y-i,Color) ; top line
          LineXY(x+i-Style,y+i,x+i+Style,y+i,Color) ; bottom line
        Next  
      Else : y+Length - 1 : x+Length 
        For i = 0 To Length
          LineXY(x-i, y, x, y-i, Color)
          LineXY(x-i, y, x, y+i, Color)
        Next 
      EndIf
    ElseIf Direction = 2 ; right
      If Style > 0 : x+size - 1 : size / 2 : y+size
        For i = 0 To Size 
          LineXY(x-i-Style,y-i,x-i+Style,y-i,Color) ; top line
          LineXY(x-i-Style,y+i,x-i+Style,y+i,Color) ; bottom line
        Next
      Else : y+Length - 1 : x+size
        For i = 0 To Length 
          LineXY(x-i, y, x-i, y-i, Color)
          LineXY(x-i, y, x-i, y+i, Color)
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; ????? ?????
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; ?????? ?????
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
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; ????? ?????
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; ?????? ?????
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
    ElseIf Direction = 0 ; ? ????
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; ? ????
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; ?????? ?????
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; ????? ?????
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
    ElseIf Direction = 2 ; ? ?????
      If Style > 0 : y-1 : x + 1
        Size / 2
        For i = 0 To Size 
          ; ? ?????
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; ????? ?????
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; ?????? ?????
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
    ;     ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_round_nearest) * Grid)))
  EndProcedure
  
  
  ;-
  
  ; SET_
  Procedure.i Set_State(*this._s_widget, List *this_item.structures::_s_items(), State.i)
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
              ElseIf sublevel < *this_item()\sublevel And *this_item()\Parent
                *this_item()\hide = Bool(*this_item()\Parent\box[0]\checked | *this_item()\Parent\hide)
              EndIf
            Wend
            PopListPosition(*this_item())
            
          ElseIf *this\index[#__s_2] <> State : *this_item()\color\state = 2
            If *this\index[#__s_2] >= 0 And SelectElement(*this_item(), *this\index[#__s_2])
              *this_item()\color\state = 0
            EndIf
            ; GetState() - Value = *this\index[#__s_2]
            \index[#__s_2] = State
            
            Debug "set_state() - "+State;*this\index[#__s_1]+" "+ListIndex(\items())
                                        ; Post change event To widget (tree, listview)
            Events(*this, #__Event_Change, *this\root\mouse\x, *this\root\mouse\y)
          EndIf
          
          Repaint = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure.s Wrap(Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$="", TextWidth
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #crLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #cr$, #LF$)
    Text.s + #LF$
    ;  
    
    If Width > 5
      
      Protected *str.Character = @Text.s
      Protected *End.Character = @Text.s
      
      While *End\c 
        If *End\c = #LF And *str <> *End
          start = (*End-*str)>>#PB_Compiler_Unicode
          line$ = PeekS (*str, start)
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
          
          ret$ + LineRet$ + line$ + nl$
          If LineRet$
            LineRet$=""
          EndIf
          
          *str = *End + #__sOC 
        EndIf 
        
        *End + #__sOC 
      Wend
      
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  
  
  ;-
  ;- - DRAWINGs
  Procedure.i Draw_box(X,Y, Width, Height, Type, Checked, Color, BackColor, round, Alpha=255) 
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
    RoundBox(X,Y,Width,Height, round,round)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, round,round, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; ????? ?????
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; ?????? ?????
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; ????? ?????
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; ?????? ?????
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  ;-
  Procedure.i Draw_text(*this._s_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\text\x, \text\y, \text\string.s, \color\front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *str.Character = @\text\string.s
          Protected *End.Character = @\text\string.s 
          #__sOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\text\x, \text\y+y, PeekS(*str, (*End-*str)>>#PB_Compiler_Unicode), \color\front&$FFFFFF|Alpha)
              *str = *End + #__sOC 
              y+\text\height
            EndIf 
            *End + #__sOC 
          Wend
          
          ;         For i=1 To \count\items
          ;           DrawText(\text\x, \text\y+y, StringField(\text\string.s, i, #LF$), \color\front&$FFFFFF|Alpha)
          ;           y+\text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[#__c_1], \y[#__c_1], \width[#__c_1], \height[#__c_1], \round, \round, \color\frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  ;-
  Procedure   _draw_text_(*this._s_widget)
    ; draw text
    If *this\text\string
      ForEach *this\row\_s()
        If *this\row\_s()\text\string
          If (*this\text\change Or *this\resize & #__resize_change)
            *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\scroll\x
            *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\scroll\y
          EndIf
          
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawRotatedText(*this\row\_s()\text\x, *this\row\_s()\text\y, *this\row\_s()\text\string, *this\text\rotate, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
        EndIf
      Next
    EndIf
  EndProcedure
  
  Procedure   Draw_button(*this._s_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      ;       ; Draw image
      ;       If \image\handle
      ;         DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_alphaBlend)
      ;         DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      ;       EndIf
      ;       
      ;       ; Draw string
      ;       If *this\text\string
      ;         DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_alphaBlend)
      ;         DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, \color\front[State]&$FFFFFF|Alpha)
      ;       EndIf
      
      
    EndWith 
    
    ; draw text
    If *this\text\string
      _draw_text_(*this)
    EndIf
  EndProcedure
  
  Procedure   _draw_hyperlink_(*this._s_widget)
    ; draw text
    If *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      _draw_text_(*this)
      
      If *this\flag\lines
        Line(*this\text\x, *this\text\y+*this\text\height-2, *this\text\width, 1, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
      EndIf
    EndIf
  EndProcedure
  
  Procedure   _draw_checkbox_(*this._s_widget)
    ; draw box background
    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    RoundBox(*this\check_box\x,*this\check_box\y,*this\check_box\width,*this\check_box\height, *this\round, *this\round, *this\color\back&$FFFFFF|*this\color\alpha<<24)
    
    ; draw box frame
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(*this\check_box\x,*this\check_box\y,*this\check_box\width,*this\check_box\height, *this\round, *this\round, *this\color\frame[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
    
    ; draw box state
    If *this\check_box\checked = #PB_Checkbox_Checked
      Protected i.i
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      For i = 0 To 2
        LineXY((*this\check_box\x+3),(i+*this\check_box\y+8),(*this\check_box\x+7),(i+*this\check_box\y+9), *this\color\frame[*this\color\state]&$FFFFFF|*this\color\alpha<<24) 
        LineXY((*this\check_box\x+10+i),(*this\check_box\y+3),(*this\check_box\x+6+i),(*this\check_box\y+10), *this\color\frame[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
      Next
      
    ElseIf *this\check_box\checked = #PB_Checkbox_Inbetween
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( *this\check_box\x+2,*this\check_box\y+2,*this\check_box\width-4,*this\check_box\height-4, *this\round-2, *this\round-2, *this\color\frame[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
    EndIf
    
    ; draw text
    If *this\text\string
      _draw_text_(*this)
    EndIf
  EndProcedure
  
  Procedure   _draw_option_(*this._s_widget)
    ; draw circle background
    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    RoundBox(*this\option_box\x, *this\option_box\y, *this\option_box\width, *this\option_box\width, *this\round, *this\round, *this\color\back&$FFFFFF|*this\color\alpha<<24)
    
    ; draw circle frame
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    Circle(*this\option_box\x+*this\round, *this\option_box\y+*this\round, *this\round, *this\color\frame[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
    
    ; draw circle state
    If *this\option_box\checked > 0
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Circle(*this\option_box\x+*this\round, *this\option_box\y+*this\round, 2, *this\color\frame[*this\color\state]&$FFFFFFFF|*this\color\alpha<<24)
    EndIf
    
    ; draw text
    If *this\text\string
      _draw_text_(*this)
    EndIf
  EndProcedure
  
  ;-
  Procedure.b Draw_Scroll(*this._s_widget)
    ProcedureReturn bar::draw(*this)
    
    With *this
      
      If Not \hide And \color\alpha
        If \color\back <> - 1
          ; Draw scroll bar background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \type = #__Type_ScrollBar
          If \bar\vertical
            If (\bar\page\len+Bool(\round)*(\width/4)) = \height
              Line( \x, \y, 1, \bar\page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          Else
            If (\bar\page\len+Bool(\round)*(\height/4)) = \width
              Line( \x, \y, \bar\page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_1]\height) Or (Not \bar\vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                               ; Draw buttons
          If \bar\button[#__b_1]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                           \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_1]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, 
                  \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_2]\height) Or (Not \bar\vertical And \bar\button[#__b_2]\width)
          ; Draw buttons
          If \bar\button[#__b_2]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                           \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_2]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2, 
                  \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
          EndIf
        EndIf
        
        If \bar\thumb\len And \type <> #__Type_ProgressBar
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                         \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
          
          If \bar\button[#__b_3]\arrow\type ; \type = #__Type_ScrollBar
            If \bar\button[#__b_3]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2, 
                    \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
            EndIf
          Else
            ; Draw thumb lines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            If \bar\vertical
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2-3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2+3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Else
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2-3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2+3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            EndIf
            
          EndIf
        EndIf
        
        If \type = #__Type_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          ;\mode = #__bar_ticks
          
          If \bar\vertical
            If \bar\mode = #__bar_ticks
              For i=0 To \bar\page\end-\bar\min
                Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-2, 
                     (\bar\area\pos + _thumb_ + Round(i * \bar\scroll_increment, #PB_Round_Nearest)),3, 1,\bar\button[#__b_1]\color\frame)
              Next
            EndIf
            
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + \bar\area\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode = #__bar_ticks
              For i=0 To \bar\page\end-\bar\min
                Line((\bar\area\pos + _thumb_ + Round(i * \bar\scroll_increment, #PB_Round_Nearest)), 
                     \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3+4)-2,1,3,\bar\button[#__b_3]\color\Frame)
              Next
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + \bar\area\len + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
          EndIf
          
          ;           If \bar\button[#__b_3]\len
          ;             If \bar\vertical
          ;               DrawingMode(#PB_2DDrawing_default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height/2+1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,-\bar\button[#__b_3]\height/2-1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               
          ;             Else
          ;               DrawingMode(#PB_2DDrawing_default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\width/2+1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,-\bar\button[#__b_3]\width/2-1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;             EndIf
          ;           EndIf
          
        EndIf
        
        If \type = #__Type_ProgressBar 
          
          ;           DrawingMode(#PB_2DDrawing_default|#PB_2DDrawing_alphaBlend)
          ;           RoundBox(\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          ;           RoundBox(\bar\thumb\pos+\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          If \bar\button[#__b_1]\round
            If \bar\vertical
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x+\bar\button[#__b_1]\width-1, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x+\bar\button[#__b_2]\width-1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y+\bar\button[#__b_1]\height-1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y+\bar\button[#__b_2]\height-1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            If \bar\vertical
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x+1,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x+1,\bar\thumb\pos,\bar\button[#__b_2]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height-2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_2]\height-2,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            EndIf
          EndIf
          
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_progress(*this._s_widget)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    
    Draw_Scroll(*this)
    
    ; draw text
    If *this\text\string
      _draw_text_(*this)
    EndIf
  EndProcedure
  
  Procedure.b Draw_track(*this._s_widget)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    *this\bar\button[#__b_3]\color\state = 2
    
    Draw_Scroll(*this)
  EndProcedure
  
  Procedure.i Draw_Spin(*this._s_widget) 
    Draw_Scroll(*this)
    
    ; draw text
    If *this\text\string
      _draw_text_(*this)
    EndIf
  EndProcedure
  
  ;-
  Procedure.i Draw_frame(*this._s_widget)
    With *this 
      ; draw text
      If *this\text\string
        _draw_text_(*this)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \__height/2
        Box(\x[#__c_1], \y+h, 6, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\text\x+\text\width+3, \y+h, \width[#__c_1]-((\text\x+\text\width)-\x)-3, \fs, \color\frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[#__c_1], \y[#__c_1]-h, \fs, \height[#__c_1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[#__c_1]+\width[#__c_1]-\fs, \y[#__c_1]-h, \fs, \height[#__c_1]+h, \color\frame&$FFFFFF|\color\alpha<<24)
        Box(\x[#__c_1], \y[#__c_1]+\height[#__c_1]-\fs, \width[#__c_1], \fs, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_combobox(*this._s_widget)
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
        _box_gradient_( \bar\vertical, \x[#__c_2], \y[#__c_2], \width[#__c_2], \height[#__c_2], \color\fore[State], \color\back[State], \round, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4]-\combo_box\width-\text\x[2],\height[#__c_4])
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
        ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
      EndIf
      
      \combo_box\x = \x+\width-\combo_box\width -\combo_box\arrow\size/2
      \combo_box\height = \height[#__c_2]
      \combo_box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\combo_box\x+(\combo_box\width-\combo_box\arrow\size)/2, \combo_box\y+(\combo_box\height-\combo_box\arrow\size)/2, \combo_box\arrow\size, Bool(\combo_box\checked)+2, \color\front[State]&$FFFFFF|Alpha, \combo_box\arrow\type)
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#__c_1], \y[#__c_1], \width[#__c_1], \height[#__c_1], \round, \round, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  ;-
  Procedure.l Draw_tree(*this._s_widget)
    Protected Y, state.b
    
    Macro _tree_lines_(_this_, _items_)
      ; vertical lines for tree widget
      If _items_\parent 
        
        If _items_\draw
          If _items_\parent\last
            _items_\parent\last\l\v\height = 0
            
            _items_\parent\last\first = 0
          EndIf
          
          _items_\first = _items_\parent
          _items_\parent\last = _items_
        Else
          
          If _items_\parent\last
            _items_\parent\last\l\v\height = (_this_\y[#__c_2] + _this_\height[#__c_2]) -  _items_\parent\last\l\v\y 
          EndIf
          
        EndIf
        
      Else
        If _items_\draw
          If _this_\row\first\last And
             _this_\row\first\sublevel = _this_\row\first\last\sublevel
            If _this_\row\first\last\first
              _this_\row\first\last\l\v\height = 0
              
              _this_\row\first\last\first = 0
            EndIf
          EndIf
          
          _items_\first = _this_\row\first
          _this_\row\first\last = _items_
          
        Else
          If _this_\row\first\last And
             _this_\row\first\sublevel = _this_\row\first\last\sublevel
            
            _this_\row\first\last\l\v\height = (_this_\y[#__c_2] + _this_\height[#__c_2]) -  _this_\row\first\last\l\v\y
            ;Debug _items_\text\string
          EndIf
        EndIf
      EndIf
      
      _items_\l\h\y = _items_\box[0]\y+_items_\box[0]\height/2
      _items_\l\v\x = _items_\box[0]\x+_items_\box[0]\width/2
      
      If (_this_\x[#__c_2]-_items_\l\v\x) < _this_\flag\lines
        If _items_\l\v\x<_this_\x[#__c_2]
          _items_\l\h\width =  (_this_\flag\lines - (_this_\x[#__c_2]-_items_\l\v\x))
        Else
          _items_\l\h\width = _this_\flag\lines
        EndIf
        
        If _items_\draw And _items_\l\h\y > _this_\y[#__c_2] And _items_\l\h\y < _this_\y[#__c_2]+_this_\height[#__c_2]
          _items_\l\h\x = _items_\l\v\x + (_this_\flag\lines-_items_\l\h\width)
          _items_\l\h\height = 1
        Else
          _items_\l\h\height = 0
        EndIf
        
        ; Vertical plot
        If _items_\first And _this_\x[#__c_2]<_items_\l\v\x
          _items_\l\v\y = (_items_\first\y+_items_\first\height- Bool(_items_\first\sublevel = _items_\sublevel) * _items_\first\height/2) - _this_\scroll\v\bar\page\pos
          If _items_\l\v\y < _this_\y[#__c_2] : _items_\l\v\y = _this_\y[#__c_2] : EndIf
          
          _items_\l\v\height = (_items_\y+_items_\height/2)-_items_\l\v\y - _this_\scroll\v\bar\page\pos
          If _items_\l\v\height < 0 : _items_\l\v\height = 0 : EndIf
          If _items_\l\v\y + _items_\l\v\height > _this_\y[#__c_2]+_this_\height[#__c_2] 
            If _items_\l\v\y > _this_\y[#__c_2]+_this_\height[#__c_2] 
              _items_\l\v\height = 0
            Else
              _items_\l\v\height = (_this_\y[#__c_2] + _this_\height[#__c_2]) -  _items_\l\v\y 
            EndIf
          EndIf
          
          If _items_\l\v\height
            _items_\l\v\width = 1
          Else
            _items_\l\v\width = 0
          EndIf
        EndIf 
        
      EndIf
    EndMacro
    
    Macro _tree_items_update_(_this_, _items_)
      If _this_\change <> 0
        _this_\scroll\width = 0
        _this_\scroll\height = 0
      EndIf
      
      If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
        ClearList(_this_\row\draws())
      EndIf
      
      PushListPosition(_items_)
      ForEach _items_
        ; 
        If _items_\text\fontID
          If _items_\fontID <> _items_\text\fontID
            _items_\fontID = _items_\text\fontID
            
            DrawingFont(_items_\fontID) 
            _items_\text\height = TextHeight("A") 
            ; Debug  " - "+_items_\text\height +" "+ _items_\text\string
          EndIf
        ElseIf _this_\text\fontID  
          If _items_\fontID <> _this_\text\fontID
            _items_\fontID = _this_\text\fontID
            
            DrawingFont(_items_\fontID) 
            _items_\text\height = _this_\text\height
            ; Debug  " - "+_items_\text\height +" "+ _items_\text\string
          EndIf
        EndIf
        
        ; ???????? ???? ??? ????? ????????? ??????  
        If _items_\text\change
          _items_\text\width = TextWidth(_items_\text\string.s) 
          _items_\text\change = #False
        EndIf 
        
        If _items_\hide
          _items_\draw = 0
        Else
          If _this_\change
            _items_\x = _this_\x[#__c_2]
            _items_\height = _items_\text\height + 2 ;
            _items_\y = _this_\y[#__c_2] + _this_\scroll\height
            
            _items_\width = _this_\width[#__c_2] ; ???
          EndIf
          
          If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
            ; check box
            If _this_\flag\checkBoxes Or _this_\flag\option_group
              _items_\box[1]\x = _items_\x + 3 - _this_\scroll\h\bar\page\pos
              _items_\box[1]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[1]\height)/2-_this_\scroll\v\bar\page\pos
            EndIf
            
            ; expanded & collapsed box
            If _this_\flag\buttons Or _this_\flag\lines 
              _items_\box[0]\x = _items_\x + _items_\sublevellen - _this_\row\sublevellen + Bool(_this_\flag\buttons) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\bar\page\pos 
              _items_\box[0]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[0]\height)/2-_this_\scroll\v\bar\page\pos
            EndIf
            
            ;
            If _items_\image
              _items_\image\x = _items_\x + _this_\image\_padding + _items_\sublevellen - _this_\scroll\h\bar\page\pos
              _items_\image\y = _items_\y + (_items_\height-_items_\image\height)/2-_this_\scroll\v\bar\page\pos
            EndIf
            
            _items_\text\x = _items_\x + _this_\text\_padding + _items_\sublevellen + _this_\row\sublevel - _this_\scroll\h\bar\page\pos
            _items_\text\y = _items_\y + (_items_\height-_items_\text\height)/2-_this_\scroll\v\bar\page\pos
            
            _items_\draw = Bool(_items_\y+_items_\height-_this_\scroll\v\bar\page\pos>_this_\y[#__c_2] And 
                                (_items_\y-_this_\y[#__c_2])-_this_\scroll\v\bar\page\pos<_this_\height[#__c_2])
            
            ; lines for tree widget
            If _this_\flag\lines And _this_\row\sublevellen
              _tree_lines_(_this_, _items_)
            EndIf
            
            If _items_\draw And 
               AddElement(_this_\row\draws())
              _this_\row\draws() = _items_
            EndIf
          EndIf
          
          If _this_\change <> 0
            _this_\scroll\height + _items_\height + _this_\flag\GridLines
            _items_\len = ((_items_\text\x + _items_\text\width + _this_\scroll\h\bar\page\pos) - _this_\x[#__c_2])
            
            If _this_\scroll\h\height And _this_\scroll\width < _items_\len
              _this_\scroll\width = _items_\len
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(_items_)
      
      
      If _this_\scroll\v\bar\page\len And _this_\scroll\v\bar\max<>_this_\scroll\height-Bool(_this_\flag\gridlines) And
         Bar_SetAttribute(_this_\scroll\v, #__bar_maximum, _this_\scroll\height-Bool(_this_\flag\gridlines))
        
        Bar_resizes(_this_\scroll, 0, 0, #PB_Ignore, #PB_Ignore)
        ;Bar_resizes(_this_\scroll, _this_\x-_this_\scroll\h\x+1, _this_\y-_this_\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
        ;Bar_resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      ; Debug ""+_this_\scroll\v\bar\max +" "+ _this_\scroll\height +" "+ _this_\scroll\v\bar\page\pos +" "+ _this_\scroll\v\bar\page\len
      ;_this_\scroll\v\bar\max = _this_\scroll\height
      ; Debug ""+_this_\scroll\v\bar\page\len+" "+_this_\scroll\height+" "+_this_\scroll\v\bar\max ; _this_\scroll\height
      
      If _this_\scroll\h\bar\page\len And _this_\scroll\h\bar\max<>_this_\scroll\width And
         Bar_SetAttribute(_this_\scroll\h, #__bar_maximum, _this_\scroll\width)
        
        Bar_resizes(_this_\scroll, 0, 0, #PB_Ignore, #PB_Ignore)
        ;Bar_resizes(_this_\scroll, _this_\x-_this_\scroll\h\x+1, _this_\y-_this_\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
        ;Bar_resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\change <> 0
        _this_\width[#__c_2] = (_this_\scroll\v\x + Bool(_this_\scroll\v\hide) * _this_\scroll\v\width) - _this_\x[#__c_2]
        _this_\height[#__c_2] = (_this_\scroll\h\y + Bool(_this_\scroll\h\hide) * _this_\scroll\h\height) - _this_\y[#__c_2]
        
        If _this_\row\selected And _this_\row\scrolled
          Bar_SetState(_this_\scroll\v, ((_this_\row\selected\y-_this_\scroll\v\y) - (Bool(_this_\row\scrolled>0) * (_this_\scroll\v\bar\page\len-_this_\row\selected\height))) ) 
          _this_\scroll\v\change = 0 
          _this_\row\scrolled = 0
          
          Draw_tree(_this_)
        EndIf
      EndIf
      
    EndMacro
    
    Macro _tree_items_draws_(_this_, _items_)
      
      PushListPosition(_items_)
      ForEach _items_
        If _items_\draw
          If _items_\width <> _this_\width[#__c_2]
            _items_\width = _this_\width[#__c_2]
          EndIf
          
          If _items_\fontID And
             _this_\row\fontID <> _items_\fontID
            _this_\row\fontID = _items_\fontID
            DrawingFont(_items_\fontID) 
            
            ;  Debug "    "+ _items_\text\height +" "+ _items_\text\string
          EndIf
          
          
          Y = _items_\y - _this_\scroll\v\bar\page\pos
          state = _items_\color\state + Bool(_this_\color\state<>2 And _items_\color\state=2)
          
          ; Draw select back
          If _items_\color\back[state]
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(_this_\x[#__c_2],Y,_this_\width[#__c_2],_items_\height,_items_\round,_items_\round,_items_\color\back[state])
          EndIf
          
          ; Draw select frame
          If _items_\color\frame[state]
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(_this_\x[#__c_2],Y,_this_\width[#__c_2],_items_\height,_items_\round,_items_\round, _items_\color\frame[state])
          EndIf
          
          ; Draw checkbox
          ; Draw option
          If _this_\flag\option_group And _items_\parent
            DrawingMode(#PB_2DDrawing_Default)
            _draw_box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 1, $FFFFFFFF, 7, 255)
            
          ElseIf _this_\flag\checkboxes
            DrawingMode(#PB_2DDrawing_Default)
            _draw_box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 3, $FFFFFFFF, 2, 255)
          EndIf
          
          ; Draw image
          If _items_\image And _items_\image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(_items_\image\handle, _items_\image\x, _items_\image\y, _items_\color\alpha)
          EndIf
          
          ; Draw text
          If _items_\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(_items_\text\x, _items_\text\y, _items_\text\string.s, _this_\text\rotate, _items_\color\front[state])
          EndIf
          
          ; Horizontal line
          If _this_\flag\GridLines And 
             _items_\color\line <> _items_\color\back
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(_items_\x, (_items_\y+_items_\height+Bool(_this_\flag\gridlines>1))-_this_\scroll\v\bar\page\pos, _this_\width[#__c_2], 1, _this_\color\line)
          EndIf
        EndIf
      Next
      
      ; Draw plots
      If _this_\flag\lines
        DrawingMode(#PB_2DDrawing_XOr)
        ; DrawingMode(#PB_2DDrawing_customFilter) 
        
        ForEach _items_
          If _items_\draw 
            If _items_\l\h\height
              ;  CustomFilterCallback(@PlotX())
              Line(_items_\l\h\x, _items_\l\h\y, _items_\l\h\width, _items_\l\h\height, _items_\color\line)
            EndIf
            
            If _items_\l\v\width
              ;  CustomFilterCallback(@PlotY())
              Line(_items_\l\v\x, _items_\l\v\y, _items_\l\v\width, _items_\l\v\height, _items_\color\line)
            EndIf
          EndIf    
        Next
      EndIf
      
      ; Draw arrow
      If _this_\flag\buttons ;And Not _this_\flag\option_group
        DrawingMode(#PB_2DDrawing_Default)
        
        ForEach _items_
          If _items_\draw And _items_\childrens
            Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
            ;             DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_alphaBlend)
            ;             ;RoundBox(_items_\box[0]\x-3, _items_\box[0]\y-3, _items_\box[0]\width+6, _items_\box[0]\height+6, 7,7, _items_\color\front[_items_\color\state])
            ;             RoundBox(_items_\box[0]\x-1, _items_\box[0]\y-1, _items_\box[0]\width+2, _items_\box[0]\height+2, 7,7, _items_\color\front[_items_\color\state])
            ;             Bar_arrow(_items_\box[0]\x+(_items_\box[0]\width-4)/2,_items_\box[0]\y+(_items_\box[0]\height-4)/2, 4, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
          EndIf    
        Next
      EndIf
      
      PopListPosition(_items_) ; 
    EndMacro
    
    With *this
      If Not \hide
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        If \change And \count\items
          If \text\change
            \text\height = TextHeight("A") + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
            \text\width = TextWidth(\text\string.s)
          EndIf
          
          _tree_items_update_(*this, \row\_s())
          \change = 0
        EndIf 
        
        ; Draw background
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\back[\color\state])
        
        ; Draw background image
        If \image And \image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
        EndIf
        
        ; Draw all items
        ClipOutput(\x[#__c_2],\y[#__c_2],\width[#__c_2],\height[#__c_2])
        
        ;_tree_items_draws_(*this, \row\_s())
        _tree_items_draws_(*this, \row\draws())
        
        UnclipOutput()
        
        ; Draw scroll bars
        If \scroll
          CompilerIf Defined(Bar, #PB_Module)
            Draw_Scroll(\scroll\v)
            Draw_Scroll(\scroll\h)
          CompilerEndIf
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        If \color\state
          ; RoundBox(\x[#__c_1]+Bool(\fs),\y[#__c_1]+Bool(\fs),\width[#__c_1]-Bool(\fs)*2,\height[#__c_1]-Bool(\fs)*2,\round,\round,0);\color\back)
          RoundBox(\x[#__c_2]-Bool(\fs),\y[#__c_2]-Bool(\fs),\width[#__c_2]+Bool(\fs)*2,\height[#__c_2]+Bool(\fs)*2,\round,\round,\color\back)
          RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\frame[2])
          ;           If \round : RoundBox(\x[#__c_1],\y[#__c_1]-1,\width[#__c_1],\height[#__c_1]+2,\round,\round,\color\frame[2]) : EndIf  ; ??????????? ????? )))
          ;           RoundBox(\x[#__c_1]-1,\y[#__c_1]-1,\width[#__c_1]+2,\height[#__c_1]+2,\round,\round,\color\frame[2])
        ElseIf \fs
          RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\frame[\color\state])
        EndIf
        
        
        If \text\change : \text\change = 0 : EndIf
        If \resize & #__resize_change : \resize &~ #__resize_change : EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_property(*this._s_widget)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 255
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected round.d = 2, Border=1, Circle=1, Separator=0
    
    With *this
      If *this > 0
        If \text\fontID : DrawingFont(\text\fontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\row\_s())
          
          X = \x
          Y = \y
          Width = \width 
          Height = \height
          
          ; ??????? ????????? 
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
          
          ForEach \row\_s()
            ;             If Not \row\_s()\text\change And Not \resize & #__resize_change And Not \change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\row\_s())
            ;             EndIf
            
            If Not \row\_s()\hide 
              \row\_s()\width=\scroll\h\bar\page\len
              \row\_s()\x=\scroll\h\x-\scroll\h\bar\page\pos
              \row\_s()\y=(\scroll\v\y+\scroll\height)-\scroll\v\bar\page\pos
              
              If \row\_s()\text\change = 1
                \row\_s()\text\height = TextHeight("A")
                \row\_s()\text\width = TextWidth(\row\_s()\text\string.s)
              EndIf
              
              \row\_s()\sublevellen=2+\row\_s()\x+((Bool(\flag\buttons) * \row\sublevellen)+\row\_s()\sublevel * \row\sublevellen)
              
              \row\_s()\box\width = box_size
              \row\_s()\box\height = box_size
              \row\_s()\box\x = \row\_s()\sublevellen-(\row\sublevellen+\row\_s()\box\width)/2
              \row\_s()\box\y = (\row\_s()\y+\row\_s()\height)-(\row\_s()\height+\row\_s()\box\height)/2
              
              If \row\_s()\image\handle
                \row\_s()\image\x = 3+\row\_s()\sublevellen
                \row\_s()\image\y = \row\_s()\y+(\row\_s()\height-\row\_s()\image\height)/2
                
                \image\handle = \row\_s()\image\handle
                \image\width = \row\_s()\image\width+4
              EndIf
              
              \row\_s()\text\x = 3+\row\_s()\sublevellen+\image\width
              \row\_s()\text\y = \row\_s()\y+(\row\_s()\height-\row\_s()\text\height)/2
              
              If \flag\checkboxes
                \row\_s()\box\x+\row\sublevellen-2
                \row\_s()\text\x+\row\sublevellen-2
                \row\_s()\image\x+\row\sublevellen-2 
                
                \row\_s()\box[1]\width = box_1_size
                \row\_s()\box[1]\height = box_1_size
                
                \row\_s()\box[1]\x = \row\_s()\x+4
                \row\_s()\box[1]\y = (\row\_s()\y+\row\_s()\height)-(\row\_s()\height+\row\_s()\box[1]\height)/2
              EndIf
              
              \scroll\height+\row\_s()\height
              
              If \scroll\width < (\row\_s()\text\x-\x+\row\_s()\text\width)+\scroll\h\bar\page\pos
                \scroll\width = (\row\_s()\text\x-\x+\row\_s()\text\width)+\scroll\h\bar\page\pos
              EndIf
            EndIf
            
            \row\_s()\draw = Bool(Not \row\_s()\hide And \row\_s()\y+\row\_s()\height>\y+\bs And \row\_s()\y<\y+\height-\bs)
            ;             If \row\_s()\draw And Not Drawing
            ;               Drawing = @\row\_s()
            ;             EndIf
            
            \row\_s()\text\change = 0
            ;\row\_s()\change = 0
          Next
          
          ; ?????? ??????? ?????? ?????
          If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #__bar_maximum, \scroll\height)
            Bar_resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
            \scroll\v\bar\scroll_step = \text\height
          EndIf
          
          If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #__bar_maximum, \scroll\width)
            Bar_resizes(\scroll, \x-\scroll\h\x+1, \y-\scroll\v\y+1, #PB_Ignore, #PB_Ignore)
          EndIf
          
          
          
          ForEach \row\_s()
            ;           If Drawing
            ;             \draw = Drawing
            ;           EndIf
            ;           
            ;           If \draw
            ;             ChangeCurrentElement(\row\_s(), \draw)
            ;             Repeat 
            If \row\_s()\draw
              \row\_s()\width = \scroll\h\bar\page\len
              State_3 = \row\_s()\color\state
              
              ; Draw selections
              If Not \row\_s()\childrens And \flag\fullselection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\row\_s()\x+1+\scroll\h\bar\page\pos,\row\_s()\y+1,\row\_s()\width-2,\row\_s()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\row\_s()\x+\scroll\h\bar\page\pos,\row\_s()\y,\row\_s()\width,\row\_s()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \color\state = #__s_2 : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\row\_s()\x+1+\scroll\h\bar\page\pos,\row\_s()\y+1,\row\_s()\width-2,\row\_s()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\row\_s()\x+\scroll\h\bar\page\pos,\row\_s()\y,\row\_s()\width,\row\_s()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysselection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\row\_s()\x+1+\scroll\h\bar\page\pos,\row\_s()\y+1,\row\_s()\width-2,\row\_s()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\row\_s()\x+\scroll\h\bar\page\pos,\row\_s()\y,\row\_s()\width,\row\_s()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \row\_s()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\row\_s()\box[0]\x+(\row\_s()\box[0]\width-6)/2,\row\_s()\box[0]\y+(\row\_s()\box[0]\height-6)/2, 6, Bool(Not \row\_s()\box[0]\checked)+2, \color\front[Bool(\color\state = #__s_2) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\row\_s()\box\x, \row\_s()\box\y, \row\_s()\box\x, (\row\_s()\box\y+\row\_s()\box\height))
                  RoundBox(\row\_s()\box\x+1,\row\_s()\box\y+1,\row\_s()\box\width-2,\row\_s()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\row\_s()\box\x,\row\_s()\box\y,\row\_s()\box\width,\row\_s()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\row\_s()\box\x+2,\row\_s()\box\y+\row\_s()\box\height/2 ,\row\_s()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \row\_s()\box\checked : Line(\row\_s()\box\x+\row\_s()\box\width/2,\row\_s()\box\y+2,1,\row\_s()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\lines 
                x_point=\row\_s()\box\x+\row\_s()\box\width/2
                y_point=\row\_s()\box\y+\row\_s()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \row\_s()\parent 
                    start=Bool(Not \row\_s()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\row\_s()\parent\height/2)-\scroll\v\bar\page\pos
                    Else 
                      start = \row\_s()\parent\y+\row\_s()\parent\height+\row\_s()\parent\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_box(\row\_s()\box[1]\x,\row\_s()\box[1]\y,\row\_s()\box[1]\width,\row\_s()\box[1]\height, 3, \row\_s()\box[1]\checked, checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \row\_s()\image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\row\_s()\image\handle, \row\_s()\image\x, \row\_s()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4]-(\width-(\bar\thumb\pos-\x)),\height[#__c_4])
              
              ; Draw string
              If \row\_s()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\row\_s()\text\x, \row\_s()\text\y, \row\_s()\text\string.s, \color\front[Bool(\color\state = #__s_2) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\x[#__c_4]+(\bar\thumb\pos-\x),\y[#__c_4],\width[#__c_4]-(\bar\thumb\pos-\x),\height[#__c_4])
              
              ;               ;\row\_s()\text[1]\x[1] = 5
              ;               \row\_s()\text[1]\x = \x+\bar\thumb\len+\row\_s()\text[1]\x[1]
              ;               \row\_s()\text[1]\y = \row\_s()\text\y
              ;               ; Draw string
              ;               If \row\_s()\text[1]\string.s
              ;                 DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_alphaBlend)
              ;                 DrawText(\row\_s()\text[1]\x+pos, \row\_s()\text[1]\y, \row\_s()\text[1]\string.s, \color\front[Bool(\color\state = #__s_2) * State_3]&$FFFFFFFF|alpha<<24)
              ;               EndIf
              
              ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
            EndIf
            
            ;             Until Not NextElement(\row\_s())
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
  
  Procedure.i Draw_listIcon(*this._s_widget)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*this\flag\gridLines, FirstColumn.i
    
    With *this 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[#__c_2]-\scroll\h\bar\page\pos
      Protected start, stop, n
      
      ; draw background
      If \color\back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#__c_2], \y[#__c_2], \width[#__c_2], \height[#__c_2], \round, \round, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[#__c_2]>1;(\box[1]\width+\box[#__b_2]\width+4)
      ForEach \columns()
        FirstColumn = Bool(Not ListIndex(\columns()))
        n = Bool(\flag\checkboxes)*16 + Bool(\image\width)*28
        
        
        y = \y[#__c_2]-\scroll\v\bar\page\pos
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
        
        \columns()\draw = Bool(Not \columns()\hide And \columns()\x+\columns()\width>\x[#__c_2] And \columns()\x<\x[#__c_2]+\width[#__c_2])
        
        
        ForEach \columns()\items()
          If Not \columns()\items()\hide 
            If \columns()\items()\text\change = 1
              \columns()\items()\text\height = TextHeight("A")
              \columns()\items()\text\width = TextWidth(\columns()\items()\text\string.s)
            EndIf
            
            \columns()\items()\width=\columns()\width
            \columns()\items()\x=\columns()\x
            \columns()\items()\y=y ; + GridLines
            
            ;\columns()\items()\sublevellen=2+\columns()\items()\x+((Bool(\flag\buttons) * \row\sublevellen)+\columns()\items()\sublevel * \row\sublevellen)
            
            If FirstColumn
              If \flag\checkboxes 
                \columns()\items()\box[1]\width = \flag\checkboxes
                \columns()\items()\box[1]\height = \flag\checkboxes
                
                \columns()\items()\box[1]\x = \x[#__c_2] + 4 - \scroll\h\bar\page\pos
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
            \columns()\items()\draw = Bool(\columns()\items()\y+\columns()\items()\height>\y[#__c_2] And \columns()\items()\y<\y[#__c_2]+\height[#__c_2])
            
            y + \columns()\items()\height + \flag\gridLines + GridLines * 2
          EndIf
          
          If *this\index[#__s_2] = \columns()\items()\index
            State_3 = 2
          Else
            State_3 = \columns()\items()\color\state
          EndIf
          
          If \columns()\items()\draw
            ; Draw selections
            If \flag\fullselection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[#__c_2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height, \color\back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[#__c_2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, \color\frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \color\state = #__s_2
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#__c_2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#__c_2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\alwaysselection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#__c_2],\columns()\items()\y+1,\scroll\h\bar\page\len,\columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[#__c_2],\columns()\items()\y,\scroll\h\bar\page\len,\columns()\items()\height, $C8C8C8&back_color|Alpha)
                EndIf
              EndIf
            EndIf
            
            If \columns()\draw 
              ;\columns()\items()\width = \scroll\h\bar\page\len
              
              ; Draw checkbox
              If \flag\checkboxes And FirstColumn
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(\columns()\items()\box[1]\x,\columns()\items()\box[1]\y,\columns()\items()\box[1]\width,\columns()\items()\box[1]\height, 3, 3, \color\front[Bool(\color\state = #__s_2)* state_3]&$FFFFFF|Alpha)
                
                If \columns()\items()\box[1]\checked = #PB_Checkbox_Checked
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  For i =- 1 To 1
                    LineXY((\columns()\items()\box[1]\x+2),(i+\columns()\items()\box[1]\y+7),(\columns()\items()\box[1]\x+6),(i+\columns()\items()\box[1]\y+8), \color\front[Bool(\color\state = #__s_2)* state_3]&$FFFFFF|Alpha) 
                    LineXY((\columns()\items()\box[1]\x+9+i),(\columns()\items()\box[1]\y+2),(\columns()\items()\box[1]\x+5+i),(\columns()\items()\box[1]\y+9), \color\front[Bool(\color\state = #__s_2)* state_3]&$FFFFFF|Alpha)
                  Next
                ElseIf \columns()\items()\box[1]\checked = #PB_Checkbox_Inbetween
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\columns()\items()\box[1]\x+2,\columns()\items()\box[1]\y+2,\columns()\items()\box[1]\width-4,\columns()\items()\box[1]\height-4, 3-2, 3-2, \color\front[Bool(\color\state = #__s_2)* state_3]&$FFFFFF|Alpha)
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
                DrawText(\columns()\items()\text\x, \columns()\items()\text\y, \columns()\items()\text\string.s, \color\front[Bool(\color\state = #__s_2) * State_3]&$FFFFFFFF|\color\alpha<<24)
              EndIf
              
              ; Draw grid line
              If \flag\gridLines
                DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Line(\columns()\items()\x-n, \columns()\items()\y+\columns()\items()\height + GridLines, \columns()\width+n+1 + (\width[#__c_2]-(\columns()\x-\x[#__c_2]+\columns()\width)), 1, \color\frame&$FFFFFF|\color\alpha<<24)                   ; top
              EndIf
            EndIf
          EndIf
          
          \columns()\items()\text\change = 0
          ;\columns()\items()\change = 0
        Next
        
        
        If \columns()\draw
          ; Draw thumb  
          If \color\back[\columns()\color\state]<>-1
            If \color\fore[\columns()\color\state]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            
            If FirstColumn And n
              _box_gradient_( \Vertical, \x[#__c_2], \columns()\y, n, \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \round, \color\alpha)
            ElseIf ListIndex(\columns()) = ListSize(\columns()) - 1
              _box_gradient_( \Vertical, \columns()\x+\columns()\width, \columns()\y, 1 + (\width[#__c_2]-(\columns()\x-\x[#__c_2]+\columns()\width)), \columns()\height, \color\fore[0]&$FFFFFF|\color\alpha<<24, \color\back[0]&$FFFFFF|\color\alpha<<24, \round, \color\alpha)
            EndIf
            
            _box_gradient_( \Vertical, \columns()\x, \columns()\y, \columns()\width, \columns()\height, \color\fore[\columns()\color\state], Bool(\columns()\color\state <> 2) * \color\back[\columns()\color\state] + (Bool(\columns()\color\state = 2) * \color\front[\columns()\color\state]), \round, \color\alpha)
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
            Line(\columns()\x-1, \columns()\y, 1, \columns()\height + Bool(\flag\gridLines) * \height[#__c_1], \color\frame&$FFFFFF|\color\alpha<<24)                     ; left
          EndIf
          Line(\columns()\x+\columns()\width, \columns()\y, 1, \columns()\height + Bool(\flag\gridLines) * \height[#__c_1], \color\frame&$FFFFFF|\color\alpha<<24)      ; right
          Line(\x[#__c_2], \columns()\y+\columns()\height-1, \width[#__c_2], 1, \color\frame&$FFFFFF|\color\alpha<<24)                                                  ; bottom
          
          If \columns()\color\state = 2
            DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\columns()\x, \columns()\y+1, \columns()\width, \columns()\height-2, \round, \round, \color\frame[\columns()\color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        \columns()\text\change = 0
      Next
      
      \scroll\height = (y+\scroll\v\bar\page\pos)-\y[#__c_2]-1;\flag\gridLines
                                                              ; set vertical scrollbar max value
      If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
         SetAttribute(\scroll\v, #__bar_maximum, \scroll\height) : \scroll\v\bar\scroll_step = \text\height
        Bar_resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \scroll\width = (x+\scroll\h\bar\page\pos)-\x[#__c_2]-Bool(Not \scroll\v\hide)*\scroll\v\width+n
      If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
         SetAttribute(\scroll\h, #__bar_maximum, \scroll\width)
        Bar_resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; 1 - frame
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x, \y, \width, \height, \round, \round, \color\frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
    EndWith
  EndProcedure
  
  ;-
  Macro _resize_panel_(_this_, _bar_button_, _pos_)
    If _bar_in_start_(_this_\tab\bar)
      _this_\tab\bar\button[#__b_1]\width = 0
    Else
      _this_\tab\bar\button[#__b_1]\width = _this_\tab\bar\button[#__b_1]\len 
    EndIf
    
    If _bar_in_stop_(_this_\tab\bar)
      _this_\tab\bar\button[#__b_2]\width = 0
    Else
      _this_\tab\bar\button[#__b_2]\width = _this_\tab\bar\button[#__b_2]\len 
    EndIf
    
    _this_\tab\bar\button[#__b_3]\x = _this_\x[#__c_2]+1+_this_\tab\bar\button[#__b_1]\width
    _this_\tab\bar\button[#__b_3]\width = _this_\width[#__c_2]-_this_\tab\bar\button[#__b_1]\width-_this_\tab\bar\button[#__b_2]\width-1
    
    If _this_\tab\bar\vertical
      _this_\tab\bar\button[#__b_1]\x = _this_\tab\bar\button[#__b_3]\x-_this_\tab\bar\button[#__b_1]\width
      _this_\tab\bar\button[#__b_2]\x = _this_\x[#__c_2]+_this_\width[#__c_2]-_this_\tab\bar\button[#__b_2]\width-1
    Else
      If _this_\tab\bar\button[#__b_1] = _bar_button_ 
        _bar_button_\x = _pos_+1
        _this_\tab\bar\button[#__b_2]\x = _this_\x[#__c_2]+_this_\width[#__c_2]-_this_\tab\bar\button[#__b_2]\width-1
      Else
        _bar_button_\x = _pos_-1
        _this_\tab\bar\button[#__b_1]\x = _this_\tab\bar\button[#__b_3]\x-_this_\tab\bar\button[#__b_1]\width
      EndIf
    EndIf
    
    
    _this_\tab\bar\button[#__b_3]\y = _this_\y[#__c_2]-_this_\__height+_this_\bs+2
    _this_\tab\bar\button[#__b_3]\height = _this_\__height-1-4
    
    _this_\tab\bar\button[#__b_1]\y = _this_\tab\bar\button[#__b_3]\y
    _this_\tab\bar\button[#__b_2]\y = _this_\tab\bar\button[#__b_3]\y
    
    _this_\tab\bar\button[#__b_1]\height = _this_\tab\bar\button[#__b_3]\height
    _this_\tab\bar\button[#__b_2]\height = _this_\tab\bar\button[#__b_3]\height
    
    _this_\tab\bar\page\len = _this_\width[#__c_2] - 1
    
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
    ;       _this_\tab\bar\thumb\pos = _bar_thumb_pos_(_this_\tab, _this_\tab\bar\page\pos)
    ;     EndIf
    
  EndMacro
  
  
  Procedure.i Draw_panel(*this._s_widget)
    Protected State_3.i, Alpha.i, Color_frame.i
    
    With *this 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \tab\bar\button[#__b_3]\x-\tab\bar\button[#__b_1]\width
      Protected start, stop
      
      ; Draw background image
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      ElseIf \color\back<>-1
        ; draw background
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[#__c_2], \y[#__c_2], \width[#__c_2], \height[#__c_2], \round, \round, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \count\items And \width[#__c_2]>(\tab\bar\button[#__b_1]\width+\tab\bar\button[#__b_2]\width+4)
        ForEach \tab\_s()
          If \index[#__s_2] = \tab\_s()\index
            State_3 = 2
            \tab\_s()\y = \y+2
            \tab\_s()\height=\__height-1
          Else
            State_3 = Bool(\index[#__s_1] = \tab\_s()\index); = \tab\_s()\color\state
            \tab\_s()\y = \y+4
            \tab\_s()\height=\__height-4-1
          EndIf
          Color_frame = \color\frame[State_3]&$FFFFFF|Alpha
          
          \tab\_s()\image\x[1] = 8 ; Bool(\tab\_s()\image\width) * 4
          
          If \tab\_s()\text\change
            \tab\_s()\text\width = TextWidth(\tab\_s()\text\string)
            \tab\_s()\text\height = TextHeight("A")
          EndIf
          
          \tab\_s()\x = x -\tab\bar\page\pos
          \tab\_s()\width = \tab\_s()\text\width + \tab\_s()\image\x[1]*2 + \tab\_s()\image\width + Bool(\tab\_s()\image\width) * 3
          x + \tab\_s()\width + 1
          
          \tab\_s()\image\x = \tab\_s()\x+\tab\_s()\image\x[1] - 1
          \tab\_s()\image\y = \tab\_s()\y+(\tab\_s()\height-\tab\_s()\image\height)/2
          
          \tab\_s()\text\x = \tab\_s()\image\x + \tab\_s()\image\width + Bool(\tab\_s()\image\width) * 3
          \tab\_s()\text\y = \tab\_s()\y+(\tab\_s()\height-\tab\_s()\text\height)/2
          
          \tab\_s()\draw = Bool(Not \tab\_s()\hide And \tab\_s()\x+\tab\_s()\width>\x+\bs And \tab\_s()\x<\x+\width-\bs)
          
          If \tab\_s()\draw
            ;             DrawingMode(#PB_2DDrawing_alphaBlend|#PB_2DDrawing_gradient)
            ;             ResetGradientColors()
            ;             GradientColor(1.0, \color\back[State_3]&$FFFFFF|$FF<<24)
            ;             GradientColor(0.5, \color\back[State_3]&$FFFFFF|$A0<<24)
            ;             GradientColor(0.0, \color\back[State_3]&$FFFFFF)
            
            ;State_3 = Bool(\index[#__s_1] = \tab\_s()\index)
            ; Draw tabs back   
            If \tab\_s()\color\back[State_3]<>-1
              If \tab\_s()\color\fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              ; _box_gradient_( \Vertical, \tab\_s()\x, \tab\_s()\y, \tab\_s()\width, \tab\_s()\height, \color\fore[State_3], Bool(State_3 <> 2)*\color\back[State_3] + (Bool(State_3 = 2)*\color\front[State_3]), \round, \color\alpha)
              _box_gradient_( \Vertical, \tab\_s()\x, \tab\_s()\y, \tab\_s()\width, \tab\_s()\height, \tab\_s()\color\fore[State_3], \tab\_s()\color\back[State_3], \round, \color\alpha)
            EndIf
            
            ; Draw string
            If \tab\_s()\text\string
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\tab\_s()\text\x, \tab\_s()\text\y, \tab\_s()\text\string.s, \color\front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \tab\_s()\image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\tab\_s()\image\handle, \tab\_s()\image\x, \tab\_s()\image\y, \color\alpha)
            EndIf
            
            ; Draw tabs frame
            If \color\frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\tab\_s()\x, \tab\_s()\y, \tab\_s()\width, 1, Color_frame)                     ; top
                Line(\tab\_s()\x, \tab\_s()\y, 1, \tab\_s()\height, Color_frame)                    ; left
                Line((\tab\_s()\x+\tab\_s()\width)-1, \tab\_s()\y, 1, \tab\_s()\height, Color_frame); right
              Else
                RoundBox( \tab\_s()\x, \tab\_s()\y, \tab\_s()\width, \tab\_s()\height, \round, \round, Color_frame)
              EndIf
            EndIf
          EndIf
          
          \tab\_s()\text\change = 0
          
          If State_3 = 2
            sx = \tab\_s()\x
            sw = \tab\_s()\width
            start = Bool(\tab\_s()\x=<\x[#__c_2]+\tab\bar\button[#__b_1]\len+1 And \tab\_s()\x+\tab\_s()\width>=\x[#__c_2]+\tab\bar\button[#__b_1]\len+1)*2
            stop = Bool(\tab\_s()\x=<\x[#__c_2]+\width[#__c_2]-\tab\bar\button[#__b_2]\len-2 And \tab\_s()\x+\tab\_s()\width>=\x[#__c_2]+\width[#__c_2]-\tab\bar\button[#__b_2]\len-2)*2
          EndIf
        Next
        
        Protected max = ((\tab\_s()\x+\tab\_s()\width+\tab\bar\page\pos)-\x[#__c_2])
        If \tab\bar\max <> max : \tab\bar\max = max
          \tab\bar\area\pos = \x[#__c_2]+\tab\bar\button[#__b_1]\width
          \tab\bar\area\len = \width[#__c_2]-(\tab\bar\button[#__b_1]\len+\tab\bar\button[#__b_2]\len)
          _resize_panel_(*this, \tab\bar\button[#__b_1], \x[#__c_2])
          
          If \tab\scrolled > 0 And SelectElement(\tab\_s(), \tab\scrolled-1)
            Protected State = (\tab\bar\button[#__b_1]\len+((\tab\_s()\x+\tab\_s()\width+\tab\bar\page\pos)-\x[#__c_2]))-\tab\bar\page\len ;
                                                                                                                                           ;               Debug (\tab\bar\button[#__b_1]\len+(\tab\_s()\x+\tab\_s()\width)-\x[#__c_2])-\tab\bar\page\len
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
        
        
        Protected fabe_x, fabe_out, button_size, Size = 35, color = \parent\color\fore[\parent\color\state]
        If Not color
          color = \parent\color\back[\parent\color\state]
        EndIf
        
        
        DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
        ResetGradientColors()
        GradientColor(0.0, Color&$FFFFFF)
        GradientColor(0.5, Color&$FFFFFF|$A0<<24)
        GradientColor(1.0, Color&$FFFFFF|245<<24)
        
        
        If (\tab\bar\button[#__b_1]\x < \tab\bar\button[#__b_3]\x)
          If \tab\bar\button[#__b_2]\x < \tab\bar\button[#__b_3]\x
            button_size = \tab\bar\button[#__b_1]\len+5
          Else
            button_size = \tab\bar\button[#__b_2]\len/2+5
          EndIf
          fabe_out = Size - button_size
        Else
          fabe_out = Size
        EndIf
        
        If Not _bar_in_start_(\tab\bar) : fabe_x = \x[#__c_0]+size
          LinearGradient(fabe_x, \y+\bs, fabe_x-fabe_out, \y+\bs)
          Box(fabe_x, \y+\bs, -Size, \__height-\bs)
        EndIf
        
        If \tab\bar\button[#__b_2]\x > \tab\bar\button[#__b_3]\x
          If \tab\bar\button[#__b_1]\x > \tab\bar\button[#__b_3]\x
            button_size = \tab\bar\button[#__b_1]\len+5
          Else
            button_size = \tab\bar\button[#__b_1]\len/2+5
          EndIf
          fabe_out = Size - button_size
        Else
          fabe_out = Size
        EndIf
        
        If Not _bar_in_stop_(\tab\bar) : fabe_x= \x[#__c_0]+\width[#__c_0]-Size
          LinearGradient(fabe_x, \y+\bs, fabe_x+fabe_out, \y+\bs)
          Box(fabe_x, \y+\bs, Size, \__height-\bs)
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
        If \tab\bar\button[#__b_1]\width ;And \color[1]\state 
          _button_draw_(0,\tab\bar\button[#__b_1]\x, \tab\bar\button[#__b_1]\y+h, \tab\bar\button[#__b_1]\width, \tab\bar\button[#__b_1]\height-h*2, 
                        \tab\bar\button[#__b_1]\arrow\type, \tab\bar\button[#__b_1]\arrow\size, 0,
                        \tab\bar\button[#__b_1]\color\fore[\tab\bar\button[#__b_1]\color\state], \tab\bar\button[#__b_1]\color\back[\tab\bar\button[#__b_1]\color\state],
                        \tab\bar\button[#__b_1]\color\frame[\tab\bar\button[#__b_1]\color\state], \tab\bar\button[#__b_1]\color\front[\tab\bar\button[#__b_1]\color\state],\tab\bar\button[#__b_1]\color\alpha,\tab\bar\button[#__b_1]\round)
        EndIf
        
        ; Draw arrow right button
        If \tab\bar\button[#__b_2]\width ;And \color[2]\state 
          _button_draw_(0,\tab\bar\button[#__b_2]\x, \tab\bar\button[#__b_2]\y+h, \tab\bar\button[#__b_2]\width, \tab\bar\button[#__b_2]\height-h*2, 
                        \tab\bar\button[#__b_2]\arrow\type, \tab\bar\button[#__b_2]\arrow\size, 2,
                        \tab\bar\button[#__b_2]\color\fore[\tab\bar\button[#__b_2]\color\state], \tab\bar\button[#__b_2]\color\back[\tab\bar\button[#__b_2]\color\state], 
                        \tab\bar\button[#__b_2]\color\frame[\tab\bar\button[#__b_2]\color\state], \tab\bar\button[#__b_2]\color\front[\tab\bar\button[#__b_2]\color\state],\tab\bar\button[#__b_2]\color\alpha,\tab\bar\button[#__b_2]\round)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  
  
  
  
  ;-
  Macro _set_text_flag_(_this_, _flag_, _x_=0, _y_=0)
    ;     If Not _this_\text
    ;       _this_\text = AllocateStructure(_s_text)
    ;     EndIf
    
    If _this_\text
      _this_\text\x = _x_
      _this_\text\y = _y_
      ; _this_\text\_padding = 5
      _this_\text\change = #True
      
      _this_\text\editable = Bool(Not constants::_check_(_flag_, #__text_readonly))
      _this_\text\lower = constants::_check_(_flag_, #__text_lowercase)
      _this_\text\upper = constants::_check_(_flag_, #__text_uppercase)
      _this_\text\pass = constants::_check_(_flag_, #__text_password)
      _this_\text\invert = constants::_check_(_flag_, #__text_invert)
      
      If constants::_check_(_flag_, #__align_text)
        _this_\text\align\top = constants::_check_(_flag_, #__text_top)
        _this_\text\align\left = constants::_check_(_flag_, #__text_left)
        _this_\text\align\right = constants::_check_(_flag_, #__text_right)
        _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
        
        If constants::_check_(_flag_, #__text_center)
          _this_\text\align\horizontal = Bool(Not _this_\text\align\right And Not _this_\text\align\left)
          _this_\text\align\vertical = Bool(Not _this_\text\align\bottom And Not _this_\text\align\top)
        EndIf
      EndIf
      
      If constants::_check_(_flag_, #__text_wordwrap)
        _this_\text\multiLine =- 1
      ElseIf constants::_check_(_flag_, #__text_multiline)
        _this_\text\multiLine = 1
      Else
        _this_\text\multiLine = 0 
      EndIf
      
      If _this_\text\invert 
        _this_\text\Rotate = Bool(_this_\vertical)*270 + Bool(Not _this_\vertical)*180
      Else
        _this_\text\Rotate = Bool(_this_\vertical)*90
      EndIf
      
      If _this_\type = #__Type_Editor Or
         _this_\type = #__Type_String
        
        _this_\color\fore = 0
        _this_\text\caret\pos[1] =- 1
        _this_\text\caret\pos[2] =- 1
        _this_\cursor = #PB_Cursor_IBeam
        
        If _this_\text\editable
          _this_\text\caret\width = 1
          _this_\color\back[0] = $FFFFFFFF 
        Else
          _this_\color\back[0] = $FFF0F0F0  
        EndIf
      EndIf
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
        ;                     \text\fontID = GetGadgetFont(TextGadget) 
        ;                     FreeGadget(TextGadget)
        ;Protected FontSize.CGFloat = 12.0 ; boldSystemFontOfSize  fontWithSize
        ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
        ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
        
        ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
        ;\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
        _this_\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
        ;
        ;           \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
        ;           CocoaMessage(@FontSize, \text\fontID, "pointSize")
        ;           
        ;           ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
        
        ;  Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
        
      CompilerElse
        _this_\text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
      CompilerEndIf
    EndIf
    
  EndMacro
  
  Macro _make_line_pos_(_this_, _len_)
    _this_\row\_s()\text\len = _len_
    _this_\row\_s()\text\pos = _this_\text\pos
    _this_\text\pos + _this_\row\_s()\text\len + 1 ; Len(#LF$)
  EndMacro
  
  Macro _make_line_x_(_this_, _scroll_width_)
    If _this_\vertical
      If _this_\text\rotate = 90
        _this_\row\_s()\text\x[2] = _this_\text\x + _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      ElseIf _this_\text\rotate = 270
        _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      EndIf
      
    Else
      If _this_\text\rotate = 0
        If _this_\text\align\right
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_\row\_s()\text\width) 
        ElseIf _this_\text\align\horizontal
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_\row\_s()\text\width)/2
        Else
          _this_\row\_s()\text\x[2] = _this_\text\x
        EndIf
        
      ElseIf _this_\text\rotate = 180
        If _this_\text\align\right
          _this_\row\_s()\text\x[2] = _this_\text\x + _scroll_width_
        ElseIf _this_\text\align\horizontal
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ + _this_\row\_s()\text\width)/2 
        Else
          _this_\row\_s()\text\x[2] = _this_\text\x + _this_\row\_s()\text\width 
        EndIf
        
      EndIf
    EndIf
    
    _this_\row\_s()\text\x = _x_ + _this_\row\_s()\text\x[2] + *this\scroll\x
  EndMacro
  
  Macro _make_line_y_(_this_, _scroll_height_)
    If _this_\vertical
      If _this_\text\rotate = 90
        If _this_\text\align\bottom
          _this_\row\_s()\text\y[2] = _this_\text\y + _scroll_height_ 
        ElseIf _this_\text\align\vertical
          _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ + _this_\row\_s()\text\width)/2
        Else
          _this_\row\_s()\text\y[2] = _this_\text\y + _this_\row\_s()\text\width
        EndIf
        
      ElseIf _this_\text\rotate = 270
        If _this_\text\align\bottom
          _this_\row\_s()\text\y[2] = _this_\text\y + ((_scroll_height_ - _this_\row\_s()\text\width) ) 
        ElseIf _this_\text\align\vertical
          _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ - _this_\row\_s()\text\width)/2 
        Else
          _this_\row\_s()\text\y[2] = _this_\text\y
        EndIf
        
      EndIf
      
    Else
      If _this_\text\rotate = 0
        _this_\row\_s()\text\y[2] = _this_\text\y + _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      ElseIf _this_\text\rotate = 180
        _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      EndIf
    EndIf
    
    _this_\row\_s()\text\y = _y_ + _this_\row\_s()\text\y[2]
  EndMacro
  
  Macro _make_scroll_x_(_this_)
    If _this_\text\align\right
      _this_\scroll\x = (((_this_\width - _this_\bs*2) - _this_\scroll\align\right - _this_\text\_padding) - _this_\scroll\width)
    ElseIf _this_\text\align\horizontal
      _this_\scroll\x = (((_this_\width - _this_\bs*2) + _this_\scroll\align\left - _this_\scroll\align\right) - _this_\scroll\width + Bool(_this_\scroll\width % 2))/2 
    Else
      _this_\scroll\x = _this_\text\_padding + _this_\scroll\align\left
    EndIf
    
    If *this\scroll\x < 0
      *this\scroll\x = _this_\scroll\align\left
    EndIf
  EndMacro
  
  Macro _make_scroll_y_(_this_)
    If _this_\text\align\bottom
      _this_\scroll\y = (((_this_\height - _this_\bs*2) - _this_\scroll\align\bottom - _this_\text\_padding) - _this_\scroll\height) 
    ElseIf _this_\text\align\vertical
      _this_\scroll\y = ((((_this_\height - _this_\bs*2) + _this_\scroll\align\top - _this_\scroll\align\bottom) - _this_\scroll\height + Bool(_this_\scroll\height % 2))/2)
    Else
      _this_\scroll\y = _this_\text\_padding + _this_\scroll\align\top
    EndIf
    
    If *this\scroll\y < 0
      *this\scroll\y = _this_\scroll\align\top
    EndIf
  EndMacro
  
  Macro _make_scroll_height_(_this_, _height_)
    If _this_\vertical
      _this_\scroll\width + _height_ + _this_\flag\gridlines
    Else
      _this_\scroll\height + _height_ + _this_\flag\gridlines
    EndIf
    
    If _this_\scroll\v And 
       _this_\scroll\v\bar\scroll_step <> _height_ + Bool(_this_\flag\gridlines)
      _this_\scroll\v\bar\scroll_step = _height_ + Bool(_this_\flag\gridlines)
    EndIf
  EndMacro
  
  Macro _make_scroll_width_(_this_, _width_)
    If _this_\vertical
      If _this_\text\multiline =- 1 And _this_\scroll\height > (_this_\height[2] - _this_\text\align\height - Bool(_this_\scroll\width > _this_\width[2]) * _this_\scroll\v\height)
        _this_\scroll\height = _this_\height[2] - _this_\text\align\height - Bool(_this_\scroll\width > _this_\width[2]) * _this_\scroll\v\height
      Else
        If _this_\scroll\height < _width_ + _this_\text\x*2
          _this_\scroll\height = _width_ + _this_\text\x*2
        EndIf
      EndIf
    Else
      If _this_\text\multiline =- 1 And _this_\scroll\width > (_this_\width[2] - _this_\text\align\width - Bool(_this_\scroll\height > _this_\height[2]) * _this_\scroll\v\width)
        _this_\scroll\width = _this_\width[2] - _this_\text\align\width - Bool(_this_\scroll\height > _this_\height[2]) * _this_\scroll\v\width
      Else
        If _this_\scroll\width < _width_ + _this_\text\x*2 + *this\text\caret\width
          _this_\scroll\width = _width_ + _this_\text\x*2 + *this\text\caret\width
        EndIf
      EndIf
    EndIf
  EndMacro
  
  
  
  Procedure.s _text_wrap_(*this._s_widget, text$, softWrapPosn.i, hardWrapPosn.i=-1, delimList$=" "+Chr(9), nl$=#LF$, liStart$="")
    ; ## Main function ##
    ; -- Word wrap in *one or more lines* of a text file, or in a window with a fixed-width font
    ; in : text$       : text which is to be wrapped;
    ;                    may contain #CRLF$ (Windows), or #LF$ (Linux and modern Mac systems) as line breaks
    ;      softWrapPosn: the desired maximum length (number of characters) of each resulting line
    ;                    if a delimiter was found (not counting the length of the inserted nl$);
    ;                    if no delimiter was found at a position <= softWrapPosn, a line might
    ;                    still be longer if hardWrapPosn = 0 or > softWrapPosn
    ;      hardWrapPosn: guaranteed maximum length (number of characters) of each resulting line
    ;                    (not counting the length of the inserted nl$);
    ;                    if hardWrapPosn <> 0, each line will be wrapped at the latest at
    ;                    hardWrapPosn, even if it doesn't contain a delimiter;
    ;                    default setting: hardWrapPosn = softWrapPosn
    ;      delimList$  : list of characters which are used as delimiters;
    ;                    any delimiter in line$ denotes a position where a soft wrap is allowed
    ;      nl$         : string to be used as line break (normally #CRLF$ or #LF$)
    ;      liStart$    : string at the beginning of each list item
    ;                    (providing this information makes proper indentation possible)
    ;
    ; out: return value: text$ with given nl$ inserted at appropriate positions
    ;
    ; <http://www.purebasic.fr/english/viewtopic.php?f=12&t=53800>
    Protected.i numLines, i, indentLen=-1, length, TextWidth
    Protected line$, line1$, indent$, ret$="", ret1$="", start, start1, found, length1
    
    If hardWrapPosn > 0
      length = softWrapPosn/6
    EndIf
    
    Protected *str.Character = @text$
    Protected *End.Character = @text$
    
    If softWrapPosn > 0 And *End
      While *End\c 
        If *End\c = #LF ;And *str <> *End
          start = (*End-*str)>>#PB_Compiler_Unicode
          line$ = PeekS (*str, start)
          
          ; Get text len
          If hardWrapPosn < 0
            If length <> start
              length = start
              
              While length > 1
                If softWrapPosn > TextWidth(Left(line$, length))
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          EndIf
          
          While start > length
            For i = length To 1 Step - 1
              If FindString(" ", Mid(line$,i,1))
                start = i
                Break
              EndIf
            Next
            
            If i = 0 
              start = length
            EndIf
            
            ret$ + RTrim(Left(line$, start)) + nl$
            line$ = LTrim(Mid(line$, start+1))
            start = Len(line$)
          Wend
          
          ret$ + line$ + nl$
          
          *str = *End + #__sOC 
        EndIf 
        
        *End + #__sOC 
      Wend
    EndIf
    
    ProcedureReturn ret$
  EndProcedure
  
  Procedure.s make_multiline(*this._s_widget, text.s)
    Protected StringWidth, len, string.s
    Protected IT,Text_Y,Text_X,Width,Height, _this_y_
    Protected *str.Character
    Protected *End.Character
    
    With *This
      Protected _x_=*this\x[2], 
                _y_=*this\y[2], 
                _width_, _height_
      
      ; Make output text
      If \Vertical
        Width = \Height[#__c_2]
        Height = \Width[#__c_2]
      Else
        Width = \Width[#__c_2]
        Height = \Height[#__c_2]
      EndIf
      
      \text\pos = 0
      
      If \text\multiline
        If *this\text\multiline =- 1
          text+#LF$
        EndIf
        
        text = _text_wrap_(*this, text, Width-\text\_padding*2, \text\multiline)
        
        \count\items = 0 ; CountString(text, #LF$)
        \scroll\width = \text\x*2
        \scroll\height = \text\y*2 ; 0
        
        *str.Character = @text
        *End.Character = @text
        
        While *End\c 
          If *End\c = #LF 
            len = (*End-*str)>>#PB_Compiler_Unicode
            String = PeekS (*str, len)
            
            _make_scroll_width_(*this, TextWidth(String))
            _make_scroll_height_(*this, TextHeight(String))
            
            \count\items + 1
            
            *str = *End + #__sOC 
          EndIf 
          
          *End + #__sOC 
        Wend
        
      Else
        text + #LF$
        \count\items = 1
        \scroll\width = \text\x*2
        \scroll\height = \text\y*2 ; 0
        _make_scroll_width_(*this, TextWidth(text))
        _make_scroll_height_(*this, (\count\items * *this\text\height))
      EndIf
      
      
      _width_ = (*this\scroll\width - *this\text\x*2)
      _height_ = (*this\scroll\height - *this\text\y*2)
      
      _make_scroll_x_(*this)
      _make_scroll_y_(*this)
      
      If \count\items
        \text\len = Len(text)
        ClearList(\row\_s())
        _this_y_ = 0;*this\text\y
        
        Protected time = ElapsedMilliseconds()
        
        *str.Character = @text
        *End.Character = @text 
        
        While *End\c 
          If *End\c = #LF And AddElement(\row\_s())
            len = (*end-*str)>>#PB_Compiler_Unicode ; /#__sOC 
                                                    ;len = (*end-*str)/#__sOC 
            String = PeekS (*str, len)
            
            \row\_s()\draw = 1
            \row\_s()\y = _y_ + _this_y_
            \row\_s()\height = \text\height
            \row\_s()\text\height = \text\height
            
            \row\_s()\text\string.s = String.s
            \row\_s()\index = ListIndex(\row\_s())
            \row\_s()\text\width = TextWidth(String.s)
            \row\_s()\text\height = \text\height
            
            \row\_s()\color = _get_colors_()
            \row\_s()\color\fore[0] = 0
            \row\_s()\color\fore[1] = 0
            \row\_s()\color\fore[2] = 0
            \row\_s()\color\fore[3] = 0
            \row\_s()\color\back[0] = 0 ;\color\back[0]
            \row\_s()\color\frame[0] = 0;\row\_s()\color\frame[1]
            
            ; set entered color
            If *this\row\_s()\index = *this\index[1]
              *this\row\_s()\color\state = 1
            EndIf
            
            ; Update line pos in the text
            _make_line_pos_(*this, len)
            
            _make_line_x_(*this, _width_)
            _make_line_y_(*this, _height_)
            
            _this_y_ + *this\text\height + *this\flag\gridlines
            
            *str = *End + #__sOC 
          EndIf 
          
          *End + #__sOC 
        Wend
        
        
        ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
        Debug Str(ElapsedMilliseconds()-time) + " text parse time "
        
      EndIf
      ;             EndIf
      
      
      
      
      
      
      
      
      
      
      ; 
      If *this\scroll And *this\text\change
        If *this\scroll\v And *this\scroll\h
          Protected scroll_change.b
          
          If *this\scroll\v\bar\min <> -*this\scroll\y
            scroll_change | Bar::SetAttribute(*this\scroll\v, #__bar_minimum, -*this\scroll\y)
          EndIf
          
          If *this\scroll\h\bar\min <> -*this\scroll\x
            scroll_change | Bar::SetAttribute(*this\scroll\h, #__bar_minimum, -*this\scroll\x)
          EndIf
          
          If *this\scroll\v\bar\max <> *this\scroll\height 
            scroll_change | Bar::SetAttribute(*this\scroll\v, #__bar_maximum, *this\scroll\height)
          EndIf
          
          If *this\scroll\h\bar\max <> *this\scroll\width 
            scroll_change | Bar::SetAttribute(*this\scroll\h, #__bar_maximum, *this\scroll\width)
          EndIf
          
          If scroll_change
            Bar::Resizes(*this\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            \height[2] = \scroll\v\bar\page\len
            \width[2] = \scroll\h\bar\page\len 
          EndIf
        EndIf
        
        
        ;           ; This is for the caret and scroll when entering the key - (enter & backspace) ;
        ;           ; При вводе enter выделенную строку перемещаем в конец страницы и прокручиваем ползунок
        ;           If \scroll\v
        ;             _text_scroll_y_(*this)
        ;           EndIf 
        ;           If \scroll\h
        ;             _text_scroll_x_(*this)
        ;           EndIf 
      EndIf 
      
    EndWith 
    
    ProcedureReturn String
  EndProcedure
  
  ;-
  Procedure.i Draw(*this._s_widget, Childrens=0)
    Protected parent_item.i
    
    With *this
      If \text And \text\fontID
        DrawingFont(\text\fontID)
      EndIf
      
      ; Get text size
      If (\text And \text\change)
        \text\width = TextWidth(\text\edit\string)
        \text\height = TextHeight("A")
      EndIf
      
      If \text And (\text\change Or (\resize & #__resize_change And *this\text\multiline =- 1)) : *this\text\change = 1
        make_multiline(*this._s_widget, \text\string)
      EndIf
      
      ; 
      If \height > 0 And \width > 0 And Not \hide And Not (*this = \root And \width[#__c_4] > 0 And \height[#__c_4] > 0)
        
        ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
        ;ClipOutput(\x[#__c_5],\y[#__c_5],\width[#__c_5],\height[#__c_5])
        
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Protected i=1
          
          If \fs = 1 
            For i=1 To \round
              Line(\x[#__c_1]+i-1,\y[#__c_1]+\caption\height-1,1,Bool(\round)*(i-\round),\caption\color\back[\color\state])
              Line(\x[#__c_1]+\width[#__c_1]+i-\round-1,\y[#__c_1]+\caption\height-1,1,-Bool(\round)*(i),\caption\color\back[\color\state])
            Next
          Else
            For i=1 To \fs
              RoundBox(\x[#__c_1]+i-1, \y[#__c_2]-\fs+i-1, \width[#__c_1]-i*2+2, Bool(\height[#__c_1]-\__height>0)*(\height[#__c_1]-\__height)-i*2+2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
              RoundBox(\x[#__c_1]+i-1, \y[#__c_2]-\fs+i, \width[#__c_1]-i*2+2, Bool(\height[#__c_1]-\__height>0)*(\height[#__c_1]-\__height)-i*2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
            Next
          EndIf
        EndIf 
        
        ; Draw back
        If \color\back[\interact * \color\state]
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          ;  RoundBox(\x[#__c_2]-Bool(\fs),\y[#__c_2]-Bool(\fs),\width[#__c_2]+Bool(\fs),Bool(\height[#__c_1]-\__height-\fs*2+Bool(\fs)*2>0) * (\height[#__c_1]-\__height-\fs*2+Bool(\fs)),Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          RoundBox(\x[#__c_2],\y[#__c_2],\width[#__c_2],\height[#__c_2], Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          ;  RoundBox(\x[#__c_2]-1,\y[#__c_2]-1,\width[#__c_2]+2,\height[#__c_2]+2, Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
        EndIf
        
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          If \fs = 1 
            RoundBox(\x[#__c_1], \y[#__c_1]+\__height, \width[#__c_1], Bool(\height[#__c_1]-\__height>0) * (\height[#__c_1]-\__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
          Else
            ; draw out frame
            RoundBox(\x[#__c_1], \y[#__c_1]+\__height, \width[#__c_1], Bool(\height[#__c_1]-\__height>0) * (\height[#__c_1]-\__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            
            ; draw inner frame 
            If \type = #__Type_ScrollArea ; \scroll And \scroll\v And \scroll\h
              RoundBox(\x[#__c_2]-1, \y[#__c_2]-1, Bool(\width[#__c_1]-\fs*2>-2)*(\width[#__c_1]-\fs*2+2), 
                       Bool(\height[#__c_1]-\fs*2-\__height>-2)*(\height[#__c_1]-\fs*2-\__height+2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \scroll\v\color\line)
            Else
              RoundBox(\x[#__c_2]-1, \y[#__c_2]-1, Bool(\width[#__c_1]-\fs*2>-2)*(\width[#__c_1]-\fs*2+2), 
                       Bool(\height[#__c_1]-\fs*2-\__height>-2)*(\height[#__c_1]-\fs*2-\__height+2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            EndIf
          EndIf
        EndIf
        
        
        
        ; draw widgets
        Select \type
          Case #__Type_Window       : window_draw(*this)
          Case #__Type_Panel        : Draw_panel(*this)
          Case #__Type_Frame        : Draw_frame(*this)
            
          Case #__Type_Text         : _draw_text_(*this)
          Case #__Type_Editor       : editor::draw(*this)
          Case #__Type_String       : editor::draw(*this)
          Case #__Type_IPAddress    : editor::draw(*this)
            
          Case #__Type_Tree         : Draw_tree(*this)
          Case #__Type_property     : Draw_property(*this)
          Case #__Type_ListIcon     : Draw_listIcon(*this)
          Case #__Type_ListView     : Draw_tree(*this)
          Case #__Type_ExplorerList : Draw_listIcon(*this)
            
          Case #__Type_ComboBox     : Draw_combobox(*this)
            
          Case #__Type_Button       : Draw_button(*this)
          Case #__Type_CheckBox     : _draw_checkbox_(*this)
          Case #__Type_Option       : _draw_option_(*this)
          Case #__Type_HyperLink    : _draw_hyperlink_(*this)
            
          Case #__Type_Spin         : Draw_Spin(*this)
          Case #__Type_Splitter     : Bar_Draw(*this)
          Case #__Type_TrackBar     : Draw_track(*this)
          Case #__Type_ScrollBar    : Draw_Scroll(*this)
          Case #__Type_ProgressBar  : Draw_progress(*this)
        EndSelect
        
        ;         ; draw text
        ;         If *this\text\string
        ;           _draw_text_(*this)
        ;         EndIf
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
        
        ; Draw anchors 
        If \root And \root\anchor And \root\anchor\widget
          ;Debug \root\anchor\widget
          a_draw(\root\anchor\widget)
        EndIf
        
        ;         ; post event draw
        ;         If \root\event And 
        ;            (\root\event\type = #PB_All Or
        ;             \root\event\type = #__Event_repaint)
        ;           
        ;           SetOrigin(\x,\y)
        ;           Post(#__Event_repaint, *this)
        ;           SetOrigin(0,0)
        ;         EndIf
        
        ; Draw Childrens
        If Childrens And \count\childrens
          ForEach \childrens() 
            
            If \childrens()\width[#__c_4] > 0 And 
               \childrens()\height[#__c_4] > 0 And 
               \childrens()\tab\index = \index[#__s_2]
              
              Draw(\childrens(), Childrens) 
            EndIf
          Next
        EndIf
      EndIf
      
      
      
      ; reset 
      If \change : \change = 0 : EndIf
      If \resize & #__resize_change : \resize &~ #__resize_change : EndIf
      If \text : \text\change = 0 : EndIf
      If \image : \image\change = 0 : EndIf
      
      ; *event\type =- 1 
      ; *event\widget = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._s_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        If \root\color\back
          ;DrawingMode(#PB_2DDrawing_default)
          ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
          FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), \root\color\back)
        EndIf
        
        Draw(*this, 1)
        
        StopDrawing()
        
        If *this\root And 
           *this\root\repaint
          *this\root\repaint = #False
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  ;-
  ;- ADD & GET & SET
  ;-
  Procedure.i X(*this._s_widget, Mode.i=0)
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
  
  Procedure.i Y(*this._s_widget, Mode.i=0)
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
  
  Procedure.i Width(*this._s_widget, Mode.i=0)
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
  
  Procedure.i Height(*this._s_widget, Mode.i=0)
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
  
  Procedure.b set_hide_state(*this._s_widget, State.b)
    With *this
      ;       If \parent\index[#__s_2]  =- 1
      ;         \parent\index[#__s_2]  = 0
      ;       EndIf
      
      \hide = Bool(State Or \hide[1] Or \parent\hide Or \tab\index <> \parent\index[#__s_2])
      ;Debug  ""+\parent\type  +" "+ \parent\index[#__s_2] +" "+ \hide
      
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
  
  Procedure.b Hide(*this._s_widget, State.b=-1)
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
  
  Procedure.i CountItems(*this._s_widget)
    ProcedureReturn *this\count\items
  EndProcedure
  
  Procedure.i ClearItems(*this._s_widget) 
    With *this
      \count\items = 0
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
      ;        PostEvent(#PB_Event_gadget, \root\window, \root\canvas\gadget, #__Event_repaint)
      ;       EndIf
    EndWith
  EndProcedure
  
  Procedure.i RemoveItem(*this._s_widget, Item.i) 
    With *this
      \count\items = ListSize(\items()) ; - 1
      \text\change = 1
      
      If \count\items =- 1 
        \count\items = 0 
        \text\string = #LF$
        ;         If Not \repaint : \repaint = 1
        ;           PostEvent(#PB_Event_gadget, \root\window, \root\canvas\gadget, #__Event_repaint)
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
  
  Procedure.i Enumerate(*this.Integer, *Parent._s_widget, parent_item.i=0)
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
  
  Procedure.i IsContainer(*this._s_widget)
    ProcedureReturn *this\container
  EndProcedure
  
  
  ;- GET
  ;   Procedure.i GetAdress(*this._s_widget)
  ;     ProcedureReturn *this\adress
  ;   EndProcedure
  
  Procedure.i GetButtons(*this._s_widget)
    ProcedureReturn *this\root\mouse\buttons
  EndProcedure
  
  Procedure.i GetPush(*this._s_widget) ; pressed pulled ; get traction
    ProcedureReturn *this\root\mouse\drag
  EndProcedure
  
  Procedure.i GetMouseX(*this._s_widget)
    ProcedureReturn *this\root\mouse\x-*this\x[#__c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetMouseY(*this._s_widget)
    ProcedureReturn *this\root\mouse\y-*this\y[#__c_2]-*this\fs
  EndProcedure
  
  Procedure.i GetDeltaX(*this._s_widget)
    ProcedureReturn (*this\root\mouse\delta\x-*this\x[#__c_2]-*this\fs)
  EndProcedure
  
  Procedure.i GetDeltaY(*this._s_widget)
    ProcedureReturn (*this\root\mouse\delta\y-*this\y[#__c_2]-*this\fs)
  EndProcedure
  
  Procedure.s GetClass(*this._s_widget)
    ProcedureReturn *this\class
  EndProcedure
  
  Procedure.i GetCount(*this._s_widget)
    ProcedureReturn *this\type_index ; Parent\type_count(Hex(*this\parent)+"_"+Hex(*this\type))
  EndProcedure
  
  Procedure.i GetLevel(*this._s_widget)
    ProcedureReturn *this\level - 1
  EndProcedure
  
  Procedure.i GetRoot(*this._s_widget)
    ProcedureReturn *this\root ; Returns root element
  EndProcedure
  
  Procedure.i GetWindow(*this._s_widget)
    If _is_root_(*this)
      ProcedureReturn *this\root\window ; Returns canvas window
    Else
      ProcedureReturn *this\window ; Returns element window
    EndIf
  EndProcedure
  
  Procedure.i GetGadget(*this._s_widget)
    If _is_root_(*this)
      ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
    Else
      ProcedureReturn *this\gadget ; Returns active gadget
    EndIf
  EndProcedure
  
  Procedure.i GetParent(*this._s_widget)
    ProcedureReturn *this\parent
  EndProcedure
  
  Procedure.i GetParentItem(*this._s_widget)
    ProcedureReturn *this\tab\index
  EndProcedure
  
  Procedure.i GetPosition(*this._s_widget, Position.i)
    Protected Result.i
    
    With *this
      If *this And \parent
        ; 
        If (\type = #__Type_ScrollBar And 
            \parent\type = #__Type_ScrollArea) Or
           \parent\type = #__Type_Splitter
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
  
  Procedure.i GetState(*this._s_widget)
    Protected Result.i
    
    With *this
      Select \type
          ;         case #__Type_Option,
          ;              #__Type_checkBox 
          ;           Result = \box\checked
          ;           
        Case #__Type_Tree : Result = *this\index[#__s_2]
        Case #__Type_Panel : Result = *this\index[#__s_2]
        Case #__Type_ComboBox : Result = *this\index[#__s_2]
        Case #__Type_ListIcon : Result = *this\index[#__s_2]
        Case #__Type_ListView : Result = *this\index[#__s_2]
        Case #__Type_IPAddress : Result = *this\index[#__s_2]
          
        Case #__Type_Image : Result = \image\index
          
        Case #__Type_ScrollBar, 
             #__Type_TrackBar, 
             #__Type_ProgressBar,
             #__Type_Splitter 
          Result = *this\bar\page\pos
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._s_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #__Type_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #__Type_Splitter
          ;           select Attribute
          ;             case #PB_Splitter_firstMinimumSize : Result = \box[#__b_1]\len
          ;             case #PB_Splitter_SecondMinimumSize : Result = \box[#__b_2]\len - \box[#__b_3]\len
          ;           Endselect 
          
        Default 
          Select Attribute
            Case #__bar_minimum : Result = \bar\min  ; 1
            Case #__bar_maximum : Result = \bar\max  ; 2
            Case #__bar_inverted : Result = \bar\inverted
            Case #__bar_buttonSize : Result = \bar\button[#__b_3]\len ; scroll
            Case #__bar_direction : Result = \bar\direction
            Case #__bar_pageLength : Result = \bar\page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._s_widget, Item.i, Attribute.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #__Type_Tree
          ForEach \row\_s()
            If \row\_s()\index = Item 
              Select Attribute
                Case #PB_Tree_SubLevel
                  Result = \row\_s()\sublevel
                  
              EndSelect
              Break
            EndIf
          Next
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*this._s_widget, Item.i)
  EndProcedure
  
  Procedure.i GetItemState(*this._s_widget, Item.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #__Type_Tree,
             #__Type_ListView
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemData(*this._s_widget, Item.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #__Type_Tree,
             #__Type_ListView
          PushListPosition(\row\_s()) 
          ForEach \row\_s()
            If \row\_s()\index = Item 
              Result = \row\_s()\data
              ; Debug \row\_s()\text\string
              Break
            EndIf
          Next
          PopListPosition(\row\_s())
      EndSelect
    EndWith
    
    ;     If Result
    ;       Protected *w._s_widget = Result
    ;       
    ;       Debug "GetItemData "+Item +" "+ Result +" "+  *w\class
    ;     EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._s_widget, Item.i, Column.i=0)
    Protected Result.s
    
    With *this
      
      Select \type
        Case #__Type_Tree,
             #__Type_ListView
          
          ForEach \row\_s()
            If \row\_s()\index = Item 
              Result = \row\_s()\text\string.s
              Break
            EndIf
          Next
          
        Case #__Type_ListIcon
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
  
  Procedure.i GetData(*this._s_widget)
    ProcedureReturn *this\data
  EndProcedure
  
  Procedure.i GetImage(*this._s_widget)
    ProcedureReturn *this\image\index
  EndProcedure
  
  Procedure.s GetText(*this._s_widget)
    If *this\text
      ProcedureReturn *this\text\string.s
    EndIf
  EndProcedure
  
  Procedure.i GetType(*this._s_widget)
    ProcedureReturn *this\type
  EndProcedure
  
  
  ;- SET
  Procedure.i SetAlignment(*this._s_widget, Mode.i, Type.i=1)
    
    With *this
      Select Type
        Case 1 ; widget
          If \parent
            If Not \align
              \align.structures::_s_align = AllocateStructure(structures::_s_align)
            EndIf
            
            If Bool(Mode&#__flag_autoSize=#__flag_autoSize)
              \align\top = Bool(Not Mode&#__align_bottom)
              \align\left = Bool(Not Mode&#__align_right)
              \align\right = Bool(Not Mode&#__align_left)
              \align\bottom = Bool(Not Mode&#__align_top)
              \align\autoSize = 0
              
              ; Auto dock
              Static y2,x2,y1,x1
              Protected width = #PB_Ignore
              Protected height = #PB_Ignore
              
              If \align\left And \align\right
                \x = x2
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              If \align\top And \align\bottom 
                \y = y2
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              
              If \align\left And Not \align\right
                \x = x2
                \y = y2
                x2 + \width
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              If \align\right And Not \align\left
                \x = \parent\width[#__c_2] - \width - x1
                \y = y2
                x1 + \width
                height = \parent\height[#__c_2] - y1 - y2
              EndIf
              
              If \align\top And Not \align\bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              If \align\bottom And Not \align\top
                \x = 0
                \y = \parent\height[#__c_2] - \height - y1
                y1 + \height
                width = \parent\width[#__c_2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
            Else
              \align\top = Bool(Mode&#__align_top=#__align_top)
              \align\left = Bool(Mode&#__align_left=#__align_left)
              \align\right = Bool(Mode&#__align_right=#__align_right)
              \align\bottom = Bool(Mode&#__align_bottom=#__align_bottom)
              
              If Bool(Mode&#__align_center=#__align_center)
                \align\horizontal = Bool(Not \align\right And Not \align\left)
                \align\vertical = Bool(Not \align\bottom And Not \align\top)
              EndIf
            EndIf
            
            If \align\right
              If \align\left
                \align\width = \parent\width[#__c_2] - \width
              Else
                \align\width = \parent\width[#__c_2] - (\x-\parent\x[#__c_2]) ; \parent\width[#__c_2] - (\parent\width[#__c_2] - \width)
              EndIf
            EndIf
            
            If \align\bottom
              If \align\top
                \align\height = \parent\height[#__c_2] - \height
              Else
                \align\height = \parent\height[#__c_2] - (\y-\parent\y[#__c_2]) ; \parent\height[#__c_2] - (\parent\height[#__c_2] - \height)
              EndIf
            EndIf
            
            ; update parent childrens coordinate
            Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i SetTransparency(*this._s_widget, Transparency.a) ; opacity
    Protected Result.i
    
    With *this
      \color\alpha = Transparency
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s SetClass(*this._s_widget, Class.s)
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
  
  Procedure.i SetParent(*this._s_widget, *Parent._s_widget, parent_item.l=0)
    Protected x.l, y.l, *LastParent._s_widget
    
    With *this
      If *this > 0 
        widget() = *this
        
        ; set first item
        If parent_item =- 1
          parent_item = 0 
        EndIf
        
        ; set root parent
        If Not *Parent\type And *this <> *Parent\parent
          ;  Debug ""+*this+" "+*Parent+" "+*Parent\parent+" "+*Parent\type
          *Parent = *Parent\parent
        EndIf
        
        If *Parent <> \parent Or \tab\index <> parent_item : \tab\index = parent_item
          If \parent And 
             \parent <> *Parent And 
             \parent\count\childrens > 0
            
            ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) 
            DeleteElement(\parent\childrens())  
            
            If \parent\root <> *Parent\root
              \root\count\childrens - 1
            EndIf
            
            \parent\count\childrens - 1
            *LastParent = \parent
          EndIf
          
          \parent = *Parent
          \root = *Parent\root
          \index = \root\count\childrens : \root\count\childrens + 1 
          
          If \parent = \root
            \window = \parent
          Else
            \window = \parent\window
            \parent\count\childrens + 1 
            \level = \parent\level + 1
          EndIf
          
          ; Add new children to the parent
          LastElement(\parent\childrens()) 
          \adress = AddElement(\parent\childrens())
          \parent\childrens() = *this 
          
          ; ???????? ??? ??????? ???????? ????????,
          ; ? ????? ??? ??? ??????????? ???? ?? ??????
          \hide = Bool(\parent\hide Or \tab\index <> \parent\index[#__s_2])
          
          ; Make count type
          If \window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\type))
            typecount(Hex(\window)+"_"+Hex(\type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\type))
            typecount(Hex(\parent)+"__"+Hex(\type)) + 1
          EndIf
          
          If *LastParent
            \root\repaint = #True
            
            If \scroll
              If \scroll\v
                \scroll\v\root = \root
                \scroll\v\window = \window
              EndIf
              If \scroll\h
                \scroll\v\root = \root
                \scroll\h\window = \window
              EndIf
            EndIf
            
            x = \x[#__c_3]
            y = \y[#__c_3]
            
            If \parent\scroll And \parent\scroll\v And \parent\scroll\h
              ; for the scroll area childrens
              x-\parent\scroll\h\bar\page\pos
              y-\parent\scroll\v\bar\page\pos
            EndIf
            
            Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
            
            If *LastParent <> *Parent And 
               *LastParent\root <> *Parent\root
              
              Select Root()
                Case *LastParent\root : ReDraw(*Parent)
                Case *Parent\root     : ReDraw(*LastParent)
              EndSelect
            EndIf
          EndIf
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetPosition(*this._s_widget, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
    With *this
      If _is_root_(*this)
        ProcedureReturn
      EndIf
      
      If \parent And \parent\count\childrens
        ;
        If (\type = #__Type_ScrollBar And \parent\type = #__Type_ScrollArea) Or
           \parent\type = #__Type_Splitter
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
  
  Procedure.i SetActive(*this._s_widget)
    Protected Result.i
    
    Macro _set_active_state_(_active_, _state_)
      _active_\color\state = (_state_)
      
      If Not(_active_ = _active_\root And _active_\root\type =- 5)
        If (_state_)
          Events(_active_, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
        Else
          Events(_active_, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
        EndIf
        
        PostEvent(#PB_Event_Gadget, _active_\root\window, _active_\root\canvas\gadget, #__Event_repaint)
      EndIf
      
      If _active_\gadget
        _active_\gadget\color\state = (_state_)
        
        If (_state_)
          Events(_active_\gadget, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
        Else
          Events(_active_\gadget, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
        EndIf
      EndIf
    EndMacro
    
    With *this
      If \type > 0 And GetActive()
        If GetActive()\gadget <> *this
          If GetActive() <> \window
            If _is_widget_(GetActive())
              _set_active_state_(GetActive(), #__s_0)
            EndIf
            
            GetActive() = \window
            GetActive()\gadget = *this
            
            _set_active_state_(GetActive(), #__s_2)
          Else
            If GetActive()\gadget
              GetActive()\gadget\color\state = #__s_0
              Events(GetActive()\gadget, #__Event_LostFocus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
            EndIf
            
            GetActive()\gadget = *this
            GetActive()\gadget\color\state = #__s_2
            Events(GetActive()\gadget, #__Event_Focus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
          EndIf
          
          Result = #True 
        EndIf
        
      ElseIf GetActive() <> *this
        If _is_widget_(GetActive())
          _set_active_state_(GetActive(), #__s_0)
        EndIf
        
        GetActive() = *this
        
        ;If _is_widget_(GetActive())
        _set_active_state_(GetActive(), #__s_2)
        ;EndIf
        Result = #True
      EndIf
      
      SetPosition(GetActive(), #PB_List_Last)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFlag(*this._s_widget, Flag.i)
    
    With *this
      If Flag&#__flag_anchorsGadget=#__flag_anchorsGadget
        ;         a_add(*this)
        a_resize(*this)
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*this._s_widget, FontID.i)
    
    With *this
      \text\fontID = FontID
      \text\change = 1
      
    EndWith
    
  EndProcedure
  
  Procedure.i SetText(*this._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    
    With *this
      
      Select \type
        Case #__Type_Editor : ProcedureReturn editor::settext(*this, text)
          
      EndSelect
      
      If \text And \text\edit\string <> Text.s
        \text\edit\string = Text.s ; Text_make(*this, Text.s)
        
        If \text\edit\string
          If \text\multiline
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \text\multiline > 0
              Text.s + #LF$
            EndIf
            
            \text\edit\string = Text.s
            \count\items = CountString(\text\edit\string, #LF$)
          Else
            \text\edit\string = RemoveString(\text\edit\string, #LF$) ; + #LF$
                                                                      ; \text\string.s = RTrim(ReplaceString(\text\edit\string, #LF$, " ")) + #LF$
          EndIf
          
          \text\string.s = \text\edit\string
          \text\len = Len(\text\edit\string)
          \text\change = #True
          Result = #True
          
          If IsGadget(*this\root\canvas\gadget)
            redraw(*this)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*this._s_widget, State.i)
    Protected Result.b, Direction.i ; ??????????? ? ??????? ??????? (?????,????,?????,??????)
    _set_repaint_(*this)
    
    With *this
      If *this > 0
        Select \type
          Case #__Type_IPAddress
            If \index[#__s_2] <> State : \index[#__s_2] = State
              SetText(*this, Str(IPAddressField(State,0))+"."+
                             Str(IPAddressField(State,1))+"."+
                             Str(IPAddressField(State,2))+"."+
                             Str(IPAddressField(State,3)))
            EndIf
            
          Case #__Type_CheckBox
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
            
          Case #__Type_Option
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
            
          Case #__Type_ComboBox
            Protected *t._s_widget = \popup\childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\count\items - 1 : State = *t\count\items - 1 :  EndIf
            
            If *t\index[#__s_2] <> State
              If *t\index[#__s_2] >= 0 And SelectElement(*t\row\_s(), *t\index[#__s_2]) 
                *t\row\_s()\color\state = 0
              EndIf
              
              *t\index[#__s_2] = State
              \index[#__s_2] = State
              
              If SelectElement(*t\row\_s(), State)
                *t\row\_s()\color\state = 2
                *t\change = State+1
                
                \text\edit\string = *t\row\_s()\text\string
                \text\string = \text\edit\string
                ;                 \text[1]\string = \text\edit\string
                ;                 \text\caret\pos[1] = 1
                ;                 \row\caret\end = \text\caret\pos[1]
                \text\change = 1
                
                ;w_Events(*this, #__Event_change, State)
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #__Type_Tree, #__Type_ListView
            ; ;             If State < 0 : State = 0 : EndIf
            ; ;             If State > \count\items - 1 : State = \count\items - 1 :  EndIf
            ; ;             
            ; ;             If \index[#__s_2] <> State
            ; ;               If \index[#__s_2] >= 0 And 
            ; ;                  selectElement(\row\_s(), \index[#__s_2]) 
            ; ;                 \row\_s()\color\state = 0
            ; ;               EndIf
            ; ;               
            ; ;               \index[#__s_2] = State
            ; ;               
            ; ;               If selectElement(\row\_s(), \index[#__s_2])
            ; ;                 \row\_s()\color\state = 2
            ; ;                 \change = \index[#__s_2]+1
            ; ;                 ; w_Events(*this, #__Event_change, \index[#__s_2])
            ; ;               EndIf
            ; ;               
            ; ;               ProcedureReturn 1
            ; ;             EndIf
            ; ;             
            Result = tree_SetState(*this, State)
            
          Case #__Type_Image
            _set_image_(*this, *this, State) 
            Result = *this\image\change
            
            If Result
              If \scroll
                SetAttribute(\scroll\v, #__bar_maximum, \image\height)
                SetAttribute(\scroll\h, #__bar_maximum, \image\width)
                
                \resize = #__resize_x|#__resize_y|#__resize_width|#__resize_height|#__resize_change
                Resize(*this, \x, \y, \width, \height) 
                \resize = 0
              EndIf
            EndIf
            
          Case #__Type_Panel
            If State < 0 : State = 0 : EndIf
            If State > \count\items - 1 : State = \count\items - 1 :  EndIf
            
            If \index[#__s_2] <> State : \index[#__s_2] = State
              
              ForEach \childrens()
                set_hide_state(\childrens(), Bool(\childrens()\tab\index<>\index[#__s_2]))
              Next
              
              ;\tab\selected = selectElement(\tab\_s(), State)
              
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
  
  Procedure.i SetAttribute(*this._s_widget, Attribute.i, Value.i)
    Protected Resize.i
    _set_repaint_(*this)
    
    With *this
      If *this > 0
        Select \type
          Case #__Type_Button
            Select Attribute 
              Case #PB_Button_Image
                _set_image_(*this, *this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #__Type_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \bar\button[#__b_1]\len = Value
              Case #PB_Splitter_SecondMinimumSize : \bar\button[#__b_2]\len = \bar\button[#__b_3]\len + Value
            EndSelect 
            
            If \bar\Vertical
              \bar\area\pos = \y+\bar\button[#__b_1]\len
              \bar\area\len = (\height-\bar\button[#__b_1]\len-\bar\button[#__b_2]\len)
            Else
              \bar\area\pos = \x+\bar\button[#__b_1]\len
              \bar\area\len = (\width-\bar\button[#__b_1]\len-\bar\button[#__b_2]\len)
            EndIf
            
            ProcedureReturn 1
            
          Case #__Type_Image
            Select Attribute
              Case #__displayMode
                
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
  
  Procedure.i SetData(*this._s_widget, *data)
    Protected Result.i
    
    With *this
      \data = *data
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetImage(*this._s_widget, Image.i)
    If *this And *this\image And *this\image\index <> Image
      _set_item_image_(*this, *this, Image)
      ProcedureReturn *this\image\change
    EndIf
  EndProcedure
  
  Procedure.i SetColor(*this._s_widget, ColorType.i, Color.i, State.i=0, Item.i=0)
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
          Case #__color_line
            If \color[Item]\line[State] <> Color 
              \color[Item]\line[State] = Color
              Result = #True
            EndIf
            
          Case #__color_back
            If \color[Item]\back[State] <> Color 
              \color[Item]\back[State] = Color
              Result = #True
            EndIf
            
          Case #__color_front
            If \color[Item]\front[State] <> Color 
              \color[Item]\front[State] = Color
              Result = #True
            EndIf
            
          Case #__color_frame
            If \color[Item]\frame[State] <> Color 
              \color[Item]\frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetCursor(*this._s_widget)
    ProcedureReturn *this\cursor
  EndProcedure
  
  Procedure.i SetCursor(*this._s_widget, Cursor.i, CursorType.i=#PB_Canvas_Cursor)
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
  Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result
    
    With *this
      If Item =- 1
        PushListPosition(\row\_s()) 
        ForEach \row\_s()
          Select ColorType
            Case #__color_back
              \row\_s()\color\back[Column] = Color
              
            Case #__color_front
              \row\_s()\color\front[Column] = Color
              
            Case #__color_frame
              \row\_s()\color\frame[Column] = Color
              
            Case #__color_line
              \row\_s()\color\line[Column] = Color
              
          EndSelect
        Next
        PopListPosition(\row\_s()) 
        
      Else
        If Item >= 0 And Item < ListSize(*this\row\_s()) And SelectElement(*this\row\_s(), Item)
          Select ColorType
            Case #__color_back
              \row\_s()\color\back[Column] = Color
              
            Case #__color_front
              \row\_s()\color\front[Column] = Color
              
            Case #__color_frame
              \row\_s()\color\frame[Column] = Color
              
            Case #__color_line
              \row\_s()\color\line[Column] = Color
              
          EndSelect
        EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetItemAttribute(*this._s_widget, Item.i, Attribute.i, Value.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #__Type_Panel
          If SelectElement(\tab\_s(), Item)
            Select Attribute 
              Case #PB_Button_Image
                _set_image_(*this, \tab\_s(), Value) 
                Result = \tab\_s()\image\change
            EndSelect
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._s_widget, Item.i, Image.i)
    If Item >= 0 And Item < *this\count\items And SelectElement(*this\row\_s(), Item)
      If *this\row\_s()\image\index <> Image
        _set_item_image_(*this, *this\row\_s(), Image)
        _tree_items_repaint_(*this)
        
        ProcedureReturn *this\row\_s()\image\change
      EndIf
    EndIf
  EndProcedure
  
  Procedure.i SetItemState(*this._s_widget, Item.i, State.i)
    Protected Result, sublevel
    
    With *this
      Select \type
        Case #__Type_ListView
          If (\flag\multiselect Or \flag\clickselect)
            Result = SelectElement(\row\_s(), Item) 
            If Result 
              \row\_s()\color\state = Bool(State)+1
            EndIf
          EndIf
          
        Case #__Type_Tree
          Result = tree_SetItemState(*this, Item, State)
          
      EndSelect     
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemData(*this._s_widget, Item.i, *Data)
    Protected Result.i;, *w._s_widget = *Data
    
    ;Debug "SetItemData "+Item +" "+ *Data ;+" "+  *w\index
    ;     
    With *this
      PushListPosition(\row\_s()) 
      ForEach \row\_s()
        If \row\_s()\index = Item  ;  ListIndex(\row\_s()) = Item ;  
          \row\_s()\data = *Data
          Break
        EndIf
      Next
      PopListPosition(\row\_s())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemText(*this._s_widget, Item.i, Text.s)
    Protected Result.i
    ;     Debug *this
    ;     
    ;     If Not *this
    ;       ProcedureReturn
    ;     EndIf
    
    With *this
      ForEach \row\_s()
        If \row\_s()\index = Item 
          
          ;           If \type = #__Type_property
          ;             \row\_s()\text[1]\string.s = Text
          ;           Else
          \row\_s()\text\string.s = Text
          ;           EndIf
          
          ;\row\_s()\text\string.s = Text.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;- ADD
  ;-
  Procedure.i AddItem_tree(*this._s_widget, position.l, Text.s, Image.i=-1, subLevel.i=0)
    Protected handle, *parent.structures::_s_rows
    
    With *this
      If *this
        If sublevel =- 1
          *parent = *this
          \flag\option_group = 12
          \flag\checkBoxes = \flag\option_group
        EndIf
        
        If \flag\option_group
          If subLevel > 1
            subLevel = 1
          EndIf
        EndIf
        
        ;{ ?????????? ?????????????
        If position < 0 Or position > ListSize(\row\_s()) - 1
          LastElement(\row\_s())
          handle = AddElement(\row\_s()) 
          position = ListIndex(\row\_s())
        Else
          handle = SelectElement(\row\_s(), position)
          
          Protected Lastlevel, Parent, mac = 0
          If mac 
            PreviousElement(\row\_s())
            If \row\_s()\sublevel = sublevel
              Lastlevel = \row\_s()\sublevel 
              \row\_s()\childrens = 0
            EndIf
            SelectElement(\row\_s(), position)
          Else
            If sublevel < \row\_s()\sublevel
              sublevel = \row\_s()\sublevel  
            EndIf
          EndIf
          
          handle = InsertElement(\row\_s())
          
          If mac And subLevel = Lastlevel
            \row\_s()\childrens = 1
            Parent = \row\_s()
          EndIf
          
          ; ?????????? ????????????? ?????  
          PushListPosition(\row\_s())
          While NextElement(\row\_s())
            \row\_s()\index = ListIndex(\row\_s())
            
            If mac And \row\_s()\sublevel = sublevel + 1
              \row\_s()\parent = Parent
            EndIf
          Wend
          PopListPosition(\row\_s())
        EndIf
        ;}
        
        If handle
          ;;;; \row\_s() = AllocateStructure(_s_rows) ? ??? setstate ???????? ?????????
          ;\row\_s()\handle = handle
          
          If \row\sublevellen
            If Not position
              \row\first = \row\_s()
            EndIf
            
            If subLevel
              If sublevel>position
                sublevel=position
              EndIf
              
              PushListPosition(\row\_s())
              While PreviousElement(\row\_s()) 
                If subLevel = \row\_s()\sublevel
                  *parent = \row\_s()\parent
                  Break
                ElseIf subLevel > \row\_s()\sublevel
                  *parent = \row\_s()
                  Break
                EndIf
              Wend 
              PopListPosition(\row\_s())
              
              If *parent
                If subLevel > *parent\sublevel
                  sublevel = *parent\sublevel + 1
                  *parent\childrens + 1
                  
                  If \flag\collapse
                    *parent\box[0]\checked = 1 
                    \row\_s()\hide = 1
                  EndIf
                EndIf
                \row\_s()\parent = *parent
              EndIf
              
              \row\_s()\sublevel = sublevel
            EndIf
          EndIf
          
          ; set option group
          If \flag\option_group 
            If \row\_s()\parent
              \row\_s()\option_group = \row\_s()\parent
            Else
              \row\_s()\option_group = *this
            EndIf
          EndIf
          
          ; add lines
          \row\_s()\index = position
          
          \row\_s()\color = _get_colors_()
          \row\_s()\color\state = 0
          
          \row\_s()\color\back = 0;\color\back 
          \row\_s()\color\frame = 0;\color\back 
          
          \row\_s()\color\fore[0] = 0 
          \row\_s()\color\fore[1] = 0
          \row\_s()\color\fore[2] = 0
          \row\_s()\color\fore[3] = 0
          
          If Text
            \row\_s()\text\string = StringField(Text.s, 1, #LF$)
            \row\_s()\text\change = 1
          EndIf
          
          _set_item_image_(*this, \row\_s(), Image)
          
          If \flag\buttons
            \row\_s()\box[0]\width = \flag\buttons
            \row\_s()\box[0]\height = \flag\buttons
          EndIf
          
          If \flag\checkBoxes Or \flag\option_group
            \row\_s()\box[1]\width = \flag\checkBoxes
            \row\_s()\box[1]\height = \flag\checkBoxes
          EndIf
          
          If \row\sublevellen 
            If (\flag\buttons Or \flag\lines)
              \row\_s()\sublevellen = \row\_s()\sublevel * \row\sublevellen + Bool(\flag\buttons) * 19 + Bool(\flag\checkBoxes) * 18
            Else
              \row\_s()\sublevellen =  Bool(\flag\checkBoxes) * 18 
            EndIf
          EndIf
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = *this\row\_s() 
            *this\row\selected\color\state = 2 + Bool(GetActive()<>*this)
          EndIf
          
          _tree_items_repaint_(*this)
          \count\items + 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn handle
  EndProcedure
  
  Procedure AddItem_listIcon(*this._s_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last.structures::_s_items, *parent.structures::_s_items
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
        
        ;{ ?????????? ?????????????
        If 0 > Item Or Item > ListSize(\columns()\items()) - 1
          LastElement(\columns()\items())
          AddElement(\columns()\items()) 
          Item = ListIndex(\columns()\items())
        Else
          SelectElement(\columns()\items(), Item)
          ;       PreviousElement(\columns()\items())
          ;       If*parent\sublevel = \columns()\items()\sublevel
          ;         *parent = \columns()\items()
          ;       EndIf
          
          ;       selectElement(\columns()\items(), Item)
          If *parent\sublevel = *last\sublevel
            *parent = *last
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
        
        \columns()\items() = AllocateStructure(structures::_s_items)
        ;\columns()\items()\box = AllocateStructure(_s_box)
        
        If subLevel
          If sublevel>ListIndex(\columns()\items())
            sublevel=ListIndex(\columns()\items())
          EndIf
        EndIf
        
        If *parent
          If subLevel = *parent\subLevel 
            \columns()\items()\parent = *parent\Parent
          ElseIf subLevel > *parent\subLevel 
            \columns()\items()\parent = *parent
            *last = \columns()\items()
          ElseIf *parent\Parent
            \columns()\items()\parent = *parent\Parent\Parent
          EndIf
          
          If \columns()\items()\parent And subLevel > \columns()\items()\parent\subLevel
            sublevel = \columns()\items()\parent\sublevel + 1
            \columns()\items()\parent\childrens + 1
            ;             \columns()\items()\parent\box\checked = 1
            ;             \columns()\items()\hide = 1
          EndIf
        Else
          \columns()\items()\parent = \columns()\items()
        EndIf
        
        
        *parent = \columns()\items()
        ;\columns()\items()\change = 1
        \columns()\items()\index= Item
        ;\columns()\items()\index[#__s_1] =- 1
        \columns()\items()\text\change = 1
        \columns()\items()\text\string.s = Text.s
        \columns()\items()\sublevel = sublevel
        \columns()\items()\height = \text\height
        
        _set_image_(*this, \columns()\items(), Image)
        
        \columns()\items()\y = \scroll\height
        \scroll\height + \columns()\items()\height
        
        \image\handle = \columns()\items()\image\handle
        \image\width = \columns()\items()\image\width+4
        \count\items + 1
        
        
        \columns()\items()\text\string.s = StringField(Text.s, ListIndex(\columns()) + 1, #LF$)
        \columns()\color = _get_colors_()
        \columns()\color\fore[0] = 0 
        \columns()\color\fore[1] = 0
        \columns()\color\fore[2] = 0
        
        \columns()\items()\y = \scroll\height
        \columns()\items()\height = height
        ;\columns()\items()\change = 1
        
        \image\width = \columns()\items()\image\width
        ;         If ListIndex(\columns()\items()) = 0
        ;           PostEvent(#PB_Event_gadget, \root\window, \root\canvas\gadget, #__Event_repaint)
        ;         EndIf
      Next
      
      \scroll\height + height
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure AddItem_property(*this._s_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *adress.structures::_s_items
    
    If Not *this
      ProcedureReturn 0
    EndIf
    
    With *this
      ;{ ?????????? ?????????????
      If Item =- 1 Or Item > ListSize(\row\_s()) - 1
        LastElement(\row\_s())
        AddElement(\row\_s()) 
        Item = ListIndex(\row\_s())
      Else
        SelectElement(\row\_s(), Item)
        If \row\_s()\sublevel>sublevel
          sublevel=\row\_s()\sublevel 
        EndIf
        
        InsertElement(\row\_s())
        
        PushListPosition(\row\_s())
        While NextElement(\row\_s())
          \row\_s()\index= ListIndex(\row\_s())
        Wend
        PopListPosition(\row\_s())
      EndIf
      ;}
      
      ;\row\_s() = AllocateStructure(_s_items)
      ;\row\_s()\box = AllocateStructure(_s_box)
      
      If subLevel
        If sublevel>ListIndex(\row\_s())
          sublevel=ListIndex(\row\_s())
        EndIf
        
        PushListPosition(\row\_s()) 
        While PreviousElement(\row\_s()) 
          If subLevel = \row\_s()\subLevel
            *adress = \row\_s()\parent
            Break
          ElseIf subLevel > \row\_s()\subLevel
            *adress = \row\_s()
            Break
          EndIf
        Wend 
        PopListPosition(\row\_s()) 
        
        If *adress
          If subLevel > *adress\subLevel
            sublevel = *adress\sublevel + 1
            *adress\childrens + 1
            ;             *adress\box\checked = 1
            ;             \row\_s()\hide = 1
          EndIf
        EndIf
      EndIf
      
      ;\row\_s()\change = 1
      \row\_s()\index= Item
      ;\row\_s()\index[#__s_1] =- 1
      \row\_s()\parent = *adress
      \row\_s()\text\change = 1
      
      Protected Type$ = Trim(StringField(Text, 1, " "))
      Protected Info$ = Trim(StringField(Text, 2, " ")) 
      
      If sublevel
        If Info$ : Info$+":" : EndIf
      EndIf
      
      Protected Title$ = Trim(StringField(Text, 3, " "))
      
      
      \row\_s()\text\string.s = Info$
      ;;\row\_s()\text[1]\string.s = Title$
      \row\_s()\sublevel = sublevel
      \row\_s()\height = \text\height
      
      _set_image_(*this, \row\_s(), Image)
      \count\items + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure AddItem_panel(*this._s_widget, Item.i, Text.s, Image.i=-1, sublevel.i=0)
    With *this
      If (Item =- 1 Or Item > ListSize(\tab\_s()) - 1)
        LastElement(\tab\_s())
        AddElement(\tab\_s()) 
        Item = ListIndex(\tab\_s())
      Else
        SelectElement(\tab\_s(), Item)
        
        ForEach \childrens()
          If \childrens()\tab\index = Item
            \childrens()\tab\index + 1
          EndIf
        Next
        
        InsertElement(\tab\_s())
        
        PushListPosition(\tab\_s())
        While NextElement(\tab\_s())
          \tab\_s()\index = ListIndex(\tab\_s())
        Wend
        PopListPosition(\tab\_s())
      EndIf
      
      \tab\_s()\color = _get_colors_()
      \tab\_s()\index = Item
      \tab\_s()\text\change = 1
      \tab\_s()\text\string = Text.s
      \tab\_s()\height = \__height
      
      ; last opened item of the parent
      \tab\opened = \tab\_s()\index
      \count\items + 1 
      
      _set_image_(*this, \tab\_s(), Image)
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  ;-
  Procedure.i AddItem(*this._s_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *this
      ;       If Not *this
      ;         ProcedureReturn 0
      ;       EndIf
      
      Select \type
        Case #__Type_Panel
          ProcedureReturn AddItem_panel(*this, Item, Text.s, Image, Flag)
          
        Case #__Type_property
          ProcedureReturn AddItem_property(*this, Item,Text.s,Image, Flag)
          
        Case #__Type_Tree, #__Type_ListView
          ProcedureReturn AddItem_tree(*this, Item,Text.s,Image, Flag)
          
        Case #__Type_Editor
          ProcedureReturn editor::additem(*this, Item, Text.s, Image, Flag)
          
        Case #__Type_ListIcon
          ProcedureReturn AddItem_listIcon(*this, Item,Text.s,Image, Flag)
          
        Case #__Type_ComboBox
          Protected *Tree._s_widget = \popup\childrens()
          
          LastElement(*Tree\row\_s())
          AddElement(*Tree\row\_s())
          
          ;*Tree\row\_s() = AllocateStructure(_s_items)
          ;           *Tree\row\_s()\box[0] = AllocateStructure(_s_box)
          ;           *Tree\row\_s()\box[1] = AllocateStructure(_s_box)
          
          *Tree\row\_s()\index = ListIndex(*Tree\row\_s())
          *Tree\row\_s()\text\string = Text.s
          *Tree\row\_s()\text\change = 1
          *Tree\row\_s()\height = \text\height
          *Tree\count\items + 1 
          
          *Tree\row\_s()\y = *Tree\scroll\height
          *Tree\scroll\height + *Tree\row\_s()\height
          
          _set_image_(*Tree, *Tree\row\_s(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  Procedure.i AddColumn(*this._s_widget, Position.i, Title.s, Width.i)
    With *this
      LastElement(\columns())
      AddElement(\columns()) 
      \columns() = AllocateStructure(_s_widget)
      
      If Position =- 1
        Position = ListIndex(\columns())
      EndIf
      
      \columns()\index[#__s_1] =- 1
      \columns()\index[#__s_2] =- 1
      \columns()\index = Position
      \columns()\width = Width
      
      ; \columns(); \image = AllocateStructure(_s_image)
      \columns()\image\x[1] = 5
      
      ; \columns(); \text = AllocateStructure(_s_text)
      \columns()\text\string.s = Title.s
      \columns()\text\change = 1
      
      \columns()\x = \x[#__c_2]+\scroll\width
      \columns()\height = \__height
      \scroll\height = \bs*2+\columns()\height
      \scroll\width + Width + 1
    EndWith
  EndProcedure
  
  ;-
  Procedure.i _Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
        Protected.l Change_x, Change_y, Change_width, Change_height
        
        With *this
          If X<>#PB_Ignore 
            If \parent 
              \x[#__c_3] = X 
              X+\parent\x[#__c_2] 
            EndIf 
            
            If \x <> X 
              Change_x = x-\x 
              \x = X 
              \x[#__c_2] = \x+\bs 
              \x[#__c_1] = \x[#__c_2]-\fs 
              
              If \parent And \parent\x[#__c_2] > \x And 
                 \parent\x[#__c_2] > \parent\x[#__c_4]
                \x[#__c_4] = \parent\x[#__c_2]
              ElseIf \parent And \parent\x[#__c_4] > \x 
                \x[#__c_4] = \parent\x[#__c_4]
              Else
                \x[#__c_4] = \x
              EndIf
              
              \resize | #__resize_x | #__resize_change
            EndIf 
          EndIf  
          
          If Y<>#PB_Ignore 
            If \parent 
              \y[#__c_3] = y 
              y+\parent\y[#__c_2] 
            EndIf 
            
            If \y <> y 
              Change_y = y-\y 
              \y = y 
              \y[#__c_1] = \y+\bs-\fs 
              \y[#__c_2] = \y+\bs+\__height
              
              If \parent And \parent\y[#__c_2] > \y And 
                 \parent\y[#__c_2] > \parent\y[#__c_4]
                \y[#__c_4] = \parent\y[#__c_2]
              ElseIf \parent And \parent\y[#__c_4] > \y 
                \y[#__c_4] = \parent\y[#__c_4]
              Else
                \y[#__c_4] = \y
              EndIf
              
              \resize | #__resize_y | #__resize_change
            EndIf 
          EndIf  
          
          If width <> #PB_Ignore 
            If width < 0 : width = 0 : EndIf
            
            If \width <> width 
              Change_width = width-\width 
              \width = width 
              \width[#__c_2] = \width-\bs*2 
              \width[#__c_1] = \width[#__c_2]+\fs*2 
              If \width[#__c_1] < 0 : \width[#__c_1] = 0 : EndIf
              If \width[#__c_2] < 0 : \width[#__c_2] = 0 : EndIf
              \width[#__c_3] = \width[#__c_2]
              \resize | #__resize_width | #__resize_change
            EndIf 
          EndIf  
          
          If Height <> #PB_Ignore 
            If Height < 0 : Height = 0 : EndIf
            
            If \height <> Height 
              Change_height = height-\height 
              \height = Height 
              \height[#__c_1] = \height-\bs*2+\fs*2 
              \height[#__c_2] = \height-\bs*2-\__height
              If \height[#__c_1] < 0 : \height[#__c_1] = 0 : EndIf
              If \height[#__c_2] < 0 : \height[#__c_2] = 0 : EndIf
              \height[#__c_3] = \height[#__c_2]
              \resize | #__resize_height | #__resize_change
            EndIf 
          EndIf 
          
          
          If \resize & #__resize_change
            If \parent And \parent\x[#__c_2]+\parent\width[#__c_3] < \x+\width And 
               \parent\x[#__c_2]+\parent\width[#__c_3] < \parent\x[#__c_4]+\parent\width[#__c_4]
              \width[#__c_4] = \parent\x[#__c_2]+\parent\width[#__c_3] - \x[#__c_4]
            ElseIf \parent And \parent\x[#__c_4]+\parent\width[#__c_4] > \x+\width 
              \width[#__c_4] = \parent\x[#__c_4]+\parent\width[#__c_4] - \x[#__c_4]
            Else
              \width[#__c_4] = \width
            EndIf
            
            If \parent And \parent\y[#__c_2]+\parent\height[#__c_3] < \y+\height And 
               \parent\y[#__c_2]+\parent\height[#__c_3] < \parent\y[#__c_4]+\parent\height[#__c_4]
              \height[#__c_4] = \parent\y[#__c_2]+\parent\height[#__c_3] - \y[#__c_4]
            ElseIf \parent And \parent\y[#__c_4]+\parent\height[#__c_4] > \y+\height 
              \height[#__c_4] = \parent\y[#__c_4]+\parent\height[#__c_4] - \y[#__c_4]
            Else
              \height[#__c_4] = \height
            EndIf
            
            If (Change_x Or Change_y)
              If (*this\scroll And *this\scroll\v And *this\scroll\h)
                Resize(*this\scroll\v, *this\scroll\v\x[#__c_3], *this\scroll\v\y[#__c_3], #PB_Ignore, #PB_Ignore)
                Resize(*this\scroll\h, *this\scroll\h\x[#__c_3], *this\scroll\h\y[#__c_3], #PB_Ignore, #PB_Ignore)
              EndIf
              
              If *this\container And *this\count\childrens
                _move_childrens_(*this, 0,0)
              EndIf
            EndIf
            
            If (Change_width Or Change_height)
              ; Resize vertical&horizontal scrollbars
              If (\scroll And \scroll\v And \scroll\h)
                bar_Resizes(\scroll, 0, 0, \width[#__c_2], \height[#__c_2])
                
                \width[#__c_3] = \scroll\h\bar\page\len
                \height[#__c_3] = \scroll\v\bar\page\len
              EndIf
            EndIf
          EndIf
          
          If \type = #__Type_ScrollBar Or
         \type = #__Type_ProgressBar Or
         \type = #__Type_TrackBar
        Bar_update(*this)
      EndIf
      
      If \type = #__Type_Splitter
        Bar_Update(*this)
      EndIf
      
      ; resize type
      If \type = #__Type_Option
        *this\option_box\x = *this\x[#__c_2] + *this\text\_padding
        *this\option_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\option_box\height)/2
      EndIf
      
      If \type = #__Type_CheckBox
        *this\check_box\x = *this\x[#__c_2] + *this\text\_padding
        *this\check_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\check_box\height)/2
      EndIf
      
      If \type = #__Type_Panel
        _resize_panel_(*this, \tab\bar\button[#__b_1], \x[#__c_2])
        
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
          \tab\bar\thumb\pos = _bar_thumb_pos_(\tab\bar, \tab\bar\page\pos)
        EndIf
      EndIf  
      
      If \type = #__Type_Window
       ; caption title bar
       If Not \caption\hide
          \caption\x = \x[#__c_1]
          \caption\y = \y[#__c_1]
          \caption\width = \width[#__c_1]
          \caption\height = \__height + \fs ; \height[#__c_1]-\height[#__c_2]-\fs ; 
          
          ; 
          \caption\x[#__c_2] = \x[#__c_1] + \fs
          \caption\y[#__c_2] = \y[#__c_1] + \fs
          \caption\height[#__c_2] = \__height - \fs
          
          If \caption\height > \height[#__c_1] -\fs ;*2
            \caption\height = \height[#__c_1] -\fs  ;*2
          EndIf
          
          ; caption close button
          If Not \caption\button[0]\hide
            \caption\button[0]\x = (\x[#__c_2]+\width[#__c_2]) - (\caption\button[0]\width+\caption\_padding)
            \caption\button[0]\y = \y[#__c_1] + (\caption\height-\caption\button[0]\height)/2
          EndIf
          
          ; caption maximize button
          If Not \caption\button[1]\hide
            If \caption\button[0]\hide
              \caption\button[1]\x = (\x[#__c_2]+\width[#__c_2]) - (\caption\button[1]\width+\caption\_padding)
            Else
              \caption\button[1]\x = \caption\button[0]\x - (\caption\button[1]\width+\caption\_padding)
            EndIf
            \caption\button[1]\y = \y[#__c_1] + (\caption\height-\caption\button[1]\height)/2
          EndIf
          
          ; caption minimize button
          If Not \caption\button[2]\hide
            If \caption\button[1]\hide
              \caption\button[2]\x = \caption\button[0]\x - (\caption\button[2]\width+\caption\_padding)
            Else
              \caption\button[2]\x = \caption\button[1]\x - (\caption\button[2]\width+\caption\_padding)
            EndIf
            \caption\button[2]\y = \y[#__c_1] + (\caption\height-\caption\button[2]\height)/2
          EndIf
          
          ; caption help button
          If Not \caption\button[3]\hide
            If Not \caption\button[2]\hide
              \caption\button[3]\x = \caption\button[2]\x - (\caption\button[3]\width+\caption\_padding)
            ElseIf Not \caption\button[1]\hide
              \caption\button[3]\x = \caption\button[1]\x - (\caption\button[3]\width+\caption\_padding)
            Else
              \caption\button[3]\x = \caption\button[0]\x - (\caption\button[3]\width+\caption\_padding)
            EndIf
            \caption\button[3]\y = \caption\button[0]\y
          EndIf
          
          ; title bar width
          If Not \caption\button[3]\hide
            \caption\width[#__c_2] = \caption\button[3]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[2]\hide
            \caption\width[#__c_2] = \caption\button[2]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[1]\hide
            \caption\width[#__c_2] = \caption\button[1]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[0]\hide
            \caption\width[#__c_2] = \caption\button[0]\x - \x[#__c_2] - \caption\_padding
          Else
            \caption\width[#__c_2] = \width[#__c_1] - \fs*2
          EndIf
          
          ; clip text coordinate
          If \caption\x[#__c_2] < \x[#__c_4]
            \caption\x[#__c_4] = \x[#__c_4]
          Else
            \caption\x[#__c_4] = \caption\x[#__c_2]
          EndIf
          If \caption\y[#__c_2] < \y[#__c_4]
            \caption\y[#__c_4] = \y[#__c_4]
          Else
            \caption\y[#__c_4] = \caption\y[#__c_2]
          EndIf
          If \caption\x[#__c_2]+\caption\width[#__c_2] > \x[#__c_4]+\width[#__c_2]
            \caption\width[#__c_4] = \width[#__c_4]
          Else
            \caption\width[#__c_4] = \caption\width[#__c_2]
          EndIf
          If \caption\y[#__c_2]+\caption\height[#__c_2] > \y[#__c_4]+\height[#__c_2]
            \caption\height[#__c_4] = \height[#__c_4]
          Else
            \caption\height[#__c_4] = \caption\height[#__c_2]
          EndIf
          
        EndIf
      EndIf
      
      ; anchors widgets
      If *this And (\root And \root\anchor And \root\anchor\widget = *this)
        a_resize(*this)
      EndIf
      ;EndIf
      
      If \type = #__Type_ScrollBar
        ProcedureReturn \bar\hide
        
      ElseIf \resize & #__resize_change ; (Change_x Or Change_y Or Change_width Or Change_height)
        ProcedureReturn \resize
      EndIf
        EndWith
    EndProcedure
    
    Procedure.i Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    With *this
      ; #__flag_autoSize
      If \parent And \parent\type <> #__Type_Splitter And
         \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
        X = 0; \align\width
        Y = 0; \align\height
        Width = \parent\width[#__c_2] ; - \align\width
        Height = \parent\height[#__c_2] ; - \align\height
      EndIf
      
      ; Set widget coordinate
      If X<>#PB_Ignore 
        If \parent 
          \x[#__c_3] = X 
          X+\parent\x[#__c_2] 
        EndIf 
        
        If \x <> X 
          Change_x = x-\x 
          \x = X 
          \x[#__c_2] = \x+\bs 
          \x[#__c_1] = \x[#__c_2]-\fs 
          \resize | #__resize_x | #__resize_change
        EndIf 
      EndIf  
      
      If Y<>#PB_Ignore 
        If \parent 
          \y[#__c_3] = y 
          y+\parent\y[#__c_2] 
        EndIf 
        
        If \y <> y 
          Change_y = y-\y 
          \y = y 
          \y[#__c_1] = \y+\bs-\fs 
          \y[#__c_2] = \y+\bs+\__height
          \resize | #__resize_y | #__resize_change
        EndIf 
      EndIf  
      
      If width <> #PB_Ignore 
        If width < 0 : width = 0 : EndIf
        
        If \width <> width 
          Change_width = width-\width 
          \width = width 
          \width[#__c_2] = \width-\bs*2 
          \width[#__c_1] = \width[#__c_2]+\fs*2 
          If \width[#__c_1] < 0 : \width[#__c_1] = 0 : EndIf
          If \width[#__c_2] < 0 : \width[#__c_2] = 0 : EndIf
          \resize | #__resize_width | #__resize_change
        EndIf 
      EndIf  
      
      If Height <> #PB_Ignore 
        If Height < 0 : Height = 0 : EndIf
        
        If \height <> Height 
          Change_height = height-\height 
          \height = Height 
          \height[#__c_1] = \height-\bs*2+\fs*2 
          \height[#__c_2] = \height-\bs*2-\__height
          If \height[#__c_1] < 0 : \height[#__c_1] = 0 : EndIf
          If \height[#__c_2] < 0 : \height[#__c_2] = 0 : EndIf
          \resize | #__resize_height | #__resize_change
        EndIf 
      EndIf 
      
      ;
      ;If \resize & #__resize_change
      ; Resize vertical&horizontal scrollbars
      If (\scroll And \scroll\v And \scroll\h)
        Bar_resizes(\scroll, 0,0, \width-\bs*2, \height-\bs*2-\__height)
        
        \width[#__c_2] = \scroll\h\bar\page\len
        \height[#__c_2] = \scroll\v\bar\page\len
      EndIf
      
      If \type = #__Type_ScrollBar Or
         \type = #__Type_ProgressBar Or
         \type = #__Type_TrackBar
        Bar_update(*this)
      EndIf
      
      ; set clip coordinate
      If Not _is_root_(*this) And \parent 
        Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
        
        If \parent\scroll 
          If \parent\scroll\v 
            clip_v = Bool(\parent\width=\parent\width[#__c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #__Type_ScrollBar)*\parent\scroll\v\width 
          EndIf
          If \parent\scroll\h 
            clip_h = Bool(\parent\height=\parent\height[#__c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #__Type_ScrollBar) * \parent\scroll\h\height 
          EndIf
        EndIf
        
        clip_x = \parent\x[#__c_4] + Bool(\parent\x[#__c_2] > \parent\x[#__c_4]) * (\parent\x[#__c_2]-\parent\x[#__c_4]) 
        clip_y = \parent\y[#__c_4] + Bool(\parent\y[#__c_2] > \parent\y[#__c_4]) * (\parent\y[#__c_2]-\parent\y[#__c_4]) 
        
        clip_width = ((\parent\x[#__c_4]+\parent\width[#__c_4])-Bool((\parent\x[#__c_4]+\parent\width[#__c_4])>(\parent\x[#__c_2]+\parent\width[#__c_2]))*\parent\bs)-clip_v 
        ;clip_height = ((\parent\y[#__c_4]+\parent\height[#__c_4])-Bool((\parent\y[#__c_4]+\parent\height[#__c_4])>(\parent\y[#__c_2]+\parent\height[#__c_2]))*\parent\bs)-clip_h 
        clip_height = ((\parent\y[#__c_4]+\parent\height[#__c_4]) - Bool((\y+\height)>(\parent\y[#__c_2]+\parent\height[#__c_2])) * \parent\bs)-clip_h 
      EndIf
      
      ;           If \resize & #__resize_x Or
      ;              \resize & #__resize_width
      
      If \resize & #__resize_x
        If clip_x And clip_x > \x 
          \x[#__c_4] = clip_x 
        Else 
          \x[#__c_4] = \x 
        EndIf
      EndIf
      
      If clip_width And clip_width < (\x+\width)
        \width[#__c_4] = clip_width - \x[#__c_4] 
      Else 
        \width[#__c_4] = (\x+\width) - \x[#__c_4] ; \width - (\x[#__c_4]-\x) 
      EndIf
      ;           EndIf
      
      ;           If \resize & #__resize_y Or
      ;              \resize & #__resize_height
      
      If \resize & #__resize_y
        If clip_y And clip_y > \y 
          \y[#__c_4] = clip_y 
        Else 
          \y[#__c_4] = \y 
        EndIf
      EndIf
      
      If clip_height And clip_height < (\y+\height) 
        \height[#__c_4] = clip_height - \y[#__c_4] 
      Else 
        \height[#__c_4] = (\y+\height) - \y[#__c_4] ; \height - (\y[#__c_4]-\y) 
      EndIf
      ;           EndIf
      
      ; resize type
      If \type = #__Type_Option
        *this\option_box\x = *this\x[#__c_2] + *this\text\_padding
        *this\option_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\option_box\height)/2
      EndIf
      
      If \type = #__Type_CheckBox
        *this\check_box\x = *this\x[#__c_2] + *this\text\_padding
        *this\check_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\check_box\height)/2
      EndIf
      
      If \type = #__Type_Panel
        _resize_panel_(*this, \tab\bar\button[#__b_1], \x[#__c_2])
        
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
          \tab\bar\thumb\pos = _bar_thumb_pos_(\tab\bar, \tab\bar\page\pos)
        EndIf
      EndIf  
      
      If \type = #__Type_Window
       ; caption title bar
       If Not \caption\hide
          \caption\x = \x[#__c_1]
          \caption\y = \y[#__c_1]
          \caption\width = \width[#__c_1]
          \caption\height = \__height + \fs ; \height[#__c_1]-\height[#__c_2]-\fs ; 
          
          ; 
          \caption\x[#__c_2] = \x[#__c_1] + \fs
          \caption\y[#__c_2] = \y[#__c_1] + \fs
          \caption\height[#__c_2] = \__height - \fs
          
          If \caption\height > \height[#__c_1] -\fs ;*2
            \caption\height = \height[#__c_1] -\fs  ;*2
          EndIf
          
          ; caption close button
          If Not \caption\button[0]\hide
            \caption\button[0]\x = (\x[#__c_2]+\width[#__c_2]) - (\caption\button[0]\width+\caption\_padding)
            \caption\button[0]\y = \y[#__c_1] + (\caption\height-\caption\button[0]\height)/2
          EndIf
          
          ; caption maximize button
          If Not \caption\button[1]\hide
            If \caption\button[0]\hide
              \caption\button[1]\x = (\x[#__c_2]+\width[#__c_2]) - (\caption\button[1]\width+\caption\_padding)
            Else
              \caption\button[1]\x = \caption\button[0]\x - (\caption\button[1]\width+\caption\_padding)
            EndIf
            \caption\button[1]\y = \y[#__c_1] + (\caption\height-\caption\button[1]\height)/2
          EndIf
          
          ; caption minimize button
          If Not \caption\button[2]\hide
            If \caption\button[1]\hide
              \caption\button[2]\x = \caption\button[0]\x - (\caption\button[2]\width+\caption\_padding)
            Else
              \caption\button[2]\x = \caption\button[1]\x - (\caption\button[2]\width+\caption\_padding)
            EndIf
            \caption\button[2]\y = \y[#__c_1] + (\caption\height-\caption\button[2]\height)/2
          EndIf
          
          ; caption help button
          If Not \caption\button[3]\hide
            If Not \caption\button[2]\hide
              \caption\button[3]\x = \caption\button[2]\x - (\caption\button[3]\width+\caption\_padding)
            ElseIf Not \caption\button[1]\hide
              \caption\button[3]\x = \caption\button[1]\x - (\caption\button[3]\width+\caption\_padding)
            Else
              \caption\button[3]\x = \caption\button[0]\x - (\caption\button[3]\width+\caption\_padding)
            EndIf
            \caption\button[3]\y = \caption\button[0]\y
          EndIf
          
          ; title bar width
          If Not \caption\button[3]\hide
            \caption\width[#__c_2] = \caption\button[3]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[2]\hide
            \caption\width[#__c_2] = \caption\button[2]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[1]\hide
            \caption\width[#__c_2] = \caption\button[1]\x - \x[#__c_2] - \caption\_padding
          ElseIf Not \caption\button[0]\hide
            \caption\width[#__c_2] = \caption\button[0]\x - \x[#__c_2] - \caption\_padding
          Else
            \caption\width[#__c_2] = \width[#__c_1] - \fs*2
          EndIf
          
          ; clip text coordinate
          If \caption\x[#__c_2] < \x[#__c_4]
            \caption\x[#__c_4] = \x[#__c_4]
          Else
            \caption\x[#__c_4] = \caption\x[#__c_2]
          EndIf
          If \caption\y[#__c_2] < \y[#__c_4]
            \caption\y[#__c_4] = \y[#__c_4]
          Else
            \caption\y[#__c_4] = \caption\y[#__c_2]
          EndIf
          If \caption\x[#__c_2]+\caption\width[#__c_2] > \x[#__c_4]+\width[#__c_2]
            \caption\width[#__c_4] = \width[#__c_4]
          Else
            \caption\width[#__c_4] = \caption\width[#__c_2]
          EndIf
          If \caption\y[#__c_2]+\caption\height[#__c_2] > \y[#__c_4]+\height[#__c_2]
            \caption\height[#__c_4] = \height[#__c_4]
          Else
            \caption\height[#__c_4] = \caption\height[#__c_2]
          EndIf
          
        EndIf
      EndIf
      
      ; Debug ""+height+" "+\height[#__c_0]+" "+\height[#__c_1]+" "+\height[#__c_2]+" "+\height[#__c_3]+" "+\height[#__c_4]
      
      If \type = #__Type_Splitter
        Bar_Update(*this)
      Else
       ; Resize childrens
       If \count\childrens
          ForEach \childrens()
            If \childrens()\align
              If \childrens()\align\horizontal
                x = (\width[#__c_2] - (\childrens()\align\width+\childrens()\width))/2
              ElseIf \childrens()\align\right And Not \childrens()\align\left
                x = \width[#__c_2] - \childrens()\align\width
              Else
                If \x[#__c_2]
                  x = (\childrens()\x-\x[#__c_2]) + Change_x 
                Else
                  x = 0
                EndIf
              EndIf
              
              If \childrens()\align\Vertical
                y = (\height[#__c_2] - (\childrens()\align\height+\childrens()\height))/2 
              ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                y = \height[#__c_2] - \childrens()\align\height
              Else
                If \y[#__c_2]
                  y = (\childrens()\y-\y[#__c_2]) + Change_y 
                Else
                  y = 0
                EndIf
              EndIf
              
              If \childrens()\align\top And \childrens()\align\bottom
                Height = \height[#__c_2] - \childrens()\align\height
              Else
                Height = #PB_Ignore
              EndIf
              
              If \childrens()\align\left And \childrens()\align\right
                Width = \width[#__c_2] - \childrens()\align\width
              Else
                Width = #PB_Ignore
              EndIf
              
              Resize(\childrens(), x, y, Width, Height)
            Else
              Resize(\childrens(), (\childrens()\x-\x[#__c_2]) + Change_x, (\childrens()\y-\y[#__c_2]) + Change_y, #PB_Ignore, #PB_Ignore)
            EndIf
          Next
        EndIf
      EndIf
      
      ; anchors widgets
      If *this And (\root And \root\anchor And \root\anchor\widget = *this)
        a_resize(*this)
      EndIf
      ;EndIf
      
      If \type = #__Type_ScrollBar
        ProcedureReturn \bar\hide
        
      ElseIf \resize & #__resize_change ; (Change_x Or Change_y Or Change_width Or Change_height)
        ProcedureReturn \resize
      EndIf
    EndWith
    
  EndProcedure
  
  
  ;-
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    ProcedureReturn Bar::Scroll(X,Y,Width,Height, Min,Max,PageLength, Flag, round)
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
    ProcedureReturn Bar::Spin(X,Y,Width,Height, Min,Max, Flag, round, Increment)
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    ProcedureReturn Bar::Track(X,Y,Width,Height, Min,Max, Flag, round)
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    ProcedureReturn Bar::Progress(X,Y,Width,Height, Min,Max, Flag, round)
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    ProcedureReturn Bar::Splitter(X,Y,Width,Height, First, Second, Flag)
  EndProcedure
  
  ;-
  Procedure.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Image, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      
      \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
      \bs = \fs
      
      ; \image = AllocateStructure(_s_image)
      _set_image_(*this, *this, Image)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size,0,\image\height,Height-\bs*2, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size,0,\image\width,Width-\bs*2, 0, 7, *this)
      
      \color = _get_colors_()
      \color\back = \scroll\v\color\back
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Frame, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \container =- 2
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \__height = 16
      
      \bs = 1
      \fs = 1
      
      ;       ; \text = AllocateStructure(_s_text)
      ;       \text\edit\string = Text.s
      ;       \text\string.s = Text.s
      ;       \text\change = 1
      _set_text_flag_(*this, flag, 2, - 22)
      
      *this\text\_padding = 5
      ;*this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_ComboBox, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \color = _get_colors_()
      \color\alpha = 255
      
      \fs = 1
      \index[#__s_1] =- 1
      \index[#__s_2] =- 1
      
      ; \text = AllocateStructure(_s_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      \text\height = 20
      
      ; \image = AllocateStructure(_s_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      \combo_box\height = Height
      \combo_box\width = 15
      \combo_box\arrow\size = 4
      \combo_box\arrow\type = #__arrow_type
      
      \index[#__s_1] =- 1
      \index[#__s_2] =- 1
      
      \row\sublevellen = 18
      \flag\gridLines = Bool(flag&#__tree_gridLines)
      \flag\multiselect = Bool(flag&#__tree_multiselect)
      \flag\clickselect = Bool(flag&#__tree_clickselect)
      \flag\fullselection = 1
      \flag\alwaysselection = 1
      
      \flag\lines = Bool(Not flag&#__tree_nolines)*8
      \flag\buttons = Bool(Not flag&#__tree_nobuttons)*9 ; ??? ??? ????? ?????? ??? ?????
      \flag\checkboxes = Bool(flag&#__tree_checkboxes)*12; ??? ??? ????? ?????? ??? ?????
      
      \popup = Popup(*this, 0,0,0,0)
      Protected *open = OpenList(\popup)
      Tree(0,0,0,0, #__flag_autoSize|#__tree_nolines|#__tree_nobuttons) 
      \popup\childrens()\scroll\h\height=0
      OpenList(*open)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Button, Flag, Root()\opened) 
    
    With *this
      \fs = Bool(Not constants::_check_(Flag, #__flag_borderless))
      \bs = \fs
      \round = Round
      
      \x =- 1
      \y =- 1
      \color = _get_colors_()
      \interact = 1
      
      \vertical = constants::_check_(Flag, #__flag_vertical)
      
      _set_text_flag_(*this, flag, 0, 0)
      
      *this\text\_padding = 5
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      *this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      ; \image = AllocateStructure(_s_image)
      \image\align\Vertical = 1
      \image\align\horizontal = 1
      _set_image_(*this, *this, Image)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    _set_last_parameters_(*this, #__Type_HyperLink, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      
      \fs = 0;Bool(Not Flag&#__flag_borderless)*2
      \bs = \fs
      \interact = 1
      
      ;\color = _get_colors_()
      \cursor = #PB_Cursor_Hand
      \color\front[1] = Color
      \color\front[2] = Color
      
      _set_text_flag_(*this, flag)
      
      *this\text\_padding = 5
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Width, 0, 7, *this)
      
      \flag\lines = constants::_check_(Flag, #PB_HyperLink_Underline)
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    If Root()\opened\count\childrens
      If Root()\opened\childrens()\type = #__Type_Option
        *this\option_group = Root()\opened\childrens()\option_group 
      Else
        *this\option_group = Root()\opened\childrens() 
      EndIf
    Else
      *this\option_group = Root()\opened
    EndIf
    
    _set_last_parameters_(*this, #__Type_Option, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \color\frame = $FF7E7E7E
      \interact = 1
      
      \fs = Bool(Not constants::_check_(Flag, #__flag_borderless))
      \bs = \fs
      
      _set_text_flag_(*this, flag)
      
      *this\text\_padding = 3
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Width, 0, 7, *this)
      *this\scroll\align\left = 18
      
      \option_box\width = 15
      \option_box\height = \option_box\width
      \round = \option_box\width/2
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_CheckBox, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFFFFFFF
      \color\frame = $FF7E7E7E
      \interact = 1
      
      \fs = Bool(Not constants::_check_(Flag, #__flag_borderless))
      \bs = \fs
      
      _set_text_flag_(*this, flag)
      
      *this\text\_padding = 3
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Width, 0, 7, *this)
      *this\scroll\align\left = 18
      
      \round = 3
      \check_box\height = 15
      \check_box\width = \check_box\height
      \flag\threestate = constants::_check_(Flag, #PB_CheckBox_ThreeState)
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Protected Size = 16, *this._s_widget = editor::create(#__Type_Text, 0,0,0,0, "", Flag|#__text_readonly)
    
    _set_last_parameters_(*this, #__Type_Text, Flag, Root()\opened)
    
    With *this
      
      _set_text_flag_(*this, flag, 2,2)
      
      *this\text\_padding = 0
      *this\text\multiline =- 1
      *this\row\margin\hide = 1
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, #__test_scrollbar_size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, round.l=0)
    Protected Size = 16, *this._s_widget = editor::create(#__Type_String, 0,0,0,0, "", Flag)
    
    _set_last_parameters_(*this, #__Type_String, Flag, Root()\opened)
    
    With *this
      If Flag&#__button_multiline
        *this\text\multiline = 1
      ElseIf Flag&#__text_wordwrap
        *this\text\multiline =- 1
      Else
        *this\text\multiline = 0
      EndIf
      
      If *this\text\multiline
        *this\row\margin\hide = 0;Bool(Not Flag&#__string_numeric)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      Else
        *this\row\margin\hide = 1
        *this\text\numeric = Bool(Flag&#__string_numeric)
      EndIf
      
      ;*this\text\align\left = Bool(Not Flag&#__string_center)
      
      *this\text\align\vertical = Bool(Not *this\text\align\bottom And Not *this\text\align\top)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size,0,0,Height, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      If Text.s
        Editor::SetText(*this, Text.s)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i IPAddress(X.l,Y.l,Width.l,Height.l)
    Protected Text.s="0.0.0.0"
    Protected Size = 16, *this._s_widget = editor::create(#__Type_IPAddress, 0,0,0,0, "", 0)
    
    _set_last_parameters_(*this, #__Type_IPAddress, 0, Root()\opened)
    
    With *this
      *this\text\multiline = 0
      *this\row\margin\hide = 1
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      *this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size,0,0,Height, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      If Text.s
        Editor::SetText(*this, Text.s)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = editor::create(#__Type_Editor, 0,0,0,0, "", Flag)
    
    _set_last_parameters_(*this, #__Type_Editor, Flag, Root()\opened)
    
    With *this
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size,0,0,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;- 
  Procedure.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Static index
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Tree, Flag, Root()\opened)
    
    If *this
      With *this
        ;\root = Root()
        \color = _get_colors_()
        \color\alpha = 255
        \color\back = $FFF9F9F9
        ;\color = _get_colors_()
        ;         \color\fore[0] = 0
        ;         \color\fore[1] = 0
        ;         \color\fore[2] = 0
        \color\frame[#__s_0] = $80C8C8C8 
        ;\color\frame[#__s_1] = $80FFC288 
        \color\frame[#__s_2] = $C8DC9338 
        \color\frame[#__s_3] = $FFBABABA
        \color\back[#__s_0] = $FFFFFFFF 
        ;\color\back[#__s_1] = $FFFFFFFF 
        \color\back[#__s_2] = $FFFFFFFF 
        \color\back[#__s_3] = $FFE2E2E2 
        ; \color\line = $FFF0F0F0
        
        ;\handle = *this
        ;\index = index : index + 1
        ;\type = #__Type_tree
        \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
        \bs = \fs
        \x =- 1
        \y =- 1
        
        \index =- 1
        \change = 1
        
        \interact = 1
        ;\round = Round
        
        ; \image = AllocateStructure(_s_image)
        ; \text = AllocateStructure(_s_text)
        \text\change = 1 ; set auto size items
        \text\height = 18 
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ;                     Protected TextGadget = TextGadget(#PB_any, 0,0,0,0,"")
          ;                     \text\fontID = GetGadgetFont(TextGadget) 
          ;                     FreeGadget(TextGadget)
          Protected FontSize.CGFloat ;= 12.0  boldSystemFontOfSize  fontWithSize
                                     ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
                                     ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
          
          ;\text\fontID = FontID(LoadFont(#PB_any, "Helvetica Neue", 12))
          ;\text\fontID = FontID(LoadFont(#PB_any, "Tahoma", 12))
          ;\text\fontID = FontID(LoadFont(#PB_any, "Helvetica", 12))
          ;
          \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
          CocoaMessage(@FontSize, \text\fontID, "pointSize")
          
          ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
          
          ; Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID,"displayName"), "UTF8String"), -1, #PB_uTF8)
          
        CompilerElse
          \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        CompilerEndIf
        
        \text\_padding = 4
        \image\_padding = 2
        
        \flag\gridlines = Bool(flag&#__tree_gridLines)
        \flag\multiselect = Bool(flag&#__tree_multiselect)
        \flag\clickselect = Bool(flag&#__tree_clickselect)
        ;\flag\alwaysselection = Bool(flag&#__flag_alwaysselection)
        
        \flag\lines = Bool(Not flag&#__tree_nolines)*8 ; ??? ??? ????? ?????? ?????
        \flag\buttons = Bool(Not flag&#__tree_nobuttons)*9 ; ??? ??? ????? ?????? ??????
        \flag\checkBoxes = Bool(flag&#__tree_checkBoxes)*12; ??? ??? ????? ?????? ??? ?????
        \flag\collapse = Bool(flag&#__tree_collapse) 
        \flag\threestate = Bool(flag&#__tree_threeState) 
        
        \flag\option_group = Bool(flag&#__tree_optionboxes)*12; ??? ??? ????? ??????
        If \flag\option_group
          \flag\checkBoxes = 12; ??? ??? ????? ?????? ??? ?????
        EndIf
        
        
        If \flag\lines Or \flag\buttons Or \flag\checkBoxes
          \row\sublevellen = 18
        EndIf
      EndIf
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size, 0,0,0, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Bool(\flag\buttons Or \flag\lines) * Size, 0,0,0, 0, 7, *this)
      
      \scroll\v\index = \index
      \scroll\h\index = \index
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_ListView, Flag, Root()\opened)
    
    With *this
      \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
      \bs = \fs
      
      \x =- 1
      \y =- 1
      ;\cursor = #PB_cursor_hand
      \color = _get_colors_()
      \color\back = $FFF9F9F9
      
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] =- 1
      
      ; \image = AllocateStructure(_s_image)
      ; \text = AllocateStructure(_s_text)
      \text\change = 1 ; set auto size items
      \text\height = 18 
      
      ;       If StartDrawing(CanvasOutput(\root\canvas\gadget))
      ;         
      ;         \text\height = TextHeight("A")
      ;         
      ;         StopDrawing()
      ;       EndIf
      
      \flag\lines = 0
      \flag\buttons = 0
      
      \flag\gridLines = Bool(flag&#__flag_gridLines)
      \flag\multiselect = Bool(flag&#__flag_multiselect)
      \flag\clickselect = Bool(flag&#__flag_clickselect)
      \flag\fullselection = 1
      \flag\alwaysselection = 1
      \flag\checkboxes = Bool(flag&#__flag_checkboxes)*12; ??? ??? ????? ?????? ??? ?????
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size, 0,0,0, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size, 0,0,0, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_ListIcon, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] =- 1
      \__height = 24
      
      ; \image = AllocateStructure(_s_image)
      ; \text = AllocateStructure(_s_text)
      \text\height = 20
      
      \row\sublevellen = 18
      \flag\gridLines = Bool(flag&#__tree_gridLines)
      \flag\multiselect = Bool(flag&#__tree_multiselect)
      \flag\clickselect = Bool(flag&#__tree_clickselect)
      \flag\fullselection = 1
      \flag\alwaysselection = 1
      
      \flag\lines = Bool(Not flag&#__tree_nolines)*8
      \flag\buttons = Bool(Not flag&#__tree_nobuttons)*9 ; ??? ??? ????? ?????? ??? ?????
      \flag\checkboxes = Bool(flag&#__tree_checkboxes)*12; ??? ??? ????? ?????? ??? ?????
      
      \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
      \bs = \fs
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size, 0,0,0, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size, 0,0,0, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      
      AddColumn(*this, 0, FirstColumnTitle, FirstColumnWidth)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_ListIcon, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \cursor = #PB_Cursor_LeftRight
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] =- 1
      \__height = 24
      
      ; \image = AllocateStructure(_s_image)
      ; \text = AllocateStructure(_s_text)
      \text\height = 20
      
      \row\sublevellen = 18
      \flag\gridLines = Bool(flag&#__tree_gridLines)
      \flag\multiselect = Bool(flag&#__tree_multiselect)
      \flag\clickselect = Bool(flag&#__tree_clickselect)
      \flag\fullselection = 1
      \flag\alwaysselection = 1
      
      \flag\lines = Bool(Not flag&#__tree_nolines)*8
      \flag\buttons = Bool(Not flag&#__tree_nobuttons)*9 ; ??? ??? ????? ?????? ??? ?????
      \flag\checkboxes = Bool(flag&#__tree_checkboxes)*12; ??? ??? ????? ?????? ??? ?????
      
      \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
      \bs = \fs
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size, 0,0,0, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size, 0,0,0, 0, 7, *this)
      
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
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_property, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] =- 1
      
      \fs = Bool(Not Flag&#__flag_borderless)*#__border_scroll
      \bs = \fs
      
      \bar\thumb\len = 7
      \bar\button[#__b_3]\len = 7 ; min thumb size
      SetAttribute(*this, #__bar_maximum, Width) 
      
      ;\container = 1
      
      
      \cursor = #PB_Cursor_LeftRight
      SetState(*this, SplitterPos)
      
      
      \color = _get_colors_()
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      ; \image = AllocateStructure(_s_image)
      
      ; \text = AllocateStructure(_s_text)
      \text\height = 20
      
      \row\sublevellen = 18
      \flag\gridLines = Bool(flag&#__tree_gridLines)
      \flag\multiselect = Bool(flag&#__tree_multiselect)
      \flag\clickselect = Bool(flag&#__tree_clickselect)
      \flag\fullselection = 1
      \flag\alwaysselection = 1
      
      \flag\lines = Bool(Not flag&#__tree_nolines)*8
      \flag\buttons = Bool(Not flag&#__tree_nobuttons)*9 ; ??? ??? ????? ?????? ??? ?????
      \flag\checkboxes = Bool(flag&#__tree_checkboxes)*12; ??? ??? ????? ?????? ??? ?????
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar,Size,0,0,Height, #__flag_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar,Size,0,0,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, scroll_step.l=1, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_ScrollArea, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \index[#__s_1] =- 1
      \index[#__s_2] = 0
      
      \color = _get_colors_()
      \color\back = $FFF9F9F9
      
      \fs = Bool(Not Flag&#__flag_borderless) * #__border_scroll
      \bs = \fs
      
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = bar_create(#__Type_ScrollBar, Size, 0,ScrollAreaHeight,Height, #__bar_vertical, 7, *this)
      \scroll\h = bar_create(#__Type_ScrollBar, Size, 0,ScrollAreaWidth,Width, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      If constants::_check_(flag, #__flag_noGadget, #False)
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Container, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \index[#__s_1] =- 1
      \index[#__s_2] = 0
      
      \color = _get_colors_()
      \color\fore = 0
      \color\back = $FFF6F6F6
      
      \fs = Bool(Not Flag&#__flag_borderless)
      \bs = \fs
      
      Resize(*this, X,Y,Width,Height)
      If constants::_check_(flag, #__flag_noGadget, #False)
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Panel(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #__Type_Panel, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \index[#__s_1] =- 1
      \index[#__s_2] = 0
      
      \color = _get_colors_()
      \color\back = $FFF9F9F9
      
      \from =- 1
      \__height = 25
      \tab\bar\page\len = Width
      \tab\bar\scroll_step = 10
      
      \tab\bar\button[#__b_1]\len = 13 + 2
      \tab\bar\button[#__b_2]\len = 13 + 2
      \tab\bar\button[#__b_1]\round = 7
      \tab\bar\button[#__b_2]\round = 7
      
      \tab\bar\button[#__b_1]\arrow\size = 6
      \tab\bar\button[#__b_2]\arrow\size = 6
      \tab\bar\button[#__b_1]\arrow\type = #__arrow_type + Bool(#__arrow_type>0)
      \tab\bar\button[#__b_2]\arrow\type = #__arrow_type + Bool(#__arrow_type>0)
      
      \tab\bar\button[#__b_1]\color = _get_colors_()
      \tab\bar\button[#__b_2]\color = _get_colors_()
      
      \tab\bar\button[#__b_1]\color\alpha = 255
      \tab\bar\button[#__b_2]\color\alpha = 255
      
      \fs = 1
      \bs = Bool(Not Flag&#__flag_anchorsGadget)
      
      Resize(*this, X,Y,Width,Height)
      If constants::_check_(flag, #__flag_noGadget, #False)
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i CloseList()
    If Root()\opened And 
       Root()\opened\parent And 
       Root()\opened\root\canvas\gadget = Root()\canvas\gadget 
      Root()\opened = Root()\opened\parent
    Else
      Root()\opened = Root()
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._s_widget, Item.l=0)
    Protected result.i = Root()\opened
    
    If *this
      If *this\type = #__Type_Window
        *this\window = *this
      EndIf
      
      Root()\opened = *this
      Root()\opened\tab\opened = Item
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent._s_widget=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    If *parent
      If Root() = *parent 
        Root()\parent = *this
      EndIf
    Else
      *parent = Root()
    EndIf
    
    _set_last_parameters_(*this, #__Type_Window, Flag, *parent) 
    ;Debug ""+#PB_compiler_procedure+"(func) line - "+#PB_compiler_line +" "+ root()\opened 
    
    ; ? ????? ???????? ??????
    If Not Root()\opened 
      Root()\opened = Root()
    EndIf
    
    With *this
      \x =- 1
      \y =- 1
      \container =- 1
      \index[#__s_1] =- 1
      \index[#__s_2] = 0 ; 
      
      \color = _get_colors_()
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      ; Background image
      \image\index =- 1
      
      
      ;       \flag\window\sizeGadget = constants::_check_(flag, #__Window_SizeGadget)
      ; ;       \flag\window\systemMenu = constants::_check_(flag, #__Window_SystemMenu)
      ; ;       \flag\window\MinimizeGadget = constants::_check_(flag, #__Window_MinimizeGadget)
      ; ;       \flag\window\MaximizeGadget = constants::_check_(flag, #__Window_MaximizeGadget)
      ;       \flag\window\TitleBar = constants::_check_(flag, #__Window_TitleBar)
      ;       \flag\window\Tool = constants::_check_(flag, #__Window_Tool)
      ;       \flag\window\borderless = constants::_check_(flag, #__Window_BorderLess)
      
      \caption\round = 4
      \caption\_padding = \caption\round
      \caption\color = _get_colors_()
      
      ;\caption\hide = constants::_check_(flag, #__flag_borderless)
      \caption\hide = constants::_check_(flag, #__Window_TitleBar, #False)
      \caption\button[0]\hide = constants::_check_(flag, #__Window_SystemMenu, #False)
      \caption\button[1]\hide = constants::_check_(flag, #__Window_MaximizeGadget, #False)
      \caption\button[2]\hide = constants::_check_(flag, #__Window_MinimizeGadget, #False)
      \caption\button[3]\hide = 1
      
      \caption\button[0]\color = colors::*this\red
      \caption\button[1]\color = colors::*this\blue
      \caption\button[2]\color = colors::*this\green
      
      *this\caption\button[0]\color\state = 1
      *this\caption\button[1]\color\state = 1
      *this\caption\button[2]\color\state = 1
      
      \caption\button[0]\round = 4+3
      \caption\button[1]\round = \caption\button[0]\round
      \caption\button[2]\round = \caption\button[0]\round
      \caption\button[3]\round = \caption\button[0]\round
      
      \caption\button[0]\width = 12+2
      \caption\button[0]\height = 12+2
      
      \caption\button[1]\width = \caption\button[0]\width
      \caption\button[1]\height = \caption\button[0]\height
      
      \caption\button[2]\width = \caption\button[0]\width
      \caption\button[2]\height = \caption\button[0]\height
      
      \caption\button[3]\width = \caption\button[0]\width*2
      \caption\button[3]\height = \caption\button[0]\height
      
      If \caption\button[1]\hide = 0 Or 
         \caption\button[2]\hide = 0
        \caption\button[0]\hide = 0
      EndIf
      
      If \caption\button[0]\hide = 0
        \caption\hide = 0
      EndIf
      
      If Not \caption\hide 
        \__height = constants::_check_(flag, #__flag_borderless, #False) * 23
      EndIf
      
      \fs = constants::_check_(flag, #__flag_borderless, #False) * 5
      \bs = \fs
      
      ;\round = 7
      
      
      Resize(*this, X,Y,Width,Height)
      
      If constants::_check_(flag, #__Window_NoGadgets, #False)
        OpenList(*this)
      EndIf
      If constants::_check_(flag, #__Window_NoActivate, #False)
        SetActive(*this)
      EndIf 
      
      If Text And \caption\height
        \caption\text\_padding = 5
        \caption\text\string = Text
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Open(Window.i, X.l=#PB_Ignore,Y.l=#PB_Ignore,Width.l=#PB_Ignore,Height.l=#PB_Ignore, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, pb_flag, Canvas.i=-1, *this._s_widget
    
    With *this
      If x = #PB_Ignore : x = 0 : EndIf
      If y = #PB_Ignore : y = 0 : EndIf
      
      If IsWindow(Window) 
        If Width = #PB_Ignore
          Width = WindowWidth(Window) - x*2
        EndIf
        
        If Height = #PB_Ignore
          Height = WindowHeight(Window) - y*2
        EndIf
      EndIf
      
      If Width = #PB_Ignore : Width = 300 : EndIf
      If Height = #PB_Ignore : Height = 200 : EndIf
      
      Root() = AllocateStructure(_s_root)
      Root()\root = Root()
      Root()\window =- 1
      Root()\canvas\gadget =- 1
      Root()\width = Width
      Root()\height = Height
      Root()\color = _get_colors_()
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        Root()\flag\transform = 1
      EndIf
      
      If Not IsWindow(window)
        pb_flag = Flag
        flag | #__flag_borderless
      EndIf
      
      *this = Form(0, 0, Width,Height, Text.s, flag,  Root())
      
      ;       ;       Width + \bs*2
      ;       ;       Height + \__height + \bs*2
      ;       Width + \fs*2
      ;       Height + \__height + \fs*2
      
      If Not IsWindow(Window) 
        w = OpenWindow(Window, X,Y,Width,Height, Text, pb_flag, WindowID) : If Window =- 1 : Window = w : EndIf
        Root()\color\back = $FFF0F0F0
        X = 0 : Y = 0
      Else
        Root()\color\back = $FFFFFFFF
      EndIf
      
      Root()\window = Window
      Root()\canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
      
      If IsGadget(Root()\canvas\gadget)
        SetGadgetData(Root()\canvas\gadget, Root())
        SetWindowData(Root()\window, Root()\canvas\gadget)
        BindGadgetEvent(Root()\canvas\gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Create(Type.i, X.l,Y.l,Width.l,Height.l, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, parent_item.i=0)
    Protected Result
    
    If Type = #__Type_Window
      Result = Form(X,Y,Width,Height, Text.s, Flag, Parent)
    Else
      If Parent
        OpenList(Parent, parent_item)
      EndIf
      
      Select Type
        Case #__Type_Panel      : Result = Panel(X,Y,Width,Height, Flag)
        Case #__Type_Container  : Result = Container(X,Y,Width,Height, Flag)
        Case #__Type_ScrollArea : Result = ScrollArea(X,Y,Width,Height, Param_1, Param_2, Param_3, Flag)
        Case #__Type_Button     : Result = Button(X,Y,Width,Height, Text.s, Flag)
        Case #__Type_String     : Result = String(X,Y,Width,Height, Text.s, Flag)
        Case #__Type_Text       : Result = Text(X,Y,Width,Height, Text.s, Flag)
      EndSelect
      
      If Parent
        CloseList()
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Free(*this._s_widget)
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
          ; FreeStructure(\scroll) : \scroll = 0
        EndIf
        
        ;If \box : FreeStructure(\box) : \box = 0 : EndIf
        ;If \text : FreeStructure(\text) : \text = 0 : EndIf
        ;If \image : FreeStructure(\image) : \image = 0 : EndIf
        ;If \image[1] : FreeStructure(\image[1]) : \image[1] = 0 : EndIf
        
        ;         GetActive()\gadget = 0
        ;         GetActive() = 0
        
        If \parent And ListSize(\parent\childrens()) : \parent\count\childrens - 1
          ChangeCurrentElement(\parent\childrens(), GetAdress(*this))
          Result = DeleteElement(\parent\childrens())
        EndIf
        
        ; FreeStructure(*this) 
        ClearStructure(*this, _s_widget) 
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure.i Post(eventtype.l, *this._s_widget, eventitem.l=#PB_All, *data=0)
    Protected result.i
    
    structures::*event\widget = *this
    structures::*event\data = *data
    structures::*event\type = eventtype
    
    If Not *this\root\event_count
      ; 
      Select eventtype 
        Case #__Event_Focus, 
             #__Event_LostFocus
          
          ForEach Root()\event_list()
            If Root()\event_list()\widget = *this And Root()\event_list()\type = eventtype
              result = 1
            EndIf
          Next
          
          If Not result
            AddElement(Root()\event_list())
            Root()\event_list() = AllocateStructure(_s_event)
            Root()\event_list()\widget = *this
            Root()\event_list()\type = eventtype
            Root()\event_list()\item = eventitem
            Root()\event_list()\data = *data
          EndIf
          
      EndSelect
    EndIf
    
    If *this And *this\root\event_count
      If *this\root <> *this  
        If *this\event And
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
  
  Procedure.i Bind(*callback, *this._s_widget=#PB_All, eventtype.l=#PB_All)
    If *this = #PB_All
      *this = Root()
    EndIf
    
    If Not *this\event
      *this\event = AllocateStructure(_s_event)
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
  
  Procedure.i Unbind(*callback, *this._s_widget=#PB_All, eventtype.l=#PB_All)
    If *this\event
      *this\event\type = 0
      *this\event\callback = 0
      FreeStructure(*this\event)
      *this\event = 0
    EndIf
    
    ProcedureReturn *this\event
  EndProcedure
  
  ;- 
  
  Macro _events_panel_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    
    If _event_type_ = #__Event_MouseMove Or
       _event_type_ = #__Event_LeftButtonUp Or
       _event_type_ = #__Event_MouseEnter Or
       _event_type_ = #__Event_MouseLeave
      
      If _this_\tab\bar\button[#__b_2]\len And 
         _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_2])
        
        If _this_\tab\bar\button[#__b_2]\color\state <> #__s_1
          If _this_\tab\bar\button[#__b_2]\color\state <> #__s_3
            _this_\tab\bar\button[#__b_2]\color\state = #__s_1
          EndIf
          
          If _this_\tab\bar\button[#__b_1]\color\state <> #__s_0 : If #__debug_events_tab : Debug " leave tab button - left to right" : EndIf
            If _this_\tab\bar\button[#__b_1]\color\state <> #__s_3 
              _this_\tab\bar\button[#__b_1]\color\state = #__s_0
            EndIf
          EndIf
          
          If _this_\index[#__s_1] >= 0 : If #__debug_events_tab : Debug " leave tab - " + _this_\index[#__s_1] : EndIf
            _this_\index[#__s_1] =- 1
          EndIf
          If #__debug_events_tab : Debug " enter tab button - right" : EndIf
          Repaint = #True
        EndIf
        
      ElseIf _this_\tab\bar\button[#__b_1]\len And
             _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_1])
        
        If _this_\tab\bar\button[#__b_1]\color\state <> #__s_1
          If _this_\tab\bar\button[#__b_1]\color\state <> #__s_3
            _this_\tab\bar\button[#__b_1]\color\state = #__s_1
          EndIf
          
          If _this_\tab\bar\button[#__b_2]\color\state <> #__s_0 : If #__debug_events_tab : Debug " leave tab button - right to left" : EndIf
            If _this_\tab\bar\button[#__b_2]\color\state <> #__s_3  
              _this_\tab\bar\button[#__b_2]\color\state = #__s_0
            EndIf
          EndIf
          
          If _this_\index[#__s_1] >= 0 : If #__debug_events_tab : Debug " leave tab - " + _this_\index[#__s_1] : EndIf
            _this_\index[#__s_1] =- 1
          EndIf
          If #__debug_events_tab : Debug " enter tab button - left" : EndIf
          Repaint = #True
        EndIf
        
      Else
        If _this_\index[#__s_1] =- 1
          If _this_\tab\bar\button[#__b_1]\color\state <> #__s_0 : If #__debug_events_tab : Debug " leave tab button - left" : EndIf
            If _this_\tab\bar\button[#__b_1]\color\state <> #__s_3 
              _this_\tab\bar\button[#__b_1]\color\state = #__s_0
            EndIf
          EndIf
          
          If _this_\tab\bar\button[#__b_2]\color\state <> #__s_0 : If #__debug_events_tab : Debug " leave tab button - right" : EndIf
            If _this_\tab\bar\button[#__b_2]\color\state <> #__s_3  
              _this_\tab\bar\button[#__b_2]\color\state = #__s_0
            EndIf
          EndIf
          Repaint = #True
        EndIf
        
        If _this_\count\items
          ForEach _this_\tab\_s()
            If _this_\tab\_s()\draw
              If _from_point_(mouse_x, mouse_y, _this_\tab\_s()) And
                 _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_3])
                
                If _this_\index[#__s_1] <> _this_\tab\_s()\index
                  If _this_\index[#__s_1] >= 0
                    If #__debug_events_tab : Debug " leave tab - " + _this_\index[#__s_1] : EndIf
                  EndIf
                  
                  _this_\index[#__s_1] = _this_\tab\_s()\index
                  If #__debug_events_tab : Debug " enter tab - " + _this_\index[#__s_1] : EndIf
                EndIf
                Repaint = #True
                Break
                
              ElseIf _this_\index[#__s_1] = _this_\tab\_s()\index
                If #__debug_events_tab : Debug " leave tab - " + _this_\index[#__s_1] : EndIf
                _this_\index[#__s_1] =- 1
                Repaint = #True
                Break
              EndIf
            EndIf
          Next
        EndIf
      EndIf
      
    ElseIf _event_type_ = #__Event_LeftButtonDown
      If _this_\index[#__s_1] =- 1
        Select #__s_1
          Case _this_\tab\bar\button[#__b_1]\color\state
            If Bar_Change(_this_\tab\bar, (_this_\tab\bar\page\pos - _this_\tab\bar\scroll_step))   
              If Not _bar_in_start_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#__b_2]\color\state = #__s_3 : If #__debug_events_tab : Debug " enable tab button - right" : EndIf
                _this_\tab\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              
              _this_\tab\bar\button[#__b_1]\color\state = #__s_2
              Repaint = #True
            Else
              _this_\tab\bar\button[#__b_1]\color\state = #__s_3
            EndIf
            
          Case _this_\tab\bar\button[#__b_2]\color\state 
            If Bar_Change(_this_\tab\bar, (_this_\tab\bar\page\pos + _this_\tab\bar\scroll_step)) 
              If Not _bar_in_stop_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#__b_1]\color\state = #__s_3 : If #__debug_events_tab : Debug " enable tab button - left" : EndIf
                _this_\tab\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              
              _this_\tab\bar\button[#__b_2]\color\state = #__s_2 
              Repaint = #True
            Else
              _this_\tab\bar\button[#__b_2]\color\state = #__s_3
            EndIf
            
        EndSelect
      Else
        Repaint = SetState(_this_, _this_\index[#__s_1])
      EndIf
    EndIf
    
    If _this_\width[#__c_2] > 90
      ; ??????????? ?????? ????? ????? ??????????? ?????? ??????
      
      If _this_\tab\bar\button[#__b_2]\x > _this_\tab\bar\button[#__b_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_1])
          If _this_\tab\bar\button[#__b_1]\color\state = #__s_3 Or
             _this_\tab\bar\button[#__b_2]\color\state = #__s_3 Or
             (Not _this_\tab\bar\button[#__b_1]\color\state And
              Not _this_\tab\bar\button[#__b_2]\color\state)
            
            If _this_\tab\bar\button[#__b_1]\x > _this_\tab\bar\button[#__b_2]\x-_this_\tab\bar\button[#__b_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_2]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#__b_1], _this_\x[#__c_2])
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#__b_1]\x < _this_\tab\bar\button[#__b_2]\x-_this_\tab\bar\button[#__b_1]\width
            If Not _bar_in_start_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#__b_1], _this_\tab\bar\button[#__b_2]\x-_this_\tab\bar\button[#__b_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#__b_1]\color\state And 
           _this_\tab\bar\button[#__b_1]\color\state <> #__s_3
          _this_\tab\bar\button[#__b_1]\color\state = #__s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#__b_2]\color\state And 
           _this_\tab\bar\button[#__b_2]\color\state <> #__s_3
          _this_\tab\bar\button[#__b_2]\color\state = #__s_3
        EndIf
      EndIf
      
      If _this_\tab\bar\button[#__b_1]\x < _this_\tab\bar\button[#__b_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_2])
          If _this_\tab\bar\button[#__b_1]\color\state = #__s_3 Or
             _this_\tab\bar\button[#__b_2]\color\state = #__s_3 Or
             (Not _this_\tab\bar\button[#__b_1]\color\state And
              Not _this_\tab\bar\button[#__b_2]\color\state)
            
            If _this_\tab\bar\button[#__b_2]\x < _this_\tab\bar\button[#__b_1]\x+_this_\tab\bar\button[#__b_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#__b_1]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#__b_2], _this_\x[#__c_2]+_this_\width[#__c_2]-_this_\tab\bar\button[#__b_2]\width)
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#__b_2]\x > _this_\tab\bar\button[#__b_1]\x+_this_\tab\bar\button[#__b_1]\width
            If Not _bar_in_stop_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#__b_2], _this_\tab\bar\button[#__b_1]\x+_this_\tab\bar\button[#__b_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#__b_1]\color\state And 
           _this_\tab\bar\button[#__b_1]\color\state <> #__s_3
          _this_\tab\bar\button[#__b_1]\color\state = #__s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#__b_2]\color\state And 
           _this_\tab\bar\button[#__b_2]\color\state <> #__s_3
          _this_\tab\bar\button[#__b_2]\color\state = #__s_3
        EndIf
      EndIf
    EndIf
  EndMacro
  
  Macro _events_bar_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    
    If _event_type_ = #__Event_MouseMove Or
       _event_type_ = #__Event_LeftButtonUp Or
       _event_type_ = #__Event_MouseEnter Or
       _event_type_ = #__Event_MouseLeave
      
      If Not (_this_\root\mouse\buttons And _event_type_ <> #__Event_LeftButtonUp)
        If _this_\bar\button[#__b_3]\len And
           _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#__b_3])
          
          If _this_\bar\button[#__b_3]\color\state <> #__s_1
            If _this_\bar\button[#__b_3]\color\state <> #__s_3
              _this_\bar\button[#__b_3]\color\state = #__s_1
            EndIf
            
            If _this_\bar\button[#__b_1]\color\state <> #__s_0
              Debug " leave spin button - 1 to 3"
              If _this_\bar\button[#__b_1]\color\state <> #__s_3 
                _this_\bar\button[#__b_1]\color\state = #__s_0
              EndIf
            EndIf
            
            If _this_\bar\button[#__b_2]\color\state <> #__s_0
              Debug " leave spin button - 2 to 3"
              If _this_\bar\button[#__b_2]\color\state <> #__s_3  
                _this_\bar\button[#__b_2]\color\state = #__s_0
              EndIf
            EndIf
            
            If  Not _this_\root\mouse\buttons And _this_\cursor
              set_cursor(_this_, _this_\cursor)
            EndIf
            
            _this_\from = #__b_3
            Debug " enter spin button - up"
            Repaint = #True
          EndIf
          
        ElseIf _this_\bar\button[#__b_2]\len And 
               _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#__b_2])
          
          If _this_\bar\button[#__b_2]\color\state <> #__s_1
            If _this_\bar\button[#__b_2]\color\state <> #__s_3
              _this_\bar\button[#__b_2]\color\state = #__s_1
            EndIf
            
            If _this_\bar\button[#__b_1]\color\state <> #__s_0
              Debug " leave spin button - 1 to 2"
              If _this_\bar\button[#__b_1]\color\state <> #__s_3 
                _this_\bar\button[#__b_1]\color\state = #__s_0
              EndIf
            EndIf
            
            If _this_\bar\button[#__b_3]\color\state <> #__s_0
              Debug " leave spin button - 3 to 2"
              If _this_\bar\button[#__b_3]\color\state <> #__s_3  
                _this_\bar\button[#__b_3]\color\state = #__s_0
              EndIf
            EndIf
            
            _this_\from = #__b_2
            Debug " enter spin button - down"
            Repaint = #True
          EndIf
          
        ElseIf _this_\bar\button[#__b_1]\len And
               _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#__b_1])
          
          If _this_\bar\button[#__b_1]\color\state <> #__s_1
            If _this_\bar\button[#__b_1]\color\state <> #__s_3
              _this_\bar\button[#__b_1]\color\state = #__s_1
            EndIf
            
            If _this_\bar\button[#__b_2]\color\state <> #__s_0
              Debug " leave spin button - 2 to 1"
              If _this_\bar\button[#__b_2]\color\state <> #__s_3  
                _this_\bar\button[#__b_2]\color\state = #__s_0
              EndIf
            EndIf
            
            If _this_\bar\button[#__b_3]\color\state <> #__s_0
              Debug " leave spin button - 3 to 1"
              If _this_\bar\button[#__b_3]\color\state <> #__s_3  
                _this_\bar\button[#__b_3]\color\state = #__s_0
              EndIf
            EndIf
            
            _this_\from = #__b_1
            Debug " enter spin button - up"
            Repaint = #True
          EndIf
          
        Else
          If _this_\bar\button[#__b_1]\color\state <> #__s_0
            Debug " leave spin button - up"
            If _this_\bar\button[#__b_1]\color\state <> #__s_3 
              _this_\bar\button[#__b_1]\color\state = #__s_0
            EndIf
            Repaint = #True
          EndIf
          
          If _this_\bar\button[#__b_2]\color\state <> #__s_0
            Debug " leave spin button - down"
            If _this_\bar\button[#__b_2]\color\state <> #__s_3  
              _this_\bar\button[#__b_2]\color\state = #__s_0
            EndIf
            Repaint = #True
          EndIf
          
          If _this_\bar\button[#__b_3]\color\state <> #__s_0
            Debug " leave spin button - 3"
            If _this_\bar\button[#__b_3]\color\state <> #__s_3  
              _this_\bar\button[#__b_3]\color\state = #__s_0
            EndIf
            
            If Not _this_\root\mouse\buttons And _this_\cursor
              set_cursor(_this_, #PB_Cursor_Default)
            EndIf
            Repaint = #True
          EndIf
          
          If _this_\count\items
            ForEach _this_\tab\_s()
              If _this_\tab\_s()\draw
                If _from_point_(mouse_x, mouse_y, _this_\tab\_s()) And
                   _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#__b_3])
                  
                  If _this_\index[#__s_1] <> _this_\tab\_s()\index
                    If _this_\index[#__s_1] >= 0
                      Debug " leave tab - " + _this_\index[#__s_1]
                    EndIf
                    
                    _this_\index[#__s_1] = _this_\tab\_s()\index
                    Debug " enter tab - " + _this_\index[#__s_1]
                  EndIf
                  Break
                  
                ElseIf _this_\index[#__s_1] = _this_\tab\_s()\index
                  Debug " leave tab - " + _this_\index[#__s_1]
                  _this_\index[#__s_1] =- 1
                  Break
                EndIf
              EndIf
            Next
          EndIf
        EndIf
      EndIf
      
    ElseIf _event_type_ = #__Event_LeftButtonDown
      ;       If _this_\index[#__s_1] =- 1
      Select _this_\from ; #__s_1
        Case #__b_1      ; _this_\bar\button[#__b_1]\color\state
          If Bar_Change(_this_\bar, Bool(_this_\bar\inverted) * (_this_\bar\page\pos + _this_\bar\scroll_step) + 
                                    Bool(Not _this_\bar\inverted) * (_this_\bar\page\pos - _this_\bar\scroll_step))
            If Not _bar_in_start_(_this_\bar) And 
               _this_\bar\button[#__b_2]\color\state = #__s_3 
              
              Debug " enable tab button - right"
              _this_\bar\button[#__b_2]\color\state = #__s_0
            EndIf
            
            _this_\bar\button[#__b_1]\color\state = #__s_2
            If _this_\type = #__Type_ScrollBar Or
               _this_\type = #__Type_Spin
              bar_update(_this_) ; _this_\bar\thumb\pos = _bar_ThumbPos(_this_, _bar_invert_(_this_\bar, _this_\bar\page\pos, _this_\bar\inverted))
            EndIf
            Repaint = #True
          EndIf
          
        Case #__b_2 ; _this_\bar\button[#__b_2]\color\state 
          If Bar_Change(_this_\bar, Bool(_this_\bar\inverted) * (_this_\bar\page\pos - _this_\bar\scroll_step) + 
                                    Bool(Not _this_\bar\inverted) * (_this_\bar\page\pos + _this_\bar\scroll_step))
            If Not _bar_in_stop_(_this_\bar) And 
               _this_\bar\button[#__b_1]\color\state = #__s_3 
              
              Debug " enable tab button - left"
              _this_\bar\button[#__b_1]\color\state = #__s_0
            EndIf
            
            _this_\bar\button[#__b_2]\color\state = #__s_2 
            If _this_\type = #__Type_ScrollBar Or
               _this_\type = #__Type_Spin
              bar_update(_this_) ; _this_\bar\thumb\pos = _bar_ThumbPos(_this_, _bar_invert_(_this_\bar, _this_\bar\page\pos, _this_\bar\inverted))
            EndIf
            Repaint = #True
          EndIf
          
        Case #__b_3 ; _this_\bar\button[#__b_3]\color\state
                    ;If _this_\bar\button[#__b_3]\color\state <> #__s_2 
          _this_\bar\button[#__b_3]\color\state = #__s_2
          If _this_\bar\vertical
            delta = _mouse_y_ - _this_\bar\thumb\pos
          Else
            delta = _mouse_x_ - _this_\bar\thumb\pos
          EndIf
          
          Repaint = #True
          ;EndIf
          
      EndSelect
      ;       Else
      ;         Repaint = SetState(_this_, _this_\index[#__s_1])
      ;       EndIf
    EndIf
    
  EndMacro
  
  
  Procedure _events_tree_(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
    Protected result
    
    If eventtype = #__Event_DragStart
      Debug "drag - "+*this
      
      If *this\row\selected <> *row_selected
        *this\row\selected = *row_selected
        ;*this\row\selected\color\state = 2
        
        Post(#__Event_Change, *this, *this\index[#__s_1])
        Result = 1
      EndIf
      
    ElseIf eventtype = #__Event_LeftButtonUp 
      ; ;           If *this = Root()\leave And Root()\leave\root\mouse\buttons
      ; ;             Root()\leave\root\mouse\buttons = 0
      
      Debug *row_selected
      If *this\row\box\checked 
        *this\row\box\checked = 0
        
      ElseIf *this\index[#__s_1] >= 0 And Not *this\row\drag
        
        If *this\row\selected <> *row_selected
          *this\row\selected = *row_selected
          *this\row\selected\color\state = 2
          
          Post(#__Event_Change, *this, *this\index[#__s_1])
          Result = 1
        EndIf
      EndIf
      
    ElseIf eventtype = #__Event_LeftButtonDown
      If *this\index[#__s_1] >= 0
        If _from_point_(mouse_x, mouse_y, *this\row\_s()\box[1])
          _tree_set_state_(*this, *this\row\_s(), 1)
          *this\row\box\checked = 1
          
          Result = #True
        ElseIf *this\flag\buttons And *this\row\_s()\childrens And _from_point_(mouse_x, mouse_y, *this\row\_s()\box[0])
          *this\change = 1
          *this\row\box\checked = 2
          *this\row\_s()\box[0]\checked ! 1
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
              *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
            Else
              Break
            EndIf
          Wend
          PopListPosition(*this\row\_s())
          
          If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
            _tree_items_update_(*this, *this\row\_s())
            StopDrawing()
          EndIf
          
          Result = #True
        Else
          
          If *row_selected <> *this\row\_s()
            If *this\row\selected 
              *this\row\selected\color\state = 0
            EndIf
            
            *row_selected = *this\row\_s()
            *this\row\_s()\color\state = 2
          EndIf
          
          
          ; ;                 ;                   If \flag\multiselect
          ; ;                 ;                     _multi_select_(*this, \row\index, \row\selected\index)
          ; ;                 ;                   EndIf
          ; ;                 
          ; ;                 If *this\row\tt And *this\row\tt\visible
          ; ;                   tt_close(*this\row\tt)
          ; ;                 EndIf
          ; ;                 
          Result = #True
        EndIf
      EndIf
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure events_key_tree(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
    Protected Result
    ; *this\row\selected = ?????
    
    
    With *this
      If eventtype = #__Event_KeyDown
        
        Select *this\root\keyboard\key
          Case #PB_Shortcut_PageUp
            If Bar_SetState(*this\scroll\v, 0) 
              *this\change = 1 
              Result = 1
            EndIf
            
          Case #PB_Shortcut_PageDown
            If Bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
              *this\change = 1 
              Result = 1
            EndIf
            
          Case #PB_Shortcut_Up, #PB_Shortcut_Home
            If *this\row\selected
              If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                 (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                
                If Bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos-18) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              ElseIf *this\row\selected\index > 0
                ; select modifiers key
                If (*this\root\keyboard\key = #PB_Shortcut_Home Or
                    (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                  SelectElement(*this\row\_s(), 0)
                Else
                  SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                  
                  If *this\row\_s()\hide
                    While PreviousElement(*this\row\_s())
                      If Not *this\row\_s()\hide
                        Break
                      EndIf
                    Wend
                  EndIf
                EndIf
                
                If *this\row\selected <> *this\row\_s()
                  *this\row\selected\color\state = 0
                  *this\row\selected  = *this\row\_s()
                  *this\row\_s()\color\state = 2
                  *row_selected = *this\row\_s()
                  
                  Post(#__Event_Change, *this, *this\index[#__s_1])
                  Result = 1
                EndIf
                
                *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                
              EndIf
            EndIf
            
          Case #PB_Shortcut_Down, #PB_Shortcut_End
            If *this\row\selected
              If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                 (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                
                If Bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos+18) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              ElseIf *this\row\selected\index < (*this\count\items - 1)
                ; select modifiers key
                If (*this\root\keyboard\key = #PB_Shortcut_End Or
                    (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                  SelectElement(*this\row\_s(), (*this\count\items - 1))
                Else
                  SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                  
                  If *this\row\_s()\hide
                    While NextElement(*this\row\_s())
                      If Not *this\row\_s()\hide
                        Break
                      EndIf
                    Wend
                  EndIf
                EndIf
                
                If *this\row\selected <> *this\row\_s()
                  *this\row\selected\color\state = 0
                  *this\row\selected  = *this\row\_s()
                  *this\row\_s()\color\state = 2
                  *row_selected = *this\row\_s()
                  
                  Post(#__Event_Change, *this, *this\index[#__s_1])
                  Result = 1
                EndIf
                
                *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                
              EndIf
            EndIf
            
          Case #PB_Shortcut_Left
            If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
               (*this\root\keyboard\key[1] & #PB_Canvas_Control)
              
              *this\change = Bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos-(*this\scroll\h\bar\page\end/10)) 
              Result = 1
            EndIf
            
          Case #PB_Shortcut_Right
            If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
               (*this\root\keyboard\key[1] & #PB_Canvas_Control)
              
              *this\change = Bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos+(*this\scroll\h\bar\page\end/10)) 
              Result = 1
            EndIf
            
        EndSelect
        
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i From(*this._s_widget, mouse_x.l, mouse_y.l)
    Protected result.i
    
    If *this And *this\count\childrens
      ;Debug ListSize((*this\childrens()\childrens()) );*this\count\childrens
      
      ;PushListPosition(*this\childrens())    ;
      LastElement(*this\childrens())         ; ??? ?? ?????? ? ?????????? ????????
      Repeat                                 ; ?????????? ? ???? ????
        If Not *this\childrens()\hide And _from_point_(mouse_x,mouse_y, *this\childrens(), [#__c_4]) 
          ; Debug *this\childrens()\index
          If *this\childrens()\count\childrens
            ; result = From(*this\childrens(), mouse_x, mouse_y)
            
            LastElement(*this\childrens()\childrens())  ; ??? ?? ?????? ? ?????????? ????????
            Repeat                                      ; ?????????? ? ???? ????
              If Not *this\childrens()\childrens()\hide And _from_point_(mouse_x,mouse_y, *this\childrens()\childrens(), [#__c_4]) 
                
                If *this\childrens()\childrens()\count\childrens
                  result = From(*this\childrens()\childrens(), mouse_x, mouse_y)
                  
                  If Not result
                    ; parent of children
                    result = *this\childrens()\childrens()
                  EndIf
                Else
                  ; last child
                  result = *this\childrens()\childrens()
                EndIf
                
                Break
              EndIf
              
            Until PreviousElement(*this\childrens()\childrens()) = #False 
            
            If Not result
              ; parent of children
              result = *this\childrens()
            EndIf
          Else
            ; last child
            result = *this\childrens()
          EndIf
          
          Break
        EndIf
        
      Until PreviousElement(*this\childrens()) = #False 
      ;PopListPosition(*this\childrens())
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Events(*this._s_widget, eventtype.i, mouse_x.i=0, mouse_y.i=0)
    Protected repaint.b
    Static delta.l
    
    With *this
      If Not _is_widget_(*this)
        ProcedureReturn
      EndIf
      
      ;       ; anchors events
      ;       If a_callback(*this, eventtype, *this\root\mouse\buttons, mouse_x,mouse_y)
      ;         ProcedureReturn 1
      ;       EndIf
      
      If eventtype = #__Event_MouseMove Or
         eventtype = #__Event_LeftButtonUp Or
         eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseLeave
        
        ; Columns at point
        If ListSize(\columns())
          
          ForEach \columns()
            If \columns()\draw
              If (mouse_x>=\columns()\x And mouse_x=<\columns()\x+\columns()\width+1 And 
                  mouse_y>=\columns()\y And mouse_y=<\columns()\y+\columns()\height)
                
                *this\index[#__s_1] = \columns()\index
                Break
                ;             Else
                ;               *this\index[#__s_1] =- 1
              EndIf
            EndIf
            
            ; columns items at point
            ForEach \columns()\items()
              If \columns()\items()\draw
                If (mouse_x>\x[#__c_2] And mouse_x=<\x[#__c_2]+\width[#__c_2] And 
                    mouse_y>\columns()\items()\y And mouse_y=<\columns()\items()\y+\columns()\items()\height)
                  \columns()\index[#__s_1] = \columns()\items()\index
                  Break
                EndIf
              EndIf
            Next
          Next 
          
        ElseIf ListSize(\items())
          ; items at point
          ForEach \items()
            If \items()\draw
              If (mouse_y>\items()\y And mouse_y=<\items()\y+\items()\height)
                
                If *this\index[#__s_1] <> \items()\index
                  *this\index[#__s_1] = \items()\index
                  
                  repaint = 1
                EndIf
                ; Debug " i "+*this\index[#__s_1]+" "+ListIndex(\items())
                Break
                ;             ElseIf *this\index[#__s_1] = \items()\index
                ;               ;Debug 77777
                ;               *this\index[#__s_1] =- 1
                ;               Break
              EndIf
            EndIf
          Next
          
        ElseIf ListSize(\row\draws())
          ; items at point
          ForEach \row\draws()
            If \row\draws()\draw
              If (mouse_y>\row\draws()\y-*this\scroll\v\bar\page\pos And 
                  mouse_y=<\row\draws()\y+\row\draws()\height-*this\scroll\v\bar\page\pos)
                
                If *this\index[#__s_1] <> \row\draws()\index
                  *this\index[#__s_1] = \row\draws()\index
                  
                  If \row\_s()\color\state = #__s_1
                    \row\_s()\color\state = #__s_0
                  EndIf
                  SelectElement(\row\_s(), *this\index[#__s_1])
                  \row\_s()\color\state = #__s_1
                  
                  repaint = 1
                EndIf
                ; Debug " i "+*this\index[#__s_1]+" "+ListIndex(\row\draws())
                Break
                ;             ElseIf \index[#__s_1] = \row\draws()\index
                ;               ;Debug 77777
                ;               \index[#__s_1] =- 1
                ;               Break
              EndIf
            EndIf
          Next
          
          
          ; ;           ; at item from points
          ; ;         ForEach *this\row\draws()
          ; ;           If (mouse_y >= *this\row\draws()\y-*this\scroll\v\bar\page\pos And
          ; ;               mouse_y < *this\row\draws()\y+*this\row\draws()\height-*this\scroll\v\bar\page\pos)
          ; ;             
          ; ;             If *this\index[#__s_1] <> *this\row\draws()\index
          ; ;               If *this\index[#__s_1] >= 0 
          ; ;                 ; event mouse leave line
          ; ;                 If (*this\row\_s()\color\state = 1 Or down)
          ; ;                   *this\row\_s()\color\state = 0
          ; ;                 EndIf
          ; ;                 
          ; ; ; ;                 ; close tooltip on the item
          ; ; ; ;                 If *this\row\tt And *this\row\tt\visible
          ; ; ; ;                   tt_close(*this\row\tt)
          ; ; ; ;                 EndIf
          ; ;               EndIf
          ; ;               
          ; ;               *this\index[#__s_1] = *this\row\draws()\index
          ; ;               
          ; ;               If selectElement(*this\row\_s(), *this\index[#__s_1])
          ; ;                 ; event mouse enter line
          ; ;                 If down And *this\flag\multiselect 
          ; ;                   _tree_items_multi_select_(*this, *this\index[#__s_1], *this\row\selected\index)
          ; ;                   
          ; ;                 ElseIf *this\row\_s()\color\state = 0
          ; ;                   *this\row\_s()\color\state = 1+Bool(down)
          ; ;                   
          ; ;                   If down
          ; ;                     *this\row\selected = *this\row\_s()
          ; ;                   EndIf
          ; ;                 EndIf
          ; ;                 
          ; ; ; ;                 ; create tooltip on the item
          ; ; ; ;                 If Bool((*this\flag\buttons=0 And *this\flag\lines=0)) And *this\row\_s()\len > *this\width[2]
          ; ; ; ;                   tt_creare(*this, GadgetX(*this\root\gadget, #PB_Gadget_ScreenCoordinate), GadgetY(*this\root\gadget, #PB_Gadget_ScreenCoordinate))
          ; ; ; ;                 EndIf
          ; ;                 
          ; ;                 Result = #True
          ; ;               EndIf
          ; ;             EndIf
          ; ;             
          ; ;             Break
          ; ;           EndIf
          ; ;         Next
          ; ;          ; Debug \index[#__s_1]
          ; ;         
          ; ; ;         ElseIf ListSize(\row\_s())
          ; ; ;           ; items at point
          ; ; ;           ForEach \row\_s()
          ; ; ;             If \row\_s()\draw
          ; ; ;               If (mouse_y>\row\_s()\y And mouse_y=<\row\_s()\y+\row\_s()\height)
          ; ; ;                 
          ; ; ;                 If \index[#__s_1] <> \row\_s()\index
          ; ; ;                   \index[#__s_1] = \row\_s()\index
          ; ; ;                   
          ; ; ;                   repaint = 1
          ; ; ;                 EndIf
          ; ; ;                 ; Debug " i "+\index[#__s_1]+" "+ListIndex(\row\_s())
          ; ; ;                 Break
          ; ; ;                 ;             ElseIf \index[#__s_1] = \row\_s()\index
          ; ; ;                 ;               ;Debug 77777
          ; ; ;                 ;               \index[#__s_1] =- 1
          ; ; ;                 ;               Break
          ; ; ;               EndIf
          ; ; ;             EndIf
          ; ; ;           Next
          ; ; ;           
          ; ; ;           Debug \index[#__s_1]
        EndIf
        
        Select \type
          Case #__Type_Tree        : _events_tree_(*this, eventtype, mouse_x, mouse_y)
          Case #__Type_Panel       : _events_panel_(*this, eventtype, mouse_x, mouse_y)
          Case #__Type_Spin        : _events_bar_(*this, eventtype, mouse_x, mouse_y)
          Case #__Type_Splitter    : _events_bar_(*this, eventtype, mouse_x, mouse_y)
          ;Case #__Type_Splitter    : _events_bar_(*this, eventtype, mouse_x-*this\x, mouse_y-*this\y)
          Case #__Type_TrackBar    : _events_bar_(*this, eventtype, mouse_x, mouse_y)
          Case #__Type_ScrollBar   : _events_bar_(*this, eventtype, mouse_x, mouse_y)
          Case #__Type_ProgressBar : _events_bar_(*this, eventtype, mouse_x, mouse_y)
        EndSelect     
      EndIf
      
      Select eventtype 
        Case #__Event_Focus, 
             #__Event_LostFocus
          repaint = 1
          
        Case #__Event_MouseEnter
          If \interact
            If *this\cursor And *this\text 
              If _from_point_(mouse_x, mouse_y, *this\text)
                set_cursor(*this, *this\cursor)
                \color\state = #__s_1
              EndIf
            Else
              \color\state = #__s_1
            EndIf
            
            repaint = 1
          EndIf
          
          Post(eventtype, *this)
          
        Case #__Event_MouseLeave
          If \interact
            If *this\cursor And *this\text
              set_cursor(*this, #PB_Cursor_Default)
            Else
              \color\state = #__s_0
            EndIf
            
            repaint = 1
          EndIf
          
          Post(eventtype, *this)
          
        Case #__Event_MouseMove
          If *this\cursor And *this\text 
            If _from_point_(mouse_x, mouse_y, *this\text)
              If \color\state <> #__s_1
                set_cursor(*this, *this\cursor)
                \color\state = #__s_1
                repaint = 1
              EndIf
            Else
              If \color\state <> #__s_0
                set_cursor(*this, #PB_Cursor_Default)
                \color\state = #__s_0
                repaint = 1
              EndIf
            EndIf
          EndIf
          
          If \type = #__Type_Window
            If _from_point_(mouse_x, mouse_y, *this\caption\button[0])
              If *this\caption\button[0]\color\state <> 2
                *this\caption\button[0]\color\state = 2
                Repaint = 1
              EndIf
            Else
              If *this\caption\button[0]\color\state <> 1
                *this\caption\button[0]\color\state = 1
                Repaint = 1
              EndIf
            EndIf
            If _from_point_(mouse_x, mouse_y, *this\caption\button[1])
              If *this\caption\button[1]\color\state <> 2
                *this\caption\button[1]\color\state = 2
                Repaint = 1
              EndIf
            Else
              If *this\caption\button[1]\color\state <> 1
                *this\caption\button[1]\color\state = 1
                Repaint = 1
              EndIf
            EndIf
            If _from_point_(mouse_x, mouse_y, *this\caption\button[2])
              If *this\caption\button[2]\color\state <> 2
                *this\caption\button[2]\color\state = 2
                Repaint = 1
              EndIf
            Else
              If *this\caption\button[2]\color\state <> 1
                *this\caption\button[2]\color\state = 1
                Repaint = 1
              EndIf
            EndIf
            
            If \root\mouse\buttons
              If *this\caption\interact
                repaint = Resize(*this, mouse_x-\root\mouse\delta\x, mouse_y-\root\mouse\delta\y, #PB_Ignore, #PB_Ignore)
              EndIf
            EndIf
            
          EndIf
          
          If delta
            If \type = #PB_GadgetType_Splitter
              If \bar\vertical
                Repaint = Splitter::SetPos(*this, (mouse_y-delta))
              Else
                Repaint = Splitter::SetPos(*this, (mouse_x-delta))
              EndIf
            Else
              If \bar\vertical
                Repaint = Bar_SetPos(*this, (mouse_y-delta))
              Else
                Repaint = Bar_SetPos(*this, (mouse_x-delta))
              EndIf
            EndIf
          EndIf
          
        Case #__Event_LeftDoubleClick 
          
          If \from =- 1
            If \bar\vertical
              Repaint = Bar_SetPos(*this, (mouse_y-\bar\thumb\len/2))
            Else
              Repaint = Bar_SetPos(*this, (mouse_x-\bar\thumb\len/2))
            EndIf
          EndIf
          
        Case #__Event_LeftButtonDown,
             #__Event_RightButtonDown 
          
          If eventtype = #__Event_LeftButtonDown
            Select \type
              Case #__Type_Tree
                _events_tree_(*this, #__Event_LeftButtonDown, mouse_x, mouse_y)
                
              Case #__Type_Panel
                _events_panel_(*this, #__Event_LeftButtonDown, mouse_x, mouse_y)
                
              Case #__Type_Window
                *this\caption\interact = _from_point_(mouse_x, mouse_y, *this\caption, [2])
                
                ; close button
                If _from_point_(mouse_x, mouse_y, *this\caption\button[0])
                  ProcedureReturn window_close(*this)
                EndIf
                
                ; maximize button
                If _from_point_(mouse_x, mouse_y, *this\caption\button[1])
                  If Not *this\resize & #__resize_maximize And
                     Not *this\resize & #__resize_minimize
                    
                    ProcedureReturn window_setstate(*this, #__window_maximize)
                  Else
                    ProcedureReturn window_setstate(*this, #__window_normal)
                  EndIf
                EndIf
                
                ; minimize button
                If _from_point_(mouse_x, mouse_y, *this\caption\button[2])
                  If Not *this\resize & #__resize_minimize
                    ProcedureReturn window_setstate(*this, #__window_minimize)
                  EndIf
                EndIf
                
              Case #__Type_ComboBox
                \combo_box\checked ! 1
                
                If \combo_box\checked
                  Display_popup(*this, \popup)
                Else
                  HideWindow(\popup\root\window, 1)
                EndIf
                repaint = 1
                
              Case #__Type_Option
                Repaint = SetState(*this, 1)
                
              Case #__Type_CheckBox
                Repaint = SetState(*this, Bool(\check_box\checked = #PB_Checkbox_Checked) ! 1)
                
              Case #__Type_Tree,
                   #__Type_ListView
                
                ; Repaint = Set_State(*this, \row\_s(), \index[#__s_1]) 
                
              Case #__Type_ListIcon
                If SelectElement(\columns(), 0)
                  Repaint = Set_State(*this, \columns()\items(), \columns()\index[#__s_1]) 
                EndIf
                
              Case #__Type_HyperLink
                If \cursor[1] <> GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
                  SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                repaint = 1
                
              Case #__Type_TrackBar,
                   #__Type_ProgressBar,
                   #__Type_ScrollBar, 
                   #__Type_Spin,
                   #__Type_Splitter
                
                _events_bar_(*this, #__Event_LeftButtonDown, mouse_x, mouse_y)
                
              Case #__Type_Button
                *this\color\state = 2
                repaint = 1
                
            EndSelect
            
            ; repaint = 1
          EndIf
          
        Case #__Event_LeftButtonUp, 
             #__Event_RightButtonUp 
          
          If \type = #__Type_Window
            *this\caption\interact = 0
          EndIf
          
          delta = 0
          ;           ;repaint | Events(*this, \from, eventtype, mouse_x, mouse_y)
          ;           select \type
          ;             case #__Type_tree
          ;               _events_tree_(*this, #__Event_leftButtonUp, mouse_x, mouse_y)
          ;               
          ; ;             case #__Type_Spin
          ; ;               _events_bar_(*this, #__Event_mouseMove, mouse_x, mouse_y)
          ;           Endselect
          ;           
          
          Post(eventtype, *this)
          repaint = 1
          
          ; active widget key state
        Case #__Event_Input, 
             #__Event_KeyDown, 
             #__Event_KeyUp
          
          If (GetActive()\gadget = *this Or *this = GetActive())
            
            \root\keyboard\input = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Input)
            \root\keyboard\key = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Key)
            \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
            
            Select \type
              Case #__Type_Tree, 
                   #__Type_ListView, 
                   #__Type_ListIcon
                
                repaint | events_key_tree(*this, eventtype, mouse_x, mouse_y)
            EndSelect
          EndIf
          
      EndSelect
      
      ; text editable events
      If \text And \text\editable
        Select \type
          Case #__Type_String, 
               #__Type_Editor
            Repaint | editor::events(*this, eventtype)
            
        EndSelect
      EndIf
      
      ; post valid event 
      If \flag\transform
        Post(eventtype, *this, *this\index[#__s_1])
      Else
        Select eventtype
          Case #__Event_Change
            Select \type
              Case #__Type_Tree, 
                   #__Type_ListView, 
                   #__Type_ListIcon
                
                Post(eventtype, *this, *this\index[#__s_1])
            EndSelect
            
          Case #__Event_DragStart,
               #__Event_drop
            
            Select \type
              Case #__Type_Image, 
                   #__Type_Tree, 
                   #__Type_ListView, 
                   #__Type_ListIcon
                
                Post(eventtype, *this, *this\index[#__s_1])
            EndSelect
            
          Case #__Event_Focus,
               #__Event_LostFocus 
            
            Select \type
              Case #__Type_Window,
                   #__Type_String,
                   #__Type_Tree, 
                   #__Type_ListView, 
                   #__Type_ListIcon
                
                Post(eventtype, *this, *this\index[#__s_1])
            EndSelect
            
          Case #__Event_LeftClick 
            Select \type
              Case #__Type_Button,
                   #__Type_Tree, 
                   #__Type_ListView, 
                   #__Type_ListIcon
                
                Post(eventtype, *this, *this\index[#__s_1])
            EndSelect
            
            
        EndSelect
      EndIf
    EndWith
    
    ;     If repaint
    ProcedureReturn repaint
    ;     EndIf
    
    
    CompilerIf #PB_Compiler_IsMainFile
      With *this
        Select eventtype
          Case #__Event_LeftClick
            Debug "click - "+*this
            ;Post(eventtype, *this, *this\index[#__s_1])
            
          Case #__Event_Change
            Debug "change - "+*this
            ;Post(eventtype, *this, *this\index[#__s_1])
            
          Case #__Event_DragStart
            Debug "drag - "+*this
            
            ;           If *this\row\selected <> *row_selected
            ;             *this\row\selected = *row_selected
            ;             ;*this\row\selected\color\state = 2
            ;             
            ;             repaint | Events(*this, #__Event_change, mouse_x, mouse_y)
            ;           EndIf
            ;           
            ;           Post(eventtype, *this, *this\index[#__s_1])
            
          Case #__Event_drop
            Debug "drop - "+*this
            
          Case #__Event_Focus
            Debug "focus - "+*this
            
          Case #__Event_LostFocus
            Debug "lost focus - "+*this
            
          Case #__Event_LeftButtonDown
            Debug "left down - "+*this
            
          Case #__Event_LeftButtonUp
            Debug "left up - "+*this
            
          Case #__Event_MouseEnter
            Debug "enter - "+*this\index
            ;           If GetButtons(*this)
            ;             *this\color\back = $00FF00
            ;           Else
            ;             *this\color\back = $0000FF
            ;           EndIf
            
          Case #__Event_MouseLeave
            Debug "leave - "+*this\index
            ;           \color\back = $FF0000
            
          Case #__Event_MouseMove
            ; Debug "move - "+*this
            
        EndSelect
        
      EndWith
    CompilerEndIf
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure CallBack()
    Protected Canvas.i = EventGadget()
    Protected eventtype.i = EventType()
    Protected Repaint, Change, enter, leave
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      mouse_x = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      mouse_y = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Protected *this._s_widget
    root() = GetGadgetData(Canvas)
    
    Select eventtype
      Case #__Event_repaint 
        Repaint = 1
        
      Case #__Event_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        ;Resize(root(), #PB_Ignore, #PB_Ignore, Width, Height)  
        Resize(root()\parent, #PB_Ignore, #PB_Ignore, Width-root()\parent\bs*2, Height-root()\parent\bs*2-root()\parent\__height)  
        ;         root()\Width = Width
        ;         root()\Height = Height 
        Repaint = 1
    EndSelect
    
    ; set mouse buttons
    If eventtype = #__Event_LeftButtonDown
      root()\mouse\buttons | #PB_Canvas_LeftButton
    ElseIf eventtype = #__Event_RightButtonDown
      root()\mouse\buttons | #PB_Canvas_RightButton
    ElseIf eventtype = #__Event_MiddleButtonDown
      root()\mouse\buttons | #PB_Canvas_MiddleButton
    ElseIf eventtype = #__Event_MouseMove
      If root()\mouse\x <> mouse_x
        root()\mouse\x = mouse_x
        change = #True
      EndIf
      
      If root()\mouse\y <> mouse_y
        root()\mouse\y = mouse_y
        change = #True
      EndIf
      
      ; Drag start
      If root()\mouse\buttons And Not root()\mouse\drag And
         root()\mouse\x>root()\mouse\delta\x-3 And 
         root()\mouse\x<root()\mouse\delta\x+3 And 
         root()\mouse\y>root()\mouse\delta\y-3 And
         root()\mouse\y<root()\mouse\delta\y+3
        
        root()\mouse\drag = 1
        repaint | Events(root()\entered, #__Event_DragStart, mouse_x, mouse_y)
      EndIf
      
    ElseIf Not root()\mouse\buttons And 
           (eventtype = #__Event_MouseEnter Or 
            eventtype = #__Event_MouseLeave)
      change =- 1
    EndIf
    
    ; widget enter&leave mouse events
    If change
      *this = From(root(), mouse_x, mouse_y)
      
      If Change =- 1
        *this = root()
      EndIf
      
      ; scrollbars events
      If *this And *this\scroll
        If *this\scroll\v And Not *this\scroll\v\hide And 
           *this\scroll\v\type And _from_point_(mouse_x,mouse_y, *this\scroll\v)
          *this = *this\scroll\v
        ElseIf *this\scroll\h And Not *this\scroll\h\hide And 
               *this\scroll\h\type And _from_point_(mouse_x,mouse_y, *this\scroll\h)
          *this = *this\scroll\h
        EndIf
      EndIf
      
      If root()\entered And root()\entered <> *this And root()\entered\state <> #__s_0 ; And Not (*this\parent And *this\parent\scroll)
        root()\entered\state = #__s_0
        
        If Not root()\mouse\buttons
          Repaint | Events(root()\entered, #__Event_MouseLeave, mouse_x, mouse_y)
        EndIf
      EndIf
      
      If *this And *this\state <> #__s_1 ; And Not (*this\parent And *this\parent\scroll)
        *this\state = #__s_1
        root()\entered = *this
        
        If root()\mouse\buttons
          ; set drop start
          DD::EventDrop(root()\entered, #__Event_MouseEnter)
        Else
          Repaint | Events(root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
        EndIf
      EndIf
    EndIf
    
    If eventtype <> #__Event_MouseMove
      change = 1
      
      ; set active 
      If _is_widget_(root()\entered) And 
         (eventtype = #__Event_LeftButtonDown Or
          eventtype = #__Event_RightButtonDown)
        
        root()\selected = root()\entered
        root()\mouse\delta\x = mouse_x - root()\entered\x[#__c_3]
        root()\mouse\delta\y = mouse_y - root()\entered\y[#__c_3]
        
        ;         If root()\entered\type = #__Type_Window
        ;           If Not (_from_point_(mouse_x, mouse_y, root()\entered\caption\button[0]) Or
        ;                   _from_point_(mouse_x, mouse_y, root()\entered\caption\button[1]) Or 
        ;                   _from_point_(mouse_x, mouse_y, root()\entered\caption\button[2]))
        ;             Repaint | SetActive(root()\entered)
        ;           EndIf
        ;         Else
        Repaint | SetActive(root()\entered)
        ;         EndIf
      EndIf
    EndIf
    
    If eventtype = #__Event_LeftClick Or
       eventtype = #__Event_MouseLeave Or
       eventtype = #__Event_MouseEnter Or
       eventtype = #__Event_DragStart Or
       eventtype = #__Event_Focus
      ; 
    ElseIf eventtype = #__Event_Input Or
           eventtype = #__Event_KeyDown Or
           eventtype = #__Event_KeyUp
      
      ; widget key events
      If GetActive() 
        If GetActive()\gadget
          Repaint | Events(GetActive()\gadget, eventtype, mouse_x, mouse_y)
        Else
          Repaint | Events(GetActive(), eventtype, mouse_x, mouse_y)
        EndIf
      EndIf
      
    ElseIf Not root()\mouse\buttons And root()\entered And change 
      Repaint | Events(root()\entered, eventtype, mouse_x, mouse_y)
    ElseIf root()\selected And change 
      Repaint | Events(root()\selected, eventtype, mouse_x, mouse_y)
    EndIf
    
    ; reset mouse buttons
    If root()\mouse\buttons
      If eventtype = #__Event_LeftButtonUp
        root()\mouse\buttons &~ #PB_Canvas_LeftButton
      ElseIf eventtype = #__Event_RightButtonUp
        root()\mouse\buttons &~ #PB_Canvas_RightButton
      ElseIf eventtype = #__Event_MiddleButtonUp
        root()\mouse\buttons &~ #PB_Canvas_MiddleButton
      EndIf
      
      If Not root()\mouse\buttons
        ; post drop event
        If DD::EventDrop(Root()\entered, #__Event_LeftButtonUp)
          Events(Root()\entered, #__Event_drop, mouse_x, mouse_y)
        EndIf
        
        ;             If Not Root()\entered
        ;               
        ;               DD::EventDrop(-1, #__Event_leftButtonUp)
        ;               
        ;             EndIf
        
        If GetActive() 
          If GetActive()\state
            If Not root()\mouse\drag
              Repaint | Events(GetActive(), #__Event_LeftClick, mouse_x, mouse_y)
            EndIf
          Else
            Repaint | Events(GetActive(), #__Event_MouseLeave, mouse_x, mouse_y)
            Repaint | Events(root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
          EndIf
          
          If GetActive()\gadget
            If GetActive()\gadget\state
              If Not root()\mouse\drag
                Repaint | Events(GetActive()\gadget, #__Event_LeftClick, mouse_x, mouse_y)
              EndIf
            Else
              Repaint | Events(GetActive()\gadget, #__Event_MouseLeave, mouse_x, mouse_y)
              Repaint | Events(root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
            EndIf
          EndIf
        EndIf
        
        root()\selected = 0
        root()\mouse\drag = 0
      EndIf
    EndIf
    
    If Repaint 
      root()\repaint = #True
      
      ;       If root()\entered And root()\entered\bar\button[#__b_3]\color\state
      ; ;         Debug root()\entered\bar\button[#__b_3]\color\state
      ; ;       EndIf
      ;       ;       If root()\entered And root()\entered\type = #__Type_tree
      ;                ReDraw(root()\entered)
      ;            Else
      ReDraw(root())
      ;             EndIf
    EndIf
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  
  UseModule widget
  UseModule constants
  ;   UseModule structures
  
  
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._s_widget
  Global *Button_1._s_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure _Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*4)
  
  
  Global c2, _splitter_ 
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate) 
    Protected Height = WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)
    
    Resize(_splitter_, 10, 10, Width-20, Height-20) 
;     ResizeGadget(c2, 10, 10, Width-20, Height-20)
;     Resize(*Button_0, Width-90, #PB_Ignore, #PB_Ignore, Height-40)
;     Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-110, Height-40)
    
    SetWindowTitle(EventWindow(), Str(*Button_1\width))
  EndProcedure
  
  If Open(11, 0, 0, 380, 200, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    c2 = GetGadget(Root())
    Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
;     Button_1 = Tab(0, 0, 0, 0, 0, 0, 0); No need to specify size or coordinates
;     AddItem(Button_1, -1, "Tab_0")
;     AddItem(Button_1, -1, "Tab long long 1")
;     AddItem(Button_1, -1, "Tab_2")
;     Button_1 = Scroll(0, 0, 0, 0, 0, 100, 20) ; No need to specify size or coordinates
;     Button_1 = Splitter(0, 0, 0, 0, Button_10, Button_1, #PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    
    Button_2 = ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    
    ;     Splitter_3 = Splitter(0, 0, 0, 0, Splitter_2, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
;     Splitter_4 = Splitter(10, 10, 285+30, 140, Splitter_3, Splitter_0, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    Splitter_3 = Splitter(0, 0, 0, 0, Splitter_2, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_4 = Splitter(10, 10, 285+30, 140, Splitter_3, Splitter_0, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    

    SetState(Splitter_3, 40)
    SetState(Splitter_4, 245)
    
    If OpenList(Button_2)
      Button_4 = ScrollArea(-1, -1, 90, 90, 150, 150, 1)
      Define i
      For i=0 To 10;000
        Progress(10+i*2, 10+i*2, 50, 30, 1, 100, 30)
      Next
      CloseList()
      Progress(100, 10, 50, 30, 2, 100, 30)
      CloseList()
    EndIf
    
    redraw(root())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    ;PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
    ;     BindGadgetEvent(g, @CallBacks())
    ;     PostEvent(#PB_Event_gadget, 11,11, #__Event_resize)
    ;     
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = f---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP