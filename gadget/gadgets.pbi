
;IncludePath "/Users/as/Documents/GitHub/Widget/"
IncludePath "../"
XIncludeFile "widgets.pbi"
; XIncludeFile "../examples/empty.pb"
Uselib(widget)


;- <<<
CompilerIf Not Defined(DD, #PB_Module)
  DeclareModule DD
;     EnableExplicit
;     
;     ;- - _S_drop
;     Structure _S_drop
;       widget.i
;       cursor.i
;       
;       Type.i
;       Format.i
;       Actions.i
;       Text.s
;       ImageID.i
;       
;       Width.i
;       Height.i
;     EndStructure
;     
;     Global *Drag._S_drop
;     Global NewMap *Drop._S_drop()
;     
;     Macro EventDropText()
;       DD::DropText()
;     EndMacro
;     
;     Macro EventDropAction()
;       DD::DropAction()
;     EndMacro
;     
;     Macro EventDropType()
;       DD::DropType()
;     EndMacro
;     
;     Macro EventDropImage(_image_, _depth_=24)
;       DD::DropImage(_image_, _depth_)
;     EndMacro
;     
;     Macro DragText(_text_, _actions_=#PB_Drag_Copy)
;       DD::Text(_text_, _actions_)
;     EndMacro
;     
;     Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
;       DD::Image(_image_, _actions_)
;     EndMacro
;     
;     Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
;       DD::Private(_type_, _actions_)
;     EndMacro
;     
;     Macro EnableGadgetDrop(_this_, _format_, _actions_, _private_type_=0)
;       DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
;     EndMacro
;     Macro EnableWindowDrop(_this_, _format_, _actions_, _private_type_=0)
;       DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
;     EndMacro
;     
;     
;     Declare.s DropText()
;     Declare.i DropType()
;     Declare.i DropAction()
;     Declare.i DropImage(Image.i=-1, Depth.i=24)
;     
;     Declare.i Text(Text.S, Actions.i=#PB_Drag_Copy)
;     Declare.i Image(Image.i, Actions.i=#PB_Drag_Copy)
;     Declare.i Private(Type.i, Actions.i=#PB_Drag_Copy)
;     
;     Declare.i EnableDrop(*this, Format.i, Actions.i, PrivateType.i=0)
;     Declare.i EventDrop(*this, eventtype.l)
  EndDeclareModule
  
  Module DD
;     Macro _action_(_this_)
;       Bool(*Drag And _this_ And MapSize(*Drop()) And FindMapElement(*Drop(), Hex(_this_)) And *Drop()\Format = *Drag\Format And *Drop()\Type = *Drag\Type And *Drop()\Actions)
;     EndMacro
;     
;     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;       Import ""
;         PB_Object_EnumerateStart( PB_Objects )
;         PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
;         PB_Object_EnumerateAbort( PB_Objects )
;         ;PB_Object_GetObject( PB_Object , DynamicOrArrayID)
;         PB_Window_Objects.i
;         PB_Gadget_Objects.i
;         PB_Image_Objects.i
;         ;PB_Font_Objects.i
;       EndImport
;     CompilerElse
;       ImportC ""
;         PB_Object_EnumerateStart( PB_Objects )
;         PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
;         PB_Object_EnumerateAbort( PB_Objects )
;         ;PB_Object_GetObject( PB_Object , DynamicOrArrayID)
;         PB_Window_Objects.i
;         PB_Gadget_Objects.i
;         PB_Image_Objects.i
;         ;PB_Font_Objects.i
;       EndImport
;     CompilerEndIf
;     
;     ;   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;     ;     ; PB Interne Struktur Gadget MacOS
;     ;     Structure sdkGadget
;     ;       *gadget
;     ;       *container
;     ;       *vt
;     ;       UserData.i
;     ;       Window.i
;     ;       Type.i
;     ;       Flags.i
;     ;     EndStructure
;     ;   CompilerEndIf
;     
;     Procedure WindowPB(WindowID) ; Find pb-id over handle
;       Protected result, window
;       result = -1
;       PB_Object_EnumerateStart(PB_Window_Objects)
;       While PB_Object_EnumerateNext(PB_Window_Objects, @window)
;         If WindowID = WindowID(window)
;           result = window
;           Break
;         EndIf
;       Wend
;       PB_Object_EnumerateAbort(PB_Window_Objects)
;       ProcedureReturn result
;     EndProcedure
;     
;     Procedure GadgetPB(GadgetID) ; Find pb-id over handle
;       Protected result, Gadget
;       result = -1
;       PB_Object_EnumerateStart(PB_Gadget_Objects)
;       While PB_Object_EnumerateNext(PB_Gadget_Objects, @Gadget)
;         If GadgetID = GadgetID(Gadget)
;           result = Gadget
;           Break
;         EndIf
;       Wend
;       PB_Object_EnumerateAbort(PB_Gadget_Objects)
;       ProcedureReturn result
;     EndProcedure
;     
;     Procedure GetWindowUnderMouse()
;       
;       CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;         Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
;         
;         CocoaMessage(@Point, 0, "NSEvent mouseLocation")
;         WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
;         NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
;         NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
;         
;         ProcedureReturn NSWindow
;       CompilerEndIf
;       
;     EndProcedure
;     
;     Procedure enterID()
;       CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;         Protected.i NSWindow = GetWindowUnderMouse()
;         Protected pt.NSPoint
;         
;         If NSWindow
;           Protected CV = CocoaMessage(0, NSWindow, "contentView")
;           CocoaMessage(@pt, NSWindow, "mouseLocationOutsideOfEventStream")
;           Protected NsGadget = CocoaMessage(0, CV, "hitTest:@", @pt)
;         EndIf
;         
;         If NsGadget <> CV And NsGadget
;           If CV = CocoaMessage(0, NsGadget, "superview")
;             ProcedureReturn GadgetPB(NsGadget)
;           Else
;             ProcedureReturn GadgetPB(CocoaMessage(0, NsGadget, "superview"))
;           EndIf
;         Else
;           ProcedureReturn WindowPB(NSWindow)
;         EndIf
;         
;       CompilerEndIf
;     EndProcedure
;     
;     
;     
;     Procedure.i SetCursor(Canvas, ImageID.i, x=0, y=0)
;       Protected Result.i
;       
;       With *this
;         If Canvas And ImageID
;           CompilerSelect #PB_Compiler_OS
;             CompilerCase #PB_OS_Windows
;               Protected ico.ICONINFO
;               ico\fIcon = 0
;               ico\xHotspot =- x 
;               ico\yHotspot =- y 
;               ico\hbmMask = ImageID
;               ico\hbmColor = ImageID
;               
;               Protected *Cursor = CreateIconIndirect_(ico)
;               If Not *Cursor 
;                 *Cursor = ImageID 
;               EndIf
;               
;             CompilerCase #PB_OS_Linux
;               Protected *Cursor.GdkCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(), ImageID, x, y)
;               
;             CompilerCase #PB_OS_MacOS
;               Protected Hotspot.NSPoint
;               Hotspot\x = x
;               Hotspot\y = y
;               Protected *Cursor = CocoaMessage(0, 0, "NSCursor alloc")
;               CocoaMessage(0, *Cursor, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
;               
;           CompilerEndSelect
;           
;           SetGadgetAttribute(Canvas, #PB_Canvas_CustomCursor, *Cursor)
;         EndIf
;       EndWith
;       
;       ProcedureReturn Result
;     EndProcedure
;     
;     Procedure.i Cur(type)
;       Protected x=1,y=1
;       UsePNGImageDecoder()
;       
;       If type And *Drop()
;         *Drop()\cursor = CatchImage(#PB_Any, ?add, 601)
;         SetCursor(EventGadget(), ImageID(*Drop()\cursor), x,y)
;       Else
;         *Drag\cursor = CatchImage(#PB_Any, ?copy, 530)
;         SetCursor(EventGadget(), ImageID(*Drag\cursor), x,y)
;       EndIf
;       
;       DataSection
;         add: ; memory_size - (601)
;         Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000017000000,$0FBDF60000000408,$4D416704000000F5,$61FC0B8FB1000041,
;                $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
;                $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
;                $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$3854414449300100,$1051034ABB528DCB,
;                $58DB084146C5293D,$82361609B441886C,$AA4910922C455E92,$C2C105F996362274,$FC2FF417B0504FC2,$DEF7BB3BB9ACF1A0,
;                $B99CE66596067119,$2DB03A16C1101E67,$12D0B4D87B0D0B8F,$11607145542B450C,$190D04A4766FDCAA,$4129428FD14DCD04,
;                $98F0D525AEFE8865,$A1C4924AD95B44D0,$26A2499413E13040,$F4F9F612B8726298,$62A6ED92C07D5B54,$E13897C2BE814222,
;                $A75C5C6365448A6C,$D792BBFAE41D2925,$1A790C0B8161DC2F,$224D78F4C611BD60,$A1E8C72566AB9F6F,$2023A32BDB05D21B,
;                $0E3BC7FEBAF316E4,$8E25C73B08CF01B1,$385C7629FEB45FBE,$8BB5746D80621D9F,$9A5AC7132FE2EC2B,$956786C4AE73CBF3,
;                $FE99E13C707BB5EB,$C2EA47199109BF48,$01FE0FA33F4D71EF,$EE0F55B370F8C437,$F12CD29C356ED20C,$CBC4BD4A70C833B1,
;                $FFCD97200103FC1C,$742500000019D443,$3A65746164745845,$3200657461657263,$312D38302D393130,$3A35313A31315439,
;                $30303A30302B3930,$25000000B3ACC875,$6574616474584574,$00796669646F6D3A,$2D38302D39313032,$35313A3131543931,
;                $303A30302B35303A,$0000007B7E35C330,$6042AE444E454900
;         Data.b $82
;         add_end:
;         ;     EndDataSection
;         ;       
;         ;     DataSection
;         copy: ; memory_size - (530)
;         Data.q $0A1A0A0D474E5089,$524448490D000000,$1A00000010000000,$1461140000000408,$4D4167040000008C,$61FC0B8FB1000041,
;                $5248632000000005,$800000267A00004D,$80000000FA000084,$EA000030750000E8,$170000983A000060,$0000003C51BA9C70,
;                $87FF0044474B6202,$7009000000BFCC8F,$00C8000000735948,$ADE7FA6300C80000,$454D497407000000,$450A0F0B1308E307,
;                $63100000000C6AC0,$0020000000764E61,$0002000000200000,$000C8D7E6F010000,$2854414449E90000,$1040C20A31D27DCF,
;                $8B08226C529FD005,$961623685304458D,$05E8A288B1157A4A,$785858208E413C44,$AD03C2DE8803C505,$74CCDD93664D9893,
;                $5C25206CCCECC7D9,$0AF51740A487B038,$E4950624ACF41B10,$0B03925602882A0F,$504520607448C0E1,$714E75682A0F7A22,
;                $1EC4707FBC91940F,$EF1F26F801E80C33,$6FE840E84635C148,$47D13D78D54EC071,$5BDF86398A726F4D,$7DD0539F268C6356,
;                $39B40B3759101A3E,$2EEB2D02D7DBC170,$49172CA44A415AD2,$52B82E69FF1E0AC0,$CC0D0D97E9B7299E,$046FA509CA4B09C0,
;                $CB03993630382B86,$5E4840261A49AA98,$D3951E21331B30CF,$262C1B127F8F8BD3,$250000007DB05216,$6574616474584574,
;                $006574616572633A,$2D38302D39313032,$35313A3131543931,$303A30302B37303A,$000000EED7F72530,$7461647458457425,
;                $796669646F6D3A65,$38302D3931303200,$313A31315439312D,$3A30302B35303A35,$00007B7E35C33030,$42AE444E45490000
;         Data.b $60,$82
;         copy_end:
;       EndDataSection
;       
;     EndProcedure
;     
;     Procedure.i EnableDrop(*this, Format.i, Actions.i, PrivateType.i=0)
;       ; Format
;       ; #PB_Drop_Text    : Accept text on this gadget
;       ; #PB_Drop_Image   : Accept images on this gadget
;       ; #PB_Drop_Files   : Accept filenames on this gadget
;       ; #PB_Drop_Private : Accept a "private" Drag & Drop on this gadgetProtected Result.i
;       
;       ; Actions
;       ; #PB_Drag_None    : The Data format will Not be accepted on the gadget
;       ; #PB_Drag_Copy    : The Data can be copied
;       ; #PB_Drag_Move    : The Data can be moved
;       ; #PB_Drag_Link    : The Data can be linked
;       
;       If AddMapElement(*Drop(), Hex(*this))
;         Debug "Enable drop - " + *this
;         *Drop() = AllocateStructure(_S_drop)
;         *Drop()\Format = Format
;         *Drop()\Actions = Actions
;         *Drop()\Type = PrivateType
;         *Drop()\widget = *this
;       EndIf
;       
;     EndProcedure
;     
;     Procedure.i Text(Text.s, Actions.i=#PB_Drag_Copy)
;       Debug "Drag text - " + Text
;       *Drag = AllocateStructure(_S_drop)
;       *Drag\Format = #PB_Drop_Text
;       *Drag\Text = Text
;       *Drag\Actions = Actions
;       Cur(0)
;     EndProcedure
;     
;     Procedure.i Image(Image.i, Actions.i=#PB_Drag_Copy)
;       Debug "Drag image - " + Image
;       *Drag = AllocateStructure(_S_drop)
;       *Drag\Format = #PB_Drop_Image
;       *Drag\ImageID = ImageID(Image)
;       *Drag\Width = ImageWidth(Image)
;       *Drag\Height = ImageHeight(Image)
;       *Drag\Actions = Actions
;       Cur(0)
;     EndProcedure
;     
;     Procedure.i Private(Type.i, Actions.i=#PB_Drag_Copy)
;       Debug "Drag private - " + Type
;       *Drag = AllocateStructure(_S_drop)
;       *Drag\Format = #PB_Drop_Private
;       *Drag\Actions = Actions
;       *Drag\Type = Type
;       Cur(0)
;     EndProcedure
;     
;     Procedure.i DropAction()
;       If _action_(*Drag\widget) 
;         ProcedureReturn *Drop()\Actions 
;       EndIf
;     EndProcedure
;     
;     Procedure.i DropType()
;       If _action_(*Drag\widget) 
;         ProcedureReturn *Drop()\Type 
;       EndIf
;     EndProcedure
;     
;     Procedure.s DropText()
;       Protected result.s
;       
;       If _action_(*Drag\widget)
;         Debug "  Drop text - "+*Drag\Text
;         result = *Drag\Text
;         FreeStructure(*Drag) 
;         *Drag = 0
;         
;         ProcedureReturn result
;       EndIf
;     EndProcedure
;     
;     Procedure.i DropPrivate()
;       Protected result.i
;       
;       If _action_(*Drag\widget)
;         Debug "  Drop type - "+*Drag\Type
;         result = *Drag\Type
;         FreeStructure(*Drag)
;         *Drag = 0
;         
;         ProcedureReturn result
;       EndIf
;     EndProcedure
;     
;     Procedure.i DropImage(Image.i=-1, Depth.i=24)
;       Protected result.i
;       
;       If _action_(*Drag\widget) And *Drag\ImageID
;         Debug "  Drop image - "+*Drag\ImageID
;         
;         If Image =- 1
;           Result = CreateImage(#PB_Any, *Drag\Width, *Drag\Height) : Image = Result
;         Else
;           Result = IsImage(Image)
;         EndIf
;         
;         If Result And StartDrawing(ImageOutput(Image))
;           If Depth = 32
;             DrawAlphaImage(*Drag\ImageID, 0, 0)
;           Else
;             DrawImage(*Drag\ImageID, 0, 0)
;           EndIf
;           StopDrawing()
;         EndIf  
;         
;         FreeStructure(*Drag)
;         *Drag = 0
;         
;         ProcedureReturn Result
;       EndIf
;       
;     EndProcedure
;     
;     Procedure.i EventDrop(*this, eventtype.l)
;       If *this =- 1
;         *this = enterID()
;         Debug "is gadget - "+IsGadget(*this)
;         Debug "is window - "+IsWindow(*this)
;         
;         ;       ;               If IsWindow(*this)
;         ;       ;                 Debug "title - "+GetWindowTitle(*this)
;         ;       ;               EndIf
;         
;         If _action_(*this)
;           *Drag\widget = *this
;           
;           If IsGadget(*this)
;             PostEvent(#PB_Event_GadgetDrop, WindowPB(GetWindowUnderMouse()), *this)
;           ElseIf IsWindow(*this)
;             PostEvent(#PB_Event_WindowDrop, *this, 0)
;           EndIf
;         EndIf
;         
;       Else
;         
;         Select eventtype
;           Case #PB_EventType_MouseEnter
;             If _action_(*this)
;               If Not *Drop()\cursor
;                 *Drag\widget = *this
;                 *Drag\cursor = 0
;                 Cur(1)
;               EndIf
;             ElseIf *Drag
;               If Not *Drag\cursor
;                 *Drop()\cursor = 0
;                 *Drag\widget = 0
;                 Cur(0)
;               EndIf
;             EndIf
;             
;           Case #PB_EventType_MouseLeave
;             If *Drag And Not *Drag\cursor
;               *Drop()\cursor = 0
;               *Drag\widget = 0
;               Cur(0)
;             EndIf
;             
;           Case #PB_EventType_LeftButtonUp
;             
;             If *Drag And MapSize(*Drop())
;               If *Drag\cursor Or *Drop()\cursor
;                 *Drag\cursor = 0
;                 *Drop()\cursor = 0
;                 ;Debug "set default cursor"
;                 SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
;               EndIf
;               
;               ProcedureReturn _action_(*this)
;             EndIf  
;         EndSelect
;         
;       EndIf
;       
;     EndProcedure
   EndModule
CompilerEndIf
;- >>>

;- >>>
DeclareModule Gadget
  EnableExplicit
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
    CompilerElse
      ImportC ""
      CompilerEndIf
      PB_Object_EnumerateStart(*Object)
      PB_Object_EnumerateNext(*Object,*ID.Integer)
      PB_Object_EnumerateAbort(*Object)
      ;       PB_Window_Objects.i
      ;       PB_Gadget_Objects.i
      PB_Image_Objects.i
    EndImport
    
    
    
;     Macro EventDropText()
;       DD::DropText()
;     EndMacro
;     
;     Macro EventDropAction()
;       DD::DropAction()
;     EndMacro
;     
;     Macro EventDropType()
;       DD::DropType()
;     EndMacro
;     
;     Macro EventDropImage(_image_, _depth_=24)
;       DD::DropImage(_image_, _depth_)
;     EndMacro
;     
; ;     Macro DragText(_text_, _actions_=#PB_Drag_Copy)
; ;       DD::Text(_text_, _actions_)
; ;     EndMacro
;     
;     Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
;       DD::Image(_image_, _actions_)
;     EndMacro
;     
;     Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
;       DD::Private(_type_, _actions_)
;     EndMacro
;     
;     Macro EnableGadgetDrop(_this_, _format_, _actions_, _private_type_=0)
;       DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
;     EndMacro
;     
;     Macro EnableWindowDrop(_this_, _format_, _actions_, _private_type_=0)
;       DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
;     EndMacro
    
    ;   
    Macro SetGadgetAttribute(_gadget_, _attribute_, _value_)
      SetGadgetAttribute_(_gadget_, _attribute_, _value_)
    EndMacro
    Macro SetGadgetColor(_gadget_, _color_type_, _color_)
      SetGadgetColor_(_gadget_, _color_type_, _color_)
    EndMacro
    ;   Macro SetGadgetData(_gadget_, _value_)
    ;   EndMacro
    Macro SetGadgetFont(_gadget_, _font_id_)
      SetGadgetFont_(_gadget_, _font_id_)
    EndMacro
    Macro SetGadgetItemAttribute(_gadget_, _item_, _attribute_, _value_, _column_=0)
      SetGadgetItemAttribute_(_gadget_, _item_, _attribute_, _value_, _column_)
    EndMacro
    Macro SetGadgetItemColor(_gadget_, _item_, _color_type_, _color_, _column_=0)
      SetGadgetItemColor_(_gadget_, _item_, _color_type_, _color_, _column_)
    EndMacro
    Macro SetGadgetItemData(_gadget_, _item_, _value_)
      SetGadgetItemData_(_gadget_, _item_, _value_)
    EndMacro
    Macro SetGadgetItemImage(_gadget_, _item_, _image_id_)
      SetGadgetItemImage_(_gadget_, _item_, _image_id_)
    EndMacro
    Macro SetGadgetItemFont(_gadget_, _item_, _font_id_)
      SetGadgetItemFont_(_gadget_, _item_, _font_id_)
    EndMacro
    Macro SetGadgetItemState(_gadget_, _position_, _state_)
      SetGadgetItemState_(_gadget_, _position_, _state_)
    EndMacro
    Macro SetGadgetItemText(_gadget_, _position_, _text_, _column_=0)
      SetGadgetItemText_(_gadget_, _position_, _text_, _column_)
    EndMacro
    Macro SetGadgetState(_gadget_, _state_)
      SetGadgetState_(_gadget_, _state_)
    EndMacro
    Macro SetGadgetText(_gadget_, _text_)
      SetGadgetText_(_gadget_, _text_)
    EndMacro
    
    Macro GetGadgetAttribute(_gadget_, _attribute_)
      GetGadgetAttribute_(_gadget_, _attribute_)
    EndMacro
    Macro GetGadgetColor(_gadget_, _color_type_)
      GetGadgetColor_(_gadget_, _color_type_)
    EndMacro
    ;   Macro GetGadgetData(_gadget_)
    ;   EndMacro
    Macro GetGadgetFont(_gadget_)
      GetGadgetFont_(_gadget_)
    EndMacro
    Macro GetGadgetItemAttribute(_gadget_, _item_, _attribute_, _column_=0)
      GetGadgetItemAttribute_(_gadget_, _item_, _attribute_, _column_)
    EndMacro
    Macro GetGadgetItemColor(_gadget_, _item_, _color_type_, _column_=0)
      GetGadgetItemColor_(_gadget_, _item_, _color_type_, _column_)
    EndMacro
    Macro GetGadgetItemData(_gadget_, _item_)
      GetGadgetItemData_(_gadget_, _item_)
    EndMacro
    Macro GetGadgetItemImage(_gadget_, _item_)
      GetGadgetItemImage_(_gadget_, _item_)
    EndMacro
    Macro GetGadgetItemState(_gadget_, _position_)
      GetGadgetItemState_(_gadget_, _position_)
    EndMacro
    Macro GetGadgetItemText(_gadget_, _position_, _column_=0)
      GetGadgetItemText_(_gadget_, _position_, _column_)
    EndMacro
    Macro GetGadgetState(_gadget_)
      GetGadgetState_(_gadget_)
    EndMacro
    Macro GetGadgetText(_gadget_)
      GetGadgetText_(_gadget_)
    EndMacro
    
    ;   Macro AddGadgetColumn(_gadget_, _position_, Title, Width)
    ;     AddGadgetColumn_(_gadget_, _position_, Title, Width)
    ;   EndMacro
    Macro AddGadgetItem(_gadget_, _position_, _text_, _image_id_=0, Flag=0)
      AddGadgetItem_(_gadget_, _position_, _text_, _image_id_, Flag)
    EndMacro
    
    Macro CountGadgetItems(_gadget_)
      CountGadgetItems_(_gadget_)
    EndMacro
    
    Macro ClearGadgetItems(_gadget_)
      ClearGadgetItems_(_gadget_)
    EndMacro
    
    Macro FreeGadget(_gadget_)
      FreeGadget_(_gadget_)
    EndMacro
    
    Macro RemoveGadgetItem(_gadget_, _position_)
      RemoveGadgetItem_(_gadget_, _position_)
    EndMacro
    
    ;   Macro ResizeGadget(X,Y,Width,Height)
    ;   EndMacro
    
    Macro EventData() : EventData_() : EndMacro
    Macro EventGadget() : EventGadget_() : EndMacro
    Macro EventType() : EventType_() : EndMacro
    Macro GadgetType(_gadget_) : GadgetType_(_gadget_) : EndMacro
    
    
    Macro BindGadgetEvent(_gadget_, _callback_, _eventtype_=#PB_All)
      BindGadgetEvent_(_gadget_, _callback_, _eventtype_)
    EndMacro
    
    ;- GADGETs
    Macro TreeGadget(_gadget_, X,Y,Width,Height, Flags=0)
      widget::Gadget(#PB_GadgetType_Tree, _gadget_, X,Y,Width,Height, "", 0,0,0, Flags)
    EndMacro
    Macro ButtonGadget(_gadget_, X,Y,Width,Height, text, Flags=0)
      widget::Gadget(#PB_GadgetType_Button, _gadget_, X,Y,Width,Height, text, 0,0,0, Flags)
    EndMacro
    Macro TextGadget(_gadget_, X,Y,Width,Height, text, Flags=0)
      widget::Gadget(#PB_GadgetType_Text, _gadget_, X,Y,Width,Height, text, 0,0,0, Flags)
    EndMacro
    Macro CheckBoxGadget(_gadget_, X,Y,Width,Height, text, Flags=0)
      widget::Gadget(#PB_GadgetType_CheckBox, _gadget_, X,Y,Width,Height, text, 0,0,0, Flags)
    EndMacro
    Macro OptionGadget(_gadget_, X,Y,Width,Height, text, Flags=0)
      widget::Gadget(#PB_GadgetType_Option, _gadget_, X,Y,Width,Height, text, 0,0,0, Flags)
    EndMacro
    Macro HyperLinkGadget(_gadget_, X,Y,Width,Height, text, Color, Flags=0)
      widget::Gadget(#PB_GadgetType_HyperLink, _gadget_, X,Y,Width,Height, text, Color,0,0, Flags)
    EndMacro
    Macro SplitterGadget(_gadget_, X,Y,Width,Height, gadget1, gadget2, Flags=0)
      widget::Gadget(#PB_GadgetType_Splitter, _gadget_, X,Y,Width,Height, "", gadget1,gadget2,0, Flags)
    EndMacro
    
    Declare SetGadgetAttribute_(Gadget, Attribute, Value)
    Declare SetGadgetColor_(Gadget, ColorType, Color)
    Declare SetGadgetData_(Gadget, Value)
    Declare SetGadgetFont_(Gadget, FontID)
    Declare SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0)
    Declare SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
    Declare SetGadgetItemData_(Gadget, Item, Value)
    Declare SetGadgetItemImage_(Gadget, Item, ImageID)
    Declare SetGadgetItemState_(Gadget, Position, State)
    Declare SetGadgetItemText_(Gadget, Position, Text$, Column=0)
    Declare SetGadgetState_(Gadget, State)
    Declare SetGadgetText_(Gadget, Text$)
    
    Declare GetGadgetAttribute_(Gadget, Attribute)
    Declare GetGadgetColor_(Gadget, ColorType)
    Declare GetGadgetData_(Gadget)
    Declare GetGadgetFont_(Gadget)
    Declare GetGadgetItemAttribute_(Gadget, Item, Attribute, Column=0)
    Declare GetGadgetItemColor_(Gadget, Item, ColorType, Column=0)
    Declare GetGadgetItemData_(Gadget, Item)
    Declare GetGadgetItemImage_(Gadget, Item)
    Declare GetGadgetItemState_(Gadget, Position)
    Declare.s GetGadgetItemText_(Gadget, Position, Column=0)
    Declare GetGadgetState_(Gadget)
    Declare.s GetGadgetText_(Gadget)
    
    ;   Declare AddGadgetColumn_(Gadget, Position, Title$, Width)
    Declare AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
    
    Declare BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
    ;   Declare ResizeGadget_(X,Y,Width,Height)
    Declare SetGadgetItemFont_(Gadget, Item, FontID)
    Declare CountGadgetItems_(Gadget)
    Declare RemoveGadgetItem_(Gadget, Position)
    Declare ClearGadgetItems_(Gadget)
    Declare GadgetType_(Gadget)
    Declare FreeGadget_(Gadget)
    Declare EventData_()
    Declare EventType_()
    Declare EventGadget_()
  EndDeclareModule
  
  Module Gadget
    Global *this.Structures::_S_widget
    
    Macro PB(Function)
      Function
    EndMacro
    
    Procedure IDImage(Handle.i) ;Returns purebasic image (ID) from handle
      Protected ID.i
      
      PB_Object_EnumerateStart(PB_Image_Objects)
      
      While PB_Object_EnumerateNext(PB_Image_Objects, @ID)
        If Handle = ImageID(ID) 
          PB_Object_EnumerateAbort(PB_Image_Objects)
          ProcedureReturn ID
        EndIf
      Wend
      
      ProcedureReturn - 1
    EndProcedure
    
    
    Procedure EventData_()
      If widget::EventWidget( )\data
        ProcedureReturn widget::EventWidget( )\data
      Else
        ProcedureReturn PB(EventData)()
      EndIf
    EndProcedure
    
    Procedure EventType_()
      If widget::EventWidget( ) And widget::Atpoint(widget::this( )\mouse\x, widget::this( )\mouse\y, widget::EventWidget( )) 
        ;if widget::EventWidget( )\event <>- 1
        ProcedureReturn widget::EventWidget( )\event
      Else
        ProcedureReturn PB(EventType)()
      EndIf
    EndProcedure
    
    Procedure EventGadget_()
      If widget::EventWidget( ) And
         widget::EventWidget( )\root And 
         widget::Atpoint(widget::this( )\mouse\x, widget::this( )\mouse\y, widget::EventWidget( )) 
        
        ProcedureReturn widget::EventWidget( )\root\canvas\gadget
       Else
        ProcedureReturn PB(EventGadget)()
      EndIf
    EndProcedure
    
    Procedure  FreeGadget_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          Protected *data = PB(GetGadgetData)(Gadget)
          If *data
            *this = *data
            ProcedureReturn widget::Free(*this)
          EndIf
        Else
          ProcedureReturn PB(FreeGadget)(Gadget)
        EndIf
      Else
        *this = Gadget
        ProcedureReturn widget::Free(*this)
      EndIf
    EndProcedure
    
    Procedure GadgetType_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          Protected *data = PB(GetGadgetData)(Gadget)
          If *data
            *this = *data
            ProcedureReturn *this\type
          EndIf
        Else
          ProcedureReturn PB(GadgetType)(Gadget)
        EndIf
      Else
        *this = Gadget
        ProcedureReturn *this\type
      EndIf
    EndProcedure
    
    Procedure BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          Protected *data = PB(GetGadgetData)(Gadget)
          If *data
            *this = *data
            ProcedureReturn widget::Bind(*this, *Callback, EventType)
          EndIf
        Else
          ProcedureReturn PB(BindGadgetEvent)(Gadget, *Callback, EventType)
        EndIf
      Else
        ProcedureReturn widget::Bind(Gadget, *Callback, EventType)
      EndIf
    EndProcedure
    
    Procedure CountGadgetItems_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::CountItems(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(CountGadgetItems)(Gadget)
        EndIf
      Else
        ProcedureReturn widget::CountItems(Gadget)
      EndIf
    EndProcedure
    
    Procedure ClearGadgetItems_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::ClearItems(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(ClearGadgetItems)(Gadget)
        EndIf
      Else
        ProcedureReturn widget::ClearItems(Gadget)
      EndIf
    EndProcedure
    
    Procedure RemoveGadgetItem_(Gadget, Position)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::RemoveItem(PB(GetGadgetData)(Gadget), Position)
        Else
          ProcedureReturn PB(RemoveGadgetItem)(Gadget, Position)
        EndIf
      Else
        ProcedureReturn widget::RemoveItem(Gadget, Position)
      EndIf
    EndProcedure
    
    Procedure SetGadgetAttribute_(Gadget, Attribute, Value)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetAttribute(PB(GetGadgetData)(Gadget), Attribute, Value)
        Else
          ProcedureReturn PB(SetGadgetAttribute)(Gadget, Attribute, Value)
        EndIf
      Else
        ProcedureReturn widget::SetAttribute(Gadget, Attribute, Value)
      EndIf
    EndProcedure
    
    Procedure SetGadgetColor_(Gadget, ColorType, Color) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetColor(PB(GetGadgetData)(Gadget), ColorType, Color)
        Else
          ProcedureReturn PB(SetGadgetColor)(Gadget, ColorType, Color)
        EndIf
      Else
        ProcedureReturn widget::SetColor(Gadget, ColorType, Color)
      EndIf
    EndProcedure
    
    Procedure SetGadgetData_(Gadget, Value) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::SetData(PB(GetGadgetData)(Gadget), Value)
        Else
          ProcedureReturn PB(SetGadgetData)(Gadget, Value)
        EndIf
      Else
        ;       ProcedureReturn widget::SetData(Gadget, Value)
      EndIf
    EndProcedure
    
    Procedure SetGadgetFont_(Gadget, FontID)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetFont(PB(GetGadgetData)(Gadget), FontID)
        Else
          ProcedureReturn PB(SetGadgetFont)(Gadget, FontID)
        EndIf
      Else
        ProcedureReturn widget::SetFont(Gadget, FontID)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::SetItemAttribute(PB(GetGadgetData)(Gadget), Item, Attribute, Value, Column)
        Else
          ProcedureReturn PB(SetGadgetItemAttribute)(Gadget, Item, Attribute, Value, Column)
        EndIf
      Else
        ;       ProcedureReturn widget::SetItemAttribute(Gadget, Item, Attribute, Value, Column)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetItemColor(PB(GetGadgetData)(Gadget), Item, ColorType, Color, Column)
        Else
          ProcedureReturn PB(SetGadgetItemColor)(Gadget, Item, ColorType, Color, Column)
        EndIf
      Else
        ProcedureReturn widget::SetItemColor(Gadget, Item, ColorType, Color, Column)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemData_(Gadget, Item, Value) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::SetItemData(PB(GetGadgetData)(Gadget), Item, Value)
        Else
          ProcedureReturn PB(SetGadgetItemData)(Gadget, Item, Value)
        EndIf
      Else
        ;       ProcedureReturn widget::SetItemData(Gadget, Item, Value)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemFont_(Gadget, Item, FontID)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetItemFont(PB(GetGadgetData)(Gadget), Item, FontID)
        Else
          ;         ProcedureReturn PB(SetGadgetItemFont)(Gadget, Item, FontID)
        EndIf
      Else
        ProcedureReturn widget::SetItemFont(Gadget, Item, FontID)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemImage_(Gadget, Item, ImageID)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetItemImage(PB(GetGadgetData)(Gadget), Item, IDImage(ImageID))
        Else
          ProcedureReturn PB(SetGadgetItemImage)(Gadget, Item, ImageID)
        EndIf
      Else
        ProcedureReturn widget::SetItemImage(Gadget, Item, IDImage(ImageID))
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemState_(Gadget, Position, State)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetItemState(PB(GetGadgetData)(Gadget), Position, State)
        Else
          ProcedureReturn PB(SetGadgetItemState)(Gadget, Position, State)
        EndIf
      Else
        ProcedureReturn widget::SetItemState(Gadget, Position, State)
      EndIf
    EndProcedure
    
    Procedure SetGadgetItemText_(Gadget, Position, Text$, Column=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetItemText(PB(GetGadgetData)(Gadget), Position, Text$, Column)
        Else
          ProcedureReturn PB(SetGadgetItemText)(Gadget, Position, Text$, Column)
        EndIf
      Else
        ProcedureReturn widget::SetItemText(Gadget, Position, Text$, Column)
      EndIf
    EndProcedure
    
    Procedure SetGadgetState_(Gadget, State)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetState(PB(GetGadgetData)(Gadget), State)
        Else
          ProcedureReturn PB(SetGadgetState)(Gadget, State)
        EndIf
      Else
        ProcedureReturn widget::SetState(Gadget, State)
      EndIf
    EndProcedure
    
    Procedure SetGadgetText_(Gadget, Text$)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::SetText(PB(GetGadgetData)(Gadget), Text$)
        Else
          ProcedureReturn PB(SetGadgetText)(Gadget, Text$)
        EndIf
      Else
        ProcedureReturn widget::SetText(Gadget, Text$)
      EndIf
    EndProcedure
    
    Procedure GetGadgetAttribute_(Gadget, Attribute)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetAttribute(PB(GetGadgetData)(Gadget), Attribute)
        Else
          ProcedureReturn PB(GetGadgetAttribute)(Gadget, Attribute)
        EndIf
      Else
        ProcedureReturn widget::GetAttribute(Gadget, Attribute)
      EndIf
    EndProcedure
    
    Procedure GetGadgetColor_(Gadget, ColorType) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::GetColor(PB(GetGadgetData)(Gadget), ColorType)
        Else
          ProcedureReturn PB(GetGadgetColor)(Gadget, ColorType)
        EndIf
      Else
        ;       ProcedureReturn widget::GetColor(Gadget, ColorType)
      EndIf
    EndProcedure
    
    Procedure GetGadgetData_(Gadget) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::GetData(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(GetGadgetData)(Gadget)
        EndIf
      Else
        ;       ProcedureReturn widget::GetData(Gadget)
      EndIf
    EndProcedure
    
    Procedure GetGadgetFont_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetFont(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(GetGadgetFont)(Gadget)
        EndIf
      Else
        ProcedureReturn widget::GetFont(Gadget)
      EndIf
    EndProcedure
    
    Procedure GetGadgetItemAttribute_(Gadget, Item, Attribute, Column=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetItemAttribute(PB(GetGadgetData)(Gadget), Item, Attribute, Column)
        Else
          ProcedureReturn PB(GetGadgetItemAttribute)(Gadget, Item, Attribute, Column)
        EndIf
      Else
        ProcedureReturn widget::GetItemAttribute(Gadget, Item, Attribute, Column)
      EndIf
    EndProcedure
    
    Procedure GetGadgetItemColor_(Gadget, Item, ColorType, Column=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetItemColor(PB(GetGadgetData)(Gadget), Item, ColorType, Column)
        Else
          ProcedureReturn PB(GetGadgetItemColor)(Gadget, Item, ColorType, Column)
        EndIf
      Else
        ProcedureReturn widget::GetItemColor(Gadget, Item, ColorType, Column)
      EndIf
    EndProcedure
    
    Procedure GetGadgetItemData_(Gadget, Item) ; no
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ;         ProcedureReturn widget::GetItemData(PB(GetGadgetData)(Gadget), Item)
        Else
          ProcedureReturn PB(GetGadgetItemData)(Gadget, Item)
        EndIf
      Else
        ;       ProcedureReturn widget::GetItemData(Gadget, Item)
      EndIf
    EndProcedure
    
    Procedure GetGadgetItemImage_(Gadget, Item)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetItemImage(PB(GetGadgetData)(Gadget), Item)
        Else
          ; ProcedureReturn PB(GetGadgetItemImage)(Gadget, Item)
        EndIf
      Else
        ProcedureReturn widget::GetItemImage(Gadget, Item)
      EndIf
    EndProcedure
    
    Procedure GetGadgetItemState_(Gadget, Position)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetItemState(PB(GetGadgetData)(Gadget), Position)
        Else
          ProcedureReturn PB(GetGadgetItemState)(Gadget, Position)
        EndIf
      Else
        ProcedureReturn widget::GetItemState(Gadget, Position)
      EndIf
    EndProcedure
    
    Procedure.s GetGadgetItemText_(Gadget, Position, Column=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetItemText(PB(GetGadgetData)(Gadget), Position, Column)
        Else
          ProcedureReturn PB(GetGadgetItemText)(Gadget, Position, Column)
        EndIf
      Else
        ProcedureReturn widget::GetItemText(Gadget, Position, Column)
      EndIf
    EndProcedure
    
    Procedure GetGadgetState_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetState(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(GetGadgetState)(Gadget)
        EndIf
      Else
        ProcedureReturn widget::GetState(Gadget)
      EndIf
    EndProcedure
    
    Procedure.s GetGadgetText_(Gadget)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::GetText(PB(GetGadgetData)(Gadget))
        Else
          ProcedureReturn PB(GetGadgetText)(Gadget)
        EndIf
      Else
        ProcedureReturn widget::GetText(Gadget)
      EndIf
    EndProcedure
    
    Procedure AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
      If PB(IsGadget)(Gadget)
        If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
          ProcedureReturn widget::AddItem(PB(GetGadgetData)(Gadget), Position, Text$, IDImage(ImageID), Flag)
        Else
          ProcedureReturn PB(AddGadgetItem)(Gadget, Position, Text$, ImageID, Flag)
        EndIf
      Else
        ProcedureReturn widget::AddItem(Gadget, Position, Text$, IDImage(ImageID), Flag)
      EndIf
    EndProcedure
    
    ;   Procedure AddGadgetColumn_(Gadget, Position, Title$, Width)
    ;   ;  ProcedureReturn widget::AddColumn(PB(GetGadgetData)(Gadget), Position, Title$, Width)
    ;   EndProcedure
    
    ;   Procedure ResizeGadget_(X,Y,Width,Height)
    ;   ;  ProcedureReturn widget::Resize(PB(GetGadgetData)(Gadget),X,Y,Width,Height)
    ;   EndProcedure
    
  EndModule
  
  
  CompilerIf #PB_Compiler_IsMainFile
    UseModule Gadget
    ;UseModule DD
    
;     Macro PB(Function)
;       Function
;     EndMacro
    
    UsePNGImageDecoder()
    
    If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") 
      End
    EndIf
    
    Procedure events_tree_gadget()
      ;Debug " gadget - "+EventGadget()+" "+EventType()
      Static click
      Protected EventGadget = EventGadget()
      Protected EventType = EventType()
      Protected EventData = EventData()
      Protected EventItem = GetGadgetState(EventGadget)
      Protected State = GetGadgetItemState(EventGadget, EventItem)
        Debug  EventType
          
      Select EventType
          ;     Case #PB_EventType_Focus    : Debug "gadget focus item = " + EventItem +" data "+ EventData
          ;     Case #PB_EventType_LostFocus    : Debug "gadget lfocus item = " + EventItem +" data "+ EventData
        Case #PB_EventType_LeftClick : Debug "gadget " +EventGadget+ " lclick item = " + EventItem +" data "+ EventData +" State "+ State
          If EventGadget = 3
            click ! 1
            If click
              SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
              SetGadgetItemState(2, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
            Else
              SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
              SetGadgetItemState(2, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
            EndIf
          EndIf
          
          If EventGadget = 4
            AddGadgetItem(1, 1, "added item "+Str(CountGadgetItems(1)))
            AddGadgetItem(2, 1, "added item "+Str(CountGadgetItems(2)))
;             widget()\change = 1
;             Debug widget()\change
;             Repaints()
          EndIf
          If EventGadget = 5
            RemoveGadgetItem(1, 1)
            RemoveGadgetItem(2, 1)
          EndIf
          If EventGadget = 6
            SetGadgetItemImage(1, GetGadgetState(1), ImageID(0))
            SetGadgetItemImage(2, GetGadgetState(2), ImageID(0))
          EndIf
          If EventGadget = 7 ; <<
                             ;         FreeGadget(0)
                             ;         FreeGadget(1)
            
            SetGadgetState(1, 0)
            SetGadgetState(2, 0)
          EndIf
          If EventGadget = 8 ; 0
            SetGadgetState(1, -1)
            SetGadgetState(2, -1)
          EndIf
          If EventGadget = 9 ; >>
            SetGadgetState(1, CountGadgetItems(1)-1)
            SetGadgetState(2, CountGadgetItems(2)-1)
          EndIf
          If EventGadget = 10
            ClearGadgetItems(1)
            ClearGadgetItems(2)
          EndIf
          
          ; widget::Redraw(GetGadgetData(1))
          
        Case #PB_EventType_LeftDoubleClick : Debug "gadget " +EventGadget+ " ldclick item = " + EventItem +" data "+ EventData +" State "+ State
        Case #PB_EventType_Change    : Debug "gadget " +EventGadget+ " change item = " + EventItem +" data "+ EventData +" State "+ State
        Case #PB_EventType_RightClick : Debug "gadget " +EventGadget+ " rclick item = " + EventItem +" data "+ EventData +" State "+ State
        Case #PB_EventType_RightDoubleClick : Debug "gadget " +EventGadget+ " rdclick item = " + EventItem +" data "+ EventData +" State "+ State
          
        Case #PB_EventType_DragStart : Debug "gadget " +EventGadget+ " sdrag item = " + EventItem +" Data "+ EventData +" State "+ State
          Text$ = GetGadgetItemText(EventGadget, GetGadgetState(EventGadget))
          DragText(Text$)
          
        Case #PB_EventType_Drop
          AddGadgetItem(EventGadget, -1, EventDropText())
          
          
      EndSelect 
      
      If EventType = #PB_EventType_LeftClick
        If State & #PB_Tree_Selected
          Debug "Selected "+#PB_Tree_Selected
        EndIf
        If State & #PB_Tree_Expanded
          Debug "Expanded "+#PB_Tree_Expanded
        EndIf
        If State & #PB_Tree_Collapsed
          Debug "Collapsed "+#PB_Tree_Collapsed
        EndIf
        If State & #PB_Tree_Checked
          Debug "Checked "+#PB_Tree_Checked
        EndIf
        If State & #PB_Tree_Inbetween
          Debug "Inbetween "+#PB_Tree_Inbetween
        EndIf
      EndIf
      
      Repaints()
    EndProcedure  
    
    If OpenWindow(0, 0, 0, 355, 240, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;ListViewGadget(0, 10, 10, 160, 160) 
      PB(TreeGadget)(1, 10, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_AlwaysShowSelection)                                         ; TreeGadget standard
      TreeGadget(2, 180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_AlwaysShowSelection | #PB_Tree_Collapse); | #__Tree_GridLines)   ; TreeGadget with Checkboxes + NoLines
      PB(SplitterGadget)(100, 10, 10, 335, 160, 1, 2, #PB_Splitter_Vertical)
      ;SplitterGadget(100, 10, 10, 335, 160, 1, 2, #PB_Splitter_Vertical)
      
      For ID = 1 To 2
        For a = 0 To 10
          AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
          AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
          AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)           ; These are on the 1st sublevel
          AddGadgetItem(ID, -1, "Sub-Item 1_2", 0, 2)         ; These are on the 1st sublevel
          AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
          AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
          AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
          AddGadgetItem (ID, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
        Next
        
        Debug " gadget "+ ID +" count items "+ CountGadgetItems(ID) +" "+ GadgetType(ID)
        EnableGadgetDrop(ID, #PB_Drop_Text, #PB_Drag_Copy)
      Next
      
      PB(ButtonGadget)(3, 10, 180, 100, 24, "set state Item")
      BindGadgetEvent(3, @events_tree_gadget())
      PB(ButtonGadget)(4, 120, 180, 100, 24, "add Item")
      BindGadgetEvent(4, @events_tree_gadget())
      PB(ButtonGadget)(5, 230, 180, 100, 24, "remove Item")
      BindGadgetEvent(5, @events_tree_gadget())
      
      PB(ButtonGadget)(6, 10, 210, 100, 24, "set image Item")
      BindGadgetEvent(6, @events_tree_gadget())
      PB(ButtonGadget)(7, 120, 210, 35, 24, "<")
      BindGadgetEvent(7, @events_tree_gadget())
      PB(ButtonGadget)(8, 155, 210, 30, 24, "0")
      BindGadgetEvent(8, @events_tree_gadget())
      PB(ButtonGadget)(9, 185, 210, 35, 24, ">")
      BindGadgetEvent(9, @events_tree_gadget())
      PB(ButtonGadget)(10, 230, 210, 100, 24, "clears Items")
      BindGadgetEvent(10, @events_tree_gadget())
      
       BindGadgetEvent(1, @events_tree_gadget())
;       BindGadgetEvent(2, @events_tree_gadget())
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = n------PVd4tttttttttttttt0----
; EnableXP