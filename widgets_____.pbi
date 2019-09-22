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

DeclareModule DD
  ;- - Drop_S
  Structure Drop_S
    Text.s
    ImageID.i
    ImageWidth.i
    ImageHeight.i
    Actions.i
    Format.i
    PrivateType.i
    Map *Drop.Drop_S()
  EndStructure
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Drop
  EndEnumeration
  
  Global Object.i, Event.i
  Global *Buffer.Drop_S
  
  Macro DropBuffer()
    *Buffer
  EndMacro
  
  Declare.s DropText(Object.i)
  Declare.i DropImage(Object.i, Image.i=-1, Depth.i=24)
  Declare.i DropAction(Object.i)
  
  Declare.i Text(Object.i, Text.S, Actions.i=#PB_Drag_Copy)
  Declare.i Image(Object.i, Image.i, Actions.i=#PB_Drag_Copy)
  Declare.i Private(Object.i, Type.i, Actions.i=#PB_Drag_Copy)
  
  Declare.i EnableDrop(Object.i, Format.i, Actions.i, PrivateType.i=0)
  Declare.i CallBack(*Object, EventType.i, Mouse_X.i, Mouse_Y.i)
EndDeclareModule

Module DD
  Procedure.i SetCursor(Canvas, Cursor.i, CursorType.i=#PB_Canvas_Cursor)
    Protected Result.i
    
    With *this
      If Canvas
        If CursorType = #PB_Canvas_CustomCursor
          If Cursor
            Protected.i x=3, y=3, ImageID = Cursor
            
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
        
        
        SetGadgetAttribute(Canvas, CursorType, Cursor)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i EnableDrop(Object.i, Format.i, Actions.i, PrivateType.i=0)
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
    
    If Not DropBuffer() 
      DropBuffer() = AllocateStructure(Drop_S) 
    EndIf
    
    With *Buffer
      If AddMapElement(\Drop(), Hex(Object))
        \Drop() = AllocateStructure(Drop_S)
        
        Debug "Enable drop - " + Object
        \Drop()\Format = Format
        \Drop()\Actions = Actions
        \Drop()\PrivateType = PrivateType
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Text(Object.i, Text.s, Actions.i=#PB_Drag_Copy)
    If Not DropBuffer()
      DropBuffer() = AllocateStructure(Drop_S)
    EndIf
    
    Debug "Drag text - " + Text
    DropBuffer()\Format = #PB_Drop_Text
    DropBuffer()\Text = Text
    DropBuffer()\Actions = Actions
  EndProcedure
  
  Procedure.i Image(Object.i, Image.i, Actions.i=#PB_Drag_Copy)
    If Not DropBuffer()
      DropBuffer() = AllocateStructure(Drop_S)
    EndIf
    
    Debug "Drag image - " + Image
    DropBuffer()\Format = #PB_Drop_Image
    DropBuffer()\ImageID = ImageID(Image)
    DropBuffer()\ImageWidth = ImageWidth(Image)
    DropBuffer()\ImageHeight = ImageHeight(Image)
    DropBuffer()\Actions = Actions
  EndProcedure
  
  Procedure.i Private(Object.i, Type.i, Actions.i=#PB_Drag_Copy)
    If Not DropBuffer()
      DropBuffer() = AllocateStructure(Drop_S)
    EndIf
    
    Debug "Drag private - " + Type
    DropBuffer()\Format = #PB_Drop_Private
    DropBuffer()\PrivateType = Type
    DropBuffer()\ImageID = ImageID(Image)
    DropBuffer()\ImageWidth = ImageWidth(Image)
    DropBuffer()\ImageHeight = ImageHeight(Image)
    DropBuffer()\Actions = Actions
  EndProcedure
  
  Procedure.i DropAction(Object.i)
    If Not Object And DropBuffer() : DropBuffer() = 0 : EndIf
    
    If DropBuffer() And DropBuffer()\Drop() And FindMapElement(DropBuffer()\Drop(), Hex(Object))
      ProcedureReturn Bool(DropBuffer()\Drop()\Format = DropBuffer()\Format And (DropBuffer()\Drop()\PrivateType = DropBuffer()\PrivateType)) * DropBuffer()\Drop()\Actions  
    EndIf
  EndProcedure
  
  Procedure.s DropText(Object.i)
    If DropAction(Object)
      Debug "Drop text - "+DropBuffer()\Text
      ProcedureReturn DropBuffer()\Text
    EndIf
  EndProcedure
  
  Procedure.i DropPrivate(Object.i)
    If DropAction(Object)
      Debug "Drop type - "+DropBuffer()\PrivateType
      ProcedureReturn DropBuffer()\PrivateType
    EndIf
  EndProcedure
  
  Procedure.i DropImage(Object.i, Image.i=-1, Depth.i=24)
    Protected Result.i
    
    If DropAction(Object) And DropBuffer()\ImageID
      Debug "Drop image - "+DropBuffer()\ImageID
      
      If Image =- 1
        Result = CreateImage(#PB_Any, DropBuffer()\ImageWidth, DropBuffer()\ImageHeight) : Image = Result
      Else
        Result = IsImage(Image)
      EndIf
      
      If Result And StartDrawing(ImageOutput(Image))
        If Depth = 32
          DrawAlphaImage(DropBuffer()\ImageID, 0, 0)
        Else
          DrawImage(DropBuffer()\ImageID, 0, 0)
        EndIf
        StopDrawing()
      EndIf  
      
      ProcedureReturn Result
    EndIf
    
  EndProcedure
  
  Procedure Cursor(Type.i=#PB_Cursor_Default)
    Protected cursor
    #PB_Cursor_Help = 50
    #PB_Cursor_Alternate = 51
    #PB_Cursor_Handwriting = 52
    
    UsePNGImageDecoder()
    UseZipPacker()
    
    Select Type
      Case #PB_Cursor_Handwriting
        *unpacked = AllocateMemory(670)
        UncompressMemory(?cursor_handwriting, 547, *unpacked, 670)
        cursor = CatchImage(#PB_Any, *unpacked, 670)
        
      Case #PB_Cursor_Alternate
        *unpacked = AllocateMemory(643)
        UncompressMemory(?cursor_alternate, 466, *unpacked, 643)
        cursor = CatchImage(#PB_Any, *unpacked, 643)
        
      Case #PB_Cursor_Default
        *unpacked = AllocateMemory(737)
        UncompressMemory(?cursor_normal, 594, *unpacked, 737)
        cursor = CatchImage(#PB_Any, *unpacked, 737)
        
      Case #PB_Cursor_Denied
        ; ; ;         *unpacked = AllocateMemory(1076)
        ; ; ;         UncompressMemory(?cursor_denied, 992, *unpacked, 1076)
        ; ; ;         cursor = CatchImage(#PB_Any, *unpacked, 1076)
        *unpacked = AllocateMemory(839)
        UncompressMemory(?cursor_denied, 830, *unpacked, 839)
        cursor = CatchImage(#PB_Any, *unpacked, 839)
        
      Case #PB_Cursor_Hand
        *unpacked = AllocateMemory(1063)
        UncompressMemory(?cursor_hand, 929, *unpacked, 1063)
        cursor = CatchImage(#PB_Any, *unpacked, 1063)
        
      Case #PB_Cursor_Arrows
        ; ; ;         *unpacked = AllocateMemory(714)
        ; ; ;         UncompressMemory(?cursor_move, 698, *unpacked, 714)
        ; ; ;         cursor = CatchImage(#PB_Any, *unpacked, 714)
        
        *unpacked = AllocateMemory(784)
        UncompressMemory(?cursor_move, 774, *unpacked, 784)
        cursor = CatchImage(#PB_Any, *unpacked, 784)
        
      Case #PB_Cursor_IBeam
        *unpacked = AllocateMemory(508)
        UncompressMemory(?cursor_ibeam, 368, *unpacked, 508)
        cursor = CatchImage(#PB_Any, *unpacked, 508)
        
      Case #PB_Cursor_LeftDownRightUp
        *unpacked = AllocateMemory(532)
        UncompressMemory(?cursor_diagonal_1, 434, *unpacked, 532)
        cursor = CatchImage(#PB_Any, *unpacked, 532)
        
      Case #PB_Cursor_LeftUpRightDown
        *unpacked = AllocateMemory(519)
        UncompressMemory(?cursor_diagonal_2, 429, *unpacked, 519)
        cursor = CatchImage(#PB_Any, *unpacked, 519)
        
      Case #PB_Cursor_LeftRight
        *unpacked = AllocateMemory(474)
        UncompressMemory(?cursor_horizontal, 382, *unpacked, 474)
        cursor = CatchImage(#PB_Any, *unpacked, 474)
        
      Case #PB_Cursor_UpDown
        *unpacked = AllocateMemory(428)
        UncompressMemory(?cursor_vertical, 396, *unpacked, 428)
        cursor = CatchImage(#PB_Any, *unpacked, 428)
        
      Case #PB_Cursor_Help
        *unpacked = AllocateMemory(725)
        UncompressMemory(?cursor_help, 605, *unpacked, 725)
        cursor = CatchImage(#PB_Any, *unpacked, 725)
        
      Case #PB_Cursor_Cross
        *unpacked = AllocateMemory(472)
        UncompressMemory(?cursor_cross, 393, *unpacked, 472)
        cursor = CatchImage(#PB_Any, *unpacked, 472)
        
    EndSelect
    
    
    ; If img0 ;createImage(110, 20, 20, 32,#PB_Image_Transparent)
    ; 
    ;     StartDrawing(ImageOutput(110))
    ;     
    ;     DrawingMode(#PB_2DDrawing_AllChannels) 
    ;     box(0,0,OutputWidth(),OutputHeight(), $FF000000)
    ;     
    ;     StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    ;     
    ;     EndIf
    ;     ProcedureReturn ImageID(110)
    ProcedureReturn ImageID(cursor)
    
    DataSection
      cursor_hand:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$CC2C4042D2020970,$003DACF957240CC1,$18191D7D1DD258A4,$F2056449FF73F636,
             $9DD6189DDC838B19,$047B2428E4097993,$343031A9543032F9,$BC350A02FC3030B4,$9578606035286060,$BC4181833560C0C0,
             $B6BEA01B40AECE60,$9190300657109F00,$8090909717171191,$20949495D5D5D570,$89A6D369FD7D7D6C,$95400540D9008888,
             $CDCDCB2B2B20300C,$0E2020202DADADAD,$1B0B0AE760424206,$8165013131301818,$62525252D2D2D282,$2C2C305036406262,
             $6214D4D4CE4E4E4C,$CECED959595C5008,$876A05151515C20E,$78308050525E4173,$81EA800202037979,$3610FDFDFD51A06C,
             $203235024A4A4810,$0E0E2DA056565601,$36361110CCCCCC0E,$1D1D1D114045A036,$A05C810505042FB8,$81B0180A81DA80BF,
             $D6FFFFFFFE7F3F9F,$F7FBFFDFEFF75BAD,$FD3E9F4EF379BCEF,$64676FB7DBE7F3F9,$FCDCDCC673399C64,$7ABD7EBF5FD7EBF5,
             $3B9DCEBF5FAFEAF5,$7FBFDFEFC5E2F177,$6666F7FBFDE9F4FA,$EAEAFF4026262666,$63F1F8FDE9E9EAEA,$7CBA3D1E8F1D8EC7,
             $FC7E3E773B9DF2F9,$F5B627D3BFDFEFF8,$660BF2092C4A6D01,$C3EA499AA6F35E60,$3F04BAFF77C65527,$C3E3F9BFE597905C,
             $FEFD66783C2FE7FA,$9B0FB7C29ED5F1F7,$D3E5FEC2A77DFF3F,$72183F7F07DE7D7B,$8EF6FE6F15667F7B,$5E9F4E7CE5DFEAE3,
             $1CF97F2688B272EB,$0FD7EBE5F7192425,$53F85B6F3FAFD26C,$A7C040CECD53C4D8,$76F249BA500DCEE1,$0B4C0B29DED24977,
             $FA40C5911E059C0C,$2416BE7AFF271804,$30018A0E98E05658,$AF17502E6735FF6E,$04E4E5C488638BA7,$60754C4B4A494820,
             $84E6273329D379CC,$7A7B369E3B9CCC52,$6A649E78FE6A9C34,$C82835C5AAF13A72,$09A5955511C8F2D5,$297A6E7A65192E87,
             $072EAE27E6727459,$4EAE434253A988E6,$5749A4D17269B4DA,$F1996C4A764D4D8A,$140B0A49D2D6D3F9,$302FEF1DBBFBC33C,
             $4AC5A57340C27958,$4C662793CD654D15,$734D131ACAE4783D,$692A566D2B3A95CD,$D0E7783D4C77BA7A,$7172568DCB25AE25,
             $9C8EC48773FB5EAC,$8C84D0A706EC9C96,$179BAB4C250CF7F4,$B35C0B48050AE707,$EF67D3CE69A3BDDC,$795931EC9BF2461E,
             $BA7A8637F66DF4F0,$70D6392C97FFF6F1,$B9EA1584B6C288E0,$FF290E873DBD4E4E,$7F52E8F7609C5E51,$E9EE9ED3CF61675F,
             $396BABEF7C77D56D,$10D9A32FBC7152DE,$999B298F81B3B911,$FE4282A17DADF3A1,$9446B896A9086002,$A517255AA49624A4,
             $5D4B430323062902,$530310B3035D6303,$036D63532B03432B,$0CAE9AC683032B03,$95699929F9B90D14,$5985843441183458,
             $CB9FABA7A2528026,$610EF6002684A73A
      Data.b $72
      end_cursor_hand:
      
      cursor_denied:
      ; ; ;   Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC200AD2020970,$52031D74965D240C,$1B0C0C8EBE8EE92C,$932482B224FFB9FB,
      ; ; ;          $18D4AA18197C823D,$85017E18185A1A18,$30301A9430305E1A,$C0C19AB060604ABC,$030DA05767305E20,$032B884F80796303,
      ; ; ;          $BDDEEF72E2E2E021,$C3FEFF7FBD5EAF57,$8FC7E3E0C0EF0F87,$8F47A3D9405A5A5A,$65656D7EBF5EA442,$00A816FB7DBEE405,
      ; ; ;          $CDFCBE5F2ECA05C8,$085E2F179140379B,$18A818FC7E3D0909,$9ECF67BADD6EB522,$F4FA7C5E2F171901,$04411E8F47AEC429,
      ; ; ;          $A003C1E0FBBDDEEF,$EA753A9ADD6EB769,$5F2E383838E773B9,$7B7B7B4DE6F37CBE,$EDD4A022A2A282A0,$F6E402D96CB7B7DB,
      ; ; ;          $B75B2280A501F5F5,$1A07AA0028282D6E,$BDFEFEFECCE6733B,$C1E0E974BA5EF77B,$FC1414102C160B83,$2B2B2B3D503FFFFF,
      ; ; ;          $272738B8B89F1F1F,$AF103BD00888A887,$2F97CBDE740A9D01,$A074FA7D37DBEDF7,$4C5A6D369F2E8033,$E78AD03E7E7E4C4C,
      ; ; ;          $8BCBCBCD2D039FCF,$6BB5DAFB3A068E8E,$7AB93C9E4FB9B9B9,$D7FDD01454546AF5,$8C8C89C9C9CF5FAF,$D9D989C4E27FBA04,
      ; ; ;          $DB7F7FBFDC9740D9,$E572B84C26136DB6,$DC73B9DCEF30300A,$4125011DD013EAAB,$02323C1C2C0CC17E,$AB11EC8C2212063A,
      ; ; ;          $6AC124C41E5F3C5E,$EF8FDC548992ED77,$DE489BBE3F1E9CFE,$7DB5241397C4C4BC,$5E6FFAE79BCA9739,$1AE7766119555EEC,
      ; ; ;          $15E2761FCFD246BB,$51E9B9DD25C47F3F,$AC9BC91CF6CDFBB9,$BB79263366801BA9,$E403D9F3CE3C04BB,$663FB2BAFA7897B0,
      ; ; ;          $1065AAE666936366,$588638BA79C74A02,$41C87C1E989D6E9C,$37D7C6D161D14DA0,$368F5D935CDD7BAB,$C411A11397105DED,
      ; ; ;          $BDE3D7F2F8C4D2A2,$E4EDE73CFD0F6D2C,$74EEF9736EC67F7F,$304B6C164B891783,$79781CE4EC3DCE72,$6C87909315C04183,
      ; ; ;          $623C115EE91E38AF,$80BB807BE3B942BD,$52C726A10C6982FC,$D223594D82CCDA24,$4FC889656CF4671D,$B4DD762B3D9A9691,
      ; ; ;          $7465DD87D5BEDB6B,$939C9DF33C9EBF48,$87FFD7ABC66ACCC1,$483738F788082624,$C179E92A4BAE55C9,$06F96D40CE3D4C78,
      ; ; ;          $9FD6E505BBBED3AB,$41DE6BD6D2ADFB7F,$482BD473D79B0FE9,$3C4F9EA9D732B170,$8B9F60AF21F4A7B4,$65383A7BA9968BF2,
      ; ; ;          $335028BC9A13AEFE,$3BA9FE16A50FD4EC,$596B520C7C7878A6,$C4E2F547C732DFEA,$F56A7E36627C7BA9,$D86A6D4733746E58,
      ; ; ;          $C528CAB6278FAD27,$F27714EA3A2B3C6B,$CE7BF37ADB1991F5,$BE773B7B7E0526EA,$897CABA488F7D956,$A810E07E1E6215FF,
      ; ; ;          $AB4846A0A7B4183F,$E270E457904DCAB8,$2B2B37A916F1B9F6,$31F039E3EF6EFF4B,$A2E33CFB43204A2C,$991C669AFBE2DC7F,
      ; ; ;          $5C4B55F0301CEFB0,$92AD524B12524A23,$A18191831481528B,$885981AEB181AEA5,$B18195B991959981,$C67F0181958181B6,
      ; ; ;          $3253F3721A285DD4,$65D533A86B712AD3,$75973F574F1CE503,$5DE4C2D3004D094E
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC200AD2020970,$5207AA6F166F2402,$1B0C0C8EBE8EE92C,$932482B224FFB9FB,
             $18D4AA18197C823D,$85017E18185A1A18,$30301A9430305E1A,$C0C19AB060604ABC,$500DA05767305E20,$7FE185DDDBC92982,
             $897B1E40FD99FF7B,$36366663FB2BAFA7,$79401388A55AE135,$6FE38F10C7174F7F,$CDB44A04847AF8A7,$1A0233F9F5F1783F,
             $D24E961252D45C2B,$92D225CCA2E895FB,$D8B2EEF33ACD3821,$1FB23E57B5C770E8,$60E95C76E47165CA,$7A24C9557828A594,
             $F361F92527E4C646,$4BCC5F7D53BB9E5E,$E7F11ADD58D5C9E5,$AE7E5F79AF7ECE73,$A729E1FDE5C6EEDC,$F766C95956EDCE77,
             $AFCDBBE2CFBB0E71,$39E7BB3EFC37F324,$CD79CDAF7387DE5B,$97BA1414F7C95F1E,$7DE0AFD7F2712B56,$3EF3EF33C5BC52EF,
             $A598E4EA60D5B15A,$325CCD1FD33A973E,$C6ECCB7512DD68D9,$5359934AAE456B64,$57EBA53AEF9A7897,$7E8B673516A715DC,
             $7DBF8EE24FA54A6F,$6E70971AE383B76E,$626CF8253DE999CF,$97179583DE75B99E,$995190F29E719F29,$9FE34F4AFCBDE677,
             $1D4534B805D7449F,$65DB50904931EF6B,$2529BCF3FC25A0BB,$09CD2E5967898515,$CFC628502A50FC9F,$D8DB5ED9E39ED2EA,
             $96FCE6B49EEE788F,$CCDE67323757EDA2,$7A8F5D8CF172F0DF,$29C8CB7C7C99749E,$65C2DDCB4D79EB16,$A519D6AA6FB8C1D5,
             $5963AC4DE6CD0B12,$82ED379718C2D9E2,$6CCF29AB97F3536B,$5D5B78DB66C4B24E,$46CF4381B67C735A,$3C6A37DF3CA5E546,
             $9053ED3C3A7EB866,$3D26526E41FBDEDF,$3DBF27CA9C0353AD,$94E9604F364B3BC9,$CA985C7FBFBA31BF,$DFACCB93CAC9F4F4,
             $F5359DB4310E2D08,$8E0173DB61F75D52,$529EB1EAE1DCE6B2,$75BB186F437C8D67,$B1D4F193BA8BDE14,$F1C9CCD26A6750F8,
             $32C273DDAF67AF41,$D9724DA59959E1E9,$3AD394ECCFCFD72F,$93258AC362BF29F4,$28BDF3D85F55BA57,$6314E5E3AF6D3F8A,
             $67953F8911A9F557,$B22C78BB7E160B67,$47CCFE56BCEFB82F,$B8D672F4FD3FF19A,$3CD376091567BDD4,$F75A56D7A720C22A,
             $0DB5E55AE97FDDA8,$F1FFE6181A5C8B4E,$9CF70BFE2BFD583B,$0791ED5A36ABE1EF,$949288D712D536A6,$2054A2E4AB5492C4,
             $606BA968606460C5,$6566606216606BAC,$60606DA96865616C,$A28EA7EE6E106065,$B712AD33253F3721,$181A81B36FACB506,
             $342539D65CFD5D3C
      Data.b $01,$00,$0B,$B6,$5D,$99
      end_cursor_denied:
      
      cursor_handwriting:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C22C403CD2020970,$819474F4FB240CC1,$C30323AFA3BA4B14,$3E40AC893FEE7EC6,
             $73BAC313BB907163,$208F64851C812F32,$868606352A86065F,$1786A1405F860616,$12AF0C0C06A50C0C,$1788303066AC1818,
             $145894036815D9CC,$F87C3FA40AE213E0,$F3F830062DD6EB70,$D7EBF5F82A030FE7,$FF7FBE459193C9E4,$A9A9B73854EA753E,
             $7764082815B5B5A9,$78C818FC7E3C7474,$519A0D4D4D6DF6FB,$FFFE0DC0643E1F0F,$EEF99CCE67240FFF,$FBFDFE9F4FA7BBDD,
             $7ABD5EAFD7EBF5F7,$24AF42501374B378,$38D05CAD21982FC8,$EAEE628477F64037,$AAA135DCA11B0CC0,$33A6B3FD3CD66BC2,
             $BD4C9302E0AAE6FD,$2A3A22BCDA3E5E1B,$00A0B1AE0E56DC9C,$2CB90BD17776F24A,$15B9BBE670E40ED0,$7C9833B310506903,
             $824478160907CE60,$6BE7AFF271804F04,$20A0E98E05658241,$1902E6735FF6E305,$7D9712218E2E9E6D,$7D61E0326B173FCF,
             $41E0A05989A34AB0,$BFFDEEBBC99D2AC2,$F3F9BC5EF478619A,$49331B5E253D2FD7,$79905C1C0AB04BF8,$D4E68CFB3181A8EA,
             $98CBE1FA0D8AB5EF,$3A1FF99786C9D66A,$F566BC3571C25FC6,$020C7183D976EF41,$D54F328272ECE11D,$CF6216FD1F8C9BD4,
             $FCEF2FE57358F5D2,$F93141B18AE7B17C,$DD3DF55E86E683DF,$C126E4B32B6FF366,$A917403115FD0D5C,$A49624A49446B896,
             $23062902A517255A,$035D63035D4B4303,$2B03432B530310B3,$83032B03036D2313,$E6E434509D1B0BD7,$EB30D6E255A664A7,
             $FABA78CC503FE58F,$C20002684A73ACB9
      Data.b $C5,$D0,$E0
      end_cursor_handwriting:
      
      cursor_alternate:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$CC2C40FCD2020970,$00CF96642B240CC1,$0C0C8EBE8EE92C52,$F902B224FFB9FB1B,
             $CEEB0C4EEE41C58C,$823D92147204BCC9,$1A1818D4AA18197C,$5E1A85017E18185A,$4ABC30301A943030,$305E201A02B06060,
             $C025A2500DA05767,$FFFFC1406195C427,$90230B3F0F2481FF,$6460660BF2092AD2,$936213E6E1E56166,$C94F0AF262E594E4,
             $4994CE332B57E0E7,$14161117168C5252,$F8928D8E098B1015,$926317503364FFE8,$F32BBEF0568BBBB7,$A862B7377CCE1C80,
             $41FBDB0D870C8CD9,$6013C120911E0582,$5960905AF9EBFC9C,$F6E30056903A6381,$2E9EBD1902E6735F,$66DC2F7D9712218E,
             $4139980861E0526A,$B7CD9166EEF44BB1,$FAA593BABFFFFC7F,$27064ED3D30DE556,$366DBA3BC4542304,$32B894BCCF7BB439,
             $371B0729ABCD6AC8,$A6C14E6737D2FFFF,$9B9AD7223B898F30,$F7D4FACD39BB6CD4,$B8167F44C51DAF17,$7F1B661199B45CD8,
             $B789BDFC465EFB4B,$E3E26EFB9D9DF1EF,$BF9D34820D93FFF5,$E334CF6BD9AEFD17,$0FAB655B8C7FACDA,$ACEC567327DECDFE,
             $2D530E8177938AF6,$B5492C4949288D71,$06460C52054A2E4A,$6606BAC606BA9686,$0656160656A60621,$7B0606560606DA46,
             $4FCDC868A0F40937,$FBCCE1ADC4AB4CC9,$73F574F2E0A00615,$9A900004D094E759
      Data.b $A4,$C1
      end_cursor_alternate:
      
      cursor_normal:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C62C4002D2020970,$03F1BC95FF240CC1,$0C0C8EBE8EE92C52,$F902B224FFB9FB1B,
             $CEEB0C4EEE41C58C,$823D92147204BCC9,$1A1818D4AA18197C,$5E1A85017E18185A,$4ABC30301A943030,$5E20C0C19AB06060,
             $7B62500DA0576730,$E4F036032B884F80,$101389C4FB3813C9,$E7738C21FFFFFFC6,$3D9F5FAFD71841CE,$6EF5919BCDE6F67B,
             $EE7099CCE671B8DC,$E70ABD5EAEF379BC,$EBF5E5A808743A1E,$0F87C38205ED58D7,$0DD02C9712793C9F,$EFFCD08640666666,
             $982FC824AACA4031,$9E3B898595999181,$BA9FF94B84325D93,$A3AB0795E0873046,$0A89B7DED785F43D,$DEF73164AA2DD9BD,
             $3E2119396D09317E,$DC8DC4D964D3D9FE,$04FF1FBECDE4450D,$FCBE17776F24C10A,$4781670E40FE06BD,$EBFC9C60DFC83164,
             $3A63815960905AF9,$B99CD7FDB8C17828,$8910C7174F5EC640,$0829358A6E17A1CB,$359D489A6A3025B0,$EF86FDED5BFA7DBB,
             $B52FDC7D7826EBF5,$91D0EF98C2DD38CF,$B33A2F7B364E27A5,$A1F46B4BBE9E7541,$14AB0236BA4D4E55,$6CFCE5B02956446C,
             $CA667F94F13FB552,$FFAE1C451762A582,$C526F3129DECBA9A,$1C9363ACFB57CDD0,$7F185B668FAFD69C,$E431A640C182B9C9,
             $F48EE094B4D267B1,$725AED3E4E9D3FCD,$5DF67C83EFB5EABF,$5FF3DE335C7165AC,$5026CFA39C61B434,$7F8F8FBBDEF7B866,
             $7DE1ACD09DCFDD2A,$931D5E37C5CB7DEF,$D706C92B2F5A9434,$DF67371D4865E830,$88D712D511E803BC,$A2E4AB5492C49492,
             $A968606460C52054,$606216606BAC606B,$6DAC6A656068656A,$95D358D060656060,$AD33253F3721A281,$30B0868823068B12,
             $B9FABA79C45004CB,$F66D0002684A73AC
      Data.b $DD,$C6
      end_cursor_normal:
      
      cursor_move:
      ; ; ;       Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC200AD2020970,$5207AA6F166F2402,$1B0C0C8EBE8EE92C,$932482B224FFB9FB,
      ; ; ;              $18D4AA18197C823D,$85017E18185A1A18,$30301A9430305E1A,$C0C19AB060604ABC,$500DA05767305E20,$7FE185DDDBC92982,
      ; ; ;              $897B1E40FD99FF7B,$56366663FB2BAFA7,$0C0C566663A28601,$8E3C431C5D3C978C,$E250383B37BC9DBF,$ABDEF8F33577FD58,
      ; ; ;              $CEB614EAD597C545,$145BEA6A6BE269E5,$E09A5241E9AB52FC,$F1E9EA0E47ECBF9D,$FBA1A1A078BC6929,$A582CA665643A94E,
      ; ; ;              $BACE7A77CDE44C37,$B3D6F38DCF8EC4F7,$B6AE1CF7F9552763,$C6B9F55CF6BEFF78,$CB3E9A66F15BB54E,$E536E7DD5DFB7633,
      ; ; ;              $7775EFEDD9917EC7,$D8BC8EEE29569994,$72E2F29CF7744976,$D6C6D66F2AACE383,$F619E6A7DECB7C06,$6FBBD555A2ADE97F,
      ; ; ;              $4828D7BD7AA96774,$454D3051ECCB265B,$8AF6D3D8B6DDF8B0,$EB3F5EEAB412EF42,$F359693F19A312FB,$8A5E2EFBC93E25BC,
      ; ; ;              $78F0AC70A1629C99,$9E959E0A3ECBC9EE,$5A9E3954CFBE7297,$DF6FEFE2CCF045F5,$6367DC57B6BEDCDE,$1736DD81730E830E,
      ; ; ;              $6E9B8694E56E6CCE,$32FA7DC76E4DF3FE,$7C8BC691E574EE5D,$69B591386FF75B3A,$6B2CF23D8E0FCB12,$88F6B3717F654F4A,
      ; ; ;              $3FADBEF5F15FEEBE,$B7A60DA5A5C96B6F,$30B1DBF59FFBAE0E,$366F25A5F865E2BD,$DD6EFE581C9BD67B,$1B9DAC3CACDB9F9E,
      ; ; ;              $A1BC73B4D7FDD776,$919FBAD149E64B3A,$FF4E7A592F024A93,$29D0E55B88533512,$FDEF957AD74D9D46,$AF373AAABDF3E04A,
      ; ; ;              $8B66F65FF1F9D5A0,$EAEA7BA936AE279D,$9DBD27D977B67B6E,$5871D73F8A3FECF6,$6281F13568C79D6F,$A4A47B6ACB1BE2ED,
      ; ; ;              $78312D3732D819F8,$765FA7E4A8519171,$06C69723E0433B0C,$D43ADFD205D50139,$A1F9EDDC62FFC57E,$5708C05EB3CEC5E5,
      ; ; ;              $492C4949288D712D,$460C52054A2E4AB5,$06BAC606BA968606,$56668656A6062166,$6BF2400606DA0606,$53F3721A286BBBD6,
      ; ; ;              $0F31686B712AD332,$73F574F0606A02CB,$61970004D094E759
      ; ; ;       Data.b $25,$66
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC200AD2020970,$5207AA6F166F2402,$1B0C0C8EBE8EE92C,$932482B224FFB9FB,
             $18D4AA18197C823D,$85017E18185A1A18,$30301A9430305E1A,$C0C19AB060604ABC,$500DA05767305E20,$7FE185DDDBC92982,
             $897B1E40FD99FF7B,$36366663FB2BAFA7,$79403A924E15C335,$6FE38F10C7174F09,$8AD4CA170B67F683,$D05DF6E370E18E5F,
             $80F2E86764B0BC19,$F57A59DD89CF074B,$A610AD58D62696E0,$713B658B757E1747,$AD7CDCD85B5DF1F2,$DB7AA7BE11F0A7E9,
             $FA5F192E1D325802,$DE649F2FEEC6E93C,$EFB67CCD349CA909,$FF7CF7FBB5A787FD,$54AB4B799EFF635B,$FC40666B95528F4A,
             $92AEF97F36A72BDD,$C5A31EADE24FE3BE,$A5DE7BB9C5CBDA92,$2AF990D05EE0BFBF,$777DE0B93F7CDBF3,$E7BC78BC2936581E,
             $793DD2BBE5595FE3,$5C5864FA6D1BF1B9,$DDEAF32F3D5D19EF,$8A37BC449B7FC0D7,$F3EB64B19A5076BC,$6FB2EA34BBEE320F,
             $7371ABC2DB4CC907,$C71DDFF2D8DDCC4F,$ECD27B7A5CEF2A6F,$857F7ADE5FCAFBBF,$7FB89D7DF9E78D93,$B7DEBD8E2D8D0AAF,
             $3DFBF45B2976D395,$25F8EE45261B990E,$B1CAE1854670AA66,$343833F0F16FA737,$2315CAA7E15EFE76,$567D82CAE64B37D2,
             $593B92829A38BFB9,$2E18F008F99AF30E,$ADB351DBED79D99E,$7C2C6FD4EE0FEA2F,$E3754931AAB67DC6,$0A9B0E824E778CB7,
             $AA157B1C597534E7,$BB8FDCF2E870EAC4,$6BCC73FA935E6F6B,$BF9BB179B5D35D96,$333C589568DBEA9E,$8BD1258CECF221A1,
             $2F972978A3D97EBF,$E5DCBCE5A0476DA5,$BBFE6EC9FEDD6E5F,$D06763B0DBBCAE3E,$270FCC2C9FF2CE9B,$F1D7B9582B63177C,
             $1EE6643F7DA88CC8,$D9602EF75F0ED450,$D99F9A29E326C499,$DDC03F3C7EBF2ACF,$709DAF7CA520A192,$9AE5F2E265FAA6C1,
             $E537E3EF5D6E0CEC,$399141FA7B703E09,$6D7FFD20975CF4F6,$F27FF7D96149011A,$7CFEEB714D4F3405,$85C325BB13793CD9,
             $BEBC76AFAD4FB57C,$27F60FEF8F21E731,$1CA2BFFEBDAFFC4B,$524A235C4B546C98,$81528B92AD524B12,$81AEA5A181918314,
             $959981885981AEB1,$8181B6A5899585B1,$14670775FC818195,$B895699929F9B90D,$C0D40FF8FD75E435,$A129CEB2E7EAE9E0
      Data.b $09,$00,$D2,$24,$51,$DF
      end_cursor_move:
      
      cursor_ibeam:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C82C40ECD2020970,$81D2DD98D5240CC1,$C30323AFA3BA4B14,$3E40AC893FEE7EC6,
             $73BAC313BB907163,$208F64851C812F32,$868606352A86065F,$1786A1405F860616,$12AF0C0C06A50C0C,$1788303066AC1818,
             $0E4894036815D9CC,$FFF831A0657109F0,$964033A0B5DA7FFF,$8383C3305F90497C,$7F573E4B2D7B8E6E,$8134CC97FD4AB2AB,
             $D74697CD53AFF325,$F71D26B62C1C3BFB,$45DDDBC929790197,$59C390036DB67361,$71804FA40C5911E0,$056582416BE7AFF2,
             $5FF6E30050C0A08E,$8E2E9EEE1902E673,$D292521393D71C21,$3F9F921253531212,$83C2426259E8F278,$192B191819D38FA7,
             $362E986F9C2ACE0D,$A6E14AE16165DC45,$47AE2A3C4A3AEA59,$B25C9155551C6E2D,$238612E9E5225524,$01CE3AAF6BDBCCFC,
             $9292511AE25AA91A,$A40A945C956A9258,$8C0D752D0C0C8C18,$0CAD4C0C42CC0D75,$AC0C0DB4CD4CAC0D,$A28F3D2CBB2E0C0C,
             $8B12AD33253F3721,$DFD91FC986885306,$9D65CFD5D3C84281,$A57D182E00134253
      end_cursor_ibeam:
      
      cursor_cross:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C2CC2082D2020970,$52049D473A4F240C,$1B0C0C8EBE8EE92C,$8CF902B224FFB9FB,
             $C9CEEB0C4EEE41C5,$7C823D92147204BC,$5A1A1818D4AA1819,$305E1A85017E1818,$604ABC30301A9430,$305E20C0C19AB060,
             $C02B42500DA05767,$F0F87C090195C427,$FFFC15019EBEBEA1,$8FC7E3EE4E515FFF,$4BB9F2001CDF0BCE,$040478581982FC82,
             $7456644C0C555815,$BBB79245720E3EAE,$9C352023F5FCB70B,$881D9A40C56E6EF9,$0481D4F1BFF81839,$38C0278241223C0B,
             $02B2C120B5F3D7F9,$D7FDB8C1BB9074C7,$638BA7B44640B99C,$09848484E4F5C708,$2E5ADE30300F74F7,$111DB665F5E740BA,
             $C4C73B97177A7A3A,$56AF7F7F2A6C4848,$C606F9CB625843AA,$F71C1A6721A6DD80,$2DF65252F6FE4E2E,$F5FDAB63B1D38F17,
             $4A3A8C121484CCCD,$E574EFB7E5058FA5,$FF3A9EF2B0C82358,$4B546B4029CF7F64,$AD524B12524A235C,$8191831481528B92,
             $5981AEB181AEA5A1,$A99581A195A98188,$65C181958181B699,$A7E6E43451E7A597,$5248B0D6E255A664,$973F574F0655E416,
             $82E4C1004D094E75
      Data.b $BC
      end_cursor_cross:
      
      cursor_help:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C02C403CD2020970,$0299E7F745240CC1,$8606475F47749629,$7C8159127FDCFD8D,
             $E77586277720E2C6,$411EC90A39025E64,$0D0C0C6A550C0CBE,$2F0D4280BF0C0C2D,$255E18180D4A1818,$2F106060CD583030,
             $29712806D02BB398,$7EBE0C0195C427C0,$7EBF5FEFF7FBFAFD,$66B35DC809F4FA7D,$ECB80FC7E3FD900D,$BFDFEFEC205F2F97,
             $0E0E08C813F9FCFF,$87C3F0440DE6F37E,$2EA07140C9C9C90F,$9FCFAAD56AB05406,$F0783E0B2015033F,$F6FB7DBC04116200,
             $81B018A3708FC7E3,$CEC7B3D9EFFFFFFF,$B75AD2D2D6C80ECE,$11515170B0B09D6E,$3DBEDF6FDEA01CD0,$010189C4E274FA7D,
             $5915012EE2879201,$794CB03305F90494,$4E0DD1EA5183BF74,$527FDEC4D8272BF6,$DFF4C3E75D45F9DD,$F9EF267B531575BF,
             $8FC2FECF4B9B4EF5,$3ECDAB5F8799795C,$FCF3F764A81959E7,$DE49B41415347C49,$035E97D80B162EEE,$F4818B223C0B3872,
             $482D7CF5FE4E3009,$60EE141D31C0ACB0,$8663205CCE6BFEDC,$1EDF75C708638BA7,$62E916110726B177,$8936748334EE4337,
             $71954FFE3B490D1F,$83AB22EB2AB6FDAD,$99865552FFA58A97,$33C798D476BEE739,$F44A7DC7B86D2D74,$BC589FA6E709D5C4,
             $BD57DDD0A779CD41,$539B3EAE8BF982D6,$7F96D6B553FF8BBE,$9D33D62DDD521609,$5A3A69B18CDCF7AE,$F77B25DF2228FAA4,
             $1B0E8B4A81FAD7ED,$F8786FE83A50ADA6,$77E667FE07ECA2C9,$6FD8DDCB6E46B6D4,$A3CE03F2A664C671,$02B448BACE5D2533,
             $9292511AE25AA8DD,$A40A945C956A9258,$8C0D752D0C0C8C18,$0CAD4C0C42CC0D75,$AC0C0DB52C4CAC0D,$4503BABB2E5E0C0C,
             $6E255A664A7E6E43,$CCA280B2E77E330D,$1342539D65CFD5D3
      Data.b $00,$3D,$9E,$0B,$9F
      end_cursor_help:
      
      cursor_vertical:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC200AD2020970,$5207AA6F166F2402,$1B0C0C8EBE8EE92C,$932482B224FFB9FB,
             $18D4AA18197C823D,$85017E18185A1A18,$30301A9430305E1A,$C0C19AB060604ABC,$500DA05767305E20,$7FE185DDDBC92982,
             $897B1E40FD99FF7B,$36366663FB2BAFA7,$D0A042EEAD515516,$6FE38F10C7174F16,$7AE220643BE42D27,$21D782827854595E,
             $6FDFFDBE2C1B07FE,$CAC9824581040864,$DACCBF1DBBBC5B2A,$2BB1A7FBF973BFA6,$D1497D38DE9D7956,$DAE3571DAD02E9EE,
             $EB7B2EF82E586C7E,$5CB7C7BB648666C1,$FBBFC7A6BBCC1D5F,$67868BC5C1BF2286,$783454979CD40F65,$B4871FF93BFD91C4,
             $4D53A67EDC830A7D,$F27D11724E3EB83F,$C146F732825E4F60,$78EF389F27F35B39,$1D9647DCCB42837E,$C9A9574D1676CFFD,
             $79C3A3E641CD3E9A,$A6CB8CC586C60D07,$D92D4585FF657DEC,$EE804B9BB5DCFF77,$2C4949288D712D57,$0C52054A2E4AB549,
             $BAC606BA96860646,$2606566606216606,$06560606DAE6C656,$90D140E96F3EC706,$C35B895699929F9B,$9E0C0D40263C75F6,
             $009A129CEB2E7EAE
      Data.b $6B,$00,$95,$B8
      end_cursor_vertical:
      
      cursor_horizontal:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C5CC4042D2020970,$01278553BD240CC2,$8606475F47749629,$7C8159127FDCFD8D,
             $E77586277720E2C6,$411EC90A39025E64,$0D0C0C6A550C0CBE,$2F0D4280BF0C0C2D,$255E18180D4A1818,$2F106060CD583030,
             $10612806D02BB398,$FFF80440CAE213E0,$161646461EC83FFF,$9E1C81136497BD96,$111E160660BF2092,$990113031D1B0D15,
             $BC928A400BB5A6FB,$032607371A785DDD,$9A40C56E6EF99C39,$FBA931C16181A40D,$09E090488F02C120,$B0482D7CF5FE4E30,
             $6E307CE41D31C0AC,$E9E611902E6735FF,$E121393D71C218E2,$E9439E1E31C3258A,$242624EF3F0606FC,$8E4EF1C6CD59D96C,
             $2ACF35B36B2EEB81,$D54AECDA1CD56B87,$3BECE9BCDE3B8E1D,$E599E7A78DBAC737,$3218238AF3B5B0F2,$BC56AF2798983ABC,
             $B0C6C068CAA6E360,$7559C963A1934FBF,$292511AE25AA0DA0,$40A945C956A92589,$C0D752D0C0C8C18A,$CAD4C0C42CC0D758,
             $C0C0DB52C4CAC0D0,$503BABB2E5E0C0CA,$E255A664A7E6E434,$EC280B2E77E330D6,$342539D65CFD5D3C
      Data.b $01,$00,$E8,$67,$77,$1A
      end_cursor_horizontal:
      
      cursor_diagonal_1:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC2002D2020970,$148183F97435240C,$C6C30323AFA3BA4B,$633E40AC893FEE7E,
             $3273BAC313BB9071,$5F208F64851C812F,$16868606352A8606,$0C1786A1405F8606,$1812AF0C0C06A50C,$CC1788303066AC18,
             $F008F094036815D9,$2C2C2C00C0657109,$898A531858585240,$903FFFFFF8C20989,$F7FB636367676764,$297CA595BC501FEF,
             $81982FC824A84850,$98518580C0454785,$5598C447414346C3,$26A720BAD9FEEA7F,$01C9EF5508BBBB79,$320C56E6EF99C199,
             $0F6B6B7B1066C405,$804F048244781462,$6582416BE7AFF271,$FB7181CF20E98E05,$174F228C817339AF,$C5AFFDB1CB8910C7,
             $12B985B25A04141C,$F13D755F9BFF2AC3,$7971CEE733FBF6E7,$5099FC68F76D086A,$A6DB98A3B95CB0E7,$59C4C71283B5D7F9,
             $D9AC7E7418B49252,$107559BE898BE4B8,$9C9CD7C7E54AE2B3,$3C632F2F6DE6E6B6,$8D8C5FFFB4D2ECFC,$DB3DF9A3791E143F,
             $0542459315FFC7EE,$CC58A0C3DC4FABD6,$D51D8A0B9665E2C9,$5492C4949288D712,$6460C52054A2E4AB,$606BAC606BA96860,
             $656160656A606216,$B0606560606DA460,$FCDC868A0F409377,$BCCE1ADC4AB4CC94,$3F574F1F0A00615F,$F86A004D094E7597
      Data.b $8B,$46
      end_cursor_diagonal_1:
      
      cursor_diagonal_2:
      Data.q $E5E773F00CEB9C78,$F4F5E0606062E292,$C1CC2002D2020970,$148183F97435240C,$C6C30323AFA3BA4B,$633E40AC893FEE7E,
             $3273BAC313BB9071,$5F208F64851C812F,$16868606352A8606,$0C1786A1405F8606,$1812AF0C0C06A50C,$CC1788303066AC18,
             $F00A7094036815D9,$4159580DC0657109,$E2E2B843F3F3F3C6,$FFFE1B0D86C610E2,$8D97FBFDFC640FFF,$47207BD891E84D8D,
             $478581982FC824A8,$41485186DF40C045,$F5F783845B559442,$76F24C8E407365A1,$80320393DEAA1177,$83B34818ADCDDF33,
             $8C41ED6D6F620CD8,$4E3009E090488F02,$C0ACB0482D7CF5FE,$35FF6E302DE41D31,$18E2E9ED91902E67,$8358A2FFB5397122,
             $1E572994E44B8080,$76A57A5ECD37AFFD,$2326370E670EE5B6,$E68CB8CE8900EE5D,$BC66CF8659848D4C,$AF7AE923B797A43F,
             $979336E79AF69251,$DD8563577DD8B2FE,$E3FA938E05994B1A,$A77F547203E5D3B9,$F67FDCEFBC7ACA0B,$9BF6BF1FA2E4BC7E,
             $71C27FE5619CD606,$96A930505FF54B76,$5AA49624A49446B8,$0323062902A51725,$B3035D63035D4B43,$132B03432B530310,
             $DF03032B03036D63,$A7E6E43450DF5D6B,$D10460D16255A664,$78C0503FE58FEB30,$02684A73ACB9FABA
      Data.b $00,$8F,$A6,$8C,$6D
      end_cursor_diagonal_2:
    EndDataSection
    
  EndProcedure
  
  Procedure.i CallBack(*Object, EventType.i, Mouse_X.i, Mouse_Y.i)
    Protected result, drag_value = 1
    Static Drag, Drag_x, Drag_y
    
    Select EventType
      Case #PB_EventType_DragStart
        Debug 556556565
        Object = *Object
        SetCursor(EventGadget(), Cursor(#PB_Cursor_Denied), #PB_Canvas_CustomCursor)
        
      Case #PB_EventType_LeftButtonDown
        Drag = 1
        Drag_x = mouse_x
        Drag_y = mouse_y
        
      Case #PB_EventType_MouseMove
        If Drag And 
           Not (mouse_x>Drag_x-drag_value And 
                mouse_x<Drag_x+drag_value And 
                mouse_y>Drag_y-drag_value And
                mouse_y<Drag_y+drag_value)
          
          Object = *Object
          Event = #PB_EventType_DragStart
          
          Drag = 0
          ProcedureReturn 1
        EndIf
        
      Case #PB_EventType_MouseLeave
        ;SetCursor(EventGadget(), Cursor(#PB_Cursor_Denied), #PB_Canvas_CustomCursor)
        Object = 0
        
      Case #PB_EventType_MouseEnter
        Debug "drop enter mouse - "+*Object +" "+ DropAction(*Object)
        
        If DropAction(*Object) : Object = *Object
          SetCursor(EventGadget(), Cursor(#PB_Cursor_Hand), #PB_Canvas_CustomCursor)
        Else
          SetCursor(EventGadget(), Cursor(#PB_Cursor_Denied), #PB_Canvas_CustomCursor)
        EndIf
        
      Case #PB_EventType_LeftButtonUp : Drag = 0
        If DropAction(Object) : Event = #PB_EventType_Drop
          SetCursor(EventGadget(), Cursor(#PB_Cursor_Default), #PB_Canvas_CustomCursor)
          ;SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
          ProcedureReturn 1
        EndIf
        
    EndSelect
    
  EndProcedure
EndModule


;-
DeclareModule Widget
  EnableExplicit
  #Anchors = 9+4
  
  #Anchor_moved = 9
  
  ;   Structure _S_type
  ;     b.b
  ;     i.i 
  ;     s.s
  ;   EndStructure
  
  ;- - STRUCTUREs
  ;- - _S_Mouse
  Structure _S_mouse
    x.i
    y.i
    
    at.b ; - editor
    buttons.i 
    *delta._S_mouse
    direction.i
  EndStructure
  
  ;- - _S_Keyboard
  Structure _S_keyboard
    input.c
    key.i[2]
  EndStructure
  
  ;- - _S_Coordinate
  Structure _S_coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
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
  
  ;- - _S_Page
  Structure _S_page
    pos.i
    len.i
    *step
  EndStructure
  
  ;- - _S_Align
  Structure _S_align
    x.i
    y.i
    
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
  Structure _S_text Extends _S_coordinate
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
  
  ;- - _S_Bar
  Structure _S_bar Extends _S_coordinate
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *parent._S_widget ; adress parent
    *scroll._S_scroll 
    *first._S_widget
    *second._S_widget
    
    ticks.b  ; track bar
    smooth.b ; progress bar
    
    type.b[3] ; [2] for splitter
    radius.a
    cursor.i[2]
    
    max.i
    min.i
    
    hide.b[2]
    *box._S_box
    
    focus.b
    change.i[2]
    resize.b
    vertical.b
    inverted.b
    direction.i
    
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
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
  
  ;- - _S_widget
  Structure _S_widget Extends _S_bar
    Type_Index.i
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    ParentItem.i ; index parent tab item
    *i_Parent._S_items
    *data
    
    *Deactive._S_widget
    *Leave._S_widget
    at.i
    
    *Popup._S_widget
    *OptionGroup._S_widget
    
    fs.i 
    bs.i
    Grid.i
    Enumerate.i
    TabHeight.i
    
    Level.i ; Вложенность виджета
    Class.s ; 
    
    List *childrens._S_widget()
    List *items._S_items()
    List *columns._S_widget()
    ;List *draws._S_items()
    Map *Count()
    
    Flag._S_flag
    *Text._S_text[4]
    *Image._S_image[2]
    clip._S_coordinate
    *Align._S_align
    
    *Function[4] ; IsFunction *Function=0 >> Gadget *Function=1 >> Window *Function=2 >> Root *Function=3
    sublevellen.i
    Drag.i[2]
    Attribute.i
    
    Mouse._S_mouse
    Keyboard._S_keyboard
    
    margin._S_margin
    create.b
    
    event.i
    ;message.i
    repaint.i
    *anchor._S_anchor[#Anchors+1]
    *selector._S_anchor[#Anchors+1]
  EndStructure
  
  ;- - _S_root
  Structure _S_root ;Extends _S_widget
    widget._S_widget
    canvas.i
    canvas_window.i
  EndStructure
  
  ;- - _S_value
  Structure _S_value
    *root._S_root
    *this._S_widget
    *last._S_widget
    *active._S_widget
    *focus._S_widget
    
    List *openedList._S_widget()
  EndStructure
  
  
  
  ;-
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  #PB_EventType_Drop = DD::#PB_EventType_Drop
  
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
    
    #PB_Toggle
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
    
    #PB_Flag_Limit
  EndEnumeration
  
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
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *Value._S_value = AllocateStructure(_S_value)
  ;Global *root._S_root = AllocateStructure(_S_root)
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    *value\root
  EndMacro
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root\widget)
  EndMacro
  
  Macro _Gadget()
    Root()\Canvas
  EndMacro
  
  Macro _Window()
    Root()\canvas_window
  EndMacro
  
  Macro Focus() ; active gadget
    *Value\Focus
  EndMacro
  
  Macro Active() ; active window
    *Value\Active
  EndMacro
  
  Macro GetFocus() ; active gadget
    *Value\Focus
  EndMacro
  
  Macro GetActive() ; active window
    *Value\Active
  EndMacro
  
  Macro Adress(_this_)
    _this_\Adress
  EndMacro
  
  ;   Macro IsBar(_this_)
  ;     Bool(_this_ And (_this_\Type = #PB_GadgetType_ScrollBar Or _this_\Type = #PB_GadgetType_TrackBar Or _this_\Type = #PB_GadgetType_ProgressBar Or _this_\Type = #PB_GadgetType_Splitter))
  ;   EndMacro
  
  Macro IsWidget(_this_)
    Bool(_this_>Root()\widget And _this_<AllocateStructure(_S_widget)) * _this_ ; Bool(MemorySize(_this_)=MemorySize(AllocateStructure(_S_widget))) * _this_
  EndMacro
  
  Macro IsChildrens(_this_)
    ListSize(_this_\Childrens())
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
  Macro _scroll_in_start_(_this_) : Bool(_this_\Page\Pos =< _this_\Min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\Page\Pos >= (_this_\Max-_this_\Page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\Min + (_this_\Max - _this_\Page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
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
    (Bool(_this_\Function) << 1) + (Bool(_this_\Window And 
                                         _this_\Window\Function And 
                                         _this_\Window<>_this_\root\widget And 
                                         _this_\Window<>_this_ And 
                                         _this_\root\widget<>_this_) << 2) + (Bool(_this_\root\widget And _this_\root\widget\Function) << 3)
  EndMacro
  
  ;   Macro Match(_value_, _grid_, _max_=$7FFFFFFF)
  ;     ((Bool((_value_)>(_max_)) * (_max_)) + (Bool((_grid_) And (_value_)<(_max_)) * (Round(((_value_)/(_grid_)), #PB_Round_Nearest) * (_grid_))))
  ;   EndMacro
  
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget::*Value\This)
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget::*Value\This)
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget::*Value\This, _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget::*Value\This, _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget::*Value\This, _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget::*Value\This, _type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.s Class(Type.i)
  Declare.i Type(Class.s)
  
  Declare.i IsContainer(*this._S_widget)
  Declare.i Get_Gadget(*this._S_widget)
  Declare.i GetRootWindow(*this._S_widget)
  Declare.i GetButtons(*this._S_widget)
  Declare.i GetDisplay(*this._S_widget)
  Declare.i GetDeltaX(*this._S_widget)
  Declare.i GetDeltaY(*this._S_widget)
  Declare.i GetMouseX(*this._S_widget)
  Declare.i GetMouseY(*this._S_widget)
  Declare.i GetImage(*this._S_widget)
  Declare.i GetType(*this._S_widget)
  Declare.i GetData(*this._S_widget)
  Declare.s GetText(*this._S_widget)
  Declare.i GetPosition(*this._S_widget, Position.i)
  Declare.i GetWindow(*this._S_widget)
  Declare.i GetRoot(*this._S_widget)
  Declare.i GetAnchors(*this._S_widget, index.i=-1)
  Declare.i GetCount(*this._S_widget)
  Declare.s GetClass(*this._S_widget)
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
  Declare.i GetParent(*this._S_widget)
  Declare.i GetParentItem(*this._S_widget)
  Declare.i GetItemData(*this._S_widget, Item.i)
  Declare.i GetItemImage(*this._S_widget, Item.i)
  Declare.s GetItemText(*this._S_widget, Item.i, Column.i=0)
  Declare.i GetItemAttribute(*this._S_widget, Item.i, Attribute.i)
  
  Declare.i SetTransparency(*this._S_widget, Transparency.a)
  Declare.i SetAnchors(*this._S_widget)
  Declare.s SetClass(*this._S_widget, Class.s)
  Declare.i GetLevel(*this._S_widget)
  Declare.i Open(Window.i, X.i,Y.i,Width.i,Height.i, Text.s="", Flag.i=0, WindowID.i=0)
  Declare.i Post(EventType.i, *this._S_widget, EventItem.i=#PB_All, *Data=0)
  Declare.i Bind(*Function, *this._S_widget=#PB_All, EventType.i=#PB_All)
  Declare.i SetActive(*this._S_widget)
  Declare.i Y(*this._S_widget, Mode.i=0)
  Declare.i X(*this._S_widget, Mode.i=0)
  Declare.i Width(*this._S_widget, Mode.i=0)
  Declare.i Height(*this._S_widget, Mode.i=0)
  Declare.i Draw(*this._S_widget, Childrens=0)
  Declare.i GetState(*this._S_widget)
  Declare.i SetState(*this._S_widget, State.i)
  Declare.i SetAttribute(*this._S_widget, Attribute.i, Value.i)
  Declare.i CallBack(*this._S_widget, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*this._S_widget, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*this._S_widget, iX.i,iY.i,iWidth.i,iHeight.i);, *That._S_widget=#Null)
  Declare.i Hide(*this._S_widget, State.i=-1)
  Declare.i SetImage(*this._S_widget, Image.i)
  Declare.i SetData(*this._S_widget, *Data)
  Declare.i SetText(*this._S_widget, Text.s)
  Declare.i GetItemState(*this._S_widget, Item.i)
  Declare.i SetItemState(*this._S_widget, Item.i, State.i)
  Declare.i From(*this._S_widget, MouseX.i, MouseY.i)
  Declare.i SetPosition(*this._S_widget, Position.i, *Widget_2 =- 1)
  Declare.i Free(*this._S_widget)
  Declare.i SetFocus(*this._S_widget, State.i)
  
  Declare.i SetAlignment(*this._S_widget, Mode.i, Type.i=1)
  Declare.i SetItemData(*this._S_widget, Item.i, *Data)
  Declare.i CountItems(*this._S_widget)
  Declare.i ClearItems(*this._S_widget)
  Declare.i RemoveItem(*this._S_widget, Item.i)
  Declare.i SetItemAttribute(*this._S_widget, Item.i, Attribute.i, Value.i)
  Declare.i Enumerate(*this.Integer, *Parent._S_widget, ParentItem.i=0)
  Declare.i SetItemText(*this._S_widget, Item.i, Text.s)
  Declare.i AddColumn(*this._S_widget, Position.i, Title.s, Width.i)
  Declare.i SetFlag(*this._S_widget, Flag.i)
  Declare.i SetItemImage(*this._S_widget, Item.i, Image.i)
  Declare.i ReDraw(*this._S_widget=#Null)
  
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
  Declare.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
  Declare.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
  Declare.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
  Declare.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
  Declare.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Checkbox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Combobox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
  Declare.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
  Declare.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  Declare.i Popup(*Widget._S_widget, X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Form(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, *Widget._S_widget=0)
  Declare.i Create(Type.i, X.i,Y.i,Width.i,Height.i, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, ParentItem.i=0)
  Declare.i ExplorerList(X.i,Y.i,Width.i,Height.i, Directory.s, Flag.i=0)
  Declare.i IPAddress(X.i,Y.i,Width.i,Height.i)
  Declare.i Editor(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  
  Declare.i CloseList()
  Declare.i OpenList(*this._S_widget, Item.i=0)
  Declare.i SetParent(*this._S_widget, *Parent._S_widget, ParentItem.i=-1)
  Declare.i AddItem(*this._S_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
  
  Declare.i Resizes(*Scroll._S_scroll, X.i,Y.i,Width.i,Height.i)
  Declare.i Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
  Declare.i Canvas_CallBack()
  Declare.i Event_Widgets(*this._S_widget, EventType.i, EventItem.i=-1, EventData.i=0)
  Declare.i Events(*this._S_widget, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
  
  ;- GLOBALs
  Global Color_Default._S_color
  
  With Color_Default                          
    \State = 0
    \alpha = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
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
    _this_\Type = _type_
    _this_\Class = #PB_Compiler_Procedure
    
    ; Set parent
    If LastElement(*Value\OpenedList())
      If _this_\Type = #PB_GadgetType_Option
        If ListSize(*Value\OpenedList()\Childrens()) 
          If *Value\OpenedList()\Childrens()\Type = #PB_GadgetType_Option
            _this_\OptionGroup = *Value\OpenedList()\Childrens()\OptionGroup 
          Else
            _this_\OptionGroup = *Value\OpenedList()\Childrens() 
          EndIf
        Else
          _this_\OptionGroup = *Value\OpenedList()
        EndIf
      EndIf
      
      SetParent(_this_, *Value\OpenedList(), *Value\OpenedList()\o_i)
    EndIf
    
    ; _set_auto_size_
    If Bool(_flag_ & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
      _this_\Align = AllocateStructure(_S_align)
      _this_\Align\AutoSize = 1
      _this_\Align\Left = 1
      _this_\Align\Top = 1
      _this_\Align\Right = 1
      _this_\Align\Bottom = 1
    EndIf
    
    If Bool(_flag_ & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget) And _this_\root\widget And Not _this_\root\widget\anchor
      
      AddAnchors(_this_\root\widget)
      SetAnchors(_this_)
      
    EndIf
  EndMacro
  
  Macro Set_Cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\Canvas, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_Cursor(_this_)
    GetGadgetAttribute(_this_\root\Canvas, #PB_Canvas_Cursor)
  EndMacro
  
  ; SCROLLBAR
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\box 
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\height[3] = _this_\thumb\len 
      Else 
        _this_\box\width[3] = _this_\thumb\len 
      EndIf
    EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\pos+_this_\area\len 
      _this_\thumb\pos = (_this_\area\pos+_this_\area\len)-_this_\thumb\len 
    EndIf 
    
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
      
      If State > \max-\page\len
        If \max > \page\len 
          State = \max-\page\len
        Else
          State = \min 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn State
  EndProcedure
  
  Procedure.i ScrollPos(*this._S_widget, ThumbPos.i)
    Static ScrollPos.i
    Protected Result.i
    Protected min.i, max.i
    
    With *this
      min = \area\pos+\min
      max = \area\pos+(\area\len-\thumb\len)
      
      If ThumbPos < min : ThumbPos = min : EndIf
      If ThumbPos > max : ThumbPos = max : EndIf
      
      If ScrollPos <> ThumbPos 
        ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        If \page\step > 1
          ScrollPos = Round(ScrollPos / \page\step, #PB_Round_Nearest) * \page\step
        EndIf
        If #PB_GadgetType_TrackBar = \type And \vertical 
          ScrollPos = Invert(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
        ScrollPos = ThumbPos
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- Anchors
  Macro Draw_Anchors(_this_)
    If _this_\root\widget\anchor
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\widget\anchor[#Anchor_moved] : Box(_this_\root\widget\anchor[#Anchor_moved]\x, _this_\root\widget\anchor[#Anchor_moved]\y, _this_\root\widget\anchor[#Anchor_moved]\width, _this_\root\widget\anchor[#Anchor_moved]\height ,_this_\root\widget\anchor[#Anchor_moved]\color[_this_\root\widget\anchor[#Anchor_moved]\State]\frame) : EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      If _this_\root\widget\anchor[1] : Box(_this_\root\widget\anchor[1]\x, _this_\root\widget\anchor[1]\y, _this_\root\widget\anchor[1]\width, _this_\root\widget\anchor[1]\height ,_this_\root\widget\anchor[1]\color[_this_\root\widget\anchor[1]\State]\back) : EndIf
      If _this_\root\widget\anchor[2] : Box(_this_\root\widget\anchor[2]\x, _this_\root\widget\anchor[2]\y, _this_\root\widget\anchor[2]\width, _this_\root\widget\anchor[2]\height ,_this_\root\widget\anchor[2]\color[_this_\root\widget\anchor[2]\State]\back) : EndIf
      If _this_\root\widget\anchor[3] : Box(_this_\root\widget\anchor[3]\x, _this_\root\widget\anchor[3]\y, _this_\root\widget\anchor[3]\width, _this_\root\widget\anchor[3]\height ,_this_\root\widget\anchor[3]\color[_this_\root\widget\anchor[3]\State]\back) : EndIf
      If _this_\root\widget\anchor[4] : Box(_this_\root\widget\anchor[4]\x, _this_\root\widget\anchor[4]\y, _this_\root\widget\anchor[4]\width, _this_\root\widget\anchor[4]\height ,_this_\root\widget\anchor[4]\color[_this_\root\widget\anchor[4]\State]\back) : EndIf
      If _this_\root\widget\anchor[5] And Not _this_\Container : Box(_this_\root\widget\anchor[5]\x, _this_\root\widget\anchor[5]\y, _this_\root\widget\anchor[5]\width, _this_\root\widget\anchor[5]\height ,_this_\root\widget\anchor[5]\color[_this_\root\widget\anchor[5]\State]\back) : EndIf
      If _this_\root\widget\anchor[6] : Box(_this_\root\widget\anchor[6]\x, _this_\root\widget\anchor[6]\y, _this_\root\widget\anchor[6]\width, _this_\root\widget\anchor[6]\height ,_this_\root\widget\anchor[6]\color[_this_\root\widget\anchor[6]\State]\back) : EndIf
      If _this_\root\widget\anchor[7] : Box(_this_\root\widget\anchor[7]\x, _this_\root\widget\anchor[7]\y, _this_\root\widget\anchor[7]\width, _this_\root\widget\anchor[7]\height ,_this_\root\widget\anchor[7]\color[_this_\root\widget\anchor[7]\State]\back) : EndIf
      If _this_\root\widget\anchor[8] : Box(_this_\root\widget\anchor[8]\x, _this_\root\widget\anchor[8]\y, _this_\root\widget\anchor[8]\width, _this_\root\widget\anchor[8]\height ,_this_\root\widget\anchor[8]\color[_this_\root\widget\anchor[8]\State]\back) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\root\widget\anchor[1] : Box(_this_\root\widget\anchor[1]\x, _this_\root\widget\anchor[1]\y, _this_\root\widget\anchor[1]\width, _this_\root\widget\anchor[1]\height ,_this_\root\widget\anchor[1]\color[_this_\root\widget\anchor[1]\State]\frame) : EndIf
      If _this_\root\widget\anchor[2] : Box(_this_\root\widget\anchor[2]\x, _this_\root\widget\anchor[2]\y, _this_\root\widget\anchor[2]\width, _this_\root\widget\anchor[2]\height ,_this_\root\widget\anchor[2]\color[_this_\root\widget\anchor[2]\State]\frame) : EndIf
      If _this_\root\widget\anchor[3] : Box(_this_\root\widget\anchor[3]\x, _this_\root\widget\anchor[3]\y, _this_\root\widget\anchor[3]\width, _this_\root\widget\anchor[3]\height ,_this_\root\widget\anchor[3]\color[_this_\root\widget\anchor[3]\State]\frame) : EndIf
      If _this_\root\widget\anchor[4] : Box(_this_\root\widget\anchor[4]\x, _this_\root\widget\anchor[4]\y, _this_\root\widget\anchor[4]\width, _this_\root\widget\anchor[4]\height ,_this_\root\widget\anchor[4]\color[_this_\root\widget\anchor[4]\State]\frame) : EndIf
      If _this_\root\widget\anchor[5] : Box(_this_\root\widget\anchor[5]\x, _this_\root\widget\anchor[5]\y, _this_\root\widget\anchor[5]\width, _this_\root\widget\anchor[5]\height ,_this_\root\widget\anchor[5]\color[_this_\root\widget\anchor[5]\State]\frame) : EndIf
      If _this_\root\widget\anchor[6] : Box(_this_\root\widget\anchor[6]\x, _this_\root\widget\anchor[6]\y, _this_\root\widget\anchor[6]\width, _this_\root\widget\anchor[6]\height ,_this_\root\widget\anchor[6]\color[_this_\root\widget\anchor[6]\State]\frame) : EndIf
      If _this_\root\widget\anchor[7] : Box(_this_\root\widget\anchor[7]\x, _this_\root\widget\anchor[7]\y, _this_\root\widget\anchor[7]\width, _this_\root\widget\anchor[7]\height ,_this_\root\widget\anchor[7]\color[_this_\root\widget\anchor[7]\State]\frame) : EndIf
      If _this_\root\widget\anchor[8] : Box(_this_\root\widget\anchor[8]\x, _this_\root\widget\anchor[8]\y, _this_\root\widget\anchor[8]\width, _this_\root\widget\anchor[8]\height ,_this_\root\widget\anchor[8]\color[_this_\root\widget\anchor[8]\State]\frame) : EndIf
      
      
      If _this_\root\widget\anchor[10] : Box(_this_\root\widget\anchor[10]\x, _this_\root\widget\anchor[10]\y, _this_\root\widget\anchor[10]\width, _this_\root\widget\anchor[10]\height ,_this_\root\widget\anchor[10]\color[_this_\root\widget\anchor[10]\State]\frame) : EndIf
      If _this_\root\widget\anchor[11] : Box(_this_\root\widget\anchor[11]\x, _this_\root\widget\anchor[11]\y, _this_\root\widget\anchor[11]\width, _this_\root\widget\anchor[11]\height ,_this_\root\widget\anchor[11]\color[_this_\root\widget\anchor[11]\State]\frame) : EndIf
      If _this_\root\widget\anchor[12] : Box(_this_\root\widget\anchor[12]\x, _this_\root\widget\anchor[12]\y, _this_\root\widget\anchor[12]\width, _this_\root\widget\anchor[12]\height ,_this_\root\widget\anchor[12]\color[_this_\root\widget\anchor[12]\State]\frame) : EndIf
      If _this_\root\widget\anchor[13] : Box(_this_\root\widget\anchor[13]\x, _this_\root\widget\anchor[13]\y, _this_\root\widget\anchor[13]\width, _this_\root\widget\anchor[13]\height ,_this_\root\widget\anchor[13]\color[_this_\root\widget\anchor[13]\State]\frame) : EndIf
    EndIf
  EndMacro
  
  Macro Resize_Anchors(_this_)
    If _this_\root\widget\anchor[1] ; left
      _this_\root\widget\anchor[1]\x = _this_\x-_this_\root\widget\anchor[1]\width+_this_\root\widget\anchor[1]\Pos
      _this_\root\widget\anchor[1]\y = _this_\y+(_this_\height-_this_\root\widget\anchor[1]\height)/2
    EndIf
    If _this_\root\widget\anchor[2] ; top
      _this_\root\widget\anchor[2]\x = _this_\x+(_this_\width-_this_\root\widget\anchor[2]\width)/2
      _this_\root\widget\anchor[2]\y = _this_\y-_this_\root\widget\anchor[2]\height+_this_\root\widget\anchor[2]\Pos
    EndIf
    If  _this_\root\widget\anchor[3] ; right
      _this_\root\widget\anchor[3]\x = _this_\x+_this_\width-_this_\root\widget\anchor[3]\Pos
      _this_\root\widget\anchor[3]\y = _this_\y+(_this_\height-_this_\root\widget\anchor[3]\height)/2
    EndIf
    If _this_\root\widget\anchor[4] ; bottom
      _this_\root\widget\anchor[4]\x = _this_\x+(_this_\width-_this_\root\widget\anchor[4]\width)/2
      _this_\root\widget\anchor[4]\y = _this_\y+_this_\height-_this_\root\widget\anchor[4]\Pos
    EndIf
    
    If _this_\root\widget\anchor[5] ; left&top
      _this_\root\widget\anchor[5]\x = _this_\x-_this_\root\widget\anchor[5]\width+_this_\root\widget\anchor[5]\Pos
      _this_\root\widget\anchor[5]\y = _this_\y-_this_\root\widget\anchor[5]\height+_this_\root\widget\anchor[5]\Pos
    EndIf
    If _this_\root\widget\anchor[6] ; right&top
      _this_\root\widget\anchor[6]\x = _this_\x+_this_\width-_this_\root\widget\anchor[6]\Pos
      _this_\root\widget\anchor[6]\y = _this_\y-_this_\root\widget\anchor[6]\height+_this_\root\widget\anchor[6]\Pos
    EndIf
    If _this_\root\widget\anchor[7] ; right&bottom
      _this_\root\widget\anchor[7]\x = _this_\x+_this_\width-_this_\root\widget\anchor[7]\Pos
      _this_\root\widget\anchor[7]\y = _this_\y+_this_\height-_this_\root\widget\anchor[7]\Pos
    EndIf
    If _this_\root\widget\anchor[8] ; left&bottom
      _this_\root\widget\anchor[8]\x = _this_\x-_this_\root\widget\anchor[8]\width+_this_\root\widget\anchor[8]\Pos
      _this_\root\widget\anchor[8]\y = _this_\y+_this_\height-_this_\root\widget\anchor[8]\Pos
    EndIf
    
    If _this_\root\widget\anchor[#Anchor_moved] 
      _this_\root\widget\anchor[#Anchor_moved]\x = _this_\x
      _this_\root\widget\anchor[#Anchor_moved]\y = _this_\y
      _this_\root\widget\anchor[#Anchor_moved]\width = _this_\width
      _this_\root\widget\anchor[#Anchor_moved]\height = _this_\height
    EndIf
    
    If _this_\root\widget\anchor[10] And _this_\root\widget\anchor[11] And _this_\root\widget\anchor[12] And _this_\root\widget\anchor[13]
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
        
        PushListPosition(\Parent\Childrens())
        ForEach \Parent\Childrens()
          If Not \Parent\Childrens()\Hide
            relative_x1 = \Parent\Childrens()\x
            relative_y1 = \Parent\Childrens()\y
            relative_x2 = relative_x1+\Parent\Childrens()\width
            relative_y2 = relative_y1+\Parent\Childrens()\height
            
            ;Left_line
            If checked_x1 = relative_x1
              If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
              If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
              
              ; \root\widget\anchor[10]\Color[0]\Frame = $0000FF
              \root\widget\anchor[10]\hide = 0
              \root\widget\anchor[10]\x = checked_x1
              \root\widget\anchor[10]\y = left_y1
              \root\widget\anchor[10]\Width = ls
              \root\widget\anchor[10]\Height = left_y2-left_y1
            Else
              ; \root\widget\anchor[10]\Color[0]\Frame = $000000
              \root\widget\anchor[10]\hide = 1
            EndIf
            
            ;Right_line
            If checked_x2 = relative_x2
              If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
              If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
              
              \root\widget\anchor[12]\hide = 0
              \root\widget\anchor[12]\x = checked_x2-ls
              \root\widget\anchor[12]\y = right_y1
              \root\widget\anchor[12]\Width = ls
              \root\widget\anchor[12]\Height = right_y2-right_y1
            Else
              \root\widget\anchor[12]\hide = 1
            EndIf
            
            ;Top_line
            If checked_y1 = relative_y1 
              If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
              If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
              
              \root\widget\anchor[11]\hide = 0
              \root\widget\anchor[11]\x = top_x1
              \root\widget\anchor[11]\y = checked_y1
              \root\widget\anchor[11]\Width = top_x2-top_x1
              \root\widget\anchor[11]\Height = ls
            Else
              \root\widget\anchor[11]\hide = 1
            EndIf
            
            ;Bottom_line
            If checked_y2 = relative_y2 
              If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
              If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
              
              \root\widget\anchor[13]\hide = 0
              \root\widget\anchor[13]\x = bottom_x1
              \root\widget\anchor[13]\y = checked_y2-ls
              \root\widget\anchor[13]\Width = bottom_x2-bottom_x1
              \root\widget\anchor[13]\Height = ls
            Else
              \root\widget\anchor[13]\hide = 1
            EndIf
          EndIf
        Next
        PopListPosition(\Parent\Childrens())
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure Anchors_Events(*this._S_widget, mouse_x.i, mouse_y.i)
    With *this
      Protected.i Px,Py, Grid = \Grid, IsGrid = Bool(Grid>1)
      
      If \Parent
        Px = \Parent\x[2]
        Py = \Parent\y[2]
      EndIf
      
      Protected mx = Match(mouse_x-Px, Grid)
      Protected my = Match(mouse_y-Py, Grid)
      Protected mw = Match((\x+\Width-IsGrid)-mouse_x, Grid)+IsGrid
      Protected mh = Match((\y+\height-IsGrid)-mouse_y, Grid)+IsGrid
      Protected mxw = Match(mouse_x-\x, Grid)+IsGrid
      Protected myh = Match(mouse_y-\y, Grid)+IsGrid
      
      Select \root\widget\anchor
        Case \root\widget\anchor[1] : Resize(*this, mx, #PB_Ignore, mw, #PB_Ignore)
        Case \root\widget\anchor[2] : Resize(*this, #PB_Ignore, my, #PB_Ignore, mh)
        Case \root\widget\anchor[3] : Resize(*this, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
        Case \root\widget\anchor[4] : Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
          
        Case \root\widget\anchor[5] 
          If \Container ; Form, Container, ScrollArea, Panel
            Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
          Else
            Resize(*this, mx, my, mw, mh)
          EndIf
          
        Case \root\widget\anchor[6] : Resize(*this, #PB_Ignore, my, mxw, mh)
        Case \root\widget\anchor[7] : Resize(*this, #PB_Ignore, #PB_Ignore, mxw, myh)
        Case \root\widget\anchor[8] : Resize(*this, mx, #PB_Ignore, mw, myh)
          
        Case \root\widget\anchor[#Anchor_moved] 
          If Not \Container
            Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure CallBack_Anchors(*this._S_widget, EventType.i, Buttons.i, MouseScreenX.i,MouseScreenY.i)
    Protected i 
    
    With *this
      If \root\widget\anchor 
        Select EventType 
          Case #PB_EventType_MouseMove
            If \root\widget\anchor\state = 2
              
              ProcedureReturn Anchors_Events(\root\widget\anchor\widget, MouseScreenX-\root\widget\anchor\delta_x, MouseScreeny-\root\widget\anchor\delta_y)
              
            ElseIf Not Buttons
              ; From anchor
              For i = 1 To #Anchors 
                If \root\widget\anchor[i]
                  If (MouseScreenX>\root\widget\anchor[i]\X And MouseScreenX=<\root\widget\anchor[i]\X+\root\widget\anchor[i]\Width And 
                      MouseScreenY>\root\widget\anchor[i]\Y And MouseScreenY=<\root\widget\anchor[i]\Y+\root\widget\anchor[i]\Height)
                    
                    \root\widget\anchor\state = 0
                    \root\widget\anchor\widget = 0
                    \root\widget\anchor = \root\widget\anchor[i]
                    \root\widget\anchor\widget = *this
                    Break
                  EndIf
                EndIf
              Next
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            \root\widget\anchor\state = 2 
            \root\widget\anchor\delta_x = MouseScreenX-\root\widget\anchor\x
            \root\widget\anchor\delta_y = MouseScreenY-\root\widget\anchor\y
            
          Case #PB_EventType_LeftButtonUp
            \root\widget\anchor\State = 1 
            
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
      If \Parent
        If \Parent\Type = #PB_GadgetType_Splitter
          ProcedureReturn
        EndIf
        
        \Grid = \Parent\Grid
      Else
        If \Container
          \Grid = Size
        Else
          \Grid = Size
        EndIf
      EndIf
      
      For i = 1 To #Anchors
        \root\widget\anchor[i] = AllocateStructure(_S_anchor)
        \root\widget\anchor[i]\Color[0]\Frame = $000000
        \root\widget\anchor[i]\Color[1]\Frame = $FF0000
        \root\widget\anchor[i]\Color[2]\Frame = $0000FF
        
        \root\widget\anchor[i]\Color[0]\Back = $FFFFFF
        \root\widget\anchor[i]\Color[1]\Back = $FFFFFF
        \root\widget\anchor[i]\Color[2]\Back = $FFFFFF
        
        \root\widget\anchor[i]\Width = 6
        \root\widget\anchor[i]\Height = 6
        
        If \Container And i = 5
          \root\widget\anchor[5]\Width * 2
          \root\widget\anchor[5]\Height * 2
        EndIf
        
        If i=10 Or i=12
          \root\widget\anchor[i]\Color[0]\Frame = $0000FF
          ;           \root\widget\anchor[i]\Color[1]\Frame = $0000FF
          ;           \root\widget\anchor[i]\Color[2]\Frame = $0000FF
        EndIf
        If i=11 Or i=13
          \root\widget\anchor[i]\Color[0]\Frame = $FF0000
          ;           \root\widget\anchor[i]\Color[1]\Frame = $FF0000
          ;           \root\widget\anchor[i]\Color[2]\Frame = $FF0000
        EndIf
        
        \root\widget\anchor[i]\Pos = \root\widget\anchor[i]\Width-3
      Next i
      
      
      \root\widget\anchor[1]\class = "left"
      \root\widget\anchor[2]\class = "top"
      \root\widget\anchor[3]\class = "right"
      \root\widget\anchor[4]\class = "botom"
      \root\widget\anchor[5]\class = "lefttop"
      \root\widget\anchor[6]\class = "righttop"
      \root\widget\anchor[7]\class = "rightbottom"
      \root\widget\anchor[8]\class = "leftbottom"
      \root\widget\anchor[9]\class = "move"
      
      
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
    ProcedureReturn Bool(*this\root\widget\anchor[(Bool(index.i=-1) * #Anchor_moved) + (Bool(index.i>0) * index)]) * *this
  EndProcedure
  
  Procedure.i RemoveAnchors(*this._S_widget)
    Protected Result.i
    
    With *this
      If \root\widget\anchor
        Result = \root\widget\anchor
        \root\widget\anchor = 0
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAnchors(*this._S_widget)
    Protected Result.i
    Static *LastPos, *Last._S_widget
    
    With *this
      If \root\widget\anchor[#Anchor_moved] And *Last <> *this
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
        
        \root\widget\anchor = \root\widget\anchor[#Anchor_moved]
        \root\widget\anchor\Widget = *this
        
        If \Container
          \root\widget\anchor[5]\Width = 12
          \root\widget\anchor[5]\Height = 12
        Else
          \root\widget\anchor[5]\Width = 6
          \root\widget\anchor[5]\Height = 6
        EndIf
        \root\widget\anchor[5]\Pos = \root\widget\anchor[5]\Width-3
        
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
            Protected *Widget._S_widget = GetGadgetData(\root\Canvas)
            
            If CallBack(\Childrens(), #PB_EventType_LeftButtonDown, WindowMouseX(\root\Canvas_window), WindowMouseY(\root\Canvas_window))
              ; If \Childrens()\index[2] <> \Childrens()\index[1]
              *Widget\index[2] = \Childrens()\index[1]
              Post(#PB_EventType_Change, *Widget, \Childrens()\index[1])
              
              SetText(*Widget, GetItemText(\Childrens(), \Childrens()\index[1]))
              \Childrens()\index[2] = \Childrens()\index[1]
              \Childrens()\Mouse\Buttons = 0
              \Childrens()\index[1] =- 1
              \Childrens()\Focus = 1
              \Mouse\Buttons = 0
              ReDraw(*this)
              ; EndIf
            EndIf
            
            SetActiveGadget(*Widget\root\Canvas)
            *Widget\Color\State = 0
            *Widget\box\Checked = 0
            SetActive(*Widget)
            ReDraw(*Widget\root\widget)
            HideWindow(\root\Canvas_window, 1)
            
          Case #PB_Event_Gadget
            MouseX = GetGadgetAttribute(\root\Canvas, #PB_Canvas_MouseX)
            MouseY= GetGadgetAttribute(\root\Canvas, #PB_Canvas_MouseY)
            
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
        X = \x+GadgetX(\root\Canvas, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\root\Canvas, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(\root\Canvas))
        
        ForEach *Widget\Childrens()\Items()
          If *Widget\Childrens()\items()\text\change = 1
            *Widget\Childrens()\items()\text\height = TextHeight("A")
            *Widget\Childrens()\items()\text\width = TextWidth(*Widget\Childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\Childrens()\Scroll\Width < (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\Scroll\h\Page\Pos
            *Widget\Childrens()\Scroll\Width = (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\Scroll\h\Page\Pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      SetActive(*Widget\Childrens())
      ;*Widget\Childrens()\Focus = 1
      
      Protected Width = *Widget\Childrens()\Scroll\width + *Widget\Childrens()\bs*2 
      Protected Height = *Widget\Childrens()\Scroll\height + *Widget\Childrens()\bs*2 
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, #PB_Ignore,#PB_Ignore, width, Height )
      If *Widget\Resize
        ResizeWindow(*Widget\root\Canvas_window, x, y, width, Height)
        ResizeGadget(*Widget\root\Canvas, #PB_Ignore, #PB_Ignore, width, Height)
      EndIf
    EndWith
    
    ReDraw(*Widget)
    
    HideWindow(*Widget\root\Canvas_window, 0, #PB_Window_NoActivate)
  EndProcedure
  
  Procedure.i Popup(*Widget._S_widget, X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    
    With *this
      If *this
        \root = *this
        \Type = #PB_GadgetType_Popup
        \Container = #PB_GadgetType_Popup
        \Color = Color_Default
        \color\Fore = 0
        \color\Back = $FFF0F0F0
        \color\alpha = 255
        \Color[1]\Alpha = 128
        \Color[2]\Alpha = 128
        \Color[3]\Alpha = 128
        
        If X=#PB_Ignore 
          X = *Widget\x+GadgetX(*Widget\root\Canvas, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\root\Canvas, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        If IsWindow(*Widget\root\Canvas_window)
          Protected WindowID = WindowID(*Widget\root\Canvas_window)
        EndIf
        
        \root\widget\Parent = *Widget
        \root\Canvas_window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \root\Canvas = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(\root\widget, 1,1, width, Height)
        
        SetWindowData(\root\Canvas_window, *this)
        SetGadgetData(\root\Canvas, *Widget)
        
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \root\Canvas_window);, \Canvas )
        BindGadgetEvent(\root\Canvas, @CallBack_Popup())
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
  
  Procedure.i Type(Class.s)
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
      Resize(_this_\First, 0, 0, _this_\width, _this_\Thumb\Pos-_this_\y)
      Resize(_this_\Second, 0, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y))
    Else
      Resize(_this_\First, 0, 0, _this_\Thumb\Pos-_this_\x, _this_\height)
      Resize(_this_\Second, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\Pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro Resize_Childrens(_this_, _change_x_, _change_y_)
    ForEach _this_\Childrens()
      Resize(_this_\Childrens(), (_this_\Childrens()\x-_this_\x-_this_\bs) + _change_x_, (_this_\Childrens()\y-_this_\y-_this_\bs-_this_\TabHeight) + _change_y_, #PB_Ignore, #PB_Ignore)
    Next
  EndMacro
  
  Procedure Init_Event( *this._S_widget)
    If *this
      With *this
        If ListSize(\Childrens())
          ForEach \Childrens()
            If \Childrens()\Deactive
              If \Childrens()\Deactive <> \Childrens()
                Events(\Childrens()\Deactive, \Childrens()\Deactive\at, #PB_EventType_LostFocus, 0, 0)
              EndIf
              
              Events(\Childrens(), \Childrens()\at, #PB_EventType_Focus, 0, 0)
              \Childrens()\Deactive = 0
            EndIf
            
            If ListSize(\Childrens()\Childrens())
              Init_Event(\Childrens())
            EndIf
          Next
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Text\Caret))
      Left = (Width + Right)
      
      If \Scroll\X < Right
        ; Scroll::SetState(\Scroll\h, -Right)
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
        ; Scroll::SetState(\Scroll\h, -Left) 
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Keyboard\Input = 65535 ) : \Keyboard\Input = 0
        \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
        If \Scroll\X>0 : \Scroll\X=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  ; SET_
  Procedure.i Set_State(*this._S_widget, List *Item._S_items(), State.i)
    Protected Repaint.i, sublevel.i, Mouse_X.i, Mouse_Y.i
    
    With *this
      If ListSize(*Item())
        Mouse_X = \Mouse\x
        Mouse_Y = \Mouse\y
        
        If State >= 0 And SelectElement(*Item(), State) 
          If (Mouse_Y > (*Item()\box\y[1]) And Mouse_Y =< ((*Item()\box\y[1]+*Item()\box\height[1]))) And 
             ((Mouse_X > *Item()\box\x[1]) And (Mouse_X =< (*Item()\box\x[1]+*Item()\box\width[1])))
            
            *Item()\box\Checked[1] ! 1
          ElseIf (\flag\buttons And *Item()\childrens) And
                 (Mouse_Y > (*Item()\box\y[0]) And Mouse_Y =< ((*Item()\box\y[0]+*Item()\box\height[0]))) And 
                 ((Mouse_X > *Item()\box\x[0]) And (Mouse_X =< (*Item()\box\x[0]+*Item()\box\width[0])))
            
            sublevel = *Item()\sublevel
            *Item()\box\Checked ! 1
            \Change = 1
            
            PushListPosition(*Item())
            While NextElement(*Item())
              If sublevel = *Item()\sublevel
                Break
              ElseIf sublevel < *Item()\sublevel And *Item()\i_Parent
                *Item()\hide = Bool(*Item()\i_Parent\box\Checked Or *Item()\i_Parent\hide) * 1
              EndIf
            Wend
            PopListPosition(*Item())
            
          ElseIf \index[2] <> State : *Item()\State = 2
            If \index[2] >= 0 And SelectElement(*Item(), \index[2])
              *Item()\State = 0
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
  
  Procedure.i Bind(*Function, *this._S_widget=#PB_All, EventType.i=#PB_All)
    Protected Repaint.i
    
    With *this
      If *this = #PB_All
        Root()\widget\Function[1] = *Function
      ElseIf Not \Function[1]
        \Function[1] = *Function
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i UnBind(*Function, *this._S_widget=#PB_All, EventType.i=#PB_All)
    Protected Repaint.i
    
    With *this
      If *this = #PB_All And Root()\widget\Function = *Function
        Root()\widget\Function = 0
        Root()\widget\Function[1] = 0
        Root()\widget\Function[2] = 0
        Root()\widget\Function[3] = 0
      ElseIf \Function = *Function
        \Function = 0
        \Function[1] = 0
        \Function[2] = 0
        \Function[3] = 0
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Macro Send(_this_, _event_type_, _event_item_, _event_data_)
    If _this_\Function And 
       CallCFunctionFast(_this_\Function, _this_, _event_type_, _event_item_, _event_data_)
    ElseIf (_this_\Window And _this_\Window<>_this_\root\widget And _this_\Window<>_this_ And _this_\root\widget<>_this_ And _this_\Window\Function) And 
           CallCFunctionFast(_this_\Window\Function, _this_, _event_type_, _event_item_, _event_data_)
    ElseIf _this_\root\widget And _this_\root\widget\Function And 
           CallCFunctionFast(_this_\root\widget\Function, _this_, _event_type_, _event_item_, _event_data_)
    EndIf
  EndMacro
  
  Procedure.i Post(EventType.i, *this._S_widget, EventItem.i=#PB_All, *Data=0)
    Protected Repaint.i
    
    With *this
      If \Function
        Repaint = CallCFunctionFast(\Function, *this, EventType, EventItem, *Data)
      EndIf
      
      If (\Window And \Window<>\root\widget And \Window<>*this And \root\widget<>*this And \Window\Function)
        Repaint = CallCFunctionFast(\Window\Function, *this, EventType, EventItem, *Data)
      EndIf
      
      If \root\widget And \root\widget\Function
        Repaint = CallCFunctionFast(\root\widget\Function, *this, EventType, EventItem, *Data)
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure.s Text_Make(*this._S_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *this
      If \Text\Numeric And Text.s <> #LF$
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
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String.s[1], \Text\Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String.s[1], \Text\Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Text\Caret + 1, 1) = "."
                ;                 \Text\Caret + 1 : \Text\Caret[1]=\Text\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String.s[1], \Text\Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String.s[1], \Text\Caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
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
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          MouseX = \Mouse\X - (\Items()\Text\X+\Scroll\X)
          
          If StartDrawing(CanvasOutput(\root\Canvas)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (MouseX-X)*(MouseX-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \Text\Caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\Items())
            ;             If \Mouse\Y < \Y+(\Text\Height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \Index[1] Or LastItem <> Item
            ;               \Items()\Text[2]\Width[2] = 0
            ;               
            ;               If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
            ;                  \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
            ;                  (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*this\Items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
            ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
            ;                 EndIf 
            ;                 
            ;                 ; \Items()\Text[2]\Width = (\Items()\Width-\Items()\Text\Width) + TextWidth(\Items()\Text[2]\String.s)
            ;                 
            ;                 If \Flag\FullSelection
            ;                   \Items()\Text[2]\Width[2] = \Flag\FullSelection
            ;                 Else
            ;                   \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
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
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Editor_Change(*this._S_widget, Pos.i, Len.i)
    With *this
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Change = #True
      EndIf
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Change = 1
      EndIf
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      If (\Text[1]\Change Or \Text[3]\Change)
        If \Text[1]\Change
          \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
          \Text[1]\String.s = Left(\Text\String.s[1], \Text[1]\Len) 
          \Text[2]\Pos = \Text[1]\Len
        EndIf
        
        If \Text[3]\Change
          \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
          \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
          \Text[3]\String.s = Right(\Text\String.s[1], \Text[3]\Len)
        EndIf
        
        If \Text[1]\Len <> \Text[3]\Pos 
          \Text[2]\Change = 1 
          \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
          \Text[2]\String.s = Mid(\Text\String.s[1], 1 + \Text[2]\Pos, \Text[2]\Len) 
        Else
          \Text[2]\Len = 0 : \Text[2]\String.s = ""
        EndIf
        
        \Text[1]\Change = 0 : \Text[3]\Change = 0 
      EndIf
      
      
      
      ;       If CountString(\Text[3]\String.s, #LF$)
      ;         Debug "chang "+\Items()\Text\String.s +" "+ CountString(\Text[3]\String.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure.i Editor_SelText(*this._S_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *this
      ;Debug "7777    "+\Text\Caret +" "+ \Text\Caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\Text\String
      
      If (Caret <> \Text\Caret Or Line <> \Index[1] Or (\Text\Caret[1] >= 0 And Caret1 <> \Text\Caret[1]))
        \Items()\Text[2]\String.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
            \Items()\Text[2]\Width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Width[2] = 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret 
            Pos = \Text\Caret[1]
            ;             If \Text\Caret[1] = \Items()\Text\Len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \Text\Caret[1] > \Text\Caret 
            ; |<<<<<< to left
            Pos = \Text\Caret
            Len = (\Text\Caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \Text\Caret[1]
            Len = (\Text\Caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \Text\Caret
          Len = \Items()\Text\Len-Pos
          ; Len - Bool(\Items()\Text\Len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \Text\Caret
        EndIf
        
        Editor_Change(*this, Pos, Len)
        
        Line = \Index[1]
        Caret = \Text\Caret
        Caret1 = \Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i Editor_SelReset(*this._S_widget)
    With *this
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
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
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Editor_Move(*this._S_widget, Width)
    Protected Left,Right
    
    With *this
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \Text\Big) ;And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \Items()\Text\String.s
        Protected string_len.i = \Items()\Text\Len
        Protected mouse_x.i = \Mouse\X-(\Items()\Text\X+\Scroll\X)
        
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
        \Items()\Text[3]\Width = TextWidth(Right(String.s, string_len-Caret))
        
        If \Scroll\X < Right
          SetState(\Scroll\h, -Right) ;: \Scroll\X = Right
        ElseIf \Scroll\X > Left
          SetState(\Scroll\h, -Left) ;: \Scroll\X = Left
        ElseIf (\Scroll\X < 0 And \Keyboard\Input = 65535 ) : \Keyboard\Input = 0
          \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
          If \Scroll\X>0 : \Scroll\X=0 : EndIf
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
          \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        Else
          \Text\Caret = \Items()\Text[1]\Len + Len(Chr.s)
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      \Text\String.s[1] = \Text[1]\String + Chr.s + \Text[3]\String
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
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\String.s[1] = \Text[1]\String + Chr.s + \Text[3]\String
          \Text\Caret[1] = \Text\Caret 
          ; \CountItems = CountString(\Text\String.s[1], #LF$)
          \Text\Change =- 1 ; - 1 post event change widget
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
      If _this_\Scroll And Not _this_\hide And Not _this_\Items()\Hide
        _this_\Scroll\Height+_this_\Text\Height
        
        
        ; _this_\scroll\v\max = _this_\scroll\Height
      EndIf
    EndMacro
    
    Macro _set_scroll_width_(_this_)
      If _this_\Scroll And Not _this_\items()\hide And
         _this_\Scroll\width<(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        _this_\scroll\width=(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        ;        _this_\Scroll\width<(_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        ;       _this_\scroll\width=(_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
        
        ;       If _this_\scroll\width < _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
        ;         _this_\scroll\width = _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
        ;       EndIf
        
        ;        If _this_\scroll\Height < _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
        ;         _this_\scroll\Height = _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
        ;       EndIf
        
        _this_\Text\Big = _this_\Items()\Index ; Позиция в тексте самой длинной строки
        _this_\Text\Big[1] = _this_\Items()\Text\Pos ; Может и не понадобятся
        _this_\Text\Big[2] = _this_\Items()\Text\Len ; Может и не понадобятся
        
        
        ; _this_\scroll\h\max = _this_\scroll\width
        ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
      EndIf
    EndMacro
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\ImageID
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\CountItems))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\CountItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\CountItems)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\CountItems)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\CountItems)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\ImageID
        If _this_\Flag\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-_this_\Items()\Text\Width)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+_this_\Items()\Text\Width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\Text\Width+_this_\Image\Width)/2)+Indent
            Image_X=(Width-_this_\Items()\Text\Width-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-_this_\Items()\Text\Width)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-_this_\Items()\Text\Width)
        ElseIf _this_\Text\Align\Horizontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        Else
          Text_X=_this_\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X + 5
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y+_this_\Scroll\Height+Text_Y + 2
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\CountItems<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\CountItems<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\Items()\Text\Pos = _this_\Text\Pos - Bool(_this_\Text\MultiLine = 1)*_this_\Items()\index ; wordwrap
      _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
      _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *this
      \CountItems = ListSize(\Items())
      
      Width = \width[2] - (Bool(Not \Scroll\v\Hide) * \Scroll\v\width) - \margin\width
      Height = \height[2] - Bool(Not \Scroll\h\Hide) * \Scroll\h\height
      
      \Items()\Index[1] =- 1
      ;\Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default color state           
      \Items()\State = 1
      
      ; Update line pos in the text
      _set_line_pos_(*this)
      
      _set_content_X_(*this)
      _line_resize_X_(*this)
      _line_resize_Y_(*this)
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*this)
      
      ; Scroll hight length
      _set_scroll_height_(*this)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i Editor_MultiLine(*this._S_widget)
    Protected Repaint, String.s, text_width, Len.i
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      Width = \width[2] - (Bool(Not \Scroll\v\Hide) * \Scroll\v\width) - \margin\width
      Height = \height[2] - Bool(Not \Scroll\h\Hide) * \Scroll\h\height
      
      If \Text\MultiLine > 0
        String.s = Text_Wrap(*this, \Text\String.s[1], Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s[1]
      EndIf
      
      \Text\Pos = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        \Text\String.s[2] = String.s
        \CountItems = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0
        _set_content_Y_(*this)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Editor_Move(*this, Width)
        EndIf
        
        If \CountItems[1] <> \CountItems Or \Text\Vertical
          \CountItems[1] = \CountItems
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \CountItems To 1 Step - 1
              If AddElement(\Items())
                \Items() = AllocateStructure(_S_items)
                String = StringField(\Text\String.s[2], IT, #LF$)
                
                ;\Items()\Focus =- 1
                \Items()\Index[1] =- 1
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String))
                Else
                  \Items()\Text\Width = TextWidth(String)
                EndIf
                
                If \Text\Align\Right
                  Text_X=(Width-\Items()\Text\Width) 
                ElseIf \Text\Align\Horizontal
                  Text_X=(Width-\Items()\Text\Width-Bool(\Items()\Text\Width % 2))/2 
                EndIf
                
                \Items()\x = \X[2]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[2]+\Text\X+Text_X
                \Items()\Width = \Text\Height
                \Items()\Height = Width
                \Items()\Index = ListIndex(\Items())
                
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\Vertical = \Text\Vertical
                If \Text\Rotate = 270
                  \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
                  \Items()\Text\y = \Items()\y
                Else
                  \Items()\Text\x = \Image\Width+\Items()\x
                  \Items()\Text\y = \Items()\y+\Items()\Text\Width
                EndIf
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                _set_scroll_height_(*this)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \Text\String.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\Items())
                    \Items() = AllocateStructure(_S_items)
                    
                    \Items()\Text\String.s = Trim(RegularExpressionMatchString(0), #LF$)
                    \Items()\Text\Width = TextWidth(\Items()\Text\String.s) ; Нужен для скролл бара
                    
                    ;\Items()\Focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\State = 1 ; Set line default colors
                    \Items()\Radius = \Radius
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
            ;             Protected *Sta.Character = @\Text\String.s[2], *End.Character = @\Text\String.s[2] : #SOC = SizeOf (Character)
            ;While *End\c 
            ;               If *End\c = #LF And AddElement(\Items())
            ;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
            ;                 
            ;                 \Items()\Text\String.s = PeekS (*Sta, Len) ;Trim(, #LF$)
            ;                 
            ; ;                 If \Type = #PB_GadgetType_Button
            ; ;                   \Items()\Text\Width = TextWidth(RTrim(\Items()\Text\String.s))
            ; ;                 Else
            ; ;                   \Items()\Text\Width = TextWidth(\Items()\Text\String.s)
            ; ;                 EndIf
            ;                 
            ;                 \Items()\Focus =- 1
            ;                 \Items()\Index[1] =- 1
            ;                 \Items()\Color\State = 1 ; Set line default colors
            ;                 \Items()\Radius = \Radius
            ;                 \Items()\Index = ListIndex(\Items())
            ;                 
            ;                 ; Update line pos in the text
            ;                 ; _set_line_pos_(*this)
            ;                 \Items()\Text\Pos = \Text\Pos - Bool(\Text\MultiLine = 1)*\Items()\index ; wordwrap
            ;                 \Items()\Text\Len = Len                                                  ; (\Items()\Text\String.s)
            ;                 \Text\Pos + \Items()\Text\Len + 1                                        ; Len(#LF$)
            ;                 
            ;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\Text\Pos +" "+ \Items()\Text\Len
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
            If ExamineRegularExpression(0, \Text\String.s[2])
              While NextRegularExpressionMatch(0) : IT+1
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                If SelectElement(\Items(), IT-1)
                  If \Items()\Text\String.s <> String.s
                    \Items()\Text\String.s = String.s
                    
                    If \Type = #PB_GadgetType_Button
                      \Items()\Text\Width = TextWidth(RTrim(String.s))
                    Else
                      \Items()\Text\Width = TextWidth(String.s)
                    EndIf
                  EndIf
                  
                  ; Update line pos in the text
                  _set_line_pos_(*this)
                  
                  ; Resize item
                  If (Left And Not  Bool(\Scroll\X = Left))
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
        \Scroll\Height = 0
        _set_content_Y_(*this)
        
        ForEach \Items()
          If Not \Items()\Hide
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
    
    If Not *this\Hide
      
      With *this
        _S_widgettate = \color\state
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        
        ; Then changed text
        If \Text\Change
          ;           If set_text_width
          ;             SetTextWidth(set_text_width, Len(set_text_width))
          ;             set_text_width = ""
          ;           EndIf
          
          \Text\Height[1] = TextHeight("A") + Bool(\CountItems<>1 And \Flag\GridLines)
          If \Type = #PB_GadgetType_Tree
            \Text\Height = 20
          Else
            \Text\Height = \Text\Height[1]
          EndIf
          \Text\Width = TextWidth(\Text\String.s[1])
          
          If \margin\width 
            \CountItems = CountString(\Text\String.s[1], #LF$)
            \margin\width = TextWidth(Str(\CountItems))+11
            ;  Resizes(\Scroll, \x[2]+\margin\width+1,\Y[2],\Width[2]-\margin\width-1,\Height[2])
          EndIf
        EndIf
        
        ; Then resized widget
        If \Resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \root\Canvas_window, *this, #PB_EventType_Resize, \Resize)
          
          CompilerIf Defined(Bar, #PB_Module)
            ;  Resizes(\Scroll, \x[2]+\margin\width,\Y[2],\Width[2]-\margin\width,\Height[2])
            Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
            \scroll\width[2] = *this\Scroll\h\Page\len ; x(*this\Scroll\v)-*this\Scroll\h\x ; 
            \scroll\height[2] = *this\Scroll\v\Page\len; y(*this\Scroll\h)-*this\Scroll\v\y ;
          CompilerElse
            \scroll\width[2] = \width[2]
            \scroll\height[2] = \height[2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\X[2]
        iY=\Y[2]
        iWidth = \width[2] - (Bool(Not \Scroll\v\Hide) * \Scroll\v\width) ; - \margin\width
        iHeight = \height[2] - Bool(Not \Scroll\h\Hide) * \Scroll\h\height
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          Editor_MultiLine(*this)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \Text\Change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \Scroll\v And \Scroll\v\max <> \Scroll\Height And 
                 SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                
                \Scroll\v\page\step = \Text\Height
                
                If \Text\editable And (\Items()\y >= (\scroll\height[2]-\Items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
                EndIf
                
                Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\Scroll\h\Page\len ; x(*this\Scroll\v)-*this\Scroll\h\x ; 
                \scroll\height[2] = *this\Scroll\v\Page\len; y(*this\Scroll\h)-*this\Scroll\v\y ;
                
                If \Scroll\v\Hide 
                  \scroll\width[2] = \Width[2]
                  \Items()\Width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\Scroll\v\Hide +" "+ \Scroll\Height
                EndIf
              EndIf
              
              If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
                 SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
                Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *this\Scroll\h\Page\len ; x(*this\Scroll\v)-*this\Scroll\h\x ; 
                \scroll\height[2] = *this\Scroll\v\Page\len; y(*this\Scroll\h)-*this\Scroll\v\y ;
                                                           ;  \scroll\width[2] = \width[2] - Bool(Not \Scroll\v\Hide)*\Scroll\v\Width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \Keyboard\Input And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
                Debug ""+\Scroll\h\Max +" "+ Str(\Items()\text\x+\Items()\text\width)
                
                If \Scroll\h\Max = (\Items()\text\x+\Items()\text\width)
                  SetState(\Scroll\h, \Scroll\h\Max)
                Else
                  SetState(\Scroll\h, \Scroll\h\Page\Pos + TextWidth(Chr(\Keyboard\Input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        
        ;
        If \Text\Editable And ListSize(\Items())
          If \Text\Change =- 1
            \Text[1]\Change = 1
            \Text[3]\Change = 1
            \Text\Len = Len(\Text\String.s[1])
            Editor_Change(*this, \Text\Caret, 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \root\Canvas_window, *this, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \Items()\Text[1]\Change : \Items()\Text[1]\Change = #False
            \Items()\Text[1]\Width = TextWidth(\Items()\Text[1]\String.s)
            
            ; demo
            ;             Protected caret1, caret = \Text\Caret[2]
            
            ; Положение карета
            If \Text\Caret[1] = \Text\Caret
              \Text\Caret[2] = \Items()\Text[1]\Width
              ;               caret1 = \Text\Caret[2]
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \Text\Caret[2] = 0
            ElseIf \index[1] = ListSize(\Items())
              \Text\Caret[2] = \Items()\Text\Width
            ElseIf \Items()\Text\Len = \Items()\Text[2]\Len
              \Text\Caret[2] = \Items()\Text\Width
            EndIf
            
            ;             If Caret<>\Text\Caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \Text\Caret[2] +" "+\index[1] +" "+\index[2]
            ;               caret = \Text\Caret[2]
            ;             EndIf
            
          EndIf
          
          If \Items()\Text[2]\Change : \Items()\Text[2]\Change = #False 
            \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text[1]\Width
            \Items()\Text[2]\Width = TextWidth(\Items()\Text[2]\String.s) ; + Bool(\Items()\Text[2]\Len =- 1) * \Flag\FullSelection ; TextWidth() - bug in mac os
            
            \Items()\Text[3]\X = \Items()\Text[2]\X+\Items()\Text[2]\Width
          EndIf 
          
          If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
            \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
          EndIf 
          
          If (\Focus And \Mouse\Buttons And (Not \Scroll\v\at And Not \Scroll\h\at)) 
            Protected Left = Editor_Move(*this, \Items()\Width)
          EndIf
        EndIf
        
        ; Draw back color
        If \Color\Fore[_S_widgettate]
          DrawingMode(#PB_2DDrawing_Gradient)
          boxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[_S_widgettate],\Color\Back[_S_widgettate],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[_S_widgettate])
        EndIf
        
        ; Draw margin back color
        If \margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \margin\width, \Height[2], \margin\Color\Back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *this\Items()
        If ListSize(*this\Items())
          PushListPosition(*this\Items())
          ForEach *this\Items()
            Protected Item_state = \state
            
            ; Is visible lines ---
            Drawing = Bool(Not \hide And (\y+\height+*this\Scroll\Y>*this\y[2] And (\y-*this\y[2])+*this\Scroll\Y<iheight))
            
            \Drawing = Drawing
            
            If Drawing
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
                ;               ElseIf *this\Text\FontID 
                ;                 DrawingFont(*this\Text\FontID) 
              EndIf
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *this\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                ; Debug "get caret "+\Text[3]\Len
                \Text[2]\Width = TextWidth(\Text[2]\String.s) + Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *this\Flag\FullSelection ; TextWidth() - bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
            EndIf
            
            
            Height = \Height
            Y = \Y+*this\Scroll\Y
            Text_X = \Text\X+*this\Scroll\X
            Text_Y = \Text\Y+*this\Scroll\Y
            ; Debug Text_X
            
            ; Draw selections
            If Drawing And (\Index=*this\Index[1] Or \Index=\Index[1]) ; Or \Index=\focus Item_state;
              If *this\Color\Back[Item_state]<>-1                      ; no draw transparent
                If *this\Color\Fore[Item_state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  boxGradient(\Vertical,*this\X[2],Y,iwidth,\Height,*this\Color\Fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24, *this\Color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24) ;*this\Color\Fore[Item_state]&$FFFFFFFF|*this\color\alpha<<24 ,RowBackColor(*this, Item_state) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*this\X[2],Y,iwidth,\Height,\Radius,\Radius,*this\Color\back[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
                EndIf
              EndIf
              
              If *this\Color\Frame[Item_state]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\x[2],Y,iwidth,\height,\Radius,\Radius, *this\Color\Frame[Item_state]&$FFFFFFFF|*this\color\alpha<<24 )
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
              ;               If *this\flag\FullSelection
              ;                 If State_3 = 1
              ;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+1+*this\Scroll\h\Page\Pos,\y+1,\width-2,\height-2, *this\Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                   
              ;                   DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                   box(\x+*this\Scroll\h\Page\Pos,\y,\width,\height, *this\Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
              ;                 EndIf
              ;                 
              ;                 If State_3 = 2
              ;                   If *this\Focus : item_alpha = 200
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\Scroll\h\Page\Pos,\y+1,\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\Scroll\h\Page\Pos,\y,\width,\height, $DC9338&back_color|item_alpha<<24)
              ;                   Else
              ;                     ;If \flag\AlwaysSelection
              ;                     DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+1+*this\Scroll\h\Page\Pos,\y+1,\width-2,\height-2, $E2E2E2&back_color|item_alpha<<24)
              ;                     
              ;                     DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              ;                     box(\x+*this\Scroll\h\Page\Pos,\y,\width,\height, $C8C8C8&back_color|item_alpha<<24)
              ;                     ;EndIf
              ;                   EndIf
              ;                 EndIf
              ;                 
              ;               EndIf
              
              ; Draw text
              Angle = Bool(\Text\Vertical)**this\Text\Rotate
              Protected Front_BackColor_1 = *this\Color\Front[_S_widgettate]&$FFFFFFFF|*this\color\alpha<<24
              Protected Front_BackColor_2 = *this\Color\Front[2]&$FFFFFFFF|*this\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len And *this\Color\Front <> *this\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*this\Text\Caret[1] > *this\Text\Caret And *this\Index[2] = *this\Index[1]) Or
                     (\Index = *this\Index[1] And *this\Index[2] > *this\Index[1])
                    \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *this\Text\Caret[1])) 
                    
                    If *this\Index[2] = *this\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[3]\X+*this\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *this\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      boxGradient(\Vertical,\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,*this\Color\Fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24 )
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \Text\String.s, angle, Front_BackColor_1)
                    
                    If *this\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      boxGradient(\Vertical,\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,*this\Color\Fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[2]\X+*this\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *this\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    boxGradient(\Vertical,\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,*this\Color\Fore[2]&$FFFFFFFF|*this\color\alpha<<24,*this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24,\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*this\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*this\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*this\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *this\Color\back[2]&$FFFFFFFF|*this\color\alpha<<24)
                EndIf
                
                If Item_state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *this\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(ix+*this\margin\width-TextWidth(Str(\Index))-3, \Y+*this\Scroll\Y, Str(\Index), *this\margin\Color\Front);, *this\margin\Color\Back)
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
        If ListSize(\Items()) And (\Text\Editable Or \Items()\Text\Editable) And \Focus : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\Text\X+\Scroll\X) + \Text\Caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \Scroll\X), \Items()\Y+\Scroll\Y, 1, Height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
          ;              SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
          ;             Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
          ;              SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
          ;             Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Draw(\Scroll\v)
          Draw(\Scroll\h)
          ; (_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*this\Scroll\h\x-GetState(*this\Scroll\h), *this\Scroll\v\y-GetState(*this\Scroll\v), *this\Scroll\h\Max, *this\Scroll\v\Max, $FF0000)
          Box(*this\Scroll\h\x, *this\Scroll\v\y, *this\Scroll\h\Page\Len, *this\Scroll\v\Page\Len, $FF00FF00)
          Box(*this\Scroll\h\x, *this\Scroll\v\y, *this\Scroll\h\Area\Len, *this\Scroll\v\Area\Len, $FF00FFFF)
        CompilerEndIf
      EndWith
      
      ; Draw frames
      With *this
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
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
        ;If (\Items()\y+\Scroll\Y =< \Y[2])
        SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
          SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
        Else
          SetState(\Scroll\h, 0)
        EndIf
        ;Editor_Change(*this, \Text\Caret, 0)
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
          Editor_Change(*this, \Text\Caret[1], \Items()\Text\Len-\Text\Caret[1])
        Else
          SelectElement(\Items(), \Index[2]) 
          Editor_Change(*this, 0, \Items()\Text\Len)
        EndIf
        ; Debug \Text\Caret[1]
        \Index[2] + 1
        ;         \Text\Caret = Editor_Caret(*this, \Index[2]) 
        ;         \Text\Caret[1] = \Text\Caret
        SelectElement(\Items(), \Index[2]) 
        Editor_Change(*this, 0, \Text\Caret[1]) 
        Editor_SelText(*this)
        Repaint = 1 
        
      Else
        If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[2]) 
          ;If (\Items()\y >= (\scroll\height[2]-\Items()\height))
          SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
          ;EndIf
          
          If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
            SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
          Else
            SetState(\Scroll\h, 0)
          EndIf
          
          ;Editor_Change(*this, \Text\Caret, 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToLeft(*this._S_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\Keyboard\Key[1] & #PB_Canvas_Shift)
    
    With *this
      If \Items()\Text[2]\Len And Not Shift
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*this)
          \Index[1] = \Index[2]
        Else
          \Text\Caret[1] = \Text\Caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \Text\Caret > 0
        If \Text\Caret > \Items()\text\len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку 
          \Text\Caret = \Items()\text\len - CountString(\Items()\Text\String.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \Text\Caret - 1 
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf Editor_ToUp(*this._S_widget)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
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
      ;           \Text\Caret + 1
      ;           Swap \Index[2], \Index[1] 
      ;         Else
      ;           If \Index[1] > \Index[2] 
      ;             Swap \Index[1], \Index[2] 
      ;             Swap \Text\Caret, \Text\Caret[1]
      ;             
      ;             If SelectElement(\Items(), \Index[2]) 
      ;               \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
      ;               \Items()\Text[1]\Change = #True
      ;             EndIf
      ;             
      ;             Editor_SelReset(*this)
      ;             \Text\Caret = \Text\Caret[1] 
      ;             \Index[1] = \Index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \Items()\Text[2]\Len
      ;         If \Text\Caret[1] > \Text\Caret 
      ;           Swap \Text\Caret[1], \Text\Caret 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \Text\Caret[1] = \Text\Caret 
      ;         Else
      ;           \Text\Caret + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \Items()\Text[2]\Len And Not Shift
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
          
          ;           Editor_SelReset(*this)
          ;           \Text\Caret = \Text\Caret[1] 
          ;           \Index[1] = \Index[2]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*this)
          \Index[1] = \Index[2]
        Else
          \Text\Caret = \Text\Caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \Text\Caret < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку
        \Text\Caret + 1
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
      ElseIf Editor_ToDown(*this)
        \Text\Caret = 0
        \Text\Caret[1] = \Text\Caret
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
        ;           \Default = *this
        ;         EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToReturn(*this._S_widget) ; Ok
    
    With  *this
      If Not Editor_Paste(*this, #LF$)
        \Index[2] + 1
        \Text\Caret = 0
        \Index[1] = \Index[2]
        \Text\Caret[1] = \Text\Caret
        \Text\Change =- 1 ; - 1 post event change widget
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
        If \Items()\Text[2]\Len
          
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 : \Text\Caret - 1 
          \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret)
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s) : \Items()\Text[1]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Pos+\Text\Caret) + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            Editor_ToUp(*this)
            
            \Text\Caret = \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToDelete(*this._S_widget)
    Protected Repaint, String.s
    
    With *this 
      If Not Editor_Cut(*this)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          \Items()\Text[3]\Len = Len(\Items()\Text[3]\String.s) : \Items()\Text[3]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text[3]\String = Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text[3]\len = Len(\Text[3]\String.s)
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\CountItems-1) ; ListSize(\Items()) - 1
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
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
          Case 1 : FirstElement(\items()) : \Text\Caret = 0
          Case - 1 : LastElement(\items()) : \Text\Caret = \items()\Text\Len
        EndSelect
        
        \index[1] = \items()\index
        SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \Text\Caret = Bool(Pos =- 1) * \items()\Text\Len 
        SetState(\Scroll\h, Bool(Pos =- 1) * \Scroll\h\Max)
      EndIf
      
      \Text\Caret[1] = \Text\Caret
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
                                 ;           If \items()\Text\Numeric
                                 ;             \items()\Text\String.s[3]=\items()\Text\String.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Keyboard\Key
            Case #PB_Shortcut_Home : Repaint = Editor_ToPos(*this, 1, Control)
            Case #PB_Shortcut_End : Repaint = Editor_ToPos(*this, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = Editor_ToPos(*this, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = Editor_ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\Text[2]\Len <> \Text\Len Or Not \Text[2]\Len)
                ForEach \items()
                  \Items()\Text[2]\Len = \Items()\Text\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                  \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                  \Items()\Text[1]\String = "" : \Items()\Text[1]\Change = 1 : \Items()\Text[1]\Len = 0
                  \Items()\Text[3]\String = "" : \Items()\Text[3]\Change = 1 : \Items()\Text[3]\Len = 0
                Next
                
                \Text[1]\Len = 0 : \Text[1]\String = ""
                \Text[3]\Len = 0 : \Text[3]\String = #LF$
                \index[2] = 0 : \index[1] = ListSize(\Items()) - 1
                \Text\Caret = \Items()\Text\Len : \Text\Caret[1] = \Text\Caret
                \Text[2]\String = \Text\String : \Text[2]\Len = \Text\Len
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
                SetClipboardText(\Text[2]\String)
                
                If \Keyboard\Key = #PB_Shortcut_X
                  Repaint = Editor_Cut(*this)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And Control
                Repaint = Editor_Insert(*this, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \Text\Caret<\Text\Caret[1]
          ; Debug \Text\Caret[1]-\Text\Caret
          Editor_Change(*this, \Text\Caret, \Text\Caret[1]-\Text\Caret)
        Else
          ; Debug \Text\Caret-\Text\Caret[1]
          Editor_Change(*this, \Text\Caret[1], \Text\Caret-\Text\Caret[1])
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
            \Text\Caret = 0
          Else
            \Text\Caret = \Items()\Text\Len
          EndIf
          
          Repaint | Editor_SelText(*this)
        EndIf
        
        \Index[1] = Line
      EndIf
      
      If isItem(Line, \Items()) 
        \Text\Caret = Editor_Caret(*this, Line) 
        Repaint | Editor_SelText(*this)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\Items()) 
      ForEach \Items()
        If (\Index[1] = \Items()\Index Or \Index[2] = \Items()\Index)
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
          
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String = \Items()\Text\String 
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \Items()\Text[2]\Len
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String =  "" 
          \Items()\Text[2]\Len = 0 
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
          If Not \Hide ;And Not \Disable And \Interact
                       ; Get line position
            If \Mouse\buttons
              If \Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Mouse\Y-\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \Items()\Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Editor_SelLimits(*this)     ; Выделяем слово
                Editor_SelText(*this)
                
                ;                 \Items()\Text[2]\Change = 1
                ;                 \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                itemSelect(Item, \Items())
                Caret = Editor_Caret(*this, Item)
                
                If \Items()\Text\Caret[1] =- 1 : \Items()\Text\Caret[1] = 0
                  *this\Text\Caret[1] = 0
                  *this\Text\Caret = \Items()\Text\Len
                  Editor_SelText(*this)
                  Repaint = 1
                  
                Else
                  Editor_SelReset(*this)
                  
                  If \Items()\Text[2]\Len
                    
                    
                    
                  Else
                    
                    \Text\Caret = Caret
                    \Text\Caret[1] = \Text\Caret
                    \Index[1] = \Items()\Index 
                    \Index[2] = \Index[1]
                    
                    PushListPosition(\Items())
                    ForEach \Items() 
                      If \Index[2] <> ListIndex(\Items())
                        \Items()\Text[1]\String = ""
                        \Items()\Text[2]\String = ""
                        \Items()\Text[3]\String = ""
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    If \Text\Caret = DoubleClick
                      DoubleClick =- 1
                      \Text\Caret[1] = \Items()\Text\Len
                      \Text\Caret = 0
                    EndIf 
                    
                    Editor_SelText(*this)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \Mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = Editor_SelSet(*this, Item)
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If \Focus And (*this\Text\Editable Or \Text\Editable)
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
            \Keyboard\Input = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Input)
            \Keyboard\Key[1] = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \Keyboard\Key = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Key)
            \Keyboard\Key[1] = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Mouse\X = GetGadgetAttribute(\root\Canvas, #PB_Canvas_MouseX)
            \Mouse\Y = GetGadgetAttribute(\root\Canvas, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            \focus = 1
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \Mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                               (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                               (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \Mouse\buttons = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Buttons)
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
      If \Color\Back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      EndIf
      
      ;       If \Text\Change : \Text\Change = #False
      ;         \Text\Width = TextWidth(\Text\String.s) 
      ;         
      ;         If \Text\FontID 
      ;           \Text\Height = TextHeight("A") 
      ;         Else
      ;           \Text\Height = *this\Text\Height[1]
      ;         EndIf
      ;       EndIf 
      
      If \Text[1]\Change : \Text[1]\Change = #False
        \Text[1]\Width = TextWidth(\Text[1]\String.s) 
      EndIf 
      
      If \Text[3]\Change : \Text[3]\Change = #False 
        \Text[3]\Width = TextWidth(\Text[3]\String.s)
      EndIf 
      
      If \Text[2]\Change : \Text[2]\Change = #False 
        \Text[2]\X = \Text\X+\Text[1]\Width
        ; Debug "get caret "+\Text[3]\Len
        \Text[2]\Width = TextWidth(\Text[2]\String.s) ;+ Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *this\Flag\FullSelection ; TextWidth() - bug in mac os
        \Text[3]\X = \Text[2]\X+\Text[2]\Width
      EndIf 
      
      Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
      Protected angle.f
      
      
      Height = \Text\Height
      Y = \Text\Y
      Text_X = \Text\X
      Text_Y = \Text\Y
      Angle = Bool(\Text\Vertical) * *this\Text\Rotate
      Protected Front_BackColor_1 = *this\Color\Front[*this\Color\State]&$FFFFFF|*this\color\alpha<<24
      Protected Front_BackColor_2 = *this\Color\Front[2]&$FFFFFF|*this\color\alpha<<24 
      
      ; Draw string
      If \Text[2]\Len And *this\Color\Front <> *this\Color\Front[2]
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          If (*this\Text\Caret[1] > *this\Text\Caret And *this\index[2] = *this\index[1]) Or
             (\index = *this\index[1] And *this\index[2] > *this\index[1])
            \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *this\Text\Caret[1])) 
            
            If *this\index[2] = *this\index[1]
              \Text[2]\X = \Text[3]\X-\Text[2]\Width
            EndIf
            
            If \Text[3]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
            EndIf
            
            If *this\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              boxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24 )
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
            
            If \Text[1]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(Text_X, Text_Y, \Text\String.s, angle, Front_BackColor_1)
            
            If *this\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              boxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
          EndIf
        CompilerElse
          If \Text[1]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
          EndIf
          
          If *this\Color\Fore[2]
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            boxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \Text[2]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
          EndIf
          
          If \Text[3]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
          EndIf
        CompilerEndIf
        
      Else
        If \Text[2]\Len
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \Color\State = 2
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
        Else
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
        EndIf
      EndIf
      
      ; Draw caret
      If \Text\Editable And \Focus : DrawingMode(#PB_2DDrawing_XOr)   
        Line(\Text\X + \Text[1]\Width + Bool(\Text\Caret[1] > \Text\Caret) * \Text[2]\Width - Bool(#PB_Compiler_OS = #PB_OS_Windows), \Text\y, 1, \Text\Height, $FFFFFFFF)
      EndIf
      
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Window(*this._S_widget)
    With *this 
      Protected sx,sw,x = \x
      Protected px=2,py
      Protected start, stop
      
      Protected State_3 = \Color\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw caption frame
      If \box\Color\back[State_3]<>-1
        If \box\Color\Fore[\Focus*2]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \box\x, \box\y, \box\width, \box\height, \box\Color\Fore[\Focus*2], \box\Color\Back[\Focus*2], \Radius, \box\color\alpha)
      EndIf
      
      ; Draw image
      If \image\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\ImageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[\Focus*2]&$FFFFFF|Alpha)
      EndIf
      Protected Radius = 4
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], Radius, Radius, $FF0000FF&$FFFFFF|\color[1]\alpha<<24)
      RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], Radius, Radius, $FFFF0000&$FFFFFF|\color[2]\alpha<<24)
      RoundBox( \box\x[3], \box\y[3], \box\width[3], \box\height[3], Radius, Radius, $FF00FF00&$FFFFFF|\color[3]\alpha<<24)
      
      ; Draw caption frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y+\bs-\fs, \Width[1], \TabHeight+\fs, \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \Color\back[State_3]<>-1
        If \Color\Fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore, \Color\Back, \Radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \Color\Frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Frame[State_3]&$FFFFFF|Alpha)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Scroll(*this._S_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \box\x[2]
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \box\y[2]
      ;Debug \width
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        ; Roundbox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \Color\Line[State_0]<>-1
        If \Vertical
          Line( \X, \Y, 1, \Page\len + Bool(\height<>\Page\len), \Color\Line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \X, \Y, \Page\len + Bool(\width<>\Page\len), 1, \Color\Line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \Thumb\len 
        ; Draw thumb  
        If \Color[3]\back[State_3]<>-1
          If \Color[3]\Fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[3], \box\y[3], \box\Width[3], \box\Height[3], \Color[3]\Fore[State_3], \Color[3]\Back[State_3], \Radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \Color[3]\Frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[3], \box\y[3], \box\Width[3], \box\Height[3], \Radius, \Radius, \Color[3]\Frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \box\Size[1]
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], \Radius, \Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[1]+( \box\Width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\Height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool( \Vertical),
               (Bool(Not _scroll_in_start_(*this)) * \Color[1]\Front[State_1] + _scroll_in_start_(*this) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
      EndIf
      
      If \box\Size[2]
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], \Radius, \Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[2]+( \box\Width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\Height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool( \Vertical)+2, 
               (Bool(Not _scroll_in_stop_(*this)) * \Color[2]\Front[State_2] + _scroll_in_stop_(*this) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
      EndIf
      
      If \Thumb\len And \Color[3]\Fore[State_3]<>-1  ; Draw thumb lines
        If \Focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \box\arrow_size[2]+3
        
        If \Vertical
          Line( \box\x[3]+(\box\Width[3]-(size-1))/2, \box\y[3]+\box\Height[3]/2-3,size,1, LinesColor)
          Line( \box\x[3]+(\box\Width[3]-(size-1))/2, \box\y[3]+\box\Height[3]/2,size,1, LinesColor)
          Line( \box\x[3]+(\box\Width[3]-(size-1))/2, \box\y[3]+\box\Height[3]/2+3,size,1, LinesColor)
        Else
          Line( \box\x[3]+\box\Width[3]/2-3, \box\y[3]+(\box\Height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\Width[3]/2, \box\y[3]+(\box\Height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\Width[3]/2+3, \box\y[3]+(\box\Height[3]-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*this._S_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String, \Color\Front[State_3]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*this._S_widget)
      
      If \box\Size[2]
        Protected Radius = \height[2]/7
        If Radius > 4
          Radius = 7
        EndIf
        
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], Radius, Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], Radius, Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[1]+( \box\Width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\Height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool(\Vertical)*3,
               (Bool(Not _scroll_in_start_(*this)) * \Color[1]\Front[State_1] + _scroll_in_start_(*this) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
        
        ; Draw arrows
        Arrow( \box\x[2]+( \box\Width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\Height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool(Not \Vertical)+1, 
               (Bool(Not _scroll_in_stop_(*this)) * \Color[2]\Front[State_2] + _scroll_in_stop_(*this) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
        
        
        Line(\box\x[1]-2, \y[2],1,\height[2], \Color\Frame&$FFFFFF|Alpha)
      EndIf      
    EndWith
  EndProcedure
  
  Procedure.i Draw_ScrollArea(*this._S_widget)
    With *this 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \Scroll And (\Scroll\v And \Scroll\h)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\Scroll\h\x-GetState(\Scroll\h), \Scroll\v\y-GetState(\Scroll\v), \Scroll\h\Max, \Scroll\v\Max, $FFFF0000)
        Box(\Scroll\h\x, \Scroll\v\y, \Scroll\h\Page\Len, \Scroll\v\Page\Len, $FF00FF00)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Container(*this._S_widget)
    With *this 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Frame(*this._S_widget)
    With *this 
      If \Text\String.s
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ;       ; Draw background image
      ;       If \image[1]\ImageID
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      ;       EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \TabHeight/2
        Box(\x[1], \y+h, 6, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\Text\x+\Text\width+3, \y+h, \width[1]-((\Text\x+\Text\width)-\x)-3, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[1], \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1]+\width[1]-\fs, \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1], \Y[1]+\height[1]-\fs, \width[1], \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Panel(*this._S_widget)
    Protected State_3.i, Alpha.i, Color_Frame.i
    
    With *this 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \x
      Protected start, stop
      
      Protected clip_x = \clip\x+\box\Size[1]+3
      Protected clip_width = \clip\width-\box\Size[1]-\box\Size[2]-6
      
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      If \width[2]>(\box\width[1]+\box\width[2]+4)
        ClipOutput(clip_x, \clip\y, clip_width, \clip\height)
        
        ForEach \items()
          If \index[2] = \items()\index
            State_3 = 2
            \items()\y = \y+2
            \items()\Height=\TabHeight-1
          Else
            State_3 = \items()\State
            \items()\y = \y+4
            \items()\Height=\TabHeight-4-1
          EndIf
          Color_Frame = \Color\Frame[State_3]&$FFFFFF|Alpha
          
          \items()\image\x[1] = 8 ; Bool(\items()\image\width) * 4
          
          If \items()\Text\Change
            \items()\Text\width = TextWidth(\items()\Text\String)
            \items()\Text\height = TextHeight("A")
          EndIf
          
          \items()\x = 2+x-\Page\Pos+\box\Size[1]+1
          \items()\width = \items()\Text\width + \items()\image\x[1]*2 + \items()\image\width + Bool(\items()\image\width) * 3
          x + \items()\width + 1
          
          \items()\image\x = \items()\x+\items()\image\x[1] - 1
          \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
          
          \items()\Text\x = \items()\image\x + \items()\image\width + Bool(\items()\image\width) * 3
          \items()\Text\y = \items()\y+(\items()\height-\items()\Text\height)/2
          
          \items()\Drawing = Bool(Not \items()\hide And \items()\x+\items()\width>\x+\bs And \items()\x<\x+\width-\bs)
          
          If \items()\Drawing
            ; Draw thumb  
            If \Color\back[State_3]<>-1
              If \Color\Fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              boxGradient( \Vertical, \items()\X, \items()\Y, \items()\Width, \items()\Height, \Color\Fore[State_3], Bool(State_3 <> 2)*\Color\Back[State_3] + (Bool(State_3 = 2)*\Color\Front[State_3]), \Radius, \color\alpha)
            EndIf
            
            ; Draw string
            If \items()\Text\String
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\items()\Text\x, \items()\Text\y, \items()\Text\String.s, \Color\Front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \items()\image\imageID
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, \color\alpha)
            EndIf
            
            ; Draw thumb frame
            If \Color\Frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\items()\X, \items()\Y, \items()\Width, 1, Color_Frame)                     ; top
                Line(\items()\X, \items()\Y, 1, \items()\Height, Color_Frame)                    ; left
                Line((\items()\X+\items()\width)-1, \items()\Y, 1, \items()\Height, Color_Frame) ; right
              Else
                RoundBox( \items()\X, \items()\Y, \items()\Width, \items()\Height, \Radius, \Radius, Color_Frame)
              EndIf
            EndIf
          EndIf
          
          \items()\Text\Change = 0
          
          If State_3 = 2
            sx = \items()\x
            sw = \items()\width
            start = Bool(\items()\x=<\x[2]+\box\Size[1]+1 And \items()\x+\items()\width>=\x[2]+\box\Size[1]+1)*2
            stop = Bool(\items()\x=<\x[2]+\width[2]-\box\Size[2]-2 And \items()\x+\items()\width>=\x[2]+\width[2]-\box\Size[2]-2)*2
          EndIf
          
        Next
        
        ClipOutput(\clip\x, \clip\y, \clip\width, \clip\height)
        
        If ListSize(\items())
          Protected Value = \box\Size[1]+((\items()\x+\items()\width+\Page\Pos)-\x[2])
          
          If \Max <> Value : \Max = Value
            \Area\Pos = \X[2]+\box\Size[1]
            \Area\len = \width[2]-(\box\Size[1]+\box\Size[2])
            \Thumb\len = ThumbLength(*this)
            ;\page\step = 10;\Thumb\len
            
            If \Change > 0 And SelectElement(\Items(), \Change-1)
              Protected State = (\box\Size[1]+((\items()\x+\items()\width+\Page\Pos)-\x[2]))-\Page\Len ;
                                                                                                       ;               Debug (\box\Size[1]+(\items()\x+\items()\width)-\x[2])-\Page\len
                                                                                                       ;               Debug State
              If State < \Min : State = \Min : EndIf
              If State > \Max-\Page\len
                If \Max > \Page\len 
                  State = \Max-\Page\len
                Else
                  State = \Min 
                EndIf
              EndIf
              
              \Page\Pos = State
            EndIf
          EndIf
        EndIf
        
        ; Линии на концах для красоты
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        If Not _scroll_in_start_(*this)
          Line(\box\x[1]+\box\width[1]+1, \box\y[1], 1, \TabHeight-5+start, \Color\Frame[start]&$FFFFFF|Alpha)
        EndIf
        If Not _scroll_in_stop_(*this)
          Line(\box\x[2]-2, \box\y[1], 1, \TabHeight-5+stop, \Color\Frame[stop]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Line(\X[2], \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\Area\Pos, \Y+\TabHeight, sx-\Area\Pos, 1, \Color\Frame&$FFFFFF|Alpha)
        Line(sx+sw, \Y+\TabHeight, \width-((sx+sw)-\x), 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\box\x[2]-2, \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\X, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X+\width-1, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X, \Y+\height-1, \width, 1, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
    EndWith
    
    With *this
      If \box\Size[1] Or \box\Size[2]
        ; Draw buttons
        
        If \Color[1]\State 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], \Radius, \Radius, \box\Color[1]\Back[\Color[1]\State]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[1], \box\y[1], \box\Width[1], \box\Height[1], \Radius, \Radius, \box\Color[1]\Frame[\Color[1]\State]&$FFFFFF|Alpha)
        EndIf
        
        If \Color[2]\State 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], \Radius, \Radius, \box\Color[2]\Back[\Color[2]\State]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[2], \box\y[2], \box\Width[2], \box\Height[2], \Radius, \Radius, \box\Color[2]\Frame[\Color[2]\State]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Arrow( \box\x[1]+( \box\Width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\Height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool( \Vertical),
               (Bool(Not _scroll_in_start_(*this)) * \box\Color[1]\Front[\Color[1]\State] + _scroll_in_start_(*this) * \box\Color[1]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
        
        Arrow( \box\x[2]+( \box\Width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\Height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool( \Vertical)+2, 
               (Bool(Not _scroll_in_stop_(*this)) * \box\Color[2]\Front[\Color[2]\State] + _scroll_in_stop_(*this) * \box\Color[2]\Frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Progress(*this._S_widget)
    With *this 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\y,\Width-4,\Thumb\Pos, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X+2,\y+2,\Width-4,\Thumb\Pos-2, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,(\height-\Thumb\Pos), \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x)-2,\height-4, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),0)
        
        ;Debug ""+\x+" "+\Thumb\Pos
      EndIf
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X+1, \Y+1, \Width-2, \Height-2, \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color[3]\Frame)
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
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          X = \X
          Y = \Y
          Width = \Width 
          Height = \Height
          
          ; Позиция сплиттера 
          Size = \Thumb\len
          
          If \Vertical
            Pos = \Thumb\Pos-y
          Else
            Pos = \Thumb\Pos-x
          EndIf
          
          
          ; set vertical bar state
          If \Scroll\v\Max And \Change > 0
            If (\Change*\Text\height-\Scroll\h\Page\len) > \Scroll\h\Max
              \Scroll\h\Page\Pos = (\Change*\Text\height-\Scroll\h\Page\len)
            EndIf
          EndIf
          
          \Scroll\Width=0
          \Scroll\height=0
          
          ForEach \items()
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\Scroll\h\Page\len
              \items()\x=\Scroll\h\x-\Scroll\h\Page\Pos
              \items()\y=(\Scroll\v\y+\Scroll\height)-\Scroll\v\Page\Pos
              
              If \items()\text\change = 1
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
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
              
              If \flag\Checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = box_1_size
                \items()\box\height[1] = box_1_size
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \Scroll\height+\items()\height
              
              If \Scroll\Width < (\items()\text\x-\x+\items()\text\width)+\Scroll\h\Page\Pos
                \Scroll\Width = (\items()\text\x-\x+\items()\text\width)+\Scroll\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; Задаем размеры скролл баров
          If \Scroll\v And \Scroll\v\Page\Len And \Scroll\v\Max<>\Scroll\height And 
             Widget::SetAttribute(\Scroll\v, #PB_Bar_Maximum, \Scroll\height)
            Widget::Resizes(\Scroll, \x-\Scroll\h\x+1, \y-\Scroll\v\y+1, #PB_Ignore, #PB_Ignore)
            \Scroll\v\page\step = \Text\height
          EndIf
          
          If \Scroll\h And \Scroll\h\Page\Len And \Scroll\h\Max<>\Scroll\Width And 
             Widget::SetAttribute(\Scroll\h, #PB_Bar_Maximum, \Scroll\Width)
            Widget::Resizes(\Scroll, \x-\Scroll\h\x+1, \y-\Scroll\v\y+1, #PB_Ignore, #PB_Ignore)
          EndIf
          
          
          
          ForEach \items()
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            If \items()\Drawing
              \items()\width = \Scroll\h\Page\len
              State_3 = \items()\State
              
              ; Draw selections
              If Not \items()\Childrens And \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
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
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\Scroll\v\Page\Pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\Checkboxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\clip\x,\clip\y,\clip\width-(\width-(\Thumb\Pos-\x)),\clip\height)
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x+(\Thumb\Pos-\x),\clip\y,\clip\width-(\Thumb\Pos-\x),\clip\height)
              
              ;\items()\text[1]\x[1] = 5
              \items()\text[1]\x = \x+\items()\text[1]\x[1]+\Thumb\len
              \items()\text[1]\y = \items()\text\y
              ; Draw string
              If \items()\text[1]\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text[1]\x+pos, \items()\text[1]\y, \items()\text[1]\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
          ; Draw Splitter
          DrawingMode(#PB_2DDrawing_Outlined) 
          Line((X+Pos)+Size/2,Y,1,Height, \Color\Frame)
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
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          ; set vertical bar state
          If \Scroll And \Scroll\v\Max And \Change > 0
            \Scroll\v\Max = \Scroll\height
            ; \Scroll\v\Max = \CountItems*\Text\height
            ; Debug ""+Str(\Change*\Text\height-\Scroll\v\Page\len+\Scroll\v\Thumb\len) +" "+ \Scroll\v\Max
            If (\Change*\Text\height-\Scroll\v\Page\len) <> \Scroll\v\Page\Pos  ;> \Scroll\v\Max
                                                                                ; \Scroll\v\Page\Pos = (\Change*\Text\height-\Scroll\v\Page\len)
              SetState(\Scroll\v, (\Change*\Text\height-\Scroll\v\Page\len))
              Debug ""+\Scroll\v\Page\Pos+" "+Str(\Change*\Text\height-\Scroll\v\Page\len)  +" "+\Scroll\v\Max                                               
              
            EndIf
          EndIf
          
          If \Scroll
            \Scroll\Width=0
            \Scroll\height=0
          EndIf
          
          ; Resize items
          ForEach \items()
            ;\items()\height = 20
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;               \Scroll\Width=0
            ;               \Scroll\height=0
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\Scroll\h\Page\len
              \items()\x=\Scroll\h\x-\Scroll\h\Page\Pos
              \items()\y=(\Scroll\v\y+\Scroll\height)-\Scroll\v\Page\Pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = \flag\Buttons
              \items()\box\height = \flag\Buttons
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
              
              If \flag\Checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = \flag\Checkboxes
                \items()\box\height[1] = \flag\Checkboxes
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \Scroll\height+\items()\height
              
              If \Scroll\Width < (\items()\text\x-\x+\items()\text\width)+\Scroll\h\Page\Pos
                \Scroll\Width = (\items()\text\x-\x+\items()\text\width)+\Scroll\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; set vertical scrollbar max value
          If \Scroll\v And \Scroll\v\Page\Len And \Scroll\v\Max<>\Scroll\height And 
             Widget::SetAttribute(\Scroll\v, #PB_Bar_Maximum, \Scroll\height) : \Scroll\v\page\step = \Text\height
            Widget::Resizes(\Scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \Scroll\h And \Scroll\h\Page\Len And \Scroll\h\Max<>\Scroll\Width And 
             Widget::SetAttribute(\Scroll\h, #PB_Bar_Maximum, \Scroll\Width)
            Widget::Resizes(\Scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; Draw items
          ForEach \items()
            
            
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            
            If \items()\Drawing
              \items()\width=\Scroll\h\Page\len
              If Bool(\items()\index = \index[2])
                State_3 = 2
              Else
                State_3 = Bool(\items()\index = \index[1])
              EndIf
              
              ; Draw selections
              If \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\Scroll\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\Scroll\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
                
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,\Flag\Lines,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\i_Parent 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\Scroll\v\Page\Pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-\Flag\Lines
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\Checkboxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
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
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
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
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked = #PB_Checkbox_Checked
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        For i = 0 To 2
          LineXY((\box\X+3),(i+\box\Y+8),(\box\X+7),(i+\box\Y+9), \Color\Frame[\Focus*2]&$FFFFFF|Alpha) 
          LineXY((\box\X+10+i),(\box\Y+3),(\box\X+6+i),(\box\Y+10), \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
        Next
      ElseIf \box\Checked = #PB_Checkbox_Inbetween
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \box\x+2,\box\y+2,\box\width-4,\box\height-4, \Radius-2, \Radius-2, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
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
      RoundBox( \box\x,\box\y,\box\width,\box\width, Radius, Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(\box\x+Radius,\box\y+Radius, Radius, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked > 0
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Circle(\box\x+Radius,\box\y+Radius, 2, \Color\Frame[\Focus*2]&$FFFFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Splitter(*this._S_widget)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      If *this > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        ; Позиция сплиттера 
        Size = \Thumb\len
        
        If \Vertical
          Pos = \Thumb\Pos-y
        Else
          Pos = \Thumb\Pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \Area\len)
          fColor = \Color\Frame&$FFFFFF|Alpha;\Color[3]\Frame[0]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Width,Pos,fColor) 
            EndIf
            If \Type[2]<>#PB_GadgetType_Splitter
              Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),fColor)
            EndIf
          Else
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Pos,Height,fColor) 
            EndIf 
            If \Type[2]<>#PB_GadgetType_Splitter
              Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = $FF000000;\Color[3]\Frame[\Color[3]\State]
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
            Line(X,(Y+Pos)+Size/2,Width,1,\Color\Frame&$FFFFFF|Alpha)
          Else
            ;box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\Color\Frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \Vertical
        ; ;           ;box(\box\x[3], \box\y[3]+\box\Height[3]-\Thumb\len, \box\Width[3], \Thumb\len, $FF0000)
        ; ;           box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;box(\box\x[3]+\box\Width[3]-\Thumb\len, \box\y[3], \Thumb\len, \box\Height[3], $FF0000)
        ; ;           box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Track(*this._S_widget)
    With *this 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*this\X[0],*this\Y[0],*this\Width[0],*this\Height[0],\Color[0]\Back)
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0]+5,\Y[0],a,\Height[0],\Color[3]\Frame)
        Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,(\y+\height)-\Thumb\Pos,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0],\Y[0]+5,\Width[0],a,\Color[3]\Frame)
        Box(\X[0],\Y[0]+5,\Thumb\Pos-\x,a,\Color[3]\Back[2])
      EndIf
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\box\x[3],\box\y[3],\box\Width[3]/2,\box\Height[3],\Color[3]\Back[\Color[3]\State])
        
        Line(\box\x[3],\box\y[3],1,\box\Height[3],\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3],\box\y[3],\box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3],\box\y[3]+\box\Height[3]-1,\box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3]+\box\Width[3]/2,\box\y[3],\box\Width[3]/2,\box\Height[3]/2+1,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3]+\box\Width[3]/2,\box\y[3]+\box\Height[3]-1,\box\Width[3]/2,-\box\Height[3]/2-1,\Color[3]\Frame[\Color[3]\State])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\box\x[3],\box\y[3],\box\Width[3],\box\Height[3]/2,\Color[3]\Back[\Color[3]\State])
        
        Line(\box\x[3],\box\y[3],\box\Width[3],1,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3],\box\y[3],1,\box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3]+\box\Width[3]-1,\box\y[3],1,\box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3],\box\y[3]+\box\Height[3]/2,\box\Width[3]/2+1,\box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\box\x[3]+\box\Width[3]-1,\box\y[3]+\box\Height[3]/2,-\box\Width[3]/2-1,\box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
      EndIf
      
      If \Ticks
        Protected PlotStep = 5;(\width)/(\Max-\Min)
        
        For i=3 To (\Width-PlotStep)/2 
          If Not ((\X+i-3)%PlotStep)
            Box(\X+i, \Y[3]+\box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
        For i=\Width To (\Width-PlotStep)/2+3 Step - 1
          If Not ((\X+i-6)%PlotStep)
            Box(\X+i, \box\y[3]+\box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Image(*this._S_widget)
    With *this 
      
      ClipOutput(\x[2],\y[2],\Scroll\h\Page\len,\Scroll\v\Page\len)
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame)
      EndIf
    EndWith
    
    With *this\Scroll
      ; Scroll area coordinate
      Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
    EndWith
  EndProcedure
  
  Procedure.i Draw_Button(*this._S_widget)
    With *this
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Combobox(*this._S_widget)
    With *this
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      If \box\Checked
        State = 2
      EndIf
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        boxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        ClipOutput(\clip\x,\clip\y,\clip\width-\box\width-\Text\x[2],\clip\height)
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
        ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      EndIf
      
      \box\x = \x+\width-\box\width -\box\arrow_size/2
      \box\Height = \height[2]
      \box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\box\x+(\box\Width-\box\arrow_size)/2, \box\y+(\box\Height-\box\arrow_size)/2, \box\arrow_size, Bool(\box\Checked)+2, \Color\Front[State]&$FFFFFF|Alpha, \box\arrow_type)
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_HyperLink(*this._S_widget)
    Protected i.i, y.i
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        If \Flag\Lines
          Line(\Text\x, \Text\y+\Text\height-2, \Text\width, 1, \Color\Front[\Color\State]&$FFFFFF|Alpha)
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[\Color\State]&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front[\Color\State]&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_ListIcon(*this._S_widget)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*this\Flag\GridLines, FirstColumn.i
    
    With *this 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[2]-\Scroll\h\Page\Pos
      Protected start, stop, n
      
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[2]>1;(\box\width[1]+\box\width[2]+4)
      ForEach \Columns()
        FirstColumn = Bool(Not ListIndex(\Columns()))
        n = Bool(\flag\Checkboxes)*16 + Bool(\Image\width)*28
        
        
        y = \y[2]-\Scroll\v\Page\Pos
        \Columns()\y = \y+\bs-\fs
        \Columns()\Height=\TabHeight
        
        If \Columns()\Text\Change
          \Columns()\Text\width = TextWidth(\Columns()\Text\String)
          \Columns()\Text\height = TextHeight("A")
        EndIf
        
        \Columns()\x = x + n : x + \Columns()\width + 1
        
        \Columns()\image\x = \Columns()\x+\Columns()\image\x[1] - 1
        \Columns()\image\y = \Columns()\y+(\Columns()\height-\Columns()\image\height)/2
        
        \Columns()\Text\x = \Columns()\image\x + \Columns()\image\width + Bool(\Columns()\image\width) * 3
        \Columns()\Text\y = \Columns()\y+(\Columns()\height-\Columns()\Text\height)/2
        
        \Columns()\Drawing = Bool(Not \Columns()\hide And \Columns()\x+\Columns()\width>\x[2] And \Columns()\x<\x[2]+\width[2])
        
        
        ForEach \Columns()\items()
          If Not \Columns()\items()\hide 
            If \Columns()\items()\text\change = 1
              \Columns()\items()\text\height = TextHeight("A")
              \Columns()\items()\text\width = TextWidth(\Columns()\items()\text\string.s)
            EndIf
            
            \Columns()\items()\width=\Columns()\width
            \Columns()\items()\x=\Columns()\x
            \Columns()\items()\y=y ; + GridLines
            
            ;\Columns()\items()\sublevellen=2+\Columns()\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\Columns()\items()\sublevel * \sublevellen)
            
            If FirstColumn
              If \flag\Checkboxes 
                \Columns()\items()\box\width[1] = \Flag\Checkboxes
                \Columns()\items()\box\height[1] = \Flag\Checkboxes
                
                \Columns()\items()\box\x[1] = \x[2] + 4 - \Scroll\h\Page\Pos
                \Columns()\items()\box\y[1] = (\Columns()\items()\y+\Columns()\items()\height)-(\Columns()\items()\height+\Columns()\items()\box\height[1])/2
              EndIf
              
              If \Columns()\items()\image\imageID 
                \Columns()\items()\image\x = \Columns()\x - \Columns()\items()\image\width - 6
                \Columns()\items()\image\y = \Columns()\items()\y+(\Columns()\items()\height-\Columns()\items()\image\height)/2
                
                \image\imageID = \Columns()\items()\image\imageID
                \image\width = \Columns()\items()\image\width+4
              EndIf
            EndIf
            
            \Columns()\items()\text\x = \Columns()\Text\x
            \Columns()\items()\text\y = \Columns()\items()\y+(\Columns()\items()\height-\Columns()\items()\text\height)/2
            \Columns()\items()\Drawing = Bool(\Columns()\items()\y+\Columns()\items()\height>\y[2] And \Columns()\items()\y<\y[2]+\height[2])
            
            y + \Columns()\items()\height + \Flag\GridLines + GridLines * 2
          EndIf
          
          If \index[2] = \Columns()\items()\index
            State_3 = 2
          Else
            State_3 = \Columns()\items()\State
          EndIf
          
          If \Columns()\items()\Drawing
            ; Draw selections
            If \flag\FullSelection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\Columns()\items()\y+1,\Scroll\h\Page\len,\Columns()\items()\height, \Color\Back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\Columns()\items()\y,\Scroll\h\Page\len,\Columns()\items()\height, \Color\Frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \Focus
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y+1,\Scroll\h\Page\len,\Columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y,\Scroll\h\Page\len,\Columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\AlwaysSelection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y+1,\Scroll\h\Page\len,\Columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y,\Scroll\h\Page\len,\Columns()\items()\height, $C8C8C8&back_color|Alpha)
                EndIf
              EndIf
            EndIf
            
            If \Columns()\Drawing 
              ;\Columns()\items()\width = \Scroll\h\Page\len
              
              ; Draw checkbox
              If \flag\Checkboxes And FirstColumn
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(\Columns()\items()\box\x[1],\Columns()\items()\box\y[1],\Columns()\items()\box\width[1],\Columns()\items()\box\height[1], 3, 3, \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                
                If \Columns()\items()\box\Checked[1] = #PB_Checkbox_Checked
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  For i =- 1 To 1
                    LineXY((\Columns()\items()\box\X[1]+2),(i+\Columns()\items()\box\Y[1]+7),(\Columns()\items()\box\X[1]+6),(i+\Columns()\items()\box\Y[1]+8), \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha) 
                    LineXY((\Columns()\items()\box\X[1]+9+i),(\Columns()\items()\box\Y[1]+2),(\Columns()\items()\box\X[1]+5+i),(\Columns()\items()\box\Y[1]+9), \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                  Next
                ElseIf \Columns()\items()\box\Checked[1] = #PB_Checkbox_Inbetween
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\Columns()\items()\box\x[1]+2,\Columns()\items()\box\y[1]+2,\Columns()\items()\box\width[1]-4,\Columns()\items()\box\height[1]-4, 3-2, 3-2, \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                EndIf
              EndIf
              
              ; Draw image
              If \Columns()\items()\image\imageID And FirstColumn 
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Columns()\items()\image\imageID, \Columns()\items()\image\x, \Columns()\items()\image\y, 255)
              EndIf
              
              ; Draw string
              If \Columns()\items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\Columns()\items()\text\x, \Columns()\items()\text\y, \Columns()\items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|\color\alpha<<24)
              EndIf
              
              ; Draw grid line
              If \Flag\GridLines
                DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Line(\Columns()\items()\X-n, \Columns()\items()\Y+\Columns()\items()\Height + GridLines, \Columns()\width+n+1 + (\width[2]-(\Columns()\x-\x[2]+\Columns()\width)), 1, \Color\Frame&$FFFFFF|\color\alpha<<24)                   ; top
              EndIf
            EndIf
          EndIf
          
          \Columns()\items()\text\change = 0
          \Columns()\items()\change = 0
        Next
        
        
        If \Columns()\Drawing
          ; Draw thumb  
          If \Color\back[\Columns()\State]<>-1
            If \Color\Fore[\Columns()\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            
            If FirstColumn And n
              boxGradient( \Vertical, \x[2], \Columns()\Y, n, \Columns()\Height, \Color\Fore[0]&$FFFFFF|\color\alpha<<24, \Color\Back[0]&$FFFFFF|\color\alpha<<24, \Radius, \color\alpha)
            ElseIf ListIndex(\Columns()) = ListSize(\Columns()) - 1
              boxGradient( \Vertical, \Columns()\X+\Columns()\Width, \Columns()\Y, 1 + (\width[2]-(\Columns()\x-\x[2]+\Columns()\width)), \Columns()\Height, \Color\Fore[0]&$FFFFFF|\color\alpha<<24, \Color\Back[0]&$FFFFFF|\color\alpha<<24, \Radius, \color\alpha)
            EndIf
            
            boxGradient( \Vertical, \Columns()\X, \Columns()\Y, \Columns()\Width, \Columns()\Height, \Color\Fore[\Columns()\State], Bool(\Columns()\State <> 2) * \Color\Back[\Columns()\State] + (Bool(\Columns()\State = 2) * \Color\Front[\Columns()\State]), \Radius, \color\alpha)
          EndIf
          
          ; Draw string
          If \Columns()\Text\String
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\Columns()\Text\x, \Columns()\Text\y, \Columns()\Text\String.s, \Color\Front[0]&$FFFFFF|Alpha)
          EndIf
          
          ; Draw image
          If \Columns()\image\imageID
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Columns()\image\imageID, \Columns()\image\x, \Columns()\image\y, \color\alpha)
          EndIf
          
          ; Draw line 
          If FirstColumn And n
            Line(\Columns()\X-1, \Columns()\Y, 1, \Columns()\height + Bool(\Flag\GridLines) * \height[1], \Color\Frame&$FFFFFF|\color\alpha<<24)                     ; left
          EndIf
          Line(\Columns()\X+\Columns()\width, \Columns()\Y, 1, \Columns()\height + Bool(\Flag\GridLines) * \height[1], \Color\Frame&$FFFFFF|\color\alpha<<24)      ; right
          Line(\x[2], \Columns()\Y+\Columns()\Height-1, \width[2], 1, \Color\Frame&$FFFFFF|\color\alpha<<24)                                                       ; bottom
          
          If \Columns()\State = 2
            DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\Columns()\X, \Columns()\Y+1, \Columns()\Width, \Columns()\Height-2, \Radius, \Radius, \Color\Frame[\Columns()\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        \Columns()\Text\Change = 0
      Next
      
      \Scroll\height = (y+\Scroll\v\Page\Pos)-\y[2]-1;\Flag\GridLines
                                                     ; set vertical scrollbar max value
      If \Scroll\v And \Scroll\v\Page\Len And \Scroll\v\Max<>\Scroll\height And 
         SetAttribute(\Scroll\v, #PB_Bar_Maximum, \Scroll\height) : \Scroll\v\page\step = \Text\height
        Resizes(\Scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \Scroll\width = (x+\Scroll\h\Page\Pos)-\x[2]-Bool(Not \Scroll\v\Hide)*\Scroll\v\width+n
      If \Scroll\h And \Scroll\h\Page\Len And \Scroll\h\Max<>\Scroll\width And 
         SetAttribute(\Scroll\h, #PB_Bar_Maximum, \Scroll\width)
        Resizes(\Scroll, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X, \Y, \Width, \Height, \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw(*this._S_widget, Childrens=0)
    Protected ParentItem.i
    
    With *this
      If \root\widget And \root\widget\create And Not \create 
        If Not IsRoot(*this)
          \Function[2] = Bool(\Window And \Window\Function[1] And \Window<>\root\widget And \Window<>*this) * \Window\Function[1]
          \Function[3] = Bool(\root\widget And \root\widget\Function[1]) * \root\widget\Function[1]
        EndIf
        \Function = Bool(\Function[1] Or \Function[2] Or \Function[3])
        
        Event_Widgets(*this, #PB_EventType_create, - 1)
        
        \create = 1
      EndIf
      
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      ; Get text size
      If (\Text And \Text\Change)
        \Text\width = TextWidth(\Text\String.s[1])
        \Text\height = TextHeight("A")
      EndIf
      
      If \Image 
        If (\Image\Change Or \Resize Or \Change)
          ; Image default position
          If \image\imageID
            If (\Type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\Scroll\h\Page\len>\image\width And (\image\Align\Right Or \image\Align\Horizontal)) * (\Scroll\h\Page\len-\image\width)) / (\image\Align\Horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\Scroll\v\Page\len>\image\height And (\image\Align\Bottom Or \image\Align\Vertical)) * (\Scroll\v\Page\len-\image\height)) / (\image\Align\Vertical+1)
              \image\y = \Scroll\y+\image\y[1]+\y[2]
              \image\x = \Scroll\x+\image\x[1]+\x[2]
              
            ElseIf (\Type = #PB_GadgetType_Window)
              \image\x[1] = \image\x[2] + (Bool(\image\Align\Right Or \image\Align\Horizontal) * (\width-\image\width)) / (\image\Align\Horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\Align\Bottom Or \image\Align\Vertical) * (\height-\image\height)) / (\image\Align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y+\bs+(\TabHeight-\image\height)/2
              \Text\x[2] = \image\x[2] + \image\width
            Else
              \image\x[1] = \image\x[2] + (Bool(\image\Align\Right Or \image\Align\Horizontal) * (\width-\image\width)) / (\image\Align\Horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\Align\Bottom Or \image\Align\Vertical) * (\height-\image\height)) / (\image\Align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y[2]
            EndIf
          EndIf
        EndIf
        
        Protected image_width = \Image\width
      EndIf
      
      If \Text And (\Text\Change Or \Resize Or \Change)
        ; Make multi line text
        If \Text\MultiLine > 0
          \Text\String.s = Text_Wrap(*this, \Text\String.s[1], \Width-\bs*2, \Text\MultiLine)
          \CountItems = CountString(\Text\String.s, #LF$)
        Else
          \Text\String.s = \Text\String.s[1]
        EndIf
        
        ; Text default position
        If \Text\String
          \Text\x[1] = \Text\x[2] + (Bool((\Text\Align\Right Or \Text\Align\Horizontal)) * (\width[2]-\Text\width-image_width)) / (\Text\Align\Horizontal+1)
          \Text\y[1] = \Text\y[2] + (Bool((\Text\Align\Bottom Or \Text\Align\Vertical)) * (\height[2]-\Text\height)) / (\Text\Align\Vertical+1)
          
          If \Type = #PB_GadgetType_Frame
            \Text\x = \Text\x[1]+\x[2]+8
            \Text\y = \Text\y[1]+\y
            
          ElseIf \Type = #PB_GadgetType_Window
            \Text\x = \Text\x[1]+\x[2]+5
            \Text\y = \Text\y[1]+\y+\bs+(\TabHeight-\Text\height)/2
          Else
            \Text\x = \Text\x[1]+\x[2]
            \Text\y = \Text\y[1]+\y[2]
          EndIf
        EndIf
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
        
        If \Image[1] And \Container
          \image[1]\x = \x[2] 
          \image[1]\y = \y[2]
        EndIf
        
        ;           SetOrigin(\x,\y)
        ;           
        ;           If Not Post(#PB_EventType_Repaint, *this)
        ;             SetOrigin(0,0)
        
        
        Select \Type
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
        
        If \Scroll 
          If \Scroll\v And \Scroll\v\Type And Not \Scroll\v\Hide : Draw_Scroll(\Scroll\v) : EndIf
          If \Scroll\h And \Scroll\h\Type And Not \Scroll\h\Hide : Draw_Scroll(\Scroll\h) : EndIf
        EndIf
        
        ; Draw Childrens
        If Childrens And ListSize(\Childrens())
          ; Only selected item widgets draw
          ParentItem = Bool(\Type = #PB_GadgetType_Panel) * \index[2]
          ForEach \Childrens() 
            ;If Not Send(\Childrens(), #PB_EventType_Repaint)
            
            If \Childrens()\clip\width > 0 And 
               \Childrens()\clip\height > 0 And 
               \Childrens()\ParentItem = ParentItem
              Draw(\Childrens(), Childrens) 
            EndIf
            
            ;EndIf
            
            ; Draw anchors 
            If \Childrens()\root\widget And \Childrens()\root\widget\anchor And \Childrens()\root\widget\anchor\widget = \Childrens()
              Draw_Anchors(\Childrens()\root\widget\anchor\widget)
            EndIf
            
          Next
        EndIf
        
        If \clip\width > 0 And \clip\height > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\clip\x,\clip\y,\clip\width,\clip\height, $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $F00F00)
        EndIf
        
        UnclipOutput()
        
      EndIf
      
      ; reset 
      \Change = 0
      \Resize = 0
      If \Text
        \Text\Change = 0
      EndIf
      If \Image
        \image\change = 0
      EndIf
      
      ; *Value\Type =- 1 
      ; *Value\This = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      Init_Event(*this)
      
      If StartDrawing(CanvasOutput(\root\Canvas))
        ;DrawingMode(#PB_2DDrawing_Default)
        ;box(0,0,OutputWidth(),OutputHeight(), *this\Color\Back)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        Draw(*this, 1)
        
        
        ;       ; Selector
        ;         If \root\widget\anchor 
        ;           box(\root\widget\anchor\x, \root\widget\anchor\y, \root\widget\anchor\width, \root\widget\anchor\height ,\root\widget\anchor\color[\root\widget\anchor\State]\frame) 
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
        If \Type = #PB_GadgetType_Tree
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
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          ;\Items()\focus =- 1
          ;\Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            ;             Select \Attribute
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
          \Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \Items()\Color = Colors
                           ;           \Items()\Color\State = 1
                           ;           \Items()\Color\Fore[0] = 0 
                           ;           \Items()\Color\Fore[1] = 0
                           ;           \Items()\Color\Fore[2] = 0
          
          If Item = 0
            If Not \Repaint : \Repaint = 1
              PostEvent(#PB_Event_Gadget, \root\Canvas_window, \root\Canvas, #PB_EventType_Repaint)
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
            ;  \i_Parent\box\Checked = 1
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
      \items()\height = \Text\height
      \Items()\i_Parent = \i_Parent
      
      Set_Image(\items(), Image)
      
      \items()\y = \Scroll\height
      \Scroll\height + \items()\height
      
      \Image = AllocateStructure(_S_image)
      \image\imageID = \items()\image\imageID
      \image\width = \items()\image\width+4
      \CountItems + 1
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
      ForEach \Columns()
        
        ;{ Генерируем идентификатор
        If 0 > Item Or Item > ListSize(\Columns()\items()) - 1
          LastElement(\Columns()\items())
          AddElement(\Columns()\items()) 
          Item = ListIndex(\Columns()\items())
        Else
          SelectElement(\Columns()\items(), Item)
          ;       PreviousElement(\Columns()\items())
          ;       If \i_Parent\sublevel = \Columns()\items()\sublevel
          ;          \i_Parent = \Columns()\items()
          ;       EndIf
          
          ;       SelectElement(\Columns()\items(), Item)
          If \i_Parent\sublevel = *last\sublevel
            \i_Parent = *last
          EndIf
          
          If \Columns()\items()\sublevel>sublevel
            sublevel=\Columns()\items()\sublevel
          EndIf
          InsertElement(\Columns()\items())
          
          PushListPosition(\Columns()\items())
          While NextElement(\Columns()\items())
            \Columns()\items()\index = ListIndex(\Columns()\items())
          Wend
          PopListPosition(\Columns()\items())
        EndIf
        ;}
        
        \Columns()\items() = AllocateStructure(_S_items)
        \Columns()\items()\box = AllocateStructure(_S_box)
        
        If subLevel
          If sublevel>ListIndex(\Columns()\items())
            sublevel=ListIndex(\Columns()\items())
          EndIf
        EndIf
        
        If \i_Parent
          If subLevel = \i_Parent\subLevel 
            \Columns()\items()\i_Parent = \i_Parent\i_Parent
          ElseIf subLevel > \i_Parent\subLevel 
            \Columns()\items()\i_Parent = \i_Parent
            *last = \Columns()\items()
          ElseIf \i_Parent\i_Parent
            \Columns()\items()\i_Parent = \i_Parent\i_Parent\i_Parent
          EndIf
          
          If \Columns()\items()\i_Parent And subLevel > \Columns()\items()\i_Parent\subLevel
            sublevel = \Columns()\items()\i_Parent\sublevel + 1
            \Columns()\items()\i_Parent\childrens + 1
            ;             \Columns()\items()\i_Parent\box\Checked = 1
            ;             \Columns()\items()\hide = 1
          EndIf
        Else
          \Columns()\items()\i_Parent = \Columns()\items()
        EndIf
        
        
        \i_Parent = \Columns()\items()
        \Columns()\items()\change = 1
        \Columns()\items()\index= Item
        \Columns()\items()\index[1] =- 1
        \Columns()\items()\text\change = 1
        \Columns()\items()\text\string.s = Text.s
        \Columns()\items()\sublevel = sublevel
        \Columns()\items()\height = \Text\height
        
        Set_Image(\Columns()\items(), Image)
        
        \Columns()\items()\y = \Scroll\height
        \Scroll\height + \Columns()\items()\height
        
        \image\imageID = \Columns()\items()\image\imageID
        \image\width = \Columns()\items()\image\width+4
        \CountItems + 1
        
        
        \Columns()\Items()\text\string.s = StringField(Text.s, ListIndex(\Columns()) + 1, #LF$)
        \Columns()\Color = Color_Default
        \Columns()\Color\Fore[0] = 0 
        \Columns()\Color\Fore[1] = 0
        \Columns()\Color\Fore[2] = 0
        
        \Columns()\Items()\Y = \Scroll\height
        \Columns()\Items()\height = height
        \Columns()\Items()\change = 1
        
        \image\width = \Columns()\Items()\image\width
        ;         If ListIndex(\Columns()\Items()) = 0
        ;           PostEvent(#PB_Event_Gadget, \root\Canvas_window, \root\Canvas, #PB_EventType_Repaint)
        ;         EndIf
      Next
      
      \Scroll\height + height
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
            ;             *adress\box\Checked = 1
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
      \items()\height = \Text\height
      
      Set_Image(\items(), Image)
      \CountItems + 1
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
        If Not \Hide[1] And \Color\Alpha
          Result = \X[Mode]
        Else
          Result = \X[Mode]+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \Hide[1] And \Color\Alpha
          Result = \Y[Mode]
        Else
          Result = \Y[Mode]+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \Hide[1] And \Width[Mode] And \Color\Alpha
          Result = \Width[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \Hide[1] And \Height[Mode] And \Color\Alpha
          Result = \Height[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CountItems(*this._S_widget)
    ProcedureReturn *this\CountItems
  EndProcedure
  
  Procedure.i Hides(*this._S_widget, State.i)
    With *this
      If State
        \Hide = 1
      Else
        \Hide = \Hide[1]
        If \Scroll And \Scroll\v And \Scroll\h
          \Scroll\v\Hide = \Scroll\v\Hide[1]
          \Scroll\h\Hide = \Scroll\h\Hide[1]
        EndIf
      EndIf
      
      If ListSize(\Childrens())
        ForEach \Childrens()
          Hides(\Childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Hide(*this._S_widget, State.i=-1)
    With *this
      If State.i=-1
        ProcedureReturn \Hide 
      Else
        \Hide = State
        \Hide[1] = \Hide
        
        If ListSize(\Childrens())
          ForEach \Childrens()
            Hides(\Childrens(), State)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i ClearItems(*this._S_widget) 
    With *this
      \CountItems = 0
      \Text\Change = 1 
      If \Text\Editable
        \Text\String = #LF$
      EndIf
      
      ClearList(\Items())
      \Scroll\v\Hide = 1
      \Scroll\h\Hide = 1
      
      ;       If Not \Repaint : \Repaint = 1
      ;        PostEvent(#PB_Event_Gadget, \root\Canvas_window, \root\Canvas, #PB_EventType_Repaint)
      ;       EndIf
    EndWith
  EndProcedure
  
  Procedure.i RemoveItem(*this._S_widget, Item.i) 
    With *this
      \CountItems = ListSize(\Items()) ; - 1
      \Text\Change = 1
      
      If \CountItems =- 1 
        \CountItems = 0 
        \Text\String = #LF$
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \root\Canvas_window, \root\Canvas, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug Item
        If SelectElement(\Items(), Item)
          DeleteElement(\Items())
        EndIf
        
        \Text\String = RemoveString(\Text\String, StringField(\Text\String, Item+1, #LF$) + #LF$)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Enumerate(*this.Integer, *Parent._S_widget, ParentItem.i=0)
    Protected Result.i
    
    With *Parent
      If Not *this
        ;  ProcedureReturn 0
      EndIf
      
      If Not \Enumerate
        Result = FirstElement(\Childrens())
      Else
        Result = NextElement(\Childrens())
      EndIf
      
      \Enumerate = Result
      
      If Result
        If \Childrens()\ParentItem <> ParentItem 
          ProcedureReturn Enumerate(*this, *Parent, ParentItem)
        EndIf
        
        ;         If ListSize(\Childrens()\Childrens())
        ;           ProcedureReturn Enumerate(*this, \Childrens(), Item)
        ;         EndIf
        
        PokeI(*this, PeekI(@\Childrens()))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i IsContainer(*this._S_widget)
    ProcedureReturn *this\Container
  EndProcedure
  
  
  ;- ADD
  Procedure.i AddItem(*this._S_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *this
      
      Select \Type
        Case #PB_GadgetType_Panel
          LastElement(\items())
          AddElement(\items())
          
          ; last opened item of the parent
          \o_i = ListIndex(\Items())
          
          \items() = AllocateStructure(_S_items)
          \items()\index = ListIndex(\items())
          \items()\Text\String = Text.s
          \items()\Text\Change = 1
          \items()\height = \TabHeight
          \CountItems + 1 
          
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
          Protected *Tree._S_widget = \Popup\Childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(_S_items)
          *Tree\items()\box = AllocateStructure(_S_box)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\Text\String = Text.s
          *Tree\items()\Text\Change = 1
          *Tree\items()\height = \Text\height
          *Tree\CountItems + 1 
          
          *Tree\items()\y = *Tree\Scroll\height
          *Tree\Scroll\height + *Tree\items()\height
          
          Set_Image(*Tree\items(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  Procedure.i AddColumn(*this._S_widget, Position.i, Title.s, Width.i)
    With *this
      LastElement(\Columns())
      AddElement(\Columns()) 
      \Columns() = AllocateStructure(_S_widget)
      
      If Position =- 1
        Position = ListIndex(\Columns())
      EndIf
      
      \Columns()\index[1] =- 1
      \Columns()\index[2] =- 1
      \Columns()\index = Position
      \Columns()\width = Width
      
      \Columns()\Image = AllocateStructure(_S_image)
      \Columns()\image\x[1] = 5
      
      \Columns()\Text = AllocateStructure(_S_text)
      \Columns()\text\string.s = Title.s
      \Columns()\text\change = 1
      
      \Columns()\x = \x[2]+\Scroll\width
      \Columns()\height = \TabHeight
      \Scroll\height = \bs*2+\Columns()\height
      \Scroll\width + Width + 1
    EndWith
  EndProcedure
  
  
  ;- GET
  Procedure.i GetAdress(*this._S_widget)
    ProcedureReturn *this\Adress
  EndProcedure
  
  Procedure.i GetButtons(*this._S_widget)
    ProcedureReturn *this\Mouse\Buttons
  EndProcedure
  
  Procedure.i GetDisplay(*this._S_widget)
    ProcedureReturn *this\root\Canvas
  EndProcedure
  
  Procedure.i GetMouseX(*this._S_widget)
    ProcedureReturn *this\Mouse\X-*this\X[2]-*this\fs
  EndProcedure
  
  Procedure.i GetMouseY(*this._S_widget)
    ProcedureReturn *this\Mouse\Y-*this\Y[2]-*this\fs
  EndProcedure
  
  Procedure.i GetDeltaX(*this._S_widget)
    ;If *this\Mouse\Delta
    ; ProcedureReturn (*this\Mouse\Delta\X-*this\X[2]-*this\fs)+*this\X[3]
    ProcedureReturn (*this\root\widget\Mouse\delta\X-*this\X[2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.i GetDeltaY(*this._S_widget)
    ;If *this\Mouse\Delta
    ; ProcedureReturn (*this\Mouse\Delta\Y-*this\Y[2]-*this\fs)+*this\Y[3]
    ProcedureReturn (*this\root\widget\Mouse\Delta\Y-*this\Y[2]-*this\fs)
    ;EndIf
  EndProcedure
  
  Procedure.s GetClass(*this._S_widget)
    ProcedureReturn *this\Class
  EndProcedure
  
  Procedure.i GetCount(*this._S_widget)
    ProcedureReturn *this\Type_Index ; Parent\Count(Hex(*this\Parent)+"_"+Hex(*this\Type))
  EndProcedure
  
  Procedure.i GetLevel(*this._S_widget)
    ProcedureReturn *this\Level
  EndProcedure
  
  Procedure.i GetRoot(*this._S_widget)
    ProcedureReturn *this\root\widget
  EndProcedure
  
  Procedure.i GetRootWindow(*this._S_widget)
    ProcedureReturn *this\root\Canvas_window
  EndProcedure
  
  Procedure.i Get_Gadget(*this._S_widget)
    ProcedureReturn *this\root\Canvas
  EndProcedure
  
  Procedure.i GetParent(*this._S_widget)
    ProcedureReturn *this\Parent
  EndProcedure
  
  Procedure.i GetWindow(*this._S_widget)
    ProcedureReturn *this\Window
  EndProcedure
  
  Procedure.i GetParentItem(*this._S_widget)
    ProcedureReturn *this\ParentItem
  EndProcedure
  
  Procedure.i GetPosition(*this._S_widget, Position.i)
    Protected Result.i
    
    With *this
      If *this And \Parent
        ; 
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *this = \Parent
        EndIf
        
        Select Position
          Case #PB_List_First  : Result = FirstElement(\Parent\Childrens())
          Case #PB_List_Before : ChangeCurrentElement(\Parent\Childrens(), Adress(*this)) : Result = PreviousElement(\Parent\Childrens())
          Case #PB_List_After  : ChangeCurrentElement(\Parent\Childrens(), Adress(*this)) : Result = NextElement(\Parent\Childrens())
          Case #PB_List_Last   : Result = LastElement(\Parent\Childrens())
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetState(*this._S_widget)
    Protected Result.i
    
    With *this
      Select \Type
        Case #PB_GadgetType_Option,
             #PB_GadgetType_CheckBox 
          Result = \box\Checked
          
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
          Result = Invert(*this, \Page\Pos, \inverted)
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select \Type
        Case #PB_GadgetType_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : Result = \box\Size[1]
            Case #PB_Splitter_SecondMinimumSize : Result = \box\Size[2] - \box\Size[3]
          EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \Min  ; 1
            Case #PB_Bar_Maximum : Result = \Max  ; 2
            Case #PB_Bar_Inverted : Result = \inverted
            Case #PB_Bar_NoButtons : Result = \box\Size ; 4
            Case #PB_Bar_Direction : Result = \Direction
            Case #PB_Bar_PageLength : Result = \Page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._S_widget, Item.i, Attribute.i)
    Protected Result.i
    
    With *this
      Select \Type
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
      Select \Type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemData(*this._S_widget, Item.i)
    Protected Result.i
    
    With *this
      Select \Type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          PushListPosition(\items()) 
          ForEach \items()
            If \items()\index = Item 
              Result = \items()\data
              ; Debug \items()\Text\String
              Break
            EndIf
          Next
          PopListPosition(\items())
      EndSelect
    EndWith
    
    ;     If Result
    ;       Protected *w._S_widget = Result
    ;       
    ;       Debug "GetItemData "+Item +" "+ Result +" "+  *w\Class
    ;     EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._S_widget, Item.i, Column.i=0)
    Protected Result.s
    
    With *this
      
      Select \Type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
          ForEach \items()
            If \items()\index = Item 
              Result = \items()\Text\String.s
              Break
            EndIf
          Next
          
        Case #PB_GadgetType_ListIcon
          SelectElement(\Columns(), Column)
          
          ForEach \Columns()\items()
            If \Columns()\items()\index = Item 
              Result = \Columns()\items()\Text\String.s
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
    If *this\Text
      ProcedureReturn *this\Text\String.s
    EndIf
  EndProcedure
  
  Procedure.i GetType(*this._S_widget)
    ProcedureReturn *this\Type
  EndProcedure
  
  
  ;- SET
  Procedure.i SetAlignment(*this._S_widget, Mode.i, Type.i=1)
    With *this
      Select Type
        Case 1 ; widget
          If \Parent
            If Not \Align
              \Align._S_align = AllocateStructure(_S_align)
            EndIf
            
            If Not \Align\AutoSize
              \Align\Top = Bool(Mode&#PB_Top=#PB_Top)
              \Align\Left = Bool(Mode&#PB_Left=#PB_Left)
              \Align\Right = Bool(Mode&#PB_Right=#PB_Right)
              \Align\Bottom = Bool(Mode&#PB_Bottom=#PB_Bottom)
              
              If Bool(Mode&#PB_Center=#PB_Center)
                \Align\Horizontal = 1
                \Align\Vertical = 1
              Else
                \Align\Horizontal = Bool(Mode&#PB_Horizontal=#PB_Horizontal)
                \Align\Vertical = Bool(Mode&#PB_Vertical=#PB_Vertical)
              EndIf
            EndIf
            
            If Bool(Mode&#PB_Flag_AutoSize=#PB_Flag_AutoSize)
              If Bool(Mode&#PB_Full=#PB_Full) 
                \Align\Top = 1
                \Align\Left = 1
                \Align\Right = 1
                \Align\Bottom = 1
                \Align\AutoSize = 0
              EndIf
              
              ; Auto dock
              Static y2,x2,y1,x1
              Protected width = #PB_Ignore, height = #PB_Ignore
              
              If \Align\Left And \Align\Right
                \x = x2
                width = \Parent\width[2] - x1 - x2
              EndIf
              If \Align\Top And \Align\Bottom 
                \y = y2
                height = \Parent\height[2] - y1 - y2
              EndIf
              
              If \Align\Left And Not \Align\Right
                \x = x2
                \y = y2
                x2 + \width
                height = \Parent\height[2] - y1 - y2
              EndIf
              If \Align\Right And Not \Align\Left
                \x = \Parent\width[2] - \width - x1
                \y = y2
                x1 + \width
                height = \Parent\height[2] - y1 - y2
              EndIf
              
              If \Align\Top And Not \Align\Bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \Parent\width[2] - x1 - x2
              EndIf
              If \Align\Bottom And Not \Align\Top
                \x = 0
                \y = \Parent\height[2] - \height - y1
                y1 + \height
                width = \Parent\width[2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
              \Align\Top = Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              \Align\Left = Bool(Mode&#PB_Left=#PB_Left)+Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Top=#PB_Top)
              \Align\Right = Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Top=#PB_Top)+Bool(Mode&#PB_Bottom=#PB_Bottom)
              \Align\Bottom = Bool(Mode&#PB_Bottom=#PB_Bottom)+Bool(Mode&#PB_Right=#PB_Right)+Bool(Mode&#PB_Left=#PB_Left)
              
            EndIf
            
            If \Align\Right
              If \Align\Left And \Align\Right
                \Align\x = \Parent\width[2] - \width
              Else
                \Align\x = \Parent\width[2] - (\x-\Parent\x[2]) ; \Parent\Width[2] - (\Parent\width[2] - \width)
              EndIf
            EndIf
            If \Align\Bottom
              If \Align\Top And \Align\Bottom
                \Align\y = \Parent\height[2] - \height
              Else
                \Align\y = \Parent\height[2] - (\y-\Parent\y[2]) ; \Parent\height[2] - (\Parent\height[2] - \height)
              EndIf
            EndIf
            
            Resize(\Parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i SetTransparency(*this._S_widget, Transparency.a) ; opacity
    Protected Result.i
    
    With *this
      \Color\Alpha = Transparency
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s SetClass(*this._S_widget, Class.s)
    Protected Result.s
    
    With *this
      Result.s = \Class
      
      ;       If Class.s
      \Class = Class
      ;       Else
      ;         \Class = Class(\Type)
      ;       EndIf
      
    EndWith
    
    ProcedureReturn Result.s
  EndProcedure
  
  Procedure.i SetParent(*this._S_widget, *Parent._S_widget, ParentItem.i=-1)
    Protected x.i,y.i, *LastParent._S_widget
    
    With *this
      If *this > 0 
        If ParentItem =- 1
          ParentItem = *Parent\index[2]
        EndIf
        
        If *Parent <> \Parent Or \ParentItem <> ParentItem
          x = \x[3]
          y = \y[3]
          
          If \Parent And ListSize(\Parent\Childrens())
            ChangeCurrentElement(\Parent\Childrens(), Adress(*this)) 
            DeleteElement(\Parent\Childrens())
            *LastParent = Bool(\Parent<>*Parent) * \Parent
          EndIf
          
          \ParentItem = ParentItem
          \Parent = *Parent
          \root = *Parent\root
          
          If IsRoot(*Parent)
            \Window = *Parent
          Else
            \Window = *Parent\Window
          EndIf
          
          \Level = *Parent\Level + Bool(*Parent <> \root\widget)
          
          If \Scroll
            If \Scroll\v
              \Scroll\v\Window = \Window
            EndIf
            If \Scroll\h
              \Scroll\h\Window = \Window
            EndIf
          EndIf
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \Hide = Bool(\Parent\Hide Or \ParentItem <> \Parent\index[2])
          
          If \Parent\Scroll
            x-\Parent\Scroll\h\Page\Pos
            y-\Parent\Scroll\v\Page\Pos
          EndIf
          
          ; Add new children 
          LastElement(\Parent\Childrens()) 
          \index = \root\widget\CountItems 
          \adress = AddElement(\Parent\Childrens())
          
          If \adress
            \Parent\Childrens() = *this 
            \root\widget\CountItems + 1 
            \Parent\CountItems + 1 
          EndIf
          
          ; Make count type
          Protected Type = \Window
          If \Window
            \Type_Index = \Window\Count(Hex(Type)+"_"+Hex(\Type))
            \Window\Count(Hex(Type)+"_"+Hex(\Type)) + 1
          EndIf
          ;\Parent\Count(Hex(\Type)) + 1
          
          ;
          Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
          
          If *LastParent
            ;             Debug ""+*root\width+" "+*LastParent\root\widget\width+" "+*Parent\root\widget\width 
            ;             Debug "From ("+ Class(*LastParent\Type) +") to (" + Class(*Parent\Type) +") - SetParent()"
            
            If *LastParent <> *Parent
              Select Root() 
                Case *Parent\root\widget     : ReDraw(*Parent)
                Case *LastParent\root\widget : ReDraw(*LastParent)
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
      
      If \Parent
        ;
        If (\Type = #PB_GadgetType_ScrollBar And \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *this = \Parent
        EndIf
        
        ChangeCurrentElement(\Parent\Childrens(), Adress(*this))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\Parent\Childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\Parent\Childrens()) : MoveElement(\Parent\Childrens(), #PB_List_After, Adress(\Parent\Childrens()))
            Case #PB_List_After  : NextElement(\Parent\Childrens())     : MoveElement(\Parent\Childrens(), #PB_List_Before, Adress(\Parent\Childrens()))
            Case #PB_List_Last   : MoveElement(\Parent\Childrens(), #PB_List_Last)
          EndSelect
          
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\Parent\Childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\Parent\Childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
        ; \Parent\Childrens()\Adress = @\Parent\Childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  Procedure.i SetFocus(*this._S_widget, State.i)
    With *this
      
      If State =- 1
        If *this And *Value\Focus <> *this ;And (\Type <> #PB_GadgetType_Window)
          If *Value\Focus 
            \Deactive = *Value\Focus 
            ;*Value\Focus\root\widget\anchor = 0 
            *Value\Focus\Focus = 0
          EndIf
          If Not \Deactive 
            \Deactive = *this 
          EndIf
          ;\root\widget\anchor = \root\widget\anchor[#Anchor_moved]
          *Value\Focus = *this
          \Focus = 1
        EndIf
      Else
        \Focus = State
        ;\root\widget\anchor = Bool(State) * \root\widget\anchor[#Anchor_moved]
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetActive(*this._S_widget)
    ; Возвращаемые значения
    ; Если функция завершается успешно, 
    ; возвращаемое значения - дескриптор 
    ; последнего активного окна.
    Protected Result.i
    
    With *this
      ;       If \root\widget\anchor[#Anchor_moved] And Not \root\widget\anchor
      ;         Event_Widgets(*this, #PB_EventType_Change, \root\widget\anchor)
      ;       EndIf
      
      If *this And \root\widget And \root\widget\Type = #PB_GadgetType_Window
        \root\widget\Focus = 1
      EndIf
      
      If \Window And *Value\Active <> \Window                                     And \Window<>Root() And Not \root\widget\anchor[#Anchor_moved]
        If *Value\Active                                                          And *Value\Active<>Root()
          \Window\Deactive = *Value\Active 
          *Value\Active\Focus = 0
        EndIf
        If Not \Window\Deactive 
          \Window\Deactive = \Window 
        EndIf
        
        If *Value\Focus ; Если деактивировали окно то деактивируем и гаджет
          If *Value\Focus\Window = \Window\Deactive
            *Value\Focus\Focus = 0
          ElseIf *Value\Focus\Window = \Window
            *Value\Focus\Focus = 1
          EndIf
        EndIf
        
        Result = \Window\Deactive
        *Value\Active = \Window
        \Window\Focus = 1
      EndIf
      
      If *this And *Value\Focus <> *this And (\Type <> #PB_GadgetType_Window Or \root\widget\anchor[#Anchor_moved])
        If *Value\Focus
          \Deactive = *Value\Focus 
          *Value\Focus\Focus = 0
        EndIf
        
        If Not \Deactive 
          \Deactive = *this 
        EndIf
        
        *Value\Focus = *this
        \Focus = 1
      EndIf
      
      If \Window
        If \Window\root\widget
          PostEvent(#PB_Event_Gadget, \Window\root\Canvas_window, \Window\root\Canvas, #PB_EventType_Repaint)
        EndIf
        If \Window\Deactive And \Window<>\Window\Deactive
          PostEvent(#PB_Event_Gadget, \Window\Deactive\root\Canvas_window, \Window\Deactive\root\Canvas, #PB_EventType_Repaint)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetForeground(*this._S_widget)
    Protected repaint
    
    With *this
      ; SetActiveGadget(\root\Canvas)
      SetPosition(\Window, #PB_List_Last)
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
  
  Procedure.i SetText(*this._S_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    
    With *this
      If \Text And \Text\String.s[1] <> Text.s
        \Text\String.s[1] = Text_Make(*this, Text.s)
        
        If \Text\String.s[1]
          If \Text\MultiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \Text\MultiLine > 0
              Text.s + #LF$
            EndIf
            
            \Text\String.s[1] = Text.s
            \CountItems = CountString(\Text\String.s[1], #LF$)
          Else
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$) ; + #LF$
                                                                      ; \Text\String.s = RTrim(ReplaceString(\Text\String.s[1], #LF$, " ")) + #LF$
          EndIf
          
          \Text\String.s = \Text\String.s[1]
          \Text\Len = Len(\Text\String.s[1])
          \Text\Change = #True
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
        Select \Type
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
                \box\Checked = State
                ProcedureReturn 1
                
              Case #PB_Checkbox_Inbetween
                If \box\ThreeState 
                  \box\Checked = State
                  ProcedureReturn 1
                EndIf
            EndSelect
            
          Case #PB_GadgetType_Option
            If \OptionGroup And \box\Checked <> State
              If \OptionGroup\OptionGroup <> *this
                If \OptionGroup\OptionGroup
                  \OptionGroup\OptionGroup\box\Checked = 0
                EndIf
                \OptionGroup\OptionGroup = *this
              EndIf
              \box\Checked = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_ComboBox
            Protected *t._S_widget = \Popup\Childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\CountItems - 1 : State = *t\CountItems - 1 :  EndIf
            
            If *t\index[2] <> State
              If *t\index[2] >= 0 And SelectElement(*t\items(), *t\index[2]) 
                *t\items()\State = 0
              EndIf
              
              *t\index[2] = State
              \index[2] = State
              
              If SelectElement(*t\items(), State)
                *t\items()\State = 2
                *t\Change = State+1
                
                \Text\String[1] = *t\Items()\Text\String
                \Text\String = \Text\String[1]
                ;                 \Text[1]\String = \Text\String[1]
                ;                 \Text\Caret = 1
                ;                 \Text\Caret[1] = \Text\Caret
                \Text\Change = 1
                
                Event_Widgets(*this, #PB_EventType_Change, State)
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State
              If \index[2] >= 0 And 
                 SelectElement(\items(), \index[2]) 
                \items()\State = 0
              EndIf
              
              \index[2] = State
              
              If SelectElement(\items(), \index[2])
                \items()\State = 2
                \Change = \index[2]+1
                ; Event_Widgets(*this, #PB_EventType_Change, \index[2])
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            Result = Set_Image(*this, State)
            
            If Result
              If \Scroll
                SetAttribute(\Scroll\v, #PB_Bar_Maximum, \image\height)
                SetAttribute(\Scroll\h, #PB_Bar_Maximum, \image\width)
                
                \Resize = 1<<1|1<<2|1<<3|1<<4 
                Resize(*this, \x, \y, \width, \height) 
                \Resize = 0
              EndIf
            EndIf
            
          Case #PB_GadgetType_Panel
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State : \index[2] = State
              
              ForEach \Childrens()
                Hides(\Childrens(), Bool(\Childrens()\ParentItem<>State))
              Next
              
              \Change = State + 1
              Result = 1
            EndIf
            
          Default
            If (\Vertical And \Type = #PB_GadgetType_TrackBar)
              State = Invert(*this, State, \inverted)
            EndIf
            
            State = PagePos(*this, State)
            
            If \Page\Pos <> State 
              \Thumb\Pos = ThumbPos(*this, State)
              
              If \inverted
                If \Page\Pos > State
                  \Direction = Invert(*this, State, \inverted)
                Else
                  \Direction =- Invert(*this, State, \inverted)
                EndIf
              Else
                If \Page\Pos > State
                  \Direction =- State
                Else
                  \Direction = State
                EndIf
              EndIf
              
              \Change = \Page\Pos - State
              \Page\Pos = State
              
              If \Type = #PB_GadgetType_Spin
                \Text\String.s[1] = Str(\Page\Pos) : \Text\Change = 1
                
              ElseIf \Type = #PB_GadgetType_Splitter
                Resize_Splitter(*this)
                
              ElseIf \Parent
                \Parent\Change =- 1
                
                If \Parent\Scroll
                  If \Vertical
                    \Parent\Scroll\y =- \Page\Pos
                    Resize_Childrens(\Parent, 0, \Change)
                  Else
                    \Parent\Scroll\x =- \Page\Pos
                    Resize_Childrens(\Parent, \Change, 0)
                  EndIf
                EndIf
              EndIf
              
              Event_Widgets(*this, #PB_EventType_Change, State, \Direction)
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
        Select \Type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                Set_Image(*this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \box\Size[1] = Value
              Case #PB_Splitter_SecondMinimumSize : \box\Size[2] = \box\Size[3] + Value
            EndSelect 
            
            If \Vertical
              \Area\Pos = \Y+\box\Size[1]
              \Area\len = (\Height-\box\Size[1]-\box\Size[2])
            Else
              \Area\Pos = \X+\box\Size[1]
              \Area\len = (\Width-\box\Size[1]-\box\Size[2])
            EndIf
            
            ProcedureReturn 1
            
          Case #PB_GadgetType_Image
            Select Attribute
              Case #PB_DisplayMode
                
                Select Value
                  Case 0 ; Default
                    \image\Align\Vertical = 0
                    \image\Align\Horizontal = 0
                    
                  Case 1 ; Center
                    \image\Align\Vertical = 1
                    \image\Align\Horizontal = 1
                    
                  Case 3 ; Mosaic
                  Case 2 ; Stretch
                    
                  Case 5 ; Proportionally
                EndSelect
                
                ;Resize = 1
                \Resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*this, \x, \y, \width, \height)
                \Resize = 0
            EndSelect
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \box\Size[0] = Value
                \box\Size[1] = Value
                \box\Size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \Page\Pos = Invert(*this, \Page\Pos)
                \Thumb\Pos = ThumbPos(*this, \Page\Pos)
                ProcedureReturn 1
                
              Case #PB_Bar_Minimum ; 1 -m&l
                If \Min <> Value 
                  \Min = Value
                  \Page\Pos + Value
                  
                  If \Page\Pos > \Max-\Page\len
                    If \Max > \Page\len 
                      \Page\Pos = \Max-\Page\len
                    Else
                      \Page\Pos = \Min 
                    EndIf
                  EndIf
                  
                  If \Max > \Min
                    \Thumb\Pos = ThumbPos(*this, \Page\Pos)
                    \Thumb\len = ThumbLength(*this)
                  Else
                    \Thumb\Pos = \Area\Pos
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \box\y[3] = \Thumb\Pos  
                      \box\Height[3] = \Thumb\len
                    Else 
                      \box\x[3] = \Thumb\Pos 
                      \box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_Maximum ; 2 -m&l
                If \Max <> Value
                  \Max = Value
                  
                  If \Page\len > \Max 
                    \Page\Pos = \Min
                  EndIf
                  
                  \Thumb\Pos = ThumbPos(*this, \Page\Pos)
                  
                  If \Max > \Min
                    \Thumb\len = ThumbLength(*this)
                  Else
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \box\Height[3] = \Thumb\len
                    Else 
                      \box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  If \page\step = 0
                    \page\step = 1
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_PageLength ; 3 -m&l
                If \Page\len <> Value
                  If Value > (\Max-\Min)
                    If \Max = 0 
                      \Max = Value 
                    EndIf
                    Value = (\Max-\Min)
                    \Page\Pos = \Min
                  EndIf
                  \Page\len = Value
                  
                  \Thumb\Pos = ThumbPos(*this, \Page\Pos)
                  
                  If \Page\len > \Min
                    \Thumb\len = ThumbLength(*this)
                  Else
                    \Thumb\len = \box\Size[3]
                  EndIf
                  
                  If \page\step = 0
                    \page\step = 1
                  EndIf
                  If \page\step < 2 And \Page\len
                    \page\step = (\Max-\Min) / \Page\len 
                  EndIf
                  
                  Resize = 1
                EndIf
                
            EndSelect
            
        EndSelect
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \Hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetItemAttribute(*this._S_widget, Item.i, Attribute.i, Value.i)
    Protected Result.i
    
    With *this
      Select \Type
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
      Select \Type
        Case #PB_GadgetType_ListView
          If (\Flag\MultiSelect Or \Flag\ClickSelect)
            Result = SelectElement(\items(), Item) 
            If Result 
              \items()\State = Bool(State)+1
            EndIf
          EndIf
          
        Case #PB_GadgetType_Tree
          
          If Item < 0 : Item = 0 : EndIf
          If Item > \CountItems : Item = \CountItems :  EndIf
          ;       
          ;       If \index[2] <> Item
          ;         If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
          ;           \items()\State = 0
          ;         EndIf
          ;         
          ;         If SelectElement(\items(), Item)
          ;           *Value\Type = #PB_EventType_Change
          ;           *Value\Widget = *this
          ;           \items()\State = 2
          ;           \Change = Item+1
          ;           
          ;           PostEvent(#PB_Event_Widget, *Value\Window, *this, #PB_EventType_Change)
          ;           PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
          ;         EndIf
          ;         
          ;         \index[2] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\Flag\MultiSelect Or \Flag\ClickSelect)
          PushListPosition(\Items())
          Result = SelectElement(\Items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \Items()\Index[1] = \Items()\Index
              \Items()\State = Bool(State)+1
            EndIf
            
            \Items()\box\Checked = Bool(State&#PB_Tree_Collapsed)
            
            If \Items()\box\Checked Or State&#PB_Tree_Expanded
              
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
          ;                 If (MouseScreenY > (\items()\box\y[1]) And MouseScreenY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
          ;                    ((MouseScreenX > \items()\box\x[1]) And (MouseScreenX =< (\items()\box\x[1]+\items()\box\width[1])))
          ;                   
          ;                   \items()\box\Checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (MouseScreenY > (\items()\box\y[0]) And MouseScreenY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
          ;                        ((MouseScreenX > \items()\box\x[0]) And (MouseScreenX =< (\items()\box\x[0]+\items()\box\width[0])))
          ;                   
          ;                   sublevel = \items()\sublevel
          ;                   \items()\box\Checked ! 1
          ;                   \Change = 1
          ;                   
          ;                   PushListPosition(\items())
          ;                   While NextElement(\items())
          ;                     If sublevel = \items()\sublevel
          ;                       Break
          ;                     ElseIf sublevel < \items()\sublevel And \items()\a
          ;                       \items()\hide = Bool(\items()\a\box\Checked Or \items()\a\hide) * 1
          ;                     EndIf
          ;                   Wend
          ;                   PopListPosition(\items())
          ;                   
          ;                 ElseIf \index[2] <> \index[1] : \items()\State = 2
          ;                   If \index[2] >= 0 And SelectElement(\items(), \index[2])
          ;                     \items()\State = 0
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
          
          If \Type = #PB_GadgetType_Property
            \items()\text[1]\string.s = Text
          Else
            \items()\text\string.s = Text
          EndIf
          
          ;\items()\Text\String.s = Text.s
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
      i = Bool(\Container)
      
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
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetCursor(*this._S_widget)
    ProcedureReturn *this\Cursor
  EndProcedure
  
  Procedure.i SetCursor(*this._S_widget, Cursor.i, CursorType.i=#PB_Canvas_Cursor)
    Protected Result.i
    
    With *this
      If \Cursor <> Cursor
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
        
        
        SetGadgetAttribute(\root\Canvas, CursorType, Cursor)
        
        \Cursor = Cursor
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- CHANGE
  Procedure.i Resize(*this._S_widget, X.i,Y.i,Width.i,Height.i)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #PB_Flag_AutoSize
        If \Parent And \Parent\Type <> #PB_GadgetType_Splitter And \Align And \Align\AutoSize And \Align\Left And \Align\Top And \Align\Right And \Align\Bottom
          X = 0; \Align\x
          Y = 0; \Align\y
          Width = \Parent\width[2] ; - \Align\x
          Height = \Parent\height[2] ; - \Align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \Parent : \x[3] = X : X+\Parent\x+\Parent\bs : EndIf : If \X <> X : Change_x = x-\x : \X = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \Resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \Parent : \y[3] = Y : Y+\Parent\y+\Parent\bs+\Parent\TabHeight : EndIf : If \Y <> Y : Change_y = y-\y : \Y = Y : \y[2] = \y+\bs+\TabHeight : \y[1] = \y[2]-\fs : \Resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \Width <> Width : Change_width = width-\width : \Width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \Height <> Height : Change_height = height-\height : \Height = Height : \height[2] = \height-\bs*2-\TabHeight : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \Width <> Width : Change_width = width-\width : \Width = Width+Bool(\Type=-1)*(\bs*2) : \width[2] = width-Bool(\Type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \Height <> Height : Change_height = height-\height : \Height = Height+Bool(\Type=-1)*(\TabHeight+\bs*2) : \height[2] = height-Bool(\Type<>-1)*(\TabHeight+\bs*2) : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        If \box And \Resize
          \hide[1] = Bool(\Page\len And Not ((\Max-\Min) > \Page\Len))
          
          If \box\Size
            \box\Size[1] = \box\Size
            \box\Size[2] = \box\Size
          EndIf
          
          If \Max
            If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
              \Area\Pos = \Y[2]+\box\Size[1]
              \Area\len = \Height[2]-(\box\Size[1]+\box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            Else
              \Area\Pos = \X[2]+\box\Size[1]
              \Area\len = \width[2]-(\box\Size[1]+\box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            EndIf
          EndIf
          
          If (\Type <> #PB_GadgetType_Splitter) And Bool(\Resize & (1<<4 | 1<<3))
            \Thumb\len = ThumbLength(*this)
            
            If (\Area\len > \box\Size)
              If \box\Size
                If (\Thumb\len < \box\Size)
                  \Area\len = Round(\Area\len - (\box\Size[2]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \box\Size[2] 
                EndIf
              Else
                If (\Thumb\len < \box\Size[3]) And (\Type <> #PB_GadgetType_ProgressBar)
                  \Area\len = Round(\Area\len - (\box\Size[3]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \box\Size[3]
                EndIf
              EndIf
            Else
              \Thumb\len = \Area\len 
            EndIf
          EndIf
          
          If \Area\len > 0 And \Type <> #PB_GadgetType_Panel
            If _scroll_in_stop_(*this) And (\Type = #PB_GadgetType_ScrollBar)
              SetState(*this, \Max)
            EndIf
            
            \Thumb\Pos = ThumbPos(*this, \Page\Pos)
          EndIf
          
          Select \Type
            Case #PB_GadgetType_Window
              \box\x = \x[2]
              \box\y = \y+\bs
              \box\width = \width[2]
              \box\height = \TabHeight
              
              \box\width[1] = \box\Size
              \box\width[2] = \box\Size
              \box\width[3] = \box\Size
              
              \box\height[1] = \box\Size
              \box\height[2] = \box\Size
              \box\height[3] = \box\Size
              
              \box\x[1] = \x[2]+\width[2]-\box\width[1]-5
              \box\x[2] = \box\x[1]-Bool(Not \box\Hide[2]) * \box\width[2]-5
              \box\x[3] = \box\x[2]-Bool(Not \box\Hide[3]) * \box\width[3]-5
              
              \box\y[1] = \y+\bs+(\TabHeight-\box\Size)/2
              \box\y[2] = \box\y[1]
              \box\y[3] = \box\y[1]
              
            Case #PB_GadgetType_Panel
              \Page\len = \Width[2]-2
              
              If _scroll_in_stop_(*this)
                If \Max < \Min : \Max = \Min : EndIf
                
                If \Max > \Max-\Page\len
                  If \Max > \Page\len
                    \Max = \Max-\Page\len
                  Else
                    \Max = \Min 
                  EndIf
                EndIf
                
                \Page\Pos = \Max
                \Thumb\Pos = ThumbPos(*this, \Page\Pos)
              EndIf
              
              \box\width[1] = \box\Size : \box\height[1] = \TabHeight-1-4
              \box\width[2] = \box\Size : \box\height[2] = \box\height[1]
              
              \box\x[1] = \x[2]+1
              \box\y[1] = \y[2]-\TabHeight+\bs+2
              \box\x[2] = \x[2]+\width[2]-\box\width[2]-1
              \box\y[2] = \box\y[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \box\y[1] = \y[2]+\Height[2]/2+Bool(\Height[2]%2) : \box\Height[1] = \Height[2]/2 : \box\Width[1] = \box\Size[2] : \box\x[1] = \x[2]+\width[2]-\box\Size[2] ; Top button coordinate
                \box\y[2] = \y[2] : \box\Height[2] = \Height[2]/2 : \box\Width[2] = \box\Size[2] : \box\x[2] = \x[2]+\width[2]-\box\Size[2]                                 ; Bottom button coordinate
              Else
                \box\y[1] = \y[2] : \box\Height[1] = \Height[2] : \box\Width[1] = \box\Size[2]/2 : \box\x[1] = \x[2]+\width[2]-\box\Size[2]                                 ; Left button coordinate
                \box\y[2] = \y[2] : \box\Height[2] = \Height[2] : \box\Width[2] = \box\Size[2]/2 : \box\x[2] = \x[2]+\width[2]-\box\Size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \box\Size
                  \box\x[1] = \x[2] + Lines : \box\y[1] = \y[2] : \box\Width[1] = \Width - Lines : \box\Height[1] = \box\Size[1]                         ; Top button coordinate on scroll bar
                  \box\x[2] = \x[2] + Lines : \box\Width[2] = \Width - Lines : \box\Height[2] = \box\Size[2] : \box\y[2] = \y[2]+\height[2]-\box\Size[2] ; (\Area\Pos+\Area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \box\x[3] = \x[2] + Lines : \box\Width[3] = \Width - Lines : \box\y[3] = \Thumb\Pos : \box\Height[3] = \Thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \box 
                If \box\Size
                  \box\x[1] = \x[2] : \box\y[1] = \y[2] + Lines : \box\Height[1] = \Height - Lines : \box\Width[1] = \box\Size[1]                        ; Left button coordinate on scroll bar
                  \box\y[2] = \y[2] + Lines : \box\Height[2] = \Height - Lines : \box\Width[2] = \box\Size[2] : \box\x[2] = \x[2]+\width[2]-\box\Size[2] ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
                EndIf
                \box\y[3] = \y[2] + Lines : \box\Height[3] = \Height - Lines : \box\x[3] = \Thumb\Pos : \box\Width[3] = \Thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        ; set clip coordinate
        If Not IsRoot(*this) And \Parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \Parent\Scroll 
            If \Parent\Scroll\v : clip_v = Bool(\Parent\width=\Parent\clip\width And Not \Parent\Scroll\v\Hide And \Parent\Scroll\v\type = #PB_GadgetType_ScrollBar)*\Parent\Scroll\v\width : EndIf
            If \Parent\Scroll\h : clip_h = Bool(\Parent\height=\Parent\clip\height And Not \Parent\Scroll\h\Hide And \Parent\Scroll\h\type = #PB_GadgetType_ScrollBar)*\Parent\Scroll\h\height : EndIf
          EndIf
          
          clip_x = \Parent\clip\x+Bool(\Parent\clip\x<\Parent\x+\Parent\bs)*\Parent\bs
          clip_y = \Parent\clip\y+Bool(\Parent\clip\y<\Parent\y+\Parent\bs)*(\Parent\bs+\Parent\TabHeight) 
          clip_width = ((\Parent\clip\x+\Parent\clip\width)-Bool((\Parent\clip\x+\Parent\clip\width)>(\Parent\x[2]+\Parent\width[2]))*\Parent\bs)-clip_v 
          clip_height = ((\Parent\clip\y+\Parent\clip\height)-Bool((\Parent\clip\y+\Parent\clip\height)>(\Parent\y[2]+\Parent\height[2]))*\Parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \clip\x = clip_x : Else : \clip\x = \x : EndIf
        If clip_y And \y < clip_y : \clip\y = clip_y : Else : \clip\y = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \clip\width = clip_width - \clip\x : Else : \clip\width = \width - (\clip\x-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \clip\height = clip_height - \clip\y : Else : \clip\height = \height - (\clip\y-\y) : EndIf
        
        ; Resize scrollbars
        If \Scroll And \Scroll\v And \Scroll\h
          Resizes(\Scroll, 0,0, \Width[2],\Height[2])
        EndIf
        
        ; Resize childrens
        If ListSize(\Childrens())
          If \Type = #PB_GadgetType_Splitter
            Resize_Splitter(*this)
          Else
            ForEach \Childrens()
              If \Childrens()\Align
                If \Childrens()\Align\Horizontal
                  x = (\width[2] - (\Childrens()\Align\x+\Childrens()\width))/2
                ElseIf \Childrens()\Align\Right And Not \Childrens()\Align\Left
                  x = \width[2] - \Childrens()\Align\x
                Else
                  If \x[2]
                    x = (\Childrens()\x-\x[2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Vertical
                  y = (\height[2] - (\Childrens()\Align\y+\Childrens()\height))/2 
                ElseIf \Childrens()\Align\Bottom And Not \Childrens()\Align\Top
                  y = \height[2] - \Childrens()\Align\y
                Else
                  If \y[2]
                    y = (\Childrens()\y-\y[2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Top And \Childrens()\Align\Bottom
                  Height = \height[2] - \Childrens()\Align\y
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \Childrens()\Align\Left And \Childrens()\Align\Right
                  Width = \width[2] - \Childrens()\Align\x
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\Childrens(), x, y, Width, Height)
              Else
                Resize(\Childrens(), (\Childrens()\x-\x[2]) + Change_x, (\Childrens()\y-\y[2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        ; anchors widgets
        If \root\widget And \root\widget\anchor And \root\widget\anchor\Widget = *this
          Resize_Anchors(*this)
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v)-(\v\Width-\v\Radius/2)+1, iHeight = Y(\h)-(\h\Height-\h\Radius/2)+1
      Static hPos, vPos : vPos = \v\Page\Pos : hPos = \h\Page\Pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\Page\Pos+iWidth 
        ScrollArea_Width=\h\Page\Pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\Page\Pos And
             ScrollArea_Width=\h\Page\Pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\Page\Pos+iHeight
        ScrollArea_Height=\v\Page\Pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\Page\Pos And
             ScrollArea_Height=\v\Page\Pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\Page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\Page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;     \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;     \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\Y + Bool(\h\Hide) * \h\Height) - \v\Y) ; #PB_Ignore, \h) 
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\X + Bool(\v\Hide) * \v\Width) - \h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\Page\Pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\Page\Pos = vPos : \h\Width = iWidth+\v\Width : EndIf
      If \h\hide : \h\Page\Pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\Page\Pos = hPos : \v\Height = iHeight+\h\Height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll._S_scroll, X.i,Y.i,Width.i,Height.i)
    With *Scroll
      If y=#PB_Ignore : y = \v\Y : EndIf
      If x=#PB_Ignore : x = \h\X : EndIf
      If Width=#PB_Ignore : Width = \v\X-\h\X+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\Y-\v\Y+\h\height : EndIf
      
      ;       If \v\Parent
      ;         y - \v\Parent\bs
      ;       EndIf
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, Width+x-\v\Width, y, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, x, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len); + Bool(\v\Radius And Not \h\Hide And Not \v\Hide)*4)
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len, #PB_Ignore); + Bool(\h\Radius And Not \v\Hide And Not \h\hide)*4, #PB_Ignore)
      
      If Not \v\Hide 
        \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not \h\Hide 
        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      EndIf
      ProcedureReturn 1 ; Bool(Not Bool(\v\Hide And \h\Hide))
    EndWith
  EndProcedure
  
  ;-
  ;- STRING_EDITABLE
  Procedure String_Remove(*this._S_widget)
    With *this
      If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Pos+\Text\Caret, 1)
      \Text\Len = Len(\Text\String.s[1])
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
      char = Asc(Mid(\Text\String.s[1], \Text\Caret + 1, 1))
      If _string_is_selection_end_(char)
        \Text\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _string_is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _string_is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure String_Caret(*this._S_widget, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      If \Scroll
        X = (\Text\X+\Scroll\X)
      Else
        X = \Text\X
      EndIf
      
      Len = \Text\Len
      FontID = \Text\FontID
      String.s = \Text\String.s[1]
      
      If \root\Canvas And StartDrawing(CanvasOutput(\root\Canvas)) 
        If FontID : DrawingFont(FontID) : EndIf
        
        For i = 0 To Len
          CursorX = X + TextWidth(Left(String.s, i))
          Distance = (\Mouse\X-CursorX)*(\Mouse\X-CursorX)
          
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
      If Caret <> *this\Text\Caret Or Line <> *this\index[1] Or (*this\Text\Caret[1] >= 0 And Caret1 <> *this\Text\Caret[1])
        \Text[2]\String.s = ""
        
        If *this\index[2] = *this\index[1]
          If *this\Text\Caret[1] > *this\Text\Caret 
            ; |<<<<<< to left
            Position = *this\Text\Caret
            \Text[2]\Len = (*this\Text\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *this\Text\Caret[1]
            \Text[2]\Len = (*this\Text\Caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *this\Text\Caret > *this\Text\Caret[1]
              ; <<<<<|
              Position = *this\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *this\Text\Caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *this\Text\Caret[1] > *this\Text\Caret 
              ; |<<<<<< to left
              Position = *this\Text\Caret
              \Text[2]\Len = (*this\Text\Caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *this\Text\Caret[1]
              \Text[2]\Len = (*this\Text\Caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *this\index[1] > *this\index[2]
              ; <<<<<|
              Position = *this\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *this\Text\Caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \Text[1]\String.s = Left(*this\Text\String.s[1], \Text\Pos+Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s[1], 1+\Text\Pos+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Trim(Right(*this\Text\String.s[1], *this\Text\Len-(\Text\Pos+Position + \Text[2]\Len)), #LF$) : \Text[3]\Change = #True
        
        Line = *this\index[1]
        Caret = *this\Text\Caret
        Caret1 = *this\Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure String_ToLeft(*this._S_widget)
    Protected Repaint
    
    With *this
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
      ElseIf \Text\Caret[1] > 0 
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToRight(*this._S_widget)
    Protected Repaint
    
    With *this
      If \Text[2]\Len 
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
      ElseIf \Text\Caret[1] < \Text\Len
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1] 
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_ToDelete(*this._S_widget)
    Protected Repaint
    
    With *this
      If \Text\Caret[1] < \Text\Len
        If \Text[2]\Len 
          String_Remove(*this)
        Else
          \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 2)
          \Text\Len = Len(\Text\String.s[1]) 
        EndIf
        
        \Text\Change =- 1
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
          If \Text[2]\Len 
            String_Remove(*this)
          EndIf
          
          \Text\Caret + 1
          ; \items()\Text\String.s[1] = \items()\Text[1]\String.s + Chr(\Keyboard\Input) + \items()\Text[3]\String.s ; сним не выравнивается строка при вводе слов
          \Text\String.s[1] = InsertString(\Text\String.s[1], Chr.s, \Text\Pos+\Text\Caret)
          \Text\Len = Len(\Text\String.s[1]) 
          \Text\Caret[1] = \Text\Caret 
          \Text\Change =- 1
        Else
          ;\Default = *this
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
      
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
        String_Remove(*this)
        
      ElseIf \Text\Caret[1] > 0 
        \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 1)
        \Text\Len = Len(\Text\String.s[1])  
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure String_Editable(*this._S_widget, EventType.i, MouseScreenX.i, MouseScreenY.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *this
      *this\index[1] = 0
      
      With *this
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If \root\Canvas And #PB_Cursor_Default = GetGadgetAttribute(\root\Canvas, #PB_Canvas_Cursor)
              SetGadgetAttribute(\root\Canvas, #PB_Canvas_Cursor, *this\Cursor)
            EndIf
            
            If *this\Text\Editable And *this\Drag[1] : *this\Drag[1] = 0
              If \Text\Caret[2] > 0 And Not Bool(\Text\Caret[2] < *this\Text\Caret + 1 And *this\Text\Caret + 1 < \Text\Caret[2] + \Text[2]\Len)
                
                *this\Text\String.s[1] = RemoveString(*this\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret[2], 1)
                
                If \Text\Caret[2] > *this\Text\Caret 
                  \Text\Caret[2] = *this\Text\Caret 
                  *this\Text\Caret[1] = *this\Text\Caret + \Text[2]\Len
                Else
                  \Text\Caret[2] = (*this\Text\Caret-\Text[2]\Len)
                  *this\Text\Caret[1] = \Text\Caret[2]
                EndIf
                
                *this\Text\String.s[1] = InsertString(*this\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                *this\Text\Len = Len(*this\Text\String.s[1])
                \Text\String.s[1] = InsertString(\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                \Text\Len = Len(\Text\String.s[1])
                
                *this\Text\Change =- 1
                \Text\Caret[2] = 0
                Repaint =- 1
              EndIf
            Else
              Repaint =- 1
              \Text\Caret[2] = 0
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            Caret = String_Caret(*this)
            
            If \Text\Caret[1] =- 1 : \Text\Caret[1] = 0
              *this\Text\Caret = 0
              *this\Text\Caret[1] = \Text\Len
              \Text[2]\Len = \Text\Len
              Repaint =- 1
            Else
              Repaint = 1
              
              If \Text[2] And \Text[2]\Len
                If *this\Text\Caret[1] > *this\Text\Caret : *this\Text\Caret[1] = *this\Text\Caret : EndIf
                
                If *this\Text\Caret[1] < Caret And Caret < *this\Text\Caret[1] + \Text[2]\Len
                  SetGadgetAttribute(\root\Canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  \Text\Caret[2] = *this\Text\Caret[1] + 1
                Else
                  Repaint =- 1
                EndIf
              Else
                Repaint =- 1
              EndIf
              
              *this\Text\Caret = Caret
              *this\Text\Caret[1] = *this\Text\Caret
            EndIf 
            
          Case #PB_EventType_LeftDoubleClick 
            \Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
            String_SelLimits(*this)    ; Выделяем слово
            Repaint =- 1
            
          Case #PB_EventType_MouseMove
            If *this\Mouse\Buttons & #PB_Canvas_LeftButton 
              Caret = String_Caret(*this)
              If *this\Text\Caret <> Caret
                
                If \Text\Caret[2] ; *this\Cursor <> GetGadgetAttribute(\root\Canvas, #PB_Canvas_Cursor)
                  If \Text\Caret[2] < Caret + 1 And Caret + 1 < \Text\Caret[2] + \Text[2]\Len
                    SetGadgetAttribute(\root\Canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  Else
                    \Text[1]\String.s = Left(*this\Text\String.s[1], \Text\Pos+*this\Text\Caret) : \Text[1]\Change = #True
                  EndIf
                  
                  *this\Text\Caret[1] = Caret
                  Repaint = 1
                Else
                  Repaint =- 1
                EndIf
                
                *this\Text\Caret = Caret
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
              Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *this\Text\Caret = 0 : *this\Text\Caret[1] = *this\Text\Caret : Repaint = #True 
              Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *this\Text\Caret = \Text\Len : *this\Text\Caret[1] = *this\Text\Caret : Repaint = #True 
                
              Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = String_ToLeft(*this) ; Ok
              Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = String_ToRight(*this) ; Ok
              Case #PB_Shortcut_Back : Repaint = String_ToBack(*this)
              Case #PB_Shortcut_Delete : Repaint = String_ToDelete(*this)
                
              Case #PB_Shortcut_A
                If Control
                  *this\Text\Caret = 0
                  *this\Text\Caret[1] = \Text\Len
                  \Text[2]\Len = \Text\Len
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_X
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                  String_Remove(*this)
                  *this\Text\Caret[1] = *this\Text\Caret
                  \Text\Len = Len(\Text\String.s[1])
                  Repaint = #True 
                EndIf
                
              Case #PB_Shortcut_C
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                EndIf
                
              Case #PB_Shortcut_V
                If Control
                  Protected ClipboardText.s = GetClipboardText()
                  
                  If ClipboardText.s
                    If \Text[2]\String.s
                      String_Remove(*this)
                    EndIf
                    
                    Select #True
                      Case *this\Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                      Case *this\Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                      Case *this\Text\Numeric 
                        If Val(ClipboardText.s)
                          ClipboardText.s = Str(Val(ClipboardText.s))
                        EndIf
                    EndSelect
                    
                    \Text\String.s[1] = InsertString(\Text\String.s[1], ClipboardText.s, *this\Text\Caret + 1)
                    *this\Text\Caret + Len(ClipboardText.s)
                    *this\Text\Caret[1] = *this\Text\Caret
                    \Text\Len = Len(\Text\String.s[1])
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
      \X =- 1
      \Y =- 1
      \Type = Type
      \Parent = Parent
      If \Parent
        \root = \Parent\root
        \Window = \Parent\Window
      EndIf
      \Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Flag&#PB_Vertical=#PB_Vertical)
      \box = AllocateStructure(_S_box)
      \box\Size[3] = SliderLen ; min thumb size
      
      \box\arrow_size[1] = 4
      \box\arrow_size[2] = 4
      \box\arrow_type[1] =- 1 ; -1 0 1
      \box\arrow_type[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \Color\State = 0
      \Color\Back = $FFF9F9F9
      \Color\Frame = \Color\Back
      \Color\Line = $FFFFFFFF
      
      \Color[1] = Color_Default
      \Color[2] = Color_Default
      \Color[3] = Color_Default
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If Size < 21
          \box\Size = Size - 1
        Else
          \box\Size = 17
        EndIf
        
        If \Vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
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
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth ; |(Bool(#PB_Vertical) * #PB_Bar_Inverted)
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Smooth|Vertical|#PB_Bar_NoButtons, 0)
    _set_last_parameters_(*this, #PB_GadgetType_ProgressBar, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected *this._S_widget
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *this = Bar(#PB_GadgetType_TrackBar, 0, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
    _set_last_parameters_(*this, #PB_GadgetType_TrackBar, Flag)
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar._S_widget, *this._S_widget, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    
    *this = Bar(0, 0, 0, Max, 0, Auto|Vertical|#PB_Bar_NoButtons, 0, 7)
    *this\Class = #PB_Compiler_Procedure
    
    _set_last_parameters_(*this, #PB_GadgetType_Splitter, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    With *this
      \Thumb\len = 7
      \First = First
      \Second = Second
      
      If \First
        \Type[1] = \First\Type
      EndIf
      
      If \Second
        \Type[2] = \Second\Type
      EndIf
      
      SetParent(\First, *this)
      SetParent(\Second, *this)
      
      If \Vertical
        \Cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \Cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _set_last_parameters_(*this, #PB_GadgetType_Spin, Flag) 
    
    ;Flag | Bool(Not Flag&#PB_Vertical) * (#PB_Bar_Inverted)
    
    With *this
      \X =- 1
      \Y =- 1
      
      \fs = 1
      \bs = 2
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\x[2] = 5
      
      ;\Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Not Flag&#PB_Vertical=#PB_Vertical)
      \box = AllocateStructure(_S_box)
      
      \Text\String.s[1] = Str(Min)
      \Text\Change = 1
      
      \box\arrow_size[1] = 4
      \box\arrow_size[2] = 4
      \box\arrow_type[1] =- 1 ; -1 0 1
      \box\arrow_type[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Text\Editable = 1
      
      \Color[1] = Color_Default
      \Color[2] = Color_Default
      \Color[3] = Color_Default
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      
      \box\Size[2] = 17
      
      If \Min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      ;\Page\len = 10
      \page\step = 1
      
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Image, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \Image = AllocateStructure(_S_image)
      Set_Image(*this, Image)
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Button, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      \Text\Align\Horizontal = 1
      
      \Image = AllocateStructure(_S_image)
      \image\Align\Vertical = 1
      \image\Align\Horizontal = 1
      
      SetText(*this, Text.s)
      Set_Image(*this, Image)
      
      ;       ; временно из-за этого (контейнер \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget))
      ;       If \Parent And \Parent\root\widget\anchor[1]
      ;         x+\Parent\fs
      ;         y+\Parent\fs
      ;       EndIf
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_HyperLink, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \Color\Front[1] = Color
      \Color\Front[2] = Color
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\MultiLine = 1
      \Text\x[2] = 5
      
      \Image = AllocateStructure(_S_image)
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      
      \Flag\Lines = Bool(Flag&#PB_HyperLink_Underline=#PB_HyperLink_Underline)
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Frame, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Container =- 2
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \TabHeight = 16
      
      \bs = 1
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text\String.s[1] = Text.s
      \Text\String.s = Text.s
      \Text\Change = 1
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Text, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text\x[2] = 3
      \Text\y[2] = 0
      
      Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
      
      If Bool(Flag&#PB_Text_WordWrap)
        Flag&~#PB_Text_MultiLine
        \Text\MultiLine =- 1
      EndIf
      
      If Bool(Flag&#PB_Text_MultiLine)
        Flag&~#PB_Text_WordWrap
        \Text\MultiLine = 1
      EndIf
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Combobox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ComboBox, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \index[1] =- 1
      \index[2] =- 1
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\x[2] = 5
      \Text\height = 20
      
      \Image = AllocateStructure(_S_image)
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\height = Height
      \box\width = 15
      \box\arrow_size = 4
      \box\arrow_type =- 1
      
      \index[1] =- 1
      \index[2] =- 1
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \Popup = Popup(*this, 0,0,0,0)
      OpenList(\Popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) : \Popup\Childrens()\Scroll\h\height=0
      CloseList()
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Checkbox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_CheckBox, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      \Text\x[2] = 25
      
      \Radius = 3
      \box = AllocateStructure(_S_box)
      \box\height = 15
      \box\width = 15
      \box\ThreeState = Bool(Flag&#PB_CheckBox_ThreeState=#PB_CheckBox_ThreeState)
      
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Option, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      \Text\x[2] = 25
      
      \box = AllocateStructure(_S_box)
      \box\height = 15
      \box\width = 15
      \Radius = 0
      
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_String, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Scroll = AllocateStructure(_S_scroll) 
      \Cursor = #PB_Cursor_IBeam
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text[1] = AllocateStructure(_S_text)
      \Text[2] = AllocateStructure(_S_text)
      \Text[3] = AllocateStructure(_S_text)
      \Text\Editable = 1
      \Text\x[2] = 3
      \Text\y[2] = 0
      \Text\Align\Vertical = 1
      
      \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \Text\MultiLine = (Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
      \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
      \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \Text\Pass = Bool(Flag&#PB_Text_Password)
      
      ;\Text\Align\Vertical = Bool(Not Flag&#PB_Text_Top)
      \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
      \Text\Align\Right = Bool(Flag&#PB_Text_Right)
      ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i IPAddress(X.i,Y.i,Width.i,Height.i)
    Protected Text.s="0.0.0.0", Flag.i=#PB_Text_Center
    Protected *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_IPAddress, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Scroll = AllocateStructure(_S_scroll) 
      \Cursor = #PB_Cursor_IBeam
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \Text = AllocateStructure(_S_text)
      \Text[1] = AllocateStructure(_S_text)
      \Text[2] = AllocateStructure(_S_text)
      \Text[3] = AllocateStructure(_S_text)
      \Text\Editable = 1
      \Text\x[2] = 3
      \Text\y[2] = 0
      \Text\Align\Vertical = 1
      
      \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \Text\MultiLine = (Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
      \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
      \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \Text\Pass = Bool(Flag&#PB_Text_Password)
      
      ;\Text\Align\Vertical = Bool(Not Flag&#PB_Text_Top)
      \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
      \Text\Align\Right = Bool(Flag&#PB_Text_Right)
      ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Editor(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Editor, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_IBeam
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      \Image = AllocateStructure(_S_image)
      
      
      \Text = AllocateStructure(_S_text)
      \Text[1] = AllocateStructure(_S_text)
      \Text[2] = AllocateStructure(_S_text)
      \Text[3] = AllocateStructure(_S_text)
      \Text\Editable = 1
      \Text\x[2] = 3
      \Text\y[2] = 0
      ;\Text\Align\Vertical = 1
      
      ;       \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \Text\MultiLine = 1;(Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
                         ;\Text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
      \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \Text\Pass = Bool(Flag&#PB_Text_Password)
      
      ;       ;\Text\Align\Vertical = Bool(Not Flag&#PB_Text_Top)
      ;       \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
      ;       \Text\Align\Right = Bool(Flag&#PB_Text_Right)
      ;       ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      
      \Color = Color_Default
      \Color\Fore[0] = 0
      
      \margin\width = 100;Bool(Flag&#PB_Flag_Numeric)
      \margin\Color\Back = $C8F0F0F0 ; \Color\Back[0] 
      
      \color\alpha = 255
      \Color = Color_Default
      \Color\Fore[0] = 0
      \Color\Fore[1] = 0
      \Color\Fore[2] = 0
      \Color\Back[0] = \Color\Back[1]
      \Color\Frame[0] = \Color\Frame[1]
      ;\Color\Back[1] = \Color\Back[0]
      
      
      
      If \Text\Editable
        \Color\Back[0] = $FFFFFFFF 
      Else
        \Color\Back[0] = $FFF0F0F0  
      EndIf
      
      
      \Interact = 1
      \Text\Caret[1] =- 1
      \Index[1] =- 1
      \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
      \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
      \Flag\FullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
      ;\Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12 ; Это еще будет размер чек бокса
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      
      ;\Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
      
      
      SetText(*this, "")
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;- 
  ;- Lists
  Procedure.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Tree, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      ;\Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(_S_image)
      \Text = AllocateStructure(_S_text)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListView, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      ;\Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      
      \Text = AllocateStructure(_S_text)
      If StartDrawing(CanvasOutput(\root\Canvas))
        
        \Text\height = TextHeight("A")
        
        StopDrawing()
      EndIf
      
      \sublevellen = 0
      \Flag\Lines = 0
      \flag\buttons = 0
      
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_LeftRight
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \TabHeight = 24
      
      \Image = AllocateStructure(_S_image)
      \Text = AllocateStructure(_S_text)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      
      AddColumn(*this, 0, FirstColumnTitle, FirstColumnWidth)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ExplorerList(X.i,Y.i,Width.i,Height.i, Directory.s, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ListIcon, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_LeftRight
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \TabHeight = 24
      
      \Image = AllocateStructure(_S_image)
      \Text = AllocateStructure(_S_text)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      
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
  
  Procedure.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Property, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      
      \box = AllocateStructure(_S_box)
      \Thumb\len = 7
      \box\Size[3] = 7 ; min thumb size
      SetAttribute(*this, #PB_Bar_Maximum, Width) 
      
      ;\Container = 1
      
      
      \Cursor = #PB_Cursor_LeftRight
      SetState(*this, SplitterPos)
      
      
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(_S_image)
      
      \Text = AllocateStructure(_S_text)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\Checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- Containers
  Procedure.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Panel, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] = 0
      
      \box = AllocateStructure(_S_box)
      \box\Size = 13 
      
      \box\arrow_size[1] = 6
      \box\arrow_size[2] = 6
      \box\arrow_type[1] =- 1
      \box\arrow_type[2] =- 1
      
      \box\Color[1] = Color_Default
      \box\Color[2] = Color_Default
      
      \box\color[1]\alpha = 255
      \box\color[2]\alpha = 255
      
      \Page\len = Width
      
      \TabHeight = 25
      \page\step = 10
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      OpenList(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Container, Flag) 
    
    With *this
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \color\Fore = 0
      \color\Back = $FFF6F6F6
      
      \index[1] =- 1
      \index[2] = 0
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      OpenList(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ScrollArea, Flag)
    
    With *this
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \fs = 1
      \bs = 2
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      \Scroll = AllocateStructure(_S_scroll) 
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,ScrollAreaHeight,Height, #PB_Vertical, 7, 7, *this)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *this)
      ;       Resize(\Scroll\v, #PB_Ignore,#PB_Ignore,Size,#PB_Ignore)
      ;       Resize(\Scroll\h, #PB_Ignore,#PB_Ignore,#PB_Ignore,Size)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      OpenList(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Form(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, *Widget._S_widget=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    
    *this\Class = #PB_Compiler_Procedure
    
    If *Widget 
      *this\Type = #PB_GadgetType_Window
      SetParent(*this, *Widget)
      
      If Bool(Flag & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
        ;         AddAnchors(*this)
      EndIf
    Else ;If *root
      If LastElement(*Value\OpenedList()) 
        ChangeCurrentElement(*Value\OpenedList(), Adress(Root()\widget))
        While NextElement(*Value\OpenedList())
          DeleteElement(*Value\OpenedList())
        Wend
      EndIf
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag) 
    EndIf
    
    With *this
      \X =- 1
      \Y =- 1
      \Container =- 1
      \Color = Color_Default
      \color\Fore = 0
      \color\Back = $FFF0F0F0
      \color\alpha = 255
      \Color[1]\Alpha = 128
      \Color[2]\Alpha = 128
      \Color[3]\Alpha = 128
      
      \index[1] =- 1
      \index[2] = 0
      \TabHeight = 25
      
      \Image = AllocateStructure(_S_image)
      \image\x[2] = 5 ; padding 
      
      \Text = AllocateStructure(_S_text)
      \Text\Align\Horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\Size = 12
      \box\Color = Color_Default
      \box\color\alpha = 255
      
      ;       \box\Color[1]\Alpha = 128
      ;       \box\Color[2]\Alpha = 128
      ;       \box\Color[3]\Alpha = 128
      
      
      \Flag\Window\SizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \Flag\Window\SystemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \Flag\Window\BorderLess = Bool(Flag&#PB_Window_BorderLess)
      
      \fs = 1
      \bs = 1 ;Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
      OpenList(*this)
      SetActive(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i CloseList()
    If LastElement(*Value\OpenedList())
      If *Value\OpenedList()\Type = #PB_GadgetType_Popup
        ReDraw(*Value\OpenedList())
      EndIf
      
      DeleteElement(*Value\OpenedList())
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._S_widget, Item.i=0)
    With *this
      If *this
        LastElement(*Value\OpenedList())
        If AddElement(*Value\OpenedList())
          *Value\OpenedList() = *this 
          *Value\OpenedList()\o_i = Item
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *this\Container
  EndProcedure
  
  Procedure.i Open(Window.i, X.i,Y.i,Width.i,Height.i, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, Canvas.i=-1, *this._S_root = AllocateStructure(_S_root)
    
    With *this\widget
      If Not IsWindow(Window) And Window >- 2
        w = OpenWindow(Window, X,Y,Width,Height, Text.s, Flag, WindowID) 
        If Window =- 1 
          Window = w 
        EndIf
        X = 0 
        Y = 0
      EndIf
      
      If Window <>- 2 ; IsWindow(w)
        Canvas = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
        BindGadgetEvent(Canvas, @Canvas_CallBack())
      EndIf
      
      \X =- 1
      \Y =- 1
      \root = *this
      
      If Text.s
        \Type =- 1
        \Container =- 1
        \Color = Color_Default
        \color\Fore = 0
        \color\Back = $FFF0F0F0
        \color\alpha = 255
        \Color[1]\Alpha = 128
        \Color[2]\Alpha = 128
        \Color[3]\Alpha = 128
        
        \index[1] =- 1
        \index[2] = 0
        \TabHeight = 25
        
        \Image = AllocateStructure(_S_image)
        \image\x[2] = 5 ; padding 
        
        \Text = AllocateStructure(_S_text)
        \Text\Align\Horizontal = 1
        
        \box = AllocateStructure(_S_box)
        \box\Size = 12
        \box\Color = Color_Default
        \box\color\alpha = 255
        
        \Flag\Window\SizeGadget = Bool(Flag&#PB_Window_SizeGadget)
        \Flag\Window\SystemMenu = Bool(Flag&#PB_Window_SystemMenu)
        \Flag\Window\BorderLess = Bool(Flag&#PB_Window_BorderLess)
        
        \fs = 1
        \bs = 1
        
        ; Background image
        \Image[1] = AllocateStructure(_S_image)
        
        SetText(*this, Text.s)
        SetActive(*this)
      Else
        \Type = #PB_GadgetType_Root
        \Container = #PB_GadgetType_Root
        
        \Text = AllocateStructure(_S_text) ; без него в окнах вилетает ошибка
        
        \color\alpha = 255
      EndIf
      
      Resize(*this, 0, 0, Width,Height)
      
      LastElement(*Value\OpenedList())
      If AddElement(*Value\OpenedList())
        *Value\OpenedList() = *this\widget
      EndIf
      
      Protected *adress = @*Value\OpenedList()
      
      ;AddAnchors(\root\widget)
      Root() = \root
      Root()\canvas_window = Window
      Root()\Canvas = Canvas
      Root()\widget\adress = *adress
      
      *Value\Last = Root()
      
      If IsGadget(Canvas)
        SetGadgetData(Canvas, *this)
        SetWindowData(Window, Canvas)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Create(Type.i, X.i,Y.i,Width.i,Height.i, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, ParentItem.i=0)
    Protected Result
    
    If Type = #PB_GadgetType_Window
      Result = Form(X,Y,Width,Height, Text.s, Flag, Parent)
    Else
      If Parent
        OpenList(Parent, ParentItem)
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
        If \Scroll
          If \Scroll\v
            FreeStructure(\Scroll\v) : \Scroll\v = 0
          EndIf
          If \Scroll\h
            FreeStructure(\Scroll\h)  : \Scroll\h = 0
          EndIf
          FreeStructure(\Scroll) : \Scroll = 0
        EndIf
        
        If \box : FreeStructure(\box) : \box = 0 : EndIf
        If \Text : FreeStructure(\Text) : \Text = 0 : EndIf
        If \Image : FreeStructure(\Image) : \Image = 0 : EndIf
        If \Image[1] : FreeStructure(\Image[1]) : \Image[1] = 0 : EndIf
        
        *Value\Active = 0
        *Value\Focus = 0
        
        If \Parent And ListSize(\Parent\Childrens()) : \Parent\CountItems - 1
          ChangeCurrentElement(\Parent\Childrens(), Adress(*this))
          Result = DeleteElement(\Parent\Childrens())
        EndIf
        
        ; FreeStructure(*this) 
        ClearStructure(*this, _S_widget) 
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- 
  Procedure.i From(*this._S_widget, MouseX.i, MouseY.i)
    Protected *Result._S_widget, Change.b, X.i,Y.i,Width.i,Height.i, ParentItem.i
    Static *r._S_widget
    
    If Root()\widget\Mouse\X <> MouseX
      Root()\widget\Mouse\X = MouseX
      Change = 1
    EndIf
    
    If Root()\widget\Mouse\Y <> MouseY
      Root()\widget\Mouse\Y = MouseY
      Change = 1
    EndIf
    
    If Not *this
      *this = Root() ; GetGadgetData(EventGadget())
    EndIf
    
    If Change 
      With *this
        If *this And ListSize(\Childrens()) ; \CountItems ; Not Root()\widget\Mouse\Buttons
          ParentItem = Bool(\Type = #PB_GadgetType_Panel) * \index[2]
          
          PushListPosition(\Childrens())    ;
          LastElement(\Childrens())         ; Что бы начать с последнего элемента
          Repeat                            ; Перебираем с низу верх
            X = \Childrens()\clip\X
            Y = \Childrens()\clip\Y
            Width = X+\Childrens()\clip\Width
            Height = Y+\Childrens()\clip\Height
            
            If Not \Childrens()\Hide And \Childrens()\ParentItem = ParentItem And 
               (MouseX >=  X And MouseX < Width And MouseY >=  Y And MouseY < Height)
              
              If ListSize(\Childrens()\Childrens())
                Root()\widget\Mouse\X = 0
                Root()\widget\Mouse\Y = 0
                *Result = From(\Childrens(), MouseX, MouseY)
                
                If Not *Result
                  *Result = \Childrens()
                EndIf
              Else
                *Result = \Childrens()
              EndIf
              
              Break
            EndIf
            
          Until PreviousElement(\Childrens()) = #False 
          PopListPosition(\Childrens())
        EndIf
      EndWith
      *r = *Result
    Else
      *Result = *r
    EndIf
    
    If *Result
      With *Result 
        \Mouse\X = MouseX
        \Mouse\Y = MouseY
        
        If \Scroll
          ; scrollbars events
          If \Scroll\v And Not \Scroll\v\Hide And \Scroll\v\Type And (MouseX>\Scroll\v\x And MouseX=<\Scroll\v\x+\Scroll\v\Width And  MouseY>\Scroll\v\y And MouseY=<\Scroll\v\y+\Scroll\v\Height)
            *Result = \Scroll\v
          ElseIf \Scroll\h And Not \Scroll\h\Hide And \Scroll\h\Type And (MouseX>\Scroll\h\x And MouseX=<\Scroll\h\x+\Scroll\h\Width And  MouseY>\Scroll\h\y And MouseY=<\Scroll\h\y+\Scroll\h\Height)
            *Result = \Scroll\h
          EndIf
        EndIf
        
        If \box 
          If (MouseX>\box\x[3] And MouseX=<\box\x[3]+\box\Width[3] And MouseY>\box\y[3] And MouseY=<\box\y[3]+\box\Height[3])
            \at = 3
          ElseIf (MouseX>\box\x[2] And MouseX=<\box\x[2]+\box\Width[2] And MouseY>\box\y[2] And MouseY=<\box\y[2]+\box\Height[2])
            \at = 2
          ElseIf (MouseX>\box\x[1] And MouseX=<\box\x[1]+\box\Width[1] And  MouseY>\box\y[1] And MouseY=<\box\y[1]+\box\Height[1])
            \at = 1
          ElseIf (MouseX>\box\x And MouseX=<\box\x+\box\Width And MouseY>\box\y And MouseY=<\box\y+\box\Height)
            \at = 0
          Else
            \at =- 1
          EndIf
        Else
          \at =- 1
        EndIf 
        
        If \at =- 1 And \Type <> #PB_GadgetType_Editor
          ; Columns at point
          If ListSize(\Columns())
            
            ForEach \Columns()
              If \Columns()\Drawing
                If (MouseX>=\Columns()\X And MouseX=<\Columns()\X+\Columns()\Width+1 And 
                    MouseY>=\Columns()\Y And MouseY=<\Columns()\Y+\Columns()\Height)
                  
                  \index[1] = \Columns()\index
                  Break
                Else
                  \index[1] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \Columns()\items()
                If \Columns()\items()\Drawing
                  If (MouseX>\X[2] And MouseX=<\X[2]+\Width[2] And 
                      MouseY>\Columns()\items()\Y And MouseY=<\Columns()\items()\Y+\Columns()\items()\Height)
                    \Columns()\index[1] = \Columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          ElseIf ListSize(\items())
            
            ; items at point
            ForEach \items()
              If \items()\Drawing
                If (MouseX>\items()\X And MouseX=<\items()\X+\items()\Width And 
                    MouseY>\items()\Y And MouseY=<\items()\Y+\items()\Height)
                  
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
        If \Parent And 
           \Parent\Scroll 
          Select *this 
            Case \Parent\Scroll\v, 
                 \Parent\Scroll\h 
              *this = \Parent
          EndSelect
        EndIf
        
        If \Mouse\Buttons And EventType = #PB_EventType_MouseMove
          If \at = 0 Or (\root\widget\anchor And Not \Container)
            ;Events_Anchors(*this, Root()\widget\Mouse\x, Root()\widget\Mouse\y)
            Resize(*this, Root()\widget\Mouse\x-\Mouse\Delta\x, Root()\widget\Mouse\y-\Mouse\Delta\y, #PB_Ignore, #PB_Ignore)
            Result = 1
          EndIf
        EndIf
        
        
        If EventType = #PB_EventType_MouseEnter
          ;  Debug "enter "
        EndIf
        
        ;         If Not Root()\widget\Mouse\Buttons
        ;           Select EventType
        ;             Case #PB_EventType_MouseEnter
        ;               
        ;               If \at=-1
        ;                 If \Leave
        ;                   Debug "en "+\Type+" "+\Cursor[1]+" "+\Leave\Cursor
        ;                   \Cursor[1] = \Leave\Cursor
        ;                 Else
        ;                   \Cursor[1] = Get_Cursor(*this)
        ;                   Debug " en "+\Type+" "+\Cursor[1]
        ;                 EndIf
        ;                 
        ;                 Set_Cursor(*this, \Cursor)
        ;               EndIf
        ;               
        ;             Case #PB_EventType_MouseLeave
        ;               If \Text
        ;                 Debug "le "+\Type+" "+\Text\String
        ;               Else
        ;                 Debug "le "+\Type
        ;               EndIf
        ;               Set_Cursor(*this, \Cursor[1])
        ;               
        ;           EndSelect
        ;         EndIf
        
        *Value\This = *this
        \Event = EventType
        
        If *this And *this <> \root\widget And \root\widget\Drag And DD::CallBack(*this, EventType, \Mouse\x , \Mouse\y)
          Event_Widgets(DD::Object, DD::Event, \index[2], EventData)
        EndIf
        
        ; PostEvent(#PB_Event_Widget, \root\widget\Window, \root\widget\Parent, EventType, EventData)
        If \Function[1] And 
           CallCFunctionFast(\Function[1], *this, EventType, EventItem, EventData)
          Result = 1
        ElseIf \Function[2] And 
               CallCFunctionFast(\Window\Function[1], *this, EventType, EventItem, EventData)
          Result = 1
        ElseIf \Function[3] And 
               CallCFunctionFast(\root\widget\Function[1], *this, EventType, EventItem, EventData)
          Result = 1
        EndIf
        
        ;         Send(*this, EventType, EventItem, EventData)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*this._S_widget, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *this > 0
      
      ;       *Value\Type = EventType
      ;       *Value\This = *this
      
      With *this
        Protected canvas = \root\Canvas
        Protected window = \root\Canvas_window
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1 : Repaint | Event_Widgets(*this, EventType, at, \Deactive)
            
          Case #PB_EventType_LostFocus : Repaint = 1 : Repaint | Event_Widgets(*this, EventType, at)
            
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0  : Repaint | Event_Widgets(*this, EventType, at)
            ;             Debug "events() LeftButtonUp "+\Type +" "+ at +" "+ *this
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \Type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                  Repaint = ScrollPos(*this, (MouseScreenY-\Thumb\len/2))
                Else
                  Repaint = ScrollPos(*this, (MouseScreenX-\Thumb\len/2))
                EndIf
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ;             Debug "events() LeftClick "+\Type +" "+ at +" "+ *this
            Select \Type
              Case #PB_GadgetType_Button,
                   #PB_GadgetType_Tree, 
                   #PB_GadgetType_ListView, 
                   #PB_GadgetType_ListIcon
                
                If Not \root\widget\Drag
                  Repaint | Event_Widgets(*this, EventType, \index[1])
                EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonDown : Repaint | Event_Widgets(*this, EventType, at)
            ;             Debug "events() LeftButtonDown "+\Type +" "+ at +" "+ *this
            Select \Type 
              Case #PB_GadgetType_Window
                If at = 1
                  Free(*this)
                  
                  If *this = \root\widget
                    PostEvent(#PB_Event_CloseWindow, \root\Canvas_window, *this)
                  EndIf
                EndIf
                
              Case #PB_GadgetType_ComboBox
                \box\Checked ! 1
                
                If \box\Checked
                  Display_Popup(*this, \Popup)
                Else
                  HideWindow(\Popup\root\Canvas_window, 1)
                EndIf
                
              Case #PB_GadgetType_Option
                Repaint = SetState(*this, 1)
                
              Case #PB_GadgetType_CheckBox
                Repaint = SetState(*this, Bool(\box\Checked=#PB_Checkbox_Checked) ! 1)
                
              Case #PB_GadgetType_Tree,
                   #PB_GadgetType_ListView
                Repaint = Set_State(*this, \Items(), \index[1]) 
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\Columns(), 0)
                  Repaint = Set_State(*this, \Columns()\items(), \Columns()\index[1]) 
                EndIf
                
              Case #PB_GadgetType_HyperLink
                If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                
              Case #PB_GadgetType_Panel
                Select at
                  Case 1 : \Page\Pos = PagePos(*this, (\Page\Pos - \page\step)) : Repaint = 1
                  Case 2 : \Page\Pos = PagePos(*this, (\Page\Pos + \page\step)) : Repaint = 1
                  Default
                    If \index[1] >= 0
                      Repaint = SetState(*this, \index[1])
                    EndIf
                EndSelect
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin, #PB_GadgetType_Splitter
                Select at
                  Case 1 : Repaint = SetState(*this, (\Page\Pos - \page\step)) ; Up button
                  Case 2 : Repaint = SetState(*this, (\Page\Pos + \page\step)) ; Down button
                  Case 3                                                  ; Thumb button
                    If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                      delta = MouseScreenY - \Thumb\Pos
                    Else
                      delta = MouseScreenX - \Thumb\Pos
                    EndIf
                EndSelect
                
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                Repaint = ScrollPos(*this, (MouseScreenY-delta))
              Else
                Repaint = ScrollPos(*this, (MouseScreenX-delta))
              EndIf
            Else
              If lastat <> at
                If lastat > 0 
                  If lastat<4
                    \Color[lastat]\State = 0
                  EndIf
                  
                EndIf
                
                If \Max And ((at = 1 And _scroll_in_start_(*this)) Or (at = 2 And _scroll_in_stop_(*this)))
                  \Color[at]\State = 0
                  
                ElseIf at>0 
                  
                  If at<4
                    \Color[at]\State = 1
                    \Color[at]\Alpha = 255
                  EndIf
                  
                ElseIf at =- 1
                  \Color[1]\State = 0
                  \Color[2]\State = 0
                  \Color[3]\State = 0
                  
                  \Color[1]\Alpha = 128
                  \Color[2]\Alpha = 128
                  \Color[3]\Alpha = 128
                EndIf
                
                Repaint = #True
                lastat = at
              EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \page\step = 1
                  Repaint + ((\Max-\Min) / 100)
                Else
                  Repaint + \page\step
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \page\step = 1
                  Repaint - ((\Max-\Min) / 100)
                Else
                  Repaint - \page\step
                EndIf
              EndIf
              
              Repaint = SetState(*this, (\Page\Pos + Repaint))
            EndIf  
            
          Case #PB_EventType_MouseEnter
            ;             If Not Root()\widget\Mouse\Buttons And IsGadget(canvas)
            ;               \Cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \Cursor)
            ;               ;             Debug "events() MouseEnter " +" "+ at +" "+ *this;+\Type +" "+ \Cursor[1]  +" "+ \Cursor
            ;             EndIf
            
          Case #PB_EventType_MouseLeave
            ;             If Not Root()\widget\Mouse\Buttons And IsGadget(canvas)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
            ;               ;             Debug "events() MouseLeave " +" "+ at +" "+ *this;+\Type +" "+ \Cursor[1]  +" "+ \Cursor
            ;             EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            
            \Color\State = 0
            If at>0 And at<4
              \Color[at]\State = 0
            EndIf
            
            If \Type <> #PB_GadgetType_Panel 
              If ListSize(\Columns())
                SelectElement(\Columns(), 0)
              EndIf
              ForEach \items()
                If \items()\State = 1
                  \items()\State = 0
                EndIf
              Next
              \index[1] =- 1
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            
            If EventType = #PB_EventType_MouseEnter
              If \Type = #PB_GadgetType_ScrollBar
                If \Parent And \Parent\Scroll And 
                   (\Parent\Scroll\v = *this Or *this = \Parent\Scroll\h)
                  
                  If ListSize(\Parent\Columns())
                    SelectElement(\Parent\Columns(), 0)
                  EndIf
                  ForEach \Parent\items()
                    If \Parent\items()\State = 1
                      \Parent\items()\State = 0
                    EndIf
                  Next
                  \Parent\index[1] =- 1
                  
                EndIf
              EndIf
            EndIf
            
            Select \Type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \Color\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              Case #PB_GadgetType_Window
              Default
                
                If at>0 And at<4 And EventType<>#PB_EventType_MouseEnter
                  \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
                EndIf
            EndSelect
        EndSelect
        
        If \Text And \Text[1] And \Text[2] And \Text[3] And \Text\Editable
          Select \Type
            Case #PB_GadgetType_String
              Repaint | String_Editable(*this, EventType, MouseScreenX.i, MouseScreenY.i)
              
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
    If *Value\Last <> _this_
      If *Value\Last<>Root()\widget
        
        ;           If *Value\Last = Parent
        ;             Debug "leave first"
        ;           Else
        ;             Debug "enter Parent"
        ;           EndIf
        
        repaint = 1
      EndIf
      
      If *Value\Last And *Value\Last <> Parent And *Value\Last <> Window And *Value\Last <> Root()\widget 
        If *Value\Last\Mouse\Buttons
          ;             Debug "selected out"
        Else
          Event_Widgets(*Value\Last, #PB_EventType_MouseLeave, *Value\Last\at)
          Events(*Value\Last, *Value\Last\at, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
        EndIf
      EndIf
      
      If _this_
        If (Not *Value\Last Or (*Value\Last And *Value\Last\Parent <> _this_))
          ;             If Not *Value\Last
          ;               Debug "enter first"
          ;             EndIf
          ;             
          ;             If (*Value\Last And *Value\Last\Parent <> _this_)
          ;               Debug "leave parent"
          ;             EndIf
          
          If _this_\Mouse\Buttons
            ;               Debug "selected ower"
          Else
            Event_Widgets(_this_, #PB_EventType_MouseEnter, _this_\at)
            Events(_this_, _this_\at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
          EndIf
        EndIf
        
        _this_\Leave = *Value\Last
        *Value\Last = _this_
      Else
        Root()\widget\Leave = *Value\Last
        *Value\Last = Root()\widget
      EndIf
    EndIf
    
  EndMacro
  
  Procedure.i CallBack(*this._S_widget, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected repaint.i, Parent.i, Window.i, Canvas = EventGadget()
    ;Static lastat.i, Down.i, *Lastat._S_widget, *Last._S_widget, *mouseat._S_widget
    
    ; ProcedureReturn Editor_CallBack(*this, EventType.i)
    
    With *this
      If Not Bool(*this And *this\root\widget)
        ProcedureReturn
      EndIf
      
      Window = \Window 
      Parent = \Parent 
      Canvas = \root\Canvas
      
      If Not MouseScreenX
        MouseScreenX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      EndIf
      If Not MouseScreenY
        MouseScreenY= GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
      EndIf
      
      ; anchors events
      If CallBack_Anchors(*this, EventType, \Mouse\Buttons, MouseScreenX,MouseScreenY)
        ProcedureReturn 1
      EndIf
      
      ; Enter/Leave mouse events
      _mouse_pos_(*this)
      
      Select EventType 
        Case #PB_EventType_MouseMove,
             #PB_EventType_MouseEnter, 
             #PB_EventType_MouseLeave
          
          If Root()\widget\Mouse\Buttons
            ; Drag start
            If Root()\widget\Mouse\Delta And
               Not (Root()\widget\Mouse\x>Root()\widget\Mouse\Delta\x-1 And 
                    Root()\widget\Mouse\x<Root()\widget\Mouse\Delta\x+1 And 
                    Root()\widget\Mouse\y>Root()\widget\Mouse\Delta\y-1 And
                    Root()\widget\Mouse\y<Root()\widget\Mouse\Delta\y+1)
              
              If Not Root()\widget\Drag : Root()\widget\Drag = 1
                Event_Widgets(*this, #PB_EventType_DragStart, \index[2])
              EndIf
            EndIf
            
            If *Value\Focus 
              repaint | Event_Widgets(*Value\Focus, #PB_EventType_MouseMove, *Value\Focus\at)
              repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_MouseMove, MouseScreenX, MouseScreenY)
            EndIf  
            
          ElseIf *this And *this = *Value\Last
            repaint | Event_Widgets(*this, #PB_EventType_MouseMove, \at)
            repaint | Events(*this, \at, #PB_EventType_MouseMove, MouseScreenX, MouseScreenY)
            repaint = 1 ; нужен для итемов при проведении мыши чтобы виделялся
          EndIf
          
        Case #PB_EventType_LeftButtonDown, #PB_EventType_MiddleButtonDown, #PB_EventType_RightButtonDown 
          Root()\widget\Mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                 (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                 (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          
          If EventType <> #PB_EventType_MiddleButtonDown
            ; Drag & Drop
            Root()\widget\Mouse\Delta = AllocateStructure(_S_mouse)
            Root()\widget\Mouse\Delta\X = Root()\widget\Mouse\x
            Root()\widget\Mouse\Delta\Y = Root()\widget\Mouse\y
            
            If *this And *this = *Value\Last
              \Mouse\Delta = AllocateStructure(_S_mouse)
              \Mouse\Delta\X = Root()\widget\Mouse\x-\x[3]
              \Mouse\Delta\Y = Root()\widget\Mouse\y-\y[3]
              \Mouse\Buttons = Root()\widget\Mouse\buttons
              
              \State = 2 
              SetForeground(*this)
              
              If \Deactive
                If \Deactive <> *this
                  repaint | Events(\Deactive, \Deactive\at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
                EndIf
                
                repaint | Events(*this, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
                \Deactive = 0
              EndIf
              
              repaint | Events(*this, \at, EventType, MouseScreenX, MouseScreenY)
              repaint = 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp,
             #PB_EventType_RightButtonUp 
          
          If EventType <> #PB_EventType_MiddleButtonDown
            If *Value\Focus And
               *Value\Focus\State = 2 
              *Value\Focus\State = 1 
              
              repaint | Events(*Value\Focus, *Value\Focus\at, EventType, MouseScreenX, MouseScreenY)
              
              If Bool(MouseScreenX>=*Value\Focus\Clip\X And MouseScreenX<*Value\Focus\Clip\X+*Value\Focus\Clip\Width And 
                      MouseScreenY>*Value\Focus\Clip\Y And MouseScreenY=<*Value\Focus\Clip\Y+*Value\Focus\Clip\Height) 
                
                If *Value\Focus = *this       
                  If EventType = #PB_EventType_LeftButtonUp
                    ;  repaint | Event_Widgets(*Value\Focus, #PB_EventType_LeftClick, *Value\Focus\at)
                    repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_LeftClick, MouseScreenX, MouseScreenY)
                  EndIf
                  If EventType = #PB_EventType_RightClick
                    ;  repaint | Event_Widgets(*Value\Focus, #PB_EventType_RightClick, *Value\Focus\at)
                    repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_RightClick, MouseScreenX, MouseScreenY)
                  EndIf
                EndIf
                
              Else
                *Value\Focus\State = 0
                repaint | Event_Widgets(*Value\Focus, #PB_EventType_MouseLeave, *Value\Focus\at)
                repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
              EndIf
              
              *Value\Focus\Mouse\Buttons = 0   
              If *Value\Focus\Mouse\Delta
                FreeStructure(*Value\Focus\Mouse\Delta)
                *Value\Focus\Mouse\Delta = 0
                *Value\Focus\Drag = 0
              EndIf
              
              repaint = 1
            EndIf
            
            ; Drag & Drop
            Root()\widget\Mouse\Buttons = 0
            If Root()\widget\Mouse\Delta
              FreeStructure(Root()\widget\Mouse\Delta)
              Root()\widget\Mouse\Delta = 0
              Root()\widget\Drag = 0
            EndIf
          EndIf
          
          ; active widget key state
        Case #PB_EventType_Input, 
             #PB_EventType_KeyDown, 
             #PB_EventType_KeyUp
          
          If *this And (*Value\Focus = *this Or *this = *Value\Active)
            
            \Keyboard\Input = GetGadgetAttribute(Canvas, #PB_Canvas_Input)
            \Keyboard\Key = GetGadgetAttribute(Canvas, #PB_Canvas_Key)
            \Keyboard\Key[1] = GetGadgetAttribute(Canvas, #PB_Canvas_Modifiers)
            
            repaint | Events(*this, 0, EventType, MouseScreenX, MouseScreenY)
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
      ; create widgets
      If Not *root\create
        *root\create = 1
      EndIf
      
      ReDraw(*root)
    EndIf
  EndProcedure
  
  Procedure.i Canvas_CallBack()
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
Macro GetActiveWidget()
  Widget::*Value\Focus
EndMacro

Macro EventWidget()
  Widget::*Value\This
EndMacro

Macro WidgetEvent()
  EventWidget()\Event
EndMacro

; Macro EventGadget()
;   (Bool(Event()<>Widget::#PB_Event_Widget) * Widget::PB(EventGadget)() + Bool(Event()=Widget::#PB_Event_Widget) * Widget::Root()\widget\Canvas)
; EndMacro

DeclareModule Helper
  Declare.i Image(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i=0)
EndDeclareModule

Module Helper
  
  Procedure.i Image(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i=0)
    Protected *Window.Widget::_S_widget = Widget::Form(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i)
    
  EndProcedure
EndModule




;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  ;
  ; ------------------------------------------------------------
  ;
  ;   PureBasic - Drag & Drop
  ;
  ;    (c) Fantaisie Software
  ;
  ; ------------------------------------------------------------
  ;
  
  #Window = 0
  
  Enumeration    ; Images
    #ImageSource
    #ImageTarget
  EndEnumeration
  
  Global SourceText,
         SourceImage,
         SourceFiles,
         SourcePrivate,
         TargetText,
         TargetImage,
         TargetFiles,
         TargetPrivate1,
         TargetPrivate2
  
  
  Procedure Events(EventGadget, EventType, EventItem, EventData)
    Protected i, Text$, Files$, Count
    
    ; DragStart event on the source s, initiate a drag & drop
    ;
    Select EventType
      Case #PB_EventType_DragStart
        
        Select EventGadget
            
          Case SourceText
            Text$ = GetItemText(SourceText, GetState(SourceText))
            DragText(Text$)
            
          Case SourceImage
            DragImage((#ImageSource))
            
          Case SourceFiles
            Files$ = ""       
            For i = 0 To CountItems(SourceFiles)-1
              If GetItemState(SourceFiles, i) & #PB_Explorer_Selected
                Files$ + GetText(SourceFiles) + GetItemText(SourceFiles, i) + Chr(10)
              EndIf
            Next i 
            If Files$ <> ""
              DragFiles(Files$)
            EndIf
            
            ; "Private" Drags only work within the program, everything else
            ; also works with other applications (Explorer, Word, etc)
            ;
          Case SourcePrivate
            If GetState(SourcePrivate) = 0
              DragPrivate(1)
            Else
              DragPrivate(2)
            EndIf
            
        EndSelect
        
        ; Drop event on the target gadgets, receive the dropped data
        ;
      Case #PB_EventType_Drop
        
        Select EventGadget
            
          Case TargetText
            AddItem(TargetText, -1, DropText())
            
          Case TargetImage
            If DropImage(#ImageTarget)
              SetState(TargetImage, (#ImageTarget))
            EndIf
            
          Case TargetFiles
            Files$ = EventDropFiles()
            Count  = CountString(Files$, Chr(10)) + 1
            For i = 1 To Count
              AddItem(TargetFiles, -1, StringField(Files$, i, Chr(10)))
            Next i
            
          Case TargetPrivate1
            AddItem(TargetPrivate1, -1, "Private type 1 dropped")
            
          Case TargetPrivate2
            AddItem(TargetPrivate2, -1, "Private type 2 dropped")
            
        EndSelect
        
    EndSelect
    
  EndProcedure
  
  If OpenWindow(#Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    Open(#Window, 0, 0, 760, 310)
    
    ; create some images for the image demonstration
    ; 
    Define i, Event
    CreateImage(#ImageSource, 136, 136)
    If StartDrawing(ImageOutput(#ImageSource))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drag this image", $000000, $FFFFFF)        
      For i = 45 To 1 Step -1
        Circle(70, 80, i, Random($FFFFFF))
      Next i        
      
      StopDrawing()
    EndIf  
    
    CreateImage(#ImageTarget, 136, 136)
    If StartDrawing(ImageOutput(#ImageTarget))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drop images here", $000000, $FFFFFF)
      StopDrawing()
    EndIf  
    
    
    ; create and fill the source s
    ;
    SourceText = ListIcon(10, 10, 140, 140, "Drag Text here", 130)   
    SourceImage = Image(160, 10, 140, 140, (#ImageSource), #PB_Image_Border) 
    SourceFiles = ExplorerList(310, 10, 290, 140, GetHomeDirectory(), #PB_Explorer_MultiSelect)
    SourcePrivate = ListIcon(610, 10, 140, 140, "Drag private stuff here", 260)
    
    AddItem(SourceText, -1, "hello world")
    AddItem(SourceText, -1, "The quick brown fox jumped over the lazy dog")
    AddItem(SourceText, -1, "abcdefg")
    AddItem(SourceText, -1, "123456789")
    
    AddItem(SourcePrivate, -1, "Private type 1")
    AddItem(SourcePrivate, -1, "Private type 2")
    
    
    ; create the target s
    ;
    TargetText = ListIcon(10, 160, 140, 140, "Drop Text here", 130)
    TargetImage = Image(160, 160, 140, 140, (#ImageTarget), #PB_Image_Border) 
    TargetFiles = ListIcon(310, 160, 140, 140, "Drop Files here", 130)
    TargetPrivate1 = ListIcon(460, 160, 140, 140, "Drop Private Type 1 here", 130)
    TargetPrivate2 = ListIcon(610, 160, 140, 140, "Drop Private Type 2 here", 130)
    
    
    ; Now enable the dropping on the target s
    ;
    EnableDrop(TargetText,     #PB_Drop_Text,    #PB_Drag_Copy)
    EnableDrop(TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy)
    EnableDrop(TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy)
    EnableDrop(TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1)
    EnableDrop(TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2)
    
    Bind(@Events())
    ReDraw(Root()\widget)
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  End
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---------f--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP