;-\\  WINDOWS
XIncludeFile "../cursors.pbi"

Module Cursor 
   #test_cursor = 0
   #SM_CXCURSOR = 13
   #SM_CYCURSOR = 14 
   
   CompilerIf #PB_Compiler_Version =< 546
    #CURSOR_SHOWING = 1
    
    Macro DesktopResolutionX( )
      (GetDeviceCaps_(GetDC_(0),#LOGPIXELSX) / 96)
    EndMacro
    Macro DesktopResolutionY( )
      (GetDeviceCaps_(GetDC_(0),#LOGPIXELSY) / 96)
    EndMacro
    Macro DesktopScaledX( _x_ )
      (_x_ * DesktopResolutionX( ))
    EndMacro
    Macro DesktopScaledY( _y_ )
      (_y_ * DesktopResolutionY( ))
    EndMacro
    Macro DesktopUnscaledX( _x_ )
      ( _x_ / DesktopResolutionX( ))
    EndMacro
    Macro DesktopUnscaledY( _y_ )
      (_y_ / DesktopResolutionY( ))
    EndMacro
    
  CompilerEndIf
  
  
  Procedure   Proc(hWnd, uMsg, wParam, lParam)
    Protected result
    Protected oldproc = GetProp_(hWnd, "#__oldproc_cursor")
    
    Select uMsg
      Case #WM_DESTROY
        Debug "event( DESTROY ) "+hwnd
        ;       Case #WM_NCDESTROY
        ;         Debug "event( NC_DESTROY ) "+hwnd
        RemoveProp_(hwnd, "#__cursor")
        RemoveProp_(hwnd, "#__oldproc_cursor")
        
      Case #WM_SETCURSOR
        ; Debug " -  #WM_SETCURSOR "+wParam +" "+ lParam +" "+ Mouse::Gadget(Mouse::Window( ))
        Cursor::Change( wParam, 1 )
        
      Default
        result = CallWindowProc_(oldproc, hWnd, uMsg, wParam, lParam)
    EndSelect
    
    ProcedureReturn result
  EndProcedure
  
  Global NewMap images.i( )
  
  ;-\\
  Procedure   Draw( Type.a )
    Protected Image
    Protected X = 0
    Protected Y = 0
    Protected size = (16)
    Protected Width = (size)
    Protected Height = (size)
    Protected fcolor = $ffFFFFFF
    Protected bcolor = $ff000000
    
    ; https://rusproject.narod.ru/winapi/g/getsystemmetrics.html
;     Width = GetSystemMetrics_( #SM_CXCURSOR )
;     Height = GetSystemMetrics_( #SM_CYCURSOR )
    
    ;\\
    Image = CreateImage(#PB_Any, Width, Height, 32, #PB_Image_Transparent)
    
    ;\\
    If StartDrawing(ImageOutput(Image))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(0,0,OutputWidth( ),OutputHeight( ), $A9B7B6)
      
      If Type = #__cursor_Arrows
        Box(6,6,4,4, fcolor)
        DrawImageCursorUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorDown(0,7,Height, bcolor, fcolor )
        ;         
        DrawImageCursorLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorRight(7,0,Width, bcolor, fcolor )
        Box(7,7,2,2, bcolor)
      EndIf
      
      ;\\
      If Type = #__cursor_LeftUp Or
         Type = #__cursor_RightDown Or
         Type = #__cursor_Diagonal1 
         DrawImageCursorDiagonal1(0,0, size, bcolor, fcolor )
      EndIf
      If Type = #__cursor_LeftDown Or
         Type = #__cursor_RightUp Or
         Type = #__cursor_Diagonal2 
        DrawImageCursorDiagonal2(0,0, size, bcolor, fcolor )
      EndIf
      
      ;\\
      If Type = #__cursor_SplitUp
        DrawImageUp(0,0,Height, bcolor, fcolor )
        DrawImageCursorSplitUp(0,0,Height, bcolor, fcolor )
        Plot(0, 8, fcolor ) : Line(1, 8, Width-2, 1, bcolor) : Plot(Width-1, 8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        Line(0, 9, Width , 1, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      EndIf
      If Type = #__cursor_UpDown
        DrawImageCursorUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorDown(0,5,Height, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitUpDown
        DrawImageCursorSplitUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorSplitDown(0,5,Height, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitDown
        Line(0, 0, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        Plot(0, 1, fcolor ) : Line(1, 1, Width-2, 1, bcolor) : Plot(Width-1, 1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        DrawImageCursorSplitDown(0,0,Height, bcolor, fcolor )
        DrawImageDown(0,0,Height, bcolor, fcolor )
      EndIf
      
      ;\\
      If Type = #__cursor_SplitLeft
        DrawImageLeft(0,0,Width, bcolor, fcolor )
        DrawImageCursorSplitLeft(0,0,Width, bcolor, fcolor )
        Plot(8, 0, fcolor ) : Line(8, 1, 1, Height-2, bcolor) : Plot(8, Height-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        Line(9, 0, 1, Height, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      EndIf
      If Type = #__cursor_LeftRight
        X = 6
        Y = 8
        DrawImageCursorLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorRight(5,0,Width, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitLeftRight
        DrawImageCursorSplitLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorSplitRight(5,0,Width, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitRight
        Line(0, 0, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        Plot(1, 0, fcolor ) : Line(1, 1, 1, Width-2, bcolor) : Plot(1, Width-1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        DrawImageCursorSplitRight(0,0,Width, bcolor, fcolor )
        DrawImageRight(0,0,Width, bcolor, fcolor )
      EndIf
      
      StopDrawing( )
    EndIf
    
    ;\\ https://www.purebasic.fr/english/viewtopic.php?t=78093
;     Define dimensions.bitmap,icon.iconinfo
;     If Not GetObject_(Image,SizeOf(dimensions),@dimensions)
;        GetIconInfo_(Image,icon)
;        GetObject_(icon\hbmMask,SizeOf(dimensions),@dimensions)
;     EndIf
; GetIconInfo_(hIcon, iconinfo.ICONINFO)
; GetObject_(iconinfo\hbmMask, SizeOf(BITMAP), bitmap.BITMAP)
; 
; Width = bitmap\bmWidth
; Height = bitmap\bmHeight
    
    If DesktopScaledX(Width) <> GetSystemMetrics_( #SM_CXCURSOR ) And 
       DesktopScaledY(Height) <> GetSystemMetrics_( #SM_CYCURSOR) 
       If DesktopResolutionX( ) = 2.0 And DesktopResolutionY( ) = 2.0
          Width = 32                  ;GetSystemMetrics_( #SM_CXCURSOR )
          Height = 32                 ;GetSystemMetrics_( #SM_CYCURSOR )
          ResizeImage(Image, Width, Height, #PB_Image_Raw )
       EndIf
    EndIf
    
    If Type = #__cursor_Arrows Or
       Type = #__cursor_UpDown Or
       Type = #__cursor_LeftRight Or
       Type = #__cursor_SplitUpDown Or
       Type = #__cursor_SplitLeftRight 
       X = Width/2
       Y = Height/2
    EndIf
      
      ;\\
    If Type = #__cursor_LeftDown Or
       Type = #__cursor_LeftUp Or
       Type = #__cursor_RightDown Or
       Type = #__cursor_RightUp Or
       Type = #__cursor_Diagonal1 Or
       Type = #__cursor_Diagonal2 
       X = Width/2 - 1
       Y = Height/2 - 1
    EndIf
      
    ;\\
    If Type = #__cursor_SplitUp  
       X = Width/2 
       Y = Height/2 - 1
    EndIf
    If Type = #__cursor_SplitDown 
       X = Width/2 
       Y = 1
    EndIf
    If Type = #__cursor_SplitLeft 
       X = Width/2 - 1
       Y = Height/2
    EndIf
    If Type = #__cursor_SplitRight
       X = 1
       Y = Height/2
    EndIf
      
    ProcedureReturn Create( ImageID( Image ), X, Y )
  EndProcedure
  
  Procedure   Image( Type.a = 0 )
    Protected Image
    
    If Type = #__cursor_Drop
      Image = CatchImage( #PB_Any, ?add, 601 )
    ElseIf Type = #__cursor_Drag
      Image = CatchImage( #PB_Any, ?copy, 530 )
    EndIf
    
    If DesktopResolutionX( ) = 2.0 And DesktopResolutionY( ) = 2.0
      ResizeImage(Image, DesktopScaledY(ImageWidth(Image)), DesktopScaledY(ImageHeight(Image)), #PB_Image_Raw )
    EndIf
    
    DataSection
      add: ; memory_size - ( 601 )
      Data.q $0A1A0A0D474E5089, $524448490D000000, $1A00000017000000, $0FBDF60000000408, $4D416704000000F5, $61FC0B8FB1000041,
             $5248632000000005, $800000267A00004D, $80000000FA000084, $EA000030750000E8, $170000983A000060, $0000003C51BA9C70,
             $87FF0044474B6202, $7009000000BFCC8F, $00C8000000735948, $ADE7FA6300C80000, $454D497407000000, $450A0F0B1308E307,
             $63100000000C6AC0, $0020000000764E61, $0002000000200000, $000C8D7E6F010000, $3854414449300100, $1051034ABB528DCB,
             $58DB084146C5293D, $82361609B441886C, $AA4910922C455E92, $C2C105F996362274, $FC2FF417B0504FC2, $DEF7BB3BB9ACF1A0,
             $B99CE66596067119, $2DB03A16C1101E67, $12D0B4D87B0D0B8F, $11607145542B450C, $190D04A4766FDCAA, $4129428FD14DCD04,
             $98F0D525AEFE8865, $A1C4924AD95B44D0, $26A2499413E13040, $F4F9F612B8726298, $62A6ED92C07D5B54, $E13897C2BE814222,
             $A75C5C6365448A6C, $D792BBFAE41D2925, $1A790C0B8161DC2F, $224D78F4C611BD60, $A1E8C72566AB9F6F, $2023A32BDB05D21B,
             $0E3BC7FEBAF316E4, $8E25C73B08CF01B1, $385C7629FEB45FBE, $8BB5746D80621D9F, $9A5AC7132FE2EC2B, $956786C4AE73CBF3,
             $FE99E13C707BB5EB, $C2EA47199109BF48, $01FE0FA33F4D71EF, $EE0F55B370F8C437, $F12CD29C356ED20C, $CBC4BD4A70C833B1,
             $FFCD97200103FC1C, $742500000019D443, $3A65746164745845, $3200657461657263, $312D38302D393130, $3A35313A31315439,
             $30303A30302B3930, $25000000B3ACC875, $6574616474584574, $00796669646F6D3A, $2D38302D39313032, $35313A3131543931,
             $303A30302B35303A, $0000007B7E35C330, $6042AE444E454900
      Data.b $82
      add_end:
      ;     EndDataSection
      ;
      ;     DataSection
      copy: ; memory_size - ( 530 )
      Data.q $0A1A0A0D474E5089, $524448490D000000, $1A00000010000000, $1461140000000408, $4D4167040000008C, $61FC0B8FB1000041,
             $5248632000000005, $800000267A00004D, $80000000FA000084, $EA000030750000E8, $170000983A000060, $0000003C51BA9C70,
             $87FF0044474B6202, $7009000000BFCC8F, $00C8000000735948, $ADE7FA6300C80000, $454D497407000000, $450A0F0B1308E307,
             $63100000000C6AC0, $0020000000764E61, $0002000000200000, $000C8D7E6F010000, $2854414449E90000, $1040C20A31D27DCF,
             $8B08226C529FD005, $961623685304458D, $05E8A288B1157A4A, $785858208E413C44, $AD03C2DE8803C505, $74CCDD93664D9893,
             $5C25206CCCECC7D9, $0AF51740A487B038, $E4950624ACF41B10, $0B03925602882A0F, $504520607448C0E1, $714E75682A0F7A22,
             $1EC4707FBC91940F, $EF1F26F801E80C33, $6FE840E84635C148, $47D13D78D54EC071, $5BDF86398A726F4D, $7DD0539F268C6356,
             $39B40B3759101A3E, $2EEB2D02D7DBC170, $49172CA44A415AD2, $52B82E69FF1E0AC0, $CC0D0D97E9B7299E, $046FA509CA4B09C0,
             $CB03993630382B86, $5E4840261A49AA98, $D3951E21331B30CF, $262C1B127F8F8BD3, $250000007DB05216, $6574616474584574,
             $006574616572633A, $2D38302D39313032, $35313A3131543931, $303A30302B37303A, $000000EED7F72530, $7461647458457425,
             $796669646F6D3A65, $38302D3931303200, $313A31315439312D, $3A30302B35303A35, $00007B7E35C33030, $42AE444E45490000
      Data.b $60, $82
      copy_end:
    EndDataSection
    
    
    ;   DataSection
    ;     cross:
    ;     ;IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/cross.png"
    ;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/cross1.png"
    ;     cross_end:
    ;     
    ;     hand:
    ;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand2.png"
    ;     hand_end:
    ;     
    ;     move:
    ;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand1.png"
    ;     move_end:
    ;     
    ;   EndDataSection
    
    ProcedureReturn Image
  EndProcedure
  
  Procedure New( Type.a, ImageID.i )
    If Not FindMapElement(images( ), Str(Type))
      AddMapElement(images( ), Str(Type))
      images( ) = ImageID
    EndIf
    
    ProcedureReturn ImageID
  EndProcedure
  
  Procedure   Free( *cursor ) 
    ;Debug "cursor-free "+*cursor
    
    If *cursor >= 0 And *cursor <= 255
      If FindMapElement(images( ), Str(*cursor))
        DeleteMapElement(images( ));, Str(*cursor))
      EndIf
    Else
      If MapSize(images( ))
        ForEach images( )
          If *cursor = images( )
            DeleteMapElement(images( ))
            Break 
          EndIf
        Next
      EndIf
      ProcedureReturn DestroyCursor_( *cursor )
    EndIf
  EndProcedure
  
  Procedure   isHiden( )
    Protected cursor_info.CURSORINFO 
    cursor_info\cbSize = SizeOf(CURSORINFO)
    GetCursorInfo_(@cursor_info)
    ProcedureReturn Bool(cursor_info\flags & #CURSOR_SHOWING)
  EndProcedure
  
  Procedure   Hide(state.b)
    ProcedureReturn ShowCursor_(state)
  EndProcedure
  
  Procedure   Clip( X.l,Y.l,Width.l,Height.l )
    Protected rect.RECT
    ;GetWindowRect_(GadgetID,rect.RECT)
    SetRect_(rect,X,Y,X+Width,Y+Height)
    ProcedureReturn ClipCursor_(rect)
  EndProcedure
  
  Procedure.i Create(ImageID.i, X.l = 0, Y.l = 0)
    Protected *create_icon, cursor_info.ICONINFO
    cursor_info\fIcon = 0
    cursor_info\xHotspot = X 
    cursor_info\yHotspot = Y 
    cursor_info\hbmMask = ImageID
    cursor_info\hbmColor = ImageID
    *create_icon = CreateIconIndirect_( @cursor_info ) 
    If Not *create_icon : *create_icon = ImageID : EndIf
    ProcedureReturn *create_icon
  EndProcedure
  
  Procedure   Change( GadgetID.i, state.b )
    Protected result, *cursor._s_cursor = GetProp_(GadgetID, "#__cursor")
    If *cursor And
       *cursor\hcursor
      
      ;\\ reset
      If state = 0 
        ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, LoadCursor_(0,#IDC_ARROW) )
        result = SetCursor_( LoadCursor_(0,#IDC_ARROW) )
      EndIf
      
      ;\\ set
      ; If *cursor\hcursor <> GetCursor_( )
      If state > 0
        If *cursor\hcursor =- 1
          If GetCursor_( )
            result = SetCursor_( #NUL )
          Else
            result = *cursor\hcursor
          EndIf
        Else
          ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, *cursor\hcursor )
          ; SetClassLongPtr_( GadgetID( gadget ), #GCL_HCURSOR, *cursor\hcursor )
          result = SetCursor_( *cursor\hcursor )
        EndIf
      EndIf
      
      If result <> *cursor\hcursor
        CompilerIf #test_cursor
          Debug " :: changeCursor "+ state +" "+ GadgetID +" "+ result +" "+ *cursor\hcursor
        CompilerEndIf
      EndIf
      ; EndIf
    EndIf
  EndProcedure
  
  Procedure   Set( Gadget.i, *cursor )
    Protected *memory._s_cursor
    
    With *memory
      If IsGadget( Gadget )
        Protected GadgetID = GadgetID( Gadget )
        CompilerIf #test_cursor
          Debug " :: setCursor "+ GadgetType( Gadget ) +" "+ *cursor ; +" "+ GadgetID +"="+ mouse::Gadget( ID::GetWindowID(GadgetID) ) +" mousebuttonsstate-"+ CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
        CompilerEndIf
        
        *memory = GetProp_( GadgetID, "#__cursor" )
        
        If Not *memory
          *memory = AllocateStructure( _s_cursor )
          \windowID = ID::GetWindowID( GadgetID )
          SetProp_( GadgetID, "#__cursor", *memory ) 
          SetProp_( GadgetID, "#__oldproc_cursor", SetWindowLongPtr_(GadgetID, #GWL_WNDPROC, @Proc( )))
        EndIf
        
        If \type <> *cursor
          If \hcursor > 0
            Select \type
              Case #__cursor_Drag, #__cursor_Drop,
                   #__cursor_SplitUpDown, #__cursor_SplitUp, #__cursor_SplitDown,
                   #__cursor_SplitLeftRight, #__cursor_SplitLeft, #__cursor_SplitRight
                cursor::Free( \hcursor )
            EndSelect
          EndIf
          \type = *cursor
          
          ;\\
          If *cursor > 255
            \hcursor = *cursor 
          Else
            Select *cursor
              Case #__cursor_Invisible : \hcursor =- 1
              Case #__cursor_Busy      : \hcursor = LoadCursor_(0,#IDC_WAIT)
                
              Case #__cursor_Default   : \hcursor = LoadCursor_(0,#IDC_ARROW)
              Case #__cursor_IBeam     : \hcursor = LoadCursor_(0,#IDC_IBEAM)
              Case #__cursor_Denied    : \hcursor = LoadCursor_(0,#IDC_NO)
                
              Case #__cursor_Hand      : \hcursor = LoadCursor_(0,#IDC_HAND)
              Case #__cursor_Cross     : \hcursor = LoadCursor_(0,#IDC_CROSS)
              Case #__cursor_Arrows    : \hcursor = LoadCursor_(0,#IDC_SIZEALL)
                
              Case #__cursor_UpDown    : \hcursor = LoadCursor_(0,#IDC_SIZENS)
              Case #__cursor_LeftRight : \hcursor = LoadCursor_(0,#IDC_SIZEWE)
                
              Case #__cursor_Diagonal1,
                   #__cursor_LeftUp,
                   #__cursor_RightDown 
                \hcursor = LoadCursor_(0,#IDC_SIZENWSE)
                
              Case #__cursor_Diagonal2,
                   #__cursor_RightUp,
                   #__cursor_LeftDown 
                \hcursor = LoadCursor_(0,#IDC_SIZENESW)
                
                ;\\  custom cursors
              Case #__cursor_SplitUpDown, #__cursor_SplitUp, #__cursor_SplitDown,
                   #__cursor_SplitLeftRight, #__cursor_SplitLeft, #__cursor_SplitRight
                
                \hcursor = New( *cursor, Draw( *cursor ) )
                
              Case #__cursor_Drag : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
              Case #__cursor_Drop : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                
              Case #__cursor_Grab      : \hcursor = LoadCursor_(0,#IDC_ARROW)
              Case #__cursor_Grabbing  : \hcursor = LoadCursor_(0,#IDC_ARROW)
                
            EndSelect 
          EndIf
        EndIf
        
        If \hcursor And 
           GadgetID = mouse::Gadget( \windowID )
          cursor::Change( GadgetID, 1 )
          ProcedureReturn #True
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure   Get( )
    Protected result.i
    Protected cursor_info.CURSORINFO 
    cursor_info\cbSize = SizeOf(CURSORINFO)
    GetCursorInfo_(@cursor_info)
    
    If cursor_info\flags & #CURSOR_SHOWING
      Select cursor_info\hCursor ; GetCursor_( )
        Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Default
        Case LoadCursor_(0,#IDC_IBEAM) : result = #__cursor_IBeam
        Case LoadCursor_(0,#IDC_NO) : result = #__cursor_Denied
          
        Case LoadCursor_(0,#IDC_HAND) : result = #__cursor_Hand
        Case LoadCursor_(0,#IDC_CROSS) : result = #__cursor_Cross
        Case LoadCursor_(0,#IDC_SIZEALL) : result = #__cursor_Arrows
          
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitUp
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitDown
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitUpDown
          
        Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitLeft
        Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitRight
        Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitLeftRight
          
        Case LoadCursor_(0,#IDC_SIZENESW) : result = #__cursor_Diagonal2
        Case LoadCursor_(0,#IDC_SIZENWSE) : result = #__cursor_Diagonal1
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Drop
        Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Drag
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Grab
        Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Grabbing
      EndSelect 
    Else
      result = #__cursor_Invisible
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule   
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 77
; FirstLine = 68
; Folding = ------------
; Optimizer
; EnableXP
; DPIAware