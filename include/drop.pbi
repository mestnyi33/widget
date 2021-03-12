CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  #path = "/media/sf_as/Documents/GitHub/widget"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  #path = "Z:/Documents/GitHub/widget"
  ;#path "C:\Users\as\Desktop\Widget_15_08_2020"
CompilerEndIf

IncludePath #path

CompilerIf Not Defined( fix, #PB_Module )
  ; fix all pb bug's
  XIncludeFile "include/fix.pbi"
CompilerEndIf

CompilerIf Not Defined( func, #PB_Module )
  XIncludeFile "include/func.pbi"
CompilerEndIf

CompilerIf Not Defined( constants, #PB_Module )
  XIncludeFile "include/constants.pbi"
CompilerEndIf

CompilerIf Not Defined( structures, #PB_Module )
  XIncludeFile "include/structures.pbi"
CompilerEndIf

CompilerIf Not Defined( colors, #PB_Module )
  XIncludeFile "include/colors.pbi"
CompilerEndIf

CompilerIf Not Defined( widget, #PB_Module )
  ;-  >>>
  DeclareModule widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    CompilerIf Defined( fix, #PB_Module )
      UseModule fix
    CompilerEndIf
    
    
    Macro EventDropX( ): DD_DropX( ): EndMacro
    Macro EventDropY( ): DD_DropY( ): EndMacro
    Macro EventDropType( ): DD_DropType( ): EndMacro
    Macro EventDropAction( ): DD_DropAction( ): EndMacro
    Macro EventDropPrivate( ): DD_DropPrivate( ): EndMacro
    Macro EventDropFiles( ): DD_DropFiles( ): EndMacro
    Macro EventDropText( ): DD_DropText( ): EndMacro
    Macro EventDropImage( Image = -1, Depth = 24 ): DD_DropImage( Image, Depth ): EndMacro
    
    Macro DragItem( Row, Actions = #PB_Drag_Copy ): DD_DragItem( Row, Actions ): EndMacro
    Macro DragText( Text, Actions = #PB_Drag_Copy ): DD_DragText( Text, Actions ): EndMacro
    Macro DragImage( Image, Actions = #PB_Drag_Copy ): DD_DragImage( Image, Actions ): EndMacro
    Macro DragFiles( Files, Actions = #PB_Drag_Copy ): DD_DragFiles( Files, Actions ): EndMacro
    Macro DragPrivate( PrivateType, Actions = #PB_Drag_Copy ): DD_DragPrivate( PrivateType, Actions ): EndMacro
    
    Macro EnableDrop( Widget, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Widget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableGadgetDrop( Gadget, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Gadget, Format, Actions, PrivateType ) : EndMacro
    Macro EnableWindowDrop( Window, Format, Actions, PrivateType = 0 ) : DD_DropEnable( Window, Format, Actions, PrivateType ) : EndMacro
    
    Declare.s DD_DropFiles( )
    Declare.s DD_DropText( )
    Declare.i DD_DropType( )
    Declare.i DD_DropAction( )
    Declare.i DD_DropImage( Image.i = -1, Depth.i = 24 )
    
    Declare.i DD_DragText( Text.S, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragImage( Image.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragPrivate( Type.i, Actions.i = #PB_Drag_Copy )
    Declare.i DD_DragFiles( Files.s, Actions.i = #PB_Drag_Copy )
    
    Declare.i DD_DropEnable( *this, Format.i, Actions.i, PrivateType.i = 0 )
    
    
    ;-
    Macro allocate( _struct_name_, _struct_type_= )
       _s_#_struct_name_#_struct_type_ = AllocateStructure( _s_#_struct_name_ )
    EndMacro
    
    
  EndDeclareModule
  
  Module widget
 ;-
    #PB_Drop_Item =- 5
    #PB_Cursor_Drag = 50
    #PB_Cursor_Drop = 51
    
    Global *drop._s_DD
    Global *drag.allocate( DD ) 
    Global NewMap *droped._s_DD( )
    
    Macro _DD_drop_( )
      ;EnterWidget( )\drop
       *drop
    EndMacro
    
    Macro _DD_drag_( )
      *drag
    EndMacro
      
    Macro _DD_action_( )
      Bool( _DD_drop_( ) And _DD_drag_( ) And 
            _DD_drop_( )\PrivateType = _DD_drag_( )\PrivateType And 
            _DD_drop_( )\format = _DD_drag_( )\format And 
            _DD_drop_( )\actions & _DD_drag_( )\actions )
    EndMacro
    
    Macro _DD_event_enter_( _result_, _this_ )
      If _DD_drag_( ) 
        ; _DD_drop_( ) = _this_\drop
        
        If FindMapElement( *droped( ), Hex( _this_ ) )
          _DD_drop_( ) = *droped( )
        Else
          _DD_drop_( ) = #Null
        EndIf
        
        If _this_\_state & #__s_dropped = #False
          _this_\_state | #__s_dropped
          
          If _DD_action_( )
            DD_cursor( #PB_Cursor_Drop )
          Else
            DD_cursor( #PB_Cursor_Drag )
          EndIf
          
          _result_ = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _DD_event_leave_( _result_, _this_ )
      If _this_\_state & #__s_dropped
        _this_\_state &~ #__s_dropped
        
        If _DD_drag_( ) 
          DD_cursor( #PB_Cursor_Drag )
          _result_ = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _DD_event_drag_( _result_, _this_ )
      If _DD_drag_( )
        DD_cursor( #PB_Cursor_Drag )
        _result_ = #True
      EndIf
    EndMacro
    
    Macro _DD_event_drop_( _result_, _this_, _mouse_x_, _mouse_y_ )
      If _DD_drag_( )
        ;; DD_cursor( #PB_Cursor_Default )
        If _is_root_( _this_ ) 
          SetCursor( _this_, #PB_Cursor_Default )
        Else
          SetCursor( _this_, _this_\cursor )
        EndIf
              
        If _DD_action_( )
          _DD_drop_( )\x = _mouse_x_
          _DD_drop_( )\y = _mouse_y_
          ;                 _DD_drop_( )\value = _DD_drag_( )\value
          ;                 _DD_drop_( )\string = _DD_drag_( )\string
          DoEvents( _this_, #__event_Drop, _mouse_x_, _mouse_y_ )
        EndIf
        
        ; reset
        FreeStructure( _DD_drag_( ) ) : _DD_drag_( ) = #Null
        _DD_event_leave_( _result_, _this_ )
        
        If _result_
          _get_entered_( _result_ )
          ;EventHandler( )
        EndIf 
      EndIf
    EndMacro
    
    ;
    Procedure.i DD_cursor( *this._s_widget, type )
      Protected x = 2, y = 2, cursor
      UsePNGImageDecoder( )
      
      If type = #PB_Cursor_Drop
        cursor = CatchImage( #PB_Any, ?add, 601 )
      ElseIf type = #PB_Cursor_Drag
        cursor = CatchImage( #PB_Any, ?copy, 530 )
      EndIf
      
      ;SetCursor( EnterWidget( )\root, ImageID( cursor ) )
      If cursor
        If *this\root\cursor <> cursor
          *this\root\cursor = cursor
          SetGadgetAttribute( *this\root\canvas\gadget, #PB_Canvas_CustomCursor, func::cursor( ImageID( cursor ), x, y ) )
        EndIf
      EndIf
      
      DataSection
        add: ; memory_size - ( 601 )
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
        copy: ; memory_size - ( 530 )
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
    
    Procedure   DD_draw( *this._s_widget )
;       ; if you drag to the widget-dropped
;       If _DD_drag_( ) And *this\_state & #__s_dropped
;         
;         DrawingMode( #PB_2DDrawing_Default | #PB_2DDrawing_AlphaBlend )
;         
;         If _DD_drop_( ) ; *this\drop 
;           If _DD_action_( )
;             If EnterRow( ) And EnterRow( )\_state & #__s_entered
;               Box( EnterRow( )\x, EnterRow( )\y, EnterRow( )\width, EnterRow( )\height, $2000ff00 )
;             EndIf  
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $1000ff00 )
;           Else
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff0000 )
;           EndIf
;         Else
;           If *this\_state & #__s_dragged 
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $10ff00ff )
;           Else
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $100000ff )
;           EndIf
;         EndIf
;         
;         DrawingMode( #PB_2DDrawing_Outlined )
;         
;         If _DD_drop_( ) ; *this\drop 
;           If _DD_action_( )
;             If EnterRow( ) And EnterRow( )\_state & #__s_entered
;               Box( EnterRow( )\x, EnterRow( )\y, EnterRow( )\width, EnterRow( )\height, $ff00ff00 )
;             EndIf
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff00ff00 )
;           Else
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff0000 )
;           EndIf
;         Else
;           If *this\_state & #__s_dragged 
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ffff00ff )
;           Else
;             Box( *this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], $ff0000ff )
;           EndIf
;         EndIf
;       EndIf
      
    EndProcedure
    
    Procedure.i DD_DragItem( *row, Actions.i = #PB_Drag_Copy )
      Debug "  drag Item - " + *row
      
      If *row
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Item
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\value = *row
      EndIf
    EndProcedure
    
    Procedure.i DD_DragText( Text.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag text - " + Text
      
      If Text
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Text
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\string = Text
      EndIf
    EndProcedure
    
    Procedure.i DD_DragImage( Image.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag image - " + Image
      
      If IsImage( Image )
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Image
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\value = ImageID( Image )
        _DD_drag_( )\width = ImageWidth( Image )
        _DD_drag_( )\height = ImageHeight( Image )
      EndIf
    EndProcedure
    
    Procedure.i DD_DragFiles( Files.s, Actions.i = #PB_Drag_Copy )
      Debug "  drag files - " + Files
      
      If Files
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Files
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\string = Files
      EndIf
    EndProcedure
    
    Procedure.i DD_DragPrivate( PrivateType.i, Actions.i = #PB_Drag_Copy )
      Debug "  drag private - " + PrivateType
      
      If PrivateType
        _DD_drag_( ).allocate( DD )
        _DD_drag_( )\format = #PB_Drop_Private
        _DD_drag_( )\actions = Actions
        _DD_drag_( )\PrivateType = PrivateType
      EndIf
    EndProcedure
    
    
    Procedure.l DD_DropX( )
      ProcedureReturn _DD_drop_( )\x
    EndProcedure
    
    Procedure.l DD_DropY( )
      ProcedureReturn _DD_drop_( )\y
    EndProcedure
    
    Procedure.i DD_DropType( )
      If _DD_action_( ) 
        ProcedureReturn _DD_drop_( )\Format 
      EndIf
    EndProcedure
    
    Procedure.i DD_DropAction( )
      If _DD_action_( ) 
        ProcedureReturn _DD_drop_( )\Actions 
      EndIf
    EndProcedure
    
    Procedure.s DD_DropFiles( )
      If _DD_action_( )
        Debug "   event drop files - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.s DD_DropText( )
      If _DD_action_( )
        Debug "   event drop text - "+_DD_drag_( )\string
        ProcedureReturn _DD_drag_( )\string
      EndIf
    EndProcedure
    
    Procedure.i DD_DropPrivate( )
      If _DD_action_( )
        Debug "   event drop type - "+_DD_drag_( )\PrivateType
        ProcedureReturn _DD_drag_( )\PrivateType
      EndIf
    EndProcedure
    
    Procedure.i DD_DropImage( Image.i = -1, Depth.i = 24 )
      Protected result.i
      
      If _DD_action_( ) And _DD_drag_( )\value
        Debug "   event drop image - "+_DD_drag_( )\value
        
        If Image  = - 1
          Result = CreateImage( #PB_Any, _DD_drag_( )\Width, _DD_drag_( )\Height ) : Image = Result
        Else
          Result = IsImage( Image )
        EndIf
        
        If Result And StartDrawing( ImageOutput( Image ) )
          If Depth = 32
            DrawAlphaImage( _DD_drag_( )\value, 0, 0 )
          Else
            DrawImage( _DD_drag_( )\value, 0, 0 )
          EndIf
          StopDrawing( )
        EndIf  
        
        ProcedureReturn Result
      EndIf
    EndProcedure
    
    Procedure.i DD_DropEnable( *this._s_widget, Format.i, Actions.i, PrivateType.i = 0 )
      ;                  ; windows ;    macos   ; linux ;
      ; = Format
      ; #PB_Drop_Text    ; = 1     ; 1413830740 ; -1    ; Accept text on this widget
      ; #PB_Drop_Image   ; = 8     ; 1346978644 ; -2    ; Accept images on this widget
      ; #PB_Drop_Files   ; = 15    ; 1751544608 ; -3    ; Accept filenames on this widget
      ; #PB_Drop_Private ; = 512   ; 1885499492 ; -4    ; Accept a "private" Drag & Drop on this gadgetProtected Result.i
      
      ; & Actions
      ; #PB_Drag_None    ; = 0     ; 0          ; 0     ; The Data format will Not be accepted on the widget
      ; #PB_Drag_Copy    ; = 1     ; 1          ; 2     ; The Data can be copied
      ; #PB_Drag_Move    ; = 2     ; 16         ; 4     ; The Data can be moved
      ; #PB_Drag_Link    ; = 4     ; 2          ; 8     ; The Data can be linked
      
      ; SetDragCallback( )
      ; 'State' specifies the current state of the Drag & Drop operation and is one of the following values:
      ; #PB_Drag_Enter         ; = 1     ; 1          ; 1     ; The mouse entered the gadget Or window
      ; #PB_Drag_Update        ; = 2     ; 2          ; 2     ; The mouse was moved inside the gadget Or window, Or the intended action changed
      ; #PB_Drag_Leave         ; = 3     ; 3          ; 3     : The mouse left the gadget Or window (Format, Action, x, y are 0 here)
      ; #PB_Drag_Finish        ; = 4     ; 4          ; 4     : The Drag & Drop finished
      ;     
      
      If Not FindMapElement( *droped( ), Hex( *this ) )
        Debug "Enable dropped - " + *this
        AddMapElement( *droped( ), Hex( *this ) )
        *droped.allocate( DD, ( ) )
      EndIf
      
      *droped( )\format = Format
      *droped( )\actions = Actions
      *droped( )\PrivateType = PrivateType
;        
;       If Not *this\drop
;         Debug "Enable dropped - " + *this
;         *this\drop.allocate( DD )
;       EndIf
;       
;       *this\drop\format = Format
;       *this\drop\actions = Actions
;       *this\drop\PrivateType = PrivateType
    EndProcedure
    EndModule
  ;- <<< 
CompilerEndIf


;- 
Macro Uselib( _name_ )
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro

;UseLib( widget )

;XIncludeFile "gadgets.pbi" : UseModule gadget

CompilerIf Not Defined( PB_EventType_Drop, #PB_Constant )
  #PB_EventType_Drop = #PB_EventType_FirstCustomValue 
CompilerEndIf


#Window = 0

Enumeration   1 ; Images
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

Global i, Event, font = LoadFont( 0, "Aria", 13 )

Procedure Events( )
  Protected EventGadget.i = EventGadget( ),
            EventType.i = EventType( ),
            ;EventItem.i = GetGadgetState( EventGadget ), 
            EventData.i = EventData( )
  
  Protected i, Text$, Files$, Count
  
  ; DragStart event on the source s, initiate a drag & drop
  ;
  Select EventType
    Case #PB_EventType_DragStart
      Debug  "Drag - " + EventGadget
      
      Select EventGadget
          
        Case SourceText
          Text$ = GetGadgetItemText( SourceText, GetGadgetState( SourceText ) )
          DragText( Text$ )
          
        Case SourceImage
          DragImage( ImageID( #ImageSource ) )
          
        Case SourceFiles
          Files$ = ""       
          For i = 0 To CountGadgetItems( SourceFiles )-1
            If GetGadgetItemState( SourceFiles, i ) & #PB_Explorer_Selected
              ;; i = GetState( SourceFiles )
              Files$ + GetGadgetText( SourceFiles ) + GetGadgetItemText( SourceFiles, i ) ; + Chr( 10 )
            EndIf
          Next i 
          
          If Files$ <> ""
            DragFiles( Files$ )
          EndIf
          
          ; "Private" Drags only work within the program, everything else
          ; also works with other applications ( Explorer, Word, etc )
          ;
        Case SourcePrivate
          If GetGadgetState( SourcePrivate ) = 0
            DragPrivate( 1 )
          Else
            DragPrivate( 2 )
          EndIf
          
      EndSelect
      
      ; Drop event on the target gadgets, receive the EventDrop data
      ;
    Case #PB_EventType_Drop
      Debug  "Drop - " + EventGadget
      
      Select EventGadget
          
        Case TargetText
          ;;Debug "EventDropText - "+ EventDropText( )
          If GetGadgetState( TargetText ) >= 0
            AddGadgetItem( TargetText, GetGadgetState( TargetText ), EventDropText( ) )
          Else
            AddGadgetItem( TargetText, - 1, EventDropText( ) )
          EndIf
          
        Case TargetImage
          If EventDropImage( #ImageTarget )
            If StartDrawing( ImageOutput( #ImageTarget ) )
              DrawingFont( font )
              
              Box( 5,5,OutputWidth(),30, $FFFFFF)
              DrawText( 5, 5, "EventDrop image", $000000, $FFFFFF )        
              
              StopDrawing( )
            EndIf  
            
            SetGadgetState( TargetImage, ImageID( #ImageTarget ) )
          EndIf
          
        Case TargetFiles
          Files$ = EventDropFiles( )
          Count  = CountString( Files$, Chr( 10 ) ) + 1
          
          For i = 1 To Count
            AddGadgetItem( TargetFiles, -1, StringField( Files$, i, Chr( 10 ) ) )
          Next i
          
        Case TargetPrivate1
          AddGadgetItem( TargetPrivate1, -1, "Private type 1 EventDrop" )
          
        Case TargetPrivate2
          AddGadgetItem( TargetPrivate2, -1, "Private type 2 EventDrop" )
          
      EndSelect
      
  EndSelect
  
EndProcedure

If OpenWindow( #Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered )       
  ;
  ; Create some images for the image demonstration
  ; 
  CreateImage( #ImageSource, 136, 136 )
  If StartDrawing( ImageOutput( #ImageSource ) )
    DrawingFont( font )
    
    Box( 0, 0, 136, 136, $FFFFFF )
    DrawText( 5, 5, "Drag this image", $000000, $FFFFFF )        
    For i = 45 To 1 Step -1
      Circle( 70, 80, i, Random( $FFFFFF ) )
    Next i        
    
    StopDrawing( )
  EndIf  
  
  CreateImage( #ImageTarget, 136, 136 )
  If StartDrawing( ImageOutput( #ImageTarget ) )
    DrawingFont( font )
    
    Box( 0, 0, 136, 136, $FFFFFF )
    DrawText( 5, 5, "Drop images here", $000000, $FFFFFF )
    StopDrawing( )
  EndIf  
  
  ; Create and fill the source s
  ;
  SourceText = ListIconGadget(#PB_Any, 10, 10, 140, 140, "Drag Text here", 130 )   
  SourceImage = ImageGadget(#PB_Any, 160, 10, 140, 140, ImageID( #ImageSource ), #PB_Image_Border ) 
  SourceFiles = ExplorerListGadget(#PB_Any, 310, 10, 290, 140, GetHomeDirectory( ), #PB_Explorer_MultiSelect )
  SourcePrivate = ListIconGadget(#PB_Any, 610, 10, 140, 140, "Drag private stuff here", 260 )
  
  AddGadgetItem( SourceText, -1, "hello world" )
  AddGadgetItem( SourceText, -1, "The quick brown fox jumped over the lazy dog" )
  AddGadgetItem( SourceText, -1, "abcdefg" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  
  AddGadgetItem( SourcePrivate, -1, "Private type 1" )
  AddGadgetItem( SourcePrivate, -1, "Private type 2" )
  
  ; Create the target s
  ;
  TargetText = ListIconGadget(#PB_Any, 10, 160, 140, 140, "Drop Text here", 130 )
  TargetImage = ImageGadget(#PB_Any, 160, 160, 140, 140, ImageID( #ImageTarget ), #PB_Image_Border ) 
  TargetFiles = ListIconGadget(#PB_Any, 310, 160, 140, 140, "Drop Files here", 130 )
  TargetPrivate1 = ListIconGadget(#PB_Any, 460, 160, 140, 140, "Drop Private Type 1 here", 130 )
  TargetPrivate2 = ListIconGadget(#PB_Any, 610, 160, 140, 140, "Drop Private Type 2 here", 130 )
  
;   AddGadgetItem( TargetText, -1, "hello world" )
;   AddGadgetItem( TargetText, -1, "The quick brown fox jumped over the lazy dog" )
;   AddGadgetItem( TargetText, -1, "abcdefg" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
  
  ; Now enable the dropping on the target s
  ;
  EnableGadgetDrop( TargetText,     #PB_Drop_Text,    #PB_Drag_Copy )
  EnableGadgetDrop( TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy )
  EnableGadgetDrop( TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy )
  EnableGadgetDrop( TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1 )
  EnableGadgetDrop( TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2 )
  
  ; Bind( -1, @Events( ) )
  
  BindGadgetEvent( SourceImage, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetImage, @Events( ), #PB_EventType_Drop )
  
  BindGadgetEvent( SourceText, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetText, @Events( ), #PB_EventType_Drop )
  
  BindGadgetEvent( SourcePrivate, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetPrivate1, @Events( ), #PB_EventType_Drop )
  BindGadgetEvent( TargetPrivate2, @Events( ), #PB_EventType_Drop )
  
  ;ReDraw( Root( ) )
  
  Repeat
    Event = WaitWindowEvent( )
    
    If event = #PB_Event_GadgetDrop
      PostEvent( #PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Drop, EventData( ) )
      
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = A8----8----4---
; EnableXP